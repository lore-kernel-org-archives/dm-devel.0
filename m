Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2078.outbound.protection.outlook.com [40.107.215.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F335C12C
	for <dm-devel@lists.linux.dev>; Mon, 20 May 2024 03:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716174791; cv=fail; b=C3VdGZkJrzYjM2wGAd8fLmBVcbnzMyYMTsOJzJQ/DWigwujFZ1O4fLS1gQUUAUtSAEkQvoboeF0F6YB0tPFtW1qQCezaiTueDbpreASyR8HTAiK1PsbTHF3Vrwy/gTLVfsYBqFdh5Fmx5NnWS9B/6hG7v5t7HJhvrD0XM2/nFmI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716174791; c=relaxed/simple;
	bh=ErHJB2zlc3BODReSuIG8nYugmscBOGFxs5487yAw8fo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IkSCd7vIqUG7+g/8JPCbC4ajO73l1ZEU4j+vDGO9k+E3estjLKN5oWhxXqKwtMxEGgwCGC5vIDUeaFr63VKpqPbp6XKhc8OlmTshxJdqrk3rRA2RLjjdFCSlYqOch04TCb3Yawt39RyHeydFglk5hExh3f9nv1AkgVt54NflArQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=JTT1Dz31; arc=fail smtp.client-ip=40.107.215.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="JTT1Dz31"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/Z2jgGypHvLe3Zi+cEkrBhq8E2++Zz96Jc70PseaPd2WWcePXK/zwYfKn4CRBbqvxASbrlTIJeYnD8LYjYBT1fTzSp5ftpyYJAAHhkLQpHFRz8LG76ZfB7SGilEoSe+cTSqQ03ckZRXKCJebWAitxmDh9qra75XnDKjxn0HwQAWGcJ4IyVP8UVTYan2FdoJNXgAcxhlwo3Gorplv0UUKcBCitp+cd/8kMP1ZcAvaFIt2e1niC+Af9nUIHF7i1GvjmSpCCLOQSvIN38+m9AaH8OmLxS7Rz5QrrOfNG1o64ozFibfcQQgIPi0YQrrjJpjEbTRvSBFCtEGGhnbSTSykQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yf+sHPCcXXIv1k08zT5l63dPtVEzabNk01gc4MUIbzo=;
 b=jPF3reITUgxhq1fRznW9xipwVXLcjYUOZooxNobn5MWVeX0i2omaFQN0rS1Quwg132nXoLOdEtiZULElh+Zl/oxUAmfu/5GuUAzjdai7bujG1XMOYBloM36DNLXVomHIhBhOCbFdFJRshjErKkBZ7L0pbPsMTOiPaP6IkQAvTMdDC/Pz6XXd+sktZbAMME500Qx5vTsi0VaMBj9pDMGf20wleEls0Tr0d6U/BCVMm6+daCaDUXV9DSNopXuH8ri2jT2+zSD+4//NM9timtTG4/TWrkcHIpuIqXQssB7Wlc7zVx/ZX+Bi4b0zKLr/HocS9b8evueAOLxJ6yy4ZBZ3qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yf+sHPCcXXIv1k08zT5l63dPtVEzabNk01gc4MUIbzo=;
 b=JTT1Dz31guxpSa0UUmhNzTfnpivrBZ5zBNNmzw2srMkXOB74GFV3JfiyX7ReXhwiqlyhCGDMUjx15GUg66J+48Q1f0VQaOTu4jP2LCfNZn1E/q7Z61cLUIEr0991TZ48LiVLDLG/YMIMY5QJSea919B7JPO1zIse0aubqiwRJynBG9h3iyTKeqxN2C/M//WtbuOqTmH/N1d1ZiuSGvFlBm0DGILvBryij7TIZL7pZpsvPPwIom2WLuE6DnK78wp6FOmV9YiBu/89kphT1GjKUykFs2pNo3LpbM4ejl6/NSdNzZIhe/jOilGzR/4y2LzU0FnUqETA/iAhxpV2iGk83Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB7401.apcprd06.prod.outlook.com (2603:1096:820:146::12)
 by SEZPR06MB5392.apcprd06.prod.outlook.com (2603:1096:101:67::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Mon, 20 May
 2024 03:13:02 +0000
Received: from KL1PR06MB7401.apcprd06.prod.outlook.com
 ([fe80::f4f:43c4:25e5:394e]) by KL1PR06MB7401.apcprd06.prod.outlook.com
 ([fe80::f4f:43c4:25e5:394e%4]) with mapi id 15.20.7587.030; Mon, 20 May 2024
 03:13:01 +0000
Message-ID: <7e84c37f-e3f0-42d3-a9b7-c810b641b95b@vivo.com>
Date: Mon, 20 May 2024 11:12:57 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] dm: support retrieving struct dm_target from struct
 dm_dev
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20240514090445.2847-1-yang.yang@vivo.com>
 <20240514090445.2847-4-yang.yang@vivo.com> <ZkTXzG1yrPmW64Z6@redhat.com>
 <80ddcd90-2e1c-4fbf-a45a-b1b5ff4d60fb@vivo.com> <ZkYmZaGWPtGIwedG@redhat.com>
 <8f49b95e-88df-48b8-9311-8a15414d8107@vivo.com> <Zkdqpl5SN3RV0smg@redhat.com>
Content-Language: en-US
From: YangYang <yang.yang@vivo.com>
In-Reply-To: <Zkdqpl5SN3RV0smg@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCP286CA0244.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:456::19) To KL1PR06MB7401.apcprd06.prod.outlook.com
 (2603:1096:820:146::12)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB7401:EE_|SEZPR06MB5392:EE_
X-MS-Office365-Filtering-Correlation-Id: 6670b4a3-9047-49d4-3261-08dc787ac1fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UTdPWkFJcloyRDhrVndJTUoxMmFMemNZUDVkMitEUUFCNGlOOHZyNGVDd2NE?=
 =?utf-8?B?WDJkd3hidm9PcGgyUG1XZkF1MDFtTDFHN3BXS3NVNlRVOEtxSEc3aFVJbWVL?=
 =?utf-8?B?YmFWRFI2UjlYQklNQXZWNEJlM3VvOTkwbkcyYXlESkpIOTZpc2xNZFR6VlpE?=
 =?utf-8?B?Vng5ZjFPM2xiWGNxTUQ3UDkyWVJZQ2ozQzFORVZpcTIzNGlHRnF3Q1N3NzZZ?=
 =?utf-8?B?akd3eVdsNUdMbUFZMERtZEQya0NsVUVJL0pWdjE5UzhTN3F0NE5PMC9kQWV1?=
 =?utf-8?B?KzBnRW5wMWF4bGhqS2YxWGFkU2VBREMrVzJvVVFIS05uTTlpelVJNjRka2k2?=
 =?utf-8?B?ZjBzOXphTjJUeWlvcW4wNFJybEpjUGp0ZmtuTTFqR1Rad1RFU3F1a01wUjNo?=
 =?utf-8?B?dDczY1JTRUR0alJKVGI3ZERUcWMwWnRhVkVDRjFBN2xpTzVWT1NhV2dIalhi?=
 =?utf-8?B?aVJSbnhSRW9rZGQxcFV3RmZDeUFsaVNRUStnOUdTWkdiUHZmTGNhWE4yeGEy?=
 =?utf-8?B?emxaRHBoeUZHeUFQU2wraGV6OXRmdmthN1hpcGUvWFpndGpieksyNVltVzlk?=
 =?utf-8?B?VXJVVVlyY1FIR1R6MGk1OTdiUndRQUozaCtmdFcwZDRobFVmdTZZaXJSN0ND?=
 =?utf-8?B?QzNVYmFrV1FhTWxHTG1zRFZVdE5kNDA0Zm1zaFVDVzZQRWRkRjl1YU1FNndu?=
 =?utf-8?B?S3cwWS9MTlI4eEJJV2dXdWxZYVhNS2x4SVpIWXdJSlVpZTlZeVR0K1phdktq?=
 =?utf-8?B?WWZHQkwrbXpKRysrMEo3VkNDZ3BMekc3b2k3OGEzam83MkkvZjE3UDJRY0RF?=
 =?utf-8?B?QkxaMVJJZncvLzFydys1OHFidVpqYStBMGt6SDMyVVkvOVRtTTlYZTVHeTEv?=
 =?utf-8?B?TklaNy9WbTBoRjNuKzJnVDlkOXk4NWZQRmFqS1FxOThmTllHNlN6K29TbzAy?=
 =?utf-8?B?eHpZQ1Z5Y2R4WFJ3aXlqUVZ6MHBHLzlSS3ozRmUvUDNHcXFDam9tMnp2aXdl?=
 =?utf-8?B?OGc5NlUwS2ZReWpPZW52Wkh0bUZubU1qZ295aFMvaFZJZmFuV0JERlNURUUz?=
 =?utf-8?B?c1ErMXc0MVpjV1Z5UjhodVc4NDdvQjZUYXlDa1lEVDhyOVRvaUFJdkV2MGg2?=
 =?utf-8?B?WFlCSFh5K1V2YW5Jby9Id05LRTh0VStjditvL0NaQXNZcVhoalhhc1RaSFhE?=
 =?utf-8?B?eDE4eGNJK0NCcitISC9Hc1VTdGkrc0NUdEVIazQxQWtWNm5yYUkxaHBUTzA5?=
 =?utf-8?B?VU9yRkVYQTBKaWxVdkRBdTNQemd5OVIvYjZTUW55Q1BpU2prSGtOS2FYbGI1?=
 =?utf-8?B?OXlGeitiQTZpL1N4clZTZHd4eWNpZ1J4YWtBQ21vT1ptQUMweU5PaFJGWC9a?=
 =?utf-8?B?OU1CeXhjZ2JjN1RBMWdJVklXUVNMRlk1VFRNTGhsV2g3Nm1yQlEyWS9iNVA2?=
 =?utf-8?B?ZVJTK1FaTUdqb2d2ZE5XaFQ0V2V5bTRYZUxqK1BPekhzT1hCWWlvOTRwYVhy?=
 =?utf-8?B?eWVmVHM1S1djMWVlNUdSTi9Tc0toUnhGU2s5a1pVNnBWbTBhSUpONzVBNzU1?=
 =?utf-8?B?RDNGSTA2TXlVWXFLdnpDTGloc05UNkM0Wm02N2NZdFFRRlZmZCsrbmY0WE1i?=
 =?utf-8?B?dlhFQ1dXb25leHNWVWlhTGtRQ29WbkZuT0RRczAzUFFTdExWTDZ3ZVZNTXM2?=
 =?utf-8?B?OTlzM2NxbjRYTHZjZStDOURqVDFpZ0Z6YUMyR3NVbk0wVk1uRGhWME93PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB7401.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZHZFcWYxLzBDcjFvLzZrUndGck82Z0lmTkZVa1ppOVNNMWFpcFBNcDZZRkt5?=
 =?utf-8?B?MXc1Q0pBOVNHUk9ndlhFa3E4WlVGK3grMWZra0twSzZMU3lrdjExTjAyS3kw?=
 =?utf-8?B?WnZIZ3JhRE05RFpGeURtOUNaVG1TbjBSR1ZLbEhWWUN1RTFMRGx5amJRdWNr?=
 =?utf-8?B?Z1ZTZ2JhaFZuUG5yNE4va3duSXA3aWhaaFdaWVp6dkdrOEVPcit5MEQvOVVn?=
 =?utf-8?B?UzRvUUwvWXNiRXhncXFEMEpaa3BtR3lIZ1FWUDZ2ZzFnaHcxazNFRGpiVEZu?=
 =?utf-8?B?cVZ5emRkdTdpYlEyMjJ5WDM5S2sxeUJkVWgwaXFDaEFlV3N4ZUpKaHlac1Ns?=
 =?utf-8?B?OFRIMmxwV29PaVJzTnByYzcwakRXSzgwSnYxSTkrVmJ0RmE2RFloQ3VFZStV?=
 =?utf-8?B?RzIwQlVrYnlibVB1VXpvb1ZOajhKQ2xGYmtsQ1duRk1BZzRyUm4yUno2ZW1Q?=
 =?utf-8?B?NzBTQlY4WG5GaGhWdVRLaEdwdjZDZmQyTVRVVG9yYm1pOS9vRThlRURnRDFQ?=
 =?utf-8?B?TWFXd3JXZU5Hd1Vhd1cwTHlvVkxNc29ZSzRWK29xdVFzeUlJY3R4WFFUbTZJ?=
 =?utf-8?B?VW0zK3lwQnU3QVUxYzIrWWQxczQ5NVMvSXhuc3Z0V1UwTTBFSDRZRHoyd1Rt?=
 =?utf-8?B?MGlKNFgxL2ZuU3VsU044VHArRzZHdzVQSVJDbzdPWllCUEdPdldrb0JqTlp4?=
 =?utf-8?B?Ny9zeUVCTGFMdXZEYU1BSjkxS3RxNFdseTc3eFlxT0JlUlpaMFBqOTlJWkMz?=
 =?utf-8?B?RjFNb0NHVDBZUXdabHVSS0hmMFoxaFh3ajFueG96b0c4VzNkMGJWeFdlSFVr?=
 =?utf-8?B?SDdkZEY0ZWd3UVBORTdzY2RwbHFlajdpdWRxUDdyQndtdTJKdzhDb3IwOFRD?=
 =?utf-8?B?Z3c2ci9aY0M3WHJPQ21jOVRDVlJXTVN1Q3VxWm5Fc0dmaGZuK2hXaUFMalQ5?=
 =?utf-8?B?S2NUck8zYy9EeWZtYjBaaVNJQy9uSFBHVjdkdjBicFVwbnI0cS9RNTBybkli?=
 =?utf-8?B?WDBzTzNqK21NUlhUU0EzQ3V5SS9mTTdRbndLcjZnUmN4Q2FJWEhPekdwYWJh?=
 =?utf-8?B?NklENndacFY4ZGpDdEJONHJZdHA3RUFlckZ2R0U2ZkFBK08yVGJyK2ZKWDVL?=
 =?utf-8?B?Nzgrdk5TeVhlaWdtQUFlYkJtZTdENFJ1VURORlFFNXBIZDhMM1BLOUZBRjV0?=
 =?utf-8?B?RUNiektQT29reXZrNDZVSE5GY3M3SFZSZkVDcTFIVkk0OXdFVHZFeGdUNUtZ?=
 =?utf-8?B?U2VZZHZYTE5Ibk52cFRxeE9LeDljWlpwQ21QUzk2TG9oUnlxTG1yQ2V3ZzEw?=
 =?utf-8?B?ajA1V0trNW5FNzZtRHFtM1VEcVhxVVUwQ2dwc0syd1dGcDIyZjZRcU12ODBh?=
 =?utf-8?B?cUtXTFJuT3B0MGl3ZXJ6MXhaSjhnVGM4dHJRQzY0cG1LbUZjZlhLOFNWSzh2?=
 =?utf-8?B?L3BqRTlWWm55dXk4aTJQRkJINkJ2ZWl3KytMdjl1eXE3anZ3d1p5VDdYcm9q?=
 =?utf-8?B?T05sbmFWL1V6RVRLbS9CSzJIWDc2blpUZiswei9zOGVRZlBUbHhMYjVtNUg3?=
 =?utf-8?B?ek9INVZac0d6N2RTc00zbGFCMCtyZlFHMWt5VFFhc0MrL1IxWkxCT1UwbWtP?=
 =?utf-8?B?TjNQeGdoY0dzWmVJT3VZT2FqVVJienRUdG1UTUxSOUJNU2J2Z3NIVmZyQktx?=
 =?utf-8?B?TlQ4S0xYTWtLbzI1aFdJSk5adWlPbzM4d3R6Z0U2UC9WU3lVMGxOZG5KV2l4?=
 =?utf-8?B?RUxzYzJFRnFBeWVyMjlQM0tRT3ZYTjdVdForQXNQa1lFWmRhKzJUZnN5Y2Va?=
 =?utf-8?B?VGpkSTFJYWZsRmVKZDY1SmxkRDgyUTdua29WTGpLOVpLN2xpeU41YkJiQWRF?=
 =?utf-8?B?L291cmo4Z1gvdzFjT3hGZmxYNWZ1aThNSnVvMENyNlZRdjZyTjB4R0lLaFRy?=
 =?utf-8?B?aVNEemsvLzRhWkdlNUpWY3pzTU1CR2xBb0RUaWhza2dESzZVcmwraVZhbktV?=
 =?utf-8?B?T3F6TzlVK2hwMWF1NHgyNE9PVWZVQmo1VkhoVTFWei8vcmJOSUxIclo4b3pI?=
 =?utf-8?B?c0lJRjNkYUlhZDFqVFh1bUl6Nkkzb0dOMjc2L1pmOTlFUEJ0Rmd2TXpnOVZ4?=
 =?utf-8?Q?xOUPdkYkYk1EmkN/awPV794vw?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6670b4a3-9047-49d4-3261-08dc787ac1fb
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB7401.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2024 03:13:01.7322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bzo6d3DGzgtiAjhGhJgGdFxnUwaIf6+gcGezuGlG3kXy8DinCafjDEUVqm2rrLSN5MzrV8m/VQ4JycETW7ptAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB5392

On 2024/5/17 22:33, Benjamin Marzinski wrote:
> On Fri, May 17, 2024 at 03:48:49PM +0800, YangYang wrote:
>> On 2024/5/16 23:29, Benjamin Marzinski wrote:
>>> On Thu, May 16, 2024 at 09:55:53AM +0800, YangYang wrote:
>>>> On 2024/5/15 23:42, Benjamin Marzinski wrote:
>>>>> On Tue, May 14, 2024 at 05:04:42PM +0800, Yang Yang wrote:
> 
>>>>
>>>> If I understand correctly, you are suggesting to iterate through all the
>>>> targets, handling those with sends_pass_around_flush set, and skipping
>>>> those where sends_pass_around_flush is not set. I believe this approach
>>>> may result in some CPU wastage.
>>>>
>>>>     for i in {0..1023}; do
>>>>       echo $((8000*$i)) 8000 linear /dev/sda2 $((16384*$i))
>>>>     done | sudo dmsetup create example
>>>>
>>>> In this specific scenario, a single iteration of the loop is all that
>>>> is needed.
>>>
>>> It's just one iteration of the loop either way. You either loop through
>>> the targets or the devices.  It's true that if you have lots of targets
>>> all mapped to the same device, you would waste time looping through all
>>> the targets instead of looping through the devices.  But if you only had
>>> one striped target mapped to lots of devices, you would waste time
>>> looping through all of the devices instead of looping through the
>>> targets.
>>
>> Yes, I get your point. This patchset may make things even worse for
>> the striped target.
>> I am just curious, in what scenario is the "dm-strip" target mapped to
>> a large number of underlying devices from the same block device.
>>
> 
> I don't think anyone in the real world does create dm-stripe devices with a
> huge number of stripe table devices. My point was that it didn't seem
> obvious me that looping through the targets was a significant problem
> compared to looping through the devices.
> 
> At any rate, Mikulas's patch already does this optimally, even for
> targets like dm-stripe, so it doesn't really matter now.
> 
> -Ben
> 

Yeah. Thanks for the explanation and your patience.


