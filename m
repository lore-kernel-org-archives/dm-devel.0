From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH] blk-mq: don't dispatch request in blk_mq_request_direct_issue if queue is busy
Date: Thu, 18 Jan 2018 12:06:59 +0800
Message-ID: <20180118040659.20202-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

If we run into blk_mq_request_direct_issue(), when queue is busy, we
don't want to dispatch this request into hctx->dispatch_list, and
what we need to do is to return the queue busy info to caller, so
that caller can deal with it well.

Fixes: 396eaf21ee ("blk-mq: improve DM's blk-mq IO merging via blk_insert_cloned_request feedback")
Reported-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4d4af8d712da..1af7fa70993b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1856,15 +1856,6 @@ static blk_status_t __blk_mq_issue_directly(struct blk_mq_hw_ctx *hctx,
 	return ret;
 }
 
-static void __blk_mq_fallback_to_insert(struct request *rq,
-					bool run_queue, bool bypass_insert)
-{
-	if (!bypass_insert)
-		blk_mq_sched_insert_request(rq, false, run_queue, false);
-	else
-		blk_mq_request_bypass_insert(rq, run_queue);
-}
-
 static blk_status_t __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 						struct request *rq,
 						blk_qc_t *cookie,
@@ -1873,9 +1864,16 @@ static blk_status_t __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 	struct request_queue *q = rq->q;
 	bool run_queue = true;
 
-	/* RCU or SRCU read lock is needed before checking quiesced flag */
+	/*
+	 * RCU or SRCU read lock is needed before checking quiesced flag.
+	 *
+	 * When queue is stopped or quiesced, ignore 'bypass_insert' from
+	 * blk_mq_request_direct_issue(), and return BLK_STS_OK to caller,
+	 * and avoid driver to try to dispatch again.
+	 */
 	if (blk_mq_hctx_stopped(hctx) || blk_queue_quiesced(q)) {
 		run_queue = false;
+		bypass_insert = false;
 		goto insert;
 	}
 
@@ -1892,10 +1890,10 @@ static blk_status_t __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 
 	return __blk_mq_issue_directly(hctx, rq, cookie);
 insert:
-	__blk_mq_fallback_to_insert(rq, run_queue, bypass_insert);
 	if (bypass_insert)
 		return BLK_STS_RESOURCE;
 
+	blk_mq_sched_insert_request(rq, false, run_queue, false);
 	return BLK_STS_OK;
 }
 
@@ -1911,7 +1909,7 @@ static void blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 
 	ret = __blk_mq_try_issue_directly(hctx, rq, cookie, false);
 	if (ret == BLK_STS_RESOURCE)
-		__blk_mq_fallback_to_insert(rq, true, false);
+		blk_mq_sched_insert_request(rq, false, true, false);
 	else if (ret != BLK_STS_OK)
 		blk_mq_end_request(rq, ret);
 
-- 
2.9.5
