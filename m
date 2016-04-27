From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 33/57] libmultipath: remove 'use_uuid' argument
	from dm_addmap()
Date: Wed, 27 Apr 2016 13:10:34 +0200
Message-ID: <1461755458-29225-34-git-send-email-hare@suse.de>
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

'use_uuid' was only ever set for DM_DEVICE_CREATE, so we
can check the task and remove the 'use_uuid' argument.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/devmapper.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 1115216..c7d4b49 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -264,8 +264,8 @@ dm_device_remove (const char *name, int needsync, int deferred_remove) {
 }
 
 extern int
-dm_addmap (int task, const char *target, struct multipath *mpp, char * params,
-	   int use_uuid, int ro) {
+dm_addmap (int task, const char *target, struct multipath *mpp,
+	   char * params, int ro) {
 	int r = 0;
 	struct dm_task *dmt;
 	char *prefixed_uuid = NULL;
@@ -283,7 +283,7 @@ dm_addmap (int task, const char *target, struct multipath *mpp, char * params,
 	if (ro)
 		dm_task_set_ro(dmt);
 
-	if (use_uuid && strlen(mpp->wwid) > 0){
+	if ((task == DM_DEVICE_CREATE) && strlen(mpp->wwid) > 0){
 		prefixed_uuid = MALLOC(UUID_PREFIX_LEN + strlen(mpp->wwid) + 1);
 		if (!prefixed_uuid) {
 			condlog(0, "cannot create prefixed uuid : %s",
@@ -339,8 +339,7 @@ dm_addmap_create (struct multipath *mpp, char * params) {
 	for (ro = 0; ro <= 1; ro++) {
 		int err;
 
-		if (dm_addmap(DM_DEVICE_CREATE, TGT_MPATH,
-			      mpp, params, 1, ro))
+		if (dm_addmap(DM_DEVICE_CREATE, TGT_MPATH, mpp, params, ro))
 			return 1;
 		/*
 		 * DM_DEVICE_CREATE is actually DM_DEV_CREATE + DM_TABLE_LOAD.
@@ -365,11 +364,11 @@ dm_addmap_create (struct multipath *mpp, char * params) {
 
 extern int
 dm_addmap_reload (struct multipath *mpp, char *params) {
-	if (dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params, 0, ADDMAP_RW))
+	if (dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params, ADDMAP_RW))
 		return 1;
 	if (errno != EROFS)
 		return 0;
-	return dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params, 0, ADDMAP_RO);
+	return dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params, ADDMAP_RO);
 }
 
 extern int
-- 
2.6.6
