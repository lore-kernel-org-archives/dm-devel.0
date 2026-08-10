Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11022120.outbound.protection.outlook.com [52.101.53.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB4E281530
	for <dm-devel@lists.linux.dev>; Mon, 10 Aug 2026 01:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.120
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786324831; cv=fail; b=A1oH8ZevVbe062VnJPo+qkkABWbR5ZhwSfh6Pq3h+cCPi0jnWdfdnQCTgR5HqPZZV13WbQwuVRAtXids5UJfwN8x7RyZnwyHXhHtbatwWuV4NvitvL2hqjxwKka9CA/JgxiSV+WSu92VYRWAfymMclT2eva2X2Yph8cRilee9kA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786324831; c=relaxed/simple;
	bh=dp1VCO+fLC/YZilCmVf+Srg4wubrq3TGJGBdGzSqG4E=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jJwGvxu4qjOv9Llv0u8C3mryoXhiUDXvR6Bq3ot9gBRdKA2tDM4TRdcPO4fifXKgsqkwnUFvLYFN9mT8VshMf+PwcC9fXF23jDe+K4AvLX4544JQrjyDkTdlV55YMOQBhSRs5b2iJ5m7cwSQA5e+c9CTlUANuHYiKXehblzdvXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pythonplayer123.dev; spf=pass smtp.mailfrom=is-likely.gay; dkim=pass (2048-bit key) header.d=pythonplayer123.dev header.i=@pythonplayer123.dev header.b=FcnNB00y; arc=fail smtp.client-ip=52.101.53.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pythonplayer123.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=is-likely.gay
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pythonplayer123.dev header.i=@pythonplayer123.dev header.b="FcnNB00y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=odiFZu2mI6BfhTd6Dk5Gqz/l1KFAf2+9TVwKT/MzBywKtILIyfIByATHYWd0U/pOBm5vV0cABxW/feYAuNMlJME1XRuJJwiuRo5Te5/+fw3OuFkT0gSQoBRyJwIpYVTIkExLrCgM+r2R05UlDWCcHUGsZkbdD+01AmD7/ujba4L6FgkqpIOJOd4PxJa1fHqxj0ltYQXeFtvbRC7RWvUR76hTy9NnduoIdU8y/U3evJ0vTC/egCQFT1qeLETk4Exi/bHWP9S2m+ZW52hznvEO1vNDTeF+H/LxAcmejHSS90b+nQzJtegl27S0v5ZkZ44i/O4CMtiY2jhxtn+Ov1++gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dp1VCO+fLC/YZilCmVf+Srg4wubrq3TGJGBdGzSqG4E=;
 b=rLNEZ2QpaxZ5sA589Y1EWo1mdCS+NgXdM4gUEyXt25W01MnPenDQ9TjbQbIpnurzDPh66llW3OfYOWzle7MDO20Xo3+pabZoeSl1PkfHZTtdw5Z7BwxaS//KpGNhjPnFHF6FbNjqYmnRGGeRUtwMz4rk4N8L2uOBKTv/DRt4trhY85xhp8DiLG9keryvpfLmx+ak/a96emyy2FO2UIqFs48WXlZ6YC199GihG5kb7am7RIikObB/3/vpkbEYdhaCllI3OB/hvFmSNI+W+BEXFZVaIhlTEuU9RbdXcierXOkVpu3KCbVGcjjXamgVeX8eOuZAZEXv/tmDpJQ6SnlUfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=is-likely.gay; dmarc=pass action=none
 header.from=pythonplayer123.dev; dkim=pass header.d=pythonplayer123.dev;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pythonplayer123.dev;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dp1VCO+fLC/YZilCmVf+Srg4wubrq3TGJGBdGzSqG4E=;
 b=FcnNB00yaz09ts8ZLH6nWYd1u2AE7E/B+T43TE6orp+dAksfzKsTAAAMI2SIwSbQQEkkyHfq84Q4ftChsI1UXKCidsAEFPH7zCfmp7ynDTzjAmJgNk1vCd+rnOUaglgqwF3F83PB6+GldlmotdWcvLBk6UFtqwrFR0BqWLHxYjnYkq3j04mVFciGvrqDExP57Wwrq7TWmJkpdB+iMGqdO4qYg0+GiD/eo1SMpkp8AurZbVR04K+ESvOVmDad2QgwskxyMGlqF+UnQ5IrY7IITp+7wF1g/LbhpxtxLRe5GH+s4qeHWI04r0xMBuvhFjOumQ00rbQnZCVmr/Wl0PvbYA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=pythonplayer123.dev;
Received: from LV0PR20MB994500.namprd20.prod.outlook.com
 (2603:10b6:408:344::7) by IA1PR20MB5981.namprd20.prod.outlook.com
 (2603:10b6:208:3fb::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Mon, 10 Aug
 2026 01:20:25 +0000
Received: from LV0PR20MB994500.namprd20.prod.outlook.com
 ([fe80::c932:7e2e:4995:2a9f]) by LV0PR20MB994500.namprd20.prod.outlook.com
 ([fe80::c932:7e2e:4995:2a9f%4]) with mapi id 15.21.0292.024; Mon, 10 Aug 2026
 01:20:25 +0000
Message-ID: <20ef74e9-3a09-4782-8a12-f8c24148a0be@pythonplayer123.dev>
Date: Mon, 10 Aug 2026 10:20:20 +0900
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] vdo: add zstd compression support
To: Matthew Sakai <msakai@redhat.com>, dm-devel@lists.linux.dev
References: <20260723161350.1080473-1-june@pythonplayer123.dev>
 <178a5039-1817-4e13-8937-12eee8b26cc6@redhat.com>
 <012e81d2-dd6e-4977-b385-d7ac890be2a2@pythonplayer123.dev>
 <25a53d68-e1ab-4262-9ee4-36dac5980fa0@redhat.com>
Content-Language: en-US
From: June Park <june@pythonplayer123.dev>
In-Reply-To: <25a53d68-e1ab-4262-9ee4-36dac5980fa0@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SEWP216CA0093.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bf::8) To LV0PR20MB994500.namprd20.prod.outlook.com
 (2603:10b6:408:344::7)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV0PR20MB994500:EE_|IA1PR20MB5981:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a200ff5-4c80-4162-5987-08def67d8e6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|41320700013|34036016|23010399003|376014|19092799006|18002099003|22082099003|56012099006|11063799006|4143699003|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	ff4FPLeYnaqd3PkZ6HlPBp3uCmywEy6SoTsoKBmNRmW6fYJsszfdEKJ/to6Mbsq3nyLSc+1OEhwZFavUXf6g4gldmoRHAOYV/0/jYhczo7Psdib932G9cZ4ubeENKwSOxDLDzuDRvgl6xrg5SSTlHmOkm+xm877MPvqDN2p8RDXJAKhx/HtuF3rTE0JiRWx3P9hM0/nm3BZRN/bI1KFEn47M/uuUKVJJpMETCui4IjPRUcIIJZUBJmCulhT99cV4jVqiDe8QRh0IZySW/MCdoGLbh0Do1CLW+KfxBYGJKniQzLnnQu0otnUQlOQrIhhv6EQTONFDJ2wYJYI6L1QQrqTZzgxZzfTGRZI9lnMamSGkcYkKN3QQ732AYg5HgkIa2MAgddWRLEyuN06+h+200Q4YG5e8c+QQaWTuu6ii5Yu8NTRwCHJySCQCNYvR+3ch2tqR8I1wxrQbR+Hs7giwEFnhTRcVZEu1mhVaZD5lK4ADW/MhfujR17JkTjMosTeBkLsBb2Xxo1mW4DTmCcmGurpyP303BqO/F4V/SgiTwEJ78PUOnfAz3YFCJAu5VBRY5MMxnD+m0JUKxrvxGVjq2pNMyui7fUk8VU/ALLHvthCJ/QVGM3zkeP4HiNglTHCYfqKYZNrDL0BdPEhlPiMKKPmSWMoXAGNR+G6RP7ehs34=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR20MB994500.namprd20.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(41320700013)(34036016)(23010399003)(376014)(19092799006)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003)(6133799003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z1B6TEVtQWJEdStrZ2VGWFZkMzhXZzMydndmY2FhSXZqUFZvUHVEMjkxcGRT?=
 =?utf-8?B?SURVcXg2b1ltcTdYZnI3UTY2RUxYVEUvLzd4anFSdTJONWM4QmF3cElKOFBh?=
 =?utf-8?B?eDBlNzU0SmJKVHYxOEV6TDhsSDBhQTRuUHA3VjAyUHlBY2pWYkxLcnNXbnV3?=
 =?utf-8?B?QnZ5cGhHRi8xTlpQZjFzVVlTU0tqenBjeElNUzJDQUM0NXJuallFMzk0NUl3?=
 =?utf-8?B?WnZub0dwaDFCVDVJZmpBbDM0b01hOGtkT0NES29ENmhrSXdQdkhLZExHMHVu?=
 =?utf-8?B?bFNGZXJpSlVhM2l0WUE5NVpmQmFkMHRZQ3dHZERPMDVlYnA2YUNuVk9nVFBQ?=
 =?utf-8?B?T0FxSG9adFNKWFJHdVRhdG50S2F3Zy9MMHllY1dLQ0JvUjNCUXorbVJzNnls?=
 =?utf-8?B?dy9qNjhFc1U1WGhVVXpMTG5ieFNqVytDRytxYWE2QjFyTE45T1ZoK0ZqOHds?=
 =?utf-8?B?MUE3NXFTeEdlYUZ5bFArYlp2N3Zoa2dCSUpDY3locEpNV2VHL2RqZ2tnajBM?=
 =?utf-8?B?emc4dC9iTFVHSzlBZ2YwMFlsWitNTGl3KzhjcEp2K1lJYm9VcUdRdGNsMXJj?=
 =?utf-8?B?aEdmQVZTRjh0Zi9iUStpOWZPT244N000djdLQjdnZGswKy9IZUZ4SjNlNmlX?=
 =?utf-8?B?dkFuODlpcGJuOFNMdjdhVVJVaHUvbDNHamg5TDNRSXJrTnI4NmZ3dHBsamtq?=
 =?utf-8?B?dEt0bVBPNk1yY0hweXlwMnpyOXNZN29XU0pqaVkybEhsZldtb1VoM04rZFVz?=
 =?utf-8?B?MXBLdHdPUCtRUE1mNlVSUWE0aHhIdCtRS01vaUo1eUlhZTJ4Y2M2MzN3VjJP?=
 =?utf-8?B?VHdyL0RYcVpoeWs3UlJWY3Fwa2JSYklmTVhTWWh4bWxiVUFPbUtaWXVjZGx6?=
 =?utf-8?B?Y1RHYlFnenlveEs0NnVNUE9nTk1sbFlvVjR6TzUzd3F2dE56ZjZIajArVzBr?=
 =?utf-8?B?NmQrSzlFMWNKMHNJTEt1Q2RObExyUWgyVjVRdE9DNk9zOWNTODk3MVNSbExT?=
 =?utf-8?B?bHpmdlcxaCszLzZibkVvOG0xNWtqZ3FNeGNZL01McHNLN1lrTkYvZlQ2Q011?=
 =?utf-8?B?MlJJTFZmY0MvWmk0VnNXU05IUmlRMUVob2k3WkZ4cjBRaHJudW1uU0ptQi92?=
 =?utf-8?B?bHhiR3lUYXdkR2l6RE1nZkVvMnZnOGRqQ01id0VkMHByMmlSWXB3UDBvMVpP?=
 =?utf-8?B?WnoyMFowZEdkZ0tvbzU5aUpIb3h1dUdseGM4bUp6bTVabEhJQWp0UmpFOVRr?=
 =?utf-8?B?Rk9xYXQza2Y4aGcwM3ViYnFiQTlwQUhEdjdSODIzOFRVeEN1azRtemZRemxZ?=
 =?utf-8?B?c3pSVlUwL0g2M0h5cWlaeW8yY1pzcFd2c0dxR1hvMmxkOWtybElvMmlrY3J3?=
 =?utf-8?B?OVRmeU5KczZ6TUFrSXlvSzFxN25PUHREdnl3cDNTQS90YjVSVUdtYm1jYVpq?=
 =?utf-8?B?UGdJOERlUHpwZVo4STF2ZlRLalRLVmwwNWtSMnZaUVdMVkVLNEpiU2xLanE2?=
 =?utf-8?B?VWFLdkVtQmdmYVlNUmFnQTVUWk4vb3Vna2dnSDlwazVpMUhjbEYyV05vN2hM?=
 =?utf-8?B?N1R0WU84bmpMdzdNbWFsTnJkU3g4VU9HYUdWaG0rZjJneTFaQTBmUWVNNytV?=
 =?utf-8?B?TTlaNFlYcEZwYlpzVHdCYUJPSmJ2MmdYOXdJd2ZEaDhpN01BLytLeWY1Nm05?=
 =?utf-8?B?MHNNcWFzQXlJNko1WldiWHRMb0R2K2dtZ0dxTWNjdlFBRlVqMC9TUk12SXBT?=
 =?utf-8?B?VWRBdWRZY3dkSFJnVEkyLzVLMkdUSDJTY3pCU3hBZndUd0czSHJvazF4djFN?=
 =?utf-8?B?ZmRNN3ZzdmJVSzVocjhrRFErY2UrcHozcUJwSk1XeURRQ2ZtOS9HWStST3c0?=
 =?utf-8?B?Nk8wNUd2MElTYUVUbWtsTUJDN1phOU52WnFHYzB0cTBnTjJrL1VUWkF6dldm?=
 =?utf-8?B?c3QyRnRCcmR1Rk9tNEtZRzUxanNURkN1V1NXM0xsM1dSNWlxVHhrcFRhd0F6?=
 =?utf-8?B?NjlEa0NCY01hQThhMFZZckRzRXBxOHVwYjdrMU5EdHAyWXJ6QjR1L3J0YmhX?=
 =?utf-8?B?bHM0aFZpb3RZL0ljc3h6eGtBbGlNVzB5YnRkMExSbGs4SnNJQXZnTkR4N3RF?=
 =?utf-8?B?eVJhVmNYMzRtc3ZEdlc0RDNzcUdweWEyMXdQRFlxeGVPcUpEbE5KMzh6Mlcw?=
 =?utf-8?B?d2FHWjdyV3NHa1NySkpFcW1DT0xTbHc5RmpITDN6U0xvU3dqYTdaRHJCbktC?=
 =?utf-8?B?Z1owKy9VUUZTa00zWFduSzhGLy9ObXJBWHMvL1FKdG9mN2xxd1V5ZS84U0Zq?=
 =?utf-8?B?djU4UVEvSFdndnZ1U29LVXMrbmZac2dVeDF5VjJZaVRwUTBtbkxtdz09?=
X-OriginatorOrg: pythonplayer123.dev
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a200ff5-4c80-4162-5987-08def67d8e6b
X-MS-Exchange-CrossTenant-AuthSource: LV0PR20MB994500.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 01:20:25.4889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a3ce53b7-1063-4e66-9486-3ad7281a5cc5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: maVusUk95MIsYCYRHA/IWsBPFkbVPK1U1mA5o4gD4l/+OWB/kttTvhg/u2YEkpB53iKr6j46nlYpqCO0u9NRbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR20MB5981

On 8/8/26 10:37 AM, Matthew Sakai wrote:
> Thank you for your patience. This took me longer to get to than I had hoped.
No worries!
> If you have data handy from these experiments, it would be interesting to see it. This is the sort of information that would go well in a cover letter explaining what you want to do, and why. At any rate, if you have cases that seem to benefit from this, we can certainly revisit whether this is worth adding.
> Another thing to consider is that we originally chose the LZ4 algorithm because it is fairly cheap to compute. If you can, it's worth trying to quantify what the extra computational load does to vdo throughput, especially with fast storage. The throughput for a vdo volume will often lag the raw storage speed significantly (due to the deduplication machinery) and it's worth knowing if changing the algorithm will make that worse.

Yes, I'll make sure to include more details in the future.

> I appreciate that you're attempting to minimize disruption. I admit that it is simpler, in terms of pure implementation, to make this a format-time choice. However, imagine what happen next:  Long-time vdo users will inquire whether they can use this new feature, and we will have to tell them no. For new users, I think they may not know all the data they will store on a volume up front, but they will be locked into their first choice. Given the case-by-case variability of the tradeoff, I expect users will appreciate being able to change this setting to fit their current needs.
> In short, doing this as a format-only option looks like implementing half a feature to me, and I think we would be better off starting with full flexibility. Also remember that every version of this feature that we expose to users is a feature we will have to maintain for the lifetime of the dm-vdo driver, and I would rather not have to support both versions.
> (I believe the difference in complexity is also not that large, but that's a bit more subjective. Setting the algorithm as a run-time option means extending the compressed block format, but adding a format-time option involves more work updating the user space tools, including the formatter. Both options also require updating the table line and the super block format, so there's also considerable overlap.)

Personally, the superblock modifications felt quite concerning at first glance, but that seems less like a huge issue, if it is justified.

> So anyway. If you can show there is utility in doing this, we can look at adding it. I will probably want to do it by building on what we did last year, though. You can look at what I've already done on the branch feature/allow-compression-configuration in the vdo-devel project. I haven't rebased the branch in a while, but you can get an idea of how I was planning the table line and super block changes, at least.

Thank you

June
