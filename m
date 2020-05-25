From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/16] nvdimm: use bio_{start,end}_io_acct
Date: Mon, 25 May 2020 13:30:05 +0200
Message-ID: <20200525113014.345997-8-hch@lst.de>
References: <20200525113014.345997-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200525113014.345997-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, dm-devel@redhat.com, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Switch dm to use the nicer bio accounting helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvdimm/blk.c  |  6 ++++--
 drivers/nvdimm/btt.c  |  6 ++++--
 drivers/nvdimm/nd.h   | 19 -------------------
 drivers/nvdimm/pmem.c |  6 ++++--
 4 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 43751fab9d36a..036e23aef9b04 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -178,7 +178,9 @@ static blk_qc_t nd_blk_make_request(struct request_queue *q, struct bio *bio)
 	bip = bio_integrity(bio);
 	nsblk = q->queuedata;
 	rw = bio_data_dir(bio);
-	do_acct = nd_iostat_start(bio, &start);
+	do_acct = blk_queue_io_stat(bio->bi_disk->queue);
+	if (do_acct)
+		start = bio_start_io_acct(bio);
 	bio_for_each_segment(bvec, bio, iter) {
 		unsigned int len = bvec.bv_len;
 
@@ -195,7 +197,7 @@ static blk_qc_t nd_blk_make_request(struct request_queue *q, struct bio *bio)
 		}
 	}
 	if (do_acct)
-		nd_iostat_end(bio, start);
+		bio_end_io_acct(bio, start);
 
 	bio_endio(bio);
 	return BLK_QC_T_NONE;
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 3b09419218d6f..90c0c4bbe77b9 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1452,7 +1452,9 @@ static blk_qc_t btt_make_request(struct request_queue *q, struct bio *bio)
 	if (!bio_integrity_prep(bio))
 		return BLK_QC_T_NONE;
 
-	do_acct = nd_iostat_start(bio, &start);
+	do_acct = blk_queue_io_stat(bio->bi_disk->queue);
+	if (do_acct)
+		start = bio_start_io_acct(bio);
 	bio_for_each_segment(bvec, bio, iter) {
 		unsigned int len = bvec.bv_len;
 
@@ -1477,7 +1479,7 @@ static blk_qc_t btt_make_request(struct request_queue *q, struct bio *bio)
 		}
 	}
 	if (do_acct)
-		nd_iostat_end(bio, start);
+		bio_end_io_acct(bio, start);
 
 	bio_endio(bio);
 	return BLK_QC_T_NONE;
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 85dbb2a322b9b..85c1ae813ea31 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -396,25 +396,6 @@ static inline int nvdimm_setup_pfn(struct nd_pfn *nd_pfn,
 #endif
 int nd_blk_region_init(struct nd_region *nd_region);
 int nd_region_activate(struct nd_region *nd_region);
-void __nd_iostat_start(struct bio *bio, unsigned long *start);
-static inline bool nd_iostat_start(struct bio *bio, unsigned long *start)
-{
-	struct gendisk *disk = bio->bi_disk;
-
-	if (!blk_queue_io_stat(disk->queue))
-		return false;
-
-	*start = jiffies;
-	generic_start_io_acct(disk->queue, bio_op(bio), bio_sectors(bio),
-			      &disk->part0);
-	return true;
-}
-static inline void nd_iostat_end(struct bio *bio, unsigned long start)
-{
-	struct gendisk *disk = bio->bi_disk;
-
-	generic_end_io_acct(disk->queue, bio_op(bio), &disk->part0, start);
-}
 static inline bool is_bad_pmem(struct badblocks *bb, sector_t sector,
 		unsigned int len)
 {
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 2df6994acf836..97f948f8f4e62 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -202,7 +202,9 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 	if (bio->bi_opf & REQ_PREFLUSH)
 		ret = nvdimm_flush(nd_region, bio);
 
-	do_acct = nd_iostat_start(bio, &start);
+	do_acct = blk_queue_io_stat(bio->bi_disk->queue);
+	if (do_acct)
+		start = bio_start_io_acct(bio);
 	bio_for_each_segment(bvec, bio, iter) {
 		if (op_is_write(bio_op(bio)))
 			rc = pmem_do_write(pmem, bvec.bv_page, bvec.bv_offset,
@@ -216,7 +218,7 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 		}
 	}
 	if (do_acct)
-		nd_iostat_end(bio, start);
+		bio_end_io_acct(bio, start);
 
 	if (bio->bi_opf & REQ_FUA)
 		ret = nvdimm_flush(nd_region, bio);
-- 
2.26.2
