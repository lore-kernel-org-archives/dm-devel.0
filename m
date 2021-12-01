Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5874C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 22:37:01 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-228-xuvyQ_i2OUWZAcIJ8JgNrw-1; Wed, 01 Dec 2021 17:36:57 -0500
X-MC-Unique: xuvyQ_i2OUWZAcIJ8JgNrw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46BF21006AA4;
	Wed,  1 Dec 2021 22:36:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2BB766060F;
	Wed,  1 Dec 2021 22:36:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A17E74BB7C;
	Wed,  1 Dec 2021 22:36:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B1MZO2I013721 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 17:35:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 229984010E8A; Wed,  1 Dec 2021 22:35:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D19840CFD0E
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 22:35:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 044A6185A79C
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 22:35:24 +0000 (UTC)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com
	[209.85.128.51]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-122-HWY0PCjPO8W43uRFboK5UA-1; Wed, 01 Dec 2021 17:35:22 -0500
X-MC-Unique: HWY0PCjPO8W43uRFboK5UA-1
Received: by mail-wm1-f51.google.com with SMTP id
	i8-20020a7bc948000000b0030db7b70b6bso921669wml.1; 
	Wed, 01 Dec 2021 14:35:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=w43jTbHl9uCUvDF2lXcZnWe1N97J9j/hb0sSTXl0PTc=;
	b=Qyaj6eFohEWvb5VwSQ6KqEqMUZWtcsuxes3vH1ZvSbILjlrDh56BeR8ddx5609rCY5
	VfBkVXujakPEt9Xs9pcqsAlWjfS6Mf8DVwDqf5oBnk1SjRl1lBQXj7ouy8Ks3lnKt35H
	YoAJkYFPEp4HKuc4uaGo0hJNySwi4ZuEl9F/Dbb2wKrSsx8ppVWo6VYUyB0LRXT5M3jk
	rYckfdkSYCJM16HJh7B5jmRFXvCIaOIXvFO755T91ZEMaO7Ed/P8iarLIA3jMXYWJiR0
	WfNa4+f8hlyMLJRaYPyIMcFbj/VVYK0xk/sA/Lrg0cMnHIyA1YsxwTgswsvuyjmQVC1T
	IXVw==
X-Gm-Message-State: AOAM530GFnuXLNMRQJo08MLImegysDyyVEARDvQIp9cdlAE58oES82Kv
	z34ecWdj/5ukZkLbyF8Hkw==
X-Google-Smtp-Source: ABdhPJwJx3tOBo+S58TEMSj8Ju/sinUJ0AcLRfiiaNYOksLrmyF1LLhSB95ALH8GCFnZa42U2yuj3w==
X-Received: by 2002:a1c:7910:: with SMTP id l16mr1380920wme.36.1638398120768; 
	Wed, 01 Dec 2021 14:35:20 -0800 (PST)
Received: from localhost (50.red-83-33-156.dynamicip.rima-tde.net.
	[83.33.156.50])
	by smtp.gmail.com with ESMTPSA id w22sm460837wmi.27.2021.12.01.14.35.20
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 01 Dec 2021 14:35:20 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Wed,  1 Dec 2021 23:35:15 +0100
Message-Id: <20211201223518.3775-1-xose.vazquez@gmail.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
	DM-DEVEL ML <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH resend] multipath-tools: add DellEMC/ME4
	(PowerVault ME4) to hardware table
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Info from: https://www.delltechnologies.com/asset/fr-fr/products/storage/industry-market/PowerVault_ME4_Series_and_Linux.pdf

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 763982cd..fc85283b 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -398,6 +398,15 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 3,
 		.fast_io_fail  = 15,
 	},
+	{
+		/* PowerVault ME4 */
+		.vendor        = "DellEMC",
+		.product       = "ME4",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.prio_name     = PRIO_ALUA,
+		.hwhandler     = "1 alua",
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+	},
 	/*
 	 * Fujitsu
 	 */
-- 
2.32.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

