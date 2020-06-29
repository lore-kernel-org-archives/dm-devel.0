From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 01/11] block: blktrace framework cleanup
Date: Mon, 29 Jun 2020 16:43:04 -0700
Message-ID: <20200629234314.10509-2-chaitanya.kulkarni@wdc.com>
References: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, dm-devel@redhat.com
Cc: jack@suse.czi, rdunlap@infradead.org, sagi@grimberg.me, mingo@redhat.com, rostedt@goodmis.org, snitzer@redhat.com, agk@redhat.com, axboe@kernel.dk, paolo.valente@linaro.org, ming.lei@redhat.com, bvanassche@acm.org, fangguoju@gmail.com, colyli@suse.de, hch@lst.de, Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
List-Id: dm-devel.ids

This patch removes the extra variables from the trace events and
overall kernel blktrace framework. The removed members can easily be
extracted from the remaining argument which reduces the code
significantly and allows us to optimize the several tracepoints like
the next patch in the series.      

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 block/blk-core.c             |  6 +--
 block/blk-merge.c            |  4 +-
 block/blk-mq-sched.c         |  2 +-
 block/blk-mq.c               | 10 ++--
 block/bounce.c               |  2 +-
 drivers/md/dm.c              |  4 +-
 include/trace/events/block.h | 87 +++++++++++++-------------------
 kernel/trace/blktrace.c      | 98 ++++++++++++++++++------------------
 8 files changed, 98 insertions(+), 115 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 72b102a389a5..6d4c57ef4533 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -674,7 +674,7 @@ bool bio_attempt_back_merge(struct request *req, struct bio *bio,
 	if (!ll_back_merge_fn(req, bio, nr_segs))
 		return false;
 
-	trace_block_bio_backmerge(req->q, req, bio);
+	trace_block_bio_backmerge(bio);
 	rq_qos_merge(req->q, req, bio);
 
 	if ((req->cmd_flags & REQ_FAILFAST_MASK) != ff)
@@ -698,7 +698,7 @@ bool bio_attempt_front_merge(struct request *req, struct bio *bio,
 	if (!ll_front_merge_fn(req, bio, nr_segs))
 		return false;
 
-	trace_block_bio_frontmerge(req->q, req, bio);
+	trace_block_bio_frontmerge(bio);
 	rq_qos_merge(req->q, req, bio);
 
 	if ((req->cmd_flags & REQ_FAILFAST_MASK) != ff)
@@ -1082,7 +1082,7 @@ generic_make_request_checks(struct bio *bio)
 		return false;
 
 	if (!bio_flagged(bio, BIO_TRACE_COMPLETION)) {
-		trace_block_bio_queue(q, bio);
+		trace_block_bio_queue(bio);
 		/* Now that enqueuing has been traced, we need to trace
 		 * completion as well.
 		 */
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 9c9fb21584b6..8333ccd60ee1 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -337,7 +337,7 @@ void __blk_queue_split(struct request_queue *q, struct bio **bio,
 		split->bi_opf |= REQ_NOMERGE;
 
 		bio_chain(split, *bio);
-		trace_block_split(q, split, (*bio)->bi_iter.bi_sector);
+		trace_block_split(split, (*bio)->bi_iter.bi_sector);
 		generic_make_request(*bio);
 		*bio = split;
 	}
@@ -793,7 +793,7 @@ static struct request *attempt_merge(struct request_queue *q,
 	 */
 	blk_account_io_merge_request(next);
 
-	trace_block_rq_merge(q, next);
+	trace_block_rq_merge(next);
 
 	/*
 	 * ownership of bio passed from next to req, return 'next' for
diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index fdcc2c1dd178..a3cade16ef80 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -409,7 +409,7 @@ EXPORT_SYMBOL_GPL(blk_mq_sched_try_insert_merge);
 
 void blk_mq_sched_request_inserted(struct request *rq)
 {
-	trace_block_rq_insert(rq->q, rq);
+	trace_block_rq_insert(rq);
 }
 EXPORT_SYMBOL_GPL(blk_mq_sched_request_inserted);
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index b8738b3c6d06..dbb98b2bc868 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -742,7 +742,7 @@ void blk_mq_start_request(struct request *rq)
 {
 	struct request_queue *q = rq->q;
 
-	trace_block_rq_issue(q, rq);
+	trace_block_rq_issue(rq);
 
 	if (test_bit(QUEUE_FLAG_STATS, &q->queue_flags)) {
 		rq->io_start_time_ns = ktime_get_ns();
@@ -769,7 +769,7 @@ static void __blk_mq_requeue_request(struct request *rq)
 
 	blk_mq_put_driver_tag(rq);
 
-	trace_block_rq_requeue(q, rq);
+	trace_block_rq_requeue(rq);
 	rq_qos_requeue(q, rq);
 
 	if (blk_mq_request_started(rq)) {
@@ -1758,7 +1758,7 @@ static inline void __blk_mq_insert_req_list(struct blk_mq_hw_ctx *hctx,
 
 	lockdep_assert_held(&ctx->lock);
 
-	trace_block_rq_insert(hctx->queue, rq);
+	trace_block_rq_insert(rq);
 
 	if (at_head)
 		list_add(&rq->queuelist, &ctx->rq_lists[type]);
@@ -1814,7 +1814,7 @@ void blk_mq_insert_requests(struct blk_mq_hw_ctx *hctx, struct blk_mq_ctx *ctx,
 	 */
 	list_for_each_entry(rq, list, queuelist) {
 		BUG_ON(rq->mq_ctx != ctx);
-		trace_block_rq_insert(hctx->queue, rq);
+		trace_block_rq_insert(rq);
 	}
 
 	spin_lock(&ctx->lock);
@@ -2111,7 +2111,7 @@ blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		goto queue_exit;
 	}
 
-	trace_block_getrq(q, bio, bio->bi_opf);
+	trace_block_getrq(bio, bio->bi_opf);
 
 	rq_qos_track(q, rq, bio);
 
diff --git a/block/bounce.c b/block/bounce.c
index c3aaed070124..9550640b1f86 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -341,7 +341,7 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 		}
 	}
 
-	trace_block_bio_bounce(q, *bio_orig);
+	trace_block_bio_bounce(*bio_orig);
 
 	bio->bi_flags |= (1 << BIO_BOUNCED);
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 109e81f33edb..4b9ff226904d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1678,7 +1678,7 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
 				part_stat_unlock();
 
 				bio_chain(b, bio);
-				trace_block_split(md->queue, b, bio->bi_iter.bi_sector);
+				trace_block_split(b, bio->bi_iter.bi_sector);
 				ret = generic_make_request(bio);
 				break;
 			}
@@ -1745,7 +1745,7 @@ static void dm_queue_split(struct mapped_device *md, struct dm_target *ti, struc
 		struct bio *split = bio_split(*bio, len, GFP_NOIO, &md->queue->bio_split);
 
 		bio_chain(split, *bio);
-		trace_block_split(md->queue, split, (*bio)->bi_iter.bi_sector);
+		trace_block_split(split, (*bio)->bi_iter.bi_sector);
 		generic_make_request(*bio);
 		*bio = split;
 	}
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 34d64ca306b1..237d40a48429 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -64,7 +64,6 @@ DEFINE_EVENT(block_buffer, block_dirty_buffer,
 
 /**
  * block_rq_requeue - place block IO request back on a queue
- * @q: queue holding operation
  * @rq: block IO operation request
  *
  * The block operation request @rq is being placed back into queue
@@ -73,9 +72,9 @@ DEFINE_EVENT(block_buffer, block_dirty_buffer,
  */
 TRACE_EVENT(block_rq_requeue,
 
-	TP_PROTO(struct request_queue *q, struct request *rq),
+	TP_PROTO(struct request *rq),
 
-	TP_ARGS(q, rq),
+	TP_ARGS(rq),
 
 	TP_STRUCT__entry(
 		__field(  dev_t,	dev			)
@@ -103,7 +102,6 @@ TRACE_EVENT(block_rq_requeue,
 
 /**
  * block_rq_complete - block IO operation completed by device driver
- * @rq: block operations request
  * @error: status code
  * @nr_bytes: number of completed bytes
  *
@@ -147,9 +145,9 @@ TRACE_EVENT(block_rq_complete,
 
 DECLARE_EVENT_CLASS(block_rq,
 
-	TP_PROTO(struct request_queue *q, struct request *rq),
+	TP_PROTO(struct request *rq),
 
-	TP_ARGS(q, rq),
+	TP_ARGS(rq),
 
 	TP_STRUCT__entry(
 		__field(  dev_t,	dev			)
@@ -181,24 +179,22 @@ DECLARE_EVENT_CLASS(block_rq,
 
 /**
  * block_rq_insert - insert block operation request into queue
- * @q: target queue
  * @rq: block IO operation request
  *
  * Called immediately before block operation request @rq is inserted
- * into queue @q.  The fields in the operation request @rq struct can
+ * into queue.  The fields in the operation request @rq struct can
  * be examined to determine which device and sectors the pending
  * operation would access.
  */
 DEFINE_EVENT(block_rq, block_rq_insert,
 
-	TP_PROTO(struct request_queue *q, struct request *rq),
+	TP_PROTO(struct request *rq),
 
-	TP_ARGS(q, rq)
+	TP_ARGS(rq)
 );
 
 /**
  * block_rq_issue - issue pending block IO request operation to device driver
- * @q: queue holding operation
  * @rq: block IO operation operation request
  *
  * Called when block operation request @rq from queue @q is sent to a
@@ -206,32 +202,30 @@ DEFINE_EVENT(block_rq, block_rq_insert,
  */
 DEFINE_EVENT(block_rq, block_rq_issue,
 
-	TP_PROTO(struct request_queue *q, struct request *rq),
+	TP_PROTO(struct request *rq),
 
-	TP_ARGS(q, rq)
+	TP_ARGS(rq)
 );
 
 /**
  * block_rq_merge - merge request with another one in the elevator
- * @q: queue holding operation
  * @rq: block IO operation operation request
  *
- * Called when block operation request @rq from queue @q is merged to another
+ * Called when block operation request @rq from queue is merged to another
  * request queued in the elevator.
  */
 DEFINE_EVENT(block_rq, block_rq_merge,
 
-	TP_PROTO(struct request_queue *q, struct request *rq),
+	TP_PROTO(struct request *rq),
 
-	TP_ARGS(q, rq)
+	TP_ARGS(rq)
 );
 
 /**
  * block_bio_bounce - used bounce buffer when processing block operation
- * @q: queue holding the block operation
  * @bio: block operation
  *
- * A bounce buffer was used to handle the block operation @bio in @q.
+ * A bounce buffer was used to handle the block operation @bio in queue.
  * This occurs when hardware limitations prevent a direct transfer of
  * data between the @bio data memory area and the IO device.  Use of a
  * bounce buffer requires extra copying of data and decreases
@@ -239,9 +233,9 @@ DEFINE_EVENT(block_rq, block_rq_merge,
  */
 TRACE_EVENT(block_bio_bounce,
 
-	TP_PROTO(struct request_queue *q, struct bio *bio),
+	TP_PROTO(struct bio *bio),
 
-	TP_ARGS(q, bio),
+	TP_ARGS(bio),
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev			)
@@ -303,9 +297,9 @@ TRACE_EVENT(block_bio_complete,
 
 DECLARE_EVENT_CLASS(block_bio_merge,
 
-	TP_PROTO(struct request_queue *q, struct request *rq, struct bio *bio),
+	TP_PROTO(struct bio *bio),
 
-	TP_ARGS(q, rq, bio),
+	TP_ARGS(bio),
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev			)
@@ -331,48 +325,43 @@ DECLARE_EVENT_CLASS(block_bio_merge,
 
 /**
  * block_bio_backmerge - merging block operation to the end of an existing operation
- * @q: queue holding operation
- * @rq: request bio is being merged into
  * @bio: new block operation to merge
  *
  * Merging block request @bio to the end of an existing block request
- * in queue @q.
+ * in queue.
  */
 DEFINE_EVENT(block_bio_merge, block_bio_backmerge,
 
-	TP_PROTO(struct request_queue *q, struct request *rq, struct bio *bio),
+	TP_PROTO(struct bio *bio),
 
-	TP_ARGS(q, rq, bio)
+	TP_ARGS(bio)
 );
 
 /**
  * block_bio_frontmerge - merging block operation to the beginning of an existing operation
- * @q: queue holding operation
- * @rq: request bio is being merged into
  * @bio: new block operation to merge
  *
  * Merging block IO operation @bio to the beginning of an existing block
- * operation in queue @q.
+ * operation in queue.
  */
 DEFINE_EVENT(block_bio_merge, block_bio_frontmerge,
 
-	TP_PROTO(struct request_queue *q, struct request *rq, struct bio *bio),
+	TP_PROTO(struct bio *bio),
 
-	TP_ARGS(q, rq, bio)
+	TP_ARGS(bio)
 );
 
 /**
  * block_bio_queue - putting new block IO operation in queue
- * @q: queue holding operation
  * @bio: new block operation
  *
- * About to place the block IO operation @bio into queue @q.
+ * About to place the block IO operation @bio into queue.
  */
 TRACE_EVENT(block_bio_queue,
 
-	TP_PROTO(struct request_queue *q, struct bio *bio),
+	TP_PROTO(struct bio *bio),
 
-	TP_ARGS(q, bio),
+	TP_ARGS(bio),
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev			)
@@ -398,9 +387,9 @@ TRACE_EVENT(block_bio_queue,
 
 DECLARE_EVENT_CLASS(block_get_rq,
 
-	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
+	TP_PROTO(struct bio *bio, int rw),
 
-	TP_ARGS(q, bio, rw),
+	TP_ARGS(bio, rw),
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev			)
@@ -427,36 +416,34 @@ DECLARE_EVENT_CLASS(block_get_rq,
 
 /**
  * block_getrq - get a free request entry in queue for block IO operations
- * @q: queue for operations
  * @bio: pending block IO operation (can be %NULL)
  * @rw: low bit indicates a read (%0) or a write (%1)
  *
- * A request struct for queue @q has been allocated to handle the
+ * A request struct for queue has been allocated to handle the
  * block IO operation @bio.
  */
 DEFINE_EVENT(block_get_rq, block_getrq,
 
-	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
+	TP_PROTO(struct bio *bio, int rw),
 
-	TP_ARGS(q, bio, rw)
+	TP_ARGS(bio, rw)
 );
 
 /**
  * block_sleeprq - waiting to get a free request entry in queue for block IO operation
- * @q: queue for operation
  * @bio: pending block IO operation (can be %NULL)
  * @rw: low bit indicates a read (%0) or a write (%1)
  *
- * In the case where a request struct cannot be provided for queue @q
+ * In the case where a request struct cannot be provided for queue
  * the process needs to wait for an request struct to become
  * available.  This tracepoint event is generated each time the
  * process goes to sleep waiting for request struct become available.
  */
 DEFINE_EVENT(block_get_rq, block_sleeprq,
 
-	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
+	TP_PROTO(struct bio *bio, int rw),
 
-	TP_ARGS(q, bio, rw)
+	TP_ARGS(bio, rw)
 );
 
 /**
@@ -521,7 +508,6 @@ DEFINE_EVENT(block_unplug, block_unplug,
 
 /**
  * block_split - split a single bio struct into two bio structs
- * @q: queue containing the bio
  * @bio: block operation being split
  * @new_sector: The starting sector for the new bio
  *
@@ -532,10 +518,9 @@ DEFINE_EVENT(block_unplug, block_unplug,
  */
 TRACE_EVENT(block_split,
 
-	TP_PROTO(struct request_queue *q, struct bio *bio,
-		 unsigned int new_sector),
+	TP_PROTO(struct bio *bio, unsigned int new_sector),
 
-	TP_ARGS(q, bio, new_sector),
+	TP_ARGS(bio, new_sector),
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev				)
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 7ba62d68885a..7b72781a591d 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -28,6 +28,11 @@
 
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 
+static inline struct request_queue *bio_q(struct bio *bio)
+{
+	return bio->bi_disk->queue;
+}
+
 static unsigned int blktrace_seq __read_mostly = 1;
 
 static struct trace_array *blk_tr;
@@ -846,33 +851,28 @@ static void blk_add_trace_rq(struct request *rq, int error,
 	rcu_read_unlock();
 }
 
-static void blk_add_trace_rq_insert(void *ignore,
-				    struct request_queue *q, struct request *rq)
+static void blk_add_trace_rq_insert(void *ignore, struct request *rq)
 {
 	blk_add_trace_rq(rq, 0, blk_rq_bytes(rq), BLK_TA_INSERT,
-			 blk_trace_request_get_cgid(q, rq));
+			 blk_trace_request_get_cgid(rq->q, rq));
 }
 
-static void blk_add_trace_rq_issue(void *ignore,
-				   struct request_queue *q, struct request *rq)
+static void blk_add_trace_rq_issue(void *ignore, struct request *rq)
 {
 	blk_add_trace_rq(rq, 0, blk_rq_bytes(rq), BLK_TA_ISSUE,
-			 blk_trace_request_get_cgid(q, rq));
+			 blk_trace_request_get_cgid(rq->q, rq));
 }
 
-static void blk_add_trace_rq_merge(void *ignore,
-				   struct request_queue *q, struct request *rq)
+static void blk_add_trace_rq_merge(void *ignore, struct request *rq)
 {
 	blk_add_trace_rq(rq, 0, blk_rq_bytes(rq), BLK_TA_BACKMERGE,
-			 blk_trace_request_get_cgid(q, rq));
+			 blk_trace_request_get_cgid(rq->q, rq));
 }
 
-static void blk_add_trace_rq_requeue(void *ignore,
-				     struct request_queue *q,
-				     struct request *rq)
+static void blk_add_trace_rq_requeue(void *ignore, struct request *rq)
 {
 	blk_add_trace_rq(rq, 0, blk_rq_bytes(rq), BLK_TA_REQUEUE,
-			 blk_trace_request_get_cgid(q, rq));
+			 blk_trace_request_get_cgid(rq->q, rq));
 }
 
 static void blk_add_trace_rq_complete(void *ignore, struct request *rq,
@@ -893,13 +893,12 @@ static void blk_add_trace_rq_complete(void *ignore, struct request *rq,
  *     Records an action against a bio. Will log the bio offset + size.
  *
  **/
-static void blk_add_trace_bio(struct request_queue *q, struct bio *bio,
-			      u32 what, int error)
+static void blk_add_trace_bio(struct bio *bio, u32 what, int error)
 {
 	struct blk_trace *bt;
 
 	rcu_read_lock();
-	bt = rcu_dereference(q->blk_trace);
+	bt = rcu_dereference(bio_q(bio)->blk_trace);
 	if (likely(!bt)) {
 		rcu_read_unlock();
 		return;
@@ -907,56 +906,59 @@ static void blk_add_trace_bio(struct request_queue *q, struct bio *bio,
 
 	__blk_add_trace(bt, bio->bi_iter.bi_sector, bio->bi_iter.bi_size,
 			bio_op(bio), bio->bi_opf, what, error, 0, NULL,
-			blk_trace_bio_get_cgid(q, bio));
+			blk_trace_bio_get_cgid(bio_q(bio), bio));
 	rcu_read_unlock();
 }
 
-static void blk_add_trace_bio_bounce(void *ignore,
-				     struct request_queue *q, struct bio *bio)
+static void blk_add_trace_bio_bounce(void *ignore, struct bio *bio)
 {
-	blk_add_trace_bio(q, bio, BLK_TA_BOUNCE, 0);
+	blk_add_trace_bio(bio, BLK_TA_BOUNCE, 0);
 }
 
-static void blk_add_trace_bio_complete(void *ignore,
-				       struct request_queue *q, struct bio *bio)
+static void blk_add_trace_bio_complete(void *ignore, struct request_queue *q,
+				       struct bio *bio)
 {
-	blk_add_trace_bio(q, bio, BLK_TA_COMPLETE,
-			  blk_status_to_errno(bio->bi_status));
+	struct blk_trace *bt;
+
+	rcu_read_lock();
+	bt = rcu_dereference(q->blk_trace);
+	if (likely(!bt)) {
+		rcu_read_unlock();
+		return;
+	}
+
+	__blk_add_trace(bt, bio->bi_iter.bi_sector, bio->bi_iter.bi_size,
+			bio_op(bio), bio->bi_opf, BLK_TA_COMPLETE,
+			blk_status_to_errno(bio->bi_status), 0, NULL,
+			blk_trace_bio_get_cgid(q, bio));
+	rcu_read_unlock();
 }
 
-static void blk_add_trace_bio_backmerge(void *ignore,
-					struct request_queue *q,
-					struct request *rq,
-					struct bio *bio)
+static void blk_add_trace_bio_backmerge(void *ignore, struct bio *bio)
 {
-	blk_add_trace_bio(q, bio, BLK_TA_BACKMERGE, 0);
+	blk_add_trace_bio(bio, BLK_TA_BACKMERGE, 0);
 }
 
-static void blk_add_trace_bio_frontmerge(void *ignore,
-					 struct request_queue *q,
-					 struct request *rq,
-					 struct bio *bio)
+static void blk_add_trace_bio_frontmerge(void *ignore, struct bio *bio)
 {
-	blk_add_trace_bio(q, bio, BLK_TA_FRONTMERGE, 0);
+	blk_add_trace_bio(bio, BLK_TA_FRONTMERGE, 0);
 }
 
-static void blk_add_trace_bio_queue(void *ignore,
-				    struct request_queue *q, struct bio *bio)
+static void blk_add_trace_bio_queue(void *ignore, struct bio *bio)
 {
-	blk_add_trace_bio(q, bio, BLK_TA_QUEUE, 0);
+	blk_add_trace_bio(bio, BLK_TA_QUEUE, 0);
 }
 
 static void blk_add_trace_getrq(void *ignore,
-				struct request_queue *q,
 				struct bio *bio, int rw)
 {
 	if (bio)
-		blk_add_trace_bio(q, bio, BLK_TA_GETRQ, 0);
+		blk_add_trace_bio(bio, BLK_TA_GETRQ, 0);
 	else {
 		struct blk_trace *bt;
 
 		rcu_read_lock();
-		bt = rcu_dereference(q->blk_trace);
+		bt = rcu_dereference(bio_q(bio)->blk_trace);
 		if (bt)
 			__blk_add_trace(bt, 0, 0, rw, 0, BLK_TA_GETRQ, 0, 0,
 					NULL, 0);
@@ -965,17 +967,15 @@ static void blk_add_trace_getrq(void *ignore,
 }
 
 
-static void blk_add_trace_sleeprq(void *ignore,
-				  struct request_queue *q,
-				  struct bio *bio, int rw)
+static void blk_add_trace_sleeprq(void *ignore, struct bio *bio, int rw)
 {
 	if (bio)
-		blk_add_trace_bio(q, bio, BLK_TA_SLEEPRQ, 0);
+		blk_add_trace_bio(bio, BLK_TA_SLEEPRQ, 0);
 	else {
 		struct blk_trace *bt;
 
 		rcu_read_lock();
-		bt = rcu_dereference(q->blk_trace);
+		bt = rcu_dereference(bio_q(bio)->blk_trace);
 		if (bt)
 			__blk_add_trace(bt, 0, 0, rw, 0, BLK_TA_SLEEPRQ,
 					0, 0, NULL, 0);
@@ -1015,14 +1015,12 @@ static void blk_add_trace_unplug(void *ignore, struct request_queue *q,
 	rcu_read_unlock();
 }
 
-static void blk_add_trace_split(void *ignore,
-				struct request_queue *q, struct bio *bio,
-				unsigned int pdu)
+static void blk_add_trace_split(void *ignore, struct bio *bio, unsigned int pdu)
 {
 	struct blk_trace *bt;
 
 	rcu_read_lock();
-	bt = rcu_dereference(q->blk_trace);
+	bt = rcu_dereference(bio_q(bio)->blk_trace);
 	if (bt) {
 		__be64 rpdu = cpu_to_be64(pdu);
 
@@ -1031,7 +1029,7 @@ static void blk_add_trace_split(void *ignore,
 				BLK_TA_SPLIT,
 				blk_status_to_errno(bio->bi_status),
 				sizeof(rpdu), &rpdu,
-				blk_trace_bio_get_cgid(q, bio));
+				blk_trace_bio_get_cgid(bio_q(bio), bio));
 	}
 	rcu_read_unlock();
 }
-- 
2.26.0
