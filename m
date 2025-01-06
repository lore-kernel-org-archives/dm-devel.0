Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C794ABA34
	for <dm-devel@lists.linux.dev>; Mon,  6 Jan 2025 14:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736173066; cv=fail; b=EbVck0Sy7ooeygCyKc43w+esxWvEnbNau0XmxDu6gM+pixZ2Nxt7qVo1qQOrbOvKKPLVOE6cACM+GVAkv7ls62CZVmiZ/CN7ayL53K+NmiKdNZmoLlE/cSHDxVL7IobJrTl/tzoP1nFq2fSxmPU11XC3p6fQh/0qv2KLKQYiRcA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736173066; c=relaxed/simple;
	bh=8pBjz8lv10W9g/Q0Zi4xMo0624c4195uGWdjcUyOpGQ=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=OFwXZKxb7o7RWuz8ijHgPugcCfhHjDjgiNLWd6Z2otgFIf0TpGw2m1EOmOH39UWnUw66OAvoOW1YQrERGLqsyk8elXZ2zpzPUbNpvCTPJs7+yPMzbqjMwRR2rfyi+CE8ekYOMhjA0C/namWZspw/Uw8Gt2OLzE6KOzxEH+hoCME=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Vw00utWd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XzfYhn2g; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Vw00utWd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XzfYhn2g"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5068u0L3019343;
	Mon, 6 Jan 2025 14:17:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=jZ3LZXWV2ZRI+RfU
	Axjqh5+RNQT2oz8vu+xkvFytCDc=; b=Vw00utWd8SkYGnNITBLZWnQ26yAIS2i0
	0LwUUItj6FXGQqqkLbP6aZPwusgeXJbnGTzmwOpnqU1BJy2sK7WKygJRiqqFTXc9
	osv+PmUmwsMSgYWgvRWc+HLsuFmPXIs9G6jasLMVs6lekRfLxBIrXbB6syozlQef
	pzhmMAclV/+tIW0yproV5aJb8nsW0As0pgcpqVsJ/2PxfPBDDDQ0I/ryjxpFruzx
	PN/r7oeR8lVjigYOJFNIEmqFSM0tKxsrXJFw+bwbsVrND/rCTv6DfpOtSiANex8v
	NwbrpI6eH36Qa/HtGYn2J0WOCbFhLPofEueSLeZnr3GG75AihCc+gQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xw1btd2q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jan 2025 14:17:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 506CBZ1r010934;
	Mon, 6 Jan 2025 14:17:42 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xue73fcx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jan 2025 14:17:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rzWUjlxLmVYtEztRbGBex6gkYjBXEdaFMUCYllbnkQ19ozcyb1UHV64N/K0v83LqZiChJHAm5+EF1s3Fw9yyPV31x53OCGNDQr3GPsztYDpaLi9/jupmwVOv79zbd/Akb4pnrGtTXZPzNcsuMlcCSoD4xWPtWzLCNDdZEiyu+CMJy6HcH3FD7OWLhN+lmv2o0rbiQiibaF2QDnQ3u3vHjiQdYIiuBWzvoxqPY7mki0Rnl6ebSPDGklzGY8QaBDOXSexrM0XA2zZzqQcFx/PQedCmmxF6tomwiMwP9orWrdJxaPsWG5nzNOTf2UqOdXWrvR9K36qJGHRuK6Gndf4yyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZ3LZXWV2ZRI+RfUAxjqh5+RNQT2oz8vu+xkvFytCDc=;
 b=yeaOuydiVcVp2R6Pr1S8eMkB7PJsZKKnDTCj9KnpXjn38NX57q25lqM5TKgZ4Yg0H0a4S99vkBvq3o+CMc5oYQfVUlogHNVB788KOETK0hG/uNtMj/FZUIWksASIT0ERUo9sRh/0qhz8Fwgn9BwVCN1CDrqwaAke5ecX55NvFcpSxrLsiBRB75P2s0jgO1sFMDy6ct6QvVp3IpEo30CEIV2TdBWvpeX8m9eZimyNjziR3ej9UaN10I110lu1JvWyurzZw1JYDVeIg1aqYXszvjQksAx/VOvTwqyqhLLy+KC+eGZnB3CHN8I6RbRjw9CG49RSSAo/vyyBtiOOIuCRHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZ3LZXWV2ZRI+RfUAxjqh5+RNQT2oz8vu+xkvFytCDc=;
 b=XzfYhn2gS9obzIanty4yxHDVrBqxOKoeGRN8BS3vAA4sw3LdSmxOmlMyk3ULuFPP2/GyRjfI3okTnI47qyak10bdiaWZ1smRyx14OElMOOp+bZXGENlS0CcEh66kRCagRjlW5GfpDfqGuvyLq5iySI4RnhV0RnRTWJs2KTQ2+P4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB7108.namprd10.prod.outlook.com (2603:10b6:510:27e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.16; Mon, 6 Jan
 2025 14:17:35 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8314.012; Mon, 6 Jan 2025
 14:17:35 +0000
From: John Garry <john.g.garry@oracle.com>
To: msakai@redhat.com
Cc: dm-devel@lists.linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH] dm vdo: Fix W=1 allmodconfig build error
Date: Mon,  6 Jan 2025 14:17:31 +0000
Message-Id: <20250106141731.1341034-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR11CA0090.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::31) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB7108:EE_
X-MS-Office365-Filtering-Correlation-Id: 2da96e9a-c0e8-490a-ee94-08dd2e5cde3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SkRRRE5wWnp0VXM3MWxUekRHOEg1QjZzRUc0bHJ1TXQxbklhZ3ZVRmxUa1pr?=
 =?utf-8?B?R0RXTFpHcXFkbUU1NHhmRkl6SlVkeVRHZ1pCdnN3V0lIeUVTVDdRTXhmZ3hu?=
 =?utf-8?B?RE9MYm5jUGh4ZUsrdEZUMjMxcUVwenM0Y20rdWpQSkFQSURyOGJLLzJsNmVL?=
 =?utf-8?B?amZxU2VTUzBMQlI1eTdhY1FrcEQycG43aWhmdEszdGpkaWV2aElDazczWXBy?=
 =?utf-8?B?UTY2d2JtZ1grQk8vMnVkUmZMeE5GdTFIUGwyVCs5NlhDVzRyQ2xOaE5DNXNO?=
 =?utf-8?B?NGVadjdQdUY4dDFvOEVRL3ltb3pDdkhoZUl6Tk1HRXNFSzJjdnVWa3JsNXBL?=
 =?utf-8?B?MDEvVklYbTYxanZ6VzJ3ZWhTVlFIcm9rMHM5RGxpL3hzK1pQUTRlOG52MEsr?=
 =?utf-8?B?S0RmTUJrYi9heVgwYzNjRm9BUkdIcU83SGJNQ24yek92clRISnFOQnlTZ0pE?=
 =?utf-8?B?cVRtcDVmMUI3bUd4MTZjcnhnYXJBZzNHYnhRUldTL2pmelcvUmVFU3NPRUlm?=
 =?utf-8?B?SEVVTXBXVnZra2phT2pOVU9uNWlLTkVDK056a0ZmUW1mZnZUZ3VKMVdBdDhi?=
 =?utf-8?B?VzVxVXovc0JjZFlTMitTL2tIWVl2N0tZNWVCcXZKRzFBVGdoZFd6enNqeDk3?=
 =?utf-8?B?REI5NU56d2JrbEt2b3pIYUx6cUtGbTM3UEVIQmxackdLNzA3MS9wNGw4NllZ?=
 =?utf-8?B?QUpKbXE2RVptV0NrTnI0bXh1Tkp5U1BEMDlVQVV2V2lQSHNEbCszVUUyOEtt?=
 =?utf-8?B?UkhQTFZxTTRvbVduTDRhOFU2UEZYNkNLaXB2TlhKdUtQYkFURitnUlBVcnNH?=
 =?utf-8?B?T3FMQTVOYWJ6RytKQ1o3MnZqYXNWVXFnWnpMcEgyOEdOSFJoZXpCejBDWUpI?=
 =?utf-8?B?ejE3SGpBWE5aNXNON2RvYS9MSDlZYkgzSXFxUWVGUGY4b3pZQXg5YnM3a2Mv?=
 =?utf-8?B?YmRGZVUvc0VLWFZkK0h2U2ZJcW8wKzNsQUhvN1ZvYkJUOHo2UW5PV28xaEdC?=
 =?utf-8?B?Nk1Rc1cwNlBCTXZRVzRmMlJnUFloSFM4SVFMenpMM2d4RE5rc2UzQTNlRTFo?=
 =?utf-8?B?S2g5R2poTEpTQWdaU3d5MGVKa1ZyRHN0M0hYR3JiYzBDeU11c1czRkdtbVNX?=
 =?utf-8?B?RTFBOGFBMkk4dWtWYjZXaTJPWFEwenFHK1VyWHdVSUt0RW52NmFFOGlPUTk4?=
 =?utf-8?B?K1h6K0RuanErcUVGZCtwV05WNXphem9iT0JNcTdBRG85ZVowQU1qY0hwVXh6?=
 =?utf-8?B?b1hyTm9aajF3Tkw2elVXQXhPZ3RWRU1sZzZZeXpiTUNvaW05YmRIdGFlNDNI?=
 =?utf-8?B?bWxCYXZJcVdqMUY3akdVZkpBVlA3bXdNL2pJMStjNDFkdk43N1E3SzY3U3d2?=
 =?utf-8?B?SjlNQWljc1JiK2VkbXUxR2NZc3NjRUZ5SmdMeDdHd3NOUU54TzAzRFF3citk?=
 =?utf-8?B?MHFHMnp4c1FRMHdOTjZZTEtVMnhOZFUxMHZndmVsM0MrdFlEVlFLRVdkU0RJ?=
 =?utf-8?B?WldlRVVWZHIyZFFFRzl4QkxPanR5ZUdyakNUNi9pNFIzMkUrYjNOUlplUStp?=
 =?utf-8?B?ZVpRMmVWUE5Db01HaGpKTFZSR3N4ay9IdTdDN3E4TmtrUmh6T2xPYTViWi9B?=
 =?utf-8?B?V3hWTjBSMjIyM1V5U1JDSjdpckYwNGJIZTdMakcrT3ZwT1JnMXM0SEkrdk8w?=
 =?utf-8?B?NzNTQXBlZStuVGNSOVZTb0d0RmZLZmM2Rk1KSXNJNlI1L2lWcWtaZEpQVjQx?=
 =?utf-8?B?YjMyRHBDM1VqTnRXNjM0dkY2VjZQM0hXUjlVSXVVb0dNNDFDWWpkeG8wMUd0?=
 =?utf-8?B?aWpPUm5UK0cweXZHUnY1Q0xwSXh6UHlTTnhRR1FYSlN1Y2lsdytranpKcVpl?=
 =?utf-8?Q?aWwMu+wTL8o4P?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bm53OG5seFRPMndRczlodmhrd1VpdDRaOVE3K2lDWjU1c1ZnSjE3bzN3REZD?=
 =?utf-8?B?RzY2eE9IeWRlRjI4Q0NBbzNjcUQ4WEhkSGR0cDR2L0pDK2FCcWwzTEw0c3N6?=
 =?utf-8?B?WWc3T25FdTljRVY2Wm9KaC9OdTl0Wk5HcVA5OFd6YVNPVzV0ZW80NkFyM2Q4?=
 =?utf-8?B?VDJFVHlJSXdmeG4xd3VXaU1oenBFUzJXdHJMNmtjK3VySk9aeVRzWnJGa3Vt?=
 =?utf-8?B?bmk5QVVIVHNEVHpSMGJkVVNHNkZZazJUaFlqdVRJUmFoSGdSZ3kxakNQaUN4?=
 =?utf-8?B?OExZQ0s3S3V5Uyt6V3FPNWhQNG5uV2c0K2lFM3NSY2ppWHZzM1MzWGhldjJP?=
 =?utf-8?B?d1c0ajlQRkQrTERjVXFvazl2dDRtWHRuNWlMZ2hXUmV2aUdLR2h1eVU0T2pI?=
 =?utf-8?B?Qi9OTHplT0E4K2MzSkxXZnQxR1hMMDF6a1M1ZTRwa2V4VktKdmJ2MHJVSE4v?=
 =?utf-8?B?NVlpN0gySGEwNmRCVWlycUxZckJodVJyTzl1Nmd1NndpWVZBd2d3ekVmdHNW?=
 =?utf-8?B?RFBObEFxSVYxcCtzUGR1SzE3anU1WGhqYU9jcDBqT05RTW1YMjhCNkhyajlu?=
 =?utf-8?B?MFVvNWk4VHRhN2dZL256Wi94WTg0cFFMV0hVZWpxREJodnFrNWMvQzFWYzgx?=
 =?utf-8?B?VDE0RTlEOVRZRlpqUUZ3OXN3RHBUNFovb2dUTUVyeWV1TFRPU2ZRSzRYOTZr?=
 =?utf-8?B?NmZBTEZwVDVUNzFBNHpyRVJpTGZjMEhVWmdFSG52dmVRd0pVSTdNRS9iZzU0?=
 =?utf-8?B?dGpEU1VqYVg1cUdCWVJCTDNuNmhkSWlpV1VoSlJhTzZKQWUwU2xMajQxRzNj?=
 =?utf-8?B?VzlZVkJ2K2xlQlBZb1NuWDlrTTlGbWR2dWw4Vkh3VTNDOHVCbEh4UWhCdHZG?=
 =?utf-8?B?WkgxVGxvYmhLV1psTnJML0huSVB0Wk5FeUQ3WHBOSTZEd3JQL1FwQVJ3UllM?=
 =?utf-8?B?U2hkbDRpT2lIMU1yaXlQb3F6cnVPQ295NDdZNWUzcWs4blJWb3YwejBjRVdi?=
 =?utf-8?B?VExiakJXKzIvU054OTJITjVlcTBsWlFaK0o0dmZSa1hVc3JmbTFyK1J5R21F?=
 =?utf-8?B?TXhDRElCTGZ0WTNXN1BubzdSSGI4MnRxdW0rOUd6SlJmaytBUUt3QU1QS1lE?=
 =?utf-8?B?M3NEZUptQWdqT1g5a0RpNmpFWlFlUXAzTEVJMkNKKys0dlYvY0Z1VitERFVj?=
 =?utf-8?B?M2Z2eUVxSU5ZUThONmNRMElqaEc3STlYb2ZRUUVYd0MxZlBUaWJQMmJaQXM2?=
 =?utf-8?B?U3Roc2MyRXY0YitnUnN4aWY2U01VcGJlVHpyNjFjTlJyTytiZUdUNVU5R2Jk?=
 =?utf-8?B?ZU51K1VGdjlNSWJ5NUg4V1dENk9MT1BiOG5Gd1NseEFXQnU1bHNDNElWYkR6?=
 =?utf-8?B?SEtvZ1pvT2wrdlM2dHgyVHRRbFpzYzVydVB6ek00UzllY01RV0hPa0VVamFI?=
 =?utf-8?B?K3RiQTBYaE5SUjNhaFJoR3dGQnVUODAxL2NoM3FCQmsyb25DU1dXd3N6eVpE?=
 =?utf-8?B?WUJJM2NrQjc5Umc1czJKRCtCOTlLY29VMURqb1NyWWZ2d3NkUHpKWWFNYlNR?=
 =?utf-8?B?UktyVVJKeTY0dHdPeE43dEk5WVF2bUdhU0R5b09HVGZzcnZsZzVkTG1DTVBa?=
 =?utf-8?B?TDVUcDhMYjVmTUdWc3JWNTZWK05NNm9YY1JPVStGWklIc0FvK0xUc1JVQmpD?=
 =?utf-8?B?b05HbGpEZkRqQzVaNVZnMEdyNktWUXFTY09wcGJ0MkdYT3ZaNHVsQnFQTXhv?=
 =?utf-8?B?Z0c4ZHBRQ2tWYnpVcnRicm9zamp0YWZ4eTZHU2VxOVQ4Vk1PM1gyTDNiRmIw?=
 =?utf-8?B?bHFoNzE0K0VYUUhzSSttTk0vRnBCQWxaMm84NlpkQTF6bUpmenZUVnRuOUdt?=
 =?utf-8?B?R2FXcjZnNFpCVy9sanBTeUhTc2UrNCt6ZU94aEtCWmZOSEdRUmUwc2N0SUZr?=
 =?utf-8?B?VDh5TGppd1JQby9Fd1YyeGJyTGxLM1ZqUXRDRm93LzNUMHl0bmxPc242ajFB?=
 =?utf-8?B?dnpHandUWjlhdzBwemduL294S25XclFkVUowREtjazQrVzZ2eWk2bThLT2kz?=
 =?utf-8?B?eklMaWwzK3ArbHVKV28zSTJJY3lmdHg3SkZEQjBld0poc2xFc2F2d25PYnV5?=
 =?utf-8?B?R3lSNjl2NmxlUFJibkpZME9ERVhiNW82S1dYRmh3OUtRSWNtekRIc1JVTjZU?=
 =?utf-8?B?b3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WmAyt2LU1AG7Ixf3Mkb7RfkGZQzrQz2OPGzCj4S5KqfBcXZPIDm9zFY+VFjVPsEX9UQyA7g9Kw/llBNBLiUxCx0Wcdx5LQwFDbSunIjQyaMduvKoivcGAfDrvxxM8bF1psrrVHTPeBqnsXndmo0vMfsf0jeh6lIhx/tszWJp4rD/EsmUjHmlP/Miki66wPW4ejRcBaQR6SsyCpuamsLLc9VMAfvQErWczdftu4i9wbxfeuWoS5nC41yECtQ/G8Vp+zEI64DvWczecFLbhSX3l0mUlqUkxAhOWSXExWhdqxl/TsRqmyIUiA8HnfLE8zWHNnXkm0Q63qmaVkb1s4LM61ntrtL03oArOqLLZ0fd+MRXgc7fCFhOCNf5yAKQ1E4QKtqAWO3kjg4VEvGKZKV0oLgeCr6YSf/+U/5x3YxTczftvF7I+q5PLHbZgydZ4w02sOeAbW2hXgNo1Jx75cleghDOeSL8goUMyYBKdsvCeTQK2GUB7Sr0oeYl2yj5vd0Gbd0fhcDYzC4wL7ahdndRgGUJ1phWg9o/MogCEOtPvpF+kc0ZCL4NkasCUeOm1/9jLRDVXhNIqsNdcBANg98IolrJFtzK2oUmt2UbPs4najk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2da96e9a-c0e8-490a-ee94-08dd2e5cde3f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 14:17:35.8426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JiTkc1m7gjT0NGwtM+kLOG51XcJNPAuvhYGEJefWusS70PWo8wpqcFzBFQRmrdhOqnA+M6AhPxFEkmE+fwxfWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7108
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-06_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2501060126
X-Proofpoint-ORIG-GUID: u-XiNXJhZhpTw1qnZ8Nx5lLV-USdVDww
X-Proofpoint-GUID: u-XiNXJhZhpTw1qnZ8Nx5lLV-USdVDww

For an allmodconfig build, I currently get this error when building with
W=1:

$ make W=1 drivers/md/dm-vdo/vdo.o
  CALL    scripts/checksyscalls.sh
  DESCEND objtool
  INSTALL libsubcmd_headers
  CC [M]  drivers/md/dm-vdo/vdo.o
drivers/md/dm-vdo/vdo.c: In function ‘vdo_make’:
drivers/md/dm-vdo/vdo.c:564:5: error: ‘%s’ directive output may be truncated writing up to 55 bytes into a region of size 16 [-Werror=format-truncation=]
    "%s%u", MODULE_NAME, instance);
     ^~
drivers/md/dm-vdo/vdo.c:563:2: note: ‘snprintf’ output between 2 and 66 bytes into a destination of size 16
  snprintf(vdo->thread_name_prefix, sizeof(vdo->thread_name_prefix),
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    "%s%u", MODULE_NAME, instance);
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fix by defining MAX_VDO_WORK_QUEUE_NAME_LEN to be sum of MODULE_NAME_LEN
plus 11 - 11 comes from number of characters required to print max unsigned
int plus NUL terminator.

Also relocate the include of sched.h to the only c file which it is
actually needed.

Signed-off-by: John Garry <john.g.garry@oracle.com>

diff --git a/drivers/md/dm-vdo/funnel-workqueue.c b/drivers/md/dm-vdo/funnel-workqueue.c
index ae11941c90a9..7e42342263ab 100644
--- a/drivers/md/dm-vdo/funnel-workqueue.c
+++ b/drivers/md/dm-vdo/funnel-workqueue.c
@@ -11,6 +11,7 @@
 #include <linux/err.h>
 #include <linux/kthread.h>
 #include <linux/percpu.h>
+#include <linux/sched.h>
 
 #include "funnel-queue.h"
 #include "logger.h"
diff --git a/drivers/md/dm-vdo/funnel-workqueue.h b/drivers/md/dm-vdo/funnel-workqueue.h
index b5be6e9e83bc..3447aac5b188 100644
--- a/drivers/md/dm-vdo/funnel-workqueue.h
+++ b/drivers/md/dm-vdo/funnel-workqueue.h
@@ -6,12 +6,10 @@
 #ifndef VDO_WORK_QUEUE_H
 #define VDO_WORK_QUEUE_H
 
-#include <linux/sched.h> /* for TASK_COMM_LEN */
-
 #include "types.h"
 
 enum {
-	MAX_VDO_WORK_QUEUE_NAME_LEN = TASK_COMM_LEN,
+	MAX_VDO_WORK_QUEUE_NAME_LEN = MODULE_NAME_LEN + 11,
 };
 
 struct vdo_work_queue_type {
-- 
2.31.1

