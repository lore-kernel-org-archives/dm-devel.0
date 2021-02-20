Return-Path: <SRS0=l+U7=HY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52974C433E0
	for <dm-devel@archiver.kernel.org>; Mon, 22 Feb 2021 08:51:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A877564E61
	for <dm-devel@archiver.kernel.org>; Mon, 22 Feb 2021 08:51:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A877564E61
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-603-UnaaDFj-NnG_5albzawEjg-1; Mon, 22 Feb 2021 03:51:45 -0500
X-MC-Unique: UnaaDFj-NnG_5albzawEjg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74A831020C22;
	Mon, 22 Feb 2021 08:51:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5380769322;
	Mon, 22 Feb 2021 08:51:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 23F1E4EBC6;
	Mon, 22 Feb 2021 08:51:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11KB6s47010467 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 20 Feb 2021 06:06:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EFFAD21121A3; Sat, 20 Feb 2021 11:06:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EAF35200ACC4
	for <dm-devel@redhat.com>; Sat, 20 Feb 2021 11:06:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2B861022F09
	for <dm-devel@redhat.com>; Sat, 20 Feb 2021 11:06:53 +0000 (UTC)
Received: from out30-44.freemail.mail.aliyun.com
	(out30-44.freemail.mail.aliyun.com [115.124.30.44]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-89-7Q0E90YIPKKex4mdxjo5QA-1;
	Sat, 20 Feb 2021 06:06:48 -0500
X-MC-Unique: 7Q0E90YIPKKex4mdxjo5QA-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R251e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04394;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=9; SR=0;
	TI=SMTPD_---0UP1N.EP_1613819202
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UP1N.EP_1613819202) by smtp.aliyun-inc.com(127.0.0.1);
	Sat, 20 Feb 2021 19:06:43 +0800
From: Jeffle Xu <jefflexu@linux.alibaba.com>
To: snitzer@redhat.com, axboe@kernel.dk
Date: Sat, 20 Feb 2021 19:06:30 +0800
Message-Id: <20210220110637.50305-6-jefflexu@linux.alibaba.com>
In-Reply-To: <20210220110637.50305-1-jefflexu@linux.alibaba.com>
References: <20210220110637.50305-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
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
X-Mailman-Approved-At: Mon, 22 Feb 2021 03:49:50 -0500
Cc: caspar@linux.alibaba.com, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, ming.lei@redhat.com, hch@lst.de
Subject: [dm-devel] [PATCH v4 05/12] blk-mq: extract one helper function
	polling hw queue
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Extract the logic of polling one hw queue and related statistics
handling out as the helper function.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 block/blk-mq.c         |  5 +----
 include/linux/blk-mq.h | 13 +++++++++++++
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c18bc23834a0..b4de2b37b826 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3850,11 +3850,8 @@ int blk_mq_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 	do {
 		int ret;
 
-		hctx->poll_invoked++;
-
-		ret = q->mq_ops->poll(hctx);
+		ret = blk_mq_poll_hctx(q, hctx);
 		if (ret > 0) {
-			hctx->poll_success++;
 			__set_current_state(TASK_RUNNING);
 			return ret;
 		}
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index adc789d5888e..cf1910c6d5ae 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -606,6 +606,19 @@ static inline void blk_rq_bio_prep(struct request *rq, struct bio *bio,
 		rq->rq_disk = bio->bi_disk;
 }
 
+static inline int blk_mq_poll_hctx(struct request_queue *q,
+				   struct blk_mq_hw_ctx *hctx)
+{
+	int ret;
+
+	hctx->poll_invoked++;
+	ret = q->mq_ops->poll(hctx);
+	if (ret > 0)
+		hctx->poll_success++;
+
+	return ret;
+}
+
 blk_qc_t blk_mq_submit_bio(struct bio *bio);
 int blk_mq_poll(struct request_queue *q, blk_qc_t cookie, bool spin);
 void blk_mq_hctx_set_fq_lock_class(struct blk_mq_hw_ctx *hctx,
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

