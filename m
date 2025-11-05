Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CED3385A6
	for <dm-devel@lists.linux.dev>; Wed,  5 Nov 2025 19:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762370498; cv=fail; b=q/Jq9Px0pG1ZCwsEl1pX1WqKQtJTXwvbEG8DMEaVOw6OqIzu8orUO7ky/PG5pmyV79m56Js8REfAo75n1PH+SLyWzrdBQURHlsfNHszUZlXO74FGN46qjBDwr1ULbBPFsgcoTk6bvhjOYVvfO2F99C/Yc+pvm7UyOGRrCJbn2YM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762370498; c=relaxed/simple;
	bh=H22oDobt8HYnPvKsFmJLYj9CjgQaKblHsEVGEh/FDKY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qyogfg3W8g9TwJGQGGT/Arlcj8/YKn8NicAfJ9Gw4gDz7XSQS/vJGgHJUvRWfawUEv+cXBqP+5GRE3kVO+65qV5WeLhjD6Y+1UIBSg5F9dNJ0UiFXjuow7WlK6RNwBSmt2W0x1vQJVY1l7YzLC7i/OVtOjgrhOhH7smbVDLqnts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=imyhqJd5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WWMHnJ8M; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="imyhqJd5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WWMHnJ8M"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A5HdQYP017359;
	Wed, 5 Nov 2025 19:21:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=mb+rNWEF3gie/LIbVrIjkS2Gl3cBOsTru9ZLI0F9J3U=; b=
	imyhqJd59NY0DcE6iWRLcZtdfcoi/qvUVrGebNX0mVCggV8JaLdyxJRdf0VhdYjR
	9DDs495UhSOhd6d24gD7v9XMlgS27aB6RREllXf04P8eEK5qGfHRucif8wL6rtrW
	AltpY2EgVBFiFUr+1JIB7D9ra/dr8TUOT2VdhNoeRA3mp5fyRALjH7XRKeDbKMVS
	JSgHLwj45Pjj6tX40eBjYJUPV/+JMWl/789Hr6tLBymLalCsxcKq4dy96vO9czHS
	RyjIIaFD4vIhkGDsfO/FhU7iBavXua+pYSKGkIBoZos0lOKC5dbqZmi4194CeIUk
	KvosqvSyXdrVn3f3j+7ryQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8b5yr78c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 19:21:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A5IC1dU010927;
	Wed, 5 Nov 2025 19:21:32 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011047.outbound.protection.outlook.com [40.93.194.47])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nbdwhk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 19:21:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DsXfdphYR4bnbAs0jbQrXFMdIupWB9osujHNarYoTE1Oj9+QMaKeiFuPkngxccFKGJwZCRn2U3FmrZ6trenn/nD9kxtMwCc2hwblv7VyfyoI8CaXnk6oFXnWC+RoZCmeJS697gP/loW4gMHftzhLaYp80cMXnz78CSzxfmCqc0337L7CJv2QEmeTUkaQA9qTbwieYuHIbhVySuuLc/EFW1LnZh0ww+5bK4QV1PLYXehD31Pi2F4BfmLIJlfS7YIAZVVm6x8EE1sidNR93DYzuHBjGAGAlplvgckWR37HPeC9DYllbf4F8DaiV6HfvUOtN0pLwVJRUGJS8P50uboF+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mb+rNWEF3gie/LIbVrIjkS2Gl3cBOsTru9ZLI0F9J3U=;
 b=mbk1zPLYc8dGEG8hk43Ot+vUcWmE+bPm2RSqAjb+M4CvWssVLHqsO6aZFi3FZUxQP53Y2US0PPQXsbrFrNEqdIYqZzjWyQeNX5fyj6t0K9hq7WUpWspbTYMLeE+hfmmPqRVj/SYTbDRIZPB+Rblui16X4LlgdgIfTwfZZvwlOgozB+58GnZpB0iz+ZZsfIKFbZG6k3oaUEu/jLrKmo+/3Vmf9wLH5K5b5xTmGfTI37AB74C+ciabda/ohJiJIzh8gFgnzr497CZjeacp9ZZRXiqxrIkn98wQL+V2h56qAY99qf4OiXDlhMtVSCv2aZbZFI2oJH4VvdPbcAeI+qSrhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mb+rNWEF3gie/LIbVrIjkS2Gl3cBOsTru9ZLI0F9J3U=;
 b=WWMHnJ8MmBFEvhah+0ODVx6X3UgIpasw1vIwuQY0l0bFIjR98Dej3g8bs7RCnTklnVnbDN1JWbDrnmDw2bOiBbArikkPbAejxPQe5ldvKKMWJAxj7LIG8aeIdxJp238Q6SkQXfrfx4ZJkGV/NR6FlwB7CMiXoMUF/qLFxDwVlDE=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH8PR10MB6598.namprd10.prod.outlook.com (2603:10b6:510:225::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Wed, 5 Nov
 2025 19:21:29 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.006; Wed, 5 Nov 2025
 19:21:29 +0000
Message-ID: <6f92e6da-677c-482b-a852-21ca8cde2919@oracle.com>
Date: Wed, 5 Nov 2025 19:21:27 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] dm-crypt atomic writes support
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
        michael.christie@oracle.com, martin.petersen@oracle.com
References: <20251105120244.99752-1-john.g.garry@oracle.com>
 <7942b0d8-9f5f-d8b5-194a-3dd5b604898a@redhat.com>
 <90b9aaa5-0572-4a3c-afd3-33864daeb814@oracle.com>
 <a78c06d6-27ea-55c1-fcba-98ebc0bb7a43@redhat.com>
 <8c9b0336-4a3e-49c4-9324-50d1c1b0305b@oracle.com>
 <bc439c9c-6002-494d-7dcd-250b3169d92c@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <bc439c9c-6002-494d-7dcd-250b3169d92c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0050.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::14) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH8PR10MB6598:EE_
X-MS-Office365-Filtering-Correlation-Id: e4c42db2-b1b8-4d21-e34b-08de1ca0855e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VFNmRlFyb1RzYlFnT1M0enI0N1YxRVdoK2xmWi9JcXpHMUN6dnlqUUFNaHdm?=
 =?utf-8?B?REt3QnhRQVhobVcydml5ZE1FMWpOZ0U1QU9WbUoxNUFhNC9ReGJUK2MwWGdI?=
 =?utf-8?B?WjRhY0N2V3plajhwejR5THBTMjZyZ0JTMGVsV3E2TThYaU9ySzVJczNxSjJy?=
 =?utf-8?B?dzJ3SXpkUlZ1TzVEODRseDRuYWs3aDdDSjRFUzZnOGpLOEdZeFlRVlh3OTNL?=
 =?utf-8?B?QzRsaGJQd2RJK0NUcUdtd0tFcjczRzB0bzEyNHFUOW5kS2kzdnBFYTJGU0pH?=
 =?utf-8?B?SnZTTDBlaFd1WEVSM29USnUrRE05c0Q4VzBNLy9UME1hOGt5ZjVrZUtmU3Rn?=
 =?utf-8?B?cGNBSGVhUjdJM1JJSWozTlZ0bTNRWkpKVnk0R2NsdmpVMktCc25iM2trT3pY?=
 =?utf-8?B?NW1QaXg1Z0daWkZKQW1zcFFrUXdPeXNFNjk4a3IyekcyREdobHpxc3RPNzBs?=
 =?utf-8?B?TW41Z2RmbFZwNUd4amc5ZDVTTnJydGZpWjZPVDFTMTJHT3VJWkFsUzZxU2g5?=
 =?utf-8?B?UVNTM2Voam1paFBrYUlLT3hrb3g1SGxEa2YzSks3d2xqWTdEYjFQZFI3QlNR?=
 =?utf-8?B?dGFyYXJtUEJhTFZnWHRIVDBHSFhaZjhITTVXY2lyT0lkcEk2VFRNclV0MEha?=
 =?utf-8?B?empRZE53VGgzeXIwVzRraUhLdXV2bXZVMlYzNXdGTytzamlTZTB4ZWhQNnJY?=
 =?utf-8?B?QXhQUnBJcjZqcnNESlZCZ1pyL2dEMWhBVnIzM2F0NFdjZ2Q3OUpaLzc4eXFZ?=
 =?utf-8?B?ZGVCaW1McDJlSnJ4b1hZOUUrNTRFT2kyUWx0WC9vd29KTHRFWWo2S01tcVE1?=
 =?utf-8?B?NWE4enlwajZyaWJmRkpaUGtTTVZyVVZ2dVdBMjZpNDFHekxYcHRNSDhjbTg2?=
 =?utf-8?B?MXJZVmJZNVIxSXkrMU1oS0hPUFpibTVPSytFT1U1VVlHeTRJMVJzNkp1L1Bv?=
 =?utf-8?B?RTRoUWkyckJTeDJjRFNtNTlYc0thMkFTYTJ0eHRrZWZXek5PQWx2Nk1USkxH?=
 =?utf-8?B?MVBpVS8yQ1lGc3BXaG5yTjZqd085Tnh2dWdpZFZFMXpkZUJVb1NoUlRqMVBN?=
 =?utf-8?B?VXZHVUo2OFRsSWJ2b0JhaGN1aWtOSlAyVUNQZE9qbTlRMFUyK3NkWUhEV3Zi?=
 =?utf-8?B?SDk4c3VyV1lhVnltenpubmJ6cjQxQUxNeDhGTFR5WEdpeVYzeHdoVjJLaXQ4?=
 =?utf-8?B?VDR3NGc0Y0tJa2tLSlNGa0ZGY0NrWkRndTd5bjl1SlBTTU1KRjBUNzg5Z0I2?=
 =?utf-8?B?QWg1T0FBWm1kTlpqRWxnL3RkU0lLdlNSMzFDaUhONnJPSEhjZ2J3M0Vkd0FR?=
 =?utf-8?B?cEJwQjFVMENsajcyL3BkdlVQa3RkWmR1ZFpKemNuSWFrZldPN0dzSlRtOWtn?=
 =?utf-8?B?bERlTVlLcTJxcTZldGhhUlhjL0VVanVYR0dGNk4vbm5PVUFFU2lTU25ZUzVi?=
 =?utf-8?B?T0dFc3d5R3B2REpaY3M0WVNNRUt5TlMzckZ3ZkZjaUtJb2w5ZUdJZE5HbFVR?=
 =?utf-8?B?R1dXZUwzbVQ2NW8wcTVNV21sRjZXbTFaVEdxWVB1bWFmbEpIMkNjTzFicTdS?=
 =?utf-8?B?bm1aRDNRajVzVkNnY3FXakpjTHJ6YVNMUG5YU0E3ZnRQZExTNEpNNk5EWU93?=
 =?utf-8?B?cWpsK0ZVaDdGYlBBOGd6amdMRGE1UWxmN1dWdzlQSy9zL0xDajIyUE0rNERS?=
 =?utf-8?B?RGV5RWF5QU9QTGhGTWQxSlV5Tkg1MjEybGljNUo4cVFiZ0VsSUJHdlpyVWND?=
 =?utf-8?B?NCtWcUxNcU9EVzROUVo5cXZTOWE4VXl1OHZkQklOY25XcjIwam4xZmEyMEp3?=
 =?utf-8?B?UVpXRXJ4eVhpTUhUcE1oRTJLL3lVNDFnVnI2R252SjJad29heUxnVWxGRU1T?=
 =?utf-8?B?allsWUZ6a2R3TEdvcW9rN0g2NVdyTGk0SmFRL2JiOTFZWkVLSnVIbUZ3ZjJa?=
 =?utf-8?Q?0Y8dglFIPBCYQsTijPfg2SmtmvCur7/H?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NG0zQ1lUdTNrRzkyS3dOaTZKejRSYW16cnVGdGkrdDhyWFlaZXFORWwwU0lo?=
 =?utf-8?B?SEh3WUtFVUlRajZveC9wU2RCODJ2L0U4MFBncXZVVGYyQ2tzanRnbDhoWndr?=
 =?utf-8?B?Wll6cGt4NytPSkR1Y0Rid2ttK2xPOXA3Q0YvczBNN1ZPUGo4bHhDaTEzSTBZ?=
 =?utf-8?B?RjNZU1ppREVXQm9heDVaaHBScTRKUW1iM2gxUFAyZlNSTHh2dlNWOVVYUys0?=
 =?utf-8?B?V1dKR1NPaG1ZdktxcFpuYjJXdThsWHZ2R0RXeU05blpTdkdIUGsyd0h2M250?=
 =?utf-8?B?Yk12MzEyOW5aazRXUDZYV0l2UTJENkpsaHVmNzY0SW9yTWJ5RUs0d05IMHM5?=
 =?utf-8?B?RC9wM01YdVpHcnA4VlFlTFhNZi9sRjNCOVMxZFRoNzg4TjgzYVRZZ1g4N3NC?=
 =?utf-8?B?Q0pxTEYrb3hhTHRGS053cFRGVVNwUWZkRldkd3A3WEp1UlpqQzhmOE92VW5p?=
 =?utf-8?B?TEJ3azg3eUUrUnQ5TFBiSWdFek9BRWdzR0FybnZSQWVEdzM1TFE1L3hYOXdX?=
 =?utf-8?B?YWRwdGdieFB4b2UzYU5aQmtiaUZ0Ni92enJEV0NSUURJbTlhVStBN2dBYlQw?=
 =?utf-8?B?Z0hHNnd4d29PTk1NKzBYOFlOaC9LU1FDUnh0RzEvYlpLUHZmRERsVDNWQ2k4?=
 =?utf-8?B?NDBMeEpRL2wvbWk2MWMwVTRPWDFxbmhTLzhBaEtkZmNEL0xwNnhMQjF4dGhn?=
 =?utf-8?B?d0VoWGZlTmQyU1FxSDBvbFpmeW9LbGMrZm12ZytJMU82SU1jS0VtMFdRL3c1?=
 =?utf-8?B?b1YveHhFcVR3enFNbmxobU5vT2UvK2piNEVldTBLeTBNWUgwdzVWblN6UDUv?=
 =?utf-8?B?QWt0VDBUb0t5eEFtT1crNVRMZHBTTzRHTGliYy9sZFZuRFJTQkR5YVlwZjlW?=
 =?utf-8?B?Nm5wWThIRmRibDZzc0p3RXpzU3pTZzQvSmN4UUM0bTZvODY4QzdMTVd3YjFD?=
 =?utf-8?B?c1JUZHFNM2Z5dytzWFJYdHlLUmtuakVURmZJVC9qTjdvREhzUVIxdndVS1J6?=
 =?utf-8?B?WnFRNFhoTHdvT0t6dEhROVYvekxIVDdHeTR6R1FZL3NmYzhVd3BmbXUvOURD?=
 =?utf-8?B?Z3RhNnNXZGg5Q2k1RWhyUSt6d2FTZFdJYStSMUtTSldkN3oydjZMcWJzL3ll?=
 =?utf-8?B?MHFpUENRYmZjZVlwSTl2ek9HcWVBU3gzNFMwTmdWbWY1c3hUTkJ4UjdpMHhp?=
 =?utf-8?B?Mi9jc2o1dVFqUmtRamJUM3R5TjVjZ3BZL2tmbXRpdzFrSEs3VjF1WVloK1pi?=
 =?utf-8?B?aUZFU05YY2pOSDNtbmhkVFMrUXVqTmZPcE1TTDlRMjdyUldYTk1NcW8wT1hJ?=
 =?utf-8?B?a2tvQjdrN3pjV0dPcitKWmprNE16czBoYnRpQzJyaWYzbEtZUjlJM2lPRm9B?=
 =?utf-8?B?NlU0cUJFMzlvRDJvV1RjVXNPRTg0TEtJd1BKTnI1aGw2WVJURkg1dHVhZjRB?=
 =?utf-8?B?Zm9vbVNyVGVnbjcwd1VxRlJBS0xwUWZ4QzdseTVuNGpiT2h0SVZraU1td2VH?=
 =?utf-8?B?THZhK21JR3dwQ0EyM092OFI4K2NhK0FpQ0JCQTl1ZHY5Y3hvUGQvZXJ1b1ds?=
 =?utf-8?B?d0owbWk1b3lBNTk3MlVoMDhtL1I5Y0k0VHhWc0FOVGRDWjFxdWJERThubzN4?=
 =?utf-8?B?SS94YlVnTm9xa21LK1hRYjRSK3Joc3BwSGZDNlhjMmVPcEtvZEhhYjRFcHRO?=
 =?utf-8?B?R0RNaVNRRThZdGVNMEpid3g1OTJaUUVUKzJ6a0RGTmUrZnlPaDdVR0h5Si9z?=
 =?utf-8?B?Z3FzTUJQSEFFYUorTXErUXJZODNzUEdIMDZSRnZ1QXFWbFhRTEFqWk4zclZi?=
 =?utf-8?B?d2prSCtKZnNMWkRKd2JGZVRLS280dE1aUDAyWVRua253WkR0cmQrL0JPMHFP?=
 =?utf-8?B?SGM1cU5UZjM2NGpSZ2RXS3VxYzk1dHFKZkh6OFIybTdRR05OWFJVZENJeGF0?=
 =?utf-8?B?Z0IzOXJZRDV4STBTQjVsQVVhK2xBczVmdWV1WDBXM3ZhVHNOWG1qYjJaOHNB?=
 =?utf-8?B?anBIcGpncjdXQWVWWE1PQzhzV2VxY2ZvSk1ibTFYU0NRNVlzcVFabjBtS3ps?=
 =?utf-8?B?S25aZnJsTFdLUnNEYmVFNCt1ZW9KTzlKL0lFRjlLeHdndGpNSUc1SXNoMDhH?=
 =?utf-8?B?a0dQQlBXWHBFUjR6dkJuK1B2VzlFdlBOWWhISzNaa0VkdmYwRi9lN1JqZm9O?=
 =?utf-8?B?NUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MbS/yieN9eQtaLaJDQ0CjcStOi8aiBm2tpDucZBplFtee0AZ+V5mBXawWPnUfi+olc3DVAJdGJSkanwlOghI6Vm/XXsbwo/P4lRqrRW2L+OnAHJNM+hm+u3LhYoQ9A5OxkX3vbzy7HxnRi178VHUm862ZPtMeRgK0vLkctBZA+A9bpkNQqsGkd+bg2e3g/N88MeKkj+ck6AKx98RfWecASxZjvVP5w1UJgt7p1E4QGZs2qAesY/0QQGa7WUQ/oIDz01SiURPefw5e45J4cozOkhrxDD85j3Av55H5ig8nUbAX539jcVvB6IutWmp6N2xRXQEm9ZlK1Hm4gbrk5aFoy9+gVdkKw/KKIzRv7xtUez771KcAZFUqOYDAlqsSDOmp9nlLEk2x89ChKA0jZoPCi4HaRsLDO84a7osaSS11Vz4pUIw6cvz/MCIfqckjRTQZST1Ny5Qzko1uAIhqntXKcOpq4udNnpWX6RcLKFNl489rpw84e2EcdR8sf/rfLvZgA2WEYyL1+ZshqFwGtKrotvp2b5D8KjFUjMdwLP6hzvbT3yBwv2F/Pdhqx1HOAxGof1odKYxbyBGlZRWOKDAo+jYp4zMVJeIz2RJCHPOq1E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4c42db2-b1b8-4d21-e34b-08de1ca0855e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 19:21:29.2927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +fFxaWWBkz54mVbjVJJGm9pcFW+R7dUZ4zGxYqYxD0T1APQVTXgaawNfZyej8unxYz8q/Q3Oaf+d5AnIuNgOZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6598
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-05_07,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511050150
X-Authority-Analysis: v=2.4 cv=IcKKmGqa c=1 sm=1 tr=0 ts=690ba3bd cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=xbRHVvU3I7J5dbJfEuQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: S9kmLd9KvzMrdT9_LqzaqXPNpmnhqVoC
X-Proofpoint-GUID: S9kmLd9KvzMrdT9_LqzaqXPNpmnhqVoC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDEzOCBTYWx0ZWRfXxrqnRWCWvXNn
 dBDzyThuxA3oIKddSGRAA9jHghn1TZmw+s64O7S7Lonr0uhTsV3dCmH3I+fkOg7kYFIcB2u8sRq
 AZKdNfbXOUH4iOzGVw1GR9yyDC7g25QDgMQDM8yDAPvkPTjpZrQmyB6d9BuxFmknrrPUMYrZIVw
 lj26JWtd9Gh9JlnedvTHTTHPrd56V3dWQoDsk0clYScZCt5fHNEc8NiDS4pZ2ZGNYBeGgd454BI
 rIFHxSylpdMddDTq453O/zuj2FdIp+0CjNpm6o+eyD1cRds6c2m+4JFnMaX8tihyz4z/rCCPkjr
 R3vX83A0wPwoe/LuOLYTXDNPrTXEKf0SRJ+z4ebVZj9EFKqd67u1gg1Fy+O1Nu+OyRJC6MpL2qO
 2a+f7PWvm3SjK1RY/Yk6YTayEmk8bw==

On 05/11/2025 18:22, Mikulas Patocka wrote:
>> Sure, but the good news is that we have checks in the block stack for this,
>> i.e. if dm submits a bio with REQ_ATOMIC to a device which doesn't support
>> atomic writes, then the block stack will reject it. The physical device will
>> also reject it.
> Yes - but the block layer checks the bio without preventing device mapper
> table swap.
> 
> So, the block layer may find out that a device supports atomic writes,
> pass the bio through to dm, dm table may be reloaded and the bio would be
> sent to a target that doesn't expect it.

ok, I think that I understand... So if this occurs, I think that when 
the cloned bio is submitted to the target bdev, the block bio submission 
path may find that the target bdev does not support atomic writes and 
reject the bio, see REQ_ATOMIC check in submit_bio_noacct().

> 
> You must do the check inside the RCU read region to make sure that the
> dm table can't be swapped underneath.

Right

Thanks,
John

