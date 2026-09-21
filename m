Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011012.outbound.protection.outlook.com [52.101.70.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FDD42B301
	for <dm-devel@lists.linux.dev>; Mon, 21 Sep 2026 08:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789978359; cv=fail; b=XTJcVSi2MDZZaeBCOazpS1iCYz0lBex1+/YFycJDBMHuBbSJ+NROpWTFbV9OWZuMAiJRnr3PKAqLzXWHZRQVLk63tAP8kMxeUor8dUZBMneFMqPAYdITjjp7L7pFUMMwAnBwWF+4Yy5JYJgo4M+E5VqB9O1Q+xze+P23/AkGk7Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789978359; c=relaxed/simple;
	bh=Qtta1kndAX/sb5iypsqzcZrv/wZGu6H7gJLNnjnuxqk=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Z6UgKW+2C3w1sqkaPVgFwad8dPdft/w7M0T5u5cQaWtwcOR+/4lJ/eazeClA7FwvHCUtep7smwAoMgse6CpEvq34u4JDAfE15CGIZ/EnXF2zj97Z1vT/OqprIQR05S//eWj5o0k1xZWkP40dEW+1on6v6DQ3AAK3e1Z9FrEqXdY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=TyLfwg/r; arc=fail smtp.client-ip=52.101.70.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="TyLfwg/r"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WB3mFFBYSnCRsaRLEuE5oMfx9tUai+4D7V8Pn7wM9SPqch1bMzGI0eZmt4engTnyFoPY5cC6fVp1I85alllTx1hfyPYpWuzCjiPqIxQI09URclnR0Hg3yZ9vUS4XuP3dvYh598ZPrWeEPHNVgltUWDB3Qissr7Rliq/18U2qQvVjyLoMfvvjGIjcidcWbImq5LJpebh/xknmsE1J5P/wdUQeCmZ6CKDwISNazPy7hY0Awk++gmxVrw0SoEsxeUIin9giHSvdV/eFMzaLGFVDzLzX0/uMgNL7nIgHd4zesrVASdsh5sRr6kYKxwdv/Cvm5g5Z35j6qsfFtfXAuZu9VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wLX4xOt8BwBzOrINlmh635oOTyEg8+Y8X+QrJDKPLKc=;
 b=TK8fgApw92BzBjchhgxEVaIEjz2RQ2A9Gb47RnawABal5O2i4zmolDOcTdIq+TnEo/0EqotSAE47d5Y1wIAanxgqgd/v6T0YdM9ef58HGuS1k7UMHdSnPeKMXFHFklaS+fhpedgIalMUCh7lXj/1Fi4q8nVd5AgNqrI0/uRwpty0803j7N1HRQpsK3AeGPUdQ3lino+uu4sp4aApAZTlRtTLNmM8plVw4MCovTKKBPk5GBc2WHhoiwzH73/UboHvl5+0xgUQf5YtmwuG1a9ZscXctHAJ1YxIZTE5VDyAJMNw2vyBZ7MGLf7UvxJAsqFHGma1uIiye/3NfPy1ElBy9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wLX4xOt8BwBzOrINlmh635oOTyEg8+Y8X+QrJDKPLKc=;
 b=TyLfwg/rfPX3uExRplopxXjTeXtbFGZCAc5vJ73AMfjmKuwBBTE78Ehp/989GGYX7QdCWoZ/8QskZnns9bRmYRjQnupd9xcV48mZyQjBvNoNJYgHMCCbFFGv8sC3mEgmgcRGsqGHOrEQfIyXNtuYLg2cDZDYyZhtQLIeUvmRBwDKeSwuueAIuKZMoOVcqFh3fWyDU5ku1HAFsuMJ4staLZcL/e642Lurzp8tLNm56IzAdNd7BAX2FtvHi1+3Hx9s6cOVf6hTF+ZhpAsFJHO+wguMVSYSHRqg2P3z2rVx9gsW30FAZ/wR7pzGg3aFI2cTb29MmMLjoK9+stZblPh9Tg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by AS5PR04MB11322.eurprd04.prod.outlook.com (2603:10a6:20b:6c7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 08:12:34 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 08:12:34 +0000
From: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	Peng Fan <peng.fan@nxp.com>,
	dm-devel@lists.linux.dev
Subject: [Patch V2] dm: use assign_bit() where applicable
Date: Mon, 21 Sep 2026 16:10:07 +0800
Message-ID: <20260921081009.278532-1-peng.fan@oss.nxp.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0174.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::12) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|AS5PR04MB11322:EE_
X-MS-Office365-Filtering-Correlation-Id: 044c8239-5df7-4995-ebe9-08df17b81762
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|19092799006|23010399003|11063799006|56012099006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	UYznF3eBYKqik7nAB5E4da7BfMgvf+A+8Tyai/hqS+HYo+qTrxO9PUeLx+dzw1k8HjtYilFbfRTWhsnoB+vHDTPwBtO78VqOp+iQZFMBqxgDtvmyDzaLINTtL2OCgZxjj42RTk5nWw2nG+pblhf54ptix1v+dAJFKOkszQGeB/XDXpR2nXxz1i5OnpuxwwEUmPMWYkBmCTfWXkEV8y55eDe+HQ1r+44pY+NSzZ/bxW7TQL7vm7/t51UdOCC9CsbZRlH8H9tRGCX6KiRYRZojTxKacGlRL61wEabI89QewroL5mXgct3ABOTUwIcXLxNEGh1IgKJQJl65AjU1+X+zfBWQuwjscOKqnnbMhHeOU9SrvtZcHnGcmHK/9+3bxKxrAwPozWX4NaVTttVlBY1L9NDPTl0KVQel70YKKULFUq56U14sMw6WYRldwyI6MTle/rUS7FL5otuuFYvfYy4nrgchLdO+wS8bAJa217410EHi7lTok9HSun2StHx+lukL+nh/bYXLBGCb74kueAJ4dB6zrK9VDM57P91zskfeJ9gfmkAWl65LpWXStlBF4aI/Ogwzc/z9SKvK1fG1udV+tFyJG4GKCvNhcH+SeC0Ipjbw/Jg9QS1o1Zy1EjdyxlywtCIlgSYWwX3nyCUKDZX3FHiYSbF8hgNbSnH911Xwbz8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(19092799006)(23010399003)(11063799006)(56012099006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TvraXKd93i7VeKO/f4pUXN1g2HQWMt+WrOcIAOEQFDGGYXb4sSW/LbIrNt6u?=
 =?us-ascii?Q?oQVu3Y8Hnp03kphHqP3UnlxzIQWo4cKqMoT1cmp7fxqJCmcfEZPbk0t2p9Cw?=
 =?us-ascii?Q?GV5SVk8h43+tTiywGn19/0ZDTqXki8QAg3pR+lBVPjGOEEYvx10VD2S/TWr8?=
 =?us-ascii?Q?oypFWXbPKnJlK2sfbA7r6MIlOUPSGWa7wyw71Zn2V4JBoEpcsSbqVBgp9eq9?=
 =?us-ascii?Q?N2+wap6DBoEwbkiJg+zfNZxMxzIOghrtSBwkdooMvPEbEMc03IgR2wJV2UFY?=
 =?us-ascii?Q?wFXKdtYrfeJcUcShiJ9Aqp9I+cvx1qO2oUf3a1M1Bq7NDiv2tTq/x05ItgfU?=
 =?us-ascii?Q?hosVZeShx+hlN6n5LWgN+t00eCSpxDcsorkjNUsWJEJKk01rIVBH69CLGa8X?=
 =?us-ascii?Q?Q9+a4fo24CEM8f8+TGfCkBenSyVb/Eoq0hD56zRjjuzg8wOv+QVZU4qXQ/6v?=
 =?us-ascii?Q?fhGE+KZzyiFsa+zq17HKYC838tCNMwJ8vxeN4TtymGGD6XEGPhNqM5/RNOTr?=
 =?us-ascii?Q?EpvjGI3wzZ7szWv9M01+bcx1ORb4Kn0XPNkxQX51pH0PCglVTOeOD83IyPtC?=
 =?us-ascii?Q?Z3K6a7E9PJQjtrx8CDQY8d3DzMK+az9qKb1RHKOkYqW0IEWMRb4hBngJb5gB?=
 =?us-ascii?Q?YD27A+s/Cjs+KErPSAZwDF2peDhEDU6Qe5fa44yFuwUf/dD2G6K0T5BJoI3Q?=
 =?us-ascii?Q?NpxzCmOyf5wWg8pD6ZuITJ19GuTRhAda+9QcRLqt2au5qyDHqeu8fHlThnzL?=
 =?us-ascii?Q?qIW/GNh5pxAQ1l3gRv4ojyrMAaPj1WmJCWjuMedSqsUrN992oBY29NmTyOHK?=
 =?us-ascii?Q?8tghYzHfWSw3mNPwgm7Ign2qWi3ErvuY5jSXN3Z0vXblhXFivc9bgCCuyyLb?=
 =?us-ascii?Q?QbV5HaXE8wOYNbWw2GF6h3k/hT9skmld5xFSfyQcJ5nk6YBbbyJvQ45hAAs2?=
 =?us-ascii?Q?mr/Zhlc/jt51pRstXxVyq6QQEYL69IgKzDUHUAXJvHUNvXuH3VIIyJMLrUTU?=
 =?us-ascii?Q?P7JKIq8nVUxyNBEi9L/OFmoU7ypTkXzvgjeMBFCF+bFyKTzCBA0NE09hKUOy?=
 =?us-ascii?Q?i3BhxKhC8QHaR9/ObSOfip7uKmSO2pd6McVpdzkt/kGkaU0kWPV6RCB4tPYA?=
 =?us-ascii?Q?CP9iN83UFOv5bwh5/JkK+rbF3kys2KqoqnQCzAPDeAMcxR+TwtTSyDLchDDV?=
 =?us-ascii?Q?KV5TmIknGGAXaRmKNvwPE1P180JIT2H27DiFBJO+xGoE5fkpRlgj3SHxB2/Z?=
 =?us-ascii?Q?cVfSWul38u4Y5yPptHLNZz1tggFdC7v/nyqxhiMtd2o6u7BcYhtCO51m4SM2?=
 =?us-ascii?Q?XgZcjO/OSvFi5RpQzNsJsdDp0o9XDkk3/buWknTsxvCeWPRO4r1XMzFYPPAA?=
 =?us-ascii?Q?MWT8rhnfeFcH2aHrLeXBrfmZNxGnePnq1CjD10QEIhF/mxfyhci66VUOBFr+?=
 =?us-ascii?Q?wHwQe02HTz9EvwGa477/ooEWOaRd9u5VOn+6jVHe9XI/3aoJLEc9qOiii93I?=
 =?us-ascii?Q?lgTaU7nhLzeVstMUy0CyQWs3aw6I+xrAfSenLHuSbWanKkOsV8ZKM6w+O5D4?=
 =?us-ascii?Q?ITYV+zI2i7wB/lGeSCu+u9wpikpF/+wiF1M6tvZV86kMdkj+U1B2vqznUsLZ?=
 =?us-ascii?Q?oQaW0066t+NOa8Upnn950zpWMgxdoDhMZTvvNB8MyF2OQ3FrFAubCK9wcuYx?=
 =?us-ascii?Q?KGJGbkjJ7gAqyKsVZQPODxMm/yTgQ5qvleb+47ptWcJ0tohdE11LwpidiFfd?=
 =?us-ascii?Q?gkPGkjUR5IS6x7RLHm/qMDViNubP78R+sEhuxYeWbwP2ipB/vY0S?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 044c8239-5df7-4995-ebe9-08df17b81762
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 08:12:34.5199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VcjxphSWq9NnWJ9pImkp7DU1KB/KIBe7p+owpL0bLXhbYQmlkxTibvwQU1+N2Mxqr9SLDvCf/SM7fLSlhp2ehJdwiNgDsr8U8D2tHWr95QmvaqRGrsQ9877TT06N/YIY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS5PR04MB11322

From: Peng Fan <peng.fan@nxp.com>

Convert open-coded if/else with set_bit/clear_bit to the assign_bit API.

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

Signed-off-by: Peng Fan <peng.fan@nxp.com>
---

V2:
 Separate device-mapper and mraid
 https://lore.kernel.org/all/20260918141737.3023011-1-peng.fan@oss.nxp.com/

 drivers/md/dm-mpath.c                  | 5 +----
 drivers/md/dm-zone.c                   | 6 ++----
 drivers/md/persistent-data/dm-bitset.c | 5 +----
 3 files changed, 4 insertions(+), 12 deletions(-)

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
-- 
2.51.0

