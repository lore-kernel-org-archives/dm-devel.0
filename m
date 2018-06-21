From: Ssemagoye Umar Munddu <ssemagoyeumar@gmail.com>
Subject: [PATCH 4.17.0-rc3 1/2] dm: Reduce line length
Date: Thu, 21 Jun 2018 15:02:31 +0300
Message-ID: <20180621120231.GA5346@umar>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

Signed-off-by: Ssemagoye Umar Munddu <ssemagoyeumar@gmail.com>
---
 drivers/md/dm.c | 187 +++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 123 insertions(+), 64 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 4ea404d..bb465e6 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -107,7 +107,8 @@ void *dm_per_bio_data(struct bio *bio, size_t data_size)
 	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
 	if (!tio->inside_dm_io)
 		return (char *)bio - offsetof(struct dm_target_io, clone) - data_size;
-	return (char *)bio - offsetof(struct dm_target_io, clone) - offsetof(struct dm_io, tio) - data_size;
+	return (char *)bio - offsetof(struct dm_target_io, clone) - offsetof(
+		struct dm_io, tio) - data_size;
 }
 EXPORT_SYMBOL_GPL(dm_per_bio_data);
 
@@ -115,7 +116,8 @@ struct bio *dm_bio_from_per_bio_data(void *data, size_t data_size)
 {
 	struct dm_io *io = (struct dm_io *)((char *)data + data_size);
 	if (io->magic == DM_IO_MAGIC)
-		return (struct bio *)((char *)io + offsetof(struct dm_io, tio) + offsetof(struct dm_target_io, clone));
+		return (struct bio *)((char *)io + offsetof(
+			struct dm_io, tio) + offsetof(struct dm_target_io, clone));
 	BUG_ON(io->magic != DM_TIO_MAGIC);
 	return (struct bio *)((char *)io + offsetof(struct dm_target_io, clone));
 }
@@ -228,7 +230,8 @@ static int __init local_init(void)
 	if (!_rq_tio_cache)
 		return r;
 
-	_rq_cache = kmem_cache_create("dm_old_clone_request", sizeof(struct request),
+	_rq_cache = kmem_cache_create("dm_old_clone_request", sizeof(
+					struct request),
 				      __alignof__(struct request), 0, NULL);
 	if (!_rq_cache)
 		goto out_free_rq_tio_cache;
@@ -395,7 +398,8 @@ int dm_open_count(struct mapped_device *md)
 /*
  * Guarantees nothing is using the device before it's deleted.
  */
-int dm_lock_for_deletion(struct mapped_device *md, bool mark_deferred, bool only_deferred)
+int dm_lock_for_deletion(
+	struct mapped_device *md, bool mark_deferred, bool only_deferred)
 {
 	int r = 0;
 
@@ -451,7 +455,8 @@ struct dm_stats *dm_get_stats(struct mapped_device *md)
 	return &md->stats;
 }
 
-static int dm_blk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
+static int dm_blk_getgeo(
+	struct block_device *bdev, struct hd_geometry *geo)
 {
 	struct mapped_device *md = bdev->bd_disk->private_data;
 
@@ -563,7 +568,8 @@ static void free_io(struct mapped_device *md, struct dm_io *io)
 	bio_put(&io->tio.clone);
 }
 
-static struct dm_target_io *alloc_tio(struct clone_info *ci, struct dm_target *ti,
+static struct dm_target_io *alloc_tio(
+		struct clone_info *ci, struct dm_target *ti,
 				      unsigned target_bio_nr, gfp_t gfp_mask)
 {
 	struct dm_target_io *tio;
@@ -609,7 +615,8 @@ static void start_io_acct(struct dm_io *io)
 
 	io->start_time = jiffies;
 
-	generic_start_io_acct(md->queue, rw, bio_sectors(bio), &dm_disk(md)->part0);
+	generic_start_io_acct(
+		md->queue, rw, bio_sectors(bio), &dm_disk(md)->part0);
 
 	atomic_set(&dm_disk(md)->part0.in_flight[rw],
 		   atomic_inc_return(&md->pending[rw]));
@@ -666,14 +673,16 @@ static void queue_io(struct mapped_device *md, struct bio *bio)
  * function to access the md->map field, and make sure they call
  * dm_put_live_table() when finished.
  */
-struct dm_table *dm_get_live_table(struct mapped_device *md, int *srcu_idx) __acquires(md->io_barrier)
+struct dm_table *dm_get_live_table(
+	struct mapped_device *md, int *srcu_idx) __acquires(md->io_barrier)
 {
 	*srcu_idx = srcu_read_lock(&md->io_barrier);
 
 	return srcu_dereference(md->map, &md->io_barrier);
 }
 
-void dm_put_live_table(struct mapped_device *md, int srcu_idx) __releases(md->io_barrier)
+void dm_put_live_table(
+	struct mapped_device *md, int srcu_idx) __releases(md->io_barrier)
 {
 	srcu_read_unlock(&md->io_barrier, srcu_idx);
 }
@@ -688,13 +697,15 @@ void dm_sync_table(struct mapped_device *md)
  * A fast alternative to dm_get_live_table/dm_put_live_table.
  * The caller must not block between these two functions.
  */
-static struct dm_table *dm_get_live_table_fast(struct mapped_device *md) __acquires(RCU)
+static struct dm_table *dm_get_live_table_fast(
+			struct mapped_device *md) __acquires(RCU)
 {
 	rcu_read_lock();
 	return rcu_dereference(md->map);
 }
 
-static void dm_put_live_table_fast(struct mapped_device *md) __releases(RCU)
+static void dm_put_live_table_fast(
+		struct mapped_device *md) __releases(RCU)
 {
 	rcu_read_unlock();
 }
@@ -713,7 +724,8 @@ static int open_table_device(struct table_device *td, dev_t dev,
 
 	BUG_ON(td->dm_dev.bdev);
 
-	bdev = blkdev_get_by_dev(dev, td->dm_dev.mode | FMODE_EXCL, _dm_claim_ptr);
+	bdev = blkdev_get_by_dev(
+		dev, td->dm_dev.mode | FMODE_EXCL, _dm_claim_ptr);
 	if (IS_ERR(bdev))
 		return PTR_ERR(bdev);
 
@@ -731,7 +743,8 @@ static int open_table_device(struct table_device *td, dev_t dev,
 /*
  * Close a table device that we've been using.
  */
-static void close_table_device(struct table_device *td, struct mapped_device *md)
+static void close_table_device(
+		struct table_device *td, struct mapped_device *md)
 {
 	if (!td->dm_dev.bdev)
 		return;
@@ -743,7 +756,8 @@ static void close_table_device(struct table_device *td, struct mapped_device *md
 	td->dm_dev.dax_dev = NULL;
 }
 
-static struct table_device *find_table_device(struct list_head *l, dev_t dev,
+static struct table_device *find_table_device(
+				struct list_head *l, dev_t dev,
 					      fmode_t mode) {
 	struct table_device *td;
 
@@ -932,7 +946,8 @@ static void clone_endio(struct bio *bio)
 	struct mapped_device *md = tio->io->md;
 	dm_endio_fn endio = tio->ti->type->end_io;
 
-	if (unlikely(error == BLK_STS_TARGET) && md->type != DM_TYPE_NVME_BIO_BASED) {
+	if(unlikely(error == BLK_STS_TARGET) 
+		&& md->type != DM_TYPE_NVME_BIO_BASED){
 		if (bio_op(bio) == REQ_OP_WRITE_SAME &&
 		    !bio->bi_disk->queue->limits.max_write_same_sectors)
 			disable_write_same(md);
@@ -961,12 +976,12 @@ static void clone_endio(struct bio *bio)
 	free_tio(tio);
 	dec_pending(io, error);
 }
-
 /*
- * Return maximum size of I/O possible at the supplied sector up to the current
- * target boundary.
+ * Return maximum size of I/O possible at the supplied sector
+ * up to the current target boundary.
  */
-static sector_t max_io_len_target_boundary(sector_t sector, struct dm_target *ti)
+static sector_t max_io_len_target_boundary(
+			sector_t sector, struct dm_target *ti)
 {
 	sector_t target_offset = dm_target_offset(ti, sector);
 
@@ -1064,7 +1079,8 @@ static long dm_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
 	return ret;
 }
 
-static size_t dm_dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
+static size_t dm_dax_copy_from_iter(
+			struct dax_device *dax_dev, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i)
 {
 	struct mapped_device *md = dax_get_private(dax_dev);
@@ -1089,11 +1105,13 @@ static size_t dm_dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 }
 
 /*
- * A target may call dm_accept_partial_bio only from the map routine.  It is
+ * A target may call dm_accept_partial_bio only from the map routine.It is
  * allowed for all bio types except REQ_PREFLUSH and REQ_OP_ZONE_RESET.
  *
- * dm_accept_partial_bio informs the dm that the target only wants to process
- * additional n_sectors sectors of the bio and the rest of the data should be
+ * dm_accept_partial_bio informs the dm that the target only 
+ * wants to process
+ * additional n_sectors sectors of the bio and the rest 
+ * of the data should be
  * sent in a next bio.
  *
  * A diagram that explains the arithmetics:
@@ -1112,8 +1130,10 @@ static size_t dm_dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
  *	 to make it empty)
  * The target requires that region 3 is to be sent in the next bio.
  *
- * If the target wants to receive multiple copies of the bio (via num_*bios, etc),
- * the partially processed part (the sum of regions 1+2) must be the same for all
+ * If the target wants to receive multiple copies of the
+ *  bio (via num_*bios, etc),
+ * the partially processed part (the sum of regions 1+2)
+ *  must be the same for all
  * copies of the bio.
  */
 void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors)
@@ -1136,7 +1156,8 @@ EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
  * REQ_OP_ZONE_REPORT bio to remap the zone descriptors obtained
  * from the target device mapping to the dm device.
  */
-void dm_remap_zone_report(struct dm_target *ti, struct bio *bio, sector_t start)
+void dm_remap_zone_report(
+		struct dm_target *ti, struct bio *bio, sector_t start)
 {
 #ifdef CONFIG_BLK_DEV_ZONED
 	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
@@ -1256,7 +1277,8 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)
 	return ret;
 }
 
-static void bio_setup_sector(struct bio *bio, sector_t sector, unsigned len)
+static void bio_setup_sector(
+		struct bio *bio, sector_t sector, unsigned len)
 {
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_iter.bi_size = to_bytes(len);
@@ -1298,7 +1320,8 @@ static int clone_bio(struct dm_target_io *tio, struct bio *bio,
 	return 0;
 }
 
-static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
+static void alloc_multiple_bios(
+				struct bio_list *blist, struct clone_info *ci,
 				struct dm_target *ti, unsigned num_bios)
 {
 	struct dm_target_io *tio;
@@ -1352,7 +1375,8 @@ static blk_qc_t __clone_and_map_simple_bio(struct clone_info *ci,
 	return __map_bio(tio);
 }
 
-static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
+static void __send_duplicate_bios(
+				struct clone_info *ci, struct dm_target *ti,
 				  unsigned num_bios, unsigned *len)
 {
 	struct bio_list blist = BIO_EMPTY_LIST;
@@ -1379,7 +1403,8 @@ static int __send_empty_flush(struct clone_info *ci)
 	return 0;
 }
 
-static int __clone_and_map_data_bio(struct clone_info *ci, struct dm_target *ti,
+static int __clone_and_map_data_bio(
+			struct clone_info *ci, struct dm_target *ti,
 				    sector_t sector, unsigned *len)
 {
 	struct bio *bio = ci->bio;
@@ -1427,7 +1452,8 @@ static bool is_split_required_for_discard(struct dm_target *ti)
 	return ti->split_discard_bios;
 }
 
-static int __send_changing_extent_only(struct clone_info *ci, struct dm_target *ti,
+static int __send_changing_extent_only(
+			struct clone_info *ci, struct dm_target *ti,
 				       get_num_bios_fn get_num_bios,
 				       is_split_required_fn is_split_required)
 {
@@ -1445,7 +1471,8 @@ static int __send_changing_extent_only(struct clone_info *ci, struct dm_target *
 		return -EOPNOTSUPP;
 
 	if (is_split_required && !is_split_required(ti))
-		len = min((sector_t)ci->sector_count, max_io_len_target_boundary(ci->sector, ti));
+		len = min((sector_t)ci->sector_count, 
+			max_io_len_target_boundary(ci->sector, ti));
 	else
 		len = min((sector_t)ci->sector_count, max_io_len(ci->sector, ti));
 
@@ -1465,7 +1492,8 @@ static int __send_discard(struct clone_info *ci, struct dm_target *ti)
 
 static int __send_secure_erase(struct clone_info *ci, struct dm_target *ti)
 {
-	return __send_changing_extent_only(ci, ti, get_num_secure_erase_bios, NULL);
+	return __send_changing_extent_only(
+				ci, ti, get_num_secure_erase_bios, NULL);
 }
 
 static int __send_write_same(struct clone_info *ci, struct dm_target *ti)
@@ -1475,10 +1503,12 @@ static int __send_write_same(struct clone_info *ci, struct dm_target *ti)
 
 static int __send_write_zeroes(struct clone_info *ci, struct dm_target *ti)
 {
-	return __send_changing_extent_only(ci, ti, get_num_write_zeroes_bios, NULL);
+	return __send_changing_extent_only(
+				ci, ti, get_num_write_zeroes_bios, NULL);
 }
 
-static bool __process_abnormal_io(struct clone_info *ci, struct dm_target *ti,
+static bool __process_abnormal_io(
+			struct clone_info *ci, struct dm_target *ti,
 				  int *result)
 {
 	struct bio *bio = ci->bio;
@@ -1530,7 +1560,8 @@ static int __split_and_process_non_flush(struct clone_info *ci)
 	return 0;
 }
 
-static void init_clone_info(struct clone_info *ci, struct mapped_device *md,
+static void init_clone_info(
+		struct clone_info *ci, struct mapped_device *md,
 			    struct dm_table *map, struct bio *bio)
 {
 	ci->map = map;
@@ -1647,7 +1678,8 @@ static blk_qc_t __process_bio(struct mapped_device *md,
 	return ret;
 }
 
-typedef blk_qc_t (process_bio_fn)(struct mapped_device *, struct dm_table *, struct bio *);
+typedef blk_qc_t (process_bio_fn)(struct mapped_device *,
+			struct dm_table *, struct bio *);
 
 static blk_qc_t __dm_make_request(struct request_queue *q, struct bio *bio,
 				  process_bio_fn process_bio)
@@ -1685,7 +1717,8 @@ static blk_qc_t dm_make_request(struct request_queue *q, struct bio *bio)
 	return __dm_make_request(q, bio, __split_and_process_bio);
 }
 
-static blk_qc_t dm_make_request_nvme(struct request_queue *q, struct bio *bio)
+static blk_qc_t dm_make_request_nvme(
+			struct request_queue *q, struct bio *bio)
 {
 	return __dm_make_request(q, bio, __process_bio);
 }
@@ -2031,7 +2064,8 @@ static void __set_size(struct mapped_device *md, sector_t size)
 /*
  * Returns old map, which caller must destroy.
  */
-static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
+static struct dm_table *__bind(
+			struct mapped_device *md, struct dm_table *t,
 			       struct queue_limits *limits)
 {
 	struct dm_table *old_map;
@@ -2075,7 +2109,8 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 
 	__bind_mempools(md, t);
 
-	old_map = rcu_dereference_protected(md->map, lockdep_is_held(&md->suspend_lock));
+	old_map = rcu_dereference_protected(
+		md->map, lockdep_is_held(&md->suspend_lock));
 	rcu_assign_pointer(md->map, (void *)t);
 	md->immutable_target_type = dm_table_get_immutable_target_type(t);
 
@@ -2227,7 +2262,8 @@ struct mapped_device *dm_get_md(dev_t dev)
 	spin_lock(&_minor_lock);
 
 	md = idr_find(&_minor_idr, minor);
-	if (!md || md == MINOR_ALLOCED || (MINOR(disk_devt(dm_disk(md))) != minor) ||
+	if (!md || md == MINOR_ALLOCED || (
+		MINOR(disk_devt(dm_disk(md))) != minor) ||
 	    test_bit(DMF_FREEING, &md->flags) || dm_deleting_md(md)) {
 		md = NULL;
 		goto out;
@@ -2302,7 +2338,8 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
 		dm_table_presuspend_targets(map);
 		dm_table_postsuspend_targets(map);
 	}
-	/* dm_put_live_table must be before msleep, otherwise deadlock is possible */
+	/* dm_put_live_table must be before msleep,
+	 * otherwise deadlock is possible */
 	dm_put_live_table(md, srcu_idx);
 	mutex_unlock(&md->suspend_lock);
 
@@ -2340,7 +2377,8 @@ void dm_put(struct mapped_device *md)
 }
 EXPORT_SYMBOL_GPL(dm_put);
 
-static int dm_wait_for_completion(struct mapped_device *md, long task_state)
+static int dm_wait_for_completion(
+		struct mapped_device *md, long task_state)
 {
 	int r = 0;
 	DEFINE_WAIT(wait);
@@ -2403,7 +2441,8 @@ static void dm_queue_flush(struct mapped_device *md)
 /*
  * Swap in a new table, returning the old one for the caller to destroy.
  */
-struct dm_table *dm_swap_table(struct mapped_device *md, struct dm_table *table)
+struct dm_table *dm_swap_table(
+		struct mapped_device *md, struct dm_table *table)
 {
 	struct dm_table *live_map = NULL, *map = ERR_PTR(-EINVAL);
 	struct queue_limits limits;
@@ -2613,15 +2652,18 @@ int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 	if (dm_suspended_internally_md(md)) {
 		/* already internally suspended, wait for internal resume */
 		mutex_unlock(&md->suspend_lock);
-		r = wait_on_bit(&md->flags, DMF_SUSPENDED_INTERNALLY, TASK_INTERRUPTIBLE);
+		r = wait_on_bit(&md->flags, DMF_SUSPENDED_INTERNALLY,
+			TASK_INTERRUPTIBLE);
 		if (r)
 			return r;
 		goto retry;
 	}
 
-	map = rcu_dereference_protected(md->map, lockdep_is_held(&md->suspend_lock));
+	map = rcu_dereference_protected(
+			md->map, lockdep_is_held(&md->suspend_lock));
 
-	r = __dm_suspend(md, map, suspend_flags, TASK_INTERRUPTIBLE, DMF_SUSPENDED);
+	r = __dm_suspend(md, map, suspend_flags,
+		TASK_INTERRUPTIBLE, DMF_SUSPENDED);
 	if (r)
 		goto out_unlock;
 
@@ -2645,7 +2687,8 @@ static int __dm_resume(struct mapped_device *md, struct dm_table *map)
 	/*
 	 * Flushing deferred I/Os must be done after targets are resumed
 	 * so that mapping of targets can work correctly.
-	 * Request-based dm is queueing the deferred I/Os in its request_queue.
+	 * Request-based dm is queueing the deferred I/Os in its
+	 * request_queue.
 	 */
 	if (dm_request_based(md))
 		dm_start_queue(md->queue);
@@ -2670,13 +2713,15 @@ int dm_resume(struct mapped_device *md)
 	if (dm_suspended_internally_md(md)) {
 		/* already internally suspended, wait for internal resume */
 		mutex_unlock(&md->suspend_lock);
-		r = wait_on_bit(&md->flags, DMF_SUSPENDED_INTERNALLY, TASK_INTERRUPTIBLE);
+		r = wait_on_bit(
+			&md->flags, DMF_SUSPENDED_INTERNALLY, TASK_INTERRUPTIBLE);
 		if (r)
 			return r;
 		goto retry;
 	}
 
-	map = rcu_dereference_protected(md->map, lockdep_is_held(&md->suspend_lock));
+	map = rcu_dereference_protected(
+		md->map, lockdep_is_held(&md->suspend_lock));
 	if (!map || !dm_table_get_size(map))
 		goto out;
 
@@ -2693,11 +2738,13 @@ int dm_resume(struct mapped_device *md)
 
 /*
  * Internal suspend/resume works like userspace-driven suspend. It waits
- * until all bios finish and prevents issuing new bios to the target drivers.
+ * until all bios finish and prevents issuing new bios
+ * to the target drivers.
  * It may be used only from the kernel.
  */
 
-static void __dm_internal_suspend(struct mapped_device *md, unsigned suspend_flags)
+static void __dm_internal_suspend(
+		struct mapped_device *md, unsigned suspend_flags)
 {
 	struct dm_table *map = NULL;
 
@@ -2711,7 +2758,8 @@ static void __dm_internal_suspend(struct mapped_device *md, unsigned suspend_fla
 		return; /* nest suspend */
 	}
 
-	map = rcu_dereference_protected(md->map, lockdep_is_held(&md->suspend_lock));
+	map = rcu_dereference_protected(
+			md->map, lockdep_is_held(&md->suspend_lock));
 
 	/*
 	 * Using TASK_UNINTERRUPTIBLE because only NOFLUSH internal suspend is
@@ -2897,11 +2945,13 @@ int dm_noflush_suspending(struct dm_target *ti)
 }
 EXPORT_SYMBOL_GPL(dm_noflush_suspending);
 
-struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, enum dm_queue_mode type,
+struct dm_md_mempools *dm_alloc_md_mempools(
+			struct mapped_device *md, enum dm_queue_mode type,
 					    unsigned integrity, unsigned per_io_data_size,
 					    unsigned min_pool_size)
 {
-	struct dm_md_mempools *pools = kzalloc_node(sizeof(*pools), GFP_KERNEL, md->numa_node_id);
+	struct dm_md_mempools *pools = kzalloc_node(
+			sizeof(*pools), GFP_KERNEL, md->numa_node_id);
 	unsigned int pool_size = 0;
 	unsigned int front_pad, io_front_pad;
 
@@ -2913,8 +2963,10 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, enum dm_qu
 	case DM_TYPE_DAX_BIO_BASED:
 	case DM_TYPE_NVME_BIO_BASED:
 		pool_size = max(dm_get_reserved_bio_based_ios(), min_pool_size);
-		front_pad = roundup(per_io_data_size, __alignof__(struct dm_target_io)) + offsetof(struct dm_target_io, clone);
-		io_front_pad = roundup(front_pad,  __alignof__(struct dm_io)) + offsetof(struct dm_io, tio);
+		front_pad = roundup(per_io_data_size, __alignof__(
+			struct dm_target_io)) + offsetof(struct dm_target_io, clone);
+		io_front_pad = roundup(
+		front_pad,  __alignof__(struct dm_io)) + offsetof(struct dm_io, tio);
 		pools->io_bs = bioset_create(pool_size, io_front_pad, 0);
 		if (!pools->io_bs)
 			goto out;
@@ -2966,7 +3018,8 @@ struct dm_pr {
 	bool	fail_early;
 };
 
-static int dm_call_pr(struct block_device *bdev, iterate_devices_callout_fn fn,
+static int dm_call_pr(
+		struct block_device *bdev, iterate_devices_callout_fn fn,
 		      void *data)
 {
 	struct mapped_device *md = bdev->bd_disk->private_data;
@@ -3007,7 +3060,8 @@ static int __dm_pr_register(struct dm_target *ti, struct dm_dev *dev,
 	return ops->pr_register(dev->bdev, pr->old_key, pr->new_key, pr->flags);
 }
 
-static int dm_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
+static int dm_pr_register(
+		struct block_device *bdev, u64 old_key, u64 new_key,
 			  u32 flags)
 {
 	struct dm_pr pr = {
@@ -3031,7 +3085,8 @@ static int dm_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
 	return ret;
 }
 
-static int dm_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
+static int dm_pr_reserve(
+		struct block_device *bdev, u64 key, enum pr_type type,
 			 u32 flags)
 {
 	struct mapped_device *md = bdev->bd_disk->private_data;
@@ -3052,7 +3107,8 @@ static int dm_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
 	return r;
 }
 
-static int dm_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
+static int dm_pr_release(
+	struct block_device *bdev, u64 key, enum pr_type type)
 {
 	struct mapped_device *md = bdev->bd_disk->private_data;
 	const struct pr_ops *ops;
@@ -3072,7 +3128,8 @@ static int dm_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
 	return r;
 }
 
-static int dm_pr_preempt(struct block_device *bdev, u64 old_key, u64 new_key,
+static int dm_pr_preempt(
+		struct block_device *bdev, u64 old_key, u64 new_key,
 			 enum pr_type type, bool abort)
 {
 	struct mapped_device *md = bdev->bd_disk->private_data;
@@ -3145,10 +3202,12 @@ module_param(major, uint, 0);
 MODULE_PARM_DESC(major, "The major number of the device mapper");
 
 module_param(reserved_bio_based_ios, uint, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(reserved_bio_based_ios, "Reserved IOs in bio-based mempools");
+MODULE_PARM_DESC(
+	reserved_bio_based_ios, "Reserved IOs in bio-based mempools");
 
 module_param(dm_numa_node, int, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(dm_numa_node, "NUMA node for DM device memory allocations");
+MODULE_PARM_DESC(
+	dm_numa_node, "NUMA node for DM device memory allocations");
 
 MODULE_DESCRIPTION(DM_NAME " driver");
 MODULE_AUTHOR("Joe Thornber <dm-devel@redhat.com>");
-- 
2.7.4
