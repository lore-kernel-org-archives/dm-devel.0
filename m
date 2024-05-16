Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2070.outbound.protection.outlook.com [40.107.255.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F7317BA1
	for <dm-devel@lists.linux.dev>; Thu, 16 May 2024 04:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.255.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715832190; cv=fail; b=VbS5FtFK40j+5X6j1o/Vl5njMRBlQ9FCLmv0x8oG4LZeoy7pXfywMWaY1UY3opYsTaDx0r77iQiztJcyX31YCpPK7IUmzvTBKccfB4Sehom5usYvvV8IaXMEdaCcHlsvmwNRMg5DPXGdCMeT1duyn2JeIzcguT5ybEPeeJm2tYA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715832190; c=relaxed/simple;
	bh=UBfgroBIYbXqpoq3UbuWWpZnLNb0i848aCOeSGM3vk8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IBH0h4wOnZBiw68B7MydaosA/Ofeya+q0v9S0Bh6NJO9I6HDdnOvc1QtKfwCmFnQ0VOhZbQg8y2ReTrIuYZFck/Y4Qzhs5tJlvoEqqD+p3ik86TNRyspARj5o64HK76Pf/G1Nc6m/K0ZMRClh21APZWXj9F9G/DGZPEBxvHZwYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=LEAUrTbF; arc=fail smtp.client-ip=40.107.255.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="LEAUrTbF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l/I25n9sglNrj65u/MYAfAU2TsG/D3n6jRiI3TaNR9+PcYjx2Lm7yT+5mBIw9zc64gyYaAWgbh1BV9xfHNORz6m2IXpVFyKoNVzRjwe88rDqeXChNQ40WqeeN5SNSPxiFIRyYlWf9eD9dnAxq6pyRCPhe08JOzBvfx4vBZpW2X9DDSDRYZ+RnBcozXlCEHR+72vmOFh704KK2rHhehX6OG6BdJKdLa+6/U12++30wthwZod/YBxfcsgtADGa8bKx+BvK0U16DMTf/7lvV/cVxkdMHM32t7po8FkV6tOll8fEfUCMx745KOtjFHUwD5ETKMST6kD8vBw1hsc5QkkOdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bX5L80hBxxttj47k9eHP54X/F2oAa3/64jBPrCkfdG4=;
 b=UT3xVP2HgcOdH0SEThxZYlRMz1c64bcrqwfYrTEBe0UvK6hU84dRYRm1OI3gosWsbAF4oHj/W0N3e4b3ihyhrJJ5haVr4BbvvcgLz4IvffgqNMbYP7a3d8/qecpvPLuQe/RBbaz+YMAydCrHM1pAHrnYJ/jq/hlgiKVerRxT+fN94/ZhvIhP1RFk4+1mdusNYNCDOuJAvFZRBPTymcw7lEKgUqh7MBqlL+Jksq6KUqzS2thqA0dCTDJqsNV8JBl6lMqe3Oa1k87ww4m8y58qYY8x947YuuHh6kjypRbhm8q6yZ7TEw+K6Xwo5s94OE9vACi+07byJtC7KXUo+/pX4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bX5L80hBxxttj47k9eHP54X/F2oAa3/64jBPrCkfdG4=;
 b=LEAUrTbFbOlw41sFhBgyMNhLGM504vzFEVyUVS9TANuDfMKOMN9H0A7inv2uC7qUayYR8nIWicinhCkf77qW4lKuPxnIcwymQ+rai5PvHvEzpFj5xl/9AtKG2gTpMfX5Urlyy2RDKwibtAvpQVqAdseHSL+Mz9vYLBAXyXWEVFU3077vE50/Py7I/yRWy6F7FrFOQpJyDgkwvhUq+N8V9V0q1r191TVYKUZLEIQChRbiFKdFchYe4hP3qFoY4o4KJGJMBJVrYTPbwmYJSMUme+FblQ4owO8cG3TSfpgRcBe5klhGUeMfvDNb+DL5uzSQpzuthhiaRuAtmgEKt8v0lw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com (2603:1096:400:42a::11)
 by TYZPR06MB6807.apcprd06.prod.outlook.com (2603:1096:405:1c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Thu, 16 May
 2024 04:03:05 +0000
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee]) by TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee%3]) with mapi id 15.20.7587.025; Thu, 16 May 2024
 04:03:05 +0000
From: Yang Yang <yang.yang@vivo.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Yang Yang <yang.yang@vivo.com>
Subject: [PATCH v3 3/5] dm: support retrieving struct dm_target from struct dm_dev
Date: Thu, 16 May 2024 12:02:32 +0800
Message-Id: <20240516040235.115651-4-yang.yang@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240516040235.115651-1-yang.yang@vivo.com>
References: <20240516040235.115651-1-yang.yang@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0017.jpnprd01.prod.outlook.com
 (2603:1096:400:a9::22) To TYSPR06MB6411.apcprd06.prod.outlook.com
 (2603:1096:400:42a::11)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYSPR06MB6411:EE_|TYZPR06MB6807:EE_
X-MS-Office365-Filtering-Correlation-Id: 5182e7a3-5d32-4ca0-417f-08dc755d16ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|52116005|366007|376005|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oQOH1Xak63OTmggUHVHmofdcss2QSZgcsBjrucvYGHbxqqjpr3HJuMEnGAzG?=
 =?us-ascii?Q?avcnMkcMpWqyo1GVaFY1r3Fi16trWAJK+lk5nEBJx/8X3snexl1Tt8hQzIsg?=
 =?us-ascii?Q?tdO55hzYjpkCLlIWkxORp6QMXSR2YGZ2V5LzA+FPn6RUuz7XHKDWWaSHjPFA?=
 =?us-ascii?Q?7IOMLWNGOCofPn0Ix30jSU7eXyhyYpoQMFOCps/Cd2SsrR4AKUW5f9xvb1Ym?=
 =?us-ascii?Q?i5VfPdGQYaNLc4iowalUN42Z7mVVqyG8wjR5aej3JTCTgkE3WRMuYXXJC7Ds?=
 =?us-ascii?Q?kv2TE73uCqG9RTihKzeM2vC2Pjs/wZiC4voeyOVH4oOOG4Za+BdF4YshHuHk?=
 =?us-ascii?Q?ibZl3MKpGOwCyYbY6oBG4Gk4jLAuBeylvG7fJPjAVfAIclT1X4mQDWbTNCXO?=
 =?us-ascii?Q?Bz+G9YadcNk7PkhZam0uPPuNt9Q4tyMRFoOUu8HGi/5x02kD3Gm/ITzrJJI1?=
 =?us-ascii?Q?Ke5mwhVb0Q5AanKl9+LmsM2VLcmGPJBwM9tVmopv1E4MLCkegu9bP4fu122m?=
 =?us-ascii?Q?BKKnyTaeyYXZbTNow5xW3OGiuFAWAiTlbFTOC3W+7tCvZfoqVecN67KqCE/z?=
 =?us-ascii?Q?qUQNMrBRSlin8QK3Jtuo51HpJyYHmYCSDf6xFY07+xaqdCZi+jCJ/oVxf07n?=
 =?us-ascii?Q?z/LTIL+BOrQRaPp3Ywu07NAPb9PXBDxEivZJrgC3RKMr5GngXTW9oU/348c2?=
 =?us-ascii?Q?AusDycMiBdG/0QmHpI/ug2hLOnY69sVLdW9KMHft5DjTfWUbuwUDI87yPHDp?=
 =?us-ascii?Q?sarF5jm/fwYHaZDZSTwLS+N4ICEfmucqgHHM3tI+ucZ7eddSk/GTTpuUVSBt?=
 =?us-ascii?Q?0bGbNHcyOyHNQw4nBUE/fFZDRMxuRwoiazruO5sHj0L+YZZ+RBC4sAp3z2GH?=
 =?us-ascii?Q?UBWvkBVNX5LbXAVTGAeqjBQ2COR0oNNXuAiVLfHdjtYI99zZKmiKCAzk2ym2?=
 =?us-ascii?Q?yudCLkst8PaxmKnGhEmVbbKH7Wh29RHGSdlQStgT50tr2hRH1pN44cJExYTU?=
 =?us-ascii?Q?LeyZQhLYcKOz0ou1fUhFtbhWy3wpvNO9cj0jUROqNWRo+ZnrnN7HRULbOYiA?=
 =?us-ascii?Q?FYCXmSe7mC5yaZkkhsRZWngVEeTCXEBFza1e0ZAF3oyYj+dUMKXPnkTeGcJe?=
 =?us-ascii?Q?GtJz8iphg7xS1JBG96G1CJvmSGcGaLX2Cp+3qwSK8SorQ/kRQ0IuaOS9y0MJ?=
 =?us-ascii?Q?9FRLLbBAxFd0ikNdS+2VQB+hRFieiTehkMMIbuyI+bj1/FdIr4jNWXVFab+q?=
 =?us-ascii?Q?sv3iuuJaQSxXjG/6pHRnpInArGVBoWqtE487LoywbdzKC67KTYoqvz6fHYr9?=
 =?us-ascii?Q?foF5nBmzs2Rz1BubdCvbaM6iPUB3wnuj/i2pswtRrwkRCQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6411.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(52116005)(366007)(376005)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2PuFGS7N0BL5D867EZ71aI3ogNZjwssIepFJ+Zuha5EeozSijboZjrHZ9kY6?=
 =?us-ascii?Q?8du3Co8q2ThzYYRkB1zxXDWkV1Hs5il4ESpPKcKA2Ml6O6Wtv6c/MpgJYvTj?=
 =?us-ascii?Q?P6mn8pJQMhmeujIhENvPHNXyev5g1sN4YjimqPMZNv+yHu2my0VF9mHvKjM5?=
 =?us-ascii?Q?onHM45m6zJGfYc1AA0FO/Vu8uXbsc2n7RlVF1GVZLF+g5PjQkJBCypPFzCnM?=
 =?us-ascii?Q?O6p91YiYzAkGrJpgO3mUp925mKwm0U4q1qhIZRUeqQC22E4jYsjLBvgnTqCd?=
 =?us-ascii?Q?ox6/STdFz4/7Sw3hiaNWOQTFBkeASKLLNttt54e2pMhl8VcDCoolw1VPzbcv?=
 =?us-ascii?Q?3ZjcY6wqSyCiBzK9FZZWcqaVPVfiZ23WPX2nHUrqQJEvwlQ1xbwpoGUHvSv8?=
 =?us-ascii?Q?FYTm1tunosBnZKKCrplsJW/kqdhDxQ5B6uqpUV8q3GJLAHOQHJADH2+/1bFk?=
 =?us-ascii?Q?J/4rxE4WFphdZC6LY27wbGYtMrYz/LVk53JMeKn4gDaf3qZXgxNNPMYpWKM9?=
 =?us-ascii?Q?ddH8wX1Sq/7AEZGtSKPFsc+R9uwhM7p5EAD4+4GqFeg7IS0fKj0EFb/W9v6d?=
 =?us-ascii?Q?yu877DbAqIRdLGWTfjMZPu+ICZPy292w5TCdZtoBpY41uvAW5AWWgmhiGElO?=
 =?us-ascii?Q?eFU6xq5QoAN9eMvQSnMAKhYOaYelq0GW1GXeF4DIF7/32NhuKAQ/6WzuXY9N?=
 =?us-ascii?Q?I3zbSlH1ZerVYiIJAKxCB/EikxnvDuan7yfgaTB/Yo6sPPIsG3B5E5gAj/q6?=
 =?us-ascii?Q?ZBpuP7gVH3TCFQ8Dw1KlXPToSc4uqo4kAS/E5ZkhADYF7Um9cLWXqANldGBn?=
 =?us-ascii?Q?Czf1oGHAMp3dSaK0tmewQuznidwEMt7ll5GxNtG3WkguS7KJKMBvWrrEEGLR?=
 =?us-ascii?Q?dJR6+Ya5HM2GjSLMOc54FlTkQ8c00c8oLKySV0Kc5VIbD47+jcZwmdCa3fen?=
 =?us-ascii?Q?Emp7blfpQJkiwsHZEq9AHD+sQM6nAAkgPYGPYbYZE+4PR5/ZDUXmMbKeZyWw?=
 =?us-ascii?Q?2ZDpN0GbkjCj5m0UIKHQ5EZgcvAJGEtMS6uPO5L49xawY7k2glCauREvCjxp?=
 =?us-ascii?Q?JOn1xfsRLYU13jQr8KuUcLQrLHtQRkri5T5EcEa/ISjpLvgNOTKNeXxDenEc?=
 =?us-ascii?Q?DKI35t/3ZDUwpcQpRkxgemu5TkWce8shpNB0UHW8ggBxZhiW5/XpX2Zrx1GR?=
 =?us-ascii?Q?F3hhY9VbCjLQerl2pcIeZ/mK6je0ADZRWP8Fnbn6W3+k9Y87Mn1aw2tYAwQ1?=
 =?us-ascii?Q?M8W86Wxiv4T8aOiyWDgLPo2vTZWaskKekq2mJSVB1KfZtvaR29tuJEpor5sg?=
 =?us-ascii?Q?3GOZX3jfHbY8YAYa7IjLXKffGCU0J8F3xrnNV9C1NC1sXu5hX6m+E4Q4W3K/?=
 =?us-ascii?Q?4oZIh7fieygNn01OjbjCSOVTfOwJkVEjZfpvTrrypiWI4p3eZIUC9FEyRq6T?=
 =?us-ascii?Q?+MtPXUKb6+T/xTBmP5QyoPpUNAVa589XZYHgB58wpHHhuBbbp5ihESPoD0t6?=
 =?us-ascii?Q?WX9V56EqYEUCY5DJ9TrI8let3gLyo7wnrQqx4lTz7NifkTgaVUn7l5lqkA8H?=
 =?us-ascii?Q?X3n75uQKlQmHt/5zLtNDzp3iiSR/glN1AeG2E9z/?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5182e7a3-5d32-4ca0-417f-08dc755d16ad
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6411.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 04:03:05.4138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 70uck+oZMI0TQKsN45MBrJowK6jEjShS3pk4Ye5DeedHa0xKyeobuX2y7RzzLDFCgANe8IprMS5JiYuOmIQVLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6807

Add a list to the struct dm_dev structure to store the associated
targets.

Signed-off-by: Yang Yang <yang.yang@vivo.com>
---
 drivers/md/dm-table.c         | 16 ++++++++++++++++
 include/linux/device-mapper.h |  1 +
 2 files changed, 17 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index bd68af10afed..4817ddb660c4 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -2134,6 +2134,13 @@ void dm_table_postsuspend_targets(struct dm_table *t)
 	suspend_targets(t, POSTSUSPEND);
 }
 
+static int dm_link_dev_to_target(struct dm_target *ti, struct dm_dev *dev,
+		sector_t start, sector_t len, void *data)
+{
+	dev->ti = ti;
+	return 0;
+}
+
 int dm_table_resume_targets(struct dm_table *t)
 {
 	unsigned int i;
@@ -2162,6 +2169,15 @@ int dm_table_resume_targets(struct dm_table *t)
 			ti->type->resume(ti);
 	}
 
+	if (t->flush_pass_around) {
+		for (i = 0; i < t->num_targets; i++) {
+			struct dm_target *ti = dm_table_get_target(t, i);
+
+			if (ti->type->iterate_devices)
+				ti->type->iterate_devices(ti, dm_link_dev_to_target, NULL);
+		}
+	}
+
 	return 0;
 }
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 0893ff8c01b6..2696d1a8b542 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -169,6 +169,7 @@ struct dm_dev {
 	struct dax_device *dax_dev;
 	blk_mode_t mode;
 	char name[16];
+	struct dm_target *ti
 };
 
 /*
-- 
2.34.1

