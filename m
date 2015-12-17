From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 2/6] block: Introduce bio_add_zero_pages()
Date: Thu, 17 Dec 2015 12:40:15 +0100
Message-ID: <56729F1F.1020701@sandisk.com>
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

Move the code for adding one or more zero pages into a new function.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
---
 block/blk-lib.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 2f4c6b2..f44ec95 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -219,6 +219,22 @@ int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 }
 EXPORT_SYMBOL(blkdev_issue_write_same);
 
+static void bio_add_zero_pages(struct bio *bio, sector_t nr_sects)
+{
+	unsigned sz;
+	int ret;
+
+	/* Avoid that bi_size overflows */
+	nr_sects = min_t(sector_t, nr_sects, UINT_MAX >> 9);
+
+	for (; nr_sects != 0; nr_sects -= ret >> 9) {
+		sz = min_t(unsigned, PAGE_SIZE >> 9, nr_sects) << 9;
+		ret = bio_add_page(bio, ZERO_PAGE(0), sz, 0);
+		if (ret < sz)
+			break;
+	}
+}
+
 /**
  * blkdev_issue_zeroout - generate number of zero filed write bios
  * @bdev:	blockdev to issue
@@ -236,7 +252,6 @@ static int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 	int ret;
 	struct bio *bio;
 	struct bio_batch bb;
-	unsigned int sz;
 	DECLARE_COMPLETION_ONSTACK(wait);
 
 	atomic_set(&bb.done, 1);
@@ -256,16 +271,9 @@ static int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 		bio->bi_bdev   = bdev;
 		bio->bi_end_io = bio_batch_end_io;
 		bio->bi_private = &bb;
-
-		while (nr_sects != 0) {
-			sz = min((sector_t) PAGE_SIZE >> 9 , nr_sects);
-			ret = bio_add_page(bio, ZERO_PAGE(0), sz << 9, 0);
-			nr_sects -= ret >> 9;
-			sector += ret >> 9;
-			if (ret < (sz << 9))
-				break;
-		}
-		ret = 0;
+		bio_add_zero_pages(bio, nr_sects);
+		nr_sects -= bio->bi_iter.bi_size >> 9;
+		sector += bio->bi_iter.bi_size >> 9;
 		atomic_inc(&bb.done);
 		submit_bio(WRITE, bio);
 	}
-- 
2.1.4
