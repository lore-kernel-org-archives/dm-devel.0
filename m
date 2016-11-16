From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 7/7] dm-mpath: Fix a race condition in
	__multipath_map()
Date: Tue, 15 Nov 2016 19:37:20 -0500
Message-ID: <20161116003720.GA19059@redhat.com>
References: <e83f8718-9e73-5544-3bcc-4d9851b90ba1@sandisk.com>
	<81bc399e-df90-099d-1b25-bdb0fda3f27c@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <81bc399e-df90-099d-1b25-bdb0fda3f27c@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Nov 15 2016 at  6:35pm -0500,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> If a single-queue dm device is stacked on top of multi-queue block
> devices and map_tio_request() is called while there are no paths then
> the request will be prepared for a single-queue path. If a path is
> added after a request was prepared and before __multipath_map() is
> called return DM_MAPIO_REQUEUE such that it gets unprepared and
> reprepared as a blk-mq request.

This patch makes little sense to me.  There isn't a scenario that I'm
aware of that would allow the request_queue to transition between old
.request_fn and new blk-mq.

The dm-table code should prevent this.

Mike

> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 7559537..6b20349 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -541,6 +541,7 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
>  	size_t nr_bytes = clone ? blk_rq_bytes(clone) : blk_rq_bytes(rq);
>  	struct pgpath *pgpath;
>  	struct block_device *bdev;
> +	struct request_queue *q;
>  	struct dm_mpath_io *mpio;
>  
>  	/* Do we need to select a new pgpath? */
> @@ -558,6 +559,18 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
>  		return r;
>  	}
>  
> +	bdev = pgpath->path.dev->bdev;
> +	q = bdev_get_queue(bdev);
> +
> +	/*
> +	 * When a request is prepared if there are no paths it may happen that
> +	 * the request was prepared for a single-queue path and that a
> +	 * multiqueue path is added before __multipath_map() is called. If
> +	 * that happens requeue to trigger unprepare and reprepare.
> +	 */
> +	if ((clone && q->mq_ops) || (!clone && !q->mq_ops))
> +		return r;
> +
>  	mpio = set_mpio(m, map_context);
>  	if (!mpio)
>  		/* ENOMEM, requeue */
> @@ -566,22 +579,20 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
>  	mpio->pgpath = pgpath;
>  	mpio->nr_bytes = nr_bytes;
>  
> -	bdev = pgpath->path.dev->bdev;
> -
>  	if (clone) {
>  		/*
>  		 * Old request-based interface: allocated clone is passed in.
>  		 * Used by: .request_fn stacked on .request_fn path(s).
>  		 */
> -		clone->q = bdev_get_queue(bdev);
> +		clone->q = q;
>  	} else {
>  		/*
>  		 * blk-mq request-based interface; used by both:
>  		 * .request_fn stacked on blk-mq path(s) and
>  		 * blk-mq stacked on blk-mq path(s).
>  		 */
> -		clone = blk_mq_alloc_request(bdev_get_queue(bdev),
> -					rq_data_dir(rq), BLK_MQ_REQ_NOWAIT);
> +		clone = blk_mq_alloc_request(q, rq_data_dir(rq),
> +					     BLK_MQ_REQ_NOWAIT);
>  		if (IS_ERR(clone)) {
>  			/* EBUSY, ENODEV or EWOULDBLOCK; requeue */
>  			clear_request_fn_mpio(m, map_context);
> -- 
> 2.10.1
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
