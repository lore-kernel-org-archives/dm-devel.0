Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA891C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 15 Feb 2022 11:11:29 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-192-4xiLsImuPLynEswFn8OKuA-1; Tue, 15 Feb 2022 06:11:27 -0500
X-MC-Unique: 4xiLsImuPLynEswFn8OKuA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB9CF180D1E4;
	Tue, 15 Feb 2022 11:11:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7048C1086484;
	Tue, 15 Feb 2022 11:11:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DB2491809C88;
	Tue, 15 Feb 2022 11:11:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21FB8kFL015261 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Feb 2022 06:08:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9587D2026D60; Tue, 15 Feb 2022 11:08:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F5942026604
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 11:08:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECB35185A79C
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 11:08:36 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-290-Qj9Zu0l9Mr6a-t2aGjDvLA-1; Tue, 15 Feb 2022 06:08:35 -0500
X-MC-Unique: Qj9Zu0l9Mr6a-t2aGjDvLA-1
Received: from [2001:4bb8:184:543c:6bdf:22f4:7f0a:fe97] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nJuiS-002E29-2V; Tue, 15 Feb 2022 10:05:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Date: Tue, 15 Feb 2022 11:05:37 +0100
Message-Id: <20220215100540.3892965-3-hch@lst.de>
In-Reply-To: <20220215100540.3892965-1-hch@lst.de>
References: <20220215100540.3892965-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH 2/5] blk-mq: fold blk_cloned_rq_check_limits into
	blk_insert_cloned_request
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Fold blk_cloned_rq_check_limits into its only caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c | 38 +++++---------------------------------
 1 file changed, 5 insertions(+), 33 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index db62d34afb637..fc132933397fb 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2842,26 +2842,14 @@ void blk_mq_submit_bio(struct bio *bio)
 
 #ifdef CONFIG_BLK_MQ_STACKING
 /**
- * blk_cloned_rq_check_limits - Helper function to check a cloned request
- *                              for the new queue limits
- * @q:  the queue
- * @rq: the request being checked
- *
- * Description:
- *    @rq may have been made based on weaker limitations of upper-level queues
- *    in request stacking drivers, and it may violate the limitation of @q.
- *    Since the block layer and the underlying device driver trust @rq
- *    after it is inserted to @q, it should be checked against @q before
- *    the insertion using this generic function.
- *
- *    Request stacking drivers like request-based dm may change the queue
- *    limits when retrying requests on other queues. Those requests need
- *    to be checked against the new queue limits again during dispatch.
+ * blk_insert_cloned_request - Helper for stacking drivers to submit a request
+ * @q:  the queue to submit the request
+ * @rq: the request being queued
  */
-static blk_status_t blk_cloned_rq_check_limits(struct request_queue *q,
-				      struct request *rq)
+blk_status_t blk_insert_cloned_request(struct request_queue *q, struct request *rq)
 {
 	unsigned int max_sectors = blk_queue_get_max_sectors(q, req_op(rq));
+	blk_status_t ret;
 
 	if (blk_rq_sectors(rq) > max_sectors) {
 		/*
@@ -2893,22 +2881,6 @@ static blk_status_t blk_cloned_rq_check_limits(struct request_queue *q,
 		return BLK_STS_IOERR;
 	}
 
-	return BLK_STS_OK;
-}
-
-/**
- * blk_insert_cloned_request - Helper for stacking drivers to submit a request
- * @q:  the queue to submit the request
- * @rq: the request being queued
- */
-blk_status_t blk_insert_cloned_request(struct request_queue *q, struct request *rq)
-{
-	blk_status_t ret;
-
-	ret = blk_cloned_rq_check_limits(q, rq);
-	if (ret != BLK_STS_OK)
-		return ret;
-
 	if (rq->q->disk &&
 	    should_fail_request(rq->q->disk->part0, blk_rq_bytes(rq)))
 		return BLK_STS_IOERR;
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

