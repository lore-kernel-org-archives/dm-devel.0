From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] percpu-rw-semaphore: lock splice methods
Date: Wed, 3 Oct 2012 20:58:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1210032046300.7188@file.rdu.redhat.com>
References: <20120926074236.GB26028@localhost> <5062B5F9.70100@kernel.dk>
	<Pine.LNX.4.64.1209261107180.5897@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1209261107180.5897@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, kernel-janitors@vger.kernel.org
List-Id: dm-devel.ids

Hi Jens

I actually forgot to lock functions generic_file_splice_read and 
generic_file_splice_write when submitting the commit 
b87570f5d349661814b262dd5fc40787700f80d6. They must be locked too.

Please apply this.

Mikulas

---

blockdev: use rwlock for splice

A rwlock that prevents changing block size while IO is being submitted
needs to be taken around generic_file_splice_read and
generic_file_splice_write functions. These functions manipulate the page
cache directly so block size must not change under them.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 fs/block_dev.c |   37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

Index: linux-2.6-copy/fs/block_dev.c
===================================================================
--- linux-2.6-copy.orig/fs/block_dev.c	2012-10-04 02:26:01.000000000 +0200
+++ linux-2.6-copy/fs/block_dev.c	2012-10-04 02:30:37.000000000 +0200
@@ -1662,6 +1662,39 @@ static int blkdev_mmap(struct file *file
 	return ret;
 }
 
+static ssize_t blkdev_splice_read(struct file *file, loff_t *ppos,
+				  struct pipe_inode_info *pipe, size_t len,
+				  unsigned int flags)
+{
+	ssize_t ret;
+	struct block_device *bdev = I_BDEV(file->f_mapping->host);
+
+	percpu_down_read(&bdev->bd_block_size_semaphore);
+
+	ret = generic_file_splice_read(file, ppos, pipe, len, flags);
+
+	percpu_up_read(&bdev->bd_block_size_semaphore);
+
+	return ret;
+}
+
+static ssize_t blkdev_splice_write(struct pipe_inode_info *pipe,
+				   struct file *file, loff_t *ppos, size_t len,
+				   unsigned int flags)
+{
+	ssize_t ret;
+	struct block_device *bdev = I_BDEV(file->f_mapping->host);
+
+	percpu_down_read(&bdev->bd_block_size_semaphore);
+
+	ret = generic_file_splice_write(pipe, file, ppos, len, flags);
+
+	percpu_up_read(&bdev->bd_block_size_semaphore);
+
+	return ret;
+}
+
+
 /*
  * Try to release a page associated with block device when the system
  * is under memory pressure.
@@ -1700,8 +1733,8 @@ const struct file_operations def_blk_fop
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= compat_blkdev_ioctl,
 #endif
-	.splice_read	= generic_file_splice_read,
-	.splice_write	= generic_file_splice_write,
+	.splice_read	= blkdev_splice_read,
+	.splice_write	= blkdev_splice_write,
 };
 
 int ioctl_by_bdev(struct block_device *bdev, unsigned cmd, unsigned long arg)
