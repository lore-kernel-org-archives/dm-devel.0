From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 1/9] blk-mq: Introduce blk_mq_queue_stopped()
Date: Wed, 31 Aug 2016 15:15:39 -0700
Message-ID: <4c2aead4-cef6-00ae-7cb7-44fd74050de4@sandisk.com>
References: <18db2396-cd4f-1d52-1ffa-21b9b512eaf4@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <18db2396-cd4f-1d52-1ffa-21b9b512eaf4@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

The function blk_queue_stopped() allows to test whether or not a
non-mq queue has been stopped. Introduce a helper function that
allows block drivers to query easily whether or not one or more
hardware contexts of a blk-mq queue have been stopped.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c         | 17 +++++++++++++++++
 include/linux/blk-mq.h |  1 +
 2 files changed, 18 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 0dcafa6..6929a52 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -965,6 +965,23 @@ void blk_mq_run_hw_queues(struct request_queue *q, bool async)
 }
 EXPORT_SYMBOL(blk_mq_run_hw_queues);
 
+/*
+ * The caller is responsible for serializing this function against
+ * blk_mq_{start,stop}_hw_queue().
+ */
+bool blk_mq_queue_stopped(struct request_queue *q)
+{
+	struct blk_mq_hw_ctx *hctx;
+	int i;
+
+	queue_for_each_hw_ctx(q, hctx, i)
+		if (test_bit(BLK_MQ_S_STOPPED, &hctx->state))
+			return true;
+
+	return false;
+}
+EXPORT_SYMBOL(blk_mq_queue_stopped);
+
 void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx)
 {
 	cancel_delayed_work(&hctx->run_work);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index e43bbff..bd677bc 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -235,6 +235,7 @@ void blk_mq_kick_requeue_list(struct request_queue *q);
 void blk_mq_abort_requeue_list(struct request_queue *q);
 void blk_mq_complete_request(struct request *rq, int error);
 
+bool blk_mq_queue_stopped(struct request_queue *q);
 void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx);
 void blk_mq_start_hw_queue(struct blk_mq_hw_ctx *hctx);
 void blk_mq_stop_hw_queues(struct request_queue *q);
-- 
2.9.3
