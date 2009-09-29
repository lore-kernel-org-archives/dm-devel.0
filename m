From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 08/18] dm-snapshot-exception-function-changes-1
Date: Tue, 29 Sep 2009 18:53:33 -0400
Message-ID: <1254264823-11538-9-git-send-email-snitzer@redhat.com>
References: <1254264823-11538-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1254264823-11538-1-git-send-email-snitzer@redhat.com>
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

From: Jon Brassow <jbrassow@redhat.com>

This patch moves towards a generalized interface for functions that
allocate and deallocate exceptions.  So, we add an additional parameter
for context pointers.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |   36 +++++++++++++++++++-----------------
 1 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index cc04760..807447e 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -419,7 +419,7 @@ static struct dm_exception *dm_lookup_exception(struct dm_exception_table *et,
 	return NULL;
 }
 
-static struct dm_exception *alloc_completed_exception(void)
+static struct dm_exception *alloc_completed_exception(void *unused)
 {
 	struct dm_exception *e;
 
@@ -430,13 +430,14 @@ static struct dm_exception *alloc_completed_exception(void)
 	return e;
 }
 
-static void free_completed_exception(struct dm_exception *e)
+static void free_completed_exception(struct dm_exception *e, void *unused)
 {
 	kmem_cache_free(exception_cache, e);
 }
 
-static struct dm_snap_pending_exception *alloc_pending_exception(struct dm_snapshot *s)
+static struct dm_snap_pending_exception *alloc_pending_exception(void *context)
 {
+	struct dm_snapshot *s = context;
 	struct dm_snap_pending_exception *pe = mempool_alloc(s->pending_pool,
 							     GFP_NOIO);
 
@@ -446,7 +447,8 @@ static struct dm_snap_pending_exception *alloc_pending_exception(struct dm_snaps
 	return pe;
 }
 
-static void free_pending_exception(struct dm_snap_pending_exception *pe)
+static void free_pending_exception(struct dm_snap_pending_exception *pe,
+				   void *unused)
 {
 	struct dm_snapshot *s = pe->snap;
 
@@ -475,7 +477,7 @@ static void dm_insert_exception(struct dm_exception_table *eh,
 		    new_e->new_chunk == (dm_chunk_number(e->new_chunk) +
 					 dm_consecutive_chunk_count(e) + 1)) {
 			dm_consecutive_chunk_count_inc(e);
-			free_completed_exception(new_e);
+			free_completed_exception(new_e, NULL);
 			return;
 		}
 
@@ -506,7 +508,7 @@ static int dm_add_exception(void *context, chunk_t old, chunk_t new)
 	struct dm_snapshot *s = context;
 	struct dm_exception *e;
 
-	e = alloc_completed_exception();
+	e = alloc_completed_exception(NULL);
 	if (!e)
 		return -ENOMEM;
 
@@ -923,7 +925,7 @@ static struct bio *put_pending_exception(struct dm_snap_pending_exception *pe)
 	if (primary_pe &&
 	    atomic_dec_and_test(&primary_pe->ref_count)) {
 		origin_bios = bio_list_get(&primary_pe->origin_bios);
-		free_pending_exception(primary_pe);
+		free_pending_exception(primary_pe, NULL);
 	}
 
 	/*
@@ -931,7 +933,7 @@ static struct bio *put_pending_exception(struct dm_snap_pending_exception *pe)
 	 * it's not itself a primary pe.
 	 */
 	if (!primary_pe || primary_pe != pe)
-		free_pending_exception(pe);
+		free_pending_exception(pe, NULL);
 
 	return origin_bios;
 }
@@ -952,7 +954,7 @@ static void pending_complete(struct dm_snap_pending_exception *pe, int success)
 		goto out;
 	}
 
-	e = alloc_completed_exception();
+	e = alloc_completed_exception(NULL);
 	if (!e) {
 		down_write(&s->lock);
 		__invalidate_snapshot(s, -ENOMEM);
@@ -963,7 +965,7 @@ static void pending_complete(struct dm_snap_pending_exception *pe, int success)
 
 	down_write(&s->lock);
 	if (!s->valid) {
-		free_completed_exception(e);
+		free_completed_exception(e, NULL);
 		error = 1;
 		goto out;
 	}
@@ -1074,7 +1076,7 @@ __find_pending_exception(struct dm_snapshot *s,
 
 	pe2 = __lookup_pending_exception(s, chunk);
 	if (pe2) {
-		free_pending_exception(pe);
+		free_pending_exception(pe, NULL);
 		return pe2;
 	}
 
@@ -1086,7 +1088,7 @@ __find_pending_exception(struct dm_snapshot *s,
 	pe->started = 0;
 
 	if (s->store->type->prepare_exception(s->store, &pe->e)) {
-		free_pending_exception(pe);
+		free_pending_exception(pe, NULL);
 		return NULL;
 	}
 
@@ -1157,14 +1159,14 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio,
 			down_write(&s->lock);
 
 			if (!s->valid) {
-				free_pending_exception(pe);
+				free_pending_exception(pe, NULL);
 				r = -EIO;
 				goto out_unlock;
 			}
 
 			e = dm_lookup_exception(s->complete, chunk);
 			if (e) {
-				free_pending_exception(pe);
+				free_pending_exception(pe, NULL);
 				remap_exception(s, e, bio, chunk);
 				goto out_unlock;
 			}
@@ -1320,13 +1322,13 @@ static int __origin_write(struct list_head *snapshots, struct bio *bio)
 			down_write(&snap->lock);
 
 			if (!snap->valid) {
-				free_pending_exception(pe);
+				free_pending_exception(pe, NULL);
 				goto next_snapshot;
 			}
 
 			e = dm_lookup_exception(snap->complete, chunk);
 			if (e) {
-				free_pending_exception(pe);
+				free_pending_exception(pe, NULL);
 				goto next_snapshot;
 			}
 
@@ -1380,7 +1382,7 @@ static int __origin_write(struct list_head *snapshots, struct bio *bio)
 
 	if (first && atomic_dec_and_test(&primary_pe->ref_count)) {
 		flush_bios(bio_list_get(&primary_pe->origin_bios));
-		free_pending_exception(primary_pe);
+		free_pending_exception(primary_pe, NULL);
 		/* If we got here, pe_queue is necessarily empty. */
 		return r;
 	}
-- 
1.6.2.5
