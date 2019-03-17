From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: [PATCH v3 5/6] dm snapshot: Make exception tables
	scalable
Date: Sun, 17 Mar 2019 14:22:57 +0200
Message-ID: <20190317122258.21760-6-ntsironis@arrikto.com>
References: <20190317122258.21760-1-ntsironis@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190317122258.21760-1-ntsironis@arrikto.com>
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
Cc: hch@infradead.org, paulmck@linux.ibm.com, mpatocka@redhat.com, linux-kernel@vger.kernel.org, iliastsi@arrikto.com
List-Id: dm-devel.ids

Use list_bl to implement the exception hash tables' buckets. This change
permits concurrent access, to distinct buckets, by multiple threads.

Also, implement helper functions to lock and unlock the exception tables
based on the chunk number of the exception at hand.

We retain the global locking, by means of down_write(), which is
replaced by the next commit.

Still, we must acquire the per-bucket spinlocks when accessing the hash
tables, since list_bl does not allow modification on unlocked lists.

Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Signed-off-by: Ilias Tsitsimpis <iliastsi@arrikto.com>
---
 drivers/md/dm-exception-store.h |   3 +-
 drivers/md/dm-snap.c            | 137 +++++++++++++++++++++++++++++++++-------
 2 files changed, 116 insertions(+), 24 deletions(-)

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
index 209da5dd0ba6..ab75857309aa 100644
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
@@ -44,7 +45,7 @@ static const char dm_snapshot_merge_target_name[] = "snapshot-merge";
 struct dm_exception_table {
 	uint32_t hash_mask;
 	unsigned hash_shift;
-	struct list_head *table;
+	struct hlist_bl_head *table;
 };
 
 struct dm_snapshot {
@@ -618,6 +619,36 @@ static void unregister_snapshot(struct dm_snapshot *s)
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
@@ -625,12 +656,12 @@ static int dm_exception_table_init(struct dm_exception_table *et,
 
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
@@ -638,15 +669,16 @@ static int dm_exception_table_init(struct dm_exception_table *et,
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
 
@@ -660,7 +692,7 @@ static uint32_t exception_hash(struct dm_exception_table *et, chunk_t chunk)
 
 static void dm_remove_exception(struct dm_exception *e)
 {
-	list_del(&e->hash_list);
+	hlist_bl_del(&e->hash_list);
 }
 
 /*
@@ -670,11 +702,12 @@ static void dm_remove_exception(struct dm_exception *e)
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
@@ -721,7 +754,8 @@ static void free_pending_exception(struct dm_snap_pending_exception *pe)
 static void dm_insert_exception(struct dm_exception_table *eh,
 				struct dm_exception *new_e)
 {
-	struct list_head *l;
+	struct hlist_bl_head *l;
+	struct hlist_bl_node *pos;
 	struct dm_exception *e = NULL;
 
 	l = &eh->table[exception_hash(eh, new_e->old_chunk)];
@@ -731,7 +765,7 @@ static void dm_insert_exception(struct dm_exception_table *eh,
 		goto out;
 
 	/* List is ordered by old_chunk */
-	list_for_each_entry_reverse(e, l, hash_list) {
+	hlist_bl_for_each_entry(e, pos, l, hash_list) {
 		/* Insert after an existing chunk? */
 		if (new_e->old_chunk == (e->old_chunk +
 					 dm_consecutive_chunk_count(e) + 1) &&
@@ -752,12 +786,24 @@ static void dm_insert_exception(struct dm_exception_table *eh,
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
@@ -766,6 +812,7 @@ static void dm_insert_exception(struct dm_exception_table *eh,
  */
 static int dm_add_exception(void *context, chunk_t old, chunk_t new)
 {
+	struct dm_exception_table_lock lock;
 	struct dm_snapshot *s = context;
 	struct dm_exception *e;
 
@@ -778,7 +825,17 @@ static int dm_add_exception(void *context, chunk_t old, chunk_t new)
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
@@ -807,7 +864,7 @@ static int calc_max_buckets(void)
 {
 	/* use a fixed size of 2MB */
 	unsigned long mem = 2 * 1024 * 1024;
-	mem /= sizeof(struct list_head);
+	mem /= sizeof(struct hlist_bl_head);
 
 	return mem;
 }
@@ -1473,13 +1530,18 @@ static void pending_complete(void *context, int success)
 	struct bio *origin_bios = NULL;
 	struct bio *snapshot_bios = NULL;
 	struct bio *full_bio = NULL;
+	struct dm_exception_table_lock lock;
 	int error = 0;
 
+	dm_exception_table_lock_init(s, pe->e.old_chunk, &lock);
+
 	if (!success) {
 		/* Read/write error - snapshot is unusable */
 		down_write(&s->lock);
 		__invalidate_snapshot(s, -EIO);
 		error = 1;
+
+		dm_exception_table_lock(&lock);
 		goto out;
 	}
 
@@ -1488,11 +1550,14 @@ static void pending_complete(void *context, int success)
 		down_write(&s->lock);
 		__invalidate_snapshot(s, -ENOMEM);
 		error = 1;
+
+		dm_exception_table_lock(&lock);
 		goto out;
 	}
 	*e = pe->e;
 
 	down_write(&s->lock);
+	dm_exception_table_lock(&lock);
 	if (!s->valid) {
 		free_completed_exception(e);
 		error = 1;
@@ -1510,14 +1575,19 @@ static void pending_complete(void *context, int success)
 
 	/* Wait for conflicting reads to drain */
 	if (__chunk_is_tracked(s, pe->e.old_chunk)) {
+		dm_exception_table_unlock(&lock);
 		up_write(&s->lock);
 		__check_for_conflicting_io(s, pe->e.old_chunk);
 		down_write(&s->lock);
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
@@ -1733,6 +1803,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 	int r = DM_MAPIO_REMAPPED;
 	chunk_t chunk;
 	struct dm_snap_pending_exception *pe = NULL;
+	struct dm_exception_table_lock lock;
 
 	init_tracked_chunk(bio);
 
@@ -1742,6 +1813,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 	}
 
 	chunk = sector_to_chunk(s->store, bio->bi_iter.bi_sector);
+	dm_exception_table_lock_init(s, chunk, &lock);
 
 	/* Full snapshots are not usable */
 	/* To get here the table must be live so s->active is always set. */
@@ -1749,6 +1821,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 		return DM_MAPIO_KILL;
 
 	down_write(&s->lock);
+	dm_exception_table_lock(&lock);
 
 	if (!s->valid || (unlikely(s->snapshot_overflowed) &&
 	    bio_data_dir(bio) == WRITE)) {
@@ -1771,9 +1844,11 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 	if (bio_data_dir(bio) == WRITE) {
 		pe = __lookup_pending_exception(s, chunk);
 		if (!pe) {
+			dm_exception_table_unlock(&lock);
 			up_write(&s->lock);
 			pe = alloc_pending_exception(s);
 			down_write(&s->lock);
+			dm_exception_table_lock(&lock);
 
 			if (!s->valid || s->snapshot_overflowed) {
 				free_pending_exception(pe);
@@ -1790,13 +1865,17 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 
 			pe = __find_pending_exception(s, pe, chunk);
 			if (!pe) {
+				dm_exception_table_unlock(&lock);
+
 				if (s->store->userspace_supports_overflow) {
 					s->snapshot_overflowed = 1;
 					DMERR("Snapshot overflowed: Unable to allocate exception.");
 				} else
 					__invalidate_snapshot(s, -ENOMEM);
+				up_write(&s->lock);
+
 				r = DM_MAPIO_KILL;
-				goto out_unlock;
+				goto out;
 			}
 		}
 
@@ -1808,6 +1887,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 		    bio->bi_iter.bi_size ==
 		    (s->store->chunk_size << SECTOR_SHIFT)) {
 			pe->started = 1;
+			dm_exception_table_unlock(&lock);
 			up_write(&s->lock);
 			start_full_bio(pe, bio);
 			goto out;
@@ -1818,6 +1898,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 		if (!pe->started) {
 			/* this is protected by snap->lock */
 			pe->started = 1;
+			dm_exception_table_unlock(&lock);
 			up_write(&s->lock);
 			start_copy(pe);
 			goto out;
@@ -1828,6 +1909,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 	}
 
 out_unlock:
+	dm_exception_table_unlock(&lock);
 	up_write(&s->lock);
 out:
 	return r;
@@ -2129,6 +2211,7 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
 	struct dm_snap_pending_exception *pe, *pe2;
 	struct dm_snap_pending_exception *pe_to_start_now = NULL;
 	struct dm_snap_pending_exception *pe_to_start_last = NULL;
+	struct dm_exception_table_lock lock;
 	chunk_t chunk;
 
 	/* Do all the snapshots on this origin */
@@ -2140,21 +2223,23 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
 		if (dm_target_is_snapshot_merge(snap->ti))
 			continue;
 
-		down_write(&snap->lock);
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
+		down_write(&snap->lock);
+		dm_exception_table_lock(&lock);
+
+		/* Only deal with valid and active snapshots */
+		if (!snap->valid || !snap->active)
+			goto next_snapshot;
 
 		pe = __lookup_pending_exception(snap, chunk);
 		if (!pe) {
@@ -2167,9 +2252,11 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
 			if (e)
 				goto next_snapshot;
 
+			dm_exception_table_unlock(&lock);
 			up_write(&snap->lock);
 			pe = alloc_pending_exception(snap);
 			down_write(&snap->lock);
+			dm_exception_table_lock(&lock);
 
 			if (!snap->valid) {
 				free_pending_exception(pe);
@@ -2187,8 +2274,11 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
 
 				pe = __insert_pending_exception(snap, pe, chunk);
 				if (!pe) {
+					dm_exception_table_unlock(&lock);
 					__invalidate_snapshot(snap, -ENOMEM);
-					goto next_snapshot;
+					up_write(&snap->lock);
+
+					continue;
 				}
 			} else {
 				free_pending_exception(pe);
@@ -2219,6 +2309,7 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
 		}
 
 next_snapshot:
+		dm_exception_table_unlock(&lock);
 		up_write(&snap->lock);
 
 		if (pe_to_start_now) {
-- 
2.11.0
