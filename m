Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10FB6C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 15 Feb 2022 11:07:40 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-519-qtx0IdGPM0eIZwilQWq80g-1; Tue, 15 Feb 2022 06:07:38 -0500
X-MC-Unique: qtx0IdGPM0eIZwilQWq80g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E5D52F26;
	Tue, 15 Feb 2022 11:07:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E415A5E4AC;
	Tue, 15 Feb 2022 11:07:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AE4BC1809C88;
	Tue, 15 Feb 2022 11:07:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21FB7WRB015160 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Feb 2022 06:07:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1C1FB14582F5; Tue, 15 Feb 2022 11:07:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1849F14582F1
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 11:07:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F422F1875067
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 11:07:31 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-227-dpIBhTUCOKqaIr0zfsC7Tg-1; Tue, 15 Feb 2022 06:07:30 -0500
X-MC-Unique: dpIBhTUCOKqaIr0zfsC7Tg-1
Received: from [2001:4bb8:184:543c:6bdf:22f4:7f0a:fe97] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nJuiU-002E3T-OO; Tue, 15 Feb 2022 10:05:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Date: Tue, 15 Feb 2022 11:05:38 +0100
Message-Id: <20220215100540.3892965-4-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH 3/5] blk-mq: remove the request_queue argument to
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The request must be submitted to the queue it was allocated for, so
remove the extra request_queue argument.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c         | 9 ++++-----
 drivers/md/dm-rq.c     | 2 +-
 include/linux/blk-mq.h | 3 +--
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index fc132933397fb..886836a54064c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2843,11 +2843,11 @@ void blk_mq_submit_bio(struct bio *bio)
 #ifdef CONFIG_BLK_MQ_STACKING
 /**
  * blk_insert_cloned_request - Helper for stacking drivers to submit a request
- * @q:  the queue to submit the request
  * @rq: the request being queued
  */
-blk_status_t blk_insert_cloned_request(struct request_queue *q, struct request *rq)
+blk_status_t blk_insert_cloned_request(struct request *rq)
 {
+	struct request_queue *q = rq->q;
 	unsigned int max_sectors = blk_queue_get_max_sectors(q, req_op(rq));
 	blk_status_t ret;
 
@@ -2881,8 +2881,7 @@ blk_status_t blk_insert_cloned_request(struct request_queue *q, struct request *
 		return BLK_STS_IOERR;
 	}
 
-	if (rq->q->disk &&
-	    should_fail_request(rq->q->disk->part0, blk_rq_bytes(rq)))
+	if (q->disk && should_fail_request(q->disk->part0, blk_rq_bytes(rq)))
 		return BLK_STS_IOERR;
 
 	if (blk_crypto_insert_cloned_request(rq))
@@ -2895,7 +2894,7 @@ blk_status_t blk_insert_cloned_request(struct request_queue *q, struct request *
 	 * bypass a potential scheduler on the bottom device for
 	 * insert.
 	 */
-	blk_mq_run_dispatch_ops(rq->q,
+	blk_mq_run_dispatch_ops(q,
 			ret = blk_mq_request_issue_directly(rq, true));
 	if (ret)
 		blk_account_io_done(rq, ktime_get_ns());
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 579ab6183d4d8..2fcc9b7f391b3 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -311,7 +311,7 @@ static blk_status_t dm_dispatch_clone_request(struct request *clone, struct requ
 		clone->rq_flags |= RQF_IO_STAT;
 
 	clone->start_time_ns = ktime_get_ns();
-	r = blk_insert_cloned_request(clone->q, clone);
+	r = blk_insert_cloned_request(clone);
 	if (r != BLK_STS_OK && r != BLK_STS_RESOURCE && r != BLK_STS_DEV_RESOURCE)
 		/* must complete clone in terms of original request */
 		dm_complete_request(rq, r);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index d319ffa59354a..3a41d50b85d3a 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -952,8 +952,7 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 		struct bio_set *bs, gfp_t gfp_mask,
 		int (*bio_ctr)(struct bio *, struct bio *, void *), void *data);
 void blk_rq_unprep_clone(struct request *rq);
-blk_status_t blk_insert_cloned_request(struct request_queue *q,
-		struct request *rq);
+blk_status_t blk_insert_cloned_request(struct request *rq);
 
 struct rq_map_data {
 	struct page **pages;
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

