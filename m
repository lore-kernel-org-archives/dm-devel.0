From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] block: replace bd_set_size with bd_set_nr_sectors
Date: Fri, 21 Aug 2020 10:55:59 +0200
Message-ID: <20200821085600.2395666-2-hch@lst.de>
References: <20200821085600.2395666-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200821085600.2395666-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Justin Sanders <justin@coraid.com>, Josef Bacik <josef@toxicpanda.com>, Xianting Tian <xianting_tian@126.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Stefan Haberland <sth@linux.ibm.com>, Jan Hoeppner <hoeppner@linux.ibm.com>, linux-kernel@vger.kernel.org, nbd@other.debian.org, linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org
List-Id: dm-devel.ids

Replace bd_set_size with a version that takes the number of sectors
instead, as that fits most of the current and future callers much better.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/loop.c     |  4 ++--
 drivers/block/nbd.c      |  7 ++++---
 drivers/block/pktcdvd.c  |  2 +-
 drivers/nvme/host/nvme.h |  2 +-
 fs/block_dev.c           | 10 +++++-----
 include/linux/genhd.h    |  2 +-
 6 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 2f137d6ce169d5..7069899a94903e 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -253,7 +253,7 @@ static void loop_set_size(struct loop_device *lo, loff_t size)
 {
 	struct block_device *bdev = lo->lo_device;
 
-	bd_set_size(bdev, size << SECTOR_SHIFT);
+	bd_set_nr_sectors(bdev, size);
 
 	set_capacity_revalidate_and_notify(lo->lo_disk, size, false);
 }
@@ -1248,7 +1248,7 @@ static int __loop_clr_fd(struct loop_device *lo, bool release)
 	set_capacity(lo->lo_disk, 0);
 	loop_sysfs_exit(lo);
 	if (bdev) {
-		bd_set_size(bdev, 0);
+		bd_set_nr_sectors(bdev, 0);
 		/* let user-space know about this change */
 		kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
 	}
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 3ff4054d6834d2..f07243335472a4 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -300,6 +300,7 @@ static void nbd_size_update(struct nbd_device *nbd)
 {
 	struct nbd_config *config = nbd->config;
 	struct block_device *bdev = bdget_disk(nbd->disk, 0);
+	sector_t nr_sectors = config->bytesize >> 9;
 
 	if (config->flags & NBD_FLAG_SEND_TRIM) {
 		nbd->disk->queue->limits.discard_granularity = config->blksize;
@@ -308,10 +309,10 @@ static void nbd_size_update(struct nbd_device *nbd)
 	}
 	blk_queue_logical_block_size(nbd->disk->queue, config->blksize);
 	blk_queue_physical_block_size(nbd->disk->queue, config->blksize);
-	set_capacity(nbd->disk, config->bytesize >> 9);
+	set_capacity(nbd->disk, nr_sectors);
 	if (bdev) {
 		if (bdev->bd_disk) {
-			bd_set_size(bdev, config->bytesize);
+			bd_set_nr_sectors(bdev, nr_sectors);
 			set_blocksize(bdev, config->blksize);
 		} else
 			bdev->bd_invalidated = 1;
@@ -1138,7 +1139,7 @@ static void nbd_bdev_reset(struct block_device *bdev)
 {
 	if (bdev->bd_openers > 1)
 		return;
-	bd_set_size(bdev, 0);
+	bd_set_nr_sectors(bdev, 0);
 }
 
 static void nbd_parse_flags(struct nbd_device *nbd)
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 4becc1efe775fc..015fe128fa8a35 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2192,7 +2192,7 @@ static int pkt_open_dev(struct pktcdvd_device *pd, fmode_t write)
 
 	set_capacity(pd->disk, lba << 2);
 	set_capacity(pd->bdev->bd_disk, lba << 2);
-	bd_set_size(pd->bdev, (loff_t)lba << 11);
+	bd_set_nr_sectors(pd->bdev, lba << 2);
 
 	q = bdev_get_queue(pd->bdev);
 	if (write) {
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index ebb8c3ed388554..ae5cad5a08f411 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -664,7 +664,7 @@ static inline void nvme_mpath_update_disk_size(struct gendisk *disk)
 	struct block_device *bdev = bdget_disk(disk, 0);
 
 	if (bdev) {
-		bd_set_size(bdev, get_capacity(disk) << SECTOR_SHIFT);
+		bd_set_nr_sectors(bdev, get_capacity(disk));
 		bdput(bdev);
 	}
 }
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 8ae833e004439b..f52597172c8b79 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1371,13 +1371,13 @@ int check_disk_change(struct block_device *bdev)
 
 EXPORT_SYMBOL(check_disk_change);
 
-void bd_set_size(struct block_device *bdev, loff_t size)
+void bd_set_nr_sectors(struct block_device *bdev, sector_t sectors)
 {
 	inode_lock(bdev->bd_inode);
-	i_size_write(bdev->bd_inode, size);
+	i_size_write(bdev->bd_inode, (loff_t)sectors << SECTOR_SHIFT);
 	inode_unlock(bdev->bd_inode);
 }
-EXPORT_SYMBOL(bd_set_size);
+EXPORT_SYMBOL(bd_set_nr_sectors);
 
 static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part);
 
@@ -1514,7 +1514,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, void *holder,
 			}
 
 			if (!ret) {
-				bd_set_size(bdev,(loff_t)get_capacity(disk)<<9);
+				bd_set_nr_sectors(bdev, get_capacity(disk));
 				set_init_blocksize(bdev);
 			}
 
@@ -1542,7 +1542,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, void *holder,
 				ret = -ENXIO;
 				goto out_clear;
 			}
-			bd_set_size(bdev, (loff_t)bdev->bd_part->nr_sects << 9);
+			bd_set_nr_sectors(bdev, bdev->bd_part->nr_sects);
 			set_init_blocksize(bdev);
 		}
 
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 4ab853461dff25..39025dc0397c04 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -375,7 +375,7 @@ void unregister_blkdev(unsigned int major, const char *name);
 int revalidate_disk(struct gendisk *disk);
 int check_disk_change(struct block_device *bdev);
 int __invalidate_device(struct block_device *bdev, bool kill_dirty);
-void bd_set_size(struct block_device *bdev, loff_t size);
+void bd_set_nr_sectors(struct block_device *bdev, sector_t sectors);
 
 /* for drivers/char/raw.c: */
 int blkdev_ioctl(struct block_device *, fmode_t, unsigned, unsigned long);
-- 
2.28.0
