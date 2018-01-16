From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH v4-mike 2/2] blk-mq: issue request directly for blk_insert_cloned_request
Date: Tue, 16 Jan 2018 10:01:48 -0500
Message-ID: <20180116150148.21145-2-snitzer@redhat.com>
References: <20180116150148.21145-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180116150148.21145-1-snitzer@redhat.com>
In-Reply-To: <20180116015710.GF3213@ming.t460p>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: Ming Lei <tom.leiming@gmail.com>, hch@lst.de, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

From: Ming Lei <ming.lei@redhat.com>

blk_insert_cloned_request() is called in fast path of dm-rq driver, and
in this function we append request to hctx->dispatch_list of the underlying
queue directly.

1) This way isn't efficient enough because hctx lock is always required

2) With blk_insert_cloned_request(), we bypass underlying queue's IO
scheduler totally, and depend on DM rq driver to do IO schedule
completely.  But DM rq driver can't get underlying queue's dispatch
feedback at all, and this information is extreamly useful for IO merge.
Without that IO merge can't be done basically by blk-mq, which causes
very bad sequential IO performance.

Fix this by having blk_insert_cloned_request() make use of
blk_mq_try_issue_directly() via blk_mq_request_direct_issue().
blk_mq_request_direct_issue() allows a request to be dispatched to be
issue directly to the underlying queue and provides dispatch result to
dm-rq and blk-mq.

With this, the DM's blk-mq sequential IO performance is vastly
improved (as much as 3X in mpath/virtio-scsi testing).

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c   |  3 +--
 block/blk-mq.c     | 42 ++++++++++++++++++++++++++++++++++++------
 block/blk-mq.h     |  3 +++
 drivers/md/dm-rq.c | 19 ++++++++++++++++---
 4 files changed, 56 insertions(+), 11 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 7ba607527487..55f338020254 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2500,8 +2500,7 @@ blk_status_t blk_insert_cloned_request(struct request_queue *q, struct request *
 		 * bypass a potential scheduler on the bottom device for
 		 * insert.
 		 */
-		blk_mq_request_bypass_insert(rq, true);
-		return BLK_STS_OK;
+		return blk_mq_request_direct_issue(rq);
 	}
 
 	spin_lock_irqsave(q->queue_lock, flags);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 55f3a27fb2e6..3168a13cb012 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1706,6 +1706,12 @@ static blk_status_t __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 	blk_qc_t new_cookie;
 	blk_status_t ret = BLK_STS_OK;
 	bool run_queue = true;
+	/*
+	 * If @cookie is NULL do not insert the request, this mode is used
+	 * by blk_insert_cloned_request() via blk_mq_request_direct_issue()
+	 */
+	bool dispatch_only = !cookie;
+	bool need_insert = false;
 
 	/* RCU or SRCU read lock is needed before checking quiesced flag */
 	if (blk_mq_hctx_stopped(hctx) || blk_queue_quiesced(q)) {
@@ -1713,25 +1719,38 @@ static blk_status_t __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 		goto insert;
 	}
 
-	if (q->elevator)
+	if (q->elevator && !dispatch_only)
 		goto insert;
 
 	if (!blk_mq_get_driver_tag(rq, NULL, false))
-		goto insert;
+		need_insert = true;
 
-	if (!blk_mq_get_dispatch_budget(hctx)) {
+	if (!need_insert && !blk_mq_get_dispatch_budget(hctx)) {
 		blk_mq_put_driver_tag(rq);
+		need_insert = true;
+	}
+
+	if (need_insert) {
+		if (dispatch_only)
+			return BLK_STS_RESOURCE;
 		goto insert;
 	}
 
 	new_cookie = request_to_qc_t(hctx, rq);
 
+	ret = q->mq_ops->queue_rq(hctx, &bd);
+
+	if (dispatch_only) {
+		if (ret == BLK_STS_RESOURCE)
+			__blk_mq_requeue_request(rq);
+		return ret;
+	}
+
 	/*
 	 * For OK queue, we are done. For error, kill it. Any other
 	 * error (busy), just add it to our list as we previously
 	 * would have done
 	 */
-	ret = q->mq_ops->queue_rq(hctx, &bd);
 	switch (ret) {
 	case BLK_STS_OK:
 		*cookie = new_cookie;
@@ -1746,8 +1765,11 @@ static blk_status_t __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 	}
 
 insert:
-	blk_mq_sched_insert_request(rq, false, run_queue, false,
-					hctx->flags & BLK_MQ_F_BLOCKING);
+	if (!dispatch_only)
+		blk_mq_sched_insert_request(rq, false, run_queue, false,
+				hctx->flags & BLK_MQ_F_BLOCKING);
+	else
+		blk_mq_request_bypass_insert(rq, run_queue);
 	return ret;
 }
 
@@ -1767,6 +1789,14 @@ static blk_status_t blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 	return ret;
 }
 
+blk_status_t blk_mq_request_direct_issue(struct request *rq)
+{
+	struct blk_mq_ctx *ctx = rq->mq_ctx;
+	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(rq->q, ctx->cpu);
+
+	return blk_mq_try_issue_directly(hctx, rq, NULL);
+}
+
 static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 {
 	const int is_sync = op_is_sync(bio->bi_opf);
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 8591a54d989b..e3ebc93646ca 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -74,6 +74,9 @@ void blk_mq_request_bypass_insert(struct request *rq, bool run_queue);
 void blk_mq_insert_requests(struct blk_mq_hw_ctx *hctx, struct blk_mq_ctx *ctx,
 				struct list_head *list);
 
+/* Used by blk_insert_cloned_request() to issue request directly */
+blk_status_t blk_mq_request_direct_issue(struct request *rq);
+
 /*
  * CPU -> queue mappings
  */
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index c28357f5cb0e..e0d84b17c1cd 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -395,7 +395,7 @@ static void end_clone_request(struct request *clone, blk_status_t error)
 	dm_complete_request(tio->orig, error);
 }
 
-static void dm_dispatch_clone_request(struct request *clone, struct request *rq)
+static blk_status_t dm_dispatch_clone_request(struct request *clone, struct request *rq)
 {
 	blk_status_t r;
 
@@ -404,9 +404,10 @@ static void dm_dispatch_clone_request(struct request *clone, struct request *rq)
 
 	clone->start_time = jiffies;
 	r = blk_insert_cloned_request(clone->q, clone);
-	if (r)
+	if (r != BLK_STS_OK && r != BLK_STS_RESOURCE)
 		/* must complete clone in terms of original request */
 		dm_complete_request(rq, r);
+	return r;
 }
 
 static int dm_rq_bio_constructor(struct bio *bio, struct bio *bio_orig,
@@ -476,8 +477,10 @@ static int map_request(struct dm_rq_target_io *tio)
 	struct mapped_device *md = tio->md;
 	struct request *rq = tio->orig;
 	struct request *clone = NULL;
+	blk_status_t ret;
 
 	r = ti->type->clone_and_map_rq(ti, rq, &tio->info, &clone);
+ check_again:
 	switch (r) {
 	case DM_MAPIO_SUBMITTED:
 		/* The target has taken the I/O to submit by itself later */
@@ -492,7 +495,17 @@ static int map_request(struct dm_rq_target_io *tio)
 		/* The target has remapped the I/O so dispatch it */
 		trace_block_rq_remap(clone->q, clone, disk_devt(dm_disk(md)),
 				     blk_rq_pos(rq));
-		dm_dispatch_clone_request(clone, rq);
+		ret = dm_dispatch_clone_request(clone, rq);
+		if (ret == BLK_STS_RESOURCE) {
+			blk_rq_unprep_clone(clone);
+			tio->ti->type->release_clone_rq(clone);
+			tio->clone = NULL;
+			if (!rq->q->mq_ops)
+				r = DM_MAPIO_DELAY_REQUEUE;
+			else
+				r = DM_MAPIO_REQUEUE;
+			goto check_again;
+		}
 		break;
 	case DM_MAPIO_REQUEUE:
 		/* The target wants to requeue the I/O */
-- 
2.15.0
