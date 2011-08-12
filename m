From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch] block: fix flush machinery for stacking drivers with
 differring flush flags
Date: Fri, 12 Aug 2011 14:59:35 +0200
Message-ID: <20110812125935.GA4254@htj.dyndns.org>
References: <x49ty9pqood.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <x49ty9pqood.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, msnitzer@redhat.com, vgoyal@redhat.com, shaohua <shli@kernel.org>
List-Id: dm-devel.ids

Hello, Jeff.

On Wed, Aug 10, 2011 at 11:19:46AM -0400, Jeff Moyer wrote:
> @@ -1708,6 +1711,20 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
>  	    should_fail_request(&rq->rq_disk->part0, blk_rq_bytes(rq)))
>  		return -EIO;
>  
> +	if (rq->cmd_flags & (REQ_FLUSH|REQ_FUA)) {
> +		/*
> +		 * Filter empty flush requests here.  REQ_FLUSH_SEQ will
> +		 * ensure that no I/O accounting is done for this request.
> +		 */
> +		if (!q->flush_flags && !blk_rq_sectors(rq)) {
> +			blk_end_bidi_request(rq, 0, 0, 0);
> +			return 0;
> +		}

I wish the short-circuiting is in blk_insert_flush().  You can simply
test if (!policy) there and blk_insert_cloned_request() would behave
like other insertion paths.

> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 6395692..60cfd24 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -168,7 +168,18 @@ enum rq_flag_bits {
>  #define REQ_COMMON_MASK \
>  	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_DISCARD | \
>  	 REQ_NOIDLE | REQ_FLUSH | REQ_FUA | REQ_SECURE)
> -#define REQ_CLONE_MASK		REQ_COMMON_MASK
> +/*
> + * Cloned requests are inserted into the elevator via blk_insert_cloned_request.
> + * Because the flush flags exported by the request-based dm target may in
> + * theory be different from the flush flags of the underlying request_queue,
> + * we need to pass along information regarding whether a particular request
> + * is part of a flush sequence.  This is primarily used to complete I/Os early
> + * that would otherwise not be necessary (such as an empty flush for a request
> + * queue that does not support flush).  In such a case, the end_io path for
> + * the request would try to account the I/O instead of ignoring it, resulting
> + * in a null pointer dereference.
> + */
> +#define REQ_CLONE_MASK		(REQ_COMMON_MASK | REQ_FLUSH_SEQ)

I'm probably missing something, but why do we still need to copy
REQ_FLUSH_SEQ?  Why doesn't the following work?

* dm driver always advertises REQ_FLUSH|FUA like other stacking
  drivers.

* blk-flush for the dm, decomposes flushes to FLUSH + FUA write and
  send it down.

* dm driver clones the requests and send them down to each member
  queue.

* blk-flush on member queue, handles FLUSH as FLUSH and decomposes FUA
  write as necessary.

What am I missing?  Why does end_io path still matter when it goes
through blk-flush on the member device too?

Thank you.

-- 
tejun
