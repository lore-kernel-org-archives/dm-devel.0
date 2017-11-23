From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-snapshot: use mutex instead of rw-semaphore
Date: Thu, 23 Nov 2017 16:15:43 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1711231615160.2217@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

The rw-semaphore is acquired for read only on two places, none of them is
performance-critical. So, we can replace it with a mutex.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap.c |   82 +++++++++++++++++++++++++--------------------------
 1 file changed, 41 insertions(+), 41 deletions(-)

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -47,7 +47,7 @@ struct dm_exception_table {
 };
 
 struct dm_snapshot {
-	struct rw_semaphore lock;
+	struct mutex lock;
 
 	struct dm_dev *origin;
 	struct dm_dev *cow;
@@ -439,9 +439,9 @@ static int __find_snapshots_sharing_cow(
 		if (!bdev_equal(s->cow->bdev, snap->cow->bdev))
 			continue;
 
-		down_read(&s->lock);
+		mutex_lock(&s->lock);
 		active = s->active;
-		up_read(&s->lock);
+		mutex_unlock(&s->lock);
 
 		if (active) {
 			if (snap_src)
@@ -909,7 +909,7 @@ static int remove_single_exception_chunk
 	int r;
 	chunk_t old_chunk = s->first_merging_chunk + s->num_merging_chunks - 1;
 
-	down_write(&s->lock);
+	mutex_lock(&s->lock);
 
 	/*
 	 * Process chunks (and associated exceptions) in reverse order
@@ -924,7 +924,7 @@ static int remove_single_exception_chunk
 	b = __release_queued_bios_after_merge(s);
 
 out:
-	up_write(&s->lock);
+	mutex_unlock(&s->lock);
 	if (b)
 		flush_bios(b);
 
@@ -983,9 +983,9 @@ static void snapshot_merge_next_chunks(s
 		if (linear_chunks < 0) {
 			DMERR("Read error in exception store: "
 			      "shutting down merge");
-			down_write(&s->lock);
+			mutex_lock(&s->lock);
 			s->merge_failed = 1;
-			up_write(&s->lock);
+			mutex_unlock(&s->lock);
 		}
 		goto shut;
 	}
@@ -1026,10 +1026,10 @@ static void snapshot_merge_next_chunks(s
 		previous_count = read_pending_exceptions_done_count();
 	}
 
-	down_write(&s->lock);
+	mutex_lock(&s->lock);
 	s->first_merging_chunk = old_chunk;
 	s->num_merging_chunks = linear_chunks;
-	up_write(&s->lock);
+	mutex_unlock(&s->lock);
 
 	/* Wait until writes to all 'linear_chunks' drain */
 	for (i = 0; i < linear_chunks; i++)
@@ -1071,10 +1071,10 @@ static void merge_callback(int read_err,
 	return;
 
 shut:
-	down_write(&s->lock);
+	mutex_lock(&s->lock);
 	s->merge_failed = 1;
 	b = __release_queued_bios_after_merge(s);
-	up_write(&s->lock);
+	mutex_unlock(&s->lock);
 	error_bios(b);
 
 	merge_shutdown(s);
@@ -1173,7 +1173,7 @@ static int snapshot_ctr(struct dm_target
 	s->exception_start_sequence = 0;
 	s->exception_complete_sequence = 0;
 	INIT_LIST_HEAD(&s->out_of_order_list);
-	init_rwsem(&s->lock);
+	mutex_init(&s->lock);
 	INIT_LIST_HEAD(&s->list);
 	spin_lock_init(&s->pe_lock);
 	s->state_bits = 0;
@@ -1338,9 +1338,9 @@ static void snapshot_dtr(struct dm_targe
 	/* Check whether exception handover must be cancelled */
 	(void) __find_snapshots_sharing_cow(s, &snap_src, &snap_dest, NULL);
 	if (snap_src && snap_dest && (s == snap_src)) {
-		down_write(&snap_dest->lock);
+		mutex_lock(&snap_dest->lock);
 		snap_dest->valid = 0;
-		up_write(&snap_dest->lock);
+		mutex_unlock(&snap_dest->lock);
 		DMERR("Cancelling snapshot handover.");
 	}
 	up_read(&_origins_lock);
@@ -1458,7 +1458,7 @@ static void pending_complete(void *conte
 
 	if (!success) {
 		/* Read/write error - snapshot is unusable */
-		down_write(&s->lock);
+		mutex_lock(&s->lock);
 		__invalidate_snapshot(s, -EIO);
 		error = 1;
 		goto out;
@@ -1466,14 +1466,14 @@ static void pending_complete(void *conte
 
 	e = alloc_completed_exception(GFP_NOIO);
 	if (!e) {
-		down_write(&s->lock);
+		mutex_lock(&s->lock);
 		__invalidate_snapshot(s, -ENOMEM);
 		error = 1;
 		goto out;
 	}
 	*e = pe->e;
 
-	down_write(&s->lock);
+	mutex_lock(&s->lock);
 	if (!s->valid) {
 		free_completed_exception(e);
 		error = 1;
@@ -1498,7 +1498,7 @@ out:
 		full_bio->bi_end_io = pe->full_bio_end_io;
 	increment_pending_exceptions_done_count();
 
-	up_write(&s->lock);
+	mutex_unlock(&s->lock);
 
 	/* Submit any pending write bios */
 	if (error) {
@@ -1694,7 +1694,7 @@ static int snapshot_map(struct dm_target
 
 	/* FIXME: should only take write lock if we need
 	 * to copy an exception */
-	down_write(&s->lock);
+	mutex_lock(&s->lock);
 
 	if (!s->valid || (unlikely(s->snapshot_overflowed) &&
 	    bio_data_dir(bio) == WRITE)) {
@@ -1717,9 +1717,9 @@ static int snapshot_map(struct dm_target
 	if (bio_data_dir(bio) == WRITE) {
 		pe = __lookup_pending_exception(s, chunk);
 		if (!pe) {
-			up_write(&s->lock);
+			mutex_unlock(&s->lock);
 			pe = alloc_pending_exception(s);
-			down_write(&s->lock);
+			mutex_lock(&s->lock);
 
 			if (!s->valid || s->snapshot_overflowed) {
 				free_pending_exception(pe);
@@ -1754,7 +1754,7 @@ static int snapshot_map(struct dm_target
 		    bio->bi_iter.bi_size ==
 		    (s->store->chunk_size << SECTOR_SHIFT)) {
 			pe->started = 1;
-			up_write(&s->lock);
+			mutex_unlock(&s->lock);
 			start_full_bio(pe, bio);
 			goto out;
 		}
@@ -1764,7 +1764,7 @@ static int snapshot_map(struct dm_target
 		if (!pe->started) {
 			/* this is protected by snap->lock */
 			pe->started = 1;
-			up_write(&s->lock);
+			mutex_unlock(&s->lock);
 			start_copy(pe);
 			goto out;
 		}
@@ -1774,7 +1774,7 @@ static int snapshot_map(struct dm_target
 	}
 
 out_unlock:
-	up_write(&s->lock);
+	mutex_unlock(&s->lock);
 out:
 	return r;
 }
@@ -1810,7 +1810,7 @@ static int snapshot_merge_map(struct dm_
 
 	chunk = sector_to_chunk(s->store, bio->bi_iter.bi_sector);
 
-	down_write(&s->lock);
+	mutex_lock(&s->lock);
 
 	/* Full merging snapshots are redirected to the origin */
 	if (!s->valid)
@@ -1841,12 +1841,12 @@ redirect_to_origin:
 	bio_set_dev(bio, s->origin->bdev);
 
 	if (bio_data_dir(bio) == WRITE) {
-		up_write(&s->lock);
+		mutex_unlock(&s->lock);
 		return do_origin(s->origin, bio);
 	}
 
 out_unlock:
-	up_write(&s->lock);
+	mutex_unlock(&s->lock);
 
 	return r;
 }
@@ -1878,7 +1878,7 @@ static int snapshot_preresume(struct dm_
 	down_read(&_origins_lock);
 	(void) __find_snapshots_sharing_cow(s, &snap_src, &snap_dest, NULL);
 	if (snap_src && snap_dest) {
-		down_read(&snap_src->lock);
+		mutex_lock(&snap_src->lock);
 		if (s == snap_src) {
 			DMERR("Unable to resume snapshot source until "
 			      "handover completes.");
@@ -1888,7 +1888,7 @@ static int snapshot_preresume(struct dm_
 			      "source is suspended.");
 			r = -EINVAL;
 		}
-		up_read(&snap_src->lock);
+		mutex_unlock(&snap_src->lock);
 	}
 	up_read(&_origins_lock);
 
@@ -1934,11 +1934,11 @@ static void snapshot_resume(struct dm_ta
 
 	(void) __find_snapshots_sharing_cow(s, &snap_src, &snap_dest, NULL);
 	if (snap_src && snap_dest) {
-		down_write(&snap_src->lock);
-		down_write_nested(&snap_dest->lock, SINGLE_DEPTH_NESTING);
+		mutex_lock(&snap_src->lock);
+		mutex_lock_nested(&snap_dest->lock, SINGLE_DEPTH_NESTING);
 		__handover_exceptions(snap_src, snap_dest);
-		up_write(&snap_dest->lock);
-		up_write(&snap_src->lock);
+		mutex_unlock(&snap_dest->lock);
+		mutex_unlock(&snap_src->lock);
 	}
 
 	up_read(&_origins_lock);
@@ -1953,9 +1953,9 @@ static void snapshot_resume(struct dm_ta
 	/* Now we have correct chunk size, reregister */
 	reregister_snapshot(s);
 
-	down_write(&s->lock);
+	mutex_lock(&s->lock);
 	s->active = 1;
-	up_write(&s->lock);
+	mutex_unlock(&s->lock);
 }
 
 static uint32_t get_origin_minimum_chunksize(struct block_device *bdev)
@@ -1995,7 +1995,7 @@ static void snapshot_status(struct dm_ta
 	switch (type) {
 	case STATUSTYPE_INFO:
 
-		down_write(&snap->lock);
+		mutex_lock(&snap->lock);
 
 		if (!snap->valid)
 			DMEMIT("Invalid");
@@ -2020,7 +2020,7 @@ static void snapshot_status(struct dm_ta
 				DMEMIT("Unknown");
 		}
 
-		up_write(&snap->lock);
+		mutex_unlock(&snap->lock);
 
 		break;
 
@@ -2086,7 +2086,7 @@ static int __origin_write(struct list_he
 		if (dm_target_is_snapshot_merge(snap->ti))
 			continue;
 
-		down_write(&snap->lock);
+		mutex_lock(&snap->lock);
 
 		/* Only deal with valid and active snapshots */
 		if (!snap->valid || !snap->active)
@@ -2113,9 +2113,9 @@ static int __origin_write(struct list_he
 
 		pe = __lookup_pending_exception(snap, chunk);
 		if (!pe) {
-			up_write(&snap->lock);
+			mutex_unlock(&snap->lock);
 			pe = alloc_pending_exception(snap);
-			down_write(&snap->lock);
+			mutex_lock(&snap->lock);
 
 			if (!snap->valid) {
 				free_pending_exception(pe);
@@ -2158,7 +2158,7 @@ static int __origin_write(struct list_he
 		}
 
 next_snapshot:
-		up_write(&snap->lock);
+		mutex_unlock(&snap->lock);
 
 		if (pe_to_start_now) {
 			start_copy(pe_to_start_now);
