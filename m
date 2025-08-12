Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013064.outbound.protection.outlook.com [40.107.44.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0963FB1B
	for <dm-devel@lists.linux.dev>; Tue, 12 Aug 2025 02:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754965111; cv=fail; b=DEH1CJ81jLn6fJkxu0lTNk8tWYOm5u+FhvKYmoDn6OktFz2RUXEfBBJ9WiWvvRn61UZYEauykA+1IrUKU9ZJ0z2X6D0pUzI4jCT7/TdMGJlCF9AMAggEhOkGO5qyOt0DJbPKNb081pEpJHv/Iz8BgAd5AISa1cYzKNO1diXkRbM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754965111; c=relaxed/simple;
	bh=DfL2+wuu9UxgTVj1a0SR2IyoDoiylboEzSonAKQZIUw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Psy02M8I5WyijNTrj/YyMxHwUv5yEyKEJ4SQHW9ISEFXzUfkn1vckYFfQrnUvr28GcJGlLfLz0AZQf1F4xSKjDKdVciZ8hhF0Wu3rw+kgJK6meLXx057QEpnRQ6mp/HzinnWQOypZruk1Ec7R6Ri/lQFKC4almg4xPjXoovb0Ew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=Z2gdiqwC; arc=fail smtp.client-ip=40.107.44.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="Z2gdiqwC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IRUiTGY/AKtAkLk5s76/CB/GmvRUeYqDPAeFN+N/dGfuEcEV8VfmGxnnFCNxtZfDd2rnJ7IeWCV5c0Ufx5hdAGEom9cNCafyGRV4zjUexDuP2XcGs7xY7wvCQEwkhD6+3SgMIAX1Zakgkqsxq0sIzwSqb96UAGcNPwY1bHX49AYG8WOSMAajUAr37cIh10QyRLmiInGZWUP9SwBturtkkQFeq0i8pr2GDynJgLnn/jwyxjrVDXG2/0IqrvmWXqtXXBb1Kt9KZInztdvMosVXlW8MhO4mb0TuRK73sRJ15dEaHKD5xgdm27vfMTgatl1mZ9/923VT8LiDRVELNXK8Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DfL2+wuu9UxgTVj1a0SR2IyoDoiylboEzSonAKQZIUw=;
 b=kVsGp0kJfCMQYFgW8SI2843L2r53G2xyvmOiUpc/qeWNVKnT8qlYFAHeR821PLZWkClTUu05RBhqWxsI5w9YkTQlORyznwvWiVMNSnsGq5g84n2M5tRtlbxOqrRU0SU6MuxnE8rap79Z4/3cvUJPdqcMDG8MTKpmItWyYlbca4RENTA3x8p/fhjgJXRSwJ56qKacCiBwZnbcHI4HfK/3vcayEi0W01/d0QGU1eZU7kxKvYtiaQu8CT8B7RfTRMBCTf7/UxvtjWWwUDoiISnrAWxgq00bhIRaFZBGJPLtbMJXf0ObqXOJYkrSpAty4lltiO+IwVRCad3ATCPPIiAp0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DfL2+wuu9UxgTVj1a0SR2IyoDoiylboEzSonAKQZIUw=;
 b=Z2gdiqwCvD/kHEIOHgIw8H1bLX7iyBlxItgOE2DyKFNun85IrsENaB5ue/vJiP6sfzmrWDWz8YRG2R142cTb94vAAnAOmflNw2rA77BAZlnkOo+5NUy7dacMPblOQyjuK/0NRLpqkWgvbvaGPPYAoF5rE4MjUN1bZMwP6op3X5NdY8SJ8BDg8xV5HDqJbfyZq7QzylvjPwIRoXXM25CsW0Q+vdnq/C4DitPmBkqy5ciJiM1vkaMul+C6DFgsxUqbMdlmTVi1dGjv7ytSb37WGMW0mklmtQnhAJe2SsxG7CDnOr2nDrunG4p4nvdRURu9PoSQXUMnc9gVj3eBVx6Qug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 SG2PR06MB5334.apcprd06.prod.outlook.com (2603:1096:4:1d5::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.21; Tue, 12 Aug 2025 02:18:26 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.9009.018; Tue, 12 Aug 2025
 02:18:25 +0000
Message-ID: <81f495fe-508c-4f7e-8a69-1738343c5a58@vivo.com>
Date: Tue, 12 Aug 2025 10:18:23 +0800
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
 <bae5bba3-a73e-4a5d-80f8-e1506d0a302e@vivo.com>
 <4fe735d7-736c-7bbb-173a-1bee27bbe92b@redhat.com>
From: Qianfeng Rong <rongqianfeng@vivo.com>
In-Reply-To: <4fe735d7-736c-7bbb-173a-1bee27bbe92b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR01CA0177.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::33) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|SG2PR06MB5334:EE_
X-MS-Office365-Filtering-Correlation-Id: d700198e-67c1-4ff7-dd9d-08ddd94684cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RHlucE1jZWM3ZnJob0VPWDhXcm8ybEhueUlLWU12c1dMbEcrc0tEV3laVkFE?=
 =?utf-8?B?enJNZ2ZoQzRBMnRwS3lNZEJkS1BrQXRzMXRSVXlmMDMySG1seXgxQXZNYzRU?=
 =?utf-8?B?SWYra2lPMDhOa01JWFVRWHkxK3RadUt6SVFzKzZKQkNna01EMlBLUDJ5U2hk?=
 =?utf-8?B?bVRqb3g2NEFpeFAyV3ZWcnpGOVVkU0dRWXVtRU9VNy81dkZXYW1lSzBMUzVQ?=
 =?utf-8?B?VEZKRnB0RE1wR1kvMGxCSyt1R0FqK2tKSGJ0RlQ5alFhczgzczRvSisrK1Ny?=
 =?utf-8?B?L2hEMFdkNnA3QitKbkxUYWFZbEVjVWU1NnlPb1lBWlBTRCs4MVp2dG9ncnRS?=
 =?utf-8?B?M2dIb0dmTnJNTDJwcDAxdVVNSGRCMHJuUEc2TTFmaFcrUm5nRFY4ekw2cU01?=
 =?utf-8?B?cG5KRm9SQWR0alkzREV6RzA3Ty9TSytKQkYxLzlxWi9STDJwRWdBSGtJVllu?=
 =?utf-8?B?MDJBbWxlekplam5BZmljaE9nMTJXbTBLb0dhZ0FmOHlMUXpSOFh5eWVyUDln?=
 =?utf-8?B?dzJsUFcrMDlaOFgrcWtwTlBLbHlpRHQ1TERFOWIwNTBWT0h6QjBjM0NHTkgv?=
 =?utf-8?B?Qkdzbi8yRkdoTjAyQks3UEtpZEhRdGRqYTdROFBGd0lCNzhleWlOcXVvZ0Ix?=
 =?utf-8?B?TjdpaTBRdDR6N2QyRlpwUGVMZzkzc3Q3Zjh2cHdFelpMdkpsa05NY1ovalpp?=
 =?utf-8?B?eFh2ZTZlQmFrQ20yRzllOGlrdjk1dGFhb01IVmZ4cTlTbGlGYUZJbENXU1J5?=
 =?utf-8?B?VE1sY05kWlJGUDladDZ2UlA4c2ZvOWNYNlc2ZVRGSlhuUVNkdDhqSTZPTy94?=
 =?utf-8?B?NW1iZlJ4UTdtV1hQRGlPYmNySHg4SFhkRnExOXBwR002aW5IOXpTU3pCby9I?=
 =?utf-8?B?NHpVb2Q1TjdUYk13VjYzLzR1M00vWEFrRU9qQVQ4TmZ5MW9jZjF5b0laK2lM?=
 =?utf-8?B?SVRwRGRwOXhEVE1WMU55OC9rRDE4Uy9LOXFEWmJoWDEzaXNoRnFqZXNBQlcv?=
 =?utf-8?B?eXMxaVE2ekNyQ1NjaUc2bkFhMTAxakZ1b3BBVjlvUldDUVlyVTNmakhWZy82?=
 =?utf-8?B?VWhyaXZuN1YyRldrNENsazNTRVVyUzAvQVhRM05ycWg1OVJGU0g3bnN0U2pB?=
 =?utf-8?B?WnV4UjFQelF1S0xpblUreHV3bllVNGdZbmpyM0ViY3lxM2o0RklSVk9jNnEr?=
 =?utf-8?B?TFpsY1Q4UnE3M2x1enlydGdqVjV5YlVjamZnMlY0bjJNZnR6TXNiQ2s5dHlG?=
 =?utf-8?B?WHdGbGtpbDM1U0hhOVdEMTRiM21TRTNiQ1NLdUlvT2luYzBsMmRvWGpUb2Rt?=
 =?utf-8?B?SE5kRlN5RFRET0RsdE03aHEyM1phTHRnc1ZrZHFHK2N2YXQyZTk5cnJTRVFS?=
 =?utf-8?B?Q3gxY1RlQUhaSjM1cDA0enh5bXVxTTJ0elBnUitGb3ZCSVptc3UxY0JZQlFx?=
 =?utf-8?B?ZUVqVHl6R1Foa2grSlo1bHE5WnY2OFRCUm5pRGU5UzV6ZlkzbWp2N3paKy8v?=
 =?utf-8?B?SG5Vd2toZERQaEdSRzE4S0FzWjRNM25qY3o0cDNtT0xLQVQvaUpsVFBkZS9u?=
 =?utf-8?B?SmROSFJiem8wTzFqd0FLRXRqaFd6a2h1aEpTcnd0Z3QyZi9IZHRMeXJiczFP?=
 =?utf-8?B?b1p0QXZ5cUZBek5YbjUwdllKUjdwZWVFNXhoZ1MvcjlZNm9GUDQvejZlNGJy?=
 =?utf-8?B?eFhXVVFzMnFFUDd6cE02cFlYWGdkaWVicHJ5ZkV3YU1LTmVoSitJejZmdXl5?=
 =?utf-8?B?M0lldDJWUnVvVzNQS1BiUjdTNWJtTG1mODY2YXNPT04yd3lwQXhVck05bTNz?=
 =?utf-8?B?SU5yV1Jmd1JnbFJXbWQxZGt1TWtUMnpId1RDSTB4alhDMHoyaGE1N1B3ZnpV?=
 =?utf-8?B?U0dSV1JpSkswditVVVRQcFlKdTdKV1UzMXNLYjR4S1VmYXFtc3BCK0JLaUVK?=
 =?utf-8?Q?ODIqpt8Q2rs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y3ZYLytCTE8wc2x3eTB2RzBiRkxhNmVIWVJOWkd3YUkvcFdMOVpMbFh2ayt5?=
 =?utf-8?B?NHJidFVSbFN0NHJsNlc1emVETC92TzhNcTVCcGJmc2tZV3NSVVMxVUlBQXIy?=
 =?utf-8?B?ZUhXMjkvbC9Ea3ZET1B1bWphL0lhOVBDRWZCQytIWCtUNklndmZXbEM1RlFh?=
 =?utf-8?B?azJvTW5OR0UvNmZkcHV5TnFCWTliejk0b1lUQU1Nd213NHM5dWpYWEZIR3My?=
 =?utf-8?B?My93Z01GZE5JbEhKNE0zWUhieWpzUGduWEorWHM1UitjVHBmVUNYY2I0ck43?=
 =?utf-8?B?QXZkb0pobnRBRyswN3pid2JYNTJnanRxSmFIYW16WE4zamVFMUNGelJaSEo0?=
 =?utf-8?B?MnNrak1aSnduZUFmZG92aS9HdTlUSzBsTjZrbGpzR1JKdTE2YktLK1VWSEhk?=
 =?utf-8?B?MFJzeDBpVWI3SWlVMEpCRVJ5M0xUZlA0MTIrWWpBZE1OYm1uWjF6cjBXS05z?=
 =?utf-8?B?ZmZEOXlsS3dOenRhQ3lJc3krYmNZVG0zZXdKRmZzbENVVG1BR040eFliTHg5?=
 =?utf-8?B?QmVIYWE4ZjR3Wi9hSmNYTWhnZDZWeFhnTEQ4NWtrWmNka0JnUVUyY29NUVl3?=
 =?utf-8?B?bWp3aUlWNVh6Tk5PUXhWOUxUUDBJNEpxc1QyVGk4K0k5WlpDTWIyN2JEUVVn?=
 =?utf-8?B?VFNvMThoaFlRS1RyVndFbVl3ZWN3YTFaanJqR0hlcUxhb3BOZ28vTjNMc1NI?=
 =?utf-8?B?R0hDTFVsclpJL1d6a0xpTk1XQUpaMUFVcDVuTmx2R21aR2RxbENIcVNSSFRM?=
 =?utf-8?B?SCtvak51SVcxUlBLamFLejdOdTFMSC9WNU1FSENqS0YwczhlcUt4Z1BKZkNG?=
 =?utf-8?B?WDU0Mlkwd0RubjZDcWhoRGp2c1o0NEpCdC9oSnhIeDNuSGs2L0c4ZnZsamJn?=
 =?utf-8?B?YjQ1d0J2dFpkVG9RQVp5ZFpmWVpINmZJcmtNdmJMZHFpcWVJN1gxUzB4bTVM?=
 =?utf-8?B?MkIxM0loRzIybFo3Zmp6bGtvL0ZRVjlScmJpTEx1Wm5iK0pRQm9OQytKbURW?=
 =?utf-8?B?MXJmTGp4VkM1N3NlREtvY21pandrQTFqUkFTZk11ZnF3am1VS1o4eFVZeGU2?=
 =?utf-8?B?OU1UOU56WkdmZGlQa2VBK3dTZTV2c1AxSldVWkI0U3hRNjdMNEg4MzBXVzRE?=
 =?utf-8?B?enZkdVZncFV4aUZzZTVRQlcvTENKZm1JTWVxam85REtWdFZMTkVsMUFPcm9R?=
 =?utf-8?B?eXZWTWFBOVpkK0lKbVRsUFJEQndTcitNUkRuUS83Z3ViSFErZWNZMFhhcHBX?=
 =?utf-8?B?UDRqT3pNenY4MXlwV2s0OTR6TGtWS053cngvRVk1a25LRlhWN3F2dDYxY2lT?=
 =?utf-8?B?U2FEbFRuQXhFZVhQN2hEL3lTOFVaL3VsRWljaE1FUmg2MThiZTlWa2MrZHZP?=
 =?utf-8?B?U0pVdnNXM1JhYzRzOXkxTnBPaWY4cGdDYkNXbVp2Zzl2MENKc0x6ak5wTDBP?=
 =?utf-8?B?d0pRQ0dmRWRkU0JBVWpRY21EbVgxMTZ0bjBkdjFvR0hwaTdpaU5mSDhiTHJv?=
 =?utf-8?B?QmI5Q0R2RUxqd0VKN3E0NXlIcktlMkY2Y3FEWHBCaFd2UWROS2NFcjJxdDFm?=
 =?utf-8?B?c3VFdlRSeCtpSE1ZMm8zN091bEQ4cDJ1dm95NHYxUTh6TVcrNEFoY2l3N0hV?=
 =?utf-8?B?V0hRTHBjVDV4RXY3eHdqRzQycVRRWG9kWDQvcHdzc0FITkhNbGxUMjlGZFhu?=
 =?utf-8?B?YXhsL2JqSXlHNUtVUXMxVERCNUdSdUJHQ1puSCthUWN2VnBaNjlXUzFTUHQ2?=
 =?utf-8?B?QW5Bd252WlhaL28yVlo1TUlIR2t4Q1hHUk4vNTMveFZDTndBUS9TKzNCaCtN?=
 =?utf-8?B?VTc2ZjRMQWsvM2RwcCswNXQ3MTZlaHNJSzgzS3pKd1RjZmRONWxLeW9NWUQr?=
 =?utf-8?B?dWJHM2o3YkduZWl2aUt2NXJ4Y2tBSWpZWGdreUEvR1RyWUtDRkdITjdxNWla?=
 =?utf-8?B?aWNpSFZpbDRCUDFDZTBBR082T3BUcVo1bWJCSTdLN2ZDazVDeEdFdVJ5Y045?=
 =?utf-8?B?MDBReExOanZWOHkyOXlQeTJKc0pkZFVVb2c4c1pyeTdwUSthSktNbE9ZUC9p?=
 =?utf-8?B?Wml6WDBITHFuVFhvbWE4OFVwUkdxUVdJYVNkbEZpMmxSdlBsbkEyaWdDNWFl?=
 =?utf-8?Q?ZNHwPJiHbgUzT2FPdQ5Gbzia/?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d700198e-67c1-4ff7-dd9d-08ddd94684cf
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 02:18:25.7910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NdHdQwp1MHApdsAa5sdfbNqOERCymzkOB5BF/vBotDwC8lcDVc5eNHuboNkpLPNV9JUU/8LfES70292VnjzlUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB5334


在 2025/8/11 23:10, Mikulas Patocka 写道:
>
> On Mon, 11 Aug 2025, Qianfeng Rong wrote:
>
>> 在 2025/8/11 20:44, Mikulas Patocka 写道:
>>> Hi
>>>
>>> I think that GFP_NOWAIT already includes __GFP_NORETRY too. So, should we
>>> drop __GFP_NORETRY as well?
>> GFP_NOWAIT does not include __GFP_NORETRY:
>> #define GFP_NOWAIT (__GFP_KSWAPD_RECLAIM | __GFP_NOWARN)
>>
>> GFP_NOWAIT tells the memory manager to only wake up kswapd to perform
>> memory reclamation, not to perform direct memory reclaim.  Even if the
>> request fails, no error message is printed.
>>
>> Best regards,
>> Qianfeng
> Yes, but if GFP_NOWAIT allocation can't sleep, it can't retry - thus
> GFP_NOWAIT should imply __GFP_NORETRY.
>
> Mikulas
I strongly agree with your perspective, but I'm uncertain whether
GFP_NOWAIT should include __GFP_NORETRY, or if we should add a
note stating GFP_NOWAIT/GFP_ATOMIC should not be combined with
__GFP_NORETRY since it becomes redundant in atomic contexts.  I'll
raise this issue to see if others have insights.

Best regards,
Qianfeng

