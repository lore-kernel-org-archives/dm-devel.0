Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012028.outbound.protection.outlook.com [52.101.126.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEE025A326
	for <dm-devel@lists.linux.dev>; Tue,  5 Aug 2025 09:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754385306; cv=fail; b=q13ReWJ9Cb5z7JqBHdYvJLYE8UiJNl0rU7+hXd5EXTAnuIMmbgkNmSHdd/M5mk06CjmG7WUv/MNM39q3l2MCf6FoxtTpjr7a1BfaiTqHBsRVDdkb546ok7WbJI0ZWrFH6ePzkEZXPrJ50cPMgauwK3PJxGuf9TI1ygjENUiXpXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754385306; c=relaxed/simple;
	bh=IXBJwNciKAk/nrMzEUMZ9LzQkM9jFeGP2zB9sTg+Dc8=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=Bjkynr1Yd0z+6B0OotZgPPBobqQxEgRoaEDN6z+Zg8Q0VJYaHAkICE5bBbi5z+TALDtUCplJeuh5Lc1973y5n1+qB9ByK3TWvRpFkVFDHWcgrQWJPf4tpEW0T3pnMrEmBtRhwXZNd/hUDJ+ruQ6TvwwQWImEEVsA478hNNIfC70=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=BBLp20R+; arc=fail smtp.client-ip=52.101.126.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="BBLp20R+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aFDJ3qe0XN34n0Zq6bQypuQYD9buMFiL3COnp5dPLu+dvZJLyE8pJsIoDWzYSpPM4T2BVXcz7Zfn9xQC7+GtT0wpCWt0qwhaXma2di41bdwDQfJILCkt/6UpynPL3MfU0Z8Jj237r9McB/soFcO9tK6QshX5AcWH448NDkXUPs08k6UKbI4RKd4evTrEOcFovoF27cIjvIFA9HY37Yxrzfl+160FWe9dwoNlO09iQQmrz+U5b0Sr0m3stJhP7y/SsLVbg6iW/2dYEbAYdc4LwRhKhlb0rwgQvoHUaGtavePAqA5ltDwXvqluGqNgiWEDpt0QsoYjzQFnJKdvfEaVqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wf1nY9zRAoHiRRuct1X9lDE/SB45dXQ4B33eXX3dOgM=;
 b=rJrIpy454UlfxsMbWX0apGZWYNcTifeQJFW4DWFCavk3tt07h+CLnkyZcn24vCDrV3w6TV6LZh0RLdi/hm7OdIzglXhSdvAu1qSGMn4OgCf0QaJSfVLGfWjBPid5dU/HcwLLiyefNuO+wed9xFJ9PxzXKuVGcb1czKiQh6FTiVu5k+uuOYaGOxyxCJnMZrkHiAY0UXFc57eYdcYaM5s4BTTCl3SlVyISYDGs/5iKyS7FJ8SQYsctlDAUCcN/tkkJv0b4br0PX/VeNkROaMI5pscrYT8mLWPhQiOy8EaLCRqL/yDzfKWWczZPhSgthhCp3WixpqFekfFAgbh2OYPlcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wf1nY9zRAoHiRRuct1X9lDE/SB45dXQ4B33eXX3dOgM=;
 b=BBLp20R+tI9tyM7qDdyLzfbdx7GDHftBQ2PZObeU12LZdRIoAnaPaBrzwAJq0qdyjIcB2kg2tW5OwW7drjJjhlUJWad0sVOhn3nJx0knf4anz/GiJez/nthmKtJUdR2TQaH8vHD3mPTQbWnpbcxFdFqH7q24bYaIY4DiRVgRBG/OggLPPMXMj7rza9sx2jSSR5WRnyPhcQVuKzzhJyZtRfX45NBw77HIUR/zYo3KmQkjVcHjNhcXJuwA9MVxOgkqoLpVPXOqbXFMsmywnmtguSYNBiAp+ICmOER9oHkBVDaax/Xqzb8J/T4AGRQVTSjyKhp+VFxdeQOBfwT6uI4XpQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 TYZPR06MB6141.apcprd06.prod.outlook.com (2603:1096:400:343::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.18; Tue, 5 Aug
 2025 09:15:00 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.8989.018; Tue, 5 Aug 2025
 09:14:59 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH] dm: Use vmalloc_array to simplify code
Date: Tue,  5 Aug 2025 17:14:48 +0800
Message-Id: <20250805091448.124183-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0037.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:29d::12) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|TYZPR06MB6141:EE_
X-MS-Office365-Filtering-Correlation-Id: 1697defa-60ce-4d05-29ab-08ddd4008d8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pqtwdKR7K/7/kCYoUOhW3b4EYnoQVoNjNqVxcJwOnxzAdjLC07xBPQVP2ExV?=
 =?us-ascii?Q?xqd4amp2M9vaXJxMC+tRJXnlU/hphrDaO89aR0QtL0DeuuHaBy1kbXk1sqoF?=
 =?us-ascii?Q?v7IDOeYpRfPHq7rjYaDVAfbXHjKLL6XDsZeIzraavUh+DnczieYpJZPPKjDB?=
 =?us-ascii?Q?SVtZ1YUH1YL/C/w11HRJUPVkv+Q8mVeLv1ny98KyBMB4jOYwp5f7z3gGTldP?=
 =?us-ascii?Q?6u1kE3ZTjQyINsIGC/P2cg/k2qBB5uAsmZEbuMCEjzKbMuNZLvJakAGbzRVv?=
 =?us-ascii?Q?TWxcF22sWjtbBxOYNYEPTi73DHTY7lHwH9UP1EHc2SljrC1lQwVfKpFnkH9E?=
 =?us-ascii?Q?BwBhXYq8sQjQiSUdy/x1R9paGdPrAi2FcHZ7DmTZPEM/YllZ98gEaAJcB/wm?=
 =?us-ascii?Q?pO38fKmuqq5Hi9Ma40khN/GoqzXUaQO6hpLtUksqtO6vNMBu/MDUoxJ/c/ZX?=
 =?us-ascii?Q?QLvfpvzvpZixTDz8UtHEKvW7+8nOZ4HZPgMneuhG0xdmqXrvI6uHuteB5/h1?=
 =?us-ascii?Q?Pscd8nl0ET2DpaBayKKUV9Ut0QltgZNbFW1bNiPb2QGvDU5YHAckLlal92DB?=
 =?us-ascii?Q?IkyfiQR6Y5cl60/J2tQMgxW3Rx6No2FxaSQY/EEdZhklGp8jChQJGX1egbB0?=
 =?us-ascii?Q?azr/KnFVXkVSUAljw4iPF5npBu7Th9F9YEjkGgPxB9HF8I/B3Yea3i5FdKcL?=
 =?us-ascii?Q?O5Ai/T2U4RWraIrdUJ5rb6ebRiADoXeM5ukDHO/1F8YmwE5rT01wbWWd1wkD?=
 =?us-ascii?Q?GOMr5oreMNQS0cUlyS4u5LpXFQsGNAOBthrOXTt9Be4WzikmV/SWbC8Vamp5?=
 =?us-ascii?Q?AUdISzh771wrpDqPckQlNMn7yzgoCu+G6c39OE/AV5foEw+sojE0ul1g17iO?=
 =?us-ascii?Q?N32SV4IgR15++vxhh7+Bja0QTeD6vloc+ld4/oiWIYgHu6zzISc21oe7x7zO?=
 =?us-ascii?Q?eBQqHBZIKn+TPsBdaKxghwAFrcyElN0cFp8k+XoXOj9zZyHIWNx/ug0OkVn4?=
 =?us-ascii?Q?wrzafFEiru9oxRHAssdr+rdtb0+vUfjBLI6L2tZsuEoz2kz3VRT32s6TtxWE?=
 =?us-ascii?Q?JqDQNbt7JXZFTxN1HkxP1sGtNMyaE/JVDwnhM8fGF/EjoXNxV5fO/BsIRubK?=
 =?us-ascii?Q?IwHFCizokeh/FV0oxfIKo/i8ZuW9+rQ5drsFoj5ADonwxS/8tqSlhHJFzfdd?=
 =?us-ascii?Q?j5Pwgdow85RVToLwoe9E4rHlsFmofTaC3xvV5hvWbHTnFRx53TX8CN7vmtVo?=
 =?us-ascii?Q?pLwCAzbsWT1SFM9jdZY62RFPZ2+PGSFlouHCGS0oh7KBCfIG6D2dwry/TwZR?=
 =?us-ascii?Q?iBiRaigqRHkytrleAX36XlQy1bVVyAY8pg0/vQQSmNSNAitQ3vhghRl665XG?=
 =?us-ascii?Q?VaQeEIohI7xUy8MnxowC0IyQdPuJBqmBW+NN215ErbwCLq9a+8Vn4BOECT/k?=
 =?us-ascii?Q?xY/eVV6MlBUFXrqUPafvQNtzg0jOYmn1TC4m6cvrtD5LnwZcKbuHCg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?15fCmquMSTt3UkNpOLuC2hK2ZaFKHIfGHRCMNaIJQ6DT4h3TSXNZ+qSu5G72?=
 =?us-ascii?Q?BTFWNJjW9ODqkiOfQ2sNKjMGSpp7DYLt047iRJbdl10gViVktxGfA71eTWdF?=
 =?us-ascii?Q?uXi+HOONIkwr9Hwy6QxGiwuRhX6xi1R5/vmLsxKT/J7Ux4tdSPAvOaBjK96j?=
 =?us-ascii?Q?8QQ+kVs1lR7/M94iX8Ziweuuenn4vWK8XKWMYBwyP8reJhW7dbRtB/u8koW4?=
 =?us-ascii?Q?vVCS+PsMZfMmiBPp+TkXV0Pe1CP5xBeJvP1v5eZgEoOlfntz66ftEstMppMd?=
 =?us-ascii?Q?BM8qG4dO0iPx8toF1eDL9jd0qAeWhfuobqzNOZGxQEBegzTgxDbNE79F/k3c?=
 =?us-ascii?Q?1IIYhQ2O+EpEwRQcAdnVqP4sIHmzE5ItSA6OMLbKrA0mvWzAqzLHKFB4bYQv?=
 =?us-ascii?Q?lM63+EBRXfpPJ1drfih4zXMqr7NcGTJ9AyuDaq3fOUwF+7Q1BK7ThFkbzhpX?=
 =?us-ascii?Q?AoRu2008GY6Rq57u4o2jX6U/3PHegfiAHadjCjN0Bzktz1gzzRxEq75XZBxI?=
 =?us-ascii?Q?v9nDD9GJwN01lzDiBdgQuXSJuYTcUnlwDJKrQHrdwP2bMfxEcgrIXVgXROw0?=
 =?us-ascii?Q?F4vqZag2zElIoWj98yPdz4aRpINkH6traNCUm+QoKvXVn34T83bqJrXSpiWp?=
 =?us-ascii?Q?juuDunBtltEiHi39Fo3G2WZK/je35tdOyr92EW6T+tOtRfUFvxqO1rFdkrvg?=
 =?us-ascii?Q?dqEJaBbMBbFlL2blg1sFI8fl5ECZmv28t9yumGigZg5d/B07qpS0ejdzAQ7I?=
 =?us-ascii?Q?+isBMupsbz1f6cu3Q9s2H7u5lsjwPfTRfboc0AFQzeZpO6NlZPomuWJamd69?=
 =?us-ascii?Q?l+GG3L536/fvIovQHeCJnLGjqwSiEOkqoyLIm/2/h7brEGgZJSAAAr9GsUcP?=
 =?us-ascii?Q?n1mkzDid79zoLCO8gp0rI5ybLPHLDcRYKLL8tBki8EWSd4SbOzG8w4DwBTW9?=
 =?us-ascii?Q?U2v5Sc8o5P1IC0MPoAujKJdhzL2oygj2kKwGC/TZMyH4pk4n1n4TvnfeSTID?=
 =?us-ascii?Q?/C3m0UCHVso2SUYSH0bnXDFsG8vJr+EPV3k/wFa3lHEup6Sf5q8LywsXEMzq?=
 =?us-ascii?Q?hk87CoNStmBZAkFi9bbv7KSzTGyHgpRNJ1C1Pm5Hx/uIm7p7gtw75dwH46sI?=
 =?us-ascii?Q?+ICisJqHBixazT19u5xAosWqJDpffsWJ+LJBh5Nw3PcbFUIP5jKy9fJC6uwp?=
 =?us-ascii?Q?nXlOBL0oitCGFy8m6mppTgiXAXnKp2lGUMg44mToXlrwOPkUHMQFN6ivi4gR?=
 =?us-ascii?Q?Qlbokn0EcMqLx6dAKsEO199PHQl4ec9jf103V1uBnFWLgD6oRfujK+t1YyhF?=
 =?us-ascii?Q?jVogUp9TNuIpoFTJWcX9IL/NBSESzhBfGRylTwHIXlH8dvXqqHWFcaDgcdej?=
 =?us-ascii?Q?7uR11stFsKtzXfQItI67OfXWPZ5wwSrQ8fivopzGhJtM5DyJ0w8J8Ve51Gm7?=
 =?us-ascii?Q?vB8+4OjcakPT6fLd5u+g8RW+oNG/LWDtsVCfUyfB/s+Vte9+n+js33VSlBdi?=
 =?us-ascii?Q?VYMRMYUted5cg/OT05wWBYeqnx9l1EfVnu91wLDU1rspDwLGt4GNnQElWjtT?=
 =?us-ascii?Q?I+CUmj/kMOSF5jZwthmWQPp+24CR7+3YlGcyAJom?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1697defa-60ce-4d05-29ab-08ddd4008d8b
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 09:14:59.7987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yPj6WplFgFhkHSwEGuLYtUgSnd+GL2eL0mhvTYI55tiWamUFIRzuYCgIqDrRIkvj2z2Mp7RIKvtU8HBhY/cAuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6141

Remove array_size() calls and replace vmalloc() with
vmalloc_array() to simplify the code.

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

