Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A8927E7D8
	for <dm-devel@lists.linux.dev>; Wed, 18 Jun 2025 08:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750235896; cv=fail; b=h3uOnhf+XYEFSMUZu0xHVg/0qvZsSo+bwnDaAEX2bSKPUOOad6UUolk4foqlalU0Dm4N/DUX8VdfwT6A6dp49kLV4ciCko/ULQlryfRu/EB1T1eJe77v7QMQJ5FVYPdIlOAfz53b9XoA6/duzoeFcAsCKr96rD3BcQxT4XGgoww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750235896; c=relaxed/simple;
	bh=Y3jIy9tOD9aF2e6HL8dUWgL9fgQXMy/xYbH4MUdgCbo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Mamm3wfPGsWDTwmor7ThsmKe+hyrKuiFtIEwtyMd4Z8XXPwj8mOCa6HUf4e8ptjEG57VLrnLavKHog8HUqQ4juuEA+VkJLJCXQXD0b6VTIe901L5YjkxiGK/0L3vkuyMSXvrEcB7GI8XWuT7WX2N+INIHf/e1gZGlHQKfzuhWic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pleJ1m8R; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QULViftR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pleJ1m8R";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QULViftR"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55I7Gq4J025140;
	Wed, 18 Jun 2025 08:38:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=L/65Zcb26Fmqvf4tVqxWMi9N2BFgKvIT6WIKxHSL8VQ=; b=
	pleJ1m8RS/dqrwkRtOL7b650eztfiLRZaoqSeKGOI5aC/Bwz7Q9DLCLoNp39sME3
	UH1clwjh3/7wNSkkvawAYfSaadqBEKvsf7RBt6APnjsssuitH5xzqIVMZbp58KS6
	jM8rq3nWHOgoEHDsYt82C7hnDPhElZu3XhxABkJ6XfbpreM+t1gfe8nEJ5tikmHg
	tm+/v1Dm3vZu2zT+s1H2vxFxQb+JYPcBA7rckczftN5EAZLbDY7MK/+MnD+i875t
	/gaK5CuLdf+op+N7wqGdo+2zB0PTSBWBYo+x6WhmlwchUv+g/FElQlqdMMSkGAMa
	oa3bmk0xgK1dnwOJnCwj9g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 478yp4qbge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Jun 2025 08:38:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55I6upZg025915;
	Wed, 18 Jun 2025 08:38:04 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2088.outbound.protection.outlook.com [40.107.243.88])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yhgmfab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Jun 2025 08:38:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nby0SNhj3uH7I8V4rsDQ4x/DveiEb70q595LEa7tD5qG8QwSdkxF+A4mCD4CMoQKPm84T/ld94CNH0P898oLgegf6cn/iogWFnHv5HvoHnCq7dqwcsQsWzt1ySs1jA3qp7cOxm8GvXdGWn2YLPD6N9sxqvzsdEZb0yHGHbROnCRLuGqgN7ci0bNOhvZyOz98DqWoAxfT1rLHuYeBjuxhY/Wr9mbMs5LYRxKx9LVUADzUKHJ892jzgDgHCgvgQ+Yk8nfwONsIhl48uXrmxhmGlhazcpF/qRmFc+ZeD50A/kIbPYm/yv7/sFzJZxX43ddEWpwtKLUP8s+vTeLHzclAiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L/65Zcb26Fmqvf4tVqxWMi9N2BFgKvIT6WIKxHSL8VQ=;
 b=vJ2AbGkN2EJZ0oj7oE4JQnDwkGlooC4COoIotLOwSkb+m4fTD1m19Z9YEvQnULkq0xqFMa2A/4i/qDpbvqu90JiGvsAWeIceA14nmvx23dIuP2QEp3GfDxnerXwFbEvOwnK6WSvHESfCDtIBl0mf2D3YQ1Q4gle+p8Ijjrrpb5FFzaK/ys0C9ORZqzQL5l9lSRPT9Z9QTc/bI8cXL5mbh7oWiakOUjdlih/rNusnOF5/6KbS1SL0yh+CP/pjlUYk4pq876TuYdVdoDZRsF2jnFLA4S1PRxLVyTNkyGibZ5+wXZ7Xmw+tIM+Rb/qcI+souhtL3trppUSIQjg6MIWamQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/65Zcb26Fmqvf4tVqxWMi9N2BFgKvIT6WIKxHSL8VQ=;
 b=QULViftRaZYTy3KWeoyin8Yg+gRbcYbxhovmz6UHpf7sb1KAd0hTvj8KxKjf5TZztgvX3vk8lXhAiakjRbj+qScaYvfCWdHifBzFmaGz/dsws1IT/4XHfoR8zAioIlslxrnDhnMTn2FYovjgFxY+40E/iQhWE6JdsGIBApIKljQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV3PR10MB7769.namprd10.prod.outlook.com (2603:10b6:408:1b7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 18 Jun
 2025 08:38:02 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 08:38:02 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 3/5] md/raid10: set chunk_sectors limit
Date: Wed, 18 Jun 2025 08:37:35 +0000
Message-Id: <20250618083737.4084373-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250618083737.4084373-1-john.g.garry@oracle.com>
References: <20250618083737.4084373-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0138.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::23) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV3PR10MB7769:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d26a081-9cac-4bac-c27b-08ddae436fd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PbjGdMvHqnVB14HW3h/YH8gQksCzlnTAJ8b7y+1RHS0eZQSmGvlqqy/hzmdA?=
 =?us-ascii?Q?1gptB8JHIEbvV3vuc8iDh+6HbX79gXPoji/LXtfiOizZ7l/SN6bHkGQaWwlK?=
 =?us-ascii?Q?BnwZBgvWW/+KxYq6Ke08R4t4kpYKOpQAZsr3XIHR6OICUAZsFoOLsK4nC/NB?=
 =?us-ascii?Q?WyoTss+Qr+JeTEVhQrXSRzB+RStyffGfBXNx2T3dxwjzfEeErUY04ld+y+WS?=
 =?us-ascii?Q?mFgsKxG+fEdAzamgK2nFzXzdqTN3i3i1RsDJUWk1fORZX2jy1JXczF+5QHz2?=
 =?us-ascii?Q?5vvuF3gQg6GenTR7kGqRMm/4vLIjSBu3Rna0hTk8HzSguhoVJGoTmBJVXFY1?=
 =?us-ascii?Q?uN4KOU/9MXi9xKv2jTu3AGRnxTozb6MBm81zf9VHDGfUmCIZ5Pnz6cOTxI5N?=
 =?us-ascii?Q?CNIoZOYLfetzMurlWBTFgd2SHr6p4fDkKmD3WrDPJKwjHwXUMGcfzbVM4isW?=
 =?us-ascii?Q?qD1A9Dbznl4n/gW8/lhNA8uxyByLLmPfJOI0o6kI66ZYeq7C+3kc91ZUBEU8?=
 =?us-ascii?Q?n4bZQbXeU0ZGu8YVa+r3ZRT9QfEHhGUad/iA4T120lPCl/W3PbAprrXeiwcq?=
 =?us-ascii?Q?78FdZ85sLzX62YTC3J0EAOTmpRtNSMC818dcnFkJ1MkUFcT9kpj66QsYseGR?=
 =?us-ascii?Q?eWL1U3Lo6QMgHTsAL1Q32nWiaXuaKtSOUeY3EGywESbR3QLb8siJiGivDtJY?=
 =?us-ascii?Q?1+QJxLoLUn4uNcN+z2jTkqvD/roezNDFJnQYCi4FPXuk9JQxi0yjKV+QBHiI?=
 =?us-ascii?Q?qf9Piv8DxwqEc3EFrI4S/9UhXvkWgNjbjZCNuShPvUGDOy6sHOzvrKyw9wqi?=
 =?us-ascii?Q?Hy1LPTHeYnb876MXKhmRL+jNwgZ5G7a/Jl8bkHkEpGKjyTsmcBa7+CxmBT+B?=
 =?us-ascii?Q?8B17YeffcC+lMZ3URbhx9/6CVM0j+QVqC/AKSfrJim0u7k9cRrUkOQ9n8/08?=
 =?us-ascii?Q?KoxVzH77pWJLnttMlRm6gSWq3LOrXcizmCujBn2SOL1SUga3s1XAktfM2d/t?=
 =?us-ascii?Q?UeTScYNeWoFaHX7p+6lFiudekL5stnJJp8jBuHBDLuBC08vgb07P/aziOIsk?=
 =?us-ascii?Q?GfKfsecoiv88mu23d8gFEssKvqJFwVQWlB7rcy5LQgOtS5OlGd4yIYFTOLid?=
 =?us-ascii?Q?xNbxvqVfLCAZRtiiSqk1btY8A74D/qzG7ekbd6nL+1qAMG8b2Mlry9QuTDIm?=
 =?us-ascii?Q?UWiYMArPZRgIefI56dbQsZiF5XkNH18WiAAICTNU4CsHCLGG336pNvndasnF?=
 =?us-ascii?Q?+p/wwojz9Hhogga3G57IIn6nHS7J+3pZwbZpS7Jl+/zJ7M5SPoT/31KITnbb?=
 =?us-ascii?Q?Ga0eSdYdt2kKrobewcV9gG3rAz5QE+FFr/V89M3fNoj7C6nmnsdW4+h4afRg?=
 =?us-ascii?Q?aIZRYiBAfM724bTMorcnfGCeMag6hK83OsOxhwTy/qDKwGYLmZ17n/m1fC/2?=
 =?us-ascii?Q?wmvYvfXgubo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3GdJbGUcbYA6bZg80F/aWUfo5KgFWNzHTDQpyk7l2nqROBFseO4mbxLzJJJ3?=
 =?us-ascii?Q?GpxWVhQYVf2kBhyAGw6EG0gVxsNjrPGAo2f6F5W2YQTj7EkLcb79sqjt4eIQ?=
 =?us-ascii?Q?sxlNLFHToTe0zRhmCyeNmHZFS/1XjoJukcbrar1LD35LT+nVo4PyEyGjTTKM?=
 =?us-ascii?Q?ovUTuWhNZ6qSUWDIiH38ZEqzsmcvqEI+AOvOBuzqOglPeLk6gGNO8fwbnpnT?=
 =?us-ascii?Q?85VpYWEG2wC8B+T0QxKxOG3VyoKIlbSaKr1qrLDI5TrI+DBcW1WgzQuU9OuI?=
 =?us-ascii?Q?aYifz5uIYtzSzEaOZMDxjyXWpUDjnYTUzWSdzi4/LKfYhk8uTxRG0UV4TRox?=
 =?us-ascii?Q?vaV90VnErSwNiDddlFUGkYvwdf3XxW4HNxYYhllhwVfsy4ULBo0F0VrHtHJL?=
 =?us-ascii?Q?rTUQLM1Yn9XErjOPsG6y/u9rYLYuGuzL6iu33sCcwO+YtVrNM/aRdOAGLFvr?=
 =?us-ascii?Q?/CILg4BdNo+Tgd1Jc98DS/3bqHeobB/9QfwTiziYyo0qCsRjsnx/vT3OOp+K?=
 =?us-ascii?Q?d3vkfNmtgiFqJd/4J3YfVakzGPE7rypHEtgRA7Q27qK+FyC5KaugQmectJqq?=
 =?us-ascii?Q?403KTcYvwvfN2TjjMY8RXtDZdtrpz3PXFh6p7VoQKA9mgyu5/1eREbt1m68Z?=
 =?us-ascii?Q?vYgMfo2iKEoTdlAeJnXi6DEgAAyOyBY+j+6ZDcydgOXEy8jLDlt5aHOeirR+?=
 =?us-ascii?Q?FSvmwfOme7vQFTzNHriupv/21NjwXxOaAw/xb4ywSQdYo8CjOuSG3YDhd0TP?=
 =?us-ascii?Q?P7uaGckxv6/GVZjwRMD/48yUub7eaTab2F2rb3J1rdnDYA03mpNxoH2Ai+aO?=
 =?us-ascii?Q?3hxicKLZwDoZfzQBjIBXPPNj6F63hB1NOxFiJeeKQ01nbXmITqHjPi+16OZj?=
 =?us-ascii?Q?yNFVUr3ckCW45f2SnraLulbFKzzAqsEEwRzzQH5HGR5ruURL1n+eqe+RpvPx?=
 =?us-ascii?Q?SFcCdDAoDWFjf6emPeK9JViX3oUWJWX4naoDECqWaokwl23QEXdkB1npQnBy?=
 =?us-ascii?Q?e9qfREb4xbTi2gau1+8kvCU5/nkmeu5HZPqT8SvKVMJHTzLGyOVlUNH0sTVj?=
 =?us-ascii?Q?jAUq9uRXJXOqyPVd1hJmc4xTT40MFZJY3h/vMD5SuAZdYGeGfpyCQnHxOrzb?=
 =?us-ascii?Q?In3TKNhoYOYyi2mpTg636wcBGN67ch7uYXl6oRdQu7XFakFP1l8Zs+OEHDIc?=
 =?us-ascii?Q?xSz32EbLUoao4yDnvnb7GL5Ee5AypXK/L4ca02l8To6iXDPDBYyslCULJek8?=
 =?us-ascii?Q?3WDeIrzJkvaK4HV7kbcXyqLDCQ0MbsO2kmdbLD5+Ve0f8qcYWIz1lYjxGBpQ?=
 =?us-ascii?Q?BMAmpiAMU2xB6978ySIwv3K9GbL4QVN4vG6DoCuTnPT6xo24O7OpDD7krBLv?=
 =?us-ascii?Q?aDOTO6gDzQzImxlm1cSxzGM8YwD4ZUYuAlvGI2iBpIKMAvAT6xqRd39a2/Fu?=
 =?us-ascii?Q?gp8MaERsVvdPYA7pH0QZo6r6+VPh1orDUNDdInO1cp6v2Vg+7KTRDn3qZ04l?=
 =?us-ascii?Q?aUg6ahO7284dWEckU6SW3AjY6FYsIXPXzgfgZh+4MdcNm8+NGAviOCylnoK9?=
 =?us-ascii?Q?T1ttPJwLym9y67RzpLox4oIdUkMpVQqw1iFJyi1PNa+lVf6FCdBrH6FIeGg0?=
 =?us-ascii?Q?QQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UDtmiyvOj8hkJru/BmiwYRdP2GJeBCm7SkUl+D6478FcZXo9+/1G1Vm2wgLXDeS8q+dyTrHXzPQDzLGG4UUHYEG17nHAAnPRsBkQD0zkVqWeBe0IlFeMny2HjI1p3nNuqgOdOIutkc711DInAKPsvgxBZ3oFEdiAIeF9h8o9UqR+VaQLy2k5UqLCCll+ax4+smkm6pdMDMEiGe1fHo2vunSpSRzTCSpL487KQgQwZw5q940UkX29EfdSTu59GXxC+tJ2rcrBwrgn1IoFOEoKE1llmIrOpy6t26s4sTA7bsJFFYqjWf2Pk/JI2mGyhXQC1M+T+stV00/UqIu4FGP+2UPnJTo/YE2Igx8FCJjRxZtSVQoBzW7j7ilHYbdjhTkjQIQo2wzj/zhT3tFzD9soLp6IJVx2BUQYV73HLRUfQEqM/cBvGfR7jbaa+iddGIvQr6yQeZ1HPiZ7dtbWz51OC93U0HAFgB9tpK7iV2CN4FnBNZJRUjIXFFYHHZHBXj6KFS/y6lhZgEz3BkL9zz5D16aL8m2AVG/v5SEfF1iLueJyGmppsx6Mb2+vmbQelgUtppJUPSf/xFHKQFRsn3g2M/qJQgeeEpjEKvKoNlH6jvk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d26a081-9cac-4bac-c27b-08ddae436fd0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 08:38:02.0328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sr++m0ejnH/4X+f16uE35Viyk+ZyguvwBlJD+0ElBS4r2NPfIeGNAzXa4v7MTCiebBf8+++Rs/o6jI3JfW0Idw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7769
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-18_03,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506180073
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE4MDA3MyBTYWx0ZWRfX/3Rq2+aWhaZ8 chLpeOp8bx0i5Dzg+AdpptdmFTQS8cs78m4Lp3cjQ8twuOW0PTCXfX1ATyKI33mQGo1ujhh54qq 2b0a4/A9NtXgr9UxqjPs5QXpYz675T7HeYzpDPZEzNi/4HbQQZp1gHILcn2GaU1GRPv1S5cOnH3
 S+muleObH1OtDVq6p+2Wbs22sXK1Tl3CqTfzCo9Znz4rvCmYEbrIsjC8ocBHPExdZ3l8AyOnuVk LMoEOoK3uT0D2uHRP6JElsK7XbTpPqAgXtDdHEJesAMdi2cLHqUhXsDphZUnPGmnxS1iaemtNnh BLgOqCxgqgprqZS1hrkf7EOXQXyqITr+tln5tQ0rRaLb1VR0B7N/uCFQtPtDvjSOTI+ZCcS7q8O
 JRi615ls6n15EriDo0DLRIdlnw0Mr1Aiy4WVkEjalg7TLgieMvSJSDChIHsMJC6xjQhyuD6i
X-Authority-Analysis: v=2.4 cv=K5EiHzWI c=1 sm=1 tr=0 ts=68527aed b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=w2tMMWzikjCRSElI7Q0A:9 cc=ntf awl=host:13207
X-Proofpoint-GUID: dKMeE1HthVy4WfYmzrxVuI69BD_-QMXQ
X-Proofpoint-ORIG-GUID: dKMeE1HthVy4WfYmzrxVuI69BD_-QMXQ

Same as done for raid0, set chunk_sectors limit to appropriately set the
atomic write size limit.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid10.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b74780af4c22..97065bb26f43 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4004,6 +4004,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
 	lim.io_min = mddev->chunk_sectors << 9;
+	lim.chunk_sectors = mddev->chunk_sectors;
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
-- 
2.31.1

