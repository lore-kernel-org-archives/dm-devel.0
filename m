From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-4.2 11/14] dm thin: range discard support
Date: Thu, 14 May 2015 17:05:09 -0400
Message-ID: <1431637512-64245-12-git-send-email-snitzer@redhat.com>
References: <1431637512-64245-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1431637512-64245-1-git-send-email-snitzer@redhat.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

Previously REQ_DISCARD bios have been split into block sized chunks
before submission to the thin target.  There are a couple of issues with
this:

 - If the block size is small, a large discard request can
   get broken up into a great many bios which is both slow and causes
   a lot of memory pressure.

 - The thin pool block size and the discard granularity for the
   underlying data device need to be compatible if we want to passdown
   the discard.

This patch relaxes the block size granularity for thin devices.  It
makes use of the recent range locking added to the bio_prison to
quiesce a whole range of thin blocks before unmapping them.  Once a
thin range has been unmapped the discard can then be passed down to
the data device for those sub ranges where the data blocks are no
longer used (ie. they weren't shared in the first place).

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c | 463 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 314 insertions(+), 149 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index e852602c..aa71bdd 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -111,22 +111,30 @@ DECLARE_DM_KCOPYD_THROTTLE_WITH_MODULE_PARM(snapshot_copy_throttle,
 /*
  * Key building.
  */
-static void build_data_key(struct dm_thin_device *td,
-			   dm_block_t b, struct dm_cell_key *key)
+enum lock_space {
+	VIRTUAL,
+	PHYSICAL
+};
+
+static void build_key(struct dm_thin_device *td, enum lock_space ls,
+		      dm_block_t b, dm_block_t e, struct dm_cell_key *key)
 {
-	key->virtual = 0;
+	key->virtual = (ls == VIRTUAL);
 	key->dev = dm_thin_dev_id(td);
 	key->block_begin = b;
-	key->block_end = b + 1ULL;
+	key->block_end = e;
+}
+
+static void build_data_key(struct dm_thin_device *td, dm_block_t b,
+			   struct dm_cell_key *key)
+{
+	build_key(td, PHYSICAL, b, b + 1llu, key);
 }
 
 static void build_virtual_key(struct dm_thin_device *td, dm_block_t b,
 			      struct dm_cell_key *key)
 {
-	key->virtual = 1;
-	key->dev = dm_thin_dev_id(td);
-	key->block_begin = b;
-	key->block_end = b + 1ULL;
+	build_key(td, VIRTUAL, b, b + 1llu, key);
 }
 
 /*----------------------------------------------------------------*/
@@ -312,6 +320,35 @@ struct thin_c {
 
 /*----------------------------------------------------------------*/
 
+static bool block_size_is_power_of_two(struct pool *pool)
+{
+	return pool->sectors_per_block_shift >= 0;
+}
+
+static sector_t block_to_sectors(struct pool *pool, dm_block_t b)
+{
+	return block_size_is_power_of_two(pool) ?
+		(b << pool->sectors_per_block_shift) :
+		(b * pool->sectors_per_block);
+}
+
+static void dm_thin_discard_set_completion(struct bio *bio, void *data)
+{
+	bio_chain(bio, data);
+}
+
+static int issue_discard(struct thin_c *tc, dm_block_t data_b, dm_block_t data_e,
+			 struct bio *parent_bio)
+{
+	sector_t s = block_to_sectors(tc->pool, data_b);
+	sector_t len = block_to_sectors(tc->pool, data_e - data_b);
+
+	return blkdev_issue_discard_async(tc->pool_dev->bdev, s, len, GFP_NOWAIT, 0,
+					  dm_thin_discard_set_completion, parent_bio);
+}
+
+/*----------------------------------------------------------------*/
+
 /*
  * wake_worker() is used when new work is queued and when pool_resume is
  * ready to continue deferred IO processing.
@@ -461,6 +498,7 @@ struct dm_thin_endio_hook {
 	struct dm_deferred_entry *all_io_entry;
 	struct dm_thin_new_mapping *overwrite_mapping;
 	struct rb_node rb_node;
+	struct dm_bio_prison_cell *cell;
 };
 
 static void __merge_bio_list(struct bio_list *bios, struct bio_list *master)
@@ -541,11 +579,6 @@ static void error_retry_list(struct pool *pool)
  * target.
  */
 
-static bool block_size_is_power_of_two(struct pool *pool)
-{
-	return pool->sectors_per_block_shift >= 0;
-}
-
 static dm_block_t get_bio_block(struct thin_c *tc, struct bio *bio)
 {
 	struct pool *pool = tc->pool;
@@ -559,6 +592,34 @@ static dm_block_t get_bio_block(struct thin_c *tc, struct bio *bio)
 	return block_nr;
 }
 
+/*
+ * Returns the _complete_ blocks that this bio covers.
+ */
+static void get_bio_block_range(struct thin_c *tc, struct bio *bio,
+				dm_block_t *begin, dm_block_t *end)
+{
+	struct pool *pool = tc->pool;
+	sector_t b = bio->bi_iter.bi_sector;
+	sector_t e = b + (bio->bi_iter.bi_size >> SECTOR_SHIFT);
+
+	b += pool->sectors_per_block - 1ull; /* so we round up */
+
+	if (block_size_is_power_of_two(pool)) {
+		b >>= pool->sectors_per_block_shift;
+		e >>= pool->sectors_per_block_shift;
+	} else {
+		(void) sector_div(b, pool->sectors_per_block);
+		(void) sector_div(e, pool->sectors_per_block);
+	}
+
+	if (e < b)
+		/* Can happen if the bio is within a single block. */
+		e = b;
+
+	*begin = b;
+	*end = e;
+}
+
 static void remap(struct thin_c *tc, struct bio *bio, dm_block_t block)
 {
 	struct pool *pool = tc->pool;
@@ -647,7 +708,7 @@ struct dm_thin_new_mapping {
 	struct list_head list;
 
 	bool pass_discard:1;
-	bool definitely_not_shared:1;
+	bool maybe_shared:1;
 
 	/*
 	 * Track quiescing, copying and zeroing preparation actions.  When this
@@ -658,9 +719,9 @@ struct dm_thin_new_mapping {
 
 	int err;
 	struct thin_c *tc;
-	dm_block_t virt_block;
+	dm_block_t virt_begin, virt_end;
 	dm_block_t data_block;
-	struct dm_bio_prison_cell *cell, *cell2;
+	struct dm_bio_prison_cell *cell;
 
 	/*
 	 * If the bio covers the whole area of a block then we can avoid
@@ -822,7 +883,7 @@ static void process_prepared_mapping(struct dm_thin_new_mapping *m)
 	 * Any I/O for this block arriving after this point will get
 	 * remapped to it directly.
 	 */
-	r = dm_thin_insert_block(tc->td, m->virt_block, m->data_block);
+	r = dm_thin_insert_block(tc->td, m->cell->key.block_begin, m->data_block);
 	if (r) {
 		metadata_operation_failed(pool, "dm_thin_insert_block", r);
 		cell_error(pool, m->cell);
@@ -849,50 +910,112 @@ out:
 	mempool_free(m, pool->mapping_pool);
 }
 
-static void process_prepared_discard_fail(struct dm_thin_new_mapping *m)
+/*----------------------------------------------------------------*/
+
+static void free_discard_mapping(struct dm_thin_new_mapping *m)
 {
 	struct thin_c *tc = m->tc;
+	if (m->cell)
+		cell_defer_no_holder(tc, m->cell);
+	mempool_free(m, tc->pool->mapping_pool);
+}
 
+static void process_prepared_discard_fail(struct dm_thin_new_mapping *m)
+{
 	bio_io_error(m->bio);
+	free_discard_mapping(m);
+}
+
+static void process_prepared_discard_success(struct dm_thin_new_mapping *m)
+{
+	bio_endio(m->bio, 0);
+	free_discard_mapping(m);
+}
+
+static void process_prepared_discard_no_passdown(struct dm_thin_new_mapping *m)
+{
+	int r;
+	struct thin_c *tc = m->tc;
+
+	r = dm_thin_remove_range(tc->td, m->cell->key.block_begin, m->cell->key.block_end);
+	if (r) {
+		metadata_operation_failed(tc->pool, "dm_thin_remove_range", r);
+		bio_io_error(m->bio);
+	} else
+		bio_endio(m->bio, 0);
+
 	cell_defer_no_holder(tc, m->cell);
-	cell_defer_no_holder(tc, m->cell2);
 	mempool_free(m, tc->pool->mapping_pool);
 }
 
-static void process_prepared_discard_passdown(struct dm_thin_new_mapping *m)
+static int passdown_double_checking_shared_status(struct dm_thin_new_mapping *m)
 {
+	/*
+	 * We've already unmapped this range of blocks, but before we
+	 * passdown we have to check that these blocks are now unused.
+	 */
+	int r;
+	bool used = true;
 	struct thin_c *tc = m->tc;
+	struct pool *pool = tc->pool;
+	dm_block_t b = m->data_block, e, end = m->data_block + m->virt_end - m->virt_begin;
 
-	inc_all_io_entry(tc->pool, m->bio);
-	cell_defer_no_holder(tc, m->cell);
-	cell_defer_no_holder(tc, m->cell2);
+	while (b != end) {
+		/* find start of unmapped run */
+		for (; b < end; b++) {
+			r = dm_pool_block_is_used(pool->pmd, b, &used);
+			if (r)
+				return r;
 
-	if (m->pass_discard)
-		if (m->definitely_not_shared)
-			remap_and_issue(tc, m->bio, m->data_block);
-		else {
-			bool used = false;
-			if (dm_pool_block_is_used(tc->pool->pmd, m->data_block, &used) || used)
-				bio_endio(m->bio, 0);
-			else
-				remap_and_issue(tc, m->bio, m->data_block);
+			if (!used)
+				break;
 		}
-	else
-		bio_endio(m->bio, 0);
 
-	mempool_free(m, tc->pool->mapping_pool);
+		if (b == end)
+			break;
+
+		/* find end of run */
+		for (e = b + 1; e != end; e++) {
+			r = dm_pool_block_is_used(pool->pmd, e, &used);
+			if (r)
+				return r;
+
+			if (used)
+				break;
+		}
+
+		r = issue_discard(tc, b, e, m->bio);
+		if (r)
+			return r;
+
+		b = e;
+	}
+
+	return 0;
 }
 
-static void process_prepared_discard(struct dm_thin_new_mapping *m)
+static void process_prepared_discard_passdown(struct dm_thin_new_mapping *m)
 {
 	int r;
 	struct thin_c *tc = m->tc;
+	struct pool *pool = tc->pool;
 
-	r = dm_thin_remove_block(tc->td, m->virt_block);
+	r = dm_thin_remove_range(tc->td, m->virt_begin, m->virt_end);
 	if (r)
-		DMERR_LIMIT("dm_thin_remove_block() failed");
+		metadata_operation_failed(pool, "dm_thin_remove_range", r);
 
-	process_prepared_discard_passdown(m);
+	else if (m->maybe_shared)
+		r = passdown_double_checking_shared_status(m);
+	else
+		r = issue_discard(tc, m->data_block, m->data_block + (m->virt_end - m->virt_begin), m->bio);
+
+	/*
+	 * Even if r is set, there could be sub discards in flight that we
+	 * need to wait for.
+	 */
+	bio_endio(m->bio, r);
+	cell_defer_no_holder(tc, m->cell);
+	mempool_free(m, pool->mapping_pool);
 }
 
 static void process_prepared(struct pool *pool, struct list_head *head,
@@ -976,7 +1099,7 @@ static void ll_zero(struct thin_c *tc, struct dm_thin_new_mapping *m,
 }
 
 static void remap_and_issue_overwrite(struct thin_c *tc, struct bio *bio,
-				      dm_block_t data_block,
+				      dm_block_t data_begin,
 				      struct dm_thin_new_mapping *m)
 {
 	struct pool *pool = tc->pool;
@@ -986,7 +1109,7 @@ static void remap_and_issue_overwrite(struct thin_c *tc, struct bio *bio,
 	m->bio = bio;
 	save_and_set_endio(bio, &m->saved_bi_end_io, overwrite_endio);
 	inc_all_io_entry(pool, bio);
-	remap_and_issue(tc, bio, data_block);
+	remap_and_issue(tc, bio, data_begin);
 }
 
 /*
@@ -1003,7 +1126,6 @@ static void schedule_copy(struct thin_c *tc, dm_block_t virt_block,
 	struct dm_thin_new_mapping *m = get_next_mapping(pool);
 
 	m->tc = tc;
-	m->virt_block = virt_block;
 	m->data_block = data_dest;
 	m->cell = cell;
 
@@ -1082,7 +1204,8 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
 
 	atomic_set(&m->prepare_actions, 1); /* no need to quiesce */
 	m->tc = tc;
-	m->virt_block = virt_block;
+	m->virt_begin = virt_block;
+	m->virt_end = virt_block + 1u;
 	m->data_block = data_block;
 	m->cell = cell;
 
@@ -1291,99 +1414,134 @@ static void retry_bios_on_resume(struct pool *pool, struct dm_bio_prison_cell *c
 		retry_on_resume(bio);
 }
 
-static void process_discard_cell(struct thin_c *tc, struct dm_bio_prison_cell *cell)
+static void process_discard_cell_no_passdown(struct thin_c *tc,
+					     struct dm_bio_prison_cell *virt_cell)
 {
-	int r;
-	struct bio *bio = cell->holder;
 	struct pool *pool = tc->pool;
-	struct dm_bio_prison_cell *cell2;
-	struct dm_cell_key key2;
-	dm_block_t block = get_bio_block(tc, bio);
-	struct dm_thin_lookup_result lookup_result;
-	struct dm_thin_new_mapping *m;
+	struct dm_thin_new_mapping *m = get_next_mapping(pool);
 
-	if (tc->requeue_mode) {
-		cell_requeue(pool, cell);
-		return;
-	}
+	/*
+	 * We don't need to lock the data blocks, since there's no
+	 * passdown.  We only lock data blocks for allocation and breaking sharing.
+	 */
+	m->tc = tc;
+	m->virt_begin = virt_cell->key.block_begin;
+	m->virt_end = virt_cell->key.block_end;
+	m->cell = virt_cell;
+	m->bio = virt_cell->holder;
 
-	r = dm_thin_find_block(tc->td, block, 1, &lookup_result);
-	switch (r) {
-	case 0:
-		/*
-		 * Check nobody is fiddling with this pool block.  This can
-		 * happen if someone's in the process of breaking sharing
-		 * on this block.
-		 */
-		build_data_key(tc->td, lookup_result.block, &key2);
-		if (bio_detain(tc->pool, &key2, bio, &cell2)) {
-			cell_defer_no_holder(tc, cell);
-			break;
-		}
+	if (!dm_deferred_set_add_work(pool->all_io_ds, &m->list))
+		pool->process_prepared_discard(m);
+}
 
-		if (io_overlaps_block(pool, bio)) {
-			/*
-			 * IO may still be going to the destination block.  We must
-			 * quiesce before we can do the removal.
-			 */
-			m = get_next_mapping(pool);
-			m->tc = tc;
-			m->pass_discard = pool->pf.discard_passdown;
-			m->definitely_not_shared = !lookup_result.shared;
-			m->virt_block = block;
-			m->data_block = lookup_result.block;
-			m->cell = cell;
-			m->cell2 = cell2;
-			m->bio = bio;
-
-			if (!dm_deferred_set_add_work(pool->all_io_ds, &m->list))
-				pool->process_prepared_discard(m);
+static void break_up_discard_bio(struct thin_c *tc, dm_block_t begin, dm_block_t end,
+				 struct bio *bio)
+{
+	struct pool *pool = tc->pool;
 
-		} else {
-			inc_all_io_entry(pool, bio);
-			cell_defer_no_holder(tc, cell);
-			cell_defer_no_holder(tc, cell2);
+	int r;
+	bool maybe_shared;
+	struct dm_cell_key data_key;
+	struct dm_bio_prison_cell *data_cell;
+	struct dm_thin_new_mapping *m;
+	dm_block_t virt_begin, virt_end, data_begin;
 
+	while (begin != end) {
+		r = ensure_next_mapping(pool);
+		if (r)
+			/* we did our best */
+			return;
+
+		r = dm_thin_find_mapped_range(tc->td, begin, end, &virt_begin, &virt_end,
+					      &data_begin, &maybe_shared);
+		if (r)
 			/*
-			 * The DM core makes sure that the discard doesn't span
-			 * a block boundary.  So we submit the discard of a
-			 * partial block appropriately.
+			 * Silently fail, letting any mappings we've
+			 * created complete.
 			 */
-			if ((!lookup_result.shared) && pool->pf.discard_passdown)
-				remap_and_issue(tc, bio, lookup_result.block);
-			else
-				bio_endio(bio, 0);
+			break;
+
+		build_key(tc->td, PHYSICAL, data_begin, data_begin + (virt_end - virt_begin), &data_key);
+		if (bio_detain(tc->pool, &data_key, NULL, &data_cell)) {
+			/* contention, we'll give up with this range */
+			begin = virt_end;
+			continue;
 		}
-		break;
 
-	case -ENODATA:
 		/*
-		 * It isn't provisioned, just forget it.
+		 * IO may still be going to the destination block.  We must
+		 * quiesce before we can do the removal.
 		 */
-		cell_defer_no_holder(tc, cell);
-		bio_endio(bio, 0);
-		break;
+		m = get_next_mapping(pool);
+		m->tc = tc;
+		m->maybe_shared = maybe_shared;
+		m->virt_begin = virt_begin;
+		m->virt_end = virt_end;
+		m->data_block = data_begin;
+		m->cell = data_cell;
+		m->bio = bio;
 
-	default:
-		DMERR_LIMIT("%s: dm_thin_find_block() failed: error = %d",
-			    __func__, r);
-		cell_defer_no_holder(tc, cell);
-		bio_io_error(bio);
-		break;
+		/*
+		 * This per-mapping bi_remaining increment is paired with
+		 * the implicit decrement that occurs via bio_endio() in
+		 * process_prepared_discard_{passdown,no_passdown}.
+		 */
+		bio_inc_remaining(bio);
+		if (!dm_deferred_set_add_work(pool->all_io_ds, &m->list))
+			pool->process_prepared_discard(m);
+
+		begin = virt_end;
 	}
 }
 
+static void process_discard_cell_passdown(struct thin_c *tc, struct dm_bio_prison_cell *virt_cell)
+{
+	struct bio *bio = virt_cell->holder;
+	struct dm_thin_endio_hook *h = dm_per_bio_data(bio, sizeof(struct dm_thin_endio_hook));
+
+	/*
+	 * The virt_cell will only get freed once the origin bio completes.
+	 * This means it will remain locked while all the individual
+	 * passdown bios are in flight.
+	 */
+	h->cell = virt_cell;
+	break_up_discard_bio(tc, virt_cell->key.block_begin, virt_cell->key.block_end, bio);
+
+	/*
+	 * We complete the bio now, knowing that the bi_remaining field
+	 * will prevent completion until the sub range discards have
+	 * completed.
+	 */
+	bio_endio(bio, 0);
+}
+
 static void process_discard_bio(struct thin_c *tc, struct bio *bio)
 {
-	struct dm_bio_prison_cell *cell;
-	struct dm_cell_key key;
-	dm_block_t block = get_bio_block(tc, bio);
+	dm_block_t begin, end;
+	struct dm_cell_key virt_key;
+	struct dm_bio_prison_cell *virt_cell;
 
-	build_virtual_key(tc->td, block, &key);
-	if (bio_detain(tc->pool, &key, bio, &cell))
+	get_bio_block_range(tc, bio, &begin, &end);
+	if (begin == end) {
+		/*
+		 * The discard covers less than a block.
+		 */
+		bio_endio(bio, 0);
+		return;
+	}
+
+	build_key(tc->td, VIRTUAL, begin, end, &virt_key);
+	if (bio_detain(tc->pool, &virt_key, bio, &virt_cell))
+		/*
+		 * Potential starvation issue: We're relying on the
+		 * fs/application being well behaved, and not trying to
+		 * send IO to a region at the same time as discarding it.
+		 * If they do this persistently then it's possible this
+		 * cell will never be granted.
+		 */
 		return;
 
-	process_discard_cell(tc, cell);
+	tc->pool->process_discard_cell(tc, virt_cell);
 }
 
 static void break_sharing(struct thin_c *tc, struct bio *bio, dm_block_t block,
@@ -2099,6 +2257,24 @@ static void notify_of_pool_mode_change(struct pool *pool, const char *new_mode)
 	       dm_device_name(pool->pool_md), new_mode);
 }
 
+static bool passdown_enabled(struct pool_c *pt)
+{
+	return pt->adjusted_pf.discard_passdown;
+}
+
+static void set_discard_callbacks(struct pool *pool)
+{
+	struct pool_c *pt = pool->ti->private;
+
+	if (passdown_enabled(pt)) {
+		pool->process_discard_cell = process_discard_cell_passdown;
+		pool->process_prepared_discard = process_prepared_discard_passdown;
+	} else {
+		pool->process_discard_cell = process_discard_cell_no_passdown;
+		pool->process_prepared_discard = process_prepared_discard_no_passdown;
+	}
+}
+
 static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
 {
 	struct pool_c *pt = pool->ti->private;
@@ -2150,7 +2326,7 @@ static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
 		pool->process_cell = process_cell_read_only;
 		pool->process_discard_cell = process_cell_success;
 		pool->process_prepared_mapping = process_prepared_mapping_fail;
-		pool->process_prepared_discard = process_prepared_discard_passdown;
+		pool->process_prepared_discard = process_prepared_discard_success;
 
 		error_retry_list(pool);
 		break;
@@ -2169,9 +2345,8 @@ static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
 		pool->process_bio = process_bio_read_only;
 		pool->process_discard = process_discard_bio;
 		pool->process_cell = process_cell_read_only;
-		pool->process_discard_cell = process_discard_cell;
 		pool->process_prepared_mapping = process_prepared_mapping;
-		pool->process_prepared_discard = process_prepared_discard;
+		set_discard_callbacks(pool);
 
 		if (!pool->pf.error_if_no_space && no_space_timeout)
 			queue_delayed_work(pool->wq, &pool->no_space_timeout, no_space_timeout);
@@ -2184,9 +2359,8 @@ static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
 		pool->process_bio = process_bio;
 		pool->process_discard = process_discard_bio;
 		pool->process_cell = process_cell;
-		pool->process_discard_cell = process_discard_cell;
 		pool->process_prepared_mapping = process_prepared_mapping;
-		pool->process_prepared_discard = process_prepared_discard;
+		set_discard_callbacks(pool);
 		break;
 	}
 
@@ -2275,6 +2449,7 @@ static void thin_hook_bio(struct thin_c *tc, struct bio *bio)
 	h->shared_read_entry = NULL;
 	h->all_io_entry = NULL;
 	h->overwrite_mapping = NULL;
+	h->cell = NULL;
 }
 
 /*
@@ -2422,7 +2597,6 @@ static void disable_passdown_if_not_supported(struct pool_c *pt)
 	struct pool *pool = pt->pool;
 	struct block_device *data_bdev = pt->data_dev->bdev;
 	struct queue_limits *data_limits = &bdev_get_queue(data_bdev)->limits;
-	sector_t block_size = pool->sectors_per_block << SECTOR_SHIFT;
 	const char *reason = NULL;
 	char buf[BDEVNAME_SIZE];
 
@@ -2435,12 +2609,6 @@ static void disable_passdown_if_not_supported(struct pool_c *pt)
 	else if (data_limits->max_discard_sectors < pool->sectors_per_block)
 		reason = "max discard sectors smaller than a block";
 
-	else if (data_limits->discard_granularity > block_size)
-		reason = "discard granularity larger than a block";
-
-	else if (!is_factor(block_size, data_limits->discard_granularity))
-		reason = "discard granularity not a factor of block size";
-
 	if (reason) {
 		DMWARN("Data device (%s) %s: Disabling discard passdown.", bdevname(data_bdev, buf), reason);
 		pt->adjusted_pf.discard_passdown = false;
@@ -3573,24 +3741,6 @@ static int pool_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
 	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
 }
 
-static void set_discard_limits(struct pool_c *pt, struct queue_limits *limits)
-{
-	struct pool *pool = pt->pool;
-	struct queue_limits *data_limits;
-
-	limits->max_discard_sectors = pool->sectors_per_block;
-
-	/*
-	 * discard_granularity is just a hint, and not enforced.
-	 */
-	if (pt->adjusted_pf.discard_passdown) {
-		data_limits = &bdev_get_queue(pt->data_dev->bdev)->limits;
-		limits->discard_granularity = max(data_limits->discard_granularity,
-						  pool->sectors_per_block << SECTOR_SHIFT);
-	} else
-		limits->discard_granularity = pool->sectors_per_block << SECTOR_SHIFT;
-}
-
 static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
 {
 	struct pool_c *pt = ti->private;
@@ -3645,14 +3795,17 @@ static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 	disable_passdown_if_not_supported(pt);
 
-	set_discard_limits(pt, limits);
+	/*
+	 * The pool uses the same discard limits as the underlying data
+	 * device.  DM core has already set this up.
+	 */
 }
 
 static struct target_type pool_target = {
 	.name = "thin-pool",
 	.features = DM_TARGET_SINGLETON | DM_TARGET_ALWAYS_WRITEABLE |
 		    DM_TARGET_IMMUTABLE,
-	.version = {1, 14, 0},
+	.version = {1, 15, 0},
 	.module = THIS_MODULE,
 	.ctr = pool_ctr,
 	.dtr = pool_dtr,
@@ -3811,8 +3964,7 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	if (tc->pool->pf.discard_enabled) {
 		ti->discards_supported = true;
 		ti->num_discard_bios = 1;
-		/* Discard bios must be split on a block boundary */
-		ti->split_discard_bios = true;
+		ti->split_discard_bios = false;
 	}
 
 	mutex_unlock(&dm_thin_pool_table.mutex);
@@ -3899,6 +4051,9 @@ static int thin_endio(struct dm_target *ti, struct bio *bio, int err)
 		}
 	}
 
+	if (h->cell)
+		cell_defer_no_holder(h->tc, h->cell);
+
 	return 0;
 }
 
@@ -4026,9 +4181,18 @@ static int thin_iterate_devices(struct dm_target *ti,
 	return 0;
 }
 
+static void thin_io_hints(struct dm_target *ti, struct queue_limits *limits)
+{
+	struct thin_c *tc = ti->private;
+	struct pool *pool = tc->pool;
+
+	limits->discard_granularity = pool->sectors_per_block << SECTOR_SHIFT;
+	limits->max_discard_sectors = 2048 * 1024 * 16; /* 16G */
+}
+
 static struct target_type thin_target = {
 	.name = "thin",
-	.version = {1, 14, 0},
+	.version = {1, 15, 0},
 	.module	= THIS_MODULE,
 	.ctr = thin_ctr,
 	.dtr = thin_dtr,
@@ -4040,6 +4204,7 @@ static struct target_type thin_target = {
 	.status = thin_status,
 	.merge = thin_merge,
 	.iterate_devices = thin_iterate_devices,
+	.io_hints = thin_io_hints,
 };
 
 /*----------------------------------------------------------------*/
-- 
2.3.2 (Apple Git-55)
