Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 941F5C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 24 Feb 2022 21:24:55 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-245cSUWHPjCQyAdBaJBONw-1; Thu, 24 Feb 2022 16:24:50 -0500
X-MC-Unique: 245cSUWHPjCQyAdBaJBONw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54E4B1091DA2;
	Thu, 24 Feb 2022 21:24:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F2B189BEC8;
	Thu, 24 Feb 2022 21:24:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BDD844ED27;
	Thu, 24 Feb 2022 21:24:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21OLOirI011038 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 24 Feb 2022 16:24:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3600B401D28; Thu, 24 Feb 2022 21:24:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 32033492D5B
	for <dm-devel@redhat.com>; Thu, 24 Feb 2022 21:24:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1836E899EC5
	for <dm-devel@redhat.com>; Thu, 24 Feb 2022 21:24:44 +0000 (UTC)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com
	[209.85.128.51]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-62-_ZMunVbiOIOblm6E1-Q0Gg-1; Thu, 24 Feb 2022 16:24:42 -0500
X-MC-Unique: _ZMunVbiOIOblm6E1-Q0Gg-1
Received: by mail-wm1-f51.google.com with SMTP id
	v2-20020a7bcb42000000b0037b9d960079so611857wmj.0; 
	Thu, 24 Feb 2022 13:24:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=9vuaPhLmZojBe225JbzHbfTU3KWoUnpvEhEuHQYss0c=;
	b=WMuOSeBFHZu+OAE5+VxFxv1AUgvSlrVfdc/4FELgRElIIpnUwgaECffShHG6IaUF39
	pMFDf96Y/wREvcBMj6g8ukIh+hJvUD6w0Bfg3BrjRZxLgpvMuFWJrlSPrdrJcrnrrXjb
	lSamnTnLHckT1XEMmI7hUjYSqIEwGn0xR0YdDlZpIQLAum1mnhw7HELHvrIOAQUNYjeL
	6dYys4xXOb8BVCuC33Vw7DEBt8VCYKQZunNoVv1iIrZwJv40QmAa6jE8tA6KqQhtVt9i
	1VmpLeB8I6nNrfeGKe/yIRxYpG4eV5MsCNWWeCLPsmHY9Nif0x2ExTGYv1fsefvVWPp6
	ENaA==
X-Gm-Message-State: AOAM5312gOG9ViSe4S4W6XtnkV+FYqDtkPhahJLCrtJdC36uV/u64hKq
	jsNYSfInWCv/xM9If+seTg==
X-Google-Smtp-Source: ABdhPJyw1cIJHMdMh3758zmjo+enexjLaCWCiuvQSkMgtNxTQuHQl/THfxde/7ZoKnRZn7UvHF8FIw==
X-Received: by 2002:a05:600c:284b:b0:380:e504:f522 with SMTP id
	r11-20020a05600c284b00b00380e504f522mr4386wmb.151.1645737880664;
	Thu, 24 Feb 2022 13:24:40 -0800 (PST)
Received: from localhost (223.red-81-39-136.dynamicip.rima-tde.net.
	[81.39.136.223]) by smtp.gmail.com with ESMTPSA id
	v7-20020adfc407000000b001e629f5e1ddsm465194wrf.22.2022.02.24.13.24.40
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 24 Feb 2022 13:24:40 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu, 24 Feb 2022 22:24:39 +0100
Message-Id: <20220224212439.25859-1-xose.vazquez@gmail.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
	DM-DEVEL ML <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH 3/3] multipath-tools: add HP/HSVX740 to hwtable
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

Info from: https://community.hpe.com/hpeb/attachments/hpeb/itrc-248/61618/1/HP_DM_MP_Guide.pdf

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 7a4b78f1..0e1c0a41 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -192,7 +192,7 @@ static struct hwentry default_hw[] = {
 	{
 		/* SAN Virtualization Services Platform */
 		.vendor        = "HP",
-		.product       = "HSVX700",
+		.product       = "(HSVX700|HSVX740)",
 		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

