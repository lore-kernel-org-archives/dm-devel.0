Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829FE1E519
	for <dm-devel@lists.linux.dev>; Thu,  5 Jun 2025 15:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749136470; cv=fail; b=S5vupy11HDUpRKxAbDMvDBN+15m17mmwrAt+q59O7sVs1s20GtlcMbWaXSwNFyU2SBnWPlMevbuWM6jrrJDRK+V2A0javqZCOnkR+UwCRDk6CSaZ3hjgskjoBsvvv3XN8Eh51RDNnQcn9MW9jZUpMudqYOunerziicG0Xu3Dv8M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749136470; c=relaxed/simple;
	bh=X9xntE57zHFQByKs8RUsD+FKcze/A0/FTbk0CaTNcpI=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=GnVKyrrIgBp/MNsNGb1ClmiP0cfETnETvncmaMWnsI2lKh4zUjq+FjJ+smTGSEfvDIAJJbJ46opfnKE+HeLI72Q2tPrsuGs1BLK8Hlhr1fvVkkrT28qRp1M5VFqH6lt/cmu0GjVEd2k9RJjbcl2mt1QjPV5palv+1QLRjFO0EYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gWt0YyBP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GNlnvf4O; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gWt0YyBP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GNlnvf4O"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 555AtVcH032032;
	Thu, 5 Jun 2025 15:09:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=Fq87XAu7lYpUEvwR
	ClcAUgMBZCA4iHNTwJR9ge8uwaM=; b=gWt0YyBPb1tZ4a/t/mIAvNYTQ4ylvt2u
	UhHx88zPiPPMXC4RfQDXl9r13imwFJOkBa2j0CaMOX9Wzw8MHtCrJeBYzSW+Rpnm
	WEN4X4HFX/qO//p5YwzVEoDNFKaYODkbK1CoeZq7GLP1RapVNpbnFEDbxXuVJPiS
	QxJvgyj4ktsTSrl0+mf7AAhMUUYDUJmOuj4cRI1ibaJQDIr0Ckk+962cQbInEaWk
	m1Th/QRsRDuhTxnG6hXSjG6S3fl6VrmjsxgwX8rcnY4I9L9O5oWkMQTOhEs1aEq+
	ZcTSRf1RINUI4b45KAnS1KDWmud0R2BvqtYKXSgIJF3YsZXFp63z4A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8ge98f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 15:09:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 555DkCux038592;
	Thu, 5 Jun 2025 15:09:16 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2052.outbound.protection.outlook.com [40.107.243.52])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7c7jyt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 15:09:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j0ddFA9p9bxHsHiQF9ZiYV3930n/BxOJsae95Yrl7O/6LFggX5mTvXNEtGsboH74NIQmeFazAen2pAFdQa2E1utM+1bTKaugArgVebpCSmDob+l+ygRXGSobqe1+pMtX/XTOrR9r5aMQSceCMinwnd8yFa+dhmzlJid+9C6ba/Ddtfz9tVf6MiPPfkgrP3UjvuRya8ybzxNPem4sZ52TX3z9zT4oZv7vDB8r3Cc8AU/vkgABP2gk1LBjKwZM3PgcDVik8NPGtSCRabqqmMuKTMDhhdNYLqAPxwk8YWQ5Jjv4RktEADNBJTh5LN541T82rVVfHFxBNJSUYJ0wK00W5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fq87XAu7lYpUEvwRClcAUgMBZCA4iHNTwJR9ge8uwaM=;
 b=ViF1WAnJn7iPtMYFR0U+dvUMHFDObHLrdlslHKmj8Qn8vP+/FTFPvRNmbTLGdhHqsf+X2miUD8ez+jQqYM5J2UAr6jKEodMrgblX5vGOvixioWOdhp6w3SfufimRSYg2tNpFpKev0ONRj4X1JVweJ4h4MxAjeI+FEL6Q3WkOnQcIF4JVol/B8WhCFKYnE6kwZXfKFpFoFPlsDtA59LM9wJIQ4BGsN21rXY6k+UsUlWaccnD9uvleIc1cRlwbWZ1SUm/O0KTo1zbU31uH1aekU3bHoAvC+3u85ImYGb21bht13SPTxZHM6uyFU5iUshHFeNB+HhidXLazXj2/vaUHJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fq87XAu7lYpUEvwRClcAUgMBZCA4iHNTwJR9ge8uwaM=;
 b=GNlnvf4OW8eTygYwUqPXl4v+sATay4I4kKUo/JzHQJQnYsjn2oR/wy31UMk2cBaSUxWyzLcKtd5SJDo2bqREmOFu/gdbm5cqKmvU98edxt+yM9YzSyVfVGKSBB8irrrfZmfU8N7a2SKgOr/y+zh2qARJ5Ex+OjBSwOqtQ+TikVM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB5099.namprd10.prod.outlook.com (2603:10b6:610:ca::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.41; Thu, 5 Jun
 2025 15:09:13 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8746.041; Thu, 5 Jun 2025
 15:09:12 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC 0/4] block: set chunk_sectors from stacked dev stripe size
Date: Thu,  5 Jun 2025 15:08:53 +0000
Message-Id: <20250605150857.4061971-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0043.namprd04.prod.outlook.com
 (2603:10b6:408:e8::18) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB5099:EE_
X-MS-Office365-Filtering-Correlation-Id: eab0ecae-389b-438f-9408-08dda442edff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uBcTguouYVrXWJwez4/vq4qQhw3K2KYDtnillPInPgz2nZN32IIxHmiF3M9B?=
 =?us-ascii?Q?FOmjgDHD9m2VFX+mQm80LSEK9LostNf7KMQqOHNYKi1wYUAYlU6MatOOhB/U?=
 =?us-ascii?Q?zkC9f0d5XchEe/Ac0QkTSBk8GL0wIPNEkI43LiILWwNTkBOobOqyl4447ehW?=
 =?us-ascii?Q?HMDJDz4aZdQJlnD51qcbbc4hFGKxfzwg9fuoqPE7dIooZSTEIG4wujHW67QB?=
 =?us-ascii?Q?mIP+RVPPErcp2uzf8B2fyqX0O9GNQVJOj8umOkObtrwij0bg7/4IIlamRqsg?=
 =?us-ascii?Q?5vjM+CrzbuGZoPkTXM84P8a1IZj34TVOhi41tXRnyCFgRbFc/G78+sMKL6yL?=
 =?us-ascii?Q?aJb/Wo5QBlGJMsPawYTkI+JoqA5tecebhTctSVWtGYbYOUbTAk3dSLsgyVlk?=
 =?us-ascii?Q?Ee91RdCO9I+B2VAS8H4zvg6R/SVYGZBjaImrfa+bqDzIwjgeq/lPb/mBfHPk?=
 =?us-ascii?Q?7VWZwebirmpBioCl4Cb2uzasEF9FJuI6O7bHQGprQRc4jCvo+PvM94tau6aA?=
 =?us-ascii?Q?pk7SybXGn/bSnzJAsMBrS7XXqgt/mJwpMctS1T1NPwl57+05JVrHs1COAVkC?=
 =?us-ascii?Q?7gOjmAkbRQX01hbr6qrsdrBPb2jPZLTPsn5Z6GO44tdNf0CvdFzHUzMU/6IR?=
 =?us-ascii?Q?ePHZmvlfE7DrOb147Rsz1Vg0WjxbXGyJSVFRaCACRPt/LwPKTWNArH1LMWYZ?=
 =?us-ascii?Q?tdTtnhfoOqnOYDhxBBYnlrHQGzFu2w8HfG/ev1lmu3D5HLkj0AlHbobzo/0L?=
 =?us-ascii?Q?EaYwinmZc/YWu6HrzgKedsPoIjPFINGwYrLGtShsvsAhH69BU1xiPQQU3gd9?=
 =?us-ascii?Q?3iV5HqI7g9V6sQb8uhkeZStc5O7faUFrroRbbE3oKe8B5ua9iusHddDgTV3U?=
 =?us-ascii?Q?ntz06MzprMrB1BjwrJMtunlNbH5f8A/4zsD+GFyR2qfr8in9cbgThDAxDjCw?=
 =?us-ascii?Q?H2daVONWXeguJy2v/WsNS1DVeTz6KKvwm0eaXhMEN4h17fB4+eqrmbTQQIhD?=
 =?us-ascii?Q?lx1/SmsKmrg3tdf9WLQn4m5sofCgcUIk9ZGMqBW9xo0sDrg+mF2MBDcXMB3s?=
 =?us-ascii?Q?PJePY1RP449RjCb4MFnW8VQ8SgQ5gkZDMq2htalaKKf03+Qb8XiaJcbJhLT6?=
 =?us-ascii?Q?L8kqR5LiP6tQOxXx0d8GwakRjfuqwrnHczMHovNK2C63n6YBzCzyOlCK4TfU?=
 =?us-ascii?Q?QUlhdErp88OOXr7qFhWft8VcNO+sHl8BXkbJbZ1EApnemA3AoElcUN3UfiJc?=
 =?us-ascii?Q?/5z6Je3qjzS6cEFCmyxA9PZiu4AdqaNMQBkNnjLm/sNH8wZEvqsvpTT1jjLN?=
 =?us-ascii?Q?vEqfT7MBSYzbZFAFOKSK3YVdFZGIdnuJRl6EgR036vfGf46/s3Wlk9aIWZoF?=
 =?us-ascii?Q?YBJYi7rITApLNEtJEGanZWxYD/8p?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8FRrupfHP5hVI2vzn/AS3kfAlavKHvQKiwEL79AwGkVVovbClyCvQivCr0m7?=
 =?us-ascii?Q?iCrT/Oy4ox1nA65DFxddB/FAlHepo6td56iTU0WIcsabI7tASxguDC0gRKBG?=
 =?us-ascii?Q?3qCobIJDlovsNYcKMpbpaHDTe9pgTUW4cE/A21m+Z8fuPTcckTXrkG6WQSJU?=
 =?us-ascii?Q?huG6zteP4qG4raKSQlPntNUJH20ScMi9WeBpxa13HUlkZ5LerjVV467YJZSD?=
 =?us-ascii?Q?tA+rgbHiZA/bHGrIa0wElRsbAn27AMEp2aMZu+qlIeYmt/AoTgH11HZ5KPWh?=
 =?us-ascii?Q?Sq4AdqIYtE6FSgiCL2JniF9NMONV+6q/6mZXum58xU9K4WJt8s9dxP4AnYus?=
 =?us-ascii?Q?10qPZzlKC7+ysq5Ibmmanqc0HhdswT6jYdWwaC6pigW8Z9/RuVRKtWz+sB2t?=
 =?us-ascii?Q?3sqjfT4slvTn0gx4s6c6V1/uBzct0m1ezQAM5jdz8Zf8UewrPw+KiR3e9Nrc?=
 =?us-ascii?Q?VxMbq6N3n4U8gfRMEWkBdAj0uJwiHU8LueIYHv7o65SZMUy3XkawfLZZcCXs?=
 =?us-ascii?Q?6mrc25uT+Uz7NjEpISwR2yMapbo0sioT6OV7wcEpQHOStgoIA+mET3kQHlCe?=
 =?us-ascii?Q?S03OvQbbJYMBFkED77BqSkvINVzcuoY1h3G1S/DB3cqC3sDR4dqdQ9M2FPQp?=
 =?us-ascii?Q?BW/1sD5uzuHsn3A1SqAjRI2fa2wHIyTDT7C7zzbPpYI9MCDWsIV4h8VifeES?=
 =?us-ascii?Q?lLdBeZ+ktMZPlAGq7QwQqSDI+zHfLLzJD/zsT1DEPXg57cRSYtRV/rVRGlRT?=
 =?us-ascii?Q?J8j1iFoQhfSzTgY9l25fdbJwdc/FhB2ngr8qhNY/sxuFuP+azyW4gDKVrddD?=
 =?us-ascii?Q?Z75qcCDIb4f2lM/fZtvhUoVUR39OinCUBDweWFQEAFSnoTjBTJBW6iCfNyfH?=
 =?us-ascii?Q?XVOxa5lP/65Z29nBiSMfzN47s/ve6bchkQj3vf8ot7IL4J7N/Qy7lbs608ns?=
 =?us-ascii?Q?RtInvsbBX6Oaf3nMvSFoKZMq2C9jsx452NFOsECYABLMCpNQI2zYBZXBLam6?=
 =?us-ascii?Q?Zgnsaw2DiySfLEue2UgQqkOsKtVBlIelPcCoIM3N5QApSQZExB0+VaBepCSP?=
 =?us-ascii?Q?4PiJJQ6hvvwAGpQXvPgoBB9pypFdQ3dXhqVMqQzaipV/NGfSs9mcOIq6ntdB?=
 =?us-ascii?Q?Puy3NNXum6L86FOgIB9eXRKddL60DoK3sd1rK+JrfYXVKqsyGrmfEuKxfgNx?=
 =?us-ascii?Q?Emjaq0tKXPsnEfJdrUnjWMyJ960RoO5lm5TkukCVCUHTzOYIidXMvR+z5vEx?=
 =?us-ascii?Q?ri0qyZ8BPaEnCF0JVSL5agq9d1Hl0AXESXqXFRcXLoLMmaTT0zU+tezhbKAR?=
 =?us-ascii?Q?XXgl2LOzJSRqXccDxdY2sS2mmeRp4bx+gT6qvZOC6vQ2UxNkCBOnZ5QHrXht?=
 =?us-ascii?Q?HdrmZ9CnYBXhglX7gAQngV3HuAqGXupPDPqleBNrz2DiXBL44pQs9Qb3whYk?=
 =?us-ascii?Q?Kj4p0C/i0sKleogrt3lzhLMba8ZXGTZYudsNwmoWpk6uZHnHrcVCEUeW8X2v?=
 =?us-ascii?Q?nmCZp2iekz1ztMO6u0GrSFg+sTSWccYzL80303Z6opPOMtAfwnLXdrg5Sf9d?=
 =?us-ascii?Q?XSoISBXl4TNZeFwQf+VGq4qBdTO6h7OvXcgv30+sqwlU/5ANf8gtD1tsYenK?=
 =?us-ascii?Q?xw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AznjmWxkfYVnxOwO1JMyKXlsJRsRpDBQGxKRNnn0NcncRk3VGGUQI71aHzepI3zK6gNl9tmiq5hFzRTW2RDGqLAzcqTHYTHKhF31kiEnWwX60X7ZXsNFZZqPqmjv/OSwha1WzBelig5RvjK4B0J0ATsIY9WMKmjlz7LOQdi/s87nbI2OvKOHMnrpNvhFPfMi6LgvoPQa1VKgjollrgMVu2bwiwqGYvgIVq0dlKABjyNmMbCaMu0rdbC7UWS6VYryptAP7qfj17DtD8ov3IQyfQ8ldeZevUNDAjqT6XpvyFlDdBE+jlcp7EEQRcuzD4Fb2SJ7IoDCzOyXzA1XK7TtkSJbzXPosgHnJYwBXbuGUgQQEiQsXiZ0FHmPSKjOxEsro4FqPynDuONDihNtWoYZ2GroNFb1Rjo6Mvt4nvO87TPuFAfZs+5jN8HFu2k3yO+fIPwQHJ9BTO6ytL9US8rC6xwRctFirt2liZSslAitDusdrwYSb9aUccTmPmzpz1ufQXQblhRyAfQB88VYgRcIgSS1sjk4Ab7IhixqxbK4vJspQHkooBvzAJrKT1NKhOrKXdmKP7hwUp8kn6ZAPIzJ+a4zeve9nWIOyNpsWa8Vr6Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eab0ecae-389b-438f-9408-08dda442edff
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 15:09:12.6436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QvFkWTAqe6x09Q+KavZb+4FSdTfa86grc2vQUGU6O9LlcWCtEFQKFexwyIF4GqxgbwQ6qlvXWA/IhWgg4J5GuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5099
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-05_03,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506050131
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDEzMSBTYWx0ZWRfX2kpIVZ9VfSi0 ohHlx29+Bgi+w84GAdHY59ZPJjoHCEFAjao+WfgLYHzVV9AJ4loSDjBKfovLBu5nY1k/b1j/1wu 2pMFswIoDFhCaTQPAORFbYP9LPHllYpv9cnQ3Oedhrg0YPUB9Ar9eU3Ud8ewMe8Tzi4fAeiJkQB
 084bt/vKD/a6hB9f4FNnu+QE3PJSjxxPDeehylMrod6DuUThYI7LyBO+vbVO61y/xJqSLhTzSZs vD5Hd0JrMjKZhsVBNoRMYRN8IOwITdy/qXIexIS1k8Tu40L6l8GTsF5TP2jwAl2Z71sEpOX0SmP sB43G1YEZTD9AHcOSY8zrZv0VmMq1Rpai+FofsxF8t1lHoJkb3jA1LtJDRmjQXbhGeJaY20M891
 rZND7ghQoAbHdoIN1jZF2cTJ3HI784LLylEl3KsXvcoBWGRGi0pheJIBBpYGnHIfnbyNCPv1
X-Proofpoint-GUID: yDuQKY3EaPEjiYQVVQhMGO6_gC4k0_W0
X-Proofpoint-ORIG-GUID: yDuQKY3EaPEjiYQVVQhMGO6_gC4k0_W0
X-Authority-Analysis: v=2.4 cv=H5Tbw/Yi c=1 sm=1 tr=0 ts=6841b31d cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=_GdD55I-O2iFgXP2jqYA:9

Currently md raid0/10 and dm-stripe sets io_min limit from stripe width.

This value in io_min is used to configure any atomic write limit for the
stacked device. The idea is that the atomic write unit max is a
power-of-2 factor of the stripe width.

Using io_min causes issues, as:
a. it may be mutated
b. the check for io_min being set for determining if we are dealing with
a striped device is hard to get right, as reported in [0].

This series now sets chunk_sectors limit to share stripe size.

Sending as an RFC as I need to test more and I am not totally confident
that using chunk_sectors is the right approach.

Apologies for any delays in response, as I will be OoO soon, and I
wanted to send this to share with Nilay.

[0] https://lore.kernel.org/linux-block/888f3b1d-7817-4007-b3b3-1a2ea04df771@linux.ibm.com/T/#mecca17129f72811137d3c2f1e477634e77f06781

John Garry (4):
  md/raid0: set chunk_sectors limit
  md/raid10: set chunk_sectors limit
  dm-stripe: limit chunk_sectors to the stripe size
  block: use chunk_sectors when evaluating stacked atomic write limits

 block/blk-settings.c          | 8 +++++---
 drivers/md/dm-stripe.c        | 3 ++-
 drivers/md/dm-table.c         | 4 ++++
 drivers/md/raid0.c            | 1 +
 drivers/md/raid10.c           | 1 +
 include/linux/device-mapper.h | 3 +++
 6 files changed, 16 insertions(+), 4 deletions(-)

-- 
2.31.1

