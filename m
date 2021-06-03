Return-Path: <SRS0=6AeK=K5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 595AEC47082
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 21:24:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BED4161401
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 21:24:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BED4161401
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-nIfTRzSMM_CMsv96babJjQ-1; Thu, 03 Jun 2021 17:24:44 -0400
X-MC-Unique: nIfTRzSMM_CMsv96babJjQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2C3A10074A6;
	Thu,  3 Jun 2021 21:24:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D74D45D6AB;
	Thu,  3 Jun 2021 21:24:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CDF0B44A58;
	Thu,  3 Jun 2021 21:24:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 153LOBc7007492 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Jun 2021 17:24:11 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4410B20BDB27; Thu,  3 Jun 2021 21:24:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F7CF20BDB25
	for <dm-devel@redhat.com>; Thu,  3 Jun 2021 21:24:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10B12101A531
	for <dm-devel@redhat.com>; Thu,  3 Jun 2021 21:24:09 +0000 (UTC)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com
	[209.85.128.54]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-219-W8Nt-2hEM_WF5bk6YKOQ6Q-1; Thu, 03 Jun 2021 17:24:07 -0400
X-MC-Unique: W8Nt-2hEM_WF5bk6YKOQ6Q-1
Received: by mail-wm1-f54.google.com with SMTP id
	o2-20020a05600c4fc2b029019a0a8f959dso4482759wmq.1; 
	Thu, 03 Jun 2021 14:24:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=GxWmOKdP+tReoulyKnq/0cZxUsD0uek33JZUDTAHw9E=;
	b=b1/BaV9wJ9azMixfhKCEcAKhsjly9tgln+yNrrrtSVgdXbUGkge0NuZHymFRl1GodE
	byM0t8H5qAE+lNcWGFYdwl1luZYaBpd+VfZ2I2UfCTcfOEaoKwLKN/KsZf48PXGMPtLZ
	0tbDvjE7OYzX+4BBXO15pNpDiV5mcHk9WEDkHjkTeHlaA9uvlJuPIHlXUt1E8dzL7qdU
	rALwYUbIZlV+Enu1X50S8iNlUtZbrJzr490WcpTvC/+6sDBQOw71maQcOT/zkEGPWVfH
	W5Fccyj6lXcUwg9aNHSeaFm1qN0PIEeLvz8o/Eu7FUCQ9TaWQP9hBHxzs7K7rVXIYyTm
	Rr+w==
X-Gm-Message-State: AOAM532MnfYFOcxroy///BVHnrwZ/f0O2rQs+ivtzGxTJ4H5XL7wTT3s
	BIE41iaKm06yMkBENeKNzsYZpv5S3A==
X-Google-Smtp-Source: ABdhPJyz9u/Pi+XehHM9oz6ZHxcyk2bYz1KEPF+eEqkbHeU2ryizmpCBzLmi2rf03hXah2rqBE1oFA==
X-Received: by 2002:a1c:c91a:: with SMTP id f26mr398699wmb.15.1622755445534;
	Thu, 03 Jun 2021 14:24:05 -0700 (PDT)
Received: from localhost (155.red-83-46-156.dynamicip.rima-tde.net.
	[83.46.156.155])
	by smtp.gmail.com with ESMTPSA id c7sm5136579wrc.42.2021.06.03.14.24.04
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 03 Jun 2021 14:24:04 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu,  3 Jun 2021 23:24:02 +0200
Message-Id: <20210603212402.5559-1-xose.vazquez@gmail.com>
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
Subject: [dm-devel] [PATCH] multipath-tools: add info about HPE Alletra 6000
	and 9000
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 README.alua                | 2 +-
 libmultipath/hwtable.c     | 4 ++--
 multipath/multipath.conf.5 | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/README.alua b/README.alua
index b15eb487..5d2b1c64 100644
--- a/README.alua
+++ b/README.alua
@@ -6,7 +6,7 @@ To enable ALUA, the following options should be changed:
 - EMC CLARiiON/VNX:
    "Failover Mode" should be changed to "4" or "Active-Active mode(ALUA)-failover mode 4"
 
-- HPE 3PAR:
+- HPE 3PAR, Primera, and Alletra 9000:
    "Host:" should be changed to "Generic-ALUA Persona 2 (UARepLun, SESLun, ALUA)".
 
 - Promise VTrak/Vess:
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 58fa7387..e884d8c7 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -107,7 +107,7 @@ static struct hwentry default_hw[] = {
 	 * HPE
 	 */
 	{
-		/* 3PAR / Primera */
+		/* 3PAR / Primera / Alletra 9000 */
 		.vendor        = "3PARdata",
 		.product       = "VV",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -225,7 +225,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* Nimble Storage */
+		/* Nimble Storage / HPE Alletra 6000 */
 		.vendor        = "Nimble",
 		.product       = "Server",
 		.hwhandler     = "1 alua",
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 064e4826..c2b642dc 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1540,7 +1540,7 @@ The vpd page abbreviation can be found by running \fIsg_vpd -e\fR. multipathd
 will use this information to gather device specific information that can be
 displayed with the \fI%g\fR wilcard for the \fImultipathd show maps format\fR
 and \fImultipathd show paths format\fR commands. Currently only the
-\fBhp3par\fR vpd page is supported.
+\fBhp3par\fR vpd page(for HPE 3PAR, Primera, and Alletra 9000) is supported.
 .TP
 .B hardware_handler
 The hardware handler to use for this device type.
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

