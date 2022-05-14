Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 775C1C433F5
	for <dm-devel@archiver.kernel.org>; Sat, 14 May 2022 23:02:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-319-cGg5ZIWfMpa0eARRwnoP5A-1; Sat, 14 May 2022 19:02:10 -0400
X-MC-Unique: cGg5ZIWfMpa0eARRwnoP5A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 46940101AA42;
	Sat, 14 May 2022 23:02:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2F7BB400E887;
	Sat, 14 May 2022 23:02:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D5560194704E;
	Sat, 14 May 2022 23:02:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C58971947040
 for <dm-devel@listman.corp.redhat.com>; Sat, 14 May 2022 23:02:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B638440D2825; Sat, 14 May 2022 23:02:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B26C940D2824
 for <dm-devel@redhat.com>; Sat, 14 May 2022 23:02:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CFE1811E76
 for <dm-devel@redhat.com>; Sat, 14 May 2022 23:02:04 +0000 (UTC)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
 [209.85.221.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-176-GYdD--73PBGjJW5pi2RiSQ-1; Sat, 14 May 2022 19:02:01 -0400
X-MC-Unique: GYdD--73PBGjJW5pi2RiSQ-1
Received: by mail-wr1-f47.google.com with SMTP id e29so6299587wrc.11;
 Sat, 14 May 2022 16:02:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=aSMDxpo3FpM2AjOTjkm47v2K6s0QbMOlcOQ6hKzKRRE=;
 b=VVRC+y6zwh5gf+mZAC9CEz4Z0RXngmCld190Qc5mdqglIxPq3JeOGztIINOIWkZmtG
 kz/jXJ/ADHrmh966lXHDRdF4XUgTxI5hzlD1lUoj5s99ggxQUPD4jPCrFKv3YsUP76ms
 R4wQd3GgiMUmZUDUQdLeQdNAlqbv/mWbnDwea6Oav+pCoNrBfjh4BNLroqrZj19mk5gb
 f86OTmlzWMkLWxJbcUZKkaralF2aGrH5TMleBr5zWzVrKxaw7J652e+KxWFKoMNYSVk3
 EMzEz8VMbXWmE99cfLQF6gRaur+pWoW/QbOzdJy1P202M+7UHFcyA63KFPkT4Qlw8Ci+
 daGw==
X-Gm-Message-State: AOAM530QZnsZ5zOiwuA5W4XntuJgDc0K0m1JyZjp0GG5ZZVWcNoHLfV+
 nYJM+40ybnnOjbxM1K/GEkjZQEFDysW6
X-Google-Smtp-Source: ABdhPJztmFi/w0wt3UggN96MhUTrx0AxcYYiJxCPq7m2f2sdn+RcthDcKTRxP2VtgaCrPyoQyyFbhw==
X-Received: by 2002:a05:6000:70a:b0:20c:4edc:ffad with SMTP id
 bs10-20020a056000070a00b0020c4edcffadmr8477506wrb.469.1652569320354; 
 Sat, 14 May 2022 16:02:00 -0700 (PDT)
Received: from localhost (50.red-81-44-142.dynamicip.rima-tde.net.
 [81.44.142.50]) by smtp.gmail.com with ESMTPSA id
 i10-20020a05600c354a00b003942a244f37sm10728020wmq.16.2022.05.14.16.01.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 14 May 2022 16:02:00 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sun, 15 May 2022 01:01:42 +0200
Message-Id: <20220514230148.139675-4-xose.vazquez@gmail.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH 3/9] multipath-tools: delete redundant ONTAP NVMe
 comment
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
 libmultipath/hwtable.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index b6ff1107..814e727a 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -839,11 +839,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 24,
 	},
 	{
-		/*
-		 * NVMe-FC namespace devices: MULTIBUS, queueing preferred
-		 *
-		 * The hwtable is searched backwards, so place this after "Generic NVMe"
-		 */
+		/* ONTAP NVMe */
 		.vendor        = "NVME",
 		.product       = "^NetApp ONTAP Controller",
 		.pgpolicy      = MULTIBUS,
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

