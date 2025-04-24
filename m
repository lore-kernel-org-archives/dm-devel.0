Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012051.outbound.protection.outlook.com [40.107.75.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530ED226D1D
	for <dm-devel@lists.linux.dev>; Thu, 24 Apr 2025 08:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745483770; cv=fail; b=HJcZsqH5pfdPMfxBUB4iZwmxT1BvO+zFLuxqK2Q0pksb4ILyxWvKN+zzR8gSjlPGoqy39ELQ3uf9AFaQYov4B8XQnud47TxLOhPEuP7XkhE9ep0RFQXoJNwfeZpEYltFFUeGUbOdx1akvOPNa4DEqvvWejZO2ONBPEOAhr6yTpU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745483770; c=relaxed/simple;
	bh=Lg3x0myeTs4QbRajz0tVik7Yci29M4dWZIrGvH2lDbA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lkpeI4uGJL7/Nx6RhlZSnvYiUTZQma/IOqwIsZurObapbO/yh+doaGQCCfcnV2ZvaQO10RBZNMm4s9Cjham710SrdLm9mdbF6WJdkLIkLdDImTc/BTaRGtHN0QX3C7uAL2bnjOJ/eRCXeLHMTYGRdJFmrF562Ce75lCy0TpoO3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=EQQzqRhp; arc=fail smtp.client-ip=40.107.75.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="EQQzqRhp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HL3ZqS0lWBk1+fbA7eV+TXRYaoPN6R2xb93PT9DzAVHPyz5AFRpm5t+ubtiS28iJF8Hil31yhJtE4IFQNMUu+3tQ1MZJ9ZcdoOaVJqfOqtnT3yEVbC4wsHuh0RfF3o2qGAPvXzCsqVdtim1d7p+rRUVSbqIrnmkXErCUvzXQpKwRZLiUXV0zuOcXggGlExvZgfi4L9qWdMoNs+EMey6ZJ+USizNtsVAFC3x+e/ybqbRoICrzilX0TpyOjl0f43eoQ78eU3LisDN40iipeKZG9pLsNuSul7TGCtLi96mKAETAsypDCDv5WOIO613tLOi72ORxrrKOL58rO00sOoP66Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AZEKDOtx+RjLM+BZkqZVGjuXzGeAzCSaOCD42n9VWnc=;
 b=pS3kzgI2w252UDNMtDs0yzdFiJlCMXOPTbjKQTkScMTFBDojWJzMReFvhvHpsuYYe2qkrl0H27eTACpcmt7W7VcjDbAQlGFF9eUueGh8/rG29I2LKPaq9N6IkyS+ovikxu5vA95QTvqN/VKEvkGrPJnvvFMIztc+QsVc6DKW3rzVJIgNXStiE35EEdunmoAJEqHcAQys1WiiT6nX5UyulrdQ4Hr6XPWmWmyrJHZ1/qSTMlsGd1IGsjyoE9qMLcGtvUocFpKm4joxCfVnI6b+VHGn5tPdVoa6GYSL58xp+IVYQnBlzB+rCe0fYsP3UsCfIz7m6zI1hGqEcXGULHnbcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AZEKDOtx+RjLM+BZkqZVGjuXzGeAzCSaOCD42n9VWnc=;
 b=EQQzqRhpa+hxE4JcQeeK3m+35ipjrmbB6OMnnu275HMJM6wpUrnPo648lks0ww/PCeICagMabx4Tu2UVGGMtMRJtKlpnI6ajFnTTMb9Nd8N/TQxagxHX9FaJQBe9iXz5+pZG7PBkBztf9vy9Fwk/pzQbUVigJL2kvDJAH+Ug1Kg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by TYZPR02MB7929.apcprd02.prod.outlook.com (2603:1096:405:ac::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.22; Thu, 24 Apr
 2025 08:36:03 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8655.033; Thu, 24 Apr 2025
 08:36:03 +0000
Message-ID: <c5197236-f2e5-40eb-af4a-32b62706e992@oppo.com>
Date: Thu, 24 Apr 2025 16:35:59 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-verity: all verity devices share the same dm_io_client
 and recheck_pool.
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: snitzer@kernel.org, Alasdair Kergon <agk@redhat.com>,
 dm-devel@lists.linux.dev, guoweichao@oppo.com, ebiggers@kernel.org
References: <20250423115013.4004577-1-weilongping@oppo.com>
 <4e48044b-0481-4d3c-9138-0c636d5a1a8d@redhat.com>
From: LongPing Wei <weilongping@oppo.com>
In-Reply-To: <4e48044b-0481-4d3c-9138-0c636d5a1a8d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0082.apcprd02.prod.outlook.com
 (2603:1096:4:90::22) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|TYZPR02MB7929:EE_
X-MS-Office365-Filtering-Correlation-Id: dd4fe2d1-327d-444b-8664-08dd830b0be1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZWUzMUlMcjBCTDJjQVV0Vi9pQzkxb25HSmh5anFXeVN1cjZENzhLWDNqWEh3?=
 =?utf-8?B?cG5DNnovNWhLczR1SWt4YmVVZ2NZQ1ZwNjlUU0xwdVJrYXY0VFdqZHpoM3hP?=
 =?utf-8?B?NDFLeHU0N0MxdjFiMW8vVEszMkRvNEVTVnowSzduZ3RHTzNNN1FDSzNLZFNl?=
 =?utf-8?B?aktEZUNOOS8rOGw1OW1KUzBINDJURFRtTE5GbDlJV0V6Z2x5QXBsTkcwVnlF?=
 =?utf-8?B?R1ZBRGhMTVh2b0xuVmYxalNJbHhpQmpqMUZRN1d6N0FCYXZWdWoySEVlRTFt?=
 =?utf-8?B?ai9jVmUvN1B0dkR5Q1dPeVppYkZzU3RHdityL0N6S012aUlVUkZoRTdQRFhS?=
 =?utf-8?B?UUovYlN2NW93ei9rTGFxL096M1Z2WkRLamk5bVMwTWxFbW42Ym1IdGljMEpO?=
 =?utf-8?B?YXpkSnNLenpzOTdDU3IzV2JaRHBWRXhhM2N1a0Rhd2l0emhrakN4TlVvMm5m?=
 =?utf-8?B?ZEZacEZ0ZjFpYUQ2d2M4MS80akx6NXJMNkY5blZxUUx3bVpDUmsxdzAyRG83?=
 =?utf-8?B?b1ZELzA4Q2RZbnRTemdrdkZQVGlTejUxbDlNL3l0M3NObjRJWFE2aktrUWdS?=
 =?utf-8?B?UWVJb3lHVEZZVVdyYXJkYS83SzhkcVFjVWRqY3MvMktCRVp4UnMwVnkxc2tn?=
 =?utf-8?B?OTRpM283SGtFU3J0NXMxQXVWTXJZaGpZWGVTSU1iZTFBU3hnRWpGSHdYZkxH?=
 =?utf-8?B?dE5nbCtja3lOVGtWNVIzNVlDTUJLU0V4QWNJODU3aDJGdDFlNnpGcGl3REdP?=
 =?utf-8?B?UFJCT0NONzF6TldmRG0veXlkMWV5L0ZBWUpxaUJQYUlzdlhEWExFL0wvVCs2?=
 =?utf-8?B?c25Tdy9aVkZMU0FpeFI1MGRtRTJBcVhUdFRGeGdwWEFucGpvR1M0MUVpS2RD?=
 =?utf-8?B?WmxWUVhBOWhvR3dENnhuYjRVK3NNVkVGTUpwUVVBdFVJeVlMQW56QThCNUc5?=
 =?utf-8?B?MGpxZzBhWjFnMDRLWlhMZllwME9yM0drQ0g5M3pnVjM5VzRvdXdlKzNHaEFw?=
 =?utf-8?B?WTZxZUwrTUQ4WHFHYkVwemFXL2Z4QnpoVUxkalB1Ykt3VlN4RlZlYlBuSWNO?=
 =?utf-8?B?Z2Y2NnVPc3p4cG5tWm1LTlNuaGQ2S2hiajhUUUVXVEZ4Nmp0K25NTng5OUxj?=
 =?utf-8?B?R2FaQ2ptbkhxM1dLS1hBdnIwM2t1VGNqR3RicGZsUlNKUDNhWWJWTEdDU0hT?=
 =?utf-8?B?NnhPekFYNG4rb2pNYlNLQm44SEJITzFMS3prZnZHQ2lMOFZISXI5MDVQejJ0?=
 =?utf-8?B?WWZIcWhVbkViWEZGWUtFYVlXWVRocWJ3aDZUSHBZUEVCM3g0QjN3aHRPUS9n?=
 =?utf-8?B?bVdEd1VBeHU4WWNycm9tWUczV1VYdWxtUXM0cXBwZGxvVE01eUVJaW1zSko3?=
 =?utf-8?B?UU9FeGpvK0hBZ1R5UmlPd1hQYStkSXI3bjl0M08yN0tROG8vczFvZENPbFdq?=
 =?utf-8?B?dk03NXRlYTRVYmU3N3Y3bEZ2R0JsVm1iQ1dWNURuYTNYcDhKcWlxTVFKRTlR?=
 =?utf-8?B?eU82QkpuTGoyWHJiSjJIM1lFb2lIeUcvdlZQSHl1ZHZ3Q2hVdEovRVc4ZFgw?=
 =?utf-8?B?R3Q1QXB4SUxiYk1HaGp4cHYrUTJWZXdsNVI5RlV2SnRrOWxFcE13a2crV29z?=
 =?utf-8?B?M3lOelU2bHlzUWJ1RnlRZ0F0N1pOeXh4RFh3NXFoSjREWmVuSEo3UTZSQ0Jt?=
 =?utf-8?B?Ui9qaStNQVFlbXdLbTdLeGhwMkJiWlRENlNSYVQ1bHRweU1YbTRUVHdLbWxM?=
 =?utf-8?B?R1o0Tk5VSTM1bmQ2MzNpOUJ2REVVK2hqTEd4dHkvK0VMeDJLenJqaUhBdFdq?=
 =?utf-8?B?ckdNdWYrWU9ibm9hc1FwYno1bFVEaWNjYzBBNElKYWZ3VUlGMHE1c3dseFNx?=
 =?utf-8?B?NmcwRllkQmk5OU4zZ29TcVozL00zeE9WWE9TckFRMjVsaU5MR2R3MDhZVjhv?=
 =?utf-8?Q?zcDd/VFb3so=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aGhBRTFlOEZoQWdMUU0xVTR1TWdmMnRkTUQ5M0hGUmtPRzk2ZVVNSmlJaENj?=
 =?utf-8?B?OG1HLzNuNVNxdFJxUXF0dVEvc2lEcVlpMFBHaWEvWGJib1l5MDdydEl1WUtp?=
 =?utf-8?B?d3BTUnhFUTVjRmZ5M050ZDViSGZxOE5tdTR1YjIzTEpJc2dSb0tIUXEwRkdW?=
 =?utf-8?B?SnMzbHVCUDBvdHVVc3MydmsrZXMvUERCVjVWUWQ4UjMvQy9sNzM3d1N3K1Fy?=
 =?utf-8?B?eUpiNUdRL1dZeTBEZjlvdEdkTDRqVWdubXJGU0NlOVk0bGowcFJVWnM0MzRs?=
 =?utf-8?B?MXBKRnF5ZkNJVmREQ0NHaUEyTjBYeDVvYkxXVmVzcGlmK0U3VE1JcThyZGhw?=
 =?utf-8?B?VXREZHdZeWRaUjFqOXVkblUwaVY3cG1DYkNRMUdGRVRnT3NKYzNpazdUWVBQ?=
 =?utf-8?B?MzFTa2NaQlpKY2VtSkxHQm9FNndzdnVCRVhnYnBUQnRGNVFlMzBLeGw4aXpy?=
 =?utf-8?B?aVZFQ1B4ZU1aWHFQY201ZlFOS3BLWXlHUS9pWEhUZkEwb3lvRGNhNGY1dzQx?=
 =?utf-8?B?NHhQeUpRSVpiYXJ2Tkd5MGxYcGhvNTV2Q3g3WURwazQ3YXY4aElsRjZaaHgr?=
 =?utf-8?B?bURENlpYMHNQem5nN1QyNkgxcmJMRFMyK1JpbWtrRGoydEhERndHOWpiVXMx?=
 =?utf-8?B?N0xybmNoVE45UUJCTkY5WVh4Z21wQVEwRWxnRUZPRzFmVnhmNjBvTHVVdmNm?=
 =?utf-8?B?QjZkM1dHdmVrRUtGc1pYMC9QVkhrSzBhMVZYdThleERUSy94RjNrdGNsZUdW?=
 =?utf-8?B?NUlBa3Fhc2NhbXBRR3k2VElaNHRkdGpNQkFXQjlIWjRTUE1LUTFZN0dCYWNx?=
 =?utf-8?B?NWVkWXZQa1VjS0dHSEhCZkZpSjk4QXVWSU1NR2FTYmdJMys2MzRqZWt6YURS?=
 =?utf-8?B?NjZwekJsRzVMVzZZVXdEV0I1RWU5QytqUDBQbHlYNjl2QVZSNjNrUW9YUFNo?=
 =?utf-8?B?emFFV2cwa1k1ajQ3WCtxYjc1cExUUFFhY3NoVEd6aUpzN3N3N3paajJFT2xV?=
 =?utf-8?B?OFFUNWF0QnlNNHBmaVRNVDFhSWx5dGVXTWhidXl2Vjg3dkJCZEVBYlk2K0pZ?=
 =?utf-8?B?aHhUYlk5d2VSQ2tjOFMrNU5yaUpuSDlBamxEcFlYcFB6Tk4wZkFGSnFiSEhq?=
 =?utf-8?B?RUliazdYTFpMSGY3MkNxYmxyVFpCRUlxNVZPdXRYcWtEVVFJT3Y1SVl4TnVq?=
 =?utf-8?B?N0s1dFY0WUN4RVVLUWJ0d2NCbU4rdllnZzBkckFFa1M4M2hOY3JDVXdyZVRv?=
 =?utf-8?B?c052M1RjdWlrbTA3YjdvQzlCV0VqM1ZtRU8zcHVRVDdtQW8ydmo2Q2t6cmcz?=
 =?utf-8?B?THFjcjByZGtLYWE5elpLWUg3NGxDM2pXNW9FZUxVUStoZVVuKzgyQSs3bWxs?=
 =?utf-8?B?aGNoQ0ZGdnh0Ynh1ellaamkvR0FlaXRTdWRjYlRTYWNPVGllSTI0SzFXbGx3?=
 =?utf-8?B?TG9PMS9qajcxQjRkS05ReXZGWVZlRFFyRzBwck1QRDgrSTI4WGl3LytWYnhX?=
 =?utf-8?B?RW52NHJmdlZnSldQTlkzRUJ4WGlJbmhCWTNIN1UwajNEbjliWW1zU2llUW1j?=
 =?utf-8?B?Qi84ZDh0S2UzZjN5NGxTWnZGTXZkSWNDRnUveHBqd0lYVUlWd1ZtandYNWx4?=
 =?utf-8?B?bVVlK1J5R0lxOTF4TVVqNUROSkhsblNWM0hYVFJTcXFXWjhQRzhwS1p0VVQz?=
 =?utf-8?B?cGVsWHpoVE8rMWVKTmZyUDJCOGdPVWlmMGJPTGx2TXJCZFNVUXZlbUw0NzQ1?=
 =?utf-8?B?dk9SZlpCYXdwY01yRHo4OWpNSkVTQ1ZEaExOOWxKZHhrRkJqaWxmL2dTNDZV?=
 =?utf-8?B?eVdyMEQ2dU1qQ2dleWFtckhIUG50R2tnQlFNOTVheDZuVzIxY2dQc0JGVE9r?=
 =?utf-8?B?cXYydlhnRytpSzVYMTRKdGx0bmVUdGQzckZCV0ZxZVNYQjVaOHEwTFFJMjYv?=
 =?utf-8?B?am1Qa3NuN3hZQ1R6cUx5Vyt6b29KMmxHOWUvWUVIMXJWdTE1ODJHNUN0bVlo?=
 =?utf-8?B?VStUOUhxcUZBSjhtNkFtNkVyR290VXRMTUpvQzZ4TjFrdVBqTVhzSXhvNDY3?=
 =?utf-8?B?amk1b05Nem81alpVV3QxZlgxbk1zN3lLbWduZDBEWnNtK2Q0a3hFZzdWTnF3?=
 =?utf-8?Q?ULGbVUy51V7CwwVgh9vym/DMj?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd4fe2d1-327d-444b-8664-08dd830b0be1
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2025 08:36:02.9214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vmkHfO0zON0v5T/pD5BU94CyAY9RtXQOOoxlFB8C4sf1YomVScl/3gqI5x+N940/OA1ZDMGrQw261Ec3XDy1DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR02MB7929

Hi, Mikulas

Thanks for your suggestion. I will test it.

LongPing

On 2025/4/24 2:46, Mikulas Patocka wrote:
> Hi
> 
> I nack this series of patches, because sharing mempools (or dm_io_client)
> is prone to deadlocks.
> 
> If you have two dm-verity devices stacked on each other, the upper device
> may deplete the mempool and the lower device has no way to do forward
> progress, resulting in a deadlock.
> 
> For example, suppose that you have dm-snapshot on the top of dm-verity on
> the top of another dm-verity device. If the kernel needs to write back
> dirty memory, it calls the dm-snapshot target, the dm-snapshot reads data
> from the upper dm-verity device, the upper dm-verity device depletes the
> shared mempool and the lower dm-verity device has no way to make forward
> progress - deadlock.
> 
> If you want to reduce memory consumption, set reserved_bio_based_ios to 1,
> that should be safe. (setting it to 0 is prone to deadlock).
> 
> I remember that the one of the first things that I did at Red Hat 17 years
> ago was removing shared resources from device mapper and making them
> per-device :-)
> 
> Mikulas
> 
> 
> On Wed, 23 Apr 2025, LongPing Wei wrote:
> 
>> The size of biovec's memory of one dm_io_client will be
>> reserved_bio_based_ios(default value is 16) * 4KiB memory.
>> When the number of dm-verity devices is dozens,
>> the total memory size will be several MiBs.
>>
>> The number of dm-verity devices is 59 on my test device,
>> and the size of biovec's memory here will be 3.87MiB.
>>
>> This commit will reduce the memory usage of dm-verity
>> by making all verity devices share the same dm_io_client and recheck_pool.
>>
>> Fixes: 9177f3c0dea61 ("dm-verity: recheck the hash after a failure")
>>
>> Signed-off-by: LongPing Wei <weilongping@oppo.com>
>> ---
>>   drivers/md/dm-verity-target.c | 71 ++++++++++++++++++++++++-----------
>>   drivers/md/dm-verity.h        |  3 --
>>   2 files changed, 49 insertions(+), 25 deletions(-)
>>
>> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
>> index 3c427f18a04b..986c3386aa59 100644
>> --- a/drivers/md/dm-verity-target.c
>> +++ b/drivers/md/dm-verity-target.c
>> @@ -72,6 +72,9 @@ struct dm_verity_prefetch_work {
>>   	unsigned int n_blocks;
>>   };
>>   
>> +static struct dm_io_client *verity_io_client;
>> +static mempool_t verity_recheck_pool;
>> +
>>   /*
>>    * Auxiliary structure appended to each dm-bufio buffer. If the value
>>    * hash_verified is nonzero, hash of the block has been verified.
>> @@ -449,14 +452,14 @@ static noinline int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
>>   	struct dm_io_request io_req;
>>   	struct dm_io_region io_loc;
>>   
>> -	page = mempool_alloc(&v->recheck_pool, GFP_NOIO);
>> +	page = mempool_alloc(&verity_recheck_pool, GFP_NOIO);
>>   	buffer = page_to_virt(page);
>>   
>>   	io_req.bi_opf = REQ_OP_READ;
>>   	io_req.mem.type = DM_IO_KMEM;
>>   	io_req.mem.ptr.addr = buffer;
>>   	io_req.notify.fn = NULL;
>> -	io_req.client = v->io;
>> +	io_req.client = verity_io_client;
>>   	io_loc.bdev = v->data_dev->bdev;
>>   	io_loc.sector = cur_block << (v->data_dev_block_bits - SECTOR_SHIFT);
>>   	io_loc.count = 1 << (v->data_dev_block_bits - SECTOR_SHIFT);
>> @@ -478,7 +481,7 @@ static noinline int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
>>   	memcpy(dest, buffer, 1 << v->data_dev_block_bits);
>>   	r = 0;
>>   free_ret:
>> -	mempool_free(page, &v->recheck_pool);
>> +	mempool_free(page, &verity_recheck_pool);
>>   
>>   	return r;
>>   }
>> @@ -1075,10 +1078,6 @@ static void verity_dtr(struct dm_target *ti)
>>   	if (v->verify_wq)
>>   		destroy_workqueue(v->verify_wq);
>>   
>> -	mempool_exit(&v->recheck_pool);
>> -	if (v->io)
>> -		dm_io_client_destroy(v->io);
>> -
>>   	if (v->bufio)
>>   		dm_bufio_client_destroy(v->bufio);
>>   
>> @@ -1625,20 +1624,6 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>>   	}
>>   	v->hash_blocks = hash_position;
>>   
>> -	r = mempool_init_page_pool(&v->recheck_pool, 1, 0);
>> -	if (unlikely(r)) {
>> -		ti->error = "Cannot allocate mempool";
>> -		goto bad;
>> -	}
>> -
>> -	v->io = dm_io_client_create();
>> -	if (IS_ERR(v->io)) {
>> -		r = PTR_ERR(v->io);
>> -		v->io = NULL;
>> -		ti->error = "Cannot allocate dm io";
>> -		goto bad;
>> -	}
>> -
>>   	v->bufio = dm_bufio_client_create(v->hash_dev->bdev,
>>   		1 << v->hash_dev_block_bits, 1, sizeof(struct buffer_aux),
>>   		dm_bufio_alloc_callback, NULL,
>> @@ -1822,7 +1807,49 @@ static struct target_type verity_target = {
>>   	.preresume	= verity_preresume,
>>   #endif /* CONFIG_SECURITY */
>>   };
>> -module_dm(verity);
>> +
>> +static int __init dm_verity_init(void)
>> +{
>> +	int r;
>> +
>> +	r = mempool_init_page_pool(&verity_recheck_pool, 1, 0);
>> +	if (unlikely(r)) {
>> +		DMERR("Cannot allocate mempool");
>> +		goto mempool_init_page_pool_failed;
>> +	}
>> +
>> +	verity_io_client = dm_io_client_create();
>> +	if (IS_ERR(verity_io_client)) {
>> +		r = PTR_ERR(verity_io_client);
>> +		verity_io_client = NULL;
>> +		DMERR("Cannot allocate dm io");
>> +		goto dm_io_client_create_failed;
>> +	}
>> +
>> +	r = dm_register_target(&(verity_target));
>> +	if (unlikely(r))
>> +		goto dm_register_target_failed;
>> +	return r;
>> +
>> +dm_register_target_failed:
>> +	dm_io_client_destroy(verity_io_client);
>> +	verity_io_client = NULL;
>> +dm_io_client_create_failed:
>> +	mempool_exit(&verity_recheck_pool);
>> +mempool_init_page_pool_failed:
>> +	return r;
>> +}
>> +module_init(dm_verity_init);
>> +
>> +static void __exit dm_verity_exit(void)
>> +{
>> +	dm_unregister_target(&(verity_target));
>> +	mempool_exit(&verity_recheck_pool);
>> +	if (verity_io_client)
>> +		dm_io_client_destroy(verity_io_client);
>> +	verity_io_client = NULL;
>> +}
>> +module_exit(dm_verity_exit)
>>   
>>   /*
>>    * Check whether a DM target is a verity target.
>> diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
>> index 8cbb57862ae1..f28454f81249 100644
>> --- a/drivers/md/dm-verity.h
>> +++ b/drivers/md/dm-verity.h
>> @@ -75,9 +75,6 @@ struct dm_verity {
>>   	unsigned long *validated_blocks; /* bitset blocks validated */
>>   
>>   	char *signature_key_desc; /* signature keyring reference */
>> -
>> -	struct dm_io_client *io;
>> -	mempool_t recheck_pool;
>>   };
>>   
>>   struct dm_verity_io {
>> -- 
>> 2.34.1
>>
> 

