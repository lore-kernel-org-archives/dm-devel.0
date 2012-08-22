From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 10/13] block: Introduce new bio_split()
Date: Wed, 22 Aug 2012 13:46:08 -0700
Message-ID: <20120822204608.GK19212@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-11-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1345655050-28199-11-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

Hello, Kent.

On Wed, Aug 22, 2012 at 10:04:07AM -0700, Kent Overstreet wrote:
> @@ -672,7 +672,6 @@ void bio_integrity_trim(struct bio *bio, unsigned int offset,
>  
>  	BUG_ON(bip == NULL);
>  	BUG_ON(bi == NULL);
> -	BUG_ON(!bio_flagged(bio, BIO_CLONED));
>  
>  	nr_sectors = bio_integrity_hw_sectors(bi, sectors);
>  	bip->bip_sector = bip->bip_sector + offset;

It depends on what BIO_CLONED is supposed to do but maybe the right
thing to do is clearing BIO_CLONED on split bio?  The split bio isn't
a clone after all.

>  /**
> + * bio_split - split a bio
> + * @bio:	bio to split
> + * @sectors:	number of sectors to split from the front of @bio
> + * @gfp:	gfp mask
> + * @bs:		bio set to allocate from
> + *
> + * Allocates and returns a new bio which represents @sectors from the start of
> + * @bio, and updates @bio to represent the remaining sectors.
> + *
> + * If bio_sectors(@bio) was less than or equal to @sectors, returns @bio
> + * unchanged.

This is no longer true.

> + * The newly allocated bio will point to @bio's bi_io_vec, if the split was on a
> + * bvec boundry; it is the caller's responsibility to ensure that @bio is not
> + * freed before the split.
> + */
> +struct bio *bio_split(struct bio *bio, int sectors,
> +		      gfp_t gfp, struct bio_set *bs)
> +{
...
> +	if (bio_integrity(bio)) {
> +		bio_integrity_clone(split, bio, gfp, bs);

What happens if bio_integrity_clone() fails?

> +		bio_integrity_trim(split, 0, bio_sectors(split));
> +		bio_integrity_trim(bio, bio_sectors(split), bio_sectors(bio));

I complained pretty loudly about this not being mentioned in the
description of this patch or the following one and there still is no
explanation.  Come on, Kent.

> +static inline struct bio *bio_next_split(struct bio *bio, int sectors,
> +					 gfp_t gfp, struct bio_set *bs)
> +{
> +	if (sectors >= bio_sectors(bio))
> +		return bio;
> +
> +	return bio_split(bio, sectors, gfp, bs);
> +}

First of all, I don't think this is necessary.  In addition, this
doesn't have any comment explaining what it does and is never
mentioned or justified in patch description.  Kent, you're repeating
the same mistakes even after being explicitly pointed out multiple
times.  *Please* pay more attention.

Thanks.

-- 
tejun
