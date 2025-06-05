Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDDC19DF48
	for <dm-devel@lists.linux.dev>; Thu,  5 Jun 2025 15:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749136177; cv=fail; b=aSwKIMk0iyEn8TMVSCaSrYyuCHeEUc2sJOJUUwhcmOgyojPgwA+azomFTDasp5D1O+2Hq2HZ0eLdk7iAgbH3fuj/gt8+NtUQ99L7av5Y9giBZszpDShbGu6RxPrWVAcSsGj+07szo0xXY8ajnSKO2pMbQIzJn7tkh1uwAw5D5cQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749136177; c=relaxed/simple;
	bh=aT5/y4K0YHL9pl5BflenbXfGfUpfuZTtnyL3v2FzeAs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VTj8/7pR1ty51YB9PbJuSyf0s7ghEZlc+F2Zx4blDmXOAgnQ9vT6JREfqj4tu3At+9zoEAJUEHLLX+dLKLn/0vJXrBbvMDuZ/qtPpuDI8EC58g6BDb/cJg9qKKmXU7n15DpsA0LS5NBZcN/hp48X4QXiyESVX9eiQ1y49LQ931s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ACFuh1Rf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0AiTyfsO; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ACFuh1Rf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0AiTyfsO"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 555AtZe5004879;
	Thu, 5 Jun 2025 15:09:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=zFSrxAf+pmIex2sYpSL37Z23Bomx5Y/zy+ALjpT9N4k=; b=
	ACFuh1Rf/vg4BUZj735LoJVnK0x6buIYBDmjeTFDa4oInJpxPCU7XHGWWO23LM+q
	utdRElIFY+F90m55pJrC1Hf6kpTy0fbOy9mo2usHfm07Pr5ie3+6szJqp8G5ZZai
	qIyzGguW3Ig0sGw4PGGQE574yfs0Av3NyhWtkXuKs5znkmFed7IW+Zkh72+Kp2Un
	ktlOyynpxlPx1vR2zinZzt5lMyC9S1wG21TyPviEPusVpBm5gfXb6NXNoKO9su9b
	2Iei30HxMu8RffcRlaQ+VrNCN0LcbDB+J/hP+1zPD1Yf+2wZG3fTtiH4UZfqnjzG
	olfi5fkpotyfSIQxn5TC5Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471gwhe61p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 15:09:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 555DrggF033839;
	Thu, 5 Jun 2025 15:09:20 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2081.outbound.protection.outlook.com [40.107.212.81])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7c6h0n-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 15:09:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VyjXgGgcx8J4Kbzlt6m7MtefA/onDMk+eJCO7/EnuqXVYzvv7UyOE23YBfutKUVe1kpnlw77qsWcfbl3IHauTVWmOnVisQ3BIcYj4JE3S1xWQ00e4RNkL5jlUxPn3bk1D9FvyBOVXbBqt3ypRI/eTy3+A45pcBm+T37FJF51xah/CMdSSANYOMDjNbjvpL4zimQ+fMysXH7qdiNziqq8iWu7Z390vL1du50lsa7Yc7bhHVT9dOrI3b2PlfkWDXxdJiOw5T6D2EgKQCZNq2g2QMw2tg7uaFnHeRMlXh2ELVKk1Rc1ViXvlycZzGWCKCC7IYTGLu4TjryhMx7dzMDYlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zFSrxAf+pmIex2sYpSL37Z23Bomx5Y/zy+ALjpT9N4k=;
 b=cH+54CtCWryOlyFrOltW3qEcE5hkcG/y+lkQR2C80RYReBbkVwPud0CfPs5eeIaMraGqvHEfaniFuWDTmF7rVnWN4XVrMt/lsK4hn0d6J4x98LM4LYGUIVezV08obAZLgFRd58XA45uNuw219lw45Z0yeC8jv9DWcTiMe+Rh714leMdZYIshr/BF7ImfEKGHJOVdh/zCr850FI7YzTTLrl/wr2F5nNG7WUU2fwXCHtkF/C6eS8pcTFLzKraVhUI65SB+4pfjlA/jGAaeUBPt2sJ25EF/ilKVWFysIRK6SSnHU+oIev3yG4J8P3IAJhmkeWR4/qugLP8u9WEPF/aIkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zFSrxAf+pmIex2sYpSL37Z23Bomx5Y/zy+ALjpT9N4k=;
 b=0AiTyfsOmRBwEIIzMbn8qTKv1c7pEOoJzJica1uB529mmXcj29iWu1SWgIKCYz7Gyvg9iagbhIMMOUiX+o+vm7LDgTs+VmIK0RJLHTkb0VPM1L79fr828FYwMpJeXWtQgdqTDR7WTUC0JPTS7kKEFQbcVUZietCUBFl/bzO0M9w=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BY5PR10MB4177.namprd10.prod.outlook.com (2603:10b6:a03:205::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Thu, 5 Jun
 2025 15:09:18 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8746.041; Thu, 5 Jun 2025
 15:09:18 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC 4/4] block: use chunk_sectors when evaluating stacked atomic write limits
Date: Thu,  5 Jun 2025 15:08:57 +0000
Message-Id: <20250605150857.4061971-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250605150857.4061971-1-john.g.garry@oracle.com>
References: <20250605150857.4061971-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0196.namprd04.prod.outlook.com
 (2603:10b6:408:e9::21) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BY5PR10MB4177:EE_
X-MS-Office365-Filtering-Correlation-Id: f757efc6-f61e-4552-ea92-08dda442f1a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K+KN/Vs5OPbY7XATVAL/ui654jKXFVbd3Dbcaqnqhe2FeViCYl8WyWxB+fzv?=
 =?us-ascii?Q?Rs9Gl1ijrSACxmlb7Ql3x7r94fSCTnGqoNRqnaqjk0XS1Qbzm0b3NerlHOZh?=
 =?us-ascii?Q?akrdL78ujgzdMXF6+EPrHbgmKoYhVxzu/lod7ykLmiSwHv8tzK/nL+8CeU+1?=
 =?us-ascii?Q?fQmXj1WIpVawGdjwCa8N4HsmqnaX0/4G3QCNBenAmKAr7O9Ma/gTjHbxVPtL?=
 =?us-ascii?Q?3qJvfVeKZPJezm3ExG+GUq34Zq5bVokuPJY9B3xHEYHXuKMXWPjYOVwG8CTn?=
 =?us-ascii?Q?CpF4yPOkeAecwAn5BXvmj97Yg5Ej4skUPwuCuSMDqRhKZ1M1M/8kbTAphEJs?=
 =?us-ascii?Q?SqnzlEYfTnOMuuyLrRryPRQiz9eVU8K3BfRJXiulh1lfXwyCdr46t8WZJT6V?=
 =?us-ascii?Q?T1oo9Pplfn38Ot3JOXrhEwOBy5cCYx/hPANsagitZY3TIqwO01pNiI5NH0JL?=
 =?us-ascii?Q?LrBfmremiLypy7OCzf9ooPEJpFgyuC4q7M+GvewN9JfwpOWrEZI2DMNdhhHr?=
 =?us-ascii?Q?RkEr+8ib7eJ2jOyqu1zG94Wo2I/sYf3tBkHQ6zPMMfjezOqfNbHQSArUQee3?=
 =?us-ascii?Q?rCzgo+3Gh6c6UjxT9FhZxQGbNOVRi4UtLkU+XBnL2NFaUtVhfCp+zOI+Jxa0?=
 =?us-ascii?Q?gwBwGZzDVCAawxgy0Ir2eoCvzF2GOpX5XoWUu0aM86nAuFOjPvc5WO72lk3U?=
 =?us-ascii?Q?PVZSpiBwSYqMUqvAAr8oemN8kUf2oLFpCEHWTXhIsR4mni/3BUBKTBlgznGS?=
 =?us-ascii?Q?/y+BzjjKN+IplvPvtQ/00NnFLHCXNCD0g9zvPYyOMFQqtP60K9j6QptghP2B?=
 =?us-ascii?Q?28NPzncBUOgil6QjYW5W1phUQnz2bpJ0vHeM0MUDradMNQQRrtjMU69t11NR?=
 =?us-ascii?Q?xqMmS09coZx60rdOpEVyKgcVqQgnhR6FQpazPy4YaInYgoMXxyVYbcObAnmG?=
 =?us-ascii?Q?T7f77+DFXnXt5+fnbca7g0BAdnLZxAOo0sYiMTsV2yzQ9bMhTCmDZChn/9Iu?=
 =?us-ascii?Q?qKM44139REQVn600kaiSvq97IZT7V1OPBisovIrAZOvZgWa2YZOCAk8RdKwz?=
 =?us-ascii?Q?i9yVsO8utMOJlhowTvmBci5Tk2FSh9Ai4QJ/9OiUsSjTSdkaqJMfPyo0H76P?=
 =?us-ascii?Q?MyjBfj8BZpnyD0hCUt33buZTGAgqZf9djbRPqDxpuKP1m1z/VY+DVmmB34cG?=
 =?us-ascii?Q?61n0f2pBpI3SnrK3xtor4tOomfYtPr9ggRrGTD1RkmR7L8VEyO2QYgBwN9YA?=
 =?us-ascii?Q?DubTFR/xTb1RzmhQGLw6nslTZ8poCZkO5LypKenCsNW3p+Lr0/loBjJyQzqa?=
 =?us-ascii?Q?ova5UprWo9vI2kxKbaAUL57WTV29mrVkFlbcU0HXu0s/rGFbxuVpv/pTTSbY?=
 =?us-ascii?Q?fOxtItbOj6Bt+xuC2oXhSmkcwK4c?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BR59OiipnRo81XnP0JVHoQdNcvAQC5RUgyozMd898v63Sq1FV/GQuCZZ8j+T?=
 =?us-ascii?Q?q9ZTJcJztJ8PEHf6oD9snNZCHUgDO5BZ/k4HqZC54YhwX3Lpn4OuudDv/Z79?=
 =?us-ascii?Q?YC5zLR1q+EopBqLRemzz2xKJhjDtuLULCkUS2m+EPhZxlmiBDH65rIr6beEv?=
 =?us-ascii?Q?2s335PJlSf3sQ2zKNqnuLPofhLFROXV4Sub9pldIKcYdT5Jgc373E0OlGgJB?=
 =?us-ascii?Q?JlP2u8HcG9z8SvG34hynq1bhFKgCOyK5dOB+B4i0xL2CUwcajp3RMlB1Pz/y?=
 =?us-ascii?Q?K9zxjdzQMa7O6hVmUZU0vHZqTwODs1tgxIqSgXOVKfQuRcTUfSQTXlF65aG5?=
 =?us-ascii?Q?KIPmO+mDdcFW/AubUa72HxJJE3DICIutDF227hlPoWaNA4j9uvgSP7jJbLsI?=
 =?us-ascii?Q?/SMh5xO7+7BWae2S1FPjXbVjAApkMv7n2/b4HtbaN7hhEtZXTcdjilIrrqUz?=
 =?us-ascii?Q?WJunncQlEp94HSmxZBiI8PPF7EvfsfJh8AQYaYLiYI4xPCivhUfwaTDzERvW?=
 =?us-ascii?Q?xWf7wM5cG1jq5pPMM1Fv/TUwBxMXXMZ1+ngoF5s8P9S4HIWcNDg7Z5GNHfea?=
 =?us-ascii?Q?9S6ptSiTZaPnO1cT9B0+LYdOaR70c4/riA0w7TAoengeZqioXgUWsMmc+BBB?=
 =?us-ascii?Q?i2lrWy191BDKT1GvMVZa0ug9vVA/ZjrHdqaAF8rG1PDOJyFEagmCm+nMx+RS?=
 =?us-ascii?Q?RC9n7mbwPS4jC4neNMVLUp3w7hHmneQ7mINwIUNfq7wtiqi4sarnmNmNracx?=
 =?us-ascii?Q?ZI9VnWMCpvKMxJXrdBHZUFxw7tBXRAPm9dXZgrjQPeSsQiQcNIK2HakeM/mY?=
 =?us-ascii?Q?7gZJsPC/phxdall/EH4zP/Ja1Ow1QRGfsepkeQSFwstWAOEY6L7wo/d15ai1?=
 =?us-ascii?Q?hwqsLuUZit/0Fze6jNQxPVz1IXUULUea+XkOvtR+fL9UlnczmZyMAtKKTIpC?=
 =?us-ascii?Q?tgQVGTWSFNP7BbeA18KaUwEzcOlC88LvFhcPMHxja9xsV9jTRmlvwxfOe4p8?=
 =?us-ascii?Q?EmWtxwcxW8CXgB8qcheGqDYML4OyIAC+VVFHPSQKebh7TtuugotAZeUDiOSS?=
 =?us-ascii?Q?F9pXnM7eUGrCkZIK03wfmLpurMUfNQ+Epwp6MUhxYVwZPDYOcJehDXbgzQpd?=
 =?us-ascii?Q?YtaNiTovpCUKGqBLXjaE/7isTJxA53M7LgvG4dDDfqDdTVDj0T2b3dvUIp89?=
 =?us-ascii?Q?CZ2V039vagULaOPaJ1XhmGINessD4DC4pPGRCRXil4sZHXBiwlzXcp9vGZVO?=
 =?us-ascii?Q?WVrc9yitgRLGO2NWSL8E0o3tVPwb3HsPPuWCLRcA8XXAshLdHJBC9ATSWGlJ?=
 =?us-ascii?Q?FLe8iQbPTpTBlhyqClqQCeL4uzuI5JCttXZhH/OsDnEK26TgiYeeNkZoZQ/V?=
 =?us-ascii?Q?TpltKu4auPwa2UbqrLBYUX49rYUApYHtBWGvHxmRyRlYgJ6woSeXv6YI5jUN?=
 =?us-ascii?Q?6HdtnRbLNGE2itHDQs9qiGxVa8kQ7j7HhygvR10gUHB9gq2mFo0nuSKpHSKY?=
 =?us-ascii?Q?4d0ekArp+bMMbGYa4fn0W3nNkk3X7d7OSM1cuSd3+HUjH94BUXvPgIpTe2Cr?=
 =?us-ascii?Q?vCC4R8PSnivoc2vivxPYw/5d/xPeaizagkpuTDTbRezEtbnCd34LbZbpoh92?=
 =?us-ascii?Q?uA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eP8afjt46CQ4ArcJswHZ3v9vRAftKoquakJ/jasYBQ5Tz7JVeSeHEDeO12IuXgL5fK7PBrEBc8YIhq0MMIhGmb+uLyucOO0NqVvJgz28p6OHA1lXwxvT0K3WEbs8tvrq3g8QQ++QuRI/orNoZYDZXVsVDEMC921W1wbe/cqxaowFyhZwEMV1Cwvehg8Z2W3obxyeYGn5bdlpQJ0WdQEP+X2pXA8ll4vHcq6HLHCoJ8P/32K8WzmrkJ6wNbmtw3+pMLwKAJYEIOHJes6gsPO3lWUGTwFlCoRDS96uxKq7KaCv6jj8HBYF0AVxZRArEVB9FDn7MAPKMYfQWqMbOW/DwZGK4cs8DNkk7E/bWF4epkfjQlLX65nbvgR0unWRz+isIDFoO537RnY2tsQkzJt0as58IMZ0Jl9kWy/qGOUu0A3EPSycglowdbWJt+B2kdySKWoz7sr23Uwq84XcjNzXdTKCohNK1efo//4a0k1WMZf7tKvLxTLe5d8qVX/5LWXrhI9UsxXccUAdbysAFM++MXmh6htUBfABp6p7ATH6HnvBwIKm7iILrt5TX0EanjrWxYDrBs7+5CqlBadxIyM3U9lBAe0j0CzQPONCQnm9xLA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f757efc6-f61e-4552-ea92-08dda442f1a2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 15:09:18.7728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qi4wY7YjlGsS5p/SXi1pezjqLQFOw0tMrUqi9Ltaq3WiorpiZq/cq4M++v1+4n2cYWwiEo/QWOua/zLBghslNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4177
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-05_03,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506050131
X-Authority-Analysis: v=2.4 cv=Wu0rMcfv c=1 sm=1 tr=0 ts=6841b322 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8 a=7Yqy5HVKIABGq53VqS4A:9 cc=ntf awl=host:13207
X-Proofpoint-GUID: KmZyx7rppGZ4GVjGDLfphq26HQ2wET8Z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDEzMSBTYWx0ZWRfX8S2OtpaXJjiE 8f7gfoJFptq8FiK+pyghDL5684yqbMwDlMMNspWoPU6KR9X2Wr6p2iDyf6LyNfvuZLXouZq+6G2 s+yF2jYkm9EdM9lP68FQPF/pWfRsbkF0cjXgkcfIjLqwnGDbIbrrc+JgWv09eE2vyuae7TtEbLE
 xSv7OSwi08VwaZiV3dR+g6FmEX57ajYoQt425B9fWXe4j5V5WcA6Z93cCUFFy6cdl5lFJiqohyu Cs8veYUwAl9SM4fCtA14lG2l9CmGWU18UkmjgdGJFtGLRCRs1F4tv8RjTBzhcWdbzcWgvkd4c1H B0kk7P3ytZM45lBZJQuubSt7TjgOOY+mgG8UtgfrOcaGY7Z5npa54q6/qz0pTqzgn0TwWVYlD4m
 7UUilmjuHXkzbHvJLrNcQnlHHIMU4ExphxBlGUj9VIuutZZeq/dugI51ZqQRhmCRc81HjtL9
X-Proofpoint-ORIG-GUID: KmZyx7rppGZ4GVjGDLfphq26HQ2wET8Z

The atomic write unit max is limited by any stack device stripe size.

It is required that the atomic write unit is a power-of-2 factor of the
stripe size.

Currently we use io_min limit to hold the stripe size, and check for a
io_min <= SECTOR_SIZE when deciding if we have a striped stacked device.

Nilay reports that this causes a problem when the physical block size is
greater than SECTOR_SIZE [0].

Furthermore, io_min may be mutated when stacking devices, and this makes
it a poor candidate to hold the stripe size. Such an example would be
when the io_min is less than the physical block size.

Use chunk_sectors to hold the stripe size, which is more appropriate.

[0] https://lore.kernel.org/linux-block/888f3b1d-7817-4007-b3b3-1a2ea04df771@linux.ibm.com/T/#mecca17129f72811137d3c2f1e477634e77f06781

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-settings.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index a000daafbfb4..5b0f1a854e81 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -594,11 +594,13 @@ static bool blk_stack_atomic_writes_boundary_head(struct queue_limits *t,
 static bool blk_stack_atomic_writes_head(struct queue_limits *t,
 				struct queue_limits *b)
 {
+	unsigned int chunk_size = t->chunk_sectors << SECTOR_SHIFT;
+
 	if (b->atomic_write_hw_boundary &&
 	    !blk_stack_atomic_writes_boundary_head(t, b))
 		return false;
 
-	if (t->io_min <= SECTOR_SIZE) {
+	if (!t->chunk_sectors) {
 		/* No chunk sectors, so use bottom device values directly */
 		t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
 		t->atomic_write_hw_unit_min = b->atomic_write_hw_unit_min;
@@ -617,12 +619,12 @@ static bool blk_stack_atomic_writes_head(struct queue_limits *t,
 	 * aligned with both limits, i.e. 8K in this example.
 	 */
 	t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
-	while (t->io_min % t->atomic_write_hw_unit_max)
+	while (chunk_size % t->atomic_write_hw_unit_max)
 		t->atomic_write_hw_unit_max /= 2;
 
 	t->atomic_write_hw_unit_min = min(b->atomic_write_hw_unit_min,
 					  t->atomic_write_hw_unit_max);
-	t->atomic_write_hw_max = min(b->atomic_write_hw_max, t->io_min);
+	t->atomic_write_hw_max = min(b->atomic_write_hw_max, chunk_size);
 
 	return true;
 }
-- 
2.31.1

