Return-Path: <SRS0=PkBB=IC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FAEFC43381
	for <dm-devel@archiver.kernel.org>; Thu,  4 Mar 2021 14:42:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 279E164F41
	for <dm-devel@archiver.kernel.org>; Thu,  4 Mar 2021 14:42:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 279E164F41
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-c0ckCac0M_yHBZjMzTUGMw-1; Thu, 04 Mar 2021 09:42:08 -0500
X-MC-Unique: c0ckCac0M_yHBZjMzTUGMw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 807E5CC628;
	Thu,  4 Mar 2021 14:42:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 59C5C5C1B4;
	Thu,  4 Mar 2021 14:42:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2A8E4C59A;
	Thu,  4 Mar 2021 14:42:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 123Bw10B003379 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Mar 2021 06:58:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D99B0201874C; Wed,  3 Mar 2021 11:58:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CFA262018759
	for <dm-devel@redhat.com>; Wed,  3 Mar 2021 11:58:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B24668C8596
	for <dm-devel@redhat.com>; Wed,  3 Mar 2021 11:58:01 +0000 (UTC)
Received: from out30-132.freemail.mail.aliyun.com
	(out30-132.freemail.mail.aliyun.com [115.124.30.132]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-396-yw8zKVbSN9yNqsmttyVzvw-1;
	Wed, 03 Mar 2021 06:57:54 -0500
X-MC-Unique: yw8zKVbSN9yNqsmttyVzvw-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R211e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
	TI=SMTPD_---0UQFn1IH_1614772667
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UQFn1IH_1614772667) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 03 Mar 2021 19:57:48 +0800
From: Jeffle Xu <jefflexu@linux.alibaba.com>
To: msnitzer@redhat.com, axboe@kernel.dk
Date: Wed,  3 Mar 2021 19:57:35 +0800
Message-Id: <20210303115740.127001-8-jefflexu@linux.alibaba.com>
In-Reply-To: <20210303115740.127001-1-jefflexu@linux.alibaba.com>
References: <20210303115740.127001-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
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
X-Mailman-Approved-At: Thu, 04 Mar 2021 09:41:43 -0500
Cc: caspar@linux.alibaba.com, linux-block@vger.kernel.org,
	joseph.qi@linux.alibaba.com, dm-devel@redhat.com,
	mpatocka@redhat.com, io-uring@vger.kernel.org
Subject: [dm-devel] [PATCH v5 07/12] blk-mq: add one helper function getting
	hw queue
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add one helper function getting hw queue mapping to specific CPU, and of
specific type.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 block/blk-mq.c         | 10 ++++++++++
 include/linux/blk-mq.h |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 6ef9f0b038c2..72390f208c82 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3902,6 +3902,16 @@ unsigned int blk_mq_rq_cpu(struct request *rq)
 }
 EXPORT_SYMBOL(blk_mq_rq_cpu);
 
+
+struct blk_mq_hw_ctx *blk_mq_get_hctx(struct request_queue *q, int cpu,
+				      unsigned int flags)
+{
+	struct blk_mq_ctx *ctx = __blk_mq_get_ctx(q, cpu);
+
+	return blk_mq_map_queue(q, flags, ctx);
+}
+EXPORT_SYMBOL(blk_mq_get_hctx);
+
 static int __init blk_mq_init(void)
 {
 	int i;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index d22269b3dbe9..149f6a9d9aa7 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -638,5 +638,7 @@ blk_qc_t blk_mq_submit_bio(struct bio *bio);
 int blk_mq_poll(struct request_queue *q, blk_qc_t cookie, bool spin);
 void blk_mq_hctx_set_fq_lock_class(struct blk_mq_hw_ctx *hctx,
 		struct lock_class_key *key);
+struct blk_mq_hw_ctx *blk_mq_get_hctx(struct request_queue *q, int cpu,
+		unsigned int flags);
 
 #endif
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

