From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V3 2/5] dm-mpath: return DM_MAPIO_REQUEUE in case of rq
 allocation failure
Date: Sat, 13 Jan 2018 09:29:25 +0800
Message-ID: <20180113012920.GA6150@ming.t460p>
References: <20180111060159.12991-1-ming.lei@redhat.com>
 <20180111060159.12991-3-ming.lei@redhat.com>
 <1515783866.2396.43.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515783866.2396.43.camel@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "snitzer@redhat.com" <snitzer@redhat.com>
List-Id: dm-devel.ids

On Fri, Jan 12, 2018 at 07:04:28PM +0000, Bart Van Assche wrote:
> On Thu, 2018-01-11 at 14:01 +0800, Ming Lei wrote:
> > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > index 86bf502a8e51..fcddf5a62581 100644
> > --- a/drivers/md/dm-mpath.c
> > +++ b/drivers/md/dm-mpath.c
> > @@ -533,8 +533,20 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
> >  		if (queue_dying) {
> >  			atomic_inc(&m->pg_init_in_progress);
> >  			activate_or_offline_path(pgpath);
> > +			return DM_MAPIO_DELAY_REQUEUE;
> >  		}
> > -		return DM_MAPIO_DELAY_REQUEUE;
> > +
> > +		/*
> > +		 * blk-mq's SCHED_RESTART can cover this requeue, so
> > +		 * we needn't to deal with it by DELAY_REQUEUE. More
> > +		 * importantly, we have to return DM_MAPIO_REQUEUE
> > +		 * so that blk-mq can get the queue busy feedback,
> > +		 * otherwise I/O merge can be hurt.
> > +		 */
> > +		if (q->mq_ops)
> > +			return DM_MAPIO_REQUEUE;
> > +		else
> > +			return DM_MAPIO_DELAY_REQUEUE;
> >  	}
> 
> Sorry but the approach of this patch looks wrong to me. I'm afraid that this
> approach will cause 100% CPU consumption if the underlying .queue_rq()
> function returns BLK_STS_RESOURCE for another reason than what can be detected
> by the .get_budget() call. This can happen if e.g. a SCSI LLD .queuecommand()
> implementation returns SCSI_MLQUEUE_HOST_BUSY. Many SCSI LLDs can do this:
> $ git grep 'SCSI_MLQUEUE_[^_]*_BUSY' | wc -l
> 204
> 
> Isn't this a severe regression?

No, it is not.

This DM_MAPIO_REQUEUE will be converted to BLK_STS_RESOURCE in dm-rq, then
it is returned to blk-mq. That means when running out of resource for
dispatching the underlying request, we tell blk-mq the truth. This
way has been used for other blk-mq drivers, such NVMe,..., more
importantly we have to provide this real feedback to blk-mq for fixing
the performance issue.

The blk_get_request(GFP_ATOMIC) is just like a kmalloc(ATOMIC),
and memory is shared system-wide too. You can see there are lots kmalloc(ATOMIC)
in NVMe IO path, when it fails, BLK_STS_RESOURCE is returned to blk-mq.

blk-mq has built-in SCHED_RESTART mechanism to handle out of RESOURCE
when BLK_STS_RESOURCE is observed.

We only implements .get_bugdet() in SCSI only, and other blk-mq drivers: NVMe,
..., often returns BLK_STS_RESOURCE to blk-mq too, so wrt. this usage there
isn't any difference between dm-mpath and other cases, right?


Thanks,
Ming
