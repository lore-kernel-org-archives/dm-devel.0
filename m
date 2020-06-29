From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/20] block: remove the NULL queue check in
	generic_make_request_checks
Date: Mon, 29 Jun 2020 21:39:41 +0200
Message-ID: <20200629193947.2705954-15-hch@lst.de>
References: <20200629193947.2705954-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200629193947.2705954-1-hch@lst.de>
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
Cc: linux-bcache@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-m68k@vger.kernel.org, linux-nvdimm@lists.01.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, drbd-dev@tron.linbit.com, linuxppc-dev@lists.ozlabs.org
List-Id: dm-devel.ids

All registers disks must have a valid queue pointer, so don't bother to
log a warning for that case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 95dca74534ff73..37435d0d433564 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -973,22 +973,12 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
 static noinline_for_stack bool
 generic_make_request_checks(struct bio *bio)
 {
-	struct request_queue *q;
+	struct request_queue *q = bio->bi_disk->queue;
 	int nr_sectors = bio_sectors(bio);
 	blk_status_t status = BLK_STS_IOERR;
-	char b[BDEVNAME_SIZE];
 
 	might_sleep();
 
-	q = bio->bi_disk->queue;
-	if (unlikely(!q)) {
-		printk(KERN_ERR
-		       "generic_make_request: Trying to access "
-			"nonexistent block-device %s (%Lu)\n",
-			bio_devname(bio, b), (long long)bio->bi_iter.bi_sector);
-		goto end_io;
-	}
-
 	/*
 	 * For a REQ_NOWAIT based request, return -EOPNOTSUPP
 	 * if queue is not a request based queue.
-- 
2.26.2
