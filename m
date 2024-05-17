Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2056.outbound.protection.outlook.com [40.107.255.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8137E10A23
	for <dm-devel@lists.linux.dev>; Fri, 17 May 2024 08:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.255.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715936164; cv=fail; b=cYDy2djBjeV71NPsq7EdrvRk7rAV+18tMM4iGAOLIB7dcOp8lHiKhwoktrsWTl+UkLHqEv8EU6wP/wTb0yMzUW2Th77RmMQUUdCkOhwCgsX9r6toREygL7J5aAaDqINUXjIKkPsiDAoaKpAyj2DPFx+j3VzHheAmgmzUsUP78N0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715936164; c=relaxed/simple;
	bh=ZSmsmExMIV3BPtG8+G1d6pRZ/b2ouH0rKVPpia2B6o0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BxRmT86j5UzYDEWTi1ObPxKP8Y340Arb68d6mbt6yr7KqgcKrPvn7kxjs3hngnpXtf1nsGA1TxTNzvYgLsLwQPJBzCBAodWNtfSSFaYJM3xOlF3/1jR7FmvBGFDcdTosyCxnSTsZoamyOSO7Nm0eeF9+o7ACCuwS/aBvOQAuego=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=T/K3cUJN; arc=fail smtp.client-ip=40.107.255.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="T/K3cUJN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h3O6b3DJOnV6lqCJePybZm8jhsYNRUZNGiibP6deNDhF1vIfupP4H6JAbTf91BboNT5c7ifdBoS+KlxbiB27uRehubIf3ppg0RXudSvRl/G694lIaI8GiZpS2DqDpUYSRdyKiIeXUuMPg93jxnFGoDs1i5fpUCjPAU45pv+TcWBP4cjK4IP5H3knt4vee/ggDGMcC7yHsYI2UBxqQUBr0MPjikQ8RicsK4ZRdWSYebV6KQEL1vN/ODO0F2Afiw/Ge26RFXs2dGGp2ky+VLqRPGWYll0+0hLcO6boKhv8d+IGBg8WXszAQOTDu0S7pa0ecygkoDYwcrkzplvfHWXbSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tEgLbXj89fXnxcQ5F4AHW/ghe8p3w/edsB60JjpnhZ0=;
 b=h5wYb7oesP2pnZe6LSS0Y02a4yHTN/fhp78MUFzYvGHacFMywwrvssakB8rh8X4gvvhezgV981VCodsTbF7eqTs0qruIXnB814ixjcPgCJ7r15NxwUZgLQ1SHumhXsfzqGkXsdkoaNtEp1LQxViL1kPuv44SgqZgJE64bu38DjmxTPfCr3k8HFYXSfgeTkwybRHgc2RD1RHRbdfIlY3uVkG5OZ+ltI3msyhcF/+Lw5yUDHex3B3xN4tbmb3ruz03SFtL/UDnKrvsVEfNbzSv3+lLIADUizAlFhF2MWKEgQBFPcA14FX1527dZVkN6ZgMSds4ASz66kXC1KlnYj6bGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEgLbXj89fXnxcQ5F4AHW/ghe8p3w/edsB60JjpnhZ0=;
 b=T/K3cUJNAnhpbNj9pZFBzjqIUiGm1hYYlTfqHpZcdbaQQiXXQPF8RG18X8VL22cPCSI/tg7w5Xb02M1HOlFX5uUMiX1jWQu33P5Ibp3aPxIrqfeYHJaf8IyvU8LEW/Nz8Ay4ziqwUagr9XS3Ut6AjIfa7PYMD7LsRZIIBrJh2oOxYPSVwT69xz+uLSUPnHReRUA3vQ6sYxPkOUFAclAC78cXo+7a3Og7b3c2Z3V1gZg83LANMOcfN9Ln61gU4TiSnbteeng4VA06s15mlJEk+Bi/4RH1QeQ9lF/YOh4i5OpGoHJj6z9liT3TVEka5AyIJkPpAEP79o/01CXayy8H8g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com (2603:1096:400:42a::11)
 by TYZPR06MB7141.apcprd06.prod.outlook.com (2603:1096:405:b7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Fri, 17 May
 2024 08:55:58 +0000
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee]) by TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee%3]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 08:55:58 +0000
Message-ID: <753c5305-6104-44e1-b402-a5ed6ea03d82@vivo.com>
Date: Fri, 17 May 2024 16:55:55 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: optimize flushes
Content-Language: en-US
To: Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240514090445.2847-1-yang.yang@vivo.com>
 <20240514090445.2847-4-yang.yang@vivo.com> <ZkTXzG1yrPmW64Z6@redhat.com>
 <60bd4b9-8edd-7e22-ce8b-e5d0e43da195@redhat.com>
 <90f4beb-2e15-3f9-4bc2-0d13872e8ea@redhat.com>
From: YangYang <yang.yang@vivo.com>
In-Reply-To: <90f4beb-2e15-3f9-4bc2-0d13872e8ea@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCP286CA0321.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3b7::14) To TYSPR06MB6411.apcprd06.prod.outlook.com
 (2603:1096:400:42a::11)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYSPR06MB6411:EE_|TYZPR06MB7141:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c7a6461-7f70-43f0-5d67-08dc764f2b74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MXh2OW5GWXFKRnFTWjJ3eVYvV2d5US8vUEZCSkxMSmd1UWc4dkV5akxWNHJT?=
 =?utf-8?B?b3dTNGloSUdTakJBQTR0NEs1eWljMVFuS3p2cHdLUXpjb1JUWkRUMCtvcUwr?=
 =?utf-8?B?TXFzUUhjY1VlYzVQYm5yTFlTT1BxeUc4cHlGTjNUNGJKT1NwQWQ0SVlqVS9q?=
 =?utf-8?B?TVM5dGhGeHJYaW53ZlRJSlFJVk10MUFPQzNOZXNVaXl5VTFUL1l3YW5mUmRB?=
 =?utf-8?B?L3N0UG1sT29nQitxTEx1YWpCbVZHOEs3YVI5VzVwQ0pVZnc0OGVTdjU1ckc1?=
 =?utf-8?B?ZW5vazNyZkhnenlVRGNrZjhsYkR1QTF1VlpDaG9GRUdaL1hmSjRtSmk3N1V3?=
 =?utf-8?B?ZHBvQ0hVOTZhVE1qYmxiSGN2Y2pkQ2VzUUdobWxQTFBxUHdib21SVktXeUQr?=
 =?utf-8?B?Kzg1ZGxlZFpHUCtqNnhVYlZYdzBFV2NETlExc1UwRUdIYUk0TUxNTXBXODVU?=
 =?utf-8?B?cDdMVngrWWtRWkxGNDkyM0Rzbmd2dGlzRXNUV1M2cTdvMUlGU3BTZFBCZ21O?=
 =?utf-8?B?U21SUmRjTnd1dHhCM2dmK2trajllRFN5bDdkM3JBOW1XeERPWkphTndBSjE5?=
 =?utf-8?B?TURPWHdEQUMzQjNyeERoRXVYdTlSdjdWZmlYcElnb0kvRm5XdEZycjU5dlFX?=
 =?utf-8?B?TEhFMzRoUER1WGZZSi81SHp1dVdRUnZxMDdwZ21tb0NDVE5WWlNwY1NvdElV?=
 =?utf-8?B?RVFaQitucUxUTk5Sd3VocHBtNGwyN1VJOWk4MTFaRXlJTEpVSDdrR3N5Rk5B?=
 =?utf-8?B?K2g4ZVpDSEdKVUJva3NjTXR6VzNKVFpIeFhseG9LckdPcWpJdXZpQ3ZRL29Q?=
 =?utf-8?B?OGt5N3pnSDhuRUdWUHRhSzYrT2NIYmF6Q0xPMDQwc3UxaDN4azVqQ2lXZUI4?=
 =?utf-8?B?b25oSyswTTNIRmRSY0dBU1h5MnhJUWhndmZqVnNsWG9STUhLYW9UaTlLTWRG?=
 =?utf-8?B?aGpFSWhKa3NpeDZ5ZlZiaUo1K3RteUVWS25RNmxtR2pjRmFvZFFQLzJEcW1r?=
 =?utf-8?B?Z2E2Wnpzc0RhZmNwWmR1ejVxRDRmeEhrWEFnbThXWUgzSXN0bWY4VmJsUFBW?=
 =?utf-8?B?WXIzTkZzcUY3djNkVm91ODJuc1pNWE95RUIzWHVvL2ZlbTV6bUxqeHo0MEpN?=
 =?utf-8?B?QjNyc0t1Q1NjNWE0M3YzaVpVL0R0dGdLc0pvNFloT3pqamt2MUFHOEFjUW80?=
 =?utf-8?B?Z1EvNW5mb0JHSkFDVzFMeGoxM2t6Z01YRkVzZTBPWm12VVlFMzVJZHhsaFRT?=
 =?utf-8?B?bVRPOWJyWVBnd0dwdkZUTkZNU29KWWhhejVDYkMwR1hWRmpRQUxMbXRsYzZq?=
 =?utf-8?B?UXFKVUQ4M3hQMklVZTNFTEd4OHRVUklDK1V4VGR4Vlk2SjBsWDZXajlVSE91?=
 =?utf-8?B?eXlYOFZsMGZMYms5K016OFlaR1VSTVlGT2hQQ29ZL3B6VWdaSmFqQnB0d1pr?=
 =?utf-8?B?K2VqMFZMaEFQRGdMblRtWVM5QUgxMlBNNzkrT2xyS1ZxbzhGNTRnR1EvOWVL?=
 =?utf-8?B?aWJHcm5nKzdZaENkQmFwWFNMMjE5YjZBMFJHOU44TGE4aFk3ZXdwM3JRR0cv?=
 =?utf-8?B?TExPSHNJTlQzYUVvOGRuTXo3ZXNBK2pDTlpodHBiWUxYb0ZyZHJwNXBVVWtL?=
 =?utf-8?Q?dI+30atXYt4BfDoaS1wGSikcAhMqP2FPC8URK+sSLvpk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6411.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QlphMFdTcnVwc3V5ejZnMXJMYzVIaTF2VnBtbGtnQm9IUXE0TG93c0NXTTVK?=
 =?utf-8?B?aHVtbEx3enNoaWhVbWoxRHJHRkR0VEhiZTNJNXlWM0E0bFpGaGJUeU4vYjFO?=
 =?utf-8?B?VHNFL3duUUNXQlNOUUQyT21Ra200TjVQZVhDaUV4dTBXZnlJeVRhblgwV0tY?=
 =?utf-8?B?bnB6eUNRTEh1NXdPQlkvc0NTVzBMbmNVcm0rUUdMaXZpTkozRkxwMFUwU0lq?=
 =?utf-8?B?WHgzMUVZS1VUd01HZTF0c0JhRW85SHcwWGZZY1JqMHNLcEhSbWprNUZTSWgv?=
 =?utf-8?B?NkFQdUFlMWVpY3FtRHpVenN1NDhCZ2RMcjN0a3lTamlsd01RUHFXbWZHY0xo?=
 =?utf-8?B?Q0c0WktrcTlxdkRmckgxWm9WNW1wZkxVcEVhU1hHOUdROC9sa2d6bmhVTVRX?=
 =?utf-8?B?UjQ4Zy82TVg4dll6cEJuUGMwUkJiR1NyWDE1Ym4yZGxDUjlFTy9VVTNiREE4?=
 =?utf-8?B?enF0T29GZmUzc2x6RGVRMlpTWW96czlHODZDMU15SHRSVlVjbjlSOTNrQmVm?=
 =?utf-8?B?M0pHRzZRdUVtRTVGZm52dUY5eFRqNmV5RXFpZkhnaTBMNXlCemlvWk52WkRG?=
 =?utf-8?B?azFZUFprdXMrdDhBc3JKcTFabk1GL1daVmdzV1M4SVZlaVZxWGNlamZGMmh0?=
 =?utf-8?B?RktXbldKWGdJQndKVDE1VWdITlhqWlQ4Sm5iQ2F4VWhCUnFGeGRsVnlOSWUv?=
 =?utf-8?B?ZDlLaFdubEFxc1RmR3J1dWEzSVAyRUdJaFJEOURTa2F6cGlMQlRhTHo5SStP?=
 =?utf-8?B?VExxaDF3M3hjZXY4Uk5VeDgrNSs1eldBbk5BT0krQmNTR3NDMXF6dWlRckRh?=
 =?utf-8?B?a0Rxb2dZNTcvbEdONVRDU3I4NjZTNHRkVlYzRmROaUFXQk1FVHZ2K3FTVzJY?=
 =?utf-8?B?QkVNZlJTd3J2OXRZRnhvOHhhTEZSZmhFMlNGdktCallqcTJJeXpnblJzL1U5?=
 =?utf-8?B?UnRQemprcjg5RXkxVExXUE1DdTZ4RHZNVVd5eWdSWEpTZkw2NWxPa1ZwdFA0?=
 =?utf-8?B?bW5VWGZ5Y0lIWkVDdVJYVy9DMDlmZFBYekJCb2RkWnppZ3JQazljU25mR2JF?=
 =?utf-8?B?UWszY21xMGVCemk2UExoT2w5bnhOR1E5ZGxJSEQ2b0g4cUV5QVVZL1hBN1A5?=
 =?utf-8?B?VGtxdFRQdGZyY0pWMmVoYy96RUFieVNpUk1RUVErR0ZVNGNFYVVVeVE5MDNx?=
 =?utf-8?B?RmpSZGZZalR1UFVNYndmQjZJWHpDam1HS1Z3Y1g2UFdQSi9waDRUZVNVYjk2?=
 =?utf-8?B?anNWdjBYVHFhS0JrNXlrVEV1SlFXeGVMVGppa0ZqNzRiRU44U3NQVWl0TUdh?=
 =?utf-8?B?T1dJZHJsWUhjSmpRa0RNVXlOQ1pYMUwxQXhjdEFXNC9NbFZKRXl4Z2w2NWFJ?=
 =?utf-8?B?R2VkUFVXNTVlWExYaGN0YzlHcEF1SnFCTy9NTWVaOE1SMVZpM05sbTYrNjlV?=
 =?utf-8?B?djJ2c0FHQU1oekRsME9jR2FEUlgxUnVrL3FadlNoVkVIWCtWaVExSERWcmli?=
 =?utf-8?B?aVl2T3dmVHpsdTg0Q0FuUkZoSGR4UDUzL2QySExlMVY2SnJKZlp3c2NFNXI3?=
 =?utf-8?B?T2RURkwwSFRDcmRuNlN1dE83dEsrcmFGU280dUF2K3NGb1hUamRnK2E2TS9R?=
 =?utf-8?B?TlVDTUxCK2EyOG9SYnFYblJ6Zm5BN3JKQUtOQ0U4VUpPbGNGNlFZQjRMb0FS?=
 =?utf-8?B?L09zc0t2V2xicmFlc0Z0WW83UitrKzBYVmtNaGMvN2FtdWF4S1hNOGcxVHJ4?=
 =?utf-8?B?VTRkaEJhSXZ0d0plZVAwMFFlZmd6ZDF5LzU3NklIS0ZqTWVTZzlWRm8vc1ph?=
 =?utf-8?B?cTg5MEtmcExzUEhNSndlWS9ZSlBxMXRSQzBZSTJWQng3MEo1VnZpZm1OZmcr?=
 =?utf-8?B?YzQ2Wkg5UlAzQlI0Y3ZuTnN4Q01KRW12R3pSUnd0bU9aQmdSTCtRZGdwbU96?=
 =?utf-8?B?b3pRdzNPUXVMQlNwV2IwOHhIdkJqbGIrQWlybm15azM3djNYUk0yZFVZaXlV?=
 =?utf-8?B?NDJZNDRkMzVyS3FUeC8wTTF2OEtjbFB6RFFtWWhpSkhsMzBZTDdrVjBVckVQ?=
 =?utf-8?B?ZEdTQnp6L1htSVhYc2lteDcwaXIyU3Q4eFVZWjBIU0k3QkdrSSt2K3c1L3Jp?=
 =?utf-8?Q?3ROrn3gMYJC7hcLdDwy3YQiMZ?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c7a6461-7f70-43f0-5d67-08dc764f2b74
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6411.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2024 08:55:58.4104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wQUSZJE/dKnwL+8BJToJsIsZumIIKBCdBArt8x5TMiNVUrwlqDczpNrOHG/pFuRdi0wR+GGKRAs7g0JiGYtsgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB7141

On 2024/5/17 4:49, Mikulas Patocka wrote:
> Device mapper sends flush bios to all the targets and the targets send it
> to the underlying device. That may be inefficient, for example if a table
> contains 10 linear targets pointing to the same physical device, then
> device mapper would send 10 flush bios to that device - despite the fact
> that only one bio would be sufficient.
> 
> This commit optimizes the flush behavior. It introduces a per-target
> variable flush_pass_around - it is set when the target supports flush
> optimization - currently, the dm-linear and dm-stripe targets support it.
> When all the targets in a table have flush_pass_around, flush_pass_around
> on the table is set. __send_empty_flush tests if the table has
> flush_pass_around - and if it has, no flush bios are sent to the targets
> and the list dm_table->devices is iterated and the flush bios are sent to
> each member of the list.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Reported-by: Yang Yang <yang.yang@vivo.com>
> 
> ---
>   drivers/md/dm-core.h          |    4 ++-
>   drivers/md/dm-linear.c        |    1
>   drivers/md/dm-stripe.c        |    1
>   drivers/md/dm-table.c         |    4 +++
>   drivers/md/dm.c               |   47 +++++++++++++++++++++++++++++-------------
>   include/linux/device-mapper.h |    5 ++++
>   6 files changed, 47 insertions(+), 15 deletions(-)
> 
> Index: linux-2.6/drivers/md/dm-core.h
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-core.h	2024-05-15 16:56:49.000000000 +0200
> +++ linux-2.6/drivers/md/dm-core.h	2024-05-15 16:56:49.000000000 +0200
> @@ -206,7 +206,9 @@ struct dm_table {
>   
>   	bool integrity_supported:1;
>   	bool singleton:1;
> -	unsigned integrity_added:1;
> +	bool integrity_added:1;
> +	/* set if all the targets in the table have "flush_pass_around" set */
> +	bool flush_pass_around:1;
>   
>   	/*
>   	 * Indicates the rw permissions for the new logical device.  This
> Index: linux-2.6/drivers/md/dm-linear.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-linear.c	2024-05-15 16:56:49.000000000 +0200
> +++ linux-2.6/drivers/md/dm-linear.c	2024-05-15 16:56:49.000000000 +0200
> @@ -62,6 +62,7 @@ static int linear_ctr(struct dm_target *
>   	ti->num_discard_bios = 1;
>   	ti->num_secure_erase_bios = 1;
>   	ti->num_write_zeroes_bios = 1;
> +	ti->flush_pass_around = true;
>   	ti->private = lc;
>   	return 0;
>   
> Index: linux-2.6/drivers/md/dm-stripe.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-stripe.c	2024-05-15 16:56:49.000000000 +0200
> +++ linux-2.6/drivers/md/dm-stripe.c	2024-05-15 16:56:49.000000000 +0200
> @@ -157,6 +157,7 @@ static int stripe_ctr(struct dm_target *
>   	ti->num_discard_bios = stripes;
>   	ti->num_secure_erase_bios = stripes;
>   	ti->num_write_zeroes_bios = stripes;
> +	ti->flush_pass_around = true;
>   
>   	sc->chunk_size = chunk_size;
>   	if (chunk_size & (chunk_size - 1))
> Index: linux-2.6/drivers/md/dm-table.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-table.c	2024-05-15 16:56:49.000000000 +0200
> +++ linux-2.6/drivers/md/dm-table.c	2024-05-15 16:56:49.000000000 +0200
> @@ -160,6 +160,7 @@ int dm_table_create(struct dm_table **re
>   	t->type = DM_TYPE_NONE;
>   	t->mode = mode;
>   	t->md = md;
> +	t->flush_pass_around = 1;
>   	*result = t;
>   	return 0;
>   }
> @@ -738,6 +739,9 @@ int dm_table_add_target(struct dm_table
>   	if (ti->limit_swap_bios && !static_key_enabled(&swap_bios_enabled.key))
>   		static_branch_enable(&swap_bios_enabled);
>   
> +	if (!ti->flush_pass_around)
> +		t->flush_pass_around = false;
> +
>   	return 0;
>   
>    bad:
> Index: linux-2.6/include/linux/device-mapper.h
> ===================================================================
> --- linux-2.6.orig/include/linux/device-mapper.h	2024-05-15 16:56:49.000000000 +0200
> +++ linux-2.6/include/linux/device-mapper.h	2024-05-15 16:56:49.000000000 +0200
> @@ -397,6 +397,11 @@ struct dm_target {
>   	 * bio_set_dev(). NOTE: ideally a target should _not_ need this.
>   	 */
>   	bool needs_bio_set_dev:1;
> +
> +	/*
> +	 * Set if the target supports flush optimization
> +	 */
> +	bool flush_pass_around:1;
>   };
>   
>   void *dm_per_bio_data(struct bio *bio, size_t data_size);
> Index: linux-2.6/drivers/md/dm.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm.c	2024-05-15 16:56:49.000000000 +0200
> +++ linux-2.6/drivers/md/dm.c	2024-05-16 20:06:32.000000000 +0200
> @@ -645,7 +645,7 @@ static struct bio *alloc_tio(struct clon
>   
>   	/* Set default bdev, but target must bio_set_dev() before issuing IO */
>   	clone->bi_bdev = md->disk->part0;
> -	if (unlikely(ti->needs_bio_set_dev))
> +	if (likely(ti != NULL) && unlikely(ti->needs_bio_set_dev))
>   		bio_set_dev(clone, md->disk->part0);
>   
>   	if (len) {
> @@ -1107,7 +1107,7 @@ static void clone_endio(struct bio *bio)
>   	blk_status_t error = bio->bi_status;
>   	struct dm_target_io *tio = clone_to_tio(bio);
>   	struct dm_target *ti = tio->ti;
> -	dm_endio_fn endio = ti->type->end_io;
> +	dm_endio_fn endio = likely(ti != NULL) ? ti->type->end_io : NULL;
>   	struct dm_io *io = tio->io;
>   	struct mapped_device *md = io->md;
>   
> @@ -1154,7 +1154,7 @@ static void clone_endio(struct bio *bio)
>   	}
>   
>   	if (static_branch_unlikely(&swap_bios_enabled) &&
> -	    unlikely(swap_bios_limit(ti, bio)))
> +	    likely(ti != NULL) && unlikely(swap_bios_limit(ti, bio)))
>   		up(&md->swap_bios_semaphore);
>   
>   	free_tio(bio);
> @@ -1566,17 +1566,36 @@ static void __send_empty_flush(struct cl
>   	ci->sector_count = 0;
>   	ci->io->tio.clone.bi_iter.bi_size = 0;
>   
> -	for (unsigned int i = 0; i < t->num_targets; i++) {
> -		unsigned int bios;
> -		struct dm_target *ti = dm_table_get_target(t, i);
> -
> -		if (unlikely(ti->num_flush_bios == 0))
> -			continue;
> -
> -		atomic_add(ti->num_flush_bios, &ci->io->io_count);
> -		bios = __send_duplicate_bios(ci, ti, ti->num_flush_bios,
> -					     NULL, GFP_NOWAIT);
> -		atomic_sub(ti->num_flush_bios - bios, &ci->io->io_count);
> +	if (!t->flush_pass_around) {
> +		for (unsigned int i = 0; i < t->num_targets; i++) {
> +			unsigned int bios;
> +			struct dm_target *ti = dm_table_get_target(t, i);
> +
> +			if (unlikely(ti->num_flush_bios == 0))
> +				continue;
> +
> +			atomic_add(ti->num_flush_bios, &ci->io->io_count);
> +			bios = __send_duplicate_bios(ci, ti, ti->num_flush_bios,
> +						     NULL, GFP_NOWAIT);
> +			atomic_sub(ti->num_flush_bios - bios, &ci->io->io_count);
> +		}
> +	} else {
> +		/*
> +		 * Note that there's no need to grab t->devices_lock here
> +		 * because the targets that support flush pass-around don't
> +		 * modify the list of devices.
> +		 */
> +		struct list_head *devices = dm_table_get_devices(t);
> +		unsigned int len = 0;
> +		struct dm_dev_internal *dd;
> +		list_for_each_entry(dd, devices, list) {
> +			struct bio *clone;
> +			clone = alloc_tio(ci, NULL, 0, &len, GFP_NOIO);
> +			atomic_add(1, &ci->io->io_count);
> +			bio_set_dev(clone, dd->dm_dev->bdev);
> +			clone->bi_end_io = clone_endio;
> +			dm_submit_bio_remap(clone, NULL);
> +		}
>   	}
>   
>   	/*
> 

Thanks, I tested this patch, and it fixed the issue for me!

