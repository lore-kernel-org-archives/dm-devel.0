Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAC71C433F5
	for <dm-devel@archiver.kernel.org>; Sat, 14 May 2022 23:02:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-446-PFeYMq3KMdS7Hig3r6mhKA-1; Sat, 14 May 2022 19:02:28 -0400
X-MC-Unique: PFeYMq3KMdS7Hig3r6mhKA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B4242811E75;
	Sat, 14 May 2022 23:02:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A0BD24411CF;
	Sat, 14 May 2022 23:02:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 75FC2194704E;
	Sat, 14 May 2022 23:02:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8A1661947040
 for <dm-devel@listman.corp.redhat.com>; Sat, 14 May 2022 23:02:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 55A2D2166B4A; Sat, 14 May 2022 23:02:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D5582166B18
 for <dm-devel@redhat.com>; Sat, 14 May 2022 23:02:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 39B2A811E78
 for <dm-devel@redhat.com>; Sat, 14 May 2022 23:02:09 +0000 (UTC)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
 [209.85.221.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-211-Wu_dfs39MpWl-SRvbMAwAQ-1; Sat, 14 May 2022 19:02:05 -0400
X-MC-Unique: Wu_dfs39MpWl-SRvbMAwAQ-1
Received: by mail-wr1-f49.google.com with SMTP id e29so6299696wrc.11;
 Sat, 14 May 2022 16:02:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=HyJwkPInLLequ5oXZm09KsMZtHfGi+Ntfku1e3vcVQ8=;
 b=Q86KfnyYsxO0w/BVj8YbEfjpGmTNxYYqZyfZkV7wdmwhttTrT4orKsg9Hre1BGejoG
 4wJsyzQQ36c94Ejeo2+VjwV3vvVtjJnt1E1dZRK2j2GzFcOcIskdT4NFBapcKNrW0D5G
 4UpvfhJjNNToj5v6Qp7YoFaeP3tMc1HH6Dp/uczH0RUKVTzzTVTXknxoKuLITA+IvZwX
 uErdHlOGIpd4igXkJtjHYF5CaYpBAW6KmGNgWrI2tFZcq5vVJU1S6njXyW9GiwxBb2bP
 95EK75GU2duVrFethW+BFbgPeEqKySQ5acE3QAcrb52LlTPR5vaZD/9XDRbCj9k0CvVt
 y2rw==
X-Gm-Message-State: AOAM530KKFXAc47NCkkdV23mPUBKjYWY2JVeXLo/+9Riu8yHiA+oK1oI
 x7Nq75Vy8uFWhchTYOzCTqpa+kmRkSj0
X-Google-Smtp-Source: ABdhPJwghqXQ2OPvslTPp61T+dv/+8Y36nbePc6/W1Z/i2qPqRsgnJligwYfWmycjlbxJe1FPYlilA==
X-Received: by 2002:a5d:6102:0:b0:20a:db89:724f with SMTP id
 v2-20020a5d6102000000b0020adb89724fmr8866220wrt.59.1652569324269; 
 Sat, 14 May 2022 16:02:04 -0700 (PDT)
Received: from localhost (50.red-81-44-142.dynamicip.rima-tde.net.
 [81.44.142.50]) by smtp.gmail.com with ESMTPSA id
 p2-20020adfaa02000000b0020cd0762f37sm5584708wrd.107.2022.05.14.16.02.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 14 May 2022 16:02:04 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sun, 15 May 2022 01:01:45 +0200
Message-Id: <20220514230148.139675-7-xose.vazquez@gmail.com>
In-Reply-To: <20220514230148.139675-1-xose.vazquez@gmail.com>
References: <20220514230148.139675-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [PATCH 6/9] multipath-tools: add IBM FlashSystem(TMS
 RamSan) NVMe to hardware table
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
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
 DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Info from:
https://www.ibm.com/docs/en/flashsystem-900/1.6.1?topic=configurations-multipathing-information-linux

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index e5adc2a3..f825f6d3 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -733,6 +733,13 @@ static struct hwentry default_hw[] = {
 		.product       = "(RamSan|FlashSystem)",
 		.pgpolicy      = MULTIBUS,
 	},
+	{
+		/* FlashSystem(RamSan) NVMe */
+		.vendor        = "NVMe",
+		.product       = "FlashSystem",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = NO_PATH_RETRY_FAIL,
+	},
 	{
 		/* (DDN) DCS9900, SONAS 2851-DR1 */
 		.vendor        = "IBM",
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

