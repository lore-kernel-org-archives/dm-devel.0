From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [PATCH v2 1/1] block: fix blk_queue_split() resource exhaustion
Date: Fri, 23 Dec 2016 09:49:53 +0100
Message-ID: <76d9bf14-d848-4405-8358-3771c0a93d39@profitbricks.com>
References: <1467990243-3531-1-git-send-email-lars.ellenberg@linbit.com>
 <1467990243-3531-2-git-send-email-lars.ellenberg@linbit.com>
 <20160711141042.GY13335@soda.linbit>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160711141042.GY13335@soda.linbit>
Sender: linux-raid-owner@vger.kernel.org
To: Lars Ellenberg <lars.ellenberg@linbit.com>, Jens Axboe <axboe@kernel.dk>
Cc: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>, linux-block@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, linux-bcache@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Alasdair Kergon <agk@redhat.com>, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Roland Kammerer <roland.kammerer@linbit.com>
List-Id: dm-devel.ids

Dear Maintainers

I'd like to ask for the status of this patch since we hit the
issue too during our testing on md raid1.

Split remainder bio_A was queued ahead, following by bio_B for
lower device, at this moment raid start freezing, the loop take
out bio_A firstly and deliver it, which will hung since raid is
freezing, while the freezing never end since it waiting for
bio_B to finish, and bio_B is still on the queue, waiting for
bio_A to finish...

We're looking for a good solution and we found this patch
already progressed a lot, but we can't find it on linux-next,
so we'd like to ask are we still planning to have this fix
in upstream?

Regards,
Michael Wang


On 07/11/2016 04:10 PM, Lars Ellenberg wrote:
> For a long time, generic_make_request() converts recursion into
> iteration by queuing recursive arguments on current->bio_list.
> 
> This is convenient for stacking drivers,
> the top-most driver would take the originally submitted bio,
> and re-submit a re-mapped version of it, or one or more clones,
> or one or more new allocated bios to its backend(s). Which
> are then simply processed in turn, and each can again queue
> more "backend-bios" until we reach the bottom of the driver stack,
> and actually dispatch to the real backend device.
> 
> Any stacking driver ->make_request_fn() could expect that,
> once it returns, any backend-bios it submitted via recursive calls
> to generic_make_request() would now be processed and dispatched, before
> the current task would call into this driver again.
> 
> This is changed by commit
>   54efd50 block: make generic_make_request handle arbitrarily sized bios
> 
> Drivers may call blk_queue_split() inside their ->make_request_fn(),
> which may split the current bio into a front-part to be dealt with
> immediately, and a remainder-part, which may need to be split even
> further. That remainder-part will simply also be pushed to
> current->bio_list, and would end up being head-of-queue, in front
> of any backend-bios the current make_request_fn() might submit during
> processing of the fron-part.
> 
> Which means the current task would immediately end up back in the same
> make_request_fn() of the same driver again, before any of its backend
> bios have even been processed.
> 
> This can lead to resource starvation deadlock.
> Drivers could avoid this by learning to not need blk_queue_split(),
> or by submitting their backend bios in a different context (dedicated
> kernel thread, work_queue context, ...). Or by playing funny re-ordering
> games with entries on current->bio_list.
> 
> Instead, I suggest to distinguish between recursive calls to
> generic_make_request(), and pushing back the remainder part in
> blk_queue_split(), by pointing current->bio_lists to a
> 	struct recursion_to_iteration_bio_lists {
> 		struct bio_list recursion;
> 		struct bio_list queue;
> 	}
> 
> By providing each q->make_request_fn() with an empty "recursion"
> bio_list, then merging any recursively submitted bios to the
> head of the "queue" list, we can make the recursion-to-iteration
> logic in generic_make_request() process deepest level bios first,
> and "sibling" bios of the same level in "natural" order.
> 
> Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> Signed-off-by: Roland Kammerer <roland.kammerer@linbit.com>
> ---
>  block/bio.c               | 20 +++++++++++--------
>  block/blk-core.c          | 49 +++++++++++++++++++++++++----------------------
>  block/blk-merge.c         |  5 ++++-
>  drivers/md/bcache/btree.c | 12 ++++++------
>  drivers/md/dm-bufio.c     |  2 +-
>  drivers/md/raid1.c        |  5 ++---
>  drivers/md/raid10.c       |  5 ++---
>  include/linux/bio.h       | 25 ++++++++++++++++++++++++
>  include/linux/sched.h     |  4 ++--
>  9 files changed, 80 insertions(+), 47 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 848cd35..c2606fd 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -366,12 +366,16 @@ static void punt_bios_to_rescuer(struct bio_set *bs)
>  	 */
>  
>  	bio_list_init(&punt);
> -	bio_list_init(&nopunt);
>  
> -	while ((bio = bio_list_pop(current->bio_list)))
> +	bio_list_init(&nopunt);
> +	while ((bio = bio_list_pop(&current->bio_lists->recursion)))
>  		bio_list_add(bio->bi_pool == bs ? &punt : &nopunt, bio);
> +	current->bio_lists->recursion = nopunt;
>  
> -	*current->bio_list = nopunt;
> +	bio_list_init(&nopunt);
> +	while ((bio = bio_list_pop(&current->bio_lists->queue)))
> +		bio_list_add(bio->bi_pool == bs ? &punt : &nopunt, bio);
> +	current->bio_lists->queue = nopunt;
>  
>  	spin_lock(&bs->rescue_lock);
>  	bio_list_merge(&bs->rescue_list, &punt);
> @@ -453,13 +457,13 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
>  		 *
>  		 * We solve this, and guarantee forward progress, with a rescuer
>  		 * workqueue per bio_set. If we go to allocate and there are
> -		 * bios on current->bio_list, we first try the allocation
> -		 * without __GFP_DIRECT_RECLAIM; if that fails, we punt those
> -		 * bios we would be blocking to the rescuer workqueue before
> -		 * we retry with the original gfp_flags.
> +		 * bios on current->bio_lists->{recursion,queue}, we first try the
> +		 * allocation without __GFP_DIRECT_RECLAIM; if that fails, we
> +		 * punt those bios we would be blocking to the rescuer
> +		 * workqueue before we retry with the original gfp_flags.
>  		 */
>  
> -		if (current->bio_list && !bio_list_empty(current->bio_list))
> +		if (current_has_pending_bios())
>  			gfp_mask &= ~__GFP_DIRECT_RECLAIM;
>  
>  		p = mempool_alloc(bs->bio_pool, gfp_mask);
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 3cfd67d..2886a59b 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2040,7 +2040,7 @@ end_io:
>   */
>  blk_qc_t generic_make_request(struct bio *bio)
>  {
> -	struct bio_list bio_list_on_stack;
> +	struct recursion_to_iteration_bio_lists bio_lists_on_stack;
>  	blk_qc_t ret = BLK_QC_T_NONE;
>  
>  	if (!generic_make_request_checks(bio))
> @@ -2049,15 +2049,20 @@ blk_qc_t generic_make_request(struct bio *bio)
>  	/*
>  	 * We only want one ->make_request_fn to be active at a time, else
>  	 * stack usage with stacked devices could be a problem.  So use
> -	 * current->bio_list to keep a list of requests submited by a
> -	 * make_request_fn function.  current->bio_list is also used as a
> +	 * current->bio_lists to keep a list of requests submited by a
> +	 * make_request_fn function.  current->bio_lists is also used as a
>  	 * flag to say if generic_make_request is currently active in this
>  	 * task or not.  If it is NULL, then no make_request is active.  If
>  	 * it is non-NULL, then a make_request is active, and new requests
> -	 * should be added at the tail
> +	 * should be added at the tail of current->bio_lists->recursion;
> +	 * bios resulting from a call to blk_queue_split() from
> +	 * within ->make_request_fn() should be pushed back to the head of
> +	 * current->bio_lists->queue.
> +	 * After the current ->make_request_fn() returns, .recursion will be
> +	 * merged back to the head of .queue.
>  	 */
> -	if (current->bio_list) {
> -		bio_list_add(current->bio_list, bio);
> +	if (current->bio_lists) {
> +		bio_list_add(&current->bio_lists->recursion, bio);
>  		goto out;
>  	}
>  
> @@ -2066,35 +2071,33 @@ blk_qc_t generic_make_request(struct bio *bio)
>  	 * Before entering the loop, bio->bi_next is NULL (as all callers
>  	 * ensure that) so we have a list with a single bio.
>  	 * We pretend that we have just taken it off a longer list, so
> -	 * we assign bio_list to a pointer to the bio_list_on_stack,
> -	 * thus initialising the bio_list of new bios to be
> -	 * added.  ->make_request() may indeed add some more bios
> -	 * through a recursive call to generic_make_request.  If it
> -	 * did, we find a non-NULL value in bio_list and re-enter the loop
> -	 * from the top.  In this case we really did just take the bio
> -	 * of the top of the list (no pretending) and so remove it from
> -	 * bio_list, and call into ->make_request() again.
> +	 * we assign bio_list to a pointer to the bio_lists_on_stack,
> +	 * thus initialising the bio_lists of new bios to be added.
> +	 * ->make_request() may indeed add some more bios to .recursion
> +	 * through a recursive call to generic_make_request.  If it did,
> +	 * we find a non-NULL value in .recursion, merge .recursion back to the
> +	 * head of .queue, and re-enter the loop from the top.  In this case we
> +	 * really did just take the bio of the top of the list (no pretending)
> +	 * and so remove it from .queue, and call into ->make_request() again.
>  	 */
>  	BUG_ON(bio->bi_next);
> -	bio_list_init(&bio_list_on_stack);
> -	current->bio_list = &bio_list_on_stack;
> +	bio_list_init(&bio_lists_on_stack.queue);
> +	current->bio_lists = &bio_lists_on_stack;
>  	do {
>  		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
>  
>  		if (likely(blk_queue_enter(q, false) == 0)) {
> +			bio_list_init(&bio_lists_on_stack.recursion);
>  			ret = q->make_request_fn(q, bio);
> -
>  			blk_queue_exit(q);
> -
> -			bio = bio_list_pop(current->bio_list);
> +			bio_list_merge_head(&bio_lists_on_stack.queue,
> +					&bio_lists_on_stack.recursion);
>  		} else {
> -			struct bio *bio_next = bio_list_pop(current->bio_list);
> -
>  			bio_io_error(bio);
> -			bio = bio_next;
>  		}
> +		bio = bio_list_pop(&current->bio_lists->queue);
>  	} while (bio);
> -	current->bio_list = NULL; /* deactivate */
> +	current->bio_lists = NULL; /* deactivate */
>  
>  out:
>  	return ret;
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index c265348..df96327 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -172,6 +172,7 @@ void blk_queue_split(struct request_queue *q, struct bio **bio,
>  	struct bio *split, *res;
>  	unsigned nsegs;
>  
> +	BUG_ON(!current->bio_lists);
>  	if (bio_op(*bio) == REQ_OP_DISCARD)
>  		split = blk_bio_discard_split(q, *bio, bs, &nsegs);
>  	else if (bio_op(*bio) == REQ_OP_WRITE_SAME)
> @@ -190,7 +191,9 @@ void blk_queue_split(struct request_queue *q, struct bio **bio,
>  
>  		bio_chain(split, *bio);
>  		trace_block_split(q, split, (*bio)->bi_iter.bi_sector);
> -		generic_make_request(*bio);
> +		/* push back remainder, it may later be split further */
> +		bio_list_add_head(&current->bio_lists->queue, *bio);
> +		/* and fake submission of a suitably sized piece */
>  		*bio = split;
>  	}
>  }
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 76f7534..731ec3b 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -450,7 +450,7 @@ void __bch_btree_node_write(struct btree *b, struct closure *parent)
>  
>  	trace_bcache_btree_write(b);
>  
> -	BUG_ON(current->bio_list);
> +	BUG_ON(current->bio_lists);
>  	BUG_ON(b->written >= btree_blocks(b));
>  	BUG_ON(b->written && !i->keys);
>  	BUG_ON(btree_bset_first(b)->seq != i->seq);
> @@ -544,7 +544,7 @@ static void bch_btree_leaf_dirty(struct btree *b, atomic_t *journal_ref)
>  
>  	/* Force write if set is too big */
>  	if (set_bytes(i) > PAGE_SIZE - 48 &&
> -	    !current->bio_list)
> +	    !current->bio_lists)
>  		bch_btree_node_write(b, NULL);
>  }
>  
> @@ -889,7 +889,7 @@ static struct btree *mca_alloc(struct cache_set *c, struct btree_op *op,
>  {
>  	struct btree *b;
>  
> -	BUG_ON(current->bio_list);
> +	BUG_ON(current->bio_lists);
>  
>  	lockdep_assert_held(&c->bucket_lock);
>  
> @@ -976,7 +976,7 @@ retry:
>  	b = mca_find(c, k);
>  
>  	if (!b) {
> -		if (current->bio_list)
> +		if (current->bio_lists)
>  			return ERR_PTR(-EAGAIN);
>  
>  		mutex_lock(&c->bucket_lock);
> @@ -2127,7 +2127,7 @@ static int bch_btree_insert_node(struct btree *b, struct btree_op *op,
>  
>  	return 0;
>  split:
> -	if (current->bio_list) {
> +	if (current->bio_lists) {
>  		op->lock = b->c->root->level + 1;
>  		return -EAGAIN;
>  	} else if (op->lock <= b->c->root->level) {
> @@ -2209,7 +2209,7 @@ int bch_btree_insert(struct cache_set *c, struct keylist *keys,
>  	struct btree_insert_op op;
>  	int ret = 0;
>  
> -	BUG_ON(current->bio_list);
> +	BUG_ON(current->bio_lists);
>  	BUG_ON(bch_keylist_empty(keys));
>  
>  	bch_btree_op_init(&op.op, 0);
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index 6571c81..ba0c325 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -174,7 +174,7 @@ static inline int dm_bufio_cache_index(struct dm_bufio_client *c)
>  #define DM_BUFIO_CACHE(c)	(dm_bufio_caches[dm_bufio_cache_index(c)])
>  #define DM_BUFIO_CACHE_NAME(c)	(dm_bufio_cache_names[dm_bufio_cache_index(c)])
>  
> -#define dm_bufio_in_request()	(!!current->bio_list)
> +#define dm_bufio_in_request()	(!!current->bio_lists)
>  
>  static void dm_bufio_lock(struct dm_bufio_client *c)
>  {
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 10e53cd..38790e3 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -876,8 +876,7 @@ static sector_t wait_barrier(struct r1conf *conf, struct bio *bio)
>  				    (!conf->barrier ||
>  				     ((conf->start_next_window <
>  				       conf->next_resync + RESYNC_SECTORS) &&
> -				      current->bio_list &&
> -				      !bio_list_empty(current->bio_list))),
> +				      current_has_pending_bios())),
>  				    conf->resync_lock);
>  		conf->nr_waiting--;
>  	}
> @@ -1014,7 +1013,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
>  	struct r1conf *conf = mddev->private;
>  	struct bio *bio;
>  
> -	if (from_schedule || current->bio_list) {
> +	if (from_schedule || current->bio_lists) {
>  		spin_lock_irq(&conf->device_lock);
>  		bio_list_merge(&conf->pending_bio_list, &plug->pending);
>  		conf->pending_count += plug->pending_cnt;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 245640b..13a5341 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -945,8 +945,7 @@ static void wait_barrier(struct r10conf *conf)
>  		wait_event_lock_irq(conf->wait_barrier,
>  				    !conf->barrier ||
>  				    (conf->nr_pending &&
> -				     current->bio_list &&
> -				     !bio_list_empty(current->bio_list)),
> +				     current_has_pending_bios()),
>  				    conf->resync_lock);
>  		conf->nr_waiting--;
>  	}
> @@ -1022,7 +1021,7 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
>  	struct r10conf *conf = mddev->private;
>  	struct bio *bio;
>  
> -	if (from_schedule || current->bio_list) {
> +	if (from_schedule || current->bio_lists) {
>  		spin_lock_irq(&conf->device_lock);
>  		bio_list_merge(&conf->pending_bio_list, &plug->pending);
>  		conf->pending_count += plug->pending_cnt;
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index b7e1a008..2f8a361 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -541,6 +541,24 @@ struct bio_list {
>  	struct bio *tail;
>  };
>  
> +/* for generic_make_request() */
> +struct recursion_to_iteration_bio_lists {
> +	/* For stacking drivers submitting to their respective backend,
> +	 * bios are added to the tail of .recursion, which is re-initialized
> +	 * before each call to ->make_request_fn() and after that returns,
> +	 * the whole .recursion queue is then merged back to the head of .queue.
> +	 *
> +	 * The recursion-to-iteration logic in generic_make_request() will
> +	 * peel off of .queue.head, processing bios in deepest-level-first
> +	 * "natural" order. */
> +	struct bio_list recursion;
> +
> +	/* This keeps a list of to-be-processed bios.
> +	 * The "remainder" part resulting from calling blk_queue_split()
> +	 * will be pushed back to its head. */
> +	struct bio_list queue;
> +};
> +
>  static inline int bio_list_empty(const struct bio_list *bl)
>  {
>  	return bl->head == NULL;
> @@ -551,6 +569,13 @@ static inline void bio_list_init(struct bio_list *bl)
>  	bl->head = bl->tail = NULL;
>  }
>  
> +static inline bool current_has_pending_bios(void)
> +{
> +	return current->bio_lists &&
> +		(!bio_list_empty(&current->bio_lists->queue) ||
> +		 !bio_list_empty(&current->bio_lists->recursion));
> +}
> +
>  #define BIO_EMPTY_LIST	{ NULL, NULL }
>  
>  #define bio_list_for_each(bio, bl) \
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 6e42ada..146eedc 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -128,7 +128,7 @@ struct sched_attr {
>  
>  struct futex_pi_state;
>  struct robust_list_head;
> -struct bio_list;
> +struct recursion_to_iteration_bio_lists;
>  struct fs_struct;
>  struct perf_event_context;
>  struct blk_plug;
> @@ -1727,7 +1727,7 @@ struct task_struct {
>  	void *journal_info;
>  
>  /* stacked block device info */
> -	struct bio_list *bio_list;
> +	struct recursion_to_iteration_bio_lists *bio_lists;
>  
>  #ifdef CONFIG_BLOCK
>  /* stack plugging */
> 
