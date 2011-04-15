From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Date: Fri, 15 Apr 2011 08:34:10 +0200
Message-ID: <4DA7E6E2.5000902@fusionio.com>
References: <20110310005810.GA17911@redhat.com> <20110405130541.6c2b5f86@notabene.brown> <20110411145022.710c30e9@notabene.brown> <4DA2C7BE.6060804@fusionio.com> <20110411205928.13915719@notabene.brown> <4DA2E03A.2080607@fusionio.com> <20110411212635.7959de70@notabene.brown> <4DA2E7F0.9010904@fusionio.com> <20110411220505.1028816e@notabene.brown> <4DA2F00E.6010907@fusionio.com> <20110415042611.GA3116@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110415042611.GA3116@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>
Cc: NeilBrown <neilb@suse.de>, Mike Snitzer <snitzer@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On 2011-04-15 06:26, hch@infradead.org wrote:
> Btw, "block: move queue run on unplug to kblockd" currently moves
> the __blk_run_queue call to kblockd unconditionally currently.  But
> I'm not sure that's correct - if we do an explicit blk_finish_plug
> there's no point in forcing the context switch.

It's correct, but yes it's not optimal for the explicit unplug. Well I
think it really depends - for the single sync case, it's not ideal to
punt to kblockd. But if you have a bunch of threads doing IO, you
probably DO want to punt it to kblockd to avoid too many threads
hammering on the queue lock at the same time. Would need testing to be
sure, the below would a way to accomplish that.


diff --git a/block/blk-core.c b/block/blk-core.c
index b598fa7..995e995 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2662,16 +2662,16 @@ static int plug_rq_cmp(void *priv, struct list_head *a, struct list_head *b)
 	return !(rqa->q <= rqb->q);
 }
 
-static void queue_unplugged(struct request_queue *q, unsigned int depth)
+static void queue_unplugged(struct request_queue *q, unsigned int depth, bool run_from_wq)
 {
 	trace_block_unplug_io(q, depth);
-	__blk_run_queue(q, true);
+	__blk_run_queue(q, run_from_wq);
 
 	if (q->unplugged_fn)
 		q->unplugged_fn(q);
 }
 
-void blk_flush_plug_list(struct blk_plug *plug)
+void blk_flush_plug_list(struct blk_plug *plug, bool run_from_wq)
 {
 	struct request_queue *q;
 	unsigned long flags;
@@ -2706,7 +2706,7 @@ void blk_flush_plug_list(struct blk_plug *plug)
 		BUG_ON(!rq->q);
 		if (rq->q != q) {
 			if (q) {
-				queue_unplugged(q, depth);
+				queue_unplugged(q, depth, run_from_wq);
 				spin_unlock(q->queue_lock);
 			}
 			q = rq->q;
@@ -2727,7 +2727,7 @@ void blk_flush_plug_list(struct blk_plug *plug)
 	}
 
 	if (q) {
-		queue_unplugged(q, depth);
+		queue_unplugged(q, depth, run_from_wq);
 		spin_unlock(q->queue_lock);
 	}
 
@@ -2737,7 +2737,7 @@ EXPORT_SYMBOL(blk_flush_plug_list);
 
 void blk_finish_plug(struct blk_plug *plug)
 {
-	blk_flush_plug_list(plug);
+	blk_flush_plug_list(plug, false);
 
 	if (plug == current->plug)
 		current->plug = NULL;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ffe48ff..1c76506 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -865,14 +865,14 @@ struct blk_plug {
 
 extern void blk_start_plug(struct blk_plug *);
 extern void blk_finish_plug(struct blk_plug *);
-extern void blk_flush_plug_list(struct blk_plug *);
+extern void blk_flush_plug_list(struct blk_plug *, bool);
 
 static inline void blk_flush_plug(struct task_struct *tsk)
 {
 	struct blk_plug *plug = tsk->plug;
 
 	if (plug)
-		blk_flush_plug_list(plug);
+		blk_flush_plug_list(plug, true);
 }
 
 static inline bool blk_needs_flush_plug(struct task_struct *tsk)


-- 
Jens Axboe
