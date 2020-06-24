From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH RFC] block: blktrace framework cleanup
Date: Tue, 23 Jun 2020 20:27:52 -0700
Message-ID: <20200624032752.4177-1-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Y
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com, kbusch@kernel.org, hch@lst.de, rostedt@goodmis.org, mingo@redhat.com, rdunlap@infradead.org, Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
List-Id: dm-devel.ids

There are many places where trace API accepts the struct request_queue*
parameter which can be derived from other function parameters.

This patch removes the struct request queue parameter from the
blktrace framework and adjusts the tracepoints definition and usage
along with the tracing API itself.

This patch still needs a lot of improvement and testing of other
tracepoints, I'll be happy to put more effort into this and send out
well tested and formatted patch.

Minimal testing shows that basic Q(queue), G (Get), I (Insert),
Dispatch (D), and Complete (C) seems to work file with following
commands:-

# dd if=/dev/zero of=/dev/nullb0 bs=4k count=10 oflag=direct
# ./blktrace -d /dev/nullb0 -o -| ./blkparse -a write  -i -
252,0    9        1     0.000000000  4268  Q  WS 0 + 8 [dd]
252,0    9        2     0.000006482  4268  G  WS 0 + 8 [dd]
252,0    9        5     0.000010189  4268  I  WS 0 + 8 [dd]
252,0    9        6     0.000029205  1001  D  WS 0 + 8 [kworker/9:1H]
252,0    9        7     0.000039174    56  C  WS 0 + 8 [0]
252,0    9        8     0.000055364  4268  Q  WS 8 + 8 [dd]
252,0    9        9     0.000056496  4268  G  WS 8 + 8 [dd]
252,0    9       12     0.000057808  4268  I  WS 8 + 8 [dd]
252,0    9       13     0.000063820  1001  D  WS 8 + 8 [kworker/9:1H]
252,0    9       14     0.000067567    56  C  WS 8 + 8 [0]
252,0    9       15     0.000076604  4268  Q  WS 16 + 8 [dd]
252,0    9       16     0.000077656  4268  G  WS 16 + 8 [dd]
252,0    9       19     0.000078928  4268  I  WS 16 + 8 [dd]
252,0    9       20     0.000083577  1001  D  WS 16 + 8 [kworker/9:1H]
252,0    9       21     0.000086963    56  C  WS 16 + 8 [0]
252,0    9       22     0.000095419  4268  Q  WS 24 + 8 [dd]
252,0    9       23     0.000096411  4268  G  WS 24 + 8 [dd]
252,0    9       26     0.000097653  4268  I  WS 24 + 8 [dd]
252,0    9       27     0.000102122  1001  D  WS 24 + 8 [kworker/9:1H]
252,0    9       28     0.000104827    56  C  WS 24 + 8 [0]
252,0    9       29     0.000111159  4268  Q  WS 32 + 8 [dd]
252,0    9       30     0.000111770  4268  G  WS 32 + 8 [dd]
252,0    9       33     0.000112581  4268  I  WS 32 + 8 [dd]
252,0    9       34     0.000115577  1001  D  WS 32 + 8 [kworker/9:1H]
252,0    9       35     0.000117701    56  C  WS 32 + 8 [0]
252,0    9       36     0.000122961  4268  Q  WS 40 + 8 [dd]
252,0    9       37     0.000123592  4268  G  WS 40 + 8 [dd]
252,0    9       40     0.000124363  4268  I  WS 40 + 8 [dd]
252,0    9       41     0.000127269  1001  D  WS 40 + 8 [kworker/9:1H]
252,0    9       42     0.000129353    56  C  WS 40 + 8 [0]
252,0    9       43     0.000134793  4268  Q  WS 48 + 8 [dd]
252,0    9       44     0.000135494  4268  G  WS 48 + 8 [dd]
252,0    9       47     0.000136276  4268  I  WS 48 + 8 [dd]
252,0    9       48     0.000139131  1001  D  WS 48 + 8 [kworker/9:1H]
252,0    9       49     0.000141215    56  C  WS 48 + 8 [0]
252,0    9       50     0.000146475  4268  Q  WS 56 + 8 [dd]
252,0    9       51     0.000147156  4268  G  WS 56 + 8 [dd]
252,0    9       54     0.000147917  4268  I  WS 56 + 8 [dd]
252,0    9       55     0.000150753  1001  D  WS 56 + 8 [kworker/9:1H]
252,0    9       56     0.000152857    56  C  WS 56 + 8 [0]
252,0    9       57     0.000158157  4268  Q  WS 64 + 8 [dd]
252,0    9       58     0.000158858  4268  G  WS 64 + 8 [dd]
252,0    9       61     0.000159639  4268  I  WS 64 + 8 [dd]
252,0    9       62     0.000162575  1001  D  WS 64 + 8 [kworker/9:1H]
252,0    9       63     0.000164679    56  C  WS 64 + 8 [0]
252,0    9       64     0.000169849  4268  Q  WS 72 + 8 [dd]
252,0    9       65     0.000170500  4268  G  WS 72 + 8 [dd]
252,0    9       68     0.000171281  4268  I  WS 72 + 8 [dd]
252,0    9       69     0.000174337  1001  D  WS 72 + 8 [kworker/9:1H]
252,0    9       70     0.000176411    56  C  WS 72 + 8 [0]

Any feedback is welcome.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 block/bio.c                  |  2 +-
 block/blk-core.c             |  6 +--
 block/blk-merge.c            |  2 +-
 block/blk-mq-sched.c         |  2 +-
 block/blk-mq.c               | 10 ++---
 block/bounce.c               |  2 +-
 drivers/md/dm.c              |  4 +-
 drivers/nvme/host/nvme.h     |  4 +-
 include/trace/events/block.h | 61 +++++++++++++++--------------
 kernel/trace/blktrace.c      | 74 +++++++++++++++---------------------
 10 files changed, 76 insertions(+), 91 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index fb5533416fa6..0b202068e475 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1432,7 +1432,7 @@ void bio_endio(struct bio *bio)
 	}
 
 	if (bio->bi_disk && bio_flagged(bio, BIO_TRACE_COMPLETION)) {
-		trace_block_bio_complete(bio->bi_disk->queue, bio);
+		trace_block_bio_complete(bio);
 		bio_clear_flag(bio, BIO_TRACE_COMPLETION);
 	}
 
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
index f0b0bae075a0..da9e2a02c542 100644
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
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 61780c38f51f..b12a7d082476 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -598,10 +598,8 @@ static inline void nvme_mpath_check_last_path(struct nvme_ns *ns)
 static inline void nvme_trace_bio_complete(struct request *req,
         blk_status_t status)
 {
-	struct nvme_ns *ns = req->q->queuedata;
-
 	if (req->cmd_flags & REQ_NVME_MPATH)
-		trace_block_bio_complete(ns->head->disk->queue, req->bio);
+		trace_block_bio_complete(req->bio);
 }
 
 extern struct device_attribute dev_attr_ana_grpid;
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 93b114226af8..a2a14f780652 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -73,9 +73,9 @@ DEFINE_EVENT(block_buffer, block_dirty_buffer,
  */
 TRACE_EVENT(block_rq_requeue,
 
-	TP_PROTO(struct request_queue *q, struct request *rq),
+	TP_PROTO(struct request *rq),
 
-	TP_ARGS(q, rq),
+	TP_ARGS(rq),
 
 	TP_STRUCT__entry(
 		__field(  dev_t,	dev			)
@@ -147,9 +147,9 @@ TRACE_EVENT(block_rq_complete,
 
 DECLARE_EVENT_CLASS(block_rq,
 
-	TP_PROTO(struct request_queue *q, struct request *rq),
+	TP_PROTO(struct request *rq),
 
-	TP_ARGS(q, rq),
+	TP_ARGS(rq),
 
 	TP_STRUCT__entry(
 		__field(  dev_t,	dev			)
@@ -191,9 +191,9 @@ DECLARE_EVENT_CLASS(block_rq,
  */
 DEFINE_EVENT(block_rq, block_rq_insert,
 
-	TP_PROTO(struct request_queue *q, struct request *rq),
+	TP_PROTO(struct request *rq),
 
-	TP_ARGS(q, rq)
+	TP_ARGS(rq)
 );
 
 /**
@@ -206,9 +206,9 @@ DEFINE_EVENT(block_rq, block_rq_insert,
  */
 DEFINE_EVENT(block_rq, block_rq_issue,
 
-	TP_PROTO(struct request_queue *q, struct request *rq),
+	TP_PROTO(struct request *rq),
 
-	TP_ARGS(q, rq)
+	TP_ARGS(rq)
 );
 
 /**
@@ -224,9 +224,9 @@ DEFINE_EVENT(block_rq, block_rq_issue,
  */
 TRACE_EVENT(block_bio_bounce,
 
-	TP_PROTO(struct request_queue *q, struct bio *bio),
+	TP_PROTO(struct bio *bio),
 
-	TP_ARGS(q, bio),
+	TP_ARGS(bio),
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev			)
@@ -260,9 +260,9 @@ TRACE_EVENT(block_bio_bounce,
  */
 TRACE_EVENT(block_bio_complete,
 
-	TP_PROTO(struct request_queue *q, struct bio *bio),
+	TP_PROTO(struct bio *bio),
 
-	TP_ARGS(q, bio),
+	TP_ARGS(bio),
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev		)
@@ -288,9 +288,9 @@ TRACE_EVENT(block_bio_complete,
 
 DECLARE_EVENT_CLASS(block_bio_merge,
 
-	TP_PROTO(struct request_queue *q, struct request *rq, struct bio *bio),
+	TP_PROTO(struct bio *bio),
 
-	TP_ARGS(q, rq, bio),
+	TP_ARGS(bio),
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev			)
@@ -325,9 +325,9 @@ DECLARE_EVENT_CLASS(block_bio_merge,
  */
 DEFINE_EVENT(block_bio_merge, block_bio_backmerge,
 
-	TP_PROTO(struct request_queue *q, struct request *rq, struct bio *bio),
+	TP_PROTO(struct bio *bio),
 
-	TP_ARGS(q, rq, bio)
+	TP_ARGS(bio)
 );
 
 /**
@@ -341,9 +341,9 @@ DEFINE_EVENT(block_bio_merge, block_bio_backmerge,
  */
 DEFINE_EVENT(block_bio_merge, block_bio_frontmerge,
 
-	TP_PROTO(struct request_queue *q, struct request *rq, struct bio *bio),
+	TP_PROTO(struct bio *bio),
 
-	TP_ARGS(q, rq, bio)
+	TP_ARGS(bio)
 );
 
 /**
@@ -355,9 +355,9 @@ DEFINE_EVENT(block_bio_merge, block_bio_frontmerge,
  */
 TRACE_EVENT(block_bio_queue,
 
-	TP_PROTO(struct request_queue *q, struct bio *bio),
+	TP_PROTO(struct bio *bio),
 
-	TP_ARGS(q, bio),
+	TP_ARGS(bio),
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev			)
@@ -383,9 +383,9 @@ TRACE_EVENT(block_bio_queue,
 
 DECLARE_EVENT_CLASS(block_get_rq,
 
-	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
+	TP_PROTO(struct bio *bio, int rw),
 
-	TP_ARGS(q, bio, rw),
+	TP_ARGS(bio, rw),
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev			)
@@ -421,9 +421,9 @@ DECLARE_EVENT_CLASS(block_get_rq,
  */
 DEFINE_EVENT(block_get_rq, block_getrq,
 
-	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
+	TP_PROTO(struct bio *bio, int rw),
 
-	TP_ARGS(q, bio, rw)
+	TP_ARGS(bio, rw)
 );
 
 /**
@@ -439,9 +439,9 @@ DEFINE_EVENT(block_get_rq, block_getrq,
  */
 DEFINE_EVENT(block_get_rq, block_sleeprq,
 
-	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
+	TP_PROTO(struct bio *bio, int rw),
 
-	TP_ARGS(q, bio, rw)
+	TP_ARGS(bio, rw)
 );
 
 /**
@@ -517,10 +517,9 @@ DEFINE_EVENT(block_unplug, block_unplug,
  */
 TRACE_EVENT(block_split,
 
-	TP_PROTO(struct request_queue *q, struct bio *bio,
-		 unsigned int new_sector),
+	TP_PROTO(struct bio *bio, unsigned int new_sector),
 
-	TP_ARGS(q, bio, new_sector),
+	TP_ARGS(bio, new_sector),
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev				)
@@ -558,7 +557,7 @@ TRACE_EVENT(block_split,
 TRACE_EVENT(block_bio_remap,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio, dev_t dev,
-		 sector_t from),
+		sector_t from),
 
 	TP_ARGS(q, bio, dev, from),
 
@@ -602,7 +601,7 @@ TRACE_EVENT(block_bio_remap,
 TRACE_EVENT(block_rq_remap,
 
 	TP_PROTO(struct request_queue *q, struct request *rq, dev_t dev,
-		 sector_t from),
+		sector_t from),
 
 	TP_ARGS(q, rq, dev, from),
 
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index c086c38f4954..59e809b40087 100644
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
@@ -846,26 +851,22 @@ static void blk_add_trace_rq(struct request *rq, int error,
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
@@ -886,13 +887,13 @@ static void blk_add_trace_rq_complete(void *ignore, struct request *rq,
  *     Records an action against a bio. Will log the bio offset + size.
  *
  **/
-static void blk_add_trace_bio(struct request_queue *q, struct bio *bio,
+static void blk_add_trace_bio(struct bio *bio,
 			      u32 what, int error)
 {
 	struct blk_trace *bt;
 
 	rcu_read_lock();
-	bt = rcu_dereference(q->blk_trace);
+	bt = rcu_dereference(bio_q(bio)->blk_trace);
 	if (likely(!bt)) {
 		rcu_read_unlock();
 		return;
@@ -900,56 +901,46 @@ static void blk_add_trace_bio(struct request_queue *q, struct bio *bio,
 
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
+static void blk_add_trace_bio_complete(void *ignore, struct bio *bio)
 {
-	blk_add_trace_bio(q, bio, BLK_TA_COMPLETE,
+	blk_add_trace_bio(bio, BLK_TA_COMPLETE,
 			  blk_status_to_errno(bio->bi_status));
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
@@ -959,16 +950,15 @@ static void blk_add_trace_getrq(void *ignore,
 
 
 static void blk_add_trace_sleeprq(void *ignore,
-				  struct request_queue *q,
 				  struct bio *bio, int rw)
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
@@ -1008,14 +998,12 @@ static void blk_add_trace_unplug(void *ignore, struct request_queue *q,
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
 
@@ -1024,7 +1012,7 @@ static void blk_add_trace_split(void *ignore,
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
