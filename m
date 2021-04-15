Return-Path: <SRS0=YP8V=JM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CABAAC433B4
	for <dm-devel@archiver.kernel.org>; Thu, 15 Apr 2021 23:16:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7ABBC610FC
	for <dm-devel@archiver.kernel.org>; Thu, 15 Apr 2021 23:16:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7ABBC610FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1618528563;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=R1RNS5V3VHKqKbHU+S5V7QX0AnbXF6acHGXzabq+wxc=;
	b=B/qahUdEo9ZkUvAKvwyOle43fMnvcOZlP6Afw2Iqyp9hTRDB6nWMyzxGevu08iTsF947Z8
	j82r1RMJEa9S6+Xr1y6BtbNbvvU0QIiqmpaxsOCx6WUfDgYItUcuLC8BSDn72dv+obt8X+
	aKD5k3NoAz4b+QC4PzdRAJ28jfBxMnk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408--3vI_wGvPb2ydLR-8y-iEQ-1; Thu, 15 Apr 2021 19:16:00 -0400
X-MC-Unique: -3vI_wGvPb2ydLR-8y-iEQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A2078189D8;
	Thu, 15 Apr 2021 23:15:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 430B29CA0;
	Thu, 15 Apr 2021 23:15:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E15A51806D17;
	Thu, 15 Apr 2021 23:15:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13FNFiW2011143 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 15 Apr 2021 19:15:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E05E0F5CEF; Thu, 15 Apr 2021 23:15:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DADF4FA737
	for <dm-devel@redhat.com>; Thu, 15 Apr 2021 23:15:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 566A3805F4B
	for <dm-devel@redhat.com>; Thu, 15 Apr 2021 23:15:41 +0000 (UTC)
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com
	[209.85.222.182]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-563-RUBtaKuVO-CgBXEKNHE1NA-1; Thu, 15 Apr 2021 19:15:37 -0400
X-MC-Unique: RUBtaKuVO-CgBXEKNHE1NA-1
Received: by mail-qk1-f182.google.com with SMTP id h13so8434827qka.2;
	Thu, 15 Apr 2021 16:15:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
	:in-reply-to:references;
	bh=7RCfwAN4jL/DjugvaPSOGTsmpmXQlAF+zlH96pTjoMg=;
	b=sWcm7HuCeszEuuJSTAsSpVUzh1XBLzJvYFyK+kfQErfKd2ViHzHJMwX3vpxVSrIkX2
	GKapk26TWivmSB9VC1LZNTZZCWz0WXxbV6bBi5YZkalfT/YhpkMlmFesQe0wmLFXqsfX
	pvlkm6/FQCb06eksAqrOFsSwyEfqTSj1W3Do6fnrKGdUjrEwtZT4GbIDfxPWaWhcUjti
	lj9PzN+yCXy5bu3k09IfAVCwO5kRz/7530TCNc1R1j+lCc4KWBr160sMbaFO53+hx8L2
	NpdtEOebsjl8kIHdu7gpfJGcIAdU9KH1676uVcaFeQZxVA603/TajBJWxDmwkO2vRN6b
	huMA==
X-Gm-Message-State: AOAM530+H30wJChx3Kq8MnrQFDcx3Kb299MIAeQPRf1M2RXrqnXHBNB3
	HbpnqtYGjc6vM8wdH8MQfHA=
X-Google-Smtp-Source: ABdhPJwf8piMfDo08mpBT8UOsivPw4eYX8FyC0nqQZZ8gbPRXDke0svfzY8InnsN4GsOOspqnWEdpA==
X-Received: by 2002:a05:620a:70c:: with SMTP id
	12mr336862qkc.377.1618528536145; 
	Thu, 15 Apr 2021 16:15:36 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	c17sm2627690qtd.71.2021.04.15.16.15.35
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 15 Apr 2021 16:15:35 -0700 (PDT)
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Date: Thu, 15 Apr 2021 19:15:29 -0400
Message-Id: <20210415231530.95464-4-snitzer@redhat.com>
In-Reply-To: <20210415231530.95464-1-snitzer@redhat.com>
References: <20210415231530.95464-1-snitzer@redhat.com>
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-nvme@lists.infradead.org
Subject: [dm-devel] [PATCH v2 3/4] nvme: introduce FAILUP handling for
	REQ_FAILFAST_TRANSPORT
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If REQ_FAILFAST_TRANSPORT is set it means the driver should not retry
IO that completed with transport errors. REQ_FAILFAST_TRANSPORT is
set by multipathing software (e.g. dm-multipath) before it issues IO.

Update NVMe to allow failover of requests marked with either
REQ_NVME_MPATH or REQ_FAILFAST_TRANSPORT. This allows such requests
to be given a disposition of either FAILOVER or FAILUP respectively.
FAILUP handling ensures a retryable error is returned up from NVMe.

Introduce nvme_failup_req() for use in nvme_complete_rq() if
nvme_decide_disposition() returns FAILUP. nvme_failup_req() ensures
the request is completed with a retryable IO error when appropriate.
__nvme_end_req() was factored out for use by both nvme_end_req() and
nvme_failup_req().

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/nvme/host/core.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 4134cf3c7e48..10375197dd53 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -299,6 +299,7 @@ enum nvme_disposition {
 	COMPLETE,
 	RETRY,
 	FAILOVER,
+	FAILUP,
 };
 
 static inline enum nvme_disposition nvme_decide_disposition(struct request *req)
@@ -318,10 +319,11 @@ static inline enum nvme_disposition nvme_decide_disposition(struct request *req)
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
@@ -330,10 +332,8 @@ static inline enum nvme_disposition nvme_decide_disposition(struct request *req)
 	return RETRY;
 }
 
-static inline void nvme_end_req(struct request *req)
+static inline void __nvme_end_req(struct request *req, blk_status_t status)
 {
-	blk_status_t status = nvme_error_status(nvme_req(req)->status);
-
 	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
 	    req_op(req) == REQ_OP_ZONE_APPEND)
 		req->__sector = nvme_lba_to_sect(req->q->queuedata,
@@ -343,6 +343,24 @@ static inline void nvme_end_req(struct request *req)
 	blk_mq_end_request(req, status);
 }
 
+static inline void nvme_end_req(struct request *req)
+{
+	__nvme_end_req(req, nvme_error_status(nvme_req(req)->status));
+}
+
+static void nvme_failup_req(struct request *req)
+{
+	blk_status_t status = nvme_error_status(nvme_req(req)->status);
+
+	if (WARN_ON_ONCE(!blk_path_error(status))) {
+		pr_debug("Request meant for failover but blk_status_t (errno=%d) was not retryable.\n",
+			 blk_status_to_errno(status));
+		status = BLK_STS_IOERR;
+	}
+
+	__nvme_end_req(req, status);
+}
+
 void nvme_complete_rq(struct request *req)
 {
 	trace_nvme_complete_rq(req);
@@ -361,6 +379,9 @@ void nvme_complete_rq(struct request *req)
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

