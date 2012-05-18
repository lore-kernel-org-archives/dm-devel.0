From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 09/13] block: Add an explicit bio flag for bios that own
 their bvec
Date: Fri, 18 May 2012 20:07:40 +0300
Message-ID: <4FB681DC.7000700@panasas.com>
References: <cover.1337308722.git.koverstreet@google.com> <363875943e9d0e13bee6ed28239280543e6e5055.1337308722.git.koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <363875943e9d0e13bee6ed28239280543e6e5055.1337308722.git.koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: dm-devel.ids

On 05/18/2012 05:59 AM, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org wrote:

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
>  
>  	if (bio_integrity(bio))
> @@ -305,6 +305,7 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
>  			goto err_free;
>  
>  		nr_iovecs = bvec_nr_vecs(idx);
> +		bio->bi_flags |= 1 << BIO_HAS_VEC;
>  	}
>  out_set:
>  	bio->bi_flags |= idx << BIO_POOL_OFFSET;
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index bd9a610..10fca21 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -101,6 +101,7 @@ struct bio {
>  #define BIO_FS_INTEGRITY 9	/* fs owns integrity data, not block layer */
>  #define BIO_QUIET	10	/* Make BIO Quiet */
>  #define BIO_MAPPED_INTEGRITY 11/* integrity metadata has been remapped */
> +#define BIO_HAS_VEC	12	/* bio_free() should free bvec */


Just an English nit
BIO with out any VECs is when bi_max_vecs is zero. Id prefer a name that
denotes allocation or ownership.
BIO_OWN_VEC or BIO_ALLOC_VEC or BIO_DELETE_VEC

And one technical problem.

I would prefer to negate this bit. Zero is the default, set on
the exception. Safer and also more logical.

 BIO_NO_DELETE_VEC

>  #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
>  
>  /*



Thanks
Boaz
