Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FE121C178
	for <dm-devel@lists.linux.dev>; Thu, 12 Jun 2025 09:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749719891; cv=fail; b=VYsi3LOoHpFj2FrqE/cdMwZhxQz9HWAr0kb9H0/SPfnSw4lBhBK5SIx6neEIoypjC2QbiWI8WhCFvuBmtGqBFXzST6t/P90njx1cs/fj7WvuVMG+n6mYgOG22Mb21kmlfh8hVauxmqUg90PJnXWPfgeuRBbZOdWcWRFabcwNY2s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749719891; c=relaxed/simple;
	bh=jyT4O1Ipz+WPadGCuBjef/UrJ6J/YGWfYLxQVXvzLko=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=myXk5wdfNNqP9UvSmt9i4Ama4xATc9qC71626xTFlVenyxq3JHVDNZv/A5P81GNfzvg27phsBCBppFAq95ggcPUoe2U1qKO3btVtRYzeUzDq93YNA6Uo9JfncFtb6ZuRjfpXy35wymKilrcfyx0KWbdEDtbdS45fw1aEzvIf77Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=n18GHBHs; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UkS1cBNp; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n18GHBHs";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UkS1cBNp"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55C7fYs3031306;
	Thu, 12 Jun 2025 09:17:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=sF4uc1voVBh0s5bV1x6x9fnr9+XuJWbl70/o6E2rNZs=; b=
	n18GHBHsARzW/ktJ/ZFPlnhr5VAykeUkVNdfDiDxwr8y1iRUWHc+UMvHZjiai9ux
	YDO/wqP7msQ2BJQOEq9Rnhmz1Hvto55KTa2SYl16zswlEpgjlagVHbilpuGVjzh8
	hOzJ2CvPzZLkBHWJ0vee2c2GdJrD33euKLT/Y+HOgK9lTo3wdqTfUgRcm5uTZ+T/
	r+1gZvi7muRovTj43WPwVIXUAxaog0faQ618ywFecMEq3xGE2SE+XLqx70O6nBhD
	KUBwCnX9+7TmY03e28azVU9WHaKgMRTmpAow5qj48Yy3SOSd+cppoKKDwbT00ffX
	1Iyyd1dq/E2E5y2jvA8PZg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4752xk0qtk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 09:17:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55C8463u016780;
	Thu, 12 Jun 2025 09:17:55 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 474bvbbg4q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 09:17:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dJUjGLKZOMycjjzFlT9p5nFcj78lm3MGR8l1zPNhrfhECBuPRezlJX06f6VbLGE+0hiZpF3gQXmFy3w/kMJ8jQRJNMpm1E/xh+JFQOVeclLpVPImlOGJ95QmSrpWBLq7W4JKdgU6U82B/c7b2mfTjci45TkGbmbyCbc0zOPPGHNFYcs0rLET2pQdAWPd2zQdA6OEFTefLOz0exndLuUE7dCbRs0dwLhxnFbbzVSwrl46ab/RZL5Q5gMuEzKXLyuRRH3ZdQ1UHSuHsEDzPDjIbMmZHL8F9Kqo3WxLfe8KwuN7BZK9ucXz0iGj2/tuCEWGLdhLNrSyJDQ4Ov3gZ5jFVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sF4uc1voVBh0s5bV1x6x9fnr9+XuJWbl70/o6E2rNZs=;
 b=IISSqDf3+0pvxEaeOqxreiYsAW1XNU3lUaYqz3KoXWF8aJa1RKnr8kMJsDqTNTgevY9RmXv4j0OLoJFt77NyTPpbTfH2fESb3kuqPg0wlCY19EoS+dl7qVL1YxvstnpnLexVQ7oq/pDjLZcJRW/7RpQdIA0+kIeBCVYt+ZSoFf87mURdPLD91ElJQtDTXgp/BE4SB/jSD56YfOO0vZbNQcsJCiuXcvMtU7IiqfmJn1HsLxPQlKpm5cd+f+6+zv3OC1aqFCTutBaeMjA66bMDKwsA1c91AoBOgJoUrblyu8kRvno2D653mdV98nucGOWFAZu9bHycEhglzcYtqb/imA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sF4uc1voVBh0s5bV1x6x9fnr9+XuJWbl70/o6E2rNZs=;
 b=UkS1cBNp1NAk4P/yzDnSUxghQxcHY4Vyjo593l2vi/4soLYRJoMlbHxx/IsS4T9CQ0BM28iHMTjoSbGKWuXouYyy8lqChHj3V3syB3ckv4dT1GZ70zlhEg78Krn5eHGLMsyIsAoFpSPsoUv2d4lQL+MhRpBFRx1Ngyiqbqxlh9o=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM3PPF1D4534BE4.namprd10.prod.outlook.com (2603:10b6:f:fc00::c10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.31; Thu, 12 Jun
 2025 09:17:53 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 09:17:52 +0000
Message-ID: <c7e4e1ad-a0d8-4eb5-8f88-6607939b1918@oracle.com>
Date: Thu, 12 Jun 2025 10:17:48 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 4/4] block: use chunk_sectors when evaluating stacked
 atomic write limits
To: Nilay Shroff <nilay@linux.ibm.com>, agk@redhat.com, snitzer@kernel.org,
        mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com, hch@lst.de,
        axboe@kernel.dk
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com
References: <20250605150857.4061971-1-john.g.garry@oracle.com>
 <20250605150857.4061971-5-john.g.garry@oracle.com>
 <94718ca7-edb8-4e87-9b2d-586dcbd42690@linux.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <94718ca7-edb8-4e87-9b2d-586dcbd42690@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0306.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:391::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM3PPF1D4534BE4:EE_
X-MS-Office365-Filtering-Correlation-Id: 67150f3c-ca87-4064-49c7-08dda992022e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UGlJc3ZFQnNubE15TlhVZlNXZUQzcVE2T1EvSTZPcEJLWGJKbm5DQnZPUHhr?=
 =?utf-8?B?RG5uWkt4QU9MekRpVzd3ZmQ2dDdLenU0enhNNWo4Z2FMQzd4ZUFwU1ZjRTV2?=
 =?utf-8?B?akYyMVJYaG9oczZzZ2JNOHFXaW1FeXE5d0hRTHByNSt5dDFzNTgyaHNPWGlO?=
 =?utf-8?B?N3JNZWxZYUhtMkxQeE5HVS9heVpQVllQTERDSDM1NVIyaUh5R2FWYUNCS1Ux?=
 =?utf-8?B?cmpxbFZxMDY3M291K2RtV0FhUHNnTWVwMFRpWlA1UmxXNWFUc0xPVHBvSEJM?=
 =?utf-8?B?bGVqWnhiRi9yTTBKa3ZtbVpkTTh5YStyS1pEd3EvV0NFV2tMTmQ3ZVJzYVNC?=
 =?utf-8?B?R3VTV21DandsL1hWVDRVeThuYVRKV2NGcEEzRStHbFBpQXJpVm1adEhkNWdl?=
 =?utf-8?B?VUltS3YrRDV2c2lYMHA1cTIrQ0Z5aERZUytUL0YzZlpERldiMWRHSFlIcmJQ?=
 =?utf-8?B?ZmYvYm5BOElORm15VFFXZVdyL1h1dmlhT3RsaHZjcXp6ZkhITDczSzZkK1dK?=
 =?utf-8?B?SzVKamdjeXBZMnNrZzZ5Z2R4ZUprRkJyYmlxTjhoMTBPWW5IVTVrNSt3WERz?=
 =?utf-8?B?TkJpN0twSUhjV2paK3FRQ05sUlV1OGRYQlNiV3lDbk05aHYrR1ozdHV5Ti9o?=
 =?utf-8?B?bFh6Z09GSGJ3UjVnUDBtMFV3QjRORlJHSmo4QWhXMCtSL2krWnljc0FlQzMv?=
 =?utf-8?B?blhBMFBqRnlITmNyRFZmcmFLTGcycVpXTUxsMFA1RE4wc3djK0pzdjVYajZQ?=
 =?utf-8?B?NXZqeTgyTzI3cituM1BlZ2JXcTJDSFA5d3A3d1VhS2JXWlNwZjk1Z2RPSzFW?=
 =?utf-8?B?c1NPWG9SeTM4Ky9rZFE2SGNNM1pWdjFxVWJ4S3VZNmRrbUdXOTZMeWZqeHhH?=
 =?utf-8?B?V3BtZ09qVDdndlA5TzJidkVHYWVYTUpXeUNhWWJaOC9SSG53SUVocEgzSnBn?=
 =?utf-8?B?NDFaUERmWUlkc21KclcwTU0wSmJFM3dHbTlWUWlpVmh3eFYvT2haMExEczVC?=
 =?utf-8?B?Z3lBaFRxcjNGd2ZDalBDSzFzYTgrTVd4ODBObmRoTTBOR2hEQlR4MEM1dU5k?=
 =?utf-8?B?UGZncDNHZ0lYZUQ5b2pzV3JQbjJCMllFcDA3Zk9CM0E1REJHc3pNRmdJOXlK?=
 =?utf-8?B?K2hyR3ErNXpJcHpRV3NCNXc0eHB1NVNDYStJcUwwRUhjd0RiSmpXWFp3ZmlV?=
 =?utf-8?B?U0RqWHJnbFFLNnlOZmMwUnlLSE1IdVQyaWsxc2UrVmVDRFdNT29zSit0VDVp?=
 =?utf-8?B?MzBkT0pPOG9ML2k3K2o2RTRZV05IdFV2ZHprRmpHc2pXendKK1pua2RPWEN6?=
 =?utf-8?B?ZzhyRVFsYmZxY2JIbGp0eVZxWUlGdmlzMlR4WFQvcVdXUExKa2JtQUhLcTNt?=
 =?utf-8?B?TTN0b1BXVnFGYW1qVEtuN3ozOUd2R1JRS0dVUkw5TVJCNXM2bjhhRTdCOWpo?=
 =?utf-8?B?UHV3ajVlNFJHY3RNelJxTGFSN0NadUk5eDdUMmNwekhTR25TZHBiL3Q0M3pZ?=
 =?utf-8?B?UFllTEVhd0pBZVpvN0FBd0JWaUp3UC9oNzlJNjdzQUY0VEFRVlVGZDdxUlVl?=
 =?utf-8?B?czRZN3BmMG8rTzVrREZyV2xZWlNLZzN0L1dPYks5eVZGVFczVzdiajcvS0hz?=
 =?utf-8?B?QVh2Q1NWSjhkeG0xTUkydWZzSTB1aURhcy92eVNBZ0g2M0RTL0JxQVNkaGpH?=
 =?utf-8?B?QzViOERvbjdqVjI0NEh2SllJY29hSmRpRWhCemF3VG14cGFnWGh1UUpNcmtG?=
 =?utf-8?B?MW8vV2g1L2laWnZNMlNtMnlvQmdjQWE2SE5zNmg2cFYyeElIWVNDT2Ric2tB?=
 =?utf-8?B?dklobXp5WG91MzlNRjRzMzg2UHU0M2FuUUtkeGNaVk1vT0tJckxzMGJXblVO?=
 =?utf-8?B?eStFanpINnB2YytydXRLWHdLN3Fyd2w0OGhuR3pqcVM1U1E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SVFvSVRTUXRkdE90bGJyK2pmbVZjSk5YakJLVEU5eGRjSUwwT1hhSUIwcVRj?=
 =?utf-8?B?OHB5RHRHOWh1ZERHbkxUUGEyK0p6dGQ2WHQwWUxuNXdlblMvNFJ2SWNlZ1Ri?=
 =?utf-8?B?bXBndDM1ZzZ6RGM5TEppSWd4dTlVeEc2NlZpTEZrbVZ3azlEMFNNRXBJSHVU?=
 =?utf-8?B?RlRLdmQ1UVMzSnlMVi9UcStzNkF5VVVrUEI3Mk1WdFNMNUppUDNEQTZrbjhR?=
 =?utf-8?B?V0pmcEl5ZDlrOEFsQm5ibDhoRzhTa2xhNHB0MWFlZUt2MVFkeENUMzdXM1Q1?=
 =?utf-8?B?Wm5nT3F1OHVjbjI4aXdUMDNHQTFPbzIwZlEyUzYwZjVxUXJuQ0ZkKzVFL0pI?=
 =?utf-8?B?SnVCVFI3RSs0WDY2Y3QrNzFOUkJnclVLclVOczFZUkQ0SFEzN0dTRXBWeDcv?=
 =?utf-8?B?MWxySis4YlUrZU4zTEhqTWRGenRZd2E4VE81YVBVM0Z6eGJmM1dTeHJiU29z?=
 =?utf-8?B?NU8yeWdmRlJ3eUhhWnc5ZisxNEdBR2FYT2lCclZJaGxLckZQUVBYaGZDb0cy?=
 =?utf-8?B?cXFKYzBUaWxVQVNGYlVoekVjRVk0YW5TSk56cUdUR2dIWjNHR3Rjbi9BNXZl?=
 =?utf-8?B?OWN6aytzN1BsZ3hxWGppMjQvanBjQW1oWmtUbXZPQkd1ZDhXQW5XNU00Rk44?=
 =?utf-8?B?d01ZZGlSUWhZR1Jzd0JOMW5tTElicGxnV2VXUUY4SmJuSVViVW0xQnJpVmNw?=
 =?utf-8?B?aklCUkFrVFErb2NOdmhjUHpWdmswdjNMSWtTQnVzN0ZNRnNULzYwSytKMi9I?=
 =?utf-8?B?WndpaFZQWXllVWZCREVSRHJEMXhVL2dlT0JvcENOTjFLdFltYm1OdUJZQWsz?=
 =?utf-8?B?a0RLWHZsUC95RkdoS29nd1dvaUYxL05Zcy91QmxMYUhCdkE3Z3diOVgzaUJ0?=
 =?utf-8?B?OUIwTzgwQ2lDWHVUTGpuRk1NNlR5M25wZk9BaGNMd1c4U3lTdWVWdCtkQlkr?=
 =?utf-8?B?MWJINGZ3WXBBTVRwVWFocElVdm0vbDlNd3BWZlVTSkF3MkhyNENya2tVeGV3?=
 =?utf-8?B?S04wdmt0UGZ3a3B4eGp2QitEeW9OREt3aEkxZ1dTTytxWmRYNXd6MVFlRDA3?=
 =?utf-8?B?UTcyQ1F3TTA4V3RUU20rYlRQK3NaQXg1b05iTmxWVVJUMi9pNUltcVd2OGpY?=
 =?utf-8?B?Q3dPUkhra3R2MmIrQzhpRVdBaEJVZUdjQkcxSFp4SnBUdkpNbkFENzR1cnZs?=
 =?utf-8?B?cDBRMXZpOGVzUmowVlNHMlJsc2VLeStHWVRFemhnQ29GZGdQdkMzQlUyeWht?=
 =?utf-8?B?c3FHdU1RWE5SYm5DTHErY2RBUWE4L2wxd05ETDlsVC9DdnByM3VLcWxBM2R6?=
 =?utf-8?B?SXdZY1NrUmZrclk5S08wSElSTHN6cmswU3liMzA3YnExMHdWNnhxWWtOb3lv?=
 =?utf-8?B?bkY2NmRhQ3JKUnI2ZHRDOHNqRFhtQituR1BNVTAwNWxiM1ZyV1VsQStKenMx?=
 =?utf-8?B?VnhsZEloWUlwYU9VNE1GSUhlWG12bDVhbnBQVWhTZE00bUJRVWh4WjNsMjNz?=
 =?utf-8?B?QURSYTVSMFlYaE9Fam1STE9OMks2UG9HVGtIN1RVTE12ai9rV1pudjhNcGdq?=
 =?utf-8?B?M2hBeVF5OE95elp4TFFBNjA4aFBwanNKRDI5OXBPb3ErUnptNlZHNXNYa0R5?=
 =?utf-8?B?V1VWcy9TaGpwOVp6dGplRTh2eXQrbG1GT08xVEZSRmI4OFRWc0FhMHk1akg2?=
 =?utf-8?B?SnZPdlBUUDFWekJwSmZjZ2l4QkY3Mm42blZEdCs1eE41dzlQYUxkU1lLZ0xY?=
 =?utf-8?B?QzFrWnZlOEN0YkdYSUJQWmNEOGJWT0Vvc0MvaUJaODBFa1pIeXQrSnJCR3cw?=
 =?utf-8?B?cGgwdmpDZE9lNHpqNENybXJQNnJYUmEwQmplYmhLRWlpYUQ3Y0V3VG9kWEk1?=
 =?utf-8?B?VmJPRlNvUy83eW8vbVlSaG5haVZGbFN2MnhuVHZpZjBTTmtycThmem94UlZ4?=
 =?utf-8?B?MGozZEVubzhSVXZUQ1E0c3A5VW9yOGxGSWlMWHhMWVFSTkRLSThaSDk4aDlQ?=
 =?utf-8?B?N01rU3ZFZVNxNGtDZTloVDlkeU02S3RQWlFzMVpFVDJJcjJzUGdjdk5uT3E3?=
 =?utf-8?B?Y3laNWp3c2RnenZSSkkzUnIzSTZZNkRrZFB4T05VY1VLblVpUnhDL3M5cDdT?=
 =?utf-8?Q?8Xuz8pI7ViZLpQublXq2sgfmc?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1xjtoSUDRF65TsCPE4v7CW9cmNdglONi6xAI5cN+IlQKvxLvyyvATTJeoZ2ADVowDXFHnAe3LEOKG0IZ/gfeQ4ZRSe2q6ORRLcZR5m2sipdmCNvInHajfjmokp2gbCpMAqsaUb5rl9Z/eUdBwKHmXCd7yOKmYqRkdzVsxgKmzznT3Qm/tc5MSrp239VzrOAVyuXu8PwZZLn867MysYUHvSBVbzyoMVIzPBzkWvzX6UBY/dhUH6qRR2erPQsuGm9nvxBrMSGKQU1chXxmsv/1kOS0CAsiKjPCV9c6KlKhty8CaoviAOuwLjWHGZ0x35NWb63JDgV32iSMmALTp07qcOOeM4CzxpCMPE5s0FXJgIJoHcHwDwMZeUcEVIIDFDS8heej0UQ5csF05Z9uynVf/GviuM39xxyJNb1gh1jFGDYFtOkS8uKlVxTVO/XY1gU9ok8zB5WgRL3j+FyNRMfkzq1iFnsPSC5UO6YcauR9iJMKD2skEWWUTgVPED4JRCpj6WdqB3xApJoTb0yPPYpuwHwG/eLxs/hYPRLZtOyK15TzOf6TRBUnjrEtM2wt/PArjpM4914bL7PvXWIihgIPiDnQbO3okomOf7llRW33NFc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67150f3c-ca87-4064-49c7-08dda992022e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 09:17:52.5931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Arhfriiki62sbrM5skawegzkS12R07HPsvBnrwI01cb73pFI3fTxNdeddoci5gffckjusFWD6Fkt8x+Pr3uJeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF1D4534BE4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_06,2025-06-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506120071
X-Authority-Analysis: v=2.4 cv=K4AiHzWI c=1 sm=1 tr=0 ts=684a9b43 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=4kgNgyTNu5cp7ov5rJ0A:9 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10 cc=ntf awl=host:14714
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDA3MSBTYWx0ZWRfX1qCu73GTilFM 9T10f4bUpgaiZczEmXQtOJ0tZQNNPL4yrAFvRH7a/aTOjomSrovw5/3aNjTZIde7AdN4krzLjEJ BZI7PS3XVbrVGioYF7T0gIV9zDkevtRpHzA+40+zoaQL8QNUd7UsTjeD3F9mz47vrK00vnvMT2c
 FpKeQweId1a7eEUyjQ4eoD1zLaY3GSHjPLzYxy/pI6sF5lgXE535rLRhigrXb9GvU14XyXY+r2s BY3252mgQ/DGVHecBLq3ZIl1N5+khlz9Z1GUCYS0nWXqfeXGdhZbzGCzwDzVWHW0XSZwEKXEhp6 3VJwdBGDTGxGPTr+Un/Ws1iBaU+IMrc9I0USP1puwSu3yxz6gDK7+ZxZaeTvU6pr9gKSEu71DIw
 QLtbsUqPy73VoYchx5MDiETHMA8I0EXp2BjqyE64ECbks6Gf/uaFqkXXxw4JP4jzLrsJ8hBN
X-Proofpoint-ORIG-GUID: 4YyEAinQXMNg_iTRI9iJJM74hfeS3-TI
X-Proofpoint-GUID: 4YyEAinQXMNg_iTRI9iJJM74hfeS3-TI

On 06/06/2025 16:23, Nilay Shroff wrote:
>>   	t->atomic_write_hw_unit_min = min(b->atomic_write_hw_unit_min,
>>   					  t->atomic_write_hw_unit_max);
>> -	t->atomic_write_hw_max = min(b->atomic_write_hw_max, t->io_min);
>> +	t->atomic_write_hw_max = min(b->atomic_write_hw_max, chunk_size);
>>   
>>   	return true;
>>   }
> This works well with my NVMe disk which supports atomic writes however the only
> concern is what if in case t->chunk_sectors is also defined for NVMe disk?
> I see that nvme_set_chunk_sectors() initializes the chunk_sectors for NVMe.
> The value which is assigned to lim->chunk_sectors in nvme_set_chunk_sectors()
> represents "noiob" (i.e. Namespace Optimal I/O Boundary). My disk has "noiob"
> set to zero but in case if it's non-zero then would it break the above logic
> for NVMe atomic writes?

Yeah, I think that I need to change the code to account for the bottom 
device setting chunk_sectors.

Thanks,
John
