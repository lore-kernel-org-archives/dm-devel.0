From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: v3.8-rc7: Kernel oops in end_clone_bio()
Date: Wed, 20 Feb 2013 16:49:04 +0100
Message-ID: <5124F070.9060001@acm.org>
References: <5123C8CD.9010207@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5123C8CD.9010207@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 02/19/13 19:47, Bart Van Assche wrote:
> general protection fault: 0000 [#1] SMP
> RIP: 0010:[<ffffffff810fe754>]  [<ffffffff810fe754>] mempool_free+0x24/0xb0
> Call Trace:
>   <IRQ>
>   [<ffffffff81187417>] bio_put+0x97/0xc0
>   [<ffffffffa02247a5>] end_clone_bio+0x35/0x90 [dm_mod]
>   [<ffffffff81185efd>] bio_endio+0x1d/0x30
>   [<ffffffff811f03a3>] req_bio_endio.isra.51+0xa3/0xe0
>   [<ffffffff811f2f68>] blk_update_request+0x118/0x520
>   [<ffffffff811f3397>] blk_update_bidi_request+0x27/0xa0
>   [<ffffffff811f343c>] blk_end_bidi_request+0x2c/0x80
>   [<ffffffff811f34d0>] blk_end_request+0x10/0x20
>   [<ffffffffa000b32b>] scsi_io_completion+0xfb/0x6c0 [scsi_mod]
>   [<ffffffffa000107d>] scsi_finish_command+0xbd/0x120 [scsi_mod]
>   [<ffffffffa000b12f>] scsi_softirq_done+0x13f/0x160 [scsi_mod]
>   [<ffffffff811f9fd0>] blk_done_softirq+0x80/0xa0
>   [<ffffffff81044551>] __do_softirq+0xf1/0x250
>   [<ffffffff8142ee8c>] call_softirq+0x1c/0x30
>   [<ffffffff8100420d>] do_softirq+0x8d/0xc0
>   [<ffffffff81044885>] irq_exit+0xd5/0xe0
>   [<ffffffff8142f3e3>] do_IRQ+0x63/0xe0
>   [<ffffffff814257af>] common_interrupt+0x6f/0x6f
>   <EOI>
>   [<ffffffffa021737c>] srp_queuecommand+0x8c/0xcb0 [ib_srp]
>   [<ffffffffa0002f18>] scsi_dispatch_cmd+0x148/0x310 [scsi_mod]
>   [<ffffffffa000a38e>] scsi_request_fn+0x31e/0x520 [scsi_mod]
>   [<ffffffff811f1e57>] __blk_run_queue+0x37/0x50
>   [<ffffffff811f1f69>] blk_delay_work+0x29/0x40
>   [<ffffffff81059003>] process_one_work+0x1c3/0x5c0
>   [<ffffffff8105b22e>] worker_thread+0x15e/0x440
>   [<ffffffff8106164b>] kthread+0xdb/0xe0
>   [<ffffffff8142db9c>] ret_from_fork+0x7c/0xb0

(replying to my own e-mail)

Any opinions about the patch below ? It seems to fix the kernel oops
mentioned above.

[PATCH] Avoid destroying a dm device before request processing finished

diff --git a/block/blk-core.c b/block/blk-core.c
index c973249..77f4ea8 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -304,10 +304,18 @@ EXPORT_SYMBOL(blk_sync_queue);
  *    This variant runs the queue whether or not the queue has been
  *    stopped. Must be called with the queue lock held and interrupts
  *    disabled. See also @blk_run_queue.
+ *
+ * Note:
+ *    Request handling functions that unlock and relock the queue lock
+ *    internally are allowed to invoke blk_run_queue(). This will not result
+ *    in a recursive call of the request handler. However, such request
+ *    handling functions must, before they return, either reexamine the
+ *    request queue or invoke blk_delay_queue() to avoid that queue processing
+ *    stops.
  */
 inline void __blk_run_queue_uncond(struct request_queue *q)
 {
-	if (unlikely(blk_queue_dead(q)))
+	if (unlikely(blk_queue_dead(q) || q->request_fn_active))
 		return;
 
 	/*
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 314a0e2..28b7ad4 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -728,14 +728,8 @@ static void rq_completed(struct mapped_device *md, int rw, int run_queue)
 	if (!md_in_flight(md))
 		wake_up(&md->wait);
 
-	/*
-	 * Run this off this callpath, as drivers could invoke end_io while
-	 * inside their request_fn (and holding the queue lock). Calling
-	 * back into ->request_fn() could deadlock attempting to grab the
-	 * queue lock again.
-	 */
 	if (run_queue)
-		blk_run_queue_async(md->queue);
+		blk_run_queue(md->queue);
 
 	/*
 	 * dm_put() must be at the end of this function. See the comment above
