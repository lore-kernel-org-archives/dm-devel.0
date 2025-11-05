Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D724F27CB0A
	for <dm-devel@lists.linux.dev>; Wed,  5 Nov 2025 16:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762361426; cv=fail; b=dE1VkYDDCq78tI6nugXbXSiGH4hEPHlzo1ffOORI089c0QxZZoh3q2sjLeXS4o43LGsEaVj/rR93UZNUHh9CvL4ZADrtIrg+l+QhUHUQDtPxx1DQA8Tz62YMK1Vqk92+b22+QJHOfayvbfda3RVnS2J/C5yfrZ/T85TH0bVDcdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762361426; c=relaxed/simple;
	bh=ekvCaiflu7G+SkKVrRNNUoK8hGbLbO3uObvDVlxSfZI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IvqZ1dxM+xwLXAPknca6IqTHglpLm91OwHcGDFlDr5ZqW/6hwGcPdMHaOH0xGMD1l19LZVnbS9ZQHnB21eUsFlMixPy7w+19m2PjI3bVy5hHYfCJ9FFmQAyyc3T1DGBDBNkx2qfM6WZM8OjT4XCtAfmEsIKq7e91SIc4ICssIvo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WjdECJme; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cgpeQOHv; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WjdECJme";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cgpeQOHv"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A5G9UAo003674;
	Wed, 5 Nov 2025 16:50:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=eZCIUPR/XCdmD20GW3+4CGdTdScm+kRfM5+BT6cdiTI=; b=
	WjdECJmeQhw4wSCCP05R5UKzw5YGpu8he/b/pyzyJRfBrA5k/gfCnFwcD8e50fAE
	ds7FEQDxcvNJtGv3emCMC+38ZEShuo3nIC15muKsnDyOcIKU+EPnkCRCwxRE9nxc
	pXog2V4evgm02DK7k6z6i+AChaQeFVMTe7Dmvi/NIDLvbKF42fUYBwT31eyBJ/1g
	8g2mtAsOR86OqIKJiHufOqwSiHc/DSl5hb5SV6GkwffmcVFmXI4UAeLjmGUJnnf9
	AuxgYcBFjQGcxsaAm7rvq5rryBqYoYHZ8JXyBAKUTErVnK6IYDSOE707fmc4dsje
	daAYdujeJYFXCvIi20DJ2A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a89usg3ja-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 16:50:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A5GRYDl010907;
	Wed, 5 Nov 2025 16:50:19 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012022.outbound.protection.outlook.com [40.93.195.22])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nb7pct-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 16:50:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HA5cPICB1OSMtewweFh+ctbQ/6eqY9L8MHZn4l6IoYa7qJ53DpId62MUasJ30PjohsQfJAkDJ21tlCijd/w1A52yy/azKapbItf7mdO0E1gZCKCYUiPFeqpVFHfCDoxLYDX5by4oTMGe7UKaWdyfLPBLWAIhuyiwmb6EKDaCNLN7zpMyj9IrKgMuUPEevjg5MoZlJZ5L0nc7beQArZO4WD7TibRYvy5N52KaqZM0mjvrlh6k+V2hSu4yQM2ZxsqMGOCHGhkynrQoyJvY0vrv5F6wrJg9P+cSsRhEe/R8E47RLkDvgHxh4rVngN8LCcZTS/zihIcN1nhsKYOIvamCrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eZCIUPR/XCdmD20GW3+4CGdTdScm+kRfM5+BT6cdiTI=;
 b=NsFC8svjBUzDqM3ciDo3FYAX3SQUUDwF1N1KJ97o5HGxj5vfmov+G9/eTJMONBZ0wagzU4kxQvChv90qb1P1qWdIdZ0kPY2ghYlhYR/uT4ygB5ijU4U+71r0wm9gWT7dJrh00vcXslga36pXhRcjSBX14Pb10087kppVl12xYGLw8ooH7n6hpCiEVGUWkiM1/5+ppLTf6ObLoKFgBTRL6shcYcu1RF/wK76FBE2WKh9z9rZgo5AXoW7CI/ED3WTfjqQ0TFXuPhboEZBWYoO09x5tk+F0b+HJG31anf72VmY0V7mdKbp48vx4O35mUYZ7XrXmY8N8yeekY/3ym7IxIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eZCIUPR/XCdmD20GW3+4CGdTdScm+kRfM5+BT6cdiTI=;
 b=cgpeQOHvgeCWMHFH3pawF3JpXca/mhG/zGr9ILFvbPw3sL/GT61PmsbYMrZxweUhouP/Arc65e7eZ0wBeyJ3+6F//dho3PBMxKjrrf0V56tA+q/mZfPYVVRRYZJXllICvsYmW4pTquLYFR/JFVKZ0AYjuSAlqUJujBmvMd1pxGM=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by LV8PR10MB7990.namprd10.prod.outlook.com (2603:10b6:408:207::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Wed, 5 Nov
 2025 16:50:15 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.006; Wed, 5 Nov 2025
 16:50:15 +0000
Message-ID: <90b9aaa5-0572-4a3c-afd3-33864daeb814@oracle.com>
Date: Wed, 5 Nov 2025 16:50:13 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] dm-crypt atomic writes support
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
        michael.christie@oracle.com, martin.petersen@oracle.com
References: <20251105120244.99752-1-john.g.garry@oracle.com>
 <7942b0d8-9f5f-d8b5-194a-3dd5b604898a@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <7942b0d8-9f5f-d8b5-194a-3dd5b604898a@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0225.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::10) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|LV8PR10MB7990:EE_
X-MS-Office365-Filtering-Correlation-Id: bc19050f-5804-4bc5-0ae1-08de1c8b64c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WDVLYXVGajU2MHdReFJVZWhNVDNYUnVGS2FDVzFVeUNCZUlsVTAyamtteWFl?=
 =?utf-8?B?YXRkNkswcjJvbmF1YTc1T1AydGM5ejN0RnF3M3B6U3kwaHFGZlFUM2ZtOVVC?=
 =?utf-8?B?TlJiL2hMMGh3Y21JWEV3WndwYWFiSlhpc0owQUV1NUNZQncwWHdlRnhuL0lM?=
 =?utf-8?B?c0xCQnJpeGJSNXRERXpZOCtBbUNTdVFEQlhKMDlGZENhTTFwTThwNFdaOUdB?=
 =?utf-8?B?WGNiNFJtTHU0a3djVmtFUmlMbWJrbHAzY0JXZ1dwRFV0TzVlZXNuRmF6Tzkr?=
 =?utf-8?B?eEtQSWdRL2VvUnQyTXlZQ3BrWllaMWRPb2JnNWx0UWl2cSs2K051YndlU2F4?=
 =?utf-8?B?SlJoankwbFU4NjJObTF6c2loczYrZWxhOGZVYjF5dW5KeXFWYXBMVFlSSmk1?=
 =?utf-8?B?RURSMVZTREcvMnBOaHMyZEtCQ2JPNDFnR280NTVRUWJtLzByT2JFRjA0Mzha?=
 =?utf-8?B?S2JSOTAzNzZEMzlhc3I4S2YxVXRmYm5ydXlSZnp2WjU3UkRQcG1zVDU0dGNO?=
 =?utf-8?B?M0puYnhONE9mVEhIbWdpbGNzN3BSbGRqNE5wVWhaNGtlajRQM3E4TXQ3NnF2?=
 =?utf-8?B?aDdydzRSWEd3VDd0clF5WjlvZCt5OXhSb2krVUR2aDF0VTQ5aVlEWnpCanFR?=
 =?utf-8?B?R1ZRQ1JnNUx0aUdGM2FHR0IrMks2bnZEK3YraVVzUHlMY2cxd3hFejBydzht?=
 =?utf-8?B?VkczMDgzd3FuaFd0MjQ5V2p0ZTA4TGhMSVpZQTF6VDg5S2gvK1dPVTROSytL?=
 =?utf-8?B?emg5QndhWGpSajl4ZEpGVTJoZmpteGlKaGc4NG00TW0wYk9UWW9yVkdTenRK?=
 =?utf-8?B?Zkl6c2ttY0hvK2RsQU9XT05hdE9LK3p5aExjTll6cEFOMnJJdk5sNmwxL2lx?=
 =?utf-8?B?dkxBRXFRZFV5dkdKMjFxaWxtZGlnTXpiTFNpTEYyMUJWbVY4U1Z4VzYrdUJS?=
 =?utf-8?B?NUJUWGw5ZDdiQ0FWZThlS3VDZ2tOWmNYb1dGVy9rYSt5L05kUXpkWHRpSXBX?=
 =?utf-8?B?cVRFNzZXdGhJbjN4dzgxY0tSWFhVcnpkQmZuNklWU2tQMmF6Z0xkM0pqY3JN?=
 =?utf-8?B?UHV6YlNFZy8vdEhsVnRCc0tYUGd0MFJLT09MYXhLV2hzNk5pSS9VUHBNWXlE?=
 =?utf-8?B?Z0tEUnJrNlRFWFNBRDJ3aldmWjl0WFBoc2toNkNvK3g4MGlXSzhqMi84Nnpp?=
 =?utf-8?B?b3ltSm1YNmxPQldBSDJCR0J0RDFYWi8xSU83b0RKTG5KQnVDd1BEVUw3ZWl4?=
 =?utf-8?B?SEhwZ0NWTXVqT203aVFpV2Uzd0tkdUpQb1IzWko3UTNYVWNTZWxHOHJMNEV5?=
 =?utf-8?B?WTNrV2ZNTEdVbTc4YlFuOVdoR2pOVFRyRm9LSThVT2FWMlRLaU5wTUFhczMy?=
 =?utf-8?B?UUpxZHd1TVN5WE5wcy9ZMXlDbk1OT1VkZ1BKSUJ3TzQwSHdscjNjRGdpdElU?=
 =?utf-8?B?K2R6YW5WeWNqSm02cUVQbFZjdVdtSitrQlNMQ08rdnpwcTlxTW5yY1h4WXZm?=
 =?utf-8?B?cWhrY1VBMUphN3F0VmVsTWtBOEFMUmFRcmMrbnMvbjNDUEs2RTdodFVYTTR2?=
 =?utf-8?B?WDZHajljanVEckQ1eURVT0RIdk9QalYyOFdBMXk5WDBwSW1HV3QzQXVPZmJW?=
 =?utf-8?B?KzhWTVVab3dSdHpKNEhqbkFicWhLMDRSeFYzenI1THFXbkE3NjQ1dko4OEtQ?=
 =?utf-8?B?Sy9QamhabERiMzZVUDlHV2ZCTnR0c0taSTRXWWFYU0dpeXAyaGtKckpLZzV6?=
 =?utf-8?B?NHZUZHBhOFBJRjViUExGVjBXNm9zOUZIN0lnTXNFMk9QSk1MYWo1aHM0WTNO?=
 =?utf-8?B?ZWZLb0ZaUnpTdDhQcWhXUHc1WmR3MWtTQjR5NGVsU29kWDM4Qnp0QnY4NGhl?=
 =?utf-8?B?VEN5SGlCQVFabmd4bGluS20zUWxwRFRBVDc2WXNuZzNtbTc5ZE9zNXNWRnNJ?=
 =?utf-8?Q?J80lhGwoZaj4ScxkcUDJg3juPzztWPUr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TDhiVTgybWdkRDdBMk1Rd0pVUFovSXk0VGRQLzliQUQ1dDI2V0tYQVJVSjY3?=
 =?utf-8?B?K01MQ2pla2VBZ0VGR3BqQUVuanJuZjhPOXNEWUtVZEZHOThncTVCeUZ1aDF4?=
 =?utf-8?B?TDFHc2FHbmdFUnluZk5hMGJrTm9wZFFKUzVBSzloTk0yN21NYURZNm1tN09l?=
 =?utf-8?B?TElKTXRzQUxCVm5DQkVUMmFuSWM5eE1KVnUzdXVxYmR4ekYzS1grMWRlWjJD?=
 =?utf-8?B?QW92dHFEUDVSUmRudlBHYlorNGl1NWowQkRLMzZFd0NKQVE5RThjV01sRy9j?=
 =?utf-8?B?NVk2TjdsNnB2UFFTeEpyY3pCcElVMjZvS2xtR09LYlQzZW9lcldqTlRtU1lt?=
 =?utf-8?B?ZlpDK3RDV1BIamlDQXp6ZVZ5ZnJzSGl3S3lkd254Q1FGQTY5ak9GdE1MMHZJ?=
 =?utf-8?B?b25TM3puT3VoUncyWmk0Lys1ZXo0NGFxZXlhMmJIUW9jTjdZMGdwQUpMOW5Y?=
 =?utf-8?B?L0ljOXZEQ1EzeEJHclcrMVZFTFZPMmxudHpwSE4zV2E2Tjk2NUQrdWhSUUJo?=
 =?utf-8?B?VElETEZzUmNmMkpXVEI1KzJLM2J0eitUNXE0ckpHL2E2OGN3UHNSTlNIV3FS?=
 =?utf-8?B?cFF0YkwvelVRcjJ0RzNzTzhrN29DTllEeWhMdGt5a1dMc3lFMHE3TjE1Y0FE?=
 =?utf-8?B?cWZEY1l2M21nM25SR3lKOGYrU3dwa3pCci9BV1NVNFFTUmJ2NnFiQkg0V2xK?=
 =?utf-8?B?ejdLMVZOZWt6MnFVQjdTYjZkdTNDVEg3SFBPeXkvbzVuR3VUbCs0d29WblpU?=
 =?utf-8?B?TWhneDRudDVtUWFpU3Q2T2ZCNVlicjh5TmlEcEdYWGVuTWFQM0RJaXRMeXZp?=
 =?utf-8?B?TW1zd0lZZDZCWmxTR1FLdHVZYmxNZDgvRldoZm05SVdYcFNxT2J1YWRQRHAv?=
 =?utf-8?B?MUlwbjdRek1YZDY1TXpTNGszdm4rZkxVcnBvYUpyWFBOZk40UlpCd0pGZWpE?=
 =?utf-8?B?azdzQzY3NHpOVXo0bURHWDROaENDZmtsK0VZN3JQR0hIaHM2Sm15WEVoYWh4?=
 =?utf-8?B?TEE0SnBVc0Z5MU1HRmFrRndWRUI4WnkwNWtBT1QxcXZyeGFwdTVPWXlMNmJ4?=
 =?utf-8?B?TzJkTjQxcWpNTVBrd0Eyb1hGMGRrajREWEU2dlZiNG1VVFFvbFZ6WlhScnpU?=
 =?utf-8?B?cTVGcVk2bWZiSzBHci9ud2dqODBnd0dTYStHZXV1MmFFaWdLV0hlZG9OK3F0?=
 =?utf-8?B?NVJaTVRTdmM4bUk0TU80Q3R5blU4d1J6TjZMSXp0UVlQRFNvempTQzl0VTkz?=
 =?utf-8?B?aS9TajhwckdYNEZkWnRZK0QzTlFEc2lrbzU5KzRIVG5iaVpjQ1RkRE5pYU5T?=
 =?utf-8?B?K0VTU1N4aW1PbUI1R2Rpa0JCUE1sN2hwdFR3RDEydWhGSW5Mc2puS1gzVmRi?=
 =?utf-8?B?b1duWFl0N25ZSUlyL0hEbkREOVVBdE9JOWFUdjY0WVVIazcxZUlkVUh3Qjlq?=
 =?utf-8?B?SGFXb0dCdDZvZVdYczh1VUZoSjZqekhKZmVxd1B3RnVpZ3N2ZGdrbHVrQlFw?=
 =?utf-8?B?OS9RK1M4SDIzdHhDK3ptY2FHZmIwc0dhNE1uOE9BNjhSbVhxTTJYVWNxUGo2?=
 =?utf-8?B?N096TlpaRm41TTBDVHdPVlZPWXJaNUtpVnk1V0gzekI3UHE3Z25oYTlIK1BC?=
 =?utf-8?B?ZE9ES3NOMGdiWWFRYTVNaTk3VmpDSkkrWWpJeDMya2Zyek1UbWx1TklNaCtu?=
 =?utf-8?B?aExyREg4dVRTNHVteXJpbFB1NTB4M3NYWWUvaHBXNEdIa3M0aHVMcnJwUEhX?=
 =?utf-8?B?bW0zcCsydFF5dE56UThLeUtPbDhHN01FT2FtUndDODcvRHlsRzk2di9qaUUz?=
 =?utf-8?B?TmhxWlFtM1lkemRKdkFwQmxSUjhMTDVqOWlzcUNXa1Z6TXNkQTNOM21rVHJw?=
 =?utf-8?B?VE9BMFFEN0g1TnhCdWVMeGpVSWJxSWQxVms3ZC9sTUFZaW83WXAzNG1vaFNu?=
 =?utf-8?B?b0pNSkY2VG9zU2JNRzUzNDVlV09HbzArdGVXTld0Tk1BYmJ1SjBzMHVReU8y?=
 =?utf-8?B?VWhzRUpjdlFKVG5iU3h1SmFLZU1tOE9VQ1V4T2xjdUlRZkJqeVBnRlplMEts?=
 =?utf-8?B?Nk1aVnhKbW9vb21CMkVHNmlBZkxSSWN4bnpWZXB5L1FqRWt5K0FJOHpCeXNL?=
 =?utf-8?Q?B2Iqbmcn8m4x4nIWR9CiTLfzP?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	78WXCUp/CdHkzwIHzpyzdlQoL0U9O6G7w5G2IqTB+EiTpJOm70yRv+w7SKpsq7qtCL4O4lUBxDfyxkoaC3RiB+MLcUdeiB8mHNpOUExqALHsgeiycM7hlss4CNAeQBvdwQngphDVgvW5unFuIAfi02bMbzmN3Zbih0cTMMuOUeCgGksy9wh5m561Z4Q8t/pYFDNcwx3EfSd68Km9FsjjlMxsylSry3Z9T3TBD8KSv7ET8HxA5c8eSeUrTglUZO6Rhly5dnbsVMH+uNsJemnABfUKJ17lcW6fq+8ilSpaDHlHsHypOqOEOftVzjC1zCVEus8El6CZ1EFZ1HjBj4YX2whjddTiLYj5Dl56cVWO/2OiTgTzZMXxNRjMsHBzg4ctb53aQkbQihx0IyoabSw58kqJeirxXgKYMIBGjGrfpciSbVIDs7sYZkODrLx834ElpRjcbVCTVlThYtM5Sf81bEZ95by2ykK7EhaBif+nmZ8MKip5NGUiSDW8BWpquFAa2x/5JAXjPCsN78dlETr7+NBdNNNYFioDEDR5/aJpb//RCwLefdJ5b2nCOKH1nAjcgniZkQ8Mj/X/dUofk7wKPta6lW6by3lFCKXqmHRIq/w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc19050f-5804-4bc5-0ae1-08de1c8b64c2
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 16:50:15.1725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7pxntg966mvzU69UxfeKHPR+RkTBtwLw0vZ57hJdFG/Q8t5+FEMBHe6fOIKLZIp/0R60NsBiquJj+UeKLYgHPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7990
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-05_06,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511050130
X-Proofpoint-GUID: UCdKYKui0fqTFSZTsz6CMFKWS4T32TzP
X-Proofpoint-ORIG-GUID: UCdKYKui0fqTFSZTsz6CMFKWS4T32TzP
X-Authority-Analysis: v=2.4 cv=UpJu9uwB c=1 sm=1 tr=0 ts=690b804c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=zNZbKVpC2hN6LRerZukA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDEyNCBTYWx0ZWRfX3Jtw04JscnbA
 TIhzca7+uBKKS55+Bx63Z1ZzfelmeitaOycLEAozXP1e6ayTu4e5kI40SEAj0gM+fKqYtvaPuzr
 lxH1mLAZGt2qRytwG4v9JGQ7a81CgVtzrD9DLfoij8rrhd6bRTA2gvnYTute0aKTeXQQ4yVCN44
 RSlZONipereNvnoGk8TSxDDapfrZJnkdXcnjO6hBBs5Vo3sU8RuqPJFHMdfUzFLoszcRva0MoT/
 NlvYBkrB0/LbiAWitF2sWOF3DK0oqdIJwuhVbKJdveUwJZtEhtafg6G7viMrcVtbgGp0AxlbhE5
 AEWBStw2GAQwHHelc4l7KxbxTUD3yJ7F9lTOxt4tq0TwhlDX4Uv2yhQmosfZ86rvpisyGprXYBR
 rUoo8uuG+Y7PiwHESNdsWEQFUpq8IA==

On 05/11/2025 15:00, Mikulas Patocka wrote:
> 
> 
> On Wed, 5 Nov 2025, John Garry wrote:
> 
>> This small series enables atomic writes support for dm-crypt.
>>
>> Apart from setting DM_TARGET_ATOMIC_WRITES flag, we need to make the
>> following changes:
>> - limit atomic write size to dm-crypt max write size
>> - BUG_ON() any partial completions for when REQ_ATOMIC is set
>>
>> John Garry (2):
>>    dm: BUG on REQ_ATOMIC in dm_accept_partial_bio()
>>    dm-crypt: enable DM_TARGET_ATOMIC_WRITES
>>
>>   drivers/md/dm-crypt.c | 21 +++++++++++++++++++--
>>   drivers/md/dm.c       |  5 +++--
>>   2 files changed, 22 insertions(+), 4 deletions(-)
>>
>> -- 
>> 2.43.5
> 

Hi Mikulas,

> 
> Thanks for the patches, I reworked them a bit.
> 
> Regarding the first patch - note that the device mapper stack may be
> arbitrarily reconfigured, so it is possible that REQ_ATOMIC bio may be
> sent to a target that doesn't support atomic writes - and this could
> trigger the "BUG_ON(bio->bi_opf & REQ_ATOMIC);".

When reconfigured, the dm device request queue limits are re-evaluated, 
right?

> 
> So, we need to reject atomic bios to targets that don't support them.
> 
> Regarding the second patch - max_write_size and
> DM_CRYPT_DEFAULT_MAX_WRITE_SIZE is a performance hint that may be set
> arbitrarily by the user (it was added after we discovered that too long
> bios would not paralellize compression/decompression and it caused
> performance regression) - so it shouldn't restrict the size of atomic
> bios. 

oh, if it's a performance hint, then we can avoid splitting for atomic 
writes.

> The size of atomic bios should be restricted to "BIO_MAX_VECS <<
> PAGE_SHIFT" - that is the hard limit.
> 
> dm-crypt already has logic to not split writes if ti->emulate_zone_append
> is true - so I joined this logic with the REQ_ATOMIC logic.
> 
> I'll send updated patches, please test them.
> 

Thanks,
John
