Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013071.outbound.protection.outlook.com [52.101.72.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BE93AF662
	for <dm-devel@lists.linux.dev>; Fri, 18 Sep 2026 14:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789741208; cv=fail; b=LC08kc0MgaV8TGoXetog573BEewpPfPJvDa4fQkQ8dSRlumYdLqdpIns4himnE8cSCZCInbOeGSFQSclOh30ziTorJUpV75TDk7OYsRhClSYrWTR9nVnntXen3mJFskbK7CN7JK3pU3oft4/VyD6UdaT5CUPlrRF07mg1UfM/AE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789741208; c=relaxed/simple;
	bh=amZcJb0lWgLi+35dHfglcL7dKtVPOpZl2MYRHJNsJ1s=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=h3BctYmT3Kd6IXoZhVeYFPeyGyeh6Ja9JvXvvorpT10vg2+lTCNCAmpWXQOecpOJiliDhw/MmmRU210XWvZf8tdXOYd8nJVPQRmBVBQS6hsamT/UNaXmJIV0nV8Y/vN4I8ZKcBSlGZJRrUA5xOtmXa1UpNSuNU1ZSghXdWDGC3I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=acdeoYm7; arc=fail smtp.client-ip=52.101.72.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="acdeoYm7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fpb5OTyOVJdq7YmfN56yvAISjdu+vUjUwCn16U+9njBcpFCP7vVFZBVAP0zu9Q3LmBXjfBJSddXQfTdTMI35ZNefhxaPUij2QoJiEwvXoC/1HAY5OW/8cPm4BsUe3Lkp7dsom/uEuQIJNGhgqPqjrUhgigEHWeF76VW5AS4pZsqOYsBMtWLBG7Z8GdWKqhH/JBvwlGQrvpsUDts5uvopxhCZ8Z5dsTcsGmDqZZulzhyO9y/iJWUEfgHQS6I183yOTVjQQMmgGiqAJag+kE/P1sA4NuYOoYMEuDlgucNM1nLjM/0RB4EDsfwHHC+5jGcP5WBkEzi3eu2JSffN0sAd2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EnuAIwCxIRaQdlFGA1SdVYNBIF/QA22srvw5iwnXjq4=;
 b=Flxac4YMLvjur848LUWD/h3Pojp+hCFijoeUEombMm9PpPb4/Go+sZaHi9xzL3H+GKNve4YZB0qWdVNJr+zc2/G4eYj1BQF18Su1G9ON8bR1hqqUYf6Rl1e+dIxVo1w3GKrppomURVvIkX5WbsPdgDZXq7F91oVZMr/EeBjvLNWZCc0ffTjrl6YVfYHJPhrVf4VDXEfuqQxUDKjXuCrdsoJZnuekX3lwkDPgQpnFAQ8iGMh7bZsCKgMAKN+XSDzhFc2rmIHj0HSrFkHbVL6AiTSqbg3voGm0+qYaZHQtn8bKAWyJgeBjY6pZHjyAIF1TTucCSEwlfzGBMS91l7N1Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EnuAIwCxIRaQdlFGA1SdVYNBIF/QA22srvw5iwnXjq4=;
 b=acdeoYm7N3PCnH9hsDh/3dNn/v5M5aT6AtTk4SIQbn9E3R/ctTRfEea9WjumdPUgrdUrqJvHpWiJ8eT4PDOe3JSPy/OzsYPFkCU3RsFuNPwzmJAL0a+xituyPOSZ1qy5x5s7vyghQldeP0jFpeZkXIrZ3pcQUzDZsVwFm7dGGNILYG+nXEMnzgonPeKFIIrSjqK9HCIS0zPsgT4l8afxYCRpGbT8iFqHe+4y9CdSEVDyvOMEwtMJhIRL4P5vX+oQvVDWloaQTY+l88Ag+Tu1oZ3tkT6LJvZ/I8haiaH5MhbnVNmL9hMpbREn/3PfE1CWvN9tuHE6WxK10sZkUQMu+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by ZR6PR04MB296659.eurprd04.prod.outlook.com (2603:10a6:910:e1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Fri, 18 Sep
 2026 14:20:03 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0428.011; Fri, 18 Sep 2026
 14:20:03 +0000
From: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Peng Fan <peng.fan@nxp.com>,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org
Subject: [PATCH] md: use assign_bit() where applicable
Date: Fri, 18 Sep 2026 22:17:35 +0800
Message-ID: <20260918141737.3023011-1-peng.fan@oss.nxp.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0028.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::21) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|ZR6PR04MB296659:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b7da716-5b02-47c7-6b51-08df158fee5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|376014|19092799006|1800799024|56012099006|10067099003|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	CHJEK1ECK9N6+KlWMRr/m1rgFhGagyKlr/AdHyemZYWgtbOQGO2EDWr6hLmDW8dGS3vfRAKdfwzkbdZvSLBQsC3knVnbHG2ZTE0J0z4ysOS6+CvycSnLPDxw1V9JwqGWDsIWx+5wEzIX0G7yMACo/NfFqCTWS0MKjPBAyRE/VJZEBEwy+VpqSWVfpevzGFJSb7Tyr17c1r8XOVcUvs0pnZAM9fpNzS1aNk/7yCPAfsh5/JcWAwLoPI+cK4e10Gec9hEaXpJtWEx8IqEzm7BryD9D+B1sDdk+DSRsoQsded+hbMrT5o3V/QYggYcM2ob3uqAhE7n7rbeBUtKD2QGNPZmSiPvtruU8c8mHA4gHqC97AXovdFtNoyeM6aYVrFNBgR+eT73oIvycJ0AJUu7V5CRoE0S1WsVRhIkbkHkd/CY+4lgCssDqGr6+AU95ncT+q3kqglw6zVZ9FBHFMMXgcDyWQPVqOHV9t1j0ZyD8u+Qr+xvHx1DaShpofGGgvbJEoPq7W4Lf83uAbmV38qWI+WXFy/5/Mrc3+GqhkrB8Lj6er80+3rYjCwmqbJgaCmwldfGeKqQ9gmzczxIvlU8htIc86ZoHAdiEpJF++Jb/7+XFIf3txRJOwZVSqOyFc86Cd0zTjKhdZ2rg1SM0QYcsq92OTsbsjgys/TqDNBgd62k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(19092799006)(1800799024)(56012099006)(10067099003)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5TtoYqva9Og4MPCC2YAOI+KSpaaY1+2J+MUnUineOPw42RBEU6t8rFAVkUjz?=
 =?us-ascii?Q?yhr4TLvwJ7mY0hOAaJ7jrsK7JT8UBZDt4US5tdbOQQsnIwp4huDKRlf9aUxx?=
 =?us-ascii?Q?mndETMUeOChxqmeBRXTBZj/J7MZMCO5BJLeTHZO8Nj9S/he/nVTMP8PELrmF?=
 =?us-ascii?Q?KuRrbUUjrN8T/GJAYZ5IOmgUylhe0UN2AED7sM6NIA351M9SxzDhZasYqF1x?=
 =?us-ascii?Q?825e9WSaJEK5oaHbQTRVwPxhNm/DdFji27C8Hvu7ujNcJcjCg3n5xt2RypeV?=
 =?us-ascii?Q?+drzt/ndMCcOXfvdhBYB1Jo+YUoJtuFp1ArZ6YBxmv5C++ngelDhEqMZf24y?=
 =?us-ascii?Q?Q2oHCs9qoCHCJNRQZ0VYBm5+WsaPyk36mBLktjVXlGXRn3lIt5c+ZfM/mgVM?=
 =?us-ascii?Q?NDH5AUw4UL9QYU6fg28qSlfgf1+yI+tESZ9ytov1zdYaMMXOQ1eFui3AhCba?=
 =?us-ascii?Q?gI1XnGPJ+HX+CNWTQATyz4PcBxvU9dLAjcYIPhqR0+181JNKIorvlS/DrMuR?=
 =?us-ascii?Q?sK0rqhLiH6AnoqtlvIDFngzIavYwOr2OhzyuEQmiSUCkAAlWpjsvomEp5G+Q?=
 =?us-ascii?Q?oDM8/ndRMFGJo6jRXfKs002q4ApZmKL0hSIaY9QIKElfmQ7h66buoQjqw4Vi?=
 =?us-ascii?Q?bGobLlQbcjkSwwLdEaqKNZsE7QxzyY1ARhlKhOtMgFTvhxqmELUY7q9Bgpx9?=
 =?us-ascii?Q?FUACQQQWBlUiQ7h3/MGNUNEIgRBOuZVP+bc7KfZppYwgV3YonHBF1r1bnPUb?=
 =?us-ascii?Q?n+BkRzyNT7zshsG5ppmKCst7Me8RncnKDSJSyRpK9C0Z/Ew4tZDbrd7BnFU8?=
 =?us-ascii?Q?kXrL74OGHaKZlrAzaXPoFEOWeYgJjnRLQ5wBwdrN3cGc6S8fB4R+pSX/2045?=
 =?us-ascii?Q?TGVk238ZlGTEFgB2/kZ7F5FczLb5i9kXfHJv7F5+wnr7TaIOOOnuYs5rPOpQ?=
 =?us-ascii?Q?uFwGh1wlK2PAxy37K/aum+ll/g7LTUVi4d+sOeLN6XaFyzt/g7iIbSxRn886?=
 =?us-ascii?Q?td63AzFDbsuQHwjtsXvkL0EMFcDHaM4T0Ba+CeJ1ITdtdmsA2z/Y9u1sLLcp?=
 =?us-ascii?Q?LjnZm6neEzLqjWjiEX1fkGCZgUcqQp47BdHMdp4HUHi325vmYPFnWfJNqYND?=
 =?us-ascii?Q?6qbMi10h4DWabhN5vWOTOtcK5XTX+w+gQJQp0gs1hy8qk05JhByhZ3jO1i6/?=
 =?us-ascii?Q?qkmoztsaHAs/b/kgKw2g6ebBn7fbryysBPjk7BU0mmbqROxM+ITA/lx6Db9W?=
 =?us-ascii?Q?983RJdOUFFYg0vHxR+WvPPF/1mcGhhaJuEApT3q6dDA0zbkbYcV5rAEmG/2q?=
 =?us-ascii?Q?U4A0zYUdWZqtX45SV6wXLRq71kh2m6c1M0zrlsFbWWrU8dc6WZAEzFClKssO?=
 =?us-ascii?Q?EnwYJg/TFfQU9v5dnueqEECVIdUizXOg9zpK3RiI5/rFJyS7aBQrf1WWWh5I?=
 =?us-ascii?Q?I+qDa2ZtEsQ5pe2OxbZPdzQqkXzGqF2Q0ERIvCF0tiDkND5mhDOYbq7BzHqc?=
 =?us-ascii?Q?yA7PR8Zv0HxUwQjZYz2MHuQb/5Du9Ka76E98T7PIecIhRzDAVGxumhYu9w0q?=
 =?us-ascii?Q?1JOUp6/JXCBSr97aePiXOlDdS6ILUZ/CVcds1bGXrc1jG1FaQRgqqy4pmATZ?=
 =?us-ascii?Q?5wwmmgAenJDCGGi21sfgRv0slvN6SNKkn3WwIPU0KEvqv6BOSaXLu8HmPoA4?=
 =?us-ascii?Q?vQlAKkKXNf0S24o9NF1HgFiOgKhcBmeb6Qlnzg6mQriEfUQKuI10nr2SefyU?=
 =?us-ascii?Q?r66+BKXge/ZxP6BtDo95aIZqm1wRP94yrttEJ5FrA4AOtwgQbJS+?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b7da716-5b02-47c7-6b51-08df158fee5a
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 14:20:03.5898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r8WuUSQ8kga0gA6bknZ5Ed6UM7FAwc2gZaCaEOChJAbA4jv47UEHoITrKOtD8kQVVEci9mcLkPAZHDa602pZtuEe8QGKVQF86//t/88rxKxGogAFJucdBFtlAZV2InMP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR6PR04MB296659

From: Peng Fan <peng.fan@nxp.com>

Convert open-coded if/else with set_bit/clear_bit and their
non-atomic __set_bit/__clear_bit variants to the assign_bit/__assign_bit
API.

Done with Coccinelle semantic patch:
    // set_bit -> clear_bit => assign_bit

    @@
    expression cond, bit, addr;
    @@

    -if (cond)
    -        set_bit(bit, addr);
    -else
    -        clear_bit(bit, addr);
    +assign_bit(bit, addr, cond);

    // clear_bit -> set_bit => assign_bit

    @@
    expression cond, bit, addr;
    @@

    -if (cond)
    -        clear_bit(bit, addr);
    -else
    -        set_bit(bit, addr);
    +assign_bit(bit, addr, !cond);

    // __set_bit -> __clear_bit => __assign_bit

    @@
    expression cond, bit, addr;
    @@

    -if (cond)
    -        __set_bit(bit, addr);
    -else
    -        __clear_bit(bit, addr);
    +__assign_bit(bit, addr, cond);

    // __clear_bit -> __set_bit => __assign_bit

    @@
    expression cond, bit, addr;
    @@

    -if (cond)
    -        __clear_bit(bit, addr);
    -else
    -        __set_bit(bit, addr);
    +__assign_bit(bit, addr, !cond);

Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
 drivers/md/dm-mpath.c                  |  5 +----
 drivers/md/dm-zone.c                   |  6 ++----
 drivers/md/md.c                        | 22 ++++++----------------
 drivers/md/persistent-data/dm-bitset.c |  5 +----
 drivers/md/raid5-cache.c               |  6 ++----
 drivers/md/raid5.c                     |  6 ++----
 6 files changed, 14 insertions(+), 36 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 7cb7bb6233b6..ae9318f5f21b 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1604,10 +1604,7 @@ static void pg_init_done(void *data, int errors)
 		goto out;
 
 	if (test_bit(MPATHF_PG_INIT_REQUIRED, &m->flags)) {
-		if (delay_retry)
-			set_bit(MPATHF_PG_INIT_DELAY_RETRY, &m->flags);
-		else
-			clear_bit(MPATHF_PG_INIT_DELAY_RETRY, &m->flags);
+		assign_bit(MPATHF_PG_INIT_DELAY_RETRY, &m->flags, delay_retry);
 
 		if (__pg_init_all_paths(m))
 			goto out;
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index f29acf64429a..35916c6e490e 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -447,10 +447,8 @@ void dm_finalize_zone_settings(struct dm_table *t, struct queue_limits *lim)
 	struct mapped_device *md = t->md;
 
 	if (lim->features & BLK_FEAT_ZONED) {
-		if (dm_table_supports_zone_append(t))
-			clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
-		else
-			set_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
+		assign_bit(DMF_EMULATE_ZONE_APPEND, &md->flags,
+			   !dm_table_supports_zone_append(t));
 	} else {
 		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
 		md->disk->nr_zones = 0;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 680b34a63cb3..6b2a397f8a9c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3586,10 +3586,7 @@ static ssize_t recovery_start_store(struct md_rdev *rdev, const char *buf, size_
 		return -EBUSY;
 
 	rdev->recovery_offset = recovery_start;
-	if (recovery_start == MaxSector)
-		set_bit(In_sync, &rdev->flags);
-	else
-		clear_bit(In_sync, &rdev->flags);
+	assign_bit(In_sync, &rdev->flags, recovery_start == MaxSector);
 	return len;
 }
 
@@ -5915,10 +5912,7 @@ fail_last_dev_store(struct mddev *mddev, const char *buf, size_t len)
 	if (ret)
 		return ret;
 
-	if (value)
-		set_bit(MD_FAILLAST_DEV, &mddev->flags);
-	else
-		clear_bit(MD_FAILLAST_DEV, &mddev->flags);
+	assign_bit(MD_FAILLAST_DEV, &mddev->flags, value);
 
 	return len;
 }
@@ -7574,14 +7568,10 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 		}
 
 		clear_bit(In_sync, &rdev->flags); /* just to be sure */
-		if (info->state & (1<<MD_DISK_WRITEMOSTLY))
-			set_bit(WriteMostly, &rdev->flags);
-		else
-			clear_bit(WriteMostly, &rdev->flags);
-		if (info->state & (1<<MD_DISK_FAILFAST))
-			set_bit(FailFast, &rdev->flags);
-		else
-			clear_bit(FailFast, &rdev->flags);
+		assign_bit(WriteMostly, &rdev->flags,
+			   info->state & (1 << MD_DISK_WRITEMOSTLY));
+		assign_bit(FailFast, &rdev->flags,
+			   info->state & (1 << MD_DISK_FAILFAST));
 
 		if (info->state & (1<<MD_DISK_JOURNAL)) {
 			struct md_rdev *rdev2;
diff --git a/drivers/md/persistent-data/dm-bitset.c b/drivers/md/persistent-data/dm-bitset.c
index 00c0a3f186b7..6680f05c25ec 100644
--- a/drivers/md/persistent-data/dm-bitset.c
+++ b/drivers/md/persistent-data/dm-bitset.c
@@ -59,10 +59,7 @@ static int pack_bits(uint32_t index, void *value, void *context)
 		if (r)
 			return r;
 
-		if (bv)
-			set_bit(bit, (unsigned long *) &word);
-		else
-			clear_bit(bit, (unsigned long *) &word);
+		assign_bit(bit, (unsigned long *)&word, bv);
 	}
 
 	*((__le64 *) value) = cpu_to_le64(word);
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 7b7546bfa21f..b442a4de61fb 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -432,10 +432,8 @@ static inline void r5c_update_log_state(struct r5l_log *log)
 			wake_reclaim = true;
 		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);
 	}
-	if (free_space < 3 * reclaim_space)
-		set_bit(R5C_LOG_TIGHT, &conf->cache_state);
-	else
-		clear_bit(R5C_LOG_TIGHT, &conf->cache_state);
+	assign_bit(R5C_LOG_TIGHT, &conf->cache_state,
+		   free_space < 3 * reclaim_space);
 
 	if (wake_reclaim)
 		r5l_wake_reclaim(log, 0);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b91545ce090d..713596ee933c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4748,10 +4748,8 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 				       RAID5_STRIPE_SECTORS(conf)))
 			set_bit(R5_ReadRepl, &dev->flags);
 		else {
-			if (rdev && !test_bit(Faulty, &rdev->flags))
-				set_bit(R5_NeedReplace, &dev->flags);
-			else
-				clear_bit(R5_NeedReplace, &dev->flags);
+			assign_bit(R5_NeedReplace, &dev->flags,
+				   rdev && !test_bit(Faulty, &rdev->flags));
 			rdev = conf->disks[i].rdev;
 			clear_bit(R5_ReadRepl, &dev->flags);
 		}
-- 
2.51.0

