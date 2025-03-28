Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2085.outbound.protection.outlook.com [40.107.117.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DA719D060
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 00:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743122503; cv=fail; b=SwuRPrCUKTfNRYaiZ52F4FCAd7ID4JCsYz872N3MM3K0+FpxWPqV+VAfvUXmESRB4lfvOhKQ8DVH1HgTjsZ081u7kIwuXNxIErisDBXgKUkru8gQfoCcbLd2QoqR1t8A+rm+Q7Id305ofvoaeY8GlrdaiYxvxwFnU+FmK0c4EkU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743122503; c=relaxed/simple;
	bh=YChH37xJmINshIySPWsDvkEa/uNfy7O09NAloLOcmRo=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=P2IBmCwHWEDbn3yHE/SkEUO0+pj9Bf8eoScFalkEDVrHV2Td0AqXgpfUXOpPg3514++tnZULb5+9Axq67T+PfOTj1wn5wlosr7fYRzkM3torZxBFaEJBxIAgA/uilL/FvZWjxbDhOUGhIy2hIXqKfredcC+hMmxN0gRQjIiWIXA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=mqj3BVWn; arc=fail smtp.client-ip=40.107.117.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="mqj3BVWn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pf5+Gmom7YVoV7pcaQuANId3GQn/ff7FRGHEaoEBueg4y95mYDTBFnP2ZG/Ldf6i8j0wtsiIWtMXWfp/toPwdkhFiLpYdD4crFEqUkuIwYOgpetMtPMkKdHGGP0M56DFRsVVqwgUNkX8NGEtInLp1eR7AgwFXE+SVaGJUBRoG+k1/uZvLiws1LVFFRZR47g/s23KMCR2MBlEVmK9iGduIgq7Sul3PVpOu1JX2u1BidWW34fYZiH1zf8R23JtSYYRX7CDLJCu9UsI0zatOIYbxZ+vojJDuqALd7NniqWGm/iV8o6GcCMcui1nWndZNUyDKKKTtccLruR2pMLM1csjlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FhzqfXmjJT5ByfchYQUes8cQodvqpwVpmy7nPc0bVao=;
 b=zMNwconCXJoGORIa6Gdj0uiiigPYjPWMaMzeLRNrrVzHBbMdhTVdXVLemIF3aAvn8RWadhDxkS/kp+odHqCRMu8hC78g+9fCQE2PAfobCBmJ0ZMFKBZSwTuZaDG5RAM0T3EPcKMdq28GyxkJTb8o+dOK8b3iTLL3ZblVhSBmego3YlncD4CZPAt2EE/YDOWiFgaDuJ9cPsbneSPhtLM+wb/1YtndrcTJn5KeElV+qhGuLY6KlfXvQQbVmBs1af3V5Bre6vhkK9Mp6J0rsggGexETItT6cTvHbCIoCZMJw+STcC/2PpIeJEvxCf+QI99U2P6rBn4sjwtOm9Km2tAeJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FhzqfXmjJT5ByfchYQUes8cQodvqpwVpmy7nPc0bVao=;
 b=mqj3BVWnPR0FE1a+S6Xq2Fn82c2Z0HQRvFdILWaPMEipsFP+PfZoAMMSo8hhR4p3VsRN32cKf6tykXDcvI12fMyMWEF2B9iq4VfFJb3bOOQdnxiuKMqjkONbQm0H7F4eqhCLBofTa+npRXdWHIlJPFwtOPZ1xZPnJN3bozM3S4w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by SEZPR02MB7753.apcprd02.prod.outlook.com (2603:1096:101:222::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.26; Fri, 28 Mar
 2025 00:41:34 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8583.023; Fri, 28 Mar 2025
 00:41:33 +0000
From: LongPing Wei <weilongping@oppo.com>
To: snitzer@kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	guoweichao@oppo.com,
	ebiggers@kernel.org,
	bvanassche@acm.org,
	LongPing Wei <weilongping@oppo.com>
Subject: [PATCH] dm-verity: pass correct bytes to verity_use_bh
Date: Fri, 28 Mar 2025 08:40:57 +0800
Message-Id: <20250328004056.2071351-1-weilongping@oppo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0134.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::14) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|SEZPR02MB7753:EE_
X-MS-Office365-Filtering-Correlation-Id: e129e261-9019-408d-4ab3-08dd6d9149ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|366016|1800799024|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7m1TGndflbtz7ip5cxTjWTXeYPyPzOZZM3YPn26KJAn2TA3KD36ZxpqqbX80?=
 =?us-ascii?Q?Rl5frfI00izWPq2lj4P1JMe3pTWlwy1pIy/mQBMC6N5KJ8kjy74oxbRzc4DO?=
 =?us-ascii?Q?neiAWRDDpSER++wXGii8OPamlEJbFwjpZPhQpGKY0rDP1+Qazhm0zlwuXe0w?=
 =?us-ascii?Q?errmjB7rkZ3X2PGiujsu5q8M+RkhYH8moviCa5TC9z1pGk9wKazLbw76ngBa?=
 =?us-ascii?Q?GT91Hp5GLxWRB0qvOtsg2QdTlKMD27KvirGEDLwWGBOwFMNXXOIFgpdMztY2?=
 =?us-ascii?Q?vmFR/dNpzkfSzIYHnbNe4Jje4h656S8C1QxYzYO2nuEKYgGxAhOSiDfRuoKC?=
 =?us-ascii?Q?pzLeAXDy3VNmq8SWko3wC/XvW5sqzfLPeU9/t8C15/gmEWyMC4n+C8tuIbef?=
 =?us-ascii?Q?0HNlkcWagdgKujCaD81umLudEvpNfuhqHiNZfuJHgo20nlLAMCaVeJ/pJsQ0?=
 =?us-ascii?Q?U32VpaMrVnxUc6WSaP4AZ1819vqCCg0cWtw+UMTCZLLH/9vY0MfKGhIRyHDk?=
 =?us-ascii?Q?it0CpBshyYbEkxdb8WV8TH309C/vnl5jrbhT58rpzCsQF1NlFMZFj19ojIOl?=
 =?us-ascii?Q?czI5VnGoCUA6MR7uobOCcsWGsh4JQdlTiMEUa5BI+9Xd5wMjenTzxMDyBaoP?=
 =?us-ascii?Q?YpbiHy5Js5WFyBm1Mb1+XwPdEarMWaXOETdLJ5i78H/DvmMn7nJQqc6xEGK0?=
 =?us-ascii?Q?P5o3ss7KcUMiGfJRb8wDhv+3K7pEDTRUaNfxkyJgEQ3a2i77N121wPf1fofy?=
 =?us-ascii?Q?Lv5c1RhCm6MnaJb/n/bpmSAC36xr/f5nvrsT+BvZlgsa5PeVKCm7Tgrxaufx?=
 =?us-ascii?Q?aeEHOFeLjwrXt66bGYUEKFGsF2PPhulq/StUg33U5WHwmLweRiB8Sild8yhH?=
 =?us-ascii?Q?hmVlZhDi2T86SzQHyGkWDrD/+M7Czsirp4zA9Y14eBbeBdQqMaTYwywHN8vd?=
 =?us-ascii?Q?70Bhqfq9E6p6RbEQbLExDAhcnqKvmNeeMb1WFTawZvII3DES7Ri5qY0Xa6cB?=
 =?us-ascii?Q?69xHyK61E5GEEZeJDpvxsini5FcZo5Ch+6RuVE/yzL1Wi64J5g/8Guf20ubi?=
 =?us-ascii?Q?5I0l7+Auwkk3E3l5howBqKlsPntxk/3q+7cKe3sQo8sJJAxhZ9UbX/brcXd5?=
 =?us-ascii?Q?PZu3kmYBEbeXuhxwawPW+lMJ50/boJWo/qOylmYu1Eo7/urtLszvwzroza4/?=
 =?us-ascii?Q?PrJfqitYlXnM4sgwlu80/trfigTB2vXk2XuNPjDt4nKMqXXqpXgNHV57DGsA?=
 =?us-ascii?Q?bdcfA2gLIQHgQ+hzc3mLRnDxMhUe0g+CoNKnlHj7H8LAzwFCdONSuirYd8dP?=
 =?us-ascii?Q?wYL3mrgzxZr3nsbzP0K0X8nRzDXKLekCCPrqruDVjvcGHiZl9Zoh4nODBisf?=
 =?us-ascii?Q?vuVf2YAls8Ek1MWd0YyVu/NydXZpGOBStDW75v++MtMzUK2RG1Kjw1zag78/?=
 =?us-ascii?Q?/Xh4vk/6vfENJT0tqtHvX8MEAqQEDi6B?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(366016)(1800799024)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Upvkwn5JPwxrTg1jtJ4TkhoMMfo14evn2+Lh6B0Np/Xc4AORmJnlq0b3f+ik?=
 =?us-ascii?Q?Fg9oX/G5RUxKT9/I2darB/Pqqoof5zVDGoo8Tx8uy+Bd2yMI64UApCon5sOj?=
 =?us-ascii?Q?TDf9hHTVVrKzklazGp0k/yVgWcGemtd6IkHiDgZCu6lliEOK4cRyIAT7b5zS?=
 =?us-ascii?Q?N8uMbh98PtwLJ+PnYT1CNFweD22cUpkUAvwxXkSeY3HTvt+aiW8h/c2GlyT1?=
 =?us-ascii?Q?FIXYacSlIqozsRQvfmTMU6wORPF3wt5kpmqKSShuBYzKyvRes0qFMzLRdV5b?=
 =?us-ascii?Q?kePo2thoREdvqZWx3cApUu25fPPYvq+oHcwtdzg7TnzfzcBxrvVtHclM4KT5?=
 =?us-ascii?Q?rm+71CL3BpdTBGhCxL0nCSyAEt6xkkXM7fIIsNO18COXUMYZTiDD3Z+7BFnN?=
 =?us-ascii?Q?QlAd1ldkS/t4ACm89SAlVmB631O3U65aPD1iDjBI12Cq6juG6Rfv1umfUgvw?=
 =?us-ascii?Q?7CO6NYSOxaG7lL8NTrjn9jvRh13ERtUpvowPwT4R4FcArFW+PRYlNBr2Dkev?=
 =?us-ascii?Q?JMnSzqZfRSNerYXaqakbE5c0Nk2TS1Wx+zFONS0y/C/31f7diAz0DiNiX6HI?=
 =?us-ascii?Q?/Zd5Sp7vdxPj8UR+RBkX7vlCPrG5jMVtcP7lPXDxKSXoWYExT3C5wurQIz/3?=
 =?us-ascii?Q?Q17jJaJ8gajUcP8tLHsuvMu1eN9CFzC0wrwL2kiaMW6TFmIXn3j4VBizlMRT?=
 =?us-ascii?Q?WvlO0OACmYYAxARoofOkQzH3jxJuvkO5lYkHml3EdpITaxdgTEAWqEMAuU5R?=
 =?us-ascii?Q?1idil5huJPR0PltO9g0jBqGWWVopWmVD0ghsvM0+Qs9C7uqSryAp//7buqZf?=
 =?us-ascii?Q?pMY+QDnCvuWZXEMhHO8LLd9QRMz/tNcBaBa79j6YA5ZLVkCmQFtqK1hxQCJe?=
 =?us-ascii?Q?FHGkNC2qaMUvR2risglclTP1hVmm4IJFVcKahXImKQm7d9GEVlWuzVKpplJu?=
 =?us-ascii?Q?5b8QME+LLwdmT08CL/1SdaDfUaP1UYmOKISyhNXnBp0Nw4FVtxa+VdiPQAJa?=
 =?us-ascii?Q?wPKCSpu+C0CFEoc+KEWgeLGzN7KK1A46wpD2Sk2OEN6T6muFmne4YGpq799U?=
 =?us-ascii?Q?b8xDC5Hn26HtZYNUhYQTj0N4SgzCfrBIrDJ8aCTDI3ypV76FjchltzG0RshM?=
 =?us-ascii?Q?6+0XZSoNfp0ihAhyWO2ca5qfmproKITi8qhtoIDGtt1SsdMreMa4o4R1oRyI?=
 =?us-ascii?Q?gFiWcp0es/zX8KUpFkKy6mQXyx7DHS4QYaSWiMfBhavX6riekpQpYJS0J+QM?=
 =?us-ascii?Q?bSTS1QtRi36uKQLyXEKqsgr7p0unAVVeJj9Iqs3WLaTh+gcQuRgeMZlKqqA8?=
 =?us-ascii?Q?G08oiQUMi+1qTtzYx04hBOvRVBo8v4Mj9nvTPV1nI2CpdpKu0nBaey3LWqsa?=
 =?us-ascii?Q?Z1Cupanisc+yhcBH8Zs+fpvLzvcIK69SC9cIe4VoAxH7b8ji4b7JEaPW2tK9?=
 =?us-ascii?Q?z9xIWD4nPJsxLmaaK7PW7Z+BFSXJCcfsUCFo5YU++/EOtuC+xn2tVnCVV2Nd?=
 =?us-ascii?Q?nzsCkmf7k0KLQc9xECg++Z3YFJ3hBZW3HVsvj3NwMQBpZrdXi/4fQbLOPj0Q?=
 =?us-ascii?Q?Vo0fnSGaJErUqinFXDRWP/00mlD1wUkNIgV3SGMu?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e129e261-9019-408d-4ab3-08dd6d9149ce
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2025 00:41:33.5279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HA64CVICI8aKmBtNaAToibsQ+AEDBoegCYHAmPju1PDnUDi/3xLTl/WDnA8feanofYqD9xuPRnRvW59wqEm9Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR02MB7753

bi_size is always 0 here since the iterator was already advanced.

Fixes: 8cf3ae875ee4 ("dm-verity: support block number limits for different ioprio classes")
Signed-off-by: LongPing Wei <weilongping@oppo.com>
---
 drivers/md/dm-verity-target.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 2ed10b4c63c5..40448a8c74b1 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -689,6 +689,7 @@ static void verity_end_io(struct bio *bio)
 {
 	struct dm_verity_io *io = bio->bi_private;
 	unsigned short ioprio = IOPRIO_PRIO_CLASS(bio->bi_ioprio);
+	unsigned int bytes = io->n_blocks << io->v->data_dev_block_bits;
 
 	if (bio->bi_status &&
 	    (!verity_fec_is_enabled(io->v) ||
@@ -699,7 +700,7 @@ static void verity_end_io(struct bio *bio)
 	}
 
 	if (static_branch_unlikely(&use_bh_wq_enabled) && io->v->use_bh_wq &&
-		verity_use_bh(bio->bi_iter.bi_size, ioprio)) {
+		verity_use_bh(bytes, ioprio)) {
 		if (in_hardirq() || irqs_disabled()) {
 			INIT_WORK(&io->bh_work, verity_bh_work);
 			queue_work(system_bh_wq, &io->bh_work);
-- 
2.34.1

