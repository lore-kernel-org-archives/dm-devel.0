From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 8/9] nvdimm: simplify revalidate_disk handling
Date: Tue,  1 Sep 2020 17:57:47 +0200
Message-ID: <20200901155748.2884-9-hch@lst.de>
References: <20200901155748.2884-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20200901155748.2884-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>, Dan Williams <dan.j.williams@intel.com>, dm-devel@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, nbd@other.debian.org, ceph-devel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: dm-devel.ids

The nvdimm block driver abuse revalidate_disk in a strange way, and
totally unrelated to what other drivers do.  Simplify this by just
calling nvdimm_revalidate_disk (which seems rather misnamed) from the
probe routines, as the additional bdev size revalidation is pointless
at this point, and remove the revalidate_disk methods given that
it can only be triggered from add_disk, which is right before the
manual calls.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvdimm/blk.c  | 3 +--
 drivers/nvdimm/btt.c  | 3 +--
 drivers/nvdimm/bus.c  | 9 +++------
 drivers/nvdimm/nd.h   | 2 +-
 drivers/nvdimm/pmem.c | 3 +--
 5 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 1f718381a04553..22e5617b2cea14 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -226,7 +226,6 @@ static int nsblk_rw_bytes(struct nd_namespace_common *ndns,
 static const struct block_device_operations nd_blk_fops = {
 	.owner = THIS_MODULE,
 	.submit_bio =  nd_blk_submit_bio,
-	.revalidate_disk = nvdimm_revalidate_disk,
 };
 
 static void nd_blk_release_queue(void *q)
@@ -284,7 +283,7 @@ static int nsblk_attach_disk(struct nd_namespace_blk *nsblk)
 
 	set_capacity(disk, available_disk_size >> SECTOR_SHIFT);
 	device_add_disk(dev, disk, NULL);
-	revalidate_disk(disk);
+	nvdimm_check_and_set_ro(disk);
 	return 0;
 }
 
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 0ff610e728ff6f..0d710140bf93be 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1513,7 +1513,6 @@ static const struct block_device_operations btt_fops = {
 	.submit_bio =		btt_submit_bio,
 	.rw_page =		btt_rw_page,
 	.getgeo =		btt_getgeo,
-	.revalidate_disk =	nvdimm_revalidate_disk,
 };
 
 static int btt_blk_init(struct btt *btt)
@@ -1558,7 +1557,7 @@ static int btt_blk_init(struct btt *btt)
 	set_capacity(btt->btt_disk, btt->nlba * btt->sector_size >> 9);
 	device_add_disk(&btt->nd_btt->dev, btt->btt_disk, NULL);
 	btt->nd_btt->size = btt->nlba * (u64)btt->sector_size;
-	revalidate_disk(btt->btt_disk);
+	nvdimm_check_and_set_ro(btt->btt_disk);
 
 	return 0;
 }
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 955265656b96c7..2304c6183822e9 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -628,7 +628,7 @@ int __nd_driver_register(struct nd_device_driver *nd_drv, struct module *owner,
 }
 EXPORT_SYMBOL(__nd_driver_register);
 
-int nvdimm_revalidate_disk(struct gendisk *disk)
+void nvdimm_check_and_set_ro(struct gendisk *disk)
 {
 	struct device *dev = disk_to_dev(disk)->parent;
 	struct nd_region *nd_region = to_nd_region(dev->parent);
@@ -639,16 +639,13 @@ int nvdimm_revalidate_disk(struct gendisk *disk)
 	 * read-only if the disk is already read-only.
 	 */
 	if (disk_ro || nd_region->ro == disk_ro)
-		return 0;
+		return;
 
 	dev_info(dev, "%s read-only, marking %s read-only\n",
 			dev_name(&nd_region->dev), disk->disk_name);
 	set_disk_ro(disk, 1);
-
-	return 0;
-
 }
-EXPORT_SYMBOL(nvdimm_revalidate_disk);
+EXPORT_SYMBOL(nvdimm_check_and_set_ro);
 
 static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 85c1ae813ea318..72740108ba4206 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -361,7 +361,7 @@ u64 nd_region_interleave_set_altcookie(struct nd_region *nd_region);
 void nvdimm_bus_lock(struct device *dev);
 void nvdimm_bus_unlock(struct device *dev);
 bool is_nvdimm_bus_locked(struct device *dev);
-int nvdimm_revalidate_disk(struct gendisk *disk);
+void nvdimm_check_and_set_ro(struct gendisk *disk);
 void nvdimm_drvdata_release(struct kref *kref);
 void put_ndd(struct nvdimm_drvdata *ndd);
 int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd);
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index fab29b514372d0..140cf3b9000c60 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -281,7 +281,6 @@ static const struct block_device_operations pmem_fops = {
 	.owner =		THIS_MODULE,
 	.submit_bio =		pmem_submit_bio,
 	.rw_page =		pmem_rw_page,
-	.revalidate_disk =	nvdimm_revalidate_disk,
 };
 
 static int pmem_dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
@@ -501,7 +500,7 @@ static int pmem_attach_disk(struct device *dev,
 	if (devm_add_action_or_reset(dev, pmem_release_disk, pmem))
 		return -ENOMEM;
 
-	revalidate_disk(disk);
+	nvdimm_check_and_set_ro(disk);
 
 	pmem->bb_state = sysfs_get_dirent(disk_to_dev(disk)->kobj.sd,
 					  "badblocks");
-- 
2.28.0
