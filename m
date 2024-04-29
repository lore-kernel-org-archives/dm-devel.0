Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2047.outbound.protection.outlook.com [40.107.117.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1854748E
	for <dm-devel@lists.linux.dev>; Mon, 29 Apr 2024 02:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714359046; cv=fail; b=LYqtsIO10qHAFamE9KKfTZX5TFZtC4JN2sq0LusV9KOwdZrKPrsFNa6sBlJF+Mc/l1phHz01EDx+XuMq7/HBkiPeUuCICHEJXpwvOFKH1o1TuZX15K5UMIRtpEAPoEYHy+TtBPMzctC1j7C879jsgJjzsmdsSgHjhfdPBtvhxBk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714359046; c=relaxed/simple;
	bh=wH0bRDwDJ6coVL4nvn2Q59MVkHR4ET4RW5IO2ztL1H4=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=Xad1uTfWTh1t6UyZXIWB0tIVDl4W3nK578ysDZRaHxRxf81C1zmznJtMrm1wMJwm20n0Yv6Iw1o7RUpH7rlQjqbfRWmjtMttV8G7CdrSVkT83AfHH+l08xglVIMbyoL5HYb25tE8QbXMnHWbcEYkNbrxK4H2gIhsKdKEBlXXUbM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=B/gGH/Jl; arc=fail smtp.client-ip=40.107.117.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="B/gGH/Jl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QMvEPhYOW9YNSIbI86h70AGDznHGC7o4FUxiB83ybxVEyXr+Ll8nA1qf7IxnOpWAd/L4cvizpgaF+WvBrhB68lwfgSyv3JK6BwJtxO912uxmCQ6hLz7aZZuVbf0zMWnRov/ATePa9qzpG1I2nzDCjMl5b7Q7uVfYyLOHDYPq2U/DWO3KhpLKBit8VlnVa9fsoiIrf6CY8H1xaVBmv6qo8TrFVde0RtIzHbHS/4y940Laksi12bJ2JuCWHBWBzWpLBExNkTVTWAepsBLTV5ZJIizu7bnNn/VhTlCRT47C8R0Eq4tbGvDYcL6QfJM//Ya8Y0dDcZR9w4ySMhj1BSIP9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bMU87YWCmjz83FtStBkdo/ngsypV4KRejSdcm0EbsFM=;
 b=VEi1YfaZI06l+QwbEXnAJksvicInlO7vTA4pJwApzhUd7ylu7YI3moOrYulVL5rz0bM1tbH3EiZ7gnDmyeAsNJBScRRzvjV3UlBD8cWgzYDjJkNoftjvIDz3ldD3yV+vCcA7WHvwDFZFoh1NqRoxIv566GVa1/tIo3Cr0Je179DjeNHo9qp3tuII9SYEvHWdLYQwghvgdstbElCEn3Fz18o0VCIDy4KIqhgosD2LT+TNoM8Vr8MaQzYM2VGV+i/ALuVp34FAMmxuSHVfwOoGkTK615MLTXunTpS2Q91lJh8ut6NUouEuaK8EdLkO+uUQjfpAi6x+EVuBcstPgpa/yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMU87YWCmjz83FtStBkdo/ngsypV4KRejSdcm0EbsFM=;
 b=B/gGH/JlMQ2z4cjj+XQ7dinAHj02lNvOLh0mMwVmGpGWoXOti4fgDGp72XQl6YezYkOK0UzlN4719lPva6x3eewNyD5jLOnztCfCBLQzdYaRWOkK1pHZ7fFtHEvfTqyWA+0e8MLc9FebnTRRg17t09UVPLdd3X1wefHYDd4kNoWOni6EBvS3N2SxnO8sNHFxRgHT+OcKd3L4u+XslHVY/+f/byLFIX/1UFM1hL4dHjmbf0CtvjMst5QXcG0tHFB6gpqasAFw3sxBiuiqYSI65ksDGDVHlF6znRGKoQcjW6bBaQ0Woy8rZZ6s/NkFO9w9x9tLd+gYJFp//fQK3yIbvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by JH0PR06MB6850.apcprd06.prod.outlook.com (2603:1096:990:4d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Mon, 29 Apr
 2024 02:50:40 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6%6]) with mapi id 15.20.7519.031; Mon, 29 Apr 2024
 02:50:40 +0000
From: Liao Yuanhong <liaoyuanhong@vivo.com>
To: Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev,
	bo.wu@vivo.com,
	Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: [PATCH] dm-table:remove the restriction on zone sector being align to pow2
Date: Mon, 29 Apr 2024 10:50:29 +0800
Message-Id: <20240429025029.1620-1-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0038.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::15) To SEZPR06MB5576.apcprd06.prod.outlook.com
 (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|JH0PR06MB6850:EE_
X-MS-Office365-Filtering-Correlation-Id: be801e0f-c893-4421-997d-08dc67f727a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|52116005|1800799015|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Qz02I3K1m4ZpqLw77T0OmR6AApJdSqEh3R+A3RydAuifwe2wDT1H3nrZo6WO?=
 =?us-ascii?Q?4b8tkbjNKFkye5OH7jJuhlILAqmTYLdBZsCovni4t38Nes4ghWNL17I6jOPp?=
 =?us-ascii?Q?n44LMCd/9ECPWT+iO9hRfMFL+MoKMg1xQAdSYqc8D2gnnzoqWHOf5LAs6BRN?=
 =?us-ascii?Q?/T612SFWlyaN1r/B9kIruQIBeJwlWXamu/uILwLE1XSvsgXwTt1HelW0V5Cm?=
 =?us-ascii?Q?Iq59+gWWQ5ernpk7k1OjgtZykJeTs9P4FSCgVI8s+BfTaOWO2AVcgT8sTjI4?=
 =?us-ascii?Q?JevdvdE9BOS89GTaxQNRBAZJqemTl7iSX1uoqaPg3yREKIv6Vvz6P9Da9utk?=
 =?us-ascii?Q?KaNJ0I1/FQeGf6QG/eR+fBaqGUtbdFWlz8p8P4JuCD8fCvJ6oGjUucgQFndT?=
 =?us-ascii?Q?O9kyhtlRG94CFKU68uvp0A/DG3OBkM3vU/SHD0iapih1+rC6qYfuTi9cW8bf?=
 =?us-ascii?Q?APnVcnrmqXZi5VKDaz6+TkT87L6lp+BENqZsDWKtPPUlUwL/gdhGX+B5tmXn?=
 =?us-ascii?Q?8EUnNRzSBoKtKAcPsOgE+TEbFGXxM5JV8moychPO/I8bG8e7Fo/Si/pD8kt0?=
 =?us-ascii?Q?Xx+q62cKlI58N0A/WY6/BFtyCNwom4umYfUoYwrTp3UT997aDjIIjD6+SMs3?=
 =?us-ascii?Q?NYzGkP8m+g4PM0W0KRk6XkbakNLOLkC4XBlGOw8HSSVO3P6wiTxistqUf2YQ?=
 =?us-ascii?Q?Mf+6/SW2UeD+arpGpQT7M9Hv4n+ybM9RhY2OQSmP3KDqPUCLWCglmrqwqwKf?=
 =?us-ascii?Q?PEXQHTFyAfMqZ6vybwSiQr1ma5Fc0NA/mOA/27oSaPrd+yT1G1EpGTBndv0/?=
 =?us-ascii?Q?cJhv/Z+hZU/HuUh1tGHXpCYFax2D+KEk66U34VZ4uXqyWh6prCKzzZRjgyWI?=
 =?us-ascii?Q?rBULvF7BQkq9EGuiHWog3XUBcM49ZZYKge2XaaB4YfkHPF93hHUp7ge0QvWn?=
 =?us-ascii?Q?AdGySS9jW1JXFGzvL3wpXCx8T9y1MsFGEG5EZy9HnaQNyUBQuiCiPQmU6r9S?=
 =?us-ascii?Q?7g72CSkm5FfSr8Fv6Aov3zzhjil2B/3vh/EOkqcblemkz0BnVCbWhQwJxB3u?=
 =?us-ascii?Q?Ta8fi9fHv/sk25TqfeqetVlVddI7Ab0DcDtT3VTgkZn49ByrYQR8HiAdIHQj?=
 =?us-ascii?Q?bn3lLa/bTKVLgBshQ/FXJtvWoCgX6Q7K9IS+b5sL4eztGQZWBLC6IP0Larsa?=
 =?us-ascii?Q?6T7z5FH0w9TNNHmj7x8+i+KDHB3ggzu+5CiTErowd1j4xVdBtVDvoCOS8vo4?=
 =?us-ascii?Q?Ew0ssoi5/8ScKjCljBXIht5nqE8yBWmSplwzxHC8XDOnZfHDBaOXOM/UejOZ?=
 =?us-ascii?Q?cRkMwKVwbrB6TgvfHNt2hFWVqmWVe8Xh8L5adEdIktTIvQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(52116005)(1800799015)(366007)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DB/vinVZxUHbLmwpNjtxV4V95sdY1K/fENN6O/YeIMpuG8WGw7IDkbG+bJJu?=
 =?us-ascii?Q?K1sc754hjX+YIeLHmv5oA/fgsZYv+kIpW2F2j6uJqhlWYubC4mHvPLJR4NB/?=
 =?us-ascii?Q?ZIHfUYroHjwHlv5HqypTnNyGyhhblvd2uHTu3OmlQjZe2tpp9soOQn5hrMLh?=
 =?us-ascii?Q?NE3esPfQVJfaZwH1AYOmdR98RZjpa+Zf0t9fOd8I7e6oQDxzozbQ2JoWQPiM?=
 =?us-ascii?Q?fDXPPFkki+FXwJAch0VY3kM9pnde6iDudvoPtF1Eej7a8MdIzOYzrCYXNABI?=
 =?us-ascii?Q?A7FJBuQCQ0IKUYkkxtNjVv5y/S11ripm7jeNv9isUv4JYQttcZT6bblPpR7r?=
 =?us-ascii?Q?g+oNJL9afAgsVyYh48NR4HgHQGcFN6xsv0OMXPQbHhdzSbm1rAjqDpN3n/id?=
 =?us-ascii?Q?IEZGXCD5dpINqoc4M25tlla6jXIlp8UGlZDNzyVvZsyIKZS33pS/ipkNkzIH?=
 =?us-ascii?Q?ULphgQZ1Ajs6D1rBmEhH4JAjbb4A7udM79/FLdSB8zmnIdiZZsVXwEYEwJcx?=
 =?us-ascii?Q?JDH1MzqXahW5ab+0AjTtqpjsNKzdzqeAHHJNjSyml1WyHfWhBuc6RsUqaKk7?=
 =?us-ascii?Q?5zpFWVTOURjDni/Qf7pUJYjRmQ3tfBsmqTGNsNd7O06IxStF1SyAPMD+3+rw?=
 =?us-ascii?Q?aJyyH44Bs2ms28vMgvv2lPxLAtCVouqeis9hbzvFWr1szbe7T9ACOiJOJFZq?=
 =?us-ascii?Q?qnIVTqmOK1NP7WLxR86t6YYAC1Y5arZgA/GKgiV5ep23hM4DqVEbxi4shTvK?=
 =?us-ascii?Q?o6QcVhzoNQ4edP2NmvhOFElaeFe/R750rORaVXdPzCYuglRmLhNCg/j+iwQm?=
 =?us-ascii?Q?ob29dG8xAJlpATEFO/KKbL82r39/UDznx4DnbNBrQ7+8MxBdOrlc5BagD93A?=
 =?us-ascii?Q?0c1lfdAFcXjWshW41KhRmDBziPkADgKrO3j+RlNhx0ICalN2ea4swIkmUhlp?=
 =?us-ascii?Q?yaI+G9qX9FJa4die7Vv2gdv+uPcxdoKxnrTSF1AjX0bjsWHP0HdhtcFwNLxh?=
 =?us-ascii?Q?U20wyLo8fNP3nEn57pih402n8M1WlDInFacdpGp+QqwG+sMBXO7dTWcDYRlF?=
 =?us-ascii?Q?wF7CRdNu5sTcLAb0WUy9iBNd15IbsMPZoWIpJZD+moIRdkikW/k+4jPfadTW?=
 =?us-ascii?Q?CD0Qc37msyjyRPCPcROj03NGzbHepkSKhWwO6pi08NYcElC2Yvt0PbTFsQhJ?=
 =?us-ascii?Q?OzbyoF+IEYJ7lh+dd/5sCxtuDG1DWXbS6n/VGR0tkBAO5r7HS2ClHp/DI3cY?=
 =?us-ascii?Q?KzOfWMFsGDuxhT8PWs3wkzlHLqcSmxbfA2ksvswzxfdg5Z7QkH3z+q9wP6i/?=
 =?us-ascii?Q?PTZkyK8YGCwq2eOCck2tPruGAclyJTEBcXqG6La2lsRTNy5zvm0YXMKcscPG?=
 =?us-ascii?Q?I4CP/xb93YEP5o8Ud/7R9qvvJ/08EuxFJWiuSelopxQ9GQfJpHX/yQZO2eoz?=
 =?us-ascii?Q?nKtSjkC3p4JdpBhlHNsjaCOzUk7+XzPYs4R8WFlArrf5dGWEMcSJ5yMdOQnC?=
 =?us-ascii?Q?GPPBmFZmR/9cVIvqiNppaZiShiXcxgNkSDgIvt5bcBHM4GKunmFD6MA1fdrB?=
 =?us-ascii?Q?tiNA+eQ45jKy5hoCTo4DI3Um3V0oeJzh5xTduoHC?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be801e0f-c893-4421-997d-08dc67f727a8
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2024 02:50:40.1692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H/oaWa/hHU0bSq5+XWwdvOl7D642Q1c6BH3rRxyeEhtjayySrAqSmTm6tcliCiAMWhe/QATdbHV3lCSves8BWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR06MB6850

For zoned-UFS, sector size may not aligned to pow2, so we need to remove 
the pow2 limitation.

Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
---
 drivers/md/dm-table.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 41f1d731ae5a..823f2f6a2d53 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1663,10 +1663,6 @@ static int validate_hardware_zoned(struct dm_table *t, bool zoned,
 		return -EINVAL;
 	}
 
-	/* Check zone size validity and compatibility */
-	if (!zone_sectors || !is_power_of_2(zone_sectors))
-		return -EINVAL;
-
 	if (dm_table_any_dev_attr(t, device_not_matches_zone_sectors, &zone_sectors)) {
 		DMERR("%s: zone sectors is not consistent across all zoned devices",
 		      dm_device_name(t->md));
-- 
2.25.1

