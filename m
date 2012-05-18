From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 04/13] block: Add bio_clone_kmalloc()
Date: Fri, 18 May 2012 19:45:28 +0300
Message-ID: <4FB67CA8.9050902@panasas.com>
References: <cover.1337308722.git.koverstreet@google.com> <1c7c2d4b89bc3d0e907608cec37bcf0ee50f4c0e.1337308722.git.koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1c7c2d4b89bc3d0e907608cec37bcf0ee50f4c0e.1337308722.git.koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: koverstreet@google.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, tj@kernel.org, axboe@kernel.dk, agk@redhat.com, neilb@suse.de
List-Id: dm-devel.ids

On 05/18/2012 05:59 AM, koverstreet@google.com wrote:

> From: Kent Overstreet <koverstreet@google.com>
> 


For the osdblk.c and exofs/ore.c bits. Thanks
looks nice.

ACK-by: Boaz Harrosh <bharrosh@panasas.com>

> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> ---
>  drivers/block/osdblk.c |    3 +--
>  drivers/block/rbd.c    |    8 ++------
>  fs/bio.c               |   13 +++++++++++++
>  fs/exofs/ore.c         |    5 ++---
>  include/linux/bio.h    |    1 +
>  5 files changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
> index 87311eb..1bbc681 100644
> --- a/drivers/block/osdblk.c
> +++ b/drivers/block/osdblk.c
> @@ -266,11 +266,10 @@ static struct bio *bio_chain_clone(struct bio *old_chain, gfp_t gfpmask)
>  	struct bio *tmp, *new_chain = NULL, *tail = NULL;
>  
>  	while (old_chain) {
> -		tmp = bio_kmalloc(gfpmask, old_chain->bi_max_vecs);
> +		tmp = bio_clone_kmalloc(old_chain, gfpmask);
>  		if (!tmp)
>  			goto err_out;
>  
> -		__bio_clone(tmp, old_chain);
>  		tmp->bi_bdev = NULL;
>  		gfpmask &= ~__GFP_WAIT;
>  		tmp->bi_next = NULL;
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 013c7a5..5a953c6 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -729,7 +729,7 @@ static struct bio *bio_chain_clone(struct bio **old, struct bio **next,
>  	}
>  
>  	while (old_chain && (total < len)) {
> -		tmp = bio_kmalloc(gfpmask, old_chain->bi_max_vecs);
> +		tmp = bio_clone_kmalloc(old_chain, gfpmask);
>  		if (!tmp)
>  			goto err_out;
>  
> @@ -751,13 +751,9 @@ static struct bio *bio_chain_clone(struct bio **old, struct bio **next,
>  			if (!bp)
>  				goto err_out;
>  
> -			__bio_clone(tmp, &bp->bio1);
> -
>  			*next = &bp->bio2;
> -		} else {
> -			__bio_clone(tmp, old_chain);
> +		} else
>  			*next = old_chain->bi_next;
> -		}
>  
>  		tmp->bi_bdev = NULL;
>  		gfpmask &= ~__GFP_WAIT;
> diff --git a/fs/bio.c b/fs/bio.c
> index 4cb621f..e2c0970 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -491,6 +491,19 @@ struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
>  }
>  EXPORT_SYMBOL(bio_clone);
>  
> +struct bio *bio_clone_kmalloc(struct bio *bio, gfp_t gfp_mask)
> +{
> +	struct bio *b = bio_kmalloc(gfp_mask, bio->bi_max_vecs);
> +
> +	if (!b)
> +		return NULL;
> +
> +	__bio_clone(b, bio);
> +
> +	return b;
> +}
> +EXPORT_SYMBOL(bio_clone_kmalloc);
> +
>  /**
>   *	bio_get_nr_vecs		- return approx number of vecs
>   *	@bdev:  I/O target
> diff --git a/fs/exofs/ore.c b/fs/exofs/ore.c
> index 49cf230..95c7264 100644
> --- a/fs/exofs/ore.c
> +++ b/fs/exofs/ore.c
> @@ -820,8 +820,8 @@ static int _write_mirror(struct ore_io_state *ios, int cur_comp)
>  			struct bio *bio;
>  
>  			if (per_dev != master_dev) {
> -				bio = bio_kmalloc(GFP_KERNEL,
> -						  master_dev->bio->bi_max_vecs);
> +				bio = bio_clone_kmalloc(master_dev->bio,
> +							GFP_KERNEL);
>  				if (unlikely(!bio)) {
>  					ORE_DBGMSG(
>  					      "Failed to allocate BIO size=%u\n",
> @@ -830,7 +830,6 @@ static int _write_mirror(struct ore_io_state *ios, int cur_comp)
>  					goto out;
>  				}
>  
> -				__bio_clone(bio, master_dev->bio);
>  				bio->bi_bdev = NULL;
>  				bio->bi_next = NULL;
>  				per_dev->offset = master_dev->offset;
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index e068a68..b27f16b 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -225,6 +225,7 @@ extern int bio_phys_segments(struct request_queue *, struct bio *);
>  extern void __bio_clone(struct bio *, struct bio *);
>  extern struct bio *bio_clone_bioset(struct bio *, gfp_t, struct bio_set *bs);
>  extern struct bio *bio_clone(struct bio *, gfp_t);
> +struct bio *bio_clone_kmalloc(struct bio *, gfp_t);
>  
>  extern void bio_init(struct bio *);
>  
