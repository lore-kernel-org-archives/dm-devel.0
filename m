From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH v4 02/24] block: Refactor blk_update_request()
Date: Mon, 15 Oct 2012 13:08:36 -0700
Message-ID: <1350331769-14856-3-git-send-email-koverstreet@google.com>
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

Converts it to use bio_advance(), simplifying it quite a bit in the
process.

Note that req_bio_endio() now always calls bio_advance() - which means
it always loops over the biovec, not just on partial completions. Don't
expect it to affect performance, but worth noting.

Tested it by forcing partial updates, and dumping before and after on
various bio/bvec fields when doing a partial update.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c | 80 +++++++++-----------------------------------------------
 1 file changed, 12 insertions(+), 68 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a17869f..a8a1a9e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -158,20 +158,10 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
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
@@ -2219,8 +2209,7 @@ EXPORT_SYMBOL(blk_fetch_request);
  **/
 bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 {
-	int total_bytes, bio_nbytes, next_idx = 0;
-	struct bio *bio;
+	int total_bytes;
 
 	if (!req->bio)
 		return false;
@@ -2264,56 +2253,21 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 
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
@@ -2329,16 +2283,6 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
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
