From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] block: make discard killable
Date: Tue, 3 Jul 2018 13:35:49 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1807031334400.22443@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

Discarding can take very long time for some device mapper targets, this
patch makes it possible to kill a process that issues the BLKDISCARD
ioctl.

Note that some filesystems call blkdev_issue_discard or
__blkdev_issue_discard directly, they may not be prepared to handle the
failure, so this patch introduces a flag BLKDEV_DISCARD_KILLABLE that is
only set when the discard is initiated by an ioctl.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/blk-lib.c        |   13 +++++++++++--
 block/ioctl.c          |    4 ++--
 include/linux/blkdev.h |    1 +
 3 files changed, 14 insertions(+), 4 deletions(-)

Index: linux-2.6/block/blk-lib.c
===================================================================
--- linux-2.6.orig/block/blk-lib.c	2018-06-29 20:10:55.540000000 +0200
+++ linux-2.6/block/blk-lib.c	2018-06-29 23:12:24.520000000 +0200
@@ -7,6 +7,7 @@
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/scatterlist.h>
+#include <linux/sched/signal.h>
 
 #include "blk.h"
 
@@ -33,6 +34,7 @@ int __blkdev_issue_discard(struct block_
 	unsigned int op;
 	int alignment;
 	sector_t bs_mask;
+	int r;
 
 	if (!q)
 		return -ENXIO;
@@ -68,8 +70,10 @@ int __blkdev_issue_discard(struct block_
 		 */
 		req_sects = min_t(sector_t, nr_sects,
 					q->limits.max_discard_sectors);
-		if (!req_sects)
+		if (!req_sects) {
+			r = -EOPNOTSUPP;
 			goto fail;
+		}
 		if (req_sects > UINT_MAX >> 9)
 			req_sects = UINT_MAX >> 9;
 
@@ -96,6 +100,11 @@ int __blkdev_issue_discard(struct block_
 		nr_sects -= req_sects;
 		sector = end_sect;
 
+		if (flags & BLKDEV_DISCARD_KILLABLE && fatal_signal_pending(current)) {
+			r = -EINTR;
+			goto fail;
+		}
+
 		/*
 		 * We can loop for a long time in here, if someone does
 		 * full device discards (like mkfs). Be nice and allow
@@ -114,7 +123,7 @@ fail:
 		bio_put(bio);
 	}
 	*biop = NULL;
-	return -EOPNOTSUPP;
+	return r;
 }
 EXPORT_SYMBOL(__blkdev_issue_discard);
 
Index: linux-2.6/block/ioctl.c
===================================================================
--- linux-2.6.orig/block/ioctl.c	2018-05-31 18:04:38.068000000 +0200
+++ linux-2.6/block/ioctl.c	2018-06-29 23:06:07.180000000 +0200
@@ -522,10 +522,10 @@ int blkdev_ioctl(struct block_device *bd
 	case BLKROSET:
 		return blkdev_roset(bdev, mode, cmd, arg);
 	case BLKDISCARD:
-		return blk_ioctl_discard(bdev, mode, arg, 0);
+		return blk_ioctl_discard(bdev, mode, arg, BLKDEV_DISCARD_KILLABLE);
 	case BLKSECDISCARD:
 		return blk_ioctl_discard(bdev, mode, arg,
-				BLKDEV_DISCARD_SECURE);
+				BLKDEV_DISCARD_SECURE | BLKDEV_DISCARD_KILLABLE);
 	case BLKZEROOUT:
 		return blk_ioctl_zeroout(bdev, mode, arg);
 	case BLKREPORTZONE:
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2018-06-18 01:09:22.040000000 +0200
+++ linux-2.6/include/linux/blkdev.h	2018-06-29 23:09:50.010000000 +0200
@@ -1390,6 +1390,7 @@ extern int blkdev_issue_write_same(struc
 		sector_t nr_sects, gfp_t gfp_mask, struct page *page);
 
 #define BLKDEV_DISCARD_SECURE	(1 << 0)	/* issue a secure erase */
+#define BLKDEV_DISCARD_KILLABLE	(1 << 1)	/* allow killing the process */
 
 extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
