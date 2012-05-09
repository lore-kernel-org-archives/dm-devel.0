From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-mpath: make ioctl retry and not return -EAGAIN
Date: Wed, 9 May 2012 16:20:20 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1205091619520.1272@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

dm-mpath: make ioctl retry and not return -EAGAIN

This fixes a problem where ioctl returns -EAGAIN when the system is
activating new path.

Instead of returning an error, we submit a work item to kmultipathd
(that will potentially activate the new path) and retry in ten
milliseconds.

Note that the patch doesn't retry ioctls if the ioctls itself fails due
to a path failure. This is quite dangerous --- some SCSI commands cannot
be retried because they are not idempotent (XOR write commands). For
commands that can be retried, there is a danger that if the device
rejects the SCSI command, the path could be errorneously marked as
failed, and the request would be retried on the other path which would
fail too. It can be determined if the failure happens on the device or
on the SCSI controller, but there is no guarantee that all SCSI drivers
set these flags correctly.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-mpath.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

Index: linux-3.4-rc6-fast/drivers/md/dm-mpath.c
===================================================================
--- linux-3.4-rc6-fast.orig/drivers/md/dm-mpath.c	2012-05-09 21:58:11.000000000 +0200
+++ linux-3.4-rc6-fast/drivers/md/dm-mpath.c	2012-05-09 22:01:52.000000000 +0200
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/workqueue.h>
+#include <linux/delay.h>
 #include <scsi/scsi_dh.h>
 #include <linux/atomic.h>
 
@@ -481,9 +482,6 @@ static void process_queued_ios(struct wo
 
 	spin_lock_irqsave(&m->lock, flags);
 
-	if (!m->queue_size)
-		goto out;
-
 	if (!m->current_pgpath)
 		__choose_pgpath(m, 0);
 
@@ -496,7 +494,6 @@ static void process_queued_ios(struct wo
 	if (m->pg_init_required && !m->pg_init_in_progress && pgpath)
 		__pg_init_all_paths(m);
 
-out:
 	spin_unlock_irqrestore(&m->lock, flags);
 	if (!must_queue)
 		dispatch_queued_ios(m);
@@ -1522,10 +1519,15 @@ static int multipath_ioctl(struct dm_tar
 			   unsigned long arg)
 {
 	struct multipath *m = (struct multipath *) ti->private;
-	struct block_device *bdev = NULL;
-	fmode_t mode = 0;
+	struct block_device *bdev;
+	fmode_t mode;
 	unsigned long flags;
-	int r = 0;
+	int r;
+
+again:
+	bdev = NULL;
+	mode = 0;
+	r = 0;
 
 	spin_lock_irqsave(&m->lock, flags);
 
@@ -1550,6 +1552,12 @@ static int multipath_ioctl(struct dm_tar
 	if (!r && ti->len != i_size_read(bdev->bd_inode) >> SECTOR_SHIFT)
 		r = scsi_verify_blk_ioctl(NULL, cmd);
 
+	if (r == -EAGAIN && !fatal_signal_pending(current)) {
+		queue_work(kmultipathd, &m->process_queued_ios);
+		msleep(10);
+		goto again;
+	}
+
 	return r ? : __blkdev_driver_ioctl(bdev, mode, cmd, arg);
 }
 
