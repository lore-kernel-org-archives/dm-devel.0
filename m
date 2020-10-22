Return-Path: <SRS0=1REc=D5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD9FC388F9
	for <dm-devel@archiver.kernel.org>; Thu, 22 Oct 2020 19:25:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8ECD824656
	for <dm-devel@archiver.kernel.org>; Thu, 22 Oct 2020 19:25:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8ECD824656
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-zSRS5wW0OsCbj26o0M7oog-1; Thu, 22 Oct 2020 15:25:03 -0400
X-MC-Unique: zSRS5wW0OsCbj26o0M7oog-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5058D425F3;
	Thu, 22 Oct 2020 19:24:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 669EB19D61;
	Thu, 22 Oct 2020 19:24:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5937A922F8;
	Thu, 22 Oct 2020 19:24:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09MJOrxr004096 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 22 Oct 2020 15:24:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 302112144B32; Thu, 22 Oct 2020 19:24:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B5F82144B30
	for <dm-devel@redhat.com>; Thu, 22 Oct 2020 19:24:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D931B1078506
	for <dm-devel@redhat.com>; Thu, 22 Oct 2020 19:24:50 +0000 (UTC)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
	[209.85.221.47]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-176-QxZLJUi8M_OZCS7LykWnTg-1; Thu, 22 Oct 2020 15:24:43 -0400
X-MC-Unique: QxZLJUi8M_OZCS7LykWnTg-1
Received: by mail-wr1-f47.google.com with SMTP id i1so4380528wro.1;
	Thu, 22 Oct 2020 12:24:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=Ff+OIAQ2OmRYBRoIu9xLBDRXFc1/lEJBQpc6a6yA2Us=;
	b=nlvisFiT2WO7/9Q3E07qo4oRs25lYAxAKhnm+3AvZ3fqvyfiF/hgt0IfStA4hCfo/w
	p+27jRgrT0Rz6NvinLUP1rjO9B6ZOm8nsJvIRaEr82Kv/OryE6nNIZ/FWE4tm7Et2gLQ
	Aqsv8IEDBuHtGrIQJRQ4HoWU5cCqYDNqKCsDQyBkdVoa9P7A//sPfnZBR5/TiQtxJieH
	L0Vc91496JuIJxCmP+Vtgd/7Nkv4gsN+XwNcnhde3xQ7gPwDygBFro4L5L1/Ji3rh1PD
	gdsHZkh+U7DQ6+fA412M6lguMhbDklBGxzQpwBukSJTAlnU54ySFQvFb51WIyM/SK7JB
	BTBg==
X-Gm-Message-State: AOAM532XRNS4JCeyTxZQTEMtuEmR5dDMj+Sx9Da7Tm94PUp01tUvf+H0
	28vskQsvdU9a92RyDqBgFQ==
X-Google-Smtp-Source: ABdhPJzzzEqFbL6UQBUhp8GF0qoN6TcSDKmMDhFqrfXlPMSZ7T2V3toi9bfIXcwdNy7tRLUt6rAcFQ==
X-Received: by 2002:adf:fd09:: with SMTP id e9mr4389160wrr.241.1603394682259; 
	Thu, 22 Oct 2020 12:24:42 -0700 (PDT)
Received: from localhost (100.red-176-87-1.dynamicip.rima-tde.net.
	[176.87.1.100])
	by smtp.gmail.com with ESMTPSA id r3sm5707877wrm.51.2020.10.22.12.24.40
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 22 Oct 2020 12:24:41 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu, 22 Oct 2020 21:24:38 +0200
Message-Id: <20201022192439.5527-1-xose.vazquez@gmail.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
	DM-DEVEL ML <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH 1/2] multipath-tools: add MacroSAN arrays to
	hwtable
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Based on:
http://case.macrosan.com/webdoc/view/Pub40288112616a02f101617abd864a0fe9.html
http://case.macrosan.com/webdoc/view/Pub402881126078307e0160c15456491369.html
http://case.macrosan.com/webdoc/view/Pub4028811263cdeeb40165d7150dce19e6.html
http://case.macrosan.com/webdoc/view/Pub40288112661f1dee016a95cb58f5504c.html

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index d1fcfdb3..43154dd0 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1262,6 +1262,18 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.prio_name     = PRIO_ALUA,
 	},
+	/*
+	 * MacroSAN Technologies
+	 */
+	{
+		/* MS family */
+		.vendor        = "MacroSAN",
+		.product       = "LU",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.prio_name     = PRIO_ALUA,
+		.no_path_retry = 30,
+	},
 	/*
 	 * EOL
 	 */
-- 
2.28.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

