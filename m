From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 for-4.4] block: flush queued bios when process blocks
 to avoid deadlock
Date: Tue, 20 Oct 2015 15:57:07 -0400
Message-ID: <20151020195707.GB31689@redhat.com>
References: <20151005205943.GB25762@redhat.com>
 <alpine.LRH.2.02.1510061410450.27916@file01.intranet.prod.int.rdu2.redhat.com>
 <20151006185016.GA31955@redhat.com>
 <20151006201637.GA4158@redhat.com>
 <alpine.LRH.2.02.1510081100510.9641@file01.intranet.prod.int.rdu2.redhat.com>
 <20151008150859.GA11770@redhat.com>
 <20151009195203.GA18790@redhat.com>
 <20151009195907.GB18790@redhat.com>
 <20151014204739.GA23449@redhat.com>
 <CACVXFVP7GwgWUHc4sHZwShwmdzFT5ZrHRcEH4zd5A8HommmCJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACVXFVP7GwgWUHc4sHZwShwmdzFT5ZrHRcEH4zd5A8HommmCJg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Sat, Oct 17 2015 at 12:04pm -0400,
Ming Lei <tom.leiming@gmail.com> wrote:

> On Thu, Oct 15, 2015 at 4:47 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> > From: Mikulas Patocka <mpatocka@redhat.com>
> >
> > The block layer uses per-process bio list to avoid recursion in
> > generic_make_request.  When generic_make_request is called recursively,
> > the bio is added to current->bio_list and generic_make_request returns
> > immediately.  The top-level instance of generic_make_request takes bios
> > from current->bio_list and processes them.
> >
> > Commit df2cb6daa4 ("block: Avoid deadlocks with bio allocation by
> > stacking drivers") created a workqueue for every bio set and code
> > in bio_alloc_bioset() that tries to resolve some low-memory deadlocks by
> > redirecting bios queued on current->bio_list to the workqueue if the
> > system is low on memory.  However another deadlock (see below **) may
> > happen, without any low memory condition, because generic_make_request
> > is queuing bios to current->bio_list (rather than submitting them).
> >
> > Fix this deadlock by redirecting any bios on current->bio_list to the
> > bio_set's rescue workqueue on every schedule call.  Consequently, when
> > the process blocks on a mutex, the bios queued on current->bio_list are
> > dispatched to independent workqueus and they can complete without
> > waiting for the mutex to be available.
> 
> It isn't common to acquire mutex/semaphone inside .make_request()
> or .request_fn(), so I am wondering it is good to reuse the rescuing
> workqueue for this unusual case.

Which specific locking are you concerned about?

> Also sometimes it can hurt performance by converting I/O submission
> from one context into concurrent contexts of workqueue, especially
> in case of sequential I/O, since plug & plug merge can't be used any
> more.

True, plug and plug merge wouldn't be usable but this recursive call to
generic_make_request isn't expected to be common.

This patch was to fix a relatively obscure bio spliting scenario that
fell out of the complexity of dm-snapshot.

> > diff --git a/block/bio.c b/block/bio.c
> > index ad3f276..99f5a2ad 100644
> > --- a/block/bio.c
> > +++ b/block/bio.c
> > @@ -354,35 +354,35 @@ static void bio_alloc_rescue(struct work_struct *work)
> >         }
> >  }
> >
> > -static void punt_bios_to_rescuer(struct bio_set *bs)
> > +/**
> > + * blk_flush_bio_list
> > + * @tsk: task_struct whose bio_list must be flushed
> > + *
> > + * Pop bios queued on @tsk->bio_list and submit each of them to
> > + * their rescue workqueue.
> > + *
> > + * If the bio doesn't have a bio_set, we leave it on @tsk->bio_list.
> > + * However, stacking drivers should use bio_set, so this shouldn't be
> > + * an issue.
> > + */
> > +void blk_flush_bio_list(struct task_struct *tsk)
...
> > +       while ((bio = bio_list_pop(&list))) {
> > +               struct bio_set *bs = bio->bi_pool;
> > +               if (unlikely(!bs)) {
> > +                       bio_list_add(tsk->bio_list, bio);
> > +                       continue;
> > +               }
> >
> > -       queue_work(bs->rescue_workqueue, &bs->rescue_work);
> > +               spin_lock(&bs->rescue_lock);
> > +               bio_list_add(&bs->rescue_list, bio);
> > +               queue_work(bs->rescue_workqueue, &bs->rescue_work);
> > +               spin_unlock(&bs->rescue_lock);
> > +       }
> 
> Not like rescuring path, schedule out can be quite frequent, and the
> above change will switch to submit these I/Os from wq concurrently,
> which might hurt performance for sequential I/O.
> 
> Also I am wondering why not submit these I/Os in 'current' context
> just like what flush plug does?

Flush plug during schedule makes use of kblockd so I'm not sure what
you're referring to here.

> >  }
> >
> >  /**
> > @@ -422,7 +422,6 @@ static void punt_bios_to_rescuer(struct bio_set *bs)
> >   */
> >  struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
> >  {
> > -       gfp_t saved_gfp = gfp_mask;
> >         unsigned front_pad;
> >         unsigned inline_vecs;
> >         unsigned long idx = BIO_POOL_NONE;
> > @@ -457,23 +456,11 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
> >                  * reserve.
> >                  *
> >                  * We solve this, and guarantee forward progress, with a rescuer
> > -                * workqueue per bio_set. If we go to allocate and there are
> > -                * bios on current->bio_list, we first try the allocation
> > -                * without __GFP_WAIT; if that fails, we punt those bios we
> > -                * would be blocking to the rescuer workqueue before we retry
> > -                * with the original gfp_flags.
> > +                * workqueue per bio_set. If an allocation would block (due to
> > +                * __GFP_WAIT) the scheduler will first punt all bios on
> > +                * current->bio_list to the rescuer workqueue.
> >                  */
> > -
> > -               if (current->bio_list && !bio_list_empty(current->bio_list))
> > -                       gfp_mask &= ~__GFP_WAIT;
> > -
> >                 p = mempool_alloc(bs->bio_pool, gfp_mask);
> > -               if (!p && gfp_mask != saved_gfp) {
> > -                       punt_bios_to_rescuer(bs);
> > -                       gfp_mask = saved_gfp;
> > -                       p = mempool_alloc(bs->bio_pool, gfp_mask);
> > -               }
> > -
> >                 front_pad = bs->front_pad;
> >                 inline_vecs = BIO_INLINE_VECS;
> >         }
> > @@ -486,12 +473,6 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
> >
> >         if (nr_iovecs > inline_vecs) {
> >                 bvl = bvec_alloc(gfp_mask, nr_iovecs, &idx, bs->bvec_pool);
> > -               if (!bvl && gfp_mask != saved_gfp) {
> > -                       punt_bios_to_rescuer(bs);
> > -                       gfp_mask = saved_gfp;
> > -                       bvl = bvec_alloc(gfp_mask, nr_iovecs, &idx, bs->bvec_pool);
> > -               }
> > -
> 
> Looks you touched rescuing path for bio allocation, and better to just
> do one thing in one patch.

Yes, good point, I've split the patches, you can see the result in the 2
topmost commits in this branch:

http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=wip

Definitely helped clean up the patches and make them more
approachable/reviewable.  Thanks for the suggestion.

I'll hold off on sending out v4 of these patches until I can better
undersatnd your concerns about using the rescue workqueue during
schedule.

Mike
