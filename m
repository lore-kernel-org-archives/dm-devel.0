Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012020.outbound.protection.outlook.com [40.107.75.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624B31482F5
	for <dm-devel@lists.linux.dev>; Thu, 31 Jul 2025 08:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753952065; cv=fail; b=sR/KBs2ZX6+Eh5MqwZ3N2HdSmztKkWVHB2rJl5id5t81Xwi9q9yBBf8J98I9P2xBVxIt/z415HzixlEnvYH1h6xaOJAkah9iQJotDCDeQMGOuLvVZCJz6Ry+xVftDt8DbmqgGiDtlDfvGiH73CR1enZzyB2bmS29H/H4IVY+U7s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753952065; c=relaxed/simple;
	bh=E1XNRcqmGwjquetCd1PfIIPigVEiJP3OMvjEm5YPWhU=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=lS5HEMUzMUWYK8r7tniuGnXqW8vvFCjpRuPRJzYIE8iQhGWDQdQEGbezNZ70jc5iWWs4cqenE0cU8kep12cftktF73nGUdBeeBCKS5lWMSxIKf5vtqWlsb/3HP2cU2MaHibunXY0oCtr5yvY5VerrDpB6EqEiGHqEZmjfl5GxOQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=Go7vGc3F; arc=fail smtp.client-ip=40.107.75.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="Go7vGc3F"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WL8No9+VbzMonHsjEsd6RLaI2fIkNRk0nyg7WLK0Oojx13aGV5V+R73bVvAMQUTPl2yKzyKUM12oqpFyPQ9KnRW7oEsGecRfZHEyoCoqX5YzEpB3isldoTWAhxMNTEdz0BILwDTD6ZsPdRIQvAwd+CZGtkAOmIsRX9n0q+mtNmSHYXNeiZ2xMXrRfwWXTx5hX9/pNsatThnXsr0CZDlQfMLdy/rh9Myt4OR+UT/0AdIuhDBM2EnyR52YRnnsF3CM+SFYQuUeWsJF7SfrXNgn04RXQc6WcvNeSv/4kKBUdg2F60q3xzpg57nVvdtaeo3DfIRSI3myWCWzrBgtfeW7gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u842IydEHEZctgqzryl+0pcQrQzQGyhJSHO9N1/p558=;
 b=XGabJrxA0KfVh1hzV1rzkrvBmqsE8LAdzRDW/jnkgRjbZFxczzMHyAxVJ47RqHM3NuS1FGtUmgCI44n8n2PUFSAqRui+aTP5QARCV5tJ71yog9cyyFpBTZUC7tS8e9SazG626hTKYnddC235CeHQb0yDCM6Qt/Pa+ttB/sXj6v78fn5FV+bhdHqXvTXrEtJF9GhXuCCq5na0p0HPTMeM+u12UEyJYt+SC10IVFRkrPJC95O7hdak006Fjpcw0BLpks479b2nXPnpdN57un7RIA++x5lVT96R1EhuUe12ok2H5DXo/vApBbMUhq1tTxVMs+0ge0J7rBkH2e00lUjRKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u842IydEHEZctgqzryl+0pcQrQzQGyhJSHO9N1/p558=;
 b=Go7vGc3FHj3kumPhwrKpPuv4tBxdeKGBl/wH1Ri6YyImTi12sZuEFc7UEj1U+AqEXDkjyis261g81pmrc5to4co1DGjIDlaQ3JV3kbNVrtuh8raiVyFnXOfHkfqpe60nhO26YYJQn6Y3VuYHidfbx55OmXu0R6aBXmJ4mC7cDn4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from PS1PPFE5C9D9891.apcprd02.prod.outlook.com (2603:1096:308::2ae)
 by SEYPR02MB6578.apcprd02.prod.outlook.com (2603:1096:101:145::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Thu, 31 Jul
 2025 08:54:17 +0000
Received: from PS1PPFE5C9D9891.apcprd02.prod.outlook.com
 ([fe80::e3d8:6cd4:4818:db76]) by PS1PPFE5C9D9891.apcprd02.prod.outlook.com
 ([fe80::e3d8:6cd4:4818:db76%5]) with mapi id 15.20.8964.024; Thu, 31 Jul 2025
 08:54:16 +0000
From: LongPing Wei <weilongping@oppo.com>
To: mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	guoweichao@oppo.com,
	snitzer@kernel.org,
	LongPing Wei <weilongping@oppo.com>
Subject: [PATCH] dm-thin: update the documentation.
Date: Thu, 31 Jul 2025 16:53:27 +0800
Message-Id: <20250731085326.1976997-1-weilongping@oppo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0111.jpnprd01.prod.outlook.com
 (2603:1096:404:2a::27) To PS1PPFE5C9D9891.apcprd02.prod.outlook.com
 (2603:1096:308::2ae)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PS1PPFE5C9D9891:EE_|SEYPR02MB6578:EE_
X-MS-Office365-Filtering-Correlation-Id: 480e9424-c799-41a3-d03d-08ddd00fd47a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|1800799024|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?31Jfqh0WHDrHDUh9BavQALfBBdS5ZBdBGJjyvRJ/L35aT4kghrRZhMsM/nag?=
 =?us-ascii?Q?p5lBfqigLU+WaRb6m5yZjaM/Iai3y395ISAu5VZi5LilB1GqFpN1Jatpbfdf?=
 =?us-ascii?Q?CFBM66nYGWu/6ggYD5ZUm7iDiYwaI24Gsv2lvSqlckzGFvpet3BUBzEmsvqy?=
 =?us-ascii?Q?L2mtaxlWMhc3iweNfPfL6zW7S45JhEdaHspwyfL3qJgn/ptOKvoSmZUBdrbM?=
 =?us-ascii?Q?3iJ4GEp0PhY+2W4bOeh3pF6bDMFFfvv+2Jqhtg8U92/ANIB5tWhoM2rTH/xN?=
 =?us-ascii?Q?CwkCBcOqF9Sea5c892SNQyPGOnkf4htfGZKuI63TL1z0cK6A6NRsfzh0On4N?=
 =?us-ascii?Q?FvpuaUiQlcJJoAGJH3GRl5r/RQ15X28MM/TRfL7EWm3pERst+1W7mkGYfIyG?=
 =?us-ascii?Q?kUSpTzGM32gxCQGHhBwT8gtfTJL8rw7AradQ605we1uteeyBgIvQVjIJn4Xm?=
 =?us-ascii?Q?pnAGBo1o941r7x/5LiVqimn5JwsTzYRFJuSbrIHUszHL+CQVPuez17WKRsKu?=
 =?us-ascii?Q?kUSD8WEZ9c5X8ts97gJoHo+ZIMufZgsE4zsQLZ9x3dHCjN/O8lbicLRXyP4U?=
 =?us-ascii?Q?tCpCS73gXSsQZEfRX3aUbwkH14EHjda/7cViEv1AJQaNnaGmmmMr4BQkZlYQ?=
 =?us-ascii?Q?DZyKetdwyfzMJngPRb95Klk0VwdunaCbMkQja3e2chcFTskThFGXk6tlb6lT?=
 =?us-ascii?Q?SCiOnjGnzV/EDA5gyoxnBabE/eKxDjuEy5lyewpcy8bZEqQPGjxcWmRMoz6m?=
 =?us-ascii?Q?39UW5K0DW5h0fDwcCcuaz4gl+NuMQQrCXViW9MEKrCrJXe0k5nw+opYNNjLL?=
 =?us-ascii?Q?gK+JkuQAf+8fvS2EJ3/oMMLe0Hmud3IvPP9SQSHipihfICXPvHVbPGrD7G09?=
 =?us-ascii?Q?6ZLsgU2OagiIqzQ63IjvH7dyn0Hf4jvir8br/8Cr+nJI4FftDTj9WO3xiZ4Z?=
 =?us-ascii?Q?Fkx8bJRbSIXwG0uEGVL4PD/8qBwR/qhraU6nQgJvm1oAjDVXSPWporBS3ISX?=
 =?us-ascii?Q?qV+sfQXljpsuiZvoqDhUi1SdTnG+wFccIZr/t60uV83zdRz73X526uwHamxz?=
 =?us-ascii?Q?I4B1qw77BoGeYVY++Mw4J657F7tG6AwyO9wunI6J16L4eB+P18bO5vRiQ57p?=
 =?us-ascii?Q?c0SVfkh7N5YhC61PfVt1/Agwi5C7jTWq4kKIBd4zE1cvR1dL9sk0f9+t8VQU?=
 =?us-ascii?Q?tPamKXED2hywGAqOw2j1hSRAT3C2KsY6C1U53BA2vuLmT1NekeFuP2ySolSN?=
 =?us-ascii?Q?N+GeyHH/KmIaOzQqOWEfbnNPrNHXd7BtiWyVmoXp4Sg6uEQZQRiRrPmr8lEN?=
 =?us-ascii?Q?TbIOVdn8eU2/yeFU2M90UoTv/o1pzrZvG/N7xx/+LcXIx4UBm9YS/rN7YK+3?=
 =?us-ascii?Q?OzZYbDll/asiG/mfKS9ZMRODvuf7XbOzAL8rTiYbqwvt9BDwtw6/I61PcxTA?=
 =?us-ascii?Q?+xGoePaz5iEsTvrDO2H6+d3bQwKzvZZuGA0AzTe3zH521kj5TCPktA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PS1PPFE5C9D9891.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(1800799024)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MFQRp6URMFop/R7WkxFyjt9DJ1LGo2AlcoIHhTaZUDdi63EGR+WVjUwa3gX7?=
 =?us-ascii?Q?vNFYWpzyl0q2Qpc52R/ZCT0BF67vRuKd2OqcYSAeqIzrKtmJuNl7EhuWU3g+?=
 =?us-ascii?Q?EFAW8yeon57xy3Y36iNQ2PM0ZoC3TT5CuUzxnUsuepwv7UeV0BqrVVyzEmXo?=
 =?us-ascii?Q?QYFNBAp8ECPnJWzNancKb4JJMsCZn+2nw7GMf4VAq7s83Gxwg+FTCtN/2iAG?=
 =?us-ascii?Q?igpHDkannMun3I87Jtidy1yJnU3ESNUC3X7SLpwo+iXV8oSd1/nsESNONDBJ?=
 =?us-ascii?Q?9b7rJTXrP9QTVZdL4uWu1c+Ibl+PCiDxDBWN6gXvWUtw46Cc/SIP6lDqa21W?=
 =?us-ascii?Q?O1dciHbaWuIHE4odMsHjIEI40KhOdO/IG1H66jiaqeKe01MuCycLDJQWIAEQ?=
 =?us-ascii?Q?TqAnWXqTOapbgun/Hhiqx3/mh19FIQeLxGAoAS4f77ogyHhjyhXpvwhL27pJ?=
 =?us-ascii?Q?vEI3hMG+ejLNoGqJ3FmzobmvOxawpmFyIBnqsM2NO0urU4RF5h9M+C+NKd8P?=
 =?us-ascii?Q?OCHjJXXRWixPPVewYqDy+81wWasiClFFT5wS5KeJ84tgMKtGaOk3t/NyK8xa?=
 =?us-ascii?Q?aFjPfCUKLk+rHJRPCBaP81U4eD5xZ5Af7FJ1YoiRl66wiuHzpL++lj8LOg5w?=
 =?us-ascii?Q?1y7W2ussUP9dA4glrtT8QrgPTrW5xhe0QYJV9qA3svgTqNjtbaAJI2TDPYZ9?=
 =?us-ascii?Q?TWLtfyPpIsdsNnyvMWbFjaLDlB2NlXoq2cZ0BeaMIN1IzFKCcw/MEbjf4Rpz?=
 =?us-ascii?Q?NwxT7lqmQ6YqNAF3PTxdPUGsKEoI3qGL5IF977BzqThbhxiqAUeF4V2V0Vj2?=
 =?us-ascii?Q?WdANBt5CW8Fgxh2m4Io2ia/2+ys79FzP0fBIW8jF6Dx8t0h5Ejmuft++yTjU?=
 =?us-ascii?Q?q+0hZI1FeUp4fzz59/+gLV4qf0udTdu9EZLmFUfVlYffL/X+N+vLPJGcv+PY?=
 =?us-ascii?Q?LIRBN6CIEylgNHOC8GpqE/TjErRGnY2VGLIOZZRszCG77VsGgyz9hfLlxk8o?=
 =?us-ascii?Q?6npRE/AfcLydnoAEXEbWKrzOQBwYRXL3a9JT7zVH4OoHQ5vPrOY2+8AknqXb?=
 =?us-ascii?Q?EPCQk2Xuq4833JFM84PPpoaiq2bvGrbQbV6gjZtmwwJfWE3jmqMOSciLk0sP?=
 =?us-ascii?Q?uTE/GPKg7ED0wP9vpui4qPmKy0XFDoz6cM/7F3jeBUexganK1Su6Nb3ZfA/i?=
 =?us-ascii?Q?QfMDWt8mHDTNXBnuKKhNN0BvNoMgQQQuw+6u94gF5rpLrl8oyDjXAzjZ/Wet?=
 =?us-ascii?Q?+I+uvBmA5P+4MrjsumMFRjDSPUQRxwgj7AyFhg3hHZRTXcuUgKkI8aGQk8VW?=
 =?us-ascii?Q?dakEbyCliaRyBJ5Hg8VjkU/iKcRnldQ4oBjc/83O3vankoepcc1q0Uj64Ih9?=
 =?us-ascii?Q?Whwe171L5rB194+ewpr/1rrNqEz1qzU74qvV8BdsS2B6y86QD/fJ9kJ1Mfhs?=
 =?us-ascii?Q?iwBNv2EZs7YmIYmIwUM381YP/BUhQzc5giYyJ9Diuc8CqLE/IvqI7+CjSMzp?=
 =?us-ascii?Q?aufcNbrU+98TSeTlSSDklfjBl3GZ5dpGKs1H7iULPetRavvoSIu3y/jrahHl?=
 =?us-ascii?Q?gzSIATrgYaPvL4Oxm6dhFPraP+rXNCBmsqogvNId?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 480e9424-c799-41a3-d03d-08ddd00fd47a
X-MS-Exchange-CrossTenant-AuthSource: PS1PPFE5C9D9891.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 08:54:16.7575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vsUOlKznkt5lJQ8VHiYx+ZoJgyD4Iv7zHvlq56Ps1CSHHmmTbL+Oio79Wbfp3Dm2pJL+9UUYYPRjCvEYxC46Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR02MB6578

1. convert KB/MB/GB to KiB/MiB/GiB;
2. change the number of sectors for 128MiB from 256000 to 262144 as
256000 sectors is neither 128 MB nor 128 MiB.

Signed-off-by: LongPing Wei <weilongping@oppo.com>
---
 .../device-mapper/thin-provisioning.rst          | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/thin-provisioning.rst b/Documentation/admin-guide/device-mapper/thin-provisioning.rst
index bafebf79da4b..b2fa49a5608a 100644
--- a/Documentation/admin-guide/device-mapper/thin-provisioning.rst
+++ b/Documentation/admin-guide/device-mapper/thin-provisioning.rst
@@ -80,11 +80,11 @@ less sharing than average you'll need a larger-than-average metadata device.
 
 As a guide, we suggest you calculate the number of bytes to use in the
 metadata device as 48 * $data_dev_size / $data_block_size but round it up
-to 2MB if the answer is smaller.  If you're creating large numbers of
+to 2MiB if the answer is smaller.  If you're creating large numbers of
 snapshots which are recording large amounts of change, you may find you
 need to increase this.
 
-The largest size supported is 16GB: If the device is larger,
+The largest size supported is 16GiB: If the device is larger,
 a warning will be issued and the excess space will not be used.
 
 Reloading a pool table
@@ -107,13 +107,13 @@ Using an existing pool device
 
 $data_block_size gives the smallest unit of disk space that can be
 allocated at a time expressed in units of 512-byte sectors.
-$data_block_size must be between 128 (64KB) and 2097152 (1GB) and a
-multiple of 128 (64KB).  $data_block_size cannot be changed after the
+$data_block_size must be between 128 (64KiB) and 2097152 (1GiB) and a
+multiple of 128 (64KiB).  $data_block_size cannot be changed after the
 thin-pool is created.  People primarily interested in thin provisioning
-may want to use a value such as 1024 (512KB).  People doing lots of
-snapshotting may want a smaller value such as 128 (64KB).  If you are
+may want to use a value such as 1024 (512KiB).  People doing lots of
+snapshotting may want a smaller value such as 128 (64KiB).  If you are
 not zeroing newly-allocated data, a larger $data_block_size in the
-region of 256000 (128MB) is suggested.
+region of 262144 (128MiB) is suggested.
 
 $low_water_mark is expressed in blocks of size $data_block_size.  If
 free space on the data device drops below this level then a dm event
@@ -291,7 +291,7 @@ i) Constructor
       error_if_no_space:
 	Error IOs, instead of queueing, if no space.
 
-    Data block size must be between 64KB (128 sectors) and 1GB
+    Data block size must be between 64KiB (128 sectors) and 1GiB
     (2097152 sectors) inclusive.
 
 
-- 
2.34.1

