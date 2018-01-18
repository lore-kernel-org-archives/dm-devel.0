From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes idle
Date: Thu, 18 Jan 2018 13:30:39 -0500
Message-ID: <20180118183039.GA20121@redhat.com>
References: <20180118024124.8079-1-ming.lei@redhat.com>
 <b2e5b7e6-ce4b-6053-adae-63cc44d773af@wdc.com>
 <20180118170353.GB19734@redhat.com>
 <1516296056.2676.23.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1516296056.2676.23.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: dm-devel.ids

On Thu, Jan 18 2018 at 12:20pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Thu, 2018-01-18 at 12:03 -0500, Mike Snitzer wrote:
> > On Thu, Jan 18 2018 at 11:50am -0500,
> > Bart Van Assche <bart.vanassche@wdc.com> wrote:
> > > My comments about the above are as follows:
> > > - It can take up to q->rq_timeout jiffies after a .queue_rq()
> > >   implementation returned BLK_STS_RESOURCE before blk_mq_timeout_work()
> > >   gets called. However, it can happen that only a few milliseconds after
> > >   .queue_rq() returned BLK_STS_RESOURCE that the condition that caused
> > >   it to return BLK_STS_RESOURCE gets cleared. So the above approach can
> > >   result in long delays during which it will seem like the queue got
> > >   stuck. Additionally, I think that the block driver should decide how
> > >   long it takes before a queue is rerun and not the block layer core.
> > 
> > So configure q->rq_timeout to be shorter?  Which is configurable though
> > blk_mq_tag_set's 'timeout' member.  It apparently defaults to 30 * HZ.
> > 
> > That is the problem with timeouts, there is generally no one size fits
> > all.
> 
> Sorry but I think that would be wrong. The delay after which a queue is rerun
> should not be coupled to the request timeout. These two should be independent.

That's fair.  Not saying I think that is a fix anyway.

> > > - The lockup that I reported only occurs with the dm driver but not any
> > >   other block driver. So why to modify the block layer core since this
> > >   can be fixed by modifying the dm driver?
> > 
> > Hard to know it is only DM's blk-mq that is impacted.  That is the only
> > blk-mq driver that you're testing like this (that is also able to handle
> > faults, etc).
> 
> That's not correct. I'm also testing the SCSI core, which is one of the most
> complicated block drivers.

OK, but SCSI mq is part of the problem here.  It is a snowflake that
has more exotic reasons for returning BLK_STS_RESOURCE.

> > > - A much simpler fix and a fix that is known to work exists, namely
> > >   inserting a blk_mq_delay_run_hw_queue() call in the dm driver.
> > 
> > Because your "much simpler" fix actively hurts performance, as is
> > detailed in this header:
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.16&id=ec3eaf9a673106f66606896aed6ddd20180b02ec
> 
> We are close to the start of the merge window so I think it's better to fall
> back to an old approach that is known to work than to keep a new approach
> that is known not to work. Additionally, the performance issue you referred
> to only affects IOPS and bandwidth more than 1% with the lpfc driver and that
> is because the queue depth it supports is much lower than for other SCSI HBAs,
> namely 3 instead of 64.

1%!?  Where are you getting that number?  Ming has detailed more
significant performance gains than 1%.. and not just on lpfc (though you
keep seizing on lpfc because of the low queue_depth of 3).

This is all very tiresome.  I'm _really_ not interested in this debate
any more.  The specific case that causes the stall need to be identified
and a real fix needs to be developed.  Ming is doing a lot of that hard
work.  Please contribute or at least stop pleading for your hack to be
reintroduced.

If at the end of the 4.16 release we still don't have a handle on the
stall you're seeing I'll revisit this and likely revert to blindly
kicking the queue after an arbitrary delay.  But I'm willing to let this
issue get more time without papering over it.

Mike
