From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 4/6] block: Make blkdev_issue_discard() submit
 aligned discard requests
Date: Thu, 17 Dec 2015 12:41:55 +0100
Message-ID: <56729F83.8040005@sandisk.com>
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

Split discard requests as follows:
* If the start sector is not aligned, an initial write request up
  to the first aligned sector.
* A discard request from the first aligned sector in the range up
  to the last aligned sector in the discarded range.
* If the end sector is not aligned, a final write request from the
  last aligned sector up to the end.

Note: if the start and/or end sectors are not aligned and if the
range is small enough the discard request will be submitted with
bi_size == 0.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
---
 block/blk-lib.c   |  4 ++--
 block/blk-merge.c | 55 ++++++++++++++++++++++++++++++-------------------------
 block/blk.h       |  3 +++
 3 files changed, 35 insertions(+), 27 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 1a60b3f..da0a744 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -30,7 +30,7 @@ static void bio_batch_end_io(struct bio *bio)
  * Return the largest number that is less than or equal to @s and for which
  * the remainder of the division by @granularity is @alignment.
  */
-static sector_t blk_round_sect_down(sector_t s, u32 granularity, u32 alignment)
+sector_t blk_round_sect_down(sector_t s, u32 granularity, u32 alignment)
 {
 	sector_t tmp = s, res = s;
 	u32 remainder;
@@ -219,7 +219,7 @@ int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 }
 EXPORT_SYMBOL(blkdev_issue_write_same);
 
-static void bio_add_zero_pages(struct bio *bio, sector_t nr_sects)
+void bio_add_zero_pages(struct bio *bio, sector_t nr_sects)
 {
 	unsigned sz;
 	int ret;
diff --git a/block/blk-merge.c b/block/blk-merge.c
index e01405a..2ce5a78 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -14,42 +14,47 @@ static struct bio *blk_bio_discard_split(struct request_queue *q,
 					 struct bio_set *bs,
 					 unsigned *nsegs)
 {
+	struct bio *wr;
 	unsigned int max_discard_sectors, granularity;
 	int alignment;
-	sector_t tmp;
-	unsigned split_sectors;
+	sector_t start, start_r, end, end_r, skip;
 
 	*nsegs = 1;
 
 	/* Zero-sector (unknown) and one-sector granularities are the same.  */
 	granularity = max(q->limits.discard_granularity >> 9, 1U);
-
+	alignment = (q->limits.discard_alignment >> 9) % granularity;
 	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
-	max_discard_sectors -= max_discard_sectors % granularity;
-
-	if (unlikely(!max_discard_sectors)) {
-		/* XXX: warn */
-		return NULL;
-	}
-
-	if (bio_sectors(bio) <= max_discard_sectors)
-		return NULL;
-
-	split_sectors = max_discard_sectors;
+	WARN_ON_ONCE(max_discard_sectors == 0);
 
 	/*
-	 * If the next starting sector would be misaligned, stop the discard at
-	 * the previous aligned sector.
+	 * If the start or end sector are misaligned, issue a write same
+	 * same request if the discard_zeroes_data flag has been set.
 	 */
-	alignment = (q->limits.discard_alignment >> 9) % granularity;
-
-	tmp = bio->bi_iter.bi_sector + split_sectors - alignment;
-	tmp = sector_div(tmp, granularity);
-
-	if (split_sectors > tmp)
-		split_sectors -= tmp;
-
-	return bio_split(bio, split_sectors, GFP_NOIO, bs);
+	start = bio->bi_iter.bi_sector;
+	start_r = blk_round_sect_down(start, granularity, alignment);
+	end = start + min(max_discard_sectors, bio_sectors(bio));
+	end_r = blk_round_sect_down(end, granularity, alignment);
+	if (start == start_r && start < end_r) {
+		if (end == end_r && bio_sectors(bio) == end_r - start)
+			return NULL;
+		return bio_split(bio, end_r - start, GFP_NOIO, bs);
+	} else if (q->limits.discard_zeroes_data) {
+		end = min(end, start_r + granularity);
+		wr = bio_alloc_bioset(GFP_NOIO, end - start, bs);
+		if (WARN_ON_ONCE(!wr))
+			return NULL;
+		wr->bi_rw = REQ_WRITE;
+		wr->bi_iter.bi_sector = start;
+		wr->bi_bdev = bio->bi_bdev;
+		bio_add_zero_pages(wr, end - start);
+		bio_advance(bio, wr->bi_iter.bi_size);
+		return wr;
+	} else {
+		skip = (min(start_r + granularity, end) - start) << 9;
+		bio_advance(bio, skip);
+		return NULL;
+	}
 }
 
 static struct bio *blk_bio_write_same_split(struct request_queue *q,
diff --git a/block/blk.h b/block/blk.h
index c43926d..e043c34 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -36,6 +36,9 @@ extern struct kmem_cache *request_cachep;
 extern struct kobj_type blk_queue_ktype;
 extern struct ida blk_queue_ida;
 
+sector_t blk_round_sect_down(sector_t s, u32 granularity, u32 alignment);
+void bio_add_zero_pages(struct bio *bio, sector_t nr_sects);
+
 static inline struct blk_flush_queue *blk_get_flush_queue(
 		struct request_queue *q, struct blk_mq_ctx *ctx)
 {
-- 
2.1.4
