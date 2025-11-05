Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C192749CB
	for <dm-devel@lists.linux.dev>; Wed,  5 Nov 2025 18:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762366451; cv=fail; b=NYoCQFI2CVebR/N1iwQUjkLvXddhAqXhaIEmd8jvh0K/8qbWJ5gsTqtpCWXhwvAhqxXYEzLYx12klCCATc24JfqTP5Q+QEJy2VzeM1K+PkaBhu9se4GMGeLqK4/SI6BI+CKoRm2fPmtZlBCW2JSMiYJTMWFLWIL3aRK431hA90U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762366451; c=relaxed/simple;
	bh=s8jIbHJDPat+cuKveIXN2FTwgvqo++PJLyCGCZvsWRY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cKmKKttZ5k7D3ySQxhGM9SO8st+rvrIhoGWm2OvDnSgJx+5ifLeLpX/Th17nSB83jjfHg7NThOiZNhtowqyYEJZIx6OEWSLkWMQkw/MyKnXhDEYhk0zzDBNPZmN+I08xPdh2KS1ATMh8v1a+vMp3rwcM5VdddKfgQEBlSnS/goM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lM5cLyZI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mBeVUpNn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lM5cLyZI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mBeVUpNn"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A5HdjSR017471;
	Wed, 5 Nov 2025 18:14:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=no2/WdOn5fxs7xyIWzcETkBFMVReJRnJZh/0Ax8b1Pg=; b=
	lM5cLyZIex7Mvmbj/P9Vw+L1mKveQH2cqGH7HLfIUcakVNSWT1CyyMOkQlCUKdwp
	Vy+cvrp6YCOr98ErnGaS+CaoS9JrPqpBdXIPLTTKESuyDOgotUkon7tjFxoCA6XB
	FrlRwbpFbDaSvCO1G0VaW41TzyePMeUterRP5XV84wt067RnXsc+LUscLjgSQUuC
	hu5XvTPlS95vvx1fI5se3I6J1OPvSSeF/jHAcVIzSCX8Ikj6Q5CEYOq1jEqySguz
	OO+7BMVKdgxSgYCWnXkcv623OWH4z7E33ul+Cy5dhe/i2AZOBzUwxiKRrFD4D/Ci
	0EugnchBGs0XVLY+xDX8Sg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8b5yr2ct-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 18:14:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A5I69gQ002656;
	Wed, 5 Nov 2025 18:14:03 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012013.outbound.protection.outlook.com [40.107.209.13])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58new345-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 18:14:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K+VRjakda0ez1fh3NVlWBfHErB38fI/ZUQ1U6NpszHIyInZnSSasSu/orqeOPfIFtZzkYJuVE9mLsqRJz340rE0KV/xqWI4eJRe7BYUg/JDzIRFrFrvRd6CdnIBVxlDPShzH/W+K8k2oKPD9FYFjgj1w826GvQWCDOaXlGDgEI0yf++F8lE2v9Q18a6h7gSn+ivCnkWHiplG79kNKqYhQ7WLwj0POn67Z5cjejqFi4t6fgg0jOEP7Zzi1gF267p3M3/I6A4RIcAHUhjaECJFtylcPunBNBNQv+dGIcfpooECt24rZFLLPlG6JYn4AbmTz34HtHQf7znPWLEQ48Pa2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=no2/WdOn5fxs7xyIWzcETkBFMVReJRnJZh/0Ax8b1Pg=;
 b=igt6CXAZm9Tw9pWGTQZYlIEtfIZhRMK6vporf8MW8b3YBzYU6TBuUHQcJ5TkntJOf5cYZUkVzrGA6OANoHNB1WFM91/LDOLkfoDA0TDtOm71ADVxW4aGdAKuB7ekPztc8uZOodAmnISPGjOB2+tYhGn8K3BHoT62JZIDXr5XmT3LiVw1aH2d4q7FTY+Jp0ysCVtIa7/ONUYLh7ADhFNDVwk/MqZ3RCAhifIU8ATaM8jvYA68GeiVYOI7KO7jIoMR/iNzDYI/F410ox3EtXAm+YxsptMhMeQuX5ErAas0oosU3r0Jbv2IsZDQOpu51/ifoueMycrGXsP8JpHAbinhiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=no2/WdOn5fxs7xyIWzcETkBFMVReJRnJZh/0Ax8b1Pg=;
 b=mBeVUpNn1cbrwbxp+tAprQhd5LOywzKTe2kSpLQJZm05L1RxD4kegh5KuoCMmIlutkwIev60FuEWG1iyjp1drrsw58HKQ+dyiqgrLZ0ej9cKd1R5/YyVbK68+Dfq89f79ce60ca1bxbLA0wTFcIdFgjDnG7mN2HlV0FuazKivvs=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by MN2PR10MB4143.namprd10.prod.outlook.com (2603:10b6:208:1dd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Wed, 5 Nov
 2025 18:14:00 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.006; Wed, 5 Nov 2025
 18:13:59 +0000
Message-ID: <8c9b0336-4a3e-49c4-9324-50d1c1b0305b@oracle.com>
Date: Wed, 5 Nov 2025 18:13:57 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] dm-crypt atomic writes support
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
        michael.christie@oracle.com, martin.petersen@oracle.com
References: <20251105120244.99752-1-john.g.garry@oracle.com>
 <7942b0d8-9f5f-d8b5-194a-3dd5b604898a@redhat.com>
 <90b9aaa5-0572-4a3c-afd3-33864daeb814@oracle.com>
 <a78c06d6-27ea-55c1-fcba-98ebc0bb7a43@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <a78c06d6-27ea-55c1-fcba-98ebc0bb7a43@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0547.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::16) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|MN2PR10MB4143:EE_
X-MS-Office365-Filtering-Correlation-Id: 23bfb736-fed8-477b-4841-08de1c9717b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WG8yM1hwWEhtdmo3NXVjdWt5c1FuYnMwQzFYeEdjRGxxWDRBbVU0RGIwM1cv?=
 =?utf-8?B?MHhvRmdWYlBXdzE1dk5jQVlscXBTMHF4QUIrODR6eFpsWjIwdjYrNldKRXVF?=
 =?utf-8?B?N2NRdHJTbXpOSWhaWU5lcXlzTG9kTk5zdS9sMm0zV1FhQkU4dmpRQkxIa28y?=
 =?utf-8?B?aFRYc0lZOUNEQjVCT1M3Mk95bXRJRC9lWVVTWU9BbU9TOHkzaldkeDFiQjJ4?=
 =?utf-8?B?WVZKVTd0VEZWUEY3aXRmSWN6N2hOTDg0clQ5MWVHTlBJQWlDNC94bFBRVDZC?=
 =?utf-8?B?VFovMlhHM1ZnRlhlYS9IWGxUVnpXaGY4Y1NXMzVQU1ZrcmFrRi9keHFIblU2?=
 =?utf-8?B?Rm9Id1VKZWRrWWwvdjFyQnFSMmhrRUFkbEJoY0VmWFpPU0k2bk8ya01aaXdh?=
 =?utf-8?B?bkx2NEo0RU5BSkEyMTFkUUNUS3JaWXhNTEtnRTNIVkxoRWtOVG9TR05pZytG?=
 =?utf-8?B?SHRkS2IxUHRMM0toRHhiVDBRZGwwZmpLdnI3TkF2UW04elkySWYrbzhjSXpu?=
 =?utf-8?B?UG5UQmlyTm5JWG1ZOHQ1SFczRm96K1dUdXF6Nk01dVBiVk5oZTRoQkd6V01X?=
 =?utf-8?B?OVNuQzVicXYvZkN3eTZFa1J4REYyR0pJRGJDbmhjSC9JV09paXNrcElGWDVQ?=
 =?utf-8?B?NVN3blBkQXpJODVMYnVMdDUrdHp2K1lsZjlTYlpCYms2Z3dlVk55Kzc1TElq?=
 =?utf-8?B?MTJ3NTA4b25iTGxQa1dEVS96WTR6Qzl1K215VGczV1lJK3hCSVhHUzVoYWdo?=
 =?utf-8?B?ZENiY2VuYTQ0TUFoVzVaWFM4TC9PZi9MVXdHcXE5b0ZSV0pHeE9xaWFURW5S?=
 =?utf-8?B?RVBmZG96VkI0Q29GeGhNdU85NkxNeVdMVXN4Q0tUcytrNm1Iam4xQlFmLy9G?=
 =?utf-8?B?enVXT1BocjRxZEFOeDJPOVdyYmE2TDBUNU5EbU1NZTFxUlJITGNudHplZ3Zz?=
 =?utf-8?B?cGZnUXJjUHpTTnF0MU1oTklxckphc2lUMTdRb0JWUU9HOXlhRjJpS0o2UGF2?=
 =?utf-8?B?dnppVi81bk50d1JwVTdKa1lzSExJZUFHVWEvc1Y2U0JQcGw1SXNnbGRIVnpN?=
 =?utf-8?B?WEw0N0ZMTERlcHRkbzNsNi9CeVdNeUdkeTIyM0EwUjlYQWcrK1puQUNXODhS?=
 =?utf-8?B?TVhISWw2ODNsbExFQmp5WWUyZnVpQTRYUXZ3d2dCTzZjeEpzakROdEFNNExt?=
 =?utf-8?B?SDV2MWZTalNnNStWL2V4dGxiRU9XLzlFS1JlRDBvbW5pVWkrb2lOYzVWdDVk?=
 =?utf-8?B?eExKL3R1RFFrQjNCbVpuWis0b2lUWjBZMndoWTNzYkRQOGtRUFYrM293TzVz?=
 =?utf-8?B?UXMzek9MNGlwN2xEdDR1d3htWFExdFB2aHZZVFB3TUlrU3NrRjVzOHQ0TVhr?=
 =?utf-8?B?QnA2RGY2UG41QklsQnB4MytmalR3TjdXay8rSExzTW1rL2k0RlYzRmFleEt4?=
 =?utf-8?B?YlhHZWNvcTgyRENDenEzVHRMQUZ2L0lKVHg1bmQxT1hYaUNmQVNyeVdhdFpT?=
 =?utf-8?B?azNxQW51cTNUdWJsN0R5WWNYQWFQUWE3VHdGNTdhb0VRQzNZVlZRcXpTRXJ3?=
 =?utf-8?B?U2lnL2RXSzVNUEF1Wk1rYmRxVnRYZ1RUdXdSZ3hwQUVENWxuRTJpZjROdUZB?=
 =?utf-8?B?emF4UVFqbGVXUWd3VG9uYTFjdmgvWTdqQ3h6OHhWRncyb3gremxOTmJDZnUv?=
 =?utf-8?B?eXZaVSthb0dVMDFVK3RveTNpajgvZERrNTVjbXlrNzdqR0ZTRitLZkNoSjEy?=
 =?utf-8?B?aWQ1VFE1eEtSSjEwRnA3eWNnTUl6N3VmRGVidGNaU3o3ejNrOHQrbTZlbml0?=
 =?utf-8?B?aHdTQkhxNkVlOWtPNlRERHQ0a0hoN3ZXWEh4ZlIrMVljTlBCb3lsUThuY29X?=
 =?utf-8?B?OFd1VUFETG1oZ0tuNGl3M2RLVVhybXNFUnVFMVZENU5XOThWQVRBY3F2R2VN?=
 =?utf-8?Q?uqFYs6ZfxzsLKEwlCauU0wlXAIz3uy7p?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b0F4eUhsajVNZWVNSDJVdjNBWUVHaGhDRW1pZ1RRM3o0S29XUC9zUnNOUXFu?=
 =?utf-8?B?MUhkZG1mMU80b29pTzZYZm40TUV0eGRYMlZIUmlLV1NVYXMvVmhsZnk4WnpZ?=
 =?utf-8?B?MHd0bC9WRGt6azVsSWVRRUREeU8yVUdodThNampXTnM4bURoemcyQUwxTzUy?=
 =?utf-8?B?cGp2bnI2bndrYUYrdDF6R3hPd1JNbjgyczgyYjNEdEhqWWgxbFZDZmRNMENM?=
 =?utf-8?B?R3htaCtxQTZ5aE0rK2lkekJ4UkhGaTJsNmVlQWdpRzJGNkVTK09yOW1iVzdz?=
 =?utf-8?B?R2NqWWVSeldBT1p4OFZtbTlCWCsrWU81dE5KS3RMK25MOHA0VEhaa3VTalVJ?=
 =?utf-8?B?UWtHMUpTR29ETjByUjJkVFo1cmtRMllaNlQvZFMxVUtyb2wwejljd3VMbkhV?=
 =?utf-8?B?ZEIwLzBXTnFVV3NWMm44d1BTR0R4TFRWNjYvbkxjdWVKQ1FKd1lEcjV2YlND?=
 =?utf-8?B?RjNkNGFQSVJpVVMrbFB2MHpRUlRtbTRjdm1vNEpycWVEZkx4SXJveU8rMEtM?=
 =?utf-8?B?ZE9teDhtVEV0akc0WlZ0Tzl6cHlRZi9jQ1cxQVc3RWE0U2xzTEErK2F4RFhi?=
 =?utf-8?B?UGNwZVVwc1NwZkxRZlNHUU5QLzBQNWhoTm9hNThickFUSVRlUGRja3RWbFhp?=
 =?utf-8?B?dVBsaWN4YlNRd3krSmY2RDZ3Tms2ckt3ZWRzRnoxTFBPUzB0Yk00b2NwajNF?=
 =?utf-8?B?WnN3VVpQRi9McUVEbjVSZktQQVZsZTNjU0hkZk1XNjN1NGY5WGl6K3RzNFMw?=
 =?utf-8?B?bmpvNnlQaklHYkVPd2NGaTlCeUFGMklEazlZNjZoalNWaFRueE9MU3R4NzVn?=
 =?utf-8?B?WXR4OHd3ekU3NHVhb1hwdTdES2RyWUJmMWdxZ2dpdE9oWnZrMGFJNlMyMjhB?=
 =?utf-8?B?bnRSSEdIcExNZEtoME9sYm5CU3FTMGtUYXFUNTNoRzVrSVF3UGpjTVhJNDNi?=
 =?utf-8?B?eW5Od242OHNmNTE2NFdsaytuN1hISXhGVExabWhja1hUN0pKM1Bla1Q5UzZD?=
 =?utf-8?B?VEJGTE9wM2hjcWJrQ1BDUW9xNUVVTjRWRFZueElNTTFBV1FybXp0WWtHWnVX?=
 =?utf-8?B?cFZEVGx3SStCa01tOUxWR000V3R6d0tiVlBmL21zK2o5dzY2MzlrMFBBUGRH?=
 =?utf-8?B?bTVwS1A2RXNRVFRUdjAvSDRFZ3VyUnkzdFpvaVNKQUI2WGJEZUJEN0xXNjM1?=
 =?utf-8?B?YXd2S3FCZG85LzdYY3VEQ0pRNkVZdkFxVCt0OHdBRkcxZ1pnQThFRzVld2pQ?=
 =?utf-8?B?NFRGNGR4VmsxR0FmYkx3REVJV2hkcVQvRWlOSTZQUXNhaXlnYUk0UWJTUGYw?=
 =?utf-8?B?QllEdjc3bGhpSGdIdG1LaVh4REpiWXFpYlFNUVl0dVl4NUl5Z1RRMHNSNjN3?=
 =?utf-8?B?aXFnVlcvNHJRaFhBK1Ryb0srUTFrdFdqZDZPcVZEemk1REc2WWpaWVlyVHNw?=
 =?utf-8?B?YThMOHFRMFdOc2VkeGdLbXVnb3I2MUZHTFZpWkk5Qlo3UXBUSkNnc2tXK25n?=
 =?utf-8?B?dzg4UzVEeHdoMGh2UDJQdXQxT0o3OTNXL0g1YmhaYU4ybk5HL2FPVXFVTFlv?=
 =?utf-8?B?ZW8xTjF3eTJoWXVGbW80cG5YZ0hSeXF4QTIvS2JRZVdCOXJONk8weEZMWm1r?=
 =?utf-8?B?ckhQK2l6TEJqYzFzKzk0YWtWVTFZcVF5ajB1OHAzTm5jcFFGeUNlREJyd2F0?=
 =?utf-8?B?dkFCNGJzbUs2cDdOTS95RWpaZ2xCQ3E3cm1TVEpkYTJOd0NTRU00byt5ejg1?=
 =?utf-8?B?MldJSDhLMFZsT2VISEJXVXNLUUptRFpyZlVPcWYzeDB4YUtQemVOd211bTFr?=
 =?utf-8?B?Y0xaeVkxdVhEMXhpSWJiVTRQNER2cFFGaWo5c3RyVUMyZHVrcmdnZWhmQ1dm?=
 =?utf-8?B?aWRtZUpKTjlZSm1VVkE5NENwVlphY0xpcGt0N1NQTzNwVXFWa0t2citNaWxh?=
 =?utf-8?B?TGFsYXdKUElhRTR2eE1CMlZacFd5Q2dScXBReUsySDgyV0hFV3NGSXdYL0VD?=
 =?utf-8?B?MjdJeGRPZ2pWejB2N04vNjdiSWdMcGdsQkRCYTV4OW5wajVaODZmZ2N0Tlpp?=
 =?utf-8?B?YVA0M0FCZFlLSjVmam03eVQ1OFVuZ1BkYkZiV256U2ZZR3lpbDA1K2tsOXJp?=
 =?utf-8?B?U1prZ2xNckN5RDdHZVVjYjNJbWw1TWVBWmpyZXJITGxzalJudFpHUnZJS0pW?=
 =?utf-8?B?eHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PsRHS2CIW3m5bMhE8J4EX1FjEZOP9vfeYo89nOzeTomjaAw8VlT/uBgJR+i/hCy8a26eiMWFo5BEfqmL6u0jhvo3wbshzAD1vVt5YeCvCPfRKm+laNyU6sn15ditxKjfGjxkBAwt/qtekmcll5n/8xBP72Y6NeDWJYadvMMXBp9ZeNJWAhMVh5bU9x3g0xK/a7BATRv3Nprm+2Z7ZJsnu16B6HNsVmM/mLchW6xEcyLNavKu91ps9oo9wVy3WVAcHBGluKFll1GqzxaSd3XXkCBAU9u1VB49dyudcShPImZdfZyUZAhOTg03Imtlvbsbg2Tjt1rbjKEIxG8jjFjEuWf/G3x9CLoRYsBwVW/3qkanQ5VSauuCIziBcYmjJJ7sgDJytj8AsOnkBbGDyUlgafRUAiWSuXDamuqHvgUT/iOahEos4DNkcfmoicCkT3nMAJtLED+SeWL8iggHHUwkIkfIc4X/QpxUSTXBluoRrHqj1Ly67mLOQPj3LC9KrA60nLepLA9nmmR6fHPDILeYDHUhkd1vmr9m7ak6U02Xq1/GQ6xZj5x3qbtlVoZWTaaMLS1UMKeiAfABXgirnz//D6/608LHofqcRJNrOV1DgWY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23bfb736-fed8-477b-4841-08de1c9717b4
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 18:13:59.8624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gPz5OPDJMnDgWtfKhMTOhuImQs1ePmk6jc3FOYNEpJwvE2mBtcQBEasXH97PnfLxjdPbWbpsnYYnQvIBFKB+mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4143
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-05_07,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511050141
X-Authority-Analysis: v=2.4 cv=IcKKmGqa c=1 sm=1 tr=0 ts=690b93eb b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=gS1r1y8pETFYBTPpKZsA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13657
X-Proofpoint-ORIG-GUID: jdRgvM8bSxJaK48lKCPDRl8yqZNOho_F
X-Proofpoint-GUID: jdRgvM8bSxJaK48lKCPDRl8yqZNOho_F
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDEzOCBTYWx0ZWRfX+nsLM3tJ8UAG
 v5XIK7f2ubctuwmyREBr9NZ4mu6dAjf/J1oNYSWH+Ee6iqCPys8gIKiy/OaJIbEyW10pC8ZJdgW
 MPYI5VOMfCyPFV4gQViZawr6452w6oLxF1Al9D6/HxjkSplp3RjK2drX6KZMBYCcOim0213Eyuf
 R2Z4ypmhCYXnF+hHAcCyNIscDAiBBfSxcynzLoNHDEojnL6EibLKqgtxO1E0PcWBgeR1DFZsorU
 wv0O7BMDnJgzn4qtF9LDecpIP1rstO0JplSotA0ELf7f0oDRK18eCU1QYKKPz4T3U6aukmUohbZ
 0MzE2VTVn8BXMZ3JfXsd15CDLBNuWkSLK9l6FxXygx3uQtpeKsm8qSYRrJ7FBUSW2Zcb/q03LwM
 G5BO7LISCCCm13Fci2WLggn+jSeKZ4D8LAq8b4ohvwzaTfn5EKM=

On 05/11/2025 17:39, Mikulas Patocka wrote:
>>> Regarding the first patch - note that the device mapper stack may be
>>> arbitrarily reconfigured, so it is possible that REQ_ATOMIC bio may be
>>> sent to a target that doesn't support atomic writes - and this could
>>> trigger the "BUG_ON(bio->bi_opf & REQ_ATOMIC);".
>> When reconfigured, the dm device request queue limits are re-evaluated, right?
> It may or may not be re-evaluated. If you stack LVM volume group on the
> top of another LVM volume group, and if you change something in the lower
> volume group, the upper group has no way of finding out that the
> underlying physical volumes (which are logical volumes on the lower group)
> were reconfigured.

sure

> 
> Similarly, if you stack dm-crypt on the top of a logical volume and change
> the limits of the logical volume, dm-crypt has no way to find you that the
> underlying logical volume was reconfigured.

Sure, and I don't know what really can be done about that.

But I am interested in if extent a vg by adding another device - would 
the limits of a lv be updated? I think that it would.

> 
> There is also time-to-check - vs - time-to-use race condition. Someone may
> see that a device has non-zero atomic_write_hw_max, construct an atomic
> write bio, the device could be reconfigured after the bio was contructed
> and before the bio was dispatched - and the atomic bio would be sent to a
> dm target that is not expecting it.

Sure, but the good news is that we have checks in the block stack for 
this, i.e. if dm submits a bio with REQ_ATOMIC to a device which doesn't 
support atomic writes, then the block stack will reject it. The physical 
device will also reject it.

Thanks,
John
