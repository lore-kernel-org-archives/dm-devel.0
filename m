Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2048.outbound.protection.outlook.com [40.107.117.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224091E1DF8
	for <dm-devel@lists.linux.dev>; Thu, 10 Apr 2025 08:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744272384; cv=fail; b=HRwIXivGgDZP4moUju9HXd1Jw8Tr5XID6Lj5g9JVMg7hUuZkbHv0bnLiJfyubAIK1P8dqMtPobSA6k+55M8K2FyXTwolqU4PBOlbL/2/NPcm8lUgU4u8e52JvTkRHll0KChkqFGaggC5ugSGNdXFJkGjzjHzYHlF6fMmGOVwgAo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744272384; c=relaxed/simple;
	bh=RijQ1DN+M7sUFq4kqd6ebjNxfAoUhXhH+nHussMwVNU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U4ClJ8XTobq7aAdzNeBrbRb8HrW69iFR3NOAcSStUYwtQWDkhZQL1+O+OpB6fDA8G45UYfskDcv+3UDXx/oq74kLYds+KenU5rP9jUvVgehzikXYFdAcInfEy1N/cKu/bg7aoA1aP0QZzsOo4fky56ebyP3kLhdL7Ojb+ilBvKk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=QO9S0zdX; arc=fail smtp.client-ip=40.107.117.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="QO9S0zdX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kCs3IkHnBCoH4NRtqQ1gb/CC9moTvQ0/jadpVQszsJvMDSOeY3zA6o1pc9ID8688tga9c3Z6BZXr4dMbzODlwUIaUCb1uABkWYOySDRL8gPaHTHJJQuZ71NGyza7LlfCbUs7tjs0A7gWmc1/iJdbShJA1/U1W/6yce0eIgY3cUbyeQ5KXIr+/UzCxDGAxt9HjUaMZzPrKBHrfRYByZdtNHtTJ3gHS94IVHgqNGt5CMeW/qT7awdFEqQRDYsl9M09t61c6xa7L8yTQ/aNdQM01XuFkHz7dySKiHcxxwmadwuTdNQ/PIuV/5TaLr7l96lo3xtwrpRePlxs9kzuW80RFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iiNv2W9XbSzeSiz7/G6kusLESAslGycGxBXfki72nso=;
 b=twbYF2rPybWa5z887Nqt0BAKHhQ1CVK5bdxIH24wZ319RmG0FfrvBMiyiYTtwoFbhdneepqgo81Ti82vyiHCjBa1ySe0wj8llebg4OcVnW3igMy5SXzjTogkl42OOK9mK6yDHOxK/ny4jVzUcWDOVsR2nPpiAiWLYv9EvKFR3/SoZ7NL6VjcJLsSCjSgv77QaQiM5xLHgxp2qFrqj/6CRtl76duF4vHVManGAnK8mGWfgURH4ssOafxDtyonoRecF45ou7zsRlekpyP44mkpioUIxnN7k5qRxvf9TBpn8p6ZhTFkK3HIPySnoSakfi9ZnkuhOz457/t6LqESAXbRLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iiNv2W9XbSzeSiz7/G6kusLESAslGycGxBXfki72nso=;
 b=QO9S0zdXumrvue36jJ2RQ5n8sR6Cm5UprTcEBiXYzQxZypoeOD0DDcutvkWkafopSMu6hYI2mFKW5qe3/f3iRhViezpwJ772Of23fwF0nMhYXtKO+srQKb+AO+cnD8tnJZ29Z9kX1F1D66KaANuqrzkthbchPLLavW5nN2DxPaM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by SEYPR02MB7459.apcprd02.prod.outlook.com (2603:1096:101:1df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.9; Thu, 10 Apr
 2025 08:06:15 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8632.017; Thu, 10 Apr 2025
 08:06:15 +0000
Message-ID: <a3523b3c-4c89-44c5-867e-75378ebb652a@oppo.com>
Date: Thu, 10 Apr 2025 16:06:12 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: Export __blk_flush_plug to modules
To: Christoph Hellwig <hch@infradead.org>
Cc: snitzer@kernel.org, mpatocka@redhat.com, axboe@kernel.dk,
 dm-devel@lists.linux.dev, linux-block@vger.kernel.org, guoweichao@oppo.com,
 sfr@canb.auug.org.au
References: <20250410030903.3393536-1-weilongping@oppo.com>
 <Z_d07I1b71zQYS0M@infradead.org>
From: LongPing Wei <weilongping@oppo.com>
In-Reply-To: <Z_d07I1b71zQYS0M@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0223.apcprd06.prod.outlook.com
 (2603:1096:4:68::31) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|SEYPR02MB7459:EE_
X-MS-Office365-Filtering-Correlation-Id: 950ff6fb-86ec-429a-4b9c-08dd780690d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NkhLc1BiNC9FdXFLYWc3VVViMElPYUw4K2pORDN2T3d2dDZQSWRwTW1PaE0y?=
 =?utf-8?B?QStzbEt0ckt6b0E2TytVTUtSTk11SmRJaDBtQmFsbXM2L1BxeTBCNXl6V1l4?=
 =?utf-8?B?M25rNzFaTmNqaUxOOWVRTkg2MW05SWh0c3d1cUhjSlRJMWFTV2plbUZlWnQv?=
 =?utf-8?B?MFN3cXB2Yk1pMkZxKzFnaFBGY2ZCWEgxZmNTQ2ZVVWx6MnpIQ1JCQnhOL1JE?=
 =?utf-8?B?aUhJNXBJUExrYklJTEc3Y3ZDQnBHSzZtbmZJWlg4MU1HQzNYNUROQlBENk03?=
 =?utf-8?B?ZTRyZVJteDFyWitxL1NiWnowUUxYWUpYYjAvSGNacW5CdXhla05iQm1KZTFy?=
 =?utf-8?B?NHRTN1BBRy9HTXVydnRQSXBET2VrVFZXYzEraCtUcDNqb3A2T2xDV2ZjcHBw?=
 =?utf-8?B?dEhnQVNnNDZZSG9nM2IwcUtxL2k5ZlpzRzQzdlZMbTRDcGFIYkppNHYrUlVv?=
 =?utf-8?B?WjBvRVhtOXBXNXNCazBXM1dXaDBidzFyQllONnl3MnNTWmxQOWNKWDBZeXdz?=
 =?utf-8?B?alE4cEs0aWpFeVNmbWo5OTFkQXJyTDVLWTQ4dmQwaWEyWmxIaVIrNzlqRFhv?=
 =?utf-8?B?d21PenFleHRxdXpMeVZYSmFVSWQ3ZTFFT3A1QVdETFFBOW1JT25wMFNJdnhW?=
 =?utf-8?B?L3JmMkZ4OENycTZyS2t6SEMxRFVUSXk1RUJNTVZLaWpLT1JRQkp0K2ErYzJj?=
 =?utf-8?B?d00xSFRuTCtMTEtjcTl4YjVkQ1dYeGI0NDNuV1c0b2dCbVFMR1JqMWpRSG45?=
 =?utf-8?B?clVuZEsxSk9jYzg4c2sxZGVQTmNpMDZrQ1FzRHB6elNtNTZVSTRIZ0FFaXdu?=
 =?utf-8?B?ZjVQd2IzYjVUdk1veEViT1pINEJ6eWZRR3NUU1NqdUhsS2NPQTA4ZERnbUVx?=
 =?utf-8?B?M3ozb3psWEc5akRZNVBYVFpuNkFYQ0VXSFBqaHdBNEJOK0FNb2l5UUd5cTR4?=
 =?utf-8?B?bDdOVEF4TkxxZG15VnJqOEx4eEN6QTdHbWNrUVZLSzRIRWhhUVhwaEV6Z0Ez?=
 =?utf-8?B?YnJBQi94djUzSk9MdEl2RndHRjlobUpHRXhTREJxZUdhTW5BQ0xzK09TM01l?=
 =?utf-8?B?dFBOZ1h3MEd4RStnWGxvYnoyYWgzcEtRa08rL1RkU1dEeHJCSXZ0ZlNtSHln?=
 =?utf-8?B?VWp3V1JtYm9pcUNFb3NUNTBXYUFGUUlTYXR3RVJFRTdNRHExb2tUUVVsT043?=
 =?utf-8?B?N3grN2RNblFNdDN0NHVoRDlKQlZFbGFLa2pUR0VvT3RkaVVCTDJZUUlKZDhC?=
 =?utf-8?B?ajU5YnFQMkRNWTBtUjlhd1Z4d2xQekwzNVBSa0E3bUR5UzA5NFZXckF6VEZU?=
 =?utf-8?B?a3lHaGlqc0pGSmdpemdLZG1sS1p5TWk0dm5vTW1vR3BtVURxWmU0bW05VGtV?=
 =?utf-8?B?eEpsUkFpczVtLzhhTEtiSktQMlh3WDlzak1RZVcrazBOWG0zMU01Qlp1c0xz?=
 =?utf-8?B?YVhQSlk3T3Y4bFlYMmUyU2k4MTBrbE9BS25MN3M2TWtISUEyUmw0b095VmMv?=
 =?utf-8?B?cTVXZ0ZPN3plYXJ6ME94NGJ4Uk9pUW1WdFhZMVcxUHlBYXRqUDAxeE9iV0kz?=
 =?utf-8?B?QXlwN0FURy9uRVYrUjIxUEdTR1lWVU5qTi9sM0ZiSHUyQUh4eTFmYXltQTYz?=
 =?utf-8?B?elNxNnFaNjBjcHVxWGt0Q2Q1c3ozaUhQNlhBZUVPUXNKUjhiQXQ5c2ZGaTJn?=
 =?utf-8?B?NXcrRjR4MUxnNlRLcWtNVDhQelBVRGI3ekcxbk5vb2gweVdNZnI5OVRCR2lO?=
 =?utf-8?B?dzBzODFHZkU5Tnl3akJrSUVnYUFKTFNNZHk0SnUzbWhDTlBrRUU1dFhUK0ww?=
 =?utf-8?B?N0l1dW1CYWF4bzFtUWYxQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MVJoM3ppdDQvM1Vkb0w1Ukx3UlkzSmVhdlN6REdrbDIyeFkvcWVnYjJuVXE0?=
 =?utf-8?B?aWhVVmVJL1c3d0VoaTkvYnF0QzZGTmJSUHNiN1dpK3p4cHBvUEJibEpyc2Q4?=
 =?utf-8?B?RndCTGp2emI2OUF2UGVWaHJ4eFFLcHM1SSszdmlXQXhwUXVLZ1VZVFRhb1cr?=
 =?utf-8?B?anBkMmIvdEFnNjJpa2hUWk1yYjRhdUpZaEFBU0tZVGVINEhyOW12OVZTZ1RU?=
 =?utf-8?B?Y0liSWR4RXpFc3llSUVFNk5DZ3NOaExWSlZXODJmSVI2TWlkZU5vOGFNajNS?=
 =?utf-8?B?NU9SVVhzcnU4VHRZWGNreUY4UXJTWTRiK0VkOVNFOUM1aWQvUlBPbWUzZzJI?=
 =?utf-8?B?NFVXSHBlWTEzTTc3c00wK3VxVGg4V29lQ0hMMWxhS1AwaTduczRVMlRTZjd2?=
 =?utf-8?B?dXI4MXVPR1h4RzdSOHl1NmdNTmNJcFo3MlRoakFXNGxGZXN6Y2NtaE96SDJl?=
 =?utf-8?B?SVRVc1lxMFpWZTV1STcwK1kwdkhYckduRi9hVjB3ZW85eGc0K3NndGo3YTNE?=
 =?utf-8?B?Z3RFOFNaSzFaVmNZYlY4NWVZUm1Wc0E1UXJmby9iV1lUZnc2NWxaZ3djYzlw?=
 =?utf-8?B?YW82eUFsMXJiYmRnNU1meEh3TFFXNVlsMitEVjJwSFlRSm5TNkUvc2VhQTlI?=
 =?utf-8?B?WnFLSklXSndFV2xaL0Rac3JzQzlDbGxTci9naWQ3QlZuejYwTjFQUUNwQmxl?=
 =?utf-8?B?ZlZHR0dMWW1NWWZtdGV3UGRPT0hyV3FsdGdOYitLcGpqbzZuZzZNS081c3Vv?=
 =?utf-8?B?WG5DZ2s1RlBCc0Z4WUJ4a01BekFROGh3S1pnd0xPTExyenJ2cTR4azhOUmhQ?=
 =?utf-8?B?ZDJQNGsza3JURFRFT3hRejlrWGZ3VEgvRXBFb2dSY3pSem9qbXF0eENuaStL?=
 =?utf-8?B?VDkybElUdzVpT2NhYUdOT0NWbW4vK2MwVzRNMmFHYjN4REZ5QitEalpNbkZa?=
 =?utf-8?B?RlNNYnR3dVlKbDNmSElqaksvQUxXS05zci9wVk9TY241WkRGSnNSTHFuTnpk?=
 =?utf-8?B?NXFxbk1nSDB0SCt4aVZzRGpMZ1RpTWgzRTBDcXRxWkk1L3JsNzFKSTJsQmxj?=
 =?utf-8?B?aGJHSk4yWktDajgxbUM0ZkdjOXVLVEhSUkNhbTJDOWxHdWFDNHRjQXlBOG8r?=
 =?utf-8?B?clB3OEVyTE5aVzBrRUtZOWRQR2pGQWVvYWFUeFVGV1JpeW1IMytOajYvMmMx?=
 =?utf-8?B?T3E0eWFKVDZ3Yms3WDBsRThPTGNQVUVHMm9WVkRYbDlzb29YS1JtMXlDTitU?=
 =?utf-8?B?dHM0Tnc3Y2w0cXFUL1dFeUpSb294ejFJZFMzZ1JvMUJWT0ZhZlpNL0tOTlFD?=
 =?utf-8?B?a0lSRUt0a0FlOHVZY2Z4azl3dE9OSUNkeFVRTTdJdUs5amZCQmhqTkdhaE1R?=
 =?utf-8?B?c3V0UTNDRmsyRDNSZ0dnWlJhRkxZMDQ5Z2xsNEZWVFRsNlpMd3ZVNEtJVVhj?=
 =?utf-8?B?UTVpaDV6ZnpuMUxlckg0ZkwxUXdVMDV6SUhtRkkzU1RtVXNyQVhsVVB5MitO?=
 =?utf-8?B?NmYyWDc0VWk1NW1YMGFzR0tUeHNDckp2RnA5N3RYUm1JU0ZQMS9mdmZ6K3ox?=
 =?utf-8?B?V25aVjVTbHdnTS8rWlgvTGVmbGVhcUh0OWNSNzF3YmhqM2U3NjhlWWx2TWV6?=
 =?utf-8?B?NVROZ3VJRVgyNThzdS9abVJnVm9vUkwyT2UySjZ4bFR2aDA4c2k1RUxkMGVw?=
 =?utf-8?B?MFpQNFVoZGljR2pUT0ZTdkM4bTZZS002UGcwZlBFRXBBYmxzNFVacnViVWZm?=
 =?utf-8?B?V0krcVpPMmkzQXVFTm1DZVJHQUp2Z0pqRG1mYXBoTXYyb0tELzRheElRZE9U?=
 =?utf-8?B?Rmw3R1djT2wrUE84YmZMbXlPbjVTOWp2a3RxY3d4Rm13c2VCRC9ZRFp3aHVW?=
 =?utf-8?B?NUk3QmtQWG5zdW1qZEwvOVhnQjZIR3pQMEZreXg1enM2RnE4OVNNVTc3U3A4?=
 =?utf-8?B?bU1Mc3l3dEd4K0tIQWRIV1pHKzBnbGowLzhRNUEyREhOZnF1alJ2QnJjMWg0?=
 =?utf-8?B?SG1nZHhpbXpRNVJRc3JwUHhHbnhLbG5FNEpCM0tGanZudkVKeUZNZDNBQTNS?=
 =?utf-8?B?czhsaFNnN1ZvYXpDUzBiODA3NjhmVDRaWVY2ZHhQLzRnbnVRakVLUkc3eE1B?=
 =?utf-8?Q?oXArFn9sDAFAZWahWzbcLLvbG?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 950ff6fb-86ec-429a-4b9c-08dd780690d2
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 08:06:15.4166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 54lrscUkRe8wRJQPusOKbq/zyqgtLCI0NzXPDTiA3ef8KFlsIf2JjLBs5qYrtBd36y7dHRYWxkuy+GPjMV3pnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR02MB7459

On 2025/4/10 15:36, Christoph Hellwig wrote:
> On Thu, Apr 10, 2025 at 11:09:04AM +0800, LongPing Wei wrote:
>> Fix the compile error when dm-bufio is built as a module.
>>
>> 1. dm-bufio module use blk_flush_plug();
>> 2. blk_flush_plug is an inline function and it calls __blk_flush_plug.
> 
> Then don't call blk_flush_plug from dm-bufio, as drivers should not
> micro-manage plug flushing.
> 
> Note that at least in current upstream and linux-next dm-bufio does
> not actually call blk_flush_plug, so I'm not sure where your
> report comes from.
> 
Hi, Christoph

Stephen reported that a compile error happened when he tried merging
device-mapper tree.

> Hi all,
> 
> After merging the device-mapper tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> ERROR: modpost: "__blk_flush_plug" [drivers/md/dm-bufio.ko] undefined!
> 
> Caused by commit
> 
>   713ff5c782f5 ("dm-bufio: improve the performance of __dm_bufio_prefetch")
> 
> I have used the device-mapper tree from next-20250409 for today.


More details are here.

https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=713ff5c782f5a497bd0e93ca19607daf5bf34005

https://lore.kernel.org/dm-devel/66bf8a8e-0a7d-47b8-9676-dc2e8c596bdb@oppo.com/T/#t

Thanks

LongPing
