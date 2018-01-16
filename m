From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH v4-mike 1/2] blk-mq: return dispatch result from blk_mq_try_issue_directly
Date: Tue, 16 Jan 2018 10:01:47 -0500
Message-ID: <20180116150148.21145-1-snitzer@redhat.com>
References: <20180116015710.GF3213@ming.t460p>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180116015710.GF3213@ming.t460p>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: Ming Lei <tom.leiming@gmail.com>, hch@lst.de, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

From: Ming Lei <ming.lei@redhat.com>

In the following patch, we will use blk_mq_try_issue_directly() for DM
to return the dispatch result.  DM needs this information to improve
IO merging.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-mq.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c8f62e6be6b6..55f3a27fb2e6 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1694,9 +1694,9 @@ static blk_qc_t request_to_qc_t(struct blk_mq_hw_ctx *hctx, struct request *rq)
 	return blk_tag_to_qc_t(rq->internal_tag, hctx->queue_num, true);
 }
 
-static void __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
-					struct request *rq,
-					blk_qc_t *cookie)
+static blk_status_t __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
+						struct request *rq,
+						blk_qc_t *cookie)
 {
 	struct request_queue *q = rq->q;
 	struct blk_mq_queue_data bd = {
@@ -1704,7 +1704,7 @@ static void __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 		.last = true,
 	};
 	blk_qc_t new_cookie;
-	blk_status_t ret;
+	blk_status_t ret = BLK_STS_OK;
 	bool run_queue = true;
 
 	/* RCU or SRCU read lock is needed before checking quiesced flag */
@@ -1735,31 +1735,36 @@ static void __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 	switch (ret) {
 	case BLK_STS_OK:
 		*cookie = new_cookie;
-		return;
+		return ret;
 	case BLK_STS_RESOURCE:
 		__blk_mq_requeue_request(rq);
 		goto insert;
 	default:
 		*cookie = BLK_QC_T_NONE;
 		blk_mq_end_request(rq, ret);
-		return;
+		return ret;
 	}
 
 insert:
 	blk_mq_sched_insert_request(rq, false, run_queue, false,
 					hctx->flags & BLK_MQ_F_BLOCKING);
+	return ret;
 }
 
-static void blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
-		struct request *rq, blk_qc_t *cookie)
+static blk_status_t blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
+					      struct request *rq,
+					      blk_qc_t *cookie)
 {
 	int srcu_idx;
+	blk_status_t ret;
 
 	might_sleep_if(hctx->flags & BLK_MQ_F_BLOCKING);
 
 	hctx_lock(hctx, &srcu_idx);
-	__blk_mq_try_issue_directly(hctx, rq, cookie);
+	ret = __blk_mq_try_issue_directly(hctx, rq, cookie);
 	hctx_unlock(hctx, srcu_idx);
+
+	return ret;
 }
 
 static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
-- 
2.15.0
