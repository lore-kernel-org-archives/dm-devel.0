Return-Path: <SRS0=0RA0=NS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A652FC432BE
	for <dm-devel@archiver.kernel.org>; Fri, 27 Aug 2021 22:19:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3AB5060FD8
	for <dm-devel@archiver.kernel.org>; Fri, 27 Aug 2021 22:19:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3AB5060FD8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-_XnB4Y4xOIav7df2qs1x2g-1; Fri, 27 Aug 2021 18:18:58 -0400
X-MC-Unique: _XnB4Y4xOIav7df2qs1x2g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90E721018F64;
	Fri, 27 Aug 2021 22:18:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D0B7604CC;
	Fri, 27 Aug 2021 22:18:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1EE16181A0F1;
	Fri, 27 Aug 2021 22:18:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17RMIniQ032631 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 27 Aug 2021 18:18:49 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 50EFA20C15C4; Fri, 27 Aug 2021 22:18:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B891200BCD8
	for <dm-devel@redhat.com>; Fri, 27 Aug 2021 22:18:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8BA32800963
	for <dm-devel@redhat.com>; Fri, 27 Aug 2021 22:18:46 +0000 (UTC)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com
	[209.85.128.41]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-291-yGGPbUhWP2-TNFdjNiln8Q-1; Fri, 27 Aug 2021 18:18:42 -0400
X-MC-Unique: yGGPbUhWP2-TNFdjNiln8Q-1
Received: by mail-wm1-f41.google.com with SMTP id i3so4737523wmq.3;
	Fri, 27 Aug 2021 15:18:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=02DTXAXuJsQR96OKrBYKMqiX/rH7fkidlyuw3/3f9rw=;
	b=ed6QI9JBS1ruM5cprIOp/3wpwTJov4h3xPQ23KK3u7Oet6u+UifK8V8Pug2Q5RCCtm
	LgsqozXqvr+JUItjfCRsfZ3M3/3OH78qpeaY+04Cn4LWyq+wdGoQ6/2zK+O4nkUXaY4K
	C2rXtU/ypcPnUV547kC8OMDn4xkXVV1H6+EB+W17d44Hitcj2iDJWMmJI0zlbWpBXFD1
	czrw73t9EGHSwPDH1GmnMAg2pok7j3inN6dAm+x1YXVK204gQygmOP/k+7rrk+6zroQG
	WoLf6ih1iwIOHt0gKvLenYWE0YobFwIa8AYf2ZkInY2n0EC4pclONILvXQA9FlxmxhBS
	TXlw==
X-Gm-Message-State: AOAM531v5jJ+vnbgD46TgoS/nRNbsvZMreBcnaZ68HtH7Opi2TA14ixa
	KEDgBNLWsus22UMZOBsbd0LbGsPIcA==
X-Google-Smtp-Source: ABdhPJx6Imu+3ebf7h0QGG4kJgohWbIjZzFvOzRgnxEgD7DNox1vaiWbH/Zcr5jDtqLT51LvQ/SLAA==
X-Received: by 2002:a05:600c:a08:: with SMTP id
	z8mr10789956wmp.52.1630102721046; 
	Fri, 27 Aug 2021 15:18:41 -0700 (PDT)
Received: from localhost (6.red-83-38-166.dynamicip.rima-tde.net.
	[83.38.166.6]) by smtp.gmail.com with ESMTPSA id
	n20sm5775020wms.15.2021.08.27.15.18.40
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 27 Aug 2021 15:18:40 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sat, 28 Aug 2021 00:18:39 +0200
Message-Id: <20210827221839.4138-1-xose.vazquez@gmail.com>
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
Subject: [dm-devel] [PATCH] multipath-tools: identify more arrays under
	IBM/2145 ID
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

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 2a896440..0caac0da 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -659,7 +659,8 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 	},
 	{
-		/* Storwize family / SAN Volume Controller / Flex System V7000 / FlashSystem V840/V9000/9100 */
+		// Storwize V5000 and V7000 lines / SAN Volume Controller (SVC) / Flex System V7000 /
+		// FlashSystem V840/V9000/5000/5100/5200/7200/9100/9200/9200R
 		.vendor        = "IBM",
 		.product       = "^2145",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-- 
2.32.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

