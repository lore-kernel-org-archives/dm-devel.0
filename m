From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2] dm-bdev-rename-suspended_bdev-to-bdev.patch
Date: Tue, 28 Apr 2009 12:14:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904281211590.22533@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This is the first patch that keeps md->bdev. Note that you must apply both 
patches, if you apply only this one, barriers will compile but don't work.

Mikulas

---

Rename suspended_bdev to bdev.

This patch doesn't change any functionality, just renames the variable.
In the next patch, the variable will be used even for non-suspended device.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

Index: linux-2.6.30-rc2-devel/drivers/md/dm.c
===================================================================
--- linux-2.6.30-rc2-devel.orig/drivers/md/dm.c	2009-04-15 16:23:23.000000000 +0200
+++ linux-2.6.30-rc2-devel/drivers/md/dm.c	2009-04-15 16:24:19.000000000 +0200
@@ -168,7 +168,7 @@ struct mapped_device {
 	 * freeze/thaw support require holding onto a super block
 	 */
 	struct super_block *frozen_sb;
-	struct block_device *suspended_bdev;
+	struct block_device *bdev;
 
 	/* forced geometry settings */
 	struct hd_geometry geometry;
@@ -1217,9 +1217,9 @@ static void free_dev(struct mapped_devic
 {
 	int minor = MINOR(disk_devt(md->disk));
 
-	if (md->suspended_bdev) {
+	if (md->bdev) {
 		unlock_fs(md);
-		bdput(md->suspended_bdev);
+		bdput(md->bdev);
 	}
 	destroy_workqueue(md->wq);
 	mempool_destroy(md->tio_pool);
@@ -1262,9 +1262,9 @@ static void __set_size(struct mapped_dev
 {
 	set_capacity(md->disk, size);
 
-	mutex_lock(&md->suspended_bdev->bd_inode->i_mutex);
-	i_size_write(md->suspended_bdev->bd_inode, (loff_t)size << SECTOR_SHIFT);
-	mutex_unlock(&md->suspended_bdev->bd_inode->i_mutex);
+	mutex_lock(&md->bdev->bd_inode->i_mutex);
+	i_size_write(md->bdev->bd_inode, (loff_t)size << SECTOR_SHIFT);
+	mutex_unlock(&md->bdev->bd_inode->i_mutex);
 }
 
 static int __bind(struct mapped_device *md, struct dm_table *t)
@@ -1280,7 +1280,7 @@ static int __bind(struct mapped_device *
 	if (size != get_capacity(md->disk))
 		memset(&md->geometry, 0, sizeof(md->geometry));
 
-	if (md->suspended_bdev)
+	if (md->bdev)
 		__set_size(md, size);
 
 	if (!size) {
@@ -1524,7 +1524,7 @@ int dm_swap_table(struct mapped_device *
 		goto out;
 
 	/* without bdev, the device size cannot be changed */
-	if (!md->suspended_bdev)
+	if (!md->bdev)
 		if (get_capacity(md->disk) != dm_table_get_size(table))
 			goto out;
 
@@ -1546,7 +1546,7 @@ static int lock_fs(struct mapped_device 
 
 	WARN_ON(md->frozen_sb);
 
-	md->frozen_sb = freeze_bdev(md->suspended_bdev);
+	md->frozen_sb = freeze_bdev(md->bdev);
 	if (IS_ERR(md->frozen_sb)) {
 		r = PTR_ERR(md->frozen_sb);
 		md->frozen_sb = NULL;
@@ -1566,7 +1566,7 @@ static void unlock_fs(struct mapped_devi
 	if (!test_bit(DMF_FROZEN, &md->flags))
 		return;
 
-	thaw_bdev(md->suspended_bdev, md->frozen_sb);
+	thaw_bdev(md->bdev, md->frozen_sb);
 	md->frozen_sb = NULL;
 	clear_bit(DMF_FROZEN, &md->flags);
 }
@@ -1606,8 +1606,8 @@ int dm_suspend(struct mapped_device *md,
 
 	/* bdget() can stall if the pending I/Os are not flushed */
 	if (!noflush) {
-		md->suspended_bdev = bdget_disk(md->disk, 0);
-		if (!md->suspended_bdev) {
+		md->bdev = bdget_disk(md->disk, 0);
+		if (!md->bdev) {
 			DMWARN("bdget failed in dm_suspend");
 			r = -ENOMEM;
 			goto out;
@@ -1678,9 +1678,9 @@ int dm_suspend(struct mapped_device *md,
 	set_bit(DMF_SUSPENDED, &md->flags);
 
 out:
-	if (r && md->suspended_bdev) {
-		bdput(md->suspended_bdev);
-		md->suspended_bdev = NULL;
+	if (r && md->bdev) {
+		bdput(md->bdev);
+		md->bdev = NULL;
 	}
 
 	dm_table_put(map);
@@ -1711,9 +1711,9 @@ int dm_resume(struct mapped_device *md)
 
 	unlock_fs(md);
 
-	if (md->suspended_bdev) {
-		bdput(md->suspended_bdev);
-		md->suspended_bdev = NULL;
+	if (md->bdev) {
+		bdput(md->bdev);
+		md->bdev = NULL;
 	}
 
 	clear_bit(DMF_SUSPENDED, &md->flags);
