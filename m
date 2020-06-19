From: Ming Lei <ming.lei@redhat.com>
Subject: Re: dm-rq: don't call blk_mq_queue_stopped in dm_stop_queue()
Date: Sat, 20 Jun 2020 07:14:51 +0800
Message-ID: <20200619231451.GD353853@T590>
References: <20200619084214.337449-1-ming.lei@redhat.com>
 <20200619094250.GA18410@redhat.com>
 <20200619101142.GA339442@T590>
 <20200619160657.GA24520@redhat.com>
 <20200619174040.GA24968@redhat.com>
 <20200619223744.GB353853@T590>
 <20200619225241.GC353853@T590>
 <20200619230404.GA26305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200619230404.GA26305@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, axboe@kernel.dk, Bart Van Assche <bvanassche@acm.org>
List-Id: dm-devel.ids

On Fri, Jun 19, 2020 at 07:04:05PM -0400, Mike Snitzer wrote:
> On Fri, Jun 19 2020 at  6:52pm -0400,
> Ming Lei <ming.lei@redhat.com> wrote:
> 
> > On Sat, Jun 20, 2020 at 06:37:44AM +0800, Ming Lei wrote:
> > > On Fri, Jun 19, 2020 at 01:40:41PM -0400, Mike Snitzer wrote:
> > > > On Fri, Jun 19 2020 at 12:06pm -0400,
> > > > Mike Snitzer <snitzer@redhat.com> wrote:
> > > > 
> > > > > On Fri, Jun 19 2020 at  6:11am -0400,
> > > > > Ming Lei <ming.lei@redhat.com> wrote:
> > > > > 
> > > > > > Hi Mike,
> > > > > > 
> > > > > > On Fri, Jun 19, 2020 at 05:42:50AM -0400, Mike Snitzer wrote:
> > > > > > > Hi Ming,
> > > > > > > 
> > > > > > > Thanks for the patch!  But I'm having a hard time understanding what
> > > > > > > you've written in the patch header,
> > > > > > > 
> > > > > > > On Fri, Jun 19 2020 at  4:42am -0400,
> > > > > > > Ming Lei <ming.lei@redhat.com> wrote:
> > > > > > > 
> > > > > > > > dm-rq won't stop queue, meantime blk-mq won't stop one queue too, so
> > > > > > > > remove the check.
> > > > > > > 
> > > > > > > It'd be helpful if you could unpack this with more detail before going on
> > > > > > > to explain why using blk_queue_quiesced, despite dm-rq using
> > > > > > > blk_mq_queue_stopped, would also be ineffective.
> > > > > > > 
> > > > > > > SO:
> > > > > > > 
> > > > > > > > dm-rq won't stop queue
> > > > > > > 
> > > > > > > 1) why won't dm-rq stop the queue?  Do you mean it won't reliably
> > > > > > >    _always_ stop the queue because of the blk_mq_queue_stopped() check?
> > > > > > 
> > > > > > device mapper doesn't call blk_mq_stop_hw_queue or blk_mq_stop_hw_queues.
> > > > > > 
> > > > > > > 
> > > > > > > > meantime blk-mq won't stop one queue too, so remove the check.
> > > > > > > 
> > > > > > > 2) Meaning?: blk_mq_queue_stopped() will return true even if only one hw
> > > > > > > queue is stopped, given blk-mq must stop all hw queues a positive return
> > > > > > > from this blk_mq_queue_stopped() check is incorrectly assuming it meanss
> > > > > > > all hw queues are stopped.
> > > > > > 
> > > > > > blk-mq won't call blk_mq_stop_hw_queue or blk_mq_stop_hw_queues for
> > > > > > dm-rq's queue too, so dm-rq's hw queue won't be stopped.
> > > > > > 
> > > > > > BTW blk_mq_stop_hw_queue or blk_mq_stop_hw_queues are supposed to be
> > > > > > used for throttling queue.
> > > > > 
> > > > > I'm going to look at actually stopping the queue (using one of these
> > > > > interfaces).  I didn't realize I wasn't actually stopping the queue.
> > > > > The intent was to do so.
> > > > > 
> > > > > In speaking with Jens yesterday about freeze vs stop: it is clear that
> > > > > dm-rq needs to still be able to allocate new requests, but _not_ call
> > > > > the queue_rq to issue the requests, while "stopped" (due to dm-mpath
> > > > > potentially deferring retries of failed requests because of path failure
> > > > > while quiescing the queue during DM device suspend).  But that freezing
> > > > > the queue goes too far because it won't allow such request allocation.
> > > > 
> > > > Seems I'm damned if I do (stop) or damned if I don't (new reports of
> > > > requests completing after DM device suspend's
> > > > blk_mq_quiesce_queue()+dm_wait_for_completion()).
> > > 
> > > request(but not new) completing is possible after blk_mq_quiesce_queue()+
> > > dm_wait_for_completion, because blk_mq_rq_inflight() only checks INFLIGHT
> > > request. If all requests are marked as MQ_RQ_COMPLETE, blk_mq_rq_inflight()
> > > still may return false. However, MQ_RQ_COMPLETE is one transient state.
> > > 
> > > So what does dm-rq expect from dm_wait_for_completion()?
> > > 
> > > If it is just no new request entering dm_queue_rq(), there shouldn't be
> > > issue.
> > > 
> > > If dm-rq hopes there aren't any real inflight request(MQ_RQ_COMPLETE &
> > > MQ_RQ_INFLIGHT), we can change blk_mq_rq_inflight to support that.
> > 
> > Hi Mike,
> > 
> > Please test the following patch and see if the issue can be fixed:
> > 
> > From faf0f9f15627446e8c35db518e37a4a2e4323eb2 Mon Sep 17 00:00:00 2001
> > From: Ming Lei <ming.lei@redhat.com>
> > Date: Sat, 20 Jun 2020 06:45:49 +0800
> > Subject: [PATCH] blk-mq: cover request of MQ_RQ_COMPLETE as inflight in
> >  blk_mq_rq_inflight
> > 
> > When request is marked as MQ_RQ_COMPLETE, ->complete isn't called & done
> > yet, and driver may expect that there isn't any driver related activity since
> > blk_mq_queue_inflight() returns.
> > 
> > Fixes it by covering request of MQ_RQ_COMPLETE as inflight in blk_mq_rq_inflight().
> > 
> > Cc: Mike Snitzer <snitzer@redhat.com>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  block/blk-mq.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/block/blk-mq.c b/block/blk-mq.c
> > index 4f57d27bfa73..7bc084b5bc37 100644
> > --- a/block/blk-mq.c
> > +++ b/block/blk-mq.c
> > @@ -831,7 +831,7 @@ static bool blk_mq_rq_inflight(struct blk_mq_hw_ctx *hctx, struct request *rq,
> >  	 * If we find a request that is inflight and the queue matches,
> >  	 * we know the queue is busy. Return false to stop the iteration.
> >  	 */
> > -	if (rq->state == MQ_RQ_IN_FLIGHT && rq->q == hctx->queue) {
> > +	if (rq->state != MQ_RQ_IDLE && rq->q == hctx->queue) {
> >  		bool *busy = priv;
> >  
> >  		*busy = true;
> > -- 
> > 2.25.2
> > 
> 
> I was going to ask if being more explit would be better:
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 4f57d27bfa73..96816ce57eb1 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -828,10 +828,11 @@ static bool blk_mq_rq_inflight(struct blk_mq_hw_ctx *hctx, struct request *rq,
>                                 void *priv, bool reserved)
>  {
>          /*
> -         * If we find a request that is inflight and the queue matches,
> +         * If we find a request that is inflight or complete and the queue matches,
>           * we know the queue is busy. Return false to stop the iteration.
>           */
> -        if (rq->state == MQ_RQ_IN_FLIGHT && rq->q == hctx->queue) {
> +        if ((rq->state == MQ_RQ_IN_FLIGHT || rq->state == MQ_RQ_COMPLETE) &&
> +            rq->q == hctx->queue) {
>                  bool *busy = priv;
> 
>                  *busy = true;
> 
> But is your patch more forgiving of any future blk-mq states that might
> also consistitute outstanding work?  Seems likely.

I am fine with either way since it is called in slow path.

But what matters is if it can fix this issue?

Thanks,
Ming
