From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] Return EROFS if read-only detected on block device
Date: Tue, 15 Feb 2011 16:16:23 +0100
Message-ID: <4D5A98C7.3070803@redhat.com>
References: <4D57E67E.1030707@redhat.com> <4D57F357.6060708@tao.ma>	<4D580A8B.5050508@redhat.com>	<20110214103026.GA18742@htj.dyndns.org>	<4D591664.6090203@redhat.com> <4D592AD1.6020500@redhat.com>	<20110214140940.GM18742@htj.dyndns.org>	<4D593AD8.7070901@redhat.com>	<20110214154430.GR18742@htj.dyndns.org>	<20110215101506.43d41ca8@notabene.brown>	<20110215020351.GD5825@agk-dp.fab.redhat.com> <4D5A6EF4.3030905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D5A6EF4.3030905@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

This allows userspace to distinguish what is going on.

EACCES is returned when user lacks required capability,
not that device is read-only.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 fs/block_dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index c9cf9f7..db2c8db 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1219,7 +1219,7 @@ int blkdev_get(struct block_device *bdev, fmode_t mode, void *holder)
 	/* __blkdev_get() may alter read only status, check it afterwards */
 	if (!res && (mode & FMODE_WRITE) && bdev_read_only(bdev)) {
 		__blkdev_put(bdev, mode, 0);
-		res = -EACCES;
+		res = -EROFS;
 	}
 
 	if (whole) {
