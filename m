From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/10] block: remove the queue_bounce_pfn helper
Date: Mon, 19 Jun 2017 09:26:22 +0200
Message-ID: <20170619072628.12894-5-hch@lst.de>
References: <20170619072628.12894-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170619072628.12894-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Only used inside the bounce code, and opencoding it makes it more obvious
what is going on.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bounce.c         | 6 +++---
 include/linux/blkdev.h | 5 -----
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/block/bounce.c b/block/bounce.c
index fc79dd3e0f20..f2b4361fff81 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -203,7 +203,7 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 	bio_for_each_segment(from, *bio_orig, iter) {
 		if (i++ < BIO_MAX_PAGES)
 			sectors += from.bv_len >> 9;
-		if (page_to_pfn(from.bv_page) > queue_bounce_pfn(q))
+		if (page_to_pfn(from.bv_page) > q->limits.bounce_pfn)
 			bounce = true;
 	}
 	if (!bounce)
@@ -220,7 +220,7 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 	bio_for_each_segment_all(to, bio, i) {
 		struct page *page = to->bv_page;
 
-		if (page_to_pfn(page) <= queue_bounce_pfn(q))
+		if (page_to_pfn(page) <= q->limits.bounce_pfn)
 			continue;
 
 		to->bv_page = mempool_alloc(pool, q->bounce_gfp);
@@ -272,7 +272,7 @@ void blk_queue_bounce(struct request_queue *q, struct bio **bio_orig)
 	 * don't waste time iterating over bio segments
 	 */
 	if (!(q->bounce_gfp & GFP_DMA)) {
-		if (queue_bounce_pfn(q) >= blk_max_pfn)
+		if (q->limits.bounce_pfn >= blk_max_pfn)
 			return;
 		pool = page_pool;
 	} else {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f1a5f82a4d97..db2b7a7450bd 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1363,11 +1363,6 @@ enum blk_default_limits {
 
 #define blkdev_entry_to_request(entry) list_entry((entry), struct request, queuelist)
 
-static inline unsigned long queue_bounce_pfn(struct request_queue *q)
-{
-	return q->limits.bounce_pfn;
-}
-
 static inline unsigned long queue_segment_boundary(struct request_queue *q)
 {
 	return q->limits.seg_boundary_mask;
-- 
2.11.0
