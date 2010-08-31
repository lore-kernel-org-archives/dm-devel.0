From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/5] dm: implement REQ_FLUSH/FUA support for request-based
 dm
Date: Tue, 31 Aug 2010 12:29:59 +0200
Message-ID: <4C7CD9A7.4030901@kernel.org>
References: <1283162296-13650-1-git-send-email-tj@kernel.org> <1283162296-13650-5-git-send-email-tj@kernel.org> <20100830132836.GB5283@redhat.com> <4C7BB932.1070405@kernel.org> <4C7BC942.7070703@kernel.org> <20100830190835.GA8458@redhat.com> <20100830212819.GA12522@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100830212819.GA12522@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com, jamie@shareable.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, dm-devel@redhat.com
List-Id: dm-devel.ids

On 08/30/2010 11:28 PM, Mike Snitzer wrote:
> On Mon, Aug 30 2010 at  3:08pm -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
>> On Mon, Aug 30 2010 at 11:07am -0400,
>> Tejun Heo <tj@kernel.org> wrote:
>>
>>> On 08/30/2010 03:59 PM, Tejun Heo wrote:
>>>> Ah... that's probably from "if (!elv_queue_empty(q))" check below,
>>>> flushes are on a separate queue but I forgot to update
>>>> elv_queue_empty() to check the flush queue.  elv_queue_empty() can
>>>> return %true spuriously in which case the queue won't be plugged and
>>>> restarted later leading to queue hang.  I'll fix elv_queue_empty().
>>>
>>> I think I was too quick to blame elv_queue_empty().  Can you please
>>> test whether the following patch fixes the hang?
>>
>> It does, thanks!
> 
> Hmm, but unfortunately I was too quick to say the patch fixed the hang.
> 
> It is much more rare, but I can still get a hang.  I just got the
> following running vgcreate against an DM mpath (rq-based) device:

Can you please try this one instead?

Thanks.

---
 block/blk-flush.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

Index: block/block/blk-flush.c
===================================================================
--- block.orig/block/blk-flush.c
+++ block/block/blk-flush.c
@@ -56,22 +56,38 @@ static struct request *blk_flush_complet
 	return next_rq;
 }

+static void blk_flush_complete_seq_end_io(struct request_queue *q,
+					  unsigned seq, int error)
+{
+	bool was_empty = elv_queue_empty(q);
+	struct request *next_rq;
+
+	next_rq = blk_flush_complete_seq(q, seq, error);
+
+	/*
+	 * Moving a request silently to empty queue_head may stall the
+	 * queue.  Kick the queue in those cases.
+	 */
+	if (next_rq && was_empty)
+		__blk_run_queue(q);
+}
+
 static void pre_flush_end_io(struct request *rq, int error)
 {
 	elv_completed_request(rq->q, rq);
-	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_PREFLUSH, error);
+	blk_flush_complete_seq_end_io(rq->q, QUEUE_FSEQ_PREFLUSH, error);
 }

 static void flush_data_end_io(struct request *rq, int error)
 {
 	elv_completed_request(rq->q, rq);
-	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_DATA, error);
+	blk_flush_complete_seq_end_io(rq->q, QUEUE_FSEQ_DATA, error);
 }

 static void post_flush_end_io(struct request *rq, int error)
 {
 	elv_completed_request(rq->q, rq);
-	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_POSTFLUSH, error);
+	blk_flush_complete_seq_end_io(rq->q, QUEUE_FSEQ_POSTFLUSH, error);
 }

 static void init_flush_request(struct request *rq, struct gendisk *disk)


-- 
tejun
