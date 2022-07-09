Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D0D8C433EF
	for <dm-devel@archiver.kernel.org>; Sat,  9 Jul 2022 23:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657408058;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aEC6HOYg6d4b3f4NU5CeZwe+beKBfBy3emjDSA2pAg8=;
	b=cGC8qlKex2P2LLWEytSdHz9cKIx97epdvawoQb5at/s+5J42V6ipJUYPByxhyu9O4WQP9W
	MRFLTgz0VwyybivMFmtu6NAiRpJNh+hv9Qg1TrbrdJLbcDsf8OztINmYIgOM0a7Jtvtibr
	X1mwkS9SB4YWQCU/J00faCKfIIIE2U0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-5_XbTL5vMI2HvLErA4kAUg-1; Sat, 09 Jul 2022 19:07:34 -0400
X-MC-Unique: 5_XbTL5vMI2HvLErA4kAUg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 024C3380673B;
	Sat,  9 Jul 2022 23:07:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E6BEF40B40C6;
	Sat,  9 Jul 2022 23:07:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C98D31947040;
	Sat,  9 Jul 2022 23:07:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D275F19466DF
 for <dm-devel@listman.corp.redhat.com>; Sat,  9 Jul 2022 23:07:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B432F492CA2; Sat,  9 Jul 2022 23:07:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AFC0F492C3B
 for <dm-devel@redhat.com>; Sat,  9 Jul 2022 23:07:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 977AC29AA3B4
 for <dm-devel@redhat.com>; Sat,  9 Jul 2022 23:07:30 +0000 (UTC)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com
 [209.85.128.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-5fWgR3TyPBqgUwl3hwMiTw-1; Sat, 09 Jul 2022 19:07:26 -0400
X-MC-Unique: 5fWgR3TyPBqgUwl3hwMiTw-1
Received: by mail-wm1-f49.google.com with SMTP id
 be14-20020a05600c1e8e00b003a04a458c54so1108132wmb.3; 
 Sat, 09 Jul 2022 16:07:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=rEZWSe+WjP1GRzd3ZHiK2JBN3yYKQV7jwRlseuXyhxI=;
 b=Fg9pq4A4RLVfVL2xvpaFFs4Yd0mbnp5cUvLccuIZFv1I5ah7mZZIcl+PMZ6Mu7SkRY
 WkZRDG1UuYg0HDwiNQ4oOI2e8IrK5wya3C5VGkTh1ULJpA5bQ2Zw/MwCgs6fJAU4ah7e
 3gBDn/YzOSrZWwhNVxdNecJDbImoa4P3b4jXCWCF4wuJaccZadr8yeTo+pqJtu1NwpZX
 Vr51TdvZTKfg4E434QwwxZDLVROBkF8fVGfh3YnzGbscyzmfinqzIdaXXlKlGAvg/v2S
 iwHISyBiZEMDwn8fKJgKrPi47+PWpvLftEEmaiZBbe8Myufikd01yteA48Gb+Feox2cB
 N2vg==
X-Gm-Message-State: AJIora/AaZUnkpJdOUA5dx0gVq1b4opqkx6v06/diMRhEKjFq1JAEmdD
 CBtic1hs1MX4BuGmg4xXXw==
X-Google-Smtp-Source: AGRyM1t9KGeNSTKOh1q3AOwcNMqRIDDjFcVVgJ0+up/JRRGqxYCZL9L5v5mHpSEysAchWfNuD6Ss9Q==
X-Received: by 2002:a05:600c:1412:b0:3a1:6e8f:f19f with SMTP id
 g18-20020a05600c141200b003a16e8ff19fmr7612020wmi.90.1657408032758; 
 Sat, 09 Jul 2022 16:07:12 -0700 (PDT)
Received: from localhost (58.red-81-44-152.dynamicip.rima-tde.net.
 [81.44.152.58]) by smtp.gmail.com with ESMTPSA id
 bh25-20020a05600c3d1900b0039c454067ddsm2516756wmb.15.2022.07.09.16.07.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 09 Jul 2022 16:07:12 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sun, 10 Jul 2022 01:07:08 +0200
Message-Id: <20220709230709.35516-2-xose.vazquez@gmail.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH 1/2] multipath-tools: update Huawei OceanStor
 NVMe vendor id
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
index 513fa679..fc0252ba 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1116,7 +1116,7 @@ static struct hwentry default_hw[] = {
 	},
 	{
 		/* OceanStor NVMe */
-		.vendor        = "NVME",
+		.vendor        = "NVM[eE]",
 		.product       = "Huawei-XSG1",
 		.checker_name  = DIRECTIO,
 		.no_path_retry = 12,
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

