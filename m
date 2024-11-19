Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2116.outbound.protection.outlook.com [40.107.21.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE2B1CEABA
	for <dm-devel@lists.linux.dev>; Tue, 19 Nov 2024 15:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.116
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732031672; cv=fail; b=h92esPKb6S3Elw7YCTaTZPHwDbpR8rH/yijbutRtKIhvyoUASWTBLOsk0SBcy38f/MmHxZve9lvC1bu4kC441HXMu2iQ+epQd6++xp9OKd3JKaCRUSsLurTRs35HBpbNcMC4wWw35gaLd/uUZcTyNboqqwFUL/cFTm2fYbWs2og=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732031672; c=relaxed/simple;
	bh=Z8NANgrCRj2Lrq7aPfP5YOsnSq6DshRYzrdx/K9KK8M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pmWNm5HSCvss8wxhZR10rjG/S1mGyWEC30VrFkMiIZem/HIDs7PumchM6stn1hMiefjpn4mydZgrU9iakGY6kfTu9pji2kRWZ4IufUYIbzRfReCSssXo3LS0Tv/q5fLydERursqhsVz3j7I3JJjdtKw90gaAeoLYdqhuS2qfvos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=EoRrqO5u; arc=fail smtp.client-ip=40.107.21.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="EoRrqO5u"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BcUqJ6l2y3ExScZrIEYfmJ53oYaxONoPp2iKMYDb5M3Y6Hu/IFVIcuqepf39Vsjwf22YJNp4uyl1i4V1QYGt5QzjOjS8pxTVBgsS8FgN8MY6KZ0R85Cf5wK9cX0hl4UjU3S7Z3JOwRrA5zowIVqc2duHUyLCB9tv+SCQe8cVeP7+v0rnrZCR9geoAjtzTgLNdZD02ns4fGGUwPB9OUs9Bo7Mo0Jlw0kWqaJIYHxVr+TnW1c9D1+PNsmUj+HWTiEQpoDrztHspwfqQtGy4WUeb62O+OdnnA/JGMA0LDvmV+hI15G4UE0hvJcETWXRCZEqrC75aRVaFlRfJsIsQ9YQVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SKEMEsS3rFwCOYEtb4WCuEAADEs+NiP4NCJTkbWISn4=;
 b=CmGN3uMESkC2M//k69/2e5BMBJH6h1a43MZeerdaNeN9tsDSHrTpwAIoSuraWH+iuWlA70uiXmso1GWtyp61e22Av1aSHx73L8beC24a+LS5o2PYzmeSpxK4ZImB0M650BkK58IGfRjSXmRYdZ5jAOaF8ojSFe9UC0V7rSPyRF4ZryMv+2TG+UgfPqtkx0Ffp+Gyw0VeIEj2FXB7h+PBQpXcqA4m4XY0njvl4KVR0QI1x/8L++2rTFlVy+uK25UWI7Rq/yOZJu1393lx30L8PTsPp0DXwJW8bb5+uvh7QyWX4NAMqw+F8UZXdZ09gtVMHDKIQaEn+UKTvhroYdbSJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SKEMEsS3rFwCOYEtb4WCuEAADEs+NiP4NCJTkbWISn4=;
 b=EoRrqO5u66nGMC5OxgKaoH9AyTU9RnufBKLMNtTif+4cR6W3HtSLi1WGq4615sb++BdUDbyPHt3ipfXeLKCuiameYvDMdwm5w8UJ9B6+rpmRsR5K/7Gxr4RBliz6a7kecSyxr7UvaxtZNbz1tA1wZy6N/aUcKAE1gAZjcrq2xoXTMRF//MuXskhkE9J8A+eola49t4u0fHtQZ2oJ/1MhAyeSZVrWySevKQDtadAzp0SmK+YjpFhw7IGPCyDARuYP1EkcsEJwM6H9xjanetiXT0RKsO/s/T7/2khh7pru3GVlSpWiXlCfI9180r13WfodbZQfBsHMEtfKYwUvWk8hGQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from VI1PR04MB4958.eurprd04.prod.outlook.com (2603:10a6:803:60::23)
 by AM9PR04MB7684.eurprd04.prod.outlook.com (2603:10a6:20b:287::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.24; Tue, 19 Nov
 2024 15:54:26 +0000
Received: from VI1PR04MB4958.eurprd04.prod.outlook.com
 ([fe80::27d0:585e:6f58:e194]) by VI1PR04MB4958.eurprd04.prod.outlook.com
 ([fe80::27d0:585e:6f58:e194%6]) with mapi id 15.20.8158.021; Tue, 19 Nov 2024
 15:54:25 +0000
Message-ID: <d485a45e-f514-4345-8f13-96c5a0df3ee0@volumez.com>
Date: Tue, 19 Nov 2024 17:54:22 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/persistent-data: Set tm hash size via a module_param
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Joe Thornber <ejt@redhat.com>, dm-devel@lists.linux.dev
References: <20241014134944.1264991-1-meir.elisha@volumez.com>
 <420a99f1-c076-4a91-8b5f-80ac9be27c7c@volumez.com>
 <9318c514-e110-464c-3d95-feb288130c51@redhat.com>
Content-Language: en-US
From: Meir Elisha <meir.elisha@volumez.com>
In-Reply-To: <9318c514-e110-464c-3d95-feb288130c51@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0015.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::18) To VI1PR04MB4958.eurprd04.prod.outlook.com
 (2603:10a6:803:60::23)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB4958:EE_|AM9PR04MB7684:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e6427f1-add0-44ae-fd0b-08dd08b27149
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N1Rwcmx0T1VHelZ1bGdUY1dUbmVUQS9RMDYyRVl3ZXo5eENGWDcxckhXQUxK?=
 =?utf-8?B?UDZVQmNtaGwxTUZ5OXNSM01MOE8ybGlzaVNXcDgrRENCTzNSK0szR05HcXdh?=
 =?utf-8?B?ZUJFSmlBMzREeUluMzVqbCtaYUVsM3A0SGJDdExLMnpsS2ZRV3EzUDlRZTB0?=
 =?utf-8?B?VTU0U2hBYnBuT2JzaHFvK295Nm9sQ3dydHdRdmt2cmZWN3R3VnVwMGE4akY3?=
 =?utf-8?B?VGNULzd2WUZYcnR3WXZOR3lxbVpGcWRHZnRpWjVIS0dabGpFbjU5cWt1Qk8r?=
 =?utf-8?B?TG9wdk43VDBGb1plZWhWSzBKVC91R3BHdkZkWlFSbEVxNDNQc3RvR0NQUkxj?=
 =?utf-8?B?MnpVRjcraEpRU3gzSFMwTnd0STlVVHNQbThvZzRzTGJmWWY1YlpQSy9ma2Jy?=
 =?utf-8?B?K3NjMW9hZXA3VVAvNjZ2RENIVVFnUHkvK2drdjhjUGhlalZGRkxIdStxTzZ2?=
 =?utf-8?B?cm1rMmQ1WE5Zc2VGRVBaOGtORnF3QThiOUhTY3FlUjFpNFlYWlgrd2hweDZu?=
 =?utf-8?B?TkFSelZ6ZStQUjlkTUx3d0gxMklteU9Pa2ROaHdTbldtUXIzUFV5d3djT0xV?=
 =?utf-8?B?dzJXSGYwQWJUcTNzaUpkY2tkL3RtckhGMEZjSGNuWDdsLzIzUHIwdjU1cHha?=
 =?utf-8?B?aDFpUjVlUm5GSW56NkxXT2RtcVlxNVZJczhtanpnVTFpelpIWHZ2WHBIeXBN?=
 =?utf-8?B?bDNkU2g3ZU9PVEx0QnRjNG04Zjl5U2hMRGVVaG1nZUN6SWZFOHpaOWs0SDJx?=
 =?utf-8?B?R2kvOGFLT0NHRmE5WUNPZkdxeHoyd2ZvY0Zha3pvSm9vdVZVbGMwbDVLNG5r?=
 =?utf-8?B?STM5Ny8xTTZKdGVLc3dhRUhVVUpENEFzZnFyU3h6VitvZmYxR01ZMmJ4Um4v?=
 =?utf-8?B?Wk80UXN6TVhPMzgycWd4TkNUbDArTnA4dkRwRHAyUmt4dzR4S3grc1dhUjYz?=
 =?utf-8?B?aEFTUURjL2JVY2VxQ1lhRyt0aHVGVUNPZXdYcS8wTGRzTlNUb1dUdi82Y3NF?=
 =?utf-8?B?V1pMUE5NTFRjeVd1MGhYa2ZiOENMZGxGS0VKbkRtZnFBaVR4SzhxaUQ2VFNZ?=
 =?utf-8?B?Z0Z1QXczazhHVklrQVFKVkdMUVNQSWtSamp2OTFBNEpxQ3B3VWVmZ3dFdTFT?=
 =?utf-8?B?ejJNT0d0MzlqSysvc1RGOWlCcytBd2cveGhmaUxOaDFLK1A1eTRNb0FUQ0h1?=
 =?utf-8?B?ZzB3RnFMcHdmaU13L2VocCtobFNSY3J0NkMxVHJ1YjUzRVJWWUcvenUzZEgr?=
 =?utf-8?B?cWEyTm1JN05TekNXZk96RW81WkJTY0VaVWw2eklIMjJrVTc3SmpyNUFrdUVm?=
 =?utf-8?B?UVcydnZodmFaUURSQzA5cGk4VDdTYVNlc3dGdEd4V3VLakd3RFdTT2tDZy9z?=
 =?utf-8?B?bS9UbW1JWVhrM1FTWDhVd25TRkZqcFhkOElsMXZubUl0MEhkc2tMcHo1Vjg2?=
 =?utf-8?B?WnBGd1JWOXVMZzFZRmh0dFVGeEdWcEtNakZqK25xY1V0VHArTkJ6T3U5Y3dp?=
 =?utf-8?B?SW5OcncvV1VOZDJqdHU2OFZESnZnY1BBM0dsY01Yb21NRnd2MGpLMHY3YlRv?=
 =?utf-8?B?Y3JTY2hldkw1ak85cis5M20yRk5QSkRIcVhVdG9nMWtkZlFpQ0FZOWpadWdX?=
 =?utf-8?B?cklJZERSTFRNeVVRbU1NN2xwMlB5WUgycDF1SzhMZWtSOHJmQnBKVDdQMTlN?=
 =?utf-8?B?OVMxL3FTQXpVYlBCUHpPeUtKNko5cDY0RGpQZmFwMHRHWlJPOEFUcFFubGNR?=
 =?utf-8?Q?Qnky5VJMGuXaZ2aFzvd+yKr7AJMftTP5tNQf1ii?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4958.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(10070799003)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MVptYzNVMUFwZTdOUGdObC9hY0tGb2M4bjgyMmdYWThWZUU4UHZZekNRL05k?=
 =?utf-8?B?NnNkaS9GSHhaUGMxYXY1QnBVbzk0TGRrdm0wMGtTZ0p5VmJsSmZKelZ0NjZO?=
 =?utf-8?B?SWxyemZQSmI3RzdsTnhVeTBzcUw4V1ZhRkZleVZjZU5OTHR4bnJFR2hWYUJ6?=
 =?utf-8?B?UkF4RExFNE9hUk42MnVvSktyOWNlSnFrUXlTSnA0MTlJVlQ0a1dPY2lTNldo?=
 =?utf-8?B?N0dXclhPNmNGb3dBNnNNd3grN0JHeE4wOWNRcEFMMmhMMHlMQkh5ZXNYendo?=
 =?utf-8?B?ODNKMlZpRU5VUUlqeitDTWFrTFRQMVcvUUw0TnZqMTFUanRpNUVKVFdTV3FZ?=
 =?utf-8?B?aGNQbHM4aWhzWS8zUHBsM0wxenhkZEhlejNNdHI1dTdWendYZDF6a0ZqcHF4?=
 =?utf-8?B?STF4S3BQOEdmcVdDRzNBeXhEUHMrOXYzU1k1WFZIQ3Y5bjJocTc3TGJaTmpE?=
 =?utf-8?B?eEdlR1NsOUF0NVA0K29kTnZIVFR6eHliRVRMVkFuai9zZ3VpaEZzeXJaeWMv?=
 =?utf-8?B?bEFSOHNMcDBZWkZjNjNlZUt1bTEzaGJJdDNQbVVQRGNFeUp4L0JLbWlZWWd4?=
 =?utf-8?B?UWVDcFZnOWk2QWhxbzdvQmdsTG5lWloxWWVqa0JiRlpYK29DYmh4ZHdQU0pD?=
 =?utf-8?B?M0cxeGUyUDFoWVR4elA2VlMyUzE1bXUyRENOOE1UQWlWd1lTaUNpZ2ZYdG5Q?=
 =?utf-8?B?RmFzUWhsREFFUkVmbkFxWVFFY0Z0S0RxaHMrMitMRmNjcUFPZ1lDMHR1dm5B?=
 =?utf-8?B?L2Rkb2ovdXpYaU1sK2FkellMKzlrdEowKzlxSGxyMGN4S0JsYXRVRGxmTzVh?=
 =?utf-8?B?Vk5ocVNFYkNZS2hzcmlEeHd2ZnVuamMrdnIyRUIvMUpOSzhnN1h1NFpnbzJ2?=
 =?utf-8?B?bE9qTVRBeURyT1U1aWZUdGVRSDNRTThkK3lxZEtwVFBDTm16S0F4ZUEybVJr?=
 =?utf-8?B?QnpkL3gyMkJ1cFVLeEYvQXpnMUxuNktmcGJzQXJNbWs5OXNaR24reWdGZkhp?=
 =?utf-8?B?dldWbG84cDd6MDA4OGlGMkcxUE1aQUpHMlU4STlaRkt3bGVBRG5OL0F4aTc1?=
 =?utf-8?B?QUhVaG1RUlBzT2ExRnFvQzBhUzlCa1JpcjF5UXlZbnRTT1MwNDVEb3BrZEdS?=
 =?utf-8?B?NXIwY1Uxd0ZjckFQNkVBTTFNOWtjZnVkSngrV1ROZTQzaGs0UW1ES1RjRkNo?=
 =?utf-8?B?NzJ0ejVJZjd1Z0JNU1V1Nm13WkVZS2c0U2tYc0dmbjNrV2FFSHp6TUNyNnUv?=
 =?utf-8?B?ZytUVWJvQjR3b3pDSTFjbVRqbUdYaDJScW90U3NrMzlVcmp4Q05STWJzNzJJ?=
 =?utf-8?B?REFCaUJWVXJxK2VFa2lkYzRDc1hZZFoyL1lGdVhXbEVNQmtlazlzY0UvWVpO?=
 =?utf-8?B?MFgyVURBM2NSdEJoN3FrMVlSM05rTlJsVTVla1hidHhoRDQ1RzY1ZHlKUjl0?=
 =?utf-8?B?OWhsMWxhNy9oWmQ2VE1rSUlGVWZyZW5OODY1bHJzU0t1ZXp6RlVJR3h6QTVv?=
 =?utf-8?B?Rm1NWXJ0Yk84Z2laRTR5VDEwc0o5UHVSN2xCRDRCN3lSM2w5VS9BZGFmaHpC?=
 =?utf-8?B?aFQrdG8wdW52eXZkdFhjTU1DRFAwWE1RcEFTMHgvc0ovRnFGQVdxUGFvSmhG?=
 =?utf-8?B?M3ZsdFhYZGU2QzgvTldKczZiRmdQYzJ5VEZiNzhYU01rUHJpK1pLcjE2cjVU?=
 =?utf-8?B?VnRQUXdualdkVi9DU05nNWkxQlE4Vmg1ZG9HYUJFaFFkUXVIYnFJS2RMWVdG?=
 =?utf-8?B?Z0Q2UDJ3SU81bVY2eWlCaHQvcnc3cFFlZnBWa2E2TGNtOHBaSXczRU1CN1JE?=
 =?utf-8?B?R2tWZkM3Y255MWVwZERpY0dMbndYNTVyZFdmKzVtbi92RVBTRDJQVkRmN0Vv?=
 =?utf-8?B?Nk9wVFIwZDdhL1AyUGcvcWFRa25wQ21rbzBzcjNNYklENjFkd0VCWW5scndx?=
 =?utf-8?B?em5BbmI4Zi83cDEwRW95NEhVNmRlM2RlUGpFKzBoemMyaTlFYTBCZHJXMHM0?=
 =?utf-8?B?L01BVE9qclhYd3ZyaFpGSGlkZm1CR1dLWmJYTW1XZjNKa2RodW0wRE5lUTc0?=
 =?utf-8?B?S3V4VGdqQTJ0QXFyWFRiMkJQdXQvZVdEeTlLNWRwTy8xSGRYWE9oeFJQWnd3?=
 =?utf-8?B?aFFFY0FYeFFZZGNWMVBXQkJtZmtCUzJkMnhjT0ZXSExYS0c4RHZ0K01vN0ZZ?=
 =?utf-8?B?TEJQRjgrK1lJcU0vb0d6NGN1Wm5LVURra2hIMUhpV1Bpa3B2SHR2eU92UXNi?=
 =?utf-8?B?N244MitoTUx6bEtCdUM0Qnd2dlBRPT0=?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e6427f1-add0-44ae-fd0b-08dd08b27149
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4958.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2024 15:54:25.6187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7KqqBqyy01eSZWXvu+j6StucAn1+WLwfXsldyjaRQxqFHGi5pDXMvsLtte87/Pit7Vm5H9utHS+CWsiIfFd+ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7684



On 11/18/24 16:55, Mikulas Patocka wrote:
> 
> 
> On Mon, 18 Nov 2024, Meir Elisha wrote:
> 
>>> diff --git a/drivers/md/persistent-data/dm-transaction-manager.c b/drivers/md/persistent-data/dm-transaction-manager.c
>>> index c7ba4e6cbbc7..8d486b1e6693 100644
>>> --- a/drivers/md/persistent-data/dm-transaction-manager.c
>>> +++ b/drivers/md/persistent-data/dm-transaction-manager.c
>>> @@ -10,6 +10,7 @@
>>>  #include "dm-space-map-metadata.h"
>>>  #include "dm-persistent-data-internal.h"
>>>  
>>> +#include <linux/moduleparam.h>
>>>  #include <linux/export.h>
>>>  #include <linux/mutex.h>
>>>  #include <linux/hash.h>
>>> @@ -84,8 +85,35 @@ struct shadow_info {
>>>  /*
>>>   * It would be nice if we scaled with the size of transaction.
>>>   */
>>> -#define DM_HASH_SIZE 256
>>> -#define DM_HASH_MASK (DM_HASH_SIZE - 1)
>>> +static uint tm_hash_table_size = 256;
>>> +
>>> +static int param_set_hash_size(const char *val, const struct kernel_param *kp)
>>> +{
>>> +	unsigned int num;
>>> +	int ret;
>>> +
>>> +	if (!val)
>>> +		return -EINVAL;
>>> +
>>> +	ret = kstrtouint(val, 0, &num);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	/* Hash size must be a power of 2 */
>>> +	if (!(num && !(num & (num - 1))))
>>> +		return -EINVAL;
>>> +
>>> +	*((unsigned int *)kp->arg) = num;
>>> +	return 0;
>>> +}
>>> +
>>> +static const struct kernel_param_ops tm_hash_table_size_ops = {
>>> +	.set = param_set_hash_size,
>>> +	.get = param_get_uint
>>> +};
>>> +
>>> +module_param_cb(tm_hash_table_size, &tm_hash_table_size_ops, &tm_hash_table_size, 0644);
>>> +MODULE_PARM_DESC(tm_hash_table_size, "transaction manager hash size");
>>>  
>>>  struct dm_transaction_manager {
>>>  	int is_clone;
>>> @@ -95,8 +123,9 @@ struct dm_transaction_manager {
>>>  	struct dm_space_map *sm;
>>>  
>>>  	spinlock_t lock;
>>> -	struct hlist_head buckets[DM_HASH_SIZE];
>>> -
>>> +	struct hlist_head *buckets;
>>> +	uint hash_size;
>>> +	uint hash_mask;
>>>  	struct prefetch_set prefetches;
>>>  };
>>>  
>>> @@ -105,7 +134,7 @@ struct dm_transaction_manager {
>>>  static int is_shadow(struct dm_transaction_manager *tm, dm_block_t b)
>>>  {
>>>  	int r = 0;
>>> -	unsigned int bucket = dm_hash_block(b, DM_HASH_MASK);
>>> +	unsigned int bucket = dm_hash_block(b, tm->hash_mask);
>>>  	struct shadow_info *si;
>>>  
>>>  	spin_lock(&tm->lock);
>>> @@ -131,7 +160,7 @@ static void insert_shadow(struct dm_transaction_manager *tm, dm_block_t b)
>>>  	si = kmalloc(sizeof(*si), GFP_NOIO);
>>>  	if (si) {
>>>  		si->where = b;
>>> -		bucket = dm_hash_block(b, DM_HASH_MASK);
>>> +		bucket = dm_hash_block(b, tm->hash_mask);
>>>  		spin_lock(&tm->lock);
>>>  		hlist_add_head(&si->hlist, tm->buckets + bucket);
>>>  		spin_unlock(&tm->lock);
>>> @@ -146,7 +175,7 @@ static void wipe_shadow_table(struct dm_transaction_manager *tm)
>>>  	int i;
>>>  
>>>  	spin_lock(&tm->lock);
>>> -	for (i = 0; i < DM_HASH_SIZE; i++) {
>>> +	for (i = 0; i < tm->hash_size; i++) {
>>>  		bucket = tm->buckets + i;
>>>  		hlist_for_each_entry_safe(si, tmp, bucket, hlist)
>>>  			kfree(si);
>>> @@ -169,13 +198,19 @@ static struct dm_transaction_manager *dm_tm_create(struct dm_block_manager *bm,
>>>  	if (!tm)
>>>  		return ERR_PTR(-ENOMEM);
>>>  
>>> +	tm->hash_size = tm_hash_table_size;
>>> +	tm->buckets = kmalloc_array(tm->hash_size, sizeof(*tm->buckets), GFP_KERNEL);
>>> +	if (!tm->buckets)
>>> +		return ERR_PTR(-ENOMEM);
>>> +
>>>  	tm->is_clone = 0;
>>>  	tm->real = NULL;
>>>  	tm->bm = bm;
>>>  	tm->sm = sm;
>>> +	tm->hash_mask = tm->hash_size - 1;
>>>  
>>>  	spin_lock_init(&tm->lock);
>>> -	for (i = 0; i < DM_HASH_SIZE; i++)
>>> +	for (i = 0; i < tm->hash_size; i++)
>>>  		INIT_HLIST_HEAD(tm->buckets + i);
>>>  
>>>  	prefetch_init(&tm->prefetches);
>>
>> Hi all,
>>
>> I wanted to follow up on this patch. 
>> Could you please review it when you have a chance?
>> If you need any additional information or have concerns, let me know.
>> Thanks for your time.
> 
> Hi
> 
> I discussed it with Joe. We concluded that the patch is not much useful, 
> because few users will know about this option and few users will change it 
> if they hit bad performance.
> 
> Joe will be reworking the code so that it will use rb-trees instead of 
> linked lists when there will be hash collision, this could improve 
> performance without adding a tunable variable.
> 
> Mikulas
> 

First of all, thanks for the response.
I get that probably not too many users will use the module_param
but it has a significant performance impact on our use case.
Any general idea when the rb-trees solution should be submitted?
