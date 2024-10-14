Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2099.outbound.protection.outlook.com [40.107.22.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2EF1D554
	for <dm-devel@lists.linux.dev>; Mon, 14 Oct 2024 13:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728913797; cv=fail; b=WTZb8Ofq/sGeJX+UwhhUglTRmYyhodjHhNthpWss7I6e8OvdDJTZSpmaP6sqVhe/RcMouUG7CIZkZvY2sC14cIxbTbj/pX0IePuxHZS8Uv3UAeKT1s09pRVkPyRuyvM+Fa7mhLSTjzkyizRzDgy2e0cWpt6XPivQq7CDWKcxx7k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728913797; c=relaxed/simple;
	bh=+XshVtkwJM50XhOp8RJfMRFB4yhR2nIESrgmA/fL3YM=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=kuPGmHpZiWMAWO6kx2d75BYwV0t3+7nQoTUjjbWLDlHPAlkSGHfszT7ojEDIAcZ1NmRUcxdyRgWsWtUtp5Ng9KhqjAYTw9LSx4MMxt59eq/4MH39Nog4K0kUC1xkGZELFIGcwpTwnIdLIM3K/nDIL57r4m4BVc1GczxkNkYwGB8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=oxQm2jxJ; arc=fail smtp.client-ip=40.107.22.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="oxQm2jxJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EOl/eeuvYLzJMqAqTjstrGSfa/SeHwY23gVRsfYeWZB74qKpk8KYMhVmdp+MC+FC92mXr2vHpTl99r3x+yDhhftAAVUz3PeJJiEnhzW9RSR4+NQ1dj723PE1JCrt6FIHT71VvWJ0Vm2yU5Kl0jMT7bSfksJSiz0q4QEIbnHudAKKHRk4EiH/UspqUvfDkyntUF9taqyR6xmMqEwmfAY4+gS08jLxyc8h2gGqSBjNeNPcOr9Fp/ms//jieu6q3p81G+Q+G2UEMn0J62kE0kT/mvqmBqvbnJdKsbhpqJIUezho8psLi1cXkLihaKSNJ165cxK/XS5wosJEbUpmYSA51g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yZhCcredzEC5Ptza90LFn4d+jGdzuMzx36DmD9TBbdA=;
 b=PAdFFKZdaPz2CrQ8e765S9NLivuPEnJizCZsaIpY3dqSfLp/2CU8HcWY/GNDgLSQPzCDxABIONvV8Z1DThLB+T2oI4FCkFJraDF801tr6TaUAtURatxrhua2S96vYY0qpqNtrt+Vo2GSyF/foHX77z60Lb7CkHsFPDvndNkUGj/3c+1Bv+pOkQ8ud69dKew34j5bb/i1FPsiSuG//tbFHvZ+OY+Ho73ZCSVRxt3FBzEP4pOg3ZbdeOvAovE+TloYZQDXnzoaBzr4sVURoZ9kli/fR74SSWRktBYji1Qt1VKxVgThK3hfIXmWCjcmXtBtNwMf90rePwwOMz8BXdfH5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yZhCcredzEC5Ptza90LFn4d+jGdzuMzx36DmD9TBbdA=;
 b=oxQm2jxJSvPW0cs5HZbW7/EFTqX004FsJ7RWY+KXXgKXi49CNmxo9EJ53Cn3sqF0/W11TnP1NjO7o0pfLx2vpt0/fRihzHknafEPtvWFUt8VfnFDYRy4aPh5b+nLdrNuJcdBsd+QnJ45Mxf2ppqHkUlTz02rvsloNOevi+cMmLPh8PPoHiGvYo1nbyhHTnKVrlwgiejWMB05FBy2hdJ8gvY/4Z514GZVW0r9HGFTStBvH8cI9KO6quXx4NCBIrnMmFmkAfZ7h6Sjv/Rh5ecEFVy0r85dFdkTINfcaLHDURVASZ1jCGcOj67fB3Mu33TqByOQXW/zS7u8kVRJlfvVTQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from DBBPR04MB6297.eurprd04.prod.outlook.com (2603:10a6:10:cd::14)
 by DU2PR04MB8567.eurprd04.prod.outlook.com (2603:10a6:10:2d6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Mon, 14 Oct
 2024 13:49:52 +0000
Received: from DBBPR04MB6297.eurprd04.prod.outlook.com
 ([fe80::193b:a2c:45e8:4b4b]) by DBBPR04MB6297.eurprd04.prod.outlook.com
 ([fe80::193b:a2c:45e8:4b4b%7]) with mapi id 15.20.8048.020; Mon, 14 Oct 2024
 13:49:52 +0000
From: Meir Elisha <meir.elisha@volumez.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Joe Thornber <ejt@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH] md/persistent-data: Set tm hash size via a module_param
Date: Mon, 14 Oct 2024 16:49:44 +0300
Message-Id: <20241014134944.1264991-1-meir.elisha@volumez.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TL2P290CA0024.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:3::8)
 To DBBPR04MB6297.eurprd04.prod.outlook.com (2603:10a6:10:cd::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBPR04MB6297:EE_|DU2PR04MB8567:EE_
X-MS-Office365-Filtering-Correlation-Id: 9755e843-dbfd-4127-70af-08dcec5713d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?m1vUb1bNmnDZZo0o8S4MsUM2P8wygaRj0Q6fcqEQTqED+vrW9F5Ua69utm/f?=
 =?us-ascii?Q?Z0ao4rhNoElGjrTibDo/miWFYJ7jJOxZvFFyGcZ4LXZXdkU1jDXT5UQOBvxE?=
 =?us-ascii?Q?HUEqCj96yIgDa/IeaPgE+H1GIUDdGDSX3wxYWe4mgVtsAuvanY/2ufq0cB0o?=
 =?us-ascii?Q?c2/aHUvNGqWcD/Y4JksVi9dMXZqnXYIJDqhRqvyVVuqoZS8vuYp9squq+xW2?=
 =?us-ascii?Q?OWWkj92MPgKIxVNHZMbTxAafeW+uOYqxMmgfPp4AHncLmIWcmt1DNgbJhaX8?=
 =?us-ascii?Q?KEfB6Svu+IMvWItL3tFffbfAEbi9+N0rhZrodhRWWn2Oe/e6EA+uABaBii1Y?=
 =?us-ascii?Q?QRIs/p9pnFBCRGKcijQdiBCOo9jwSGAbgVSu9cDBhuhvvWJ42gQ9gcaR8LUh?=
 =?us-ascii?Q?QFPZuux+6ifmZKroAForIfS41awEMafcEQQKlbkhRy5zEAQEmlOPbvVkAez1?=
 =?us-ascii?Q?9JcrN/zROQ/ps7dyXHelGPMmzuRwPQbtGCNJPsEXsBvYl5ru0zcSF576S8gG?=
 =?us-ascii?Q?InqRhcVsP1RHVMuY00f2hRm+xT4zRd5Ys51f//Ux5Qi5xD83YPEUrG+UfNCO?=
 =?us-ascii?Q?N8hZNkKPllqJf/aOr7Xs9cJwKrEpa7xh3ntcCM0KGwB8VVCdpD1SnjX4y+NM?=
 =?us-ascii?Q?Ou8PNrs2WNtJmk79h9V/AwzNq1wKckmDpBf3hreb0e7aKyGLBGwbQIgaeB50?=
 =?us-ascii?Q?1FU/5FJx7lfesb9cZtgZ+ty8EtMwdL1c5p5NoEs0KW3hSSEd7DnNyI/OK95m?=
 =?us-ascii?Q?3OfXWHOqUqO39EnOETbRCd9uX6e903EFHvAYo4NM6REV6GVYNBVur54DHWR7?=
 =?us-ascii?Q?i9zy280LSbPOvFmDFR9FJdVWVLA3ebQP6C0tfVnNqkxLOtFC20uwSWNiKBvo?=
 =?us-ascii?Q?ua9lkJ+Z2qvUCwo8l00WMQ5Uewdz5iCwLBdLZPv7gaGsKYBp5/ovaeJupjAU?=
 =?us-ascii?Q?SBtoMvQDZkcftMrc7ivdEW2qOdIkWCgSSMUtHaPOnuxy4ckI5WJiB6NM1mc7?=
 =?us-ascii?Q?TllSI3V8lZN7MjQF154vLkP3DOwmR7o9nadRjPim6XGZveRClccCvD1PC2k8?=
 =?us-ascii?Q?jRKRK/wNlaTfdYH4SKdTMpmbzRMY6EtdQ4aawCzaswRFJFdkAN9ta7I9KUAC?=
 =?us-ascii?Q?ZUONAxFpzQgTCYZafLN+w0QZHD8I2Erako2HHYHvrtaEjQFHtHWPmNkik3b3?=
 =?us-ascii?Q?9GuAH63N2B1fBJaQoSPkjfaj7yIFoWpmsc35Ou2+J2uVsy735SKohe0wXJod?=
 =?us-ascii?Q?eZRKZLKGSAg3CnAhp5QD9OAf4g+vuOP8zq9QZFpwGpBMxnZe11F6x54wTYB6?=
 =?us-ascii?Q?k/XWL+HdOomle8M0r7EsHkOuAL3q3AJerESOU6Ayd9O6gw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR04MB6297.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ohsbgE8g2/fhG1dR20YhCF3oeWOHedpihTzclFZrb0lglLEJc7TD1o5PttXV?=
 =?us-ascii?Q?1KrUFILokYcdOiPq3rpFIHeczAbYprgNk0s0f4goYwXHw0ZHp7BP2OLM27WF?=
 =?us-ascii?Q?gJDVR1KU6cgNLzQjncbb+bjM7d1xpdcftR8CKzUqlOuIB5Q1uUTs01yZc1Cx?=
 =?us-ascii?Q?SYYD2WH6FgxrBCrlnfy5jeeBqv5Kr7MIfs1yh6IGc3YlEYb2cSx8kqGBGDr0?=
 =?us-ascii?Q?AFnX5osSn8w92LVSkDXCdcviMasvQhPsZ6LT6O6dZn2cu7tetSBaw/kGdC6g?=
 =?us-ascii?Q?nRQqxTo6/UvAehCcqYp1beX6AeT2rS9C/bYn4qbmrxZCze9MCnoSypCr+XOW?=
 =?us-ascii?Q?K52+dwlTi/zhuAMLF33gs1EfKMKRmqh1S0OKsXd43NGe9ZJW/WpI8/mbeDf9?=
 =?us-ascii?Q?Yc0kvY9aY9EZjuYnTC4SRizXbiY0GnWVF+rbUcvxB6Gk+9KviSSYPrc25UEO?=
 =?us-ascii?Q?q1DckK6KI71klRyW5r5EbFeqe7v+rMGGQj6SP2Wi2XTOnWugHubPhIhXsO92?=
 =?us-ascii?Q?M3jJBfmK2gBzN83OLQNpvnGVX8bDeCXqzUBSLBldjK1jdiN2/DfsP5w2ub2i?=
 =?us-ascii?Q?v1gk/mWzfHSPTdR03IQT/ApRsi4i2AOijH2ua+mWHQk836EYtYw5wBRcMb3+?=
 =?us-ascii?Q?lelxoQJ9OK0Uq1VzcTrPWuVhJPWs4TBxNlwtKIT1fXlEiBd1blYCpgn5ADUH?=
 =?us-ascii?Q?HlVX/CuVnXOUIAUzWKNMHukkQgb+H59NgLedWvRPN3ghnElstltmPgPLtGr+?=
 =?us-ascii?Q?7ggeFX6FnQ2YZrbI7mzK+wDEdctKZ+6lvkAweV0wW3rlmP3FK4dTSC2KUTOu?=
 =?us-ascii?Q?mO92lGqzO3rgZG4CRp/I3IqUghy2/0vf0Y32aib0rPQxOFgrp5PZO8IQiP57?=
 =?us-ascii?Q?sBy4wKEtsotxKY3zjxPB1Plwp29y8IK3Zcm3ATXwnCslnMb24ogdeSoA5BtQ?=
 =?us-ascii?Q?YqjzlTtIW6f197UVhn6/Oo7e/apw4tKrqXhOTV8Pn6WA22VZLs4y4Z8Fp7yN?=
 =?us-ascii?Q?6vXPopRIfKJRBLpVG8E1zo7aDfYFHVzTSfNyNFhJoxi6O0j9bY++eQGREnow?=
 =?us-ascii?Q?/t22+lqG5Z0VeO73AVhP7HlXQmnnOlMdSLgPAfzmULQEFeKxtLUXxusJe7T8?=
 =?us-ascii?Q?nCheSUAS2awaOFDsDjGlgnjVoPHK5FLIi1onJJFkocZ0iPvWqYCkTYStr6CM?=
 =?us-ascii?Q?iXLzdt651bu0QEx1NEB6eV8k2oSAyqK0vwa92fGvGeb9UECSypvQS94yOCP2?=
 =?us-ascii?Q?tZ4pGpYepM3sfi02I63VGYBcfG+1Iw5hyZlFOWjjAscPfMtkGPzAKLpsPhzG?=
 =?us-ascii?Q?644GCWrrbaQTO+u2KbOe1h7p+sqwMe6w7CmQY5Pp4J+DLNJlAtysb2aTBCpQ?=
 =?us-ascii?Q?D1I4CsVh8+M0wcFZEh3CxauWDe9gEn9YH20C1zWJ4/AQaGoySgQRULu3sTT3?=
 =?us-ascii?Q?tA/DFW6FKS2KwDIeIkidFUJge4ay3o01JbXDV10kK2MEIkDLSoPIewOMzkXJ?=
 =?us-ascii?Q?tHI74UWd/NCL8lhk/h2HyQMsv/3JFiIZU25+LFBeDaIIXRKMyK0uZi+W/u+h?=
 =?us-ascii?Q?yZ2x1zW9A6WlrH+Qpmpz44TzIJeJwnSVOuLkBgod5XPnyPHbCQXEEGUM6bb1?=
 =?us-ascii?Q?JQ=3D=3D?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9755e843-dbfd-4127-70af-08dcec5713d3
X-MS-Exchange-CrossTenant-AuthSource: DBBPR04MB6297.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2024 13:49:52.0164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oieZMDCd1eInvWKavI5lnmNVbSn00vEe0T3iBgzbP7xV+5lS2y62jrcS9+VYhh04Arbm11LHF7og4yB1V9Hf3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8567

Enlarging the hash table size can significantly improve transaction
manager hash operations. This commit adds the tm_hash_table_size
module_param that sets the hash size.

For demonstration, I've created a thin volume, filled it with 4.8TiB of
sequential data and took a snapshot. then, I overwritten the volume in a
way that caused a maximum btree nodes to be allocated. I've repeated the
process for 5 snapshots and measured the first snapshot deletion time.

When using 128k hash size (instead of the 256 default value) I was able
to reduce snapshot deletion time from 42min to 4min (10x improvement).

Signed-off-by: Meir Elisha <meir.elisha@volumez.com>
---

Script used for demonstration attached below.

 .../persistent-data/dm-transaction-manager.c  | 51 ++++++++++++++++---
 1 file changed, 43 insertions(+), 8 deletions(-)

diff --git a/drivers/md/persistent-data/dm-transaction-manager.c b/drivers/md/persistent-data/dm-transaction-manager.c
index c7ba4e6cbbc7..8d486b1e6693 100644
--- a/drivers/md/persistent-data/dm-transaction-manager.c
+++ b/drivers/md/persistent-data/dm-transaction-manager.c
@@ -10,6 +10,7 @@
 #include "dm-space-map-metadata.h"
 #include "dm-persistent-data-internal.h"
 
+#include <linux/moduleparam.h>
 #include <linux/export.h>
 #include <linux/mutex.h>
 #include <linux/hash.h>
@@ -84,8 +85,35 @@ struct shadow_info {
 /*
  * It would be nice if we scaled with the size of transaction.
  */
-#define DM_HASH_SIZE 256
-#define DM_HASH_MASK (DM_HASH_SIZE - 1)
+static uint tm_hash_table_size = 256;
+
+static int param_set_hash_size(const char *val, const struct kernel_param *kp)
+{
+	unsigned int num;
+	int ret;
+
+	if (!val)
+		return -EINVAL;
+
+	ret = kstrtouint(val, 0, &num);
+	if (ret)
+		return ret;
+
+	/* Hash size must be a power of 2 */
+	if (!(num && !(num & (num - 1))))
+		return -EINVAL;
+
+	*((unsigned int *)kp->arg) = num;
+	return 0;
+}
+
+static const struct kernel_param_ops tm_hash_table_size_ops = {
+	.set = param_set_hash_size,
+	.get = param_get_uint
+};
+
+module_param_cb(tm_hash_table_size, &tm_hash_table_size_ops, &tm_hash_table_size, 0644);
+MODULE_PARM_DESC(tm_hash_table_size, "transaction manager hash size");
 
 struct dm_transaction_manager {
 	int is_clone;
@@ -95,8 +123,9 @@ struct dm_transaction_manager {
 	struct dm_space_map *sm;
 
 	spinlock_t lock;
-	struct hlist_head buckets[DM_HASH_SIZE];
-
+	struct hlist_head *buckets;
+	uint hash_size;
+	uint hash_mask;
 	struct prefetch_set prefetches;
 };
 
@@ -105,7 +134,7 @@ struct dm_transaction_manager {
 static int is_shadow(struct dm_transaction_manager *tm, dm_block_t b)
 {
 	int r = 0;
-	unsigned int bucket = dm_hash_block(b, DM_HASH_MASK);
+	unsigned int bucket = dm_hash_block(b, tm->hash_mask);
 	struct shadow_info *si;
 
 	spin_lock(&tm->lock);
@@ -131,7 +160,7 @@ static void insert_shadow(struct dm_transaction_manager *tm, dm_block_t b)
 	si = kmalloc(sizeof(*si), GFP_NOIO);
 	if (si) {
 		si->where = b;
-		bucket = dm_hash_block(b, DM_HASH_MASK);
+		bucket = dm_hash_block(b, tm->hash_mask);
 		spin_lock(&tm->lock);
 		hlist_add_head(&si->hlist, tm->buckets + bucket);
 		spin_unlock(&tm->lock);
@@ -146,7 +175,7 @@ static void wipe_shadow_table(struct dm_transaction_manager *tm)
 	int i;
 
 	spin_lock(&tm->lock);
-	for (i = 0; i < DM_HASH_SIZE; i++) {
+	for (i = 0; i < tm->hash_size; i++) {
 		bucket = tm->buckets + i;
 		hlist_for_each_entry_safe(si, tmp, bucket, hlist)
 			kfree(si);
@@ -169,13 +198,19 @@ static struct dm_transaction_manager *dm_tm_create(struct dm_block_manager *bm,
 	if (!tm)
 		return ERR_PTR(-ENOMEM);
 
+	tm->hash_size = tm_hash_table_size;
+	tm->buckets = kmalloc_array(tm->hash_size, sizeof(*tm->buckets), GFP_KERNEL);
+	if (!tm->buckets)
+		return ERR_PTR(-ENOMEM);
+
 	tm->is_clone = 0;
 	tm->real = NULL;
 	tm->bm = bm;
 	tm->sm = sm;
+	tm->hash_mask = tm->hash_size - 1;
 
 	spin_lock_init(&tm->lock);
-	for (i = 0; i < DM_HASH_SIZE; i++)
+	for (i = 0; i < tm->hash_size; i++)
 		INIT_HLIST_HEAD(tm->buckets + i);
 
 	prefetch_init(&tm->prefetches);
-- 
2.34.1

Script used for testing(assumes PAGE_SIZE=4096):

# Create volume group
vgcreate --physicalextentsize 16384k vg1 /dev/nvme1n1
# Create thin pool
lvcreate --yes --extents 320002 --poolmetadatasize 104860412 --chunksize 128k --thinpool tp vg1
# Create thin volume
lvcreate --yes --virtualsize 5868826560512b --thin --name lv1 vg1/tp

# Fill volume with initial data
fio --name=write_data --ioengine=libaio \
        --direct=1 \
        --randrepeat=0 \
        --numjobs=1 \
        --bs=128k \
        --filename=/dev/vg1/lv1 \
        --size=4800G \
        --iodepth=8 \
        --rw=randwrite

for i in {1..5}; do
        # Create a snapshot
        lvcreate --name snap$i --snapshot vg1/lv1
        # Fill snap tree with the worst case scenario
        # write 1 chunk at every btree leaf to enforce new tree for each snapshot
        fio --name=write --filename="/dev/vg1/lv1" --rw=write:32128k --rw_sequencer=sequential \
            --bs=128k --size=4800G --direct=1 --ioengine=libaio

        sleep 1
done

# Remove a snapshot
time lvremove vg1/snap1

-- 
2.34.1
