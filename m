Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2085.outbound.protection.outlook.com [40.107.117.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DDDC2C8
	for <dm-devel@lists.linux.dev>; Thu, 27 Mar 2025 00:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743036777; cv=fail; b=UGpUYVVUQT5IphbVlT88ekd4KZiIaw8/6yXmxIeiTjZQeX9xVCM2O/hjNR80fhUllDXzBJPyD50wWZyRPVa1zK3beqkUcAOirsTvaynHwAhNxRuOGR7ZKNrAN6f/G3uT5fN02Lj/aaAlp5jnAGczFJ5KXD8DFDwSXsO/5y316yg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743036777; c=relaxed/simple;
	bh=VDcN3W2yNXuhYBhyGIP/CEjJdIK+fuDaiN5xfl0p1y4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TX4Y4iVESJ7eVL5roJ/uYyPh0DYRHZFKPAvI5TM+pabg+oJa0Rbuc0cwU11IvLAWVU9y4Lmaa9/zn3BaR+s8nuqMIvHI9juV4KnqBpx3e+UtBdkg94j5QGPCX7htPFvmbSo1Oln/UrFDzrQbsxjvYMtfluUmE3Y6dGOBUKAvV6Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=kQsp6zaT; arc=fail smtp.client-ip=40.107.117.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="kQsp6zaT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SBx4x0SOSkSH2Vq+34pzxaPy1pzEp3U0lSX4EimMxB+kSczUcgOOFO4RNjErcipM/WFaSIy6y2dxJTNSeRp8XSGDY0Em8UTABT5NPtqPO1M0aUE2ppWrBq/v1h9oOJylxN5Jx/9LMNRE5X3kTrMjGJeFbcahvJFdRb3UkokmJZSs0wDyEUksDmmeb0ZYRPxDEX0fifQlMT1r6/DcN1nR6+/z0gV9qKbhonGN4HdAyvhuQpHnkEmxYpYSz2nhF1s9XD0MyFFd7PFh7cWVxe1+WPMIosGMd5dz5elW58mbCp2+zKW+7EKN1tU6sJoTtYqckwR+1K3Edq6ymNqmzgebYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CzPIkF+JwDos5uTY3Aw2qtFKdBDn4ax+JhlOsgbTtps=;
 b=JLh3GLhSpCQhHiATHnR6OcjrB7Lrta1ExMp4eWFGdfP0pwtymql5MzGiBWZ4Inp/ueTK7wg1cgUrGUSmhwmZxxCuxWGHZTPBCAzjxD+4CGtdnExv6D77+GzWj4rUvI6MIhbvF6BEDwpz91BjIafp8mYmRjRF32vxkSn+kPYQPpcLLGmwrUD7ofNEo+d0tuY8o4/DmEh+WtZQeLBFJJZ25DXa3HehkTew7+R9oxRoK2juB2lmuI6tD8MzxDWam2Ia2+0KvaYBgsoFqcu/Le5yBMzd6C1l+VDKm38oTt5AFk+M0/fM51eCdZdYsvqmez9pW8Ph0nn5kEU4EpE3C3jtDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CzPIkF+JwDos5uTY3Aw2qtFKdBDn4ax+JhlOsgbTtps=;
 b=kQsp6zaT5ZT7xlbY2tDVPppTL0mkBaZ78ykrnj78T/WskZvouCwgG2QQAJLYy6NSo/ikr3ChaZuNtI8SmDh/9ZV68xCkf5M+nqjyMp0+WXnfsdccIoYbEmCI6T3mCe8a9i6WZtQNRpnP21nqdZk1yLXMZAytE4QuRhC2l3dsYkk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by SEYPR02MB7485.apcprd02.prod.outlook.com (2603:1096:101:1d4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.25; Thu, 27 Mar
 2025 00:52:51 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8583.023; Thu, 27 Mar 2025
 00:52:51 +0000
Message-ID: <dd421003-2d7f-4d35-aa77-12d319454160@oppo.com>
Date: Thu, 27 Mar 2025 08:52:45 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] dm-verity: support block number limits for different
 ioprio classes
To: Eric Biggers <ebiggers@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
Cc: agk@redhat.com, dm-devel@lists.linux.dev, guoweichao@oppo.com,
 snitzer@kernel.org, Bart Van Assche <bvanassche@acm.org>
References: <50200020-3c4f-0667-1697-7c2ff62133b2@redhat.com>
 <20250326013049.1292617-1-weilongping@oppo.com>
 <93b863a6-24f3-2281-c9a7-c3e59b2a6ec2@redhat.com>
 <431f8798-e0e5-362c-bf6b-fb6cddadd4b2@oppo.com>
 <20250326165336.GB1243@sol.localdomain>
 <052d22b6-2d49-7faf-49f3-742c9b79fc8e@redhat.com>
 <20250326204845.GB6625@sol.localdomain>
From: LongPing Wei <weilongping@oppo.com>
In-Reply-To: <20250326204845.GB6625@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0245.apcprd06.prod.outlook.com
 (2603:1096:4:ac::29) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|SEYPR02MB7485:EE_
X-MS-Office365-Filtering-Correlation-Id: 5849cf53-9264-410d-1ad5-08dd6cc9b309
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L3hsWVJQcFR5c2FwNEJ1Q1U4WUdZQzZDOG9Vb25vY1F2b0hHcEhnNHA0d3ND?=
 =?utf-8?B?d0FBTHFnSlFFZkxwVDBHVlVFWWR3Ykl2ZkN3SURjaU9QSTlwbm91L0MyOWtu?=
 =?utf-8?B?ek1VZEsyRWZuRGJHVkUzS2luYTlGMUFGSXNWMitQQUZCWktVOVF6TGpXYlA5?=
 =?utf-8?B?elNQV3ZjOCtvcUFXakVGZEVERDIvWDdCWUl3NFh0eU5QOVNWNU14VEdvYW95?=
 =?utf-8?B?VC9yRlY4VzRXeksyelJsK1FRdndtWisrWUV6dFFaTFRzQTN1MlJhSFViamZJ?=
 =?utf-8?B?VldLUkF2QTlDRnRZdmxHa28xY0xJYmM2ZHhGcGVoOThqdWd5V0RnNEJLR1Rs?=
 =?utf-8?B?YlgrdXNMVGsyN0VoS3hUS254cXNDZWlKUFFBamd6NGpuVVJCV0xxbStCdnZM?=
 =?utf-8?B?VU5NY1JjTUJwZkxJT2JlZHArcDh1aXhlVkY0bHV3bzF3dHl0VHZoaGJZTExo?=
 =?utf-8?B?M2RQdEVUQytoR1gzd3lhVHNMSXczb1psOHVsT2N5RFQ2WG8yYkdQZ3ZnQ0wv?=
 =?utf-8?B?L3ZrMWl6c3lWTjZENUtKTzVUSVVhcXZ0a1h0Qm80RUVZMFVidVhLa20xOUV4?=
 =?utf-8?B?d3VaY1dmNnN4MHJmYjgrdXZPaTI5TE5WUmhxbjdRMXlNUnNBMnlPS0ZORXpu?=
 =?utf-8?B?RkFaMkJzQ3FFOHQrR0w3VVdNSjBtWlZDN0pQdU54TWdtYWFKL2pObUxoWURz?=
 =?utf-8?B?Tjl3UHI1S0NZbXp1SFcxY3NZWlk1cWlTY1dIRXdOM09neXZVdGowenZweG5F?=
 =?utf-8?B?NGlMWDVLS0FYRVNkVlZEZGp3Vml1TllIRjNweXBoTDh2TTd5ajFEQ2Y4MFlR?=
 =?utf-8?B?TVpGZTBuNDQrYVoxczhJRTVvN0pqQXVMOUwxaVlLRVZDcnFXcVZKWWY5anlp?=
 =?utf-8?B?QzBBRHc3em1FZDJ3N1hVV3h1dlRHdVdNdEJDOUZ1dE5yWGIyazZDdjNXcG5O?=
 =?utf-8?B?K2hOV0tuQWtyaUNIc3dqeXErWW94SDN2bEdBQWtPbjcreDJNaVdqZlcwUEZr?=
 =?utf-8?B?WWlMMXVyNzgyODJrYzUzODBsQzRkaERrVml6RFp6NnErek1ZWmFGeG55T2pl?=
 =?utf-8?B?VGM5QnBCQUR1ckxDRXMveHl0TjQyRmh3eTZPb1Qyc2lNbHZLb0s1czhyY1Rs?=
 =?utf-8?B?UlE1eXNaWnZsRlpvdkRNQUIxMUp6MU9QcHl2VVJVVmN5Rk1UUHBpTzZLYmxv?=
 =?utf-8?B?VTJDRlFWU0d5d25pMHlmcE1jZkFYR2JVL3pzNGRuYTEzeEFLNFJRMDFGS0xt?=
 =?utf-8?B?VXFzcXByYzlGcEVxOFBJN2pmS2ZTb3M3S2xvLy9JZE1QWlV0MFJTcHROQ3Vk?=
 =?utf-8?B?czdQbDFORmhsZ2lUU3o0cXZ0RE5vZ1ozUmJ5T1JwZkdoOU5xRkM0YXkrKy9T?=
 =?utf-8?B?d1BzYWR2dElqT3JYK204Z3hqWHdDNmt0QW5Ld1p4Q3loVVY1eUZZVnEzbVJF?=
 =?utf-8?B?WFNNd1lPRDZRUi9ab0ZRbkZWTGFnQTRvWUZNYkg2THo0UTFxOU10VU56RXox?=
 =?utf-8?B?dDVsZEdZYkt0V29lYjh4dUl6Wnc1MVlTME5LOWcwSUVMcmxJbzlHOUJnckJ5?=
 =?utf-8?B?LzB2Wk01cHowaUJqbDBzK3ZuS2N0RFNPbms3RUYxSWR4aUNFYW9TWDhsOVhu?=
 =?utf-8?B?V1cxTUc3RGw1LzFoRWhzbUhtOThGdWN5QTUzZFlIZjhnUjhTYjQ1ZW9ZOUZu?=
 =?utf-8?B?YVBEcS9DNG9aUHQvdWFYN2VqeVFWZ1YzUktyUmhraytORnpuZGxiSDBYdFNy?=
 =?utf-8?B?RUdqWnhEZ0MxRlpkNEFWd25yUnVBcnp2ekJKYW5lRW9mWXVJckFYUlZFM2FR?=
 =?utf-8?B?bVlOR21sejRLQk9iRUZyeUtzTEhkS3lRVkhnYkppWkhCRFlkKzRyaHZrb29h?=
 =?utf-8?Q?OKiObyJGbEKH9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N2wzVThDaHAyazJuNnpsekc0dTVRMVVuYmxwbzBvUHFXejM0blJBM3dnM01O?=
 =?utf-8?B?SW9wMnpYWXBlR2t3MjA4YW9OeEJGZXYvNURIS3RIZ0MvbFFYSW9JK0lublR0?=
 =?utf-8?B?eFJxN2tNNysrOUw4Yjduc2EwbENGN2VCSTc3SFR2bGQwcXRlRHFyNFd4Qmwx?=
 =?utf-8?B?REgxQ3laWmgrN2ZRSFlNc3c1N2NVSVNjTHdabGpqYkRDTllZbzBqWXFlaHV5?=
 =?utf-8?B?RTNWMGRHemZ3R2ZzL1FPVmk3dWM3V0gyWnJOeE1uTDhQanBnRnJhZU9HNEdR?=
 =?utf-8?B?djljMmF6ZTFRS0V6OW1BbDYybWhDWUNQMmsya1FkNDdmMUhhekpoc1JhSnNR?=
 =?utf-8?B?L1VsQVVCaEw1QmN6VlJsazZFeHRXcHBnaHlCL1FJODRYM01LYkw5ZEd4RENm?=
 =?utf-8?B?RDd4RGhGcUJFcFdOQ0pqZGxjbU1lWWh4VEVJZmQ5dXJFa0RNdHBXd20rWlZE?=
 =?utf-8?B?OGRQUmcvOW1qSk1jamNMVGxManB4aDU0SFJsQXBsZ2tSRm5KTktZQThhcWxa?=
 =?utf-8?B?TVRpY0w1ZTN1YUE0R0taeGhGc0FjZVZETzdCcTh2aU5Uck5PcGw2Q1BTOUZu?=
 =?utf-8?B?Tld6aXBQQzV0TG55MTlrRjVVQlpBbktVckw0SC9pUDhiMkhoZnhBZkoyQi9N?=
 =?utf-8?B?OHAwTm1xOWVWL1Q3NCtlbk14TmpybDVDRThidlRNVG8xZUREaEdsbzJXQnBN?=
 =?utf-8?B?WUJ1dkNZbExRRmpmSzFPYllsK3hPUkFUS1RvcTNqZ3ppc1k3dU5sQjEzQnZF?=
 =?utf-8?B?anhsNFNYUDhoM3B1RzVkY0VsbklxU0hDMDNwT1Iwc3NHdUttOTUveE5LNko3?=
 =?utf-8?B?SG9jMzQxNktjOUpzaEhhVmVtdTVGTmYrZ0lDeDBEUjlkLzNwWU80OXZjeVhs?=
 =?utf-8?B?c3pBK1lVdHdiWXY1Q0wvcHhuN0F4bTA1bGpJT0JSMGtUQTFXZlFpSXZUUHpm?=
 =?utf-8?B?UHBRSlc1Q0wvaVd6b2V0cEUrN1FEZFVIa2xLNUFyNUVrd1RxRHZZU1JpWFBF?=
 =?utf-8?B?ZE1yZkZUV1RrQThLZ2hlbTREeWtqYk0vZzQ2cWFKcnptNU9Ick5hNlpFUjUz?=
 =?utf-8?B?ZHUrcERkVU9NSVd6RXFnS1dGc3JHZEJVSW5FSFZyKzlQV3h6cFl0TmswMEJ1?=
 =?utf-8?B?blJEMll5MHJpdlJQOGxKV1dNK1lnaFY3UG9Xdkh1dXFxeUtiK083eW9uOCtu?=
 =?utf-8?B?cmx4VnB4MCtEL1hDZTE0VnNwUGtlUElBNzBXcGxKL3lkb3dDTjdYZUFJVHJt?=
 =?utf-8?B?M0xwNWV4NXBqbGVvQXd4TXAxRlZWNmpZRTZBK0lSMmNJYUNLd055VWNzZUpF?=
 =?utf-8?B?ZFkxQVZSMmQzM1IrUW83M05nTE9RdER4aU1nQ2xCdHB0NUQ5RlE5UTFRMGpV?=
 =?utf-8?B?dDVqU3lic240WGVjaENUeFhxdm4ya1dQb3BlSmNIVlVMN3VqbTlLSUoreDRx?=
 =?utf-8?B?bld5cWNGYWhxUlNPZ0UzbFVnM0lDekxHMEtRcVkxUzE3c0x2TWRCK2RyQjBR?=
 =?utf-8?B?L3VOOGRtcDZSUEJVTnVpd0hnSTRMQ0JKQzBncktNOG9Qczh4NS9kcmRManZy?=
 =?utf-8?B?dnF3eExReXhXVUluTFF2NzFZN3dUZWpoMHhTQS9FVU02UVZ1MHUyTXpxK2tU?=
 =?utf-8?B?WWJzRWwvTTc4dk04cXdzdFFIQndRRFdFd1VaQVg2MlNpdHA5WC9SR2c2Ulc2?=
 =?utf-8?B?dkUwdW56bnNtQlhOaUVnN0pCZ1VYTVFtOURQVmRxc3NUbTdFM0pVcXpmRnE3?=
 =?utf-8?B?VklTQlhHSjlHNisrVkVFMFJhYmIzTzA1MWdGNVhEaktWVnJiRVgzRUNUNStR?=
 =?utf-8?B?dUd5a1E4S1VqaEd1d3BLQVpMeHp6clhCSk5LWk9LWnhlSG1ERDU4NjJVL1pp?=
 =?utf-8?B?USt3OXM2U0c1UGtuZHF2NU90RGRxZ2xDNWJ6MWpDb1FQckR4cEkrZi9tUnpZ?=
 =?utf-8?B?dkhvU1Z6a2F4bGZaa2dzWVFWQ0I3NlFMUzJ2bHFZM3I0a09qMXBwZ1FROW82?=
 =?utf-8?B?eXN3L0JuSEVLeURZa1VtSU1KbFFiOEpGRmdHWXlNSHlmMHJNTnR4cnhMOHIy?=
 =?utf-8?B?aFB6SG9yY25VVTJlYlAwcHZOR053a3QvdndyeUFYTnlvZXMyM1J2VnVzejl2?=
 =?utf-8?Q?WUBcnkXp4kVgimxFUBxHfvyzj?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5849cf53-9264-410d-1ad5-08dd6cc9b309
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2025 00:52:50.6784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oZgpsafyPsYzbBwvoyRxNbWQrwyK6tJ0QhgocCSWIUVNeQMbav+A4FcjInxuFemhn5t14g+HFHEDjc2+2VlXMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR02MB7485

On 2025/3/27 4:48, Eric Biggers wrote:
> On Wed, Mar 26, 2025 at 07:50:34PM +0100, Mikulas Patocka wrote:
>>
>>
>> On Wed, 26 Mar 2025, Eric Biggers wrote:
>>
>>> On Wed, Mar 26, 2025 at 09:32:27PM +0800, LongPing Wei wrote:
>>>> On 2025/3/26 19:04, Mikulas Patocka wrote:
>>>>>
>>>>>
>>>>> On Wed, 26 Mar 2025, LongPing Wei wrote:
>>>>>
>>>>>> Calling verity_verify_io in bh for IO of all sizes is not suitable for
>>>>>> embedded devices. From our tests, it can improve the performance of 4K
>>>>>> synchronise random reads.
>>>>>> For example:
>>>>>> ./fio --name=rand_read --ioengine=psync --rw=randread --bs=4K \
>>>>>>    --direct=1 --numjobs=8 --runtime=60 --time_based --group_reporting \
>>>>>>    --filename=/dev/block/mapper/xx-verity
>>>>>>
>>>>>> But it will degrade the performance of 512K synchronise sequential reads
>>>>>> on our devices.
>>>>>> For example:
>>>>>> ./fio --name=read --ioengine=psync --rw=read --bs=512K --direct=1 \
>>>>>>    --numjobs=8 --runtime=60 --time_based --group_reporting \
>>>>>>    --filename=/dev/block/mapper/xx-verity
>>>>>>
>>>>>> A parameter array is introduced by this change. And users can modify the
>>>>>> default config by /sys/module/dm_verity/parameters/use_bh_bytes.
>>>>>>
>>>>>> The default limits for NONE/RT/BE/IDLE is set to 4096.
>>>>>>
>>>>>> Call verity_verify_io directly when verity_end_io is in softirq.
>>>>>>
>>>>>> Signed-off-by: LongPing Wei <weilongping@oppo.com>
>>>>>
>>>>> Are you sure that 4096 bytes is the correct threshold?
>>>>>
>>>>> I suggest that you run the benchmarks for 4k, 8k, 16k, 32k, 64k, 128k,
>>>>> 256k, 512k and set the default threshold to the largest value where bh
>>>>> code performs better than non-bh code.
>>>>>
>>>>> Mikulas
>>>>>
>>>
>>> 4096 bytes sounds good to me.  As I mentioned elsewhere in the thread
>>> (https://lore.kernel.org/dm-devel/20250326164057.GA1243@sol.localdomain/),
>>> objections keep getting raised to doing more work in softirq context due to
>>> potential impact on real-time tasks.  So while more I/O benchmarks would be
>>> interesting, they are also not the whole story and we should probably prefer a
>>> more conservative threshold.  Also, dm-verity I/O requests have a bimodal
>>> distribution with peaks at 4 KiB (for synchronous reads) and 128 KiB or
>>> read_ahead_kb (for readahead) anyway, so most of the impact should come from 4
>>> KiB anyway.
>>>
>>> 8 KiB could also be reasonable when taking into account multibuffer hashing
>>> though, since multibuffer hashing makes hashing two 4 KiB blocks almost as fast
>>> as hashing a single 4 KiB block.  (Though multibuffer hashing is currently
>>> Android-only, as the crypto maintainer keeps rejecting it upstream.)
>>>
>>> - Eric
>>
>> OK, so I'll set it to 8KiB.
>>
>> Do you think that I should increase this limit to "unlimited" for
>> IOPRIO_CLASS_RT and disable this feature at all for IOPRIO_CLASS_NONE?
> 
> IOPRIO_CLASS_NONE means an I/O priority isn't set, so it probably should be
> treated the same as IOPRIO_CLASS_BE which is the "normal" priority.
> 
> For now I think it makes sense to use 4 or 8 KiB even for IOPRIO_CLASS_RT.  That
> covers the single-block request case which is the one that matters most.  We can
> bump it up later if we can be shown that something higher is better.  Softirqs
> normally get prioritized over all real-time tasks; so while it should be more
> acceptable to use them for IOPRIO_CLASS_RT, it's not a perfect solution.
> 
> Another concern I have with longer requests is that when dm-verity runs the
> verification work in a softirq and finds that a Merkle tree block isn't cached,
> it punts the request to a kworker and restarts it from the beginning.  That not
> only defeats the point of using softirq context, but it also throws away work
> that was done.  I think we could fix it to not throw away work, but having to
> fall back at all would still defeat the point of using softirq context.
> 
> - Eric

Hi, Eric

It seems that verity_prefetch_io doesn't work efficiently.
dm_bufio_prefetch_with_ioprio
   __dm_bufio_prefetch
     blk_start_plug
     for loop
       __bufio_new
       submit_io
       cond_resched
     blk_finish_plug

If more than one hash blocks need to be prefetched, cond_resched will
be called in each loop and blk_finish_plug will be called at the end.

The requests for hash blocks may have not been dispatched when the
requests for data blocks have been completed.

- LongPing
