Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168C91D88AC
	for <dm-devel@lists.linux.dev>; Mon,  6 Jan 2025 12:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736167313; cv=fail; b=a1Pbh/A4XC9ZqJcoShg2IWVUp8ZIacv3AP6Hd3OswMIgZj3jMOy6X696vAOSLbVTR3U+d3zDrijSkweCCmc/716AozU72St3SX/6a9djkgzhdwp9tcSTNlksJlD+pDiWWpgcTT1ZjBTkh8Hka1h1+EWTbmH0OL/wGOP/KECR3BM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736167313; c=relaxed/simple;
	bh=3tIVXBvYHF2KN6KrooOTm+8Jl+o1P+9DTRtr4f3ltS0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sYWOp/riklBx2U4C1ee37VeWkNCTdkNNnRS5InqAiib9gWk0UdIX3bU3tEvEKCMLhRDizywMx6sTaj+eKeQmjugWmnOlYsb8fGMqU3OpttP29CTrZ84i6Lnmvi72XD2SH+XqKAclrzqH3HhcSwfuXrSiMFu7OgawoikfvHXnIhE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ITCcvBbs; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Vas0zJEl; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ITCcvBbs";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Vas0zJEl"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5068u4cH011449;
	Mon, 6 Jan 2025 12:41:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=p+ysVsiT4AHWozSRa28JuSgRYXzYpExZevoIbCMiOZ0=; b=
	ITCcvBbskkQxLzW+M5td0E1A/yJKpgb4ZiYstYu2pAWG4PnFV+MUPIxuT8eviaB9
	h7xCJ2s6SOn0WOPSUQ07xaQicsGhcWbB7WWvaIRoEOjDvjYljJ6uwZ2SgPC8Nr01
	ZS8ypTXF6n7FUR2gZsTMDJN/vF0aMh4qWzJhmj+DSvFiQOjIEWC5LMkf5YvRUeR0
	RO/TuFaPwF0s9liHeulJLBVpbhkzXJTtnzyGxmU1DGQfhOZ884mCOSCU3M5Md5/H
	gVvjRWkuY9nVlfunyv9NbWsx3wZV7h0V174BOvHzywbiV3mbH8tb9JH+rC84t/Kw
	+mll/cr8wnqV0JYh9AXJIg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xuk02r3y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jan 2025 12:41:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 506CDvtg025483;
	Mon, 6 Jan 2025 12:41:48 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xue7fqsm-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jan 2025 12:41:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v4q9fqgj2OIa5EnvrO3hJKwsBM2WNfblRSHmfQRRVOzVNbeJEhD0ej5s+LXs48H3HZTuhu1O/+0In9YE507STCAqSM0MndBFTNjDJBqUYD6yZhhf6WRCNc7LZlohCVjrjHJyzq6UPyjwCrqZeF2OjQu66+rkI7HYYAxZcNyRtsaLEL8MQeyIEi3SR9zmF8TFKVBMoz3cFVoqK1y+Os3LqKy5Lt8WzZ2iOTGIdYOsXFb5qY1KDoxJIHDm58D3lcTj5QydgxzPwOeZcNfw0sbijy45ROU1qPxirziRx5fCt17OboCdpQPJ6C4DxjoRn1V6yAmt9nkJW/Ghl0tsMPvACw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p+ysVsiT4AHWozSRa28JuSgRYXzYpExZevoIbCMiOZ0=;
 b=ae09gy2kbBsXdfBSDd/X0hi9GFuTO9Y3MDXMNesoObZvdiht/Wz3qtvcoIByKY80qGk8em0mZjRQhPWLfLUmjbCOIdNcugMwUfE1mRGz4M1KB4cjo+OBTTZuXawq5pWKmRoTnDGrvMINymO10muG3Kvwm7IodZrGAIOtWHJi5KRJzbzqsJjwiXsJrH0YhwILcM+ygbl+f01Tu1/JHkT6LIGw8nHjJmXbMNxjKFrzESgMvxLHicyaSOkR2Ojc8mpch6Bc9a6yKMMPtRuMlxr+gfXqstLdxaDW86SwDaoSR3Tl92khgyOLGtCvnB82usrNclSbN0ZIs3WiUoWFb8ZuAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+ysVsiT4AHWozSRa28JuSgRYXzYpExZevoIbCMiOZ0=;
 b=Vas0zJElFpeO9ESIXYCLMjZ244u2B/xIDb90lK+Qmjqx11m1zUNV2HBfK7haGM1S1irdUU9tfR1QUflHNCr7v8ja8ELJiyeIIlQVObCsjdLaWXms2tYW4vfib3PQeVQo6kkstWE+1pK7DJ+gMlfgudcNYY/eMjC0dolEtUskeWU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA1PR10MB7662.namprd10.prod.outlook.com (2603:10b6:806:386::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 12:41:40 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8314.012; Mon, 6 Jan 2025
 12:41:40 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, hch@lst.de
Cc: mpatocka@redhat.com, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC 4/5] dm: Ensure cloned bio is same length for atomic write
Date: Mon,  6 Jan 2025 12:41:18 +0000
Message-Id: <20250106124119.1318428-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250106124119.1318428-1-john.g.garry@oracle.com>
References: <20250106124119.1318428-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9P223CA0012.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA1PR10MB7662:EE_
X-MS-Office365-Filtering-Correlation-Id: 12ac51ae-b121-4a7b-66de-08dd2e4f773f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?L1JeVL96rC2Ej2SixaoxJo7IWHrpfF2HzCvd489UIgnUcuAHImdebh4ar07V?=
 =?us-ascii?Q?Cm/8X3GCCvyY2toqamVwR4LsM3ICqyQ7E+f9gpKc+Eu9tCBXVkpWYM0mQ4mx?=
 =?us-ascii?Q?y2zLx4Qb5GX8HXolkZtug/JUQPOYD4lQzYocpEjrXp6ajmseiP/YO1BSykzq?=
 =?us-ascii?Q?FJ8cG7JJolSFJAQHH8E/OrHjcREwnLQHinBTrQS7u00vAc0Ri1WIAn/BZzN0?=
 =?us-ascii?Q?Itaz5ECBQysMT1raOig3eUwL/Y7jcADyWTdrI3bc1sy6Us5NhZi6eNx+j2hv?=
 =?us-ascii?Q?laePj6QfsEz3BRNL53SUEImwddLgBhCB0RKz/OU2czf6NW8YWiIy05kZEX+U?=
 =?us-ascii?Q?d/VQ2YHj+7je++zSNZ9Hx++uMt6pYtYI639WcULis0e44Z4Zmz+a95d8HKQb?=
 =?us-ascii?Q?QRdOY9yysWiK+pXZqzvtzOTxfkXhIJXcisLUrGRHXmAyUV4CKCRr/l+szSzW?=
 =?us-ascii?Q?qJMcC0lrzfnhYm0Jbg7oIEcAKFbjHvJCwFlt03s3L2gXnmJ6a1xZaI2GYhOe?=
 =?us-ascii?Q?b9jPtooJKkDmJ5q7M5Dxy8aC9+MtJJgOPRBWp9oRp92ITJtWs/CaY7g6oquS?=
 =?us-ascii?Q?J9SeFiOMf/Q547eBeeW2jeq9AOLbFRrSp+myGSLXDDWqScU2EGFZRd0EKQLS?=
 =?us-ascii?Q?dMIdn0GZdu23dipPCEUqA1YHYtHQf+O+GiBFNzyIx7X8cAqJTxm6nJs+Hot5?=
 =?us-ascii?Q?sgD6tJbTN++p4l0GJ1S7FP2xVxGqzy22D9Hj8btY31yW1UVW6bG8FaF3lVoR?=
 =?us-ascii?Q?x/tZpZ5YO0meSGa85cBsz+rZkM7l5324E58/UQIkWpCBD1O2G6vR4Ly1M5Lh?=
 =?us-ascii?Q?GGYkB7Gi0yWSOb2cRyFt8QHkd+Tmsz3wa118kf3pRbtNdJxm0T+vJ9wa27PH?=
 =?us-ascii?Q?VRqPT8Fyv432xkJsRaDUC6gEv8zknDw+EieuWWx/yz4/rga10u8/ToNXjtTq?=
 =?us-ascii?Q?5Sh/zyJ+Pch2IAORrKonZoH2lrsxQkmq6Zw/7Uz7xSpjMWQU0OGdJdEnFSJZ?=
 =?us-ascii?Q?kPC25V9zQDb7E4HecTH6X2xYk+1QMe8FhwMGFz4cyE3cojVBLZ1nmmI1aedU?=
 =?us-ascii?Q?U1DO/fkleUuvP5pWZQYwiAvjuaMck150lVCOftFSFX5sPfkAOKz4Z/5vhM1a?=
 =?us-ascii?Q?pxltMLcfpQdYR+epSggdj5jLgU0cKvKMy4nXIne2Eiw45sxAThbpUQhk1RmI?=
 =?us-ascii?Q?bsP+hte/M0gZ8n/4e2f9gvPMy7oFG1MUGXmaKlmp5lsxfYVmVxdCPaam//7b?=
 =?us-ascii?Q?T0KUoAHuha20rAeRVpeBE8PpGMyAWFWDLG+7NZ1t7y9NMrtsPbKXjElmqMxC?=
 =?us-ascii?Q?VXLVczWyI/6yfhA1yT/kTjrsmpPW8yKgirRGfcKaOLX7uGjExPOGx9F/3CF5?=
 =?us-ascii?Q?tKTgu7wX5CcvKGpBT5FdZPP+tg+Q?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TCS93JIxCwVFpjLtB6TXIbK7DZMLY+1T3Cofj30sGh2rtLqvp3TnbN4M3J5n?=
 =?us-ascii?Q?KwqeDGkHda6vmi/cUV4RAqCovhVMRyQ5kEks4rdPOZB0VGhdMkRp8BrivWmr?=
 =?us-ascii?Q?Hggf0qxbKUUxAQsCHTq67MbePjeeKF8I9Lo/OJJQ4d8LqtywLkO1SrnxuRTG?=
 =?us-ascii?Q?YnTV8GimC/3CHcmOGILVJyY1axxCsKp40Hh2AxhG3dArIKVX8Gkg314gNc1e?=
 =?us-ascii?Q?nWbDQOcnu57aVzBddZuavvN+UCft13CXhZdzCa6pPm/Oid4illyTi9DiYYWu?=
 =?us-ascii?Q?PHowDMikd67vpuvtFP8TB0oR/50qB6pIdrETu1AUl4OmRkwtJAh4Xx88J4ii?=
 =?us-ascii?Q?LuM1Y/35H1YeADTAw7oZGsaR12mr5Ms2I8ABtKmTu4lvzwPgF4kHD07XvmfX?=
 =?us-ascii?Q?y4GSK3gzE1YLhp+8rfip4AT2fHbTUZ+p5v2bn014VC2VGDQVxQrcuVMFVSPY?=
 =?us-ascii?Q?j2cgwEi8y/iwmReeNWyaiCF0q4o8yn4mbysWnCzmCImTNfsId5kigz8IKZEi?=
 =?us-ascii?Q?G5DNbm8elJTSxjEpAN1l0T8wOfHX3pJ9zIbWim7k5RwNk+g0WSkeLFbAU4kK?=
 =?us-ascii?Q?k3gO7BJBgk9p64fXT6JHtWrIi1IdlHiUbrlYjn+DW/73OpgSPGH6NF2UphTF?=
 =?us-ascii?Q?iPXJYukt992qk3rbG65RNe9Dyyg5wwQ9at1le/yFQuqWdCaeA9jlOkOH0Qud?=
 =?us-ascii?Q?51Ri9X+GmLtVryppQ+NPeeVM9RNXnb0VWU4XYgUQvO0mhjsCQ4MNG4bFZqyo?=
 =?us-ascii?Q?RmBz4LPeBZ9KzEszU2NovT9olVKoDiJAH45uMNjNok9pyT4MTRZbCD9P74DL?=
 =?us-ascii?Q?vq0KE0aUXb+X4R1VjKV56ZbOKUcoCFcitS/dAPIXyPxq9c31/vNoIEp2iacc?=
 =?us-ascii?Q?OlsMN2+pqhJ0rNuTVwQ9G/6GrOEV25P9NUmwMOYmDQ97POfCgleWvsaDr7OR?=
 =?us-ascii?Q?ATMnmZa3VEbcGJqKoz0qi2YJBUscDYT1VZoaTj3tOB/f63/E18DmYnwbvI5n?=
 =?us-ascii?Q?v34xsMTUR/X+ifMFBO33+DKHCOq6+ZrHoZjC+jTumfqmGw1kxcvU72bFfmUM?=
 =?us-ascii?Q?F562rTkp3YODovm1Pt8dtHqNdRrRlkUXr2ZOQ6dCmTqQdAUueXyap1EQ+ADU?=
 =?us-ascii?Q?EtgdniS5Ts6AYJ/gfE20C7R40SUCf7nd4aIY+Wkc38dlOhuTs0Iy9SBx9a2S?=
 =?us-ascii?Q?jwWOgVafyhxTNMUbb3kcez9VblDW4klu6OKxLELnvgiH2ND0aaJ9EV4hh5i3?=
 =?us-ascii?Q?Q+8611SleJuxSBnw2WiDmXa+6vSQGMw90VcRLZyxB1wDBQgydxZwsepAilAH?=
 =?us-ascii?Q?PxATRXiD7iEw7h8GRgmoJIvrIULNo8/Y1tBZUuHKm27MURye5sWl5WwjJrSR?=
 =?us-ascii?Q?NPxhvcR6K/coeuOl5sK1UAYpQroIOZuABv1oPz80kH3nTgLMZXGRKWbltF2q?=
 =?us-ascii?Q?1OlTlVNMeF27Qyn5ILs+ala8wV0p225HZBON/QOmBQr3PAotmQ9ebBf4yIsp?=
 =?us-ascii?Q?HHZVa5NZrP9Hjy5nYbSAXvpg2a0sfl27+Zug6mZX4PV0Sra0UD1Dmggsgt9B?=
 =?us-ascii?Q?Uh4T5zPYz/ftOPXXjkMvtCJwbI4IJnUCuLPXm42rLUE3IFSoiLeNWtSWG2E2?=
 =?us-ascii?Q?3A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sdxooTuO1IqmZKv1bTh6HeqbuEbhY2kgHIbCzkrW0ieqpkI0bAXjzDlZOQqkjtkqLlR2r6J9qtlHzaVrtlUU6kN7kqFOZJTXP5MeC5DoT8J8zje8ps8BWYz+C0HaXh8c5rgLn2va12XhMdl6cTJVNzqJ8cHgeN8UA1gyzvYaHZ9AeIMQbskrny1w/FFK5KCVF/kC8Ms8YmqRjY5r2Lt90yLx4BsdGIlOz1Nco00cp3dZn6fQbhuPsAod0gv8Y1C6Hwm9/WZ7GJC1IZiIWV32sqMQpX9ZWFS/HFI/sKbtX9evvigXY2NKoy1iKtCPiMNZQQ8gmKoJtuePzGf5zTecVNB9DPX9L9qPseAwibYarrVTMNESJ6SWYeofAh+CEPuH5493hdMIL0rEvxN8Op0Z5fFLvitT4+QEXMLD69aQVTjVB5J9WOAnI+6W9eXsqZ/RLOfXJgxtkNTLRSVBxGu7XhsPQj7Q340Vo2LkijpQEP2L/RmlezaTqZAMR0kQAlPr0i8mHm9QP0zOaFMX9BG7BuvIFQFrO4EcA7HQCIIh4phd4w/sUgvktDTWMiN+X7sUsXYhcYVatN3hbDToLubq/3xHON2xCuR+CwyZHNmaamk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12ac51ae-b121-4a7b-66de-08dd2e4f773f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 12:41:39.5867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5j2h5GOZNVFu6cspR+3DK032b7mvr7j/mHWDF9NNsyHvZDLKo7+g9SpRRXTW/kR/MDacMsEBclqMbYOuk8zyGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7662
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-06_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501060112
X-Proofpoint-ORIG-GUID: oyQAk59Et2XL2w7yL6s1VR3p3uvgZ-L5
X-Proofpoint-GUID: oyQAk59Et2XL2w7yL6s1VR3p3uvgZ-L5

For an atomic writes, a cloned bio must be same length as the original bio,
i.e. no splitting.

Error in case it is not.

Per-dm device queue limits should be setup to ensure that this does not
happen, but error this case as an insurance policy.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/dm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 12ecf07a3841..e26c73fb365a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1746,6 +1746,9 @@ static blk_status_t __split_and_process_bio(struct clone_info *ci)
 	ci->submit_as_polled = !!(ci->bio->bi_opf & REQ_POLLED);
 
 	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
+	if (ci->bio->bi_opf & REQ_ATOMIC && len != ci->sector_count)
+		return BLK_STS_IOERR;
+
 	setup_split_accounting(ci, len);
 
 	if (unlikely(ci->bio->bi_opf & REQ_NOWAIT)) {
-- 
2.31.1

