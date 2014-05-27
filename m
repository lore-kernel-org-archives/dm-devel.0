From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: block: flush queued bios when the process blocks
Date: Tue, 27 May 2014 13:33:06 -0400
Message-ID: <20140527173306.GA12201@redhat.com>
References: <alpine.LRH.2.02.1405271059190.27492@file01.intranet.prod.int.rdu2.redhat.com>
 <5384AA79.4010206@kernel.dk>
 <alpine.LRH.2.02.1405271120390.31404@file01.intranet.prod.int.rdu2.redhat.com>
 <5384B26D.1000703@kernel.dk>
 <alpine.LRH.2.02.1405271222150.8745@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1405271222150.8745@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, May 27 2014 at 12:26pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> On Tue, 27 May 2014, Jens Axboe wrote:
> 
> > On 2014-05-27 09:23, Mikulas Patocka wrote:
> > 
> > > The patch adds bio list flushing to the scheduler just besides plug
> > > flushsing.
> > 
> > ... which is exactly why I'm commenting. It'd be great to avoid yet one more
> > scheduler hook for this sort of thing.
> > 
> > -- 
> > Jens Axboe
> 
> One could create something like schedule notifier chain, but I'm not sure 
> if it is worth the complexity because of just two users. If more users 
> come in the future, it could be generalized.

It could be that Jens is suggesting updating blk_needs_flush_plug() and
blk_schedule_flush_plug() to be bio_list aware too (rather than train
sched_submit_work() from this new bio_list)?

Somewhat awkward, but _could_ be made to work.
