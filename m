Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B219B1DF73B
	for <dm-devel@lists.linux.dev>; Mon,  6 Jan 2025 18:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736187304; cv=fail; b=EUtxCW/u6zmbsrsrmYv93OXdfbFUEN27LRiVR6kMBl7bAgjTYAmt7+o4Qp0i4j/x6+F0SZyLmc6wANJ3eVzjdGO3NR65Wa7nTs/OEL54X3IQ1lAb66ZijT9aN03Em1LC47tMGSwW59QM+4qnY2ZXWyWeWT9SusJck4lWH7psNoM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736187304; c=relaxed/simple;
	bh=bd1pt9St8p1frLrDufMHxhQ7CpyqFO+eHv0IX7CwIic=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sonn3EGR3TpOU7J5ZOZ6gWBIzFJtUuAbgcQpLCgDBKgODLPT8mkvXf9LE/pv3RtMpqKCHZ+BuqzY9tSRN2gjiMDFLskIf/uzo8Wk3uYVzmJ27QixxvAuVrz5SxxgsIuTcfwlJsZYdhML0UCCCUZkXSXTvPicjRdiPAfHOgQszgM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GFyuiQwn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=y6pj6/lH; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GFyuiQwn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="y6pj6/lH"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 506Htkkg024539;
	Mon, 6 Jan 2025 18:14:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=OhGFUe9oi3qEoy+d6FoicON6b9AFqC3QN0h1bI5t5tA=; b=
	GFyuiQwn3zC5L7pck6vDQCUUduSvQbdAELMvVqlQdAE6ACEZnG7jO6TyPE64lP5N
	+JshNYD4+7p/LpkDcOGWzCqicglCnbNJKcEf4+RG9w2+2UTM4r/7eGTy25wWA5X6
	otTQlBaE5hfAd+4QqXV5yB9Yn1RXbJwCyGyr5o0YiFAI2R61FvUy2NmVl0QT5d2q
	odo486KBBVrj3PJkiPZ7zmL7ZK9zYiQkCqARl9QwfAmvNu4u/mo5Eq8Z5uHPIbZS
	1WgGKlsnBFQLFVrPJ0bKXI5xKJLpo8xVbLn6pH5dcJh+XNO+gt+FBwwrrvOnvd1q
	WcyRo5EdsL4dNxtQCFecEg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xwhsjv8w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jan 2025 18:14:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 506GdULW020171;
	Mon, 6 Jan 2025 18:14:56 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2041.outbound.protection.outlook.com [104.47.70.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xuedupt6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jan 2025 18:14:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=moowA1V7vd9AkmmJ54EcRlqQWoMCTVDYpFyPJhCe/j2BB0y/DeL4kMB8INahXWmJSggaBCviR7d1DH7Ka9cjBVxseL3dHxfcdq8CDLmVbtWbGbvXXnC7WkDentVJmvVQpvsEU+imfISRXv9POugrGTlqVBLIQP1SVJQc0aE2YLBEWJ5Jwcnv90qqBZyFruqNg5rhzEiOr70rhu8doiwFCORDd94cO4S8wHXm74GfedHiWGpp6sAjJqZj6jq5eTXUXErkP4rwCHOPtv4r6hrvJB/2cthVMJpNrKzGE79QlmQO8KPVvqiv5zy7VrpbDwdtniocqGgm1RT7ljFTcBiMxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OhGFUe9oi3qEoy+d6FoicON6b9AFqC3QN0h1bI5t5tA=;
 b=huZZlzruJJNTxScHk/vBZBMlS5M/ynPDuSbJzsKqqS7bJPeLgM9qPkQ6slpNX2jzIMUXCtHrgCbm6+ri9SsY+zF/iNOMHFn6waUk+JefH075iPHKD603jvoe9qVw+XApVKR4HRakacfg7sabOYN3qlVxCHaykqoJdPJoSEJzCXtyqH5eWj5QMIFFMkZazLeYX3CmPqkyVLaDvRAawC7PLQITKKS9KfhxBLLogMITNN5sTz1dQ74NqB3vIYozxI79SrtfDhY0/DlQu8Xj2efr7M0cFZrpoWpQ58SD8IJjBEb5HBafmgbq+JSlkRB0SBbe4WhKICCBnWafH2r9/mn9Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OhGFUe9oi3qEoy+d6FoicON6b9AFqC3QN0h1bI5t5tA=;
 b=y6pj6/lHvtr64zCBL801x7Qp9/KW70OlOIEY6urStE1arIS7wwoSMZ5mKmOcsZn/mTFJTpFWDTG+neR08h98Q3MbQjeCEST+19mcXdwnp2ruA0tQalSfEErgffu1DI7Iu2FVndrxI2RNEpDnE/RLEMwjDg2NfGpJ1OYMm+ZDhfk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB7137.namprd10.prod.outlook.com (2603:10b6:610:12b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 18:14:42 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8314.012; Mon, 6 Jan 2025
 18:14:42 +0000
Message-ID: <dcbaadea-66c1-4d98-8a37-945d8b336d5b@oracle.com>
Date: Mon, 6 Jan 2025 18:14:38 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/5] device mapper atomic write support
To: Mike Snitzer <snitzer@hammerspace.com>
Cc: axboe@kernel.dk, agk@redhat.com, hch@lst.de, mpatocka@redhat.com,
        martin.petersen@oracle.com, linux-block@vger.kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250106124119.1318428-1-john.g.garry@oracle.com>
 <Z3wSV0YkR39muivP@hammerspace.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Z3wSV0YkR39muivP@hammerspace.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0P190CA0025.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::35) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB7137:EE_
X-MS-Office365-Filtering-Correlation-Id: 607884a3-fc29-41c5-c704-08dd2e7dfdab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NDVRRjhLTmZsekhhZ0VWNksyOWFhREpPMm1BT1Q4czE5cUdvMlhFdFBsOGdV?=
 =?utf-8?B?dS9KaVR6MDZlRzAwZGZTM09SQjBkeWlFNmRnV3pyYmhpdXVRNW9OeG1BS1hX?=
 =?utf-8?B?VVpyU0dFSVBoNmc2KzBzNkduSDN6cHlPTWFiY3NQNGI5dElpSVFHT3ArS0lK?=
 =?utf-8?B?MFpGQjFJbTl3REJFQmxqcjlFTi9NdlM0bzkwZENvR2VwbkxwbXo1enlhMTBO?=
 =?utf-8?B?Q09xQ0wzbmJTLzdyQ3BCTHRwWjlaMU5Na2JMbkNEbitoczMwaHNpV2dBQjdn?=
 =?utf-8?B?c0hrNnlZRURlYWUvbjMwdUhHK252UjlWTUNjcHBlYXZ0YXYrc212MW5qNjNr?=
 =?utf-8?B?M1pNaENpaVVjVStpR3QrcjNkRVM0L3JiTDd2a2d4eGFtakEzTzJ5aFV4WWtP?=
 =?utf-8?B?RGt4bTJWQWRCaVBlaUdZYkZOanY5TnJMWHRKQTZoNTN1aDFHWFZLRGNjUld5?=
 =?utf-8?B?eERSR0pLcitFMkVCM3ZveEI3eFo3amttUTVuWCtaOGRoRUxScXQ5OHJlQnFa?=
 =?utf-8?B?WmMxR3NheklqS1E5MSszakFKU21BSVBxeEl6R1MwK3M2dHN3SFBybmJBandj?=
 =?utf-8?B?NS9zZkhYNjhFRjFaQTV4ZjZ4RGtyYTI2YVRJRUZoaE9VRnAwc2xrWm1ST1Mw?=
 =?utf-8?B?K2JSdVd2L05UV05ZVmx5ZUxMZjBvcStiaWliRi92UCtkRXpzQXY1Sis1N2Yv?=
 =?utf-8?B?U1FoK09LMi9IOUVHMHdSYTcwOFBkWGZpaW1NVWdUUXo0em1jVXIzcTFhUno5?=
 =?utf-8?B?aFpIMWZBbWRxRFg1cW84cW5UN3FPU2JiNnJleUoxbGwrVGVyaWVzOTBjUkhp?=
 =?utf-8?B?TXZ6MHVFWmFrUHNtTk1Hem01R0ErTDAvUjd6VC9DTlNNU0oxemQ4R1ZZTWxu?=
 =?utf-8?B?TTJ2bWFSdS8xQno0ZkpYb3EwdGNJWkNUay9JaWpXdmVaeUxMNUxmODl6M3E4?=
 =?utf-8?B?cEpwSDJGZjI2VkNLQTJvMlFFUlU4N21OdkRPTm1zaGhiNHdjMndDTlp2ZGJx?=
 =?utf-8?B?aWVNcjJmUzI2eklTQ2FjWnVtc1o3dk1oYUxBU3lYU2F4ZFNyVTRONFRhTlM2?=
 =?utf-8?B?MVNLRzZzRmNmbXhTZFpDejI2QkF4VE1KTTRDMm5uek9iUDJmZjcvUVUxWXJQ?=
 =?utf-8?B?NWdjMUp0VlUvcXprWlZLWXRoOGlsa2VEK3NRL01HRkpyaElsYmRmU2QzOHVJ?=
 =?utf-8?B?eXFjSXNYNWdTTS84YXk1bUpHUmRKUW5jVkgzN0xnME01LzhkTlZETEI1NmJh?=
 =?utf-8?B?QStrTnJmVUtZcVBlQ3FFTlk5ZHZhVWRBNlN6MjJvTlduN1A0eVNQbGRJUW0r?=
 =?utf-8?B?RXNVNW9NZy8yUE5neHVVQ3lDMlU2NXgvNDZYdGx4eWEvR1RITGxONFBKZ09y?=
 =?utf-8?B?Z0hBc09kRE96OS9wTC9MT2ppQUJZeS9LZEQ4YnJoQTJ6OGZYb0Z5ZU8zNEV6?=
 =?utf-8?B?QkMvM05ta21XZld6ZVZBYjJXTTFwWW15V0xBcE9SQ1JjQkk2S25GNmxvc2Rp?=
 =?utf-8?B?UE5Sdy82cG5kKzh6Y05EUE92MnIyL3A5d3p3TXE0b3diVVNWQlFJYjROMFh1?=
 =?utf-8?B?N1JBQ3JDVzRhL2szZ0loa1Q5OEcrK1VWVm55bnE1MUd1cVI3YWpLOTlwZDdK?=
 =?utf-8?B?Q0k1bnV1YVdIS3VrSGlSSDJjNXB0M1VJM3pxUm9PL25lOFV4VDQ5b01yVldZ?=
 =?utf-8?B?SGNTay91dzI3RlpCNllkaEFDWWIvZnpub1VzR0hJVUZwc045YnphNlM3endI?=
 =?utf-8?B?a1ZYVnF3WEMrNldjeHJXWGNDN0U3SFR5YkpzbFUwdXRjaWRDSmtubk9leExx?=
 =?utf-8?B?QUN6dmdqdG1oV3ovbFNvQ2hyN3Q3aHFFS2RjT25tUG9IWHoyckcvZkwxS2NT?=
 =?utf-8?Q?B1JlUlINOfcgu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U3lpOFZZb0todW9sUDZyZXQ2M0kzOCtjeGovdkNrYzF0YmkyUTdOMWNRSUpq?=
 =?utf-8?B?VXBqUmlLRGU2MXBCbTFMY0dXcG5tcWZPZWxVRmVEZ1BUWnF6NS9wQXdGNzFx?=
 =?utf-8?B?MjErcEVOak5jZlJqUEIrM2Z6Wkw5VGY5dzFvYWdKNXN0czFLanpoSEl5dW9V?=
 =?utf-8?B?SU4vZ1Zvc0Y5U2lpZ05mRi9YS010RXc2YjNSaEwxUE03SmliZ1Zxb09Xc1ZF?=
 =?utf-8?B?bitaYWhMQnZKM3VGU21mU1pCZm5xdERvOVBneFJxb0M1d3pjVHlHbWxnc1dz?=
 =?utf-8?B?SHBLTk51M1Rta1FrS3RMdnpwK2dpUnZ4MTd0bGZZK3Q2bVRONUI5VTdLVW5N?=
 =?utf-8?B?eDhWdDVNcWNwRUY1VUpBNkgxTlp5NW1TeWgzWWZvOFU5amhPbGlSNjhsaUp4?=
 =?utf-8?B?RkRndUdRNjcyL2d4dVkyQlE0SUljNkZDNDN0RVd1QlpuRS8vTDJTTnV4ZGti?=
 =?utf-8?B?bjVzcC96S3pydFkrOWpramszSUxJQnF3Ti95TENGbGNKUzBpWkF6NzJxanN2?=
 =?utf-8?B?UjJDcUFrVDFxRmJUNHU5QVpZTTZ0ZXNqMjA4TlRxTkRCZmF3bW04VzVLdERm?=
 =?utf-8?B?U21Ha1UwU09vaU5MRS9meVRScUhGallySnZrWmh2cjJCK1VkUkZ3SERYdVlY?=
 =?utf-8?B?NVpUKytaVmRiSlgxenhDUGZwNjdaaGZQamVWUzRtcjBudnlmNzJneUgxUzYy?=
 =?utf-8?B?N3FsVHJTVlZsNERRRjBkNHlIQVd3dVU5THNabkF2Qk1BMy8zektnRXQvUGY3?=
 =?utf-8?B?MlVlbTdaZ3IzcHFmQkNOcGFmU0JvUmo0SGpUMmxJUDVxYzBESGxacnpoK1l0?=
 =?utf-8?B?cGJHNlpJaEIrLzZlRWNNU2thWWRhT2ZQQzhseXhkVDJjS2gwQzZsOFptVVRL?=
 =?utf-8?B?Qk13bFFVU0tQRGUrTTJWbDBUU0pqYlQzSjRwQzdVVmxtVHZIUFIweC9kTEMz?=
 =?utf-8?B?eGRqek5YdVQvLzVpV2wyZDJKUVpzbVBDMUNWMzJCUTNuV1dsVExKSjN1NGtt?=
 =?utf-8?B?eFlORmp4R2NUd3dydnFXa2lKUW4xM1VoZXVnbHR0b0Y2MWRpb2FIZUpJd1du?=
 =?utf-8?B?Wi9FK005R0hnbm00UC9QV1RrNDMzTDIzUFU3cGVRNUMyMDUwWVdwMFBhdXVz?=
 =?utf-8?B?Yy9TeXpVeWcvNUR1UGdTV0VlUVRScnJtcHJsNjJmVlQvS3BVTTVJa2U0eERU?=
 =?utf-8?B?bDFQRmhhTXZPK0NwZjNZbWk1bStQNGlUOEF1YzlFSldrVDVTNHkzMTM2bElJ?=
 =?utf-8?B?eTdGeHE2VGJ1dUtOQkZ1MjlHYlRWYmhJcEhoUFlSZWNtQklYR2ZuY0FuN2Rh?=
 =?utf-8?B?NEE4eTRaWmVTTHJteVNOd3oyRFdjZzZaMitGTjlhOXBjZWQ4blBrYld1YzN6?=
 =?utf-8?B?WEZRa3k4cnRDZXBtejl2RmJGVGJjbFZFNGVtN0VSWEF6U0MwL1V0akQ0bzVD?=
 =?utf-8?B?V3dIQjR6enNJRU9DZE5ablU0am44WkQ1U2QzZG5DRUx5VExXN1dhOVBmSytN?=
 =?utf-8?B?MVAvejRmb0p4VGFJREVLMU9UUTl4aHhTZWJnV2VaNjB3VkJpNlorWTRBcVFa?=
 =?utf-8?B?QW01N1hyT0pvanlUWjdNMXYyRWdQMlpMdDNqNDVoT2kzWEFHUjdwTHJBUThv?=
 =?utf-8?B?T1lsdjdJanhkY3pGWEFWY1ZPeEhSQkxMN0x2OXZxVkhLMXlINTZhaTV2RDhS?=
 =?utf-8?B?bmxkTkpEcHVGYkFGaE4ySHR1K25jYVR2YzBodlFSVkVTWTlUNGZFVXlSOXBI?=
 =?utf-8?B?WlROZkhlaVJQTENtOWM2eGxBN1I3RUVqeFRzNWMvT0FUTHI3d05hVytkcmpC?=
 =?utf-8?B?am94M0xEZmhzc2hmUUhTSXJYcy9NT0UyWjkyU0JuN3RUQmRRdVZyY0ZvWnly?=
 =?utf-8?B?L1NOaGJ1amUxcEMrcklONTBFSVVtVDhMUkFZSzg5TnFhNW9OSnVzbVlYUXBa?=
 =?utf-8?B?OTIvdUo1VE43cG5GN2dTWFBnZHV4a0RVblhQeEpCNEpjTHI1RzYyOHNKRHVL?=
 =?utf-8?B?b21QS2pTNTBCRy9HNDBwK2tReS9MbzBKWGVjeGVNLzJSKzVVUElCVEFDTGZx?=
 =?utf-8?B?dk9jNW5sU1UrOGJtS3RUZHN1ajdFVExKZGhBNnVoa21ZSlBlWnNNQUZyNW53?=
 =?utf-8?B?TVZuSGhLLzR5dUtPOE13VXRmQjRsS0k5c20zRjRoUDhYNmM3aisvclJOcDZ4?=
 =?utf-8?B?cnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mF9ouKpFE3AyQoJAcw5kvz/53MQofxIzdRseYukqVqzz6HhYSR8q3AaI6TUDZMru1NP55nXDUIh/SFl4rPPoxVxqs9h/1ZTCI4tgzCRTpjS0TMBhtyBxK/AlCaV2G0uMPlH8USRhQp3SqM5yQ63i6WjTXrGO9jDOXLKMky6kC2pjz1IIOnbEA2RTpf3bq2I/2RIWRfaUoAx4Q5q8hluqcA4hkB/rmYIm5YaG6gLLUdz1hicFhCnXU/MhgINZkfEhRFOR6wrRY1Nn0NVDaD8dSMwA6jHZk1XhmarboOh23cjqyazzBFSa0vsjKfgQ8BgIW8/BGNDeApvyxCvPqR+xQ1JtoQWovLSf0IcIGpnon34uBq62XiabLeyMjTk5fWpUjEA644yg1uJa5L9qKjUIm4G/rA7bkkzC/tQ94r1g1nF5g/4wjcXXv59FQTvMfLAWckNjB+0XftzgDmOC3PeiHOAuL+KuCqEAVYa4Po6iZXkAUNAyOZfk4N56Bt8YiKBWis6OwVr7xSEQFyR87yvuJpiFxCjoncXTm+AgHo7pQy7QP85w2Uqip2xR4XZoPQe+g152rjB4B93duKV/wQha/GUoL8MVEaxZoyceWbdviGs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 607884a3-fc29-41c5-c704-08dd2e7dfdab
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 18:14:42.0397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g2X+ifiKxZAZbL6NeBPGYjr01/NTHNpfLfOweXIUPh+zpRvDv2FWs+1PRBvz8FFfUSJJK99PhEOXyua95EFG4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7137
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-06_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501060160
X-Proofpoint-GUID: WQOy2iV1jMrIZVJq2aqriic2IovUJyPN
X-Proofpoint-ORIG-GUID: WQOy2iV1jMrIZVJq2aqriic2IovUJyPN

On 06/01/2025 17:26, Mike Snitzer wrote:
> On Mon, Jan 06, 2025 at 12:41:14PM +0000, John Garry wrote:
>> This series introduces initial device mapper atomic write support.
>>
>> Since we already support stacking atomic writes limits, it's quite
>> straightforward to support.
>>
>> Only dm-linear is supported for now, but other personalities could
>> be supported.
>>
>> Patch #1 is a proper fix, but the rest of the series is RFC - this is
>> because I have not fully tested and we are close to the end of this
>> development cycle.
> In general, looks reasonable.  But I would prefer to see atomic write
> support added to dm-striped as well.  Not that I have some need, but
> because it will help verify the correctness of the general stacking
> code changes (in both block and DM core). 

That should be fine. We already have md raid0 support working (for 
atomic writes), so I would expect much of the required support is 
already available.

> I wrote and/or fixed a fair
> amount of the non-atomic block limits stacking code over the
> years.. so this is just me trying to inform this effort based on
> limits stacking gotchas we've experienced to this point.

Yeah, understood. And that is why I am on the lookup for points at which 
we try to split atomic writes in the submission patch. The only reason 
that it should happen is due to the limits being incorrectly calculated.

> 
> Looks like adding dm-striped support would just need to ensure that
> the chunk_size is multiple of atomic write size (so chunk_size >=
> atomic write size).

Right, so the block queue limits code already will throttle the atomic 
write max so that chunk_size % atomic write upper limit == 0.

> 
> Relative to linear, testing limits stacking in terms of linear should
> also verify that concatenated volumes work.

ok,

Thanks,
John
