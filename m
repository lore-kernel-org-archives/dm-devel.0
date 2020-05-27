From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/16] rsxx: use bio_{start,end}_io_acct
Date: Wed, 27 May 2020 07:24:06 +0200
Message-ID: <20200527052419.403583-4-hch@lst.de>
References: <20200527052419.403583-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20200527052419.403583-1-hch@lst.de>
Sender: linux-bcache-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, dm-devel@redhat.com, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Switch rsxx to use the nicer bio accounting helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 drivers/block/rsxx/dev.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/block/rsxx/dev.c b/drivers/block/rsxx/dev.c
index 8ffa8260dcafe..3ba07ab30c84f 100644
--- a/drivers/block/rsxx/dev.c
+++ b/drivers/block/rsxx/dev.c
@@ -96,20 +96,6 @@ static const struct block_device_operations rsxx_fops = {
 	.ioctl		= rsxx_blkdev_ioctl,
 };
 
-static void disk_stats_start(struct rsxx_cardinfo *card, struct bio *bio)
-{
-	generic_start_io_acct(card->queue, bio_op(bio), bio_sectors(bio),
-			     &card->gendisk->part0);
-}
-
-static void disk_stats_complete(struct rsxx_cardinfo *card,
-				struct bio *bio,
-				unsigned long start_time)
-{
-	generic_end_io_acct(card->queue, bio_op(bio),
-			    &card->gendisk->part0, start_time);
-}
-
 static void bio_dma_done_cb(struct rsxx_cardinfo *card,
 			    void *cb_data,
 			    unsigned int error)
@@ -121,7 +107,7 @@ static void bio_dma_done_cb(struct rsxx_cardinfo *card,
 
 	if (atomic_dec_and_test(&meta->pending_dmas)) {
 		if (!card->eeh_state && card->gendisk)
-			disk_stats_complete(card, meta->bio, meta->start_time);
+			bio_end_io_acct(meta->bio, meta->start_time);
 
 		if (atomic_read(&meta->error))
 			bio_io_error(meta->bio);
@@ -167,10 +153,9 @@ static blk_qc_t rsxx_make_request(struct request_queue *q, struct bio *bio)
 	bio_meta->bio = bio;
 	atomic_set(&bio_meta->error, 0);
 	atomic_set(&bio_meta->pending_dmas, 0);
-	bio_meta->start_time = jiffies;
 
 	if (!unlikely(card->halt))
-		disk_stats_start(card, bio);
+		bio_meta->start_time = bio_start_io_acct(bio);
 
 	dev_dbg(CARD_TO_DEV(card), "BIO[%c]: meta: %p addr8: x%llx size: %d\n",
 		 bio_data_dir(bio) ? 'W' : 'R', bio_meta,
-- 
2.26.2
