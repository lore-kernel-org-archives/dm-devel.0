Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C45730FC10
	for <dm-devel@lists.linux.dev>; Tue, 28 Oct 2025 15:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761664112; cv=fail; b=IEDccqmheOaj/3/wwHjJ1JVKzmB/Kdk1TT4k1Ie77o0331ypFbgyjXuOLIS3gi625QP+tUcBOo8ZMEI9x9FnpLWFJyGZcoFXZ52yNvaMsXTmlacY9KkBzf+BsGglPzyiJsYkys25fglMqqzjnVUd/LlNa/ssqrue2wojycuyhdE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761664112; c=relaxed/simple;
	bh=ah4+zekRD6/CbRcpVpI+u05BaIdDFDgvpVKkxw9q65g=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=CUdk41UeGQFmPL/UMkR6f0WB7+SjDZDosr5rul0/QY6jO6xq4I4sIh1Il2hwOJiWVa5ckfzQQ8gLv8B1ZkiOobnVOK3GtrouF/XuibUjQYOEqd71K0OJWLxNdapJeZgEXjI1WudxKy4mJOn3ZbKLaeZM9c6o6JpxSOI8Rn+O4r0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rzTdwMLz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wBC0aCbf; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rzTdwMLz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wBC0aCbf"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59SBDfFn022540;
	Tue, 28 Oct 2025 15:08:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=aMwsAWHYCScFqKk5
	MnNXIElM3XKR+FiG39TK9k29xTs=; b=rzTdwMLz76H2BVTm9agO1w2kII5of2gM
	7ageTIVgLNA0WQVj3ee4zIG5Oj8uweVnEhXQylXaHPSlGQuU7dFTyQZZ2X+uLvVo
	nUs8tG42fFyOqQMGAnhng1pwUEKpYQ/S56NEZcEiOUZCK4FtINU2uNNrUxxWhkKk
	e26b/KHBTs8G7yHeKRoAc+CAjYC/AcN5GWtAgVuCEGh8gUklnp8tROrCRtcdWS4N
	744NHyAfNvh59gpsRRaHzPmycwOD26Y2EMVG5IFxFlxfLt44MPz5vESXdQRBXJwP
	531G7G+nqx+RsCq8KcBGj0VzXyZ0OUt0HnqfPyF7KMgtjRIf4eLyig==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a232uuvyd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 15:08:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59SEIbMN034928;
	Tue, 28 Oct 2025 15:08:26 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013028.outbound.protection.outlook.com [40.93.196.28])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a19pfqk2d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 15:08:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fVBRXPD02oCP5+tjx74oGp474+DJ29NlV+Woe6g5yNwpKraRmEVfNJefiMqtPHawBmsBD+fQWPA3+qcGPabQ+Lpv5DrQr3jy9JVB/up92FjpA1pYcdYwvHYC3a68y7CdP5dj4Mo0VAdicV8Eg20rQkbOnpB4/U3KK04cXw7vlhUFHjGYf9s/Hr9bkKYRQP39Dh6omNMWso/h4CJPAKV/fUs8LfBMkSwLS31tRfr0OnCq7kqjq3zhwObok9UbBbZqDfbOxR5nmw20OJLVgSCq/L44GAPElLebyvkkbXOoZdoEPcKFqo8w9h5IZU2UxaXYG1wTbk/AHP1kP9ZIDKcP4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aMwsAWHYCScFqKk5MnNXIElM3XKR+FiG39TK9k29xTs=;
 b=IR82Qtgi2bwmXMEiBivsHsbqpe6li7o0R3u1EIv5cBtKDPsRiOFx4IaJBteutPSehBGk9SlRmhJvazyI4z/SVuBs++EbDp9l0WW41mGME5edepKOA8wp693V+xISsGa9ni4cDdk00wHMlJhoCPdlZwFZQCa2HZxzmEOoO4VkoWTZa1VYACOyBtoS2PY2U8P1Gz+60gNewbn2q/dugmHEdlzSBORe+qc1bLJ3YMc4QKcTJ7pu+nL8DCf3cLfOno0CBJPed4ncCTiCs9BQbiZJGzFFfxZde8wqZ7DK1M4lTPzh30Oz4QS5VCKAK7OLmeqllXlaIh4FSmprM1OElR5BEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aMwsAWHYCScFqKk5MnNXIElM3XKR+FiG39TK9k29xTs=;
 b=wBC0aCbftOoI+t3FiZlZkVCokLrc4lVsfR/SHz2QU6WxHoSis4Yt1xcVLXf4SioN2lu0MVJWC/pONOxK4A/x32tTn3ht/bc3EZDKLlJoIh/bZrVaYRdMH09uADwkKxaNMQ3Fga6/ouEOS4CqgznqVlqEpJ4YZ44zMpP44Yq70fc=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH8PR10MB6551.namprd10.prod.outlook.com (2603:10b6:510:225::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Tue, 28 Oct
 2025 15:08:18 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9253.018; Tue, 28 Oct 2025
 15:08:18 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev, michael.christie@oracle.com,
        martin.petersen@oracle.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH] dm mpath: enable DM_TARGET_ATOMIC_WRITES
Date: Tue, 28 Oct 2025 15:08:05 +0000
Message-ID: <20251028150805.1564068-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0190.namprd05.prod.outlook.com
 (2603:10b6:a03:330::15) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH8PR10MB6551:EE_
X-MS-Office365-Filtering-Correlation-Id: ac57acce-c868-4422-fd81-08de1633d33e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?axc/u10a/Bp1yMGBqCB2B/dCgGeNRIXBfmoIICtaSbMMBS/E88tdTwgbRIVG?=
 =?us-ascii?Q?wZPiZO83xSVRpbtccG5kSHklKpHF4aWSWIwYb14CPNuvdjdDODPIM1z03OLP?=
 =?us-ascii?Q?jOEZTBIVMmtJbyg91qUHot1604NynzKf3pdgXWxbgCGaizwyAKsTSpWZ6D6p?=
 =?us-ascii?Q?41DUS3CsS235VdA5h8c2FOW2zLd6xIdYk9nvDbBQE14eYjxqYjSIQBKc1641?=
 =?us-ascii?Q?NiDP2CYI7nl8hpJJNHno9ld91Y5gv9nhYe2sfFW7BdEn0xCbZT7Nah2OGv0A?=
 =?us-ascii?Q?zjwMG0jIRPNfF17mLB9L/ZQDvqBBFLFG0gw+A/aDc+kxI39DK0Y3S6wkdC2s?=
 =?us-ascii?Q?ciwth9eq1tr9MlCeLflft2Xq23Amy5ko4bOtK0PAu5OUDghJkRObLnPyuqce?=
 =?us-ascii?Q?rIl0BRpPYEEaXXPKIpoTtvdFfL+urvtFrwEkd3WdLlfANl/RkITtVPtoXYop?=
 =?us-ascii?Q?K5vmBHFC+3F0ct3gpVzbuWJeZzak3F9BuCPkUy7NBn0/KGjbU0wGBLTettP8?=
 =?us-ascii?Q?aiFS1Fda3uWen7YJIf4OuqEmTavVWRit3obQbRYKuRNvmlh8oasUC7tXmslN?=
 =?us-ascii?Q?KrbUcSeZTqpAEzM10Kci6iBdIu2q/BT6x6ao2PWR7EtjM48cJxCTvmSMpcaT?=
 =?us-ascii?Q?GwWxzNGl4I3SWrcnlYGZJVBZi78TQwk84i282Gz4HRe9d/Wba9idxU1VbWF/?=
 =?us-ascii?Q?/8FWCQBeFaN8KSUi1LLtOiL7U0qX6ePonnr1To+Ck+5rMjAI9lDI0l/D+j0J?=
 =?us-ascii?Q?YvJu/NPTsxql4yP2B7/JFxVlOJk18kEwDH7QjI3Vlj5w8HEtDFSGafE8UF5A?=
 =?us-ascii?Q?C/W0LWKygAy7faNkKwixJUst1tqFcmiuz3pYlfQ2AvxS/u3mT+HNOHVbDYpU?=
 =?us-ascii?Q?rJ3f0p6q+44/moDtvHPaBd2RfHjFE0WY13QeKRX/EOsbPjdS/1+sWEUvERg/?=
 =?us-ascii?Q?kvTGUwFAeEYuY4nHzWyKIiOTQJCRuJvRc0qkc0Y4hxLX4RyNPqri3QANFLCJ?=
 =?us-ascii?Q?AHUAYsBntlYQ2qvPH1+jgrOXoeqUeLVkeI3RH939YEbAXBfuCkATEOqpJrPR?=
 =?us-ascii?Q?pDUq6wR9okcFSasj/0lr479gSZdeMATWz79HPaMGoIl+Q1ArZrQzrK/CK64E?=
 =?us-ascii?Q?Gw9oerdrAtCMkaRQwNGkZpXe+yfKJ5FKBIdxwmuVL6T/X7sMLV1ppZlAxDo3?=
 =?us-ascii?Q?s/QQ1UCRl1q2d/WItRAi9yOibMJD7jKH7OYQzzvIdnqotp4VVOWXBdhbIPuE?=
 =?us-ascii?Q?FOOrA02wl2oNkB8qgi924/MObKiC2otCAAwCS8P1iGbpkmlfZ+P38/zlK0J9?=
 =?us-ascii?Q?n9WlKtH9n7yyRVZUopQugEwD6OrWdL264vdVneiEWNKIEs1mU/YYsCs9WHS8?=
 =?us-ascii?Q?0LgdMSkzh3nUI9TTsU/PKko1swqqM90/mq+1J5csyzzyUIFMbnK/HrqZ2gLE?=
 =?us-ascii?Q?PdfaFc0oY2tCb+Zx4SYwthbipR72zTsg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zZ9dIKqfqcnxFpPwPkwhnPXdpGW85dUlKJldOWUID9phRUyiecdksU+B6zwV?=
 =?us-ascii?Q?UjtcAO3VBc1r8ryjgKhf/l1xPYgwaAvS17TQDuOuNgJYOWKyqLqrd/zwVX/J?=
 =?us-ascii?Q?gcC+kmgzzRvlniBuL/9Ev/BSFoIQHIkMh5rZd2FEkRwDHSvQ5TCs1geLFTgy?=
 =?us-ascii?Q?fCIJ+sFMXFfaY+PPvVV7rvmclOJVlFN9usYYHQt7FxgC3oJQXmjvdhJV7Nbg?=
 =?us-ascii?Q?95sYTMWsVyJjvTHGZX35bYBpZocrh4SjWaIaegvgEZaEogp0DmNuw1V25xP4?=
 =?us-ascii?Q?CVRVlMs+9OQ1T/y3UgyMNie6OP3JF1lssiSGPgprPazW605mZjR6lmEVx+Y7?=
 =?us-ascii?Q?RQyFIjbYQPsB2No0qoFqMH0d19MqS+9GZ+oEdnUeCFCEPEk8g8TNSWKxaT63?=
 =?us-ascii?Q?UP3FCbUa3G7Xw/xA7xMCDqljujyaFEmwSt30a8WeUDH4d5+MsjSqJw7qt5tg?=
 =?us-ascii?Q?AsljHNGJ6wHHHH3ggTrGDnkYkvMGZ7nbqOLVVKRIDbxkBsdWjidV5BEzDiS6?=
 =?us-ascii?Q?SmB9ofAp7N8R9EPz79hx349sgTRsSN/xLLO90++12pYj4+4VqX/7mnLdgma6?=
 =?us-ascii?Q?MkVkvg6tyiUy60lVrYEKcU9U7r7zT1VDa0hd05R1XQWG0t0Z2SE+cwfRJdbk?=
 =?us-ascii?Q?lArXdyS39fvYvM+gdsQHvunJ1H3n/fuAD+d32fSK8jNLjpNlqGoMnwTC5ABl?=
 =?us-ascii?Q?HmJD9dVPaof0/Y7JrMEevn/GFMj3f5g/xdCtiZGt7Xhsewl8Xs8ZxnYttj8r?=
 =?us-ascii?Q?im5+efQDDWpL7pOKhIYdsNACTXl5oUZkahAeLWTTN49NovtKNHHmwbmsDtoY?=
 =?us-ascii?Q?GszajibayysnFmoi3CxG9cxueerM3ja9M2ByWbFJlHq8SwIrsVS/b0Q9/IwL?=
 =?us-ascii?Q?0AiyHcmbFtZgdqtG/V3ufiV7bAn6//D2j03Sab3HvCR4Et/w+ZVAArvo9WaM?=
 =?us-ascii?Q?IzUi4amKMF2wlw4sXxm27WWEfKUrFDkM28DSAcLn00ZM1eo5RQhjSgNJGpmT?=
 =?us-ascii?Q?WMUzpUNPy699q4piz6U+Fld8zZt23UFE3v01v8pWfMPu+dzWDnvUMVQ5GJWB?=
 =?us-ascii?Q?UU6wWsjsqM3Oqy+D8IXx3Pf9JF4oWHw85jkmnvSj4IoXYmQ3i/DoAAtzSnGt?=
 =?us-ascii?Q?qvzFYZyObh6Mjlt5eM6tNZPpp108DEDNUJVPLURnSr46/KMn3x3bk37K2cT9?=
 =?us-ascii?Q?m7fAeN7ud1Zpsh/jZqyXiTYBbPHENiVLdCC3fzVgCNH//u9P+2K3Pk4Wh0uc?=
 =?us-ascii?Q?5GOqAeiNwCOLugvsZD0Qj8Wkx435qqHcEuVr3Mq8UQnTp1aTo7fq2ZcDTUPL?=
 =?us-ascii?Q?tr2759VpXDGg1g4oKvd+xm3XS0Cpf0EFMBpG/W1+oL7BaMK/TvY/VCn+ozE0?=
 =?us-ascii?Q?W7e+y9MXjHGV7dheMAaLyADfHjdKKndH0a3PQ0mybRXEOVtSctiWdvzVWme7?=
 =?us-ascii?Q?yjC1Et/P4xk6FYL9qWTbO3rIBOb7d6JG5JBLxtElJRUABcYijs9PirQP0qkq?=
 =?us-ascii?Q?jtthFDrTsKp4bTxeuu6QzDVjP20eLXqQEi/QbP0MstrWWaT2kfVLzURAxOow?=
 =?us-ascii?Q?h4xfiOgYod70BWXyfwGSiZTis1j2UMdMWAlpu54jh3HpU2KcDHlA3Rl5N3RW?=
 =?us-ascii?Q?2g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zo1Y1fiyBYDYEvvPk8LAEgmfllUp3OgkG66HUvVgk7mQRTuTvCNVMNbskWRujlDbQhW9XLvKmUQ2uRcO4LUY6zFdn/3L0KFbuUVHCqBsZYe1ndGnkzIUDYjIggmThRNSxzWzonqwDwUZ9IeYP9xfXP4MO1aJyVLvH6T8Y5bamTGGBI0B63n6KWaNFQ/7DMRyK/GFcubr1sWXfFbvcY4Msz0TIcH21GwpJb0jqvhfzf8xGdHeim7wDntTVHxmc5ldO7TeVUvEhlQoCMbevJDVLwRwX2Lm7Z92k3e3AwIyAjcY7Bbvx15UH6sZ7f6Cj/EJHhO7h4Un3Nz/BSY3LOSC3TidBkSdBSvRrKIYzkFdgpCrLkRqG9PuP3SQhUtZKMTJfNcL9rsHsfcBenkoAYPOU0qsIgGKwholBgfx2TB2QyVRntYSOiAc9OCeLcc5TW+6VkEGHUFymV5BhfGCMdJm9mqPapEpxU9ZG+fFE25S44zApNQcZchuxtXATkQHy0MQQBdzAXGPBz3TBJGaThss/BWKYNs8/KRa4YfCOOUDV5eIicT70m2apkFp/CrYLab4hCR7ZggpXgkhlREAFDYqoTy7MfrQ11xiiqxsIo9T3ss=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac57acce-c868-4422-fd81-08de1633d33e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 15:08:17.9363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Arb9QWuwhaEDcnZoJYyTg30PTM/qwDnctY1W+6v2kUZdmn61z+DM6cg9OzaaaEF+2vVYxDVeR52OpELmfxr+Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6551
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_05,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510280127
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1MiBTYWx0ZWRfX8MAjRbcqaghf
 mStH3yUqBS6AkeeMLakw5HaP/K/RLwrl4aEJIb8HpDaZpucllUkrDPyByxRn764+Wpd/z1/9r2e
 Fe35K88U+IH15Ao1xBXt5LcJeQcgxR0hSqxgIdVSiqP8KhWms2kZ7v981ekXwE5uENBc9+CnOFk
 C03tKNunZc1AgpSPyIhu7NMqn+c+0GiE7NN7iQBoMMPrGDbtpAIOnoNMP2Q5kxnPWE3ZfbymIDf
 iiNZFj1CD8EeLMM1K+SxSJsimXRQJfenykjCVLkDX3uT09TB8EeITNq/6jyyzxnQuhRkZr68lyg
 L6cirRiI6oOvTWqjXtUQ88qLC0qcFPckw1ZBOdZyQC1HJZV9yfS8Nl7UzIaDUziiEdIRifLzfH3
 vDdjvr1orbTSyLmKpiuu0xCAmXVDGNilihKytk9Tgg8cR3uatog=
X-Proofpoint-GUID: bCnFjX2piwEnTrM0nfUqI2DbVvx63XVs
X-Proofpoint-ORIG-GUID: bCnFjX2piwEnTrM0nfUqI2DbVvx63XVs
X-Authority-Analysis: v=2.4 cv=abVsXBot c=1 sm=1 tr=0 ts=6900dc6c b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=Sn8nGx-Gd90ocIG677EA:9 cc=ntf awl=host:12124

Both the bio- and rq-based paths have no problem supporting REQ_ATOMIC,
so enable DM_TARGET_ATOMIC_WRITES.

Signed-off-by: John Garry <john.g.garry@oracle.com>

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index aaf4a0a4b0ebb..5dd90b2cdb9bb 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -2307,7 +2307,7 @@ static struct target_type multipath_target = {
 	.name = "multipath",
 	.version = {1, 15, 0},
 	.features = DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE |
-		    DM_TARGET_PASSES_INTEGRITY,
+		    DM_TARGET_PASSES_INTEGRITY | DM_TARGET_ATOMIC_WRITES,
 	.module = THIS_MODULE,
 	.ctr = multipath_ctr,
 	.dtr = multipath_dtr,
-- 
2.43.5

