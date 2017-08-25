From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-rq: do not update rq partially in each ending bio
Date: Fri, 25 Aug 2017 11:48:39 -0400
Message-ID: <20170825154839.GA1695@redhat.com>
References: <20170825152749.14435-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170825152749.14435-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: dm-devel.ids

On Fri, Aug 25 2017 at 11:27am -0400,
Ming Lei <ming.lei@redhat.com> wrote:

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

Bart said he cannot reproduce the lockups with his patchset applied.
Have you tested using Bart's patchset?

Comments inlined below.

> ---
>  drivers/md/dm-rq.c | 15 +++++----------
>  drivers/md/dm-rq.h |  1 +
>  2 files changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index c6ebc5b1e00e..50cd96c7de45 100644
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
> @@ -144,21 +144,15 @@ static void end_clone_bio(struct bio *clone)
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

Why did you remove this check?

> +	tio->completed += nr_bytes;
>  
>  	/*
>  	 * Update the original request.
>  	 * Do not use blk_end_request() here, because it may complete
>  	 * the original request before the clone, and break the ordering.
>  	 */
> -	blk_update_request(tio->orig, BLK_STS_OK, nr_bytes);
> +	if (is_last)
> +		blk_update_request(tio->orig, BLK_STS_OK, tio->completed);
>  }

Partial completion support is important given the potential for path
failures interrupting requests.  Why do you think it is OK to avoid it
by switching to an all or nothing approach?

Mike
