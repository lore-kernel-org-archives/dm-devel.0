From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 06/22] libmultipath: trigger path uevent only
	when necessary
Date: Fri, 13 Apr 2018 23:59:59 +0200
Message-ID: <20180413220015.7032-7-mwilck@suse.com>
References: <20180413220015.7032-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180413220015.7032-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Paths that are already classified as DM_MULTIPATH_DEVICE_PATH don't
need to be retriggered.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index c56e972f..2cae9240 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -458,8 +458,20 @@ trigger_paths_udev_change(const struct multipath *mpp)
 		if (!pgp->paths)
 			continue;
 		vector_foreach_slot(pgp->paths, pp, j) {
+			const char *env;
+
 			if (!pp->udev)
 				continue;
+			/*
+			 * Paths that are already classified as multipath
+			 * members don't need another uevent.
+			 */
+			env = udev_device_get_property_value(
+				pp->udev, "DM_MULTIPATH_DEVICE_PATH");
+			if (env != NULL && !strcmp(env, "1"))
+				continue;
+
+			condlog(4, "triggering change uevent for %s", pp->dev);
 			sysfs_attr_set_value(pp->udev, "uevent", "change",
 					     strlen("change"));
 		}
-- 
2.16.1
