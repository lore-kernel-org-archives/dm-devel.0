Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3827328D8EF
	for <dm-devel@lists.linux.dev>; Wed,  9 Jul 2025 13:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752067307; cv=fail; b=gAVkcWdPiGqGfbgDOms3s8NID9/yvZ7bqxDS7g2suZfax+CRfgXtUDxe0Myz940QOb0qln0eqfGLLo67E6J3lJhfEMskLv9iw2uHn4SjZDIwKcsaSEUl385krNdPgig5nw2payAx/K5jZSCgLunI4wGRk2DER/rOb1Pa2r/XfL4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752067307; c=relaxed/simple;
	bh=c74YW7DKiVt64QsPg6cMzycN1orcJdKGBHveg2ttvFU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Z3oEF2G3jbD8hs4Eg8Q3M8Q760PtpCyoqDM2rCAP6rKrte9EeUBEsM1u8iQt+MunwxUv8tCdCtlNuiumG1+YT77CtMfjBNNBjo8Xk76OsbnEnmjVwA1CgOLp3CEwn4XpXtx650uWG80HaFxvkgfY0NJa43AWfwjA0sqAaLOhkoM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XN+iN+oC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nlxQkiZn; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XN+iN+oC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nlxQkiZn"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 569CqRlP018743;
	Wed, 9 Jul 2025 13:16:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UcYGgt+0cNEPoQtt5mF9j5RENFbcXPpFyydfuBMg3yU=; b=
	XN+iN+oCtT1k5RaKTfSpU0xGIpOfI0RfpqUIK2igvo11K2bN+74rAcofBrjFhqU5
	4JoXNzO31kClLHYJCmgxFRqfVf1r0sDaUCzRCwtkbbFEJAC2UDyyLI8asETTirrT
	zrH3ZHsxgnzYS4YN6v7FStgZM3oV0t+tjOYSCulZfFeFQzGhLP9cmPRuTJpDXVbH
	B77U1naAtsZaUBp9d2aDt26nZZEcqPXPpEsnvwjgTaqyD+CJEu+Ae0E09RLn0Zje
	FaPICEfF9ASjJlCI/zzvR30vOSmwUzXaZT4GvkMnIpdUvvR4KxzneByM2APuIxz2
	VRNLw1siDVLj6WYRO2gxoQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47srt6827f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 13:16:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 569CgorU040565;
	Wed, 9 Jul 2025 13:16:37 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2058.outbound.protection.outlook.com [40.107.96.58])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgb73sw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 13:16:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HNQFH6kitlVzNjxGu2TCZuKRevgvdaFabW/jIf9V7rf0+zWgZg8m+RuoIrAXnoG+CV6iumKZ5BpMSiSe91tEsewO58/qCEVS2cIRzwdST0Fe9ZvxWBNu/v+lJroXGz8g0OlT3dzXulOjs7WhBDO5y5vb9hJbP/Lrgr4VHr1VWSXAf9l8rZuKoy+S8hnLiJ+0HbKQePKGo0wSdrBTrALbkTV/MtwVI9QJhfZMQK8BMNJk4gvlmdwAgK0/3lbcpQBBfIb7Hg0eJVTTcj5rdg5pQAoia08NDvc5XBy7SB6tLPbYrvBTTscPB9AjBnhRreGkBNz0E2cTzZoiv6+jYRlj/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UcYGgt+0cNEPoQtt5mF9j5RENFbcXPpFyydfuBMg3yU=;
 b=UN5GdA5S+hD+xKxdc9oF1FykGD629c+1RCi9soKlSAvDhQj+kPehIzPuGCwG+WKpjLmTQK090wfZG6EfvATDvEAZEq9jALlPauUGSI2KwggySp0dlG8/uC0VcTBeY8Wq1qJEGPsakZX0StID7wMjEXOkyNLBpTbZSPeyHDR03KagZlTPsIrwB5HcQmuyjm/JTVCe5UZtpSXnSsRDDN03ZZDrqOVt3IS8F7FrMordO9Vqfu0HEYT6MVmcqKrgmT2uU4HpfGTArd1hBRm+xXRaSHNuWZrF9A+MFinYvXTiIJ3sphbwkQuZC5zASOnGrSAKkvORz/4C0Ma+yl6TAVFpmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UcYGgt+0cNEPoQtt5mF9j5RENFbcXPpFyydfuBMg3yU=;
 b=nlxQkiZnbqECuiN5461hsdwEPDZGsI6AiJRqGlq+mv+DSpZJSvR+EPK0bBk0XjHtMdA56s2Z2zFozHrM/+7GX4n7ppIpmIXeS8GYp+2FibUL6siXVVuySSN2+UZ6BVr3z9wbT22pJ4hOxihQpBFG1oySd7aKi4DwObvCS2JUZl4=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by MW4PR10MB5861.namprd10.prod.outlook.com (2603:10b6:303:180::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.16; Wed, 9 Jul
 2025 13:16:34 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%3]) with mapi id 15.20.8901.028; Wed, 9 Jul 2025
 13:16:33 +0000
Message-ID: <4098ac0d-1558-4ca5-a873-275e6630ea40@oracle.com>
Date: Wed, 9 Jul 2025 14:16:24 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/5] block: use chunk_sectors when evaluating stacked
 atomic write limits
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, axboe@kernel.dk, agk@redhat.com,
        snitzer@kernel.org, song@kernel.org, yukuai3@huawei.com, hch@lst.de,
        nilay@linux.ibm.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, ojaswin@linux.ibm.com
References: <20250703114613.9124-1-john.g.garry@oracle.com>
 <20250703114613.9124-6-john.g.garry@oracle.com>
 <b7bd63a0-7aa6-2fb3-0a2b-23285b9fc5fc@redhat.com>
 <f7f342de-1087-47f6-a0c1-e41574abe985@oracle.com>
 <8b5e009a-9e2a-4542-69fb-fc6d47287255@redhat.com>
 <803d0903-2382-4219-b81e-9d676bd5de1f@oracle.com>
 <yq1a55edu8i.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <yq1a55edu8i.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P195CA0016.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::18) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|MW4PR10MB5861:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f124e56-f973-45a4-f3b6-08ddbeead35b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UDFnMjFuU3B4bWlxdjVWekFBNkpYeTVNZ0FQcHBrcVNBZ0xUTG50aGJDYzJW?=
 =?utf-8?B?ZDBxSmVUOUFFN2ZJMHhLaG1CU3JmY1NFNS9ic3IyVlZYVWVnOEp3UFRkWEZl?=
 =?utf-8?B?ZlcxYWZNWHQxdWN6YmJyQ0ZzZ3hMYlNnZFg4OWZpZ0Y1MC9jTUNjeERnVWpq?=
 =?utf-8?B?MmtOOTdGNnZ6WDlyRktmakppeUFWUHZBdXpvL01mcy81MXVPM2JLbnBCMUNa?=
 =?utf-8?B?eFJQVnZQTWNuRGF1RUZrNDMxQ0ZwOGZiY0JtaEZpYkhtOURhV1NQeXNMRkx0?=
 =?utf-8?B?RksxRHVocVBCbk9GckU2S3ZabCtBK2hBSVBiQTBWaWQwc1hHTmVaOE9MOGYr?=
 =?utf-8?B?SDhTY0FGZkVrNGZJa3kweDJVWjc5R2x6UG9PN01ZOGtYRWZZSFhkdCt6VElJ?=
 =?utf-8?B?MnFmcm8vZk14bVlpVml4L0VUOWhQT3YwZUY2ekN3VFk3T1h1N2VFUHJpTGcr?=
 =?utf-8?B?MWo4NEphSHNFOWUzN2xHUnZHY3hFa3FEKzJTSEtnMzNsSlFhQWVHckJtcW1P?=
 =?utf-8?B?L3JwMUx6alhxcHZIWnF1YlFtSFVBeDZSWkJkemJQcUh2dnV3YTRTSXVyV3hr?=
 =?utf-8?B?cFVXaWNBOVdIVnJrN1ZkQzlZbk1vRzVtTGRLOGRUbU5pSjFXUjlCZWRSTWFF?=
 =?utf-8?B?K0ZtZVFPQzZWMy9UYUlVc2pBS2hGYkJLdVFFR045OEhQRUhaT0plNTMycXRa?=
 =?utf-8?B?TUgwaWpraHlQNS9BVWZJSVFiN2c2dUhtVHAvM3BhZjc3ZWlrRTlkTGkvc1M5?=
 =?utf-8?B?OVVTeSsySjgxRlYvQzh3QzFpVVdBbksyaTFoUHZLZi91Njhqd3NPT093WUpp?=
 =?utf-8?B?YVQrOEorWXZiQlZDQzJIQUpsRGNhR2ZLSTk1TVJWZFNTQXdWR1lpSC9ka084?=
 =?utf-8?B?cXpPYXhacTdqVFF0M3UzMTZDUWNqMlR1NEpUeDNsWlFUQTVwYjdHSnpJUmFY?=
 =?utf-8?B?Q0RkTklLTms0eitnbitVZFZ2ZGRYMnJDa1hrUzBYT0tzbDVjN1VCUG9ZOVdC?=
 =?utf-8?B?ZW5DdDVkZDNCeXFUbkNWcGtrQUQyVlEwc1RqbEdub2svbVJSemdidTlMZ1Fr?=
 =?utf-8?B?MUlNZkdlT0JSaVpuYThrM3B6a1dXL2R6Tm1hMUVyZTVBenE1TWpWRVpRakNS?=
 =?utf-8?B?QmRSVUx4cEk1WTRKWkwxcE9aUHVzajl3eWlzdkpqMnFlTXdWSStjWHFMdmFl?=
 =?utf-8?B?Q0NGMWFCVjFEL3dZUnJSdkVVbE1vN2FZQ2NQbnR5Q0prMWx0SS9KeW4yOTNP?=
 =?utf-8?B?akNxNHFwSVZMbUgzdVpiVEpnU2RzWGpwMFJuemtzOWltQmhxVjltUlB0YUo0?=
 =?utf-8?B?cXplN1A1aFBha3RpSVB1OU1aRTFjQWlXcGRXbzFhWThLWWxrb3U4UTZTKzZo?=
 =?utf-8?B?aWkxd3R3M04wbDRLRm84RU1ycWZINnZjd3Zua1RPU1NveTVDeElHSUYyK0hm?=
 =?utf-8?B?cy9YZlNVMFcxWDJHeGtRS1ZaNUpvd2ZDYTE3Y3d6WDlyS2ZaRFlVc0dDM1Nv?=
 =?utf-8?B?Tkh4Y2xzcFV2S1pJYW5aWHNjS1phOGthTDFHNXdSL0hqUXRPdGRnOE4vQmZC?=
 =?utf-8?B?SjRoMmRUa1NXaU1QekNEcnFSRE9rSm5JamtlMzZnRlJaTFowcjRDbHJQc3Vq?=
 =?utf-8?B?c3BLUm5HQ3Ezb3lMSXg2ZXJNdE9McldseFF5eHpDTGNCbHZxanVNZFIyajE4?=
 =?utf-8?B?cEhiNlZTa0h4QlNJcGlmbDdSSUtRVWdRdDN4TnpLRUo5N3FXUmZ4blhFb2Ru?=
 =?utf-8?B?ZDNLNUVKS05LKy9QL2xjeWNkRzN3Nkt5ZEN5dHI4SkVNbWx5Sk1sUHduOGdi?=
 =?utf-8?B?QzZ1aFVOeGN3TzdRWE5xTkROcmJmZGozViszUmVsMjZpUm44NGdNbytTV2JE?=
 =?utf-8?B?VjJyZXJWN0pUSkNkUXJWTXRqTjNyZ3I2Z0RtREpZWU8xT3c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cDFDM1pxUE5TYTJHNHpMVC92UnJpd083azNVQUFIOWF6Rkc0TUY2K3JBRXZm?=
 =?utf-8?B?djV4dkc5Zjd3SnBnRG84czdzaHZwNFlNcUlMdTdvY0xwN1QrZFBRR1VBQ2xa?=
 =?utf-8?B?RzlrNyt3aXFQL1hCakNRTzRBbTIrZXF2dW51bUN2QnpST2QrRFE4MFNBVkg2?=
 =?utf-8?B?TngrOXZWejVmdTIrN2VRNmhyQWQ2bmIwZTNWQUh1MGRwZ2FjK29jQ1QzT0I2?=
 =?utf-8?B?RlFWUXV1NlMwSzhta2lkeEtyRGNiR3lyNU1GTVhxdlp6dDRPTFdtRURXa3Jt?=
 =?utf-8?B?Ukk3U3g1bUJWYlFibSs5MjBTc1RQUDFmZEp4TndSZUtIdzV6ZlNIYU9HMEFD?=
 =?utf-8?B?UjRCT2g4SHpOK1BFd3VOWWVXUHA1TmlTNTY2YXEwc01PbGU3L0llbER4OTNL?=
 =?utf-8?B?VUIvSzlyb2doNHJha09PUksyTUVxTGw5VkhxUlU4U245TjNUTW95c3Y4STdC?=
 =?utf-8?B?cUlpajRIZHlIYzE0WlNiTERsaElHN0ZRM1FNbmdKeFZmaXpkSHhpVWlMdFNz?=
 =?utf-8?B?NFhNNVlGMEIzZ3NaTGFMODdicEJtQUZrNFNIbTUvOHB1S0VUdkszSEtaV0xv?=
 =?utf-8?B?bEd6b0NVbHFNU285TUZLS2NTcnZlMkE0T0h6NjhCMExOYU9udVQzYmJQdDFT?=
 =?utf-8?B?ZWJiQXdWaDRVSm5ad1RkcDdDL0t0SVFhUEVWc1k2Y1dSUC9kdGY0bzJxTTNB?=
 =?utf-8?B?MlNtSEwwdXF5NkJBYVlQc1orTkV5RGtReHBLV3RxY1E0c2swNmcwelBoQUpq?=
 =?utf-8?B?T1VaZkNEbmNrSy9FYlptaW9EOHRNMDJRS2JxbzBZS3MyZmNGeG9XeStrTUUx?=
 =?utf-8?B?emxOQ0c1cDRGL3pYdmYzQmUzYkpyUWdYd3VoSVlvSUtyZUZHOEdUa3hQWERi?=
 =?utf-8?B?M2VBYm13NEhIT1YyZUJmNmlQck5zb01NWVZONTB5OTUzanJVRG9hbVY5UGlV?=
 =?utf-8?B?MUZ1OGR3YTJ3bkxFREo3dXVCemZhM0NyTm9wMmIvTjZSL1VYMlMrR2FkMWx0?=
 =?utf-8?B?aEI1RElNRnQ5OVFzbFJyVWMwMGFkcHVnL1FSQk9Eam8wRnp0WVhYUmNyb2tC?=
 =?utf-8?B?WEdnMnlJTkk2bEdFUVE1OHRuWVRsV251dmhLNWhNMkVEdWR6aGxFUXJQZkRp?=
 =?utf-8?B?RldqeXNrNUVDeHBpbDQzWEl5cUdRUU1qTlR3V05aTDVKUVhkbHliRkpPY1ZD?=
 =?utf-8?B?Y0w3YWh3TWw1TUFoRFlZN1VVRDZURUplUDZNdERJWThhbkRzamFlekV2UXZo?=
 =?utf-8?B?TDZGK0NURk84dlJVamQwZU9tUG1FYUZSZ01OQVNSYU04UGdRMHNsMkVyZ3FV?=
 =?utf-8?B?a1dtY3NmOGJhWFpxTDlmS3NYb1NIL2FPNEFIbktPdStRQ0M3bHFCYkp4V2dn?=
 =?utf-8?B?ZE1IWlp3ZDVpQ1VXdFYrcm1sVFREN1pNUjRPSXBtMklmTXkvQjY5NW40OURn?=
 =?utf-8?B?MEhUb0w5d1BMczM0YllEME9hSWo1Y054MmJRSnN0a3V6cjBsaUVBK2pZWm5l?=
 =?utf-8?B?YnBqY3F1SWRHNHJrVkowN0I0cGk4MHVXYjArNUNmdXp3TVVlSldiNzAwT1pn?=
 =?utf-8?B?MWszY0FNeGdCU3Q2bi9VcXExWmNTQWl3cnNhdi9VN3QyTWNPd3dJL056USt6?=
 =?utf-8?B?SmpudDVTOGp0NWpBeERZejZRV05IdDdVb29CdGlORWtEKzZ1TktydGlpcG9m?=
 =?utf-8?B?RjgzVUFDejN5dlVXdnhZQmlHSTJFZGRzTkZPbHZRNHlEVHlmR0pXVWI2dlU3?=
 =?utf-8?B?MDJxYkNyVU5pOU9xUmg2cmhMSmc1RVhlL2lpSkRkZENXR2tWV25DQ055cHNn?=
 =?utf-8?B?T1dGRGZ0VGt1T3VVZjZ5b0ZtOHl6Vk5qUzZwWGZ6SEU5UnpzMDlEU2FUZzVS?=
 =?utf-8?B?enVCakttalk1MDNqb3p1U3pwdjMrQmpXd25uTXM4Vm1MRHBVV2dPMjNIcm5l?=
 =?utf-8?B?YktMSTFaaFJFTTVqc1JTWGJSL214dUUyVXVQNlhHQm5JZkhaaFUyaFRSMGxm?=
 =?utf-8?B?TWFlRUlZQlNzNzBsT09iM0RLaTFUV3Y2ZitORzlCQW5jNGdOTFdzbVoxb0U1?=
 =?utf-8?B?dUNsd0EzUm1VMThEM3A0R2dOa3Izb2s3dVRYc2wyaENlWkRHayt1TXNuNHVP?=
 =?utf-8?B?MzZXK3Nqc0JZQUQwWUtGa2R4VHJubVJ3a3ByRG13RWxqazVsME8wem5DVm51?=
 =?utf-8?B?elE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nb2wjarureIOw/Usp2K2wk24uRB6mpX/tguF5pnMKyfb8LazkUkZ8KrKBYmfIejDOvCWDdamGy7WlakXvuLILid4wa2bqRYraVZUp0V6IwokedeTzVb8EVBGpYAGheNqlVLJbDM7T1X2AQzNE6iCCsH/3TullFCH7ml7951ltMYvkrwxHT6TWO+CdhxtekHnMDhQqRzrjRNanHIu+Cd92dBmBvZuD2aKLAnB6ZmBPdz8py73Oze5i+78i3NzfLYB8pCaarNcTS9wckpGWlxiuEPVVERob+mxXjd929DKKUi5czVej+mMwGc+UDUD0wI+rfE+IMnY09rWHhpBbNKywhOpKstA4mF2K/etEJKwV0uxKcieqWxYr+vzpsWOJB4v35+8kSlQdZFcfD423gjRnrrzTtiKT/b5oFfbHZhs9eJ0gPO0FzCs8juEU1mIJfwzD2dq9pkf+hHJMeOic9x//gjUpbc2ppyESmRNI2k2HCyXBRpdX9SYFRdi8M+lL7eVMMC93VpZOYQ+gcvMpe6vXNH7S+FFzDvdOEI52swZ8oXgzsRDki+We22b9sqUNX8MwKnJdCGVmdkahOLKP/gqTA7gdiI68KpexDj07PaKQTk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f124e56-f973-45a4-f3b6-08ddbeead35b
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 13:16:33.6689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hVTN0gP0V5K6UpOaL7mkwPlWQnZr9h1STyaVjxzX511pg5RfVDyQK3ffFwGY9Qvm4iKgWA/09rSGzzninnmMdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5861
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-09_02,2025-07-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507090119
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA5MDExOSBTYWx0ZWRfXwCOuavi5f+MR 1JeDEEMPMoLgI86+sRDlW4XfTPzuSrB94QEyyfmcRi+P5nQ29zEq/IaHaP6UbCaJhnQLZodL3JX p6TlOQh0wELUuf4/FLkF2yljr3IJNYTejKFuLhbhxNitdTgJM5kTYWN9qKVms2ng8fyz5+vCwws
 x8PxeLZUJMt13ML5yaLnRsulMNtuBQkMXLaSvD7Vg6czjAsUBb3dFiChAy/zFr2ku0//1i0r6nL 3LD1Ajruo/b+RJLF2PTDmxonaLIN8cDZqM94SUqgSO/2KsAze+M1NXiGbJ02QtZSld/jIW8ObJC uF26HoGXg1LeZgVsr7EtALTyN66/toVi0O3+yWQJkZQ7A/ACnDnIWVdErOjEgLmxNBuH9fjl6x7
 G4PUPnIUCDg6O4NaLaDvyceenWuvU1zbP3V/FzQ++5+fxEKWqtAOIILda/vY7b4JuS9HY7j1
X-Proofpoint-ORIG-GUID: rjUqPRxMINzRrXvpy9jP5qSnB_sO_s4V
X-Authority-Analysis: v=2.4 cv=WIV/XmsR c=1 sm=1 tr=0 ts=686e6bb5 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=ofuVaQMgaN6fenXXJMUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: rjUqPRxMINzRrXvpy9jP5qSnB_sO_s4V

On 09/07/2025 02:39, Martin K. Petersen wrote:
> 
> John,
> 
>> For io_min/opt, maybe reduce to a factor of the stripe size / width
>> (and which fits in a unsigned int).
>>
>> I am not sure if it is even sane to have such huge values in io_min
>> and the bottom disk io_min should be used directly instead.
> 
> The intent for io_min was to convey the physical_block_size in the case
> of an individual drive. And for it to be set to the stripe chunk size in
> stacking scenarios that would otherwise involve read-modify-write (i.e.
> RAID5 and RAID6).

And the same is done for md raid0/dm stripe; I suppose that the idea is 
to encourage larger than chunk size writes to see the performance 
advantage in striping.

 > > io_opt was meant to communicate the stripe width. Reporting very large
> values for io_opt is generally counterproductive since we can't write
> multiple gigabytes in a single operation anyway.
>

Right, and so it seems counterproductive to have chunk size much bigger 
than bottom device io_opt

> logical <= physical <= io_min <= io_opt <= max_sectors <= max_hw_sectors
> 

