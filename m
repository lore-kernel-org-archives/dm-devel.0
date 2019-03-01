From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: [PATCH v2 3/5] dm snapshot: Replace mutex with rw
	semaphore
Date: Fri,  1 Mar 2019 18:51:49 +0200
Message-ID: <20190301165151.1352-4-ntsironis@arrikto.com>
References: <20190301165151.1352-1-ntsironis@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190301165151.1352-1-ntsironis@arrikto.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
Cc: mpatocka@redhat.com, iliastsi@arrikto.com
List-Id: dm-devel.ids

dm-snapshot uses a single mutex to serialize every access to the
snapshot state. This includes all accesses to the complete and pending
exception tables, which occur at every origin write, every snapshot
read/write and every exception completion.

The lock statistics indicate that this mutex is a bottleneck (average
wait time ~480 usecs for 8 processes doing random 4K writes to the
origin device) preventing dm-snapshot to scale as the number of threads
doing IO increases.

The major contention points are __origin_write()/snapshot_map() and
pending_complete(), i.e., the submission and completion of pending
exceptions.

Replace this mutex with a rw semaphore.

We essentially revert commit ae1093be5a0ef9 ("dm snapshot: use mutex
instead of rw_semaphore") and together with the next two patches we
substitute the single mutex with a fine-grained locking scheme, where we
use a read-write semaphore to protect the mostly read fields of the
snapshot structure, e.g., valid, active, etc., and per-bucket bit
spinlocks to protect accesses to the complete and pending exception
tables.

Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Signed-off-by: Ilias Tsitsimpis <iliastsi@arrikto.com>
---
 drivers/md/dm-snap.c | 88 +++++++++++++++++++++++++---------------------------
 1 file changed, 43 insertions(+), 45 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 4b34bfa0900a..209da5dd0ba6 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -48,7 +48,7 @@ struct dm_exception_table {
 };
 
 struct dm_snapshot {
-	struct mutex lock;
+	struct rw_semaphore lock;
 
 	struct dm_dev *origin;
 	struct dm_dev *cow;
@@ -457,9 +457,9 @@ static int __find_snapshots_sharing_cow(struct dm_snapshot *snap,
 		if (!bdev_equal(s->cow->bdev, snap->cow->bdev))
 			continue;
 
-		mutex_lock(&s->lock);
+		down_read(&s->lock);
 		active = s->active;
-		mutex_unlock(&s->lock);
+		up_read(&s->lock);
 
 		if (active) {
 			if (snap_src)
@@ -927,7 +927,7 @@ static int remove_single_exception_chunk(struct dm_snapshot *s)
 	int r;
 	chunk_t old_chunk = s->first_merging_chunk + s->num_merging_chunks - 1;
 
-	mutex_lock(&s->lock);
+	down_write(&s->lock);
 
 	/*
 	 * Process chunks (and associated exceptions) in reverse order
@@ -942,7 +942,7 @@ static int remove_single_exception_chunk(struct dm_snapshot *s)
 	b = __release_queued_bios_after_merge(s);
 
 out:
-	mutex_unlock(&s->lock);
+	up_write(&s->lock);
 	if (b)
 		flush_bios(b);
 
@@ -1001,9 +1001,9 @@ static void snapshot_merge_next_chunks(struct dm_snapshot *s)
 		if (linear_chunks < 0) {
 			DMERR("Read error in exception store: "
 			      "shutting down merge");
-			mutex_lock(&s->lock);
+			down_write(&s->lock);
 			s->merge_failed = 1;
-			mutex_unlock(&s->lock);
+			up_write(&s->lock);
 		}
 		goto shut;
 	}
@@ -1044,10 +1044,10 @@ static void snapshot_merge_next_chunks(struct dm_snapshot *s)
 		previous_count = read_pending_exceptions_done_count();
 	}
 
-	mutex_lock(&s->lock);
+	down_write(&s->lock);
 	s->first_merging_chunk = old_chunk;
 	s->num_merging_chunks = linear_chunks;
-	mutex_unlock(&s->lock);
+	up_write(&s->lock);
 
 	/* Wait until writes to all 'linear_chunks' drain */
 	for (i = 0; i < linear_chunks; i++)
@@ -1089,10 +1089,10 @@ static void merge_callback(int read_err, unsigned long write_err, void *context)
 	return;
 
 shut:
-	mutex_lock(&s->lock);
+	down_write(&s->lock);
 	s->merge_failed = 1;
 	b = __release_queued_bios_after_merge(s);
-	mutex_unlock(&s->lock);
+	up_write(&s->lock);
 	error_bios(b);
 
 	merge_shutdown(s);
@@ -1191,7 +1191,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	s->exception_start_sequence = 0;
 	s->exception_complete_sequence = 0;
 	s->out_of_order_tree = RB_ROOT;
-	mutex_init(&s->lock);
+	init_rwsem(&s->lock);
 	INIT_LIST_HEAD(&s->list);
 	spin_lock_init(&s->pe_lock);
 	s->state_bits = 0;
@@ -1357,9 +1357,9 @@ static void snapshot_dtr(struct dm_target *ti)
 	/* Check whether exception handover must be cancelled */
 	(void) __find_snapshots_sharing_cow(s, &snap_src, &snap_dest, NULL);
 	if (snap_src && snap_dest && (s == snap_src)) {
-		mutex_lock(&snap_dest->lock);
+		down_write(&snap_dest->lock);
 		snap_dest->valid = 0;
-		mutex_unlock(&snap_dest->lock);
+		up_write(&snap_dest->lock);
 		DMERR("Cancelling snapshot handover.");
 	}
 	up_read(&_origins_lock);
@@ -1390,8 +1390,6 @@ static void snapshot_dtr(struct dm_target *ti)
 
 	dm_exception_store_destroy(s->store);
 
-	mutex_destroy(&s->lock);
-
 	dm_put_device(ti, s->cow);
 
 	dm_put_device(ti, s->origin);
@@ -1479,7 +1477,7 @@ static void pending_complete(void *context, int success)
 
 	if (!success) {
 		/* Read/write error - snapshot is unusable */
-		mutex_lock(&s->lock);
+		down_write(&s->lock);
 		__invalidate_snapshot(s, -EIO);
 		error = 1;
 		goto out;
@@ -1487,14 +1485,14 @@ static void pending_complete(void *context, int success)
 
 	e = alloc_completed_exception(GFP_NOIO);
 	if (!e) {
-		mutex_lock(&s->lock);
+		down_write(&s->lock);
 		__invalidate_snapshot(s, -ENOMEM);
 		error = 1;
 		goto out;
 	}
 	*e = pe->e;
 
-	mutex_lock(&s->lock);
+	down_write(&s->lock);
 	if (!s->valid) {
 		free_completed_exception(e);
 		error = 1;
@@ -1512,9 +1510,9 @@ static void pending_complete(void *context, int success)
 
 	/* Wait for conflicting reads to drain */
 	if (__chunk_is_tracked(s, pe->e.old_chunk)) {
-		mutex_unlock(&s->lock);
+		up_write(&s->lock);
 		__check_for_conflicting_io(s, pe->e.old_chunk);
-		mutex_lock(&s->lock);
+		down_write(&s->lock);
 	}
 
 out:
@@ -1527,7 +1525,7 @@ static void pending_complete(void *context, int success)
 		full_bio->bi_end_io = pe->full_bio_end_io;
 	increment_pending_exceptions_done_count();
 
-	mutex_unlock(&s->lock);
+	up_write(&s->lock);
 
 	/* Submit any pending write bios */
 	if (error) {
@@ -1750,7 +1748,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 	if (!s->valid)
 		return DM_MAPIO_KILL;
 
-	mutex_lock(&s->lock);
+	down_write(&s->lock);
 
 	if (!s->valid || (unlikely(s->snapshot_overflowed) &&
 	    bio_data_dir(bio) == WRITE)) {
@@ -1773,9 +1771,9 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 	if (bio_data_dir(bio) == WRITE) {
 		pe = __lookup_pending_exception(s, chunk);
 		if (!pe) {
-			mutex_unlock(&s->lock);
+			up_write(&s->lock);
 			pe = alloc_pending_exception(s);
-			mutex_lock(&s->lock);
+			down_write(&s->lock);
 
 			if (!s->valid || s->snapshot_overflowed) {
 				free_pending_exception(pe);
@@ -1810,7 +1808,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 		    bio->bi_iter.bi_size ==
 		    (s->store->chunk_size << SECTOR_SHIFT)) {
 			pe->started = 1;
-			mutex_unlock(&s->lock);
+			up_write(&s->lock);
 			start_full_bio(pe, bio);
 			goto out;
 		}
@@ -1820,7 +1818,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 		if (!pe->started) {
 			/* this is protected by snap->lock */
 			pe->started = 1;
-			mutex_unlock(&s->lock);
+			up_write(&s->lock);
 			start_copy(pe);
 			goto out;
 		}
@@ -1830,7 +1828,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 	}
 
 out_unlock:
-	mutex_unlock(&s->lock);
+	up_write(&s->lock);
 out:
 	return r;
 }
@@ -1866,7 +1864,7 @@ static int snapshot_merge_map(struct dm_target *ti, struct bio *bio)
 
 	chunk = sector_to_chunk(s->store, bio->bi_iter.bi_sector);
 
-	mutex_lock(&s->lock);
+	down_write(&s->lock);
 
 	/* Full merging snapshots are redirected to the origin */
 	if (!s->valid)
@@ -1897,12 +1895,12 @@ static int snapshot_merge_map(struct dm_target *ti, struct bio *bio)
 	bio_set_dev(bio, s->origin->bdev);
 
 	if (bio_data_dir(bio) == WRITE) {
-		mutex_unlock(&s->lock);
+		up_write(&s->lock);
 		return do_origin(s->origin, bio);
 	}
 
 out_unlock:
-	mutex_unlock(&s->lock);
+	up_write(&s->lock);
 
 	return r;
 }
@@ -1934,7 +1932,7 @@ static int snapshot_preresume(struct dm_target *ti)
 	down_read(&_origins_lock);
 	(void) __find_snapshots_sharing_cow(s, &snap_src, &snap_dest, NULL);
 	if (snap_src && snap_dest) {
-		mutex_lock(&snap_src->lock);
+		down_read(&snap_src->lock);
 		if (s == snap_src) {
 			DMERR("Unable to resume snapshot source until "
 			      "handover completes.");
@@ -1944,7 +1942,7 @@ static int snapshot_preresume(struct dm_target *ti)
 			      "source is suspended.");
 			r = -EINVAL;
 		}
-		mutex_unlock(&snap_src->lock);
+		up_read(&snap_src->lock);
 	}
 	up_read(&_origins_lock);
 
@@ -1990,11 +1988,11 @@ static void snapshot_resume(struct dm_target *ti)
 
 	(void) __find_snapshots_sharing_cow(s, &snap_src, &snap_dest, NULL);
 	if (snap_src && snap_dest) {
-		mutex_lock(&snap_src->lock);
-		mutex_lock_nested(&snap_dest->lock, SINGLE_DEPTH_NESTING);
+		down_write(&snap_src->lock);
+		down_write_nested(&snap_dest->lock, SINGLE_DEPTH_NESTING);
 		__handover_exceptions(snap_src, snap_dest);
-		mutex_unlock(&snap_dest->lock);
-		mutex_unlock(&snap_src->lock);
+		up_write(&snap_dest->lock);
+		up_write(&snap_src->lock);
 	}
 
 	up_read(&_origins_lock);
@@ -2009,9 +2007,9 @@ static void snapshot_resume(struct dm_target *ti)
 	/* Now we have correct chunk size, reregister */
 	reregister_snapshot(s);
 
-	mutex_lock(&s->lock);
+	down_write(&s->lock);
 	s->active = 1;
-	mutex_unlock(&s->lock);
+	up_write(&s->lock);
 }
 
 static uint32_t get_origin_minimum_chunksize(struct block_device *bdev)
@@ -2051,7 +2049,7 @@ static void snapshot_status(struct dm_target *ti, status_type_t type,
 	switch (type) {
 	case STATUSTYPE_INFO:
 
-		mutex_lock(&snap->lock);
+		down_write(&snap->lock);
 
 		if (!snap->valid)
 			DMEMIT("Invalid");
@@ -2076,7 +2074,7 @@ static void snapshot_status(struct dm_target *ti, status_type_t type,
 				DMEMIT("Unknown");
 		}
 
-		mutex_unlock(&snap->lock);
+		up_write(&snap->lock);
 
 		break;
 
@@ -2142,7 +2140,7 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
 		if (dm_target_is_snapshot_merge(snap->ti))
 			continue;
 
-		mutex_lock(&snap->lock);
+		down_write(&snap->lock);
 
 		/* Only deal with valid and active snapshots */
 		if (!snap->valid || !snap->active)
@@ -2169,9 +2167,9 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
 			if (e)
 				goto next_snapshot;
 
-			mutex_unlock(&snap->lock);
+			up_write(&snap->lock);
 			pe = alloc_pending_exception(snap);
-			mutex_lock(&snap->lock);
+			down_write(&snap->lock);
 
 			if (!snap->valid) {
 				free_pending_exception(pe);
@@ -2221,7 +2219,7 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
 		}
 
 next_snapshot:
-		mutex_unlock(&snap->lock);
+		up_write(&snap->lock);
 
 		if (pe_to_start_now) {
 			start_copy(pe_to_start_now);
-- 
2.11.0
