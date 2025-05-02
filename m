Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980B933987
	for <dm-devel@lists.linux.dev>; Fri,  2 May 2025 14:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746196801; cv=fail; b=kCrKToDBW6AM+FG5IMf9Tv+ozjF8643RDvA74P2fjd12h8AvutjDOGj8b1lfFE90SQjOWIcVMsDo6ZMV+Cg4AC4B5e+YoKliEYRcqOEGGrvLo9gVFXoyppezAq9SYeLVZc3w5IyZN6PMtZKwwooW+fW9nGLQkePHYIb4iQu/3JQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746196801; c=relaxed/simple;
	bh=SdKq4rPoTRSfLq8AREEumc0zDqjDR9ZJhp07WX5vADU=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=FcPEsrwGAqdy/Se3R+TfKHk09aq9FopHXXOtfz+VxvXYswXF31wzncC5VhXOOqZIqKJhA0oQlEjyYaesPd97vBiu85tzIhL0Esd4TXlRL0yVyYH+975Nx8bywGl04ZGP1Q/BIzE6HjOIajmw9YvV82p771ftCirziIVnusfc97A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=l7HaExOL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=X7/cZ8h7; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l7HaExOL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="X7/cZ8h7"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5425WwOB013895;
	Fri, 2 May 2025 14:39:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=Vp/Hr3JQ8L/tRsNC
	CR2HTUKch4igANxP2T5tBI7/p6I=; b=l7HaExOLZGgbacTzak604lNH3tfQRI9m
	uhxMwvXlB6/JpE83zJC4UakaajG9oAu1de3TMSNpsV44BjJolCFhYCKJLpn72ULv
	voY/ubzcagjhyoyVrTbfDVjwItyQ7zq7ebYjpCzybaMmUTvAlb42crIrq+f5gFTG
	71D5jg35j2/5Nm5fHJW7V4RpVqcSLWkel5s/Ht2YH7TQSdwVKtn/ReFFkhZSZAG3
	3j6hb6KSsaRuF4ybjjE/Zq4RWVTNtqbQgM5kvRi+UNCbdPnZRvk91HRqb8T31SMk
	lvDy12s4QMmAu8ep6dI+PnqZF0cJ2lOZ9pz7gk8IREZxnJBZ9ZYmSQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46b6utdb7n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 May 2025 14:39:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 542Ce5bu035576;
	Fri, 2 May 2025 14:39:43 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azlp17010006.outbound.protection.outlook.com [40.93.10.6])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 468nxdmjkf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 May 2025 14:39:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lK07hd7bS7YRNOfDsqhlRGIhfiP2Up7EOLQUCFCHBihxDd5znbtp96pDotAlpVoyKiCD+8OGOqOYrasUSHE9Ex924ax6jDyg30/sPn6Ri0g2oVX0EoQ4N0frosGM6Gq/OhIlIdxISsqvMl9bOwihYr2bz9sHVuJi9auPrBH1kFkWOod5PVxBxiYV6dR7LmSHIn7OxJDhWkAqZ3wb6S318zmnIVlKYrvYeClgIsfR+VFcQueMcMbsc28D5bWMV2f8vj/bq++cVndOLxHvvVRUM9/ToTe3ztJExnUkD6ezvsbY8ENiT9sudK+vY/MmmiUvCM6C5qaZmasDs9JFnZBKjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vp/Hr3JQ8L/tRsNCCR2HTUKch4igANxP2T5tBI7/p6I=;
 b=JOeNGzqXHpYUGmuq9JFv+WFKVgO1elKvjHm3bAlTBus06Fjcp9fDay4QXsCS015mMdBb6f7qNRCQrP9CV/lUsMryRqzIewIajDTBgD2muaonXUufVIeA5m8kbc96u4E57+jhuJM+0NOm2ZNWLakz+U0Lpj0HG1wdEIOY65kzdzknp7DjML+omUsvZg6Jk5O5AMzq39ZlOVCVMRkGcSAU4uxrTesMjsqnye6iablIGyh55F7pUhYMWAV6P16S4Tc2Jop0xWCKU4tqMv0o6O1RxdbPWCrBUJoTx6G1WIbwg8JwWP+UXs30pLQmvgj6nYlkdy6gA7Jw7ZTIT1Nh7goMkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vp/Hr3JQ8L/tRsNCCR2HTUKch4igANxP2T5tBI7/p6I=;
 b=X7/cZ8h75A/JRN44nwyXyUwu7xr0yb3ma5zMsTMDxgt8CkSyVxvQ6vpi+AY7VxSodUS7PPPEYBJyDjnVNpVhQV3RgxZhzwcVe4iIBmHB2dRBshxr2sNHyK3I6SHI02707uquhBpjQciXFjdA1iaNjbOUV6E+ZOdcvc0CfguzQHY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA2PR10MB4492.namprd10.prod.outlook.com (2603:10b6:806:11f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.23; Fri, 2 May
 2025 14:39:41 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8699.022; Fri, 2 May 2025
 14:39:40 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        martin.petersen@oracle.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH] dm-table: Set BLK_FEAT_ATOMIC_WRITES for target queue limits
Date: Fri,  2 May 2025 14:39:33 +0000
Message-Id: <20250502143933.1320061-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::25) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA2PR10MB4492:EE_
X-MS-Office365-Filtering-Correlation-Id: f29a8a4b-9c48-4a45-3c81-08dd89872be8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KRmnZfXdRely7NuJs2hl6U3XZlHRDdm8muM4IVKeyCQYbWqeQpV2vYAn2w9e?=
 =?us-ascii?Q?MOVKYK88TV02tS+ngpb5jbN8Bx/eliIZtDD9YRoa/s70qKPt1C8cn49rKzVD?=
 =?us-ascii?Q?2q5ofrRXDJsZvRKtukfVVv+ADSohuuOEelKEApmyNcuAokxREjG0AKVI8G7g?=
 =?us-ascii?Q?SJu/LIMCR7RgCZO+rwWYEsF6ggwdCmvppfdgh71/zBDlQ/uVx8ecVMBno8B0?=
 =?us-ascii?Q?tmYHtbY8CMMAS1wp1LEPZTeWuT3pT6cT9LX/2NdUwqiE3Re1bK+1V/zjOzAU?=
 =?us-ascii?Q?120UZKZsWJW7hWyFOrbsHmUqtjBV1muWnIBvySAe9V/9Rg9eB20tAAZgb3tr?=
 =?us-ascii?Q?8zX5qnf216sRlveQD3wYEiX4wYopT6u1vgCBxdHj9yHEKXmiKo9Ixu8hcvkP?=
 =?us-ascii?Q?3FhMpi0DsHJKT9IU0DYKyHwT70Q85qlcgYAsaqeIifrIp3MCDwHlmfQItOpe?=
 =?us-ascii?Q?WuXxqQRVAjvA3RRxvVa77pjDAs/dYB6IANuYycA68UUYQanqFVV6r1uFUYZM?=
 =?us-ascii?Q?wkGoQ/K4vOIH9mk8JgP4CBjgulk6r3RO3X57K0BJtXvR4VzemvFtub94q2FS?=
 =?us-ascii?Q?E0B6adDkMNeRGmigoNGisgpKgESIUndRiYe2mXi96JwxUVBFmiSjrug9JoaS?=
 =?us-ascii?Q?94Isi8OidSKPPeq6UXKhUrblkdRYhs2CfTlMjks7A37Bl/KYm3DPAhOBavf/?=
 =?us-ascii?Q?1DoGSDWEkI0zABc5PpP4lWEpuroWRgkZcCwyvc+i161Q6ikR2ELGmNJt8D6a?=
 =?us-ascii?Q?SvB5t0lhi8V56bKHZ4Kt1pvPIHDCfSDdDwghSatWU8PZF9loC1tUCdFFLqQv?=
 =?us-ascii?Q?1d1zh1j3tJklnV6edqEawa8eb/eDYMhlWdEvoecb1i9+IOcjmIxvQd9T75ym?=
 =?us-ascii?Q?LgtezbvzoORcHv8oM5S/nUwIdGCXorPWe2r+7ftVgDIpK0DJcEni2VuExv4T?=
 =?us-ascii?Q?CIrbrMYRLZjxb7HEPXNX/4P54EGODqXIavYOYlJ2UmRV7r1i/16qMov3dMZA?=
 =?us-ascii?Q?3kRkAwkP6i2ee1SDPS1M7yqOxB6PmgWvPcf2I8SqvV2mOVptXAKS6ze3oQdq?=
 =?us-ascii?Q?AEoz1jz+tj2PtMGrzVtG3RIKsM8mtO/sxh4UM5PydVpE12B238a4sedJ8dha?=
 =?us-ascii?Q?VR9oWsbqASniGUbxOwcJbvsxtPkBO9Zv6k+jMZiUtdQN+ZVGuroymsmI2vFp?=
 =?us-ascii?Q?52dgKgNla5cKl8BH2bErVzIseA3fpGBSAZHb+t3bbgKBa2VSnrPeEZygfPBq?=
 =?us-ascii?Q?DFSfThXeQtV9+SaltI43DSSko8/bWZ2eCEyxKpJcCWdf4tuDBOoefTCAZmrV?=
 =?us-ascii?Q?feqHOtLLhwNu5C71KG6I7BACWjiQlNt4UR5cSkgg/BxV/ipYo0RMEqb2j8xQ?=
 =?us-ascii?Q?DOUe3YAhpY5TbH4isVr1KMZR72IHciQIO6/SAS3Vq+OoJESYuK7k2qfmDgOH?=
 =?us-ascii?Q?fvCjDKbYXgI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oE4ZdFVw7LnN6I7Ep2+b+sdPlyxUBYxDrt+vprXeSDdD/U3HfSdV/gtXcvDm?=
 =?us-ascii?Q?WBaXoN/J3IK8bSgb7vLFSfGOFbn0Mvc6nuAXmc+LHVwXR+5CS3ZlatiGV5YS?=
 =?us-ascii?Q?E29Jn8Oql8GBgGPfRRH7SrZDwAFrxWRKl+wRnPqW1nGwSx64pblz1P2ZQq+f?=
 =?us-ascii?Q?pdNsR8dmubWnxcNpDSrBWMvTjH8AUoaCTaxOa4ZlGkHveW4fkRF24P7Gr7BO?=
 =?us-ascii?Q?RhQO/ufZprxyg6q5Am7zi9qn2gXEzkiGh7r74y2nyP0VVxh5gL1JXdrN5Z/j?=
 =?us-ascii?Q?5//HA0+NtA69Z0OTUXtPThEQfg+t0MegL8/6vxCnVThlPxv21ILJNT+wGUFP?=
 =?us-ascii?Q?eM6UeZDEyiQWkPKvpTgiNwnTAl4UiTqx3kvkVKWQ8gJa/RBxvBWemhZ/QumI?=
 =?us-ascii?Q?+43AhIpBcJP1Ps2B1XejLdQ9/St525/RcWRbi8e22nSojZ9uwjB9WihakGkQ?=
 =?us-ascii?Q?ua1Pw/m+eqrdxRX8ro42nc+KtsdncsONx6wwgDb6qG+n1uo8tfHSmS2jc3fd?=
 =?us-ascii?Q?MrnxMko1tmvdicIrtVJUtUdb2rMf7jAVFJkpHHt8444bCQUzws6+3eJWwG5p?=
 =?us-ascii?Q?M/R54m4uWvNqv+xSqHkiu+ZPML8PTIzX3I/ATH2J+nlbzM3KMl/2Ldb7sLsJ?=
 =?us-ascii?Q?pK3qzuA/AFjFpcqAHbxjA61shFhXXlxubL9i+vxHTsEUNKyffNGs7AE4xkyd?=
 =?us-ascii?Q?JKFFyU5Szn0OIH/FuNYprAJCDyU11ja3pOo/6Wd5nCxungkZmfYdCUUPzzbX?=
 =?us-ascii?Q?crZGv3zRIvbUOMwtNF7L0wiG8jo88VGzIlA6Glzad1IRHqkbFymMWb7aH/LX?=
 =?us-ascii?Q?3oprUzPGpSkDj6nvbfnIkBQQqYTROveefxRTaFnDP1BW79kgtbYexrpsAWJs?=
 =?us-ascii?Q?Wulr24VDvHCZK7MRIQecACGF1gCEPDdKz5RbwNJhs3t756Yi8gO7edo2x9PS?=
 =?us-ascii?Q?QCtvDUXBai1DYAY96tx4OuaGgBkAsNm8+ed4VSwilCNfroAjO1AqBMNrlCk7?=
 =?us-ascii?Q?U8IMwQxkAfeEUxvTh/bAqSHKPb/tEbEDyhZ4BQ3XAd2KD06LTopG4s6fjtIu?=
 =?us-ascii?Q?yMopyCypecerb1umgTEiiZ4XYpI2Fh8NtPHFAPmikn6T5lqouHDAUmVcmD4C?=
 =?us-ascii?Q?74EUkt/2DqGOdoRw+GP6zrftWuOjAzD+2L+4S4/qjQXst1TsVlEcLnvhSjnb?=
 =?us-ascii?Q?1DYLwYpzTWUlbbFumWHZxlel0e1NNgdqUfFHAr7zb6hGEQLHf7CC3S32SBYv?=
 =?us-ascii?Q?MaSysYDzLhfDHUkN/2/eQJYB8wtGjPLh+1hiHHrIuzFAfGLy/jC6Xwr3q5ca?=
 =?us-ascii?Q?1l50AB60wnEcBplwE9bb4Cf3P81PYSz+8SaX2+hb1IRFHO7Ibhr1GVgBw0VF?=
 =?us-ascii?Q?Etih7MkH1yO3l6zA5G9Rdnoktgc84wiLnZ93cZZlkFouhqHbWpTK9BwWcBEu?=
 =?us-ascii?Q?+kHOCBLWs40juWTPon55DWvOcpnvqScm4OwOsFuuQvm+Ngv5BCwIj/NisO3g?=
 =?us-ascii?Q?u7EeHEmyRTp35wUkgG5XbkGytbClNb2syHdqjkhz7k5MQd76tUM43F8Q491B?=
 =?us-ascii?Q?wxIbwcRXcfnBFGCfE9pzI48/BhneZjvYLhoy0IH1n3cpliaYEdDauQ1dXyMs?=
 =?us-ascii?Q?YQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dVKydK685JfR9vgsIq1lp+9lUcPf/FLh2gPdojZft72u+FajmNKlcrd0dw3soyUxAGlqLxI7eWHyaFXWH+FTKrQoEdy4T3hc8GCB/NfUp2LueEO8Nk+3qQyD4ytiiUm5+gA5krLSbjaPbaOto3wnbCPhguy/cHBtXqkDypdRRi+ddnDIhQwD0m0pGHwm9LVWWcjVG/p12F0TdnR6ZRwm5osMCCVNq+YPn25EsTpXV31y1rUdExYll0QPIx4gYR+Nhi2qfVfASsFsVkdbdZzX5gCtGefCMFL1Ob9N7fnyMApYtlGq12dVZj4jKCfSzPlOGyV+Ub8Oqz8xpLwm94hL8RtPJAqDK7HA3V1iLEs6Gre+6RDwadOeTs1Oja4o8JA0Jtjx8K0VPZ9zjmKuXqDQW6JY38N3egxvF9sXCf/yycbD8z3f/kp9M+IdSIWrdyDzRbaJ97GKkOAYDN0STmoX9ssL0IHccLTKOgnPqRQuK7hfqji+iYE0JYXhhPbPNVhpFOiqz8tFoYKPkWBLM6RB9yKkcboszVrsrWZcGLh7XKp9RS8g1QuafpNfQwYeNzgicpN6ZOZYEVmebaMS/QReDCkBTwRcp/+k/cnb+2lwUUg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f29a8a4b-9c48-4a45-3c81-08dd89872be8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2025 14:39:40.8184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1fd8k9/pt7jPMLjo5USXUR7Ao9jVs8oakqdraFXGqSrB22T1eLzXxerCNLiObBIPy2nJVVfWOxnudRBCG9XynA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4492
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-02_02,2025-04-30_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505020116
X-Proofpoint-GUID: ekeojPi7BOfzJyjgJsZeyd-OoG-qQXjL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTAyMDExNiBTYWx0ZWRfX9pbAnEZVyLzz Z1PfmxZi4290i+7A9tr4M6xSs+1gp5/xVUdCjs+SsvluKQU46j1O2vSDwJC0kb1RDIZG4cYwIav 42RGz5jwmVO/nnqnr7jIlZWDNCEQ/PQTu3mAQb948Aps6RcsCCuyAH1ElNS97dZIF7Bahr1ZpTV
 ERUgMDjixWS3SAmGzdR0hAz7zuC/0SJ6uC40Kwh9a3W+P9dviKCLQ5EbDBQcfUw1bS2not89u2d Vgoxjhkb5htn4qPHOVlL5BMNAa9AMQ7u2wRIEbyilKDr9TGDbDU0OoxarbhO66qK1WzKYvOkltP CNXYLPqTuG/Dq39w4YC2Z2y6MAfYOXuilSBuhL01z3CWNxe3lNHdH4dgXeu74owXrbhgzGAdwoV
 hVul3ysXd4y0yGerLpiJFq431uozdsBtEegWA81DQycceizychDRYaCT7o7lq4N3DK8bqLC/
X-Authority-Analysis: v=2.4 cv=ZuHtK87G c=1 sm=1 tr=0 ts=6814d931 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=u5aENX_vKhAgTG_2G2gA:9 cc=ntf awl=host:14638
X-Proofpoint-ORIG-GUID: ekeojPi7BOfzJyjgJsZeyd-OoG-qQXjL

Feature flag BLK_FEAT_ATOMIC_WRITES is not being properly set for the
target queue limits, and this means that atomic writes are not being
enabled for any dm personalities.

When calling dm_set_device_limits() -> blk_stack_limits() ->
... -> blk_stack_atomic_writes_limits(), the bottom device limits
(which corresponds to intermediate target queue limits) does not have
BLK_FEAT_ATOMIC_WRITES set, and so atomic writes can never be enabled.

Typically such a flag would be inherited from the stacked device in
dm_set_device_limits() -> blk_stack_limits() via BLK_FEAT_INHERIT_MASK,
but BLK_FEAT_ATOMIC_WRITES is not inherited as it's preferred to manually
enable on a per-personality basis.

Set BLK_FEAT_ATOMIC_WRITES manually for the intermediate target queue
limits from the stacked device to get atomic writes working.

Fixes: 3194e36488e2 ("dm-table: atomic writes support")
Signed-off-by: John Garry <john.g.garry@oracle.com>

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 9e175c5e0634..b35e48fed641 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -431,6 +431,12 @@ static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 		return 0;
 	}
 
+	/*
+	 * BLK_FEAT_ATOMIC_WRITES is not inherited from the bottom device in
+	 * blk_stack_limits(), so do it manually.
+	 */
+	limits->features |= (q->limits.features & BLK_FEAT_ATOMIC_WRITES);
+
 	if (blk_stack_limits(limits, &q->limits,
 			get_start_sect(bdev) + start) < 0)
 		DMWARN("%s: adding target device %pg caused an alignment inconsistency: "
-- 
2.31.1

