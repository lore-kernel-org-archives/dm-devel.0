From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/5] dm: implement REQ_FLUSH/FUA support for
 request-based dm
Date: Mon, 30 Aug 2010 17:07:46 +0200
Message-ID: <4C7BC942.7070703__31577.2289097824$1283196910$gmane$org@kernel.org>
References: <1283162296-13650-1-git-send-email-tj@kernel.org>
	<1283162296-13650-5-git-send-email-tj@kernel.org>
	<20100830132836.GB5283@redhat.com> <4C7BB932.1070405@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Resent-Message-ID: <20100830192437.GK9195@redhat.com>
Resent-To: dm-devel@redhat.com
In-Reply-To: <4C7BB932.1070405@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: k-ueda@ct.jp.nec.com, jaxboe@fusionio.com, jamie@shareable.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, j-nomura@ce.jp.nec.com, hch@lst.de
List-Id: dm-devel.ids

On 08/30/2010 03:59 PM, Tejun Heo wrote:
> Ah... that's probably from "if (!elv_queue_empty(q))" check below,
> flushes are on a separate queue but I forgot to update
> elv_queue_empty() to check the flush queue.  elv_queue_empty() can
> return %true spuriously in which case the queue won't be plugged and
> restarted later leading to queue hang.  I'll fix elv_queue_empty().

I think I was too quick to blame elv_queue_empty().  Can you please
test whether the following patch fixes the hang?

Thanks.

---
 block/blk-flush.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

Index: block/block/blk-flush.c
===================================================================
--- block.orig/block/blk-flush.c
+++ block/block/blk-flush.c
@@ -28,7 +28,8 @@ unsigned blk_flush_cur_seq(struct reques
 }

 static struct request *blk_flush_complete_seq(struct request_queue *q,
-					      unsigned seq, int error)
+					      unsigned seq, int error,
+					      bool from_end_io)
 {
 	struct request *next_rq = NULL;

@@ -51,6 +52,13 @@ static struct request *blk_flush_complet
 		if (!list_empty(&q->pending_flushes)) {
 			next_rq = list_entry_rq(q->pending_flushes.next);
 			list_move(&next_rq->queuelist, &q->queue_head);
+			/*
+			 * Moving a request silently to queue_head may
+			 * stall the queue, kick the queue if we
+			 * aren't in the issue path already.
+			 */
+			if (from_end_io)
+				__blk_run_queue(q);
 		}
 	}
 	return next_rq;
@@ -59,19 +67,19 @@ static struct request *blk_flush_complet
 static void pre_flush_end_io(struct request *rq, int error)
 {
 	elv_completed_request(rq->q, rq);
-	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_PREFLUSH, error);
+	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_PREFLUSH, error, true);
 }

 static void flush_data_end_io(struct request *rq, int error)
 {
 	elv_completed_request(rq->q, rq);
-	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_DATA, error);
+	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_DATA, error, true);
 }

 static void post_flush_end_io(struct request *rq, int error)
 {
 	elv_completed_request(rq->q, rq);
-	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_POSTFLUSH, error);
+	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_POSTFLUSH, error, true);
 }

 static void init_flush_request(struct request *rq, struct gendisk *disk)
@@ -165,7 +173,7 @@ struct request *blk_do_flush(struct requ
 		skip |= QUEUE_FSEQ_DATA;
 	if (!do_postflush)
 		skip |= QUEUE_FSEQ_POSTFLUSH;
-	return blk_flush_complete_seq(q, skip, 0);
+	return blk_flush_complete_seq(q, skip, 0, false);
 }

 static void bio_end_flush(struct bio *bio, int err)
