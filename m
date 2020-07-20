From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] block: remove blk_queue_stack_limits
Date: Mon, 20 Jul 2020 08:12:51 +0200
Message-ID: <20200720061251.652457-4-hch@lst.de>
References: <20200720061251.652457-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200720061251.652457-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: Damien.LeMoal@wdc.com, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

This function is just a tiny wrapper around blk_stack_limits.  Open code
it int the two callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-settings.c         | 11 -----------
 drivers/block/drbd/drbd_nl.c |  4 ++--
 drivers/nvme/host/core.c     |  3 ++-
 include/linux/blkdev.h       |  1 -
 4 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 8c63af7726850c..76a7e03bcd6cac 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -455,17 +455,6 @@ void blk_queue_io_opt(struct request_queue *q, unsigned int opt)
 }
 EXPORT_SYMBOL(blk_queue_io_opt);
 
-/**
- * blk_queue_stack_limits - inherit underlying queue limits for stacked drivers
- * @t:	the stacking driver (top)
- * @b:  the underlying device (bottom)
- **/
-void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b)
-{
-	blk_stack_limits(&t->limits, &b->limits, 0);
-}
-EXPORT_SYMBOL(blk_queue_stack_limits);
-
 /**
  * blk_stack_limits - adjust queue_limits for stacked devices
  * @t:	the stacking driver limits (top device)
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index da4a3ebe04efa5..d0d9a549b58388 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1250,7 +1250,7 @@ static void fixup_discard_if_not_supported(struct request_queue *q)
 
 static void fixup_write_zeroes(struct drbd_device *device, struct request_queue *q)
 {
-	/* Fixup max_write_zeroes_sectors after blk_queue_stack_limits():
+	/* Fixup max_write_zeroes_sectors after blk_stack_limits():
 	 * if we can handle "zeroes" efficiently on the protocol,
 	 * we want to do that, even if our backend does not announce
 	 * max_write_zeroes_sectors itself. */
@@ -1361,7 +1361,7 @@ static void drbd_setup_queue_param(struct drbd_device *device, struct drbd_backi
 	decide_on_write_same_support(device, q, b, o, disable_write_same);
 
 	if (b) {
-		blk_queue_stack_limits(q, b);
+		blk_stack_limits(&q->limits, &b->limits, 0);
 
 		if (q->backing_dev_info->ra_pages !=
 		    b->backing_dev_info->ra_pages) {
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 5192a024dc1b9c..45c4c408649080 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1973,7 +1973,8 @@ static int __nvme_revalidate_disk(struct gendisk *disk, struct nvme_id_ns *id)
 #ifdef CONFIG_NVME_MULTIPATH
 	if (ns->head->disk) {
 		nvme_update_disk_info(ns->head->disk, ns, id);
-		blk_queue_stack_limits(ns->head->disk->queue, ns->queue);
+		blk_stack_limits(&ns->head->disk->queue->limits,
+				 &ns->queue->limits, 0);
 		revalidate_disk(ns->head->disk);
 	}
 #endif
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 247b0e0a2901f0..484cd3c8447452 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1108,7 +1108,6 @@ extern int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 			    sector_t offset);
 extern void disk_stack_limits(struct gendisk *disk, struct block_device *bdev,
 			      sector_t offset);
-extern void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b);
 extern void blk_queue_update_dma_pad(struct request_queue *, unsigned int);
 extern void blk_queue_segment_boundary(struct request_queue *, unsigned long);
 extern void blk_queue_virt_boundary(struct request_queue *, unsigned long);
-- 
2.27.0
