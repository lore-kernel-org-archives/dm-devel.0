Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7542C64EC7
	for <dm-devel@archiver.kernel.org>; Wed,  1 Mar 2023 00:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677629248;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=y5M9Agr0RqdBzDOw2RHGYyX7Gikt/L9I6SGqPHjyifM=;
	b=Dah1FOt3vn6AX+RtlI21NFCAHbFQkjAji2WvrRsiqnfC4iH4PJJueFZaCS17dD3YQPB9IC
	Tqw1nuSp+Eu+LjvvDP/J2UC0y+WPiWZ2ie5PrPdkyQUA8JIWHuux1jmbMZPRvWhJRYFicJ
	ET3ep5/QN7I7HyghkrrvpShkBx/p/TM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-0hBEBISLO6Cg0ib38jDP3A-1; Tue, 28 Feb 2023 19:07:24 -0500
X-MC-Unique: 0hBEBISLO6Cg0ib38jDP3A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0952C85C70E;
	Wed,  1 Mar 2023 00:07:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8666640C6EC4;
	Wed,  1 Mar 2023 00:07:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7251B194658F;
	Wed,  1 Mar 2023 00:07:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E9CCA194658C
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Mar 2023 00:07:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CAC45492B0F; Wed,  1 Mar 2023 00:07:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C3E15492B0E
 for <dm-devel@redhat.com>; Wed,  1 Mar 2023 00:07:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7F02101B429
 for <dm-devel@redhat.com>; Wed,  1 Mar 2023 00:07:19 +0000 (UTC)
Received: from mail-oa1-f100.google.com (mail-oa1-f100.google.com
 [209.85.160.100]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-399-aaXS08PgOUG-PFvmprN9Kg-1; Tue, 28 Feb 2023 19:07:17 -0500
X-MC-Unique: aaXS08PgOUG-PFvmprN9Kg-1
Received: by mail-oa1-f100.google.com with SMTP id
 586e51a60fabf-17235c8dab9so12720284fac.7
 for <dm-devel@redhat.com>; Tue, 28 Feb 2023 16:07:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=QOMQhF/sH9JXA0O/3+AXuQxVnIBs73dSZjVTlEU+U2Y=;
 b=G/RtINb/xmrFKCcxVuHiqWpcHCtYgf4PlXKE76j4K4QAAE4qBC3g/5EVadAz3otjnR
 1502egLJtq1z/2lsIO3iaUR1II3pqKvD6v7ZZWWkdsTgZw3ILxM8SnFHIc5RQ7aLiSSP
 yGdJ78fGnw1ZaDX2UZsY6flCZt2Kic0cp18rjwwarvnJn00I8+CpINwcO/a24XFFrF8z
 /VJRc4QaOK9g82pww6ItJBVdGJ248PEsJ9m+hazffHtswC437VV75xoM+wInKESP7CYo
 nGfe5EbontKSWuQkacbDa/2SGuGC+hkfdiMQ1Tqvkg1sTqjmUwuuea4dZGWs3l1+JINS
 ulww==
X-Gm-Message-State: AO0yUKWPf+XGO5pptEkeviH5sM+9T4+50gaxK5bLT1xNKQe8GaI1PZj3
 VzQDOa5hxtImNTRxNQxUKhHdJO/gqqM419mlD/DDy78YdMpXv1XYYCudJEpN8uF74A==
X-Google-Smtp-Source: AK7set83EGGEx4Gtvz8XTLvtgE3w2Y6/DJ78cVT0IPvfAU2EunoiFrSo2mkWCWfJ5m1B6SfYuwyFaebXUk7m
X-Received: by 2002:a05:6870:17aa:b0:172:4d65:d176 with SMTP id
 r42-20020a05687017aa00b001724d65d176mr2230426oae.11.1677629236781; 
 Tue, 28 Feb 2023 16:07:16 -0800 (PST)
Received: from c7-smtp.dev.purestorage.com ([2620:125:9007:320:7:32:106:0])
 by smtp-relay.gmail.com with ESMTPS id
 z22-20020a05687042d600b001727c3968d1sm45584oah.38.2023.02.28.16.07.16
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Tue, 28 Feb 2023 16:07:16 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-ushankar.dev.purestorage.com (dev5.dev.purestorage.com
 [IPv6:2620:125:9007:640:7:70:36:0])
 by c7-smtp.dev.purestorage.com (Postfix) with ESMTP id 98152220F7;
 Tue, 28 Feb 2023 17:07:15 -0700 (MST)
Received: by dev-ushankar.dev.purestorage.com (Postfix, from userid 1557716368)
 id 930C4E4021C; Tue, 28 Feb 2023 17:07:15 -0700 (MST)
From: Uday Shankar <ushankar@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Christoph Hellwig <hch@infradead.org>,
 Keith Busch <kbusch@kernel.org>
Date: Tue, 28 Feb 2023 17:06:55 -0700
Message-Id: <20230301000655.48112-1-ushankar@purestorage.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH v3] blk-mq: enforce op-specific segment limits in
 blk_insert_cloned_request
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 Uday Shankar <ushankar@purestorage.com>, kernel test robot <lkp@intel.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The block layer might merge together discard requests up until the
max_discard_segments limit is hit, but blk_insert_cloned_request checks
the segment count against max_segments regardless of the req op. This
can result in errors like the following when discards are issued through
a DM device and max_discard_segments exceeds max_segments for the queue
of the chosen underlying device.

blk_insert_cloned_request: over max segments limit. (256 > 129)

Fix this by looking at the req_op and enforcing the appropriate segment
limit - max_discard_segments for REQ_OP_DISCARDs and max_segments for
everything else.

Signed-off-by: Uday Shankar <ushankar@purestorage.com>
---
Changes v1-v2:
- Fixed format specifier type mismatch
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202302162040.FaI25ul2-lkp@intel.com/
Changes v2-v3:
- Refactor: move pre-existing blk_rq_get_max_segments to blk.h and use
  it instead of introducing a new function

 block/blk-merge.c | 7 -------
 block/blk-mq.c    | 7 ++++---
 block/blk.h       | 7 +++++++
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 1ac782fdc..6460abdb2 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -587,13 +587,6 @@ int __blk_rq_map_sg(struct request_queue *q, struct request *rq,
 }
 EXPORT_SYMBOL(__blk_rq_map_sg);
 
-static inline unsigned int blk_rq_get_max_segments(struct request *rq)
-{
-	if (req_op(rq) == REQ_OP_DISCARD)
-		return queue_max_discard_segments(rq->q);
-	return queue_max_segments(rq->q);
-}
-
 static inline unsigned int blk_rq_get_max_sectors(struct request *rq,
 						  sector_t offset)
 {
diff --git a/block/blk-mq.c b/block/blk-mq.c
index d3494a796..d0cb2ef18 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3000,6 +3000,7 @@ blk_status_t blk_insert_cloned_request(struct request *rq)
 {
 	struct request_queue *q = rq->q;
 	unsigned int max_sectors = blk_queue_get_max_sectors(q, req_op(rq));
+	unsigned int max_segments = blk_rq_get_max_segments(rq);
 	blk_status_t ret;
 
 	if (blk_rq_sectors(rq) > max_sectors) {
@@ -3026,9 +3027,9 @@ blk_status_t blk_insert_cloned_request(struct request *rq)
 	 * original queue.
 	 */
 	rq->nr_phys_segments = blk_recalc_rq_segments(rq);
-	if (rq->nr_phys_segments > queue_max_segments(q)) {
-		printk(KERN_ERR "%s: over max segments limit. (%hu > %hu)\n",
-			__func__, rq->nr_phys_segments, queue_max_segments(q));
+	if (rq->nr_phys_segments > max_segments) {
+		printk(KERN_ERR "%s: over max segments limit. (%u > %u)\n",
+			__func__, rq->nr_phys_segments, max_segments);
 		return BLK_STS_IOERR;
 	}
 
diff --git a/block/blk.h b/block/blk.h
index e835f21d4..cc4e8873d 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -156,6 +156,13 @@ static inline bool blk_discard_mergable(struct request *req)
 	return false;
 }
 
+static inline unsigned int blk_rq_get_max_segments(struct request *rq)
+{
+	if (req_op(rq) == REQ_OP_DISCARD)
+		return queue_max_discard_segments(rq->q);
+	return queue_max_segments(rq->q);
+}
+
 static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
 						     enum req_op op)
 {

base-commit: bdc9c96cfce220e972136493f4c031f28ecb9f36
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

