From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [for-4.16 PATCH v5 2/3] blk-mq: improve DM's blk-mq IO merging
 via blk_insert_cloned_request feedback
Date: Wed, 17 Jan 2018 08:34:53 -0700
Message-ID: <a3e24070-6436-c672-14bb-90938823f182@kernel.dk>
References: <20180117043338.25839-1-snitzer@redhat.com>
 <20180117043338.25839-4-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180117043338.25839-4-snitzer@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Ming Lei <tom.leiming@gmail.com>, hch@lst.de, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On 1/16/18 9:33 PM, Mike Snitzer wrote:
> From: Ming Lei <ming.lei@redhat.com>
> 
> blk_insert_cloned_request() is called in the fast path of a dm-rq driver
> (e.g. blk-mq request-based DM mpath).  blk_insert_cloned_request() uses
> blk_mq_request_bypass_insert() to directly append the request to the
> blk-mq hctx->dispatch_list of the underlying queue.
> 
> 1) This way isn't efficient enough because the hctx spinlock is always
> used.
> 
> 2) With blk_insert_cloned_request(), we completely bypass underlying
> queue's elevator and depend on the upper-level dm-rq driver's elevator
> to schedule IO.  But dm-rq currently can't get the underlying queue's
> dispatch feedback at all.  Without knowing whether a request was issued
> or not (e.g. due to underlying queue being busy) the dm-rq elevator will
> not be able to provide effective IO merging (as a side-effect of dm-rq
> currently blindly destaging a request from its elevator only to requeue
> it after a delay, which kills any opportunity for merging).  This
> obviously causes very bad sequential IO performance.
> 
> Fix this by updating blk_insert_cloned_request() to use
> blk_mq_request_direct_issue().  blk_mq_request_direct_issue() allows a
> request to be issued directly to the underlying queue and returns the
> dispatch feedback (blk_status_t).  If blk_mq_request_direct_issue()
> returns BLK_SYS_RESOURCE the dm-rq driver will now use DM_MAPIO_REQUEUE
> to _not_ destage the request.  Whereby preserving the opportunity to
> merge IO.
> 
> With this, request-based DM's blk-mq sequential IO performance is vastly
> improved (as much as 3X in mpath/virtio-scsi testing).

This looks better. Two minor nit picks:

> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index c117c2baf2c9..0b64f7210a89 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1706,7 +1706,8 @@ static blk_status_t __blk_mq_issue_directly(struct blk_mq_hw_ctx *hctx,
>  	blk_qc_t new_cookie;
>  	blk_status_t ret;
>  
> -	new_cookie = request_to_qc_t(hctx, rq);
> +	if (cookie)
> +		new_cookie = request_to_qc_t(hctx, rq);
>  
>  	/*
>  	 * For OK queue, we are done. For error, caller may kill it.
> @@ -1716,13 +1717,15 @@ static blk_status_t __blk_mq_issue_directly(struct blk_mq_hw_ctx *hctx,
>  	ret = q->mq_ops->queue_rq(hctx, &bd);
>  	switch (ret) {
>  	case BLK_STS_OK:
> -		*cookie = new_cookie;
> +		if (cookie)
> +			*cookie = new_cookie;
>  		break;
>  	case BLK_STS_RESOURCE:
>  		__blk_mq_requeue_request(rq);
>  		break;
>  	default:
> -		*cookie = BLK_QC_T_NONE;
> +		if (cookie)
> +			*cookie = BLK_QC_T_NONE;
>  		break;
>  	}

Instead of adding these three conditions, always pass in a valid pointer
to a cookie and get rid of them.

> @@ -1731,15 +1734,20 @@ static blk_status_t __blk_mq_issue_directly(struct blk_mq_hw_ctx *hctx,
>  
>  static void __blk_mq_fallback_to_insert(struct blk_mq_hw_ctx *hctx,
>  					struct request *rq,
> -					bool run_queue)
> +					bool run_queue, bool bypass_insert)
>  {
> +	if (bypass_insert) {
> +		blk_mq_request_bypass_insert(rq, run_queue);
> +		return;
> +	}
>  	blk_mq_sched_insert_request(rq, false, run_queue, false,
>  					hctx->flags & BLK_MQ_F_BLOCKING);
>  }

Lose the return and just make it an if/else.

-- 
Jens Axboe
