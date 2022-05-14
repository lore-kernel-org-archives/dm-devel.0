Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF0EDC433EF
	for <dm-devel@archiver.kernel.org>; Sat, 14 May 2022 23:02:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-270-oU886M7AM1-PrAS4T_y8mA-1; Sat, 14 May 2022 19:02:15 -0400
X-MC-Unique: oU886M7AM1-PrAS4T_y8mA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1825180139A;
	Sat, 14 May 2022 23:02:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 844A24411CA;
	Sat, 14 May 2022 23:02:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 41D9F194704E;
	Sat, 14 May 2022 23:02:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2EF45194707E
 for <dm-devel@listman.corp.redhat.com>; Sat, 14 May 2022 23:02:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 10D9315088A0; Sat, 14 May 2022 23:02:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C5BA15063FF
 for <dm-devel@redhat.com>; Sat, 14 May 2022 23:02:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9A243803502
 for <dm-devel@redhat.com>; Sat, 14 May 2022 23:02:11 +0000 (UTC)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
 [209.85.128.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-Q1btc0bAML-q5Z8s7Yy1qg-1; Sat, 14 May 2022 19:02:08 -0400
X-MC-Unique: Q1btc0bAML-q5Z8s7Yy1qg-1
Received: by mail-wm1-f47.google.com with SMTP id
 v191-20020a1cacc8000000b00397001398c0so75821wme.5; 
 Sat, 14 May 2022 16:02:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=llcNdaKlUpBQsK0jyN+buglVi4CZJSVv4jVyVOCW1gw=;
 b=r1c97KQibM4qhSwKXWjx5j4v7ysuIkH3HJ4IDsSOnRcXedWSg7eggb9EL31zJNxygt
 yYoj6Sll6putPHBo/8BWF1LGFP8YLTuz5pJclod2z+BLmUMwuaC57IfLg9a2dIQz5WrL
 nlEtCP3qc9ObNSx41KoGxmsqU5EMTIZcsFeG1xzRNcCcm+hWgm7h/77XC9FhErh+2VwL
 yM98VteAvKyt9+eRhcZGkS7qrfT/CBcWwbItdEtM7fVcD0MZM2iy1mlUsEjYhBEf/NmQ
 2en0jRvIciBneKgeTM8o8ZvqIHtoOwLC379gwnvPhBBTmFgWnEmWvGx3aYIaXor4tjQe
 Xxtw==
X-Gm-Message-State: AOAM532qSVC4C4LhEkMR3yIbhAlKeF39bRll5qti5kOoAgY9PcvRLhFw
 JK9OEXNZwwSRyfKtrXDzaA==
X-Google-Smtp-Source: ABdhPJz2uWcxZ/sK+CWwuoay8FACxO0reMU5chKugKpAaMv4FLczkSV3HBLnIMI/lDzukox0IgRfgg==
X-Received: by 2002:a7b:ce08:0:b0:394:32df:2ae6 with SMTP id
 m8-20020a7bce08000000b0039432df2ae6mr20508891wmc.184.1652569327052; 
 Sat, 14 May 2022 16:02:07 -0700 (PDT)
Received: from localhost (50.red-81-44-142.dynamicip.rima-tde.net.
 [81.44.142.50]) by smtp.gmail.com with ESMTPSA id
 o28-20020adfa11c000000b0020d03c14b9csm973296wro.1.2022.05.14.16.02.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 14 May 2022 16:02:06 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sun, 15 May 2022 01:01:47 +0200
Message-Id: <20220514230148.139675-9-xose.vazquez@gmail.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH 8/9] multipath-tools: add Pure FlashArray NVMe to
 hardware table
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
 Uday Shankar <ushankar@purestorage.com>, DM-DEVEL ML <dm-devel@redhat.com>,
 Brian Bunker <brian@purestorage.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Cc: Uday Shankar <ushankar@purestorage.com>
Cc: Brian Bunker <brian@purestorage.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index f99e2537..bef1c8e5 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1107,6 +1107,13 @@ static struct hwentry default_hw[] = {
 		.fast_io_fail  = 10,
 		.max_sectors_kb = 4096,
 	},
+	{
+		/* FlashArray NVMe */
+		.vendor        = "NVME",
+		.product       = "Pure Storage FlashArray",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = 10,
+	},
 	/*
 	 * Huawei
 	 */
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

