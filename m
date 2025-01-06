Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328411DDA2E
	for <dm-devel@lists.linux.dev>; Mon,  6 Jan 2025 12:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736167313; cv=fail; b=erquc/Hf8XYJuhXICSrag1b7rWrDBWpaei+NnjaHRgB9pypk7CK/0eR4eBOGugLP3xXpAP7EawmhvyD7YAJALENsqL0pFdF4kq8mfj7Ki0ldS/6jEV52zzLeEQenhFP/z5G3MT1k+LNpYTmQ/U3Y4sFhXE1OoYTeiIqx3wcEyD8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736167313; c=relaxed/simple;
	bh=F+RP7B5Bw991OHHY+NwYg1gQU/8Z6WhhMC/WV0c1dmw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AgGr94FkSjaN3MqofcWnagRv0InkVHRNY53Dkfr+cq8gZehtwNonwc/OGcazt8hXRqRcrWyqS6Ffv093Wqe2QKdP1MOqwwGvOFwF7a9ButJ0UMrgMIBt4tRfCQVMgY4/0tyyVjx00rB8ndM9UEEaC/odJGkpz7D+cYbpNHeS8mM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cI9k3LS1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VfD4V+7l; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cI9k3LS1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VfD4V+7l"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5068tnm6019244;
	Mon, 6 Jan 2025 12:41:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=9RvRaCj1qXoc71O+4ar8RblUY1mnlIDr1xYBjAFSGms=; b=
	cI9k3LS1MeMP1qaAgw5okmQsyu5zk2pHFUbBT4VytYp8BTXiuu31obRSbXtwdAxv
	56LVfrfXlGBa9CjY8eqLDYNn4CEuESWSv++Y7m5eKQTTTvPov5uBDo1XeDURS7SI
	jyMOmsIJV3OVeizTD5yDSPFJ+l+ZIfixNYFIfTPdCto2nNgcok8NqYAdPAnYSTfr
	RwGK/ceaA8/myuf6PbJ4GpDwBRra17/1K7HubB3Gm6mf1IBT3uVtGtTv+sTq0dkJ
	reTiGgnBYaJfTAERsLyk2pFXJhMpDwgEsK8iYqUAOdId0CADeOL8EFJ0kSHMJdOI
	XsTBYBXx1SEEeLjatpxzRA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xw1bt89h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jan 2025 12:41:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 506CDvtf025483;
	Mon, 6 Jan 2025 12:41:47 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xue7fqsm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jan 2025 12:41:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ufZC+hUoG39sX5t1/bWPPDUsqgAXaelohQq1nuw/UD01LFzXjZdGEhEEOlJGbau7uoYxkfM4n34ZoSEQYBxVEFIIlR9yrS6H2fxhUdWwfAgaiMzjTLsT4dm+K35RQ8dSutAkd7u0pUBPm6roEjbZaYwbYDTK9fc6jbluZKw+/XvHAT7POYtCzooqf1TuYCz9NUNgJ9TaKN4ZSmSwwUZB5V4cMu26bgDonEO0OUEN0f1X+Npy3eX1BtlEpmIgl25wMYpjQYqwQTtFHZpj8Z/IX0Jpgq71ycjyD7n8KT52Fstc82NRhaGGaLlTXAYmAlV9Is9vX4sg07AGNITXCSkCMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9RvRaCj1qXoc71O+4ar8RblUY1mnlIDr1xYBjAFSGms=;
 b=x8fAHmf341hy+ig4SJxAKxR27MeYu1sAo3XwUfHLARyGwi9X4J0h8yx06PQmQWOxZdMLwS68kyoIpG6KaPD4OS0v8nDIFLdzkh/GrCbEbXgiCMUiG6fFPN+fYLOz11yMs4K+ZfsgRAqxwi9h/o+R8U81hdfz3vjRwQknjnKVOdmeX6CvW20I8xQMCQJsKa4YU3mFQFW/VRG+ge+Q5zn49A9gQbDdK1W6cUmHuyoxshxSgPrrY5wKTQMLIssbpuf8FKWeifh+D5kyQQqPoECRWwxuVstBhBdhFYkvzuzeq1nplo8N2yzVJzMbQ6NJ9y8OMxYlK7Q6KF9q+aLGbwJxbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9RvRaCj1qXoc71O+4ar8RblUY1mnlIDr1xYBjAFSGms=;
 b=VfD4V+7ln9C+g6nQJ63BiCS6oROemfo9A2dTubSuA9ZOcaGHDxw+TKlNPPVIZ3expTwl1r1sPXo/ILJcqo8HqmXh/ZFKlSBURcKXFj/MjZ6vLz2f7C4FyptDd+J6hxtK84UAURsjt+U5uzAd32tHAuaY5R0ctu8K9b9dVW0wom0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA1PR10MB7662.namprd10.prod.outlook.com (2603:10b6:806:386::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 12:41:40 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8314.012; Mon, 6 Jan 2025
 12:41:40 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, hch@lst.de
Cc: mpatocka@redhat.com, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC 5/5] dm-linear: Enable atomic writes
Date: Mon,  6 Jan 2025 12:41:19 +0000
Message-Id: <20250106124119.1318428-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250106124119.1318428-1-john.g.garry@oracle.com>
References: <20250106124119.1318428-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: IA1P220CA0022.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:464::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA1PR10MB7662:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f1fe892-a1f8-4bc2-a1cb-08dd2e4f77f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uNkpxNNZ+eV8t06ypyvV4/K0atKIvFpNNpU0zEulRceK2EMenCV6Ii2aG8mQ?=
 =?us-ascii?Q?YXrqEb5wDLZaouxT+55m96lrDALrsNPaSowrD3KnpD3SBvyI3W4oMO9Ukne6?=
 =?us-ascii?Q?uwW8YaXveCMvGF+1d6MreBQ+rrbaVp1X9EwvIdJPgd17zUFLjLVaL/Ulqb6E?=
 =?us-ascii?Q?PP6ehFUz27BBlPScoLySCR/hoRWFRbMWNMwV0ZCeTvYxfuoUO8oNkzzLXPIb?=
 =?us-ascii?Q?B+rTgGeQZgLrPlJLxFbzc1rIFXYFR7jfiOSdaNCRY4HThFXSIjv8D9DGRQiq?=
 =?us-ascii?Q?NQQvIIMArZmwrXrBQJHdVBiPphrXQlDHhF7SKl4pE/Xvyb4XBzcTu1X+BQA+?=
 =?us-ascii?Q?+LaPhYMu6ZWaBBcizDd8fyVilbXOTN3rtcT4VTWXNskrvNqOP/2/6MZZn3/6?=
 =?us-ascii?Q?L/1IoXacYjYQ42VP/fJLIUrZjQb6YtdSi7J5jQ9oEs0Z8eRJBM4iR0dkaJ6m?=
 =?us-ascii?Q?YNxAgN4qvmcKSVz6565Wa1DGZNHUW2Vtv+LL8IdiHbktZQAIKoBn6ZfbgnqO?=
 =?us-ascii?Q?RuLbBj0V+XVxoLZNbnHgFhFrKzc0+/UAamnSvLJcTAryd5AoIALavRTd/2CU?=
 =?us-ascii?Q?kg80At6Og4bc9pzOSKLtHo0eUnjUzl55MZbu9C5OVJclUVmWKE0kddpQTVtC?=
 =?us-ascii?Q?H1HVfEON0GRKT3GK9LlhgJRQrQoYzAQh4Bkx0skFM7rM7BtD7ky13vSviRSs?=
 =?us-ascii?Q?oVMuIdwudRdWCXF/rkFh4a1iMci3Zi37TdEfE+8FHFyVxZkoGsSiOPd4zwIy?=
 =?us-ascii?Q?AgRfwtfTID8wWsWNKwGLy6W1SMb8aKbdztBei9Lhot0nLzzz54Ds0XarBRMj?=
 =?us-ascii?Q?p8MU1aV1KRSEc+oO78Xsdbt9N57chg4va17Wes6xKSiXyYnVhtIbzZrYQzCL?=
 =?us-ascii?Q?RVgkgmaELuHbNAt1+nR+z7FBo60QvN/fOfg+Cu/gfgytp+YuH0TSRAdtig8u?=
 =?us-ascii?Q?PorKjKguL4YOFVRcHWq1eL+riNxoJ1qnHZLtw559KP8pqnjmAXgLKHSqhkJZ?=
 =?us-ascii?Q?8wbJ57XhZMJsnnk4rBMC0DIfptX3cc+v/x6GBjtR2Cg/GWZwnuy+GSyjIHT3?=
 =?us-ascii?Q?JXvL1484phqQKpxNA3d/lNT6KAtFJ02Tq0XcRBcaUStTdTVOgsDfJ5DAd1Xc?=
 =?us-ascii?Q?n8g7VdE6iBpeMvqOhp/uK1os8QPmmzQUmsdbJp40aZ8Tj0t8HwJ3ebfxB5EX?=
 =?us-ascii?Q?7p0RkBcjWRIWNKxxxIqNuj1YjARGAcHJ2jWXReX/oy8jT2q3RyVbeGrDDoEr?=
 =?us-ascii?Q?LeEpkGatnyAB0sf8BqBK6D9Y5CeHqKO2lH2rTbwhEhzmm+ye9SgoNIzuZAod?=
 =?us-ascii?Q?Uy4a7wOBl0Y+bi4NaPEYfrAnl1E1EdMvk9Ts0Cr5Pk7ZFU7wLryY3qlUOKxE?=
 =?us-ascii?Q?ATdSjisKQQpgQgQ1JK6/Mv4a1CY3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5UG3qfoRMXAyuW8jBttVj59TejxThXvRQ3K0R5mTKRGrS78CfJn1ifXiS7EV?=
 =?us-ascii?Q?lVjV3oOi3ZfPOX3fnqyhvLIG1LWQblR0W0MORANdv5reeAPNkDZzOy5chOp6?=
 =?us-ascii?Q?jb/qkZeAaVDNkxk5/k+K5DpVPZZiiMLKnfDQV/FBq86lCAY0VG2LgTeayvk2?=
 =?us-ascii?Q?USEIdv5+F+Pn1daAaReiTMtI2QDgeEg4o2YuQlJYANF5DNbNxKIzYj3tVxa/?=
 =?us-ascii?Q?fFqhPuJHIrGeUW1QhyCM2FUm1xHRsVPx6/MK1ZuzeNiwzV/nxmavAL4nswjd?=
 =?us-ascii?Q?hV4gM4zEBNca9nTBpPdL80i3fvOq0j96A4MRXKZpyuARABVQNH/dF+kEbngO?=
 =?us-ascii?Q?E2gm2aiMBRfQXH8VBAy5DSeDtKITMFZOjTocWbQ90jCOI68b/Nf+OtNL48ii?=
 =?us-ascii?Q?MOaCvPccaIf4gbCp1J4vn4ZW9YbSvE7v2yraFmOWii3ioQic+VW4ogKTzSGN?=
 =?us-ascii?Q?wRDTs3aR+BQ9HXvo7+M6HEh3zpCujP4w7VC2RGJYVHau1mvxwCjrdphL6CIn?=
 =?us-ascii?Q?2j+FJOaV3tRcpY+kw3cyVrVLDgVHRyri2hCiCc2s6cdnILqdaYBT4v1bj4RN?=
 =?us-ascii?Q?gjOP8wk+YeSnwmwLqwKC+a4zu5Fq1rUwLGFZjg+6QLPbDPS7gpmftvwMXa/9?=
 =?us-ascii?Q?n2mZT9uNBIr0u9fzG6g6KN+Zq3hq+hwBKZiDkA34mOcGHCUhP8/XdEsKUsQY?=
 =?us-ascii?Q?5lYY5Kc51Tx4LDJhI7QjRF0IXlV9LzQDavSNQnOQqAmUbwHTLP/2K2TXFb90?=
 =?us-ascii?Q?GHMfODM3wkdXrZ0BZ8zy+bm/QrwFhM6eHqaA8qMpK2k1+WZsVvd/x00fjzmf?=
 =?us-ascii?Q?0NFnV5IjiuSJeIZk9t+V81ruo15y7Fpv3IBLbg9sxhfQifchTVZ5fJNWoijr?=
 =?us-ascii?Q?T+8CW9PugA0Wq8B0UZZGoKAtM4lCoar7TQPbdUo8vsgVbt+sa2a7Nmdh4nPX?=
 =?us-ascii?Q?bg+8Axxrg3vgW4oo6tiQAGTqOZ8c3kBRC4NLwS/6oIJ6Y5zhTbF8aH8seFn7?=
 =?us-ascii?Q?YBFw1QBcyoI5FBqIEy3/2IAmFRqqXdw11lpt7LFk6DgcQPorvqT3AlyBcat/?=
 =?us-ascii?Q?LXlCEAtWRyFJyBWCAquEtiMkq99kDitFo1e4CI5Z181G7hsxcJbARTvP93sp?=
 =?us-ascii?Q?dD10CMNEy38tAgk/r6k7UhZ5nMSUbN2EX+G5HPqBiaDXCVBFVtu1RcrRRaxZ?=
 =?us-ascii?Q?iAhDS8Z5ajraJ4EX+HuQq0jSxNZcizaOP2WCIcrdWKA0AbxMtPH1KKD/dUO5?=
 =?us-ascii?Q?rjravFcb92HHb/WRJVNwpBzOMkFRYXYxihN0N4wb9rhf+wm7iUk+QMY9QoxY?=
 =?us-ascii?Q?K+/wWlslSZRhZsq/QJvh2OvrBF56c9pQKpYHVVsGwBU9PTmm6S4l2OT3CXIj?=
 =?us-ascii?Q?0NLsjh5z/2gsA5/0LZ6MnX4vGx0Exdh8052DrNYGyaizS0HMbi9vn6qZJT9B?=
 =?us-ascii?Q?SQkOcOD4UDfiMH9eyrIxQgi3gHFfGUo/7mCyAlZgijNc4S77UvDuD21cuuPU?=
 =?us-ascii?Q?7BKLw7Sa1ystQ+5tcuSBWKFOGSbw8UiMCP1R1tV6P+11KoroBrsHxYq9uTG+?=
 =?us-ascii?Q?yEjaj4Ih/GDFeLSOEcT3oFs4mgavFB0PVksRsw/RQChKpWw2zCcWAPBrW2Ru?=
 =?us-ascii?Q?dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eonB3a2tOGF2y/8hF5aHvfcnLD/W4+POjIYgaunimYQuPfcepHJtOFHeBlL+ZQoHOqMBBsUk/4i+DSMgg9fbGTA+GS7+SnGhxdW1q8aK5PmNHl+w0G5cSwyNJsDcbdGoJzrN7LU5xkSpgLdQdbFTAEHiDm7EIXKMTHjet3qOy+M0vG54DCCUOiKYW2hEDjtec84w9Y1bWvo99wBlj3wqbdqv4eU7BRRkzYvHmnBwrQCnWAjVf3fiKe5Xby07ETbuPevbZ5Agn01/m5hMBvexh7jb6e5vrLnVMGPAy175RGGdQvmePXmNtRWRdnWQOThgWNxRB3VKGSGoFi8GuMYIrZhCTKPxEgdQBk2JRwcWK2xZLMaKjomYwpJP0+uG8VvsnyzRzrJlyDIwFXbOQxZYqySas/IPVBdNc6z9QN+mLOhUz0YlUN5XO8o4mZJ/vyqpHissZgOPX5ipTOKvTLw1S1cl5v++dPeOeMnzvtFC4eYOTu6Gr/066gHl4EGk+Rq/PnTfSP0PwBAvEX1sO6L5FDY0oGEe6bwfpWvnx8+OtKpEkQthTt+RtmOLM162RRLThyNfGpjVc9bsXIdF6w+3L+bYfziLYwouf48AS41t4lg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f1fe892-a1f8-4bc2-a1cb-08dd2e4f77f4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 12:41:40.7248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3DzjySxSPu1Ylwqfo02SMY0hWUhQkqQ3VYl4WIvOmrnvmOiLLsbbvpyfgYAm9+TXvPe8gowcRcVRguIn+XTEeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7662
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-06_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501060112
X-Proofpoint-ORIG-GUID: EAr-9VNoip4aDbQz7MWb1GIyy3mcokGy
X-Proofpoint-GUID: EAr-9VNoip4aDbQz7MWb1GIyy3mcokGy

Set feature flag DM_TARGET_ATOMIC_WRITES.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/dm-linear.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 49fb0f684193..351f4ee83997 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -201,7 +201,8 @@ static struct target_type linear_target = {
 	.name   = "linear",
 	.version = {1, 4, 0},
 	.features = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_NOWAIT |
-		    DM_TARGET_ZONED_HM | DM_TARGET_PASSES_CRYPTO,
+		    DM_TARGET_ZONED_HM | DM_TARGET_PASSES_CRYPTO |
+		    DM_TARGET_ATOMIC_WRITES,
 	.report_zones = linear_report_zones,
 	.module = THIS_MODULE,
 	.ctr    = linear_ctr,
-- 
2.31.1

