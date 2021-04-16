Return-Path: <SRS0=cPWn=JN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02084C433B4
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 23:53:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 891BA6115B
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 23:53:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 891BA6115B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1618617227;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=66D/u0gBSrGAT9L1jxOhCQyDK5+fotQ1emZYKt/GVtg=;
	b=W5UXkD/HHkWwUnOgAWo1DpJTOJTeUQ9Hq5DVGlKiLBViCbDYqJblyUkcgqm6v/D972jRcY
	lv5RwSLsD4lSiXj2K7ijIN090MF/KQhDPPWTpTdygZUhxOrV1tYMa28kGLcsxai7DlS22O
	j5/cGfvY1nZCGzuGsdvD3HU15h6PgVw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-47W94a6dPtaHaHeQCB1JVA-1; Fri, 16 Apr 2021 19:53:45 -0400
X-MC-Unique: 47W94a6dPtaHaHeQCB1JVA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B4FD18397A9;
	Fri, 16 Apr 2021 23:53:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D9965C257;
	Fri, 16 Apr 2021 23:53:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 73D101806D0F;
	Fri, 16 Apr 2021 23:53:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13GNrc8i018867 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 19:53:38 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 51E302021473; Fri, 16 Apr 2021 23:53:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BB0B2021470
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 23:53:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2BF0F805C1D
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 23:53:38 +0000 (UTC)
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com
	[209.85.160.175]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-312-F1AbFHB8MEOovKcYFYb9eA-1; Fri, 16 Apr 2021 19:53:34 -0400
X-MC-Unique: F1AbFHB8MEOovKcYFYb9eA-1
Received: by mail-qt1-f175.google.com with SMTP id y12so22083895qtx.11;
	Fri, 16 Apr 2021 16:53:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
	:in-reply-to:references;
	bh=a1nvUyKb7Km0hekKdxHGyN60tpfHzRrsEqFGAZI+ni4=;
	b=anvzRuoitYfE3MkQS/5n5hDI3RqVH2JXr005Xq/GmVlfPr4hq0npr6RF8nZr3dJa+z
	NbiF2FUX/T2GvI1fgPq5lc9zc7PLnvdtbx8mL4Yfls/KD446hvbXe4k+BA1RDhz5a5NZ
	I8WbM3kOwCf1cqU9yVxHi5PHZz55fedZIrOErGqVk87p5Hq0lDVJmSzxD6jTlVL0hMeL
	4UmWxKHkTlbw0l/C3rickxzx4+w8ECz8nTAxszUh+Nva7x37A+tamQp50PXEyip2xto4
	yaVV7sOY+6W3+LGqmaIryFLHGwn+vYeoMneD3/ehPqIt9DiE1Z8G/socFhGGf2rP0lrz
	ooTg==
X-Gm-Message-State: AOAM533yfjKW0NH4EtOroMIb0+bj/I09n4wtIT3v42Y7fhzuIaz/V+kV
	9zUdyfp1cukRsYkrr0n0CDu7Fm+lZjPhpQ==
X-Google-Smtp-Source: ABdhPJxYYCrNVTkBMHh7ujpabmWkrGvRS/5k9AOlVSsGCZug6eBYSy3tgv0ntn47DVL2D4MVf0kk9A==
X-Received: by 2002:ac8:6b46:: with SMTP id x6mr1598672qts.150.1618617213544; 
	Fri, 16 Apr 2021 16:53:33 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	a66sm1377452qkc.74.2021.04.16.16.53.32
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 16 Apr 2021 16:53:33 -0700 (PDT)
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Date: Fri, 16 Apr 2021 19:53:28 -0400
Message-Id: <20210416235329.49234-3-snitzer@redhat.com>
In-Reply-To: <20210416235329.49234-1-snitzer@redhat.com>
References: <20210416235329.49234-1-snitzer@redhat.com>
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-nvme@lists.infradead.org
Subject: [dm-devel] [PATCH v4 2/3] nvme: allow local retry and proper
	failover for REQ_FAILFAST_TRANSPORT
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

REQ_FAILFAST_TRANSPORT is set by upper layer software that handles
multipathing. Unlike SCSI, NVMe's error handling was specifically
designed to handle local retry for non-path errors. As such, allow
NVMe's local retry mechanism to be used for requests marked with
REQ_FAILFAST_TRANSPORT.

In this way, the mechanism of NVMe multipath or other multipath are
now equivalent. The mechanism is: non path related error will be
retried locally, path related error is handled by multipath.

Also, introduce FAILUP handling for REQ_FAILFAST_TRANSPORT. Update
NVMe to allow failover of requests marked with either REQ_NVME_MPATH
or REQ_FAILFAST_TRANSPORT. This allows such requests to be given a
disposition of either FAILOVER or FAILUP respectively.

nvme_complete_rq() is updated to call nvme_failup_req() if
nvme_decide_disposition() returns FAILUP. nvme_failup_req() ensures
the request is completed with a retryable path error.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/nvme/host/core.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 540d6fd8ffef..a12b10a1383c 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -299,6 +299,7 @@ enum nvme_disposition {
 	COMPLETE,
 	RETRY,
 	FAILOVER,
+	FAILUP,
 };
 
 static inline enum nvme_disposition nvme_decide_disposition(struct request *req)
@@ -306,15 +307,16 @@ static inline enum nvme_disposition nvme_decide_disposition(struct request *req)
 	if (likely(nvme_req(req)->status == 0))
 		return COMPLETE;
 
-	if (blk_noretry_request(req) ||
+	if ((req->cmd_flags & (REQ_FAILFAST_DEV | REQ_FAILFAST_DRIVER)) ||
 	    (nvme_req(req)->status & NVME_SC_DNR) ||
 	    nvme_req(req)->retries >= nvme_max_retries)
 		return COMPLETE;
 
-	if (req->cmd_flags & REQ_NVME_MPATH) {
+	if (req->cmd_flags & (REQ_NVME_MPATH | REQ_FAILFAST_TRANSPORT)) {
 		if (nvme_is_path_error(nvme_req(req)->status) ||
 		    blk_queue_dying(req->q))
-			return FAILOVER;
+			return (req->cmd_flags & REQ_NVME_MPATH) ?
+				FAILOVER : FAILUP;
 	} else {
 		if (blk_queue_dying(req->q))
 			return COMPLETE;
@@ -336,6 +338,12 @@ static inline void nvme_end_req(struct request *req)
 	blk_mq_end_request(req, status);
 }
 
+static inline void nvme_failup_req(struct request *req)
+{
+	nvme_req(req)->status = NVME_SC_HOST_PATH_ERROR;
+	nvme_end_req(req);
+}
+
 void nvme_complete_rq(struct request *req)
 {
 	trace_nvme_complete_rq(req);
@@ -354,6 +362,9 @@ void nvme_complete_rq(struct request *req)
 	case FAILOVER:
 		nvme_failover_req(req);
 		return;
+	case FAILUP:
+		nvme_failup_req(req);
+		return;
 	}
 }
 EXPORT_SYMBOL_GPL(nvme_complete_rq);
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

