From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: fix imposition of queue_limits in dm_wq_work() thread
Date: Mon, 28 Sep 2020 12:03:22 -0400
Message-ID: <20200928160322.GA23320@redhat.com>
References: <20200927120435.44118-1-jefflexu@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200927120435.44118-1-jefflexu@linux.alibaba.com>
To: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: dm-devel@redhat.com, joseph.qi@linux.alibaba.com, ming.lei@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Sun, Sep 27 2020 at  8:04am -0400,
Jeffle Xu <jefflexu@linux.alibaba.com> wrote:

> Hi Mike, would you mind further expalin why bio processed by dm_wq_work()
> always gets a previous ->submit_bio. Considering the following call graph:
> 
> ->submit_bio, that is, dm_submit_bio
>   DMF_BLOCK_IO_FOR_SUSPEND set, thus queue_io()
> 
> then worker thread dm_wq_work()
>   dm_process_bio  // at this point. the input bio is the original bio
>                      submitted to dm device
> 
> Please let me know if I missed something.
> 
> Thanks.
> Jeffle

In general you have a valid point, that blk_queue_split() won't have
been done for the suspended device case, but blk_queue_split() cannot be
used if not in ->submit_bio -- IIUC you cannot just do it from a worker
thread and hope to have proper submission order (depth first) as
provided by __submit_bio_noacct().  Because this IO will be submitted
from worker you could have multiple threads allocating from the
q->bio_split mempool at the same time.

All said, I'm not quite sure how to address this report.  But I'll keep
at it and see what I can come up with.

Thanks,
Mike

> Original commit log:
> dm_process_bio() can be called by dm_wq_work(), and if the currently
> processing bio is the very beginning bio submitted to the dm device,
> that is it has not been handled by previous ->submit_bio, then we also
> need to impose the queue_limits when it's in thread (dm_wq_work()).
> 
> Fixes: cf9c37865557 ("dm: fix comment in dm_process_bio()")
> Fixes: 568c73a355e0 ("dm: update dm_process_bio() to split bio if in ->make_request_fn()")
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>  drivers/md/dm.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 6ed05ca65a0f..54471c75ddef 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1744,17 +1744,13 @@ static blk_qc_t dm_process_bio(struct mapped_device *md,
>  	}
>  
>  	/*
> -	 * If in ->submit_bio we need to use blk_queue_split(), otherwise
> -	 * queue_limits for abnormal requests (e.g. discard, writesame, etc)
> -	 * won't be imposed.
> -	 * If called from dm_wq_work() for deferred bio processing, bio
> -	 * was already handled by following code with previous ->submit_bio.
> +	 * Call blk_queue_split() so that queue_limits for abnormal requests
> +	 * (e.g. discard, writesame, etc) are ensured to be imposed, while
> +	 * it's not needed for regular IO, since regular IO will be split by
> +	 * following __split_and_process_bio.
>  	 */
> -	if (current->bio_list) {
> -		if (is_abnormal_io(bio))
> -			blk_queue_split(&bio);
> -		/* regular IO is split by __split_and_process_bio */
> -	}
> +	if (is_abnormal_io(bio))
> +		blk_queue_split(&bio);
>  
>  	if (dm_get_md_type(md) == DM_TYPE_NVME_BIO_BASED)
>  		return __process_bio(md, map, bio, ti);
> -- 
> 2.27.0
> 
