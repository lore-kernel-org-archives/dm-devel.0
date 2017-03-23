From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v2] block: trace completion of all bios.
Date: Thu, 23 Mar 2017 18:43:33 +0800
Message-ID: <20170323104331.GA16903@ming.t460p>
References: <877f3iave6.fsf@notabene.neil.brown.name>
 <20170322125149.GA29606@infradead.org>
 <87shm4a4lt.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87shm4a4lt.fsf@notabene.neil.brown.name>
Sender: linux-block-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

On Thu, Mar 23, 2017 at 05:29:02PM +1100, NeilBrown wrote:
> 
> Currently only dm and md/raid5 bios trigger trace_block_bio_complete().
> Now that we have bio_chain(), it is not possible, in general, for a
> driver to know when the bio is really complete.  Only bio_endio()
> knows that.
> 
> So move the trace_block_bio_complete() call to bio_endio().
> 
> Now trace_block_bio_complete() pairs with trace_block_bio_queue().
> Any bio for which a 'queue' event is traced, will subsequently
> generate a 'complete' event.
> 
> There are a few cases where completion tracing is not wanted.
> 1/ If blk_update_request() has already generated a completion
>    trace event at the 'request' level, there is no point generating
>    one at the bio level too.  In this case the bi_sector and bi_size
>    will have changed, so the bio level event would be wrong
> 
> 2/ If the bio hasn't actually been queued yet, but is being aborted
>    early, then a trace event could be confusing.  Some filesystems
>    call bio_endio() and will need to use a different interface to
>    avoid tracing
> 
> 3/ The bio_integrity code interposes itself by replacing bi_end_io,
>    then restores it and calls bio_endio() again.  This would produce
>    two identical trace events if left like that.
> 
> To handle these, we provide bio_endio_notrace().  This patch only adds
> uses of this in core code.  Separate patches will be needed to update
> the filesystems to avoid tracing.
> 
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  block/bio-integrity.c |  4 ++--
>  block/bio.c           | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  block/blk-core.c      |  2 +-
>  drivers/md/dm.c       |  1 -
>  drivers/md/raid5.c    |  8 --------
>  include/linux/bio.h   |  1 +
>  6 files changed, 50 insertions(+), 12 deletions(-)
> 
> diff --git a/block/bio-integrity.c b/block/bio-integrity.c
> index 5384713d48bc..28581e2f68fb 100644
> --- a/block/bio-integrity.c
> +++ b/block/bio-integrity.c
> @@ -370,7 +370,7 @@ static void bio_integrity_verify_fn(struct work_struct *work)
>  
>  	/* Restore original bio completion handler */
>  	bio->bi_end_io = bip->bip_end_io;
> -	bio_endio(bio);
> +	bio_endio_notrace(bio);
>  }
>  
>  /**
> @@ -397,7 +397,7 @@ void bio_integrity_endio(struct bio *bio)
>  	 */
>  	if (bio->bi_error) {
>  		bio->bi_end_io = bip->bip_end_io;
> -		bio_endio(bio);
> +		bio_endio_notrace(bio);
>  
>  		return;
>  	}
> diff --git a/block/bio.c b/block/bio.c
> index 5eec5e08417f..c8e5d24abd52 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1811,6 +1811,45 @@ static inline bool bio_remaining_done(struct bio *bio)
>  }
>  
>  /**
> + * bio_endio_notrace - end I/O on a bio without tracing
> + * @bio:	bio
> + *
> + * Description:
> + *   bio_endio_notrace() will end I/O on the whole bio.
> + *   bio_endio_notrace() should only be call if a completion trace
> + *   event is not needed.  This can be the case if a request-level
> + *   completion event has already been generated, if the bio is
> + *   being completed early, before it was even queued.
> + *
> + **/
> +void bio_endio_notrace(struct bio *bio)
> +{
> +again:
> +	if (!bio_remaining_done(bio))
> +		return;
> +
> +	/*
> +	 * Need to have a real endio function for chained bios, otherwise
> +	 * various corner cases will break (like stacking block devices that
> +	 * save/restore bi_end_io) - however, we want to avoid unbounded
> +	 * recursion and blowing the stack. Tail call optimization would
> +	 * handle this, but compiling with frame pointers also disables
> +	 * gcc's sibling call optimization.
> +	 */
> +	if (bio->bi_end_io == bio_chain_endio) {
> +		bio = __bio_chain_endio(bio);
> +		goto again;
> +	}
> +
> +	if (bio->bi_bdev)
> +		trace_block_bio_complete(bdev_get_queue(bio->bi_bdev),
> +					 bio, bio->bi_error);

The notrace version still traces?

> +	if (bio->bi_end_io)
> +		bio->bi_end_io(bio);
> +}
> +EXPORT_SYMBOL(bio_endio_notrace);

It isn't a good idea to duplicate bio_endio here, and any change on
bio_endio() may be needed for this _notrace version too in future.

Thanks,
Ming
