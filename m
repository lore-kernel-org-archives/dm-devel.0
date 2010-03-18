From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH 2/3] Add genhd flag requesting notification of
	partition changes only.
Date: Thu, 18 Mar 2010 14:58:13 +0100
Message-ID: <1268920694-10960-2-git-send-email-mbroz@redhat.com>
References: <1268920694-10960-1-git-send-email-mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1268920694-10960-1-git-send-email-mbroz@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, kay.sievers@vrfy.org
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

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
index be48ea5..77faed3 100644
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
index 7b364d7..57da1f7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1934,6 +1934,7 @@ static struct mapped_device *alloc_dev(int minor)
 	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
 	md->disk->flags |= GENHD_FL_SUPPRESS_ADD_EVENT;
+	md->disk->flags |= GENHD_FL_PARTITION_CHANGE_NOTIFY;
 	add_disk(md->disk);
 	format_dev_t(md->name, MKDEV(_major, minor));
 
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 916173b..b66253f 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -548,6 +548,12 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
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
index ade71ff..64b25f0 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -118,6 +118,9 @@ struct hd_struct {
 #define GENHD_FL_NATIVE_CAPACITY		128
 #define GENHD_FL_SUPPRESS_ADD_EVENT		256
 
+/* notify udev instead of use in-kernel partitioning */
+#define GENHD_FL_PARTITION_CHANGE_NOTIFY	512
+
 #define BLK_SCSI_MAX_CMDS	(256)
 #define BLK_SCSI_CMD_PER_LONG	(BLK_SCSI_MAX_CMDS / (sizeof(long) * 8))
 
@@ -182,6 +185,11 @@ static inline struct gendisk *part_to_disk(struct hd_struct *part)
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
-- 
1.7.0
