Received: from SG2PR03CU006.outbound.protection.outlook.com (mail-southeastasiaazon11010000.outbound.protection.outlook.com [52.101.133.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A4054279
	for <dm-devel@lists.linux.dev>; Sat, 11 May 2024 11:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.133.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715425536; cv=fail; b=ddQuVg9Ywgtnf2fj5MqAxGz/gp3w8R8ric8OS9VfbCQNVGwwWD41ptfia8Z+Ke36NziEtDEMZcJw3lGdfNeYym/k9JCVdf2x+CdFs9XdwvPexv2AG6cwyscve1azcQ10HtuRKZUftnnCZ4BNsnNRagq3qzfoh7lMWiDAjE7fyFY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715425536; c=relaxed/simple;
	bh=dPNsYJHG+HeGuvyAXLecpULAt3QCopLAP1Y9i6m51p0=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CiC4O5oAy75Mn3BAr9xjP6kseP7dEMIwxxIRXYADz/f0/8dsu6MgiVNPK5hTlQgvaxrw6+rr5Px4q2Ruhj3LzUH1BBnebDXdpyteCbhJehz7LCOeVzjkTIGVn7A2lYMPBqXMli5VNZFpgg3HdlPnxfD836tUudOH6dpWzRSpzRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=ZDiJvO2F; arc=fail smtp.client-ip=52.101.133.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="ZDiJvO2F"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIgCr0PcWe/+TkGRwlXJW9OnX9j1C/nVusNPGRw4smqZ74t7fWJXxrr3+OUmEsmole3KjmL9DvvKjDRGZkwunvw3TI2JEo0JIrDF15mAQJubkOEZZOZ2XutvYyWqlEXHiJaSl9JE5ogGbU4GBXdxFYsbTQVKOhfxLLsE4ikcGhyjO7z+TNPH2ZL/WZpq6Y3SJ50JMWK5TETbv3hC9GNqqZyV8jhT7dLD7gbyPA3UP8B2/XPeKialt1xX6XYP4WUagEVwvVj8joTKlJ+iYov2p+rDTAydo1Qkz/aqk9MOMuE5DNwkTEor7P7q8QHDI9UB+nKGMOhhiV4sJgMMVmbwGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ia8v3saUsbwltzFYNSxaeKLrEzTvrg2IPH1kdtsm3yA=;
 b=UgNb3i1vgKy4gKHeXjBjNnp8Y1VS7OJHIgWg6CferiB2uM+B07wetRJm84hBOyzfW/Lcla1Zp9v5leWMJ5cYNfDxTQUI5+VC7XWwCFSJ0IqNGoUJ036YmBblEf44jZEiCudUgZ74YUqhJ3tTowvFwiNugrdMqQ+OpzbaT+c20CyjehzEd5pJPrWRYefqY+FuTrYZEk514SxMr01yXl7US1cGlPtN7CRLmonWqrYbtUoaMINDzxjCbL30x9Z0+nyRFUDKCjmOzp+8eEwvlTuT7lOJ0o+N06R/lhs1vXeZAqM9IpwiV24jHLeRSX4jHY7vvUfK7cgVuvVkpIfchxXWzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ia8v3saUsbwltzFYNSxaeKLrEzTvrg2IPH1kdtsm3yA=;
 b=ZDiJvO2Fbfi4Oer2OcWNe+MhFXaEYq2g9RJcYLoYFRjQKSLR4VgI4tlPjHQEZKnSxfyLBWsbfueEn0rYLf0jc0foE1DriE02Y2kpztF/AHR0wrUz+D6YRCTFuJt6OGUOTmJFhoUVDKeGknbv6Pb5cZ8xTuANf0CFBfUO5gYX9KKtsoTg2PRfqTfnfEQFTwIM8FATQ1T28O8r/nRHdT/fja+1L3nEhmgt2v8D4K1Kl9S2RuWwNqWi3x+KujTVsY6ybMDbpqlrvAyx/WPfA+1KTJyaZtZUleFX7pN7CGZfqjKUsOL1m7BjdLjnJ+zOjnJntRdhurxBVKRcvhU4uIZeVA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com (2603:1096:400:42a::11)
 by SEZPR06MB6303.apcprd06.prod.outlook.com (2603:1096:101:129::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Sat, 11 May
 2024 11:05:27 +0000
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::af33:ff9c:cf31:45e9]) by TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::af33:ff9c:cf31:45e9%3]) with mapi id 15.20.7544.052; Sat, 11 May 2024
 11:05:26 +0000
Message-ID: <1caa3057-96e2-41ab-8be1-8e831ecf6afe@vivo.com>
Date: Sat, 11 May 2024 19:05:23 +0800
User-Agent: Mozilla Thunderbird
From: YangYang <yang.yang@vivo.com>
Subject: Re: [RFC PATCH] dm: Avoid sending redundant empty flush bios to the
 same block device
To: Mike Snitzer <snitzer@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240422100540.2213-1-yang.yang@vivo.com>
 <ZjzbuuGKqEJxScRY@redhat.com>
Content-Language: en-US
In-Reply-To: <ZjzbuuGKqEJxScRY@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYXPR01CA0048.jpnprd01.prod.outlook.com
 (2603:1096:403:a::18) To TYSPR06MB6411.apcprd06.prod.outlook.com
 (2603:1096:400:42a::11)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYSPR06MB6411:EE_|SEZPR06MB6303:EE_
X-MS-Office365-Filtering-Correlation-Id: dfef3998-a255-4feb-c3fc-08dc71aa4311
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZXIyUTk4Vml6UlVSbkJwMXA1c1JVSER5VU9KRHQ3eitlUXZDdDU5SkV2bXZj?=
 =?utf-8?B?cnZSaXIveFBCTXdUdDAvMXptbU8zbU4wem5nNFp3Q3hIa2k5S1d2Z0RBQTd5?=
 =?utf-8?B?NVVIUjlqQjNENnV0NUo0dlZGcm41aDFSMk5ka29idWFOUHJDTEJ2STRhL0tx?=
 =?utf-8?B?OWZXdTZPZWFieUkvWllySnc3dTlFdDVSNUpUTVJCYTJleUVhcnNMbFJBTmw4?=
 =?utf-8?B?QklnZ0J1aDBDSS9GOXNCdkNrbWhJTndzam4vY0NBdVdDbVFNT2xTM3YyTFRu?=
 =?utf-8?B?bmVRUWNDRFN1RU9Eak9QQjh5L09WUlVEbGdFdzR3WHRXVGtpaWdqZ1V5WUgy?=
 =?utf-8?B?YXA5Z1BTNCtvNG5vTWNTRlFHSGJiMEEvdnVDdU1FQzYzUE5xQStZSnVmd1Fo?=
 =?utf-8?B?bEg0K1ZONTYraTJEYnlJbUltOWNSakpDTUN6cURPZTFWUTJVWDhENFdNbnZj?=
 =?utf-8?B?WEJDUFVuMGpkdzdBZE9MSkx1c1c1VWsyQWNmSm5WOWtBSE5HVlQ2Nm1jTDFy?=
 =?utf-8?B?ZjU4RDcyQkhndkw5NmZVUHVtSy8xZGpCY09VYkRrNk15Y3dYY1cwSVhINDlX?=
 =?utf-8?B?YUpBQnFocndITnBYSmh0Ky8wNFpsUmQzam5tNnVHV3FOQ3V5SDAzUkloTCtK?=
 =?utf-8?B?WHAzVTRLVHM5UUFNNjhqVkU4VURpNXFMazZzUVMzc2Z4bWczb3FlWUk4N1Rh?=
 =?utf-8?B?VStXMGhSb1loZ0JqRHU0SGVzOUlFejZhdlVmazg2VkVabXNqUDZrRWkxUURr?=
 =?utf-8?B?TXo2Sm5vanZPc3FaQ2pHWFNYNzRRNFFJVzNXZ0UyMEZVdER3L1VkRjQ3YVBx?=
 =?utf-8?B?QTI0N3Buc3BLNC9vb1U2Qlc0S2ZTN0pLNnlNRUhtU3ZNK3hlcVV0RmNJaDJD?=
 =?utf-8?B?RkRhYTIxc1FsYk9YaW1aWXozbzYwNFRMVXRyTllac0U0TTRJbDJFcW4zNzBW?=
 =?utf-8?B?bVgyZm9GeTdIeDEzdEhDTnh2S3V6YVFmT1JIMmt6WXdvSWVNK2NzYk9vL2Z2?=
 =?utf-8?B?WkFCa2NhZ29vZjlhMUQ3Y1pkaDVIc3g0aGlPNk4ybFl6cG9SdGgwVS9KanFs?=
 =?utf-8?B?Q2dqOHI5NERvWVRkNWVlL2VpNjFXaVBTVG5RZkRzSUl4bzA0UmdOREJYZ1B3?=
 =?utf-8?B?NWFsdDNvcE5QNU1wdlFFTy9DN3ByeFBtREpmdkNuaCtpNXJiSnlrQWIwNTFI?=
 =?utf-8?B?bEI0a1k4U21YL3VCaHZKcmdvT1AraWloeGxkMWtNV05XVnBScjQ4TVhtckNv?=
 =?utf-8?B?bDVmd2pWVkYxRkhKaTdkQWZSb1c2c1lRMGxodXl3L01JWGpWa1hUNlBBWWpo?=
 =?utf-8?B?UFBSYzV6RHY1QTkvb2xMbG1FNWwyS2NCUksyK044ZUxBZklPdDc4S1UzN0tT?=
 =?utf-8?B?cVhIOFVpdkp1Z1JIMTM5ZG9hVUVEeldUTkkvQ2VKc2VpWGpPT3M2bmJoYmVZ?=
 =?utf-8?B?alYxSm16LzVUcTBuMFdhNDRJL3RaSUxYVFlHYnJJUVJmRFpTZHFpUFUzb29B?=
 =?utf-8?B?bFdyOUlzZ21sUzlrNjdycE94YzRKUUJ2T0VhOHpaQTMzQk4vTCtpVjZHdTBn?=
 =?utf-8?B?ZzdnamhLQVZpZUtDZU92STF4c2RjYW9qRHNDNEdISmlFcXVzODNCNytGVm5Z?=
 =?utf-8?B?a3pZWlE5dzQ2S1J0UGdNVUhOaE5FQmcxU3VaQTZJRHZjT3N0U0NkMFdMZU1y?=
 =?utf-8?B?aVMvZXNBVVNFOUFybll5b1hMcjJrSVl4TkFnUWJJcFE0Rm9COGZtS0l3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6411.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NmdXQlYxcWV1VEQ0WWtXcUVremowZThGbnZmNFlQZGV5WnRnWUVhckZSQzRR?=
 =?utf-8?B?OENqQk5wTTNuRlBaejRNdUo1MmQ2VFRmbm5lRkhEWjFWYUtGZXdHODFGYk5N?=
 =?utf-8?B?ZFhjdkZlampqK21acEt0VWd3NldkQUFQeW4vTENseGIyS1BjYnZmci82TXVt?=
 =?utf-8?B?YVFWdkVIOUNNeXVjMDloWGRNTDBsY3FvcGNpRWJwK2IxeFhCc3FKanNhZElQ?=
 =?utf-8?B?alo1UlQ0QjM1SXNOb2NPOGFzb20zVVVHVFNJeU9HQ0lJc2JiZmxaSjJRQ2lx?=
 =?utf-8?B?clY3TkJaK2JxZlNuZjQwWFB1eW1ESTFkb3hxYVNDN25SZ21uRkRlVStxdWdv?=
 =?utf-8?B?VFY1aXBXQ2ZzNW9PdWZ4aUtORmNVVlE3WlhlQ043SjRzOGZOL0VSOElTNllT?=
 =?utf-8?B?Mll1eUtiZWF2VzdhOGhjWU5XSnFMT3pxZDhEci9jN0NtZGJYUEFZZ3V0ajYv?=
 =?utf-8?B?MVBicklXSXB6Q01iT2Q2VE05SHJIRW1KM1c0elJ0YlBnamFkbnVJTWtZQnE0?=
 =?utf-8?B?TVpZZVFPb2RiUEk3bmg3dXVUdGMwM0EvM0I1TGU1UFE1Y29mZStOVzhxQk9u?=
 =?utf-8?B?cVJZVWRoT3NIcDFLTjc2dHQ1NUlzNmNCWHJQaGVOb0lCc3I4RnREK3lSQlRT?=
 =?utf-8?B?UG5HMGxhalBpVk9CV0Zsc2cvNFdLbXhBa0daL3FDeDF0TVpPZVIvTWh0VTFL?=
 =?utf-8?B?c0ZnenBnT3ZOU1c3UmRtRU4rd01pb0tyNzlwRlM0djA3Q2pnL0tHR1ZQVGhm?=
 =?utf-8?B?ZnRTNDlneWovUzhmZWgzVWJ5VHRQUXhVSHp0ZW5kTVZkNnVNRzVQeHpnKzRP?=
 =?utf-8?B?M0NYZHZqTEJqOU1jbEZZWmtZMTkyU0tWVEhtd2N3RElaakxUSVlKRXVtNWhD?=
 =?utf-8?B?K1JkVThMNml5U3VhS1BvbURMYlRLaEljeGdtUFA1MkhQRW13ZjFiV0NGNjlx?=
 =?utf-8?B?RTRtMkpsWEtOS1FWd21HVUpMbW1kZnlPVjQyQVhSR1hpM0dEMzAvd3RWZ1Zt?=
 =?utf-8?B?S2puaDBzS0hqVExQbklaWjlPNVFCODVPdlNFcHlsS01OYTNNUVA4MUJVQXZH?=
 =?utf-8?B?WEI4bnp4MUNNNEc3cmJ1bEtwbGJsbTRScjRQblZEV2I4OGVQTlZ3ZCtBbCtO?=
 =?utf-8?B?QmFqWldNdEdYSm5TL3FaNnpTWVIrSVNxZU1NeC9zakp5MXhsQjF5ZzBaZjQ0?=
 =?utf-8?B?NnJHbFVZZ0VNSkVHSXRJaFZCT3EzanFLU2d3Ym1CKy8vRWUydVUxUDlQMkNl?=
 =?utf-8?B?czJrcGlEUDc3ZUM1UzMwSi9LaDlibzUvOVJSWk9peXQ0VDFIeGt6K3ZrOEVG?=
 =?utf-8?B?c2Y3SlJHV3pqQytCdUtIbi9ad1BPeFBpWXFMTXFTdDJKOHNaVW54d3FodFZl?=
 =?utf-8?B?NDZSL0RzdjZuMXpBWTUwdHNXSlhuYjY2Q2ZPUzZaaUxJM20rTUoxYW9Tamlz?=
 =?utf-8?B?UkJDd01aUjl1S0Y2RUlzeE5Gb29wRFNuVEUyTWk5bExRVllFODRRWmVDZTN1?=
 =?utf-8?B?cUxMTzVIUmVIL0NYak1lekR4b3hqOVNOOGhvRHRXSmRGNnJ3bi8zbnRodWw2?=
 =?utf-8?B?Y3BKenZ2V2tXOUNyeWtpWjdRVTJNSXp0VFVrMVFWRi9HWEthUUZMWXh5UHlo?=
 =?utf-8?B?cGZxWXVjTlNDNlNsYmRpUVhZa0VpR3l3Q1hxSkhOcHV2SkpTd2ErYm5WWlRp?=
 =?utf-8?B?MURMWHQ5aVc5SCtkZHQ4T042KzFxZ2tHVXFDSzNFWXB6cDJrR2J6L0M2b0tC?=
 =?utf-8?B?N0EwQWl1WmxLMlNNMmZzZzN1bkNwdStQdHQ0andVNEdZa3N0QVUwcy8xckRQ?=
 =?utf-8?B?V1NBc0RJUU1BOXdNb1UrY3ZWbHA2M2NsODlxbWpxR2ZNaG4rV3NDRHFaczR0?=
 =?utf-8?B?cnZ4K014U3VYSTlnSHMwQnpCOXBIa2ZpcjJKbVRkSG15aFZUT2VUMFVKczNt?=
 =?utf-8?B?eDlOVkk4ekkwdEJ6ODJKdTl3bDB0QTZFaU9SWEtHVzBZOVNxQ25xbUpnSUli?=
 =?utf-8?B?R3lUeVF0VVRVN2F3TmZOS2d5bEFINVk1S3pnSXlJRGQ5VFFYMnUvYnpvajY3?=
 =?utf-8?B?TTZoWUFXYzlzYjNyQ1dBNWZSN0lkSFRCNUoyWjFBZjhuaWJnb1p0TjY4MEV1?=
 =?utf-8?Q?NQ+QfVu7QVdq5DZ9wEJwRe1eP?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfef3998-a255-4feb-c3fc-08dc71aa4311
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6411.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2024 11:05:26.4598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RpdH+GulCYhaCjOKMGndJigcZMatJ9a3JF8sAjj132PRO7b3egSEOgQQZwMSWKrzqUxsXUXkaKyvU2xzIdMWPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB6303

On 2024/5/9 22:20, Mike Snitzer wrote:
> On Mon, Apr 22, 2024 at 06:05:40PM +0800, Yang Yang wrote:
>> __send_empty_flush() sends empty flush bios to every target in the
>> dm_table. However, if the num_targets exceeds the number of block
>> devices in the dm_table's device list, it could lead to multiple
>> invocations of __send_duplicate_bios() for the same block device.
>> Typically, a single thread sending numerous empty flush bios to one
>> block device is redundant, as these bios are likely to be merged by the
>> flush state machine. In scenarios where num_targets significantly
>> outweighs the number of block devices, such behavior may result in a
>> noteworthy decrease in performance.
>>
>> This issue can be reproduced using this command line:
>>    for i in {0..1023}; do
>>      echo $((8000*$i)) 8000 linear /dev/sda2 $((16384*$i))
>>    done | dmsetup create example
> 
> Only _one_ dm_dev will be created for this example: /dev/sda2
> So your bitmap is looking at a single bit.

Yes. And this patch has also been tested on a scenario with multiple
dm_devs using the following command line:
   for i in {0..1023}; do
     if [[ $i -gt 511 ]]; then
       echo $((8000*$i)) 8000 linear /dev/sda3 $((16384*$i))
     else
       echo $((8000*$i)) 8000 linear /dev/sda2 $((16384*$i))
     fi
   done | sudo dmsetup create example

>> With this fix, a random write with fsync workload executed with the
>> following fio command:
>>
>>    fio --group_reporting --name=benchmark --filename=/dev/mapper/example \
>>        --ioengine=sync --invalidate=1 --numjobs=16 --rw=randwrite \
>>        --blocksize=4k --size=2G --time_based --runtime=30 --fdatasync=1
>>
>> results in an increase from 857 KB/s to 30.8 MB/s of the write
>> throughput (3580% increase).
>>
>> Signed-off-by: Yang Yang <yang.yang@vivo.com>
> 
> I'm including my original fine-grained review comments inlined below
> BUT, having wasted time reviewing this patch I'm left with the
> conclusions:
> 
> 1) this patch has serious issues.
> 2) it fixes an issue with a toy 'example' but ignores that not all
>     targets are linear, each disparate target could have their own
>     reason(s) for actually _needing_ the redundant flushes.

I chose this specific 'example' because the constructed scenario closely
resembles real-world use cases.
This is a real-life scenario that we have encountered:
1) Call fallocate(file_fd, 0, 0, SZ_8G)
2) Call ioctl(file_fd, FS_IOC_FIEMAP, fiemap). In situations of severe
file system fragmentation, fiemap->fm_mapped_extents may exceed 1000.
3) Create a dm-linear device based on fiemap->fm_extents
4) Create a snapshot-cow device based on the dm-linear device

I guess targets needing the redundant flushes you mentioned are targets
with ti->num_flush_bios > 1. I think they won't be affected, duplicate
flush bios are still send to dm_dev by __send_duplicate_bios().
The main purpose of this patch is to ensure that __send_duplicate_bios()
is called only once for each dm_dev.

Anyway, I will modify this patch to apply only to dm-linear and dm-stripe.

> I'm inclined to never take this type of change.
> 
>> ---
>>   drivers/md/dm-core.h          |  1 +
>>   drivers/md/dm-table.c         |  7 +++++
>>   drivers/md/dm.c               | 59 +++++++++++++++++++++++++++++++++++
>>   include/linux/device-mapper.h |  6 ++++
>>   4 files changed, 73 insertions(+)
>>
>> diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
>> index e6757a30dcca..7e3f2168289f 100644
>> --- a/drivers/md/dm-core.h
>> +++ b/drivers/md/dm-core.h
>> @@ -217,6 +217,7 @@ struct dm_table {
>>   	/* a list of devices used by this table */
>>   	struct list_head devices;
>>   	struct rw_semaphore devices_lock;
>> +	unsigned short num_devices;
>>   
>>   	/* events get handed up using this callback */
>>   	void (*event_fn)(void *data);
>> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
>> index 41f1d731ae5a..ddc60e498afb 100644
>> --- a/drivers/md/dm-table.c
>> +++ b/drivers/md/dm-table.c
>> @@ -2133,6 +2133,8 @@ void dm_table_postsuspend_targets(struct dm_table *t)
>>   
>>   int dm_table_resume_targets(struct dm_table *t)
>>   {
>> +	struct list_head *devices = dm_table_get_devices(t);
>> +	struct dm_dev_internal *dd;
>>   	unsigned int i;
>>   	int r = 0;
>>   
>> @@ -2159,6 +2161,11 @@ int dm_table_resume_targets(struct dm_table *t)
>>   			ti->type->resume(ti);
>>   	}
>>   
>> +	t->num_devices = 0;
>> +
>> +	list_for_each_entry(dd, devices, list)
>> +		dd->dm_dev->index = ++(t->num_devices);
>> +
>>   	return 0;
>>   }
>>   
>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>> index 56aa2a8b9d71..7297235291f6 100644
>> --- a/drivers/md/dm.c
>> +++ b/drivers/md/dm.c
>> @@ -48,6 +48,8 @@
>>    */
>>   #define REQ_DM_POLL_LIST	REQ_DRV
>>   
>> +#define DM_MAX_TABLE_DEVICES	1024
>> +
> 
> This name is too general. This limit isn't imposed for anything other
> than bounding the size of the bitmap used to avoid redundant flushes.
> 
> So maybe rename to: DM_MAX_REDUNDANT_FLUSH_BITMAP_DEVICES

Got it!

>>   static const char *_name = DM_NAME;
>>   
>>   static unsigned int major;
>> @@ -1543,10 +1545,38 @@ static unsigned int __send_duplicate_bios(struct clone_info *ci, struct dm_targe
>>   	return ret;
>>   }
>>   
>> +static inline bool has_redundant_flush(struct dm_table *t,
>> +		unsigned long **bitmap)
>> +{
>> +	if (t->num_devices < t->num_targets) {
>> +		/* Add a limit here to prevent excessive memory usage for bitmaps */
>> +		if (t->num_devices >= DM_MAX_TABLE_DEVICES)
>> +			return false;
> 
> OK, in practice I'm not aware of tables that require such an excessive
> amount of devices.

Noted!

>> +		/* dm_dev's index starts from 1, so need plus 1 here */
>> +		*bitmap = bitmap_zalloc(t->num_devices + 1, GFP_KERNEL);
>> +		if (*bitmap)
>> +			return true;
>> +	}
> 
> This method is being used in the IO path, so you cannot use
> GFP_KERNEL.  Please switch to GFP_NOIO.

Got it!

>> +
>> +	return false;
>> +}
>> +
>> +static int dm_get_dev_index(struct dm_target *ti, struct dm_dev *dev,
>> +				     sector_t start, sector_t len, void *data)
>> +{
>> +	unsigned short *index = data;
>> +	*index = dev->index;
>> +	return 0;
>> +}
>> +
>>   static void __send_empty_flush(struct clone_info *ci)
>>   {
>>   	struct dm_table *t = ci->map;
>>   	struct bio flush_bio;
>> +	unsigned long *handled_map;
> 
> Please rename, e.g.: handled_devices_bitmap

Got it!

>> +	unsigned int nr_handled = 0;
>> +	bool check = has_redundant_flush(t, &handled_map);
>>   
>>   	/*
>>   	 * Use an on-stack bio for this, it's safe since we don't
>> @@ -1562,17 +1592,46 @@ static void __send_empty_flush(struct clone_info *ci)
>>   
>>   	for (unsigned int i = 0; i < t->num_targets; i++) {
>>   		unsigned int bios;
>> +		unsigned short index = 0;
>>   		struct dm_target *ti = dm_table_get_target(t, i);
>>   
>>   		if (unlikely(ti->num_flush_bios == 0))
>>   			continue;
>>   
>> +		/*
>> +		 * If the num_targets is greater than the number of block devices
>> +		 * in the dm_table's devices list, __send_empty_flush() might
>> +		 * invoke __send_duplicate_bios() multiple times for the same
>> +		 * block device. This could lead to a substantial decrease in
>> +		 * performance when num_targets significantly exceeds the number
>> +		 * of block devices.
>> +		 * Ensure that __send_duplicate_bios() is only called once for
>> +		 * each block device.
>> +		 */
>> +		if (check) {
>> +			if (nr_handled == t->num_devices)
>> +				break;
>> +
>> +			if (ti->type->iterate_devices)
>> +				ti->type->iterate_devices(ti, dm_get_dev_index, &index);
> 
> You're looping through all data devices in a target, so you're only
> getting the last device in the target's index.  That seems very
> broken.
> 
> But each target in your test 'example' device (mentioned in the patch
> header) only has a single device so you wouldn't have noticed this.

Perhaps the code comments are not sufficiently detailed, so allow me to
provide a detailed explanation of the execution flow of this code.

For device table only has a single device:
example: 0 8000 linear 8:2 0            -> dm_dev(8:2).index = 1
example: 8000 8000 linear 8:2 16384     -> dm_dev(8:2).index = 1
example: 16000 8000 linear 8:2 32768    -> dm_dev(8:2).index = 1
example: 24000 8000 linear 8:2 49152    -> dm_dev(8:2).index = 1
example: 32000 8000 linear 8:2 65536    -> dm_dev(8:2).index = 1
example: 40000 8000 linear 8:2 81920    -> dm_dev(8:2).index = 1
example: 48000 8000 linear 8:2 98304    -> dm_dev(8:2).index = 1
example: 56000 8000 linear 8:2 114688   -> dm_dev(8:2).index = 1
example: 64000 8000 linear 8:2 131072   -> dm_dev(8:2).index = 1

Before enter the loop:
     nr_handled = 0
     t->num_devices = 1

When i equals to 0:
for (unsigned int i = 0; i < t->num_targets; i++) {
     if (nr_handled == t->num_devices) //nr_handled=0, t->num_devices=1
         break;

     if (ti->type->iterate_devices)
         ti->type->iterate_devices(ti, dm_get_dev_index, &index) //index is set to 1

     if (index > 0) {
         if (__test_and_set_bit(index, handled_map)) //__test_and_set_bit() return 0
             continue;
         else
             nr_handled++;    //nr_handled = 1
     }

     bios = __send_duplicate_bios(ci, ti, ti->num_flush_bios,
                      NULL, GFP_NOWAIT);  //__send_duplicate_bios() is called
}

When i equals to 1:
for (unsigned int i = 0; i < t->num_targets; i++) {
     if (nr_handled == t->num_devices) //nr_handled=1, t->num_devices=1, break the loop
         break;
}

__send_duplicate_bios() is called for device (8:2) only once.

======================================================================

For device table has two devices:
example: 0 8000 linear 8:2 0            -> dm_dev(8:2).index = 1
example: 8000 8000 linear 8:2 16384     -> dm_dev(8:2).index = 1
example: 16000 8000 linear 8:2 32768    -> dm_dev(8:2).index = 1
example: 24000 8000 linear 8:2 49152    -> dm_dev(8:2).index = 1
example: 32000 8000 linear 8:2 65536    -> dm_dev(8:2).index = 1
example: 40000 8000 linear 8:3 81920    -> dm_dev(8:3).index = 2
example: 48000 8000 linear 8:3 98304    -> dm_dev(8:3).index = 2
example: 56000 8000 linear 8:3 114688   -> dm_dev(8:3).index = 2
example: 64000 8000 linear 8:3 131072   -> dm_dev(8:3).index = 2

Before enter the loop:
     nr_handled = 0
     t->num_devices = 2

When i equals to 0:
for (unsigned int i = 0; i < t->num_targets; i++) {
     if (nr_handled == t->num_devices) //nr_handled=0, t->num_devices=2
         break;

     if (ti->type->iterate_devices)
         ti->type->iterate_devices(ti, dm_get_dev_index, &index) //index is set to 1

     if (index > 0) {
         if (__test_and_set_bit(index, handled_map)) //__test_and_set_bit() return 0
             continue;
         else
             nr_handled++;    //nr_handled = 1
     }

     bios = __send_duplicate_bios(ci, ti, ti->num_flush_bios,
                      NULL, GFP_NOWAIT);    //__send_duplicate_bios() is called
}

When i equals to 1, 2, 3, or 4:
for (unsigned int i = 0; i < t->num_targets; i++) {
     if (nr_handled == t->num_devices) //nr_handled=1, t->num_devices=2
         break;

     if (ti->type->iterate_devices)
         ti->type->iterate_devices(ti, dm_get_dev_index, &index) //index is set to 1

     if (index > 0) {
         if (__test_and_set_bit(index, handled_map)) //__test_and_set_bit() return 1
             continue;
         else
             nr_handled++;
     }
}

When i equals to 5:
for (unsigned int i = 0; i < t->num_targets; i++) {
     if (nr_handled == t->num_devices) //nr_handled=1, t->num_devices=2
         break;

     if (ti->type->iterate_devices)
         ti->type->iterate_devices(ti, dm_get_dev_index, &index) //index is set to 2

     if (index > 0) {
         if (__test_and_set_bit(index, handled_map)) //__test_and_set_bit() return 0
             continue;
         else
             nr_handled++;    //nr_handled = 2
     }

     bios = __send_duplicate_bios(ci, ti, ti->num_flush_bios,
                      NULL, GFP_NOWAIT); //__send_duplicate_bios() is called for the second time
}

When i equals to 6:
for (unsigned int i = 0; i < t->num_targets; i++) {
     if (nr_handled == t->num_devices) //nr_handled=2, t->num_devices=2, break the loop
         break;
}

__send_duplicate_bios() is called only once for each of devices (8:2) and (8:3).

>> +
>> +			if (index > 0) {
>> +				if (__test_and_set_bit(index, handled_map))
>> +					continue;
>> +				else
>> +					nr_handled++;
> 
> Think you really mean to set bits in the bitmap within the
> iterate_devices callout.  So it should be renamed accordingly.
> 
> Why not count the first time a device is handled in nr_handled?
> Also, it strikes me as strange that you're break'ing out this loop
> early based on nr_handled... not seeing the point (and also it seems
> broken, because it implies you aren't issuing flushes to targets at
> the end).
> 
>> +			}
>> +		}
>> +
>>   		atomic_add(ti->num_flush_bios, &ci->io->io_count);
>>   		bios = __send_duplicate_bios(ci, ti, ti->num_flush_bios,
>>   					     NULL, GFP_NOWAIT);
>>   		atomic_sub(ti->num_flush_bios - bios, &ci->io->io_count);
>>   	}
>>   
>> +	if (check)
>> +		bitmap_free(handled_map);
>> +
>>   	/*
>>   	 * alloc_io() takes one extra reference for submission, so the
>>   	 * reference won't reach 0 without the following subtraction
>> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
>> index 82b2195efaca..4a54b4f0a609 100644
>> --- a/include/linux/device-mapper.h
>> +++ b/include/linux/device-mapper.h
>> @@ -169,6 +169,12 @@ struct dm_dev {
>>   	struct dax_device *dax_dev;
>>   	blk_mode_t mode;
>>   	char name[16];
>> +
>> +	/*
>> +	 * sequential number for each dm_dev in dm_table's devices list,
>> +	 * start from 1
>> +	 */
>> +	unsigned short index;
> 
> Please update this comment to indicate that index=0 is (ab)used as a
> flag in __send_empty_flush().

Noted!

Thanks for your comments.
