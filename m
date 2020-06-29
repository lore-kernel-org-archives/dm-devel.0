From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/20] rsxx: stop using ->queuedata
Date: Mon, 29 Jun 2020 21:39:33 +0200
Message-ID: <20200629193947.2705954-7-hch@lst.de>
References: <20200629193947.2705954-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20200629193947.2705954-1-hch@lst.de>
Sender: linux-bcache-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org
List-Id: dm-devel.ids

Instead of setting up the queuedata as well just use one private data
field.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/rsxx/dev.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/block/rsxx/dev.c b/drivers/block/rsxx/dev.c
index 3ba07ab30c84f5..6a4d8d26e32cbd 100644
--- a/drivers/block/rsxx/dev.c
+++ b/drivers/block/rsxx/dev.c
@@ -119,7 +119,7 @@ static void bio_dma_done_cb(struct rsxx_cardinfo *card,
 
 static blk_qc_t rsxx_make_request(struct request_queue *q, struct bio *bio)
 {
-	struct rsxx_cardinfo *card = q->queuedata;
+	struct rsxx_cardinfo *card = bio->bi_disk->private_data;
 	struct rsxx_bio_meta *bio_meta;
 	blk_status_t st = BLK_STS_IOERR;
 
@@ -267,8 +267,6 @@ int rsxx_setup_dev(struct rsxx_cardinfo *card)
 		card->queue->limits.discard_alignment   = RSXX_HW_BLK_SIZE;
 	}
 
-	card->queue->queuedata = card;
-
 	snprintf(card->gendisk->disk_name, sizeof(card->gendisk->disk_name),
 		 "rsxx%d", card->disk_id);
 	card->gendisk->major = card->major;
@@ -289,7 +287,6 @@ void rsxx_destroy_dev(struct rsxx_cardinfo *card)
 	card->gendisk = NULL;
 
 	blk_cleanup_queue(card->queue);
-	card->queue->queuedata = NULL;
 	unregister_blkdev(card->major, DRIVER_NAME);
 }
 
-- 
2.26.2
