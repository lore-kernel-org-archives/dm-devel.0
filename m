Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68E22253FF
	for <dm-devel@lists.linux.dev>; Fri, 20 Jun 2025 11:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750419331; cv=fail; b=ntQJZJHj096+03JxzU/zLzG7vzkBNsgm6rjcFaFhr/1yw/XFmm3eBMCjgnLA8lycIEk8UcKTgrRE2/Lxhr4NB7f9JllnhaIDrZrq3zrllvADSU46SNc6hI+4O/u8oq5dTQnT7+hn0YGkob23pC32x9q9+acXhltWsgw717i/mQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750419331; c=relaxed/simple;
	bh=i0HNpKk8+B1tYmhqORup236KdKMngFeGMRQleY3hucg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D+uCOREYFPCKIMl48UWl3wq5S50Fyt5kekudcuWN22HICsE/AI50mVh648ePn0mWxBVz8v3phfC3p6zUrJW9hp9FNYW2NcNvyjo62CHgTIpGKtRg2+GDFLuS408zQCyNafHtCYcrUc/XLaIhzEF9VA/qd6FGys+8wYCHGckJbOo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MZoUwByq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aUz8SM4y; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MZoUwByq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aUz8SM4y"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55K7fdIi023111;
	Fri, 20 Jun 2025 11:35:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=45OU25aWxCF7jmJjhac4Ii5JRMbeUsdRmYZ03qFBDkQ=; b=
	MZoUwByqlJodH8DwrE13sFTFh0fcwxSFQujxErJso4BTwUWj+7u5GL4f5jfJEDy+
	/FVFDDvCPPPOXdJfoisrvz8Gtz8QJHo8gSTsSKP+dXbjYUZSy4wexTf21nSWZGfC
	B3geH4pDz0YX0IURjUs0ewS172B2xQL+bBIv++scwoxwZFYdvx+Mqe5zN0Rpn+B4
	O4WFk9D+hfJdHKDUIAwVqt4mwCVWGQ11hiPAalEPqddUx4Wqk2SE8SCwMuwG2Du8
	vvNmy1kpum1d8PH5gdzebuuSkujkxk3XaAP67sSVTWztJXVXxp+38Ik1sIdhh201
	CB5O8EG/duUDE+ATm2YLUA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 478yp4uhew-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 11:35:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55K9S585038549;
	Fri, 20 Jun 2025 11:35:12 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2057.outbound.protection.outlook.com [40.107.236.57])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yhcu0vg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 11:35:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iHkwEcM7yPj3Hdq6m2y/KOGr+fPYAd7Z20EpxlkZOmqnwBkkZS8k46IPnVuwHu8PzpUtcY24dTUJNz24/N80bvqH+EC8+B1SYTe+bqS3JEAQIhwjnZk6W1azXAPFkaZGcFZkeyJ5a2KgAmSXMlNaZ3dikBDg6fNlAWUTqPlvBAH+F1DlwIWWTnC96QXBke2hF+YiL5isvg9fZFw8kiGWxcXj5Ge3hu7pP9QxJ4/mkCCeJ4eRSDK8QuAHclrRNKftMOl/Ad6HRo9dvkY487PND1vmviP+TexYh2V1hRpzB/5lcG+d5CCtCrjTe00JrWIKqyeBpSF0if7M9cwkdtxs2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=45OU25aWxCF7jmJjhac4Ii5JRMbeUsdRmYZ03qFBDkQ=;
 b=btcEvPs1kgUBkovNgYxEOQHof5IiautnSvGiYM3l9+JYf8MBknhErHRVXO5kepPj1Ph82mIdvdTKVqrfDltafVH507gzsL1lMKu1eMvOeYywUwdu3YU2yeYJpN7uTs5l9fC1lk+HsGs5v8BYL+I82C+iarI0oT8JUqb3jMpHjJEframdYFJ1fp0uk+Vp5oxZp8FRAzqArH1K99g9heZ0GcuwPIEzMNrmVloow1sBSG1XPu84szc/2dBnjM6hPSfZq55BHeS9Bwj1ZridvkdWnGQeAsHmrWyKFb5xAM6akqkZ+ud4GykMTcxoVCDUPTvqiRYzfyKczBwxQGrHh+0z3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45OU25aWxCF7jmJjhac4Ii5JRMbeUsdRmYZ03qFBDkQ=;
 b=aUz8SM4ya4RnNaz2wdK/8ywU31EGFMtdMbg3L0xGTqfKWdrAcn1rbmLAXIoapP/y+jpoWUVYNuh53YyTqBbU1S/eoN1hWLi+uk7QvhkiqP5gj2FjIjt2Qbc8jGi8+51qOywIOuftxCoQ0DGjl/u+wqGd+HOYAtXRRyHfc5MBdt0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB8102.namprd10.prod.outlook.com (2603:10b6:8:202::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Fri, 20 Jun
 2025 11:35:10 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8857.022; Fri, 20 Jun 2025
 11:35:10 +0000
Message-ID: <98c7b752-5d09-46b0-b137-5843523f3ddf@oracle.com>
Date: Fri, 20 Jun 2025 12:35:04 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] block: use chunk_sectors when evaluating stacked
 atomic write limits
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com
References: <20250618083737.4084373-1-john.g.garry@oracle.com>
 <20250618083737.4084373-6-john.g.garry@oracle.com>
 <yq1tt4bt9y5.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <yq1tt4bt9y5.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0189.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::14) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB8102:EE_
X-MS-Office365-Filtering-Correlation-Id: cb706326-3220-4156-8838-08ddafee8347
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aDJDY1pwcEw2ZitBd2VPRTdaRjJaaWlvaEx1eW8yOWdiK3dBcjcwWWtSNDE4?=
 =?utf-8?B?eG1oVEp1MUgzQWNTVlZJSDBDYnZyYjJoVXhPVThDaE51alB0d29seXhPdWtM?=
 =?utf-8?B?OTRkNjVqL0dUYURtUjdCZ2JmdE42UThFY1VqWkJVRHAzZW1NaWw5ZWxCYllk?=
 =?utf-8?B?QnlSV3FGNHNrK1pwTXpyTWQwb3p1QUZjRjM2UzZjWWlWNkVrSDFwV0FINDVz?=
 =?utf-8?B?ZEhZVDlWWlhFaDI4TzBiOFFXVUtnMXZtK2VnbHgzNkVPcWFENkVvMmUxKzhh?=
 =?utf-8?B?TExIQnAyMk9GM1RxMHNCYWpiM1EyUmR6OXVtVTNOZi94aFBPR2YzODNOV3N0?=
 =?utf-8?B?T3gzc1oweUEzMEhmbmNFaEtuRWp0S0krOEhWbEZxcGNvSngvOG9wVW50eDZp?=
 =?utf-8?B?bGxWdkR4YWZYd3V1RmRBQ1Z6M1B3Y05nWVJFMTErbkJuUDBOMy8wT2hwZVdU?=
 =?utf-8?B?a0VTVnE1QUV0aVloRUJhU3NxZ1VxWjBCaW9UWUw3T0kzbEFBNGFkaUxPWmlq?=
 =?utf-8?B?ZEFjd2I2d0ZYY0R0VUZIdEFsekNFYkFUZkpteW5pNkZVS0UzYlBZZng2dHRS?=
 =?utf-8?B?a1h0eFNoYkF3SGxadE1OcGt6bXNBU0JyNnRIRGJkQ1pEekRZK2lrU3RCeVhW?=
 =?utf-8?B?VHhjejkzdWdJTEgwMjU5M0diNzJmOG4rVlh5TVdmT0dzamVSb05DS25JbHJT?=
 =?utf-8?B?eGozNlJ1MWdnTWVGN0xQUkIwbzhxMHEwTStqTFNkQW9iWnRtK0VUWGdCdno1?=
 =?utf-8?B?aHAydGJSd0h0a2U0OTFyenFaRkVMRmxMQlFkbXRyeUNxMVlFd09ZdnhHOEZZ?=
 =?utf-8?B?bWluWDVHeFFBOXJnSVgvR1JZS043a3Q4d3JXWVFHWHFJclhPQzlieFhHaUZx?=
 =?utf-8?B?dEMzeWRGSC9HUlZZTU1oMXg1REM4ZjhaVS9hcnhWT1g5ME9VN0ZHU05BbkFB?=
 =?utf-8?B?NUtwWmVyYmgxVXBqQXliakxxSUswSThzM3M0QlhUekxlcTVIazM2TU5xN0d6?=
 =?utf-8?B?cTFBbDBaZWFOWUZoSjNDeXpvOXByaTllYnFhbW1qaXhNT0d6TVRCYVRoc1hn?=
 =?utf-8?B?NVpteFZUbS9oWlpHNS8yZ25vc1VTRlhHOVE2RTNJU2tRL1dUYnNyb2ZvQjc0?=
 =?utf-8?B?RHZBcjRWUG53TENIM2czODlvc2pUZGhZUUpiRGtnR0RMb2R5RTlDckhiS29L?=
 =?utf-8?B?MjRLY25tLzVMSjhPUWZKajFyK3k1V3JKb3EvSXFwY3VPMlMyRUlKc1ZJaDR4?=
 =?utf-8?B?OStPNUpSY1pkZGVDcTZMME52a1JBbTZjd2tYeS9iajdzWWpFWjcvbDRhbFUy?=
 =?utf-8?B?Q09QTDIrU1R6ci9RS0F3UGtZdmxRYVJ1UTZTZG1XbTQxd0ozNUgvRkUyNk95?=
 =?utf-8?B?ZlpSUVh6SFJhMmtZeUsxeDlBbEVVaTg1cUNqRjZBRUxSVVhJSXIwMEwwNGFZ?=
 =?utf-8?B?cjBpblZiZWVhSE5UZERHaFBDa2lxaXY0MDdDSVZIbGlnNjBRaHlIaTR6d0RU?=
 =?utf-8?B?UUpUK0VNT1Z6U21UcllkeWN1MHZWajNBTkRIenoyVkJ0K3NaTTZ2WHhyS2Ra?=
 =?utf-8?B?Q0RnVlJpNmZVQU0yeEJ3UnFnK1dBVGJWVzRnc3dKSit5eHFSeFRKK3lTM1I5?=
 =?utf-8?B?dWdWOXpUL2hwSDl2dzg2RWRKYjl3TmVXTmtvRDExb1B1VFJqY3YweE12elZh?=
 =?utf-8?B?ZFdJLzVvemJJckExTnh4OHhXK3Z2MFFSWllISzRYUTFZMkRrcEFLMmo4RXZ4?=
 =?utf-8?B?bG5vOVRkNG0xZUsyd3AwYU1JVytpTUY3NnNmdlphSzhPdmprTkJNQ2FSbjFx?=
 =?utf-8?B?blNjMWsrL2R6VzcvcElUVTRYREZtbnNGZkFHcE04d1lsNndrU1N2M3ZMT3Z2?=
 =?utf-8?B?ZWJ3YjRrSzB2cXhlVTFOUlBabjF5YXQ5ZzlKR3AvcXIwUTR0Sm80UEpyY1k1?=
 =?utf-8?Q?b6X4eT9gAPU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YU1NakZPV1ZQS29sWEJZbjFQMjlMOGZwZ3dEM1U1cTNmY2hjckVJN2xMOHp0?=
 =?utf-8?B?aFdtWGYyWGtOYTlnNm51bWJGVHNjVUFrSjVUUnBRc2ZTbjY3WEVackwxMm9Q?=
 =?utf-8?B?NkFIL092SlBhQ1poSlovK3ZidVNVd0lPM2xtQUlZUGZVL0xQc2MyOE9BUFRN?=
 =?utf-8?B?N3JIcGdHZDJURTlyZjhFNzVNRFFiNGV6YUh4QXliZlF6RVBWa1R5b2ZnbE1y?=
 =?utf-8?B?ZWVaSktIKytEYStNRDk3ZzExdzA5S2NCUGovVTh6QndKQ1pWVnNhOFcwVFlG?=
 =?utf-8?B?aWMwbk5FTmVLVnBzSHFXNDlCSkJ6N2JNS01qa1h2K3U0Zll5UTlsWTg3L1B3?=
 =?utf-8?B?a0k1eWc2S2Y0R3B6Wm4vais5WWw3T2NWdDUyS2V4d3M5Z0xERVRod0hhQkEw?=
 =?utf-8?B?ZnZFTFFjemZRL0Z4bmZxWHU3UDV2TGd0RVNGV0pJdGNHOWF4Z3lTc2FlcEts?=
 =?utf-8?B?MXZLODdmWlJ3WWlTa3c0aDVyYW43L0RYN1g1anNtdGNNVzZxUjR1M0lDUXNx?=
 =?utf-8?B?NVllMTYveDVmdmVJY1RvR0pmSjFscXpMZEZSdFFqcENxc1Q3T1VCZjB5RFZV?=
 =?utf-8?B?dzR6N3FodWlBbnlkMHQ5cXFoK2dQZE9BRTJYMldFWEZtTm91QVlkQU5BcGZs?=
 =?utf-8?B?VGZzKzJzNDlpeUhlNk5TZWtCZk5wM1J4cElITWJhaGl2a1NhMHhYYzFzL2Jj?=
 =?utf-8?B?T0o3RkdLZS9kMjRZODFtS1lEazNNMk9xUHJLM09Oa1hwWDZsaE85Sks5bFZS?=
 =?utf-8?B?QUdMbTBVbkJObVF0V2VHWk1HcTVzbmhrQUJYaEZ3dklGUE5SNFo2YThLNUlV?=
 =?utf-8?B?OW5lNFk4cjU2QTdrVEFxREZnclN1bmx1WjdEOEt1VGhhdVRBS3pCL1VDUzE0?=
 =?utf-8?B?RCtIN3Fram9HWVRGZ2k1cjNlc3oyVVF4SGZZWnZyc0JpTHZSR1dadW5IQ1FG?=
 =?utf-8?B?T1dIUUNUMGdXYkM3L2F0N0d3WG92VWFIVEpjVmFwbkhYNnlGTGpYczZrUkIx?=
 =?utf-8?B?LzlkcTdLSGJORjRjbFRrV1ArQXJHb2h6TmVPNFhIVWtkVVdvZ2hUMWZoMU41?=
 =?utf-8?B?R2JQcXZRUThMTGFqV2pVMEpvT1N6R004bDNXN0l0L09ISzBGT0wxeTVsa3pQ?=
 =?utf-8?B?TVBmbUJtclVham5MUnFydmZsKzR4MGlqZ1RKVkQ0R0NqK3ludHE2UXNsVDBr?=
 =?utf-8?B?OVBLTm5hckNSNE1Ia0s1L1RHUTg4enF2YnpzdmsxbklWbmdmem8vbFowSUxU?=
 =?utf-8?B?U0dWM3MvdnBVQTlYR1hnMTA3MHZ3Ny9VTkZSL0htQUMwaWpsN2FZeWZmUnZi?=
 =?utf-8?B?NXBEQllBd2FFQ2RmdjZGVUhIeHo2YUluM2dmVE43MGJ3ZXl4aTFmOG5udVgy?=
 =?utf-8?B?bjBlR25KbElqZ00zQTBGSWZmcHN0eWtUMmQ1NVlxUzE5eFN0U1EvR3JxYXkv?=
 =?utf-8?B?aGRZU1d0STlZMDZjalNiVXZZUlNZSVBpbkdHRVVYQW4xeVNzQWlXcHMxSUtF?=
 =?utf-8?B?M0s3bTNHWldwbXRWKzloejNPZFEzRE5uUEJBNTd3TGJrWUx5djZFUU44SkJj?=
 =?utf-8?B?bUVyTG1YQkQyUW5seHRVVGhieHpTNWlOaHEzczdYVnJJM3VKK2UxWU16Zm1m?=
 =?utf-8?B?a1NJYlU5SVdFamdwMHBUYmh1OTJ6S2JKK1Y1M2U3OEpmemQzR0t2RDF6ZGVV?=
 =?utf-8?B?eFdhUlhadm1lcjJrUjNGYStoc0JCV2VxUGxseWhRNG9ySU05WHJaTnU5YXF1?=
 =?utf-8?B?ZmhFS2lReUl1YUF4NGxhK2cyTkpsaGlLaE52TzFWSHJnajZIaHpMMlpTUEhW?=
 =?utf-8?B?dU5Gay9uSEJGblB3bVlPTGRXcStMak1oTHBoei93TWo2bHdqSWkzQmVqR05x?=
 =?utf-8?B?T2VaQ3k2MnkrRUxIWWlSOWlYK0F2OUloazZFZFZLRWdFRVJXbWpNS0M0clRk?=
 =?utf-8?B?MTB1bGdybDZJSXVpOWtYMSsvUS9qN2l6UDFjZ0diMXdkRjJMNW5iWFoyOHlG?=
 =?utf-8?B?R0pKT3FPZ0toN1V0QUFPSHNpZ2p6SGVmUlZIYytVQU9zMTVDSUVIUVBIVnVX?=
 =?utf-8?B?NFdlbzN3ZHdnalIzSitRL0ZmbnNTWG4vcGZxUXpqSHpYSkEwYmdtOVM3UG1K?=
 =?utf-8?B?UVlsYjhUZ1h1dWxSMjF1OXpuNy8zWjRaM2dac29DcDNwRUhoMXFVZVp0aE50?=
 =?utf-8?B?bVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hmWULIJPsQCvP2liOcxFE84DHoU8BdRf1oP3XV4tVUiLoDn2sGJBBHPPcuPzjWnuNia6Ehb+40DFOThq9Q+U5NKLcgMi+3yOmSffQlrErVDmjmFMx6Pi7Bf8EZsyF31+gXFgZTFhkumBwXRSnZoVB8LBnKE3OzBTzZI0DiqKA3m9SbPBe2fTjL+1L0ijPlzmSXjC5425SsL6y15hZXFVQV/WqHK+Kh58ji/LwjP+drEKWGjVdLuISz38NaOjdONO54hhpsBDI3wykFsD2HCHl82zqlT3mq9Pyrd6TQBGpO2mg948a1lkmnlgUly2AvJz5Q3seOAmA1647blE/7NwbfRJdI/AmkN6w3MTuObRmtafsLjk5gKd6JakT83KWHMZMhAXLbEmYEDPNoAzc9yDUQlWOxN5I7CS4JhYeVU9/ITa4bUYsEh2OpE3Pn69XAqBD1nziB6hyXpt8xEW/3yv1Y9/1u5hzqVCyji7RS8T/p+GAD9fTiT4jaxZi2obD5vH3bd26F5TipxlGfBTcqIV7riOGv4HsH4otSrm37kcSqOaMxf0989E28aQCO+keMCsQX3GO11NMAIkfFosiSheMh5+fHZK9UvSKrjI/g+ANgM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb706326-3220-4156-8838-08ddafee8347
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2025 11:35:09.9527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JlLwrxJvUuWYR2T+zZWGlvYZ8IEdsHLwOh5yPluF49OwK2bCFgUt3nsVPSBTDsJIna30inEWeeFVA9+nOkHJyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8102
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-20_04,2025-06-18_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506200084
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIwMDA4MyBTYWx0ZWRfX3phQ/SO3B8co dZiMl47/6tlvF6rN3dhD9dN7F+T+SJ5MOrXaMkbPDndnCmMe2v5QluoEYX3mKlC91XzgHhqlMgo cBOWDHziJoXHZwBVsI8Hn5mwo8akoiJCzzUwcey8XmjvjL+QewDpUAliIvlkaO424rIifWz5vkK
 o1o09aKpWRhat1iFgcH/eEg1tpEPZGXfHSV3nIyfSO/Lytije0uXdHnj5R4/CpM1bqfbA4bd3Mv eJT8+XBN+dQTPyfgVKGQ06CkvGMU7WOBAzDCIO6mPcFpkecklyaBAIv2H3cFeRyq6q57fGXb3Fy esHW3/RSHeVWk7hY7iA8Uby6Ag+stUu7H1J2SUMHNOlJL6JrqYQXWkXqL98nr98GH8ipiO635F0
 rPs5AxC+MgYDoisXAklB4gmM8Cnup69CMR0oJUDj8lJ+8iuwA9vb/J+k5xDGc4U/ySyV0vFK
X-Authority-Analysis: v=2.4 cv=K5EiHzWI c=1 sm=1 tr=0 ts=68554771 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=nQR27uK35VafCFBPkXcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10 cc=ntf awl=host:13206
X-Proofpoint-GUID: JZYuTDCnZYMyzDhbFZX7oRDkLub6lU3x
X-Proofpoint-ORIG-GUID: JZYuTDCnZYMyzDhbFZX7oRDkLub6lU3x

On 20/06/2025 03:40, Martin K. Petersen wrote:
>> Furthermore, io_min may be mutated when stacking devices, and this
>> makes it a poor candidate to hold the stripe size. Such an example (of
>> when io_min may change) would be when the io_min is less than the
>> physical block size.
> io_min is not allowed to be smaller than the physical_block_size. How
> did we end up violating that requirement?
> 
>    logical_block_size <= physical_block_size <= io_min <= io_opt

I should have been a bit less ambiguous in my words.

I meant that if we try to set the stacked device io_min (from the stripe 
size) less than the bottom device phys block size, then this leads to 
the stacked device io_min being set to the bottom device phys block 
size. That's what I mean by mutating. And that's why it's a bad idea to 
assume that the stripe size is in io_min.

Having said that, we should probably reject this even being allowed – we 
should not have physical blocks straddling stripes.

