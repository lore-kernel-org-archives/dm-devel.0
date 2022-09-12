Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39969ECAAD5
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 11:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662981662;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VuEwDN6YFXUz9RQwpX7lgW6NIvnAU17+W7x7ZunwFkc=;
	b=W0evhJuvSl1HZNj4KNsrBcYxwP6NSjPZiyxOTH8vBmVeWtx5H9B3VNcslkJfWI+TeOYdUK
	iDwLrgVFqiTjBGkBBslIDpUKT57QsyuDC5gmAasq2yjkTcP+brXkmfFJMocB0oFxhr/B8T
	Ua/xBpwbsCCeVd6pdArGAjjdEehUvwM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-CQDzNfc8O_OxvDGEvgc6Bg-1; Mon, 12 Sep 2022 07:20:58 -0400
X-MC-Unique: CQDzNfc8O_OxvDGEvgc6Bg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E1F61185A7BA;
	Mon, 12 Sep 2022 11:20:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AE9562027061;
	Mon, 12 Sep 2022 11:20:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7C5041946A43;
	Mon, 12 Sep 2022 11:20:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A3DDD1946A42
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 11:20:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 878FB17582; Mon, 12 Sep 2022 11:20:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 838C910EB8
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 11:20:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 693F93806705
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 11:20:53 +0000 (UTC)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com
 [209.85.221.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-358-khJlBNFSPV6gugTfp0mN2Q-1; Mon, 12 Sep 2022 07:20:51 -0400
X-MC-Unique: khJlBNFSPV6gugTfp0mN2Q-1
Received: by mail-wr1-f44.google.com with SMTP id k9so14869330wri.0;
 Mon, 12 Sep 2022 04:20:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date;
 bh=p9MuuLYus96ZeEOfP4W450FT1kiT0urq/Q4YigWaCH4=;
 b=k1OYKOjdTudPdZOAQCzyNq2MS8yrH85yl/R24Jy6Kuu5JpBNim2/qfOfTdP10jHRL3
 sRkmMR6BiUT6gOx3fljBOfEwmDJOauYkp6KHlhc7kEajhjkrlhUZS6/uZuMX/XJKEers
 q3IHxoLRCmwkqu7y0kqyQpk5sPb2tRMTxfWTyI8uNbyKJHs48x1mSvAlJQIK1U/RgyCs
 83eklZjXnMlmNOfmrOmKXjBKXA6x+Pj5qsirUvq/2eqezuyyywQFc1rHBt2cH+HWDTQB
 PlYXFRO6jwQCnIpShyyno5vXkt5jFBUkdljg9S77jK42vOUOYLGKwOPH/3yKYvNNDtXK
 amvw==
X-Gm-Message-State: ACgBeo3ebqgLS6RruU3602DV5i0w91g2/9Hsfe4xQ/miD25dPwCI2laX
 d1LbBCSuJl14FhXGwzYWYC/eCLP5Dw==
X-Google-Smtp-Source: AA6agR5AfKUrZAlAV84DH5MjqSqXqIewl+58BLtQxcP14i7Ga9wRylnc+ZVNR2WekyFrJUsmcIXLVA==
X-Received: by 2002:a5d:464e:0:b0:228:c179:6b0a with SMTP id
 j14-20020a5d464e000000b00228c1796b0amr14226127wrs.402.1662981650193; 
 Mon, 12 Sep 2022 04:20:50 -0700 (PDT)
Received: from localhost (53.red-81-44-158.dynamicip.rima-tde.net.
 [81.44.158.53]) by smtp.gmail.com with ESMTPSA id
 bg14-20020a05600c3c8e00b003a840690609sm12425476wmb.36.2022.09.12.04.20.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 12 Sep 2022 04:20:49 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Mon, 12 Sep 2022 13:20:47 +0200
Message-Id: <20220912112048.175777-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH v2] multipath-tools: update hwtable
 text/info/comments
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
 DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

add HPE Alletra 5000 info.
compact some info.
delete trivial/redundant comments.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 2085aba5..7daf29d8 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -232,7 +232,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* Nimble Storage / HPE Alletra 6000 */
+		/* Nimble Storage / HPE Alletra 5000/6000 */
 		.vendor        = "Nimble",
 		.product       = "Server",
 		.hwhandler     = "1 alua",
@@ -367,7 +367,7 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 	},
 	{
-		/* SC Series, formerly Compellent */
+		/* SC Series (formerly Compellent) */
 		.vendor        = "COMPELNT",
 		.product       = "Compellent Vol",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -672,7 +672,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 	},
 	{
-		// Storwize V5000 and V7000 lines / SAN Volume Controller (SVC) / Flex System V7000 /
+		// Storwize V5000/V7000 lines / SAN Volume Controller (SVC) / Flex System V7000
 		// FlashSystem V840/V9000/5000/5100/5200/7200/7300/9100/9200/9200R/9500
 		.vendor        = "IBM",
 		.product       = "^2145",
@@ -1049,10 +1049,10 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	/*
-	 * Linux-IO Target
+	 * Linux
 	 */
 	{
-		/* Linux-IO Target */
+		/* Linux-IO (LIO) Target */
 		.vendor        = "(LIO-ORG|SUSE)",
 		.product       = ".",
 		.hwhandler     = "1 alua",
@@ -1107,8 +1107,6 @@ static struct hwentry default_hw[] = {
 	 */
 	{
 		/* OceanStor V3-V6 */
-		// This config works with multibus and ALUA
-		// ALUA is required by HyperMetro
 		.vendor        = "HUAWEI",
 		.product       = "XSG1",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -1202,7 +1200,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	{
-		/* 3000 / 6000 Series - ALUA mode */
+		/* 3000 / 6000 Series (ALUA mode) */
 		.vendor        = "VIOLIN",
 		.product       = "SAN ARRAY ALUA",
 		.hwhandler     = "1 alua",
-- 
2.37.3

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

