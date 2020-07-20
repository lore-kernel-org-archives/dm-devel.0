From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] block: remove bdev_stack_limits
Date: Mon, 20 Jul 2020 08:12:50 +0200
Message-ID: <20200720061251.652457-3-hch@lst.de>
References: <20200720061251.652457-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200720061251.652457-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: Damien.LeMoal@wdc.com, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

This function is just a tiny wrapper around blk_stack_limit and has
two callers.  Simplify the stack a bit by open coding it in the two
callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-settings.c   | 25 ++-----------------------
 drivers/md/dm-table.c  |  3 ++-
 include/linux/blkdev.h |  2 --
 3 files changed, 4 insertions(+), 26 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 9cddbd73647405..8c63af7726850c 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -614,28 +614,6 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 }
 EXPORT_SYMBOL(blk_stack_limits);
 
-/**
- * bdev_stack_limits - adjust queue limits for stacked drivers
- * @t:	the stacking driver limits (top device)
- * @bdev:  the component block_device (bottom)
- * @start:  first data sector within component device
- *
- * Description:
- *    Merges queue limits for a top device and a block_device.  Returns
- *    0 if alignment didn't change.  Returns -1 if adding the bottom
- *    device caused misalignment.
- */
-int bdev_stack_limits(struct queue_limits *t, struct block_device *bdev,
-		      sector_t start)
-{
-	struct request_queue *bq = bdev_get_queue(bdev);
-
-	start += get_start_sect(bdev);
-
-	return blk_stack_limits(t, &bq->limits, start);
-}
-EXPORT_SYMBOL(bdev_stack_limits);
-
 /**
  * disk_stack_limits - adjust queue limits for stacked drivers
  * @disk:  MD/DM gendisk (top)
@@ -651,7 +629,8 @@ void disk_stack_limits(struct gendisk *disk, struct block_device *bdev,
 {
 	struct request_queue *t = disk->queue;
 
-	if (bdev_stack_limits(&t->limits, bdev, offset >> 9) < 0) {
+	if (blk_stack_limits(&t->limits, &bdev_get_queue(bdev)->limits,
+			get_start_sect(bdev) + (offset >> 9)) < 0) {
 		char top[BDEVNAME_SIZE], bottom[BDEVNAME_SIZE];
 
 		disk_name(disk, 0, top);
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index ec5364133cef7f..aac4c31cfc8498 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -458,7 +458,8 @@ static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 		return 0;
 	}
 
-	if (bdev_stack_limits(limits, bdev, start) < 0)
+	if (blk_stack_limits(limits, &q->limits,
+			get_start_sect(bdev) + start) < 0)
 		DMWARN("%s: adding target device %s caused an alignment inconsistency: "
 		       "physical_block_size=%u, logical_block_size=%u, "
 		       "alignment_offset=%u, start=%llu",
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 67b9ccc1da3560..247b0e0a2901f0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1106,8 +1106,6 @@ extern void blk_set_default_limits(struct queue_limits *lim);
 extern void blk_set_stacking_limits(struct queue_limits *lim);
 extern int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 			    sector_t offset);
-extern int bdev_stack_limits(struct queue_limits *t, struct block_device *bdev,
-			    sector_t offset);
 extern void disk_stack_limits(struct gendisk *disk, struct block_device *bdev,
 			      sector_t offset);
 extern void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b);
-- 
2.27.0
