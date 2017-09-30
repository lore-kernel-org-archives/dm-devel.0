From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V5 7/8] blk-mq-sched: refactor blk_mq_sched_try_merge()
Date: Sat, 30 Sep 2017 19:26:54 +0800
Message-ID: <20170930112655.31451-8-ming.lei@redhat.com>
References: <20170930112655.31451-1-ming.lei@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170930112655.31451-1-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, Omar Sandoval <osandov@fb.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

This patch introduces one function __blk_mq_try_merge()
which will be resued for bio merge to sw queue in
the following patch.

No functional change.

Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Tested-by: Tom Nguyen <tom81094@gmail.com>
Tested-by: Paolo Valente <paolo.valente@linaro.org>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq-sched.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 8c09959bc0d0..a58f4746317c 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -222,12 +222,11 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ctx *hctx)
 	}
 }
 
-bool blk_mq_sched_try_merge(struct request_queue *q, struct bio *bio,
-			    struct request **merged_request)
+static bool __blk_mq_try_merge(struct request_queue *q,
+		struct bio *bio, struct request **merged_request,
+		struct request *rq, enum elv_merge type)
 {
-	struct request *rq;
-
-	switch (elv_merge(q, &rq, bio)) {
+	switch (type) {
 	case ELEVATOR_BACK_MERGE:
 		if (!blk_mq_sched_allow_merge(q, rq, bio))
 			return false;
@@ -250,6 +249,15 @@ bool blk_mq_sched_try_merge(struct request_queue *q, struct bio *bio,
 		return false;
 	}
 }
+
+bool blk_mq_sched_try_merge(struct request_queue *q, struct bio *bio,
+		struct request **merged_request)
+{
+	struct request *rq;
+	enum elv_merge type = elv_merge(q, &rq, bio);
+
+	return __blk_mq_try_merge(q, bio, merged_request, rq, type);
+}
 EXPORT_SYMBOL_GPL(blk_mq_sched_try_merge);
 
 /*
-- 
2.9.5
