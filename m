Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1544E18B47D
	for <dm-devel@lists.linux.dev>; Tue,  7 Jan 2025 17:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736272763; cv=fail; b=eHqz5NVB5NGk/2eVlomtkLnkcTQrl0S3hw2GI+fuPZ42aisgx2coowhtB9hlgY6OZv8Ubz+IyDfi9rQhoThTiJyQTpFN7wKOGlryuybjj8C3vXFVwvIJk7tRN1bSKpkUQ0SmOekl8Kki48XNJnq0JGX5k/S8yQinzY/+1/VgRAk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736272763; c=relaxed/simple;
	bh=0YOK0Bc4gQjSgWzKagAulnOK5pCl76x2O4EVJtCLgE8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=t4DzJpJAsMvj4dNLP7iCXCopzEiG1D2VuJ5LTSO9vzspQvf0uTKZ/StzNkebrwhMZpfTiBtLBwppitEPYhSb631J7Y5zqrD6VrJVLItVJuLl2Wsy0FRLOEcJlI5NXB5M7wpi156G/ZRQ/mRHnvyR8ybswxXzsRged5qw8PV97Vc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nQK7ZCtF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WIhThBy5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nQK7ZCtF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WIhThBy5"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 507HMtUE010800;
	Tue, 7 Jan 2025 17:58:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=DvlvRIqzvRYH5zHAX7UGaFoLH1O6pPMffuLTncvWAcE=; b=
	nQK7ZCtF9/4ID0UieRR0DCnGJ+RLq74T0xyag2PTPRLc7XKp8OJWX8BGcq11vpyI
	8WW1DZLMPlBj9IqUtozwuT7+mRvqtER/j9ge8DNJ3W+TMFFsakTCzycaBZSuR8Lf
	8wgnmpYwRJ5Xd03K/j+K6pjt2GyvAgcH6M3J07TGjPglGkKN+M2nXMFBLgcM0Pp3
	f7mIg7x946wX8bf/osQPHSIeUeZy0aMg4v/0UEZVLEP8minLKYoXLbBVSmGutFr2
	31JzXnhNIVUMqfKYYe6xoX42v5uZ3oPJtYvRdcM8+pShBnZ15p818i5HZBInhcEI
	6fguJAMOwN9Q4lmzc2VBtw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xvv9517c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Jan 2025 17:58:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 507GdH3T020040;
	Tue, 7 Jan 2025 17:58:16 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xuef428c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Jan 2025 17:58:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hYPAh8ajBNm45xSdTEqZ82Ats9iQGPM4uyKiR0BoZcI8f/JcYVoRUuAHeQRhgzf7lysAyU3vZMWMg3zIw2jx/Hr6kWMG8jeP/nIbZ3TlvPlnn+13yD62OR/34AOG6pHRH66SAmAJ9ONywSZum1/SBl4XF0481mawe81Fx254dyASSg8Jm8i52bEzk6pmfFZ0N9mdSs8CjdpO+yzLb29gjiPK9RP+bRqoFOynDOTyz9a0nLV92E1/DJ9p62dbGhvT/deEW4D1AyA6pu13OlyO+GAZd9AP+fTjAi88ouaLfTcOkT664Jda6sEQugoall0R/XcUgn4OviAC6zVNMI5WEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DvlvRIqzvRYH5zHAX7UGaFoLH1O6pPMffuLTncvWAcE=;
 b=R67ex++zlA/lUBSvedEHkdFuj1d9/5QrYgFdTrbYLAACQhkYoiUefnXVc2IqDm9PtJBiRjLwvnsi4XTIXqawQFwN3BBh3mkzdM4HE4Zx5IBxlmdz6H4MZnRTLvOj0ApvFaJpWxUO/Z/H1GwjpZEbkY7GsER02UFwF8C51K95QXyO815nfhq4HJst1q/DawsY8wrs3czYYI85BErnz72VQZpPLzB0onbAFP+Aunop4esG/rm7VRDUlNd3vSZrHFVS0ZxcZzhb+5tP3HEls0yqe64oYz9LDzdZ5vtd2IamSX9E9fXMvacLPTJB9lj144wq1rSR69THcKpE0OVTQNYunA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DvlvRIqzvRYH5zHAX7UGaFoLH1O6pPMffuLTncvWAcE=;
 b=WIhThBy51UJHqMBxhzzTH9T0RaM6b51LaL0dIuIWCyQyInPsUbfEINVP1hu0kXuPSO6i8WAMuFsMvN7BxjYV3360sEBSZivAgDWitHMYthe6aNvP+pBnm+HTjgkAfmJwx/3YQHUEVz1eZlkJQwiUfn8Xw22Qv6+feWvlf+gBZTs=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA0PR10MB7326.namprd10.prod.outlook.com (2603:10b6:208:40d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Tue, 7 Jan
 2025 17:58:10 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8314.018; Tue, 7 Jan 2025
 17:58:09 +0000
Message-ID: <ca18486a-a171-43a9-b0ff-638a8ed3c882@oracle.com>
Date: Tue, 7 Jan 2025 17:58:06 +0000
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
X-ClientProxiedBy: LO3P265CA0023.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:387::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA0PR10MB7326:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fa309f9-240a-4abf-8cd9-08dd2f44d8ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QTdITFE3ZElwcWY3aE9oN1hlK2JKQnZScUpxR1Zna0lTR1FDWlpSUXE4UXZn?=
 =?utf-8?B?cFFUemlCNmFFT0M3UDZlRlFUdllLb3c0WkVxRmhtL0l2dm82RkxtZExQZHNX?=
 =?utf-8?B?WUVtWUcyc3hTU1pIa3dTWkJxWmczVGJvaDdYOTVZQm8xQXdhVitVZC9iYld0?=
 =?utf-8?B?NEpMSENIaHhXWUV4d1ZScEZhaDNJMXFjL1NqellLQ25SUnhFRzlxbXE1d2k1?=
 =?utf-8?B?dVhjS0VmZzA2eUdlbHdJSzlPVHJyK1FiQThlSUZCcXZKRkVOMzR4Szk0WUMw?=
 =?utf-8?B?N09iTlBRUFUzdnBvUG9aZC9mNkptMkVhVkYwU05QNEQ4Vk5hRUx0Njd3Wm5v?=
 =?utf-8?B?WlBiWlpkN21xdDlVUDZqV3VHbkxoVktzU2dxUDJSSFhSWGlVMDZ4OFBnSVBv?=
 =?utf-8?B?UWd5RnUxYlRaVXIrRlZDSFZYTk9CN1BYcTVpd0RoR2RxbVBzbmExRTBTSXdw?=
 =?utf-8?B?SjdnUWxpTTN0TkY0Z0VnWEhzR2lMM3hxQ3E1Sy9aUGlnTnFEQ0hvWjQzZHlN?=
 =?utf-8?B?VFhQZmtiQ3lKQ1V3eDQrWDFjelROb0k4ODN6d3ZmRDRzQVFPTk5EdnRjQ2ha?=
 =?utf-8?B?cjhBTFV1bC9UTXlSdHd1RENwVERhV0hjeG4valBEZ0c4NGRkRG9vc2xCSWV3?=
 =?utf-8?B?ZG91V25HRTdyRXc1YkxlVzd6ck5FOXk1N1R1N1FCU0lKL2VmdW5TU0c0bkVz?=
 =?utf-8?B?bCtJalBaeEtNclZKdEtmWi9nNE14dmRIZ1FpTjNHbTFnM1FYaEF4WHFKQkoy?=
 =?utf-8?B?aWJGSFdUc25uRDR4eURaTWZSc0FtTHcyemszVlNCbWFXUkFtakZWNHh2ZHFY?=
 =?utf-8?B?OTRXRzIyL2FRUlFmK3NoMkVVdVArV1V2WlV6N1E3emVqTHRBTGxxNHpZRzQ2?=
 =?utf-8?B?c3pkdTZTZCtPVVN4TEpycTB4K0duQzZHS0pXaEc4K2pwWE9KdS9hajRQb0cx?=
 =?utf-8?B?ckFxa3dLcE1ZZzQwYTlDUlVIQUwrcGlibm5EdDhockxza1pyTHNmQ1dja3Bp?=
 =?utf-8?B?bWZnSnlKdERyRmJjNUFRMTJabWJ1K3lSVWNyaUVUU1luSzNxM0w1UDNMaktr?=
 =?utf-8?B?RFNwQ2ZITU1pRkdYbkRvbFVBYjJLTHRxMUZzRTNnNU8vMW5OcjJ6OFlrQjN3?=
 =?utf-8?B?NWg0cHY5dUdxZ0VWVUlGNzRaSk9wSjc2UDZWOC92Ylo1R0hqSDNJS1dxeXlx?=
 =?utf-8?B?VTdnbU1iQ3kwWEs3cXpVbXBueU96VnhxNGxRMWVPU2RmaCtNVTNUcXNERklx?=
 =?utf-8?B?MnhoS09RQWg5aFlVNVFpZ0cydldIZUNZTFhiRTQ1UlRSTVlZSklrSmJyMHNF?=
 =?utf-8?B?dGVSR3VtUjFwSVFSSXFJaEJoQk1wYjJvQkpia0dRbkNod2UrZjVubjFMZ1JB?=
 =?utf-8?B?eUdWb3VyNCs3WUI5UjJmYXM2a3lrcEZ2em4rTkNQKy81Q09aaWpXbkl2OWxj?=
 =?utf-8?B?QVlobkY1a1Bya0w4QjJYejVVdW03SVovRHlUbVVpR00rblBNMGdDVkZ4T1NH?=
 =?utf-8?B?aldmc1ZJaHNFSThuMnpydWYxUjhEZGQrRnVuV2JRSHJPVjYxNVRhcllBZkcz?=
 =?utf-8?B?K1V0RmVEcFlXZ3ExUTZzQTdqaThuZDh5R0FNSTJ2U2hBVXk5bFVpS0wvejNM?=
 =?utf-8?B?ZW9BRVk2RXE3OFNPNWdSOC9UM1lXVTB6cmU4cnZVSjBNb1FKZnhDei9aZG9Q?=
 =?utf-8?B?OTBtQ3lZTGdtaGNqRFlIUGlkZkErdHpkc0hzandBRGRGem9OQy9LQ3Erc1A4?=
 =?utf-8?B?VndZVkpEeFFneGVMUUxONExjMU1wNitmSHIvMisvRTRqNmtSU1g2K3ZZcUxY?=
 =?utf-8?B?aElDb0ZEWDNiQzdJanFkK2pKL2JOZ2M2cko2QWEvQVVUUVErWlNycFJoeDVa?=
 =?utf-8?Q?WkKnhNJrPmHzZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RFhEWGhsaThVZlRpWERPVXdXdDRwaHgyUitZMGtjSEo5YVd2WE9ldENOY1FE?=
 =?utf-8?B?TDlYNlVUbGFLN3BJYzJYNTF3cUJTb3VFRjNrN2pyVDRvRkpWTzBTam84RWhQ?=
 =?utf-8?B?VGVhaSs1UjNUMFBRRnZRaytzcy8xbWNDU0lhQStyc1ZjV0FxYjlYZ3NVM0N6?=
 =?utf-8?B?cEhQeFV2bTU1RTdXc201MU5aRTJuQ2RicWRLMFhyaEFhTVdFcSt5QjFvZXRP?=
 =?utf-8?B?M1RzYkN5SGdGRitwOUloNXREZ2NQR0dkSlBDVlRwS2Fic0pEbjh2bjcyRHph?=
 =?utf-8?B?ZW9EZlNUY2hyY2tqYlFpc3ZidnVJcXRMZEdOaDFHNVNzS2hRRWphajhEK2ZQ?=
 =?utf-8?B?RW1NZzJUajdCZDNGUFRaL0tpZVJJbG5MTkdJMlJkNmZIeHVIbitHWjJCU3hx?=
 =?utf-8?B?aXdacEZ1RjUwZmFldjNOQ3hqT0s3aVpyNnlpY090OUhMUWQ1bXVvZ0UzK2hP?=
 =?utf-8?B?UHBrV1dCTWt0M3VGNVFmS3JLTzV4aVhXdXRqVmlIbGRtVGNlOXNDbTQxN1Nh?=
 =?utf-8?B?R3NSV000anJHUmZybXNEQjdYaVA4cmdLbUJkVllSeXU5SmVBZ1RxalduL2Z5?=
 =?utf-8?B?VjUvalVrVHUwUHNSWkFxeUFqOU1aTTd2dkY1Y0lUdWNydGtiakUyanFPakdX?=
 =?utf-8?B?cXIrN2gvTTJDY1RaUmlKa0xLUXU5ZVJLZk81dXdxV0oxZ1N4L3pYVWkzL2JI?=
 =?utf-8?B?NGM2bmlFU1JjMWgvQ2lhZVNHMEdYYVE5d0VXYzJhUFJhS1hZNGU2dzAra0pO?=
 =?utf-8?B?bWYwaGxnYXZrYUdsZXVCVXNOV3doL3ZuYXJyTXh5QkwxQU0xVG5sVlNwdUI5?=
 =?utf-8?B?anNLeU9wNGxwNHdVWEpsVUJLWVJLeFViZUQ3WG5mTDNjVlkrbTVvdmozcWdy?=
 =?utf-8?B?UjRlNFRsaFUwRGFjN3VGSnlDcUdhUDI5NWJiVmJ2OGhhdi80U3lBaUYya2tZ?=
 =?utf-8?B?WDJnR0tYc0dvMjhxaGRQQXZIT3VEQ0VwNmJ3VjJrWTJ5YjBseTRoZVVsRUhC?=
 =?utf-8?B?ZGU0S2hsSUF6VThIazUyRjJsVkU5Y2ZVaUtjcVE3ZVpHbUNGR2ZYSzlzQVc0?=
 =?utf-8?B?MTV0cng1N0pTN0YxaUEwR0xpY3l6Q3JkaU5HMHgwSk5xcVBjNDlpang4bG5T?=
 =?utf-8?B?aW5zTWt4UEpiYlgxSWhGQUkvSTl1UGJ1MkVGSnZHNmVLb1FyTW5ZZS91VFFv?=
 =?utf-8?B?RXNwckYrK3VtSHZqZ0lkanVrVXdhRlAvWVhpR2FBYXpaTzNqaDBwNFE4cnFN?=
 =?utf-8?B?a3F5WGRlSVZDc01WK1N5T1lob200WnNNdjlKMU8zbjg5Rk1uNHR6WlpZWkJp?=
 =?utf-8?B?aG9Bb1RvSFJoVTRYTm4xVHErUTRZSW5pQWNGd1JxYktoUlZVRFVocUk2TnlQ?=
 =?utf-8?B?ZHdGQ09GN1RKNjVwcWxvZXRHSTRoWEUzVSthYWQ1ZGJlUlhPMEdtWFgrTGFT?=
 =?utf-8?B?RzlHZmlITEZiMnpYKzFkbVFBM1pBTHEzYVZZSS9jdkgwUHBuVGNVWWN0OFdP?=
 =?utf-8?B?Z3ZoQVpkb1NaZHVDOFFGZWNLdmd2SFhKRGQwd2Z5dXdVY0ptTHhPKzY3RXU3?=
 =?utf-8?B?a3drMEpEMWdTY3c3S21IZjh6YUhlQ3plamM5SzBMellSL01GdTJDY0h6ZlZF?=
 =?utf-8?B?ZDI2RUZhVllFV1VIOG9hejRVcjJxZUZsdkk4QWxuQithNGlIQ2V1aUl1YWRE?=
 =?utf-8?B?aGRaOFU5eWJ6QkVVYVhxSExJUkxCUzE3bTFUazlIb3I0NnZaMkZKdC9VeVRS?=
 =?utf-8?B?VE10bndGVFl0M0hBL3U5bEg1Z0FmVWhIbEY0d2ZpMWV6dnVUdngycy94ek4r?=
 =?utf-8?B?aXRhRmplVmVCdWpvRW8wNW9OUDNNd0cxU2c1QlU4OG9RS2FqZnU2K3kyNjVN?=
 =?utf-8?B?RWJUN3d3aC9UeWJ2c1dQWHNRS0xTUVhDaGlxd2I0Wk5EanBFZWRyUzVPekNt?=
 =?utf-8?B?YmRac1ZOQUZET0pVS0JOMzBWRjNVMWM4TjF5bEZQMVBMQ3FNd05PTmJwWEQ4?=
 =?utf-8?B?STdEZGZvZ0daZWlhYk9oUG14bHd6YU9YdERaVGtaRWI4ZFVlaGFXdmU1TXZD?=
 =?utf-8?B?ZGRBNmc4eFBoaU1kRDQyZTBLRXhqMXFlRVZuSWU3c3ZRdkdzSmZKSzVIMUJD?=
 =?utf-8?B?UW5GeWg5bDZvcDBIWmNvUmdqSXpheEQvNjlKR3hQN2ZCZE4yM1N2ZEg2MXhB?=
 =?utf-8?B?RXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CVCf0nsHAoLQq3Btcv3FA1y+xrYJrR8eVPCHof0yAD/UiAx92cvYqjPbEmR3Py40APirtLA+1nTIKvGIwMFC7ttguVjhtvWdl5v6xWU4hmcHTqeGzRw39na1T4OXDume0oYYsX9IaFJT195Ki2XUle3ELGdJzckBbcF8YYzeHYF1xJlUZfiT+s8oJD6Yvko3e7fcQJ9zIDy2fhLdaxRTL+7w4iAHlgxYKvidNJOtQ65/p/QCTnRgjahz/H7SHGsDORvj2crXYwPs0VQ8YhyulCn66RWEBsiHYnydAHNXr+3cyn9lpLNTjR/lvvPzOgPdBf2vHE6Wx8EhVrwDHhMADisBmda16bYbKIFzBNzDYJZu0jxBZjFwPIJRwFzQ3Y3MzA39m9+6leUs+RBv7XKg5xFy65hiKpjWegXv/+Japm9aBgOkBzmcchRVQdaYnTzbKhjYRNRzwwJI4QscJZsI94oAoJSy87IDhfda55k4I6TvWF4blPLBT5fqxDD3Dk/qLRPUJfkrga1I64pNs5Yb+vDKgvyZrEvOGuUsfg/hX+8qnu5EZvpILI8uqEt0Y7AmkCXLQSCKbkK7p3yLX/Cwn+udb572J62f9jSbyMjgLhM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fa309f9-240a-4abf-8cd9-08dd2f44d8ad
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 17:58:09.8331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x8g8L8T/TgmgOeGOFwwYPlaXdSq8J60r3qE6FwJ/2UKLenBAXnl1aouvZLDN5zo9iJysq+wkZNaYotzw3lB/dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7326
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-07_04,2025-01-06_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501070148
X-Proofpoint-GUID: iHbSB4dFnatw37s56DhFqdrWWZLElEX-
X-Proofpoint-ORIG-GUID: iHbSB4dFnatw37s56DhFqdrWWZLElEX-

On 07/01/2025 17:13, Mikulas Patocka wrote:
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
>> That should be fine. We already have md raid0 support working (for atomic
>> writes), so I would expect much of the required support is already available.
> BTW. could it be possible to add dm-mirror support as well? dm-mirror is
> used when the user moves the logical volume to another physical volume, so
> it would be nice if this worked without resulting in not-supported errors.
> 
> dm-mirror uses dm-io to perform the writes on multiple mirror legs (see
> the function do_write() -> dm_io()), I looked at the code and it seems
> that the support for atomic writes in dm-mirror and dm-io would be
> straightforward.

FWIW, we do support atomic writes for md raid1. The key principle is 
that we atomically write to each disk. Obviously we cannot write to 
multiple disks atomically. So the copies in each mirror may be 
out-of-sync after an unexpected power fail, but that is ok as either 
will have all of old or new data, which is what we guarantee.

> 
> Another possibility would be dm-snapshot support, assuming that the atomic
> i/o size <= snapshot chunk size, the support should be easy - i.e. just
> pass the flag REQ_ATOMIC through. Perhaps it could be supported for
> dm-thin as well.

Do you think that there will be users for these?

atomic writes provide guarantees for users, and it would be hard to 
detect when these guarantees become broken through software bugs. I 
would be just concerned that we enable atomic writes for many of these 
more complicated personalities, and they are not actively used and break.

Thanks,
John
