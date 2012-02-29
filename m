From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 11/13] dm thin: add discard support
Date: Wed, 29 Feb 2012 09:50:15 -0500
Message-ID: <1330527017-28618-12-git-send-email-snitzer@redhat.com>
References: <1330527017-28618-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1330527017-28618-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Joe Thornber <ejt@redhat.com>, snitzer@redhat.com
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

On discard the corresponding mapping(s) are removed from the thin
device.  If the associated block(s) are no longer shared the discard is
passed to the underlying device.

All bios other than discards now have an associated deferred_entry that
is saved to the 'all_io_entry' in endio_hook.  When non-discard IO
completes and associated mappings are quiesced any discards that were
deferred, via ds_add_work() in process_discard(), will be queued for
processing by the worker thread.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c |  176 +++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 161 insertions(+), 15 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index bcbe86f..fec7ddb 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -73,7 +73,7 @@
  * missed out if the io covers the block. (schedule_copy).
  *
  * iv) insert the new mapping into the origin's btree
- * (process_prepared_mappings).  This act of inserting breaks some
+ * (process_prepared_mapping).  This act of inserting breaks some
  * sharing of btree nodes between the two devices.  Breaking sharing only
  * effects the btree of that specific device.  Btrees for the other
  * devices that share the block never change.  The btree for the origin
@@ -531,10 +531,12 @@ struct pool {
 	struct bio_list deferred_bios;
 	struct bio_list deferred_flush_bios;
 	struct list_head prepared_mappings;
+	struct list_head prepared_discards;
 
 	struct bio_list retry_on_resume_list;
 
 	struct deferred_set shared_read_ds;
+	struct deferred_set all_io_ds;
 
 	struct new_mapping *next_mapping;
 	mempool_t *mapping_pool;
@@ -632,6 +634,7 @@ static struct pool *__pool_table_lookup_metadata_dev(struct block_device *md_dev
 struct endio_hook {
 	struct thin_c *tc;
 	struct deferred_entry *shared_read_entry;
+	struct deferred_entry *all_io_entry;
 	struct new_mapping *overwrite_mapping;
 };
 
@@ -739,11 +742,12 @@ struct new_mapping {
 
 	unsigned quiesced:1;
 	unsigned prepared:1;
+	unsigned pass_discard:1;
 
 	struct thin_c *tc;
 	dm_block_t virt_block;
 	dm_block_t data_block;
-	struct cell *cell;
+	struct cell *cell, *cell2;
 	int err;
 
 	/*
@@ -883,7 +887,30 @@ static void process_prepared_mapping(struct new_mapping *m)
 	mempool_free(m, tc->pool->mapping_pool);
 }
 
-static void process_prepared_mappings(struct pool *pool)
+static void process_prepared_discard(struct new_mapping *m)
+{
+	int r;
+	struct thin_c *tc = m->tc;
+
+	r = dm_thin_remove_block(tc->td, m->virt_block);
+	if (r)
+		DMERR("dm_thin_remove_block() failed");
+
+	/*
+	 * Pass the discard down to the underlying device?
+	 */
+	if (m->pass_discard)
+		remap_and_issue(tc, m->bio, m->data_block);
+	else
+		bio_endio(m->bio, 0);
+
+	cell_defer_except(tc, m->cell);
+	cell_defer_except(tc, m->cell2);
+	mempool_free(m, tc->pool->mapping_pool);
+}
+
+static void process_prepared(struct pool *pool, struct list_head *head,
+			     void (*fn)(struct new_mapping *))
 {
 	unsigned long flags;
 	struct list_head maps;
@@ -891,21 +918,27 @@ static void process_prepared_mappings(struct pool *pool)
 
 	INIT_LIST_HEAD(&maps);
 	spin_lock_irqsave(&pool->lock, flags);
-	list_splice_init(&pool->prepared_mappings, &maps);
+	list_splice_init(head, &maps);
 	spin_unlock_irqrestore(&pool->lock, flags);
 
 	list_for_each_entry_safe(m, tmp, &maps, list)
-		process_prepared_mapping(m);
+		fn(m);
 }
 
 /*
  * Deferred bio jobs.
  */
-static int io_overwrites_block(struct pool *pool, struct bio *bio)
+static int io_overlaps_block(struct pool *pool, struct bio *bio)
 {
-	return ((bio_data_dir(bio) == WRITE) &&
-		!(bio->bi_sector & pool->offset_mask)) &&
+	return !(bio->bi_sector & pool->offset_mask) &&
 		(bio->bi_size == (pool->sectors_per_block << SECTOR_SHIFT));
+
+}
+
+static int io_overwrites_block(struct pool *pool, struct bio *bio)
+{
+	return (bio_data_dir(bio) == WRITE) &&
+		io_overlaps_block(pool, bio);
 }
 
 static void save_and_set_endio(struct bio *bio, bio_end_io_t **save,
@@ -1143,6 +1176,86 @@ static void no_space(struct cell *cell)
 		retry_on_resume(bio);
 }
 
+static void process_discard(struct thin_c *tc, struct bio *bio)
+{
+	int r;
+	struct pool *pool = tc->pool;
+	struct cell *cell, *cell2;
+	struct cell_key key, key2;
+	dm_block_t block = get_bio_block(tc, bio);
+	struct dm_thin_lookup_result lookup_result;
+	struct new_mapping *m;
+
+	build_virtual_key(tc->td, block, &key);
+	if (bio_detain(tc->pool->prison, &key, bio, &cell))
+		return;
+
+	r = dm_thin_find_block(tc->td, block, 1, &lookup_result);
+	switch (r) {
+	case 0:
+		/*
+		 * Check nobody is fiddling with this pool block.  This can
+		 * happen if someone's in the process of breaking sharing
+		 * on this block.
+		 */
+		build_data_key(tc->td, lookup_result.block, &key2);
+		if (bio_detain(tc->pool->prison, &key2, bio, &cell2)) {
+			cell_release_singleton(cell, bio);
+			break;
+		}
+
+		if (io_overlaps_block(pool, bio)) {
+			/*
+			 * IO may still be going to the destination block.  We must
+			 * quiesce before we can do the removal.
+			 */
+			m = get_next_mapping(pool);
+			m->tc = tc;
+			m->pass_discard = !lookup_result.shared;
+			m->virt_block = block;
+			m->data_block = lookup_result.block;
+			m->cell = cell;
+			m->cell2 = cell2;
+			m->err = 0;
+			m->bio = bio;
+
+			if (!ds_add_work(&pool->all_io_ds, &m->list)) {
+				list_add(&m->list, &pool->prepared_discards);
+				wake_worker(pool);
+			}
+		} else {
+			/*
+			 * This path is hit if people are ignoring
+			 * limits->discard_granularity.  It ignores any
+			 * part of the discard that is in a subsequent
+			 * block.
+			 */
+			sector_t offset = bio->bi_sector - (block << pool->block_shift);
+			unsigned remaining = (pool->sectors_per_block - offset) << 9;
+			bio->bi_size = min(bio->bi_size, remaining);
+
+			cell_release_singleton(cell, bio);
+			cell_release_singleton(cell2, bio);
+			remap_and_issue(tc, bio, lookup_result.block);
+		}
+		break;
+
+	case -ENODATA:
+		/*
+		 * It isn't provisioned, just forget it.
+		 */
+		cell_release_singleton(cell, bio);
+		bio_endio(bio, 0);
+		break;
+
+	default:
+		DMERR("discard: find block unexpectedly returned %d\n", r);
+		cell_release_singleton(cell, bio);
+		bio_io_error(bio);
+		break;
+	}
+}
+
 static void break_sharing(struct thin_c *tc, struct bio *bio, dm_block_t block,
 			  struct cell_key *key,
 			  struct dm_thin_lookup_result *lookup_result,
@@ -1288,6 +1401,7 @@ static void process_bio(struct thin_c *tc, struct bio *bio)
 
 	default:
 		DMERR("dm_thin_find_block() failed, error = %d", r);
+		cell_release_singleton(cell, bio);
 		bio_io_error(bio);
 		break;
 	}
@@ -1329,7 +1443,11 @@ static void process_deferred_bios(struct pool *pool)
 
 			break;
 		}
-		process_bio(tc, bio);
+
+		if (bio->bi_rw & REQ_DISCARD)
+			process_discard(tc, bio);
+		else
+			process_bio(tc, bio);
 	}
 
 	/*
@@ -1363,7 +1481,8 @@ static void do_worker(struct work_struct *ws)
 {
 	struct pool *pool = container_of(ws, struct pool, worker);
 
-	process_prepared_mappings(pool);
+	process_prepared(pool, &pool->prepared_mappings, process_prepared_mapping);
+	process_prepared(pool, &pool->prepared_discards, process_prepared_discard);
 	process_deferred_bios(pool);
 }
 
@@ -1406,6 +1525,7 @@ static struct endio_hook *thin_hook_bio(struct thin_c *tc, struct bio *bio)
 
 	h->tc = tc;
 	h->shared_read_entry = NULL;
+	h->all_io_entry = bio->bi_rw & REQ_DISCARD ? NULL : ds_inc(&pool->all_io_ds);
 	h->overwrite_mapping = NULL;
 
 	return h;
@@ -1424,7 +1544,7 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio,
 	struct dm_thin_lookup_result result;
 
 	map_context->ptr = thin_hook_bio(tc, bio);
-	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA)) {
+	if (bio->bi_rw & (REQ_DISCARD | REQ_FLUSH | REQ_FUA)) {
 		thin_defer_bio(tc, bio);
 		return DM_MAPIO_SUBMITTED;
 	}
@@ -1600,10 +1720,12 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 	bio_list_init(&pool->deferred_bios);
 	bio_list_init(&pool->deferred_flush_bios);
 	INIT_LIST_HEAD(&pool->prepared_mappings);
+	INIT_LIST_HEAD(&pool->prepared_discards);
 	pool->low_water_triggered = 0;
 	pool->no_free_space = 0;
 	bio_list_init(&pool->retry_on_resume_list);
 	ds_init(&pool->shared_read_ds);
+	ds_init(&pool->all_io_ds);
 
 	pool->next_mapping = NULL;
 	pool->mapping_pool =
@@ -1844,7 +1966,8 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	pt->low_water_blocks = low_water_blocks;
 	pt->zero_new_blocks = pf.zero_new_blocks;
 	ti->num_flush_requests = 1;
-	ti->num_discard_requests = 0;
+	ti->num_discard_requests = 1;
+	ti->discards_supported = 1;
 	ti->private = pt;
 
 	pt->callbacks.congested_fn = pool_is_congested;
@@ -2275,6 +2398,18 @@ static int pool_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
 	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
 }
 
+static void set_discard_limits(struct pool *pool, struct queue_limits *limits)
+{
+	limits->max_discard_sectors = pool->sectors_per_block;
+
+	/*
+	 * This is just a hint, and not enforced.  We have to cope with
+	 * bios that overlap 2 blocks.
+	 */
+	limits->discard_granularity = pool->sectors_per_block << SECTOR_SHIFT;
+	limits->discard_zeroes_data = pool->zero_new_blocks;
+}
+
 static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
 {
 	struct pool_c *pt = ti->private;
@@ -2282,6 +2417,7 @@ static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 	blk_limits_io_min(limits, 0);
 	blk_limits_io_opt(limits, pool->sectors_per_block << SECTOR_SHIFT);
+	set_discard_limits(pool, limits);
 }
 
 static struct target_type pool_target = {
@@ -2398,8 +2534,8 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	ti->split_io = tc->pool->sectors_per_block;
 	ti->num_flush_requests = 1;
-	ti->num_discard_requests = 0;
-	ti->discards_supported = 0;
+	ti->num_discard_requests = 1;
+	ti->discards_supported = 1;
 
 	dm_put(pool_md);
 
@@ -2455,6 +2591,14 @@ static int thin_endio(struct dm_target *ti,
 		spin_unlock_irqrestore(&pool->lock, flags);
 	}
 
+	if (h->all_io_entry) {
+		INIT_LIST_HEAD(&work);
+		ds_dec(h->all_io_entry, &work);
+		list_for_each_entry_safe(m, tmp, &work, list)
+			list_add(&m->list, &pool->prepared_discards);
+	}
+
+	mempool_free(h, pool->endio_hook_pool);
 	return 0;
 }
 
@@ -2531,9 +2675,11 @@ static int thin_iterate_devices(struct dm_target *ti,
 static void thin_io_hints(struct dm_target *ti, struct queue_limits *limits)
 {
 	struct thin_c *tc = ti->private;
+	struct pool *pool = tc->pool;
 
 	blk_limits_io_min(limits, 0);
-	blk_limits_io_opt(limits, tc->pool->sectors_per_block << SECTOR_SHIFT);
+	blk_limits_io_opt(limits, pool->sectors_per_block << SECTOR_SHIFT);
+	set_discard_limits(pool, limits);
 }
 
 static struct target_type thin_target = {
-- 
1.7.1
