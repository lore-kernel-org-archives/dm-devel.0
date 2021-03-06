Return-Path: <SRS0=EI4u=IE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48CB0C433DB
	for <dm-devel@archiver.kernel.org>; Sat,  6 Mar 2021 15:40:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CAD4365000
	for <dm-devel@archiver.kernel.org>; Sat,  6 Mar 2021 15:40:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CAD4365000
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-3nx-GlknO-SuJyV_uBDqUA-1; Sat, 06 Mar 2021 10:40:18 -0500
X-MC-Unique: 3nx-GlknO-SuJyV_uBDqUA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E48A1005D45;
	Sat,  6 Mar 2021 15:40:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 389FA19C47;
	Sat,  6 Mar 2021 15:40:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 78B7A1809C86;
	Sat,  6 Mar 2021 15:40:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 126Fe9wX020074 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 6 Mar 2021 10:40:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 41A25200E26F; Sat,  6 Mar 2021 15:40:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 39FC1200E27F
	for <dm-devel@redhat.com>; Sat,  6 Mar 2021 15:40:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA3A98219B9
	for <dm-devel@redhat.com>; Sat,  6 Mar 2021 15:40:06 +0000 (UTC)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com
	[209.85.128.52]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-230-PoLnzvG6OwG56iyLlYNkDg-1; Sat, 06 Mar 2021 10:40:02 -0500
X-MC-Unique: PoLnzvG6OwG56iyLlYNkDg-1
Received: by mail-wm1-f52.google.com with SMTP id
	y124-20020a1c32820000b029010c93864955so1144406wmy.5; 
	Sat, 06 Mar 2021 07:40:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=Z2lg4PSemDrUOgT4gmFgjfGnsrPNQsuN0t7OiyhozkY=;
	b=FW7uZRDoPAyiY0e4OX9QfwuxfExKmh93uAksrUq0l5RrhloLDCy0RjmzsyWiyso56a
	/JZnPyQ+FDkepMdOdVDHHKu8gdsTYzP8d7zmHTBbNBBQop/HtPASNoet1MEki1uCfMaD
	Zwesf4qp11Wb/upmntjr62CsJzckV1Zv+5kiR24ab3Hy/48w1QiWZbn1jd/AnJmr153E
	rrdG5LMEOXPwOxVAA2ya3xZHlIMcyBGUprXZn16E4dcnWpYovnEQTPT8lGl99Ipe7bEn
	LUyKRnf4cA2np6X2fXcspyUw4dv+pEDGx6iZ8eMdXugcMg7lLT9VnRPyfzptauszi8Zj
	Ai/Q==
X-Gm-Message-State: AOAM531Ie4pNdjXO6n7ilFTEax43aBiA/LDUs2IflrBOs9bP2AXeBbq2
	DRCURTSD1kiEq4Tuy2mAHj6wwRJwlQ==
X-Google-Smtp-Source: ABdhPJxkpqNL+ORSqOaxTx/hPQhjX0e702KVlmf27HOeAolnl/TZGdvpPhFbngh5EWJO0RXoNJfeOw==
X-Received: by 2002:a05:600c:20d3:: with SMTP id
	y19mr14233015wmm.146.1615045201239; 
	Sat, 06 Mar 2021 07:40:01 -0800 (PST)
Received: from localhost (215.red-81-43-178.staticip.rima-tde.net.
	[81.43.178.215]) by smtp.gmail.com with ESMTPSA id
	t188sm5829388wma.25.2021.03.06.07.40.00
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Sat, 06 Mar 2021 07:40:00 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sat,  6 Mar 2021 16:39:59 +0100
Message-Id: <20210306153959.38698-1-xose.vazquez@gmail.com>
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
Subject: [dm-devel] [PATCH] multipath-tools: delete a space in
	multipath.conf.5 to be consistent
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

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 21963813..c9c67f13 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1095,7 +1095,7 @@ for the configured time, and is declared healthy, it will be returned to its
 normal pathgroup. See "Shaky paths detection" below for more information.
 .RS
 .TP
-The default  is: \fBno\fR
+The default is: \fBno\fR
 .RE
 .
 .
-- 
2.30.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

