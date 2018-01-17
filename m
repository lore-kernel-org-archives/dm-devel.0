From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH v6 3/3] blk-mq-sched: remove unused 'can_block' arg from blk_mq_sched_insert_request
Date: Wed, 17 Jan 2018 11:25:58 -0500
Message-ID: <20180117162558.28553-4-snitzer@redhat.com>
References: <20180117162558.28553-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180117162558.28553-1-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: Ming Lei <tom.leiming@gmail.com>, hch@lst.de, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-exec.c     |  2 +-
 block/blk-mq-sched.c |  2 +-
 block/blk-mq-sched.h |  2 +-
 block/blk-mq.c       | 16 +++++++---------
 4 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index 5c0f3dc446dc..f7b292f12449 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -61,7 +61,7 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	 * be reused after dying flag is set
 	 */
 	if (q->mq_ops) {
-		blk_mq_sched_insert_request(rq, at_head, true, false, false);
+		blk_mq_sched_insert_request(rq, at_head, true, false);
 		return;
 	}
 
diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 2ff7cf0cbf73..55c0a745b427 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -427,7 +427,7 @@ void blk_mq_sched_restart(struct blk_mq_hw_ctx *const hctx)
 }
 
 void blk_mq_sched_insert_request(struct request *rq, bool at_head,
-				 bool run_queue, bool async, bool can_block)
+				 bool run_queue, bool async)
 {
 	struct request_queue *q = rq->q;
 	struct elevator_queue *e = q->elevator;
diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
index ba1d1418a96d..1e9c9018ace1 100644
--- a/block/blk-mq-sched.h
+++ b/block/blk-mq-sched.h
@@ -18,7 +18,7 @@ bool blk_mq_sched_try_insert_merge(struct request_queue *q, struct request *rq);
 void blk_mq_sched_restart(struct blk_mq_hw_ctx *hctx);
 
 void blk_mq_sched_insert_request(struct request *rq, bool at_head,
-				 bool run_queue, bool async, bool can_block);
+				 bool run_queue, bool async);
 void blk_mq_sched_insert_requests(struct request_queue *q,
 				  struct blk_mq_ctx *ctx,
 				  struct list_head *list, bool run_queue_async);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index f5f0d8456713..02ae1d7b94af 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -745,13 +745,13 @@ static void blk_mq_requeue_work(struct work_struct *work)
 
 		rq->rq_flags &= ~RQF_SOFTBARRIER;
 		list_del_init(&rq->queuelist);
-		blk_mq_sched_insert_request(rq, true, false, false, true);
+		blk_mq_sched_insert_request(rq, true, false, false);
 	}
 
 	while (!list_empty(&rq_list)) {
 		rq = list_entry(rq_list.next, struct request, queuelist);
 		list_del_init(&rq->queuelist);
-		blk_mq_sched_insert_request(rq, false, false, false, true);
+		blk_mq_sched_insert_request(rq, false, false, false);
 	}
 
 	blk_mq_run_hw_queues(q, false);
@@ -1729,13 +1729,11 @@ static blk_status_t __blk_mq_issue_directly(struct blk_mq_hw_ctx *hctx,
 	return ret;
 }
 
-static void __blk_mq_fallback_to_insert(struct blk_mq_hw_ctx *hctx,
-					struct request *rq,
+static void __blk_mq_fallback_to_insert(struct request *rq,
 					bool run_queue, bool bypass_insert)
 {
 	if (!bypass_insert)
-		blk_mq_sched_insert_request(rq, false, run_queue, false,
-					    hctx->flags & BLK_MQ_F_BLOCKING);
+		blk_mq_sched_insert_request(rq, false, run_queue, false);
 	else
 		blk_mq_request_bypass_insert(rq, run_queue);
 }
@@ -1767,7 +1765,7 @@ static blk_status_t __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 
 	return __blk_mq_issue_directly(hctx, rq, cookie);
 insert:
-	__blk_mq_fallback_to_insert(hctx, rq, run_queue, bypass_insert);
+	__blk_mq_fallback_to_insert(rq, run_queue, bypass_insert);
 	if (bypass_insert)
 		return BLK_STS_RESOURCE;
 
@@ -1786,7 +1784,7 @@ static void blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 
 	ret = __blk_mq_try_issue_directly(hctx, rq, cookie, false);
 	if (ret == BLK_STS_RESOURCE)
-		__blk_mq_fallback_to_insert(hctx, rq, true, false);
+		__blk_mq_fallback_to_insert(rq, true, false);
 	else if (ret != BLK_STS_OK)
 		blk_mq_end_request(rq, ret);
 
@@ -1916,7 +1914,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 	} else if (q->elevator) {
 		blk_mq_put_ctx(data.ctx);
 		blk_mq_bio_to_request(rq, bio);
-		blk_mq_sched_insert_request(rq, false, true, true, true);
+		blk_mq_sched_insert_request(rq, false, true, true);
 	} else {
 		blk_mq_put_ctx(data.ctx);
 		blk_mq_bio_to_request(rq, bio);
-- 
2.15.0
