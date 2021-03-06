Return-Path: <SRS0=EI4u=IE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27896C433DB
	for <dm-devel@archiver.kernel.org>; Sat,  6 Mar 2021 02:54:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 881E265011
	for <dm-devel@archiver.kernel.org>; Sat,  6 Mar 2021 02:54:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 881E265011
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-KTel0ETpMsqNsV12qd9fHA-1; Fri, 05 Mar 2021 21:54:38 -0500
X-MC-Unique: KTel0ETpMsqNsV12qd9fHA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BCB2F1842143;
	Sat,  6 Mar 2021 02:54:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1819F5D9C0;
	Sat,  6 Mar 2021 02:54:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 45A194EA30;
	Sat,  6 Mar 2021 02:54:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1262sQwr017761 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 5 Mar 2021 21:54:26 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 450DD114A1D2; Sat,  6 Mar 2021 02:54:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 40634114A1D1
	for <dm-devel@redhat.com>; Sat,  6 Mar 2021 02:54:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A5408551E2
	for <dm-devel@redhat.com>; Sat,  6 Mar 2021 02:54:23 +0000 (UTC)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com
	[209.85.128.42]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-367-dE0cCLVkOBWmndMxkb3WYQ-1; Fri, 05 Mar 2021 21:54:19 -0500
X-MC-Unique: dE0cCLVkOBWmndMxkb3WYQ-1
Received: by mail-wm1-f42.google.com with SMTP id
	d139-20020a1c1d910000b029010b895cb6f2so390322wmd.5; 
	Fri, 05 Mar 2021 18:54:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=KGzR+AD5HHJJdQ/qUZFR3QJAG7dvk2gwtNtef31pUck=;
	b=uVR0l3sESZUhDIF1v4dVeH9bjJ6beos8YsmY5tEl/NNGv/z6JVxRsTX4FVZO3B8c9j
	qAz3zWhE5YVInz0JvF4YrZvxOfzmcOXY/DQYrK9/DyJ186nHJRF5mSkPX0Hh2if+PPQk
	cyh9G3pMD9IaCM2c4h+4s7Y49dHQIXJ4uLaLeEN8dwmWVLz/9ty9FuoYLrokXs0NZKZQ
	KV+DP/5P4XV/V4BvZjjXiCG6yMkNJJcGMUKi4f4l2+i3k65+Y2Hoj6TjieuCAitY6DUP
	v0YIk/khxGvocE2ByHW/qvjEryjBCJmKyW5Bl9dqYYdPgjcr8dQ0mBQqtUtvkTfkTjQp
	xN2A==
X-Gm-Message-State: AOAM5318DaYXaKuiG00gLePwkI5v5OI6NkkvPIBkRPDG2EMZJaFap9UR
	hvIZabLEKsdvbVKasA7RBA==
X-Google-Smtp-Source: ABdhPJwq3gF2+PLjwt8uQByr/fdIfvjfmL2Vdvm+7W+ZQ0pNkFCX/eqNu7pn8CIEcf2xvPooPvY2sQ==
X-Received: by 2002:a1c:3b02:: with SMTP id i2mr11551032wma.18.1614999257811; 
	Fri, 05 Mar 2021 18:54:17 -0800 (PST)
Received: from localhost (49.red-83-45-62.dynamicip.rima-tde.net.
	[83.45.62.49])
	by smtp.gmail.com with ESMTPSA id e8sm7235667wme.14.2021.03.05.18.54.17
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 05 Mar 2021 18:54:17 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sat,  6 Mar 2021 03:54:15 +0100
Message-Id: <20210306025415.19329-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
	DM-DEVEL ML <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH v2] multipath-tools: add DellEMC/PowerStore to
	hardware table
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Info from: https://www.delltechnologies.com/en-us/collaterals/unauth/technical-guides-support-information/products/storage-2/docu5128.pdf

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
v2: typo, change .no_path_retry from 30 to 3
---
 libmultipath/hwtable.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 921aadc5..58fa7387 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -388,6 +388,17 @@ static struct hwentry default_hw[] = {
 		.product       = "^EMC PowerMax_",
 		.pgpolicy      = MULTIBUS,
 	},
+	{
+		/* PowerStore */
+		.vendor        = "DellEMC",
+		.product       = "PowerStore",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.prio_name     = PRIO_ALUA,
+		.hwhandler     = "1 alua",
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.no_path_retry = 3,
+		.fast_io_fail  = 15,
+	},
 	/*
 	 * Fujitsu
 	 */
-- 
2.30.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

