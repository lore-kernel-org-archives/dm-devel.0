Received: from SY2PR01CU004.outbound.protection.outlook.com (mail-australiaeastazolkn19011027.outbound.protection.outlook.com [52.103.72.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA703430BA8
	for <dm-devel@lists.linux.dev>; Sun,  1 Mar 2026 13:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.72.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772371110; cv=fail; b=jMlilbs5V0yZVUMOJHDW33k1g2Exz81wvUvBuulXxoa+5Qi3o7fGaldZr/k0vY2gkbRSinC4c/qlynQWYBY7bjdDYAVMO8pmDjQLijqGY2cvTsw5+la1ZiSeP0cTFgTzNYH50dzQC/RmEGP+zIt54RAdZHLeLECTZiFoaazxUo8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772371110; c=relaxed/simple;
	bh=n8IXMC38UXHtyWs4qngvoOW3uSTens4khOOE4nfTBSA=;
	h=From:Date:Subject:Content-Type:Message-ID:To:Cc:MIME-Version; b=GWGM7sm0Omr22w5AJ3QBI3zV7ZFskKXERagpaJKpDZAOQcEccHWGtEbwJzO4XxaBBObREId6DORswGEbe/oskQqGcnue2so8Q1OO4MCdB3u5Y5VFUU+MDarSLmWNUvW+jIsJTv45gcUHMb4a/0CyPY5PvqVNgM6cJ94iLmYiiFg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=VEcvc5Re; arc=fail smtp.client-ip=52.103.72.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="VEcvc5Re"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ig/JEDjP8DHmP9FaIFQzDBXVcDKnD74KKcm718Dl7UsDlTKOZQg0ARYDC2v7/mZRCQwZyIbPqGQNL1sVsQzCG10t9rojJLQuL/GVCEodmAweZGgxG/YaqIWL1whS4lhnmGN217Q7kMWgP696mF3d5fzlyjcbYthhDB8GtU7NusFDuNkSj34xhFEvZlwcYXP5e9tk07lYiYh66hqARPtkVKIfYA/RAXGedFs0e6vm3pV/JH3JbSDZh2TN8htzUQQIKVYE0JkUuuObWasJgu0txxv4tiBDnE0BsMGtZjnSnfcBXY/CSIrti2SJa+F9QePUQoyeYUkwKrKIi6GH/HRmzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uu5V7t1DboYB9K07VWthFLxHfrdXYQs23crYXWt9bno=;
 b=HDd/mcqX4OC9EP8VuLBYDTNWW20Cx3E1/S1RcFOoLQPlIslmNII+LAL/TsCE7pzjdgEv6Pt3SSEiIQZaGCJjNXKBmbkTT6cAtrpJWaOHtwxBykFV0l/AyylHJbASKsCWkw3Evj/CLXThF+PhDMcgUqY5ugUrNpnVE9zcbFr0pauv3Wtf2ryE/m+9Pu4Hl8+3OZUPTd86cPDBxT1b4q6TAom6TDouMlpFe6fqsfXoxYIBLEuL5/Qy4zPVE0vp8i4fD3bOrrKdDBZFQavbxnRBdh0TfL7M73hVvZqL16kvjwew5mET+6mTxU1GXVXBGw5Ln1hTCyBDVsOScHAKvLXlRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uu5V7t1DboYB9K07VWthFLxHfrdXYQs23crYXWt9bno=;
 b=VEcvc5ReiDToyRCf37fHKNNn3DXYQTlM1au7fG9JayMvcGAEDQjEZKjuJb2TluU/eVHSMFfsoh6p7XJoo0bDntmwulDJIVS1JOTEU85y/F8Mygslt+nGfWbEpQOUK+GZza3ZPS7gErfmbh6dG8zZVkZvDPiVovp27f7sDibQM1Ps/4+2j4hkYXK1pZ99pJluWrm4FXsfLudr0wgUBEy17wuhJGK6JNA8xZbDCIxwaI+sZ/EGGojA2ilxAbn9UFSFY8GJRn97pJAm/+taOEKfdbJRwag0TJFl8LIOHPcNMP6yMttV5/eIVfFRb4bAdF3D7Ch1VKNn0SXFJqom9EUarQ==
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com (2603:10c6:10:1b0::5)
 by ME5PR01MB9836.ausprd01.prod.outlook.com (2603:10c6:220:258::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Sun, 1 Mar
 2026 13:18:24 +0000
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c]) by SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c%5]) with mapi id 15.20.9654.015; Sun, 1 Mar 2026
 13:18:24 +0000
From: Junrui Luo <moonafterrain@outlook.com>
Date: Sun, 01 Mar 2026 21:10:58 +0800
Subject: [PATCH] dm mirror: fix integer overflow in create_dirty_log()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID:
 <SYBPR01MB78818AAF59CB119B833C535DAF71A@SYBPR01MB7881.ausprd01.prod.outlook.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDYwND3bTMitRiXdMkU0szSzNzA0uzZCWg2oKiVLAEUGl0bG0tACSaWeJ
 XAAAA
X-Change-ID: 20260301-fixes-5b596967096c
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Yuhao Jiang <danisjiang@gmail.com>, Junrui Luo <moonafterrain@outlook.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1683;
 i=moonafterrain@outlook.com; h=from:subject:message-id;
 bh=n8IXMC38UXHtyWs4qngvoOW3uSTens4khOOE4nfTBSA=;
 b=owGbwMvMwCVW+MIioLvvgwPjabUkhswlNlP2NCxeXzZ9Ut/tp1zXipnKHIUzgx6+0HJeZq0v4
 VVxpzmvo5SFQYyLQVZMkeV4waVvFr5bdLf4bEmGmcPKBDKEgYtTACby0JqRYWXl3bMxfdGHWFws
 Iu9McdE71H0zrU3KVCmRa7l/WWZFMCPDmhVMawsFudmYp7c9ZnZjDuz40TQ3UyN3Yrg+w+Kw1c2
 cAA==
X-Developer-Key: i=moonafterrain@outlook.com; a=openpgp;
 fpr=C770D2F6384DB42DB44CB46371E838508B8EF040
X-ClientProxiedBy: SJ0PR05CA0110.namprd05.prod.outlook.com
 (2603:10b6:a03:334::25) To SYBPR01MB7881.ausprd01.prod.outlook.com
 (2603:10c6:10:1b0::5)
X-Microsoft-Original-Message-ID:
 <20260301-fixes-v1-1-23bbe8fed782@outlook.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYBPR01MB7881:EE_|ME5PR01MB9836:EE_
X-MS-Office365-Filtering-Correlation-Id: 42aa34a9-d309-4fc4-5d6d-08de7795042b
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|12121999013|5072599009|19110799012|8060799015|15080799012|23021999003|41001999006|5062599005|461199028|6090799003|440099028|3412199025|40105399003|53005399003|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eFArY1RENjZxaUFzcVFabkFpdjkzUWNvajJIUTRsbHhvMklOendsV3pUK2Ft?=
 =?utf-8?B?SXlCVlhMNGlreHhXZFlPb1g1M0ptY09SL0pxem5mdktCc2lOZkxNWEhkdS9N?=
 =?utf-8?B?bjNhUWc2eXZUK0ZzYWNoRVNxcmNaNmhNejFqTGZicDhMajZZYU9nNjNlc0l2?=
 =?utf-8?B?ZkxEOWQ1dXpEVm5VQU9Xc1BxdmJlTHRib1ZtWUdoVHRGbTFobm84T2MzcVVy?=
 =?utf-8?B?MzhPSWpRandFNCtVdzR2eEx1RGJ1SjdtRnpiTlhLTUU4YXdTOXh0UEVHamJ5?=
 =?utf-8?B?a2VJR2RnZ1RMKzE1TzhTMGRFc0RmWE44OUUrYkdiZzRIWi9QQXRzejA3UjIv?=
 =?utf-8?B?QzhIVFhDRHRJQnpnTU1WNWNoWnZwcE9WNHRIbXlwVGxwL3BwWGRZSEFrYVRa?=
 =?utf-8?B?Vi94eGJNTWlSTkd2TGZWa3gyZjdmTGlIMWdGbHJSU1hsZ3VOUlZwYXV4NWdH?=
 =?utf-8?B?UHFaMGIrVWRPMGRaSGhmRGRYVTNMbXlwNjZLb0JDUGVGUFkyOExhSEN1dzN2?=
 =?utf-8?B?b2ZrSVRqZFU2MXZBM2lvZU13YWNoVG4raDVBaVBvTERodVNabnpXVVlNMnF5?=
 =?utf-8?B?WExJSWh3Vy9FK0prZWU4K3RwZGFMSzBXeW1rMXZQVmFybkxURnhoUThYOEVC?=
 =?utf-8?B?MFlQVVFaVFNlOG1sTG5adjVuY0RqL21pdisyMUtLa3ZXcHZzbXczek92VVhu?=
 =?utf-8?B?UThZMUN0T3hHVE14WDlianJqcTYwczBmRGR5U1ZZWllpSTJyY1RzdldCaG1F?=
 =?utf-8?B?ZUFUdlhDZi9Tb0o5d3VZSi9aMEQzWGd2cmV5MGNMR3ovcTFiYVFuZkJPQ3V4?=
 =?utf-8?B?NEcvQXhhaGdWaTc4eGxPSk9sdHFRZ2hGZkxPdTN5L3BJSVNkQUYvSkxQRzZC?=
 =?utf-8?B?d012K0F6ekJOZXl6WTdUTlVUZ3hETUdHaVNsLzNQK01mMktTL1J6Vzd4MWZv?=
 =?utf-8?B?NmlPRk9MMW9iR1pjWFBJMnc2TUo5ekgzczJUTzhZUVdrSlAxU29WVzN0ZXRK?=
 =?utf-8?B?SWpYVmF2ZmVVZmE2OGhqYklSRFkrVDZJSmw3K2RvQUF0L1R4dmRzUGtVQk9j?=
 =?utf-8?B?ZWJnb0FSd2lLSXJITU1BOTNDTVh1QkF2Z3lKRmtzK015dUxsQmZ6SkVqL1A2?=
 =?utf-8?B?OHUwVEZZME14QzRXdmpEWnZHTDVINW5zYzBlTEFLd2Y0eDZiMVFTeGZ1a3NM?=
 =?utf-8?B?dHFSYlNXWlJtUzEvVzZUUDJxS1ExOFRST2VoQzBvbDlLQWExSUdlUVFidFFr?=
 =?utf-8?B?aWFMVDlmZUFhb2wvbTVrZ0V0aHI1Z3NPSGlHUE80YXdPeU8rQ3c5eTBjNWcx?=
 =?utf-8?B?L2xkNERGN0JiOTRsbW1IQm1USVRCNGVWYnhPdHpBakJxV0dsWlJKWGpDSkw2?=
 =?utf-8?B?QjJ2VWp5UE9iVUVxTVRCc3EyN3lKZVJQZTZzV1F2ZDBRS1pIRGxqWkZxV0Zx?=
 =?utf-8?Q?MV8S6Bwa?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VTMzRytkazRQZWRxNXZOaHcxaUlKL0tYQ2JKZmpmK1JnYVRPcndpTUErWW0y?=
 =?utf-8?B?bW1WNDhwZnFUd2poKzZQdFZ5ZVJ0S0s1Z0UwTmFzeE9uZ21wMU9RNjN1K0tU?=
 =?utf-8?B?KzgybHBCZi82QjQ1ZEtNcXhiUHdCNFJUbllnTSt0VlVEaXphOTlwalZIclEy?=
 =?utf-8?B?RVZkdzRpODRIajU4QXpmcmkxWncxSkdNem4wbWcxNXJlSGJ1SjdkcEs0UnJ6?=
 =?utf-8?B?SHZ6WjZyYzZIRUt6aTR5UGVPSU1JMjVabzZSTW9IZHRYWXZ5Q1YvaUlLUjNG?=
 =?utf-8?B?T3FIVWFrclpIbmY5aVNGaFJnNGQ0emdpU3FmT0VVdUtYTWpQRnU0cFNac2xE?=
 =?utf-8?B?T0ZIUTZLUitaQk90M2lyV3VFMHNuaXNuYTFhUW1hMDlsK2poSXdta0VKem5Y?=
 =?utf-8?B?LzJudG9MWWtHVDZhNkc4REdtbWZQSUtUQnNvR0dJbHYycTVQNXo5c1FmT0kw?=
 =?utf-8?B?b1RlWU1RVHBiS2ZkOEhpZlZWWVM4RXdQVFYzRVA3VWhWd3MzQmNqcExFSHFK?=
 =?utf-8?B?L1RFY1lPdExkSnloNUVxTVo4S2pTRDU5cG1VZVNtWmNndG9WanUvNHdPdE1E?=
 =?utf-8?B?WFIvNit1QnY0d2hLcUdRR0tKNGdBOGxENjhIM2R6alBOQzcvT2x4MzBTV1dL?=
 =?utf-8?B?TUNnYUpaV0JEV1ZwMjVzNjV5V1hZR3dTK0VqSjZ3WGJTSnRoRVlTbGNtVncr?=
 =?utf-8?B?ODR4NXRoNEhLMlBMeEV4b1lsM2lWVENaZHZBazdveEd6eFFZbFJDVFB4OW9a?=
 =?utf-8?B?NWpTWmJ2NWNpVHUxRG55dW9VaUZBQSs1dUNkeWRvdkdqNXh5QnlHdXU5anhM?=
 =?utf-8?B?eUphYitOSDhIMnplVU1LMm9Od0FMRHNrMHNyM1JrbDN0aDlxbDlGUWxCckYw?=
 =?utf-8?B?U1BqMk5OZ0hPc3FvS25RakppYUNwd2drbHRMTmJqNWhVc0Z6WXZBM0VaeVJh?=
 =?utf-8?B?Q1J0WStkN2RGMlNKWkhUN1JVMEprNmRGdll1cGlPSit5azh5dTdXMkloT3Zp?=
 =?utf-8?B?Y3lwUUx3Q2w4NFVTT3JSVU9xckw5K2pyRDNURWlITkhlUERzQUNncmZVK1d6?=
 =?utf-8?B?VG5CVXNtUmNXTzlQN3lTdGZmU2VscGRoM2NCL092bHRjczZKTk40aTRlWUdu?=
 =?utf-8?B?eEVnWUpXQWtQT3ZrUFpZVFF2RWFGUDFOcnEwUnI4VXowcU9LYkhOSnFJRC9X?=
 =?utf-8?B?cGJpZnFnM0pUQkpLcVBwdVV6ZDN1QjFMN3ZwUUhrRDhGT1llZnVSQjV0a01L?=
 =?utf-8?B?MTB1T1oyd1ZuQVJUUU54TTlWQXFwOW9iUVY5eGV3dWoyWWhoTXRjM0grcXE3?=
 =?utf-8?B?NXNLeFUvVHJKUDA1c3VTcnB2OXp0a09kSWdiemh6MS9Cc2NKVU83MldHMHVv?=
 =?utf-8?B?Vm1EK2RpNGpCMFNRbStXYUF3MkhnWlpGTWhnK1NUZ3NtUWQvSWp4aU1VU1Yw?=
 =?utf-8?B?aERXdzFPTllNZmdZZlNqMVJ4MzF1dGxPbUwzdTgzT0VHWE00V292Zk1HR051?=
 =?utf-8?B?Tjd4WlhUU2NRTzEvTlp2eTlKKzl2dkFwcjNkUHVnV2F0ajJOVkRETG9nR2pN?=
 =?utf-8?B?eXMvWlhHeHUxSmdRUElGQ1FOMzVUbzRvTVYyaUt2UDhOdU1DZTM1RWZ4K3Ro?=
 =?utf-8?B?T0ZpMU9QSzhUV1VuTUtGQndYNjk5UjJYMnRDSWZRaGxWN3NwOWNHQ2UzSy80?=
 =?utf-8?B?L0NwWHdCVmxwckZsQkFid01BTDRZQUhYTk5GcFRDejFsS2hFMWNBalhkczh5?=
 =?utf-8?B?b2p3dXdsNDhlS3pBTS9FZWZGR2w1UlJWTkd4L0VoVzltdWkza1NpMUhLNUtB?=
 =?utf-8?B?Vmd6S3crS3JiVmI4bHN2aklKTjFoeEE2bG1CRWhwbmh3T1RjV05NWUk3MEFI?=
 =?utf-8?Q?gvwurHNfrzmuo?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42aa34a9-d309-4fc4-5d6d-08de7795042b
X-MS-Exchange-CrossTenant-AuthSource: SYBPR01MB7881.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2026 13:18:23.9987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ME5PR01MB9836

The argument count calculation in create_dirty_log() performs
`*args_used = 2 + param_count` before validating against argc. When a
user provides a param_count close to UINT_MAX via the device mapper
table string, this unsigned addition wraps around to a small value,
causing the subsequent `argc < *args_used` check to be bypassed.

The overflowed param_count is then passed as argc to dm_dirty_log_create(),
where it can cause out-of-bounds reads on the argv array.

Fix by comparing param_count against argc - 2 before performing the
addition, following the same pattern used by parse_features() in the
same file. Since argc >= 2 is already guaranteed, the subtraction is
safe.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
---
 drivers/md/dm-raid1.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 80a5c4127707..de5c00704e69 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -993,13 +993,13 @@ static struct dm_dirty_log *create_dirty_log(struct dm_target *ti,
 		return NULL;
 	}
 
-	*args_used = 2 + param_count;
-
-	if (argc < *args_used) {
+	if (param_count > argc - 2) {
 		ti->error = "Insufficient mirror log arguments";
 		return NULL;
 	}
 
+	*args_used = 2 + param_count;
+
 	dl = dm_dirty_log_create(argv[0], ti, mirror_flush, param_count,
 				 argv + 2);
 	if (!dl) {

---
base-commit: 4d349ee5c7782f8b27f6cb550f112c5e26fff38d
change-id: 20260301-fixes-5b596967096c

Best regards,
-- 
Junrui Luo <moonafterrain@outlook.com>

