Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83F54C77B75
	for <dm-devel@archiver.kernel.org>; Tue, 11 Apr 2023 06:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681195463;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=F+BbdctGVXvrIe25y2hfHlS+twpaY+wd+nMzu25csCA=;
	b=e3mFDVNkC2Btv78hdBNGUXBV0FeN6NWed4nP0/DHwVk3kp6W6x+PyGsMTEjAtcbSneSXf0
	wBqVI/ECmNn+ijNdFE+weAiBV9ZDCDNHG+cAf15EBKPHr/nXCyPMNFIdUfmvZA4vnkghR0
	RtEgH+/oqtccKe0egJcE8Pa2Or9Y/1U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-DMtGwp9-PFuN1-M-xrmTGg-1; Tue, 11 Apr 2023 02:44:20 -0400
X-MC-Unique: DMtGwp9-PFuN1-M-xrmTGg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7ECE3C0F237;
	Tue, 11 Apr 2023 06:44:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B7EF8C15BB8;
	Tue, 11 Apr 2023 06:44:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B73061946A7B;
	Tue, 11 Apr 2023 06:44:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3220C1946586
 for <dm-devel@listman.corp.redhat.com>; Sun,  9 Apr 2023 16:44:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 160981121315; Sun,  9 Apr 2023 16:44:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D8B61121314
 for <dm-devel@redhat.com>; Sun,  9 Apr 2023 16:44:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF1061C04339
 for <dm-devel@redhat.com>; Sun,  9 Apr 2023 16:44:02 +0000 (UTC)
Received: from APC01-PSA-obe.outbound.protection.outlook.com
 (mail-psaapc01on2122.outbound.protection.outlook.com [40.107.255.122]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-ew5O09ntNTeZoorVisx_QQ-1; Sun, 09 Apr 2023 12:43:57 -0400
X-MC-Unique: ew5O09ntNTeZoorVisx_QQ-1
Received: from SEZPR06MB5269.apcprd06.prod.outlook.com (2603:1096:101:78::6)
 by KL1PR06MB6134.apcprd06.prod.outlook.com (2603:1096:820:d0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Sun, 9 Apr
 2023 16:43:51 +0000
Received: from SEZPR06MB5269.apcprd06.prod.outlook.com
 ([fe80::a3a1:af8e:be1e:437c]) by SEZPR06MB5269.apcprd06.prod.outlook.com
 ([fe80::a3a1:af8e:be1e:437c%6]) with mapi id 15.20.6277.031; Sun, 9 Apr 2023
 16:43:51 +0000
From: Yangtao Li <frank.li@vivo.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Mon, 10 Apr 2023 00:43:37 +0800
Message-ID: <20230409164339.60919-1-frank.li@vivo.com>
X-ClientProxiedBy: SI1PR02CA0029.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::20) To SEZPR06MB5269.apcprd06.prod.outlook.com
 (2603:1096:101:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5269:EE_|KL1PR06MB6134:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b9a6bee-380c-4210-c393-08db391998f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: RGRih5u+qWzQolQC13KfZhUBQs7Nvc4g1unf7YYHJJMa5OH8JKtflwKreCToJkr4g2dXfL/XSAXjCLweG2t4CFFK+vTP2/bEJ+xl/gKqLPFfgNNglX14+PtESRifGCW4Ax45BuDhVtkfzRuGlFC4hTNna10xCcDHB+xmEsRr/HQ+zWETIqhv6lGoKr1lHYUFqYJpBisDcgrwSjQrxPyi/zFEg+M5nTCWYTueSZ+Ct7yrBHGmwaezrUEhiQPxE+4mb0UQ51EmoGcjtf1/sXxu7H2XYPoJSJazu9M22cGhZkmv5kB2AXIgziBmMeJ981aKPpNq+UIvcsoNlQ6+2FovX9kAua8EAjuPhTKgTpYsMXGyoCjgSp+s1hc8gN37ERwIMQgcSxB++S4wynKEkSL+LsYHK2yfCsX1tnXwlNf4o0wZ0PzhSxBGKhRPXvrZfpolQzY2HY3ZwfyjIKCeuvaFHywNCdrr9M4Aelg7pDmjG6zmDazKNnDl8RSOpK8LjQbSlh1QHV0/xKEi5JcvJLOiFmadMCSD5sqnEKOY4WJqZQqItYQjWdjnK3t2pm1/tw/BhnUPzz/opIff3XQFsWAqVPclJWJkpqhFHaiGt5UcHJoezwNwWBYffEojJZdeAERQ
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SEZPR06MB5269.apcprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(4636009)(366004)(346002)(39850400004)(136003)(376002)(396003)(451199021)(36756003)(86362001)(30864003)(2906002)(2616005)(6486002)(6666004)(52116002)(83380400001)(186003)(6512007)(6506007)(1076003)(26005)(478600001)(66476007)(4326008)(66556008)(66946007)(41300700001)(38350700002)(8936002)(8676002)(38100700002)(316002)(110136005)(5660300002);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ga0Nn1dbRPSMQPSmO/2RJdUe16ovNLJts9zlEW4tWEKUFk9f0Kjehc2Fy4Il?=
 =?us-ascii?Q?OYoC73MAV/pVZyJoHNRW/lQmEVXqztOGB1uoDJ1j0cIQgK1Qj8KR5zL8UYPa?=
 =?us-ascii?Q?En359aomfFyxJwcu1rzYGzyxcuen35kt3uscOPglMyyWmsJ3uH5CIU2OKYc5?=
 =?us-ascii?Q?Edq6rxf8264k//31xLb+10wc1am4crVk8BpNbSo5PyFeysvq2RcZwi6IJxwq?=
 =?us-ascii?Q?FEg36gPgMyk6DhB3Ea/YcqBPP/EpnDu6scWULmih1x5b4o7+z1exX7jhHxdK?=
 =?us-ascii?Q?hqL9v9RRlFSjANg9W4eMXosp5ckikSDJSrAFQ7xz4Gy+nix8+ZWa2oB8TDSC?=
 =?us-ascii?Q?H/ToziAjIpvnbcbz3+NdI2GfkAabcYYFnZhwr5FS64SABJYxUdS16aaVHyrA?=
 =?us-ascii?Q?16D9Goo+9Q62EeY1NldXfzbIrUk3VYrO4e/Og1jzZ5GhXWKR9H0ZFbUVT2G8?=
 =?us-ascii?Q?oNQo/L8/MUwhi2Ah9ATunWczQujw++rW93F+y5C1nKu3JYAIUa5cK+XWJLap?=
 =?us-ascii?Q?jptEIBxuxgoZHN9kwY27otJWtCCwnuwIZ+zkfxGf9QAc5l/q4XFffnW8q1o/?=
 =?us-ascii?Q?sJKAhGj+091y3oYAQzdtRN6QtgN9U0Oa9qk1kWO7CcVtnNV7r939gnJ1rZCh?=
 =?us-ascii?Q?ioMDzHeLBePcug/bcoRlBTXlC9PXKRx+zFl3Jvc+MbTRyb8O8cNrwEg14GSD?=
 =?us-ascii?Q?sYSgFm9sMTCIoqsDh379yJzBYvzoNSXh0HQ+4w8HRgiw808A1GddVbD70rB3?=
 =?us-ascii?Q?mXPqWLJibUVgLc1TQFnUNQ2FrlmDXmNfQTfTLnMd5WkBCCne9sKSi0av5WQa?=
 =?us-ascii?Q?djrP9AP+lzZqQa0wqbacAsIRo/o9Vlzw6Mkc597OU6dhUIvnXzND0bRZf++M?=
 =?us-ascii?Q?OTASM0EivHt/9dCe3b1F0K2SCup2AnXOfmSwjPL2w2P5BbKy9xLBhYfGH7+W?=
 =?us-ascii?Q?z1A33u8d+56QVeed2xf8CtoLLtL5nMTxtEkVBHNkyWz6lFVDgxLbdtlRPdWL?=
 =?us-ascii?Q?YmI0oi1M/6YqZTqoP5ATlJZEpdPs9hrbS4cwY783t3+eg4qLH6yLdFSgzpso?=
 =?us-ascii?Q?okxdDgaRuSlgBzYz76J6j491FXxQ4yUQKGAs4oGiLKCG9eqNTL3IvdE2jMus?=
 =?us-ascii?Q?KVWUo3wY2IPR+99eDKmo1Nq/BGlTDBtl1KLEO4U+5cbL5PTbqflV/vFZP3b7?=
 =?us-ascii?Q?bdAb+FIMABnVXjnnnU4whsxHdv5BOmr7tDyyBtmwOwm9ys8QXOGOTSYa6zkQ?=
 =?us-ascii?Q?WTCFrxMqV6xohAvRoPF/qMe/yLupRiMyZY54E4U+638b8fEli7343dbhaOiX?=
 =?us-ascii?Q?Iac+3hZO/SEUhP4MPxm/avCcuAE3S1RBs1skX0TVrM1935TK9rbPi3CQwKB5?=
 =?us-ascii?Q?xtGJ6TrE3sSR+5drpc6vWebqXWju1mnH62mGJVR7p8MbwfIMjKt+kV9WeBnh?=
 =?us-ascii?Q?qJA2R+ytdRbOL8P7V2ACFUZI+uLzp+CxvKxhc7uLMsmqzk9p0fJ4fZFYAht+?=
 =?us-ascii?Q?lCtkZjLTSv3yyrxhAV6z661COXy7UYSqYtqst4Ek7BpWtx5R6eiPOmLhv704?=
 =?us-ascii?Q?NnR6v+DmsSpcbO7OFAgJU9RMfZo5rS/wKM4vz8hp?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b9a6bee-380c-4210-c393-08db391998f4
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5269.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2023 16:43:50.9389 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LBdkAGcNo+joB3TsAVEJ1GRwgy7QslVHS+tKexYTsiR47GQCY0a97GqOeSuRjywbU2RrUzLYQ5dHNtveZkicdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB6134
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Tue, 11 Apr 2023 06:44:09 +0000
Subject: [dm-devel] [PATCH] dm: add helper macro for device mapper target
 driver boilerplate
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
Cc: linux-kernel@vger.kernel.org, Yangtao Li <frank.li@vivo.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: vivo.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

For simple modules that contain a single device mapper target driver
without any additional setup code then ends up being a block of duplicated
boilerplate. This patch adds a new macro, module_dm(), which replaces
the module_init()/module_exit() registrations with template functions.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
---
 drivers/md/dm-crypt.c         | 14 +-------------
 drivers/md/dm-delay.c         | 15 +--------------
 drivers/md/dm-dust.c          | 14 +-------------
 drivers/md/dm-ebs-target.c    | 14 +-------------
 drivers/md/dm-era-target.c    | 14 +-------------
 drivers/md/dm-flakey.c        | 15 +--------------
 drivers/md/dm-log-writes.c    | 14 +-------------
 drivers/md/dm-raid.c          | 18 +-----------------
 drivers/md/dm-switch.c        | 14 +-------------
 drivers/md/dm-target.c        |  3 +++
 drivers/md/dm-unstripe.c      | 14 +-------------
 drivers/md/dm-verity-target.c | 14 +-------------
 drivers/md/dm-writecache.c    | 14 +-------------
 drivers/md/dm-zero.c          | 14 +-------------
 drivers/md/dm-zoned-target.c  | 16 ++--------------
 include/linux/device-mapper.h | 20 ++++++++++++++++++++
 16 files changed, 38 insertions(+), 189 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 52615a258e13..8b47b913ee83 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3659,19 +3659,7 @@ static struct target_type crypt_target = {
 	.iterate_devices = crypt_iterate_devices,
 	.io_hints = crypt_io_hints,
 };
-
-static int __init dm_crypt_init(void)
-{
-	return dm_register_target(&crypt_target);
-}
-
-static void __exit dm_crypt_exit(void)
-{
-	dm_unregister_target(&crypt_target);
-}
-
-module_init(dm_crypt_init);
-module_exit(dm_crypt_exit);
+module_dm(crypt);
 
 MODULE_AUTHOR("Jana Saout <jana@saout.de>");
 MODULE_DESCRIPTION(DM_NAME " target for transparent encryption / decryption");
diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 00d18b2070a5..7433525e5985 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -367,20 +367,7 @@ static struct target_type delay_target = {
 	.status	     = delay_status,
 	.iterate_devices = delay_iterate_devices,
 };
-
-static int __init dm_delay_init(void)
-{
-	return dm_register_target(&delay_target);
-}
-
-static void __exit dm_delay_exit(void)
-{
-	dm_unregister_target(&delay_target);
-}
-
-/* Module hooks */
-module_init(dm_delay_init);
-module_exit(dm_delay_exit);
+module_dm(delay);
 
 MODULE_DESCRIPTION(DM_NAME " delay target");
 MODULE_AUTHOR("Heinz Mauelshagen <mauelshagen@redhat.com>");
diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
index 9bf3cdf548de..12a377e06d02 100644
--- a/drivers/md/dm-dust.c
+++ b/drivers/md/dm-dust.c
@@ -570,19 +570,7 @@ static struct target_type dust_target = {
 	.status = dust_status,
 	.prepare_ioctl = dust_prepare_ioctl,
 };
-
-static int __init dm_dust_init(void)
-{
-	return dm_register_target(&dust_target);
-}
-
-static void __exit dm_dust_exit(void)
-{
-	dm_unregister_target(&dust_target);
-}
-
-module_init(dm_dust_init);
-module_exit(dm_dust_exit);
+module_dm(dust);
 
 MODULE_DESCRIPTION(DM_NAME " dust test target");
 MODULE_AUTHOR("Bryan Gurney <dm-devel@redhat.com>");
diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
index 38da4de3ecbf..435b45201f4d 100644
--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -452,19 +452,7 @@ static struct target_type ebs_target = {
 	.prepare_ioctl	 = ebs_prepare_ioctl,
 	.iterate_devices = ebs_iterate_devices,
 };
-
-static int __init dm_ebs_init(void)
-{
-	return dm_register_target(&ebs_target);
-}
-
-static void dm_ebs_exit(void)
-{
-	dm_unregister_target(&ebs_target);
-}
-
-module_init(dm_ebs_init);
-module_exit(dm_ebs_exit);
+module_dm(ebs);
 
 MODULE_AUTHOR("Heinz Mauelshagen <dm-devel@redhat.com>");
 MODULE_DESCRIPTION(DM_NAME " emulated block size target");
diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index 554d234fca18..0d70914217ee 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1753,19 +1753,7 @@ static struct target_type era_target = {
 	.iterate_devices = era_iterate_devices,
 	.io_hints = era_io_hints
 };
-
-static int __init dm_era_init(void)
-{
-	return dm_register_target(&era_target);
-}
-
-static void __exit dm_era_exit(void)
-{
-	dm_unregister_target(&era_target);
-}
-
-module_init(dm_era_init);
-module_exit(dm_era_exit);
+module_dm(era);
 
 MODULE_DESCRIPTION(DM_NAME " era target");
 MODULE_AUTHOR("Joe Thornber <ejt@redhat.com>");
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 14179355e6a1..ebcfb99b186b 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -506,20 +506,7 @@ static struct target_type flakey_target = {
 	.prepare_ioctl = flakey_prepare_ioctl,
 	.iterate_devices = flakey_iterate_devices,
 };
-
-static int __init dm_flakey_init(void)
-{
-	return dm_register_target(&flakey_target);
-}
-
-static void __exit dm_flakey_exit(void)
-{
-	dm_unregister_target(&flakey_target);
-}
-
-/* Module hooks */
-module_init(dm_flakey_init);
-module_exit(dm_flakey_exit);
+module_dm(flakey);
 
 MODULE_DESCRIPTION(DM_NAME " flakey target");
 MODULE_AUTHOR("Joe Thornber <dm-devel@redhat.com>");
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 6d7436d2fd7f..f17a6cf2284e 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -937,19 +937,7 @@ static struct target_type log_writes_target = {
 	.dax_zero_page_range = log_writes_dax_zero_page_range,
 	.dax_recovery_write = log_writes_dax_recovery_write,
 };
-
-static int __init dm_log_writes_init(void)
-{
-	return dm_register_target(&log_writes_target);
-}
-
-static void __exit dm_log_writes_exit(void)
-{
-	dm_unregister_target(&log_writes_target);
-}
-
-module_init(dm_log_writes_init);
-module_exit(dm_log_writes_exit);
+module_dm(log_writes);
 
 MODULE_DESCRIPTION(DM_NAME " log writes target");
 MODULE_AUTHOR("Josef Bacik <jbacik@fb.com>");
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 2dfd51509647..c8821fcb8299 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -4077,23 +4077,7 @@ static struct target_type raid_target = {
 	.preresume = raid_preresume,
 	.resume = raid_resume,
 };
-
-static int __init dm_raid_init(void)
-{
-	DMINFO("Loading target version %u.%u.%u",
-	       raid_target.version[0],
-	       raid_target.version[1],
-	       raid_target.version[2]);
-	return dm_register_target(&raid_target);
-}
-
-static void __exit dm_raid_exit(void)
-{
-	dm_unregister_target(&raid_target);
-}
-
-module_init(dm_raid_init);
-module_exit(dm_raid_exit);
+module_dm(raid);
 
 module_param(devices_handle_discard_safely, bool, 0644);
 MODULE_PARM_DESC(devices_handle_discard_safely,
diff --git a/drivers/md/dm-switch.c b/drivers/md/dm-switch.c
index 5a5976b0cfb8..dfd9fb52a6f3 100644
--- a/drivers/md/dm-switch.c
+++ b/drivers/md/dm-switch.c
@@ -565,19 +565,7 @@ static struct target_type switch_target = {
 	.prepare_ioctl = switch_prepare_ioctl,
 	.iterate_devices = switch_iterate_devices,
 };
-
-static int __init dm_switch_init(void)
-{
-	return dm_register_target(&switch_target);
-}
-
-static void __exit dm_switch_exit(void)
-{
-	dm_unregister_target(&switch_target);
-}
-
-module_init(dm_switch_init);
-module_exit(dm_switch_exit);
+module_dm(switch);
 
 MODULE_DESCRIPTION(DM_NAME " dynamic path switching target");
 MODULE_AUTHOR("Kevin D. O'Kelley <Kevin_OKelley@dell.com>");
diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 9e9871361440..a6381cf376c1 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -84,6 +84,9 @@ int dm_register_target(struct target_type *tt)
 {
 	int rv = 0;
 
+	DMINFO("Loading '%s' target version %u.%u.%u",
+		tt->name, tt->version[0], tt->version[1], tt->version[2]);
+
 	down_write(&_lock);
 	if (__find_target_type(tt->name)) {
 		DMERR("%s: cannot find '%s' target",
diff --git a/drivers/md/dm-unstripe.c b/drivers/md/dm-unstripe.c
index e7b7d5983a16..48587c16c445 100644
--- a/drivers/md/dm-unstripe.c
+++ b/drivers/md/dm-unstripe.c
@@ -192,19 +192,7 @@ static struct target_type unstripe_target = {
 	.iterate_devices = unstripe_iterate_devices,
 	.io_hints = unstripe_io_hints,
 };
-
-static int __init dm_unstripe_init(void)
-{
-	return dm_register_target(&unstripe_target);
-}
-
-static void __exit dm_unstripe_exit(void)
-{
-	dm_unregister_target(&unstripe_target);
-}
-
-module_init(dm_unstripe_init);
-module_exit(dm_unstripe_exit);
+module_dm(unstripe);
 
 MODULE_DESCRIPTION(DM_NAME " unstriped target");
 MODULE_ALIAS("dm-unstriped");
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 260f04d12982..e35c16e06d06 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1514,19 +1514,7 @@ static struct target_type verity_target = {
 	.iterate_devices = verity_iterate_devices,
 	.io_hints	= verity_io_hints,
 };
-
-static int __init dm_verity_init(void)
-{
-	return dm_register_target(&verity_target);
-}
-
-static void __exit dm_verity_exit(void)
-{
-	dm_unregister_target(&verity_target);
-}
-
-module_init(dm_verity_init);
-module_exit(dm_verity_exit);
+module_dm(verity);
 
 MODULE_AUTHOR("Mikulas Patocka <mpatocka@redhat.com>");
 MODULE_AUTHOR("Mandeep Baines <msb@chromium.org>");
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 81b60b75a9fa..074cb785eafc 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -2773,19 +2773,7 @@ static struct target_type writecache_target = {
 	.iterate_devices	= writecache_iterate_devices,
 	.io_hints		= writecache_io_hints,
 };
-
-static int __init dm_writecache_init(void)
-{
-	return dm_register_target(&writecache_target);
-}
-
-static void __exit dm_writecache_exit(void)
-{
-	dm_unregister_target(&writecache_target);
-}
-
-module_init(dm_writecache_init);
-module_exit(dm_writecache_exit);
+module_dm(writecache);
 
 MODULE_DESCRIPTION(DM_NAME " writecache target");
 MODULE_AUTHOR("Mikulas Patocka <dm-devel@redhat.com>");
diff --git a/drivers/md/dm-zero.c b/drivers/md/dm-zero.c
index 884ac726a743..3b13e6eb1aa4 100644
--- a/drivers/md/dm-zero.c
+++ b/drivers/md/dm-zero.c
@@ -75,19 +75,7 @@ static struct target_type zero_target = {
 	.map    = zero_map,
 	.io_hints = zero_io_hints,
 };
-
-static int __init dm_zero_init(void)
-{
-	return dm_register_target(&zero_target);
-}
-
-static void __exit dm_zero_exit(void)
-{
-	dm_unregister_target(&zero_target);
-}
-
-module_init(dm_zero_init)
-module_exit(dm_zero_exit)
+module_dm(zero);
 
 MODULE_AUTHOR("Jana Saout <jana@saout.de>");
 MODULE_DESCRIPTION(DM_NAME " dummy target returning zeros");
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index ad4764dcd013..ad8e670a2f9b 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -1138,7 +1138,7 @@ static int dmz_message(struct dm_target *ti, unsigned int argc, char **argv,
 	return r;
 }
 
-static struct target_type dmz_type = {
+static struct target_type zoned_target = {
 	.name		 = "zoned",
 	.version	 = {2, 0, 0},
 	.features	 = DM_TARGET_SINGLETON | DM_TARGET_MIXED_ZONED_MODEL,
@@ -1154,19 +1154,7 @@ static struct target_type dmz_type = {
 	.status		 = dmz_status,
 	.message	 = dmz_message,
 };
-
-static int __init dmz_init(void)
-{
-	return dm_register_target(&dmz_type);
-}
-
-static void __exit dmz_exit(void)
-{
-	dm_unregister_target(&dmz_type);
-}
-
-module_init(dmz_init);
-module_exit(dmz_exit);
+module_dm(zoned);
 
 MODULE_DESCRIPTION(DM_NAME " target for zoned block devices");
 MODULE_AUTHOR("Damien Le Moal <damien.lemoal@wdc.com>");
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 8aa6b3ea91fa..9d79ce428b62 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -631,6 +631,26 @@ void dm_destroy_crypto_profile(struct blk_crypto_profile *profile);
 		DMEMIT("target_name=%s,target_version=%u.%u.%u", \
 		       (y)->name, (y)->version[0], (y)->version[1], (y)->version[2])
 
+/**
+ * module_dm() - Helper macro for drivers that don't do anything
+ * special in module init/exit. This eliminates a lot of boilerplate.
+ * Each module may only use this macro once, and calling it replaces
+ * module_init() and module_exit().
+ *
+ * @name: device mapper name
+ */
+#define module_dm(name) \
+static int __init dm_##name##_init(void) \
+{ \
+	return dm_register_target(&(name##_target)); \
+} \
+module_init(dm_##name##_init) \
+static void __exit dm_##name##_exit(void) \
+{ \
+	dm_unregister_target(&(name##_target)); \
+} \
+module_exit(dm_##name##_exit)
+
 /*
  * Definitions of return values from target end_io function.
  */
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

