Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2048.outbound.protection.outlook.com [40.107.117.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348FD657C6
	for <dm-devel@lists.linux.dev>; Thu, 16 May 2024 08:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715846649; cv=fail; b=Yx69Z2KYED1lWMMfIF8d0VluGKWpofIi8LgebnzeMhBWp72HEnsBRlCk5hwvuQEAuwj+JX+4SnmZKHO0Xej8dT+uRIMrhWfuDxIKkHWgxRLn/0GkUMQdijbZjW5qSsq8MLyD5QUUCV6gUKI+2blZFD42X95e655wE+3gd6TEqig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715846649; c=relaxed/simple;
	bh=zWEBCNSe79viO1spxmcK/ZYeuG0VJn5c1YmXVlk3QNk=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=Gs3IQXJOk2wsZnx6dcGYR81fphjyW7v80QiihL/R9I4WPyTeW7Dv72I+R5FK1BkCzTXi+hkMWaw9m52WwotVgL0Q34y3Y0zIqLuFkMBEpoYmv3JYbuayAuE35oq+IoW74mjTNAT3zsqbNTcYo92RAuA3cDOEovjJUuwUoEx3ATE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=qZ300jYh; arc=fail smtp.client-ip=40.107.117.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="qZ300jYh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a32gxdOUNDAuy2gk/9Ap9rr9msndAXpIzH6+fhAzeM78vTiZchhyzgYGly9N9jo29QtVBATjSPt7sD9HgZKKqIih893nIn2+vG2TQ/xqbe0m9q9bmLfGcQj1uMkBAKJYbTY5tdBlkB6KsNXDhgxleWcxuGsdzJRRgqDLJ1Hnvmq9A7/OMBBs8vvUToN54bceS+8MKMVTvqPTwuc5GV/YD0rabaJMPwR1knhY4ZtLzfhIuuhS2lqNs608scyp38GL9vBMl7pzkab80Ak1t66KEDBYP5e+R5d2igp+0HsI3ARNMI7DZ/1rJLnZ5WPPcSFR5Wmg/4E6xaTmur0dT11UcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y76K7FYwu7re6+JtRHUJH5GnlAx3F+R5CzXhHz74B4c=;
 b=V72mkdOORkP6BF7kM1okhesJXpfWcGMWZKv9TUbPrRIOtKt0ghTWWukzvIwxhrAfXipOs6xjxfcykYS3M5P4QB+Mb19Qdr/7uUkoy3Ct0sFivk/vn+JR5/R8IotztN7m7UQKifCeA+Z+qvLk0RtPmtkYM+fPmvBqEjG8JE/HwF9tLKJ4Ul3UsTojAMYtQzjJOCDysRQ31w5Ia/3KUq3JrAHQ0XiJSJYCF1sUCvxl4SZRJebaBpVeaaty6vZAzhY3l0W1dcFQavHUaLLHJDtuZ0I/l4OPQMNFhUmh1ph2MON2UlGopvNEgvDQrxQJIBax1FA7d4DlQWI9McHen2dagA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y76K7FYwu7re6+JtRHUJH5GnlAx3F+R5CzXhHz74B4c=;
 b=qZ300jYhvRDdWeGwE1nNhHyzEuMVMGiVXPI/WJ+GS9r5yBVnguGRgnEXwS1lrIX6BCusWjD9o2oBnQ1tA33uUQ8qZYs4RFTY8ubn+ICyrv6I/pHp3ISdzpjjIcwKRf2zrFpITUfPptooKZ8x/zCTwp30FgD0LTN48p1w3yctmAINbUOI9ZER7giMkoPtAMNWOG+aGWP6vjstOR7JKwVMzwMZtcyCWX5Tz+Xx7qiryrIJG9L6FbiIhHG2GB3Lcs9oK9MwbWVsd0Ba7rxLHYq7Tosf31BKkT/z1Tf+Op4Qa0cQAHPR1FhOK4u8RtfgM2goGeBzQIUcVQ3OuZhZ77k6Lg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com (2603:1096:400:42a::11)
 by SEYPR06MB6830.apcprd06.prod.outlook.com (2603:1096:101:1b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Thu, 16 May
 2024 08:04:03 +0000
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee]) by TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee%3]) with mapi id 15.20.7587.025; Thu, 16 May 2024
 08:04:02 +0000
From: Yang Yang <yang.yang@vivo.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Yang Yang <yang.yang@vivo.com>
Subject: [PATCH v4 0/5] dm: empty flush optimization
Date: Thu, 16 May 2024 16:03:13 +0800
Message-Id: <20240516080318.120231-1-yang.yang@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0201.jpnprd01.prod.outlook.com
 (2603:1096:405:7a::18) To TYSPR06MB6411.apcprd06.prod.outlook.com
 (2603:1096:400:42a::11)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYSPR06MB6411:EE_|SEYPR06MB6830:EE_
X-MS-Office365-Filtering-Correlation-Id: c70dd023-1494-4562-b2b6-08dc757ebfb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|52116005|1800799015|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?D6eL6CXAtaoASTtqDhIAqtKD+yGfBH8goqlBZi2mGQKrDRCSz++/wSlWSQdW?=
 =?us-ascii?Q?cW3oNDxjzl2hf52hn4a7HkiATzEQNGr4CKCo5zIpbpfGxBWSyIUE+DWYHbKG?=
 =?us-ascii?Q?zeLRUmyLpU6MbK4yKNbflhA2RgtEMKfizkkzl9jZPvo9FVYlxZIWNDnD3j8F?=
 =?us-ascii?Q?GQET9PJGcWsnX0zGZxul3AS+h1SeV0lSRL1NKwr0WAglGvN+mcDL1PLdQ7eB?=
 =?us-ascii?Q?YX7lAyA8/2B0+ly1NpiJpItEkbHBWgph99/IQHSWfdgzxTygkGwfapyvMpnx?=
 =?us-ascii?Q?gOMRMhqdpRnge47Hq22X+ZjMxPPRurphcAJ/Oxpv+JaNeL8ppIVPEdWtIwo3?=
 =?us-ascii?Q?+YjXIqLbWTtBBIdyYvZkG5zLju7VRujwt5Dbe90RcuqEIvYPjPfcv2kxePKM?=
 =?us-ascii?Q?BFKyGw2zvhMzcTIH6ori+s2jHwzx0inonEG93GzNyPLVzZxlSxMw98CqcTnu?=
 =?us-ascii?Q?G+Jh6q6qapufjVcEbqCIhoPg9MZcORSBTxIdUw9kxBbJn8EXsZVvEaPdGRcs?=
 =?us-ascii?Q?kyzIuEzOap5bSg5M4uAR7r5ZcxhzfmXYdAGk3VEvcYR2GJzpm5aiblMFTSVN?=
 =?us-ascii?Q?k4f2COQnthGiLgTHGpo+RSZfyInID+Jz8C/Aze0Opw+W3l5T0s+fQaTbK4KS?=
 =?us-ascii?Q?1f62LAcgW9gxpFJ747t5/zX8kAROG7uiSKHz8XL04atwWL8VwZ4LGEFqTU04?=
 =?us-ascii?Q?PPsalcSgyUuQxfaGiKixjLPKoXrGopKdllhEZXH65+hPVeBlbvMew/0x8cTW?=
 =?us-ascii?Q?GJBP5NOUImR/MzWIj41vnpPPDk5rpUk3TA6TX2IlpXggG1Go8V6TiKYAuqK6?=
 =?us-ascii?Q?PTdL6re2K3aPqeYJUIpmLTJWFFLf+el6ccROApDn5JWR1GL7rOqpSpmN/HYv?=
 =?us-ascii?Q?mqgHkwyv2KCa6uCV2CRjBSL+X/8t2QBlVX7R/1Q1ouFAOkTA31Ir+BCjaUv8?=
 =?us-ascii?Q?xXollF5c6l8xyINQITMqFeHgtaMt5wxLaNM2E+Y4XL4YxAHMkIEsdg37bRqd?=
 =?us-ascii?Q?9IK/ovOYGpzIs8MVmEgKBeJFacMtVycmMvbAbn43X5JIkKFV8OLnBilET5zp?=
 =?us-ascii?Q?wTZydGH1GEsYAL7YCrJTqWVDcQva4Zqandty8im4DJFfvS2MWb3c6wq0JKsd?=
 =?us-ascii?Q?L57wXx6l4d0IPPomZW5gWj/FXHfWNkHp0b2s7MB2aCuSJ1XMScNPYpyO6FQN?=
 =?us-ascii?Q?OFGahdXCgvWd5F1Yw4AYrGR5eR8kiCklO4vfqabtV061q2oPe7C+bpbu6jZK?=
 =?us-ascii?Q?/bMzbK8oWS8BjgGZ9OVkSB194qsAv/Jf/zlxGw+MioiX/uRYLde+mN0I85f3?=
 =?us-ascii?Q?Cb8K9/C4YDNWm/149fXfRtYWt8xKKxYMtViNY3Stwc9zTg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6411.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(52116005)(1800799015)(366007)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZnCCE/vPLFumuTu+sTClUrni0UWJwi0hRUdtyqMTXm0U1BqDxunw33mvpQg/?=
 =?us-ascii?Q?BSEQxEj6XEzQWcpH+X4t2n6qwsu6YI1U7huemOUlcR6Jx3ZjAIerctCDumIT?=
 =?us-ascii?Q?qrpbvTd30KR5PIv6wTBvGb67xzQ5BYMM/sJUnZJLkGy3jezfAANrWL+ypBJ/?=
 =?us-ascii?Q?GIAHRMGDzEbN5cMdO3m7tOYUnMKrTGsm9seU9/QTw7eVGMXBrYxpqPxJWTaC?=
 =?us-ascii?Q?85LM+7qoyjy5+pRlqaYCu+OyWObSGEoqmA8pYm3hxMNeZ4rsJ96k4pLWO9zc?=
 =?us-ascii?Q?XNhN0SunIWcYaAAgHtPkSXIcd2bQay0nAMPrM/gDrfQEECr278hJ00Z85PZl?=
 =?us-ascii?Q?JbtaTz0ohFU+Ac8zCcrRBTbdWPwyr6FG+h0Yb+DQAV1G6GHnoQ5HxoPC5BQg?=
 =?us-ascii?Q?OwtDOd4Y/Omb0lv0sZQop35o7TZdOcZbrIGydzg41C2D2V1rbPklHNWmDh+G?=
 =?us-ascii?Q?Km13uSZHqzF18T7Na566alW1YoJ/qqNPQX6XDUd54/5qZnqPTb/dUWZalRHm?=
 =?us-ascii?Q?grUH0qWuVxYpQ1knWzgqwPjac8tGUV3y+QayrJkdupifToM/lr0GZXUrqc4e?=
 =?us-ascii?Q?sqF+vnHtJYE54t16kFsh4KYHqvo7pMQOAIp3IqDxqeU+M0SWp5ArKm6BiFwi?=
 =?us-ascii?Q?PatgQ2i3p8Qy3Fx2DWLrpmJIa8L5hkATAskPaerzpOVPeIb4vaInx8KS2TDV?=
 =?us-ascii?Q?yWRqcHBQ8I2uASJGiKpHAc4P+fDOmSC4sSyXMYq2knVMrUplE4ss+j9WygZb?=
 =?us-ascii?Q?O0GYQWzZc0JSj7WVu3E0NIBC5dq2p3U2vP8GBYYd2tdgva6V7PUyM0rKNRBn?=
 =?us-ascii?Q?cwD6uTkf5n9Pr++CzNUoBREQeuzNMu36WVRdWQr/mbd61VosVQRxYLURebs/?=
 =?us-ascii?Q?saTjtlHPx9pW2ePc6KuhlRKHIkESuJN9gyjjSaipl8AXAn3NcRt5F6SmFlJC?=
 =?us-ascii?Q?iY6VAFIqvyLqHxIjf/poCMU9+wm0TQC6C2lsMknItxSZ3j5IDtRE1+XpMY5U?=
 =?us-ascii?Q?yTIhfpeFQtCQUGCIp816Wjn0/bb2JgAkG8TJOZmLJPh6xpP09WaGwYhwCmu0?=
 =?us-ascii?Q?KaM4/XUjz0syc9PmwwYZvoF4Qw1q6vp2v5h/WxcgzTpkVg2ldqYK+ueyHymD?=
 =?us-ascii?Q?6GonMWPnKJW2PdEmWT2tLpKxSP0QgoPUWOC884pAKdS0mKuY85XgCpz4UR7i?=
 =?us-ascii?Q?MBVHpNER9NuLmwi4Zh0iPJk1kgW8fm86w4CnkHzuHBVgnCDCycxBYNdGORLh?=
 =?us-ascii?Q?7cNt2B6agAg8xyJyeXgIoPkHig9NETPLkYONkwCocFJ4AOkegothyOAZVibY?=
 =?us-ascii?Q?sJj3VLu10CjfnPSnNy21lSeQvri2wZZhfKCs7Pv8HuFCBf9wvQOzZBMUSqvL?=
 =?us-ascii?Q?b2y4gtCLzrjgdNMbVq6D5whhKg579lFanrfSQWqad2s54BbDYnTMXAAq1n11?=
 =?us-ascii?Q?aSWDjsq164VeaHpUjMSLDVhwoXG9T9QV8YQCGcfIJB+FD3Bg88XZtpKl9BEN?=
 =?us-ascii?Q?vY9/EcYxWcYFei15+W/Q8juKNvZwOgwjzeymAjDu/KauFrTVUCfV+TI2zADo?=
 =?us-ascii?Q?Bc+r3HwPe7fCtMZj39Q32Y3G8K7MjQOSBQI7CSGn?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c70dd023-1494-4562-b2b6-08dc757ebfb6
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6411.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 08:04:02.4336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3khQx5U2S579fJfLjZ1SRc+OMnoLAxzU6MUYuLp/Xo0dc3Y4yZGgwDATIXBLTQLntLiknvgNSdYCneS0dIuhSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB6830

__send_empty_flush() sends empty flush bios to every target in the
dm_table. However, if the num_targets exceeds the number of block
devices in the dm_table's device list, it could lead to multiple
invocations of __send_duplicate_bios() for the same block device.
Typically, a single thread sending numerous empty flush bios to one
block device is redundant, as these bios are likely to be merged by the
flush state machine. In scenarios where num_targets significantly
outweighs the number of block devices, such behavior may result in a
noteworthy decrease in performance.

This is a real-world scenario that we have encountered:
1) Call fallocate(file_fd, 0, 0, SZ_8G)
2) Call ioctl(file_fd, FS_IOC_FIEMAP, fiemap). In situations of severe
file system fragmentation, fiemap->fm_mapped_extents may exceed 1000.
3) Create a dm-linear device based on fiemap->fm_extents
4) Create a snapshot-cow device based on the dm-linear device 

Perf diff of fio test:
  fio --group_reporting --name=benchmark --filename=/dev/mapper/example \
      --ioengine=sync --invalidate=1 --numjobs=16 --rw=randwrite \
      --blocksize=4k --size=2G --time_based --runtime=30 --fdatasync=1

Scenario one:
  for i in {0..1023}; do
    echo $((8000*$i)) 8000 linear /dev/sda2 $((16384*$i))
  done | sudo dmsetup create example

  Before: bw=857KiB/
  After:  bw=30.8MiB/s    +3580%

Scenario two:
  for i in {0..1023}; do
    if [[ $i -gt 511 ]]; then
      echo $((8000*$i)) 8000 linear /dev/nvme0n1p6 $((16384*$i))
    else
      echo $((8000*$i)) 8000 linear /dev/sda2 $((16384*$i))
    fi
  done | sudo dmsetup create example

  Before: bw=1470KiB/
  After:  bw=33.9MiB/s    +2261%

Any comments are welcome!

V4:
-- Fix the build warning "no semicolon at end of struct or union."

V3:
-- Focus on targets with num_flush_bios equal to 1 to simplify the code
-- Use t->devices_lock to protect the dm_table's device list

V2:
-- Split into smaller pieces that are easier to review
-- Add flush_pass_around, suggested by Mikulas Patocka
-- Handling different target types separately

Yang Yang (5):
  dm: introduce flush_pass_around flag
  dm: add __send_empty_flush_bios() helper
  dm: support retrieving struct dm_target from struct dm_dev
  dm: Avoid sending redundant empty flush bios to the same block device
  dm linear: enable flush optimization function

 drivers/md/dm-core.h          |  3 +++
 drivers/md/dm-ioctl.c         |  4 ++++
 drivers/md/dm-linear.c        |  1 +
 drivers/md/dm-table.c         | 19 +++++++++++++++++++
 drivers/md/dm.c               | 34 +++++++++++++++++++++++++---------
 include/linux/device-mapper.h |  6 ++++++
 6 files changed, 58 insertions(+), 9 deletions(-)

-- 
2.34.1

