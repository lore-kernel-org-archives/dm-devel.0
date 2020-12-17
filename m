Return-Path: <SRS0=NZHG=FV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F24DC4361B
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 15:50:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 96CAE23975
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 15:50:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96CAE23975
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-gupp_p3cOcKSAOu8qfxuSw-1; Thu, 17 Dec 2020 10:49:58 -0500
X-MC-Unique: gupp_p3cOcKSAOu8qfxuSw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08FB8800D55;
	Thu, 17 Dec 2020 15:49:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 061D85D9CD;
	Thu, 17 Dec 2020 15:49:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8D98E180954D;
	Thu, 17 Dec 2020 15:49:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BHFnkY2028974 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Dec 2020 10:49:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A8874D7DE9; Thu, 17 Dec 2020 15:49:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A37A8DAF10
	for <dm-devel@redhat.com>; Thu, 17 Dec 2020 15:49:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F56880018D
	for <dm-devel@redhat.com>; Thu, 17 Dec 2020 15:49:44 +0000 (UTC)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
	[209.85.128.47]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-593-oz01hxrCPiWGaZ0s0Aa8TQ-1; Thu, 17 Dec 2020 10:49:42 -0500
X-MC-Unique: oz01hxrCPiWGaZ0s0Aa8TQ-1
Received: by mail-wm1-f47.google.com with SMTP id 3so6125452wmg.4;
	Thu, 17 Dec 2020 07:49:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=WwiG8sT4gYP/pFWE3HgqLTET1LL59iVl6KjYx9ByiMc=;
	b=fYpQhSbgSFdmbrTvEDv/Ol+dcqia2dneeiflAUmqQoo1kiqrjXL/i8fgqli/BBHSLZ
	CMjbzAvpDPqxc4MbR4xi41pAc7SsAKuaRFcqfqnRf0xS2GCnpgV61hs0prrz0NhWC6ri
	uDY0JihvSO6ZpCUEbwN9NS2/nWJ8wZ8iiXLNTgKRBcdl9hZyaVsCajEmBBMEJKsGzsfc
	CHVH7unkXyqVuL6M3bNDiiGkbjHHyi82fyqfcZQQzM/CDHdEfSQn0ENQH2Ep4wxUaU9u
	VVc0byLjEhEBSYMLClKb1ZoHZRUAp6bMXdLBhVwUmQO16i4g2zMRCi1cNxupDiX9eJ13
	5TVw==
X-Gm-Message-State: AOAM530uaLQ65PAwI9nnle3DJ4KF58NNLsW7aQMr/cw5c0M6jqQVZ/sG
	Ks+H7S4L6AknZzzKcFrifA==
X-Google-Smtp-Source: ABdhPJywqkPKQWlF7Tt0cbypFt0hPlMy0hCpdH7030E9I79S9NG5kvCrFH68UZhnurstPaSllcS0vA==
X-Received: by 2002:a1c:e90b:: with SMTP id q11mr9373307wmc.102.1608220181108; 
	Thu, 17 Dec 2020 07:49:41 -0800 (PST)
Received: from localhost (10.red-176-87-2.dynamicip.rima-tde.net.
	[176.87.2.10])
	by smtp.gmail.com with ESMTPSA id f7sm14791822wmc.1.2020.12.17.07.49.40
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 17 Dec 2020 07:49:40 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu, 17 Dec 2020 16:49:38 +0100
Message-Id: <20201217154938.14013-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
	DM-DEVEL ML <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH] multipath-tools: replace hidden tab by space in
	hwtable
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index a54cc0a3..921aadc5 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -819,7 +819,7 @@ static struct hwentry default_hw[] = {
 		 *
 		 * The hwtable is searched backwards, so place this after "Generic NVMe"
 		 */
-		.vendor	       = "NVME",
+		.vendor        = "NVME",
 		.product       = "^NetApp ONTAP Controller",
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

