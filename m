From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 06/13] block: Consolidate bio_alloc_bioset(),
 bio_kmalloc()
Date: Wed, 22 Aug 2012 13:17:30 -0700
Message-ID: <20120822201730.GI19212@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-7-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1345655050-28199-7-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: dm-devel.ids

Hello,

On Wed, Aug 22, 2012 at 10:04:03AM -0700, Kent Overstreet wrote:
> Previously, bio_kmalloc() and bio_alloc_bioset() behaved slightly
> different because there was some almost-duplicated code - this fixes
> that issue.

What were those slight differences?  Why is it safe to change the
behaviors to match each other?

>  struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
>  {
> +	unsigned front_pad;
> +	unsigned inline_vecs;
>  	unsigned long idx = BIO_POOL_NONE;
>  	struct bio_vec *bvl = NULL;
>  	struct bio *bio;
>  	void *p;
>  
> -	p = mempool_alloc(bs->bio_pool, gfp_mask);
> +	if (nr_iovecs > UIO_MAXIOV)
> +		return NULL;

This test used to only happen for bio_kmalloc().  If I follow the code
I can see that UIO_MAXIOV is larger than BIOVEC_MAX_IDX, so this
doesn't really affect the capability of bioset allocs; however, given
that bioset allocation already checks against BIOVEC_MAX_IDX, I don't
see why this test is now also applied to them.

> +	if (bs == BIO_KMALLOC_POOL) {
> +		p = kmalloc(sizeof(struct bio) +
> +			    nr_iovecs * sizeof(struct bio_vec),
> +			    gfp_mask);
> +		front_pad = 0;
> +		inline_vecs = nr_iovecs;
> +	} else {
> +		p = mempool_alloc(bs->bio_pool, gfp_mask);
> +		front_pad = bs->front_pad;
> +		inline_vecs = BIO_INLINE_VECS;
> +	}
> +
>  	if (unlikely(!p))
>  		return NULL;
> -	bio = p + bs->front_pad;
>  
> +	bio = p + front_pad;
>  	bio_init(bio);
> -	bio->bi_pool = bs;
>  
> -	if (unlikely(!nr_iovecs))
> -		goto out_set;
> -
> -	if (nr_iovecs <= BIO_INLINE_VECS) {
> -		bvl = bio->bi_inline_vecs;
> -		nr_iovecs = BIO_INLINE_VECS;
> -	} else {
> +	if (nr_iovecs > inline_vecs) {
>  		bvl = bvec_alloc_bs(gfp_mask, nr_iovecs, &idx, bs);
>  		if (unlikely(!bvl))
>  			goto err_free;
> -
> -		nr_iovecs = bvec_nr_vecs(idx);
> +	} else if (nr_iovecs) {
> +		bvl = bio->bi_inline_vecs;
>  	}
> -out_set:
> +
> +	bio->bi_pool = bs;
>  	bio->bi_flags |= idx << BIO_POOL_OFFSET;
>  	bio->bi_max_vecs = nr_iovecs;
>  	bio->bi_io_vec = bvl;
> @@ -331,63 +340,6 @@ err_free:
>  }
>  EXPORT_SYMBOL(bio_alloc_bioset);

> +extern struct bio_set *fs_bio_set;
> +
> +static inline struct bio *bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
> +{
> +	return bio_alloc_bioset(gfp_mask, nr_iovecs, fs_bio_set);
> +}
> +
> +#define BIO_KMALLOC_POOL NULL
> +
> +static inline struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned int nr_iovecs)
> +{
> +	return bio_alloc_bioset(gfp_mask, nr_iovecs, BIO_KMALLOC_POOL);
> +}

And we lose /** comments on two exported functions and
bio_alloc_bioset() comment doesn't explain that it now also handles
NULL bioset case.  Now that they share common implementation, you can
update bio_alloc_bioset() and refer to it from its wrappers but please
don't drop them like this.

Thanks.

-- 
tejun
