Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11023122.outbound.protection.outlook.com [40.107.162.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25801435535
	for <dm-devel@lists.linux.dev>; Tue, 28 Jul 2026 14:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.122
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785249302; cv=fail; b=T52oUT159jXLXe1EcqqKbK7AWFlLBcBXAbd4ps2P9AtIQUvLxyivgLLGdoOU/yg77EhxmQfN+dJV+MscS+fgXipHOoUQv+wHitWqSMs+sMU1FgRuQJLogKoumKvdFsHScZlMSbqP8l+9LRFgJZgPYZGZw+RMRKEnKG5MHKav+w4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785249302; c=relaxed/simple;
	bh=/3jF7hNAZ/Io16W1M1uNTPyoclWW8gWLvMkXC1jq4q8=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=d1HaxqpPwK0ipHtVgZKwPb6er9yhSlwuw6hrZmIqHspqlBG2mF5OYQ6rO5/vgRORsHGTRW9DXELzliDkzHPBGgd4MwEvZMGRLAV1fMKHzcfAy7uSQE4MnUTbDlTkH4A3xS03AYWgamphjeOnFZrrJG6f5+Uc6sYOY6GAos9nBks=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kuleuven.be; spf=pass smtp.mailfrom=kuleuven.be; dkim=pass (1024-bit key) header.d=kuleuven.be header.i=@kuleuven.be header.b=TkeHW5Yu; arc=fail smtp.client-ip=40.107.162.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kuleuven.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kuleuven.be
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kuleuven.be header.i=@kuleuven.be header.b="TkeHW5Yu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zNZ2AgzvNNtja+SlfRtxhEBU7u1WoH/49RDfAEPE1M3sXEtdJhUyj3xUt4/GkyrT3KvL8mrlg1MnHSbLZH12CXVLjL0MoxWj4p4PFwr0XPeHeM0/dgrzNwLdkYvWcOCg/tPFDJnPsF2F2v737PHxD7HEUYoFBZWK0WwseenqAPQc/5LYEGF1u3m5CH3/sEYeUr5311RTHs/5X8As0FFYa86ZIj+vMxafOs7P1QVl2d7nSXKCP04r48kCxZ5du/m/KP7dznBRacC13BWuj9PDlD5iUp7fNreMHqUhWXGKTgoC5AlWjHwi6jBZUOL8CDTQDqHmTZQpUaj1hbxhBwm9Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pvWHs/mQHI95nl9jDF2l2lNO90bdroEj08eD7nWRgXY=;
 b=ss6+oBnBHBkuWmPDsvhD7myBFyzcOJcmUnOi4irffNA63Im71/hHSmWKJiRSgjX46lC7nDT3cRaMpbYckr/HtmI8ulGbZceZWrszGYqYLIN4JSgsmkr7VIsFjZKviIkHEtGJspiZzoIn99hxn0wZlaVEba7XjpsAb8xdhQzNKeJs+rgsgLxg/8kJiYo5WpRyoBHQEB/qKicxMcorg+506uWCW/gwn5tF8Cx6xFkabo+BaMD7bbZPmqlP5Is3Up3FJQWyDn9cktybJ0Xzh+S2oZGucafX8Cp11nk0Q5FOGby334jtJGUgWL1eR7PVvalVePz0O67tfenRv1P4D9oEcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kuleuven.be; dmarc=pass action=none header.from=kuleuven.be;
 dkim=pass header.d=kuleuven.be; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kuleuven.be;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pvWHs/mQHI95nl9jDF2l2lNO90bdroEj08eD7nWRgXY=;
 b=TkeHW5YuMBoIluYYAF2PNbXptyMFESuLe+OsZPIruVPJnnmzkZMJ79y0D5BWY8ldsX3ShkMswnmpo9asB0rFIbDb/GMZLpJN/NpYrWGHkrSmz1dxDBR/6Ziw8EWIsQnbXT2BwMshKwXEUDzM/2k/F1l7us6AiIwKpMbwkWryEHo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kuleuven.be;
Received: from DB3PR08MB9011.eurprd08.prod.outlook.com (2603:10a6:10:431::12)
 by DBBPR08MB6314.eurprd08.prod.outlook.com (2603:10a6:10:20f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 14:34:55 +0000
Received: from DB3PR08MB9011.eurprd08.prod.outlook.com
 ([fe80::f6d3:4f5f:88a2:e500]) by DB3PR08MB9011.eurprd08.prod.outlook.com
 ([fe80::f6d3:4f5f:88a2:e500%6]) with mapi id 15.21.0245.012; Tue, 28 Jul 2026
 14:34:55 +0000
From: Shukai Ni <shukai.ni@kuleuven.be>
To: mpatocka@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org
Cc: bmarzins@redhat.com,
	gmazyland@gmail.com,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Shukai Ni <shukai.ni@kuleuven.be>
Subject: [PATCH v2 0/1] dm-integrity: replace forgeable discard filler with a keyed sector marker
Date: Tue, 28 Jul 2026 16:33:49 +0200
Message-ID: <20260728143350.44279-1-shukai.ni@kuleuven.be>
X-Mailer: git-send-email 2.53.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR09CA0024.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::12) To DB3PR08MB9011.eurprd08.prod.outlook.com
 (2603:10a6:10:431::12)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB3PR08MB9011:EE_|DBBPR08MB6314:EE_
X-MS-Office365-Filtering-Correlation-Id: 7eb1cba6-a681-4f5a-f889-08deecb5649d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|10070799003|786006|376014|11063799006|56012099006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	JDdrEbMtQBVbjBLbJwEQ7lixfDrz82Dx9Zyi2FVQvAhZBZBO9zMZRliu3snn7tbFn50rGQhytwanpf96C8qPtiFm1CfyRSyMB/mNXZIIbF1gMyanzPNT2oAfYAgPJoLTG7ApVaf1fhtk095kUIlXZA9xb6cpQeTiA9kh6TWDJ6MGXWnv/YAilSy+bnAt0R4VguDydxj8RDgNJ4DAKq639BHzvgbvwoKyqYV8zlLQWEqPvQrthMGJDKSore3fAZdygDF35cDi4k649IpfoX1RO6kCOqOwnthZh0Nzf+BD52dOdqzRhq8bZFUy4eIa0v9zYr7zblSFkbVUS6oFmDA+VHvZA6gKpKGQVyd9agwYrK6FqYqbHKWvrsz7SZgCm00SkZ6mlAjOLjkpp1K+AMqpz4vbYKpySseaoMEeZyS8+oTPGW+XX1j6ioJLd++zZYe9S9IPHuf0IZVN4ALwL9D5z+KjRvv5FO0qS7QXn73jwqabN4oVNLOc9ZOEGGLH3ceqcVK05GUgZp+8aTvb02gROZxjjX5MSy5mRFRVVKgG06TB1xEFynq1ussEwP5KalZCxUhPWbp/N58kXkK0ShMBqMmiSHHVaPFIJrwu2eYyXb90X3uuKkqZ8Mt1URhHvv3VJ39ArcsUFjWvmRmGUV/YVumm0M7DB4CzXj9S+fZsXCs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR08MB9011.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(10070799003)(786006)(376014)(11063799006)(56012099006)(10067099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?m3lXrAne7wuCO017j/ZbwrOhftVD1stHqWHsn/1Nz+fWKUlMFAWNrjRpb8SU?=
 =?us-ascii?Q?vT6Jn8ldrwzxb0jrXw2WKJomlt/d2p+vFwyF/augsNt7GP02fEXEA9foil1a?=
 =?us-ascii?Q?/exjjy3OM3LP2aOT+dMWgMEU11/gomS8AL9yV007lLG8bPgjadgKt5eix230?=
 =?us-ascii?Q?gdWbgr5+JG221xSjM6RJ4MUV4Izp3HGiMo/XjG1Sr5mN5yhZuWdPwoWc32d4?=
 =?us-ascii?Q?oB+iXsQXjlSISpId/d6hB2Q4trm3dcwOaqk4T5YMZf6p1hmQ1o/3MmnB1LKm?=
 =?us-ascii?Q?aVjqDLH6CClMWte59ro0LnPogkTe1OzBfPo348eNzYy1MJAshqrDeILBMH3K?=
 =?us-ascii?Q?Dlc2d7tWf1ro/+rm6OH/XW849rng3lM3k9x/fT+IULHm6oe8zBiCF0rI5BoA?=
 =?us-ascii?Q?usdFXDaxiWHfJG7VRwH49v8jRcm2jQq0cgII8sDySzTxuDme+tzoq9jz23hD?=
 =?us-ascii?Q?NUxgWRoPzZmtpdqqfFJ0LZ82u66VTVPplzgPuSUjnNJ1uLiYcutCQw6T9MFM?=
 =?us-ascii?Q?E4ir5iAVa9mqtHd4HpMJvl0ZCZXoIdBF4N9/Ab5d8Iijk4z15ChM+Wi2lUBN?=
 =?us-ascii?Q?FIbJFKTZyNiw7t8RmrTENpe80dod31gCyOC/38Y8vs7T/EVUEd02IGI+puhc?=
 =?us-ascii?Q?ozhHYc1D80UUSFTHBxS3s1KX8OuuG28/XTLOt/lf+A23ompuClhlrugejzLg?=
 =?us-ascii?Q?1JGm0qUBSXtJ+d7R3w62KKjcomE4MBlQ7/dKCmar9pHSQx70U8Yol00lz/Uv?=
 =?us-ascii?Q?F6HP81kEYynCIT1HmlnSHxtePKMlGU0fsFy4x1LgWMhEex2501nYtBIiTkOO?=
 =?us-ascii?Q?0zjn4MoNeOeeFSvdvETn1To2RE+eW7RctoacrsXG/+5lIp+1KPje+WVxHfTv?=
 =?us-ascii?Q?0eViSJqWGQlp4IgRo+ayE7MbpPo2jQozqNtngGEkey23tW+1lQvLs2g33IJY?=
 =?us-ascii?Q?Fdr+h0SUGRkcynbScoDujPHeeG4lnsldIPkiAVVD6X4HUD9Y9/R8fDY30M67?=
 =?us-ascii?Q?UeKugKtV4jzVsFYuy5/mzBShxsnmjr+x2e1lVUELx/XUltOACvf/Yxpf0wOW?=
 =?us-ascii?Q?lEvRsdZH5P56iv65LZPw2xN/lfsYa8zuQ0tYmRXyZZhKtv+2w8POKgP9CcKN?=
 =?us-ascii?Q?quRG2mX1e2owjk4h/r5CQ03GlHgRYnLuwjLeaEZzggJB3iCbOOoIw4GcSfQt?=
 =?us-ascii?Q?7ajfg9qgMMjrfFQQJ6JQ+5TRuprQkoLE+DYU5DTm7fWcPKCG2dmKRPuv0Ac4?=
 =?us-ascii?Q?i4R0iY6/NAlXrVpXK3U5x6XVzs3CZkbsukU9jjCv98gVG6NXxbymUccE1u46?=
 =?us-ascii?Q?Nto6ku5paGlwwtTFbsolfCE0X1B/0G6PXEgvpVyYC+1PSpgeTVhGMmCk9wwo?=
 =?us-ascii?Q?JqSnKpfLxVtBS9tEpDEXy+4O0m28eBFyjF0AAQgA2wqxrWe1IeLUUINQNJ7V?=
 =?us-ascii?Q?5tx85+kXFEVYDNmpBNLXVEPLs8RRmMknsBWzJBP+J3i1SdEN+536QRx9tzIl?=
 =?us-ascii?Q?tIaSgdKkjtZD2IqG/1xOcn0uFPBmfRBwpa39pgDxVoqhFAW0eyfHsVQ1V5Fc?=
 =?us-ascii?Q?vWlgSarEF4biI/nvuNYN26LBe+QyQ4GsBfh9kTTGXG+7CHC1AuWLuZlZtDJ8?=
 =?us-ascii?Q?na3pO7uaDs4wjg3BMvl+VEUG1euUry3vTgbWeJ+dBgpxEkp7iXcUyAen23XX?=
 =?us-ascii?Q?Zz3vw6G3dGHlS02rcoEPVkHZstVOBJK4PhWef5zzjSRHtfIFt2nwwf0ZqdGn?=
 =?us-ascii?Q?QsYS2HWUnTmt6uQALiJx7dAbbiSoFwOd20ViR4+Y+Sm74bwwrVea?=
X-OriginatorOrg: kuleuven.be
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eb1cba6-a681-4f5a-f889-08deecb5649d
X-MS-Exchange-CrossTenant-AuthSource: DB3PR08MB9011.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 14:34:55.6047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3973589b-9e40-4eb5-800e-b0b6383d1621
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CZ5TkFxPcDW7cKIk08OT5LPJLBvqT3CC7T4cTMMhQZ+teFHnGKxbE0nSCNRnWzOVyVj6saOIjRusRh+4OX2PPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6314

dm-integrity's discard support has a keyless bypass. When a device is
opened with --allow-discards, dm_integrity_rw_tag() treats a stored
tag consisting entirely of the constant DISCARD_FILLER (0xf6) as
sufficient proof that the corresponding block was discarded, and
skips the keyed integrity check for it. That constant is public and
needs no key to reproduce, so anyone able to write raw sectors to the
backing device can stamp an arbitrary data block with an all-0xf6 tag and
have its contents served as if they had passed HMAC verification.

The exposure is limited to dm-integrity's standalone cryptographic
authentication mode: discard is only accepted when internal_hash is
configured, so the combined dm-crypt + dm-integrity AEAD setup, where
dm-crypt supplies the tags itself, is not affected.

v1 replaced the constant filler unconditionally with a per-sector
keyed marker: HMAC_key(salt || sector). A real data tag is
HMAC_key(salt || sector || block); because its input always includes
the full block while the discard marker's never does, the two cannot
structurally collide, regardless of block content.

v2 makes the fix opt-in instead. A new "allow_discards_keyed" target
argument enables the keyed marker. Once "allow_discards_keyed" is
used, SB_FLAG_DISCARD_KEYED is set in the superblock and persists
across future activations.

Changes since v1:
 - Added "allow_discards_keyed" as a new, explicit opt-in target
   argument instead of always replacing the discard marker scheme.
 - Added SB_FLAG_DISCARD_KEYED, a sticky superblock flag recording the
   choice, following the same persistence pattern as
   SB_FLAG_RECALCULATING.
 - Restored the original DISCARD_FILLER-based marker as the default
   behavior, so existing volumes are unaffected unless the admin
   explicitly opts in.
 - Documented the new option, its danger, and its formula in
   dm-integrity.rst; updated the status-string grammar in dm-ima.rst.

Shukai Ni (1):
  dm-integrity: replace forgeable discard filler with a keyed sector
    marker

 .../admin-guide/device-mapper/dm-ima.rst      |   7 +-
 .../device-mapper/dm-integrity.rst            |  13 ++
 drivers/md/dm-integrity.c                     | 122 +++++++++++++++---
 3 files changed, 121 insertions(+), 21 deletions(-)

-- 
2.53.0

