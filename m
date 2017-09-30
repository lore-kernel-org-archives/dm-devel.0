From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 5/5] dm-rq: improve I/O merge by dealing with underlying STS_RESOURCE
Date: Sat, 30 Sep 2017 19:46:52 +0800
Message-ID: <20170930114652.32441-6-ming.lei@redhat.com>
References: <20170930114652.32441-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170930114652.32441-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, linux-kernel@vger.kernel.org, Omar Sandoval <osandov@fb.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

If the underlying queue returns BLK_STS_RESOURCE, we let dm-rq
handle the requeue instead of blk-mq, then I/O merge can be
improved because underlying's out-of-resource can be perceived
and handled by dm-rq now.

Follows IOPS test of mpath on lpfc, fio(libaio, bs:4k, dio,
queue_depth:64, 8 jobs).

1) blk-mq none scheduler
-----------------------------------------------------
 IOPS(K)  |v4.14-rc2    |v4.14-rc2 with| v4.14-rc2 with
          |             |[1][2]        | [1] [2] [3]
-----------------------------------------------------
read      |       53.69 |       40.26  |       94.61
-----------------------------------------------------
randread  |       24.64 |       30.08  |       35.57
-----------------------------------------------------
write     |       39.55 |       41.51  |      216.84
-----------------------------------------------------
randwrite |       33.97 |       34.27  |       33.98
-----------------------------------------------------

2) blk-mq mq-deadline scheduler
-----------------------------------------------------
 IOPS(K)  |v4.14-rc2    |v4.14-rc2 with| v4.14-rc2 with
          |             |[1][2]        | [1] [2] [3]
-----------------------------------------------------
 IOPS(K)  |MQ-DEADLINE  |MQ-DEADLINE  |MQ-DEADLINE
-----------------------------------------------------
read      |       23.81 |       21.91 |       89.94
-----------------------------------------------------
randread  |       38.47 |       38.96 |       38.02
-----------------------------------------------------
write     |       39.52 |        40.2 |      225.75
-----------------------------------------------------
randwrite |        34.8 |       33.73 |       33.44
-----------------------------------------------------

[1] [PATCH V5 0/7] blk-mq-sched: improve sequential I/O performance(part 1)

	https://marc.info/?l=linux-block&m=150676854821077&w=2

[2] [PATCH V5 0/8] blk-mq: improve bio merge for none scheduler

	https://marc.info/?l=linux-block&m=150677085521416&w=2

[3] this patchset

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq.c     | 17 +----------------
 drivers/md/dm-rq.c | 14 ++++++++++++--
 2 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 9a3a561a63b5..58d2268f9733 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1467,17 +1467,6 @@ void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 	blk_mq_hctx_mark_pending(hctx, ctx);
 }
 
-static void blk_mq_request_direct_insert(struct blk_mq_hw_ctx *hctx,
-					 struct request *rq)
-{
-	spin_lock(&hctx->lock);
-	list_add_tail(&rq->queuelist, &hctx->dispatch);
-	set_bit(BLK_MQ_S_DISPATCH_BUSY, &hctx->state);
-	spin_unlock(&hctx->lock);
-
-	blk_mq_run_hw_queue(hctx, false);
-}
-
 /*
  * Should only be used carefully, when the caller knows we want to
  * bypass a potential IO scheduler on the target device.
@@ -1487,12 +1476,8 @@ blk_status_t blk_mq_request_bypass_insert(struct request *rq)
 	struct blk_mq_ctx *ctx = rq->mq_ctx;
 	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(rq->q, ctx->cpu);
 	blk_qc_t cookie;
-	blk_status_t ret;
 
-	ret = blk_mq_try_issue_directly(hctx, rq, &cookie, true);
-	if (ret == BLK_STS_RESOURCE)
-		blk_mq_request_direct_insert(hctx, rq);
-	return ret;
+	return blk_mq_try_issue_directly(hctx, rq, &cookie, true);
 }
 
 void blk_mq_insert_requests(struct blk_mq_hw_ctx *hctx, struct blk_mq_ctx *ctx,
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 2ef524bddd38..feb49c4d6fa2 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -405,7 +405,7 @@ static void end_clone_request(struct request *clone, blk_status_t error)
 	dm_complete_request(tio->orig, error);
 }
 
-static void dm_dispatch_clone_request(struct request *clone, struct request *rq)
+static blk_status_t dm_dispatch_clone_request(struct request *clone, struct request *rq)
 {
 	blk_status_t r;
 
@@ -417,6 +417,7 @@ static void dm_dispatch_clone_request(struct request *clone, struct request *rq)
 	if (r != BLK_STS_OK && r != BLK_STS_RESOURCE)
 		/* must complete clone in terms of original request */
 		dm_complete_request(rq, r);
+	return r;
 }
 
 static int dm_rq_bio_constructor(struct bio *bio, struct bio *bio_orig,
@@ -490,8 +491,10 @@ static int map_request(struct dm_rq_target_io *tio)
 	struct request *rq = tio->orig;
 	struct request *cache = tio->clone;
 	struct request *clone = cache;
+	blk_status_t ret;
 
 	r = ti->type->clone_and_map_rq(ti, rq, &tio->info, &clone);
+ again:
 	switch (r) {
 	case DM_MAPIO_SUBMITTED:
 		/* The target has taken the I/O to submit by itself later */
@@ -509,7 +512,14 @@ static int map_request(struct dm_rq_target_io *tio)
 		/* The target has remapped the I/O so dispatch it */
 		trace_block_rq_remap(clone->q, clone, disk_devt(dm_disk(md)),
 				     blk_rq_pos(rq));
-		dm_dispatch_clone_request(clone, rq);
+		ret = dm_dispatch_clone_request(clone, rq);
+		if (ret == BLK_STS_RESOURCE) {
+			if (!rq->q->mq_ops)
+				r = DM_MAPIO_DELAY_REQUEUE;
+			else
+				r = DM_MAPIO_REQUEUE;
+			goto again;
+		}
 		break;
 	case DM_MAPIO_REQUEUE:
 		/* The target wants to requeue the I/O */
-- 
2.9.5
