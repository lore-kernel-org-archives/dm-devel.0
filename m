Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012043.outbound.protection.outlook.com [40.107.75.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C3C171D2
	for <dm-devel@lists.linux.dev>; Mon, 11 Aug 2025 12:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754917138; cv=fail; b=Hk/c6wj+cveqgN09G0VNevXbVoeShJw/odg3MBPr7IjYPSlhdBFqPbTy2q5FTMll+wEppqUYnjXQPLF/rviruwf74xlCtxjepBy99uqn0VxYQXCIVdJyoTX8Ax9dscaq25XPWvb7hmRmlX4xLA8H25d/Bno7neBBP0MqG1JiMnc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754917138; c=relaxed/simple;
	bh=PCJKCSDfpaq2xPIOa1jFJQ42hHgbCF+KZ2/08GRm4zQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KnDGmynxh2n+6RfV3uACqAZWJrgcxJVQo2oYbwXMEYEwPHYRBQ47SygquvfuOiCOPUDyDMi66JafmmCkb9ZWMAebPciWbacGh7VOExaVbq+aDe3uA1RPHShBQHG9sHoRSk3GMLQg58F1s65WMiQk1lGQdrr82Z06sW8umoeUtCs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=D5ZdRzm9; arc=fail smtp.client-ip=40.107.75.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="D5ZdRzm9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G9XWdv5fwi1H5hTzDVN8dy2LO3VR9RYtHTjIKLj7YsK1O3+UZWejB3tQP9r9S7U/PjHiG18zuRS45lPQVRpe3q7oXC49ohLbXUFfZlwy+pc93+Azuz/eecQ61x59m/uqChzeRgTPvoHQmbM0CwEEWnfSlv8c9qkwbuQ5U/Ihpbp/iNW+i4kJ5frn8bJI321Su9ZBYegA0lGBqlF0ZVHF4VVHK59+tif/u415XP+NF2aPvsvDi1YaIZ+UQWBhgXoHOmyg/QNYaTULf9lHBK7hOO19JS1Mw7EkIYzEUa9VcgF0ktQNEKXaNFkBp8mIZZgDNguPOKJbQLEdK3MkYmXh2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PCJKCSDfpaq2xPIOa1jFJQ42hHgbCF+KZ2/08GRm4zQ=;
 b=ZPv9btAUcW3hI2q3x10alHCvbvGPbm5dXppU8nVbrUzfsqswBF/VN0X2ukGmoIT9rVjQQYD8k87PumGndAGwuCxXzpbADGaimYl25DQFBod6i0SyGcFEG6qSnC+WPiD1xuOPJG4x5huG2xZ47blp20UIYeX2VO5U6XdJCfDupRjvV8iGrdWfAuajGcptQLjzt8FdaTKwTW9VSJFRYrTmUMMDQU2BtEYdTED/c4j9fVr7lXBGeROBHilcyhRHF3OKYtJ2l+zWaS/m3XU0zE+nOmioWTcXK9pQv2KY2cEipqxgCTq8z1yIv66aiyjsDCBi7Bb4p0Z6PKSnisPbp/67HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PCJKCSDfpaq2xPIOa1jFJQ42hHgbCF+KZ2/08GRm4zQ=;
 b=D5ZdRzm9e6Lgm/1qheTRYmtgZJvgi3Q/SoxlYXqVh9dmpFEHCtxFuZHvKPhDFl+UOqwsG6hEHM/HqbreJRJpmYqjvjWY9sJcmexUs458b2gFHSM9RPk9ucQlVyko86UJFP5+eXg5hj+/C+yRfKe/mx5+E7jlEhbXR65Kqsg8OBEHNzrWi7waW9sIaYswdrFzDR2+PMQ3IpoMaDqIQxugF2C1dC97i/AfPEdKdigZcOLb55jEpUwdx7dADlotfPQK1Bufy0wRZ26Hgajnmlpo7Gc+6SGu0RvKB3Y8n4Q2QIS/1XybgQ0hNxPTzqmwGhjQIu9FWYLhFcFm36IKtQlVvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 TYZPR06MB6308.apcprd06.prod.outlook.com (2603:1096:400:41d::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.20; Mon, 11 Aug 2025 12:58:53 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 12:58:53 +0000
Message-ID: <bae5bba3-a73e-4a5d-80f8-e1506d0a302e@vivo.com>
Date: Mon, 11 Aug 2025 20:58:50 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] dm bufio: remove redundant __GFP_NOWARN
Content-Language: en-US
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 "open list:DEVICE-MAPPER (LVM)" <dm-devel@lists.linux.dev>,
 open list <linux-kernel@vger.kernel.org>
References: <20250811123638.550822-1-rongqianfeng@vivo.com>
 <20250811123638.550822-3-rongqianfeng@vivo.com>
 <649a5bf8-309b-8128-b3f9-971d3a0bb350@redhat.com>
From: Qianfeng Rong <rongqianfeng@vivo.com>
In-Reply-To: <649a5bf8-309b-8128-b3f9-971d3a0bb350@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGAP274CA0017.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::29)
 To SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|TYZPR06MB6308:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d65e6bc-01fe-499a-1baa-08ddd8d6d355
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QW5raHRYZm1CVjBQb1VmemNuUWFwUG9YT1d5ZzArOWtXNStvL3lIT2RXSnR1?=
 =?utf-8?B?MVlzT3I5ajFtSW5RYTVXSVFhWTNuSVFxT2RjS3k4MjJ6Q1FNTXA5SllCbUVR?=
 =?utf-8?B?RTJBdU5oQ3JGZW5TMGhlZ2Vzb3BVdUttLysxWnpwb2t3MTU3RS9hdis2Sllr?=
 =?utf-8?B?ZGVEY0V4NFFTVTBZRUtnOXlHZXpsdjZ4aDNNUU9OOWdoMUtKalNLN3IyYWpB?=
 =?utf-8?B?OG9aWFVnYld0U003S09hdEZYYzhlVnJpb0NNSmpEQnVKazBkY2d4WGwyam54?=
 =?utf-8?B?cUJneU5hK0JqUWh5c2VsKzhpdS9TUnR0aVhvVG5lQmExd25aY0xLMk4vbXN0?=
 =?utf-8?B?VU1nRGJmR1FOYUZLemRIRG5udDExRDMyTmpXS2UyaHVwTEZWaHBWTm9lQmQr?=
 =?utf-8?B?VEkzOUxzRk1QUUUyeUlpejF1T0lHR1k5Rnl5SlFyQ3ZxWkFIdGpzeHVBeDlq?=
 =?utf-8?B?dTRmaUNHY2FKTS8veml1c1hFRW5zZGgzZGxwMzhmTllURnFFR2w2Q20vblFj?=
 =?utf-8?B?UXBwMHQ5N2ZlWmpvSkMvTFF5akRMMDdlUXVXbDVYWUZoYXkzZHNZV0FBOTJj?=
 =?utf-8?B?MTd2cm1IYTBtOE04SkIzYktFTnAwbVdlSG1yNnRueGRsclFERWx2M1VPd3Bm?=
 =?utf-8?B?T2hxZUUvT0pWYlNXa0ZzMFcrNW1xWUlFbEsyVFpuaitCNDI3SHY0VDJTM0w0?=
 =?utf-8?B?ZnlGL3Z0ZW1ZK3RMYnBSdWc0ck9tVGN1WmRaNkZSb0JtcTRvajBpYlUrR3d2?=
 =?utf-8?B?bHRaMnZwdVdRb0x3N2JXQnBJT2tRN3lSQ2J4K01ETmZNRTVLZmdmbFl5VXdq?=
 =?utf-8?B?Unl0UGdNU2JsMUtObHo3ZUdxUG5hU2FYYUVCdEo1Z1FlckZENHdCZ0NzUVVM?=
 =?utf-8?B?VnRKdU1oTHpwdlhzOGgycnd3MDByRm1DMDd1aXlBNktvZlpmN0Mwbkdocnhi?=
 =?utf-8?B?ZmdxSGo2LzFxS1p3RTVtRHc3ZTgzRnY5VG9yeFYyaUFqWmhsaUhiVFNjUUMv?=
 =?utf-8?B?RTVmQXJMaEx6QXFMcUFsVWJVUkRvS041dWZIZmNoVUhhaVl4TDgzSXBwSFhZ?=
 =?utf-8?B?cUt3bGd1STh2RkxIK0poUy8yaEpSNkV1NSs0RUVCQ013SzFHWGd5N2RGWmFN?=
 =?utf-8?B?akhGeFZ2ZnNYVDIyQU9aL3BqQ1QzUnFJaTV0Y21OR2NSQ1IvdHdXcHZtbEUw?=
 =?utf-8?B?SWR3SFpBWWtSQ0Y1WTJoN2YvK3hIN1M4aGdXaXZvZFEyOHN2REhsSVlFRFM0?=
 =?utf-8?B?YkxzY09qQ2dTTU05WVRSV2VpTWdNVnpPT0loSC90WTN1U1VVUHA2ZEdvTmMr?=
 =?utf-8?B?dFBmR0VaRlgyTlV4ZlNDNDJoazJ4Y2J4TnI2dndVWjBaem5mK21mYWV0dERU?=
 =?utf-8?B?dnIzcWd6V2ttUW9Bcm5sN2VKcVdiblR4bTNDd1BwSjRpazlLZFhQejJWVGZi?=
 =?utf-8?B?S3IwM0prcGh4dEwyVGtYSVlMSTRYL0swTk1OaVZ2SHUvRUp6TVl1OVlkVnJ4?=
 =?utf-8?B?T1JTSFZLNjZ4bGxnbXROcUswb3Z4OHE3eFFsdFFNNE1aM1ZtK243UEN0UXpF?=
 =?utf-8?B?REo4cTBKeWlSNEs4SDluVFo5eUlVYVFsekVabHlxNXV2Sm9HUXBUaWxZL2tl?=
 =?utf-8?B?NW8wZTNhYWd4VEJkVUdSS3VuSEthc2hvdXh5bGRuVzY2MnU5cTUwUjF0RVV4?=
 =?utf-8?B?TVBaZ0VBakY4dnYwc3o3OU1ueVY4M0svOFo3WHB5Q0k2Mm5McHBHeFVNUkhn?=
 =?utf-8?B?TVZYNzZ1TDdrWlRPRkxHRmtmblR1ME5VWnlpdGJZcGxEcnZSVE1hZjdiVFR0?=
 =?utf-8?B?S2dKQjVJQW1WVWNkaDFhR0tXb3VKUHRpL2lvY2t2Tlp6b24zQk9NdWZLMkYv?=
 =?utf-8?B?Z3JBa2dGYUMyaUY2S2txTlBxbklCUjFlOGNOSDVOVnNvanlGMDFZTncxV3FZ?=
 =?utf-8?Q?smEjPuF7NOk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OHVBUUFNUmY2VU1aUmtReVlkbDRrd1dwdlFkVjFCUTBFQnRsdWlVcXdLaWxL?=
 =?utf-8?B?a0YxMWVuUkhIMFRSQUlyZ3M5UDNIWkxybVBVNW52b3d1MVluSTVkY2ZoUGxC?=
 =?utf-8?B?MWFqRUgrS2JMWm10SkhqM3o2Q2orTjE1YUN1VVN6M0tkcEVVeElOV2RreFdC?=
 =?utf-8?B?KzhmNWdOMEtEZk5wbnFnd0l4UldKNVV2NjJNNElQdWRFYlNpSEhnSVNqdFlE?=
 =?utf-8?B?My9xYzZWZFpPeGVkRlZZWkR3d0NKU29LaERsS215dWJNdERTL2VCWFlEQ2hV?=
 =?utf-8?B?T01IcFdEM3g3V1lQTnp2SnF5aGNuY3d3MkFuZkQvSVM1Rmp1dTBqYVBsQjA2?=
 =?utf-8?B?MkE4N2JPeTdKVHVwOEgzdU0xOUFXT2NvbSt3NERuSXFKa0p5VDFpZlgzblYz?=
 =?utf-8?B?Z3hSQXpZUnNVYmM4WFhLVWc3QktVOGxNRlA1dW9qRWJzcEtKOTk4M05ZQ1Ro?=
 =?utf-8?B?Rll0cmVrRXBNeHZ5NDBWV255UVNEa0NTaVlSVkYzaG5zckJGR1pwdDB5Sis5?=
 =?utf-8?B?a29kUi9ZZXBjMkhBaFlPbXVIRE1nY2huM0hiNURvc3FCd0pLbjRNd241NGVq?=
 =?utf-8?B?dHlMcUVXSTI1TDVUdmJTQk42aW51ODdDdFpQS3F4bU1JSTJ2dGlqckFIOEIw?=
 =?utf-8?B?cUZoZEZnazNFSFlTbndLcytBVUkrN0lTZ0xBMWwvbHdSanBpYTdtTEJGSXlO?=
 =?utf-8?B?OTNNNWRqdmFWdXFRYXpiOWtrUVZKbmZIL0N5RW9Mcysxd01nZjdZWSt3RXk2?=
 =?utf-8?B?c2VBczRQYzlwajBsU05tUzNHaVdySStLNmZlenEzazlYTEpnKy9BbUxSTzU0?=
 =?utf-8?B?eHNmYlRZUkY1U2FXZ2c5YksvQ09aK3UyRmNrQUtobW80M01LVDNpNnhLSWRK?=
 =?utf-8?B?S0lieExXdzc2MDdsaEhydGZCMHRUMlJaNnc0UjltQkFuWTdwTFNVMG01Z3Uw?=
 =?utf-8?B?eENDaXZqc2g3N3dCWG51aTJxWE1kVWR4VUYyT3U4MDhLUFdEWFp2OVRrb1Yr?=
 =?utf-8?B?bEphaWcxZytwbUY1bkN4WjRNZjdMSzd1Q0FiQlR6WnRhWUUwdnViemxFenNP?=
 =?utf-8?B?MVBlbzRjeTFYUlk3azF5bGZ4aE5JTUpHREJ2bFZqUmhDMmovRWJvK2ZHdXhj?=
 =?utf-8?B?SVRNOEFDYTQzeWQ4OXZFOEt0dlRKTEordXI5SzQ2ZW5hbTdZdTRrRjh6SlJz?=
 =?utf-8?B?S1M0ZE8zM0UyK0JuL09zd1dKdTNzNU80MGY0eUU4MW9hZFB2SDFiK3M5eXNY?=
 =?utf-8?B?VmNldEFpVnY1a0ViYThzL3BieUhsZVNtaUFKL25XUmhkWjVVYmI4Q1ZtR1RF?=
 =?utf-8?B?T21GZGFSSE5RMnllUk9IWlZralk2SldPVlJwNGt4YXJYRmE4R0ZFUTNMTHdk?=
 =?utf-8?B?N3NLY2trby9MaVRZWnFkYnVNaXZJcHdvSlB0L3pidDBEN0I0Ry9sanZEQ0NH?=
 =?utf-8?B?UUFjV2paT1BoemJRZlZGUzczNUNkbFpnempxVDczaWo2VEVYaU1Odm81OU5P?=
 =?utf-8?B?bGJsc2NhOGorSzJNbVQwNCt3ZDZYUFI0c093NElSRDE2NWsrbS9Bbm5XWktJ?=
 =?utf-8?B?bkRsdkJaSFdYOHh1bnVFdHFzRHNMVTJweVUzQzRkdzVxSlh0K2ZvRHFKakw3?=
 =?utf-8?B?LzNnQWJia20zT3NmSFcvZWNRTHBqMzdHaVFMajNDZFVGbGlsc3dMdHY3cXpN?=
 =?utf-8?B?WEVKMVNoRWwvUElnMDRhenY4ZXB2bG1qcXJjS0hHMkkxdm1EbVJ3NnNZSVc5?=
 =?utf-8?B?OEl2bDRyMGlUWVJsdEhsNW94RVphTS96cm14OElEVFZlOFA4dHNQYUVxTzEz?=
 =?utf-8?B?aWkxYWYrRzhNbVZZUEdKa2dKc2JNRDltOEd1dUxXZzh0cXp0SmNRZk1rZFhn?=
 =?utf-8?B?bnlzT1Bwc1NtRUdydkE0Q0M4Y2l6c21SeWozbUNtdFJxM2p3eTdKTjFyNWxj?=
 =?utf-8?B?SXlUbzljS2d4NUoySGlEUFcxc1A3d0JvWkFlMGFndUdhMmI2NGNqdVpzR0Zt?=
 =?utf-8?B?RnBYOG1kd1hJd2Q2RDd3eVBxd25zMWhsN09GZEtYSDFlaFQ2NzhnbE5FdURG?=
 =?utf-8?B?aCtWNmZHWFJHZlpYclBpbWw0UWlxQTlCenRJRVZCV0tKdFV1Q1pMYjJEL0hG?=
 =?utf-8?Q?DB4gThqcEEXQQic/M1HX4Th5X?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d65e6bc-01fe-499a-1baa-08ddd8d6d355
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 12:58:53.7617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1E5EOk2rp7gN4sH71stN/DUwEJCqFO2lm76Az+iNQzQzt/hlbf4bkkCdcaxdt7tc69I3VhNc8YAFcxjDrPxgPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6308


在 2025/8/11 20:44, Mikulas Patocka 写道:
> Hi
>
> I think that GFP_NOWAIT already includes __GFP_NORETRY too. So, should we
> drop __GFP_NORETRY as well?
GFP_NOWAIT does not include __GFP_NORETRY:
#define GFP_NOWAIT (__GFP_KSWAPD_RECLAIM | __GFP_NOWARN)

GFP_NOWAIT tells the memory manager to only wake up kswapd to perform
memory reclamation, not to perform direct memory reclaim.  Even if the
request fails, no error message is printed.

Best regards,
Qianfeng
>
> Mikulas
>
