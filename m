Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AD425A658
	for <dm-devel@lists.linux.dev>; Mon, 27 Jan 2025 15:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737991422; cv=fail; b=fl/0vu8W6uxO54HSS8bw1h1E0J0JX73zIfoX1WEkvI8v3aIjoGFetmrAFadhXM+Twd8WB5rnczhg3XVsPzW4nfi//nvzkXAnG0DKXya4bW1Y29xWkJZNe/WxJEV5j6svuMrguWm5niF5y7YWa/a/NVbCI+AlujM8yA/BTqF8UmM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737991422; c=relaxed/simple;
	bh=zWPRwQVcNRQjT+ojlEKoXFxb2pRfkL7JBM49J0CtkmA=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r7a/x+cHLD6WdUQqR6vMZGgaJqm1ys9LtzgIAm2syhXqo9A40HnwyggSl6uGIRem4QWCvyxBx4IJeVl8IzZ3ajlhqJwRcYCS6yQnqqT44KsiOQsLrLR2XCnteHnxsaz6tbDQBcc74wu07MrvBvgHRbzDx3sS/ZMuIhTzUzqUXhs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZBMgxl+R; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Qs3mP1Tp; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZBMgxl+R";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Qs3mP1Tp"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50REVl2i000835;
	Mon, 27 Jan 2025 15:23:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=oZPOhqWICSz950vb1NYUNs83akpT1K6X2cFVLsXa79o=; b=
	ZBMgxl+RMiTUOkkFIn51IloYwYaaQoA4819hveEy9gGb1cnbF8yRg6kBs2vZ6zSe
	QiT7GfSWbzWOr6ws1iEP1Ec8r/vzS0oqyp1AXIhvBFUudSFrInxwH0PyUakV9h7v
	UFbVNn67ivhZM59rXYOOXBfYRyzhFTVtmSIpeNYHWUK42UFzHO9nIoAZtT4Mu4Ec
	U6ycoH5ChpCMI05hnUK4x0PGIcFQvVK9NaEN4Q/twNBH1uNssU/J4cgnSNew9uCZ
	kgDAIKq4KPd8b8FXog7SWKOd7cHv+sgRsTbv1e7OH4lkW5E1TBFNmmzEAmTpvo4o
	q8DIyg0COXp8QE2ZV3ejLw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44ec00g4ab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 15:23:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50RF2G6c036395;
	Mon, 27 Jan 2025 15:23:38 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44cpd72s6p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 15:23:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lV5Ppc6eP86Lw5WLws8FBn4QSGscfxa7ni6XiATS3NfABDkCd7Q9flvMClDLfnqHkpperuUvm6//5ZL1nOrSIj5VS0r4J+groLkvwjQBJTaa+f0wr4jjF7IRnxdHzA879XBvGW/c9OVzC0xZsF1Nm3fGFdeChlL6mb77btHf3ZyGQ61CZcug/tj2ij3sTrO/hqT6zKmRONaV8xhQ7BaI9HKYBVdFzYoZSAQqgh89QmAwnpurpEjjn5aCBQ5G1sSZDzsjpK4kQe0gv+tHHnHtrX70izIJe4PVg8Mx/5Izv929q/Pg7qNO8ZWTtv+oQsO0ZmbDd4xLeaVBakPbkxtv5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oZPOhqWICSz950vb1NYUNs83akpT1K6X2cFVLsXa79o=;
 b=Fvf6yOjYjm2/0yDBhe9KeeF7VZ6JBiphwTpjgmEHTRjt1vFrcCkEYq4yWb20JEbUZvsYcIHsIXkWOjGP8B+GcY8EglIh8TU2PA7AeAnVa2JggCEkKHlwcAhVcuIpOcLs2FFIxpBMatvKa64uq6drLr5LA4BZIF+KL2+24918iL0phehtJJG19NISl/NbVL/979BzdpaOJfLSZlLWnqFV7EkSEvUFGRFeVfjrhaz4RYUiio+r6veS8aYSVKp0uyyUClurhbOtlJxB3AF3HmUAwjFlj24f26KythtZFk4YJN8EVGdrYMBH0Gf4YrfspPzDD+PI2TYNen+cBGSRWl7EEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZPOhqWICSz950vb1NYUNs83akpT1K6X2cFVLsXa79o=;
 b=Qs3mP1Tpgan1dAVAGHPq9lA8fJASFH9z3G9mSlpJ55jYY0wtzmiWkTRH6NyBIu6XgAld8MBLOgwUckVfLbrbnfS467YNcRp4atmXmsoJ0KmG7UCID4br6m5gse5iVUtOdbpklJH3gG0EHTVHwJzizwrH53XSmrFNL8b8v5IHYWs=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB6824.namprd10.prod.outlook.com (2603:10b6:8:11f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.22; Mon, 27 Jan
 2025 15:23:10 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8377.021; Mon, 27 Jan 2025
 15:23:10 +0000
Message-ID: <d5dc7055-fb76-4f91-99c0-90a45646b98a@oracle.com>
Date: Mon, 27 Jan 2025 15:23:08 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] dm vdo: use a short static string for thread name
 prefix
To: Matthew Sakai <msakai@redhat.com>, dm-devel@lists.linux.dev
References: <ba07663c444baf7dfe539f41f9cb088354af4106.1737584895.git.msakai@redhat.com>
 <3be87d52-2e0f-494e-8583-a80680b0a4ec@oracle.com>
 <2a01b7d3-5463-4638-84e6-5ab56fb64685@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <2a01b7d3-5463-4638-84e6-5ab56fb64685@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0010.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:ba::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB6824:EE_
X-MS-Office365-Filtering-Correlation-Id: 75ced39b-135c-4a74-83bc-08dd3ee6822a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RC9FczcxQnFHYWI1YkhHdld2R2sydGFab3FTWUZCKy9hNk91TzNLQ3NIZ25P?=
 =?utf-8?B?akliazVteEZ5RzlFYktoaXFIYkVTVUxZTDJsODdqYTdwYWU4K0pKNGNOdy9o?=
 =?utf-8?B?a2M3dTFQeGxJcTFwdmxtL0o3ZzhCemZDU2VaUEUvM1JVTDU3S0NVdzBCcXVL?=
 =?utf-8?B?Tm9DZURrYmRYZzdlT0FvcUhObm1FWEpPampxb0YyVEt3bTVlNjd1a0J6VGtI?=
 =?utf-8?B?RmZ4N2FWNERhSmo2bGtDcFBoRi9tUGRsK1VUTjROWVhmTGxhUVhyVEd2Nm5w?=
 =?utf-8?B?RWxEelVMVWpBTnJ0R09YbmxPb1lCTkVZbzBBTUwyb1FLQnpUaEJUTzB0Y3lz?=
 =?utf-8?B?Mm5aQ05pTHVOaGcrdjhvT0x1L3ROQXQwSFRnZFVCODFyOE8velpKN2orajhW?=
 =?utf-8?B?am84Ly9HUUpQL201SVM3cFlFNXZhK1RsbGNjVkZkazlqMEQyQWkvOVhySHBU?=
 =?utf-8?B?eithb2JqZG5KR0o2OE5qWFNvQjY0RjNQcVBjNXlWY2VyQkE0UlJMSXJIT2xX?=
 =?utf-8?B?L01Ta0hFbVRiVUFxNHFtekUvRnlXd3FqdXliMUJDQnV4WU1vYld4RC8rb0d4?=
 =?utf-8?B?WHlWSzZBZDhNUFBrWDRlVzJKQUFwVHJvYW1PZDdRdDd5K2hMUGpjQnA5WE95?=
 =?utf-8?B?ZjhSQlVEUU56K016a3FPWUs0YWo2T0dkRWdaU2hzZEJpTGZPWEN6VmI0RVFQ?=
 =?utf-8?B?ZGFlMm1UQStBb0JLejJyTG4xTTdaMkdXSUc3TE5sUzVYeUhmbHRkWENTZWRG?=
 =?utf-8?B?NnFCZXUzUFFScyt1c2NxM0RpZzZ2dkpZcnF2b0N5MExpdHVtd2hxQ1hPZVQ4?=
 =?utf-8?B?U1REOUNRb2ptK1Z6NVlieUtQellja2dqVFBJSWZTQ25GMkJRUkpWQWVTZTlY?=
 =?utf-8?B?Ujhnb1E0NUlTL0FUSXNjNlpVR3lsMmtHTVNHSW10OTBHL0YxTXdWSnNKOEI4?=
 =?utf-8?B?MHZEYkpWQVZJdjNUdnpvb013TVJTbW0xUUcrOVl1TTVXVDRkKy9MdjhHZDA1?=
 =?utf-8?B?dGlhRjRESWVqSHlSRzNsZFdLTWh2NXNyYXppQ2VJYkQyZ0JiNFp5VEIyQk96?=
 =?utf-8?B?c3BOL0hXaXpFVzlrTnE2UlB3cjZHOCtqTTcrSm1rVXVXOTk2NWNhcnJtK09G?=
 =?utf-8?B?REtpUnVtRGNSZ1BtQ1dmanFLaHhid3BRZ0MzY0ZrcUdtL3V5aUpPU2pBcjlu?=
 =?utf-8?B?VnZZYnRPSWozaEpiS0t3dElrcExnNlpPNHFVZnM5TExSKzBIQ29ZaEhHejBa?=
 =?utf-8?B?eVczSU5BZkNGdlhiemhkUWNtd2ppem1VZmlzdHFkWWRWWEQ2SEFVWWl5MTNE?=
 =?utf-8?B?eFovenlNR3JmcFA0OTEzeGl0enViMXRjRmhpUFNTZnk2OE5zSkc1OHBTOFU0?=
 =?utf-8?B?SEhNUW9UU2ZPRWxuV1lUWXNOc1ZUVjJRcWl6TUU1TFdmWnNRczVMeVZTUTY0?=
 =?utf-8?B?TjZ0SXNqNXlmQ0VWNnVhcTF1am9uRS9xWjUyQnhuTWVpWitjbFZTVGl6MEQ5?=
 =?utf-8?B?UHZWcFpjL1M3TVRBU2kvcGR6RHovSzB5VElybjFydThZSElqNWRDaWp5ZjVJ?=
 =?utf-8?B?RXJhTlR1ZWFnTUUwLzNFelZLOEg2SE93SncySUlJdlJCa3pFUVNIMm94VEtY?=
 =?utf-8?B?M0RMblpJVkluODZGNk01N21YTU1BVmFibUJ0bFpXWGZJdVZBK3R2TWFuZXh6?=
 =?utf-8?B?aFdsK0V1V2MwR3VaZU0wTW5VNG9uUW9vRkRhelR4YzJvalFrSmd1ai92My85?=
 =?utf-8?B?cXhpTmhMUDZtNFM3ekRhTmZPdHBQTU9MeDlUb20yd3F0TzQvanJaYXB4OUQy?=
 =?utf-8?B?L0hmUWxkZUdMWEVmeE1IZ2JtbkVhQmNPeXJtcWxBTUplajIzU1BWdnpTcnph?=
 =?utf-8?Q?vCDsori/K5mFS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T3dGZ2ZUbVFKYkNxVkpySkxGTnVMRDMyeC9KN050ZlhudzE3dnBuR0hDa1J5?=
 =?utf-8?B?SkFMQlZEUjh4c1BPMEtyVnN5Mk9yOGNjeFdzU2FEdFc2dnJGSzVOMEdWdzI3?=
 =?utf-8?B?bUxKZVVQM0FqMis2L3QxUjJxRVFFcDFmWVlNOXhYd1hUTUdpVndiY1Rnclps?=
 =?utf-8?B?Q3ViN3Z5SWttK21rRHNRR2YwMkEzc0JhdFV4TXg1WEE3bXBySkw3aXZyQ2hi?=
 =?utf-8?B?SjhEL0JxaWdXaklzRi95SEtoQm8xTE9CdnBDNGhvWnE0cVFCY2xpd2o3Z2s1?=
 =?utf-8?B?M2FMU1B0bHBBNzR6REpxSzFLZjdXelE5eGZyTUkyRHBsNklpRytGL3M3Q1Ax?=
 =?utf-8?B?NHdLUTMvMzhNNGxUSVZSRUJQOStpVVQzcmdkVTZHMS9adlNLdkdLMm1Xdzdx?=
 =?utf-8?B?UEZxbGRDdDNiOVlRMzNxSFpsTXQvQzAzcVlXb2RwMGczUE11U3dCOU5XUGll?=
 =?utf-8?B?NDJpOHBIWlUwRWY3S2t1dzFqczREaUVIY25xaVB0YzBGV0FWQ3RiWkphUVZh?=
 =?utf-8?B?cnE2NDhrNFRHUm90eWY0MEk4eTI5LzJLem9CYXdFOXNvVmRBaExBYWtrczZU?=
 =?utf-8?B?dHViZXBiNjQ5VFc4MmR2NC9RUTVHZzg3NkFnUWZ5aVFlTHNjNCtSaDFuZkhu?=
 =?utf-8?B?Q0MxS21VQlQ5bzVRMHlTM2NaYnJXRHh5STF0MFZGL3VsQnV5eUFUT21RVXB5?=
 =?utf-8?B?bG9HZnpGaFNOTzZNWU9OcGtMRnFIZUo0RnZ2YS92V2pQbFN0RzFVMlFhb2pQ?=
 =?utf-8?B?eVpEcklvR1JVUWFtVVVpUXR2cnE5VE5pbWZtVytGandSUldjSWNTWW1rK1Iw?=
 =?utf-8?B?VFhpaW5ySE5LWGJmVkxqVzIxc01BdkZlbmdxa1UvNWEwSytSWENnS3BxdWw5?=
 =?utf-8?B?MkZISGU1UCtNNG5sazBoSkFyUXZvUXVSNVdiQ2ZxT083MFZSNTBZRDlmRWtC?=
 =?utf-8?B?M29tM2RWRWNyaUd6M3ppVzZDMkdRV2hyQXpmTEFHc3I3WnlNajA3T3V6clRa?=
 =?utf-8?B?Vzc0QUdoNzRicmgwNXc5TGVDNk1zem5ERFNmZ0ZDVTcxK2Y4UjBvejk2RWFN?=
 =?utf-8?B?R0dZL1ErU25CYzZJaWNlSnJzd0wzUktUa0ZBMytRMnZzL1BkbXQ5RWlWalhr?=
 =?utf-8?B?djN6WVVxa3pndGZtSjdQb0l6SDI4Q1RsUEFKVDNPOTlFQ3hCb0VJZjQ3Q0dr?=
 =?utf-8?B?R3pITGUvLzZaUzlzSnJwdisxZFVYOXk1WWNKanpaRmUvR04xdkNacTBKcmJi?=
 =?utf-8?B?Zk9tenI2K2l2c3c3bHpsZGwvQUFDTUNLMStNSm40S1ZoeHk5U01uWkcxWEVs?=
 =?utf-8?B?d3lzK2NiZXJxY1ovcFZLQnJ1LzJCcDBxZ2RyY3NYb0hyRVQ4WjEzaXNVR0Nx?=
 =?utf-8?B?QU8wWFZOM0JSWnJkN01sVHhLc0dIRnNBZkJqdEQ0Y25zM3dHZEd4WXRKR050?=
 =?utf-8?B?MnExc0c1aEZCSlNPWUd0QVg5d3hZaU5vZ2MvdlRNR1ZldkFmNnI3alJTQnVN?=
 =?utf-8?B?bENJK3owNWZ2dU9qQkwyekUwcGZNc1J5c2lGNEdsdUFEV3BRTnhrVWc1VE9M?=
 =?utf-8?B?S2hUcUxFUGZiN3ViMnBZZW9lZlBFK2YvOU52MlVXcjdXT3B2QWJoaUs4Yzdk?=
 =?utf-8?B?TDFRV29YbkUxMDRuclpxT1hxWW56aEt4NWYwT2IwVk5hUG1FdmFoOU5uL1A2?=
 =?utf-8?B?bjBXQVhrNDlMVnBqLzVkOVczTXY1UXNaRVl2NVpaWTl6WTlUa1A1U0FuaTIr?=
 =?utf-8?B?aUg4d2s0Y0Z4UGU2cTVNWGJ2MVV5TGlUZmxHeHNkMG95em96L2l0dm12M1BP?=
 =?utf-8?B?dUpLNFQzTHVtblAySW85cW96NHllQVU2SE9Od1Q3UUEyaElnNDJDSHBlSmFo?=
 =?utf-8?B?VjJlbENEb0k0VVVxYlFWdi9YeEllZ3g3L0lqOTFzYjlUTmZlbmJMRjc0aDFF?=
 =?utf-8?B?NUh4Nk0xWkQ1OU1TL1lST3FJb2VYSFNzRE12d29mQ2FTTEpTYkhhSmRIS0ZP?=
 =?utf-8?B?TkV0ejYrdGU0blpzV2o3dVJLSXdzbndtamtUZWtlSi92ZGhCSU9URnFodlYv?=
 =?utf-8?B?WlM0aUNEcXdlbkEzUDNmN245NkEvRVdwL2FIU2RNM1hrUFdSOHQ4dnZidHFQ?=
 =?utf-8?B?YytvcUlJVlptQ1NsckV1SmdWaXlLbW9iU0s5VXNJSVJNZmllcFFaa2VXMHpu?=
 =?utf-8?B?U3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nJLMZXgChlkEFPAdUbXRNDfup9VpkKlcfgkgSLCcdK0ZVg/PTheyvOPtCY7xTfYITTLtDlFI1htpNF9WXzAfNiauBHAjPRGvJqxdqOPwQRm/3KmZfPSPQVkP+wyqmRqDdB/ehBHYfP5Uze07fAaJpoacXyP/3eIcAgssuBHrEgZNKPx394EGGq4DyF93vKoMKQBLoyTfphbCHKQRPvcpNW3IE96br2B7+BlbWltoxD9jKUU6LuDny5fyIsphbMVwwTldMrQv8ltJVfQ7Wu1DfPp0ne+lJu4WB5bdorFBG/BYJjgrkoe4cbB5lH3s3U9VTtBbEerUQkDsBOGIUs2+9nuKxYqr+0ZEdzswZz9o0G/cATL+dKjAVoje9l2Wni1/od9ps33bMmqM0I6BiLXoQm7hE6ULA8ckd2XteGyOv2YZiJXLOExu+WnO6OK96LbDXNvgZVCDVSJ6eo7KgImKKzRO/ZmlF08ggHdDLvFvUrui8NqYcD42joN0S/iItJR5CE2u9fjn8NoZmqv5o5Wc3/lcAg/tFtryQX3rvq/bK4wrwTXbOwoRn7unWSEUVKB5vZotuQogHM9tWMObfXWZzl5DcBUs3xYt1F3sgJrR/tY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75ced39b-135c-4a74-83bc-08dd3ee6822a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2025 15:23:10.7833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xk36xfnTGZj0ZiMPM4t58qkW+5Aq+r3x/JJmZnRohRX3hI0elHFzNkpL7lx1CODcbBrVVCmLlk/3LfiVs5STSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6824
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-27_07,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501270123
X-Proofpoint-GUID: Vhlq-Lv0yXIaJDTpit_5klriRSaYVfO4
X-Proofpoint-ORIG-GUID: Vhlq-Lv0yXIaJDTpit_5klriRSaYVfO4

On 24/01/2025 19:26, Matthew Sakai wrote:
> It's not completely clear to me; does the Reviewed-by: tag supersede the 
> Reported-by: tag, or should I include both?

both is fine, I think

John
