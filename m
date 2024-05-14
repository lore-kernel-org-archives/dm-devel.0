Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2051.outbound.protection.outlook.com [40.107.215.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9942C85D
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 09:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715677556; cv=fail; b=p9t+xkypvj9dcf8caUNmoaeYCD4w8JXCVlYCr7jsypcCCyFBCLx/rPRSx5ucOUdRWD71tu3CjimPdwSS2QVBNaRWTZziwciMoAqXBIkC4WyNmQnPvME2ymceY7x7ziPAdQ0Td5bD2qJpDqzKG1xiNr3VhECFUEGi6IlMK+9uyIk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715677556; c=relaxed/simple;
	bh=d+6J0DopE8a1tqTqwm3DC/qdhoRyEx3y9opRon/FBkE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tniq7SDUjcfD8mCRFBwDNug22FEzaB6GeQmSfS5AXN4kiiZwlWwGlpRElO2tJ7VUkn5Ls2DSwsLNCq/wHyRfvYmJpp2w+Y/bjRq3gbFaEOxgnUWRPuhKUi0Thnvv/YlIC4m79+114Ox1pPM0V/ie7To7zvDzUo3ZgzvKLFcct6g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=LM0rILLw; arc=fail smtp.client-ip=40.107.215.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="LM0rILLw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eHGgdT47Bc+EmStViV7mEvGWa0jxcqzPeFkugI5ozzD2JZJwmch2aBUSM6F109Eff9nc0kMA0AsO3/74lLY7C3rQy+ZFe8xTWmxlBi0DiEnEKf7gUA66tUkRiBs15gcVK9N7IoT0uGo5nyQfKRzTAmAqRunF4plovdTbvCJlhzqlerYVwizYfqbaJb7kHKPPsJ/rY6ovncdE3KSNtEjFiOHBCF4CVzyWjfQIWGjLIyLvl/087RFRYyiI6XuF/7YqCHhcG5cBOEH4LRAlA8KXfK6zy6WGKGGiGzCoSx19WyGyFlHZtS74wPpBKZ6Nhbys6kU+zbV4n9AiRJuVmgoO2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Ly6WgXtiz0dA/xzmP8OTqpgBcoRWGdPsXGNgS1wPGE=;
 b=Ykn2MKHRd5FO4padJBdLALtEqtcNJgPfxfx6Rj2SLJxQZHDzwizDfKKFFQM7LwoRJeAcQrFXNymTQ/cgCW9Y99Fj2p9bMBbg+bfdkJ4bs35In8V7hkoITxeljtzuLAzD4Rg0ZNO9eUE6fAnWj/tl4qb3F7vil6XyzkgQdZnaNm12t8pr+fjLoiZemBnHrzvvnSX94kVr8g5zxaYtQSjqHXgb26Mv/C5ZKDN8hgXupV9LtN9VV2F3Z/32bJIUusuqL96+/9OVmeyTz1FqVAXMVJrsM44Ly/IzAaSV5uMG65S7hX/ErZd8D+XPjLXZ7KHp85bNWRok9YaEEx49Gp/VfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Ly6WgXtiz0dA/xzmP8OTqpgBcoRWGdPsXGNgS1wPGE=;
 b=LM0rILLwbzyJVUqPcDr+ciRyku2jtjYt/jabd49siiQV2QZmfvsrYXAIiq5QUoAOtHk2ApKHWJC+oqOhPMTp2QIfSv6dG6ltxCIz6s0j1qTWTx8HlRz6+uh/pt6leSgFnM7MNC9DGB8gDqL0EfoTMBPtC8d4ikF22KRI5iXkCMv5VK9dUlIj7Cbyjv7nXJC/eWPdmNXo5E6hl5ENYmDy5QWxytnOx1a+6hz2BFHHIoklWwV2Z7NOZi0JnKVYpSyaB2RSrxywILXctmtmX/o/Tn6auxuOvBekuWJfoVNY/68JpCOfP9lFg7j2cjxyzS9cBHZCUC7mDPK+QN0al2zTkg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEYPR06MB6398.apcprd06.prod.outlook.com (2603:1096:101:145::9)
 by PUZPR06MB6102.apcprd06.prod.outlook.com (2603:1096:301:112::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Tue, 14 May
 2024 09:05:48 +0000
Received: from SEYPR06MB6398.apcprd06.prod.outlook.com
 ([fe80::9784:d8bc:5eb5:b60e]) by SEYPR06MB6398.apcprd06.prod.outlook.com
 ([fe80::9784:d8bc:5eb5:b60e%6]) with mapi id 15.20.7544.052; Tue, 14 May 2024
 09:05:48 +0000
From: Yang Yang <yang.yang@vivo.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Yang Yang <yang.yang@vivo.com>
Subject: [PATCH 1/5] dm: introduce flush_pass_around flag
Date: Tue, 14 May 2024 17:04:40 +0800
Message-Id: <20240514090445.2847-2-yang.yang@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240514090445.2847-1-yang.yang@vivo.com>
References: <20240514090445.2847-1-yang.yang@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0046.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::14) To SEYPR06MB6398.apcprd06.prod.outlook.com
 (2603:1096:101:145::9)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEYPR06MB6398:EE_|PUZPR06MB6102:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ddbe501-f402-4523-fd93-08dc73f50bd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|52116005|1800799015|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tv9uyUug7qbgWIg/WUd6y+j15lmemrDBtfeFb/QKE866LtICExhC7F+wQM39?=
 =?us-ascii?Q?QwtUieO0PNuQxfnJxTUo2QwhO2zPlSwg0P1j4fx4QBCzxavS1gT5OxX6xvE7?=
 =?us-ascii?Q?QpmdRy3FgfDo2PWb3LWc6lMC4u3/LN7m3DcH2DDnblF2h34ajPzS4UiEFJTe?=
 =?us-ascii?Q?ddEgLYceLNTJhKGTNoU0XB2sjDe6Vs2XT/7lGxTxasZn/ppn833Jkg6DXanC?=
 =?us-ascii?Q?NC015zQIi7rIy63yMIESEPw0udGN86SywynLKAgoGc9OlIrubngnI8E6qur0?=
 =?us-ascii?Q?ueeRGshFYHViB3QDFUugjPAeDXp0UGy/YsU5k2Vp6NGOfZWvCYcZYRJfY5Ft?=
 =?us-ascii?Q?17qh751hYLL+slfZttFsDX2c7eUokotZFg7UGB3nmMDMyhnn0h2XLbJlOi3M?=
 =?us-ascii?Q?UnFWZii1gBgBXA2IqRR8CXUjE1LMrXUoffAR9r9VGiPb5k6u8N1Tq4/VtFLx?=
 =?us-ascii?Q?zB1H7hzIZXvnl/R1FFexJ/BbSvnYqFE/iox7AqxRCaClJZlrI2idXXEC5AMN?=
 =?us-ascii?Q?E4vGVHpq4T/75q24lxXx1OH82xdQAPHxWAvuFsGN1dmn5rk8mhiDUIackIb9?=
 =?us-ascii?Q?60DFS3wfablSFJpJjjprO0RZEOQwb6s0WF7048XKayVm63w7Wd+84eTZxWx4?=
 =?us-ascii?Q?ppsO6KZ2iQWldksmgFHsm/pzpOMNv9BBmtfPR99TsTalAFfHtBgY2DdnnlgL?=
 =?us-ascii?Q?Qvg4SJ2laJjEc2Q/6WuyN6G6BkSRdjVqE/FASJcLQBqykEYuDD4MfzmMObzp?=
 =?us-ascii?Q?o616F9gm6pyeFXzRaCdKg84tw2l2ygSReqyMCo5fng+6q9qYCm6/kkwxR+la?=
 =?us-ascii?Q?LdDexEW2oOO3ruWlqMdd3f5hBED6RHmjKrvxbKjam8GFCzL1ROBDscCqklaz?=
 =?us-ascii?Q?mPD04aO7KFrOQSjpFddJRWmK1vSrlVLnU4D5brFoICbgowBVnQZjT/inMgwV?=
 =?us-ascii?Q?XBLgqnDkOAYtd4qo07TiFyfjPYlUzjcm623Pfu/EVDBDfCkq+Qt4HYEl96wr?=
 =?us-ascii?Q?NQMa9hj2Ntm//CHRgF7x3fotRmnjxU9st6nyl2saBRWrttOP2cPzthZiLIgp?=
 =?us-ascii?Q?sLJS0woshfGaGMJswxWYE/mfDVyjbpATAhwVvjmz4kmncHBXr0J5vRZHYMpw?=
 =?us-ascii?Q?WHTEqbVoftalhM0HD+Yn13Tsouz7jbC74BRM75Y0yvy6EYspFOQlf7KT4MyT?=
 =?us-ascii?Q?QI+pMYkHkj7qqmHmENNe3rRMZoricl19RvNuoX+i7sMa9H36Mnx3lIkSmSVL?=
 =?us-ascii?Q?typxSlyT396Wr852XjPhCUCbQuZdsXCrDafitaXbUz3sWrN/ADEG1jIHN0SK?=
 =?us-ascii?Q?5KjxY7LLpvWUu4cshq/wwxKyiaTWsRAY41FXT0B3LIgnqQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEYPR06MB6398.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(52116005)(1800799015)(366007)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0Kyd6oAPwJWhoCMDEK7ZCaMPGGLkp27XGJk0JjEOpFV7TvFxqiz19Joh/YhX?=
 =?us-ascii?Q?wv+g0FezBmrDw9TRWIDpe6TMhGftHPSjIxgEz32zT7XK9K1AUdYW+S/OTTG8?=
 =?us-ascii?Q?Hs3MaG8FAG/nU/d08YQmS0sqKA0S1/HSY9cn8AS9cTta5yDORzNNCXgyGsxx?=
 =?us-ascii?Q?Kixey+VDsGmtL/HO77Rl9koQMDc44Grf0KF1rONHot+wpk3Mx3bYjw4MGltU?=
 =?us-ascii?Q?xRAmKPDEXVM+ZaIzlR0eJLADn0p/V37Xd26wyNOqm/RvCv3i1ZBuvBREzp4F?=
 =?us-ascii?Q?qRjWs+rUTxPqqdAymN176E6H89auDEdS/pwdqSjf0BEXrfVbKt04uiNZyFHk?=
 =?us-ascii?Q?17nLE/M70jpBoaAP+UCuaL+69qWVOEge0GChK1v68k+csS6p5q3n7wzJsQRh?=
 =?us-ascii?Q?2cMU8bHJEqzv3Za73PA3HueqzV/oEEkobkie7sbEx/Cj2b1GheM1cIGrQmDz?=
 =?us-ascii?Q?GsTAksQ1m2U9kCAojKW9csGDNFEpdZKUIQ0pZO1pLZaclaCvl+z6j6dJkIXS?=
 =?us-ascii?Q?FhFPkQ4MGjvhLWJvN4Ezt4Gwkp/Xo39Db0k1Cz0JMHD2YOqhEi/N+FIRI4Y0?=
 =?us-ascii?Q?PVygfb+0SyCOAYpA3c9+TABwAwGO9MZHPG3ZLvuwu/XDdNZC2Bpk3EZm7oUo?=
 =?us-ascii?Q?NCfSXQBpa1HydZPi8pvQlbtipNSL3gKqKiXUFbT795Eu0I6Co40ftuVP+nGT?=
 =?us-ascii?Q?mF4ps1x6kGfanpkEpMyQuT2jCa7mYhoU5va09tFSv+qNtn5q9eGRTVyjDHwT?=
 =?us-ascii?Q?QXiyl5Rxleq90ke14+U9QDypQtVskgEUgephaXMvdQHy4aDT34RSEHLHQ7Uz?=
 =?us-ascii?Q?Vddc530Om5PNxD3jlCPrNXruHyivwIaSafSJIUk1esllZAsaVxZumYh+/g3E?=
 =?us-ascii?Q?+AvADoRR5YNxWjFDmXdbEn/NJwvmHr9UJhLuwIGsYLb48G0/XwapHIIkyojv?=
 =?us-ascii?Q?XjnDPz/PG1oGTzTfQxvra1LiNoQgDGWnfafFHyulXDjmKK5TFB2BIP8jQloP?=
 =?us-ascii?Q?yQT/zVmQTv3/njX70l+RhcKMUkc4rUv25ImP8ruS38H+p4TPBWjxpoB/oOTo?=
 =?us-ascii?Q?UuL7ZIXNsTdVeOBAL68JuMZnoKYV04+WYpGhqQmQnOZ29Qp86Szy60GAhLDG?=
 =?us-ascii?Q?Ahb93b8G8bog0eRFknZ7I5ZwxCsCZM1zChG1Lwlpaj9mkmNkGJDmMB8gUS5m?=
 =?us-ascii?Q?xLJYjM+3YcSSgfslcWnCBv8TdUqEuASeZPRPJMNT6BeWnMcwDER9F2gzOU8F?=
 =?us-ascii?Q?ItXq+8b3J1ttd6pH56mCJxfMHpHQm/f30Yv55CV10IJtt5xI6vGe5YTS7K5O?=
 =?us-ascii?Q?jCw63W1sVRq5fH4+YMXopH8mRnXwFsiuotaRWPZfPtksW35nVrW+qexXS0iM?=
 =?us-ascii?Q?U8lqGTbbjRrJT/CH15cu6kIODcvj7aPCasFffFuZ8g9G39s4FzpDb3yQJ08O?=
 =?us-ascii?Q?lUxDvc1Gy/voTUAjPB5inNmXkYsiwdahgyT17tvT2UtvZFTqSvQQtPPPtZny?=
 =?us-ascii?Q?KoFgq9JcroecJhQ6WUA5u6lFfc/KCPwf8ROgBSCykZKsE+12ERfbR6D3Mu9E?=
 =?us-ascii?Q?VAvbgt6fadfE4YAx5rhXxo5/QQF5quBQQah66UBh?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ddbe501-f402-4523-fd93-08dc73f50bd9
X-MS-Exchange-CrossTenant-AuthSource: SEYPR06MB6398.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2024 09:05:48.4485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p1PnDxemO6cYZHZgitbqFghnwBTbiUYj8bi3t1o4Oyv68Dyv/fHIUQz1lNyKDZl1r/cnP1Clwis5E8lTte2MZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB6102

introduce a per-target bit "flush_pass_around" and means that the
target supports flush optimization.
set a per-table "flush_pass_around" bit if all the targets in the
table have "flush_pass_around" set.

Signed-off-by: Yang Yang <yang.yang@vivo.com>
---
 drivers/md/dm-core.h          | 3 +++
 drivers/md/dm-ioctl.c         | 4 ++++
 drivers/md/dm-table.c         | 3 +++
 include/linux/device-mapper.h | 5 +++++
 4 files changed, 15 insertions(+)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index e6757a30dcca..b273f25b634d 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -208,6 +208,9 @@ struct dm_table {
 	bool singleton:1;
 	unsigned integrity_added:1;
 
+	/* set if all the targets in the table have "flush_pass_around" set */
+	bool flush_pass_around:1;
+
 	/*
 	 * Indicates the rw permissions for the new logical device.  This
 	 * should be a combination of BLK_OPEN_READ and BLK_OPEN_WRITE.
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index c2c07bfa6471..bb178df2a340 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1445,6 +1445,8 @@ static int populate_table(struct dm_table *table,
 		return -EINVAL;
 	}
 
+	table->flush_pass_around = 1;
+
 	for (i = 0; i < param->target_count; i++) {
 		const char *nul_terminator;
 
@@ -2279,6 +2281,8 @@ int __init dm_early_create(struct dm_ioctl *dmi,
 	if (r)
 		goto err_hash_remove;
 
+	t->flush_pass_around = 1;
+
 	/* add targets */
 	for (i = 0; i < dmi->target_count; i++) {
 		r = dm_table_add_target(t, spec_array[i]->target_type,
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 41f1d731ae5a..bd68af10afed 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -738,6 +738,9 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 	if (ti->limit_swap_bios && !static_key_enabled(&swap_bios_enabled.key))
 		static_branch_enable(&swap_bios_enabled);
 
+	if (ti->flush_pass_around == 0)
+		t->flush_pass_around = 0;
+
 	return 0;
 
  bad:
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 82b2195efaca..0893ff8c01b6 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -397,6 +397,11 @@ struct dm_target {
 	 * bio_set_dev(). NOTE: ideally a target should _not_ need this.
 	 */
 	bool needs_bio_set_dev:1;
+
+	/*
+	 * Set if the target supports flush optimization
+	 */
+	bool flush_pass_around:1;
 };
 
 void *dm_per_bio_data(struct bio *bio, size_t data_size);
-- 
2.34.1

