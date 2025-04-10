Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sg2apc01on2066.outbound.protection.outlook.com [40.107.215.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B5A20C002
	for <dm-devel@lists.linux.dev>; Thu, 10 Apr 2025 09:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744278261; cv=fail; b=l9ppXWXPDxQrHPtUqJxxapyahzDkgOyeD8zL/UIBn4VujN7MULGjpJzhErI0FG+027oFGWUEDKNAjDQ5yk7909Q849Q+B2gbMDlWUzrel74ZAp5UMv+knQuHi1zFHWEB1H3Iqp+1mZVausV9nt5HCD7ZxybySONpyA/fxRtaQi8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744278261; c=relaxed/simple;
	bh=hmI/iIEfjRzdx55skAkxARVpJhQCsK65yccsZvUGgDA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dP5hq3QKVaop6+OAKxbHPNHQEhjxGbX41LItNYdvgLrz8/atm1CGUuil3o9ah9oXiy9WymwQuqQa2SWTiwQ7X3mpZPVGa6Duj0UiWHFQvDnKGx0Ia3vvfvGv8q9T7DPXsr67iz7K5TWDN9Xz6PkQ4WuCsVgu3b5uzarJBUCnVRA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=mN5RIAWr; arc=fail smtp.client-ip=40.107.215.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="mN5RIAWr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yDrKuqbwnZhUvu7Lqu4cNn5f2bOTPomsXHQqhoLtehHmzoeYY80896kLmMuFJzvVKs88i8hl4WdAYS3Fp9gCyElAg5MkG3PJ8e7GkzQTTIWCsVx1AfID9iILmjX5ZqyE8DCbwC0fwFbdrXZPL0D8D9x2Pac8pYLYGR5kt54f/yR2RoTcMtJ480yKEoahMG0/QHM6LovOR4ifaTHWTbuEa8uenZtQR0IkTJxOFCTUazscztp9E8LBH9NBanRvPPOzbXCORx/CxGv+PFPSSa8/FNO5AyY2MuddZzwnkWeUdlZRjWw1c+ZjQNJV4vXt+VfBXnzsjlVxnapj+CcvvseH0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yRL1MeYfNDwtTWwaU7O1zeu4Zurk1ndn6z50YATVuNQ=;
 b=B7EVs+A4yZMOmEtVo90s2wsXxgdisf+Ighb/RlWf3++BUUiSCOpzmAFhok+2UJRNg8ZxwMhh9TZNbx3x1YfaFhL5pJkGiNKbDc6kEm8RT+DQdDbIO1kPbgknTOLbUz2qNWROkvAqSe2mPM3AT2eP7ZAQb16+MnvVUzOQsF1Kb2m7vEs0MCAUVOoRRSIx5+R311pv/CLcfShfGawH7var+9OUmdgRDbTEYmvW+smxqdlw41I7h5kNnWTFmMkoLRtD3EhzogRhlQucfbjTp0ehCySJvnNQVCw3cr3vhfxCcz/TFDKuF98vbYCYfkc1i00fDFYYDu8RSfvH/1txbN5Seg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yRL1MeYfNDwtTWwaU7O1zeu4Zurk1ndn6z50YATVuNQ=;
 b=mN5RIAWrlEFXgcd/FaAvYsrmNTzjxXf6r5+I/vglzt9xbPD9ONd4IhAEGFiUc3WRyMJOGC8jR4bbxtmDv565uFjzDuSb7RdWCUbV/Pf32YNe0nkf3CfRLkDajKOgNevSXTJ4x4kIQZ4ncCpP2m2Dbxi0F5VZazg/jc5ptWeJSdQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by SEZPR02MB7644.apcprd02.prod.outlook.com (2603:1096:101:1f1::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.21; Thu, 10 Apr
 2025 09:44:11 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8632.017; Thu, 10 Apr 2025
 09:44:10 +0000
Message-ID: <bb8c52f3-628a-4567-ac29-449dbba0b892@oppo.com>
Date: Thu, 10 Apr 2025 17:44:06 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: Export __blk_flush_plug to modules
To: Yu Kuai <yukuai1@huaweicloud.com>, Christoph Hellwig <hch@infradead.org>
Cc: snitzer@kernel.org, mpatocka@redhat.com, axboe@kernel.dk,
 dm-devel@lists.linux.dev, linux-block@vger.kernel.org, guoweichao@oppo.com,
 sfr@canb.auug.org.au, "yukuai (C)" <yukuai3@huawei.com>
References: <20250410030903.3393536-1-weilongping@oppo.com>
 <Z_d07I1b71zQYS0M@infradead.org>
 <a3523b3c-4c89-44c5-867e-75378ebb652a@oppo.com>
 <21aa6521-e814-d3f9-2ba7-eb511e4ae8d6@huaweicloud.com>
From: LongPing Wei <weilongping@oppo.com>
In-Reply-To: <21aa6521-e814-d3f9-2ba7-eb511e4ae8d6@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR04CA0007.apcprd04.prod.outlook.com
 (2603:1096:4:197::19) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|SEZPR02MB7644:EE_
X-MS-Office365-Filtering-Correlation-Id: c237048f-ba7a-4544-faa0-08dd78143eb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dC9uWEVXeU80SjFSY0drSmxVZ2ttUElna2c2TW1qUDhkcEJySFlMb3FDS04w?=
 =?utf-8?B?bHFUcDFvR3VtdjA3OTFkZ2hwdE9CYmRiMmRIckdUY09KV2k2U0dYcHVQN3pS?=
 =?utf-8?B?NS96VmtsVnB3bGtveVFHMEFvUnJ5dFV5WmZZbWVHM3NzREJyMVVuNEN5OENP?=
 =?utf-8?B?OStTbHNBbFM1WUMrakFKUkdnRnBKd25va0tlOWJES1RaT2hjZGEzOXRKb21O?=
 =?utf-8?B?VXNZZ29RQ0lOMCs5ekhpMXQwL0tVbmp3b25ORG4xUnpRaGVuTFdINUtXc2JN?=
 =?utf-8?B?Uml2WjFHdVFUMWdXNml5MGdPWHRVT0k0Sng3YkhRbFl4elJUc3RJUFMvWFpU?=
 =?utf-8?B?NnJsNVVJcHhmZjRIT0dPMmZlemhoaDJZdW5oa3RrRU1raUQrdDl2VkNwY0Zt?=
 =?utf-8?B?ZVJ6TWlnOE1HcmxTc0FSOGtZVVhrQXZEaGptSTEwUHdpZE9ZL3dtMjZnNlRG?=
 =?utf-8?B?ZU53ZkRiVjhKWHE1dTdDeWpUOWIwUXpIazBWZWRrQjBNVDhMTFk3WHRHVDZU?=
 =?utf-8?B?bTUyTC9CUnBONmtScG9iVCtnZ0xXM3U5Tm1BMzEyVjQxVmdDVkM1YUtrODJy?=
 =?utf-8?B?Y1g3a2FiZThLSS9FVGV0clByRmZ0aktqVUpvSk1xbXhmd2NpbDVKb2lua2Fh?=
 =?utf-8?B?YmNVVnhlM3JrcUVyT1lLbXUvNGVXV0NoTUJBWTJjMFVweVBoSVhxTUZ4ZFpZ?=
 =?utf-8?B?TUFOMmFzejJYOXF5c1Q4eUp3bU5oYkVTUllBUjlWUzJGdk94eHN4bXcrK0dL?=
 =?utf-8?B?SlRLNEtxZDExVlRMWEtjWEFkYUxXaXg2UXd0a2pPVlhkRk9TVkdHaUNRSDlo?=
 =?utf-8?B?ci9jUk56cHgxL1dvZ2lMWWxsVDh4Y3drS2hMUHU5L25oRDJ1dXpFTEJRSFc1?=
 =?utf-8?B?SVQ0T1pCNlFoN0FKV25OMTJYNWZhUGZMTDhBdUV4WWpNbzR6OVNvbjJ2eER0?=
 =?utf-8?B?NXBERjY4MHptREE5bEUxeERsd01UUTQ1KzRiV3NGc2tSNXZMMFZzTVNselg4?=
 =?utf-8?B?MkdxWGJ0Zmo2dUV4QTJIOGpWTmhRNy92RVFBRjl2NE1CYll6Wjd3S2grNC9v?=
 =?utf-8?B?L0pUTHdtRUN2R2xwbHRrYVFOaTUyZ0lJUHFqcHFWLzc3RE5tNFJKa3BZZnVZ?=
 =?utf-8?B?WndVRVdzd0NTcmhLd3NsTkhqWnJCeTAxS3R4TjhSQ3R2UGVMbXY3RGJLc2h0?=
 =?utf-8?B?ZDBpRCtDaUJVaVhZeGVtUTk4ZjVSVC9ZTlRjUFBuYWdkb09HTldaTDFZZU1s?=
 =?utf-8?B?d3p5OFN6TDkxaTBOZTdJOURzbys2VUNySzByZlQybk94ZmZSdXpzaVMzRVhS?=
 =?utf-8?B?RGFnRnNhU29IZ2hVUm1hNmdXVmMzTkx5ckxTNXBTSFVERHVCZWFrSEgxSmZO?=
 =?utf-8?B?cGd4Z0pkZEFRNXpqSTBTazJnSE56V25IbWZuV2RPU3IzTFZFLzhCTm9DYzd1?=
 =?utf-8?B?TUFTU0ljbmZ4YncvK1hOTHpOVmQ3Qi9pWk9GMnNTeDgyY01uRWVXYTRLZDVu?=
 =?utf-8?B?dzFZYkFveVd2cHFsMVVtNzlueEdiV0FhM2EvbDFtazhGQ1drd0JSVzhqd3Zm?=
 =?utf-8?B?YjdQR3owMEpGbGhnM1hFU2xOT1lkN3ZpelhwTXVLbThUTmhSaFhnYUZjYjV1?=
 =?utf-8?B?UjRuaEdjWnJWb0Q0NkMyWkEza0Y1aCtQNlZ0Wks1dSt0TTZYU2VQTTR3UnVh?=
 =?utf-8?B?MGdrSHloaFBkS1R5ZlV3a0RiL0JPZ29LUU9uL3hRRzVHSW9lemVtVUtyNkJD?=
 =?utf-8?B?Znl0S21XNjhTMUJFRUVWZVpKQmhPWTRJTHdLNkM4NHV5TE5pR0VGRjR4NGdB?=
 =?utf-8?Q?H2q81Y/xdRBYFUQE/ygSoM112Z3HnhcVYo1SY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SFFhSy9TdDlsc0RHclBrMTh4RGRFT0Zud0VnWGNLZlYzeHhmVWY5QUgxQ1JC?=
 =?utf-8?B?RTVrWWRSOUtSYzNmNWdiY3JaNjhiUFNQWTVzb0JialhxRDd3eVFyUmc0amg3?=
 =?utf-8?B?b0g2YnJERk5Wd2c0UzRKOER3ZkZQVzNHK0R0S3NURDZFdy95MzEvVWxmbkhC?=
 =?utf-8?B?ZU8wam5vU1lBYUFaYkdEbHNJUnZoVUU2aDNKaXF2eU8vSlhrNzZoY0ZmdlpF?=
 =?utf-8?B?UXFIZk5FRVI4Ujg3VEpsdUNQL3F0Wkt5WUVFZlZhZWozQjZFNHVpN1FmSUpp?=
 =?utf-8?B?L3NIeCtidk54WHZKRnN0aGxzazdzM0dlTVNwbmw4d0RnTmdaWjd0a3c3OWNt?=
 =?utf-8?B?Vkl4NzU1cS9zb0hLZEY2bE1XTDBSMmhEV0c5NkFVMllPdlRuc1F3a2hpUXp2?=
 =?utf-8?B?dGcyd1B3R3NDTzI2L1F3QjB2SGF6TTZXMVpQV2RKNW4yNThiUEdZY3BnSHRZ?=
 =?utf-8?B?TnEvL045QUF4NzkralpMejNqbllqYytQOGtDSVFyUmUyNlo1bGNrdUlPZExP?=
 =?utf-8?B?cG5GMnBINitKaG1XUVUwbUl0V25yTFpnSGRaYjBjK3k3djArZE96cVBIOXk3?=
 =?utf-8?B?V3RKTXYwS0VkV2JRNUhSQmFWeXNKUHFqeXhsSWl5MlZRMFdMaDl1K0s3T1Jt?=
 =?utf-8?B?QjlDeERielZZNWlVUElVdk5WQnliU210WFgwY0hDUjV4SFExeCsrdEMwNWlr?=
 =?utf-8?B?VUxOSTc1eUlPTWt4M09HR2t5SzhWUzhOSFhraEl0bmtDUTNaUU16N1ZjajZi?=
 =?utf-8?B?N3JHNjVGTmxJMmZET2o4QjFOM1FEa1M2ZkJlWHBlVHI3SFVKWm1kOFpWYWww?=
 =?utf-8?B?UlIzejJudFM3ZzgrdXdDZkpnRTA5dzhCRkhjdXY0ckU4UWtSM29PUitIakZv?=
 =?utf-8?B?SVhSQUtGNUlqSm5LYi9kaEJWRVVBZU5UTVB6TGdFSmdSTmZBZlZqV3MwUllI?=
 =?utf-8?B?bkl0V2g4TFU3cnN6eHJMOVcybjdJUXNDMDVjWnp3YkdGNmRXRmlzOGNaOStM?=
 =?utf-8?B?dndsRktNUDI0cHUrckZXM0tKcUlqV2xmK25xV1QrTWRrMFhYL0ZGaDJiMEZo?=
 =?utf-8?B?WmdUTWdhYnBVa29jOCs5M2dMcm1YU2JQZWZwRFZsdjBncDNsNTJOaXhPN0V0?=
 =?utf-8?B?aDVmdEdFVWt3RlZVWjFpTGZEczd3Z0VCQlFmdWxmRHNnb2kzNnZWTEQ4NThE?=
 =?utf-8?B?QjNYV2E5K1ZEcXFwNDlseXpqWEsvQXhXTmppU1NWTFo0UFlSSno1N2ptb2Rt?=
 =?utf-8?B?TG0xYmRzTkErTG8wMytOUVF6emJFK3ppTm1EQXEyZjI0UU9YV2JsTWFib0pE?=
 =?utf-8?B?VTVkTmZ4Z3NGck5Iby83ZEIxbjdiNnV0SFByeTJQMkpzWmtNdkExbkF1TUFV?=
 =?utf-8?B?RlkzUy9NZHAxWTZvb0QyL2J6MDdEWC81K1h1OFY2TDRyOHlrM0NWYmhieXVu?=
 =?utf-8?B?bDJIS21vaXg4UzJOeXRNS3N6R1NqVmloTTJWRWR1K0ZmWm5tVzJwTFVJdDNZ?=
 =?utf-8?B?ZG03N0NwZ0Z1bkM2TDU3dmxZMW9YSC90OE50cFY1dm5HQkRtSHNQakdsalNq?=
 =?utf-8?B?Wjc5Z0dPbGVmOTZ3VXlyWHFVWmNLaFVQcHJUMEdHbHJOWCtOb1JFczVtY1RT?=
 =?utf-8?B?WngwQ2dzdGFRUkN5YzZqbGhXL2NYQTAyZ0doWFh2WWJOK0l3blZ1SVpyV2Ey?=
 =?utf-8?B?MEJrSEF3K003alkyUC8rWFMzd29odkY5VFNvOWZNVXRqaHBTNldoemhDcmg4?=
 =?utf-8?B?eDNzVjY3enlZbkphSTh3YnByNE0vZDVRMVJ5Q1Rpck5LMXMyKytxcUJQRTJE?=
 =?utf-8?B?MS91N0luc09JdDNZajZhVzhxbGFCR1NWR3JzcjNzU0F3Tzc5WkRrSVo5VEJT?=
 =?utf-8?B?Q0cyYk56bitNUm9LeGNmeTg1WjR6UXc5c2Nnb3d1ZWtndEU5OFVCbVJtNzBn?=
 =?utf-8?B?ZU1ob3UwaG43NkZjSGxnT2F4cU01TXZxaWxlbDMzSnJsL0hOaWZySjZ0ZkZx?=
 =?utf-8?B?N2N4djF3NDFlK0tQVTYrb3ZWQ0pVTm1rRWVIalluL05JQWJwdXIyZ242TWtt?=
 =?utf-8?B?YXdvNkhyc1Q1NDFSM3E1YTk3dTJoUU1ENU81M25RaTd3VjJMVmFhS25Vbis3?=
 =?utf-8?B?cGFMS1JaWnB1M2RhYWs1dlErdGdxNnRiUVlTclBqZ1YrcXozWXpEcm9iYkE5?=
 =?utf-8?B?N2c9PQ==?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c237048f-ba7a-4544-faa0-08dd78143eb4
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 09:44:10.5920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Unz7ezQhEzOl7drmnG5+JzaJSe79FDiWJzo0Y4VlmzpMauAzNeB0/iWUjh8kGJduo4wyI8lGyrmQHnnzJQnUuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR02MB7644

On 2025/4/10 17:11, Yu Kuai wrote:
> Hi,
> 
> 在 2025/04/10 16:06, LongPing Wei 写道:
>> On 2025/4/10 15:36, Christoph Hellwig wrote:
>>> On Thu, Apr 10, 2025 at 11:09:04AM +0800, LongPing Wei wrote:
>>>> Fix the compile error when dm-bufio is built as a module.
>>>>
>>>> 1. dm-bufio module use blk_flush_plug();
>>>> 2. blk_flush_plug is an inline function and it calls __blk_flush_plug.
>>>
>>> Then don't call blk_flush_plug from dm-bufio, as drivers should not
>>> micro-manage plug flushing.
>>>
>>> Note that at least in current upstream and linux-next dm-bufio does
>>> not actually call blk_flush_plug, so I'm not sure where your
>>> report comes from.
>>>
>> Hi, Christoph
>>
>> Stephen reported that a compile error happened when he tried merging
>> device-mapper tree.
>>
>>> Hi all,
>>>
>>> After merging the device-mapper tree, today's linux-next build (powerpc
>>> ppc64_defconfig) failed like this:
>>>
>>> ERROR: modpost: "__blk_flush_plug" [drivers/md/dm-bufio.ko] undefined!
>>>
>>> Caused by commit
>>>
>>>   713ff5c782f5 ("dm-bufio: improve the performance of 
>>> __dm_bufio_prefetch")
>>>
>>> I have used the device-mapper tree from next-20250409 for today.
>>
>>
>> More details are here.
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux- 
>> dm.git/commit/?h=for-next&id=713ff5c782f5a497bd0e93ca19607daf5bf34005 
> 
> So, this patch has compile problem, I think it should be removed from
> dm tree.
> 

If __blk_flush_plug cannot be exported, this commit need to be removed
at first.

> BTW, I don't get it from commit message, why you need to flush plug when
> bio is not contiguous. Other than bio merge, plug is also benefit from
> batch submitting:
> 
> __blk_mq_flush_plug_list
>   q->mq_ops->queue_rqs(&plug->mq_list)
> 
> Thanks,
> Kuai
> 
>>
>>
>> https://lore.kernel.org/dm-devel/66bf8a8e-0a7d-47b8-9676- 
>> dc2e8c596bdb@oppo.com/T/#t
>>
>> Thanks
>>
>> LongPing
>>
>> .
>>
> 

Previous discussion is here.

https://lore.kernel.org/dm-devel/20250325104942.1170388-1-weilongping@oppo.com/T/#ma327528c69f6fd62e15febb5c94164c8e10c7c0d

> It seems that verity_prefetch_io doesn't work efficiently.
> dm_bufio_prefetch_with_ioprio
>    __dm_bufio_prefetch
>      blk_start_plug
>      for loop
>        __bufio_new
>        submit_io
>        cond_resched
>      blk_finish_plug
> 
> If more than one hash blocks need to be prefetched, cond_resched will
> be called in each loop and blk_finish_plug will be called at the end.
> 
> The requests for hash blocks may have not been dispatched when the
> requests for data blocks have been completed.

The change ("dm-bufio: improve the performance of __dm_bufio_prefetch")
wants to decrease the probability of waiting hash blocks in
verity_end_io.


Thanks

LongPing
