Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00261DD520
	for <dm-devel@lists.linux.dev>; Mon,  6 Jan 2025 12:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736167312; cv=fail; b=cZPkiZTIJ+/YUDeKV7PbLFLpH6BGGxtvBdSueoQxDOGlJedhHIl1X4SbedOkVEYPjAjG3+SrA5fUok1kPNyrf8MLms10JQ39fUCSEmFaB9ygL3G1gw1O4wPQshv9jLkoSIcN9XrtYcUUrw9qK+IAugg4LcLEETCH7MbJlBtaNBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736167312; c=relaxed/simple;
	bh=Jo4Uy+G5aNWhOE2ig8YZcDzEWNXOXl5ktbxFvOF5vZs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ejQCkIgjAO3RxEwLxZI9xahbYkkf0uxC+yd5fWGE0culUWFLkJK5RP3oR27vQbGIVgeKEeMBe2zYfA4wk1vTm4OuFyJ9XUFMz3s+Deo+wO9IrxAyJhps6vsF+DRNlY2TCAGcBPVsiEqNB3zkJQpxuEIVEGEDFZ95cfbgT+gnjJw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lfrfuZ5y; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Y23zLuPC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lfrfuZ5y";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Y23zLuPC"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5068tu8b011383;
	Mon, 6 Jan 2025 12:41:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=aadR7L0RRcg0fufZn+7824fps32TTXxFkguhgexSiQs=; b=
	lfrfuZ5yT2qof4GfDXTHJtp1+4q9wySdsbqCTVvkIOPAcmqbjTut0JJCY8mc2b/P
	aTY6Hzr3FbQZmstZfbISKfs0gRRh8sfNbChlFuSJqBKlkBCz4MTF8WJgu+JEeuWq
	Rkj6cSKUqCGCXa++UWOp+2JYxvEqU7hnwDb8JrANS2wzzuD77qsOr7jG9eGt8Vhx
	jl/cazp5LJeFFbZB7M+rAHvKIz20B2kMjJbPlID2LWHFbRTdmVMJiO+ZgfbVl+3l
	kPouj8GAFCpVOJuK9hRTrmgWfLyEuGD5ssEe4pNaZmvJ4md5Ib3M9u1w0w1mcKnd
	1SBz4+vB7TNYfJznn7LRtQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xudc2nma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jan 2025 12:41:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 506CRHYD022790;
	Mon, 6 Jan 2025 12:41:45 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xue77s52-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jan 2025 12:41:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n4QhAhnRTPDL984OM+9xc/XYQf2y8y4N2Sj43vD1yTwovos+fNm6n+MYqYbBniMbXmK4vbpodap4vDGDmS3TMakRklHgfWvlifGkSt3O93sfW+xaQ3p2Z3FFEjGUamiHnvyJ88Njb1riMCLH/Os698c3Hg3d3ya4f8UhSew9dCxq3vP1d04j8VRNYqBlAM5E5CNdygNNr50fni6K4CB9VA/IaiI/wj7dwYQh4iBVNCI0hxgPUgmv9CRD9WDUy5RenANttMHi19QLZ20SrblXiTzPhDgabHY0zEjtMb4YmFQJa56is3FUmAopc4G3XPzYX4EtQP7eO8agZLU5NmU36A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aadR7L0RRcg0fufZn+7824fps32TTXxFkguhgexSiQs=;
 b=yPDlEMHNY0G3IrqpwcjFsiGzK+qbv482koDPAXcZtSw1W6ZhyKFMrRXIskwDpYPaRnEfilC0XrIHRJKyP+A5KpYKNz/Znl6VhRTZYLYbHKK21kKA0kmw3VEk4bPsSvqjTwQKxwBhwkiJzKcnFrPgZ/DkbrX1r3W7Bvv7WCEwlXXVUMXLjf7hYBg+fJ9qmxb1IYnhVvX5iDPhP3DO7azeR/zgicVvsMn+73w+wo+QAd0UyrXdWqXK8ALNJf0hv469KC/uaVtvRBMO0NqIJ6QDYRHNjJ0heHjLO3ZBBa0HYxBLfxunE+2TmrPaXYqpEfxI8x7ZiBz5ZpEidXTRUJAOhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aadR7L0RRcg0fufZn+7824fps32TTXxFkguhgexSiQs=;
 b=Y23zLuPCLNmPYS/7YD800R8Hk1MG7N3YC10XoXvv5EIaqZOF2UxGK+Mdp4BoMVr34Tijt+vtKNXFwH8KRvVMOr9XR7WkVQy4zITViUp3XWXeib7XM8Sk9dPZGLLOBZbQ6YmPgC4RIMUn1ti1dBtclbTO2cqX3GeKI+AxSm3NjPQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA1PR10MB7662.namprd10.prod.outlook.com (2603:10b6:806:386::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 12:41:39 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8314.012; Mon, 6 Jan 2025
 12:41:38 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, hch@lst.de
Cc: mpatocka@redhat.com, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC 3/5] dm-table: Atomic writes support
Date: Mon,  6 Jan 2025 12:41:17 +0000
Message-Id: <20250106124119.1318428-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250106124119.1318428-1-john.g.garry@oracle.com>
References: <20250106124119.1318428-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9P223CA0028.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::33) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA1PR10MB7662:EE_
X-MS-Office365-Filtering-Correlation-Id: 28781f0b-f035-4f2d-de75-08dd2e4f7699
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ycv88d3xjkRI35YRtTUGYMwUu8A15JakzhOZC9K6AOOb29160KXATiAyZwJ/?=
 =?us-ascii?Q?ZWeAKuUkEhbMxuK7fCZWuuMrABywYmEU7fRaKzk8hvVKlhshE8JGzJiO6Q/i?=
 =?us-ascii?Q?NL6o1dlIKjg7OhWeaHlZaj7PPn3WKEh/cA7Tje8lvoMEgKijGHbF5eQONkmn?=
 =?us-ascii?Q?7t1QvQwMvq/Cetrk272RQU+355SzJGq30+GkT1xcmTbU0hXZnMNTSnPHAFV1?=
 =?us-ascii?Q?gxEtIa8MxzfpYCWcx0e31sHcIkwjr+MVprPio4qiTiIXe0skUtZCkWgfWPEs?=
 =?us-ascii?Q?zp7DfyaXJeFf+7GzuVd1kWvO7510M5SFCOk2mjQpAB/2ccKXnr9TWsCmH9MC?=
 =?us-ascii?Q?Zpd0nVLfDypHVb0Ju5P9Sn+h9wY52psqRRdQP8UR1fROdrr+ZW6ywbJ3v4fi?=
 =?us-ascii?Q?PuUZCqfmSf3bYgxq0GNcqoG8KaCdtFjdP9AIDweqiuaEAEg1uDZBwmJALZXW?=
 =?us-ascii?Q?mmbUpsl1zaRq7PI1fsR/7lc4dGnsgwfEfRpPE+Ys4mhd85JIo3jhHFj5PArK?=
 =?us-ascii?Q?flKU//Vct/jEBEOccqYm/HKVa0UOIUhW4D1F6v0XL79xb6d2cBDkw0tNTijy?=
 =?us-ascii?Q?SkP4tCSdUC6m7VkitP/HwBeOKdKy4zl9hEs5jVD95eU79dymdIz+PA5iiNlO?=
 =?us-ascii?Q?m7WPFDmlg35h8zkd/0CazyEUZ+814aOnLmbgdHj/0sCYzcQ0nBFSvjPSe+L4?=
 =?us-ascii?Q?pb7NdC3bROkxSabIU63XURpIjXHLhfn8Ybong44FoiRqV9K/8oz0OQS0ERQ4?=
 =?us-ascii?Q?uyC2p/SqrKhLo1OQVIWIdrvTZq62Zyb+G1Hbe69HkGUFJJDcM2JUHHIn9ogs?=
 =?us-ascii?Q?qWRM3XC9OvAeFFGnXRZQ1h+ZKr8QbE2KDatfhL5EdzaVpK/fJv2wO2uJCtxK?=
 =?us-ascii?Q?nRV21QKXp4Pt0pmW1b+FRWHot8EW4mR5ChDnznpdWqepZsKaF7weLM/jkX5U?=
 =?us-ascii?Q?7spGbADBDapF6M+2AAd+nI8cumCizQ7lHtXl+RqXeOyzcbqAqIrF75TzHw8J?=
 =?us-ascii?Q?N2lxxbxQ3qUqd+wne2WDHk9b6y/sK+lzTjb3VuVpJVXSgTwNFKZXcUlWCffP?=
 =?us-ascii?Q?YctBl2g1cneWgGRi2vusW6yj8+kPgKYVX2DSwHJHPwm3DxssAQNmlijQUG2c?=
 =?us-ascii?Q?H4kKS8H19AvSpfrQ6Fve7toz5jMzgIqbHEa5zIm9TWv3dwKShMhjLIyjlTf1?=
 =?us-ascii?Q?6dZBLG7+49Q4FZfHFK5tCReRTHmKnErS+MzdfijZRRg4Zzwz8U77wUcCBe3m?=
 =?us-ascii?Q?UtPTBEdEDoVXEtABIFPFquw7dUEWl1vezSHDsdVDQVA9ojXgfhax7YWh9CyS?=
 =?us-ascii?Q?8rw4dOgeAEPvI7yXqM8wOMV16jfCsq7mWPB8jArUu+X7qryHwoIyt6jQrs2T?=
 =?us-ascii?Q?4zdCsqnb/Oj8aNVG8G1VFjmKea4v?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yMIhMKWidE6IuJse0nE6basO0AQhYEEE4GetRkyeDw6pc4I9egqdxFbiYrBs?=
 =?us-ascii?Q?NpN532cqJpviatuoFjDjRrjriyzuLije1Qijj0wbgaIwPEJ2gCfKLfZQOn6k?=
 =?us-ascii?Q?nY9UowAwYLx1YQSU+mx8XhL0GhGMdXb7O9qghwiXgCvq1er6qNqFzTS5iTRp?=
 =?us-ascii?Q?z+EYSn6UbKzKyu61w90w+zkl6UP3/gcdtpB+uT1yHW6MTyoGJiCVB1tiWUps?=
 =?us-ascii?Q?6yXNJ01Ui12x/WeIZjnzR6WImn5Z2HCav99f2BBHVdabWlVfx3JiWqCBJiSS?=
 =?us-ascii?Q?7Nwl/a5KXTHg1uQ2HKTR+gqMfrwEGMD+wvPYzAEYn5P+vvf8ZtevHV+zQ2pK?=
 =?us-ascii?Q?MckIrE5QlLtZx/1DXrtuBIre0WsdSezrexn9RU2zAkssu8mwbal4+7qDPcUi?=
 =?us-ascii?Q?jdUg21oT7h0ipBmuPK33xzIVH5kF5URgi+qtCDriu6a5su2wy9GQiQX+As/4?=
 =?us-ascii?Q?hUyQ3RNcnsEi0PBb/lGahO+/d4hCvQLyfl8ATqP8mdDWvB5CeWg6q31y/N2y?=
 =?us-ascii?Q?Qz/2S8wt6UNxZR2O8BP95Bi8sJPg6LGe3AnNU/6LnSw9xncyrXMGOAwihFay?=
 =?us-ascii?Q?heKD2uHiSJxx7H4AGvCK7CpTobDjjvOa+RnbznV2xX0bXPCtIzRuOm8yGHvf?=
 =?us-ascii?Q?yBIbFATEp9cAt+x7o/HLvT7m7wPW09kyAmwMzpBPzaThgVTETZ4P1UPHQX32?=
 =?us-ascii?Q?Dr1u88tG0yv2bQnOyPDJe1nTN07NysN9CmRzKK6+Qi6cpDV9zMB3/qDWCepy?=
 =?us-ascii?Q?m+kWgiUjrtbhcB7DIAHYLblhQjMkQLFbulRmKXJit6XeNnaktbf5+PV7/uhR?=
 =?us-ascii?Q?3ti5ZJ3kkdd/AnnhJ9HhGfXrbxn/WjJHde1YTr7UYOlxdH0WIB2jCjAiSgyt?=
 =?us-ascii?Q?mQAWS0ZUcto1ISgutiQ96rnLrNtZgZTPzNJ0bsoZlJ+72BMfQE5+NECsqS7h?=
 =?us-ascii?Q?IBHDloTk4O5WPPHnAte2pUVwyNj64nSqVpc0a1aga7u6Bk+ZUEU7Kdfo6MlW?=
 =?us-ascii?Q?8U1Z0EVy19ufpDEH4qrTb4fUOAqBTXqz9Ot6Xr5CU4Ni8QM/pVTyT0ZEEsaE?=
 =?us-ascii?Q?Auh0K0JOSELKy2YtmmlpwgyGzKQ4tibi1NNrmHyFuVD21dJ1w3J3Lo4kHsBW?=
 =?us-ascii?Q?EzD0HHzogX/OiCp/2uYSgldC/jMvTNhfdkNMDgUU+2uiRr6qFfvMWX9BQyXp?=
 =?us-ascii?Q?Gb6AF2igt6HA4G5XyAGreCl4qik/agiVIJMxKBbeN+fB8079WFQEib5nr8C6?=
 =?us-ascii?Q?TqUooukVYOisnR5wHZBVd3o6/iacEuzE/Gj21fcFe1XZWHAyrsIlvNyMP568?=
 =?us-ascii?Q?WoBsdtitdTsb83BQGKjeErZF5O4kHoF8yeoAn0L6xAqXMU5R8ElUC7XPRkoD?=
 =?us-ascii?Q?Kzxq8RR/k4i1lK5M5oOVKryGqa/gYi8N3DtrPOoTTurA8QiOiGXRK3daBMc6?=
 =?us-ascii?Q?YR/SbEUdY69vdeDHLd9SqnpVnjmKpEtjFwwHGOVBZS6gGQVo8Ip9VyTLFFJt?=
 =?us-ascii?Q?jOw2/fTtAphxKKDE/LM7SP9BgNNr95hheErvi6P0AmC4McvwhCXhjMy+PV2j?=
 =?us-ascii?Q?RS/ifPwJY9L+olpg4CC/UZKgTYSxJV+eLXGiB6CTVjAxVQ3aYkpSthW7szyG?=
 =?us-ascii?Q?YQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jEM3PVcURqXaT8VPy6fEL9WgcA3BH3ABDrRJb1zzu4FvV4eQWIGpBjl7eu/43objn16vsa/A8ivoc9AN5h/mMFo6kpr7710D3FzNXxjrQ7SIZKfdw2wJm8lXaiJ+zdjSmGJKW7ZT4fdwYv7wefcgMN4xNTRs6oHQnR+zQYuW5Qinw/xg8RDBx2vUSjtypk3hHAwppK8BJGf5gJ6hcmcPCoEqVP0z2K+xJRNPinOKxZDFm5Xi+XTzW5oxv/OmwQXJa4Ma85xtRVGDtnFY43ZcGU+WYXHA/DXpljKV1dgF0GzpdW7WHKnpkt5oJzt84K0aEKawDWlyxwSpNVbgDqnHZlOFYLoXoggavbCP1z1xeBCpBgQMRpw58orUM9KNBuobZREwaGq2BgegGabmOql7wgEhb6tkyO2WgUADYp18xZmJnSO0L9yKzKhhXaf4DEHSrDUaORJC+p/nwxF342v2+19/N/l6TycjMX0Xnmasyq2KjgRfWyvRieIZcPOua4lA0BcuQJ0VOsxD6N0WzhVE2iOmtoywnrMdEAEwrJKbdTGlUROp097qp0X5ScD5TstFUeFy96c+VcAZUTzQRsPt/mCioYI2YNLMg3lg6/mGN1k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28781f0b-f035-4f2d-de75-08dd2e4f7699
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 12:41:38.4570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QCa7f83lLDEa9nJzb40PsBNiRD6z2ztUc1dgqi7QcSN6GnOE5uW3qLZZpRULcffi1mIrT/RRdB6T2kDlMM0kfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7662
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-06_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501060112
X-Proofpoint-ORIG-GUID: LLQ_ODkX3ibUA-hVa1U5-4R4psDLlcb7
X-Proofpoint-GUID: LLQ_ODkX3ibUA-hVa1U5-4R4psDLlcb7

Support stacking atomic write limits for DM devices.

All the pre-existing code in blk_stack_atomic_writes_limits() already takes
care of finding the aggregate limits from the bottom devices.

Feature flag DM_TARGET_ATOMIC_WRITES is introduced so that atomic writes
can be enabled on personalities selectively. This is to ensure that atomic
writes are only enabled when verified to be working properly (for a
specific personality). In addition, it just may not make sense to enable
atomic writes on some personalities (so this flag also helps there).

When testing for bottom device atomic writes support, only the bdev
queue limits are tested. There is no need to test the bottom bdev
start sector (like which bdev_can_atomic_write() does), as this would
already be checked in the dm_calculate_queue_limits() -> ..
iterate_devices() -> dm_set_device_limits() -> blk_stack_limits()
callchain.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/dm-table.c         | 12 ++++++++++++
 include/linux/device-mapper.h |  3 +++
 2 files changed, 15 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index bd8b796ae683..1e0b7e364546 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1593,6 +1593,7 @@ int dm_calculate_queue_limits(struct dm_table *t,
 	struct queue_limits ti_limits;
 	unsigned int zone_sectors = 0;
 	bool zoned = false;
+	bool atomic_writes = true;
 
 	dm_set_stacking_limits(limits);
 
@@ -1602,8 +1603,12 @@ int dm_calculate_queue_limits(struct dm_table *t,
 
 		if (!dm_target_passes_integrity(ti->type))
 			t->integrity_supported = false;
+		if (!dm_target_supports_atomic_writes(ti->type))
+			atomic_writes = false;
 	}
 
+	if (atomic_writes)
+		limits->features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
 	for (unsigned int i = 0; i < t->num_targets; i++) {
 		struct dm_target *ti = dm_table_get_target(t, i);
 
@@ -1616,6 +1621,13 @@ int dm_calculate_queue_limits(struct dm_table *t,
 			goto combine_limits;
 		}
 
+		/*
+		 * dm_set_device_limits() -> blk_stack_limits() considers
+		 * ti_limits as 'top', so set BLK_FEAT_ATOMIC_WRITES_STACKED
+		 * here also.
+		 */
+		if (atomic_writes)
+			ti_limits.features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
 		/*
 		 * Combine queue limits of all the devices this target uses.
 		 */
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 8321f65897f3..bcc6d7b69470 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -299,6 +299,9 @@ struct target_type {
 #define dm_target_supports_mixed_zoned_model(type) (false)
 #endif
 
+#define DM_TARGET_ATOMIC_WRITES		0x00000400
+#define dm_target_supports_atomic_writes(type) ((type)->features & DM_TARGET_ATOMIC_WRITES)
+
 struct dm_target {
 	struct dm_table *table;
 	struct target_type *type;
-- 
2.31.1

