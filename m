From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V2 1/5] dm-mpath: don't call blk_mq_delay_run_hw_queue()
 in case of BLK_STS_RESOURCE
Date: Fri, 1 Dec 2017 10:01:03 +0800
Message-ID: <20171201020058.GA30132@ming.t460p>
References: <20171127050721.5884-1-ming.lei@redhat.com>
 <20171127050721.5884-2-ming.lei@redhat.com>
 <1511802882.2993.4.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1511802882.2993.4.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "osandov@fb.com" <osandov@fb.com>
List-Id: dm-devel.ids

On Mon, Nov 27, 2017 at 05:14:46PM +0000, Bart Van Assche wrote:
> On Mon, 2017-11-27 at 13:07 +0800, Ming Lei wrote:
> > If .queue_rq() returns BLK_STS_RESOURCE, blk-mq will rerun the queue in
> > the three situations:
> > 
> > 1) if BLK_MQ_S_SCHED_RESTART is set
> > - queue is rerun after one rq is completed, see blk_mq_sched_restart()
> > which is run from blk_mq_free_request()
> > 
> > 2) run out of driver tag
> > - queue is rerun after one tag is freed
> > 
> > 3) otherwise
> > - queue is run immediately in blk_mq_dispatch_rq_list()
> > 
> > This random dealy of running hw queue is introduced by commit 6077c2d706097c0
> > (dm rq: Avoid that request processing stalls sporadically), which claimed
> > one request processing stalling is fixed, but never explained the behind
> > idea, and it is a workaound at most. Even the question isn't explained by
> > anyone in recent discussion.
> > 
> > Also calling blk_mq_delay_run_hw_queue() inside .queue_rq() is a horrible
> > hack because it makes BLK_MQ_S_SCHED_RESTART not working, and degrades I/O
> > peformance a lot.
> > 
> > Finally this patch makes sure that dm-rq returns BLK_STS_RESOURCE to blk-mq
> > only when underlying queue is out of resource, so we switch to return
> > DM_MAPIO_DELAY_REQUEU if either MPATHF_QUEUE_IO or MPATHF_PG_INIT_REQUIRED
> > is set in multipath_clone_and_map().
> 
> Sorry but in my opinion the above description shows that you don't understand
> the dm-mpath driver completely.

I have to treat your above comment as a noop since you never provide a explanation.

Also I don't think it is wrong to deal with MPATHF_QUEUE_IO/MPATHF_PG_INIT_REQUIRED
via DM_MAPIO_DELAY_REQUEUE, since both can seldom happen, and the delay
won't cause performance issue.

The idea behind this change is that this patchset switches to return BLK_STS_RESOURCE
to blk-mq only when we run out of resource, but the above two(MPATHF_QUEUE_IO and
MPATHF_PG_INIT_REQUIRED) don't belong to 'run out of resource'.

> 
> > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > index c8faa2b85842..8fe3f45407ce 100644
> > --- a/drivers/md/dm-mpath.c
> > +++ b/drivers/md/dm-mpath.c
> > @@ -484,9 +484,7 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
> >  		return DM_MAPIO_KILL;
> >  	} else if (test_bit(MPATHF_QUEUE_IO, &m->flags) ||
> >  		   test_bit(MPATHF_PG_INIT_REQUIRED, &m->flags)) {
> > -		if (pg_init_all_paths(m))
> > -			return DM_MAPIO_DELAY_REQUEUE;
> > -		return DM_MAPIO_REQUEUE;
> > +		return DM_MAPIO_DELAY_REQUEUE;
> >  	}
> 
> This patch removes a pg_init_all_paths() call but you don't explain why you
> think it is allowed to remove that call. Did you perhaps remove that call by
> mistake?

OK, that is a problem, will fix it in V2.

-- 
Ming
