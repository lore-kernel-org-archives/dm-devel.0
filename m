Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11020124.outbound.protection.outlook.com [52.101.69.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DBB47208C
	for <dm-devel@lists.linux.dev>; Thu, 10 Sep 2026 11:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789039605; cv=fail; b=cvEVhT5ZP1m1Lwb76dWwHfSD8wM8AnzogZuR5Nz4uVwyaeSg/X3QUvWq/dWwN5vzS3GbKiyVOI7Yrbxm7DP2MZWYMqdNFZ2AsKg5aUce55+DZubpLJtm3iuVYpxMV5cV1P9I4Fna6pmxrvspDdaLqHBby0pnmyeS+jF5OhScDRQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789039605; c=relaxed/simple;
	bh=QhZbuDvy6/whI9EPX8KAkuaDZnAson3Sl1PUzKl0zsg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mjluKAUl0xVAJ7YLW4FfzMUK3Guls7sHKC5dd97Tso6VyvAFfLhBH3zaOLkEGZpev6C1LD3kvqnCKF67Gxd85p322+psBkOeb1WdmLT2zD1Oyxsl4PM8zpqGlwj7eIWuHQdoAJgUSdO+VYiStAMWllYhqmJJlDiswjlm7DDYEhg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kuleuven.be; spf=pass smtp.mailfrom=kuleuven.be; dkim=pass (1024-bit key) header.d=kuleuven.be header.i=@kuleuven.be header.b=pKgZZ0Af; arc=fail smtp.client-ip=52.101.69.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kuleuven.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kuleuven.be
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kuleuven.be header.i=@kuleuven.be header.b="pKgZZ0Af"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=byNVGNh2F9aP3hHou0+M7iE05v4NlgD5k7B0Ol7FNzEgdTeNcGUtq5o1zEboDTF5WrgJZX0BafBO8KZ3IhJaP7SViREC2TynBZUymguPSXzRKjNIf7lIEr8FrVq9Ll+G6sh6t8/WpLlW+McJUFPEBLD/Op5ezsQxJ8hxZB3MrXncqCLeOIIq4ql5f6XGd5D+qOksfrexpXrRmhnMOwFrnMtofq+oW2TRF1eiTyUO35c8HZwjr1OZI0HpZK9zZiqv+YFukiBOXQd1SqsveAeeYXZ6XOoETpvq11itwEpik6B4P/jrdpKEiDS+Zv9dLEHbjCxv+9GR2XDLJCQVatG5zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sl40GcUiFK5s/Bca27FDFFh6CJLtgVc1aX+rj0PaH0c=;
 b=OfOk0e2T1aLOlYfnB+1xlc0KXoyZS7Gxh6xEvJh1tSnBdHWJv2cC+fIja7oUs6JamshmNKgPeheybnXEb3hIm5DwClL2SfL+ZpXnl9Iy0jo3Dl6/lqfbs9NYoQM1V3if8ZW4OMhrQnf2zrppwVlYwAFTboTv9gsV0vSF4Y9Z5ttpneEmCLqfHzHzmHUgAGqYI4j3I3VrnCaq8KImmtwCw6/CtyhJxXQ+0odCE6L3NmKRFbcltdkRAo0xvZKMrZw2xmV8/tP5qhySzs/0bKOmGPiqbvgfzNpkU736cfUaXb9+IVbyjsGXyiU7DuC/jtj8E4V49g/dPGH8LquSzx73EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kuleuven.be; dmarc=pass action=none header.from=kuleuven.be;
 dkim=pass header.d=kuleuven.be; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kuleuven.be;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sl40GcUiFK5s/Bca27FDFFh6CJLtgVc1aX+rj0PaH0c=;
 b=pKgZZ0AfRQHuWC7VGsnQQnwwhDuIzoP83yI0PxJn6im28+27JZTbOYz4YExKT6egMBMlt3FUbgGisQg1B98rflBrRlw89aV5MMR1aTcGyWRABvXn4OdXUDU0dwiR8QjxCUnWUC4kxB1Ydjt+p5spVWkpZnq1ITJWgvgiwcXg1RA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kuleuven.be;
Received: from AS8PR08MB8996.eurprd08.prod.outlook.com (2603:10a6:20b:5b1::13)
 by AS8PR08MB9019.eurprd08.prod.outlook.com (2603:10a6:20b:5c1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Thu, 10 Sep
 2026 11:26:31 +0000
Received: from AS8PR08MB8996.eurprd08.prod.outlook.com
 ([fe80::ee9d:8228:404b:262c]) by AS8PR08MB8996.eurprd08.prod.outlook.com
 ([fe80::ee9d:8228:404b:262c%4]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 11:26:31 +0000
Message-ID: <125229be-6fcc-4a4a-923f-1765cf03e29f@kuleuven.be>
Date: Thu, 10 Sep 2026 13:26:30 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] dm-integrity: fix infinite loop on discard with large
 tag size
To: jo.vanbulck@cs.kuleuven.be, Ben Cressey <ben@cressey.dev>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org,
 "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
References: <20260820-dm-integrity-discard-v1-0-196d3618d09a@cressey.dev>
 <20260820-dm-integrity-discard-v1-2-196d3618d09a@cressey.dev>
 <35bdf3a1-9e85-45d3-8af8-f324cc455144@cs.kuleuven.be>
Content-Language: en-US
From: Shukai Ni <shukai.ni@kuleuven.be>
Autocrypt: addr=shukai.ni@kuleuven.be; keydata=
 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
 qQzAq6/nlHM/bMUHgzNXNIMB
In-Reply-To: <35bdf3a1-9e85-45d3-8af8-f324cc455144@cs.kuleuven.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0400.eurprd06.prod.outlook.com
 (2603:10a6:20b:461::29) To AS8PR08MB8996.eurprd08.prod.outlook.com
 (2603:10a6:20b:5b1::13)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR08MB8996:EE_|AS8PR08MB9019:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b2e2c18-1ef4-4a68-7b6d-08df0f2e5d21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|786006|366016|1800799024|23010399003|376014|7416014|10067099003|56012099006|18002099003|22082099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	Pq0XqHHlaFmQDhG7Vx3kBWauSZmZYzmRsS2ZtuX2lUkc+0y9SKDJXryP1n7WtevaTADXx3a2Hftmg4YuWw7wd8Nkt+sJaVW2dFV/dFriZLIjYribA+ZNtQeE+DA6CqYjNi9raSP9MEsSs90GFZtLyixjqI12FbLKsIqwcl8Cjuh+c9TJdeYw+zn1mj0ghHIAznD5YOXmAOLLzH4cCvVFXS0bhv0zJISS1MPSK1AlBByHyjeHu2OheNvpwGijJujI3v38cz6CAVn581RmlDmW9qJiNq9lhBw8W0WTJKvKkC+0mbD8AaqbOsLggUMkZ5vdZVabnVFKsw8BYdAVy6oqM+kXG5skhwt/qp3DdP92yXnjdXh8k8obE4+/zhkX3yQ10YwR3SzAgV7br51Xvw7+Nx3BqRvINtyxYeIKlu/rUlJDAQf0gYFvvJW1RXqA3IqGAOVoC4oLX4/lCcU3VoYmfVjYdH11dLQDOhWFLztSqS0Bkq37pKdQRWY5FqdKj2acc6DAuvOG4C/aQasRgQJXaIgwyHnVNE8pAi8UKvGhYtEVDurbF+CbjQnI9Y4ZG9eg+CXhxHVl/iSm+3lfC41xOvm5R5W2i/GcgwL+3SLf7z4gamKQ42/cUiIklbvlfWyIdF+tXYEPJqDhywW8xYkj4eiiOMH67A9mCrPAjWVUltA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB8996.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(786006)(366016)(1800799024)(23010399003)(376014)(7416014)(10067099003)(56012099006)(18002099003)(22082099003)(11063799006)(4143699003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q09pREtkN05nektxNzlrZFhpQU1LUmRsd21kNHk4cXQwcTdCU2NYVHhKa29z?=
 =?utf-8?B?MHd5VlV5TkwwTUYvM3FvQUl5L09QQXBHL3NMampvWVNFdkRtOGdPeXJlbjY1?=
 =?utf-8?B?ZGJ0VHQ4NkNzd0xYOGVWOHRJRmkvZVE4aWcxQUIyei91dGdhU2xEMkhCZmxw?=
 =?utf-8?B?cndpNU4wMnZMS01sV1FIaUFDWGZvdHNlY1RiOU0vUWI5YWZiaGkzT2YwK3BH?=
 =?utf-8?B?TnA1ZFdXN0NqNU5IbUQ3MkVDS3hWN1R6b0xOS3hwYzhzSFBzRGpxZy9PUnd4?=
 =?utf-8?B?eFROb2xDdkQ0c3NqY3FIcWRlWWVOM2JGYnVYZzdYM0lnb2ZacVdnWU1Od2M1?=
 =?utf-8?B?VEpJaWFWTVVnd3gzNHBya0poamJjRVpyTldiMkdUN3VMRzUrcDh0K2dJMEJx?=
 =?utf-8?B?L0FlZmZDSG1jdnFralRqVUdJSWJMeWVTTzV3ZDQwRmFNeC9UTUFBbGttUVh5?=
 =?utf-8?B?Z1FJc2ovOTZscjk1bDYzNjVOSEtXUWpKQnVFTllScjRVM3dLcEMybjZnRnd0?=
 =?utf-8?B?MEdpS1dkWmhld3EwWDFZdFFVSHhwRTNxUDlxYThXWVNXRFRRVzZTbFRaUTFr?=
 =?utf-8?B?TENUQ3kzSWNDc295Mm41VGt0WkdmcGpBNVh3S1E5SVM5anVGeWJ0cm5PS2tM?=
 =?utf-8?B?MXEvODdndG5hQ25JSlhJdWNQUVpQNFB2aXVVakwrMHVTTFhLS3RMRWFPUVhC?=
 =?utf-8?B?eGJrTC9LZnlrdjRMaEs2YzdtNFNQbHJseUM4MWdzR215ZURNMk1ORVUwTTlk?=
 =?utf-8?B?djJHdnN5N3hWNng5a25USjd2b0lDZHlkVmtjWk5GQ3JGaFJSZ2hSeWxlQUV6?=
 =?utf-8?B?U3RxZTB4dlYvc3g1QklzOEV4MWVpWlprNnkySWh3S2pzaVE1RXROSktrdVBT?=
 =?utf-8?B?QVMyNVdBVzhCQVZSMkR0UzFrQm04ME5qRlNwZzZJT0FPR255STNaYXBpbjVi?=
 =?utf-8?B?NUg5R3Rockx0dlJzREVSL3FDY3Y4S1NwL3hzdTRWT2crWFk3TkhqdXNJT0hV?=
 =?utf-8?B?RzEvNVJpYjJqeHhxWUszWThwTGY3VXNLanczNnRFbHBVaFZ0ODcyb2hISnAz?=
 =?utf-8?B?dDdMWGp4K0tzekpkSXhHQlJ4Y2dVUG1KbHYzQ3hHSno0OU1CbkV0UDJvV2hK?=
 =?utf-8?B?TGlwM0pRWm8xdSsra1NvNWpZd0N6eEprTnpmYjRod0VtUEpKaW1TRzY2MmNp?=
 =?utf-8?B?WHdiWFBucW95T2VLRnhmaUQ2d0xvL2VWRFBKY0RLcGtZeFk2bzE0ZFlyN2VZ?=
 =?utf-8?B?RTNvbVZaQTUxOTZWMi9SWXVvMU1ySWlveXRrNlVESXZUdTN4UFBlOC96Q2tj?=
 =?utf-8?B?MG1VR255eitIeFJYTUNNVWRTaGZXb3RYajhOU1BTcUtaMGttNlJkSlpEK3do?=
 =?utf-8?B?VGlyQWNpd3pEU3RuVzdlRHZubzNHaDA1SzMzTlJsbHpiazZVRzBQVjUrcTlS?=
 =?utf-8?B?c2lOelVwVzZLbWVWQXBucTFBL2EvcWNhWFppdTU2VHIyNE85dDliVng2ZEFa?=
 =?utf-8?B?NXU5RW5LNExhMFBQTHhSbTFkUUV0VjZKakV0QVBybloveUNNcDBlUkdZdG5i?=
 =?utf-8?B?aVJsVzJYT2tkTjVNam02K0d5VDJEaGhTWmVtakd0dm9EMVA0TXg5eE5Yb0cv?=
 =?utf-8?B?R2RKNDhxZllWdldHUm0zdnhUdWxCMEo4K0Q1dGZyQWVzVTFMUVJoRHJWZ0VJ?=
 =?utf-8?B?TmtaUXFkRlhjVGwyaEx1R0tHNjEyTDU2RFk4alhCUkZRb1U2OUQ5UWI2NVRO?=
 =?utf-8?B?a0hzMzhEb3JZUlEvQVNvNzZDcDZZcGRSc2puWTgyRGtJa1h2T21UR1NuZ2xo?=
 =?utf-8?B?M2xmZ3grTHRjbWZxVkFEcURSQnpEeGhEb1RFUmE3WlRCVjhCTy8rUjVBTTdI?=
 =?utf-8?B?blVtd0xoSklLRm81QVR5ZGhxYVVoekZ0WHVxSFYxTEVVOWlxL3JtS3dLeGNh?=
 =?utf-8?B?aDh6clF4eFhjeEZ3MEJrV0ZoaUs5K2pJbWFTOHM2TWpQTUpMOVZ6M0MyU2Uv?=
 =?utf-8?B?elpDSDFwdnhZSHFRN0VzQnFRMXE3dzZZRStpNFk1NkpJMm9EeGF3Zm1aOGxI?=
 =?utf-8?B?d05PT2N6RUx3V3RIcWZpZXczUWpFK003MC84SW5KZzR6dnl0RmFUUDRMR01q?=
 =?utf-8?B?ZVdQTU83UjlwZ001Y0U3T0JLeHRXQy8vaittUFBxeVRJUm15MnF3ZnJUbXV5?=
 =?utf-8?B?c2xxYzczei9IZ2VZd0NqQTVZUk02eE1ZS2lTbENPUm5aaFZIUE0rVmJBQkVQ?=
 =?utf-8?B?b3hqR29Ub1J6M2VyM2dPeTdFdFp5a0s5aWpWNTIwaXdRSjZtTEVaQ2ZEbnRs?=
 =?utf-8?B?c2F1YTljRlNjRG9uZlFDQjBDdmlQS2RlcVFvSGhLa1dtNWZjWEtnZ0VEUjMr?=
 =?utf-8?Q?EpD7evLalMHfmjq/jdQe5+VHbSltmrvryX8yo?=
X-OriginatorOrg: kuleuven.be
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b2e2c18-1ef4-4a68-7b6d-08df0f2e5d21
X-MS-Exchange-CrossTenant-AuthSource: AS8PR08MB8996.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 11:26:31.7242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3973589b-9e40-4eb5-800e-b0b6383d1621
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IgAoiChncD4z2GbAodehLD4KEAxOFkBBSnJHScf8z4E2/hatv/k9ZuWx1by2n8ZZbe9IXaROC5wMix2/jCjR2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9019

Hi Mikulas,


On 8/20/26 23:44, Ben Cressey wrote:
>> When integrity_metadata handles a discard, it fills a buffer with
>> DISCARD_FILLER and writes it over the tags, max_blocks blocks at a
>> time. If the kmalloc fails, the buffer is the on-stack array> 
>> checksums_onstack and max_size is set to HASH_MAX_DIGESTSIZE. So if the
>> tag size is larger than HASH_MAX_DIGESTSIZE, max_blocks is zero, bi_size
>> is never decremented and the loop never terminates.

Following up on this explicitly in case it got lost in the noise.
Jo and I reviewed 1/2 and the one-line fix is correct.

2/2 is independent of our change (on-stack fallback with tag_size >
HASH_MAX_DIGESTSIZE) and also looks right to us.

Reviewed-by: Shukai Ni <shukai.ni@kuleuven.be>
Reviewed-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
