Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2053.outbound.protection.outlook.com [40.107.117.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B927136E00
	for <dm-devel@lists.linux.dev>; Thu, 16 May 2024 08:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715846661; cv=fail; b=k3x8ZeDh3ZLTrgnGtRg7h6J6UAaUXT2of63N2zt7UrSPvRS+ohlKWWVGvDt3rd5dvyB1Jc+QToEIkt5dp/JGzL1TA2ivhpUFWMQ38aY8O8Nv2p36Tg5p3o9vsYwF+anFvWCmvJQs4ryP+S58f+gZoYmZ+Cab+Nlwx8ilpMn1a40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715846661; c=relaxed/simple;
	bh=pPWvRKMPkRY+EnBmIi6erbgSwiPgbkjhyxIFZjHSVZs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rLPsZxHAhcZ5RYNxgHSIRhhyWC93H6njQQNedoTy6eRs0Mw2igBAuPPiUew+RNqwVO0iXDhZOBzifqA5v/2LFzeNj3wlF+c1qS2RvwwK+nAKSaqP66DhjyBC6wn00BMcz2Yiv+G6nz5JEK2d4rWFtUfmmD5mYaMAhqdoRCRvS3Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=absooTII; arc=fail smtp.client-ip=40.107.117.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="absooTII"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fB/EIIjjfzZO4ty8LKsbhdnRSdPIVk3rGOFs/rLW1FduF3bYNY3t2jbf/meyo8BpDRC6EqY3CZOr94jZvbbwOrEZzNcNiYA+u99XtR51FwO18soZZe8nhq+vrBODi2o0yzSlJ+MS+AoObt+EjsYI/QeTOWk6Gcy6Bihb8k2rpaFNRcclEyFtaizUmLdCHzpntXP443+OI3DJNaMtTj6UAzxx1Jyn8wfQyrfT/0Db8iOJocr4T7QlwpFnbcgsuwOFqt75T9r2ItLhfhEjwrVoS1tluap96rcMtjzyhFTDGU5rf6rP99yis3SvS08Z1buAnW6UaQyx8e99Rqf+WqZhxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BRt2mpHtqBUQEwpYTcZxeN7e22kn1HBl7EsDYJP5O38=;
 b=Z9edaEbcmojDorLpEGwqQL0tWUQzUOLXvVy9/b97LyOWBF1KhRyJIdFtggu+/FrQ/aBfPUodSZZaYx1QgpUvkINbmD6KenP90iZxi3GPGdB8WBzjPvLhvBS2mtXm3XVR6jRzQTgHN0Ydqnh6SH6hvNrVuUhOP5/ynnXEOKKzyzl5bqlQDrtCt8oxEtxMMXtlUexz3WHWMAxriWoh5XLY9VsCo+TtPgr7o31IAAIJTCK2tTuizDiPLyN0Ef43IEI+l0O/3VKnzYV5r7pVEK+idgdw9oYTZjpXZJ1Ctl893DzrF6sfCwkmlsyjweplTRsq24Fn1BbA3szRTscrxHUiVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BRt2mpHtqBUQEwpYTcZxeN7e22kn1HBl7EsDYJP5O38=;
 b=absooTIIXCxYJ0fMnPKFY9JhxZJVFGdELYOOE+3jxZZ5Ws/n14gLqWk3RpX0G+hOQj/E8tWNsxt69MFrypyRHPlVDoPh/PKIRRrdxZa9qJIZGMXrtvchdYg2KbVmGPKNc4GXftaooPSMyO+AguKUxbt1eEYBX+1lsBQIHwUnc6rI55dgDdj6gqQp9veJCIxUCjGAAkbbN2/xClmwuSmdwxOs62nl9bYNXy5yiAgw66mFhvCFeGyywlfVTmYGBwY7ri0ZJ7AAP2wclkzW/PmOmgX2iDhOS8YSvWcR2UzXSbHh3xcZsep5jZvGE/PB1tCDOsrLlvf+f6l9CQkpBIcj9w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com (2603:1096:400:42a::11)
 by SEYPR06MB6830.apcprd06.prod.outlook.com (2603:1096:101:1b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Thu, 16 May
 2024 08:04:16 +0000
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee]) by TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee%3]) with mapi id 15.20.7587.025; Thu, 16 May 2024
 08:04:16 +0000
From: Yang Yang <yang.yang@vivo.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Yang Yang <yang.yang@vivo.com>
Subject: [PATCH v4 5/5] dm linear: enable flush optimization function
Date: Thu, 16 May 2024 16:03:18 +0800
Message-Id: <20240516080318.120231-6-yang.yang@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240516080318.120231-1-yang.yang@vivo.com>
References: <20240516080318.120231-1-yang.yang@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0195cbde-feed-43a7-6de7-08dc757ec856
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|52116005|1800799015|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cqxVHo0QwXfE7osLUCtTdtxDHSc0FxQWrpc50lTCvysa4FMF0jOuJ9CWZ0pj?=
 =?us-ascii?Q?Yp94sLaowN0nUu4EWGgRm3Gunj2WS5eELA6XqlCbMJgl9twfC6+e64m61+zl?=
 =?us-ascii?Q?zAf+pun73SeCu/Zg7FB7/T83+07KxstuhepeD9w0tQIPL1zfdaHJSBmhWfSG?=
 =?us-ascii?Q?EoNu+CmZJB86fNPVSNZnfjB/3NDzox4hZiAMkwndvPf6dmn/zlPjV4GM3Occ?=
 =?us-ascii?Q?mWtWrFyxKoiObYkSJHRbCn8PqZ4o4tLmgWhcoYQ7EBFx38rB2bvX/kclTVQw?=
 =?us-ascii?Q?eaSU4w6of9XCplimeUjA9Ga9n9j7FLwAGMy5x2qD5f7VRgQnucVK8hj/u/5g?=
 =?us-ascii?Q?OwoZEbdKMmR/PCjuk2IZj9aA/HFEy2X84QpNOC1uMMDnVmDy/zjKGLKhRmVz?=
 =?us-ascii?Q?LqGQaOU+PfoLmdApFoA0Jst6Whk3el1dbR42dMUJ4SgPQ26r+kmRNHIGpXEy?=
 =?us-ascii?Q?peEdtT8D7vjKqxM5WMhCSq4SwsyUIPuaAeBcjqCYhKR7FreVsYrSFhXg+7aP?=
 =?us-ascii?Q?k3NTligP3gprylqAhXZdMC4R+09Mn9+UYk5VP60aElkOK5D7iuVhod57kG44?=
 =?us-ascii?Q?XV/vJhc7SdVDIAlC1hS0F7T+bIbHN/+pB92oC/hlhU+WRc8xHsdsAdQZkQQP?=
 =?us-ascii?Q?XoU6PU9/PMdkNZu0VJwdjKNRuy2NLxC9ThS+4FghwZv7yxJLou5Cs3kfQOdq?=
 =?us-ascii?Q?poEzSLqFfn0h+1qpDy4LMTSmsTonID0lJy2JgxlLedNQO1IidmttXwjLPuBO?=
 =?us-ascii?Q?xHpcWaMEk7BRRHjFSdsqqJey66cljrrI0U73A6e6DEJj/4TygBJrqbyIV82C?=
 =?us-ascii?Q?RKIcPWdgLE5LBPS8zFwJ7FXL8K0Vuf0caRVIP1JgVT1TuX5FosZ8tAAbSwhp?=
 =?us-ascii?Q?K3ogJEr0OMAPlTHQYiB3XkD8P7YwyOZhTkna42Wvu8B8gIcW2MT+exdYadhK?=
 =?us-ascii?Q?IHP6CzcbYzu2Dz3AZVtTAbZfNpXjnD+VDj1eK75brikrw7EJd4L7wbL2y7Sl?=
 =?us-ascii?Q?YT/k/NCzGePYIwK/adQ6f3t7hOXuJXFKRKsbDFCesFy30Nh4/mIyRxYevyvq?=
 =?us-ascii?Q?jUgV5fiHDQz42KatJMgBKdSkc1ssHKj3IytxpqqEUUZllabg6xPXSJlnv0+r?=
 =?us-ascii?Q?kYZX0qDplLqFD5GsSnbqhwyx6uYK7KwaGEPoPTeK9VlFzXeq9htM4f3FuL7g?=
 =?us-ascii?Q?p6TJJoT2/yrb2Qea6tcB8lr2Wun1GpsOB2bZ8jaAbo9dLQF8ck4/eb1gKhZL?=
 =?us-ascii?Q?BsJegSc1VJrnKiCtMFlqAD5ZR9APG8DTWpKXCtPYQve9/O4zE02Diz5tCSLe?=
 =?us-ascii?Q?OaNECtwLI1eU3MgpdU3aSwmdQqLn6PtTtkj/l3YSfFeKQA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6411.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(52116005)(1800799015)(366007)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ff1Ok/aSWDmc/oKgX6Z3mRiweLDSvA6plgEAAb29iB5iom9oNQjUR1BK7cx5?=
 =?us-ascii?Q?iFL67oKIEq8/6Xp4UJuWTVPRbHu+OPzS1cB7uWPh+pya4n6jdikqEadYZ3oW?=
 =?us-ascii?Q?9EZo6eCGOG7zjeLwW/qZKQpUcVrtkbV84Dc5YnYyok0sEVcM1nmvDBFLpB3E?=
 =?us-ascii?Q?1tbP2bGVMHeJwFgnHqXZUGQrnZtyHHJ1gqxgKo/JEPjN0ecCtW4LrQgOBNXD?=
 =?us-ascii?Q?JtCmVX8x6oqwCxcwZMYu9pGfybeFuKf0cmG7Fp+y/J7S0FP50lePsRKHbuQe?=
 =?us-ascii?Q?qzW1G2N64HFHESDUXR/LucZQBIKZEZSqq7lADYc8oerEg82c0YccY4WRihwP?=
 =?us-ascii?Q?2D3iSCU+10UjlATGNPh8foOIRe7zk1UqxInhJJSlQ6Rp/8muOMyufWrke/Ei?=
 =?us-ascii?Q?utaHfw4rhlYqsAwYCSqQr10PrGvYhHFrH8Tn67c/CyrkZNC36qBXwr1Byoa8?=
 =?us-ascii?Q?6IcZcxZUJJuO3pItd7YYbMHwZHMiWvS5Kvz9kZg8ifCzUzFwPLD2GqSjn9z+?=
 =?us-ascii?Q?dGW/DOUd8LqSC6EyKY1MSGDnrPIv3nVVBCHAwfa2wERWkIE/sWbw9VgLDOD9?=
 =?us-ascii?Q?AbzcaVPR8DPC8XMHL163HKNMIsklKsYAf1oeFwmi5kW/obfu6hjLel/w+CQc?=
 =?us-ascii?Q?6M2QMXntdWeRUoi5sH1cM40tgda7ehpT0/EfoP+/PLLg4OvceQ9b+7YFJ4e8?=
 =?us-ascii?Q?JQQ6IRUDFdfp9zxiA3+Jk2dUCHEBtd8N7cjdXomiGP7VQA8Qh6fD1eXIgr/g?=
 =?us-ascii?Q?aPspiqmw4RkTVpaqDyva/BcOZi+WN7+YC3UlmtsuSuNez4KfSgNtTFVfHNZ9?=
 =?us-ascii?Q?UfSbwH8hbjExb48TIXpZ64pZZOoUKKE/+Og+mP5t+M0m75tLeVMrDe43A1RK?=
 =?us-ascii?Q?y2NLWnufnnr+pqnqcJ3SKr9EsAn2XKeF0epB4AAhAhUbhX6ZaHbo5V+wvlaC?=
 =?us-ascii?Q?nYgI0plRAOrutWeA247RY4mcbg/AFTMjHbOhAJTiwm4Gt4GPh/xfTvJzXCXJ?=
 =?us-ascii?Q?DN7uokutezN+TAWOp0RufjRX0I3Zs8Z6y4of8SKUjXydZ9UVm5KS9P8Bf6cr?=
 =?us-ascii?Q?1Slh/3UdwiBjbt1UVXBmAD2rh5bnuno8oRCzYPjPPcugUDJC920hM1C/Xrbi?=
 =?us-ascii?Q?alf0i4Y/U/LCOtonTGvVBMHe+skOTYiiNqe/EKy8CFjgj0DWlCEYGFIU36kG?=
 =?us-ascii?Q?iowGKrHmi9YWW41FyF1q0/H4J59XIUeZUBciGtqp7bYOGSPWxnVCu+8a1DWH?=
 =?us-ascii?Q?4ZQWeLP1BIcQbfAYaOPgQTdkPuvhZd/O6vZ6OVpCSZhfupnkKoYSOrGsSSr/?=
 =?us-ascii?Q?VIgZNqPuRblDmXP1r36rlhyh8izijhkpcnKpfhDQ+VV6CTE7q4f9hXnYd+V5?=
 =?us-ascii?Q?BXqKlRHpYdkEnHpIOnSEME7QvvP6ESnGyIZEQQzq+sv+2iUq0zgxusFPItTR?=
 =?us-ascii?Q?rMcXWoF+eognL7VryO3X27YbUQOB6+rkWEwC8qbov+m6d0UG0Kd0k1gYZsSn?=
 =?us-ascii?Q?0wf6nShC8FjFPnbRyHYAhk8FoH0vd6l1oKmHhRrojbrK+TSSgK9mo11+TKU3?=
 =?us-ascii?Q?YS65vjpppQz+vmORWQwRcl6DAZDMJh/NzCbfLoPd?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0195cbde-feed-43a7-6de7-08dc757ec856
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6411.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 08:04:16.8848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 17Flpdv/WdRoZqeKbMIT1x4mzmd7/yA7QNnJXSezCuNfpimZO6BBt9Q20Qt9u/OMqqMDdYroyb4dcS4X2MuzJQ==
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

This issue can be reproduced using this command line:
  for i in {0..1023}; do
    echo $((8000*$i)) 8000 linear /dev/sda2 $((16384*$i))
  done | dmsetup create example

With this fix, a random write with fsync workload executed with the
following fio command:

  fio --group_reporting --name=benchmark --filename=/dev/mapper/example \
      --ioengine=sync --invalidate=1 --numjobs=16 --rw=randwrite \
      --blocksize=4k --size=2G --time_based --runtime=30 --fdatasync=1

results in an increase from 857 KB/s to 30.8 MB/s of the write
throughput (3580% increase).

Signed-off-by: Yang Yang <yang.yang@vivo.com>
---
 drivers/md/dm-linear.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 2d3e186ca87e..3e1a33b4d289 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -62,6 +62,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->num_discard_bios = 1;
 	ti->num_secure_erase_bios = 1;
 	ti->num_write_zeroes_bios = 1;
+	ti->flush_pass_around = 1;
 	ti->private = lc;
 	return 0;
 
-- 
2.34.1

