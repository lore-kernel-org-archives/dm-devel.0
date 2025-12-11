Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazolkn19012055.outbound.protection.outlook.com [52.103.66.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD6B2C0307
	for <dm-devel@lists.linux.dev>; Thu, 11 Dec 2025 07:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.66.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765436600; cv=fail; b=unTy9+AZyhOgBC3TKo+nHjqvhnqGzZGheHkInCczrPq1htW7ogRFsl48489sO9JhZ5xX//AmJwBMR6Aug+ODA4h4xNN2J4RrqCSvH1kVEDZ7C2Nd11yU1tigoQcAjO3h1czrm80gUAbzz4kIOQPlAM7HOyxRaCzFIc60T0OWV1Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765436600; c=relaxed/simple;
	bh=6JXQDjVgs13MMvghaLC74ifafX7RE12HXyxsGuwKUMY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MFPmnNEHOkvTSyHQcpsxo/GigO68ISpGhbADgMEfooeFeu+9gH9Umb5QI/rZeL697eKUNUImWJonenfZ5Ygkgg45ET9Q1wMyvSWcpL5X6iiokQS3Qz7jNsvCiGoFlY8XAoG4R3jQXjHotE05ezEd4xNo7k0tQ0O207tiHSklQes=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=K2QvWyLo; arc=fail smtp.client-ip=52.103.66.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="K2QvWyLo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AjZdOqgdMYJAUnDo+SLJYf6taT9864fPeGHUv20Yw7qETq7V/sGWazxT0rTYEK7kDyVZJKRI+8YR+gmQ7XO2bJC2vw1mpccnInLqRHGnE15XqLTrp2u2wbtak0uwU1S0JCjg6tONNv+JT9DFyon5/DGW85fMh1Zi7Zl+cmsJkVbxePEBhzGVRD9Jt+c6rzbr02tTnJwapc/ZdVxq4aOW5FXl0/86kw3ws+lZUBpYXE5vRGHyJxwvD4tDUn8Qyoz0vQr3IiXtT6sS1KvXGCT9mctC9rOCVrZbGkUMEYpZoLklBP5oGBzaYH2Z0LbQEvcFpTUImn9/7bZKAfVp55k5RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GO+Wh+NeK5VfXRYyxqqa7ZhreGN7a67zYTWXAJRhr48=;
 b=RS6ju1c8l1LuOl+s2G0x9ixSfYWg+zArRzF+o1vrJmfg53/40kZkxR9zs07nVcW2tfKp/QTbIN5dUIecfHs+xn15mf5z2k4ogiBSxV0K9vxIDSklJ6k0dIpGuvIPFPkzcQ0izzEeHFExcVbQ1EQHxHSHcISjx5R2ShNkdlsB/Gdf35G4N6xDsBPezV+Eyr8Tz7vNydUBkJIIoFmFGB6E5wow+vZp+rQAca+qEC08mxpbaD0AMpXzwbQNQRrb6SHne2gVMgMnMA87Ee/q1yroNNBVa2DnMmCwZPWKghUA5bwOsPGxlk93eZQmdWojAlb00bJb8+YKTJRFroqnpO8rOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GO+Wh+NeK5VfXRYyxqqa7ZhreGN7a67zYTWXAJRhr48=;
 b=K2QvWyLouO0Y+y4Z5DnGGHfdNmMNGKL2um4aaDJHD/wDe38XsOFwsDuNyx0urd4mtVTJVoGsPfA2K4eYDo/BRZA7pw/IkGfQrtckbW2wFhMZH/qxN6nzlzBsjnt5Et0V7dO+Dd4gBvUCnhWnHkytWfIHKIEdQMHNZwuKiaasOWloR8F7lpYLJgxfveT+6SDyER5+kkDGff0YZAUEdOyBhx2dluiFBRHR9mW6hz/T+bHl0JPKLKAGi1lWo7gKzDouZuOoSrjt5nVZQL/A4HvCaMZrC/2AmLZTJkdMw8oT3/Ba7ga70t6yrg1M5n7PrSeNXw4huMn+s+9+dlkiS/2XaA==
Received: from SI4PR02MB8696.apcprd02.prod.outlook.com (2603:1096:4:26c::5) by
 TYZPR02MB6815.apcprd02.prod.outlook.com (2603:1096:405:21::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.9; Thu, 11 Dec 2025 07:03:14 +0000
Received: from SI4PR02MB8696.apcprd02.prod.outlook.com
 ([fe80::5616:802:bc6b:aba3]) by SI4PR02MB8696.apcprd02.prod.outlook.com
 ([fe80::5616:802:bc6b:aba3%4]) with mapi id 15.20.9412.005; Thu, 11 Dec 2025
 07:03:14 +0000
Message-ID:
 <SI4PR02MB869655E1A6EAD8A9462F432899A1A@SI4PR02MB8696.apcprd02.prod.outlook.com>
Date: Thu, 11 Dec 2025 15:03:12 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] dm-stripe: adjust max_hw_discard_sectors to avoid
 unnecessary discard bio splitting
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Yongpeng Yang <yangyongpeng.storage@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
 Yongpeng Yang <yangyongpeng@xiaomi.com>
References: <20251208100713.697542-2-yangyongpeng.storage@gmail.com>
 <aTkOIzJVOcEJB7SU@redhat.com>
Content-Language: en-US
From: Yongpeng Yang <yangyongpeng.storage@outlook.com>
In-Reply-To: <aTkOIzJVOcEJB7SU@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0003.apcprd02.prod.outlook.com
 (2603:1096:3:17::15) To SI4PR02MB8696.apcprd02.prod.outlook.com
 (2603:1096:4:26c::5)
X-Microsoft-Original-Message-ID:
 <5832d571-a40a-4bc7-b1bf-abe9bde7d152@outlook.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI4PR02MB8696:EE_|TYZPR02MB6815:EE_
X-MS-Office365-Filtering-Correlation-Id: d3a62422-7313-4b99-8ecc-08de38835a9e
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|9112599006|461199028|6090799003|5072599009|8060799015|8040799003|19110799012|41001999006|39105399006|12121999013|23021999003|440099028|3412199025|40105399003|3430499032|3420499032;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ajNISkZabGpxQldzWjFobWVPQ0NzUUZwRndieDBLditJc0Jiajlxd1BYTk83?=
 =?utf-8?B?Nnc5ODdaUU1GVWkxbFA0ZjcyQ0NlanBZNU9lcmMyUXg1dWtKajFPaXRKSUQx?=
 =?utf-8?B?M0RzTVlZWndkK2swb2luZDhMWnJnY3ZQdzJ6cXF4bXRZY3d5ZGJKNUs3NUdT?=
 =?utf-8?B?eWxsclVDOEZQSm1Fc2FYWDI0OHJVYlpwNGVsekFYR0MrYUllUVlNRUFYQVVY?=
 =?utf-8?B?UjcwVmQ2V2lUMlVzVE40OFBjeHpEMGF3MGtFNUlYTDNBaDVQdk92bFVpUm4y?=
 =?utf-8?B?Nk1rL3hmZ1FtWWpiN0U3dnhPclQxLzJCbEh1TkY4ODhCUEs3Mkt4T1kwQ3BD?=
 =?utf-8?B?QXkvb0JUM25KVURYcThWRks5dk5tWDlrQk9pbVFVWE1JSTVwcHErQmEveWdk?=
 =?utf-8?B?YXJkSXFCR1FpejBDczAzdmtFcDdEQUc0NWJrTlE1dGFralF0MFpnd1JHU21j?=
 =?utf-8?B?SlNMT2pvZVdPZ3dPckNIU2grWndpWWtSSVRHcS93RWdSRGFXU2R1WWVTb1dj?=
 =?utf-8?B?cTRNTTZweVZ3L3I0bnlLVFg1MVlLZXNOZlpmMWRYVDQ1RU82ZG5weXg0VlNH?=
 =?utf-8?B?TVRMK1ZwMm5FNFgrS012MHFGd1dPSmh4UUxTb2c4V1RTV3RQL1F6OWxmUHZR?=
 =?utf-8?B?aks1eWx6Nk5oUS9XVjgwVEhGY2xVR1hzdytleHc5R05yZXNYb2FvWnBJSDE2?=
 =?utf-8?B?NVhVRUhtdnZENXJHU0NqY3lDcFNoLzRjb0RwV2htY3BpdVdoRnJ6Z1VDOXFv?=
 =?utf-8?B?bWpDRWVOSG9sRC8vREF4M1lWaEZCTWlxQ1BCSGxFOVEvVkpaWGRvME1wUGpv?=
 =?utf-8?B?N0JMd2RFOXE3bUNJWE9rQ2RsZEYrVm5tb2lMT0RGYk5KUEhFOWJmQ1F4Q0hD?=
 =?utf-8?B?Y3NnTWNubk1POGE1M2svWUhHcExBNG1hSEFmemVLTitzRUw2cHFia0cycmFX?=
 =?utf-8?B?WTM1aVhPTWZDMThzSmgvVkVRR083Vjl2SUJIKyttckg4VGNWd1lqb0paSVJa?=
 =?utf-8?B?VFM4L2VMOFNRNTVia0tkbmZxNGtrUXZiNE1JMFkwWnMyYi9iZjVERUsxdlRn?=
 =?utf-8?B?TmNmVG1rOFJIQXk1MzlUUUIvTE00VVExUE9tYkNxOGl1SzJNYUVFb05oV01Z?=
 =?utf-8?B?RHZDcVAxTTNPZloyeDFzaVQ3QTBkMW1saHVXRlR4NmtpRitJbVBMZ3FERjFw?=
 =?utf-8?B?dVpIRUZOa1NKd2c1eU5lbEFnSXhGRGU4REFaMWJ0aWVocGltTGdsbDh1NGY4?=
 =?utf-8?B?VGVNU1c0TFM2RWkrMnQwencyVGhTTnJRNDdSR1c2U1o2YTEydWl1MVJ6MDg3?=
 =?utf-8?B?THZWdnd2Y3JWWFRYMVZnUE53YTFRMk1TU09IUEFnbkNEYStnRWNMa2tZQkdH?=
 =?utf-8?B?UGQrTkx4Q0xneWdtQklIZWZuSG11M0xsdkc5VTlXMHZpUXpGdFVPY2ZOd2NF?=
 =?utf-8?B?QzJ4dHlLcXZZU0x5Nk9zbW9PY0dpb3lKTGd2VTJJUDJzODU1cVdzVTZ6OXQ4?=
 =?utf-8?B?cmRZZXRic1EyMlY2RU0rekdjMThNbFl1eUxhdzJwckw2ejluNDlrbmQ4cjdD?=
 =?utf-8?B?bGtWeEhSNkEveHJ4R0RYaWtGM2xWaGNhQ2FobVA5ZW5EalNiVVFsVThNeGQ0?=
 =?utf-8?B?emVPb0FhaTJHU1pSOWpNUU5nOE9VSEppOUZiOXVFT2JVUUU4RFF5cEI4c0VU?=
 =?utf-8?B?YjYwZlV4T1h4UXJIQzZoUk1MN1ZlN2ZXTnA0L1pjeDVCRkpmd2xOVVJYNTZ5?=
 =?utf-8?Q?mohGpX9kXt5r5FIO1I=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MmZTYVZHVUp5Rm9kRFNpb3NhdkU0VlhUeFF6MFNoc1o0UExPSkFOSk8vL0hC?=
 =?utf-8?B?U0tLSUo4b2o4alJaUTZTdno5WUhUanNuVk9QM29jc3I2ZXdObWRZYVVKKzlI?=
 =?utf-8?B?aWRLSkx3WnAwZGN5TXBqVWpjS0hvcWFoZDdlSGU2Y0Erb0thSmd2N1E0T2pD?=
 =?utf-8?B?bTBjZzdWVFpwbTlCV1pVUVBPQ2RzZmdTQjdPdW1XYmo3MU1WRXhNTnBOd3lY?=
 =?utf-8?B?dzE0aGNrVEJqczFyejZId0hEbm1SMTFDMEZKZS9ZQWZCU1N4QUZBZnJCMjhi?=
 =?utf-8?B?aC9Eb0tYOVN0Ry9BQ2puVm5MRDhsNXh2MkxNcG4wT1h1N2pCSFdPbTQ4cE1L?=
 =?utf-8?B?Ukk5ajFyQTRUb1F2L1VDZkZHdFU3eDdyU0xhTXY2VjhWTUtLdGtLT0lBNFhL?=
 =?utf-8?B?eVVqMTYwNXZhQTBjL2hMM0xLRWZPZWlHc2FKbVFheXB3QXhkN0NpeER6aXlm?=
 =?utf-8?B?a3JhQjcxTXh2aU9CQ1hqMU5TSlRsZEVvOFdHTnR5cURQSkpxdVFOcDdDYUNI?=
 =?utf-8?B?SmVLZTIvM2ZCZm5QYjAydlcvWFN2cGI1RmZtOGpnZTZQQTBhOWlzRE5zY2RC?=
 =?utf-8?B?YmxwZUFiWmxoUkpqeE9tMkxkYnBJWmkwTHRBU1p2U3JJMVRFZlRvbU5LRS9y?=
 =?utf-8?B?MWh1RjlBSHpZbGRFQXJLVTZEaklyOWJ4eHQxRlRmU1BucEROMWpIMnBwdWZH?=
 =?utf-8?B?M1djUGF3QzViMVpja1czeDV5V2xiTE82R2lnaXZiRmt4NWl5R3grR205Nlpr?=
 =?utf-8?B?aE5sTjRzTmxhUlNTWkIyZ0VKRjJ5c25MSCtRT2Q1Wm9McEtTcVh3YXVUZDZx?=
 =?utf-8?B?WXpaQlJVNXh2VUc2Nzd3L1Y1dE1Cbis3V2I0cVZUUjNiL1BIUVdmSzE0WEE1?=
 =?utf-8?B?RERkWnpQcEVNb00rQkdKUVdoM25VRlZGL3pwbGVkTTRtNlpzcGFqUVRpRVJI?=
 =?utf-8?B?MFFyaVVmQkxjNU80aGQ0VVlMbEphdlFYNUV0bmQ5bDE5UGY4ckM4VzFPTVZT?=
 =?utf-8?B?Nm1rano4a3REZUgzOURKL2ZZZGYzRUxvZGVhalg2Q2h5QlFCUS9DSGg1cmw3?=
 =?utf-8?B?R0RsMWMzTDA0NkNwU3dleUZQeDZ5Ny9NM05CUVhDaEhYQW5xRzh6ZDdPK3R5?=
 =?utf-8?B?MzZwSkJCeUNiM21JK0ZRWlEwaHNnRnlEbDBvVGNWT3ZCa1JWQVQ2eDZ1ajBI?=
 =?utf-8?B?cnN4OTBObmh2MFhPNnNFOWFKL1NTVFZMVTB2QTNQa29ob0ExZVpCaFJXMU5D?=
 =?utf-8?B?WGdXZDVIQzlVLzdva2taTEJpbWxEZnJRNnNWemF5MnFjaHBqeEEvY2xMOWpw?=
 =?utf-8?B?Mmlaa2s0V0ViRjMrMFdHbmN6dlZGRlZFOGo0eU5Ha1FKRjdLM1hJQ0VLai8z?=
 =?utf-8?B?Q212cXAwc2k2bWpGTVFvaGx6TDd0L0RJUWVROTg1SDZmdC9mRlNDOWZ3RkI1?=
 =?utf-8?B?Z1FBZGZCSTZ0TDhibnRXUXRFQTN3cU1nT2J1eCsrTzJjK2EvODJ4TG1vQ1Q2?=
 =?utf-8?B?ZmU1NVNCQlphOUVLUDZ1TGd4bXZlVDhZY085dmhBY3plMElrck1QVGR2Ykgw?=
 =?utf-8?B?UmhtOEZ6TmV6WWp1NzNxVWw3R3hLZHdzNGFFUG1BaVVJSWJwOVlhbTd2Ni9C?=
 =?utf-8?B?aCtBRzY4MGdPVVhRcXhlRVZkSkw5MEdEVmN1OS9TeUtMRnZ0WGdLQUYyWHRK?=
 =?utf-8?B?WjNudTRCUFhySXFJeTNkVXBTNlMwSEFFdlM3TkFXMzF4MVdZQUM2UVlRPT0=?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3a62422-7313-4b99-8ecc-08de38835a9e
X-MS-Exchange-CrossTenant-AuthSource: SI4PR02MB8696.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2025 07:03:14.6739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR02MB6815

On 12/10/25 14:07, Benjamin Marzinski wrote:
> On Mon, Dec 08, 2025 at 06:07:14PM +0800, Yongpeng Yang wrote:
>> From: Yongpeng Yang <yangyongpeng@xiaomi.com>
>>
>> Currently, the max_hw_discard_sectors of a stripe target is set to the
>> minimum max_hw_discard_sectors among all sub devices. When the discard
>> bio is larger than max_hw_discard_sectors, this may cause the stripe
>> device to split discard bios unnecessarily, because the value of
>> max_hw_discard_sectors affects max_discard_sectors, which equal to
>> min(max_hw_discard_sectors, max_user_discard_sectors).
>>
>> For example:
>> root@vm:~# echo '0 33554432 striped 2 256 /dev/vdd 0 /dev/vde 0' | dmsetup create stripe_dev
>> root@vm:~# cat /sys/block/dm-1/queue/discard_max_bytes
>> 536870912
>> root@vm:~# cat /sys/block/dm-1/slaves/vdd/queue/discard_max_bytes
>> 536870912
>> root@vm:~# blkdiscard -o 0 -l 1073741824 -p 1073741824 /dev/mapper/stripe_dev
>>
>> dm-1 is the stripe device, and its discard_max_bytes is equal to
>> each sub device’s discard_max_bytes. Since the requested discard
>> length exceeds discard_max_bytes, the block layer splits the discard bio:
>>
>> block_bio_queue: 252,1 DS 0 + 2097152 [blkdiscard]
>> block_split: 252,1 DS 0 / 1048576 [blkdiscard]
>> block_rq_issue: 253,48 DS 268435456 () 0 + 524288 be,0,4 [blkdiscard]
>> block_bio_queue: 253,64 DS 524288 + 524288 [blkdiscard]
>>
>> However, both vdd and vde can actually handle a discard bio of 536870912
>> bytes, so this split is not necessary.
>>
>> This patch updates the stripe target’s q->limits.max_hw_discard_sectors
>> to be the minimum max_hw_discard_sectors of the sub devices multiplied
>> by the # of stripe devices. This enables the stripe device to handle
>> larger discard bios without incurring unnecessary splitting.
>>
>> Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
>> ---
>>  drivers/md/dm-stripe.c | 16 +++++++++++++++-
>>  1 file changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
>> index 1461dc740dae..799d6def699b 100644
>> --- a/drivers/md/dm-stripe.c
>> +++ b/drivers/md/dm-stripe.c
>> @@ -38,6 +38,9 @@ struct stripe_c {
>>  	uint32_t chunk_size;
>>  	int chunk_size_shift;
>>  
>> +	/* The minimum max_hw_discard_sectors of all sub devices. */
>> +	unsigned int max_hw_discard_sectors;
>> +
>>  	/* Needed for handling events */
>>  	struct dm_target *ti;
>>  
>> @@ -169,6 +172,8 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>>  	 * Get the stripe destinations.
>>  	 */
>>  	for (i = 0; i < stripes; i++) {
>> +		struct request_queue *q;
>> +
>>  		argv += 2;
>>  
>>  		r = get_stripe(ti, sc, i, argv);
>> @@ -180,6 +185,13 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>>  			return r;
>>  		}
>>  		atomic_set(&(sc->stripe[i].error_count), 0);
>> +
>> +		q = bdev_get_queue(sc->stripe[i].dev->bdev);
>> +		if (i == 0)
>> +			sc->max_hw_discard_sectors = q->limits.max_hw_discard_sectors;
>> +		else
>> +			sc->max_hw_discard_sectors = min_not_zero(sc->max_hw_discard_sectors,
>> +					q->limits.max_hw_discard_sectors);
> 
> I don't think any of the above is necessary. When stripe_io_hints() is
> called, dm_set_device_limits() will already have been called on all the
> underlying stripe devices to combine the limits. So
> limits->max_hw_discard_sectors should already be set to the same value
> as you're computing for sc->max_hw_discard_sectors. Right?

dm_set_device_limits() initializes the stack-local ti_limits defined in
dm_calculate_queue_limits(), and stripe_io_hints() modifies this same
variable as well. These updates do not affect the stripe device’s
q->limits until dm_calculate_queue_limits() later calls
blk_stack_limits(). Therefore, the q->limits.max_hw_discard_sectors of
each sub device in a stripe target is never modified and it is necessary
to record the minimum q->limits.max_hw_discard_sectors
across all sub devices.

> 
>>  	}
>>  
>>  	ti->private = sc;
>> @@ -456,7 +468,7 @@ static void stripe_io_hints(struct dm_target *ti,
>>  			    struct queue_limits *limits)
>>  {
>>  	struct stripe_c *sc = ti->private;
>> -	unsigned int io_min, io_opt;
>> +	unsigned int io_min, io_opt, max_hw_discard_sectors;
>>  
>>  	limits->chunk_sectors = sc->chunk_size;
>>  
>> @@ -465,6 +477,8 @@ static void stripe_io_hints(struct dm_target *ti,
>>  		limits->io_min = io_min;
>>  		limits->io_opt = io_opt;
>>  	}
>> +	if (!check_mul_overflow(sc->max_hw_discard_sectors, sc->stripes, &max_hw_discard_sectors))
> 
> sc->max_hw_discard_sectors should be the same as
> limits->max_hw_discard_sectors here 
> 
>> +		limits->max_hw_discard_sectors = max_hw_discard_sectors;
> 
> I see a couple of issues with this calculation. First, this only works
> if max_hw_discard_sectors is greater than sc->chunk_size. But more than
> that, before you multiply the original limit by the number of stripes,
> you must round it down to a multiple of chunk_size. Otherwise, you can
> end up writing too much to some of the underlying devices. To show this
> with simple numbers, imagine you had 3 stripes that with a chunk_size of
> 4 and all the underlying devices had a max_hw_discard_sectors of 5. You
> would set max_hw_discard_sectors to 5 * 3 = 15. But if you discared 15
> sectors from the beginning of the device, you would end up discarding
> the first 4 sectors of each underlying device, and then loop around
> discard 3 more sectors of the first device. This means that you would
> discard 7 from the first device, instead of the 5 that it could handle.
> Rounding max_hw_discard_sectors down to a multiple of chunk_size will
> fix that.

The splitting of discard bios is based on limits->max_discard_sectors,
which is independent of the stripe size. As a result, the discard bio
size passed to stripe_map->stripe_map_range() may exceed
`sc->chunk_size * sc->stripes`. In the example above, stripe_map_range()
is invoked three times, and each invocation reduces bio->bi_iter.bi_size
to 5 sectors for each sub devices.

> 
> Lastly, if you do overflow when multiplying max_hw_discard_sectors by
> the number of stripes, you should probably just set
> limits->max_hw_discard_sectors to UINT_MAX >> SECTOR_SHIFT, instead of
> leaving it at what it was.

Yes, I overlooked that. I’ll fix it in v2.

Thanks
Yongpeng,

> 
> -Ben
> 
>>  }
>>  
>>  static struct target_type stripe_target = {
>> -- 
>> 2.43.0
> 

