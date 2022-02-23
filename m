Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36000C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 23 Feb 2022 22:21:33 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-160-qlBt37HfNuaXDOGzHIQIBQ-1; Wed, 23 Feb 2022 17:21:28 -0500
X-MC-Unique: qlBt37HfNuaXDOGzHIQIBQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D2F51006AA6;
	Wed, 23 Feb 2022 22:21:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E601F705BB;
	Wed, 23 Feb 2022 22:21:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5FCB91809CB2;
	Wed, 23 Feb 2022 22:21:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21NMGu8d001042 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 23 Feb 2022 17:16:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A6B702026990; Wed, 23 Feb 2022 22:16:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A1DB3202660C
	for <dm-devel@redhat.com>; Wed, 23 Feb 2022 22:16:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B8321884983
	for <dm-devel@redhat.com>; Wed, 23 Feb 2022 22:16:53 +0000 (UTC)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com
	[209.85.128.52]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-610-1eIie73oPCiVgVlbhhqL-Q-1; Wed, 23 Feb 2022 17:16:51 -0500
X-MC-Unique: 1eIie73oPCiVgVlbhhqL-Q-1
Received: by mail-wm1-f52.google.com with SMTP id
	n25-20020a05600c3b9900b00380f41e51e6so193664wms.2; 
	Wed, 23 Feb 2022 14:16:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=5gdBBT2ODiXDgaA0LzLZHPQAuJ7//dZmafwkxEk6NNk=;
	b=mKu/yY4TQEg2YvNBc7ULsrcEHXmYjoehm7JxhBuzRlwzT8KC1yE6a0jhl8G1gbB23C
	3cH/sLdSUDN88WNkICR46EMiNaHGLH+CBzlTQeJbrM2LUk9Ixv1QWJStY7ss5tF6jaIM
	JrqX9vT2cc9Lq3U194Lqj6ugZRrlcb8K42UCL7xiVjecap8GFd/RU+thAwkWd9yP+qO1
	bpJSagubNvB7Fqlaw5ix4JVCa2+E3islYXq2O0WWCRhRp52MPn70Lxs8VaqIHZZpCvEM
	mw0O2fPVEh3Q9ajf5u8dWEzTQ/Nk2/bewTp/QGQEZS5q1IdOLWdtXmEuGsKlTh+8iv6l
	2Z4A==
X-Gm-Message-State: AOAM530Ha39fKzKMBHYX2N7PCGrFv/Vgm9cJljge6AfxL7AtSpnTJFn8
	tjiOPUDrrGPlDAU1tUSvbw==
X-Google-Smtp-Source: ABdhPJzZWTJ606pdk9us4eJ/KLNwIN1HJ4WvEmfql1F/C79HYctxTWhXqskII/NhIy50I33XyfK6Rg==
X-Received: by 2002:a1c:7216:0:b0:37b:f84d:d56e with SMTP id
	n22-20020a1c7216000000b0037bf84dd56emr9136997wmc.177.1645654610117;
	Wed, 23 Feb 2022 14:16:50 -0800 (PST)
Received: from localhost (223.red-81-39-136.dynamicip.rima-tde.net.
	[81.39.136.223]) by smtp.gmail.com with ESMTPSA id
	j6-20020a05600c190600b0037c3659a12fsm1286579wmq.6.2022.02.23.14.16.46
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 23 Feb 2022 14:16:46 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Wed, 23 Feb 2022 23:16:44 +0100
Message-Id: <20220223221645.15829-1-xose.vazquez@gmail.com>
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
Subject: [dm-devel] [PATCH] multipath-tools: add DellEMC/ME5 (PowerVault
	ME5) to hardware table
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

Convert PowerVault ME4 template for all ME series.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index bd157103..7f89dd2c 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -397,9 +397,9 @@ static struct hwentry default_hw[] = {
 		.fast_io_fail  = 15,
 	},
 	{
-		/* PowerVault ME4 */
+		/* PowerVault ME 4/5 families */
 		.vendor        = "DellEMC",
-		.product       = "ME4",
+		.product       = "^ME",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.prio_name     = PRIO_ALUA,
 		.hwhandler     = "1 alua",
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

