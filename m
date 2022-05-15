Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 427D4C433EF
	for <dm-devel@archiver.kernel.org>; Sun, 15 May 2022 13:08:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-oEV4dKU2NjWdgrTn4jPwsg-1; Sun, 15 May 2022 09:08:24 -0400
X-MC-Unique: oEV4dKU2NjWdgrTn4jPwsg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6715A857048;
	Sun, 15 May 2022 13:08:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5E7801544989;
	Sun, 15 May 2022 13:08:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 23AE519451F0;
	Sun, 15 May 2022 13:08:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E22D6194705B
 for <dm-devel@listman.corp.redhat.com>; Sun, 15 May 2022 13:08:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BF4FFC27EA9; Sun, 15 May 2022 13:08:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BB2BBC27EA7
 for <dm-devel@redhat.com>; Sun, 15 May 2022 13:08:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1F31101AA42
 for <dm-devel@redhat.com>; Sun, 15 May 2022 13:08:18 +0000 (UTC)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
 [209.85.221.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-Bqk5tx3mMXacA83Z1MoqXQ-1; Sun, 15 May 2022 09:08:16 -0400
X-MC-Unique: Bqk5tx3mMXacA83Z1MoqXQ-1
Received: by mail-wr1-f47.google.com with SMTP id e29so7609356wrc.11;
 Sun, 15 May 2022 06:08:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=Ijz0rWCeGq7M+K2E2R7Rvnu4jL2Vap/1crH3LKRUCys=;
 b=6+Bq4jLJKqURoUF/XNgytLGlEp47dgpiBzHPJT0jxxiU/HO8AR7wWLLyf1bM6zcgVG
 tdHHq1UX5KoyBU8CoBO8rH9NlGWWRiaxF5Yv+tA/HtF+3D69M1CuttdC9LMyIobgzx8W
 9lDeZv+XK3Ou7behaM4ItU162rEJHJhxpMreUPbMVD+PbVYGu+puli7mNb+qpuMF49pn
 Xiik3RdOdttU9LKOaEkNvyherf8am+d3BoI3w2G8QWC1uXFv7WXEssCCSTAIsB6v+1mL
 CkPQHI5hZoNPaX/MrAyWcGRJipNfbnO7yjMn5ku4USZEBFbitbC/BaxkMSRrVDL1f34Q
 wnww==
X-Gm-Message-State: AOAM533pRHttoGFfrefj/X2bh8Up/nNrbbstM6tQmDSsC6hNbBccWcH9
 5Jxzcw7Occ28VsGDw2VeUDiAlXeNvZCZ
X-Google-Smtp-Source: ABdhPJz1HRxoNjlTPN8DCRxemAmpO2xBrpbuwc4Ilre0r+HavoICTfHyr3oE++Ha1NtttFFC4eFN6A==
X-Received: by 2002:a5d:6da1:0:b0:20c:6969:b26a with SMTP id
 u1-20020a5d6da1000000b0020c6969b26amr10676565wrs.103.1652620094971; 
 Sun, 15 May 2022 06:08:14 -0700 (PDT)
Received: from localhost (50.red-81-44-142.dynamicip.rima-tde.net.
 [81.44.142.50]) by smtp.gmail.com with ESMTPSA id
 k20-20020adfb354000000b0020d0459b4besm2029548wrd.13.2022.05.15.06.08.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 15 May 2022 06:08:14 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sun, 15 May 2022 15:08:12 +0200
Message-Id: <20220515130812.189374-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH] multipath-tools: add ETERNUS AB/HB (relabeled
 NetApp E-Series) NVMe to hardware table
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Info from (page 88):
https://sp.ts.fujitsu.com/dmsp/Publications/public/a3ca08733-a105-EN.pdf

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
index 47ea5d3d..39daadc2 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -477,6 +477,15 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
 	},
+	{
+		/* ETERNUS AB/HB NVMe */
+		.vendor        = "NVME",
+		.product       = "Fujitsu ETERNUS AB/HB Series",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.prio_name     = PRIO_ANA,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.no_path_retry = 30,
+	},
 	/*
 	 * Hitachi Vantara
 	 *
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

