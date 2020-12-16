Return-Path: <SRS0=g9U1=FU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D16EC1B0D8
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 22:18:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0404322A99
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 22:18:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0404322A99
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-lIGLqvLTOLGuR3a-k1LWFg-1; Wed, 16 Dec 2020 17:18:01 -0500
X-MC-Unique: lIGLqvLTOLGuR3a-k1LWFg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F60D19251A2;
	Wed, 16 Dec 2020 22:17:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 57CAC60C15;
	Wed, 16 Dec 2020 22:17:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9237A4A7C6;
	Wed, 16 Dec 2020 22:17:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BGMHpwU013447 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 17:17:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B48392026D48; Wed, 16 Dec 2020 22:17:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AFD702026D76
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 22:17:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44855185A7BC
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 22:17:49 +0000 (UTC)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com
	[209.85.221.44]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-245-ZxYYUH_9NZ6qAdspzzq73A-1; Wed, 16 Dec 2020 17:17:46 -0500
X-MC-Unique: ZxYYUH_9NZ6qAdspzzq73A-1
Received: by mail-wr1-f44.google.com with SMTP id y17so24633571wrr.10;
	Wed, 16 Dec 2020 14:17:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references:mime-version:content-transfer-encoding;
	bh=yPvajLKRJWnyOX3Jny/8rqbKeXgsqJ6fO6hmz9JpJ3s=;
	b=kBRoCWvEq3feCgB4xjbqj7mvWDOD3UYDnx3U1lDoLubOgv50adj1m0j/Y+U71Mnr1e
	1eUrlifUrHefDqP5M679XzRmvT4MNDIZET891k5E4fuNJlOe/cnpuMriJJuDJtkDvpZ5
	gkYe6but/j0zbSEbIs+SsaNQoD0BXR6S/vErvseL4xvWhc00fXOUuqxp5M7cFLI3dbCD
	VMTBJhOdaQfz32Y99ch82ypc+YSUGIcZeq/c2sYkEBh8O43XwDSEfzzSE+q71RkdDgdl
	JlkhAmec+KUNAcc8n2hYO2k5tQs1s12euXcRqn1fbhkLhjjZ0pEmqn5cQU+ZOTk9IPUv
	HyCw==
X-Gm-Message-State: AOAM5328YOceyn/eXNC2iH55BmdfETQHcnaMr2lV5s/HvfHiS4gqe0b5
	dYG1EmM6CB8PDTp1eeC76AQfLitpnugx
X-Google-Smtp-Source: ABdhPJy7v4/g236BNUnVekczE3bPZxYimZFabD53hdCyG1n/5ukqswaYJj5SYVIXnsvfwW1d8U8CEg==
X-Received: by 2002:adf:bb0e:: with SMTP id r14mr41444594wrg.159.1608157065556;
	Wed, 16 Dec 2020 14:17:45 -0800 (PST)
Received: from localhost (10.red-176-87-2.dynamicip.rima-tde.net.
	[176.87.2.10]) by smtp.gmail.com with ESMTPSA id
	f14sm4506563wme.14.2020.12.16.14.17.44
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 16 Dec 2020 14:17:45 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Wed, 16 Dec 2020 23:17:40 +0100
Message-Id: <20201216221740.10170-2-xose.vazquez@gmail.com>
In-Reply-To: <20201216221740.10170-1-xose.vazquez@gmail.com>
References: <20201216221740.10170-1-xose.vazquez@gmail.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
	DM-DEVEL ML <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH resend] multipath-tools: Violin and Nexsan were
	bought by StorCentric
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Reviewed-by: Martin Wilck <mwilck@suse.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 59bc0d6e..475489c2 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1113,8 +1113,9 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 	},
 	/*
-	 * Imation/Nexsan
+	 * StorCentric
 	 */
+		/* Nexsan */
 	{
 		/* E-Series */
 		.vendor        = "NEXSAN",
@@ -1143,9 +1144,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 		.no_path_retry = 30,
 	},
-	/*
-	 * Violin Systems
-	 */
+		/* Violin Systems */
 	{
 		/* 3000 / 6000 Series */
 		.vendor        = "VIOLIN",
-- 
2.28.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

