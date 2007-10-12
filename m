From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 08/25] dm: fix thaw_bdev
Date: Fri, 12 Oct 2007 18:15:25 +0100
Message-ID: <20071012171525.GS24157@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761710AbXJLRQP@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, stable@kernel.org
List-Id: dm-devel.ids

From: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

This patch fixes a bd_mount_sem counter corruption bug in device-mapper.

thaw_bdev() should be called only when freeze_bdev() was called for the
device.
Otherwise, thaw_bdev() will up bd_mount_sem and corrupt the semaphore counter.
struct block_device with the corrupted semaphore may remain in slab cache
and be reused later.

Attached patch will fix it by calling unlock_fs() instead.
unlock_fs() will determine whether it should call thaw_bdev()
by checking the device is frozen or not.

Easy reproducer is:
  #!/bin/sh
  while [ 1 ]; do
     dmsetup --notable create a
     dmsetup --nolockfs suspend a
     dmsetup remove a
  done

It's not easy to see the effect of corrupted semaphore.
So I have tested with putting printk below in bdev_alloc_inode():
        if (atomic_read(&ei->bdev.bd_mount_sem.count) != 1)
                printk(KERN_DEBUG "Incorrect semaphore count = %d (%p)\n",
                        atomic_read(&ei->bdev.bd_mount_sem.count),
                        &ei->bdev);

Without the patch, I saw something like:
 Incorrect semaphore count = 17 (f2ab91c0)

With the patch, the message didn't appear.

The bug was introduced in 2.6.16 with this bug fix:

commit d9dde59ba03095e526640988c0fedd75e93bc8b7
Date:   Fri Feb 24 13:04:24 2006 -0800

    [PATCH] dm: missing bdput/thaw_bdev at removal
    
    Need to unfreeze and release bdev otherwise the bdev inode with
    inconsistent state is reused later and cause problem.
    
and backported to 2.6.15.5.

It occurs only in free_dev(), which is called only when the dm device is
removed.  The buggy code is executed only if md->suspended_bdev is
non-NULL and that can happen only when the device was suspended without
noflush.

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: stable@kernel.org

---
 drivers/md/dm.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.23/drivers/md/dm.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm.c	2007-10-12 13:14:40.000000000 +0100
+++ linux-2.6.23/drivers/md/dm.c	2007-10-12 13:15:35.000000000 +0100
@@ -1060,12 +1060,14 @@ static struct mapped_device *alloc_dev(i
 	return NULL;
 }
 
+static void unlock_fs(struct mapped_device *md);
+
 static void free_dev(struct mapped_device *md)
 {
 	int minor = md->disk->first_minor;
 
 	if (md->suspended_bdev) {
-		thaw_bdev(md->suspended_bdev, NULL);
+		unlock_fs(md);
 		bdput(md->suspended_bdev);
 	}
 	mempool_destroy(md->tio_pool);
