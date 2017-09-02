From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 09/31] libmultipath: support
	MPATH_UDEV_NO_PATHS_FLAG on map creation
Date: Sun,  3 Sep 2017 00:38:38 +0200
Message-ID: <20170902223900.7339-10-mwilck@suse.com>
References: <20170902223900.7339-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170902223900.7339-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Some vendor kernels (e.g. SUSE) have supported loading multipath
maps without valid paths for a long time. Without that feature,
problems can occur in failover scenarios when multipathd tries
to (re)load maps after device failure/removal, because multipathd's
attempts to reload the configuration may fail unnecessarily.
The discussion in the kernel community is ongoing
(see e.g. https://patchwork.kernel.org/patch/4579551/).

One corner case of this is creation of a map with only failed
paths. Such maps can be created if the kernel patch mentioned above
is applied. The current udev rules for dm-multipath can't detect
this situation. This patch fixes that by setting
DM_SUBSYSTEM_UDEV_FLAG2, which is already used for the "map reload"
case with no valid paths. Thus no additional udev rules are required
to detect this situation.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index e701e806..7a3390a7 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -300,12 +300,14 @@ dm_device_remove (const char *name, int needsync, int deferred_remove) {
 
 static int
 dm_addmap (int task, const char *target, struct multipath *mpp,
-	   char * params, int ro, int skip_kpartx) {
+	   char * params, int ro, uint16_t udev_flags) {
 	int r = 0;
 	struct dm_task *dmt;
 	char *prefixed_uuid = NULL;
 	uint32_t cookie = 0;
-	uint16_t udev_flags = DM_UDEV_DISABLE_LIBRARY_FALLBACK | ((skip_kpartx == SKIP_KPARTX_ON)? MPATH_UDEV_NO_KPARTX_FLAG : 0);
+
+	/* Need to add this here to allow 0 to be passed in udev_flags */
+	udev_flags |= DM_UDEV_DISABLE_LIBRARY_FALLBACK;
 
 	if (!(dmt = libmp_dm_task_create (task)))
 		return 0;
@@ -371,15 +373,27 @@ addout:
 	return r;
 }
 
+static uint16_t build_udev_flags(const struct multipath *mpp, int reload)
+{
+	/* DM_UDEV_DISABLE_LIBRARY_FALLBACK is added in dm_addmap */
+	return	(mpp->skip_kpartx == SKIP_KPARTX_ON ?
+		 MPATH_UDEV_NO_KPARTX_FLAG : 0) |
+		(mpp->nr_active == 0 ?
+		 MPATH_UDEV_NO_PATHS_FLAG : 0) |
+		(reload && !mpp->force_udev_reload ?
+		 MPATH_UDEV_RELOAD_FLAG : 0);
+}
+
 int dm_addmap_create (struct multipath *mpp, char * params)
 {
 	int ro;
+	uint16_t udev_flags = build_udev_flags(mpp, 0);
 
 	for (ro = 0; ro <= 1; ro++) {
 		int err;
 
 		if (dm_addmap(DM_DEVICE_CREATE, TGT_MPATH, mpp, params, ro,
-			      mpp->skip_kpartx))
+			      udev_flags))
 			return 1;
 		/*
 		 * DM_DEVICE_CREATE is actually DM_DEV_CREATE + DM_TABLE_LOAD.
@@ -405,11 +419,7 @@ int dm_addmap_create (struct multipath *mpp, char * params)
 int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
 {
 	int r = 0;
-	uint16_t udev_flags = ((mpp->force_udev_reload)?
-			       0 : MPATH_UDEV_RELOAD_FLAG) |
-			      ((mpp->skip_kpartx == SKIP_KPARTX_ON)?
-			       MPATH_UDEV_NO_KPARTX_FLAG : 0) |
-			      ((mpp->nr_active)? 0 : MPATH_UDEV_NO_PATHS_FLAG);
+	uint16_t udev_flags = build_udev_flags(mpp, 1);
 
 	/*
 	 * DM_DEVICE_RELOAD cannot wait on a cookie, as
@@ -419,12 +429,12 @@ int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
 	 */
 	if (!mpp->force_readonly)
 		r = dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params,
-			      ADDMAP_RW, SKIP_KPARTX_OFF);
+			      ADDMAP_RW, 0);
 	if (!r) {
 		if (!mpp->force_readonly && errno != EROFS)
 			return 0;
 		r = dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp,
-			      params, ADDMAP_RO, SKIP_KPARTX_OFF);
+			      params, ADDMAP_RO, 0);
 	}
 	if (r)
 		r = dm_simplecmd(DM_DEVICE_RESUME, mpp->alias, !flush,
-- 
2.14.0
