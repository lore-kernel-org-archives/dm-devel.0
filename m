Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D61E2E49BE
	for <dm-devel@lists.linux.dev>; Thu,  3 Jul 2025 11:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751543224; cv=fail; b=capAQOETeLaZMPSrLGSvgRuziCnO4uQPVcltiJMvf/rqKOWEGsD4eXIaBogoB6bPQtlBNwbctZuAPSrzysAnqoRrN2BvUddoLRNRa5xpzdYc43J0YObm20i7GToYzgfJTKOHjZ8ym3LrgP3k15qj1RVkMNwPxavJ7oRQLRLLgQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751543224; c=relaxed/simple;
	bh=FCEN1pczawj+2x5UuZHr0Km43itOqO9sUFh9gQctssQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ETKNKZbVuDTNccjNoKcGNmzLcCPpw9f4Ta5C8nWw1nerH0vNY+EeQhdxKYgePxZ93GxEEUcLGxje4L2S75d+krnyTDrjCKm1A3BgBMuJNXRMp8safTWUwWTSCPdohPBV45EBWND+BqBSm7jVE/lm/gfqvvf7bx1mUtQpCKVpgm0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HMyz58q7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nQuVcp+D; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HMyz58q7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nQuVcp+D"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5639YoWm006722;
	Thu, 3 Jul 2025 11:46:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=r+ZOCiW9J1w6DfiVUleMtEgXSchl7yhV3pwDA/QY97U=; b=
	HMyz58q7shMcFJhl8XOTzmkL8/Qov9BtbOjor4Or989fKOYT4LEnqM2Zd/4aO+KY
	A1AY/Iv24D5tFZHFvG4zM5s/7d4TrTmA9No25os8bDEdgta4Y0iBYRooBOiTsLba
	o4SCTprmiEIZMWcvwYjTq/xPjWtJKhetmt4oTJu5GLMjAgDkSVmYPcuQjQZrxgju
	GDqsujt0++0dZWwRR5NLoKko7DyyOcBBjzXHMynnr03GYZdpjCyNY8r3VGSfEWpT
	SuOCbWJoYxt32rSc/Nnm04yCiB4922YRaSBLWVHZe10NWocXranvoxV8ANdjegsk
	bUTAH45HAXw45rFjKGCS4w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47j8ef8wp4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Jul 2025 11:46:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 563ANXW4027469;
	Thu, 3 Jul 2025 11:46:46 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47j6ucgj2f-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Jul 2025 11:46:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ydmc/3WuahgWj2KBXQ1VruE5f4QiXlEURMVH+nmwRoJkLfOSengPJXWivbVUtYZ+IJ9tHgIU8gAI5C3VxuAhACjOci3KZr2fN9mWI4aHRCm6Tya+9pDELrX+0f0N1Rg9njq4CnPv8ttJ6NTD2fldfRcImqnUtQ3BmAu4CSiPgK5SFWeFdt6UdG6YM1EodIiKAvNLXUvflmYABzlpWnLOSg4vZQ01vOte+sPau86Z/2T0JsLMlbO2eSyePyz03P1nSSMOV8rwiu2tVlmQMrgv2psi8N1pxeAbOzBahRLfp9/DNYdd1F1OhyejuLoYPQggE5qT3WX1caDhotv8sfOdQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r+ZOCiW9J1w6DfiVUleMtEgXSchl7yhV3pwDA/QY97U=;
 b=rt+7He4Ffcaa1+rvPYOhYABvmH1r2/pmVkFzlyTrChwuGlc170Wf3O6P1f1fstEVZZSFRWh6s5QBQfBnVYw2Gs1PsC9m3KXeIAumVyOiVNscndy1qj7fAHfdNsijHKB7INxKyRViYQpjL9OqNaP/RWi9hoY+5EB1Tx+EBjsQKk9XozUyHtzo3JKdl038spHFBW7n/cGohlnjHD6k2LP/Ud65PEuvIWx6Q8rmDBYx3r/RAd1CqhzNPz16rUzftYisrPJnnzmAvDSzIch9DM3mAMQZgxGdH7p69ym3ahb1awtalD8y6VAJMgdFJANs4fLx8XnYiaFwK4v+M6bIhih4Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+ZOCiW9J1w6DfiVUleMtEgXSchl7yhV3pwDA/QY97U=;
 b=nQuVcp+DowxDhFwo2lO7BurSA+1FGenguWto35VREWaLSp9hA/srJWf8BfAO/63IoL5y7ebJgRqTb/ertzS9VbThHzK8Q7Ssv+ZmxbvFqG3+9SNybkKP3Emwt1A7k+ELqm5JwvWvVkTLrb784RoE94fVktWsnTBpoSO4kfrrIhk=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH3PPF262994532.namprd10.prod.outlook.com (2603:10b6:518:1::78f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.26; Thu, 3 Jul
 2025 11:46:41 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8880.027; Thu, 3 Jul 2025
 11:46:41 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        song@kernel.org, yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 3/5] md/raid10: set chunk_sectors limit
Date: Thu,  3 Jul 2025 11:46:11 +0000
Message-ID: <20250703114613.9124-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250703114613.9124-1-john.g.garry@oracle.com>
References: <20250703114613.9124-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR21CA0021.namprd21.prod.outlook.com
 (2603:10b6:510:2ce::15) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH3PPF262994532:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f8028a6-3ceb-46eb-4d27-08ddba2746d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DzAr3yBU7XOkQF0M3bzfreduIslwvQPnuxSnuJjHpbeRaclHJ2KZIP8t9sMk?=
 =?us-ascii?Q?mr3pTNKJgPqahFLrvASQjNq8qZUkyHW+4fFI7OxZcg5KjAs/roezJqAZiHPW?=
 =?us-ascii?Q?eOF+t5/PVoaVej/+/gYTwXtO4D6RU683vMnLVE3iJ3lzHoQ+aja+JhFw1qOC?=
 =?us-ascii?Q?DEMbcpbS/aL58VQC4dWKvnMFHV0zB7j2Bno4Y6srjtzHLWFDNx2DGWbz+68t?=
 =?us-ascii?Q?FZQKy+Gm4beXdef7HkPlwQzsrGGmoEwaqwfvg3mo2AJj4ncxu0uql0P1VyDA?=
 =?us-ascii?Q?mNQXyo6HQ59mqIiflXMbJhLKCFdsTIhUZifVZ3V2HaKVSSfcthXq/qz6j/e8?=
 =?us-ascii?Q?yNBgm+ZMT/fhsVmAZ029luLxM/JJwU6BdpsPl8qmkilFsTz+9eHAAVFIJREs?=
 =?us-ascii?Q?bkpyo2/HGI17tUGZlXOn45I27bKB26n0r3Yrfci7oSPnXwon5KMLuBHQQzsW?=
 =?us-ascii?Q?4eXo02zBuhl32oER2tC1W6vP8BR+FS5egM1Ga3K4nqzQurnD+eOEt7GZAtZ7?=
 =?us-ascii?Q?rg3twSLonQ5INZpGdofYOUgchR0GdnPV03L9C3Ppp2fUIHRv5K9onJEeAHes?=
 =?us-ascii?Q?o+eoUQcxNpqghW0TpWOKYrnc2yM8J7lBKcFpCk38AoX9UympLvFm6c4aEKHj?=
 =?us-ascii?Q?uVjsWQqg8V14knMetprZZv+udKEPMDDnole8Cu1VWRVDJ2bZSAl2RilhdMu1?=
 =?us-ascii?Q?AqFv9flj7vGJNyPfxsEGSwj9rxTF0uoaqyi5MsCmAL/r7EdUeYHqzP2F7767?=
 =?us-ascii?Q?yJgB0/4SC93bwvA7lyZ7o/r9fkvFp7D+CYEC1z1QNmOlbwxskTnmvx7Bq+GF?=
 =?us-ascii?Q?/1km7uowsywCFk0VDl8aSxnSl3sLu4Bpyln0ihYewgPxjbvihWJdao2veC34?=
 =?us-ascii?Q?xCTJF6yKn8a4yWWGs66MJX8+VOy8EmX9/sPXc5vrS6F7rOoEoo/ihH6XYgTg?=
 =?us-ascii?Q?dexkCATh9RSe5dZZ11+nFL66m1YFpNNt53XDmBpGtzsuYgrHZGTDmjF2hfb+?=
 =?us-ascii?Q?vu5PiMrUI+y0GgaExctK649RifRsi4myYn8Q8VPgXI0boGR8q8r6wZR9+14o?=
 =?us-ascii?Q?ygMpY2PjrBm4ZyDbtTr/2/nlP6qPSXkbZe7rZgnUsIbPzXaqbeIXFryCSiTt?=
 =?us-ascii?Q?3gIY7o+Fwlpm6/SzkkPDPbe256po4f3BNiJJrQjpG+qHtf4X4r40ccmOQaR2?=
 =?us-ascii?Q?o3pi3C1LpZZbH/J/TBJZwfmF0aknQOTe5WnuWqCpoVwXAR25N/iWu3oC5xl7?=
 =?us-ascii?Q?QQz+830fgp7jfIOj+iPqXJBOj+rhCl4nINjqy26OXQWPVdbe+G9M2LC5CF/K?=
 =?us-ascii?Q?ewX/Y+Cd/p6F5XoA1Un4SYLLH1oq07rOQm2DnlcXG0OSfmVI/x/zSsrFVpd1?=
 =?us-ascii?Q?PC1jFdb4OLgRTXgeGZrYXBkJr6ocVn8L4pfxnOBeFglh/CC8rifjctey6eRs?=
 =?us-ascii?Q?C+90AxuSSUk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HMubjEJAM12kmbLTPimqz/IHE1NWlniPisd4RAoqS31ywR7TXvDYNWrsXMWb?=
 =?us-ascii?Q?pu5bIkA05vuXhE+y5BJiqhl9oQUqgtd1RokvKRBx9m/AcwHW9W4LaxZeP7Pt?=
 =?us-ascii?Q?bPQdLhVW1utTJSgMqsY8S5jJY8IgOFFnmxuRYuGLcKe//GOcDZAEvtetb5xh?=
 =?us-ascii?Q?oGYzWzT3h2Mk6yDj3jfV5jylIF8B6tFLZxg8dTPK5avH7kmopCDjntCrXDtM?=
 =?us-ascii?Q?0LdY/lRcuNsALp7i6NckiTWOuIO7ClPLGL6t8OsMhTTvR+Y8QsCeGYt1vdH9?=
 =?us-ascii?Q?ObaLYNGm8AzsuhtqUW7ss85yYJRx06ZtAJie1XFXkcfCdFtmKgm2fEzlpgd7?=
 =?us-ascii?Q?4bW5qOuJRAeHleaXBn8HRELRXMPYs50DXz2q1HRrGVhFV+ReD+6AcRN8/sXB?=
 =?us-ascii?Q?N3ysdjzEibqDDeXYY4TGm4vbvMBYJoh4seZvNEcNyuIQHDYHZva+NUobhStg?=
 =?us-ascii?Q?NN5SF+o9FGk72fExVjnCq1woJTcBkXIl4lSkLORFrlvHf1wU0GZxtfp2SE/l?=
 =?us-ascii?Q?ZXEp8vRVLng3Gj9JlNkQ0ccdjmfkYhOTnfODW2x27A5L1fJ4ETr5WJeuWXmD?=
 =?us-ascii?Q?HTttQ4X3SalTrEhOREMn7iq8SfOdWHjUoCBuZKQe1k6asNguBbbPxP8GCL6D?=
 =?us-ascii?Q?Ew/zQrFGUIlXu44B9chzUOYnVt0Suxw1sIFlkzhEZbQ55Btng6hCXEe//uqW?=
 =?us-ascii?Q?B6q2vRVG29Og23B691sm5KFgLoa6hKDl2lG7gE/6rOMzHqOHQrXoKShxN/qy?=
 =?us-ascii?Q?TopuDcV5Q9gPoICseH+pL4zeDNDsmWjlD+64rIpwr4eayBDmSEZUMeYFrDeW?=
 =?us-ascii?Q?dM56yXbAmjqTBfsNnZicvA2ZX3Jnik1+9vt4JhI81+DEKHHbdJEvYBy1yV7f?=
 =?us-ascii?Q?e4DMpSxzXyGh5v+xY1TLaUJSWtt/9Tg0mW/Ibp5InrIgg5KAfdBVLQTIf+t3?=
 =?us-ascii?Q?Ja1fZpfeodSGRzSO9SEpzc86rpofrm7h6Y4MyJbJxtLJr1OHCVGRxcH1Dqph?=
 =?us-ascii?Q?7kT1AoWBE9q1ruRPyK9WeK3OPfZMZrV80+K2xivM7uHYh5KGFYhPzTDatrZp?=
 =?us-ascii?Q?Imqbz7hRAUR4yXQwi1GyLPhcExilnMFgNop+XtvdipbG7jNZvaCnyxqXfLrF?=
 =?us-ascii?Q?3hiA8uRjGPLzpPe1M8t0eXP50F9+apsZm1NX8l/BNl4fPTC8g4y/KmuwjcSW?=
 =?us-ascii?Q?omVnSdFRfbwhhGreFjAwmYfVD1oal4mDLuHj8YJmhBl74PDVX1OWVfMhdoNO?=
 =?us-ascii?Q?YkDxW80t1LXFROMMXNMJPbjzojl5m/6UV4ywPDpFOinhM/Q0wbrBFD8S6B9O?=
 =?us-ascii?Q?ePlA1NbTtf7887OLLRZyL9OXuq71W88nQv1HdzD3k84eVYCwjrRfVjCnroFG?=
 =?us-ascii?Q?kyE/VjLhCUQrDDzvZem8xEmF8LujnsvAl4T4ehwNZlk45VddevLxMite/3uE?=
 =?us-ascii?Q?VdjorrLNjn518bEaCrA9wUEfoUX9wq+yXCHGQxheSW1USi/oYpm+YeX60FIP?=
 =?us-ascii?Q?Nxfl+o/7KNJ8fsHd6ye4neoXEVN/CJxorMTJnkKR5mHGqEkHVDFnzs2PiuBy?=
 =?us-ascii?Q?EvTXZdYFunmOY2OHwbtMfdgO3WprVy5JQEvMWt4qAzn7JgxzG2F8arsbNhgy?=
 =?us-ascii?Q?/w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CU7vwlE42poPAsoZeg4zP+BrguqzdYuM+F7XMORPM8LbwyhAmV6qQVYLzGMYFd80+qegCiV0fA188VvHODG+eM7su/JrdA/fucurM0OTLkxib09kF5hLDxkVcQgeH9+phNwgbVVBIXr7URdTdpz9IGyADQfkYn3WjHnx/CrePemHf8G1w0TwyyZxaFHCnco9A8mZ5rRK3g6Diidmtw7y2dNjJBIdmC1s9rjowHne+VjZmfjnp/rrYOEImJeLe8OWeQQKUYNOypnlaZ226GOK3zgOAE/NeZGqJr4DCFcs0Rypnsn0wWYeGsknUUIo3pifTPmZ41MhDl6InnYowiQOtyEoXutcSlESQW6X5xWQFA3t7htxm4BSzKUZSqCr8k1GlnhohIYNC3yrN5MoSltPlCbVgtAH52oZug5QA7y5p0Gg2Q8OS4oDRsccjD3103IPB+fd75/MGXWScXY6l5VRkbWJd+mgVFFWtt8yYluFDAxqjh2+DquEppYQ4q0sziryzKKAVQNC5YLXZcbZMfDKkFpZ9v3vP1WcHGT2FqKj5+XUZeR9R9BgDIolLfo/nqvkmKpk59xzCuVqL6lYMQvtKLmTVYZGcstTMh0ySMTS5Ys=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f8028a6-3ceb-46eb-4d27-08ddba2746d0
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2025 11:46:41.3791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aQCc9pUN6mBxGtrwyjJbEArJIpGWW2bVRUMJumwOxOrNROpTGPEdMN4ESsTvdYHBiVDc1lHH94A3I1WZOWqX+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF262994532
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-03_03,2025-07-02_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507030097
X-Proofpoint-GUID: 9Tzz92rhCljwOjHNqbug392NXrLWoib4
X-Proofpoint-ORIG-GUID: 9Tzz92rhCljwOjHNqbug392NXrLWoib4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAzMDA5OCBTYWx0ZWRfX93AhUc2IIles IgyVVzjysU9dkaxZB+J+XNTNlc83d4lLL/+wff+mLSipRzVj1xc4/XUJazPvh64FwccZgPltWvx Nc+qgGsIiCIBVz8b+QapYwoaT63OmSqMWxNvVoRdQhgLoRv5ooius1XXy2YPT8Jinw70OmNdMrY
 f0YvjyFQEwTNQ+6UPE8TDqTKsfXOo2vnhVkya4HxeMVJzNh8dxJnrE9yIF0m3Q1nPEZG28/o0gh BUKIqL2/v4yvcgIfxfuv6Q5+NtdfKsm3zkIHM1rQaM0dCsjJHycq10t6TLriDAvN8w+5TefAk7f IGx5W40stk9llIHkKlfBuJ+Vi40kjNlb8Bv49GxoAknPDmNzWe1CjTd/KLcydbWcg3ZL0IkllTz
 p6Qws1jIynCdiAgHBmleajzHZsflVsdZNj25UxNXzgRTFsM7LpyV8Qz2rXInQZCk1AHYWIAA
X-Authority-Analysis: v=2.4 cv=ONgn3TaB c=1 sm=1 tr=0 ts=68666da7 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VnNF1IyMAAAA:8 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8 a=w2tMMWzikjCRSElI7Q0A:9

Same as done for raid0, set chunk_sectors limit to appropriately set the
atomic write size limit.

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid10.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b74780af4c22..97065bb26f43 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4004,6 +4004,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
 	lim.io_min = mddev->chunk_sectors << 9;
+	lim.chunk_sectors = mddev->chunk_sectors;
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
-- 
2.43.5

