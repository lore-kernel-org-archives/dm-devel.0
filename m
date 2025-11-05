Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DBD2FF65E
	for <dm-devel@lists.linux.dev>; Wed,  5 Nov 2025 12:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762344176; cv=fail; b=S59B7KSL9zjXQWRt7EPDDcSIjIq7YYO/fhJ+IIWntIuWo/KsPp3MkAArS1X7i34+pc+g1ob0qpXGZXqWyxr1duClmhtIaBgoGRsDyTd+Q5bw8D4bysx9yk/EH7z1tyRWuA07+FJhehMFBlDC4s3HVBHkxTrvMxfgdsZ/irhFcyU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762344176; c=relaxed/simple;
	bh=f8uY6/IZyrlaAcgNFhvVoThXEjaWJWBei9RpX2EYaNw=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=gbBTEmFDz29Qo8rhCnRC0oBmeoc/D65sBmj3dvEW8MV6sQ4vH6JTryxWtcQlhTzawwxrreZv0Ej6zKVO+UsuADPQgWG31xG4HmzVOPjI8UgXe9rSZw9sCR0XZaeswiUIHuxFAZFO4an17Fh4U4Elqn8aA+HWU7hc94vk/ydynq4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O1zyIyv9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xiR53gIU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O1zyIyv9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xiR53gIU"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A5BQSFt000394;
	Wed, 5 Nov 2025 12:02:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=XOv3lFndPqDQwD/7
	JpHt9eoba18ZZPWyteiJ+LrSTv0=; b=O1zyIyv9fiyFBVIvc5Qci9yLJ+7U+pCI
	p2YAEmlr4Tcq5uRnNE4e2MTfIC0ah7vjGLMEzId2eYzY7t5gIv5pjwLiHQVnGPUs
	I56rnPJXML2dcopKSHnBGWowjfp66EcM1zYWBQgfvlLM8dlRyrIe3mtoXxQZqgrx
	cEaO7FbY2diTwZA/S5iQQ5nDYdcNy9z+bkj0JtOarHcj411VV+Vzjg5A7Rhg4+eU
	Glb8G0PCI2JxW6v24ge79Wz/AGvB6Bh+5u3ch1gaXICHQv9WITb0CEMd30OAknWW
	KDp/dIA3P78auGXM+Y8JeBBhBaav7b98YKZb6GRYffJflX5CFQ1OlQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a85q501w2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 12:02:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A5B4Id5039360;
	Wed, 5 Nov 2025 12:02:51 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010025.outbound.protection.outlook.com [52.101.193.25])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nmpgr2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 12:02:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tr7UQvcKpXxSaxwjOkQBvDb/RWIzrMOY6joB911Fu3oOMu0GaMERw8tU1vCmWLHDaE0fqDMHT6XYmzcim+dK/kE+S3yVh7f0TOkMAey7uggxbnn66psLfHaVYLUFJRTiEcJqLFsvWKduLQcqaEYZ5EP6bTg9KaKasJz6Fxc9JYkNpi79OXKxF9OyHo7L5eVuWw5RmoSrWl5AtsjfjElXKYxkw6PeIZ1mxHmu5pyyGqif53Gw/T1AWFCrekN3E8kqHnvFkuv91DgJx6aJxlFYw7LffAqGAohrEAevq/aj6X6v/B9kHhO94O2Mni/7uKUzUlhGRlItnAPM9OXBIZQn7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XOv3lFndPqDQwD/7JpHt9eoba18ZZPWyteiJ+LrSTv0=;
 b=NiHuBflsCKYHr6mAqn1vh6i5XOAgSbJxz/v2+AQn4oRWj5kO5R+NC7IH/+rZepjMg21ZxY+IjPgsx17yVj2acxPa/pzrjJRw9ajlx7i89ILfvuL5rZzB/h74XRxIbOefrgRq2vEeRYlhwR/c7xI6FTNSxzCelvbWlDj6uc8X4WE8wdDPSbS3fSg0Ae1OAwd9Mdwe+zRg0eotBw0MAj4RuhNjCu3NiLR892j9yGqI0u+ljfdKsC2apf6N7JBFQ9Ip9CrTV6cFCydHettW1rW+8AETF7KWWKEy5g6XVEyB9coA+NVwAAP9wEuQMLgvOFGGq7giHO8chD+FSdu43wxXqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XOv3lFndPqDQwD/7JpHt9eoba18ZZPWyteiJ+LrSTv0=;
 b=xiR53gIUBVVnm2AAZQlBYC56hR2WrLN4ig4e2z8YCc7wgTM4Ltn6v0j5+vv59ihMX3olqMWD7hvIrMVRYhfwVeFu3kLm75YQFKq8/3Soe90hCvRYf9GQ7yfIv+bOmlGOx1udRGjvq21M627kTyTN9JaEcmTY+Ubb/WP07lMDMqA=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH3PPF476853C3F.namprd10.prod.outlook.com (2603:10b6:518:1::79b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Wed, 5 Nov
 2025 12:02:48 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.006; Wed, 5 Nov 2025
 12:02:48 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev, michael.christie@oracle.com,
        martin.petersen@oracle.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 0/2] dm-crypt atomic writes support
Date: Wed,  5 Nov 2025 12:02:42 +0000
Message-ID: <20251105120244.99752-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH5P220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:34a::17) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH3PPF476853C3F:EE_
X-MS-Office365-Filtering-Correlation-Id: df1cbc5e-e096-4ff1-fbaa-08de1c633c93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HDUTAkwXQEVPzGETFDfDS4l2k2CIiRsoi+UaEiNXz0s2izTHgKADrzWwUoPT?=
 =?us-ascii?Q?OV8c87YsdDpqzHwRc/F6JIOuhv9BhMWiUIc+BYlwmjYiHT+8lbq5pQyJmQNf?=
 =?us-ascii?Q?bT7+dBOcHFB8PQ0GWMGrjuaQm7yVRT4nkPudLG3H5y13MGJAydzVkrEiPxDe?=
 =?us-ascii?Q?UxZT6IOmi7peUEgCHLK9dgzdBZ8pHW+IapoqLk5elzZhtuC5UnX5HYrIxjuD?=
 =?us-ascii?Q?pLpW4vc8AePjSwF5R4X0RF6tmvOmE/7Wbkfz0hjESjsuIhzoolnicuYntUiA?=
 =?us-ascii?Q?HClfaU0Y9LJpfMYdXt5VyjAcGrxOWll9kGubIvFxPzuA/WlYJ8n+czwev+2O?=
 =?us-ascii?Q?f495bUB2FEnNfZ+UU6DyFgWAPsawZcHQLN7i1BPDHP1NECw9X/eBuqhORrki?=
 =?us-ascii?Q?osH9hPJu8ixPAqj/CLb1U7uY7XWSIcqgB3irckZHOFNCE+uHysGqGa+S1XPz?=
 =?us-ascii?Q?xW6QIY7N9GmUORezwm9yOf9uJn3InUeLCMiXdsEPkaBHpKeBeuut1jZ0jZMr?=
 =?us-ascii?Q?zeeDgInR5zDdSd6PtSq4lsFJfGvhEJ3zSJuwB1wkmeYw4ZbTGtoosVTh78ZA?=
 =?us-ascii?Q?n7x86nCbYVVOsxzO9NzbMlpPZQvtGtBnfnuPrwsKvVC0lhGCn4bTeo2ZRbHi?=
 =?us-ascii?Q?XeOqPmhPzGYcqcs4BlzEYbkr9nJOyEJEopbYEa4aH4pOmGPlucLTUzzbrnLH?=
 =?us-ascii?Q?9OCNsAtMQR8kkpKlrFlFoKBEr+AxTzKzC4XgYhJCpfKwigSgrJmRREPk8NFU?=
 =?us-ascii?Q?+L4BK/YAJwbaCVn2HwUppkh4ceIs3BYZCp8ibFGK8LmyoouiimRa8C6ZCSf9?=
 =?us-ascii?Q?L7YRHHHNwtpWIq4LdERCsMcLRp/xxIFJvPA7gj4bZYtZvwnsvZoJpgJQNDru?=
 =?us-ascii?Q?GVQfoIUOgrJ3qtFqNA5Yapgs1A2SCTZQCGq24SzizolJIwpmwt0G/QEcIg+S?=
 =?us-ascii?Q?wn8ypDGS/SEFYsSRSKJZXV/j09BkXCkrlHDaa2ckfZw1TW9QqlD+CXhr5GQo?=
 =?us-ascii?Q?z51zgAywrxYuMoDpRy8CPby183lyIdRJSeCD6VPSMcOwBGVCJyuqrZlJ/CBU?=
 =?us-ascii?Q?td9gFMQ3ZLdpgpV6xjuoArBW7anEQO32ILlYY3tZdl0SKBdalFhFE5T/GR5r?=
 =?us-ascii?Q?o23TyYwOMOfs7cmOtXvzKSrZu0EznS/j6jdAGDe4FtUrTsMAO0q0BW49EKkc?=
 =?us-ascii?Q?FpJ+NujPPxSq0+AwL0DEthRCwPKEluNTKA40XMEm70td/xgu8gCVs/ZaQ/fc?=
 =?us-ascii?Q?doFT7mHRZT64/HwHESBpEkvD8rgq6+t3i5xC2y7Ue1JAdRuisuAPUy7FU8B2?=
 =?us-ascii?Q?n8jclnootUkK9jh4nrwJCn5ogtZd/R0R8hn6MO4f+tBfFeXrCxNG8951U75z?=
 =?us-ascii?Q?zo7pHkec5CcBmaNNf7Y9uquEHVY5Q7FHUGhNlN6R9WsteQP/2zaRRxM1pmZW?=
 =?us-ascii?Q?pMnyx8EkJgcueDIsaYl4Dv4tu2zFB4hE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?P8n6mFrMny8bsToVcyjxEkV7chwCgRWJcR8SoA2TUFOjZQmAftHndulrDJU6?=
 =?us-ascii?Q?6ameXBlivws4cMvCS6MAbLEjApovJU6wTFUWP1W62YBAPXQk1qwwuF7bLsJ/?=
 =?us-ascii?Q?UqG2EFoTnbHdUsvazIln5u07Osq82eDT6jKkk7D/0nUf3ltcUl0ic2z6aAI/?=
 =?us-ascii?Q?KVE7ZGx3lghYQGZcbGigFERC4SIvzZ+L9/vClZhM/XEJBt44Nud/77PnDjai?=
 =?us-ascii?Q?KdtLRXmYGTElfPzyOQ1rDBQ9P2cAtdH479DDpxGL55Nstk7gkaWcW3rNXUhS?=
 =?us-ascii?Q?lUJEuN+OIwUUoJ/LT/JfvcJIKT7X9WoveFtXe8TjHpYNnqv1WbOsaauQDXtW?=
 =?us-ascii?Q?COVgRbgbQhKvnMp0fMYJC7xhvXUUarqIYodGMC9NAG1jr9kkMCRSbohQTcm2?=
 =?us-ascii?Q?wqI1E8qsQOaLMjUXRw11AJhEvNYtzL0uQArnPSEWK3TSYjbBOl4WeVq4mVcu?=
 =?us-ascii?Q?vZ3VOndGIEP9JO7tGl5SpJckwItfcWP59YO61KC2kk4BAFL0pDbSS7RxgtHW?=
 =?us-ascii?Q?OmBu4kTKa46olShq/2IlBpWahRjZH+vom+gAn1ZvzItz1A1rUnpeU4CD9I4T?=
 =?us-ascii?Q?IE2toiqm4Q3oJuwsOOIHHpNylArL0fGbv5T4y87mlxURIGu8U0mmUqugN1Qy?=
 =?us-ascii?Q?MX92RyYUV3rpG0d9s7Y/s4jeigFzOuYZfbWrxNRR8iOe8oCp24bK8ucJW6v9?=
 =?us-ascii?Q?cPc1EenbbdoiG4M8SRuUyXOcdt2ITrGL3zGiyI73L0RXTBlkHdT4L7PGrBmG?=
 =?us-ascii?Q?ZFLhqG4QnKQ6YFNt0scGAZf92pvYEEIE9SdkgjutnHpzi7sug7peJ+HPDYMi?=
 =?us-ascii?Q?dcY8rfcpxWXIAXjvkfEKknvf2CH12zO+btP7HzevsiL8inWnwbT05e+xK05c?=
 =?us-ascii?Q?nb5YfTlZdbrTMh9NbqtwaWrzmJn/0mi1bcZGN+hPtZbux4mGIvYpkUkRIM2+?=
 =?us-ascii?Q?OM8B1SzcPXlW2a5y5LAo1NRm92psD7iMl9fn0Sbo3/XCukf4sQuddPUz1YDT?=
 =?us-ascii?Q?bKH5BYDKDJjdYSCJGxH/SFonGa7ILsWV0vWcN9QW9i8R1IGZGiXRWQWv9ZMb?=
 =?us-ascii?Q?3NhBp3FSfiC/FO3nUbeG4uYMhwB8Mvj8aTY9oFwRehsGxMmBzZay1vSztUE6?=
 =?us-ascii?Q?4vLRJkCh2gh46+2L78RwH+Be7Paa7QT8Be+QvM+VpuOTd68QyJNwdmIbB7Ij?=
 =?us-ascii?Q?abxrLX8U5vU9pgJKkgQZZ7ETadM8UJuJK8Nyg+Qa8SvKaa/dKl1Ldw4CvTGR?=
 =?us-ascii?Q?DBrSob1/OY1/oAxqJrc049acNgrBq2QSgflgpUSr/JIS9Jw64R1OAbXyi1/I?=
 =?us-ascii?Q?yAduJjohEhZP7SFza2ZHLgpuR1fQjl6qSyibL5LFl9ApKO9s2/m+FS0zYWz8?=
 =?us-ascii?Q?pl5Hm0CNSFdsh1DclO3Q9P5MwkULHBiS4b0aHCPxMXcTIChU14K5UmWyXlN0?=
 =?us-ascii?Q?sebXJiwOajAp3sASemArV2xe4xFcBcliwJ1KUaPQMp+p/GbqyuomRDABTLGz?=
 =?us-ascii?Q?saJhLemX68rV0VQEbH5qSeIgBDWnIDhg+kcB0tvwgCB1p8cbG4ymf2x1eFVQ?=
 =?us-ascii?Q?AQ7fr/2F21AEc6itnoVpEHCtngJS6eJUZpGuW+PgURqUjsGa7dPO+OKoAa5r?=
 =?us-ascii?Q?CA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WJCybfKNsjG3MjVVo03b/mX3y++/6Uw/pCjA4f56y5BDpezu27+GmCOmzSjnadZP61BMqulrGQjef8pjwWV00cXllo+yroTT0VQ94uznsMAol3WwvFsfrLoRR5YttBlEqni7zCQAGQQISg/1LQHkti3BSgIseuOtEl0wg0CmZanuNwZhl/nOxfY9yzUPtBoUktlckx6URoV8bnS+WPudjl9caD8lE0eC1BrzDI2pWcz7HEMKvIC4AQxTP2dmUCdShCsD6i7lFDDAvUKjxT9YMG42jeriQaStApK4+uNI58kcNHHhpQk7GZe4CfnihUY4/SfYfLqkWXmGvETJRVm9OQjNMAvt1AbMQOHkaq4NQEIOdF8UoCaAWmiyCVCTBC82uRZkIgYy1CG6iG/hn4idxoa+hCp27sz0JvG0K3+qAYPk6syFtPaNw9xdnbEBC8m9QG/Z/CZ2J8nUShWMzQcvodYHHRROF6JzQuXX5lwoitqkMgAzIP8iXaZdJlV3wb6P9iHPEzANwgG2LWWeTMljDDNJTQ7FtWaAp0hvigEXLbzu/oVT9XDRAjqJM8vzaprU95oR5BTOPpXsJXwuKWHT0mCJwcqLteFVr8R8wCK42H4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df1cbc5e-e096-4ff1-fbaa-08de1c633c93
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 12:02:48.4396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aanSPIZbmuax2WAhQq25h8dURY//H8laC42kATKeRWDap3fq/Z5E7LlKnsBxLilU8W27IxMWHQTcD/d8GXJgAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF476853C3F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-05_04,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=989 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511050089
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDA4NCBTYWx0ZWRfX6uSXkV9PwQAW
 d5oewoWdWZ9m89orU5aCnbcpo4Em8ZxetHpbEDNhfcLxSwHjVzbODPJyF/Bk1CBtCVSqwtFdB+o
 Q2x2/JC34HJlmBCbtyxVVUm3GsudDsyoE6vtj8ld94CJ9+TDy4tE9jofaDt77gX6gxSOHWdpBYw
 IIW3m8BcRpBnpJ4NDvhFpapBBNHNJh60JqH5x4/KKaq4mbCbI7Q3+iDD4Qg3BlEH2zedUgHDh5X
 q7kvInYrw7l5t+3L+BnVniONW9Cbskn/guDCmcFoalW3YTN0JAMU4a9xTz2aTV7wiV+P05CRe8e
 ohhRWUuT1vSBegjkHsxog8IOoCfc85B+i34KtkvNjT6JrTCMMgD9C2KJEz5qtYh1YjpEua033Xh
 UKFhZyOiZs5euCBDmKv84LRa0jv2WYEIAZrk8k36gdFYpJSqA20=
X-Proofpoint-ORIG-GUID: 2j3Zpjy2E1TVQ6UhnNbVX4flUVXuQYJ6
X-Proofpoint-GUID: 2j3Zpjy2E1TVQ6UhnNbVX4flUVXuQYJ6
X-Authority-Analysis: v=2.4 cv=FLEWBuos c=1 sm=1 tr=0 ts=690b3cec b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=BifSmOV1l7_HZnNdCfkA:9 cc=ntf
 awl=host:12124

This small series enables atomic writes support for dm-crypt.

Apart from setting DM_TARGET_ATOMIC_WRITES flag, we need to make the
following changes:
- limit atomic write size to dm-crypt max write size
- BUG_ON() any partial completions for when REQ_ATOMIC is set

John Garry (2):
  dm: BUG on REQ_ATOMIC in dm_accept_partial_bio()
  dm-crypt: enable DM_TARGET_ATOMIC_WRITES

 drivers/md/dm-crypt.c | 21 +++++++++++++++++++--
 drivers/md/dm.c       |  5 +++--
 2 files changed, 22 insertions(+), 4 deletions(-)

-- 
2.43.5

