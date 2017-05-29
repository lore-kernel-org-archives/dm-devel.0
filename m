From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 3/4] dm: Fix zoned block device model validation
Date: Mon, 29 May 2017 19:23:06 +0900
Message-ID: <20170529102307.19814-4-damien.lemoal@wdc.com>
References: <20170529102307.19814-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170529102307.19814-1-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

A target type may be implementing a zoned model different from that of
the table devices. This means that the compatibility of the table
devices zoned models and zone sizes should not be checked against the
zoned model and zone size indicated by the stacked limits.
Fix validate_hardware_zoned_model() so that compatibility of zoned
models and zone sizes is done only between the table devices, ignoring
the stacked limits values.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-table.c | 99 +++++++++++++++++++++++++--------------------------
 1 file changed, 49 insertions(+), 50 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 9ba58d3..9849042 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1381,83 +1381,82 @@ bool dm_table_has_no_data_devices(struct dm_table *table)
 	return true;
 }
 
-static int device_is_zoned_model(struct dm_target *ti, struct dm_dev *dev,
-				 sector_t start, sector_t len, void *data)
+static int device_matches_zoned_model(struct dm_target *ti, struct dm_dev *dev,
+				      sector_t start, sector_t len, void *data)
 {
-	struct request_queue *q = bdev_get_queue(dev->bdev);
+	struct block_device *bdev = dev->bdev;
 	enum blk_zoned_model *zoned_model = data;
 
-	return q && blk_queue_zoned_model(q) == *zoned_model;
-}
-
-static bool dm_table_supports_zoned_model(struct dm_table *t,
-					  enum blk_zoned_model zoned_model)
-{
-	struct dm_target *ti;
-	unsigned i;
-
-	for (i = 0; i < dm_table_get_num_targets(t); i++) {
-		ti = dm_table_get_target(t, i);
-
-		if (zoned_model == BLK_ZONED_HM &&
-		    !dm_target_supports_zoned_hm(ti->type))
-			return false;
+	if (bdev_zoned_model(bdev) == BLK_ZONED_HM &&
+	    !dm_target_supports_zoned_hm(ti->type))
+		return 0;
 
-		if (!ti->type->iterate_devices ||
-		    !ti->type->iterate_devices(ti, device_is_zoned_model, &zoned_model))
-			return false;
-	}
+	if (*zoned_model == -1) {
+		*zoned_model = bdev_zoned_model(bdev);
+		return 1;
+ 	}
 
-	return true;
+	return bdev_zoned_model(bdev) == *zoned_model;
 }
 
 static int device_matches_zone_sectors(struct dm_target *ti, struct dm_dev *dev,
 				       sector_t start, sector_t len, void *data)
 {
-	struct request_queue *q = bdev_get_queue(dev->bdev);
+	struct block_device *bdev = dev->bdev;
 	unsigned int *zone_sectors = data;
 
-	return q && blk_queue_zone_sectors(q) == *zone_sectors;
-}
-
-static bool dm_table_matches_zone_sectors(struct dm_table *t,
-					  unsigned int zone_sectors)
-{
-	struct dm_target *ti;
-	unsigned i;
-
-	for (i = 0; i < dm_table_get_num_targets(t); i++) {
-		ti = dm_table_get_target(t, i);
-
-		if (!ti->type->iterate_devices ||
-		    !ti->type->iterate_devices(ti, device_matches_zone_sectors, &zone_sectors))
-			return false;
+	if (*zone_sectors == -1) {
+		*zone_sectors = bdev_zone_sectors(bdev);
+		return 1;
 	}
 
-	return true;
+	return bdev_zone_sectors(bdev) == *zone_sectors;
 }
 
 static int validate_hardware_zoned_model(struct dm_table *table,
 					 struct queue_limits *limits)
 {
-	if (!dm_table_supports_zoned_model(table, limits->zoned)) {
-		DMERR("%s: zoned model is inconsistent across all devices",
-		      dm_device_name(table->md));
-		return -EINVAL;
-	}
+	enum blk_zoned_model zoned_model = -1;
+	sector_t zone_sectors = -1;
+ 	struct dm_target *ti;
+ 	unsigned i;
 
 	if (limits->zoned != BLK_ZONED_NONE) {
-		unsigned int zone_sectors = limits->chunk_sectors;
-
-		/* Check zone size validity and compatibility */
+		/* Check stacked limits zone size validity */
+		zone_sectors = limits->chunk_sectors;
 		if (!zone_sectors || !is_power_of_2(zone_sectors))
 			return -EINVAL;
+	}
 
-		if (!dm_table_matches_zone_sectors(table, zone_sectors)) {
-			DMERR("%s: zone sectors is inconsistent across all devices",
+	/*
+	 * Check table devices zoned model and zone size compatibility.
+	 * This is done for any type of stacked limits zoned model since the
+	 * table targets may have overriden the zoned model of the devices
+	 * (e.g. the target type is doing emulation of a different zoned model).
+	 */
+	for (i = 0; i < dm_table_get_num_targets(table); i++) {
+		ti = dm_table_get_target(table, i);
+
+		if (limits->zoned != BLK_ZONED_NONE &&
+		    !ti->type->iterate_devices)
+			/* Cannot check */
+			return -EINVAL;
+
+		/* Check device zoned model compatibility */
+		if (!ti->type->iterate_devices(ti, device_matches_zoned_model,
+					       &zoned_model)) {
+			DMERR("%s: zoned model is inconsistent across all devices",
 			      dm_device_name(table->md));
 			return -EINVAL;
 		}
+
+		/* Check device zone size compatibility */
+		if (!ti->type->iterate_devices(ti, device_matches_zone_sectors,
+					       &zone_sectors)) {
+ 			DMERR("%s: zone sectors is inconsistent across all devices",
+ 			      dm_device_name(table->md));
+ 			return -EINVAL;
+		}
 	}
 
 	return 0;
-- 
2.9.4

Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.
