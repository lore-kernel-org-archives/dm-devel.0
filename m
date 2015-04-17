From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/7] fs: use gendisk->disk_name where possible
Date: Fri, 17 Apr 2015 12:29:13 +0400
Message-ID: <1429259359-13480-2-git-send-email-dmonakhov@openvz.org>
References: <1429259359-13480-1-git-send-email-dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1429259359-13480-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, axboe@kernel.dk, viro@zeniv.linux.org.uk, dm-devel@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>
List-Id: dm-devel.ids

gendisk with part==0 is obviously gendisk->disk_name.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/block_dev.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index c7e4163..874a8d1 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1012,12 +1012,9 @@ EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
 static void flush_disk(struct block_device *bdev, bool kill_dirty)
 {
 	if (__invalidate_device(bdev, kill_dirty)) {
-		char name[BDEVNAME_SIZE] = "";
-
-		if (bdev->bd_disk)
-			disk_name(bdev->bd_disk, 0, name);
 		printk(KERN_WARNING "VFS: busy inodes on changed media or "
-		       "resized disk %s\n", name);
+		       "resized disk %s\n",
+		       bdev->bd_disk ? bdev->bd_disk->disk_name : "");
 	}
 
 	if (!bdev->bd_disk)
@@ -1041,12 +1038,9 @@ void check_disk_size_change(struct gendisk *disk, struct block_device *bdev)
 	disk_size = (loff_t)get_capacity(disk) << 9;
 	bdev_size = i_size_read(bdev->bd_inode);
 	if (disk_size != bdev_size) {
-		char name[BDEVNAME_SIZE];
-
-		disk_name(disk, 0, name);
 		printk(KERN_INFO
 		       "%s: detected capacity change from %lld to %lld\n",
-		       name, bdev_size, disk_size);
+		       disk->disk_name, bdev_size, disk_size);
 		i_size_write(bdev->bd_inode, disk_size);
 		flush_disk(bdev, false);
 	}
-- 
1.7.1

