From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm rq: Avoid that request processing stalls sporadically
Date: Thu, 18 Jan 2018 11:50:51 -0500
Message-ID: <20180118165050.GA19734@redhat.com>
References: <20180118163707.11825-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180118163707.11825-1-bart.vanassche@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

On Thu, Jan 18 2018 at 11:37am -0500,
Bart Van Assche <bart.vanassche@wdc.com> wrote:

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
> -- 
> 2.15.1
> 

Sorry but we need to understand why you still need this.

The issue you say it was originally intended to fix _should_ be
addressed with this change:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.16&id=4dd6edd23e7ea971efddc303f9e67eb79e95808e

So if you still feel you need to blindly kick the queue then it is very
likely a bug in blk-mq (either its RESTART hueristics or whatever
internal implementation is lacking)

Did you try Ming's RFC patch to "fixup RESTART" before resorting to the
above again?, see: https://patchwork.kernel.org/patch/10172315/

Thanks,
Mike
