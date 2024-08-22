Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2083.outbound.protection.outlook.com [40.107.117.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4899712B72
	for <dm-devel@lists.linux.dev>; Thu, 22 Aug 2024 01:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724291727; cv=fail; b=X0SpkcD/f2m3GhVNsMuM1t/dmd8HjoNBYM5qDgjlF3xV5FLhS4XAOHGsI+0D0Q0yprQXR9pqETgqwojmDQyiFA9IS5M3ZXCMczjlmptMbXBhmMMskoGkBE6jkqW827gpImJUTXbwMN02MFWsH0XzoT2y4f9xV4nx5iy7+JWY/CU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724291727; c=relaxed/simple;
	bh=9PqXbQ4pw9VAHilrnhB1TV0UgTmL8hO5uYCOZTSjXuA=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=n+5HpZk9XlEkEThB6xQ68kK35krejiMM2BFKg20XvRnoYBZPUjhmFfUb6Ph+3BKfo7dNenqwXqSITXQhMERxpQbxehSsjlXjgWeSpYAaWfCrSnTBUDhxGuOV8/Da1jPEtYiAtuRA56qwxaQUVvG0llzWU2IBS9vuyOnejJ4bX4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=RbwDC1tn; arc=fail smtp.client-ip=40.107.117.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="RbwDC1tn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f2pbZpmUXGT+xoCH2HE+rdrM6S/AhUWuF1fxNcvMOe5WQCYN4cfd9WsRs3Xx2ZyTEiQJMg70QGRPYhe3qyq75eQNA7jE2+tLn+Alu+9PYtDwLEaSd3XQleKoVp5JPoVdFl8VQ6zbEHdwnBiISuprT9jovwZ3SnU2LHKTncpRMaW2xBp6yykioX6ldyoS1EIXpS4srHuhDdU1+7BQPe44WnimQN3I8bs4eNm1Jn4a4v5bHOv/WC9reD3JO/B4/jbVBY3+xm6bgj4Rf8TCsYI55gJbQgD7OfHIkiz9Sk5YsqPn7LwnOUzkMPQHAbSyw/6zMaQVM2py9FHbtespn9bOVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1duJJ+mhxvDKN9lFwsVr5JsQPYxcJaIzOS6XwhBdbWY=;
 b=TtiX/oU4oPL2spJfqA6LJs6HRSE8raMCK3PF+5e6JgIolOUWnXfw34bgilKeGcoeOJ2i25KNQ+6nBZZA4oH298MIan2TvTH8SklyrkJL1+6UAWt0EUaXE4H0Fq93bwDTgCLS/xHSDbao2oY1GhDHvOC508PlFHOq9Pe/jqWUWpxKyC7qWPnfrZIylPeS/lWJ+tB9fTS21WU2XOaAWjnu0iPros28kKZPLIQPJemB02tpr59704ivbDc4nMNkcXsOeQFjiVQFSLeovyZ4m5ToONBw4BY1aNlKbyaOZtSnG58kUz5F0n609f2WF+whtkOawQuILnlu7Td8E7wrIaYlhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1duJJ+mhxvDKN9lFwsVr5JsQPYxcJaIzOS6XwhBdbWY=;
 b=RbwDC1tnApB6mjTEuvGVjx3CRbPAUkW4MC1sqCuXt1B8jiaxd2r1Yp53YBX3Dzl7MwbKZcb4KFT//Toyxb724BGvJ/MhggbB2AyadGUsa8JTbdfcsbFQt0tO1dDZrsGZPo9LJENm4Z+W0r1P3C/07S4FJQMan29y6rs7iY4gLiYma2p9FMXGLBjn3VLav/rP0jOJUoeQNqSYV4A2365k+z97G+/EvpHgcZJ3z6RfU/b4gZD7h0OoOVG9St6MCuijn+FPP+J3rQYt32fK+Y3Z93IQuPbfw17YXetEG1sO7eKQiYOsXqWum7aWLVpkpkAZI8sPQeSrw6c3iJXmI/baww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR0601MB5487.apcprd06.prod.outlook.com
 (2603:1096:820:bf::14) by KL1PR06MB5943.apcprd06.prod.outlook.com
 (2603:1096:820:c9::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19; Thu, 22 Aug
 2024 01:55:20 +0000
Received: from KL1PR0601MB5487.apcprd06.prod.outlook.com
 ([fe80::2129:59e5:6c67:311f]) by KL1PR0601MB5487.apcprd06.prod.outlook.com
 ([fe80::2129:59e5:6c67:311f%7]) with mapi id 15.20.7897.014; Thu, 22 Aug 2024
 01:55:20 +0000
From: Chen Yufan <chenyufan@vivo.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: opensource.kernel@vivo.com,
	Chen Yufan <chenyufan@vivo.com>
Subject: [PATCH v1] Device-mapper(LVM): Convert to use time_after_eq macro
Date: Thu, 22 Aug 2024 09:54:16 +0800
Message-Id: <20240822015416.3627-1-chenyufan@vivo.com>
X-Mailer: git-send-email 2.39.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0120.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::24) To KL1PR0601MB5487.apcprd06.prod.outlook.com
 (2603:1096:820:bf::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR0601MB5487:EE_|KL1PR06MB5943:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dfc4097-2ef8-47bd-c372-08dcc24d7a45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OsNg+CFGF53dIGEeSRbHjhmkDXuUr44oyi9YYB+Gb4io52AWT7DkTJr4lauF?=
 =?us-ascii?Q?m2P8a4Mxury5FFbpDAIMd/YAky36zl0t8iuvF/690kx3Iv2IAJ5TkXri7lL2?=
 =?us-ascii?Q?ntQz3xnEXLuPasceM4wiVgd8aJLnUYaY2ZVxqggZaQrGVE968lJB7Pp2vXqx?=
 =?us-ascii?Q?vXGyoHzP/1Xq4E1JsOJ11Lzy0UkPRJrkaHTWxG1u2SmeWQie7KBWa74XdfsI?=
 =?us-ascii?Q?pktKQvedbnhBtAso7j0QKit6sjfC+1tfJ4WcKXq0GGoaywE/CUCiWtZEUFcT?=
 =?us-ascii?Q?hPi9iuX1u5vMLevOfpvBe0Fkc/eJTHCUOIuSCFHOFjb1HI974rOUZPp2WW6E?=
 =?us-ascii?Q?xV9fw22RFy/nt8HzeWzPvYJI/TaqWUaRBcWtLzbscqR93QhdimEUh3JMVCH2?=
 =?us-ascii?Q?q7jEFjXJIrBLWaDZjg0QOmZbSGUebdwBjh6PA/GxlZKIsvV7SbyugtBWRfsd?=
 =?us-ascii?Q?4DH2wyJeHEVmse5AKVlBejmpwrCBVMYeGTNwCv7xf+I256TN0L20wyzU6F3U?=
 =?us-ascii?Q?voMAb3tuvSO15DL2EbdU810XrIfjEEPQIPvNRbRIijjkd6J92qqzZ96uHcjC?=
 =?us-ascii?Q?cxUxCaEWNsiXKG5MYKbxnqa7HP7WfhTDPhR5IVfeafku3Q9QM20Xyz1+wGIs?=
 =?us-ascii?Q?MAjR7dNAeNioRe19hPYXI4JoAB0trZdkWU+pAkrtUaw29wdXPBziqMNiWhY1?=
 =?us-ascii?Q?zGG66d6U8UOlZoi+2DqzLuB7ZC7I+8Ni7qg+x2ldmVjVlliGBI1UXX0zk+GT?=
 =?us-ascii?Q?syCVTDu7Jw2/1NCaRxxHpjcxVyo6YIf8E7H6Ft6r3YAXdvpmrzomHaSSitId?=
 =?us-ascii?Q?LRCknpcSNxrdBKxG9VKBckLPUJe/OGdXnTdanVyyYMw6WLLu6OOclPxvhM1j?=
 =?us-ascii?Q?Bj3cKMGzZ/u5tLKyZIdkPBGKxSgAumqwVy4LTMdeUNpeaGEtDvaLThktsM1p?=
 =?us-ascii?Q?k1oDwl92bC1NJ9i9/ROSE1M7EZ2heTfBFFq5v0TZj+GXVL7rMjVgUnOVNvDE?=
 =?us-ascii?Q?DfN0+PVcPS782+d6JlonxjTd8cSzf32iDzR3BhZfTZc64kd9a80aSFPMwi7M?=
 =?us-ascii?Q?jfG+1UjFZZw4iiIzjdCLq0cK8hYyLl3BbTHhPmMYlXSfSfUkYXKmRDFiYfEo?=
 =?us-ascii?Q?Y7r2N31fNoGTQt+2eGtFJI50grcZQ1YNGZTrGMRKhpc5Qoe+p4Mf6weInWUM?=
 =?us-ascii?Q?gyiaBAAQeiN8JVxaeZigzrYBYbdZ+2c33/Sf9va8w9rMFP40n8U2mL6+kwMw?=
 =?us-ascii?Q?Dt5xl9GaKGc0X/yeKUdLEPB7AVL6+Zoy6VepJve0AoKWAJb8GT6xyNMtEW0s?=
 =?us-ascii?Q?BBn/ps21BVok0VycdbqR01tTKFqmlZwU0qNOjuKToEf5Dvmj4anZ8a36vKYa?=
 =?us-ascii?Q?pvGwMagKBQFFJG8N4iTQi9UkAQtycouUeUW4i+vPA4rjyB3EVg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR0601MB5487.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kpUMpHPGOdutyud0RfNklrAIbsx1CquoXZZZ72wnCegV/LOK7fFr7yaWkI5l?=
 =?us-ascii?Q?rtcPU0jVyHpeBYlvw1Ku/TmXlMxjUSNg/olmz8hE+bdkdUKHZ5Cw/UYpm/fV?=
 =?us-ascii?Q?0ctMH3MEg5lhJt649R0sR0OBhI4lHwCaa1fXfnvDrjhlOHIyrFzCPcqYihpL?=
 =?us-ascii?Q?Z+Gqj3kUlUWkusf3bi84hNLhkGQob0p582kQvLi4CeZQaDc4guGeSjCv+kxO?=
 =?us-ascii?Q?XW0pw+VnzGF/cMQgawwdkGeD6sxhdnzOKHuhMbOYxgBTw+qTdAf863LJNt+w?=
 =?us-ascii?Q?4AczqQjoVC/xGW2aTPxGf6QcnY5PWHY3jzarRU1mq+73YOHJdaBVQWDYSJ9n?=
 =?us-ascii?Q?0+cKMVxY+xNr/bj0/sQMAwi7qKdBZBvY8T4oriE8H65LWDHNN2Jm0IbPaQfX?=
 =?us-ascii?Q?qFrFBSzRIiV/uYN5GDkMeulHLtQUD2+wn3n28UA3tx9KGLY98nmWQCBUfTdU?=
 =?us-ascii?Q?4EHnkfj3xah+FZF1RhtUSUdyb0jIsh/4ojRWwF1u34aCbqJ4R6BacMlXl6Tb?=
 =?us-ascii?Q?mzwoms7ZlgDkaqTIXw//Znit87g2a+VN9JhfM0Q+yYvNeDUt3/deGMn0AQVf?=
 =?us-ascii?Q?PMWZDqaNV888ETQnDB63llTijZC4t2lti3mii74miEQiTUL6D3owcoqZRJ12?=
 =?us-ascii?Q?0MCPezREjrGTJpu6t2HMcxlfuz+Gt8SFnf4UzJfeS192pP0xwvW9aw17Qlg2?=
 =?us-ascii?Q?v3/a3KS5qsAwCaNX/7XzEpsUD26CkxSBvyQPF4mwpd9GePd/7uZgRi9X3TYR?=
 =?us-ascii?Q?gHo2xaKYDrKCnBZyJMuIdQUS6LYGK6QJSeflD5VS5IQyyrwamiAVZMPEc8Jj?=
 =?us-ascii?Q?Z7TYj6PEIBKlTgZb4pgn7GcrAUMkmEph/KOoox4Rjkg74oMlnAcohT5J5Y51?=
 =?us-ascii?Q?tMPp25wbr/fmDDsjUoeKm0mwIjLsgDluMExKJLsqDRcJ7yM8pUF5ttxZhMtY?=
 =?us-ascii?Q?/Hp1yE2xubPrNtspg2+3PZ+WWMEwgQOeOVTd0XbDMfKz65rHnkna4CJDlFvS?=
 =?us-ascii?Q?7xkK4DJWZguBWwa0TZEZinkE+mYPZBrttzXK1gMzT2HITrSiQEsTX9ML8Z7f?=
 =?us-ascii?Q?JGuXHn+wTtqLaMHb/GPsxwM2OSt/YLd+pQnRrlZonFhilUXln9ROkpXvhrFz?=
 =?us-ascii?Q?UGFAIHsxycrbnajSvZW/lYorGE6+bsYvqVy7uUGCOxRNL8ygF58Sx4d+wLBY?=
 =?us-ascii?Q?tNBxkwj4pKoZ3F7K4qi+fvdMwpc6x9heeRNz4T3fb2Up1DPOJ43aq29A1l1F?=
 =?us-ascii?Q?BE+Zw09mIIQ76PR9vWVk4umfOILyYsnj4ad3/NgG9ZOXRfM9ZtSQNDZgWifw?=
 =?us-ascii?Q?LNOeM95QgWVhjOUY5wjLTce6BFYs0Zxq7kJeVyQhnd+KcyKowoK6aCvEdFgw?=
 =?us-ascii?Q?sMZbj9I6vbZgGfZP66SbcEstAl6FjAu0FD89p00WOYSNFDo+2OqgcCinZ3NV?=
 =?us-ascii?Q?HKQjnApvFpllt75eCDWBNze4ytIBGT8+sD5bdZmDt1TUiikPgaqrDYjaHHxS?=
 =?us-ascii?Q?cgLB+Nrj3ZSk71nLLfywX9cbyzCMKgvUv8ndDUvnHx6wKchUXfqWWvfFS8By?=
 =?us-ascii?Q?C1L+OqjHjR5XP9bl59v1z9z5auDORMxZJuIpzP8X?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dfc4097-2ef8-47bd-c372-08dcc24d7a45
X-MS-Exchange-CrossTenant-AuthSource: KL1PR0601MB5487.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2024 01:55:20.1559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tco0rZq9xx0fK/eMvWOgxPo9a+h8BBwI3j7P7f6LMnXodSDAXNKMdRPeeuujE5PCQIPV2/y2o4mSlTj7AuJIbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB5943

Use time_after_eq macro instead of opening it for readability.

Signed-off-by: Chen Yufan <chenyufan@vivo.com>
---
 drivers/md/dm-writecache.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 7ce8847b3..548d4d37e 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -16,6 +16,7 @@
 #include <linux/pfn_t.h>
 #include <linux/libnvdimm.h>
 #include <linux/delay.h>
+#include <linux/jiffies.h>
 #include "dm-io-tracker.h"
 
 #define DM_MSG_PREFIX "writecache"
@@ -1994,8 +1995,8 @@ static void writecache_writeback(struct work_struct *work)
 	while (!list_empty(&wc->lru) &&
 	       (wc->writeback_all ||
 		wc->freelist_size + wc->writeback_size <= wc->freelist_low_watermark ||
-		(jiffies - container_of(wc->lru.prev, struct wc_entry, lru)->age >=
-		 wc->max_age - wc->max_age / MAX_AGE_DIV))) {
+		(time_after_eq(jiffies, container_of(wc->lru.prev, struct wc_entry, lru)->age +
+		 (wc->max_age - wc->max_age / MAX_AGE_DIV))))) {
 
 		n_walked++;
 		if (unlikely(n_walked > WRITEBACK_LATENCY) &&
-- 
2.39.0

