Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1680C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 19 May 2022 18:06:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-318-tcwREelIPB68j17ASbPpsQ-1; Thu, 19 May 2022 14:06:24 -0400
X-MC-Unique: tcwREelIPB68j17ASbPpsQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A1E680B90A;
	Thu, 19 May 2022 18:06:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1B4B91410DD5;
	Thu, 19 May 2022 18:06:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CD6011949759;
	Thu, 19 May 2022 18:06:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2528C194705A
 for <dm-devel@listman.corp.redhat.com>; Thu, 19 May 2022 18:06:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EC5D67774; Thu, 19 May 2022 18:06:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E817B7AD5
 for <dm-devel@redhat.com>; Thu, 19 May 2022 18:06:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB811800B21
 for <dm-devel@redhat.com>; Thu, 19 May 2022 18:06:20 +0000 (UTC)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
 [209.85.221.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-159-_J2dJuPCMeu1DhfirS6Gug-1; Thu, 19 May 2022 14:06:19 -0400
X-MC-Unique: _J2dJuPCMeu1DhfirS6Gug-1
Received: by mail-wr1-f49.google.com with SMTP id h14so8313094wrc.6;
 Thu, 19 May 2022 11:06:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=QwZmmSXTTYILzZPtMOmCVCpg21kUgHeMx4QUagAKHE4=;
 b=k3WOeBWWGCoy5kW1RAyFvdjzGAvldlPTk5UqK5BaHgSvApGb93kE4uHDFuyLIyQfGi
 l2STUc+Fl3Cx7SrboISEZFaoX0bJt/QJ//DmJnUXrpzf+k1FDL6v4fO0GtOj5b6XQEk0
 LSOl8F4VFfSxpbcoxn+dgV94KL1hxIkMULsnkRItD4COwAxUwRLqMfGVBs9g2Ytb1SEc
 D6H9VHO1xSS3J+0K5709P8heie0qqOtKi+Ex0goCDIkjUS+p7trr4nvrmlcWB7ZUP3+H
 UcnQICDWEoXcXyNTsUDaWF8P/3WXkbCTQx3FNOljmEG1H8fImobNWOsnsTDftNl3F42K
 LlZQ==
X-Gm-Message-State: AOAM531ZPgHtK+LorxH/xYZzX0bZ3cMtQTWpuBVDeFegMJo6UbNjWGlv
 qXkwSwQI/0nEqb2m7LywBXkzZdxVAg==
X-Google-Smtp-Source: ABdhPJy4awRv0Vf35+Ar15zK32IL1xWp7MoKcycIcuhVZ2M7z7j8WpcFrS5F9ZsYdZhNf+/GOrtBIQ==
X-Received: by 2002:adf:f252:0:b0:20d:76e:99bb with SMTP id
 b18-20020adff252000000b0020d076e99bbmr5110323wrp.647.1652983577444; 
 Thu, 19 May 2022 11:06:17 -0700 (PDT)
Received: from localhost (205.red-81-44-158.dynamicip.rima-tde.net.
 [81.44.158.205]) by smtp.gmail.com with ESMTPSA id
 c17-20020a05600c0a5100b003948f4e750fsm199250wmq.23.2022.05.19.11.06.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 19 May 2022 11:06:17 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu, 19 May 2022 20:06:15 +0200
Message-Id: <20220519180615.117289-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH] multipath-tools: update "Generic NVMe" options
 in hwtable
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Suggested-by: Martin Wilck <mwilck@suse.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 39daadc2..555f4e0c 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -86,11 +86,10 @@ static struct hwentry default_hw[] = {
 	 */
 	{
 		/* Generic NVMe */
-		.vendor        = "NVME",
+		.vendor        = "NVM[eE]",
 		.product       = ".*",
 		.uid_attribute = DEFAULT_NVME_UID_ATTRIBUTE,
 		.checker_name  = NONE,
-		.retain_hwhandler = RETAIN_HWHANDLER_OFF,
 	},
 	/*
 	 * Apple
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

