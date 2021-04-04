Return-Path: <SRS0=M4qM=JB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17FE1C433ED
	for <dm-devel@archiver.kernel.org>; Sun,  4 Apr 2021 22:13:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5CB6561389
	for <dm-devel@archiver.kernel.org>; Sun,  4 Apr 2021 22:13:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5CB6561389
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-P8UCK2F2NgeynPPjIXstPw-1; Sun, 04 Apr 2021 18:13:24 -0400
X-MC-Unique: P8UCK2F2NgeynPPjIXstPw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FFDD1853021;
	Sun,  4 Apr 2021 22:13:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 978946A051;
	Sun,  4 Apr 2021 22:13:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7BFFA1809C83;
	Sun,  4 Apr 2021 22:13:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 134MD6Ql018589 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 4 Apr 2021 18:13:06 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A1A132ED96; Sun,  4 Apr 2021 22:13:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9BBC32ED95
	for <dm-devel@redhat.com>; Sun,  4 Apr 2021 22:13:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0957B101A52C
	for <dm-devel@redhat.com>; Sun,  4 Apr 2021 22:13:04 +0000 (UTC)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com
	[209.85.221.43]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-485-VkdCP9U-OX-UZogWq_QDZQ-1; Sun, 04 Apr 2021 18:13:02 -0400
X-MC-Unique: VkdCP9U-OX-UZogWq_QDZQ-1
Received: by mail-wr1-f43.google.com with SMTP id j18so9373294wra.2;
	Sun, 04 Apr 2021 15:13:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=5dQScrPyuB7UgwX+NWXpt4iarzHi9umcFnrzZ4D7Tic=;
	b=aCLX9pd6VIrDpH4RbhnEGLCjIh33WGNPb7FuloWF7KbWulRVmm1pH1VR8pWc+/49++
	cTs8NT+PmaUS5OV3XAJb563Bq1SHKw8c3uSirKDw+G2PntTDeh4OhkRWKBzXUzy38a26
	5vZMSgV0r03XxuimQwG+mUxXuoHimDvwqJRWs1Tn59QHl5Q45n0r+EE4VEX4vTi68Wu4
	RurabmfNtEO+dBD6YUB/8S/oRXprTRFDa73K15k8zpblfUFkGP0HsNESXEW0JAV9MHi9
	UdZJ7hPC93xyfEFa/Cqb8OTOQqi44+spVUTND/EYk0ouAHaGWLUJ6+Zy5Kmlh3bYfv1z
	S/Jw==
X-Gm-Message-State: AOAM532H50VTfN89UgYD/wRDIQfGq+B7sxrTc4nApfNgEFnUHb/PjAty
	3IPKeQi7l87n5jLAaGHhWQ==
X-Google-Smtp-Source: ABdhPJzTZi1hfOn95J51nLTPCXO6GgHUuryi9VfJl8KA0ObXZy34dXty5o7OVH2REQq1Mvr4vUVuJA==
X-Received: by 2002:adf:e54a:: with SMTP id z10mr25993408wrm.87.1617574380724; 
	Sun, 04 Apr 2021 15:13:00 -0700 (PDT)
Received: from localhost ([84.39.179.33]) by smtp.gmail.com with ESMTPSA id
	i17sm25785397wrp.77.2021.04.04.15.12.59
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Sun, 04 Apr 2021 15:13:00 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Mon,  5 Apr 2021 00:12:58 +0200
Message-Id: <20210404221258.18767-1-xose.vazquez@gmail.com>
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
Cc: Zou Ming <zouming.zouming@huawei.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	DM-DEVEL ML <dm-devel@redhat.com>, Zhouweigang <zhouweigang09@huawei.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH] multipath-tools: make HUAWEI/XSG1 config work
	with alua and multibus
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

And add recommended no_path_retry and pgfailback values.

Info from:
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

Suggested-by: Martin Wilck <mwilck@suse.com>
Cc: Zhouweigang (Jack) <zhouweigang09@huawei.com>
Cc: Zou Ming <zouming.zouming@huawei.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 58fa7387..9c7212be 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1078,11 +1078,14 @@ static struct hwentry default_hw[] = {
 	 * Huawei
 	 */
 	{
-		/* OceanStor V3 */
+		/* OceanStor V3-V6 */
+		// This config works with multibus and ALUA
+		// ALUA is required by HyperMetro
 		.vendor        = "HUAWEI",
 		.product       = "XSG1",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.prio_name     = PRIO_ALUA,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.no_path_retry = 15,
 	},
 	/*
 	 * Kove
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

