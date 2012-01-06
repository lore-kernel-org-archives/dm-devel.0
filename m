From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [RFC PATCH] Track block device users that created dirty
	pages
Date: Thu, 5 Jan 2012 19:58:34 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1201051954160.31587@hs20-bc2-1.build.redhat.com>
References: <1325632496-5524-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1325632496-5524-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com, Edward Thornber <thornber@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

Hi

This is the patch for selective flushing on block devices. Only processes 
that created some dirty data in the pagecache flush the pagecache when 
closing the device. The processes that didn't create any dirty data (for 
example lvm, when using direct io) don't flush the cache when closing the 
device.

Mikulas

---

Track block device users that created dirty pages

This patch adds a new field f_driver_flags to struct file. The field may
be used by the driver for any purpose.

Block device driver uses this field to track "file" structures that
created some dirty data in the pagecache. When such "file" structure is
closed, we flush block device cache.

This changes previously defined flush semantics.

Previously, the block device cache was flushed when the last user closed
the block device. That has various problems:
* because system tools and daemons (for example udev or lvm) can open
  any block device anytime, this semantics doesn't guarantee that flush
  happens. For example, if the user runs "dd" to copy some data to the
  partition, then udev opens the device and then "dd" finishes copying
  and closes the device, data is not flushed when "dd" exits (because
  udev still keeps the device open).
* if the last user that closes the device ends up being "lvm" process,
  it can introduce deadlocks. "lvm" would than have to flush some dirty
  data created by some other process. If writeback of these dirty data
  waits for some other operation to be performed by "lvm", we get a
  deadlock.

The new semantics is: if a process did some buffered writes to the block
device (with write or mmap), the cache is flushed when the process
closes the block device. Processes that didn't do any buffered writes to
the device don't cause cache flush. It has these advantages:
* processes that don't do buffered writes (such as "lvm") don't flush
  other process's data.
* if the user runs "dd" on a block device, it is actually guaranteed
  that the data is flushed when "dd" exits.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 fs/block_dev.c     |   18 ++++++++++++++++--
 include/linux/fs.h |    1 +
 2 files changed, 17 insertions(+), 2 deletions(-)

Index: linux-3.2-fast/include/linux/fs.h
===================================================================
--- linux-3.2-fast.orig/include/linux/fs.h	2012-01-06 00:57:58.000000000 +0100
+++ linux-3.2-fast/include/linux/fs.h	2012-01-06 00:58:42.000000000 +0100
@@ -1007,6 +1007,7 @@ struct file {
 #ifdef CONFIG_DEBUG_WRITECOUNT
 	unsigned long f_mnt_write_state;
 #endif
+	unsigned		f_driver_flags;
 };
 
 struct file_handle {
Index: linux-3.2-fast/fs/block_dev.c
===================================================================
--- linux-3.2-fast.orig/fs/block_dev.c	2012-01-06 00:57:58.000000000 +0100
+++ linux-3.2-fast/fs/block_dev.c	2012-01-06 01:41:08.000000000 +0100
@@ -324,10 +324,22 @@ static int blkdev_readpage(struct file *
 	return block_read_full_page(page, blkdev_get_block);
 }
 
+static int blkdev_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	if ((vma->vm_flags & (VM_WRITE | VM_SHARED)) == (VM_WRITE | VM_SHARED)) {
+		if (!file->f_driver_flags)
+			file->f_driver_flags = 1;
+	}
+	return generic_file_mmap(file, vma);
+}
+
 static int blkdev_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
 {
+	if (unlikely(!file->f_driver_flags))
+		file->f_driver_flags = 1;
+
 	return block_write_begin(mapping, pos, len, flags, pagep,
 				 blkdev_get_block);
 }
@@ -1429,7 +1441,6 @@ static int __blkdev_put(struct block_dev
 
 	if (!--bdev->bd_openers) {
 		WARN_ON_ONCE(bdev->bd_holders);
-		sync_blockdev(bdev);
 		kill_bdev(bdev);
 		/* ->release can cause the old bdi to disappear,
 		 * so must switch it out first
@@ -1513,6 +1524,9 @@ static int blkdev_close(struct inode * i
 {
 	struct block_device *bdev = I_BDEV(filp->f_mapping->host);
 
+	if (unlikely(filp->f_driver_flags))
+		sync_blockdev(bdev);
+
 	return blkdev_put(bdev, filp->f_mode);
 }
 
@@ -1592,7 +1606,7 @@ const struct file_operations def_blk_fop
 	.write		= do_sync_write,
   	.aio_read	= generic_file_aio_read,
 	.aio_write	= blkdev_aio_write,
-	.mmap		= generic_file_mmap,
+	.mmap		= blkdev_mmap,
 	.fsync		= blkdev_fsync,
 	.unlocked_ioctl	= block_ioctl,
 #ifdef CONFIG_COMPAT
