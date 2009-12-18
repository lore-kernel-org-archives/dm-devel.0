From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] dm: Fix alignment stacking on partitioned devices
Date: Fri, 18 Dec 2009 02:30:51 -0500
Message-ID: <yq1aaxg7n84.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: jens.axboe@oracle.com
List-Id: dm-devel.ids


The dm device limits function passes the start sector within the block
device to the block layer stacking function.  However, the partition's
offset on the physical device is not added, resulting in incorrect
alignment reporting.

Add the partition offset to the values passed to blk_stack_limits().

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index be62547..67efac9 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -495,6 +495,7 @@ int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 	struct queue_limits *limits = data;
 	struct block_device *bdev = dev->bdev;
 	struct request_queue *q = bdev_get_queue(bdev);
+	sector_t offset = (get_start_sect(bdev) + start) << 9;
 	char b[BDEVNAME_SIZE];
 
 	if (unlikely(!q)) {
@@ -503,7 +504,7 @@ int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 		return 0;
 	}
 
-	if (blk_stack_limits(limits, &q->limits, start << 9) < 0)
+	if (blk_stack_limits(limits, &q->limits, offset) < 0)
 		DMWARN("%s: target device %s is misaligned: "
 		       "physical_block_size=%u, logical_block_size=%u, "
 		       "alignment_offset=%u, start=%llu",
@@ -511,7 +512,7 @@ int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 		       q->limits.physical_block_size,
 		       q->limits.logical_block_size,
 		       q->limits.alignment_offset,
-		       (unsigned long long) start << 9);
+		       (unsigned long long) offset);
 
 
 	/*
