Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FB02376FF
	for <dm-devel@lists.linux.dev>; Wed,  2 Jul 2025 08:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751444971; cv=fail; b=seq+gwaXzwUKBHRK9ISMDRQPrNHRZTOnUBSsYuplm0ezf9UG+yXQ/AyihxlaTV/WkrbZrBokYp3VYlqFaw5Y2B/UJur7QYrO9DzrBlRVBrWBOTpbZdNaN/64qSFsnzBNMFCsSkpHhAagWLaZxsw0LQ1CucC3H2ncH2MDZ976nIY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751444971; c=relaxed/simple;
	bh=XhIHQn40rW+dWDYLBFQ9cCdMWL9ZlAU8IgYKq/1wFn0=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qKnijXADk3aBx6KPlAS78r5o39THkvkcJyH2/SZgqlvWg547gSNyq9qj152OXuCQMbU1h+FWfdJlivwkJdfhCfyO4Wj0oy59L/Zu/rPDIWn+ddKhC6xUG5jFCaej+cJlTSmuEiQ7p57253iRrS9HbszkyT9AM8x840g4dweeZGU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YF8S/7Ad; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AXobH68h; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YF8S/7Ad";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AXobH68h"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5627MaVj026819;
	Wed, 2 Jul 2025 08:29:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=F+GY8SomNPPMRsYRX2bB672l00faAp8u0ZQ4OnmBnS8=; b=
	YF8S/7AdSN+KgnsB3r2Tm+dxneWP5FErCNq1LrU7d2E/YHVMBrqn8B4vUM2NpGQ1
	AbyqMBkVxCDZRQtgIW0C4jIe7ACXw5gZHqpkuof9y9DQHdcXqh/katcDFKCs0eqa
	729t4AGcRUWDaV9P88MJ9pcOXTxJO+dbL2HwbV/9VyTt0oplyNwejSgk9buYubEz
	Lq+Mmxo2ZhynunEhWM6XKsfjUN4Wx5lX9XcnyvUHXjheii1A7EA939YSY/mhhUSU
	eFzvylN4ufyIJatpZISVtlwsdNrlXEWYVTVPezKJ3GeVjqPMc7dz/sJ/NLc2Bqqq
	s80cmediZRgNK3I4OeTYIg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47j6tfecbs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Jul 2025 08:29:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5628ASrK019402;
	Wed, 2 Jul 2025 08:29:03 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47jy1fnymj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Jul 2025 08:29:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G0bsb9PeNBIxNbo9A0asbHDq0/fYQH8uuwJPtYVeYQeEBc1pXTMkcdnm9/6i7WdVxMxvP7L2GYCHnFP6q9JiGgHzzt726g0myXmSwin6OXV73hgdY1jrXXI/IW42KjIPFmica0kHsl9uK/70AzqIA2tgoGDeKHvOO+7K0gc0k2NRmSNpM4dIsOZR4+WJuEvkVbbKXNukl8wxsMmy6Uqo737rrEfGyqaFfZ+TKDYySDrSNMUTZrf3M/ZCgdxH13fy9JFn8o9opPwaMxz99f69r0UARN3bvsWHZqHtO7AcM+XNnkZxf316RXWoY4oNSuFfOYa4WzAnxbCh/kBc3qOR2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+GY8SomNPPMRsYRX2bB672l00faAp8u0ZQ4OnmBnS8=;
 b=iadOfHWsNKbwSlVNA9RJZx8YFR/a9hRhCyN837mQ4EuFK5DtXcEIX4RvduJJyqD11qK5O/a1N+cjEBmFZ4qM8uZ0a39wUiJN9R5a+2F8gXOZFIA/U4gdM05qDbzaKD1hd5iy7GGbMCUz+0ZAouEU7efShDeQZ7NzahdQ4BW04mW1jR4AJTZ0LOJjiMG36DQmhts3AKrrTPcsSoCym0fANicd+zHevLJGec2pvuUp+4g8az09TOyx04cqWAZybrm2D8bM4Bt0Nkiprxs/sPUL1gALsXP5elTGBUm20nlxQunFI4RvVGRiYQ9TkN+5m+ZCJVRmI6x4gb2PDvFYFOTsdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+GY8SomNPPMRsYRX2bB672l00faAp8u0ZQ4OnmBnS8=;
 b=AXobH68hDQPv/Nm6h5KkSkQxhytF8i0zevM4UEhgjt6snnlo7u+OYVFOYECz+uMxJvIScQWLw2eWa1DIEdIaMex2Pq8VJBZ+hU8x974+2bM+eiVJNabER30rnp96nFBcQa5diE2lpuzzuBoHbMw3bufJD7ZhN2WIhJAENWC0W48=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DM4PR10MB7428.namprd10.prod.outlook.com (2603:10b6:8:190::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Wed, 2 Jul
 2025 08:28:59 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8880.027; Wed, 2 Jul 2025
 08:28:59 +0000
Message-ID: <510bee79-9098-49fe-8449-c66366f73372@oracle.com>
Date: Wed, 2 Jul 2025 09:28:54 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] block/md/dm: set chunk_sectors from stacked dev
 stripe size
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com
References: <20250618083737.4084373-1-john.g.garry@oracle.com>
 <32a644b7-4f27-47b4-80ad-04026b2bfc7d@oracle.com>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <32a644b7-4f27-47b4-80ad-04026b2bfc7d@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR04CA0101.eurprd04.prod.outlook.com
 (2603:10a6:208:be::42) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DM4PR10MB7428:EE_
X-MS-Office365-Filtering-Correlation-Id: c8804a08-522b-42df-6b9a-08ddb9427d9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WWdqdTByWjJwbjdvS1l4c2lBOEorcC9pMVlFN1I2MEh1Vlo4M3ZXWGRGSXpD?=
 =?utf-8?B?THIvbzZtZWVPR3Z6UFZ1SG1zK3pDYi9sdm56Mlk0bG16RkVzV2ptRlE3d1B3?=
 =?utf-8?B?cEdKYmRqbXlyTHFwYm9tWDc1NjBXMVVESFJzUG9IN1VUYmZFMENvV2ZwaHRQ?=
 =?utf-8?B?YVpBOXpNVnpmN1Y5UGJFcEYvZnNUZ01OelczREdmUmZxUE4wSkxJZkpNcUlD?=
 =?utf-8?B?V2Z6TXh0d3owTEpxSmE2NDFSbG1OcVBLbVhZYVJJTFlUWTNZekFBOUgraktF?=
 =?utf-8?B?NjgrcHVnSVVGQ3dnVmpTSVJzN3pWRGovcVpOWVFQQWxUN1FmM1BoTUoxczdP?=
 =?utf-8?B?elNWRytndmh6S0Z2YWJGTHI1Zk5seVIwMmNDcDdGV0t5THNOdlFJTFZaanp3?=
 =?utf-8?B?b2FNY0hmQTBxRm9FMlhldXZLdlJhQnUvUEhKUXNlZnpwcGRlUThObmxuSzdv?=
 =?utf-8?B?Z01SbVJINjhZS1RTeENSMmMyOXdHaUJUbjVYSndJWDRkRXlMK2gwTEJ4VE1x?=
 =?utf-8?B?WE9ZbFptR2V3akoySHZkeEkvMGxIMGlhUVFXcURLSk9KMkFhQmJnaXpUeFlh?=
 =?utf-8?B?ckpxUDN6YXRVM1hTSnpSSkNEbENXODN4V3VWQVIxejZVUGNIeW1pTVYrSG1B?=
 =?utf-8?B?RTBuWWUvUVhQa3JIUXoyUkZ2Tlo1YTFnMG4yblo2VWVRYWsySG00SU8ya1ZI?=
 =?utf-8?B?eUErTGhVbUhGOTBBT2hkSEdPaGhya0JyTG1kaHV0bE9xN2o5bGlhOVc3OFF3?=
 =?utf-8?B?cnJqaDdrSUVwSXlDMVBFR3M0SCtKS1JtSHRMMmpRWnR1a3ZaUEZEcHdmRWlh?=
 =?utf-8?B?MTZ4bjB0TFM0cEgrRTcyWktnaGNFQWNwL3hFalJwTUpqL004ZjN3ZzA2dHFv?=
 =?utf-8?B?SUw5ZWZLbjdGTEFNcXJYMm1xTm9ieVpTN3dCYzV1QWozZFhqK3ppYjBVN2VW?=
 =?utf-8?B?amt6eVJaUjhsbUdoUWFRYit0S24za3BFaG5uVFpYOUJTa1VFNTIrdFlLSXZ4?=
 =?utf-8?B?S0tGUHBWbFpaVEp2bWZaMzBoSmxPOVJMdTEvVTBhdUk2UXI0N1BxbmJ4OUdZ?=
 =?utf-8?B?V0hON0d3cGNwcnVMUDk0Tzl6c1B3RDNBaFVWaFp4MzdYdlYwMDRhRWxwbWgw?=
 =?utf-8?B?ckl3ZFdKdWZydTEvYU0vdUFSbWJEVC9BUXRpN0UvNWFRQ3lwVW91UHNvTytH?=
 =?utf-8?B?dEV5U014V0VJaU1kSXZIMHZTbkUwZHhYOTdKV3dKclpMSjEwVUZvZEdTRTFB?=
 =?utf-8?B?OTczOUswZnNmbmhWdWwxUzZWQlpYQlJzL2wwN2FwU3NKVktCODV2Wi8vMXp4?=
 =?utf-8?B?dXovcEZTM01ROGdQaUV0eUZJTmVvZmJNVDN6Z09rdVpkcHA4djdmeTRuVVcy?=
 =?utf-8?B?aFFrMFEzSldoOE1lVXFpTEYrVHZBMXl4RUtUR0pOQUYxRURucy9LdjVSUW9x?=
 =?utf-8?B?b3BZYmQ0ZHVxaFNMVUxaN2IyMGZjU3M0cjI2aUl2MytDMVZzcStaUVZXbFJT?=
 =?utf-8?B?VkE4R28xYW80eWQ3Tm9QRVdseHBSZ1ZmTkJLaXNJNW5ZZ3lNYWRPMm1vNnkw?=
 =?utf-8?B?VVNOYk5BT0xTUHdpM094NGNoVEs4Uzk3d2hjeXNYMTBIejVPdUNveFZGMndq?=
 =?utf-8?B?cGQ5cURmTXJXTGlDMDBIYVdQeEd6R2I3RGRMd3p4a0FwNWJPSUZWSHJzT2hU?=
 =?utf-8?B?dU9laTdwcG1QdG5taGhaL2s2QVZESElWN0kreUVUaWtRdmdibXhzTjlpdXZD?=
 =?utf-8?B?cCttS1RQb01GOTdGK3pXYVhvaWUyUkVlYVRYNEk4KzdJNTNxL2ZPd3hvVm01?=
 =?utf-8?B?aDhORk00bGRDK0ZLOUFPb0RjM3hteFJoL09uamRyWWxBMzNDZnZmUTdoaXdY?=
 =?utf-8?Q?MOM8HV8M76ucx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VldFMUJmckdmNHVuOWpGcEphVjZ0bU1UV2Y1OHlXM1Zab1Ixd25vWVVUVEFN?=
 =?utf-8?B?cllGWGVKbGlaSmROdXFqQmExemplRTNKUTlMMDJaeXFSVnZteDd0Vjg3VEs3?=
 =?utf-8?B?RVhSUVpzdVRUZ1NUVXd2d0hsaTVwVXFXb3BGaXBHcjVGbHB2SGdiYXI1V0hE?=
 =?utf-8?B?T2Fwb2tycUpJem9qdFJhQ3dOUWpHK2QzRDJvMkZEUFhnb1FpN1dMakx5VHk3?=
 =?utf-8?B?Nm82Y3NHQkpCTjdGOXlBREx1TVVXZFA4elVFZnB1TTA1cmVtN0xkL2t3QkJ0?=
 =?utf-8?B?WkRvL1J3RkNocDZwMVE0UjNGNU00YlhSLzQvRHpkVEN5ZVpQVGRZQksyVHdW?=
 =?utf-8?B?RkVZSkh6TWV1UWhqV2JPcENHSm5mZUpoWTZiMHV1eVIyY3RyQ2ZoWmZzcUNL?=
 =?utf-8?B?dTZjbnVBMTZCNEF4UW90eTl1bGRTY0JacWQwclF4bU9pVzROZ2xDajRUK2NS?=
 =?utf-8?B?Zm1VWGJTVklKNEV6TTNHUjh5WHdjMnpuTzRGeVhGWkUwZ0c0UDA3WStnVFln?=
 =?utf-8?B?VFVEeENZL0VQdFFJY1libVFscjVSSCt1cUJ6T1kwN09qTy9rV3IrQVloWlg2?=
 =?utf-8?B?T1VhZ0Y5bGNEVWRkQUJtTEhxM1dlL0dlcUdKcUZuZWtSZ1FDS2dFb2dYcEhD?=
 =?utf-8?B?bVhnRTdmNjVFaDVCZDg4SE9lRmdCOCtYWkdkZTMvdHBURjlNb1EyZ1R5bEJn?=
 =?utf-8?B?LzZualVKWk1NV3lLVmREbzJyYjc1b1hYeGp0RmdKbE5uN2VtOHY1cmVqZkxv?=
 =?utf-8?B?NXhzcUoyc1NmL09vTTY5RkNleEF6cEtoTHMvZ1pIZURqaTFOamFLTFZ5YXhC?=
 =?utf-8?B?SFMyWWlQWkNKcXRIR3MyeC9Cclh2YVI3U2FPZjh3djZkcGtDTHUrZy9wUlJM?=
 =?utf-8?B?bWdEZlVpdWMrK0tFSXBjcG83VXlXMElBNkYxRkNnQ0tXejA5Vkk1VmNRbTZ4?=
 =?utf-8?B?YmlhU1dWNXBhN0NLU1AxMUxlZno4d2pxWUdwSTZjUzMwMi95RGdmWm4yaTAw?=
 =?utf-8?B?V2V6Q3BxR01QN0RrNDQ5eGxHbFI0bkljRUdlZ29jUGVVeDJQU0tDYWdQTHhC?=
 =?utf-8?B?d1hybENNYldKTEd1TmxpS1FUM3lpVndET244RTk2YXh6OG1lc1JUOTNZV0ZD?=
 =?utf-8?B?SHdKOXp3Ukk3bCtJU3c5ZHJJbjFRTVUxbGlqSUZ6ZWgwVFMxYjEveXFlZ2Ju?=
 =?utf-8?B?OXZvUHRTblNzeERhSFJ2WUcxbDZEQmdTRmt3cERFcFBIeUJyNU1SazRsaUZX?=
 =?utf-8?B?SzF5NVJGSjVBTVhkUkpCOEIvZjJhYWVVRU9NY250WUE4T2xRQlV1YXFkY0Q4?=
 =?utf-8?B?V2Y1T2toZ3B4eWd3eUliMmhTb1lUSTM2am1EUStUekZJRXBlU0JRNSsrSXdv?=
 =?utf-8?B?Y3U1dXBiM0cxNGo3Y254bkNzM29ucVJSQzhNN05Bd3Mxb0lkTkg3VzR3Vnhq?=
 =?utf-8?B?SWhud0wwMERFZXpEQmc1T0kxVnQzN2ZiVU51SFVwcGFuTzh1V2lYQmRoZG5V?=
 =?utf-8?B?SEE0SEJ3MFM1Vitvdit5MVFVSWRGTWlRTGNiYmlrNFZiNThZK3BQMmc2K1Zu?=
 =?utf-8?B?MWo3cWJ3bmNLZlpSSldOVmRkd1J5WUF6T0NGR0N1YVFEWVRySDI5V2tSTG5w?=
 =?utf-8?B?U1VqbnRpaWl5ZXlZcXl5MUxQSThuV2trVTllR0ljYzB5dVYxT0VkQzZMR1Uy?=
 =?utf-8?B?ZEw1d21lclJldkRDOHQ4ZHhUQ1QwczZYR01saS9PYjBqM25RZDFJNlNQV2tK?=
 =?utf-8?B?ZEdac3NJdC9XVG04a2lpdlRLUUxTdjVCcEdFa2xUMVQwaWVsN1h5SHp6OElR?=
 =?utf-8?B?MFNGdzVEWUM2WTZ5NDhCcEtYMkhFa2ExME5zKzR5bmx6QTRhZWxWNDZTa0Qx?=
 =?utf-8?B?d0I4dmY4c1RIK2lTYjYrZUxpbEw0YjZVcGQ3RHk3UmRzSG5JNlQycjB2TWli?=
 =?utf-8?B?SUNVZ2MzODBxNysyY2Z5azROa0dRc0xlWG5OTnNEUEZCNEJjb1M0Y05qQzNU?=
 =?utf-8?B?NUpvZVBidW1sRllPNUtNNkZsSEY4Qmhmd241aHVRM3I4VlRWMk9DVTlyWmNt?=
 =?utf-8?B?ZW1YMDBQdU9CSVQ2a3YxclFpbFBrTzY0YnZVdnlwenFkTzRJWVp1ZVp0cHFF?=
 =?utf-8?B?NnBKeVRHNkdmeE9uNmErSHZPOW5FMmR1VnhkWlAvZXJJYXdrdjBwMi9IOE02?=
 =?utf-8?B?ZVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	K9sl9zDaAUvore6f1/YYyT10GPW/LdMbNmPWAeg9UCvbSxuZJEta8DnvxXnU8XspGABSAqIYHqQ+l9HPk70HFywQpsXSG/IAVZqXfdAFM1Gp+9Qwl/xSLzMfLiX4mtqyEYaTt7I1cKAqy1ke2T4T4zIGP2KRzwAJFElSK04/gCaa9Ao2IdK9SZujAgl/qZhLQyg2qY9JG69G6GvSakpAHGeu+P/cEqcmy3ZDqWzsbklwBEiNIRtVC09s54hUoEPb+H+uUEXLa+qEheRW5GC440hGnGJTty7XSV+gwqcaQ2TU/mJ+0vCyfEhLQHkNB5NVeFdziSvTliYxEmqm5pNi2IqDNV2nJQM5eOeVAghw6GL3LKe5+HB9GnRANp7Avv7/ehy4jnKPaKp/tpwLYcsEobglgF7Ufcm+Htx6RcOBIiPYtfXAGeX9J5I375JnHCHU8+4jhtVa84A7NOUpl8RptI6oC+S3BPhxW2fHc1kol7kG8C+ShWHjvSB0p0+A/pY2y9c93ttlbecXpfUK/ccK92dEKk29QsbYzCPAqBWLpA+7wGd/N8/SUtz+D96q0h5HWQqhxGJeTFgjkhy9YHgZkYCI2bcH4gkdjACKAtKECfw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8804a08-522b-42df-6b9a-08ddb9427d9b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 08:28:58.8128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sifCQX8r9UPg0JfhGXBBdLkAk8E6GuPND30LR3rqSAaBuUTtP3c67KhCY06BSqN3wrKBjtgfTvVOb5EjsplMpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7428
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-01_02,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507020068
X-Authority-Analysis: v=2.4 cv=CMMqXQrD c=1 sm=1 tr=0 ts=6864edd0 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=uherdBYGAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=pnC35hD8n4BYsXDOBjkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13216
X-Proofpoint-GUID: kfdwD3u2qsxpRkBKWRMQkAwuYUVyCkgA
X-Proofpoint-ORIG-GUID: kfdwD3u2qsxpRkBKWRMQkAwuYUVyCkgA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAyMDA2NyBTYWx0ZWRfX2GoJ+WyBI86w YhD4/PRhmPu8ZPkvnPXFQANenwRoq/8/+bazzNiDtmkYee4rFKy7319eHHldxQnfYVLHGgw/UjH zfA+hixwHT0XIL1stC7okYvKWYpP3QU/O/IOLMMroi/2UTCoWtgS9p5ZQQl6MV/Uo8+vHb/Iqca
 XECVBO/hxRID5tikTZP2Ul5eRBLmkM2Fiso1NVCebq658G3s22IHN8KVfMy27CZQ3aHmwdxq0ps IR6p51nRY8tMEIB8WAiVhkOmS8V0ozgM5NLhUzimtowBDOYbm6HqHQWlwzegns1I7F4U+5wfurn AH7PjoUWGt8Rzkmpc11OJwSRT85Ce/pkNJxrQBxqw9s8cmXlS9EsqYKkkJnY6yEx5Ty3ndg3pVe
 QBPVdW3vLibCdFxxS9VtulEDyuNxioM5/SqqFzxaJYBi4kmHQIfaC0fpcUAp+Yw4S2jTS6WO

On 26/06/2025 10:36, John Garry wrote:
 > On 18/06/2025 09:37, John Garry wrote:

Hi Jens,

Could you kindly consider picking up this series via the block tree?

I was hoping for a maintainer ack on the md raid0/1/10 stuff, but it's 
quite a straightforward change there.

Cheers,
John

>> This value in io_min is used to configure any atomic write limit for the
>> stacked device. The idea is that the atomic write unit max is a
>> power-of-2 factor of the stripe size, and the stripe size is available
>> in io_min.
>>
>> Using io_min causes issues, as:
>> a. it may be mutated
>> b. the check for io_min being set for determining if we are dealing with
>> a striped device is hard to get right, as reported in [0].
>>
>> This series now sets chunk_sectors limit to share stripe size.
> 
> Any more comments here? It would be good to have the md/raid0 and md/ 
> raid10 changes checked by the md maintainers.
> 
> Thanks
> 
>>
>> [0] https://urldefense.com/v3/__https://lore.kernel.org/linux- 
>> block/888f3b1d-7817-4007-b3b3-1a2ea04df771@linux.ibm.com/T/ 
>> *mecca17129f72811137d3c2f1e477634e77f06781__;Iw!!ACWV5N9M2RV99hQ! 
>> I8diqGp3zAZO162eEpQ1SuUsrvAMTWzhbHUSxxn23h3TLcRRTAs3LUDanOeWiK2osXVfFD0HHw4PioWzfd6MhbOnyw$
>> Based on v6.16-rc2
>>
>> Differences to RFC:
>> - sanitize chunk_sectors for atomic write limits
>> - set chunk_sectors in stripe_io_hints()
>>
>> John Garry (5):
>>    block: sanitize chunk_sectors for atomic write limits
>>    md/raid0: set chunk_sectors limit
>>    md/raid10: set chunk_sectors limit
>>    dm-stripe: limit chunk_sectors to the stripe size
>>    block: use chunk_sectors when evaluating stacked atomic write limits
>>
>>   block/blk-settings.c   | 60 ++++++++++++++++++++++++++----------------
>>   drivers/md/dm-stripe.c |  1 +
>>   drivers/md/raid0.c     |  1 +
>>   drivers/md/raid10.c    |  1 +
>>   4 files changed, 40 insertions(+), 23 deletions(-) 

