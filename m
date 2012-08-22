From: Adrian Bunk <bunk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 08/13] block: Add an explicit bio flag for bios that
 own their bvec
Date: Wed, 22 Aug 2012 20:43:52 +0300
Message-ID: <20120822174351.GA27453@bunk.dyndns.info>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-9-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1345655050-28199-9-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: dm-devel.ids

On Wed, Aug 22, 2012 at 10:04:05AM -0700, Kent Overstreet wrote:
>...
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -117,6 +117,7 @@ struct bio {
>   * BIO_POOL_IDX()
>   */
>  #define BIO_RESET_BITS	12
> +#define BIO_OWNS_VEC	12	/* bio_free() should free bvec */
>...

This doesn't look right.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
