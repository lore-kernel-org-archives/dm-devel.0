Return-Path: <SRS0=cPWn=JN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F90C433ED
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 22:09:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4D8DF611AF
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 22:09:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D8DF611AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1618610943;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qf+hlEoDblnF0tYk6GlL6S1yyKsqDtYrleQgKuaUJfg=;
	b=Mkh1LJg5p7VUodvlDi0a8FmbURIvERr1V0SYhTvMRGzJm1kufSZ5D5H6gZRXkSEnGxta2c
	E0Xh5Z6bFrtOi70538ZKgkIUd+zkfNPq07z657JCTrycyAz/1FlTJEWYFaUSBlBQoTFGNO
	emOmlNY3+8s0oA0jNS3GPUXumJ42CBE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-E9TDLHeTMcajZBsZ_Gqnig-1; Fri, 16 Apr 2021 18:09:00 -0400
X-MC-Unique: E9TDLHeTMcajZBsZ_Gqnig-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D25E081746E;
	Fri, 16 Apr 2021 22:08:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B12AA5945A;
	Fri, 16 Apr 2021 22:08:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7C4674EE0B;
	Fri, 16 Apr 2021 22:08:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13GM6nb2010952 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 18:06:50 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C3CE6103CCE; Fri, 16 Apr 2021 22:06:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BDEF7104823
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 22:06:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8258085A5AA
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 22:06:46 +0000 (UTC)
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com
	[209.85.160.172]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-310-JSg0eystMjW0JHdt8dp7iw-1; Fri, 16 Apr 2021 18:06:42 -0400
X-MC-Unique: JSg0eystMjW0JHdt8dp7iw-1
Received: by mail-qt1-f172.google.com with SMTP id 1so21939680qtb.0;
	Fri, 16 Apr 2021 15:06:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
	:in-reply-to:references;
	bh=T/JS0tPFuGx026nisaFi9hJiA3/ZXWO6l+YekczmOw4=;
	b=Jj0LIH8HNs/9qApUuDaya1qOuaGkf0LUEYg8kWjeVdbc84qIrUoxPOUzHsq5z67Gcm
	txOMvVFfdYI4g64LMT75nBuYeZEXCTE15xpdKM7O8bb97tBTW3ArZL92V+qiajZvjMd4
	7pIH1+rojd/DQ7IjaJvFyYrnIu5m4P56HrG4FLQQAK6n3jUPuOzu9iPXsI5Xkg8bQoRT
	YLU7zTtvndiH5FA6RkWjbqjmKbX4i9ESEnGB5g1/85ZQBaycv2xpdDVDmsaER/R41sgq
	B58A5xo52iJkuEyQRbKkeN9kycgcc1c1aFj+Nx2c1WqMP545lwJw4lKtk/VHeV83boEq
	xyuA==
X-Gm-Message-State: AOAM533CYUnLt46G66YF5/FLBgDHxPVjaXA73F4iw94Atb+hT3uv6Imh
	NqBbZCL+bb0+wbPg/V5SAtM=
X-Google-Smtp-Source: ABdhPJxyJrj306zuvVTg3nzFruQmMJ8VK2i/9VkWSo3aiQx5V9FJ+qx4C2zKZCnzibF9TMCU9sAExA==
X-Received: by 2002:a05:622a:52:: with SMTP id
	y18mr1219038qtw.216.1618610801550; 
	Fri, 16 Apr 2021 15:06:41 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	o62sm5165833qkd.81.2021.04.16.15.06.40
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 16 Apr 2021 15:06:41 -0700 (PDT)
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Date: Fri, 16 Apr 2021 18:06:35 -0400
Message-Id: <20210416220637.41111-3-snitzer@redhat.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	Chao Leng <lengchao@huawei.com>, linux-nvme@lists.infradead.org
Subject: [dm-devel] [PATCH v3 2/4] nvme: allow local retry for requests with
	REQ_FAILFAST_TRANSPORT set
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

From: Chao Leng <lengchao@huawei.com>

REQ_FAILFAST_TRANSPORT was designed for SCSI, because the SCSI protocol
does not define the local retry mechanism. SCSI implements a fuzzy
local retry mechanism, so REQ_FAILFAST_TRANSPORT is needed to allow
higher-level multipathing software to perform failover/retry.

NVMe is different with SCSI about this. It defines a local retry
mechanism and path error codes, so NVMe should retry local for non
path error. If path related error, whether to retry and how to retry
is still determined by higher-level multipathing's failover.

Unlike SCSI, NVMe shouldn't prevent retry if REQ_FAILFAST_TRANSPORT
because NVMe's local retry is needed -- as is NVMe specific logic to
categorize whether an error is path related.

In this way, the mechanism of NVMe multipath or other multipath are
now equivalent. The mechanism is: non path related error will be
retried locally, path related error is handled by multipath.

Signed-off-by: Chao Leng <lengchao@huawei.com>
[snitzer: edited header for grammar and clarity, also added code comment]
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/nvme/host/core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 540d6fd8ffef..4134cf3c7e48 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -306,7 +306,14 @@ static inline enum nvme_disposition nvme_decide_disposition(struct request *req)
 	if (likely(nvme_req(req)->status == 0))
 		return COMPLETE;
 
-	if (blk_noretry_request(req) ||
+	/*
+	 * REQ_FAILFAST_TRANSPORT is set by upper layer software that
+	 * handles multipathing. Unlike SCSI, NVMe's error handling was
+	 * specifically designed to handle local retry for non-path errors.
+	 * As such, allow NVMe's local retry mechanism to be used for
+	 * requests marked with REQ_FAILFAST_TRANSPORT.
+	 */
+	if ((req->cmd_flags & (REQ_FAILFAST_DEV | REQ_FAILFAST_DRIVER)) ||
 	    (nvme_req(req)->status & NVME_SC_DNR) ||
 	    nvme_req(req)->retries >= nvme_max_retries)
 		return COMPLETE;
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

