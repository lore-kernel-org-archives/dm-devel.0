Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA891D88AC
	for <dm-devel@lists.linux.dev>; Mon,  6 Jan 2025 12:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736167308; cv=fail; b=DOeTCu+9963DPVUd6qGI/42xD2IUqDrBy7Yv3/DBoD/2/zko2BUmz/TdjX4gWXNIW4b9mEgMY1zASjU7PKz/HlmEyzANdWdWIRDHXemh0Ym/+Mhj05hUwojFzF2f4jE44iwkr5yj4eq0eywb0GRb+daQDikYo+9HH2REIBwYQoc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736167308; c=relaxed/simple;
	bh=JkEezKrtXRgiZ3N1F9MyVkVX66gmNICfV+MHVV0QI2M=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=SMQBAqpt77Jp3iFrZ2RXSwqoD+pj/SL0P3ct7S00allk8wzGbgvgp+SbhRiJYehIqUg3tAkS94Alp+t019nBVogiGBfVGz8QEHzVbRXSC5N1L32uE3vVbmH03q6hb7KdzmtP235+LZ+/paI1HU+5BNqUjLne7EDRA8Jan5rWFvU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cDVosrWC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=R/XNTqnB; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cDVosrWC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="R/XNTqnB"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5068tsf9004065;
	Mon, 6 Jan 2025 12:41:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=IicFE/9TF8uMmdqB
	qJ9NwoFc7QyYnk89zVgAEJxSif8=; b=cDVosrWCGEL2f86/sRkRcdKVpU0SVRco
	SbElvx2+RDh+H1iHp7CX08w6+MtfKVUOWpDWnHCeDsdyNYm2LofGfDZ0W9+O8h9L
	rflLY6tK+3racSc7TDNSe8szSyJ4mwxaU82el7jtdR/A8xSMQmTxcwnXwvZ8Paei
	och64VNimfLIlwZ23oVJy3yDePPs210H3kS5GtGNgdXQk5KCTJPzT66EImSfJ3Tb
	eoxDZI/SmCAaad88kApidFR7ezC9sijzWnqQC8CB01u41mkBhBDJIADH0lF+v+Ob
	jGqC2Ag42SUmCOQhiEiIkl2SIFQUoQVrepoYJElGcMaBKchKzmkE8A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xuwb2gaf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jan 2025 12:41:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 506C7JbP022649;
	Mon, 6 Jan 2025 12:41:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xue77s42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jan 2025 12:41:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ACs1zPBd30gpEdHUtVKLQg19IrEtCLY3HIqnFIhDXPI8pPBbZ899DVH6Gh5sWUNowIEpABlw0oucbFtSxXrgZrwzDrtXWFAyxW0TJL1SzH5FoM9C1RkkfD/oNKtnPes42G6QrquUNei5ioN70PsiG0U2LddrWQVAB0V7eipaQpR5OTFne63lEs87zzFTX9Qi9k3tVwRygn86BOCkFfEx+eJx+bK9K6WUcG0RXWE+Vvf7zbWGvvzXSjcwkyXjgoRw5822wz4jfz4spyLm2Xkcq1Fl2ClDk1vz1ltYZbORvzBQ1giU+f6aSz2fRbfFb6Xhd0Jy1hcWHXLpCnkLJ9FQwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IicFE/9TF8uMmdqBqJ9NwoFc7QyYnk89zVgAEJxSif8=;
 b=LPxfIGXAX6sTgFcOIcGpsN/ZphuQ0Q1GKDhHubQM8RB+vj2W/twDlp6bHDqQcKNP6/p3jDRLsGbzU6Y/3SAMAbFUfvafPINZfPJ2UF+etX+vnAcr3+64e9k4rUY0McBg2Ib6wz117TJN/iWNXI8Wr8klaZt3QadMJD6gDkf1XV+U6XzCWIPIpt1j8OsoI3cUQxH94WJ1uFKas4ikipptmscqi249qP8PFUplMKN3ZuKkRLgnbvRuMHWwFbUfyNP/F6uJLC8aK6BgB8l9cfyPHRBoGsSBuV0ku/tulLh6JBzztI6xFqQ5SJ3IKhPJD3jxjpjVqaIG9Nfu4EdHYhg3zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IicFE/9TF8uMmdqBqJ9NwoFc7QyYnk89zVgAEJxSif8=;
 b=R/XNTqnBCJtKdOZZrsaXcghANdP3lMeOBeT7D3YO06ED5Y6RnENJdgMBWf2gPI2w40k5CMSeo8/OzbBJDzrBKUCLSQ0ZoUThbimJsARfy0pUNmbUgf5+1iaQuD2rSXg+DshULInn+6DzSu+o3H1szM2p9+7JsBmylVOgn0NVmbo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA1PR10MB7662.namprd10.prod.outlook.com (2603:10b6:806:386::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 12:41:34 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8314.012; Mon, 6 Jan 2025
 12:41:34 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, hch@lst.de
Cc: mpatocka@redhat.com, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC 0/5] device mapper atomic write support
Date: Mon,  6 Jan 2025 12:41:14 +0000
Message-Id: <20250106124119.1318428-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0533.namprd03.prod.outlook.com
 (2603:10b6:408:131::28) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA1PR10MB7662:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f9617e2-6aa9-4885-84f6-08dd2e4f742a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Iv9QMpWBgpHGhNvaQXtsmGl1TKkqwXA0FymCV5uZzy/LXOlrdxYcYx8qiKg1?=
 =?us-ascii?Q?CmAd4FJf0gPMyeT+2ae4ZjlggCeXHrZSTK8jI9oiNyQvhSHZ4BKetg1bKWbU?=
 =?us-ascii?Q?tzBlRUANglbX7JVVB6AuYNiK/zLfk/GBboQxY0gLFMM9UY051sHwghrvXoaZ?=
 =?us-ascii?Q?eIOD90h50bbUbCsrjLuYxguZousiMHXepmj7My30ciY3risuRJjHYNA+Zhke?=
 =?us-ascii?Q?xxSyxI+7vP7RqIhGWPs2CJcqz+F2l9m3gFOTHTEs0c1e1dZCEMooejuJ6vX3?=
 =?us-ascii?Q?eMbu6rx7R63WpWqMW47hqsk0U/kr7X3PXKeEzYXBWuElsLIulmsrWqaO0fwY?=
 =?us-ascii?Q?K+sNtI83XV7dBQ5+elvIk+f2GN8DMSacgjZenfK4yP4jwLGIRT7eF6Vg+CQS?=
 =?us-ascii?Q?02ibBBNRfhpdA0Gp0AFyARhGerzH8DwloMmA1cUGj7o7KQt8scPTKwu/di1j?=
 =?us-ascii?Q?ByJOUldBn1IccI36+6tzsi6vaFIq/9DK3TZ6v8sw16hiNvujyIxzcM3ZovwW?=
 =?us-ascii?Q?0UbB5riFQkB+9jT0ksof+E6oMspvVi/0a7ek47L4kwRJ9yRtEDrM3RAuamKw?=
 =?us-ascii?Q?LaZIQLAcmh/3KT6k6D0X9eOnVehQUI+UFn/5hZ9g3cjb4yNiD5MH7vVWqX3b?=
 =?us-ascii?Q?fBmqpCvCjaK4yNoUxTV93NJgUz5gKy3OZCIAQm5ZJ8KSPnQ5mqnDx2u/8fLW?=
 =?us-ascii?Q?S81FhkocPwq3WpB1uusXVmYbEI1whnvR5nCN2e0UZ7+KrnbliYwGMwbL6N3j?=
 =?us-ascii?Q?oll8K9F8NTUMXZyMe2HHelZH/f4TnHihGUN9wAsNTxjHgfzHCciTfQx+1x1J?=
 =?us-ascii?Q?hkjwdb6WOmG/3WCFTU10BOvPAbVIhVwYP+5HaSxLaj6RTEyGfZ1zyPJye8vX?=
 =?us-ascii?Q?F4WvyDykGHJ67pvl6Z23S/CC6+m+Jk1YygbujrfOuGSXhSXJESvcCA/LXHt4?=
 =?us-ascii?Q?9LdEkS3kNWnGuEPtJOdZSvFvmRAfruUqT+DEmRwK8/dV4Q9pxJQGXjyg0hJ2?=
 =?us-ascii?Q?gw5EsXSxs/a5fMbfGGz5/1Huk0LYjC6+ea1kvKeU25SA/VtJjIkkuP88Y4qL?=
 =?us-ascii?Q?U38yvIqWmRFkVx685+LJ6+9XrmL+A+mNNo2YTfiIRx3IyzZLWTlc2YT2qOVI?=
 =?us-ascii?Q?DplqnSmdQkCr+Gmz5wN2Txux6wSdf9O+8AGZudn+l94W0jmkePm7QZxyKyYR?=
 =?us-ascii?Q?vEXkUnc2j+6UMI9Wlb5Vs4lvorw/RjGAaezUappFGqjMyOcX/VLHa0I+Vphm?=
 =?us-ascii?Q?x1uuQlZWxKel2o3I3LgbxmeawmsAIfd28ckBYQGO0VDMc5nq8tE62xtMVCda?=
 =?us-ascii?Q?E3Xc2YD5yC4h+7XcWNEnz8ZeCpO+iEI+uFLB2ymnk2hnP8OG61jHBbaBuLtZ?=
 =?us-ascii?Q?S/AHs8IwvXbki5qtHNCvH+sjYIjz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JfclRmA9U/1QIBgiHzPuIukLfoZe6PX9qqVNJRLunGNT2NNeGqv9k1tivmHr?=
 =?us-ascii?Q?tHm9RPUiky6e3dxU+xK6/RH+RjauwM21BOnI6ixQxf0tl6t+JBDWtxmY2fSB?=
 =?us-ascii?Q?HvMvemXS5nic6aL7IMFk4uHLEuMGynspJJ1LcgwkMZeiaezFyyZ07EL8Bq2X?=
 =?us-ascii?Q?eK4ILE7ZubZvuwgPpIa5qtUG0/PZLIUj5dfEzIMfXoRz/RXU+pa60Qq5zpJD?=
 =?us-ascii?Q?cc0bX1uIgme4K8M5avU3K2JwntLLpAq/CyPxhl6Q0jxC6zK/2je2WSGS/rlU?=
 =?us-ascii?Q?jXt6NzpZqsYgnUpoDDryQpoHspE+eqK8equACNpiet01oPCJNyIddv2wuOD3?=
 =?us-ascii?Q?HUGRA9A8iiZozI0x+WBzK7dd+iCpQo4wlOjfd9vXVn4UciD+5AcdTxxnFA6H?=
 =?us-ascii?Q?I+6qRTTxPCY+jdNiZBbvkmjVqF9d4PuaxSAwkDgO6uD9VKBdL6uslKezrN74?=
 =?us-ascii?Q?rqbbQfbtsbrqOFvJdUGiqNXBBcXXVzSMDyzaZ5F3BGQkQgRVFa3Nn5DSw4dw?=
 =?us-ascii?Q?VOuEiIr5iTMC/lsBLS4QRabx75m5u7+KJ4YZL5xznut0YZTssnX8aejP6pBX?=
 =?us-ascii?Q?sB7dVU6N48oQTGzvPrLKQfNrXD19fU73ExKgOeqI1+tqYnu5XNKh+4gWodIr?=
 =?us-ascii?Q?1zErbMwqPFAzyT3FZlLmDzYsn/0vDF4MvwIzjM62T7wk5usmlOgf/VjfKjob?=
 =?us-ascii?Q?DfE6eP+bSj3boN4hdt9xm5CgiDxVUNyiRQqlQuhhaYI/sGpJykqow6ovyLsn?=
 =?us-ascii?Q?woCxFaELbm2UgZqQ4izri/FkazhoOlCrXBPInR9rFRb35zdTxDbMmw5GsQnc?=
 =?us-ascii?Q?su1Z/1LmPDEtAr/2HaA2JTY7Q2fdsDWEwfHUWm7C/GMPM6RqHeg52MNOc+T/?=
 =?us-ascii?Q?gGHftOvl+bVACW8i7NidYy3WChXq1GmBRforimNfLdaJe7e7sdixsXQYfzbw?=
 =?us-ascii?Q?+D5hsSsNBcjOzHepcHgFOMCUWE9H30YmvpxKi5lwj7YhEvHNBRD0PUy1PsLt?=
 =?us-ascii?Q?3nYGI/2BZnbRx8UPrSxnzCJy0ZaMajKTQ8Y9nij8Y5TD20UPPc1rG0gnJHEx?=
 =?us-ascii?Q?kRZfvYb0LhfEMEID5v2SJdQbUPrYT6s6IgJC6JDKFczC0c+ZL2gISjnfQWky?=
 =?us-ascii?Q?i1NeJbfE1k4GrJwl2DjtwJJl0PMyHXm/n4gxZ0zIcol4YC3Lhq7rOavzRx91?=
 =?us-ascii?Q?tSypHlI1IvZNVPcNaKUDcEHU1rpTNxgtpDNc8QSUWXzwajA/f43vUcEyXJI+?=
 =?us-ascii?Q?ibVNmBAldqzLRmd2dfcQpcj5SqFLyztLphYqbStdhj2UCOU0GW/CIdBZJBau?=
 =?us-ascii?Q?ZAJU+o1pUJmoCZ8tD8Rgj+ff7p0S4x0uEiQ/ngh0wcBoZ2vnB0Cclw2sBH3f?=
 =?us-ascii?Q?UWOhPEgXE1HSKTOgq4AvM4L+GNu5Dzygrx0CeEZPBODXCxgaZXLqr/dGc+ug?=
 =?us-ascii?Q?pQuRf6HOu+gAMnNby09p9hflhFLMNiKG3M/9zYdFVl7ggtYmhqOMo3Aqz8tX?=
 =?us-ascii?Q?BHzmoTLH/1hPlo/TOrl5EoeKLDs/4BZGhpefXK+ixXOsAZEKWns4Feiy8SIo?=
 =?us-ascii?Q?Jb/Z4+sxTq6floSzoPy1ocASZ9M1tPDKEbSWlkNUhUeBw+Ibg8aY0BBihD5D?=
 =?us-ascii?Q?AA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BdEX6dXADHwaXBf/EF1GKA919A2/Xc1p3E0plZz92t4G0cHO13eU8vpIwB8yCL/H/l0xeumNBb7WjdP3PCvJL3Vj0ywhr+WAq2j1Bkvx3AeD9nXvpSGxIy76kz4pWM4DfkYlXMg7a4HndqEmaJcwtYBmKrSjKyfoNlyiFuQCSxlY9itDMWGfKz3h0qlTVb/efFAa4S7VLHf3wTwsTDD576W9xDDE2crhFCRmWZIZfnlSgvunC7C0472Kvd10v2szTCOzMvsW88QHqlDeg5h5dFcsK9zKUssmgL/i10udjnDnoZKg5rV2IcaXLzLukfZ6GfTvc0J3PNUgDtcgWGSdcHRLsc4UtJBhx7ysNRodS1jRCw0/nAYMGn3GZUJrAnryUncsnD+EyhP8cP6Ka7ZS47UxZ27cHN9ILI1Omlrsw2hTW+k/j2vT/cEJNHZ/+AjPLyT6m1bloeOBHnFynC74Ig2VAC0KYUGF3KCfgpgYyB9rR4ReUrX1Njx0iegdHy1RlFUcEeqJAh4wQV5/f2ZV6ke8a3L+3pfDXgWNDjfZtlGfsn8pV3yeYnGIMd2K8P52dPZiCPDoIlrCrciVXVPseOCG+iLoTsK0WnXRDn6YmEk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f9617e2-6aa9-4885-84f6-08dd2e4f742a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 12:41:34.3772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8OGlXlfHHCVrG2XoS5/GrLSISdPwVmnXHnVIcBmfxz17T6Ox6X4wDhTtllkWcL/3KBTzXOC3y/fuXRW1O/CpDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7662
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-06_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501060112
X-Proofpoint-GUID: OUFVksgbiRp7aHQG0meYsQ5jtmT9-Yg8
X-Proofpoint-ORIG-GUID: OUFVksgbiRp7aHQG0meYsQ5jtmT9-Yg8

This series introduces initial device mapper atomic write support.

Since we already support stacking atomic writes limits, it's quite
straightforward to support.

Only dm-linear is supported for now, but other personalities could
be supported.

Patch #1 is a proper fix, but the rest of the series is RFC - this is
because I have not fully tested and we are close to the end of this
development cycle.

Based on v6.13-rc6

John Garry (5):
  block: Ensure start sector is aligned for stacking atomic writes
  block: Change blk_stack_atomic_writes_limits() unit_min check
  dm-table: Atomic writes support
  dm: Ensure cloned bio is same length for atomic write
  dm-linear: Enable atomic writes

 block/blk-settings.c          |  9 ++++++---
 drivers/md/dm-linear.c        |  3 ++-
 drivers/md/dm-table.c         | 12 ++++++++++++
 drivers/md/dm.c               |  3 +++
 include/linux/blkdev.h        | 21 ++++++++++++---------
 include/linux/device-mapper.h |  3 +++
 6 files changed, 38 insertions(+), 13 deletions(-)

-- 
2.31.1

