From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-3.19 PATCH v2 14/17] dm thin: defer whole cells
	rather than individual bios
Date: Fri, 17 Oct 2014 14:37:16 -0400
Message-ID: <1413571039-31986-14-git-send-email-snitzer@redhat.com>
References: <1413571039-31986-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1413571039-31986-1-git-send-email-snitzer@redhat.com>
In-Reply-To: <20141017183119.GA31854@redhat.com>
References: <20141017183119.GA31854@redhat.com>
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
Cc: ejt@redhat.com
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

This avoids dropping the cell, so increases the probability that other
bios will collect within the cell, rather than being passed individually
to the worker.

Also add required process_cell and process_discard_cell error handling
wrappers and set associated pool-mode function pointers accordingly.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-bio-prison.h |   1 +
 drivers/md/dm-thin.c       | 235 +++++++++++++++++++++++++++++++++++----------
 2 files changed, 185 insertions(+), 51 deletions(-)

diff --git a/drivers/md/dm-bio-prison.h b/drivers/md/dm-bio-prison.h
index 997a439..c0cddb1 100644
--- a/drivers/md/dm-bio-prison.h
+++ b/drivers/md/dm-bio-prison.h
@@ -35,6 +35,7 @@ struct dm_cell_key {
  * themselves.
  */
 struct dm_bio_prison_cell {
+	struct list_head user_list;	/* for client use */
 	struct rb_node node;
 
 	struct dm_cell_key key;
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 4658635..a7b188f 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -202,6 +202,7 @@ struct pool_features {
 
 struct thin_c;
 typedef void (*process_bio_fn)(struct thin_c *tc, struct bio *bio);
+typedef void (*process_cell_fn)(struct thin_c *tc, struct dm_bio_prison_cell *cell);
 typedef void (*process_mapping_fn)(struct dm_thin_new_mapping *m);
 
 struct pool {
@@ -246,6 +247,9 @@ struct pool {
 	process_bio_fn process_bio;
 	process_bio_fn process_discard;
 
+	process_cell_fn process_cell;
+	process_cell_fn process_discard_cell;
+
 	process_mapping_fn process_prepared_mapping;
 	process_mapping_fn process_prepared_discard;
 };
@@ -282,6 +286,7 @@ struct thin_c {
 	struct dm_thin_device *td;
 	bool requeue_mode:1;
 	spinlock_t lock;
+	struct list_head deferred_cells;
 	struct bio_list deferred_bio_list;
 	struct bio_list retry_on_resume_list;
 	struct rb_root sort_bio_list; /* sorted list of deferred bios */
@@ -346,19 +351,6 @@ static void cell_release_no_holder(struct pool *pool,
 	dm_bio_prison_free_cell(pool->prison, cell);
 }
 
-static void cell_defer_no_holder_no_free(struct thin_c *tc,
-					 struct dm_bio_prison_cell *cell)
-{
-	struct pool *pool = tc->pool;
-	unsigned long flags;
-
-	spin_lock_irqsave(&tc->lock, flags);
-	dm_cell_release_no_holder(pool->prison, cell, &tc->deferred_bio_list);
-	spin_unlock_irqrestore(&tc->lock, flags);
-
-	wake_worker(pool);
-}
-
 static void cell_error_with_code(struct pool *pool,
 				 struct dm_bio_prison_cell *cell, int error_code)
 {
@@ -371,6 +363,11 @@ static void cell_error(struct pool *pool, struct dm_bio_prison_cell *cell)
 	cell_error_with_code(pool, cell, -EIO);
 }
 
+static void cell_success(struct pool *pool, struct dm_bio_prison_cell *cell)
+{
+	cell_error_with_code(pool, cell, 0);
+}
+
 /*----------------------------------------------------------------*/
 
 /*
@@ -706,6 +703,28 @@ static void cell_defer_no_holder(struct thin_c *tc, struct dm_bio_prison_cell *c
 	wake_worker(pool);
 }
 
+static void thin_defer_bio(struct thin_c *tc, struct bio *bio);
+
+static void inc_remap_and_issue_cell(struct thin_c *tc,
+				     struct dm_bio_prison_cell *cell,
+				     dm_block_t block)
+{
+	struct bio *bio;
+	struct bio_list bios;
+
+	bio_list_init(&bios);
+	cell_release_no_holder(tc->pool, cell, &bios);
+
+	while ((bio = bio_list_pop(&bios))) {
+		if (bio->bi_rw & (REQ_DISCARD | REQ_FLUSH | REQ_FUA))
+			thin_defer_bio(tc, bio);
+		else {
+			inc_all_io_entry(tc->pool, bio);
+			remap_and_issue(tc, bio, block);
+		}
+	}
+}
+
 static void process_prepared_mapping_fail(struct dm_thin_new_mapping *m)
 {
 	if (m->bio) {
@@ -1193,20 +1212,17 @@ static void retry_bios_on_resume(struct pool *pool, struct dm_bio_prison_cell *c
 			retry_on_resume(bio);
 }
 
-static void process_discard(struct thin_c *tc, struct bio *bio)
+static void process_discard_cell(struct thin_c *tc, struct dm_bio_prison_cell *cell)
 {
 	int r;
+	struct bio *bio = cell->holder;
 	struct pool *pool = tc->pool;
-	struct dm_bio_prison_cell *cell, *cell2;
-	struct dm_cell_key key, key2;
+	struct dm_bio_prison_cell *cell2;
+	struct dm_cell_key key2;
 	dm_block_t block = get_bio_block(tc, bio);
 	struct dm_thin_lookup_result lookup_result;
 	struct dm_thin_new_mapping *m;
 
-	build_virtual_key(tc->td, block, &key);
-	if (bio_detain(tc->pool, &key, bio, &cell))
-		return;
-
 	r = dm_thin_find_block(tc->td, block, 1, &lookup_result);
 	switch (r) {
 	case 0:
@@ -1273,6 +1289,19 @@ static void process_discard(struct thin_c *tc, struct bio *bio)
 	}
 }
 
+static void process_discard_bio(struct thin_c *tc, struct bio *bio)
+{
+	struct dm_bio_prison_cell *cell;
+	struct dm_cell_key key;
+	dm_block_t block = get_bio_block(tc, bio);
+
+	build_virtual_key(tc->td, block, &key);
+	if (bio_detain(tc->pool, &key, bio, &cell))
+		return;
+
+	process_discard_cell(tc, cell);
+}
+
 static void break_sharing(struct thin_c *tc, struct bio *bio, dm_block_t block,
 			  struct dm_cell_key *key,
 			  struct dm_thin_lookup_result *lookup_result,
@@ -1379,34 +1408,25 @@ static void provision_block(struct thin_c *tc, struct bio *bio, dm_block_t block
 	}
 }
 
-static void process_bio(struct thin_c *tc, struct bio *bio)
+static void process_cell(struct thin_c *tc, struct dm_bio_prison_cell *cell)
 {
 	int r;
 	struct pool *pool = tc->pool;
+	struct bio *bio = cell->holder;
 	dm_block_t block = get_bio_block(tc, bio);
-	struct dm_bio_prison_cell *cell;
-	struct dm_cell_key key;
 	struct dm_thin_lookup_result lookup_result;
 
-	/*
-	 * If cell is already occupied, then the block is already
-	 * being provisioned so we have nothing further to do here.
-	 */
-	build_virtual_key(tc->td, block, &key);
-	if (bio_detain(pool, &key, bio, &cell))
-		return;
-
 	r = dm_thin_find_block(tc->td, block, 1, &lookup_result);
 	switch (r) {
 	case 0:
 		if (lookup_result.shared) {
 			process_shared_bio(tc, bio, block, &lookup_result);
+			// FIXME: we can't remap because we're waiting on a commit
 			cell_defer_no_holder(tc, cell); /* FIXME: pass this cell into process_shared? */
 		} else {
 			inc_all_io_entry(pool, bio);
-			cell_defer_no_holder(tc, cell);
-
 			remap_and_issue(tc, bio, lookup_result.block);
+			inc_remap_and_issue_cell(tc, cell, lookup_result.block);
 		}
 		break;
 
@@ -1440,7 +1460,26 @@ static void process_bio(struct thin_c *tc, struct bio *bio)
 	}
 }
 
-static void process_bio_read_only(struct thin_c *tc, struct bio *bio)
+static void process_bio(struct thin_c *tc, struct bio *bio)
+{
+	struct pool *pool = tc->pool;
+	dm_block_t block = get_bio_block(tc, bio);
+	struct dm_bio_prison_cell *cell;
+	struct dm_cell_key key;
+
+	/*
+	 * If cell is already occupied, then the block is already
+	 * being provisioned so we have nothing further to do here.
+	 */
+	build_virtual_key(tc->td, block, &key);
+	if (bio_detain(pool, &key, bio, &cell))
+		return;
+
+	process_cell(tc, cell);
+}
+
+static void __process_bio_read_only(struct thin_c *tc, struct bio *bio,
+				    struct dm_bio_prison_cell *cell)
 {
 	int r;
 	int rw = bio_data_dir(bio);
@@ -1450,15 +1489,21 @@ static void process_bio_read_only(struct thin_c *tc, struct bio *bio)
 	r = dm_thin_find_block(tc->td, block, 1, &lookup_result);
 	switch (r) {
 	case 0:
-		if (lookup_result.shared && (rw == WRITE) && bio->bi_iter.bi_size)
+		if (lookup_result.shared && (rw == WRITE) && bio->bi_iter.bi_size) {
 			handle_unserviceable_bio(tc->pool, bio);
-		else {
+			if (cell)
+				cell_defer_no_holder(tc, cell);
+		} else {
 			inc_all_io_entry(tc->pool, bio);
 			remap_and_issue(tc, bio, lookup_result.block);
+			if (cell)
+				inc_remap_and_issue_cell(tc, cell, lookup_result.block);
 		}
 		break;
 
 	case -ENODATA:
+		if (cell)
+			cell_defer_no_holder(tc, cell);
 		if (rw != READ) {
 			handle_unserviceable_bio(tc->pool, bio);
 			break;
@@ -1477,11 +1522,23 @@ static void process_bio_read_only(struct thin_c *tc, struct bio *bio)
 	default:
 		DMERR_LIMIT("%s: dm_thin_find_block() failed: error = %d",
 			    __func__, r);
+		if (cell)
+			cell_defer_no_holder(tc, cell);
 		bio_io_error(bio);
 		break;
 	}
 }
 
+static void process_bio_read_only(struct thin_c *tc, struct bio *bio)
+{
+	__process_bio_read_only(tc, bio, NULL);
+}
+
+static void process_cell_read_only(struct thin_c *tc, struct dm_bio_prison_cell *cell)
+{
+	__process_bio_read_only(tc, cell->holder, cell);
+}
+
 static void process_bio_success(struct thin_c *tc, struct bio *bio)
 {
 	bio_endio(bio, 0);
@@ -1492,6 +1549,16 @@ static void process_bio_fail(struct thin_c *tc, struct bio *bio)
 	bio_io_error(bio);
 }
 
+static void process_cell_success(struct thin_c *tc, struct dm_bio_prison_cell *cell)
+{
+	cell_success(tc->pool, cell);
+}
+
+static void process_cell_fail(struct thin_c *tc, struct dm_bio_prison_cell *cell)
+{
+	cell_error(tc->pool, cell);
+}
+
 /*
  * FIXME: should we also commit due to size of transaction, measured in
  * metadata blocks?
@@ -1624,6 +1691,51 @@ static void process_thin_deferred_bios(struct thin_c *tc)
 	blk_finish_plug(&plug);
 }
 
+static void process_thin_deferred_cells(struct thin_c *tc)
+{
+	struct pool *pool = tc->pool;
+	unsigned long flags;
+	struct list_head cells;
+	struct dm_bio_prison_cell *cell, *tmp;
+
+	// FIXME: push down into per cell processing
+	if (tc->requeue_mode) {
+		requeue_bio_list(tc, &tc->deferred_bio_list);
+		return;
+	}
+
+	INIT_LIST_HEAD(&cells);
+
+	spin_lock_irqsave(&tc->lock, flags);
+	list_splice_init(&tc->deferred_cells, &cells);
+	spin_unlock_irqrestore(&tc->lock, flags);
+
+	if (list_empty(&cells))
+		return;
+
+	list_for_each_entry_safe(cell, tmp, &cells, user_list) {
+		BUG_ON(!cell->holder);
+
+		/*
+		 * If we've got no free new_mapping structs, and processing
+		 * this bio might require one, we pause until there are some
+		 * prepared mappings to process.
+		 */
+		if (ensure_next_mapping(pool)) {
+			spin_lock_irqsave(&tc->lock, flags);
+			list_add(&cell->user_list, &tc->deferred_cells);
+			list_splice(&cells, &tc->deferred_cells);
+			spin_unlock_irqrestore(&tc->lock, flags);
+			break;
+		}
+
+		if (cell->holder->bi_rw & REQ_DISCARD)
+			pool->process_discard_cell(tc, cell);
+		else
+			pool->process_cell(tc, cell);
+	}
+}
+
 static void thin_get(struct thin_c *tc);
 static void thin_put(struct thin_c *tc);
 
@@ -1672,6 +1784,7 @@ static void process_deferred_bios(struct pool *pool)
 
 	tc = get_first_thin(pool);
 	while (tc) {
+		process_thin_deferred_cells(tc);
 		process_thin_deferred_bios(tc);
 		tc = get_next_thin(pool, tc);
 	}
@@ -1850,6 +1963,8 @@ static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
 		dm_pool_metadata_read_only(pool->pmd);
 		pool->process_bio = process_bio_fail;
 		pool->process_discard = process_bio_fail;
+		pool->process_cell = process_cell_fail;
+		pool->process_discard_cell = process_cell_fail;
 		pool->process_prepared_mapping = process_prepared_mapping_fail;
 		pool->process_prepared_discard = process_prepared_discard_fail;
 
@@ -1862,6 +1977,8 @@ static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
 		dm_pool_metadata_read_only(pool->pmd);
 		pool->process_bio = process_bio_read_only;
 		pool->process_discard = process_bio_success;
+		pool->process_cell = process_cell_read_only;
+		pool->process_discard_cell = process_cell_success;
 		pool->process_prepared_mapping = process_prepared_mapping_fail;
 		pool->process_prepared_discard = process_prepared_discard_passdown;
 
@@ -1880,7 +1997,9 @@ static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
 		if (old_mode != new_mode)
 			notify_of_pool_mode_change(pool, "out-of-data-space");
 		pool->process_bio = process_bio_read_only;
-		pool->process_discard = process_discard;
+		pool->process_discard = process_discard_bio;
+		pool->process_cell = process_cell_read_only;
+		pool->process_discard_cell = process_discard_cell;
 		pool->process_prepared_mapping = process_prepared_mapping;
 		pool->process_prepared_discard = process_prepared_discard_passdown;
 
@@ -1893,7 +2012,9 @@ static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
 			notify_of_pool_mode_change(pool, "write");
 		dm_pool_metadata_read_write(pool->pmd);
 		pool->process_bio = process_bio;
-		pool->process_discard = process_discard;
+		pool->process_discard = process_discard_bio;
+		pool->process_cell = process_cell;
+		pool->process_discard_cell = process_discard_cell;
 		pool->process_prepared_mapping = process_prepared_mapping;
 		pool->process_prepared_discard = process_prepared_discard;
 		break;
@@ -1962,6 +2083,20 @@ static void thin_defer_bio_with_throttle(struct thin_c *tc, struct bio *bio)
 	throttle_unlock(&pool->throttle);
 }
 
+static void thin_defer_cell(struct thin_c *tc, struct dm_bio_prison_cell *cell)
+{
+	unsigned long flags;
+	struct pool *pool = tc->pool;
+
+	throttle_lock(&pool->throttle);
+	spin_lock_irqsave(&tc->lock, flags);
+	list_add_tail(&cell->user_list, &tc->deferred_cells);
+	spin_unlock_irqrestore(&tc->lock, flags);
+	throttle_unlock(&pool->throttle);
+
+	wake_worker(pool);
+}
+
 static void thin_hook_bio(struct thin_c *tc, struct bio *bio)
 {
 	struct dm_thin_endio_hook *h = dm_per_bio_data(bio, sizeof(struct dm_thin_endio_hook));
@@ -1982,8 +2117,7 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 	dm_block_t block = get_bio_block(tc, bio);
 	struct dm_thin_device *td = tc->td;
 	struct dm_thin_lookup_result result;
-	struct dm_bio_prison_cell cell1, cell2;
-	struct dm_bio_prison_cell *cell_result;
+	struct dm_bio_prison_cell *virt_cell, *data_cell;
 	struct dm_cell_key key;
 
 	thin_hook_bio(tc, bio);
@@ -2008,7 +2142,7 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 	 * there's a race with discard.
 	 */
 	build_virtual_key(tc->td, block, &key);
-	if (dm_bio_detain(tc->pool->prison, &key, bio, &cell1, &cell_result))
+	if (bio_detain(tc->pool, &key, bio, &virt_cell))
 		return DM_MAPIO_SUBMITTED;
 
 	r = dm_thin_find_block(td, block, 0, &result);
@@ -2033,20 +2167,19 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 			 * More distant ancestors are irrelevant. The
 			 * shared flag will be set in their case.
 			 */
-			thin_defer_bio(tc, bio);
-			cell_defer_no_holder_no_free(tc, &cell1);
+			thin_defer_cell(tc, virt_cell);
 			return DM_MAPIO_SUBMITTED;
 		}
 
 		build_data_key(tc->td, result.block, &key);
-		if (dm_bio_detain(tc->pool->prison, &key, bio, &cell2, &cell_result)) {
-			cell_defer_no_holder_no_free(tc, &cell1);
+		if (bio_detain(tc->pool, &key, bio, &data_cell)) {
+			cell_defer_no_holder(tc, virt_cell);
 			return DM_MAPIO_SUBMITTED;
 		}
 
 		inc_all_io_entry(tc->pool, bio);
-		cell_defer_no_holder_no_free(tc, &cell2);
-		cell_defer_no_holder_no_free(tc, &cell1);
+		cell_defer_no_holder(tc, data_cell);
+		cell_defer_no_holder(tc, virt_cell);
 
 		remap(tc, bio, result.block);
 		return DM_MAPIO_REMAPPED;
@@ -2058,14 +2191,13 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 			 * of doing so.
 			 */
 			handle_unserviceable_bio(tc->pool, bio);
-			cell_defer_no_holder_no_free(tc, &cell1);
+			cell_defer_no_holder(tc, virt_cell);
 			return DM_MAPIO_SUBMITTED;
 		}
 		/* fall through */
 
 	case -EWOULDBLOCK:
-		thin_defer_bio(tc, bio);
-		cell_defer_no_holder_no_free(tc, &cell1);
+		thin_defer_cell(tc, virt_cell);
 		return DM_MAPIO_SUBMITTED;
 
 	default:
@@ -2075,7 +2207,7 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 		 * pool is switched to fail-io mode.
 		 */
 		bio_io_error(bio);
-		cell_defer_no_holder_no_free(tc, &cell1);
+		cell_defer_no_holder(tc, virt_cell);
 		return DM_MAPIO_SUBMITTED;
 	}
 }
@@ -3388,6 +3520,7 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto out_unlock;
 	}
 	spin_lock_init(&tc->lock);
+	INIT_LIST_HEAD(&tc->deferred_cells);
 	bio_list_init(&tc->deferred_bio_list);
 	bio_list_init(&tc->retry_on_resume_list);
 	tc->sort_bio_list = RB_ROOT;
-- 
1.8.3.1
