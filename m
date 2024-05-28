Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C79B16B756
	for <dm-devel@lists.linux.dev>; Tue, 28 May 2024 10:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716893696; cv=fail; b=L6lBnWwyFpWA9IX8KHZ9+zTUsHwzmzIZrb7Yp0PQ2/k546Y/tyw7pPND36U0+WAX4QDwEJ4cWvpg8J2kwSutVpIFgXgD1oQLxYk31Ec3Q4bMBQQq9TMow2L4UL8L0eOAfLEcIe/vuo55R6HnZN5N+RRcfiXzNNLOBmG0Ea19bvI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716893696; c=relaxed/simple;
	bh=z8OBKFZZ5JbiXIu2px8MkQfqekeTJNLpxJdodNFFHoE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s7POnOgilHvLFWzydk3GNhu7B+I/z156awyVzhBOscZ9RJgyCaKqLZnvGDcEkKwwPBZMai82neoyrw7u8eVZzTBzfeyCOrvGRprkIvVd1LoknHIs9rwgoCjm3xNTd2ymy3H52y1az9uH7jo4RDcUV8MMmjWidraSp0JEWZyHbxU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44S7wkBA031521;
	Tue, 28 May 2024 10:54:50 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-transfer-encoding:content-type:date:from:in-reply?=
 =?UTF-8?Q?-to:message-id:mime-version:references:subject:to;_s=3Dcorp-202?=
 =?UTF-8?Q?3-11-20;_bh=3DcAb7BtJwc58y1wdWATG5IIxxq5sElUdwYvzuMCCt0Ps=3D;_b?=
 =?UTF-8?Q?=3DKrGAOQHdm5cSNiXLDb6Js3BapPffQGza+omXCzw0gotPF+8zIrgED9CfYpt1?=
 =?UTF-8?Q?RAKtD6Eg_+3hTw7IKtvSuP3Pyk5uEJnFhvjNw3K/niamABPtfr5FYz3x12gpJVf?=
 =?UTF-8?Q?U79ZlxsWsjO6eM_2aoMhump9F0w31hxxKFMw7OzaSh2b4JeA0vZGHWNV9PzQO2m?=
 =?UTF-8?Q?wqGmQI8iwzlSQv0VF22n_bvuO4j2YIaWC2gEqDn1LZporw0a6HSGMbYwT51TFB3?=
 =?UTF-8?Q?5r1QtWonQXvp3NKIz+VY3hHTeW_nLR5oCeVY2Gjrv7HM9HI5PGtzweBxUX9FQ1Z?=
 =?UTF-8?Q?1qJJQtvFD0Bm1Af4M56A1nveJG8Ckuer_AA=3D=3D_?=
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8j83xrv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 May 2024 10:54:49 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44SAIr7W013204;
	Tue, 28 May 2024 10:54:48 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yd7c3vy3s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 May 2024 10:54:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DM4cjlp3Jd27pBFCtVvrryNs2yTnFPP+s9vuW+q9ARmbfeutlknPJfRKSWUQQ1UYdiADepNlAJchOytQYEoQ4AKr+NJcJWeguDHOTysmQpmCjg1BBMGQyq1jQ10Mw0/KC8S22pFUiFOHiYthNSunm0531P6DVDGKX6nOFTmX9tpHBlAtJfSv8Hh6Zasy8Db5eU9YHDIlQFwSWyjHnXlrxgA0atq9lJRBHRxwkHTAAv70Y4CmQzNNcTg+6WTvdvF5GMxB0a17bNFjndOdAji7izgKTyiWXM9Vo3QcU7fSqrtaf4Rp2a0BJ8pAAWOv2Szq8QRI39i05j5fajiCwXRziA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cAb7BtJwc58y1wdWATG5IIxxq5sElUdwYvzuMCCt0Ps=;
 b=IM9+46Ga3qKbueesE5tdr2u2h9grhRoM3F4unNCUwpZ3k1UeHKwOfljNIMgD8vT3Ad/16aM1ZpfFgUrgffkVLUFwn88ip5Ak4+4nGZR4fFH7LGdUI7htOLn4Arw04Ubi699EwWzGomJ14bjt7l6TjG3XqawpB0IWNFkYfk1JgNAakdlVqDFgBSkx93P4cmHyIpqYPBjBmkcaLHpXhcXvuOMQiLjpol6YAy1ocZ/e+CRTpTR+5cE1R9WxXZ3Em89aX+ppurJXfa5qkISoVMYUQ4llQjd+tuTJtLRQjWzVPGHNiBg2n3oGHOqfmC7qxljC1NZ+Z+qpaRJWfFIgpdNbTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAb7BtJwc58y1wdWATG5IIxxq5sElUdwYvzuMCCt0Ps=;
 b=uM0LTwmY+nPGVNGPTMjKHZvwDSOCg0sZfFrAhRduPxU439H7l+oqYmfrsT3txmFUahB1gSWVQnl4TjQ6FElwrKu2ADE7+kY3l9XhzkMDL0XkOMqgR42Bc6Gay7vVFc1gaL/ofAFOOItR3l6tBIl3n8cw2GQCX7OLuh6CeoLOyFA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB5546.namprd10.prod.outlook.com (2603:10b6:510:d9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Tue, 28 May
 2024 10:54:46 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7611.030; Tue, 28 May 2024
 10:54:46 +0000
Message-ID: <acf3e39c-36ae-4792-b870-26d392be5241@oracle.com>
Date: Tue, 28 May 2024 11:54:42 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2] block: check for max_hw_sectors underflow
To: Hannes Reinecke <hare@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@kernel.org>,
        linux-block@vger.kernel.org, dm-devel@lists.linux.dev
References: <20240524104651.92506-1-hare@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240524104651.92506-1-hare@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0184.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::28) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB5546:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d123e4e-eaaf-4db4-d6a2-08dc7f0496b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?b3BZSHNLSXhSWDJUc2FYQVZjVDgxQVAxS3lsN3U1cnJCNDhuR0ZPUTRaUHAv?=
 =?utf-8?B?L21BVVZrcE16TUhGTXFNSVAzL0V0eW01ZmFjNFI4NE11MDBuU1dkRDk4OEh2?=
 =?utf-8?B?YmIwT1RZQWtWYlp6MUV3L0YrQlpaTk1yWVpjelpGYnRUL2Y2Qy9JRUU1SEUx?=
 =?utf-8?B?K2paZllGb0hCKzNPZDNDZkNRTFROV3NkNnFPV2V1Zm1BM1JXS2FjVFZ4ZFdQ?=
 =?utf-8?B?a0JEUnhmakNmUUx3OGVtTEwrOG83SlkrbkVSWEJYd1NJZzdNMjlMbWFKdzBZ?=
 =?utf-8?B?YU05bHIxSDR3TVo1MC9NNlBsMVlTMkJjMTFrZlZXdWFCdnhNc1F5VmNWTzV6?=
 =?utf-8?B?eTNvMWJQR2FnQlcxVGlyTmVPUU93SXZ2TWVsN2VHdmtVem9Sa0FyTlAxdUZU?=
 =?utf-8?B?NXdBdWZqMGhtRHpCL2ZoRTNKR3dwSEtTVGFSWHJ4NHpOMkNra1FSejJwMUhv?=
 =?utf-8?B?dWI5ckhEZEE2TWREaURvM3VPdkFlZWU5eE1YeUtFL0l3MTJMUDVtSHBaVmpw?=
 =?utf-8?B?bnIza29mSHg2dWVBWndZK0l2QlFIbDJEQ0VLc3NHMVB1QmJkT0hlUUp5b0s3?=
 =?utf-8?B?c21wemVvQ0MvcGpZaHA1R010VDJoMDNkMUl4R0RZVE9weUkrcEpqTmRtZklm?=
 =?utf-8?B?ZG1sNW9MZTNXcmRFOW5QZkFYT0tPYjRUVkFiY1pqK1VYVUYrb1VXaUtnOFRs?=
 =?utf-8?B?RmRJbjJxdjNxWTl3dDU1bXo2Y1pwNVdVRDFMOGdOQSs5OExKaytqVndlWmhp?=
 =?utf-8?B?bklFeFN1ZGZhTFhoRWhjY01vbnhlRG53cFBORUdMUElZaExmeVZOZDF2TzZ0?=
 =?utf-8?B?UVdxSEpaak1NNjdXRTd2UmFxNTBBSTlDUDlUcEpQNlVkWHdxYmxnaUFjelZD?=
 =?utf-8?B?ZHZRM0tUV3orRklkSDlDUk9JZUFQdGJTSVRURytueDdab2lMYVZRUkZXRmd6?=
 =?utf-8?B?WnBlWHJVV201d0JYNUpXTGVQazRKYnN0dDZHL3lPUlJ6NnpJRXZUYVIrTDlL?=
 =?utf-8?B?V21KNGVoZWpveGpHVEtheGs0OWpZTU5lVUR1QzRkdmhYYWNsTG9NcU5vczY3?=
 =?utf-8?B?cmxKZnZpMDlCaWxyYlY4VVpsaHhsdC8vdGNkaVQrQTM3bWlyL24reitGWG1V?=
 =?utf-8?B?WTZzeXhMRkpWVnJyVUZwS0VRR0MveEttbk9zaXVFYTA2ZEhMby9ZWGp5M3BS?=
 =?utf-8?B?VkZYNWdINzN1aUVtNjFLNitaWVR3Z0liRjRNK0dCdGc3eWNRUGdtREtoa215?=
 =?utf-8?B?UnVGL0UzRkowQ1p4N3VhMGJlZG5xeHppcFZEalF2SDdUT29JWDNCcEgxWGtS?=
 =?utf-8?B?U3Jmc3pWem8rYS9jb0V6dlV2ZTZqTk4xSWZrLzF5cFoyQjRWcWt5d01pRG1N?=
 =?utf-8?B?TnBHWitYRWZ0RDJCOEpKaVlMQnBrT0w4b2d6QVhkZ2g3OHNZNzZ4eFEyWkxS?=
 =?utf-8?B?U3RLRld2aDN4TWd1cVljUWhESVVxRzZHajV1S1c3dWR5T3F3ejR4MWdlNEVT?=
 =?utf-8?B?UGd2Tk4vZ2JnL0U0Ti8wZUt0akF2bU5LN2Y3ZVJDMU13WExJa3RYUkl0TmI4?=
 =?utf-8?B?cXYxbTR2N0d3T3hsREV6RzNWcU5vSm52eGhpanM5NEtScklsVmkwS0lLS1Jv?=
 =?utf-8?B?bk1EZjUwaTU0Y1k1RHRzRWxSU2REWklQekdEVFlISk91dkhHd1NiWDJmbzZw?=
 =?utf-8?B?eVJVWnBoUFcyREFETXNJUnNocjFkQzJ4M3pyeEpwV045dll2TGNPTm1BPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?eXd1eWhrT0xRczNVem5uTXQrSG12WmY1Z2RDd3NIblh4YUlpdjlpWDBJRU1L?=
 =?utf-8?B?RmVTVGQwSnlBQTVzdG9jOVlTVGwzYWVjWk5XWGppV2VJUzhXL0h6TGpVcFNa?=
 =?utf-8?B?dnAvOXBtdDlKWVR4NWRqaE1KMW9WSXhJNUV2R1k0bjBPNG1nQnphZzFDZWFP?=
 =?utf-8?B?QzFUN0tyaUVDdUlFZEFqZEN2dlYrUktzczVRc3ZhcURrcXd2NlFEUC9ZZWJO?=
 =?utf-8?B?VWtKU1dqTTN0dVg1ZzlEWERkLzhqdXlhWXdlYzNmOFdJMVFDZE1DWjY3Z0s4?=
 =?utf-8?B?YVVXNERlb0pxd2dSaEVhVWZmaittUVl1dTl3WU5HS0JtWEIyTW94WjJ4dmtu?=
 =?utf-8?B?blRRSjB5Qy9qSDcrZE5tejh3OTBzcmFiZXA0M3c0VG50djgrZnBuT3lKUkRK?=
 =?utf-8?B?Uys0c0VLS0ZLU0xXcUxzODkrb2VXSU50cExwaXJLRWVXb3RqaEFoN04vYjVJ?=
 =?utf-8?B?MGlYbnRDSXM1Q1djN1dMNm8xQXcvQjkzbU9vUndWR1pMWUFKeFdJNThVSU9p?=
 =?utf-8?B?cGxpRmFIdjZ2R093RDBOV0Y0VlJOWTF3QXorK0NBOHl3bEdhTExDRCs2VzAx?=
 =?utf-8?B?d2pFalhnaUE4NnM1M05LWjA5L1M3cmhsYVZIcndTQkdEWVVzak8rRUJGSXBa?=
 =?utf-8?B?S21DMXYxVy9OaTA4dHFTdE9XcHJnVmJlYUhTWVIycWhkTXVwOGlKaDMwVjNU?=
 =?utf-8?B?bzdvRjZzOGsxa01OYlZOMHFMazhMNDJYM3RiTEN2c0VmdVcybWtVWGpsUkhH?=
 =?utf-8?B?SmlzajV5QW9DbVZhMWEzUVBiai9samhrbkNrdk9nbWRaM2w1bzQweUtBangz?=
 =?utf-8?B?aXlpRjZqR01DZUdFN1Y2Y0lZMFozT21UcVRrTHBxaDlCMWVtd1pwTTBFOXNw?=
 =?utf-8?B?VjVhdTdJamcwcm5ibVY3cENMR2hXb0dLaUQ1ZFVRSDhmSnBydWNUZTVhTDNW?=
 =?utf-8?B?YU9uRmM0ZkIrbU40emszSmU3YjFjalFpSUVvaXBzVm0vREdqVkxtS1RkMlox?=
 =?utf-8?B?YzJNK2c4WHhTRW0wcDhqRHh3SUl2VTRsVXFrcW9MRHdoS0xrL3dYRDIwMHQ4?=
 =?utf-8?B?R0RHRkxVUW1obFhJRXhDRzNsSXlmbmN2dWN0VmVobGlxN1NMODFYcE14UFRE?=
 =?utf-8?B?Zmh6b0grNVZ2OWltNjVsY0IwSUVDYyswMlJhMkgxc3RQeCsyUkhidDY5KzBM?=
 =?utf-8?B?bHFtYU1aMk9uVFkxUmVzdUI0VnMrcXZsYUZpc2IvQ3hVSUIraFhYSEo4N1hv?=
 =?utf-8?B?N25IKzh4MVNDeWtNLzdLRDRnWFNkTC9GTE84V0E1WWp1ajBkbEdiUGIxWHYr?=
 =?utf-8?B?eTNRa3hVRGxWTFZnU1E1dUtzOWhkUmJwaWJNdXZkSnE1QXlzZUVUUDVRcDFH?=
 =?utf-8?B?OExaWmcwQ3V0OVFKUHQrQ2kwTUg5cDE2eTB6cmtiZTZwQm9HOUpzd0VQajZ6?=
 =?utf-8?B?bmhrUE1xeFR2amNhSU5iWHNKUEttTFg3L1hrbFFaVjNjMWUvK1JuUUI2SE5R?=
 =?utf-8?B?aktzUWlQZzBoYk43WEdQcHBKQ2VCdllUai9udythdkFPZFJWd2tVNndQemRs?=
 =?utf-8?B?VTR3bVhSUW9HcEUxQk1Vb1NZQ216KzNRd2lvOUtrU2NRZSsxYkhFWFhIc0tU?=
 =?utf-8?B?SG5KZWI2WGVBTEE5Wi9ONTlQQnQyNkhTL1VvTjJmc0lFVEp5Tlk0RVFQaGxU?=
 =?utf-8?B?UmpYeVZqTGlyTm9heVMyd0lkL2ZPcXdWTWRnT0pEY0trUlowVGJrMWlTSUs2?=
 =?utf-8?B?Ymd5SzNyK1p3Y21lWDg5dSs2cG04bzFTdEdjaUdsQ3JZYTNZa21VU2YzVHkr?=
 =?utf-8?B?cE9mWlNoWFRsTVlNUU52Yk84OTJkOEJuOTZaZEdIMU1YeGVFcE8rS3ErdVZV?=
 =?utf-8?B?Q0FHenA2bWRwRGRUNWFETnIyaWhJbUF1aXdqNS9mYzdRMit6UlRFOUZ6b3Ux?=
 =?utf-8?B?eWdFc0RNRUVHN0wvWkNETlRGRFlSS295UFhDdkxKVytMRjk2WHBTa3dOOVVt?=
 =?utf-8?B?K0ZiNElnQWh6UWUxMFdDME1tTjdZcmZBbk5TMGV2U3JmV0x2U08xU1dBdDVr?=
 =?utf-8?B?NkdJYkpCNXBianc5K29SZ1ZUN3JnQTZGQmtsY3N1TE5iYTVsSHNVWVIwZnZ0?=
 =?utf-8?Q?7aGN0a4DiFIOEYW3ozyW/bVtv?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	4HN6yXPYJompVpTJT6xMZRA/Eh70pez+cWU47Zyhaio7idPkw89anSmrkfywKvS7p1xS3wENdkCQseAlBrqaLaPXtCNAEP/pCDHsS3wAYBRJvoY6Mobp0S1n2VWZoE3Ck+/flfD6usNR3A2eHVYOKdS4d6/lMqanJ49SgvY9Hdyp/0O8DoXIqImMs6O0TJVkkFgR8UEKhc1VM7W305oVfkdic14/WKMckKzobpqxNnyCK0tHNgTrKws/fv1C4a3c7cNLg3f4ZzJKdJHTa8zn7MttZYdgTTmLGncQvDZ3TkWRb5QgzMMzVQQYndPzX3IC2WKDG3YV+HgT8U9QqTpJp1adUUH1zR1IwnzMbIHrGMq6Dbiz98fRMTRo84eR8T11msFT0jFsiazCpbbHVJNQx98a/puImuKEmWkcqSIfPYK5X4AM93uk8IAAa8j8YJ49HXK3ywn+uV+rVdPUfN7DVdLAW8vTo55okNwxNkQz6Krk7jfaLbrkdLmgMI5RPnfdWVTYl2fHRaSmLX0l0AWn0gndvkmifHbRplxconrfzP36vWJjS8yT59Cv+NvNO11CE/caabeHvVzpZ/NWlZkR+Y4rNyoSvw4gYcNUR1g/ydg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d123e4e-eaaf-4db4-d6a2-08dc7f0496b4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2024 10:54:46.8342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T7fYxAxNXq1Fvx9J1lYqhWUDUfv5g1RLVZL6hDRi5kkpxPHEO1YQc4nULdDPpRzg/gKkRjH6fo+WoJd9zR+40g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5546
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-28_07,2024-05-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405280082
X-Proofpoint-ORIG-GUID: K48Q6zvX2dJdsGjBl4UUhYT-0NnsMo4n
X-Proofpoint-GUID: K48Q6zvX2dJdsGjBl4UUhYT-0NnsMo4n

On 24/05/2024 11:46, Hannes Reinecke wrote:
> The logical block size need to be smaller than the max_hw_sector
> setting, otherwise we can't even transfer a single LBA.
> 
> Signed-off-by: Hannes Reinecke <hare@kernel.org>

Regardless of comment, below:

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   block/blk-settings.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index d2731843f2fc..030afb597183 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -104,6 +104,7 @@ static int blk_validate_zoned_limits(struct queue_limits *lim)
>   static int blk_validate_limits(struct queue_limits *lim)
>   {
>   	unsigned int max_hw_sectors;
> +	unsigned int logical_block_sectors;
>   
>   	/*
>   	 * Unless otherwise specified, default to 512 byte logical blocks and a
> @@ -134,8 +135,11 @@ static int blk_validate_limits(struct queue_limits *lim)
>   		lim->max_hw_sectors = BLK_SAFE_MAX_SECTORS;
>   	if (WARN_ON_ONCE(lim->max_hw_sectors < PAGE_SECTORS))
>   		return -EINVAL;
> +	logical_block_sectors = lim->logical_block_size >> SECTOR_SHIFT;
> +	if (WARN_ON_ONCE(logical_block_sectors > lim->max_hw_sectors))
> +		return -EINVAL;
>   	lim->max_hw_sectors = round_down(lim->max_hw_sectors,

I don't think that we ever check if lim->logical_block_size is a 
power-of-2 - but that's a given, right?

> -			lim->logical_block_size >> SECTOR_SHIFT);
> +			logical_block_sectors);
>   
>   	/*
>   	 * The actual max_sectors value is a complex beast and also takes the
> @@ -153,7 +157,7 @@ static int blk_validate_limits(struct queue_limits *lim)
>   		lim->max_sectors = min(max_hw_sectors, BLK_DEF_MAX_SECTORS_CAP);
>   	}
>   	lim->max_sectors = round_down(lim->max_sectors,
> -			lim->logical_block_size >> SECTOR_SHIFT);
> +			logical_block_sectors);
>   
>   	/*
>   	 * Random default for the maximum number of segments.  Driver should not

