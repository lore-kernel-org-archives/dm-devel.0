From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [dm-devel] should blk-mq halt requeue processing while queue is
 frozen?
Date: Fri, 2 Sep 2016 15:42:33 -0700
Message-ID: <aa663595-4890-adb1-a2b4-422b0b65b097@sandisk.com>
References: <20160901204806.GA12742@redhat.com>
 <66e36ae7-19ff-058f-049a-3e91a62b19b3@sandisk.com>
 <20160901211718.GA12894@redhat.com> <20160901221823.GA13209@redhat.com>
 <f276cf3d-cad3-3e61-2903-754970f90445@sandisk.com>
 <20160901222654.GA13292@redhat.com>
 <938609b9-3a55-0ed3-ffeb-de27e1c1e864@sandisk.com>
 <20160901234754.GA13653@redhat.com>
 <6af010f8-0a8f-cf0e-d819-3b8e1c20b56e@sandisk.com>
 <20160902151213.GA17508@redhat.com> <20160902161059.GB17508@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
        boundary="------------3483500B203E42BB43E83497"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20160902161059.GB17508@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, hch@lst.de
List-Id: dm-devel.ids

--------------3483500B203E42BB43E83497
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit

On 09/02/2016 09:10 AM, Mike Snitzer wrote:
> On Fri, Sep 02 2016 at 11:12am -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
>
>> So in the case of blk-mq request-based DM: we cannot expect
>> blk_mq_freeze_queue(), during suspend, to complete if requests are
>> getting requeued to the blk-mq queue via BLK_MQ_RQ_QUEUE_BUSY.
>
> Looking closer at blk-mq.  Currently __blk_mq_run_hw_queue() will move
> any requeued requests to the hctx->dispatch list and then performs async
> blk_mq_run_hw_queue().
>
> To do what you hoped (have blk_mq_freeze_queue() discontinue all use of
> blk-mq hw queues during DM suspend) I think we'd need blk-mq to:
> 1) avoid processing requeued IO if blk_mq_freeze_queue() was used to
>    freeze the queue.  Meaning it'd have to hold requeued work longer
>    than it currently does.
> 2) Then once blk_mq_unfreeze_queue() is called it'd allow requeues to
>    proceed.
>
> This would be catering to a very specific requirement of DM (given it
> re-queues IO back to the request_queue during suspend).
>
> BUT all said, relative to request-based DM multipath, what we have is
> perfectly fine on a correctness level: the requests are re-queued
> because the blk-mq DM device is suspended.
>
> Unfortunately on an efficiency level DM suspend creates a lot of busy
> looping in blk-mq, with 100% cpu usage in a threads with names
> "kworker/3:1H", ideally we'd avoid that!

Hello Mike,

What blk_mq_freeze_queue() does is to wait until queue_rq() has finished 
*and* all pending requests have completed. However, I think in 
dm_stop_queue() all we need is to wait until queue_rq() has finished. 
How about adding new functions in the block layer core to realize this, 
e.g. something like in the attached (untested) patch? Busy looping 
should be avoided - see also the tests of the new "quiescing" flag.

Thanks,

Bart.

--------------3483500B203E42BB43E83497
Content-Type: text/x-patch;
	name="0001-blk-mq-Introduce-blk_mq_quiesce_queue.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-blk-mq-Introduce-blk_mq_quiesce_queue.patch"

From e55a161ee4df7804767ed8faf9ddb698e8852b06 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bart.vanassche@sandisk.com>
Date: Fri, 2 Sep 2016 09:32:17 -0700
Subject: [PATCH] blk-mq: Introduce blk_mq_quiesce_queue()

---
 block/blk-mq.c         | 50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/blk-mq.h |  2 ++
 include/linux/blkdev.h |  3 +++
 3 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 123d1ad..0320cd9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -135,6 +135,46 @@ void blk_mq_unfreeze_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(blk_mq_unfreeze_queue);
 
+/**
+ * blk_mq_quiesce_queue - wait until all pending queue_rq calls have finished
+ *
+ * Prevent that new I/O requests are queued and wait until all pending
+ * queue_rq() calls have finished.
+ */
+void blk_mq_quiesce_queue(struct request_queue *q)
+{
+	spin_lock_irq(q->queue_lock);
+	WARN_ON_ONCE(blk_queue_quiescing(q));
+	queue_flag_set(QUEUE_FLAG_QUIESCING, q);
+	spin_unlock_irq(q->queue_lock);
+
+	atomic_inc_return(&q->mq_freeze_depth);
+	blk_mq_run_hw_queues(q, false);
+	synchronize_rcu();
+
+	spin_lock_irq(q->queue_lock);
+	WARN_ON_ONCE(!blk_queue_quiescing(q));
+	queue_flag_clear(QUEUE_FLAG_QUIESCING, q);
+	spin_unlock_irq(q->queue_lock);
+}
+EXPORT_SYMBOL_GPL(blk_mq_quiesce_queue);
+
+/**
+ * blk_mq_resume_queue - resume request processing
+ */
+void blk_mq_resume_queue(struct request_queue *q)
+{
+	int freeze_depth;
+
+	freeze_depth = atomic_dec_return(&q->mq_freeze_depth);
+	WARN_ON_ONCE(freeze_depth < 0);
+	if (freeze_depth == 0)
+		wake_up_all(&q->mq_freeze_wq);
+
+	blk_mq_run_hw_queues(q, false);
+}
+EXPORT_SYMBOL_GPL(blk_mq_resume_queue);
+
 void blk_mq_wake_waiters(struct request_queue *q)
 {
 	struct blk_mq_hw_ctx *hctx;
@@ -506,6 +546,9 @@ static void blk_mq_requeue_work(struct work_struct *work)
 	struct request *rq, *next;
 	unsigned long flags;
 
+	if (blk_queue_quiescing(q))
+		return;
+
 	spin_lock_irqsave(&q->requeue_lock, flags);
 	list_splice_init(&q->requeue_list, &rq_list);
 	spin_unlock_irqrestore(&q->requeue_lock, flags);
@@ -806,6 +849,8 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 	 */
 	flush_busy_ctxs(hctx, &rq_list);
 
+	rcu_read_lock();
+
 	/*
 	 * If we have previous entries on our dispatch list, grab them
 	 * and stuff them at the front for more fair dispatch.
@@ -888,8 +933,11 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 		 *
 		 * blk_mq_run_hw_queue() already checks the STOPPED bit
 		 **/
-		blk_mq_run_hw_queue(hctx, true);
+		if (!blk_queue_quiescing(q))
+			blk_mq_run_hw_queue(hctx, true);
 	}
+
+	rcu_read_unlock();
 }
 
 /*
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index bd677bc..8fc07bb 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -248,6 +248,8 @@ void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 void blk_mq_freeze_queue(struct request_queue *q);
 void blk_mq_unfreeze_queue(struct request_queue *q);
 void blk_mq_freeze_queue_start(struct request_queue *q);
+void blk_mq_quiesce_queue(struct request_queue *q);
+void blk_mq_resume_queue(struct request_queue *q);
 int blk_mq_reinit_tagset(struct blk_mq_tag_set *set);
 
 void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e79055c..9b360fc 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -505,6 +505,7 @@ struct request_queue {
 #define QUEUE_FLAG_FUA	       24	/* device supports FUA writes */
 #define QUEUE_FLAG_FLUSH_NQ    25	/* flush not queueuable */
 #define QUEUE_FLAG_DAX         26	/* device supports DAX */
+#define QUEUE_FLAG_QUIESCING   27
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -595,6 +596,8 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_secure_erase(q) \
 	(test_bit(QUEUE_FLAG_SECERASE, &(q)->queue_flags))
 #define blk_queue_dax(q)	test_bit(QUEUE_FLAG_DAX, &(q)->queue_flags)
+#define blk_queue_quiescing(q)	test_bit(QUEUE_FLAG_QUIESCING,	\
+					 &(q)->queue_flags)
 
 #define blk_noretry_request(rq) \
 	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
-- 
2.9.3


--------------3483500B203E42BB43E83497--
