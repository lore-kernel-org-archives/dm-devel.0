Received: from HK3PR03CU002.outbound.protection.outlook.com (mail-eastasiaazon11011042.outbound.protection.outlook.com [52.101.129.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA832AE77
	for <dm-devel@lists.linux.dev>; Wed,  2 Apr 2025 10:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.129.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743590123; cv=fail; b=EoTAb5YM1msGv4KHNV3/eOqKW8egvdyLsU9iiJqyLXIK2KyJ2KySqzD94wkPAzwbxAKZD3sf7dJQB1+JXr3ysrkXKrz3xKmg4dzaZqQuGGeqzN204gcTGneJeF41EY1ibCr4h59TKuMohStj6Jc0vPAkT6eCGWaPn3xmYPQptsQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743590123; c=relaxed/simple;
	bh=RPnpz5wugo4dUEyj92Xjoj5Pul4lNCwftFQylGzCSvY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FEM7xudgcGwpC4WCNHl6go2i7YNdGd1J4HCM+2MHENvKHkiBoBHwLO7xa/xRTN63MhtO0SGcUYqU1CbRuyQsWbuQABQ1zEjx2NsoNn/t43jrMCXvrIMs80Td9h5cCYcNuh7XUOZ9m6Pd1i7aDhLdpSe6dn5er6pHw1oU430Xt+4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=KaUrdKGs; arc=fail smtp.client-ip=52.101.129.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="KaUrdKGs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xfrk8/sJvE5yx8J1r+gB/XmXl0DhOOzw93QAIWZiKTGyFjaNCNvm3ou09/0Wd0gPeMj/UTxRyqRKJ9rCUlh3D8oy8Lf7AsbnjiOhcQ+kPAM8hextOd1/lBoVncjcsSvquxNPwlyvHwgBsxfk98XpYAy5NEOWqF/zvcsBdueXDDOGYVaRNksVsY0MDdY0wQKqlg058VaJ0uJV4Zd6gSaqiepIKT+Fo/7xSYr7xZwSWW7jouZrIYSHcYQhHbd4lc1pnwnR001DO03f5IndrPvMa5+0/8hXE+ZHD61iDmV61wpj9nyC2IC7Yffl4RO7RPnP8Z0J4YetNBHp+7r3Lyl3Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/y58yZUoRoAA42Lmf/n8yBjn1t1hGT4iNPQPobBHuas=;
 b=ylI3e0ZdcHglpylBowVAd1NSE024Z+zWy5JgsJ/Pia0Wy5HuLxHW2nP2xmXxYKqdzN4jJmnZPJuZSC5gY+wo9FMJyKtrVKtSYCn8vOjAOt0WIY2fuCdPcSRrI4N3ep8Npg7m4N5ba5Ol27UD4rMoCYiXmB5OC6Fv5WX5Ya2yhMbTuf+fHVChKvleuTGzPDiCwtqPzDo5z2yKt5vHPmIWrD+c+PYcwVd+a8diyAFYrmTwAc3ul8rhaliZoxdilNvtj81FAF/cqb9MutnKfo4PRF+WNGu895SjJZEn2lee9bGQJTD/UxBwYfv6i0IZg0jTzr67JJarsdByf95FJhOekA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/y58yZUoRoAA42Lmf/n8yBjn1t1hGT4iNPQPobBHuas=;
 b=KaUrdKGs0r6w/8RKxNcai4iUCfUgYYkL4pSvTdbkdPZVmWotVuhDT+XTMJXtAOHrdqxxWv4hYNkepj4qoU/B6r1NDKQpURG3uygzUVpg2cP9QUSjRpVIDJqPouLy3zcOQuMBBuGq6N+fwuo8TdqsTVNjDtFGCC8k7FjgoSaqLrc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by TYZPR02MB7077.apcprd02.prod.outlook.com (2603:1096:405:2c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.21; Wed, 2 Apr
 2025 10:35:17 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8606.019; Wed, 2 Apr 2025
 10:35:17 +0000
Message-ID: <d25b56ad-fa6f-49db-9a78-d4849742b22e@oppo.com>
Date: Wed, 2 Apr 2025 18:35:14 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] dm-verity: prefetch all hash blocks in verity_ctr
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: snitzer@kernel.org, dm-devel@lists.linux.dev, guoweichao@oppo.com,
 ebiggers@kernel.org, bvanassche@acm.org
References: <20250402070934.2387587-1-weilongping@oppo.com>
 <20250402070934.2387587-2-weilongping@oppo.com>
 <8ec81db3-fff0-71be-e643-b74cb5bb88de@redhat.com>
From: LongPing Wei <weilongping@oppo.com>
In-Reply-To: <8ec81db3-fff0-71be-e643-b74cb5bb88de@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCP286CA0310.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:38b::7) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|TYZPR02MB7077:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cecf20b-7ae3-48b0-a5a9-08dd71d20f4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NE54Tk1OZ2pTR25WNVREc1VjMVFkSUR0dG1yYzZrNFZvaU9IUXFwRUhtRGR3?=
 =?utf-8?B?VVBWU29Ic2ZXb0orZFNrWEh6V0VUTWhVR1k1bXVFS3RYWGRiYW9WV0hsYVZV?=
 =?utf-8?B?UytadFZLVzBWdzFYU0ZkZU5DMjhZWUttWUV3M2dmYlVIb0FCQXpkNHZ1Yjlx?=
 =?utf-8?B?UmN5UE9UK2MyeVFCd3kwYjgxaUEvRVhqSTZuNVJyWktZVVA4eHBONUpscXpE?=
 =?utf-8?B?ZUZkVGpjWitTYklteUwwcXR6U1pseGpHRXluK2twRVc0ZTVEU3dzWVN5N1dV?=
 =?utf-8?B?dTY5RkczbXdFcDFOWGRCbzgzekNOMytqUzNXK2FOSmVQRlQzL2RFb1pUS3NZ?=
 =?utf-8?B?Z0lqKzE4VzBiUC9WZmxtS0pJNHh2bTJKNWFwSU91QzA2ZmVsTDRpdGlCTkla?=
 =?utf-8?B?S0dIejZwUG54SE1WWjhHV2c2eTBIZWZiMUFueWRIb2k3QTJMN1RXU1VoUTM5?=
 =?utf-8?B?VEMyVDN6eHU5Zy9tM0J5SkJxVi9XcjVpRzNlS1pxazJJWG5KbzhRTjhWZnlI?=
 =?utf-8?B?cmJsRk53MjFvU3ViY3dwMGk0NUlNOXVoV1N0Q1F2ZG1mTDhudHJkaWFyQTVo?=
 =?utf-8?B?c0xHcTRMQ3FNRHJzckJpd0RsVWVkMkJSVFFac3NBTElibUF2Qi9ZdXVNUGhl?=
 =?utf-8?B?M0c5Tk1QQjY3VTErdVU1ZzNvR2ZGN0NpVTVRY2ljdit5bVBTR2JIR2NZRWk0?=
 =?utf-8?B?cVNGWmRFdm1aeHZQMHUwOFFRVGF3cUhVVUlWcytIZG45Tjh5Q1pIdUpXZzhD?=
 =?utf-8?B?SmhUcFJTVXRsWEVSMGlwRkFyYlVzVElPTG1qU1l0TFhkbHhmWEtyMHJjcVVU?=
 =?utf-8?B?MC8zdkRBRVA0b0dIckpseU5aMit4MVVlSU83QnVMaS9LVW8zcG92N0Q5U0hP?=
 =?utf-8?B?TXJxZXZKZURBNVJ1clB0TGpab0dzbll1aUpJS0tmN2YxWFJHbFRqa3JNcTA3?=
 =?utf-8?B?SFFjcU1veW5yZlA3K2VzenhBNDY2MU02L1Z2WVBCakl1S3hQMkxTdHdPZGUx?=
 =?utf-8?B?TVQ4bWNPSEhNL21NSEIzakx3VkNCWk05eW0wKytqVlJ3bXVjK0s3M3Mzc3dR?=
 =?utf-8?B?MFRlSEhTYVFwajBidlBxa0dHanR1aFRUQ3BxbTV0d253WVRsQXVmU2x3Zk1X?=
 =?utf-8?B?R0c5L1d3ZndnTXhVMWNvVHdjMURlOTB2ckFFYkFobWVNdFlLYWZZK2ZLL0Y0?=
 =?utf-8?B?U3ZaRURSMnRvd01POVoyMWpFQkRqdkl6QTVQQWQrWkRDYU5Ic3BEUjhaaG9r?=
 =?utf-8?B?QlhCZXdmS0VMUUJhRWFKSXlLOXBjN0l3MEJmUEIxVDJSR3Nlb2RIYVFlU3Nm?=
 =?utf-8?B?aW82QzhRN1h2akhPYzBUdk91RTArQjdzVTRPbGJiWER2V01ybzdzNHZYTGZY?=
 =?utf-8?B?dUh3WGZveGlpVVdycFFIOVB5NHd0MThpK1p3MkNZR0pMK1cxaDAvL21XYXpw?=
 =?utf-8?B?SWdNbFpBNVVveE1xZW9DOFY2b1Y2Y1p6RmhoN0NHSFFqemV6ZGc2TnhLV2hR?=
 =?utf-8?B?UDFVUG92czZIa2dNLzhNRXdrV01nbTdkdklTQnIyUUFTQnN3bTcyby9reDJN?=
 =?utf-8?B?NzFLbVhvSnpTZzRGWlFXcmVIZFdaQlNBbHpiVGZxeWswSys1S1oreXQ0YXlC?=
 =?utf-8?B?YTExQjJObk1oaG4xL2NJRENMZnBZenV5YkdvYi9xUVZGY3dER2dPWFBtY0Zx?=
 =?utf-8?B?ZTRyRy9qamRtQzFuNGV3L0dsQ0h4VXFEQ2x5MVpOcnIwWXcrenRueWRTWmJ3?=
 =?utf-8?B?Ym5OcHFrbWE2SGVwbndGM0k4cWR4b3ZweTFNMGxlVkw2b25JbkZsMklJNmtn?=
 =?utf-8?B?QzRqaE0wOUQ0NjkzbGh4T0hkOTV1UjBISkU3Zlp0NmQvTy9RQURXa25vWU5u?=
 =?utf-8?Q?JNPNy55vlBxId?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RlVsN1NOSUN0NHRSdkRBUHNIcUxLT1IySm0xc1g4MnJlSk5PWDJDZmt5QmFo?=
 =?utf-8?B?bmFJYVhESFgrQllJUzlDdkNJTStndTRROTZrUjZaZFpNekNCcHlLVEVISFJ2?=
 =?utf-8?B?d2p0d2Z6Vi9VYlZHTnZmVDA3ZFBuNjVhT3N5UStvSFNKVEwzRUs1NmlhVm4x?=
 =?utf-8?B?RTBaUXJTRERiakhYQ1N2VlRVbG9OTytDR0NnOCtEVWtycjkvajlhb0ZyNWRQ?=
 =?utf-8?B?SU1OdGR3NzE2RTEvSGw5a2ZWMGNYMS93SmZtcXJ2MTVlQjJSNWh4cENlNGs0?=
 =?utf-8?B?U2RNZXZtQXpKRmUxTlNDUDN3RUZIOWNsdUhqL0VzYzRMbGt3aUh2TDl2WE9w?=
 =?utf-8?B?UG1zWGFQZE5jVklUM2lCelNpbzFuKzZCOEYrNGc3RVptWlBIREtLZ2lqQjhV?=
 =?utf-8?B?c1BxMWYxMDE1VzEyaFlvY21tV0JaRGkyZEZ5cEVoYWZhZWM4ek5DR2VkaVBD?=
 =?utf-8?B?V1FJelBadkdhK2JoS1l6R010S0Qxb0pTeklUQTVvZEh2Nk1MTlUrdFl3Wmtx?=
 =?utf-8?B?RUVidGhZMi9BOGhsU1crYTVqUmk1aFdxUlh4VS9SVHhqWnB1RUh6Z3ZJMVgr?=
 =?utf-8?B?V290b2FHM2o5cjJvUDhCL3hlM0x1aFNDQjhKTDZ4cnhvSy9scW8vOGhnUXBj?=
 =?utf-8?B?V0ttVU10ekV0MUpucVlmbWNrSXNKSTNkS0c5NjErYnFWdTMybXhqNTl6M0Fw?=
 =?utf-8?B?alVQdmlESDlNUStremtLeXROZzlGUE9DVUREUm01ajFvQ3MxV0tLOEkzYzZ3?=
 =?utf-8?B?L0U2Q0I3NTNOeVZaeHd5U0RLa0FhSUNwNHlsZ3l0c2w2Z3JlRFhhWkpFeDUy?=
 =?utf-8?B?eEF2NEtjYjZsTGY2b0ppSEI0RUtjZWxzYkRrUkpJb3dTVE90S2FZWWd1Nld3?=
 =?utf-8?B?dC82cTZ6aUtBZWhGV3kzMStMYlJVQ1RoTEZEbFdWbXZrVnU4eGVZcVd2Ylgy?=
 =?utf-8?B?RU50bmJDTVRnVERCTTVoMXQ2ZU5xZ01CN25jNTNzUDdVN3ZzNFl1TDVmYUU3?=
 =?utf-8?B?UGhFV2xUQ3M0VStxRkU2T3BER3NSV21pSmZxclZRYzNTT2xYbzI0Y1IwazV4?=
 =?utf-8?B?RDZFcG1VZ09udHhsRHJ4a1FOQlV4cXlaN0VxWWJoMzhiRCt6UFhoSys4OVc4?=
 =?utf-8?B?WjcyQ0dJby80MkxPbVRRZ2ltOFRwSElxTnVQTTkxVldDZTYxY2JUSnlQWnN5?=
 =?utf-8?B?OXZGWEFhb3hNK211YUxhTzU2bVFPKzJTQ201RXhmRUxUTDBQVmdOYXg4MWZK?=
 =?utf-8?B?YTU0djFlWTRBeTNySE1rUzZ0U1lwYmJvbzdmMWJ0aldTdFgvYUZDbzI3ZWZI?=
 =?utf-8?B?MGtXMk1BR2NKQ2RtSnEzTUJjNk40UWtGaVZTdmF5SWNIN1k0OGV3c2FXU1Ix?=
 =?utf-8?B?aHRVNEdhQUxLUDl4dkNJNzVxbEJ3amgrL2xxeWk2MHFBa1QrM0RhbUl6cG5h?=
 =?utf-8?B?eTE0S1hZR0hmakd1bzRLVDRvMW5IL3djbkxBRUFVKy81R2k5NE8zRkpzU2ZQ?=
 =?utf-8?B?d0NjTHJJMzZsb3pGM2czV1d5dkcrdEJNQzVwem1uQVZQSndjWnVxeUpxaUti?=
 =?utf-8?B?N2VqNFd4d0JFek5iaTB4V1JvbTBHWUpCeFRSSmRwOFpRaEt5a3FqSTRtQ0dL?=
 =?utf-8?B?TGRkNFdHa3dzaUxtaVBqa2ZoMjFDN2ovczN3TWd3amkzbXJ5QS9ISGlqaFVr?=
 =?utf-8?B?UEpWeVBJWnV0SzEwRktYanltdy9ETjV6WGI5UzRiVHdQTHFiTXhTc3dQVUNk?=
 =?utf-8?B?TDdBaW9qN0NDdWpXME1RNitXT2RiSWszNnkrMTVJaXZhNWV1RU1qOHhPb2Z0?=
 =?utf-8?B?Mi9aOENPWE9XcS9XWVptVFc0Rm55a00rZVJCQzRyOHRieURMbUZRRklXYmpX?=
 =?utf-8?B?ZGgyNmFZc2t5MzQyY1pUcWxOTTlJOWV1UnowcURHS2dGOGR4dHRIZkFpaFhr?=
 =?utf-8?B?dzR6ZVpLRFcyTkk5VkxPRnRIeWx4RmpmNTZKQmh1SFJodktRNHpTTU1yeHVO?=
 =?utf-8?B?QVZNTlpud3h1M3VSYWxxclI1c0Y4QTVMaUptOUtYby9MSXhxZVhCNDEybEpn?=
 =?utf-8?B?TGgzempla0NhbjB4NU8zcFBwYmpKc1Zwb0xibUhoOXE2YThFejJVMFErRFdx?=
 =?utf-8?Q?vxnqXPbIVj1KvVSsjeuFDVytN?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cecf20b-7ae3-48b0-a5a9-08dd71d20f4a
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2025 10:35:17.2185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DeBSyhcUXcIPy26orpYTyV5FfdBwIH4yQFdsyzrIGpGBoCyU+BoxSD8AhAYH83SzGbMWgmzKPcS5DyQLqpwHNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR02MB7077

On 2025/4/2 17:56, Mikulas Patocka wrote:
> 
> 
> On Wed, 2 Apr 2025, LongPing Wei wrote:
> 
>> At this time, all bios for hash blocks should eventually
>> be merged into a single large bio.
>>
>> Signed-off-by: LongPing Wei <weilongping@oppo.com>
>> ---
>>   drivers/md/dm-verity-target.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
>> index 3c427f18a04b..813d5cfc7ffa 100644
>> --- a/drivers/md/dm-verity-target.c
>> +++ b/drivers/md/dm-verity-target.c
>> @@ -1683,6 +1683,10 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>>   
>>   	verity_verify_sig_opts_cleanup(&verify_args);
>>   
>> +	dm_bufio_prefetch_with_ioprio(v->bufio, v->hash_start,
>> +		v->hash_blocks - v->hash_start,
>> +		IOPRIO_PRIO_VALUE(IOPRIO_CLASS_RT, 0));
>> +
>>   	dm_audit_log_ctr(DM_MSG_PREFIX, ti, 1);
>>   
>>   	return 0;
>> -- 
>> 2.34.1
> 
> Hi
> 
> I would move it into the "resume" callback, so that if the user
> reconfigures the device stack between "ctr" and "resume", it won't read
> the data too early.
> 
> Don't use IOPRIO_CLASS_RT, this is not real-time requirement,
> IOPRIO_CLASS_RT would slow down concurrent I/O.
> 
If the prefetch io is submitted with non-rt at first, the later dm io
need the same hash block will wait the non-rt bio.
> Another problem with this approach is that when the verity device is big
> and system memory is small, it just causes I/O churn - new bufio blocks
> will be displacing old blocks - and it will degrade performance, not
> improve it.
> 
Do we need a solution to check if the memory is enough to the prefetch?
For Android devices, the verity device should be created on the boot 
procedure.
> Please, describe some scenario, where this prefetch actually helps. What
> is the size of the metadata that you are prefetching? What is the total
> memory size? Is there any benchmark that shows the advantage of this
> patch?
The size of hash blocks for the ROM of our low-end devices is about
71MiB. I want to enhance probability of cache hit when
try_verify_in_tasklet is enabled. How about only doing the prefetch when
try_verify_in_tasklet is enabled?
For example:
	if (v->use_bh_wq)
		dm_bufio_prefetch_with_ioprio(v->bufio, v->hash_start,
			v->hash_blocks - v->hash_start,
			IOPRIO_PRIO_VALUE(IOPRIO_CLASS_RT, 0));

> 
> Mikulas
> 

LongPing
