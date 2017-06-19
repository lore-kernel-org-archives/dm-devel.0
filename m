From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/10] mmc/block: remove a call to blk_queue_bounce_limit
Date: Mon, 19 Jun 2017 09:26:28 +0200
Message-ID: <20170619072628.12894-11-hch@lst.de>
References: <20170619072628.12894-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170619072628.12894-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

BLK_BOUNCE_ANY is the defauly now, so the call is superflous.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/mmc/core/queue.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
index 7f20298d892b..b659a28c8018 100644
--- a/drivers/mmc/core/queue.c
+++ b/drivers/mmc/core/queue.c
@@ -388,7 +388,6 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 		mmc_queue_setup_discard(mq->queue, card);
 
 	if (card->bouncesz) {
-		blk_queue_bounce_limit(mq->queue, BLK_BOUNCE_ANY);
 		blk_queue_max_hw_sectors(mq->queue, card->bouncesz / 512);
 		blk_queue_max_segments(mq->queue, card->bouncesz / 512);
 		blk_queue_max_segment_size(mq->queue, card->bouncesz);
-- 
2.11.0
