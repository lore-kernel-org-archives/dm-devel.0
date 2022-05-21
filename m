Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3209AC433EF
	for <dm-devel@archiver.kernel.org>; Sat, 21 May 2022 18:45:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-210-OWUzdk4OOLKOm3kDnhUA8A-1; Sat, 21 May 2022 14:45:07 -0400
X-MC-Unique: OWUzdk4OOLKOm3kDnhUA8A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54F241C05ABF;
	Sat, 21 May 2022 18:45:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3F73E401E9D;
	Sat, 21 May 2022 18:45:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EF8F8194704E;
	Sat, 21 May 2022 18:45:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 387F31947040
 for <dm-devel@listman.corp.redhat.com>; Sat, 21 May 2022 18:45:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 121692166B25; Sat, 21 May 2022 18:45:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0DE6B2166B3F
 for <dm-devel@redhat.com>; Sat, 21 May 2022 18:45:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E6A7E811E75
 for <dm-devel@redhat.com>; Sat, 21 May 2022 18:45:00 +0000 (UTC)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com
 [209.85.128.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-KbOyniHkOwWcwNw9_DWSjQ-1; Sat, 21 May 2022 14:44:59 -0400
X-MC-Unique: KbOyniHkOwWcwNw9_DWSjQ-1
Received: by mail-wm1-f53.google.com with SMTP id
 67-20020a1c1946000000b00397382b44f4so2764254wmz.2; 
 Sat, 21 May 2022 11:44:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=2hAwLyfdQrWIlOQ2c9K4BpFYE/fVM9FqZ+xBK+qg9+g=;
 b=rxZf99w0mogxQosl9nLwnrm0Zy3fYybd5oZSn3PlOROWFJ+cXH4JVSmB1VIAXDE/Qs
 49nf6ttDewIYxQVGQgJ2BVaD+VJrbNIov4XBoyHQ2ggS2tw4vi8lZOKyaJZliEZZt+L2
 xv++tqSHUT1y//Ww12sGnrbm91q2L2HfcvnTOZ5WwPG3k+CDFMV9T+RsxjM29e9yumTe
 nHIXto1HWVAtxYAGrwhCJKuY6jdsm42umIF41pu3WEcRWrL+auvwzr3DQJrGWW+PyD97
 nOg10sbESLCWDC8BhEUtklF6SxJqLnQ+jAlGlsgiNJjWxywhD6UYQdCEiF2gTEpal1oC
 VN+Q==
X-Gm-Message-State: AOAM531k27MdxFAudJnUHwlXnICRg9xWFIQKyVo+71QRDbwFTXvVwF3k
 YOH+36gE9h2SUlam+LT1zIa/y88S7bO4
X-Google-Smtp-Source: ABdhPJwBxM9hF7HlV64MFBt1K7/lZmmZMa1HjOj7AtBEe42MzHPfZxVL5+MTfI15ixAoEt4AKj1C2g==
X-Received: by 2002:a7b:c310:0:b0:38c:f07a:e10d with SMTP id
 k16-20020a7bc310000000b0038cf07ae10dmr13478525wmj.110.1653158697546; 
 Sat, 21 May 2022 11:44:57 -0700 (PDT)
Received: from localhost (53.red-81-44-209.dynamicip.rima-tde.net.
 [81.44.209.53]) by smtp.gmail.com with ESMTPSA id
 i17-20020a05600c355100b00397470a8226sm536249wmq.15.2022.05.21.11.44.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 21 May 2022 11:44:56 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sat, 21 May 2022 20:44:55 +0200
Message-Id: <20220521184455.73855-1-xose.vazquez@gmail.com>
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
Subject: [dm-devel] [PATCH] multipath-tools: fix Huawei OceanStor NVMe
 vendor tag
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
Cc: Zou Ming <zouming.zouming@huawei.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>, chengjike.cheng@huawei.com,
 DM-DEVEL ML <dm-devel@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>, sunao.sun@huawei.com,
 jiangtao62@huawei.com, Zhouweigang <zhouweigang09@huawei.com>,
 Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

"NVME" in the doc, but "NVMe" is the real output:
(page 61-62): https://drive.google.com/file/d/1c5RK4GXX7ofZBFxTtZ_IN1qHyIjw5eR1
https://marc.info/?l=dm-devel&m=163393151312418
Use both, just in case.

Cc: <chengjike.cheng@huawei.com>
Cc: <sunao.sun@huawei.com>
Cc: <jiangtao62@huawei.com>
Cc: Zhouweigang (Jack) <zhouweigang09@huawei.com>
Cc: Zou Ming <zouming.zouming@huawei.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 39daadc2..c2b3642c 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1147,7 +1147,7 @@ static struct hwentry default_hw[] = {
 	},
 	{
 		/* OceanStor NVMe */
-		.vendor        = "NVME",
+		.vendor        = "NVM[eE]",
 		.product       = "Huawei-XSG1",
 		.pgpolicy      = MULTIBUS,
 		.checker_name  = DIRECTIO,
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

