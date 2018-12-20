From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: [PATCH 3/3] dm snapshot: Use fine-grained locking scheme
Date: Thu, 20 Dec 2018 20:06:51 +0200
Message-ID: <20181220180651.4879-4-ntsironis@arrikto.com>
References: <20181220180651.4879-1-ntsironis@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181220180651.4879-1-ntsironis@arrikto.com>
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

Substitute the single mutex with a fine-grained locking scheme. Use a
read-write semaphore to protect the mostly read fields of the snapshot
structure, e.g., valid, active, etc., and per-bucket bit spinlocks to
protect accesses to the complete and pending exception tables.

This scheme allows dm-snapshot to scale better, resulting in increased
IOPS and reduced latency.

Following are some benchmark results using the null_blk device:

  modprobe null_blk gb=1024 bs=512 submit_queues=8 hw_queue_depth=4096 \
   queue_mode=2 irqmode=1 completion_nsec=1 nr_devices=1

* Benchmark fio_origin_randwrite_throughput_N, from the device mapper
  test suite [1] (direct IO, random 4K writes to origin device, IO
  engine libaio):

  +--------------+-------------+------------+
  | # of workers | IOPS Before | IOPS After |
  +--------------+-------------+------------+
  |      1       |    57708    |   66421    |
  |      2       |    63415    |   77589    |
  |      4       |    67276    |   98839    |
  |      8       |    60564    |   109258   |
  +--------------+-------------+------------+

* Benchmark fio_origin_randwrite_latency_N, from the device mapper test
  suite [1] (direct IO, random 4K writes to origin device, IO engine
  psync):

  +--------------+-----------------------+----------------------+
  | # of workers | Latency (usec) Before | Latency (usec) After |
  +--------------+-----------------------+----------------------+
  |      1       |         16.25         |        13.27         |
  |      2       |         31.65         |        25.08         |
  |      4       |         55.28         |        41.08         |
  |      8       |         121.47        |        74.44         |
  +--------------+-----------------------+----------------------+

* Benchmark fio_snapshot_randwrite_throughput_N, from the device mapper
  test suite [1] (direct IO, random 4K writes to snapshot device, IO
  engine libaio):

  +--------------+-------------+------------+
  | # of workers | IOPS Before | IOPS After |
  +--------------+-------------+------------+
  |      1       |    72593    |   84938    |
  |      2       |    97379    |   134973   |
  |      4       |    90610    |   143077   |
  |      8       |    90537    |   180085   |
  +--------------+-------------+------------+

* Benchmark fio_snapshot_randwrite_latency_N, from the device mapper
  test suite [1] (direct IO, random 4K writes to snapshot device, IO
  engine psync):

  +--------------+-----------------------+----------------------+
  | # of workers | Latency (usec) Before | Latency (usec) After |
  +--------------+-----------------------+----------------------+
  |      1       |         12.53         |         10.6         |
  |      2       |         19.78         |        14.89         |
  |      4       |         40.37         |        23.47         |
  |      8       |         89.32         |        48.48         |
  +--------------+-----------------------+----------------------+

[1] https://github.com/jthornber/device-mapper-test-suite

Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Signed-off-by: Ilias Tsitsimpis <iliastsi@arrikto.com>
---
 drivers/md/dm-exception-store.h |   3 +-
 drivers/md/dm-snap.c            | 273 +++++++++++++++++++++++++++-------------
 2 files changed, 185 insertions(+), 91 deletions(-)

diff --git a/drivers/md/dm-exception-store.h b/drivers/md/dm-exception-store.h
index 12b5216c2cfe..5a3c696c057f 100644
--- a/drivers/md/dm-exception-store.h
+++ b/drivers/md/dm-exception-store.h
@@ -11,6 +11,7 @@
 #define _LINUX_DM_EXCEPTION_STORE
 
 #include <linux/blkdev.h>
+#include <linux/list_bl.h>
 #include <linux/device-mapper.h>
 
 /*
@@ -27,7 +28,7 @@ typedef sector_t chunk_t;
  * chunk within the device.
  */
 struct dm_exception {
-	struct list_head hash_list;
+	struct hlist_bl_node hash_list;
 
 	chunk_t old_chunk;
 	chunk_t new_chunk;
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 4b34bfa0900a..4530d0620a72 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/kdev_t.h>
 #include <linux/list.h>
+#include <linux/list_bl.h>
 #include <linux/mempool.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -44,11 +45,11 @@ static const char dm_snapshot_merge_target_name[] = "snapshot-merge";
 struct dm_exception_table {
 	uint32_t hash_mask;
 	unsigned hash_shift;
-	struct list_head *table;
+	struct hlist_bl_head *table;
 };
 
 struct dm_snapshot {
-	struct mutex lock;
+	struct rw_semaphore lock;
 
 	struct dm_dev *origin;
 	struct dm_dev *cow;
@@ -76,7 +77,9 @@ struct dm_snapshot {
 
 	atomic_t pending_exceptions_count;
 
-	/* Protected by "lock" */
+	spinlock_t pe_allocation_lock;
+
+	/* Protected by "pe_allocation_lock" */
 	sector_t exception_start_sequence;
 
 	/* Protected by kcopyd single-threaded callback */
@@ -457,9 +460,9 @@ static int __find_snapshots_sharing_cow(struct dm_snapshot *snap,
 		if (!bdev_equal(s->cow->bdev, snap->cow->bdev))
 			continue;
 
-		mutex_lock(&s->lock);
+		down_read(&s->lock);
 		active = s->active;
-		mutex_unlock(&s->lock);
+		up_read(&s->lock);
 
 		if (active) {
 			if (snap_src)
@@ -618,6 +621,36 @@ static void unregister_snapshot(struct dm_snapshot *s)
  * The lowest hash_shift bits of the chunk number are ignored, allowing
  * some consecutive chunks to be grouped together.
  */
+static uint32_t exception_hash(struct dm_exception_table *et, chunk_t chunk);
+
+/* Lock to protect access to the completed and pending exception hash tables. */
+struct dm_exception_table_lock {
+	struct hlist_bl_head *complete_slot;
+	struct hlist_bl_head *pending_slot;
+};
+
+static void dm_exception_table_lock_init(struct dm_snapshot *s, chunk_t chunk,
+					 struct dm_exception_table_lock *lock)
+{
+	struct dm_exception_table *complete = &s->complete;
+	struct dm_exception_table *pending = &s->pending;
+
+	lock->complete_slot = &complete->table[exception_hash(complete, chunk)];
+	lock->pending_slot = &pending->table[exception_hash(pending, chunk)];
+}
+
+static void dm_exception_table_lock(struct dm_exception_table_lock *lock)
+{
+	hlist_bl_lock(lock->complete_slot);
+	hlist_bl_lock(lock->pending_slot);
+}
+
+static void dm_exception_table_unlock(struct dm_exception_table_lock *lock)
+{
+	hlist_bl_unlock(lock->pending_slot);
+	hlist_bl_unlock(lock->complete_slot);
+}
+
 static int dm_exception_table_init(struct dm_exception_table *et,
 				   uint32_t size, unsigned hash_shift)
 {
@@ -625,12 +658,12 @@ static int dm_exception_table_init(struct dm_exception_table *et,
 
 	et->hash_shift = hash_shift;
 	et->hash_mask = size - 1;
-	et->table = dm_vcalloc(size, sizeof(struct list_head));
+	et->table = dm_vcalloc(size, sizeof(struct hlist_bl_head));
 	if (!et->table)
 		return -ENOMEM;
 
 	for (i = 0; i < size; i++)
-		INIT_LIST_HEAD(et->table + i);
+		INIT_HLIST_BL_HEAD(et->table + i);
 
 	return 0;
 }
@@ -638,15 +671,16 @@ static int dm_exception_table_init(struct dm_exception_table *et,
 static void dm_exception_table_exit(struct dm_exception_table *et,
 				    struct kmem_cache *mem)
 {
-	struct list_head *slot;
-	struct dm_exception *ex, *next;
+	struct hlist_bl_head *slot;
+	struct dm_exception *ex;
+	struct hlist_bl_node *pos, *n;
 	int i, size;
 
 	size = et->hash_mask + 1;
 	for (i = 0; i < size; i++) {
 		slot = et->table + i;
 
-		list_for_each_entry_safe (ex, next, slot, hash_list)
+		hlist_bl_for_each_entry_safe(ex, pos, n, slot, hash_list)
 			kmem_cache_free(mem, ex);
 	}
 
@@ -660,7 +694,7 @@ static uint32_t exception_hash(struct dm_exception_table *et, chunk_t chunk)
 
 static void dm_remove_exception(struct dm_exception *e)
 {
-	list_del(&e->hash_list);
+	hlist_bl_del(&e->hash_list);
 }
 
 /*
@@ -670,11 +704,12 @@ static void dm_remove_exception(struct dm_exception *e)
 static struct dm_exception *dm_lookup_exception(struct dm_exception_table *et,
 						chunk_t chunk)
 {
-	struct list_head *slot;
+	struct hlist_bl_head *slot;
+	struct hlist_bl_node *pos;
 	struct dm_exception *e;
 
 	slot = &et->table[exception_hash(et, chunk)];
-	list_for_each_entry (e, slot, hash_list)
+	hlist_bl_for_each_entry(e, pos, slot, hash_list)
 		if (chunk >= e->old_chunk &&
 		    chunk <= e->old_chunk + dm_consecutive_chunk_count(e))
 			return e;
@@ -721,7 +756,8 @@ static void free_pending_exception(struct dm_snap_pending_exception *pe)
 static void dm_insert_exception(struct dm_exception_table *eh,
 				struct dm_exception *new_e)
 {
-	struct list_head *l;
+	struct hlist_bl_head *l;
+	struct hlist_bl_node *pos;
 	struct dm_exception *e = NULL;
 
 	l = &eh->table[exception_hash(eh, new_e->old_chunk)];
@@ -731,7 +767,7 @@ static void dm_insert_exception(struct dm_exception_table *eh,
 		goto out;
 
 	/* List is ordered by old_chunk */
-	list_for_each_entry_reverse(e, l, hash_list) {
+	hlist_bl_for_each_entry(e, pos, l, hash_list) {
 		/* Insert after an existing chunk? */
 		if (new_e->old_chunk == (e->old_chunk +
 					 dm_consecutive_chunk_count(e) + 1) &&
@@ -752,12 +788,24 @@ static void dm_insert_exception(struct dm_exception_table *eh,
 			return;
 		}
 
-		if (new_e->old_chunk > e->old_chunk)
+		if (new_e->old_chunk < e->old_chunk)
 			break;
 	}
 
 out:
-	list_add(&new_e->hash_list, e ? &e->hash_list : l);
+	if (!e) {
+		/*
+		 * Either the table doesn't support consecutive chunks or slot
+		 * l is empty.
+		 */
+		hlist_bl_add_head(&new_e->hash_list, l);
+	} else if (new_e->old_chunk < e->old_chunk) {
+		/* Add before an existing exception */
+		hlist_bl_add_before(&new_e->hash_list, &e->hash_list);
+	} else {
+		/* Add to l's tail: e is the last exception in this slot */
+		hlist_bl_add_behind(&new_e->hash_list, &e->hash_list);
+	}
 }
 
 /*
@@ -766,6 +814,7 @@ static void dm_insert_exception(struct dm_exception_table *eh,
  */
 static int dm_add_exception(void *context, chunk_t old, chunk_t new)
 {
+	struct dm_exception_table_lock lock;
 	struct dm_snapshot *s = context;
 	struct dm_exception *e;
 
@@ -778,7 +827,17 @@ static int dm_add_exception(void *context, chunk_t old, chunk_t new)
 	/* Consecutive_count is implicitly initialised to zero */
 	e->new_chunk = new;
 
+	/*
+	 * Although there is no need to lock access to the exception tables
+	 * here, if we don't then hlist_bl_add_head(), called by
+	 * dm_insert_exception(), will complain about accessing the
+	 * corresponding list without locking it first.
+	 */
+	dm_exception_table_lock_init(s, old, &lock);
+
+	dm_exception_table_lock(&lock);
 	dm_insert_exception(&s->complete, e);
+	dm_exception_table_unlock(&lock);
 
 	return 0;
 }
@@ -807,7 +866,7 @@ static int calc_max_buckets(void)
 {
 	/* use a fixed size of 2MB */
 	unsigned long mem = 2 * 1024 * 1024;
-	mem /= sizeof(struct list_head);
+	mem /= sizeof(struct hlist_bl_head);
 
 	return mem;
 }
@@ -927,7 +986,7 @@ static int remove_single_exception_chunk(struct dm_snapshot *s)
 	int r;
 	chunk_t old_chunk = s->first_merging_chunk + s->num_merging_chunks - 1;
 
-	mutex_lock(&s->lock);
+	down_write(&s->lock);
 
 	/*
 	 * Process chunks (and associated exceptions) in reverse order
@@ -942,7 +1001,7 @@ static int remove_single_exception_chunk(struct dm_snapshot *s)
 	b = __release_queued_bios_after_merge(s);
 
 out:
-	mutex_unlock(&s->lock);
+	up_write(&s->lock);
 	if (b)
 		flush_bios(b);
 
@@ -1001,9 +1060,9 @@ static void snapshot_merge_next_chunks(struct dm_snapshot *s)
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
@@ -1044,10 +1103,10 @@ static void snapshot_merge_next_chunks(struct dm_snapshot *s)
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
@@ -1089,10 +1148,10 @@ static void merge_callback(int read_err, unsigned long write_err, void *context)
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
@@ -1188,10 +1247,11 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	s->snapshot_overflowed = 0;
 	s->active = 0;
 	atomic_set(&s->pending_exceptions_count, 0);
+	spin_lock_init(&s->pe_allocation_lock);
 	s->exception_start_sequence = 0;
 	s->exception_complete_sequence = 0;
 	s->out_of_order_tree = RB_ROOT;
-	mutex_init(&s->lock);
+	init_rwsem(&s->lock);
 	INIT_LIST_HEAD(&s->list);
 	spin_lock_init(&s->pe_lock);
 	s->state_bits = 0;
@@ -1357,9 +1417,9 @@ static void snapshot_dtr(struct dm_target *ti)
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
@@ -1390,8 +1450,6 @@ static void snapshot_dtr(struct dm_target *ti)
 
 	dm_exception_store_destroy(s->store);
 
-	mutex_destroy(&s->lock);
-
 	dm_put_device(ti, s->cow);
 
 	dm_put_device(ti, s->origin);
@@ -1467,6 +1525,13 @@ static void __invalidate_snapshot(struct dm_snapshot *s, int err)
 	dm_table_event(s->ti->table);
 }
 
+static void invalidate_snapshot(struct dm_snapshot *s, int err)
+{
+	down_write(&s->lock);
+	__invalidate_snapshot(s, err);
+	up_write(&s->lock);
+}
+
 static void pending_complete(void *context, int success)
 {
 	struct dm_snap_pending_exception *pe = context;
@@ -1475,29 +1540,37 @@ static void pending_complete(void *context, int success)
 	struct bio *origin_bios = NULL;
 	struct bio *snapshot_bios = NULL;
 	struct bio *full_bio = NULL;
+	struct dm_exception_table_lock lock;
 	int error = 0;
 
+	dm_exception_table_lock_init(s, pe->e.old_chunk, &lock);
+
 	if (!success) {
 		/* Read/write error - snapshot is unusable */
-		mutex_lock(&s->lock);
-		__invalidate_snapshot(s, -EIO);
+		invalidate_snapshot(s, -EIO);
 		error = 1;
+
+		dm_exception_table_lock(&lock);
 		goto out;
 	}
 
 	e = alloc_completed_exception(GFP_NOIO);
 	if (!e) {
-		mutex_lock(&s->lock);
-		__invalidate_snapshot(s, -ENOMEM);
+		invalidate_snapshot(s, -ENOMEM);
 		error = 1;
+
+		dm_exception_table_lock(&lock);
 		goto out;
 	}
 	*e = pe->e;
 
-	mutex_lock(&s->lock);
+	down_read(&s->lock);
+	dm_exception_table_lock(&lock);
 	if (!s->valid) {
+		up_read(&s->lock);
 		free_completed_exception(e);
 		error = 1;
+
 		goto out;
 	}
 
@@ -1509,17 +1582,21 @@ static void pending_complete(void *context, int success)
 	 * merging can overwrite the chunk in origin.
 	 */
 	dm_insert_exception(&s->complete, e);
+	up_read(&s->lock);
 
 	/* Wait for conflicting reads to drain */
 	if (__chunk_is_tracked(s, pe->e.old_chunk)) {
-		mutex_unlock(&s->lock);
+		dm_exception_table_unlock(&lock);
 		__check_for_conflicting_io(s, pe->e.old_chunk);
-		mutex_lock(&s->lock);
+		dm_exception_table_lock(&lock);
 	}
 
 out:
 	/* Remove the in-flight exception from the list */
 	dm_remove_exception(&pe->e);
+
+	dm_exception_table_unlock(&lock);
+
 	snapshot_bios = bio_list_get(&pe->snapshot_bios);
 	origin_bios = bio_list_get(&pe->origin_bios);
 	full_bio = pe->full_bio;
@@ -1527,8 +1604,6 @@ static void pending_complete(void *context, int success)
 		full_bio->bi_end_io = pe->full_bio_end_io;
 	increment_pending_exceptions_done_count();
 
-	mutex_unlock(&s->lock);
-
 	/* Submit any pending write bios */
 	if (error) {
 		if (full_bio)
@@ -1670,8 +1745,8 @@ __lookup_pending_exception(struct dm_snapshot *s, chunk_t chunk)
 /*
  * Inserts a pending exception into the pending table.
  *
- * NOTE: a write lock must be held on snap->lock before calling
- * this.
+ * NOTE: a write lock must be held on the chunk's pending exception table slot
+ * before calling this.
  */
 static struct dm_snap_pending_exception *
 __insert_pending_exception(struct dm_snapshot *s,
@@ -1683,12 +1758,15 @@ __insert_pending_exception(struct dm_snapshot *s,
 	pe->started = 0;
 	pe->full_bio = NULL;
 
+	spin_lock(&s->pe_allocation_lock);
 	if (s->store->type->prepare_exception(s->store, &pe->e)) {
+		spin_unlock(&s->pe_allocation_lock);
 		free_pending_exception(pe);
 		return NULL;
 	}
 
 	pe->exception_sequence = s->exception_start_sequence++;
+	spin_unlock(&s->pe_allocation_lock);
 
 	dm_insert_exception(&s->pending, &pe->e);
 
@@ -1700,8 +1778,8 @@ __insert_pending_exception(struct dm_snapshot *s,
  * for this chunk, otherwise it allocates a new one and inserts
  * it into the pending table.
  *
- * NOTE: a write lock must be held on snap->lock before calling
- * this.
+ * NOTE: a write lock must be held on the chunk's pending exception table slot
+ * before calling this.
  */
 static struct dm_snap_pending_exception *
 __find_pending_exception(struct dm_snapshot *s,
@@ -1735,6 +1813,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 	int r = DM_MAPIO_REMAPPED;
 	chunk_t chunk;
 	struct dm_snap_pending_exception *pe = NULL;
+	struct dm_exception_table_lock lock;
 
 	init_tracked_chunk(bio);
 
@@ -1744,13 +1823,15 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 	}
 
 	chunk = sector_to_chunk(s->store, bio->bi_iter.bi_sector);
+	dm_exception_table_lock_init(s, chunk, &lock);
 
 	/* Full snapshots are not usable */
 	/* To get here the table must be live so s->active is always set. */
 	if (!s->valid)
 		return DM_MAPIO_KILL;
 
-	mutex_lock(&s->lock);
+	down_read(&s->lock);
+	dm_exception_table_lock(&lock);
 
 	if (!s->valid || (unlikely(s->snapshot_overflowed) &&
 	    bio_data_dir(bio) == WRITE)) {
@@ -1773,15 +1854,9 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 	if (bio_data_dir(bio) == WRITE) {
 		pe = __lookup_pending_exception(s, chunk);
 		if (!pe) {
-			mutex_unlock(&s->lock);
+			dm_exception_table_unlock(&lock);
 			pe = alloc_pending_exception(s);
-			mutex_lock(&s->lock);
-
-			if (!s->valid || s->snapshot_overflowed) {
-				free_pending_exception(pe);
-				r = DM_MAPIO_KILL;
-				goto out_unlock;
-			}
+			dm_exception_table_lock(&lock);
 
 			e = dm_lookup_exception(&s->complete, chunk);
 			if (e) {
@@ -1792,13 +1867,22 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 
 			pe = __find_pending_exception(s, pe, chunk);
 			if (!pe) {
+				dm_exception_table_unlock(&lock);
+				up_read(&s->lock);
+
+				down_write(&s->lock);
+
 				if (s->store->userspace_supports_overflow) {
-					s->snapshot_overflowed = 1;
-					DMERR("Snapshot overflowed: Unable to allocate exception.");
+					if (s->valid && !s->snapshot_overflowed) {
+						s->snapshot_overflowed = 1;
+						DMERR("Snapshot overflowed: Unable to allocate exception.");
+					}
 				} else
 					__invalidate_snapshot(s, -ENOMEM);
+				up_write(&s->lock);
+
 				r = DM_MAPIO_KILL;
-				goto out_unlock;
+				goto out;
 			}
 		}
 
@@ -1810,7 +1894,10 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 		    bio->bi_iter.bi_size ==
 		    (s->store->chunk_size << SECTOR_SHIFT)) {
 			pe->started = 1;
-			mutex_unlock(&s->lock);
+
+			dm_exception_table_unlock(&lock);
+			up_read(&s->lock);
+
 			start_full_bio(pe, bio);
 			goto out;
 		}
@@ -1818,9 +1905,12 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 		bio_list_add(&pe->snapshot_bios, bio);
 
 		if (!pe->started) {
-			/* this is protected by snap->lock */
+			/* this is protected by the exception table lock */
 			pe->started = 1;
-			mutex_unlock(&s->lock);
+
+			dm_exception_table_unlock(&lock);
+			up_read(&s->lock);
+
 			start_copy(pe);
 			goto out;
 		}
@@ -1830,7 +1920,8 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 	}
 
 out_unlock:
-	mutex_unlock(&s->lock);
+	dm_exception_table_unlock(&lock);
+	up_read(&s->lock);
 out:
 	return r;
 }
@@ -1866,7 +1957,7 @@ static int snapshot_merge_map(struct dm_target *ti, struct bio *bio)
 
 	chunk = sector_to_chunk(s->store, bio->bi_iter.bi_sector);
 
-	mutex_lock(&s->lock);
+	down_write(&s->lock);
 
 	/* Full merging snapshots are redirected to the origin */
 	if (!s->valid)
@@ -1897,12 +1988,12 @@ static int snapshot_merge_map(struct dm_target *ti, struct bio *bio)
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
@@ -1934,7 +2025,7 @@ static int snapshot_preresume(struct dm_target *ti)
 	down_read(&_origins_lock);
 	(void) __find_snapshots_sharing_cow(s, &snap_src, &snap_dest, NULL);
 	if (snap_src && snap_dest) {
-		mutex_lock(&snap_src->lock);
+		down_read(&snap_src->lock);
 		if (s == snap_src) {
 			DMERR("Unable to resume snapshot source until "
 			      "handover completes.");
@@ -1944,7 +2035,7 @@ static int snapshot_preresume(struct dm_target *ti)
 			      "source is suspended.");
 			r = -EINVAL;
 		}
-		mutex_unlock(&snap_src->lock);
+		up_read(&snap_src->lock);
 	}
 	up_read(&_origins_lock);
 
@@ -1990,11 +2081,11 @@ static void snapshot_resume(struct dm_target *ti)
 
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
@@ -2009,9 +2100,9 @@ static void snapshot_resume(struct dm_target *ti)
 	/* Now we have correct chunk size, reregister */
 	reregister_snapshot(s);
 
-	mutex_lock(&s->lock);
+	down_write(&s->lock);
 	s->active = 1;
-	mutex_unlock(&s->lock);
+	up_write(&s->lock);
 }
 
 static uint32_t get_origin_minimum_chunksize(struct block_device *bdev)
@@ -2051,7 +2142,7 @@ static void snapshot_status(struct dm_target *ti, status_type_t type,
 	switch (type) {
 	case STATUSTYPE_INFO:
 
-		mutex_lock(&snap->lock);
+		down_write(&snap->lock);
 
 		if (!snap->valid)
 			DMEMIT("Invalid");
@@ -2076,7 +2167,7 @@ static void snapshot_status(struct dm_target *ti, status_type_t type,
 				DMEMIT("Unknown");
 		}
 
-		mutex_unlock(&snap->lock);
+		up_write(&snap->lock);
 
 		break;
 
@@ -2131,6 +2222,7 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
 	struct dm_snap_pending_exception *pe, *pe2;
 	struct dm_snap_pending_exception *pe_to_start_now = NULL;
 	struct dm_snap_pending_exception *pe_to_start_last = NULL;
+	struct dm_exception_table_lock lock;
 	chunk_t chunk;
 
 	/* Do all the snapshots on this origin */
@@ -2142,21 +2234,23 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
 		if (dm_target_is_snapshot_merge(snap->ti))
 			continue;
 
-		mutex_lock(&snap->lock);
-
-		/* Only deal with valid and active snapshots */
-		if (!snap->valid || !snap->active)
-			goto next_snapshot;
-
 		/* Nothing to do if writing beyond end of snapshot */
 		if (sector >= dm_table_get_size(snap->ti->table))
-			goto next_snapshot;
+			continue;
 
 		/*
 		 * Remember, different snapshots can have
 		 * different chunk sizes.
 		 */
 		chunk = sector_to_chunk(snap->store, sector);
+		dm_exception_table_lock_init(snap, chunk, &lock);
+
+		down_read(&snap->lock);
+		dm_exception_table_lock(&lock);
+
+		/* Only deal with valid and active snapshots */
+		if (!snap->valid || !snap->active)
+			goto next_snapshot;
 
 		pe = __lookup_pending_exception(snap, chunk);
 		if (!pe) {
@@ -2169,14 +2263,9 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
 			if (e)
 				goto next_snapshot;
 
-			mutex_unlock(&snap->lock);
+			dm_exception_table_unlock(&lock);
 			pe = alloc_pending_exception(snap);
-			mutex_lock(&snap->lock);
-
-			if (!snap->valid) {
-				free_pending_exception(pe);
-				goto next_snapshot;
-			}
+			dm_exception_table_lock(&lock);
 
 			pe2 = __lookup_pending_exception(snap, chunk);
 
@@ -2189,8 +2278,11 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
 
 				pe = __insert_pending_exception(snap, pe, chunk);
 				if (!pe) {
-					__invalidate_snapshot(snap, -ENOMEM);
-					goto next_snapshot;
+					dm_exception_table_unlock(&lock);
+					up_read(&snap->lock);
+
+					invalidate_snapshot(snap, -ENOMEM);
+					continue;
 				}
 			} else {
 				free_pending_exception(pe);
@@ -2221,7 +2313,8 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
 		}
 
 next_snapshot:
-		mutex_unlock(&snap->lock);
+		dm_exception_table_unlock(&lock);
+		up_read(&snap->lock);
 
 		if (pe_to_start_now) {
 			start_copy(pe_to_start_now);
-- 
2.11.0
