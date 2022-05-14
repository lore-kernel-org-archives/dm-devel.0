Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AA47C4332F
	for <dm-devel@archiver.kernel.org>; Sat, 14 May 2022 23:02:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-pqrF8VKsOcatq4JkFYExZg-1; Sat, 14 May 2022 19:02:14 -0400
X-MC-Unique: pqrF8VKsOcatq4JkFYExZg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68FEB3C02185;
	Sat, 14 May 2022 23:02:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 57F9540D2820;
	Sat, 14 May 2022 23:02:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2380E194704E;
	Sat, 14 May 2022 23:02:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 117261947040
 for <dm-devel@listman.corp.redhat.com>; Sat, 14 May 2022 23:02:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E84CA434820; Sat, 14 May 2022 23:02:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E477E416385
 for <dm-devel@redhat.com>; Sat, 14 May 2022 23:02:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB5F7805B25
 for <dm-devel@redhat.com>; Sat, 14 May 2022 23:02:10 +0000 (UTC)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com
 [209.85.128.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-59-xqMJqUQmNM2CX2vn9T1A1A-1; Sat, 14 May 2022 19:02:07 -0400
X-MC-Unique: xqMJqUQmNM2CX2vn9T1A1A-1
Received: by mail-wm1-f44.google.com with SMTP id
 v191-20020a1cacc8000000b00397001398c0so75811wme.5; 
 Sat, 14 May 2022 16:02:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=J6GujI3m7mc23fFikWCl+4mUoiDSjQ1P8nbVDnG/7Ag=;
 b=cfCwuYrLa51ho6CnnSMWOlkxNhibmmzVy0xqs9zqnWuJdtxTc1RkICF+QUI0IUgXpy
 ErdAEnF2RLVPre5xUhoKO8obI5nilZqP9X3Nyh6n/mAmQsKlVV8fvjgLvJRIiYUYk9GF
 hbDOo1GNztT0lrYvGvTQtaoEUP4rL/xGjivjTPnw+XwI0CMRxxr3mZ99pq5sXO12W5/L
 fe5zbCF73gG/vxtr6M3uEIyeNPryTmec3QEvHAeIPcsIBecuVzZ+3I3FLDPJ9ku/2tDe
 /7ke2MV2cWAjF+8MSpRiqPmcYzGk1ECVoZwnjcP8d7zSsPxnja2VYdWbQW5AgXteWxNz
 nKYw==
X-Gm-Message-State: AOAM530rYQGiulfdUEP8qBveFgubcn0WAdhGmZvmrJRfhz/o6hF+Al0h
 54c8NzVFsl6gyuq86DdIeA==
X-Google-Smtp-Source: ABdhPJzmksLw7t7nxvqBogZ1h/OwF7lfSzS/JliiDTP4NMO0Bm96qFyV7FkTCYpD1Lh1OSDDl1DnoQ==
X-Received: by 2002:a05:600c:3b99:b0:394:70a0:12e3 with SMTP id
 n25-20020a05600c3b9900b0039470a012e3mr10549451wms.120.1652569325683; 
 Sat, 14 May 2022 16:02:05 -0700 (PDT)
Received: from localhost (50.red-81-44-142.dynamicip.rima-tde.net.
 [81.44.142.50]) by smtp.gmail.com with ESMTPSA id
 p15-20020a7bcdef000000b00394517e7d98sm6370786wmj.25.2022.05.14.16.02.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 14 May 2022 16:02:05 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sun, 15 May 2022 01:01:46 +0200
Message-Id: <20220514230148.139675-8-xose.vazquez@gmail.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH 7/9] multipath-tools: add IBM
 FlashSystem(Storwize/SVC) NVMe to hardware table
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Info from:
https://www.ibm.com/docs/en/flashsystem-7x00/8.5.x?topic=system-multipath-configuration-fc-nvme-hosts

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index f825f6d3..f99e2537 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -680,6 +680,13 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.prio_name     = PRIO_ALUA,
 	},
+	{
+		/* FlashSystem(Storwize/SVC) NVMe */
+		.vendor        = "NVME",
+		.product       = "IBM[ ]+2145",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+	},
 	{
 		/* PAV DASD ECKD */
 		.vendor        = "IBM",
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

