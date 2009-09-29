From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 09/18] dm-snapshot-exception-function-changes-2
Date: Tue, 29 Sep 2009 18:53:34 -0400
Message-ID: <1254264823-11538-10-git-send-email-snitzer@redhat.com>
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

This patch makes exception [de]allocation functions deal specifically
with the dm_exception type.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |   43 +++++++++++++++++++++++++------------------
 1 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 807447e..df8cb32 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -435,7 +435,7 @@ static void free_completed_exception(struct dm_exception *e, void *unused)
 	kmem_cache_free(exception_cache, e);
 }
 
-static struct dm_snap_pending_exception *alloc_pending_exception(void *context)
+static struct dm_exception *alloc_pending_exception(void *context)
 {
 	struct dm_snapshot *s = context;
 	struct dm_snap_pending_exception *pe = mempool_alloc(s->pending_pool,
@@ -444,13 +444,16 @@ static struct dm_snap_pending_exception *alloc_pending_exception(void *context)
 	atomic_inc(&s->pending_exceptions_count);
 	pe->snap = s;
 
-	return pe;
+	return &pe->e;
 }
 
-static void free_pending_exception(struct dm_snap_pending_exception *pe,
-				   void *unused)
+static void free_pending_exception(struct dm_exception *e, void *unused)
 {
-	struct dm_snapshot *s = pe->snap;
+	struct dm_snap_pending_exception *pe;
+	struct dm_snapshot *s;
+
+	pe = container_of(e, struct dm_snap_pending_exception, e);
+	s = pe->snap;
 
 	mempool_free(pe, s->pending_pool);
 	smp_mb__before_atomic_dec();
@@ -925,7 +928,7 @@ static struct bio *put_pending_exception(struct dm_snap_pending_exception *pe)
 	if (primary_pe &&
 	    atomic_dec_and_test(&primary_pe->ref_count)) {
 		origin_bios = bio_list_get(&primary_pe->origin_bios);
-		free_pending_exception(primary_pe, NULL);
+		free_pending_exception(&primary_pe->e, NULL);
 	}
 
 	/*
@@ -933,7 +936,7 @@ static struct bio *put_pending_exception(struct dm_snap_pending_exception *pe)
 	 * it's not itself a primary pe.
 	 */
 	if (!primary_pe || primary_pe != pe)
-		free_pending_exception(pe, NULL);
+		free_pending_exception(&pe->e, NULL);
 
 	return origin_bios;
 }
@@ -1076,7 +1079,7 @@ __find_pending_exception(struct dm_snapshot *s,
 
 	pe2 = __lookup_pending_exception(s, chunk);
 	if (pe2) {
-		free_pending_exception(pe, NULL);
+		free_pending_exception(&pe->e, NULL);
 		return pe2;
 	}
 
@@ -1088,7 +1091,7 @@ __find_pending_exception(struct dm_snapshot *s,
 	pe->started = 0;
 
 	if (s->store->type->prepare_exception(s->store, &pe->e)) {
-		free_pending_exception(pe, NULL);
+		free_pending_exception(&pe->e, NULL);
 		return NULL;
 	}
 
@@ -1112,7 +1115,7 @@ static void remap_exception(struct dm_snapshot *s, struct dm_exception *e,
 static int snapshot_map(struct dm_target *ti, struct bio *bio,
 			union map_info *map_context)
 {
-	struct dm_exception *e;
+	struct dm_exception *e, *tmp_e;
 	struct dm_snapshot *s = ti->private;
 	int r = DM_MAPIO_REMAPPED;
 	chunk_t chunk;
@@ -1155,18 +1158,20 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio,
 		pe = __lookup_pending_exception(s, chunk);
 		if (!pe) {
 			up_write(&s->lock);
-			pe = alloc_pending_exception(s);
+			tmp_e = alloc_pending_exception(s);
+			pe = container_of(tmp_e,
+					  struct dm_snap_pending_exception, e);
 			down_write(&s->lock);
 
 			if (!s->valid) {
-				free_pending_exception(pe, NULL);
+				free_pending_exception(&pe->e, NULL);
 				r = -EIO;
 				goto out_unlock;
 			}
 
 			e = dm_lookup_exception(s->complete, chunk);
 			if (e) {
-				free_pending_exception(pe, NULL);
+				free_pending_exception(&pe->e, NULL);
 				remap_exception(s, e, bio, chunk);
 				goto out_unlock;
 			}
@@ -1279,7 +1284,7 @@ static int __origin_write(struct list_head *snapshots, struct bio *bio)
 {
 	int r = DM_MAPIO_REMAPPED, first = 0;
 	struct dm_snapshot *snap;
-	struct dm_exception *e;
+	struct dm_exception *e, *tmp_e;
 	struct dm_snap_pending_exception *pe, *next_pe, *primary_pe = NULL;
 	chunk_t chunk;
 	LIST_HEAD(pe_queue);
@@ -1318,17 +1323,19 @@ static int __origin_write(struct list_head *snapshots, struct bio *bio)
 		pe = __lookup_pending_exception(snap, chunk);
 		if (!pe) {
 			up_write(&snap->lock);
-			pe = alloc_pending_exception(snap);
+			tmp_e = alloc_pending_exception(snap);
+			pe = container_of(tmp_e,
+					  struct dm_snap_pending_exception, e);
 			down_write(&snap->lock);
 
 			if (!snap->valid) {
-				free_pending_exception(pe, NULL);
+				free_pending_exception(&pe->e, NULL);
 				goto next_snapshot;
 			}
 
 			e = dm_lookup_exception(snap->complete, chunk);
 			if (e) {
-				free_pending_exception(pe, NULL);
+				free_pending_exception(&pe->e, NULL);
 				goto next_snapshot;
 			}
 
@@ -1382,7 +1389,7 @@ static int __origin_write(struct list_head *snapshots, struct bio *bio)
 
 	if (first && atomic_dec_and_test(&primary_pe->ref_count)) {
 		flush_bios(bio_list_get(&primary_pe->origin_bios));
-		free_pending_exception(primary_pe, NULL);
+		free_pending_exception(&primary_pe->e, NULL);
 		/* If we got here, pe_queue is necessarily empty. */
 		return r;
 	}
-- 
1.6.2.5
