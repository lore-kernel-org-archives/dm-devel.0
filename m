Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C71A2749CF
	for <dm-devel@lists.linux.dev>; Mon, 10 Nov 2025 16:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762790576; cv=fail; b=i+MApivvdpLsSmc5L3bNDWKC4rZxrrCpjJcyxYb2PwYImElpUff1o35UKQQKCdFs2ggP2XV9Kj1PUnjCykVrGupN3e3c2Qnm8/VVEk6MY2BTxwOS/cvNZs+OgP3hijfnV1pj6IuDtvqaPZg4HhU+1b2h9KNG7pcCWHWjyU8zFwo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762790576; c=relaxed/simple;
	bh=8v37ndRsOG2Crdr5bibmLp0ehMvdaiQmJh+/iuWQZvQ=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bHReCPpxEMECPOFiNPfy+vHlj1LPj/iUDhaO1wfF+bpCWLvpr0XECrJwiosa8jCLff1ikwm47Rpu9kWcXtiwtZqiC6VQ7EBSV9IPVXjN0Y7GIQrLyyP82NFyGJSF9dC2EiGkomnbatN1pM+szr+4tOkwpioEA7sgL8/eyS+YhtA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Un9rWh5o; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eGlZAEzC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Un9rWh5o";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eGlZAEzC"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAEgO5G022983;
	Mon, 10 Nov 2025 16:02:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3g2Vdu/lB9UvrAdUS0PHOrkaFT31gfx2O2vT9//ynLQ=; b=
	Un9rWh5oqqgxwSTQzLbsxYNbxFUwQeZ81HF2t9W1JzhyA9Tt9VnTmIh5IJRhf42u
	8vUaEEcD6nl0PTLMrOYWmpFPSoWTqQAKaupuXKFICGbQcwVgewEiEca3y38cEcJ/
	RXvJRWv7l9KtTmO4sLlLEcHyWLdB23RjsM54xTeGroWsPaYEE84S/bu9aGXWsrAW
	UMxzf0FllDAXuJu+1Gw34/dAO3O9FFWFZSraNCUeHhFKFni+G8cO08iWGW6X5XRR
	v7raNtN/n7wgWuliF7NSsqKRWF0efYxTIuzKnLjfkNwp5gvY48nMSTpr7qyF+yNh
	4FHYE/xZlQnh8EVVzvBytw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abgwt8bh2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 16:02:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAF2FwR012740;
	Mon, 10 Nov 2025 16:02:47 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013035.outbound.protection.outlook.com [40.93.201.35])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vabtxfp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 16:02:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AoOvvprQTEbbjWX7SRdRquuX5ui37R5AGI9OYqLrtihodLn1AqWqfMiggBAiVLsqWDoRloCh2+eFB6RdNFbV1DgvfrUBsrNuWJT0c4Rm/RbISmiiHRRjaTUT1y3VMv9UguYJZdwc7/IyvEE1f6Ys6sp/1uNCP2UKFw5Mz7amvD7CddgtbNiBUdfSIqGwI79Btrt3CarAUeTDoQuvCpoqefDFmLZvXRdvFhjITb7fTDpItWl0FeGYUuPi9b1Nrgtt75EXkrs3B6K+MgJlZkthMQPeNAcUvqfQTetSEsx3zD80Q7uTDw13BoLfmG/u7x5McD8CtWdtRWdru/1UJ+3tyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3g2Vdu/lB9UvrAdUS0PHOrkaFT31gfx2O2vT9//ynLQ=;
 b=diZA/gGC2/pTGAiF/sp6fc87hoyAUq07fz0X44/bmDpgvbpb7JasASqq7mzZJOdRoAeg415N3oJD6XuVsywJ7icMJexpGZjg4O1rfP28c4SxKCg2cZqYIj7dOaI/YjB15gHtvs1FFD859qx/SQCBPOGcJeD/MlnqXfRk/mNgqmJYJl/CzgTDWqULHQ2z8wx7rrTV4QrtBF+ZQPUu73xEVVOQAxueOz6+niNCzMf+ZGi5TimZKvDN301O0bbtwO0+/veeBo56cMkMF+8YMwoWOTxWC4R8B32blxjTGVTY0pxPzBaLH+Ojj6QajFSVNAxP7X/KmZO2ETjN5yMdATS3Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3g2Vdu/lB9UvrAdUS0PHOrkaFT31gfx2O2vT9//ynLQ=;
 b=eGlZAEzCGpYNKw5uDn6MY0+aBcNuizMfCErnZUldnRQQxgmuNoJs7Z9+H181jZ+/IgYr4C/wR6QHkSaFbBqg3N4aKznU76TjBpXS3DZVg418+KjULGbKKbRycTxaM6oeu1tu4Hr+kxNKPLpsbIzs5EkPWRratoHPT9Kwjar82xg=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SN7PR10MB6384.namprd10.prod.outlook.com (2603:10b6:806:26c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 16:02:44 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 16:02:42 +0000
Message-ID: <6b3582bb-1e50-4e7a-972f-a82f62f46e7c@oracle.com>
Date: Mon, 10 Nov 2025 16:02:40 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] dm-crypt: enable DM_TARGET_ATOMIC_WRITES
To: Mikulas Patocka <mpatocka@redhat.com>, agk@redhat.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, michael.christie@oracle.com,
        martin.petersen@oracle.com
References: <e0b99d8e-1159-a489-6df3-648b21c4f091@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <e0b99d8e-1159-a489-6df3-648b21c4f091@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0483.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::8) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SN7PR10MB6384:EE_
X-MS-Office365-Filtering-Correlation-Id: 37872736-21a1-4ab1-bc89-08de20729468
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SkRuQmtoMlpXZHE3NmsxcU8wVjg4akw1OUVSWWFCWTBKeEtCd3hpTWZoczBw?=
 =?utf-8?B?Y3pIbVhLZGEveVk3aXJ1OUJwSXNMbWhQVUNnREg1K2gxZjI4NEFMclNlVEtI?=
 =?utf-8?B?UHpXMVExVGhUaUZkYnN6UFpoNFF4alltTkhvUC83dnlWSjFseTZKSUtwZmZD?=
 =?utf-8?B?Yjd5OENNejJMMVgrVjRYVVp5eGJYdVA4bzlsQ1FpL2dtUzdtQkhMZ3BGSEFy?=
 =?utf-8?B?ZHZyK015VjJFRWhhWjQ5dUhlWFZMMVJEN3VUMXZ6MHR4eGFtU3d3Mk10NDBO?=
 =?utf-8?B?TlNLQ28yTFAwSy9hTTdTY1lkb3Ztc3NMVG42UUhLNWVEZnRPRGF3VFRCbGJI?=
 =?utf-8?B?ajdNcG5HaWVFSm9ZY1JQZVpsN0dsempWek1lK2FWUUJUTGI5WVFPY24reTlt?=
 =?utf-8?B?d1h1QVppWXFRcHpFaG5GWWNmOXIvTW8rbjF3dmFEVU5xU0xONWtGeTYxeXdV?=
 =?utf-8?B?anUrbUU0Rk5Ca1lJb0M5a0RpajNoeUptR1ByckhWeTRaaHJVemkyT1RTK1JJ?=
 =?utf-8?B?R0loN1IycEh2OXJFcWRPNmVNM05PUkdSd3RmUVRtSERKWEpxd0NLd0pZNlVL?=
 =?utf-8?B?eWQxT2lNYlFuLy9lZW42SHd5akowNVI0THMwcUMyUnp6RVpqNDVpaXA5bFQ2?=
 =?utf-8?B?N0V6L1l2VG1jWHF0Z1cyWEU2bVZra2J0Y1JqeC9UYk44NkVtZll1QWZncFFM?=
 =?utf-8?B?VHhGNFI1UmxQK2NFUlFsWE5YdXhHdnhUSDJ4Zy91SmJtM3ljSmQzbnpJQmtM?=
 =?utf-8?B?TVE0NlNCOCt5ZXYrNlVuaEszR1pzQ1Q0aEl2SUY1Znl6Ni91cnY2VHRuYnBn?=
 =?utf-8?B?cytIaXVEMXg0SXkzUENRNlpTWFg1cUQ2a3h5Y25HQVVDVWhkL2g2ajhySHB3?=
 =?utf-8?B?aHJVUEVsSXpueUNPRWg0TTViRC8vbElVRURzZE03aUZRNzZ3d2lQVi8xby85?=
 =?utf-8?B?K081RUFHcVpzcWowWWFrcHRYUVJyZStxeWMzOFNvVzgvWkUvdXlBeWExWWpU?=
 =?utf-8?B?Z255SzJVK2RXTkdWMzlmYjloZ2tyMmlVcDl5ckk0SUNQa0RHOTJ2QjgxcnE1?=
 =?utf-8?B?Sk9YeUVmRmRQTXNCcExnK2d2SDlNOXRiby9HMC9iNTdFUm44T3F1ZldyLzAw?=
 =?utf-8?B?VG5ETWNoNFhnS3JQc2ViQVgwWXROaXNaQ3g1bHVlczBtUG5ZRFczVyszMzd4?=
 =?utf-8?B?cFJ0WjZEcUdla0Ezem5WZGYvK3V5WHoxV1ZrOFBnMTBjRWhUSGR3TWtVM2xn?=
 =?utf-8?B?YVlLdjJJSEpoR1JoTUJsd052MWlQMGYxZ05wK2FlVGVWRjcwbGNleGYyeFpE?=
 =?utf-8?B?OUhtcEVCQVRHV21XNW1XU0Z0a3loN1NQL0NZNmlJdkN2VGIwaG8rV1ZLNjNU?=
 =?utf-8?B?cEhmWi96M2pwQUJPY1VUM0E3SFRSWlhHUGxKdzBVSHdiVTQyUU5HYmU0S0pK?=
 =?utf-8?B?YnRaM2FiZG4wM0F1bDlzYUV6dElDbytlSFJkOFdYT253Q0dXYWEvYVQydFlu?=
 =?utf-8?B?bWFOWDMvaGl1S2EvSnlsNlRCelVVSWtQMjlXWlI2aFpocXNzY1NRdXFselRZ?=
 =?utf-8?B?VDVRNVBIY3cxWWJiZFBBZTg4MUlFcTk5M0tJcFp5NG1yalo5ZnZaaEF2ZVZC?=
 =?utf-8?B?dDRiWmFzNTQvRm1iTVR2ZHc1bmlxUDZKQW1CVWRoK1hGT3RwTCt6TzFJbmxi?=
 =?utf-8?B?VWdaUHhUc1dOMnJuL2Yzdlk0a0VUcWFiZFdJdXF4SnJXZE85OXp3eHZUWnpK?=
 =?utf-8?B?b0x3UEZmbTlBaHVYakNrZE5EbDVMc0Z2UVNQOHkrcW9raG5udHpaZXdPWldE?=
 =?utf-8?B?VmJrYkk4R1p5K0dlRDJFSHF0YVFBOXhRSkMxSmRrRWJBNTc3UjJoemFtdVBE?=
 =?utf-8?B?TVFmQmlMa2RaNVhmcFZVVnh6QkJmUFM4MnVsWThxSUJaZW9QMldycFE1N3lv?=
 =?utf-8?Q?DdMnWnFBwBnnJKOBesKKg3NijGZaZC0O?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UDZPbElIcUsySWM1bUg0bllwbWNjS2JsWWYyc2FKZXBIZEVwMGl3SCs3NkF3?=
 =?utf-8?B?V0NlQ3F2bW9tMDBuc0hxa3JaVkMxdnZaN0ZTZkMyVC9RTVlLZHlCMGFKWDB6?=
 =?utf-8?B?NWlzblZhdVphbVlkam55RkxuWndVMHdqK3orVytlTWJBZVpuMkVTZTBnOUhP?=
 =?utf-8?B?TkdobDQxMmRXK3k5a1BWSHhmdGJ4azBneFBvdUs4NUJKV0hOVGZCaDRablMw?=
 =?utf-8?B?TnVCUG1FTXp3T05QSWZNUm1IS0pIbUhUd0pIK2FEZzdpSmY0SG5XRm5IVlNU?=
 =?utf-8?B?bU9XV0FqL0ZKSXQ5K2ZMR3k2YWZWNWNLMGRJMHU0SzNCa1dFSDRGYkx2T00w?=
 =?utf-8?B?SlVHNHBwRk10TDBQbC9takdRY0NoOXpZSmVsMWpZQVdOTENxcU9nSHg1K1Ri?=
 =?utf-8?B?by9vcGc1aDRhZHl0dlRuS2NCUGZhMDFRbEgrMjRpdXU2SS9oVUdCWjRURmpZ?=
 =?utf-8?B?NEtubnhwOVRGZG5xR2tPTWxWLzZLNWpwTUdINFEvUElhZVpmQnhoVkxpekE0?=
 =?utf-8?B?U3pMTU9SRDVEZ2hUcjBmRnlCdmlnbkpWNnR3cWhpNFVXUkc2WWNkRWVqbmcr?=
 =?utf-8?B?TDdHY2FhTjBVUGJuN2VhU3IvRCtUakNYRVJpaVN3ZW9tbDNDT3djRktLTC9z?=
 =?utf-8?B?T3dMMmFaUmJYVmJpSCsrOUUxMjFieFZkcEVybDVacWRCdmV2UnYwOW5Dc2VY?=
 =?utf-8?B?SmJadHh6dHF4RWsyOUxycDF3eWRES3kxTEh4bFcxRGVuamFuZDlmQzY5aGs0?=
 =?utf-8?B?THJSNE90TnBrRXNGN2x4VE0rMDUzdWpVVTVJSXFLNFhCQUZJazM3QitJYk5V?=
 =?utf-8?B?TFprdHk4czNGTU1zWTl4L0ppbnlsOWhucHdlV0kxYzRxaGtEZ0xPNUlHYWpQ?=
 =?utf-8?B?dEhHZE9WVlA0T2RvbGh4T1ZBc1JXUk05bEIxdU1EZGlZdTFOM1BTME5wdENt?=
 =?utf-8?B?eU8vUmJnS3gxSHo0bkpHQTJ0cUVjTEUreEtRMVBVZ0drZXRLM2JvcHhMMlJU?=
 =?utf-8?B?VzlGUmNZVWQ0bjNNd0NGeGhzZ2VmbGVjdmcwTG5JdEEvV2ppL09PRGNZRVBl?=
 =?utf-8?B?TzNmajhvVDVPZnRsb1IvRitvNHFnZmFkWGRBekhHRVBnVTdMdVdlT1dsOHJE?=
 =?utf-8?B?RGtlOXU1bEtSdXNXelI2YkR0MWtpcloxWGlXNzRoWjJ6SXdJTFBBUk44dzRS?=
 =?utf-8?B?MG5hVW11TjVlaEVva3Raa1VkeEhPT3N0UTAvd2pUeS9KWFJVa2ZpV1lrWDUr?=
 =?utf-8?B?VE1MRlJGT0dKQ0cvSmExbGNkT0xCc0N4T29wMGJVMnQ0U2haZ0RZaEpOVjU5?=
 =?utf-8?B?cUNIbEh4d2ZtMWw5ampqZ2xVK1FSeTdaWXlIb1JMc2YrUk5HYTZ1Z2NSdXBD?=
 =?utf-8?B?aU91dUkySzg0ejg2eU8ybnhtVUo3alllYmtyZjF1bjNId2hSM3pHRGd2SkN6?=
 =?utf-8?B?aHo0ZUdaLzV6ay9ZS2hrUjJWVDJiZDNpUkdYWk1IbllzRlA1MlgwU1dWeTVx?=
 =?utf-8?B?c2RqTFZvNW8zbkN2eUpKV0RlbjY2ZmRKeUxqNTJrVGt6T1lVdE5jckJNMzNj?=
 =?utf-8?B?cWE0dm5CYXo5YkwvaUhIM3p4WWFYYVhhOGcrUWpOU005YWIwbzFsby9TVDh2?=
 =?utf-8?B?bDM0Q1NsdGFIbFoycmFjTlZsWE1zeW9aWTZnZzFiRDRPSWRzNDBEOUZtRktM?=
 =?utf-8?B?Nk52c0xRMGNOMVIxMDhWNGx4K2o0RThmRmtWM1BnRmdQeVlTKzRYSnVsdkJ6?=
 =?utf-8?B?SVltTk45WnZvdHVMeXhaeTNJRGM4alVla2ZNTGlla1NZWEZnRk9STzRhZ0dj?=
 =?utf-8?B?RXVBaFpZQlA2MXIvZm01eE5CeHViTlJIaVNqbXpmc2lTZW9qUWd0ZHlzdFhY?=
 =?utf-8?B?eU91OFNUcUN5bW80TitkaUtiM1NKdTlTOGZoOTZhMldDaDJTRDhXT09lWlVI?=
 =?utf-8?B?cFhxN3drd0FaMWsyTmZWREJvTEl1djQ2ZVd5M0xxNzlQSDc4bFZYbEZacFVq?=
 =?utf-8?B?dFlkOE9oejFKVGs0QmZiRE5qQjZOSmprSnFFSTFuSHpCVzUxUFdJZXdRUkZs?=
 =?utf-8?B?NkloZWlNaVlGVmpXeUFpdmRUb05GVjEySmpUc2xhQ3hYUk1IQVBHNDV0TW5S?=
 =?utf-8?B?TnhRRnpxU2lKdk5LZm9Hc2pmNWJZSVludkFVMHU3RVNNTi9zN1JFTFhuYTFS?=
 =?utf-8?B?SEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1ILMgPJGb4EWMi5RxC9Jf3NIygxY3HBmGnB4olPb4+qgNrcDnLwi/fAmXHnOk+jJWwwdqfBjqyl2osn/sdRfBHaci7pjyRBx+42QpxZHFOMT5fatpGVE67ZgKEzwJNZP2kO/CnUrGoLtf3Yd18wDsV7/ZWvod1QnQui7hBbEVucjTlaGbYX4HwTr9NIjVa3RcxM2QAxNgANssb+y5o0RlO2wXulYTfNa/+RSdd4oDlJSAbXZzyPODKqOw+HbLC28R2hxqwJSgDD/g18d0YYHGs/a3kqETbLRoSFe1nfse8e+WeIbN6xLqd2nMebybWkJlLZFMcXANdLYfEwefk8i2DJb7iKPASssTc9g2rfZ4GQI65I7T8ZROxSadLesawN1DUuSeZxCusXjEysyXZ++OCnh2HyRpJFbtQAeziEIvGSWVcUEl7MRdii0nyciVGSG192nrifibFlMkgtJfOyDKZ/Z/CeCu2slzovvHWlo4uFPH3ww0xkwvhG8D4IsJwxuBbP0ndj1CZMzW/yETgEYsL6GqIkB8+wlRJNawQDpPCDwYQa75yqyOgZwT9r9XLtaX8rJ/4Dg6Ab8LHDEQhpb21T0BdDHp/za25evYkFk0as=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37872736-21a1-4ab1-bc89-08de20729468
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 16:02:42.5272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KN/co3UoRn8y2EWQ1U5oA183xy+54eo1ydY8/K73phylj6Url+TUBcxWfjWw1KUv9zE9qB/wEHNlPh/UokPVsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6384
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_05,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511100135
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDExNyBTYWx0ZWRfXxZjvPw7b6eZS
 ujuzR+ZpibYxCcRc2/N4npfrjfX6LYvt1nmMvBvKtsrWsc3A6dt9d69zGP0YF082u98rZwzMBHR
 yonvyVIi5iauihNuFF9ib7GYF+y/rU+L/Y6vmg5FwXTErQxMHEVQ14uffGh16VmbFsru97vREKZ
 CLRZu9sPcKOHTpd3F/5al0alkH16CSNLj0fdApnmfygVf/W6ehbU8fRH7jviS9i6scrsCWChmz3
 yDgIUm0vvqz3R62K6bbOmqqSRPhVIFdRRPkxtKjbbi61y+ww+R7dNeuEIXFIQOdf/Yn2CQ8uayV
 QEwG4M9bNsG5f/8UzoLTpEpNBI9932ElqGFzmCkjRv0Hz33KwMZPFdU8s+FScDrOCJ4AcyJRhNt
 Qg00s+Yei+ocZQPL3m6Y2SdnixCnRBpBAPGNsl/ngaTmZa0oLeE=
X-Proofpoint-ORIG-GUID: -NkLiykUXrdobxE8eYchT5yu3ooBIsGt
X-Authority-Analysis: v=2.4 cv=DpVbOW/+ c=1 sm=1 tr=0 ts=69120ca8 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=DQNoQCCHoCVXVzmfzwcA:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12099
X-Proofpoint-GUID: -NkLiykUXrdobxE8eYchT5yu3ooBIsGt

On 05/11/2025 15:02, Mikulas Patocka wrote:
> Allow handling of bios with REQ_ATOMIC flag set.
> 
> Don't split these bios and fail them if they overrun the hard limit
> "BIO_MAX_VECS << PAGE_SHIFT".
> 
> This commit joins the logic that avoids splitting emulated zone append
> bios with atomic write bios.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 

Tested-by: John Garry <john.g.garry@oracle.com>

fwiw, I still don't think that we require the change in crypt_io_hints() 
[not shown], but it should not make a difference.

Thanks!

