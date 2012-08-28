From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 5/9] block: Kill bi_destructor
Date: Tue, 28 Aug 2012 13:36:13 -0700
Message-ID: <20120828203613.GD24608@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-6-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1346175456-1572-6-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: dm-devel.ids

On Tue, Aug 28, 2012 at 10:37:32AM -0700, Kent Overstreet wrote:
> @@ -385,7 +386,7 @@ struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned int nr_iovecs)
>  	bio->bi_flags |= BIO_POOL_NONE << BIO_POOL_OFFSET;
>  	bio->bi_max_vecs = nr_iovecs;
>  	bio->bi_io_vec = bio->bi_inline_vecs;
> -	bio->bi_destructor = bio_kmalloc_destructor;
> +	bio->bi_pool = NULL;

Doesn't bio_init() already memset the whole thing?

Thanks.

-- 
tejun
