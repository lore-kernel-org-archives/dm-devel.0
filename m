From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Write barriers on MD RAID1
Date: Wed, 24 Jun 2009 09:38:50 +0200
Message-ID: <20090624073849.GG31415@kernel.dk>
References: <4A188CAD.1080009@googlemail.com> <0fa4b1e19d3edb12931e0d641ce2c7d7.squirrel@neil.brown.name> <4A3E3C49.7010907@googlemail.com> <19009.41191.662901.179565@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19009.41191.662901.179565@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Ken Milmore <ken.milmore@googlemail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Jun 24 2009, Neil Brown wrote:
> On Sunday June 21, ken.milmore@googlemail.com wrote:
> > I thought I had better bump my previous post as this regression is still 
> > present in 2.6.29.5.
> 
> Thanks Ken.
> 
> > 
> > To recap, commit cec0707e40ae25794b5a2de7b7f03c51961f80d9 has broken 
> > write barriers on md raid1 block devices in 2.6.29 and later kernels. 
> > Reversing this commit appears to fix the problem.
> > 
> > Please let me know if I'm harassing the wrong maintainers here!
> 
> Jens,
>   have you had a chance to look at this?

Yeah, I think it's the right way to go. I'll queue it up for .31 and we
should put in in -stable as well.

> 
> I think the following patch is appropriate and should go in to
> -stable.
> 
> Thanks,
> NeilBrown
> 
> 
> From addd8b129835a63d6df9a38eae20caaa15de5988 Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Wed, 24 Jun 2009 13:39:15 +1000
> Subject: [PATCH] Restore barrier support for md and probably other virtual devices.
> 
> The next_ordered flag is only meaningful for devices that use __make_request.
> So move the test against next_ordered out of generic code and in to
> __make_request
> 
> Since this test was added, barriers have not worked on md, and (I
> think) dm and similar devices that don't use __make_request and so
> don't bother to set next_ordered.
> 
> Cc: stable@kernel.org
> Cc: Ken Milmore <ken.milmore@googlemail.com>
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  block/blk-core.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index b06cf5c..fc221aa 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1172,6 +1172,11 @@ static int __make_request(struct request_queue *q, struct bio *bio)
>  	const int unplug = bio_unplug(bio);
>  	int rw_flags;
>  
> +	if (bio_barrier(bio) && bio_has_data(bio) &&
> +	    (q->next_ordered == QUEUE_ORDERED_NONE)) {
> +		bio_endio(bio, -EOPNOTSUPP)
> +			return 0;
> +	}
>  	/*
>  	 * low level driver can indicate that it wants pages above a
>  	 * certain limit bounced to low memory (ie for highmem, or even
> @@ -1472,11 +1477,6 @@ static inline void __generic_make_request(struct bio *bio)
>  			err = -EOPNOTSUPP;
>  			goto end_io;
>  		}
> -		if (bio_barrier(bio) && bio_has_data(bio) &&
> -		    (q->next_ordered == QUEUE_ORDERED_NONE)) {
> -			err = -EOPNOTSUPP;
> -			goto end_io;
> -		}
>  
>  		ret = q->make_request_fn(q, bio);
>  	} while (ret);
> -- 
> 1.6.3.1
> 

-- 
Jens Axboe

