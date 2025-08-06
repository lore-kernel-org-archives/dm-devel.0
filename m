Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012007.outbound.protection.outlook.com [40.107.75.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489FB209F2E
	for <dm-devel@lists.linux.dev>; Wed,  6 Aug 2025 12:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754483241; cv=fail; b=AgS9k63HaZ653EaD4mLQOpOmTXu27wz7eB0hSr2MftXBUuJT6kcpQ8lnODS1ZT5JupgWOAdiblv81uEeUDKZx68z/85dshImn/k9erwF0HsFx19K2xNktepYBlUTDeZo5cSI7M2ZGimWdtrm/5RfLhqhuqIoU4a4sHmsXVmfmaM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754483241; c=relaxed/simple;
	bh=Tt2IpuUkcGIFISGG/coyC6LD/R2FpGP7dMSPTg5balQ=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=H5ws5kwDz9OXbZDUcV0e0Pwt7pJoO2Y8TllbH3zDg8c3qhRtKJsSSkNxEWEHhmmE+WAxbXEWg74ws0+fL1hXtZ67DpGIdAcL3bjk3FL/2FS38qNyc63WQSuBuL8+NodySsQyJmsnddyHILzNyBM4vlawFM+4TyK4qTfmgQ6Tj04=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=FqQYuTBp; arc=fail smtp.client-ip=40.107.75.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="FqQYuTBp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LhXCmlrPmy139aBUKUPpNQRXUA3MliVS2YRwoEygSu7srV79pjWjVpcKMuVQO0L6UUyqs+RQN1ZxIBuDrGnvlRoR55BHlPVGsAUb0aw4T+eIwW4+pQYv6OKMM25qqTP1NfjQ4Vjq7fXkw01JE3tn893NhH/JgZK9mnTGuinFYlIDWNcgowh2ReOPHm3IkCYycX9XhLvY63N9HZRySw6vN0jtR2AV9vLyG7rYVOlgqO/6G1EbWaW8GJa6k5JFnzoZ4VX2u9ONOy0bkyRWkO3xVrymbXUg0tstukAlh3sszfU6w4CwvowX038Zb3UXlGSApWsxjWAIFnZmkfuiFkEw/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4LAHMW6OTobZTbmTiBJTIMwWXvMRo8AaJeS4IfY4QFo=;
 b=vAiJuk68xl70jT9fIHzudgb2Ej8yUxo2sBkjlOgj4NXSLOMDEZmiH35BHYA8x4HrsekXiOPGUSktZMPsP0qSC90ZbBi4O9BJUBAIp2VEjb+MF8eVF4kbdK9eeKMvir1q86nGS6oTYotnfE+EvdMPNRbF6a0kYBBXtmHzLUhmwoo/WhFLC9sWW2tT9WF/WB65rrVbfiVzcv4h7SbUysx9PAB7euvv7ddHDI8pbJiuf3el4w6dgcMds6Vh2hoe+hyuPyIhyoNcekgiI/2u7RsMkpl04Vc6qJPMcen9F06yPbNNpEYEJeXPnLTd0Y1CR/G6NfJxB9G+EGU3p+PtJYoybg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4LAHMW6OTobZTbmTiBJTIMwWXvMRo8AaJeS4IfY4QFo=;
 b=FqQYuTBpU9sZ2e2URxMYSUvOlFr3rmafkuv0vyF3UcB0SsKlsbZpMNRmvW4Min+TPw694WePlxWVzcQ03RqfjLeXUa1gX7eTTvVLAbeAwLJF4dGdOb+lzVg8rCxbw+vK7uhnP8WCUajfAR2Jqq3+issYd773iDfx7hi0FhtAHsAPzjQd0Y/QPI3J9Pi9GepFhoFuvojNDESBNhG1TB0V52uo+ooCPIwFRl24Ck8OzbrdfSALDbSsmUH2RK15ge4UcirjQen3L6oBpkfB4jEQCsKciAUPDgOJ60clTC/b5bW0X8NrzjJmAH3HmoFMh1+PXnrgJPApTR/Bv9GvHL4O2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 KL1PR06MB5971.apcprd06.prod.outlook.com (2603:1096:820:d5::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8989.18; Wed, 6 Aug 2025 12:27:14 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.8989.018; Wed, 6 Aug 2025
 12:27:14 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH v2] dm: Use vmalloc_array() to simplify code
Date: Wed,  6 Aug 2025 20:27:04 +0800
Message-Id: <20250806122704.378122-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0010.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::17) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|KL1PR06MB5971:EE_
X-MS-Office365-Filtering-Correlation-Id: 31f88a95-aa3e-47c2-b784-08ddd4e49310
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yGL2+FJVmxzHjv5NJQoajxWpoz35srUktUdODwGMImRU/S8WkCemQVK6/WWy?=
 =?us-ascii?Q?Oq7GCY/od0oFGUhYyuH7bw2+04n53+ml7rlFPMZ+sEEd5XKuF7QL685p1lfb?=
 =?us-ascii?Q?uvKxmkO4VHsIR9V5a7nNBnm03CZQnYXySbcf699RSU31NpaiBEd5LOmG3fVf?=
 =?us-ascii?Q?ptwIaG3nnqTO/5I8RmpzxbvgHQZgpZ/MfUtY2EcJ3hI1VT9ct70igqbc4bKZ?=
 =?us-ascii?Q?MFcvb5oI9BwalrDf9syBatuTbHw2EE/WujL84ISgL+3dMg015/6O/+6RrajC?=
 =?us-ascii?Q?sWjup6hkv4CFFOjc7X5RN+GqBkpbGPQ+1KaGwjAtZd+nDDGy9E9Zou/YySu3?=
 =?us-ascii?Q?+Y8nT3zr1L8Fm9pvMOkvgwh+i1L5460cdPhaoPUKeiqa2OwB/KphxXcRgqjV?=
 =?us-ascii?Q?FJ3VEBnUPdUMPxzcinvsLgjY/hBBpbtOy8r6odoIgo8Pc0PKRvXWtAIiIa/W?=
 =?us-ascii?Q?6Wh7I1soTVBi+KV+VY5oGeN3Z3XY0nkqobNvXxcRDgoKjgz+torYvA4/So/k?=
 =?us-ascii?Q?Y96mBdiP7JYeBIdvxteo6eR73E8PgbXllv2F+UYH6MKXzHQkgiPC95mEA+DZ?=
 =?us-ascii?Q?y/10YzVMXXg1GGoylkXvFWZhdHQGrkAopim/m3GHFsAWFK5jhNfsC+WOY6+5?=
 =?us-ascii?Q?ragmYcc4nS2jbjAeFWNh2VRQGPt9h5zp5Cvpni4BNM40gQEhrv2i58iNOjo0?=
 =?us-ascii?Q?MGTS/vdoLOvn+UoPDxikN8YSfPdKPYf1mWqaGB01saeDwVKeZCnj8XCnvfGR?=
 =?us-ascii?Q?BDcnQGjNNIj2dJiEUKzwUBvLMoFlQY6vNOcIJoZH8kPmV0LnjS+hz0Djs5oz?=
 =?us-ascii?Q?SkoyuPW7ifNLGSKrsFDXjT4a23fvwHzAi9/PCdsOFJFUamV5OPf0iq5ZTZxW?=
 =?us-ascii?Q?E/M86SmnzopX3qvn7uDHyXGTavgbujz2y8Rgi1cImlA02ywpssp3+sBclYyO?=
 =?us-ascii?Q?efuAVG1ypOxSLU4o5CvASD7nWnIRKntBI0Kga3E5EqsoiH9g/Z6XHdHpu/Fy?=
 =?us-ascii?Q?ctirpnvfuxP1FKQZlZ0gZ5BZtCND0E3kmzt1lIHcjv70afHLFK0wqceRhKeL?=
 =?us-ascii?Q?/RYSG5+QNwUW3IfoKxFNlKHSGQBOi/iemBeNmApa/onYK/aVQFPyG/OIJOne?=
 =?us-ascii?Q?ROJkh+OyyHtD7ms1lzGjoqyXBfkljnH8sCVkv5oeATt9IvLq2R24vySPpHW+?=
 =?us-ascii?Q?ZBDGHw/ncHrEe5WKxHOqftZyhAfh34Cd3eSCGzAzkHRBwOc2C9xOyFxxbO+i?=
 =?us-ascii?Q?nEnSOEcVh7GWMVPwQifeCAfb/fL7BCien+JStBmC/CZCAqvDLCnlXzGo1Cdq?=
 =?us-ascii?Q?IgNiUaKkd9jYASFnDks/UnfW2LqE8cM0RQ2p7+9xZ450XgbYSiFgDInQvZ51?=
 =?us-ascii?Q?SEdqTK7yiTI8APcCGV9KmyBGEe/v7OLkNIi7q6LG8+XTrwp4DsfdZYIY2Urm?=
 =?us-ascii?Q?U0tkSCxICTAzQ2+Ina5sCXU7nMPObE4dJYJ5ryvvQ6QrdftsAng4sg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Zc7YwBJSYvBYvK+KFRq3JCFBwA623W7UwOwSWX5QBqB9N/83P88y0V/s5qWX?=
 =?us-ascii?Q?4oy9lrS1f3fyeJHmvkG/cCYfnV/BjEe8QI9E5OXBtHZKeunCRBx8ALFK2LRN?=
 =?us-ascii?Q?Vb26QN9zYsf+R0f+EtoDydDZGPIjmuH9jF7PWqoHKTplmv4eocCs0B2+aOBX?=
 =?us-ascii?Q?iEyppCRufJJyFo9EedTcCS6mOcewhvY11CaacGCd8MouYgS6abSiex9LlHkl?=
 =?us-ascii?Q?ZDh4nZkPgI7MlgT23Oj5tJ9kAPNiBP3/vodQJAptwDKxdV26Dcg9h92WtBCf?=
 =?us-ascii?Q?pd0MwWgaVFK9yRdqGX48BiZYzRhm48UO5U8Ps9xUxjbzcc5TUvC0WO68lP4f?=
 =?us-ascii?Q?jhq9sr/Ekh8WuEsR4HROQIBVXyv+uTP/hPMpAJ7nmqVYS57J8dqxsedfzyOP?=
 =?us-ascii?Q?2lYYOQQbiMH57M/8I+KSs4EzMd6APsPgkd0wo6njGvZ5TI21tL2s35vKhfUs?=
 =?us-ascii?Q?Ttwa4zIdCGKxIyati6cBlEWSB3apkm3GOtUp6Tk8pTGcQ9p8MBQy+aY9e4wL?=
 =?us-ascii?Q?F5upPWNcJlAQUpQGKFyVbiVzpunFbl3x80OtF6bvvvuTDJNC48LTwIXkM2Xt?=
 =?us-ascii?Q?VqJv+jPRpwoihsqcu6SwHn5BhcjBryJNFxdb9znvKLDeFKoLJQAkVWx2J5Es?=
 =?us-ascii?Q?uJBOdzQ8AplItj65dx/8KbQKhV9YUWOg1KgQSHe+TeIeLnHOXpDQXMnYXL4j?=
 =?us-ascii?Q?qrc2aSDoAUuJXzCyjJZslGgqgsVLVZw/v2QtFvtnbxGKuDPyn/RKWpnyaayG?=
 =?us-ascii?Q?pmuHji69K2viLi/ztSim24u80E6j8akGyA6g9wGeP/Fq7XkbyQkuToXH47Xg?=
 =?us-ascii?Q?ZILOVAuoLIqQViWrb5JyWY1C2qZqH8fIDOTl2vPLNN4QqPZxAQZLJsHSvy6q?=
 =?us-ascii?Q?J0C9DcoNb1WsMk5eAo/daHQfnRl13iQb4LQAPgGzokLrq2wOR+SWRa7ObQUB?=
 =?us-ascii?Q?y9Ibax7X6IwNM62SVn+XBjaN2ucvgQ3SpXPUv3+6mfPTYkraHO8tnGF356VA?=
 =?us-ascii?Q?MsGgFD/cwIDZGQ5E8j9M54cmTBmeyHhZdt3rxx3zqrUzuvQBE6ZUYj5YbCyx?=
 =?us-ascii?Q?qB4jOZQHkCkdTMoBK+AjJTSiefODksaP9Z4xu9IXbqinQCdpfFwjPZ4xrURJ?=
 =?us-ascii?Q?2wzeGVEyRDQB8fN7ajf7tpolB0TMQbqKC63MIrRjpMfX+Y8qg264B1szUEgF?=
 =?us-ascii?Q?yf80TJqtrV4Z1hwLUr9kf8kDC0VhjZPZXSSSCnOp9iUG/VkGawp13GrDWaFb?=
 =?us-ascii?Q?b9udJHzqcJmYLK0X3+msFqBrSySu9tmY8hUVgzC4BrdWpPBaBVU2WJ1i3tjL?=
 =?us-ascii?Q?hkzDri9A+PdOp5ApvluYsNSmhKyGWWANiwqdIqMoMxoGVsXxYhlScrbb3f4P?=
 =?us-ascii?Q?+LOMLOjOdqTn0V0Rrw6O1K/MZeiJ5Q98rwEk+sYO84ZTgmGF2tpyY5M0nZaH?=
 =?us-ascii?Q?9xfRx/eFc0rPgPEbXh8Z/xxfS0917p74zu4In+1FH5toWsab7XCK3dzryCi+?=
 =?us-ascii?Q?izp+n/zhtaFcX5D6K9FkGWEvG4RtcxHrAy807XixFZc4T7pgHrQrCsQMTuVT?=
 =?us-ascii?Q?bFFevsTkEv339oPFpQXZBz1J+PjSPAsCVAwFu1BP?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31f88a95-aa3e-47c2-b784-08ddd4e49310
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 12:27:14.3574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BwNZQpGfu4wtIv8NocVNGYzkY4tUpR/c5QsXa0g8i5e08YRq91SuvC2n35E3/HTIF9Se+PXd5WaGA3tmyVtHxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB5971

Remove array_size() calls and replace vmalloc() with vmalloc_array() to
simplify the code.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/md/dm-cache-policy-smq.c | 2 +-
 drivers/md/dm-region-hash.c      | 2 +-
 drivers/md/dm-switch.c           | 4 ++--
 drivers/md/dm-thin.c             | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-cache-policy-smq.c b/drivers/md/dm-cache-policy-smq.c
index 2ed894155cab..7e1e8cc0e33a 100644
--- a/drivers/md/dm-cache-policy-smq.c
+++ b/drivers/md/dm-cache-policy-smq.c
@@ -590,7 +590,7 @@ static int h_init(struct smq_hash_table *ht, struct entry_space *es, unsigned in
 	nr_buckets = roundup_pow_of_two(max(nr_entries / 4u, 16u));
 	ht->hash_bits = __ffs(nr_buckets);
 
-	ht->buckets = vmalloc(array_size(nr_buckets, sizeof(*ht->buckets)));
+	ht->buckets = vmalloc_array(nr_buckets, sizeof(*ht->buckets));
 	if (!ht->buckets)
 		return -ENOMEM;
 
diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
index a4550975c27d..e9b47b659976 100644
--- a/drivers/md/dm-region-hash.c
+++ b/drivers/md/dm-region-hash.c
@@ -206,7 +206,7 @@ struct dm_region_hash *dm_region_hash_create(
 	rh->shift = RH_HASH_SHIFT;
 	rh->prime = RH_HASH_MULT;
 
-	rh->buckets = vmalloc(array_size(nr_buckets, sizeof(*rh->buckets)));
+	rh->buckets = vmalloc_array(nr_buckets, sizeof(*rh->buckets));
 	if (!rh->buckets) {
 		DMERR("unable to allocate region hash bucket memory");
 		kfree(rh);
diff --git a/drivers/md/dm-switch.c b/drivers/md/dm-switch.c
index bb1a70b5a215..50a52ca50b34 100644
--- a/drivers/md/dm-switch.c
+++ b/drivers/md/dm-switch.c
@@ -114,8 +114,8 @@ static int alloc_region_table(struct dm_target *ti, unsigned int nr_paths)
 		return -EINVAL;
 	}
 
-	sctx->region_table = vmalloc(array_size(nr_slots,
-						sizeof(region_table_slot_t)));
+	sctx->region_table = vmalloc_array(nr_slots,
+					   sizeof(region_table_slot_t));
 	if (!sctx->region_table) {
 		ti->error = "Cannot allocate region table";
 		return -ENOMEM;
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 007bb93e5fca..c84149ba4e38 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3031,8 +3031,8 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 	}
 
 	pool->cell_sort_array =
-		vmalloc(array_size(CELL_SORT_ARRAY_SIZE,
-				   sizeof(*pool->cell_sort_array)));
+		vmalloc_array(CELL_SORT_ARRAY_SIZE,
+			      sizeof(*pool->cell_sort_array));
 	if (!pool->cell_sort_array) {
 		*error = "Error allocating cell sort array";
 		err_p = ERR_PTR(-ENOMEM);
-- 
2.34.1

