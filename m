From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 36/57] libmultipath: pass in 'cookie' as argument
	for dm_addmap()
Date: Wed, 27 Apr 2016 13:10:37 +0200
Message-ID: <1461755458-29225-37-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Instead of generating the cookie internally we should be
passing in the cookie to dm_addmap().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/devmapper.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index e6156f7..a96cc0e 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -274,11 +274,10 @@ dm_device_remove (const char *name, int needsync, int deferred_remove) {
 
 extern int
 dm_addmap (int task, const char *target, struct multipath *mpp,
-	   char * params, int ro) {
+	   char * params, int ro, uint32_t *cookie) {
 	int r = 0;
 	struct dm_task *dmt;
 	char *prefixed_uuid = NULL;
-	uint32_t cookie = 0;
 
 	if (!(dmt = dm_task_create (task)))
 		return 0;
@@ -319,18 +318,18 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
 	dm_task_no_open_count(dmt);
 
 	if (task == DM_DEVICE_CREATE &&
-	    !dm_task_set_cookie(dmt, &cookie,
+	    !dm_task_set_cookie(dmt, cookie,
 				DM_UDEV_DISABLE_LIBRARY_FALLBACK)) {
-		dm_udev_complete(cookie);
+		dm_udev_complete(*cookie);
 		goto freeout;
 	}
 	r = dm_task_run (dmt);
 
 	if (task == DM_DEVICE_CREATE) {
 		if (!r)
-			dm_udev_complete(cookie);
+			dm_udev_complete(*cookie);
 		else
-			dm_udev_wait(cookie);
+			dm_udev_wait(*cookie);
 	}
 	freeout:
 	if (prefixed_uuid)
@@ -345,11 +344,13 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
 extern int
 dm_addmap_create (struct multipath *mpp, char * params) {
 	int ro;
+	uint32_t cookie = 0;
 
 	for (ro = 0; ro <= 1; ro++) {
 		int err;
 
-		if (dm_addmap(DM_DEVICE_CREATE, TGT_MPATH, mpp, params, ro))
+		if (dm_addmap(DM_DEVICE_CREATE, TGT_MPATH,
+			      mpp, params, ro, &cookie))
 			return 1;
 		/*
 		 * DM_DEVICE_CREATE is actually DM_DEV_CREATE + DM_TABLE_LOAD.
@@ -374,11 +375,15 @@ dm_addmap_create (struct multipath *mpp, char * params) {
 
 extern int
 dm_addmap_reload (struct multipath *mpp, char *params) {
-	if (dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params, ADDMAP_RW))
+	uint32_t cookie = 0;
+
+	if (dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params,
+		      ADDMAP_RW, &cookie))
 		return 1;
 	if (errno != EROFS)
 		return 0;
-	return dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params, ADDMAP_RO);
+	return dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params,
+			 ADDMAP_RO, &cookie);
 }
 
 extern int
-- 
2.6.6
