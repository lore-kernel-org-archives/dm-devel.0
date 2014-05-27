From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] block: flush queued bios when the process blocks
Date: Tue, 27 May 2014 15:56:00 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1405271526570.3223@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1405271059190.27492@file01.intranet.prod.int.rdu2.redhat.com> <5384AA79.4010206@kernel.dk> <alpine.LRH.2.02.1405271120390.31404@file01.intranet.prod.int.rdu2.redhat.com> <5384B26D.1000703@kernel.dk>
 <alpine.LRH.2.02.1405271222150.8745@file01.intranet.prod.int.rdu2.redhat.com> <5384CE82.90601@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5384CE82.90601@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids



On Tue, 27 May 2014, Jens Axboe wrote:

> On 2014-05-27 10:26, Mikulas Patocka wrote:
> > On Tue, 27 May 2014, Jens Axboe wrote:
> > 
> > > On 2014-05-27 09:23, Mikulas Patocka wrote:
> > > 
> > > > The patch adds bio list flushing to the scheduler just besides plug
> > > > flushsing.
> > > 
> > > ... which is exactly why I'm commenting. It'd be great to avoid yet one
> > > more
> > > scheduler hook for this sort of thing.
> > > 
> > > --
> > > Jens Axboe
> > 
> > One could create something like schedule notifier chain, but I'm not sure
> > if it is worth the complexity because of just two users. If more users
> > come in the future, it could be generalized.
> 
> Except such a thing already exists, there are unplug callback chains. All I'm
> asking is that you look into how feasible it would be to use something like
> that, instead of reinventing the wheel.
> 
> -- 
> Jens Axboe

Do you mean moving current->bio_list to struct blk_plug and calling 
blk_start_plug/blk_finish_plug around generic_make_request?

It would be possible on a condition that we can redirect all bios to a 
workqueue (i.e. eliminate bio_kmalloc and always use bio_alloc_bioset).

What are performance implications of this - does it make sense to have 
blk_start_plug/blk_finish_plug around every call to generic_make_request? 
- that means that all i/o requests will be added to a plug and then 
unplugged.

Mikulas
