From: Dan Williams <dan.j.williams@intel.com>
Subject: [resend PATCH v2 09/33] block: kill bdev_dax_capable()
Date: Mon, 17 Apr 2017 12:09:38 -0700
Message-ID: <149245617829.10206.728860403459694493.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, hch@lst.de
List-Id: dm-devel.ids

This is leftover dead code that has since been replaced by
bdev_dax_supported().

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/block_dev.c         |   24 ------------------------
 include/linux/blkdev.h |    1 -
 2 files changed, 25 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 2eca00ec4370..7f40ea2f0875 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -807,30 +807,6 @@ int bdev_dax_supported(struct super_block *sb, int blocksize)
 }
 EXPORT_SYMBOL_GPL(bdev_dax_supported);
 
-/**
- * bdev_dax_capable() - Return if the raw device is capable for dax
- * @bdev: The device for raw block device access
- */
-bool bdev_dax_capable(struct block_device *bdev)
-{
-	struct blk_dax_ctl dax = {
-		.size = PAGE_SIZE,
-	};
-
-	if (!IS_ENABLED(CONFIG_FS_DAX))
-		return false;
-
-	dax.sector = 0;
-	if (bdev_direct_access(bdev, &dax) < 0)
-		return false;
-
-	dax.sector = bdev->bd_part->nr_sects - (PAGE_SIZE / 512);
-	if (bdev_direct_access(bdev, &dax) < 0)
-		return false;
-
-	return true;
-}
-
 /*
  * pseudo-fs
  */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5a7da607ca04..f72708399b83 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1958,7 +1958,6 @@ extern int bdev_write_page(struct block_device *, sector_t, struct page *,
 						struct writeback_control *);
 extern long bdev_direct_access(struct block_device *, struct blk_dax_ctl *);
 extern int bdev_dax_supported(struct super_block *, int);
-extern bool bdev_dax_capable(struct block_device *);
 #else /* CONFIG_BLOCK */
 
 struct block_device;
