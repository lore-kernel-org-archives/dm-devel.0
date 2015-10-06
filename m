From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: block: flush queued bios when the process blocks
Date: Tue, 6 Oct 2015 10:26:48 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1510061020200.20214@file01.intranet.prod.int.rdu2.redhat.com>
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

A process rescheduled with cond_reched is not stuck, it will be run later. 
It may contribute to increased request latency, but it can't contribute to 
a deadlock.

Mikulas
