Return-Path: <SRS0=D7/d=OS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A45ACC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 28 Sep 2021 16:52:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F063561159
	for <dm-devel@archiver.kernel.org>; Tue, 28 Sep 2021 16:52:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F063561159
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-Y3LwYEIdMJKdQQ3svdg7jQ-1; Tue, 28 Sep 2021 12:52:40 -0400
X-MC-Unique: Y3LwYEIdMJKdQQ3svdg7jQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2D1FCC621;
	Tue, 28 Sep 2021 16:52:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F38060C13;
	Tue, 28 Sep 2021 16:52:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 191A31806D00;
	Tue, 28 Sep 2021 16:52:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18SGqQ2j022574 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 28 Sep 2021 12:52:26 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8F2BE202F2EE; Tue, 28 Sep 2021 16:52:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A492201F3B1
	for <dm-devel@redhat.com>; Tue, 28 Sep 2021 16:52:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2CC318A01B1
	for <dm-devel@redhat.com>; Tue, 28 Sep 2021 16:52:18 +0000 (UTC)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com
	[209.85.221.51]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-176-d4Fa4H8bOQWiBkF3ggZTLA-1; Tue, 28 Sep 2021 12:52:14 -0400
X-MC-Unique: d4Fa4H8bOQWiBkF3ggZTLA-1
Received: by mail-wr1-f51.google.com with SMTP id t18so59243492wrb.0;
	Tue, 28 Sep 2021 09:52:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=x4us8Ao+9GZExWtEvTLI4OW6vIJrTsgx2m2UtR6g378=;
	b=bkqK7Q3y5X1rzhoa6nt0eUygDVk8kPp+kCsq//hdL9lIifRfXTOAOEq54rxlM/7V8h
	Fhx88mUab/oJasFsQJEICgjXbif6b5wT4Bqc2zrYe4qxYSYrk90sz0gGo1wTf6Z2scL/
	0PpXFdESk650SS+h/Yfz8d8XnDBBZEyCJim1O1Xq3OI7Vsn9CuJTIW+sCYbuZkFIuXTd
	cG0tVMhONu+W4GZBocjFDQQrCCNsKsI0bO/xqjhr0NPsB9B+5X3PyyPcdIPUGIjo1iBt
	MrDBRdTeZ3GqPzLLJQGDoRQzaivucdRZQ1WbKfmGorol4CHss2PTaaHXpHHx8klVJ++8
	rR4Q==
X-Gm-Message-State: AOAM530f5BNbWVGTWKKupG07sJ3fI5U13ue0PGVdFKtU8hD3B/q6062u
	xi+A6TOeCB+SF7obk13dxw==
X-Google-Smtp-Source: ABdhPJybpK4BXrukYOyfcRXUgrrVL2Xi255m2zfqkaINbXSPq/JRs1ueiW0yMiDitXaFPou765EgEg==
X-Received: by 2002:a5d:610c:: with SMTP id v12mr1310787wrt.423.1632847932557; 
	Tue, 28 Sep 2021 09:52:12 -0700 (PDT)
Received: from localhost ([90.160.137.52]) by smtp.gmail.com with ESMTPSA id
	s2sm19611254wrn.77.2021.09.28.09.52.11
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 28 Sep 2021 09:52:12 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Tue, 28 Sep 2021 18:52:10 +0200
Message-Id: <20210928165210.15565-1-xose.vazquez@gmail.com>
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
Subject: [dm-devel] [PATCH] multipath-tools: make IBM/2107900 (DS8000)
	config work with alua and multibus
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

ALUA is supported since the beginning:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/scsi/device_handler/scsi_dh_alua.c?id=057ea7c9683c3d684128cced796f03c179ecf1c2#n683

... the DS8000 is an Asymmetric Logical Unit Access (ALUA) capable storage array,
pag#160(144): https://www.redbooks.ibm.com/redbooks/pdfs/sg248887.pdf

kernel log:
https://marc.info/?l=linux-scsi&m=156407413807511&q=mbox

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 72f81c60..f115c4f9 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -656,7 +656,8 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^2107900",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-		.pgpolicy      = MULTIBUS,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
 	},
 	{
 		// Storwize V5000 and V7000 lines / SAN Volume Controller (SVC) / Flex System V7000 /
-- 
2.32.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

