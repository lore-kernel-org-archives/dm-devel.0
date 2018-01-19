From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 16/16] libmultipath: trigger path uevent only
	when necessary
Date: Fri, 19 Jan 2018 01:29:16 +0100
Message-ID: <20180119002916.10323-17-mwilck@suse.com>
References: <20180119002916.10323-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180119002916.10323-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Paths that are already classified as DM_MULTIPATH_DEVICE_PATH don't
need to be retriggered. As an exception, trigger events for paths in
"maybe" state that are waiting to be updated.
---
 libmultipath/configure.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index c08ea5b8decc..f8d1fa452014 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -447,8 +447,28 @@ trigger_paths_udev_change(const struct multipath *mpp)
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
+			if (env != NULL && !strcmp(env, "1")) {
+				/*
+				 * Nonempty DM_MULTIPATH_SAVED_FS_TYPE means
+				 * path is in "maybe" state and timer is running
+				 * Send uevent now (see multipath.rules).
+				 */
+				env = udev_device_get_property_value(
+					pp->udev, "DM_MULTIPATH_SAVED_FS_TYPE");
+				if (env == NULL)
+					continue;
+			}
+			condlog(4, "triggering change uevent for %s", pp->dev);
 			sysfs_attr_set_value(pp->udev, "uevent", "change",
 					     strlen("change"));
 		}
-- 
2.15.1
