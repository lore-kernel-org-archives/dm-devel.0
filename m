Return-Path: <SRS0=IV6L=OF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB2F6C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 15 Sep 2021 23:49:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1C4E9603E9
	for <dm-devel@archiver.kernel.org>; Wed, 15 Sep 2021 23:49:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1C4E9603E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-pS-29V41M9K0gHCgYd624Q-1; Wed, 15 Sep 2021 19:49:11 -0400
X-MC-Unique: pS-29V41M9K0gHCgYd624Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3BDDF835DE1;
	Wed, 15 Sep 2021 23:49:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 24DFD60583;
	Wed, 15 Sep 2021 23:49:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E803F4E9F5;
	Wed, 15 Sep 2021 23:49:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18FNfFiU014303 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 15 Sep 2021 19:41:15 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2AFA02034604; Wed, 15 Sep 2021 23:41:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 25F932034602
	for <dm-devel@redhat.com>; Wed, 15 Sep 2021 23:41:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78736800C00
	for <dm-devel@redhat.com>; Wed, 15 Sep 2021 23:41:12 +0000 (UTC)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com
	[209.85.221.54]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-69-bKRaZyKPMEKh0gjn2QKfFA-1; Wed, 15 Sep 2021 19:41:08 -0400
X-MC-Unique: bKRaZyKPMEKh0gjn2QKfFA-1
Received: by mail-wr1-f54.google.com with SMTP id i23so6484535wrb.2;
	Wed, 15 Sep 2021 16:41:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=hL3G7Av2Dd+ORakwyHhJxy8r0ohb/LbFDlVbH6frSAM=;
	b=ZCLSSDIKUuOI6NQRwHhIYUDy1WWg+YsFlN7ftQ4ipFoLLHT4r4Qp3j3XY9oXGBDRmI
	als0kqmnIhgFQPjUxX2U2A2utT2dPRxkPdZjyVLUDkeMh8H5ILIfANiMLTf5reL3MTKC
	Fy6UadGOJb9KGd3LliqTBNEyKbkrrDp4LQIvOUTCj8vwq/ZAnmbEZ3NTiV2hMWTn8oRV
	qGRJpSRgH2rHLq8vfeoX0FqoebK3qhQhuz2i/Qef5NneEWpp8VesbU+aaXx7GvySRv86
	oMGq8m0UlnPcPnzk2PDz5UmnKLNnpZZWPMOT0ms0wvHKEZc/wcelF9Sbcq6T5lRAntBR
	piVw==
X-Gm-Message-State: AOAM533EcfahP9BoWcFoRsMrwzS4dPS577+6h489WzGJGDreprlvPeyA
	8aXFxMlrP3AwmG/5ju222JB0AGY91w==
X-Google-Smtp-Source: ABdhPJzEgIjNgliP0L2RoM5+pLHL5PuGzp+agj4zkOSGhd8/7ocKIbdZap5t2vMrOseBfVAHw8n9/Q==
X-Received: by 2002:adf:80eb:: with SMTP id 98mr2678651wrl.348.1631749267179; 
	Wed, 15 Sep 2021 16:41:07 -0700 (PDT)
Received: from localhost (227.red-83-37-137.dynamicip.rima-tde.net.
	[83.37.137.227])
	by smtp.gmail.com with ESMTPSA id d7sm1413717wrf.3.2021.09.15.16.41.06
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 15 Sep 2021 16:41:06 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu, 16 Sep 2021 01:41:05 +0200
Message-Id: <20210915234105.17955-1-xose.vazquez@gmail.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
	DM-DEVEL ML <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH] multipath-tools: fix emc info from
	multipath.conf.5
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add PNR info and remove "Unity" from emc prio, path_checker and hardware_handler.
Unity series does not support PNR mode, just ALUA.
113 and 153: https://www.delltechnologies.com/asset/en-us/products/storage/technical-support/docu5128.pdf

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index c74129bd..eb48ceda 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -314,7 +314,7 @@ generate the path priority. This prioritizer accepts the optional prio_arg
 .I emc
 (Hardware-dependent)
 Generate the path priority for DGC class arrays as CLARiiON CX/AX and
-EMC VNX and Unity families.
+EMC VNX families with Failover Mode 1 - Passive Not Ready(PNR).
 .TP
 .I alua
 (Hardware-dependent)
@@ -494,7 +494,7 @@ Issue a \fITEST UNIT READY\fR command to the device.
 .I emc_clariion
 (Hardware-dependent)
 Query the DGC/EMC specific EVPD page 0xC0 to determine the path state
-for CLARiiON CX/AX and EMC VNX and Unity arrays families.
+for CLARiiON CX/AX and EMC VNX families with Failover Mode 1 - Passive Not Ready(PNR).
 .TP
 .I hp_sw
 (Hardware-dependent)
@@ -1553,8 +1553,8 @@ The following hardware handler are implemented:
 .TP 12
 .I 1 emc
 (Hardware-dependent)
-Hardware handler for DGC class arrays as CLARiiON CX/AX and EMC VNX and Unity
-families.
+Hardware handler for DGC class arrays as CLARiiON CX/AX and EMC VNX families
+with Failover Mode 1 - Passive Not Ready(PNR).
 .TP
 .I 1 rdac
 (Hardware-dependent)
-- 
2.32.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

