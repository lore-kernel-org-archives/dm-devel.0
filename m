From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] dm: Fix alignment stacking on partitioned
	devices
Date: Wed, 23 Dec 2009 13:07:20 -0500
Message-ID: <1261591640-24380-1-git-send-email-snitzer@redhat.com>
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
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

From: Martin K. Petersen <martin.petersen@oracle.com> 

The DM device limits function passes the start offset within the block
device to the block layer stacking function.  The stacking function
expects the provided start offset to be relative to start of the disk
(request_queue).  Until now DM was passing a start offset that was
relative to beginning of the partition (block_device), resulting in
incorrect alignment stacking.

Add the partition offset to the values passed to blk_stack_limits().

Also clarify, in the DMWARN message, that the device which caused
blk_stack_limits() to return failure isn't necessarily misaligned
itself.  It caused the top-level (DM) device to have inconsistent
alignment when taken in combination with all previously stacked
device(s).

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-table.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index be62547..44527c1 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -495,6 +495,7 @@ int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 	struct queue_limits *limits = data;
 	struct block_device *bdev = dev->bdev;
 	struct request_queue *q = bdev_get_queue(bdev);
+	sector_t offset = (get_start_sect(bdev) + start) << 9;
 	char b[BDEVNAME_SIZE];
 
 	if (unlikely(!q)) {
@@ -503,15 +504,15 @@ int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 		return 0;
 	}
 
-	if (blk_stack_limits(limits, &q->limits, start << 9) < 0)
-		DMWARN("%s: target device %s is misaligned: "
+	if (blk_stack_limits(limits, &q->limits, offset) < 0)
+		DMWARN("%s: adding target device %s caused an alignment inconsistency: "
 		       "physical_block_size=%u, logical_block_size=%u, "
 		       "alignment_offset=%u, start=%llu",
 		       dm_device_name(ti->table->md), bdevname(bdev, b),
 		       q->limits.physical_block_size,
 		       q->limits.logical_block_size,
 		       q->limits.alignment_offset,
-		       (unsigned long long) start << 9);
+		       (unsigned long long) offset);
 
 
 	/*
