From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] Miscellaneous multipath bugfixes
Date: Thu, 2 Apr 2009 23:44:19 -0500
Message-ID: <20090403044419.GW15911@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

This is mostly a cleanup of some bugs that recently got introduced. In
ACT_RESIZE we were trying to create a read-only device before we tried
to create a read/write one (I also added the ability to fail back to
read-only in ACT_RELOAD).  There were some printouts that I assume were
for debugging, and some duplicate code.  And I switched it so that
dm_simplecmd_flush did flushing, and dm_simplecmd_noflush didn't.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c  |   13 ++++++++-----
 libmultipath/devmapper.c  |   11 ++++-------
 multipathd/cli_handlers.c |    9 ++-------
 3 files changed, 14 insertions(+), 19 deletions(-)

Index: multipath-tools-090402/libmultipath/configure.c
===================================================================
--- multipath-tools-090402.orig/libmultipath/configure.c
+++ multipath-tools-090402/libmultipath/configure.c
@@ -352,16 +352,19 @@ domap (struct multipath * mpp)
 		break;
 
 	case ACT_RELOAD:
-		r = (dm_addmap_reload(mpp->alias, mpp->params, mpp->size, NULL)
-		     && dm_simplecmd_flush(DM_DEVICE_RESUME, mpp->alias));
+		r = dm_addmap_reload(mpp->alias, mpp->params, mpp->size, NULL);
+		if (!r)
+			r = dm_addmap_reload_ro(mpp->alias, mpp->params, mpp->size, NULL);
+		if (r)
+			r = dm_simplecmd_noflush(DM_DEVICE_RESUME, mpp->alias);
 		break;
 
  	case ACT_RESIZE:
-  		r = dm_addmap_reload_ro(mpp->alias, mpp->params, mpp->size, NULL);
+  		r = dm_addmap_reload(mpp->alias, mpp->params, mpp->size, NULL);
   		if (!r)
-  			r = dm_addmap_reload(mpp->alias, mpp->params, mpp->size, NULL);
+  			r = dm_addmap_reload_ro(mpp->alias, mpp->params, mpp->size, NULL);
   		if (r)
-  			r = dm_simplecmd_noflush(DM_DEVICE_RESUME, mpp->alias);
+  			r = dm_simplecmd_flush(DM_DEVICE_RESUME, mpp->alias);
 		break;
 
 	case ACT_RENAME:
Index: multipath-tools-090402/libmultipath/devmapper.c
===================================================================
--- multipath-tools-090402.orig/libmultipath/devmapper.c
+++ multipath-tools-090402/libmultipath/devmapper.c
@@ -176,12 +176,12 @@ dm_simplecmd (int task, const char *name
 
 extern int
 dm_simplecmd_flush (int task, const char *name) {
-	return dm_simplecmd(task, name, 1);
+	return dm_simplecmd(task, name, 0);
 }
 
 extern int
 dm_simplecmd_noflush (int task, const char *name) {
-	return dm_simplecmd(task, name, 0);
+	return dm_simplecmd(task, name, 1);
 }
 
 extern int
@@ -204,9 +204,6 @@ dm_addmap (int task, const char *name, c
 	if (ro)
 		dm_task_set_ro(dmt);
 
-	if (ro)
-		dm_task_set_ro(dmt);
-
 	if (uuid){
 		prefixed_uuid = MALLOC(UUID_PREFIX_LEN + strlen(uuid) + 1);
 		if (!prefixed_uuid) {
@@ -550,7 +547,7 @@ dm_flush_map (const char * mapname)
 		return 1;
 	}
 
-	r = dm_simplecmd_noflush(DM_DEVICE_REMOVE, mapname);
+	r = dm_simplecmd_flush(DM_DEVICE_REMOVE, mapname);
 
 	if (r) {
 		condlog(4, "multipath map %s removed", mapname);
@@ -949,7 +946,7 @@ dm_remove_partmaps (const char * mapname
 				 */
 				condlog(4, "partition map %s removed",
 					names->name);
-				dm_simplecmd_noflush(DM_DEVICE_REMOVE, names->name);
+				dm_simplecmd_flush(DM_DEVICE_REMOVE, names->name);
 		   }
 
 		next = names->next;
Index: multipath-tools-090402/multipathd/cli_handlers.c
===================================================================
--- multipath-tools-090402.orig/multipathd/cli_handlers.c
+++ multipath-tools-090402/multipathd/cli_handlers.c
@@ -459,7 +459,6 @@ cli_resize(void *v, char **reply, int *l
 
 	pgp = VECTOR_SLOT(mpp->pg, 0);
 	pp = VECTOR_SLOT(pgp->paths, 0);
-	condlog(0,"%s: reading sysfs.", mapname);
 	if (sysfs_get_size(pp->sysdev, &size)) {
 		condlog(0, "%s: couldn't get size for sysfs. cannot resize",
 			mapname);
@@ -473,15 +472,11 @@ cli_resize(void *v, char **reply, int *l
 	condlog(3, "%s old size is %llu, new size is %llu", mapname, mpp->size,
 		size);
 
-	condlog(0, "%s: resize_map.", mapname);
 	if (resize_map(mpp, size, vecs) != 0)
 		return 1;
 
-	condlog(0,"%s: dm_lib_release.", mapname);
 	dm_lib_release();
-	condlog(0,"%s: setup multipath.", mapname);
 	setup_multipath(vecs, mpp);
-	condlog(0,"%s: sync map state.", mapname);
 	sync_map_state(mpp);
 
 	return 0;
@@ -513,7 +508,7 @@ cli_suspend(void * v, char ** reply, int
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
-	int r = dm_simplecmd_flush(DM_DEVICE_SUSPEND, param);
+	int r = dm_simplecmd_noflush(DM_DEVICE_SUSPEND, param);
 
 	condlog(2, "%s: suspend (operator)", param);
 
@@ -534,7 +529,7 @@ cli_resume(void * v, char ** reply, int 
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
-	int r = dm_simplecmd_flush(DM_DEVICE_RESUME, param);
+	int r = dm_simplecmd_noflush(DM_DEVICE_RESUME, param);
 
 	condlog(2, "%s: resume (operator)", param);
 
