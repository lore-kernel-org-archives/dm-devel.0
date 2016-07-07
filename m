From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: block: fix blk_queue_split() resource exhaustion
Date: Thu, 7 Jul 2016 08:47:12 -0400
Message-ID: <20160707124712.GC2737@redhat.com>
References: <1466583730-28595-1-git-send-email-lars.ellenberg@linbit.com>
 <871t36ggcr.fsf@notabene.neil.brown.name>
 <20160707081616.GH13335@soda.linbit>
 <20160707123937.GK13335@soda.linbit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160707123937.GK13335@soda.linbit>
Sender: linux-raid-owner@vger.kernel.org
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: NeilBrown <neilb@suse.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, Ming Lei <ming.lei@canonical.com>, linux-bcache@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>, Keith Busch <keith.busch@intel.com>, Takashi Iwai <tiwai@suse.de>, dm-devel@redhat.com, Ingo Molnar <mingo@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Shaohua Li <shli@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, Roland Kammerer <roland.kammerer@linbit.com>
List-Id: dm-devel.ids

On Thu, Jul 07 2016 at  8:39am -0400,
Lars Ellenberg <lars.ellenberg@linbit.com> wrote:

> On Thu, Jul 07, 2016 at 10:16:16AM +0200, Lars Ellenberg wrote:
> > > > Instead, I suggest to distinguish between recursive calls to
> > > > generic_make_request(), and pushing back the remainder part in
> > > > blk_queue_split(), by pointing current->bio_lists to a
> > > > 	struct recursion_to_iteration_bio_lists {
> > > > 		struct bio_list recursion;
> > > > 		struct bio_list remainder;
> > > > 	}
> > > >
> > > > To have all bios targeted to drivers lower in the stack processed before
> > > > processing the next piece of a bio targeted at the higher levels,
> > > > as long as queued bios resulting from recursion are available,
> > > > they will continue to be processed in FIFO order.
> > > > Pushed back bio-parts resulting from blk_queue_split() will be processed
> > > > in LIFO order, one-by-one, whenever the recursion list becomes empty.
> > > 
> > > I really like this change.  It seems to precisely address the problem.
> > > The "problem" being that requests for "this" device are potentially
> > > mixed up with requests from underlying devices.
> > > However I'm not sure it is quite general enough.
> > > 
> > > The "remainder" list is a stack of requests aimed at "this" level or
> > > higher, and I think it will always exactly fit that description.
> > > The "recursion" list needs to be a queue of requests aimed at the next
> > > level down, and that doesn't quiet work, because once you start acting
> > > on the first entry in that list, all the rest become "this" level.
> > 
> > Uhm, well,
> > that's how it has been since you introduced this back in 2007, d89d879.
> > And it worked.
> > 
> > > I think you can address this by always calling ->make_request_fn with an
> > > empty "recursion", then after the call completes, splice the "recursion"
> > > list that resulted (if any) on top of the "remainder" stack.
> > > 
> > > This way, the "remainder" stack is always "requests for lower-level
> > > devices before request for upper level devices" and the "recursion"
> > > queue is always "requests for devices below the current level".
> > 
> > Yes, I guess that would work as well,
> > but may need "empirical proof" to check for performance regressions.
> > 
> > > I also really *don't* like the idea of punting to a separate thread - it
> > > seems to be just delaying the problem.
> > > 
> > > Can you try move the bio_list_init(->recursion) call to just before
> > > the ->make_request_fn() call, and adding
> > >     bio_list_merge_head(->remainder, ->recursion)
> > > just after?
> > > (or something like that) and confirm it makes sense, and works?
> > 
> > Sure, will do.
> 
> Attached,
> on top of the patch of my initial post.
> Also fixes the issue for me.
> 
> > I'd suggest this would be a patch on its own though, on top of this one.
> > Because it would change the order in which stacked bios are processed
> > wrt the way it used to be since 2007 (my suggestion as is does not).
> > 
> > Which may change performance metrics.
> > It may even improve some of them,
> > or maybe it does nothing, but we don't know.
> > 
> > Thanks,
> > 
> >     Lars
> > 

> From 73254eae63786aca0af10e42e5b41465c90d8da8 Mon Sep 17 00:00:00 2001
> From: Lars Ellenberg <lars.ellenberg@linbit.com>
> Date: Thu, 7 Jul 2016 11:03:30 +0200
> Subject: [PATCH] block: generic_make_request() recursive bios: process deepest
>  levels first
> 
> By providing each q->make_request_fn() with an empty "recursion"
> bio_list, then merging any recursively submitted bios to the
> head of the "remainder" list, we can make the recursion-to-iteration
> logic in generic_make_request() process deepest level bios first.
> 
> ---
> 
> As suggested by Neil Brown while discussing
> [RFC] block: fix blk_queue_split() resource exhaustion
> https://lkml.org/lkml/2016/7/7/27

Will look closer at this today, thanks!
