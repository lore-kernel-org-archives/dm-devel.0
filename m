Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612FD288D6
	for <dm-devel@lists.linux.dev>; Mon, 28 Apr 2025 13:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745847976; cv=fail; b=SZ1FD/0j0UbDzSFDzoeRIOUabU8S5sfxRmUaZ2+EpWSP9ChQKGRWCm626u2YnfW2nJzEMZIa3SXiyz+LUo5tHTg+X3kfQOAbDub6Nfcv7tiD0ANHGrQ7HNjxSxWjQLV++Lc3LmyrHwEzRfTp0iT7G/xJFOelpiiNzN87YIyhntk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745847976; c=relaxed/simple;
	bh=OyUV/V9I+iKmOMhpP/ZQPcsVv/m9WZMNL9mbBd7queA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fbTRLBqq62BkScIvCPFj/CbDTgmQ2gAGXOD99Qozn/mAwmhNveJVk7D0+0GiAqe+FGbMKoDRwkGmr4gXKG2K2yG+0QW0Bdz3cxQpaLGRyIpgMmL7YSH5Usa9XFTyft3N234BsIu4GP/WP6zUie8NikCrIsCu1rrT9s7SrmTc6JY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lb7m/Kom; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=D3dzPgM2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lb7m/Kom";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="D3dzPgM2"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53SD4ooe012974;
	Mon, 28 Apr 2025 13:45:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Wtqx6JBTSYj3yzJ4kcDcVONIHvQj7377/qK4XT2AJVM=; b=
	lb7m/Kom44q8uOUUxmhG/6KDzbWewcb8XJcdDsCrXFi6WVjPyqke6EUlQj9L7lS2
	ycSEzxRMtCAIBoi8dMXjATPbdMSt1tV5/Nq/ObrhjWBlgU0VT39ODZ4OfJObRaGb
	4f5q6r6gV6yedOGHrkq2t5CIX0vz8laRpTo5UK3f79mftA0L+oCw86MmgPjXDJsk
	kD6LJU0mcThmWfKOR7jTVUS/IbNnIJoNIL2OszXPGp3v2ODSO1PMHl7z4OgIJtmw
	lCXrbIXb61L4AG2X1DGmbicKfHarGN8RP6a7t/kzUmkK+CpRQpRZCgiVYbIrCzLQ
	Puxt0cU3ySe4yN6TLGFQ6A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46a9d286tj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Apr 2025 13:45:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53SCHMEh016069;
	Mon, 28 Apr 2025 13:45:36 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazlp17011030.outbound.protection.outlook.com [40.93.13.30])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 468nx8xy5a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Apr 2025 13:45:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qj1LMojH/TmRgYtHz7w+RNETbHZ0PA7kenge7mskZJ3xy9aL4nfL2qvBKsjwNSfK3JqlF+kNvLWEirSXqoPb6iSxDwDup2CvhP/RTcUEm+YNZfgxt6+H2K5xirqnIITlPJw7PY8kvA4zFSCoYXK44cWr8NXIeUXt5a0aw2snEKypKLLHu64dooOg16oC2HyWkmFoVcAm31HM13eUNYp/xvbNvsbwqnQZ75G7bnF4Y9BPJudUNQce2Ue39jSNrpd1qM2xpm63w3/W1OV6WbVkM/RJCmgLxIO+Kaxi4jQn1kA+VO9cqPo7UholkNrI29M1RXBVWYGTQUwkvsRyyuf3UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wtqx6JBTSYj3yzJ4kcDcVONIHvQj7377/qK4XT2AJVM=;
 b=w8JYmB9WkS2F7BzkBzh223bnTZprr4PFz9M4fl1WYqn6Id0LD9GiLx6UabT5Fenv+9SA/qUrhZfx0mju3mOI7wdHVZBuyq+czYp32EdQRrBWXcrMgEVg0RbtiJ3KtpxN86yI1aOSadw00qFuW9C+cP1YLILVLvNaF0d73XpJST6DMem3LtBRxab97f4wruX0TaKgJ2AbSMv10uPx/ShhTngGvYhpq60EVvYWRTZiN/cppRjow1gmY2v+WSqKA8+bdvrSQrkx/GHP4pSXZlisLHuuaG6iY24njGlXlfZ66DYalrdv+WKx/vQZZS320/1AEXA9jy/p78S6ZVMp+fIaYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wtqx6JBTSYj3yzJ4kcDcVONIHvQj7377/qK4XT2AJVM=;
 b=D3dzPgM2k9xsR7DrxkpWt78/j5v2A8UsEYL44XvkeyZII5Le9WwLQy4htNx9k74yqF3sFKzhNovIx//qYrr0UQeCqGUPpTRUuy6+8gsfRgXGnyhs41AeW63CJmCzhb1GhYOAlLki2clTSVZJCDJCXh02dtSTxHbk54Umk7iP1o8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB6629.namprd10.prod.outlook.com (2603:10b6:303:22e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.37; Mon, 28 Apr
 2025 13:45:32 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8678.028; Mon, 28 Apr 2025
 13:45:32 +0000
Message-ID: <0296cc37-d56c-405a-84c7-4b814496e4df@oracle.com>
Date: Mon, 28 Apr 2025 14:45:26 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/9] blk-mq: remove blk_mq_in_flight()
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@infradead.org, axboe@kernel.dk,
        xni@redhat.com, agk@redhat.com, snitzer@kernel.org,
        mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com, cl@linux.com,
        nadav.amit@gmail.com, ubizjak@gmail.com, akpm@linux-foundation.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
        yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
References: <20250427082928.131295-1-yukuai1@huaweicloud.com>
 <20250427082928.131295-2-yukuai1@huaweicloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250427082928.131295-2-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P190CA0003.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::8) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB6629:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b548279-95c9-4d95-b489-08dd865af1ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QTNneW0wQVpDbERwTHV2TDE5LzM0TCtOTHBVb1VRR2ZRK3FGalVzcFpmRG5C?=
 =?utf-8?B?TTIvRTVhR2ZlZ3Q5NG50OUhJeU9SazVGSlJUNWdodVNMZDlRZGREU1k2eDA0?=
 =?utf-8?B?VjcvbUdjMVVkSEdkZTF3Zkc2WFY0Ym5CR1pVZHVPblNPUVFMeS9BTnRWNll5?=
 =?utf-8?B?cFU1bmtYa1Fad0dsNDIrZ3o1VTJlTlhMdGpzSUo3OVFFaEsyRXgyY2xZcVR3?=
 =?utf-8?B?VjA2RVRZWU9HOC9HV3BSbzJySXhJZG1sUUsyNFlmL1B1NjI2K0tWWGFkeXVZ?=
 =?utf-8?B?QU54eWkzd3ZSRXlvNWRLN0xrcGsrU2lhS25GdGdJdFZYeVJnbldIVUtSMHJS?=
 =?utf-8?B?WXFuVEdQRkNmRlRJaXI5REFnNVN5S2U3OUtMdTNKTWVHYitUOEh6eUozSlBP?=
 =?utf-8?B?RmpEOWFGTnEyb1B5djE4LzlkclFDdFdEa0RzWGM1azlTUE5CMnV2MXhxeSsy?=
 =?utf-8?B?V1RLUk56YXV1OG9ndUFTTFFZT0lwY3FNbFh6TW5RZzArWUo5Y09FTzRiWjFB?=
 =?utf-8?B?ZEpkMnhBL1Z4ZXFyODI2VnlkQmxnTlVIWmx0TGpHZTdUMTl5dGo1Q1E4blVU?=
 =?utf-8?B?d283dTNFUTVOZmNhYitOczBZL1VwNjh0YmsrbExRRWpKaDR1YmhSOHM5d1RB?=
 =?utf-8?B?Y2NXdzRtNVF4ekdnQ3RrajlkQXhaYit3cHR0aGZlZVJOa2t2WDVyb05WWUIz?=
 =?utf-8?B?VmxWTko2V00rNC9nSENOR1hraHBob29jSllQYnl1c3hCOVBIQmVjM29FV1pp?=
 =?utf-8?B?OVM4S3AxRkd1YjJreEdIT253ak9EKzNCbHpOcXpGL1EzajVaNGxPMTUvREd0?=
 =?utf-8?B?c1o5UU5iTk9FVzVPd1hrR2cvWkVobndXZ3ZaN3FXWjd2ZnhtNi94SzVkY08r?=
 =?utf-8?B?enVQbWRJWVRSQ0EwaVFuQzlGTzg2RklDY1NadTk0VU9uTjBsbkQ4dnBKWmhG?=
 =?utf-8?B?ZngraXZtc09rVmNFL2dkM2Jlcm9lNzBmVFlFdlEvSHQyaW91TGZLYXVqY2pJ?=
 =?utf-8?B?MWR2QUp5Y3Z2S0IyVStERkJ2cExWOW52ZlIzSVM5TUhwdUxSb1VUcjFmbVBY?=
 =?utf-8?B?NEhPMUdFam5ac0RFclR1dXFPcU9Rb1lWcDNacUEyc1kvb2MrcUI2UnBURjdB?=
 =?utf-8?B?UmExejhjV0gvTW56QW9QUVJab0t4RkF1TnpMY3JZVStRMDFPNHlBQjQ3UHVG?=
 =?utf-8?B?UEtwaEZjUHRlRkZVa2tOc2RvSzlUNEx2bGNMbjlMOWd6MXY4UGkvUE5QNHJ3?=
 =?utf-8?B?ZklUYTZTOVNwZTJtK1VPUjRPSGtvNnorb3VvMXpTdFN5R2RkUHhFQWlaWmFa?=
 =?utf-8?B?MWU4MmdkdWFVbmFwcUdZbzRkcndCWmprc3YyN3pUbktBaHNkSUZhWnAwTGVE?=
 =?utf-8?B?dm1Ba2dTZXRLR2xLalJ3bmN0ekY4TUk0TjEyUWwvd2NaRjMrWHlEbG90ZS9w?=
 =?utf-8?B?TXRYYk5hN1M0TC9uNlc1N2ZQV1lqb2tlZ0E5M3EwV3NGaHFWLzlOTmlRRVJQ?=
 =?utf-8?B?c1IzdGFGVjQ4UC9HNGc0NjBQRm4rTWR0OWRyWjI5TmZRUnRXQU5CVlBmVkht?=
 =?utf-8?B?T25LcUVKUXhsVlFhbXd3QXFUNnJjNnJWeEhCLzU0cEhQaGVxa29YTmZGbTBo?=
 =?utf-8?B?RStuQzducHlTR2diUEpDR1B6dlQySUtMNWxDT255dmhaWGpiWUNmMllzZDAw?=
 =?utf-8?B?a0w1ZTdUSjQ4Y1V0Snp6SmFncFIxMk1mZVJxYUliN3pkV3hEQkJ2eDdiakdN?=
 =?utf-8?B?MWRQdnFxa3IzbmV0dTlLZmRDVnNGcHcydFd2cjVkZUtKbXc1ang1NHhDWDhu?=
 =?utf-8?B?S0srODdZSGxSVytRemNDVTFGNmJXVXM2L0xUUmdFT1FLSVVhQjhtLzJHYjho?=
 =?utf-8?B?VjExNmJvc3FVN2J4R1RuN1VZOVdFTnVQQXhoVENLNXJJU21UK0VNVDB6ZURC?=
 =?utf-8?B?d3hNMnhMYWY3NVIvdllLZlZLVDRTVHVSSmsxTC9MMElKbGR5RWthRDJVTm5C?=
 =?utf-8?B?R1RRa2F5OVp3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WHlFNGxRcjhQUWRoMGJIdWdJUm9GUjQ2YmpIUkdUQzlPbWxFMTJETXZPQmN0?=
 =?utf-8?B?RlBkMjRxby9RVFdQZWtTNHdOQ1pwRTBnTmFHMlI0Z0JwSjR4VVFkbTNoQmhv?=
 =?utf-8?B?TnA2OTMrOTNWV20zdWsxOW9Ya0JIUExqcS8wKzFiSEhmWGJXR2JDVS95VCsv?=
 =?utf-8?B?eEpmaW13VVVxYU4yWm5TNlEyRE5HMldGUEVINXBGcURDd1hKdEoyMy9aMkNr?=
 =?utf-8?B?RXk2YlhKcm5Ec1lEaFZaZU9BU0syKzk4WHhRVjFhaUhMOUcxSGgxSS9yUTVW?=
 =?utf-8?B?UWdPcTVIeU9yQXEyN3YwazFlRGsyRnJ5UG5OeEdodFpJeXZ4TjZLNjNBeGoz?=
 =?utf-8?B?Vm5EeFU1Q2xFY0VnWE9nR0FQUmJRZ25VNnBCYVJpTDErOVJnWkZ6bzdFeThK?=
 =?utf-8?B?M1JXZXRZL3R1L1Z4eVJkeExSYjR1WGNJbCtqQ3U0MzhSdEFzZVlpSDhRVDJt?=
 =?utf-8?B?azRBL0VCZGluTVFoc2NNNFNyY2wxNEhGOFoyeDZxdWdMRmRGcm1nYnJyR1Zx?=
 =?utf-8?B?Slp3dnQ5RzRXRjVaOThqYmJNWC9hY2FiQmtweGJCeHRxYkVyd21IOVVvM0lB?=
 =?utf-8?B?VXl0ZVF6alc0SFY1KzZpaUo2TTBoZ21CVU5Yc3BFdkNMY2pPeFFxb3RucHhP?=
 =?utf-8?B?cC9qSmh4bG0xckg0NXg2b3o3d2Z3NlBpamMySkF1bzFBY2VJczA0T3pPZEZJ?=
 =?utf-8?B?UjB3c0hrZnBlNnVnTGNrZ2hxL2tjMFZCQ0hsRC8vL2dMeld0L2ZXODFkLzE1?=
 =?utf-8?B?bnRoWnpwSjd1NU03alVpM2dnZi9HTlVZWDRkOCtkSGNnQW91dS94bFR3RUhv?=
 =?utf-8?B?Q2JGcFpXeFBhOHhSYzRwclg3MkV5VzRTTnYwbmozUHdQbUVuZHZPZUVlMHJn?=
 =?utf-8?B?VmNQTGRZYmdWMEUxeFVkbGRzMFJPNGxOWEF6cEg1MysxVUpUeEZmdG4yMmkz?=
 =?utf-8?B?cFo2R1R2b09XaCtnTDQyRUlqQk5hQkFQRC9pRGFuVEloTXkrNjFLZmFUUnFp?=
 =?utf-8?B?eGE5Rkk5bVVsbTBJbGU0dmlGUmpHbGZ4RGNaT25FcmZoeW9uRC82UDY2NkdM?=
 =?utf-8?B?d0ZST1lZRTRrU3FMaVZhSUNhbFg2bUdTMjdDTW1Uc2drdGZ5aUFNdC83WGZT?=
 =?utf-8?B?dFhMeC9UMktKUjY2UGJlOC9aNmxLOEFhM1pDNnpmUzkwNHZGd05PQkYxZElC?=
 =?utf-8?B?b09GODE4a0laZE9JWk9YNFZGejJBdlYwTmRlS3NRK2NiaU5Od1U0eDZnZVZC?=
 =?utf-8?B?cS9vQzkzczBXbEZJdTZRbjErRHBpM0h5VzVlRHRJMCtuemhYblhROUc3OTBV?=
 =?utf-8?B?L2hPNHRBQ2RlUXVpRGJrQnF6T2FiNHU4MDlwekVVZXhjN0RvWHB2YlZUZzRZ?=
 =?utf-8?B?TlFia0NBN1h2UFVKbzRwRmFiWWthMlF0djFHcWJaei9VV0RnREFraDNETTNP?=
 =?utf-8?B?L2NKcWY4dm9CL0UzM0F1SGMxVi9sb0R2bC9VUFVMRDEzUktteS8zaDNQajZj?=
 =?utf-8?B?Vzh0dEdZRUR0cEhwOWVkazJZODNHcHFWU2k1R0pBVDQ5WXA3Q2pyZG41NEsx?=
 =?utf-8?B?TTdLZlkwNTFXWHpXQ2NmMnRMU3ZXdlJVSDUzczhveWpSYVFlWEdiU01sK0dt?=
 =?utf-8?B?UW4rOUJkWC9OMFJEaDAwdDBFWmYwQXhHTUtwYjR4Zm1QcG04SFJINGlxa3A2?=
 =?utf-8?B?eVFEbFBrWExrK01OK2t6aDIvS0tSdWs3K3BQVFg5b1JYcit6U3RYZnJQai9a?=
 =?utf-8?B?U0oyOXg5SzZSOXN2WGZKWktKU2ViOE1va1N3RTVoaTM0QlZvVDhaVVNrR2dG?=
 =?utf-8?B?VklnNm5ob3NJS3hJR0tKb1FVcHpWZmNxenh3aWtWNkZQZmp6TkcyTGZaaTdG?=
 =?utf-8?B?L1lBMzY1YUZWSzZxNUFOTFhSN2IrNUppZlhEajZRZ3ExdkVkQ2RzeWdMeHpY?=
 =?utf-8?B?ZlAxWWx5WHV1aTV5K281bWtEcGh6UnlHVnpzOGEzcS9RUDZQb1RFNVdkSFZp?=
 =?utf-8?B?c3d3K3JwbWF0dFJ6Y1VFaXdhVzdnZGkzSFJRTGhjWGhkY0ZVcjlXUkFuQVk1?=
 =?utf-8?B?NHJpZ0dQY2VTLzFJSkxwTXJ4VlB2Z0dQUHJvblI0OWRPbE9jUDVybXFkNm45?=
 =?utf-8?Q?9pcXZWhgPdN/iJo538lHv08sr?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	I7qyT+Id8w4X8aVkcTAlcnjzaSwSOsaVrrHE5fJehT9CYRQMFZKHyVI07wh++0j0Z34sPhUeHV8n6CHEzSdFdaLXYExa31OXgpvfJUcSS9uk/51TfxScAeP7HlWBhSJ9OLa17DykEQSZjbrLRaWjD5fYcQOMt1Ro8OkhrjKG2iDzlhRVy+OI1m/Kbn0c/wgVHOC2wBRJYCe5c/dck8tI9Ay2ElhNAf60QjMD5gobGsNcv0KXzkU3zxJBe+VJurqqV+j8AxLv8TGQ237hc6Vlq8Jjx/WJAVprxzANFVToLGakLeUbpT40glPXFALBnlwsCWMXEqk3OVGkm3bAoq/OLn2WW54lwjgtuuPp8HjqVffIeZehQvT31WpubNZUID4F5PbwO3tNeCddJH3DuFAyCgbA50XRRPNHQTzaIDJJAshhghpVv9up3BydeJwMlbRb4HH8+lyOn6nCK/x8yuDqeORvzPpyHAKs9kh5m3mluU6KBMoJsRD52vBebPU0wyVW5hl/qHkrsnUjH3f5SXkbCFqLuVZgBta8wtg+fI4Bs9ZM0TbpqVjesUBmE97UHoIkYpVaIK66YgOPrh6IDthfNiicYDYLt+M6axbgHQpzm7Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b548279-95c9-4d95-b489-08dd865af1ed
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2025 13:45:32.3809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZPYAIsK40a1Dk8DEIf9t/HA6g5rRRS/sYDczHowybbkRYn9tAaRCdk3mLJLopkLs9gRRNP7mtnRNpzzVeigr/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6629
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-28_05,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2504280113
X-Proofpoint-GUID: OO4_rsS-CSosoLtOXArsvzdtXdXYqhOc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI4MDExMyBTYWx0ZWRfX4TGr8LKTmRNn 177JpDfcF3uV70fdexXjSumbFSQTHeppagRlNpzGNX2iGrqsyL1neCRmpmvvJLZjfH9hP6tnxpM JBz788AJ4kC8op8iAFdpB93AF6K4EW0+XI3zmgx2lJhhWeCDkMO0biR531k7ffY1QNkAkGZ5dNJ
 KIYO9Ip9i0iIkg7l26JKlPTQnB7oT3WDIFPPKlS5Vv8T1PbM1IM7zyINptlDG886bulZ6Vw1hdf +fuVNyLZkDyhsqq5vBCb6QPFCANxjmJChBpdhed2WOW7BJv1jq8SuxKytAehvjuHx6Pou0ibdsh Bgeq/Brt/CO+w1S/mHaqAi1BIDLP84hkDzhy1rPOTVSgh93KEULZE++kDIU5s6m2ZgaxGA57sJP U9iEM9Ph
X-Proofpoint-ORIG-GUID: OO4_rsS-CSosoLtOXArsvzdtXdXYqhOc

On 27/04/2025 09:29, Yu Kuai wrote:
> From: Yu Kuai<yukuai3@huawei.com>
> 
> It's not used and can be removed.
> 

it's nice to mention when it stopped being used.

> Signed-off-by: Yu Kuai<yukuai3@huawei.com>

Regardless, FWIW:
Reviewed-by: John Garry <john.g.garry@oracle.com>
