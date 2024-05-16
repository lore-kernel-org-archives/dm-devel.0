Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2048.outbound.protection.outlook.com [40.107.117.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EA86DCE3
	for <dm-devel@lists.linux.dev>; Thu, 16 May 2024 08:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715846650; cv=fail; b=gaX2XlSAkBQVecyA/osp+CkdimiBO2j1bd0bJNHvfKXQYsXCAp6lwO9Jn+pnsLuoSEVLDbryW7VciLWmovjc7xnJkB5Qvt50S/pDjImk9dRFKYFi5zw2KHpBQI17sxMQ2KJQJl8u84HLSEG35wXApXAGBHtImZP9wag8tq6mSGM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715846650; c=relaxed/simple;
	bh=d+6J0DopE8a1tqTqwm3DC/qdhoRyEx3y9opRon/FBkE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aa7C5Fl1AASGwU/6nyyYGhhLtezEW1Y9irYDAPhrH7vMyvIGenFWO6yVkbLUnUgiepc4U2G/h/bviF4jmcD0/Uw/YF9mBXJr0+MiUD/eM8NMZl4xMjjpaecCMThmAPSOOLTFif9DG8nl644Em5PPquWMLdKKnjfDTXSEwy3eb/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=qdwBnQeQ; arc=fail smtp.client-ip=40.107.117.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="qdwBnQeQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZvdIORSGMKm/2JGQxGc9dE8JmsN2WOIRj3RO6HEbHVgFPoTJfjOIPgJjsXAf9V2gfSchF4q7fjLS6oLK8vbkJGuA7YuPV7i86KNeflLKiqKyl1k5x7ifrVYVBt+oM4NDig903Y2fkhtO0DQWmU2G/eIroWCmNIF06Y2UbugIXv8tViapwnQjtRqmTsz3ALUalyIC4sS8YWKS417EmzlETbtUyDPd4wAAqN0jotuBBk3FCUe4bheCCDgej/bn/yT5+erSSpjg8nFyp9EMh0eJBQFEHQ93y6839nWV2yhMw0dZCZ5HiO72INTSqlNX5xOp/8Yirek4HwtYdjgEzuGFcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Ly6WgXtiz0dA/xzmP8OTqpgBcoRWGdPsXGNgS1wPGE=;
 b=X1EwJxnQs1bdXaYD1akNySvRwkh10JIe0gTkF83g2PMoTt8+EtnytWaqjTd8XZOuHnMfpj1ATrNBfHEJQFGiyRnB6hKhUVWNuhxOiqlac1qDpS983zHMZUvqOR2Se9pqfDwAx1KYvs+G/0bbtdlPQvMNfoDvTKeX5dHWKNVZxcflygkhQxDYW9fjCoWmDntTJ13gqet8v2WAn4B03Z9ZTPZ7EMdJBv94fbQISZWz7baU+Y4yExLakfwLoFN0oXzUgWbqbw83Ho7DhFvP68sq7VGtL6YLPzgQ0mBT9V64iOAnwIm/fFe9fszo50QEJxU7NkgqbtF690KkxHdylowNlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Ly6WgXtiz0dA/xzmP8OTqpgBcoRWGdPsXGNgS1wPGE=;
 b=qdwBnQeQc23rfLvLJm88kdBZAUuuGf3w0vYB9S8B324zs+XjYfdcqLJYk88AH9EfvkwMXXwNkXm/vTNk5EJvUs+KsEFLLmfJqHhMTfCBtmEvVsrCQCtNFUnK+iZQYqidXdDz2k7yCYjiVk5F/2XuBt/y8kFJOevRQFnM9TY32FvM6wmo/cO21dX6Ah4jjNJvINkciPaCv8SLO2VbwewWt4l4ZayEjEJV+iapkJZ7h1JjpKIJBuWahUudfam43NSkfYK2EeU35Yk5rvyn84y4Kx0hW9FuzdeUDswbfUHu8e2JjMonSnqqvC+I90+XjdBFFxtK6/KSPf30HcRnJSiZmQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com (2603:1096:400:42a::11)
 by SEYPR06MB6830.apcprd06.prod.outlook.com (2603:1096:101:1b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Thu, 16 May
 2024 08:04:06 +0000
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee]) by TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee%3]) with mapi id 15.20.7587.025; Thu, 16 May 2024
 08:04:05 +0000
From: Yang Yang <yang.yang@vivo.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Yang Yang <yang.yang@vivo.com>
Subject: [PATCH v4 1/5] dm: introduce flush_pass_around flag
Date: Thu, 16 May 2024 16:03:14 +0800
Message-Id: <20240516080318.120231-2-yang.yang@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9ff2380c-6319-4787-ebc2-08dc757ec1cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|52116005|1800799015|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Lk3WypqYDWHAEAXbTlLP9ukn8FZ/jMTX8aV30psr29JniM4MSuwkENsylIbZ?=
 =?us-ascii?Q?7kKCWykutwplk6VzubHk+ioyUfNzaOYKkfPvIEkqrdZ+YN/fXdUEOy2jbUgy?=
 =?us-ascii?Q?BxFaVioFgyESaSyYORhNUV6gxXs6UL1xvBJbJuF9JM4Mdo8Kd7xlYX3AoiEq?=
 =?us-ascii?Q?1vEf2rM/PScoxtp5T5jonVQldAARhTEVqpwA3o2+Iy7yMqvi1lUhRaTIqp58?=
 =?us-ascii?Q?h/VUgbc93ACUvUox74NiBTO3+EZnVHzu24So/RX+zbsbKIWUYS3EXyii+Iky?=
 =?us-ascii?Q?oR4GJtF5H5u8BybBJawx4Bj8ITa2hiw+zviIu2Po8t6SvotXbMPb5yz4XN0t?=
 =?us-ascii?Q?amE6u6JNbPlLdRcYry3j0cPo4yDNCSVdM0hvuucSwwAWJFZh8+4leXUVpLUB?=
 =?us-ascii?Q?x4ZZWtgCZdtqMBXoM9/aZqmHzdIf9g6Dc7IMt4phgvWO0Xf0SqT4ArOsPFcI?=
 =?us-ascii?Q?OBw8almIxsDCNjHVXkEtx1sP+riE4d/TnbV/rtcxVi+TWXTr1Cje0YTRKW5s?=
 =?us-ascii?Q?sbD8xKpWoj1yyZxUyzYXSjkdhVDKdfzuXvDCUBxGMIU9O+LMIMHcCAZxvssG?=
 =?us-ascii?Q?fDFehkdZ5BW7QMqMIWYxjZkLT9NZg2gx2+o61C9c1XGtbTBLQxcA+kZ67v2E?=
 =?us-ascii?Q?S4Yyfc+77K9JjadygDCn4AY8L2IMqou/CRGuVAVgUeAHkp4H+Mcfd65gc9Bv?=
 =?us-ascii?Q?9xsFGWjGdoP3Ih6F5V0U+KdkOfqhQ68dIwHlusrpjznnmNeTQvB7qbYZ5S+o?=
 =?us-ascii?Q?TndFGVKqrpRhJSo47C+kSv7HiuN9ONP9kBanJvwmnqUipFOumt9prw9TROeC?=
 =?us-ascii?Q?RneCLREPlDeEEQX2d3b76cW/KDZchwVaiazJpls8dENL40LsgoEkbO+pDhdp?=
 =?us-ascii?Q?+x2tB5k7lL1ZgTZRkDTrMbaX8FNZovV2qkuLgZXiVBT+Rs9G+Cf5ajn777rf?=
 =?us-ascii?Q?aH1OWx8hy/evGhKwmtLW77dtCcv/VJC6ine6VKNjq3qHJ55SfkZxA7W54C4j?=
 =?us-ascii?Q?CDrRkX7lQ6sxLV9imTZtwSCQrH2oPNsPrWXqLDmWl+YQlvMp+iT3yWyNJ0/b?=
 =?us-ascii?Q?Zg5+WPYSRzoPKhYNX58CZRWg0uTnG4c5HJ6SpQlQcn9Le8MtDlav8Wzrs6BD?=
 =?us-ascii?Q?+lg5MFRDGYUeIxy53oyAWnXAgL6rvMc5CdKMGX8vuKOJrNN/qP5+JZXiCdCp?=
 =?us-ascii?Q?9kIThqDUeaTRA98GaJhwzA/gA8nR0z35LTyLB0d3yvdFYocSDlLyxmwadkMU?=
 =?us-ascii?Q?17WeWooFIyhhExnpwyW4pBr9anWKJOW7qevlCF/7W/QNd4xjd2YBKKlbbE5F?=
 =?us-ascii?Q?hLPLs1QGP9ifGBrxKqsR1inxq18ZvjLf5y6ZVZ0+V182Ww=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6411.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(52116005)(1800799015)(366007)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NKYRJyYBCHVSJvAM85MDrdRKGSn8BV1JMeJQzRUKuLrs2s21+ixD7naNenkM?=
 =?us-ascii?Q?eqgQjeAFyDjeWCDHQCbM+dN85y68jaL5mftJyrGqvcZbwSNl6tfhWZJDO9CA?=
 =?us-ascii?Q?yrpszIY38NPEGAEfPdHNGJly5DvYY35C0d0nMCRYg3dIl8niYWXX4EMJ0nLE?=
 =?us-ascii?Q?8LrPN3cmoPes0U3kzqh58ULQtjvlHkYn0RMzJK25mMWyZ7PiFnVyGRIYutYe?=
 =?us-ascii?Q?zFEIyJEg5W7B0Uf//+KbL9YvbOBWmHTzXjyIAbPBFEaudAA8fzQ+lAWN/Ly8?=
 =?us-ascii?Q?zZR2FFQSrpWaHz7AYMsCNpM37iumERL9GuZhtJKtE6pSM1SgrTo/i0pDpq0M?=
 =?us-ascii?Q?yFCXSyCUcVtZ+eUZpjW1FnbNUn0Jh86kQjXPluS2OorkDAX2XBiHm5+0OSLk?=
 =?us-ascii?Q?lO6ClYnR4iNMegb8Ll2n0tdCTq2irrvb0mPCNxs1F2qi2ZG3Q1uJwqxmN/Ge?=
 =?us-ascii?Q?MtG9gCWN1HzfIb+M7KwAvCAS2oaZV34o7Aj+r9IxbMDtJo5vs7OxtjEHa/Wp?=
 =?us-ascii?Q?FUnkH7ByWo+3xxSe2OfS/KgXnOpVaxPVXWIeRVp0cYoBAzumVDXHeBFBOvsd?=
 =?us-ascii?Q?REJ0UN5vmRnKlbY8/sxStXq2ZqKiJ0bt/Tn7HdLrhFI1m/KQhKGzAMgQ+InI?=
 =?us-ascii?Q?DXASmGKF/CPYM6FB/kYvlKTHjK/bAG9K7Fcco/TBZXiM3lnb7Kb3I8t5P2iD?=
 =?us-ascii?Q?nIe73VfCBA8a2m1D6PYvnuIvu6FBF7VuNJGcMqBMrL5RHiqWuu+ZAHPMvc4v?=
 =?us-ascii?Q?lusv8lyBB7wndFwKSjY4J1TEYWm3tdMMe5um16IqHyZVQamAWU9Vey7s3wbg?=
 =?us-ascii?Q?+YlOVFD5uVBnP/v/Dg+GSbnGlwyxdLiYHmuV9u80mq2AQ8vBMz9UIExHNJYT?=
 =?us-ascii?Q?sUeHW5M5AwxFvY/1xiTEeWM+R/vqeyospaFHjSW3XTj9zQ4sluCj/POwvIfg?=
 =?us-ascii?Q?kk9aes4UOfWGL4pdeL7DxXzKum7nM0KDXyh4diPnfd4VJKxdh+p25wxVbaXC?=
 =?us-ascii?Q?l7g5IB73dGDv2V5iSmXPb2nf7E38Pru5P7CfxOntJ1ROHuo+P62ZjL2GW4Sw?=
 =?us-ascii?Q?Esa81pXzrCT7OSy2Fdh1AnFksYglqnNc/89q0+PdeOeowtgxykzrq9pmaAKw?=
 =?us-ascii?Q?ehIcSNsuYlzHqRqsr/tb9/KNrDpQrtdI5zB4nENTXotJJ859vt2WIYvHWyz8?=
 =?us-ascii?Q?3LSL92SFZmObfFD1jFTu92JdhwLOuY0gxGzpxnRMNwqUrLAo7B+gYnz7IRlr?=
 =?us-ascii?Q?6ZqlMO5oZE12OC5NgTZa1U130eP/Fsti8MlYzXmilFVlZ5SuWiiaSafOh+FT?=
 =?us-ascii?Q?S2s6EPQYuZQDPk6u8tYj3VuoGDakx/rf+oq2F9MlKhmQ/KxcztWmW+SUB+VL?=
 =?us-ascii?Q?fErgBKBrLl3M4Iv3smEbQCj2n3O0KWnwWMyUIVpS1dbd8fTdxEkrJCFIlLir?=
 =?us-ascii?Q?MMzEKUaxrBcU4wkLF3p9oo1wFlvXwLyvBRo99WW1+o64B1iw8QFE8uWOBQHX?=
 =?us-ascii?Q?upPKAMPybx5Gmo0xZigTis8h3Pr7ySl7KGi6u+x+W8jhYS4JeQHGtwyT0Iqy?=
 =?us-ascii?Q?9NrHrAwkItbjB1hxzihwuJ+CkAGGFK+8X0s3fSR7?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ff2380c-6319-4787-ebc2-08dc757ec1cf
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6411.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 08:04:05.9398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yayOpf+LkBvum35PH2m9v3mMdfqSGrbCj/549s66K7vix4QKt4faClkT1zrj8V+J4bPG8l2C1UZf+OkGcZp3RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB6830

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

