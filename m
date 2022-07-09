Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CBA8C433EF
	for <dm-devel@archiver.kernel.org>; Sat,  9 Jul 2022 23:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657408049;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PjbgmK5ezAGWoy1genFjfiJMdQEKkmpc/9sHOqHPSZw=;
	b=UiOvmqFkVJipHjbO2nrRbHFv55uuzv7vVyKQU0GTvochHZfyxCj4A7NLHX8vEcZ7ExgjYu
	dto5LRr4ElY0ZvgzlP7P4GJhP8r1q+0/FF/qml3+eb6T9yMstDuUy/GMkY1fxCtoxAY1Zc
	7khItqzU4WpgZJPByPmVTrssD/jA3qg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-425-F6ho8Zl6Oo6shtwf14fdsg-1; Sat, 09 Jul 2022 19:07:25 -0400
X-MC-Unique: F6ho8Zl6Oo6shtwf14fdsg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 77684380673E;
	Sat,  9 Jul 2022 23:07:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DD470400EA84;
	Sat,  9 Jul 2022 23:07:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 910461947040;
	Sat,  9 Jul 2022 23:07:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2E99D19466DF
 for <dm-devel@listman.corp.redhat.com>; Sat,  9 Jul 2022 23:07:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0D1732166B29; Sat,  9 Jul 2022 23:07:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 08EB42166B26
 for <dm-devel@redhat.com>; Sat,  9 Jul 2022 23:07:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFF7885A581
 for <dm-devel@redhat.com>; Sat,  9 Jul 2022 23:07:18 +0000 (UTC)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
 [209.85.128.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-dM26-CL5M8uf5zEbpR1dkA-1; Sat, 09 Jul 2022 19:07:15 -0400
X-MC-Unique: dM26-CL5M8uf5zEbpR1dkA-1
Received: by mail-wm1-f47.google.com with SMTP id
 v67-20020a1cac46000000b003a1888b9d36so3067554wme.0; 
 Sat, 09 Jul 2022 16:07:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=vWXMevDBexlquqZF1369lcQmS2p4iCoha/D+yyTAbes=;
 b=ff++UvpbcphrO7OG9Y6SC8ba3s95sW027UcDUgP8f1D/IxMixDyJcRA3/0sAADWyeB
 1IlQwKVye29IjdEC09jObbRci+LqMG84yRdRISA4odLcGDSH7YFtMzR4oEZzX+jY23t5
 ckICSrgjyr88c6/vaCQSiTEVspa6Wiq5bY0WzfGr/0vGJ3oXZhAGlrrZ6vO4KFFiZDur
 PwPjWowEYaVIh1PbnMAjME5751Y0M5z9pTAbDFXyDAS8ZncClZ2mK59WXdWYiq5v1VjF
 R+MxMw2k8FaApPKRQMkS467pGXDM45IyQlLD/Ib69/0x14CpYh+/A6eemL2XxUt5Ww9F
 ceng==
X-Gm-Message-State: AJIora+Y8FXEDjRctHZ6lr1He9mEqc9IC7R8Snn77ZVAzKB8P2zHkh5g
 D9iEthR3P8gAGDdHsO08I08TKe8qZw==
X-Google-Smtp-Source: AGRyM1uLVMR0Iet7lEJUK7MgfMWAkEJv1kWbImCc8yKprhpq2hS4PifrpFv6gHVU02gI24529TKo3g==
X-Received: by 2002:a05:600c:254f:b0:3a2:e3d6:5217 with SMTP id
 e15-20020a05600c254f00b003a2e3d65217mr1806141wma.10.1657408033857; 
 Sat, 09 Jul 2022 16:07:13 -0700 (PDT)
Received: from localhost (58.red-81-44-152.dynamicip.rima-tde.net.
 [81.44.152.58]) by smtp.gmail.com with ESMTPSA id
 a9-20020a05600c2d4900b0039c45fc58c4sm2490577wmg.21.2022.07.09.16.07.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 09 Jul 2022 16:07:13 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sun, 10 Jul 2022 01:07:09 +0200
Message-Id: <20220709230709.35516-3-xose.vazquez@gmail.com>
In-Reply-To: <20220709230709.35516-1-xose.vazquez@gmail.com>
References: <20220709230709.35516-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [PATCH 2/2] multipath-tools: update "Generic NVMe"
 vendor regex in hwtable
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
 DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

to accept NVME and NVMe

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index fc0252ba..c88fa09a 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -86,7 +86,7 @@ static struct hwentry default_hw[] = {
 	 */
 	{
 		/* Generic NVMe */
-		.vendor        = "NVME",
+		.vendor        = "NVM[eE]",
 		.product       = ".*",
 		.uid_attribute = DEFAULT_NVME_UID_ATTRIBUTE,
 		.checker_name  = NONE,
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

