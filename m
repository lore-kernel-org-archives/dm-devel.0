Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013024.outbound.protection.outlook.com [52.101.127.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038F71D5CEA
	for <dm-devel@lists.linux.dev>; Tue,  5 Aug 2025 12:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754397812; cv=fail; b=fnm445ZkzxNBcDpNsQkH+xzIpE9I0d80eTkxhckskV89CpCseXL9vSEKV1S26qPaVqYu0m9Kh+T9D7r54BOMDoW9gM8BaTT0NZegQvgWqNFptsFAfEmbqKK/ocQ4v4g59/ZR/A1c2Mew8BsYHX6985gNruatlgpu59CwjJy5dh8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754397812; c=relaxed/simple;
	bh=T4LA50cRs93eH/aBsM3jlv3apGPwmFkxuiDmz6xwM6M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O0NcoznJyeWhPHpGdyvkSRsn9msnef8cnYHzePp7h8re8xTvai/ka/tT71BWccv5J3NEAQ3AAsQn95JQbjW05GyWjE+w+DIPcWpTtaXywTO/FXfuIwJdxeq8nQ05wETnAf9SvMcL58CONVvwcRdOsJzE1PdvkfS3ctRrMnNks2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=BVXnqQ0i; arc=fail smtp.client-ip=52.101.127.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="BVXnqQ0i"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ylkQPKiQGXKhTEzEea2SjVmN8HvO7LSMDQh0BKQcMXU0qf93/0D5Vkaa9Z1diS2AmrNwGOZw6w+6Zi/3JWbT8Tf8YMVsf56ZczwCLvmKoL4raNxlC4pD5CsUbF9qxu3C4l8wZUFy3djPsbFFHus9Z2gQ9xpzC9J0fsnoV5BgbTeusPcU74peBQUaO/smjkOxT9vLpE4aoqjIWhXvYjPbYcz4N2UXnkVDiizx211MZ+k/s3hx8xyP6uEQFdBdYcC2wy+EvH3y734irpytK+TkegHy42WORs3DqcbCgjCVJZPt7qFHceZcxmxUdFlckS91I9ngaAFcg6CplG98t8i25Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T4LA50cRs93eH/aBsM3jlv3apGPwmFkxuiDmz6xwM6M=;
 b=CzAFc+tmO1TYuwdsxhFOMofCEgiigRafQCwTeulaZP8pcDuAmLYTfcmj7kn0CsozMfMjCyZ9O7s3Kj5OUF+3b06IHdk6P9gDo39NjX3zQFMQSDf0i0Xm0/h0G23Zjr3GJsmXF3VgSOeuHpuQs8aXSQ+2MZhNcXFtSNo88BH6GawEc5mlBSfzZllFdyL5vjiBeGYiBHh/JkxC4ee1F+4BLFC4CUS9uE9QYjpsqp4PzXJ+XQzqZFAsycehR3UURjPjH0ky33BZ0UPr8wd1kQyKL8S5B+J+jlol7L1QJpicSdMkPhKII5hYRWSNe1MlcLc+KzBYp+imqb+3DB2JKYRRNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T4LA50cRs93eH/aBsM3jlv3apGPwmFkxuiDmz6xwM6M=;
 b=BVXnqQ0i/YZOFJIilNPQSbCdek/a5pIc6iFFI9cNLqx30rf1UC9nMHF8lRWOM7l996hNmNLxMtG0H6njlT8LGYI8yucJkCOKik/iMWCJ9Al7GbrJ9j+ZQBaDRS/F7c2W6guc7wmEEEEtaV3mquK7Pl8ZvZqDRi42dTWx/ysOzkOCdgUsxie0NAmPsKK5alC5QVFc5O92HtFPb50Tfura0qQIEl7/Ge7Tv8gcsE2aC4DOvuZrG73iFy4NtKK+fyY4eHVkPzXF1+PyAGgyfBo+Of65Sl3Yw2rMsjvQg+yi9zWIdRS/QcH70WDC/duMePgSIjWMtOGrnMH3G+U3fznhzw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 PS1PPF6FB3BD305.apcprd06.prod.outlook.com (2603:1096:308::254) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8989.20; Tue, 5 Aug 2025 12:43:24 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.8989.018; Tue, 5 Aug 2025
 12:43:24 +0000
Message-ID: <4ad4c673-8fce-45ef-b8d1-f724747bb649@vivo.com>
Date: Tue, 5 Aug 2025 20:43:19 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: Use vmalloc_array to simplify code
Content-Language: en-US
To: Markus Elfring <Markus.Elfring@web.de>, dm-devel@lists.linux.dev
Cc: LKML <linux-kernel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
References: <20250805091448.124183-1-rongqianfeng@vivo.com>
 <06347a42-7ebe-4fbb-9772-0124e308f967@web.de>
From: Qianfeng Rong <rongqianfeng@vivo.com>
In-Reply-To: <06347a42-7ebe-4fbb-9772-0124e308f967@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR04CA0003.apcprd04.prod.outlook.com
 (2603:1096:4:197::23) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|PS1PPF6FB3BD305:EE_
X-MS-Office365-Filtering-Correlation-Id: 19c2b130-700c-476a-508c-08ddd41daac4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QVBnbGJzVzR4MERjVGd3Sjc2eHo3c3VBZVdpMWRsUERDV04zblNjMG03OHpn?=
 =?utf-8?B?eHhSMnZ0Tm1NUW1FNjI3R0gxS2JLeFBJN0dwN1pwZnhQRXczS0hjSHVzR2dD?=
 =?utf-8?B?ckRxd1ptejBUMFpHaEdSOStLRzJDcUw2RGVmTDNWcU0rS25iVWk1QWVYazlN?=
 =?utf-8?B?akExSTBmWjJLUEpPOUFBY0lMNjJYcWJUMnl4TGNTTEYzd2d1azUzTy9nU0NK?=
 =?utf-8?B?Nnlhc2EyUEFVekFNKzJZelFsYktmdmJ2L0tZVkRpMzJTQ2V2LzJUUmRCcHpD?=
 =?utf-8?B?cDAxUVZOR3NFT25ZOXdoclFSNDFTZFkzYW1pbWpkRVRyUEhSYmx1c3F3NGp3?=
 =?utf-8?B?ZEZFZVdNK053cXlaOHlPWXpWVktBZExjMG9weGxXUHBWZVFhZXVZbnREQmcy?=
 =?utf-8?B?TU1NNHlPaUwyLzczZXg5Q3h4ZiswVU03QmNic3FHWmt6RjNSdXFFWktybHZF?=
 =?utf-8?B?cUNzRkVaY1FEb1FXV2FaL1JIcENWZ3JxQ3U3QU5lb01sa1JCREg4cTNKeC95?=
 =?utf-8?B?c2xwdmwxYXk3TUc2R0t4dkZrTGZITm1lT1drS3c0YWxwZGFtbVJvdTJwZFky?=
 =?utf-8?B?bUlMVERJWlpNUm9hZERsR21kNFlxa3FLcEtPR3Rzbzd2aEJJMitnNUVEbGJ4?=
 =?utf-8?B?YUduVFduN1ZEOHNtbHBUTFNKVjRybWxuU2lHY1QvYmQ3bmlrY2FkV3JVSWJr?=
 =?utf-8?B?Y0lzc0Z5M3VFelNwSlVHRm1ycmR0cFkvTzF2T3NjMFpiNng1MWZxMHVrK2p2?=
 =?utf-8?B?Tm9lR00rTVk0dzdOVG8wbFZMQkNhVjRrbWVtN25GNDBBdEFmMy95RjUvaDdj?=
 =?utf-8?B?MzY1NW40TkRzT1hJOWxjM200Z0FhVTFtV0EwRzZpMi8wTjRBRXJ5V0xxLzk1?=
 =?utf-8?B?bXJSNXYyaHVLTnlKSld1RjlVdmhacU41SERvTE9WRFp4ZHFHZWVvQko2MHdl?=
 =?utf-8?B?TW5QZ1JMU0Joa3FHVDhOb0Nnd0ZxdkVBQ0M5RmVEQUhYS2xJWWtGM1NobFJE?=
 =?utf-8?B?M3FveDRVYjZKWHJrOXB1YjF5M2s1RFRnT2RTTHVRdzFsNjFLZFlUZnJVSVA3?=
 =?utf-8?B?WWMrSTQ4RFNUNGV5dzVHcG10NHpkaHloZ2NtQVFpTW9qaDUwbnlEUGp2TGlI?=
 =?utf-8?B?ZXhqakx3aFZLa0N3azRoK2M0RVhvbytVd2hCTTRLemRISHlTTnBkS0trRFFF?=
 =?utf-8?B?dDdGS3pwQmNlQVp1bGhPNy9sd0xSYTZFcDJHc3gyRTYzNFQ0YTNBTHJZL2tj?=
 =?utf-8?B?eGQydHVGeGdyMTB5aEFJWkE3ekdzeWlCTURxazAybDV3RGxTYWp4SlM2cFdV?=
 =?utf-8?B?WVhTSzNGZXkydEk0L3hScVpWTWxJTXhzQmxUV0pLMm1FcDlyb2ZQbEl5WUNt?=
 =?utf-8?B?aEk4dWVPZngvWTJFcHBzL1cweFY4UVFpMUc5aFBSMVdCRFBxbXIwV1dqWGRV?=
 =?utf-8?B?di9VK0xFQjZyOE5EMzlGckp5K3lyMXBmVHRiTWVGYkdqTXhjZURVZTh0a004?=
 =?utf-8?B?TnRMK2pxcUhHYjZhbEE5L044MnNLYURQeVR5cVg4MUdZRXdDS0dYVWFiZXNr?=
 =?utf-8?B?M1N6UEdQWVZjRDJpWWQ5Yk1IWEQ1ZXRiMWd5T1lhaG94czAyeVBsQ25nVkxW?=
 =?utf-8?B?bFVZT2lRczIzV0dsOHhPSUZaZFJVbVcvRnBrdzVTeUhwdk42ZjA0SEdacmZr?=
 =?utf-8?B?N2tTN0FmMEtzK1Z1OE1HSllhLzVXOTR0MjhwckhUM2o2YXdXczFON0EwLy9P?=
 =?utf-8?B?NEZya0NHUXVRSm05S1hJUll1enBkNllHNjFCQlUyYmxMbmViWE9SRnEwaUNY?=
 =?utf-8?B?NUpqTzZNaEhjRndaVzQ4ZUJlelB1bzd0RkRUSWZGdExGQWd1NEdJUEV3RFZE?=
 =?utf-8?B?TDdWeFE0SG5LVHc0Z2NMMnJ1bE0yTHhhQW1HdXBqV1pzQm4reW43U0c0d0Zj?=
 =?utf-8?Q?QLvzHgvqpKs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WDQ5THUzZjhkYmFnSjZiRHRUeTk5cHhEWW82OVhzYlJlb2VWZXdhb29TWlc1?=
 =?utf-8?B?Y0N6OEszS0V0Q3cxN0lGczFTSmlnSjJvZ20rTWtwbUtKUUFmZDRjQjFZNEow?=
 =?utf-8?B?QnNuMTZKMi9ZRHdaeStUQTBzUWpub0VMdGIwSFEvNW11ZTlDNkdaZDRQTXdy?=
 =?utf-8?B?OXNKalczbUZxZlZkVUhlYnptSUpOczVjeUU0MVBVbnRzL3F4c011eHV2Mml3?=
 =?utf-8?B?NFVjWkIvM3J4QnJsbVJTL3ZzRE8xYW0vMTNhWXUyNWQrUzlsTVRlZDdyWWJn?=
 =?utf-8?B?TVU3WWM3clZHYWhtczUzSTR5T1JsREFrQ1NhOUxrLzRNa3JvZndOS2NqSWNG?=
 =?utf-8?B?WFRYajk1UlN0UFpUenRSbjhVQ1hjVytmbCtjV1VCUTlDdG9NWWI5R0lIdER4?=
 =?utf-8?B?aTdIenppRnB6a3N4ajhnN2hBTDNSRWtGemtMaVVVa2M0VVNsVlNnbzNibkda?=
 =?utf-8?B?czRuN3MySzlTVlVpd3FYTWNGd3NuZmVKM2I3dkxJOVEwYktWU2dNazZyd2pm?=
 =?utf-8?B?WkFad25PRCtaVUtVVlFOd2wvZnFsRnY2cldKZ1hqTmNyTkpHRVU2UkNuY3ps?=
 =?utf-8?B?NWU4NjdMZTl3aXBEdnVyL01BVjh1Z1BoTXpINzV4eU9UaWtmWVRFUHgrTGsv?=
 =?utf-8?B?Um1PV3NuMWtZVzFhRThrYlh5alJPNEZ1OUkwOERSTW9LSDdyWUtSY3NScHYv?=
 =?utf-8?B?U01GOXI1MWtvSnp4SDhqV2NlcDcycG1MYm1wd3R4TWRkZ0pvMThwOTJPQTFE?=
 =?utf-8?B?L1RoNmtqNk81QVl2Y3dxVE5KeUdqd0lXZ2U3V2Jsem5mL0E5Wjk4TTg3MUU2?=
 =?utf-8?B?aHpnQ0p5K3Z3TklBUlJQUW5nb2ZiOURkclRpS0pCa0ZuZVIwbkhJMDI5MEZO?=
 =?utf-8?B?bzZYcUFubUZ5cmR5V2UrNG1Ka3dTa0Ixc3FxaFFjaFZYMERmWmN1UGwrS0Vm?=
 =?utf-8?B?elN0S3dZREJrZTc0RDVCVUdsV3ZmZDROR2Q2Q3RhUGNOWGUwNzlRcG5xc2Zm?=
 =?utf-8?B?THVJd3dTZGZsNHZqbEl5dVI5Z1pCbG5MemtTT2xvMVlOa0toakJBdzFITmdX?=
 =?utf-8?B?clRzOEsyUXB1T1lobVR5b3hoRjZQNWM3OGE5SlZ2U1gxaTNicXdBU1VpaGtz?=
 =?utf-8?B?YldaSk5aZTRVRkxOcnVVNnI0SDNsN1VJV1poSjdGSEExMGI3TkZ1MWxwTDBC?=
 =?utf-8?B?eEdNazVqOXJ5YkVDRUhXeFlGU2g5ZDR0S25aRDJHd2xyS2RjTEtMWVl0a3pi?=
 =?utf-8?B?b3dIQUsrRmplZCtVMGJPMkNxQXRNSTNnL2tMb0szNXRqbzZJRHdpbTRHZVJS?=
 =?utf-8?B?ZkdaZzRHRWIzKytWTHVwV0lHbU9CR09yNS9MZ1NtTWRCaTVodVJLejFVWWw3?=
 =?utf-8?B?MlpjS29aY1VhL3Z0eHk4UzRpNkU2dVUyNk5RUzBiWDFkU1BKdGhacVZLbXYw?=
 =?utf-8?B?L0VhaDQ3UzduM1VXNG83S2ZSVDRZc29rVjE4eHRONHh2RFB1dlNTd3grYVVz?=
 =?utf-8?B?WlluRjhoRkJaRG1Ra0dkM3Zna1FQUUp6MTk1S3hDems1V3BDd055M3VvRUMv?=
 =?utf-8?B?Qjk5SUIvdURMbGNBenhDRTM5RkpRU25SNU4wWWcwQ3VZQlNwOXcyc3NSbEFC?=
 =?utf-8?B?dUMwNFNSNjhMTGU4UUhPbTFZYno0MlBueUVMQ01nME5oNk1YK2pFU2NxTUdy?=
 =?utf-8?B?VnIrSHp0Sjc3bkVHekdJK3Z6VFkrWHdoVGNRNmdLL3FjSC9mZVhnYnN5YU5s?=
 =?utf-8?B?Z2twbVVGcCt5VmNuc0dKQnB1Q3VnNi9mRWRTcnkybTFTUGpJeHI0RTRoajRJ?=
 =?utf-8?B?c08rc0NoUXVaVUFwSDBFL1RTQ0JpbGZ2K3dBU1FUa3Boc0VGUGx5d2ZtOW9z?=
 =?utf-8?B?Yy9lakozMm9pMmJyT21vMElnZmM3WlRtZm9MOEh1Z2h3RkVwSys1SzYzMGNT?=
 =?utf-8?B?TW9TQ2V6Zkw5M1NFWTVHUm9BbHZoOXpPWkNGNFU3QjN0NFNROGdOejZVYzhL?=
 =?utf-8?B?eGNKSUxraTRHQzBLYWdFWWg0OE1mWXNET2VhL25hR0hKQUFWTU1uc2xzS3pN?=
 =?utf-8?B?MFlaMGlwRmczSFdzcFdtT0x2akFMa3BJWTduWDBzYkpLcVMvYkpoR3pHOVM5?=
 =?utf-8?Q?FnR44WGtWCSnuRtMUZmkd3UMY?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19c2b130-700c-476a-508c-08ddd41daac4
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 12:43:24.2002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bmfBHdYb6Jy8dGzYsjgsjYLkfQKwVDXCw9kk4fdq/GQ5Pfw5rWty7IiFrs8MYrrCG0rsCvt8S4vMPlwtqzNLTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS1PPF6FB3BD305


在 2025/8/5 20:08, Markus Elfring 写道:
> [You don't often get email from markus.elfring@web.de. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>
>> Remove array_size() calls and replace vmalloc() with
>> vmalloc_array() to simplify the code.
> You may occasionally put more than 52 characters into text lines
> of such a change description.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v6.16#n658
Ok，Will do in the next version.
>
> Regards,
> Markus
