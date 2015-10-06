From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: block: flush queued bios when the process blocks
Date: Tue, 6 Oct 2015 10:10:35 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1510060951530.23547@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1405271059190.27492@file01.intranet.prod.int.rdu2.redhat.com> <5384AA79.4010206@kernel.dk> <alpine.LRH.2.02.1405271120390.31404@file01.intranet.prod.int.rdu2.redhat.com> <5384B26D.1000703@kernel.dk>
 <alpine.LRH.2.02.1405271222150.8745@file01.intranet.prod.int.rdu2.redhat.com> <5384CE82.90601@kernel.dk> <alpine.LRH.2.02.1405291944090.22123@file01.intranet.prod.int.rdu2.redhat.com> <20151005205943.GB25762@redhat.com>
 <alpine.LRH.2.02.1510060919120.23547@file01.intranet.prod.int.rdu2.redhat.com> <20151006134753.GA30555@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151006134753.GA30555@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>, "Alasdair G. Kergon" <agk@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids



On Tue, 6 Oct 2015, Mike Snitzer wrote:

> On Tue, Oct 06 2015 at  9:28am -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > 
> > 
> > On Mon, 5 Oct 2015, Mike Snitzer wrote:
> > 
> > > Mikulas,
> > > 
> > > Could it be that cond_resched() wasn't unplugging?  As was
> > > recently raised in this thread: https://lkml.org/lkml/2015/9/18/378
> > > Chris Mason's patch from that thread fixed this	issue... I _think_ Linus
> > > has since committed Chris' work but I haven't kept my finger on the
> > > pulse of that issue.
> > 
> > I think it doesn't matter (regarding correctness) if cond_reched unplugs 
> > on not. If it didn't unplug, the process will be scheduled later, and it 
> > will eventually reach the point where it unplugs.
> 
> Couldn't the original deadlock you fixed (as described in your first
> patch) manifest when a new process is scheduled?
>  
> > > FYI, I've put rebased versions of your 2 patches in my wip branch, see:
> > > http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=wip
> > > 
> > > I tweaked the 2nd patch that adds bio_list to plug so that
> > > generic_make_request's checks for in_generic_make_request isn't racey
> > > (your original patch could happen to have current-plug set but
> > > in_generic_make_request not yet set).
> > 
> > I don't recommend that second patch 
> > (http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=wip&id=5e740c2e45a767d8d6ef8ca36b0db705ef6259c4). 
> > The patch just complicates things without adding any value. It's also not 
> > correct because it plugs bios at places when bios aren't supposed to be 
> > plugged
> 
> Avoiding another hook the the scheduler is a requirement (from Jens).
> "without adding any value": it offers a different strategy for recording
> bios to the bio_list by making it part of the plug.  The plug doesn't
> actually block bios like requests are plugged.

Unfortunatelly, it does (when the second patch is applied).

> What am I missing?

Bios allocated with bio_kmalloc can't be unplugged because they lack the 
rescurer workqueue (they shouldn't be used by the stacking drivers, they 
could only be used by top-level mm code). If you plug those bios at 
incorrect places (i.e. between blk_start_plug and blk_finish_plug), you 
are introducing other deadlock possibility.


> Avoiding another hook the the scheduler is a requirement (from Jens).

So, you can add a flag that is set when either current->plug or 
current->bio_list is non-NULL and if the flag is set, run a function that 
unplugs both current->plug and current->bio_list.

But anyway - if you look at struct task_struct, you see that "bio_list" 
and "plug" fields are next to each other - so they will likely be in the 
same cacheline. So testing current->bio_list in the schedule function has 
no performance overhead because the cacheline was already loaded when 
testing current->plug.

Mikulas
