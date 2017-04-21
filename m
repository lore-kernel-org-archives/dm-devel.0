From: damien.lemoal@wdc.com
Subject: [PATCH 03/10] dm-table: Check block devices zone model
	compatibility
Date: Fri, 21 Apr 2017 12:55:51 +0900
Message-ID: <20170421035558.2657-4-damien.lemoal@wdc.com>
References: <20170421035558.2657-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170421035558.2657-1-damien.lemoal@wdc.com>
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
Cc: linux-block@vger.kernel.org, Bart Van Assche <Bart.VanAssche@sandisk.com>, Damien Le Moal <damien.lemoal@wdc.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

From: Damien Le Moal <damien.lemoal@wdc.com>

When setting the dm device queue limits, several possibilities exists
for zoned block devices:
1) The dm target driver may want to expose a different zone model (e.g.
host-managed device emulation or regular block device on top of
host-managed zoned block devices)
2) Expose the underlying zone model of the devices as is

To allow both cases, the underlying block device zone model must be set
in the target limits in dm_set_device_limits() and the compatibility of
all devices checked similarly to the logical block size alignment. For
this last check, introduce the function validate_hardware_zone_model()
to check that all targets of a table have the same zone model and that
the zone size of the target devices are equal.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-table.c | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 6947f0f..4683cb6 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -505,6 +505,8 @@ static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 		       q->limits.alignment_offset,
 		       (unsigned long long) start << SECTOR_SHIFT);
 
+	limits->zoned = bdev_zoned_model(bdev);
+
 	return 0;
 }
 
@@ -720,6 +722,96 @@ static int validate_hardware_logical_block_alignment(struct dm_table *table,
 	return 0;
 }
 
+/*
+ * Check a devices's table for compatibility between zoned devices used by
+ * the table targets. The zone model may come directly from a target block
+ * device or may have been set by the target using the io_hints method.
+ * Overall, if any of the table device targets is advertized as a zoned
+ * block device, then all targets devices should also be advertized as
+ * using the same model and the devices zone size all equal.
+ */
+static int validate_hardware_zone_model(struct dm_table *table,
+					struct queue_limits *limits)
+{
+	struct dm_target *ti;
+	struct queue_limits ti_limits;
+	unsigned int zone_sectors = limits->chunk_sectors;
+	unsigned int num_targets = dm_table_get_num_targets(table);
+	int zone_model = -1;
+	unsigned int i = 0;
+
+	if (!num_targets)
+		return 0;
+
+	/*
+	 * Check each entry in the table in turn.
+	 */
+	while (i < num_targets) {
+
+		ti = dm_table_get_target(table, i);
+
+		/* Get the target device limits */
+		blk_set_stacking_limits(&ti_limits);
+		if (ti->type->iterate_devices)
+			ti->type->iterate_devices(ti, dm_set_device_limits,
+						  &ti_limits);
+
+		/*
+		 * Let the target driver change the hardware limits, and
+		 * in particular the zone model if needed.
+		 */
+		if (ti->type->io_hints)
+			ti->type->io_hints(ti, &ti_limits);
+
+		/* Check zone model compatibility */
+		if (zone_model == -1)
+			zone_model = ti_limits.zoned;
+		if (ti_limits.zoned != zone_model) {
+			zone_model = -1;
+			break;
+		}
+
+		if (zone_model != BLK_ZONED_NONE) {
+			/* Check zone size validity and compatibility */
+			if (!zone_sectors ||
+			    !is_power_of_2(zone_sectors))
+				break;
+			if (ti_limits.chunk_sectors != zone_sectors) {
+				zone_sectors = ti_limits.chunk_sectors;
+				break;
+			}
+		}
+
+		i++;
+
+	}
+
+	if (i < num_targets) {
+		if (zone_model == -1)
+			DMWARN("%s: table line %u (start sect %llu len %llu) "
+			       "has an incompatible zone model",
+			       dm_device_name(table->md), i,
+			       (unsigned long long) ti->begin,
+			       (unsigned long long) ti->len);
+		else
+			DMWARN("%s: table line %u (start sect %llu len %llu) "
+			       "has an incompatible zone size %u",
+			       dm_device_name(table->md), i,
+			       (unsigned long long) ti->begin,
+			       (unsigned long long) ti->len,
+			       zone_sectors);
+		return -EINVAL;
+	}
+
+	if (zone_model == BLK_ZONED_HA ||
+	    zone_model == BLK_ZONED_HM) {
+		limits->zoned = zone_model;
+		limits->chunk_sectors = zone_sectors;
+	}
+
+	return 0;
+}
+
 int dm_table_add_target(struct dm_table *t, const char *type,
 			sector_t start, sector_t len, char *params)
 {
@@ -1432,6 +1524,9 @@ int dm_calculate_queue_limits(struct dm_table *table,
 			       (unsigned long long) ti->len);
 	}
 
+	if (validate_hardware_zone_model(table, limits))
+		return -EINVAL;
+
 	return validate_hardware_logical_block_alignment(table, limits);
 }
 
-- 
2.9.3

Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.
