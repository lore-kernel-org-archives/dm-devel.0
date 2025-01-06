Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FC41D88AC
	for <dm-devel@lists.linux.dev>; Mon,  6 Jan 2025 12:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736167311; cv=fail; b=RFyREN/idH0medG6ZnQuYvMXrbk2JomMmCU5LMbGt2/Wl6qr07737+sRDSURrGp8iL0MHMkkhdLLLnYb1FFC2cSVLepwWdOweq5QdlACxl/aXnVRMySRe4mX93MllSsgcptjGAeH9fDt3b5KEL9TaHSghCTSJJLt9htXKf6wjVQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736167311; c=relaxed/simple;
	bh=kpm+0yaneby7Pkvj8vISBjN6zDTcCMmEKKQW0LjMunU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I/nXfVzERWHJAS5Hra/deZDri+lDJJSy0eVAyJ44XEePD+6Fd05gACSaJnzofGY5oM8QinOerqCn08G7a8NPJ+A7m2NgrCuhNUgw6/YmFPUsfJzI/BNXOqFfHIBYvKnICF6kMqnyYVgCXOAeaBdcKQTVkdR9BepQJgNB/3azANA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nhKmGCnO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QaipT5RI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nhKmGCnO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QaipT5RI"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5068u0kq014773;
	Mon, 6 Jan 2025 12:41:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=n96Tr9jpEclkwh1xhflTCQcfa6XoDMbR0CkzKsum5c4=; b=
	nhKmGCnOgCm/4AH5CbCWYdi99X0G4oLGOdMcAOsGr+KfpJJreW76AjTki853dMQM
	33XyJm9fZGR5xaaNhqMj3ddH22zr0Ji6aDcY/tTfFyeEeCqwhB567LD99NefCKpM
	BONIzTTJBpeMRdP2BMgdee4Z7euxx0hKWCpabUjcDhYBsx47ESvyKwEa3eZ5k8zT
	9Q7yYnjU+luYlbq1fyl33DFDBc66qua2rch6n/E0GcA7iAanJ/6KlEG4LudjIYW3
	PIkNNM+gEvBk7a/axKdw6FLOmjvrrsU23dAuezLR/OcHrAqCJMVOLSZxHxzKVSRW
	8KeE3+oLOtKT5AbTCRWzGw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xwhsj7au-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jan 2025 12:41:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 506C7JbQ022649;
	Mon, 6 Jan 2025 12:41:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xue77s42-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jan 2025 12:41:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tfvUGvInLKPRrSoihgVmcq0xvEDKGq9mAkpRwqXQnMhbhYlIARXY26TkV3R3DFqscwlxVHN8vB0yugW6PcUHC83E7rhYrdMVwH+UhyqWudgZm454JUMrlWicM0QQye5HlvzsGjZJrwzNuBjM4ZcZw6Rf92wF2H3hIBIxiLM+u/CeigSAuiKMScaTIQfPT4slyDFb0fklB8i+GB4Scj117uNIzKyum/DJstlEZXm0qBnDmWUgB92KYS6CubJhzt/qJEhjpyZZEORFL4CQ8uyW/HdojOi6UUfCQYswvVhKrfpQkjnaCDnFmLjkunOHbapZLHiCAV+p4xQlf0AU/ZbH0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n96Tr9jpEclkwh1xhflTCQcfa6XoDMbR0CkzKsum5c4=;
 b=D2V+CcAKc/q4o7/Zt8y6TjPoJEV51fc7KjtWo8BNvw9oVS+kHdU7/CGHAgAWoW4mFsF4+w57n0lKpqPBWJ5IX7MNqRpr+GSVHS//YJENdYYevslhkmyTEUHUmqFcysLDf4ygd+CnBNbR/PFoyXNlq349WSgpi7Ze0y8jgKOVWo4C4+LBMTepRsMkHTPWf/Eq2MSMh2yBlt+4gGVbcVUGQTI2jtZwINuvlgUDgIP5RSCWurnRrPDJvVKfx1GJhHiA3IHfLqMW9J5YLYurV84WrX40+XDxUY3Vtyu7ok89GtLhE1WxL5a8mJrz+20mZweioaGakhygE0yaAh0MlOJ6hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n96Tr9jpEclkwh1xhflTCQcfa6XoDMbR0CkzKsum5c4=;
 b=QaipT5RIx/3VXxH21lau36wKWJTnPuQIpo/VYZqTrkCyCK7AFysaG19mJosei28JkUA6QrhL95HsSi3RWSNfcPK7VI8lMGZKZ5+FqMvhzrmckmyvDPXqB/+Nq3GcnAEUm+T94s+6GOeDU+wzR5+XDRv3Xprqk1ktF63RU6jystU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA1PR10MB7662.namprd10.prod.outlook.com (2603:10b6:806:386::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 12:41:36 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8314.012; Mon, 6 Jan 2025
 12:41:35 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, hch@lst.de
Cc: mpatocka@redhat.com, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 1/5] block: Ensure start sector is aligned for stacking atomic writes
Date: Mon,  6 Jan 2025 12:41:15 +0000
Message-Id: <20250106124119.1318428-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250106124119.1318428-1-john.g.garry@oracle.com>
References: <20250106124119.1318428-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9P223CA0007.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA1PR10MB7662:EE_
X-MS-Office365-Filtering-Correlation-Id: a0df74a9-1ba8-4a37-c3cf-08dd2e4f7506
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yiN400dj515WNVHJEukZRlXnqCU9JWD3e0dmlJeULNCY1cOSEQU4PeXDPUMZ?=
 =?us-ascii?Q?NQ491lTlww4QXsrPNQq5RXBIevEiWQRxFQAFlmNd8aY8gKDhsUQOb1T9el1w?=
 =?us-ascii?Q?JW+KAV3t45SKgP1pr8Gmb7F+k7Ztf9GUOLn79XKm8fvB8e1r6bp9qUMnI4ST?=
 =?us-ascii?Q?jJNv9dncskKOBn05bTuQZ6SFvcUYnCoIyGQ4ItP1z1oIxdMkRd3cFCWqBRwp?=
 =?us-ascii?Q?fLz8CMu24xLBfuwhXbCdDQ9NlQK1Lb5j+gRrEgQd33hQrljyjx3CTpwk2dTn?=
 =?us-ascii?Q?GxbMcwnvbpfGd51mU6FM9QN9lP421PxUeWJkTxMVVmyUIqj5NCCEvgI57NIc?=
 =?us-ascii?Q?C0WOFn56yNCiE3hjCGCjpzjyB3BAobC/g8oG460HtK3o7UdnLGV8qqzxHAbY?=
 =?us-ascii?Q?NQmU7HZWsZsJK3RU+i+75j3FbJ6OoJRHYZAyh1kOGLaxrRuIgIoSgP4no72F?=
 =?us-ascii?Q?nNyQG3NUrPPCxqhZ2IWu3vCW9DKryE1rcwxVHv9gvrppZlD7b8RokvQqV/EI?=
 =?us-ascii?Q?WqgbRceB5KWC4LAwQHwEPU3qQLE8m/34/VrLCPt+3rwsOODND+LO8zHgtX5V?=
 =?us-ascii?Q?iy2GMrbezHinzLKPr7OMdEvcrH0xDPukRR9wTLRNu5REFJ+CsfJf/w1o7NuG?=
 =?us-ascii?Q?89XHDn3a4JyGjiKipptacTkYO9h0RXpQWLtpWFDrCrV0LjEJrw8NuM09P26V?=
 =?us-ascii?Q?23rB8y9mxvTL0gEcJISZIR+h216MHT4yr4sF2Go9MJTAsFZLoUyLvAXzXcrk?=
 =?us-ascii?Q?H61ZrfPXGbla5kNqEq2FXEykKn5ZAMZEIpFH9lNp0UKK995a/97xJUHf3pxl?=
 =?us-ascii?Q?QEB6eDaf50eFXPUBXHJ0M2Y6lJ83MC9D+hAQdxyKsJFmQLtRI461H+cqJKyv?=
 =?us-ascii?Q?R7ivsbbW0ouzGYdDXzcODTdxBe5PQ17cJxnFCpAoPkDggjmEBmVH0TfFnade?=
 =?us-ascii?Q?/iFwslgiEGjA5pAu75z8W3LbynIBXmWUSxgylhF8U0xfVaqCL/XUTDOogH0N?=
 =?us-ascii?Q?QJ76r8fLH95CCG68PkMGdNU7plIykRraUbOvnMkCZ3IVjk53Q3cH1ZHmo/6b?=
 =?us-ascii?Q?a8IyZ79T6pDFqEm/cZTR/7t1YFqcsv5MA/AnydEfoqbJHcvOjUOcG0wEXMIc?=
 =?us-ascii?Q?MW+IxGJadyffecoA04ncR3OJCZ25NKDieul5vfeqD/MfP4xs0enezXfQAIeA?=
 =?us-ascii?Q?ISF30LZ/0XtIeVltQQp2iwktY+j80Mc5Fh7I+zO4qpX7o/16bBvYrvDeKZP+?=
 =?us-ascii?Q?D9Loyk77MkxnU5Z5Sk56D1JfgYC3ZhBSj6y1raelrpWH+lSdtYb/vberhnTS?=
 =?us-ascii?Q?pCcBWRD8WCeS3X9iaSBM4VhHBMVaJnmcSNZP137qPZ/T3J4HN0iqJN1xnrxq?=
 =?us-ascii?Q?nBnWAlrJybvcsQHyIfZc23MKKqwR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JAadAYX6ZzrT47w1ZFhSMEC6UupD/HVreHTmGZnQaaIrVi44p8O3O6HNJQ8X?=
 =?us-ascii?Q?3GVkrGAgrwDX95ip6GzfKBcVqajo5myuB4r0tctDPC3rmptDJmukbbtrSMB0?=
 =?us-ascii?Q?U8qLSqs+Uqo3j4Ciud5dJ8PXZXlmygOhcB5Wo233khzlS3P2O02JfvJP5bT5?=
 =?us-ascii?Q?aqIPOa4qdLeKMSay64c5K0qQRDHvei9vCeYypeCVNAWzc4lj0IWYioCazih4?=
 =?us-ascii?Q?hzczIiOECFlUY7QXA+KfahNf7CNcwKLJ5ZZf4uuWiajNc8bIY8o7EEG5Ayxm?=
 =?us-ascii?Q?k2WrSsSX9YijG8Krq6j9PWg32ZFg4FCg0ESJuwpxRFn6ElGFzIs92KaB1xmM?=
 =?us-ascii?Q?5LvpJcicMGBLLyvibTR4W2kGFHFZmyWKXPdGJrRg7hDx913qTTd5xejQIcaS?=
 =?us-ascii?Q?YD+Tjv8eHhxIiXNfEHBakdR7OFdkl6MjnijU1VFkOwVOlXA+ic/AUkld7Nkg?=
 =?us-ascii?Q?SCU0T55DXM/R6LZJzGtEqUx4xdXDu/acpRVVsyZd7i9ZG5y/1XOR0L662OJe?=
 =?us-ascii?Q?0QOTUZdSn3xQ619g4EL+Q+XGfwu9UDacahkDmLfLRB8uWgomjAD7ysvE4mhS?=
 =?us-ascii?Q?k106xZDKrkGaY9xcIzcJUngSO8Bp6USCRBrdox77PejAKcxmoOVIUekyW395?=
 =?us-ascii?Q?225AkGUd2SZx4Vy1Q+s7Ku/2JIZPzWoXhBm6gKjlbSuWPue+DPPKviAgMb4q?=
 =?us-ascii?Q?KoSnlqYq0lbv1woeT5JsdpIKyTDV9piWHSZGoDGIgjaRy53yN7tt+RV19V4s?=
 =?us-ascii?Q?zTL027ikh6InuB5sBJw3u2PxCudYk6q6x39TXF6EOiwib1clEO4dWpeiSU3H?=
 =?us-ascii?Q?BcrpcfdP6Ex/qnL137oSPR8w5JJNqJ6YeffQ3kG6iFb0OEuLFbkW4gHwqGWe?=
 =?us-ascii?Q?JPOL7jDpmWmYbIvWoPwCYTPOHrv8EErHQ9QlbuW2+yXxl6pgGA/DzapO4ZUK?=
 =?us-ascii?Q?jktmiQwv1ZUMoOzd7aVvpnqjvWwZfgJ9SKne85WWvlqYF6Sm1FPpMVBpECyc?=
 =?us-ascii?Q?NEJfeHq2lHDLWsWctFDEjg6i9HZ0jna3XOgT6zH1dC0oQ0oKcEcok7DI5SXB?=
 =?us-ascii?Q?8H/HEU/JnKgHTT9Jb2IPlJHghZ7SkY2RD5yDypBanXt+nC1Y+YVV3EWwzXKj?=
 =?us-ascii?Q?msnOkFaveonKlTcoJnKOUxbSIlQ+aaOD5/sRNLQ6OiBY96NgcyMiD3HjqNJ7?=
 =?us-ascii?Q?o0b4oGOUWezFfROdr+KTfs5RZu/FdHLg9KUsXW9CZiCrrcFkLVR15+zsW3E2?=
 =?us-ascii?Q?x1nRi1r4zVuRh1WwpqbCxgUoWfSPXsvlTnP4zxz7K1sYyMNJOywuaw7LZ8tM?=
 =?us-ascii?Q?EyOU0UTTz/B12xYl38JmRPzu0kZWCBHxUORH8XsOOQ8aaU/CJoumj1u1NiBC?=
 =?us-ascii?Q?QreVv2A4eV+233UxVGeOCdCbNgcQkbZ/80O7pouA1zeX+yfFP/X0QCPgEiho?=
 =?us-ascii?Q?MQ1jnJrzSAkg3P10T+AC6McQ5e2vu26hUBBkjR0inYuOcun9Ahy8kYsg7RU7?=
 =?us-ascii?Q?HSVaf4mID1QmaOUTc76yUaTYdpTO5IKmZIIQFz5/DhKUGb4unvlMZ4uiVDf9?=
 =?us-ascii?Q?eTk8214m6DFpzkwXsCWCuVSoapVOekKDr2nBAYsY+kEd42pVoWUX5Q1HX4Yk?=
 =?us-ascii?Q?zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	30y2GyOFi2NoFP3cMsUomWP8S+u9263MQZb0d6Bl8EWmQ+OKwScE+rRkhDXJbMCxvxmh/xW+oDy46jpZyB28RNlkrYe7kN8U+gaMPgBht/Z8/gpMDY+QcbuvAkEC3S5HLXNV3cL4ktZMUVZzxCY8Q/ckx31ifn2KO8KRAlL++/3u8bDQnQC9KoydkKkEyyCnPOEKHrf7qoll1JDLeOznp3MFZvcvsnkviLvbwLdUOUI0o3R7TCDjJOE6pHDhR2E3YPmGECIh0dls+MS3HqMZC4/D6RRrkZLU/lQiCNThhLzZHfFluTf+3k1UsrXjYE0/DHxZExQSKNIsinOf5pd+cdWEZzTfHyjFHIjJ6gL0RdAOjkFffR8ocnUicXG/jnvLTazv2sHyLPZDnuuvJjlSd/6TfM7xgw/bUSUflmeyTdaD6dZqF4zMcl1RKNNcJ9fCkqj3NuCIpjNaB3VbJG1HME5XdG1NDEMxUXY4nYKFJXBaBrDiMB5t92ZvuCI4/8pqA6shxL4rTI86Nm8XVZugX0TsiOq5mW8JN+ONnx3lIs9w+YGjlPoULNWZRoM8W1wOVZnTe8K1Nqc0RW0zwq8mce5T4kujCkPvmMxU1ADft44=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0df74a9-1ba8-4a37-c3cf-08dd2e4f7506
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 12:41:35.8953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Z3zlv78jmDRC0NDFpJ//ah40FAKpmTo2rEuF2qxUo/dUdbtDMMT6oSDWxUFOZK5icHdAAbpzg/FcInsiGMFpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7662
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-06_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501060112
X-Proofpoint-GUID: Je7NmrqyRS2TDeMnpMtUrUwD27Dmm-gB
X-Proofpoint-ORIG-GUID: Je7NmrqyRS2TDeMnpMtUrUwD27Dmm-gB

For stacking atomic writes, ensure that the start sector is aligned with
the device atomic write unit min and any boundary. Otherwise, we may
permit misaligned atomic writes.

Rework bdev_can_atomic_write() into a common helper to resuse the
alignment check. There also use atomic_write_hw_unit_min, which is more
proper (than atomic_write_unit_min).

Fixes: d7f36dc446e89 ("block: Support atomic writes limits for stacked devices")
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-settings.c   |  7 +++++--
 include/linux/blkdev.h | 21 ++++++++++++---------
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 8f09e33f41f6..a8dd5c097b8a 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -584,7 +584,7 @@ static bool blk_stack_atomic_writes_head(struct queue_limits *t,
 }
 
 static void blk_stack_atomic_writes_limits(struct queue_limits *t,
-				struct queue_limits *b)
+				struct queue_limits *b, sector_t start)
 {
 	if (!(t->features & BLK_FEAT_ATOMIC_WRITES_STACKED))
 		goto unsupported;
@@ -592,6 +592,9 @@ static void blk_stack_atomic_writes_limits(struct queue_limits *t,
 	if (!b->atomic_write_unit_min)
 		goto unsupported;
 
+	if (!blk_atomic_write_start_sect_aligned(start, b))
+		goto unsupported;
+
 	/*
 	 * If atomic_write_hw_max is set, we have already stacked 1x bottom
 	 * device, so check for compliance.
@@ -774,7 +777,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 		t->zone_write_granularity = 0;
 		t->max_zone_append_sectors = 0;
 	}
-	blk_stack_atomic_writes_limits(t, b);
+	blk_stack_atomic_writes_limits(t, b, start);
 
 	return ret;
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 378d3a1a22fc..b9776d469781 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1699,6 +1699,15 @@ struct io_comp_batch {
 	void (*complete)(struct io_comp_batch *);
 };
 
+static inline bool blk_atomic_write_start_sect_aligned(sector_t sector,
+						struct queue_limits *limits)
+{
+	unsigned int alignment = max(limits->atomic_write_hw_unit_min,
+				limits->atomic_write_hw_boundary);
+
+	return IS_ALIGNED(sector, alignment >> SECTOR_SHIFT);
+}
+
 static inline bool bdev_can_atomic_write(struct block_device *bdev)
 {
 	struct request_queue *bd_queue = bdev->bd_queue;
@@ -1707,15 +1716,9 @@ static inline bool bdev_can_atomic_write(struct block_device *bdev)
 	if (!limits->atomic_write_unit_min)
 		return false;
 
-	if (bdev_is_partition(bdev)) {
-		sector_t bd_start_sect = bdev->bd_start_sect;
-		unsigned int alignment =
-			max(limits->atomic_write_unit_min,
-			    limits->atomic_write_hw_boundary);
-
-		if (!IS_ALIGNED(bd_start_sect, alignment >> SECTOR_SHIFT))
-			return false;
-	}
+	if (bdev_is_partition(bdev))
+		return blk_atomic_write_start_sect_aligned(bdev->bd_start_sect,
+							limits);
 
 	return true;
 }
-- 
2.31.1

