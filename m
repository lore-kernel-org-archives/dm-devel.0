Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3554F231A23
	for <dm-devel@lists.linux.dev>; Thu, 12 Jun 2025 10:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749722485; cv=fail; b=ESIHlfN7yieeWk0mNRB0gTBn9HKe1ESWBP+LD1FyYz71tWIsEvMKXODmoiqbvNpWRNO6fqYArWFfYK4wk1ccUBrxW4TgFVDgC3oZ7ZAjSUyrRZ4XCPSGga3skfUYYCDlHMCq1lWf597H1va0Qb8my4Vq0ARTIwGdC7uBUyWVlY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749722485; c=relaxed/simple;
	bh=YzNTLXXY9ZAVNcCuZX0YdxijGWCNJ00cNDJAwjETffk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AuXx5Y+FLt9YJn/QXHmysIuNv3pSYizdyoBjLJEghfXCsHek6VcT/KYptmF0x6OzOsEpOvOBS07vNDV+w/9Hn/vs/5lcL0sBxZPNLUWnQbuIBGSRq6WlDREzGDYqwuGoI9lrAVc9cCzCt+xvbOJyyGKJLAtfecqKDQXs/fEqwPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GERArkaJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HpWxmnNN; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GERArkaJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HpWxmnNN"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55C7fYq2031316;
	Thu, 12 Jun 2025 10:01:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=nE03C05KutueEYCLzPSpAfsqH7cOqqME4DJ2miZlRIE=; b=
	GERArkaJGBpwOiLHPD75BJOnKvZRQJEaGtZ5iZS97hBjX/iWeirxOW4u0uOV9SF/
	8cfVLgPMRZG5b1xoDLzbZQ/Dc/UmaL/so9Nkgox8GWB8zSaByy0Jbm1BNWeE86wz
	uYKyGCQctwXlxNieVv/wKVxgbQKBkLJP0Ef+9RHpsYv7H+MnC7NnpJNAOLvTFvgs
	GjBcfCgbzMBOzysVYzxIR5xwQwvbOs40wLWxwCN/Q8d7zPLJCWQZNQfZHU8inOG9
	8hFlo+LNelf/GQ4jO3Niwif/60wqecAZSqmRBcGlNkM9RF3j7gCPXm3k9TICAN3M
	GtFAkGsZiTWzZv9wPXmGxA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4752xk0srx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 10:01:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55C83sjt037807;
	Thu, 12 Jun 2025 10:01:12 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2077.outbound.protection.outlook.com [40.107.92.77])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 474bvhm035-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 10:01:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c5ly2PwXccC11Mw6goQ6iX8dYqFHbLix5ODLVxtxT7i1ZIHGtgDEp6ekpdRHQVmo6+DgI31ZIbXGNW500oF2baxZtnNi3tRYXsLk1yXjpFFD64dameSxk3f+EeXXWSPFp+INuqaSnO9el5FJCkoL79ZHLPCxQK2Ma7X1n02777R+RhJnQwLFrfFNCB1EdxqElr08sw4GBfBWPPtV9LpAMICVZkp1mHCiWKY1CUqaH914j1GuZXAnsGE1JmiLsZ/HSuSN1PHgIFeNCXmbxGR+532wsXcJfXuw+PXfOia4k7S9V+WnxXAxNF/+nTrY0xBT34dZRyynBcK772UcQqoHhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nE03C05KutueEYCLzPSpAfsqH7cOqqME4DJ2miZlRIE=;
 b=t27SWFuoXP+DdHDscI6DQqxFDOreHspudquwMsflHpYLfvF8DjX8uGVJp4gf20VtziePo3dA7yuLeht6oyL08hd9Rn9w0gpCVgfysQrWkdeH139ty1ykzkQG+YON+/Utwds/Gb5EEZKdDrK+tvMEqvXEp9TQSXOiqf4+E3qNRMI4Sk6W/EySfk57bnwBkJrRyPIdytgPN5y41cn4KyLyYedgQVRv3LefkUaqEsXl+LP2qNUS8n7XURRDHVkI90PA8ccGipWPnfHHY1zXXemI1udHVKqAL+FOvhkcRMRIxSt4v5kw1yBmGdfozSk8WTMh+ZwgbpKNZSm9p7+ruw7rIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nE03C05KutueEYCLzPSpAfsqH7cOqqME4DJ2miZlRIE=;
 b=HpWxmnNNfpFODsQPcDfFZBNiH+I6L8jJO0ywaOwv10uS1jBDrK5n2w85lNW8Ou91nxxuLoj3Alibccvayp/T3F2akuCID+YNcyO6+slpQe87szUHsTILFrrolOnwMODzrYItDqNpKM2JNHqZdhQvwJGbLpoeRWURPSN3CSRvI+A=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS4PPF7BD9BEA92.namprd10.prod.outlook.com (2603:10b6:f:fc00::d2d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.25; Thu, 12 Jun
 2025 10:01:10 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 10:01:10 +0000
Message-ID: <f06aa274-c442-478e-85c2-40d9a07c7a5a@oracle.com>
Date: Thu, 12 Jun 2025 11:01:05 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 3/4] dm-stripe: limit chunk_sectors to the stripe size
To: Nilay Shroff <nilay@linux.ibm.com>, agk@redhat.com, snitzer@kernel.org,
        mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com, hch@lst.de,
        axboe@kernel.dk
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com
References: <20250605150857.4061971-1-john.g.garry@oracle.com>
 <20250605150857.4061971-4-john.g.garry@oracle.com>
 <041186c7-a249-4564-979c-3e480aadaa23@linux.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <041186c7-a249-4564-979c-3e480aadaa23@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0143.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c4::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS4PPF7BD9BEA92:EE_
X-MS-Office365-Filtering-Correlation-Id: c4b65f63-2a70-4e6c-b0d5-08dda9980e3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WHB0SlVUMnZLNUlUamRMdFRxNVR0Y0E0aElqaXppTjZVcEV6aVdXMzdkYTNI?=
 =?utf-8?B?K2tkOWhvZUxKeFhydXF3bmwrUDdyNldNUGp3OU4xL0V6NngvRERoaExyUW1G?=
 =?utf-8?B?VUYyWlJRazlRcFhRMGovNUQ5Yjg4S0pUbmxaNXdNT3Rnd1NMcmJ0M2k3VUNu?=
 =?utf-8?B?UjkyTUlSZmJMS2F3bitCUExUNmFCYUk1VCtRWVA3eVV2a050RHlDNlFRK09j?=
 =?utf-8?B?U0oxOUROdXR6blNERDU3MmlmUHR4ZlFYZTdLV0ZKanNpc2plNjEwb0xMdUNI?=
 =?utf-8?B?SWdlTHRpcm12QUQwUDhBancrQlluSjMrRnAvQ3NLR01rSlI0REFLNS9vd1VU?=
 =?utf-8?B?UDZYdzVTend4bmg3Sk15N01udWkrcTVXSW5PcTIyZFJWNWNwalRLWVJ6V21v?=
 =?utf-8?B?S3IwTW5GTU94OGcvVk9td0d5NTdXVTVPcXJQWWtBREgwbGlBeUNaT21iTFU0?=
 =?utf-8?B?b0JlUGFqTDFOTjdEM3RjR1VDdDFFckwyRTk0NzdMZGFFK0pHWkFjazVjTUND?=
 =?utf-8?B?RTlqTlZrL0ZQcCtvWUEwd3BoRmVQVzFrUVlOUkhnVG1VWVIrOXgzdDlHc09M?=
 =?utf-8?B?aWZmUzE3MTJMNS9XZlQ0Z1VjckFpd0FsZElwUWdIWWZNQXY3aEFZampqZ255?=
 =?utf-8?B?RzVRZTN5M2VNdE5QN3VTMmovdCtvdkswVWZSYzMzeVIyRXZ1UzRTQmpsbVRh?=
 =?utf-8?B?RW0ya2VhOGkxWldKUy9yM3BJUllESEhXVE93STZnRllSN0N6MGNOUEg4M2ZQ?=
 =?utf-8?B?K3pRVUpGcGRmTUxpa3hYMktqMjBGQTdtTE5yS2c5VjZGbUNTbW95VzQ0SU9X?=
 =?utf-8?B?dmxhTS8vT2VTNUxEOWRHQnF2QWVqb3puMlJoS09rZHl6MDJPdEZiUmdiR1Rq?=
 =?utf-8?B?ODZPK2xjSSs4ODVrMnZsUmYrQkIzR0dGK2t6bUsyQ2tJN0VFRlA0WGhuWjZu?=
 =?utf-8?B?WHVaM044bkhhdHdmOXE1a1ZjWklydDFCWmFnOFptdFZTSkJTQytkYzBBeWw0?=
 =?utf-8?B?SitmQWJTR1BCMkRPbGZDNTlZdFlGbUtiSzEvZytHNDJFcmF6b0dHRHJrUkhD?=
 =?utf-8?B?bDVicTJIM2hxVTZjQkpvUDQwWFk0eFI4c241b29EMm1mWDBJNjU4RWNSZ2Fl?=
 =?utf-8?B?QVBtTmJOcVJCR0k0Q0RFZWMySDkzYmRpNHNmSE5nYlhFS09uck9MQTVUNHpY?=
 =?utf-8?B?MmdSN0Z4TzJwbnI4bHJaNHhjUm50ZkF4MHRZNUFEdm9TV1o1K2xjTkVMcWNH?=
 =?utf-8?B?SUc1SmZwTm4xZzlDeGRsWjB4eWUrR2d0R3FIaWJsN1N5eFhDTVI3OTZyMUx5?=
 =?utf-8?B?R0dsNUhOQWNURnZ6aUNOc3R2SjhiR2l3VDFRWUprQTF0NDVvR285UmN3anlv?=
 =?utf-8?B?Z0V4dkN2SlMxa3Q3UHZ1ajBxTnBsTThrUzZRUmpsajlMMmZNYkp0eXQ3YWJK?=
 =?utf-8?B?ZlpEVFpzeTd5Z2VNeWp4R2lEOVJXemxsTnBqa0RKeHhYanJzbjN1WnB6MFB3?=
 =?utf-8?B?Vks1cUtpRERscHBDdVcvYjFaalE0bjR3ZVBqV2FtU25KY3YrelFWcUhPUmU0?=
 =?utf-8?B?Z3lXS3lwSVIrUXk2NTBKQXFVL3hhSDJ0Sk5ValdwQnRwTmJsVWVtUDRKY0Iz?=
 =?utf-8?B?Y1NYNUNmem1qODZjNlhRMnlKeCt1WmtPa2pHU05abVdxVk5vWjZxdDJ5UllP?=
 =?utf-8?B?clpmOTJORzE3QkxSUVFDQUNBV2E0cXBlb0piWHRRZXJtV3R6UDFiOVhJQXJm?=
 =?utf-8?B?cWp4cVc1TDd0TytUanM4MHZZMjRNWUVWeHY1K0FGNzk1TjVhRjY4UUFNeVpE?=
 =?utf-8?B?Q2Vaby9UaVJnK25EeFlNWVRuaGx1L2hMV1dkSENMa3Uralc2NktvMDdsMGVm?=
 =?utf-8?B?SGNJeUZmVTJDME5EYVd6c0pGbU5zY3g5WWxjTjFXWHViRGtFQStiVlkrRlRi?=
 =?utf-8?Q?5+6BmiVcSxg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c29vODRkWEp0TFFhVnRCdHA5Y3JrVmw3RHFIQ05SKzhNWnY0UWo3cjFTcmMr?=
 =?utf-8?B?U1RKTExLNXUvak05cStMK0pjZy9Fdng4VWg1c3c0d0prSWRqQXdJbFBQb3hy?=
 =?utf-8?B?bGFDSTduSjVXS051M1VWZmkrQlY4RTIwVkFIMFFHclBYM0l2Y1habDBsLzRa?=
 =?utf-8?B?OHJPbTc1ZmJPNTRTMHVVQzlLVnhtaWdoWmc2K3NYSFFCamhvUzdwNkp0SlA5?=
 =?utf-8?B?c25uREVMYXRFN0JFSmcwSnNnUXgvQll3V0k1YmlTaFZwMEVWT0dwUE56cnVn?=
 =?utf-8?B?NndmSEcvSWthK1NtU3krQVdST1VnNS81a08xTjVVb3UvZmNFNWdNZXJuZEdw?=
 =?utf-8?B?Y3BZaXl4Nm4zVGtDUUxSMVAycTVQZENGRnNIMlQvRlc4ajlmTWNUWUwxL1ZP?=
 =?utf-8?B?QnVSWkJmS1VEMkkxMXhtd256RjZ2U0JaM1NWcmc3SlMrV0Q4UXdZeTJza1ZE?=
 =?utf-8?B?L1pMOXlaM1pPWFpNdEdmSTN1MTcyalZ0SWtoZE1ZVVEvNTBZckM5TlQ2Q2t6?=
 =?utf-8?B?eGEyVmMyNzVnS1BMS2R0WDhRWEw1RFk1Q2hlQnNsWE1ON25QQ0g5M1FRays3?=
 =?utf-8?B?VjBIZ0xQQnBaR3dHWlFMZ3lNajhZWERKS2FLcUw4SnI0VkY0eDMzTWFsL24z?=
 =?utf-8?B?M1NrODdRZmhyUFhZY09ZRUZ6RXlSZ0pBN2c2VUUwa1ZmaVpVd1V2SVNQTWxK?=
 =?utf-8?B?aEJmV3FJNmV6UG84YXE0SG5Zc0NsUWdvU3RvbSt1dnNRM3pndGFZbkR2emg4?=
 =?utf-8?B?d05kdWwzMmhVS3FJazFPaHp2R09DRktZVXp6aGh1RC9JaXJtc29FM3lvejVu?=
 =?utf-8?B?VlRMNVMxcE9NcVRvWmxwMGJsaTZoWFhrSDZKT2xLdXlzNXRWREVINVhwczJ2?=
 =?utf-8?B?eDQ3SWJraWtDS3RGcEFNUXl2WjFtQjMrRHVFUjVXUy8vMENyL2FvSnV0eFNT?=
 =?utf-8?B?NnUyRTRXUHFqeWt3VmZseTF0MVJkNnN0c3JLQkt6R3Q4THN3UzRXRE9JVU1J?=
 =?utf-8?B?MHdYUXYvd2JsSDg3b0xWN3M1V3hPU2lhU3l1Z1NxcExlOVhmelorNDh6dHZB?=
 =?utf-8?B?NitMcXNUelI4djdTNVV5TCtRWjlzaGhmc3piRDE3ZEdqQWJZcmtjQU80OHEz?=
 =?utf-8?B?SVdCZkdHSUtGWllnVVdjbFI5cytoaGsweFByWmtpZUt3SUdza3Q3dTJjekFM?=
 =?utf-8?B?STQ1ZnA1aWliZnUvRVl0M0Q3VmQ4VGZvekltNzM2VFNqdytvZE9kQWY2MzFH?=
 =?utf-8?B?Z1lvMFNkZThaWWJZeGs4SS9IbWZmR2ZyQnY2dHRUd015N2xHZWRDb3VjcWNa?=
 =?utf-8?B?QmhYbHM4M3RmTXlSdDNhdWdsZWNQNzZrclV5SC9LSGZVRm84ejZHWTVIMTY0?=
 =?utf-8?B?MkM4djJCNUpIMUJlanFZbWpKWEZoSkNNSHVFRjdNS0RyRUM1R0hHcWQwakEw?=
 =?utf-8?B?Mm80WkxxUnI3T05nNXMzTGZJY1R2elBlWGU2ek5tM25kKzViYndEQlFabmIx?=
 =?utf-8?B?Q1Jvb0RqOUtqVVV4MG5jYS9hRTdNeThrK25laUNJdTdtS2p5Y1dLWm5veDV2?=
 =?utf-8?B?RzVVOU4rcFo5OC9Jc2s5TUMwaUdQSE93RG1sTUdNOTZVYUtsT3J1Q0psVUNw?=
 =?utf-8?B?R1RXdjlsUkdla09RanZjdGpNWGNjbWwzVzQ5QzEzZU45WGt1WWtIaU5LM3di?=
 =?utf-8?B?aitEWWVkRGJYMDRBZ1krUzZ0VExSRnpuNG1pRXplM2VzbVhrR2JtVDRxVkJJ?=
 =?utf-8?B?em1VaTlOTXJ1U3VUbERIM28xTW51Q0lxQUVUUHUyVVZNWnAzZm03eUhTY0pS?=
 =?utf-8?B?MzZTWHZOcTcrQ1JDZk9XN09LYmFMb2NFeWhHT2k3bXh4Y3VNanBnRmZzSFND?=
 =?utf-8?B?RVl3YTYxT3RaMVFKQXRvck1FbU1LdG00ZmZqNk1FZ2lJRTRDd0FGSkFsV1lJ?=
 =?utf-8?B?K2lYRGJReFo1TFY5QXNtREhYeVU0ZXNwTTkrY1lNTldTNVBLQ0RSbTVac1Qw?=
 =?utf-8?B?czhsZ3BFYzV1NW1GbXptRG1uR0tBY3EvNW81TlgzcW5lRlZyUmJPZzMvNWg5?=
 =?utf-8?B?YTd6TlBkdE1qWjJoN2JQZHVXY2NuRUg2N3dpQU1sVHBUWE5CYzRIb2JPaWVn?=
 =?utf-8?Q?knMPiR709CsNlT4qHzaPBTGYo?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hegM49Pwrr79nNZ/cEXFDELTSiOnJ/19eCBu/UCfkTjRsXbJOIRnTBDVETBi0wP1guS/XakgsRWUE6ar45PAPM+xo3X2lkTaEvg2zeONJO1tjinrziTc7OdFlhxJTfR0t+5/LkohU1AVI0kWvnkviEZdNEY+pDJyPjp2VTCC7ZanMN+4hRKKYcqZ1evW/dy0TeyKP2qOLtaOUb3NL01qqMLbgwO8hPGA2Pnz8XechggaSMj8VToBbDXe7Mel07LMJQEKmpirU292nNOVt/GbUlgSjbmpbVYHj99uHSIfwM/0yG8bFruHyuvqYq9nu7UGeZYodPr36tzA/tltGQ5LLv0/0RIxbs2eOMMFtv87kmBfaoLnmR4Mxhse9+a/YSXVPd+X57Qk1odZXArl+yZCIHCYIMFJne83ApeUJNebWTNtKSFixYPC3BeQgoGbedOmZ8dzjfFdJdIEp2P+XkF3SIsFLwKaE4VgJv6j5m0erIL9FqwYbvKfebVRxQj0L4SLBktaL5B6r+iLKzXLe80K9clx+1Yj7WHfr98C5TmRcCYMbM4zo1x3CrIaIkmUsyaN2ncgcIHyiwXnNwa0xrHni+olHopXU3q7KLNkiJsqFyI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4b65f63-2a70-4e6c-b0d5-08dda9980e3c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 10:01:10.0310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ml2P0WNZZYH256hagnqGgqptEOI2lNPGruAFp8wPDBluNpQY8CLiSoNWIbW42EKHz3cZ0koJWALGRw8JwJ3wIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF7BD9BEA92
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_07,2025-06-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506120077
X-Authority-Analysis: v=2.4 cv=K4AiHzWI c=1 sm=1 tr=0 ts=684aa568 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=vDLckumU3XCrawMfmvoA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13207
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDA3NyBTYWx0ZWRfXxd/DAwXRB3UA 8xApdc3jxoRKZdTkwGwR1W/kfOqb5kBPvzmU+Jq5arTIxKvj6gn/FtNGLgs4i0h9R6M4ghhh42p XZPVAIcuN0ogE8+Aquh/l3VyHsQSFu5PNdXtRVdN7wKji3+0SzUAr9M7Rls0qF9cKMUy4dyCdL1
 mQ+04klRFWSG+Iw6aWwXjyB5Q0efmGz19ICplrK4EhUW0PQwAuL8+wd2aHJ8/L+JbOuVDhnUFfO AwJiP9MbaLSHzSWtcWKnERytJU+nZoSnyaqw9V+8n0iL3fEqQulSBjmKJLJh4PkR3uS243+0Bhl Y+/ZIM8zoKNcFcMwNQCdYLbM6WtUlj908Jn6WPUgvlVu+bKiWLDqnNtbvKcrz5vVt7n1eGOTOq1
 p/adb+MuwzCMwSql8Pl2bqIVRhutmcv5GuxYF/zBkTuv2Mxwnqxjxr7rl9UTpKWrY3A9v+5T
X-Proofpoint-ORIG-GUID: khNJQSOAaO3wo_s_EHylMhz4ATNEMbSp
X-Proofpoint-GUID: khNJQSOAaO3wo_s_EHylMhz4ATNEMbSp

On 06/06/2025 16:16, Nilay Shroff wrote:
>> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
>> index 24a857ff6d0b..4f1f7173740c 100644
>> --- a/drivers/md/dm-table.c
>> +++ b/drivers/md/dm-table.c
>> @@ -430,6 +430,10 @@ static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
>>   		return 0;
>>   	}
>>   
>> +	/* For striped types, limit the chunk_sectors to the chunk size */
>> +	if (dm_target_supports_striped(ti->type))
>> +		limits->chunk_sectors = len >> SECTOR_SHIFT;
>> +
> I think here "len" refers to the total size of dm target and not the
> chunk sectors. So we need to modify this and take into account chunk sectors..
> We can get chunk sectors, for example, like this:
> 
> 	struct stripe_c *sc = ti->private;
> 	limits->chunk_sectors = sc->chunk_size;

right

I find that the terminology used in the dm code for stripe width and 
size a bit confusing.

> 
> But again struct stripe_c is private to dm-stripe.c and so we can't access it
> here directly in dm-table.c Better we add a new callback function for dm target
> type under struct target_type and then use that callback to get chunk sector.
> 
> struct target_type stripe_target = {
>          ...
>          .chunk_sectors = stripe_chunk_sectors,
>          ...
> }


Please see reply to Mikulas on this same topic.

Thanks,
John
