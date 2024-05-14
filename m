Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2051.outbound.protection.outlook.com [40.107.215.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6427336120
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 09:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715677560; cv=fail; b=laJw4xfyIHyOoDE9jG1UmjsmM86IGPZquuM2ZsQ2IMKDXwjJJKZSHnYr4nmPJCGlMJtinOJAyrGI10AJ6GtUIdiPmOe9Yo2PzoRgRAYJx++iva8fJDxiAJ5YsIbaUHr/5qzym9996/EpwTCnnfN33CZB0cVBPyEav9O6IVfKptw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715677560; c=relaxed/simple;
	bh=VHZwr8tNtZIJf0LYeloQo1WBZMXdRCsXX3k+TDqo7GM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oywUSnMN5ZGoIR1odF7AG12H1tS1OwauH2XP1SJCbz+39sijFg8wvtdOv/xBMLMWOFfSQS3ubm+f9IRKVQsyO6TIUsg53df8MFDmYH+mJDHJRbc8bmhx178DvqOuINpbT0B2WquR2ERnnZRzFg2XJJBu+38l7Omg6IJ2r5pcnOo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=py3ShVAw; arc=fail smtp.client-ip=40.107.215.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="py3ShVAw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NKx/1AdCkuyEC62D9tK8KGiPLQHDKq3tE/q1j9N2maKMQt5EEwR8JwvZpejzGOdOXzacW0XNadRVLY5ps68RJPQTXEYZxVTkhKp5Yjc8XJT757RqchiXbqOMzytkDMIvP2O8WDgPCKbi1RlZUW66z9c0cqCP1o6gzFAArCmchh60pGMUsBreYILu1t7VniemXVuwDfxrUY4es71npedRf8HO/a+D9+C2rL9WJbk+pOZLvLY0Aao59yip7fWJ0Mf3bDHJLRU8WhuavYy7pnTrmltPdVOe/aNOEDNVoefUTfohCmaeth7QMZbBdiBgvYDMzhNSlEXCqBDZDMPQlZueQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nIEas/sTtxUKYLg98jqka6RbqrUbl8OXP/nhpbEovzA=;
 b=E1VJ+llqwKZXpfxuy+Sg2YXldDcFl0Bslvp0PZXP/Q8YXEtj+taR6yMqzhL1sozcY5J4siG7hoXizcmE/CLU/S2FHUa/Nq8nQGB0jpiMSLVWo6zmix7ZuVEkbdAAhyVAskHUei1t64kqPqJDlminSj17c/U48lASNMd8Sb036D+Nmismdqrxx8EnqC0JWHpVc2ZOoTegtwGJfDygi3UI5WBeSYdqt0Lqs9ldLuJnUVxYtTqJAsdMD2ml6XjTKGjZ6FpdaIR9UYZ5JgeZ6Ajn9wwwvcOUIUzoV8W6JuSL4I4fFA3UKXlekbEj3NeuuLP5EfjqOL3KrN2Fd7BMigXiBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nIEas/sTtxUKYLg98jqka6RbqrUbl8OXP/nhpbEovzA=;
 b=py3ShVAw/tHfyBJCT8S9Nk5hiPNLapifaqIfLVEIyJiN+GP/fpx6UUxiIeThyQ7femPWH/YEy8Qcjm6loG6FD+mAZG+Nog5/AZv2P7o+o6oR03cOXHfrl1eChZpigCr8buLIYnwyw+TO5/2DhnrNHTngcFgUAdu87SV28DFskvFp7som3L+uPCEd4WrHfzbZcX4fv8Z0LISrPDoiDX+iNV8JDid6ApraRj+ZvUuEbEN5X1KBRwpqdfsbkFi3PGlpItWM0NF9SN7ExVOqFLMOgaq/zA/gpLDmoJBZd7Sfau/kGYX9Gcb2uln3KLA1s2xX9D3x4m62XONUUZM4j5Ojsg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEYPR06MB6398.apcprd06.prod.outlook.com (2603:1096:101:145::9)
 by PUZPR06MB6102.apcprd06.prod.outlook.com (2603:1096:301:112::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Tue, 14 May
 2024 09:05:55 +0000
Received: from SEYPR06MB6398.apcprd06.prod.outlook.com
 ([fe80::9784:d8bc:5eb5:b60e]) by SEYPR06MB6398.apcprd06.prod.outlook.com
 ([fe80::9784:d8bc:5eb5:b60e%6]) with mapi id 15.20.7544.052; Tue, 14 May 2024
 09:05:55 +0000
From: Yang Yang <yang.yang@vivo.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Yang Yang <yang.yang@vivo.com>
Subject: [PATCH 3/5] dm: support retrieving struct dm_target from struct dm_dev
Date: Tue, 14 May 2024 17:04:42 +0800
Message-Id: <20240514090445.2847-4-yang.yang@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 01a95b6c-f61d-403f-a869-08dc73f51033
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|52116005|1800799015|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CC4KXHZ7tk6bPHvxBA89SYsJ26rQ5/sUzCuqBzxugKafRjh+omuTLj1TY3yl?=
 =?us-ascii?Q?lg/qkAJC2dGVShtQrd39t8blc6WbghTkZjvlDx4l3mfVz1CKjRiqRrlK99X3?=
 =?us-ascii?Q?s1tqw/zRNLpJVrKxuANlYwv1pq7MwgX8XduwwLLYUkvoDwU9bzuKf3lydAGu?=
 =?us-ascii?Q?zqL6Z4i7ZU2s1ObFQ3WJlRUMU8UcIOpyxat4TJjdZdXaSaBWNjQXpi91qvXe?=
 =?us-ascii?Q?jOFshoEfOHWte5PvlLNSZ9fOgTorf71wR5kvfTupx79rIUmapqyYTFDqVbUx?=
 =?us-ascii?Q?xyD4zD5xx3EkORrzYfMGXW6CH6JqLlFw0/k8fAgRFjNn0iK+Rd+FnELvpb2K?=
 =?us-ascii?Q?icV8v+Tv6gO/GW9akD/7yak4kvFeBSkUQHEXNO62VG5jPTWBrXsaRcBeHZeh?=
 =?us-ascii?Q?WyI82ajL7q3Wb4+78NjBTaqmLoI0+uB6Hjiu5ncGnWjKa9H/tkXCUQUjeW3l?=
 =?us-ascii?Q?ni71gJ64JH9foqC/WsEfQG27+BkskfQFTAa/8+QI4ZpU5zGSyRCx2m8aEPZg?=
 =?us-ascii?Q?K6eW8LPl5HroNwi8MIHYx0rIgVvaB8/urSqeUhWXrsv1cr2Ec9/B/CNkj0rc?=
 =?us-ascii?Q?pKEbEkTsgs62rIJo5ctH9FEJNimKUJGkMAPr0g5fsbddV3G2xlou15puX6y9?=
 =?us-ascii?Q?dsduTwE2+uVcKdUTiRQZ7OaPrGMD62b0JT9pGbtkDTN1uwcnUFNfwiLF6WsV?=
 =?us-ascii?Q?AUapwE3Obg6szMGGRhRspOyEoSFZfp1wqTJkgKQY094AU1p0rTcfAKb1vQiz?=
 =?us-ascii?Q?M8U6ksvH4eGClcUdXYJTxAaXJfF51zuZ3w5arG1ZWJ0Qu9XbCVOztu4biIFL?=
 =?us-ascii?Q?BgqXsv0T4OXa1EGR/nOJiT6qSKVS41dlpUhEJ4QGAK8TKBW2XS/oeUQiF/YQ?=
 =?us-ascii?Q?FG2BpwttOTULj1CqHrUNqMrwNsFEc4dAn9AE8uRhLosrVzjaEIYn1REMOOzP?=
 =?us-ascii?Q?L8VrVP2c7ib8/WyWfIOIWYZyvfxN0xoUqPbGhEUcHt/put3zNq8IsSz66noQ?=
 =?us-ascii?Q?TQ/DxpLXrPvwNsYUdqyTo4mC1f8S+4SmaGcFQ05jQUPfBifyBmk/Qnj+2Upf?=
 =?us-ascii?Q?uR/CcN6MNckdN2dXm9W11xOxYnurCxc17OJ/gJthNhscUeE+HTwA8rlaSjvj?=
 =?us-ascii?Q?/RkTGN+7dMTZxrdiGj3IbaYbTwsoTF7uBHvVD8TL12ICZz5u+UUATuOE2Xu2?=
 =?us-ascii?Q?T+cAcKG4woohvg7dCDffrlEQDpeq0LAIIgkCd/NSP06DnF+NtT4EIm+/ShGb?=
 =?us-ascii?Q?wg0efgFtV1wA05ONd2kqIXVfuJklNXSBKsFgzxehf6LBuTol40HNZmAMIXSn?=
 =?us-ascii?Q?csOaClpCDG0J9mwSD31yzjTVeCb5YcYv2XwL13UFcFW/BA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEYPR06MB6398.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(52116005)(1800799015)(366007)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/FcNCiaJvIKCnhWD2Q6hw1ZgCwTOec5ylyaa/3SXMy4Z+vFSMVEbtRD6vyfl?=
 =?us-ascii?Q?RiA9ZxpL7+HjCOr6QqPRDF6isf2q1xPTyTq7b3WufR1cfOPBmIqP+b5dQ4Yz?=
 =?us-ascii?Q?fi/96W8bCfJlT7/e+O+Z/GetVZTpKajkdCcq1eYhBKyeHcMwniwIgL0yE186?=
 =?us-ascii?Q?Nvq1FtynU30744idB/b3oMtz4R53/yuvs5P/uW2lkywXkV8eu5xnST8O6MBJ?=
 =?us-ascii?Q?fi+J6cE1e1cV1gBvzAKQF7tLAJ6cbAUwrin1y/c92s8EBRC9CQgOcsihQzWB?=
 =?us-ascii?Q?q2/jZlkOzfcXco4Gz8T2TSDs8NExAVGv2jUnL56Or/hY+rNNRnxj9SU56HTG?=
 =?us-ascii?Q?lsZBUGMcrHw9QB/MgwivY2CsxmsAjIlahoxzT7+/y/wH5aWcMgfFqvxTCain?=
 =?us-ascii?Q?8OwWa7vQm7ckulj/KbPG6WwtWGalCXe6uYsM08u4nWegr6OFJ8qlht7DHY2j?=
 =?us-ascii?Q?XwaK0AlzvCWldMQoVa04nFcHrSKUptW1Ei4uY9XzQHucDhXb4sV1g/cAFcVk?=
 =?us-ascii?Q?X+RVDzeXqNQbNE0Fc2YAdjnscH2xn8R97ggL9aJElpreU87CiBQxturNb8mF?=
 =?us-ascii?Q?SMfLZZfLN8bk1SuJn78hLtPv+8SiBJSQOBWk5Z25wH5GRh4TQ0YYIIfmQGus?=
 =?us-ascii?Q?rscMNDLhMt3oIW+lyXzlDreOAC0Qbk7Q/cj3KxDn2ygWY3ZQkGgXl6ssG2h7?=
 =?us-ascii?Q?Zk1KBLNVlFvVIS5zhrda3ZTyOZKhg6L5kQYBpVr+WmGtdxLDpqadzTR+DrQA?=
 =?us-ascii?Q?8ku5D4aN5IUFwmb4vvA4Hqytyi9DivUA6h2PO0WUtTfQJTmNxRfaoWCxGn+i?=
 =?us-ascii?Q?HT37gXgKtGiBWWPv81QRT8pk0ZHgvnOdi6lsy9+B0pknrPRuZqRHKHWqmlDE?=
 =?us-ascii?Q?jQ0s7gPpiJfrL7EVx/hh4r/PaQZ7qsw70svtxv19GkkCVPlJ8wYh9daMR2Hc?=
 =?us-ascii?Q?l/yWtPZ/Rkar3Nl2I6kfoOYV+RrbbCo+XPCAX9N1v4TJWp7dkeT0lX3N3VQe?=
 =?us-ascii?Q?fENkVz1D1V4fMyEkkd5fgKAHXAUc5S0gN6c9p7TqVioyMbzVhF0Wzf0s+X4C?=
 =?us-ascii?Q?Oo68T3Uo5p3ehuFjUCMEENjip60XyIYWHvzToEBWVC1gBwMjdiACCAEyZCoS?=
 =?us-ascii?Q?K47RL8UzSvCRV6Si/M+3fsQ7wc8UxiXzlMBKuTCHIeTVzXAOXaC8vJfRShne?=
 =?us-ascii?Q?rTLAsfI3KMD5RAq+X/tew2uvBuCKMnz6Obp+GC90/pMcBkwFej8uLtkroV+y?=
 =?us-ascii?Q?HLNQmABxa0SWqTOWy7vO70X02GwhDFtMe+mXoMeFg7IKUOIybjTh/c+nNAcV?=
 =?us-ascii?Q?6871sxJ4fLvPVuOifJx2Ncox/Eaxrqa4q70vHAy24r+JuKNRagKg9bN77Xsg?=
 =?us-ascii?Q?n1SDzQmVNT2H2zw1bmsDC9gIsBFgQbWaf31mSff76i8D8iyjmYz8PQDEI13z?=
 =?us-ascii?Q?BFtEkq6g+A2JH0lPGKLgTNUTbQIH042d3qNMNsyHFoqDvZcbAz1lyP4bhm7U?=
 =?us-ascii?Q?JUM4EzLYq5K53wcYYvOjhlq29wMJNWj49tvFwrPxgMDIi68BLpVG5Y/oLa7x?=
 =?us-ascii?Q?S2ZX2B+F4nPcbzTtGrbhr9Hlj8snHvwG63DsoAML?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01a95b6c-f61d-403f-a869-08dc73f51033
X-MS-Exchange-CrossTenant-AuthSource: SEYPR06MB6398.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2024 09:05:55.7555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4LYvc197lNDsOIbnMV29w5KgiU1/5d4h3rpsSiVNJ6HUW4RQEfnUaqpNiZzpCPy7LcvbCsKsIQTKneQnnb4dXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB6102

Add a list to the struct dm_dev structure to store the associated
targets, while also allowing differentiation between different target
types.

Signed-off-by: Yang Yang <yang.yang@vivo.com>
---
 drivers/md/dm-table.c         | 36 +++++++++++++++++++++++++++++++++++
 include/linux/device-mapper.h |  3 +++
 2 files changed, 39 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index bd68af10afed..f6554590b7af 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -741,6 +741,8 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 	if (ti->flush_pass_around == 0)
 		t->flush_pass_around = 0;
 
+	INIT_LIST_HEAD(&ti->list);
+
 	return 0;
 
  bad:
@@ -2134,6 +2136,25 @@ void dm_table_postsuspend_targets(struct dm_table *t)
 	suspend_targets(t, POSTSUSPEND);
 }
 
+static int dm_link_dev_to_target(struct dm_target *ti, struct dm_dev *dev,
+		sector_t start, sector_t len, void *data)
+{
+	struct list_head *targets = &dev->targets;
+	struct dm_target *pti;
+
+	if (!list_empty(targets)) {
+		list_for_each_entry(pti, targets, list) {
+			if (pti->type == ti->type)
+				return 0;
+		}
+	}
+
+	if (list_empty(&ti->list))
+		list_add_tail(&ti->list, targets);
+
+	return 0;
+}
+
 int dm_table_resume_targets(struct dm_table *t)
 {
 	unsigned int i;
@@ -2162,6 +2183,21 @@ int dm_table_resume_targets(struct dm_table *t)
 			ti->type->resume(ti);
 	}
 
+	if (t->flush_pass_around) {
+		struct list_head *devices = &t->devices;
+		struct dm_dev_internal *dd;
+
+		list_for_each_entry(dd, devices, list)
+			INIT_LIST_HEAD(&dd->dm_dev->targets);
+
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
index 0893ff8c01b6..19e03f9b2589 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -169,6 +169,7 @@ struct dm_dev {
 	struct dax_device *dax_dev;
 	blk_mode_t mode;
 	char name[16];
+	struct list_head targets;
 };
 
 /*
@@ -298,6 +299,8 @@ struct dm_target {
 	struct dm_table *table;
 	struct target_type *type;
 
+	struct list_head list;
+
 	/* target limits */
 	sector_t begin;
 	sector_t len;
-- 
2.34.1

