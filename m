From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V5 5/8] block: add check on elevator for supporting bio merge via hashtable from blk-mq sw queue
Date: Sat, 30 Sep 2017 19:26:52 +0800
Message-ID: <20170930112655.31451-6-ming.lei@redhat.com>
References: <20170930112655.31451-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170930112655.31451-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, Omar Sandoval <osandov@fb.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

blk_mq_sched_try_merge() will be reused in following patches
to support bio merge to blk-mq sw queue, so add checkes to
related functions which are called from blk_mq_sched_try_merge().

Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Tested-by: Tom Nguyen <tom81094@gmail.com>
Tested-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/elevator.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/block/elevator.c b/block/elevator.c
index e11c7873fc21..2424aea85393 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -71,6 +71,10 @@ bool elv_bio_merge_ok(struct request *rq, struct bio *bio)
 	if (!blk_rq_merge_ok(rq, bio))
 		return false;
 
+	/* We need to support to merge bio from sw queue */
+	if (!rq->q->elevator)
+		return true;
+
 	if (!elv_iosched_allow_bio_merge(rq, bio))
 		return false;
 
@@ -449,6 +453,10 @@ static enum elv_merge __elv_merge(struct request_queue *q,
 		return ELEVATOR_BACK_MERGE;
 	}
 
+	/* no elevator when merging bio to blk-mq sw queue */
+	if (!e)
+		return ELEVATOR_NO_MERGE;
+
 	if (e->uses_mq && e->type->ops.mq.request_merge)
 		return e->type->ops.mq.request_merge(q, req, bio);
 	else if (!e->uses_mq && e->type->ops.sq.elevator_merge_fn)
@@ -711,6 +719,10 @@ struct request *elv_latter_request(struct request_queue *q, struct request *rq)
 {
 	struct elevator_queue *e = q->elevator;
 
+	/* no elevator when merging bio to blk-mq sw queue */
+	if (!e)
+		return NULL;
+
 	if (e->uses_mq && e->type->ops.mq.next_request)
 		return e->type->ops.mq.next_request(q, rq);
 	else if (!e->uses_mq && e->type->ops.sq.elevator_latter_req_fn)
@@ -723,6 +735,10 @@ struct request *elv_former_request(struct request_queue *q, struct request *rq)
 {
 	struct elevator_queue *e = q->elevator;
 
+	/* no elevator when merging bio to blk-mq sw queue */
+	if (!e)
+		return NULL;
+
 	if (e->uses_mq && e->type->ops.mq.former_request)
 		return e->type->ops.mq.former_request(q, rq);
 	if (!e->uses_mq && e->type->ops.sq.elevator_former_req_fn)
-- 
2.9.5
