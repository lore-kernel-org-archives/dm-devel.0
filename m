From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 03/26] block: Refactor blk_update_request()
Date: Thu, 20 Sep 2012 16:20:00 -0700
Message-ID: <20120920232000.GG7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-4-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1347322957-25260-4-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

Hello,

On Mon, Sep 10, 2012 at 05:22:14PM -0700, Kent Overstreet wrote:
>  static void req_bio_endio(struct request *rq, struct bio *bio,
>  			  unsigned int nbytes, int error)
>  {
> +	/*
> +	 * XXX: bio_endio() does this. only need this because of the weird
> +	 * flush seq thing.
> +	 */
>  	if (error)
>  		clear_bit(BIO_UPTODATE, &bio->bi_flags);
>  	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
>  		error = -EIO;

Isn't this also necessary to record errors on partial completions?

Other than that, I definitely like this.  It would be nice to note
that the custom partial bio advancing in blk_update_request() is
replaced with multiple calls to req_bio_endio().  I don't think it has
any meaningful performance implications.  It's just nice to future
readers of the commit.

Also, it would be really nice if you can verify this actually works
with partial blk_update_request().  sector update bug in the previous
patch scares me a bit.  Implementing some debug hacks in the
completion path might be the easiest way to verify.  A subtle bug here
could be pretty painful.

Thanks.

-- 
tejun
