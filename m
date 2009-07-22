From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/2] Add genhd flag requesting notification of
 partition changes only.
Date: Wed, 22 Jul 2009 12:17:47 +0200
Message-ID: <4A66E74B.7080805@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040103020900020206060004"
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------040103020900020206060004
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Resend patch 1/2; seems to be stuck in the mailqueue somewhere.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

--------------040103020900020206060004
Content-Type: text/x-patch;
	name="Add-genhd-flag-requesting-notification-of-partition.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename*0="Add-genhd-flag-requesting-notification-of-partition.patch"

From 1aeec7a3141af62456576baf16978738c7bf4152 Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Wed, 22 Jul 2009 08:18:18 +0200
Subject: [PATCH 1/2] Add genhd flag requesting notification of partition changes only.

This patch provides notification mechanism which allows handle partition
code in userspace.

If the BLKRRPART ioctl arrives and GENHD_FL_USERSPACE_PARTITIONS
is set, just send uevent and ignore in-kernel partitioning code.

This is useful e.g. for device-mapper devices, which can use kpartx
or similar tool in udev rules.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/ioctl.c         |    3 ++-
 drivers/md/dm.c       |    1 +
 fs/partitions/check.c |    7 +++++++
 include/linux/genhd.h |    8 ++++++++
 4 files changed, 18 insertions(+), 1 deletions(-)

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
index 3c6d4ee..df3332d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1791,6 +1791,7 @@ static struct mapped_device *alloc_dev(int minor)
 	md->disk->queue = md->queue;
 	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
+	md->disk->flags |= GENHD_FL_USERSPACE_PARTITIONS;
 	add_disk(md->disk);
 	format_dev_t(md->name, MKDEV(_major, minor));
 
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 1a9c787..01f97dd 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -536,6 +536,13 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 		disk->fops->revalidate_disk(disk);
 	check_disk_size_change(disk, bdev);
 	bdev->bd_invalidated = 0;
+
+	/* partitions handled in userspace, just send change event */
+	if (disk_userspace_partitions(disk)) {
+		kobject_uevent(&disk_to_dev(disk)->kobj, KOBJ_CHANGE);
+		return 0;
+	}
+
 	if (!get_capacity(disk) || !(state = check_partition(disk, bdev)))
 		return 0;
 	if (IS_ERR(state))	/* I/O error reading the partition table */
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 45fc320..a5ee079 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -116,6 +116,9 @@ struct hd_struct {
 #define GENHD_FL_EXT_DEVT			64 /* allow extended devt */
 #define GENHD_FL_NATIVE_CAPACITY		128
 
+/* notify udev instead of use in-kernel partitioning */
+#define GENHD_FL_USERSPACE_PARTITIONS		256
+
 #define BLK_SCSI_MAX_CMDS	(256)
 #define BLK_SCSI_CMD_PER_LONG	(BLK_SCSI_MAX_CMDS / (sizeof(long) * 8))
 
@@ -180,6 +183,11 @@ static inline struct gendisk *part_to_disk(struct hd_struct *part)
 	return NULL;
 }
 
+static inline bool disk_userspace_partitions(struct gendisk *disk)
+{
+	return (disk->flags & GENHD_FL_USERSPACE_PARTITIONS) ? 1 : 0;
+}
+
 static inline int disk_max_parts(struct gendisk *disk)
 {
 	if (disk->flags & GENHD_FL_EXT_DEVT)
-- 
1.5.3.2


--------------040103020900020206060004
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------040103020900020206060004--
