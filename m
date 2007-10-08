From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] device-mapper: fix bd_mount_sem corruption
Date: Mon, 08 Oct 2007 19:31:49 -0400
Message-ID: <470ABDE5.30200@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
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
To: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi,

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


Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2120155..998d450 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1064,12 +1064,14 @@ static struct mapped_device *alloc_dev(int minor)
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
