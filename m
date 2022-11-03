Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E18A5C433FE
	for <dm-devel@archiver.kernel.org>; Thu,  3 Nov 2022 16:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667492273;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DpOWspS+dOcz+ceAIjWhioueJFATdWvXw6kFujgTAr0=;
	b=Y4KHkSzcQKjTw4oAO/Ugz2Rhjf8g2vnNukPaWI1dWh2wsV6XmlZhyv+vWY2JFuY80eccLU
	7ewbi0PydS7C2GiZGJbtTv0G802j5F0EcTk4qt0uHiP6SmEW0TqzBypOrAuOGrpDTaKGua
	+7WJQafISHp7LAjVjvHksue9F/tXlQU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-533-DRw0upXpPliEO5xLvmPAbA-1; Thu, 03 Nov 2022 12:17:51 -0400
X-MC-Unique: DRw0upXpPliEO5xLvmPAbA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 396548041B5;
	Thu,  3 Nov 2022 16:17:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 27F9C4A9254;
	Thu,  3 Nov 2022 16:17:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0D0A81946597;
	Thu,  3 Nov 2022 16:17:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AACD51946594
 for <dm-devel@listman.corp.redhat.com>; Thu,  3 Nov 2022 16:17:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8F21DC15BA4; Thu,  3 Nov 2022 16:17:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 87CC2C15BAB
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 16:17:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D6A9381A72B
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 16:17:45 +0000 (UTC)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com
 [209.85.221.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-298-ICRQCr2zNg2_7gL8zCYitQ-1; Thu, 03 Nov 2022 12:17:42 -0400
X-MC-Unique: ICRQCr2zNg2_7gL8zCYitQ-1
Received: by mail-wr1-f50.google.com with SMTP id a14so3534503wru.5;
 Thu, 03 Nov 2022 09:17:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=jlEQW3CuVjHPzIeuHolspLp9Ckhgyc8kccRjPP511K0=;
 b=Y/Hl0tGU/E3n8fpdSGkQRETPZlEcau9UGfjYEMUeUN/G8IOgNOq5nOv7RRtGTFslMa
 Xpsoe2H7mO7GXLIgtpYjc3n63VlDD5Cq6VZLtN8KNiFP1umW6uwJr8biv9VxqRNW0s1d
 D8DZlsVKYaURKT3O+rR7Sv/bx82aAVoKT4b4pxHmnImbANyDepb8gbasbQg+FxtEeJKu
 J2OguRtuadEB5GKqfZqLmn+R4opA/lNidcVBGmNeQYrJ+dsn5T9RCkrv6TSa//xARe73
 gCrvYrkxIrPYxtAnY1IHPChc4ESqjh2moL4dbzCk+GHMbuy/OLjFPx68J76X9EuJ/vnE
 07Iw==
X-Gm-Message-State: ACrzQf21xSBURE7Qx9ELQB9KCGzRLkWkDYBvMCpTGH73RCxhjj7vI2xe
 Eh9/NE9hO85tsKHreEp58g==
X-Google-Smtp-Source: AMsMyM6WR4HGkgUBudt3KNvP7hESBzHgQsD2b88ZQsT8Uf9xAzaOU/yDKDHcmWj0JHfTlrUDrL8+ow==
X-Received: by 2002:a5d:65cf:0:b0:236:9119:be3 with SMTP id
 e15-20020a5d65cf000000b0023691190be3mr18937803wrw.602.1667492260500; 
 Thu, 03 Nov 2022 09:17:40 -0700 (PDT)
Received: from localhost (230.red-81-44-152.dynamicip.rima-tde.net.
 [81.44.152.230]) by smtp.gmail.com with ESMTPSA id
 bt12-20020a056000080c00b00236576c8eddsm1255330wrb.12.2022.11.03.09.17.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 03 Nov 2022 09:17:40 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu,  3 Nov 2022 17:17:28 +0100
Message-Id: <20221103161730.93378-2-xose.vazquez@gmail.com>
In-Reply-To: <20221103161730.93378-1-xose.vazquez@gmail.com>
References: <20221103161730.93378-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH 1/3 v3] multipath-tools: update hwtable
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add Alletra 5000, FAS/AFF and E/EF Series info.
Compact some info.
Delete trivial/redundant comments.
Reformat LIO.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 2085aba5..7ae7dbf8 100644
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
@@ -456,6 +456,7 @@ static struct hwentry default_hw[] = {
 	{
 		/*
 		 * ETERNUS AB/HB
+		 *
 		 * Maintainer: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
 		 */
 		.vendor        = "FUJITSU",
@@ -672,7 +673,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 	},
 	{
-		// Storwize V5000 and V7000 lines / SAN Volume Controller (SVC) / Flex System V7000 /
+		// Storwize V5000/V7000 lines / SAN Volume Controller (SVC) / Flex System V7000
 		// FlashSystem V840/V9000/5000/5100/5200/7200/7300/9100/9200/9200R/9500
 		.vendor        = "IBM",
 		.product       = "^2145",
@@ -808,7 +809,7 @@ static struct hwentry default_hw[] = {
 	 */
 	{
 		/*
-		 * ONTAP family
+		 * ONTAP FAS/AFF Series
 		 *
 		 * Maintainer: Martin George <marting@netapp.com>
 		 */
@@ -825,7 +826,7 @@ static struct hwentry default_hw[] = {
 	},
 	{
 		/*
-		 * SANtricity(RDAC) family
+		 * SANtricity(RDAC) E/EF Series
 		 *
 		 * Maintainer: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
 		 */
@@ -1049,12 +1050,12 @@ static struct hwentry default_hw[] = {
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
-		.product       = ".",
+		.product       = ".*",
 		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -1107,8 +1108,6 @@ static struct hwentry default_hw[] = {
 	 */
 	{
 		/* OceanStor V3-V6 */
-		// This config works with multibus and ALUA
-		// ALUA is required by HyperMetro
 		.vendor        = "HUAWEI",
 		.product       = "XSG1",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -1202,7 +1201,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	{
-		/* 3000 / 6000 Series - ALUA mode */
+		/* 3000 / 6000 Series (ALUA mode) */
 		.vendor        = "VIOLIN",
 		.product       = "SAN ARRAY ALUA",
 		.hwhandler     = "1 alua",
-- 
2.38.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

