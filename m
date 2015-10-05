From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: block: flush queued bios when the process blocks
Date: Mon, 5 Oct 2015 16:59:44 -0400
Message-ID: <20151005205943.GB25762@redhat.com>
References: <alpine.LRH.2.02.1405271059190.27492@file01.intranet.prod.int.rdu2.redhat.com>
 <5384AA79.4010206@kernel.dk>
 <alpine.LRH.2.02.1405271120390.31404@file01.intranet.prod.int.rdu2.redhat.com>
 <5384B26D.1000703@kernel.dk>
 <alpine.LRH.2.02.1405271222150.8745@file01.intranet.prod.int.rdu2.redhat.com>
 <5384CE82.90601@kernel.dk>
 <alpine.LRH.2.02.1405291944090.22123@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1405291944090.22123@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>, "Alasdair G. Kergon" <agk@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, May 29 2014 at  7:52pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Tue, 27 May 2014, Jens Axboe wrote:
> 
> > On 2014-05-27 10:26, Mikulas Patocka wrote:
> > > On Tue, 27 May 2014, Jens Axboe wrote:
> > > 
> > > > On 2014-05-27 09:23, Mikulas Patocka wrote:
> > > > 
> > > > > The patch adds bio list flushing to the scheduler just besides plug
> > > > > flushsing.
> > > > 
> > > > ... which is exactly why I'm commenting. It'd be great to avoid yet one
> > > > more
> > > > scheduler hook for this sort of thing.
> > > > 
> > > > --
> > > > Jens Axboe
> > > 
> > > One could create something like schedule notifier chain, but I'm not sure
> > > if it is worth the complexity because of just two users. If more users
> > > come in the future, it could be generalized.
> > 
> > Except such a thing already exists, there are unplug callback chains. All I'm
> > asking is that you look into how feasible it would be to use something like
> > that, instead of reinventing the wheel.
> > 
> > -- 
> > Jens Axboe
> 
> 
> You can use this patch as an example that moves current->bio_list to 
> struct plug, but I don't recommend to put it in the kernel - this patch 
> still has some issues (some lvm raid tests fail).


Mikulas,

Could it be that cond_resched() wasn't unplugging?  As was
recently raised in this thread: https://lkml.org/lkml/2015/9/18/378
Chris Mason's patch from that thread fixed this	issue... I _think_ Linus
has since committed Chris' work but I haven't kept my finger on the
pulse of that issue.

FYI, I've put rebased versions of your 2 patches in my wip branch, see:
http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=wip

I tweaked the 2nd patch that adds bio_list to plug so that
generic_make_request's checks for in_generic_make_request isn't racey
(your original patch could happen to have current-plug set but
in_generic_make_request not yet set).

Anyway, I'm just dusting off your earlier work and seeing if I can make
sense of a way forward that meets Jens' approval.  Jens, if adding a
bio_list to struct blk_plug isn't what you were after either please be
more specific on what you would like to see...

Thanks,
Mike
