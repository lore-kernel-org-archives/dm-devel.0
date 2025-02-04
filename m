Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E635588F
	for <dm-devel@lists.linux.dev>; Tue,  4 Feb 2025 03:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738639857; cv=fail; b=fu+QDNbqxG472Glwfv6TmiQBlzVyXL6dmyIfVVQxzKh6x2dWy7+uAgTSurLQr94lVj4ZmnQ2tCQKANHYVoYNfdZWJwHIDNmNBOMvCwb7o2PWN6hiIQQ7Q2rP0B3Zz0BoF9YAuJ6bjkgRAN7qncd3xv5fwTqR7lmW2tSME10r7ks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738639857; c=relaxed/simple;
	bh=o4WTRy40Bqd7dJKU3Fk4x1mlplg6TGvGls7NKOwh4Jg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=HKO8gIM/rLxOPEXbRsfI3frhyRioV5nFa8ZxGv6AcOl2DR+z8Nek/INWMZo7vpGJvEJvP8XZdtU+EoageMoEYOQ9U+/gigM/KCTD+w6vdZ/MublXl1phSHN/822cYHOlI9AJJ3T0T6mdeLdBntAtlGpAcL7olVfbNdX+wBdLVIY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VHLzDCQ2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pOeguoNo; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VHLzDCQ2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pOeguoNo"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5141NJ8k028875;
	Tue, 4 Feb 2025 03:30:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=urZVscalcIV0WvupRQ
	8lEy/RXtV3w4XTwCyoAkHvfLY=; b=VHLzDCQ2A1xCIG7nGPQg64KMHhLFfVR4sj
	RiFUFXl2FLjHIq4MshkBnVxM6tyOKEIvHTaGe5c6kShGMht+3xsVIhPE+rRJ4M3D
	HOJ3eOho0cVb/PtwHr3z6xbhm0elkTt2l4i0TZckjRs0Jr0gezWXY/V0z/03aSMP
	4LsnStwO5lH3jTToYKcI4ItSNM07BSkjKRsPDFnCfamk+Hvv/gX9Ywchl3vM+Zhn
	pReati9wVnsX2Y4IAqLj84q8fFe4HPHjYUgGTSC01KryPc7XHZW1sv/Ib8eWzwPE
	UI0gkqX3rjy4QGoORROA3dnq/prXKIVCg4uK5Tatzxz7JLJES9mA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hhsv41kd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Feb 2025 03:30:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5142UtFZ029923;
	Tue, 4 Feb 2025 03:30:48 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44j8p2f1v0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Feb 2025 03:30:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MSU/02ByfAmck6M6GjAq6b50PiVi/mrcsPLHYZ7a0QWtPwEw7fzeHzk4cJwJGZhIocUQ0YrLyLu36jai7xABmOEKVUdrIzI8jRnJM677Ntw9cS/RtCXugrFEDb74nPp2bIlxfH6ntg9dlEfc92pWO9QdCHO9nlptrfpD7+2rrHMyC2WMkGNwr1pG/bA7yiIXhEwfZu+JNj9DIK/9PhzIDcscBdWKiKiDcwqBuni7LM+tHgjKAYhtdPQyteZwvqUrhW/XvZXu5Oy7stmKVyb1nBVuUZW4/uVN+YTT5xzL4UFdmwfRxZa+YkOPheTQ07ZvKiOcEjKWeZk1Wj9MZTY/DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=urZVscalcIV0WvupRQ8lEy/RXtV3w4XTwCyoAkHvfLY=;
 b=TDR3CwzivYtSyOAICpwd/RbvP/AQtMGoLWjlcLj76UFLorTClzgM66ojcvRikfA5jjXD8OcGX4Momv474vsBwYMUhhM2h6T90koZevX7JxLmbbJp8glJyLNLA8x+eyLOBnFIH3m/0jkDnkmRCrLwYm0MFXVOYBffxl/1SYOP/LwE1pIV/1/oBMBm0UloZihzmNNTowWTDibYls8cGjQHS5Ly5vDmmR03I/EUFd3TyMHVm15RykWViYs/HtPp4IdHw/46HAhRoRKerviaueA50j7GfZ5b+SHsvouNURMVgwPx1Gv2hQUtmhWSJoU/B+Fh7lFW0vVdVs2olqHwlL1S1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=urZVscalcIV0WvupRQ8lEy/RXtV3w4XTwCyoAkHvfLY=;
 b=pOeguoNoEvCkzcNzahrPtN93DSjWu8gsLB6RmpjW65MxSFOJAeB6P0Pm1d5n8rC0VYBlJh17gAXMgKNNwxF9f4CPTjRDBTkMP4Ba6DzfFZw6RZ+qAIA7sSlTGOvOLkVAwzZ5/Hqj4jT5dYJ4TzfuEzrVMrGbUkAxtqQU5lICx8c=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA1PR10MB7634.namprd10.prod.outlook.com (2603:10b6:806:38a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Tue, 4 Feb
 2025 03:30:46 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8398.025; Tue, 4 Feb 2025
 03:30:46 +0000
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig
 <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Alasdair Kergon
 <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Zdenek Kabelac
 <zkabelac@redhat.com>,
        Milan Broz <gmazyland@gmail.com>, linux-block@vger.kernel.org,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH] blk-settings: round down io_opt to at least 4K
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <28dcf41a-db7d-f8e7-d6b7-acef325c758c@redhat.com> (Mikulas
	Patocka's message of "Mon, 3 Feb 2025 22:05:27 +0100 (CET)")
Organization: Oracle Corporation
Message-ID: <yq1bjviflwb.fsf@ca-mkp.ca.oracle.com>
References: <81b399f6-55f5-4aa2-0f31-8b4f8a44e6a4@redhat.com>
	<Z5CMPdUFNj0SvzpE@infradead.org>
	<e53588c8-77f0-5751-ad27-d6a3c4f88634@redhat.com>
	<yq1cyfykgng.fsf@ca-mkp.ca.oracle.com>
	<28dcf41a-db7d-f8e7-d6b7-acef325c758c@redhat.com>
Date: Mon, 03 Feb 2025 22:30:42 -0500
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0074.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::14) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA1PR10MB7634:EE_
X-MS-Office365-Filtering-Correlation-Id: 847a098f-1b22-4bd2-7e00-08dd44cc4f9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+Z1wpa8tu6Q8zpnVLvzKjQ63rT1IIVsFDQNBKTxlEsXv3/igl/dWDHFjxF+T?=
 =?us-ascii?Q?DBo9Msv2cBohE7UPZjUHnfdbvIYk1LWQWPY1Z8O998g3G8sOfcepCfwTy0Sc?=
 =?us-ascii?Q?wBUiqS3OPJTkXiXqSt27LypARvHEMhiKKbQLV+CzSn8EginbGr9PhgRWzVJu?=
 =?us-ascii?Q?dJCPE2mp9L0k9z1aCbJRJ9w1qf2Zclpttxu6w1/z07xe9yJ+uHBbosYPKYmo?=
 =?us-ascii?Q?YINIMkpTXie7sp1pLZtP3Ir8dEOMrzqdD+/a+Um+UA779kLEpcNzDFDCSG5A?=
 =?us-ascii?Q?hr21WmJhCfyB/qkwKQ1yB7NQ3jSFRnJZ8v76dmw6vA7julhpcOuoAkboWFeK?=
 =?us-ascii?Q?0IJm1N6SK75jenzLegi8BFemrhr/YwhGMKJNmOJZhSbdUjB6cl11Uxa3XM47?=
 =?us-ascii?Q?dB/soYCHapub0FF0T1xFeAgNDDnP+kCfC2uyn5clQx9ZW9Y6h7roqSbHdnQ5?=
 =?us-ascii?Q?IH4CPK6heKsL40Xonz+pgieQEo/fdWXLXCIN7Rsu8aqUE2sSWVV1dEFChPkG?=
 =?us-ascii?Q?Zx76jdpzBg9QfxGC1n9jgl7p6TPFeAp7KsWOLvK0h9zhkXufPmxiQ4+nwB9+?=
 =?us-ascii?Q?6TAz9Hwj2RDHqnZXCy9dX0RqtANBGC/CBdv5uxBczDeKSYTGOlgI2wbunwz2?=
 =?us-ascii?Q?MnsDMnBWc+nqFaKPnsZIWyXyCXjObzrG/ubmxxfGze02kQnBcvddMhwGy90s?=
 =?us-ascii?Q?sKvqG6roS5KmrU/hwe9LVQ4F6zRU3XFA/hBxILcCPis2S9KBmsEoCN7s5S0q?=
 =?us-ascii?Q?o37FV+m3bcSS1Bu7xkeR1Arm0G1w4GPc9E8kOwmmLn5BsDLkDZ5IegzzK9rl?=
 =?us-ascii?Q?I0MZcWJ9WG8yBlnU3XPI2xY7uOAlCBRJxePChroMbj2uioNR5/aBus0JgvF2?=
 =?us-ascii?Q?R+IyQ4Vf+R83Hsg3v4tzSnp5JSSBK7ZTKZkweL2+zuPvQ1JltFOfjZbyP6jh?=
 =?us-ascii?Q?pdVQU+/8I7tmSkM3jcdnrtrI3FfUzW5dvjnRDqAQEeuAtvGKi4mlDJckAwJc?=
 =?us-ascii?Q?R3KkqSuYOUTaOMyXv/FVrARPaOK2y8RF4ifVznw0oA2KvOvjrXa8tRCf/b1h?=
 =?us-ascii?Q?J7bdkLRxZxwpaErq262OJ0v/ZtDmZTmiYTiljaG9XCSIkcojsjcxlDDRH4U5?=
 =?us-ascii?Q?kZdlszvxl/OeibLZ7Pw7LjrwFUe7NnRmISn/ri/fj96MSE98VE8ubaZl7NSw?=
 =?us-ascii?Q?7T9HheUZOt2zK8huU+X4b75DxMJcF0hZUam44GUuqK/vhXGUmhz+XioXdlGv?=
 =?us-ascii?Q?4uSSG7bSLbxOiHSjQKNv/UJSTTg8omnhVkVsnaVGJCEt8W0iqFddsxDnAk02?=
 =?us-ascii?Q?9W5DSse+A6x5dqRGxobn4NL6U5U0Gq2XrmP/s+B6sq9wOAt9XqOS9DJFqwLr?=
 =?us-ascii?Q?l5AIVd1/Qa11x15pxwl3Cdcr0cJZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IeFBQdmDlq2WCfuUKMDEw4gJ4PKgXJxjQDhx3d9AdCER4YPsEE24OBzZac7U?=
 =?us-ascii?Q?4eoJEExAmCZl1OhCQbDN4fUjWTX5o17mRLejGN6N3jTSEFjozxbuJZgMrw04?=
 =?us-ascii?Q?Ae9MN2furayVyblShTfdoMpy8fncra937TxXUnn4utj9BFr0Lsu7uPTVjpYX?=
 =?us-ascii?Q?JuIFBYgntENPv9dSCY3D+7pvYiOCxvKQcVu2roOaQIYJbHLxTl2RRJ8voDBm?=
 =?us-ascii?Q?L46YoYQ5qijs+CHb6l0SNTvRo487YRt/VdiT8L+SYbC2kz1e02k8WZ289V7S?=
 =?us-ascii?Q?ql0yBP2rBdCaukouJGbuTnz0uVP8BvQeU/QCGSZH3Z111iGqygGothEGoYb9?=
 =?us-ascii?Q?5JN1+lv2IhJ/Z1TYKgE+Ql5V4ZGFwvZbN6CMxhzhMGnz/mi+LxlBGS8MJkAe?=
 =?us-ascii?Q?YI6sZMWgCj+p7dEbg1Gz0LIQhkHnZHYPqgXT+7a2II4xoHjTF3nsvwTSGLxw?=
 =?us-ascii?Q?iN3J037NLf19NAi50toGH3SonqcLLIRQIOdOr2MWSFQHkpakCIVgtuGQRD/H?=
 =?us-ascii?Q?LKt05W5sYmKHHWPukR1ZNcx+n4jT89W0pjvODk5ICbEt7nXzzdnfPM89ZOKP?=
 =?us-ascii?Q?q08linjZQafHSX5Mxwxcqvyn7bpCw0QICXgkIZQ46XOV8jXYypPj0PacL9sE?=
 =?us-ascii?Q?68nQj40JT5qi462G1HsE33h6Zfp1oehsAUe7cSOChOJqkVEQWV8xa4Z+cSVT?=
 =?us-ascii?Q?1QzxZzqgbo26fcMVwJujqDoceV3aPSuypW7sxix7h+WFtmYEIKRhxTFscjYJ?=
 =?us-ascii?Q?/SYoNaqT5UXe/DBQfsl8Q7083U5xntJmKTRta1SYpHUAbjIuBo6CnwDPTkGN?=
 =?us-ascii?Q?FJZA2z09RzGDtjfUea6ECJXsePFibIPUL0ciurRhOxU6vE6SsuAnQfnYksgz?=
 =?us-ascii?Q?DipqumgBRy6EJ5LGIMwhmFy2oew9zakcyJEwoGzAIYNHTZ34TpTkI1sDtyV3?=
 =?us-ascii?Q?aA4hoTCF1Ip1TKyvrau9dEsXn3COTH+bWQDQvSr8KyTum5joF+ZaNOs4BHh9?=
 =?us-ascii?Q?rIIezzjtezRPkCickJZUdJEGdkjjGW45PRJ5bqSNgMX64le3D8lrhiVD0gXi?=
 =?us-ascii?Q?ruuXb0SOZi+jwBC/Up6PkF6o4UFEAqqjWSU/waHCRLtBUvA6vGrcyvZnaTA9?=
 =?us-ascii?Q?iWyYvwyVcUN0rjXJKsxRZS1P+YhHhVP/kb6YrS2yRPApc6t4/myvUTUB2tmy?=
 =?us-ascii?Q?sayvalW7sY7uPYw6ni1doyHIpAFGTiyow4rPM3rbcAoiN/Lh7OKLeZnHvNzc?=
 =?us-ascii?Q?Fexui3PUG7NQsCEY5NzwDkN3/c2JGA2562fFrVuT90VzqoNtQKNXy8LEaPbm?=
 =?us-ascii?Q?DMXZnkzpAl04TVNwTdsuJ8zTDx7WfwQLc2lK5M6jb2umXE3W8pePBc4KuGjW?=
 =?us-ascii?Q?YqXRC3JhtEpgPZcD6QnyV53KkCy+RNc6+fY6LWCsVR6/zNBB41UAogKJ+5wz?=
 =?us-ascii?Q?bH8+6rjv1jhhZyIMIe2qpuEAtZFaXppMwEh2O/+ZQCD25i7ItQqEj59E+pz8?=
 =?us-ascii?Q?7MKpTvZ7//1KMmMkuaXmt/bFGhVyUx34TG25tuiHae+/xO3ldPOVPa3Zqm/j?=
 =?us-ascii?Q?gAw8UzB0sNApw8rt9B3w4Rr4gYO5i+yw4iPZod5v86QSYChVXjp4DVLzNnIa?=
 =?us-ascii?Q?Rg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	79pzDTNTVttK5f+iYqTaWXBqtQcQg5ch412xIiu84rrgvmGuFu4A9Y9xDZYucYv4Bi7wKZtX2fuhVraeyaPqvK4ZclkR7P0dZrp3pLLBJEdqg9GtbDbJzjQqQlOtY2/c5HqaeGVxChExjfTmPYc5mCoIJ2CabUJpXgRwDk0LVnsf271PISVg9pN5xdTt2nASHXwunVa3VG692rowJIRJ+Ixk6fKuNWAg1cHEr5s+f0wIU28yaRWGh+4tfzzm3eo+4pddMpAGRLpwyPbP6Q43FxSey+2kjAwwPbQ03BA9wKt3s3wm43oOQ5nJWuRCdrh5IulagRFClimPgG00mwujCDMICivyeVzNOdPO51fD5kciL7OxEnJKri5iZKMmP+yeW+O1sz8q6j5iyIHa5JnYFuimsFElbScW3j933DMpfEi28tLUSsyLs6YSyksoW5gGh+zDWH7pPqdvURXXTHj7Ia131h5dQI+bdTY4w7AD8ZogPwvcXwFGuA1n0MJ817Qoz8TaSoaq9CPHdfAe3L5lbvmsNcYmWM9SGMqNfue0BYDfQiwv1MWRlUoOmBAgxa4+4Uoh8BF84MXX73V7i+p24G9ip6GIakzSUxyDM79sr7M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 847a098f-1b22-4bd2-7e00-08dd44cc4f9d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 03:30:45.8767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IWXDTCUPFDdrIx46bFm88xns2PoqRcNZjgqu8Jk6N8q99/FgttTj7NjJQY4RgQO4xgit5hvB44y/2pUf+WUYe/Vjx6pJhMZX6mDVDhMhqL8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7634
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-04_01,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502040025
X-Proofpoint-GUID: kco4jMHnYQwM3VQpKlHtK9nX4_Cr9KnY
X-Proofpoint-ORIG-GUID: kco4jMHnYQwM3VQpKlHtK9nX4_Cr9KnY


Mikulas,

> Do you think that SSDs benefit from more alignment than 4K?

It really depends on the SSD.

> If you have some SSD that has higher IOPS with alignment larger than
> 4K, let me know.

Absolutely.

There are devices out there reporting characteristics that are not
intuitively correct. I.e. not obvious powers of two due to internal
striping or allocation units. Some devices prefer an alignment of 768KB,
for instance. Also, wide RAID stripes can end up causing peculiar
alignment to be reported.

Instead of assuming that 4KB is the correct value for all devices, I'd
rather address the cases where one particular device is reporting
something wrong.

I'm willing to entertain having a quirk to ignore reported values of
0xffff (have also seen 0xfffe) for USB-ATA bridge devices. But I don't
think we should blindly distrust what devices using other transport
classes happen to report, it's usually only USB bridges that are spewing
nonsense. Which is why we typically avoid trying to make sense of VPD
pages on USB in the first place.

-- 
Martin K. Petersen	Oracle Linux Engineering
