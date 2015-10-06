From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: block: flush queued bios when the process blocks
Date: Tue, 6 Oct 2015 09:28:20 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1510060919120.23547@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1405271059190.27492@file01.intranet.prod.int.rdu2.redhat.com> <5384AA79.4010206@kernel.dk> <alpine.LRH.2.02.1405271120390.31404@file01.intranet.prod.int.rdu2.redhat.com> <5384B26D.1000703@kernel.dk>
 <alpine.LRH.2.02.1405271222150.8745@file01.intranet.prod.int.rdu2.redhat.com> <5384CE82.90601@kernel.dk> <alpine.LRH.2.02.1405291944090.22123@file01.intranet.prod.int.rdu2.redhat.com> <20151005205943.GB25762@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151005205943.GB25762@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>, "Alasdair G. Kergon" <agk@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids



On Mon, 5 Oct 2015, Mike Snitzer wrote:

> Mikulas,
> 
> Could it be that cond_resched() wasn't unplugging?  As was
> recently raised in this thread: https://lkml.org/lkml/2015/9/18/378
> Chris Mason's patch from that thread fixed this	issue... I _think_ Linus
> has since committed Chris' work but I haven't kept my finger on the
> pulse of that issue.

I think it doesn't matter (regarding correctness) if cond_reched unplugs 
on not. If it didn't unplug, the process will be scheduled later, and it 
will eventually reach the point where it unplugs.

> FYI, I've put rebased versions of your 2 patches in my wip branch, see:
> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=wip
> 
> I tweaked the 2nd patch that adds bio_list to plug so that
> generic_make_request's checks for in_generic_make_request isn't racey
> (your original patch could happen to have current-plug set but
> in_generic_make_request not yet set).

I don't recommend that second patch 
(http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=wip&id=5e740c2e45a767d8d6ef8ca36b0db705ef6259c4). 
The patch just complicates things without adding any value. It's also not 
correct because it plugs bios at places when bios aren't supposed to be 
plugged

> Anyway, I'm just dusting off your earlier work and seeing if I can make
> sense of a way forward that meets Jens' approval.  Jens, if adding a
> bio_list to struct blk_plug isn't what you were after either please be
> more specific on what you would like to see...
> 
> Thanks,
> Mike

Mikulas
