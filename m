From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: should blk-mq halt requeue processing while queue is frozen?
Date: Fri, 2 Sep 2016 20:34:45 -0400
Message-ID: <20160903003445.GA20058@redhat.com>
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

> On 09/02/2016 09:10 AM, Mike Snitzer wrote:
> >On Fri, Sep 02 2016 at 11:12am -0400,
> >Mike Snitzer <snitzer@redhat.com> wrote:
> >
> >>So in the case of blk-mq request-based DM: we cannot expect
> >>blk_mq_freeze_queue(), during suspend, to complete if requests are
> >>getting requeued to the blk-mq queue via BLK_MQ_RQ_QUEUE_BUSY.
> >
> >Looking closer at blk-mq.  Currently __blk_mq_run_hw_queue() will move
> >any requeued requests to the hctx->dispatch list and then performs async
> >blk_mq_run_hw_queue().
> >
> >To do what you hoped (have blk_mq_freeze_queue() discontinue all use of
> >blk-mq hw queues during DM suspend) I think we'd need blk-mq to:
> >1) avoid processing requeued IO if blk_mq_freeze_queue() was used to
> >   freeze the queue.  Meaning it'd have to hold requeued work longer
> >   than it currently does.
> >2) Then once blk_mq_unfreeze_queue() is called it'd allow requeues to
> >   proceed.
> >
> >This would be catering to a very specific requirement of DM (given it
> >re-queues IO back to the request_queue during suspend).
> >
> >BUT all said, relative to request-based DM multipath, what we have is
> >perfectly fine on a correctness level: the requests are re-queued
> >because the blk-mq DM device is suspended.
> >
> >Unfortunately on an efficiency level DM suspend creates a lot of busy
> >looping in blk-mq, with 100% cpu usage in a threads with names
> >"kworker/3:1H", ideally we'd avoid that!
> 
> Hello Mike,
> 
> What blk_mq_freeze_queue() does is to wait until queue_rq() has
> finished *and* all pending requests have completed.

Right, I had a look at blk-mq this afternoon and it is clear that the
current implementation of blk-mq's freeze (in terms of percpu
q->q_usage_counter dropping to zero) won't fly for the DM requeue
usecase.

> However, I think
> in dm_stop_queue() all we need is to wait until queue_rq() has
> finished. How about adding new functions in the block layer core to
> realize this, e.g. something like in the attached (untested) patch?
> Busy looping should be avoided - see also the tests of the new
> "quiescing" flag.

I'll take a closer look at your patch next week.

The reuse of the mq_freeze_depth to achieve this quiesce/resume will
need closer review -- likely by Jens.

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

Yes, those are the correct hooks to place code to conditionally
short-circuit normal blk-mq operation.
