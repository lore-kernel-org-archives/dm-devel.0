From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dm-mpath: Work with blk multi-queue drivers
Date: Wed, 24 Sep 2014 07:52:15 -0700
Message-ID: <20140924145215.GA26398@infradead.org>
References: <1411491802-7356-1-git-send-email-keith.busch@intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1411491802-7356-1-git-send-email-keith.busch@intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Keith Busch <keith.busch@intel.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

> index bf930f4..4c5952b 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c

Can you split the block core changes into separate patches in a
series?

> @@ -2031,6 +2031,11 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
>  	    should_fail_request(&rq->rq_disk->part0, blk_rq_bytes(rq)))
>  		return -EIO;
>  
> +	if (q->mq_ops) {
> +		blk_mq_insert_request(rq, false, true, true);
> +		return 0;
> +	}

In the case of a torn down queue this one will complete the request,
while the !mq case will return an error.  Does the upper level code
handle that difference fine?

>  	spin_lock_irqsave(q->queue_lock, flags);
>  	if (unlikely(blk_queue_dying(q))) {
>  		spin_unlock_irqrestore(q->queue_lock, flags);
> @@ -2928,8 +2933,6 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
>  	if (!bs)
>  		bs = fs_bio_set;
>  
> -	blk_rq_init(NULL, rq);
> -

Moving this into the caller in a preparatory patch would be useful, too.

> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 383ea0c..eb53d1c 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -172,6 +172,7 @@ static void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
>  #if defined(CONFIG_BLK_DEV_INTEGRITY)
>  	rq->nr_integrity_segments = 0;
>  #endif
> +	rq->bio = NULL;

Jens has been trying to micro-optimize this area and avoid additional
overhead for the fast path.  It would be better to do this in dm-mpath.

>  	unsigned long flags;
>  	struct pgpath *pgpath;
>  	struct block_device *bdev;
> @@ -410,9 +411,11 @@ static int multipath_map(struct dm_target *ti, struct request *clone,
>  		goto out_unlock;
>  
>  	bdev = pgpath->path.dev->bdev;
> -	clone->q = bdev_get_queue(bdev);
> -	clone->rq_disk = bdev->bd_disk;
> -	clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
> +	*clone = blk_get_request(bdev_get_queue(bdev), rq_data_dir(rq),
> +							GFP_KERNEL);

I suspect this should be GFP_NOWAIT so that we can push the request back
up the stack if none are available.

> +	if (!(*clone))
> +		goto out_unlock;

No need for the inner braces.

>   * This may be used when the target's map_rq() function fails.
>   */
> -void dm_kill_unmapped_request(struct request *clone, int error)
> +void dm_kill_unmapped_request(struct request *rq, int error)
>  {
> -	struct dm_rq_target_io *tio = clone->end_io_data;
> -	struct request *rq = tio->orig;
> -
>  	rq->cmd_flags |= REQ_FAILED;
> -	dm_complete_request(clone, error);
> +	dm_complete_request(rq, error);
>  }
>  EXPORT_SYMBOL_GPL(dm_kill_unmapped_request);

At this point it might be worth to just kill the
dm_kill_unmapped_request wrapper?
