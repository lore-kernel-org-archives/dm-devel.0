Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0624C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 30 Mar 2022 19:50:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-ryIMDvobNE2hSApfKgsLPg-1; Wed, 30 Mar 2022 15:49:56 -0400
X-MC-Unique: ryIMDvobNE2hSApfKgsLPg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E8BF100BAA7;
	Wed, 30 Mar 2022 19:49:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 09562140265A;
	Wed, 30 Mar 2022 19:49:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C88561947BBB;
	Wed, 30 Mar 2022 19:49:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2431719451F3
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Mar 2022 19:49:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0E40D140265A; Wed, 30 Mar 2022 19:49:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0AAEE1402642
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 19:49:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E4170185A79C
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 19:49:48 +0000 (UTC)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
 [209.85.128.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-393-HS4SAZXqM4GWfA58Y4uw4Q-1; Wed, 30 Mar 2022 15:49:45 -0400
X-MC-Unique: HS4SAZXqM4GWfA58Y4uw4Q-1
Received: by mail-wm1-f47.google.com with SMTP id q20so12967938wmq.1;
 Wed, 30 Mar 2022 12:49:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=1vDbGswLcO8Xj4x8H6Xvq3LQa4GQHfoHBbsAptOG5GA=;
 b=FXmfz1syfbEqAIZv9cfHh9yuOBtN0OWT3DgKi8Eo5q9ZTsPM7123y9HyiJONWeck/e
 Im1eRo2lbEu16hGq2rZcKM9zXXzJJ77falTL/EDfiNQsHoh7BADlrLDW6OksC20UeTIN
 9EVplEs0ZpuRfghAxTlLq/msfNtAMsYoSyoakCfjjk+3CO/yisuSyjAIAjHoxDAB0m99
 C9NwX17phleF0Yc1Tx7xTRhU9FZyQYpLTW98027lSlE8nfwyF7yvGd/5gvDOTHL/iGO8
 00e1n3tLXlgnQEK+SILdqBFd2KexighWAKcHbtW+KQ4JzADC2HfCU669xMor52pHXLd4
 pjzQ==
X-Gm-Message-State: AOAM5309thN+ZDA4amdkdlLULJqoT5RrAly94+rITzXiDg9WGYeg/jGM
 xG5faT5cakqGLasjuEPEAg==
X-Google-Smtp-Source: ABdhPJywvf36PVjxCHSghUCXZ886gnuvY3dVhdeVhm+fn0LAtC6/2CBxMVCyYZ9FqGSvzMS/g0foNw==
X-Received: by 2002:a7b:c7d4:0:b0:38c:dd1b:5475 with SMTP id
 z20-20020a7bc7d4000000b0038cdd1b5475mr1125938wmk.55.1648669783660; 
 Wed, 30 Mar 2022 12:49:43 -0700 (PDT)
Received: from localhost (59.red-81-39-139.dynamicip.rima-tde.net.
 [81.39.139.59]) by smtp.gmail.com with ESMTPSA id
 p14-20020a5d59ae000000b00203dcc87d39sm28501246wrr.54.2022.03.30.12.49.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 30 Mar 2022 12:49:43 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Wed, 30 Mar 2022 21:49:41 +0200
Message-Id: <20220330194941.28470-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH RFC] multipath-tools: update "Generic NVMe"
 options in hwtable
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
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

Removed values were default.
Check ANA, else fall back to CONST(multibus).

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 0e1c0a41..81dca0d5 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -88,9 +88,9 @@ static struct hwentry default_hw[] = {
 		/* Generic NVMe */
 		.vendor        = "NVME",
 		.product       = ".*",
-		.uid_attribute = DEFAULT_NVME_UID_ATTRIBUTE,
-		.checker_name  = NONE,
-		.retain_hwhandler = RETAIN_HWHANDLER_OFF,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
 	},
 	/*
 	 * Apple
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

