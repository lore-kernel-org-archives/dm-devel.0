From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-rq: do not update rq partially in each ending bio
Date: Fri, 25 Aug 2017 12:32:33 -0400
Message-ID: <20170825163233.GB1900@redhat.com>
References: <20170825152749.14435-1-ming.lei@redhat.com>
 <20170825154839.GA1695@redhat.com>
 <20170825160850.GA13937@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170825160850.GA13937@ming.t460p>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: dm-devel.ids

On Fri, Aug 25 2017 at 12:08pm -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> On Fri, Aug 25, 2017 at 11:48:39AM -0400, Mike Snitzer wrote:
> > On Fri, Aug 25 2017 at 11:27am -0400,
> > Ming Lei <ming.lei@redhat.com> wrote:
> > 
> > > We don't need to update orignal dm request partially
> > > when ending each cloned bio, and this patch just
> > > updates orignal dm request once when the whole
> > > cloned request is finished.
> > > 
> > > Partial request update can be a bit expensive, so
> > > we should try to avoid it, especially it is run
> > > in softirq context.
> > > 
> > > After this patch is applied, both hard lockup and
> > > soft lockup aren't reproduced any more in one hour
> > > of running Laurence's test[1] on IB/SRP. Without
> > > this patch, the lockup can be reproduced in several
> > > minutes.
> > > 
> > > BTW, after d4acf3650c7c(block: Make blk_mq_delay_kick_requeue_list()
> > > rerun the queue at a quiet time), we need to make the
> > > test more aggressive for reproducing the lockup:
> > > 
> > > 	1) run hammer_write.sh 32 or 64 concurrently.
> > > 	2) write 8M each time
> > > 
> > > [1] https://marc.info/?l=linux-block&m=150220185510245&w=2
> > 
> > Bart said he cannot reproduce the lockups with his patchset applied.
> > Have you tested using Bart's patchset?
> 
> d4acf3650c7c(block: Make blk_mq_delay_kick_requeue_list() rerun the
> queue at a quiet time) has been in linus tree.
> 
> For other patches, I didn't test it yet. Because every time
> when the lockup is triggered, it is always in blk_recalc_rq_segments(),
> and not see any patch is dealing with that.

Please test with all of Bart's patches applied!

> > Comments inlined below.
> > 
> > > ---
> > >  drivers/md/dm-rq.c | 15 +++++----------
> > >  drivers/md/dm-rq.h |  1 +
> > >  2 files changed, 6 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> > > index c6ebc5b1e00e..50cd96c7de45 100644
> > > --- a/drivers/md/dm-rq.c
> > > +++ b/drivers/md/dm-rq.c
> > > @@ -117,9 +117,9 @@ static void end_clone_bio(struct bio *clone)
> > >  	struct dm_rq_clone_bio_info *info =
> > >  		container_of(clone, struct dm_rq_clone_bio_info, clone);
> > >  	struct dm_rq_target_io *tio = info->tio;
> > > -	struct bio *bio = info->orig;
> > >  	unsigned int nr_bytes = info->orig->bi_iter.bi_size;
> > >  	blk_status_t error = clone->bi_status;
> > > +	bool is_last = !clone->bi_next;
> > >  
> > >  	bio_put(clone);
> > >  
> > > @@ -144,21 +144,15 @@ static void end_clone_bio(struct bio *clone)
> > >  	 * I/O for the bio successfully completed.
> > >  	 * Notice the data completion to the upper layer.
> > >  	 */
> > > -
> > > -	/*
> > > -	 * bios are processed from the head of the list.
> > > -	 * So the completing bio should always be rq->bio.
> > > -	 * If it's not, something wrong is happening.
> > > -	 */
> > > -	if (tio->orig->bio != bio)
> > > -		DMERR("bio completion is going in the middle of the request");
> > 
> > Why did you remove this check?
> 
> The check isn't valid any more because this patch only update
> original dm rq in .end_bio() of the last cloned bio.

Fair enough, so just a side-effect of your all or nothing completion handling.

> > 
> > > +	tio->completed += nr_bytes;
> > >  
> > >  	/*
> > >  	 * Update the original request.
> > >  	 * Do not use blk_end_request() here, because it may complete
> > >  	 * the original request before the clone, and break the ordering.
> > >  	 */
> > > -	blk_update_request(tio->orig, BLK_STS_OK, nr_bytes);
> > > +	if (is_last)
> > > +		blk_update_request(tio->orig, BLK_STS_OK, tio->completed);
> > >  }
> > 
> > Partial completion support is important given the potential for path
> > failures interrupting requests.  Why do you think it is OK to avoid it
> > by switching to an all or nothing approach?
> 
> If the cloned rq is partially completed, this dm rq is still partially
> completed. This patch only update dm rq in the last cloned bio's
> .end_io().

Which is exactly what we do _not_ want because it removed partial
completion.  Which is an important feature of DM multipath.  Christoph
echoed its importance some time ago:
https://www.redhat.com/archives/dm-devel/2015-May/msg00228.html

> Also if one middle cloned bio is completed with error, the current
> implementation doesn't update dm rq any more from that bio, so
> looks the following patch is consistent with current
> implementation, what do you think of it?

Not seeing how.  Yes, the current implementation will not account for a
part of the request that failed.  That is fine.. the bio failed, so
nothing to update!

So no, I don't understand why you've added the 'exit' goto to update the
request on error.  If the request is to be failed upgrades it'll get
updated as a side-effect of that completion due to error (if multipath
is configured to fail_if_no_path or whatever).

Mike

> From 2b5ef7e64ba8595c0c58790d14fd77b10a28afee Mon Sep 17 00:00:00 2001
> From: Ming Lei <ming.lei@redhat.com>
> Date: Thu, 24 Aug 2017 20:19:52 +0800
> Subject: [PATCH] dm-rq: do not update rq partially in each ending bio
> 
> We don't need to update orignal dm request partially
> when ending each cloned bio, and this patch just
> updates orignal dm request once when the whole
> cloned request is finished.
> 
> Partial request update can be a bit expensive, so
> we should try to avoid it, especially it is run
> in softirq context.
> 
> After this patch is applied, both hard lockup and
> soft lockup aren't reproduced any more in one hour
> of running Laurence's test[1] on IB/SRP. Without
> this patch, the lockup can be reproduced in several
> minutes.
> 
> BTW, after d4acf3650c7c(block: Make blk_mq_delay_kick_requeue_list()
> rerun the queue at a quiet time), we need to make the
> test more aggressive for reproducing the lockup:
> 
> 	1) run hammer_write.sh 32 or 64 concurrently.
> 	2) write 8M each time
> 
> [1] https://marc.info/?l=linux-block&m=150220185510245&w=2
> 
> Cc: Laurence Oberman <loberman@redhat.com>
> Cc: Bart Van Assche <Bart.VanAssche@wdc.com>
> Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Alasdair Kergon <agk@redhat.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/md/dm-rq.c | 18 +++++++-----------
>  drivers/md/dm-rq.h |  1 +
>  2 files changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index c6ebc5b1e00e..72396b0ce485 100644
> --- a/drivers/md/dm-rq.c
> +++ b/drivers/md/dm-rq.c
> @@ -117,9 +117,9 @@ static void end_clone_bio(struct bio *clone)
>  	struct dm_rq_clone_bio_info *info =
>  		container_of(clone, struct dm_rq_clone_bio_info, clone);
>  	struct dm_rq_target_io *tio = info->tio;
> -	struct bio *bio = info->orig;
>  	unsigned int nr_bytes = info->orig->bi_iter.bi_size;
>  	blk_status_t error = clone->bi_status;
> +	bool is_last = !clone->bi_next;
>  
>  	bio_put(clone);
>  
> @@ -137,28 +137,23 @@ static void end_clone_bio(struct bio *clone)
>  		 * when the request is completed.
>  		 */
>  		tio->error = error;
> -		return;
> +		goto exit;
>  	}
>  
>  	/*
>  	 * I/O for the bio successfully completed.
>  	 * Notice the data completion to the upper layer.
>  	 */
> -
> -	/*
> -	 * bios are processed from the head of the list.
> -	 * So the completing bio should always be rq->bio.
> -	 * If it's not, something wrong is happening.
> -	 */
> -	if (tio->orig->bio != bio)
> -		DMERR("bio completion is going in the middle of the request");
> +	tio->completed += nr_bytes;
>  
>  	/*
>  	 * Update the original request.
>  	 * Do not use blk_end_request() here, because it may complete
>  	 * the original request before the clone, and break the ordering.
>  	 */
> -	blk_update_request(tio->orig, BLK_STS_OK, nr_bytes);
> +	if (is_last)
> + exit:
> +		blk_update_request(tio->orig, BLK_STS_OK, tio->completed);
>  }
>  
>  static struct dm_rq_target_io *tio_from_request(struct request *rq)
> @@ -455,6 +450,7 @@ static void init_tio(struct dm_rq_target_io *tio, struct request *rq,
>  	tio->clone = NULL;
>  	tio->orig = rq;
>  	tio->error = 0;
> +	tio->completed = 0;
>  	/*
>  	 * Avoid initializing info for blk-mq; it passes
>  	 * target-specific data through info.ptr
> diff --git a/drivers/md/dm-rq.h b/drivers/md/dm-rq.h
> index 9813922e4fe5..f43c45460aac 100644
> --- a/drivers/md/dm-rq.h
> +++ b/drivers/md/dm-rq.h
> @@ -29,6 +29,7 @@ struct dm_rq_target_io {
>  	struct dm_stats_aux stats_aux;
>  	unsigned long duration_jiffies;
>  	unsigned n_sectors;
> +	unsigned completed;
>  };
>  
>  /*
> -- 
> 2.9.5
> 
> 
