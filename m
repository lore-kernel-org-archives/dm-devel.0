From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: 4.1-rc2 dm-multipath-mq kernel warning
Date: Wed, 27 May 2015 13:00:01 -0400
Message-ID: <20150527170001.GA22548@redhat.com>
References: <5548CDE5.9@sandisk.com> <20150506022332.GA12096@redhat.com>
	<5549C68E.2050705@sandisk.com> <20150506182942.GA15545@redhat.com>
	<554B3C22.4060305@sandisk.com> <20150527125732.GA15911@redhat.com>
	<5565E2EA.2000302@sandisk.com> <5565E3E3.4080801@sandisk.com>
	<20150527161415.GA22520@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150527161415.GA22520@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, May 27 2015 at 12:14P -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Wed, May 27 2015 at 11:33am -0400,
> Bart Van Assche <bart.vanassche@sandisk.com> wrote:
> 
> > On 05/27/15 17:29, Bart Van Assche wrote:
> > >On 05/27/15 14:57, Mike Snitzer wrote:
> > >>Looks like Junichi likely fixed this issue you reported, please try this
> > >>patch: https://patchwork.kernel.org/patch/6487321/
> > >
> > >Hello Mike,
> > >
> > >On a setup on which an I/O verification test passes with
> > >blk-mq/scsi-mq/dm-mq disabled, this is what fio reports after a few
> > >minutes with scsi-mq and dm-mq enabled:
> > >
> > >test: Laying out IO file(s) (1 file(s) / 10MB)
> > >fio: io_u error on file /mnt/test.0.0: Input/output error: write
> > >offset=8327168, buflen=4096
> > >fio: io_u error on file /mnt/test.0.0: Input/output error: write
> > >offset=9007104, buflen=4096
> > >fio: pid=4568, err=5/file:io_u.c:1564, func=io_u error,
> > >error=Input/output error
> 
> I'll look closer at this.. so NULL pointer is fixed but this test hits
> IO errors.

Further code inspection revealed an issue with dm-mq enabled but scsi-mq
disabled (when requeuing the original request after clone_rq() failure DM
core wasn't unwinding the dm_start_request() accounting).  The following
patch will fix this issue.  I've also switched the dm-mq on scsi-mq case
to return BLK_MQ_RQ_QUEUE_BUSY directly (like hch suggested last week).
I have no idea if this would actually fix your case (would be surprising
but worth a shot I suppose).

Anyway, feel free to try this patch:

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 85966ee..02e2d1f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1115,23 +1115,37 @@ static void old_requeue_request(struct request *rq)
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
-static void dm_requeue_original_request(struct mapped_device *md,
-					struct request *rq)
+static void __dm_requeue_original_request(struct mapped_device *md,
+					  struct request *rq, bool in_blk_mq_queue_rq)
 {
 	int rw = rq_data_dir(rq);
 
 	dm_unprep_request(rq);
 
-	if (!rq->q->mq_ops)
-		old_requeue_request(rq);
-	else {
-		blk_mq_requeue_request(rq);
-		blk_mq_kick_requeue_list(rq->q);
+	if (!in_blk_mq_queue_rq) {
+		if (!rq->q->mq_ops)
+			old_requeue_request(rq);
+		else {
+			blk_mq_requeue_request(rq);
+			blk_mq_kick_requeue_list(rq->q);
+		}
 	}
 
 	rq_completed(md, rw, false);
 }
 
+static void dm_requeue_original_request(struct mapped_device *md,
+					struct request *rq)
+{
+	return __dm_requeue_original_request(md, rq, false);
+}
+
+static void dm_unprep_before_requeuing_original_request(struct mapped_device *md,
+							struct request *rq)
+{
+	return __dm_requeue_original_request(md, rq, true);
+}
+
 static void old_stop_queue(struct request_queue *q)
 {
 	unsigned long flags;
@@ -2679,15 +2693,18 @@ static int dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 		/* clone request is allocated at the end of the pdu */
 		tio->clone = (void *)blk_mq_rq_to_pdu(rq) + sizeof(struct dm_rq_target_io);
 		if (!clone_rq(rq, md, tio, GFP_ATOMIC))
-			return BLK_MQ_RQ_QUEUE_BUSY;
+			goto out_requeue;
 		queue_kthread_work(&md->kworker, &tio->work);
 	} else {
 		/* Direct call is fine since .queue_rq allows allocations */
 		if (map_request(tio, rq, md) == DM_MAPIO_REQUEUE)
-			dm_requeue_original_request(md, rq);
+			goto out_requeue;
 	}
 
 	return BLK_MQ_RQ_QUEUE_OK;
+out_requeue:
+	dm_unprep_before_requeuing_original_request(md, rq);
+	return BLK_MQ_RQ_QUEUE_BUSY;
 }
 
 static struct blk_mq_ops dm_mq_ops = {
