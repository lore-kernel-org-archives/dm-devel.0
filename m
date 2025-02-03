Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979F325A623
	for <dm-devel@lists.linux.dev>; Mon,  3 Feb 2025 19:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738611964; cv=fail; b=fQSrtjrhPS85Icq1Y3sUxW6KGEeuJUnsuSlQMdo3P9XEfoM8Fd7w2OIWhQ3kBxiuIsOwJ2PMMxQwbdIZ4AWBjvnEITdFUEOSqJB+7SI0nXnekGnjraHIY2xdDGrHeT1IYYDA6bKTTl/jfTPywBFUL5psiJ6G3zaCKthKo2V6JPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738611964; c=relaxed/simple;
	bh=Ap6witRk32qtA0z2N21Wu62vCE+vDS9JxsDnlcuQvHE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=r22uwDYrHSY1NrBo1lAlvgkPrVtuhBIA6dsLq0hu0yZKAM/8jKxRBE2KsDTCAqHfAVsqBVXbf2u594hLAYXySFduAVKut8kHC3N++DRAFQd5TGURLQZyjHXyCBG3pvg0/GWCXkKlCDnqLH8nzvimxO62w4+XJp4eJVYabropttc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gMdOAm5p; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wUX4fduU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gMdOAm5p";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wUX4fduU"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 513JMr6N009080;
	Mon, 3 Feb 2025 19:45:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=CheIvvpzjcsIt7lxQh
	R5b64PLkjsZWENLv8yHBpKdYA=; b=gMdOAm5pMV+zOCcCTNWUqsul0gogffwSo4
	JRIvDdXwuYiQ1eZb1877P+hONFkbqBo+Dn6v109mfqPIWi1p9NS4H46e3soHNdgY
	C0bRS2QdELN+wZMAnE/9HaC9PWzThJd+J7RLrNr5pBsL3P8dap6/wgzzKYd9wk+s
	gnkSjwXRWg8dGtGvnRgOd4Au44yY6gz5xqEh/TrfljFFXcRXgitEg8JJt1b1YIS3
	wNvel4M+/YCF9UaTZGD/C9YlkrlcuemsUKjmgQfN4lAvdC/ZBcgvHvG23wARUDOb
	FuQwYk3FrpNjv00GIP9vDmdhBnh8JBcxC+Y45H4VgNqlBaa6EWyw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hhbtbg7e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Feb 2025 19:45:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 513JU4qn004883;
	Mon, 3 Feb 2025 19:45:46 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2042.outbound.protection.outlook.com [104.47.70.42])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44j8fn358v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Feb 2025 19:45:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d+Uj+Q5y4HT73TmFYU5lsByaZ7go4KbsOjKAQK+YIGlsHto2TGv8YtCAq4r/LRMj/959eBdxeez527KRdJewGWiN/JU2m0RJEZNPoSO/o9jOuoLII+HCA1UHb3i1zncPICpSr0N8ciehDp729PkWQbp2gliYTapnfibfX+qa8FgIAUlFTlNh7nPt7JjzwF8mWUZ+z7PpaCqGGj2NOsGrtlYpgR6gRAAr7FPjNbUaPjzT2qMis42sNDIaz7bg7lZghxrH585+gXu4UGFlIlgBsIIzS5hlgsizDx5Eg1wekxkjruLPorquSK3wTRSfwj0S+Frdtt3xJpB40GexgqIEUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CheIvvpzjcsIt7lxQhR5b64PLkjsZWENLv8yHBpKdYA=;
 b=BATV1IuuqavSVY9UqTKxe/fKq/pkZNh7e+NekO5kUEYLKASR9WgPUNEjOlUolFcGWNaD2rFeVOJ6Ode4YWPeVz4GZ0RyOUqvT3xnoSyuRSfPiGdbAXZs9A7/33D9rt7IMuBQ4CtF+H1jrHJg5MZTjHGgBX2vV3PWq2tOHQzkfFYJxhhsH3FmsssdHqBVPKRrdztjnuIa5RzJW9ami+7EheU7cxAHEsTIfZ2bL5N3Is6o2pw2ztBeV95VzpLkSIDl3a2NeOlnLuc3G62qoICigLQ67q4spaMlS74UWJDK66ddwVCt5VCcEeVnYb1dbuotu5Vk5lKQghWR/I5uffxxCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CheIvvpzjcsIt7lxQhR5b64PLkjsZWENLv8yHBpKdYA=;
 b=wUX4fduU1eLVDvj7rSwwBYVyCd0JXoNiDmyMIAqIGHKUz8wpuzzIwFIVnp6nuRyZ8YBd/eyNFGJI7Qo2i/xRoSQuyaYojZnjIsVq9ylEzvjR9j1tKVe/vR8U5jouG+hCbo3Sx2vqYlXNQ5b+0OQKIoJR0COkfztzSsl1MNU+Kh0=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ0PR10MB6325.namprd10.prod.outlook.com (2603:10b6:a03:44a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Mon, 3 Feb
 2025 19:45:44 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8398.025; Mon, 3 Feb 2025
 19:45:44 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
        Yu
 Kuai <yukuai3@huawei.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
        dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH 3/3] block: split struct bio_integrity_data
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250131122436.1317268-4-hch@lst.de> (Christoph Hellwig's
	message of "Fri, 31 Jan 2025 13:24:18 +0100")
Organization: Oracle Corporation
Message-ID: <yq1pljyizht.fsf@ca-mkp.ca.oracle.com>
References: <20250131122436.1317268-1-hch@lst.de>
	<20250131122436.1317268-4-hch@lst.de>
Date: Mon, 03 Feb 2025 14:45:42 -0500
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0005.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::10) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ0PR10MB6325:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b3e4304-1537-4a49-ac32-08dd448b593b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/lxgmY3qqX7w9zXg8DT+sCWSfJVZ+qV/hbzjPP2cHBrre+CR/qCDo0bVCB1Y?=
 =?us-ascii?Q?179RNl1IRTSi2rHJmiwtDTsVazaTxgXSNdNztnLbe4FaOhKxrifk95s5OjB7?=
 =?us-ascii?Q?vOCJZnrY0DT7PcfGpGp9jeGem2o2DCui31eX7RjKpGrk9FwRa9XxBZf38B5W?=
 =?us-ascii?Q?VCVMddqntR5fkm/k5jHmWIWzmG+ULl8uphtQdiAJtpe80+pcY2pgqHogG3Ei?=
 =?us-ascii?Q?dtCq7tz35sVFan7D7N8STwKEgagJR5Uk4cDLRIlxdMAj2j0HYBcBrXwJDaph?=
 =?us-ascii?Q?cRiJKPtWYaYptW+YqdD84RA2MxYj7uCk0JAv3r9cD+seD7kSivJVqbAvSpAl?=
 =?us-ascii?Q?I4VXiA+wzAABvyyRwIGb8CBazXW+nB64bChx+ljWKsPRmXsIVyAhjnu6yPhm?=
 =?us-ascii?Q?LTu+0M3RinzltUnpTygNbr1Aq26s/aED/u5ntHArPzl8VAAzZ6WqdDhbO+Iv?=
 =?us-ascii?Q?oeYyNIEZRNLWrpuDdN9Ja+N/9gSNUIuqAgD12xnuPTnEuisqBJifUNmyrtT+?=
 =?us-ascii?Q?wnZ2mKPqCR6K11Lj2HAO0PCM8NXZX9V6bhcuUlvvpNx0YOGisONRDYY1/ULv?=
 =?us-ascii?Q?qlfQKIcUimbUW8Zn4MWAUUn1kANXS3FiHW3xnlkm0EEfWZKHpZniphEhR0c2?=
 =?us-ascii?Q?0QUr32ALodnRl0pCiZ/MWu9s8VO1VdnxR9HK1gyuQrocAI/TLRYoSrQnUqMy?=
 =?us-ascii?Q?feIMBhHnieOvCFi3pyZtSnsYnxSTerFhaAZH77s+ILG2e9ZFS8WNifgmG2Fx?=
 =?us-ascii?Q?wB1i+3jGYhssE1g2DwZZwdmucOMsJS2m/DL3z2YNibVVbHlGlvQd+hIbP74i?=
 =?us-ascii?Q?wq/YPgLF8r9wn6fqMmSxOOeYyb0oJNh5+WM7srdLNfpE6JvfyZv9DGw5yCru?=
 =?us-ascii?Q?b0h3Bs+S4fI+NHUyrZsbLjCjeHtJHoBkv6bIKqFaRwKb54wqhuD0F5OgrGge?=
 =?us-ascii?Q?ySs0XB7PWSwrx/j3HujNnol5voSnRtws7fl4RBZpnSc4ptk/O5453UuawkmG?=
 =?us-ascii?Q?F9WKnSuErTDGvRFDTIDKODQQmWspQeiIKP6o7Cf9J4WMnb10UJ7BiyWknDn7?=
 =?us-ascii?Q?DXHZH8zAsvlQSvR2+DW4i7hFTRAWpVh5aWn++tFaalYeWvNbNaa2SSPpRLJX?=
 =?us-ascii?Q?Nn2K1hQszyT7CBg8AQrZzPJh542bSIZrqzHrxFoCn8LShXE/psNB64bbEvxa?=
 =?us-ascii?Q?Z+RsDguu8d+rQ1RcENWHoYMypvll3Lfq0XYisFhVr6ar1mkOlK9cEcEHBxHu?=
 =?us-ascii?Q?scZhkLkKpo643f3qLBP5sfH+tC4dR4XCQHsNZ1FzCNX5H4echtVTsAbRZblv?=
 =?us-ascii?Q?ymDe0MQxeqjSnrKjd9fmiItMJU0cpWyPElvLHl87JxbVXehGcFLJLApkVo9i?=
 =?us-ascii?Q?1OImy3hkZOkIkYWAFmR0+ysRXrif?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jSlRQiNTggAc1guYTmwog9+5NYObPNR4paZP/BAc4++fFXMH+PjguJ9/LCoK?=
 =?us-ascii?Q?Q3Y8kIUTo1lC7IW8WNQXlShumULlOpE9LuywX9TiyV7gJNxXKopSck9ustRC?=
 =?us-ascii?Q?X2Nf1KzGZgJqc31cKlnoB4JDKoZiuan1Csx1D+BjIiEEx4ePc609TKyPublR?=
 =?us-ascii?Q?EOyboDtvje/Ulb8b8yzAv/DWeAgSJTaLIsAskkZKlR0WAG7xPHHQkxRl/lxd?=
 =?us-ascii?Q?8WcVN+xnna0Kk/BFba6C/ArqEmbCd21ymdPv04pL6vNet2q0JuwZr5HvHACZ?=
 =?us-ascii?Q?PZnHWmehyWMyv1N0ZQWDFGBvho0ySsz5Q+AEAW3Bn6mSTjsZGkBiqJYkfg/0?=
 =?us-ascii?Q?dFRFX0xGogi3YDvMtIWvzCbcpH6CxGSjy8DesNJNfTv5Cfj4gwTlXn0C6g8j?=
 =?us-ascii?Q?h+LE6x4MPP3LyFvwILU0hatgseewTpDIo0Li1oEKmMYxr0gZ7jgO64AUji5K?=
 =?us-ascii?Q?NzMH9Du+7wksGlzpeVDSPCrSWOqz8FsF3gMPyrPgIvDQpIrtoPdLcfT8zqZg?=
 =?us-ascii?Q?ywH9ulpjTIDEJZxG+KVKlSRCbZ0r/1K3gfgv7/8+LSIU3EYQ6HTlf9bYgmjO?=
 =?us-ascii?Q?/QyY8zoHXp0vIT6W9oyQze9ACOt0LIWE+76b1bkKKs07mj8Y6xBwSjXcryNd?=
 =?us-ascii?Q?V3dYkivU2ruRqMKaBlGBNgPSuWPdIpuB7ZA5u0NhWu/O3V/hOL5uRk0C1svS?=
 =?us-ascii?Q?E/aHcaDCccxGHy5NEZxwbyCwLKFjSWlxmurndmVqITVU/aKamDB3MVdzlhmp?=
 =?us-ascii?Q?Ym+sbq9n2tFlR/1j0pNAlZCYyRcz+DhxRTf9luRu7eL5R/YHyNPU0Vkvr7uv?=
 =?us-ascii?Q?mgdVbISEr/04QfwYYNafHX+2eAcvvtI5QKSGa6a6IcGNIfLTf9NcFIgHHCz4?=
 =?us-ascii?Q?imDPTRqnos16wbtLSEp0ziTvHHciVbywWnc68eWTdhsNY5nQtJYSmFV+3p2e?=
 =?us-ascii?Q?YYDh87Y3YQ2SiDE2gxpWEK5cy5HhTTB3VaVi7cFMQviq6Tcmsk9KrNdIZHGl?=
 =?us-ascii?Q?1n8sdeKKekKpbVpP65zOzstxJQ3O6ww99ksW7LmOhSjDwMVCMtyM1wp5swXb?=
 =?us-ascii?Q?HImSsGAqCy7CMGWzN6QG3wtIZmxxJ1oXICYipr7NuwKR3khkvCAz+FwhixtV?=
 =?us-ascii?Q?0245aWh8fW4NLTvYTmsD73i1ak0rHI9UlW5GGwkLXVELR/1EdO88nyfSK/df?=
 =?us-ascii?Q?GVVP+MPXCl6nzzHLlVgsM4+Cb9yFDgcu95TtoVQ30XL7yBJKIXgFevQ610uy?=
 =?us-ascii?Q?HRcx9q30XfHioSAmWulK8RxprQveZfAxuclnCvUVwQmc5uBtbYflLUM1ZZfI?=
 =?us-ascii?Q?0y5tS3hFkG5UdGqpnWUYsCJB0B5URz/Kf32MJGZKEKu/TuugXdvE0iN+LoMs?=
 =?us-ascii?Q?yncS1Ln4UFql9T9XmPTI6y1yDNTHsMDmhXV2YQimjI+HJXJVZRei11R2IJtp?=
 =?us-ascii?Q?xn63crAkQvSpmuZCW3qzS7M6bND8U/TsO2uus+DMSZIga8d2Txv1uOcXPnyj?=
 =?us-ascii?Q?tCqqmOBPT3E9eBe6hroUZSqkzfOV2nCxyBs12SbTwwi77WGf46Ds+lcPzsH6?=
 =?us-ascii?Q?qM+kfOa4iM0PjUkQIwXbwe44YUY1Hn+QP1laeFJ9b5oV9FAxcdrerZQOLHph?=
 =?us-ascii?Q?NQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	us4B0LAXTnNpyaPgI6hTy+nXNNSQuVg+lpYdjeq8vEypbqD44M1E/LpaCMN1+fK11531Z6CNFEhYIgMApN3Cb1NT5mo/EQzbGbPcw2AgWHdzrWxkO8OnbiK9wx8KWJSwpeGBmFIkCPSv5aX3Zii9aRVbHK6IGabH6ZypupuorzUtfp1LMNEiq4qVLDepDXZC6x6Armt9JYhvOUOTQyyAdKH6LuOtKSOiuk71eBZD6PILXOxZUaf4oAt94ASB13X03GQzR6MMTq6qKu4046nM2ie4V+pXjB0ehLI2xssq2H9yNEneIF5ji+AcFyzKeO9f03TMp/9cFky4z99B+JoimgWXOktm/O54wi1wcdr5UwTA3SsuW85Sqoq3U4EDBGzLHOmlGGr0QBgG7MBLO5jDiYNot8lAIupemaCRjkT8cDlsJbXKSqcUQU2HKPD25IKlIko/ojxD8M5rmomTgQsN+TpSSidJA/2aQMS0ibYqrR5Vkhn/4AAQc70CGlWtGCeKM7OvgKpZhBTRHO9b3NfGrS35YF7ClPJjnRI4763tVYt6LY1of3KfgQA4R1+jIoMWlr9ruv/KqKf8Lo7YfyMBfpUK/g9rI8LiYuk28eCCKPw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b3e4304-1537-4a49-ac32-08dd448b593b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2025 19:45:44.6645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t7jMu9C0phIpXCMEhxKEjgG9SJ/9uRn0py6xZVRUrK/laY0DfLq5ehzQ+eVUUwzEAKz0MQYDS7vR7f5zgGAb50GhNBkzlEF92RYSIzOVdII=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6325
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_08,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502030143
X-Proofpoint-GUID: 4wv6CyQMlH0oek1Vt_6mZx4JZgRy_d-U
X-Proofpoint-ORIG-GUID: 4wv6CyQMlH0oek1Vt_6mZx4JZgRy_d-U


Christoph,

> Many of the fields in struct bio_integrity_data are only needed for
> the default integrity buffer in the block layer, and the variable
> sized array at the end of the structure makes it very hard to embed
> into caller allocated structures.

This looks OK to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
