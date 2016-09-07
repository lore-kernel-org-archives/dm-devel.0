From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: should blk-mq halt requeue processing while queue is frozen?
Date: Wed, 7 Sep 2016 12:41:14 -0400
Message-ID: <20160907164114.GA17578@redhat.com>
References: <20160901211718.GA12894@redhat.com>
 <20160901221823.GA13209@redhat.com>
 <f276cf3d-cad3-3e61-2903-754970f90445@sandisk.com>
 <20160901222654.GA13292@redhat.com>
 <938609b9-3a55-0ed3-ffeb-de27e1c1e864@sandisk.com>
 <20160901234754.GA13653@redhat.com>
 <6af010f8-0a8f-cf0e-d819-3b8e1c20b56e@sandisk.com>
 <20160902151213.GA17508@redhat.com>
 <20160902161059.GB17508@redhat.com>
 <aa663595-4890-adb1-a2b4-422b0b65b097@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <aa663595-4890-adb1-a2b4-422b0b65b097@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, hch@lst.de
List-Id: dm-devel.ids

On Fri, Sep 02 2016 at  6:42pm -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> However, I think
> in dm_stop_queue() all we need is to wait until queue_rq() has
> finished. How about adding new functions in the block layer core to
> realize this, e.g. something like in the attached (untested) patch?
> Busy looping should be avoided - see also the tests of the new
> "quiescing" flag.
> 
> Thanks,
> 
> Bart.

Comments inlined below.

> From e55a161ee4df7804767ed8faf9ddb698e8852b06 Mon Sep 17 00:00:00 2001
> From: Bart Van Assche <bart.vanassche@sandisk.com>
> Date: Fri, 2 Sep 2016 09:32:17 -0700
> Subject: [PATCH] blk-mq: Introduce blk_mq_quiesce_queue()
> 
> ---
>  block/blk-mq.c         | 50 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/blk-mq.h |  2 ++
>  include/linux/blkdev.h |  3 +++
>  3 files changed, 54 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 123d1ad..0320cd9 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -135,6 +135,46 @@ void blk_mq_unfreeze_queue(struct request_queue *q)
>  }
>  EXPORT_SYMBOL_GPL(blk_mq_unfreeze_queue);
>  
> +/**
> + * blk_mq_quiesce_queue - wait until all pending queue_rq calls have finished
> + *
> + * Prevent that new I/O requests are queued and wait until all pending
> + * queue_rq() calls have finished.
> + */
> +void blk_mq_quiesce_queue(struct request_queue *q)
> +{
> +	spin_lock_irq(q->queue_lock);
> +	WARN_ON_ONCE(blk_queue_quiescing(q));
> +	queue_flag_set(QUEUE_FLAG_QUIESCING, q);
> +	spin_unlock_irq(q->queue_lock);
> +
> +	atomic_inc_return(&q->mq_freeze_depth);
> +	blk_mq_run_hw_queues(q, false);
> +	synchronize_rcu();

Why the synchronize_rcu()?

Also, you're effectively open-coding blk_mq_freeze_queue_start() minus
the q->q_usage_counter mgmt.  Why not add a flag to conditionally manage
q->q_usage_counter to blk_mq_freeze_queue_start()?

> +	spin_lock_irq(q->queue_lock);
> +	WARN_ON_ONCE(!blk_queue_quiescing(q));
> +	queue_flag_clear(QUEUE_FLAG_QUIESCING, q);
> +	spin_unlock_irq(q->queue_lock);
> +}
> +EXPORT_SYMBOL_GPL(blk_mq_quiesce_queue);
> +
> +/**
> + * blk_mq_resume_queue - resume request processing
> + */
> +void blk_mq_resume_queue(struct request_queue *q)
> +{
> +	int freeze_depth;
> +
> +	freeze_depth = atomic_dec_return(&q->mq_freeze_depth);
> +	WARN_ON_ONCE(freeze_depth < 0);
> +	if (freeze_depth == 0)
> +		wake_up_all(&q->mq_freeze_wq);

Likewise, here you've open coded blk_mq_unfreeze_queue().  Adding a flag
to conditionally reinit q->q_usage_counter would be better.

But I'm concerned about blk_mq_{quiesce,resume}_queue vs
blk_mq_{freeze,unfreeze}_queue -- e.g. if "freeze" is nested after
"queue" (but before "resume") it would still need the q->q_usage_counter
management.  Your patch as-is would break the blk-mq freeze interface.

> +	blk_mq_run_hw_queues(q, false);
> +}
> +EXPORT_SYMBOL_GPL(blk_mq_resume_queue);
> +
>  void blk_mq_wake_waiters(struct request_queue *q)
>  {
>  	struct blk_mq_hw_ctx *hctx;
> @@ -506,6 +546,9 @@ static void blk_mq_requeue_work(struct work_struct *work)
>  	struct request *rq, *next;
>  	unsigned long flags;
>  
> +	if (blk_queue_quiescing(q))
> +		return;
> +
>  	spin_lock_irqsave(&q->requeue_lock, flags);
>  	list_splice_init(&q->requeue_list, &rq_list);
>  	spin_unlock_irqrestore(&q->requeue_lock, flags);
> @@ -806,6 +849,8 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
>  	 */
>  	flush_busy_ctxs(hctx, &rq_list);
>  
> +	rcu_read_lock();
> +
>  	/*
>  	 * If we have previous entries on our dispatch list, grab them
>  	 * and stuff them at the front for more fair dispatch.
> @@ -888,8 +933,11 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
>  		 *
>  		 * blk_mq_run_hw_queue() already checks the STOPPED bit
>  		 **/
> -		blk_mq_run_hw_queue(hctx, true);
> +		if (!blk_queue_quiescing(q))
> +			blk_mq_run_hw_queue(hctx, true);
>  	}
> +
> +	rcu_read_unlock();
>  }
>  
>  /*

Please explain this extra rcu_read_{lock,unlock}
