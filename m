From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 03/10] dm-table: Check block devices zone
	model compatibility
Date: Mon, 8 May 2017 16:40:45 -0700
Message-ID: <20170508234052.32375-4-bart.vanassche@sandisk.com>
References: <20170508234052.32375-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170508234052.32375-1-bart.vanassche@sandisk.com>
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
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Damien Le Moal <damien.lemoal@wdc.com>, Christoph Hellwig <hch@lst.de>
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
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/md/dm-table.c | 93 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 3949897..bac1438 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -506,6 +506,8 @@ static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 		       q->limits.alignment_offset,
 		       (unsigned long long) start << SECTOR_SHIFT);
 
+	limits->zoned = bdev_zoned_model(bdev);
+
 	return 0;
 }
 
@@ -721,6 +723,94 @@ static int validate_hardware_logical_block_alignment(struct dm_table *table,
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
+	unsigned int i;
+
+	if (!num_targets)
+		return 0;
+
+	/*
+	 * Check each entry in the table in turn.
+	 */
+	for (i = 0; i < num_targets; i++) {
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
@@ -1448,6 +1538,9 @@ int dm_calculate_queue_limits(struct dm_table *table,
 			       (unsigned long long) ti->len);
 	}
 
+	if (validate_hardware_zone_model(table, limits))
+		return -EINVAL;
+
 	return validate_hardware_logical_block_alignment(table, limits);
 }
 
-- 
2.9.3
