From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/7] fs: use gendisk->disk_name where possible
Date: Tue, 31 Mar 2015 20:01:16 +0400
Message-ID: <1427817681-4494-3-git-send-email-dmonakhov@openvz.org>
References: <1427817681-4494-1-git-send-email-dmonakhov@openvz.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1427817681-4494-1-git-send-email-dmonakhov@openvz.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>, viro@zeniv.linux.org.uk
List-Id: dm-devel.ids

gendisk with part==0 is obviously gendisk->disk_name.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/block_dev.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 2e522ae..ec43814 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1013,12 +1013,9 @@ EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
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
@@ -1042,12 +1039,9 @@ void check_disk_size_change(struct gendisk *disk, struct block_device *bdev)
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
