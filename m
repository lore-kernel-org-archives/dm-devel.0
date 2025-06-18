Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A35127F73E
	for <dm-devel@lists.linux.dev>; Wed, 18 Jun 2025 08:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750235901; cv=fail; b=WCKXSFtH5lHu2JA8T58fsXbIDh7+yf6CuAk7gGItddp/Zz8/5+Sh+t2DlnJlSWV22qH50mNxTvi1i6pXIQISnGDXIzdnby2yE4qZl39BZHc3BsIKko8Dkx4Ou19N9iF6+SlM8yfl3Vwe4DYcl87T7D3PuB76bu26mzmll4gnnIE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750235901; c=relaxed/simple;
	bh=L5wtCk1QDiuWUHpu/gwZQF/1/8zpDqpyPSRvRY7ZRvA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nWYaE0e+olwweUGSoujFpjchlIUZnalEYIW4RDuB++0VYXnilb+NrDpg8fk7ps78U7bszXWqPFHepkyoxldDr10RetRvc2qgkkqOL4rH3FlHd8mGbFXIhfmizPMrxC+hx+n0lC3oZE3nid0Ik6erWEDmbsDGFej3rUYpJ3ti/MY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YyulVQdG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lPtpPGf9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YyulVQdG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lPtpPGf9"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55I7GnlN004509;
	Wed, 18 Jun 2025 08:38:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fHOwhRk00Ncd9SP78JSvZuIIc7o9BVO8qq6+ka6OWh8=; b=
	YyulVQdGTuNRysHLtMtzgi9nMuqu5JUhMl/VQPWGvxrlH7PKctqOoxa8clolVmEi
	/TJ42PBjWI8EvwlHJSb/Ytc1t2Mhc+ROQGWKJOdEK16Vr0reaaCiISTL03Xelefk
	Kpn428jZxBaHmZpx3m3gKol1aTv5NEOUGZsEz526Bqvbf5AiUk6QlldoipQ9th7I
	TCQFOoGqKIbmh1eef3HRTffIA1bjRsAJfIRx54xcf07QGg3Hp1pSxlP/1i6xzSj9
	cPi8sdDw/D+blbgd3e99Cvw61z9FtSrIcKWuDtsRKxP7esx1gQLBEEiehvPOk2s/
	YUDySYE4iAuYVZnXALEKBg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47900eyb54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Jun 2025 08:38:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55I7WFxQ031766;
	Wed, 18 Jun 2025 08:38:02 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 478yha47hy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Jun 2025 08:38:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lfYBwDCGB2oDmWFogOKuJHgJXxcpJXphLV/vm6yVlqCd5Rxi7J4E+3ltCCuGd1uxmrrFdQbt14ScI3L0IMT3+sB5f92tgXokvKRwO71HTEz1iz1lYhZ8CdJt8JZDV1Y1CiX2EYuhdwu6lKRP3o6+UqznTD5cvjDKJVkdhXgZcRycc8kdAkIGZ+XLEZPe27E7+X8bIz8WWYcdo/1ajXFpAxPVlLzDyTxS8KJrog9cnE+Poby27LNoEbKI0xCVEKlay+m9AXnYxihoxiK7jvLvkkbqBuiy6Z9LPSF1dQLxQQNoQKFjng/9pISa5c+WNlmJhsY4AiAPOz2PBFhhzvxOrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fHOwhRk00Ncd9SP78JSvZuIIc7o9BVO8qq6+ka6OWh8=;
 b=BD1kxwMWwyyDG7+wLNZDCQl51FICnOMPpNQgYnbWtSDk3Or5XC4AiFki6gqRVJvQE/CnFpsT9nKUR06fvdRHbgE4zuO2Uj3TPcz0CCTpbkV3lP+0YFGPPFBKujg4ykqYeDLq9TJzXkmU9oDLYC82bLH+sfiuJag3ksHxrsyZ8vWpQegdVvc9tYXxBtgrP12tJmQ0d69+ieJxzU0CEgk73KuGanzhm/qeoocbWZcGGTGuz5LQjqhatg2/90ckUTOq7wgM4ARq/lVMtoQ4iDaWD24PxjARyhuEUOVfKPo5JA0KEt17FNUKxnSaxMqlnAcq8Vbv6EzQoPCOPrYG1hRyzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fHOwhRk00Ncd9SP78JSvZuIIc7o9BVO8qq6+ka6OWh8=;
 b=lPtpPGf9mRDWwiO31day9K/qysP3n2xy+jBzbkgsZI351J4GmQC1mAwVxUd/Njs2hq6lKJU8EOCCHdJpMEuFDktb1E7z5zla8DeF0BbW3+AAyL4jf1C6DkLin6HGTAuMwGqlkor+7Gh1HxbPS4xaQG+n8sl9PKsbWDaaupcnswg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV3PR10MB7769.namprd10.prod.outlook.com (2603:10b6:408:1b7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 18 Jun
 2025 08:37:59 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 08:37:59 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 2/5] md/raid0: set chunk_sectors limit
Date: Wed, 18 Jun 2025 08:37:34 +0000
Message-Id: <20250618083737.4084373-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250618083737.4084373-1-john.g.garry@oracle.com>
References: <20250618083737.4084373-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0079.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV3PR10MB7769:EE_
X-MS-Office365-Filtering-Correlation-Id: e1c5e1d4-4229-4b37-58f1-08ddae436e36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W0Of+xLdggyEmPFcIharvMwWkmZO6gfRtO6QlUv+3ibzD7y97bFTMqkG0PyZ?=
 =?us-ascii?Q?QVJzYeSZcxMIlnflQSKFwsB2TJSkZA1PEz1dIhi0hKfBOXHJMi8coUuBPd5e?=
 =?us-ascii?Q?Y5fjSODhlELA8wzJFMbFNJ7ZREByEaLvmAtyfIxgNfLYuIE7IMgfAgiaTAEr?=
 =?us-ascii?Q?OzKbgnj4Z0TAKk2T31UmRHZ1Aej3b0YexnE41yaIUaqm54AxGKSJN4MpW7Ag?=
 =?us-ascii?Q?wtuNDk5FaWDeDxm1Y9l3nDWRx/LNnJufl4M3KJifop65sS3WPpsEfh/B9Rsk?=
 =?us-ascii?Q?uSdCis3GwYeyzPQHQHALUzaon2nagH2jtS94Za0elDWzOv6lObPdDWvOTs1E?=
 =?us-ascii?Q?U+E2fKxS2JGzOBouvanBMROZWSR+n2JVmw3rrV7pLF+EI7DxuUoNHU77lG9S?=
 =?us-ascii?Q?dPUiUA6yzl+hW9O/6E7162oWT0WPYoC5vp5Wv2R3SDHdkezotyI2Ku7+Fz8R?=
 =?us-ascii?Q?9KJh1eiuSUoQfXMG/xb5Gmd2XevA8EDQloqEX4EFX7/gh+/6deo6snGHna+B?=
 =?us-ascii?Q?vOdvSygd42nkO1R+Rih8xJkNaUKXvIWYw3TE3Xny4ryKBCJll0/RyeOlAUpO?=
 =?us-ascii?Q?3Gd1Dyuh4O85YjCnCRBBEl0cj6MehISk6sZGLHH8U4LvZfpXNKrhouWA5xai?=
 =?us-ascii?Q?lx2gRUfes3qMdlQDWi2RsG4ITMgWvl4oZCsswCp8NbIqvA5bdekYkM/VHVUd?=
 =?us-ascii?Q?+bSGpmK1x/Bp7dcJBK0+novJLa6PhjMhMHNcfGQTEsv+i5yiXKmgOTru26H/?=
 =?us-ascii?Q?Jj3i3e0iX9J0h5BFiATbxqF7uW4ePaLBuD8FVFXqpEsZoqMfa5TZfKMM6It+?=
 =?us-ascii?Q?ptYOZYz0J0mZQiqqeULlQGh5RSNJsJSwKTu++EIvKVPNyNNz4bHhIEeXfY4W?=
 =?us-ascii?Q?kX8RL/Mhb63XwxpnLxWX8spoP+IGzWD/EyWSyQXN/BR5QzeRe72zUSzKAPDy?=
 =?us-ascii?Q?xVoehNxQVfVgbWFdDge0oNbTHc6KFpcUR+JkF7mcRwt3fIsvaQo/ABsgtyn4?=
 =?us-ascii?Q?VUyh80JCvbBlDKb0TBa0AmsC62JPRSLij0mE4SJ6NqhFLyaIgykH/+mVi7Wv?=
 =?us-ascii?Q?EGDJXv1WasOXO6KlgyX41YDlQyKcuy3DyTidiUjuL7125c+MKUocarEO7UWb?=
 =?us-ascii?Q?wTQWMF/oK0B5LWNSESnntufutFckKJUt+0AYqg0rHtFIafICk1yY/frViuEQ?=
 =?us-ascii?Q?J5Tk5FE9ONSAyK20Z57gsdeVN8l47zPiMdWL2zwDuR+3TjZQUmfCMWgreZo3?=
 =?us-ascii?Q?IYTsU+IFnLKbz3GmI5QPurBhhLey1Coa30YgzDIkDb9RF+iiK/TlY8LZ6jM7?=
 =?us-ascii?Q?D/K3rbtubGswSVxjrKUQGtSFx7w0tH8K4HJ8RfVFIkNpa1+yC7M3fnulPtf4?=
 =?us-ascii?Q?bTzVyx9RLS80u22Gq4OvgGPHl62jbQlPr+rk8Tg6RFUBuU6CYJeyj7mFCODI?=
 =?us-ascii?Q?Kf1a9bCbtvk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zkynLkYsoFoBgvsrBHEUm9JTufGpuY9Ru247p3uNeMiRFMn/I9Yd/32vaydB?=
 =?us-ascii?Q?xxkOaI0/MjObr7v+L/PClaVtRM+dNiolQI9/evSNkhlsyY1HLM1RTW2I/mQq?=
 =?us-ascii?Q?oYmdSx4dMP9nbcI00G8tY5FECkaVguhjJLH7OwDcAO2AbSBB60tKb5MmYmnX?=
 =?us-ascii?Q?qoYNwPrH/VIkejecEq6RbN8TtWtLv1USfe8BGh1tTZkck+2LvxlYH0Rjejyu?=
 =?us-ascii?Q?2MBeQkZ+WdYqgu3LaJryzlgvVPQWZ+jayMCbHL1xiMTtPMBq5azrMktcP+cR?=
 =?us-ascii?Q?GgXtciY3adDmt22pRRmmNUeQMlyjGiA3ni49U0+QdNHeD6WI2Ka1m+n1B0Lv?=
 =?us-ascii?Q?1oP8PlvAq6tCLmWNgY/uoUb85j93ih23mg7jVsfUE2L2H8fzfYMNk5AkSIp2?=
 =?us-ascii?Q?11yOunzIq8WpoZ9qz3n0BqaX6rXylWZyyEfUpOsWDfVmK1Bx1Kx65hgwHJ+h?=
 =?us-ascii?Q?/+78LGiGZf+77caMjwAVQdVSVRKMRL7Byi55u3Nth8hRDV6X3HYZcQXwnrOv?=
 =?us-ascii?Q?lCI6jEdKJTK6EJgH8P3nhVZff/Yvg1G84MQ31GoKw/E8Gd6Wj10ti2pK3eEV?=
 =?us-ascii?Q?Sq8KyeHHPkqjxaXZ6tQgHR6N2QrXJvTpEa7HjYfAYvEWeK0tElrTjCLLOUmF?=
 =?us-ascii?Q?DoJlTXiosBImY1KW28kXRxB3IFWSstR9W85AKL2/BVNYiOX1rfw3COUUyqZj?=
 =?us-ascii?Q?J4cuvvH24Iiv/oxBQWoBTq04287vZUnYjc3h+TuGbrUOyhOWOmsq9bWCt+SL?=
 =?us-ascii?Q?dS33rqPLks2Cb+i8M4ISGesGtwHr2+/mW+gp9d9IE3dWEIJKzVAiFzk1OFIf?=
 =?us-ascii?Q?416H5wyTxK3ASyY4sQjQPW0tIY+uoPu5L4uyS+yM2+oTRnUN0eBpjpVb0Yrk?=
 =?us-ascii?Q?lOZEQppK2QSywVTDSu5AoLoUp/DjllkUETYoFC7mO3thtCcScDwsCkYmWpVf?=
 =?us-ascii?Q?cTMzS+ocQ0wYHqaX6T9RQ+3GdrVwQ/ASxhBq+7Z7DOXYJ8PLgp6O/+ApPE5S?=
 =?us-ascii?Q?zu6Tj4MwQ6pLS+X8m1Qxane4WohOJnvuboFTvmQ3H15ht88XAvae+nbeRQ3O?=
 =?us-ascii?Q?RcEH3rWIYEWX0/1KEYxmSAix+ICYXt7W2AgD/7evQbE4i9gajj4/eTCz6PPl?=
 =?us-ascii?Q?4VCcZ0Va7x+PqRSlDpD/nevXluG6uBTpa+pfIRatz5eKBNhXEbZgcajdY+p5?=
 =?us-ascii?Q?tVMib/ZDqw4FerhRKBF061cd2kKtujO71I7mscmB/Pb2riiE5N42lr2t94M9?=
 =?us-ascii?Q?+VKRQyGAlkMRidx+w/f1h+WRjabOLAB5oOGm+gE0XNMGAqwz/RDgVKLLZvrV?=
 =?us-ascii?Q?UGgSK6hG4UKXaYay2gGXgryXzSAo8ARbA7DHKExWxZkG0pA3ZxnTL1g8qeAf?=
 =?us-ascii?Q?baNgAGLA3eLrsitLW9dXLxdCIztTKKQO59f7TN9Xyu/52F79/9nBGMSls07i?=
 =?us-ascii?Q?yfbEu8T8DVzpjCAYYvKoPwX2TF0eClMNx6ESGkSugsyE/uwHcx5UDkVF17fd?=
 =?us-ascii?Q?OKZOWmOnxCi5Hv9rZ0el/WsImstYJVC8RqVaQFA0EgFXgKuiQtRpLLreTp2r?=
 =?us-ascii?Q?aKMux6uC/DIm8QGjzmMLSp76nRCN88G45/ZTNbng6INNHhBFNSXv8EjYTYyQ?=
 =?us-ascii?Q?lA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bQHzB0Vwcmvx86TS4r8k4rs0QVOJ0+s9mx0n2YZ1JzIMXxaYcwTwO36FWO+NrCiq36hCBon5NOKbPHrLuQ5Y7QDNaDXhx6QZ/RR0HYTYYhocBT0sOwfMRfx5diU+tBL/xoeoT3ViY0wpy9FZROFiBLcFd44+CY9nbhzI2dfeBGu09XF5DRhhBGRJXpm9cQ9eznWkyRjMn2QdRZeRtM9mwQzncrS3WFIPLfuhGcirLNwPmlhVxgGJqMe62lEQzf7SVQPTu1Y4uQd2PNUeAHf06enyiBaF+gL3y2GBBYtsa4UDvRuCrHS+WTzmYScdxw3loluKY40X2W1gw+DFTQNkuiJ2pzN8mDo9dhQdk1OA+Q07yZsyRyRC9EcZV4wo2wrKTugAKOUCHGiGuYy+cNrsnzd3mfM79/e6QhayaZOabrayT4/as9yvUNE39nu/UelSIxDxLGXBciIUsNI2r5p5N+ICUy3v1nExvyZRe3H5KTnkBpxcprWVDN9jaCKiORoUXI1p4t2B9PboQzhYm++zOivtZGJ5CFDtQ5fV/yCD2Ap9tzNpk7X2ip1IMenR1Ip9M9d7El+ZFs+gjCM/8FH5GAuEI/snskioFX+hrrY8Lfk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1c5e1d4-4229-4b37-58f1-08ddae436e36
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 08:37:59.6195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7VuYFPocLKx4eOAXtH0hbVlo4LnaflLFBYf2dFtC30nRQHrgtKWSE1zEYfiv3B3pLBqlSVC5aPGQlSbvPqjUMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7769
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-18_03,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506180073
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE4MDA3NCBTYWx0ZWRfX74uJybRl3he5 OqrNDERwzZGTzCu5gl7GZC+Zig7SCzQ/EI1406wN8hx6Lzt9+1iAEYwXtqsGR7CG2ZUvVWCT2wa 9bfiGhYN7vn5wYkvJhoKwaYvzZOGV07aKsyfjzMUCC732+85owjvSXqCet8qVa/uLQXbIXQWB76
 Z4ZujHZyNRzWN7Oi/B7aXAPQ672hKkXanyNe77bm6nD2S4nzMOFovJje5QFwyLEM50BFTjJJVkV Hvz9E9AVI0xXVRq2Tcixw+8GIYc0i9EoLJ0/FLIQ7LXS2uIGJ20HEzcyZqGfNWbOkuzHc0hQQgs /7L41byQLHXLINmL0q+wIk879c0lz1JFxnHZNfhxSsn3n7ADDmv+BcczQ2hZnytrHJkS2fwmtCx
 cI+N9fKmi+AbaoWIjY4I4hn3bDsp6kOoIoe8dQq0Yknd3nhut7Yo1irN8gYG9IekXaI9OgZx
X-Proofpoint-ORIG-GUID: XtQEhbx_okVNbuOxUb-K99k9DJvHZYz6
X-Authority-Analysis: v=2.4 cv=X/5SKHTe c=1 sm=1 tr=0 ts=68527af4 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=oeePQw0IGsqOEWDZT9MA:9
X-Proofpoint-GUID: XtQEhbx_okVNbuOxUb-K99k9DJvHZYz6

Currently we use min io size as the chunk size when deciding on the
atomic write size limits - see blk_stack_atomic_writes_head().

The limit min_io size is not a reliable value to store the chunk size, as
this may be mutated by the block stacking code. Such an example would be
for the min io size less than the physical block size, and the min io size
is raised to the physical block size - see blk_stack_limits().

The block stacking limits will rely on chunk_sectors in future,
so set this value (to the chunk size).

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index d8f639f4ae12..cbe2a9054cb9 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -384,6 +384,7 @@ static int raid0_set_limits(struct mddev *mddev)
 	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * mddev->raid_disks;
+	lim.chunk_sectors = mddev->chunk_sectors;
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
-- 
2.31.1

