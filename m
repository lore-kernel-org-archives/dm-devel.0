Return-Path: <SRS0=D7/d=OS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5447AC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 28 Sep 2021 20:16:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CA62C6128C
	for <dm-devel@archiver.kernel.org>; Tue, 28 Sep 2021 20:16:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CA62C6128C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-523-Ei5GXH_KP0a4vl-MUlBpGQ-1; Tue, 28 Sep 2021 16:16:22 -0400
X-MC-Unique: Ei5GXH_KP0a4vl-MUlBpGQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BACFA1006AA2;
	Tue, 28 Sep 2021 20:16:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F0A4860877;
	Tue, 28 Sep 2021 20:16:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D85281800B9E;
	Tue, 28 Sep 2021 20:16:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18SKGCDQ007347 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 28 Sep 2021 16:16:12 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A5DF7114249B; Tue, 28 Sep 2021 20:16:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F4BD1142496
	for <dm-devel@redhat.com>; Tue, 28 Sep 2021 20:16:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72CD8811E7A
	for <dm-devel@redhat.com>; Tue, 28 Sep 2021 20:16:01 +0000 (UTC)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com
	[209.85.221.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-587-zxL7t0EkNN62u8NNxGhWaQ-1; Tue, 28 Sep 2021 16:15:59 -0400
X-MC-Unique: zxL7t0EkNN62u8NNxGhWaQ-1
Received: by mail-wr1-f46.google.com with SMTP id s21so415256wra.7;
	Tue, 28 Sep 2021 13:15:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=yj25AEH6+0qFEDOFYA6qoD1sKL51fQ26dtMIOdUHAQ8=;
	b=qVBlW7am/6WwZ6kwFprv9bmnm0hkzqYg7FfPUkHGrdct4l1S9hDNg31fS7gl2gHFWK
	o403ax2bd+lo/JFHcjDR0tneCRd5c5Dcx8wF7heKtUUQ89TcM6nSTZiOmfGEItDAomaK
	MFHeniffgRpjtqViqo08+yn1etV5Qg7yibyoxRUmZ4Lk/xuP2oIf528jfeJ2O9qzv6b9
	GPPp8/QmzDBJvsyODHFq0i/xtsBXywKhfUEYxJqYNKj/E0+I4AXN6ZmYmZk6jB0t4MEG
	egMQ2eWfTqAoh4eWWcoXKemLt3G3XpXxXmDFV/oujxQonMt6NMB3Qsh7LpN7s2L021+H
	SGuw==
X-Gm-Message-State: AOAM530R/qKmh8suEWwQCOUlgi+gumZGR2tFSU9QhGcWbmtr66aqrOFD
	mw/dSqFmrF1oLGWwzAFuSQ==
X-Google-Smtp-Source: ABdhPJxOnHTexr3ILyvd3XHdwnk6KR7Gy5PmSUPr/TbzUtX6TgMNRLwQIpJEP5pAg8LAryvNJ6SG3w==
X-Received: by 2002:a05:6000:1561:: with SMTP id
	1mr2337087wrz.369.1632860158157; 
	Tue, 28 Sep 2021 13:15:58 -0700 (PDT)
Received: from localhost ([90.160.137.52]) by smtp.gmail.com with ESMTPSA id
	189sm4275073wmz.27.2021.09.28.13.15.57
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 28 Sep 2021 13:15:57 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Tue, 28 Sep 2021 22:15:56 +0200
Message-Id: <20210928201556.24100-1-xose.vazquez@gmail.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Sean McGinnis <sean_mcginnis@dell.com>, DM-DEVEL ML <dm-devel@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH] multipath-tools: make "COMPELNT/Compellent Vol"
	config work with alua and multibus
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

ALUA is needed by SAS arrays, pag#124:
https://downloads.dell.com/manuals/all-products/esuprt_solutions_int/esuprt_solutions_int_solutions_resources/general-solution-resources_white-papers2_en-us.pdf

Cc: Sean McGinnis <sean_mcginnis@dell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 4e8b52ff..7fc5bc04 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -368,7 +368,8 @@ static struct hwentry default_hw[] = {
 		 */
 		.vendor        = "COMPELNT",
 		.product       = "Compellent Vol",
-		.pgpolicy      = MULTIBUS,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 	},
 	{
-- 
2.32.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

