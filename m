Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C49A27F016
	for <dm-devel@lists.linux.dev>; Wed, 18 Jun 2025 08:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750235894; cv=fail; b=P6RYDbFMFvB1wrhj7YU6Pd4LDLKSimR8XPLO7oEQCKb5C831EYDY1eMwCGrhRkx7ZDKwyhbmTkTIu+X+wWNV+HLNI+23fQCnp8ldI1zHet0CeZ7XCTinEGSnFYx57cF3mAL5u9kJUo+Obi7+0BJboOXnxzT7qf6Ddh5fFQyyTiw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750235894; c=relaxed/simple;
	bh=QB+9CXPm5tBc17OTDmaS/MthrzZd7jrd7VTrE8pdbqo=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=VtCn/iAatJBq/hYtKxf3a4m2099/GUKNCgMMjI+lteaGB1kne4vnHu0TyuH4Fr5ow60PvDcXAaintPsuzCRmngPPLR8jzX3xpVCilld6tOezhxDP/6uuttarsvAaKbGNGTpZr9LPyF7NLdNQcW5LC4UznC34mi4OJq4jrolaqtg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QzwZ8Oo8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=B1juB1JF; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QzwZ8Oo8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="B1juB1JF"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55I7GvSr015247;
	Wed, 18 Jun 2025 08:38:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=Pu+XVwJgdeN0DZBd
	EsWcv/XZ0YgnmH4PI9FBFkoV+gI=; b=QzwZ8Oo8Fjl0fqHB9o5oYz49h6XShRNL
	zYKKQ5+nDH3ILCPROheZANz0mGIxjrUiIERUnldqYI7PhcvPD79YX0dI1E+EK5+W
	8uJmMDk0HfCMLUgvH70DdDbTbvkiOyllbks23TOnGiXETJr9/34Wp2LglJtmxu40
	QYBgMe5Faf0TmeVKipbdTAR9Fc/0mCrQccIOUxRDzEmX3HqwPXK2zSLdGlqCrkSP
	MTT/4LaoyHh0N7kCkcVAzKK/TfF+o/q0pkJYmu+dxmK+uZ5j3kyMFy+ZbufEqGLd
	zSUqIlzKNX/yoLaD+cBVXdvQzfShkon93HDBcVtNspuY6VrZpRFgbg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47914eq9ge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Jun 2025 08:37:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55I8bCNC034444;
	Wed, 18 Jun 2025 08:37:58 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 478yha4as7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Jun 2025 08:37:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ElAXGenZIYfC4uS4pl66lVvKICrSD71UkBzZtQx9yV5xbTbQnWl/MdL4X8Wz+VelJxQgK+Pf013YKdPjG1ONT6cFfZVUD2QmiYeA+CZ/QLvFrwO73/F5Dupwnp7rJGjnmMHlbc6o6Kx0wAcVbRdcrkQ+BADhHxxqg19zffbFErtKn0qtL20yLviWOtyIXS/BmGs7bnP6US6E7edBDwTtjnRSMKqPdCMS4A6ZgCZ3UZ8HEduksL3o8w9cuhQh751LZCKGxdxQrPderav89LloRUmbuQiCAoFUJMAaoq6VWe0AHoE/GkPn599oANec3Re672noGFfXs4vG+nTztoB3QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pu+XVwJgdeN0DZBdEsWcv/XZ0YgnmH4PI9FBFkoV+gI=;
 b=ThthM2tmy5OFyNpgBQgQQXZ+8PcL7MYsPxbMvhqI3ppDgxQlxGav0As3HDOfH0IZMbqtEhyM8PvO+zM3Ly6CICY4eTrzThadr1lprIeJ+OTTIT2abadkORCgICyct6v3rQGhRS0XtG+BC2sqXK0txX6yIHFfVH8SFrn/Hg2ZXSgmUaxVpNeLcb4TC8ccSlLQ0CeRPEFovK2dx1FgK6Z6ddSA4fsfTAafza7j9xku7JNdo3M5e4oY0mWlV9wOjFWYdvYJO2J82gJpod0/tpn+7rMgS8XX5maZo9S0uJBa0LAPlSfbyBq6hyzt8H8ab+brfxxcvgdLhamwk4e79pBC7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pu+XVwJgdeN0DZBdEsWcv/XZ0YgnmH4PI9FBFkoV+gI=;
 b=B1juB1JFIhMvRvfgJ/WeihEWD5ZxPkGIp6Q9CLr4NgboBfjdQG94cgtkuWA4j4jYjUDwZPcviR1y2Xd5jy2SlnINMLy8VwoAR29xVBUR+lvQES9bEhtM+/SoFLrnVZN/WKjIc/h9HdDCtg5ImLlMQBD2p/UBijo1j1BScny40UE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV3PR10MB7769.namprd10.prod.outlook.com (2603:10b6:408:1b7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 18 Jun
 2025 08:37:55 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 08:37:54 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 0/5] block/md/dm: set chunk_sectors from stacked dev stripe size
Date: Wed, 18 Jun 2025 08:37:32 +0000
Message-Id: <20250618083737.4084373-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0055.namprd07.prod.outlook.com
 (2603:10b6:a03:60::32) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV3PR10MB7769:EE_
X-MS-Office365-Filtering-Correlation-Id: 227ee85f-8528-4c32-7607-08ddae436b69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kHsOUs9iB25xf2QyUer9K/De777+RyDLSLHmLFSmqOsCTC24ZFtweMN3gwzC?=
 =?us-ascii?Q?SpM3MdKbkKgsPFSUMvu9MKzQzuEiVajV8ltd0rmMkW7qCUXyNSTu7tcjvtWf?=
 =?us-ascii?Q?mxowcGfD4NzvcLYG0P1zA3M6HdSMk0ukYGFc5+btk0Am8n9I6a07ZfPNRsZc?=
 =?us-ascii?Q?pEWw5zlHhSt/j9tii9xAXlw4bbMWLkoq6y1FDb6R+iG8t7QuWFi/vxXRLE4T?=
 =?us-ascii?Q?5gGyMfp+Nr7CgYsnuhx77x2ZNudDQNvJ6MSJQUwAIYIBFjEFdBWS002yVHC1?=
 =?us-ascii?Q?ZtsyCJbifsmBbi9BTI4oH4QPHfVjROFT6U0fu2Qt2J7WgmL/I19zflivnrPZ?=
 =?us-ascii?Q?aBa+3SzNTF96R6BPBa+9B850rkJsWgYDid+OpHe/Fch4wrAgw11cWhkwDopO?=
 =?us-ascii?Q?W6wzh9eZtZJC4xsH/6sJfZCiKbJE3CBfG6f/xcbBX6tHXUsOkZTTe2xKJGrR?=
 =?us-ascii?Q?p+ALDoK1S+8+xPz0roWIvHQGYdnllbndBo/62xZQ8bNng/v/PriSvaEaa8kp?=
 =?us-ascii?Q?vO519bnpOSxZSfjhP5Yyo5O3NwY6uSRniIonG61fk4pes5VGHmaSM7D9hqV9?=
 =?us-ascii?Q?PgTohnivW7uZUFstVevmV/i8iAZ4IPQ+pQbwapRnXkoMTD74BqrFRdmqfOFg?=
 =?us-ascii?Q?Qp8urOSeYyzhUo4Q5U0s4ABOvADG4yHFwF2H3qMP7bR52IkDUms/KcgSmoKz?=
 =?us-ascii?Q?H9o0XlvayPGcptjA+x69wwBpUZ0ZhbzuwSx2SGiQ/ugGuEKtTPPW5aW+zRDC?=
 =?us-ascii?Q?YtrG6m/QHAX7VWmnJ3SEH+LRIzesAOqSMmckHeBHP+W57FL2R/DizoJzHFgH?=
 =?us-ascii?Q?UqJ5uRJ8G93/4U5jis8WBKYn002WSLT9EuuQE6FBIMhJc1tPvE2IXrBOAf5t?=
 =?us-ascii?Q?JsI1oUeT1clkRoQ8RYYcNiBApIAlSK9cWO32lTqZm1zlDK7XYNuCJL4t3Pmt?=
 =?us-ascii?Q?zGdC5S4Rd73kn8f3kRmrmrvYnGG7bk7BloC3erUUouao0o02NwKiAu8oQO05?=
 =?us-ascii?Q?BOy+ZPcmZWzD1AjL/qHniaIchKQ75AsoX2bzeiRq6NTnRNSNuDWhdLZZ0oa/?=
 =?us-ascii?Q?daPaNAXaFKTEGuinA5B92zUwFOIqH+2yNy2CVGGcwA6i6qc7nJDFfocb21Lx?=
 =?us-ascii?Q?8dHVndxOwVZx6Tc5kDHrJw3gryEd1jaK/ebwy+yvX9dUDIaeKzM/EpG0S4pZ?=
 =?us-ascii?Q?TOeIAAGRTQoo575lUBGhO6QswpX6shZWDNA4eM5oCxL+y7jGRl3TlbdljFeL?=
 =?us-ascii?Q?mALNYkwlp705MAY6U4WaZpyFByWadiiCvRwH12oJcjnSmCWKe6fC3V9JO3q9?=
 =?us-ascii?Q?KrWT9b/KWHL1YwcqKaTCQKeKTJ51l8OvhCC4ZFbg+EXROewVZpOOsU1yNC9D?=
 =?us-ascii?Q?L3D69yFMzrcWev2alH+clnibw9BI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?t51F9Uj0aqui84U+yI036n3Yy6lLlUU5iCp/v28+sAW5ZCw7ZKj6FI9C5B/L?=
 =?us-ascii?Q?YS8LiZLU9yqcBK1gKXJWPReiT0GTqzj7zw8X53OraYkHYSUZsEWOAXfibPSJ?=
 =?us-ascii?Q?1otcNsln3qfYQ/CGyBWmUtvBgVKu9nlDyX617z49LjVN460IJDRfp109MNqt?=
 =?us-ascii?Q?qfj20Rh+SkAJWusWgvQJWPwgiGyiO7ITeCLEk6qLxtOBSm8k3wDYGTzSwZmw?=
 =?us-ascii?Q?AlBZ3RwHryzR7Plkf083a9P3z9dTQA9cw8+6utoxRJXTaGZ+TAjbZgJvdAij?=
 =?us-ascii?Q?+VLeXzlV7YYtzXh9yVC8eCXliIADAtBR4UjELVKP/bFU8FhE+CkXu069h35Z?=
 =?us-ascii?Q?/BNQIWb4+7soefYshwMhFSxoYs7Bu7AbhO+gJZoGPlHKWu0k66rbcDyfshqG?=
 =?us-ascii?Q?x/5N3+AI67ylTzH6epdDSQgwPl3lTaHr1udj7xR6erZ+Gpl7XuHo5XtvDTQF?=
 =?us-ascii?Q?7F/gzc6nMC1chLeJ6WC5OTiFgzzE3IaHPwgj+7lcVKpwqE8hG2l+JHjK9viI?=
 =?us-ascii?Q?fsJXCofRHgSS6V88k+mZgsacGRTyN2sf93pYAEtn1ZDVJVTEGahECeYFOFIC?=
 =?us-ascii?Q?60A/MsAi3KA0S9PzvaYVEETZPv/ddPAwwom3N7NXPqXUv7RYADCmkDZ2phsM?=
 =?us-ascii?Q?wbHqfo/B4lEUAPAFqWCLWkHPPUYknv96DsGGD3PKXkBgSum1lyXqsQyvXk7N?=
 =?us-ascii?Q?VjxT74GurLAFb6QUXQcL2p8VciSsJBSU057TQN7BTnWMak6Z2L/TAFTI42mM?=
 =?us-ascii?Q?gE8yHX3nKQqYlP3pnk9WXDINlPX8W9bEvj8tFD+lEkx6D8g2Ey3h2rqrqyCm?=
 =?us-ascii?Q?Q4n66qeBgBd5omfImIYqTYzYR+GZPJuq6DQ5dMxDJphAsV8zkJ58rXTY2Xqr?=
 =?us-ascii?Q?dMPxR3ToudZw7D/l6s9TNFheyXKzZkX0P/f3bIKtgzG3Eni/BTEz8OqBj6VV?=
 =?us-ascii?Q?pUP4gGIwX4QCOges6MB8Pzyv9LHv3MIyEVGnei3m6nO3bG0mbSeC6dADycv+?=
 =?us-ascii?Q?UQxqVg7JhcjpMYh8RhrF9RKTyY4u4yzk9o9DDN8nTe17VHypungk/nIMVd81?=
 =?us-ascii?Q?7421r+tOjD0JfljLcXeEnxoKsD1cD2lKSVAdrk/T9PF+POhCrlu58mQTH+nP?=
 =?us-ascii?Q?b3K1gFZ+ooIdLpg3AVKWdU8aIKVcovdKFLTu7DHAyxpUmN6LJW47BO86myrs?=
 =?us-ascii?Q?ggNZtDj2Qp6L0+b2aPhTPuXJWml6eGZWqIxuOYzmgfeov2+uX8o2HDWL0rNE?=
 =?us-ascii?Q?Os7UjzmzfxbUjYWHa+y/eyzTcTCqj5ysewYKpXF5UiwVN3KFcLGTsWhzCc4o?=
 =?us-ascii?Q?CSIMG9Ir34hm5onZNKFETtT8KjFe3hitnYGo9zxbyPV1/0ownAowxI8anUxB?=
 =?us-ascii?Q?PR8G+0PhVUHlg/V41/42MiAZliSz7AHzcb0wWFAu9qlHRJWIpDUs0lr4lMFb?=
 =?us-ascii?Q?G/A4ClE2dSPpXLFhu8BEwKBlCaQ0iClWUaCx9/oxq8BFq77+eZNlnMjgH1Wk?=
 =?us-ascii?Q?xp0yHHRMLHaVjkwJk4D0Z3lthqsXYdRrmRKbel65XfaEMlH1SiF5G+uMNTWI?=
 =?us-ascii?Q?YiE8sU7uhAJr73WcNSOb1LC5RMjxZdsd93HmygjlNlyBmS8sfdiV6+mIih4T?=
 =?us-ascii?Q?DA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NCohP8Fvi1K7SkVKzlMgkyAG0+hOJUW4qphwD3vFuLjJ//0X8XbqPuYWVA6XIbQfEpF81lQoEk9hSkG6lF4PYYMMJ5eypHarj6Z1wU1+xjtro8ZQ5eWE57w6L29++Ckad/h4GPzkVcP3j7M+bJqNu1YxnZXGPobP4IjUkuATizy7c7pSZi2smjcJjTMamMNUCWiAOTbPtKTTvq0iPbSK8HouUJTns+5JUvAJoL7PzX6m1cWDzJxlsq5jFIL511NDDYMGk39yAKLuTSXNvlj9sPTAXfRXOdKSIY2u3Mug0vuOXjdIj9+UatzphU5K4b7FhTprXNqPJho2BBVgFMci+orc1t2ghz1bCn/mHZ2lk1YsprmNpFPVZXE+Bpnkvsw6Skuu77RnuJGO1d5/BkbdM/ysqpbtVJFJyJ6jC2odxkkKTYV+mCdP6PJEsd0IVb1x+l7gUUaII8C6xgJTYNg2LxYyyDUmumo+1MRf9lr0MDVsf3k5MyPUfgE2TSEb4rstpkdwy5CVgedLTStRw9tHC37cqM/GUFMyS6DLoOAg4GKgMh7wfstPy7HTWb5pWp8OhHxpDtSpoczfNwnEbf0md1NBqRSftwzeBknPqzC4JmY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 227ee85f-8528-4c32-7607-08ddae436b69
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 08:37:54.8236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YKIzYE6tWrWZ0xJMJtufNUuUArvh1yigLJk3X6jlbY5z5uZH/tT2HKPnHnS7ytA/sV+I+ejcUdpfmAQso0XiPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7769
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-18_03,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506180073
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE4MDA3NCBTYWx0ZWRfX99f5ZLFkTrCt qLDk5eFaM4fC30cg8jXuomoN8r3mtrdiQtJB1C4yFLG0fVxTyGsjXAfhj9MaCUAtmvAWELgs7hR oPt+IYZYYZYr0uORAzDII6+Hh+HVOuQ7O2UCQSt2N4BFdrTGfjdifXUjHMuyuMCclD9EzZZyOj1
 KOcqigxdqyMMhXXJsfqC8QCNKfzaBBg22cDI/IMs2TiEWtT9htswezdaEg/Xva0Eo9ofGWc6bTJ mDTemdnqYfXjUkKqpCoyn65f7P78Ij1ayx3dzyl47iPvTqRTpZL4u6SnLH7R4MQRF/IFk7BQUh0 dD91KaYEAndaVtz7SdvLDOx/ewnalKgRRIn/Y1/170eL06lzfdQ0Sga80z/NlIZL+wUJ3vrZDfr
 ss4ESv4nOYisgiNQ/YFmKZTyjTaquft5O68s0YXCGj8WJqPryQl9Rd8T+EEDBf6guM4FzfWB
X-Authority-Analysis: v=2.4 cv=U4CSDfru c=1 sm=1 tr=0 ts=68527ae8 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=U5J2MVZqgsNsGrsRRvEA:9
X-Proofpoint-GUID: pe2EVuDXshAgbL8olb4CYsAkMqDBUaDw
X-Proofpoint-ORIG-GUID: pe2EVuDXshAgbL8olb4CYsAkMqDBUaDw

This value in io_min is used to configure any atomic write limit for the
stacked device. The idea is that the atomic write unit max is a
power-of-2 factor of the stripe size, and the stripe size is available
in io_min.

Using io_min causes issues, as:
a. it may be mutated
b. the check for io_min being set for determining if we are dealing with
a striped device is hard to get right, as reported in [0].

This series now sets chunk_sectors limit to share stripe size.

[0] https://lore.kernel.org/linux-block/888f3b1d-7817-4007-b3b3-1a2ea04df771@linux.ibm.com/T/#mecca17129f72811137d3c2f1e477634e77f06781

Based on v6.16-rc2

Differences to RFC:
- sanitize chunk_sectors for atomic write limits
- set chunk_sectors in stripe_io_hints()

John Garry (5):
  block: sanitize chunk_sectors for atomic write limits
  md/raid0: set chunk_sectors limit
  md/raid10: set chunk_sectors limit
  dm-stripe: limit chunk_sectors to the stripe size
  block: use chunk_sectors when evaluating stacked atomic write limits

 block/blk-settings.c   | 60 ++++++++++++++++++++++++++----------------
 drivers/md/dm-stripe.c |  1 +
 drivers/md/raid0.c     |  1 +
 drivers/md/raid10.c    |  1 +
 4 files changed, 40 insertions(+), 23 deletions(-)

-- 
2.31.1

