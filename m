Return-Path: <SRS0=/efG=IB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D93C433E0
	for <dm-devel@archiver.kernel.org>; Wed,  3 Mar 2021 23:28:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 61B1D64F1A
	for <dm-devel@archiver.kernel.org>; Wed,  3 Mar 2021 23:28:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 61B1D64F1A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-REuv2HiMMFy-O2jIEz0X4Q-1; Wed, 03 Mar 2021 18:28:45 -0500
X-MC-Unique: REuv2HiMMFy-O2jIEz0X4Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81F53107ACC7;
	Wed,  3 Mar 2021 23:28:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 15FF55D748;
	Wed,  3 Mar 2021 23:28:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DF51818095CB;
	Wed,  3 Mar 2021 23:28:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 123NSULk002397 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Mar 2021 18:28:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8E7842026D39; Wed,  3 Mar 2021 23:28:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 87A942026D3B
	for <dm-devel@redhat.com>; Wed,  3 Mar 2021 23:28:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C06F18E4AA3
	for <dm-devel@redhat.com>; Wed,  3 Mar 2021 23:28:27 +0000 (UTC)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com
	[209.85.128.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-545-x5P2lehgPGSZg_M8OWsdKQ-1; Wed, 03 Mar 2021 18:28:23 -0500
X-MC-Unique: x5P2lehgPGSZg_M8OWsdKQ-1
Received: by mail-wm1-f46.google.com with SMTP id n22so6482888wmc.2;
	Wed, 03 Mar 2021 15:28:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=EMqJMmYiEVEXNS2b1oROnyf8+95Yo4Q4nlxPWCnHdQM=;
	b=QPoSC9k45rqOItA1YYIVBicHg+uAv59GXkqjv0CslutboNQX2kjr6GYYmPws1J+2qw
	+rUkNcwKqC8/lYm/k6m+GEu8hfWJJX/HGSjoRjAuwaRcudA1H+M4lOfYs4wNnME5DdRk
	kr7rTawaxHQViHSYuhQeAtEVeAY2pvagGqOXrhZNKi2SM+/AYz6+MLE81ievSj6f4ddB
	nyihTU1WWbXCbBvMy0bWzlePnBBVYaroiUq+R2tCndl2Qu9m/mFH4k5yGBmepJgKyQWA
	k2bRVuJF1zoaDXKZblHiU2OOR36dvMmQP7V89HzeIm6+0KRRR5itjMabBnraz//gcJHb
	FEDg==
X-Gm-Message-State: AOAM532Syu0ky3qn38IAssMMe2K6bSVhA0Z4wtkDp6EXpxOx3w0syZ+M
	ChZt2jSKCHOz8/oLZmIcOg==
X-Google-Smtp-Source: ABdhPJzB2Q/egO+56RseFc1nLtH8rEZEn/0EVyqahBi4naGqNTVR7luL7eMak08dxImbP1YplF4gnA==
X-Received: by 2002:a05:600c:2145:: with SMTP id
	v5mr1077633wml.65.1614814102136; 
	Wed, 03 Mar 2021 15:28:22 -0800 (PST)
Received: from localhost (96.red-83-37-104.dynamicip.rima-tde.net.
	[83.37.104.96]) by smtp.gmail.com with ESMTPSA id
	u142sm7401041wmu.3.2021.03.03.15.28.21
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 03 Mar 2021 15:28:21 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu,  4 Mar 2021 00:28:20 +0100
Message-Id: <20210303232820.13319-1-xose.vazquez@gmail.com>
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
Subject: [dm-devel] [PATCH] multipath-tools: add DellEMC/PowerStore to
	hardware table
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

Info from: https://www.delltechnologies.com/en-us/collaterals/unauth/technical-guides-support-information/products/storage-2/docu5128.pdf

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 921aadc5..f5d26b04 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -388,6 +388,17 @@ static struct hwentry default_hw[] = {
 		.product       = "^EMC PowerMax_",
 		.pgpolicy      = MULTIBUS,
 	},
+	{
+		/* PowerStore */
+		.vendor        = "DellEMC",
+		.product       = "PowerStore",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.prio_name     = PRIO_ALUA,
+		.hwhandler     = "1 alua",
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.no_path_retry = 30,
+		.fast_io_fail  = 15,
+	},
 	/*
 	 * Fujitsu
 	 */
-- 
2.30.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

