Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6082561D1
	for <dm-devel@lists.linux.dev>; Thu,  3 Jul 2025 11:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751543219; cv=fail; b=lcvaysoVA7hXto5uqdvn5bEbD63vbiCg6ArxeJjg3mKolF6cSE8c8byqxtqrnTlcPIbxX49EjmjmsOJZtCPDEqQkvWpi/JOF01xaE03Qnhb+M+kzP1Z70uoxMgX5smFqQKMSPpTnpIV+JShnryMCoGUrJPImxsaX4Y009qrndK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751543219; c=relaxed/simple;
	bh=tYb97xYS6SvY4DR1UD8j0VDm6KYBcSdgzWKlXc6cpQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=MAmTiRJ+oRpoHtYkljb7DQMEDaj7dS2B8m4DcxAFIAl+4W91F+h4+qwRW1kR98KELUi/A7ui4TOWe+F9x3RDvgGFyvdBxKskLYBk+FMAWflrzFLCLP+a/aoJM8/hN4bOBDUIyBLemMSdpRjH8SVZbojDdS7p7LBJ7ecor7KWyfk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=b1CY72Tm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iq7jt6do; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b1CY72Tm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iq7jt6do"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5639Yp2L015470;
	Thu, 3 Jul 2025 11:46:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=Q7Nx7dZHJ1ycB/kV
	ikBOr5UaA8lcNMJf2uw4UN2h/K0=; b=b1CY72TmIb5sPLFlvYhQZ/u1wqx9J7j3
	na29FK7wWY0EUVHAHgpm8tRp4PzizPJTcRO40Zy4bSEJXvllYLHPHEUftg54FG59
	dRV1rwvffd22ZgzkBq7nbq75py23esA+xPLPljRllaAogrugm3MT2Rz9dUKAQteB
	WN2wYoAx4BNuQUsf5NjnSU05w6mBH0C4vE7mWv5VlCDiskfNGTKul+Qi9O5Lvvtg
	AdhOUGz0+IVgfk7PpAEeErH+NF50WuqnRe10FFO59D79XpwI5tzO4+x2P0EVJqyB
	sRC0C1CxfBdUGNJxkSmEvEcPDeffkG8TB02p/e5qwZyrtVPjJmVAJQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47j766gw63-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Jul 2025 11:46:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 563B8euq027527;
	Thu, 3 Jul 2025 11:46:37 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47j6ucgj1q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Jul 2025 11:46:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IFbEJs5G3c4Bl6LyZ0Rz444xJVTSv0DKRKqKB0HUBl+Xyweyz5x986c3nKLM1svYSJZiPU4o+r+wk6DZR9BKca2XayL2wHRaGGEBPlSon0FAvCXK4KbiY5g3STEak2zrTZz826bUOWugTLO1JrSBCh/Eg+pjNcb+RELRurrPu0qIyPGEzD8SPoJKCxbXA24vfujSSI/l8fJxsgo/Hcyg3/bgAeASRPTRhMtCjs5lgTLC9wD8eg3DhW4q3LHWkG4SdGXVG/gZ8bNaqfRGR4tnbM7DBQqUa87UVpJftpC3/3yirdyjahQTH9/1vZGe8nBDY2yDojFekbkS92QDBTPezg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q7Nx7dZHJ1ycB/kVikBOr5UaA8lcNMJf2uw4UN2h/K0=;
 b=yIRS46ANTieAPnoZ486QCciCHmWPymt2+448uiEfXDlfM1FHTnAyzjlzv1soPr7PU4e12Ce8KaOloO/liQ0e1YzoimjD740cKvhFzuIid2Cg+1rxdy2cFSYt6mPYF6ViamJCMKpjKbyj69XGzM2kGlbipcfykJNI4kpzTKt4a8liXmsq3+tjC3VYEWv7gukZASXMuyifFPdBW2MYitTfjeYYvyJAxkeyam27Edx2/9HVQkQKMCiaily1/eRYrA2zss20/AiwprNdWkPh3WztndQY2+c1LJF6FTpZj2TEF2IMHBaiRBIiYg/aHruhhF75orMN283N+moSUvm66mHWaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q7Nx7dZHJ1ycB/kVikBOr5UaA8lcNMJf2uw4UN2h/K0=;
 b=iq7jt6doXW1A2ahA/6jCxUZUsA4FKVpjWUPjilcjcUrHPWGNM0AVbuTtyDN6r1O5pcaUB9DKu+IfLZem7Q/38rvbETDwEOSZIN2CUuFeAtAUnCt18PW0/u0ZDdoCwkSANetq8iTRPqpxChP9lG+iyjf7TGteYXYW10LiLLSeJmQ=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH3PPF262994532.namprd10.prod.outlook.com (2603:10b6:518:1::78f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.26; Thu, 3 Jul
 2025 11:46:33 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8880.027; Thu, 3 Jul 2025
 11:46:33 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        song@kernel.org, yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 0/5] block/md/dm: set chunk_sectors from stacked dev stripe size
Date: Thu,  3 Jul 2025 11:46:08 +0000
Message-ID: <20250703114613.9124-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0215.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::22) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH3PPF262994532:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b8cc504-39eb-46a4-de69-08ddba274239
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4h9Z4lzJptpFf27DdddQquuvEf96zNKFtFIFiz6HgVNrPCQmxnmUlKU9IQm3?=
 =?us-ascii?Q?KiUBW87KuQd2Nw65ckq4t0Zs9RLNmJZ5d0EVjxGtJ9V8L55uYyupbYoY0na+?=
 =?us-ascii?Q?RP5Mfsc+M3gihkzODEsIeZ7gtMU9Jmx96OzqkD7OEBkotJMnhRpqhO7w1GId?=
 =?us-ascii?Q?ltcRuvT/G5uwBuNc+reugh6qXct2y4o2uOAJBJyiJW3GF87QGEGqrZvmKLZC?=
 =?us-ascii?Q?RFhBSo6ALPaKHFml3TUJbd1wwxiU99jztx/bdHC0yLXftV4jOnYwjS/BNmK8?=
 =?us-ascii?Q?SMkhJXiQ3dEl/S9sJxFwvqPxpLBUKgAHgtSDuojziQr73KroUgdH1vqzgjph?=
 =?us-ascii?Q?Di6kIdacbRybAXFjN9fXOj6DhKNy0tUXEevyGJjrLgmsONMPz5RacFkHCwUf?=
 =?us-ascii?Q?H7PdvVr8ewBQrEaCrTRvaEHMrHETJwh+e3pS1hGL8C0OX420m/hsaJZCWVnp?=
 =?us-ascii?Q?EvKzpnm1lRFHlISNEIYPffDB2AOo1AYyOFrHQoe5VnD5MQwMzk7z3Sj3noyx?=
 =?us-ascii?Q?Z+uiExwFRMAqq8zLZtlT/oxfqFBtbrKpOV8oF4YzaR/lQMPiTqdP8K+P1DBk?=
 =?us-ascii?Q?18pQjzcOYkDYhrEaXSMalVvOKBvxZ+XvnBTYzrefOKG5jEBxjOAXrtlhrh3W?=
 =?us-ascii?Q?7dgcoClwkdxmCB9IAHFRfmqpICoi94R+U31Hkbybi3w/I8qJonNh3OpqSa2a?=
 =?us-ascii?Q?rpyyrUngUQeKVfEQT/foqL1dlH8mpjFpY0rtiY0qZT0UP0RIwsex1hSeN/FO?=
 =?us-ascii?Q?oSE6Ip1oDe4R/MDVraTHYW4b04riUjdeZAQ96jEb5DoBaZ5rgm6Bou2RJKHz?=
 =?us-ascii?Q?97Rxqs9ez2nG6oj/mKHOFfxs5z2+Cri2d9X8JXjhk3b+twJlFhmDqdX1AlxV?=
 =?us-ascii?Q?VnNUNd1+OJGg7NuW6QDYjnCMTPenPkQmQqz27FBxyutcsKMTm8wAlqnKlBAa?=
 =?us-ascii?Q?8gW3enAh48r+D9IFldePWHESH+PXZTatGWz7x6GQwfcvTGI1bW46edi5wPWn?=
 =?us-ascii?Q?GmWo12aME5dxGoy8DVTPGF92NmgonL7HC7hkBJbQ1Um282Wq0PA8gn7EwSTp?=
 =?us-ascii?Q?fT6D3qVg4YAwXFYDcUwKYGNVnbFZV1QyyXDR33KCMrZvOh56KZH8Cd/RHvF/?=
 =?us-ascii?Q?w7AT5i2MiWIHOK6RpiTO0hCmnWBj74rqYzKskOl0waXkP7ugGF3wNz2jQWFQ?=
 =?us-ascii?Q?W62fh1/Rj52Qbr+VAgLJMRZQEgqvyQYrgJ7daecKlVSrDxS9fIVmX3GDRVOJ?=
 =?us-ascii?Q?/EObDoABUwk9QhsJc+UtE/HqZYu4MiEZz7HJfAlIgFuWIr8QJFS9Y2bqCYOt?=
 =?us-ascii?Q?gi+LD2ZZVWc95U+o8UJ4yWiYV9GCK3QQkoASmASIuH01nHLekUxtxG67cX7/?=
 =?us-ascii?Q?ZvLSLe0JUDTMm9BHpm7R6KdVLkb0SUTqnq8BK8sIKUDHhYG5xNtjLnYs1saP?=
 =?us-ascii?Q?pBJgty2SXAg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Vu0nPCVB5ob1ZHqt3zUHOt3y/zl2KITlfDlpVfyyxIby569As2fycqtthRMC?=
 =?us-ascii?Q?oxkV0XCXbq2BzdiGbqqp1swNRxFHDtCFb7gVdG6uQuTNeWQSoQGgGVYKeUhb?=
 =?us-ascii?Q?7SUf4/SzfWFjq9DZcFV95j8y2vkWAMq/WARLg31oFuajvAICr9AOURVF7uc+?=
 =?us-ascii?Q?69Wj8T3/PkitcTewLZB340FjYwz7UPsEr5aVgVwHlOLSv6BXiDAFBNMbnYgq?=
 =?us-ascii?Q?BJbF76VdTbZCzAFl5BdNlxm9c4upfFUk53ex/BfoiX0yYK2Y/Q6oIjSEaJyB?=
 =?us-ascii?Q?lbyZxUPK3gNyjJqipbs0Rx0A/vBZMe47OzeNeSmP0AISc17wfB2k1G4cpD5P?=
 =?us-ascii?Q?FIYt3Act/pEtwaV73qXZ26rSuKkdHseUl4BrIALMOet7T9ifRJz/rvapAx5k?=
 =?us-ascii?Q?j45wgJzrG+vm/DJGbpbiGG107YIdY6y3mlf2M8AdlFGJA0ZVqzt7744mxGq6?=
 =?us-ascii?Q?CYu7umGspPGA+EHeZrijLVoii6Zaor7HcKaORYYaTRjEOxdgqWZQdvAM3P1p?=
 =?us-ascii?Q?oC5oZVM7ZKQg79JnSm/JY1fKfWFfVzwTZ73UKOE/4fKuKHzk3YsniwMlRTI8?=
 =?us-ascii?Q?x32esEgWDCBC5d95EuF6BR9yd9XMXF4wbvOAOR8xFsnA4DuLwRW9wlMZVQS4?=
 =?us-ascii?Q?hA4aaKlSdUvSMGaIzHlQuYRpxy3HDNChBOk1rx3FkQbOtINcbaQwdbbgaABQ?=
 =?us-ascii?Q?10sA6HmyyJ07vhegJkoISeaUq+Z/6Rti0Tt0Hbj6H0gky829MqfOe3/Ek/xL?=
 =?us-ascii?Q?U+SxLwxl9fmGN8jW+EqITSgFYVmznplMzj/X/kOYkOYh6RcPAgMKOYxVtQ35?=
 =?us-ascii?Q?fogk3sQZ+F/Ox5s6WVhr/VbiBrFMY56zubJybl+O9gR9+IrPAK3UkJefl/3t?=
 =?us-ascii?Q?5FWI3+Ks/ECUKPWegDfrfqkZBOEw7dOGDd4kzv/qpgPQGbx+VXAM/Ikda7PC?=
 =?us-ascii?Q?xyhmEtYt/bC29WxFaQmp5gfkKxSGbFmPCVe2Yz7qpwhzdWbsqegOI/DlYrn9?=
 =?us-ascii?Q?agkkQ7EaGazge03v4dO51N4lhaIes5t64ticpZ9A6BEEYTpAaF295GHxDte0?=
 =?us-ascii?Q?jLm+AyYPO3fDVOkdOJ0Fe2Z0zcbrnPG0W7gJjB8YoHArk2qZBsAKRvo9lQ5F?=
 =?us-ascii?Q?Wn89yEbdI0g/Xv0aevXG9aVYiv+zoZYQqnPD2h1UZ3zB4JonktFmdft9Z+bd?=
 =?us-ascii?Q?U7eGLTVoookGqhmHriOG+tw8gtBcD8CMXaV2XpqyVTRROu2bkwplLa3Cpt0a?=
 =?us-ascii?Q?RSCF0IvUZaAgW4MOOOMBWLsdjBiIX4osDuSlDjFKhycUDVYiAsowXS8alaAF?=
 =?us-ascii?Q?lXl+9jyGNkLISi0+hEY93fgz7TaGhCUQxukY+jTSo21WNPTcmWpv2xXiktU7?=
 =?us-ascii?Q?NuEugE8JjA43D9rBWFZABL7PS0Mdqnpp+RxEmhm9HJRo8KT1Oc1Xaxlp74aC?=
 =?us-ascii?Q?+00EVAPSpgdrTNGzpJLrO8EFrbSnILF5EvPHRC/sAXP6LNBvr/b+nRB1iQfd?=
 =?us-ascii?Q?LnXhwbYSzn5XSmuRGAY8wtHEJjihvYQ7o9SKyoKcQ8MRr2bwlF7VoB9lR/kP?=
 =?us-ascii?Q?99l/cr97rqinQxEvtVqgZTwG+TgOQJ5tnLWuGMTj4CIwse9JMXjptsMZbg2m?=
 =?us-ascii?Q?pQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hQE61Wif3IKi7MBHf6r8lGDUncH5VbqJLSRIsu8UNDseM97Dt/8hAoSiksaxofzI+aq4ADVmBq+9pjVReac4xBQC7/Sn/7JuhEaeE8osBmJl/EM7yyKFL6YSSsy8AicW1chTcZsmPrvMb4CCg81usTUGr8tO6p1GvKBRGnZ9WuER5OIqqQ8SpX/CoeGs2s43HKUqJfEu2uVDs8LqIp3kha5r2L3mwPwBCKuX4uMszvHU5aIWA+1SckYN3PCLRVFW1S2npYJrXDuqZ12s4R0m3l0ChcFw3l1fol7Bzr9tPpGqTo02Ql0VZtXVhe3piig3rZdxQWU4lk/uMM5UfB/v9Iqky0dqcbssJGBDCaSVWb9lwM4pIU7+nvBvELMgrDQGGUk2/4ySsQA0cf9oUMjIcqMRi1dJxx8p/yz3/hoU0pPP96/aV2Sz3LJef6ywDkf3pg6xXTjKE4uaBTx7nEShHKk2zijaWZbL5NZfyewvv1KrpsjT0O+EKGEVtnuTXOHpTfvcYtom5bthApmap0MnvlclSwHM13EKzIMlQuoWeWlidCqUFAGdAjwnixBmvAR8420J48ivZjG6H5JnrEkccIN7u8wYCr0djOvm4Fo0SOY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b8cc504-39eb-46a4-de69-08ddba274239
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2025 11:46:33.5591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MEL63/hPUAQn2TPjg+bYPC0mENHXrVPsTHGqhS+Vv/lBSIKEZrD/sufn7SbZilttE4ASDq4Pj+NQGO47ZQjZIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF262994532
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-03_03,2025-07-02_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507030097
X-Proofpoint-GUID: B8fmzvBanUaM3Nv7YqHidXDkFBl6GmzL
X-Proofpoint-ORIG-GUID: B8fmzvBanUaM3Nv7YqHidXDkFBl6GmzL
X-Authority-Analysis: v=2.4 cv=b82y4sGx c=1 sm=1 tr=0 ts=68666d9e cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=U5J2MVZqgsNsGrsRRvEA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAzMDA5OCBTYWx0ZWRfX6eZFMR78gxlK BG8gusui1Zg6Qaa2TikRyDUvR4KjcE3LoMvZ3XypqhfM9mL9dm1L4PwGdghAeKtIv7y2Gaau6XY mfF39uyOPnZRdLxIywYAtprNvSSglWl6bxck8Avb0Zb5iaDaBoelESoK40eajcD6iBz7cMFHHDe
 q54BbIu3YdoxD/1W8dO7xlK6uw7TrVJkc6z+zHZ7u6lr6SzZY74IZXsxbuLBfLe442Lnpl5ZlKu chkbxEa9FerO4Udvzr6T3cKj+03cf3L/kczOAKE3qRXmZ2fDsbDAOt+C2K5RIRfwqGNfAZwELvH 0ZPPURE2EuKCIaTuQsB4YjyY+PgYeLcgi3uVDt5gySfXNF+E8Jt0NYoPPDt2SBZDMyEnCUrv9kC
 aznDjcUWstr8bOh8AcvIoCs+r8BwgiPddmzDKuf68bJbDKJAy4jhA1x+qtDHFCUe9btjCxCp

This value in io_min is used to configure any atomic write limit for the
stacked device. The idea is that the atomic write unit max is a
power-of-2 factor of the stripe size, and the stripe size is available
in io_min.

Using io_min causes issues, as:
a. it may be mutated
b. the check for io_min being set for determining if we are dealing with
a striped device is hard to get right, as reported in [0].

This series now sets chunk_sectors limit to share stripe size.

[0] https://lore.kernel.org/linux-block/888f3b1d-7817-4007-b3b3-1a2ea04df771@linux.ibm.com/T/#mecca17129f72811137d3c2f1e477634e77f06781

Based on 0d519bb0de3b ("brd: fix sleeping function called from invalid
context in brd_insert_page()")

This series fixes issues for v6.16, but it's prob better to have this in
v6.17 at this stage.

Differences to v2:
- Add RB tags (thanks!)

Differences to RFC:
- sanitize chunk_sectors for atomic write limits
- set chunk_sectors in stripe_io_hints()

John Garry (5):
  block: sanitize chunk_sectors for atomic write limits
  md/raid0: set chunk_sectors limit
  md/raid10: set chunk_sectors limit
  dm-stripe: limit chunk_sectors to the stripe size
  block: use chunk_sectors when evaluating stacked atomic write limits

 block/blk-settings.c   | 60 ++++++++++++++++++++++++++----------------
 drivers/md/dm-stripe.c |  1 +
 drivers/md/raid0.c     |  1 +
 drivers/md/raid10.c    |  1 +
 4 files changed, 40 insertions(+), 23 deletions(-)

-- 
2.43.5

