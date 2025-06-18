Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AA227F73B
	for <dm-devel@lists.linux.dev>; Wed, 18 Jun 2025 08:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750235901; cv=fail; b=XzTUqrc+TLORDzSYOn9cUf9j2rIr3ZHk3sBUYbcMzIb/EQAQt0ylzsHGgTpAdtwah1lcEd+JwATztAbc30s5nxTHIWrW2B8QDCPKPuM57eYu/NTp5M+DMbl5Wt/9ct0XHJBsa2w8NWnEYkbVDD2iWaYCxxuj9mGXQk5DqdCWKWA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750235901; c=relaxed/simple;
	bh=m26dLTFrVoOLT9/JYHvR3TQz3FhonGR4VvzPqVYSqZk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sP68wdDsPkWBaB3a5fQOG3Q3v0y67eJhHvxYVmAeceBHfncKOCxOMEVXFAm73SVzuRZ3JS+xeX7mXeMOanucEDXaj2+Z/V/1t9l3WXNiyzTxFMbuyNrJPNWeDxZcZ57oULC3AMPNcThZ/u/pw0npA4AE3eLf0HiBLHiDgRXjP4k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hAbkvWTp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gbt2GRjd; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hAbkvWTp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gbt2GRjd"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55I7HRRm005385;
	Wed, 18 Jun 2025 08:38:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=RYZpB97zfWCB8KyRvMKySltaOPQsGfaUSHBKe69QD7Q=; b=
	hAbkvWTpCvitcG0JA8EWBs3ohd0xS2vn10ZmUlZk53YNyUHAlKR66D68xLfWtUmi
	B3LBwqAFydT/HodhPLOfgyjH6B2cYuzfUfbJoOVpHvjs1MUyDMQDvywdIYIQBXQj
	DZ0oRZk+0cAvYgVwNCjr5qi62zqnBRqcP6PMejTi8C8rkN4cSNjcvaLhrljF3jLv
	iY3MPOD80t9vgafMpT+E2OnuGHd3N85uwnPGSykYFenMDAq5sYOwmqYJsqOdKAqP
	mhSfvkV1sOSnG1/RPPvyNcgytCVTyUT2YCVxgm3C9C7Daihp8CDNxZ3k8mr4G7AY
	QNfkVOq+y3ztvyl4ivLreg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47900eyb5f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Jun 2025 08:38:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55I6nsf5034417;
	Wed, 18 Jun 2025 08:38:09 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 478yha4b02-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Jun 2025 08:38:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kcsgJU6sFv4k0Z63vmO3hDR8qbsvEelisHZoM+fhJKdPSF5S93tpQBEFNeeHO9JLgLXgPsq7pcPyVotnc2PJmLB410W3Nk7f0VR4iNjxuUh9far+l4upWVzG05kPT8vQf54SlxMnRUSKHLOBQtZtLihw9nJ6VzYm5AIjU5ygoT43BFtchHQgQ8JqE26A8yImqYfLOYFAexIYtiaszRXq4GUFw4sHGcbS2k/LpR+sAYvyA684+HSgWFFQi4/yNy09urIMaFV5g7WQUBZDky4A23U62P7G7RMm9zPjHrEdCrypIcvWp8MzSZkuY1Ok/TPePXU2iObs+ReP5mnQRUKPfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RYZpB97zfWCB8KyRvMKySltaOPQsGfaUSHBKe69QD7Q=;
 b=Z8yiH7k+bPSQXY5Me4C1UxUfCZYHEB8AIlPKwQMACGzKRWfSk/MnpiBzRnojTvmPxDPPJGjx0imfVPVlC/A3DTgY+Ib0QJDaBIG0R/IbzG2VksOzKYlmx2cUUONWmPTddn0YpUfNtc06dJ5HAAPNMpMChl4mBfkcdcCOzZ8GlrqGUllO/tTBARtTN3s31F8CCAX+9RQCCcI6MY1WLu9SgzLG6oQENapaDFxchANWfkBb0K/Uh45R607fGwaAqsu+c9sddklNtNgWoOybm9nAk8Wa4nl7t7qUDmszXy94MsCggx0q+RGINN+nW2kI1dC9mcdzoHTg3BQn3wFY8Qp++w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RYZpB97zfWCB8KyRvMKySltaOPQsGfaUSHBKe69QD7Q=;
 b=gbt2GRjdJliX8fo57fA1/yJGQO10zs8Dkj/8kwHlPrD/2KhuhfenRGy0wFVB7RO93LlBfldsj506yUh040e+H+6/jqXM3r6nieij4ssEmrk6vSarnCQQurFB++wHh+hURpDVSwhBiUy0PonY54uKrdFmpZqYM5PVtV9albYpSTI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV3PR10MB7769.namprd10.prod.outlook.com (2603:10b6:408:1b7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 18 Jun
 2025 08:38:07 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 08:38:06 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 5/5] block: use chunk_sectors when evaluating stacked atomic write limits
Date: Wed, 18 Jun 2025 08:37:37 +0000
Message-Id: <20250618083737.4084373-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250618083737.4084373-1-john.g.garry@oracle.com>
References: <20250618083737.4084373-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0149.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::34) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV3PR10MB7769:EE_
X-MS-Office365-Filtering-Correlation-Id: e26ded56-0407-4f83-4476-08ddae437278
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sQh3qoc/J4haAafhGwj8tEVPrKpxopz700j8ax7O/Be0DAZZ3durY1pMetgp?=
 =?us-ascii?Q?SEsqUi3houZIcED6KxaSU5e7AxhHqcMayJtUE04EIFcp2ohobi+hW1Ftucrw?=
 =?us-ascii?Q?ZsAGCMXmYECQQSz1SO67obK2Vt7X4a4osWNlEdYeLIdm2GND0gNtdiXtmiqG?=
 =?us-ascii?Q?KnZ+hmUHGaup7xgbMcanBKMkWH6FFQXLLfwC0T0vJTiJ/8/Nq8/kN6p/nc/t?=
 =?us-ascii?Q?aIYPVL9lRwGqb9QBlmvniCll0hgJCm9Tmj7hTGy1XQL+a5hHBmv9GEdXUR3/?=
 =?us-ascii?Q?8NCR3Gg6KfACVqAZha5vm7W6NWHItLut/Z4f26xaKoaEGxQmWD7ij6VTGaI3?=
 =?us-ascii?Q?x1WR1tYcIWAklRZdWeNgtO8qkGg+gWcIqgudWyn8SMMY+js9U3lTbwItlebQ?=
 =?us-ascii?Q?pYG9FiDG4P6UwB0binOvNIo0X9+gR827cvgjBNEtx+xbKlSSWiq7/zbpE+5E?=
 =?us-ascii?Q?6ZlEhmZ+S1Cy5YKKowAiCiL/iBqh8tALW6ivwTeMhE5NPH16JAQM+umYsW9I?=
 =?us-ascii?Q?1+4JK4Xao4Hc1OZksVZwolXbKT2Y0lwLmJrPNVbrLDhbFiisPMnekykmU2l9?=
 =?us-ascii?Q?4Fa7VKf1CKPjrDXejMiUkQHyXqFL8tc/ytuA/QF7AWS2JcjEtA5/Cx4jMJAV?=
 =?us-ascii?Q?xpfdaXyrPO1Ne4wl+AuQ6fwTwS6jXjnYY84b7b4E+be6DJPpkj6ptWZa9whA?=
 =?us-ascii?Q?gRJuNgcIgdMFJoriJYKxXL2prA+I7E7L6wHNzw00f8E6Cp7FS/hxut3m4POJ?=
 =?us-ascii?Q?4ZBHiHY8LzJlnFgwF5yS/VAlSsv0nS58fe0AZI6nxc1b6YDt36Q8wewXFRUj?=
 =?us-ascii?Q?xV7cfsoqX28sHj0WI6eIV37f1k7QABR3fW4H4pmtgZIatiimyGle4j/8UBF5?=
 =?us-ascii?Q?kWGFZPSHPyhbBzZjKCaXD9FuEGYjm6ZCPoyufHP7v7TEXnAK4BwP2jV/PjgT?=
 =?us-ascii?Q?W7FiadelMDFd95PN9efMZEKTXBNQexE3PpTh5Ve6Z25sNY8k/xHp0odh2toW?=
 =?us-ascii?Q?2aavivFqZECmw2MEuBfRjP6qPkjhtRMovzytTgHna3nOnE8S1Gsgn44/11Jk?=
 =?us-ascii?Q?u+JoATGvUnfVxSujS1F8wgtR5ijEyGrX734QJcM7ASFjljXeyx/OzCDYuiVf?=
 =?us-ascii?Q?PxH8Q+0yb2DOOVHzAkaZ6T2gqWzC7Ajyho5FiB1iq7NP4FR4Q8ptPPe6q7eI?=
 =?us-ascii?Q?c3vXfj8+GkI0b0ZfEux1hk/KZTS2C9ct5+LKBf0dSrkaG9eRVVRgkDyXE1WN?=
 =?us-ascii?Q?U982NMtgpGbkFEEXgE+ee4zAwFWxZEKkWCzO2KXoKyF/zB3smEny5sOjf8/j?=
 =?us-ascii?Q?qXKxKJC2u60daRQ0jsdDJ3liBDhGmec0N8kXpNW2H35XThBrXR1Rqd7y3sa5?=
 =?us-ascii?Q?4Wn8mRcqqW08uPOTmpe76IhjmUBl?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0DdqeXZiuGCk0udKFPve9LJWX9Z4QmtbHod3CmVLShGoo5EaVzM3KPFENSzg?=
 =?us-ascii?Q?DPE1POuogxD9qAfl8Ma/7dzy+xwJpQbJU6Vvs8GsZVxoOHFoeL0adE/h4mXI?=
 =?us-ascii?Q?mz7FsqMDAkAsbr+A93YuNDbVcIioZ74Z2hV7gTGV3g6A9rD+aMWrYmNI4amu?=
 =?us-ascii?Q?jOyTjc0j8uZAUbWaZX1Q/oKzU2FUZlq5JcmZ3n7QwN9zcdLDEE6FqQnAjQVI?=
 =?us-ascii?Q?ZKyAU9FBSJCRpFbRLeFWV0ni7yrinhvI01Dh5rot93fMSuWu7ymqecapxrZz?=
 =?us-ascii?Q?7eDZ+W3t1xBtgOMu5Yu5ng1MDiJsN7PjZ7hADRQM6Vd3LZP65ObUkIggtHbe?=
 =?us-ascii?Q?fBwH573aw3E5IPgNPZeGRWi+qp/6BIOX1pFdF8mq40qQJI9/oKt+vBhSxoeU?=
 =?us-ascii?Q?PgxhghVCfWPgZSD156ljUX0QM/Oa1VsTqvPlSoy00MceqpT6YZblOwHi5OG5?=
 =?us-ascii?Q?upwKXZ1bSETXHwa4U+cGi6986fWJDL27cDF6/ZMtr0/G09T23kH8GoN5Sshu?=
 =?us-ascii?Q?P0bbiLrVJInW4dfLUOxS3II3mYyfk5loYgY6Zz4bjboE+CxIF2/CFNAO2y3s?=
 =?us-ascii?Q?J70eiY1fhvpAUjd04is75nkPTC/cCVHQpBmIFdrce6LhboS/UnLgiiaGRfXv?=
 =?us-ascii?Q?tgGIbdId4plnnF8kniUjyPn1QOxy+o7zPsQHkQAXsCHpglwBxfLTC+sQ4B74?=
 =?us-ascii?Q?UY1eG8udlKBspWpUFKOxA6VX59ZcV9pS3PjjMv5cQe3WnkOUw87mPGWEO1Du?=
 =?us-ascii?Q?KfciWcGVtF00cYmo3EAT5vVuLwgDt7fkw6J1WDrCCVE6/MQhIPUSXXr0q8T5?=
 =?us-ascii?Q?gOZURq7rW4c5PdTFZAjuNr9xXvJpv2NJGCwz76i7BtJC+u0dEt0uw/zgTLS6?=
 =?us-ascii?Q?uKpa49YfaaE3r/j7pnsBIy2DDYQdwdrWE3YnrDYEyXp5mKK61IoeyteVW5T/?=
 =?us-ascii?Q?oRNebyCBk9UdqxUZ9mDaj8YgR15x5MwNVxeIr+Utswyxnot6OltNgaZR1C+1?=
 =?us-ascii?Q?OI84SoInnMQlCEh0gEuIhGkOIL6dZ1/XZho8LNH5gxi8I1jF8PqoR6KOOE3C?=
 =?us-ascii?Q?Z5zWU+hl05M13eHe6is0JivxdcKQ9Ai7H6gDMTX145Sb/BP81QNGjiXm2VIr?=
 =?us-ascii?Q?Y2vXIPkN01ovetNAVyAum/wsomqmQwRhP6ibXa5MocDGyBG6gwjOtlNHxsUK?=
 =?us-ascii?Q?pXf/6awetnU/8k2Tsp4PBwES6GBlOx9uRpVVvhlwY/2teFxBKz5StHgsU9lB?=
 =?us-ascii?Q?DpzAbmSEYAFo7Ie1wrpkX5RRWhwbm3VKOkdSIYRkoJ0wdjLTN1PjvN4sLmjv?=
 =?us-ascii?Q?RjZebHQszQMdjV/FXIjMBG3uLDzLuaILuX/+suEbuxOdEn4pVIYgTojZkD+7?=
 =?us-ascii?Q?jF26To1gX1bN7InnCmVo1raseSZJK4aZB3/zi+8UQhsB/Dv8wwZQZcrGp3kg?=
 =?us-ascii?Q?vcq9UR3sAzUYFntTls6BzRspzpXIz/SQEpXNcl8qynlEIvpRtUmuEsub7A8I?=
 =?us-ascii?Q?b315cjMQ7R7KB1dikN/zbBzRPsjxSYY21hIlcPTH/Xw4mmjBqhIrGYA58D60?=
 =?us-ascii?Q?aFrl5hPguK2zsti7ub3B3W1nKwSNKXVl0SBCzSzb9KCDZb5WJH/QfcOkXb0X?=
 =?us-ascii?Q?BQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uocI8oWxjdzc/sq1yCzNcbpqe3gk9wnYLPQYs8Uc8z6isUfueDgGz1hGWo9Kao1U2KzTXzusx9mQ/ttquI1B8jKi8d7FJD64XD0sBXmQO0Hfd32q2NO9JKFBGsbWqnGqnzis4fQ93IAXzzNLXRUDab7WLnXFbkPzfe4GKC5YS/Vwl7CkXVx082wUbOqzE+X8CYePFSN6SNfcXzFu3y5ZSw++CbajCBUNmTHOov4VkvdryFUxV5vqn6YtpRif7TI1bb40VYyFJ3z8SdNMANvttkKGWm1zssfo6M02Az/BhlldQunABFOgbx4apo0/1QrTxkSf3EjPeKDRTUL87tH+ZOKPdp4NWqFwHWAgeZCs1lseJ7iwEDnzBMlUy7aRHBJd/Om7+oOgk6w59BMaZAekLwPCwisizx/9Pi3M0vGnC8o4isAJoaXFJlaUKBEB22Q2IJWgCPKHXSryc24tCsPccgNfzD70zZFPJQvF6czPeHgGLLdpG4heKV1+SXJuxvVaaBWxBF75xaMF13pAImZ/12E9t0SIlO6ObuwHNvw1XiY2+mKp+9YAE46nTzj2LGni80HubYFvYKODYwhrOjNM+kQz4HhEH3M9BRVORXRRgMU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e26ded56-0407-4f83-4476-08ddae437278
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 08:38:06.8817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: epwDgkplxoIx9Y+DYR3TLPhbIST7+SoKsK7MaVv0x3uVjWC3rQOIBxyXY0OK+xcL0ZPQGJsg8IZfqCN4xntf4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7769
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-18_03,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506180073
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE4MDA3NCBTYWx0ZWRfXyaD+9GcKGbiU DWl0cCf+F2aOkyzeQrwrWesNuhYDBWmQBdfQxWAi+zL9ih2LRYvRzRQQq+/G4XPdb5DNfVao/KA jVE0Ao+e6szu3yoF3G1hG7fj7SJwDQCk7O9gStrOw3ACOrA0EbeaYC+s4xB3S1GS/cEvexm1YJN
 wF3Tw65cEBAHdUUo1pTnakX9PxYEJLja4n3k9ixW57fRrv23LEJ6hc8Qyw/8BZFq0XLhStOCxWu 7ZrCqakJkkI6hGx8/OKu9GGgiKNLl5uhZ/sq4gC7wDdrLw4ztBLLWQ4cq6kS3knxlQf2KIW7II0 IXGvBkxLm5vqN8kjy/V7yDa6vnLBSdfam8ho2ve1rwmANieWbKS7lodbaSr5CZieFlgvIGu2sOX
 H88xfdCtzEXvpxKaEfkHgB/Kzo+4KxG9jgJ1Qdn7slGpyVXp5WVp2bOHMZlinOFkZRmoqKJB
X-Proofpoint-ORIG-GUID: Ys0NnzhFSD2x4sm1ADu9F0ZXGC13GP4O
X-Authority-Analysis: v=2.4 cv=X/5SKHTe c=1 sm=1 tr=0 ts=68527af4 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8 a=qbs3ZK57z4IZS5yrueoA:9
X-Proofpoint-GUID: Ys0NnzhFSD2x4sm1ADu9F0ZXGC13GP4O

The atomic write unit max value is limited by any stacked device stripe
size.

It is required that the atomic write unit is a power-of-2 factor of the
stripe size.

Currently we use io_min limit to hold the stripe size, and check for a
io_min <= SECTOR_SIZE when deciding if we have a striped stacked device.

Nilay reports that this causes a problem when the physical block size is
greater than SECTOR_SIZE [0].

Furthermore, io_min may be mutated when stacking devices, and this makes
it a poor candidate to hold the stripe size. Such an example (of when
io_min may change) would be when the io_min is less than the physical
block size.

Use chunk_sectors to hold the stripe size, which is more appropriate.

[0] https://lore.kernel.org/linux-block/888f3b1d-7817-4007-b3b3-1a2ea04df771@linux.ibm.com/T/#mecca17129f72811137d3c2f1e477634e77f06781

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-settings.c | 51 +++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 22 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 7ca21fb32598..20d3563f5d3f 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -596,41 +596,47 @@ static bool blk_stack_atomic_writes_boundary_head(struct queue_limits *t,
 	return true;
 }
 
+static inline unsigned int max_pow_of_two_factor(const unsigned int nr)
+{
+	return 1 << (ffs(nr) - 1);
+}
 
-/* Check stacking of first bottom device */
-static bool blk_stack_atomic_writes_head(struct queue_limits *t,
-				struct queue_limits *b)
+static void blk_stack_atomic_writes_chunk_sectors(struct queue_limits *t)
 {
-	if (b->atomic_write_hw_boundary &&
-	    !blk_stack_atomic_writes_boundary_head(t, b))
-		return false;
+	unsigned int chunk_bytes = t->chunk_sectors << SECTOR_SHIFT;
 
-	if (t->io_min <= SECTOR_SIZE) {
-		/* No chunk sectors, so use bottom device values directly */
-		t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
-		t->atomic_write_hw_unit_min = b->atomic_write_hw_unit_min;
-		t->atomic_write_hw_max = b->atomic_write_hw_max;
-		return true;
-	}
+	if (!t->chunk_sectors)
+		return;
 
 	/*
 	 * Find values for limits which work for chunk size.
 	 * b->atomic_write_hw_unit_{min, max} may not be aligned with chunk
-	 * size (t->io_min), as chunk size is not restricted to a power-of-2.
+	 * size, as the chunk size is not restricted to a power-of-2.
 	 * So we need to find highest power-of-2 which works for the chunk
 	 * size.
-	 * As an example scenario, we could have b->unit_max = 16K and
-	 * t->io_min = 24K. For this case, reduce t->unit_max to a value
-	 * aligned with both limits, i.e. 8K in this example.
+	 * As an example scenario, we could have t->unit_max = 16K and
+	 * t->chunk_sectors = 24KB. For this case, reduce t->unit_max to a
+	 * value aligned with both limits, i.e. 8K in this example.
 	 */
-	t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
-	while (t->io_min % t->atomic_write_hw_unit_max)
-		t->atomic_write_hw_unit_max /= 2;
+	t->atomic_write_hw_unit_max = min(t->atomic_write_hw_unit_max,
+					max_pow_of_two_factor(chunk_bytes));
 
-	t->atomic_write_hw_unit_min = min(b->atomic_write_hw_unit_min,
+	t->atomic_write_hw_unit_min = min(t->atomic_write_hw_unit_min,
 					  t->atomic_write_hw_unit_max);
-	t->atomic_write_hw_max = min(b->atomic_write_hw_max, t->io_min);
+	t->atomic_write_hw_max = min(t->atomic_write_hw_max, chunk_bytes);
+}
 
+/* Check stacking of first bottom device */
+static bool blk_stack_atomic_writes_head(struct queue_limits *t,
+				struct queue_limits *b)
+{
+	if (b->atomic_write_hw_boundary &&
+	    !blk_stack_atomic_writes_boundary_head(t, b))
+		return false;
+
+	t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
+	t->atomic_write_hw_unit_min = b->atomic_write_hw_unit_min;
+	t->atomic_write_hw_max = b->atomic_write_hw_max;
 	return true;
 }
 
@@ -658,6 +664,7 @@ static void blk_stack_atomic_writes_limits(struct queue_limits *t,
 
 	if (!blk_stack_atomic_writes_head(t, b))
 		goto unsupported;
+	blk_stack_atomic_writes_chunk_sectors(t);
 	return;
 
 unsupported:
-- 
2.31.1

