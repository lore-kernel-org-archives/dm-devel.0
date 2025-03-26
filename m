Received: from HK2PR02CU002.outbound.protection.outlook.com (mail-eastasiaazon11010021.outbound.protection.outlook.com [52.101.128.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750BCD27E
	for <dm-devel@lists.linux.dev>; Wed, 26 Mar 2025 01:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.128.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742952750; cv=fail; b=UXYWyT9k+91gb06O/mPekYIzFvsoUIjk751rxW9hiotuK0+WTYQjAyAzlMaKqC5tszJHTjiTK247vJ9ODXNe+o8B1Xm51aKEYy2nxTCjAEq47jmpDh4gvfGzGE+vPh4kU69imROtYNqzeRwfE4YXqzkAuMzgjrzg00dBEtAkUU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742952750; c=relaxed/simple;
	bh=Ii/jMHM9LwBcmv7p7ten0iKbVnGSZao1Yuc/KJaWoao=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I0NBwVWjyGL95IDmbJLOPhHqWkrVs4PhUXJDGaeBevLH1b1XFid0/0DhocPEVrjBXdg/qb59ofkIELp4Peflh2yQTSl7tsq0YJkvlu+jQxci1HKGd102Kc2x8PN467Rl7wPjU80a0iVApkytpqwLYbqyM6+1pDhOBJiVzdDj2o0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=aXQM0WRm; arc=fail smtp.client-ip=52.101.128.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="aXQM0WRm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mxce3Y7X8l5V/GQ92z4iFR5TGppMG2spp/pnWIJV6rgVNcle3muSiewGoRYz9g3LMfDBH88lrIni0LHgOfDJE1x0giDFKnuSFC5UmvKino0hA67xmL1WJF4WsDTluy4dfWHKzNZAw4jGvKT3VKYGehBYB52AlRmywBJaB5ulDN0gh7X2nQNAk0WnJ5tz3N3r1gycRZDUf4HDR/ouEmf9uQL5ojbFRPD1zcV1qLWEOEpyB9vZ6FRFDjM0vpNgQoZSfm9Pmbd7f6g1FwKXcVJIcJ/2i9TiV/bWmbddsTX0IgLTakLtcjDKrUslOXB4EkAcQHNJn7Gp4R38czpssP92bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gl/J0ak5mML4fWOo++9KQiWQPAF7GfmgB9sYEqemtmU=;
 b=ee+526xHORHDsy9Lsvbg6CjDhWux5Sl1rXuWazvMYaMVRUWWBYSPfT49IUR/yL3wex0IHHnX6JXLwA3qcTaNaKtQfQEHCN6w9M0eCmDhBJ4gZ1i14TWtgmJoVX498Vn4bkCyt0iosOE0FtE+QLGqYpI0tTZHNmYom3FJuDeD9IFsn7yGR2zsBLlyjH6GBlCcZQ/5sZcmEmikUfxZOFKQmnHE0F6q29cyf89i5Mg/Bg91uWkjppKfnuVFAF42tJ+FOlDqimf/24f1go+B1Ad/KMSNvVwRxZNN+A5T5sZiCHADZYK1shpsaET7pasATApGGBiEXpEjBjOG5EoJul5RmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gl/J0ak5mML4fWOo++9KQiWQPAF7GfmgB9sYEqemtmU=;
 b=aXQM0WRmsquyWwxbxDfha92tMRidk8dJyktVNDCOUZ9yzHvdQXo8qM+MU7+fH9G7rDUCVOXNm+KmDdHs3pPEvXUV4Kru6UWopW9VeV0xw1d7ogIFAqeegtWbhuBch5GWd08gQMCgMgwxh/F9W62RgRS9jtHgc1mTmGzln2qq0w8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by OSQPR02MB7980.apcprd02.prod.outlook.com (2603:1096:604:293::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.25; Wed, 26 Mar
 2025 01:32:23 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8583.023; Wed, 26 Mar 2025
 01:32:22 +0000
From: LongPing Wei <weilongping@oppo.com>
To: mpatocka@redhat.com
Cc: agk@redhat.com,
	dm-devel@lists.linux.dev,
	guoweichao@oppo.com,
	snitzer@kernel.org,
	weilongping@oppo.com
Subject: [PATCH v2] dm-verity: support block number limits for different ioprio classes
Date: Wed, 26 Mar 2025 09:30:51 +0800
Message-Id: <20250326013049.1292617-1-weilongping@oppo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <50200020-3c4f-0667-1697-7c2ff62133b2@redhat.com>
References: <50200020-3c4f-0667-1697-7c2ff62133b2@redhat.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0008.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::19) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|OSQPR02MB7980:EE_
X-MS-Office365-Filtering-Correlation-Id: b07e74c1-16e9-4596-cd12-08dd6c060e86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|52116014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yZ3i9PU1VvSpSCW6bbPFwww1M9+g+pCwsCamSbZkMI/PMZiLpUtgItTDGKDk?=
 =?us-ascii?Q?JDDgAB+pw2eAyprujBHMzdl54g8n3Nzv1LblSfKZub0XHQdPOXnLd7URK9TU?=
 =?us-ascii?Q?7B7neijBL/AJWEdvpA4NWXse+qQjCkAzXXlqYREiLojuolTI1c8Oe7F6lqka?=
 =?us-ascii?Q?Sx732pPFW2/sZkhaPBAIRvpXGOKzR33UM4j8RwqvskdO1P+2dl4c2I0wyfK0?=
 =?us-ascii?Q?mU/MBb4MMGnYPCBdB0W+Ks5sJ/1kzVm9TBIPvD9bIVM5rwlgvNt0lv7pwQNy?=
 =?us-ascii?Q?2dLMHx8MAkRwkrgchT2Vu5QeAF+X0mit6RYAqtiFnZDyHxHoWlkgNm+En5hu?=
 =?us-ascii?Q?FaqL5SqO06d2FAZPGOlhw1Fz9u3Pao54cSfPBN8Azlu4UPW1zNoIKAmV6J/v?=
 =?us-ascii?Q?zOVCzGymqqdTQ/cVbJVZx+hL4GKo5jf9Pv7np8dg4clLhFZ16VomEjg6o3YQ?=
 =?us-ascii?Q?n2+oM/YH+e7NNQOSyrH+03XKWEz7yOaGoMy/agp10UCwJnv4oQmlsna7SXVa?=
 =?us-ascii?Q?3KbD/Z+B+nLjaPkx1+VjcGRdkxI+SNCZiL+Shn+6Z5hVRRveKdByERhp00bw?=
 =?us-ascii?Q?FnCWn8F0vDO9Zzlc01O1TClOGuR6Gs64Z9y/QpiFwRnMS66T+XyOrhbT390O?=
 =?us-ascii?Q?KPFuuDsJX6BPo5bT/gPZewThNsK0eD7ieBFJuKr2uBUxANbSyyoZpTGOhTyL?=
 =?us-ascii?Q?tZeNIA3JJTaq5pKTQ/l6t6eqy0nKq5nqfmEglwHeJiS98wFfDr1A5lWZo9sv?=
 =?us-ascii?Q?+7yuOhKTRzi41iBajDpJrlYV68lpkK6EBvoPga+DTSOxj3yGNGR/82LjxYGT?=
 =?us-ascii?Q?m7JAWgmoIgO1tIm6NEcuLcsSAssQQiVYm0eFu9mmZIj9GipivySgHRPYp0vl?=
 =?us-ascii?Q?YtRKKm7UhPR//+Xm70Db8Yp2MKr5VoZdbN/pw0EQ2fTTf6b2yp1s0o3i1iUM?=
 =?us-ascii?Q?HhpKOgsiUSHIlU7wrTve35ai1DPKpFY6DkIdeMoBvoujqTKigNbX3Z6n+5SE?=
 =?us-ascii?Q?VnNhDcXAsHu14eOFUSaQg+ZkxQQqpSSsgXef7MI2QgkyK/Zd77J4Y+YmhamA?=
 =?us-ascii?Q?QEEgzNFLcq/9ngITnv8BzQOaHLRhX6b7D49GJGw/nL4tqOPunOdkR3XFvAga?=
 =?us-ascii?Q?pY0CDKhmZNeTu9p/cVXY0rk1xJ2PL99nhzwgiF57MEFVazOXSSOH39pRVDjz?=
 =?us-ascii?Q?J8+sM3Vn4gGyiqV1ckRtHRjJ+kTufHaffrZjRUWBt58lPHtmOJnduc1sXyss?=
 =?us-ascii?Q?EH6wtfExBuIKyM478YnssQFdsDs+6Zg7+rBhmABZkoJHkaAC1tVmmDrKjUqV?=
 =?us-ascii?Q?vCiHQ7YpXGDLapmzHRiNgI5GdWMzowhe2CX5nZdKn5mAix+fFPOVVaWe7uBB?=
 =?us-ascii?Q?q6lLm+Uv1nP7qGlxi7RiqHYTloNR04paoMwpYsszxmwNBdB8cXpluIjVdPHz?=
 =?us-ascii?Q?BYwJbpM60U9YAEZFtK8jy3m21xWOUWLV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(52116014)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mVTh9TDPcnLf2C5ab+q4dHfMfLtC9Jcko98PzVc7JpKO2Vg1ygIK4tNb6s08?=
 =?us-ascii?Q?4CqLKBEuW4/g9/ViV/Qtq/kBlt+vm/MZcIofKZg3CmuV/ET376P9G97dHGDa?=
 =?us-ascii?Q?A5yxsNzrRZoEHRmm3z745wzUbcGC2JnHtrHvCCLamZRQv6bGIG05b8EchCGz?=
 =?us-ascii?Q?vMdZZ3Q+tJKU9qC36vRJA50QKW9Ch99yopU4AwfDE+rRUa/yHBtLowqsNfaq?=
 =?us-ascii?Q?SJcEGRVGvfY4xJStuZTbNhq5p4wn5janOHnkyKyX1pofAzynRWOaWtg9t2i4?=
 =?us-ascii?Q?QwbfklKIPubj+6BU8KQ5Rqsl5KarY01U5roB0Lsc94JhhMig89v9wj304u+o?=
 =?us-ascii?Q?7RvLg6T8m/KU1cxBBmsiL5t4Joh5/0Qp1mmEdNPqcaeLvXLGuzR0GMsDQwSt?=
 =?us-ascii?Q?cJ9sMVKwMaWQda9M7esfv7BbeSYzXlHTYWYWzPVGEN+yGCUjfFaYK+8bJ6j6?=
 =?us-ascii?Q?pXUKjVI5m/XoE4njbqxVk+SvZSY3XPmSzluDnRT8Ce5CYIQBXDCQ7UllZG2u?=
 =?us-ascii?Q?qGok0xx3KIV7Pb4/57wu9DU30jLYtG9E4gmxuM236KdQG/RYARHod6MLnGr9?=
 =?us-ascii?Q?gXlyuUoJvWtA6txZGlBcCxYRNpjVSMOTDwmFiXKnUz5BErWvDeC8VIlW4fXk?=
 =?us-ascii?Q?jMceUA1FX9g+3w7Z6JfUCMQ0dFOcy3p0AJhl9ywBIxvPqaC6WDmR41lqTWOD?=
 =?us-ascii?Q?zOd/QGOhwZqtDvY8vU2otGfmglvVPYUgvCBVQiy2mIjaHk2eQlnyVwUAyFVt?=
 =?us-ascii?Q?oRIWonJ7j4QFfrIg052ADZP28nmUyG5TnCX9MtiD6/37qHD8Mc+CLFSCW6YC?=
 =?us-ascii?Q?XHxcdQfOioy9NMGlFp6BCwLd482Asgu6gtBzwRdQ/fgqYF5DyFsT3JC+OuYY?=
 =?us-ascii?Q?bEVSMq9zx5crDOkswSHp/pe6mmSMvJsCiudQ/9wYET93BZecwa08t2pimWBL?=
 =?us-ascii?Q?a+k3I/V3p5fzgIKo1MrWGbprFUXEDF+OMkW0Mj8k80LYCjG0bi9dzKXs1G86?=
 =?us-ascii?Q?Sxmp9ht2mln8HfiJ9E9utEZpiyuHmK0VMz8JHkbQ2G+w9yKD1TZdK8rsF0my?=
 =?us-ascii?Q?0GYZVyAC83o/qCrh5KVzh1Qt4jUhkzsxBu0mmBELRj6FVFMbzkut5g4gRo+w?=
 =?us-ascii?Q?MVc7S6ZDopipNke0cDhOoegQ1L1tYPxsf30SRlcIsxJQU9V7T4Po1wZsNfuC?=
 =?us-ascii?Q?zAihZE9qpDOcPteCrCmpR9zX+o2In7BqLweG3uzfNK8Yc8KxUuc1iqqU+NOw?=
 =?us-ascii?Q?pAAGVGkpu4sjkVrAu4/AcRs0sOKMkX+AXO/DgMOVmJA94ikH1j4M/cw8pDFr?=
 =?us-ascii?Q?7D2Ovtjfl84NUF+7xk+NSc2/TFe8UuJQsN6QdF9aSyOk1+6V85bypv1Dt4cw?=
 =?us-ascii?Q?BDw5zGO25wHBg/KJnOjeTVg0+e+ddKAtmpAd0UfjkS0/b+lD3gBGRWYzFjVs?=
 =?us-ascii?Q?ANKvc7FBtX6+HF6BaqEU+3TA2a3UFs2s1zAEq3GSXlRSnKZqxWT7xfX9iUP/?=
 =?us-ascii?Q?rOj6NzuTEDQhGb5d0Rpvu09KgaVRWCpWPnRgAosq4X+fNl2Fax293eVP2bBw?=
 =?us-ascii?Q?NA/ElkM+KUkyg9xXN9jPYYjl10tFVVrCEQxlJJ3Y?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b07e74c1-16e9-4596-cd12-08dd6c060e86
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2025 01:32:22.8533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8dVu0YhISwWrEHPRKIilJdTLDULztN4tYGc9NPjauZSNk8WqboxAy5zYRXHf3gQvFWq0hWNEl9Ev3y+PO2MtbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR02MB7980

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
default config by /sys/module/dm_verity/parameters/use_bh_bytes.

The default limits for NONE/RT/BE/IDLE is set to 4096.

Call verity_verify_io directly when verity_end_io is in softirq.

Signed-off-by: LongPing Wei <weilongping@oppo.com>
---
v2:
1. change from use_bh_blocks to use_bh_bytes;
2. update documention;
3. set the default limit to 4096bytes;
4. call verity_verify_io directly when verity_end_io is in softirq;
5. bump version of dm-verity;
---
 .../admin-guide/device-mapper/verity.rst      |  8 ++++-
 drivers/md/dm-verity-target.c                 | 30 +++++++++++++++++--
 2 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/verity.rst b/Documentation/admin-guide/device-mapper/verity.rst
index a65c1602cb23..f7fb5ea3c0df 100644
--- a/Documentation/admin-guide/device-mapper/verity.rst
+++ b/Documentation/admin-guide/device-mapper/verity.rst
@@ -143,7 +143,13 @@ root_hash_sig_key_desc <key_description>
 
 try_verify_in_tasklet
     If verity hashes are in cache, verify data blocks in kernel tasklet instead
-    of workqueue. This option can reduce IO latency.
+    of workqueue. This option can reduce IO latency. The size limits could be
+    configured via /sys/module/dm_verity/parameters/use_bh_bytes. The four
+    parameters correspond to limits for IOPRIO_CLASS_NONE,IOPRIO_CLASS_RT,
+    IOPRIO_CLASS_BE and IOPRIO_CLASS_IDLE in turn.
+    For example:
+    <none>,<rt>,<be>,<idle>
+    4096,4096,4096,4096
 
 Theory of operation
 ===================
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index e86c1431b108..6e26d59cdcef 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -30,6 +30,7 @@
 #define DM_VERITY_ENV_VAR_NAME		"DM_VERITY_ERR_BLOCK_NR"
 
 #define DM_VERITY_DEFAULT_PREFETCH_SIZE	262144
+#define DM_VERITY_USE_BH_DEFAULT_BYTES	4096
 
 #define DM_VERITY_MAX_CORRUPTED_ERRS	100
 
@@ -49,6 +50,15 @@ static unsigned int dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE
 
 module_param_named(prefetch_cluster, dm_verity_prefetch_cluster, uint, 0644);
 
+static unsigned int dm_verity_use_bh_bytes[4] = {
+	DM_VERITY_USE_BH_DEFAULT_BYTES,	// IOPRIO_CLASS_NONE
+	DM_VERITY_USE_BH_DEFAULT_BYTES,	// IOPRIO_CLASS_RT
+	DM_VERITY_USE_BH_DEFAULT_BYTES,	// IOPRIO_CLASS_BE
+	DM_VERITY_USE_BH_DEFAULT_BYTES	// IOPRIO_CLASS_IDLE
+};
+
+module_param_array_named(use_bh_bytes, dm_verity_use_bh_bytes, uint, NULL, 0644);
+
 static DEFINE_STATIC_KEY_FALSE(use_bh_wq_enabled);
 
 /* Is at least one dm-verity instance using ahash_tfm instead of shash_tfm? */
@@ -652,6 +662,12 @@ static void verity_bh_work(struct work_struct *w)
 	verity_finish_io(io, errno_to_blk_status(err));
 }
 
+static inline bool verity_use_bh(unsigned int bytes, unsigned short ioprio)
+{
+	return ioprio <= IOPRIO_CLASS_IDLE &&
+		bytes <= READ_ONCE(dm_verity_use_bh_bytes[ioprio]);
+}
+
 static void verity_end_io(struct bio *bio)
 {
 	struct dm_verity_io *io = bio->bi_private;
@@ -665,8 +681,16 @@ static void verity_end_io(struct bio *bio)
 	}
 
 	if (static_branch_unlikely(&use_bh_wq_enabled) && io->v->use_bh_wq) {
-		INIT_WORK(&io->bh_work, verity_bh_work);
-		queue_work(system_bh_wq, &io->bh_work);
+		unsigned short ioprio = IOPRIO_PRIO_CLASS(bio->bi_ioprio);
+
+		if (verity_use_bh(bio->bi_iter.bi_size, ioprio)) {
+			if (in_hardirq() || irqs_disabled()) {
+				INIT_WORK(&io->bh_work, verity_bh_work);
+				queue_work(system_bh_wq, &io->bh_work);
+			} else {
+				verity_bh_work(&io->bh_work);
+			}
+		}
 	} else {
 		INIT_WORK(&io->work, verity_work);
 		queue_work(io->v->verify_wq, &io->work);
@@ -1761,7 +1785,7 @@ static struct target_type verity_target = {
 	.name		= "verity",
 /* Note: the LSMs depend on the singleton and immutable features */
 	.features	= DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE,
-	.version	= {1, 10, 0},
+	.version	= {1, 11, 0},
 	.module		= THIS_MODULE,
 	.ctr		= verity_ctr,
 	.dtr		= verity_dtr,
-- 
2.34.1

