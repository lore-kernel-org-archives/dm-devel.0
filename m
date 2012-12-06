From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 1/4] dm thin: replace calls to
	dm_cell_release_singleton with cell_defer_no_holder
Date: Thu,  6 Dec 2012 09:43:44 -0500
Message-ID: <1354805027-29118-1-git-send-email-snitzer@redhat.com>
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

In every case dm_cell_release_singleton is called the bio in question
is the holder.  If there are no non-holder entries in the cell then
cell_defer_no_holder (renamed from cell_defer_except) behaves
identically to dm_cell_release_singleton.  If there *are* non-holder
entries then dm_cell_release_singleton is the wrong thing to call
because those entries must be deferred.

This patch offers no functional change but is a pre-requisite for
"dm thin: eliminate race when io and discards are issued
simultaneously the same block".

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/md/dm-thin.c |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index ceb17be..2fadaef 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -513,10 +513,10 @@ static void cell_defer(struct thin_c *tc, struct dm_bio_prison_cell *cell,
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
 	struct bio_list bios;
 	struct pool *pool = tc->pool;
@@ -573,7 +573,7 @@ static void process_prepared_mapping(struct dm_thin_new_mapping *m)
 	 * the bios in the cell.
 	 */
 	if (bio) {
-		cell_defer_except(tc, m->cell);
+		cell_defer_no_holder(tc, m->cell);
 		bio_endio(bio, 0);
 	} else
 		cell_defer(tc, m->cell, m->data_block);
@@ -588,8 +588,8 @@ static void process_prepared_discard_fail(struct dm_thin_new_mapping *m)
 	struct thin_c *tc = m->tc;
 
 	bio_io_error(m->bio);
-	cell_defer_except(tc, m->cell);
-	cell_defer_except(tc, m->cell2);
+	cell_defer_no_holder(tc, m->cell);
+	cell_defer_no_holder(tc, m->cell2);
 	mempool_free(m, tc->pool->mapping_pool);
 }
 
@@ -602,8 +602,8 @@ static void process_prepared_discard_passdown(struct dm_thin_new_mapping *m)
 	else
 		bio_endio(m->bio, 0);
 
-	cell_defer_except(tc, m->cell);
-	cell_defer_except(tc, m->cell2);
+	cell_defer_no_holder(tc, m->cell);
+	cell_defer_no_holder(tc, m->cell2);
 	mempool_free(m, tc->pool->mapping_pool);
 }
 
@@ -936,7 +936,7 @@ static void process_discard(struct thin_c *tc, struct bio *bio)
 		 */
 		build_data_key(tc->td, lookup_result.block, &key2);
 		if (dm_bio_detain(tc->pool->prison, &key2, bio, &cell2)) {
-			dm_cell_release_singleton(cell, bio);
+			cell_defer_no_holder(tc, cell);
 			break;
 		}
 
@@ -967,8 +967,8 @@ static void process_discard(struct thin_c *tc, struct bio *bio)
 			 * a block boundary.  So we submit the discard of a
 			 * partial block appropriately.
 			 */
-			dm_cell_release_singleton(cell, bio);
-			dm_cell_release_singleton(cell2, bio);
+			cell_defer_no_holder(tc, cell);
+			cell_defer_no_holder(tc, cell2);
 			if ((!lookup_result.shared) && pool->pf.discard_passdown)
 				remap_and_issue(tc, bio, lookup_result.block);
 			else
@@ -980,14 +980,14 @@ static void process_discard(struct thin_c *tc, struct bio *bio)
 		/*
 		 * It isn't provisioned, just forget it.
 		 */
-		dm_cell_release_singleton(cell, bio);
+		cell_defer_no_holder(tc, cell);
 		bio_endio(bio, 0);
 		break;
 
 	default:
 		DMERR_LIMIT("%s: dm_thin_find_block() failed, error = %d",
 			    __func__, r);
-		dm_cell_release_singleton(cell, bio);
+		cell_defer_no_holder(tc, cell);
 		bio_io_error(bio);
 		break;
 	}
@@ -1043,7 +1043,7 @@ static void process_shared_bio(struct thin_c *tc, struct bio *bio,
 
 		h->shared_read_entry = dm_deferred_entry_inc(pool->shared_read_ds);
 
-		dm_cell_release_singleton(cell, bio);
+		cell_defer_no_holder(tc, cell);
 		remap_and_issue(tc, bio, lookup_result->block);
 	}
 }
@@ -1058,7 +1058,7 @@ static void provision_block(struct thin_c *tc, struct bio *bio, dm_block_t block
 	 * Remap empty bios (flushes) immediately, without provisioning.
 	 */
 	if (!bio->bi_size) {
-		dm_cell_release_singleton(cell, bio);
+		cell_defer_no_holder(tc, cell);
 		remap_and_issue(tc, bio, 0);
 		return;
 	}
@@ -1068,7 +1068,7 @@ static void provision_block(struct thin_c *tc, struct bio *bio, dm_block_t block
 	 */
 	if (bio_data_dir(bio) == READ) {
 		zero_fill_bio(bio);
-		dm_cell_release_singleton(cell, bio);
+		cell_defer_no_holder(tc, cell);
 		bio_endio(bio, 0);
 		return;
 	}
@@ -1123,7 +1123,7 @@ static void process_bio(struct thin_c *tc, struct bio *bio)
 		 * TODO: this will probably have to change when discard goes
 		 * back in.
 		 */
-		dm_cell_release_singleton(cell, bio);
+		cell_defer_no_holder(tc, cell);
 
 		if (lookup_result.shared)
 			process_shared_bio(tc, bio, block, &lookup_result);
@@ -1133,7 +1133,7 @@ static void process_bio(struct thin_c *tc, struct bio *bio)
 
 	case -ENODATA:
 		if (bio_data_dir(bio) == READ && tc->origin_dev) {
-			dm_cell_release_singleton(cell, bio);
+			cell_defer_no_holder(tc, cell);
 			remap_to_origin_and_issue(tc, bio);
 		} else
 			provision_block(tc, bio, block, cell);
@@ -1142,7 +1142,7 @@ static void process_bio(struct thin_c *tc, struct bio *bio)
 	default:
 		DMERR_LIMIT("%s: dm_thin_find_block() failed, error = %d",
 			    __func__, r);
-		dm_cell_release_singleton(cell, bio);
+		cell_defer_no_holder(tc, cell);
 		bio_io_error(bio);
 		break;
 	}
-- 
1.7.1
