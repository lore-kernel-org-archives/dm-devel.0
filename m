From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [dm-devel] [RFC] block: fix blk_queue_split() resource exhaustion
Date: Thu, 7 Jul 2016 10:16:17 +0200
Message-ID: <20160707081616.GH13335@soda.linbit>
References: <1466583730-28595-1-git-send-email-lars.ellenberg@linbit.com>
 <871t36ggcr.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <871t36ggcr.fsf@notabene.neil.brown.name>
Sender: linux-bcache-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, Ming Lei <ming.lei@canonical.com>, linux-bcache@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>, Keith Busch <keith.busch@intel.com>, Takashi Iwai <tiwai@suse.de>, dm-devel@redhat.com, Ingo Molnar <mingo@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Shaohua Li <shli@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, Roland Kammerer <roland.kammerer@linbit.com>
List-Id: dm-devel.ids

On Thu, Jul 07, 2016 at 03:35:48PM +1000, NeilBrown wrote:
> On Wed, Jun 22 2016, Lars Ellenberg wrote:
> 
> > For a long time, generic_make_request() converts recursion into
> > iteration by queuing recursive arguments on current->bio_list.
> >
> > This is convenient for stacking drivers,
> > the top-most driver would take the originally submitted bio,
> > and re-submit a re-mapped version of it, or one or more clones,
> > or one or more new allocated bios to its backend(s). Which
> > are then simply processed in turn, and each can again queue
> > more "backend-bios" until we reach the bottom of the driver stack,
> > and actually dispatch to the real backend device.
> >
> > Any stacking driver ->make_request_fn() could expect that,
> > once it returns, any backend-bios it submitted via recursive calls
> > to generic_make_request() would now be processed and dispatched, before
> > the current task would call into this driver again.
> >
> > This is changed by commit
> >   54efd50 block: make generic_make_request handle arbitrarily sized bios
> >
> > Drivers may call blk_queue_split() inside their ->make_request_fn(),
> > which may split the current bio into a front-part to be dealt with
> > immediately, and a remainder-part, which may need to be split even
> > further. That remainder-part will simply also be pushed to
> > current->bio_list, and would end up being head-of-queue, in front
> > of any backend-bios the current make_request_fn() might submit during
> > processing of the fron-part.
> >
> > Which means the current task would immediately end up back in the same
> > make_request_fn() of the same driver again, before any of its backend
> > bios have even been processed.
> >
> > This can lead to resource starvation deadlock.
> > Drivers could avoid this by learning to not need blk_queue_split(),
> > or by submitting their backend bios in a different context (dedicated
> > kernel thread, work_queue context, ...). Or by playing funny re-ordering
> > games with entries on current->bio_list.
> >
> > Instead, I suggest to distinguish between recursive calls to
> > generic_make_request(), and pushing back the remainder part in
> > blk_queue_split(), by pointing current->bio_lists to a
> > 	struct recursion_to_iteration_bio_lists {
> > 		struct bio_list recursion;
> > 		struct bio_list remainder;
> > 	}
> >
> > To have all bios targeted to drivers lower in the stack processed before
> > processing the next piece of a bio targeted at the higher levels,
> > as long as queued bios resulting from recursion are available,
> > they will continue to be processed in FIFO order.
> > Pushed back bio-parts resulting from blk_queue_split() will be processed
> > in LIFO order, one-by-one, whenever the recursion list becomes empty.
> 
> I really like this change.  It seems to precisely address the problem.
> The "problem" being that requests for "this" device are potentially
> mixed up with requests from underlying devices.
> However I'm not sure it is quite general enough.
> 
> The "remainder" list is a stack of requests aimed at "this" level or
> higher, and I think it will always exactly fit that description.
> The "recursion" list needs to be a queue of requests aimed at the next
> level down, and that doesn't quiet work, because once you start acting
> on the first entry in that list, all the rest become "this" level.

Uhm, well,
that's how it has been since you introduced this back in 2007, d89d879.
And it worked.

> I think you can address this by always calling ->make_request_fn with an
> empty "recursion", then after the call completes, splice the "recursion"
> list that resulted (if any) on top of the "remainder" stack.
> 
> This way, the "remainder" stack is always "requests for lower-level
> devices before request for upper level devices" and the "recursion"
> queue is always "requests for devices below the current level".

Yes, I guess that would work as well,
but may need "empirical proof" to check for performance regressions.

> I also really *don't* like the idea of punting to a separate thread - it
> seems to be just delaying the problem.
> 
> Can you try move the bio_list_init(->recursion) call to just before
> the ->make_request_fn() call, and adding
>     bio_list_merge_head(->remainder, ->recursion)
> just after?
> (or something like that) and confirm it makes sense, and works?

Sure, will do.
I'd suggest this would be a patch on its own though, on top of this one.
Because it would change the order in which stacked bios are processed
wrt the way it used to be since 2007 (my suggestion as is does not).

Which may change performance metrics.
It may even improve some of them,
or maybe it does nothing, but we don't know.

Thanks,

    Lars
