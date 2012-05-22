From: Tejun Heo <tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Bcache v13 14/16] bcache: Request, io and allocation code
Date: Tue, 22 May 2012 15:42:55 -0700
Message-ID: <20120522224255.GM14339@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <9ea33658f2a71b3b9bd2ec10bee959bef146f23c.1336619038.git.koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9ea33658f2a71b3b9bd2ec10bee959bef146f23c.1336619038.git.koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Wed, May 09, 2012 at 11:11:25PM -0400, Kent Overstreet wrote:
> +int submit_bbio_split(struct bio *bio, struct cache_set *c,
> +		      struct bkey *k, unsigned ptr)
> +{
> +	struct closure *cl = bio->bi_private;
> +	struct bbio *b;
> +	struct bio *n;
> +	unsigned sectors_done = 0;
> +
> +	closure_get(cl);
> +
> +	bio->bi_sector	= PTR_OFFSET(k, ptr);
> +	bio->bi_bdev	= PTR_CACHE(c, k, ptr)->bdev;
> +
> +	do {
> +		n = bio_split_get(bio, bio_max_sectors(bio), c);
> +		if (!n) {
> +			closure_put(cl);
> +			return -ENOMEM;
> +		}
> +
> +		b = container_of(n, struct bbio, bio);
> +
> +		bkey_copy_single_ptr(&b->key, k, ptr);
> +		SET_KEY_SIZE(&b->key, KEY_SIZE(k) - sectors_done);
> +		SET_PTR_OFFSET(&b->key, 0, PTR_OFFSET(k, ptr) + sectors_done);
> +
> +		b->submit_time_us = local_clock_us();
> +		generic_make_request(n);
> +	} while (n != bio);
> +
> +	return 0;
> +}

Hmmm... where is @sectors_done updated?

Thanks.

-- 
tejun
