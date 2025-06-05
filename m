Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7EA18C031
	for <dm-devel@lists.linux.dev>; Thu,  5 Jun 2025 15:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749136171; cv=fail; b=utbiNex2jKCB6yV15kPMXxp3qVuW0FV+NFjZYDyiFSEawzsxn6WyeThczUs4TL4Pi66RNWvjJOdhjpcVEMeIGpCR0ZUKWQNYuN+7u0TYZDsQJoIhBCTuBcAtQVoGJ0wH0EeoqAVX4U1fMGHiY60Xseef3Huj9T6v6qQVh95a1js=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749136171; c=relaxed/simple;
	bh=XhSRzs4L0auh/qyFt77U1ZYFqqMG0P+oX8nj9ZzXm88=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G3mLIrpu3STpo/lzShVI1xFsnAVvqciwJa13dADBePwp6Vy8Dzp29kRDLKQKo4h5oSDvz51+Mf6LdG/+sYxsemuToI4EEzsV5Ne3sNuwqNFBKNZ4IP3KUQOZeO0DkzSc4y6aTCHV6Omf143uDaEQvlULti7R78oFv9eHAqrCFMM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mOQsq8W7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tsJIGC17; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mOQsq8W7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tsJIGC17"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 555AtW1k024270;
	Thu, 5 Jun 2025 15:09:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Hu0XzR7Fvlrq+DRDf6cHxJRVjNFb7WRVDUZLob4nQVM=; b=
	mOQsq8W7pRmpbEHVou5cJw7A7hbPCn2o4qae38HqfvGGhnZFI/Z0Lq0YVoUVe2oD
	Wpz40DYclixKcXB8VA8zfCjSQqrFYZyN/EfqRBv6VG/2DnGc70g3gvlYxpNCbT4u
	dNsM+lW8qt5YHBy1yZu4BgjQNc5ey87d0FysYARnuMs/0afduRJ34tIrkBzUGrU3
	/0muLq0XsSH/Nz5u6YVqpdz1qgY9QAYuHGhsRuCsWVTAN6064KN5VY1L3WQPq2Cy
	ckF0heenhJg8pKPmBrBbG7VgW9ROtnjU49m7Di+74nMXzblaHPZRf3raUeZoOD2s
	qp6yvM7IgsazKoTgMP2vVw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471gahee5j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 15:09:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 555Esxru034993;
	Thu, 5 Jun 2025 15:09:18 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2085.outbound.protection.outlook.com [40.107.212.85])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7cejv4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 15:09:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S3wkYNAcSwm/b3JRTTklqjfCzM0YAqa1aKJEGvEa9+CqBLmcunmVlxe6WpBlr6u6fppOBiRo0qJduGiK2aDdA5nBBAXpJSmUE8b8/0nWiuIdvq6MpVXnWjdV+7SK/D+IMZ4U4ewXn8SzXK7JM1EQ5fsEhXsA/tkcUFQnfHnHHr4HzhcD7Ijj8XOz/p4Hbrq7H00VK4Ck2Ga6EkR+Z+dQd76uk/qhUPxZAUKXS5BKDq8k6U6Flo3yreBLqtNmyATiVbAzEVtojnmaoSM4Jw3mJ0mqdOgaRUZci0kY8DgUmJ85m8n5GXM4GwkO26N33ANZvqy0/nSEjRLhXrsq76S8Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hu0XzR7Fvlrq+DRDf6cHxJRVjNFb7WRVDUZLob4nQVM=;
 b=mh4AnkpxU9nhRt6bt2RrH/CiMB425bwxAQTwiv8nU7KVdjUme/hgQjcJUA2GzVrIw6AC6kCC3gJpv1NZ9sCQXBoXFVcDS6DTS9JvpFxPNpHcMgmCGhhN42mpc5lBlcP9IX7uDymkk7XFpW0EngNc6EvvRH4PFITf1CJwbSWjcuvHh4KfjLdmusC6nU+tYw5sm3iDKUJvHASnZxvHao2M2rwYjTUhEydSBLy58yp7ObA9Yb1vxf5Elllzce2CJtD+p+870uEuHV/52xRxTkCdB5mx3aPUQARENWSqlvh3osJoyW+PrHYJPU/UnmApXtCto0qXziBGdaGskrcvo3j5Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hu0XzR7Fvlrq+DRDf6cHxJRVjNFb7WRVDUZLob4nQVM=;
 b=tsJIGC17Ur61/q7nGmbtzjqWvz043n9vh8MHOQ+gGDzrXdgUC8KpGwo5ou9bU4i6mg6bHeBEcu30KPCqEKt/qL7LQQAPF4hHygH0d9URnQwcKSS/sQ0aqRX78rdH3+Y1K3Eb2+icdk2ZsL3jzGbqRCmdynUf5txauJ5UpQ018vM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BY5PR10MB4177.namprd10.prod.outlook.com (2603:10b6:a03:205::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Thu, 5 Jun
 2025 15:09:14 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8746.041; Thu, 5 Jun 2025
 15:09:14 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC 1/4] md/raid0: set chunk_sectors limit
Date: Thu,  5 Jun 2025 15:08:54 +0000
Message-Id: <20250605150857.4061971-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250605150857.4061971-1-john.g.garry@oracle.com>
References: <20250605150857.4061971-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:408:fb::8) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BY5PR10MB4177:EE_
X-MS-Office365-Filtering-Correlation-Id: c3fe2129-2e7c-4378-9e2d-08dda442eef0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6rILaMWvP93vN3a7VTlEWdwd2Z3n8V9nW2JlCApTQRfVbHwhz8F2EgvpbEKy?=
 =?us-ascii?Q?S7hzBh9JB7njDQV5a2G1asiD9aOXIsCdQ4N1gJWhJWITbvWA9huiqpD37lJl?=
 =?us-ascii?Q?DMHuCJwx+3LtyowOJ85/9fn2r/C43HfWT30+WWEvGQw5FzdiEdRRx3vR/4E4?=
 =?us-ascii?Q?9uygmwyT+oX4yz33AH9OgDyU+N3vW/NjRsl23qfasCNyvaurHVNC6pImII/2?=
 =?us-ascii?Q?30jXJLTomlHYFqYrWhuXJbsx29vZklIXmfUFw9yTGkd7AxWNFMFRSiKZzv/W?=
 =?us-ascii?Q?Ef32ArxDvvwe7w70h0E++CRLJu581CvQotXMFwUquySiZAzhpD17xVf6o+Z4?=
 =?us-ascii?Q?jvwjghtwo14Hsu6DrbXtLqL3KnejEUIW2qI9gwsQh9rOpSa0KGEOsnvgxntA?=
 =?us-ascii?Q?JOiJ643rYx8DqYOY20UFV4vymqmANZSIr1Es9LTqjVex5+H4nOry+SvD121M?=
 =?us-ascii?Q?8ZiC03tngqbjzzNJ7t6bM63kPv3qiPZcSyiHzZpJO1s83MeFAxdHc9RkEyI2?=
 =?us-ascii?Q?ivxiKcEenXQCDU8clIIBc7lIy7u9FTnssluSWuSd5e9XMtS3CxYibq0M940m?=
 =?us-ascii?Q?BNbREZMv4r5SbXj1SHyOiGF5Dw7xV/Dn6ZQkvbqut8oOubiaiwQ0LNt78I7j?=
 =?us-ascii?Q?/GC86h24NTDKBz8E7l7RCc8Cc3vlcc5lqIA1fd3OsALEqaNLKXEkwn3Q2vE2?=
 =?us-ascii?Q?8w/3Z7lievtVAXgYzf7brD7l83Kd9uP8Gswy522AYD7orwM6t6JP1WbEOA6w?=
 =?us-ascii?Q?yBghZljJmkxcAu5uVB9nJSsHC+d4N5bTgAbwLp6oOiFTLoCwMk2hhdyR3/iP?=
 =?us-ascii?Q?RAgNkXps8W7iEbYSE7xF6FTiPG6bqaAfF3uQHoh0mgnbKiZRQgU7nNiSmdLh?=
 =?us-ascii?Q?ArY7iHHIXgbjGTHJww3Zpnhh0s3CmP6GGpYGkXavRyWPC6ZNO1n0J/DJQKKV?=
 =?us-ascii?Q?f5Z0kBlrl/UCL7pzCLT8SVHUfnsSmzOlFO3yM/89tCN20gSIiZXeAFzGp0VO?=
 =?us-ascii?Q?DH8K+m8Ss8/rT05zVvRcr1nEAbSuVlTs9lV8THwuCvpgLK8PM7oAL3lLM+dA?=
 =?us-ascii?Q?CAirANTHfZaWQbhroUaLzA/Wn1nMkC1QHiYP5HveM5/NbKarbdN8YHajEnSn?=
 =?us-ascii?Q?+JBO/F7oMynBBAT6iu/0RYpwSdKwcT9HSO5Vlbj8AM/qx3Z7zudL4JO6lJ5d?=
 =?us-ascii?Q?407ix6c/vgcUU2xL3lv9T0mFryfnQ5jzNnyhhLCijfvO2XZWa7duCnSoeLRd?=
 =?us-ascii?Q?S90tVlGhKCVpjG2oepTtx7V9G/0YCZNtzPNOdk67E1epaFFsV6FJ3srD5Uom?=
 =?us-ascii?Q?jLfGPUPtuSompy2fdTroVF4AySbjulJFOli8/VjLNyetXzvJNnWvGVjZhlYr?=
 =?us-ascii?Q?V9h2IlV/Yp7z6Dpe8XGB8doQHhM0/nLgng7HFkfmCZIuurTYH1Fh9x/WyuXQ?=
 =?us-ascii?Q?hvcBj4Z7QxQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7inMtQzDKLhM8kuntJ5glflH9v7yjDV2xM3Z9Hkp90LcDpG7cLkVuf4Jhymu?=
 =?us-ascii?Q?LiTM1/CmOCUq2vh/GJV2K3yGx2c5yPH7dWQYlDR6yo5tWYE7muz6miOHWKGH?=
 =?us-ascii?Q?DaR+NFV1eXdupGBm4waA1a3TKaxrxa5XUwqO+VPKim6+Zl1BrGdle9p41tft?=
 =?us-ascii?Q?PNMep2ZH3HmGmLAlw0uqSU/YpwZmav1cBTJgIR81bTjxfHk7djbdZVGQtHz4?=
 =?us-ascii?Q?46n03wwTWsXH9TiQbmgYFWhMT50uuXVeDrFOws3KetMoFxoPZowEQ2PibOja?=
 =?us-ascii?Q?fj95WHv4ySVvwn5vDV+Jyb9OlsjtmJrt4s2PFItLUWdH5iuUNVpG1B1/BlOZ?=
 =?us-ascii?Q?KGa5neJzzR1toxIkUqhBX2fk4L0/WnErjWS2dmjGXe2YbxhDOHlmfRt0hfjc?=
 =?us-ascii?Q?9e4yoRpURE3r152rx591+YRbOiWu1uS2IppU/bLK7pxjKu0VXC++vNgV0zbH?=
 =?us-ascii?Q?NtOZjmJig6C280cFxfx7AL6DGaAKAI2wy7FJMw3Sn6IZnlxevreXFOCg6beq?=
 =?us-ascii?Q?N863YEK2BkG/wiPVYwaVcF+h+f2DYPLVsZo6LwzW8QwKZdij76bYriIZKMaX?=
 =?us-ascii?Q?SGniOqH9pB8Br5AoCuTFaTJoy21jv7xElswbc5t4QibvKSP6dPi6tFdgR8Dh?=
 =?us-ascii?Q?4ZakMaIpb7Ny/5OTRopxkBF9RHcSA9Lak24y37MVKjbLEyYlHr0k1K34b2hf?=
 =?us-ascii?Q?ADhsnueKJ39F0wacF5kFQJHgntRwKiJraLIu4dJs0wrJnn1ndh/YkC1tT8sl?=
 =?us-ascii?Q?1WrhsgAMzw/KP3zPPW+269xpoUkwVyKFJ1DVVzEVn+Cfx/xa+Uq9n/raD746?=
 =?us-ascii?Q?VMfBVkfrEEyX2ohAf7PdCbB5s75cMzSU4Up7XAhbbAGsRvSaASUZOOkO5ClG?=
 =?us-ascii?Q?6par8YkQBaGNO8Nw92GLnME/aMcgS1l/LUP4wNGYeC0R2hmXV59n5umrQ/bf?=
 =?us-ascii?Q?79Pu4R//N7GBukYvpb7W0DiuDG+X33UZ30RwZuah0m8SuczvI2TjN3UB0p2C?=
 =?us-ascii?Q?WCy/Pbg6MpG7QQ2fhBvvPGohPt/VV1jXO8p4VhCejIOBjJ7tMjNkpx2c1MJK?=
 =?us-ascii?Q?SKGbzuX0Us3nATn7oqJfSJPhB6a3iLIJ/OD0NX5gM9hosguNcRF6U+xMt+h5?=
 =?us-ascii?Q?0rwI5fBoKpy4N0G0MAufi9j1LRw3s5JLhgopHMIUXwfDp6pfHfQAIlzzCUeH?=
 =?us-ascii?Q?gihtZktt3eBS5LlVH4G0LAZTzxM6ZrBl6Xj2pqHeFjmDlo68qk8h8OvkZkpb?=
 =?us-ascii?Q?6fV3KsT8TVGfnW//9u5joUdKMeLrdxpb5tCCu7MgwCohufNMS1wsxEl7GT3m?=
 =?us-ascii?Q?ZoXqhZjY4vG8JhmTnZLyhqGhMp+zWWqFtZGY59srl5fThC+zsSepW0eUKmZh?=
 =?us-ascii?Q?U+1Lm1IKXqhUPNP1d4hBk2RGNmMyIf1K8KEyU3wUqJDMQJaqUj13dlSjl/VP?=
 =?us-ascii?Q?pmOD67HUWCdHXE7VBmb+UbXS0OatX6fe6UKjVpdKdWHh0+/w3TJsJ5Xbh+iu?=
 =?us-ascii?Q?+1tbGT7Pv3UrsPbWYVrk06JTtCunkKsVbUhCJpmWWOCzaTkoc6iMchTnXOpS?=
 =?us-ascii?Q?44QLRdLPntCVGE6l6lBtd24hWxSd4N5FxLrO1VCpeyooIsijVn+uB3jQxHAB?=
 =?us-ascii?Q?Sg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WkZmBSwf13Uxq6ktu+1ikHmodZnh1uLULUyCUk2Bb8pmp0fJdcvqaB61Z9RT0MQWM3xzUI6Vo5dffpq0gu2yP/iJWUadjsUjbKPKTw6NxWZH5TAB6vjeJ98QrFRzc8qeH5zza+zoj2Zu1phKgGV8JXJHEEoR2KbjkrSNkqii1lL16L4GpCBU+wOdORpLvYjMvB00v5UQzYULpPci5fj7HqcukIFn609E+oJCpGRcor90ReMZAJ/gztIPBR9xW3t/FeeELTf2JSKM6T2R+NDLHU5iDeCJNTnRhBeglHbvgJgdmztvFkuxlXsQe68oHFeAzAyaudymH12KVIrE1GLnF2Sqd49R60tv9wsDKa2wZV3R92wFNEQGKGWd2diT3Dy6voUN2fSuwivMI7fQLbMgYmoUMcsLW0vLo5ZAiOVK4Tg5jglh2jtzRDeoT1e+10FVBX3Z2saTlx2wKs3TP5jPTkkk8A4pL5YLOLyOs9Gfx0HWz0doZP4UM6y4Q9DFeS2kYQrxK57AVu2z6l72f3bO5txPvyukFxMdRPHkT0ePP6x30RA/iFcNfOC19JWWycdLjqRMO/vrqqulD4W4YiEi833xiE18iTL8JGs1eGqQFaM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3fe2129-2e7c-4378-9e2d-08dda442eef0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 15:09:14.1805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vYqepbIv//elOeHCE6cUrNQDMBqTcCyH4342gf9sWG61MVCzrU5WSEvjyE+n1S+PQmQA5Z3EJAVZh79g2i1vYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4177
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-05_03,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506050131
X-Authority-Analysis: v=2.4 cv=aqqyCTZV c=1 sm=1 tr=0 ts=6841b31f b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=7Kcq9eLNRO4W3QebyBYA:9
X-Proofpoint-GUID: iXAaQwbqu8LawNV8jmXTRVdUqbWDMsNY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDEzMSBTYWx0ZWRfXz7YbNZWT0XAL 1NJKpBeaJ9wv8JJQ4ziD4yCLLzsV0rCt+/Ida48a2rtp6QdidcZYivDP+emaGSoBjDV8LH+vrEx iItsxUq3UYzn1zLTc0Ys5LhKa8NZYc5iO1qa29XcFBkTFlbvvxg1GTaxTxXMKzra9K2fro0zXQF
 oqPcsHwFRl+xQv7PHg7Dl5y4fytC+VdlMLwVynhfBaH7dvpMVSjmWyfUaiyWO50K4a5GA9u6WzD t25u+bYqLZbLQGZUduZ5d8Mwyks05JRn9ZFI75aYC60Qhp9p5K4DtgQNt5pFJDbNEspU2a9uxsL WYTQKCs5zf5MuEM1ELKfP5H8Z26MVX2aeTmVSa6wXHDjB/DE8TGJEtjDzJtD4l+yCc2amjwldBs
 9SunRjUiN7ZLXXnALCqdm4rsXgaE1Mq49liE8Bsz9H9wL5pJ6ps4R12RJdVgp3prkoAPRRJ3
X-Proofpoint-ORIG-GUID: iXAaQwbqu8LawNV8jmXTRVdUqbWDMsNY

Currently we use min io size as the chunk size when deciding on the
atomic write size limits - see blk_stack_atomic_writes_head().

The limits min_io_size is not a reliable value to store the chunk
size, as this may be mutated by the block stacking code. Such an example
would be for the min io size less than the physical block size, and the
min io size is raised to the physical block size - see blk_stack_limits().

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

