From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 28/33] libmultipath: coalesce_paths: trigger
	uevent if nothing done
Date: Tue, 28 Feb 2017 17:23:24 +0100
Message-ID: <20170228162329.14517-29-mwilck@suse.com>
References: <20170228162329.14517-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170228162329.14517-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Martin Wilck <mwilck@suse.de>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.de>

The previous patches skip RELOAD actions if there's nothing
to be done. I found a corner case where this may lead to imporperly
initialized device nodes (in my case a by-label link hadn't been
reset to the partition on the multipath device by udev).
Triggering an extra "change" event on the device fixes
this situation.

Signed-off-by: Martin Wilck <mwilck@suse.de>
---
 libmultipath/configure.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 025947a8..d9554553 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -411,6 +411,18 @@ get_udev_for_mpp(const struct multipath *mpp)
 	return udd;
 }
 
+static void
+trigger_udev_change(const struct multipath *mpp)
+{
+	static const char change[] = "change";
+	struct udev_device *udd = get_udev_for_mpp(mpp);
+	if (!udd)
+		return;
+	condlog(3, "triggering %s uevent for %s", change, mpp->alias);
+	sysfs_attr_set_value(udd, "uevent", change, sizeof(change)-1);
+	udev_device_unref(udd);
+}
+
 static int
 is_mpp_known_to_udev(const struct multipath *mpp)
 {
@@ -949,6 +961,18 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 		if (r == DOMAP_DRY)
 			continue;
 
+		if (r == DOMAP_EXIST && mpp->action == ACT_NOTHING &&
+		    force_reload == FORCE_RELOAD_WEAK)
+			/*
+			 * First time we're called, and no changes applied.
+			 * domap() was a noop. But we can't be sure that
+			 * udev has already finished setting up this device
+			 * (udev in initrd may have been shut down while
+			 * processing this device or its children).
+			 * Trigger a change event, just in case.
+			 */
+			trigger_udev_change(find_mp_by_wwid(curmp, mpp->wwid));
+
 		conf = get_multipath_config();
 		allow_queueing = conf->allow_queueing;
 		put_multipath_config(conf);
-- 
2.11.0
