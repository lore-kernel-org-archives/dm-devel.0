Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFBA14F70
	for <dm-devel@lists.linux.dev>; Wed, 19 Feb 2025 01:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739928954; cv=fail; b=cCpkxKTKKUBHxuk9APFEF1Ju+yAoLTQwYfhmlLJpLwUREtmw3urU8xT0ds7cl1dStTMxi3pJPxTwFGoCHLF+lahgQNiII+lFYThsgyut45Zff0RUTZwb3VF463feL4oIqBPwPxJeKgPUfso3JQBgPKdKIjmhDvWiG3SEdj+WzqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739928954; c=relaxed/simple;
	bh=bWX2Dj9hsp4BTPvoBqXrholEcbKoE3d4ZTdMT8ZrA+g=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Qa8JrFd/DhFgazqfRU4WQRycieh6bBp85r3FD0lQNCNSALl11uy6kFXXZu01uVz56I3jVPF5cQjQX5IV9R3HwIZozCwjV9+0QqjB8DLxQybjHZ9W0FwZQW2J2B/d0g8LSFxCkJjFQa8MLHqDNh/3fEq9AQ9JdpO/x03JQdwbWbI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VOoLklPI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=t0sukC4H; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VOoLklPI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="t0sukC4H"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51IMfXC8006252;
	Wed, 19 Feb 2025 01:35:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=0zjcxO113Q63sZ2ml8
	3+xIsT5mY9w5oALqPYQtj3q3E=; b=VOoLklPIYByGrx4k9+tjxA7dcGdvHE/9pf
	P/zEfp0E0LwsG/oEP1l+LmAIUmtyVePIPryH6iHEiVs4o46uwm0OjtzssW26pVlY
	mJjhqJbZWj/aZycCH9Ud7x1ZbEwVzESTnYPZiYz28t4Uqp/gt2KmRmrqdTpDdAJV
	iU4CqDklaBX2iYZiBxV/r/NY9KAfR7IF+jcls8K9zCJjRlbllaMjND11TsaV1bJw
	0Xd/Yvnv1pqZ5tY5n/s5gdmKl9r2u6qhB4asrUm6nSFd4DartyUCV+c3xdcfyvzC
	CYAYp88fpwu/NsKPYvhXvBDI52aoNMnYlZuIciMlECTVgB0qa8HA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00n0kny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 01:35:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51J0FOw4002195;
	Wed, 19 Feb 2025 01:35:44 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44w0tk2dqe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 01:35:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J4rVoZwSxf8YVWPT9AsHC4sG5tUrhUaG4d9ITSRJihctz0Sy588zImSJ8Hbi1g3Kicx50S4hgZ6qRnBjOIgF3/VXljX3bJGe4U/U0k28Jl9/SAoYtWTDUQF6TSy9gCLukZVptOVTHS04VoZHHUCpfT33jT49iqkgRSqi11zUJhO4oB2XdLWLgyms5oEEO7o+dmuypcxqfs8p4Ekb2ot23STI1Pn5YK22iPqrKoEJv8kzl95EsGGkBrLy9reeHaDEEtrROehFPAv34bMsogFdeGPyISlt3Te4TGakOEYKXtt50svNVrBugrwwg9qyip2XKFalIsCWWjlE/98TVi0SJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0zjcxO113Q63sZ2ml83+xIsT5mY9w5oALqPYQtj3q3E=;
 b=nX3aPEDrbcoxbxoumZexaL+eLCLoLgSoc9YxprAgQFSgJNBKbfkuBGCUPLvo62cOmlY5KerAuFH/x0QKwzzVlMVDmrNpK7oqA1CfWKKX4UlE0lCfX2+kCwo/2Zh8ZGboNKh+Plyys8unJQoA2qWICxJWkHdltnNd/exRKI+Glm1tBaFBcZUHQCDa9/UuCnC2dejnOJ0BzecPaUxjKl+i0zIYjGpn4WZ5FAAAywrKHRda4T1i8QsiDEp19yUc0QtGPgJftq7RNMNy1ev5gtvIl7W8EGEngE7fWZuEHozhgi9krj2bVnVOqYyKdO4m/nDYSpSNuz5AbaqCY4gEFAb1lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0zjcxO113Q63sZ2ml83+xIsT5mY9w5oALqPYQtj3q3E=;
 b=t0sukC4HxS8KnIy0N+KvC3wuvmn618wvumh5NEJ3Pk/p8yK/Dlw10qrTI1Mmv9qceDewLV49qtpUx13nBphncVDHXcJSOJSxxy9IE3nekhF+aHZZ8EQEvI6YSzYbl0BmJq9cd7ucZb4tf/RA0PHdoj5tq1rfWWvO7YeULldz0bU=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA2PR10MB4778.namprd10.prod.outlook.com (2603:10b6:806:114::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.17; Wed, 19 Feb
 2025 01:35:40 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8445.017; Wed, 19 Feb 2025
 01:35:40 +0000
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
In-Reply-To: <20250218182207.3982214-3-hch@lst.de> (Christoph Hellwig's
	message of "Tue, 18 Feb 2025 19:21:57 +0100")
Organization: Oracle Corporation
Message-ID: <yq1ldu2ogxw.fsf@ca-mkp.ca.oracle.com>
References: <20250218182207.3982214-1-hch@lst.de>
	<20250218182207.3982214-3-hch@lst.de>
Date: Tue, 18 Feb 2025 20:35:38 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN8PR04CA0057.namprd04.prod.outlook.com
 (2603:10b6:408:d4::31) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA2PR10MB4778:EE_
X-MS-Office365-Filtering-Correlation-Id: b9c5b7bf-b4f3-4528-9ba6-08dd5085b7e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lrL6muyk16Nxe+imgSq5f5/pHUXpnsMmnu82RRaO1/b34uJRVPdQvdGT1lKU?=
 =?us-ascii?Q?XL14dzi4go4czohyr8Zg83qBpQoYP40ftNdKC+gbyiamGjTpy6+39Buag9/R?=
 =?us-ascii?Q?k4fmuO1QXu3Y83Y08U7SWKRLLqnco9NAa4/ROhfJehuRMIXVtZyAg0ZHrgnx?=
 =?us-ascii?Q?Ugde35Lz1Afq4PEDqyOxvToheZHPXgao+274Je6dmArCdlRu9F89evYU0KIy?=
 =?us-ascii?Q?/qwT7H/8DbDKFBVvHel/fMjx8z/+6vKydCRqlg6tKRq/Sg7AhWl28Ik0u3lc?=
 =?us-ascii?Q?WTidwdfArP18lX6Oh+mlX5qKoEyJlF5PMuRT522uGrCoHgKqK2yURgn8MkKY?=
 =?us-ascii?Q?keJVgfiFUhA6GdbfXsDp2bERr8KNeJ3aSeTEY0kaGRYdbFL2i+X1gSSQPSVE?=
 =?us-ascii?Q?TN1za0he0a2B+pH1LkSpSnZfSmVoD2eKPSyKJo/hcBa4Mc1ZyH5+1fWSFZqS?=
 =?us-ascii?Q?7IH/O0nNz6sa+T3J43zEPIHlw1SG9JrdvQRWabZJJXL2N/HSIQ9+/NVpVkYq?=
 =?us-ascii?Q?ETpkwLEcTJtXFITIfynx4/YFbh4qo7FeFrNuWTXmZ7KY8VIWgbZXk5/b9rrp?=
 =?us-ascii?Q?5sEwSGBamjmFLJM7+Osoc1KxazUxUysQFAX3YFyfglkghHOEUSeErsHzumGS?=
 =?us-ascii?Q?hjKgIbs9+nqInWS9YkP3g5iv9rWPKc9rW407EQxMo4850exC88RaxLYEM6xY?=
 =?us-ascii?Q?AIpcS/ifjD2fkQYRl9VU8rdX314jkGcBFr6i08GWPupxKUdojhEAGAUyNd4r?=
 =?us-ascii?Q?T5Fp2XRf7bg52G48VD3cwFNinymDuxQ8JQKhLRqmR7i3yL8490eudTAQFxS0?=
 =?us-ascii?Q?9vscCcL5/pF17wAzj5LPohklBtxiineXO9cA9SMD58yYmjMr9hxc8nkNfvkl?=
 =?us-ascii?Q?t60UaQ5pIeM3adqcfDpwYKw+oRZM0nB7vXKvDQZKnwxezSPjC8wYyJqAuTmu?=
 =?us-ascii?Q?sPgq7ovfzSwlfqm9ue8mUPGvy7B+6hPfY4uHbzPBsHPzH9MlgXxXpt2bFH/m?=
 =?us-ascii?Q?J2S9Y+wLpYyiNgdTPx8eGCr7lcL5v4GIZIh+eWGGUKsVHuALwQyuvd2SRA81?=
 =?us-ascii?Q?E+nhEqG1igg+r5ywLYOq06LjJc/G9uSfnExmvOZoi1VeHNwCS0s+YrUwTZZS?=
 =?us-ascii?Q?xfgVGnm9y6FyUm4JL/4tKr/rA8is/ueh/OTYCq2gbQNVA4c09gDoJKbOxK1D?=
 =?us-ascii?Q?3Gq7NrlNvafzSuNkeLActFA3q86h/RFyOOyEWhQERGQ/r1ZIQq7t1zEPwxuU?=
 =?us-ascii?Q?pPXLny4SZeR06Iy0JhsVYoZ1JtOynKa5VJUrYNp50C7NF+os6fL+5w2uM4b7?=
 =?us-ascii?Q?SLlLI4OsV1KvUp72YyfPF83fIFsjqnRkjECtux8yRz6Javugh0mugIi7xbOP?=
 =?us-ascii?Q?uQf/rWnN4oZRtYhOd5n8Zm5YWl2d?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RArOZUS4vPy3wSNiBe3SLbVYfpMJC3JJGnyC6EZBLoFF6dungh6RBbChXEI7?=
 =?us-ascii?Q?sys9gdbXMLkDNGeMYY4rJ6wTJybz+SOKe6+U70dF+w/KdXoeo0tF/hhvavdW?=
 =?us-ascii?Q?pBaEyQyQx9e5ZvBQNKExHcWClDhd4gCVtt0M0JKGGvqKnXM3TWej/zxN9UpD?=
 =?us-ascii?Q?nRHvCcfxCNU6kbd5l46BiJkfP3iaOUCru3NZpip4EHyPdWSy9O9h3ni8BxXD?=
 =?us-ascii?Q?L+6NTPlDewqlXSW2U4JPsg4ngbUFmppXB9pu6RbZynQcaznycs+LH3aCGK4L?=
 =?us-ascii?Q?J2LXhU/yNsauGh5OIkgnPhe9DnKPTm/K7TLsE5Bt84+q4jQ7uEe/SdZbhZQV?=
 =?us-ascii?Q?3Q6z0UwMvPvwENxHYCqToOb9Q9tTe5yYn6Q2hOVdU2Y6cvff6eaZSV3mQgA0?=
 =?us-ascii?Q?wCdiR1+InSD0IeMig8aKbGhOBVd6bBMo7TQYMR/NHM2RP5IykAg0SIi0CYTG?=
 =?us-ascii?Q?rjdJ+KENjyR3c7haD1jUUAEWlmDhoj+2eV4owIFMb4MpV2Lq3T/uAdwFnlKW?=
 =?us-ascii?Q?il7SV5tq5xuU6q+Ix8FMIc6L+I0xS/J0fyxfofQHq9jvfiGr1NSQH1QwymbY?=
 =?us-ascii?Q?ct0FlY+oakfCqs6xAA8PRkjpLf5A/luZatLTpbdcqDtOwd2RMGq65I//jGvy?=
 =?us-ascii?Q?x6Gxg4m6mlPg2zMJicbmuHbp5RuVnQ2PDonZapGPCaFopQQ/1rCSpXqBXyWC?=
 =?us-ascii?Q?wkCnJEwcA8s4PNgQiLYHydbvJQNjESAB8Dk5hCdR/GJ0bXtskCec/pS9UuEk?=
 =?us-ascii?Q?RUkKvT6x0SCpNh+flWuZ8iMUT8JHe5hJ+lXn+noTyVOwIjvaGO5uT2Fo4/B+?=
 =?us-ascii?Q?fy6/wJbA7bfmerz9x6N5NGkHA8+VRzFzXtlwFhXzqDgiaN40kkiJ72CmyRJc?=
 =?us-ascii?Q?1k6Hz9cI5G9GecUG5pnXz+Zamv+Ix2PeKGzMi24295tG0AmXzV1PziRxah3L?=
 =?us-ascii?Q?u6tnFF0ihdW0yfpVTWtbIT3FVJFK4kmkAlNPB+mxFnRZ28xCN03UpGU96foa?=
 =?us-ascii?Q?EZ4P9n7WAxUDM8irw9gph/Z8l7nwP7OMe/k2MTiIDp6RDoOqZ8AFEXoNB8Co?=
 =?us-ascii?Q?4VsA+Wi61VEjIHcKMaDxM15q4Xw2PbiiruvWBi12ODxo1eGAJma33TwcQp1t?=
 =?us-ascii?Q?OgtEFOmSb1pONMGnFFkWESi7qL8W5MOMSFUrY2P5jPDJOGJFKkH7zbGEKOE3?=
 =?us-ascii?Q?Mo+p91TMw0m14ZCkhq2K9c+NIIpIz4uslGjR8lpBMHl2eUmFzZbRLoJkM1Xu?=
 =?us-ascii?Q?IebwCmhOvTkkwGLhR6Z093NCSlUEz/cZge6uIsSfjkShNnaegMbGIpptqH7i?=
 =?us-ascii?Q?N6hX985mgj6ETB8sU0sAhR/pO9AMA72p5IBCLvvKEq7dnmrwpfp5EWxr6Qcj?=
 =?us-ascii?Q?pFZq8ajcBH/h7h5lWvyWul3jAEjz4Xas0XvRPd9TCmI3f8tduoGwzm1beGZQ?=
 =?us-ascii?Q?5nooMzSA0KnLoSlraxkOSCjXHuUl8d0gjY/dLNnJqb/0/4vUz7GiW/U7A3WJ?=
 =?us-ascii?Q?UXG86AN7HDJk1KkvuPI9rauIk59jvNo1lTBHOjujhs7O6XZ4Pkls8Fk+VwmT?=
 =?us-ascii?Q?r7nNtfrm5UGB2aLraqP/mDVTA5WWASd2TgfNg1HvQ4xi5WDIdhr5YE690cSA?=
 =?us-ascii?Q?nA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RkIPAsjNfxXsOtqGmtaICVUDVz/ReOBxb6U3sGxjjE0dVfjzkREKv63GG/XqscXKiHjIaHsBh9KQSCsIubtqfLNLNxa4gOVKpiuYkkl/ihLjd/xtf1PfUI77gEOUahxtdRP/TW+KpPP0eXIPrR/4BrcViADOwuQeBEL0vFYzRdQE6a8YgN1mzGkxH9CV1DDC6I+VCIIKCImVwZfXGXKsauJ4xwz7zUT7gers5x7XRNNOc3xvwjeDy5BNkohKtrhgNRZcl9QSkJpUCHNo9wyL2c2N9SuMp8COzFDPNqSe42VvcPbVwN0ordkqBdI6SzP2glMdpA1JnFQSiSSg1neegLq2sPFK1dThuXkqw/5JHvH7JFghVUx7/V4gBrPLeO+icANum2c6Ed7/CwD86UPUFLlRGt0+vCB/v7sTyWYeztB6W9n8z6KlWbgVuFBsWSXMCldBDQRBzC2VME3FDXeXdouTNpBtvfUwB8VnlkaTAWzBrfIzRaQB7lNqnbt0eY9NHgf2++lNaPBk7wmJVWiLr9d1K80BHd+4yM/NufFIrxWYXqY3A82HCLI/wgjASohawmquQducj1dWDZSrkTZ6DYv0ETiC9P2khJVLmf+Yuvk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9c5b7bf-b4f3-4528-9ba6-08dd5085b7e7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 01:35:40.4043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nlI1ZDMIQvE+w5gtjJvmF93C/bkWJHrT0Oh5+Qo+og2wRZvEnHO20zY99/XsW3BHJlzD3NQtL4xkXFkiD/A9U0QTrmaN14dgnWRBBHoAulc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4778
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-19_01,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502190008
X-Proofpoint-ORIG-GUID: PsRQ2ZCBp-2dtSIhKFqDj7kE9oT_odlN
X-Proofpoint-GUID: PsRQ2ZCBp-2dtSIhKFqDj7kE9oT_odlN


Christoph,

> The code that automatically creates a integrity payload and generates
> / verifies the checksums for bios that don't have submitter-provided
> integrity payload currently sits right in the middle of the block
> integrity metadata infrastruture. Split it into a separate file to
> make the different layers clear.

Looks good to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
