Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDA3BC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  1 Jun 2022 20:26:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-yrHGa0qZM2uqPUFZiLn0FA-1; Wed, 01 Jun 2022 16:26:53 -0400
X-MC-Unique: yrHGa0qZM2uqPUFZiLn0FA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0D2E811E81;
	Wed,  1 Jun 2022 20:26:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AF87040CF8EB;
	Wed,  1 Jun 2022 20:26:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4EFBE1947B88;
	Wed,  1 Jun 2022 20:26:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6E68C19452D2
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Jun 2022 20:26:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 406A7492C3B; Wed,  1 Jun 2022 20:26:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C12940F06C
 for <dm-devel@redhat.com>; Wed,  1 Jun 2022 20:26:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E87CE858EED
 for <dm-devel@redhat.com>; Wed,  1 Jun 2022 20:26:47 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-T76w27MKPmuCvXETMyLDGg-1; Wed, 01 Jun 2022 16:26:46 -0400
X-MC-Unique: T76w27MKPmuCvXETMyLDGg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 2D5BA21B25;
 Wed,  1 Jun 2022 20:26:45 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DFEF41330F;
 Wed,  1 Jun 2022 20:26:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id KAcUNYTLl2IFJwAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 01 Jun 2022 20:26:44 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Steven Schremmer <Steve.Schremmer@netapp.com>
Date: Wed,  1 Jun 2022 22:26:28 +0200
Message-Id: <20220601202628.5469-3-mwilck@suse.com>
In-Reply-To: <20220601202628.5469-1-mwilck@suse.com>
References: <20220601202628.5469-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH 2/2] libmultipath: hwtable: remove obsolete NVMe
 entries
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

With the previous patch, lots of specific settings for NVMe devices
can be removed, because they match the general NVMe defaults.
E-Series NVMe is removed entirely.
---
 libmultipath/hwtable.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index e0dce84..fd4573f 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -124,7 +124,6 @@ static struct hwentry default_hw[] = {
 		/* Alletra 9000 NVMe */
 		.vendor        = "NVME",
 		.product       = "HPE Alletra",
-		.pgpolicy      = MULTIBUS,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 	},
 	{
@@ -387,12 +386,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
 	},
-	{
-		/* EMC PowerMax NVMe */
-		.vendor        = "NVME",
-		.product       = "^EMC PowerMax_",
-		.pgpolicy      = MULTIBUS,
-	},
 	{
 		/* PowerStore */
 		.vendor        = "DellEMC",
@@ -408,9 +401,6 @@ static struct hwentry default_hw[] = {
 		/* PowerStore NVMe */
 		.vendor        = ".*",
 		.product       = "dellemc-powerstore",
-		.pgpolicy      = GROUP_BY_PRIO,
-		.prio_name     = PRIO_ANA,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 3,
 	},
 	{
@@ -482,9 +472,6 @@ static struct hwentry default_hw[] = {
 		/* ETERNUS AB/HB NVMe */
 		.vendor        = "NVME",
 		.product       = "Fujitsu ETERNUS AB/HB Series",
-		.pgpolicy      = GROUP_BY_PRIO,
-		.prio_name     = PRIO_ANA,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.no_path_retry = 30,
 	},
 	/*
@@ -703,7 +690,6 @@ static struct hwentry default_hw[] = {
 		/* FlashSystem(Storwize/SVC) NVMe */
 		.vendor        = "NVME",
 		.product       = "IBM[ ]+2145",
-		.pgpolicy      = MULTIBUS,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 	},
 	{
@@ -763,7 +749,6 @@ static struct hwentry default_hw[] = {
 		/* FlashSystem(RamSan) NVMe */
 		.vendor        = "NVMe",
 		.product       = "FlashSystem",
-		.pgpolicy      = MULTIBUS,
 		.no_path_retry = NO_PATH_RETRY_FAIL,
 	},
 	{
@@ -875,18 +860,8 @@ static struct hwentry default_hw[] = {
 		/* ONTAP NVMe */
 		.vendor        = "NVME",
 		.product       = "^NetApp ONTAP Controller",
-		.pgpolicy      = MULTIBUS,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 	},
-	{
-		/* E-Series NVMe */
-		.vendor        = "NVME",
-		.product       = "NetApp E-Series",
-		.pgpolicy      = GROUP_BY_PRIO,
-		.prio_name     = PRIO_ANA,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.no_path_retry = 30,
-	},
 	/*
 	 * NEC
 	 */
@@ -1130,7 +1105,6 @@ static struct hwentry default_hw[] = {
 		/* FlashArray NVMe */
 		.vendor        = "NVME",
 		.product       = "Pure Storage FlashArray",
-		.pgpolicy      = MULTIBUS,
 		.no_path_retry = 10,
 	},
 	/*
@@ -1150,7 +1124,6 @@ static struct hwentry default_hw[] = {
 		/* OceanStor NVMe */
 		.vendor        = "NVME",
 		.product       = "Huawei-XSG1",
-		.pgpolicy      = MULTIBUS,
 		.checker_name  = DIRECTIO,
 		.no_path_retry = 12,
 	},
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

