From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 06/26] block: Use bio_sectors() more consistently
Date: Thu, 20 Sep 2012 16:36:18 -0700
Message-ID: <20120920233618.GL7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-7-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1347322957-25260-7-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: dm-devel.ids

On Mon, Sep 10, 2012 at 05:22:17PM -0700, Kent Overstreet wrote:
> diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
> index 321de7b..6e4420a 100644
> --- a/drivers/block/aoe/aoeblk.c
> +++ b/drivers/block/aoe/aoeblk.c
> @@ -199,7 +199,7 @@ aoeblk_make_request(struct request_queue *q, struct bio *bio)
>  	buf->bio = bio;
>  	buf->resid = bio->bi_size;
>  	buf->sector = bio->bi_sector;
> -	buf->bv = &bio->bi_io_vec[bio->bi_idx];
> +	buf->bv = bio_iovec(bio);

Contamination?

Also, in general, please cc at least the maintainers of the files that
you modify.

Thanks.

-- 
tejun
