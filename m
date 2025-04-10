Received: from HK3PR03CU002.outbound.protection.outlook.com (mail-eastasiaazon11011013.outbound.protection.outlook.com [52.101.129.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8DC1EE010
	for <dm-devel@lists.linux.dev>; Thu, 10 Apr 2025 03:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.129.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744254589; cv=fail; b=ICfQdC1SUg30oSDPyCWaepqlvELdk3l/+nbX8ZSsValZXUXbDAa1e3egHyVyWOHSvPpLrqJdVGS5JACeOLGIxNbtuZ5/76pD7HzEx/OwKb8hlQJQRv6C2cehcSaqR1jPSU32ahKwh1abpkDzQ1SQtgQAP5bRrzb79yK+5xuy3Tk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744254589; c=relaxed/simple;
	bh=/jv18j6N9mUwxlk8e7BT8Kb2kYhY68Tz/dvINWPD3wQ=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=Y3WzqD34m6L89LuWyctf7s8FY2kmaOk+yhMDcQQLWysJsbi2kNYZmnLdhcj/dl7xo4nncu4K4qkgG5q2l2ULyh/J/m8qEork3/ZfzIVYGT3emqTe5KJLgrokOEy8WpOt5sqfPW0Nx5nFkvhJllHWzL9b3vT/F8s5rGCQADTxmTE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=Kpz2GX3f; arc=fail smtp.client-ip=52.101.129.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="Kpz2GX3f"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TKLp2slcregynmzJcIz6wtNQReq3QfBcsHyumdxWRN2fOd/yF+4IJjb1HQluFy2149qTRYjN0VD2/w/z2+Ry/DcQs71to18NTKsbM02q0bUvQYepS/p2G2sIaWL+XzYThIku/F8KajQpBy5PtreQzF5OYR+uwirWR2NB5VUF9jqP0CVX0NqTXSOydqu60hOVlPsntqQMvc7fg9GlQaT+3xGuP7OHqrCKo3rp6kJJhhIBxn1kQsOBFzwOrDVSGf25GNz55RHHeXkHCjOk6OIyUVpRjeUvo7MDWb64OwWmloXjXODmb6t+ysoorUjn5mdFYA+1TzXjjnaGx3eIzLMtIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ha+bSolPWMRjJq5+plf1AoJIVyPxaaMpWpmTowDlJaw=;
 b=qZeYmVBuRRXuTjQ4Wgy1aBDeG8UjoKEdqaxbpkNu7SOkDlBR5EWgoGUUCbBI/Q473BKzWXPAQKsUHpdWn0RW8YETiW9/7LloanwXwMamuFnGrzem/AaLYfuShLfSjddYqRV5alDpb582WVqHFYMCx8qVoo7KyhylN3B9vbwUtWrYUchDO8p37O50By7cfXkPF63hyQJ5fvO0VbZn65milHLcufMTLtCPXKuPQ9xq0rPHi6S4hwf95Bqi6YCF12BtNHbamDj7oyVZkaCMoD5R1XzOVZs7TMiZLoYmgr28TiKwx6Us32UO/mcu7HCa3TIF1XSDrQ2YdMDNOclSXKFnNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ha+bSolPWMRjJq5+plf1AoJIVyPxaaMpWpmTowDlJaw=;
 b=Kpz2GX3fBkq0dZVEstu/hnOZ2dDM/vn2+1JS1eK6d6n2wNDg7R0mT4Gsl2TIOZRdlXkp06Hoa8ov5mwJjZQ8dATjE4LIwHdJGMclA6auO53hoTp0ov2AH8AnyGtNDmg6Di6oCEvdxChhmmZwAfWyD4sfp8l7pBPRMVHJjlevmNM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by TYSPR02MB7489.apcprd02.prod.outlook.com (2603:1096:405:34::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.22; Thu, 10 Apr
 2025 03:09:44 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8632.017; Thu, 10 Apr 2025
 03:09:43 +0000
From: LongPing Wei <weilongping@oppo.com>
To: snitzer@kernel.org,
	mpatocka@redhat.com,
	axboe@kernel.dk
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	guoweichao@oppo.com,
	sfr@canb.auug.org.au,
	LongPing Wei <weilongping@oppo.com>
Subject: [PATCH] block: Export __blk_flush_plug to modules
Date: Thu, 10 Apr 2025 11:09:04 +0800
Message-Id: <20250410030903.3393536-1-weilongping@oppo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG3P274CA0012.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::24)
 To SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|TYSPR02MB7489:EE_
X-MS-Office365-Filtering-Correlation-Id: 19c6dcfa-31c7-403a-a9e0-08dd77dd23fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|52116014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WoU9x0q7ROKji3aNkexmAwnDLDm11sGy/S+WfNa4EoMBZAU/b5P76dhJWnFh?=
 =?us-ascii?Q?OwH57YgRs8Z1DlYArDrxe3IjsszxBjw4eGW2SJVhNpTLMwQ4B4M+520XM24b?=
 =?us-ascii?Q?csuirJueRThcixi6Ylu9fdA3hnAYQ6peSSwAJZ2Br0OYdNRxFh9QkrPSKn6E?=
 =?us-ascii?Q?LFTOROYBwbj0OtncRdXsMPoO1WFCnocOGkzQdjRm8RejoxbgfrgVk6aJGEh/?=
 =?us-ascii?Q?OIDMvs889d8q/+BjeZtQdlFWhZga+V7bize3HZ4fERP8e/uWObuvVTXPSgj4?=
 =?us-ascii?Q?zzJgXQv4Foas9Sx+pKaFCThfJEhHUX1Jc6fZNrT4y+76DmXvUlaH3eAcam/Y?=
 =?us-ascii?Q?mHIyQQ4PzWqqEIJaS69QecM55DUNO02ZZysfM1bE3UIzxDjScQ71N6dCNVjc?=
 =?us-ascii?Q?bP0UlFBZtNyfFr0GmDA2tSS9E9YF0x6BbvVYZJd+tz5gRL24oCCmN+kHcfuK?=
 =?us-ascii?Q?lyoWU4tkX8oXtj79wX0C/wZo0lz1pE6plxttwnOa0VV7dyU8mSf5HFS2c9nk?=
 =?us-ascii?Q?ZKpzHL3+eUROVgFneADq4Sj6r5H7Ir74VJStBehj0jC5SMNHYkN19rsce249?=
 =?us-ascii?Q?sho4Z+TRQ9YnF8NN97tn7ifXgB9VMBkcYZz6xI+D1O1X2HviD2JWt7T1jGCe?=
 =?us-ascii?Q?z5eWWTU9F0BG41GY/lXCljROOQfLeIzAQHj4gpWoT/8bU6f4sz8nPNamGtvB?=
 =?us-ascii?Q?/UclAksfgZERZibmDVHEXpQo4Sc7M00PdrCCab4N2CUlCt4/CzMw/8vKn6rz?=
 =?us-ascii?Q?FNBkp2epTxPMRfXiqoSYtFVKH/7/IspLS8lbzH7Q45w+78mXQuuxu9jo+5ff?=
 =?us-ascii?Q?zL17hNthuSFxLwqfLv83rJecJqolVA8jyipuLJjdFf+fIgcTkVknmJ5wIF6P?=
 =?us-ascii?Q?Jz5ERbBtC8QXwkcH/2gfx9mSsOfCA/SIyTYwPkqgj9IuOWlwAlALfTNKIsvG?=
 =?us-ascii?Q?+XmdcYhMdukZ+oyB3tiieczSR8h98LJo40lDJ2gUmrmilWt9weoaqbiSBRER?=
 =?us-ascii?Q?u5Ng78qUNBGi8vtLMFbWtfbcodSLIeXQ03eHVgFZ5odGi3CI+byyEhpXHxMg?=
 =?us-ascii?Q?Z79y3nkPeknUDJ0AvZTspfPIynA8Dw0U2TN5iPBmjRT+ueTRKnGkY3jNxCF1?=
 =?us-ascii?Q?oe9foH8ONOnDvwni9SAVYbIIyUc0GXFYdYR9Nm0wH32xajhJHFzcq+l262Qf?=
 =?us-ascii?Q?AkLgJtOSxRW+C7v09o979SuNDH5A7HvwVDwNXVaEtYy29nvmT02hhxP2MU7O?=
 =?us-ascii?Q?GhFyXx87YrJ5qegDmxgnCkazENg1pO7rRYNH9yB4GljoolFsMfRiDG3HZ+Q2?=
 =?us-ascii?Q?X77RHAjSLMcmWX9+Z3NvgKtjKMBsl3XU+MCiTPgJyYdPZ0vU1YxweRf8kfoX?=
 =?us-ascii?Q?9+wlydiBndDXQ9Zr7yD/JWOQH3XOUP32gAcarYBKzsVs9u6wZ/pwz6/Sh92i?=
 =?us-ascii?Q?ogeBMMmYBociMhDGoZarX3S8XTNOL0Zb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(52116014)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z+AVSDdC9bL72SeoaR+JTcu+hKSsbdYWbpCVsWY0MCVEebTxwLYN5EXDbgZJ?=
 =?us-ascii?Q?lSiEBCSp58BDVy+YTJok+juAKclt5RlbjunWdrjlj43tfLN6Ebx6JJO2g8Nt?=
 =?us-ascii?Q?j+1qKuWD7k5P+sDeAz8RRLo1+sUMNCOKlErP2rAZbKxL+JZUAhPaVelNwaZ0?=
 =?us-ascii?Q?GXcJpxpTg7CtmJ4K6U0joAUye3Y2jPW0566BC1Sb114UFwHuZ4Mb7ImBi/Yc?=
 =?us-ascii?Q?aj1yTW8LQH0vISJ+2iVC1OzN06M8vGsYnYqx0P8REMzLRYWpNVOJRdKCTAJj?=
 =?us-ascii?Q?xfNjjnzCTm96rP2NbtOHWAiT/QLlz5l1lodZoGQ8xN8EvJe1ZbO0eQYQ+kX+?=
 =?us-ascii?Q?bc4arF36h3r24ifaNoUAaOoQiORCv9slqmLhTmH+/TdvqYFic20iORYe67FF?=
 =?us-ascii?Q?c65qWQiZi2//5nznI8ynOOhAYsM4HU85A6Jq8SXuFPenMWu3nkEAdsiLXm86?=
 =?us-ascii?Q?7wCKEiRejZD3kxiMyGSFjwxdNwKhBan2W0PvGd+s+c9APlIff7PsEIObLlmj?=
 =?us-ascii?Q?PYP1t9x7AkvSVAF7GRJ61840PBf38fJiMxmRZwg3fg/GK4SdciGhf6Raryhu?=
 =?us-ascii?Q?j528iLX+jim/K0hEo79xSzUImAk8Z8XA0EPZMoyPbNOtJS4A/eYE38G69+3g?=
 =?us-ascii?Q?4puFznsPzVvqu2bEx1KRyB9Ff/6Vk85pY/maOJffbfBcZjiFLUTKNjVjVXpb?=
 =?us-ascii?Q?2IDw7uMwCovNuuqVwSnSi557uz28cxvvSmkvFHCiEY1iYgVpf2xMqROywata?=
 =?us-ascii?Q?hAr403CsO/0r37lmT100rbxlG3gqK1K8Ep6WAu2qLlR2Q93cgU8uqMnmohNT?=
 =?us-ascii?Q?vmCXnZAkXTa9PH+nwDQjIcb8+7n2fD7AWV4QVCau1Humqu1vCekjCMJw7rbs?=
 =?us-ascii?Q?z4yyK0+4XrdpTVla1TzQgQ37NqG92aWa+rqSVafcKYYxGRUvlVWWIA00ApIM?=
 =?us-ascii?Q?DrWFu3ul22rOUWaAve6ius/vPHWtvnHPyuiXGoA7OO2NuE93LNuJR2Zsw35P?=
 =?us-ascii?Q?ja7+V3aZhPE/h5nYzZl37Ecz24XHln5+EyMqIABI58NUzuPXh6BvsFUActee?=
 =?us-ascii?Q?AFY/DMVf8EzWDi1iVxq05UhdhY4ANtL4sPog5vKjIpnJq9fbI6k3eC0j9D2c?=
 =?us-ascii?Q?0Ac+/zjykcqSKrIgE5jB7/D/mUJpzcVXBuRP7RUDJ6bA0xsbFaTFP/AU2P+h?=
 =?us-ascii?Q?AF2KMAGZ+c/dbYm7OGTuxcUFscq1Rk+nVZGNo+O3qkrDujBcEWXndq6yKyV5?=
 =?us-ascii?Q?pJLdclzxQ31YBlRYb877LZXwGD+oJR1fOk/toIOhuW9zZQVw8xYa0pO81bHe?=
 =?us-ascii?Q?tfb1b1sLolOw2/FT0YpBXzGpQlMsxOw8HjziHCGUdNnYk5OTExC0S7GpJLxY?=
 =?us-ascii?Q?BMKHUWqnOIVZQNWzu/pDn3PiD1AIVBvzJ0cCZ5E8j8ZUW9uotB5sWXOXITOa?=
 =?us-ascii?Q?RBz82yc/FwpGv1+He+h9x3TPhwmxExMjbzm2dyoC/4GUXOIFSDOWace1Ty6i?=
 =?us-ascii?Q?K3ni9p0qBUZdO25G+MHmLMMu3t7YqLmH1itYGb87TjW8G8dqKt4hxuZjy38U?=
 =?us-ascii?Q?+Moo/PgMOX/DIvrPO5GF3V2arGkeVMi5BnsV/GBC?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19c6dcfa-31c7-403a-a9e0-08dd77dd23fd
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 03:09:43.4997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gVI7sldoj5SudGBlHboJWSYeb7/hq4CllBQxuaoidY2l3vod/oGqNYAcNlGsLXyhcO3Rz8So7+QUQ9ex9Rj9Kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR02MB7489

Fix the compile error when dm-bufio is built as a module.

1. dm-bufio module use blk_flush_plug();
2. blk_flush_plug is an inline function and it calls __blk_flush_plug.

Signed-off-by: LongPing Wei <weilongping@oppo.com>
---
 block/blk-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index e8cc270a453f..4d72ebeb18f7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1230,6 +1230,7 @@ void __blk_flush_plug(struct blk_plug *plug, bool from_schedule)
 	plug->cur_ktime = 0;
 	current->flags &= ~PF_BLOCK_TS;
 }
+EXPORT_SYMBOL(__blk_flush_plug);
 
 /**
  * blk_finish_plug - mark the end of a batch of submitted I/O
-- 
2.34.1

