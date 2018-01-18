From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes idle
Date: Thu, 18 Jan 2018 15:48:57 -0500
Message-ID: <20180118204856.GA31679@redhat.com>
References: <20180118024124.8079-1-ming.lei@redhat.com>
 <b2e5b7e6-ce4b-6053-adae-63cc44d773af@wdc.com>
 <20180118170353.GB19734@redhat.com>
 <1516296056.2676.23.camel@wdc.com>
 <20180118183039.GA20121@redhat.com>
 <1516301278.2676.35.camel@wdc.com>
 <deeb2b2e-6d0e-a144-843d-d08626de8aea@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <deeb2b2e-6d0e-a144-843d-d08626de8aea@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
List-Id: dm-devel.ids

On Thu, Jan 18 2018 at  3:11pm -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 1/18/18 11:47 AM, Bart Van Assche wrote:
> >> This is all very tiresome.
> > 
> > Yes, this is tiresome. It is very annoying to me that others keep
> > introducing so many regressions in such important parts of the kernel.
> > It is also annoying to me that I get blamed if I report a regression
> > instead of seeing that the regression gets fixed.
> 
> I agree, it sucks that any change there introduces the regression. I'm
> fine with doing the delay insert again until a new patch is proven to be
> better.
> 
> From the original topic of this email, we have conditions that can cause
> the driver to not be able to submit an IO. A set of those conditions can
> only happen if IO is in flight, and those cases we have covered just
> fine. Another set can potentially trigger without IO being in flight.
> These are cases where a non-device resource is unavailable at the time
> of submission. This might be iommu running out of space, for instance,
> or it might be a memory allocation of some sort. For these cases, we
> don't get any notification when the shortage clears. All we can do is
> ensure that we restart operations at some point in the future. We're SOL
> at that point, but we have to ensure that we make forward progress.
> 
> That last set of conditions better not be a a common occurence, since
> performance is down the toilet at that point. I don't want to introduce
> hot path code to rectify it. Have the driver return if that happens in a
> way that is DIFFERENT from needing a normal restart. The driver knows if
> this is a resource that will become available when IO completes on this
> device or not. If we get that return, we have a generic run-again delay.
> 
> This basically becomes the same as doing the delay queue thing from DM,
> but just in a generic fashion.

This is a bit confusing for me (as I see it we have 2 blk-mq drivers
trying to collaborate, so your refering to "driver" lacks precision; but
I could just be missing something)...

For Bart's test the underlying scsi-mq driver is what is regularly
hitting this case in __blk_mq_try_issue_directly():

        if (blk_mq_hctx_stopped(hctx) || blk_queue_quiesced(q))

It certainly better not be the norm (Bart's test hammering on this aside).

For starters, it'd be very useful to know if Bart is hitting the
blk_mq_hctx_stopped() or blk_queue_quiesced() for this case that is
triggering the use of blk_mq_sched_insert_request() -- I'd wager it is
due to blk_queue_quiesced() but Bart _please_ try to figure it out.

Anyway, in response to this case Bart would like the upper layer dm-mq
driver to blk_mq_delay_run_hw_queue().  Certainly is quite the hammer.

But that hammer aside, in general for this case, I'm concerned about: is
it really correct to allow an already stopped/quiesced underlying queue
to retain responsibility for processing the request?  Or would the
upper-layer dm-mq benefit from being able to retry the request on its
terms (via a "DIFFERENT" return from blk-mq core)?

Like this?  The (ab)use of BLK_STS_DM_REQUEUE certainly seems fitting in
this case but...

(Bart please note that this patch applies on linux-dm.git's 'for-next';
which is just a merge of Jens' 4.16 tree and dm-4.16)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 74a4f237ba91..371a1b97bf56 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1781,16 +1781,11 @@ static blk_status_t __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 	struct request_queue *q = rq->q;
 	bool run_queue = true;
 
-	/*
-	 * RCU or SRCU read lock is needed before checking quiesced flag.
-	 *
-	 * When queue is stopped or quiesced, ignore 'bypass_insert' from
-	 * blk_mq_request_direct_issue(), and return BLK_STS_OK to caller,
-	 * and avoid driver to try to dispatch again.
-	 */
+	/* RCU or SRCU read lock is needed before checking quiesced flag */
 	if (blk_mq_hctx_stopped(hctx) || blk_queue_quiesced(q)) {
 		run_queue = false;
-		bypass_insert = false;
+		if (bypass_insert)
+			return BLK_STS_DM_REQUEUE;
 		goto insert;
 	}
 
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index d8519ddd7e1a..2f554ea485c3 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -408,7 +408,7 @@ static blk_status_t dm_dispatch_clone_request(struct request *clone, struct requ
 
 	clone->start_time = jiffies;
 	r = blk_insert_cloned_request(clone->q, clone);
-	if (r != BLK_STS_OK && r != BLK_STS_RESOURCE)
+	if (r != BLK_STS_OK && r != BLK_STS_RESOURCE && r != BLK_STS_DM_REQUEUE)
 		/* must complete clone in terms of original request */
 		dm_complete_request(rq, r);
 	return r;
@@ -472,6 +472,7 @@ static void init_tio(struct dm_rq_target_io *tio, struct request *rq,
  * Returns:
  * DM_MAPIO_*       : the request has been processed as indicated
  * DM_MAPIO_REQUEUE : the original request needs to be immediately requeued
+ * DM_MAPIO_DELAY_REQUEUE : the original request needs to be requeued after delay
  * < 0              : the request was completed due to failure
  */
 static int map_request(struct dm_rq_target_io *tio)
@@ -500,11 +501,11 @@ static int map_request(struct dm_rq_target_io *tio)
 		trace_block_rq_remap(clone->q, clone, disk_devt(dm_disk(md)),
 				     blk_rq_pos(rq));
 		ret = dm_dispatch_clone_request(clone, rq);
-		if (ret == BLK_STS_RESOURCE) {
+		if (ret == BLK_STS_RESOURCE || ret == BLK_STS_DM_REQUEUE) {
 			blk_rq_unprep_clone(clone);
 			tio->ti->type->release_clone_rq(clone);
 			tio->clone = NULL;
-			if (!rq->q->mq_ops)
+			if (ret == BLK_STS_DM_REQUEUE || !rq->q->mq_ops)
 				r = DM_MAPIO_DELAY_REQUEUE;
 			else
 				r = DM_MAPIO_REQUEUE;
@@ -741,6 +742,7 @@ static int dm_mq_init_request(struct blk_mq_tag_set *set, struct request *rq,
 static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 			  const struct blk_mq_queue_data *bd)
 {
+	int r;
 	struct request *rq = bd->rq;
 	struct dm_rq_target_io *tio = blk_mq_rq_to_pdu(rq);
 	struct mapped_device *md = tio->md;
@@ -768,10 +770,13 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 	tio->ti = ti;
 
 	/* Direct call is fine since .queue_rq allows allocations */
-	if (map_request(tio) == DM_MAPIO_REQUEUE) {
+	r = map_request(tio);
+	if (r == DM_MAPIO_REQUEUE || r == DM_MAPIO_DELAY_REQUEUE) {
 		/* Undo dm_start_request() before requeuing */
 		rq_end_stats(md, rq);
 		rq_completed(md, rq_data_dir(rq), false);
+		if (r == DM_MAPIO_DELAY_REQUEUE)
+			blk_mq_delay_run_hw_queue(hctx, 100/*ms*/);
 		return BLK_STS_RESOURCE;
 	}
 
