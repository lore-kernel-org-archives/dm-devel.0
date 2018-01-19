From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] dm rq: Avoid that request processing stalls sporadically
Date: Fri, 19 Jan 2018 14:36:48 +0800
Message-ID: <20180119063647.GA25369@ming.t460p>
References: <20180118163707.11825-1-bart.vanassche@wdc.com>
 <20180119001136.GA4712@ming.t460p>
 <1516320863.2676.104.camel@wdc.com>
 <20180119001834.GB4712@ming.t460p>
 <040c195c-732e-70e8-3a54-89c5939e815c@kernel.dk>
 <20180119003516.GD4712@ming.t460p>
 <91af852d-cb1b-f306-d899-d72de4023d8d@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <91af852d-cb1b-f306-d899-d72de4023d8d@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>
List-Id: dm-devel.ids

On Thu, Jan 18, 2018 at 05:49:10PM -0700, Jens Axboe wrote:
> On 1/18/18 5:35 PM, Ming Lei wrote:
> > On Thu, Jan 18, 2018 at 05:24:29PM -0700, Jens Axboe wrote:
> >> On 1/18/18 5:18 PM, Ming Lei wrote:
> >>> On Fri, Jan 19, 2018 at 12:14:24AM +0000, Bart Van Assche wrote:
> >>>> On Fri, 2018-01-19 at 08:11 +0800, Ming Lei wrote:
> >>>>> On Thu, Jan 18, 2018 at 08:37:07AM -0800, Bart Van Assche wrote:
> >>>>>> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> >>>>>> index f16096af879a..c59c59cfd2a5 100644
> >>>>>> --- a/drivers/md/dm-rq.c
> >>>>>> +++ b/drivers/md/dm-rq.c
> >>>>>> @@ -761,6 +761,7 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
> >>>>>>  		/* Undo dm_start_request() before requeuing */
> >>>>>>  		rq_end_stats(md, rq);
> >>>>>>  		rq_completed(md, rq_data_dir(rq), false);
> >>>>>> +		blk_mq_delay_run_hw_queue(hctx, 100/*ms*/);
> >>>>>>  		return BLK_STS_RESOURCE;
> >>>>>>  	}
> >>>>>>  
> >>>>>
> >>>>> Nak.
> >>>>
> >>>> This patch fixes a regression that was introduced by you. You should know
> >>>> that regressions are not acceptable. If you don't agree with this patch,
> >>>> please fix the root cause.
> >>>
> >>> Yesterday I sent a patch, did you test that?
> >>
> >> That patch isn't going to be of much help. It might prevent you from
> >> completely stalling, but it might take you tens of seconds to get there.
> > 
> > Yeah, that is true, and why I marked it as RFC, but the case is so rare to
> > happen.
> 
> You don't know that. If the resource is very limited, or someone else
> is gobbling up all of it, then it may trigger quite often. Granted,
> in that case, you need some way of signaling the freeing of those
> resources to make it efficient.
> 
> >> On top of that, it's a rolling timer that gets added when IO is queued,
> >> and re-added if IO is pending when it fires. If the latter case is not
> >> true, then it won't get armed again. So if IO fails to queue without
> >> any other IO pending, you're pretty much in the same situation as if
> > 
> > No IO pending detection may take a bit time, we can do it after
> > BLK_STS_RESOURCE is returned and SCHED_RESTART is set. I have done
> > this way in the following patch, what do you think of it?
> > 
> > https://github.com/ming1/linux/commit/f866ce0b97b0ae22d033881da7eb07706fd458b4
> 
> I think it's overly complicated. As I wrote in a lengthier email earlier
> today, just ensure that we have a unique return code from the driver for
> when it aborts queuing an IO due to a resource shortage that isn't tied
> to it's own consumption of it. When we get that return, do a delayed
> queue run after X amount of time to ensure we always try again. If you
> want to get fancy (later on), you could track the frequency of such
> returns and complain if it's too high.

Suppose the new introduced return code is BLK_STS_NO_DEV_RESOURCE.

This way may degrade performance, for example, DM-MPATH returns
BLK_STS_NO_DEV_RESOURCE when blk_get_request() returns NULL, blk-mq
handles it by blk_mq_delay_run_hw_queue(10ms). Then blk_mq_sched_restart()
is just triggered when one DM-MPATH request is completed, that means one
request of underlying queue is completed too, but blk_mq_sched_restart()
still can't make progress during the 10ms.

That means we should only run blk_mq_delay_run_hw_queue(10ms/100ms) when
the queue is idle.

I will post out the patch in github for discussion.

Thanks,
Ming
