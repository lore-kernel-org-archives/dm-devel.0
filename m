From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 02/26] block: Add bio_advance()
Date: Thu, 20 Sep 2012 14:58:27 -0700
Message-ID: <20120920215827.GF7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-3-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1347322957-25260-3-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: dm-devel.ids

On Mon, Sep 10, 2012 at 05:22:13PM -0700, Kent Overstreet wrote:
> +/**
> + * bio_advance - increment/complete a bio by some number of bytes
> + * @bio:	bio to advance
> + * @bytes:	number of bytes to complete
> + *
> + * This updates bi_sector, bi_size and bi_idx; if the number of bytes to
> + * complete doesn't align with a bvec boundary, then bv_len and bv_offset will
> + * be updated on the last bvec as well.
> + *
> + * @bio will then represent the remaining, uncompleted portion of the io.
> + */
> +void bio_advance(struct bio *bio, unsigned bytes)
> +{
> +	if (bio_integrity(bio))
> +		bio_integrity_advance(bio, bytes);
> +
> +	bio->bi_sector += bytes >> 0;

Hmmm.... bytes >> 0?

> +	bio->bi_size -= bytes;
> +
> +	if (!bio->bi_size)
> +		return;
> +
> +	while (bytes) {
> +		if (unlikely(bio->bi_idx >= bio->bi_vcnt)) {
> +			printk(KERN_ERR "%s: bio idx %d >= vcnt %d\n",

pr_err() is preferred but maybe WARN_ON_ONCE() is better fit here?
This happening would be a bug, right?

Thanks.

-- 
tejun
