Return-Path: <SRS0=cPWn=JN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74698C43461
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 22:09:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0EA4E610F7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 22:09:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0EA4E610F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1618610949;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cL/VIKdoRe6G8nUuURPDdunWQMoyPMd3+6/s1nok6Vs=;
	b=YPddn7yryAkD10aBNzkGBsOi78VkxzQgJ6gbEmNBC70Wkm9fj0Rw3vjMXsR5thHvgKeYiN
	H5/3rYzbn+KVnxaSncn28Pqg7nZkLGj+BOB+pJ46Uf9vPu9OKyESzTPaC/+fHNZBafbf+y
	q9jMSH+kgTxo+kEfEGqWEQ+EgvwIJHY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-E_ENOLGZMCOa3gzST5xLEg-1; Fri, 16 Apr 2021 18:09:06 -0400
X-MC-Unique: E_ENOLGZMCOa3gzST5xLEg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 529D28030C9;
	Fri, 16 Apr 2021 22:09:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 32ED25D9C0;
	Fri, 16 Apr 2021 22:09:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 06D2544A60;
	Fri, 16 Apr 2021 22:09:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13GM6rRT010998 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 18:06:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 413F71054E2E; Fri, 16 Apr 2021 22:06:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3CFF910548C7
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 22:06:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C7EC101A52C
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 22:06:49 +0000 (UTC)
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com
	[209.85.222.170]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-476-X_IjnUVfOQy7Ra-zkEcsmA-1; Fri, 16 Apr 2021 18:06:43 -0400
X-MC-Unique: X_IjnUVfOQy7Ra-zkEcsmA-1
Received: by mail-qk1-f170.google.com with SMTP id v7so2383743qkj.13;
	Fri, 16 Apr 2021 15:06:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
	:in-reply-to:references;
	bh=bMR2VTLj6F901p54R7TJJG701KH0qEMwjYWby2WBJ1k=;
	b=IQdo4nn5h6Zg/rPQRP9mOjAJm957RLxmPW6VjDr/4O2ItEPwVuj+MwZgvT64pSIcvO
	/zGd+TxhBZf2nm4K2pjCKcWNpjES7yQjbDhs5/XszI9XTYkcfgv9ri9Tlah/boOrg4wl
	zJFP53W6R0+GsXZi2X2Ai1St6Dv7ze7cD4OLAW28jq9ySBZV8Pb7QePJgmqUO2q5qJce
	1g0dTbXTJyymsjKneH37ZU5gyomGGAtzmj3ZK/IonsLg8KOr8INif7wQV+KJGb+JaNjA
	5MsgQJQ4eiFpG2IoC8aCK1xSHELa4jUtoh6xAK1lWnpujNRg9VUFwvbayPICu1lLHZ5a
	5+Eg==
X-Gm-Message-State: AOAM532+VXjt6LHjXdFFo6KktsDWaclbdY10fyhR8x7pmQM+OXHx302k
	3LOZIsJTeRbEQsLF2IcR16Q=
X-Google-Smtp-Source: ABdhPJwWCSOVGVoMxgIJwBSWNNpF9FwTIxmOZvPSZ8Rmi8aNJ381/s9+9qabM8hKroVd8ED9vuQBtw==
X-Received: by 2002:a37:7006:: with SMTP id l6mr1394793qkc.137.1618610802681; 
	Fri, 16 Apr 2021 15:06:42 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	d62sm5173006qkg.55.2021.04.16.15.06.42
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 16 Apr 2021 15:06:42 -0700 (PDT)
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Date: Fri, 16 Apr 2021 18:06:36 -0400
Message-Id: <20210416220637.41111-4-snitzer@redhat.com>
In-Reply-To: <20210416220637.41111-1-snitzer@redhat.com>
References: <20210416220637.41111-1-snitzer@redhat.com>
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-nvme@lists.infradead.org
Subject: [dm-devel] [PATCH v3 3/4] nvme: introduce FAILUP handling for
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/nvme/host/core.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 4134cf3c7e48..605ffba6835f 100644
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
@@ -343,6 +345,25 @@ static inline void nvme_end_req(struct request *req)
 	blk_mq_end_request(req, status);
 }
 
+static void nvme_failup_req(struct request *req)
+{
+	blk_status_t status = nvme_error_status(nvme_req(req)->status);
+
+	/* Ensure a retryable path error is returned */
+	if (WARN_ON_ONCE(!blk_path_error(status))) {
+		/*
+		 * If here, nvme_is_path_error() returned true.
+		 * So nvme_error_status() translation needs updating
+		 * relative to blk_path_error(), or vice versa.
+		 */
+		pr_debug("Request meant for failover but blk_status_t (errno=%d) was not retryable.\n",
+			 blk_status_to_errno(status));
+		nvme_req(req)->status = NVME_SC_HOST_PATH_ERROR;
+	}
+
+	nvme_end_req(req);
+}
+
 void nvme_complete_rq(struct request *req)
 {
 	trace_nvme_complete_rq(req);
@@ -361,6 +382,9 @@ void nvme_complete_rq(struct request *req)
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

