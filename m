From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 05/11] block: get rid of the trace rq insert wrapper
Date: Mon, 29 Jun 2020 16:43:08 -0700
Message-ID: <20200629234314.10509-6-chaitanya.kulkarni@wdc.com>
References: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, dm-devel@redhat.com
Cc: jack@suse.czi, rdunlap@infradead.org, sagi@grimberg.me, mingo@redhat.com, rostedt@goodmis.org, snitzer@redhat.com, agk@redhat.com, axboe@kernel.dk, paolo.valente@linaro.org, ming.lei@redhat.com, bvanassche@acm.org, fangguoju@gmail.com, colyli@suse.de, hch@lst.de, Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
List-Id: dm-devel.ids

Get rid of the wrapper for trace_block_rq_insert() and call the function
directly.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 block/bfq-iosched.c   | 4 +++-
 block/blk-mq-sched.c  | 6 ------
 block/blk-mq-sched.h  | 1 -
 block/kyber-iosched.c | 4 +++-
 block/mq-deadline.c   | 4 +++-
 5 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 50c8f034c01c..e2b9b700ed34 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -125,6 +125,8 @@
 #include <linux/delay.h>
 #include <linux/backing-dev.h>
 
+#include <trace/events/block.h>
+
 #include "blk.h"
 #include "blk-mq.h"
 #include "blk-mq-tag.h"
@@ -5507,7 +5509,7 @@ static void bfq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 
 	spin_unlock_irq(&bfqd->lock);
 
-	blk_mq_sched_request_inserted(rq);
+	trace_block_rq_insert(rq);
 
 	spin_lock_irq(&bfqd->lock);
 	bfqq = bfq_init_rq(rq);
diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index a3cade16ef80..20b6a59fbd5a 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -407,12 +407,6 @@ bool blk_mq_sched_try_insert_merge(struct request_queue *q, struct request *rq)
 }
 EXPORT_SYMBOL_GPL(blk_mq_sched_try_insert_merge);
 
-void blk_mq_sched_request_inserted(struct request *rq)
-{
-	trace_block_rq_insert(rq);
-}
-EXPORT_SYMBOL_GPL(blk_mq_sched_request_inserted);
-
 static bool blk_mq_sched_bypass_insert(struct blk_mq_hw_ctx *hctx,
 				       bool has_sched,
 				       struct request *rq)
diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
index 126021fc3a11..04c40c695bf0 100644
--- a/block/blk-mq-sched.h
+++ b/block/blk-mq-sched.h
@@ -10,7 +10,6 @@ void blk_mq_sched_free_hctx_data(struct request_queue *q,
 
 void blk_mq_sched_assign_ioc(struct request *rq);
 
-void blk_mq_sched_request_inserted(struct request *rq);
 bool blk_mq_sched_try_merge(struct request_queue *q, struct bio *bio,
 		unsigned int nr_segs, struct request **merged_request);
 bool __blk_mq_sched_bio_merge(struct request_queue *q, struct bio *bio,
diff --git a/block/kyber-iosched.c b/block/kyber-iosched.c
index a38c5ab103d1..e42d78deee90 100644
--- a/block/kyber-iosched.c
+++ b/block/kyber-iosched.c
@@ -13,6 +13,8 @@
 #include <linux/module.h>
 #include <linux/sbitmap.h>
 
+#include <trace/events/block.h>
+
 #include "blk.h"
 #include "blk-mq.h"
 #include "blk-mq-debugfs.h"
@@ -602,7 +604,7 @@ static void kyber_insert_requests(struct blk_mq_hw_ctx *hctx,
 			list_move_tail(&rq->queuelist, head);
 		sbitmap_set_bit(&khd->kcq_map[sched_domain],
 				rq->mq_ctx->index_hw[hctx->type]);
-		blk_mq_sched_request_inserted(rq);
+		trace_block_rq_insert(rq);
 		spin_unlock(&kcq->lock);
 	}
 }
diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index b57470e154c8..f3631a287466 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -18,6 +18,8 @@
 #include <linux/rbtree.h>
 #include <linux/sbitmap.h>
 
+#include <trace/events/block.h>
+
 #include "blk.h"
 #include "blk-mq.h"
 #include "blk-mq-debugfs.h"
@@ -496,7 +498,7 @@ static void dd_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 	if (blk_mq_sched_try_insert_merge(q, rq))
 		return;
 
-	blk_mq_sched_request_inserted(rq);
+	trace_block_rq_insert(rq);
 
 	if (at_head || blk_rq_is_passthrough(rq)) {
 		if (at_head)
-- 
2.26.0
