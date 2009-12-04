From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v5 01/13] dm snapshot: rework writing to snapshot
	origin
Date: Thu,  3 Dec 2009 21:23:42 -0500
Message-ID: <1259893434-10792-2-git-send-email-snitzer@redhat.com>
References: <1259893434-10792-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1259893434-10792-1-git-send-email-snitzer@redhat.com>
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
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>

The previous code selected one exception as "primary_pe", linked all
other exceptions to it and used reference counting to wait until all
exceptions were reallocated.

All the complexity with exceptions linking and reference counting has
been removed.  Now, a bio is linked to one exception and when that
exception is reallocated, the bio is retried to possibly wait for other
exceptions.

The new __origin_write() interface affords the snapshot-merge support
the ability to trigger exceptions in other snapshots without having a
need for an associated bio (which snapshot-merge does not generate).  As
such this patch is a prerequisite for snapshot-merge.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |  165 +++++++++++++++++--------------------------------
 1 files changed, 57 insertions(+), 108 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index ee89573..d8180ba 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -137,28 +137,6 @@ struct dm_snap_pending_exception {
 	struct bio_list origin_bios;
 	struct bio_list snapshot_bios;
 
-	/*
-	 * Short-term queue of pending exceptions prior to submission.
-	 */
-	struct list_head list;
-
-	/*
-	 * The primary pending_exception is the one that holds
-	 * the ref_count and the list of origin_bios for a
-	 * group of pending_exceptions.  It is always last to get freed.
-	 * These fields get set up when writing to the origin.
-	 */
-	struct dm_snap_pending_exception *primary_pe;
-
-	/*
-	 * Number of pending_exceptions processing this chunk.
-	 * When this drops to zero we must complete the origin bios.
-	 * If incrementing or decrementing this, hold pe->snap->lock for
-	 * the sibling concerned and not pe->primary_pe->snap->lock unless
-	 * they are the same.
-	 */
-	atomic_t ref_count;
-
 	/* Pointer back to snapshot context */
 	struct dm_snapshot *snap;
 
@@ -999,6 +977,28 @@ static void flush_queued_bios(struct work_struct *work)
 	flush_bios(queued_bios);
 }
 
+static int do_origin(struct dm_dev *origin, struct bio *bio);
+
+/*
+ * Flush a list of buffers.
+ */
+static void retry_origin_bios(struct dm_snapshot *s, struct bio *bio)
+{
+	struct bio *n;
+	int r;
+
+	while (bio) {
+		n = bio->bi_next;
+		bio->bi_next = NULL;
+		r = do_origin(s->origin, bio);
+		if (r == DM_MAPIO_REMAPPED)
+			generic_make_request(bio);
+		else
+			BUG_ON(r != DM_MAPIO_SUBMITTED);
+		bio = n;
+	}
+}
+
 /*
  * Error a list of buffers.
  */
@@ -1032,39 +1032,6 @@ static void __invalidate_snapshot(struct dm_snapshot *s, int err)
 	dm_table_event(s->ti->table);
 }
 
-static void get_pending_exception(struct dm_snap_pending_exception *pe)
-{
-	atomic_inc(&pe->ref_count);
-}
-
-static struct bio *put_pending_exception(struct dm_snap_pending_exception *pe)
-{
-	struct dm_snap_pending_exception *primary_pe;
-	struct bio *origin_bios = NULL;
-
-	primary_pe = pe->primary_pe;
-
-	/*
-	 * If this pe is involved in a write to the origin and
-	 * it is the last sibling to complete then release
-	 * the bios for the original write to the origin.
-	 */
-	if (primary_pe &&
-	    atomic_dec_and_test(&primary_pe->ref_count)) {
-		origin_bios = bio_list_get(&primary_pe->origin_bios);
-		free_pending_exception(primary_pe);
-	}
-
-	/*
-	 * Free the pe if it's not linked to an origin write or if
-	 * it's not itself a primary pe.
-	 */
-	if (!primary_pe || primary_pe != pe)
-		free_pending_exception(pe);
-
-	return origin_bios;
-}
-
 static void pending_complete(struct dm_snap_pending_exception *pe, int success)
 {
 	struct dm_exception *e;
@@ -1113,7 +1080,8 @@ static void pending_complete(struct dm_snap_pending_exception *pe, int success)
  out:
 	dm_remove_exception(&pe->e);
 	snapshot_bios = bio_list_get(&pe->snapshot_bios);
-	origin_bios = put_pending_exception(pe);
+	origin_bios = bio_list_get(&pe->origin_bios);
+	free_pending_exception(pe);
 
 	up_write(&s->lock);
 
@@ -1123,7 +1091,7 @@ static void pending_complete(struct dm_snap_pending_exception *pe, int success)
 	else
 		flush_bios(snapshot_bios);
 
-	flush_bios(origin_bios);
+	retry_origin_bios(s, origin_bios);
 }
 
 static void commit_callback(void *context, int success)
@@ -1210,8 +1178,6 @@ __find_pending_exception(struct dm_snapshot *s,
 	pe->e.old_chunk = chunk;
 	bio_list_init(&pe->origin_bios);
 	bio_list_init(&pe->snapshot_bios);
-	pe->primary_pe = NULL;
-	atomic_set(&pe->ref_count, 0);
 	pe->started = 0;
 
 	if (s->store->type->prepare_exception(s->store, &pe->e)) {
@@ -1219,7 +1185,6 @@ __find_pending_exception(struct dm_snapshot *s,
 		return NULL;
 	}
 
-	get_pending_exception(pe);
 	dm_insert_exception(&s->pending, &pe->e);
 
 	return pe;
@@ -1462,14 +1427,21 @@ static int snapshot_iterate_devices(struct dm_target *ti,
 /*-----------------------------------------------------------------
  * Origin methods
  *---------------------------------------------------------------*/
-static int __origin_write(struct list_head *snapshots, struct bio *bio)
+
+/*
+ * Returns:
+ *	DM_MAPIO_REMAPPED: bio may be submitted to origin device
+ *	DM_MAPIO_SUBMITTED: bio was queued on queue on one of exceptions
+ */
+
+static int __origin_write(struct list_head *snapshots,
+			  sector_t sector, struct bio *bio)
 {
-	int r = DM_MAPIO_REMAPPED, first = 0;
+	int r = DM_MAPIO_REMAPPED;
 	struct dm_snapshot *snap;
 	struct dm_exception *e;
-	struct dm_snap_pending_exception *pe, *next_pe, *primary_pe = NULL;
+	struct dm_snap_pending_exception *pe, *pe_to_start = NULL;
 	chunk_t chunk;
-	LIST_HEAD(pe_queue);
 
 	/* Do all the snapshots on this origin */
 	list_for_each_entry (snap, snapshots, list) {
@@ -1481,22 +1453,19 @@ static int __origin_write(struct list_head *snapshots, struct bio *bio)
 			goto next_snapshot;
 
 		/* Nothing to do if writing beyond end of snapshot */
-		if (bio->bi_sector >= dm_table_get_size(snap->ti->table))
+		if (sector >= dm_table_get_size(snap->ti->table))
 			goto next_snapshot;
 
 		/*
 		 * Remember, different snapshots can have
 		 * different chunk sizes.
 		 */
-		chunk = sector_to_chunk(snap->store, bio->bi_sector);
+		chunk = sector_to_chunk(snap->store, sector);
 
 		/*
 		 * Check exception table to see if block
 		 * is already remapped in this snapshot
 		 * and trigger an exception if not.
-		 *
-		 * ref_count is initialised to 1 so pending_complete()
-		 * won't destroy the primary_pe while we're inside this loop.
 		 */
 		e = dm_lookup_exception(&snap->complete, chunk);
 		if (e)
@@ -1526,59 +1495,39 @@ static int __origin_write(struct list_head *snapshots, struct bio *bio)
 			}
 		}
 
-		if (!primary_pe) {
-			/*
-			 * Either every pe here has same
-			 * primary_pe or none has one yet.
-			 */
-			if (pe->primary_pe)
-				primary_pe = pe->primary_pe;
-			else {
-				primary_pe = pe;
-				first = 1;
-			}
-
-			bio_list_add(&primary_pe->origin_bios, bio);
+		r = DM_MAPIO_SUBMITTED;
 
-			r = DM_MAPIO_SUBMITTED;
-		}
+		if (bio) {
+			bio_list_add(&pe->origin_bios, bio);
+			bio = NULL;
 
-		if (!pe->primary_pe) {
-			pe->primary_pe = primary_pe;
-			get_pending_exception(primary_pe);
+			if (!pe->started) {
+				pe->started = 1;
+				pe_to_start = pe;
+			}
 		}
 
 		if (!pe->started) {
 			pe->started = 1;
-			list_add_tail(&pe->list, &pe_queue);
+			start_copy(pe);
 		}
 
  next_snapshot:
 		up_write(&snap->lock);
 	}
 
-	if (!primary_pe)
-		return r;
-
 	/*
-	 * If this is the first time we're processing this chunk and
-	 * ref_count is now 1 it means all the pending exceptions
-	 * got completed while we were in the loop above, so it falls to
-	 * us here to remove the primary_pe and submit any origin_bios.
+	 * pe_to_start is a small performance improvement:
+	 * To avoid calling __origin_write N times for N snapshots, we start
+	 * the snapshot where we queued the bio as the last one.
+	 *
+	 * If we start it as the last one, it finishes most likely as the last
+	 * one and exceptions in other snapshots will be already finished when
+	 * the bio will be retried.
 	 */
 
-	if (first && atomic_dec_and_test(&primary_pe->ref_count)) {
-		flush_bios(bio_list_get(&primary_pe->origin_bios));
-		free_pending_exception(primary_pe);
-		/* If we got here, pe_queue is necessarily empty. */
-		return r;
-	}
-
-	/*
-	 * Now that we have a complete pe list we can start the copying.
-	 */
-	list_for_each_entry_safe(pe, next_pe, &pe_queue, list)
-		start_copy(pe);
+	if (pe_to_start)
+		start_copy(pe_to_start);
 
 	return r;
 }
@@ -1594,7 +1543,7 @@ static int do_origin(struct dm_dev *origin, struct bio *bio)
 	down_read(&_origins_lock);
 	o = __lookup_origin(origin->bdev);
 	if (o)
-		r = __origin_write(&o->snapshots, bio);
+		r = __origin_write(&o->snapshots, bio->bi_sector, bio);
 	up_read(&_origins_lock);
 
 	return r;
-- 
1.6.5.2
