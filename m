From: NeilBrown <neilb@suse.com>
Subject: [PATCH 2/2] block: trace completion of all bios.
Date: Fri, 07 Apr 2017 11:10:44 +1000
Message-ID: <149152744466.17489.12941899591178733530.stgit@noble>
References: <149152735878.17489.16036848644242802943.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <149152735878.17489.16036848644242802943.stgit@noble>
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
Cc: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Currently only dm and md/raid5 bios trigger
trace_block_bio_complete().  Now that we have bio_chain() and
bio_inc_remaining(), it is not possible, in general, for a driver to
know when the bio is really complete.  Only bio_endio() knows that.

So move the trace_block_bio_complete() call to bio_endio().

Now trace_block_bio_complete() pairs with trace_block_bio_queue().
Any bio for which a 'queue' event is traced, will subsequently
generate a 'complete' event.

There are a few cases where completion tracing is not wanted.
1/ If blk_update_request() has already generated a completion
   trace event at the 'request' level, there is no point generating
   one at the bio level too.  In this case the bi_sector and bi_size
   will have changed, so the bio level event would be wrong

2/ If the bio hasn't actually been queued yet, but is being aborted
   early, then a trace event could be confusing.  Some filesystems
   call bio_endio() but do not want tracing.

3/ The bio_integrity code interposes itself by replacing bi_end_io,
   then restoring it and calling bio_endio() again.  This would produce
   two identical trace events if left like that.

To handle these, we introduce a flag BIO_TRACE_COMPLETION and only
produce the trace event when this is set.
We address point 1 above by clearing the flag in blk_update_request().
We address point 2 above by only setting the flag when
generic_make_request() is called.
We address point 3 above by clearing the flag after generating a
completion event.

When bio_split() is used on a bio, particularly in blk_queue_split(),
there is an extra complication.  A new bio is split off the front, and
may be handle directly without going through generic_make_request().
The old bio, which has been advanced, is passed to
generic_make_request(), so it will trigger a trace event a second
time.
Probably the best result when a split happens is to see a single
'queue' event for the whole bio, then multiple 'complete' events - one
for each component.  To achieve this was can:
- copy the BIO_TRACE_COMPLETION flag to the new bio in bio_split()
- avoid generating a 'queue' event if BIO_TRACE_COMPLETION is already set.
This way, the split-off bio won't create a queue event, the original
won't either even if it re-submitted to generic_make_request(),
but both will produce completion events, each for their own range.

So if generic_make_request() is called (which generates a QUEUED
event), then bi_endio() will create a single COMPLETE event for each
range that the bio is split into, unless the driver has explicitly
requested it not to.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 block/bio.c               |   13 +++++++++++++
 block/blk-core.c          |   10 +++++++++-
 drivers/md/dm.c           |    1 -
 drivers/md/raid5.c        |    2 --
 include/linux/blk_types.h |    2 ++
 5 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 12c2837c4277..3db98fc3ee87 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1789,6 +1789,11 @@ static inline bool bio_remaining_done(struct bio *bio)
  *   bio_endio() will end I/O on the whole bio. bio_endio() is the preferred
  *   way to end I/O on a bio. No one should call bi_end_io() directly on a
  *   bio unless they own it and thus know that it has an end_io function.
+ *
+ *   bio_endio() can be called several times on a bio that has been chained
+ *   using bio_chain().  The ->bi_end_io() function will only be called the
+ *   last time.  At this point the BLK_TA_COMPLETE tracing event will be
+ *   generated if BIO_TRACE_COMPLETION is set.
  **/
 void bio_endio(struct bio *bio)
 {
@@ -1809,6 +1814,11 @@ void bio_endio(struct bio *bio)
 		goto again;
 	}
 
+	if (bio->bi_bdev && bio_flagged(bio, BIO_TRACE_COMPLETION)) {
+		trace_block_bio_complete(bdev_get_queue(bio->bi_bdev),
+					 bio, bio->bi_error);
+		bio_clear_flag(bio, BIO_TRACE_COMPLETION);
+	}
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio);
 }
@@ -1847,6 +1857,9 @@ struct bio *bio_split(struct bio *bio, int sectors,
 
 	bio_advance(bio, split->bi_iter.bi_size);
 
+	if (bio_flagged(bio, BIO_TRACE_COMPLETION))
+		bio_set_flag(bio, BIO_TRACE_COMPLETION);
+
 	return split;
 }
 EXPORT_SYMBOL(bio_split);
diff --git a/block/blk-core.c b/block/blk-core.c
index d772c221cc17..2a7993063a7e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1936,7 +1936,13 @@ generic_make_request_checks(struct bio *bio)
 	if (!blkcg_bio_issue_check(q, bio))
 		return false;
 
-	trace_block_bio_queue(q, bio);
+	if (!bio_flagged(bio, BIO_TRACE_COMPLETION)) {
+		trace_block_bio_queue(q, bio);
+		/* Now that enqueuing has been traced, we need to trace
+		 * completion as well.
+		 */
+		bio_set_flag(bio, BIO_TRACE_COMPLETION);
+	}
 	return true;
 
 not_supported:
@@ -2601,6 +2607,8 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 		if (bio_bytes == bio->bi_iter.bi_size)
 			req->bio = bio->bi_next;
 
+		/* Completion has already been traced */
+		bio_clear_flag(bio, BIO_TRACE_COMPLETION);
 		req_bio_endio(req, bio, bio_bytes, error);
 
 		total_bytes += bio_bytes;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index dfb75979e455..cd93a3b9ceca 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -810,7 +810,6 @@ static void dec_pending(struct dm_io *io, int error)
 			queue_io(md, bio);
 		} else {
 			/* done with normal IO or empty flush */
-			trace_block_bio_complete(md->queue, bio, io_error);
 			bio->bi_error = io_error;
 			bio_endio(bio);
 		}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d8bd25f235dc..14557259dd69 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5138,8 +5138,6 @@ static void raid5_align_endio(struct bio *bi)
 	rdev_dec_pending(rdev, conf->mddev);
 
 	if (!error) {
-		trace_block_bio_complete(bdev_get_queue(raid_bi->bi_bdev),
-					 raid_bi, 0);
 		bio_endio(raid_bi);
 		if (atomic_dec_and_test(&conf->active_aligned_reads))
 			wake_up(&conf->wait_for_quiescent);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index ff07d891f38f..56c2a8180ce1 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -102,6 +102,8 @@ struct bio {
 #define BIO_REFFED	8	/* bio has elevated ->bi_cnt */
 #define BIO_THROTTLED	9	/* This bio has already been subjected to
 				 * throttling rules. Don't do it again. */
+#define BIO_TRACE_COMPLETION 10	/* bio_endio() should trace the final completion
+				 * of this bio. */
 /* See BVEC_POOL_OFFSET below before adding new flags */
 
 /*
