Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EF925771
	for <dm-devel@lists.linux.dev>; Thu,  6 Nov 2025 09:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762420923; cv=fail; b=ckzNNtXKlGz5iTIvgQsvvd0VvAxeLvoHKZzlzJhFqoP0geknTcqH+Ny6rF9aUABrBCAxpMmhXabp4andifHKPXzueJJtdS8fEL7TSJD7xN2ToTF872P8ar1hKIJT3mlnP6IhHsAY8Im0lu0TW1/A6muf64HVUg8cCFF7mB7flI4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762420923; c=relaxed/simple;
	bh=uec0jwHCbozqL/JOhlkM8LAhhhn1mc+bw2fG2/L8UlQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LjxcE0m0SWoNOD65U6jxhL8xPgZhoYqoXX1hjjsjH0gEer9USIPKQATxvWlJeiz64THNqot71WW3UTIr+Yl2gAIRezaZ0UnC9xi4GFTld2aSFTi0Ou/lGtTDw7pBRSlcQHrEAj7vqOvWYn61Z2P6KygAzCcjl3vcFnCV2xpB6MU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mMBTD/TY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iazyGLFr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mMBTD/TY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iazyGLFr"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A61CHwH017059;
	Thu, 6 Nov 2025 09:21:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HUC9/MAZ3l1H4YMEH15xnemkvTPOnfP8OPSl5iQumqo=; b=
	mMBTD/TYoUfjrLwlVawhjS+u/ikYgUHCHevl1TnPEpdzSjBKjIpprD5HSPAQvzaK
	Z4XbI+xf97htgAmbtyQ16lnBeqITbInDNC6X7HBjtVNhZx/ges3avhIOS1vcOy7W
	TenEO4RByr0cLcKSrG5zyiiqIuJGhSNbPFhKts8g2+KxzRIS8uJdrN35BeTGdGfE
	8TCf1DyvKdm0ZxPdoahIf40BM55AWaFjo2Pi8Hh+5DQ3nl783c6lpwx+GtmvdS9G
	yoqLGOpw3oS8bK0TKVEfUlgcRZfrLLVltfQck2XJ0+naUNwvSDALKIBPz8Ymt5BA
	TrO/5NS0t2N9LdfTGDJU0g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8aejsmh4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 09:21:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A67VxJF015031;
	Thu, 6 Nov 2025 09:21:57 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013045.outbound.protection.outlook.com [40.93.196.45])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nbwta3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 09:21:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CcO0wBL/yju3ud93obD3mkfF2RnXfnlrOfVcUn1k42fzAWgTJGQyRj51r50oZHu+zihEzLJz5zgNTe+/Xi9ZR+/fx2sOPncidd4TB/JUK/+8AOF04Ah7+QZIZcQJ2cIxeCfiw6jq/BbPXqha+bDCiGB/dFV5wPc2sqE/HujdtmotG4t1tbuLHDhxTj6GeC4yTXlNcOL8G3I4FVOB2Aqp7adcIuiPRS7cOVxEZ/wxf2AZuxyQ+O3xdOzbzO9eEpmfnMROOLuGTJYiDJh8uSgTGH9ZWh8raTb5RGLfQz8edjr0h06klZJ7AyIWXrFwGe7H1rUQReEe+ulvIBOcpznyxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HUC9/MAZ3l1H4YMEH15xnemkvTPOnfP8OPSl5iQumqo=;
 b=NkZPCIt8dhSYxpBDkkqxw+UFoYS+wu7WYiNMTazyMQIx/0gUbPq2g613hLepOm+E0l4GTIGcbgdiaL2pOxMfDYIdOXE2I1X/JO1i+QBTs5aOdIR4Wwa9h97d7TZYQEG2G9QGrytUBhl9m2XhdEc0K7zOoCcQ86pK1VOug3nuGH7YAna0S9fztPkXWDvxe+ihNYhjmdEkiusqE8kcQpMM82ofwegv4NFO7NTvb6lN7zXHwGeS8o0xg+ORAMyZPgnhBMg3R98by9Qbg7U0vTCiUH1LPi4O4SUs1f/KUbpyR+Fu+8M09V6UgloXHpLmb6FNXlGvPRqMCsREMtx/IhtGoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HUC9/MAZ3l1H4YMEH15xnemkvTPOnfP8OPSl5iQumqo=;
 b=iazyGLFrowt/Mdsgw5kqpCRDKJ2XfEuWJgPNrWW38z4HljvMRsjmjhJ7piwaSJzjDRpIF94fw+auHRBc6YCYF20uuZbI/6gqHnENYuABTcYcHRFMZENv3I0AA/IVIEsKowA09y1mthltchv6Z93X6aSduKFSeo5Q6bGVtBcte04=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DS7PR10MB7192.namprd10.prod.outlook.com (2603:10b6:8:ee::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.8; Thu, 6 Nov
 2025 09:21:55 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.006; Thu, 6 Nov 2025
 09:21:55 +0000
Message-ID: <17b4c528-00b1-44fd-b21c-de8f37d9c46c@oracle.com>
Date: Thu, 6 Nov 2025 09:21:53 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] dm-crypt: enable DM_TARGET_ATOMIC_WRITES
To: Benjamin Marzinski <bmarzins@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
        michael.christie@oracle.com, martin.petersen@oracle.com
References: <e0b99d8e-1159-a489-6df3-648b21c4f091@redhat.com>
 <aQwCHqrdNMy1wy75@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aQwCHqrdNMy1wy75@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0612.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::6) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DS7PR10MB7192:EE_
X-MS-Office365-Filtering-Correlation-Id: 80d9a6c8-9714-46c5-59f1-08de1d15eda6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Sk9iMGtERSt6cFF3YUh4SE00QTE5ckR3eGZ2bi9CejRtOE5hYTRMaXE0QXdL?=
 =?utf-8?B?MFBhYzBraVJNcnFNUEs5dTRlNzBleldkUVdSekFWazBlNEt1ZzJnNGZXTzBq?=
 =?utf-8?B?dHB1Mm9kWW4zNXFDTUJoUkVrb1l1c2J4VkxBR0FNWlZWcE9DRzMrYUdCQm1y?=
 =?utf-8?B?bC84MHVtdmRCV2lTd3dpbXV2c3Jjb2srdVBXMVVvOEpsRVJVRFRIQkQ0dlFm?=
 =?utf-8?B?U0U4bDgvK3RqY1VNL3V4NWhNUFVhNkpOeE1VRm1QVnU3UzlTcy9adDdxWmxm?=
 =?utf-8?B?YnEzdUJtQW5IY0gzS1RBY25GUktESm5MbUhGUHN4eXFwTWNldmpkeXFQSkJH?=
 =?utf-8?B?OU9nYWFyZ0tsWC9OTmhhN1QxWFk5eDFMaWd5amVrY1hLT3VXeXlPWjltU2Q4?=
 =?utf-8?B?V1R6MjJueG9iZDVkT1Q2QzRjaGdZYlVhditNLzgwbUpCaFhCTjkvTURyRXdl?=
 =?utf-8?B?MC9ZUzlram5ibVdhcXFzZ0dqYlRkUW8xZjhJQmpYSmI3aC9razNscDcxMUpw?=
 =?utf-8?B?ZCtGaGFzNWdQR3IvRmx2bGoxaVlpeEJoVTI3dkdRZnNMUmQ0Wnpxem12dnVh?=
 =?utf-8?B?Z21RWjhOa3czYkZKaWRKWHJYV0g2K1lrZTYyYmU4VlBZbkxpMTNUdEtieFNM?=
 =?utf-8?B?OFZzeUxnZmtHcStKSXNETTdTZnhBeGFEdEtybjdmanlGTVRCK1gzdXl0NDFw?=
 =?utf-8?B?MTFpTFdURjIyREdDaWk2VVBPVzI4NExCYWV5ckJkeXlxNEJ5VllKQVRUYnlO?=
 =?utf-8?B?VVRNVHFYMXNjWVQ2MGpJSlYxamhLUmxHTCt3Wmx1TjA5OVdQbEozOEY2MUJh?=
 =?utf-8?B?OHZHRWYrREsrdGlUYlNGcStZNm9NK1NQOHZzT0srbXBRNWQzTnZBTEhQVUxx?=
 =?utf-8?B?NlVaeVJvWEllSy95S0w3aU56WkoyRzdJWDNpbFAyYVRxV1ByMjJWUmtrUjhJ?=
 =?utf-8?B?TkI4eFgzeWdMWW9Nd3dTbmxNTENuTE5WN0VQdFFGQjY0VFVGTnFZbVk1Vi8x?=
 =?utf-8?B?eGdXMW5iN3AxT3NlL0hLN0VSb2R5a1ljai9tZGgvQ3pRaXIwbVk0K2NKYXFB?=
 =?utf-8?B?dFQrSURiUDVNREVPb0t3S2VnN1hrY2lzSTBNdTBweWp5bGtBVnhVdUZxR3Y2?=
 =?utf-8?B?cEtxMjZHY3RMelRLaVQ2TGk4bktNdXZvckcvcm1EYnhqakZuVUx0T2lObWtV?=
 =?utf-8?B?eXlPa0ZlQi9yMFFNRnR2TEJpWU9FVTNmWnJ3YkpQWWwwOWZnK08vbWM4T3N4?=
 =?utf-8?B?YVlXWWhGVzFqS01JV1hVYzM1M3diVHNOMDMzQ3l5OG9POCt1OWtsLzVQbi9Z?=
 =?utf-8?B?Zi8vRTBEWG5Wd0psbXpkSTJmdXB1WUtQZGRJd3puOCttS28weHAvcG5PRFcz?=
 =?utf-8?B?UXFxRUs3b1kwalh6QU16dkd4UW5LV1M0VnliQXVqeXBWTTQ4b21HU3RwZXBq?=
 =?utf-8?B?K3lrcWIzVzBncVdXeXZJZFFXWUdiMzRJN25FK1hwMEh2YzErTFlrQXBtdkJp?=
 =?utf-8?B?TkJhK2tPOFVGTmhUdkp1NGMzZzlmWUd6Q1h3Uk0zRXJOd1FCbUJvZ0V2MUx0?=
 =?utf-8?B?Z01XQmg0enowVGVMZnVEUXJjWFlGaklXSnJSRFdlN0JWS3hVdWRvWVdrQnRz?=
 =?utf-8?B?dko5YjVuNy9XRS8vR1ZXWHpvRTMzTWFpbEZJZWVvbGllNWxna1ZERWVMSm5p?=
 =?utf-8?B?dS9NVzMrSmM3bDYzL21Jc0Z2OXhraCsxRG5OUExRNDQ5eXgzL2lFcTR6VS9m?=
 =?utf-8?B?TTcwTjRxRWVXWG5xTUlQSkVMNTZYcFJOSHZUaWQ3YkdHQS8zaWhTRGJBUWRz?=
 =?utf-8?B?SlJYMzYvSWFoNEg3YlBVSnl5a3JiS0JCdnJQWlMxYXo5RHBXWTk4OE9TVWY4?=
 =?utf-8?B?WVFCNGc3UGlFa3liZlEwOEpCT2dBZUxnTWVpUzM1QkYrcElhUHc5V0lXSmp1?=
 =?utf-8?Q?BgmsQpuQd45r/Um+zGSp0McmcGG9mgPB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ajJsTENDU01ZQVpWMTdiOFZGakhJTkltYmUyeGxyNFBkc09DQVozMkkvUit5?=
 =?utf-8?B?Tm4xSHhySHlveWZZQmVEeDNUTkQ1d2gzcFlkdGU0RFh4elBEbTluWGpJb0Yr?=
 =?utf-8?B?S0NkVjJ0MzNDZnE0L2xINUdJVUVtMFRwTlVDbjFhRHRWYk1KUyt4STFNNDFn?=
 =?utf-8?B?cnh6QkczUmh6OGNJVDZxbGdTRU1KNS9xWEpzVG9LWWRmQXdRTkViWTc0aEZC?=
 =?utf-8?B?cVdPU2ttZ0habzhVOVQxVE5XWkJxQWtnNlpGcHVsOUVIeVBuZ2xHSUhMVDVT?=
 =?utf-8?B?SVFhcU9XSmY4dnZDK2JheXRRUXFhcmxmdkdVekxFdk95MTdkVWNtOU84djJs?=
 =?utf-8?B?b1pHL3p5U2REZnpQMTBsRFJmVHdMT2VFODUyNFROZDhyOXhmc2EvQzlxcVRs?=
 =?utf-8?B?VXZsaERWUGc0ODVjUFFhUmppZEdCYWNBZ2FabDRzWkEyODVmbk9wY0ZtWE5V?=
 =?utf-8?B?Tm5KeU5yK3FBVUJVQlBLdDN5dmZpb1dCcUQvZVA4eWs5a1ZDU21WOTdoMmxG?=
 =?utf-8?B?cjRzUkx1akVqbGR0MFJNNThhRUZMb2Z5VEhHVHpkUlRpbTFZUVc3bnpnc3Fa?=
 =?utf-8?B?RnlJUjJHdnBobFA3cXB1a2JYVU1FaXdmNUFHNzZxTGUvMG9tYWJxTkFRS3hs?=
 =?utf-8?B?V2I3Q0gzU3BYNGxJY0NQbWUxZm55SUltNW5Jbk5IQ0NUYVduYW9rMzhqQjZa?=
 =?utf-8?B?SXJGRHQ2NXNxWXJFZ3dKaFJ3REpZZVhBSlVUZTBzL0Q2UXV6UEd3NTlvSmd3?=
 =?utf-8?B?OVpmem00alB5TXBNVWdGM3BsRkFIYk9HQWFKOVBmaWNTMm1xdkZmRzZuUCtn?=
 =?utf-8?B?OHV0c25LbmRESjFoSlBjUlVjWlhxdXR4bjBEdVgyU25QZGZwYi83QVFyMmo1?=
 =?utf-8?B?YTI0N1ZSSHBZV0Z6NGU1eGJrd3NvaTNmaDIwZWJRWGttdkRLb0VpZW53NGpF?=
 =?utf-8?B?blhOZVZaUEI4MjJVSnFYT1hFWUM0cjN1eWRSSW91SFRIVU9GLzhhV2tPblB1?=
 =?utf-8?B?VTBqVGtkbE1qSkMyVzBORjZXTTREc0x4K2hhMTNQZDdQYjY4cHpXU29BS3dE?=
 =?utf-8?B?Z1FRUlh2Ky9xNWsxYUNjcG1PVVRzZTUvamgzZEwrV2Q0YWdlUGZITUN1dVlL?=
 =?utf-8?B?UWxBNTgvN1JnbTBMMzgvRkM4VjNoa2sybU03VFdRM1g4dDllcVVEcWFKdEtZ?=
 =?utf-8?B?Q1RESDdOY3FPbUxIcW1mZkJucW40c1ZlS3pPNDFmWUhzN1BOY2xpVjFTbjZw?=
 =?utf-8?B?OXFvWEdET2NZRnlmTGZCRDNoUTZ5dUpma2pQSmxIRlBLQ0NNV0RBcGxCam1N?=
 =?utf-8?B?V1Q1N1E2OFY0dktUOVluZnZETWo1SjNDSk52ZWlOSU9XSFcxQUtxazJ2R2ti?=
 =?utf-8?B?QXlJTThvMW9OYkR1M3hjNGVOYlRabXNaYW1hTklzR0NaTmNtVnZXQ28xUzdm?=
 =?utf-8?B?SFIxVXM0anM3NmZMMUlXNmJxY2c1RXU1STJibTZWakprMnN2dDNqZTZZNExR?=
 =?utf-8?B?K21SYlpTZGFFZDI2TU1kVVFXeWVEWmZzTEdIQ0d3RklpcWVlWDhUa25NZERr?=
 =?utf-8?B?Qzk3aHllMTk1SndKQXJvN285bVZ5Wkt4N3BJUnlNbWllY2tPMVVMQUducjZO?=
 =?utf-8?B?cWhnM094QjRBWklsTTdualFOdllMSzBaRy8wYWRtT2UwU1hlbXZVbEFGZEwy?=
 =?utf-8?B?SitqQW1PQTdDY011ZDUzN2tVaktvVG95eHVjUTgvazh6YitwRTVZejYzN2h3?=
 =?utf-8?B?SzNsV0NQU3ZsazZqSVE5U3NkMnN0emJrcHhqdktSRThtOGs0eXBnTHZhYWlK?=
 =?utf-8?B?cStxU3N3SWZnMzFlbkZtTU5GUTM1Q0Q2M0ZPNzBXMDFWOVl1RUNlUUMwOVkx?=
 =?utf-8?B?TFloUHNha0Mrem1jejBwNk5GYXNmY3diYm42cXlEMGYzTU5iWXA5Smh2QTk4?=
 =?utf-8?B?MUVyUmI1NkZsNG01eHFHaXJ1UWVwVEFOSUpjUUQwMnEyY3ZXTWpCcWVPbnF6?=
 =?utf-8?B?c2lYcHl6b21KSXlHdjVTTzZGcGxGTEhoK0lIdE92aHBUWmk1ZHR6engvUFc4?=
 =?utf-8?B?VmtNamttWTNxamNtV2xFdTNSMmI1a2swSzJrcFpoajhPTkE3RXd1akJnbHhP?=
 =?utf-8?Q?6lUifyoS0vDw4+GfyQt996DId?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YjnqkFC1mdppnjXKz0D/rk8u6CaO+nY6im4+OsY/dzviAb7X46RREQAm4HT7HTET/502WMKWlp5SZKc6p0booq3FqijS8DcW5kAdJbvCsQnv5WNykkELNUOdFeEeDeUgzwdOrd9JaHNN1peEtDFVsS02Z7PGz/VB7EhuoFPweu5AtQFA0HLYG/8kh31JfWx4yW9YtQIaKT7xovhmujmRhLOkzNPz3L5CJdPcsGYjo1ER61TsSAQuOZzHbwDSEI50Zn1Z/9Cba60+UW0ZTQnocC7kBwQbGPYnZ0q5Q5chAgymwnZGHdKi4hb/ROyvYEs15qqSIDDEJWwh/JHzDWmsiFXmvV3Fi+bslslTh50WVIwkJfZOEV4HiMNQctC56RSDv8PCrqSs4zsQ+iAzcyohq5EsPVUcjzLZ+W7yxu5cRivox2W1qJrxR73l6QXWwq8bsn28KMpGlGwJC1QtWjt22Ms3/LyqAQIOiSHSa1/ZHwy1acqURLjSoUZCc46dA+Cu4OY9VQKKNEPCNxlHbyWuS7E6JdxuXDsnSNEI3IEYeuraP7cuKa3FNe/yEVsMEF7hG4Efg3DetxUofTUzQOjdUw5VDz0Z3kHBQRHjh5lNjqo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80d9a6c8-9714-46c5-59f1-08de1d15eda6
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 09:21:55.3893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s+FSCT4QD+XEbHMw0tTj5Vh2K7584+6PlnqbSqlxJJ89cElvgj6yjaQcekahzG+Et4fCPi4nO4e62WtrEi2U8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7192
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_02,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511060075
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDEzMCBTYWx0ZWRfX+sLyu14pW8GC
 3T43Szv0SfnO3RovhU82pBx4OvPPq0mClhOHtP4PEIZaki3fimCY2AUz/bW+AT4vQMhTDL13TrD
 t0LPQwF+EAwOMkiIsIb0atAFf6ITva1i2ZTxTOplxBbzHGLvqquzs5YVAE+xBbx3OD3HaRs84Gg
 9iU+PZ/R9JBVA6xyEwujcOVEaUc6tp3rdigDR2rIK2IMm6khd4WKeEnFZT2ck4G+xwPsc2W3Ju8
 HKKGTDdoQzDFyU4YxCwY3T7G+yhMbTg/7NvMlcwNPpl5MYUXqqjSGRzorg/1wpVRwX4OKwgSjMd
 /DD21NXWAqlbRfP08v5OnMx281lGBUWeju6lEP1ytJKYy3eggSRvZXsRLF5kJu8oKXw4U0Vuab3
 XymAcmVvV1NVJCGriCYePwtLfK7exg==
X-Authority-Analysis: v=2.4 cv=R8IO2NRX c=1 sm=1 tr=0 ts=690c68b6 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=HLxmRMMJVmP-RQJGHGgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: FfGo2C3VsVMTDri8kJmmRx3-jlmk_qbQ
X-Proofpoint-GUID: FfGo2C3VsVMTDri8kJmmRx3-jlmk_qbQ

On 06/11/2025 02:04, Benjamin Marzinski wrote:
>> }
>>   
>>   	/*
>>   	 * Ensure that bio is a multiple of internal sector encryption size
>> @@ -3762,6 +3766,11 @@ static void crypt_io_hints(struct dm_tar
>>   	if (ti->emulate_zone_append)
>>   		limits->max_hw_sectors = min(limits->max_hw_sectors,
>>   					     BIO_MAX_VECS << PAGE_SECTORS_SHIFT);
>> +
>> +	limits->atomic_write_hw_unit_max = min(limits->atomic_write_hw_unit_max,
>> +					       BIO_MAX_VECS << PAGE_SHIFT);
>> +	limits->atomic_write_hw_max = min(limits->atomic_write_hw_max,
>> +					  BIO_MAX_VECS << PAGE_SHIFT);
>>   }
> Do we need to cap these limits, instead of just accepting the underlying
> device limits?

I was going to mention that I don't think that this is required.

> Neither of them are really used for IO.
> atomic_write_unit_max, which is used for IO, will already get a capped
> value from atomic_write_hw_unit_max in
> blk_atomic_writes_update_limits().

Yes, we limit the software atomic writes limits by what the block stack 
can actually handle for never requiring to split a bio with REQ_ATOMIC 
flag set. The HW limits are just what the HW can support.

> And capping atomic_write_hw_max seems
> wrong, since atomic_write_hw_max == UINT_MAX is used
> blk_validate_atomic_write_limits() to indicate that atomic writes were
> never set up, because no underlying device supported them.

That UINT_MAX is used as a flag to indicate that we have not started to 
stack limits for bottom devices yet, and so we just report 0 for the 
atomic limits (when set). I actually don't think that this check is 
strictly required in blk_validate_atomic_write_limits(), as we don't try 
to validate those the limits before stacking the bottom devices. I did 
hit it previously - I need to check on that.

> I don't think
> these caps will actually break things, but in my mind they make some
> already confusing limits even more confusing.
> 
> Or am I missing some reason why this is needed?

Thanks,
John

