Received: from HK3PR03CU002.outbound.protection.outlook.com (mail-eastasiaazon11011063.outbound.protection.outlook.com [52.101.129.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC66E573
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 00:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.129.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743122578; cv=fail; b=U9Cc3oJ6F8xwwy2bzU1LbFdmUoOAzGTE/F758xnvcejf56B9qhx9dnMIQ2Q5KxS/qwRZtFIuAybx2/PWDDOA47X4rqQvv2/QFjha0hfjUHHdAFEJWqOkU4oQSzld5DzZrxsiewY8Gn/Au8mIQ3Mj8wp/mAOB6ikNl5zujYjRo0A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743122578; c=relaxed/simple;
	bh=K1pBWt4x6waxCq6DG28ddMKiCR2URDCElBt7y9akwMA=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=YjMrYBtXjSYO2PITL1ScwhII05WlbJ46g3HDWpx1+JSVfM8uYSY9hC3/3nGL7wTi7lKOa2burc2T0F8xelC4flp5BGjkq+K0z5PjE5XGyiveq176QmAcfTGKOicm6WqNvHXxozlccuDYF6TB3128hdzEcOu0cXHbVhALPCIY4Bw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=YqFySWOf; arc=fail smtp.client-ip=52.101.129.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="YqFySWOf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l1WPdcBvF1XzLor2/K3AiIBiofIH94c8ZivCq+W449YRpy8MFVPis7rIoTCaMXV4QlfYOOtmGbJTHXBPuydSLAjUmtQcoHpq7yBSH8UtemdApVf5D4MC+MZnqsA9FLawczod0vLfHAvpXarQ21ZAnK6FL5huU2MA5OZQo0iElEdA55mvkOo64s7L3vEWRmGBCAG8fUgDlsfSmJcSfhoH9aPfnea/HsNnQLSjg79MwFaB6tthfPpKF+lFVWcwlTie97bSWC39hz5BrmbTnejkPyRo/ugVr+6fCmbSzvHCo7JL9Ble1h157xylAhtc0OBD1R3pEoA6O+xhFYSHcx9QDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oKXxdoYIw1pMypGvMof47PRy6wxjTzhDc0pYbPXOi/0=;
 b=gXDLuygkW9bqKAAPqLGUxTRHa0gn7tj0QY8jIylNhl39emiVVkWh/znuS+F90Fy9CPWIaXAt2O7HHMJumajBjw3XEX1MOw60X2utXfBsHX6BI/SQnEH+SrYKmPP+jYnNqZFsITjh4K0MjVKVa8uyPIzLv6iYL3WX9tnBrtSvezbCsxVs1Erv3+dwFHc7/pyAag5u5DPIIhwdt5BvdyJG98YlJxmyxbDoUMLPcgGN5//GQiWT7/7DsSRuFIGCKwc64YAn5FYngDJ36gjrHmN9AmP+nTlFel9cJ+2U/eJSbi6jTpRTuRYxc4nlN4MVW0seWu5Lh5oegc9Ff0N3Yz13Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oKXxdoYIw1pMypGvMof47PRy6wxjTzhDc0pYbPXOi/0=;
 b=YqFySWOf0XJvl/CFaKX6JIMuFX03aKXD/x1LBIz5SMuK9KX3cKQXEmlfG+9bHClJ5iQQ92OzMtRrBBbeHd/F6y6tfmSPKqcQMF57Y34sXodTFH0939Ozn7oLmgT/mhszHAuWAhprWSp8yIHa/ThBIPn+j2a+xARE+wa6U0MX4RQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by JH0PR02MB6604.apcprd02.prod.outlook.com (2603:1096:990:4d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.25; Fri, 28 Mar
 2025 00:42:50 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8583.023; Fri, 28 Mar 2025
 00:42:50 +0000
From: LongPing Wei <weilongping@oppo.com>
To: snitzer@kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	guoweichao@oppo.com,
	ebiggers@kernel.org,
	bvanassche@acm.org,
	LongPing Wei <weilongping@oppo.com>
Subject: [PATCH] dm-verity: update the documention about try_verify_in_tasklet
Date: Fri, 28 Mar 2025 08:42:13 +0800
Message-Id: <20250328004212.2071381-1-weilongping@oppo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0068.apcprd02.prod.outlook.com
 (2603:1096:4:54::32) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|JH0PR02MB6604:EE_
X-MS-Office365-Filtering-Correlation-Id: ce1b9f9b-72e7-4097-255f-08dd6d9177be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|366016|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Gc/JPEgUEDQUt92ey8FFhtMZ17P85uEdePnTNDYN0K9Ey9W81QDZY3O1Du2Q?=
 =?us-ascii?Q?CM5UQgCUvvx3CPM3Cg9gctf+gVPiTjB+QxgGypJj7Fp2pLDYc3I10fjhkbzQ?=
 =?us-ascii?Q?//G+Uv1+ermClZ+q1gP/vOM1BzsTNfscOFYcz7we9+qCVyMg1wTEurSthqfY?=
 =?us-ascii?Q?Nh5W/dKv13xq27cOTUmy01WVXzWbkcQUg8/EAbGom40lf3m53HkdEpD+a98L?=
 =?us-ascii?Q?OwhgLYqvoy1ITBnAiw3E9ywkcxprQIUj094CVKlFiDrfLUe40S1S8hpcfUzA?=
 =?us-ascii?Q?NaEjrLj1R5vtqNbxdLD3oYWpd9a/azyssOJA4VV3HC/1AnxaUtXOASrCiZ/8?=
 =?us-ascii?Q?eeKwLG8QVbufaQfj9o4xaPv03sAwbAeX7Ee7EOcDGhBudD3J4sP1vezPjZG6?=
 =?us-ascii?Q?Fw4DeX4ilL7PDV7ehzzp5YxfwAtWUNc1TCONj/ZwlzxuvpkpgKrPR3jxQOxS?=
 =?us-ascii?Q?5aAQdzUBpJ+fJiFyzLyk4iEgwM/e1no2R9sq049yL+Jvx0bsiw9bNO307t+V?=
 =?us-ascii?Q?o6INQw37XRyJ8N6kPvwFA4VlZ8oGmLCe8WTkAL15RKMpda0Atv/iywdiPxvC?=
 =?us-ascii?Q?MFw4EToaDp5hBEsJjLc/vID1Ij1lsayFnWWbUbdkgcJ57s4bvnnsaDDqYnZ5?=
 =?us-ascii?Q?We/FcYwom7reHjzra+ZRZaNtxqbiLsWnPpWSg2/sB5hGTP+2g4Zp5xTXt6UL?=
 =?us-ascii?Q?uJUeFegOMB6zzxSZzCle5oH6gxbV/Kx62d4gNGOJV3L5oPoHoRkz3tHLz7QN?=
 =?us-ascii?Q?E7C8RHFSm9tywBD3MjD50HXtRkqC7koQBXNXjEjQQbbc7GS9d8t1Jdne7Sna?=
 =?us-ascii?Q?Tea7ea/DlOdzyOH4apJJU6S0nCJETYvkBiFWtrgoXkdqzt9rgxyaXFBINYlA?=
 =?us-ascii?Q?XeRmbw/aobBLO3D4RQxY3sQtwFjpBaAA2/qUGIQU1AUkp5LY2YqjVVirCFky?=
 =?us-ascii?Q?efYy+vBev2hhaMUsP1G+69n2aADaGYmlhjJ1nkTyLpmJOAk079uaHGGZzo9d?=
 =?us-ascii?Q?25KJOHnW5jJGLBptwImn/+I92l60mIN9kyCrUW+iDQqJzBDBhAxP1SXQ6PAU?=
 =?us-ascii?Q?LpWelbhI20TqvoclkVqb0RE9FBTYFDF8w4mUKqv/V3EtcNJT5/VMkGIH78eE?=
 =?us-ascii?Q?ykPqElGkOQpSlb7fM+C6sZAb5dIrBdRxyejbofo9EL2Kuibs3YOa5uffmqlt?=
 =?us-ascii?Q?dNBWpQu7oSvunh1us2U02GTO11rxh5Xr+10h7Oog1k9bOO2B63DynHoDwx3n?=
 =?us-ascii?Q?tPCIC7w/TJ8a2+jy6otqxOTpmnwN+mvhoUMM+n50cH/Li1G7SB8cKEB4jVJe?=
 =?us-ascii?Q?+puAQUExcUQ5bNyW0LnhpCymzqnSMAvFwL9yfaXoun5WrZZV+2tVhPmwyviK?=
 =?us-ascii?Q?6N6RHRmnPmeuCrUhTD8OIifS2UT9kucXVW86tgIy8oCkbOO8+qhSILN9iDv/?=
 =?us-ascii?Q?QBUOIHFPh26uukKaGQHHtg1C/+J4+0tl?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(366016)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KEmcc+e3NcDOGNb8Lx6cj39DBsUOZgLLkybCx+BPY+jbSjemxEXET4fxDs0y?=
 =?us-ascii?Q?xzG7DeRKbxoaBrPdIeKvZNbx7VUrH0jz00glGPeUEt7P+2VteC7bK7FwQIrd?=
 =?us-ascii?Q?w1CQvw/xjUemmUZdBJHW6CVXadDSbs9ZoBZQ98QwD9E6qVBbC3Aun0QKpUt0?=
 =?us-ascii?Q?lYQDowslgKZl63cPB1/v9S+aCx58sBmx/Vre1z85Mjus+zpWByP2bsjDS/EL?=
 =?us-ascii?Q?ivJ+dbooiw5JOoMU/L981KmWUuhJGRrsStsFQCxYE7qIIDWuOW9SSkQFuHK1?=
 =?us-ascii?Q?AEp9ZsPFb4jAtKqoHHAqX6FvoBSwGIDkZ/Yv2BktinYJu4fxQ3LC90c2vaCm?=
 =?us-ascii?Q?PmdqquKwW3MXK+u4K0OdOG2EnYHXzk9qB5WzIozQpxmb0oZN5RFXHGcMJner?=
 =?us-ascii?Q?Gr6f5/euP6YeDIHbnYLbqQ2O0OYjEPEEhy3xN1uX9MvovwiGjwdIruH6OdsK?=
 =?us-ascii?Q?RtStd5X6kb7jpvWk3OTYHbhcD7SSXR7plr5GDWIhjH7WYQKhAJeKCCJKGvDY?=
 =?us-ascii?Q?8QE9KrHlRIgkCvWFH3dSohBGmMcXBOyBq7LGLs0TaG2xNWAz8t4Cz4qpTVl5?=
 =?us-ascii?Q?SvVtGUbvQYDL6Zkl5ZGbGgVnzGYifJyH5yL5N8VXZecOHB9/Out/n1gIxfdc?=
 =?us-ascii?Q?t+YzxFh+ERe6q+in6ryQtYQiEfw3MxfHWQaZJvsdGFSncbJqlXhbB/KJPjih?=
 =?us-ascii?Q?19wOCNSFcnN2UzVY/UVADlxsSxRS9URuitMbtkibKhWgU3x6eNT9Yxm4nlkp?=
 =?us-ascii?Q?oQuQsQ3c/mHTSDRHNC2RqN7MAzFJbCrHI2La5CdIVeuOmNcNRHYPDk9DbVYt?=
 =?us-ascii?Q?n9cudrxTa04jDZIEtX6LUw8Yn3mjVywX3SoeRKFV48/LpBvzlAaxF/6uSy1g?=
 =?us-ascii?Q?9vx6w9S429an4EAH6L8YU1bg2gpAvAW/FIQNdtwDptyf0QPR3d9hBC5H9YY7?=
 =?us-ascii?Q?bXrE3SOCaBEhFukkjdQBx1h9d/q0iHSgubgaIyUaqjXmcvLMsZrFibPj/EE2?=
 =?us-ascii?Q?zaxZy3gCSdufaQ24Y9/6dNJMhF6iebPSvHdUSHrpVaJ0M4ldDZHx1PzQJyxT?=
 =?us-ascii?Q?7AmKDHRvn4xKMUvZ7wbuFC/IvGTJiYAiMv+lP2Cw50QC3yRAUUPLwwY+dD+x?=
 =?us-ascii?Q?/Uuhvv16OZxwD0ErWH4y4u6RzEySt7t+1x84YgAORJroawch+dQxbtSVxfFz?=
 =?us-ascii?Q?Fwx83vxEEkgEmFpF8osIMtn8liVTJm3USc4HNFJQ7tH1NCOLUa/KCZN3XL4k?=
 =?us-ascii?Q?zwyykDPegiAOlHy0hEeLPBqoBYfopXaOTYjhp5DXkJhSBKp8jZRgJTYHyo8G?=
 =?us-ascii?Q?tCS5qaI0q2L0+OyIR05WQKYRWpcWYXcyqIPQzYFANvrGaTeMl32W1X7BBjPT?=
 =?us-ascii?Q?9tgn9tXY+qWn54iHc7YNHbj35/vfZdXB5NO6XI3zMb6b0Hmkp+tyhPWq5+fp?=
 =?us-ascii?Q?/PtvmTArwm9CkiYlJ+AHWZuxkawnDvSx5RgS0yYqNShp93T3bm4eV6f2ogXD?=
 =?us-ascii?Q?coA6vxOuz/rbxGY1R1tgOAmcxqyQlzu5ekj5+jTglCk5Fid+iqQywTv/XsWj?=
 =?us-ascii?Q?hfg+bCfwmIDVEs73ZGrgdhWqkj0uxcHhsSc/8mWu?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce1b9f9b-72e7-4097-255f-08dd6d9177be
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2025 00:42:50.5076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nb7lmqusNAXaIDIfFWA22pnAN9IuOGFdeefAkW4Rb/mhNo+5EP+3YOMILsim354+Wm6/WVvhl0qhi9H8BKLAPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR02MB6604

Tasklets aren't actually used anymore.

Signed-off-by: LongPing Wei <weilongping@oppo.com>
---
 Documentation/admin-guide/device-mapper/verity.rst | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/verity.rst b/Documentation/admin-guide/device-mapper/verity.rst
index cda958a517c6..9382343c99d2 100644
--- a/Documentation/admin-guide/device-mapper/verity.rst
+++ b/Documentation/admin-guide/device-mapper/verity.rst
@@ -151,10 +151,11 @@ root_hash_sig_key_desc <key_description>
     already in the secondary trusted keyring.
 
 try_verify_in_tasklet
-    If verity hashes are in cache, verify data blocks in kernel tasklet instead
-    of workqueue. This option can reduce IO latency. The size limits could be
-    configured via /sys/module/dm_verity/parameters/use_bh_bytes. The four
-    parameters correspond to limits for IOPRIO_CLASS_NONE,IOPRIO_CLASS_RT,
+    If verity hashes are in cache and the IO size does not exceed the limit,
+    verify data blocks in bottom half instead of workqueue. This option can
+    reduce IO latency. The size limits can be configured via
+    /sys/module/dm_verity/parameters/use_bh_bytes. The four parameters
+    correspond to limits for IOPRIO_CLASS_NONE,IOPRIO_CLASS_RT,
     IOPRIO_CLASS_BE and IOPRIO_CLASS_IDLE in turn.
     For example:
     <none>,<rt>,<be>,<idle>
-- 
2.34.1

