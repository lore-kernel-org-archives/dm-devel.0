Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F8DAC433FE
	for <dm-devel@archiver.kernel.org>; Sat, 14 May 2022 23:02:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-RMwyJNqsN92MbQ_cZt-yeA-1; Sat, 14 May 2022 19:02:12 -0400
X-MC-Unique: RMwyJNqsN92MbQ_cZt-yeA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4922C80088A;
	Sat, 14 May 2022 23:02:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 38406434820;
	Sat, 14 May 2022 23:02:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 12BC3194704E;
	Sat, 14 May 2022 23:02:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 17E78194F4BF
 for <dm-devel@listman.corp.redhat.com>; Sat, 14 May 2022 23:02:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 07DEC15063FC; Sat, 14 May 2022 23:02:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C6C0115063E7
 for <dm-devel@redhat.com>; Sat, 14 May 2022 23:02:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD3D5101AA52
 for <dm-devel@redhat.com>; Sat, 14 May 2022 23:02:08 +0000 (UTC)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
 [209.85.221.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-504-woXXtVwMO-ypIMnGEbpPNQ-1; Sat, 14 May 2022 19:02:04 -0400
X-MC-Unique: woXXtVwMO-ypIMnGEbpPNQ-1
Received: by mail-wr1-f47.google.com with SMTP id u3so15965891wrg.3;
 Sat, 14 May 2022 16:02:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=G+qdfan40+GbHhDMkz2ecKLnSU3wMGKVFRP+RaEC9ig=;
 b=KoXifLfYdVMtgApv/OrYHKZtn8ZENjXsSpSbt/VeHs4gUmNs3uhCmAvQxoI2fZAOYP
 qufx5jbjcWkf6Cb3Ux7ZE5VJ2lXIW3/Iaw7bMyPCFJbJZCxhD/w1ePDn5AvCiPbhLa07
 70v3mgmvnM5Nd2zEbzpcrg59ByC9F1f9CSsdj8zlbK3uUsmXJEQPXqCl7dInQbHD2ODm
 GV2w/bwpMvx3981KYXB5cQrvCnmgFZBmpbg2ENhurGiQiFfeXTKhWTBMg7w3HXGUs4z4
 hbgnAgzFk3TP7LN/RQCE4wBKtYzHFd1qtAZ0/ScRXVDyGIWJD0IpCsvfQ4WaIEDlQh5O
 FStg==
X-Gm-Message-State: AOAM530LwT1FNg9YgwUKSMu3YMtuSyLiTaqQH7s8k4w67ihHb+AkdqJx
 mt9e3wb6sWFSayeV/vAaPQ==
X-Google-Smtp-Source: ABdhPJw4XB7bRlwBj9lenCooAVGMdYyW/G3txhPypeWgboHduDOUpm3XkQkOc6W2FW+LFOduhZSK5w==
X-Received: by 2002:a05:6000:1acd:b0:20c:726a:3840 with SMTP id
 i13-20020a0560001acd00b0020c726a3840mr8611457wry.507.1652569322965; 
 Sat, 14 May 2022 16:02:02 -0700 (PDT)
Received: from localhost (50.red-81-44-142.dynamicip.rima-tde.net.
 [81.44.142.50]) by smtp.gmail.com with ESMTPSA id
 y13-20020a7bc18d000000b003942a244ee4sm1109454wmi.41.2022.05.14.16.02.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 14 May 2022 16:02:02 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sun, 15 May 2022 01:01:44 +0200
Message-Id: <20220514230148.139675-6-xose.vazquez@gmail.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH 5/9] multipath-tools: add Huawei OceanStor NVMe
 to hardware table
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
Cc: Zou Ming <zouming.zouming@huawei.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>, DM-DEVEL ML <dm-devel@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Zhouweigang <zhouweigang09@huawei.com>, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Info from (config removed in latest edition):
https://download.huawei.com/edownload/e/download.do?actionFlag=download&nid=EDOC1100154490&partNo=6001&mid=SUPE_DOC&_t=1612885603000
Old version (page 61-62): https://drive.google.com/file/d/1c5RK4GXX7ofZBFxTtZ_IN1qHyIjw5eR1

Cc: Zhouweigang (Jack) <zhouweigang09@huawei.com>
Cc: Zou Ming <zouming.zouming@huawei.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 61a5aa16..e5adc2a3 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1106,6 +1106,14 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 15,
 	},
+	{
+		/* OceanStor NVMe */
+		.vendor        = "NVME",
+		.product       = "Huawei-XSG1",
+		.pgpolicy      = MULTIBUS,
+		.checker_name  = DIRECTIO,
+		.no_path_retry = 12,
+	},
 	/*
 	 * Kove
 	 */
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

