Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867F43126A0
	for <dm-devel@lists.linux.dev>; Wed,  5 Nov 2025 12:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762344179; cv=fail; b=GbuJeTfEma2/fdgmDgjXJzLp7CFNsETvKCElpEJdkM7GTyrCxrZd9wHJLOVm4fZ3Ax8eHD5x6YnfQ/HQCoPb3O5LvSB620BZgn9CweUjSlA8O/lnk13aPdOtaNLg4Oz+TB4C24jPFbwZvre2PdnqNFlmI11tQQx5iAjbWR9Zy+8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762344179; c=relaxed/simple;
	bh=AabCiWZKIQYzFgzgjmJeIbLaUlc33BEK9Zk2rmcdlVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lT7gbemYMMSHryWOz4nNmTExF6nb1D44XGA4RokAePW7UL7o9FC1xaLv4tLqWxptRyCToSG302EcXv/2MZGoIQi5a8Z0pMAmmXob7xJ2QQ04/NqaNgNYWwyVizui3sWDBLUiCcVAUDk2t1+l5AvWzhAqjQJyzjVHzVUI784djYs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jrXEMPK1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wRIUE1p4; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jrXEMPK1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wRIUE1p4"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A59j1kg020690;
	Wed, 5 Nov 2025 12:02:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=s4NL0Ig8WNuWuZU6UMvzRUXAxcgPuwnSib8wkQpxZGo=; b=
	jrXEMPK1ZKX0Li8DPqzyAIPvcOIMR5OnBnTD3MZGmdEg2t2zcMONtgcs08pTAlRQ
	rzTL2Ulx/Cd6tFxzCBCaMr6RLCG5c0bDVcpfMhfbQCW/39W12DUFtnuBel+Nc+XK
	8HnLmVZxABRXdDsZgdGDsFVGpRfqyswDwMpRBWmqpfJFgTKaoD+4Ri0PHpRBSNX5
	mrYU0bQNFXRIqrO1+6a8IVr+pv52pE4NLlqUuz77f+zeMXzTqAzbn2Qix2MvNv6f
	XbIP9RvIsTzY8Wm00KQd5+ynoDDPpOhCL6zven25kqRucosS0gr05Rh0czYAjtfK
	XI8WT+ilAgBqsVHQSHQPmQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a847cr87m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 12:02:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A5B4HO6039163;
	Wed, 5 Nov 2025 12:02:53 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010021.outbound.protection.outlook.com [52.101.193.21])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nmpgs4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 12:02:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X6pJCDrcUuVG9p1eze4hxzGjhNzqnVHjocdatsLoDdlhmd8xsOGpEl1ogkdKofEAh1sWnA+16fyvOYl6E6oFJtLlbVUJCtr6m645JHSis+YMJm0ZC9DKdODNHYwQ3r8V3Iqy+EaK/NoKLkK9WX5fbAOM5YRsP/79bt4jKvLOGLK2XhY11UJlgOcsLPY79qLd7aKbyaVaKBrHVOKWxDMjSSsg+yNmIrD1FBqx4Esq6C6L8jcLmCIFruAMP6gAoEwTN5k2yL9QBS1+Mm/nPk40FgrdqyCLMtNlY61rUwA0pKmWtdM5g+AuN6zdp2aagMOP9OYss0gHYmU6qWKmjsaxZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s4NL0Ig8WNuWuZU6UMvzRUXAxcgPuwnSib8wkQpxZGo=;
 b=hyoHMLiWAgEfmvy+M6UEydW65DgDnB3vIrsSZjZKlTaWB7BqRm25Or51L9qEsO8LcxVgM9WDSyXKO24JL+HnU9avKMbnAvQlzSLRJH7tBq2Eo2g3+VsKA8+sgq+bQdyxKNKThROF5CVNSa50jMs8QnlA6gAhUN7zN452oquEFzalNywOj//csdPzGvFgypZHCVWlWLo2a0aJrvWRb3EU8YUk06H+KHBVO/1r755JJRVIGoW9plaqom7q27yWtvyjtuVm8w6UnKfV31BoU4HBdU8TODJ5znl8v5jIsyVe71bqZiavbtSqWU9JF+ckXlYoJcI+qwOe80UgyFj7JZYGPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s4NL0Ig8WNuWuZU6UMvzRUXAxcgPuwnSib8wkQpxZGo=;
 b=wRIUE1p4W3gKKl5Kpyw1VxLBaP2SlOycwRvVcZSNdcmNJb7gGr6i2EmuZ/Rf/lIcpdEd1Ydy1LocjiSpqjjagHNHFkjcHx5TGL1XXCa0xCfFPsVPtV5fB3TSZfBCalCPGvxEuUJ3ef6b2obWLNvqVcAwCgVleSagYhVSTSIjJy8=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH3PPF476853C3F.namprd10.prod.outlook.com (2603:10b6:518:1::79b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Wed, 5 Nov
 2025 12:02:50 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.006; Wed, 5 Nov 2025
 12:02:50 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev, michael.christie@oracle.com,
        martin.petersen@oracle.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 1/2] dm: BUG on REQ_ATOMIC in dm_accept_partial_bio()
Date: Wed,  5 Nov 2025 12:02:43 +0000
Message-ID: <20251105120244.99752-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251105120244.99752-1-john.g.garry@oracle.com>
References: <20251105120244.99752-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH5P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:34a::16) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH3PPF476853C3F:EE_
X-MS-Office365-Filtering-Correlation-Id: e3d0ae53-4724-447a-4bd5-08de1c633e37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?R0B3JGZkby6LnY0zruYeEho5vN3AfoJZQcPC731s7PiVLLMqDxRMf5Ig/IFZ?=
 =?us-ascii?Q?27k13YK0K5cs9g/vQR0Kbym7tnG1YtiOTTL+2SnLs+1Htlj1bfyuu+JPG8gS?=
 =?us-ascii?Q?7kHUqxyUPJyuQbAKI91YP4qYEXUQrHyA6M9bdXQcYeJOVWzxtw1wB6BAG5/Y?=
 =?us-ascii?Q?QrikxwKaufEbDf7Sqn5fJxtG/jiBqo8EFCVEY/Q7kz932GmRwE8gSdkwOglX?=
 =?us-ascii?Q?EBxoc5Hi8TxnSBGGIFkvBEAbIvuxTdIwLF8/1lcoGw/oqTxROV9Dpbm3m/8b?=
 =?us-ascii?Q?mVNw4zQ+J1RHecdNXZzjtdsA2xKB7PKBOSu5AazreV0dXjKGYGODlCZ9Q3l3?=
 =?us-ascii?Q?er8Xy6wMGtZEMeJNGpRpD/bobE2BF1bHWukXsHzBfhXJS4rR8S4WSok9d6hV?=
 =?us-ascii?Q?O/uVG/b7yZOGsZYU0Zj0RaTBrFdwyfygWz0g4KJuDGisCva9nzcZ6OsfiTOj?=
 =?us-ascii?Q?iRj/H/wic0EEGN8MHLlq477LMxJYEYHJMQV+Z71M0AOU87KLmpw9+gAROfEi?=
 =?us-ascii?Q?/5k21gghdlf2tT8T61znBXbJzQ8/4MhfRuA8jJvcJueGLBYL/oTT+bcnWAwn?=
 =?us-ascii?Q?JTqf26G0mot2Y+qCF1tUPpNAigPMOGJLrab9vIcfKcXCq4w+tc77As0Cozci?=
 =?us-ascii?Q?jw5SNrVrjV/2gNZtwuYPaG3pV7KAD37H74PUKsP17aEuPkKdMB/8zjNf8ati?=
 =?us-ascii?Q?gZiAtBD1RMDR5gUrEEG6N3wHX7fhT/EyYl9Ka+BxXzgfVlaqrMjzwvXxK4p+?=
 =?us-ascii?Q?NargJ7DO1oE83uVQ/UcosqgNBiFRvIcM6gvDAGKrBjKSIBSPTKB0790phOml?=
 =?us-ascii?Q?pjwl2REQ/zKZhWcfERQBKJco5I9Bwut5PauSFv4Qvs6zZYe4X3IIjpg6qaXU?=
 =?us-ascii?Q?RvyrBeLyvE3OdnZsIkdtFEBZhVv7gi4sgL9Qhogc0ECD/EAehqHmDURNLHvx?=
 =?us-ascii?Q?8Y3heMZ9BFIpI+kvxOTzACNsu/D6VjZ+rsHSngckH25qFI5uBxIBatykMnfo?=
 =?us-ascii?Q?T6bPgUC7mqMbwv8dhndIiJTKphvb50PyFlDl6qiLMS7BVheYdv2eSvEuvRey?=
 =?us-ascii?Q?MPZpz7X/RINWqUzx4qKv96aw2unu4eo5d0MeOp6WBXpyE2coEFkR7um9uYu3?=
 =?us-ascii?Q?4kOIgok87SOAXcykuEOljYzqrzQq/hH7tdxCoVKG8UvkBp7b2hv64bq66/V2?=
 =?us-ascii?Q?+s2Ac5a7x2Yz27v/5GrAgeapgYQGryeyhFD6pm/Z/0AGicS9fxxHLQzBVeKL?=
 =?us-ascii?Q?GOjxJVwe4BpjoL+tmucWbRE/U3UN4ABdQvf+P6v1ekS5HGEe2qLY7vPwejin?=
 =?us-ascii?Q?KtdC2K5/TjvJTObZSK41G9f1LjdEHSE70qJtd9HPP9NaGrq5RhU52nYgHOQ/?=
 =?us-ascii?Q?FqeAUBZSQjpds/e24g2iqSIxnd84HM8las559PfaULraErDFuB4aoNI+aIlq?=
 =?us-ascii?Q?0yT/iFyQk9ZMOK0Pueik8CJvawnM625Z?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?o2P9slmuB4MNLj/4xhIFRrNrpcmbWG7RXfNceHpNrYX0lOrM9kOfrzDmR2tu?=
 =?us-ascii?Q?gwUKNnjPzzd3Vh7apWqW9MQ1kvsvD5phcriLmgxkP+0478xZYEmmCS7eUFVO?=
 =?us-ascii?Q?oXh+APxKh0nhzr3zzDEFr7Svrse+VdsU/eVLkeUHlRpDLMOb9858GF2LkiEe?=
 =?us-ascii?Q?9WcFD4R+ZFbStZQdVRZ8Cit1N2odu9Af8JsU/qfFQRFsXFyzJrCfwhJXqDJ+?=
 =?us-ascii?Q?YHkzCgeqMA8xKCTMsjx1HbB2GsRaMNmKgmEaATxDsaavgjc4kNsxbRdmAaIt?=
 =?us-ascii?Q?Ti3jJCVc150VZGbk8cH0F0zRD7QQpK3lTx6Ng0BnL0G67rAXd0g42/4aVocE?=
 =?us-ascii?Q?2ImIqR+/GrWYkSA/7glb5D+2fTcU48KQOeodA/Q8Feg7dvExAJXDbZdTqfYE?=
 =?us-ascii?Q?lDDIpoZjMzhCiz91z1/5z0kv/uQbvN5D45ZtwjYqZzBnVuT5imMl1gzhxcQf?=
 =?us-ascii?Q?2nJzsIE8lqxIwKBcVxEAjxKozvFt1ySodr8LqYltmYzOcukFP6AjVWfJ4LJt?=
 =?us-ascii?Q?5PubhW9xxU6S+k1dj5OyvE43a9FLJvrpISff8ZuCZbaPsrembyR+ku6mYfKb?=
 =?us-ascii?Q?PkgjAuQdOnO/eSQGF8xV+bINrvwD1JzLqt5Qb2aiCzsBW4Wqr7BdEq6eMHpD?=
 =?us-ascii?Q?b1jZ9G0rHbQshyx5pO2GAmLScNsYfiwjrKCCRGPtFH/Ny8LRgx2RjpK9BuzM?=
 =?us-ascii?Q?ssswd96InCfa/6l4GFBYH2jwwqoKoUMpUwxLU+P5o41+Hnl/SFh1p/Ji0q7b?=
 =?us-ascii?Q?no8Z53nz4mD7b5tL9UHeBJE1l8saQah0pSm9KIz12tDHc8XJstFCmhetfUVy?=
 =?us-ascii?Q?YC0patKVjR71XQG1YyI0Fnnx436emvAhC/Xt+ZioFyB4AdH7sB8iXlt1to1c?=
 =?us-ascii?Q?Q0g1c0Mgpfn6ysJZY3WDMZ61djs757sBCK9E1j8/DKMBOcFNUw5N4RBDlc3O?=
 =?us-ascii?Q?Uxm7KZx9VB24S7w1Ry/HT9PUK5QYmK7WvnDTiZFfeWlAKl9lycLUFgFe8Rqc?=
 =?us-ascii?Q?Jxi4qDDgA4XZaWfdrvL098B9W+YT9A1Y27EvkORQUv8aAtRmrn6Vys1XdbvP?=
 =?us-ascii?Q?08oupxcPxP+9wmBElL0InM4QCeRcTlTP3bi61NsTJG4Y5beeQAk/bPEKL5RV?=
 =?us-ascii?Q?PHCtDg80oHyzlXHxZcbTtN/ibN4ZXFH+gZPkHSjHu3EWw12BpW5djp8hRQ5P?=
 =?us-ascii?Q?+ef8Zqa1XsxOzDPGCDYVpEoU8WYuCEWVLEXZnDZT2TwwIPCHj0cBw3pd8le3?=
 =?us-ascii?Q?WRWdLF00Vuk4Gw34ZvWM6qkV2lV9VONK8HPhKM1vvHkDlDt4pZ1nIYG74KhM?=
 =?us-ascii?Q?7RvFWdSn6fpp3HJaGrlzp1D1OzwE+yr8DD71ahQVzQ+6bEt+HLesc90SE21P?=
 =?us-ascii?Q?tEPSPGc6MvTlnNa93BBBdrAz6nK99Jd+zuzD9zwv6pwS+wFI1Tcu+PVCP5tu?=
 =?us-ascii?Q?2gNRaFH2+zbeOE3iT/cjZTocUMDEKuitb3p94lmmxdI+aEjGUi0ruLqO9wRa?=
 =?us-ascii?Q?zrYwkyd9qTkkYzy4F0NSCBs85Pgyi9/bXJqWbiYMFEuBXrH84ZZhC5uvxb1n?=
 =?us-ascii?Q?67pyFjIb+zUNDjLmmE8AAXvaFucF8UMGM1GHyJnfrP01uqZBZFsIl5JC2jWf?=
 =?us-ascii?Q?Wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2TWNCrXsYDr3sOcVWW2ioLEVUlKTfmrqdcuYsIGDN4x8ob+ZPoU6bwz/NrM2mhD3yAq8Z9uIlmccyOvCvoeQMcRUYC5GOg/AC942Lku492CWm9SE+P5D0LSRPwsdPi7YMzxkdT3VLKbMAkzZ8+fbJ5B8bBTBqme7RwJP8eqOwNT0d5PETh1KZs1MiTWI4nG17u3gtX2Oba/BlyHU0a374f50fg2TBQBpX7IXHI7bsfcablxv+mHiPGPiRhY56FGw19E2Ku1yq8zVt16uXMgrUVENo8D9Di3TMH9sIb1I5Y8lhy7AzU8qnJaSd5z2w87svApLb6Yqzvcq5gA+DZXUTP7DWaFRoTBhPHpjzkWoLj9OMnconHNuWRwopYpNdZpfW9todu9bCN2iM+upO/nJC3Z1fJPqUjk1pgklQ8gQPxy75mGLbiGl3QiHcjH1gFh5HgOUeINEZFqwBq/zdQqvY3fmav0vPKCXpfMub6WqHGQI5/2w8P1nmhZUC36PzYl8fFa0IRavO3DjJgoqLLCmK5VnmrhpaUZzgg05r5hLPz5MOtlx7LIsO1i45wCosohdWrzj4DCj1BmrYpwyXrRs+4GsBN1XXopjUd/pepsIY9U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3d0ae53-4724-447a-4bd5-08de1c633e37
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 12:02:50.7488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BELuTtBtYLq/VIoXlO8DD3pnZIHtufm2zjYoFBLpAOw2VKkFuA0xv6O5yw7n55OFkSZpkj1dMFqiW3QkwtWLEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF476853C3F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-05_04,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511050089
X-Proofpoint-GUID: ePLVaY73CK8t-N9X66FdKhW93Rm9FXVa
X-Proofpoint-ORIG-GUID: ePLVaY73CK8t-N9X66FdKhW93Rm9FXVa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDA3MiBTYWx0ZWRfXxJega36+MIHM
 RnvKfp05bgCjEgJovowxYWEouEK+NaaeBOEB74m8S++UUAYM3qVj3TGCPMozn6gD1B+/XIQJbaR
 SLTXXnTBJbLfWm2EBYAlJlTOON2zK4RI5k4O/CIpPdtxh7NzyynpYT49z2kgmYPgNnCqvmSxZ7y
 SVOnIRsUa7J8gV9OlwdVLCl3FUuMeUlOQaT1HmsnPHsHHf3wHQocDPGsoLg6gmubcaJP4RbopjC
 DpCstMOutpZZhZuQwWTgYUhytmRLKShCOY4+u5whFyd4J++s2Obg8Scw7EIPvmjvjFb0N2cSgwQ
 gsBg2ftjuhqYoX2BHt9/Al4CyPs+dkACx12GezZkeVhxGzDV1yTKCGb98ZbfJLPX8wv/rgi+h8d
 AXUW7QzaL/tY6EVvbNUrYJcl+Luf+ero2nSMOYn0MiuKulh1zqM=
X-Authority-Analysis: v=2.4 cv=H+PWAuYi c=1 sm=1 tr=0 ts=690b3cef b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=akmeGB1JeA0V8tEv4-UA:9 cc=ntf awl=host:12124

Any bio with REQ_ATOMIC flag set should never be split or partially
completed, so BUG_ON() on this scenario in dm_accept_partial_bio() (whose
intent is to allow partial completions).

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/dm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f5e5e59b232bf..7bd020ef9db37 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1285,8 +1285,8 @@ static size_t dm_dax_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
  * A target may call dm_accept_partial_bio only from the map routine.  It is
  * allowed for all bio types except REQ_PREFLUSH, REQ_OP_ZONE_* zone management
  * operations, zone append writes (native with REQ_OP_ZONE_APPEND or emulated
- * with write BIOs flagged with BIO_EMULATES_ZONE_APPEND) and any bio serviced
- * by __send_duplicate_bios().
+ * with write BIOs flagged with BIO_EMULATES_ZONE_APPEND), any bio serviced
+ * by __send_duplicate_bios(), and REQ_ATOMIC.
  *
  * dm_accept_partial_bio informs the dm that the target only wants to process
  * additional n_sectors sectors of the bio and the rest of the data should be
@@ -1321,6 +1321,7 @@ void dm_accept_partial_bio(struct bio *bio, unsigned int n_sectors)
 	BUG_ON(dm_tio_flagged(tio, DM_TIO_IS_DUPLICATE_BIO));
 	BUG_ON(bio_sectors > *tio->len_ptr);
 	BUG_ON(n_sectors > bio_sectors);
+	BUG_ON(bio->bi_opf & REQ_ATOMIC);
 
 	if (static_branch_unlikely(&zoned_enabled) &&
 	    unlikely(bdev_is_zoned(bio->bi_bdev))) {
-- 
2.43.5

