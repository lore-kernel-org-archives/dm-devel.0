From: Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH] blk-mq: fixup RESTART when queue becomes idle
Date: Thu, 18 Jan 2018 10:41:24 +0800
Message-ID: <20180118024124.8079-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-kernel@vger.kernel.org, Omar Sandoval <osandov@fb.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

BLK_STS_RESOURCE can be returned from driver when any resource
is running out of. And the resource may not be related with tags,
such as kmalloc(GFP_ATOMIC), when queue is idle under this kind of
BLK_STS_RESOURCE, restart can't work any more, then IO hang may
be caused.

Most of drivers may call kmalloc(GFP_ATOMIC) in IO path, and almost
all returns BLK_STS_RESOURCE under this situation. But for dm-mpath,
it may be triggered a bit easier since the request pool of underlying
queue may be consumed up much easier. But in reality, it is still not
easy to trigger it. I run all kinds of test on dm-mpath/scsi-debug
with all kinds of scsi_debug parameters, can't trigger this issue
at all. But finally it is triggered in Bart's SRP test, which seems
made by genius, :-)

This patch deals with this situation by running the queue again when
queue is found idle in timeout handler.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---

Another approach is to do the check after BLK_STS_RESOURCE is returned
from .queue_rq() and BLK_MQ_S_SCHED_RESTART is set, that way may introduce
a bit cost in hot path, and it was V1 of this patch actually, please see
that in the following link:

	https://github.com/ming1/linux/commit/68a66900f3647ea6751aab2848b1e5eef508feaa

Or other better ways?

 block/blk-mq.c | 83 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 82 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 6e3f77829dcc..4d4af8d712da 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -896,6 +896,85 @@ static void blk_mq_terminate_expired(struct blk_mq_hw_ctx *hctx,
 		blk_mq_rq_timed_out(rq, reserved);
 }
 
+struct hctx_busy_data {
+	struct blk_mq_hw_ctx *hctx;
+	bool reserved;
+	bool busy;
+};
+
+static bool check_busy_hctx(struct sbitmap *sb, unsigned int bitnr, void *data)
+{
+	struct hctx_busy_data *busy_data = data;
+	struct blk_mq_hw_ctx *hctx = busy_data->hctx;
+	struct request *rq;
+
+	if (busy_data->reserved)
+		bitnr += hctx->tags->nr_reserved_tags;
+
+	rq = hctx->tags->static_rqs[bitnr];
+	if (blk_mq_rq_state(rq) == MQ_RQ_IN_FLIGHT) {
+		busy_data->busy = true;
+		return false;
+	}
+	return true;
+}
+
+/* Check if there is any in-flight request */
+static bool blk_mq_hctx_is_busy(struct blk_mq_hw_ctx *hctx)
+{
+	struct hctx_busy_data data = {
+		.hctx = hctx,
+		.busy = false,
+		.reserved = true,
+	};
+
+	sbitmap_for_each_set(&hctx->tags->breserved_tags.sb,
+			check_busy_hctx, &data);
+	if (data.busy)
+		return true;
+
+	data.reserved = false;
+	sbitmap_for_each_set(&hctx->tags->bitmap_tags.sb,
+			check_busy_hctx, &data);
+	if (data.busy)
+		return true;
+
+	return false;
+}
+
+static void blk_mq_fixup_restart(struct blk_mq_hw_ctx *hctx)
+{
+	if (test_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state)) {
+		bool busy;
+
+		/*
+		 * If this hctx is still marked as RESTART, and there
+		 * isn't any in-flight requests, we have to run queue
+		 * here to prevent IO from hanging.
+		 *
+		 * BLK_STS_RESOURCE can be returned from driver when any
+		 * resource is running out of. And the resource may not
+		 * be related with tags, such as kmalloc(GFP_ATOMIC), when
+		 * queue is idle under this kind of BLK_STS_RESOURCE, restart
+		 * can't work any more, then IO hang may be caused.
+		 *
+		 * The counter-pair of the following barrier is the one
+		 * in blk_mq_put_driver_tag() after returning BLK_STS_RESOURCE
+		 * from ->queue_rq().
+		 */
+		smp_mb();
+
+		busy = blk_mq_hctx_is_busy(hctx);
+		if (!busy) {
+			printk(KERN_WARNING "blk-mq: fixup RESTART\n");
+			printk(KERN_WARNING "\t If this message is shown"
+			       " a bit often, please report the issue to"
+			       " linux-block@vger.kernel.org\n");
+			blk_mq_run_hw_queue(hctx, true);
+		}
+	}
+}
+
 static void blk_mq_timeout_work(struct work_struct *work)
 {
 	struct request_queue *q =
@@ -966,8 +1045,10 @@ static void blk_mq_timeout_work(struct work_struct *work)
 		 */
 		queue_for_each_hw_ctx(q, hctx, i) {
 			/* the hctx may be unmapped, so check it here */
-			if (blk_mq_hw_queue_mapped(hctx))
+			if (blk_mq_hw_queue_mapped(hctx)) {
 				blk_mq_tag_idle(hctx);
+				blk_mq_fixup_restart(hctx);
+			}
 		}
 	}
 	blk_queue_exit(q);
-- 
2.9.5
