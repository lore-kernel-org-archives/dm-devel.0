From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/9] block: rename bd_invalidated
Date: Tue,  1 Sep 2020 17:57:42 +0200
Message-ID: <20200901155748.2884-4-hch@lst.de>
References: <20200901155748.2884-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20200901155748.2884-1-hch@lst.de>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
 <mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
 <mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Errors-To: virtualization-bounces@lists.linux-foundation.org
Sender: "Virtualization" <virtualization-bounces@lists.linux-foundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, nbd@other.debian.org, virtualization@lists.linux-foundation.org, ceph-devel@vger.kernel.org
List-Id: dm-devel.ids

Replace bd_invalidate with a new BDEV_NEED_PART_SCAN flag in a bd_flags
variable to better describe the condition.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c             |  2 +-
 drivers/block/nbd.c       |  8 ++++----
 fs/block_dev.c            | 10 +++++-----
 include/linux/blk_types.h |  4 +++-
 4 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 99c64641c3148c..a2c0ec694918e5 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -734,7 +734,7 @@ static void register_disk(struct device *parent, struct gendisk *disk,
 	if (!bdev)
 		goto exit;
 
-	bdev->bd_invalidated = 1;
+	set_bit(BDEV_NEED_PART_SCAN, &bdev->bd_flags);
 	err = blkdev_get(bdev, FMODE_READ, NULL);
 	if (err < 0)
 		goto exit;
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index a54f2d155a31a5..15eed210feeff4 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -315,7 +315,7 @@ static void nbd_size_update(struct nbd_device *nbd)
 			bd_set_nr_sectors(bdev, nr_sectors);
 			set_blocksize(bdev, config->blksize);
 		} else
-			bdev->bd_invalidated = 1;
+			set_bit(BDEV_NEED_PART_SCAN, &bdev->bd_flags);
 		bdput(bdev);
 	}
 	kobject_uevent(&nbd_to_dev(nbd)->kobj, KOBJ_CHANGE);
@@ -1322,7 +1322,7 @@ static int nbd_start_device_ioctl(struct nbd_device *nbd, struct block_device *b
 		return ret;
 
 	if (max_part)
-		bdev->bd_invalidated = 1;
+		set_bit(BDEV_NEED_PART_SCAN, &bdev->bd_flags);
 	mutex_unlock(&nbd->config_lock);
 	ret = wait_event_interruptible(config->recv_wq,
 					 atomic_read(&config->recv_threads) == 0);
@@ -1500,9 +1500,9 @@ static int nbd_open(struct block_device *bdev, fmode_t mode)
 		refcount_set(&nbd->config_refs, 1);
 		refcount_inc(&nbd->refs);
 		mutex_unlock(&nbd->config_lock);
-		bdev->bd_invalidated = 1;
+		set_bit(BDEV_NEED_PART_SCAN, &bdev->bd_flags);
 	} else if (nbd_disconnected(nbd->config)) {
-		bdev->bd_invalidated = 1;
+		set_bit(BDEV_NEED_PART_SCAN, &bdev->bd_flags);
 	}
 out:
 	mutex_unlock(&nbd_index_mutex);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 2760292045c082..0207623769715d 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -881,7 +881,7 @@ struct block_device *bdget(dev_t dev)
 		bdev->bd_super = NULL;
 		bdev->bd_inode = inode;
 		bdev->bd_part_count = 0;
-		bdev->bd_invalidated = 0;
+		bdev->bd_flags = 0;
 		inode->i_mode = S_IFBLK;
 		inode->i_rdev = dev;
 		inode->i_bdev = bdev;
@@ -1365,7 +1365,7 @@ int check_disk_change(struct block_device *bdev)
 	if (__invalidate_device(bdev, true))
 		pr_warn("VFS: busy inodes on changed media %s\n",
 			disk->disk_name);
-	bdev->bd_invalidated = 1;
+	set_bit(BDEV_NEED_PART_SCAN, &bdev->bd_flags);
 	if (bdops->revalidate_disk)
 		bdops->revalidate_disk(bdev->bd_disk);
 	return 1;
@@ -1390,7 +1390,7 @@ int bdev_disk_changed(struct block_device *bdev, bool invalidate)
 
 	lockdep_assert_held(&bdev->bd_mutex);
 
-	bdev->bd_invalidated = 0;
+	clear_bit(BDEV_NEED_PART_SCAN, &bdev->bd_flags);
 
 rescan:
 	ret = blk_drop_partitions(bdev);
@@ -1528,7 +1528,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, void *holder,
 			 * The latter is necessary to prevent ghost
 			 * partitions on a removed medium.
 			 */
-			if (bdev->bd_invalidated &&
+			if (test_bit(BDEV_NEED_PART_SCAN, &bdev->bd_flags) &&
 			    (!ret || ret == -ENOMEDIUM))
 				bdev_disk_changed(bdev, ret == -ENOMEDIUM);
 
@@ -1558,7 +1558,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, void *holder,
 			if (bdev->bd_disk->fops->open)
 				ret = bdev->bd_disk->fops->open(bdev, mode);
 			/* the same as first opener case, read comment there */
-			if (bdev->bd_invalidated &&
+			if (test_bit(BDEV_NEED_PART_SCAN, &bdev->bd_flags) &&
 			    (!ret || ret == -ENOMEDIUM))
 				bdev_disk_changed(bdev, ret == -ENOMEDIUM);
 			if (ret)
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 63a39e47fc6047..c21eff7efda237 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -19,6 +19,8 @@ struct cgroup_subsys_state;
 typedef void (bio_end_io_t) (struct bio *);
 struct bio_crypt_ctx;
 
+#define BDEV_NEED_PART_SCAN		0
+
 struct block_device {
 	dev_t			bd_dev;  /* not a kdev_t - it's a search key */
 	int			bd_openers;
@@ -37,7 +39,7 @@ struct block_device {
 	struct hd_struct *	bd_part;
 	/* number of times partitions within this device have been opened. */
 	unsigned		bd_part_count;
-	int			bd_invalidated;
+	unsigned long		bd_flags;
 	spinlock_t		bd_size_lock; /* for bd_inode->i_size updates */
 	struct gendisk *	bd_disk;
 	struct backing_dev_info *bd_bdi;
-- 
2.28.0
