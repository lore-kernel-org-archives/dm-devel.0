Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013000.outbound.protection.outlook.com [52.101.127.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A8678F4C
	for <dm-devel@lists.linux.dev>; Wed, 30 Jul 2025 11:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753876795; cv=fail; b=oLwwFYGKXobdTiAkin/awJF91nEadcF1h+RmZ0ZAz3pIyNhbmz1RT5GK0IFJohc6cfnya6PFZH7hDLtSfXalUXsguZlo59kqEZKGU2/pNR0OI+pBHBHmeZg2jh+Ls2gLjaZNMi4Afkknwdpt/sl59RAykc1t+659vL/X+k7a2iQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753876795; c=relaxed/simple;
	bh=SPDHhq2LE2Xsf/NfMzIbv9oFi5JWnEO7nEeR7N0G3Ls=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dFLZh+JASXpQE6zZFLdGVX1TWScjhgN3dImovTUM5vhSriZms99s7q5h33MXsg8bh8biz9mfDgqwjFTwnAa8L+2RK7lUkpAY1yQWJLc1L9rS1khmzvQyMyrA3T7bX8ZzwtcxLBV9prgkkicaHJLi93yor07wqCR4dmy0XX49HFQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=pVA8P1Xu; arc=fail smtp.client-ip=52.101.127.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="pVA8P1Xu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RoPgXJAy8kdwluwSLpZPY3kJ5MU+9P2bxZTt2KLvI95zO0U5VfHcWdkFJf49VtfcNwu2ddvkcBiSVnMZDqJOMlrDvCbp98IVpFOab/TtE+w5Oavb1Z4vM898t2skBnKMTvYqV/7UPIhh4epQcZ/BxI5cAMihKq6trSeEZcNHmMWlhg6PQHF7QLDRXhBgf2ie+4Ng8NF5tR641mGkQH9psbr8EoIXLU8D1lGYxpu6Qq4huuOJWFK/NBokN5viaNOKRb16xmdRquK5pzqLwD/IMUyE/sbl4Za7o5X3RSK4Ff1qhucDysS7sUWKiz99N+jnZuSj8o9nQ/gui/n0V2kGDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dQnSrhaUS6Q0Wc0fwdDHMW+lqP16yteEzOmDixRoqJM=;
 b=pbQ8AYY1imKYO9tfJhQSekSpWW7yVXbgGfNns6kL0do8YH7b+1mwJlFY853GCPI65L3m0Pb+6DStXxOaZkGG10i3wcMj7FBhDMIAEAvEidz1/ejL46kVb3sVQWEKQqusuQYrFyRcrA/wmE4uTWEOghuYpaHnqmhbPv2fVLpeXOiGTha0GDLpRsqSC+WQOeYz0WJPpwyMcnAxAAgRMAyNqU+3DZyWaCVOa5mzNrk4lrEE3su+5NED+G6Ua6R7yFzU7wmd96RhshM0uqaCMyEBsmXp76qeb5GerUrcKxO80oVcgl8OLiCeiGHHrcwWwics4W4D3r6D6yBdkBX0uqf3Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dQnSrhaUS6Q0Wc0fwdDHMW+lqP16yteEzOmDixRoqJM=;
 b=pVA8P1XuLiux4nNFrTUOWj/cuk0PNcQ+5DUgVej6FN6h2pXxWwRH4SjpYYvSh2OPyPnzt3ffwuuEGPTpQ7C5+Qc1wsvPyBItLp3toRwpZQ4x/t2I1biVYb+9Z1Js0FMKrvsK/4hMWfLEdRKQ1h4uJuMlGt3ZLNM7xxzssdC0JCI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from PS1PPFE5C9D9891.apcprd02.prod.outlook.com (2603:1096:308::2ae)
 by SG2PR02MB5951.apcprd02.prod.outlook.com (2603:1096:4:1da::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Wed, 30 Jul
 2025 11:59:49 +0000
Received: from PS1PPFE5C9D9891.apcprd02.prod.outlook.com
 ([fe80::e3d8:6cd4:4818:db76]) by PS1PPFE5C9D9891.apcprd02.prod.outlook.com
 ([fe80::e3d8:6cd4:4818:db76%5]) with mapi id 15.20.8964.024; Wed, 30 Jul 2025
 11:59:49 +0000
Message-ID: <6db292e9-dea9-42a6-ab96-298481cc70c2@oppo.com>
Date: Wed, 30 Jul 2025 19:59:46 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: set DM_TARGET_PASSES_CRYPTO feature for dm-thin
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, guoweichao@oppo.com, snitzer@kernel.org
References: <20250730061718.1966686-1-weilongping@oppo.com>
 <0d84258e-daa5-2f96-78e3-ac52b8d35452@redhat.com>
From: LongPing Wei <weilongping@oppo.com>
In-Reply-To: <0d84258e-daa5-2f96-78e3-ac52b8d35452@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0018.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::7) To PS1PPFE5C9D9891.apcprd02.prod.outlook.com
 (2603:1096:308::2ae)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PS1PPFE5C9D9891:EE_|SG2PR02MB5951:EE_
X-MS-Office365-Filtering-Correlation-Id: b50d2bac-69e9-4f86-b845-08ddcf6095ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MlBPOEpwbUFML2lnUGR4MWE3UHVwNG1uTVZXaU5EMllvZFJZUXlhdU9ucTVC?=
 =?utf-8?B?SklKejVlSnd6TENsbzIwRE04aUVNVCtUWHphOWR6WXdxRG5tK015V3lKcEsz?=
 =?utf-8?B?b0tEaU5zakdmdkNaazUvZHhTZGNTYVA1WG04WVdNWkpPZ1NwRW5LSXk5Tm12?=
 =?utf-8?B?WmZDUEZtSktlVkNZNFp5b1BDRmIwZ1BaRjBZYzJpcXFQYkx5TS9ZejROc3lk?=
 =?utf-8?B?dlJGeklNeklRUExIK0ZRbFJWdDNEZE4vUlUyOGVBS2gra1FuUTBla3kxV3VX?=
 =?utf-8?B?QzFBZ1JReDFaMEhMSVlTZGNEc1ZHWW9WbmdiT3dmNWFLcW5nckZqOUh0Kys2?=
 =?utf-8?B?SHNDNUp4QzAzYWpzc09ua2orQ09hZlM0M0xuVGEzQ3gvY0p2clFVVVBIbXJx?=
 =?utf-8?B?MHFGN1FvWWU1THBrSmZ6VDZ0RU9SUGw3RTlIMXhjKzJBd0VRMTYyUVZWRitL?=
 =?utf-8?B?ejQycW5TOVJmS2dISzBMQUlrWFJTTFFDSEo3cVVOSUx4c2twRC9DMXQvWTJ2?=
 =?utf-8?B?alNvdXZvTDQ0SnNlWi90a3RJY1ZvNzhSckhhUDc2MXRnRHBxTVpOY2FuZWpM?=
 =?utf-8?B?QlNSMGhjUUlaOFlZOENnWXlrOXF4dHA5OXFLM0JTRittbjdEVTlJUXQrdnEy?=
 =?utf-8?B?UVR1NXhjVURLT1BZUmVLcjJzM3NWbGNMbGxVeVdhRUtjKy9BOGtZSzJxanc1?=
 =?utf-8?B?a0NvQVNqU241ZEFwTFNjcmpiQ1JWUXgweHRvOERKUzhOT2NOZFpwMStkQ056?=
 =?utf-8?B?L2Q0ODIxc0wzQjBqNE9LekE2RHYzODNJaXZBU2toTG8wLy9XTUVnY0p5MWtj?=
 =?utf-8?B?N3czN3JReWIvZkZjbVIzV1U2TUswQ1NrRU1HZ1UxV1h5RnI2Zk0vZ3EwMVR4?=
 =?utf-8?B?KzMrYXRQZkw2bVJ3UGpTRUJPcTIwMFJkNnFvUS9MQ3BOblYrelFoTlQ2VzlW?=
 =?utf-8?B?YWxBTzdYZUlLVUJLdVhrUC9lZkFzREoraVNSZFhDcHgweFkxajN3SFBjNmI5?=
 =?utf-8?B?dENmOW5jVDJnbFpGREVSTEJkZUxIZzYzcWFUbHhCZTcva0REc0U5RVcvdFdi?=
 =?utf-8?B?Tm0zSTBlaFNpNUt3bXAyT1ZwNGF5N2tmLzFxaUdFZUcyREVUbmxtcDRWckVp?=
 =?utf-8?B?UkovVHNzVjhjQTQvSElDR25MQTRVRU8wd2tYRmNrTGkreE9sbS80RTRIUDd0?=
 =?utf-8?B?dXVENkJVNnQrRlhUOTU3S1NwU0hvZmxsYWJZWSsxN3VIOGd5TldaTGFBd3pM?=
 =?utf-8?B?a1RRRW9ZaWVvTk1zYUY3bk92NE81b3VpUTQ0NUFuMC81amZiczZqMW92NGxS?=
 =?utf-8?B?ekNOcTZSSlp6M2ZneVlMOUJLai82K1VqSHVtdkNpRnRxSzd6UnBpSjErT2dI?=
 =?utf-8?B?OWthZjFHRjUyeEdSK2FkcElnekN1b1JLWlZhMXluY1Z5Wjl2bERjRDlGSnZs?=
 =?utf-8?B?QTdQcUllanVpUzVIanIzVVpvVDFnblpnQ3lsK2tySmxRWmNMamJxQVRJSXB6?=
 =?utf-8?B?WWo1OVNDZDRIYXViMXBiQ2N5aWtGU1NLSHBKaVVwVlh6YVdoeENINDE0TDFx?=
 =?utf-8?B?STRqRG1pcjVOQUdhODdTQi9VVlJkS1VTdHhvL3ZoVG1zQllSWE1wZHo5WFNy?=
 =?utf-8?B?cEtGZUJsZitRbmZhcEJzV1VKb3JYbXVNekRDQ00yU0RiNGF5a2VJa3MxNzRW?=
 =?utf-8?B?eVViRHNnQitXTXFUQ2dzRWNXR0preVlhQ2Y3RHoyYXNPQVFSRUpYTW5lU1di?=
 =?utf-8?B?QW9FRWFPVmxnTS9KZkxEQlMzblkvZnJwWURtbTYrNm10aW1kVEJQSlZJekh2?=
 =?utf-8?B?dW9RU3ZXZHFWTlZkRzlOTlVwdFJmTVVwVXJGeURUZzduOVpSZHlOZXppNlkr?=
 =?utf-8?B?TE5TRTNWQXFMR2FrQm1PWis2US9ESlRRZWpoL2x6V2JOV1c0Mm80djY4aDFp?=
 =?utf-8?Q?UhsPdK/fx5g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PS1PPFE5C9D9891.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUxtQU9COE9pWFNWL3F0TUFUc25iZEdEZFVRUXVBcTdDMnlBUkhZdWp2SmJC?=
 =?utf-8?B?L2ZRSURZdFlUMWJ3ajJqQWFmajlCd1E0dUNjWEJuUWJLR0MrRmN4amZYNkd2?=
 =?utf-8?B?NHFDVGlnN0g3Q2NYVzdtYlhzaTdONVllRUZzT0U3N0tNbXl5a0FsQWwrQzBC?=
 =?utf-8?B?Sk1ST25WOTJvL3lOcUJRbG4wYkRmUkY1dXZKWmdPYTlKSmUyTVlhUDk5SWpF?=
 =?utf-8?B?dVlCLy9yeUQwTFR1amFIUmtaMVFodkw3YkFxUUdiNXRoUENZdHV3cE84QlV6?=
 =?utf-8?B?MHM1NS90Q3FTNEtFVjNsU1NHb1U3R093ZUZyR3dxRzIzVGtrMGJsa0JQeU5q?=
 =?utf-8?B?L203THBEendaOGFiOFpoMnczU2lzbXhGdXNyTFZwQkdkLytnMDFZb2dEd1Jq?=
 =?utf-8?B?SVMvTHhFbHFVazBqME93cTB1THBZdUMyMksybDBzenFETnpabmZpS21QRWFx?=
 =?utf-8?B?UlkwMHkwWTRFWUF2TU5tbGhEZDdSUVJLZzhYUUkrK3JkZy8zQUhJNDlzUzNE?=
 =?utf-8?B?bHdZMVlSVHJmdE1MNjArRGZVTzlCNXNNKzZqNXZSM2pnZ0hHeko0dnBTWkQr?=
 =?utf-8?B?YnpaaFdDU2ZiWkJtck11SVlRMDN6ZGNOVWt1OU5Zc1hhQXY5L08zWlBoeDAr?=
 =?utf-8?B?NDJCM2FJamZvZi9Zdmc1OHRSVzhaZEpIT3Y4VWI2ZThxVS9VSzZSNVpoVnE0?=
 =?utf-8?B?MXVtMUVzbHViTERweFlnbHBOMUw2VE51eGlhZU43Q0xkK2ZPakJrbEM1VFlj?=
 =?utf-8?B?NHZ0SlhnSjRzRDRYNkRROGh4WWVHR3FqYTdQRUFUd3U0NGlqQWRWRDluMFpY?=
 =?utf-8?B?WjFMc0dZbnhRcUlKUlY1bTNIM05pdzNJUDMweWpwTjBrTUthMW9kN01jL0Ru?=
 =?utf-8?B?RG9seE9qVG5pUHMxaVFMTFZ5MStDY2xsSTFWNStNNGN2VlFOMGVhY1JKbUtU?=
 =?utf-8?B?dEkwOWdGbStrL2FMUkxkZzVTUGN0SGFvWEplaFhFQ01uV2NzeURQei8rbHNx?=
 =?utf-8?B?azVDWUszMkhvakxLSHR2bEZqb0o2WWJhNGtMMUZmMUgxcUN4OWJtMkwrdGlP?=
 =?utf-8?B?M2c0YWY0TjdvVlk5ZXNmZGovclJkSU0yOEpQeDdjNnlQcFVzQk9rMlJXelc5?=
 =?utf-8?B?dGF5NVFteXJaRklNdXUxUTl5aGFHemd4TGxRSnpLUG85K3NSVlVvTlV2ZHha?=
 =?utf-8?B?bUhHMEFFQTgwQm9nTVBTeGJuL05xOWowQ3ZNU25iN1YwNE83aUltdU1PNElC?=
 =?utf-8?B?N3Fwa1loYUduTlJNTXl6djRGZDFxZjBmbWpzcEdNb1g2Qml4YUZQWVovTXVk?=
 =?utf-8?B?ZitkMXhKYnJOSjBCWllqbFI2bkRNa21TRHFLb3FYRHZuaW1ITWd4c1BoVkV3?=
 =?utf-8?B?dFlSelk5MWdWWkhhSUF3b3ZqeDhrcEFxR0hhdkNhN1d5R1lMdWF3TE05cy9p?=
 =?utf-8?B?VzQvNmRiYnovR0NJbDR3aGNkeVczT0N4aU54dExBNTEydmtMejAyZVZhaTJL?=
 =?utf-8?B?alRUV0pBL0RvQ3ZoemJ4a2ZhTFdWWHAwQzc3RHdoblhaMENldmZRRGF2WmZL?=
 =?utf-8?B?S1JudlEyeEVuMUlZNDRITTEvTDZUQmFEeUI4VmZuSHN2NVVmU1ROYzd2dmQw?=
 =?utf-8?B?cWJsUEJ1NG9IQ3FNV21uUWFEZ1hNNVNZV2FGYlVkMytOaGFUWVJtMzRFOUlZ?=
 =?utf-8?B?QnRJZElrZGlzUzZTNnZNdVBvRS9QWXhyNzV4OG9OeU5ZM1plREtNS1RtbXl1?=
 =?utf-8?B?YjJOQ0FGWlludUNZaldoZm4yOGMrOFJpRG9ORUlxOEYzdXlNT3lSUFB0dWxH?=
 =?utf-8?B?L3FPM2szVTZ4amQycnFqTWhQZjNpbXJmdVJkb1VLRVlRNDVNeEhVM3dJZWdG?=
 =?utf-8?B?S1BWajRvT2p2SmlocFBjTnFKV2Nyd2JzNWlFMU9CcUs5aC9sUDVRdXUyNEha?=
 =?utf-8?B?elY3akpJdG9kWlQ3VG4yYlZNVEJHYjQ3Y1FUNEtsTDVrVjJheGl3V2lDSVBr?=
 =?utf-8?B?UDlKdTFFKy9EL0hJTTRsLytsdmZMZmZleUx6NHFkdU52THhPODkrNjV6bHNF?=
 =?utf-8?B?UzN4Szc5TmlsM0MwNzBmQmF5SDd4YzVKUG5Rdm4zYTV2bzJIdDVFaGhVYjV5?=
 =?utf-8?Q?RluBnN1sjK+DZppb38UaHeWai?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b50d2bac-69e9-4f86-b845-08ddcf6095ba
X-MS-Exchange-CrossTenant-AuthSource: PS1PPFE5C9D9891.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 11:59:49.5009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F+AuJe+y9vaJYrJGj/G8auULJuIr5xhozV0MQ2i/tYnObuY9EuI28NFZi1je1eKqztKNraNgFgK4qcviNoYtjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR02MB5951

On 7/30/2025 6:46 PM, Mikulas Patocka wrote:
> 
> 
> On Wed, 30 Jul 2025, LongPing Wei wrote:
> 
>> dm-thin obviously can pass through inline crypto support.
> 
> Hi
> 
> I'm not sure about it. What if dm-thin performs copy-on-write? How would
> that interact with inline crypto?
> 
> Mikulas
> 
Hi, Mikulas

dm-thin's encryption behavior is the same as dm-bow's when COW occurs, 
and DM_TARGET_PASSES_CRYPTO has already been set to dm-bow.

The key and iv of inline crypto are passed in by the upper layer, which 
is not affected by the specific location of data blocks in thin-pool.

LongPing Wei>> Signed-off-by: LongPing Wei <weilongping@oppo.com>
>> ---
>>   drivers/md/dm-thin.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
>> index 05cf4e3f2bbe..42f218dcf99f 100644
>> --- a/drivers/md/dm-thin.c
>> +++ b/drivers/md/dm-thin.c
>> @@ -4111,7 +4111,7 @@ static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
>>   static struct target_type pool_target = {
>>   	.name = "thin-pool",
>>   	.features = DM_TARGET_SINGLETON | DM_TARGET_ALWAYS_WRITEABLE |
>> -		    DM_TARGET_IMMUTABLE,
>> +		    DM_TARGET_IMMUTABLE | DM_TARGET_PASSES_CRYPTO,
>>   	.version = {1, 23, 0},
>>   	.module = THIS_MODULE,
>>   	.ctr = pool_ctr,
>> @@ -4509,6 +4509,7 @@ static struct target_type thin_target = {
>>   	.status = thin_status,
>>   	.iterate_devices = thin_iterate_devices,
>>   	.io_hints = thin_io_hints,
>> +	.features = DM_TARGET_PASSES_CRYPTO,
>>   };
>>   
>>   /*----------------------------------------------------------------*/
>> -- 
>> 2.34.1
>>
> 

