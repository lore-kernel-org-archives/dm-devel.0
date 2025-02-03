Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1684154457
	for <dm-devel@lists.linux.dev>; Mon,  3 Feb 2025 19:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738611206; cv=fail; b=dl8zusk5WoX+xJ7ITc9Fw7uWHKEcUxbmkfpxSu8C7TbEOAdK1txEGOV7x41ALPmG9cJckxt3V/vTIIZ7SlTFQZAIASeqwbYfji4fIuEnd06MXMgOPYdkXXjOQDAewg0E2WGT/O3ERe9CKrx/vBRiumTX3Y8Pv/CfXEbjPcUMOjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738611206; c=relaxed/simple;
	bh=4vw1+2LC79xBCUETiRpsJBYOmH+ijnks1Ae/Prig7iU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=oYqwpfCfhDfROMx76v7ZtHAN8ymyPbXAHa+PyVRhXu4sqgHiidZ7s+Q4x8MX9wBKoNQc3e71PwsZ9kVfEYxco77jkGbhyasDvb0xc47GWYQ6nFDutyN5iS8sQAVkkiRc5yQ0LKlZtNeTaN7DoYfO3Okt0eUPJe6Wi49m7IYfvN0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SI2kmePe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WSI61OSX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SI2kmePe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WSI61OSX"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 513JMriE004430;
	Mon, 3 Feb 2025 19:33:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=lCM+UMhMjfL32GK0PF
	cSRal3XtDGCCGMwuhn41+3aoU=; b=SI2kmePeeuF2O3icvP7f8aWP5sOoEtJ8Z1
	9ciH9N9gD+ry5qwszR3qww0zub1JjF8GgxZQBDmeN6zjBqgFGkgrglCFJWtodWRb
	jKv8MKr/r8E6ev942S4JCLt68W9hfDAiLHI47XEyzIUdCZRcmou6P4UpjK4EKC79
	Yh/voa4VX87cwO3rJ1kTqbR3C1lvbku/oB27uXb8/gAQV94ou7bfVQ6gywk4XzXk
	tjvdxT0/mYOgV5P8tbvGD5zN4OiqnFblLuI6irJhjwa4ia7sIRP/xJB358OxSe8r
	Ez6G0+PK8+OTY99JEcsVEygEiPn4C9TQ1wv922vM+auk+E81pEqQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hh73ka7n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Feb 2025 19:33:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 513JOMWZ030945;
	Mon, 3 Feb 2025 19:33:13 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2041.outbound.protection.outlook.com [104.47.70.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44j8dkana4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Feb 2025 19:33:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Al1yDzvtxqQRu0m+qXTH1wgS2CsD0jWPsj1EvBlzd6riXsEqvvMRwotr4QUfk6hBDSmOoein0ZTsRA2fY7CE/dXPKWgMESIZK/yvUZuhoYgYQTVjGbwykHoUE5kE9TLl/vhiJhtJzsra2Iedmi6uSeckw+rb5KgezhfZIeyV5DanBXOZOAqnFxyE8G5YwBtRKJSPcX7txZ0K2izmQMbe9KG3tYihrbBOpW1OHIgU6+FpDNHueTYF4TSpxhNJUnFVi2PeMttiLbzEc7L+Wq+XI9/qg32dL8zCx7yV1yk6aqRBKwd2Fx6RDMrnPF9AY86ISFxk/AfLmHRpZJ3/5PXRRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lCM+UMhMjfL32GK0PFcSRal3XtDGCCGMwuhn41+3aoU=;
 b=Ruw1IGEQWQ5eXT6P2B/v+3TXcn4mnclh3dKUzqGEfoxnCKMXuGF5qHIn93MC+lBTiu2Lrnxly2b2aJcu4+vtPMgQAk8xnjiQlCmiBONZoIHmkCSRx5vXbuR0Yz0rcGHuV8VIEA52iswqbGdtRrbO+eTon+U56TST5RpOGYl4xeKrEzKOW5RpPAR7QqkYwJZd6Ve0HTiwUzyBu4qMMYhA7NMBc1Xxe/Anr/N/zTDj2CfDk+Q8UBFDcmxWNW4FNBU28yCDor4T+2A1d84ocZP4GU7A+MVze6U14RNL0HWir5AqLidLZG22bwrWmYbFEwH/MzjNtTPJ7Kl8uQ/+aC4eEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lCM+UMhMjfL32GK0PFcSRal3XtDGCCGMwuhn41+3aoU=;
 b=WSI61OSXNOrjdksTl30MMvf775/i4OCYUMMEDCvaTrRiw3IGPwhhCqko9HtjA4gWkP2Vr9xor4At4yHJ6keuYoIkWEZapWTZZU1j3/EDXxq3n8+fPWrsYCH5yJyhj4r47g0EP061PZXHeeVwBMH8pT7E9AGIlhw2j50jBFYWvfM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BLAPR10MB4867.namprd10.prod.outlook.com (2603:10b6:208:321::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Mon, 3 Feb
 2025 19:33:10 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8398.025; Mon, 3 Feb 2025
 19:33:10 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
        Yu
 Kuai <yukuai3@huawei.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
        dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH 1/3] block: mark bounce buffering as incompatible with
 integrity
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250131122436.1317268-2-hch@lst.de> (Christoph Hellwig's
	message of "Fri, 31 Jan 2025 13:24:16 +0100")
Organization: Oracle Corporation
Message-ID: <yq11pwekenn.fsf@ca-mkp.ca.oracle.com>
References: <20250131122436.1317268-1-hch@lst.de>
	<20250131122436.1317268-2-hch@lst.de>
Date: Mon, 03 Feb 2025 14:33:07 -0500
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0081.namprd05.prod.outlook.com
 (2603:10b6:a03:332::26) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BLAPR10MB4867:EE_
X-MS-Office365-Filtering-Correlation-Id: 77cd99e6-353b-4a35-128a-08dd448997b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aXH2Ge6qBLYPz+8q+ZDV7axl9PPUkOXRTQakspBUsS+dCdT7/8pl3BD/Yzdj?=
 =?us-ascii?Q?AXnvG/vqSevCSxA/cp+H44PVTkh3DhQKMHNdiDCKWslwju2ab4bluU8vWxX0?=
 =?us-ascii?Q?7TsEEF95TZlEcsoWBl1KKaQjjW/QU9z4v2C4coHnUeqrlMwgs4MZAxzR9sFg?=
 =?us-ascii?Q?wAU8oDHQ5VLMKvd6Jcbnqu9bCCVjQSjdwqOSt1JoesYTqlcV7lk72/vHq3uJ?=
 =?us-ascii?Q?ONghOhdPVJ/aGsY0oqukqv5M9IKQW3GzX+P2puhB3cZC1qYBk4wHmOvEmTQg?=
 =?us-ascii?Q?IAxC3YeOy5jEZYx+CAznx6ohwPkhMDThdqW1fmKAC3J/q438OYoWEpbRNP9f?=
 =?us-ascii?Q?QJlq08hasYROnbIJmDnAl05FbHAdMLuXYO0u5xn3p51ZtHPYk4QBFvZwrhSK?=
 =?us-ascii?Q?YRIolul9EiNbPNM5zXtQSVeb/eD9RboPul1IgcTHuw+2F0bJstorJmrW9zIR?=
 =?us-ascii?Q?uTBXmC8d8Enpg6NRpR4R029bRzOKafPG5s30koYqWbvdfvu7f1W+6gOvytBX?=
 =?us-ascii?Q?ShL8zY9EF0OsFrDQsSoMUHjCp0CuQqOj5aFua0gO2sXE11T2XCJHeXj7JFuK?=
 =?us-ascii?Q?andPLXYgPm5VRLB+E2g8c8sy8L8/oTrGjXc4+tWf/oDTiXT0n2mlK0uD2YIz?=
 =?us-ascii?Q?w49/tgfWsXsmjiDJX3kvr+wXQC+E4lIEeayboAqXZKRaROiOFedEF0k5qi43?=
 =?us-ascii?Q?l4TbZzNJK0rJi8Mo2qltdQLKKXn2wYxYhdx1WPJiwlyyK90PI93OsucOdhLN?=
 =?us-ascii?Q?daKL7UeEiVyjkNVw6/G8Jjzi4p6cQMZBPf3SdieWDLLoR+/99bK43YuVfWgN?=
 =?us-ascii?Q?Ao48jJ6+74lAUtE/JOnHhjZCb9DU3gYjCuskHn6bCpeCJ/MkSRPhdj84UKtF?=
 =?us-ascii?Q?e1DavYAExzqJEsWMnEJODH1KNUaj+aip/8vrnbJPg7XqpY0xyF0x7z8sdZc8?=
 =?us-ascii?Q?PXlY6Mz7Vf71GPGVmudcxsY4x4yDMYi+5dAaCiK+5NKs9oe4wFDTGbDohwdl?=
 =?us-ascii?Q?GU5lBnyoKUQHtdJ5FFSd0fTF2gEg22SZEdjAzbM1XPps6PgJkp58R5P0C5A4?=
 =?us-ascii?Q?iGjj+56KT5eoEdBHaSk6F+fLdAhvyxiAxL6gZSMX+3IfraR6ZFemH5qZJl/h?=
 =?us-ascii?Q?xJrheSUEXoyrLtvpV/yeGYTLKMT6zpu8BWlqmSMnU/EE17EKHdSg45iMcIR0?=
 =?us-ascii?Q?vtAR/0C2rj18owSJSENLhnkEH1JvFxOGV9KJeCSILDsKLTTNJyOJOqwWBvoA?=
 =?us-ascii?Q?61OWl5NFlP0FOp7eFv0Z0OwHQ9tlu5PXo2C7EzkH1sJ+C3Gk4PMSX1X6ONUB?=
 =?us-ascii?Q?g5f92zoGqSOaernCADxiWkqLy5CClaZDoXutnpLtUtZI8ddA07Ct79PhuAJ1?=
 =?us-ascii?Q?YArs1UbN7UYIosqN6f8n96hY7vSg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5a1CKAAlQOLGXCPX4OH6YYZB+en7Zg5U3Dh0onw9FYSHegx6fVDt0W4ixi10?=
 =?us-ascii?Q?J8LRFoH4WKEna/KZnnA2G7/k/gdAcIFgjShwYKTUqxoMv3P2u8xlB9ouYnmK?=
 =?us-ascii?Q?fLP5uBOJeq8TQ0pt27Wyu22UTKyPf0gHBbq3O5JOelHm4rRVNsz+jIsTWIIT?=
 =?us-ascii?Q?756K09x5sfWMs5hs/c/vre3sy/rLYpC1y/XUAkcVKpCNwNrar3vGUlt+JltB?=
 =?us-ascii?Q?EwmKJT0KJNwK39ow3VGrdateuI/uawzjTEBW7Mt8sTh6yXoD02pO5ExyKIin?=
 =?us-ascii?Q?Bryxl6aLXdj4xijtuRoLug/wi9mEFdpu+mzdoqA1Y19OtuUEtN8+f26lMyqQ?=
 =?us-ascii?Q?VLiQ4vVml+sF3Uzwc3pRNsJu3Yz4wZewHAseMEkzmHjmV/lkm0e9YH5RbrdF?=
 =?us-ascii?Q?wgrtC4eDiOsb4TIZHcku8L+YeSEPCdq2gLdxk5cQkpjHzIFN0doD9wRJfE0o?=
 =?us-ascii?Q?w/ubbVDDDHxI8pYAzjdz/DBj+ykN/sX8803ofj2UgnzIe/YTjgBfnNQcKerP?=
 =?us-ascii?Q?trSuGQNCbcH9DIPMAxAsJ2ED0NI29BGWcU6hisxA20fizyI17CY5D4kuHcg9?=
 =?us-ascii?Q?IW/lbF8nzpAWvT45FxpWrlhnYSt9ThXVnUm+dN2sls9FgyohVelXZvFjTYay?=
 =?us-ascii?Q?EE8VsCKkj4bN907Yt9STksI8UcHB2iu3E9XvEZ+eMt5XxHQfv2o/RrJZ1fF5?=
 =?us-ascii?Q?ItYpkjBfPOMxMrB9FfR/VPWoKGGemgSQQN54mgoE4sWIKu69FUUENZZ53bll?=
 =?us-ascii?Q?8Eis5GCzONT2kV6EhcJtalVuAphqZsugqxrn9oxyPyzlLgial7vrocsWxCBm?=
 =?us-ascii?Q?yq0fZAW8PkDyg4Yq+Oo/PuAcXcPFr8NcoXS7ei2SDuL7ZlX9zVZAcx8CJkFa?=
 =?us-ascii?Q?s9k67Vf6t83zhxt3xtHjf1EG9YsxtWIQYEvxP9TygvIJN2+kkVQ9BzImMQtX?=
 =?us-ascii?Q?71wFSwLOHy4FCUDPhRpFinK5/In7H/ByGTbiy/FWv1ujCbkR7bZ/eY13CC3H?=
 =?us-ascii?Q?EqS7htSPVek0TOEfTpeTvAB0Oe8x3Zh8lfZjZIMLLacUWgisgjj8N3F5r5dy?=
 =?us-ascii?Q?k1a6fNLWdKxmeSvNPTJ7FueSeiKMqxhy7N69t7FohjjLwS+UiWv2Gk/lL1Yo?=
 =?us-ascii?Q?xhofepo4uUwXlf1ezELtsvOMfDgtccTV0DIIZSVCY6PPSHIG5N/S1yYv9NMW?=
 =?us-ascii?Q?8GK/4HGpD4V/4Jg/YESjN48v2vJ1ozSk/ocV0Xq2ggX8ElKmEQMSBZBgXGFV?=
 =?us-ascii?Q?Q1vL9oYLK53Fcw20RGALYrxbJrlXjnuDXKlxoDV6TFTmd3oTt+7z/AalAh1j?=
 =?us-ascii?Q?9999T0L87SZL4mFqXislwbMRBwoIu9HWocl5Vi6MElCy3xuq1uO/Q5azBCGK?=
 =?us-ascii?Q?Pvs7q7L6WSeJiQA415wfIb7UEBbXNHWlLBFLLRc3Il32bAteNqATkoDgywK7?=
 =?us-ascii?Q?sOhLTiR5Ngi9fKFRzWBHDotbm41D5TBx9U3j2QOj9y2ocXBCimfPXQ7JawB9?=
 =?us-ascii?Q?go3AnVCFYqOlbDV773H88kOO3poAX7Z1DH8eneJVkSQXNDDbPiXK04WH5zjm?=
 =?us-ascii?Q?9C6nMpwm4u4pvEDpZXk6bCW/PvB0ySSJ+PKJemC+KowVlm9vt6ghgY9Hhx5H?=
 =?us-ascii?Q?/w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	P+Sa0mo9Th/ZvJGJG7odbiZldTam25wGDszTPnjiy/edpED/1baUTFdL8pS4+aa0XwqmkOgaY2lG0VZbCYNsDERabE5SF4ly56shJk18+wkIghdA48gWaLosqC3NL9nkFa0WbnfGWzIEUfdkHDYLOJwgtSvlyMgEpYIfejVYn5AmhbEnjWiVoTsXM2S9qQf/Y8R4UxP4mkVQRFFTV4uSjED3DKAoG3M4Z2+F/knl5/oVtv7kwGKMZDZ3tt1nzei2bwqVYKlPqTJQMaqeHNXI/avy4y9X5BHt8PmsEs4avi65ZSfum7JL6vFMlE26I+OchxNfSVbJmCpdwsj3vLfFqPC1Utb/Fqm0qEdTjr881r+hgrhNu154xTe5AafdYalDW6lW2MPyiyGbeuQD8AW/M5/AHfTVoIF0Z4FOhy8INAHaaZwtRjGkJpRXB5iHbXAag2+b4Hdk5IRjYCT5hac2bospjI5icCBJCq2ltYWu2vA6QJ9uhewgezCo4+scTtLEf04BPrDq4gg5eT5iQ8UKpxi5G8uM+vE9srkmP3T3lefh6xwjZ5Fgj6rKqQ2nQZpzSW+D13yx+Cok/P2xjpJyGO5GdpJcm9fcVSWnI7nAOUY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77cd99e6-353b-4a35-128a-08dd448997b8
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2025 19:33:10.4238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nEljbtZdRtfoN8k4yjgqj1+n0z1LM8X13vXKWDrymzylYt3mS7IoS4Y8THh7VGfkI2FV3V6qTulvfWWesajZWFHbni7A4Ia6mqe7fdIhlFE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4867
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_08,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxlogscore=950 adultscore=0 suspectscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502030142
X-Proofpoint-ORIG-GUID: ZL1PwyM8pu8UQsahBLHZ4SyiTT8fhzqn
X-Proofpoint-GUID: ZL1PwyM8pu8UQsahBLHZ4SyiTT8fhzqn


Christoph,

> None of the few drivers still using the legacy block layer bounce
> buffering support integrity metadata. Explicitly mark the features as
> incompatible and stop creating the slab and mempool for integrity
> buffers for the bounce bio_set.

With typo fixed.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
