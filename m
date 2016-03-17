From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 1/9] block: add block_device_operations methods to set and get reserved space
Date: Thu, 17 Mar 2016 10:30:29 -0400
Message-ID: <1458225037-24155-2-git-send-email-bfoster@redhat.com>
References: <1458225037-24155-1-git-send-email-bfoster@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1458225037-24155-1-git-send-email-bfoster@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: xfs@oss.sgi.com
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: dm-devel.ids

From: Mike Snitzer <snitzer@redhat.com>

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 fs/block_dev.c         | 20 ++++++++++++++++++++
 include/linux/blkdev.h |  5 +++++
 2 files changed, 25 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 826b164..375a2e4 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -497,6 +497,26 @@ long bdev_direct_access(struct block_device *bdev, struct blk_dax_ctl *dax)
 }
 EXPORT_SYMBOL_GPL(bdev_direct_access);
 
+int blk_reserve_space(struct block_device *bdev, sector_t nr_sects)
+{
+	const struct block_device_operations *ops = bdev->bd_disk->fops;
+
+	if (!ops->reserve_space)
+		return -EOPNOTSUPP;
+	return ops->reserve_space(bdev, nr_sects);
+}
+EXPORT_SYMBOL_GPL(blk_reserve_space);
+
+int blk_get_reserved_space(struct block_device *bdev, sector_t *nr_sects)
+{
+	const struct block_device_operations *ops = bdev->bd_disk->fops;
+
+	if (!ops->get_reserved_space)
+		return -EOPNOTSUPP;
+	return ops->get_reserved_space(bdev, nr_sects);
+}
+EXPORT_SYMBOL_GPL(blk_get_reserved_space);
+
 /*
  * pseudo-fs
  */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 413c84f..f212fe5 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1664,6 +1664,8 @@ struct block_device_operations {
 	int (*getgeo)(struct block_device *, struct hd_geometry *);
 	/* this callback is with swap_lock and sometimes page table lock held */
 	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
+	int (*reserve_space) (struct block_device *, sector_t);
+	int (*get_reserved_space) (struct block_device *, sector_t *);
 	struct module *owner;
 	const struct pr_ops *pr_ops;
 };
@@ -1674,6 +1676,9 @@ extern int bdev_read_page(struct block_device *, sector_t, struct page *);
 extern int bdev_write_page(struct block_device *, sector_t, struct page *,
 						struct writeback_control *);
 extern long bdev_direct_access(struct block_device *, struct blk_dax_ctl *);
+
+extern int blk_reserve_space(struct block_device *, sector_t);
+extern int blk_get_reserved_space(struct block_device *, sector_t *);
 #else /* CONFIG_BLOCK */
 
 struct block_device;
-- 
2.4.3

