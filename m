From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 21/26] block: Convert some code to
 bio_for_each_segment_all()
Date: Thu, 20 Sep 2012 17:38:32 -0700
Message-ID: <20120921003832.GY7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-22-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1347322957-25260-22-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: dm-devel.ids

On Mon, Sep 10, 2012 at 05:22:32PM -0700, Kent Overstreet wrote:
> A few places in the code were either open coding or using the wrong
> version - fix.
> 
> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> CC: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
> ---
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -921,7 +921,7 @@ static void alloc_behind_pages(struct bio *bio, struct r1bio *r1_bio)
>  	if (unlikely(!bvecs))
>  		return;
>  
> -	bio_for_each_segment(bvec, bio, i) {
> +	bio_for_each_segment_all(bvec, bio, i) {

I don't get this conversion.  Why is this necessary?

-- 
tejun
