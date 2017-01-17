From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch] block: add blktrace C events for bio-based drivers
Date: Tue, 17 Jan 2017 16:57:45 -0500
Message-ID: <x49ziips61y.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: axboe@kernel.dk, linux-block@vger.kernel.org
Cc: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, shli@kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de
List-Id: dm-devel.ids

Only a few bio-based drivers actually generate blktrace completion
(C) events.  Instead of changing all bio-based drivers to call
trace_block_bio_complete, move the tracing to bio_complete, and remove
the explicit tracing from the few drivers that actually do it.  After
this patch, there is exactly one caller of trace_block_bio_complete
and one caller of trace_block_rq_complete.  More importantly, all
bio-based drivers now generate C events, which is useful for
performance analysis.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---

Testing: I made sure that request-based drivers don't see duplicate
completions, and that bio-based drivers show both Q and C events.  I
haven't tested all affected drivers or combinations, though.

diff --git a/block/bio.c b/block/bio.c
index 2b37502..ba5daad 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1785,16 +1785,7 @@ static inline bool bio_remaining_done(struct bio *bio)
 	return false;
 }
 
-/**
- * bio_endio - end I/O on a bio
- * @bio:	bio
- *
- * Description:
- *   bio_endio() will end I/O on the whole bio. bio_endio() is the preferred
- *   way to end I/O on a bio. No one should call bi_end_io() directly on a
- *   bio unless they own it and thus know that it has an end_io function.
- **/
-void bio_endio(struct bio *bio)
+void __bio_endio(struct bio *bio)
 {
 again:
 	if (!bio_remaining_done(bio))
@@ -1816,6 +1807,22 @@ void bio_endio(struct bio *bio)
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio);
 }
+
+/**
+ * bio_endio - end I/O on a bio
+ * @bio:	bio
+ *
+ * Description:
+ *   bio_endio() will end I/O on the whole bio. bio_endio() is the preferred
+ *   way to end I/O on a bio. No one should call bi_end_io() directly on a
+ *   bio unless they own it and thus know that it has an end_io function.
+ **/
+void bio_endio(struct bio *bio)
+{
+	trace_block_bio_complete(bdev_get_queue(bio->bi_bdev),
+				 bio, bio->bi_error);
+	__bio_endio(bio);
+}
 EXPORT_SYMBOL(bio_endio);
 
 /**
diff --git a/block/blk-core.c b/block/blk-core.c
index 61ba08c..f77f2d9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -153,7 +153,7 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 
 	/* don't actually finish bio if it's part of flush sequence */
 	if (bio->bi_iter.bi_size == 0 && !(rq->rq_flags & RQF_FLUSH_SEQ))
-		bio_endio(bio);
+		__bio_endio(bio);
 }
 
 void blk_dump_rq_flags(struct request *rq, char *msg)
@@ -1947,7 +1947,7 @@ generic_make_request_checks(struct bio *bio)
 	err = -EOPNOTSUPP;
 end_io:
 	bio->bi_error = err;
-	bio_endio(bio);
+	__bio_endio(bio);
 	return false;
 }
 
diff --git a/block/blk.h b/block/blk.h
index 041185e..1c9b50a 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -57,6 +57,7 @@ int blk_init_rl(struct request_list *rl, struct request_queue *q,
 		gfp_t gfp_mask);
 void blk_exit_rl(struct request_list *rl);
 void init_request_from_bio(struct request *req, struct bio *bio);
+void __bio_endio(struct bio *bio);
 void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 			struct bio *bio);
 void blk_queue_bypass_start(struct request_queue *q);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3086da5..e151aef 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -807,7 +807,6 @@ static void dec_pending(struct dm_io *io, int error)
 			queue_io(md, bio);
 		} else {
 			/* done with normal IO or empty flush */
-			trace_block_bio_complete(md->queue, bio, io_error);
 			bio->bi_error = io_error;
 			bio_endio(bio);
 		}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 36c13e4..17b4e06 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -159,8 +159,6 @@ static void return_io(struct bio_list *return_bi)
 	struct bio *bi;
 	while ((bi = bio_list_pop(return_bi)) != NULL) {
 		bi->bi_iter.bi_size = 0;
-		trace_block_bio_complete(bdev_get_queue(bi->bi_bdev),
-					 bi, 0);
 		bio_endio(bi);
 	}
 }
@@ -4902,8 +4900,6 @@ static void raid5_align_endio(struct bio *bi)
 	rdev_dec_pending(rdev, conf->mddev);
 
 	if (!error) {
-		trace_block_bio_complete(bdev_get_queue(raid_bi->bi_bdev),
-					 raid_bi, 0);
 		bio_endio(raid_bi);
 		if (atomic_dec_and_test(&conf->active_aligned_reads))
 			wake_up(&conf->wait_for_quiescent);
@@ -5470,8 +5466,6 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
 		if ( rw == WRITE )
 			md_write_end(mddev);
 
-		trace_block_bio_complete(bdev_get_queue(bi->bi_bdev),
-					 bi, 0);
 		bio_endio(bi);
 	}
 }
@@ -5878,11 +5872,9 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
 		handled++;
 	}
 	remaining = raid5_dec_bi_active_stripes(raid_bio);
-	if (remaining == 0) {
-		trace_block_bio_complete(bdev_get_queue(raid_bio->bi_bdev),
-					 raid_bio, 0);
+	if (remaining == 0)
 		bio_endio(raid_bio);
-	}
+
 	if (atomic_dec_and_test(&conf->active_aligned_reads))
 		wake_up(&conf->wait_for_quiescent);
 	return handled;
