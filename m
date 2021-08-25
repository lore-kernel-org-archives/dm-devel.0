Return-Path: <SRS0=7gQR=NQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64AA0C432BE
	for <dm-devel@archiver.kernel.org>; Wed, 25 Aug 2021 22:25:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D81AA6109E
	for <dm-devel@archiver.kernel.org>; Wed, 25 Aug 2021 22:25:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D81AA6109E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-Q07uXH4dPQ6UpDSTCMDQrA-1; Wed, 25 Aug 2021 18:25:33 -0400
X-MC-Unique: Q07uXH4dPQ6UpDSTCMDQrA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C18961008060;
	Wed, 25 Aug 2021 22:25:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3768560C04;
	Wed, 25 Aug 2021 22:25:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E23CD181A0F7;
	Wed, 25 Aug 2021 22:25:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17PMOVrf031315 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 25 Aug 2021 18:24:31 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2379CFA74A; Wed, 25 Aug 2021 22:24:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E56DFA74D
	for <dm-devel@redhat.com>; Wed, 25 Aug 2021 22:24:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1AC9188142B
	for <dm-devel@redhat.com>; Wed, 25 Aug 2021 22:24:27 +0000 (UTC)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com
	[209.85.221.43]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-164-6-Vz_dyTOpKX_uEIhHSkww-1; Wed, 25 Aug 2021 18:24:23 -0400
X-MC-Unique: 6-Vz_dyTOpKX_uEIhHSkww-1
Received: by mail-wr1-f43.google.com with SMTP id d26so1788595wrc.0;
	Wed, 25 Aug 2021 15:24:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=uuFrqEXs5GqGcqXprOBaRe4dDD39x24JGPw2qdVBEVg=;
	b=AkthJNEZgFLmBUXq7Ss30GraJYaYkdEOrrJZawF7jfzrEPaVZ82pLlX6fEbAeG4aMs
	wFxu3GTrly0TJFFX8LxSvjewHpkwxvd/M0xzdVD5uWax+yJjh6Q3ee3PfNaXQ84vkZfT
	y1WvL8FP7knXwCFqMs19Ejx1FSOvlo8Euv1QVkOIc6tOdm9m43obJtEeJQfmuMKNrUgJ
	LdAn1a6S45Cz9Gi5ak8qVCaCrjfkJrQR67G7esmAt7KyGGcnY43v8MemWiRbwsuUZM6j
	/FBfRUztpt48vopmHN5kS+3zGb3bbi+eRQSJlzx+TXng38HQ6IqtFnimuBe6Ntbd/W3+
	TnXA==
X-Gm-Message-State: AOAM530o/ONCe/6lKSp7HOV/oswx33x/wXAQF7kL0q2+g5NoSfAkqlH/
	Wou3z01AbM//MbaWUZkwRQ==
X-Google-Smtp-Source: ABdhPJzrUMxXEGkxizzz54P7jBr+6wHFaIjimQmaI2UOBBtpdm58D3tkN4mx5m1uBIEbdnWhUFMDgg==
X-Received: by 2002:adf:ce8d:: with SMTP id r13mr414648wrn.18.1629930261954;
	Wed, 25 Aug 2021 15:24:21 -0700 (PDT)
Received: from localhost (254.red-83-33-155.dynamicip.rima-tde.net.
	[83.33.155.254])
	by smtp.gmail.com with ESMTPSA id n1sm1106746wrp.49.2021.08.25.15.24.20
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 25 Aug 2021 15:24:21 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu, 26 Aug 2021 00:24:13 +0200
Message-Id: <20210825222413.2822-1-xose.vazquez@gmail.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
	DM-DEVEL ML <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH] multipath-tools: update no_path_retry value for
	IBM/2145
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Based on current configs: https://www.ibm.com/docs/en/flashsystem-9x00/8.4.x?topic=system-settings-linux-hosts

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 2a896440..58554cbb 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -662,7 +662,7 @@ static struct hwentry default_hw[] = {
 		/* Storwize family / SAN Volume Controller / Flex System V7000 / FlashSystem V840/V9000/9100 */
 		.vendor        = "IBM",
 		.product       = "^2145",
-		.no_path_retry = NO_PATH_RETRY_QUEUE,
+		.no_path_retry = 5,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.prio_name     = PRIO_ALUA,
-- 
2.32.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

