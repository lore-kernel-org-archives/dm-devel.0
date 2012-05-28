From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2] dm optimize: use SRCU and RCU
Date: Mon, 28 May 2012 12:43:33 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1205281242280.4594@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

dm-optimize: use SRCU and RCU

This patch removes "io_lock" and "map_lock" in struct mapped_device and
"holders" in struct dm_table and replaces these mechanisms with
sleepable-rcu.

Previously, the code would call "dm_get_live_table" and "dm_table_put" to
get and release table. Now, the code is changed to call "dm_get_live_table"
and "dm_put_live_table". dm_get_live_table locks sleepable-rcu and
dm_put_live_table unlocks it.

dm_get_live_table_fast/dm_put_live_table_fast can be used instead of
dm_get_live_table/dm_put_live_table. These *_fast functions use
non-sleepable RCU, so the caller must not block between them.

If the code changes active or inactive dm table, it must call
dm_sync_table before destroying the old table.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Modified-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

---
 drivers/md/dm-ioctl.c         |  122 ++++++++++++++++++++++-----------
 drivers/md/dm-table.c         |   35 ---------
 drivers/md/dm.c               |  154 ++++++++++++++++++++++++------------------
 include/linux/device-mapper.h |    6 -
 4 files changed, 174 insertions(+), 143 deletions(-)

Index: linux-3.4-rc6-fast/drivers/md/dm-ioctl.c
===================================================================
--- linux-3.4-rc6-fast.orig/drivers/md/dm-ioctl.c	2012-05-18 08:22:05.000000000 +0200
+++ linux-3.4-rc6-fast/drivers/md/dm-ioctl.c	2012-05-18 08:23:28.000000000 +0200
@@ -36,6 +36,14 @@ struct hash_cell {
 	struct dm_table *new_map;
 };
 
+/*
+ * A dummy definition to make RCU happy.
+ * struct dm_table should never be dereferenced in this file.
+ */
+struct dm_table {
+	int undefined__;
+};
+
 struct vers_iter {
     size_t param_size;
     struct dm_target_versions *vers, *old_vers;
@@ -242,9 +250,10 @@ static int dm_hash_insert(const char *na
 	return -EBUSY;
 }
 
-static void __hash_remove(struct hash_cell *hc)
+static struct dm_table *__hash_remove(struct hash_cell *hc)
 {
 	struct dm_table *table;
+	int srcu_idx;
 
 	/* remove from the dev hash */
 	list_del(&hc->uuid_list);
@@ -253,16 +262,18 @@ static void __hash_remove(struct hash_ce
 	dm_set_mdptr(hc->md, NULL);
 	mutex_unlock(&dm_hash_cells_mutex);
 
-	table = dm_get_live_table(hc->md);
-	if (table) {
+	table = dm_get_live_table(hc->md, &srcu_idx);
+	if (table)
 		dm_table_event(table);
-		dm_table_put(table);
-	}
+	dm_put_live_table(hc->md, srcu_idx);
 
+	table = NULL;
 	if (hc->new_map)
-		dm_table_destroy(hc->new_map);
+		table = hc->new_map;
 	dm_put(hc->md);
 	free_cell(hc);
+
+	return table;
 }
 
 static void dm_hash_remove_all(int keep_open_devices)
@@ -270,6 +281,7 @@ static void dm_hash_remove_all(int keep_
 	int i, dev_skipped;
 	struct hash_cell *hc;
 	struct mapped_device *md;
+	struct dm_table *t;
 
 retry:
 	dev_skipped = 0;
@@ -287,10 +299,14 @@ retry:
 				continue;
 			}
 
-			__hash_remove(hc);
+			t = __hash_remove(hc);
 
 			up_write(&_hash_lock);
 
+			if (t) {
+				dm_sync_table(md);
+				dm_table_destroy(t);
+			}
 			dm_put(md);
 			if (likely(keep_open_devices))
 				dm_destroy(md);
@@ -356,6 +372,7 @@ static struct mapped_device *dm_hash_ren
 	struct dm_table *table;
 	struct mapped_device *md;
 	unsigned change_uuid = (param->flags & DM_UUID_FLAG) ? 1 : 0;
+	int srcu_idx;
 
 	/*
 	 * duplicate new.
@@ -418,11 +435,10 @@ static struct mapped_device *dm_hash_ren
 	/*
 	 * Wake up any dm event waiters.
 	 */
-	table = dm_get_live_table(hc->md);
-	if (table) {
+	table = dm_get_live_table(hc->md, &srcu_idx);
+	if (table)
 		dm_table_event(table);
-		dm_table_put(table);
-	}
+	dm_put_live_table(hc->md, srcu_idx);
 
 	if (!dm_kobject_uevent(hc->md, KOBJ_CHANGE, param->event_nr))
 		param->flags |= DM_UEVENT_GENERATED_FLAG;
@@ -620,11 +636,14 @@ static int check_name(const char *name)
  * _hash_lock without first calling dm_table_put, because dm_table_destroy
  * waits for this dm_table_put and could be called under this lock.
  */
-static struct dm_table *dm_get_inactive_table(struct mapped_device *md)
+static struct dm_table *dm_get_inactive_table(struct mapped_device *md, int *srcu_idx)
 {
 	struct hash_cell *hc;
 	struct dm_table *table = NULL;
 
+	/* increment rcu count, we don't care about the table pointer */
+	dm_get_live_table(md, srcu_idx);
+
 	down_read(&_hash_lock);
 	hc = dm_get_mdptr(md);
 	if (!hc || hc->md != md) {
@@ -633,8 +652,6 @@ static struct dm_table *dm_get_inactive_
 	}
 
 	table = hc->new_map;
-	if (table)
-		dm_table_get(table);
 
 out:
 	up_read(&_hash_lock);
@@ -643,10 +660,11 @@ out:
 }
 
 static struct dm_table *dm_get_live_or_inactive_table(struct mapped_device *md,
-						      struct dm_ioctl *param)
+						      struct dm_ioctl *param,
+						      int *srcu_idx)
 {
 	return (param->flags & DM_QUERY_INACTIVE_TABLE_FLAG) ?
-		dm_get_inactive_table(md) : dm_get_live_table(md);
+		dm_get_inactive_table(md, srcu_idx) : dm_get_live_table(md, srcu_idx);
 }
 
 /*
@@ -657,6 +675,7 @@ static void __dev_status(struct mapped_d
 {
 	struct gendisk *disk = dm_disk(md);
 	struct dm_table *table;
+	int srcu_idx;
 
 	param->flags &= ~(DM_SUSPEND_FLAG | DM_READONLY_FLAG |
 			  DM_ACTIVE_PRESENT_FLAG);
@@ -676,26 +695,27 @@ static void __dev_status(struct mapped_d
 	param->event_nr = dm_get_event_nr(md);
 	param->target_count = 0;
 
-	table = dm_get_live_table(md);
+	table = dm_get_live_table(md, &srcu_idx);
 	if (table) {
 		if (!(param->flags & DM_QUERY_INACTIVE_TABLE_FLAG)) {
 			if (get_disk_ro(disk))
 				param->flags |= DM_READONLY_FLAG;
 			param->target_count = dm_table_get_num_targets(table);
 		}
-		dm_table_put(table);
 
 		param->flags |= DM_ACTIVE_PRESENT_FLAG;
 	}
+	dm_put_live_table(md, srcu_idx);
 
 	if (param->flags & DM_QUERY_INACTIVE_TABLE_FLAG) {
-		table = dm_get_inactive_table(md);
+		int srcu_idx;
+		table = dm_get_inactive_table(md, &srcu_idx);
 		if (table) {
 			if (!(dm_table_get_mode(table) & FMODE_WRITE))
 				param->flags |= DM_READONLY_FLAG;
 			param->target_count = dm_table_get_num_targets(table);
-			dm_table_put(table);
 		}
+		dm_put_live_table(md, srcu_idx);
 	}
 }
 
@@ -796,6 +816,7 @@ static int dev_remove(struct dm_ioctl *p
 	struct hash_cell *hc;
 	struct mapped_device *md;
 	int r;
+	struct dm_table *t;
 
 	down_write(&_hash_lock);
 	hc = __find_device_hash_cell(param);
@@ -819,9 +840,14 @@ static int dev_remove(struct dm_ioctl *p
 		return r;
 	}
 
-	__hash_remove(hc);
+	t = __hash_remove(hc);
 	up_write(&_hash_lock);
 
+	if (t) {
+		dm_sync_table(md);
+		dm_table_destroy(t);
+	}
+
 	if (!dm_kobject_uevent(md, KOBJ_REMOVE, param->event_nr))
 		param->flags |= DM_UEVENT_GENERATED_FLAG;
 
@@ -986,6 +1012,7 @@ static int do_resume(struct dm_ioctl *pa
 
 		old_map = dm_swap_table(md, new_map);
 		if (IS_ERR(old_map)) {
+			dm_sync_table(md);
 			dm_table_destroy(new_map);
 			dm_put(md);
 			return PTR_ERR(old_map);
@@ -1003,6 +1030,10 @@ static int do_resume(struct dm_ioctl *pa
 			param->flags |= DM_UEVENT_GENERATED_FLAG;
 	}
 
+	/*
+	 * Since dm_swap_table synchronizes RCU, nobody should be in
+	 * read-side critical section already.
+	 */
 	if (old_map)
 		dm_table_destroy(old_map);
 
@@ -1118,6 +1149,7 @@ static int dev_wait(struct dm_ioctl *par
 	int r = 0;
 	struct mapped_device *md;
 	struct dm_table *table;
+	int srcu_idx;
 
 	md = find_device(param);
 	if (!md)
@@ -1138,11 +1170,10 @@ static int dev_wait(struct dm_ioctl *par
 	 */
 	__dev_status(md, param);
 
-	table = dm_get_live_or_inactive_table(md, param);
-	if (table) {
+	table = dm_get_live_or_inactive_table(md, param, &srcu_idx);
+	if (table)
 		retrieve_status(table, param, param_size);
-		dm_table_put(table);
-	}
+	dm_put_live_table(md, srcu_idx);
 
 out:
 	dm_put(md);
@@ -1214,7 +1245,7 @@ static int table_load(struct dm_ioctl *p
 {
 	int r;
 	struct hash_cell *hc;
-	struct dm_table *t;
+	struct dm_table *t, *old_map = NULL;
 	struct mapped_device *md;
 	struct target_type *immutable_target_type;
 
@@ -1270,14 +1301,14 @@ static int table_load(struct dm_ioctl *p
 	hc = dm_get_mdptr(md);
 	if (!hc || hc->md != md) {
 		DMWARN("device has been removed from the dev hash table.");
-		dm_table_destroy(t);
 		up_write(&_hash_lock);
+		dm_table_destroy(t);
 		r = -ENXIO;
 		goto out;
 	}
 
 	if (hc->new_map)
-		dm_table_destroy(hc->new_map);
+		old_map = hc->new_map;
 	hc->new_map = t;
 	up_write(&_hash_lock);
 
@@ -1285,6 +1316,11 @@ static int table_load(struct dm_ioctl *p
 	__dev_status(md, param);
 
 out:
+	if (old_map) {
+		dm_sync_table(md);
+		dm_table_destroy(old_map);
+	}
+
 	dm_put(md);
 
 	return r;
@@ -1294,6 +1330,7 @@ static int table_clear(struct dm_ioctl *
 {
 	struct hash_cell *hc;
 	struct mapped_device *md;
+	struct dm_table *old_map = NULL;
 
 	down_write(&_hash_lock);
 
@@ -1305,7 +1342,7 @@ static int table_clear(struct dm_ioctl *
 	}
 
 	if (hc->new_map) {
-		dm_table_destroy(hc->new_map);
+		old_map = hc->new_map;
 		hc->new_map = NULL;
 	}
 
@@ -1314,6 +1351,10 @@ static int table_clear(struct dm_ioctl *
 	__dev_status(hc->md, param);
 	md = hc->md;
 	up_write(&_hash_lock);
+	if (old_map) {
+		dm_sync_table(md);
+		dm_table_destroy(old_map);
+	}
 	dm_put(md);
 
 	return 0;
@@ -1363,6 +1404,7 @@ static int table_deps(struct dm_ioctl *p
 {
 	struct mapped_device *md;
 	struct dm_table *table;
+	int srcu_idx;
 
 	md = find_device(param);
 	if (!md)
@@ -1370,11 +1412,10 @@ static int table_deps(struct dm_ioctl *p
 
 	__dev_status(md, param);
 
-	table = dm_get_live_or_inactive_table(md, param);
-	if (table) {
+	table = dm_get_live_or_inactive_table(md, param, &srcu_idx);
+	if (table)
 		retrieve_deps(table, param, param_size);
-		dm_table_put(table);
-	}
+	dm_put_live_table(md, srcu_idx);
 
 	dm_put(md);
 
@@ -1389,6 +1430,7 @@ static int table_status(struct dm_ioctl 
 {
 	struct mapped_device *md;
 	struct dm_table *table;
+	int srcu_idx;
 
 	md = find_device(param);
 	if (!md)
@@ -1396,11 +1438,10 @@ static int table_status(struct dm_ioctl 
 
 	__dev_status(md, param);
 
-	table = dm_get_live_or_inactive_table(md, param);
-	if (table) {
+	table = dm_get_live_or_inactive_table(md, param, &srcu_idx);
+	if (table)
 		retrieve_status(table, param, param_size);
-		dm_table_put(table);
-	}
+	dm_put_live_table(md, srcu_idx);
 
 	dm_put(md);
 
@@ -1418,6 +1459,7 @@ static int target_message(struct dm_ioct
 	struct dm_table *table;
 	struct dm_target *ti;
 	struct dm_target_msg *tmsg = (void *) param + param->data_start;
+	int srcu_idx;
 
 	md = find_device(param);
 	if (!md)
@@ -1441,9 +1483,9 @@ static int target_message(struct dm_ioct
 		goto out_argv;
 	}
 
-	table = dm_get_live_table(md);
+	table = dm_get_live_table(md, &srcu_idx);
 	if (!table)
-		goto out_argv;
+		goto out_table;
 
 	if (dm_deleting_md(md)) {
 		r = -ENXIO;
@@ -1462,7 +1504,7 @@ static int target_message(struct dm_ioct
 	}
 
  out_table:
-	dm_table_put(table);
+	dm_put_live_table(md, srcu_idx);
  out_argv:
 	kfree(argv);
  out:
Index: linux-3.4-rc6-fast/drivers/md/dm-table.c
===================================================================
--- linux-3.4-rc6-fast.orig/drivers/md/dm-table.c	2012-05-18 08:22:05.000000000 +0200
+++ linux-3.4-rc6-fast/drivers/md/dm-table.c	2012-05-18 08:23:28.000000000 +0200
@@ -26,22 +26,8 @@
 #define KEYS_PER_NODE (NODE_SIZE / sizeof(sector_t))
 #define CHILDREN_PER_NODE (KEYS_PER_NODE + 1)
 
-/*
- * The table has always exactly one reference from either mapped_device->map
- * or hash_cell->new_map. This reference is not counted in table->holders.
- * A pair of dm_create_table/dm_destroy_table functions is used for table
- * creation/destruction.
- *
- * Temporary references from the other code increase table->holders. A pair
- * of dm_table_get/dm_table_put functions is used to manipulate it.
- *
- * When the table is about to be destroyed, we wait for table->holders to
- * drop to zero.
- */
-
 struct dm_table {
 	struct mapped_device *md;
-	atomic_t holders;
 	unsigned type;
 
 	/* btree table */
@@ -208,7 +194,6 @@ int dm_table_create(struct dm_table **re
 
 	INIT_LIST_HEAD(&t->devices);
 	INIT_LIST_HEAD(&t->target_callbacks);
-	atomic_set(&t->holders, 0);
 
 	if (!num_targets)
 		num_targets = KEYS_PER_NODE;
@@ -247,10 +232,6 @@ void dm_table_destroy(struct dm_table *t
 	if (!t)
 		return;
 
-	while (atomic_read(&t->holders))
-		msleep(1);
-	smp_mb();
-
 	/* free the indexes */
 	if (t->depth >= 2)
 		vfree(t->index[t->depth - 2]);
@@ -275,22 +256,6 @@ void dm_table_destroy(struct dm_table *t
 	kfree(t);
 }
 
-void dm_table_get(struct dm_table *t)
-{
-	atomic_inc(&t->holders);
-}
-EXPORT_SYMBOL(dm_table_get);
-
-void dm_table_put(struct dm_table *t)
-{
-	if (!t)
-		return;
-
-	smp_mb__before_atomic_dec();
-	atomic_dec(&t->holders);
-}
-EXPORT_SYMBOL(dm_table_put);
-
 /*
  * Checks to see if we need to extend highs or targets.
  */
Index: linux-3.4-rc6-fast/drivers/md/dm.c
===================================================================
--- linux-3.4-rc6-fast.orig/drivers/md/dm.c	2012-05-18 08:22:56.000000000 +0200
+++ linux-3.4-rc6-fast/drivers/md/dm.c	2012-05-18 08:23:28.000000000 +0200
@@ -123,12 +123,19 @@ EXPORT_SYMBOL_GPL(dm_get_rq_mapinfo);
 #define DMF_MERGE_IS_OPTIONAL 6
 
 /*
+ * A dummy definition to make RCU happy.
+ * struct dm_table should never be dereferenced in this file.
+ */
+struct dm_table {
+	int undefined__;
+};
+
+/*
  * Work processed by per-device workqueue.
  */
 struct mapped_device {
-	struct rw_semaphore io_lock;
+	struct srcu_struct io_barrier;
 	struct mutex suspend_lock;
-	rwlock_t map_lock;
 	atomic_t holders;
 	atomic_t open_count;
 
@@ -162,6 +169,8 @@ struct mapped_device {
 
 	/*
 	 * The current mapping.
+	 * Use dm_get_live_table{_fast} or take suspend_lock for
+	 * dereference.
 	 */
 	struct dm_table *map;
 
@@ -415,7 +424,8 @@ static int dm_blk_ioctl(struct block_dev
 			unsigned int cmd, unsigned long arg)
 {
 	struct mapped_device *md = bdev->bd_disk->private_data;
-	struct dm_table *map = dm_get_live_table(md);
+	int srcu_idx;
+	struct dm_table *map = dm_get_live_table(md, &srcu_idx);
 	struct dm_target *tgt;
 	int r = -ENOTTY;
 
@@ -437,7 +447,7 @@ static int dm_blk_ioctl(struct block_dev
 		r = tgt->type->ioctl(tgt, cmd, arg);
 
 out:
-	dm_table_put(map);
+	dm_put_live_table(md, srcu_idx);
 
 	return r;
 }
@@ -541,20 +551,38 @@ static void queue_io(struct mapped_devic
 /*
  * Everyone (including functions in this file), should use this
  * function to access the md->map field, and make sure they call
- * dm_table_put() when finished.
+ * dm_put_live_table() when finished.
  */
-struct dm_table *dm_get_live_table(struct mapped_device *md)
+struct dm_table *dm_get_live_table(struct mapped_device *md, int *srcu_idx)
 {
-	struct dm_table *t;
-	unsigned long flags;
+	*srcu_idx = srcu_read_lock(&md->io_barrier);
+	return srcu_dereference(md->map, &md->io_barrier);
+}
 
-	read_lock_irqsave(&md->map_lock, flags);
-	t = md->map;
-	if (t)
-		dm_table_get(t);
-	read_unlock_irqrestore(&md->map_lock, flags);
+void dm_put_live_table(struct mapped_device *md, int srcu_idx)
+{
+	srcu_read_unlock(&md->io_barrier, srcu_idx);
+}
 
-	return t;
+void dm_sync_table(struct mapped_device *md)
+{
+	synchronize_srcu(&md->io_barrier);
+	synchronize_rcu_expedited();
+}
+
+/*
+ * A fast alternative to dm_get_live_table/dm_put_live_table.
+ * The caller must not block between these two functions.
+ */
+static struct dm_table *dm_get_live_table_fast(struct mapped_device *md)
+{
+	rcu_read_lock();
+	return rcu_dereference(md->map);
+}
+
+static void dm_put_live_table_fast(struct mapped_device *md)
+{
+	rcu_read_unlock();
 }
 
 /*
@@ -1298,17 +1326,18 @@ static int __clone_and_map(struct clone_
 /*
  * Split the bio into several clones and submit it to targets.
  */
-static void __split_and_process_bio(struct mapped_device *md, struct bio *bio)
+static void __split_and_process_bio(struct mapped_device *md,
+				    struct dm_table *map, struct bio *bio)
 {
 	struct clone_info ci;
 	int error = 0;
 
-	ci.map = dm_get_live_table(md);
-	if (unlikely(!ci.map)) {
+	if (unlikely(!map)) {
 		bio_io_error(bio);
 		return;
 	}
 
+	ci.map = map;
 	ci.md = md;
 	ci.io = alloc_io(md);
 	ci.io->error = 0;
@@ -1334,7 +1363,6 @@ static void __split_and_process_bio(stru
 
 	/* drop the extra reference count */
 	dec_pending(ci.io, error);
-	dm_table_put(ci.map);
 }
 /*-----------------------------------------------------------------
  * CRUD END
@@ -1345,7 +1373,7 @@ static int dm_merge_bvec(struct request_
 			 struct bio_vec *biovec)
 {
 	struct mapped_device *md = q->queuedata;
-	struct dm_table *map = dm_get_live_table(md);
+	struct dm_table *map = dm_get_live_table_fast(md);
 	struct dm_target *ti;
 	sector_t max_sectors;
 	int max_size = 0;
@@ -1355,7 +1383,7 @@ static int dm_merge_bvec(struct request_
 
 	ti = dm_table_find_target(map, bvm->bi_sector);
 	if (!dm_target_is_valid(ti))
-		goto out_table;
+		goto out;
 
 	/*
 	 * Find maximum amount of I/O that won't need splitting
@@ -1384,10 +1412,8 @@ static int dm_merge_bvec(struct request_
 
 		max_size = 0;
 
-out_table:
-	dm_table_put(map);
-
 out:
+	dm_put_live_table_fast(md);
 	/*
 	 * Always allow an entire first page
 	 */
@@ -1406,8 +1432,10 @@ static void _dm_request(struct request_q
 	int rw = bio_data_dir(bio);
 	struct mapped_device *md = q->queuedata;
 	int cpu;
+	int srcu_idx;
+	struct dm_table *map;
 
-	down_read(&md->io_lock);
+	map = dm_get_live_table(md, &srcu_idx);
 
 	cpu = part_stat_lock();
 	part_stat_inc(cpu, &dm_disk(md)->part0, ios[rw]);
@@ -1416,7 +1444,7 @@ static void _dm_request(struct request_q
 
 	/* if we're suspended, we have to queue this io for later */
 	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags))) {
-		up_read(&md->io_lock);
+		dm_put_live_table(md, srcu_idx);
 
 		if (bio_rw(bio) != READA)
 			queue_io(md, bio);
@@ -1425,8 +1453,8 @@ static void _dm_request(struct request_q
 		return;
 	}
 
-	__split_and_process_bio(md, bio);
-	up_read(&md->io_lock);
+	__split_and_process_bio(md, map, bio);
+	dm_put_live_table(md, srcu_idx);
 	return;
 }
 
@@ -1614,7 +1642,8 @@ static int map_request(struct dm_target 
 static void dm_request_fn(struct request_queue *q)
 {
 	struct mapped_device *md = q->queuedata;
-	struct dm_table *map = dm_get_live_table(md);
+	int srcu_idx;
+	struct dm_table *map = dm_get_live_table(md, &srcu_idx);
 	struct dm_target *ti;
 	struct request *rq, *clone;
 	sector_t pos;
@@ -1662,7 +1691,7 @@ requeued:
 delay_and_out:
 	blk_delay_queue(q, HZ / 10);
 out:
-	dm_table_put(map);
+	dm_put_live_table(md, srcu_idx);
 
 	return;
 }
@@ -1677,14 +1706,14 @@ static int dm_lld_busy(struct request_qu
 {
 	int r;
 	struct mapped_device *md = q->queuedata;
-	struct dm_table *map = dm_get_live_table(md);
+	struct dm_table *map = dm_get_live_table_fast(md);
 
 	if (!map || test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags))
 		r = 1;
 	else
 		r = dm_table_any_busy_target(map);
 
-	dm_table_put(map);
+	dm_put_live_table_fast(md);
 
 	return r;
 }
@@ -1696,7 +1725,7 @@ static int dm_any_congested(void *conges
 	struct dm_table *map;
 
 	if (!test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) {
-		map = dm_get_live_table(md);
+		map = dm_get_live_table_fast(md);
 		if (map) {
 			/*
 			 * Request-based dm cares about only own queue for
@@ -1707,9 +1736,8 @@ static int dm_any_congested(void *conges
 				    bdi_bits;
 			else
 				r = dm_table_any_congested(map, bdi_bits);
-
-			dm_table_put(map);
 		}
+		dm_put_live_table_fast(md);
 	}
 
 	return r;
@@ -1839,12 +1867,14 @@ static struct mapped_device *alloc_dev(i
 	if (r < 0)
 		goto bad_minor;
 
+	r = init_srcu_struct(&md->io_barrier);
+	if (r < 0)
+		goto bad_io_barrier;
+
 	md->type = DM_TYPE_NONE;
-	init_rwsem(&md->io_lock);
 	mutex_init(&md->suspend_lock);
 	mutex_init(&md->type_lock);
 	spin_lock_init(&md->deferred_lock);
-	rwlock_init(&md->map_lock);
 	atomic_set(&md->holders, 1);
 	atomic_set(&md->open_count, 0);
 	atomic_set(&md->event_nr, 0);
@@ -1907,6 +1937,8 @@ bad_thread:
 bad_disk:
 	blk_cleanup_queue(md->queue);
 bad_queue:
+	cleanup_srcu_struct(&md->io_barrier);
+bad_io_barrier:
 	free_minor(minor);
 bad_minor:
 	module_put(THIS_MODULE);
@@ -1932,6 +1964,7 @@ static void free_dev(struct mapped_devic
 		bioset_free(md->bs);
 	blk_integrity_unregister(md->disk);
 	del_gendisk(md->disk);
+	cleanup_srcu_struct(&md->io_barrier);
 	free_minor(minor);
 
 	spin_lock(&_minor_lock);
@@ -2058,7 +2091,6 @@ static struct dm_table *__bind(struct ma
 	struct dm_table *old_map;
 	struct request_queue *q = md->queue;
 	sector_t size;
-	unsigned long flags;
 	int merge_is_optional;
 
 	size = dm_table_get_size(t);
@@ -2087,9 +2119,8 @@ static struct dm_table *__bind(struct ma
 
 	merge_is_optional = dm_table_merge_is_optional(t);
 
-	write_lock_irqsave(&md->map_lock, flags);
 	old_map = md->map;
-	md->map = t;
+	rcu_assign_pointer(md->map, t);
 	md->immutable_target_type = dm_table_get_immutable_target_type(t);
 
 	dm_table_set_restrictions(t, q, limits);
@@ -2097,7 +2128,7 @@ static struct dm_table *__bind(struct ma
 		set_bit(DMF_MERGE_IS_OPTIONAL, &md->flags);
 	else
 		clear_bit(DMF_MERGE_IS_OPTIONAL, &md->flags);
-	write_unlock_irqrestore(&md->map_lock, flags);
+	dm_sync_table(md);
 
 	return old_map;
 }
@@ -2108,15 +2139,13 @@ static struct dm_table *__bind(struct ma
 static struct dm_table *__unbind(struct mapped_device *md)
 {
 	struct dm_table *map = md->map;
-	unsigned long flags;
 
 	if (!map)
 		return NULL;
 
 	dm_table_event_callback(map, NULL, NULL);
-	write_lock_irqsave(&md->map_lock, flags);
-	md->map = NULL;
-	write_unlock_irqrestore(&md->map_lock, flags);
+	rcu_assign_pointer(md->map, NULL);
+	dm_sync_table(md);
 
 	return map;
 }
@@ -2268,11 +2297,12 @@ EXPORT_SYMBOL_GPL(dm_device_name);
 static void __dm_destroy(struct mapped_device *md, bool wait)
 {
 	struct dm_table *map;
+	int srcu_idx;
 
 	might_sleep();
 
 	spin_lock(&_minor_lock);
-	map = dm_get_live_table(md);
+	map = dm_get_live_table(md, &srcu_idx);
 	idr_replace(&_minor_idr, MINOR_ALLOCED, MINOR(disk_devt(dm_disk(md))));
 	set_bit(DMF_FREEING, &md->flags);
 	spin_unlock(&_minor_lock);
@@ -2282,6 +2312,9 @@ static void __dm_destroy(struct mapped_d
 		dm_table_postsuspend_targets(map);
 	}
 
+	/* dm_put_live_table must be before msleep, otherwise deadlock is possible */
+	dm_put_live_table(md, srcu_idx);
+
 	/*
 	 * Rare, but there may be I/O requests still going to complete,
 	 * for example.  Wait for all references to disappear.
@@ -2296,7 +2329,6 @@ static void __dm_destroy(struct mapped_d
 		       dm_device_name(md), atomic_read(&md->holders));
 
 	dm_sysfs_exit(md);
-	dm_table_put(map);
 	dm_table_destroy(__unbind(md));
 	free_dev(md);
 }
@@ -2353,8 +2385,10 @@ static void dm_wq_work(struct work_struc
 	struct mapped_device *md = container_of(work, struct mapped_device,
 						work);
 	struct bio *c;
+	int srcu_idx;
+	struct dm_table *map;
 
-	down_read(&md->io_lock);
+	map = dm_get_live_table(md, &srcu_idx);
 
 	while (!test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) {
 		spin_lock_irq(&md->deferred_lock);
@@ -2364,17 +2398,13 @@ static void dm_wq_work(struct work_struc
 		if (!c)
 			break;
 
-		up_read(&md->io_lock);
-
 		if (dm_request_based(md))
 			generic_make_request(c);
 		else
-			__split_and_process_bio(md, c);
-
-		down_read(&md->io_lock);
+			__split_and_process_bio(md, map, c);
 	}
 
-	up_read(&md->io_lock);
+	dm_put_live_table(md, srcu_idx);
 }
 
 static void dm_queue_flush(struct mapped_device *md)
@@ -2474,7 +2504,7 @@ int dm_suspend(struct mapped_device *md,
 		goto out_unlock;
 	}
 
-	map = dm_get_live_table(md);
+	map = md->map;
 
 	/*
 	 * DMF_NOFLUSH_SUSPENDING must be set before presuspend.
@@ -2495,7 +2525,7 @@ int dm_suspend(struct mapped_device *md,
 	if (!noflush && do_lockfs) {
 		r = lock_fs(md);
 		if (r)
-			goto out;
+			goto out_unlock;
 	}
 
 	/*
@@ -2510,9 +2540,8 @@ int dm_suspend(struct mapped_device *md,
 	 * (dm_wq_work), we set BMF_BLOCK_IO_FOR_SUSPEND and call
 	 * flush_workqueue(md->wq).
 	 */
-	down_write(&md->io_lock);
 	set_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags);
-	up_write(&md->io_lock);
+	synchronize_srcu(&md->io_barrier);
 
 	/*
 	 * Stop md->queue before flushing md->wq in case request-based
@@ -2530,10 +2559,9 @@ int dm_suspend(struct mapped_device *md,
 	 */
 	r = dm_wait_for_completion(md, TASK_INTERRUPTIBLE);
 
-	down_write(&md->io_lock);
 	if (noflush)
 		clear_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
-	up_write(&md->io_lock);
+	synchronize_srcu(&md->io_barrier);
 
 	/* were we interrupted ? */
 	if (r < 0) {
@@ -2543,7 +2571,7 @@ int dm_suspend(struct mapped_device *md,
 			start_queue(md->queue);
 
 		unlock_fs(md);
-		goto out; /* pushback list is already flushed, so skip flush */
+		goto out_unlock; /* pushback list is already flushed, so skip flush */
 	}
 
 	/*
@@ -2556,9 +2584,6 @@ int dm_suspend(struct mapped_device *md,
 
 	dm_table_postsuspend_targets(map);
 
-out:
-	dm_table_put(map);
-
 out_unlock:
 	mutex_unlock(&md->suspend_lock);
 	return r;
@@ -2573,7 +2598,7 @@ int dm_resume(struct mapped_device *md)
 	if (!dm_suspended_md(md))
 		goto out;
 
-	map = dm_get_live_table(md);
+	map = md->map;
 	if (!map || !dm_table_get_size(map))
 		goto out;
 
@@ -2597,7 +2622,6 @@ int dm_resume(struct mapped_device *md)
 
 	r = 0;
 out:
-	dm_table_put(map);
 	mutex_unlock(&md->suspend_lock);
 
 	return r;
Index: linux-3.4-rc6-fast/include/linux/device-mapper.h
===================================================================
--- linux-3.4-rc6-fast.orig/include/linux/device-mapper.h	2012-05-18 08:22:06.000000000 +0200
+++ linux-3.4-rc6-fast/include/linux/device-mapper.h	2012-05-18 08:23:28.000000000 +0200
@@ -362,9 +362,9 @@ int dm_table_complete(struct dm_table *t
 /*
  * Table reference counting.
  */
-struct dm_table *dm_get_live_table(struct mapped_device *md);
-void dm_table_get(struct dm_table *t);
-void dm_table_put(struct dm_table *t);
+struct dm_table *dm_get_live_table(struct mapped_device *md, int *srcu_idx);
+void dm_put_live_table(struct mapped_device *md, int srcu_idx);
+void dm_sync_table(struct mapped_device *md);
 
 /*
  * Queries
