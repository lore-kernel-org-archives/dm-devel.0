From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5/5] dm thin: unroll issue_discard() to create
	longer discard bio chains
Date: Thu,  5 May 2016 11:54:25 -0400
Message-ID: <1462463665-85312-6-git-send-email-snitzer@redhat.com>
References: <1462463665-85312-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1462463665-85312-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

There is little benefit to doing this but it does structure DM thinp's
code to more cleanly use the __blkdev_issue_discard() interface --
particularly in passdown_double_checking_shared_status().

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c | 104 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 69 insertions(+), 35 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 598a78b..e4bb9da 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -334,26 +334,55 @@ static sector_t block_to_sectors(struct pool *pool, dm_block_t b)
 		(b * pool->sectors_per_block);
 }
 
-static int issue_discard(struct thin_c *tc, dm_block_t data_b, dm_block_t data_e,
-			 struct bio *parent_bio)
+/*----------------------------------------------------------------*/
+
+struct discard_op {
+	struct thin_c *tc;
+	struct blk_plug plug;
+	struct bio *parent_bio;
+	struct bio *bio;
+};
+
+static void begin_discard(struct discard_op *op, struct thin_c *tc, struct bio *parent)
+{
+	BUG_ON(!parent);
+
+	op->tc = tc;
+	blk_start_plug(&op->plug);
+	op->parent_bio = parent;
+	op->bio = NULL;
+}
+
+static int issue_discard(struct discard_op *op, dm_block_t data_b, dm_block_t data_e)
 {
-	int type = REQ_WRITE | REQ_DISCARD;
+	struct thin_c *tc = op->tc;
 	sector_t s = block_to_sectors(tc->pool, data_b);
 	sector_t len = block_to_sectors(tc->pool, data_e - data_b);
-	struct bio *bio = NULL;
-	struct blk_plug plug;
-	int ret;
 
-	blk_start_plug(&plug);
-	ret = __blkdev_issue_discard(tc->pool_dev->bdev, s, len,
-				     GFP_NOWAIT, type, &bio);
-	if (!ret && bio) {
-		bio_chain(bio, parent_bio);
-		submit_bio(type, bio);
+	return __blkdev_issue_discard(tc->pool_dev->bdev, s, len,
+				      GFP_NOWAIT, REQ_WRITE | REQ_DISCARD, &op->bio);
+}
+
+static void end_discard(struct discard_op *op, int r)
+{
+	if (op->bio) {
+		/*
+		 * Even if one of the calls to issue_discard failed, we
+		 * need to wait for the chain to complete.
+		 */
+		bio_chain(op->bio, op->parent_bio);
+		submit_bio(REQ_WRITE | REQ_DISCARD, op->bio);
 	}
-	blk_finish_plug(&plug);
 
-	return ret;
+	blk_finish_plug(&op->plug);
+
+	/*
+	 * Even if r is set, there could be sub discards in flight that we
+	 * need to wait for.
+	 */
+	if (r && !op->parent_bio->bi_error)
+		op->parent_bio->bi_error = r;
+	bio_endio(op->parent_bio);
 }
 
 /*----------------------------------------------------------------*/
@@ -968,24 +997,28 @@ static void process_prepared_discard_no_passdown(struct dm_thin_new_mapping *m)
 	mempool_free(m, tc->pool->mapping_pool);
 }
 
-static int passdown_double_checking_shared_status(struct dm_thin_new_mapping *m)
+/*----------------------------------------------------------------*/
+
+static void passdown_double_checking_shared_status(struct dm_thin_new_mapping *m)
 {
 	/*
 	 * We've already unmapped this range of blocks, but before we
 	 * passdown we have to check that these blocks are now unused.
 	 */
-	int r;
+	int r = 0;
 	bool used = true;
 	struct thin_c *tc = m->tc;
 	struct pool *pool = tc->pool;
 	dm_block_t b = m->data_block, e, end = m->data_block + m->virt_end - m->virt_begin;
+	struct discard_op op;
 
+	begin_discard(&op, tc, m->bio);
 	while (b != end) {
 		/* find start of unmapped run */
 		for (; b < end; b++) {
 			r = dm_pool_block_is_used(pool->pmd, b, &used);
 			if (r)
-				return r;
+				goto out;
 
 			if (!used)
 				break;
@@ -998,20 +1031,20 @@ static int passdown_double_checking_shared_status(struct dm_thin_new_mapping *m)
 		for (e = b + 1; e != end; e++) {
 			r = dm_pool_block_is_used(pool->pmd, e, &used);
 			if (r)
-				return r;
+				goto out;
 
 			if (used)
 				break;
 		}
 
-		r = issue_discard(tc, b, e, m->bio);
+		r = issue_discard(&op, b, e);
 		if (r)
-			return r;
+			goto out;
 
 		b = e;
 	}
-
-	return 0;
+out:
+	end_discard(&op, r);
 }
 
 static void process_prepared_discard_passdown(struct dm_thin_new_mapping *m)
@@ -1021,20 +1054,21 @@ static void process_prepared_discard_passdown(struct dm_thin_new_mapping *m)
 	struct pool *pool = tc->pool;
 
 	r = dm_thin_remove_range(tc->td, m->virt_begin, m->virt_end);
-	if (r)
+	if (r) {
 		metadata_operation_failed(pool, "dm_thin_remove_range", r);
+		bio_io_error(m->bio);
 
-	else if (m->maybe_shared)
-		r = passdown_double_checking_shared_status(m);
-	else
-		r = issue_discard(tc, m->data_block, m->data_block + (m->virt_end - m->virt_begin), m->bio);
+	} else if (m->maybe_shared) {
+		passdown_double_checking_shared_status(m);
+
+	} else {
+		struct discard_op op;
+		begin_discard(&op, tc, m->bio);
+		r = issue_discard(&op, m->data_block,
+				  m->data_block + (m->virt_end - m->virt_begin));
+		end_discard(&op, r);
+	}
 
-	/*
-	 * Even if r is set, there could be sub discards in flight that we
-	 * need to wait for.
-	 */
-	m->bio->bi_error = r;
-	bio_endio(m->bio);
 	cell_defer_no_holder(tc, m->cell);
 	mempool_free(m, pool->mapping_pool);
 }
@@ -1505,11 +1539,11 @@ static void break_up_discard_bio(struct thin_c *tc, dm_block_t begin, dm_block_t
 
 		/*
 		 * The parent bio must not complete before sub discard bios are
-		 * chained to it (see issue_discard's bio_chain)!
+		 * chained to it (see end_discard's bio_chain)!
 		 *
 		 * This per-mapping bi_remaining increment is paired with
 		 * the implicit decrement that occurs via bio_endio() in
-		 * process_prepared_discard_passdown().
+		 * end_discard().
 		 */
 		bio_inc_remaining(bio);
 		if (!dm_deferred_set_add_work(pool->all_io_ds, &m->list))
-- 
2.6.4 (Apple Git-63)
