From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: block: directly insert blk-mq request from
 blk_insert_cloned_request()
Date: Fri, 8 Sep 2017 18:03:18 -0400
Message-ID: <20170908220318.GA31120@redhat.com>
References: <1504620914.4135.11.camel@wdc.com>
 <20170907155255.GA22848@redhat.com>
 <756D2B3A-CD5A-4351-BC39-C2BAB771C740@linaro.org>
 <20170908164129.GA48286@redhat.com>
 <113c15ac-75f5-ff5b-695d-920dc6d5f708@kernel.dk>
 <20170908170727.GA29318@redhat.com>
 <20170908195805.GA30517@redhat.com>
 <57b4bb39-f50c-ad5e-d47d-01f0f84ec3ca@kernel.dk>
 <20170908214236.GA49918@redhat.com>
 <49cc6184-48da-2a45-e50e-13430e14e197@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49cc6184-48da-2a45-e50e-13430e14e197@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Paolo Valente <paolo.valente@linaro.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Sep 08 2017 at  5:50pm -0400,
Jens Axboe <axboe@kernel.dk> wrote:

> On 09/08/2017 03:42 PM, Mike Snitzer wrote:
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index d709c0e..7a06b2b 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -2342,7 +2342,7 @@ blk_status_t blk_insert_cloned_request(struct request_queue *q, struct request *
> >  	if (q->mq_ops) {
> >  		if (blk_queue_io_stat(q))
> >  			blk_account_io_start(rq, true);
> > -		blk_mq_sched_insert_request(rq, false, true, false, false);
> > +		blk_mq_insert_request(rq);
> >  		return BLK_STS_OK;
> >  	}
> 
> I think this is fine, since only dm uses this function. Would be nice to
> have some check though, to ensure it doesn't get misused in the future.

Not sure what kind of check you're thinking.

> 
> > diff --git a/block/blk-mq.c b/block/blk-mq.c
> > index 3f18cff..5c5bb3f 100644
> > --- a/block/blk-mq.c
> > +++ b/block/blk-mq.c
> > @@ -1401,6 +1401,24 @@ void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
> >  	blk_mq_hctx_mark_pending(hctx, ctx);
> >  }
> >  
> > +static inline void blk_mq_queue_io(struct blk_mq_hw_ctx *hctx,
> > +				   struct blk_mq_ctx *ctx,
> > +				   struct request *rq)
> > +{
> > +	spin_lock(&ctx->lock);
> > +	__blk_mq_insert_request(hctx, rq, false);
> > +	spin_unlock(&ctx->lock);
> > +}
> 
> Any particular reason it isn't just added to the dispatch queue?

I just started from the blk_mq_insert_request() that was removed as part
of commit bd166ef18 and then simplified it by reusing blk_mq_queue_io()
rather than open-coding it again.  So I moved blk_mq_queue_io() higher
in the file and re-used it.

Is there more efficiency associated with adding direct to dispatch
queue?  If so then I suppose it is worth it!  But me doing it would take
a bit more effort (to review code and expand my horizons, but that is
fine if that is what you'd prefer to see).

> > +void blk_mq_insert_request(struct request *rq)
> > +{
> > +	struct blk_mq_ctx *ctx = rq->mq_ctx;
> > +	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(rq->q, ctx->cpu);
> > +
> > +	blk_mq_queue_io(hctx, ctx, rq);
> > +	blk_mq_run_hw_queue(hctx, false);
> > +}
> 
> Would probably be cleaner as blk_mq_insert_and_run_request() or
> something, to make sure it's understood that it also runs the queue.

That's fine.  Feel free to tweak this patch however you like!  But if
you'd like me to completely own driving this patch forward I'll fold
this in to v2.

Mike
