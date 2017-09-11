From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] block: directly insert blk-mq request from
 blk_insert_cloned_request()
Date: Mon, 11 Sep 2017 12:16:48 -0400
Message-ID: <20170911161647.GA55061@redhat.com>
References: <20170907155255.GA22848@redhat.com>
 <756D2B3A-CD5A-4351-BC39-C2BAB771C740@linaro.org>
 <20170908164129.GA48286@redhat.com>
 <113c15ac-75f5-ff5b-695d-920dc6d5f708@kernel.dk>
 <20170908170727.GA29318@redhat.com>
 <20170908195805.GA30517@redhat.com>
 <57b4bb39-f50c-ad5e-d47d-01f0f84ec3ca@kernel.dk>
 <20170908214236.GA49918@redhat.com>
 <49cc6184-48da-2a45-e50e-13430e14e197@kernel.dk>
 <20170908220318.GA31120@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170908220318.GA31120@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Paolo Valente <paolo.valente@linaro.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

Here is v2 that should obviate the need to rename blk_mq_insert_request
(by using bools to control run_queue and async).

As for inserting directly into dispatch, if that can be done that is
great but I'd prefer to have that be a follow-up optimization.  This
fixes the regression in question, and does so in well-known terms.

What do you think?

Thanks,
Mike

From: Mike Snitzer <snitzer@redhat.com>
Date: Fri, 8 Sep 2017 11:45:13 -0400
Subject: [PATCH v2] block: directly insert blk-mq request from blk_insert_cloned_request()

A NULL pointer crash was reported for the case of having the BFQ IO
scheduler attached to the underlying blk-mq paths of a DM multipath
device.  The crash occured in blk_mq_sched_insert_request()'s call to
e->type->ops.mq.insert_requests().

Paolo Valente correctly summarized why the crash occured with:
"the call chain (dm_mq_queue_rq -> map_request -> setup_clone ->
blk_rq_prep_clone) creates a cloned request without invoking
e->type->ops.mq.prepare_request for the target elevator e.  The cloned
request is therefore not initialized for the scheduler, but it is
however inserted into the scheduler by blk_mq_sched_insert_request."

All said, a request-based DM multipath device's IO scheduler should be
the only one used -- when the original requests are issued to the
underlying paths as cloned requests they are inserted directly in the
underlying dispatch queue(s) rather than through an additional
elevator.

But commit bd166ef18 ("blk-mq-sched: add framework for MQ capable IO
schedulers") switched blk_insert_cloned_request() from using
blk_mq_insert_request() to blk_mq_sched_insert_request().  Which
incorrectly added elevator machinery into a call chain that isn't
supposed to have any.

To fix this re-introduce a blk-mq private blk_mq_insert_request() that
blk_insert_cloned_request() calls to insert the request without
involving any elevator that may be attached to the cloned request's
request_queue.

Fixes: bd166ef18 ("blk-mq-sched: add framework for MQ capable IO schedulers")
Cc: stable@vger.kernel.org
Reported-by: Bart Van Assche <Bart.VanAssche@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c |  2 +-
 block/blk-mq.c   | 28 +++++++++++++++++++---------
 block/blk-mq.h   |  1 +
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index dbecbf4..9085013 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2330,7 +2330,7 @@ blk_status_t blk_insert_cloned_request(struct request_queue *q, struct request *
 	if (q->mq_ops) {
 		if (blk_queue_io_stat(q))
 			blk_account_io_start(rq, true);
-		blk_mq_sched_insert_request(rq, false, true, false, false);
+		blk_mq_insert_request(rq, true, false);
 		return BLK_STS_OK;
 	}
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4603b11..05d9f7c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1357,6 +1357,25 @@ void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 	blk_mq_hctx_mark_pending(hctx, ctx);
 }
 
+static inline void blk_mq_queue_io(struct blk_mq_hw_ctx *hctx,
+				   struct blk_mq_ctx *ctx,
+				   struct request *rq)
+{
+	spin_lock(&ctx->lock);
+	__blk_mq_insert_request(hctx, rq, false);
+	spin_unlock(&ctx->lock);
+}
+
+void blk_mq_insert_request(struct request *rq, bool run_queue, bool async)
+{
+	struct blk_mq_ctx *ctx = rq->mq_ctx;
+	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(rq->q, ctx->cpu);
+
+	blk_mq_queue_io(hctx, ctx, rq);
+	if (run_queue)
+		blk_mq_run_hw_queue(hctx, async);
+}
+
 void blk_mq_insert_requests(struct blk_mq_hw_ctx *hctx, struct blk_mq_ctx *ctx,
 			    struct list_head *list)
 
@@ -1450,15 +1469,6 @@ static inline bool hctx_allow_merges(struct blk_mq_hw_ctx *hctx)
 		!blk_queue_nomerges(hctx->queue);
 }
 
-static inline void blk_mq_queue_io(struct blk_mq_hw_ctx *hctx,
-				   struct blk_mq_ctx *ctx,
-				   struct request *rq)
-{
-	spin_lock(&ctx->lock);
-	__blk_mq_insert_request(hctx, rq, false);
-	spin_unlock(&ctx->lock);
-}
-
 static blk_qc_t request_to_qc_t(struct blk_mq_hw_ctx *hctx, struct request *rq)
 {
 	if (rq->tag != -1)
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 60b01c0..01067b2 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -54,6 +54,7 @@ int blk_mq_alloc_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
  */
 void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 				bool at_head);
+void blk_mq_insert_request(struct request *rq, bool run_queue, bool async);
 void blk_mq_insert_requests(struct blk_mq_hw_ctx *hctx, struct blk_mq_ctx *ctx,
 				struct list_head *list);
 
-- 
2.10.1
