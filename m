Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3A3288514
	for <dm-devel@lists.linux.dev>; Tue, 18 Nov 2025 17:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763485241; cv=fail; b=HmvrhsLmq6guUXW8IV/4qPcu6/qvxPuy9mBEG2VBg9TweO3eh25g7k9DucUVyBl0x+DVqmFuEICiNcKDAH/iYtcGz3GWuiJuVC+E8SjqMeDGXsTGd2HqJ4z/VOom5NVHEhRvkh2FdixGBaLrURVHVwdneZoPuplftMqt9OpiATM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763485241; c=relaxed/simple;
	bh=4EKm3Y3Q6bNvlFapkeufZuYyfS95VpwaScEaXXQs5Pc=;
	h=Message-ID:Date:Subject:From:To:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IWLKhXa0yKQc+vUlB/SpnHKkLF/bzw8JLGVOK17uqjXocG4SBYjMSObP92g5pfBi5k/osZlOecyH22ILMSSSxlr4S/4GAAWYUwTARZ8wG0cXrcVT2sBxXXqpt9wgQ1aqmw5b1XoSDdBaC6iguW0aKMtGaroAwa1FC2x9y+FTH4g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NqHKftBT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zfMlg/T8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NqHKftBT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zfMlg/T8"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AIDSYSw015636;
	Tue, 18 Nov 2025 17:00:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=c2gmA5BVPJz3uIKVq5J5pO4qd2GoZI6z6TiHeS8kInY=; b=
	NqHKftBTwCzbydsFUPJ3+5ySKMdu8/b24IdcP30hCyV8uJ6akE/wF4aYtqU5UBBU
	w6114Ff6Zs2cpJhykK3sn2c09pMC1q2INjXXVneZfbZbVF/7de3zQmjlQ9F/SYnp
	4iRmlqfv0z43DR4+Osghn2CF2WYDSTB2iHKAlgmugUCIi7QAcsvtMxJ/xZQEwZTw
	TAWTD5EhCTBSYyVoJeaiYQHi+fuNAyb7/PAf2Mhd8tOYvOB/8FInTMkE7AGCiLYt
	sGxvfoDhmPc6A+CbKPivB9a2scuhjFgSphdf/0AjQuQE61kN4K7SENkv0Fs/9NaQ
	yotLaK9+6K2va2hfbUTC2g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbbdcuk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 17:00:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AIGYasG002704;
	Tue, 18 Nov 2025 17:00:25 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010046.outbound.protection.outlook.com [52.101.61.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefy9dpn2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 17:00:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MFGwUzYh13egsmNskoWZ0DBAUcqjJJ28HtQtsXmBlQQvpkpCz5qED0o/9fhyT1dwsc8NH7v+JoqrD+QmzACIZuFUCA3pcR3ClTc18CV6VNkl6HtFtB7baMZ71IMYVYGM9HzdEz4nagJD1RH0zqSITyEYf2NnNRLBQ+qtX7FDEBTziVeJlTFvtSl/zttqCjbEor9FQuPT1/SCnFRowDec8Lb7GH9ujl4l5fnapWXkzdSZqXRrtNTuD61ERWF/9/c/wsS7MtmdrvzYaEjBCc8Hi1AS9lYYZ7lsTfeSw9OY+0+LJSp9M5jecUOBhYq85LaCgWbubXWGzN21Y7nGR/n4QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c2gmA5BVPJz3uIKVq5J5pO4qd2GoZI6z6TiHeS8kInY=;
 b=G06qrAkxI7QBYYpkCj2Z9cPNPZe9iUXts6vPdb7PNUHezVUHl4NJDrQ570uoY6DO3Q5bPl+Ak1esu5/mxJ29Jc5cBHC2sR499NIWgb4Lw0wnrhZL8KE3Ooo7TadPtJAwoOK+lwnyjbkCFS/lqUc9nRwb5CY6gr7nZn4Zqevh4l8yYud35cTDLSiBm6QGgHPai7GHMAHk31pee5wgcmzBT4qxXAUBfqtG+5CWz59ASR/ojI0v3QsGSnRSosOVQp6DCPpVkL0YZqzvYKGhRfpvci2f+lRqizdyAQ+vTSHL5EdXu6wvKfp6oR5OG20rVUD1XnjLbdVElsDjX7WjE6+tdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2gmA5BVPJz3uIKVq5J5pO4qd2GoZI6z6TiHeS8kInY=;
 b=zfMlg/T8g7iQ+qQJYYxRoRSQ0wzteQoKRxVEfYPKcBrk1pJS3PT0FQmG4CjHKejC8sXE82ttjy7GWDqSRktdMRYElzx2uJAmz2DACfDPUcu/6slOWgjhoBICEfw1z3Sz880X3YWcT5UGq0DTQ9fL9jvNWt4mCczuE9cywJ6IX7k=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DS7PR10MB7298.namprd10.prod.outlook.com (2603:10b6:8:ec::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Tue, 18 Nov
 2025 17:00:22 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9343.009; Tue, 18 Nov 2025
 17:00:22 +0000
Message-ID: <9d2816c3-fc01-44d0-a9ca-4129515bd0ca@oracle.com>
Date: Tue, 18 Nov 2025 17:00:19 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] dm-crypt: enable DM_TARGET_ATOMIC_WRITES
From: John Garry <john.g.garry@oracle.com>
To: Mikulas Patocka <mpatocka@redhat.com>, agk@redhat.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, michael.christie@oracle.com,
        martin.petersen@oracle.com
References: <e0b99d8e-1159-a489-6df3-648b21c4f091@redhat.com>
 <6b3582bb-1e50-4e7a-972f-a82f62f46e7c@oracle.com>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <6b3582bb-1e50-4e7a-972f-a82f62f46e7c@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0232.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b2::16) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DS7PR10MB7298:EE_
X-MS-Office365-Filtering-Correlation-Id: d536a338-e4c5-4bdc-ca3c-08de26c3f5e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YWtKY3VuamlOUVNOZ1diamxjYTVlQlozSG1QZnRBR2FTZTZ0bU1tSHZhRExM?=
 =?utf-8?B?Nk42d2FodzM3OUNpR3VVeEM1eGdiVzZYOGNvbFYxWHJ1SjEvRWtQVDF2ZjlW?=
 =?utf-8?B?Mm1mdnl2bDJYVmZoaTlEUUs5NThuNHBHU3B4RWZMR3VXRURidmxJb2hPdXZ5?=
 =?utf-8?B?WFhZV2hvMDBjb2xsU1M4dnVmeDFkNW16bjVXaG8zTzkvcmViVU5PbE1hdGVC?=
 =?utf-8?B?Vk8yaXJ4ZUhCZGI1UzB1Y0pDejk2TnlmVlc3MmQ2dE9ueXhDOUFva2R0QStC?=
 =?utf-8?B?bm1uWElBamw0WE5kN0NCamxqdVRYTkJ5QXdBQ0lFbWFnQ1dTMWdhalhFWkhs?=
 =?utf-8?B?c1lsNTF5Sm1JRDR5VWVZMlBvUkpMSHB4RUJPb1RsK1lQYzAxMm1XaWJkTmE4?=
 =?utf-8?B?V0JNRDc4ZXJqa3VQVVUreEI4dXdZclFXQ0pPV0tNRDVaNzZ3YXpjOGxWSXhF?=
 =?utf-8?B?aS9ZM0lSaHBQN1A1cDJKTTdGZTlyNEVXRlV4ZlA0S3A1RGQ4TDVtL2dzU2Mr?=
 =?utf-8?B?VkpqZ21wKzhtWUt4TU03Wnk5T1lzOW9iK1dpM28zblRISjdITlpMMjhjeGN3?=
 =?utf-8?B?SmowZWNtODhZcFhtWThQZUFuR1NYaGp5UWRCYldJT0ZzZ1lzYmxjMFpsUmZE?=
 =?utf-8?B?ZWhRM1g5cUhNVjlIa2RCVXA4VE5yMVlXUHBVR3JTYStjMmliRWJTUmJXbEEz?=
 =?utf-8?B?TGdFcUJFN3ZSWktMTTBwMFdOVGhMUnJIYWxvUnRoODJYTitXM3lPbEkySnMr?=
 =?utf-8?B?aHFybTM1WHJIaG1FNFJRSnhmTXFER2ZVQ2kwQzJ2dTlVRVErMGZpOFUvTjhr?=
 =?utf-8?B?RDJEM2wva1VzWFg5bEttUlFieXJadTRRRGdnTDNUKzNsQytuZi8vdTgwTXNY?=
 =?utf-8?B?bHFLbWRJNDYrMlRkU0luMUNpRDMzU0p6bElHdis1N0dwMXVsNDlJQjQrdjg1?=
 =?utf-8?B?R3JHRTdlQ3JmUGZOa0phQ2oxS3drbVlZb3QzTXF0emtkZjFXVWJlSmVBK090?=
 =?utf-8?B?dUlIb1E4QTNzbnFoRTlsNkQ3cEREM0hSNnc3aGFyaHMyY1VZc0hXekJiaG9Y?=
 =?utf-8?B?U2pSZDZQOFZIUFN4MVltL041dHk0eVRBWVVEYmh0UFR5cDQ2T1R5NUM4UEVl?=
 =?utf-8?B?M3ZpU1ZURCt2UUgzL0l1bDRnRExPaWkrWkg1S004S3lyZUpFVlVGaTRnTktI?=
 =?utf-8?B?aWNURkJOWXZxNko4YmpQV2g3N0IvSm1CQnBLMFQ3ZFI0TEVKeUhSQm93U1lI?=
 =?utf-8?B?bERwTXgxWGFOZ2hNUTlpLzcwczZOcFJ6RnJRRDdqSjcxUmtUS1hLNWVxeTJ6?=
 =?utf-8?B?b1NjczREN3NHSXpGNGMxUmUxbEhaL1A3bWR6SC9mN1RHTzdkdGlWTmJhTlBp?=
 =?utf-8?B?YjdlZEtZUDhoUmw3Qm5mRWd2QngrN29VUlVVZEVRcDRGSU9pMGtvWmNXZEVq?=
 =?utf-8?B?NlJMajFDanl1aEV2MTJaSkhUd0hNVHNBM3lJY1c0MnErYzhoOWNXaGZiR0h5?=
 =?utf-8?B?TW0vdkdXcGJBZkRZR0c1bXJja2ZaR1d6dzhiWTFYdGZjZjlrVXZUNUdyQVdN?=
 =?utf-8?B?NDNoU0hsMEM0VHoyM1pVdDFheVNuNEkyRHliQkpheGNlVmx3aGo1TW9kcWg1?=
 =?utf-8?B?cmZNbTBYeGFyM2lTTUlVVW1LSmdzbExDT0FSUmJoNzZyekM3VnluZ0ErQWFL?=
 =?utf-8?B?OTR0U1N6L3J1OStRQkF3aWNIb3U4WWx1a29Oa0ZhMFBMQlBBUHJlb2ZXbm5U?=
 =?utf-8?B?cmF3NklLaWFGdGlFNGExbHZ6aDlEUG1CcGFZK1JacmllMGZQNTYvRE9XdEk2?=
 =?utf-8?B?UTRrQWJkYVRGMzg2aGxCMHlyTUc1aCtFaHJkVFlWSDVIRjV1UHdlekFvMW5M?=
 =?utf-8?B?R1BvbmdKSGJCZlhFenloUE0vWVB2c0VsbHlBRjZGT25iWDZYWExyZVhGQmcx?=
 =?utf-8?Q?q6QCU7UmAd445DCK2R29UpGTEDYilOnk?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QVJscG1RMUcvU29acnhaRmx4Zlh5VXBsYVNIYWV3TGVWY0dwdytLSWh5SERi?=
 =?utf-8?B?dWY1R1RPdjFRNjJaUVc4dXNyWFNPaDgvVTQ1WFZRcytYRlZNNWVWSjZwcVdr?=
 =?utf-8?B?WW52cit2aytiT3R0N1BlcDNWM0pVWlIyeGZ3Z29nS3g2RUozOTZidFJkZVRB?=
 =?utf-8?B?ekNDalUrZnF2RCtZdlpZelZ0aFNGVFdWSTlkallST0d5UW1HL0FQQ0xiVzF1?=
 =?utf-8?B?dkNCVXErS1Z5YURkQjYzQTRobFVTdTlIUkkyOFczaWtHbUJ5cjNNMXdXREcr?=
 =?utf-8?B?WUMwWnFtSmt1YzF2cUZ2OXpBZTh6UlZwQ2s3VEc0QmpRUStYRmp6RmtaSitZ?=
 =?utf-8?B?UXBCVUNnUW01eTYvdWIxZVd4UlJCYW8rUUxJa3pUSEoxYVdEU1FGSExBTERQ?=
 =?utf-8?B?ZXVWaTJaZ1c4V2YyOWYrOWFjNW43WkFzWXhNVmlQelhvMU9yNlNyeFZPUlNH?=
 =?utf-8?B?TWc4WWlocGZKR2I1eDRTL1ZLMytwSlBHRThGUmoxSGg1eVlHcVdWcTMrZ0hi?=
 =?utf-8?B?VmxJVklROGM4SHBNMUdOZDREaVdNU2lsQ1N4YnhmS3M3cTFDZmMxWjMyZWVq?=
 =?utf-8?B?cUZqWkJ5RFRTTldjNzUrRE9QVGxRWGU1eFVnNEtzSWxUMGhyZlVIRTVhSy9a?=
 =?utf-8?B?bk40Y3VWK1BoT1Z4TVpGckIxcnNYYi9JdzRXbnc5aUYwQ0IyRnpiOFRkQmMv?=
 =?utf-8?B?elZTQUNSbG5YS1dRVEgzc0ZmUlpMMjRlSlZWQ3NNWC82UW91SUtZU0ZVZzdw?=
 =?utf-8?B?MSthQ0Nzd25oS1JFMDZJcVppM3NVMjl4UmtSdXNMVm43cjVHYTM4SkRKUko1?=
 =?utf-8?B?L3B6d0g0OHVOSkI3UzUwcXhqQms4aGt6K2FmNHdrbXgwVERVbjlobW1URDJQ?=
 =?utf-8?B?Z0tLbG9UbDhUYTBEaERWd2JnUVNWYU9iWExLbkVQbWhCK3NSMW43NHVkd2s0?=
 =?utf-8?B?dHZhSzkvRm44YjBCcE5ybjB0dGExMzlzaWFwZ3UxYk5QblVWa2MxNUVZTHV0?=
 =?utf-8?B?aTZWaTZkOFhxcS9UMTJvSHMyNjJVRnRmSjVmK2FYaFpMclRFYk1xTmIwcVhX?=
 =?utf-8?B?QVRnbEdpWVVRT1pMZ1VhT3YwckFCRGxQVFI0Q25HQ1pGWENtc1JzdGdWQWJn?=
 =?utf-8?B?RkpuTStvdTBmMHZudmVTaTRnYUFuWCtwVlJybkkrWHIxOFMveWtzUnMxSUE5?=
 =?utf-8?B?cjBtY3ppZHNOOW1tV1IrTUE0eFFwTi9ZWmlOTGlCSS96ZEgzczNRMklKbWxO?=
 =?utf-8?B?Tnh6YTI4MndvTGt1dDFkZ1ZpWXZVVWZ0T0NUVm9kNlZWNE1YdHBxQTYyc3hy?=
 =?utf-8?B?MTE3Z2QrbE0xa0NadUsvZTlVMXd3bXRmTm14RVJ6MGF1cWFSM2F6eTUvZ0pF?=
 =?utf-8?B?MDlrN2FqYnMyOXdFbHFNMVFjUFZ2dno3SmVCRW9OTUNjRjNzTUJaZmZGRmc2?=
 =?utf-8?B?NmdPcGhuS1dxTzVoSTZVTmZwd3Q2blNMakhPaDNJSlB5cjZyQVdmK0lIYnhi?=
 =?utf-8?B?eTFXM2c2aXdRY1RGUitYd3Q5ZGRmZmZobDlldUpiNmNtVGlxSkFxZXFQOGgx?=
 =?utf-8?B?dFZ5Yy8ySDRuRFU5REl0d2FEalZNcG9sKy9BbEtiY09ZR0pLYStMMDlhbGZ3?=
 =?utf-8?B?cmdWSC9tNFltdFhEK2FqUXBNRERob1VCWVkyZmpseUZQemhtMURRNjRjMmJC?=
 =?utf-8?B?YlJCM3dLSEcxVEQyMzYvaXZJQ2p1TmFRUkVFaytUbU9YSTdia0huV2l2RUQx?=
 =?utf-8?B?K3FVaTJ3dWUyVUJWYUljdGxwQVVRWXJoSWFMRDNmd3lGOWNRRzVadDFXaWFq?=
 =?utf-8?B?NHBwTGFTRmVTNkF4c05qTDlTSE5vY0VJSm5vRTVwVSt0WVlNRmFkYlh3eEFx?=
 =?utf-8?B?RkFqeWFSSzBVeWdlbnBSTytGV2t6bUtCemJuemRVVVVaTUJNN1Z2Tmt6cmkr?=
 =?utf-8?B?c2V4S2RsSDRXb3RUTFBkK3FlV05jVTQzT0ZBVEw2M3dyczBrN1BYMFJqR1dI?=
 =?utf-8?B?NFZPZThIdmxIeXhHa1E3WG5JblhFQnhRODBKRXVybzNuamdLRlVnVXBRek10?=
 =?utf-8?B?V2RuWEc5Tis1a3M5NEY1OVk2cDNjdEkrRjZXRFhhTDB3OXozUXJ0SXp0THZY?=
 =?utf-8?B?c2hWUGdONlNMUWk2Umd5VC9tdzVxdUdqZmp5VjYwR0JGQWJUcDc2R0tLZmZ0?=
 =?utf-8?B?VFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5rOHdedgRzYnbD+x6JuHuNmPVkONWNeFsU5ARaR2uGNT+L1Ob/YDleyEX6vJbcm03Pwhhzudi/1Z2l1BYbE6ldkapv5BfiuONgJfhidnHFJAf/+bt/ZoY24+tYgnhfAyErqvm1/SwhNpgxuuVE9vO+SPjWryESB/qTeWg1RDpwDHG7txa1lWjMRBHom9EKluRJLa/EePV3Ta65Of7AdkglSL+trtAszCb3/9yGQvNGWSdboc43CMLTC265sylUgpuvQHACyI5qVghF0CM+lRkkdX7SWgUUYsiKuXwWbAcrxATt4ZZm11rzfYqQ4+jy7Ykmw1owvcUh4IMlL3yr3CipOtplsSUbBU6f/MvGPvp2t1K7u1dqoaTVA5URktLaAl+bJgCit+XI2RLfDpXg8yxNHXYQuqY6rUKdJlmILfzexJ6ylRHLvTC8QNsuB6tEGki41kNVX4PYqKkU6C0A0fyXqgKzjMxJeJbgnzHTXMJnvTZKYN6XIaHsDiDdZ5XtQo9sYeuu3rD75mJ8zyhyjzW0oaLPG2eT0rtHCuhvtCVd2CogkHORt8Rvg/7w+Yr5fg4yHMpzXIoNm4jq0+peyklRqd4mzzJ5P02oRoCqwRY14=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d536a338-e4c5-4bdc-ca3c-08de26c3f5e6
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 17:00:22.1679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kxt3jqucp4bZw3aHT1I7+pcJTg0fxf8Fvi5X+6TpjsH5AbVfOk42LgKHT5mShpyxChGREWI7Kk9X6C5wZ6uvtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7298
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-18_02,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511180137
X-Authority-Analysis: v=2.4 cv=BoqQAIX5 c=1 sm=1 tr=0 ts=691ca62a b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=d655rgKI7-WaDrM9qd4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: bGg8vuysboAkVT9xKJy8_nUxr9TuvvN0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX1g+7kgLNFjmi
 EAVVO3DvyGZpI7w9sNab95xtF+a6MsvkSjS3EMZC5w4CCppnBmacuImbYhdAWnKC4THub8G06Ke
 9pB5M/8Y0Mqa8byqHoHu2qgD1GO6E/ksa87re3pepp8vEVh6fO5s9f3aW/FC+ABmIALGth5Hbso
 FdJaEXERVv8bjzGGRUBzaZ7BDWZUwtQHFRQqymJ93AU2nHNEU4poFziR2j04siVo5tYenblG+Zu
 2fIoWHirvxfy9dGSW/6CHPLB186Bb5cS0XY4gWmfmpi3D7rOk2HZBq6/XuiavydoSAlISyKhYiV
 nrD2t9b0igDe3Gb/Nv5t97wrnBUOD8W+oHgoMI4QDenyQKOxm/2JkvxfCyXWlzG2qNOlNO3qlIk
 sxxnH+Ge8a9uD07w8PWHKfZiiA4pOg==
X-Proofpoint-GUID: bGg8vuysboAkVT9xKJy8_nUxr9TuvvN0

On 10/11/2025 16:02, John Garry wrote:

Hi Mikulas,

Just a friendly reminder on this series. Let me know if you require 
anything else.

Cheers

> On 05/11/2025 15:02, Mikulas Patocka wrote:
>> Allow handling of bios with REQ_ATOMIC flag set.
>>
>> Don't split these bios and fail them if they overrun the hard limit
>> "BIO_MAX_VECS << PAGE_SHIFT".
>>
>> This commit joins the logic that avoids splitting emulated zone append
>> bios with atomic write bios.
>>
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>>
> 
> Tested-by: John Garry <john.g.garry@oracle.com>
> 
> fwiw, I still don't think that we require the change in crypt_io_hints() 
> [not shown], but it should not make a difference.
> 
> Thanks!
> 

