From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/9] block: add a new revalidate_disk_size helper
Date: Tue,  1 Sep 2020 17:57:43 +0200
Message-ID: <20200901155748.2884-5-hch@lst.de>
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

revalidate_disk is a relative awkward helper for driver use, as it first
calls an optional driver method and then updates the block device size,
while most callers either don't need the method call at all, or want to
keep state between the caller and the called method.

Add a revalidate_disk_size helper that just performs the update of the
block device size from the gendisk one, and switch all drivers that do
not implement ->revalidate_disk to use the new helper instead of
revalidate_disk()

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/rbd.c           |  2 +-
 drivers/block/rnbd/rnbd-clt.c | 10 ++-------
 drivers/block/virtio_blk.c    |  2 +-
 drivers/block/zram/zram_drv.c |  4 ++--
 drivers/md/dm-raid.c          |  2 +-
 drivers/md/md-cluster.c       |  6 ++---
 drivers/md/md-linear.c        |  2 +-
 drivers/md/md.c               | 10 ++++-----
 fs/block_dev.c                | 42 ++++++++++++++++++++++++-----------
 include/linux/genhd.h         |  1 +
 10 files changed, 46 insertions(+), 35 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 01153903969321..5d3923c0997ce0 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4921,7 +4921,7 @@ static void rbd_dev_update_size(struct rbd_device *rbd_dev)
 		size = (sector_t)rbd_dev->mapping.size / SECTOR_SIZE;
 		dout("setting size to %llu sectors", (unsigned long long)size);
 		set_capacity(rbd_dev->disk, size);
-		revalidate_disk(rbd_dev->disk);
+		revalidate_disk_size(rbd_dev->disk, true);
 	}
 }
 
diff --git a/drivers/block/rnbd/rnbd-clt.c b/drivers/block/rnbd/rnbd-clt.c
index cc6a4e2587aec2..157538fc8be515 100644
--- a/drivers/block/rnbd/rnbd-clt.c
+++ b/drivers/block/rnbd/rnbd-clt.c
@@ -102,18 +102,12 @@ static int rnbd_clt_set_dev_attr(struct rnbd_clt_dev *dev,
 static int rnbd_clt_change_capacity(struct rnbd_clt_dev *dev,
 				    size_t new_nsectors)
 {
-	int err = 0;
-
 	rnbd_clt_info(dev, "Device size changed from %zu to %zu sectors\n",
 		       dev->nsectors, new_nsectors);
 	dev->nsectors = new_nsectors;
 	set_capacity(dev->gd, dev->nsectors);
-	err = revalidate_disk(dev->gd);
-	if (err)
-		rnbd_clt_err(dev,
-			      "Failed to change device size from %zu to %zu, err: %d\n",
-			      dev->nsectors, new_nsectors, err);
-	return err;
+	revalidate_disk_size(dev->gd, true);
+	return 0;
 }
 
 static int process_msg_open_rsp(struct rnbd_clt_dev *dev,
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index ca63a41059d68e..a314b9382442b6 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -598,7 +598,7 @@ static void virtblk_update_cache_mode(struct virtio_device *vdev)
 	struct virtio_blk *vblk = vdev->priv;
 
 	blk_queue_write_cache(vblk->disk->queue, writeback, false);
-	revalidate_disk(vblk->disk);
+	revalidate_disk_size(vblk->disk, true);
 }
 
 static const char *const virtblk_cache_types[] = {
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 9100ac36670afc..a356275605b104 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1739,7 +1739,7 @@ static ssize_t disksize_store(struct device *dev,
 	zram->disksize = disksize;
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
 
-	revalidate_disk(zram->disk);
+	revalidate_disk_size(zram->disk, true);
 	up_write(&zram->init_lock);
 
 	return len;
@@ -1786,7 +1786,7 @@ static ssize_t reset_store(struct device *dev,
 	/* Make sure all the pending I/O are finished */
 	fsync_bdev(bdev);
 	zram_reset_device(zram);
-	revalidate_disk(zram->disk);
+	revalidate_disk_size(zram->disk, true);
 	bdput(bdev);
 
 	mutex_lock(&bdev->bd_mutex);
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8d2b835d7a108c..56b723d012ac15 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -701,7 +701,7 @@ static void rs_set_capacity(struct raid_set *rs)
 	struct gendisk *gendisk = dm_disk(dm_table_get_md(rs->ti->table));
 
 	set_capacity(gendisk, rs->md.array_sectors);
-	revalidate_disk(gendisk);
+	revalidate_disk_size(gendisk, true);
 }
 
 /*
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index d50737ec403946..0580b51a156a1c 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -582,7 +582,7 @@ static int process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
 		break;
 	case CHANGE_CAPACITY:
 		set_capacity(mddev->gendisk, mddev->array_sectors);
-		revalidate_disk(mddev->gendisk);
+		revalidate_disk_size(mddev->gendisk, true);
 		break;
 	case RESYNCING:
 		set_bit(MD_RESYNCING_REMOTE, &mddev->recovery);
@@ -1296,12 +1296,12 @@ static void update_size(struct mddev *mddev, sector_t old_dev_sectors)
 			pr_err("%s:%d: failed to send CHANGE_CAPACITY msg\n",
 			       __func__, __LINE__);
 		set_capacity(mddev->gendisk, mddev->array_sectors);
-		revalidate_disk(mddev->gendisk);
+		revalidate_disk_size(mddev->gendisk, true);
 	} else {
 		/* revert to previous sectors */
 		ret = mddev->pers->resize(mddev, old_dev_sectors);
 		if (!ret)
-			revalidate_disk(mddev->gendisk);
+			revalidate_disk_size(mddev->gendisk, true);
 		ret = __sendmsg(cinfo, &cmsg);
 		if (ret)
 			pr_err("%s:%d: failed to send METADATA_UPDATED msg\n",
diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index c2ae9125c4c381..5ab22069b5be9c 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -202,7 +202,7 @@ static int linear_add(struct mddev *mddev, struct md_rdev *rdev)
 	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	mddev_resume(mddev);
-	revalidate_disk(mddev->gendisk);
+	revalidate_disk_size(mddev->gendisk, true);
 	kfree_rcu(oldconf, rcu);
 	return 0;
 }
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 60727820702300..9562ef598ae1f4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5358,7 +5358,7 @@ array_size_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->array_sectors = sectors;
 		if (mddev->pers) {
 			set_capacity(mddev->gendisk, mddev->array_sectors);
-			revalidate_disk(mddev->gendisk);
+			revalidate_disk_size(mddev->gendisk, true);
 		}
 	}
 	mddev_unlock(mddev);
@@ -6109,7 +6109,7 @@ int do_md_run(struct mddev *mddev)
 	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
 
 	set_capacity(mddev->gendisk, mddev->array_sectors);
-	revalidate_disk(mddev->gendisk);
+	revalidate_disk_size(mddev->gendisk, true);
 	clear_bit(MD_NOT_READY, &mddev->flags);
 	mddev->changed = 1;
 	kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
@@ -6427,7 +6427,7 @@ static int do_md_stop(struct mddev *mddev, int mode,
 		set_capacity(disk, 0);
 		mutex_unlock(&mddev->open_mutex);
 		mddev->changed = 1;
-		revalidate_disk(disk);
+		revalidate_disk_size(disk, true);
 
 		if (mddev->ro)
 			mddev->ro = 0;
@@ -7259,7 +7259,7 @@ static int update_size(struct mddev *mddev, sector_t num_sectors)
 			md_cluster_ops->update_size(mddev, old_dev_sectors);
 		else if (mddev->queue) {
 			set_capacity(mddev->gendisk, mddev->array_sectors);
-			revalidate_disk(mddev->gendisk);
+			revalidate_disk_size(mddev->gendisk, true);
 		}
 	}
 	return rv;
@@ -9018,7 +9018,7 @@ void md_do_sync(struct md_thread *thread)
 		mddev_unlock(mddev);
 		if (!mddev_is_clustered(mddev)) {
 			set_capacity(mddev->gendisk, mddev->array_sectors);
-			revalidate_disk(mddev->gendisk);
+			revalidate_disk_size(mddev->gendisk, true);
 		}
 	}
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 0207623769715d..85f013315d48b3 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1311,6 +1311,34 @@ static void check_disk_size_change(struct gendisk *disk,
 	}
 }
 
+/**
+ * revalidate_disk_size - checks for disk size change and adjusts bdev size.
+ * @disk: struct gendisk to check
+ * @verbose: if %true log a message about a size change if there is any
+ *
+ * This routine checks to see if the bdev size does not match the disk size
+ * and adjusts it if it differs. When shrinking the bdev size, its all caches
+ * are freed.
+ */
+void revalidate_disk_size(struct gendisk *disk, bool verbose)
+{
+	struct block_device *bdev;
+
+	/*
+	 * Hidden disks don't have associated bdev so there's no point in
+	 * revalidating them.
+	 */
+	if (disk->flags & GENHD_FL_HIDDEN)
+		return;
+
+	bdev = bdget_disk(disk, 0);
+	if (bdev) {
+		check_disk_size_change(disk, bdev, verbose);
+		bdput(bdev);
+	}
+}
+EXPORT_SYMBOL(revalidate_disk_size);
+
 /**
  * revalidate_disk - wrapper for lower-level driver's revalidate_disk call-back
  * @disk: struct gendisk to be revalidated
@@ -1325,19 +1353,7 @@ int revalidate_disk(struct gendisk *disk)
 
 	if (disk->fops->revalidate_disk)
 		ret = disk->fops->revalidate_disk(disk);
-
-	/*
-	 * Hidden disks don't have associated bdev so there's no point in
-	 * revalidating it.
-	 */
-	if (!(disk->flags & GENHD_FL_HIDDEN)) {
-		struct block_device *bdev = bdget_disk(disk, 0);
-
-		if (bdev) {
-			check_disk_size_change(disk, bdev, ret == 0);
-			bdput(bdev);
-		}
-	}
+	revalidate_disk_size(disk, ret == 0);
 	return ret;
 }
 EXPORT_SYMBOL(revalidate_disk);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 39025dc0397c04..8e9c9d3a493fae 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -373,6 +373,7 @@ int register_blkdev(unsigned int major, const char *name);
 void unregister_blkdev(unsigned int major, const char *name);
 
 int revalidate_disk(struct gendisk *disk);
+void revalidate_disk_size(struct gendisk *disk, bool verbose);
 int check_disk_change(struct block_device *bdev);
 int __invalidate_device(struct block_device *bdev, bool kill_dirty);
 void bd_set_nr_sectors(struct block_device *bdev, sector_t sectors);
-- 
2.28.0
