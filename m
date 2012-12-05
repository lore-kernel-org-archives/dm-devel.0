From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/3] dm thin: fix deadlock when io and discards
	are simultaneously sent to the same block
Date: Wed,  5 Dec 2012 16:26:19 -0500
Message-ID: <1354742781-21423-1-git-send-email-snitzer@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

The all_io_entry for a bio must be incremented whilst the
dm_bio_prison_cell is held for both the virtual and physical blocks.
That cell locking wasn't occuring.  This patch fixes this.

Also, now that the map function may add bios to a cell, process_bio() is
no longer the only thread that will do so.  As such, we must replace
dm_cell_release_singleton calls with cell_defer_no_holder (renamed from
cell_defer_except).  In every case cell_defer_no_holder is called the
bio in question is the cell holder.  If there are no non-holder bio
entries then cell_defer_no_holder behaves identically to
dm_cell_release_singleton.  If there *are* non-holder entries then
dm_cell_release_singleton was the wrong thing to call because those
entries must be deferred.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/md/dm-thin.c |   97 ++++++++++++++++++++++++++++++-------------------
 1 files changed, 59 insertions(+), 38 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 058acf3..1cb6d34 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -368,11 +368,24 @@ static int bio_triggers_commit(struct thin_c *tc, struct bio *bio)
 		dm_thin_changed_this_transaction(tc->td);
 }
 
+static void inc_all_io_entry(struct pool *pool, struct bio *bio)
+{
+	struct dm_thin_endio_hook *h;
+
+	if (bio->bi_rw & REQ_DISCARD)
+		return;
+
+	h = dm_get_mapinfo(bio)->ptr;
+	h->all_io_entry = dm_deferred_entry_inc(pool->all_io_ds);
+}
+
 static void issue(struct thin_c *tc, struct bio *bio)
 {
 	struct pool *pool = tc->pool;
 	unsigned long flags;
 
+	inc_all_io_entry(pool, bio);
+
 	if (!bio_triggers_commit(tc, bio)) {
 		generic_make_request(bio);
 		return;
@@ -513,17 +526,14 @@ static void cell_defer(struct thin_c *tc, struct dm_bio_prison_cell *cell,
 }
 
 /*
- * Same as cell_defer above, except it omits one particular detainee,
- * a write bio that covers the block and has already been processed.
+ * Same as cell_defer except it omits the original holder of the cell.
  */
-static void cell_defer_except(struct thin_c *tc, struct dm_bio_prison_cell *cell)
+static void cell_defer_no_holder(struct thin_c *tc,
+				 struct dm_bio_prison_cell *cell)
 {
-	struct bio_list bios;
 	struct pool *pool = tc->pool;
 	unsigned long flags;
 
-	bio_list_init(&bios);
-
 	spin_lock_irqsave(&pool->lock, flags);
 	dm_cell_release_no_holder(cell, &pool->deferred_bios);
 	spin_unlock_irqrestore(&pool->lock, flags);
@@ -573,7 +583,7 @@ static void process_prepared_mapping(struct dm_thin_new_mapping *m)
 	 * the bios in the cell.
 	 */
 	if (bio) {
-		cell_defer_except(tc, m->cell);
+		cell_defer_no_holder(tc, m->cell);
 		bio_endio(bio, 0);
 	} else
 		cell_defer(tc, m->cell, m->data_block);
@@ -588,8 +598,8 @@ static void process_prepared_discard_fail(struct dm_thin_new_mapping *m)
 	struct thin_c *tc = m->tc;
 
 	bio_io_error(m->bio);
-	cell_defer_except(tc, m->cell);
-	cell_defer_except(tc, m->cell2);
+	cell_defer_no_holder(tc, m->cell);
+	cell_defer_no_holder(tc, m->cell2);
 	mempool_free(m, tc->pool->mapping_pool);
 }
 
@@ -602,8 +612,8 @@ static void process_prepared_discard_passdown(struct dm_thin_new_mapping *m)
 	else
 		bio_endio(m->bio, 0);
 
-	cell_defer_except(tc, m->cell);
-	cell_defer_except(tc, m->cell2);
+	cell_defer_no_holder(tc, m->cell);
+	cell_defer_no_holder(tc, m->cell2);
 	mempool_free(m, tc->pool->mapping_pool);
 }
 
@@ -936,7 +946,7 @@ static void process_discard(struct thin_c *tc, struct bio *bio)
 		 */
 		build_data_key(tc->td, lookup_result.block, &key2);
 		if (dm_bio_detain(tc->pool->prison, &key2, bio, &cell2)) {
-			dm_cell_release_singleton(cell, bio);
+			cell_defer_no_holder(tc, cell);
 			break;
 		}
 
@@ -967,12 +977,13 @@ static void process_discard(struct thin_c *tc, struct bio *bio)
 			 * a block boundary.  So we submit the discard of a
 			 * partial block appropriately.
 			 */
-			dm_cell_release_singleton(cell, bio);
-			dm_cell_release_singleton(cell2, bio);
 			if ((!lookup_result.shared) && pool->pf.discard_passdown)
 				remap_and_issue(tc, bio, lookup_result.block);
 			else
 				bio_endio(bio, 0);
+
+			cell_defer_no_holder(tc, cell);
+			cell_defer_no_holder(tc, cell2);
 		}
 		break;
 
@@ -980,13 +991,13 @@ static void process_discard(struct thin_c *tc, struct bio *bio)
 		/*
 		 * It isn't provisioned, just forget it.
 		 */
-		dm_cell_release_singleton(cell, bio);
+		cell_defer_no_holder(tc, cell);
 		bio_endio(bio, 0);
 		break;
 
 	default:
 		DMERR("discard: find block unexpectedly returned %d", r);
-		dm_cell_release_singleton(cell, bio);
+		cell_defer_no_holder(tc, cell);
 		bio_io_error(bio);
 		break;
 	}
@@ -1041,8 +1052,8 @@ static void process_shared_bio(struct thin_c *tc, struct bio *bio,
 
 		h->shared_read_entry = dm_deferred_entry_inc(pool->shared_read_ds);
 
-		dm_cell_release_singleton(cell, bio);
 		remap_and_issue(tc, bio, lookup_result->block);
+		cell_defer_no_holder(tc, cell);
 	}
 }
 
@@ -1056,8 +1067,8 @@ static void provision_block(struct thin_c *tc, struct bio *bio, dm_block_t block
 	 * Remap empty bios (flushes) immediately, without provisioning.
 	 */
 	if (!bio->bi_size) {
-		dm_cell_release_singleton(cell, bio);
 		remap_and_issue(tc, bio, 0);
+		cell_defer_no_holder(tc, cell);
 		return;
 	}
 
@@ -1066,7 +1077,7 @@ static void provision_block(struct thin_c *tc, struct bio *bio, dm_block_t block
 	 */
 	if (bio_data_dir(bio) == READ) {
 		zero_fill_bio(bio);
-		dm_cell_release_singleton(cell, bio);
+		cell_defer_no_holder(tc, cell);
 		bio_endio(bio, 0);
 		return;
 	}
@@ -1111,34 +1122,29 @@ static void process_bio(struct thin_c *tc, struct bio *bio)
 	r = dm_thin_find_block(tc->td, block, 1, &lookup_result);
 	switch (r) {
 	case 0:
-		/*
-		 * We can release this cell now.  This thread is the only
-		 * one that puts bios into a cell, and we know there were
-		 * no preceding bios.
-		 */
-		/*
-		 * TODO: this will probably have to change when discard goes
-		 * back in.
-		 */
-		dm_cell_release_singleton(cell, bio);
-
 		if (lookup_result.shared)
 			process_shared_bio(tc, bio, block, &lookup_result);
 		else
 			remap_and_issue(tc, bio, lookup_result.block);
+
+		/*
+		 * We can release this cell now.  But there may be other
+		 * other bios in the cell from the thin_map function.
+		 */
+		cell_defer_no_holder(tc, cell);
 		break;
 
 	case -ENODATA:
 		if (bio_data_dir(bio) == READ && tc->origin_dev) {
-			dm_cell_release_singleton(cell, bio);
 			remap_to_origin_and_issue(tc, bio);
+			cell_defer_no_holder(tc, cell);
 		} else
 			provision_block(tc, bio, block, cell);
 		break;
 
 	default:
 		DMERR("dm_thin_find_block() failed, error = %d", r);
-		dm_cell_release_singleton(cell, bio);
+		cell_defer_no_holder(tc, cell);
 		bio_io_error(bio);
 		break;
 	}
@@ -1347,7 +1353,7 @@ static struct dm_thin_endio_hook *thin_hook_bio(struct thin_c *tc, struct bio *b
 
 	h->tc = tc;
 	h->shared_read_entry = NULL;
-	h->all_io_entry = bio->bi_rw & REQ_DISCARD ? NULL : dm_deferred_entry_inc(pool->all_io_ds);
+	h->all_io_entry = NULL;
 	h->overwrite_mapping = NULL;
 
 	return h;
@@ -1364,6 +1370,8 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio,
 	dm_block_t block = get_bio_block(tc, bio);
 	struct dm_thin_device *td = tc->td;
 	struct dm_thin_lookup_result result;
+	struct dm_bio_prison_cell *cell1, *cell2;
+	struct dm_cell_key key;
 
 	map_context->ptr = thin_hook_bio(tc, bio);
 
@@ -1400,12 +1408,25 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio,
 			 * shared flag will be set in their case.
 			 */
 			thin_defer_bio(tc, bio);
-			r = DM_MAPIO_SUBMITTED;
-		} else {
-			remap(tc, bio, result.block);
-			r = DM_MAPIO_REMAPPED;
+			return DM_MAPIO_SUBMITTED;
 		}
-		break;
+
+		build_virtual_key(tc->td, block, &key);
+		if (dm_bio_detain(tc->pool->prison, &key, bio, &cell1))
+			return DM_MAPIO_SUBMITTED;
+
+		build_data_key(tc->td, result.block, &key);
+		if (dm_bio_detain(tc->pool->prison, &key, bio, &cell2)) {
+			cell_defer_no_holder(tc, cell1);
+			return DM_MAPIO_SUBMITTED;
+		}
+
+		inc_all_io_entry(tc->pool, bio);
+		cell_defer_no_holder(tc, cell2);
+		cell_defer_no_holder(tc, cell1);
+
+		remap(tc, bio, result.block);
+		return DM_MAPIO_REMAPPED;
 
 	case -ENODATA:
 		if (get_pool_mode(tc->pool) == PM_READ_ONLY) {
-- 
1.7.1
