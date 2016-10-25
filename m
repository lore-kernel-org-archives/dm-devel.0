From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] brd: remove support for BLKFLSBUF
Date: Tue, 25 Oct 2016 10:37:19 -0400
Message-ID: <20161025143719.GA51266@redhat.com>
References: <alpine.LRH.2.02.1610211406290.9197@file01.intranet.prod.int.rdu2.redhat.com>
 <20161021200022.GA12580@redhat.com>
 <alpine.LRH.2.02.1610211616450.31606@file01.intranet.prod.int.rdu2.redhat.com>
 <20161024155756.GA48306@redhat.com>
 <20161025130712.GA12717@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161025130712.GA12717@infradead.org>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk
Cc: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Oct 25 2016 at  9:07P -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> I think the right fix is to kill off the BLKFLSBUF special case in
> brd.  Yes, it break compatibility - but in this case the compatibility
> breaks more than it helps.

Jens, please pick up this patch:

From: Mike Snitzer <snitzer@redhat.com>
Date: Tue, 25 Oct 2016 10:25:07 -0400
Subject: [PATCH] brd: remove support for BLKFLSBUF

Discontinue having the brd driver destructively free all pages in the
ramdisk in response to the BLKFLSBUF ioctl.  Doing so allows a BLKFLSBUF
ioctl issued to a logical partition to destroy pages of the parent brd
device (and all other partitions of that brd device).

This change breaks compatibility - but in this case the compatibility
breaks more than it helps.

Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/block/brd.c | 35 -----------------------------------
 1 file changed, 35 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 0c76d40..45c998a 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -395,44 +395,9 @@ static long brd_direct_access(struct block_device *bdev, sector_t sector,
 #define brd_direct_access NULL
 #endif
 
-static int brd_ioctl(struct block_device *bdev, fmode_t mode,
-			unsigned int cmd, unsigned long arg)
-{
-	int error;
-	struct brd_device *brd = bdev->bd_disk->private_data;
-
-	if (cmd != BLKFLSBUF)
-		return -ENOTTY;
-
-	/*
-	 * ram device BLKFLSBUF has special semantics, we want to actually
-	 * release and destroy the ramdisk data.
-	 */
-	mutex_lock(&brd_mutex);
-	mutex_lock(&bdev->bd_mutex);
-	error = -EBUSY;
-	if (bdev->bd_openers <= 1) {
-		/*
-		 * Kill the cache first, so it isn't written back to the
-		 * device.
-		 *
-		 * Another thread might instantiate more buffercache here,
-		 * but there is not much we can do to close that race.
-		 */
-		kill_bdev(bdev);
-		brd_free_pages(brd);
-		error = 0;
-	}
-	mutex_unlock(&bdev->bd_mutex);
-	mutex_unlock(&brd_mutex);
-
-	return error;
-}
-
 static const struct block_device_operations brd_fops = {
 	.owner =		THIS_MODULE,
 	.rw_page =		brd_rw_page,
-	.ioctl =		brd_ioctl,
 	.direct_access =	brd_direct_access,
 };
 
-- 
2.8.4 (Apple Git-73)

