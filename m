Return-Path: <SRS0=8v/u=FH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34009C433FE
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 16:34:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 24BCA206B9
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 16:34:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24BCA206B9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-F-F5wLUDNCq27My0Uyr3bQ-1; Thu, 03 Dec 2020 11:34:02 -0500
X-MC-Unique: F-F5wLUDNCq27My0Uyr3bQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 945C8100F340;
	Thu,  3 Dec 2020 16:33:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 787AD6086F;
	Thu,  3 Dec 2020 16:33:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4B8D14E590;
	Thu,  3 Dec 2020 16:33:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B3GW2tr031533 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 11:32:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6E59310E51C4; Thu,  3 Dec 2020 16:32:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 693B810E51C5
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 16:32:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09AB485828A
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 16:32:00 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-337-cPHIo3ILN1u_VH7F2WEtiQ-1; Thu, 03 Dec 2020 11:31:57 -0500
X-MC-Unique: cPHIo3ILN1u_VH7F2WEtiQ-1
Received: from 213-225-0-143.nat.highway.a1.net ([213.225.0.143]
	helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kkrMj-0005dp-F5; Thu, 03 Dec 2020 16:21:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu,  3 Dec 2020 17:21:39 +0100
Message-Id: <20201203162139.2110977-6-hch@lst.de>
In-Reply-To: <20201203162139.2110977-1-hch@lst.de>
References: <20201203162139.2110977-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: linux-raid@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
	linux-s390@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [dm-devel] [PATCH 5/5] block: remove the request_queue to argument
	request based tracepoints
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The request_queue can trivially be derived from the request.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-merge.c            |  2 +-
 block/blk-mq-sched.c         |  2 +-
 block/blk-mq.c               |  8 +++----
 drivers/md/dm-rq.c           |  2 +-
 drivers/s390/scsi/zfcp_fsf.c |  3 +--
 include/linux/blktrace_api.h |  5 ++--
 include/trace/events/block.h | 30 ++++++++++--------------
 kernel/trace/blktrace.c      | 44 ++++++++++++++----------------------
 8 files changed, 39 insertions(+), 57 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 4071daa88a5eaf..7497d86fff3834 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -799,7 +799,7 @@ static struct request *attempt_merge(struct request_queue *q,
 	 */
 	blk_account_io_merge_request(next);
 
-	trace_block_rq_merge(q, next);
+	trace_block_rq_merge(next);
 
 	/*
 	 * ownership of bio passed from next to req, return 'next' for
diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index d1eafe2c045caa..deff4e826e234d 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -386,7 +386,7 @@ EXPORT_SYMBOL_GPL(blk_mq_sched_try_insert_merge);
 
 void blk_mq_sched_request_inserted(struct request *rq)
 {
-	trace_block_rq_insert(rq->q, rq);
+	trace_block_rq_insert(rq);
 }
 EXPORT_SYMBOL_GPL(blk_mq_sched_request_inserted);
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 26eaf476f1e12b..ed21218188da65 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -733,7 +733,7 @@ void blk_mq_start_request(struct request *rq)
 {
 	struct request_queue *q = rq->q;
 
-	trace_block_rq_issue(q, rq);
+	trace_block_rq_issue(rq);
 
 	if (test_bit(QUEUE_FLAG_STATS, &q->queue_flags)) {
 		rq->io_start_time_ns = ktime_get_ns();
@@ -760,7 +760,7 @@ static void __blk_mq_requeue_request(struct request *rq)
 
 	blk_mq_put_driver_tag(rq);
 
-	trace_block_rq_requeue(q, rq);
+	trace_block_rq_requeue(rq);
 	rq_qos_requeue(q, rq);
 
 	if (blk_mq_request_started(rq)) {
@@ -1821,7 +1821,7 @@ static inline void __blk_mq_insert_req_list(struct blk_mq_hw_ctx *hctx,
 
 	lockdep_assert_held(&ctx->lock);
 
-	trace_block_rq_insert(hctx->queue, rq);
+	trace_block_rq_insert(rq);
 
 	if (at_head)
 		list_add(&rq->queuelist, &ctx->rq_lists[type]);
@@ -1878,7 +1878,7 @@ void blk_mq_insert_requests(struct blk_mq_hw_ctx *hctx, struct blk_mq_ctx *ctx,
 	 */
 	list_for_each_entry(rq, list, queuelist) {
 		BUG_ON(rq->mq_ctx != ctx);
-		trace_block_rq_insert(hctx->queue, rq);
+		trace_block_rq_insert(rq);
 	}
 
 	spin_lock(&ctx->lock);
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 729a72ec30ccae..13b4385f4d5a92 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -397,7 +397,7 @@ static int map_request(struct dm_rq_target_io *tio)
 		}
 
 		/* The target has remapped the I/O so dispatch it */
-		trace_block_rq_remap(clone->q, clone, disk_devt(dm_disk(md)),
+		trace_block_rq_remap(clone, disk_devt(dm_disk(md)),
 				     blk_rq_pos(rq));
 		ret = dm_dispatch_clone_request(clone, rq);
 		if (ret == BLK_STS_RESOURCE || ret == BLK_STS_DEV_RESOURCE) {
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 6cb963a0677714..37d450f4695281 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2359,8 +2359,7 @@ static void zfcp_fsf_req_trace(struct zfcp_fsf_req *req, struct scsi_cmnd *scsi)
 		}
 	}
 
-	blk_add_driver_data(scsi->request->q, scsi->request, &blktrc,
-			    sizeof(blktrc));
+	blk_add_driver_data(scsi->request, &blktrc, sizeof(blktrc));
 }
 
 /**
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index 3b6ff5902edce6..05556573b896a2 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -75,8 +75,7 @@ static inline bool blk_trace_note_message_enabled(struct request_queue *q)
 	return ret;
 }
 
-extern void blk_add_driver_data(struct request_queue *q, struct request *rq,
-				void *data, size_t len);
+extern void blk_add_driver_data(struct request *rq, void *data, size_t len);
 extern int blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 			   struct block_device *bdev,
 			   char __user *arg);
@@ -90,7 +89,7 @@ extern struct attribute_group blk_trace_attr_group;
 #else /* !CONFIG_BLK_DEV_IO_TRACE */
 # define blk_trace_ioctl(bdev, cmd, arg)		(-ENOTTY)
 # define blk_trace_shutdown(q)				do { } while (0)
-# define blk_add_driver_data(q, rq, data, len)		do {} while (0)
+# define blk_add_driver_data(rq, data, len)		do {} while (0)
 # define blk_trace_setup(q, name, dev, bdev, arg)	(-ENOTTY)
 # define blk_trace_startstop(q, start)			(-ENOTTY)
 # define blk_trace_remove(q)				(-ENOTTY)
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 8fb89574d8677f..0d782663a005dc 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -64,7 +64,6 @@ DEFINE_EVENT(block_buffer, block_dirty_buffer,
 
 /**
  * block_rq_requeue - place block IO request back on a queue
- * @q: queue holding operation
  * @rq: block IO operation request
  *
  * The block operation request @rq is being placed back into queue
@@ -73,9 +72,9 @@ DEFINE_EVENT(block_buffer, block_dirty_buffer,
  */
 TRACE_EVENT(block_rq_requeue,
 
-	TP_PROTO(struct request_queue *q, struct request *rq),
+	TP_PROTO(struct request *rq),
 
-	TP_ARGS(q, rq),
+	TP_ARGS(rq),
 
 	TP_STRUCT__entry(
 		__field(  dev_t,	dev			)
@@ -147,9 +146,9 @@ TRACE_EVENT(block_rq_complete,
 
 DECLARE_EVENT_CLASS(block_rq,
 
-	TP_PROTO(struct request_queue *q, struct request *rq),
+	TP_PROTO(struct request *rq),
 
-	TP_ARGS(q, rq),
+	TP_ARGS(rq),
 
 	TP_STRUCT__entry(
 		__field(  dev_t,	dev			)
@@ -181,7 +180,6 @@ DECLARE_EVENT_CLASS(block_rq,
 
 /**
  * block_rq_insert - insert block operation request into queue
- * @q: target queue
  * @rq: block IO operation request
  *
  * Called immediately before block operation request @rq is inserted
@@ -191,14 +189,13 @@ DECLARE_EVENT_CLASS(block_rq,
  */
 DEFINE_EVENT(block_rq, block_rq_insert,
 
-	TP_PROTO(struct request_queue *q, struct request *rq),
+	TP_PROTO(struct request *rq),
 
-	TP_ARGS(q, rq)
+	TP_ARGS(rq)
 );
 
 /**
  * block_rq_issue - issue pending block IO request operation to device driver
- * @q: queue holding operation
  * @rq: block IO operation operation request
  *
  * Called when block operation request @rq from queue @q is sent to a
@@ -206,14 +203,13 @@ DEFINE_EVENT(block_rq, block_rq_insert,
  */
 DEFINE_EVENT(block_rq, block_rq_issue,
 
-	TP_PROTO(struct request_queue *q, struct request *rq),
+	TP_PROTO(struct request *rq),
 
-	TP_ARGS(q, rq)
+	TP_ARGS(rq)
 );
 
 /**
  * block_rq_merge - merge request with another one in the elevator
- * @q: queue holding operation
  * @rq: block IO operation operation request
  *
  * Called when block operation request @rq from queue @q is merged to another
@@ -221,9 +217,9 @@ DEFINE_EVENT(block_rq, block_rq_issue,
  */
 DEFINE_EVENT(block_rq, block_rq_merge,
 
-	TP_PROTO(struct request_queue *q, struct request *rq),
+	TP_PROTO(struct request *rq),
 
-	TP_ARGS(q, rq)
+	TP_ARGS(rq)
 );
 
 /**
@@ -491,7 +487,6 @@ TRACE_EVENT(block_bio_remap,
 
 /**
  * block_rq_remap - map request for a block operation request
- * @q: queue holding the operation
  * @rq: block IO operation request
  * @dev: device for the operation
  * @from: original sector for the operation
@@ -502,10 +497,9 @@ TRACE_EVENT(block_bio_remap,
  */
 TRACE_EVENT(block_rq_remap,
 
-	TP_PROTO(struct request_queue *q, struct request *rq, dev_t dev,
-		 sector_t from),
+	TP_PROTO(struct request *rq, dev_t dev, sector_t from),
 
-	TP_ARGS(q, rq, dev, from),
+	TP_ARGS(rq, dev, from),
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev		)
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 405637144a0389..7839a78205c243 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -795,12 +795,12 @@ static u64 blk_trace_bio_get_cgid(struct request_queue *q, struct bio *bio)
 #endif
 
 static u64
-blk_trace_request_get_cgid(struct request_queue *q, struct request *rq)
+blk_trace_request_get_cgid(struct request *rq)
 {
 	if (!rq->bio)
 		return 0;
 	/* Use the first bio */
-	return blk_trace_bio_get_cgid(q, rq->bio);
+	return blk_trace_bio_get_cgid(rq->q, rq->bio);
 }
 
 /*
@@ -841,40 +841,35 @@ static void blk_add_trace_rq(struct request *rq, int error,
 	rcu_read_unlock();
 }
 
-static void blk_add_trace_rq_insert(void *ignore,
-				    struct request_queue *q, struct request *rq)
+static void blk_add_trace_rq_insert(void *ignore, struct request *rq)
 {
 	blk_add_trace_rq(rq, 0, blk_rq_bytes(rq), BLK_TA_INSERT,
-			 blk_trace_request_get_cgid(q, rq));
+			 blk_trace_request_get_cgid(rq));
 }
 
-static void blk_add_trace_rq_issue(void *ignore,
-				   struct request_queue *q, struct request *rq)
+static void blk_add_trace_rq_issue(void *ignore, struct request *rq)
 {
 	blk_add_trace_rq(rq, 0, blk_rq_bytes(rq), BLK_TA_ISSUE,
-			 blk_trace_request_get_cgid(q, rq));
+			 blk_trace_request_get_cgid(rq));
 }
 
-static void blk_add_trace_rq_merge(void *ignore,
-				   struct request_queue *q, struct request *rq)
+static void blk_add_trace_rq_merge(void *ignore, struct request *rq)
 {
 	blk_add_trace_rq(rq, 0, blk_rq_bytes(rq), BLK_TA_BACKMERGE,
-			 blk_trace_request_get_cgid(q, rq));
+			 blk_trace_request_get_cgid(rq));
 }
 
-static void blk_add_trace_rq_requeue(void *ignore,
-				     struct request_queue *q,
-				     struct request *rq)
+static void blk_add_trace_rq_requeue(void *ignore, struct request *rq)
 {
 	blk_add_trace_rq(rq, 0, blk_rq_bytes(rq), BLK_TA_REQUEUE,
-			 blk_trace_request_get_cgid(q, rq));
+			 blk_trace_request_get_cgid(rq));
 }
 
 static void blk_add_trace_rq_complete(void *ignore, struct request *rq,
 			int error, unsigned int nr_bytes)
 {
 	blk_add_trace_rq(rq, error, nr_bytes, BLK_TA_COMPLETE,
-			 blk_trace_request_get_cgid(rq->q, rq));
+			 blk_trace_request_get_cgid(rq));
 }
 
 /**
@@ -1037,16 +1032,14 @@ static void blk_add_trace_bio_remap(void *ignore, struct bio *bio, dev_t dev,
  *     Add a trace for that action.
  *
  **/
-static void blk_add_trace_rq_remap(void *ignore,
-				   struct request_queue *q,
-				   struct request *rq, dev_t dev,
+static void blk_add_trace_rq_remap(void *ignore, struct request *rq, dev_t dev,
 				   sector_t from)
 {
 	struct blk_trace *bt;
 	struct blk_io_trace_remap r;
 
 	rcu_read_lock();
-	bt = rcu_dereference(q->blk_trace);
+	bt = rcu_dereference(rq->q->blk_trace);
 	if (likely(!bt)) {
 		rcu_read_unlock();
 		return;
@@ -1058,13 +1051,12 @@ static void blk_add_trace_rq_remap(void *ignore,
 
 	__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_bytes(rq),
 			rq_data_dir(rq), 0, BLK_TA_REMAP, 0,
-			sizeof(r), &r, blk_trace_request_get_cgid(q, rq));
+			sizeof(r), &r, blk_trace_request_get_cgid(rq));
 	rcu_read_unlock();
 }
 
 /**
  * blk_add_driver_data - Add binary message with driver-specific data
- * @q:		queue the io is for
  * @rq:		io request
  * @data:	driver-specific data
  * @len:	length of driver-specific data
@@ -1073,14 +1065,12 @@ static void blk_add_trace_rq_remap(void *ignore,
  *     Some drivers might want to write driver-specific data per request.
  *
  **/
-void blk_add_driver_data(struct request_queue *q,
-			 struct request *rq,
-			 void *data, size_t len)
+void blk_add_driver_data(struct request *rq, void *data, size_t len)
 {
 	struct blk_trace *bt;
 
 	rcu_read_lock();
-	bt = rcu_dereference(q->blk_trace);
+	bt = rcu_dereference(rq->q->blk_trace);
 	if (likely(!bt)) {
 		rcu_read_unlock();
 		return;
@@ -1088,7 +1078,7 @@ void blk_add_driver_data(struct request_queue *q,
 
 	__blk_add_trace(bt, blk_rq_trace_sector(rq), blk_rq_bytes(rq), 0, 0,
 				BLK_TA_DRV_DATA, 0, len, data,
-				blk_trace_request_get_cgid(q, rq));
+				blk_trace_request_get_cgid(rq));
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(blk_add_driver_data);
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

