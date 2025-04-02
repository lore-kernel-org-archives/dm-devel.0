Received: from HK3PR03CU002.outbound.protection.outlook.com (mail-eastasiaazon11011054.outbound.protection.outlook.com [52.101.129.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DDE1EB1A7
	for <dm-devel@lists.linux.dev>; Wed,  2 Apr 2025 23:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.129.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743638328; cv=fail; b=J4noIqGNnNCv91uVDVQP4691f9uL9xCK42WbBivTmbPEdlMogfSE7rodcNvCibV9YG3zxAwxhVOkZ5l3BPWU9p09VXQwCMN7q8w0WzWqPGIdndGi1aQSrh/h4TJMvcpnt17+84nNAj2Coc2/W+OBBPoIyUpIj04AwSSlPl189DM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743638328; c=relaxed/simple;
	bh=liLi4pRFXC0Wa2JeeMhLQjzWlpwdnlo1sUJxj776zag=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RWTjQmBqs6McrxcwOmypIgVznIEgjrNLFUVQPupQsajUb9QgsQxtZn74Iup+gBQeWM9Wrt9EqAu1oqEqzAhO2cm31tTqEeBbK09H0umFWUk+iZy7c19HXMcDMMTJvN8IpxRz3x6QDC60jGEZB4wCfWXzEQvpwBqmUJfF6ogMf7I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=dpOav/w8; arc=fail smtp.client-ip=52.101.129.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="dpOav/w8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l1n1HKrJoao+b8oZsv7yFi9b0Alfw2O/yeS4X8OGRhSluo1jjSt4BapmTL9qtG4RdX/lsH/o+dZBTDrlw6Ek8Zv4hpOA34w3V5dk1w25g8NHX5yS4gVDdBPDOaX5HD1f9UAfx6kxvxS+21aU9V5MX1zeIx5LSY3/kgqwhky6sR3bnn6mFNNxwrKLtK3U2ma+ZOgqEpocEc/uOB48izWXqjpLNpzfJ7ZYJjIGRzALiRuqvpl2BetcOZue0Z2SfuQ4FPlyV5kYjoE9U4MRyzTWctg1M/SHuR0/e7d6J3HZSLG69dOQc1GDjmBomyS7CruWSvEIPshYP3elgWRh11TF2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wXJdSV40v7sS8zoQXK2y/36CJQOEcUTa3X0UyeKqYDM=;
 b=rCZv2R2h702zmb0zPPnrrMReHstlHCHawi61lhUnMzN8WcB5l0I/KOj5dxQGGlnyOsq1aCHP+NPPNjLan/3+jm1yEI3st4fj9Ti5GX8x8vOEboQlZoCfdx8ihXQ4eTuIGKe2bmKo8p1squ2P3A4KIGAWgIDCa3I6s9upXAnWne6c2PEIPDwUSzuXboqkN8/w5TqLQ6XTG+kFcyUWSg9eB2VhcC4W9Bm9PmXRWb0+CDEz3GnBR84zF+M4ay0ZSvW0L5Q2kF5FpvOhOObJFlF/k191pu7g6fSKrv0xUfMV+pz1tHFIevtbkOkAIUbaSZK3eKImjdubGVpVujw1OAWY9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wXJdSV40v7sS8zoQXK2y/36CJQOEcUTa3X0UyeKqYDM=;
 b=dpOav/w8fML0ZKsA4nubtA1u609OVAqWhBMGlgpghEoSD3967bz+mPlrXp1wq9paYQrteZVwDCuy+bxK6rld1/WgeO7lIlW5t14g4/2Q//uTCsjcpz9xLNWZT6aHzNcT6wvtAD5pjKU+a4O++PPa4cAANn3nzMydHX5U/1RHhog=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by TYZPR02MB5665.apcprd02.prod.outlook.com (2603:1096:400:1c3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.19; Wed, 2 Apr
 2025 23:58:41 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8606.019; Wed, 2 Apr 2025
 23:58:40 +0000
Message-ID: <650fda27-56fd-4918-990c-663e4e7649f7@oppo.com>
Date: Thu, 3 Apr 2025 07:58:35 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] dm-verity: prefetch all hash blocks in verity_ctr
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: snitzer@kernel.org, dm-devel@lists.linux.dev, guoweichao@oppo.com,
 ebiggers@kernel.org, bvanassche@acm.org
References: <20250402070934.2387587-1-weilongping@oppo.com>
 <20250402070934.2387587-2-weilongping@oppo.com>
 <8ec81db3-fff0-71be-e643-b74cb5bb88de@redhat.com>
 <d25b56ad-fa6f-49db-9a78-d4849742b22e@oppo.com>
 <7228249e-db9d-be26-8459-9141ec3b3ceb@redhat.com>
From: LongPing Wei <weilongping@oppo.com>
In-Reply-To: <7228249e-db9d-be26-8459-9141ec3b3ceb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0188.apcprd04.prod.outlook.com
 (2603:1096:4:14::26) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|TYZPR02MB5665:EE_
X-MS-Office365-Filtering-Correlation-Id: 5286a53f-bcea-41fa-90ca-08dd72424a5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TEdoMlc1VlBXck10SWg3OHNVNTAzZy9oNFM3M0lid1U3ZUhuTTA0TU1OZlF2?=
 =?utf-8?B?bjkzSHNlYzlXMDJobzBGaHlyQU9UdS9EanJjQ05PbXhrWlN1NU1TcVdhc2FY?=
 =?utf-8?B?RkhRRDhQbFRNcEIrTkVZTjcwS1JIQ3RZZXRORE5QTlpZTGo3ZmtiUm1UcHht?=
 =?utf-8?B?QzhWN09FY2JIdEhQcS9kZEdxT3M4WjRubmtib0tjZWtoSE9NZTFsU1lPVy84?=
 =?utf-8?B?VWNJOVpTQU9oTFh3eW5xaXA3dExoZFdTVWg2a21qaWhMYmpmSE80c3JiQ1VU?=
 =?utf-8?B?TTZpdjRqdmtXdTFncE0vTFRJanBwdlI2ajRIeUFmdkRZMkZkOVpDNFBHQm9h?=
 =?utf-8?B?VkFoSnI4enYrb3ZkUUdwWm8vQld0R25OMVErM0p2WjU0RWJaQmdiRGlBT3dM?=
 =?utf-8?B?NXRQSWg5YlVRNHlFSTNLTDVlVnVKbEg4U2dYMHh5M0NHSitDRmo3VWEyMWVu?=
 =?utf-8?B?QW1vaWpRRjhkTWhNSkxGdCtLcW9kKzBYUmFMVllNdFArWXVnRnJpbE03WUJs?=
 =?utf-8?B?d012M0V0Lzh4WmRuREM0Ky9iZVZYUCtGK0xJRnFuTzlybFM1Z2x5cHRHU29q?=
 =?utf-8?B?YnI4QXk2VU8rOUt6ekhPb05SVHZSK2FXdkpaNFBLRmFiMUJpbHN3UkJ1RXJF?=
 =?utf-8?B?dW9mM2pqZFpPMlczeUpURFdJLythQ2VqZjRVNDh3M092NzZ5eGlDRkgrY1JN?=
 =?utf-8?B?OFo2RDRZcDA2dlRlU0l5V3d0Wm1jWVpaMjd5c2hRZGh4WTBxT3dmN0pQeU0z?=
 =?utf-8?B?MGFyY1FtT1BnY0tWMm8vZGJGK05peEhOelFSd0VaY04raXhLZ1c1M3UzanpR?=
 =?utf-8?B?YUlPOUVuN1hOcFZESVVEdzNybzhUNW94WktXUWxjVnN3RG14Y0dVc0hWR0FV?=
 =?utf-8?B?RkxkMVJvZUU1Zm4vMFczeXM1aUEwZElvNkJKMGwwWEg3Tm13enh1QjBwbWpV?=
 =?utf-8?B?cG1CTWM3M21xbnJBN2lRZHAwZXA0NjFET2lxVW5NZTAwYTJnTzhnc1dIb1dS?=
 =?utf-8?B?OTAwZVlzVEVLYVBLS2dUK1RhV2F4eFZIampUS1dpM2c5THk4SCt6WlozYVRZ?=
 =?utf-8?B?Um5CbzNZUkxFaVkyODRZc25lcUN4Z1ZsYUhXcENkeklpWXl6ZzJXd2tNRm1a?=
 =?utf-8?B?SXg1MFJzZVZ2ODIyd3lYZVpNMXZIZ05KNVpUNUxVYkJZcm9KTTJjTE5OSUZ5?=
 =?utf-8?B?M25RVzRCeVNseWt2TzJtL3pwdGZVdk1WMEtJZUJ2c3BNbVl5T1JXWUlMT0hZ?=
 =?utf-8?B?cWlkN3MyKzJ6am8rcDJlS3VCTDVQRGpuSTEwaHN6KzFjczFrT05vSWN1QmtP?=
 =?utf-8?B?ZGoySlJMOHZNSHVSbFU2OHhrbTBqTEdKWTVrV3pqbWNqTW5uOFV6c2pYb1R2?=
 =?utf-8?B?ckpaMUNVK1dGckVPM2x4SXcxOUh1c1FPWnNxMjJwaUtGQnhtUjA0QlBwL2M5?=
 =?utf-8?B?YjFPZjhOUG16UnBtaU9HTEJQTStQcEt4WlhQV1ZEcGdyTnhrdktYai9RUDBJ?=
 =?utf-8?B?WXlhMG13WnVNa0M0SzhoQWNsd3ZoK2ROanJkUng3eHhHczdLR1YzRlZZKzBu?=
 =?utf-8?B?MnhUWTR3Mk40bE1uelZRRDRyeFBkRDhjUFc1bGpUaGhkdFNJYlpqRDVNR2Rj?=
 =?utf-8?B?MkpqTmw4WkFkZUJCMnR0ZkE5VngrWmNPa0svd1krSG5hbGVqcS9nTXRMSC96?=
 =?utf-8?B?MVBwckNjcnJYT1ptck5hQktGWk1QQ00vWUdrQXdjdWRYaEhlWlY4T1h3OTZs?=
 =?utf-8?B?RTI1cWk3S1pDbWIwVEs4ZXVnQ0hTTm5WQXZrdXNXbG8xSTc5WkttekFWOFow?=
 =?utf-8?B?dHhPUytNeU9lK1h2eW9FR0I4SVlWTTQyZW9ac242ZlNVYlRtOWV5VzE4U0Zx?=
 =?utf-8?Q?A7QNCaTyge46/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eW51bTZ5WTVQS0NkcGRkb2ZvclFKUzRSNVRWQjRjT29kd0t6MXo3ZGhjNHJx?=
 =?utf-8?B?alB4cHlsbWJicmExZ0lOSHVHZ0NtWmZGajA4RG9uUmdhTUZ4K0NOcTFXbXV4?=
 =?utf-8?B?QW1lbWhxOEtPSDdxSzdVWTA3UUttMlVCdXg1ZTl6UFJyMS8yWU5VOFY0TW1Z?=
 =?utf-8?B?dldyVHZTQmdBTXJNZG90Z2RLOFJHSUtrTFptQkZ3cTI5TGJ5MnovNDIyaldW?=
 =?utf-8?B?eGo0V3N1UElWMkVZZ2JxWkdCdFF3ZW8wOFdTNGcxK1p0dkM4RHNTcUdULzdn?=
 =?utf-8?B?enJPN3BEcnNvMDB0cVJvNXdIQzZabm9HZklDRkxucmV1N0J5U1hWcHI5Z1VW?=
 =?utf-8?B?SzJsZlVNa1FxK1Z4RkdyMjNvSW52MUdIL094VE9xa1RabEF1YnVKS3QrWjVV?=
 =?utf-8?B?d0hnMXVKaENPM015aXdHMjk4YVF1bnFpb2lLaGhnMFM3M0NQYzh2dlNWRFJx?=
 =?utf-8?B?MHRRWjF3cjFaVWdsdzVwbkx5UFVGSGdqdlBDK1VKUW5IQ1FXWkFvUU1TUnVK?=
 =?utf-8?B?UERXZ0lXNUFBZHRrSCtlWGFKSEJGYlJWbVM0cnJNdEN2YklkSDg0Tll3Zk9h?=
 =?utf-8?B?NUcxYjVtaVdBY1RMc3p0VVoxL2dyMWdkRHl0T09nWTJxVUJRR2w2ZzZKQnNs?=
 =?utf-8?B?bThYdk8wTVFwMWxVVDlrRWxJQ20xb1lVdGdxTHpjbWdhbzBzRUFnNmZjZ2wz?=
 =?utf-8?B?Z1V6ZmJrSTdwcU1OVndoNGsyR0N5UjQwUXVUL1hBZTc3NDJCcTJNOEdrN2Zv?=
 =?utf-8?B?Tk1NalFWZWM2aTBrNE03U0FQWGgrajZpWC8vM0p4T2J5Z1RzelJOK0xrTFcx?=
 =?utf-8?B?NExzMGhQbnRGajErUnZFTFFBckpVRWRpRFFjT2wvM1U0cVJtZ0FhN0dnV053?=
 =?utf-8?B?ZkwyMFFyc3NXM0czRVQyTlUzbWE2QzNjNk9uRlYzb2VXNEUvVEkzOWozREVO?=
 =?utf-8?B?SjU0SlNrRTE3eENpN3JRVWwvY01rZ1FkY2dmMm90cFhLY1llMHN4R3ZIZm5y?=
 =?utf-8?B?VEJWSzRJQUhCdkpjcXBjRGlHSFNob2hVekREUFFSUXcvbnFGNkhudEVEQUhY?=
 =?utf-8?B?T0FFUDhFanJsY2dlWEFlT1YxaXRaN0t5ZFdlWkU4dUVCdkpxeDNER1ZBV3dC?=
 =?utf-8?B?R0hwQ3BPUC9uUXlCRjg5dGNqTXYvRXd4cXc4L0RhZ2VxQndMZFJYblZhZ1VK?=
 =?utf-8?B?RFhHeUp1dW0xMmxxN3V5Szg4dlNVQUxKRUk5d1lqcUhERTdqS2pUTUMxSDRY?=
 =?utf-8?B?Z0FnM1FBcVpKS0pVUXVWOEI0c0NMZE1saDhCbmdIdzhKeHdxRWYzUjlYbWhr?=
 =?utf-8?B?OUVrQUx4Mlo2T09PSEpDNUVuVmRJUCt1NWtrdThFMG1rWjhTV3FQcGVWRER5?=
 =?utf-8?B?b0NzaFM3UUh1akZtbXhmNGd0a1F0QjNxMXNGMlZLNml5azNpN2VlaGlsc3JZ?=
 =?utf-8?B?dUdwNDRxMlJWdzE1enZ1S1VoOGRwQS9DT1lWN2Fmb1hDZ1Nwd1B0SEdSNHJT?=
 =?utf-8?B?TUE5Vi9FWFp4dzF4d21Rd2hTeDJSOUJxRG11am5XYnJhTWNIWXd6ZTQrOTBy?=
 =?utf-8?B?by82bnhPeitPREhRSkt4MGRyeUpEL2cvcUJQNHNpbllkMVQwOUxDV3FiMWNr?=
 =?utf-8?B?Z3lPVU8yS1lXQmtTdVVnMEFSbkVVbjhyU0VPaHZQSGNwWWZEemRWc0JkZ3o0?=
 =?utf-8?B?SWJQK2xXaDU3dUFhbkZ2NjlRVWdvR3JLNWFlVFlyV1dlMlRxWHlZblNjNWJw?=
 =?utf-8?B?NlgwRVFjSisyemMrT0JVQlBsaCtrZ0dXUjZOWlAwRC9xRW96YlVhVGRPSUpl?=
 =?utf-8?B?WDIvQUN6eHV3SjZCOGlLelBXdlNyclFkeUsrK096OTdyamtyRnV6a2NUbEFq?=
 =?utf-8?B?cW5JWkFMaUY5d0VuelNFemJpWk1qdUtRd2hHZmpWblZZeXNhTTFZUnlGaE9t?=
 =?utf-8?B?WUdEcTAweUF4bU43WHA3NEowbDc4T2lLb3lSWC9lTTdQRDlxZ0ZjekFYZmhL?=
 =?utf-8?B?TURwc1F5ZUx1YjdrSWlnNW1jZExIakxmTWR3OXBqV2tSWGVsTWZpTVNTTFdv?=
 =?utf-8?B?WWthM2U2cm43UWlBQ2syYWN4Y3NFWFFoU1NoQVk4b21FaGJYYWI0VklMcTIr?=
 =?utf-8?Q?eS+B8Ytc0/qUJc8s8euPyk34A?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5286a53f-bcea-41fa-90ca-08dd72424a5c
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2025 23:58:40.0465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3LTu6wf68U9xfpfwuCL4iOHdaJrOaLgPtc50J+sq/LBCLYVcQ2mjgIvhTHHKPUzckv10wQJM+PUJzJtksj7h1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR02MB5665

On 2025/4/3 2:44, Mikulas Patocka wrote:
> 
> 
> On Wed, 2 Apr 2025, LongPing Wei wrote:
> 
>> On 2025/4/2 17:56, Mikulas Patocka wrote:
>>>
>>>
>>> On Wed, 2 Apr 2025, LongPing Wei wrote:
>>>
>>>> At this time, all bios for hash blocks should eventually
>>>> be merged into a single large bio.
>>>>
>>>> Signed-off-by: LongPing Wei <weilongping@oppo.com>
>>>> ---
>>>>    drivers/md/dm-verity-target.c | 4 ++++
>>>>    1 file changed, 4 insertions(+)
>>>>
>>>> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
>>>> index 3c427f18a04b..813d5cfc7ffa 100644
>>>> --- a/drivers/md/dm-verity-target.c
>>>> +++ b/drivers/md/dm-verity-target.c
>>>> @@ -1683,6 +1683,10 @@ static int verity_ctr(struct dm_target *ti,
>>>> unsigned int argc, char **argv)
>>>>      	verity_verify_sig_opts_cleanup(&verify_args);
>>>>    +	dm_bufio_prefetch_with_ioprio(v->bufio, v->hash_start,
>>>> +		v->hash_blocks - v->hash_start,
>>>> +		IOPRIO_PRIO_VALUE(IOPRIO_CLASS_RT, 0));
>>>> +
>>>>    	dm_audit_log_ctr(DM_MSG_PREFIX, ti, 1);
>>>>      	return 0;
>>>> -- 
>>>> 2.34.1
>>>
>>> Hi
>>>
>>> I would move it into the "resume" callback, so that if the user
>>> reconfigures the device stack between "ctr" and "resume", it won't read
>>> the data too early.
>>>
>>> Don't use IOPRIO_CLASS_RT, this is not real-time requirement,
>>> IOPRIO_CLASS_RT would slow down concurrent I/O.
>>>
>> If the prefetch io is submitted with non-rt at first, the later dm io
>> need the same hash block will wait the non-rt bio.
> 
> Submitting large I/O with IOPRIO_CLASS_RT will block every other task that
> does some I/O, so I can't do that. It needs to be changed to
> IOPRIO_CLASS_NONE or IOPRIO_CLASS_IDLE.
> 
>>> Another problem with this approach is that when the verity device is big
>>> and system memory is small, it just causes I/O churn - new bufio blocks
>>> will be displacing old blocks - and it will degrade performance, not
>>> improve it.
>>>
>> Do we need a solution to check if the memory is enough to the prefetch?
> 
> Yes.
> 
>> For Android devices, the verity device should be created on the boot
>> procedure.
> 
>>> Please, describe some scenario, where this prefetch actually helps. What
>>> is the size of the metadata that you are prefetching? What is the total
>>> memory size? Is there any benchmark that shows the advantage of this
>>> patch?
>>
>> The size of hash blocks for the ROM of our low-end devices is about
>> 71MiB. I want to enhance probability of cache hit when
>> try_verify_in_tasklet is enabled. How about only doing the prefetch when
>> try_verify_in_tasklet is enabled?
>> For example:
>> 	if (v->use_bh_wq)
>> 		dm_bufio_prefetch_with_ioprio(v->bufio, v->hash_start,
>> 			v->hash_blocks - v->hash_start,
>> 			IOPRIO_PRIO_VALUE(IOPRIO_CLASS_RT, 0));
> 
> I wouldn't overload the "use_bh_wq" option for that. Perhaps we could add
> a new option (that would be off by default), so that the patch won't cause
> problems to existing users.
> 
> How much does this patch improve Android boot time? So that we can decide
> whether the improvement is worth the complexity.
> 
> Mikulas
> 

Hi, Mikulas

Can we add a parameter that is used only once in the process of ctr or
resume?

For normal boot, the improvement is not significant. But for upgrading
boot, it could be valuable to do this as dm-verity works on dm-user and
snapshotd in userspace has a large number of writes in the background.
We have met an issue of system running slowly in this situation.

If a parameter that is used only once in the process of ctr or
resume is acceptable, I want to use it only in upgrading boot mode and
the shrinker of dm-bufio should be skipped until the system is upgraded.

The goal is to reduce the number of read requests to snapuserd.

LongPing
