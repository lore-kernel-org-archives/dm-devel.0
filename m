From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm snapshot: remove try_again goto from
	snapshot_merge_process()
Date: Mon,  7 Dec 2009 23:26:20 -0500
Message-ID: <1260246380-32576-1-git-send-email-snitzer@redhat.com>
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

Replace snapshot_merge_process()'s 'goto try_again;' loop with a while
loop that calls origin_write_extent().  origin_write_extent() triggers
exceptions in all non-merging snapshots for the specified extent.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
NOTE: this patch has been appended to the following quilt tree:
http://people.redhat.com/msnitzer/patches/snapshot-merge/kernel/2.6.33/
---
 drivers/md/dm-snap.c |  103 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 57 insertions(+), 46 deletions(-)

Index: linux-rhel6/drivers/md/dm-snap.c
===================================================================
--- linux-rhel6.orig/drivers/md/dm-snap.c
+++ linux-rhel6/drivers/md/dm-snap.c
@@ -766,8 +766,8 @@ static int init_hash_tables(struct dm_sn
 static void flush_bios(struct bio *bio);
 static void error_bios(struct bio *bio);
 
-static int __origin_write(struct list_head *snapshots,
-			  sector_t sector, struct bio *bio);
+static int origin_write_extent(struct dm_snapshot *merging_snap,
+			       sector_t sector, chunk_t size);
 
 static void merge_callback(int read_err, unsigned long write_err,
 			   void *context);
@@ -785,10 +785,8 @@ static u64 read_pending_exception_done_c
 
 static void snapshot_merge_process(struct dm_snapshot *s)
 {
-	int r, i, linear_chunks;
-	chunk_t old_chunk, new_chunk, n;
-	struct origin *o;
-	int must_wait;
+	int i, linear_chunks;
+	chunk_t old_chunk, new_chunk;
 	struct dm_io_region src, dest;
 	sector_t io_size;
 	u64 previous_count;
@@ -832,49 +830,13 @@ static void snapshot_merge_process(struc
 	src.sector = chunk_to_sector(s->store, new_chunk);
 	src.count = dest.count;
 
-	/*
-	 * Reallocate the other snapshots:
-	 *
-	 * The chunk size of the merging snapshot may be larger than the chunk
-	 * size of some other snapshot. So we may need to reallocate multiple
-	 * chunks in a snapshot.
-	 *
-	 * We don't do linking of pending exceptions and waiting for the last
-	 * one --- that would complicate code too much and it would also be
-	 * bug-prone.
-	 *
-	 * Instead, we try to scan all the overlapping exceptions in all
-	 * non-merging snapshots and if something was reallocated then wait
-	 * for any pending exception to complete. Retry after the wait, until
-	 * all exceptions are done.
-	 *
-	 * This may seem ineffective, but in practice, people hardly use more
-	 * than one or two snapshots. In case of two snapshots (one merging and
-	 * one non-merging) with the same chunksize, wait and wakeup is done
-	 * only once.
-	 */
-
-test_again:
+	/* Reallocate the other snapshots */
 	previous_count = read_pending_exception_done_count();
-	must_wait = 0;
-
-	/*
-	 * Merging snapshot already has the origin's __minimum_chunk_size()
-	 * stored in split_io (see: snapshot_merge_resume); avoid rediscovery
-	 */
-	BUG_ON(!s->ti->split_io);
-	down_read(&_origins_lock);
-	o = __lookup_origin(s->origin->bdev);
-	for (n = 0; n < io_size; n += s->ti->split_io) {
-		r = __origin_write(&o->snapshots, dest.sector + n, NULL);
-		if (r == DM_MAPIO_SUBMITTED)
-			must_wait = 1;
-	}
-	up_read(&_origins_lock);
-	if (must_wait) {
+	while (origin_write_extent(s, dest.sector, io_size)) {
 		wait_event(_pending_exception_done,
 			   read_pending_exception_done_count() != previous_count);
-		goto test_again;
+		/* Retry after the wait, until all exceptions are done. */
+		previous_count = read_pending_exception_done_count();
 	}
 
 	down_write(&s->lock);
@@ -1984,6 +1946,55 @@ static int do_origin(struct dm_dev *orig
 }
 
 /*
+ * Trigger exceptions in all non-merging snapshots for the
+ * specified extent:
+ *
+ * The chunk size of the merging snapshot may be larger than the chunk
+ * size of some other snapshot. So we may need to reallocate multiple
+ * chunks in a snapshot.
+ *
+ * We don't do linking of pending exceptions and waiting for the last
+ * one --- that would complicate code too much and it would also be
+ * bug-prone.
+ *
+ * Instead, we try to scan all the overlapping exceptions in all
+ * non-merging snapshots and if something was reallocated then wait
+ * for any pending exception to complete. Retry after the wait, until
+ * all exceptions are done.
+ *
+ * This may seem ineffective, but in practice, people hardly use more
+ * than one or two snapshots. In case of two snapshots (one merging and
+ * one non-merging) with the same chunksize, wait and wakeup is done
+ * only once.
+ */
+static int origin_write_extent(struct dm_snapshot *merging_snap,
+			       sector_t sector, chunk_t size)
+{
+	int r, must_wait = 0;
+	chunk_t n;
+	struct origin *o;
+
+	/* 'size' must be a multiple of the 'merging_snap's chunk_size */
+	BUG_ON(size % merging_snap->store->chunk_size);
+	/*
+	 * Merging snapshot already has the origin's __minimum_chunk_size()
+	 * stored in split_io (see: snapshot_merge_resume); avoid rediscovery
+	 */
+	BUG_ON(!merging_snap->ti->split_io);
+
+	down_read(&_origins_lock);
+	o = __lookup_origin(merging_snap->origin->bdev);
+	for (n = 0; n < size; n += merging_snap->ti->split_io) {
+		r = __origin_write(&o->snapshots, sector + n, NULL);
+		if (r == DM_MAPIO_SUBMITTED)
+			must_wait = 1;
+	}
+	up_read(&_origins_lock);
+
+	return must_wait;
+}
+
+/*
  * Origin: maps a linear range of a device, with hooks for snapshotting.
  */
 
