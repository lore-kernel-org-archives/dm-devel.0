Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2048.outbound.protection.outlook.com [40.107.117.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61BD1311B1
	for <dm-devel@lists.linux.dev>; Thu, 16 May 2024 08:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715846654; cv=fail; b=WGWy5y27ZwG3PsHZgY3gjlzpexEhaqLfOinz+qSYa7QaBWY0VkwzvttAsLyq5r4/s3U0leqdlZ11HvyjbJGd9hOAemJt/gYr9qqi72qGB5/pgA1l9K5Aa9+u9w4SpP52hQ5+zRwJlrs/lHEgti+gcQHkzRkw6r6q+orQNlgfGIM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715846654; c=relaxed/simple;
	bh=geiOUcwvOQEWvSWzvmzuzbbdH8s7gm3NIqsdxOCEO4U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Gfgr6/BfYxsmL9U9gK6nOJrlZ8bLc3b2wu9Q3RJGeCUe5FviPOnUiu7/or+fpwq+GTlmUtPhXBh0fj4eC2G8zHPHx9W1Ly9kWjrj1PjqMhfzXiAiApxMa0DEgwI3VOVIci9Vqt9YlFrkrDJrGfdDXDTlpBWzkJt+jQ61Hcx1nWM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=QoB/nVXB; arc=fail smtp.client-ip=40.107.117.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="QoB/nVXB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e9jAV9fKkfPvEznJn6kWn141AdDam40qObz94FYiQO3RR4rp05gbDHnfBFsVN8DjCFqwxbH6M6ydD8B4hImp4F3i56hO1Er4GX/ejpdMt6VSecl9SYnebCae1Qci8mJk5zuQ7+tnD94lfD5Eh+7hXUuQPKCAZe5a9RUTPktor4aQtWLZB9f19g/7WG0vcWh35ld9mIjviBDWn0O6zvttRcL/0vx7DTYNkXgniI5b9cNYp0KaUcJgATXYgfTuPYzWH95/LCwGkCxLAMuD6BhpQvb+g2Jr2BRXRS03ojjhffT0yVaWj2EJZ55IXb/WD1GEawT0huItbLZ5ybiRaogW6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lzCRbOJSPZPENWNCT94N4Qep991CBkBUtd0EM6pObP8=;
 b=Pyy2zyEaVGNu8Kl+Ke9wUVLo099Z/INu3UCrtjg+/m2U9wDaVHPJCdHm42YGjT5BfzrlLDUoNrOELFNMOuddQaKFHIIYhe1t5+pQ99Nfe57KsQw0voZuWo0kFSWd66LrhotUSuW50WsUrJmWXQ82bzCnoc4rZcaypmE/aCS0rHKSgacwoC5Aczatu/UbneOnuqsbNt/78Fzo4mzMBLKe9rypjlZkxL0jHl+qaVeimBuangHioOwY/0Pn0y+8ZDcqO3NzFliYk2AQln7R4IhjKB9hjlvdn83qtPD2UT8fO+lQLB2fZZjv8wRRH2hiAETsUQ9xFs13JvBujvMWTUIV6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lzCRbOJSPZPENWNCT94N4Qep991CBkBUtd0EM6pObP8=;
 b=QoB/nVXBQMa7lutNNyoUPZB/88hDQPho5NXEZxNZMWUbOUiFHHX67dIMygtUraVnsyS9Xl/IpsV0V/dKtWHE2jYAGyQ/9/GElfuRaMYnQmgb5ZrScqE8uBhy038qSG56zKpBm0B5Bu84UDrnj/fjUnjkqSan11LwOOK5dQ6Vp9v9bFcFdAJCEY5aZNCpKBqypvuVMz9QZkB9dfLPBxrZNkAtatG6rG2KRyerGQ+jwJOesjPFfvyzxWTwPeYVjk2WKpdNnmyqVETleilsh9JGxyTe650c6AAeRemITvsYnQsAY1LGnJZLW8icojsmwvVq/j4JRuKQIuwpQL+NaM22xg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com (2603:1096:400:42a::11)
 by SEYPR06MB6830.apcprd06.prod.outlook.com (2603:1096:101:1b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Thu, 16 May
 2024 08:04:11 +0000
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee]) by TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee%3]) with mapi id 15.20.7587.025; Thu, 16 May 2024
 08:04:11 +0000
From: Yang Yang <yang.yang@vivo.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Yang Yang <yang.yang@vivo.com>
Subject: [PATCH v4 3/5] dm: support retrieving struct dm_target from struct dm_dev
Date: Thu, 16 May 2024 16:03:16 +0800
Message-Id: <20240516080318.120231-4-yang.yang@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: ae48b68c-8f66-4cee-4884-08dc757ec4e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|52116005|1800799015|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HzsAvWL2b8dg+ryAm5PvRzLbZsLRoKsR857oy6OonW9wvZT1FRX/WABH8rQ0?=
 =?us-ascii?Q?4Tj03TLr5NbT8cOTfJv715j3Za3J58DFLabGtgZ3fXy1EwBDE1IjWVfOpaWc?=
 =?us-ascii?Q?v98lTh+g7OK6Ps+9EwOpB60zd/husDROpz1N4MUiAUfG5pyLA0jWeeWhksN/?=
 =?us-ascii?Q?cLIvbimOhJIrXzNMHzFZU26a7z5heFneBt2s1FUW4Io1Crf+tE65WCPbQUvC?=
 =?us-ascii?Q?1agyVBG7+RHVxnj5GO2hoc7+U/Q86FIoDLoOD0k2u+E5kwFbFkcrPMHQU9H1?=
 =?us-ascii?Q?mc1+pXjhn0JsDQl+mP8ctcVUT2X5rB/Gtg+1MS/PFpN+1yXA2MmX80wxOb1O?=
 =?us-ascii?Q?uUEEB0CSoQiN5UR7sLrfmk4LJdmDakX0m5YAXJ87aFSas4i74WJZJtJ/dYhN?=
 =?us-ascii?Q?U8GlYqVGBvcPoOkk8Q+nnw3UdY3MjwZbkTkrJl+8SPTbKoTiNHhPUO4EmBaF?=
 =?us-ascii?Q?71b97ZlK/MOnwZw3C9lXATfiddDYOF94pMr20PkYsf+xlAzzI6tSgF7SZY6b?=
 =?us-ascii?Q?8jQND1uihIpuev/afYCMeuvxvB0+AIyBs6mT9ReehtIqoqQzH5uduRlxywx5?=
 =?us-ascii?Q?Qy8Oab76pPjwin7D0rRiUlO6sPOK7eYYBAisvZcQ2iozKxDsCjMTpTatqZ0U?=
 =?us-ascii?Q?G+7ioWMzyFN91k8g2Cn5l0s0nTFlhiiTI0c22C+5sVcbGiiyxBoi7FnrcVJ0?=
 =?us-ascii?Q?53djg5HGFpmmsikSecvJ8CGb0BjPjfP5sedqprkRJZA1ZAjE5OWmeVrzmj5F?=
 =?us-ascii?Q?CuPQgOG3s2JS3HveKRsvQgBwg1lluG93nE5u//fIWM5wm8yyFbx/jHY01ST5?=
 =?us-ascii?Q?//F/l/iZsaGG1oKWuB8STwFJRKFixXVILJwfl3ikZcijmwBvcUrROk75a/SN?=
 =?us-ascii?Q?DglFvZEwMSzqFXHbbCG3B9uN9rppTLEkmyZ7sXgMXh/d4vUU45MYo/kHMGCS?=
 =?us-ascii?Q?92uOUIsCIqoPWiBIi2Xyfbg0d9OgLA6XcUbdVbwAJFVeVEbr4RPx4C6+c/10?=
 =?us-ascii?Q?qzo2heou91646aYokFcySefH+SUuw0zm4bPGKZwP4Anu915C18xjVhwjf0oY?=
 =?us-ascii?Q?4NiedNMq2F5mh++QYl17cP6cfrKvtvW6PmiUM9Nzy9TdERvirU1ovc5Ua5zJ?=
 =?us-ascii?Q?Hxj4QVoisvV2TaPUIFb73Ld/GdWr0UsoIW/HA9PZeckzaMzaprkxPd95KYlV?=
 =?us-ascii?Q?AoMzK/ChW+fZfz4luucr75UC7DzshHLXf+4OjgFmsMwC4bwIyS4HCryLEKJ2?=
 =?us-ascii?Q?EqiTvQXnD/wdSucdYatrvt0kZyfpyXomxUUKNvmgLmgRx7A/mIO9hgK3cLA/?=
 =?us-ascii?Q?/p1CcGr3josVscYM8yBxGk+k88YOg3eYG+PFaW1vbiGs1Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6411.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(52116005)(1800799015)(366007)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JI5hQhYJLt4jrmoUV7fplwiGtTRC+vBBsxBKrUA9AhKAcQVMCh1eSX+IC7U6?=
 =?us-ascii?Q?b/LQTxGb+Qk9SDopGVnDzMYEcFIcM4o8K0JwI+gN3oXircBzheED4eIR+Ixu?=
 =?us-ascii?Q?HGB7YzXHFwB4K6q/VSqDs6LDYh46Ogv/PkTlQGMyOz+Sw450WiENzRsKc7av?=
 =?us-ascii?Q?qq8BeqOOeuxlvGUdQqYtWAdER/QQxKMiIdcdJPoiGHyeyYvlK/RrONu4ZHPj?=
 =?us-ascii?Q?EMfOKwTeteyhtK8S3xGmuV3w+GwzeoD74yne/5P90M/AiFEYjP3BgcDbPxLv?=
 =?us-ascii?Q?UyiUmf1VE2IdbnznkZcFctSF1i5RZfHNKukT3AKVfqFvYovy4fAI1GrfpIyX?=
 =?us-ascii?Q?2gTrfeqwnLSUGY4gN+/++qGgKa0ICXG/U24Yu7yuHOq4d/76SpecqBkB17qD?=
 =?us-ascii?Q?bsWC0vPCFuscbQFN8YgHWoBFP01qkcRgMlDnmphnKDKMYyS1CivFzEmt+Ncj?=
 =?us-ascii?Q?smtpoIcTsfpkR1Z6NYCuP8c0qFveIQ/xXv34OME7qz7Hd7Nh3FmnVbPj7YMi?=
 =?us-ascii?Q?Jfk4MeJSyqzVsnBRZQNPq18fB8EMCHgAJ58uDhXsMHQHvDGfQiUAZxh07eeV?=
 =?us-ascii?Q?qCtGfHJa9KToJCMfVNO9pqgW5weowONH0HAnLqdGRpCMefZA+B63V1aFhgJ3?=
 =?us-ascii?Q?QrdjTsvmF8pj6MVdMcLkhpZnxCdN0jklOIG7TSMUmd5XsQwm9AVKCXE3r4/d?=
 =?us-ascii?Q?VDOpYq5a+in1Wz408skFMZpHIUY2z43DRAMgTdlW2Cod+VDSQgxR3xG0XLGB?=
 =?us-ascii?Q?u2Nie9JhhsllMQF4Ldxc0CrvuKr99MYiaimz8iW6JXkXPWKGltWfY8aswPox?=
 =?us-ascii?Q?yKv8egPb4HFh5rhcpMAXijfhNmxmGqESvRE8ASv1yFDSWkS1YGNSDC2UFGfw?=
 =?us-ascii?Q?kAjObQGiz89MsJQ+YSOM40pLaHZndzXo+8lZmYKBrsrQ3dp/BpllnKGwu6YG?=
 =?us-ascii?Q?tCE26mcBev5/9mFVaqb3c/YHDGUgsVGOB7S2IvZ1kbslc+hwROHGJuu1Phhh?=
 =?us-ascii?Q?NITum0n8F1hjsgajgH0M56b1QPkMgYHt/qP1B8MLzMCxPEvWfZ8aV+WO7tPR?=
 =?us-ascii?Q?WFkQDkP1GhC3L3Lq6uDt+yuJ354d8/IvWPoAlT878oqJUeNbvyOti9rINd5/?=
 =?us-ascii?Q?jKrIpzr6ssC281nh6sea8223iSznC+SIptKzwGcGczoxqGlWavNsD2bENepO?=
 =?us-ascii?Q?Cy3lz9DmI+uqyB0GmKLctnXqhrmNUYRMD8SR34Jrbq0ItzbXDEn+lmFAObMX?=
 =?us-ascii?Q?p0BvvAtx86ctz4+njrOBfEo9cE7RVCVV7t2dnUVVZT8CaI1dmKq5gpC9taXR?=
 =?us-ascii?Q?GqvpmrcGtzsXXwuj4LAk6GC/7pTgWo0GEXAc21Tq9KatWePbnSshgol1+erC?=
 =?us-ascii?Q?6RUEWWe8OZo2EB9SyEyVPyzQ1JWR3KDPb0CLhBZzfczHWJkx5xDIUeWLVpc9?=
 =?us-ascii?Q?4q/pm1rXxd8OIyKsHrjuuBsFc2rgQb1wDd02QCVjsqgiBXjbiw+6DU6UxMVP?=
 =?us-ascii?Q?Ig/J8pJswisFFwxiJ/54k1QyYfjNBkrFHdrJwGktWr/jKqwRxj2XWQsVi77Y?=
 =?us-ascii?Q?kkX7SwscvyCG0a7HbgXqvimz1YzcMwIQYyqv+AYv?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae48b68c-8f66-4cee-4884-08dc757ec4e4
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6411.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 08:04:11.1097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Kzg/4vYoqKQFIbY6x1kmUbPaOCegpT1tms0a74dDcIbZqcNMUm+SD5lmCWJjWkHFVBc8mirv099uWy9yDVDog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB6830

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
index 0893ff8c01b6..c6696f88bf66 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -169,6 +169,7 @@ struct dm_dev {
 	struct dax_device *dax_dev;
 	blk_mode_t mode;
 	char name[16];
+	struct dm_target *ti;
 };
 
 /*
-- 
2.34.1

