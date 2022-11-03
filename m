Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33EA2C43217
	for <dm-devel@archiver.kernel.org>; Fri,  4 Nov 2022 06:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667544612;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ImSLetlk2I36g9HWPx2jwO4rB1qW3zroY/zGdagflwQ=;
	b=L0x6fWEUMArZdRZK8LuOI4PRQms8RaqwDRdU8bRgddELWyVybZkP80XV7xQqtumsIf5F05
	jBAu8Be1iMpUZukjef6EtK3o1AIAolrlVQwe03pbxgLd4rKHs9UovyCaaY9fvD0TGjdquz
	kjNoPdRBRQwT/vQhXeELRIsw/OhQbqo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-258-qGeLGx8DPDirHcVXhoZXOQ-1; Fri, 04 Nov 2022 02:50:09 -0400
X-MC-Unique: qGeLGx8DPDirHcVXhoZXOQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D079833A19;
	Fri,  4 Nov 2022 06:50:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 34DDC492B25;
	Fri,  4 Nov 2022 06:50:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E97A919465B3;
	Fri,  4 Nov 2022 06:50:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AA0A01946594
 for <dm-devel@listman.corp.redhat.com>; Thu,  3 Nov 2022 15:26:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A0803C16932; Thu,  3 Nov 2022 15:26:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 98D1DC15BAB
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 15:26:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 802971C08982
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 15:26:15 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com
 [67.231.145.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-378-My2fYUgpPdukK5wxnkbkPA-1; Thu, 03 Nov 2022 11:26:14 -0400
X-MC-Unique: My2fYUgpPdukK5wxnkbkPA-1
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
 by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A3984Dc017248
 for <dm-devel@redhat.com>; Thu, 3 Nov 2022 08:26:11 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
 by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kmar7atnk-2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
 for <dm-devel@redhat.com>; Thu, 03 Nov 2022 08:26:11 -0700
Received: from twshared14438.02.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 08:26:09 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
 id BA164AA9A07E; Thu,  3 Nov 2022 08:26:00 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <dm-devel@redhat.com>, <axboe@kernel.dk>
Date: Thu, 3 Nov 2022 08:25:59 -0700
Message-ID: <20221103152559.1909328-4-kbusch@meta.com>
In-Reply-To: <20221103152559.1909328-1-kbusch@meta.com>
References: <20221103152559.1909328-1-kbusch@meta.com>
MIME-Version: 1.0
X-FB-Internal: Safe
X-Proofpoint-ORIG-GUID: HiJDTfdiRA7WshjJLqCzvPfDw0iPq9Vg
X-Proofpoint-GUID: HiJDTfdiRA7WshjJLqCzvPfDw0iPq9Vg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_04,2022-11-03_01,2022-06-22_01
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Fri, 04 Nov 2022 06:50:05 +0000
Subject: [dm-devel] [PATCH 3/3] block: make blk_set_default_limits() private
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
Cc: ebiggers@kernel.org, Keith Busch <kbusch@kernel.org>, mpatocka@redhat.com,
 me@demsh.org, stefanha@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Keith Busch <kbusch@kernel.org>

There are no external users of this function.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/blk-settings.c   | 1 -
 block/blk.h            | 1 +
 include/linux/blkdev.h | 1 -
 3 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 4949ed3ce7c9..8ac1038d0c79 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -59,7 +59,6 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->zone_write_granularity = 0;
 	lim->dma_alignment = 511;
 }
-EXPORT_SYMBOL(blk_set_default_limits);
 
 /**
  * blk_set_stacking_limits - set default limits for stacking devices
diff --git a/block/blk.h b/block/blk.h
index d259d1da4cb4..4849a2efa4c5 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -330,6 +330,7 @@ void blk_rq_set_mixed_merge(struct request *rq);
 bool blk_rq_merge_ok(struct request *rq, struct bio *bio);
 enum elv_merge blk_try_merge(struct request *rq, struct bio *bio);
 
+void blk_set_default_limits(struct queue_limits *lim);
 int blk_dev_init(void);
 
 /*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 69ee5ea29e2f..704bc175a732 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -939,7 +939,6 @@ extern void blk_queue_io_min(struct request_queue *q, unsigned int min);
 extern void blk_limits_io_opt(struct queue_limits *limits, unsigned int opt);
 extern void blk_queue_io_opt(struct request_queue *q, unsigned int opt);
 extern void blk_set_queue_depth(struct request_queue *q, unsigned int depth);
-extern void blk_set_default_limits(struct queue_limits *lim);
 extern void blk_set_stacking_limits(struct queue_limits *lim);
 extern int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 			    sector_t offset);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

