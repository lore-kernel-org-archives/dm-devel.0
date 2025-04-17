Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013019.outbound.protection.outlook.com [40.107.44.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD0F21C19E
	for <dm-devel@lists.linux.dev>; Thu, 17 Apr 2025 00:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744849611; cv=fail; b=Tyr6wZQuNR/msUfptT12LQ/8N50lksZy6DBGnXUW4krq6JgA2PxL1B+z16VjiqVoPv3oIBKCyVCqlnuvkjsfXfOWo4GN66xBaOmqmjjKiM2Ukf6TysdVgeKV85JGlhHWL2rb6ntKjalA8Un5W98FJ1eX5nD17W3dXfqA+LK864c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744849611; c=relaxed/simple;
	bh=i5QbvuE94fbQlSR+ZS73Y84enduysbRJjLxdSIkSTJ8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HbQkdpyhxJ3chL9EaLBnlHMEFLU4YwY6ltgbaGdBUlA9DT73VMWTiv+24V2ssWlPPo3Sgt0NvmPmbj8Tn4XxTY5OUQQDudsVLO3FRxXy+arLcwP2KVR8UxeC/fiwKgxsIn7Elz2qyre4DlpGbrZjYOC/y37MC7UeFIPsvnfhzN0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=fjs57MZX; arc=fail smtp.client-ip=40.107.44.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="fjs57MZX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dGktZbuZIRQ+7rdLth2fGl0jQkZbGspg0AFLxP/RoHZlQj3ez4lR7g7j92BI+3I1EhYMBbBRgNc9CqpeMANz2qC0RHPhcRtSfAdLZnlw8wCDXPWdpmNLBnKPcpZQhs3OymZliMKwvZmsDkY59oPz3jSSam3nL/jyYA4JWd5MGW+7pBhA+n6myk4AV4F2gNrqSGRM+NLvll+xba7h0Gv1sRIoZBIpukmLrsM9BOMcy3lTubs8LZ0UEP89Pbf9XV1nD4GOkGiK86sfiarrs+EmM2QkN1tcCEM8PGCH9FDTYOsfnpYOYhPK19ay743sHkb+St5DMkosnNCWTp802Zbo8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eQm1a+cJ8cnhMvhFibNsiqysbL1JRYMZtEGSMzG3/Mg=;
 b=PJat2WKKZuaP5qzykvbJjZ2N7yg6zTqLIamh4K7iUcnEX6CKeeJXeTsowNb3hTz8tCfwb6wBAXok9yuq28M8nmmiP4kA+xdhcQCV4zDzNZXQC/SpgAAnlHtram8VNDUoWBgmG8FvYbQG4dyXNNoJ2YGiwx6PoE/5Mqa7gdXF6BM1ouWvyCKuy7fnygj5ZbzpICSc4ukkqyrcL1izbZ6NKEWMntW5bvdi9sdtl6bO59ziNNPG1TYQKi6yxvBA5Og9c10fGL1BVBawBXGqXsj5F32KPv2PoBNjkq2Ad7GfBrXB8rLppvI9iXY1YWhsQlcQXooSYOWL91LcEaQmxTMisQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eQm1a+cJ8cnhMvhFibNsiqysbL1JRYMZtEGSMzG3/Mg=;
 b=fjs57MZXuSW+TePAjpmdEZrtgrtmzGUwGGE+QLnrNlxC7qK1PDLHJPp1JHv0jq4xDDLPKhHv4HDy9hcoVhJqYe0Cpth3lmb1J4hC07aP+HLkUy2XNc5HAlXaD5rqxcdLPUd7l8fKL9cd/COfoWvxSBqWQRLdPBhobsm3GJJkGpc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by SEZPR02MB5960.apcprd02.prod.outlook.com (2603:1096:101:7b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.22; Thu, 17 Apr
 2025 00:26:42 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8655.012; Thu, 17 Apr 2025
 00:26:42 +0000
Message-ID: <bf5f3854-b171-4eaf-801a-28c0f690a4cd@oppo.com>
Date: Thu, 17 Apr 2025 08:26:39 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-bufio: skip cond_resched when no_sleep is enabled
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: snitzer@kernel.org, dm-devel@lists.linux.dev, guoweichao@oppo.com
References: <20250416094512.3561667-1-weilongping@oppo.com>
 <16733109-69f6-e347-e1af-02af6223ca8d@redhat.com>
From: LongPing Wei <weilongping@oppo.com>
In-Reply-To: <16733109-69f6-e347-e1af-02af6223ca8d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0019.apcprd02.prod.outlook.com
 (2603:1096:4:195::13) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|SEZPR02MB5960:EE_
X-MS-Office365-Filtering-Correlation-Id: d17bdb2e-d053-414e-75a4-08dd7d4686a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c3ZYRXNBSUxlZXprRVNITi9nZkhjNzNuaksydC9YY1RwbGcwbmpMM00rWndU?=
 =?utf-8?B?K0cwRE1OQVRCK0E4bHNRTzVKK0hTRkNxV2hGSHZHdEdlUmZ3SU11YWEvTjdu?=
 =?utf-8?B?L3R5MXRvMThQaUNQdkFEa2syQ1cveWR2R2tIWVdiZTNZZXhJV2d1OWhZKy9V?=
 =?utf-8?B?MDRjS2d5ZmtSQlBON0d0OGQxWnZtMVN3eGVjeHJhUCt1alFnRjdsc0NVSjlG?=
 =?utf-8?B?RjYvRGdCUmVYaEJuZ2JaVmhMNUcrQ0FndWY0anozdWFaaTlXeFFNTnFPU2dm?=
 =?utf-8?B?VEo2ajI2U1lGdG5Nd1o0bzNCRUl3c2REWW9hOHdKWFIvUE9sUFRpeGp4ajRY?=
 =?utf-8?B?UmtxeC9nYm16QjFoZHVEUStWaCtkYURBQ0hLaGI5LzRock83RGwrQXJrMkhY?=
 =?utf-8?B?MC8xMWVQWjY3SGFFMG1VVE02N2lOYzViaTZ0RjZCZktrOXc0eHJRbUN0UVFz?=
 =?utf-8?B?RlI5T2ZXM0RYK09sMkcyZ2RVdDBhbyt5bjkxRWlYQ2xGM3N2MklhWXpRRTcw?=
 =?utf-8?B?VEd2ZEZvNkdHc3lrOC9ZVnpQcTl1dTI2YzlxZVZQVWpobGE0NEtuYVV2Zzl1?=
 =?utf-8?B?amxwNHp5OW4yZ3M4Q1pGcE0vN1M0MXBPM2F5TkZhbnpjcjQzeWFHSy8zdjNp?=
 =?utf-8?B?NXNndXkrL1U5cjhpYkRlQ1creFR2NzdqcFQ4MEpmQjkrK0R1V2dkUlZaZEVG?=
 =?utf-8?B?RG80UHRPbCtNWG9wclNKN2pUZDhiMVRLZEF5cWczNkFEK0hXK1g3bUk1bG9I?=
 =?utf-8?B?eFVaNVF4R1B4aENyOXpncnA0dk9UYnFqN1gweTkrM0N0NHRYNDk5bThKMjAz?=
 =?utf-8?B?cW93MCtDZlBONzJEajRJZUswTVIzSlQwTnQxM2tQVHpWaXBVV0h4NFg3M0pI?=
 =?utf-8?B?eTUxd0plWmdyK1NrYXJjWUNrcHFqelNxSHBQaGVVakZjNDUra1pJQlZHbFBN?=
 =?utf-8?B?K1NhTUdNcEdFZ0lidFdnUUg1NDdwemladk1qRldLeWZlczBMcE00VjJyNGZJ?=
 =?utf-8?B?cjZudFV6amFMdjh0cnVJNG5IdHFMUGJaRkpuMlFTWTFtU3p1ZUcyemptV1Zt?=
 =?utf-8?B?YnZhb0ZuSm5NeWE3L3NtNkxicFF5NHI1dy8vV0Z2ZzRKdFoyR3hxUUZuL08v?=
 =?utf-8?B?bkxzYnVhZE1rbUJSNXNrTk1udDJkYTJWd3phVGkyZE8xejMwTTIvTjVCS2Fw?=
 =?utf-8?B?dkM4S3dsTVpDT28xbW1IcnN3QXVQbWd5RWUyY2dyM2xyR0o3aWwzWEtNZGhN?=
 =?utf-8?B?RTJiY2ZGeG5jQVN1WkJyYlUwMksxTjdxaTdjTW9QNHAyOGFXdEo4cmJqR3RM?=
 =?utf-8?B?R2kxTWF6TUJHVTNDUWVUYm50VGU2RGxTOHJNa1hHZ3FJamUyU0w2V0RzaTNp?=
 =?utf-8?B?WlRlMTBXV0NkUEFyYkZjTjhJMm45ZVQvWGFGUkJITEJwaytBY2JRa1dYWEQz?=
 =?utf-8?B?UCtkRTc5SlFRRlRIdjhJRXpwaXg4YnpzcW14TGFZZVJGMUlGcnE1SjlqR2dH?=
 =?utf-8?B?RWRETEdCVEY5TE5IV0lsT1JJdEEvdTNpcmk5QjZDRkxPaDl1MmNzWWNCRnEw?=
 =?utf-8?B?VFB3d2NCUUpXWTJNMjAvRURWTFpZSk0yYUhpSDM1MXFsNFZ5aFM0emFjdFJz?=
 =?utf-8?B?WGV2TEpFMVZsSXhnMS9RWS80Rng0QXp6VjBsd3k4SmdlSFN5T0VzbDJ2YlM3?=
 =?utf-8?B?Z0dLbE51aHc5ZFUzblNEQUh4QSsyNlZ3T0RoMTBXVkdNZ2dIeTBQMjNuLy8x?=
 =?utf-8?B?SzlDeVJBR2MxWThxeVJRaVVHQ2tOTU9ZVFFoYzhFMXcwSnhkUFZyZE0yV2Fv?=
 =?utf-8?Q?JJGSntM27uD3TkGiKgqfSiSXEtC0B/+jyYQIU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V3kzQWdPeVZneE44R0RpUWhSOEdBaWZrZEdFWHpTZnpoa2VzdmkvQjdYM2Ey?=
 =?utf-8?B?TDF5NDQ1OGYzOTZYNkNtT1p3Q1RiNitiV3BaRXFRaEEvSGVaRDh1S1RtNEwx?=
 =?utf-8?B?ak9OUnFhcURlSlFYSjlQUzZRSTJIenNQRWRJbGJaUzFDMmJrcVdBZ0pjL1hp?=
 =?utf-8?B?QXYyKzcwRGdINkhzenpiM1NFMmRqK3R4bGxPUFpBR0ZBNjJJcHphcUlVTVNU?=
 =?utf-8?B?dnhXWkxWRGlZalFPZmdmZCtyZ0V6T3d2V2ZDWENKMmU3V094ck1ocldjckdE?=
 =?utf-8?B?TnpsRkZTWGxZL1JFZFRUYTRyQnRyRjdiSEhlU0hVSmU2OXZIRExwQjhQMEhk?=
 =?utf-8?B?SXl5K0lMWEpBNmZyaDdjSkF3bVlITnUwRWRlNm9mWHQ5enM2cDBMbW42c0JR?=
 =?utf-8?B?NlVvSi9rd0FQN29LR0t2L2VpOThnamMrRnd0UmJ3NGpLSzZ2a1NoOVp3S1dI?=
 =?utf-8?B?N0ZwazVsTFprV3RmZDNkejZ3d0wzQzJreDZjaUdWSEJHVHRBcGlFR1hpVGxE?=
 =?utf-8?B?SXp3N1FsMGNoeFIvR2FJaVZ5Lzd1YWhNUng5WFllM25nbXdBQld0SVlKdHhN?=
 =?utf-8?B?ZW14ajhBV01YbU5GWDJqcUVrNTdPakFucXlGdlhaM3NJdWxuRXB1bXFHVFJG?=
 =?utf-8?B?MDUrRFJTT0ZwZ0xLbDIwU1NmVmR1N1UrKzAzZ1d1cFIzVlRGYnZ1ditBbE5C?=
 =?utf-8?B?dFRGdzRxYmljNW4vMWV1dGU2UXRyNjh3WkNCRGNrcEhjNnFqT2tMajE5QXRE?=
 =?utf-8?B?cG1FY1d3dE5QalExbGdVb2JuTjN1TC9zVGVMN3A1WXJTU25JUUFhc3FhT1Q0?=
 =?utf-8?B?R2l5WFdBdTUxOFAvMlJzc3ppWGdlQmR1TDJrdGphQyt2ditqZVpEYzNwU3gw?=
 =?utf-8?B?RU0zS0NTcmczZUpyMGZ1ZjY3Q0dSci9ZczFqcHpyWTFZRVpDRUpmbDV1OExy?=
 =?utf-8?B?QWpndDQxWG9jeEdqV0YvTDBYUlNscm5CbitzbC9OM1FaSFZGNGVWWmZ6UVpI?=
 =?utf-8?B?SjQvRDNVQlJGTWZKQTB1dVlBcXE4YkN4eGUramx1TFB1YjdDZUZDUGJESU50?=
 =?utf-8?B?SXhaWXZORllnN0xkMWd2N2Q4US9rdlJLem5tTlR6Y2pQT2UvdmtXVm5qOEh0?=
 =?utf-8?B?MEYxTmdySVZwZEVDeFZrT0FNRWV0M283bE1vTVlrRXdrSDNmbzhleG9mb2R0?=
 =?utf-8?B?eHZjQXdSV3puLzFXZXIxMVhpNzJ3NjhWSnFZYkNGSVFTY0x1UFg2M1pFK2ti?=
 =?utf-8?B?dW5LNGtxbWZZeUVpRWRVa1hoUGRxK1RuZU5DejZuZTB6WlZIVU5FaVJPRERZ?=
 =?utf-8?B?MEVRZU93RnZ3L2pMazdIUFhCTklCQ2hmQU5BcVlRTVBQdW1tNGZmTnBkMjBH?=
 =?utf-8?B?K29Odk5XVzQ5bzdBbEtTa1pEK2xXa2VGcWRYYzlTU1J2MHdLMEx5UVF6ZVRn?=
 =?utf-8?B?bmVzZ3lTMXpIWTkveE9iMW94YmE0RDN6Zk5zaFE1VGQxVnZkdDNkeC94dXpx?=
 =?utf-8?B?NkRwUnRxUU1NVzNRY0N3SzRVY1d4RkkwbTlIS3F0RzgzakZZVC91MjBHNzZQ?=
 =?utf-8?B?REU3OVpRVFhZMGJ1di9yS01lYTlRTDNNdHJ3eTdyUm5XMkRMMXBXVmYrcU5r?=
 =?utf-8?B?eWVkYm93SHM2MXFuYjlRS3R4RjlrQ3RacDJqZzFBcGxFZlJOQ0pJK3JkMU11?=
 =?utf-8?B?d25uS2hzSEZzNWE0NFNLclVaTGM5bWM4N2h1dWw3UHZjalpoM0p5QjVKdjVM?=
 =?utf-8?B?WXYvMTlOVzJlVlU1eWE5M1hET1E3VW1Nb3JDUzgwRXhTSWxqZFN0VkRpSVRL?=
 =?utf-8?B?T3F0eWxwcUpyQXVFVGROZE00ZTI2VXh3SzE5aVcydUR3VjV1ZW43enJ0bnpE?=
 =?utf-8?B?QzlOaWhYRHNSMEpFZ3JWL0NTTnpTa3RkTEQwV1ppY2NSdGFSTkNrSUVVQmo5?=
 =?utf-8?B?b3A2eEQ5T2FZWE11empITjVtQ3c1TVQ3bFMxNng4SmF0Mlc0SkdDNEJWOFBO?=
 =?utf-8?B?TlBtQUVxSmVuUXZRdkEwS2VjWGVSZmZUMXgrZnNDdFhhak1oWklzYkt2YlQz?=
 =?utf-8?B?ZHVTRUJsT0s1eGVVaXhTUzg2eE4vdyt0YkE3Rm1zeU9IRm9uZ01IeFJUbytK?=
 =?utf-8?Q?SnIOiJaLVrOTn7n3/LLyEY1+J?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d17bdb2e-d053-414e-75a4-08dd7d4686a3
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 00:26:41.9520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u8sSysslfetaTDprWjHwYsJQr81oDNprvmJe9GqVdZ0UEY57PpyFiCOliJJ06WzBSNKyL05lBZmCwW1l1GJ8vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR02MB5960

On 2025/4/16 20:22, Mikulas Patocka wrote:
> 
> 
> On Wed, 16 Apr 2025, LongPing Wei wrote:
> 
>> A BUG was reported as below when CONFIG_DEBUG_ATOMIC_SLEEP and
>> try_verify_in_tasklet are enabled.
>>
>> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
>> index 9c8ed65cd87e..bdbd79e76f96 100644
>> --- a/drivers/md/dm-bufio.c
>> +++ b/drivers/md/dm-bufio.c
>> @@ -2424,6 +2424,10 @@ static void __scan(struct dm_bufio_client *c)
>>   
>>   			atomic_long_dec(&c->need_shrink);
>>   			freed++;
>> +
>> +			if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep)
>> +				continue;
>> +
>>   			cond_resched();
>>   		}
>>   	}
>> -- 
>> 2.34.1
> 
> Hi
> 
> Thanks for the bug report. I think it is not a good practice in general to
> hold a spinlock and loop over a list of unbounded size. So, I modified
> your patch so that it drops the lock after every 16 iterations and calls
> cond_resched() with the lock dropped.
> 
> Please, test this patch and report whether it works for you.
> 
> Mikulas
> 
> 
> [PATCH] dm-bufio: don't schedule in atomic context
> 
> A BUG was reported as below when CONFIG_DEBUG_ATOMIC_SLEEP and
> try_verify_in_tasklet are enabled.
> [  129.444685][  T934] BUG: sleeping function called from invalid context at drivers/md/dm-bufio.c:2421
> [  129.444723][  T934] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 934, name: kworker/1:4
> [  129.444740][  T934] preempt_count: 201, expected: 0
> [  129.444756][  T934] RCU nest depth: 0, expected: 0
> [  129.444781][  T934] Preemption disabled at:
> [  129.444789][  T934] [<ffffffd816231900>] shrink_work+0x21c/0x248
> [  129.445167][  T934] kernel BUG at kernel/sched/walt/walt_debug.c:16!
> [  129.445183][  T934] Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
> [  129.445204][  T934] Skip md ftrace buffer dump for: 0x1609e0
> [  129.447348][  T934] CPU: 1 PID: 934 Comm: kworker/1:4 Tainted: G        W  OE      6.6.56-android15-8-o-g6f82312b30b9-debug #1 1400000003000000474e5500b3187743670464e8
> [  129.447362][  T934] Hardware name: Qualcomm Technologies, Inc. Parrot QRD, Alpha-M (DT)
> [  129.447373][  T934] Workqueue: dm_bufio_cache shrink_work
> [  129.447394][  T934] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [  129.447406][  T934] pc : android_rvh_schedule_bug+0x0/0x8 [sched_walt_debug]
> [  129.447435][  T934] lr : __traceiter_android_rvh_schedule_bug+0x44/0x6c
> [  129.447451][  T934] sp : ffffffc0843dbc90
> [  129.447459][  T934] x29: ffffffc0843dbc90 x28: ffffffffffffffff x27: 0000000000000c8b
> [  129.447479][  T934] x26: 0000000000000040 x25: ffffff804b3d6260 x24: ffffffd816232b68
> [  129.447497][  T934] x23: ffffff805171c5b4 x22: 0000000000000000 x21: ffffffd816231900
> [  129.447517][  T934] x20: ffffff80306ba898 x19: 0000000000000000 x18: ffffffc084159030
> [  129.447535][  T934] x17: 00000000d2b5dd1f x16: 00000000d2b5dd1f x15: ffffffd816720358
> [  129.447554][  T934] x14: 0000000000000004 x13: ffffff89ef978000 x12: 0000000000000003
> [  129.447572][  T934] x11: ffffffd817a823c4 x10: 0000000000000202 x9 : 7e779c5735de9400
> [  129.447591][  T934] x8 : ffffffd81560d004 x7 : 205b5d3938373434 x6 : ffffffd8167397c8
> [  129.447610][  T934] x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffffffc0843db9e0
> [  129.447629][  T934] x2 : 0000000000002f15 x1 : 0000000000000000 x0 : 0000000000000000
> [  129.447647][  T934] Call trace:
> [  129.447655][  T934]  android_rvh_schedule_bug+0x0/0x8 [sched_walt_debug 1400000003000000474e550080cce8a8a78606b6]
> [  129.447681][  T934]  __might_resched+0x190/0x1a8
> [  129.447694][  T934]  shrink_work+0x180/0x248
> [  129.447706][  T934]  process_one_work+0x260/0x624
> [  129.447718][  T934]  worker_thread+0x28c/0x454
> [  129.447729][  T934]  kthread+0x118/0x158
> [  129.447742][  T934]  ret_from_fork+0x10/0x20
> [  129.447761][  T934] Code: ???????? ???????? ???????? d2b5dd1f (d4210000)
> [  129.447772][  T934] ---[ end trace 0000000000000000 ]---
> 
> dm_bufio_lock will call spin_lock_bh when try_verify_in_tasklet
> is enabled, and __scan will be called in atomic context.
> 
> Signed-off-by: LongPing Wei <weilongping@oppo.com>
> Cc: stable@vger.kernel.org
> 
> ---
>   drivers/md/dm-bufio.c |    7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/md/dm-bufio.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-bufio.c	2025-04-14 16:01:58.000000000 +0200
> +++ linux-2.6/drivers/md/dm-bufio.c	2025-04-16 14:18:44.000000000 +0200
> @@ -2424,7 +2424,12 @@ static void __scan(struct dm_bufio_clien
>   
>   			atomic_long_dec(&c->need_shrink);
>   			freed++;
> -			cond_resched();
> +
> +			if (!(freed & 15)) {
> +				dm_bufio_unlock(c);
> +				cond_resched();
> +				dm_bufio_lock(c);
> +			}
>   		}
>   	}
>   }
> 

Hi, Mikulas

I have tested my v2 patch with try_verify_in_tasklet enabled on my
device and the BUG is fixed.

Should we change the current behaviour for devices wihtout
try_verify_in_tasklet enabled?

Thanks

LongPing
