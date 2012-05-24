From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 09/14] block: Add an explicit bio flag for bios that
 own their bvec
Date: Thu, 24 May 2012 19:57:34 +0300
Message-ID: <4FBE687E.1030605@panasas.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com> <1337817771-25038-10-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337817771-25038-10-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

On 05/24/2012 03:02 AM, Kent Overstreet wrote:

> This is for the new bio splitting code. When we split a bio, if the
> split occured on a bvec boundry we reuse the bvec for the new bio. But
> that means bio_free() can't free it, hence the explicit flag.
> 




How do you insure that the original bio which owns the
bvec is not freed before the split-out bio.

Perhaps calling code needs to make sure by taking an extra
ref on the original bio, or something. If so a big fat comment
at bio_split is do.

And I understand you did not like my suggestion of negating
the meaning of the flag, so the default is zero?
Please say why?

Thanks
Boaz

> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Change-Id: I040f6b501088e882a9f013d6b6e730ff04e9c1da
> ---
>  fs/bio.c                  |    3 ++-
>  include/linux/bio.h       |    5 -----
>  include/linux/blk_types.h |    1 +
>  3 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/bio.c b/fs/bio.c
> index fc4a168..24b1d1c 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -241,7 +241,7 @@ void bio_free(struct bio *bio, struct bio_set *bs)
>  		return;
>  	}
>  
> -	if (bio_has_allocated_vec(bio))
> +	if (bio_flagged(bio, BIO_HAS_VEC))
>  		bvec_free_bs(bs, bio->bi_io_vec, BIO_POOL_IDX(bio));
>  
>  	if (bio_integrity(bio))
> @@ -312,6 +312,7 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
>  			goto err_free;
>  
>  		nr_iovecs = bvec_nr_vecs(idx);
> +		bio->bi_flags |= 1 << BIO_HAS_VEC;
>  	}
>  out_set:
>  	bio->bi_flags |= idx << BIO_POOL_OFFSET;
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 35f7c4d..8dd8cae 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -84,11 +84,6 @@ static inline void *bio_data(struct bio *bio)
>  	return NULL;
>  }
>  
> -static inline int bio_has_allocated_vec(struct bio *bio)
> -{
> -	return bio->bi_io_vec && bio->bi_io_vec != bio->bi_inline_vecs;
> -}
> -
>  /*
>   * will die
>   */
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index b6ddbf1..ab2252d 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -101,6 +101,7 @@ struct bio {
>  #define BIO_FS_INTEGRITY 9	/* fs owns integrity data, not block layer */
>  #define BIO_QUIET	10	/* Make BIO Quiet */
>  #define BIO_MAPPED_INTEGRITY 11/* integrity metadata has been remapped */
> +#define BIO_HAS_VEC	12	/* bio_free() should free bvec */
>  #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
>  
>  /*
