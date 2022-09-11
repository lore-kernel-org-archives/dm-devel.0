Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21E80ECAAD3
	for <dm-devel@archiver.kernel.org>; Sun, 11 Sep 2022 22:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662935791;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uSAd0aBHYFEEel7krgBb8dglxzmmNnD6ZXxhKqf23fU=;
	b=hOUYWoB0rRdeqxQJTVU/JcblSq/QaO+kv703wRQL63UtR7ImGXCn0z/5Gptzt7g47VrA0E
	Fi5HYKM5+OwBaF3nfzqtoqp32cI/oXP8I3F89iWZt4meVdF7j+KyW/NGl8aSmAegixWFFv
	ph1Yv0qvcRD/djM0sLMXcUegDiFbeCM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-58cv024yNC2otoaOlNTUrg-1; Sun, 11 Sep 2022 18:36:28 -0400
X-MC-Unique: 58cv024yNC2otoaOlNTUrg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F6FA1C05147;
	Sun, 11 Sep 2022 22:36:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 971472166B26;
	Sun, 11 Sep 2022 22:36:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 71FEC1946A42;
	Sun, 11 Sep 2022 22:36:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 10C8B1946A41
 for <dm-devel@listman.corp.redhat.com>; Sun, 11 Sep 2022 22:36:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DFF0C40C1421; Sun, 11 Sep 2022 22:36:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DBF584010FA1
 for <dm-devel@redhat.com>; Sun, 11 Sep 2022 22:36:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C546785A585
 for <dm-devel@redhat.com>; Sun, 11 Sep 2022 22:36:22 +0000 (UTC)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com
 [209.85.128.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-612-6nP3uXWzMLi7xtZP5H9SnQ-1; Sun, 11 Sep 2022 18:36:20 -0400
X-MC-Unique: 6nP3uXWzMLi7xtZP5H9SnQ-1
Received: by mail-wm1-f48.google.com with SMTP id
 n17-20020a05600c501100b003a84bf9b68bso6004023wmr.3; 
 Sun, 11 Sep 2022 15:36:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date;
 bh=f7xN3/hKDTT/SS2zGMqJTkYGMnzdDuwQAm7/zAuXFF0=;
 b=BBseY2TtRe4knQSu31oEvYCb1X0M21QRwW6jKmqUArUn5q+Y7oy+xItcqHoSTyeSAV
 ExdS9BUAs+jAqu8iRVKr5g0ctHhgoaxYYVreJstMgIt6AWDA2fNWbOPmTTgZkrQCl6XO
 wVnZuBZ07KY7xwIivkveie8DPymdaY0tIwi3y21C+aSSsrAKiC8oTk3EZn2pT5foN3Wk
 RPy/piEVG1NxjOLjDeIkQP69Jw0yk5etNO1egcxstaKvYzbD8nLO/1yZdhdFzr7SZH27
 l32PTZc2UeMS3w3wiWTu/g0BdGvJtsvoqK4OW1+ynImLxwedvMcvm0NtnROihLkDMTDl
 W0VA==
X-Gm-Message-State: ACgBeo1AL7EYUWmqA+ZbXSrSqHoEh1zD3319N8OE1revgsRBoFZrmYSF
 jz9PCwYGFdAmxhgJiGomLQ==
X-Google-Smtp-Source: AA6agR7tTcb7banX6TmWvlDLaIq3Jw6gulMMchE0RevJruVINi5PdFzxuaLo3ajoxc9K2MD0pSiPUg==
X-Received: by 2002:a7b:c44d:0:b0:3a5:ce2b:5558 with SMTP id
 l13-20020a7bc44d000000b003a5ce2b5558mr11975152wmi.123.1662935779275; 
 Sun, 11 Sep 2022 15:36:19 -0700 (PDT)
Received: from localhost (53.red-81-44-158.dynamicip.rima-tde.net.
 [81.44.158.53]) by smtp.gmail.com with ESMTPSA id
 x19-20020a1c7c13000000b003a6896feef7sm7509078wmc.39.2022.09.11.15.36.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 11 Sep 2022 15:36:18 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Mon, 12 Sep 2022 00:36:17 +0200
Message-Id: <20220911223617.141304-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH] multipath-tools: update hwtable
 text/info/comments
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

delete attributes from template, outdated and incompleted.
delete trivial/redundant comments.
add HPE Alletra 5000 info.
remove empty lines in comments.
compact some info.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 66 +++++++-----------------------------------
 1 file changed, 10 insertions(+), 56 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 2085aba5..d2c92d43 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -33,59 +33,26 @@
 	 * Copy this TEMPLATE to add new hardware.
 	 *
 	 * Keep only mandatory(.vendor and .product) and modified attributes.
-	 * Attributes with default values must be removed.
+	 * Attributes with default values must be omitted.
 	 * .vendor, .product, .revision and .bl_product are POSIX Extended regex.
 	 *
 	 * COMPANY_NAME
-	 *
 	 * Maintainer: NAME <email>
 	 */
 	{
 		/* Product Name */
 		.vendor        = "VENDOR",
 		.product       = "PRODUCT",
-		.revision      = "REVISION",
-		.bl_product    = "BL_PRODUCT",
-		.pgpolicy      = FAILOVER,
-		.uid_attribute = "ID_SERIAL",
-		.selector      = "service-time 0",
-		.checker_name  = TUR,
-		.alias_prefix  = "mpath",
-		.features      = "0",
-		.hwhandler     = "0",
-		.prio_name     = PRIO_CONST,
-		.prio_args     = "",
-		.pgfailback    = -FAILBACK_MANUAL,
-		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.minio         = 1000,
-		.minio_rq      = 1,
-		.flush_on_last_del = FLUSH_DISABLED,
-		.user_friendly_names = USER_FRIENDLY_NAMES_OFF,
-		.fast_io_fail  = 5,
-		.dev_loss      = 600,
-		.retain_hwhandler = RETAIN_HWHANDLER_ON,
-		.detect_prio   = DETECT_PRIO_ON,
-		.detect_checker = DETECT_CHECKER_ON,
-		.deferred_remove = DEFERRED_REMOVE_OFF,
-		.delay_watch_checks = DELAY_CHECKS_OFF,
-		.delay_wait_checks = DELAY_CHECKS_OFF,
-		.skip_kpartx   = SKIP_KPARTX_OFF,
-		.max_sectors_kb = MAX_SECTORS_KB_UNDEF,
-		.ghost_delay   = GHOST_DELAY_OFF,
+		...
 	},
 #endif
 
 static struct hwentry default_hw[] = {
 	/*
 	 * Generic NVMe devices
-	 *
-	 * Due to the parsing logic in find_hwe(), generic entries
-	 * have to be put on top of this list, and more specific ones
-	 * below.
 	 */
 	{
-		/* Generic NVMe */
+		/* NVMe */
 		.vendor        = "NVM[eE]",
 		.product       = ".*",
 		.uid_attribute = DEFAULT_NVME_UID_ATTRIBUTE,
@@ -95,7 +62,6 @@ static struct hwentry default_hw[] = {
 	},
 	/*
 	 * Apple
-	 *
 	 * Maintainer: Shyam Sundar <g.shyamsundar@yahoo.co.in>
 	 */
 	{
@@ -232,7 +198,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* Nimble Storage / HPE Alletra 6000 */
+		/* Nimble Storage / HPE Alletra 5000/6000 */
 		.vendor        = "Nimble",
 		.product       = "Server",
 		.hwhandler     = "1 alua",
@@ -311,7 +277,6 @@ static struct hwentry default_hw[] = {
 	{
 		/*
 		 * Nexenta COMSTAR
-		 *
 		 * Maintainer: Yacine Kheddache <yacine@alyseo.com>
 		 */
 		.vendor        = "NEXENTA",
@@ -367,7 +332,7 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 	},
 	{
-		/* SC Series, formerly Compellent */
+		/* SC Series (formerly Compellent) */
 		.vendor        = "COMPELNT",
 		.product       = "Compellent Vol",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -471,7 +436,6 @@ static struct hwentry default_hw[] = {
 	},
 	/*
 	 * Hitachi Vantara
-	 *
 	 * Maintainer: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
 	 */
 	{
@@ -672,7 +636,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 	},
 	{
-		// Storwize V5000 and V7000 lines / SAN Volume Controller (SVC) / Flex System V7000 /
+		// Storwize V5000/V7000 lines / SAN Volume Controller (SVC) / Flex System V7000
 		// FlashSystem V840/V9000/5000/5100/5200/7200/7300/9100/9200/9200R/9500
 		.vendor        = "IBM",
 		.product       = "^2145",
@@ -757,7 +721,6 @@ static struct hwentry default_hw[] = {
 	},
 		/*
 		 * IBM Power Virtual SCSI Devices
-		 *
 		 * Maintainer: Brian King <brking@linux.vnet.ibm.com>
 		 */
 	{
@@ -789,7 +752,6 @@ static struct hwentry default_hw[] = {
 	{
 		/*
 		 * DE Series
-		 *
 		 * Maintainer: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
 		 */
 		.vendor        = "LENOVO",
@@ -809,7 +771,6 @@ static struct hwentry default_hw[] = {
 	{
 		/*
 		 * ONTAP family
-		 *
 		 * Maintainer: Martin George <marting@netapp.com>
 		 */
 		.vendor        = "NETAPP",
@@ -826,7 +787,6 @@ static struct hwentry default_hw[] = {
 	{
 		/*
 		 * SANtricity(RDAC) family
-		 *
 		 * Maintainer: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
 		 */
 		.vendor        = "(NETAPP|LSI|ENGENIO)",
@@ -843,7 +803,6 @@ static struct hwentry default_hw[] = {
 	{
 		/*
 		 * SolidFir family
-		 *
 		 * Maintainer: PJ Waskiewicz <pj.waskiewicz@netapp.com>
 		 */
 		.vendor        = "SolidFir",
@@ -874,7 +833,6 @@ static struct hwentry default_hw[] = {
 	 */
 		/*
 		 * Pillar Data / Oracle FS
-		 *
 		 * Maintainer: Srinivasan Ramani <srinivas.ramani@oracle.com>
 		 */
 	{
@@ -1015,7 +973,6 @@ static struct hwentry default_hw[] = {
 	},
 	/*
 	 * Pivot3
-	 *
 	 * Maintainer: Bart Brooks <bartb@pivot3.com>
 	 */
 	{
@@ -1049,12 +1006,12 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	/*
-	 * Linux-IO Target
+	 * Linux
 	 */
 	{
-		/* Linux-IO Target */
+		/* IO Target */
 		.vendor        = "(LIO-ORG|SUSE)",
-		.product       = ".",
+		.product       = ".*",
 		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -1107,8 +1064,6 @@ static struct hwentry default_hw[] = {
 	 */
 	{
 		/* OceanStor V3-V6 */
-		// This config works with multibus and ALUA
-		// ALUA is required by HyperMetro
 		.vendor        = "HUAWEI",
 		.product       = "XSG1",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -1133,7 +1088,6 @@ static struct hwentry default_hw[] = {
 	},
 	/*
 	 * Infinidat
-	 *
 	 * Maintainer: Arnon Yaari <arnony@infinidat.com>
 	 */
 	{
@@ -1202,7 +1156,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	{
-		/* 3000 / 6000 Series - ALUA mode */
+		/* 3000 / 6000 Series (ALUA mode) */
 		.vendor        = "VIOLIN",
 		.product       = "SAN ARRAY ALUA",
 		.hwhandler     = "1 alua",
-- 
2.37.3

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

