Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012015.outbound.protection.outlook.com [52.101.126.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD82239E66
	for <dm-devel@lists.linux.dev>; Wed, 30 Jul 2025 13:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753880940; cv=fail; b=rYRSl/cS/kgOKiCjFvIx7Gxf6y/sRmthqEFudm6WBYTmbS8n5GNuvjDG+SK06AKr2ENmmNXZ+YkN0Yd3LM/bKTk0Va4Lnj2F+FWOXmpCQadcoIDNtspgepjcgvLjL6+MHsCETiiMJRALI+hCV8dhYmw/o6rj1hkHISYSN/1Jlys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753880940; c=relaxed/simple;
	bh=JU28sjSTQPyAbJcFKMq9l19+Uu+DN6EL5+eiA/P0tMU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iAZ44DFIpC8oHpwAMGB712wjTSFoUehcaNUMyLdTBFJw85677suPcngIBIUG8dg+c56tQQbwLiVSSah7UZJWz/ouCK9Rr74G3WFRKkNUXU43/H2V1fsJZiu+rbjJlHGoRdbXbLdhCr+XyPxtgMw+Qfj7FHHu8A2cmTTyK6NigSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=UF8HSDqw; arc=fail smtp.client-ip=52.101.126.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="UF8HSDqw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ul7QdEF3roO35CvIphlPB4K4WFlV8u9/GfaXCFS9II5MmOVlLGUupm3xkaw1rC42ce0UIeXKzxtEOlVvrqYztCEwwdP3mN1xdMnXnGKYk0I6OC8CNCCh3QPlvxDPeWRUa7QJfSyI7kTrOriCk20ER9/Nlev08vhZ293BbdccVGNeAUnqdHJ39O8R4+Q+BUY3h74hGypd6tGu6aCSBqs1Vxvf6KWGwsr1O2uzXYTghChM0ORu4vphGk1w34aPcCoY7vR370XVkxEfgXc4dmo3olrqk885OpeP291zgzTnbgws47pwefqsUSX9nC3nYi6JqMxUj3gMhUWqu+4b4URcAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A5bSg+0UmJ1PtAETRnaJJ14EJo4OA8s/+EA0CMnvGKw=;
 b=A06nGqcmHZOOlmc42dz21rDQ7Mt9iM7XVmtyfsWVtm2mTnCIM4652BJsh4Fj9iK6XQeFtuouVjH3VepjXi5pwarYGA8QkmDc6a+LlsCKsjTxfC4kBIv9B5e+VGX5z7++8O/DbXcVP5mvDoxzGWcPA1GlxU70B0DXNANnCpPd9U5zK7b/XArGZ9CN1McHw8EyVUbrwP6zQOiz94GNmVru3UXPFHxu3atBHsU3F/UQcENeczKUPTdv5z/Mgo/fw/+sP8g52a3tX9tXvomobeNeBEYFi5lRvdrpaVOq8tu96wiob4AGe2lnTJo5tH0/F4ww284GSOvx1Tyh1yYIWWQkPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A5bSg+0UmJ1PtAETRnaJJ14EJo4OA8s/+EA0CMnvGKw=;
 b=UF8HSDqwcp4vt8hRwy8KfWShpDV0GxDVDCKQajVvuNU1HjBzYUKEF6ZLMjenS2T4ti7PadOt+tJPZq1awAUVolhh78M+wNJo5dBsaYct/nCIxdIXTCRhnIbOFVPEVX2cGzpSFeNVFZnqpWEpTEh6v9vME0sace9MPTmu7MuGKVs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from PS1PPFE5C9D9891.apcprd02.prod.outlook.com (2603:1096:308::2ae)
 by JH0PR02MB7344.apcprd02.prod.outlook.com (2603:1096:990:6f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.12; Wed, 30 Jul
 2025 13:08:53 +0000
Received: from PS1PPFE5C9D9891.apcprd02.prod.outlook.com
 ([fe80::e3d8:6cd4:4818:db76]) by PS1PPFE5C9D9891.apcprd02.prod.outlook.com
 ([fe80::e3d8:6cd4:4818:db76%5]) with mapi id 15.20.8964.024; Wed, 30 Jul 2025
 13:08:53 +0000
Message-ID: <72f54b80-2e66-4692-a635-0882e9d11631@oppo.com>
Date: Wed, 30 Jul 2025 21:08:49 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: set DM_TARGET_PASSES_CRYPTO feature for dm-thin
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, guoweichao@oppo.com, snitzer@kernel.org
References: <20250730061718.1966686-1-weilongping@oppo.com>
 <0d84258e-daa5-2f96-78e3-ac52b8d35452@redhat.com>
 <6db292e9-dea9-42a6-ab96-298481cc70c2@oppo.com>
 <f66ace1c-3112-a3c9-5c43-efdbbf82d765@redhat.com>
From: LongPing Wei <weilongping@oppo.com>
In-Reply-To: <f66ace1c-3112-a3c9-5c43-efdbbf82d765@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0127.apcprd02.prod.outlook.com
 (2603:1096:4:188::7) To PS1PPFE5C9D9891.apcprd02.prod.outlook.com
 (2603:1096:308::2ae)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PS1PPFE5C9D9891:EE_|JH0PR02MB7344:EE_
X-MS-Office365-Filtering-Correlation-Id: 20daaf1f-3fad-412f-a7e1-08ddcf6a3b73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SjR1RU45c3dZVUtuNVZhYWlIdzRJcGxEYlJUNHpjU1BTK2M2L1hSaVVMMm5p?=
 =?utf-8?B?WWE3S1N2NlIxczRtSlh1UDZHNExJL20vWHlHZVVRZU9rSEY0elFYOU9OL1l0?=
 =?utf-8?B?WE83RUdyOUhRYUN4SkhpZ2xmRzg2VTU1UWRFSk1keC9CdXpFSE1UcDhzRmhl?=
 =?utf-8?B?cktqNGZIY3U3cThqOFIwMG1qM0gzN2RqK1ZGQVlRdjM0d0JKTE9YZUUzR3VJ?=
 =?utf-8?B?d01GSFNWT3pEcEFVMXlpcVJkdVlqQUw3R081OEgrTW9MTGZyZXBDRHdrMk1W?=
 =?utf-8?B?MHFyRWZOTUdWSzl6V21seUd3YUo2NmpNc3BGRWh5WFROQm5wd1FoWWQ5bVpD?=
 =?utf-8?B?bG5YeWx1cHNmUkIrYllucjlvMWxkbExaeU40ZFYzM1RialFYbmZSeER0dVF0?=
 =?utf-8?B?VzNnaHVBNUJXYUk2NjJ1RGtyNUtIODZ4bTlUVURmNzBoYk5MTWJYR3AveUlw?=
 =?utf-8?B?b0lzWXMrUkJ4NUFSSUdnamJyai8rZTNSbXl0NkFhZEI3THpVTWlIZ3Q5TGZZ?=
 =?utf-8?B?NmdERWNKeldwQ0ZLR0VKMWQ1a1J5UVVnYlJCOEpFTXl4amE5S3hJMVFhQWty?=
 =?utf-8?B?MFJETHhjV0JCOUMzMlNuS2JkSEJCMXZGMEtadHQ0eXJrZ2MvaGtNeTVLTE1v?=
 =?utf-8?B?eGFtam5ua2JmdFRnVUhhMlVSekJxbXlLdmY0NDZ4WUVsWHhsdS84aUxoa1JD?=
 =?utf-8?B?a3BDeEl2YUNVVFIxN0F3SkVXSGtENGMvRlRXRVB4Z3N5V3JBekNtVWRwYXMw?=
 =?utf-8?B?eFZSeXBvQVgxMEtJRFBFOU02MnZwbVY2akJmcGs3V1RuSDZ4bjdtVHNSUE1q?=
 =?utf-8?B?a21tRUNrQWtVeWJTWU5CdXgrQ3FxcGVCU0FUTjY2ZU9qa0R1V244SFBqSFhG?=
 =?utf-8?B?RnBHekhsV2NkQVB4bjZyWWl3cENTNzhnbEZKZmdyMHNhRUJFOWlBelF4TGk0?=
 =?utf-8?B?d1RZbDloMUk3bEVHTnp2TWMrMmo5SGRpUWNqYnA4bmdiZXNKb2ZOQ04wdUgy?=
 =?utf-8?B?aS96OWJjODB4dGl3VnkyMEVKc1c0cnRpM1liRzAyNm4xWFhNKyt3VWg2VWhB?=
 =?utf-8?B?MHZML1k0ZDRUcTIzNDMzREUwRHBHWUhEeHk2bHIyUDJuMDJyQUxCWVBkUWIy?=
 =?utf-8?B?RVdIMEUzU2UwSlJjaVRFcFNVYk42Wk5OY1IvdGp5QmZuVnR2YmtYeHY1Qy95?=
 =?utf-8?B?b0FCVjlGMzVpWWdZV0dkOGhldFd1NGRTYllwd2ZDZlAyU0FPZFZiVzErUVBo?=
 =?utf-8?B?bkQrcGZITFB3MWp1LzI0RzYvNHgvRSs4U2xrR2pSd2xuc2JrTWR0ZTZ0RkJO?=
 =?utf-8?B?bDZMTnFiei8yUWl6aVE5ejFBdzhvOTBWYXBDN1oyZ2FaOW9PN0IvOWdjM0tG?=
 =?utf-8?B?bWdMKytZUlM0alczYkhOT0x3NmV5Q1E5Z2crTWlpeVhNSzF3UmNaNzIzNjkw?=
 =?utf-8?B?VWN2WGN3aC8vK21qVlFxR0thdFhUQ2J6WWI1SVVkSEhyaHR0bmxaSkZuVDF0?=
 =?utf-8?B?UWQ1ajZPamVqMUtQeHVjVnI5MFhEakowUG9VWkxOaW1DM1RJa0ZSMyt1Vmpk?=
 =?utf-8?B?WWExRW1mYlFIS05NQkY3UzlhcW1WVEVLVG9ScGxtU3lvN0RiRGozVmhLdWZL?=
 =?utf-8?B?clBCcDJveWpvWENlenM5Q2VyUDAvWkdiVmp2QWc2SHhvemV5N0lpY3pHYlRB?=
 =?utf-8?B?T1c5U1VhUmFXUUhhRHFvNWVmL2lDRlRmbmtYSnhqNEpGdlo4VHIzajN2TGVR?=
 =?utf-8?B?d2pydEpwUzdrREQ4dmdiL01OVEZOS0pMU053aHdaQStVaHA2UnloVjB3Q3hT?=
 =?utf-8?B?NmlHL2Ywb0k4T203QlpiQW42SlMvWkhuLzZid3BTTWorajU2SGVkNGR5c1RH?=
 =?utf-8?B?MW8xbUFVUHNDSXB5YUx5RWxJKzlQQjhhaTZ0TGw5V3hhUjF1RXJKRjU1NmZs?=
 =?utf-8?Q?iR0lSCZoBBA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PS1PPFE5C9D9891.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Yjg4ZFFOQUM3akh5cTBxamRoMVVUL2ZkaUovbW5aNVBObHEvOE51YWJ5MW5n?=
 =?utf-8?B?dnordlZSYk5uOW5pcG5kcHE5TnhaKzZaVHIrd2RZbnRhQWZUaWdCKzd6RFkr?=
 =?utf-8?B?UHZHZU1TdzFUTnYzalBLZy9ZbDNObk16N1JMdzhQUWJxQTRVWm9UdlQycXYv?=
 =?utf-8?B?OHhiemVHZUFOQTdtZUNjREs1UStZd2xNUDhUcEpLWE1XbGRNb3R6QTFjT0Vp?=
 =?utf-8?B?dEt4VjVocXVQMFlFaEhhMElXNHE4UjNDbWtoalp5VkFIMmt0c28zcC94YVg4?=
 =?utf-8?B?L1FCZWsrRjVuOGlDVXB4NkN1dFIrSVg3V29FY2FUdkgxZlduVTNIOEVOMHBH?=
 =?utf-8?B?Z3NqMlN5N0dGT3p6aUlLZ0h4N2NYbEM2RDZGQjhiZTY3alNrZWY5b0w1bFBS?=
 =?utf-8?B?djk4OG1MSWdqcHo5MkZDbzFzcFdGWW1RZVNzWnBCWnIwUXYrVW1keWY4UGZF?=
 =?utf-8?B?Tlh1RG9PWVB5WVByT3FBRWNleHRONGVSUXFFNk5NZ3JWaTBnMnpKcWlwUGQ1?=
 =?utf-8?B?elhwZXpnU3hRVXM0b0c2RVhVNG5uQVNqTk5UaHlOSE1YdDVWcXNXcWtQN1la?=
 =?utf-8?B?elNSblJuMFpEemJtaDYrVW5tcklBL2xjV2Z6c0Y3Tlp1V0VHOW1RcVFxMldK?=
 =?utf-8?B?dlpQbXA1VEM0YVJBcG9PbC9hcWtKak4vL290YkxSYmpVUG9Pb2xESy9xQmVq?=
 =?utf-8?B?Q1BuemwvRDhiVEtMbUJaOWQxb1JnVUNaOFY5RTVCbmdEMlcyb1plalVpdG1n?=
 =?utf-8?B?VTE5ZjZ1eDhjMHBCd2tHNXBhNjNnK0tReUhrUzF4WmNodzlBV0VSaEdIdmxz?=
 =?utf-8?B?VHhOb0RmOHdUUXBJN1JjSnNVZlg3NTlTRDlZUXhrQlQrWUtIdk4zMktuaWVW?=
 =?utf-8?B?c3RiOWdHNEY0dk85TVYxSXorQzFUNXFRbG12ZFlZY2xQTmtVdTUwYTI3N20w?=
 =?utf-8?B?c3J3UDk4Q09PQ2tkQ3FieHRUSStXeDU1cjNCcjhQREFJM0hZWVZWSWhHYkRB?=
 =?utf-8?B?eDFNN2dKNXRkMDdsN1FlUmlEWHl6a3BXTjhtWnpidDhUbm5teC9wUG9zWFE3?=
 =?utf-8?B?V01IY0VRdXp6cENFQWZaWUxrNmVOY29LSTBrRjBadXRSMnJ4eWs2MnZ6S04y?=
 =?utf-8?B?bzZFQURkaFdhQ0pEdWl6U2lZdHl3aWlKckQzQzc1bzBoV0poYWYwcVpRVVZF?=
 =?utf-8?B?QUEzV01yc0t1UXlVb2ZpdWJ2WVlpbzVsVnUwbi8veDc1UHB4MzVLU3RzQ3pR?=
 =?utf-8?B?TWw5NzV5TVpaNVBGYVlyTmhjeXBITXhlWFB1Z1RiMXNialdDazBoNzNFMGJ5?=
 =?utf-8?B?cTZCeTlDbStYSGdySE5qeEljdkd6RjBEL2s5MFlRZmtScFpnSS9QQ0N4VWEz?=
 =?utf-8?B?ZTNSc2RFeW5HOTdubkZZTUZuS0NEeXltdWhkdWdTbjlZcWFrZEFoTUV4UWRw?=
 =?utf-8?B?Qk9vQnFZQ3BpMHJSSytmNjAyK1FwS3ZpUGxVSldjamdZR0ZMY2lmZWdvRXFG?=
 =?utf-8?B?c0J2V1hoR1RnMlFiS2ltZWJPQUFBV0xOYTQyMW45enEvT3dBU1ZoYTdZeW9l?=
 =?utf-8?B?ZGQxL3JsOXc5RHpCYXV6MjNEd2t4MDlweWladVJ4dEtiRVFWK1NoT2wxN29C?=
 =?utf-8?B?djh2TFRKT2hEeGxPT05VZVhGTXFScThxSHhmOG1wS1huZERYcnNKOGlHdzVS?=
 =?utf-8?B?MnNGWEgrMFpjVElDRWJvSGx1bGxNSWV4N3VxVGZydndMRkltVVhJYXlpQ1hh?=
 =?utf-8?B?eGlYK3lZcmhSeEdiU1RkRTdpdmQxS1lJMDNWVzNKQjEzdi9VaHE2Y3h6Z0hD?=
 =?utf-8?B?c1VxTUlYa3lpRVhVdXRjZGlGYlo2VklQVW9kdHR6bWZHMisvb1JNaklOTVN2?=
 =?utf-8?B?ZTNTdzVQOCtmZmhhTEY1SGhrYUFPYmlYbkgzVDgvQkJwcUplT2FlT1RMS2tT?=
 =?utf-8?B?dzR3RWZJbjFHUlpMZlBXaEpjMzJKUWFuSGZybHNwLzBiNEo5a29pdDVGMnNT?=
 =?utf-8?B?ZHgwWitZQU1JcmQzU29LVmV2OFZyVGVPUDZHQkV0cTljYzFETTNkTGJqNjFE?=
 =?utf-8?B?WEIxVEJ3U3dvSGFLQ2ZyQ0J4a0MwWUZLTUhXN2c1aERiemoweWFkLzRKeVhO?=
 =?utf-8?Q?fvO5K6duYfBZg2CL2qkvxaTfY?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20daaf1f-3fad-412f-a7e1-08ddcf6a3b73
X-MS-Exchange-CrossTenant-AuthSource: PS1PPFE5C9D9891.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 13:08:53.0170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8GHKPNq7WUns/j3ySmNLn+TP5kuWf642TbqUEh++1DVB7ZveOIIOJuSqu0BYjIsvlI2JHfWKJa5pYgPH4qDcNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR02MB7344

On 7/30/2025 8:27 PM, Mikulas Patocka wrote:
> 
> 
> On Wed, 30 Jul 2025, LongPing Wei wrote:
> 
>> On 7/30/2025 6:46 PM, Mikulas Patocka wrote:
>>>
>>>
>>> On Wed, 30 Jul 2025, LongPing Wei wrote:
>>>
>>>> dm-thin obviously can pass through inline crypto support.
>>>
>>> Hi
>>>
>>> I'm not sure about it. What if dm-thin performs copy-on-write? How would
>>> that interact with inline crypto?
>>>
>>> Mikulas
>>>
>> Hi, Mikulas
>>
>> dm-thin's encryption behavior is the same as dm-bow's when COW occurs, and
>> DM_TARGET_PASSES_CRYPTO has already been set to dm-bow.
>>
>> The key and iv of inline crypto are passed in by the upper layer, which is not
>> affected by the specific location of data blocks in thin-pool.
>>
>> LongPing Wei>> Signed-off-by: LongPing Wei <weilongping@oppo.com>
> 
> How is it supposed to work during provisioning? Suppose that you have 64k
> chunk with no mapping. dm-thin returns zero for it. Then, you write 4k
> somewhere to this chunk. dm-thin allocates the chunk, writes zeroes to it
> and then writes 4k data into it (and only this 4k block will be
> encrypted). When you attempt to read this chunk, the 4k block will be
> deciphered correctly, but the zero data around it will be deciphered too
> and garbage will be returned to the application.
> 
> Mikulas
> 
Hi, Mikulas

For example:

F2FS/EXT4
----
dm-thin
----
dm-thin-pool
----
pool data

1. There is a block of testfile in F2FS/EXT4.
2. The offset of this block is n.
3. The position in the dm-thin device is m.
4. The position in the pool data is x.

The IV is only be affectted by offset in file and the ino of this file.

Even if we change m by defrag or change x by COW, IV won't changed.

The upper layer will only read the decrypted blocks with the same key 
and continous IV in one bio.

If the upper layer read the full chunk with mixed blocks for GC purpose, 
key and IV won't be passed in. Then the upper layer just get the 
encrypted blocks.

LongPing Wei
