Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2053.outbound.protection.outlook.com [40.107.117.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2DE10FA
	for <dm-devel@lists.linux.dev>; Thu, 16 May 2024 01:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715824570; cv=fail; b=td3b1ppG6+T1ltVpzJYqWh5Cafu9qiS/TUD95C40sz2jbZJpvMSMBp+oxhoXvXFiYpRrn/ijWEMcMXsTDcl2my0dvNRvOBxQYWAP6NrCeqC0QizjA5o5Pa4RTv3z2OdXSMuJBvR+m5Eb1DTX6AwQ/Cahg2LCP/FyCcY+vpHC/MQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715824570; c=relaxed/simple;
	bh=sebfIh+xnVtbOfN19elqf4/s5YK6KmUMtZmb7Xr311o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AH/c3Ic7HOlhfFLEifnHlIO++n22yiZKi5uTpmv8y1FJEc2E2O1A8Z7KdATX2JqK/13QkI2NTGbx7GEZ6K+K+/KL85a1UelV4KiXzbBBljWbsLlbmY5hn/26j/YF/gan4mqSb11C6lpxVE+9NEcFYctJbl/tiMVyPxJCK+0QG5o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=MCrUkypC; arc=fail smtp.client-ip=40.107.117.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="MCrUkypC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e5abjNveVktrjzvWhMhFBBAdU0tMwYgR1NPwB4pCsKAU28WA+Al89YBU90t2V6aHlGT9xNv1YjF4YhmVV6zIlME52YGjO2zk3EvxqIsB6Bn3sjghLGiDi2dapZxKkaebCP5Nriqtz97QYFxM2qSyt1TdzUF7TuL0SMcg/ye+1cQ8X+pDBlI/ufVxTyTIHYbVc4cbfZVs38MHGtdm4uvmagAtlv4oKezSOuX6+q2+3SWilpiC2RTgbBnxKZeL/s2somb+NJqKrmfx9qdmHiJYDIcI1M5fpELoEJVTjtUK39SQxqFZvOORdUPaEJkbfXvjqfBCDNWAZkAW0C9Jh0CQHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dx53n1MYeBh680L5d2h+x4yqPY9cWHO+C7PrageE7pU=;
 b=nIoRvzY4oXv2zr1sVqWT+0xBIIBEBz791h8WQwyklVocmcU5g6F3BYjIE0ZaIInMt0p8wdqa/iBDC9/9AiMm0hDComt2df5t1x8lRu0McNknJHAuW09fNCTjiit6qpAa1nJH8e9JWWU4MvU4zaiiFwY/8YNDFurHIHpLfZ/evdKE6FTx42PSFyGxLih1jRKrALKTP+dcKTute6WpTegFxbypNWjC8Z/1l7P8FFZ5OD4AsjlAPz6MdET51F9iAMQd3y1gT6kkcTQsfi5gOhsxm5icXJYD9ZMS1Y73+h4dsgXGZDM5bZh6c71DUXK+RI0/6/qJdtfDgyq9vkjyakZqWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dx53n1MYeBh680L5d2h+x4yqPY9cWHO+C7PrageE7pU=;
 b=MCrUkypCppNOh/lX6naXaQTu8lb0vgRFy6s002TySdTjKJp42hUo06QXbs7B3jYyiEZalAeXAI8uRU8GCHVtxx4JWQ+jNR58IjVtIN1L1gN1UKb/w+kNOVOzk+3Ks23hQ+68S5CeSBsaKn5fl9XwoJ9cdKyDR0CRbkS2WF9ySdkZJ21ygoF3HW5WNKsmgdMZYjKVa6/yKo+2W+hDasfWC1nFVhPiW0dY7yTJ548vVJVAmTOPHBZK+PKf3fJ6VaUKFBfM/Lc/pyzwcZ5+mf0x3CuazjlgDkPbkxzGQTAORirOv2bWZfSVFYJ39Rm8IbJ9QpgEhliyxzGxDCk3E3H2Rw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com (2603:1096:400:42a::11)
 by KL1PR06MB6041.apcprd06.prod.outlook.com (2603:1096:820:cb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Thu, 16 May
 2024 01:55:56 +0000
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee]) by TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee%3]) with mapi id 15.20.7587.025; Thu, 16 May 2024
 01:55:56 +0000
Message-ID: <80ddcd90-2e1c-4fbf-a45a-b1b5ff4d60fb@vivo.com>
Date: Thu, 16 May 2024 09:55:53 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] dm: support retrieving struct dm_target from struct
 dm_dev
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20240514090445.2847-1-yang.yang@vivo.com>
 <20240514090445.2847-4-yang.yang@vivo.com> <ZkTXzG1yrPmW64Z6@redhat.com>
Content-Language: en-US
From: YangYang <yang.yang@vivo.com>
In-Reply-To: <ZkTXzG1yrPmW64Z6@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0186.jpnprd01.prod.outlook.com
 (2603:1096:404:ba::30) To TYSPR06MB6411.apcprd06.prod.outlook.com
 (2603:1096:400:42a::11)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYSPR06MB6411:EE_|KL1PR06MB6041:EE_
X-MS-Office365-Filtering-Correlation-Id: e28b7b7f-f175-4072-2b99-08dc754b5380
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WlNabDJsTExYM2dBN1NZYzlZUitaS1p4S0s2U1dzRFcyL3d1WUc2NUxNQzJJ?=
 =?utf-8?B?R0srQVNTc1VLby93alZ5eHhWekJCdWJEd2UxTGJvWXdTa2FjVG50T0ZWQ1Vi?=
 =?utf-8?B?T1JZdWZLb0pXUEFVUGQ2Q2NVM2FIQTA0aGdkN2l6TDJGMW1FQURycjFZU2NM?=
 =?utf-8?B?Q2FFZmJlSUhYZ1Z2dVpqUTFSM21XaG9DNC9NNmlmczFQY2Y3SHFoaUZZQVVQ?=
 =?utf-8?B?YXpxcUFNMTQ3cHF4S3dhTGhuS0x0SW5QL3JiZXdGeG9xdmxibm1FTTJnOGV2?=
 =?utf-8?B?dGhSMy9oTXdVZ2d1VjhNcDgwdXo0YmhhdHhXQ2gzMzc5ZmpRTGhGRGo4b2Ry?=
 =?utf-8?B?am5oZ3cveVF1Zk9TdGVyYTJTNW53QU9DcjloL0tWMG9VVTZUREdDVDh1YXdG?=
 =?utf-8?B?OHhFTFh0N1VLeTc4Vm8xMnJCTDAzUC84T3l6M3ZrdFhZVDZFQzlPR3UwTnQz?=
 =?utf-8?B?NzNnZzFnT3hvYWxjTE9wTERVU1NjU2tnZDdqU044cnJMOFdzSHlzdHk5cE5w?=
 =?utf-8?B?WHNuSXF4bWlzRWJTYWhBVmhYdHRsK3A4Qi9hajBObUVoM1JxUXBUaEFHWkg2?=
 =?utf-8?B?bXBuUlIycUNuSWs1akVOYnltSi93OTdOVk0vZTcyYW40OWVuOHhxYUR4Wkxv?=
 =?utf-8?B?WkJwN1JQZkRTNE1ENXphNjRxTmpUdFhEbmxKOSsrcTJmMnFhbHluK3YySXB6?=
 =?utf-8?B?czBJSGZKZ0J6cVdzRjhEY3AvcW9sTTdFUVRFMng3WnZpMjdWWUFqNjN3YS9E?=
 =?utf-8?B?Ni9WYlIyNms4dk1EZWQ5SkVYY20xYmszbFBjaDdiZEFYL2d6d080bElhaDJC?=
 =?utf-8?B?TGptQmV2MDVuN1BNTDJSd3ZnNkRDZUtyeVJTT20wUk5mekcraFdLOFJaSWlq?=
 =?utf-8?B?dkRSeE5GeU1GSlVWTDBYVzJlczFJRWxhRFJ1TXQ0UHVRdEU0Z2NFaU1MVXdK?=
 =?utf-8?B?K2k4bDJVanV5YU03Sk1ia2xxUzNWOGliU2RqR1c0MHl2Zm1MalBSUXZGcUpr?=
 =?utf-8?B?SjZubmJiZk9sQ2tkM2E5cWppai9hcTZsbnB2cXVwUHNYdktBYWJOTitnY2Fr?=
 =?utf-8?B?bzU1TXU0b1pUTGE2cDNHemJ0WmZGckRMQzF4LzNYNEdlN200MVJVdnBtUWZh?=
 =?utf-8?B?ZEltZFcwTjBSQXllazVqbFdVb1M1TWpBSVpxaUZZZ1YrUjg3aS9Ka0s5R0Mv?=
 =?utf-8?B?MEp2UVpxVnpaZGo3bVIrb29wYzY4UWdyK0QxWEtuZUtIeGprNGhaeEZYR25N?=
 =?utf-8?B?YmYwd0FXNzBIb2EwL0JLNWQ5SVhFc3JVNWVvcDhaekRwRXZNN2N1MDFoUmtR?=
 =?utf-8?B?OURrenZ0Lzg1OU54M3RITERzbVNzT0ZQZEZiVHhEZnYreFZ1UzJ0emNuTnQw?=
 =?utf-8?B?SkVXZHZ6UFJ3TkxXT1NPazM1SlgvWll1a25ZRFBwS3k1TW5ERFJVL1F4Q004?=
 =?utf-8?B?QitjUlNWbzJEVFFWc05Ha0liY0dMVjJ2WkpzNDBjRVdvcDJxSEJxc0FPVmF1?=
 =?utf-8?B?ektnd2lkdFgxaXRCZkdabVRnbmJqb3A3TnVNV2VrOTE3MmdqMXhnNmZjeWVL?=
 =?utf-8?B?ekFEdityQStnemdxNjZwTWlXTFMxeEpNcjVmMkVieXNHNmFxc1dVRzc0elg5?=
 =?utf-8?B?Skd3eCtCVHJCbmREc2U3L1ZMQU5GU1BSS0grcXlpY0hVUDlpVXhhbHZLZHlq?=
 =?utf-8?B?SmozYkdxZ3pSZTFVR2RObVRaUm9DTTRYZEZIbFUzaTRick5qaktkTlBBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6411.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Yjl6bmpuUFVQSlRwVVFTSDBtRkwvTGZOVkZ3dW4rejN1L1ozeGp4TnUwR3Uy?=
 =?utf-8?B?M3U5eHQ1dGtsSHUxTyszOHQvQ3k2bFlLRDRocUxHWEhnU29VbDRkTEl4Mk16?=
 =?utf-8?B?L0JBQ09lS2picmI2V1JSQmVjZC9kWGRWRmRCTDFCdXV2V1hZMG1ueUVheUE0?=
 =?utf-8?B?SFlJK29LUFBLSHFPSU9uMjhJeFovMkZVa2hXWmRVMWljNmkwbkpxeHpSL3BZ?=
 =?utf-8?B?UndIeVZXR1IvaWhPZTg5TmRKTW9NdXJZWWNzbzAvVGJwK2RYNGYzN1dCOFIw?=
 =?utf-8?B?Ym80OXNwTFFvTHlxcW5WUm93NnplaHVSMHNJMUhINnk2TXl4Sm44UDkrM2k0?=
 =?utf-8?B?enlRYXlEN05jZFNEZ3hLeklHQnpNNzljQ0NWcml6S05LT0lBbllRckJmSThE?=
 =?utf-8?B?ekhYT1FzS25pOUtaSUNCOFVESW9YZk5MTTNFMkVFajByKzN1VThablJ1OEJq?=
 =?utf-8?B?S1RVMVRYQ2ZJZDBxMUtjdlNEWmxoZU8wenkwMlJ6NDY4cXNJNXBxR08xa0ZV?=
 =?utf-8?B?Y2t5b1c1bnVXcHdyQnZ5OUNDUXdzY0N4OExwaTV5bW1RQ0JGS3lNSDltc1dY?=
 =?utf-8?B?d0k2WUQ5Vk5jbWVvdzlneWo0SDM5U3FhNTEwMVR0QzQycmE4cStuM216b1U1?=
 =?utf-8?B?bjZOUU9ERHRWRG5nY0Q5S3AvMVF2OFQ4a2ovVldETGhka3NES2RYZFhhM0RN?=
 =?utf-8?B?OFZWZUs3L29EME92cURUdFk0eERzdkYzVW1zbjVmdERLVVJ0VndBT2JieGN1?=
 =?utf-8?B?NWVwQUhuTXBiZlNCeXExeEdrc0QzOFJwUGFobFBDMFMrOEQ4S0xRTHo3RlVq?=
 =?utf-8?B?Ym1VdmE5V3JINFRITndWWlQ4REF3Z3V2ZTAwTTErcHVNYXczb04yNHRjTnZ6?=
 =?utf-8?B?d2FQK0dVWU80QzZkbjhrdi9waDZMU3JHemI4cHhSOHZpNmNLSkdOWEF1Q2RD?=
 =?utf-8?B?WGdEZlBKYTJob2xvQk5FNGRtL1AvNWd0NGtNL0t0Y2VjU3dvQTJmL1Q2U3R5?=
 =?utf-8?B?Wlk4WVh5VFlCeVVHR09GY3ZJdU0wWHg4ckl4NnRQT3kraVJLWXFmYXFBcGJp?=
 =?utf-8?B?Zk9IOEdKZzgwekh4TkNscFhGNlhDNWQzWjY3ajZGS3RETm42ZHUvcGEvWU9w?=
 =?utf-8?B?NWcwUmVOb213bFpJZSttT2E2UDlxenFJQ2NraWhwV2RVVFM4THlpT3pEYVFT?=
 =?utf-8?B?UXVUNkpZbVlyVlQxOVZqbEpVd3hrNWg4V05pdk90cHpvdGRZSExWRXhFcHpR?=
 =?utf-8?B?YzBNalhTeExhZ0w5dlhQckEwSktRU2xKdVdWT1VjdmV1VE9uTnA3RDFCZ1FJ?=
 =?utf-8?B?UUc4RzRZTm03M1pRUDF3dXl1eXl5andGZjNZOEhUbm9lTTRJRHdHWTRjczhH?=
 =?utf-8?B?QWxQRTdWYmgzcnZFa0Z5TXQyQXRDc2k0Z3IrMW9jRFB1VVJBUVN1eWNyNG5v?=
 =?utf-8?B?SW5EUXhiMU4wdHFwbVdjRDdHRU9ENVNwM1BzOVBFVWdDa3JLUlQvcjFUdHIv?=
 =?utf-8?B?UGlITHByZFRVcmNRcVBRcnFab3RaMWgyZk9IRnlXRkNOZHdES2M5UjNVMEw1?=
 =?utf-8?B?REtBeWNVNVV1N1JwejNwZFRPMC9TN2wrKyszZ1JMZWNWSGZiQkxGRmF2dFc1?=
 =?utf-8?B?bWM5NDVzM0JwRkdnSHk5bVljQWxvTytXNG1meUNZajZPYnpNL05OYm9GTHNV?=
 =?utf-8?B?bmR6bjc5bkpOREIrQ2xTN24wTmJWQnJ3alVjZTdjU25PeVVleWNMYzVZQ1NY?=
 =?utf-8?B?ZXlZTkc5RG1tZ0YrWE9kUFlUMFZDWEl5Z1BicUVRQ0dVSXlFcnlFc0tyZ09q?=
 =?utf-8?B?NWlRalkyL01hc3VDZXM1U2tkMmJuZFlMUWhXUWovSlROMFk4emZSdkVDZm5X?=
 =?utf-8?B?U1M5MlRUbGJwNExYdmdkUm5KWjg5SHVKZmNwMDFGaEYzS3JiWndWM21obDZY?=
 =?utf-8?B?ZnB2Tjg2WnZuMEdCR3Jyc044bkNXbVVOdDViZUs0YUJWVFltdTFYSkdnV2Mx?=
 =?utf-8?B?RGhnajJIdGQ4cDNnMi9UUlYrcGVhZzBNOWJmMUhkMGpMUGppcnp1K3dxK1hh?=
 =?utf-8?B?bEIzR0pUTDhzaDJoN1lEQS9zK3g0d25QYWNJZVVQbUZDTFBrWXEvMVVicHVK?=
 =?utf-8?Q?GocoQ5MfvhYb59tN3JtYLGK2e?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e28b7b7f-f175-4072-2b99-08dc754b5380
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6411.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 01:55:56.4518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3quVZE75mIfLYEnSmTqDo5UI2yFznWLVMUWsNRPBqEquv4yG/Nrlkdz1Cvg2EOtTePlL74fJrMhQ8QxPaFCSMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB6041

On 2024/5/15 23:42, Benjamin Marzinski wrote:
> On Tue, May 14, 2024 at 05:04:42PM +0800, Yang Yang wrote:
>> Add a list to the struct dm_dev structure to store the associated
>> targets, while also allowing differentiation between different target
>> types.
> 
> I still think this is more complex than it needs to be. If devices that
> support flush_pass_around can guarantee that:
> 
> 1. They will send a flush bio to all of their table devices
> 2. They are fine with another target sending the flush bio to their
>     table devices
> 
> Then I don't see why we need the table devices to keep track of all the
> different target types that are using them. Am I missing something here?

I attempted to enhance this solution to support additional target types,
such as those with num_flush_bios greater than 1.

> If we don't need to worry about sending a flush bio to a target of each
> type that is using a table device, then all we need to do is call
> __send_empty_flush_bios() for enough targets to cover all the table
> devices. This seems a lot easier to track. We just need another flag in
> dm_target, something like sends_pass_around_flush.
> 
> When a target calls dm_get_device(), if it adds a new table device to
> t->devices, then it's the first target in this table to use that device.
> If flush_pass_around is set for this target, then it also sets
> sends_pass_around_flush. In __send_empty_flush() if the table has
> flush_pass_around set, when you iterate through the devices, you only
> call __send_empty_flush_bios() for the ones with sends_pass_around_flush
> set.
> 
> Or am I overlooking something?

If I understand correctly, you are suggesting to iterate through all the
targets, handling those with sends_pass_around_flush set, and skipping
those where sends_pass_around_flush is not set. I believe this approach
may result in some CPU wastage.

   for i in {0..1023}; do
     echo $((8000*$i)) 8000 linear /dev/sda2 $((16384*$i))
   done | sudo dmsetup create example

In this specific scenario, a single iteration of the loop is all that
is needed.

> 
> -Ben
> 
>>
>> Signed-off-by: Yang Yang <yang.yang@vivo.com>
>> ---
>>   drivers/md/dm-table.c         | 36 +++++++++++++++++++++++++++++++++++
>>   include/linux/device-mapper.h |  3 +++
>>   2 files changed, 39 insertions(+)
>>
>> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
>> index bd68af10afed..f6554590b7af 100644
>> --- a/drivers/md/dm-table.c
>> +++ b/drivers/md/dm-table.c
>> @@ -741,6 +741,8 @@ int dm_table_add_target(struct dm_table *t, const char *type,
>>   	if (ti->flush_pass_around == 0)
>>   		t->flush_pass_around = 0;
>>   
>> +	INIT_LIST_HEAD(&ti->list);
>> +
>>   	return 0;
>>   
>>    bad:
>> @@ -2134,6 +2136,25 @@ void dm_table_postsuspend_targets(struct dm_table *t)
>>   	suspend_targets(t, POSTSUSPEND);
>>   }
>>   
>> +static int dm_link_dev_to_target(struct dm_target *ti, struct dm_dev *dev,
>> +		sector_t start, sector_t len, void *data)
>> +{
>> +	struct list_head *targets = &dev->targets;
>> +	struct dm_target *pti;
>> +
>> +	if (!list_empty(targets)) {
>> +		list_for_each_entry(pti, targets, list) {
>> +			if (pti->type == ti->type)
>> +				return 0;
>> +		}
>> +	}
>> +
>> +	if (list_empty(&ti->list))
>> +		list_add_tail(&ti->list, targets);
>> +
>> +	return 0;
>> +}
>> +
>>   int dm_table_resume_targets(struct dm_table *t)
>>   {
>>   	unsigned int i;
>> @@ -2162,6 +2183,21 @@ int dm_table_resume_targets(struct dm_table *t)
>>   			ti->type->resume(ti);
>>   	}
>>   
>> +	if (t->flush_pass_around) {
>> +		struct list_head *devices = &t->devices;
>> +		struct dm_dev_internal *dd;
>> +
>> +		list_for_each_entry(dd, devices, list)
>> +			INIT_LIST_HEAD(&dd->dm_dev->targets);
>> +
>> +		for (i = 0; i < t->num_targets; i++) {
>> +			struct dm_target *ti = dm_table_get_target(t, i);
>> +
>> +			if (ti->type->iterate_devices)
>> +				ti->type->iterate_devices(ti, dm_link_dev_to_target, NULL);
>> +		}
>> +	}
>> +
>>   	return 0;
>>   }
>>   
>> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
>> index 0893ff8c01b6..19e03f9b2589 100644
>> --- a/include/linux/device-mapper.h
>> +++ b/include/linux/device-mapper.h
>> @@ -169,6 +169,7 @@ struct dm_dev {
>>   	struct dax_device *dax_dev;
>>   	blk_mode_t mode;
>>   	char name[16];
>> +	struct list_head targets;
>>   };
>>   
>>   /*
>> @@ -298,6 +299,8 @@ struct dm_target {
>>   	struct dm_table *table;
>>   	struct target_type *type;
>>   
>> +	struct list_head list;
>> +
>>   	/* target limits */
>>   	sector_t begin;
>>   	sector_t len;
>> -- 
>> 2.34.1
>>
> 

