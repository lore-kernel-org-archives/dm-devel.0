Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E88AEC64E7B
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 18:03:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CB89C206F9
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 18:03:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB89C206F9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-5T-FM3zlOC62Hs4Gyr-jGQ-1; Mon, 30 Nov 2020 13:03:33 -0500
X-MC-Unique: 5T-FM3zlOC62Hs4Gyr-jGQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 822EB8030AB;
	Mon, 30 Nov 2020 18:03:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 291FE10023AD;
	Mon, 30 Nov 2020 18:03:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B8DC35002C;
	Mon, 30 Nov 2020 18:03:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AUI3P9b008655 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Nov 2020 13:03:25 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 534DF2166B2E; Mon, 30 Nov 2020 18:03:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4EBC02166B2C
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 18:03:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 267E6803CE8
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 18:03:23 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-224-xaehNODMNOClLHGBq6Szyw-1; Mon, 30 Nov 2020 13:03:19 -0500
X-MC-Unique: xaehNODMNOClLHGBq6Szyw-1
Received: from 089144198196.atnat0007.highway.a1.net ([89.144.198.196]
	helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kjnW9-0006b8-IE; Mon, 30 Nov 2020 18:03:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Mon, 30 Nov 2020 18:58:50 +0100
Message-Id: <20201130175854.982460-2-hch@lst.de>
In-Reply-To: <20201130175854.982460-1-hch@lst.de>
References: <20201130175854.982460-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
	dm-devel@redhat.com, linux-s390@vger.kernel.org
Subject: [dm-devel] [PATCH 1/5] block: remove the unused block_sleeprq
	tracepoint
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/trace/events/block.h | 18 ------------------
 kernel/trace/blktrace.c      | 22 ----------------------
 2 files changed, 40 deletions(-)

diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 34d64ca306b1c7..76459cf750e14d 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -441,24 +441,6 @@ DEFINE_EVENT(block_get_rq, block_getrq,
 	TP_ARGS(q, bio, rw)
 );
 
-/**
- * block_sleeprq - waiting to get a free request entry in queue for block IO operation
- * @q: queue for operation
- * @bio: pending block IO operation (can be %NULL)
- * @rw: low bit indicates a read (%0) or a write (%1)
- *
- * In the case where a request struct cannot be provided for queue @q
- * the process needs to wait for an request struct to become
- * available.  This tracepoint event is generated each time the
- * process goes to sleep waiting for request struct become available.
- */
-DEFINE_EVENT(block_get_rq, block_sleeprq,
-
-	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
-
-	TP_ARGS(q, bio, rw)
-);
-
 /**
  * block_plug - keep operations requests in request queue
  * @q: request queue to plug
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index a482a37848bff7..ced589df304b57 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -959,25 +959,6 @@ static void blk_add_trace_getrq(void *ignore,
 	}
 }
 
-
-static void blk_add_trace_sleeprq(void *ignore,
-				  struct request_queue *q,
-				  struct bio *bio, int rw)
-{
-	if (bio)
-		blk_add_trace_bio(q, bio, BLK_TA_SLEEPRQ, 0);
-	else {
-		struct blk_trace *bt;
-
-		rcu_read_lock();
-		bt = rcu_dereference(q->blk_trace);
-		if (bt)
-			__blk_add_trace(bt, 0, 0, rw, 0, BLK_TA_SLEEPRQ,
-					0, 0, NULL, 0);
-		rcu_read_unlock();
-	}
-}
-
 static void blk_add_trace_plug(void *ignore, struct request_queue *q)
 {
 	struct blk_trace *bt;
@@ -1164,8 +1145,6 @@ static void blk_register_tracepoints(void)
 	WARN_ON(ret);
 	ret = register_trace_block_getrq(blk_add_trace_getrq, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_sleeprq(blk_add_trace_sleeprq, NULL);
-	WARN_ON(ret);
 	ret = register_trace_block_plug(blk_add_trace_plug, NULL);
 	WARN_ON(ret);
 	ret = register_trace_block_unplug(blk_add_trace_unplug, NULL);
@@ -1185,7 +1164,6 @@ static void blk_unregister_tracepoints(void)
 	unregister_trace_block_split(blk_add_trace_split, NULL);
 	unregister_trace_block_unplug(blk_add_trace_unplug, NULL);
 	unregister_trace_block_plug(blk_add_trace_plug, NULL);
-	unregister_trace_block_sleeprq(blk_add_trace_sleeprq, NULL);
 	unregister_trace_block_getrq(blk_add_trace_getrq, NULL);
 	unregister_trace_block_bio_queue(blk_add_trace_bio_queue, NULL);
 	unregister_trace_block_bio_frontmerge(blk_add_trace_bio_frontmerge, NULL);
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

