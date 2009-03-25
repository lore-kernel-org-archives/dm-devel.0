From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 2 of 2] DM Snapshot: blocking lookup_exception
	workaround
Date: Wed, 25 Mar 2009 16:48:33 -0500
Message-ID: <200903252148.n2PLmX1t027384@hydrogen.msp.redhat.com>
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
@@ -17,6 +18,7 @@ struct clusterized_c {
 	atomic_t prepared_exceptions;
 
 	struct completion completion;
+	struct work_struct resume_work;
 
 	int current_lock_mode;
 	struct semaphore serialize; /* serialize DLM lock modes */
@@ -124,6 +126,21 @@ static int cluster_unlock(struct cluster
 	return 0;
 }
 
+static void resume_core(struct work_struct *work)
+{
+	int r;
+	struct clusterized_c *cc;
+
+	cc = container_of(work, struct clusterized_c, resume_work);
+
+	DMERR("Initiating core resume");
+	r = cc->core_store->type->resume(cc->core_store);
+	if (r)
+		DMERR("Core resume failed");
+	DMERR("Finished");
+	complete(&cc->completion);
+}
+
 /*
  * clusterized_ctr
  * @store
@@ -180,6 +197,7 @@ static int clusterized_ctr(struct dm_exc
 	cc->lksb.sb_lvbptr = (char *)&cc->cluster_metadata_counter;
 
 	init_completion(&cc->completion);
+	INIT_WORK(&cc->resume_work, resume_core);
 
 	init_MUTEX(&cc->serialize);
 
@@ -392,7 +410,8 @@ static int clusterized_lookup_exception(
 	 * re-reading its metadata and updating its cache.  IOW, it must
 	 * be able to resume multiple times before a suspend is issued.
 	 */
-	cc->core_store->type->resume(cc->core_store);
+	schedule_work(&cc->resume_work);
+	wait_for_completion(&cc->completion);
 
 	cc->metadata_counter = cc->cluster_metadata_counter;
 	cluster_unlock(cc);
