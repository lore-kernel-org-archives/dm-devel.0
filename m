From: Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v5 12/12] block: Only clone bio vecs that are
 in use
Date: Mon, 6 Aug 2012 19:16:33 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1208061913500.21956@file.rdu.redhat.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-13-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1344290921-25154-13-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: dm-devel.ids

Hi Kent

When you change the semantics of an exported function, rename that 
function. There may be external modules that use __bio_clone and this 
change could silently introduce bugs in them.

Otherwise, the patchset looks fine.

Mikulas


On Mon, 6 Aug 2012, Kent Overstreet wrote:

> bcache creates large bios internally, and then splits them according to
> the device requirements before it sends them down. If a lower level
> device tries to clone the bio, and the original bio had more than
> BIO_MAX_PAGES, the clone will fail unecessarily.
> 
> We can fix this by only cloning the bio vecs that are actually in use.
> 
> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/block/rbd.c |    2 +-
>  drivers/md/dm.c     |    5 ++---
>  fs/bio.c            |   13 +++++++------
>  3 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 692cf05..21edfe5 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -714,7 +714,7 @@ static struct bio *bio_chain_clone(struct bio **old, struct bio **next,
>  	}
>  
>  	while (old_chain && (total < len)) {
> -		tmp = bio_kmalloc(gfpmask, old_chain->bi_max_vecs);
> +		tmp = bio_kmalloc(gfpmask, bio_segments(old_chain));
>  		if (!tmp)
>  			goto err_out;
>  
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 3f3c26e..193fb19 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1057,11 +1057,10 @@ static struct bio *clone_bio(struct bio *bio, sector_t sector,
>  {
>  	struct bio *clone;
>  
> -	clone = bio_alloc_bioset(GFP_NOIO, bio->bi_max_vecs, bs);
> +	clone = bio_alloc_bioset(GFP_NOIO, bv_count, bs);
>  	__bio_clone(clone, bio);
>  	clone->bi_sector = sector;
> -	clone->bi_idx = idx;
> -	clone->bi_vcnt = idx + bv_count;
> +	clone->bi_vcnt = bv_count;
>  	clone->bi_size = to_bytes(len);
>  	clone->bi_flags &= ~(1 << BIO_SEG_VALID);
>  
> diff --git a/fs/bio.c b/fs/bio.c
> index 38ad026..631c67e 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -449,8 +449,9 @@ EXPORT_SYMBOL(bio_phys_segments);
>   */
>  void __bio_clone(struct bio *bio, struct bio *bio_src)
>  {
> -	memcpy(bio->bi_io_vec, bio_src->bi_io_vec,
> -		bio_src->bi_max_vecs * sizeof(struct bio_vec));
> +	memcpy(bio->bi_io_vec,
> +	       bio_iovec(bio_src),
> +	       bio_segments(bio_src) * sizeof(struct bio_vec));
>  
>  	/*
>  	 * most users will be overriding ->bi_bdev with a new target,
> @@ -459,10 +460,10 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
>  	bio->bi_sector = bio_src->bi_sector;
>  	bio->bi_bdev = bio_src->bi_bdev;
>  	bio->bi_flags |= 1 << BIO_CLONED;
> +	bio->bi_flags &= ~(1 << BIO_SEG_VALID);
>  	bio->bi_rw = bio_src->bi_rw;
> -	bio->bi_vcnt = bio_src->bi_vcnt;
> +	bio->bi_vcnt = bio_segments(bio_src);
>  	bio->bi_size = bio_src->bi_size;
> -	bio->bi_idx = bio_src->bi_idx;
>  }
>  EXPORT_SYMBOL(__bio_clone);
>  
> @@ -477,7 +478,7 @@ EXPORT_SYMBOL(__bio_clone);
>  struct bio *bio_clone_bioset(struct bio *bio, gfp_t gfp_mask,
>  			     struct bio_set *bs)
>  {
> -	struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, bs);
> +	struct bio *b = bio_alloc_bioset(gfp_mask, bio_segments(bio), bs);
>  
>  	if (!b)
>  		return NULL;
> @@ -507,7 +508,7 @@ EXPORT_SYMBOL(bio_clone);
>  
>  struct bio *bio_clone_kmalloc(struct bio *bio, gfp_t gfp_mask)
>  {
> -	struct bio *b = bio_kmalloc(gfp_mask, bio->bi_max_vecs);
> +	struct bio *b = bio_kmalloc(gfp_mask, bio_segments(bio));
>  
>  	if (!b)
>  		return NULL;
> -- 
> 1.7.7.3
> 
> --
> dm-devel mailing list
> dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
