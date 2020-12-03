Return-Path: <SRS0=8v/u=FH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B037C4361A
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 16:33:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9DA35206B9
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 16:33:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9DA35206B9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-CySvPkA_NvOSetliAcw8rA-1; Thu, 03 Dec 2020 11:33:48 -0500
X-MC-Unique: CySvPkA_NvOSetliAcw8rA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E6F2100F340;
	Thu,  3 Dec 2020 16:33:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FBAF60BFA;
	Thu,  3 Dec 2020 16:33:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8DBAF4BB7B;
	Thu,  3 Dec 2020 16:33:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B3GVsmC031484 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 11:31:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D7EA9EAFAF; Thu,  3 Dec 2020 16:31:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D2A74EAFB6
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 16:31:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BAF8C1871CC8
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 16:31:54 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-244-QUiK8Bf_OhShTy1tRRd8eQ-1; Thu, 03 Dec 2020 11:31:51 -0500
X-MC-Unique: QUiK8Bf_OhShTy1tRRd8eQ-1
Received: from 213-225-0-143.nat.highway.a1.net ([213.225.0.143]
	helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kkrMW-0005bX-IM; Thu, 03 Dec 2020 16:21:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu,  3 Dec 2020 17:21:36 +0100
Message-Id: <20201203162139.2110977-3-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: linux-raid@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
	linux-s390@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [dm-devel] [PATCH 2/5] block: simplify and extend the
	block_bio_merge tracepoint class
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The block_bio_merge tracepoint class can be reused for most bio-based
tracepoints.  For that it just needs to lose the superfluous q and rq
parameters.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-core.c             |   2 +-
 block/blk-merge.c            |   4 +-
 block/blk-mq.c               |   2 +-
 block/bounce.c               |   2 +-
 include/trace/events/block.h | 158 ++++++++---------------------------
 kernel/trace/blktrace.c      |  41 +++------
 6 files changed, 48 insertions(+), 161 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index cee568389b7e11..cb24654983e1e4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -907,7 +907,7 @@ static noinline_for_stack bool submit_bio_checks(struct bio *bio)
 	blkcg_bio_issue_init(bio);
 
 	if (!bio_flagged(bio, BIO_TRACE_COMPLETION)) {
-		trace_block_bio_queue(q, bio);
+		trace_block_bio_queue(bio);
 		/* Now that enqueuing has been traced, we need to trace
 		 * completion as well.
 		 */
diff --git a/block/blk-merge.c b/block/blk-merge.c
index cb351ab9b77dbd..1a46d5bbd399e3 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -922,7 +922,7 @@ static enum bio_merge_status bio_attempt_back_merge(struct request *req,
 	if (!ll_back_merge_fn(req, bio, nr_segs))
 		return BIO_MERGE_FAILED;
 
-	trace_block_bio_backmerge(req->q, req, bio);
+	trace_block_bio_backmerge(bio);
 	rq_qos_merge(req->q, req, bio);
 
 	if ((req->cmd_flags & REQ_FAILFAST_MASK) != ff)
@@ -946,7 +946,7 @@ static enum bio_merge_status bio_attempt_front_merge(struct request *req,
 	if (!ll_front_merge_fn(req, bio, nr_segs))
 		return BIO_MERGE_FAILED;
 
-	trace_block_bio_frontmerge(req->q, req, bio);
+	trace_block_bio_frontmerge(bio);
 	rq_qos_merge(req->q, req, bio);
 
 	if ((req->cmd_flags & REQ_FAILFAST_MASK) != ff)
diff --git a/block/blk-mq.c b/block/blk-mq.c
index ce6cd12aeda54e..26eaf476f1e12b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2184,7 +2184,7 @@ blk_qc_t blk_mq_submit_bio(struct bio *bio)
 		goto queue_exit;
 	}
 
-	trace_block_getrq(q, bio, bio->bi_opf);
+	trace_block_getrq(bio);
 
 	rq_qos_track(q, rq, bio);
 
diff --git a/block/bounce.c b/block/bounce.c
index 162a6eee89996a..d3f51acd6e3b51 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -340,7 +340,7 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 		}
 	}
 
-	trace_block_bio_bounce(q, *bio_orig);
+	trace_block_bio_bounce(*bio_orig);
 
 	bio->bi_flags |= (1 << BIO_BOUNCED);
 
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 76459cf750e14d..506c29dc7c76fd 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -226,45 +226,6 @@ DEFINE_EVENT(block_rq, block_rq_merge,
 	TP_ARGS(q, rq)
 );
 
-/**
- * block_bio_bounce - used bounce buffer when processing block operation
- * @q: queue holding the block operation
- * @bio: block operation
- *
- * A bounce buffer was used to handle the block operation @bio in @q.
- * This occurs when hardware limitations prevent a direct transfer of
- * data between the @bio data memory area and the IO device.  Use of a
- * bounce buffer requires extra copying of data and decreases
- * performance.
- */
-TRACE_EVENT(block_bio_bounce,
-
-	TP_PROTO(struct request_queue *q, struct bio *bio),
-
-	TP_ARGS(q, bio),
-
-	TP_STRUCT__entry(
-		__field( dev_t,		dev			)
-		__field( sector_t,	sector			)
-		__field( unsigned int,	nr_sector		)
-		__array( char,		rwbs,	RWBS_LEN	)
-		__array( char,		comm,	TASK_COMM_LEN	)
-	),
-
-	TP_fast_assign(
-		__entry->dev		= bio_dev(bio);
-		__entry->sector		= bio->bi_iter.bi_sector;
-		__entry->nr_sector	= bio_sectors(bio);
-		blk_fill_rwbs(__entry->rwbs, bio->bi_opf, bio->bi_iter.bi_size);
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
-	),
-
-	TP_printk("%d,%d %s %llu + %u [%s]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
-		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->comm)
-);
-
 /**
  * block_bio_complete - completed all work on the block operation
  * @q: queue holding the block operation
@@ -301,11 +262,11 @@ TRACE_EVENT(block_bio_complete,
 		  __entry->nr_sector, __entry->error)
 );
 
-DECLARE_EVENT_CLASS(block_bio_merge,
+DECLARE_EVENT_CLASS(block_bio,
 
-	TP_PROTO(struct request_queue *q, struct request *rq, struct bio *bio),
+	TP_PROTO(struct bio *bio),
 
-	TP_ARGS(q, rq, bio),
+	TP_ARGS(bio),
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev			)
@@ -329,116 +290,63 @@ DECLARE_EVENT_CLASS(block_bio_merge,
 		  __entry->nr_sector, __entry->comm)
 );
 
+/**
+ * block_bio_bounce - used bounce buffer when processing block operation
+ * @bio: block operation
+ *
+ * A bounce buffer was used to handle the block operation @bio in @q.
+ * This occurs when hardware limitations prevent a direct transfer of
+ * data between the @bio data memory area and the IO device.  Use of a
+ * bounce buffer requires extra copying of data and decreases
+ * performance.
+ */
+DEFINE_EVENT(block_bio, block_bio_bounce,
+	TP_PROTO(struct bio *bio),
+	TP_ARGS(bio)
+);
+
 /**
  * block_bio_backmerge - merging block operation to the end of an existing operation
- * @q: queue holding operation
- * @rq: request bio is being merged into
  * @bio: new block operation to merge
  *
- * Merging block request @bio to the end of an existing block request
- * in queue @q.
+ * Merging block request @bio to the end of an existing block request.
  */
-DEFINE_EVENT(block_bio_merge, block_bio_backmerge,
-
-	TP_PROTO(struct request_queue *q, struct request *rq, struct bio *bio),
-
-	TP_ARGS(q, rq, bio)
+DEFINE_EVENT(block_bio, block_bio_backmerge,
+	TP_PROTO(struct bio *bio),
+	TP_ARGS(bio)
 );
 
 /**
  * block_bio_frontmerge - merging block operation to the beginning of an existing operation
- * @q: queue holding operation
- * @rq: request bio is being merged into
  * @bio: new block operation to merge
  *
- * Merging block IO operation @bio to the beginning of an existing block
- * operation in queue @q.
+ * Merging block IO operation @bio to the beginning of an existing block request.
  */
-DEFINE_EVENT(block_bio_merge, block_bio_frontmerge,
-
-	TP_PROTO(struct request_queue *q, struct request *rq, struct bio *bio),
-
-	TP_ARGS(q, rq, bio)
+DEFINE_EVENT(block_bio, block_bio_frontmerge,
+	TP_PROTO(struct bio *bio),
+	TP_ARGS(bio)
 );
 
 /**
  * block_bio_queue - putting new block IO operation in queue
- * @q: queue holding operation
  * @bio: new block operation
  *
  * About to place the block IO operation @bio into queue @q.
  */
-TRACE_EVENT(block_bio_queue,
-
-	TP_PROTO(struct request_queue *q, struct bio *bio),
-
-	TP_ARGS(q, bio),
-
-	TP_STRUCT__entry(
-		__field( dev_t,		dev			)
-		__field( sector_t,	sector			)
-		__field( unsigned int,	nr_sector		)
-		__array( char,		rwbs,	RWBS_LEN	)
-		__array( char,		comm,	TASK_COMM_LEN	)
-	),
-
-	TP_fast_assign(
-		__entry->dev		= bio_dev(bio);
-		__entry->sector		= bio->bi_iter.bi_sector;
-		__entry->nr_sector	= bio_sectors(bio);
-		blk_fill_rwbs(__entry->rwbs, bio->bi_opf, bio->bi_iter.bi_size);
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
-	),
-
-	TP_printk("%d,%d %s %llu + %u [%s]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
-		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->comm)
-);
-
-DECLARE_EVENT_CLASS(block_get_rq,
-
-	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
-
-	TP_ARGS(q, bio, rw),
-
-	TP_STRUCT__entry(
-		__field( dev_t,		dev			)
-		__field( sector_t,	sector			)
-		__field( unsigned int,	nr_sector		)
-		__array( char,		rwbs,	RWBS_LEN	)
-		__array( char,		comm,	TASK_COMM_LEN	)
-        ),
-
-	TP_fast_assign(
-		__entry->dev		= bio ? bio_dev(bio) : 0;
-		__entry->sector		= bio ? bio->bi_iter.bi_sector : 0;
-		__entry->nr_sector	= bio ? bio_sectors(bio) : 0;
-		blk_fill_rwbs(__entry->rwbs,
-			      bio ? bio->bi_opf : 0, __entry->nr_sector);
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
-        ),
-
-	TP_printk("%d,%d %s %llu + %u [%s]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
-		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->comm)
+DEFINE_EVENT(block_bio, block_bio_queue,
+	TP_PROTO(struct bio *bio),
+	TP_ARGS(bio)
 );
 
 /**
  * block_getrq - get a free request entry in queue for block IO operations
- * @q: queue for operations
  * @bio: pending block IO operation (can be %NULL)
- * @rw: low bit indicates a read (%0) or a write (%1)
  *
- * A request struct for queue @q has been allocated to handle the
- * block IO operation @bio.
+ * A request struct has been allocated to handle the block IO operation @bio.
  */
-DEFINE_EVENT(block_get_rq, block_getrq,
-
-	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
-
-	TP_ARGS(q, bio, rw)
+DEFINE_EVENT(block_bio, block_getrq,
+	TP_PROTO(struct bio *bio),
+	TP_ARGS(bio)
 );
 
 /**
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index ced589df304b57..7ab88e00c15765 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -906,10 +906,9 @@ static void blk_add_trace_bio(struct request_queue *q, struct bio *bio,
 	rcu_read_unlock();
 }
 
-static void blk_add_trace_bio_bounce(void *ignore,
-				     struct request_queue *q, struct bio *bio)
+static void blk_add_trace_bio_bounce(void *ignore, struct bio *bio)
 {
-	blk_add_trace_bio(q, bio, BLK_TA_BOUNCE, 0);
+	blk_add_trace_bio(bio->bi_disk->queue, bio, BLK_TA_BOUNCE, 0);
 }
 
 static void blk_add_trace_bio_complete(void *ignore,
@@ -919,44 +918,24 @@ static void blk_add_trace_bio_complete(void *ignore,
 			  blk_status_to_errno(bio->bi_status));
 }
 
-static void blk_add_trace_bio_backmerge(void *ignore,
-					struct request_queue *q,
-					struct request *rq,
-					struct bio *bio)
+static void blk_add_trace_bio_backmerge(void *ignore, struct bio *bio)
 {
-	blk_add_trace_bio(q, bio, BLK_TA_BACKMERGE, 0);
+	blk_add_trace_bio(bio->bi_disk->queue, bio, BLK_TA_BACKMERGE, 0);
 }
 
-static void blk_add_trace_bio_frontmerge(void *ignore,
-					 struct request_queue *q,
-					 struct request *rq,
-					 struct bio *bio)
+static void blk_add_trace_bio_frontmerge(void *ignore, struct bio *bio)
 {
-	blk_add_trace_bio(q, bio, BLK_TA_FRONTMERGE, 0);
+	blk_add_trace_bio(bio->bi_disk->queue, bio, BLK_TA_FRONTMERGE, 0);
 }
 
-static void blk_add_trace_bio_queue(void *ignore,
-				    struct request_queue *q, struct bio *bio)
+static void blk_add_trace_bio_queue(void *ignore, struct bio *bio)
 {
-	blk_add_trace_bio(q, bio, BLK_TA_QUEUE, 0);
+	blk_add_trace_bio(bio->bi_disk->queue, bio, BLK_TA_QUEUE, 0);
 }
 
-static void blk_add_trace_getrq(void *ignore,
-				struct request_queue *q,
-				struct bio *bio, int rw)
+static void blk_add_trace_getrq(void *ignore, struct bio *bio)
 {
-	if (bio)
-		blk_add_trace_bio(q, bio, BLK_TA_GETRQ, 0);
-	else {
-		struct blk_trace *bt;
-
-		rcu_read_lock();
-		bt = rcu_dereference(q->blk_trace);
-		if (bt)
-			__blk_add_trace(bt, 0, 0, rw, 0, BLK_TA_GETRQ, 0, 0,
-					NULL, 0);
-		rcu_read_unlock();
-	}
+	blk_add_trace_bio(bio->bi_disk->queue, bio, BLK_TA_GETRQ, 0);
 }
 
 static void blk_add_trace_plug(void *ignore, struct request_queue *q)
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

