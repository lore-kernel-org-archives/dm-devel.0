From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 9/9] block: remove revalidate_disk()
Date: Tue,  1 Sep 2020 17:57:48 +0200
Message-ID: <20200901155748.2884-10-hch@lst.de>
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

Remove the now unused helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.h       |  2 +-
 fs/block_dev.c        | 19 -------------------
 include/linux/genhd.h |  1 -
 3 files changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index d9c4e6b7e9398d..f9e2ccdd22c478 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -397,7 +397,7 @@ struct mddev {
 	 * These locks are separate due to conflicting interactions
 	 * with bdev->bd_mutex.
 	 * Lock ordering is:
-	 *  reconfig_mutex -> bd_mutex : e.g. do_md_run -> revalidate_disk
+	 *  reconfig_mutex -> bd_mutex
 	 *  bd_mutex -> open_mutex:  e.g. __blkdev_get -> md_open
 	 */
 	struct mutex			open_mutex;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 85f013315d48b3..0771836d0220bd 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1339,25 +1339,6 @@ void revalidate_disk_size(struct gendisk *disk, bool verbose)
 }
 EXPORT_SYMBOL(revalidate_disk_size);
 
-/**
- * revalidate_disk - wrapper for lower-level driver's revalidate_disk call-back
- * @disk: struct gendisk to be revalidated
- *
- * This routine is a wrapper for lower-level driver's revalidate_disk
- * call-backs.  It is used to do common pre and post operations needed
- * for all revalidate_disk operations.
- */
-int revalidate_disk(struct gendisk *disk)
-{
-	int ret = 0;
-
-	if (disk->fops->revalidate_disk)
-		ret = disk->fops->revalidate_disk(disk);
-	revalidate_disk_size(disk, ret == 0);
-	return ret;
-}
-EXPORT_SYMBOL(revalidate_disk);
-
 /*
  * This routine checks whether a removable media has been changed,
  * and invalidates all buffer-cache-entries in that case. This
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index c340b392452ce6..2cdc41a3fb6a57 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -372,7 +372,6 @@ extern void blk_unregister_region(dev_t devt, unsigned long range);
 int register_blkdev(unsigned int major, const char *name);
 void unregister_blkdev(unsigned int major, const char *name);
 
-int revalidate_disk(struct gendisk *disk);
 void revalidate_disk_size(struct gendisk *disk, bool verbose);
 int check_disk_change(struct block_device *bdev);
 int __invalidate_device(struct block_device *bdev, bool kill_dirty);
-- 
2.28.0
