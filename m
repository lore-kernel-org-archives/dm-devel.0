From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/16] zram: nvdimm: use bio_{start,end}_io_acct and disk_{start,end}_io_acct
Date: Wed, 27 May 2020 07:24:11 +0200
Message-ID: <20200527052419.403583-9-hch@lst.de>
References: <20200527052419.403583-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20200527052419.403583-1-hch@lst.de>
Sender: linux-bcache-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, dm-devel@redhat.com, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Switch zram to use the nicer bio accounting helpers, and as part of that
ensure each bio is counted as a single I/O request.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 drivers/block/zram/zram_drv.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index ebb234f36909c..6e2ad90b17a37 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1510,13 +1510,8 @@ static void zram_bio_discard(struct zram *zram, u32 index,
 static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 			int offset, unsigned int op, struct bio *bio)
 {
-	unsigned long start_time = jiffies;
-	struct request_queue *q = zram->disk->queue;
 	int ret;
 
-	generic_start_io_acct(q, op, bvec->bv_len >> SECTOR_SHIFT,
-			&zram->disk->part0);
-
 	if (!op_is_write(op)) {
 		atomic64_inc(&zram->stats.num_reads);
 		ret = zram_bvec_read(zram, bvec, index, offset, bio);
@@ -1526,8 +1521,6 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 		ret = zram_bvec_write(zram, bvec, index, offset, bio);
 	}
 
-	generic_end_io_acct(q, op, &zram->disk->part0, start_time);
-
 	zram_slot_lock(zram, index);
 	zram_accessed(zram, index);
 	zram_slot_unlock(zram, index);
@@ -1548,6 +1541,7 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
 	u32 index;
 	struct bio_vec bvec;
 	struct bvec_iter iter;
+	unsigned long start_time;
 
 	index = bio->bi_iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
 	offset = (bio->bi_iter.bi_sector &
@@ -1563,6 +1557,7 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
 		break;
 	}
 
+	start_time = bio_start_io_acct(bio);
 	bio_for_each_segment(bvec, bio, iter) {
 		struct bio_vec bv = bvec;
 		unsigned int unwritten = bvec.bv_len;
@@ -1571,8 +1566,10 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
 			bv.bv_len = min_t(unsigned int, PAGE_SIZE - offset,
 							unwritten);
 			if (zram_bvec_rw(zram, &bv, index, offset,
-					 bio_op(bio), bio) < 0)
-				goto out;
+					 bio_op(bio), bio) < 0) {
+				bio->bi_status = BLK_STS_IOERR;
+				break;
+			}
 
 			bv.bv_offset += bv.bv_len;
 			unwritten -= bv.bv_len;
@@ -1580,12 +1577,8 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
 			update_position(&index, &offset, &bv);
 		} while (unwritten);
 	}
-
+	bio_end_io_acct(bio, start_time);
 	bio_endio(bio);
-	return;
-
-out:
-	bio_io_error(bio);
 }
 
 /*
@@ -1633,6 +1626,7 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
 	u32 index;
 	struct zram *zram;
 	struct bio_vec bv;
+	unsigned long start_time;
 
 	if (PageTransHuge(page))
 		return -ENOTSUPP;
@@ -1651,7 +1645,9 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
 	bv.bv_len = PAGE_SIZE;
 	bv.bv_offset = 0;
 
+	start_time = disk_start_io_acct(bdev->bd_disk, SECTORS_PER_PAGE, op);
 	ret = zram_bvec_rw(zram, &bv, index, offset, op, NULL);
+	disk_end_io_acct(bdev->bd_disk, op, start_time);
 out:
 	/*
 	 * If I/O fails, just return error(ie, non-zero) without
-- 
2.26.2
