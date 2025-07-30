Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013019.outbound.protection.outlook.com [40.107.44.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DFE1F3B87
	for <dm-devel@lists.linux.dev>; Wed, 30 Jul 2025 06:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753856281; cv=fail; b=JYEwAPF2wQf2yAXhrxbYwYnXvQWKl+ztP1SjKy1PYMnDhTldvvuoIgOGUBTcyUtlXOXFWMfZHA3QehN1fZ+5Ve4mYOIDteJ1CLlsbxCqggBVT6p9lQYO1QBU9BinLVR1zz0nzUUsscp1LvWXyrUl5BmI3SP3KcHZnYMGV0ptm7c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753856281; c=relaxed/simple;
	bh=IINrJkFUpEg5crME+M4QtQNWQWO3B4tmiLdm/AWoEFE=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=UUKBhpUl/vxOuC8dfmZxHMVficZ9PMVxQD25fayzECMKW1xrC5wfM3rcFX8skNHKS/ib+OaUUqUOamAyQ/fxESqhJELDwz7Yw78JfvPlcGbqgGGya38Lumesp7vt0lIkHN3Hh9bCRjnQcgWklGaBnnyMAWvITrnPzJIo81ZTWiI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=McTmhYXO; arc=fail smtp.client-ip=40.107.44.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="McTmhYXO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CfJUx33Nki65epT/U8v9EhzL4GbiUHiP4GTVKfqBaMzeNlSLKpD0eHmYVyiJQYAUMgPjLiuCH2ihZufjCDHC5Aija4JpvazFXolmXTtRFfvwPMgM/jYGq3/yLFHTalkIZ5xAlTKssHF9FJiXHPv9T6ATdk8faOqpouCVhqu8Qq+JdUZL+K2fM78AgvEbIpFEuwL9T657WYvoKHkhesze9phccAORa+oXfWpidz0yvkoWN998MmIyk6etdXTBE8meJ2QuP/1Nnj1OdBjnLMqUaZYR7e+KOmB4sox6zvTsUXwS5hCoirOA3rdyxuDUEheFx/La3ZB6MOPEX1/j9d+iZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pWVE+p6RBnHQzrvt9VL7UKh4bmHPBZRf7M4QNLJOMIo=;
 b=ZEqudCts65erRgznSgAtl0APPUTNc06cKB81Bx/lE8QeGx3FqrBRgEliCKq534I43irudVUbxK8h1ssXBGAaFWtAUwiqtWQDcWQUZM+B/39fU5pAP64a+MMRRX15CgyXg2bTXzwhJMVr2f56dsCV5SNIXcEJ3SHNZ8nDH5T7bKJvB3HKXtFFWwxQNPVlqllH94Ax9KxFxmyXcLv8Zzz5D/ZP+0BrCOTOMF2U81aVuHh96jGVDL+zVIxStWEC8ENUR/EmtrSjShx6Rv93BBH2RFj+gGPekRPGTTHA8ncvKI9/vRBt0eziWbvPSkRFuRl5uBrEGyg4gH1sfqkkox/MLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWVE+p6RBnHQzrvt9VL7UKh4bmHPBZRf7M4QNLJOMIo=;
 b=McTmhYXOz2RVbN1OmO+XsYub1FYICwZmYbH2JawEM8hVa7qWOoH9A26s9GXhOtX1jkdpgdUxlOias18kwj594kvNMPxTUC+LawC6BHFMMCJL/JIkbbadCQla6Sa1KcKE64IG+zueWDy/w/EHMDSFhFyYTo2cIJB+iAF1rHtOWwA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from PS1PPFE5C9D9891.apcprd02.prod.outlook.com (2603:1096:308::2ae)
 by KL1PR02MB7212.apcprd02.prod.outlook.com (2603:1096:820:127::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.27; Wed, 30 Jul
 2025 06:17:55 +0000
Received: from PS1PPFE5C9D9891.apcprd02.prod.outlook.com
 ([fe80::e3d8:6cd4:4818:db76]) by PS1PPFE5C9D9891.apcprd02.prod.outlook.com
 ([fe80::e3d8:6cd4:4818:db76%5]) with mapi id 15.20.8964.024; Wed, 30 Jul 2025
 06:17:55 +0000
From: LongPing Wei <weilongping@oppo.com>
To: mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	guoweichao@oppo.com,
	snitzer@kernel.org,
	LongPing Wei <weilongping@oppo.com>
Subject: [PATCH] dm: set DM_TARGET_PASSES_CRYPTO feature for dm-thin
Date: Wed, 30 Jul 2025 14:17:19 +0800
Message-Id: <20250730061718.1966686-1-weilongping@oppo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0017.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::10) To PS1PPFE5C9D9891.apcprd02.prod.outlook.com
 (2603:1096:308::2ae)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PS1PPFE5C9D9891:EE_|KL1PR02MB7212:EE_
X-MS-Office365-Filtering-Correlation-Id: de82799c-a2cf-47ff-4934-08ddcf30d27c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AmTT8q38RN2d1+uOLxpjZ7sJGLvw73EoBA66sonPKXZLFaTarzpRDk9q2zJW?=
 =?us-ascii?Q?f2m6clQyDR1jL3AIn7+zdULUC4maZm6pAhs4y7OTWyCNtUYvp5QuM6Xo95Xt?=
 =?us-ascii?Q?mCy94HIHMgj4nQ6W1gPsiC8rPyd5UKDtMNNkLXzNBmegmY5cRc6CEi294wMB?=
 =?us-ascii?Q?3VdrB5lgmPrJbLq5cAINHxUhmTPHN/9fSSklL5LUtaWrMhHhRJm5WNQel/bO?=
 =?us-ascii?Q?5/GOIOEQ6q+f2+DaZy0JG0G2TnGTGgFrm7+2cQ/tCzuyE1SyrU3/+I5rSOXp?=
 =?us-ascii?Q?Q+k/E6v2W/QOQz81/cOH+Xf8CkoVENxd/rdrNVBQsY41k2k/QXBFYtF5cTtH?=
 =?us-ascii?Q?H+5ywfsmW+TllKnF7Jm6fBZz9vw79vytwYwe8ElXA7owojncMLb3Ida1yOyV?=
 =?us-ascii?Q?3D7CqyY29ouAbLmFjQwQfhuIVl9yswVxvQIfmioSZMkZjVYGIXz2rdSS6m4w?=
 =?us-ascii?Q?aJQRG3iqVhbucgwjAKN2x1/cvcejVgT2Ovlo5Od4FeBPPIQ+TuvANkUqU4pG?=
 =?us-ascii?Q?l1WPklkLqaqXTy5/8JQgVi8V8H722DH6mygxjYksyueRri7AZG208GsJaQYr?=
 =?us-ascii?Q?a/lviHa5w0d6sIrq/WOFUplF9uf/1zrBChD9LxpKM+eXL480Q3mIhnfV7F9u?=
 =?us-ascii?Q?4nmojwwuPMA0rCJk6omlZbtd00IokUD5emQOyFCODaix/lMIDXIOuuqtFEu3?=
 =?us-ascii?Q?GWSoblc+yXzx3u2pqxVGgSU3v6XltaW2p2aYF12h9uMZbNn2+wAqbgDWBXcA?=
 =?us-ascii?Q?vpKOew8Wf5zPw0qCSQSeSDuLQW8EfSz6+zqtYtuQw0NSSXR1xN+1mbMX++NB?=
 =?us-ascii?Q?znN3DMXtVfHuaxa2Yfhw8inKa+E/jf27ZG2Kd24Br3+D8zXI9g046jG6wKZi?=
 =?us-ascii?Q?hDI8jYWjnoVp7aEUdV+xkwi+bVlrTzr7/ttEPlrcBJNPIqJGI2lU5Pkyul//?=
 =?us-ascii?Q?TO5r94qLoQQU0PZBJKvmZsJNfVc5UoTK3GNm29W/BFUrBS23u9mMOAM6DDLf?=
 =?us-ascii?Q?ADwV/JvtcVgx2jkX/ibQHD3wnWLKnr+M0MSJCqcaKsAIn5E13zd9MoosePDb?=
 =?us-ascii?Q?hX9TVshjk11sAUkRloCyvujYwVpIMFlRky94OtJwb5lUAKuCWIUObhhmCv6u?=
 =?us-ascii?Q?aCah9J4ceywlbop3VodZ4L8nzLAoWrT5X9oMslA3Yg5NmKpdfRCTUVRdJRT0?=
 =?us-ascii?Q?rR1znIOQIdxo4N+e8qkVATGwgzVOMHjflR1E8BfVny+YtrBxrd2mT2TatPYf?=
 =?us-ascii?Q?Qmbq8CWbK5RFQPagIeuE8A6Fsz0m0oyfC4nIH37wb/krwbkAPUZxS9rS8Yf0?=
 =?us-ascii?Q?23Vu4OwIjbGg1BtlSlf0bJ1ID2tczKVS0co61leJYF7QNKt0dd3Xd9SUXJhA?=
 =?us-ascii?Q?EQ/38/uDwopLOj45tBUrfC8flebvwpBNSYOSz7/pTVU8qLBsgdCSgh5pkgMS?=
 =?us-ascii?Q?lCvtDRpaOgSd/lKyrg18B9t3Z8vbxuztjD8tuq716JfvJV745VRr8A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PS1PPFE5C9D9891.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IOn6tj0ze8CYsAH4BlW0v9Opn6STxTjbLNBE0Dpn7BG3tdAgdVUcMez/H19c?=
 =?us-ascii?Q?wFXod6CYtR3aDejfivIzSjZoa2egi34fGB3b8M6HNdiC6DZ/RGGJ8WcQ2AFJ?=
 =?us-ascii?Q?1m4Z6fzh5eaIEwgsbuaGobjG35F8KCbfKcTTfX+bHedb/RdKsfUHplzq3Rkp?=
 =?us-ascii?Q?7hmZkt+UDoZ3u/Sk/S9R1Za7V1NRGtPh/1gFg/djxu6GsCLIoRvLC0Cn0xX0?=
 =?us-ascii?Q?kR06Hgf9zPlNKdQlFaceyykaiw20VbJiN9AcgfGtUuF/k0J3OrTC6TrpVjpO?=
 =?us-ascii?Q?smHegKAAuVQfxQaqGZ3xxg+EsJdG+DU+m9BpaBBbiCbbyBFS8BE3mI3J4lhd?=
 =?us-ascii?Q?EqHhc3jlQLw//gI/2z7OU/Ht6bKUo0Cm2rPDzukRVaMME3KE3aAkaKoouPUP?=
 =?us-ascii?Q?xIl9tKnzKC1GiSnDiMIUSMTil6xnVWeveilc3AwXA7JI2fMBdw2FJbTIRdwU?=
 =?us-ascii?Q?90qcfinu429vW4bMJDs3/M95tTU0kjNo3PGus1PYeqbj9c7Jg3RITkrvSos9?=
 =?us-ascii?Q?xOnyosI5gpt441IyRQlwvEo4FQAAqlqLU2TxPn7izYSeOZD82KxgOInNj7RB?=
 =?us-ascii?Q?AIgU2SGImuxtN1a6LiQYnFdGQ4o0rZ7CBKoFtW5CKNRqE9DUS/IBq+8jLI0Q?=
 =?us-ascii?Q?uwA955VL2n7+R0StqFGm9Uz7hndqgdD9MAvrDHVB7J8N4cIlpWt5L1m3Ughm?=
 =?us-ascii?Q?aGNiipRG6EsRsxgQzfDG3yQNRPkN6xYbbkN6gDLKt3LfCNBlmHCegXYlrhjh?=
 =?us-ascii?Q?CTt6ZggG6QtgYYzhRopY3Vv1byWkcTicUQ6Lb5+zmD47Y2gUwUKZzpsny/8e?=
 =?us-ascii?Q?rRwZx8bRsQ0jBT1pf3CdTsmJxkJGhlhQtgyI7XLJAuqt3GShJdENwLmUbY9d?=
 =?us-ascii?Q?E7x8CSyULQQmdPcn6/F6y8L2ETobQqNMD4I0b1ZgTipUlFHAY1eW4yPjRHHx?=
 =?us-ascii?Q?M0cvoF0meti3Mk8mXVoAqPG7fM/Ja4FRfSKsvp2kqYbhpkPZM6Xbk3ZJaSUt?=
 =?us-ascii?Q?YR5r7XuyVbQ5H2Y2UzkO7ZKRxR/sQ+bEn+m4Hie1p7wuA2WiKLJcsezZrhNz?=
 =?us-ascii?Q?PotGUC8cBTXXus1QkPJqTxG5/9oWVRxT6Ke+wVFvMH7RrHrdRz5V3pE0W3ZF?=
 =?us-ascii?Q?ayIroeMAfDHlwZHm3EvZameSfn58sI8qTJEIIfpVrkFwXgpsxAlozP11WL3y?=
 =?us-ascii?Q?zsfis/md9yKd5DzDg2o4xU7kcP8BZe7tan/he7U9E3bqMjumPn5jglD928vg?=
 =?us-ascii?Q?rLH9YJ1KqWCsGV7NsC7rBO9WJHJCCsTHecyXnnh6khAsidx1a++a0G88LNZl?=
 =?us-ascii?Q?Hgd4m1vLXXWTkqQXFgftU4jqwyMiKp4zo/LQ93sfTcZpQwQtPTocxv/+ArrU?=
 =?us-ascii?Q?9/j01abKr8IprM53dZ+uwpsE7GfmEc94vCQOFm8+8rcbOpLmLwW/lU+cc1Wl?=
 =?us-ascii?Q?LpkkOW9TI8Q9KFr2jC22l3E4cvw5EhkJeSJM2tbhSgN9mkGeYa0+QXCrZ9Xx?=
 =?us-ascii?Q?9SYHkN92cVc0JJoCY4haunsmLdxfhw4TV7evCARjjbuDF6pF7MVUZFGAsdT6?=
 =?us-ascii?Q?eel7QzB/wZik2SqrtZRzWFFG6H0Biwd3QHRn5djK?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de82799c-a2cf-47ff-4934-08ddcf30d27c
X-MS-Exchange-CrossTenant-AuthSource: PS1PPFE5C9D9891.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 06:17:55.6475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 74JU3R7SF2/v1LTl+iiEhq76/8q5ntWHYJ438nTgtC0hBM/ReQXW/vDiaUq+Sd1PXU/yc/dO8bcE8glMJsmn6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR02MB7212

dm-thin obviously can pass through inline crypto support.

Signed-off-by: LongPing Wei <weilongping@oppo.com>
---
 drivers/md/dm-thin.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 05cf4e3f2bbe..42f218dcf99f 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -4111,7 +4111,7 @@ static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
 static struct target_type pool_target = {
 	.name = "thin-pool",
 	.features = DM_TARGET_SINGLETON | DM_TARGET_ALWAYS_WRITEABLE |
-		    DM_TARGET_IMMUTABLE,
+		    DM_TARGET_IMMUTABLE | DM_TARGET_PASSES_CRYPTO,
 	.version = {1, 23, 0},
 	.module = THIS_MODULE,
 	.ctr = pool_ctr,
@@ -4509,6 +4509,7 @@ static struct target_type thin_target = {
 	.status = thin_status,
 	.iterate_devices = thin_iterate_devices,
 	.io_hints = thin_io_hints,
+	.features = DM_TARGET_PASSES_CRYPTO,
 };
 
 /*----------------------------------------------------------------*/
-- 
2.34.1

