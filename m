From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 3/5] blk-mq: move actual issue into one helper
Date: Thu, 11 Jan 2018 14:01:57 +0800
Message-ID: <20180111060159.12991-4-ming.lei@redhat.com>
References: <20180111060159.12991-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180111060159.12991-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

No functional change, just to clean up code a bit, so that the following
change of using direct issue for blk_mq_request_bypass_insert() which is
needed by DM can be easier to do.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq.c | 39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 9aa24c9508f9..d27c1a265d54 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1684,15 +1684,38 @@ static blk_qc_t request_to_qc_t(struct blk_mq_hw_ctx *hctx, struct request *rq)
 	return blk_tag_to_qc_t(rq->internal_tag, hctx->queue_num, true);
 }
 
-static void __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
-					struct request *rq,
-					blk_qc_t *cookie)
+/* return true if insert is needed */
+static bool __blk_mq_issue_req(struct blk_mq_hw_ctx *hctx,
+			       struct request *rq,
+			       blk_qc_t *new_cookie,
+			       blk_status_t *ret)
 {
 	struct request_queue *q = rq->q;
 	struct blk_mq_queue_data bd = {
 		.rq = rq,
 		.last = true,
 	};
+
+	if (!blk_mq_get_driver_tag(rq, NULL, false))
+		return true;
+
+	if (!blk_mq_get_dispatch_budget(hctx)) {
+		blk_mq_put_driver_tag(rq);
+		return true;
+	}
+
+	*new_cookie = request_to_qc_t(hctx, rq);
+
+	*ret = q->mq_ops->queue_rq(hctx, &bd);
+
+	return false;
+}
+
+static void __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
+					struct request *rq,
+					blk_qc_t *cookie)
+{
+	struct request_queue *q = rq->q;
 	blk_qc_t new_cookie;
 	blk_status_t ret;
 	bool run_queue = true;
@@ -1706,22 +1729,14 @@ static void __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 	if (q->elevator)
 		goto insert;
 
-	if (!blk_mq_get_driver_tag(rq, NULL, false))
+	if (__blk_mq_issue_req(hctx, rq, &new_cookie, &ret))
 		goto insert;
 
-	if (!blk_mq_get_dispatch_budget(hctx)) {
-		blk_mq_put_driver_tag(rq);
-		goto insert;
-	}
-
-	new_cookie = request_to_qc_t(hctx, rq);
-
 	/*
 	 * For OK queue, we are done. For error, kill it. Any other
 	 * error (busy), just add it to our list as we previously
 	 * would have done
 	 */
-	ret = q->mq_ops->queue_rq(hctx, &bd);
 	switch (ret) {
 	case BLK_STS_OK:
 		*cookie = new_cookie;
-- 
2.9.5
