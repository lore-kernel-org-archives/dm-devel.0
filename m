From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes idle
Date: Fri, 19 Jan 2018 15:26:24 +0800
Message-ID: <20180119072623.GB25369@ming.t460p>
References: <20180118024124.8079-1-ming.lei@redhat.com>
 <b2e5b7e6-ce4b-6053-adae-63cc44d773af@wdc.com>
 <20180118170353.GB19734@redhat.com>
 <1516296056.2676.23.camel@wdc.com>
 <20180118183039.GA20121@redhat.com>
 <1516301278.2676.35.camel@wdc.com>
 <deeb2b2e-6d0e-a144-843d-d08626de8aea@kernel.dk>
 <20180119023212.GA25413@ming.t460p>
 <eba1191e-4d59-a763-03b2-acd2d2812ea3@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <eba1191e-4d59-a763-03b2-acd2d2812ea3@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>
List-Id: dm-devel.ids

On Thu, Jan 18, 2018 at 09:02:45PM -0700, Jens Axboe wrote:
> On 1/18/18 7:32 PM, Ming Lei wrote:
> > On Thu, Jan 18, 2018 at 01:11:01PM -0700, Jens Axboe wrote:
> >> On 1/18/18 11:47 AM, Bart Van Assche wrote:
> >>>> This is all very tiresome.
> >>>
> >>> Yes, this is tiresome. It is very annoying to me that others keep
> >>> introducing so many regressions in such important parts of the kernel.
> >>> It is also annoying to me that I get blamed if I report a regression
> >>> instead of seeing that the regression gets fixed.
> >>
> >> I agree, it sucks that any change there introduces the regression. I'm
> >> fine with doing the delay insert again until a new patch is proven to be
> >> better.
> > 
> > That way is still buggy as I explained, since rerun queue before adding
> > request to hctx->dispatch_list isn't correct. Who can make sure the request
> > is visible when __blk_mq_run_hw_queue() is called?
> 
> That race basically doesn't exist for a 10ms gap.
> 
> > Not mention this way will cause performance regression again.
> 
> How so? It's _exactly_ the same as what you are proposing, except mine
> will potentially run the queue when it need not do so. But given that
> these are random 10ms queue kicks because we are screwed, it should not
> matter. The key point is that it only should be if we have NO better
> options. If it's a frequently occurring event that we have to return
> BLK_STS_RESOURCE, then we need to get a way to register an event for
> when that condition clears. That event will then kick the necessary
> queue(s).

Please see queue_delayed_work_on(), hctx->run_work is shared by all
scheduling, once blk_mq_delay_run_hw_queue(100ms) returns, no new
scheduling can make progress during the 100ms.

> 
> >> From the original topic of this email, we have conditions that can cause
> >> the driver to not be able to submit an IO. A set of those conditions can
> >> only happen if IO is in flight, and those cases we have covered just
> >> fine. Another set can potentially trigger without IO being in flight.
> >> These are cases where a non-device resource is unavailable at the time
> >> of submission. This might be iommu running out of space, for instance,
> >> or it might be a memory allocation of some sort. For these cases, we
> >> don't get any notification when the shortage clears. All we can do is
> >> ensure that we restart operations at some point in the future. We're SOL
> >> at that point, but we have to ensure that we make forward progress.
> > 
> > Right, it is a generic issue, not DM-specific one, almost all drivers
> > call kmalloc(GFP_ATOMIC) in IO path.
> 
> GFP_ATOMIC basically never fails, unless we are out of memory. The

I guess GFP_KERNEL may never fail, but GFP_ATOMIC failure might be
possible, and it is mentioned[1] there is such code in mm allocation
path, also OOM can happen too.

  if (some randomly generated condition) && (request is atomic)
      return NULL;

[1] https://lwn.net/Articles/276731/

> exception is higher order allocations. If a driver has a higher order
> atomic allocation in its IO path, the device driver writer needs to be
> taken out behind the barn and shot. Simple as that. It will NEVER work
> well in a production environment. Witness the disaster that so many NIC
> driver writers have learned.
> 
> This is NOT the case we care about here. It's resources that are more
> readily depleted because other devices are using them. If it's a high
> frequency or generally occurring event, then we simply must have a
> callback to restart the queue from that. The condition then becomes
> identical to device private starvation, the only difference being from
> where we restart the queue.
> 
> > IMO, there is enough time for figuring out a generic solution before
> > 4.16 release.
> 
> I would hope so, but the proposed solutions have not filled me with
> a lot of confidence in the end result so far.
> 
> >> That last set of conditions better not be a a common occurence, since
> >> performance is down the toilet at that point. I don't want to introduce
> >> hot path code to rectify it. Have the driver return if that happens in a
> >> way that is DIFFERENT from needing a normal restart. The driver knows if
> >> this is a resource that will become available when IO completes on this
> >> device or not. If we get that return, we have a generic run-again delay.
> > 
> > Now most of times both NVMe and SCSI won't return BLK_STS_RESOURCE, and
> > it should be DM-only which returns STS_RESOURCE so often.
> 
> Where does the dm STS_RESOURCE error usually come from - what's exact
> resource are we running out of?

It is from blk_get_request(underlying queue), see multipath_clone_and_map().

Thanks,
Ming
