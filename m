Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E341D33CEA1
	for <dm-devel@lists.linux.dev>; Thu,  6 Nov 2025 14:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762438341; cv=fail; b=lOJvsvHH5+2/BFcWkWrTJ1mYYLZ9r34rekH1wFldFct5+oh52KYlPFAspVqXCmEcdY/AdDJGvkJIyI5Y5F9n0WO1pDW8yu9lVFVHyEKvKkCzpdgvc3D/NnyuOkV45VzL02eOh2QaKr3R1sQMt4eRiZNdraZE4/A/XjyR7maOclE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762438341; c=relaxed/simple;
	bh=/cdcWcT7zZWWFoCZcQupSpUcg79WX2eaHONBmBJkAqI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dW+grvwCBfwZfUyhrMrH5atTWa8imJTZkidrrFBSoV8U93cvW7+TyD4GwBDbrz/uTd/cw5pXHejs1MfHDKK6OK95Jy+/VpBSxP1A5flAwiTtv3KUWUtVgjM7S/TeiMbRLQYQsZwYrblHEj/1ABZ8RsV/vdtGTmh0pOFAOFpiUS4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oDsC/Pq7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nCaOqX2r; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oDsC/Pq7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nCaOqX2r"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6CA4R1000476;
	Thu, 6 Nov 2025 14:12:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YaKh6Cng5TOOgXPQBjAGa9//fB4KU68EGAUAm6uoxmM=; b=
	oDsC/Pq7VYaEL5qWoPpG0Xdj2P+cWQFDu3Za/OtUFY/m8YCBCDrFm39zr5VNs6Ri
	OtWWZaTvmchaIQnEHfgS5jtBGl7Iej35xq2ZQT/FomVWCyXsEBQLT84BwyNNmORr
	j952Znb7TjOAjYuxi+gqx91JxUuMjicvKY1WMts/oTYREoveqtWvGHV1ZWoyKlCg
	LVVUoRDVfdtSHozHbGMujDnMd+1yrgPxqhe84Uxg6elMKeIR97SP81289OAYKaDZ
	V68BLM5PMtdU6G0QNAn2UvtFwlxpFF1DyoWRTsd0pswzT+UyzOfesP0aW/MFSzq+
	586ByLutTHs8LGB2RHEtCQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8at923kx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 14:12:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6DwYNv002877;
	Thu, 6 Nov 2025 14:12:15 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010056.outbound.protection.outlook.com [52.101.85.56])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ng1ju8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 14:12:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XfwdF1RVQyoOrtQHRzxQc5j9LV7Y0rfHHmfg9Oig7VOJe69t8bMsWypIFCsTUejTnZK9dt47RLkt4BBnIjMXN1pogZiSr+pJgF6+rj6F5UBxXy3OpL5ugyOhBH6Drzc9Dq/ThPbJ24HVa/1GmEZlh74dfUPSoCH1lLcGwSzLMj4yYv1WF7x22cSFtxK7QcoSoDbe3VqNXPLn9qW/3jXR5prCcoeaOhyKDN5lqkLrSRorE4+w8DczbbOW47KZ6EUCJnjAWrQpW5cnjDiYgBo6/4WoYBXXrnZqqCNAdJ3/RVf1X85dLp8ylMNLBnpNSblnX+9LBF6r7iPLEbUrz7c4ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YaKh6Cng5TOOgXPQBjAGa9//fB4KU68EGAUAm6uoxmM=;
 b=D+Ii+IfM7CLfm5gf/Ih9YRZI/DRuoxgzZeu/IkBuTk8dW2+adWhIebCYDgzJhAf8s6BFQ7cGJm2TSCcD5cBonpTDRZDg1GFYLDJpWj5IieewoUO6XxC0caJrCIirl54VG5igrJvTkK7WkBcJBCdfCwUK0KuQbQi/ZtWtSaEpVXZBaWEV24TBaZkzp4sBm/Q54ZlVnV+5+9hwwt666C25/yT5gGHLO67/uYW7WJpjOpGzKYH4LLoQFmG2cIcSg0hSKXPYDjO/GpCtOVDh9jqlkIRKKUJbX69BwJHxKZHwpPnv0aT9mPvQVfAVnWTTW2y+jb36EGjgHKXdPTwgThq9ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YaKh6Cng5TOOgXPQBjAGa9//fB4KU68EGAUAm6uoxmM=;
 b=nCaOqX2rQGY/M5EiUZv8lU8h18M3Af21VXrbzP+RrFLQZISwoTq8vIeK7dC8jM/iQV9lgm6vzcycJEUQvrN1I1oFzPr+pzFNcRWbp4/+1qK8/OgR86WXMoRC5//95RgZ3Y+016TOtIhoWSQU5VB3sIykf1GWq3wEvCFfLTV+oCk=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CH0PR10MB5210.namprd10.prod.outlook.com (2603:10b6:610:ca::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Thu, 6 Nov
 2025 14:12:12 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.006; Thu, 6 Nov 2025
 14:12:10 +0000
Message-ID: <ec21ec69-9c1d-4d53-8674-6551dc294ed9@oracle.com>
Date: Thu, 6 Nov 2025 14:12:07 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] dm-crypt: enable DM_TARGET_ATOMIC_WRITES
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, agk@redhat.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        michael.christie@oracle.com, martin.petersen@oracle.com
References: <e0b99d8e-1159-a489-6df3-648b21c4f091@redhat.com>
 <aQwCHqrdNMy1wy75@redhat.com>
 <513ec9c1-a568-a98e-18ef-e42d9c73e3e1@redhat.com>
 <16e9a3d8-8334-4164-a41a-4a2da0467c65@oracle.com>
 <05ac7dff-bdb2-049c-e38b-319e81170234@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <05ac7dff-bdb2-049c-e38b-319e81170234@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0259.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::31) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CH0PR10MB5210:EE_
X-MS-Office365-Filtering-Correlation-Id: ed259f4d-eb56-4b79-cece-08de1d3e79c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VEY5UmsyTUpyVjZRcFNjcHNaS2cyUklZdXFpL2FvODdrbDVZbzFBSWZXSXo5?=
 =?utf-8?B?a0VWL0xIRWRBVHNKMjZDcWI4MzFpa1RyR2w3MnBieTA3NGU0WUt3UnZpaGlm?=
 =?utf-8?B?dHFOOGYvRkxIUzBYRWtTMk82dmF4RmtIYmhPZmNHbFVCUVBPRE5iaVQyNnRl?=
 =?utf-8?B?WWVKOEROM0VHR0N6WnhSZWxjVFN4QXF6R20rUm40SXE2cDQ0bFB5NnMvakoy?=
 =?utf-8?B?aFBXYnUyRzR1YXBJNm50SklpalBNdVVxdFk0RzNqKzVkUjI0L0tld3liWUQx?=
 =?utf-8?B?djF3dHQ5bFpCVzhFUWRMdHk0Q2ZhNzhGeVZyMFdqTXhFUDVpSkFrbkE5VGRG?=
 =?utf-8?B?TVpxcUNxZHpjRE9HZlp2VU5wRTljK002Y1R4QXRMdHlFVnY5ZVNvdUtaK2VO?=
 =?utf-8?B?UXV4R1oySS9raEJaRWZGdnJKelBTbFZxV2tPKzdWZmt6L2x4aHY3eDNwTmhR?=
 =?utf-8?B?Y3dRajdFekVzUzlYaXVuMTlTaW0wK29qemlndE5qbGorc2dSZDVkclNPN3hz?=
 =?utf-8?B?aEwrTms5dlNhcmVVNHVmYkRMU1pqb0ZodEJmSm12dmJZaG90T3FINlFTdStF?=
 =?utf-8?B?MUNwTTRwK1o0UmVxTTZWOHJBWVp4dXlEbHh3MVFTSC8yUjd0cWhPNHRtbVU0?=
 =?utf-8?B?K1hhdVJmdVBmMGlranVJZTVUY1FqUDZGaWxxNjZQbXpocjRzV0ZPYUxYTURL?=
 =?utf-8?B?WDNUZ2JlVDZmOWxVdTlZZXQ4NmJRdkZsOWIvUno1ak51ZFdsWi9ZL2MrU2lL?=
 =?utf-8?B?YnRnZ01ZOUhtQ0MwakVadUlMa2xCRGxpbU1SdHJlQzg1RWJiTWNiMk1adnZ6?=
 =?utf-8?B?VXZNa0MvZmtDWVZscDVEbnVwbU8zWmNqZkdmaWl2Vk9DLzhEYzduV1hHVHJx?=
 =?utf-8?B?T3lxREFhZG5rZHQramVTQVBJakVjb0VTRVF1TGV0bzFVc2lrK2YyOC9Zd1FJ?=
 =?utf-8?B?UjQ3akZGVnIrQmpUT3BZU3IrajlHMkdhdStyOXBLYzNYeUJNUENoTHBjNXQy?=
 =?utf-8?B?WVFtOVZwWEsydGZHNFAxa0FyZS80Rk5HUXk4RVl6bHgydnJSYkU1TFlDMXdZ?=
 =?utf-8?B?b01tY3ErQmVtNUFYZmkvTE5OUDQxMnk0L0xpaVZiQ2Jka3crOXRwY3k2emFj?=
 =?utf-8?B?NmVPWXVBcEtlS3UwOTY5V1JaTld1VlVQS1NnSnFJSGVIN0Nxc1RKRUdNUW00?=
 =?utf-8?B?ZWcrVmdHSy9TcmdEcjVHSzVHSERrcng5Q2h3MThyaC84ZmdGRzdvenMrWEE5?=
 =?utf-8?B?WVRlSjJYTDZGTEJoOG44My9NV3gyV0oybWFtVlJiUWI3bTRyZE4xeFZVT2NW?=
 =?utf-8?B?c3RNTVpJUTBUaEQ5RlRqbnZkNlNvUER1Q0twRXUzR0hpMEVLamJvUkNDRU4z?=
 =?utf-8?B?akNIU3VibzBEWlZKQU1xaFF1Q20vTldjZ3pObXZyYUtNQnlodW1XZ1BYNCtB?=
 =?utf-8?B?c0hrc2pwZEpyQlpEa2hVWDF1N2ZYbGZLaWEzZ1RpUDFNcHpYSFhpTXhVZW9t?=
 =?utf-8?B?dllYMDBoNTJzWkJKejZBOFQ3aWdJTnIwbVVPS2xlbDVUc1A0SWV0L3FYSXZU?=
 =?utf-8?B?NlZTWitLdjBoUDM3eVU0by85dmE4QjgwV2JvbHcxNW1BeVVxUWFPVnFqTmNP?=
 =?utf-8?B?UVJzNVdrVWxJRGNXeEs3YWpvQnVhc2tSZHZJOHlaZkNHc0RZdVlZQ0xUU0Zs?=
 =?utf-8?B?Z2I2bXFrbVdkYzd6WjduQmRSWnBqblpOYWtRN1hNZk5NNlRHZFA4WEtMemUx?=
 =?utf-8?B?U2NGSDRPcTE2aGg4MHhFUDdNVW9NYjNYeC8rWEZOaUhqellqbktjRjN5eXBG?=
 =?utf-8?B?SldBd2J4c0d1cDVqdm9mTzdULytmUlk4SmRXVks4ZDRLazN0empjUlNVSzQ0?=
 =?utf-8?B?d3kvMi82OW9aYXRjekJrZ3d6S0gyODhMaDRrS0tDV3FMQUptaHh2UHRVVC9F?=
 =?utf-8?Q?turPLqEPEqO1pwR6UtWL/Lca0nxb9ltk?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?czduOHFXeWs5dFZqUUdDUEkreklHclNCUXdxUzBTRjU1cDY0SlhPYml2UzVS?=
 =?utf-8?B?UHp6dE1NQ3ZBNVlYTEZkRHh2cTJubGJwdUM5ak84SDJ3Q2RLMTV1ZWliV3hn?=
 =?utf-8?B?a1MvOUhxYTFPS3RINWZsbDlmYjQ1YUUxYWJtQURUS1lVYzhiWEEvbEtpdEcx?=
 =?utf-8?B?M3RKTFZoTVlES0U5RlhZNUpmNk5DSjYvMElBOUtPTEtCRDByaWJVdW1neDJY?=
 =?utf-8?B?OU5uVE1acHdWSENoVnVKY0hHd2p3ZHRIM0V0UzJ0STRnTEliL3VkeHd6bHNx?=
 =?utf-8?B?dmRmVXRENGZpUVppWkc1TlNTbkhTbVdLZW5NV0VzekRUbUwvak5wb1lKV20x?=
 =?utf-8?B?N1pMMGVOWHhxNk1jd1hSM1VnQkJyNk9vdTY5em1pQ1Rmbzh3Z1dtcFgrYVg0?=
 =?utf-8?B?ZHk3SFBKY2g3S25zUFBRc2JXQkVtaFhFVDJsU1ZOdUZhTmJROXlkbUQ2MnMv?=
 =?utf-8?B?ZXg4RjY3OGJZQm84QW9keEdrZlpQZ1MrRlBMcXRiZXlhTFpndHdwenRiVERY?=
 =?utf-8?B?SlpvN1p6bFdFdmZ4bWlWYVRNZFIveU05R09zUGI4Kzl1dE5QK2hKMWRLaGpz?=
 =?utf-8?B?emJVNXVDMjQ4dXZjYjMzREtrdytBNi8yaFFLSzNCa1JDZVkrYWZZdlE3Mkll?=
 =?utf-8?B?WTFRY1dzaUhrOEs3UnVPL0FaeTZkV1ArdzJEWVpnZWh3K21QOTZpMElDclFM?=
 =?utf-8?B?emxWRlBCVm9qTkg1ckt0cnlOVGFWYTYyUXFrZy9HcCtCODdtYW1PaE1xdmx4?=
 =?utf-8?B?MjM0OGJZckRzS1N1bW5NdStyMXorVkFNbWV4QkYvK0pjM3ZKVURHUzl1WEM1?=
 =?utf-8?B?RlVlZGVMTGcyRWtzREtuSmJqQXUrOEJkVmVtYmlNRXF4U3FEeGVmM1N3SDI2?=
 =?utf-8?B?dEhCRGptWHM1REYrbzNEWUN1ZTlBUHM2Z29EM2ZXVXhQbS91Uzd0OWJEV1Bj?=
 =?utf-8?B?U2YwSFY2NTVZRDJ1dGlhM0FoN0lZQlJpQ3pKdER1YzVYRkQ5RDVWSUh0eml1?=
 =?utf-8?B?ZXV5ZkFuNEpqZGJoS3ZQYXc2Z1lkUGVpcnR4NXFtM3ozVUdlNXFJZ0grSlRw?=
 =?utf-8?B?L1JGd1ZlbURvRHVWeXpFTVVoQm5NaVVPQy9mYzBlYU1NOUJKTzN0MmN1YUdh?=
 =?utf-8?B?T3dyY2lCN0syMFE4Zkg0SHZPWk9uOUpDN1FBSlMxK2wzRWFMMU92Zm43cGNw?=
 =?utf-8?B?TDIwYUgxK2hDR0lBcHRIdUtJbWhOTUZkMHZXcy9ESlR5cS9HQ0xSNE45d0lG?=
 =?utf-8?B?TnFmdzNOdm44WFBoSWlZRjRCeGUzVGhyMTEySGZkS3c2SkhSQW44WkFkdktY?=
 =?utf-8?B?UUxKYnVpVDF2UFIwM1poVS9jSy91eXpSUEZqWDBOaVZUL2lRVHFGRW5hNkdr?=
 =?utf-8?B?dGllN3RDVzEyK2FtSGJvV1MxQ0d6KzV0VkRuYWZoYlJUKzlQQUJnay9NL1R0?=
 =?utf-8?B?YmRUU2M4T1U4RENhdWsrUEQ2RWdkeDBtMFlVTzlDMyttQVVSUHVBQkt1SG16?=
 =?utf-8?B?M0N3RFdJNXJOQmZEdVZLOXlMeUV4YlZGV1lNRExUVjJoc2xVMFc0T2IyTVcv?=
 =?utf-8?B?aTZiWUpnY1BJWXpMMTB1bHFOSmc4ZmwxQ3JoT3dOVW45OUNpM3VhMDRXZ2ZH?=
 =?utf-8?B?Z2NwYy9PRzRyYWNEMnFvN1BxWVpyWUNpN2Z6TDVhZEc4RUZybVRFNmk4MCsx?=
 =?utf-8?B?b1R0SHRyMFJSdi9wY3E0Y0hHUGk4cmY3WjN5YzI1RDhXWkY3RXZjSUJBazBk?=
 =?utf-8?B?YVU0YzAzQzEzYnJGQmtDRExjWXJ4VnZhN1JDV1VyZWpSV3E2bmt6dkVtZ1A5?=
 =?utf-8?B?bVBvM1pMZ3B5b1puejVWRVk5VVZWQVZKUUlnYTRST0plamdXTzN6Q1ptc0tL?=
 =?utf-8?B?dnRIT0w1TlQ0dit5UFJhQVFuOFlaK2YvZnVDZFVpV1RvVWNFV3FQd3U5L3NO?=
 =?utf-8?B?dnhCckRTT01RTnhQOUYxUi93TThRekYyVjFzMlIwVjVhNXBBWDR0RUloTGhL?=
 =?utf-8?B?NWJWSGVVMnFvVHhQeWJqQVFxMDF0blJzUnA4L1RSSGVGUzkvZDZONlZUdTUw?=
 =?utf-8?B?UjNyUjQxUm53SHlyUjhaUjVZVlJpRXhZVFA5TlFzZm1TbmVxaHhoL3h1dHkx?=
 =?utf-8?Q?/8ATDAqH2rkcqBVHWvGElPpXV?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TXjTANZzEFEOW0E/BAn4J5A10XB1bIiYR57HUdIH++pyJ2Rk0K7EIEILlDLKXBYJ9qSQu7SQw9xVTppzDDRPoagacAsiHtmUMLI7xMo/p0E7znl0N/lNjDKYCpgyk1InpZn1Odjg88sidTXq+TDgQhbyZY0lyOywv6l4BLbPW5LJ7I+PTFqF37MkY/vhpG6RwjxXyJf3gaJAgn89MFz665Pbkv1VFU65CK7mY15/xi26V0CXz2hxtYFlameNTXjLXxjQgpJ/g7Nr1OqH5lXGz5CuSWTclE7gQYsTBRqKVT1mS11ibDA+xDYlbI1k5cF1ofNwzi8qzFZNqU34EFSc+zQ/RDW43hWVmr3H0kc4BZ/aiKkjrkUvYt8VtxWYNFEXHO4+cgNpGAMgkmDluqp1yupU+2FUodG1mnzsdcGXNFiejjiIC54pUfkGTh23vPlXJJTLn/AY0KzitNqVmRwr04xVB0LFn8YAQ77dNXs58nKoAhe0RfclvRMYVWeYH8VY+ghEDo68ZFJS6GxYttGDtKA3+l01800Zz01rGxcahIkE7sNROzuJ0IlFfPHgNXh1SJpGgFaUKg7eFGYOifcA1lY38KseDOvVSxz1o0nTo/w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed259f4d-eb56-4b79-cece-08de1d3e79c0
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 14:12:10.4759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KstpSvZ0IfhFXIPRfKCOwzjwSVcsK1ySK0Q0bcmwXuo7yuytwQ6ImQWVyQeGDtZu+1xjJE8Hg+v+E1xqrmKcVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5210
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511060112
X-Authority-Analysis: v=2.4 cv=HPPO14tv c=1 sm=1 tr=0 ts=690cacc0 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=dR5YDe3e5jyw5GTX_KIA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13657
X-Proofpoint-GUID: t1QGnSUmGAzklTPwh2iX9peB8JN7-ADV
X-Proofpoint-ORIG-GUID: t1QGnSUmGAzklTPwh2iX9peB8JN7-ADV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDEzNCBTYWx0ZWRfX8wIZptuhye8M
 NMBL9247c4jDycAOXSMW7mMSvfhopQ6KLavMmv//rQ+mAu3qbuOzTXssHIjJnUtIyRqCzG3LYkF
 x6yzjD9ncgOSMkuiFlPbw7BES2P9YcGJyt8cdrA6uNFUbYsS3wt06iufCIzLaO+HS4M/VahC1fs
 rnVrHF7zqbmE6rtJKxOKVMe4QzZskuhw6NrSEDX+y4ABWfoH71bzV6xTWk4RUjh7p9qnwvB1+1A
 nInlJvyZ+s7YPFwXkDM4LqqlSuKTtHj0nWGP60rd7o8v+Lcx9eMb9Vd7ddJRql452cCvBvI7FgG
 e0DWoC2BSRn5bPEVndYFFm80OSDOjOhI/6KJ0AN+0QQPv1RbzMEQXr5ylf+fdU9fIGaGSfIJ/V8
 qM6tlfeOTLmZlYd61L8jqDidXj+yBPFgNjsdeACd7WhmUxBVGjk=

On 06/11/2025 14:00, Mikulas Patocka wrote:
>> The atomic write size is limited elsewhere, specifically
>> blk_atomic_writes_update_limits() - the limit there is quite similar (to what
>> is added in this updated patch). So I don't think that we need to do anything
>> special in dm-crypt, as that block limit is already tighter.
>>
>> I suppose that this code can be kept with a comment (saying that it is
>> unnecessary, but safer to keep). Or we can just drop the code and add a
>> comment (saying that we don't need to limit here, as it is done elsewhere).
>>
>> Thanks,
>> John
> What if someone creates a hypothetical device that supports atomic writes
> larger than BIO_MAX_VECS << PAGE_SHIFT? I think, we should limit it.

Yeah, it's entirely possible. And this is why we have separate HW and SW 
atomic write limits. The HW limits are just what the HW can support, and 
has no theoretical limit (apart from what we can fit in the 
request_queue limits values). But the SW limits are a combination of the 
HW limits and what the block stack can support (when guaranteeing to 
never split a bio). The SW upper limit is about ~500KB for 4K PAGE_SIZE 
- it can be less if the bdev has a limited segment count max. The SW 
limits are what we report to userspace in terms of the maximum atomic 
write size; in addition, it is the SW limits which the block stack 
checks for when submitting a bio.

So you could cap the HW limits to BIO_MAX_VECS << PAGE_SHIFT, but it 
would not have any effect in practice.

Thanks,
John
