From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH v4 18/24] bounce: Refactor __blk_queue_bounce to
	not use bi_io_vec
Date: Mon, 15 Oct 2012 13:08:52 -0700
Message-ID: <1350331769-14856-19-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: tj@kernel.org, axboe@kernel.dk, Kent Overstreet <koverstreet@google.com>, vgoyal@redhat.com
List-Id: dm-devel.ids

A bunch of what __blk_queue_bounce() was doing was problematic for the
immutable bvec work; this cleans that up and the code is quite a bit
smaller, too.

The __bio_for_each_segment() in copy_to_high_bio_irq() was changed
because that one's looping over the original bio, not the bounce bio -
a later patch renames __bio_for_each_segment() ->
bio_for_each_segment_all(), and documents that
bio_for_each_segment_all() is only for code that owns the bio.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
---
 mm/bounce.c | 73 ++++++++++++++++---------------------------------------------
 1 file changed, 19 insertions(+), 54 deletions(-)

diff --git a/mm/bounce.c b/mm/bounce.c
index 0420867..3068300 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -101,7 +101,7 @@ static void copy_to_high_bio_irq(struct bio *to, struct bio *from)
 	struct bio_vec *tovec, *fromvec;
 	int i;
 
-	__bio_for_each_segment(tovec, to, i, 0) {
+	bio_for_each_segment(tovec, to, i) {
 		fromvec = from->bi_io_vec + i;
 
 		/*
@@ -181,78 +181,43 @@ static void bounce_end_io_read_isa(struct bio *bio, int err)
 static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 			       mempool_t *pool)
 {
-	struct page *page;
-	struct bio *bio = NULL;
-	int i, rw = bio_data_dir(*bio_orig);
+	struct bio *bio;
+	int rw = bio_data_dir(*bio_orig);
 	struct bio_vec *to, *from;
+	unsigned i;
 
-	bio_for_each_segment(from, *bio_orig, i) {
-		page = from->bv_page;
+	bio_for_each_segment(from, *bio_orig, i)
+		if (page_to_pfn(from->bv_page) > queue_bounce_pfn(q))
+			goto bounce;
 
-		/*
-		 * is destination page below bounce pfn?
-		 */
-		if (page_to_pfn(page) <= queue_bounce_pfn(q))
-			continue;
-
-		/*
-		 * irk, bounce it
-		 */
-		if (!bio) {
-			unsigned int cnt = (*bio_orig)->bi_vcnt;
+	return;
+bounce:
+	bio = bio_clone_bioset(*bio_orig, GFP_NOIO, fs_bio_set);
 
-			bio = bio_alloc(GFP_NOIO, cnt);
-			memset(bio->bi_io_vec, 0, cnt * sizeof(struct bio_vec));
-		}
-			
+	bio_for_each_segment(to, bio, i) {
+		struct page *page = to->bv_page;
 
-		to = bio->bi_io_vec + i;
+		if (page_to_pfn(page) <= queue_bounce_pfn(q))
+			continue;
 
-		to->bv_page = mempool_alloc(pool, q->bounce_gfp);
-		to->bv_len = from->bv_len;
-		to->bv_offset = from->bv_offset;
 		inc_zone_page_state(to->bv_page, NR_BOUNCE);
+		to->bv_page = mempool_alloc(pool, q->bounce_gfp);
 
 		if (rw == WRITE) {
 			char *vto, *vfrom;
 
-			flush_dcache_page(from->bv_page);
+			flush_dcache_page(page);
+
 			vto = page_address(to->bv_page) + to->bv_offset;
-			vfrom = kmap(from->bv_page) + from->bv_offset;
+			vfrom = kmap_atomic(page) + to->bv_offset;
 			memcpy(vto, vfrom, to->bv_len);
-			kunmap(from->bv_page);
+			kunmap_atomic(vfrom);
 		}
 	}
 
-	/*
-	 * no pages bounced
-	 */
-	if (!bio)
-		return;
-
 	trace_block_bio_bounce(q, *bio_orig);
 
-	/*
-	 * at least one page was bounced, fill in possible non-highmem
-	 * pages
-	 */
-	__bio_for_each_segment(from, *bio_orig, i, 0) {
-		to = bio_iovec_idx(bio, i);
-		if (!to->bv_page) {
-			to->bv_page = from->bv_page;
-			to->bv_len = from->bv_len;
-			to->bv_offset = from->bv_offset;
-		}
-	}
-
-	bio->bi_bdev = (*bio_orig)->bi_bdev;
 	bio->bi_flags |= (1 << BIO_BOUNCED);
-	bio->bi_sector = (*bio_orig)->bi_sector;
-	bio->bi_rw = (*bio_orig)->bi_rw;
-
-	bio->bi_vcnt = (*bio_orig)->bi_vcnt;
-	bio->bi_idx = (*bio_orig)->bi_idx;
-	bio->bi_size = (*bio_orig)->bi_size;
 
 	if (pool == page_pool) {
 		bio->bi_end_io = bounce_end_io_write;
-- 
1.7.12
