Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 433B9C433EF
	for <dm-devel@archiver.kernel.org>; Sat, 14 May 2022 23:02:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-169-F0u7FeSNM2KujxcVmXJjzg-1; Sat, 14 May 2022 19:02:10 -0400
X-MC-Unique: F0u7FeSNM2KujxcVmXJjzg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 47F5D80418B;
	Sat, 14 May 2022 23:02:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 34B3240D2824;
	Sat, 14 May 2022 23:02:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E453B194704E;
	Sat, 14 May 2022 23:02:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C484A194F4BB
 for <dm-devel@listman.corp.redhat.com>; Sat, 14 May 2022 23:02:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9100CC27E89; Sat, 14 May 2022 23:02:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CF0AC27E84
 for <dm-devel@redhat.com>; Sat, 14 May 2022 23:02:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 714251C04B76
 for <dm-devel@redhat.com>; Sat, 14 May 2022 23:02:02 +0000 (UTC)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com
 [209.85.128.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-f6QaEU4xPsC8P4zK3uqW8g-1; Sat, 14 May 2022 19:02:00 -0400
X-MC-Unique: f6QaEU4xPsC8P4zK3uqW8g-1
Received: by mail-wm1-f54.google.com with SMTP id
 125-20020a1c1983000000b003941f354c62so6711471wmz.0; 
 Sat, 14 May 2022 16:02:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=50HLvFUsOZHhEbZkYrg8AB8i5w9C3aCBM8jg/jTVO84=;
 b=PkSetYZ2b61dz2KgbFnfBzqk4ukKrTj9hyl9r0LXYrJmwuOpbOmrwCzO380nQmM3G6
 tEBvipStZP4MZmOD/dCieYJjZXlL6e/DZvB1E8rb9Q43ja5fM1bBTlRYLZmx98dJpVgY
 /j4n4PpWQMHohqUKMAAEY9H77zRzluN7LdvG+/wWHGy0O6Pu8ph/tbXSs6/5qiKRJMxC
 0TTUrqHQP/fyZvL49a8a9s3oXimqo9hMaQoMX9aa/9vJpM6IRnwl+OJ++Mva7qtvc7kO
 Tz4x9fSTsaaXyIREKmEabyjaoDRiTG0GrjWqJzQakk9YB9XTHJTZ2hb2RmEzTw5BhPwc
 fCMw==
X-Gm-Message-State: AOAM531+I8f/nZYnKf9Mxg5PnNV5Fmehf200gZ0lt3uV/rhp286SgbWL
 1kJwEw2pmvkV/s76oh0zU5WxTwcZlX/3
X-Google-Smtp-Source: ABdhPJwkhMlqxbEZ3aeBF2MaoZRsurdMMFIHu1LN7OzP5GRK+9AlHD2UN7R1ILq3geDCPGgQQc5lCg==
X-Received: by 2002:a05:600c:240a:b0:394:18b:d722 with SMTP id
 10-20020a05600c240a00b00394018bd722mr21392787wmp.177.1652569319063; 
 Sat, 14 May 2022 16:01:59 -0700 (PDT)
Received: from localhost (50.red-81-44-142.dynamicip.rima-tde.net.
 [81.44.142.50]) by smtp.gmail.com with ESMTPSA id
 m32-20020a05600c3b2000b003942a244ed2sm8422173wms.23.2022.05.14.16.01.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 14 May 2022 16:01:58 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sun, 15 May 2022 01:01:41 +0200
Message-Id: <20220514230148.139675-3-xose.vazquez@gmail.com>
In-Reply-To: <20220514230148.139675-1-xose.vazquez@gmail.com>
References: <20220514230148.139675-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH 2/9] multipath-tools: add HPE Alletra 9000 NVMe
 to hardware table
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Info from (page 53, website sometimes is broken):
https://support.hpe.com/hpesc/public/docDisplay?docLocale=en_US&docId=a00115289en_us or
https://support.hpe.com/hpesc/public/docDisplay?docId=sd00001334en_us&page=GUID-551FCC2F-D8EA-405B-B9DC-2E66C2AE8608.html

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 0f0795c3..b6ff1107 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -119,6 +119,13 @@ static struct hwentry default_hw[] = {
 		.dev_loss      = MAX_DEV_LOSS_TMO,
 		.vpd_vendor_id = VPD_VP_HP3PAR,
 	},
+	{
+		/* Alletra 9000 NVMe */
+		.vendor        = "NVME",
+		.product       = "HPE Alletra",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+	},
 	{
 		/* RA8000 / ESA12000 */
 		.vendor        = "DEC",
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

