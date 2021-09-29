Return-Path: <SRS0=53Ra=OT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F903C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 29 Sep 2021 16:41:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 60FBF61262
	for <dm-devel@archiver.kernel.org>; Wed, 29 Sep 2021 16:41:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 60FBF61262
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-HW9ksWy8ND6GcpSLrBw8Tg-1; Wed, 29 Sep 2021 12:41:53 -0400
X-MC-Unique: HW9ksWy8ND6GcpSLrBw8Tg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D60F984A5E3;
	Wed, 29 Sep 2021 16:41:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A72A519D9D;
	Wed, 29 Sep 2021 16:41:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4B86B1800B9C;
	Wed, 29 Sep 2021 16:41:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18TGfl0H025102 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 29 Sep 2021 12:41:47 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1E68D207AD1E; Wed, 29 Sep 2021 16:41:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 18F60207AC55
	for <dm-devel@redhat.com>; Wed, 29 Sep 2021 16:41:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64F2D899EC0
	for <dm-devel@redhat.com>; Wed, 29 Sep 2021 16:41:44 +0000 (UTC)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com
	[209.85.221.54]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-338-7O0WNV3oP_avt6kOoOcDlg-1; Wed, 29 Sep 2021 12:41:40 -0400
X-MC-Unique: 7O0WNV3oP_avt6kOoOcDlg-1
Received: by mail-wr1-f54.google.com with SMTP id h15so3733991wrc.3;
	Wed, 29 Sep 2021 09:41:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=w43jTbHl9uCUvDF2lXcZnWe1N97J9j/hb0sSTXl0PTc=;
	b=G9mqZrjUF5t7oXs7eAUu9f5WHS3yFQPr58bB9biZVcTiKxX4yFxmvQ5gvJnlIT2iBI
	jjtK849sr+EpIQulaNjxLezxyhWFhQ/ozAO9e5m8FUdmy0bhryJ4q45dHsTlO0aszmWc
	JNTF3aWUfHXRt241KN7Ch4sA03tLci+j+KdIkGY7VdmlxopodyKn2fSYxQdR+Kyvp6do
	zaTEkTD2kTkmSKYnreb/OIG7tN2LLOEXUnjxozHgb10L/B3hpO+SUFy7X1/Bu/0KsUYq
	+r3XdofElA4kIMtPrMPDq7/IL2THS45CiRbBI3MOlwhPV7sumFmhjeU32DblFSUv8hpH
	UlOQ==
X-Gm-Message-State: AOAM5302cAB2doM5U4FFPgyyNqfLsqBbAy5mlzuDQrkwq+sr8pkyQvqE
	bXturjYqO2LhlBs33i102Q==
X-Google-Smtp-Source: ABdhPJxf91ocKkjZgbpC8AU6w+wlsz5mz+gOm6wXQ7vBSwYr9AY0X9HuNFkGk2Hxt3MyW37BAaHjug==
X-Received: by 2002:adf:e684:: with SMTP id r4mr1013577wrm.229.1632933698630; 
	Wed, 29 Sep 2021 09:41:38 -0700 (PDT)
Received: from localhost (67.red-83-32-34.dynamicip.rima-tde.net.
	[83.32.34.67]) by smtp.gmail.com with ESMTPSA id
	x21sm2175932wmc.14.2021.09.29.09.41.38
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 29 Sep 2021 09:41:38 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Wed, 29 Sep 2021 18:41:36 +0200
Message-Id: <20210929164136.10979-1-xose.vazquez@gmail.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
	DM-DEVEL ML <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH] multipath-tools: add DellEMC/ME4 (PowerVault
	ME4) to hardware table
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Info from: https://www.delltechnologies.com/asset/fr-fr/products/storage/industry-market/PowerVault_ME4_Series_and_Linux.pdf

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 763982cd..fc85283b 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -398,6 +398,15 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 3,
 		.fast_io_fail  = 15,
 	},
+	{
+		/* PowerVault ME4 */
+		.vendor        = "DellEMC",
+		.product       = "ME4",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.prio_name     = PRIO_ALUA,
+		.hwhandler     = "1 alua",
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+	},
 	/*
 	 * Fujitsu
 	 */
-- 
2.32.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

