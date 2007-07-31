From: Diego Woitasen <diego@woitasen.com.ar>
Subject: [PATCH] remove unneded lock_kernel in drivers/md/dm.c
	and use unlocked_ioctl.
Date: Mon, 30 Jul 2007 23:23:49 -0300
Message-ID: <11858486294133-git-send-email-diego@woitasen.com.ar>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids


Signed-off-by: Diego Woitasen <diego@woitasen.com.ar>
---
 drivers/md/dm.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 141ff9f..aebb207 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -282,17 +282,16 @@ static int dm_blk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return dm_get_geometry(md, geo);
 }
 
-static int dm_blk_ioctl(struct inode *inode, struct file *file,
-			unsigned int cmd, unsigned long arg)
+static long dm_blk_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct mapped_device *md;
 	struct dm_table *map;
 	struct dm_target *tgt;
+	struct inode *inode;
 	int r = -ENOTTY;
 
-	/* We don't really need this lock, but we do need 'inode'. */
-	unlock_kernel();
 
+	inode = file->f_path.dentry->d_inode;
 	md = inode->i_bdev->bd_disk->private_data;
 
 	map = dm_get_table(md);
@@ -317,7 +316,6 @@ static int dm_blk_ioctl(struct inode *inode, struct file *file,
 out:
 	dm_table_put(map);
 
-	lock_kernel();
 	return r;
 }
 
@@ -1550,7 +1548,7 @@ EXPORT_SYMBOL_GPL(dm_noflush_suspending);
 static struct block_device_operations dm_blk_dops = {
 	.open = dm_blk_open,
 	.release = dm_blk_close,
-	.ioctl = dm_blk_ioctl,
+	.unlocked_ioctl = dm_blk_ioctl,
 	.getgeo = dm_blk_getgeo,
 	.owner = THIS_MODULE
 };
-- 
1.5.2.4
