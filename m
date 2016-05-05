From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4/5] dm thin: use __blkdev_issue_discard for
	async discard support
Date: Thu,  5 May 2016 11:54:24 -0400
Message-ID: <1462463665-85312-5-git-send-email-snitzer@redhat.com>
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

With commit 38f25255330 ("block: add __blkdev_issue_discard") DM thinp
no longer needs to carry its own async discard method.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
---
 drivers/md/dm-thin.c | 70 ++++++++++++----------------------------------------
 1 file changed, 16 insertions(+), 54 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index da42c49..598a78b 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -322,56 +322,6 @@ struct thin_c {
 
 /*----------------------------------------------------------------*/
 
-/**
- * __blkdev_issue_discard_async - queue a discard with async completion
- * @bdev:	blockdev to issue discard for
- * @sector:	start sector
- * @nr_sects:	number of sectors to discard
- * @gfp_mask:	memory allocation flags (for bio_alloc)
- * @flags:	BLKDEV_IFL_* flags to control behaviour
- * @parent_bio: parent discard bio that all sub discards get chained to
- *
- * Description:
- *    Asynchronously issue a discard request for the sectors in question.
- */
-static int __blkdev_issue_discard_async(struct block_device *bdev, sector_t sector,
-					sector_t nr_sects, gfp_t gfp_mask, unsigned long flags,
-					struct bio *parent_bio)
-{
-	struct request_queue *q = bdev_get_queue(bdev);
-	int type = REQ_WRITE | REQ_DISCARD;
-	struct bio *bio;
-
-	if (!q || !nr_sects)
-		return -ENXIO;
-
-	if (!blk_queue_discard(q))
-		return -EOPNOTSUPP;
-
-	if (flags & BLKDEV_DISCARD_SECURE) {
-		if (!blk_queue_secdiscard(q))
-			return -EOPNOTSUPP;
-		type |= REQ_SECURE;
-	}
-
-	/*
-	 * Required bio_put occurs in bio_endio thanks to bio_chain below
-	 */
-	bio = bio_alloc(gfp_mask, 1);
-	if (!bio)
-		return -ENOMEM;
-
-	bio_chain(bio, parent_bio);
-
-	bio->bi_iter.bi_sector = sector;
-	bio->bi_bdev = bdev;
-	bio->bi_iter.bi_size = nr_sects << 9;
-
-	submit_bio(type, bio);
-
-	return 0;
-}
-
 static bool block_size_is_power_of_two(struct pool *pool)
 {
 	return pool->sectors_per_block_shift >= 0;
@@ -387,11 +337,23 @@ static sector_t block_to_sectors(struct pool *pool, dm_block_t b)
 static int issue_discard(struct thin_c *tc, dm_block_t data_b, dm_block_t data_e,
 			 struct bio *parent_bio)
 {
+	int type = REQ_WRITE | REQ_DISCARD;
 	sector_t s = block_to_sectors(tc->pool, data_b);
 	sector_t len = block_to_sectors(tc->pool, data_e - data_b);
+	struct bio *bio = NULL;
+	struct blk_plug plug;
+	int ret;
+
+	blk_start_plug(&plug);
+	ret = __blkdev_issue_discard(tc->pool_dev->bdev, s, len,
+				     GFP_NOWAIT, type, &bio);
+	if (!ret && bio) {
+		bio_chain(bio, parent_bio);
+		submit_bio(type, bio);
+	}
+	blk_finish_plug(&plug);
 
-	return __blkdev_issue_discard_async(tc->pool_dev->bdev, s, len,
-					    GFP_NOWAIT, 0, parent_bio);
+	return ret;
 }
 
 /*----------------------------------------------------------------*/
@@ -1543,11 +1505,11 @@ static void break_up_discard_bio(struct thin_c *tc, dm_block_t begin, dm_block_t
 
 		/*
 		 * The parent bio must not complete before sub discard bios are
-		 * chained to it (see __blkdev_issue_discard_async's bio_chain)!
+		 * chained to it (see issue_discard's bio_chain)!
 		 *
 		 * This per-mapping bi_remaining increment is paired with
 		 * the implicit decrement that occurs via bio_endio() in
-		 * process_prepared_discard_{passdown,no_passdown}.
+		 * process_prepared_discard_passdown().
 		 */
 		bio_inc_remaining(bio);
 		if (!dm_deferred_set_add_work(pool->all_io_ds, &m->list))
-- 
2.6.4 (Apple Git-63)
