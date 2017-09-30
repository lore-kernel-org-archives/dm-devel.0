From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V5 1/8] blk-mq-sched: introduce blk_mq_sched_queue_depth()
Date: Sat, 30 Sep 2017 19:26:48 +0800
Message-ID: <20170930112655.31451-2-ming.lei@redhat.com>
References: <20170930112655.31451-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170930112655.31451-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, Omar Sandoval <osandov@fb.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

The following patch will use one hint to figure out
default queue depth for scheduler queue, so introduce
the helper of blk_mq_sched_queue_depth() for this purpose.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Tested-by: Tom Nguyen <tom81094@gmail.com>
Tested-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq-sched.c |  8 +-------
 block/blk-mq-sched.h | 11 +++++++++++
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index c5eac1eee442..8c09959bc0d0 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -588,13 +588,7 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 		return 0;
 	}
 
-	/*
-	 * Default to double of smaller one between hw queue_depth and 128,
-	 * since we don't split into sync/async like the old code did.
-	 * Additionally, this is a per-hw queue depth.
-	 */
-	q->nr_requests = 2 * min_t(unsigned int, q->tag_set->queue_depth,
-				   BLKDEV_MAX_RQ);
+	q->nr_requests = blk_mq_sched_queue_depth(q);
 
 	queue_for_each_hw_ctx(q, hctx, i) {
 		ret = blk_mq_sched_alloc_tags(q, hctx, i);
diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
index 9267d0b7c197..1d47f3fda1d0 100644
--- a/block/blk-mq-sched.h
+++ b/block/blk-mq-sched.h
@@ -96,4 +96,15 @@ static inline bool blk_mq_sched_needs_restart(struct blk_mq_hw_ctx *hctx)
 	return test_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state);
 }
 
+static inline unsigned blk_mq_sched_queue_depth(struct request_queue *q)
+{
+	/*
+	 * Default to double of smaller one between hw queue_depth and 128,
+	 * since we don't split into sync/async like the old code did.
+	 * Additionally, this is a per-hw queue depth.
+	 */
+	return 2 * min_t(unsigned int, q->tag_set->queue_depth,
+				   BLKDEV_MAX_RQ);
+}
+
 #endif
-- 
2.9.5
