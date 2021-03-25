Return-Path: <SRS0=/8Bn=IX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74563C433DB
	for <dm-devel@archiver.kernel.org>; Thu, 25 Mar 2021 23:01:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E276B619BA
	for <dm-devel@archiver.kernel.org>; Thu, 25 Mar 2021 23:01:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E276B619BA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-GMGxfvV9NBa3Lv2s-xG8bw-1; Thu, 25 Mar 2021 19:01:05 -0400
X-MC-Unique: GMGxfvV9NBa3Lv2s-xG8bw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95CB010AF381;
	Thu, 25 Mar 2021 23:01:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F3B2F5D756;
	Thu, 25 Mar 2021 23:01:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 60E3A1809C84;
	Thu, 25 Mar 2021 23:01:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12PN0wOv008542 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 25 Mar 2021 19:00:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 315E72026D48; Thu, 25 Mar 2021 23:00:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C5A92026D65
	for <dm-devel@redhat.com>; Thu, 25 Mar 2021 23:00:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F28A185A7BA
	for <dm-devel@redhat.com>; Thu, 25 Mar 2021 23:00:55 +0000 (UTC)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com
	[209.85.128.48]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-564-5CDd3-hZP6iTVy8MzY9ZJg-1; Thu, 25 Mar 2021 19:00:53 -0400
X-MC-Unique: 5CDd3-hZP6iTVy8MzY9ZJg-1
Received: by mail-wm1-f48.google.com with SMTP id
	n11-20020a05600c4f8bb029010e5cf86347so5123900wmq.1; 
	Thu, 25 Mar 2021 16:00:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=SaOTri6EE+ztvMFugOCAz3mRHz5dI/dIEMsBPTsB8EU=;
	b=XB46dS+PQqwV/bjKduyi+HFgSLkexqJSieuwda0jRusZuHDQSG1kwj7E4r41pDfOdo
	3DQ66g3I0tojgfyikMjQXP8mRqFV96SCavMEGKtuvhkZVp/TiyT22iABVLLfwwuorKUF
	3lhspE07XSoAIzt7eQzWYvqhuKv1J5qcoJMs/xGdkzUYgHo2n9V5VXQVY1FkxxMMkLIm
	v0UoexMrM2EF1hMMGnoFNkfceI2qT19L4AIQTcp3OoBO9T8CpFYxKk1TNxCsX2A1C5XR
	mpDr1ck3RJW1hm08RDu/HrBllOyyYpSIorZ0Ox9QddT87E3ehqHhqLmZ1d0YDjr3Eqv8
	GkMQ==
X-Gm-Message-State: AOAM530kGLdbL2HMqf/h4oDSZoqGLKv25c0HTianK29k3LT+rTARmMkf
	xgly6clzOZqoPXOpRt2+4sMdYbiQQQ==
X-Google-Smtp-Source: ABdhPJxGAJ4kGNcLIVKsZfno3vvG+BhctC6LyMoO8khyyAKq4KwOz7Q1sqIRsJU37jPauwl8FcK6rA==
X-Received: by 2002:a1c:22c2:: with SMTP id i185mr10077359wmi.99.1616713252045;
	Thu, 25 Mar 2021 16:00:52 -0700 (PDT)
Received: from localhost (220.red-83-38-250.dynamicip.rima-tde.net.
	[83.38.250.220])
	by smtp.gmail.com with ESMTPSA id l1sm8103147wrv.87.2021.03.25.16.00.51
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 25 Mar 2021 16:00:51 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Fri, 26 Mar 2021 00:00:50 +0100
Message-Id: <20210325230050.6732-1-xose.vazquez@gmail.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Zou Ming <zouming.zouming@huawei.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	DM-DEVEL ML <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH] multipath-tools: add NVME/Huawei-XSG1 to hwtable
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Info from: https://download.huawei.com/edownload/e/download.do?actionFlag=download&nid=EDOC1100154490&partNo=6001&mid=SUPE_DOC&_t=1612885603000

Cc: Zou Ming <zouming.zouming@huawei.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
---
 libmultipath/hwtable.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 58fa7387..7923abba 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1084,6 +1084,15 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.prio_name     = PRIO_ALUA,
 	},
+	{
+		/* OceanStor NVMe */
+		.vendor        = "NVME",
+		.product       = "Huawei-XSG1",
+		.pgpolicy      = MULTIBUS,
+		.checker_name  = DIRECTIO,
+		.retain_hwhandler = RETAIN_HWHANDLER_OFF,
+		.no_path_retry = 12,
+	},
 	/*
 	 * Kove
 	 */
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

