From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 03/26] block: Refactor blk_update_request()
Date: Thu, 20 Sep 2012 16:50:16 -0700
Message-ID: <20120920235016.GG5519@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-4-git-send-email-koverstreet@google.com>
 <20120920232000.GG7264@google.com>
 <20120920233632.GC5519@google.com>
 <20120920234133.GM7264@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120920234133.GM7264-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On Thu, Sep 20, 2012 at 04:41:33PM -0700, Tejun Heo wrote:
> Hey,
> 
> On Thu, Sep 20, 2012 at 04:36:32PM -0700, Kent Overstreet wrote:
> > > Other than that, I definitely like this.  It would be nice to note
> > > that the custom partial bio advancing in blk_update_request() is
> > > replaced with multiple calls to req_bio_endio().  I don't think it has
> > > any meaningful performance implications.  It's just nice to future
> > > readers of the commit.
> > 
> > The number of calls to req_bio_endio() isn't changing...
> > blk_update_request() called it for partial completions before. It's just
> > where the bio itself is updated that's getting shuffled around.
> >
> > Or did you mean that bio_advance() is getting called on every bio
> > instead of the custom advancing in blk_update_request() before? That is
> > different, yeah - it's now always looping over the iovec, not just for
> > partial completions.
> > 
> > Yeah, I will note that in the commit message, in case Jens sees a
> > performance regression from it :)
> 
> I don't think there's any performance implication.  It's just nice to
> explain how the complexity went away.  If for nothing else, to point
> out how silly the original code was. :)

New patch below - that commit message have what you're after?

> > > Also, it would be really nice if you can verify this actually works
> > > with partial blk_update_request().  sector update bug in the previous
> > > patch scares me a bit.  Implementing some debug hacks in the
> > > completion path might be the easiest way to verify.  A subtle bug here
> > > could be pretty painful.
> > 
> > Any suggestions on how to trigger partial updates?
> 
> ide along with many legacy drivers do it.  Any SCSI driver including
> libata only does full completion.  I don't know.  Even just trying to
> call the function and comparing before & after with the original code
> would be good.  I'd like to see at least some form of verification
> because the manifested bugs could be extremely nasty and difficult to
> track down.

Multiple partial completions should have the same semantics as a single
full completion, so maybe I'll try rigging up some test code that wraps
blk_update_request(), turning full completions into partial completions,
and verifies stuff...


commit fef0ddc82214f87de71ec6fb051eb28a6de0be74
Author: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Date:   Thu Sep 20 16:38:30 2012 -0700

    block: Refactor blk_update_request()
    
    Converts it to use bio_advance(), simplifying it quite a bit in the
    process.
    
    Note that req_bio_endio() now always calls bio_advance() - which means
    it always loops over the biovec, not just on partial completions. Don't
    expect it to affect performance, but worth noting.
    
    Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
    CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

diff --git a/block/blk-core.c b/block/blk-core.c
index 2d739ca..9f8cb16 100644
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
@@ -2214,8 +2204,7 @@ EXPORT_SYMBOL(blk_fetch_request);
  **/
 bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 {
-	int total_bytes, bio_nbytes, next_idx = 0;
-	struct bio *bio;
+	int total_bytes;
 
 	if (!req->bio)
 		return false;
@@ -2259,56 +2248,21 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 
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
@@ -2324,16 +2278,6 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
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
 
