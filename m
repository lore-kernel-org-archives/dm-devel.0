Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEBE18C031
	for <dm-devel@lists.linux.dev>; Thu,  5 Jun 2025 15:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749136177; cv=fail; b=LsP0P8gpW/PcAap/ch7q0/6YG3/72Mq+MZaIMFx8R3uJsSsiIu+BVxqa0UjTubRBPSbDNkzToXHrD4N0I7lHSRP7lOQn1GF/Gq17m28f/YP6AFYsB6t3/ehgfM/78BPGfCgdSwvGQB8GvWRgVsXsuu5U48UZRfllfx3n3usZji0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749136177; c=relaxed/simple;
	bh=m511kMq1CUxkWHODX5ADtFh7Aa8s9Ju+50fs/sBmQuU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Km3KhAyXLBUrhYpWlVIoYtGMRwcPgDYce2xkb90ZjAnst9QmeDlMtzVt/voad+hHaaSscwyI6sWYgS72CzH9c3d47+7VqVZYVXjxdlLGWjuDTVm7VaHDovsJTCEXuQEx0Ei5eNkp1PHTpFSRXCNr9vUDGw8rpYMCBtd3MgP2JnY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sZ43xD86; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WVSQyTum; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sZ43xD86";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WVSQyTum"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 555Atqhs029872;
	Thu, 5 Jun 2025 15:09:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=x1gcfS++nMLqj9c6xy7b+apJxXHDBje1TbCQkZtgvxo=; b=
	sZ43xD86A3KmlIHafKC8N7YiyX9hrqRUgk8eYbxKq5E/gHspNQHPXT/DdLXLfK/O
	n7C/nPuiHaoDlLxvvywlEnf1UHYlwLZ0yNpdMyltdLz9SHzXjBa1i9L9pBlktR7d
	tem1rykhNfGoTNQRGbc0R9HaN7+SKks7vkpB+lk4G2HYFO8Dp/Du/0ye4amz+ecJ
	9r43xRLZaLmtEwPrWQQNBI6KZaO1gN4uzako6Xa0XNvWiCUoctSD8YN3+okbQmLC
	ASjPIP2YBzb4dTcs6Rmo3P9DNhb5GpFsFnqFlyV051/iqcWMfAbF3/U7ntT7qXLO
	TgeeLdrklYGl5Pe0BdqCrA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8cxb2w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 15:09:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 555DrggE033839;
	Thu, 5 Jun 2025 15:09:20 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2081.outbound.protection.outlook.com [40.107.212.81])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7c6h0n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 15:09:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HxCX3L/XcgHys4nwA/P8w+u7730It+jzZ9yb6VGXyVk9ctyQSrd5jbtaCsMLwwm/sFjWdaQdwJwUo05pvKXJqnfRYB2H3qtym3rEON91EW/Rqm+yzAA2hdXQ0bQ7ZNxSTf3Y13G5tOhMZY30MYAtISeEzrTOAVI3cC8Lp/la0yHGxTWjFQg2P7eSg3no3kPGaIIzMiE657mfz1MmAZwFrrf7WDEZzBoEvVsME80ZDfnvjSr2o12nhb8dHiiKf/tcXpP6gfL4zYVU6CBBo4HiIJu7gYHtVP0sMeTV3GMu0uFCx2ZWAi++XglpjWMq8uWa9fD88omsFqSg0TeyG/GxFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x1gcfS++nMLqj9c6xy7b+apJxXHDBje1TbCQkZtgvxo=;
 b=dXg98PFMxq9NHuBRxwRY6ktA1CYtOZZjbhBy0CJoDES1l8jGnu7IqJ7yAPLGgg69DOk2hvWknAqRECKtatAMdLWl3WU9NZwYeEiIUqmVYmaJehLZCn4e15MNlGawC9Fft3zS9lEnYYMrDJmC0dOd8C+mtEXBnI8kBeyTYoH5OGec9Ep7pQAkvdjwZhH39bEMXIZx5XxzltYAkX3qUQEyiWMOcdSaAspmC2fcmgUJoVfFvN/luDZ/ZvzFpaCq4f9Px5l88HRPMy6v2qyqpmtt7cOvg0qwyavWOlWtPH4I/IfGlrdk4dSQCUTR89Z39LXmNi+VpRwYMbnT9LAawbKtLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x1gcfS++nMLqj9c6xy7b+apJxXHDBje1TbCQkZtgvxo=;
 b=WVSQyTumeeeWUN1RT6nMtKyVFWWTbGiJD6sSwk55Fg7CqnrmqxFaobOf66elsj/CfNyn3IqAJGfWyXqVNhloOI4+1RffSH2QnPrthib2PT9D8ehoCPF6KWZkwWHWHsj2FzRxxb/dyPpmhkMehq6M3F2Vmx2QQlQHZZCQvifr+uM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BY5PR10MB4177.namprd10.prod.outlook.com (2603:10b6:a03:205::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Thu, 5 Jun
 2025 15:09:17 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8746.041; Thu, 5 Jun 2025
 15:09:17 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC 3/4] dm-stripe: limit chunk_sectors to the stripe size
Date: Thu,  5 Jun 2025 15:08:56 +0000
Message-Id: <20250605150857.4061971-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250605150857.4061971-1-john.g.garry@oracle.com>
References: <20250605150857.4061971-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0056.namprd04.prod.outlook.com
 (2603:10b6:408:e8::31) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BY5PR10MB4177:EE_
X-MS-Office365-Filtering-Correlation-Id: 678bf072-78ba-48ff-c3c2-08dda442f0da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3AHBNeMlZHN+Z1E9H8Y6wWcfLOk69Mu/+9Qa5MavtlGASFZBCvMa3aTg1fBj?=
 =?us-ascii?Q?UYdPgCnd2Ua5XsHLZ+k1RpcSMpIWDo0cpqONtH0JDp6ClSANee5tF/yU0hPY?=
 =?us-ascii?Q?4ChUgJv96IValBE1sNTVz7bYiYfXs1Hxg8mhQy/V8yAyVBmasT4yn/OVe6fy?=
 =?us-ascii?Q?ElC4O/p2hX6aENwEdyi2fgXPJTuf5APFnqTdInH8H1RvJYYWSorqJdXjN95h?=
 =?us-ascii?Q?FPZz3Hq/G0XPvhe19mfysvd9jXRPIbZB3OGA5pmHTD66wmmLpPeVoyXycx69?=
 =?us-ascii?Q?xkp0ZF+ga/z4dHg028kmg2sdPUEBssIJfU942FUbX0Yxc878f77K0VqpNxHB?=
 =?us-ascii?Q?eGYaUb1M03tihrDOxHbUz+u+ZH/z7mueL/lTvrvnajq0zWksCRSC1Qnz6JXc?=
 =?us-ascii?Q?00PNyKiFzllKl7pANIgMJAF5Lg+u6G10UhLT+KeTr9LZaR8XwfsgSdHEvCaT?=
 =?us-ascii?Q?UBDWgslx5AT4zjMWWkCj8ix25sVt/I2i6QFSEEPNS0CzCUb86065+UhT9smd?=
 =?us-ascii?Q?5D2P2xssRJXth0FihhwWzXa/atD2CVZUZ86VPg9YxiWohtMtUdMkXOG3ETxS?=
 =?us-ascii?Q?ruRqBs8VjFqHN7w3taR38LO3TfvgLE9AnJ/9ayDwUJ9qPaRPzsQZXOCJcqx1?=
 =?us-ascii?Q?o6IABi03kL+l0P6Bp6Olgov+M/GzK/kR9WHtr+fSlrOKSOrfCkQ0JzKKzOEN?=
 =?us-ascii?Q?MfJ4ycPGpRgpsotX0qbQ6hI3gPqLtUqCfsHkF6E2i6G+EVNrNbJrFVzo5Lq4?=
 =?us-ascii?Q?9KUZT9MIPpMzd4djCwdrfV4kFuSdSfq8sFKbfnG7ZQ2KG8qVB5Iq+ic1a8ya?=
 =?us-ascii?Q?3AoCetvqYQh4w/VuwgFbfN7UynZTSn6z3EFBT4yvFdb/+a9ubn9A8FggpsRT?=
 =?us-ascii?Q?XQqB5xT/p/hFQaA6GpuQQBOrGzxLvLD8yzmwekrDvmo1OCDEEV/LqdV7hc2R?=
 =?us-ascii?Q?MYTD/YYX2EaF4n8q9g3mnJdXQHfhDmNE3GVrvXNd5JS/Rnq0XL8ILhJnW5x0?=
 =?us-ascii?Q?A46miF1lOLepOIA8NW7OFr/Q+4t8WsGrwXnYR0A2w5M5O9YbEyCx5URlVeUs?=
 =?us-ascii?Q?3ESiYdWLstK+kgAQNvd+9dEKORlgSe5gd3FBTPQpqTu3GCGiAjhvtMUsMovr?=
 =?us-ascii?Q?Q1NEYSaQyTyQbLm4pe9iDYoGGBFN0lqIkrlJVgK2gQd6KWkZ94TLJyPpZn5j?=
 =?us-ascii?Q?wC0FXX/1YD3/G+pLcpBKbk5TDttB7SNvkgDLCzVkP7M9P5w6MiJc/89naI5D?=
 =?us-ascii?Q?xdDypgpDhHqdaJIDVQLBOhSBA5MANmhScpmZMRhcbVPhSqxDCXmzErXxZDXk?=
 =?us-ascii?Q?ewW+PeSOI225ZktQQvc/2bp9u0pQZqU1fhrzDX22ByascqATPzdWlRf6Ps87?=
 =?us-ascii?Q?TbENqqOzWmx8LBQtL52ylsCkJlJaxg8UxQi1gbdfHCdktYBt6CN3SfJFaf0/?=
 =?us-ascii?Q?xtf6z8vw6hQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BYQNrSTXUqWSWEz35Doo39j0D9c+FF6HQTeRP+I5z5ii7tk6jwE3r7avCwpe?=
 =?us-ascii?Q?7hr+7LdPnMgZPFj45WJrBfC+BoLrIt1g5GvNkJR9Uczvlk8g+EqsWNQuzA5l?=
 =?us-ascii?Q?jbueyFUr1zU1AV66byqtKWel6RQcSSHNzIlePtpjM01FN4+phdTEtOqOQxVZ?=
 =?us-ascii?Q?qaNKB8KOkHvbeipybb1sehzmXneKQ3HqXZ36NoGRdg+aM49/xacR+1eiS9IN?=
 =?us-ascii?Q?A7efZEER9nBK/Mqq1MsfNt1cOkPo7qVxisUNqCLeW+qpR/Gdo9WDirRCgXhB?=
 =?us-ascii?Q?hhotnXDcOf5wxBew50k4iNx6Qdf+HSnMzcwgDPa8rLgm67Rt6ByH0oGcndAN?=
 =?us-ascii?Q?xyY4VdYVr8+RZeDczhQ0BpmEPIX7DjiuhA2Mi0R6h6AH4VNm9HNcSWcw4IVx?=
 =?us-ascii?Q?SFO4IdHQ4Cw5DNHbccWpusrGnqMR9tXddm0jIIpvrf1ZR0FBKXHk0smFj3jF?=
 =?us-ascii?Q?swfgg25BJMmdX6KpKpzYvRPs7Z4d/HpxD5btYecXIRLbwIVhRgA7ZAg5rJge?=
 =?us-ascii?Q?dmlStTxeAI+jClU7UT7mDK72afxDFhr/nezJbsN+UlTUKCmJYIUFXSL0DE7p?=
 =?us-ascii?Q?Zgv1Hv75ssbbWfcsedbE8YT4SU7MleQ6FpI1guLIM8s9XKBHsa7TuUgfhEaB?=
 =?us-ascii?Q?nNeRq9TdUFiWJfAq+Bp30/AJnBJJiILioRe1zqGi5osrOrDIQW6yrAZHObdK?=
 =?us-ascii?Q?6yPWH1bWDlZYZ5PEfG2lIKm1AJugl10D2v6/Lm2l9j2nIQIejX3adxwXyX29?=
 =?us-ascii?Q?+Wq0F5dNLl4FsJEbAU3djX+0KgGcxi/oaW1lmiHBAlDaVfHDmlYc7WXYW4gl?=
 =?us-ascii?Q?3BZKbL2q6QUz+6p3MCKdR1fVKrRTa59N5rJ7AYj9rTFhLrx49ebq7Ef8tLpm?=
 =?us-ascii?Q?vHN/Pby94zgg3ZYz7iUg1AMzUOeX6+epLP9krVF/assUfitKcyxCydu5DZBT?=
 =?us-ascii?Q?Uqg5sUtxdM5Kfn7dNSu8gBJHaOdsTVmFzlVcjpkQoYgKhXTffgB41qgPcRKH?=
 =?us-ascii?Q?Nn1aFy9f6mjWMWFOSLaRAsI7rz1Uf74OQ67MJmkINbMU6MFzsj6fLCc/v7u9?=
 =?us-ascii?Q?Za4/N0MHon5udZFC3if3NSB9jcsRg1OT2i1D7TJkeDCGmN81T7kkyjABAB3O?=
 =?us-ascii?Q?ig6M/hT2ug+FKqpnDWh/yOsM+DivLbIOSCliezLS0UQZ/OSYK/t6iPPdKN4s?=
 =?us-ascii?Q?b+LTkz6APN5xgO8YaE4uQVhHSeoZXTPdR+kqnluhUkIYbCfMnr3U+m/gWRrF?=
 =?us-ascii?Q?59Qi3WqvpnikwDs3mf8Jj/Gd3794VR32ExuYotPQ7hlPXa13f6SVKR4wKFAO?=
 =?us-ascii?Q?bbiwIzPD9azYh3JTvPkZjQV7+lKACoTJWvIoKnxb2SHjrNb4G8FQJVWc3VjS?=
 =?us-ascii?Q?a9Oc0m7cJM9GgTrsfzZQm7s23r0MSQusoilyE+xnqjEtb544KC2iplwW3q7X?=
 =?us-ascii?Q?Sgmp1XnL/l5zQ1PugKBUS4RjU3+B8s3p/0dAVWmqQndfmjMgyKOt33gsFsDB?=
 =?us-ascii?Q?EuhWh0K2ocgct5xMv7oB9sGwJWOGLNh1x8bp/vAseJEma+qRS0Uf74ySZCfk?=
 =?us-ascii?Q?5lU7whQyESdvVwBkDsQVCar6/6dSnR77toaTE0WeiEeVIBgtXWkQai1HKpYv?=
 =?us-ascii?Q?aA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4sIBOCPsBjlnVhfHEkgEIatg17r3MaB6Aj2MF9fzoCV+8eH9CAa2RdeM+/1qZ4fTT+IRsd7qrCv9hg8M9OAr3GgjAadtaStS1DLCSZUjUK1RMh60vAHr6pJNDD2jWzLvlEAaAZYxIt5aAvc0z7kaddUgaCvt0rqahWUiLQaGm/WB1gpp2QAyj5uU2becZHgrozrxRtQ9AJ5YJHd/whjNdltbrsQq8skd7kNAuRz5Jb/OxI/UsKfzGnVEvcA+Boez2zTnLeB1qjSNhFFTZYkEasAGMIQHgJCrNo/8chqpLy+Q5V++DZxAjPw9LtvAaR0SLRwMgdvrwrGMUZH9GOc5/kbDj9kXLVJjNuBr2MNsWBCO3Iy3/5tqdycdjJumRRuV/acp4dw3sCxvQZ6jqAS0q8I9aV+kEz4RgU6h9LvN0/b7MtPDtDFJUiePZRK1pwLGJa3Xto3EM9nkkhvRQ8nQA6cg3ZMkj9Hv0Qr7DAbXt+iFX0ue0Rs1M29GFyOek2eDq6nC/pIsaxZMkiSSbtO2HPbLkeW5quVf2VfYAygChPVhc+7Udoofa4/mf761K5ubdYwof4s4uZEyjUVQ50hm4vvLf01E5WtHxmOAqxtxTpo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 678bf072-78ba-48ff-c3c2-08dda442f0da
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 15:09:17.3741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KewX0gYdZeqc+469CzSlwDybkH3vLAp5jwLCmwkPxZvzuoXi/aEKwCGNRGihpoZ8OxgTzpfJMZy/Le8BnkItcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4177
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-05_03,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506050131
X-Proofpoint-GUID: 3SSBk09ZEqkTcdmN8xcWVj9i4v0TmgcP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDEzMSBTYWx0ZWRfX6BriyImrNPfG boe5oqTmtLG40bLbCejBMjSArXS/2ZMWrCdL3CmMHT8YdQgcOqDS8huukhQPTTIPZd3A2wurE6b +F+TJYPSvPi4gAzuFADb1XkZfERBCqNTIJCrM1DbmJYvEKQWxxT0rREh5t65DIH6oCnbFyKV8TN
 WPjIH+hSNCaWuZv6BFlo3v0se/ZSBF7iMIqXK2kVu+2RhjJdBIPoXsVBsU25V3xdF0y1+k3655J hj7PGeDv3pMORalLo28B1HQ9oaav2uPxzcpUZxlKPGPciM8UnEZtZcuIAkKz9IcR7AQfpa6J27c gF+N/DpaQIM62Vd4ckq8mjXO4KFM1b2R9jmx5tvwz2gw/H6OMvBi9VxlWm3ehMMEwzr0ZlTbqMA
 endy9EuzLxzlcihJn3XrKe7QEGWuTo5OeXAfBxmE0akM3mE9w5W92v40VFrhWBLYEd0J2W73
X-Authority-Analysis: v=2.4 cv=KaTSsRYD c=1 sm=1 tr=0 ts=6841b321 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=PeSxHp5bJ7usbbqzs1sA:9 cc=ntf awl=host:13207
X-Proofpoint-ORIG-GUID: 3SSBk09ZEqkTcdmN8xcWVj9i4v0TmgcP

Currently we use min io size as the chunk size when deciding on the limit
of atomic write size.

Using min io size is not reliable, as this may be mutated when stacking
the bottom device limits.

The block stacking limits will rely on chunk_sectors in future, so set
this value (to the chunk size).

Introduce a flag - DM_TARGET_STRIPED - and check this in
dm_set_device_limits() when setting this limit.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/dm-stripe.c        | 3 ++-
 drivers/md/dm-table.c         | 4 ++++
 include/linux/device-mapper.h | 3 +++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index a7dc04bd55e5..c30df6715149 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -466,7 +466,8 @@ static struct target_type stripe_target = {
 	.name   = "striped",
 	.version = {1, 7, 0},
 	.features = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_NOWAIT |
-		    DM_TARGET_ATOMIC_WRITES | DM_TARGET_PASSES_CRYPTO,
+		    DM_TARGET_ATOMIC_WRITES | DM_TARGET_PASSES_CRYPTO |
+		    DM_TARGET_STRIPED,
 	.module = THIS_MODULE,
 	.ctr    = stripe_ctr,
 	.dtr    = stripe_dtr,
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 24a857ff6d0b..4f1f7173740c 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -430,6 +430,10 @@ static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 		return 0;
 	}
 
+	/* For striped types, limit the chunk_sectors to the chunk size */
+	if (dm_target_supports_striped(ti->type))
+		limits->chunk_sectors = len >> SECTOR_SHIFT;
+
 	mutex_lock(&q->limits_lock);
 	/*
 	 * BLK_FEAT_ATOMIC_WRITES is not inherited from the bottom device in
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index cb95951547ab..a863523b69ee 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -309,6 +309,9 @@ struct target_type {
 #define DM_TARGET_ATOMIC_WRITES		0x00000400
 #define dm_target_supports_atomic_writes(type) ((type)->features & DM_TARGET_ATOMIC_WRITES)
 
+#define DM_TARGET_STRIPED		0x00000800
+#define dm_target_supports_striped(type) ((type)->features & DM_TARGET_STRIPED)
+
 struct dm_target {
 	struct dm_table *table;
 	struct target_type *type;
-- 
2.31.1

