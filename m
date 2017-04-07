From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 7/9] multipathd: allow devices to switch from RW
	to RO
Date: Fri,  7 Apr 2017 01:16:36 -0500
Message-ID: <1491545798-22183-8-git-send-email-bmarzins@redhat.com>
References: <1491545798-22183-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1491545798-22183-1-git-send-email-bmarzins@redhat.com>
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

Whenever multipathd tries to reload a device, even if it's because a
path switched from read/write to read-only, it tries to load the device
read/write first, and then falls back to read-only. When device-mapper
sees that multipath is using the same devices in the same state in its
new table, it simply reuses the devices from the old table, instead of
closing and re-opening them. This means that multipath can successfully
reload the multipath device read/write, even if a path device has
switched to read-only.  To deal with this, multipathd now doesn't try to
reload a device read/write when it sees that a path device has switched
to read-only.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 9 +++++----
 libmultipath/structs.h   | 1 +
 multipathd/main.c        | 3 +++
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 044be2b..026418f 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -371,7 +371,7 @@ int dm_addmap_create (struct multipath *mpp, char * params)
 
 int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
 {
-	int r;
+	int r = 0;
 	uint16_t udev_flags = (flush ? 0 : MPATH_UDEV_RELOAD_FLAG) |
 			      ((mpp->skip_kpartx == SKIP_KPARTX_ON)?
 			       MPATH_UDEV_NO_KPARTX_FLAG : 0) |
@@ -383,10 +383,11 @@ int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
 	 * DM_DEVICE_RESUME. So call DM_DEVICE_RESUME
 	 * after each successful call to DM_DEVICE_RELOAD.
 	 */
-	r = dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params, ADDMAP_RW,
-		      SKIP_KPARTX_OFF);
+	if (!mpp->force_readonly)
+		r = dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params,
+			      ADDMAP_RW, SKIP_KPARTX_OFF);
 	if (!r) {
-		if (errno != EROFS)
+		if (!mpp->force_readonly && errno != EROFS)
 			return 0;
 		r = dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp,
 			      params, ADDMAP_RO, SKIP_KPARTX_OFF);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index fdcfc85..98e13e4 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -271,6 +271,7 @@ struct multipath {
 	int san_path_err_recovery_time;
 	int skip_kpartx;
 	int max_sectors_kb;
+	int force_readonly;
 	unsigned int dev_loss;
 	uid_t uid;
 	gid_t gid;
diff --git a/multipathd/main.c b/multipathd/main.c
index f4ff13e..995e580 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1017,7 +1017,10 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 			if (mpp->wait_for_udev)
 				mpp->wait_for_udev = 2;
 			else {
+				if (ro == 1)
+					pp->mpp->force_readonly = 1;
 				retval = reload_map(vecs, mpp, 0, 1);
+				pp->mpp->force_readonly = 0;
 				condlog(2, "%s: map %s reloaded (retval %d)",
 					uev->kernel, mpp->alias, retval);
 			}
-- 
1.8.3.1
