From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v3 01/16] block: Generalized bio pool freeing
Date: Mon, 28 May 2012 13:04:06 +0300
Message-ID: <4FC34D96.30402@panasas.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com> <1337977539-16977-2-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337977539-16977-2-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

On 05/25/2012 11:25 PM, Kent Overstreet wrote:
<snip>

> diff --git a/fs/bio.c b/fs/bio.c
> index e453924..3667cef 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -269,10 +269,6 @@ EXPORT_SYMBOL(bio_init);
>   *   bio_alloc_bioset will try its own mempool to satisfy the allocation.
>   *   If %__GFP_WAIT is set then we will block on the internal pool waiting
>   *   for a &struct bio to become free.
> - *
> - *   Note that the caller must set ->bi_destructor on successful return
> - *   of a bio, to do the appropriate freeing of the bio once the reference
> - *   count drops to zero.
>   **/
>  struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
>  {
> @@ -287,6 +283,7 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
>  	bio = p + bs->front_pad;
>  
>  	bio_init(bio);
> +	bio->bi_pool = bs;
>  


I really hate it that people in the Kernel at some point decided
to name bio_set(s) "pool". This is against Kernel style guide.

You don't overload the namespace and you don't call one-thing
another-thing.

For one "pool"s are already another thing. And for-most the struct
is bio_set a pointer to it should be called bio_set or in short
bs.

The original bio_set code kept the "bio_set" and/or "bs" naming
conventions. But later code. Kept breaking it with "pool". In
code and in comments.

But this Patch is the most blasphemous of all because it's
the first instance of block core code that calls it a "pool".
Up to now bio core kept the bio_set naming.

Please change the name to bi_bs so we can have:
+	bio->bi_bs = bs;

For me above code is an immediate alarm in my mind. Rrrr
false alarm. Please don't let my poor old mind Jump
unnecessarily.

>  	if (unlikely(!nr_iovecs))
>  		goto out_set;
> @@ -313,11 +310,6 @@ err_free:
>  }
>  EXPORT_SYMBOL(bio_alloc_bioset);
>  
> -static void bio_fs_destructor(struct bio *bio)
> -{
> -	bio_free(bio, fs_bio_set);
> -}
> -
>  /**
>   *	bio_alloc - allocate a new bio, memory pool backed
>   *	@gfp_mask: allocation mask to use
> @@ -339,12 +331,7 @@ static void bio_fs_destructor(struct bio *bio)
>   */
>  struct bio *bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
>  {
> -	struct bio *bio = bio_alloc_bioset(gfp_mask, nr_iovecs, fs_bio_set);
> -
> -	if (bio)
> -		bio->bi_destructor = bio_fs_destructor;
> -
> -	return bio;
> +	return bio_alloc_bioset(gfp_mask, nr_iovecs, fs_bio_set);
>  }
>  EXPORT_SYMBOL(bio_alloc);
>  
> @@ -419,7 +406,11 @@ void bio_put(struct bio *bio)
>  	 */
>  	if (atomic_dec_and_test(&bio->bi_cnt)) {
>  		bio->bi_next = NULL;
> -		bio->bi_destructor(bio);
> +
> +		if (bio->bi_pool)
> +			bio_free(bio, bio->bi_pool);
> +		else
> +			bio->bi_destructor(bio);
>  	}
>  }
>  EXPORT_SYMBOL(bio_put);
> @@ -470,12 +461,11 @@ EXPORT_SYMBOL(__bio_clone);
>   */
>  struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
>  {
> -	struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, fs_bio_set);
> +	struct bio *b = bio_alloc(gfp_mask, bio->bi_max_vecs);
>  
>  	if (!b)
>  		return NULL;
>  
> -	b->bi_destructor = bio_fs_destructor;
>  	__bio_clone(b, bio);
>  
>  	if (bio_integrity(bio)) {
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 4053cbd..dc0e399 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -70,6 +70,9 @@ struct bio {
>  	struct bio_integrity_payload *bi_integrity;  /* data integrity */
>  #endif
>  
> +	/* If bi_pool is non NULL, bi_destructor is not called */
> +	struct bio_set		*bi_pool;
> +


Please, Please , Please Don't forget this time. 
	bi_bs.
Pools are something a bit different (though related) in the
Kernel.

>  	bio_destructor_t	*bi_destructor;	/* destructor */
>  
>  	/*


BTW: I would have loved it if some brave sole would go and
     rename struct bio_set => bio_pool. Because when we speak
     about them they are pools. (And very much related to memory pools)

     And actually a set is something else. This here is definitely
     a pool. Because a set is a group of objects that have a relating
     trait, a relationship, a uniting factor. Its when we want to act
     on a group of objects as one unit.

Thanks
Boaz
