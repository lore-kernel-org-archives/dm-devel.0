From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] handle failures in __lock_fs
Date: Thu, 10 Feb 2005 22:45:11 +0100
Message-ID: <20050210214511.GA15204@lst.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
List-Id: dm-devel.ids

I have a patch pending that allows freeze_bdev to return errors.

To handle that in DM __lock_fs need to properly unwind and it's caller
must not ignore the return value.  Detailed changelog:

 - add a new member frozen_bdev to struct mapped_device to store the
   frozen block device instead of needing a second bdget_disk in
   __unlock_fs
 - handle the possibility of freeze_bdev returning an error
 - properly unwind all state in __lockfs in case of failure
 - check __unlock_fs return value to void because it doesn't return a
   useful value
 - use gotos to properly unwind in dm_suspend
 - handle __lock_fs error return
 - use test_and_set_bit for DMF_BLOCK_IO

Question: how does dm_table_presuspend_targets need to be undone?


--- 1.62/drivers/md/dm.c	2005-02-03 16:16:04 +01:00
+++ edited/drivers/md/dm.c	2005-02-10 22:45:38 +01:00
@@ -90,6 +90,7 @@ struct mapped_device {
 	 * freeze/thaw support require holding onto a super block
 	 */
 	struct super_block *frozen_sb;
+	struct block_device *frozen_bdev;
 };
 
 #define MIN_IOS 256
@@ -975,44 +976,43 @@ int dm_swap_table(struct mapped_device *
  */
 static int __lock_fs(struct mapped_device *md)
 {
-	struct block_device *bdev;
+	int error = -ENOMEM;
 
 	if (test_and_set_bit(DMF_FS_LOCKED, &md->flags))
 		return 0;
 
-	bdev = bdget_disk(md->disk, 0);
-	if (!bdev) {
-		DMWARN("bdget failed in __lock_fs");
-		return -ENOMEM;
-	}
+	md->frozen_bdev = bdget_disk(md->disk, 0);
+	if (!md->frozen_bdev)
+		goto out;
 
 	WARN_ON(md->frozen_sb);
-	md->frozen_sb = freeze_bdev(bdev);
+	md->frozen_sb = freeze_bdev(md->frozen_bdev);
+	if (IS_ERR(md->frozen_sb)) {
+		error = PTR_ERR(md->frozen_sb);
+		goto out_bdput;
+	}
+
 	/* don't bdput right now, we don't want the bdev
 	 * to go away while it is locked.  We'll bdput
 	 * in __unlock_fs
 	 */
 	return 0;
+
+ out_bdput:
+	bdput(md->frozen_bdev);
+ out:
+	clear_bit(DMF_FS_LOCKED, &md->flags);
+	md->frozen_sb = NULL;
+	return error;
 }
 
-static int __unlock_fs(struct mapped_device *md)
+static void __unlock_fs(struct mapped_device *md)
 {
-	struct block_device *bdev;
-
-	if (!test_and_clear_bit(DMF_FS_LOCKED, &md->flags))
-		return 0;
-
-	bdev = bdget_disk(md->disk, 0);
-	if (!bdev) {
-		DMWARN("bdget failed in __unlock_fs");
-		return -ENOMEM;
+	if (test_and_clear_bit(DMF_FS_LOCKED, &md->flags)) {
+		thaw_bdev(md->frozen_bdev, md->frozen_sb);
+		bdput(md->frozen_bdev);
+		md->frozen_sb = NULL;
 	}
-
-	thaw_bdev(bdev, md->frozen_sb);
-	md->frozen_sb = NULL;
-	bdput(bdev);
-	bdput(bdev);
-	return 0;
 }
 
 /*
@@ -1026,37 +1026,41 @@ int dm_suspend(struct mapped_device *md)
 {
 	struct dm_table *map;
 	DECLARE_WAITQUEUE(wait, current);
+	int error = -EINVAL;
 
 	/* Flush I/O to the device. */
 	down_read(&md->lock);
-	if (test_bit(DMF_BLOCK_IO, &md->flags)) {
-		up_read(&md->lock);
-		return -EINVAL;
-	}
+	if (test_bit(DMF_BLOCK_IO, &md->flags))
+		goto out_read_unlock;
 
 	map = dm_get_table(md);
 	if (map)
 		dm_table_presuspend_targets(map);
-	__lock_fs(md);
+
+	error = __lock_fs(md);
+	if (error) {
+		/* XXX(hch): no need to undo dm_table_presuspend_targets? */
+		if (map)
+			dm_table_put(map);
+		goto out_read_unlock;
+	}
 
 	up_read(&md->lock);
 
 	/*
-	 * First we set the BLOCK_IO flag so no more ios will be
-	 * mapped.
+	 * First we set the BLOCK_IO flag so no more ios will be mapped.
+	 *
+	 * If the flag is already set we know another thread is trying to
+	 * suspend as well, so we leave the fs locked for this thread.
 	 */
+	error = -EINVAL;
 	down_write(&md->lock);
-	if (test_bit(DMF_BLOCK_IO, &md->flags)) {
-		/*
-		 * If we get here we know another thread is
-		 * trying to suspend as well, so we leave the fs
-		 * locked for this thread.
-		 */
-		up_write(&md->lock);
-		return -EINVAL;
+	if (test_and_set_bit(DMF_BLOCK_IO, &md->flags)) {
+		if (map)
+			dm_table_put(map);
+		goto out_write_unlock;
 	}
 
-	set_bit(DMF_BLOCK_IO, &md->flags);
 	add_wait_queue(&md->wait, &wait);
 	up_write(&md->lock);
 
@@ -1084,12 +1088,9 @@ int dm_suspend(struct mapped_device *md)
 	remove_wait_queue(&md->wait, &wait);
 
 	/* were we interrupted ? */
-	if (atomic_read(&md->pending)) {
-		__unlock_fs(md);
-		clear_bit(DMF_BLOCK_IO, &md->flags);
-		up_write(&md->lock);
-		return -EINTR;
-	}
+	error = -EINTR;
+	if (atomic_read(&md->pending))
+		goto out_unfreeze;
 
 	set_bit(DMF_SUSPENDED, &md->flags);
 
@@ -1100,6 +1101,16 @@ int dm_suspend(struct mapped_device *md)
 	up_write(&md->lock);
 
 	return 0;
+
+ out_unfreeze:
+	__unlock_fs(md);
+	clear_bit(DMF_BLOCK_IO, &md->flags);
+ out_write_unlock:
+	up_write(&md->lock);
+	return error;
+ out_read_unlock:
+	up_read(&md->lock);
+	return error;
 }
 
 int dm_resume(struct mapped_device *md)


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
