From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2] block: flush queued bios when the process blocks
Date: Thu, 8 Oct 2015 11:04:00 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1510081100510.9641@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1405271059190.27492@file01.intranet.prod.int.rdu2.redhat.com> <5384AA79.4010206@kernel.dk> <alpine.LRH.2.02.1405271120390.31404@file01.intranet.prod.int.rdu2.redhat.com> <5384B26D.1000703@kernel.dk>
 <alpine.LRH.2.02.1405271222150.8745@file01.intranet.prod.int.rdu2.redhat.com> <5384CE82.90601@kernel.dk> <alpine.LRH.2.02.1405291944090.22123@file01.intranet.prod.int.rdu2.redhat.com> <20151005205943.GB25762@redhat.com>
 <alpine.LRH.2.02.1510061410450.27916@file01.intranet.prod.int.rdu2.redhat.com> <20151006185016.GA31955@redhat.com> <20151006201637.GA4158@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151006201637.GA4158@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, kent.overstreet@gmail.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Tue, 6 Oct 2015, Mike Snitzer wrote:

> To give others context for why I'm caring about this issue again, this
> recent BZ against 4.3-rc served as a reminder that we _need_ a fix:
> https://bugzilla.redhat.com/show_bug.cgi?id=1267650
> 
> FYI, I cleaned up the plug-based approach a bit further, here is the
> incremental patch:
> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=wip&id=f73d001ec692125308accbb5ca26f892f949c1b6
> 
> And here is a new version of the overall combined patch (sharing now
> before I transition to looking at alternatives, though my gut is the use
> of a plug in generic_make_request really wouldn't hurt us.. famous last
> words):
> 
>  block/bio.c            | 82 +++++++++++++-------------------------------------
>  block/blk-core.c       | 21 ++++++++-----
>  drivers/md/dm-bufio.c  |  2 +-
>  drivers/md/raid1.c     |  6 ++--
>  drivers/md/raid10.c    |  6 ++--
>  include/linux/blkdev.h | 11 +++++--
>  include/linux/sched.h  |  4 ---
>  7 files changed, 51 insertions(+), 81 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index ad3f276..3d03668 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -354,35 +354,31 @@ static void bio_alloc_rescue(struct work_struct *work)
>  	}
>  }
>  
> -static void punt_bios_to_rescuer(struct bio_set *bs)
> +/**
> + * blk_flush_bio_list
> + * @plug: the blk_plug that may have collected bios
> + *
> + * Pop bios queued on plug->bio_list and submit each of them to
> + * their rescue workqueue.
> + *
> + * If the bio doesn't have a bio_set, we use the default fs_bio_set.
> + * However, stacking drivers should use bio_set, so this shouldn't be
> + * an issue.
> + */
> +void blk_flush_bio_list(struct blk_plug *plug)
>  {
> -	struct bio_list punt, nopunt;
>  	struct bio *bio;
>  
> -	/*
> -	 * In order to guarantee forward progress we must punt only bios that
> -	 * were allocated from this bio_set; otherwise, if there was a bio on
> -	 * there for a stacking driver higher up in the stack, processing it
> -	 * could require allocating bios from this bio_set, and doing that from
> -	 * our own rescuer would be bad.
> -	 *
> -	 * Since bio lists are singly linked, pop them all instead of trying to
> -	 * remove from the middle of the list:
> -	 */
> -
> -	bio_list_init(&punt);
> -	bio_list_init(&nopunt);
> -
> -	while ((bio = bio_list_pop(current->bio_list)))
> -		bio_list_add(bio->bi_pool == bs ? &punt : &nopunt, bio);
> -
> -	*current->bio_list = nopunt;
> -
> -	spin_lock(&bs->rescue_lock);
> -	bio_list_merge(&bs->rescue_list, &punt);
> -	spin_unlock(&bs->rescue_lock);
> +	while ((bio = bio_list_pop(&plug->bio_list))) {
> +		struct bio_set *bs = bio->bi_pool;
> +		if (!bs)
> +			bs = fs_bio_set;
>  
> -	queue_work(bs->rescue_workqueue, &bs->rescue_work);
> +		spin_lock(&bs->rescue_lock);
> +		bio_list_add(&bs->rescue_list, bio);
> +		queue_work(bs->rescue_workqueue, &bs->rescue_work);
> +		spin_unlock(&bs->rescue_lock);
> +	}
>  }
>  
>  /**
> @@ -422,7 +418,6 @@ static void punt_bios_to_rescuer(struct bio_set *bs)
>   */
>  struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
>  {
> -	gfp_t saved_gfp = gfp_mask;
>  	unsigned front_pad;
>  	unsigned inline_vecs;
>  	unsigned long idx = BIO_POOL_NONE;
> @@ -443,37 +438,8 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
>  		/* should not use nobvec bioset for nr_iovecs > 0 */
>  		if (WARN_ON_ONCE(!bs->bvec_pool && nr_iovecs > 0))
>  			return NULL;
> -		/*
> -		 * generic_make_request() converts recursion to iteration; this
> -		 * means if we're running beneath it, any bios we allocate and
> -		 * submit will not be submitted (and thus freed) until after we
> -		 * return.
> -		 *
> -		 * This exposes us to a potential deadlock if we allocate
> -		 * multiple bios from the same bio_set() while running
> -		 * underneath generic_make_request(). If we were to allocate
> -		 * multiple bios (say a stacking block driver that was splitting
> -		 * bios), we would deadlock if we exhausted the mempool's
> -		 * reserve.
> -		 *
> -		 * We solve this, and guarantee forward progress, with a rescuer
> -		 * workqueue per bio_set. If we go to allocate and there are
> -		 * bios on current->bio_list, we first try the allocation
> -		 * without __GFP_WAIT; if that fails, we punt those bios we
> -		 * would be blocking to the rescuer workqueue before we retry
> -		 * with the original gfp_flags.
> -		 */
> -
> -		if (current->bio_list && !bio_list_empty(current->bio_list))
> -			gfp_mask &= ~__GFP_WAIT;
>  
>  		p = mempool_alloc(bs->bio_pool, gfp_mask);
> -		if (!p && gfp_mask != saved_gfp) {
> -			punt_bios_to_rescuer(bs);
> -			gfp_mask = saved_gfp;
> -			p = mempool_alloc(bs->bio_pool, gfp_mask);
> -		}
> -
>  		front_pad = bs->front_pad;
>  		inline_vecs = BIO_INLINE_VECS;
>  	}
> @@ -486,12 +452,6 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
>  
>  	if (nr_iovecs > inline_vecs) {
>  		bvl = bvec_alloc(gfp_mask, nr_iovecs, &idx, bs->bvec_pool);
> -		if (!bvl && gfp_mask != saved_gfp) {
> -			punt_bios_to_rescuer(bs);
> -			gfp_mask = saved_gfp;
> -			bvl = bvec_alloc(gfp_mask, nr_iovecs, &idx, bs->bvec_pool);
> -		}
> -
>  		if (unlikely(!bvl))
>  			goto err_free;
>  
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 2eb722d..cf0706a 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1927,6 +1927,7 @@ end_io:
>  void generic_make_request(struct bio *bio)
>  {
>  	struct bio_list bio_list_on_stack;
> +	struct blk_plug plug;
>  
>  	if (!generic_make_request_checks(bio))
>  		return;
> @@ -1934,15 +1935,15 @@ void generic_make_request(struct bio *bio)
>  	/*
>  	 * We only want one ->make_request_fn to be active at a time, else
>  	 * stack usage with stacked devices could be a problem.  So use
> -	 * current->bio_list to keep a list of requests submited by a
> -	 * make_request_fn function.  current->bio_list is also used as a
> +	 * current->plug->bio_list to keep a list of requests submitted by a
> +	 * make_request_fn function.  current->plug->bio_list is also used as a
>  	 * flag to say if generic_make_request is currently active in this
>  	 * task or not.  If it is NULL, then no make_request is active.  If
>  	 * it is non-NULL, then a make_request is active, and new requests
>  	 * should be added at the tail
>  	 */
> -	if (current->bio_list) {
> -		bio_list_add(current->bio_list, bio);
> +	if (current->plug && current->plug->bio_list) {
> +		bio_list_add(&current->plug->bio_list, bio);
>  		return;
>  	}
>  
> @@ -1962,15 +1963,17 @@ void generic_make_request(struct bio *bio)
>  	 */
>  	BUG_ON(bio->bi_next);
>  	bio_list_init(&bio_list_on_stack);
> -	current->bio_list = &bio_list_on_stack;
> +	blk_start_plug(&plug);
> +	current->plug->bio_list = &bio_list_on_stack;
>  	do {
>  		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
>  
>  		q->make_request_fn(q, bio);
>  
> -		bio = bio_list_pop(current->bio_list);
> +		bio = bio_list_pop(current->plug->bio_list);
>  	} while (bio);
> -	current->bio_list = NULL; /* deactivate */
> +	current->plug->bio_list = NULL; /* deactivate */
> +	blk_finish_plug(&plug);
>  }
>  EXPORT_SYMBOL(generic_make_request);
>  
> @@ -3065,6 +3068,8 @@ void blk_start_plug(struct blk_plug *plug)
>  	INIT_LIST_HEAD(&plug->list);
>  	INIT_LIST_HEAD(&plug->mq_list);
>  	INIT_LIST_HEAD(&plug->cb_list);
> +	plug->bio_list = NULL;
> +
>  	/*
>  	 * Store ordering should not be needed here, since a potential
>  	 * preempt will imply a full memory barrier
> @@ -3151,6 +3156,8 @@ void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
>  	LIST_HEAD(list);
>  	unsigned int depth;
>  
> +	blk_flush_bio_list(plug);
> +
>  	flush_plug_callbacks(plug, from_schedule);
>  
>  	if (!list_empty(&plug->mq_list))
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index 2dd3308..c2bff16 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -168,7 +168,7 @@ static inline int dm_bufio_cache_index(struct dm_bufio_client *c)
>  #define DM_BUFIO_CACHE(c)	(dm_bufio_caches[dm_bufio_cache_index(c)])
>  #define DM_BUFIO_CACHE_NAME(c)	(dm_bufio_cache_names[dm_bufio_cache_index(c)])
>  
> -#define dm_bufio_in_request()	(!!current->bio_list)
> +#define dm_bufio_in_request()	(current->plug && !!current->plug->bio_list)

This condition is repeated several times throughout the whole patch - so 
maybe you should make it a function in block device header file.

Mikulas
