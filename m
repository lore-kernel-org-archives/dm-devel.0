Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4688357731
	for <dm-devel@lists.linux.dev>; Tue, 18 Nov 2025 17:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763486575; cv=fail; b=j0muAtjpZmG/vk7qM2FaGmEe/9BzkiiBrbI5umIx4W5/ExnB1IzpXGlkSjcRx/AH5FvK+X5uiF9FkSAgLCVyDeW3ksIZzmkY3bdpto0rVk+J+BKusVh19ywvLDRUyM9nfTEPfEQfOQQAbpJSnWpHPjI0O450mWDtPNt03DWVHjI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763486575; c=relaxed/simple;
	bh=S63yhpgixaKRS2XWj0uVkWNLG+rc30/5/AC09IEeWLs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=saBx9lH2l5qwsoR243iV6w6j1sK9L0+MqxTHLQVwlCDFfwsjxJtcJqz4KUIg5ANb+kG01HR3zP7A1fGyIgNLpJFQyx0ktzzryG6FoHQSEoZhJGvpMglt1NOa7daTXavHoOPoOmC+YNaFdfiZVaqjCG4xObqlusTJ/+u87sig/34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Cdz4JEyL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LN8hp0K8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Cdz4JEyL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LN8hp0K8"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AIDSOq7020009;
	Tue, 18 Nov 2025 17:22:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=F29Hp/Rc3AiFhCiPC37LM6pCVojRbk5RXb6msAlA0nU=; b=
	Cdz4JEyLxYMSau8svO0cXAolw4oeCDwWzSD0Aa0v0NV82EA/sCwMXxkfw1Pks4BL
	LhrABztMxZezDY6+QiZLhysFhzXQ/a8tJ6CLDSfwZxu3h/eyp6ZEpuz4nS3SbVRd
	z2Z1h7P0BTDDHc9FPmOgNHyBjDQbuYHiOqE4mSqxJ9S2YEZnz3uGzHPTVq77+9uY
	W9I41yDGlVgF3/E07pRvKMDMXHG51rZsRhZeIGNKJ9KZYE1qg4LADtCkJyIBpDyl
	QtXBUQFvLCcJeOKWh/R7DIgcfTQ6KLRzDPtkYJ39c1hznEWLgO4i1Xg2Yi6dkGu0
	ohb4MEsMPN2eNx5tdOAniA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbun7ss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 17:22:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AIH1kdL004274;
	Tue, 18 Nov 2025 17:22:39 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010045.outbound.protection.outlook.com [40.93.198.45])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefy96jqk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 17:22:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YyNFmCSWNGPzxeoAUNKjI3H6yAQ/Tv7a0mC5MNtuj32bVBBhZRbTI+xW0hlbHxEsVu4lxIwz9fX5bA9u+eCZbgn396j0zzR8vkEyegehru/EnL2x5enjZ1/i9cgj+nDtfz1l9akm4VVze5KBrmABJqj8bCE+ZpdwGHCgmYDM+pcHGg8xOjv/fqixb2iB7j4BRs5NLDsEgu5AEuItTjgVG14iV4McO4RgZmYwLi8KteYWVKShAUFU2Qfy3A0nh6wIpHVtxpDd3RiLjDqRbZ0NNYGY/EDh/dIgwaauzZSbYeaBUWMLBFTl+qNyhlV3hwTXHH6fbH3zqyzSbymj/V9Fmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F29Hp/Rc3AiFhCiPC37LM6pCVojRbk5RXb6msAlA0nU=;
 b=JZ8M9ZJ8KTDe7KID9VQ51OkSgLJtGvFwrky+KVPYDh8VTuguRLqBv6XcWHIn3uyiuDg7FENFjncwUyN58PhNboyNl/9S+FT4XpP/VDT/GWD3iZ9g6rEaJyIXi/Np5S2mA9tDDJTipXa3Ipe9esmPwnpbW791adfTzVkyv9KVDmFPmRCQv8V3rOEHmoyjVHrKaSrs5CZA5cKj9md7FToiYGspmVztoYB0KBIGO2MA0B/q93VvCYl7m9ChYtLvNkSiyKYJc41mDjiMBCEbagBau6PKl5QzyvLjMUddSRAfkasQL8klkcnaojbfwFNV5MM6Uu3pUlrAu/8wxsEzmIzpKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F29Hp/Rc3AiFhCiPC37LM6pCVojRbk5RXb6msAlA0nU=;
 b=LN8hp0K82HGynaGGWXox8D+qMOFVgVxvfKaS4kW4YKaeoFjzrj08jLI+TeNazUf/l0tXzZbeJlPNo5VP6EcrV74tSaoBcHbEaeS7VnfrDRmKpptUQNaZ0bKOE1ZdidYiqwLVnjribpH8Ti9QG2j0C+17CfwM3MTl26EtGo4A2gs=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DS7PR10MB4910.namprd10.prod.outlook.com (2603:10b6:5:3a4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Tue, 18 Nov
 2025 17:22:34 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9343.009; Tue, 18 Nov 2025
 17:22:33 +0000
Message-ID: <22e40d78-8a14-4101-ba0b-58e94b494432@oracle.com>
Date: Tue, 18 Nov 2025 17:22:31 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] dm-crypt: enable DM_TARGET_ATOMIC_WRITES
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
        michael.christie@oracle.com, martin.petersen@oracle.com
References: <e0b99d8e-1159-a489-6df3-648b21c4f091@redhat.com>
 <6b3582bb-1e50-4e7a-972f-a82f62f46e7c@oracle.com>
 <9d2816c3-fc01-44d0-a9ca-4129515bd0ca@oracle.com>
 <4ba947ac-969a-49da-193a-ea5cea43c14e@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <4ba947ac-969a-49da-193a-ea5cea43c14e@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0309.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:391::13) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DS7PR10MB4910:EE_
X-MS-Office365-Filtering-Correlation-Id: 6695b4a7-cf73-4d8a-0da4-08de26c70f9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VFRaaHRoTUlpcy9aRUNsaWRTS0dCTzJlMjhNbHlhUERtVEdKci82dWJUUUUw?=
 =?utf-8?B?eGNMcjFZQk91elBscnRlL2xUMWwrYjlXY2NneHBScjBxQjMzZExWOERHajA2?=
 =?utf-8?B?VkxNZ1JQcGhXdHZYSVJQdUdZbG5TQXNCZndmcnR1Yk8wK294ZmVycFZDV2NQ?=
 =?utf-8?B?QnUzRTNENzQ1b3Q0dFl3K2dET0VrSFhNL2lHb1pJdVV0SmJodllQRTlFUGVI?=
 =?utf-8?B?cE1aVWNad0k4RXJQclQ5bXNFOTdiaFFBck9Fa3RyTTdaaFd1dktsTytUdTBm?=
 =?utf-8?B?OWZ2bDRZMkdROFhXMFY0d2xJZjZUaWJPeEhHUllXWlgrVkgxLzhEV2dOSEdz?=
 =?utf-8?B?ZlFwUlFRMG5sY0lpU21rNXlPZ1B5b1lpL1o3VlVtam0zeVJ4RGhGbkJTK0Qw?=
 =?utf-8?B?Z0tpRWRMT2l6SnFYQVlDa0JIUlFCVE13WE8wYkdvTVZlQjdleG9uc3E4N0VW?=
 =?utf-8?B?dm5lTTdvZjh2by9VV0xHYmtHS1lndWdBaG9PTy83Um1ENE5vS1ZaUkVYNWlV?=
 =?utf-8?B?M2lNVk82RUFJOWlOeXFySm1vbFpwWnZvK0VEeTlDTTJYTElBcHEwWHFaSExp?=
 =?utf-8?B?bmVVeU4zU2NjTjRHTDI5d1k4U1UwZ2ZZMUJDZ3R1dlpQOHRKNkpiVkFxR3Rh?=
 =?utf-8?B?WDM3dC8zWlI1UTBPa1FqQXV5UUpTUU5JcXRwUVdPaENlMjdYdXNQMUI3Vmds?=
 =?utf-8?B?ZHBERUJ4TU9XZmQ5Z0d3QU5BTVh0NzU4bFkwTDB1NEgzRFRKNUR0TktBVlYv?=
 =?utf-8?B?WVEyVkJLYk5HN0lLWFFxUnVCZTZyU1NCYWFCcm9CTWdISm5Db1NvU2xKbTZh?=
 =?utf-8?B?R3ZHRFpBU0xTNCt4Rjg0ZzNvdGx5NVhlSmNqK3c4b0xKMEd4MExvbzRlaFVj?=
 =?utf-8?B?N09LeEp2TzlFR0RRNkJkbVUwU01FYjRBNWxyTWFPM2Y2NjNhdmhHaWZidzJq?=
 =?utf-8?B?OXNYT3lueFhoU2VGbDZJdjNyZmF0dzBFMnZKT1NWMEJxZjFWQ0NsRzR1Z3R0?=
 =?utf-8?B?Uzdiak9SUEhUbjg5T0NLanFaeUZiQkZINjgraHN3UFdsN040bnNKaVZUUDlu?=
 =?utf-8?B?ZWtJNXhmT2Z3dGlySkZnSlJkN1Zvclowdk0vV285QjJlbU9XRG1lSUxCeFFP?=
 =?utf-8?B?TGtCSjV0OHBDMlN5TUlFbDFpRTNGcVRqeHdnYWxOT2xEU1htdkZMSmQxdzdL?=
 =?utf-8?B?aEpsYTFyeGFzK3Rwc1MwV3lPbjBYYVhENFhIWG4vWWl0UDgvWkthWTZvaVRX?=
 =?utf-8?B?R1NtaGQzN1BzMVpjaVVhQ0ljeDVjWnRGK3UyWFlGSFMrek1nSG82dDJIOGZs?=
 =?utf-8?B?bHVpaHBFajJMeDJXT2pLWlVDN21KR3FuWWFRM1JxVSszSjZaRFBDWlN2ckhT?=
 =?utf-8?B?S0p4ODRBUU1UV3prS2M5TENLUGlmbUV0SHc3UmMyWERiY2VUeU1MWjFBcmJp?=
 =?utf-8?B?MURCQVIzejRrVlJmT3RFVFdqblJ2akpXY0VxOTlNbDVLWmZrUEFGdkl0MlpO?=
 =?utf-8?B?Ynp2aEdubVZScVpXUnZxMitiTWIwbkx2dHBUbDRzK0lSTEcwYnlKclQyU294?=
 =?utf-8?B?VnVCYmIxY0UrTTlINnRISElVRDRWb3lyWlJRUzRxc1JnUUQyUDlQUGxtRnY1?=
 =?utf-8?B?TkdEcGF4YjhDZG5PQ2U0dkpmdkxzOGI4ckd2UGdob1hrYmpPUUR4Z3BuVXZM?=
 =?utf-8?B?YnArQ3pZL3cwdEJ6S3hZUThsV2UydjVmcytrcjhxeHFoc0pweTVaU0twMlhN?=
 =?utf-8?B?NWVPVTV1Ynl2aDFzNGpaRnhORmhWT0NDZ2NsUElnUFI5VnZxYlJQM2xGZi80?=
 =?utf-8?B?TE03RUR1QyswdytKVGhTcWhmOW1IZTd2NmZ1WkVKc3dia3hWUURBbTBDVk1t?=
 =?utf-8?B?Z1ZsZkdNbGZRdGxMb3p5S3VFU0FLbVoraUF3UlQzVWhRUVVuL2dncDhMNko2?=
 =?utf-8?Q?RHN1ceQE6gAf+pW3xFYgOzKqWBWXwlQQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MkRDSENjVE1Qc1R2SjhYUHVDM0VQdm1HNzBDaXh3VElPbm00R1MrQXozclhl?=
 =?utf-8?B?cUNEQUdtUWd5MVo0VU4rWnYvekZaRUJBNlA2QS9YejRkUyt1N3BLaTRPMEI0?=
 =?utf-8?B?am54cWUvcWllQ2g0dExDQzRkTEFZakNxR21uUldScGJXU1JGMHRNNmFvMmpL?=
 =?utf-8?B?S0orNVhNSTZKTVNGeTMwSmxGMjUvY2Z0U2RlVWtlcFJTbmlmNUZVbzZIR1NO?=
 =?utf-8?B?MEE4cE1xUzJSdGJrRUwvd1VUQ3VBMUdIV2VvcmtBRzJZZnFZR2hSWFZpTXZD?=
 =?utf-8?B?MEdXeHJxU1ZOaWVMUzBiWXVKeTZ1c1R1S2pjYWNVSUhHRFV1cHcxc0VYdGR5?=
 =?utf-8?B?bHJOQ3NwRGt5TjZrcWJUK1VTNHdkai83OWJOK3AwNmtCQ3VtSFBOVHdVOGpv?=
 =?utf-8?B?dmROT3N2dGhOQytmclpJVk1tSXd4ZStmZVloRlFyWk1rUEtpVkNCazNEVmtZ?=
 =?utf-8?B?UjVGam9yNGFsWFN4VlVVeGNicVlQTjJSZlFGT1NmblNCOTc2disyWXRHMVhK?=
 =?utf-8?B?ZStvTkxwa0F6ZVdQT2VMcGhSdTVZVUhaSTZ6OUduY2FTaTlmQTFhc05ma3I2?=
 =?utf-8?B?elp3UnI2NERHVmNUYi9udEdGQkJhR25JOFVqN1dlb2NRRlM0dFU0bG9QMUVw?=
 =?utf-8?B?eEpoUlEzWjZUNFJHczFoQ252S2lxaUJ0aUtXUy9VUGVMNm96ZEl0WkNkL3dQ?=
 =?utf-8?B?cWkyemtINTIxR2pjekdjbkhCVFVSZ0QrTkZKYjVZQkpWMU82MUloNG55ZHNu?=
 =?utf-8?B?OFc4UWt0TjhnTC9JWHIzSFl3VkZIRmZ4eG1jWW90b1F4OWswbXEzOFMwY0pP?=
 =?utf-8?B?MWhOb2FFcUZXOFBhQnJXU1g0Y0lwdmtuMy9TZW1WUE82elBJWm0rT0ZGNmh2?=
 =?utf-8?B?V1ZrWVpJbEM4Z1BHeCtjNFJVYTdyc2lzN2Y1UkhLWXhCNjVZdCtkYk1WMnNl?=
 =?utf-8?B?eWh6TWNvRXlBWnY1UHYrQzIrR1VxeGtScjRvdjQ4TG9LY0R1WjJ6Vzd6QkRi?=
 =?utf-8?B?Z3FoQ3JocFFBcWdFNmFJRkkyTjVLN1ZUSGNRc1Fwc1NmUzNvMmlMLzFrdlhi?=
 =?utf-8?B?UWRQQVlxTCtGbmxPOUh4aWlobEpMSFhWSVpoanpFa0cxczRDTndFYk96V3Yw?=
 =?utf-8?B?QWsyQytkT25SbnBxK0MzbFlneHFML096Y09ObUl1NXVOMUNMVm9lZjJJajNj?=
 =?utf-8?B?RWRFZE9xcnZ0RnYyZ1B4S2ppZmRzeEJyMTZQaEZFUzRTZ1ZHdHJSc2RJekpk?=
 =?utf-8?B?UDA5WWlXYm1QVGRYNVc3VSt4OUVVYlc0aXNoQnU0UjFKcGtoVzZFR0JFMC84?=
 =?utf-8?B?V2hlclkyUzhjTFU1ZTFpaDU1ckdudkNjMjRmczkzTVluYjRUTmRiV3R3blFX?=
 =?utf-8?B?K0crZlVTRThWczhtNFptMzh1Y3dURWtWd2t0ZjZjUDZkemFuT2k0VDRCa2lV?=
 =?utf-8?B?TFFLaTFqaTVQZDJ4Rkc3NzBDRmcrNitqUTN0SFcyQ3ZvYTRvUnIwOUtGaEwx?=
 =?utf-8?B?Q051clk5Yy9TN3F5cnZBK0hpclk4dEhONjU1TTNUbGhpTTFYQlFMS2hCdVhs?=
 =?utf-8?B?UGdZVG9UMEdmbmJjdGRLY0FDNGJzTFFkMzNFakhTTHVuMFEvVW1mWnBPazN0?=
 =?utf-8?B?VDU1L0R1MWlTbE1UTHptaWRsUUZjMXNkN2QybmdsaEt1Qy9HTmdDYXJobTJp?=
 =?utf-8?B?eDRRYktCT2lEbGVWMFprK20rVFpFT1RFdnZhUjZHTEFqSkZZakhlSTkwOUFK?=
 =?utf-8?B?MTBsb3JFbENhVVVjaWFMR053ME02bjRDWnpTT1dnOWN3M21WdGV6Q3dnbHVZ?=
 =?utf-8?B?eDRvbHg1YkxoQzdyWWw2RE45eWtkVnd2T1ZmMkJyOXNTaUdTdzdJbk04a0g4?=
 =?utf-8?B?QXpQYUZiU0VUNTl2MHZ6YVpGR3NMYTdCanBmaStpVFNCWmFvd2xZTmhSSTRC?=
 =?utf-8?B?OHF5dURrZjExelhZeEpqdTdpS2FObXRIeWRpRURIM3J1dWQ1RnhIRHhvbHV6?=
 =?utf-8?B?YW4vSHhaUGtjcFVtek00ck1XeG1ocmJPdDdCSWpqaGpCbVQ2WmJzdHBGZnhS?=
 =?utf-8?B?cEd4U2VxNjBuODFiUTNEOGdDcVp2V0ZCUnBWdzVSa0ZKUjVlU0FLekpjalda?=
 =?utf-8?B?bUlmVW9lTGVYZE9rQ25NQjRVRW9QUkdhQkNXTDIzODFTMmd3Wm1LcG5wZlhW?=
 =?utf-8?B?Zmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	d+YEVdpwEkcMvznXk1mFmmQpEaV+HvpsocSOolaSEy3z1Xuxfb8gpDLRnmJJvNUsoI8HFKZL5LWAt9eBB4IY00Vbguc2PaLKf26nbJRwnr/BCkBcJ1yLuKaUyZld5u0ENXYmSyx7kDpth8GiD2qh/PJPuGEIvDf94bC7CQwkDHFajKUDWg59Rc7O4HkZCxRnlypUMvU8zCCrzyNbNKb91GmlGbnldDpXNah2hkY0JBc6CTNnQPudrRFloSyqevSyf1QtdtBxts48Td2EhR+vQmyWcadFqpfZ3MWEbQvpLJG+SsfL1zrpW+BfEMy3qi/PcPd9Yz4kcLpdd9KDF4Ba1IDXe4s+/4DFYl1JfLfOk+Sd7eSjHRB1iyEq4HcNRhFf1x18FP/lRCTRr0Vf6ODgqSiiiJd0NTC7iY8bGIi5tZqzs329dOyumleJtND1V4XopEgVP1QXiHPvwuY5o4tzwKFFVZy6f2fQqdVx5IY3xhMJgJwrnL11DequSm3tJRbFWKffNnnuXzJdPiTFnMLfune0CIi4VkZgx06XoE9cjxA/JKYgSW/0ZnGAmaOAKhS+sMrj6F235viYdcf7oL67Ykn+sLcOAd99xl148AuE+Mo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6695b4a7-cf73-4d8a-0da4-08de26c70f9c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 17:22:33.7735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xrrPhDzLUJv7DpeQXtoNxrPEvUGOzil3l8izftq9gPMXxuk747WFvjFpGiKJuDYuFKM6Pe3yc2Odv6bnSKUYfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4910
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-18_02,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=914
 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511180140
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX8jvuRQB4p0aw
 1HhTzqwxUSGuDDCJ2+933LnnjugxWHI8tfIAZ8W/RS3G2IJMWm8G4zzgKZ2joO/5VERICdeJbwi
 JN/JmBoN/tXzWI/AX2xeAE9Dfdnqh4nEtPT8WbvLb8DQdxjmVqruAZp2QqWsrI1by32mJdp/6l6
 6Eei/Axo0+QhXBuCA3kwyBPIoPLKDdWThchxYPAa563C5cKKgrQqq8nCis+dzbLrLcTCBOqFakJ
 P/5d1pZGM9x2cbZb/w83QTkbNpvM+CVzt1/PLaAzHQ6eUz8zEZ+5YrDYLti7YX70IWkTAP14T+5
 u7875YxF9Ra5lcvB3dfMUd0Q0knkY9tpg2JKfug/oEvDw3QFC4KDPeQx0HUMuBHAfcm0aW8tELo
 tEOMBwEhjNBRFpz7L5K1UsK1024O2Q==
X-Proofpoint-GUID: 67cMBt5dEtUBdKy0BR6I132NwJ2fWp22
X-Proofpoint-ORIG-GUID: 67cMBt5dEtUBdKy0BR6I132NwJ2fWp22
X-Authority-Analysis: v=2.4 cv=Rdydyltv c=1 sm=1 tr=0 ts=691cab60 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=IjDYGp9YzUDGJKVX-4cA:9 a=QEXdDO2ut3YA:10

On 18/11/2025 17:09, Mikulas Patocka wrote:
> In crypt_io_hints - should I set "limits->atomic_write_hw_max",
> "limits->atomic_write_hw_unit_max" or both?
> 
> I think that we haven't settled about that when we talked about it.

If you are going to set one then set both of them.

I already tested this, so it's fine.

Thanks,
John
