From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] block: directly insert blk-mq request from
 blk_insert_cloned_request()
Date: Fri, 8 Sep 2017 17:42:36 -0400
Message-ID: <20170908214236.GA49918@redhat.com>
References: <AE77899A-0365-4C7C-91E4-5ACCC396B26B@linaro.org>
 <ED23C7AC-F202-40E3-8421-E714BF446399@linaro.org>
 <1504620914.4135.11.camel@wdc.com>
 <20170907155255.GA22848@redhat.com>
 <756D2B3A-CD5A-4351-BC39-C2BAB771C740@linaro.org>
 <20170908164129.GA48286@redhat.com>
 <113c15ac-75f5-ff5b-695d-920dc6d5f708@kernel.dk>
 <20170908170727.GA29318@redhat.com>
 <20170908195805.GA30517@redhat.com>
 <57b4bb39-f50c-ad5e-d47d-01f0f84ec3ca@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57b4bb39-f50c-ad5e-d47d-01f0f84ec3ca@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Paolo Valente <paolo.valente@linaro.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Sep 08 2017 at  4:28P -0400,
Jens Axboe <axboe@kernel.dk> wrote:

> On 09/08/2017 01:58 PM, Mike Snitzer wrote:
> > On Fri, Sep 08 2017 at  1:07pm -0400,
> > Mike Snitzer <snitzer@redhat.com> wrote:
> > 
> >> On Fri, Sep 08 2017 at 12:48pm -0400,
> >> Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >>>> Please see the following untested patch.  All
> >>>> testing/review/comments/acks appreciated.
> >>>>
> >>>> I elected to use elevator_change() rather than fiddle with adding a new
> >>>> blk-mq elevator hook (e.g. ->request_prepared) to verify that each
> >>>> blk-mq elevator enabled request did in fact get prepared.
> >>>>
> >>>> Bart, please test this patch and reply with your review/feedback.
> >>>>
> >>>> Jens, if you're OK with this solution please reply with your Ack and
> >>>> I'll send it to Linus along with the rest of the handful of DM changes I
> >>>> have for 4.14.
> >>>
> >>> I am not - we used to have this elevator change functionality from
> >>> inside the kernel, and finally got rid of it when certain drivers killed
> >>> it. I don't want to be bringing it back.
> >>
> >> Fine.
> > 
> > BTW, while I conceded "Fine": I think your justification for not
> > reintroducing elevator_change() lacks substance.  What is inherently
> > problematic about elevator_change()?
> 
> Because no in-kernel users should be mucking with the IO scheduler. Adding
> this back is just an excuse for drivers to start doing it again, which
> generally happens because whatever vendors driver team tests some synthetic
> benchmark and decide that X is better than the default of Y. So we're not
> going back to that.

Fine.  But I really mean it this time, fair position, thanks :)

> > Having an elevator attached to a DM multipath device's underlying path's
> > request_queue just asks for trouble (especially given the blk-mq
> > elevator interface).
> > 
> > Please own this issue as a regression and help me arrive at a timely way
> > forward.
> 
> I'm trying, I made suggestions on how we can proceed - we can have a way
> to insert to hctx->dispatch without bothering the IO scheduler. I'm
> open to other suggestions as well, just not open to exporting an
> interface to change IO schedulers from inside the kernel.

What do you think of this?

From: Mike Snitzer <snitzer@redhat.com>
Date: Fri, 8 Sep 2017 11:45:13 -0400
Subject: [PATCH] block: directly insert blk-mq request from blk_insert_cloned_request()

A NULL pointer crash was reported for the case of having the BFQ IO
scheduler attached to the underlying blk-mq paths of a DM multipath
device.  The crash occured in blk_mq_sched_insert_request()'s call to
e->type->ops.mq.insert_requests().

Paolo Valente correctly summarized why the crash occured with:
"the call chain (dm_mq_queue_rq -> map_request -> setup_clone ->
blk_rq_prep_clone) creates a cloned request without invoking
e->type->ops.mq.prepare_request for the target elevator e.  The cloned
request is therefore not initialized for the scheduler, but it is
however inserted into the scheduler by blk_mq_sched_insert_request."

All said, a request-based DM multipath device's IO scheduler should be
the only one used -- when the original requests are issued to the
underlying paths as cloned requests they are inserted directly in the
underlying dispatch queue(s) rather than through an additional
elevator.

But commit bd166ef18 ("blk-mq-sched: add framework for MQ capable IO
schedulers") switched blk_insert_cloned_request() from using
blk_mq_insert_request() to blk_mq_sched_insert_request().  Which
incorrectly added elevator machinery into a call chain that isn't
supposed to have any.

To fix this re-introduce blk_mq_insert_request(), albeit simpler and
blk-mq private, that blk_insert_cloned_request() calls to insert the
request without involving any elevator that may be attached to the
cloned request's request_queue.

Fixes: bd166ef18 ("blk-mq-sched: add framework for MQ capable IO schedulers")
Cc: stable@vger.kernel.org
Reported-by: Bart Van Assche <Bart.VanAssche@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c |  2 +-
 block/blk-mq.c   | 27 ++++++++++++++++++---------
 block/blk-mq.h   |  1 +
 3 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d709c0e..7a06b2b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2342,7 +2342,7 @@ blk_status_t blk_insert_cloned_request(struct request_queue *q, struct request *
 	if (q->mq_ops) {
 		if (blk_queue_io_stat(q))
 			blk_account_io_start(rq, true);
-		blk_mq_sched_insert_request(rq, false, true, false, false);
+		blk_mq_insert_request(rq);
 		return BLK_STS_OK;
 	}
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3f18cff..5c5bb3f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1401,6 +1401,24 @@ void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 	blk_mq_hctx_mark_pending(hctx, ctx);
 }
 
+static inline void blk_mq_queue_io(struct blk_mq_hw_ctx *hctx,
+				   struct blk_mq_ctx *ctx,
+				   struct request *rq)
+{
+	spin_lock(&ctx->lock);
+	__blk_mq_insert_request(hctx, rq, false);
+	spin_unlock(&ctx->lock);
+}
+
+void blk_mq_insert_request(struct request *rq)
+{
+	struct blk_mq_ctx *ctx = rq->mq_ctx;
+	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(rq->q, ctx->cpu);
+
+	blk_mq_queue_io(hctx, ctx, rq);
+	blk_mq_run_hw_queue(hctx, false);
+}
+
 void blk_mq_insert_requests(struct blk_mq_hw_ctx *hctx, struct blk_mq_ctx *ctx,
 			    struct list_head *list)
 
@@ -1494,15 +1512,6 @@ static inline bool hctx_allow_merges(struct blk_mq_hw_ctx *hctx)
 		!blk_queue_nomerges(hctx->queue);
 }
 
-static inline void blk_mq_queue_io(struct blk_mq_hw_ctx *hctx,
-				   struct blk_mq_ctx *ctx,
-				   struct request *rq)
-{
-	spin_lock(&ctx->lock);
-	__blk_mq_insert_request(hctx, rq, false);
-	spin_unlock(&ctx->lock);
-}
-
 static blk_qc_t request_to_qc_t(struct blk_mq_hw_ctx *hctx, struct request *rq)
 {
 	if (rq->tag != -1)
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 98252b7..678ab76 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -54,6 +54,7 @@ int blk_mq_alloc_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
  */
 void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 				bool at_head);
+void blk_mq_insert_request(struct request *rq);
 void blk_mq_insert_requests(struct blk_mq_hw_ctx *hctx, struct blk_mq_ctx *ctx,
 				struct list_head *list);
 
-- 
2.10.1
