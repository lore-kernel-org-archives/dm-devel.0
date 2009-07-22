From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 2/2] Disable partition scan
Date: Wed, 22 Jul 2009 10:01:29 +0200
Message-ID: <20090722080129.E9393D340B@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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
To: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, jens.axboe@oracle.com
List-Id: dm-devel.ids


For some setups (multipath or dmraid) the in-kernel partition scan
is pointless as the (block) partitions won't be used anywhere.
Worse, it might trigger I/O errors as the partition table might not
be accessible (eg for the passive path of a multipath device) or
even invalid (eg for RAID0 dmraid).
This patch allows to switch off the in-kernel partition scan by adding
'no_partition_scan' to the kernel commandline. Partitions scan can be
allowed for individual disk by echoing a positive number into
/sys/block/XXX/range and rescan the disk.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 Documentation/kernel-parameters.txt |    5 ++++
 block/genhd.c                       |   41 ++++++++++++++++++++++++++++++++--
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index d08759a..47bed29 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1424,6 +1424,11 @@ and is between 256 and 4096 characters. It is defined in the file
 	mtdparts=	[MTD]
 			See drivers/mtd/cmdlinepart.c.
 
+	no_partition_scan	[KNL] Inhibit in-kernel partition scan
+			for all block devices. Partition scan can be
+			re-enabled for individual devices by writing
+			a non-zero value in /sys/block/XX/range.
+
 	onenand.bdry=	[HW,MTD] Flex-OneNAND Boundary Configuration
 
 			Format: [die0_boundary][,die0_lock][,die1_boundary][,die1_lock]
diff --git a/block/genhd.c b/block/genhd.c
index f4c64c2..d120ec8 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -504,6 +504,18 @@ static int exact_lock(dev_t devt, void *data)
 	return 0;
 }
 
+static int __read_mostly no_partition_scan;
+
+static int __init no_partition_scan_setup(char *str)
+{
+	no_partition_scan = 1;
+	printk(KERN_INFO "genhd: omit partition scan.\n");
+
+	return 1;
+}
+
+__setup("no_partition_scan", no_partition_scan_setup);
+
 /**
  * add_disk - add partitioning information to kernel list
  * @disk: per-device partitioning information
@@ -527,6 +539,8 @@ void add_disk(struct gendisk *disk)
 	WARN_ON(!disk->minors && !(disk->flags & GENHD_FL_EXT_DEVT));
 
 	disk->flags |= GENHD_FL_UP;
+	if (no_partition_scan)
+		disk->flags |= GENHD_FL_USERSPACE_PARTITIONS;
 
 	retval = blk_alloc_devt(&disk->part0, &devt);
 	if (retval) {
@@ -816,7 +830,27 @@ static ssize_t disk_range_show(struct device *dev,
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
-	return sprintf(buf, "%d\n", disk->minors);
+	return sprintf(buf, "%d\n",
+		       (disk_userspace_partitions(disk) ? 0 : disk->minors));
+}
+
+static ssize_t disk_range_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+	int i;
+
+	if (count > 0 && sscanf(buf, "%d", &i) > 0) {
+		if (i == 0)
+			disk->flags |= GENHD_FL_USERSPACE_PARTITIONS;
+		else if (i <= disk->minors)
+			disk->flags &= ~GENHD_FL_USERSPACE_PARTITIONS;
+		else
+			count = -EINVAL;
+	}
+
+	return count;
 }
 
 static ssize_t disk_ext_range_show(struct device *dev,
@@ -824,7 +858,8 @@ static ssize_t disk_ext_range_show(struct device *dev,
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
-	return sprintf(buf, "%d\n", disk_max_parts(disk));
+	return sprintf(buf, "%d\n",
+		       disk_userspace_partitions(disk) ? 0: disk_max_parts(disk));
 }
 
 static ssize_t disk_removable_show(struct device *dev,
@@ -861,7 +896,7 @@ static ssize_t disk_alignment_offset_show(struct device *dev,
 	return sprintf(buf, "%d\n", queue_alignment_offset(disk->queue));
 }
 
-static DEVICE_ATTR(range, S_IRUGO, disk_range_show, NULL);
+static DEVICE_ATTR(range, S_IRUGO, disk_range_show, disk_range_store);
 static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
 static DEVICE_ATTR(ro, S_IRUGO, disk_ro_show, NULL);
-- 
1.5.3.2
