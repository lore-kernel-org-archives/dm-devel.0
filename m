From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/10] blk-mq: don't bounce by default
Date: Mon, 19 Jun 2017 09:26:24 +0200
Message-ID: <20170619072628.12894-7-hch@lst.de>
References: <20170619072628.12894-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170619072628.12894-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

For historical reasons we default to bouncing highmem pages for all block
queues.  But the blk-mq drivers are easy to audit to ensure that we don't
need this - scsi and mtip32xx set explicit limits and everyone else doesn't
have any particular ones.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c               | 5 -----
 drivers/block/virtio_blk.c   | 3 ---
 drivers/block/xen-blkfront.c | 3 ---
 3 files changed, 11 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index e26b7435e245..dd276a9e138e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2300,11 +2300,6 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 	blk_queue_make_request(q, blk_mq_make_request);
 
 	/*
-	 * by default assume old behaviour and bounce for any highmem page
-	 */
-	blk_queue_bounce_limit(q, BLK_BOUNCE_HIGH);
-
-	/*
 	 * Do this after blk_queue_make_request() overrides it...
 	 */
 	q->nr_requests = set->queue_depth;
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index e59bd4549a8a..0297ad7c1452 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -720,9 +720,6 @@ static int virtblk_probe(struct virtio_device *vdev)
 	/* We can handle whatever the host told us to handle. */
 	blk_queue_max_segments(q, vblk->sg_elems-2);
 
-	/* No need to bounce any requests */
-	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
-
 	/* No real sector limit. */
 	blk_queue_max_hw_sectors(q, -1U);
 
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index ac90093fcb25..c852ed3c01d5 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -953,9 +953,6 @@ static void blkif_set_queue_limits(struct blkfront_info *info)
 
 	/* Make sure buffer addresses are sector-aligned. */
 	blk_queue_dma_alignment(rq, 511);
-
-	/* Make sure we don't use bounce buffers. */
-	blk_queue_bounce_limit(rq, BLK_BOUNCE_ANY);
 }
 
 static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size,
-- 
2.11.0
