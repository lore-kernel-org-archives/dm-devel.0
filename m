Return-Path: <SRS0=uf5V=K6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DD74C4743D
	for <dm-devel@archiver.kernel.org>; Fri,  4 Jun 2021 23:02:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B7503613F9
	for <dm-devel@archiver.kernel.org>; Fri,  4 Jun 2021 23:02:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7503613F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-Svr1IjoCNSinY873AhumZw-1; Fri, 04 Jun 2021 19:02:11 -0400
X-MC-Unique: Svr1IjoCNSinY873AhumZw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89F9E180FD6D;
	Fri,  4 Jun 2021 23:02:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C05F860D06;
	Fri,  4 Jun 2021 23:02:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BE95B1800BB8;
	Fri,  4 Jun 2021 23:01:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 154N1tNx020113 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Jun 2021 19:01:55 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BB2E12062C07; Fri,  4 Jun 2021 23:01:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E3DD20E7AB3
	for <dm-devel@redhat.com>; Fri,  4 Jun 2021 23:01:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D62E381D79F
	for <dm-devel@redhat.com>; Fri,  4 Jun 2021 23:01:52 +0000 (UTC)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
	[209.85.221.47]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-406-rQRWFgDKO-eSSqoo7x7XwQ-1; Fri, 04 Jun 2021 19:01:48 -0400
X-MC-Unique: rQRWFgDKO-eSSqoo7x7XwQ-1
Received: by mail-wr1-f47.google.com with SMTP id q5so10781046wrm.1;
	Fri, 04 Jun 2021 16:01:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=sh2l+hdfNYUR73msS2cZ9lFW6i3ITYA8bU5Q6H2iQsI=;
	b=rzgV8hQ0T+8dyfXw9dZCyWNoOkeswtdaTgCJynkJLBg4acwuJpmZTd9g6XK7p60Wav
	r4F2DYW9xFqd5hwhsOChW+XzRRw7gHAbPzHSj0RZPJs2s6qsGsjOZpgOL3BNqX7pFPB0
	1Mygwwe6rbPketcFplSs1n72xDQ18U/NKpuXIhjjHKfMIuMGbhpsgz18GmS5f29qPd/V
	Pp+qzy5xgyIQ+eUJ/D5N3LUuqQfXo9ZGZMT0L5rblpIfFT2ERGV8X6FGqI48zWQ8RkXn
	nLmGY/gjZJUyc3GBii/9+EyHUqKv46v7LrWZYcf6ESeZN6J5xQq+ATeqoGGpth/rAXeE
	1LKw==
X-Gm-Message-State: AOAM532WjxtlaZtjHmcY+r0YTWMUQvd4JCsCp1S0Vmnh1ASZgJwFQOe/
	CF0nCdGY7xQh9VaWOW0bgQ==
X-Google-Smtp-Source: ABdhPJzCGqq79Yp8QX9w6c2hQcTyU1heCXPoVruLju7d5N8qokaLDMuCWEWtVOcCsolO9zfl/fhKog==
X-Received: by 2002:a5d:58c1:: with SMTP id o1mr5920002wrf.420.1622847707511; 
	Fri, 04 Jun 2021 16:01:47 -0700 (PDT)
Received: from localhost (146.red-83-46-167.dynamicip.rima-tde.net.
	[83.46.167.146]) by smtp.gmail.com with ESMTPSA id
	k82sm10160147wmf.11.2021.06.04.16.01.46
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 04 Jun 2021 16:01:47 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sat,  5 Jun 2021 01:01:45 +0200
Message-Id: <20210604230145.9887-1-xose.vazquez@gmail.com>
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
Subject: [dm-devel] [PATCH v2] multipath-tools: add info about HPE Alletra
	6000 and 9000
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
 README.alua            | 2 +-
 libmultipath/hwtable.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

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
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

