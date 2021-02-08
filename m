Return-Path: <SRS0=CL6l=HT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31459C433E6
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:35:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C1F3E64D9F
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:35:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C1F3E64D9F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-BYYDVNcrN2Cu-PxCCTzBDA-1; Wed, 17 Feb 2021 10:35:47 -0500
X-MC-Unique: BYYDVNcrN2Cu-PxCCTzBDA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22CA6192D785;
	Wed, 17 Feb 2021 15:35:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 00E9760657;
	Wed, 17 Feb 2021 15:35:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BF23358073;
	Wed, 17 Feb 2021 15:35:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1188r3Um030080 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 8 Feb 2021 03:53:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 27A911111C94; Mon,  8 Feb 2021 08:53:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 238371111C92
	for <dm-devel@redhat.com>; Mon,  8 Feb 2021 08:53:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 121C8858F17
	for <dm-devel@redhat.com>; Mon,  8 Feb 2021 08:53:03 +0000 (UTC)
Received: from out30-44.freemail.mail.aliyun.com
	(out30-44.freemail.mail.aliyun.com [115.124.30.44]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-134-Keg4h-sXPYu6gEGjliZJeA-1;
	Mon, 08 Feb 2021 03:53:00 -0500
X-MC-Unique: Keg4h-sXPYu6gEGjliZJeA-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R271e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04357;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
	TI=SMTPD_---0UOAeIP5_1612774375
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UOAeIP5_1612774375) by smtp.aliyun-inc.com(127.0.0.1);
	Mon, 08 Feb 2021 16:52:56 +0800
From: Jeffle Xu <jefflexu@linux.alibaba.com>
To: snitzer@redhat.com, axboe@kernel.dk
Date: Mon,  8 Feb 2021 16:52:43 +0800
Message-Id: <20210208085243.82367-12-jefflexu@linux.alibaba.com>
In-Reply-To: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
References: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
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
X-Mailman-Approved-At: Wed, 17 Feb 2021 10:31:26 -0500
Cc: caspar@linux.alibaba.com, hch@lst.de, linux-block@vger.kernel.org,
	joseph.qi@linux.alibaba.com, dm-devel@redhat.com, io-uring@vger.kernel.org
Subject: [dm-devel] [PATCH v3 11/11] dm: fastpath of bio-based polling
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Offer one fastpath of bio-based polling when bio submitted to dm device
is not split.

In this case, there will be only one bio submitted to only one polling
hw queue of one underlying mq device, and thus we don't need to track
all split bios or iterate through all polling hw queues. The pointer to
the polling hw queue the bio submitted to is returned here as the
returned cookie. In this case, the polling routine will call
mq_ops->poll() directly with the hw queue converted from the input
cookie.

If the original bio submitted to dm device is split to multiple bios and
thus submitted to multiple polling hw queues, the bio submission routine
will return BLK_QC_T_BIO_MULTI, while the polling routine will fall
back to iterating all hw queues (in polling mode) of all underlying mq
devices.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 block/blk-core.c          | 33 +++++++++++++++++++++++++++++++--
 include/linux/blk_types.h |  8 ++++++++
 include/linux/types.h     |  2 +-
 3 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 37aa513da5f2..cb24b33a4870 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -956,11 +956,19 @@ static blk_qc_t __submit_bio(struct bio *bio)
  * bio_list_on_stack[0] contains bios submitted by the current ->submit_bio.
  * bio_list_on_stack[1] contains bios that were submitted before the current
  *	->submit_bio_bio, but that haven't been processed yet.
+ *
+ * Return:
+ *   - BLK_QC_T_NONE, no need for IO polling.
+ *   - BLK_QC_T_BIO_MULTI, @bio gets split and enqueued into multi hw queues.
+ *   - Otherwise, @bio is not split, returning the pointer to the corresponding
+ *     hw queue that the bio enqueued into as the returned cookie.
  */
 static blk_qc_t __submit_bio_noacct(struct bio *bio)
 {
 	struct bio_list bio_list_on_stack[2];
 	blk_qc_t ret = BLK_QC_T_NONE;
+	struct request_queue *top_q = bio->bi_disk->queue;
+	bool poll_on = test_bit(QUEUE_FLAG_POLL, &top_q->queue_flags);
 
 	BUG_ON(bio->bi_next);
 
@@ -968,6 +976,7 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
 	current->bio_list = bio_list_on_stack;
 
 	do {
+		blk_qc_t cookie;
 		struct request_queue *q = bio->bi_disk->queue;
 		struct bio_list lower, same;
 
@@ -980,7 +989,20 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
 		bio_list_on_stack[1] = bio_list_on_stack[0];
 		bio_list_init(&bio_list_on_stack[0]);
 
-		ret = __submit_bio(bio);
+		cookie = __submit_bio(bio);
+
+		if (poll_on &&
+		    blk_qc_t_bio_valid(ret) && blk_qc_t_valid(cookie)) {
+			unsigned int queue_num = blk_qc_t_to_queue_num(cookie);
+			struct blk_mq_hw_ctx *hctx = q->queue_hw_ctx[queue_num];
+
+			cookie = (blk_qc_t)hctx;
+
+			if (!blk_qc_t_valid(ret)) /* set initial value */
+				ret = cookie;
+			else if (ret != cookie)   /* bio got split */
+				ret = BLK_QC_T_BIO_MULTI;
+		}
 
 		/*
 		 * Sort new bios into those for a lower level and those for the
@@ -1003,6 +1025,7 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
 	} while ((bio = bio_list_pop(&bio_list_on_stack[0])));
 
 	current->bio_list = NULL;
+
 	return ret;
 }
 
@@ -1142,7 +1165,13 @@ static int blk_bio_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 	do {
 		int ret;
 
-		ret = disk->fops->poll(q, cookie);
+		if (blk_qc_t_bio_valid(cookie)) {
+			struct blk_mq_hw_ctx *hctx = (struct blk_mq_hw_ctx *)cookie;
+			struct request_queue *target_q = hctx->queue;
+
+			ret = blk_mq_poll_hctx(target_q, hctx);
+		} else
+			ret = disk->fops->poll(q, cookie);
 		if (ret > 0) {
 			__set_current_state(TASK_RUNNING);
 			return ret;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 2e05244fc16d..4173754532c0 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -557,6 +557,14 @@ static inline bool blk_qc_t_is_internal(blk_qc_t cookie)
 	return (cookie & BLK_QC_T_INTERNAL) != 0;
 }
 
+/* Macros for blk_qc_t used for bio-based polling */
+#define BLK_QC_T_BIO_MULTI	-2U
+
+static inline bool blk_qc_t_bio_valid(blk_qc_t cookie)
+{
+	return cookie != BLK_QC_T_BIO_MULTI;
+}
+
 struct blk_rq_stat {
 	u64 mean;
 	u64 min;
diff --git a/include/linux/types.h b/include/linux/types.h
index da5ca7e1bea9..f6301014a459 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -126,7 +126,7 @@ typedef u64 sector_t;
 typedef u64 blkcnt_t;
 
 /* cookie used for IO polling */
-typedef unsigned int blk_qc_t;
+typedef uintptr_t blk_qc_t;
 
 /*
  * The type of an index into the pagecache.
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

