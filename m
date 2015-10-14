From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v3 for-4.4] block: flush queued bios when process blocks to avoid deadlock
Date: Wed, 14 Oct 2015 17:44:38 -0400
Message-ID: <x49wpupazw9.fsf@segfault.boston.devel.redhat.com>
References: <5384CE82.90601@kernel.dk>
	<alpine.LRH.2.02.1405291944090.22123@file01.intranet.prod.int.rdu2.redhat.com>
	<20151005205943.GB25762@redhat.com>
	<alpine.LRH.2.02.1510061410450.27916@file01.intranet.prod.int.rdu2.redhat.com>
	<20151006185016.GA31955@redhat.com> <20151006201637.GA4158@redhat.com>
	<alpine.LRH.2.02.1510081100510.9641@file01.intranet.prod.int.rdu2.redhat.com>
	<20151008150859.GA11770@redhat.com>
	<20151009195203.GA18790@redhat.com>
	<20151009195907.GB18790@redhat.com>
	<20151014204739.GA23449@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151014204739.GA23449@redhat.com> (Mike Snitzer's message of
	"Wed, 14 Oct 2015 16:47:39 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, kent.overstreet@gmail.com, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids


I don't see a problem with this.  Jens, I'm not sure what you were
getting at about the using the existing plugging infrastructure.  I
couldn't think of a clean way to integrate this code with the plugging.
They really do serve two separate purposes, and I don't think growing a
conditional in the scheduler hook is all that onerous.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

Mike Snitzer <snitzer@redhat.com> writes:

> From: Mikulas Patocka <mpatocka@redhat.com>
>
> The block layer uses per-process bio list to avoid recursion in
> generic_make_request.  When generic_make_request is called recursively,
> the bio is added to current->bio_list and generic_make_request returns
> immediately.  The top-level instance of generic_make_request takes bios
> from current->bio_list and processes them.
>
> Commit df2cb6daa4 ("block: Avoid deadlocks with bio allocation by
> stacking drivers") created a workqueue for every bio set and code
> in bio_alloc_bioset() that tries to resolve some low-memory deadlocks by
> redirecting bios queued on current->bio_list to the workqueue if the
> system is low on memory.  However another deadlock (see below **) may
> happen, without any low memory condition, because generic_make_request
> is queuing bios to current->bio_list (rather than submitting them).
>
> Fix this deadlock by redirecting any bios on current->bio_list to the
> bio_set's rescue workqueue on every schedule call.  Consequently, when
> the process blocks on a mutex, the bios queued on current->bio_list are
> dispatched to independent workqueus and they can complete without
> waiting for the mutex to be available.
>
> Also, now we can remove punt_bios_to_rescuer() and bio_alloc_bioset()'s
> calls to it because bio_alloc_bioset() will implicitly punt all bios on
> current->bio_list if it performs a blocking allocation.
>
> ** Here is the dm-snapshot deadlock that was observed:
>
> 1) Process A sends one-page read bio to the dm-snapshot target. The bio
> spans snapshot chunk boundary and so it is split to two bios by device
> mapper.
>
> 2) Device mapper creates the first sub-bio and sends it to the snapshot
> driver.
>
> 3) The function snapshot_map calls track_chunk (that allocates a structure
> dm_snap_tracked_chunk and adds it to tracked_chunk_hash) and then remaps
> the bio to the underlying device and exits with DM_MAPIO_REMAPPED.
>
> 4) The remapped bio is submitted with generic_make_request, but it isn't
> issued - it is added to current->bio_list instead.
>
> 5) Meanwhile, process B (dm's kcopyd) executes pending_complete for the
> chunk affected be the first remapped bio, it takes down_write(&s->lock)
> and then loops in __check_for_conflicting_io, waiting for
> dm_snap_tracked_chunk created in step 3) to be released.
>
> 6) Process A continues, it creates a second sub-bio for the rest of the
> original bio.
>
> 7) snapshot_map is called for this new bio, it waits on
> down_write(&s->lock) that is held by Process B (in step 5).
>
> Fixes: https://bugzilla.redhat.com/show_bug.cgi?id=1267650
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Depends-on: df2cb6daa4 ("block: Avoid deadlocks with bio allocation by stacking drivers")
> Cc: stable@vger.kernel.org
> ---
>  block/bio.c            | 75 +++++++++++++++++++-------------------------------
>  include/linux/blkdev.h | 19 +++++++++++--
>  kernel/sched/core.c    |  7 ++---
>  3 files changed, 48 insertions(+), 53 deletions(-)
>
> v3: improved patch header, changed sched/core.c block callout to blk_flush_queued_io(),
>     io_schedule_timeout() also updated to use blk_flush_queued_io(), blk_flush_bio_list()
>     now takes a @tsk argument rather than assuming current. v3 is now being submitted with
>     more feeling now that (ab)using the onstack plugging proved problematic, please see:
>     https://www.redhat.com/archives/dm-devel/2015-October/msg00087.html
>
> diff --git a/block/bio.c b/block/bio.c
> index ad3f276..99f5a2ad 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -354,35 +354,35 @@ static void bio_alloc_rescue(struct work_struct *work)
>  	}
>  }
>  
> -static void punt_bios_to_rescuer(struct bio_set *bs)
> +/**
> + * blk_flush_bio_list
> + * @tsk: task_struct whose bio_list must be flushed
> + *
> + * Pop bios queued on @tsk->bio_list and submit each of them to
> + * their rescue workqueue.
> + *
> + * If the bio doesn't have a bio_set, we leave it on @tsk->bio_list.
> + * However, stacking drivers should use bio_set, so this shouldn't be
> + * an issue.
> + */
> +void blk_flush_bio_list(struct task_struct *tsk)
>  {
> -	struct bio_list punt, nopunt;
>  	struct bio *bio;
> +	struct bio_list list = *tsk->bio_list;
> +	bio_list_init(tsk->bio_list);
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
> +	while ((bio = bio_list_pop(&list))) {
> +		struct bio_set *bs = bio->bi_pool;
> +		if (unlikely(!bs)) {
> +			bio_list_add(tsk->bio_list, bio);
> +			continue;
> +		}
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
> @@ -422,7 +422,6 @@ static void punt_bios_to_rescuer(struct bio_set *bs)
>   */
>  struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
>  {
> -	gfp_t saved_gfp = gfp_mask;
>  	unsigned front_pad;
>  	unsigned inline_vecs;
>  	unsigned long idx = BIO_POOL_NONE;
> @@ -457,23 +456,11 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
>  		 * reserve.
>  		 *
>  		 * We solve this, and guarantee forward progress, with a rescuer
> -		 * workqueue per bio_set. If we go to allocate and there are
> -		 * bios on current->bio_list, we first try the allocation
> -		 * without __GFP_WAIT; if that fails, we punt those bios we
> -		 * would be blocking to the rescuer workqueue before we retry
> -		 * with the original gfp_flags.
> +		 * workqueue per bio_set. If an allocation would block (due to
> +		 * __GFP_WAIT) the scheduler will first punt all bios on
> +		 * current->bio_list to the rescuer workqueue.
>  		 */
> -
> -		if (current->bio_list && !bio_list_empty(current->bio_list))
> -			gfp_mask &= ~__GFP_WAIT;
> -
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
> @@ -486,12 +473,6 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
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
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 19c2e94..5dc7415 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1084,6 +1084,22 @@ static inline bool blk_needs_flush_plug(struct task_struct *tsk)
>  		 !list_empty(&plug->cb_list));
>  }
>  
> +extern void blk_flush_bio_list(struct task_struct *tsk);
> +
> +static inline void blk_flush_queued_io(struct task_struct *tsk)
> +{
> +	/*
> +	 * Flush any queued bios to corresponding rescue threads.
> +	 */
> +	if (tsk->bio_list && !bio_list_empty(tsk->bio_list))
> +		blk_flush_bio_list(tsk);
> +	/*
> +	 * Flush any plugged IO that is queued.
> +	 */
> +	if (blk_needs_flush_plug(tsk))
> +		blk_schedule_flush_plug(tsk);
> +}
> +
>  /*
>   * tag stuff
>   */
> @@ -1671,11 +1687,10 @@ static inline void blk_flush_plug(struct task_struct *task)
>  {
>  }
>  
> -static inline void blk_schedule_flush_plug(struct task_struct *task)
> +static inline void blk_flush_queued_io(struct task_struct *tsk)
>  {
>  }
>  
> -
>  static inline bool blk_needs_flush_plug(struct task_struct *tsk)
>  {
>  	return false;
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 10a8faa..eaf9eb3 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3127,11 +3127,10 @@ static inline void sched_submit_work(struct task_struct *tsk)
>  	if (!tsk->state || tsk_is_pi_blocked(tsk))
>  		return;
>  	/*
> -	 * If we are going to sleep and we have plugged IO queued,
> +	 * If we are going to sleep and we have queued IO,
>  	 * make sure to submit it to avoid deadlocks.
>  	 */
> -	if (blk_needs_flush_plug(tsk))
> -		blk_schedule_flush_plug(tsk);
> +	blk_flush_queued_io(tsk);
>  }
>  
>  asmlinkage __visible void __sched schedule(void)
> @@ -4718,7 +4717,7 @@ long __sched io_schedule_timeout(long timeout)
>  	long ret;
>  
>  	current->in_iowait = 1;
> -	blk_schedule_flush_plug(current);
> +	blk_flush_queued_io(current);
>  
>  	delayacct_blkio_start();
>  	rq = raw_rq();
