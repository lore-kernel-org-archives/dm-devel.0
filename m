From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] blk-mq: consider non-idle request as "inflight" in blk_mq_rq_inflight()
Date: Tue,  7 Jul 2020 11:04:33 -0400
Message-ID: <20200707150433.39480-1-snitzer@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-block@vger.kernel.org, axboe@kernel.dk
Cc: dm-devel@redhat.com, stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

From: Ming Lei <ming.lei@redhat.com>

dm-multipath is the only user of blk_mq_queue_inflight().  When
dm-multipath calls blk_mq_queue_inflight() to check if it has
outstanding IO it can get a false negative.  The reason for this is
blk_mq_rq_inflight() doesn't consider requests that are no longer
MQ_RQ_IN_FLIGHT but that are now MQ_RQ_COMPLETE (->complete isn't
called or finished yet) as "inflight".

This causes request-based dm-multipath's dm_wait_for_completion() to
return before all outstanding dm-multipath requests have actually
completed.  This breaks DM multipath's suspend functionality because
blk-mq requests complete after DM's suspend has finished -- which
shouldn't happen.

Fix this by considering any request not in the MQ_RQ_IDLE state
(so either MQ_RQ_COMPLETE or MQ_RQ_IN_FLIGHT) as "inflight" in
blk_mq_rq_inflight().

Fixes: 3c94d83cb3526 ("blk-mq: change blk_mq_queue_busy() to blk_mq_queue_inflight()")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-mq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4f57d27bfa73..e6219c27fc65 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -828,10 +828,10 @@ static bool blk_mq_rq_inflight(struct blk_mq_hw_ctx *hctx, struct request *rq,
 			       void *priv, bool reserved)
 {
 	/*
-	 * If we find a request that is inflight and the queue matches,
+	 * If we find a request that isn't idle and the queue matches,
 	 * we know the queue is busy. Return false to stop the iteration.
 	 */
-	if (rq->state == MQ_RQ_IN_FLIGHT && rq->q == hctx->queue) {
+	if (blk_mq_request_started(rq) && rq->q == hctx->queue) {
 		bool *busy = priv;
 
 		*busy = true;
-- 
2.15.0
