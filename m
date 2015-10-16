From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] block: flush queued bios when the process blocks
Date: Fri, 16 Oct 2015 11:29:04 -0400
Message-ID: <20151016152903.GA5253@redhat.com>
References: <20151005205943.GB25762@redhat.com>
 <alpine.LRH.2.02.1510061410450.27916@file01.intranet.prod.int.rdu2.redhat.com>
 <20151006185016.GA31955@redhat.com>
 <20151006201637.GA4158@redhat.com>
 <alpine.LRH.2.02.1510081100510.9641@file01.intranet.prod.int.rdu2.redhat.com>
 <20151008150859.GA11770@redhat.com>
 <20151009195203.GA18790@redhat.com>
 <CACVXFVPgvKEJo1dPigk303=GGVc3fJnuEk+QP+VEf=xa_Lz+vA@mail.gmail.com>
 <20151015080610.GA25536@redhat.com>
 <CACVXFVP+sACdZObrm2gLZZBzi-b4OErADgva9o9Jk4ibM5Ddsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACVXFVP+sACdZObrm2gLZZBzi-b4OErADgva9o9Jk4ibM5Ddsg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, dm-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Oct 15 2015 at 11:08pm -0400,
Ming Lei <tom.leiming@gmail.com> wrote:

> On Thu, Oct 15, 2015 at 4:06 PM, Mike Snitzer <snitzer@redhat.com> wrote:
> > On Wed, Oct 14 2015 at 11:27pm -0400,
> > Ming Lei <tom.leiming@gmail.com> wrote:
> >
> >> On Sat, Oct 10, 2015 at 3:52 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> >> >
> >> > Turns out that this change:
> >> > http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=wip&id=2639638c77768a86216be456c2764e32a2bcd841
> >> >
> >> > needed to be reverted with:
> >> > http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=wip&id=ad3ccd760da7c05b90775372f9b39dc2964086fe
> >> >
> >> > Because nested plugs caused generic_make_request()'s onstack bio_list to
> >> > go out of scope (blk_finish_plug() wouldn't actually flush the list
> >> > within generic_make_request because XFS already added an outermost
> >> > plug).
> >>
> >> Looks you should have defined bio_list in plug as
> >>
> >>                'struct bio_list bio_list'
> >>
> >> instead of one pointer.
> >
> > I realized that and fixed it (see commit ad3ccd760da7c05b90 referenced
> > above that does exactly that).  That wasn't the problem.
> 
> OK.
> 
> >
> >> >
> >> > But even after fixing that I then hit issues with these changes now
> >> > resulting in imperfect 'in_generic_make_request' accounting that happens
> >> > lazily once the outermost plug completes blk_finish_plug.  manifested as
> >> > dm-bufio.c:dm_bufio_prefetch's BUG_ON(dm_bufio_in_request()); hitting.
> >>
> >> Looks this problem should be related with above 'bio_list' definition too.
> >
> > No, as I explained it was due to the nested plug:
> >
> >> >
> >> > Basically using the blk-core's onstack plugging isn't workable for
> >> > fixing this deadlock and we're back to having to seriously consider
> >> > this (with its additional hook in the scheduler)
> >
> > To elaborate, for the code in DM (and other subsystems like bcache) that
> > rely on accurate accounting of whether we're actively _in_
> > generic_make_request: using plug to store/manage the bio_list isn't
> 
> That looks an interesting requirement, which means DM just need to know
> if the current callsite is from generic_make_request(), so what you need
> is just one per-task variable.
> 
> With the stack variable of 'plug', it should be easier to do that for DM, for
> example, you can introduce one flag in 'struct blk_plug', then set it in
> the entry of generic_make_request(), and clear it in the exit of the
> function.

Yes, I mean we _could_ set/clear the 'in_generic_make_request' flag _in_
generic_make_request() but then it just calls into question why the heck
we're using the plug to begin with? (especially given plugging is for
request-based devices at this point!).

It really doesn't make _any_ sense to overload blk_plug by moving the
bio_list into there and adding a 'in_generic_make_request'... when you
consider the _only_ reason this was suggested is to (ab)use the existing
hook in scheduler/core.c.

So I stand by my position that there is really no point in the exercise
and that it actually hurts the code to try to make this a blk_plug
"feature".

We already have well established current->bio_list semantics that can be
reused as a flag given it is a pointer.  The block callout in the
scheduler is going to grow a conditional either way.  What I've proposed
_seems_ the cleanest to me and others.  Hopefully you can see that
aspect of things.

So if you could review the v3 patch with a critical eye that'd be very
much appreciated.

But I do look forward to Jens also having a look at this and providing
his review feedback.

> > workable because nested plugs change the lifetime of when the bio_list
> > is processed (as I implemented it -- which was to respect nested plugs).
> > I could've forced the issue by making the bio_list get processed
> > regardless of nesting but that would've made the onstack plugging much
> > more convoluted (duality between nested vs not just for bio_list's
> > benefit and for what gain?  Simply to avoid an extra conditional
> > immediately in the scheduler?  That conditional was still added anyway
> > but just as part of blk_needs_flush_plug so in the end there wasn't any
> > benefit!).
> >
> > Hopefully my middle-of-the-night reply is coherent and helped to clarify
> > my position that (ab)using blk_plug for the bio_list management is
> > _really_ awkward. ;)
> 
> Hope it wan't my reply to cause the break of your sleep, :-)

No, my dog woke me up to go outside at 4am.. I was up and couldn't
resist looking at my phone.. the rest is history ;)
