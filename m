Received: from HK3PR03CU002.outbound.protection.outlook.com (mail-eastasiaazon11011036.outbound.protection.outlook.com [52.101.129.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA80A2701B7
	for <dm-devel@lists.linux.dev>; Wed, 23 Apr 2025 13:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.129.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745413615; cv=fail; b=dbrOA9k5vJMCIZ/eivkmQ0SzoI6ZZgzUl0bdI1K9hSmGjEcwbyHb1qBXJBPPGUW8BMeSaUM6XJYpVc58/FumTc/87pOkqgLrOyuZOjlvQ7fYKlztnnl++7vDNill/XuX7mkrn/MFTPWqx2nmwvrTA9lAW0uZ16TracURxYPALBI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745413615; c=relaxed/simple;
	bh=FKrGeQE0R0kPZdeDaM//7j8uSq/LgmKoex9lfAWYvM0=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=Xo4JNqU+94OBLf/EDlMNWPaGQZmtSJ+j1fsY62f4qRu6oxx8OkRpkTP7MvZUApHSFjnnzeAqL8UyOan875VaJ4EuYRO+SyyQ5SCJzFEVG1tYBAfqzObGgezkOJ3ACQ6ZpDeG4v6i3T3Pi87PVsgkm9mhQ97h/gpPVeMGKB1flCs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=WSSGfLvO; arc=fail smtp.client-ip=52.101.129.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="WSSGfLvO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dvLBI1w1nUL91ls/xjB4gCO9azyyoS0KQkrftJAkZ6JkEPDEa8kAXlPcsRPaRWUqVh3eHNuqwx/0AZSaudggqzC1yTZe7FDYKuAQ/RqxL8ERe0mCn1UTgae3kY5rIG1YsAC/DmryM+JZQhnM1skvFxFvbSFy8Gspb7pXBhIm/3PGPKBAVZCUyQ2FxmftYDzBqTzdcdUwOf72DCnUGGk5DhdIatlFJpffDaBIuv9f6X8WWjtQduvsKMyMffeR9Pxz+/v6x/Z9OVbtv/HW+qE+q5iglQKGbrW0QPRPWW3p7SYuKGCkruekR2/sUUo9f9W7m1xt+SVYLzwBWoOx36L0qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7L9NnROr/QkNEA8wJw1P650Y6Cl1U1f8uCq1XQqYiyg=;
 b=yJHR04sSDO0MYZaEfrSB1p9VWzyDpBqjkrdbjFUFLRJ+5ken/mawH+f15++0U6w6snLY2FPKvav1clkqaQXYMWRp5h4lBnhvuXvwTTD237Zz4phN9ZAS3RPseAZF+9cgC4H3s3aTcaqp+aZifs3XDUc/qJjBsn08vwjajhZoUFwN62asq1D25esuJ1rMsHEn/bVyC95sIx/CxwRw0ncrTc4AHZ0AaVGDV/p52Yc8urayho1joUckXF+lSbgnbrxHAofsgv9AgsLA7/wdR9krQqtCbxNq2bvca9o0py3a/36SR7d7hbzXSBC0X9BaOcLatDnKT1WCdKs85z/rCSdXTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7L9NnROr/QkNEA8wJw1P650Y6Cl1U1f8uCq1XQqYiyg=;
 b=WSSGfLvOg+y8X5R/teu/NMACRLCSbTvbi/zltMEb78SfBG89Mh+kQgxmhQ9PyVBBFz6fjuGcOLYxy/wBkdB/1CQcYHoC1N3MBVWfGvKf2WcADAW/ykQvhWBcfYrdEXS5a5UwjItJbpQtaORVYQT0LbICE/B8HCOkTZ1nqdrJ97A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by TYZPR02MB6711.apcprd02.prod.outlook.com (2603:1096:405:2a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.27; Wed, 23 Apr
 2025 13:06:48 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8655.033; Wed, 23 Apr 2025
 13:06:48 +0000
From: LongPing Wei <weilongping@oppo.com>
To: snitzer@kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	guoweichao@oppo.com,
	ebiggers@kernel.org,
	LongPing Wei <weilongping@oppo.com>
Subject: [PATCH 0/2] Reduce memory usage when there are dozens dm-verity devices.
Date: Wed, 23 Apr 2025 21:06:14 +0800
Message-Id: <20250423130615.24793-1-weilongping@oppo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0129.apcprd02.prod.outlook.com
 (2603:1096:4:188::19) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|TYZPR02MB6711:EE_
X-MS-Office365-Filtering-Correlation-Id: 90f583b2-107a-4a67-9c46-08dd8267b481
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|376014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6SLBhxKWerqhkBGNObkGmMkkB0/fCZ+TzP6fCgxDlwfVcgKpcB9nA5cCVTsO?=
 =?us-ascii?Q?jjOSMzMPGBirBo/tg8s2BSEWAwOVTMA4QRlscViEV+pmuDriMho3LGNuS9aX?=
 =?us-ascii?Q?uycHbX0p0lWhqWJ9a5ewRWHnBC8tRO/r6V0RSm66iIyEw25KgP5n8fh+Mmp8?=
 =?us-ascii?Q?M80rJ94tqDRYLHQuzxQOreGmJH6ZFFVbNc91rJGEBPhLYPnmfaZwr5LWv30H?=
 =?us-ascii?Q?+BsHU6fjstD26mX+twZoWlJA0YCvTihPGEOYbYDIFWhTlCUq0pInGHOLGtsV?=
 =?us-ascii?Q?YirQzr2CrAVnHNWFRcpEL6+48eVk8Q5CpHZ60HVCA0UOLgDxt9DJhid2/GfO?=
 =?us-ascii?Q?rXgGjOkZqwf1OSphBktqg9/xJ5ZqsAkoxBKWMKEA/VO7HQunUb+YNQxMWoqg?=
 =?us-ascii?Q?RI2IjbHbzxcC7PurJJEmWzfqftAZlFELhbhZ0BhddTZpE5UyHTxbi1TmFG62?=
 =?us-ascii?Q?SuoWn2fYI75Htpca0TG9SvBkIjsWKWmXAiedkg/tjAIySCZ6TE7vZ5sIwaGW?=
 =?us-ascii?Q?2nPlgEdG3aMdOUrFNnBh/rMgugbOcJBdrELajyqkaCM1CE0dcCRy6ivEuus2?=
 =?us-ascii?Q?//8fAw8j/fScT7dIw2z+Y3oBPZS0HUp8tdm7WLCd9jMI4LCMmxitMPpB+Ggh?=
 =?us-ascii?Q?HGrAM/edeAeYXnmMzPfDqjYUKizqCoNT3312A/jGhMyEHNLyd4Everb18tZi?=
 =?us-ascii?Q?XBH1mJvhuGrbplcNv2OScd9IKdwdh5uUb9WOnY29nPu0yfEFYdKtHNd6lpQJ?=
 =?us-ascii?Q?VjI1trhv3HlR1TtbGnFWWkn9f9Jh3zQJY7bu6bF6hV7YuM/MjbOH6kppU1dM?=
 =?us-ascii?Q?BFS/0YvEaQIgVNQ/gLi3vLEFEbA3k/q87v+T13NDD/GEOz939tp3lYvZbliZ?=
 =?us-ascii?Q?ob+zeHtZH2C+b52vaVRxRF3KRfRghNLonlEFLXKp968fMFoQ5UOExHLHmdAZ?=
 =?us-ascii?Q?mI5domRAUpRGSl6KzpBAWWhOC/mqwSuUZavi2j1ISx4eB/3R1VIGwWLcWx/q?=
 =?us-ascii?Q?QJ+XqkpSVWBxnpg/bLMxDUucJ/8tPnug2rHnLnXY4EQ0kYsy8RIsHaXTqkd5?=
 =?us-ascii?Q?uKbs/tqNkvkN7H50CkC9fD9Bv50xpQDIi3oL8A95oiBjXL9bJlWMRth/vBTr?=
 =?us-ascii?Q?iY5n67LYJpkTKwPHFk7k/xJclvDOxzFh02pGc/f/kq3yrhJ8r3qLvohzhd4l?=
 =?us-ascii?Q?5nsjsJgdzCR7tE980UH9k+wGo1tR7ifY8AoyiP+0eSYAtlTatmEh1y0fql/a?=
 =?us-ascii?Q?We1th3Cl5Av2h+Ko1YUlBsUsMpJePMMSStYhySgwbdYptsOJow8805mKFpOK?=
 =?us-ascii?Q?XNO2t7M2xA/PwcoPmGBOR4Oq72FN9dao09MdfGCkTsVNFKiuNcl2OMqVUxKy?=
 =?us-ascii?Q?NBho/Krxmw68fQXn7BOhXlcJMhmFjxkJCqSSCeLHDcLzNfphYJaVDyffGiJN?=
 =?us-ascii?Q?LC5VnGBfQvTCehYgf9tpfvCc4jTgeIHE2bI0AkRtSbgiOtWkBgfefA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(376014)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XjENexwPB8vPFf1KQy/0OIo6PfUOiX3SqqtLSqZ5w/sU00aWvrCMG1d17Xsh?=
 =?us-ascii?Q?XBWa6LcWeYkBtlYr7BgjnkSOv5tdT6kUkCBHQQkgyFZQYmB5/b0CAQZc8W7j?=
 =?us-ascii?Q?a4GuC1+HhJYXWawyhSfedc9GuZgCme/P5gqR2K+MzmSzWZPA9mHzi+bAjBmR?=
 =?us-ascii?Q?J0wg0Zr7a5hXckIT+Bb+v2arvJTAGisDuqJooIgUY/QCI2pcmTkX2+m91i7m?=
 =?us-ascii?Q?+aN6FXIGgdWlClEVSfINHVGUL1CyepFj/0FkzNUMYsZVnXds9O5G+tZz1m+g?=
 =?us-ascii?Q?EbOp7zk1vYpy4DJM7IesIAwGKlJ39YZYKIB/mKoAJa6/ICwWwNrwThXEj4bM?=
 =?us-ascii?Q?jrGTD9Sy61P9hUQvHOM/60n7ZA41nTWby4dAcvh9VzMnxF+ENSkUb1qoUd0Z?=
 =?us-ascii?Q?4V1PeTz7fU7q4P35QLTdqBBkospL3tsEJGaHu1SobaFmXOmijQeb01lgvVkM?=
 =?us-ascii?Q?Ps+1M+eUa4E4aKvfYR5MNtTrz0Ay11OFUHFB6Wfk6XJ4OfxIMjz4PSyOjfvm?=
 =?us-ascii?Q?2pmdHjR/KkinF41vQy5MDTXvZpsfinig5rJiXAGgeCFV01If2NtCJky8qyC3?=
 =?us-ascii?Q?H8hxjaK1nNE5Bs3mAbWDrz27/KVThk06YKASAH+Ihtsc8DSGwDfbGQCes/QW?=
 =?us-ascii?Q?3sBdJ6J9jl1p9ii/FzOuY5KnQG5C5ZQfS+dy4sqnbSkQ+YXPZCIA4i95iEcN?=
 =?us-ascii?Q?HD7lLPUg9bKoP/Uen265PyfTN1dV3BlC4HlDibTB7bueeeTW+GSlWbrFKfnX?=
 =?us-ascii?Q?DRFPfoIOAl3WTDsjPwyn2dJgXV54Si8CM/YGlKPwOFqgC1rbOny4UgxWjy0t?=
 =?us-ascii?Q?LWrsCfvhOfOY2ASsAAQb9CJ1fmQLRtFUh+H30ApS1jwR37XZQjkQPRnFpQG0?=
 =?us-ascii?Q?j8+fAT8qB9VRnlyYgWHyKWBNCkuoLWbpMEITnOFuClnhk1XiatLjK4l9EolF?=
 =?us-ascii?Q?5MYQcfFZmf5teZX1Ls4yVjoSxZlvHf24dxhjV7F30M4q9ZeXlWBB2KoWuH2K?=
 =?us-ascii?Q?TNPJFW2yZVuz4M7Xgj6mq/XBTUMuSDakVBTblxBC0qbbrax16V/kCm5bj3za?=
 =?us-ascii?Q?EiXPwbph4DaqIy+/v4eQ2V0TCBnyApMo+qF7Hb+1gHuVPgEEux2roEXPP51W?=
 =?us-ascii?Q?bw4RGfPwWtSOtQvaAIHL5MS6a62V5CqHXSmyh/3zZUHxxii6U3COAAfsi0v0?=
 =?us-ascii?Q?YycvDZDAwq7TVsVjpKpzZH/wEXbK0KvJ3AsDSujB/nprx0SeZpect2+tWrwU?=
 =?us-ascii?Q?O97nstr9WBQNpPO8rhWHdb8eLnzlFGOvDWgSTkZZw42J3WhZZcBj2MbgPT9F?=
 =?us-ascii?Q?LfTOoTtSFKddBjb+xEuAWZZv7lp3nXo0GPCEKMsuA4Ch+HLkGVnYKXlN9C9P?=
 =?us-ascii?Q?zx/MgqRzuXVm46L/FQW2WpcOey7OtT9lebvcgoLlLzNrzGV7v3g69uXJRi8j?=
 =?us-ascii?Q?Uhx+RWbuSmn7pEOuEj2+0JfUBdqx86X55tEnCLhhDupJA5Eg8kJlxz5PGxdH?=
 =?us-ascii?Q?2OY680V5cU2V33ZlvmoERV0gwffUkRbGuC7HX4DxcIRv6sKzwOsy4eFwg0rG?=
 =?us-ascii?Q?WdV8o7siLfft/Mk42EfQHHv0wPpcsLqGdOXuM3bR?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90f583b2-107a-4a67-9c46-08dd8267b481
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2025 13:06:48.0968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GKU92mE9EyrgerFPMgx0rRkNhxmr4T0NWzNlz8tfbRtvIb0u7DstlEawyNB2hk1jw3DX4+dfjnfysuXbbjSbFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR02MB6711

# Before
# cat /proc/slabinfo | grep biovec
biovec-max          2159   2173   4096    8    8 : tunables    0    0    0 : slabdata    276    276      0

# After
# cat /proc/slabinfo | grep biovec
biovec-max           232    248   4096    8    8 : tunables    0    0    0 : slabdata     31     31      0

LongPing Wei (2):
  dm-verity: all verity devices share the same dm_io_client and
    recheck_pool.
  dm-bufio: all dm_bufio_client share the same dm_io_client.

 drivers/md/dm-bufio.c         | 29 +++++++-------
 drivers/md/dm-verity-target.c | 71 ++++++++++++++++++++++++-----------
 drivers/md/dm-verity.h        |  3 --
 3 files changed, 64 insertions(+), 39 deletions(-)

-- 
2.34.1

