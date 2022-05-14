Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9898FC433F5
	for <dm-devel@archiver.kernel.org>; Sat, 14 May 2022 23:02:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-465-vXbnaVQpPKmSHezkrFtOEQ-1; Sat, 14 May 2022 19:02:14 -0400
X-MC-Unique: vXbnaVQpPKmSHezkrFtOEQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0E3129AB3F0;
	Sat, 14 May 2022 23:02:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8445440D2825;
	Sat, 14 May 2022 23:02:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 597041932106;
	Sat, 14 May 2022 23:02:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 66E5C1947040
 for <dm-devel@listman.corp.redhat.com>; Sat, 14 May 2022 23:02:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4A8694411CF; Sat, 14 May 2022 23:02:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 463904411CB
 for <dm-devel@redhat.com>; Sat, 14 May 2022 23:02:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F54F801210
 for <dm-devel@redhat.com>; Sat, 14 May 2022 23:02:05 +0000 (UTC)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
 [209.85.221.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-nqxtQMbbNt--XMM2SlV2rQ-1; Sat, 14 May 2022 19:02:03 -0400
X-MC-Unique: nqxtQMbbNt--XMM2SlV2rQ-1
Received: by mail-wr1-f47.google.com with SMTP id d5so15950923wrb.6;
 Sat, 14 May 2022 16:02:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=OiSMjCxa5fTZ4bjI04p+LdM1WgAKDGQOza45PbA3bwg=;
 b=2J/1uefZb39mCxU9DGkpJTXvJ5sZDz/XLGY4hWY5DxjdP36q8mar36xe8t/2GhV7/0
 yVyfCGi9GcIWVCv+EjXnx62FERJfjpHuCHVHMiuWTDEbsxRSAUyLUGsqxQsyXlPC03fA
 1f7JAmCbjRzVBqlQ2hZhO6Q1CZkIMQfBTJ9lPhbqNCkMKpwrC87U3j0oMurdROCysx5H
 5Dxv2S0F+oOYIyzoSa3sHfSn2ZgF6WtDLW6ZC2fTlgmc7n1a5dSehl6l18JBchVQczlf
 gC9ij41pVqTKjws9CHPbjkgY6YS+WFqZqxEq7el9I9RYF3ufEOYrriJa0sWNnbSyYa4x
 DrqQ==
X-Gm-Message-State: AOAM5316Kateof3GFn0xkOB6oFb8TSlEbtHdyjasq4CAIEuQXBvKCi2N
 nIHjianyyUUvzDiX1HdtMQ==
X-Google-Smtp-Source: ABdhPJzPd9KH2gEVeVav93PX8uuykOInh0f9n57osXbbPpBSxw7Vxaq/Y53aMt7c1x7jPsYZZTHzMQ==
X-Received: by 2002:adf:dd92:0:b0:20a:d831:222f with SMTP id
 x18-20020adfdd92000000b0020ad831222fmr8446817wrl.401.1652569321741; 
 Sat, 14 May 2022 16:02:01 -0700 (PDT)
Received: from localhost (50.red-81-44-142.dynamicip.rima-tde.net.
 [81.44.142.50]) by smtp.gmail.com with ESMTPSA id
 s18-20020a7bc0d2000000b003942a244eebsm6143279wmh.48.2022.05.14.16.02.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 14 May 2022 16:02:01 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sun, 15 May 2022 01:01:43 +0200
Message-Id: <20220514230148.139675-5-xose.vazquez@gmail.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH 4/9] multipath-tools: add NetApp E-Series NVMe to
 hardware table
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
 NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>,
 DM-DEVEL ML <dm-devel@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Info from (page 12):
https://docs.netapp.com/us-en/e-series/pdfs/sidebar/NVMe_over_Fibre_Channel_setup.pdf

Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 814e727a..61a5aa16 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -845,6 +845,15 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 	},
+	{
+		/* E-Series NVMe */
+		.vendor        = "NVME",
+		.product       = "NetApp E-Series",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.prio_name     = PRIO_ANA,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.no_path_retry = 30,
+	},
 	/*
 	 * NEC
 	 */
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

