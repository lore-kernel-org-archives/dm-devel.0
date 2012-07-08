From: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
Subject: [PATCH] DM MULTIPATH: Allow dm to send larger request if
 underlying device set to larger max_sectors value
Date: Sun, 8 Jul 2012 17:59:59 +0000
Message-ID: <F200AD42A082BC4088B232D13A916A8907E5DD64@SACEXCMBX02-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "Moger, Babu" <Babu.Moger@netapp.com>, "Stankey,
	Robert" <Robert.Stankey@netapp.com>
List-Id: dm-devel.ids

Even though underlying paths are set with larger value for max_sectors, dm 
sets 1024(i.e 512KB) for max_sectors as default. max_sectors for dm 
device can be reset through sysfs but any time map is updated, max_sectors
is again set back to default. This patch gets the minimum of max_sectors from 
physical paths and sets it to dm device.


Signed-off-by: Vijay Chauhan <vijay.chauhan@netapp.com>
Reviewed-by: Babu Moger <babu.moger@netapp.com>
Reviewed-by: Bob Stankey <Robert.Stankey@netapp.com>

---
--- linux-3.5-rc5-orig/drivers/md/dm-table.c	2012-07-07 11:39:17.000000000 +0530
+++ linux-3.5-rc5/drivers/md/dm-table.c	2012-07-09 00:52:37.000000000 +0530
@@ -549,6 +549,18 @@ int dm_set_device_limits(struct dm_targe
 }
 EXPORT_SYMBOL_GPL(dm_set_device_limits);
 
+int dm_device_max_sectors(struct dm_target *ti, struct dm_dev *dev,
+			sector_t start, sector_t len, void *data)
+{
+	unsigned int *max_sectors = data;
+	struct block_device *bdev = dev->bdev;
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	*max_sectors = min_not_zero(*max_sectors, q->limits.max_sectors);
+
+	return 0;
+}
+
 /*
  * Decrement a device's use count and remove it if necessary.
  */
@@ -692,6 +704,7 @@ static int validate_hardware_logical_blo
 	struct dm_target *uninitialized_var(ti);
 	struct queue_limits ti_limits;
 	unsigned i = 0;
+	unsigned int max_sectors = 0;
 
 	/*
 	 * Check each entry in the table in turn.
@@ -706,6 +719,15 @@ static int validate_hardware_logical_blo
 			ti->type->iterate_devices(ti, dm_set_device_limits,
 						  &ti_limits);
 
+		/* Find minimum of max_sectors from target devices */
+		if (ti->type->iterate_devices) {
+			ti->type->iterate_devices(ti, dm_device_max_sectors,
+						  &max_sectors);
+			limits->max_sectors = min_t(unsigned int,
+						    ti_limits.max_hw_sectors,
+						    max_sectors);
+		}
+
 		/*
 		 * If the remaining sectors fall entirely within this
 		 * table entry are they compatible with its logical_block_size?
--
