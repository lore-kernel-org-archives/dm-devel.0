From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/1] block: fix blk_queue_split() resource exhaustion
Date: Fri, 8 Jul 2016 14:49:57 -0400
Message-ID: <20160708184957.GA10765@redhat.com>
References: <1467990243-3531-1-git-send-email-lars.ellenberg@linbit.com>
 <1467990243-3531-2-git-send-email-lars.ellenberg@linbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1467990243-3531-2-git-send-email-lars.ellenberg@linbit.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Keith Busch <keith.busch@intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, Ming Lei <ming.lei@canonical.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, NeilBrown <neilb@suse.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, linux-bcache@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Ingo Molnar <mingo@redhat.com>, Alasdair Kergon <agk@redhat.com>, Roland Kammerer <roland.kammerer@linbit.com>
List-Id: dm-devel.ids

On Fri, Jul 08 2016 at 11:04am -0400,
Lars Ellenberg <lars.ellenberg@linbit.com> wrote:

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
>  block/bio.c               | 27 +++++++++++++++++--------
>  block/blk-core.c          | 50 +++++++++++++++++++++++++----------------------
>  block/blk-merge.c         |  5 ++++-
>  drivers/md/bcache/btree.c | 12 ++++++------
>  drivers/md/dm-bufio.c     |  2 +-
>  drivers/md/md.h           |  7 +++++++
>  drivers/md/raid1.c        |  5 ++---
>  drivers/md/raid10.c       |  5 ++---
>  include/linux/bio.h       | 18 +++++++++++++++++
>  include/linux/sched.h     |  4 ++--
>  10 files changed, 88 insertions(+), 47 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 848cd35..1f9fcf0 100644
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
> @@ -380,6 +384,13 @@ static void punt_bios_to_rescuer(struct bio_set *bs)
>  	queue_work(bs->rescue_workqueue, &bs->rescue_work);
>  }
>  
> +static bool current_has_pending_bios(void)
> +{
> +	return current->bio_lists &&
> +		(!bio_list_empty(&current->bio_lists->queue) ||
> +		 !bio_list_empty(&current->bio_lists->recursion));
> +}
> +

This should be moved to include/linux/bio.h

> diff --git a/block/blk-core.c b/block/blk-core.c
> index 3cfd67d..74bceea 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2066,35 +2071,34 @@ blk_qc_t generic_make_request(struct bio *bio)
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
> +			/* XXX bio_list_init(&bio_lists_on_stack.recursion); */

Please remove this XXX commented code.

> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index b4f3352..b62e65f4 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -664,6 +664,13 @@ static inline void rdev_dec_pending(struct md_rdev *rdev, struct mddev *mddev)
>  	}
>  }
>  
> +static inline bool current_has_pending_bios(void)
> +{
> +	return current->bio_lists && (
> +	      !bio_list_empty(&current->bio_lists->queue) ||
> +	      !bio_list_empty(&current->bio_lists->recursion));
> +}
> +

This can be removed now that include/linux/bio.h exports the same.
