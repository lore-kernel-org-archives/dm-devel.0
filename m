Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2070.outbound.protection.outlook.com [40.107.255.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CFD4C63
	for <dm-devel@lists.linux.dev>; Thu, 16 May 2024 04:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.255.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715832187; cv=fail; b=Ok1zp5ddqufFYMaup9oUDKIfhGk2d1R5ssoXqqInWosBwbNSCmZs1HZ9L3sLt8Fr3pzJP05zqmQDu0GyKfbQjBtP6SiZNzNL6ohL1Rorm0l5EpAPbVBtU9hbrdHFHze1cL9zOFue7Qu2RdzDfLjmyVejyt7Y7EF5dvl9N/JKjJA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715832187; c=relaxed/simple;
	bh=d+6J0DopE8a1tqTqwm3DC/qdhoRyEx3y9opRon/FBkE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZPUA32N5ByOm8lH2CD88DsFFfQ8ouJJvAvNxUgGxr/FBosEcs0cH4xwR+0cPa9S24P1AFys++TlxnnTM1fDbXvfGqWkTMfQU4A1Xv3LXRVtqL+3vxPYNQD3Ppvt8LQucd7FpkwDkcgg+bkbk/CVldeIqr8hxBRA39BrjgbBmoTw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=d5cl490q; arc=fail smtp.client-ip=40.107.255.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="d5cl490q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h7iCakEba/dqyv1d2TroV6PZmiuINWVf+D8N4KRv9EGX5somammvZI6fkWRmdXuVk2qlswOUBHUw4BmfYZ7gIJ7jCB4N5Ub9qGGV4fY9uoYWFOAkCdIY6jajZ53TbcnHYUwZaNEfg5BKiTb1GM7/RVcwzEeHmjrC1/0PvvRwHra+ygwLj62pPd533ZP6uFUjQIRcnS44fSH777Zi8BZqK26uL2KsOSV7L8Gc+Le/IUnIcAvyvboiaeOS62z2wIB57+uGobnq1L2o728zP5ZQ4JxqZjpFtqWMqDphWaXQgKMQFhyqMYqB5CeAmqikzmqLXAuaMvgKBOydPh/mZxmC+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Ly6WgXtiz0dA/xzmP8OTqpgBcoRWGdPsXGNgS1wPGE=;
 b=ako8OfN0/6idztOMu4ggTWxP4AJjjSSOEHWZAb0gelJB0/5A7gHZ0Iie+6fbrHG1jDLY4HOaiQ5fa1d2uA3KEmWyE9iVYG9ggT7UqQ+KN2zCVrS4AN9oBhs7Fr37xM7gRo6ZYwOGuYcacFxD7qyUBmlg3QBgiKx+AkyIhrrW35od1e/yUenHnn7t3GMWxoucr6ISemGXX/ZcpRZod4iaKxmuuJyNh5L6/hhnUhnkqg5v4RBEWqy4Biz9PoNxHG0tks28PRmbbGrubhjy5iyTFnqOuRANiRKWnS8ihdQ0R/T6GnGpEUovLnvA8zuUxs0OYSqWwn4AGnMf5ljDhcKCMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Ly6WgXtiz0dA/xzmP8OTqpgBcoRWGdPsXGNgS1wPGE=;
 b=d5cl490qJBFVZ7r8unUi7NlDnshmamU41SOqEgAN19sk5A17BmiBeXx8LpX/+6vwUpKSmgUelDH69yKTYpH2kwC3TBVLZI472neuKtyCn9oMv850GuoxoUs7EgI06gIkhl0JYlSrQDpGdkAh61ybfzuiGQNuGfyMX3/5Tl2v+6QtViiZ6bE+08oE+ANO2YX3nB5cT+1hHrPYSbcNrrrhDHNJD23peopr8HPH0R44NKeYTU3hkareArI7qmMOvgVD0gRs6Ocpv+3HIt2rA7IRR19pVbZLaqdk+NryZjBx9gbBxYYdDRauNUq07+NV4wcB2HYzyhFYevqvmtVi99k6Pw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com (2603:1096:400:42a::11)
 by TYZPR06MB6807.apcprd06.prod.outlook.com (2603:1096:405:1c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Thu, 16 May
 2024 04:03:01 +0000
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee]) by TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee%3]) with mapi id 15.20.7587.025; Thu, 16 May 2024
 04:03:00 +0000
From: Yang Yang <yang.yang@vivo.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Yang Yang <yang.yang@vivo.com>
Subject: [PATCH v3 1/5] dm: introduce flush_pass_around flag
Date: Thu, 16 May 2024 12:02:30 +0800
Message-Id: <20240516040235.115651-2-yang.yang@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9c44fe5d-207e-4491-786d-08dc755d136f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|52116005|366007|376005|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FdwwhYe5Syn2s7EH4wBJ/4MOnC7eSQy/RqeCTvunN0eA1iOOAV5+2fTRs3yw?=
 =?us-ascii?Q?c8UYN1ElAOL2qdUHyIWxcaXqtuaggEHbofGaByDda1oAOv5CjCjDv/SeV/uL?=
 =?us-ascii?Q?gwFl2GvFQbQWVsOIvTC7VhBJrJiWAJgrFJjeWCA945a/LGz6PImHWjQft1Zu?=
 =?us-ascii?Q?zDN7F5jq0nHBPSTKmcS6SM6F/Ia2eUi7GHeh9I+dgJyCV/D1U7AK8VVkJbxH?=
 =?us-ascii?Q?j7ntLpb/CesRAjAuia0Ts7fZh4vlDDWHhFcKc5YRgDGn2EjXTggbm4xsOdgt?=
 =?us-ascii?Q?xHM7368+D28USPitCwcy6DKqXmzKuGobanj82RbEvSOu4UKtdnXKcoHbjaGf?=
 =?us-ascii?Q?ecGFuujlGK5Z60zfQUfCPqOmFg+tqij5fQe6o0+E/7H9GhfmDvqbsOMSlIta?=
 =?us-ascii?Q?5MOuxdENo3ElAjRgDC4EJck4exv71PyOaCsDl5ve+59MrmLG1SmCghUm4DDQ?=
 =?us-ascii?Q?jMNBFyCNgp3PJtdsnT9pRIlp2QxX0BO+A9y4OcHrzJK8fFqEHHYQylT7AyHv?=
 =?us-ascii?Q?OaEan3lsm6Bz4VYPbax+6mwtvQtnqa7AELoIQavu9E3fl6AnueB0Lqna9fxT?=
 =?us-ascii?Q?y/pt/FLtvLqAexBkVdDCs028vNMkZ0lyJDZGwzbqR3muG9HkgvvBNZjlSWEc?=
 =?us-ascii?Q?S8eXruQw8uTOP5YBAYjadRd7sxnOYZ/vFByy1a8IfM++WW4HqJDyHGBZmW3s?=
 =?us-ascii?Q?S2B9DkW7kW+9n7LDXPBpBEpyIiL7XwpL/Vqicv5PbxLqq09zTiTpr4I3itu/?=
 =?us-ascii?Q?ZDQURwfCChSVQNm07j7ZnXkybZZaFKhqHORijxp4/gfXBeDU55e76E2TqTpr?=
 =?us-ascii?Q?Hhaeu+DroV3N/6iSE1p5vaFIbueUyH/gYwdAdHKiKZm8pZ9PdIPHp8icrIVj?=
 =?us-ascii?Q?cbWOrSkJKlx5PDqgW4dkb16EBU08p6r0YLuaOs0M0M3vpziFD4hYFt14HPUP?=
 =?us-ascii?Q?84gQYvwT+CHH89boU8wSAOdNIMLdH0ZdBXSaaDwIrrvrKl6RzrV+0jT4+5VK?=
 =?us-ascii?Q?QaRXCtiKjGMF1ALufCeY8Hu9fo09W6epzmEqjp2majD64khDh6tdL1Xnr+2Q?=
 =?us-ascii?Q?n0jzJi7EUCfTjeDnbiG49OP8jnCE9sKBZ1rFDPnqR/oGGSn32eSIznACt7MP?=
 =?us-ascii?Q?AFr1pu1AJrgPeKBbSKJOP5y6edzA/bDm6gjzxTO9a6piDTVBpw6vrLQeY3JJ?=
 =?us-ascii?Q?GY1PAcIMzJu29DrAUamGElWgW5KfuKELYdOGNlJ+V6pAYC4tdC5KQ2n4YKA/?=
 =?us-ascii?Q?Noxe/Eigqf5JGzzvix+3kN/HEA57L8upS1676GwxJEmrXbTYHTWJqFL4RsAF?=
 =?us-ascii?Q?AxJMSbg2Vpl6kSpImp59g+BI5RccKuPaUKhGucPWQiZTVw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6411.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(52116005)(366007)(376005)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1OSWjcwLgYsSEAZUEvgKHzUvrI2jwMUTXcGFY6GseA8F/sEN3xBoIXR0Bobt?=
 =?us-ascii?Q?IBVC+YGSfiGmuusF7lvxNYu/bFZ70GdkLcGQPYNsBwhYcMWX/gIH5+jWpVY3?=
 =?us-ascii?Q?tKWFcE8eay8zM1dGudrPecGnxPUtN+65Wnu4c3qvBeWZdvasq7E7CtDMAkdt?=
 =?us-ascii?Q?1+lTu1G2p6SUi0LPN2diaVryHqNgtBimnjzOxUGdDwuwBKCipg75mFCal2ms?=
 =?us-ascii?Q?QlyIReWrTRjjR5EdErXngJMxMlJZGYI2rw9tgJMGd5mw10OtV2iSQ/qElMTw?=
 =?us-ascii?Q?01nyqP+gDTqDf1K4ZIFfww3D6/igZQeYwFXWaAqoNL4g0PU+SZKFPkHNkJ5/?=
 =?us-ascii?Q?3GO1BBUp7pltT3+sveb2siZRMVXMnEYL1dY0JQwLhCm2UAvbusrn/tGhV9cH?=
 =?us-ascii?Q?Zmv54DinOw3PBpGvlJcABw3Kk1iukw8BhNN51SQre0C3RPfbH07bNb/Fw7u4?=
 =?us-ascii?Q?FoKRzN0QMsa9lOSSmHsHIF7Z3P3XE1bygC5pmADkZjq/hfULvZRJq688dJa7?=
 =?us-ascii?Q?EMiivf6qyMyFejHn4Q6RGj4L7NbNxpTWGuGp0Opwa6MrORSYs9d+MzoDKtPS?=
 =?us-ascii?Q?E5fbVvckBNi6EUfWUEK1B6c0U6QkzD2NxjvBKbQtqL9uUm2UbkNqVwfcsKfh?=
 =?us-ascii?Q?0KMwjNjKUyWqE/UY+d5mCZz9s4N/jmf0FcfoqF3EN5subCqE2nQdM/Nijh/S?=
 =?us-ascii?Q?WtgOSVXT6go9s0GoBI8qdXOQ+ecOvVRYtE+QlJbJgP+WNPZC3CH/U6oQjiBd?=
 =?us-ascii?Q?NBl/MP2zIPPg2BWh6U8WUQ5ExY26a3BCe+Ld42TzogyDtA9Vj8uZ8TispW5K?=
 =?us-ascii?Q?+gc6noiTLjYV3xy+8Lg/fAeTy4WLBt39rTb/tAaVNKsu4GFilzzIvbMUF9V+?=
 =?us-ascii?Q?4pJVhfdhbEJUsGoOw7rvFgdSJ0cfxpGwiCqCL9HAP1xrt6CUzYSDBCLwl1Cq?=
 =?us-ascii?Q?q0CAnNBYiO9NFo0O+juuVFLGqF+iAePYXmyK+giaGh4uW93jpNrBEpoPUQz5?=
 =?us-ascii?Q?aBQt6uZQ8e12bF19wLgoq9WKUKPkEqTi2icO0uVSFLQSZjFompqoQ4Yp0ueg?=
 =?us-ascii?Q?EvFtTDTvrXnlYMoukR998BS+5iPqwRkGYs4rdug92Jw5Aa4RVbej9aSg1Woc?=
 =?us-ascii?Q?3OUBVdkypaPn23WYFNCSeOMjUA8NMhIytlMhLI4XucUKm8yhiXtJ9+liRx6f?=
 =?us-ascii?Q?o3edVxbtlmOc4quIUApdhsmDqrhrK6Pd9s0AR5YQ6lzaPYlMk2UE0d52kct8?=
 =?us-ascii?Q?EOn5B/ZhZDF1G/5q+lKNHE9EnDDJAtV0iqR1T6Y5hIqyd1jf5RNM89TFoXHb?=
 =?us-ascii?Q?B1Snp1FQaDWQcxKLqgp/Eikirfu0nnSkpcZx4gcyPe4UaMcG/XI+zGfi0buq?=
 =?us-ascii?Q?XKAuaqpvQDpsX7SBIdqVZEB9sHMItxqKKUcYoKWdKCmCJRs/eqsMxkmox+xo?=
 =?us-ascii?Q?wNiRj4xnenuEGW3AHCuJAayD8pUOePMjUr2Z9ITLsXRAwlmuBA+UVg0XWmhA?=
 =?us-ascii?Q?oiIQ5BV7CbokKQp2zc2hCwIQfGIf5Dgu7/RvBWl2EnOGYCrRzVadEeQYuDfD?=
 =?us-ascii?Q?A2WcqbnJSDxsB7RyC2Whms99y2aJE/akcl2tl/qU?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c44fe5d-207e-4491-786d-08dc755d136f
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6411.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 04:02:59.9830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qLlIFVmCPhGUs/p1DBNJlv9rb2BaT2i0c7ZSD1iQ4tskE2lpSwD0j8UeCpho7uax0aUVKHQIjp0+RA8MzNEmyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6807

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

