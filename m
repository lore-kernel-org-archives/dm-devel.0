From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH v6 1/3] blk-mq: factor out a few helpers from __blk_mq_try_issue_directly
Date: Wed, 17 Jan 2018 11:25:56 -0500
Message-ID: <20180117162558.28553-2-snitzer@redhat.com>
References: <20180117162558.28553-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180117162558.28553-1-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: Ming Lei <tom.leiming@gmail.com>, hch@lst.de, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

No functional change.  Just makes code flow more logically.

In following commit, __blk_mq_try_issue_directly() will be used to
return the dispatch result (blk_status_t) to DM.  DM needs this
information to improve IO merging.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-mq.c | 79 ++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 52 insertions(+), 27 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c8f62e6be6b6..c117c2baf2c9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1694,9 +1694,9 @@ static blk_qc_t request_to_qc_t(struct blk_mq_hw_ctx *hctx, struct request *rq)
 	return blk_tag_to_qc_t(rq->internal_tag, hctx->queue_num, true);
 }
 
-static void __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
-					struct request *rq,
-					blk_qc_t *cookie)
+static blk_status_t __blk_mq_issue_directly(struct blk_mq_hw_ctx *hctx,
+					    struct request *rq,
+					    blk_qc_t *cookie)
 {
 	struct request_queue *q = rq->q;
 	struct blk_mq_queue_data bd = {
@@ -1705,6 +1705,43 @@ static void __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 	};
 	blk_qc_t new_cookie;
 	blk_status_t ret;
+
+	new_cookie = request_to_qc_t(hctx, rq);
+
+	/*
+	 * For OK queue, we are done. For error, caller may kill it.
+	 * Any other error (busy), just add it to our list as we
+	 * previously would have done.
+	 */
+	ret = q->mq_ops->queue_rq(hctx, &bd);
+	switch (ret) {
+	case BLK_STS_OK:
+		*cookie = new_cookie;
+		break;
+	case BLK_STS_RESOURCE:
+		__blk_mq_requeue_request(rq);
+		break;
+	default:
+		*cookie = BLK_QC_T_NONE;
+		break;
+	}
+
+	return ret;
+}
+
+static void __blk_mq_fallback_to_insert(struct blk_mq_hw_ctx *hctx,
+					struct request *rq,
+					bool run_queue)
+{
+	blk_mq_sched_insert_request(rq, false, run_queue, false,
+					hctx->flags & BLK_MQ_F_BLOCKING);
+}
+
+static blk_status_t __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
+						struct request *rq,
+						blk_qc_t *cookie)
+{
+	struct request_queue *q = rq->q;
 	bool run_queue = true;
 
 	/* RCU or SRCU read lock is needed before checking quiesced flag */
@@ -1724,41 +1761,29 @@ static void __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 		goto insert;
 	}
 
-	new_cookie = request_to_qc_t(hctx, rq);
-
-	/*
-	 * For OK queue, we are done. For error, kill it. Any other
-	 * error (busy), just add it to our list as we previously
-	 * would have done
-	 */
-	ret = q->mq_ops->queue_rq(hctx, &bd);
-	switch (ret) {
-	case BLK_STS_OK:
-		*cookie = new_cookie;
-		return;
-	case BLK_STS_RESOURCE:
-		__blk_mq_requeue_request(rq);
-		goto insert;
-	default:
-		*cookie = BLK_QC_T_NONE;
-		blk_mq_end_request(rq, ret);
-		return;
-	}
-
+	return __blk_mq_issue_directly(hctx, rq, cookie);
 insert:
-	blk_mq_sched_insert_request(rq, false, run_queue, false,
-					hctx->flags & BLK_MQ_F_BLOCKING);
+	__blk_mq_fallback_to_insert(hctx, rq, run_queue);
+
+	return BLK_STS_OK;
 }
 
 static void blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 		struct request *rq, blk_qc_t *cookie)
 {
+	blk_status_t ret;
 	int srcu_idx;
 
 	might_sleep_if(hctx->flags & BLK_MQ_F_BLOCKING);
 
 	hctx_lock(hctx, &srcu_idx);
-	__blk_mq_try_issue_directly(hctx, rq, cookie);
+
+	ret = __blk_mq_try_issue_directly(hctx, rq, cookie);
+	if (ret == BLK_STS_RESOURCE)
+		__blk_mq_fallback_to_insert(hctx, rq, true);
+	else if (ret != BLK_STS_OK)
+		blk_mq_end_request(rq, ret);
+
 	hctx_unlock(hctx, srcu_idx);
 }
 
-- 
2.15.0
