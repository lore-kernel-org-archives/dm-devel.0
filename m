From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 8/9] dm: Fix two race conditions related to
 stopping and starting queues
Date: Wed, 31 Aug 2016 23:13:55 -0400
Message-ID: <20160901031355.GB4741@redhat.com>
References: <18db2396-cd4f-1d52-1ffa-21b9b512eaf4@sandisk.com>
	<82ff8574-8b73-8ba3-9098-741060f38fca@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <82ff8574-8b73-8ba3-9098-741060f38fca@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: axboe@kernel.dk, device-mapper development <dm-devel@redhat.com>, hch@lst.de
List-Id: dm-devel.ids

On Wed, Aug 31 2016 at  6:18pm -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> Ensure that all ongoing dm_mq_queue_rq() and dm_mq_requeue_request()
> calls have stopped before setting the "queue stopped" flag. This
> allows to remove the "queue stopped" test from dm_mq_queue_rq() and
> dm_mq_requeue_request(). Use BLK_MQ_S_STOPPED instead of
> QUEUE_FLAG_STOPPED.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>

At first glance, at a minimum this patch needs a better header.  It
seems you're doing 2 things:

1) using blk_mq_{freeze,unfreeze}_queue() actually makes dm_stop_queue()
   work for blk-mq?  Whereby fixing blk-mq race(s)?

2) switching away from QUEUE_FLAG_STOPPED to BLK_MQ_S_STOPPED (via
   blk_mq_queue_stopped)
   - not clear to me that dm-mq's use of QUEUE_FLAG_STOPPED wasn't fine;
     NVMe also uses it for blk-mq

> ---
>  drivers/md/dm-rq.c | 29 +++++++----------------------
>  1 file changed, 7 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index 8dc8cfb..b5db523 100644
> --- a/drivers/md/dm-rq.c
> +++ b/drivers/md/dm-rq.c
> @@ -78,7 +78,6 @@ void dm_start_queue(struct request_queue *q)
>  	if (!q->mq_ops)
>  		dm_old_start_queue(q);
>  	else {
> -		queue_flag_clear_unlocked(QUEUE_FLAG_STOPPED, q);
>  		blk_mq_start_stopped_hw_queues(q, true);
>  		blk_mq_kick_requeue_list(q);
>  	}
> @@ -98,13 +97,13 @@ void dm_stop_queue(struct request_queue *q)
>  {
>  	if (!q->mq_ops)
>  		dm_old_stop_queue(q);
> -	else {
> -		spin_lock_irq(q->queue_lock);
> -		queue_flag_set(QUEUE_FLAG_STOPPED, q);
> -		spin_unlock_irq(q->queue_lock);
> -
> +	else if (!blk_mq_queue_stopped(q)) {
> +		/* Wait until dm_mq_queue_rq() has finished. */
> +		blk_mq_freeze_queue(q);
> +		/* Avoid that requeuing could restart the queue. */
>  		blk_mq_cancel_requeue_work(q);
>  		blk_mq_stop_hw_queues(q);
> +		blk_mq_unfreeze_queue(q);
>  	}
>  }
>  
> @@ -318,13 +317,10 @@ static void dm_old_requeue_request(struct request *rq)
>  static void dm_mq_requeue_request(struct request *rq)
>  {
>  	struct request_queue *q = rq->q;
> -	unsigned long flags;
>  
>  	blk_mq_requeue_request(rq);
> -	spin_lock_irqsave(q->queue_lock, flags);
> -	if (!blk_queue_stopped(q))
> -		blk_mq_kick_requeue_list(q);
> -	spin_unlock_irqrestore(q->queue_lock, flags);
> +	WARN_ON_ONCE(blk_mq_queue_stopped(q));
> +	blk_mq_kick_requeue_list(q);
>  }
>  
>  static void dm_requeue_original_request(struct mapped_device *md,
> @@ -867,17 +863,6 @@ static int dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
>  		dm_put_live_table(md, srcu_idx);
>  	}
>  
> -	/*
> -	 * On suspend dm_stop_queue() handles stopping the blk-mq
> -	 * request_queue BUT: even though the hw_queues are marked
> -	 * BLK_MQ_S_STOPPED at that point there is still a race that
> -	 * is allowing block/blk-mq.c to call ->queue_rq against a
> -	 * hctx that it really shouldn't.  The following check guards
> -	 * against this rarity (albeit _not_ race-free).
> -	 */
> -	if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
> -		return BLK_MQ_RQ_QUEUE_BUSY;
> -
>  	if (ti->type->busy && ti->type->busy(ti))
>  		return BLK_MQ_RQ_QUEUE_BUSY;
>  
> -- 
> 2.9.3
> 
