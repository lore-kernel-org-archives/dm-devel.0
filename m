From: NeilBrown <neilb@suse.de>
Subject: [PATCH 05/24] md: split out md_rdev_init
Date: Tue, 01 Jun 2010 19:56:19 +1000
Message-ID: <20100601095619.565.77218.stgit@notabene.brown>
References: <20100601094414.565.3638.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100601094414.565.3638.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

This functionality will be needed separately in a subsequent patch, so
split it into it's own exported function.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |   34 +++++++++++++++++++---------------
 drivers/md/md.h |    1 +
 2 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2337cb2..d8e8a8c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2690,6 +2690,24 @@ static struct kobj_type rdev_ktype = {
 	.default_attrs	= rdev_default_attrs,
 };
 
+void md_rdev_init(mdk_rdev_t *rdev)
+{
+	rdev->desc_nr = -1;
+	rdev->saved_raid_disk = -1;
+	rdev->raid_disk = -1;
+	rdev->flags = 0;
+	rdev->data_offset = 0;
+	rdev->sb_events = 0;
+	rdev->last_read_error.tv_sec  = 0;
+	rdev->last_read_error.tv_nsec = 0;
+	atomic_set(&rdev->nr_pending, 0);
+	atomic_set(&rdev->read_errors, 0);
+	atomic_set(&rdev->corrected_errors, 0);
+
+	INIT_LIST_HEAD(&rdev->same_set);
+	init_waitqueue_head(&rdev->blocked_wait);
+}
+EXPORT_SYMBOL_GPL(md_rdev_init);
 /*
  * Import a device. If 'super_format' >= 0, then sanity check the superblock
  *
@@ -2713,6 +2731,7 @@ static mdk_rdev_t *md_import_device(dev_t newdev, int super_format, int super_mi
 		return ERR_PTR(-ENOMEM);
 	}
 
+	md_rdev_init(rdev);
 	if ((err = alloc_disk_sb(rdev)))
 		goto abort_free;
 
@@ -2722,18 +2741,6 @@ static mdk_rdev_t *md_import_device(dev_t newdev, int super_format, int super_mi
 
 	kobject_init(&rdev->kobj, &rdev_ktype);
 
-	rdev->desc_nr = -1;
-	rdev->saved_raid_disk = -1;
-	rdev->raid_disk = -1;
-	rdev->flags = 0;
-	rdev->data_offset = 0;
-	rdev->sb_events = 0;
-	rdev->last_read_error.tv_sec  = 0;
-	rdev->last_read_error.tv_nsec = 0;
-	atomic_set(&rdev->nr_pending, 0);
-	atomic_set(&rdev->read_errors, 0);
-	atomic_set(&rdev->corrected_errors, 0);
-
 	size = rdev->bdev->bd_inode->i_size >> BLOCK_SIZE_BITS;
 	if (!size) {
 		printk(KERN_WARNING 
@@ -2762,9 +2769,6 @@ static mdk_rdev_t *md_import_device(dev_t newdev, int super_format, int super_mi
 		}
 	}
 
-	INIT_LIST_HEAD(&rdev->same_set);
-	init_waitqueue_head(&rdev->blocked_wait);
-
 	return rdev;
 
 abort_free:
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1f680e4..a9cde80 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -484,4 +484,5 @@ extern void md_integrity_add_rdev(mdk_rdev_t *rdev, mddev_t *mddev);
 extern int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale);
 extern void restore_bitmap_write_access(struct file *file);
 
+extern void md_rdev_init(mdk_rdev_t *rdev);
 #endif /* _MD_MD_H */


