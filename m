From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 09/13] block: Add an explicit bio flag for bios that
 own their bvec
Date: Fri, 18 May 2012 09:30:18 -0700
Message-ID: <20120518163018.GI19388@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <363875943e9d0e13bee6ed28239280543e6e5055.1337308722.git.koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <363875943e9d0e13bee6ed28239280543e6e5055.1337308722.git.koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: dm-devel.ids

On Thu, May 17, 2012 at 10:59:56PM -0400, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org wrote:
> From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> This is for the new bio splitting code. When we split a bio, if the
> split occured on a bvec boundry we reuse the bvec for the new bio. But
> that means bio_free() can't free it, hence the explicit flag.
> 
> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/bio.c                  |    3 ++-
>  include/linux/blk_types.h |    1 +
>  2 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/bio.c b/fs/bio.c
> index ecc9088..3332800 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -234,7 +234,7 @@ void bio_free(struct bio *bio, struct bio_set *bs)
>  {
>  	void *p;
>  
> -	if (bio_has_allocated_vec(bio))
> +	if (bio_flagged(bio, BIO_HAS_VEC))
>  		bvec_free_bs(bs, bio->bi_io_vec, BIO_POOL_IDX(bio));

We can remove bio_has_allocated_vec()?

Thanks.

-- 
tejun
