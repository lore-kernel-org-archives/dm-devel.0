From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] dm rq: Avoid that request processing stalls sporadically
Date: Fri, 19 Jan 2018 08:11:37 +0800
Message-ID: <20180119001136.GA4712@ming.t460p>
References: <20180118163707.11825-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180118163707.11825-1-bart.vanassche@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Jan 18, 2018 at 08:37:07AM -0800, Bart Van Assche wrote:
> If the .queue_rq() implementation of a block driver returns
> BLK_STS_RESOURCE then that block driver is responsible for
> rerunning the queue once the condition that caused it to return
> BLK_STS_RESOURCE has been cleared. The dm-mpath driver tells the
> dm core to requeue a request if e.g. not enough memory is
> available for cloning a request or if the underlying path is
> busy. Since the dm-mpath driver does not receive any kind of
> notification if the condition that caused it to return "requeue"
> is cleared, the only solution to avoid that dm-mpath request
> processing stalls is to call blk_mq_delay_run_hw_queue(). Hence
> this patch.
> 
> Fixes: ec3eaf9a6731 ("dm mpath: don't call blk_mq_delay_run_hw_queue() in case of BLK_STS_RESOURCE")
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/md/dm-rq.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index f16096af879a..c59c59cfd2a5 100644
> --- a/drivers/md/dm-rq.c
> +++ b/drivers/md/dm-rq.c
> @@ -761,6 +761,7 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
>  		/* Undo dm_start_request() before requeuing */
>  		rq_end_stats(md, rq);
>  		rq_completed(md, rq_data_dir(rq), false);
> +		blk_mq_delay_run_hw_queue(hctx, 100/*ms*/);
>  		return BLK_STS_RESOURCE;
>  	}
>  

Nak.

It still takes a bit time to add this request to hctx->dispatch_list
from here, so suppose the time is longer than 100ms because of interrupt
, preemption or whatever, this request can't be observed in the scheduled
run queue(__blk_mq_run_hw_queue).

Not mention it is just a ugly workaround, which degrades performance
a lot.

-- 
Ming
