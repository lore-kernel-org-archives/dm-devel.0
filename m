From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: Crash in dm_done()
Date: Wed, 11 Jan 2012 17:36:51 +0900
Message-ID: <4F0D4A23.7060604@ce.jp.nec.com>
References: <4F0C1E68.30602@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4F0C1E68.30602@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Hannes Reinecke <hare@suse.de>
List-Id: dm-devel.ids

Hi Hannes,

On 01/10/12 20:18, Hannes Reinecke wrote:
> I'm trying to hunt down a mysterious crash:
> 
> Unable to handle kernel pointer dereference at virtual kernel
> address 000003c001762000
> Oops: 0011 [#1] SMP
> Modules linked in: dm_round_robin sg sd_mod crc_t10dif ipv6 loop
> dm_multipath scsi_dh dm_mod qeth_l3 ipv6_lib zfcp scsi_transport_fc
> scsi_tgt scsi_mod dasd_eckd_mod dasd_mod qeth qdio ccwgroup ext3
> mbcache jbd
> Supported: Yes
> CPU: 0 Not tainted 3.0.13-0.5-default #1
> Process kworker/0:1 (pid: 51750, task: 0000000008450138, ksp:
> 0000000007323620)
> Krnl PSW : 0704200180000000 000003c001953750 (dm_done+0x44/0x188
> [dm_mod])
>            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:2 PM:0 EA:3
> Krnl GPRS: 000000002adb5e80 000003c001762100 0000000037de9e80
> 0000000000000000
>            0000000000000400 000003c00195e178 0000000000000380
> 0000000000000000
>            0000000000000100 0000000000000001 0000000037de9e80
> 0000000037de9e68
>            000003c00194f000 000003c00195e168 000000007ef97d30
> 000000007ef97cd8
> Krnl Code: 000003c001953740: e3b021580004       lg     %r11,344(%r2)
>            000003c001953746: e310b0080004       lg     %r1,8(%r11)
>            000003c00195374c: bf4fb180           icm %r4,15,384(%r11)
>           >000003c001953750: e32010080004       lg      %r2,8(%r1)
>            000003c001953756: e38020500004       lg      %r8,80(%r2)
>            000003c00195375c: a7740062           brc    7,3c001953820
>            000003c001953760: b9020099           ltgr    %r9,%r9
>            000003c001953764: a7840049           brc    8,3c0019537f6
> 
> r11 is struct dm_rq_target_io *tio = clone->end_io_data;
> r1 is tio->ti (ie struct dm_target), which is invalid.
> r2 is tio->ti->type, likewise.
> 
> Apparently the table got replaced between map_io() and dm_done(),
> causing this invalid pointer.
> While we do hold a reference on the mapped_device in map_request(),
> we only take a _single_ reference to the table in dm_request_fn(),
> which is dropped again at the end.

> And as the table holds the pointer to the targets, they'll be
> invalidated upon table swapping, causing dm_done() accessing an
> invalid pointer.

The last paragraph is not correct.
If any requests are in-flight, dm does not swap table.

I.e., in dm_suspend(), for request-based dm, we do:
  1) stop request_queue processing
     <from this point, no new request becomes in-flight>
  2) wait for completion of in-flight I/Os
     <from this point, no requests are in-flight>
and only after that, we can swap tables.

Existence of in-flight I/O is checked by "pending" counter of md.

The counter is increased in dm_request_fn()
and decreased in rq_completed(), which is called either
when the original request is requeued or completed.
I.e. after dm_done() processing.


> I can't really believe that is the case, so please do correct me if
> the above analysis is wrong.

Just guessing...
Such a mysterious crash could occur if there are bugs like:
  - somebody start the queue while dm stopped it in dm_suspend()
  - somebody submit/complete/requeue request with
    wrong function and corrupt pending counter
  - lower-level driver completes a request twice

If you can recreate the crash, try attached debug patch.
It should raise warnings when cases like above happen
and might help hunting down the problem.

-- 
Jun'ichi Nomura, NEC Corporation


Added debug checks:
  - DM_REQ_CLONE_COMPLETED to check duplicated completion
  - DM_REQ_CLONE_IN_FLIGHT to check inbalance of pending inc/dec
  - DMF_QUEUE_QUIESCENCE to check if queue is suspended
  - check there is no in-flight I/O in table swapping

Use BUG_ON instead of WARN_ON_ONCE if you like.

Index: linux-3.2-rc5/drivers/md/dm.c
===================================================================
--- linux-3.2-rc5.orig/drivers/md/dm.c	2011-12-10 08:09:32.000000000 +0900
+++ linux-3.2-rc5/drivers/md/dm.c	2012-01-11 17:14:58.854508640 +0900
@@ -84,7 +84,10 @@ struct dm_rq_target_io {
 	struct request *orig, clone;
 	int error;
 	union map_info info;
+	unsigned long flags;
 };
+#define DM_REQ_CLONE_COMPLETED (1UL<<0)
+#define DM_REQ_CLONE_IN_FLIGHT (1UL<<1)
 
 /*
  * For request-based dm.
@@ -122,6 +125,7 @@ EXPORT_SYMBOL_GPL(dm_get_rq_mapinfo);
 #define DMF_DELETING 4
 #define DMF_NOFLUSH_SUSPENDING 5
 #define DMF_MERGE_IS_OPTIONAL 6
+#define DMF_QUEUE_QUIESCENCE 7
 
 /*
  * Work processed by per-device workqueue.
@@ -769,6 +773,7 @@ static void free_rq_clone(struct request
 	struct dm_rq_target_io *tio = clone->end_io_data;
 
 	blk_rq_unprep_clone(clone);
+	tio->flags |= DM_REQ_CLONE_COMPLETED;
 	free_rq_tio(tio);
 }
 
@@ -783,6 +788,8 @@ static void dm_end_request(struct reques
 	struct mapped_device *md = tio->md;
 	struct request *rq = tio->orig;
 
+	WARN_ON_ONCE(!(tio->flags & DM_REQ_CLONE_IN_FLIGHT));
+
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
 		rq->errors = clone->errors;
 		rq->resid_len = clone->resid_len;
@@ -823,6 +830,8 @@ void dm_requeue_unmapped_request(struct 
 	struct request_queue *q = rq->q;
 	unsigned long flags;
 
+	WARN_ON_ONCE(!(tio->flags & DM_REQ_CLONE_IN_FLIGHT));
+
 	dm_unprep_request(rq);
 
 	spin_lock_irqsave(q->queue_lock, flags);
@@ -835,7 +844,11 @@ EXPORT_SYMBOL_GPL(dm_requeue_unmapped_re
 
 static void __stop_queue(struct request_queue *q)
 {
+	struct mapped_device *md = q->queuedata;
+
 	blk_stop_queue(q);
+	set_bit(DMF_QUEUE_QUIESCENCE, &md->flags);
+	/* no new request becomes in-flight after here */
 }
 
 static void stop_queue(struct request_queue *q)
@@ -849,6 +862,10 @@ static void stop_queue(struct request_qu
 
 static void __start_queue(struct request_queue *q)
 {
+	struct mapped_device *md = q->queuedata;
+
+	clear_bit(DMF_QUEUE_QUIESCENCE, &md->flags);
+	/* from here, new request can become in-flight */
 	if (blk_queue_stopped(q))
 		blk_start_queue(q);
 }
@@ -868,6 +885,9 @@ static void dm_done(struct request *clon
 	struct dm_rq_target_io *tio = clone->end_io_data;
 	dm_request_endio_fn rq_end_io = tio->ti->type->rq_end_io;
 
+	WARN_ON_ONCE(tio->flags & DM_REQ_CLONE_COMPLETED);
+	tio->flags |= DM_REQ_CLONE_COMPLETED;
+
 	if (mapped && rq_end_io)
 		r = rq_end_io(tio->ti, clone, error, &tio->info);
 
@@ -1521,6 +1541,7 @@ static struct request *clone_rq(struct r
 	tio->orig = rq;
 	tio->error = 0;
 	memset(&tio->info, 0, sizeof(tio->info));
+	tio->flags = 0;
 
 	clone = &tio->clone;
 	if (setup_clone(clone, rq, tio)) {
@@ -1616,6 +1637,7 @@ static void dm_request_fn(struct request
 	struct dm_table *map = dm_get_live_table(md);
 	struct dm_target *ti;
 	struct request *rq, *clone;
+	struct dm_rq_target_io *tio;
 	sector_t pos;
 
 	/*
@@ -1642,6 +1664,10 @@ static void dm_request_fn(struct request
 
 		blk_start_request(rq);
 		clone = rq->special;
+		/* new request becomes in-flight */
+		WARN_ON_ONCE(test_bit(DMF_QUEUE_QUIESCENCE, &md->flags));
+		tio = clone->end_io_data;
+		tio->flags |= DM_REQ_CLONE_IN_FLIGHT;
 		atomic_inc(&md->pending[rq_data_dir(clone)]);
 
 		spin_unlock(q->queue_lock);
@@ -2403,6 +2429,7 @@ struct dm_table *dm_swap_table(struct ma
 		goto out;
 	}
 
+	WARN_ON_ONCE(md_in_flight(md));
 	map = __bind(md, table, &limits);
 
 out:
