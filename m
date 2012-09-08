From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] block: Avoid deadlocks with bio allocation by
 stacking drivers
Date: Sat, 8 Sep 2012 12:36:41 -0700
Message-ID: <20120908193641.GB12773@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1347055973-11581-1-git-send-email-koverstreet@google.com>
 <1347055973-11581-3-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1347055973-11581-3-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
List-Id: dm-devel.ids

(Restoring cc list from the previous discussion.  Please retain the cc
list of the people who discussed in the previous postings.)

On Fri, Sep 07, 2012 at 03:12:53PM -0700, Kent Overstreet wrote:
> But this is tricky and not a generic solution. This patch solves it for
> all users by inverting the previously described technique. We allocate a
> rescuer workqueue for each bio_set, and then in the allocation code if
> there are bios on current->bio_list we would be blocking, we punt them
> to the rescuer workqueue to be submitted.

It would be great if this explanation can be expanded a bit.  Why does
it make the deadlock condition go away?  What are the restrictions -
e.g. using other mempools for additional per-bio data structure
wouldn't work, right?

> +static void punt_bios_to_rescuer(struct bio_set *bs)
> +{
> +	struct bio_list punt, nopunt;
> +	struct bio *bio;
> +
> +	bio_list_init(&punt);
> +	bio_list_init(&nopunt);
> +
> +	while ((bio = bio_list_pop(current->bio_list)))
> +		bio_list_add(bio->bi_pool == bs ? &punt : &nopunt, bio);
> +
> +	*current->bio_list = nopunt;

Why this is necessary needs explanation and it's done in rather
unusual way.  I suppose the weirdness is from bio_list API
restriction?

> +	spin_lock(&bs->rescue_lock);
> +	bio_list_merge(&bs->rescue_list, &punt);
> +	spin_unlock(&bs->rescue_lock);
> +
> +	queue_work(bs->rescue_workqueue, &bs->rescue_work);
> +}
> +
>  /**
>   * bio_alloc_bioset - allocate a bio for I/O
>   * @gfp_mask:   the GFP_ mask given to the slab allocator
> @@ -317,6 +354,7 @@ EXPORT_SYMBOL(bio_reset);
>   */
>  struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
>  {
> +	gfp_t saved_gfp = gfp_mask;
>  	unsigned front_pad;
>  	unsigned inline_vecs;
>  	unsigned long idx = BIO_POOL_NONE;
> @@ -334,13 +372,37 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
>  		front_pad = 0;
>  		inline_vecs = nr_iovecs;
>  	} else {
> +		/*
> +		 * generic_make_request() converts recursion to iteration; this
> +		 * means if we're running beneath it, any bios we allocate and
> +		 * submit will not be submitted (and thus freed) until after we
> +		 * return.
> +		 *
> +		 * This exposes us to a potential deadlock if we allocate
> +		 * multiple bios from the same bio_set() while running
> +		 * underneath generic_make_request(). If we were to allocate
> +		 * multiple bios (say a stacking block driver that was splitting
> +		 * bios), we would deadlock if we exhausted the mempool's
> +		 * reserve.
> +		 *
> +		 * We solve this, and guarantee forward progress, with a rescuer
> +		 * workqueue per bio_set. If we go to allocate and there are
> +		 * bios on current->bio_list, we first try the allocation
> +		 * without __GFP_WAIT; if that fails, we punt those bios we
> +		 * would be blocking to the rescuer workqueue before we retry
> +		 * with the original gfp_flags.
> +		 */
> +
> +		if (current->bio_list && !bio_list_empty(current->bio_list))
> +			gfp_mask &= ~__GFP_WAIT;
> +retry:
>  		p = mempool_alloc(bs->bio_pool, gfp_mask);
>  		front_pad = bs->front_pad;
>  		inline_vecs = BIO_INLINE_VECS;
>  	}

Wouldn't the following be better?

	p = mempool_alloc(bs->bi_pool, gfp_mask);
	if (unlikely(!p) && gfp_mask != saved_gfp) {
		punt_bios_to_rescuer(bs);
		p = mempool_alloc(bs->bi_pool, saved_gfp);
	}

I really hope the usage restriction (don't mix with mempool) for
bioset is clearly documented somewhere appropriate.

Thanks.

-- 
tejun
