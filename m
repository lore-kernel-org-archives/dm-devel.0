From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4] dm: don't allow ioctls to targets that don't map to whole devices
Date: Sat,  4 Feb 2017 10:45:03 +0100
Message-ID: <20170204094503.19322-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: snitzer@redhat.com, axboe@kernel.dk
Cc: agk@redhat.com, pbonzini@redhat.com, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

.. at least for unprivileged users.  Before we called into the SCSI
ioctl code to allow excemptions for a few SCSI passthrough ioctls,
but this is pretty unsafe and except for this call dm knows nothing
about SCSI ioctls.

As the SCSI ioctl code is now optional, we really don't want to
drag it in for DM, and the exception is not very useful anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9e958bc94fed..5bd9ab06a562 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -465,13 +465,16 @@ static int dm_blk_ioctl(struct block_device *bdev, fmode_t mode,
 
 	if (r > 0) {
 		/*
-		 * Target determined this ioctl is being issued against
-		 * a logical partition of the parent bdev; so extra
-		 * validation is needed.
+		 * Target determined this ioctl is being issued against a
+		 * subset of the parent bdev; require extra privileges.
 		 */
-		r = scsi_verify_blk_ioctl(NULL, cmd);
-		if (r)
+		if (!capable(CAP_SYS_RAWIO)) {
+			DMWARN_LIMIT(
+	"%s: sending ioctl %x to DM device without required privilege.",
+				current->comm, cmd);
+			r = -ENOIOCTLCMD;
 			goto out;
+		}
 	}
 
 	r =  __blkdev_driver_ioctl(bdev, mode, cmd, arg);
-- 
2.11.0
