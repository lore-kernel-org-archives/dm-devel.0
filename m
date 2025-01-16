Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DFF1D79A9
	for <dm-devel@lists.linux.dev>; Thu, 16 Jan 2025 11:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737026910; cv=fail; b=F64RRtuX4DHrzdwo8LDR2o3oTwu0FemmVezTOEBAnXayRzHggHlQ87SHkXCuon5TpG8iYtNZfr52jk0QUWOQOA41aF99InUj0hSJEv3UKe70wWJkaXNFYI1Qaq1+mlGaHAuwDH2Dn4NS1KZtxd7eyfL1LLocDB9MEoWpAk9nBIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737026910; c=relaxed/simple;
	bh=Z/7U5NshPks9lAkS+WKDV9u405nr8LDsBzoAhOa9xgM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GwoBoUMLXX+oz0FveHSsKI/iGHeUO31g/+fV+/XFzX7fBTaL7hbErJ4B/7RXpw3vxwXK8DoenoOZ0zoKlWib6Ip4m+u/yQ1b3BwM5s7An4CIkHFD6hI/A58SUKg0usD1YDTdvc4D87w1pwz56kNSJ3MiFgPqGYDjlIFkXJx8UHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TtoKWg3X; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gypCotfQ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TtoKWg3X";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gypCotfQ"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50GBNHbC011013;
	Thu, 16 Jan 2025 11:28:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=u4ucE/JjEgqOKzGqVvBCvuYFyQ4zE9tjPLTIaW37KFM=; b=
	TtoKWg3XjclPI+jkUj0qGd90jkpxVvFVlWiLBxl0m3kVDYcCGn8wFaoHbtiyuacK
	kU4xOtHrsC1/wSwtmZn20SLJR3vDvOmAGsGDHn+1IhipDAeeF6RlIE+iCRr5HKXO
	UPoauS4ACk5cjp3+A1LIbkwGxbO9UMAqySK+SK4TSx6+gb4H2Q80+8TYYshjSCal
	iSSPz7ELyzMPh8coD87pNPnmY/oF4dIQSiZMeL3Qqdz4fMeN8jMTnpGbfizSXL4W
	VDPy5zJ2VvnEGHLygad3Qz1rc3YeDu6egv2RFjAhVMcHNbEWqG5mc8Jerutvo7K9
	MyrC8Rts0Z5HzmJh/KW8ow==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 446pdx0vsw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 11:28:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50GAmu9F036336;
	Thu, 16 Jan 2025 11:28:23 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 443f3b88gf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 11:28:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sExiYjUIRULLypnHKUP82nlsBTwEGbDBn9UF39JA0gleDjMXZGAdeSJoH4910xZeHeLcKT96DBWCXvcaABVTS6t3sP1t4UJMvi2tHV/hLbyJB12by9LD7Fly18Svybje670RQb7kCETKmENZdRkdEKbuIkTeOnOX4qieqej5fhDJZmipjFZnyWEMpEr50vXIbol1q2JhqVxX2t42IvOxefJD5QGlIpJnfA6+PPDsTadRCW2WyGbF8CdEkgQ6cQE834sC/pczeU/ud0l76YkMc4gugU4xfAXJmNQNxUvw9aRrHZkRut4scTXWaVsrODD5sJhCnMpBOpt/KNSoyRLJSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u4ucE/JjEgqOKzGqVvBCvuYFyQ4zE9tjPLTIaW37KFM=;
 b=QMadZx58p4X6DVuuV/wI3LYdY2Iemoc1evOE25m79PkAL1fcy8jIBKsbEutViGFq3EsJwB+4JUUgxKXeslDWGSGYgKsYPjptu7euZDJ96poYQPbvbnIESRxsFjuGYtsECzzIqUcFqUduoGhE2CtXCkp0RR+MNCoeJfC28Qv3mk1dMnJkANnMofz+ATG9qGXZ50hjOD81Cqb/AownIe40+FAD3jpFjTI2cPNVZqCZwO1UPBaczrx7qMwZshddP7kJGAeQYdXVnnjirTzI9GQw/mSRA2pr7OrHwXcrPHRQlNhomsP2Ua3FB5SolxPt3nb/r9vdGqRhgEwKpJisn3usOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u4ucE/JjEgqOKzGqVvBCvuYFyQ4zE9tjPLTIaW37KFM=;
 b=gypCotfQPmmwy6+qknBgGuRm6PJcI+PTZBUKFeR9BtcrUzNGKz1CCSZkWl18O0NZm2+xMb3NwarQeaq7mPNZqqq0Roc5hypNTFgnQb7sALg4E+VF7R4k3TJLTZwH8ObZOhkZaw227AlIfA0if8HjTQuud0iT+GsFFjhwTRBavkg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SN4PR10MB5653.namprd10.prod.outlook.com (2603:10b6:806:20c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Thu, 16 Jan
 2025 11:28:17 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8356.010; Thu, 16 Jan 2025
 11:28:17 +0000
Message-ID: <6a6f8cff-bd19-4079-8867-4ac17d09e915@oracle.com>
Date: Thu, 16 Jan 2025 11:28:08 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/5] device mapper atomic write support
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@hammerspace.com>, axboe@kernel.dk, agk@redhat.com,
        hch@lst.de, martin.petersen@oracle.com, linux-block@vger.kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250106124119.1318428-1-john.g.garry@oracle.com>
 <Z3wSV0YkR39muivP@hammerspace.com>
 <dcbaadea-66c1-4d98-8a37-945d8b336d5b@oracle.com>
 <5328db9a-8345-2938-7204-3d4cdb138ee4@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <5328db9a-8345-2938-7204-3d4cdb138ee4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0003.apcprd02.prod.outlook.com
 (2603:1096:4:194::13) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SN4PR10MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: 7caf8f04-05b6-4836-65cd-08dd3620df2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WE5yVzhBZXVqNEh5R3ViYzFOZ0plekxtN2VFWExhVG0zWTVDLzJpVkprNUkv?=
 =?utf-8?B?RDN6cWJyWFppR3hPdlBpeGRtQy91dGoyNkRtK2hERmorUFhDTk93NW0xNWQy?=
 =?utf-8?B?N1NjZlh1cG56VnpwSVBuamY0Q0NmM1psd05kYm9mcUFXS0o3Qi95cEtFVDB3?=
 =?utf-8?B?REJSOEl0M1IvMHd0Z3VINUxjZzcyeUt6eWFsSWxqT3RNbEVJSmxiaFZzVWNP?=
 =?utf-8?B?SHh2VFIzaS82Tml1cTRONjFvM1B2QnQrSFNDcSs1VUhRbUtrdWJJcm00aE82?=
 =?utf-8?B?YUZnVjM2eU1yRUdjWFRZdEI3TUFqaHZGSFJnQnI5a3l4S0p2RXdGOGp0MUpQ?=
 =?utf-8?B?cnpORmJlR24zNFZwMlJQMzFrcEN6NmVkNjdVanlPaWlSUGM5em94aCtkb2RU?=
 =?utf-8?B?cUN2Q3lMZ0NCaUVrWlZxSjlxR2RqSGFSQUM4TEE1K29TVVFvMytScTd3Risy?=
 =?utf-8?B?Q05HSWFtWWo3MnFNU09WU0hTVm02dVFiZkVvdmtyZlpSN2g4RnZ2a2hmVjgv?=
 =?utf-8?B?cXp3TjBsWFRJcytDWDZSK2dENlV4Q1RXYW1GcTAvZVVaYnl2aWlNUFgzdWdn?=
 =?utf-8?B?Rk5UZWVZNFVPcG45RjUwR3lCYXVidzlndWpoSE55SXdBeXB3aW1uc2lYYmRm?=
 =?utf-8?B?TmF5RDJCakFMblVzRXVEQlFFVHl6dnczcFhSTS9GR1lUbjl6SjNWbDZYTTJF?=
 =?utf-8?B?Q2tnL1lHUG5BSmlWRklrNE9uVXJGR2ltOEJqemNOSVFOUHEwaGxTL3RiUjRn?=
 =?utf-8?B?YkVnYmNJUGppOXUySE1xaTJKZjdtOUpSUHNJak0vdG9jRVZtbkN1VDZQcnQx?=
 =?utf-8?B?OCtnZ3cyRjBvTzdlaUQ0bkFvcVhUTlRaQ2JHYkJEeEhjUm94a1dXaTVFTmJR?=
 =?utf-8?B?b0hEV2hEeVJTRCtKZFZGR3Z1NTAzTWlpbGVQRHltRHhNWXZWWVpQd3JoQnZS?=
 =?utf-8?B?NXBXTE0wbENDdGVEQzRsaVNNSnR3TUl3M21qSG1lbkN6UnhiTFIwOElSNDdZ?=
 =?utf-8?B?Sjd4U3o3ekNsODR2dVlOM2Q3MCtMcy9qbHk1dUNwWnh0dk1zYURnUkprYUgv?=
 =?utf-8?B?ZWs0L1pPTVBibWVFUWlyUy9kdTljYm50T3k0Mk5iMVdXSVk3OFRPQVFaZTBI?=
 =?utf-8?B?bjMrV2hhY0tHMC9vakgvKzVsZkdjVnhiazRPQ256UzBHc2hLUnIwSDhVblhE?=
 =?utf-8?B?aTY2cFIvbXltWklGYVI1QmdSUiswWkZiZmlOeVY5aE1LTGhHeHNKb0pYeGFs?=
 =?utf-8?B?Qzd2RE91RkZnNWoySDdsSklFd3R6Q0dmOUU3NFIyYlNQUGd5RGI0UFdYdDNj?=
 =?utf-8?B?LytibHBTeC82eUgwL1ZRUFdvbnJ3dmJ5NW0xcmg4VE4wbXZ6Vk9yNlF4TnAw?=
 =?utf-8?B?MUs1d2RIMFJNMUdNVVBYN1UzWkhNeDJXS2RRS2kvckV5dk55T3kvUU9pc3J6?=
 =?utf-8?B?Ujd6eHhQdWxOOTVPbXBVczRHcVF0OGhvR1praXA0bEMzb2k4L1AzOGswdW5R?=
 =?utf-8?B?b3cwY3lNUGN4OXY5cGEwOXVNaFJZM0RBYWJnSkk3SjRhV2lVbGgwMXFjdFJP?=
 =?utf-8?B?ZWlVT2lKUFhpeGVQdklTM3B3UDduZ2pNeWVML3V0Y3F1Y1RydnUyWWlPcGp2?=
 =?utf-8?B?dWcwbTVQems2clBvRTFaTWsrV2Z4V0pybUgxMkpYTk85cjgzQWZnZVhlc1Zi?=
 =?utf-8?B?TVptYlVGTE15bHNJN2NqQjJDTmhOb3VzdFdiTUd3MGFLcG5XdVVLOFB0OVZR?=
 =?utf-8?B?R056bDBHQ05MR1NCbnlFNHBGN2MwRFBXeTYrZnNsUzBuQmJDRFM4dDRwMkhD?=
 =?utf-8?B?a3B1bTVzM3RtaHpROFBVeHBVQnQ5bHJFRjNjYUZaRFNoU0MzTGJjaXlJUGF6?=
 =?utf-8?Q?HflDbJDxFPOXj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YUVjNXp2TFB5SFFNUzlsNVM1MldDRFZNQTZqdzFBdlRlMjl5NTdTcGpFZHlp?=
 =?utf-8?B?dkpnZVgvcXlzWWdISjFrRzN6Z1VlbFl3eWJJTUxuUHkvdllTbStOaXY5aUJr?=
 =?utf-8?B?enRkeEx4bkxZa1pNRmQzY2NGc3YreU5Yd2w5TDZVNDJ6M3FVU0VNSnowY2Fv?=
 =?utf-8?B?M0FkTVd5aHVEcjgyVlJJZFBPNGlyZE4xWUdKdjllOEpKb0o5Y0NmakIxMGRK?=
 =?utf-8?B?ckd5Q1NmdjVYVUpGdWUxbW5yWlc3TlFQTU5iYVRTMDFUd1BnaWJOeWkwYXNQ?=
 =?utf-8?B?RUQ3YWUwZEFwTVZlMXJjVWZIUzd6YmlGcGpiNnU1RjFwTHR6Z3RaZllqQ2ZR?=
 =?utf-8?B?MjdyVDZ2VE5keVgxWWs2RnFWOUtJMXJpUGx0YXRpcHpYZzBycFIrWTcwZlg0?=
 =?utf-8?B?TWZkKy9nQnZoNlpmaVczOUVxQmdtNjJBQ092U0psMWoxb210aGtPazRTdW1P?=
 =?utf-8?B?RkEvbVNaSGh5SFlaVDZwdnBBU1JuQ1YvK3AyeWU5aXQ3Y0ZMcVlCaFpPRVMv?=
 =?utf-8?B?T1drMW5wcUdFdXlRbXlpbW93OFY2Zk1XbldLVWtNeTRNaUsrcDY4cEJFVllN?=
 =?utf-8?B?MENLS0V4ZzJ3T0c5RW1jSkhMRkRHN1lvaUl5QVlPWDdzVTJhWld3b3lSTWRL?=
 =?utf-8?B?RUZoU0psKzZJOHhjMDBCOFhOUkE3Z2FucHhzbDJid1l6RndnOHVIeGVIM05p?=
 =?utf-8?B?K1gzV2FqbnIxQ0tXcEhkMGJkaW53dCthckZSZmdPb3ZMUHRBZlRFSkpFL1A3?=
 =?utf-8?B?QWc5QlBaT05XelBmZzQ0YmxDMXFKRnBUOEg2MU91U3JPMWtBQTBiMVREY2xO?=
 =?utf-8?B?dkdVc2ZGQ2hYTzNLcUwwNjlqaEdMeTBtM0Q5ejRueFExaVJVZ3hueGt2MFJO?=
 =?utf-8?B?NmRHNHZpWkFuYlpENHArYXFYcWZkRms2cWh2RVFSVWR3SUw0cWRKckZleUhM?=
 =?utf-8?B?d2YxWUlWZiszTWxlZktBN1lBMDRkVG9mL1FzV29DWFNoZ2NoZnVMYklkKzEr?=
 =?utf-8?B?UWFGSVdCV1JKQUs1OFc1MnhuKzBxZ0NtbGdiSVR1OW55N2EyaGNXdVlOUmw3?=
 =?utf-8?B?U2ovdmljNGluVE00NWE2alNRNVVlUDRvT1MzZUJib1d3ZmxxNCtlQ0Q1N20v?=
 =?utf-8?B?Y2VFSkVGNjBWM1QyTTVoeE51QVlmZ0NMajBIdUtreXp4V3lrWU51dGE4YWpE?=
 =?utf-8?B?QVRMVUhBZHRlZ3JvclBDby9hU2QveGlBdFQ4ZVBtK0JNS1hXT3VlczZUT1VC?=
 =?utf-8?B?NW9GajJZMThFWC9IUDR4TU5wZ2NEanpLblhGcWxvczdsMVVPNnczY3pSa2dq?=
 =?utf-8?B?dXBZSWUrUDRtOHc0Ly9lNnFxMlBWeGsvWlJ4dlVCRDhmOXBpdUc2QXZmM1Z6?=
 =?utf-8?B?cDU0aHJKQzRGcFgrREM4cmQybVpncUN5RWNjaUpwVWthU2xxVkRIZWZDU3BJ?=
 =?utf-8?B?YVh4NmhlanhTN0JBckY0bE9MU0dCdEhXVEpaZFhLTVZTbFdtelVpbnBxb1Fs?=
 =?utf-8?B?S3NWU1ZsM21MbzV1TmNIVzdqM2xSUFJDZ2szcjhTR2pJWndGUG1lS0dLQVVF?=
 =?utf-8?B?eElSTXRtL1grMHZIOU9jU2dic210dnBiVTlLQ1daSjVkaVNYZDZ3QmJYdUp6?=
 =?utf-8?B?TGFaZ0RiazA2a1RPV3JSaDlHcHV2eHJ3NGpaVUt1Qy80WjJMYUVBOFdQb3BE?=
 =?utf-8?B?Q1hVaHNXNm4ydm5JNnRVWHJxdURkc01ZOVhvMjRQK2VQdGo5ZHU0TnE2RXhL?=
 =?utf-8?B?OG82QTl1d3dRSURDTmw4V3RkNWdSTEo2U2E2NkFpREpoQ3R1R2lsRVdTendi?=
 =?utf-8?B?bDUvWUNJcUpPcC9VcXpORElOd3h0N1ZmZDdoc055Tk03WWxEYnl2WndybHJu?=
 =?utf-8?B?QU5CQnI3TlJ5dWphSU9PZnBkRUtiRnFPa2MvazM4WXdwNlBKUUsvU3d3R0Fv?=
 =?utf-8?B?dHVQS2ZXRzVyM05SNXhiY093dTVMeEd3b2ZzQUlpWTR3RU1Hc1ZjU0xra3lE?=
 =?utf-8?B?cGhnTHYwK3EvR2x4YXVlbzYvMVh0cE1KT1hiaHAzeXh4akVVWklmVHNGUHNW?=
 =?utf-8?B?cHV2L1gxVWkwczYrNTJlaU9haXpTbFhXQnlJcncwYTJQVXdKL3NMY0Zkdk80?=
 =?utf-8?Q?GtIjJitgtnXvqk5X5JU0TFDnW?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GiGygvpDUc/Vy1o1TbLtqhdfbJZg8IBRJdIlijkx9lgEXIRvXedojGUWvGexXdHWwbx2mrWUEvXqC9ei9rfu0Su3rXD5+1JodHy3rgnxdGbV0x2loWSVRofFYmK0Bqh0N6wiI1FLIeHjjv/oFJntROeQydSoPOIqwTcov6dgL+mWmAGka1jxm/rUFATni8n24XtneR54M2TBToKbTLwNq/TJThXpptAlXt1QCLnD/+hPw6G9e5Uvmu/4aAKWz5olxaqMZeaIzCwifKfTSCO1TsBvLRS/sVNv3M2Bd1OaENCP2kQTNrZ1iI71lQRf5xKeYb3ST2yAj/DYTBC0Z8st4qxcz0WlX8M4OtASdtUKeUM3OBS2uKZT4IUWq/4jbnq9iVkN/0X5yAKZbDoGujFrpLDcrQHxDOs6zLLRpvUXiUHUoCZolKzKboN9O7YV+RUUvxNdK5a75Fq1ZM+ql3vZjGwEu586nF9DFUUygH13kt68QAtjBt0yk+Y69werrkP6om4/lxe63cIiBv7NDcNgiNYWqTNcYcf9bybVheIv0xDuEyX3FFGeGDxw88ITk/YCWjWncJY8ORI0HNQrcd3uRzATyQhx7OJ6MFpkvnq5zGY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7caf8f04-05b6-4836-65cd-08dd3620df2c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2025 11:28:17.0820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q1cBnSm+kyxcVaJanMbA5O5eDle30ugOKWwBR9hlBwf7WMCCpKZpxVEYqAkYJjFtQ9MI6l4ISUFqkwLROwUxSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_04,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501160086
X-Proofpoint-GUID: J20y86k8YOr5OfsUo99DsgFu-SvOsbAj
X-Proofpoint-ORIG-GUID: J20y86k8YOr5OfsUo99DsgFu-SvOsbAj

On 07/01/2025 17:13, Mikulas Patocka wrote:
> 
> 
> On Mon, 6 Jan 2025, John Garry wrote:
> 
>> On 06/01/2025 17:26, Mike Snitzer wrote:
>>> On Mon, Jan 06, 2025 at 12:41:14PM +0000, John Garry wrote:
>>>> This series introduces initial device mapper atomic write support.
>>>>
>>>> Since we already support stacking atomic writes limits, it's quite
>>>> straightforward to support.
>>>>
>>>> Only dm-linear is supported for now, but other personalities could
>>>> be supported.
>>>>
>>>> Patch #1 is a proper fix, but the rest of the series is RFC - this is
>>>> because I have not fully tested and we are close to the end of this
>>>> development cycle.
>>> In general, looks reasonable.  But I would prefer to see atomic write
>>> support added to dm-striped as well.  Not that I have some need, but
>>> because it will help verify the correctness of the general stacking
>>> code changes (in both block and DM core).
>>
>> That should be fine. We already have md raid0 support working (for atomic
>> writes), so I would expect much of the required support is already available.
> 
> BTW. could it be possible to add dm-mirror support as well? dm-mirror is
> used when the user moves the logical volume to another physical volume, so
> it would be nice if this worked without resulting in not-supported errors.
> 
> dm-mirror uses dm-io to perform the writes on multiple mirror legs (see
> the function do_write() -> dm_io()), I looked at the code and it seems
> that the support for atomic writes in dm-mirror and dm-io would be
> straightforward.

I tried this out, and it seems to work ok.

However, I need to set DM_TARGET_ATOMIC_WRITES in the 
mirror_target.features member, like:

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 9511dae5b556..913a92c55904 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1485,6 +1485,7 @@ static struct target_type mirror_target = {
	.name    = "mirror",
	.version = {1, 14, 0},
	.module  = THIS_MODULE,
+	.features = DM_TARGET_ATOMIC_WRITES,
	.ctr     = mirror_ctr,
	.dtr     = mirror_dtr,
	.map     = mirror_map,


Is this the right thing to do? I ask, as none of the other DM_TARGET* 
flags are set already, which makes me suspicious.

Thanks,
John

