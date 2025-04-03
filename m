Received: from HK3PR03CU002.outbound.protection.outlook.com (mail-eastasiaazon11011016.outbound.protection.outlook.com [52.101.129.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B505728FF
	for <dm-devel@lists.linux.dev>; Thu,  3 Apr 2025 00:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.129.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743639172; cv=fail; b=bj9PIVT0NJg/4RqZ46jOvsu8Apxd8OTGfrU8W066y4ZgSM001A6EomsKWAHDL20D1UGHlaEsvtVDhDuf6aeq4y46QbdMD8GRf7fZxxKGpVtnRr5LBG+aE1Z7e1YdqQXPCjxCV90kXFCZG85b3/0W/jYRf16RJMFVe4uQeUj8u9g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743639172; c=relaxed/simple;
	bh=hQMpHIV/xHNTUaqwnjgP9tPv/lOgsNJY4SWY61Y1lwY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YzX0ZhsPOw6E8LpI0UYJqaU1YRJ4cpDbT2mHAKTjILVEh6kpPMnAH5duGLhvCXtVnbzjZjtXqalPDcLTEWTfyLHjb7tAO6skfYL1GcoYGGwvt4gj8VybY9jH6ztJ1poeMT6U3yoyv70rF2rh7QjW0ALKsbVAeu6WbZ1tJq6SEDo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=GkuZFL4r; arc=fail smtp.client-ip=52.101.129.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="GkuZFL4r"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vkcmFGeOk3L30gWH/pA1H6eWHq1wDV+zS21/U+8dhebzHzBHXGYBryxn33n/3aMdcE647jsFT0hmMNYpds76gfGdmBcC75W3Fv49pMeg0kvk0ermq0+ZSVJkI/oQBrF+sZRKZjx2ePDAcNqVCLPYYv9rLS+3iQzKM2W3QH7OD2PVftVMfvoPG2aN38WVKL2ROkEaxxvyOTOUihbSsyzT1cEWBMPgdJPWV1Tx3cKeab8dOcryVkN2RwBhK5iazdHNwKOF+K7VioBNq3qEwJOjKjVFiKTgyw2pzx0Y870J1CxpCbE3uHUqxFfaA6DH16ZC0J1gZAdz621QgXYXCifN9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lRu1xFpZ6VUW1JXuJv3mdiVDHukdY5qn2FiNfsYkOek=;
 b=RBD66JXBifwnzkfk+g/rsgwDETS7Ul914NJJf5U21D5MNv0WDC8wIxuC/52UyGg0vQfTqQWgzOJdgMYWsPuYjkb+oIGUgMO5QYQoVt/o7UjyrTTPm5bH14g6wuzLo2+LbHgM4J8l2t3sGoF8W4AyFg1ae6Vsojd81Pl5cSJzB0r7Ay+jdBVwIQ2dFxuE84h+oYD9OmBzr3XSH++2J06JIaLMwYONbY/KTVZMXICTTaBb20yO1ROTZvhKrODTajrH6zM3tCv6sWQGTsx2UEfTgB8JD2o5PqkJNf80og1L4ZL1QI9CA2AAqRegsKPYyt7vdJ5DRo9A8XrSrxUQwFBHeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lRu1xFpZ6VUW1JXuJv3mdiVDHukdY5qn2FiNfsYkOek=;
 b=GkuZFL4rzNmgAkAwa78biNQzU1HiE3G63Xb9Z/4t7Zntwhc96HZJ7rwE4ksHmtnXn/L2MNM54+5ZBYyDsmpajhVyR4pd/WBZQBl0iXpfl7AKgZJCtvi/5zyGv5q1c8hNc1FEMcZX+sJpwLfuY9WE5Rt6J46r7+HyosWU24/MIoQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by TYZPR02MB7949.apcprd02.prod.outlook.com (2603:1096:405:b7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.19; Thu, 3 Apr
 2025 00:12:44 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8606.019; Thu, 3 Apr 2025
 00:12:44 +0000
Message-ID: <66bf8a8e-0a7d-47b8-9676-dc2e8c596bdb@oppo.com>
Date: Thu, 3 Apr 2025 08:12:41 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] dm-bufio: improve the performance of
 __dm_bufio_prefetch
To: Eric Biggers <ebiggers@kernel.org>
Cc: snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev,
 guoweichao@oppo.com, bvanassche@acm.org
References: <20250402070934.2387587-1-weilongping@oppo.com>
 <20250402174313.GG1235@sol.localdomain>
From: LongPing Wei <weilongping@oppo.com>
In-Reply-To: <20250402174313.GG1235@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0002.apcprd02.prod.outlook.com
 (2603:1096:3:17::14) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|TYZPR02MB7949:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cc1bc53-f120-4cd9-fa27-08dd724441e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UnVvWVUzR1IxSWNKaVFXR2hYSG8xQXl0ZEl2UHlMb1dtOVo3RGtKdGF1TWRO?=
 =?utf-8?B?NDNwcE92Sm50WUdXT1pqWU9pVUtrQmZJZkloSGdsL3JNVC92anBzbVVYbjc5?=
 =?utf-8?B?RVhCSzRxMnAxUzdIK3ZNWk51TGVmdGpTY0N4Zk0zMTRLaS9wZWxNeHRoRE5K?=
 =?utf-8?B?YXVQOURQdmhDNXFzSFA0UEc4K2RncmhoaGttdVowTFQrSEhUZ2YzdUxzZ1BP?=
 =?utf-8?B?eENSd2M2TGF2V2FHdjhBSWtjUE1pL21zSzJJZGZHK0lFb0p2am5lS0taVmdi?=
 =?utf-8?B?OVI2Z25NZnBXZFJGV2RKTzVBQ3VwK2ZsQ0RNdkdkaGttSzhoSTFWbHIzMGpy?=
 =?utf-8?B?VzJzNlI2U2dMeWdzWnNwV1E1ekJ0bE9nRTJJbjBRVWppZTl5eTg4OERmaHVW?=
 =?utf-8?B?M25ySlV6NTd4anNBOXVLYU1vYnFSV01NL0d0U2FIVHY1Nk9lOEJmME1qdDY2?=
 =?utf-8?B?VE1JYVlxbHVhMnhkUU0zN2FBWUhsY0hJREZmelc3eWlhbDhMdWZUbmxoTTRD?=
 =?utf-8?B?MXlBT1duZGU2V0NpeXZPN2lCKzU1OWxKVGFtTXB6QWtWaVlVTWdoWW1aMlJw?=
 =?utf-8?B?TUR4RUZib0NOMjJZZDlnUGplZldoLzlIS0tBV3h0cXdMeFd5ZzNmUnpYZjBZ?=
 =?utf-8?B?ci9TWjk1RFFWWXVLcnRvQXpQNllDdWJzWmxvanhsZk5jRXNYWGs4QnkzVUVI?=
 =?utf-8?B?N1RoNWl5NTFyeml6alhhZHBFSjNlWS9HL1FNZWluNGtiWC9hNyt5M0xBRHBn?=
 =?utf-8?B?QVJiVi9CeGF6MXk0U25kUWVIZHpNSXdKQmpDbnRFa2M3TDcvQmpGVThTUVVt?=
 =?utf-8?B?amswWXczT0toVlg2Z05RVTdrcGoxd0I0QXNHVU9TMzhnOFZQcGU2RzNISWNy?=
 =?utf-8?B?bGZkVGhmbnFGZWp0Z20vdnoxVW9wTGo5QzNaNjMrNmhXQVowNWV1S3Yxam9Q?=
 =?utf-8?B?VGE0UVY2RWdnQlNYRnR4MzkxV05KbXladEZyRTJWUU1maXJCTzBMWTBZSjRj?=
 =?utf-8?B?VURvbmoya1c1cTBQdXlXeE92VjBNdkxGZlJyaFJJSGZvb3BPbnluOTAxamsw?=
 =?utf-8?B?cFcvVm1NeVBmUTJ6akRwNGVuS3pXUjlPdm5Za0FLVjRPR1l0d0FXQ3prZlFh?=
 =?utf-8?B?MzNkNThoZXBjZ2FBQkVrMm9tV1h4YzFNRlVXWTd1ckxxWS9RRWMvYmlWeW9o?=
 =?utf-8?B?SUMvQ2JkM2ZCdVhMclk3UmlSbVoxbFVPalVha0x3RzgzYlphVEx3QlREc3d5?=
 =?utf-8?B?YUtLeE4xTjdjYVBtZkk1R09BcndzSDdmeDhRR2hPWUVZQTc4MWZCVzNMYkQw?=
 =?utf-8?B?ZkhkZ1A1TWpYcC9GYncvd1J2QVlrc1RkZHIzZUNYUGVwNkY0WjNoZ2xrbE1i?=
 =?utf-8?B?NUFpWXc1RXU1c0hvam1HaittK3IxQXlwSXljMXhWa0NpcXpWbVY0ZHNIbkpt?=
 =?utf-8?B?U1hhN3hyRU9LZ1FGdnNVYnRVdUpVNmpjbm5ZVmhCODI5aXRTSnFpdXBHaDZa?=
 =?utf-8?B?U1Vvd0FQYyt1bEN6c2pUeStQNXRTZkprWGl2VUptZzRLL0JFUXhmakxnK2ZH?=
 =?utf-8?B?MENVZndoc3JEMERxbG9UTHVuck0rbjRMSFlxMjdmbUJ2bEdnY3dFdURwazUx?=
 =?utf-8?B?QjdnV2pqRzlsVW5KVURUMXVDOE0zSEE1KzF4eEk0eURhZG1HYzNZc09pZjc1?=
 =?utf-8?B?aXdlS0M5d1V6K3hDYkR2aHhWNlZiV1NBSkZHaWJpSkxVYnRxUHU5R2ZLNDNL?=
 =?utf-8?B?Z1VQUmNudWlYWnV0Nm02NjVOQUhURHJkN3RkRy9jOCs2TUY2WEZyOEsybXQw?=
 =?utf-8?B?Y3RHdSsrd0hXR3YrRzk0Y0F6VWMrdDNtODdIajAzcDk0VXYzeXV2bWpJbkp5?=
 =?utf-8?B?eHFBQ1pRODU3UXd5a05uSmphSXU4MFNHWkx1RC9xb01lS083WXhWUkliVWdh?=
 =?utf-8?Q?wtRLNZgaUyQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZHFSeHBVbmtaMjFVMC9LQVRuK1dlbldOdzNFLy85bllHeDgzTWIvNnZuRFNB?=
 =?utf-8?B?UXl4TXU3Y3FRa1oxdFYveHA2MzF3MW5CeEVlcXpBeXlFbzFTbFBZY0czRXBZ?=
 =?utf-8?B?eUlqMDhoRStOcnI4N2xPNlozbzBsY1VVT01JdHYxN0w1T1N2Y3podHY5L2kw?=
 =?utf-8?B?ZWhEWlZ5Skl1VGpLKzR4dVpiODBpb0FOZlo5R2hKYUkwOG1KMEVSdzhjdkUv?=
 =?utf-8?B?WDk0S2EvV2laYUhMb3hoc2U2WjA2YW9vbHZacXdVSWFJKzhteXg1YktHd1lM?=
 =?utf-8?B?dzRFNjh6YitWY1ZkUnpiZVMwSXloUEk1OHhPMHV6OU9LbE1QSURnS0E0TTRS?=
 =?utf-8?B?TlQzRVJqSnl6aXRHQTNMeDdEMWZkWDFlVXhiWElSOXBXZ0ZDNm1ZNzZINkx2?=
 =?utf-8?B?S0xXR1lteVFCNjFvdWdjRnZuRUVzdWdQNmlrd0FDTnR1cnFQWkNHKzdMcVhC?=
 =?utf-8?B?YWJ2UTE3SXh1V3pWM3dwTzBCL2VwZ3gralZDRnlXbDh6ZjYrdHhYWkF2N1Z5?=
 =?utf-8?B?S0hjRzFhZ2ZBSEtZSjZSVFQrZmpRMG9yd3JYQlZhakptUFZUSW5YdzVQTkNN?=
 =?utf-8?B?YmZIQTh4S0xpOXRiZ1RDOU5reEtkcE1YNzlIZERuTVZ6cjhCK3ZlaythVkF6?=
 =?utf-8?B?djA4UTFXRjNseDdwTVpUbTJKZSthcEVmN0hMbTE2R0JEWm92OFd2S0poOUZF?=
 =?utf-8?B?aksrNklRb0dDeWt6TGEvTS85SzR2L29BUE1Oa2ZpQVoxUGx1b3BiQ01JM3Bi?=
 =?utf-8?B?VjN0djZaOXIyWDVoYWdDcjBNMVBxSnhsSURSLzlQSFNJZXp3dTZQOFhiL20v?=
 =?utf-8?B?UEpDeWJmL0lra2tTQ0Z1ekRPQzVycWp0L0NNSFF4MEIvQmlnVDFpOUpPeHBY?=
 =?utf-8?B?VFZ5RGtUNnpnaUxUbmJzQWdqelhibC9XZThjK0NucTRBRnZpOUZZTnU2dU8x?=
 =?utf-8?B?NUIzVXl1dG5qbzZaRnhZdkJTY1lOQ3huVU9Bc3VXcnArZ0NqSG1IOHZNT1pk?=
 =?utf-8?B?akZRTFEvdHpWbDVuNjFWaTloUzhLMXM0UEpveGhhREU0OHhXM1IwSDF6OXp4?=
 =?utf-8?B?b2ZwemRwZDAvN2p3M3g5b2M4VUFyMG5DcThaa29qenFBNFBTUTczT0V1ZUc3?=
 =?utf-8?B?QzJwV2lsRi9peXdDemhQb1EwTWJRYUtkTzFBeXh4OWhvZXVRc2g0UlZZYkpi?=
 =?utf-8?B?VTM3YlRvemc2TU1CSHRqa2N1VktFbFJaUG5XZUpRNEVPTkhJdkRLdGFqYzlu?=
 =?utf-8?B?d2M1dDgyTHBkUjlLMUllMk80WEdLN2x3UVZucUhjT0E4R1BBaEZFblkzSlZB?=
 =?utf-8?B?VldQU2g1SXpoeGxrUWhnMWxNdENHUEdvMmFsYmsrVUtGampuaVBmTU91d25p?=
 =?utf-8?B?ajZaQzd3RWJxWHBsU083dzVpWFVkVmphREJLcTJDV0xiMEtSODBGYzVDR2ZP?=
 =?utf-8?B?NFYxQzBzd1Ivdlp4enVJSXVpbzFHVFNiVXFhMlRnSkhnUi93RjBrSURNTThW?=
 =?utf-8?B?RDJQN1pWYWNaV3kvTnJiUTFKcUZlcmhDNjBMYlNYMlMwcHdhTkFnRythdnl3?=
 =?utf-8?B?WkNjVnE5akJhOVdkaXVrVUI4bnp1M2NWZ3JiR1NIcFYzcUFYdFEwSHF3OUY1?=
 =?utf-8?B?eHF5emtKdTRKcWMwSmhsQ0N5bUt4dkpycXZOSFU2cnczcVRiOUdNR2gvV2sw?=
 =?utf-8?B?U3ZTbjBzaFVGQ2JKemhtL2VLS0ZFS1ZQRzBiREQ5QTJEbzhPNXN4SjBybkdt?=
 =?utf-8?B?QVNDRkRTdlRuTm5Mb2J2UTZ1cGxldnhPRjIwdzYwcWxITklPTFUwNGNGR3l5?=
 =?utf-8?B?a25XVURWdGtDdzJIZmN3a0dWVVdyaXFGdURRNlhTZGpTOTFNcVNhNkhxZjh3?=
 =?utf-8?B?QnlsbkxaQkhMWVF2MFZCQ3pKcm1wOEpqQTFPc09rRWxmTXU0elovZ0RybDd5?=
 =?utf-8?B?a2p5OUtnOGNlZUR6b1FjRWRIeHQxNS91OWNnNVBOYURVWUtjU0Z0VE5vTS9D?=
 =?utf-8?B?Ym54L3Z2Q2dTd2NGZ2ZJTHlwZklYWEwwNWtja0dTdTBQQi9YTW5NSGlCanVp?=
 =?utf-8?B?eFJSZlNMYVIrLzFxY3lOcFRrMGxrcTNOZUhKdmtIbG13TW9qbnV6Vm5qY2Q5?=
 =?utf-8?B?Z09jME1iTG9QdjJNb242bkMxaTZwV3VNTTRaWHMxcEpQYWRtdGVQU2o0RHdj?=
 =?utf-8?B?dHc9PQ==?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cc1bc53-f120-4cd9-fa27-08dd724441e4
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2025 00:12:44.7210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Rtl0dD6TzQY5nSHML5qMG+ucDV/LK4nKGP6xxTG95YghF3y+PWuTjpI24XDTqpypOVzbkL+ROB6zlUNFSdXbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR02MB7949

On 2025/4/3 1:43, Eric Biggers wrote:
> On Wed, Apr 02, 2025 at 03:09:34PM +0800, LongPing Wei wrote:
>> 1. call blk_flush_plug when cache hit as the address of the subsequent
>>   bio is no longer contiguous with the previous bio;
>> 2. skip cond_resched when ioprio class is rt;
>>
>> Signed-off-by: LongPing Wei <weilongping@oppo.com>
>> ---
>>   drivers/md/dm-bufio.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> Looks fine:
> 
> Reviewed-by: Eric Biggers <ebiggers@kernel.org>
> 
> But I do think the prefetching should be reworked to be along the lines of what
> I suggested here:
> https://lore.kernel.org/dm-devel/20250327170524.GF1425@sol.localdomain/
> Any chance you're interested in helping with that?
> 

How about calling verity_prefetch_io directly in verity_map only when
use_bh_wq return true for this dm io? The size of dm io may be a greate
number as dm-verity doesn't set a max io length. Mikulas once mentioned
that there was a problem that caused him to give up doing so. Has that
issue been fixed?

> It also *might* be the case that the prefetching is no longer helpful and should
> just be removed.  Especially if dm-verity will start prefetching the whole hash
> tree anyway, as your other patch does.

It seems that we cannot just removed the prefetching in verity_map as
the cahche in dm-bufio may be shrinked.

> 
> - Eric

LongPing

