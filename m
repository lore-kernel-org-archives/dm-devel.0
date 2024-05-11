Received: from HK2PR02CU002.outbound.protection.outlook.com (mail-eastasiaazon11010001.outbound.protection.outlook.com [52.101.128.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF14753379
	for <dm-devel@lists.linux.dev>; Sat, 11 May 2024 11:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.128.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715425728; cv=fail; b=ut+++K6G0kq1i+qszYGwWWFBYHIybJl6PXgrZKam7j1wEFgbbbImjeFj9tq5fBEC8vkre+wNPd2E09lxdMDtO+YOcCeLoseDJ+hVxGrX/putxWE9s8YJhYZ34rCn5ZotTB7oHoCRwbarhrYElgMaWIZsRksRkQtlHmqBgRT1Ung=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715425728; c=relaxed/simple;
	bh=7klhX6iAxIxavWR0Rau+r0ZWuVHm+bVWl293jwK1Rqg=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sxokR6yHeI6O5c9bkXB+bYweCx+Q9IGz51IAMWeDdBJ+ppBls+P97qL0Oet2ABV2mdupgiPycA6PayGR+3r2Tbt2bnno+E5YpKHzvn3WU23vgKH84nXxzPFsfEYytTAeN1yuCb2XPD86oXcUdOizleDh8SSpAQr60qE7yrfVXAw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=SesimEFu; arc=fail smtp.client-ip=52.101.128.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="SesimEFu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n1KfiExQoDvur+80zB2cYQYtJJNDQ78EtmM2qEXNIftjsxqZ+ialge9ZRlYIHbVSn9vPakl99sOGdV8EiApiN8e4U4Q3yKDXzSHoSoWbWFLUOGY+XtYcBHADnqSQ0xMWisebi35St/K4UZ2GSZFzQMChYzM7tESMr2gaIAJQXJd400Izf0tkNpgyoCegF9PZAYWRm51dXHy6lfncZXfmnC7DMGQbrmvdX+e+GWPraTYQXyxsqx8JHURxerz/e+h6nZBGkSgf33euUOq+7eaFBJ0RcJaldiPdMxZ3ZY2LVEEe4EgSc4aa3T70dcJVebLNzuatiZmCCc5J+3sqFg78FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gH0fUQ4zGiNNj82A/GMQTgUOkZeBbE+M1eenHfjiaPE=;
 b=adPwRvqw9mqysyGFxbhwVEkieE2T/j4atjb92Pe2EdaEPEni1oMJ5Ne3rnHpoUsbuOT9daErw85yVqFlV1uiaeipmqjflYROC521jZUZrY6FRRIYbC+L5eXbZa+I/ak96znJanBc/8LfgQmLy6vUxqnA5MsGIwoI4/H4HS1P7mUmBnYpck6Lf2d/wjsWRB4V6B/Hzx9hQL1QvzF+sWMRG3bJTTmA8c4qpKVesKFotOTVVstwuvKKAfW9QJnE5mgh2MBuMVdhg7iVh4XPP+DrTehek8qkEhezhNOsGBlPClnyGudyoSKlOH7TFsn0BNfLMHERmHV+Umb03XWvtkV3EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gH0fUQ4zGiNNj82A/GMQTgUOkZeBbE+M1eenHfjiaPE=;
 b=SesimEFuhHCJKMoN8+7O7xl7K6VoCu7bAX98ZLR+Eh9hEqj7DNiMvTsk+sjdmw06du0AwH0O9wJ4dOLCUD/HvkuuMm8AoeXaZZrMursSZ2hgNgFTxh8fCLbhB3l2j4esIM51FCvp+Ftw2sjXWzmD7CJxo0UzudV5cRnBo3uaEIIYpdGwEzJrY9YwtY57b5vAIi3U7tRxvhjCkdIMC+nu8rF3siZwylV840RnzJUsNelRX5d3YA4Op5k3B2CSFdqKWJnz8f9wvV0P+dAJU4PKOV/ufUxeZU3RjCOHPUGNczh9X69GqxqdfmRCnW+Xe14oUacRd70qc/DdAATCUAKOFQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com (2603:1096:400:42a::11)
 by SEZPR06MB6303.apcprd06.prod.outlook.com (2603:1096:101:129::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Sat, 11 May
 2024 11:08:43 +0000
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::af33:ff9c:cf31:45e9]) by TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::af33:ff9c:cf31:45e9%3]) with mapi id 15.20.7544.052; Sat, 11 May 2024
 11:08:43 +0000
Message-ID: <c1b45434-6341-4e26-a376-4f434df2caf0@vivo.com>
Date: Sat, 11 May 2024 19:08:39 +0800
User-Agent: Mozilla Thunderbird
From: YangYang <yang.yang@vivo.com>
Subject: Re: [RFC PATCH] dm: Avoid sending redundant empty flush bios to the
 same block device
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240422100540.2213-1-yang.yang@vivo.com>
 <1f741e4d-c33f-a2e3-f4dd-d7f613443534@redhat.com>
Content-Language: en-US
In-Reply-To: <1f741e4d-c33f-a2e3-f4dd-d7f613443534@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0019.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::12) To TYSPR06MB6411.apcprd06.prod.outlook.com
 (2603:1096:400:42a::11)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYSPR06MB6411:EE_|SEZPR06MB6303:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f919cb3-e5fe-4a34-92a9-08dc71aab895
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eDlWUEE5aUNXQktYTVpBMG5sVmo0MWpYdDJVY2FOVjY0eFBIbG4rZzJvczdN?=
 =?utf-8?B?T2luY3ZsSmdCMFA0d25kbVdTL3Rjbk9QZUZVOS9WM3kvZFQyU2lPdHNtQ0hs?=
 =?utf-8?B?VHRadjQ5N1lGR0pKUExuYkFQc3E5R3BhQ1VTL1hTNVJFd1g0L2xlb2Vla01J?=
 =?utf-8?B?VUFvTlVJdGszb0pVK09nWUltUk1zUTcreWdhQ004dHZ5UytFQkFRV0Z4Z2ll?=
 =?utf-8?B?amxvdUd3UTR0aElpZGhBQWpJWUxZTXJYYjVGVGZWcm5LM0dWK1hNSjc2WWNj?=
 =?utf-8?B?RjI2RXM0WVlhejBjem1YZHd1UEg1aEZTdUFEUmZmTnF3d1hFaU5JSm5OMFFz?=
 =?utf-8?B?MnFXWmVzSkVab0luc0w5Z0NzSlFrWXdmb2pCUGViRGQrRlJKL2J5V0tmR3VT?=
 =?utf-8?B?REk3aVNndHRFWkMxL2hNbnNkQ0xzNzRoQ2cxSGlTM2dNZjFWcDZucUQyVWpX?=
 =?utf-8?B?M1gxT1ZZM1VTZFNtR0dGN3NFUmQ3ZnA4K2E1S0ExdEVwMXZRZGk3d2NyQ0wy?=
 =?utf-8?B?eWpXMUFRN0NJOFBBeDJDOXJjTzZMTUF1UzlUelFXeEtuc3hoa3oyMlJUZEY0?=
 =?utf-8?B?TWJwV2dRbS9vbWtZK3VSQjBEUUdocDVuRU02UkU4NHRBWGJEMzlKQkJHN2cw?=
 =?utf-8?B?V2Q0R3dIaGsxVElmcDNMVGg4bVQrb1hYRlh1SzlSOEhpSHduUWVITmF1TnZy?=
 =?utf-8?B?K3UvLzBLTnRJc3ZsbDlZdzdNN3QvdWE4R3FOSk5TVnl3Rllad1lYK1FHaGph?=
 =?utf-8?B?MDIrVnd0a2ovNlZONWd5dGltMDdtT3NoTnZYUGFlLzRzWVV2b2lvaVNod2FR?=
 =?utf-8?B?TVRVWG1zSVhVd1ZxeHhxdFc2WUwyMXVDOG9UQkU5Y1lzdXBXeDlSMGlUZmtk?=
 =?utf-8?B?a1FwRFVsWTE1V242OVNKQnRLMTVCdFJHQkNiS2VXUFVDaEs0UlZIdGtCZ0w5?=
 =?utf-8?B?eEF1ejgzd3d2KzY3d05yM2F4Z29jNFc1WTNNMU9QVGVXNWxrMlZnd2F1a3ZV?=
 =?utf-8?B?QjRIZGpla1l2T1lyUXUwL2g0WG8wYzUwTjZtRHgwaTlPMm5XUGhyUm1nVGNS?=
 =?utf-8?B?bExZWWh4TkRzYS9WQVVvK3FhclZWckFrYkNMM3YvekdwOUVIczJZTzV4N2lv?=
 =?utf-8?B?YXlDdnRoVHkyQlVNWGplVlFMMGRaNTBtTFk2dkhJaGVwNU5NZUEvbEJTMlhZ?=
 =?utf-8?B?UldVYjdBVEJtOWxwOE9lSS9zd2tVSnFpa3VHMWs5UnU2WERwVENudXo2cmJQ?=
 =?utf-8?B?blNpNUwwU1pnMFd2SThpSVNGeWVzT0lGYkJqbFhEQUd2S0MyNXNZeDJXdmVv?=
 =?utf-8?B?QzduS2hYZ3V1Yzg2L2REQlVtd0ZrcjVWVkNrZVNaampFM01mN1VuR1NCRnVt?=
 =?utf-8?B?WlZrbW9IMFhnWHBkUkE4TWJGTlNXbzViYlU3ZkVJaEpXd0ZRaUx0ajZvZ1Fk?=
 =?utf-8?B?WDF5MmV2RXNSSzFVa0pKQkhweXQrbnlxZFRDT01hM3JNNDlOTlVzcjhySG4w?=
 =?utf-8?B?RWZ6N3JNRGZGMlc4am03NjFmeEpPZVJNckptYUpSdDZDZGpzMUVmZ21UVk5m?=
 =?utf-8?B?Q09YamxTSXQySDRaeURKQTlmWk5PWVBLRG1IQ2JqV2NYd2NpZkp0d05TZlRU?=
 =?utf-8?B?bGNhVGhRUUNlSHYzQ21teEpJL1FVckxzK2ZmdE42VDkwUHFCUkd1ZHFtWm5v?=
 =?utf-8?B?UVhyeStmRnF5MHZqT0lKUlpqUTdHODBkaWV0ZS9IZ1dqVEY2dHhjVWJRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6411.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TW5xSWhSNitVeitzTDVBOStuMm1uTWM2YUppa0xaZXNpcngwMUdsQ0ZIbm5k?=
 =?utf-8?B?N2F5aHdkblJYRExXVU9FL2c5RktWK3VTQzVESnBBUDE3eTR4YlpmcHBUOUNh?=
 =?utf-8?B?QnZSZlZpSlZZRjFZNy9HTGZ2ekJlV2d0VjBWaVA3M2tDbG5hWlBkamhBUTZE?=
 =?utf-8?B?cTdwOVY0ZmhJN1hGcnVqd3hva0pXSW1vMldINCs1T3VEeWFxRmdNUGRkSy9G?=
 =?utf-8?B?YUl4eE1kemZRamdEenZidUlvR0NFbUpibk1wVjZldEpVSjh0U1d3UTczRWxM?=
 =?utf-8?B?aHNtZzlqS2hFQU51MkpXSlBLVklPSzArWDlTK1hKUDdCcURwamN4UndBRFc4?=
 =?utf-8?B?bXgxRVlLQVlFbThyM2JPdHluK205K2hTZXdsYkRmZktCSXhQRk0veW1kSysz?=
 =?utf-8?B?UkFHeHZibTFZOS8weU1waFAxdnV4cENBN0k5RTI4LzlmQ1dHNzUzN0Z6blVN?=
 =?utf-8?B?QU04NW40ZkcxTHptSXJLV2ppWlpjaUVtb3FERmVZWCtNeTBWWjYvdVcxbkZq?=
 =?utf-8?B?bHZQYzhtWE5xSDg1dWhTa0NtZlAvdDFBVXl4WnZUd0RmU2kxM1ByMkk4TGh0?=
 =?utf-8?B?QUlqdlBvV0lPekFHRjdJZERaYTYxTTlaenV1SmFNeG5mNm9MWjNpZW1nNW53?=
 =?utf-8?B?WUhKaXJVMEk1YmtFOWZDdHVIUU1hR1p6cUcya1EyMm8xSG5UdkhueGI1U1RN?=
 =?utf-8?B?N05iS0tyZUd0QTRwVlY3U1pvb2I4UmFveVg5bnhBNDZMWnkzb3ZFNTlPdko2?=
 =?utf-8?B?bkk3cmpZOFZSZzk1blFITEIzL1p2NVdYQklZSFFZSWJoSTVEdUxic2QydDZ4?=
 =?utf-8?B?dWtYbFV0QXkzcVpEcmo1ZjIxSlZWTXY3TWkranluNUxyRlRVTVYzZzdJS0tW?=
 =?utf-8?B?RFJhWS9aVzZCdlpXa3A4ZXRGRUNiZVFlZmxWOWx3ekJITTF3ek9NcytuYzdW?=
 =?utf-8?B?NXdMQnU5aUtyWm1IZ2M3Y0pmOEZBWTBZV1lqU09JeWUxdDRpUHIzZGZ2VVN5?=
 =?utf-8?B?RTZOTEFNcFFTeXZEUkRTcFFWckJjRmdJeENCdUgxSlZ6ZGxPZU1PZ1QxcHhJ?=
 =?utf-8?B?bkltd0lEWGs0djRsQlZDdmw0bzY3SnUxeEZXQTRVYUVhWWhzWmEzT09EdE84?=
 =?utf-8?B?L2tPekd5cHZ2aUlnQkpNeGtOVS92alowSkJWSDVldDM3bkFWMFI5U3F4aVZl?=
 =?utf-8?B?b3IvQlNYSkczY0h5RmxvN1hpcTN1Um5wRjR4QWFrWE9mTjcvMHA5aDNMTi9P?=
 =?utf-8?B?bTkwaUtKME1uUUpybm80VUxvanpHQjBuV1E3bmI2V2dFTGU4MkVzMXZobGEr?=
 =?utf-8?B?WE4rdm9LMnE0aXkySnIvNVB4aHFVanVQZ2FoTEd0ZUdsK2tIVWsyNEZsbllV?=
 =?utf-8?B?b0kxZUR4UXVWUHZ5ejdFMmthWFZQTit5Y2YvenR3S1BzbG1HbmpVK05jWXcx?=
 =?utf-8?B?b3E5RDlVNXRFYTBsQm5UME8yU2NtUmx5OGdzYzQ0ZC95d1dITG5iR3p4cjFO?=
 =?utf-8?B?RUZJeHluMU5Rc04yV1F1d1IzS3pSYk9DakZ4b0Q0cFBZdCt0ckFWOWkyY0NB?=
 =?utf-8?B?MlBPV091by8xalRPK3I0WFRmaDdqZTJZTTVZRmdGeHFrdGpwYlNtbVY1YlNK?=
 =?utf-8?B?NVlMWGdmeXpYU3lJdFBxeDIrTkxNejJZa2NVbFJtL1hza0NFUUU3VlVMTFlR?=
 =?utf-8?B?RkovM0ZvaS92VEN0d1lKUWhCN2x0VTZSL0xVZjA4WmJOOEZqNy82cnRUMkJJ?=
 =?utf-8?B?ZXAxTG9WRm9rL1gvZTBQVFRVNXNwMytESjNWWlpISGFLOXRVcXkzZkgyYW5M?=
 =?utf-8?B?UU1ZWkh6dllud1FxN0hYQUNmU0lpdENYQWlNNHVyYTBTeHh3aC9lRVhnZXdQ?=
 =?utf-8?B?VmlWeVgza2lJYXhwVHA4UGNjS2JQTkZ1MGxpVFdqS1dFWnRZb3JjVVJPQjFk?=
 =?utf-8?B?amY3NmxsWWp1citDYjVMY3ZvbitkQ2svQU8wUUV0aFJrSm14VU9xMDgrRTdv?=
 =?utf-8?B?Q202UXNibXd2ZmFIdnhnOXNMNUdXVzNrZWtuWlY4MEJCY2k1b0RDRW1WcWxZ?=
 =?utf-8?B?eXZ2cFM0VFFPYXlMTHlDOU4vcURvWWY3Z2dIV3JEVW56V0lic0krUzdwYXcr?=
 =?utf-8?Q?cbD1qpJyHyD5vGg+HWkI9E+Tn?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f919cb3-e5fe-4a34-92a9-08dc71aab895
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6411.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2024 11:08:43.6260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W4NkMa+QBbcD+FDS4ohL6S8lnKymSiG1nE2mH9zXp6vuIkdOFJTd963Ntbv7HpZVmfW9tPreKlAu2LXykcVYDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB6303

On 2024/5/10 22:08, Mikulas Patocka wrote:
> Hi
> 
> Regarding *bitmap = bitmap_zalloc(t->num_devices + 1, GFP_KERNEL); - you
> can't allocate memory in the I/O processing path, because it may deadlock.
> Think of a case when the system is out of memory and it needs to swap out
> some pages and the swap out operation attempts to allocate more memory.

Got it!

> 
> Anyway, the patch is too complicated. I suggest to try this:
> 
> * introduce a per-target bit "flush_pass_around" that is set for dm-linear
>    and dm-stripe and that means that the target supports flush optimization
> 
> * set a per-table "flush_pass_around" bit if all the targets in the table
>    have "flush_pass_around" set
> 
> * in __send_empty_flush, test the table's "flush_pass_around" bit and if
>    it is set, bypass this loop "for (unsigned int i = 0; i <
>    t->num_targets; i++) {" and iterate over dm_table->devices and send the
>    flush to each of them.

OK, I will do this in the next version.

Thanks for your comments.

> 
> Hopefully, these changes will make the patch smaller and more acceptable.
> 
> Mikulas
> 
> 
> 
> On Mon, 22 Apr 2024, Yang Yang wrote:
> 
>> __send_empty_flush() sends empty flush bios to every target in the
>> dm_table. However, if the num_targets exceeds the number of block
>> devices in the dm_table's device list, it could lead to multiple
>> invocations of __send_duplicate_bios() for the same block device.
>> Typically, a single thread sending numerous empty flush bios to one
>> block device is redundant, as these bios are likely to be merged by the
>> flush state machine. In scenarios where num_targets significantly
>> outweighs the number of block devices, such behavior may result in a
>> noteworthy decrease in performance.
>>
>> This issue can be reproduced using this command line:
>>    for i in {0..1023}; do
>>      echo $((8000*$i)) 8000 linear /dev/sda2 $((16384*$i))
>>    done | dmsetup create example
>>
>> With this fix, a random write with fsync workload executed with the
>> following fio command:
>>
>>    fio --group_reporting --name=benchmark --filename=/dev/mapper/example \
>>        --ioengine=sync --invalidate=1 --numjobs=16 --rw=randwrite \
>>        --blocksize=4k --size=2G --time_based --runtime=30 --fdatasync=1
>>
>> results in an increase from 857 KB/s to 30.8 MB/s of the write
>> throughput (3580% increase).
>>
>> Signed-off-by: Yang Yang <yang.yang@vivo.com>
>> ---
>>   drivers/md/dm-core.h          |  1 +
>>   drivers/md/dm-table.c         |  7 +++++
>>   drivers/md/dm.c               | 59 +++++++++++++++++++++++++++++++++++
>>   include/linux/device-mapper.h |  6 ++++
>>   4 files changed, 73 insertions(+)
>>
>> diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
>> index e6757a30dcca..7e3f2168289f 100644
>> --- a/drivers/md/dm-core.h
>> +++ b/drivers/md/dm-core.h
>> @@ -217,6 +217,7 @@ struct dm_table {
>>   	/* a list of devices used by this table */
>>   	struct list_head devices;
>>   	struct rw_semaphore devices_lock;
>> +	unsigned short num_devices;
>>   
>>   	/* events get handed up using this callback */
>>   	void (*event_fn)(void *data);
>> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
>> index 41f1d731ae5a..ddc60e498afb 100644
>> --- a/drivers/md/dm-table.c
>> +++ b/drivers/md/dm-table.c
>> @@ -2133,6 +2133,8 @@ void dm_table_postsuspend_targets(struct dm_table *t)
>>   
>>   int dm_table_resume_targets(struct dm_table *t)
>>   {
>> +	struct list_head *devices = dm_table_get_devices(t);
>> +	struct dm_dev_internal *dd;
>>   	unsigned int i;
>>   	int r = 0;
>>   
>> @@ -2159,6 +2161,11 @@ int dm_table_resume_targets(struct dm_table *t)
>>   			ti->type->resume(ti);
>>   	}
>>   
>> +	t->num_devices = 0;
>> +
>> +	list_for_each_entry(dd, devices, list)
>> +		dd->dm_dev->index = ++(t->num_devices);
>> +
>>   	return 0;
>>   }
>>   
>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>> index 56aa2a8b9d71..7297235291f6 100644
>> --- a/drivers/md/dm.c
>> +++ b/drivers/md/dm.c
>> @@ -48,6 +48,8 @@
>>    */
>>   #define REQ_DM_POLL_LIST	REQ_DRV
>>   
>> +#define DM_MAX_TABLE_DEVICES	1024
>> +
>>   static const char *_name = DM_NAME;
>>   
>>   static unsigned int major;
>> @@ -1543,10 +1545,38 @@ static unsigned int __send_duplicate_bios(struct clone_info *ci, struct dm_targe
>>   	return ret;
>>   }
>>   
>> +static inline bool has_redundant_flush(struct dm_table *t,
>> +		unsigned long **bitmap)
>> +{
>> +	if (t->num_devices < t->num_targets) {
>> +		/* Add a limit here to prevent excessive memory usage for bitmaps */
>> +		if (t->num_devices >= DM_MAX_TABLE_DEVICES)
>> +			return false;
>> +
>> +		/* dm_dev's index starts from 1, so need plus 1 here */
>> +		*bitmap = bitmap_zalloc(t->num_devices + 1, GFP_KERNEL);
>> +		if (*bitmap)
>> +			return true;
>> +	}
>> +
>> +	return false;
>> +}
>> +
>> +static int dm_get_dev_index(struct dm_target *ti, struct dm_dev *dev,
>> +				     sector_t start, sector_t len, void *data)
>> +{
>> +	unsigned short *index = data;
>> +	*index = dev->index;
>> +	return 0;
>> +}
>> +
>>   static void __send_empty_flush(struct clone_info *ci)
>>   {
>>   	struct dm_table *t = ci->map;
>>   	struct bio flush_bio;
>> +	unsigned long *handled_map;
>> +	unsigned int nr_handled = 0;
>> +	bool check = has_redundant_flush(t, &handled_map);
>>   
>>   	/*
>>   	 * Use an on-stack bio for this, it's safe since we don't
>> @@ -1562,17 +1592,46 @@ static void __send_empty_flush(struct clone_info *ci)
>>   
>>   	for (unsigned int i = 0; i < t->num_targets; i++) {
>>   		unsigned int bios;
>> +		unsigned short index = 0;
>>   		struct dm_target *ti = dm_table_get_target(t, i);
>>   
>>   		if (unlikely(ti->num_flush_bios == 0))
>>   			continue;
>>   
>> +		/*
>> +		 * If the num_targets is greater than the number of block devices
>> +		 * in the dm_table's devices list, __send_empty_flush() might
>> +		 * invoke __send_duplicate_bios() multiple times for the same
>> +		 * block device. This could lead to a substantial decrease in
>> +		 * performance when num_targets significantly exceeds the number
>> +		 * of block devices.
>> +		 * Ensure that __send_duplicate_bios() is only called once for
>> +		 * each block device.
>> +		 */
>> +		if (check) {
>> +			if (nr_handled == t->num_devices)
>> +				break;
>> +
>> +			if (ti->type->iterate_devices)
>> +				ti->type->iterate_devices(ti, dm_get_dev_index, &index);
>> +
>> +			if (index > 0) {
>> +				if (__test_and_set_bit(index, handled_map))
>> +					continue;
>> +				else
>> +					nr_handled++;
>> +			}
>> +		}
>> +
>>   		atomic_add(ti->num_flush_bios, &ci->io->io_count);
>>   		bios = __send_duplicate_bios(ci, ti, ti->num_flush_bios,
>>   					     NULL, GFP_NOWAIT);
>>   		atomic_sub(ti->num_flush_bios - bios, &ci->io->io_count);
>>   	}
>>   
>> +	if (check)
>> +		bitmap_free(handled_map);
>> +
>>   	/*
>>   	 * alloc_io() takes one extra reference for submission, so the
>>   	 * reference won't reach 0 without the following subtraction
>> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
>> index 82b2195efaca..4a54b4f0a609 100644
>> --- a/include/linux/device-mapper.h
>> +++ b/include/linux/device-mapper.h
>> @@ -169,6 +169,12 @@ struct dm_dev {
>>   	struct dax_device *dax_dev;
>>   	blk_mode_t mode;
>>   	char name[16];
>> +
>> +	/*
>> +	 * sequential number for each dm_dev in dm_table's devices list,
>> +	 * start from 1
>> +	 */
>> +	unsigned short index;
>>   };
>>   
>>   /*
>> -- 
>> 2.34.1
>>
> 
> 

