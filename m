From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/5] aio: Refactor aio_read_evt, use cmxchg(), fix bug
Date: Wed, 10 Oct 2012 19:51:02 -0700
Message-ID: <20121011025102.GE24174@moria.home.lan>
References: <1349764760-21093-5-git-send-email-koverstreet@google.com>
 <20121009183753.GP26187@lenny.home.zabbo.net>
 <20121009212724.GD29494@google.com>
 <20121009224703.GT26187@lenny.home.zabbo.net>
 <20121009225509.GA26835@google.com>
 <20121009231059.GV26187@lenny.home.zabbo.net>
 <20121010000600.GB26835@google.com>
 <20121010002634.GX26187@lenny.home.zabbo.net>
 <20121010004746.GF26835@google.com>
 <20121010214315.GE6371@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121010214315.GE6371-fypN+1c5dIyjpB87vu3CluTW4wlIGRCZ@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org
List-Id: dm-devel.ids

On Wed, Oct 10, 2012 at 02:43:15PM -0700, Zach Brown wrote:
> > True. But that could be solved with a separate interface that either
> > doesn't use a context to submit a call synchronously, or uses an
> > implicit per thread context.
> 
> Sure, but why bother if we can make the one submission interface fast
> enough to satisfy quick callers?  Less is more, and all that.

Very true, if it's possible. I'm just still skeptical.

> > I don't have a _strong_ opinion there, but my intuition is that we
> > shouldn't be creating new types of handles without a good reason. I
> > don't think the annoyances are for the most part particular to file
> > descriptors, I think the tend to be applicable to handles in general and
> > at least with file descriptors they're known and solved.
> 
> I strongly disagree.  That descriptors are an expensive limited
> resources is a perfectly good reason to not make them required to access
> the ring.

What's so special about aio vs. epoll, and now signalfd/eventfd/timerfd
etc.? 

> > That would be awesome, though for it to be worthwhile there couldn't be
> > any kernel notion of a context at all and I'm not sure if that's
> > practical. But the idea hadn't occured to me before and I'm sure you've
> > thought about it more than I have... hrm.
> > 
> > Oh hey, that's what acall does :P
> 
> :)
> 
> > For completions though you really want the ringbuffer pinned... what do
> > you do about that?
> 
> I don't think the kernel has to mandate that, no.  The code has to deal
> with completions faulting, but they probably won't.  In acall it
> happened that completions always came from threads that could block so
> its coping mechanism was to just use put_user() :).

Yeah, but that means the completion has to be delivered from process
context. That's not what aio does today, and it'd be a real performance
regression.

I don't know of a way around that myself.

> If userspace wants them rings locked, they can mlock() the memory.
> 
> Think about it from another angle: the current mechanism of creating an
> aio ring is a way to allocate pinned memory outside of the usual mlock
> accounting.  This could be abused, so aio grew an additional tunable to
> limit the number of total entries in rings in the system.
> 
> By putting the ring in normal user memory we avoid that problem
> entirely.

No different from any other place the kernel allocates memory on behalf
of userspace... it needs a general solution, not a bunch of special case
solutions (though since the general solution is memcg you might argue
the cure is worse than the disease... :P)
