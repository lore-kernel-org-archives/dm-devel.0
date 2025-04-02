Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2043.outbound.protection.outlook.com [40.107.255.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6AF23372B
	for <dm-devel@lists.linux.dev>; Wed,  2 Apr 2025 07:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.255.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743577844; cv=fail; b=S+FRJSm3TNrHQVdp2cbkz7DJfTrn5qX7Zv1P8WbsRgEDjv924lLw1YO8QlB4QN8C9pH3Za7gCuci7QuX44+28UqfKJ4xMxg1XvdqK03c/XaZAMhU4A2in0N7TODAcn5qvLQUyCbp6Zu8K3np0WrGw82BhRJgWJTnY6p0IrL/+cY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743577844; c=relaxed/simple;
	bh=9Dfbyt/DHk0GAJtWoTqPF4HGRy0E9IMKKx61HtMweQg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QKCGPuDmzP9Omi1reGY/G00phoEyjEGxK9UEGC28JwdWaCQNMmEPytvvEd+lB02KJH1/Dk683+XuJc7mYcw+KF0bbnCdTOXwdfQndOSTnARmUja++qjadebpEshwoubA0YHe0N+boGq+w5oZPH1/yBB3SdPC2Nl+rDTZ6jFfdg0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=PIQ8ES6l; arc=fail smtp.client-ip=40.107.255.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="PIQ8ES6l"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h4Zkt1D6hvd73RTv4oOdx+8JzORnXEIQCaYnldLN54EOlYqLt3pNQOz3WRBJqCw0QFce7PY3XpQJrybURfmPL0TqHLsxl8+7aUUrCAqbFAXpTMjSEd5SQTs9X7ensqLhJXVl9P/9E5hXfSOkgBc2sMOej3Ea29bPUdg7k6b33y0AolaK3YqIAKavxa6dIFn7a+RBzf4Q7mQTrV7RNKY4U//bMbPslIV9AK4QjPYXA2OYbhOPUZu9PvsFO4TJJknMaa8QcRhBtIhLSzcIxBtvxVGNLXNfnLqn0zr6NRiFXZgSRBGGJwus0YTyV7a2gIUF2W6cenha8coKRbMP2/3Z1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VI7uOpn+xg5m9gKy43uSuB07FsC3f8g1295JsjGl+iA=;
 b=pmkS4hBT34pC85H5Amscf/hmaZoG/WwB0F9Uq60HLovmSa3PBPoTncdGKvYnT1I3L4rl+UWfMyxJU3jqoJyGMLBDsASbvxp6xRIfHBl6mIFgMwCzURI0LvWPCCa+vNrgpmKdosCem1M3MXgQTf8W2Hirs+tra8jR1Tewot9Zg/tu+SPTgzdzT8lNfOngzJfnqmA25zYZGM2s2+wpm1mliC1kr+SGJde6adOFu5I8iDU9fe8n60XcHo7hZKuVbdN+7qc5FOfakp74gd/Wseb6dB/BqjinFlzM6Wi7v+hCy/7FBDjPvrtJ4PHlhvYPgevZpsvGWkVdSyiH/WS0sRhouw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VI7uOpn+xg5m9gKy43uSuB07FsC3f8g1295JsjGl+iA=;
 b=PIQ8ES6ljfiE2hirVZk8e/LHEDV3URMb++Qpizu/Ns2R4IyTy+iBKVAZUVgBpBZApKgLJoHkXcljpSTGOtQ705WeDB9OyRh9ZYDC7jYMhRo1Vw1YDvCAMbmADX4f4rCCCwYZLAmrKOFOv6Orl5uAE9XZkLVFRsl+70cEGWK44S0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by TY0PR02MB6127.apcprd02.prod.outlook.com (2603:1096:400:265::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.20; Wed, 2 Apr
 2025 07:10:38 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8606.019; Wed, 2 Apr 2025
 07:10:38 +0000
From: LongPing Wei <weilongping@oppo.com>
To: snitzer@kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	guoweichao@oppo.com,
	ebiggers@kernel.org,
	bvanassche@acm.org,
	LongPing Wei <weilongping@oppo.com>
Subject: [PATCH 2/2] dm-verity: prefetch all hash blocks in verity_ctr
Date: Wed,  2 Apr 2025 15:09:36 +0800
Message-Id: <20250402070934.2387587-2-weilongping@oppo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250402070934.2387587-1-weilongping@oppo.com>
References: <20250402070934.2387587-1-weilongping@oppo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0077.apcprd02.prod.outlook.com
 (2603:1096:4:90::17) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|TY0PR02MB6127:EE_
X-MS-Office365-Filtering-Correlation-Id: d559e01d-39f1-41bd-5644-08dd71b57886
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|366016|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A0p1u9ZCnHxQqULbrUmfzGYfs5oGi9fzIYqqSi2r0fAEEr3OWJy2CBY5k7yu?=
 =?us-ascii?Q?B82xhf2E1hXvec6qmcposV2NzJzyOlXcK31uPMeygBcJf5SAuFmt8Eo4FPZe?=
 =?us-ascii?Q?X7hXnzqRRsQvQULRwv3FtO8bWeirqWTgPLi6TOvkRF3Bv/JBUQ81e6+iSfUl?=
 =?us-ascii?Q?PyUPIONoCp3tHN/hwNHsQJx1+prUiVxvxchD58UL6z0CwUbrgav1hm3ZrCJh?=
 =?us-ascii?Q?aF4IL366wmBWZeYaemVldJJ6hGqNP2P/uwAhtFF6CS0vivgBw3fx7rKkmsrH?=
 =?us-ascii?Q?GGNZ24LiTkq3uI79MzAqg9LPXYhnXdJqJFZfMTWV8AiFqW1v6LBLSGVSNb2z?=
 =?us-ascii?Q?kg5Mxw1Yttu64gCT07ia9m5jI9BnSBFKCiffpKgPenaq7PXcEJYpYpeCwojU?=
 =?us-ascii?Q?JWHe9SCTiXlxzAhctkmFZvzvCe1I2Hr3MU5Se61IeTs0iI8jqsDFC61GgkC7?=
 =?us-ascii?Q?kRCC1CxPYt3KUyKHD/DbrbfV4Geg9z8I+yeKx1dIoY3VSwkkt5Y3LUYyjbqL?=
 =?us-ascii?Q?Wh+UAk/D5U8NtJwsOKzYyTifrDv31BeckMNJA3i3bf99FnCqDcBmXy3GujS2?=
 =?us-ascii?Q?AkD1kQPLkfNFjiKQQN5YhhhpGbNFTLeoVVkxjtrPwjIUa1VQcbvY+hrgcSgv?=
 =?us-ascii?Q?el0hYf5bCWz92D1HaDlEYSpnmbGCbtGnaKEzrXuw3euu9r5ZJRMqhec4alCt?=
 =?us-ascii?Q?2z6EgR9KDLM+Uf/BmOd/rQGipjhlgcMBSOmrwA/CcuP8KPjoZnmhCsDIi/ED?=
 =?us-ascii?Q?+M2Ao4IxHI8o3sOP4oNNRZ4eViHbyR/i6+jhU+wNoL9g23J3id8k1tStD7nC?=
 =?us-ascii?Q?KkFswaIe34S6SDnG2Zmm9OVOshZWebcX2H5zvahay7keyWFuASG/OlfQoscQ?=
 =?us-ascii?Q?vRRio6Zp5uYmI69vH5rUWYUgvlv+SDHfzcc+87v6frFLL/rotvpz/86Jj7Nh?=
 =?us-ascii?Q?RAVc8NxJkzLTLfhUj5hi+YzdxMqozTZWsPuEWOhzo4OlhzwXc0Kx6y8eLKvA?=
 =?us-ascii?Q?0AiDxSBGncqWCIOfcj1W74Z6cbdvfKn+OexSHsYz8xeQ1IODmJ6Ug/bROfA/?=
 =?us-ascii?Q?JmvV4Bj+HeKgPScp/0l6cqFYOy4vdvndFZaxYZ8T9b+3lLdGbhXXWXvX/+4C?=
 =?us-ascii?Q?2qDMUQ/u9RQXlbWt2+vXdGkstCvUjDH8Aybz0pQVaS2SqW0jSmSqwxsx+TSf?=
 =?us-ascii?Q?atxWb5ecFPGdpmRg/34D8VhIj+YsZwND0rQx+cCfx6SrJwbK36p1kz3b9aC7?=
 =?us-ascii?Q?6CMz06nL0U0kQHTHy4km7nE6TNcVAHQpwlVPnOunCzZLWz/f/+0Mv2+M3qfg?=
 =?us-ascii?Q?1Dkh/BIwzIMkIFXAYCKOBqJ0Na5Vi4Dz7Pnhnp0XhJPsB9a8sBMVvAJsvGk3?=
 =?us-ascii?Q?Zk/wjiFL712AavjOKjM9MBkcBPEkTrOlgsTxafiXCctt3lQ62yZy7jWf0fu1?=
 =?us-ascii?Q?iQtRzotyi5y8cfotWTkbSkeVd8iDwbdA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(366016)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?E9ahTo78Ws7rmsagS8AafpuXW3tmAZ2FB133lFfvsKlSewEzy4QQsnqr0xnU?=
 =?us-ascii?Q?FB4KwGluzsaZmDupJBY2Z/BNezFDF79fQcjP9u5HhHPvlg1lrumuZyeqvZlD?=
 =?us-ascii?Q?FzbXky8kHvGxJ1WKPviSG2MlBrxfqpa+r33p+rVUyAohNQZgIN/rVAaempyP?=
 =?us-ascii?Q?JB5kaKvXCzf6khUg9FQzUFfM8jMZxtU2yANcXa3xtj1REtSBskPJfMeVclzH?=
 =?us-ascii?Q?rM4rmJIyqseQDNo1L8j8NDWvHIPURNKDJw0LrH/+9c0ycpCnt6Wj8yz++tvl?=
 =?us-ascii?Q?Nt5APXgW8TZT8v3TJTpNSHRmIarBcrn9SYyD3y1+TBdErwo1S5RhU4pNo/eq?=
 =?us-ascii?Q?/+3nOwAJ055xV4P2rqtyQTbJMs1JNQC7qKvbYRAOp+FmlgOI7y4QxhMioDl7?=
 =?us-ascii?Q?G6hMpxyfjLHPfIA7msDkQU38tQaLnOPnVTH7LJ94BBSA2BuUoxSZUp+7iXix?=
 =?us-ascii?Q?BxLaAi+x8JarykKuVgV77SMfnjEG5ScRKh67Wo3rpNWMLjh342cYmhxrqUS2?=
 =?us-ascii?Q?DxfPKTzzQZAtxGp5QetAS2WqDk476XcJ96nbpAhaDbYldaj8l1lnIaDGbgI5?=
 =?us-ascii?Q?e+gz370UbSZ0MVFwpuyyWN9FZM7Jz608U3MFaZCiiqR7bfEfZL8sQ4KQ9rXR?=
 =?us-ascii?Q?ubmcjYjNqcEHb7rXjD+JXG2M50RJhfU5RvKLeKOspSKHioZ5ZO7jPxePN6Tg?=
 =?us-ascii?Q?xgTjwYE4iak4IyaBXbPAbCG/9maUHvNROcO9G8ox37fN6epcBJF5QbaegMTz?=
 =?us-ascii?Q?9OXGfTOVlnFSkYWEvNYhiV4zSxmi/KJMUxJZ5+VT96S+FVNIwTO6Qo3RO35g?=
 =?us-ascii?Q?ZG2OAx0yUNVx1sJ/MtZfdCXREJYZYZlALgiLwXkjQPfzFUZIgO1Ls8fMxXM/?=
 =?us-ascii?Q?N9KwialZc3Aajn5OposItIEIKIYbcpe8Gj13m2Pp5jaHdI50U9/2yVCkohQN?=
 =?us-ascii?Q?SpLwU7EpQKlSoZAMFIjS/xMTYULmc7XBU61aYpQdbH8s/J+uav/1STGQDPGf?=
 =?us-ascii?Q?QeOG7+kUw1wdF6jJt0x9sSP7NML+FzDUWyUG6wDMF4RhyEmAt7Ufpuz3rxBu?=
 =?us-ascii?Q?IT2jrAkL2n7C2XbDma3d2E7RX2WnUlfKv5utTUbyM1p/IDguMhddbHZUdocZ?=
 =?us-ascii?Q?1NBIQ9AJ8bppj9Irm8E/BtGkUzT1a9zlnozHetD07pQDOw4M/oyOJJAU0sG1?=
 =?us-ascii?Q?hWaviSVEm4193AJhXvZDe3Rm3pFRsy6JzFIL2B44XAwJ9JQilbuBVxz0gvgr?=
 =?us-ascii?Q?LxnODJNRh8IAdPI0tvmDlJgVWAqLGNKA8He8nwBUpfLn5vH+Q01RWPaItpSK?=
 =?us-ascii?Q?yWmPAUpjmpvpXQ9V+Q8/KwNecQNIHkQBnW2+GnSJRx5vU9pzdkyZgyt+067f?=
 =?us-ascii?Q?yddMOh5rnNZnrUk3vB2GhHKAm4hU2J6UyNUJi7kuHx+MCSaEpRgNt1VTa9es?=
 =?us-ascii?Q?tICAA5mZZKt6rcUcwfwFJ8+12G717Xqn6tSs28gLWI67/bjOtpH3VEkqkjtt?=
 =?us-ascii?Q?NVTaD0DCxl88F11qIKKvv3IAMJX0JjixNNkCajVl/JvgR+Xvwej+kYhhB9O1?=
 =?us-ascii?Q?9mefWfYdV2nzIefxwVJ1rrfTEMBsLn6XzTPS+AgR?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d559e01d-39f1-41bd-5644-08dd71b57886
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2025 07:10:38.4295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6oYgpzeMnor8ykSuFq+7KoESt6W3b6J820TUszUyJjhu8s6cxrQmp/hPIdJLvv6f5q+Nx2y9B7T6u3SZblbibQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR02MB6127

At this time, all bios for hash blocks should eventually
be merged into a single large bio.

Signed-off-by: LongPing Wei <weilongping@oppo.com>
---
 drivers/md/dm-verity-target.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 3c427f18a04b..813d5cfc7ffa 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1683,6 +1683,10 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	verity_verify_sig_opts_cleanup(&verify_args);
 
+	dm_bufio_prefetch_with_ioprio(v->bufio, v->hash_start,
+		v->hash_blocks - v->hash_start,
+		IOPRIO_PRIO_VALUE(IOPRIO_CLASS_RT, 0));
+
 	dm_audit_log_ctr(DM_MSG_PREFIX, ti, 1);
 
 	return 0;
-- 
2.34.1

