Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2048.outbound.protection.outlook.com [40.107.255.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9875A179A8
	for <dm-devel@lists.linux.dev>; Fri, 17 May 2024 07:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.255.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715932140; cv=fail; b=J/F98UwJlGYOqH8Xab0jsbG+ygZgsPaLh4y428eWQiWOj/l4TmrmjmKAzqIuMFOw2RRAb8Danz0FkUPTULvNYaWUxgG1Z4CTuBW2bRfvs2FzYf6plqITmnsgX63ER1m//e9HHx2Nq3B1rosZRcZWIPSZMCz4gAMUYyWeDQOlbIk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715932140; c=relaxed/simple;
	bh=bwLYGk7p5mxL4A02drJvPEyR367cKRry0+OzF2r7Kpo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=A3ib79KzxmDH158mxEZDAtlc1hIi9okT1gHKOObbd7JZt4AeD/EyUn+MTgCFe3NoJL1hDgWeZuU2DKzsZimat2hSyPZMa2+3HXJYxRbCdt8C2ktLYKUBMJNBpRYLwLhofO9OFwWUmC9RKvBVtLx0I5ciauW1IPK27nEK9KFOY8o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=DlqZ7Mhd; arc=fail smtp.client-ip=40.107.255.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="DlqZ7Mhd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DFLc/5KoeuFxluZMoSveAjOEq5tqGCjNc8p/s+UazBLTG4t5mu2HUuoiYfxhPScuHkU1hZMSzzH+nLKajHkMJWOvrmvGO97p03SCFXRsgEhHNaN4FxVP10GgV5vA2JqyTz0S7gHN63ExNrjcrKD6tqKhPJE5qigh6Ao97I84tUnx90NqMFlLMTI6bYFF2G7cDa+jyYrgpeZ9DXsOs7Y2iDMppVr7OQG/q2afJQCSE+sypp5la5IQDpFrQSVCAYsAioMqrf+RAyPqvDIkdXQX8cmBgCRRiyeaL/8vAGE4/SaV84uuNG8aGnK3BQeYJjo4IZQhThKizZ+rTb+5vLVzpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6WHPDxfQC8Cz0SKLPSS1k0tQuqB2OfZM9qyLrgjZk8k=;
 b=U8OLdQr9ekogJKEDPspT+P4l4TUqsPkr6H0bWv3JsdTVZ7wLN060vPlJi+sldXenJYtYrMIdHSNiBF0uJsKzDRJSsz4MQEMsJop2yvVbjvaXuU3aHQJYvzoJ8WfCJcRGvef3Vcto1U9v+jq4ZXLWOHCfB0sVZoXJgFPB3X2eJE1xmJS36yzxcRgAJPI0E2V68hFGzNWFIcUHUy/gmrhUHgnpMb7ytVwAqApndiO/yVXNed8ke/3cvcg0mc4a7YqNBnrOGMlXZsbHCGsCpLxlInxu6qBCcXzh7lHiipzbX6t1wNY/NDgpDplNOeZwEBPxBvjRMtwdQ7ZQnX086M9YPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6WHPDxfQC8Cz0SKLPSS1k0tQuqB2OfZM9qyLrgjZk8k=;
 b=DlqZ7MhdggRhbV8gAoDT8w4CxixCTzJmDnVXoT0XS/KqLV6GGlCtyk+/4kV0rIjubl2GQLjmS+vKHzTSMzmY/claBbMRzhOixQwKvCejejnN/6sdCiJT0VJKzEqDZXvCHzy6b/uU0Di4gMYvtuckv7xEGYdP8++1FJdkQBEGDcquSWNNC+29KZPot/wo1I2IyQhfnS3fX+6Urd50MUkFXH/9NAIK0HTEbK6GeqAKW7Z1KUFuG0teVt2ZUx2z7b2Q4zJ5JdK38JpQz31g4Fg+UQWwlf9AgDbDvnMIfRMUpI5gsiFrwx3qi0k7L9wt6tyGkE9vT/M1bdEW+nKG/t0usg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com (2603:1096:400:42a::11)
 by SEYPR06MB5669.apcprd06.prod.outlook.com (2603:1096:101:bf::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Fri, 17 May
 2024 07:48:53 +0000
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee]) by TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee%3]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 07:48:53 +0000
Message-ID: <8f49b95e-88df-48b8-9311-8a15414d8107@vivo.com>
Date: Fri, 17 May 2024 15:48:49 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] dm: support retrieving struct dm_target from struct
 dm_dev
Content-Language: en-US
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20240514090445.2847-1-yang.yang@vivo.com>
 <20240514090445.2847-4-yang.yang@vivo.com> <ZkTXzG1yrPmW64Z6@redhat.com>
 <80ddcd90-2e1c-4fbf-a45a-b1b5ff4d60fb@vivo.com> <ZkYmZaGWPtGIwedG@redhat.com>
From: YangYang <yang.yang@vivo.com>
In-Reply-To: <ZkYmZaGWPtGIwedG@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCP286CA0023.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:263::10) To TYSPR06MB6411.apcprd06.prod.outlook.com
 (2603:1096:400:42a::11)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYSPR06MB6411:EE_|SEYPR06MB5669:EE_
X-MS-Office365-Filtering-Correlation-Id: b13edea2-8710-4910-bdb3-08dc7645cc7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U3dnODdjRGo4Z3VsbW9mcWMvTjdMSEg1ZHlRalEyd3pEaTl3UktYR3pDMVEx?=
 =?utf-8?B?ZzRJbm5DSkVsN2FDME8rQWYvdXYzbnl0aDdJWFhacWNNK2xUdThwUTdaWmNE?=
 =?utf-8?B?R1VJWlBseVY5TWFibUdBVkdrbHZGZGNybDRFOW5yZVN6M0pjQlFEWFNZc0k4?=
 =?utf-8?B?SURMN21SdmlJenRsNE5CcGJMKzN1QnFFbGMxZjR0OVZzUkhva0NFMldpUGJT?=
 =?utf-8?B?Z0tlRmRneXo3RFoxbWEzZi9rWnZPMDU2UmZTandWQ01Jd1Z0NENLaEU0dUdx?=
 =?utf-8?B?YVBrUFViZXJ0RlJEQlBkc2V4STYxMHM3cEZUZUxNVTlBZmY2MXdUUGNtbnRV?=
 =?utf-8?B?cU90OGs5Qk9SVCtyZ3F5TVVMdldwcjV6alV5T1FWSFh5NFl6Z0pkUnhHQmNh?=
 =?utf-8?B?WGdVNXkwVWV0RWZkbUJDdXpyTmFOSitLb216SlcyQUFnU05xdzEzTTNHdEh2?=
 =?utf-8?B?M0lqZkFnYythWStTZWpteUcvbDljNkQ3YTlhOWRpcVRrVWlhTFcvZldPTXJX?=
 =?utf-8?B?Tkt3U2RVK1M3NkErSEoyR0RSbnFLYmd4NXN6bE5wVE9XRVBRUCtoVUUxZk5G?=
 =?utf-8?B?dzVBZXA2TWJrb1hVS3djV1JiSjBuRXk0NDh2VEtzWGJIRHd2MnJyQ0I4L3FS?=
 =?utf-8?B?dFg0aGRud0IzL0ZpZWZydW1DSU9OSFpZMUJtNWtLVndBd1JVT2E4MUdQaTVZ?=
 =?utf-8?B?azI3SHN1ZDVqNnRYdEFYaXNmMXFFa0RkUjZRc1hJZ0xiQkErb3RPQjR2elho?=
 =?utf-8?B?TnY5MzFFOTFzTUN0MjV2anR1Uk1maFRJWVliYVI1RHR1Sy9BVFNUVDdidGNt?=
 =?utf-8?B?UEkzUmY1RHRzbnAzem93dWpFaVgwNHdGVVFMNXFBVkJEbGRjR2hmUmd1elVu?=
 =?utf-8?B?Yi8rU1piY3VDZWRkMlRsWnBsRlhYNGh5TjdDTkhLRUhORmlmTzRaZkxXZENC?=
 =?utf-8?B?NGsyTTdJeUFZbkV4UlJxaFgrYm9EOHlkYVZvdm93VWYzeWF4NCtuRHh0dUNE?=
 =?utf-8?B?MWN6Y0I2YlNQTUNJY1BiNFpWL3Y1YjJiME1xS0FCbzd6ZDVWYjBMUGFaT0Ja?=
 =?utf-8?B?TkdRaXlucVkyMWpsa0ZNcnJZc2NxSVpvRFBIZ3lCL3RhZEQwQTJvYVAxNUlX?=
 =?utf-8?B?MUNKMkQyQ04zZW9rc3htUS8xZ1RralRoMjg1MXNUblNJUzExUDVkR1hLTXlZ?=
 =?utf-8?B?QlJUS21GQmE5Qkx5ZnFEVGdMU1lnNUpvWkFJeDd1Nms2a0g3OVlRZ2lNNHRW?=
 =?utf-8?B?bHcraHh3ZUN2V0xEYkFxYTNpUjE0RUFjQ0R4QmFTUWhDdktwTDlTZVY3NEt4?=
 =?utf-8?B?Y01FL211VWZEMzJJT2FoSmdOYkhFelQxdk9YS1JmYjMyZ2lKa3NPRGFJYWl1?=
 =?utf-8?B?ZDNod2dpV2pUL3Z0bTgwRjF6ZjJQQ3k0d1F2ZThZK01SWkVwb08xb0N6OUJE?=
 =?utf-8?B?ekpKdWt3KzlXa3R4WGh2RTFncndIUHBQN2UzN01uMllCRTJPVDkya1lVVFFu?=
 =?utf-8?B?VFR3dmg2QTJ6T2ZLSnV6NUo2VkpvSm12UGJySFEwVnhoU0VMZDJya1NNRkhI?=
 =?utf-8?B?dU1kU3hHR0xxYkwwaHBLNjA2RlVXSGFZY0tPUkFaOHQ3V3V5QVZUdkpFRWwz?=
 =?utf-8?B?YTE1VDl1bXpPVkk2dS80K2pkWkErK2E0UzhnWGFYQ0pGWE51Z01nVHUyZlJF?=
 =?utf-8?B?OXdnK2hRbGZzdnhCeDhEOCtxTmpRVFRKV3lBaFBpN09ZejZYcjFWQVJRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6411.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YWVUNEg4SEV2a0s2WmFYSjRwZlhEaCtZczRDOTdjNGVjYllNSFVPOUxMMmdH?=
 =?utf-8?B?RDNCZ1c5bmhMb01lMzFIeVk5ckwxVlhSS2c4cG52QzJHNk5HUmMxY3p2M3Ji?=
 =?utf-8?B?ZW9wTE9oZmNpaCtZdzgzRG53OU9WeDdKVEF2U1prb3phais5cHFzWnliUFA4?=
 =?utf-8?B?c1RDejY2VDVCeDlFcFNaSWYvcGFqQzJad2xVdmpabXBZbkZ0MWpnVWp5RjFj?=
 =?utf-8?B?S1NWT0FJTW45UHRCemZ6dnZRZm9OYUlTTzl0V0JGVkRWNjBNa2hWU3pxMGxO?=
 =?utf-8?B?RnNRb1hHalZXSmVXVWJqRUZSMkhFOGJxdmFLR2IyRHlwcjYwcWJBdjU5QlVJ?=
 =?utf-8?B?Tjlwd3JwdTVCRXBoTjJrRStRbEVRSjkybU4rY1dVOGY1MkJGNmFtOXVGL3ZC?=
 =?utf-8?B?V2taRzZnUWlKd3gvcVRlUHJFdzc5d3Y0Umh3b2JBTjcyQmI5MTVHZm10emE1?=
 =?utf-8?B?MWFJUUxpM3NFdmkvUTU0aUpTdGpGUUhMaXlaUWxTc2lBNGZiaTZDeG5Va3NQ?=
 =?utf-8?B?cjFNWUUwSlRsS1BsQU93Nkljayt2OUVkUE9neWIvME5uRVJaUlhncXdRUU9G?=
 =?utf-8?B?Zit1UDl0Sk9yQ1A2L0VIVXlYTStVTXV2eXluK3hwK2N4ZGw5NjRQK2pwR1BW?=
 =?utf-8?B?bW1VWC93ZXZJY1ZvT3Nqb1FhZUZkcWczV2lKZ1FRYUs4QTBQWlBrdnlGbHdq?=
 =?utf-8?B?RWhKRTR2U002R295UDh3NGo0VkNaRFJHVlNnR3kvSTRuVzhqaEMwSk40WnFR?=
 =?utf-8?B?cGVTK1ZzaG1VYjRtSk10NWVlR2ovbDBjMEJlSmsvVkxGVEx4V3NVbldiM3lG?=
 =?utf-8?B?R00wN1NsWFN4NzBMdi9MYjRBK3Z1eEt1OGdHYzBRWktIL3ltcTNIRTl6aExF?=
 =?utf-8?B?cXdlbWxjQURNTUFYdWVDLzg2TDFUSUFyTzZZdHNHQndsRFRPWkU2bHJ6VExQ?=
 =?utf-8?B?WkNIUG1yU3FtbFhNdnM3SFlqYWxHc2NkT2FkS1d3OVdCN0FBUk5HWmpPVVh3?=
 =?utf-8?B?Um95T28yK04wV0JlSzNiRk5wSXRIb0FmS1RTako0Y2pmaGd1U2V2NFZpWmMx?=
 =?utf-8?B?ZGhLd0RwVFdBVElMNlVkTm44REx4N0xKWDREMkZCR3ZDUnhzdlFZS3dacUZR?=
 =?utf-8?B?THUyc0s4cmNQUERzdlY0eEl1djd0UXpPZjFyNFVTdUFLNzFwN21ISjBRck9S?=
 =?utf-8?B?MDd2UmFqZUdlak03L1hKMmcxZDErczJ0cTN6eWorKzBGVmhjZ1czUEU5S3Jz?=
 =?utf-8?B?RzErYzRxdThOR0JIN0RWaTJRTzB3Z1FHZWFCMU5FQXprS1lyaUloQXJRRWhU?=
 =?utf-8?B?MlVMNGY1c2hXSWRCN0haQ3dHQTI2UnpQd085dG91VWhjU0VtYVlTUDFlZ3JO?=
 =?utf-8?B?VmUzU3ZqZGpkVU04dHp0cllMYnBNRktxYVQyNTc0QnFsUWdXdjQwNU9iZ2gx?=
 =?utf-8?B?ZVNNbDZ2RUtvREdEdjF4Q2krZTZZcmhvdHJGK255LzMxaEtXcklyb3lYczNq?=
 =?utf-8?B?RURyaHJXYk9DQkt4RFhzeEhPeFdmMzgxbWQyekRJUjduSjJKUWxxdHAxVHdt?=
 =?utf-8?B?bnhESUd1ODJtZUk0cGVMZUFXWmJtdjIrcmwycGxaamRPdFJYN3hZb0tVay9o?=
 =?utf-8?B?VmRUOG9XU3BkMTFkblZLOFQrTVQwYW5ST3F5RDM3ZkdrTVh4cEN2ZlF5SENp?=
 =?utf-8?B?OWozeWNiL3RTRFNkbFF4bVNRU2FqZjRtSTNMUlhwajA5Qjhjc1dBU3FtNk14?=
 =?utf-8?B?SjY5RUNFWVZBMnJTYkJoWFJ6amI0NGpNenVOaVREOU5kbmVBLy81dUVsVGNL?=
 =?utf-8?B?MjRRNWtXOVF1YjR6bjQ0eFBMQm84cXZtV3E1SDNRR0pFQUR2eHhRbGt5NnUx?=
 =?utf-8?B?dUVwcUE0VnNqNHRxcVlydmU5Y2VzZW5wOHRJeDNVc3cyQ2NvVm1RTFVnYjdm?=
 =?utf-8?B?aVdLUFptQWJBcW9PeUdwVG9XY3FENFFxZlNVaTZyTkVlQWZGTlFaZ25xc2wv?=
 =?utf-8?B?V0Q3Y2YxNTRMMFdzVUxmN2pvYWRCMjNIcG1nQXAybWx6cDlkSnE3Zm1qYzlx?=
 =?utf-8?B?dHB2ekxGdGU4MFJDZE5MS2VEcE5CNHJCTHZaWnFpeEZIRkRqV2F4M0lsd2tE?=
 =?utf-8?Q?0Y0s8OMVYMnP8+UPQW4A+y8bY?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b13edea2-8710-4910-bdb3-08dc7645cc7a
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6411.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2024 07:48:53.6075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KAYXvvAD4gNncV3SzY23ijtceVMqO18VV3GeLhGAoBjXlW+8jHRRksRz8gkqQY/pJT0jeiiv1ny/hrteuLBJZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB5669

On 2024/5/16 23:29, Benjamin Marzinski wrote:
> On Thu, May 16, 2024 at 09:55:53AM +0800, YangYang wrote:
>> On 2024/5/15 23:42, Benjamin Marzinski wrote:
>>> On Tue, May 14, 2024 at 05:04:42PM +0800, Yang Yang wrote:
>>>> Add a list to the struct dm_dev structure to store the associated
>>>> targets, while also allowing differentiation between different target
>>>> types.
>>>
>>> I still think this is more complex than it needs to be. If devices that
>>> support flush_pass_around can guarantee that:
>>>
>>> 1. They will send a flush bio to all of their table devices
>>> 2. They are fine with another target sending the flush bio to their
>>>      table devices
>>>
>>> Then I don't see why we need the table devices to keep track of all the
>>> different target types that are using them. Am I missing something here?
>>
>> I attempted to enhance this solution to support additional target types,
>> such as those with num_flush_bios greater than 1.
> 
> I'm still missing why sending a flush to each target type is necessary
> to handle num_flush_bios > 1. As long as the targets meet the
> requirements I listed before, AFAICS it should still work with only one
> of the targets mapped to each device.
> 
> Say the table devices are sda, sdb, sdc, and sdd.  If you have 4 linear
> targets, each mapped to a different table device, and one stripe target
> mapped to all of them.  It doesn't really matter if you don't call
> __send_empty_flush_bios() for the stripe target, does it? all if its
> stripe devs will still get flushes. Similarly, it's fine if one of the
> linear targets doesn't get called (in fact it's fine if all the linear
> targets don't get called, since the stripe target will send flushes to
> all the devices). If there were only 3 linear targets, then the stripe
> target would get linked to a table device, so it would get a flush sent
> to it. Can you explain a situation where you need the to send a flush to
> multiple targets per table device for this to work, if you assume the 2
> guarantees I mentioned above (the target sends flushes to all their
> devices, and they don't do something special so they need to be the one
> to send the flushes).

Yes, if the targets meet the requirements you listed previously, there
is no need to send a flush to each target type.
I think I may be overthinking this. I tried to handle some targets with
num_flush_bios > 1 that don't meet the requirements.

>>
>>> If we don't need to worry about sending a flush bio to a target of each
>>> type that is using a table device, then all we need to do is call
>>> __send_empty_flush_bios() for enough targets to cover all the table
>>> devices. This seems a lot easier to track. We just need another flag in
>>> dm_target, something like sends_pass_around_flush.
>>>
>>> When a target calls dm_get_device(), if it adds a new table device to
>>> t->devices, then it's the first target in this table to use that device.
>>> If flush_pass_around is set for this target, then it also sets
>>> sends_pass_around_flush. In __send_empty_flush() if the table has
>>> flush_pass_around set, when you iterate through the devices, you only
>>> call __send_empty_flush_bios() for the ones with sends_pass_around_flush
>>> set.
>>>
>>> Or am I overlooking something?
>>
>> If I understand correctly, you are suggesting to iterate through all the
>> targets, handling those with sends_pass_around_flush set, and skipping
>> those where sends_pass_around_flush is not set. I believe this approach
>> may result in some CPU wastage.
>>
>>    for i in {0..1023}; do
>>      echo $((8000*$i)) 8000 linear /dev/sda2 $((16384*$i))
>>    done | sudo dmsetup create example
>>
>> In this specific scenario, a single iteration of the loop is all that
>> is needed.
> 
> It's just one iteration of the loop either way. You either loop through
> the targets or the devices.  It's true that if you have lots of targets
> all mapped to the same device, you would waste time looping through all
> the targets instead of looping through the devices.  But if you only had
> one striped target mapped to lots of devices, you would waste time
> looping through all of the devices instead of looping through the
> targets.

Yes, I get your point. This patchset may make things even worse for
the striped target.
I am just curious, in what scenario is the "dm-strip" target mapped to
a large number of underlying devices from the same block device.

> -Ben
>   
>>>
>>> -Ben
>>>
>>>>
>>>> Signed-off-by: Yang Yang <yang.yang@vivo.com>
>>>> ---
>>>>    drivers/md/dm-table.c         | 36 +++++++++++++++++++++++++++++++++++
>>>>    include/linux/device-mapper.h |  3 +++
>>>>    2 files changed, 39 insertions(+)
>>>>
>>>> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
>>>> index bd68af10afed..f6554590b7af 100644
>>>> --- a/drivers/md/dm-table.c
>>>> +++ b/drivers/md/dm-table.c
>>>> @@ -741,6 +741,8 @@ int dm_table_add_target(struct dm_table *t, const char *type,
>>>>    	if (ti->flush_pass_around == 0)
>>>>    		t->flush_pass_around = 0;
>>>> +	INIT_LIST_HEAD(&ti->list);
>>>> +
>>>>    	return 0;
>>>>     bad:
>>>> @@ -2134,6 +2136,25 @@ void dm_table_postsuspend_targets(struct dm_table *t)
>>>>    	suspend_targets(t, POSTSUSPEND);
>>>>    }
>>>> +static int dm_link_dev_to_target(struct dm_target *ti, struct dm_dev *dev,
>>>> +		sector_t start, sector_t len, void *data)
>>>> +{
>>>> +	struct list_head *targets = &dev->targets;
>>>> +	struct dm_target *pti;
>>>> +
>>>> +	if (!list_empty(targets)) {
>>>> +		list_for_each_entry(pti, targets, list) {
>>>> +			if (pti->type == ti->type)
>>>> +				return 0;
>>>> +		}
>>>> +	}
>>>> +
>>>> +	if (list_empty(&ti->list))
>>>> +		list_add_tail(&ti->list, targets);
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>>    int dm_table_resume_targets(struct dm_table *t)
>>>>    {
>>>>    	unsigned int i;
>>>> @@ -2162,6 +2183,21 @@ int dm_table_resume_targets(struct dm_table *t)
>>>>    			ti->type->resume(ti);
>>>>    	}
>>>> +	if (t->flush_pass_around) {
>>>> +		struct list_head *devices = &t->devices;
>>>> +		struct dm_dev_internal *dd;
>>>> +
>>>> +		list_for_each_entry(dd, devices, list)
>>>> +			INIT_LIST_HEAD(&dd->dm_dev->targets);
>>>> +
>>>> +		for (i = 0; i < t->num_targets; i++) {
>>>> +			struct dm_target *ti = dm_table_get_target(t, i);
>>>> +
>>>> +			if (ti->type->iterate_devices)
>>>> +				ti->type->iterate_devices(ti, dm_link_dev_to_target, NULL);
>>>> +		}
>>>> +	}
>>>> +
>>>>    	return 0;
>>>>    }
>>>> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
>>>> index 0893ff8c01b6..19e03f9b2589 100644
>>>> --- a/include/linux/device-mapper.h
>>>> +++ b/include/linux/device-mapper.h
>>>> @@ -169,6 +169,7 @@ struct dm_dev {
>>>>    	struct dax_device *dax_dev;
>>>>    	blk_mode_t mode;
>>>>    	char name[16];
>>>> +	struct list_head targets;
>>>>    };
>>>>    /*
>>>> @@ -298,6 +299,8 @@ struct dm_target {
>>>>    	struct dm_table *table;
>>>>    	struct target_type *type;
>>>> +	struct list_head list;
>>>> +
>>>>    	/* target limits */
>>>>    	sector_t begin;
>>>>    	sector_t len;
>>>> -- 
>>>> 2.34.1
>>>>
>>>
> 

