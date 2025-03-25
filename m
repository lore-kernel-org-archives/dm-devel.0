Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2045.outbound.protection.outlook.com [40.107.255.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199BA1EFF87
	for <dm-devel@lists.linux.dev>; Tue, 25 Mar 2025 10:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.255.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742899836; cv=fail; b=rFAG5CW3E6hWnSccKgWnMO7SRuSNVNG5c/gJPWuhkErPZES3nilLlZBOdJMd5kHxK7YWjvCkrWNKB0a3GPZpXKLt9YwGm6Uz2ffVetU14iL9wSxRt+pEGz5dVC/UNYJwodQmKuMx4qBO/yyegS585bns/yKWNo6yd+6CidP2VB0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742899836; c=relaxed/simple;
	bh=ADRp1/ksyGk9UzABNAv4TJZpLAX7mZ9y1Xv9J86SfMI=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=renQUp9dVeOClJKvhIGSEO/SZveEuY+SyA9p0L1dkYOb76Dph9wn+kbZnAYGnBeffkwvJDekiS8UdQxn8nc2cMv5fGc4aRB5t72Vm5M125FHyyIYOjr8SFUYR2myVMa/GTh/PcSU6Tciucu9AkFbYq1KuI+xU8KypOT2WIGrAyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=J89fmrCn; arc=fail smtp.client-ip=40.107.255.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="J89fmrCn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cRFHWBVHQIR5ZAZq4Zr1Fa15xveLrqyO9Lp8r2OpiJLmN6g3ivhZyEyKGtoV/O/F+CfNTjYNlX+eL6F6bcV8fDZO01tGXhDtsaSvu8ajO+fxt7mVpC8EwlyfcDYc4uop3KL3T49kARrCfjzfm17gFI1UOP1bTARLFtiOWxLY+Lu3noJwISKpxwtyQiO1q8c/1DjX+YVaDu6RTQ0/jSj4biI/Eri/cw9xgB6HPzxjN7pJEh+KXsUUF31XXBbyOqTRz2P78VjnH/draSgbg8iHB9br6eAdDBf10mZ5ftCJ87gqblAD5CdkqP/CH5L5uOud1R0s8rUA6SJPNZ+riiDudA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ISHH3g01iUfhRZjnqXUKnFLiRBBhH8Gg/j1j7fflkww=;
 b=FtCgtUJm+CQGiBdroGm5MMMyzolr6atroqmM9hNp5YmlzlOrLL5GAL0ke/UAOo9S8Aa0ppv+ORXU+YRsq52Za2dhfPazVbHJndaMeCZOT1CVp2uxosGdNFdk7wuNaFCjoiBv7wFmtY+1tXq8sO+Jdy3d8ZPFpna+fBrxDP6KWJYh31nYUwpB0HBAvQph/baT3MlulFZLEFmtmmqPmw/Q16gTQWetIq+onoxL3/UjzNpjnHLWkmB7g3x9hIBj1xltzrRKHn/aBF+Zl786WXtG2Pkzkd4ek/up+vmCA8w7BbaUxceU0T3kw2BiVTUN3sxXBw0Mzsl0vL0wlGjCeCnhBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISHH3g01iUfhRZjnqXUKnFLiRBBhH8Gg/j1j7fflkww=;
 b=J89fmrCn6U98UCIgle8o1Pkd0L1KVtSw2PooT5xHya1HtaC3fZGH3ubsGPo0935Fikpkb6jHWtn9wngOCVFqvH6Bu1NHFfPMwdY7ChiIniOaRLU3rzRdxow0UFqmMEq/fI5TelGiLr77okeHPdeA8n62l3wbgeKNAZiF+1M+snk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by TY0PR02MB5672.apcprd02.prod.outlook.com (2603:1096:400:1b3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.23; Tue, 25 Mar
 2025 10:50:31 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8583.023; Tue, 25 Mar 2025
 10:50:31 +0000
From: LongPing Wei <weilongping@oppo.com>
To: snitzer@kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	guoweichao@oppo.com,
	LongPing Wei <weilongping@oppo.com>
Subject: [PATCH] dm-verity: support block number limits for different ioprio classes
Date: Tue, 25 Mar 2025 18:49:43 +0800
Message-Id: <20250325104942.1170388-1-weilongping@oppo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0112.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::16) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|TY0PR02MB5672:EE_
X-MS-Office365-Filtering-Correlation-Id: aab320ba-20f4-45a4-c44d-08dd6b8adc9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|366016|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LnG/v+eGBudtw9hzaMxEpI3iS/qf615fKIc8FBh4njreLNGH3tPgk0PvqewM?=
 =?us-ascii?Q?oeQd8MRYsk7hUSejtfSazn1SXZVNJs6pUXEiFCpvhPVldhr3fiHqwDsZyHtw?=
 =?us-ascii?Q?M5a49Te0MMNUrUl7fyxBSVVkwXm6V0JC9vqigMQdhNsiQbXMs7WtuMBCDPq+?=
 =?us-ascii?Q?AyiNkeb+ubAJ+JJmNr3MJWhQXjPmI1Yzl1n4T/Ff75zXtraZdUzHsjUPJwRJ?=
 =?us-ascii?Q?hrH1QeIW6rLmH04J6iM2UwOL66mpAPR9BPsRIQ5HpKoAsL9ASjNMS4DWppU7?=
 =?us-ascii?Q?wAlMVI7mG/B+u1AAoqw9PafaMAqQYTPd8K2YteYP/o+Ghh01xTF7DZRr3+gd?=
 =?us-ascii?Q?mMV5J1PsvON+HOu+H9vNRlQiLAlyuxSVlcfHpmL7kh11ErKAadyjGKZC7fz4?=
 =?us-ascii?Q?zV2zs0F5nOhLbHzTqbNKxRjG8CKvk1KkQuEXXrI0bZwLu8bKLfliGlH+P1pw?=
 =?us-ascii?Q?Uxk65wasBxFYdhfCRqR7WWz8dGjsclJNnMICxGvSg4Ac9n1Y9JKTRYmCt7LT?=
 =?us-ascii?Q?Us7qHe5NFGOf1vHW5F1y7pK+kNVMXQci1MI9dBq2XmW6eQHMe2QlNrvlOiQ1?=
 =?us-ascii?Q?xWo4YV9hPpyAzbFXLS+xoa9R+5Ct81aqAl1hqN0AwsMVskRVD4ddgxx/3okD?=
 =?us-ascii?Q?xkS20M5BHrMBEn4bNneK3Cx3cAd/v1VhRMk0ngoaatrISDpvOIv0gi6A75T4?=
 =?us-ascii?Q?bRsCTjHl/DmUDLgHz4Kg1JSJk3tU3NJa38oS18ILgj7gPfIeED+l5urJEOCe?=
 =?us-ascii?Q?hqGBCHkz4iH3Gj34sEu8yHjQmGI9foFiUMCHtT5zYJ9rwiXK972rDg8HltsT?=
 =?us-ascii?Q?+APj9WmxW43k+G3x0zDGYMINzMGPb/Imgrnwbr/vVaW1xjNEyV74+L1hCepj?=
 =?us-ascii?Q?QK/lNSvtzcKUIdMF+AhsJj0E2vl9fQI6IQjURxpSXzHfnn4fh9sfgIZ3Zrge?=
 =?us-ascii?Q?uX41Tu5ZAPfL6o8HuB9dB7hXIyp86n/E4Jr2y78Af9KezoXmAH0AXEWvHotd?=
 =?us-ascii?Q?DnvoIPfryzLhUtQNPNzOL4z4JHL/T9ZLKRDiqUVddOT/OZlkPRObTHw/9HK6?=
 =?us-ascii?Q?VlIKvLnD0a/jTix2NmYrzjK9p+W88/kEOft37NlEU8cLsyHa6XkDBuzja3Fc?=
 =?us-ascii?Q?GRATRqG87eWI2bJvybVY9inVGOe3RB/Yvm+PsSR2pqzJknFDK2cLDgLFoPu3?=
 =?us-ascii?Q?A4R6XSY7UtqlCJ1sXIy/7GUt0ttkVm3cm928xLmT+xDqwwP5wXaBXOjZM/zt?=
 =?us-ascii?Q?E895QfNhjz5HFTELDfvTAUiOBHV9JiF/mCI95LBN+4CnKdRROwckVcR1KUfU?=
 =?us-ascii?Q?Zc7FV7/tU/Ka1UdBX93BYs7HD0KRemjFWMjyFdpyHHrbwHsgw8p3AbkboQti?=
 =?us-ascii?Q?SmNL8z4r/dkeh+ztAikr3qkYKQlfQXGW9cBBFSBL/KfvrVS1YjE4WvOnj1C5?=
 =?us-ascii?Q?63JOdsFNCacdC6/iPuQmacEg7cbIPqgtEFBMOHTvma2Pfps5/GaXzg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(366016)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jjv9Vh/Q4S6bD9Mz1eMkBZ/fosU1ObnXsjZL2fLli6MOr+/HSJ/U90RAg8NQ?=
 =?us-ascii?Q?GKjZI5VFidVFzzMn8+vuX1EVHpDOtF8LKhPTAHFjvE8uWbFOoz5YCnkQLY0t?=
 =?us-ascii?Q?sArshOKWwYISa6DWGGX261MQQy/P4lq0rD084gqlw7P6G0kFy84r1e+lPsCk?=
 =?us-ascii?Q?9MIZLk6GQzrsoRfaEBrdoscZilcqp5u55XcXoNyVRr4k7lhk5nZGJcEjwGOK?=
 =?us-ascii?Q?LloFiDRmi6yP0fSkQp/9T4oA3WY49V3uIoYJnP9Tpxhv6NTnbW9X6xiSN5IZ?=
 =?us-ascii?Q?0OnRkNuZ/SS2aVBpiYSQR4CyAQ2CVZTezIYJZorIpC0Tgm3vD7utikNa0t7e?=
 =?us-ascii?Q?Ro74Pqn9/5bMKnE2Cl7T1wQFVNJalNhAUNXQ7X9Ry1oASwO0/eHP+kxfW3BS?=
 =?us-ascii?Q?yhSY8Ktdhrd10fBKNuvLTwOmwalKTf9UUKf2KIYEOd1d/9C7p25SmajfrINr?=
 =?us-ascii?Q?bBEST4WnQSyzhwcM0m/2IahDWTTvgwPZcUoCNgYRSmxe8W7eERenBN/2KvcO?=
 =?us-ascii?Q?CRMND85HmeBdR3XPkz0/ZtD4Is/dbfgAOCNJNlIqulLbRLIJrxqp2xpKzZHd?=
 =?us-ascii?Q?sRop51afaj1ENn4Ygw359JwVYzWUaimrjHMW4/FVI9BL5hO+TSdno3+Wh2Nk?=
 =?us-ascii?Q?rFD/YX2hVfOc9Q3RESw6m/XetWKqExu/sFxHdTD0mpZdd0pEVQt3KdIIHsAy?=
 =?us-ascii?Q?Ez6VkGxc7SODHoovwwDdugiZZM64Cukg0Vl6EnennCsDLIKQU+op9tV795sq?=
 =?us-ascii?Q?eud00/rlJYpgkP09obxVrKp+WdtNFSL8XqpCAQnfG9xltuVYjrmxTG1g5asC?=
 =?us-ascii?Q?3NLp0YL/tB36vJ3WLegs4t6z/BU67ToMJS86gDFzQsbLYjD/f5tzm1SZc5il?=
 =?us-ascii?Q?cXmhmd0CWgcD038FS1OnYb0HBqjxHHaAu8ScTH5IShX1Nog+ndt5OJayC5y2?=
 =?us-ascii?Q?zE7zQZj8+4AlSK7kOW5jHDtuNsrMtqGsgltIUCtcruUI37Cc/RC2c6pd07pa?=
 =?us-ascii?Q?0ToFXtRqMGKHOE2GStEwqRworc3xg9XuVJs6/sbknMJBNdZkUDXHVSp9gOtm?=
 =?us-ascii?Q?igfHZNPrpW0N0QVRaWRLoAqmc/KLeq2t7wZGcKGvUoCsKyPoBCrAA/k3sFfw?=
 =?us-ascii?Q?k8cXm/kcHthx3dYdBQYOEQBEJS7xOihafCh1YNCboCPM/jJmLKBWEIKrnLiS?=
 =?us-ascii?Q?i2XvUag5IbyHVb/a3A6x0JlriMLt57POGvY8j2DUUge9H2m5vLVRb66GKhJh?=
 =?us-ascii?Q?gcuuk/+GqT+ebuYZsTUTVu83JSt1vXovMOSn4lNyrkkiErIMrQxutQTmTLbI?=
 =?us-ascii?Q?QiAD1RP706Izd+LWiaIXKXi/l3O/6XI4d5GNKhLrgzNlbPSW/2Qgv5ksKhFl?=
 =?us-ascii?Q?2tBR/UtcuipEYSOdilanrZegARtLWyggHkHXzzDTK41n1aZKSQSbvvx3WcSB?=
 =?us-ascii?Q?grDNT4F4929k1baDukNegVYS1OcRHiTzQtGfi36CyxPe27gTryv7YEWCwyNO?=
 =?us-ascii?Q?sTe1vUIZ6N/6ZU1KGJQWHVBFcFGsVM1XEbKpHTxNtHRHCzmc1sVT3jmZrAqo?=
 =?us-ascii?Q?Ym7cQAOIqKVQQHFvid+zbcum7n/CdzEvP4Vd1wtp?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aab320ba-20f4-45a4-c44d-08dd6b8adc9e
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2025 10:50:31.0179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gEB0XndBdG/+yrFnSejF7ng5ekSnHPbjugRgNYBF6O5m9X1AdRLAwoP3QBHs7JHdW4aOvPpg9K7ME4dgINnfFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR02MB5672

Calling verity_verify_io in bh for IO of all sizes is not suitable for
embedded devices. From our tests, it can improve the performance of 4K
synchronise random reads.
For example:
./fio --name=rand_read --ioengine=psync --rw=randread --bs=4K \
 --direct=1 --numjobs=8 --runtime=60 --time_based --group_reporting \
 --filename=/dev/block/mapper/xx-verity

But it will degrade the performance of 512K synchronise sequential reads
on our devices.
For example:
./fio --name=read --ioengine=psync --rw=read --bs=512K --direct=1 \
 --numjobs=8 --runtime=60 --time_based --group_reporting \
 --filename=/dev/block/mapper/xx-verity

A parameter array is introduced by this change. And users can modify the
default config by /sys/module/dm_verity/parameters/use_bh_blocks.

The default limits for NONE/RT/BE/IDLE is set to UINT_MAX to keep the
original behaviour.

Signed-off-by: LongPing Wei <weilongping@oppo.com>
---
 drivers/md/dm-verity-target.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index e86c1431b108..1e0d0920d6a9 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -30,6 +30,7 @@
 #define DM_VERITY_ENV_VAR_NAME		"DM_VERITY_ERR_BLOCK_NR"
 
 #define DM_VERITY_DEFAULT_PREFETCH_SIZE	262144
+#define DM_VERITY_USE_BH_DEFAULT_BLOCKS	UINT_MAX
 
 #define DM_VERITY_MAX_CORRUPTED_ERRS	100
 
@@ -49,6 +50,15 @@ static unsigned int dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE
 
 module_param_named(prefetch_cluster, dm_verity_prefetch_cluster, uint, 0644);
 
+static unsigned int dm_verity_use_bh_blocks[4] = {
+	DM_VERITY_USE_BH_DEFAULT_BLOCKS,	// IOPRIO_CLASS_NONE
+	DM_VERITY_USE_BH_DEFAULT_BLOCKS,	// IOPRIO_CLASS_RT
+	DM_VERITY_USE_BH_DEFAULT_BLOCKS,	// IOPRIO_CLASS_BE
+	DM_VERITY_USE_BH_DEFAULT_BLOCKS		// IOPRIO_CLASS_IDLE
+};
+
+module_param_array_named(use_bh_blocks, dm_verity_use_bh_blocks, uint, NULL, 0644);
+
 static DEFINE_STATIC_KEY_FALSE(use_bh_wq_enabled);
 
 /* Is at least one dm-verity instance using ahash_tfm instead of shash_tfm? */
@@ -652,6 +662,12 @@ static void verity_bh_work(struct work_struct *w)
 	verity_finish_io(io, errno_to_blk_status(err));
 }
 
+static inline bool verity_use_bh(unsigned int n_blocks, unsigned short ioprio)
+{
+	return ioprio <= IOPRIO_CLASS_IDLE &&
+		n_blocks <= READ_ONCE(dm_verity_use_bh_blocks[ioprio]);
+}
+
 static void verity_end_io(struct bio *bio)
 {
 	struct dm_verity_io *io = bio->bi_private;
@@ -664,7 +680,8 @@ static void verity_end_io(struct bio *bio)
 		return;
 	}
 
-	if (static_branch_unlikely(&use_bh_wq_enabled) && io->v->use_bh_wq) {
+	if (static_branch_unlikely(&use_bh_wq_enabled) && io->v->use_bh_wq &&
+		verity_use_bh(io->n_blocks, IOPRIO_PRIO_CLASS(bio->bi_ioprio))) {
 		INIT_WORK(&io->bh_work, verity_bh_work);
 		queue_work(system_bh_wq, &io->bh_work);
 	} else {
-- 
2.34.1

