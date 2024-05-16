Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2077.outbound.protection.outlook.com [40.107.117.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FA01353FE
	for <dm-devel@lists.linux.dev>; Thu, 16 May 2024 08:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715846657; cv=fail; b=i4e57DTrGR28Cyc/Q+h4QqIhr4USxlvvYts7/Tu1OBVlbKdGMQcH7rSUw72+Et5vKdz5oZeJrDaYheQNpHbvWfgaYzvM7RSjzrDUYmXBJXz6ACZd3weQS/ostv+OSiniU1akhVyM/DKRnMJl72YFv+Wimi+G5OTyex2H3xn3I8Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715846657; c=relaxed/simple;
	bh=Ka0RlUPOcraRrZGtj2xqynrRqvKUIqfl5gHglLt+BvI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s1gciaVwq43bpKdM6yWScvr84sN+IY965EU9dUB+/3yGgCk0QpQ2El3vHepFae0Cu7cMC0SH8I/UB/0urPQUnn/mxVGIEvxkeEMOTxjYVZNnJQJ3IqSJc2oYnMiFkplBIv4MytvYUQ3RZzjn1i9TjyruiRV61sA13Kv3sHZHB/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=VuHs++ep; arc=fail smtp.client-ip=40.107.117.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="VuHs++ep"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IeK1UKFCZk8WqQGk++D8O/mjhBWr/8XzSvee5/ceNu3kpJkrOo+M8WZxP1Tuq7PFXod+9zeU2M7JX7Rhi7iCqy3hPj95u1TIk1H8brXrlgflEGtDBQJStsVHPmJpoV0AxvjZ2Ifkr90j8NSSLilAoDxnngrc+GuQc1mpEeEC/JCHegoVrx4jMXqHidMgjtzCZCeXjjFJWYg/18nOT1//T1Tu9yeoiccclU0X9NjuafjDRkx5IWTMvNJsvVfsAg4RhRjm64SbhhOtltQ8qyePPARInt/OOFsScqJNmBPUqnB7ld/gg3DFSqNEPWYxFKOGmkQUc4QUFMdk4BGVbYgJGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IGw8QMlOkK53XoUQo8KmpkoyGxRrVd+a4gf6PImb2ko=;
 b=kGBbD7FpmM/SQGdqstEr7tIDfoaZJrA7JrOZ5K5x8BTmrIc/Yx/8WT4kMvk3iukzoRbx/G26N5rEhGmN/1tubaPtYR7ZuMgxhp/DuaX938p4KD/a2EhNN/pyco3XpmBnAcPVCyyaJP524Tv+n+f3XDHHiLEz7qtxQygh8nSxkS3XYUbuJnLgK1v6dUJclRE4VCIzOTEutqOJ/9HXLccNVuq+Sa5/60gLK5Xa8awYtklESDuIeDTUgCBJZ2oX5QJT2E7zOQv4egMA0MrokQXqCDFkysdjeElQiyAf+vf/tytXIZJIty/JEOvROqfz9IQp02H7SI0ixX6LCSlMG3oB+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IGw8QMlOkK53XoUQo8KmpkoyGxRrVd+a4gf6PImb2ko=;
 b=VuHs++epf62mpRjBwVWA6S0JVCFSUS7NnT0FKh5EAeorLygHoLZSKJq6tt/c8UhyV6Lh/j0OV2n23YQ5pvZA+6BSv6U3sL003lbz0mPeL53bWxQV4BO31dryplb7/qAvsHzoUS3NZdZQwVAaW2idliOph6CVf0U5nvZd2H+KOwQBN1Nfn0R1gq07C9hp/kOnUEqBaLxR6l5lr2pByi2R+dFb6ont0o9RhZyuVZC3Gk9T4prOo8hAaBTUPgyxabRnwkz9Ah/YHXLOUv6gynGY1TAgA2bje+o5eiDwOsSsrBgyg7hfroLbi0MevWynXbUPCndMwhTEmRjymcgEXyF34w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com (2603:1096:400:42a::11)
 by SEYPR06MB6830.apcprd06.prod.outlook.com (2603:1096:101:1b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Thu, 16 May
 2024 08:04:13 +0000
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee]) by TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee%3]) with mapi id 15.20.7587.025; Thu, 16 May 2024
 08:04:13 +0000
From: Yang Yang <yang.yang@vivo.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Yang Yang <yang.yang@vivo.com>
Subject: [PATCH v4 4/5] dm: Avoid sending redundant empty flush bios to the same block device
Date: Thu, 16 May 2024 16:03:17 +0800
Message-Id: <20240516080318.120231-5-yang.yang@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240516080318.120231-1-yang.yang@vivo.com>
References: <20240516080318.120231-1-yang.yang@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0201.jpnprd01.prod.outlook.com
 (2603:1096:405:7a::18) To TYSPR06MB6411.apcprd06.prod.outlook.com
 (2603:1096:400:42a::11)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYSPR06MB6411:EE_|SEYPR06MB6830:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ed83c32-e6bf-4f77-8611-08dc757ec67e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|52116005|1800799015|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JjDkkDgH/Io2dPnOho9wjfvV9f1VsILh5Q1QRkJm+HoCwyehPWO8zmyLRKHE?=
 =?us-ascii?Q?Kaj3n2knHSakeH/J8Tai4fc/l5F47VhDDkxD4KDgLswEr7yry3iCjXHMuS/Y?=
 =?us-ascii?Q?oF50Dm10GJAcWiaYE1XrSmTbW9Wr+yFlQG/yr7hJT8NajMnvH0OAhVQG2MaI?=
 =?us-ascii?Q?SMMXbmT0p7L7lxFWyCip6S7HclCYr++K6JJWlWC0FkmnpSZC7ENctCTRzN7z?=
 =?us-ascii?Q?QgrHsbg5H0N67uIqGW+ZOUjutJqI8Vh3ZcWndGcHYxSR5PJpnzrh16LiHJ4u?=
 =?us-ascii?Q?egweAvzkkQTDPI3pOf66vLQQCriZM1S8XK4LP92d7KFb/52PP+Fh0YIjt3f6?=
 =?us-ascii?Q?bzXK8IqZPJCbbPLNZNEnpv8E89Vm3SZzqhk00/F1jE69F/rlwggQEu9ojsoj?=
 =?us-ascii?Q?l3K/lPiMcQqf8V6SSXJ7I+2FGcyjErua3m3v0YYLzPG+jfcTfusZQOO3RLJl?=
 =?us-ascii?Q?sccPywC0yu9OZWMjlICe0iaj+Gx2bM+0vHe8HFam6Td7WN1c1I9KeUAHTIsA?=
 =?us-ascii?Q?KDK9qngOB1XbyH/HXewLTa73CESKmsQmwA06dA4mfmQqaGZc4r/EqZasADyi?=
 =?us-ascii?Q?Hwh1/hNOn4LJTJK5oe/rrHg+xE/dgNvXPl7YTIpoGE/e7eodiCxjoznaqaE0?=
 =?us-ascii?Q?JHBFHk2Vcqnkk91MFrwfJfm9XlYEt29wPv480OvAONF3bO8nGfUpEcSdyrR4?=
 =?us-ascii?Q?q2VaG8DmRNTthiQS3GtAicGrM2wGgZXbMtkC6Bb7953StJRIWwWUh16GGHPZ?=
 =?us-ascii?Q?y30ZuH5VIlm3Q0rcwMxIX1ZxJC5H7XdVrFD60jyniE7eYGj7/wKJgwZxncxE?=
 =?us-ascii?Q?RNJbZNIKHm4F13lA7K299+vzmMvZlKx2fd++oGLmTvxJ//RzYpKi9/iqrE66?=
 =?us-ascii?Q?ZXhQRdgEBTbVqZUtd6mH0H2x7sMUYBeuUJKF3QG5CJD22IJ0cc3bevacza69?=
 =?us-ascii?Q?ipt40YleaRVIqNpP9/GZOaOmsKs8Dm4xwQ4uZy0nsZgPBjfiexKTLAFS5mwz?=
 =?us-ascii?Q?eNeHfvOZnxFgDryUbHrkxzPpOGMcF3gBrYhYJ5Ot6LpwtcJplYWqbfrB6MSU?=
 =?us-ascii?Q?E8E9Jh8ELYQY/WDSmDOt5zPEFypmG6C80SUHV3x271qJrB85Rzf06olPGsrL?=
 =?us-ascii?Q?cI+EdXnv1UGMLKzcicIOkKXT/VoE/WCu53hb/YhiU7lQDUDydY0tF00hl6MR?=
 =?us-ascii?Q?BfzST0k4Q9Is9G72R0V8gwtFOAvIlmCsvTd5e05zpaH7/zCB5W4XmhY+Hdg1?=
 =?us-ascii?Q?n5r6LiFqVn4ofJgg97knwa5LSYLy9pDDkoEdlWh31whoPAjm9OKrFbBTXDg+?=
 =?us-ascii?Q?I4IrWrJQUmiavLM6kpX3mIA08RGfFqYA7VewrXNCBEu71g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6411.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(52116005)(1800799015)(366007)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KI/mL0AeTwWoy0nDbkTVNimcTYlcZCzqAHb/hZcR9/elYENcp5tWyBsGDKfr?=
 =?us-ascii?Q?Hk/ke9z9eqoVCuFh6lyXu9HIplzjYUR5djQO4/PkaKK9XTUd4uKqVf5D/hGA?=
 =?us-ascii?Q?xdy6flGJ7+CfJElNZ5X3VtMTwcz8GXPfpwwXKe+9+u3dsnTHWj5VPbn0/Y+u?=
 =?us-ascii?Q?Dd1LyxJMHQSWifpiG6k7ypG16BNxGV1V293ICLg28ETO73iFHmTin25b1tUa?=
 =?us-ascii?Q?gWBvjkWv8YTa5jyiC6UEVqiu2VujB1WsfpEmMi+ne8OGMw51nHkM3BJ3tUha?=
 =?us-ascii?Q?AJsVdhFZ96EnobwKA5rEq3MkysZlQeZsnIbWwaALaNUYlUAWbvtLNgUo8wDr?=
 =?us-ascii?Q?/xWbvrZdudGCSj6X07hCULhowzV75JMFz/H2xWrOO0kYr5+Qpp1OGmuJMdgs?=
 =?us-ascii?Q?fCV2GKatKng8KQKwA7DImaNW5XPJ+vbq7c1tjubITLO/P5w3nwyXnZ4oDnmr?=
 =?us-ascii?Q?AEkZh51uaPNjXLl7aOStN+YJXkK8ZDfJK09c4uCw5MrcxY4MYoDS+u7diwgG?=
 =?us-ascii?Q?QDXJrBYdp1Sn23xV0FYCSwLTsSDmvTAg6EvsVgN3/dUMgGrtlkN1eKxG/8+9?=
 =?us-ascii?Q?TAUlULawbGmo5DXNkzUHN+kwsU4U7Gtpi2dMXFq0XENPHhZlM8QxzyqvnIok?=
 =?us-ascii?Q?+Omd/91frxctBoSqZvP0Kzeuxvo5jnDPfVIGHen/LFR867NKBf1V0H/lwIzQ?=
 =?us-ascii?Q?7Xdy7f0kOTXdrX/lyh8pLkBmKgMi1cVEJl7qaXfKgjEgEwMR2IPe2ovyeOm+?=
 =?us-ascii?Q?Au4wse9vaUJBOCAK7FZOEm7batqbi2pnsma4gJzZSUz0CUTi+CM9XYra1nGC?=
 =?us-ascii?Q?3xDYdzZu5c0Hi9X+BWOqXiTsUAiXBv5UCVSyxPnDW+LGoKovGd2Vz0124LJc?=
 =?us-ascii?Q?V7uh+QHUgtddQB+Kj5X2U/qTSrHBVfNuL1MYLpnnZnl4ezmtx5XZy+0zvAiA?=
 =?us-ascii?Q?XTAH/q3UXG8beWuqS4aCMNJ9rcr2WGmcbiDeESGKSAml2sr8NULI3Jydjki6?=
 =?us-ascii?Q?WEsNWpQa2SmpqClzWJqesNOIjzprjT0f+br0OrNDjIbx5q56LPzsGfhXPKOO?=
 =?us-ascii?Q?hf4mANZGkEZlWSwvuY0MG+vei/QrzcKPy3kE7q5ISLT+yJpct47/AMB09+4f?=
 =?us-ascii?Q?KmNZqhjvV1LsS/BKk7KWAlqOJGanD+DoM6kNfnDwqraKltpYTc7wTncAxRKG?=
 =?us-ascii?Q?bDGZx23agfOL+l/TleVgNmZn/oWouWWZizwVCHrAL+NQwZte+sDOyogzVG6d?=
 =?us-ascii?Q?H8/xlF2cQyAqNy/werJy+ppKW7gj0TpWcufkrBoSHv5A88wb7Eu0aIMT/oUt?=
 =?us-ascii?Q?UAs2GAIjEXctzj78HYRIcm/s3Ai1O/LNdX5fKU9e2PG4dHy5Ti6Cud/L5wby?=
 =?us-ascii?Q?UgJp1OZKr81ekMRjimJ0l4gClFOHEHCRgHb5yDx0ACMdNQhyuSZxoLKyc4Gf?=
 =?us-ascii?Q?KRH4jyrQlp4q+FDUB1hPPOJHZvHYEFlft7W9sxKhHkVyaJ3X0Qn48ybj0Wzu?=
 =?us-ascii?Q?VgCp7adsC5BZWnBBnS9TOhSrM98nIpsi0wNBcyM0lUeZalU+Cpe96aGRHAGb?=
 =?us-ascii?Q?PH7qMMtqT63K27IpgA4v30WqdyET4hCDD52hPmdb?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ed83c32-e6bf-4f77-8611-08dc757ec67e
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6411.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 08:04:13.7946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BeI8ubqFgMmQgk3sx0uObkAM5DLSuUeWSr6zRd/matPnYRh57OfKCW54NCLxsb3d9I21+5M3wyMqmrwsEi0X+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB6830

If the num_targets is greater than the number of dm_devs in the
dm_table's devices list, __send_empty_flush() might invoke
__send_duplicate_bios() multiple times for the same block device.
This could lead to a substantial decrease in performance when
num_targets significantly exceeds the number of dm_devs.
This patch ensure that __send_duplicate_bios() is only called once
for each dm_dev.

Signed-off-by: Yang Yang <yang.yang@vivo.com>
---
 drivers/md/dm.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 25215b93c3cf..9dd0f5c97028 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1561,6 +1561,7 @@ static void __send_empty_flush(struct clone_info *ci)
 {
 	struct dm_table *t = ci->map;
 	struct bio flush_bio;
+	struct dm_dev_internal *dd;
 
 	/*
 	 * Use an on-stack bio for this, it's safe since we don't
@@ -1574,10 +1575,18 @@ static void __send_empty_flush(struct clone_info *ci)
 	ci->sector_count = 0;
 	ci->io->tio.clone.bi_iter.bi_size = 0;
 
-	for (unsigned int i = 0; i < t->num_targets; i++) {
-		struct dm_target *ti = dm_table_get_target(t, i);
+	if (!t->flush_pass_around) {
+		for (unsigned int i = 0; i < t->num_targets; i++) {
+			struct dm_target *ti = dm_table_get_target(t, i);
+			__send_empty_flush_bios(t, ti, ci);
+		}
+	} else {
+		down_read(&t->devices_lock);
+
+		list_for_each_entry(dd, dm_table_get_devices(t), list)
+			__send_empty_flush_bios(t, dd->dm_dev->ti, ci);
 
-		__send_empty_flush_bios(t, ti, ci);
+		up_read(&t->devices_lock);
 	}
 
 	/*
-- 
2.34.1

