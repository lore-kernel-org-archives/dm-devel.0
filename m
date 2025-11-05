Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF423126BE
	for <dm-devel@lists.linux.dev>; Wed,  5 Nov 2025 12:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762344181; cv=fail; b=QhHLkQw4WoumY4dIU6/g39pnyMaBiOZIamDkfyPbfnd0mYdsnhpLcU7ORXFBRPdnCtHEdX4Z7bKj8a0MAnVLGW2WUSRIRhlPVwA8X5bH3HonMph7S3Sxi+i9mGVMlxLOsg3E2UX4cvon185ft06mngTrHJ8Fz2XpdoN1N7vQ3Fc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762344181; c=relaxed/simple;
	bh=8LKD64Xibi1GXkfYV/WreoKJr3mSM7fL7cazd6J7tEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CnnHW/br0sanZaAITgKTvVCsfvMZbN8ydzmpzHBHhUMhGxOk4YoRmYpHq3d6YY8PNNU4gPzVn0rLsdy9iRnvWvzF4sAtUqveOp9VGtC6FyAd4IT7U9jhX0wCkur1awoLGo6o8h1QPqjee68Km+oRGW2MhW679Em2XiCHPYnuPxk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OfLOX3yS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HvHiPy6B; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OfLOX3yS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HvHiPy6B"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A5Boht0027869;
	Wed, 5 Nov 2025 12:02:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yMnieQEOlXH0wi4H4Ef5wvOSDoa3ApFS6TlEvtagfDc=; b=
	OfLOX3ySiZg99WtTbGtACg1h4j6ABRNa3WVmHfb4Kelxvq2q4jxLnNeVcJadHXdW
	j37Af4hFR2EaiW16S2lHgRIH5GfYAn/Oe1o3felfeBjBBCgCLj/00C3F7HxBAIwl
	n6tIEeoEaenOZXGf47sdk/f31oPHAnTOFKRtDtfoPYMc7KOJFdNQSPNvH7oZi9R3
	zp8ktmnrEvMCLNiPicu31Zy2Qo3nYQ88QtLG+JLXphUSqBJ3cSPj5S1irjWMf5bP
	peTkRZh7JdEytGcVwQx7IAGhLASB48Lbm7AiFfTxYILo/geiDzhwEyngpcF8hcol
	jfKpgeaLa8aXc0j9dY70Kw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a861x80kn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 12:02:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A5B3nLp007224;
	Wed, 5 Nov 2025 12:02:56 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012013.outbound.protection.outlook.com [40.93.195.13])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58namyg7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 12:02:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ICDhYJx4cp60nK09zqOrOjnM4k3ylz2VxcFHUHPZRde6/gyp9gqNpxpwBmza+3cSEukXMOzVnWMZ3SqHzWbPOMqGuZTyAum0+6nPbLWPGsTnCNN4i1nDMiz4M4ZwfM+NkiDQNJBcETqv8iXyKeI8IrTX5dodc9dqXCzCaeZWrnM4GTkgW36KlxKBVgn+Wt1WfNfGbxqb9AeqbunT8enwIjTbDCbXwW9v9OI94ozsq6x5l1YfVkT+mzkQpKkFRSGjan4yWJ9PwU2Z7QBTTYMJagOcwHVWyFm5pwrBXBGwMKsurrx9FoTAMJcepY1raje2pEKu57MzpWIXZ9UwksqI0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yMnieQEOlXH0wi4H4Ef5wvOSDoa3ApFS6TlEvtagfDc=;
 b=rGZMSzaOo97j5X5aqZBUjbdvhAoGL8RjhRNU9Yk1GU8m/qDP5eYQr/wwKlSW7oeyIok9dcas+hlgAxUCa8VAmMdSAVyuLmcBjbbEvMQ5xT9eu5bmujVjtaCKjbs3PkhzKm6sMlaOYA+c0LGgAETi7g5WcC5RdDusUW6XOgqLluDto9Y25q18woy7UDSd4zcqWaIlnGepciBfVXMXuIjzvmcHu+WJe30plJWpxnNfjtRqb5YSSjXEiG4wx/tZaUR6tJIyA7qlMHoSN2K9jKZuvZxK8B+hEHtZ5V0tl7Wp0mnjotNa6bz7B0OGt9Yd7EFG+SiSbBLC18JmWQHZwpNGug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yMnieQEOlXH0wi4H4Ef5wvOSDoa3ApFS6TlEvtagfDc=;
 b=HvHiPy6B6LKQ52yerNvnX6OIgLMWBU4cOipPAOPNeFByL58joJrIsvpt3apVBiMPNrJFpu3clYWAIHoV6xFUf4aAsJQ6dN3Trhw8AlQGuuQ54/Y392cVQf4BlzajXGqbjbIn2eoPAh52zVyeaN8U3TBgxmGsiVhDr55R09NNrBQ=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH3PPF476853C3F.namprd10.prod.outlook.com (2603:10b6:518:1::79b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Wed, 5 Nov
 2025 12:02:53 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.006; Wed, 5 Nov 2025
 12:02:53 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev, michael.christie@oracle.com,
        martin.petersen@oracle.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 2/2] dm-crypt: enable DM_TARGET_ATOMIC_WRITES
Date: Wed,  5 Nov 2025 12:02:44 +0000
Message-ID: <20251105120244.99752-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251105120244.99752-1-john.g.garry@oracle.com>
References: <20251105120244.99752-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::6) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH3PPF476853C3F:EE_
X-MS-Office365-Filtering-Correlation-Id: 217bbcfc-dfa9-4749-7e5e-08de1c633f98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?c//Sn1pOD8nAA75SFJGcpy+1550X4R2UkwTp2AoXC5Q0BvfCTZUhCJIS2Ily?=
 =?us-ascii?Q?ROODC9yRQ615ry9fdc46MO34Z+mABN2uFiWiLLFZTa2XeqvqJX9367hU9EaB?=
 =?us-ascii?Q?kMnQGq/i4wOsxR3ynxZGxfUFh+gcXm97XhVfenQSpXr+VxIwwYS6Ic/EkVwE?=
 =?us-ascii?Q?waBsQIGB9dwdFtGSJgUQUwbGtpP6XOOo8U4n+r6FenISywe2257k+vvRSGRO?=
 =?us-ascii?Q?5gMZvJpsSWqgv6nLG4lQ/ObYnTMoSdWcX2CPtJPvPrZRK0c9ubQQWFzlPzM+?=
 =?us-ascii?Q?E9ua2Y3KCcncCo1J9v2PdMX8zM6CBZOlNxdrV3c/Txl3W08ZeIJICNmMaLzX?=
 =?us-ascii?Q?ndr2XD7PXx0bWR4qHAiT0M+LemPh57+VuRn9sljzp0Jic3J5Qmtb6ichtUTj?=
 =?us-ascii?Q?uABT6/wrWEkOv9nk8rA1dHISxtDBLyQWweWzt5Sf+HmQi0Zp6qT2Z0NpEinH?=
 =?us-ascii?Q?v6NMHCvDJYni8Xm5+8BmlPG+7R3iCxW7iYVknfO90tGU16IkrwHnWdVVZExL?=
 =?us-ascii?Q?GEbUbStyUa597I8HkdPeuiD9DnjbMsRRJZBY12LmOSr0ZshtYDRXbru95fUb?=
 =?us-ascii?Q?sVt/9bZkcX0vEZdt5TDmam3aaayV1bAt5KjER11dVD0Pmk87p5PHXygA9x/b?=
 =?us-ascii?Q?uxdeQtkDViJ77MpLgLllFXsacL1GSCInnISxEbLdEcbAIq58+fRq4xI1PZKn?=
 =?us-ascii?Q?tQxUmYUV9nSeGnH7mdGGnV8PRVn6jmvTiycAttu7gDaLAgwOtC9lXBJcqJ0g?=
 =?us-ascii?Q?FAchu7lxrmsXbjSLJG+JAG4IL3aChCyW5siW560QqyIQ+JZzbk71J/BaoS2w?=
 =?us-ascii?Q?lw4xgRMxaqIHqvJubCZ/fXNuux80xgBTyoDmnXQsD9epL80P1RuLLzob0a9A?=
 =?us-ascii?Q?WulL67JJ/JXIksTnz4AC20QVBh0KgN0emAxRvHI0Aikbs/BpJ9HysWAY8gIY?=
 =?us-ascii?Q?dmLxcZF+p1Za2zTEIORPOXwPi04boNsr3UpnUTQmC1CfJEGlWdN7ZhMxKDtH?=
 =?us-ascii?Q?pwepucaSYZUHGOcO5PcTyqcozJ16SHrCYu3XAxndUHjuxOdxm1qCEmTuN+Fv?=
 =?us-ascii?Q?LlY2pSwsK9JKqN8FvxMt7BAu4+rFzOd9B8quj1rywgu0Ikk+7BPojWgw4sx7?=
 =?us-ascii?Q?5FMk6TN8SK12I3k4UKZvgJ17+j02PaFG+GPErCR8ru/ilm5e6E1fkLKei8DD?=
 =?us-ascii?Q?WAdv5bgvpViL58rzgnNasYNZlKKm38Wm5BOSjY/KxJTVitDbanv7+W83oVJ2?=
 =?us-ascii?Q?9p4El4iqKwsFdE6sxp1bpULiHXER/sip+a0nslTsynF1rCrDgLSy2+ADL8Kn?=
 =?us-ascii?Q?7l3lr8u0tvL9qnjbNoohy+VCBRQAO48WNVlg2mZtMcvtGq1JvloznBTf69Cb?=
 =?us-ascii?Q?Cba7Irnm7WXIJGh52XuWiWxi6eyp54YL+hVIeLTfcGogH4YpxFt+oZlwox2G?=
 =?us-ascii?Q?HAQXC6Dosi8ASmr6pwZHTWW7kOWavs9/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PbsWgwj4iQUz8X3SeEkSw6K+5zBXz+iosjtNNTdSpNVGGJrkWy+P4YD0zh0p?=
 =?us-ascii?Q?F0Ji+S7wSb5yxNYeFScxbLLC860eaeyZ9Ue017xySMSxziZZgdRaeNimuoK+?=
 =?us-ascii?Q?rZhCGc3DEcjfo9XZmlCSI64w3jgRFpP8xNMvUFGGWdB5QYKtzCqH0ni2VrXz?=
 =?us-ascii?Q?2jzgtpB0oUPEVZblP3GDGJxgxqsRPtBOFri+abP8La4osIGW2mBPeFp9mmnJ?=
 =?us-ascii?Q?TUhQe/AMifZpN3YOYkkIltWWlwLzl+uWW4L5MnaP4vXmIVJ0CqswEPPIBhzi?=
 =?us-ascii?Q?cTq2MSTav9qFeWoRAlnkFyJ67ImrH+KxSCFG+mBQ2PL8OjgZuwA01FULNYIo?=
 =?us-ascii?Q?zqXbcDAKX3F1lLnuASBToAmWwbbQupETo+JGpTfaDtakQ3FhzQE1g3YCLijk?=
 =?us-ascii?Q?WdK/87niRxJJxxL7+S4bjlhDTs5VjJarjm6paJt5kIRCpa2OgQeqrIkJMrK+?=
 =?us-ascii?Q?M0tFtaU9UowMn+jWN9OexHISbf9ZS0iFgZBZAFhXZDKyh6o5xrIS7JNaWthO?=
 =?us-ascii?Q?p+5+6Y/g1xlDM5ObK6MESaK4HmqBmgIq226kXBdMLypn7v9HmJfc41LPSqXw?=
 =?us-ascii?Q?utATDUqKTKSAMzFTXM6LgFHLQsNhFLzSyygjzKrM1G7gA3T434NXKvq3INHJ?=
 =?us-ascii?Q?hm8dMNK06iQ/ozYxIpBgwt6MsrzjfyJPNFrKABzxOKZrZbgT9V9qdT9md9nv?=
 =?us-ascii?Q?PVyZVhwFOIbO9+IGLSkmdhTrJQ6YqTPwSjcGO8pyom8pTcv2MuTz2l2i3wUb?=
 =?us-ascii?Q?D36hyFZovSHvwjPja9xqMlRhvdanzL0Bks0hUGvSuZ6/uCXiSj321djxnl5C?=
 =?us-ascii?Q?77yk3ptg+Htbe61W1GhiRe2dnmm3p4Pzn3r2kfz/se0sJfqK3Hx1/bn2MgT4?=
 =?us-ascii?Q?De9oufFqRz2ilN4ishV2wwE6EDV7WRkZaAfR6SoOTsWOlzAVBroKRt1Brjrc?=
 =?us-ascii?Q?qj1XCCMxDi34/Fr2sPu3Vah+cjyxJMJI0pnb8MaD7vUPYLK61fPwzM7UbPgg?=
 =?us-ascii?Q?+F71XyLuommdzhfbSZzPz2I18QiWRdtF/ywVFnt+CG3sJkReLfcmQmZDsAKq?=
 =?us-ascii?Q?n/MtiLOH2ea51D1EXAaLjBz1faEVUEVVEPj1jNQRaJpmwRI+zBZ+Yk10viYW?=
 =?us-ascii?Q?v0vOuDcZjfXHPrxf/QTDR7bkiDoIvJpFu7QopL2ljDcPvESG3HSBrssIdYab?=
 =?us-ascii?Q?eZbuZx6FoTw1PPJMIUXfD1hOS7IoBqmJteNSNT4SnOv7s5far3Bx2P3jLVLw?=
 =?us-ascii?Q?SMPiFscWDh8vYyyCwe1p+1gar978WBK/JNP+sXfIfF8HOPNKCBjxAYheXt6r?=
 =?us-ascii?Q?flGttTm3VLcm8FTqnSs7HMjl1ambhLZJPtdQCcfFMkhB9u8RT7gOdEwqcEVL?=
 =?us-ascii?Q?ZyZ2VSEdqwVeuxVlJS3UwzsihqUNLO8pR93u7Iyx/QkyJe503RVb0pD9K9QK?=
 =?us-ascii?Q?SkLVonEWKxwto/B4bHtLsthr2oyJzshP4H+IGFSHDNYT+RzO+nlrKolZ5ZEl?=
 =?us-ascii?Q?/1y4Ltvjmt5XbB2w4sSFDu5mMwM8WM+M0JwXYyoE5sIuSg9KAhTh2DYtCQTz?=
 =?us-ascii?Q?RSYOeuzvljDxZuavNyzRh4UPW0luJBomfg3PW0LRQhzVFb8+4RhPiNwHYVv+?=
 =?us-ascii?Q?iQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mfUSnE+0aPsNpdGraz1KdfjRSl5ItURvpnxXda2maFEeCtrmz5g1YYmgtCmH6rQIikZGZ6kLOH3W8aKBRhcIYPDLVFSH0spdZ0xfYItiYtIr0TdGcWjCu+lgLWaQAs5+rlpQR4Q5kS3ci4zZ7matKqFLHJ1aMxFNLfjjVZFmqe6i3JLgSRgE/HCoyT7no9IUVqaLd9kDXOvaCyi8yQTDi6L+wr/XIRuZM6RCDcX9795N2zWw1sC0nJjfIRNspz8UPsQGxXHPGIOeNrGY2egRbMuvtWxYuPlUoSNpxp6GWT334yb16Z4nYvN2JKyP6auoWWoJObYoGZm1NdQX3qYzkLL8ax/mltoMbqTdLQbtgT7zaCRcWNOagl2Ua6j6pBIh78ZZDxTI4eO0uiMPEhozmf2MKHTxlCFR6Zn87CltcP1rgKJneoR+gOWDo+h3MPOq7pGXoVCe2MnC/Vo1chtqocLnnGJVWPM0DAZpF6QZb37gfR9/QMb6PeOtpJYwYFh1c/wtP90awtpe6x4evgCZS4cTuvtgP0QQU+6eCT8djAhJcx/N2mjU9JPJTjZvoz/m9Kj+CIMISGAw6C8Eqyi2Is/mg2H4kdk0/k9ZNRAKdls=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 217bbcfc-dfa9-4749-7e5e-08de1c633f98
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 12:02:53.5582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JkBSSjR9w0e0mbpzB7ShXjfTZU8ipI/ee4uHHCpMRczTHYrttE2BrNUDlhoX2LGoC3tSSoCh47asbPhaWILkUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF476853C3F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-05_04,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511050089
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDA4OCBTYWx0ZWRfXxdbTSf7uWIMt
 IKk9iIUXCXeakSm0RI1XrbBq3cSk8Ir8fAw/hCLlB82WnZaeZG2OapWOY8e0P/k+flIiPEYwAwS
 7yPUicn/TJSO7d2G31WzeobZ/QLgd3yyn5D8sWg+kA8tABJXq0Mqv5kygZBvQSl+FQ1xwYvNTmc
 JKMSl/X0F3Hx1kb3PIarKu3+jyHNzcvGLcLE1frR29xcGbnAahyHocQuzAUmBPRt4/iKa8nSKPX
 jtR1MIjuXmtAfdTo/09UBLCdF1Fc7+yWqwlCFCL8UE4U9cvggb4R+re+LHsvUBrWkVXEt/wn9NB
 dQtn1qakgP6M5eBl9okyHNJhjAasBTuGqZnlcv6fQ50GTK/G66T6FOzjhFPdWixYuDV7QXQmze4
 zRciGnSqUsJ31K3hqo7yjZ5bfil5jQ==
X-Proofpoint-GUID: OQjDuxopv7I8YNB33767NKcdpmyfRNWk
X-Authority-Analysis: v=2.4 cv=VO3QXtPX c=1 sm=1 tr=0 ts=690b3cf0 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=2ZwYEh2GkgH6j_ZU5asA:9
X-Proofpoint-ORIG-GUID: OQjDuxopv7I8YNB33767NKcdpmyfRNWk

Allow handling of bios with REQ_ATOMIC flag set.

In crypt_io_hints(), the max atomic write sizes needs to be limited
according to the max of DM_CRYPT_DEFAULT_MAX_WRITE_SIZE and max_write_size.
Otherwise, we may need to split bios in crypt_map() ->
dm_accept_partial_bio().

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/dm-crypt.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 5ef43231fe77f..c4c97f57bc477 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3515,8 +3515,11 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
 	 * Check if bio is too large, split as needed.
 	 */
 	max_sectors = get_max_request_sectors(ti, bio);
-	if (unlikely(bio_sectors(bio) > max_sectors))
+	if (unlikely(bio_sectors(bio) > max_sectors)) {
+		if (bio->bi_opf & REQ_ATOMIC)
+			return DM_MAPIO_KILL;
 		dm_accept_partial_bio(bio, max_sectors);
+	}
 
 	/*
 	 * Ensure that bio is a multiple of internal sector encryption size
@@ -3744,6 +3747,8 @@ static int crypt_iterate_devices(struct dm_target *ti,
 static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
 {
 	struct crypt_config *cc = ti->private;
+	unsigned int _max_write_size =
+		min_not_zero(max_write_size, DM_CRYPT_DEFAULT_MAX_WRITE_SIZE);
 
 	limits->logical_block_size =
 		max_t(unsigned int, limits->logical_block_size, cc->sector_size);
@@ -3762,6 +3767,18 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	if (ti->emulate_zone_append)
 		limits->max_hw_sectors = min(limits->max_hw_sectors,
 					     BIO_MAX_VECS << PAGE_SECTORS_SHIFT);
+
+	if (_max_write_size < limits->atomic_write_hw_unit_min) {
+		limits->atomic_write_hw_unit_min = 0;
+		limits->atomic_write_hw_unit_max = 0;
+		limits->atomic_write_hw_max = 0;
+		limits->atomic_write_hw_boundary = 0;
+	} else {
+		limits->atomic_write_hw_unit_max =
+			min(limits->atomic_write_hw_unit_max, _max_write_size);
+		limits->atomic_write_hw_max =
+			min(limits->atomic_write_hw_max, _max_write_size);
+	}
 }
 
 static struct target_type crypt_target = {
@@ -3770,7 +3787,7 @@ static struct target_type crypt_target = {
 	.module = THIS_MODULE,
 	.ctr    = crypt_ctr,
 	.dtr    = crypt_dtr,
-	.features = DM_TARGET_ZONED_HM,
+	.features = DM_TARGET_ZONED_HM | DM_TARGET_ATOMIC_WRITES,
 	.report_zones = crypt_report_zones,
 	.map    = crypt_map,
 	.status = crypt_status,
-- 
2.43.5

