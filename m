Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91A11876
	for <dm-devel@lists.linux.dev>; Tue, 22 Jul 2025 03:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753155838; cv=fail; b=A1krdQiXW8IStD5ihuqWlysYapTASZpNIDsEypvHxgijRy51Gx8TrZuuaNPiXmsLLP9jM9hYb0WDU+rYo/D4dtkJKLOXcQUDMRy8q62bpfYJU9GhLa/RKvvTRDxTb6bZfGcB1CjYn7zUDyDqMVuD95jjrs+HGnZ4ObYgSZw3Hpk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753155838; c=relaxed/simple;
	bh=PctjxJq0YoG4HuZUspY5v3KiRqs/coDUxU65Nv+l4Iw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=V37o06XHLX1Uqw+WJJXIcC4sUAjfILlqw378TCBfYm91Se6IWlD0F0JdOe/NJwBsyhcO8orprSVGoSNU7jCcJ7Q8V2RsYm77L+a5xckhSO7oZp7rlm1rHYsLR+akxfhJFCAC1ypq1FG0Gqb/4H6Bd2bmMhFKd64g6IxIW8/SpL0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Hp04Syte; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UDN9r/hs; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hp04Syte";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UDN9r/hs"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56M1CGM6027669;
	Tue, 22 Jul 2025 03:43:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=n7sTH875HbTafX5IXz
	wHYL8f1CoY4GoICnLVM8bUNCw=; b=Hp04SyteZNlHbDGODExBtMkkGsz2N/LcKC
	9VCBCQ9bpi3/1sVwOEjcl8dYFAhXCQQFQEnsOlset/3A28TBOfhcP2KXOTc8VapM
	7GFWnspNgissF97axVJhflij2pzXezHsz7lPCvZb+OC518s9kGvws4JfZeOOfOJr
	Yrvfxq8nOpdP1xetGOZMiCFzwFAks2eOynjI51GpiXlyBagaAc81EECNClXMh6Xo
	lh8Pek3SJuON3Qn7J8jgPGpiBtdrboZTIkM0B2Wy2ulwaB+uTEDwI9dSIMBAftTw
	dJa17QkP+9h0TwL5KDOKmr0r/C8xcxcvbJh7tNlmYQg8EW/0ewRQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805tx4a8e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:43:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56M3aKEn005877;
	Tue, 22 Jul 2025 03:43:38 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801t8t1f8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:43:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l5nrtno5eRcOoIZQ0pF9M410IZZbxyw49+DAusqN69iBY+E2h5B9rGwry9xxi56hF8anm0fqKAifubCo3DFrgg5jDK6G4ffR8MqLQCZo5Iv54tYdakP6TJhSGqXLSXPMDLaMTAIG8mUQWO8ZYJsqxEU5q7UTNMNmiGpsuzi9fm2SUNO1/ntH2Xdet2tuLEyoabttHY2f2JIh3bj+pPMKJa2fRES/dk6JLapGtFZfu3ODWA/sjZVZyWL8ql6crDiYTc0FJitQuSGjALEY39XnpUylKhCFxdb/to8e6GCXZ0A0VAEKIztLIPyQDx2uagmdHqEATlzhv/uRN8l14dwnBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n7sTH875HbTafX5IXzwHYL8f1CoY4GoICnLVM8bUNCw=;
 b=kr3o+99k/wpuElYjTzFoz1aH4DdzBzdBe6tUFGgkpVa0gf7KYyGtR3hYpkM8qH2VhCe12WdsP9ZVtGjQYtqBpFQrbmLPqTemJHMumJ55ln8dqV/T6IQJ3ZZ9fgCrr3teSF22+xl0bD8RmdrM00wJ0BmfbCkRSY/rm5tWVwiq2b3y+D4sCn5Ajx/75Yv15oy9R7Z9boswTLbeYEXro7wLWwTZ1KmjKt7xzwH3f+Y71aeNgV5ThqlGCoZYnjeXq/m89c2yF1+noeB7zx8ilCvnNbVQhNKyuE/gwLLF1M/p1j6xc43LpxLrazUJEH7ywiJs3L6pD3U1IDUzOCvMPbw2mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n7sTH875HbTafX5IXzwHYL8f1CoY4GoICnLVM8bUNCw=;
 b=UDN9r/hsJnmL0GJE1s/IguyTyXhwbqa6LZrgIT5JXQiRD5jRtKggglBYkjy4ZO0Zx+LSfZU2nlx8p6WmOyXZ3CiQQ3QVjDCzpKmLauH39AJMrZePL6p/Deho/uVc3GSRnKTw8YNG1R7QkRSf1dXh5BO6RzRPjGnJfgv2X/81Yz0=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB5676.namprd10.prod.outlook.com (2603:10b6:510:130::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Tue, 22 Jul
 2025 03:43:35 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8943.028; Tue, 22 Jul 2025
 03:43:35 +0000
To: John Garry <john.g.garry@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mikulas Patocka
 <mpatocka@redhat.com>, <axboe@kernel.dk>,
        <agk@redhat.com>, <snitzer@kernel.org>, <song@kernel.org>,
        <yukuai3@huawei.com>, <hch@lst.de>, <nilay@linux.ibm.com>,
        <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <linux-raid@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <ojaswin@linux.ibm.com>
Subject: Re: [PATCH v3 5/5] block: use chunk_sectors when evaluating stacked
 atomic write limits
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <cad33609-9a92-444b-9ff5-5f5a68598866@oracle.com> (John Garry's
	message of "Mon, 21 Jul 2025 15:09:24 +0100")
Organization: Oracle Corporation
Message-ID: <yq1qzy8x5m8.fsf@ca-mkp.ca.oracle.com>
References: <20250703114613.9124-1-john.g.garry@oracle.com>
	<20250703114613.9124-6-john.g.garry@oracle.com>
	<b7bd63a0-7aa6-2fb3-0a2b-23285b9fc5fc@redhat.com>
	<f7f342de-1087-47f6-a0c1-e41574abe985@oracle.com>
	<8b5e009a-9e2a-4542-69fb-fc6d47287255@redhat.com>
	<803d0903-2382-4219-b81e-9d676bd5de1f@oracle.com>
	<yq1a55edu8i.fsf@ca-mkp.ca.oracle.com>
	<cad33609-9a92-444b-9ff5-5f5a68598866@oracle.com>
Date: Mon, 21 Jul 2025 23:43:32 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0021.namprd17.prod.outlook.com
 (2603:10b6:510:324::27) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB5676:EE_
X-MS-Office365-Filtering-Correlation-Id: 07f1152d-efe1-46d2-ce90-08ddc8d1ef85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rnFom0wzZaBskntMQS0qmvmqtb75fn2Cw2ObXi62KVsjeHTGMA8QlR8WlvrV?=
 =?us-ascii?Q?jp2cG3IgFkv5nOhk4Q1e4KAOz6gWFtols29p2LtuujXcdD2uJoRHZG0/4+OM?=
 =?us-ascii?Q?oX9UeEJPijPj2YGCs+/MwwmH6NP21z5JjMwIU+ywhD4nhATtPprVIuOgRlIk?=
 =?us-ascii?Q?gDnoqGab25hx/5ss3l6otu85CuWup15FxbPJ3HpgYcDqPDS1qJbOm4Y2zUBW?=
 =?us-ascii?Q?tgiHA2W4me3q349MfGYqwz5S+iJga7QNpwvgWy4cs2TEbJQBG4Qj9VttwNbs?=
 =?us-ascii?Q?i86AbG6z2zxg4K20Mt2k28gq7xRZxLcDg2GS7pMMRmHSHiWq0zWnFSE9tRoT?=
 =?us-ascii?Q?rp3Y9p4l1lWQIQ4bf/XThlPLjtFaYWVs4q9ONyAiu4VtTKf0shLP9sHiqpXI?=
 =?us-ascii?Q?fZCm4nLEcr3X0wVZgq0doGLOICRmP4TRnZfzLDKr4KCizyzb45dARjXVBMcC?=
 =?us-ascii?Q?MAq06uGPnYJvjBkp8C4I24BTK78TNdNPjwsVOZorzMgxQeCUeEi9PlaHLjqM?=
 =?us-ascii?Q?mwwKX5h134MUzZ61caXh6LKnsfkAJ4rUGou+zZDENuHyfM8ZGIRSrVH/jLEz?=
 =?us-ascii?Q?5MGA38LT1wAjN8KEeAGEpk1VaM9xrzffUxEYxnpUMGNMysP2mgFYSNg+Nqh1?=
 =?us-ascii?Q?Fw1nq9VVPG8XLcpi8DdxsiVUZStqnue9x2EAKE+cog8vdegue3TUd/HQKOIK?=
 =?us-ascii?Q?FoA2Mhef9O+td5yzP+lkrglbpLTW8CTUxjpaS7H0JaP+GLIAPX6aEEJb2uIF?=
 =?us-ascii?Q?oJnPnEdd2fyjmcAhiZARNkh9s5ZOi6rK4T+v1pjEjplmEtRw4MRgRR2n+S3q?=
 =?us-ascii?Q?kmbaURadmZ4v2kLItrdnxsqQXvstKjVJogO/TedwQTOyYZEhXeKWZUYh93kA?=
 =?us-ascii?Q?AODzkqWsJl4xXJMRIBf6PA17BRr1kO7iuSra29fcFPdrKvLmjby7X+kCvOnx?=
 =?us-ascii?Q?SsNJSI3H409nffWtlLVeYZluXrgvllI0PIZQH0F96kwTp/UYYebQC8Q3zv07?=
 =?us-ascii?Q?GNwHVxUZgCnGwFACuwMzpDb7mFk4CHkvazQ8x3px4sBhvl5beEnNDENOvhhJ?=
 =?us-ascii?Q?lnXRBB3eQ/KEe0MWFk8jq4rc9jlCpwU6yQfASOjrSBAZlK4IpIyA7ZUn23oZ?=
 =?us-ascii?Q?AHhvDUmb0UWHizpWEGhs9a+Y5xRDsHZPEHnd0fSQ8zdzvNbKf73SxxjEjF6Z?=
 =?us-ascii?Q?0JaPoXGfxQHARhXomjqbuGZaJ79oefz3AuMgH3bdum8mj1X4YMIH1EAVsvGy?=
 =?us-ascii?Q?CoCGFLORCzqI+ja6cdeXq/NiFNExX2rzKs0WtYcKKAJzY/8rDn7p0UozVB1S?=
 =?us-ascii?Q?dK8zo1GBng1S15b1DDhB3s8kCB9LNP9jbZ7gc0v8zMj8xrRnYfPq2sUnUTK4?=
 =?us-ascii?Q?1kU35TSZZ43kpw4B5yrYG1wF1s8+CvIj4EiQOuO4hQbHu7TF8u+QuuGkV9ft?=
 =?us-ascii?Q?p2p49CYmtVw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?i5ZShUCNsDqpfomi+VRSrk/BtC+RdG5YQvlSXfSKRULDsrKqCO6KmQ6h3MBH?=
 =?us-ascii?Q?CMT5BY5Y2/hb75vngrqcbEoQD3H7zA8ASe55kts5vXPNVmlzy4oM2C2DA3/S?=
 =?us-ascii?Q?q/nALKyamPJfZH1GZgpVqoLTkN06XEU7E1c8Oiy8MM+YhmOzMiLOsL8f7RRj?=
 =?us-ascii?Q?eENmQWijrso649d82I6gO+yE8Ar8dFpTAKgyyukYY8sEqd0H88tDixwUTlm6?=
 =?us-ascii?Q?j3+QyWKKMqoqw2U90mFi8Vwigvf1kzqBjN9QXeM5vQOhMGnjrKU1Lt4fUbXE?=
 =?us-ascii?Q?TH2zbW0nI/w3+g8U8K4S+INkUy1hChIpaHPSvOUiHrBDp6xwrVasxoBWcMuI?=
 =?us-ascii?Q?Ao0fo9TSZkeBxQJQTxD0CkcSY0a1oQ7kMkd32V0d5SjaUSlty+HrU63iCx8m?=
 =?us-ascii?Q?Ax7YgcRBYVovdPy7V1TyhEjVFku/TeNThXEe4CcV6sFxU+tY4ggu5Q7SiCpF?=
 =?us-ascii?Q?CCQRJOlbZExdceLzQi+8/taKXRp6ZPpk7AGcCKXQjzOpXNs78Hv5fjQDN7Ct?=
 =?us-ascii?Q?DRSpRvo83YstYhXvBJ8cOJpI7NCMZbUZCr6eUKwDxTx2ACKLvw7B/QLAGDk6?=
 =?us-ascii?Q?gOSrGjjvHK0MrNT7jPvzFxuk+337yokcyctqMjgt4SqMwDptauUX3n/dCnZn?=
 =?us-ascii?Q?SuzRkACUntQQRukm3bKfMGOXXMfwwAf47lTPYk0jp+W40u/J0NDDprBnA8Fq?=
 =?us-ascii?Q?cirzA4B/st0RaSjRVDrOnlIiCExrcb4ygGWuB3385vDwPCeaYhRdy5KPMDpm?=
 =?us-ascii?Q?L3OxB2xpDpTlgVrFdVPAIu21XkMJoBn6wyCyqcG47AZ9vn7osxM9CrZ29mFm?=
 =?us-ascii?Q?nCaMsXl6Gssph35eDsVkDWqCATfGXg0FmvEdrs7CcqTe67sE0XsA6hth2jsh?=
 =?us-ascii?Q?Y9m3wE3njZTCf8sqe9EIe1BdGGC22MBTPnuoOXW+wxnLFVBhz+bUq/EkE6fU?=
 =?us-ascii?Q?QH5suI7QumkFOzQM2ViVUrt/0I6Qfr/qYMRw/9y7udPkHXKrp7H1+xFNlU/t?=
 =?us-ascii?Q?31l3QT/qB9jGPlSXldqd1Pen0fW2BsRqOrvurUcZonPSa0xOMewWECkdDcRL?=
 =?us-ascii?Q?bMDApzNFD6W13HA8Eo7WuU21IEUBTqdWZ5LJNFswvKUd1kDXYHzvPZq9dEUu?=
 =?us-ascii?Q?gcBZ0SHMJfPz3zjL03WOCk7zrdoSgeQzUOYaiHSoxXvLxSzuTpMXS+vNQwsV?=
 =?us-ascii?Q?+2D5KQ5O2YXe9sBlA2aH9IRu84mkj091t8lWd2Zu3kqQJl3aF/BYuJsBvuzT?=
 =?us-ascii?Q?OLsaNJs64492SBNFayItbwl1I6+6rMo/OBYjIL517BaLkbyROUCf6ZKE14Zs?=
 =?us-ascii?Q?0QBHf88g1xD4OPnT79cCq4bHIHC9WSaA/XxX/kf2tTJ+3RgzTS6H9AbSKkPZ?=
 =?us-ascii?Q?Z4TkWnCWlYkgqHohLZn5SE2d82mKXPVFnp8/x0zre4Tsi/hzmbkBFy45RW8N?=
 =?us-ascii?Q?actfXVA0jHaf1ETRyPAC8u4XpImUkUsMGk6XE9JqKzh3fdNVlKtqWM3rWfNs?=
 =?us-ascii?Q?zHwFiHdUUxI1gQAYHTKFMHOiGailJmFYHCxR0SeMGC8LuuiMa9gjOMC3XQZ5?=
 =?us-ascii?Q?1u62TS9EvLBH4UJU5anLPeg+f84W/Xe3B4W0s6i1T9HYGSjXs2SqJiPpqH8i?=
 =?us-ascii?Q?Iw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+IFj25a7j4ZafQ3rPaKNRHlNIwsqAi7f8Vt5DB6e1LU1x8tYMJSe3F6LETFYGbhN1Lna+1rV8FTb305R0sxWqBo2RVp/Ija2Q/mC/Ck48qjuP+JHMMpIchKWPIKBL6YtfQfx4r8ere4hpBYPv4HutnxOnfFAGrJhzhHqDP0/NLz3mlf0VTUVX7LQQmDgcmM2Wt4gDZvRsQJTl7RH5W3ZHps82pViswyvQtuC4+UotpByzdKH96JqiAxovqJr5csTFnuqpU5U1vKaHF7jRbxMMVBMsbad8rnRhsqkEywyI0GdGBi5eUX2FJa8LPHnAeclnmbCkdZ+Vdyawdtf/gu8VjY2cHTuGd5DMCiGb/VIrZT1IvYFaS794ZatBNq4X22IEQg2y8wiRrrL4+/SAVXHVq/9zEt3sVZSKF82Jk13JkbMQ+zRBMR5xQNEPt3i/cEMo6ENEXNkf9HdPwEHjYuywbWAD+y3Aw1xCS1BLPOMZqtnZeaGhRHGpplju2obBkUSgW71YIVPwqk8soWmsuh7HqxPqzL+rpSsZj495HQlo6fodx3yRGHBTYJUNmSzGVdRGAi4JvjIjK4j6jIizZmIun69eEGsxylkzVpyZiNcnOQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07f1152d-efe1-46d2-ce90-08ddc8d1ef85
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 03:43:35.1097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9b++ArdI+/Olk8oWUJDbRdmS9/opXR4rIc0xMp6KGeWYYxl9GSB0CT+E1ge3b2RwCPsZ/3gH74KmcrlZWCTjTY/94q4P7yDbGC2aDniyA4c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5676
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-21_05,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=751
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507220028
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDAyNyBTYWx0ZWRfX5gh03Oa0h/6R
 29y321CiQF7R1Yt/HJRmi1gSP7pHowzJ/82+uy1G6NtdbW3PYMoIN7C12+9oZQxDRLyGKMuYFAu
 tQ+y49cMB+p/qQ0S5DbyNUol0Pm3g/OFLoQSyXnWT83+CQMl4QLY3/YYkb8wpx+Cw52L7/tGM9m
 rGZBmbZgNAl1q2FbI5yYGiwb/FE6HUZ/+FL0FmrGPUuoaK5VYGFiOwCb4X0bSLY98/thlYkJ3i7
 8wsmz03c0Cfsmv4Rd28dNacMOiRyW9DGCP/hkKETaLTmKUlbhA54Z5+cflwneMFfcpezGF5olIR
 vYJ0zI5ja00nS/17rSNbsdnq9O5Vdqu/D+9oRz5kdFwmYvrtGwNL1hlLfWINf98j1NsoIQomn0I
 pheNaMT9461nWxqPE3rT5uBADLYcVXZ8KAtLEgDAknDG/5lEgn3eHpDAy31tXxfnKrrCelE2
X-Proofpoint-GUID: 7gmgo-g6rze-WVBcaK8MMl6e_OqvG7lr
X-Authority-Analysis: v=2.4 cv=IsYecK/g c=1 sm=1 tr=0 ts=687f08ea cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=a31PYApw6P84EDBIWn4A:9
X-Proofpoint-ORIG-GUID: 7gmgo-g6rze-WVBcaK8MMl6e_OqvG7lr


John,

> Does pbs need to be a power-of-2?

For ATA and SCSI, definitely. NVMe could technically report a multiple
of the logical block size but I've never come across anything that
didn't report a power of two.

-- 
Martin K. Petersen
