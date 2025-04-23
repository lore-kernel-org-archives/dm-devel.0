Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012063.outbound.protection.outlook.com [40.107.75.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067C78BEA
	for <dm-devel@lists.linux.dev>; Wed, 23 Apr 2025 13:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745414071; cv=fail; b=DGhRnmO//DwrwS8tyqrsCrpwXsdnL/QqjoAan13LyY2JLk0KcDSYY2J4HXNYOVv1DBVw3RTCrnjXMAVA1VP+OJaCG7l/E+YAB8PSYyHJ7jvEyb3EsS8WoGhZqhn7cXFiOrOn8cDFLwsFwy/HzkwUHJSjr2P9Vk1U2/sXmGhLglI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745414071; c=relaxed/simple;
	bh=K4eNwzMwt2xpOJeHvZbXJtexsVGnuM/2ZoRvNuTffOQ=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=FiL/VWGz9tJO6CPko17drIA1cjqNyRZ4vtUASVsxFfYxDLiJBlGptfqZ1X6vhfDIwlYDEEioAAs4GCz9IHL5erll95ABCUKVa1HSIUIOIZF40bJ1ZgZUwbiFqIVXIf6TtLXaLtRVJNqJW/fP5rCp5TLBJiXenrBvXRbR3VBo+kw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=Wat/NPtA; arc=fail smtp.client-ip=40.107.75.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="Wat/NPtA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vitzMQQ+7OJ8uMKzAbhcx/Zd0R7OqxorF83/3+tH+5Odxa+BtRt+4+pf6eZvpESDaEUXcSgT4Vn+HPMKWB34oDbUvjz5agorTb2hbu4cdKQgeqCVJqCZHLTqaX9gHbbn4Ql9BGhbcEus5WQgxZMRsVj7GPe0+ZRZP1k7kJgLH7estkjHYayKaKsCVvO9DYYJWECvp951IdShTSUKYF/yclQzN+BbiHSuBDoIzM10rORKhvoa7X24Pbvwos/pNNEEFKTY1dHgDWQoJWD5L/HuadmH5UMqps9mGAAVfYaHD6oxytDFew+59/VrD93fXZmhNugois/rATGanL2cXap9eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S6ci/KFI7VfNqsk9Y8d3sjfq66byl1r1EqRe+0NMILY=;
 b=YB8HKMuOKItEw0+CWshha8/EOpJqYQ2pD+3mm3XfUbNM0SYTXz7dGioABEYzH8pINgB1/tW1nF1n+9KmZK9H8KFz+purUKdHgty5w+IXjCHkRuYTkxfTsAgaN7MBWJo3TunzMUgP0zmDUEzSABXgKmFk9iPL6VifmepEZM5G7G9upP8y5WadPw/0WOOZ5YpgfReLHZ9i1l1Oeb+llyBMl0+9LzzwWAuhGSZSwGBhpOVupe0eoS8Veghngp+xhvbQgefhgBD3Qc+192AslR04Hhl4Yx9Ro9XVRVEjBWVLdQNSBcWIYJ02d3YbYnB/iaYii/MqO+/5SPEw8QdmvnQg+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S6ci/KFI7VfNqsk9Y8d3sjfq66byl1r1EqRe+0NMILY=;
 b=Wat/NPtAigGpQBf0thVvipzEFqPo6+xRlaGX3S1BShXeD5qwvTBz9u22dQu7JFIdZ/XMaEMFROnlUINz274yLvAkEVDIRnpK21aIohEMV8rk+oDUzpZslQgj9ylGotlBqrDdtK2JJVH+RC7d9RKZjc9PHprgPS4avwr+iV+t5V8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by TYSPR02MB7783.apcprd02.prod.outlook.com (2603:1096:405:5e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.33; Wed, 23 Apr
 2025 13:14:25 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8655.033; Wed, 23 Apr 2025
 13:14:25 +0000
From: LongPing Wei <weilongping@oppo.com>
To: snitzer@kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	guoweichao@oppo.com,
	ebiggers@kernel.org,
	LongPing Wei <weilongping@oppo.com>
Subject: [PATCH v2 0/2] Reduce memory usage when there are dozens dm-verity devices.
Date: Wed, 23 Apr 2025 21:14:07 +0800
Message-Id: <20250423131408.26608-1-weilongping@oppo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::14) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|TYSPR02MB7783:EE_
X-MS-Office365-Filtering-Correlation-Id: f6e98a09-0404-47b7-6913-08dd8268c54f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Zm6IV4tjagvR6uPCIpS1+SfHq8NMZACCfEhFcKlbC/rlVSlzuudt2eVm5VIa?=
 =?us-ascii?Q?gkuifpLkrMV+k7bER+z4rvqx3vOUnwKLFmu1/38//I+gvb3Y0vLWzCnWvkFg?=
 =?us-ascii?Q?vrP7nmx+/zxVN1vHK4boXwQzyOUjPXpejd4yHB/Cf+N7zdni2kB99ioJWYyU?=
 =?us-ascii?Q?XVrUcAXsvMUnXlNT4lURRohHbBsaXLc/c/iAHi1hg+FYUKmenXWmnThUXlXX?=
 =?us-ascii?Q?dfTIgs/uEQqoheTwoykJ8TvNhWk8RiVkE1xrpKLnwYQM6NtMjsZBfvoKHpJP?=
 =?us-ascii?Q?5BgfyxNs+naf1EslQJL7ezYQbglMJ1hqqULd+CcCJmYXDj15CYg74yawY6w7?=
 =?us-ascii?Q?8lUxAToGhlPQdbbCqqDN1C+mei6dXkBcpPskPXsl3AbeY7+h8ycMjqdEOFxt?=
 =?us-ascii?Q?yVubigxm92yLwWg+1cIASGVewbYbMZsEFMGwvAiwI1v6HbSskiO/+n6xW7HQ?=
 =?us-ascii?Q?uh3mCdYI7BxyFbqzvVBTY0gRI0Rs9XUwmkHQ6aXsnOTGA/qjosn2mG9oS4Ss?=
 =?us-ascii?Q?qyyfZhx3JE3bHqEQWwmriSsPIEMPjYDH6iOrIvaughV3qjCj4WA3lQ+sda+B?=
 =?us-ascii?Q?Y7YmQP7v5bsib5ktdXST4Ceh/vD1LlfYVd7y7JBeHLLgaXD4vYjye8g2BMBz?=
 =?us-ascii?Q?DoTB4xCryAqN2UUOKdenT8SPbYXPchdEyuw1nMC3l01imUvM6KiHp2AOM/aQ?=
 =?us-ascii?Q?3QIO4ykwlgeiRCFv/b9OYmoQn+C4o8VYu2PyI9vQVoVh9SycR+bYJ+bLLrtY?=
 =?us-ascii?Q?gbJ84+wLFcg813sK3s63FAybxZ9Du8rAf0Cq/OpAas8gESp8A1g9HeFbISvF?=
 =?us-ascii?Q?074EsWmIa9mD9PO2wR0+C89T3Z+S3NCRO6GXT3AE0Erf1XS8cTaGf3Zdi0cJ?=
 =?us-ascii?Q?vbo97m/rz96LHK4FLHTDvuQAeaDpSRZwV4qGqqvnjSgknUCoVofHA4+qwnE3?=
 =?us-ascii?Q?eS+hJWyHiDPqNZRI6oYbg25ppJWWSS5m9d3t+VwoYwDjMh0eZ3dzfVNYy179?=
 =?us-ascii?Q?NEhkVL6gU5jo6aHLpRFH+lLyfijwupl+5vKgDjQd4rfMRcor0fzLM/hAJO/r?=
 =?us-ascii?Q?QbwwcKFE0X6XCTAg78DlACmUy7rbqGloz0G3bGz4Syj9zhkOw7lIKoz/t/dA?=
 =?us-ascii?Q?FFSa2e8xdBdoCv2rVV5G3WhOSZlskdqKDHTGpLFEwfIb39RKZEvF9oVCmz4H?=
 =?us-ascii?Q?5UgqZMLNEqo0CtCQC8vYyKsCzZqn7FY5K8pIWFawb+JWNSazv9pXRJAzsxRN?=
 =?us-ascii?Q?N6cXUIuNnZbb98Qdr/g2ji6wnTK3PuIQNRiutHnbfcTwR5E+h9QjVxvUpMpr?=
 =?us-ascii?Q?t4uoGBcVSjz2b1QIE7oWabWxyQHdUELlHM0TyC/2eaSAnSImEbONdp2ixSuJ?=
 =?us-ascii?Q?o/az+wvCSd9zlce6cRXCvS2XgA28DJYxO9/yAjZ92MSW4zXPCDXGs0cC5QM5?=
 =?us-ascii?Q?b+hqI5FmioB3vQl8Wn4uN7RVAA8s+wNc2R6ApvJgR5TpcuaHNVlacw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SxLxavC0WPmRo9b8XbphEH+BFrpBnnXZiWpK8+grd50hIN+84WH0YV4gOmeF?=
 =?us-ascii?Q?wdl3jyG3Ed3aHzxTSQdauRyCC1n1iY8fO94d0gyHsyqIB6fhwczvbXX6rAZc?=
 =?us-ascii?Q?VX7wzRbKc71vlDdm6JUVSqyjGftKOZvv4JJSjSoGkigpfEdL9qI3RaA71uLC?=
 =?us-ascii?Q?IqyWplStsxQDfU0l0hwS6tTpNH57CHWVMIx/SuDT0dlBPstfnTLbM3zxSluv?=
 =?us-ascii?Q?mzeG81Eq65ioZSeGJZvf1HMnoALyQ3kUwQd3QFaiNNPl3sFeihIHJ8xY7JsF?=
 =?us-ascii?Q?S/XkXkE//qG5EGnwFSOPT3wWYFpcNkI4gtrQLxWSzlWzvaRnjHmHbJqkXuvf?=
 =?us-ascii?Q?6SnICNhN0OkxLk5g/27nDNbskAHP+da/9yKiUwgV1oxUs/euvGWMcgaYAbi0?=
 =?us-ascii?Q?NiriAEEs0++4Gs1MQjzLa+ayZeif2tg7kqPz2ob0vVLaNf5bFEvgrulhVuki?=
 =?us-ascii?Q?WfOur88ghi7dnvEHFHB8KUd/hAssW63i1ZQgx9lhFaelPmg/j+g76B041vBU?=
 =?us-ascii?Q?2HdvBzb47zRoSRPPSJN46TMIZyEB6sz2L5H2D/KpRXoRk4OIWRT+NEZGKb+F?=
 =?us-ascii?Q?QVr3FgYQ9+gC+4wa843UaZoF40p+fnsKmC15C+8AlCHCr3k53R7sfxxg+55d?=
 =?us-ascii?Q?JcUT73DlWPuDQ2cOMX7mlvLnuD2mGVQn8b/ZA6NCjg7QafCvsdqPSVKU7zCU?=
 =?us-ascii?Q?+9JRsWbKUKj/BirQYBF6MaBM7qLxSOgEJjw16G7oiVkNvDHCJdErUIIUMeqb?=
 =?us-ascii?Q?b1rixincL92hUwUTFaSBHhszTNaRFwxNVpfRN8AWVMCzHvVzYh6/bqUVnj/7?=
 =?us-ascii?Q?+HvIkp7WH25tJ5U7CoKjO/FDOWduS8GlMaiaSnIyomiQKR/oL7ucGcKbnSCX?=
 =?us-ascii?Q?Ih0s8XP1tQxyIRFv0fIHpXnUEm627lGuA8D3CIY1eeRRkD+5MhoyMxcqj2Rn?=
 =?us-ascii?Q?TBw3/7+LvkCB7TAe1TdRrIyfamG1Fv0moGGVsxFP0ZoBSoEZdzkfCZsZqOA9?=
 =?us-ascii?Q?1bTJMcyIhscrtsTIDdGwXdZwsjr7IBU1p1PJ/K+bF80HDdqWp3e7tvp5pg66?=
 =?us-ascii?Q?huz4h+17VtqNCw+rAVnkW6ytrlO2/zVYFskKroKt3yYRyCJS5vTGqO58hvaE?=
 =?us-ascii?Q?kROiky8JX0Udq3V9Wkr8Q2XVzy9tBuIqntWws5QTTL75S/4v0kbTBCptOTbG?=
 =?us-ascii?Q?y6kt5c+3hfZBGJkPstdKSgntsF31xLlhdLB/i7x1/1NSXjkLy3hGbCK+p6V7?=
 =?us-ascii?Q?STss/P3Wbh/ayqyD0pd/6Ntof6of1ibQPF5d7hs9Y7KEIegrJNEVZbSMMEa/?=
 =?us-ascii?Q?ELlceaqeqCfd22dJmZd1TbtO13+bBPXs5Q198+X9aOeGdyYOIgd8azovhOve?=
 =?us-ascii?Q?u76/57VwMWQrsSgt/I4MnfcUnTI5kukJQ768MNuX24tW934Iup8i1qfWHRIl?=
 =?us-ascii?Q?XXbdoe4FkhN52YNypgAoFq5lfxfYUG1kTqC0pp1YSUfeBTJ6S+IMtDm3oNZV?=
 =?us-ascii?Q?/7/J0nrb/nMyF/RnGrWD1TR9HMT/J+r6JwllFQc5ko9MyLAMdWLYOM519DUn?=
 =?us-ascii?Q?6Zb7QmJxaFO4Y4nZ09XYExp38QMt9UZ7rrgx80SH?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6e98a09-0404-47b7-6913-08dd8268c54f
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2025 13:14:25.7821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5pTa4fE1Cqym4McQP2ucDHfeyGfDsHFVwKFWfkeX0yIJNPZIJ6t2yKfxdY9xJVGTk5cXN+walS6iF8T+iqt4zA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR02MB7783

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

 drivers/md/dm-bufio.c         | 31 ++++++++-------
 drivers/md/dm-verity-target.c | 71 ++++++++++++++++++++++++-----------
 drivers/md/dm-verity.h        |  3 --
 3 files changed, 66 insertions(+), 39 deletions(-)

-- 
2.34.1

