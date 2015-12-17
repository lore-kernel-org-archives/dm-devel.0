From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 3/6] block: Optimize __blkdev_issue_zeroout()
Date: Thu, 17 Dec 2015 12:41:01 +0100
Message-ID: <56729F4D.5060105@sandisk.com>
References: <56729ECF.50906@sandisk.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <56729ECF.50906@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@fb.com>
Cc: Jan Kara <jack@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Dmitry Monakhov <dmonakhov@openvz.org>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

Avoid to confuse SCSI target software by ensuring that the WRITE SAME
data buffer length matches the block size.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
---
 block/blk-lib.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index f44ec95..1a60b3f 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -249,7 +249,9 @@ static void bio_add_zero_pages(struct bio *bio, sector_t nr_sects)
 static int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 				  sector_t nr_sects, gfp_t gfp_mask)
 {
-	int ret;
+	int ret = 0;
+	struct request_queue *q = bdev_get_queue(bdev);
+	unsigned req_sects;
 	struct bio *bio;
 	struct bio_batch bb;
 	DECLARE_COMPLETION_ONSTACK(wait);
@@ -258,7 +260,6 @@ static int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 	bb.error = 0;
 	bb.wait = &wait;
 
-	ret = 0;
 	while (nr_sects != 0) {
 		bio = bio_alloc(gfp_mask,
 				min(nr_sects, (sector_t)BIO_MAX_PAGES));
@@ -271,9 +272,11 @@ static int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 		bio->bi_bdev   = bdev;
 		bio->bi_end_io = bio_batch_end_io;
 		bio->bi_private = &bb;
-		bio_add_zero_pages(bio, nr_sects);
-		nr_sects -= bio->bi_iter.bi_size >> 9;
-		sector += bio->bi_iter.bi_size >> 9;
+		bio_add_zero_pages(bio, q->limits.logical_block_size);
+		req_sects = min_t(sector_t, nr_sects, UINT_MAX >> 9);
+		bio->bi_iter.bi_size = req_sects << 9;
+		nr_sects -= req_sects;
+		sector += req_sects;
 		atomic_inc(&bb.done);
 		submit_bio(WRITE, bio);
 	}
-- 
2.1.4
