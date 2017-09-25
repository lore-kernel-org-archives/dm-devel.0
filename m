From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] dm-mpath: return DM_MAPIO_REQUEUE in case of rq
 allocation failure
Date: Mon, 25 Sep 2017 11:06:43 +0800
Message-ID: <20170925030641.GB7090@ming.t460p>
References: <20170922013506.22510-1-ming.lei@redhat.com>
 <1506092775.2512.5.camel@wdc.com>
 <20170922174431.GA21108@ming.t460p>
 <1506102888.2512.9.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1506102888.2512.9.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: dm-devel.ids

On Fri, Sep 22, 2017 at 05:54:48PM +0000, Bart Van Assche wrote:
> On Sat, 2017-09-23 at 01:44 +0800, Ming Lei wrote:
> > On Fri, Sep 22, 2017 at 03:06:16PM +0000, Bart Van Assche wrote:
> > > On Fri, 2017-09-22 at 09:35 +0800, Ming Lei wrote:
> > > > +		/*
> > > > +		 * blk-mq's SCHED_RESTART can cover this requeue, so
> > > > +		 * we needn't to deal with it by DELAY_REQUEUE. More
> > > > +		 * importantly, we have to return DM_MAPIO_REQUEUE
> > > > +		 * so that blk-mq can get the queue busy feedback,
> > > > +		 * otherwise I/O merge can be hurt.
> > > > +		 */
> > > > +		if (q->mq_ops)
> > > > +			return DM_MAPIO_REQUEUE;
> > > > +		else
> > > > +			return DM_MAPIO_DELAY_REQUEUE;
> > > >  	}
> > > 
> > > This patch is inferior to what I posted because this patch does not avoid
> > > the delay if multiple LUNs are associated with the same SCSI host. Consider
> > > e.g. the following configuration:
> > > * A single SCSI host with two SCSI LUNs associated to that host, e.g. /dev/sda
> > >   and /dev/sdb.
> > > * A dm-mpath instance has been created on top of /dev/sda.
> > > If all tags are in use by requests queued to /dev/sdb, no dm requests are in
> > > progress and a request is submitted against the dm-mpath device then the
> > > blk_get_request(q, GFP_ATOMIC) call will fail. The request will be requeued
> > > and the queue will be rerun after a delay.
> > > 
> > > My patch does not introduce a delay in this case.
> > 
> > That delay may not matter because SCHED_RESTART will run queue just
> > after one request is completed.
> 
> Did you understand what I wrote? SCHED_RESTART will be set for /dev/sdb but not
> for the dm queue. That's what I was trying to explain to you in my previous e-mail.

The patch I posted in this thread will set SCHED_RESTART for dm queue.

> 
> > There is at least one issue with get_request(GFP_NOIO): AIO
> > performance regression may not be caused, or even AIO may not
> > be possible. For example, user runs fio(libaio, randread, single
> > job, queue depth: 64, device: dm-mpath disk), if get_request(GFP_NOIO)
> > often blocks because of shared tags or out of tag, the actual queue
> > depth won't reach 64 at all, and may be just 1 in the worst case.
> > Once the actual queue depth is decreased much, random I/O performance
> > should be hurt a lot.
> 
> That's why we need to modify scsi_lld_busy(). If scsi_lld_busy() will be
> modified as I proposed in a previous e-mail then it will become very
> unlikely that no tag is available when blk_get_request() is called. With that
> scsi_lld_busy() modification it is even possible that we don't need to modify
> the dm-mpath driver.

Then post out a whole solution, and I'd like to take a look and test.

-- 
Ming
