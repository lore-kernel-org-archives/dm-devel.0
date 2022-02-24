Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8502DC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 24 Feb 2022 21:06:39 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-H1Fv5GcHMoyL0reTpcKW9g-1; Thu, 24 Feb 2022 16:06:34 -0500
X-MC-Unique: H1Fv5GcHMoyL0reTpcKW9g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 420BF1091DA1;
	Thu, 24 Feb 2022 21:06:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E6C3100687F;
	Thu, 24 Feb 2022 21:06:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7234D1809C98;
	Thu, 24 Feb 2022 21:06:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21OL6HIa009950 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 24 Feb 2022 16:06:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D89D476EE; Thu, 24 Feb 2022 21:06:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D3B3553B5
	for <dm-devel@redhat.com>; Thu, 24 Feb 2022 21:06:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFC988039D5
	for <dm-devel@redhat.com>; Thu, 24 Feb 2022 21:06:13 +0000 (UTC)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com
	[209.85.128.53]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-479-E9WznqI5NdSjTw1_izkd2Q-1; Thu, 24 Feb 2022 16:06:11 -0500
X-MC-Unique: E9WznqI5NdSjTw1_izkd2Q-1
Received: by mail-wm1-f53.google.com with SMTP id i20so562177wmc.3;
	Thu, 24 Feb 2022 13:06:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=AfwBmvRWDDIejlwfeIVQ50qbevTB+SkhlWJzr1KZ0P8=;
	b=zU41cumntWMAKltYGg4eOE8QNAoz+GqKy9rdRd+17i8o757wB5BdA6yZeNCDv7MZc2
	c49EeQID/jW9D3sXHcYE+YfszkODgG3pc881gywmvUdTLSMl/ZKRgSkJIJaO34aCfcOn
	p+jGt0UYqF3+X0pz1VSSWNmn2onrQa8t4Sri0J3SzwBI1I5qMHT7sP47djX30/CxhvkU
	hkaZjn88gUY/5W2SsALxhTx3ENGMjQOeS5POrWYFTNjNtlIOTQhnrywRg1e33eheubBJ
	ZWJ9V0i+XZBiwym42aiX10zSCPqRgkjlheyF7feD+9z0jgbu0yQOMb82pECc0smVOlnc
	k/ug==
X-Gm-Message-State: AOAM531ZLCBlj1PhgzZG1Nan9wP7M7inn5nmxo+8/sDU65HK63RTXDIo
	vMX9JzjK8A15Eg0F5XhUtKvbiHgOww==
X-Google-Smtp-Source: ABdhPJy1Y4aO55ldtmEvU/KThH+px31+bYVq7PR70lHj4EcX1htUf8bTYaDoCuFqBVUcHPmGguET1A==
X-Received: by 2002:a05:600c:3b06:b0:37c:3ce4:9a31 with SMTP id
	m6-20020a05600c3b0600b0037c3ce49a31mr3910194wms.192.1645736770065;
	Thu, 24 Feb 2022 13:06:10 -0800 (PST)
Received: from localhost (223.red-81-39-136.dynamicip.rima-tde.net.
	[81.39.136.223]) by smtp.gmail.com with ESMTPSA id
	e6-20020a056000120600b001ea9414f2c3sm450173wrx.12.2022.02.24.13.06.09
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 24 Feb 2022 13:06:09 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu, 24 Feb 2022 22:06:08 +0100
Message-Id: <20220224210608.24502-1-xose.vazquez@gmail.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
	DM-DEVEL ML <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH 1/3] multipath-tools: identify more arrays under
	IBM/2145 ID
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 7f89dd2c..cace23b7 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -665,7 +665,7 @@ static struct hwentry default_hw[] = {
 	},
 	{
 		// Storwize V5000 and V7000 lines / SAN Volume Controller (SVC) / Flex System V7000 /
-		// FlashSystem V840/V9000/5000/5100/5200/7200/9100/9200/9200R
+		// FlashSystem V840/V9000/5000/5100/5200/7200/7300/9100/9200/9200R/9500
 		.vendor        = "IBM",
 		.product       = "^2145",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

