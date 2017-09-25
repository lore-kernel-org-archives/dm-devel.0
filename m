From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mpath: return DM_MAPIO_REQUEUE in case of rq allocation
 failure
Date: Mon, 25 Sep 2017 12:17:03 -0400
Message-ID: <20170925161702.GA29036@redhat.com>
References: <20170922013506.22510-1-ming.lei@redhat.com>
 <1506092775.2512.5.camel@wdc.com>
 <20170922174431.GA21108@ming.t460p>
 <1506102888.2512.9.camel@wdc.com>
 <20170925030641.GB7090@ming.t460p>
 <1506352994.2641.4.camel@wdc.com>
 <20170925161014.GB16470@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170925161014.GB16470@ming.t460p>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: dm-devel.ids

On Mon, Sep 25 2017 at 12:10pm -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> On Mon, Sep 25, 2017 at 03:23:16PM +0000, Bart Van Assche wrote:
> > On Mon, 2017-09-25 at 11:06 +0800, Ming Lei wrote:
> > > On Fri, Sep 22, 2017 at 05:54:48PM +0000, Bart Van Assche wrote:
> > > > On Sat, 2017-09-23 at 01:44 +0800, Ming Lei wrote:
> > > > > On Fri, Sep 22, 2017 at 03:06:16PM +0000, Bart Van Assche wrote:
> > > > > > On Fri, 2017-09-22 at 09:35 +0800, Ming Lei wrote:
> > > > > > > +		/*
> > > > > > > +		 * blk-mq's SCHED_RESTART can cover this requeue, so
> > > > > > > +		 * we needn't to deal with it by DELAY_REQUEUE. More
> > > > > > > +		 * importantly, we have to return DM_MAPIO_REQUEUE
> > > > > > > +		 * so that blk-mq can get the queue busy feedback,
> > > > > > > +		 * otherwise I/O merge can be hurt.
> > > > > > > +		 */
> > > > > > > +		if (q->mq_ops)
> > > > > > > +			return DM_MAPIO_REQUEUE;
> > > > > > > +		else
> > > > > > > +			return DM_MAPIO_DELAY_REQUEUE;
> > > > > > >  	}
> > > > > > 
> > > > > > This patch is inferior to what I posted because this patch does not avoid
> > > > > > the delay if multiple LUNs are associated with the same SCSI host. Consider
> > > > > > e.g. the following configuration:
> > > > > > * A single SCSI host with two SCSI LUNs associated to that host, e.g. /dev/sda
> > > > > >   and /dev/sdb.
> > > > > > * A dm-mpath instance has been created on top of /dev/sda.
> > > > > > If all tags are in use by requests queued to /dev/sdb, no dm requests are in
> > > > > > progress and a request is submitted against the dm-mpath device then the
> > > > > > blk_get_request(q, GFP_ATOMIC) call will fail. The request will be requeued
> > > > > > and the queue will be rerun after a delay.
> > > > > > 
> > > > > > My patch does not introduce a delay in this case.
> > > > > 
> > > > > That delay may not matter because SCHED_RESTART will run queue just
> > > > > after one request is completed.
> > > > 
> > > > Did you understand what I wrote? SCHED_RESTART will be set for /dev/sdb but not
> > > > for the dm queue. That's what I was trying to explain to you in my previous e-mail.
> > > 
> > > The patch I posted in this thread will set SCHED_RESTART for dm queue.
> > 
> > This is not how communication on an open source mailing list is assumed to work.
> > If you know that you are wrong you are assumed either to shut up or to admit it.

Code speaks much better than unnecessarily caustic exchanges.  Not sure
why Bart persists with that.. but that's for him to sort out.
 
> You just mentioned 'This patch is inferior' and never explained my patch
> is wrong, so please go ahead and show me why this patch(the post in this
> thread, also the following link) is wrong.
> 
> 	https://marc.info/?l=linux-block&m=150604412910113&w=2
> 
> I admit both are two ways for the issue, but I don't think my patch
> is wrong. Your approach can be a very big change because .queue_rq()
> will block, and I also mentioned it might cause AIO regression.

I have no interest in changing DM multipath to block in .queue_rq()
So please consider that approach a dead end.

Ming, just iterate on your revised patchset, test and post when you're
happy with it.

Thanks,
Mike
