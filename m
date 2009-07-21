From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH][RFC] Emulate BLKRRPART on device-mapper
Date: Tue, 21 Jul 2009 18:13:06 +0200
Message-ID: <4A65E912.6020706@redhat.com>
References: <200907081414.50698.knikanth@suse.de>
	<20090720182324.GD32330@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090720182324.GD32330@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>, Alasdair G Kergon <agk@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

Alasdair G Kergon wrote:
> On Wed, Jul 08, 2009 at 02:14:50PM +0530, Nikanth Karthikesan wrote:
>   
>> From: Hannes Reinecke <hare@suse.de>
>> Subject: Emulate BLKRRPART on device-mapper
>>
>> Partitions on device-mapper devices are managed by kpartx (if at
>> all). So if we were just to send out a 'change' event if someone
>> called BLKRRPART on these devices, kpartx will be triggered via udev
>> and can manage the partitions accordingly.
>>
>>     
> Please could I have a 'Tested-by' for this one?
>   
I am afraid that this patch cannot work, BLRRPART never reach this code.
I tried another idea - or is there better way how to achieve that?

Milan
---

From: Milan Broz <mbroz@redhat.com>

Add genhd flag requesting notification of partition changes only.

This patch provides notification mechanism which allows handle partition
code in userspace.

If the BLKRRPART ioctl arrives and GENHD_FL_PARTITION_CHANGE_NOTIFY
is set, just send uevent and ignore in-kernel partitioning code.

This is useful e.g. for device-mapper devices, which can use kpartx
or similar tool in udev rules.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 block/ioctl.c         |    3 ++-
 drivers/md/dm.c       |    1 +
 fs/partitions/check.c |    6 ++++++
 include/linux/genhd.h |    8 ++++++++
 4 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 500e4c7..bce793f 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -101,7 +101,8 @@ static int blkdev_reread_part(struct block_device *bdev)
 	struct gendisk *disk = bdev->bd_disk;
 	int res;
 
-	if (!disk_partitionable(disk) || bdev != bdev->bd_contains)
+	if (!disk_userspace_partitions(disk) &&
+	    (!disk_partitionable(disk) || bdev != bdev->bd_contains))
 		return -EINVAL;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9acd54a..1186ce1 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1791,6 +1791,7 @@ static struct mapped_device *alloc_dev(int minor)
 	md->disk->queue = md->queue;
 	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
+	md->disk->flags |= GENHD_FL_PARTITION_CHANGE_NOTIFY;
 	add_disk(md->disk);
 	format_dev_t(md->name, MKDEV(_major, minor));
 
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index ea4e6cb..bb42c44 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -521,6 +521,12 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 	struct parsed_partitions *state;
 	int p, highest, res;
 
+	/* partitions handled in userspace, just send change event */
+	if (disk_userspace_partitions(disk)) {
+		kobject_uevent(&disk_to_dev(disk)->kobj, KOBJ_CHANGE);
+		return 0;
+	}
+
 	if (bdev->bd_part_count)
 		return -EBUSY;
 	res = invalidate_partition(disk, 0);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 45fc320..a241bd6 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -116,6 +116,9 @@ struct hd_struct {
 #define GENHD_FL_EXT_DEVT			64 /* allow extended devt */
 #define GENHD_FL_NATIVE_CAPACITY		128
 
+/* notify udev instead of use in-kernel partitioning */
+#define GENHD_FL_PARTITION_CHANGE_NOTIFY	256
+
 #define BLK_SCSI_MAX_CMDS	(256)
 #define BLK_SCSI_CMD_PER_LONG	(BLK_SCSI_MAX_CMDS / (sizeof(long) * 8))
 
@@ -180,6 +183,11 @@ static inline struct gendisk *part_to_disk(struct hd_struct *part)
 	return NULL;
 }
 
+static inline bool disk_userspace_partitions(struct gendisk *disk)
+{
+	return (disk->flags & GENHD_FL_PARTITION_CHANGE_NOTIFY) ? 1 : 0;
+}
+
 static inline int disk_max_parts(struct gendisk *disk)
 {
 	if (disk->flags & GENHD_FL_EXT_DEVT)
