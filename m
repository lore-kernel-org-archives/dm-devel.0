From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 5/5] libmultipath: force udev reloads
Date: Mon, 24 Apr 2017 17:39:30 -0500
Message-ID: <1493073570-17167-6-git-send-email-bmarzins@redhat.com>
References: <1493073570-17167-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1493073570-17167-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Now that the multipath udev rules try harder to not do lvm scans or
kpartx runs unnecessarily, multipath needs to make sure that these do
run when they are wanted.  This patch makes sure that when a device is
force reloaded, or changes size, the MPATH_UDEV_RELOAD_FLAG isn't set.
This allows lvm scanning and kpartx runs to happen on these uevents.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c | 7 ++++++-
 libmultipath/devmapper.c | 3 ++-
 libmultipath/structs.h   | 1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index b29a660..bd090d9 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -499,8 +499,10 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 				cmpp->alias, mpp->alias);
 			strncpy(mpp->alias_old, cmpp->alias, WWID_SIZE - 1);
 			mpp->action = ACT_RENAME;
-			if (force_reload)
+			if (force_reload) {
+				mpp->force_udev_reload = 1;
 				mpp->action = ACT_FORCERENAME;
+			}
 			return;
 		}
 		mpp->action = ACT_CREATE;
@@ -538,12 +540,14 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 		return;
 	}
 	if (force_reload) {
+		mpp->force_udev_reload = 1;
 		mpp->action = ACT_RELOAD;
 		condlog(3, "%s: set ACT_RELOAD (forced by user)",
 			mpp->alias);
 		return;
 	}
 	if (cmpp->size != mpp->size) {
+		mpp->force_udev_reload = 1;
 		mpp->action = ACT_RESIZE;
 		condlog(3, "%s: set ACT_RESIZE (size change)",
 			mpp->alias);
@@ -797,6 +801,7 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 		 * DM_DEVICE_CREATE, DM_DEVICE_RENAME, or DM_DEVICE_RELOAD
 		 * succeeded
 		 */
+		mpp->force_udev_reload = 0;
 		if (mpp->action == ACT_CREATE)
 			remember_wwid(mpp->wwid);
 		if (!is_daemon) {
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index c7602cb..d73ba1a 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -372,7 +372,8 @@ int dm_addmap_create (struct multipath *mpp, char * params)
 int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
 {
 	int r = 0;
-	uint16_t udev_flags = (flush ? 0 : MPATH_UDEV_RELOAD_FLAG) |
+	uint16_t udev_flags = ((mpp->force_udev_reload)?
+			       0 : MPATH_UDEV_RELOAD_FLAG) |
 			      ((mpp->skip_kpartx == SKIP_KPARTX_ON)?
 			       MPATH_UDEV_NO_KPARTX_FLAG : 0) |
 			      ((mpp->nr_active)? 0 : MPATH_UDEV_NO_PATHS_FLAG);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 98e13e4..01e031a 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -272,6 +272,7 @@ struct multipath {
 	int skip_kpartx;
 	int max_sectors_kb;
 	int force_readonly;
+	int force_udev_reload;
 	unsigned int dev_loss;
 	uid_t uid;
 	gid_t gid;
-- 
1.8.3.1
