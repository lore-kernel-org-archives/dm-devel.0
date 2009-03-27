From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 2 of 2] DM Snapshot: blocking lookup_exception
	workaround
Date: Fri, 27 Mar 2009 16:38:43 -0500
Message-ID: <200903272138.n2RLchN5018067@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Patch name: dm-snap-blocking-lookup_exception-workaround.patch

This patch is just a workaround to make the cluster exception store
(cluster-aware snapshots) work.  It basically, makes the snapshot
mapping functions ignore the fact that the lookup_exception function
will block.

The proper fix would be to have a separate thread in dm-snap.c that
would be used if an exception store returned -EWOULDBLOCK from
lookup_exception.


Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -1070,7 +1070,7 @@ static int snapshot_map(struct dm_target
 
 	/* If the block is already remapped - use that, else remap it */
 	rtn = ss->store->type->lookup_exception(ss->store, chunk,
-						&new_chunk, 0, 0);
+						&new_chunk, 0, 1);
 	if (!rtn) {
 		remap_exception(ss, bio, new_chunk);
 		goto out_unlock;
@@ -1108,7 +1108,7 @@ static int snapshot_map(struct dm_target
 			rtn = ss->store->type->lookup_exception(ss->store,
 								chunk,
 								&new_chunk,
-								0, 0);
+								0, 1);
 			if (!rtn) {
 				dm_free_exception(ss->pending, &pe->e);
 				remap_exception(ss, bio, new_chunk);
@@ -1290,7 +1290,7 @@ static int __origin_write(struct list_he
 		 * ref_count is initialised to 1 so pending_complete()
 		 * won't destroy the primary_pe while we're inside this loop.
 		 */
-		rtn = store->type->lookup_exception(store, chunk, NULL, 1, 0);
+		rtn = store->type->lookup_exception(store, chunk, NULL, 1, 1);
 		if (!rtn)
 			goto next_snapshot;
 
@@ -1315,7 +1315,7 @@ static int __origin_write(struct list_he
 			}
 
 			rtn = store->type->lookup_exception(store, chunk,
-							    NULL, 1, 0);
+							    NULL, 1, 1);
 			if (!rtn) {
 				dm_free_exception(snap->pending, &pe->e);
 				goto next_snapshot;
Index: linux-2.6/drivers/md/dm-ex-store-clusterized.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ex-store-clusterized.c
+++ linux-2.6/drivers/md/dm-ex-store-clusterized.c
@@ -7,6 +7,7 @@
  */
 #include <linux/device-mapper.h>
 #include <linux/dlm.h>
+#include <linux/workqueue.h>
 #include "dm-exception-store.h"
 
 #define DM_MSG_PREFIX "clusterized exception store"
@@ -14,6 +15,9 @@
 struct clusterized_c {
 	struct dm_exception_store *core_store;
 
+	struct completion resume_completion;
+	struct work_struct resume_work;
+
 	struct rw_semaphore lock;
 
 	int current_dl_mode;
@@ -170,6 +174,19 @@ static int cluster_unlock(struct cluster
 	return r;
 }
 
+static void resume_core(struct work_struct *work)
+{
+	int r;
+	struct clusterized_c *cc;
+
+	cc = container_of(work, struct clusterized_c, resume_work);
+
+	r = cc->core_store->type->resume(cc->core_store);
+	if (r)
+		DMERR("Core resume failed");
+	complete(&cc->resume_completion);
+}
+
 /*
  * clusterized_ctr
  * @store
@@ -227,6 +244,8 @@ static int clusterized_ctr(struct dm_exc
 
 	init_rwsem(&cc->lock);
 	init_completion(&cc->dlm_completion);
+	init_completion(&cc->resume_completion);
+	INIT_WORK(&cc->resume_work, resume_core);
 
 	/* Create (or join) the lock space */
 	r = dlm_new_lockspace(store->type->name, strlen(store->type->name),
@@ -438,7 +457,8 @@ static int clusterized_lookup_exception(
 	 * re-reading its metadata and updating its cache.  IOW, it must
 	 * be able to resume multiple times before a suspend is issued.
 	 */
-	cc->core_store->type->resume(cc->core_store);
+	schedule_work(&cc->resume_work);
+	wait_for_completion(&cc->resume_completion);
 
 	cc->metadata_counter = cc->cluster_metadata_counter;
 	cluster_unlock(cc);
