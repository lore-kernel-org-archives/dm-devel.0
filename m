From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 2/4] dm: Fix staking limits for zoned block device
Date: Mon, 29 May 2017 19:23:05 +0900
Message-ID: <20170529102307.19814-3-damien.lemoal@wdc.com>
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

Since blk_stack_limits() does not change the zoned model type, in
dm_calculate_queue_limits(), make sure to report the correct stacked
limits by setting the zoned model to the model of the underlying table
device, after eventual override by the target .io_hints. This allows
removing the local variables zoned_model and zone_sectors and to
simplify validate_hardware_zoned_model() interface.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-table.c | 46 +++++++++++++++++++---------------------------
 1 file changed, 19 insertions(+), 27 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 6545150..9ba58d3 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1438,16 +1438,17 @@ static bool dm_table_matches_zone_sectors(struct dm_table *t,
 }
 
 static int validate_hardware_zoned_model(struct dm_table *table,
-					 enum blk_zoned_model zoned_model,
-					 unsigned int zone_sectors)
+					 struct queue_limits *limits)
 {
-	if (!dm_table_supports_zoned_model(table, zoned_model)) {
+	if (!dm_table_supports_zoned_model(table, limits->zoned)) {
 		DMERR("%s: zoned model is inconsistent across all devices",
 		      dm_device_name(table->md));
 		return -EINVAL;
 	}
 
-	if (zoned_model != BLK_ZONED_NONE) {
+	if (limits->zoned != BLK_ZONED_NONE) {
+		unsigned int zone_sectors = limits->chunk_sectors;
+
 		/* Check zone size validity and compatibility */
 		if (!zone_sectors || !is_power_of_2(zone_sectors))
 			return -EINVAL;
@@ -1471,8 +1472,6 @@ int dm_calculate_queue_limits(struct dm_table *table,
 	struct dm_target *ti;
 	struct queue_limits ti_limits;
 	unsigned i;
-	enum blk_zoned_model zoned_model = BLK_ZONED_NONE;
-	unsigned int zone_sectors = 0;
 
 	blk_set_stacking_limits(limits);
 
@@ -1490,15 +1489,6 @@ int dm_calculate_queue_limits(struct dm_table *table,
 		ti->type->iterate_devices(ti, dm_set_device_limits,
 					  &ti_limits);
 
-		if (zoned_model == BLK_ZONED_NONE && ti_limits.zoned != BLK_ZONED_NONE) {
-			/*
-			 * After stacking all limits, validate all devices
-			 * in table support this zoned model and zone sectors.
-			 */
-			zoned_model = ti_limits.zoned;
-			zone_sectors = ti_limits.chunk_sectors;
-		}
-
 		/* Set I/O hints portion of queue limits */
 		if (ti->type->io_hints)
 			ti->type->io_hints(ti, &ti_limits);
@@ -1523,20 +1513,22 @@ int dm_calculate_queue_limits(struct dm_table *table,
 			       dm_device_name(table->md),
 			       (unsigned long long) ti->begin,
 			       (unsigned long long) ti->len);
+
+		if (limits->zoned == BLK_ZONED_NONE &&
+		    ti_limits.zoned != BLK_ZONED_NONE) {
+			/*
+			 * By default, the stacked limits zoned model is set to
+			 * BLK_ZONED_NONE in blk_set_stacking_limits(). Update
+			 * this model using the first target model reported
+			 * that is not BLK_ZONED_NONE. This will be either the
+			 * first target device zoned model or the model reported
+			 * by the target .io_hints.
+			 */
+			limits->zoned = ti_limits.zoned;
+		}
 	}
 
-	/*
-	 * Verify that the zoned model and zone sectors, as determined before
-	 * any .io_hints override, are the same across all devices in the table.
-	 * - but if limits->zoned is not BLK_ZONED_NONE validate match for it
-	 * - simillarly, check all devices conform to limits->chunk_sectors if
-	 *   .io_hints altered them
-	 */
-	if (limits->zoned != BLK_ZONED_NONE)
-		zoned_model = limits->zoned;
-	if (limits->chunk_sectors != zone_sectors)
-		zone_sectors = limits->chunk_sectors;
-	if (validate_hardware_zoned_model(table, zoned_model, zone_sectors))
+	if (validate_hardware_zoned_model(table, limits))
 		return -EINVAL;
 
 	return validate_hardware_logical_block_alignment(table, limits);
-- 
2.9.4

Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.
