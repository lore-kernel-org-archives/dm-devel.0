From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] dm table: improve terse warning messages with
	more context
Date: Thu, 27 Aug 2009 09:31:36 -0400
Message-ID: <1251379896-30585-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

The lack of context in two dm-table warnings has already proven
unfortunate when analyzing the root-cause of these warnings.  Two recent
fixes went in to address issues that triggered these terse warnings:
5dea271b6d87bd1d79a59c1d5baac2596a841c37
ea9df47cc92573b159ef3b4fda516c32cba9c4fd

If the warnings contained the additional info that this patch provides
it would have made life easier on both the developers and end-users.

Having specific information up-front will improve the dialog with users
that hit these warnings in the future.

This patch also changes dm-table.c's physical_block_size and
logical_block_size (both unsigned int) printk format from %hu to %u.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>

---
 drivers/md/dm-table.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c
+++ linux-2.6/drivers/md/dm-table.c
@@ -360,8 +360,12 @@ static int device_area_is_invalid(struct
 		return 0;
 
 	if ((start >= dev_size) || (start + len > dev_size)) {
-		DMWARN("%s: %s too small for target",
-		       dm_device_name(ti->table->md), bdevname(bdev, b));
+		DMWARN("%s: %s too small for target: "
+		       "start=%llu, len=%llu, dev_size=%llu",
+		       dm_device_name(ti->table->md), bdevname(bdev, b),
+		       (unsigned long long)start,
+		       (unsigned long long)len,
+		       (unsigned long long)dev_size);
 		return 1;
 	}
 
@@ -370,7 +374,7 @@ static int device_area_is_invalid(struct
 
 	if (start & (logical_block_size_sectors - 1)) {
 		DMWARN("%s: start=%llu not aligned to h/w "
-		       "logical block size %hu of %s",
+		       "logical block size %u of %s",
 		       dm_device_name(ti->table->md),
 		       (unsigned long long)start,
 		       limits->logical_block_size, bdevname(bdev, b));
@@ -379,7 +383,7 @@ static int device_area_is_invalid(struct
 
 	if (len & (logical_block_size_sectors - 1)) {
 		DMWARN("%s: len=%llu not aligned to h/w "
-		       "logical block size %hu of %s",
+		       "logical block size %u of %s",
 		       dm_device_name(ti->table->md),
 		       (unsigned long long)len,
 		       limits->logical_block_size, bdevname(bdev, b));
@@ -496,8 +500,14 @@ int dm_set_device_limits(struct dm_targe
 	}
 
 	if (blk_stack_limits(limits, &q->limits, start << 9) < 0)
-		DMWARN("%s: target device %s is misaligned",
-		       dm_device_name(ti->table->md), bdevname(bdev, b));
+		DMWARN("%s: target device %s is misaligned: "
+		       "physical_block_size=%u, logical_block_size=%u, "
+		       "alignment_offset=%u, start=%llu",
+		       dm_device_name(ti->table->md), bdevname(bdev, b),
+		       q->limits.physical_block_size,
+		       q->limits.logical_block_size,
+		       q->limits.alignment_offset,
+		       (unsigned long long) start << 9);
 
 	/*
 	 * Check if merge fn is supported.
@@ -698,7 +708,7 @@ static int validate_hardware_logical_blo
 
 	if (remaining) {
 		DMWARN("%s: table line %u (start sect %llu len %llu) "
-		       "not aligned to h/w logical block size %hu",
+		       "not aligned to h/w logical block size %u",
 		       dm_device_name(table->md), i,
 		       (unsigned long long) ti->begin,
 		       (unsigned long long) ti->len,
