From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/9] block: Refactor blk_update_request()
Date: Fri,  7 Sep 2012 15:59:14 -0700
Message-ID: <1347058760-30794-4-git-send-email-koverstreet@google.com>
References: <1347058760-30794-1-git-send-email-koverstreet@google.com>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1347058760-30794-1-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
List-Id: dm-devel.ids

Converts it to use bio_advance(), simplifying it quite a bit in the
process.

Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
---
 block/blk-core.c | 84 +++++++++++---------------------------------------------
 1 file changed, 16 insertions(+), 68 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 82aab28..94cbdcc 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -153,25 +153,19 @@ EXPORT_SYMBOL(blk_rq_init);
 static void req_bio_endio(struct request *rq, struct bio *bio,
 			  unsigned int nbytes, int error)
 {
+	/*
+	 * XXX: bio_endio() does this. only need this because of the weird
+	 * flush seq thing.
+	 */
 	if (error)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = -EIO;
 
-	if (unlikely(nbytes > bio->bi_size)) {
-		printk(KERN_ERR "%s: want %u bytes done, %u left\n",
-		       __func__, nbytes, bio->bi_size);
-		nbytes = bio->bi_size;
-	}
-
 	if (unlikely(rq->cmd_flags & REQ_QUIET))
 		set_bit(BIO_QUIET, &bio->bi_flags);
 
-	bio->bi_size -= nbytes;
-	bio->bi_sector += (nbytes >> 9);
-
-	if (bio_integrity(bio))
-		bio_integrity_advance(bio, nbytes);
+	bio_advance(bio, nbytes);
 
 	/* don't actually finish bio if it's part of flush sequence */
 	if (bio->bi_size == 0 && !(rq->cmd_flags & REQ_FLUSH_SEQ))
@@ -2216,8 +2210,7 @@ EXPORT_SYMBOL(blk_fetch_request);
  **/
 bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 {
-	int total_bytes, bio_nbytes, next_idx = 0;
-	struct bio *bio;
+	int total_bytes;
 
 	if (!req->bio)
 		return false;
@@ -2261,56 +2254,21 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 
 	blk_account_io_completion(req, nr_bytes);
 
-	total_bytes = bio_nbytes = 0;
-	while ((bio = req->bio) != NULL) {
-		int nbytes;
+	total_bytes = 0;
+	while (req->bio) {
+		struct bio *bio = req->bio;
+		unsigned bio_bytes = min(bio->bi_size, nr_bytes);
 
-		if (nr_bytes >= bio->bi_size) {
+		if (bio_bytes == bio->bi_size)
 			req->bio = bio->bi_next;
-			nbytes = bio->bi_size;
-			req_bio_endio(req, bio, nbytes, error);
-			next_idx = 0;
-			bio_nbytes = 0;
-		} else {
-			int idx = bio->bi_idx + next_idx;
-
-			if (unlikely(idx >= bio->bi_vcnt)) {
-				blk_dump_rq_flags(req, "__end_that");
-				printk(KERN_ERR "%s: bio idx %d >= vcnt %d\n",
-				       __func__, idx, bio->bi_vcnt);
-				break;
-			}
-
-			nbytes = bio_iovec_idx(bio, idx)->bv_len;
-			BIO_BUG_ON(nbytes > bio->bi_size);
-
-			/*
-			 * not a complete bvec done
-			 */
-			if (unlikely(nbytes > nr_bytes)) {
-				bio_nbytes += nr_bytes;
-				total_bytes += nr_bytes;
-				break;
-			}
 
-			/*
-			 * advance to the next vector
-			 */
-			next_idx++;
-			bio_nbytes += nbytes;
-		}
+		req_bio_endio(req, bio, bio_bytes, error);
 
-		total_bytes += nbytes;
-		nr_bytes -= nbytes;
+		total_bytes += bio_bytes;
+		nr_bytes -= bio_bytes;
 
-		bio = req->bio;
-		if (bio) {
-			/*
-			 * end more in this run, or just return 'not-done'
-			 */
-			if (unlikely(nr_bytes <= 0))
-				break;
-		}
+		if (!nr_bytes)
+			break;
 	}
 
 	/*
@@ -2326,16 +2284,6 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 		return false;
 	}
 
-	/*
-	 * if the request wasn't completed, update state
-	 */
-	if (bio_nbytes) {
-		req_bio_endio(req, bio, bio_nbytes, error);
-		bio->bi_idx += next_idx;
-		bio_iovec(bio)->bv_offset += nr_bytes;
-		bio_iovec(bio)->bv_len -= nr_bytes;
-	}
-
 	req->__data_len -= total_bytes;
 	req->buffer = bio_data(req->bio);
 
-- 
1.7.12
