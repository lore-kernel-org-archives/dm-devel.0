From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] dm: don't allow ioctls to targets that don't map to whole devices
Date: Fri,  3 Feb 2017 11:06:13 +0100
Message-ID: <20170203100613.9023-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, snitzer@redhat.com
Cc: agk@redhat.com, pbonzini@redhat.com, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

.. at least for unprivilegued users.  Before we called into the SCSI
ioctl code to allow excemptions for a few SCSI passthrough ioctls,
but this is pretty unsafe and except for this call dm knows nothing
about SCSI ioctls.  As SCSI the SCSI ioctl code is made optionally
now we really don't want to drag it in for DM, and the exception is
not very useful anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Note: this should go into the block tree, as that's where
scsi_verify_blk_ioctl becomes optional.

---
 drivers/md/dm.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9e958bc94fed..adc9dcfd5e9c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -465,13 +465,16 @@ static int dm_blk_ioctl(struct block_device *bdev, fmode_t mode,
 
 	if (r > 0) {
 		/*
-		 * Target determined this ioctl is being issued against
-		 * a logical partition of the parent bdev; so extra
-		 * validation is needed.
+		 * Target determined this ioctl is being issued against a
+		 * subset of the parent bdev; require extra privilegues.
 		 */
-		r = scsi_verify_blk_ioctl(NULL, cmd);
-		if (r)
+		if (!capable(CAP_SYS_RAWIO)) {
+			printk_ratelimited(KERN_WARNING
+				"%s: sending ioctl %x to DM device!\n",
+				current->comm, cmd);
+			r = -ENOIOCTLCMD;
 			goto out;
+		}
 	}
 
 	r =  __blkdev_driver_ioctl(bdev, mode, cmd, arg);
-- 
2.11.0

