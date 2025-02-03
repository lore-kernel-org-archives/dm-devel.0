Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA031482F2
	for <dm-devel@lists.linux.dev>; Mon,  3 Feb 2025 19:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738611707; cv=fail; b=NkEsVx9An6EUzwQLpH0TT74f2+7psAlEzrg+LAX9qWZIvXEJyvfjc5WKu7T8nhzQD2urFmKyoTLe1Oiog3dJkDLXb63/jwnUuCIbLMabsSUTGlaUxIbE1W6PKMZdhGaLiPW/AkCFCMjyjHEIjC7NxjVb9ETJOSPIRmrt74SX5bo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738611707; c=relaxed/simple;
	bh=2+XytTOF0b8Qn+YxBojfUkHj4JM03ZF8cjHoOz8aQzM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=C9mOJQmgarAK9aXGboMjH45Hf+BzrFc/FfjpsmROwEOr2eMccX2GW+SPUCJL1UF46TWOZ1wlb16Z59YnhgTOi5sn6WfZHRn+y2Amg7Kep6ZSAgmTFpEJ2YkVULWpyi+5SQu0pdJQbXO45pRDzuJEWSKFdrAxVmLPJpVV6ilUe9U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Qdo5Y1hr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xSP+gJZD; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qdo5Y1hr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xSP+gJZD"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 513JMq94001157;
	Mon, 3 Feb 2025 19:41:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=9713mcZ9mgyLHnp8fl
	pmLVLbzBvg3tbfkc4pMKgfALI=; b=Qdo5Y1hrMpImR3FYf3wGYGg/OZtt1HPUX2
	OjELnWQpDFpZt7YdEcNQZb4Vqg1rdM4rRjSSKIubCfR3btOPWWEWkXdJiLPIXXDs
	WGZUg7dQRT4KmNAR7YAFn8Wce9rFVZJhjjZFQ2OIZuwIMZv5OSrpqrgYcE49l3TK
	Uewvvze2y+x4PybG5m4QlpfwRAJYAlvy6EtYomRMeEDDhSH66Q1qJZ+BjIhEONOL
	I50ZUVf/k3Tecx1gK2Xu7cZdU7PA/XW6fJU2bmWaIRqj+D6JhsVxAu8u9T58doed
	8zQ9GCARgoIcVLGk8ApqANQzQMs3GEaqTlfn/KMTVUoxBNPy/z+A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hj7uuchf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Feb 2025 19:41:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 513IfN7I037786;
	Mon, 3 Feb 2025 19:41:31 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8gg2cts-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Feb 2025 19:41:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W9COBpvwQUjQqe3lX26qz4lyCEIgLQfhpYwUfbMFasQpDjlENXZdtngw9rW0Yqtk70yRUpyvhLoRzkVgcMeQ/elPdYwgE8KQldkHGdQs+e87l4rEByRbUtsqZI1kv8DrhzpPIMEMNmby2YD/85Kt+PzBDj2ombk+4f+adzfg/7EsfCoKqWY1g6rkWQuEeEBZCN057kWCUMz0lVpoQBAcKqbZNB2C76OIRjmH6vDDh0UDpbVNbtw4GMFXZsMcD5xj0ml8NdqNLmsMwbeKya8muAf3szPYH+c/qWGeVAIfmxDZgFs8uAnv0blL6huqc+brGyLybFn39VMiTH+qcArjOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9713mcZ9mgyLHnp8flpmLVLbzBvg3tbfkc4pMKgfALI=;
 b=D2OtmkU3GqbxJOgvJY/QRHI46Df2dacZA462YnnluB7L65Sj4z68vM0bJpA3dLOghtwGpELNhFZNI+BPFaiUGtMY06b4xZK0v4HVVFisBFdbbXBrgPKUIEqXaV19NlvAbOQ4DvYcm1SuHKNtMuAOce29uI+EcWydnjLjkDRAQkzO3+AN9u/r6apcle6DilSLJidO0DG1X8UXTnpmMn4tZtEhPS++84sa/cKyYbX16xqv3TAo/jZGQFnAt2+vtKK7Y1A9HHCjXVG9aagNcrjxFoDnzEX4mAVqnT7HDnC8m+pyGzOMFhN0nLJw20bT+jVfKATprzZLXhCm28op/o2bZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9713mcZ9mgyLHnp8flpmLVLbzBvg3tbfkc4pMKgfALI=;
 b=xSP+gJZDgJQKiJvYeX8noAHvG4LJYDsNnxHRBdh1vZHHnxoFNJ+Y1hdFMpTdiX+FwgSN3uSsOs0VOvwWHOZBA539O/iFtxhn1bQvdjYdu+aeK17jqexJNjp4ndboaRBAHVz9Xni1rDPr08fOM+5e0E1AtwrQ5ZfcC7EeMSROndQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BLAPR10MB4913.namprd10.prod.outlook.com (2603:10b6:208:307::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Mon, 3 Feb
 2025 19:41:28 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8398.025; Mon, 3 Feb 2025
 19:41:28 +0000
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
Subject: Re: [PATCH 2/3] block: move the block layer auto-integrity code
 into a new file
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250131122436.1317268-3-hch@lst.de> (Christoph Hellwig's
	message of "Fri, 31 Jan 2025 13:24:17 +0100")
Organization: Oracle Corporation
Message-ID: <yq1v7tqj00w.fsf@ca-mkp.ca.oracle.com>
References: <20250131122436.1317268-1-hch@lst.de>
	<20250131122436.1317268-3-hch@lst.de>
Date: Mon, 03 Feb 2025 14:41:25 -0500
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0043.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::20) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BLAPR10MB4913:EE_
X-MS-Office365-Filtering-Correlation-Id: d7f50f41-a2d1-4b2c-d8cb-08dd448ac05e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?so2m21oFGIbFTGC+he7esP0xIxXby4l0LBirp90fz5QMnsgpdEnYT12ZNsEc?=
 =?us-ascii?Q?SMHUE1umeuRtNsODV7wQWh9yy7qiZ5F5s+tdq0NK9m6CQH5rYZYBM0ciC1na?=
 =?us-ascii?Q?6AHU02E5pkuncmD2TfA982RloOe4d5gjzQa0ugTDbp/avoS/Dc6RkYDSnd1s?=
 =?us-ascii?Q?c8DduyJktj75xFkPMO8LvT8XpwUjD9ocW1SdP4Vq1UDJOFiAb+K3kPpN+ZLx?=
 =?us-ascii?Q?DNO7fFrmOq05qbOZT59Q+pDRF/5Lic9V7XJiEeqeXj8+4giqA2GQGPp86HvT?=
 =?us-ascii?Q?YVYgnr8kkTp24r4biLgUGEirxn94CpKrnH3gnvsTOzr9oIEdtEczoruo0Rid?=
 =?us-ascii?Q?9JbuWEl3AdWHNXvCKCvXTCQEsuf03QqxbdHjLO6i9Aimaowo+JsNX4NOHgF0?=
 =?us-ascii?Q?ksZ2iKW3JaWiSmENN+eLh5byvwXYxpEzZkQNkNOPecilyNL4/C+GeV2MkEi+?=
 =?us-ascii?Q?6W3AaMRihyba76knOVWlHhGumlU2MOoJo5nDO0rDfmPOjEMxsCIXoKZo0f0b?=
 =?us-ascii?Q?ta+F3pJxKVMb0caLCxIVNu3j5qTEQXzPmQ4FAGHKJHbP8GQ/MlJg6LT2ML2t?=
 =?us-ascii?Q?F+rcuHViYcP/WIYNjdKrFeYsERNuR8anuPO9MS4vjtenhiLkgIWP5z5bXVIo?=
 =?us-ascii?Q?+O8dt38J5wukdJ3JDHmd+NZES2z7fTQHXgJzmAEpODBO8sRkFDwonRArplN7?=
 =?us-ascii?Q?8hXfoljZ3UCQMexvLPS0+6m9UYlCWERU2Go28PTbxUPPwa7kZFhRL030l3xG?=
 =?us-ascii?Q?aDsqysfgo7bW2Chp+a7rBanLr5oYQyWUjnskRFc44LyWgARdQWc+0hveTrSB?=
 =?us-ascii?Q?sbqsIqoL9xOmhJFCuXhJKTaXKN1a1A2hMJo2zz9uTXFbfCszFXmiA+lV8iCM?=
 =?us-ascii?Q?6Jk7T8A8fiIddLnK12T5o9l3pZymSakVl81ARlu4JLN5TXVHXS1xP8AHTgam?=
 =?us-ascii?Q?+O+/pTjCxCYXQWZRNegfoLCfVRPBbtp4UsZwY2HUzpXfxOFPvqqt45YN0lLz?=
 =?us-ascii?Q?V244PFeCTg0pF7m4+Q4YLF+2ycd/HZgOlqh1IPLTho7ndIuHzE/ssvWj7jg3?=
 =?us-ascii?Q?p7BjM5EHHbZEq33iETQoukmRMBDDYsNrbl1bCOxvvSVjTd8jWqpf+ltLYtS2?=
 =?us-ascii?Q?8UUEPu+W8HZNGNDflNeX1ajETVCY2qKEVXfX4NAJzWpGXnn9Z7pl3+GChKAW?=
 =?us-ascii?Q?rYbzBqNXZC7+TSpjfuDJETcWKlvya4K4gNxOuVafl9k0WlrhTSMlV9Hdit9c?=
 =?us-ascii?Q?BTqDuSEWJ+jJcHvuEz5z5hOonZOwz7+DuX6T8f7Q1mtAnWO8vManc7AIk+FR?=
 =?us-ascii?Q?v5arT8jGVkzru5dllOOKyiwHHBF3FSKF8pgpEKlBsghM+L13TekGSUmagxaR?=
 =?us-ascii?Q?OYwdqeORYjZF+APbyc4+N1XC8MGZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4/hV50ra7BKuwQlL1tqkr8+26gH/20TFpqzYd78zSVtdeK6DnAFliwskhXiq?=
 =?us-ascii?Q?KfCmCCFIqxWOjfTslMw6r6MgGnOEl0ZdSCNAeYGPgRXdYZ9oTbFpFsFr1Fp2?=
 =?us-ascii?Q?rFu0dNEoZJj81Bup/fo5HKYuCPzYe0g3CYhJgOtYtT5gIqgWZCyzUG5pPCgJ?=
 =?us-ascii?Q?6yLSclA6D6qYFv5OkdRjg23HZRgefAEMt77dZNo+pCsKhdSG8JccyJgB6q3v?=
 =?us-ascii?Q?U8Y3eiuOCnzp1B3XrQ/cfwUPxZqELUcMgodxU3Oefw4OVgTlS01QLi4tReXl?=
 =?us-ascii?Q?VwOPby4vxcwlyYJ99pvTGnRsQinXhpcdRntMVba+JDspyUgGB16Dh2wCc4fw?=
 =?us-ascii?Q?YhdAC9EmryMOch6U2oVH+dAyXdpMnqTUelpgrGuiDIhfwo54aL3/2FPbRmHX?=
 =?us-ascii?Q?P+LesxiDS96unMiYjmHBAzSUFAsUVaLsYXX8cAdo4OLiXVuftK0Jnn8tXg3T?=
 =?us-ascii?Q?WK9QEIYZGrrwuTJK8y90YqSN12kbY7/htAdWJA7cX7efO3NDJK2gScvzZvHP?=
 =?us-ascii?Q?GsoL0mfrxtBuj159RYgGZ2+eLkP6Y+t8Tp1jkZFEVlwa8xDROz9sYH/uLKq3?=
 =?us-ascii?Q?PMN+bi7MIoDNIjDD6RDfw7u7TgvlxdcVzU7LBEAWoO+qyf1cJfhhbX1+EK0o?=
 =?us-ascii?Q?V/gRpLk2NaFt9ax9qCPvmW0Erpd1VlPDZejT6JWxrceq6MhoX86ULnCKnJ/3?=
 =?us-ascii?Q?Yda3XP9Ucdnh0YHQhIh6WVKD76yPO0X3AmaCfhPpUnio5QvRa3Ny5ArlKJqZ?=
 =?us-ascii?Q?QLUMtwsRpaV3jecWr0/XfHpaqNleBpZxu0Is8nagWVhymqEv03xk48oDJdzO?=
 =?us-ascii?Q?IO2aS2mKmYijwKCDihTrWon8m4VsLZf6Oyj7lV8iUp1dwJ+Bodk1YsZxhm/n?=
 =?us-ascii?Q?iQEKnK91+bRZD/NUxY6ZJ/LCHXD6fzUTOpXMKtjWMUotNN8ZTF61QWPOgO0G?=
 =?us-ascii?Q?zMXnrzZxkRiOcehRqBDi88hAKdqhrzTaj+6fNoaSIt1iusyMUNoLiUGFp9Bg?=
 =?us-ascii?Q?+8Z6GP5q++4CGiX0vXg3ORNWkJKAXKrKDL5XaIVFuLOg801uWN0WBWjKUZut?=
 =?us-ascii?Q?wceuPdIAivvXCtJ56B+kNKKTfyWpXLmdcbGnBh8qQLbsLtNzIYdaFfZuaRcz?=
 =?us-ascii?Q?F7UMkMaWcGG/4M5m8ZIHNGlJXHIfyFZRhR8D1Ygq+BpVxXl+sTUJRwOfMm5W?=
 =?us-ascii?Q?fVv1Z64cAJSKvbxRoMBNSbOjSbJ4Kr9vpT9qQg4og0M6OEGmIMoiGvKyYn74?=
 =?us-ascii?Q?A/RbpsGsdxk7IpiqhOR0tmiTVfXZ51m1QB2yH5RE2T4CWk6wvB/aGfn8NkcL?=
 =?us-ascii?Q?9CCC39Srfng4JUwFoiRwX1JFkKd66iSijQlcIx5IBXJo/qWf1kzu9nU6DE96?=
 =?us-ascii?Q?SvZxyfdQH/+0HxFARoKfjt9ipqQlHxknqtQT+OjON/mNtx/irJIbUQsohSJM?=
 =?us-ascii?Q?rl2QNVBMmp2TCpJ3iI9G7AACxMsq808fuK45vg+8nHUAzUz7t4EoigwpW33J?=
 =?us-ascii?Q?vbmJx1TAFRyBXbItKPhEdxCImzZnb9udL29mqwSwczbfQVLMVwVmIxkb9eSo?=
 =?us-ascii?Q?765l2GTPb2Uy1mwUNmaaNiZZaABO16b+AJt8F/7e+TZrRTeHv+TgnNC59kC7?=
 =?us-ascii?Q?AA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CLDEEhqN2TYMpH6efS/61+YG2kfCLr29PrXayoRmyos0uSYL495scZuB+h6rmOOGmpr6QXDATUJVycQOwdoQf63Uo+iJVyP5oMzhYqyFYrN8Cdu9kKyEkZ+6aB3ZkctEm1Xv30PCZW56ybiPeTcgW/ORR+HKzFMZO6/EcmX7ycwtN9fYkrd/y0F029DGfL1F2h3+m75TC82VgPLk3Xj00ajR2ifSxtRC/fBVM3N75wnvUfJi80UEdiLDrFxitNFWjDTibYOekBwbZPnH1MjPRnNxNvkLMOY0qvYLqsdtY7j+wjedvh0ZC5J7Q0Wp8HTVcdys+qOXsIySfdINEvYnnE6tXUCKFA7Ls/ZUIF5hljWF3CvZUXIWzB92QNVUUNrNOr1aDBQptYF6EpOgoaWfrWx7443zd9sSwtbQ4xbroiMliaMHUISEAassX3x8UZu/cw3GvHoukjWXXdBbNlehiroAOLh9apkiqPFmifKH90rlrqtD0pJa8l1RsBiD3r3mKbF5J/YAVf0mkqgHWO+a8RHVSr746v3cdOTx0XGG1T5DzmVBYy6KMkpkM3yZfyKF1+NxvEewrIz+lRvO0GLKqxvqxfUWW2DUiQ+UdyNfTpw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7f50f41-a2d1-4b2c-d8cb-08dd448ac05e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2025 19:41:28.2205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xm1wBO8aJPEzgOtArJUFCqRvIPRYy5IyrwZzITWOso+IbtESfN4uaoMUKXokBo5NWsI2/Kcy2jQ8LAjYA+p1ENaSbG98VP3dE8ZipaG9fzw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4913
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_08,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502030143
X-Proofpoint-ORIG-GUID: JZeyNI0rPt4GZTR4mDGXUuNWDvd24Kil
X-Proofpoint-GUID: JZeyNI0rPt4GZTR4mDGXUuNWDvd24Kil


Christoph,

> The code that automatically creates a integrity payload and generates /
> verifies the checksums for bios that don't have submitter-provided
> integrity payload currently sits right in the middle of the block
> integrity metadata infrastruture.

The original split was intentional: Stuff that mucks with bios in
bio-integrity.c and stuff that mucks with the block device or queue in
blk-integrity.c. I never really thought of the generation/verification
as being separate from attaching the PI to the bio.

However, I don't mind moving the code out at all. That's fine.

I'm not sure I'm so keen on integrity-default.c, though. But naming is
hard. bio-integrity-auto.c, maybe?

-- 
Martin K. Petersen	Oracle Linux Engineering
