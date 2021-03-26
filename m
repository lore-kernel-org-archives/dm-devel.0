Return-Path: <SRS0=sRxI=IY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9908DC433C1
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 03:11:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0F809619B4
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 03:11:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F809619B4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-594K7R_hN-aJPkUkMetRuA-1; Thu, 25 Mar 2021 23:11:50 -0400
X-MC-Unique: 594K7R_hN-aJPkUkMetRuA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8280E87A83A;
	Fri, 26 Mar 2021 03:11:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D6605D9D0;
	Fri, 26 Mar 2021 03:11:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C23454A7C8;
	Fri, 26 Mar 2021 03:11:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12Q38o5V000901 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 25 Mar 2021 23:08:50 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E880E2026D65; Fri, 26 Mar 2021 03:08:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E31192026D48
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 03:08:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 239AC185A7B2
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 03:08:47 +0000 (UTC)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
	[209.85.221.49]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-215-k9xtO6hrObSJ8vlDhBdvEA-1; Thu, 25 Mar 2021 23:08:42 -0400
X-MC-Unique: k9xtO6hrObSJ8vlDhBdvEA-1
Received: by mail-wr1-f49.google.com with SMTP id b9so4218267wrt.8;
	Thu, 25 Mar 2021 20:08:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=nt+o8B6KeY1tV0lTwjBjg5uc87TqpuJH42+CgG/O65w=;
	b=MQiUEANVjh9m4CghBXT6/FejnnnJo2xTWXYRlnAAn89d6txwhktfMp93BDpR+tky0K
	KnfBIRzgi4QV81zXS81uxwGpRkf6H8dP2C/lHGrB7OdEDiSbKG/ba+eACVwpYoVl3Ctm
	k7CpTFuwaZIFVy26OFXuiaqz0g88WLWGokwwV0vN6c95Y5GJ/eRvDJ314q3cl4TkL8Sl
	8C9hc44q3fH0nJ/JXwa5BVGu8HThpqxeTcDeK2XLOxxKFD2IfLY+kZKKiDyEiLSmu8zD
	XF9ssIiD05StRfUp8uEA9vQeNdpecPS6UEGTnpGcNaw53HyPdNs6tNIUwod/5v3EmV9K
	Jm/Q==
X-Gm-Message-State: AOAM533z0cMrLYtyOSNxI7aOWfhp13ckYXY5D9ZVTiwG/B+ASuT8ERp5
	CQbZe8ZVbMbO3iYbMDyDKd8ODZiC8wt0
X-Google-Smtp-Source: ABdhPJx15lSO/LYpnv+N/Wre2XnrASF7f0bizvSbdaj+kS4EZtBCk5ewzUXRhmse9AGqlT2Ua6V7IA==
X-Received: by 2002:adf:f143:: with SMTP id y3mr4050458wro.198.1616728121371; 
	Thu, 25 Mar 2021 20:08:41 -0700 (PDT)
Received: from localhost (220.red-83-38-250.dynamicip.rima-tde.net.
	[83.38.250.220]) by smtp.gmail.com with ESMTPSA id
	m9sm10170842wro.52.2021.03.25.20.08.40
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 25 Mar 2021 20:08:41 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Fri, 26 Mar 2021 04:08:39 +0100
Message-Id: <20210326030839.15452-1-xose.vazquez@gmail.com>
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
	DM-DEVEL ML <dm-devel@redhat.com>, Zhouweigang <zhouweigang09@huawei.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH] multipath-tools: convert back HUAWEI/XSG1 to
	multibus
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This reverts commit ad206af1716437e84bbd81de6c4da7961d9a41d2

Recommended configs are, info from:
- RHEL https://download.huawei.com/edownload/e/download.do?actionFlag=download&nid=EDOC1100113070&partNo=6001&mid=SUPE_DOC&_t=1612885511000
- SLES https://download.huawei.com/edownload/e/download.do?actionFlag=download&nid=EDOC1100117892&partNo=6001&mid=SUPE_DOC&_t=1612885538000

- without HyperMetro:
vendor "HUAWEI"
product "XSG1"
path_grouping_policy multibus
no_path_retry 15

- with HyperMetro:
vendor "HUAWEI"
product "XSG1"
path_grouping_policy group_by_prio
prio alua
failback immediate
no_path_retry 15

ALUA is only used with HyperMetro(cluster of two arrays).

Cc: Zhouweigang (Jack) <zhouweigang09@huawei.com>
Cc: Zou Ming <zouming.zouming@huawei.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 7923abba..cd8ed7ff 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1081,8 +1081,8 @@ static struct hwentry default_hw[] = {
 		/* OceanStor V3 */
 		.vendor        = "HUAWEI",
 		.product       = "XSG1",
-		.pgpolicy      = GROUP_BY_PRIO,
-		.prio_name     = PRIO_ALUA,
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = 15,
 	},
 	{
 		/* OceanStor NVMe */
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

