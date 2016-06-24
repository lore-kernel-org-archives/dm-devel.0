From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [RFC] block: fix blk_queue_split() resource exhaustion
Date: Fri, 24 Jun 2016 16:27:11 +0200
Message-ID: <20160624142711.GF3239@soda.linbit>
References: <1466583730-28595-1-git-send-email-lars.ellenberg@linbit.com>
 <CACVXFVOtzcPpmg9Z_P6xN99dW=Sb_cCQNd-VcP0s5Nk0yHbwXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACVXFVOtzcPpmg9Z_P6xN99dW=Sb_cCQNd-VcP0s5Nk0yHbwXQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-block@vger.kernel.org, Roland Kammerer <roland.kammerer@linbit.com>, Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.com>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Takashi Iwai <tiwai@suse.de>, Jiri Kosina <jkosina@suse.cz>, Zheng Liu <gnehzuil.liu@gmail.com>, Keith Busch <keith.busch@intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On Fri, Jun 24, 2016 at 07:36:57PM +0800, Ming Lei wrote:
> >
> > This is not a theoretical problem.
> > At least int DRBD, and an unfortunately high IO concurrency wrt. the
> > "max-buffers" setting, without this patch we have a reproducible deadlock.
> 
> Is there any log about the deadlock? And is there any lockdep warning
> if it is enabled?

In DRBD, to avoid potentially very long internal queues as we wait for
our replication peer device and local backend, we limit the number of
in-flight bios we accept, and block in our ->make_request_fn() if that
number exceeds a configured watermark ("max-buffers").

Works fine, as long as we could assume that once our make_request_fn()
returns, any bios we "recursively" submitted against the local backend
would be dispatched. Which used to be the case.

commit 54efd50 block: make generic_make_request handle arbitrarily sized bios
introduced blk_queue_split(), which will split any bio that is
violating the queue limits into a smaller piece to be processed
right away, and queue the "rest" on current->bio_list to be
processed by the iteration in generic_make_request() once the
current ->make_request_fn() returns.

Before that, any user was supposed to go through bio_add_page(),
which would call our merge bvec function, and that should already
be sufficient to not violate queue limits.

Previously, typically the next in line bio to be processed would
be the cloned one we passed down to our backend device, which in
case of further stacking devices (e.g. logical volume, raid1 or
similar) may again push further bios on that list.
All of which would simply be processed in turn.

Now, with blk_queue_split(), the next-in-line bio would be the
next piece of the "too big" original bio, so we end up calling
several times into our ->make_request_fn() without even
dispatching one bio to the backend.

With highly concurrent IO and/or very small "max-buffers" setting,
this can deadlock, where the current submit path would wait for
the completion of the bios supposedly already passed to the
backend, but which actually are not even dispatched yet, rotting
away on current->bio_list.

I could code around that in various ways inside the DRBD make_request_fn,
or always dispatch the backend bios to a different (thread or work_queue)
context, but I'd rather have the distinction between "recursively
submitted" bios and "pushed back part of originally passed in bio" as
implemented in this patch.

Thanks,

    Lars

> > I'm unsure if it could cause problems in md raid in some corner cases
> > or when a rebuild/scrub/... starts in a "bad" moment.
> >
> > It also may increase "stress" on any involved bio_set,
> > because it may increase the number of bios that are allocated
> > before the first of them is actually processed, causing more
> > frequent calls of punt_bios_to_rescuer().
> >
> > Alternatively,
> > a simple one-line change to generic_make_request() would also "fix" it,
> > by processing all recursive bios in LIFO order.
> > But that may change the order in which bios reach the "physical" layer,
> > in case they are in fact split into many smaller pieces, for example in
> > a striping setup, which may have other performance implications.
> >
> >  | diff --git a/block/blk-core.c b/block/blk-core.c
> >  | index 2475b1c7..a5623f6 100644
> >  | --- a/block/blk-core.c
> >  | +++ b/block/blk-core.c
> >  | @@ -2048,7 +2048,7 @@ blk_qc_t generic_make_request(struct bio *bio)
> >  |       * should be added at the tail
> >  |       */
> >  |      if (current->bio_list) {
> >  | -            bio_list_add(current->bio_list, bio);
> >  | +            bio_list_add_head(current->bio_list, bio);
> >  |              goto out;
> >  |      }

> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 2475b1c7..f03ff4c 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -2031,7 +2031,7 @@ end_io:
> >   */
> >  blk_qc_t generic_make_request(struct bio *bio)
> >  {
> > -       struct bio_list bio_list_on_stack;
> > +       struct recursion_to_iteration_bio_lists bio_lists_on_stack;
> >         blk_qc_t ret = BLK_QC_T_NONE;
> >
> >         if (!generic_make_request_checks(bio))
> > @@ -2040,15 +2040,18 @@ blk_qc_t generic_make_request(struct bio *bio)

> > -       if (current->bio_list) {
> > -               bio_list_add(current->bio_list, bio);
> > +       if (current->bio_lists) {
> > +               bio_list_add(&current->bio_lists->recursion, bio);
> >                 goto out;
> >         }
> >

> > @@ -2067,8 +2070,9 @@ blk_qc_t generic_make_request(struct bio *bio)
> >          * bio_list, and call into ->make_request() again.
> >          */
> >         BUG_ON(bio->bi_next);
> > -       bio_list_init(&bio_list_on_stack);
> > -       current->bio_list = &bio_list_on_stack;
> > +       bio_list_init(&bio_lists_on_stack.recursion);
> > +       bio_list_init(&bio_lists_on_stack.remainder);
> > +       current->bio_lists = &bio_lists_on_stack;
> >         do {
> >                 struct request_queue *q = bdev_get_queue(bio->bi_bdev);
> >
> > @@ -2076,16 +2080,14 @@ blk_qc_t generic_make_request(struct bio *bio)
> >                         ret = q->make_request_fn(q, bio);
> >
> >                         blk_queue_exit(q);
> > -
> > -                       bio = bio_list_pop(current->bio_list);
> >                 } else {
> > -                       struct bio *bio_next = bio_list_pop(current->bio_list);
> > -
> >                         bio_io_error(bio);
> > -                       bio = bio_next;
> >                 }
> > +               bio = bio_list_pop(&current->bio_lists->recursion);
> > +               if (!bio)
> > +                       bio = bio_list_pop(&current->bio_lists->remainder);
> >         } while (bio);
> > -       current->bio_list = NULL; /* deactivate */
> > +       current->bio_lists = NULL; /* deactivate */
> >
> >  out:
> >         return ret;
> > diff --git a/block/blk-merge.c b/block/blk-merge.c
> > index 2613531..8da0c22 100644
> > --- a/block/blk-merge.c
> > +++ b/block/blk-merge.c
> > @@ -172,6 +172,7 @@ void blk_queue_split(struct request_queue *q, struct bio **bio,
> >         struct bio *split, *res;
> >         unsigned nsegs;
> >
> > +       BUG_ON(!current->bio_lists);
> >         if ((*bio)->bi_rw & REQ_DISCARD)
> >                 split = blk_bio_discard_split(q, *bio, bs, &nsegs);
> >         else if ((*bio)->bi_rw & REQ_WRITE_SAME)
> > @@ -190,7 +191,7 @@ void blk_queue_split(struct request_queue *q, struct bio **bio,
> >
> >                 bio_chain(split, *bio);
> >                 trace_block_split(q, split, (*bio)->bi_iter.bi_sector);
> > -               generic_make_request(*bio);
> > +               bio_list_add_head(&current->bio_lists->remainder, *bio);
> >                 *bio = split;

