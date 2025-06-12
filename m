Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0FA1E51EB
	for <dm-devel@lists.linux.dev>; Thu, 12 Jun 2025 09:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749719783; cv=fail; b=ULugUw5w+e0E1jSu4+zZ6piqs4uL8abk6OUO/XnGX96JrWlymbvX2qBeqpbl2O7wd4s6N9mytBG+SPuqJJiOX27P5Abw/prFvWyyR5cxgoxzS53pARZFN4EBTtaLZ109gYCBFS/4xiFnXcxxLAEtY4GC7pdSAaJ0HbWvh9orzKI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749719783; c=relaxed/simple;
	bh=nxlINzYM2E5Nel7J5KrYXHNdmt2gp1fNbhbAYzN+zMM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=czR+CzG4C4u8YTW7rg0H1lluDiyfGqPa4SdXpNuKXIgHl8TuovHUlYtt+ZRZRb0SxH+LUS0+DD6rTvW4u2WuPHOB+SkcAB8dlf0/YQeIxdXoC7eWmTzAB5VV6nMT/vHT1YcW77OYsf/lClRrR3+ftD6QaxNZJWNkypVbIBDZMsk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rk0rimkR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=acJFg+A3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rk0rimkR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="acJFg+A3"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55C7fa3I022106;
	Thu, 12 Jun 2025 09:16:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Kau9E4KcPpDfyycoLRCSXdbVKY84XytLlNBjk/SPx7Y=; b=
	rk0rimkRDFhhnGtBGVdExJY62C4bIkALnxxiS6Y7Vb+5jEepq6NLgJcLdcwEyilA
	RuXHZFLWwdIezzpGt0vShk3e4MUfcItErDVU1iR8IspJKC+WiRyyRyVHWgYrC98x
	kI5xoIz6oBBhv+pe/ant5yKS2Y68aCHOW/d2rYW+xWYp/+UmMehshk/a3Mch/jZC
	67H2/1YxYtd1IGc2pcMqfwo8XoioR8zlSz4mCNF9gJy/cXdHSM3LCPupmdIppjVp
	AckByavNVuKBBMFCKzj/VEaH+EQDevKXbZ0STtdf5XdaqesKex9GXiZS7BTEqlly
	P+U3XKwKQW9qw4XvSm1cWA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474dad96g2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 09:16:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55C83tkK037907;
	Thu, 12 Jun 2025 09:16:06 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 474bvhjr16-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 09:16:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=conTOW2P3ERA8vwpSOrxZ+NIAcm1kVULj+PUWZ4ntsW9vDnFyoy+EIU8hTpux5lTvTiwedN01VAS196eOzAHbq5MXvgGMcDhY1q/Fe/CdnHzZJWGPV2HB+wL5jMuGGd2Lskgaq2LZwFamGbJqh9YuBrPmt0ssQpHLauYuDK7fHFeqimD7xZ4V13CCg/7U0R1UvCrgidavpOcROpzQLtPTt2t4BbNcrpfrmwYu9nqwRSWyAGpPMcFqHekPYtU4qYrC+D0/6laHa4yrgqyPzGguSuPKqMtrXqpNlN0xmHo0mUHxu1f+1bXCgzJBfGG+OFAo5pNGF1mP1+lGyIV0RjMMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kau9E4KcPpDfyycoLRCSXdbVKY84XytLlNBjk/SPx7Y=;
 b=khiJDudE/5aMUeVTb7TRnkTjYWc8xRBs0Yi8d60ZwkcQVWCddbOX4DnpJfvApVBrveJQPxLvvIDUGE09xWqsPK9A/IghJEtvNvvHyRdg7ofxKmOb7X3yKeMMqhEdyvtloP77dxIxKcp0+VGxvWU+IwtPDhhsC0iUwB4C8z3jpw6BavOHmjIE3H+Ogg6HMJTT5AOjjlyKTC09scxNV1qUZ9M6fy4Tz0M+zCL+2dFAJbCouN8dTKpcry2o51G41JWfVIFWLP2op+bWcKlL5nlUjGGe7ehMHXN9yMk1tu1Q0nGA4COML48Ss+02ZbTE0QOoNfH87zw2BIBb4AYkFAx33A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kau9E4KcPpDfyycoLRCSXdbVKY84XytLlNBjk/SPx7Y=;
 b=acJFg+A356xo6FK4sLPzYPVuy9z6sbzJd7xP1iwFn2SPcDJqxGMQFZh4jGI5T1yqP4XlNngQING0qZwbdCjRrlusegecwpQjhK2Kv3L6LyBogDAdOOFnbrKQSSKYQao4pAuqJYsFAhOxSMiPms6OrvXpsuCY8J0Z5kn4KE88mh8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM3PPF1D4534BE4.namprd10.prod.outlook.com (2603:10b6:f:fc00::c10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.31; Thu, 12 Jun
 2025 09:16:04 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 09:16:03 +0000
Message-ID: <c216f57a-3d9f-4549-9ed2-4dbc2b2330d9@oracle.com>
Date: Thu, 12 Jun 2025 10:15:59 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 3/4] dm-stripe: limit chunk_sectors to the stripe size
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: agk@redhat.com, snitzer@kernel.org, song@kernel.org, yukuai3@huawei.com,
        hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com
References: <20250605150857.4061971-1-john.g.garry@oracle.com>
 <20250605150857.4061971-4-john.g.garry@oracle.com>
 <e7e147a8-f22e-e420-1497-5b31be9ab4e3@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <e7e147a8-f22e-e420-1497-5b31be9ab4e3@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0302.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::26) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM3PPF1D4534BE4:EE_
X-MS-Office365-Filtering-Correlation-Id: 881ec64f-b28c-4eaf-7d94-08dda991c137
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TFdHbUlRMXBZMExBYnpYZWQra0toVzNoaDVaL1hlMjFVU2VocW5OS1VyQlMr?=
 =?utf-8?B?b2pqSENDS3RDU1ZhTzZOT0ZJM2g1ZnU5ejU2bjU1ZnUvQThFY3YzQTMrTXpJ?=
 =?utf-8?B?U3RXNU9kMXpnbjlqZndXUC8zVlAyeEtrSHFvRU43S0lML3VBTm04c1NQak1o?=
 =?utf-8?B?d3BIS3dSMlo2cTJldTRxN3hBdENEWFhWRG5EcE9zd3I0dXF3bDNObU1nQWxV?=
 =?utf-8?B?eVZyZm1RVkpSd2lYTTM3OTFlbUZ6ckQvdklXWWFNSHBhZGUwVXN3c2szemN6?=
 =?utf-8?B?bm9Ybys5RjQ1TFN6YjZxSmp5OERKR3prQzRLVktSTHYyZ0F0YnlIUGh6TjZF?=
 =?utf-8?B?empIcGpvN0JnMXMveW1UNTZ1WXZ0MVk1a2MrRjU4U3hHNmdBSnphOU9kaGtl?=
 =?utf-8?B?bE9WdVE1TXlCZE1na3ZlcHlUb2NpNUMyL2xmWkJyZ1lxLy9KOXdMaXRqV0xz?=
 =?utf-8?B?UUROUXNKd3EyNzVlNitVS3RPR0FzUEVRampUMkgzNHU3d3VuVEdlU2tRcE1t?=
 =?utf-8?B?bksxdFNxQTU0RkE0UDFUempwZVgrSElmUzlwSGVqMThPS0dld2l1NEZ2c01U?=
 =?utf-8?B?VlhjeVR3RkxJK000elV2MjZJbkdETjI2TzNTWlM3UktmTklPQVFsZkVaY1hY?=
 =?utf-8?B?VU5ZNXBMbmJwalE1MllNbDdwd3drTklXNjkrVkN6Y3hPT3kydWphR25FWGoz?=
 =?utf-8?B?SWlFb2ZkVzM2eW96aXNtcU1KK3BuNklwQzBQQTM0czMrNVZnQjlRRGZ1N2hB?=
 =?utf-8?B?STNTQnBMYXBJcVo1eHljMkwrdWxKSWFZNElSWDNpZE1ES0N4VWlIdmxlZUZU?=
 =?utf-8?B?d25adFNkc2hmNENoUDBNVzdCYVNkVXR5eEZHdW5XS1BVQ0FYSUZYVzd2ZVJ5?=
 =?utf-8?B?VHlVY0ViZG9NMm1xM1BvL2xHN0EwMHJmbU9pZUVwOHZ4NEs1V0N2cHJ6QTA2?=
 =?utf-8?B?emRWYzc5WWNHcVdQNlBtdWdmSlZocWhqS01GOE5uOEdBTCs0bEFoVG5FYmZh?=
 =?utf-8?B?L00xZTJwK0liK2JPNjJCY05KN2xyS1h4Y3MxS1pJcHVFOHc3bk5YWThJMXJj?=
 =?utf-8?B?enh5ZGF2ZUpVa0xHWTZDclpkN3RuN2tZeFdxMG51UEJVVnlUQS91Ymh0Wm8z?=
 =?utf-8?B?RDMyc256dHJHNmFZQzFJTGpiU0Npcm8yWERBcVBEMFpJS1RjS0VLRnlzMnpI?=
 =?utf-8?B?ZE1LNEZ6TFpqMGVaVlVPZUI3RENxeXRPZ2JQMGx3dUhNSitFMGVPZGU2dHdG?=
 =?utf-8?B?L3MrMStqL3NRd1FnRDZPNGNmMUlGUHJjR1NDVTVwTEFUYWxmdm5JR3ROdnAw?=
 =?utf-8?B?TlZEbU5aUkNrY2hDdGdYbHZ5WHpCSi9laWV5MFo2THdXbm0wc3V1d2hqaUhV?=
 =?utf-8?B?dzllbTYzM2QyTWdHbWF5NTQ5dmZYN0dwY1pLRUJDcWJ2QUk0c3ZCNXhZdlJw?=
 =?utf-8?B?TmZYRXIxMm9maE00ak0xTGR1eStMMUlBNHBwL2ZpYW5WN2pBQWJLa1ZIa3VG?=
 =?utf-8?B?YnJiQ2VlcERjR3NwS1Fpa0RUanU4K3lvL0JKRXFCTjJkaWlhcUh2bFhWcjkz?=
 =?utf-8?B?MUhaZmg1SlNqT1FIYjl6ZFFrYm41UVFSQVBGTlZpUThBT283Uml6Ny9KRTZB?=
 =?utf-8?B?SFdXNHhKRFJ1dkE4Q3lCYmx0by9yU2JsbVNKSE1IWHN0OGlPY1YyOCtXQ2R3?=
 =?utf-8?B?L2FZb3MzMkNtd05vc2F3NDI5am9sVGpMUVA4M1IwWHlCNDgrc2ljU2R4M0FG?=
 =?utf-8?B?TGp1Rm5qWEtmUERlUndlZm5XeGkvQkJFMEpUUkQ2aGgrSVhYUjNZdVlqWWhq?=
 =?utf-8?B?THZkNVkvU01CWjhnaFd6Wmh2ZmFlSC96Z3FFY1JQNDd0RTV6K0x6VlhuSFNC?=
 =?utf-8?B?V1pJRzdpSUlBdXZwUzAzUWJ6RnJQMHAxc0NHcG5QOVg1M216aWVETHlVV0xC?=
 =?utf-8?Q?1Ik+46kJxkQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YXErRDNVS2w4NEd3bXVkcjZXRytLc3RTZ2o2VC9rcmg1VGN6MUl6eEEwendu?=
 =?utf-8?B?MU4vOHRtaTBKOExpMndRMWtzQU84SnRkd2VVSVJCenV5aEtpbWZiU3I2Q2g3?=
 =?utf-8?B?N1cyS0pKNUlOdFFrT0FvM1JNditVZzJ3ZUxwblJ4Z0R2VUE3YkNjUUpKM1lU?=
 =?utf-8?B?aFZSempsa3J5eVo2dFhZN0dJekhIUHk5YWs1Vmx6YkhqK1hIaHJiMUFrQ0Yv?=
 =?utf-8?B?VTg1WW5qR2dyU2VzMjlSajRzdVRFdnk0TGtLeHp5ODBGY3RlL1l5L1Z6OEZj?=
 =?utf-8?B?aHo5bXNoY3dQOWwwaFZ4dXJGNElST01JeXhtcHdEUW9pdmVmVnVpQ3hLWGhR?=
 =?utf-8?B?M20zTkxFQW1xRHQraXdpbUxvemlFTXF5TU9FNVl0OE8rbG4yb0hWQUs3RUp4?=
 =?utf-8?B?UHBKaEV1aW9pa0lQSEN3ZnV3WmpRbUJOdVNhYmNJdHdGdGM1a0h6NG9LamF1?=
 =?utf-8?B?akZyUVBrMjVzUXk2L3J5Z2thdkJZMFZUZlZDTFBEc2FycnJnQ1V6M0RQb2Fw?=
 =?utf-8?B?Y0p5cXRoT3kwNk14ZkJvQXVtbzFUWlArajhiZ1ZodFNFUVlOQkFSRHkyUDlZ?=
 =?utf-8?B?NzN3WS93YVNBUFpsYktDcHVEcG04N0R3ZVljeHFDRlh4cm9MbjI0QzlWazNK?=
 =?utf-8?B?ek9PU0NEeXZDWUdVanNWRkF4V0Yra3lZZUd4Q0RVR0tiaGZqNDcycnppZVd1?=
 =?utf-8?B?RHVva1lDMW8wbmcydCtwZ3BxLzdPVCswdWdBazhpRWEydG00WDE2RDJSWkNE?=
 =?utf-8?B?K2ozYmtxbTJYbEd6YzkrUGdycTl2aU1JdUtRWU9JR2VNL3pwTXh2SUY1MnE0?=
 =?utf-8?B?TzIxeThpYmFMTDZBa2Z6TUdpTmtab0ZDUFVYZ1FFclN1WERnYVM4MmlqM3Jz?=
 =?utf-8?B?d1RHM3JXaVY2Y1JWTXpmSkR1dXc0WlNlZnBNMXRxQ20wQ0lycXE1RTlRcDRU?=
 =?utf-8?B?aVE5dzJoemhHY1haaGJFUlhJMHRmV20zU3E4L1FsRmhLdzFWbm5YTjRYUFdY?=
 =?utf-8?B?T2Q5MUVVQXA0NnNYZm13OHh1VGE1QTMweWJWb0JFVmxOY2p4TjdFY2FRNDM2?=
 =?utf-8?B?U0lLY0dQTy9mdmxhZ24rekM2MUlzUXF3UWxOSmtMSUo5RlhGejlKNHV2WXor?=
 =?utf-8?B?OEJYQVJsQm93QlJEWnN6QmFXVVg5ZnVpNE9kYnNack1rUHB6NlBlT0kyYlUr?=
 =?utf-8?B?V2k5aDR5ZVZYc29DS1NQK0xUWUZJKzVGK1BoSUJuOWRlcVNrbFV3OEd2bWRk?=
 =?utf-8?B?cUtlZEEvSVNOWCt1dmc1KzdBcTg0dnVrV01wckdmd1lVbnpENi94V1YzOHpO?=
 =?utf-8?B?YnEvcmtubEV4WHh0ZnBxUjdvMXhBN01DdGp4QWt4b1o3eXNGOEpvWnpiNmwz?=
 =?utf-8?B?dXp6RURQSG5RczR2d1RsZVorVjQ0bUtmcjlGalpBNm5RY2dLL2VOMkRzNmVx?=
 =?utf-8?B?bXlQNUhIQ1d5VE9JdHdBMDhMM0VlR2FwQTU4WWd1S05kT1R3TnNRdEJuNElZ?=
 =?utf-8?B?dXBwOWFCQ0tzSzZpalVqbVBvdXpnakZaT3lQSGNRc1d1czRLaG5NZFliTXNM?=
 =?utf-8?B?cE1iaytGRm4zc3Ewd2RUMi96NVNoSzN1UXQzazM3SWtuZUpCbDRzYWxTZUVa?=
 =?utf-8?B?RHJabThaVGM2bHlESnRoMG5nZEYyRW03Tk1vSTZIMGhKM3JVUm4zTEQ4TlYr?=
 =?utf-8?B?VmxGelNRTTlwU2IwNlY0ekJETlNES2M1UG9BaFNTQmdwYllDNHZtRnVVSzNR?=
 =?utf-8?B?ZzhKZmJ3Q05BaTNsWW4rQXRmOGlRNTdGMTdlNm5HR1ZuZ0Yrcndib1Q1dFVI?=
 =?utf-8?B?L0gxWEh1ZTZpdDNCK2t2dUkxMm5Rd2swQlFVZ2ZyWFgwODdVaURLK256NmRS?=
 =?utf-8?B?RGxvbTN6V01YWFU3cFhmOVpzYWtxMS9XWW1JWE5WKzIvWlhHQjhaeW9mVUMv?=
 =?utf-8?B?ZXpKa3hsWTl3anF1d2JZVVVTRWNkUEFWdGk2V1h0TzhWZ25zeDNzbUtncy9C?=
 =?utf-8?B?Y0FLR2hvZ1JqSktxTjNkRUhESDF6QWNjbEptUDRCcEwxYkxBVzUraDVFSUxX?=
 =?utf-8?B?RCtUc3pYa2lFd0owVWNyR29zbmdtTzZReXRjd1BkUnRBSDBjZFE0OUZIQWlH?=
 =?utf-8?Q?Ez08xvjVG94YWyeguUJZQuW7A?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	z67DGW5UY46yvXDjpZ6nGFnf8h9jY/aZDwCCB3PbNgJVbA8osuWC3MMSNrbpICvdATb1ZeGrC9FV00fjLIiD0def2AanVDIUf73+CzV8HxEJqJbnbNKr3eJ/5t7s5UGZ9Xkw35RxrhxhZFb05MnwAHSNVGx1XLtCXdLVxDjfU8GQT0js3r2BzV8uepTFmuAELKbM0by3vnQj9VBMSvASoLMcBmBfI0OJ3fbWgHQfpgUiiso7pNaxPaolmsi7HZ/QzVULhsbufOe6ddkIRyNvgY+zVBWfsbdieaTioMvl/YpZI7K9wYBGZYRGk9fCe6q94V2t8gICxxCLLQ88KeVjGZIo0Mg5Jp2A3JTkTb8FgVux/+vNEgPGLxSorvVz1UbDR6JAWW2BsK1X8DMYcAE4nPc+43fhxM2E32KVP0t8lr2KTJhkMO+ZM9kqkynixkH0KDeOoITl+KRthWL6U0EJQsSGLy53TdXQSBoK9I+vz5mYIJfDtR1zNoVMk+Aw7ngVbTZ75sYbUKoL9NK+83KcQ1z5NkCg+NznQ42A4/xmCYxU2N4mSbCiBqWzWEZYmHxhOHefIu8iqIzUTgoNOo+TTKvPrwXC1Q2560kphdeZj24=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 881ec64f-b28c-4eaf-7d94-08dda991c137
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 09:16:03.6337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ELBp0wuDaUgJDFlQZMz10A64rCA3ZmBWJxNZmmJGt1JJHdUyXqmNNKRN51AqZDC6PiFQiUbkYnCAq2Ntb4vFIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF1D4534BE4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_06,2025-06-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506120071
X-Proofpoint-ORIG-GUID: 2lDiBXWKFBlx6shIDbJP3jM94-PSWjzz
X-Authority-Analysis: v=2.4 cv=EJwG00ZC c=1 sm=1 tr=0 ts=684a9ad7 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=k-88YjR21PCFb7npTyQA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13207
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDA3MCBTYWx0ZWRfX5xFGc8iJz4xy 0lqKV/xC53ywg4vssBjCi7hNeBQmu6F0WcaJQ44dZfssPebYvD658ckRPCbq+FU+Ydx+qsQUnmt AoX68ombpSaB2bVp3inEXLRErLMJj+AwqvqN1OcD1G1Q4XWmmXyqLElB7OukYkCgCIo21LRod8t
 8pGHYt/+o94W5C/QNBDfXTrBOQfuVr9dB883khlVdk/17vRBVd3Grb9eRfzXwIt5ZAkaTAiwYjd Dj52iprCtlFvJ2UgEqBi6QoGtWMQyo1VEAMrqLY+uPYbubFVJc5RRBCiIyrayQ+dqWW4vGgKsL2 EqlJkQ0BX6E7pnF9FYjIy8BRxCgGDv2+dJdjgIlm5+sv/6o1W0bspJic2KEwpg+aEdl4rHXeLbe
 g1hjOwzmBNeUSgJpcEeToZeNRK9zRagQz7cAhA0YeBOeFKTc+86rTGILJAmyUMqGwzmWNw4n
X-Proofpoint-GUID: 2lDiBXWKFBlx6shIDbJP3jM94-PSWjzz

On 09/06/2025 16:19, Mikulas Patocka wrote:
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
> len is already in sectors, so why do we shift it right?

Actually what I am passing is not the proper value at all. len holds the 
sc->stripe_width, and that seems to be md dev size / # stripes. I think 
that we want chunk_size, right?

> 
> Could this logic be moved to the function stripe_io_hints, so that we
> don't have to add a new flag for that and that we don't have to modify the
> generic dm code?
> 

That would be better. I am going to have to change 
blk_stack_atomic_writes_limits() to work for that, but I think that code 
needs to change anyway if the bottom device has its own chunk_sectors 
(as Nilay mentioned about 4/4).

Thanks,
John
