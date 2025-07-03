Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0EC1F16B
	for <dm-devel@lists.linux.dev>; Thu,  3 Jul 2025 14:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751552335; cv=fail; b=YLBbaFwTyrv352wJGge1lAjpxLU3A65Ax5XLTqH8RJJP/XcJBkA2yRnMIdHFJi+OGuGgNE82TjL09e2BR1yIwLTAaUf42aER5+ILQF15RoMZtUJx+zYxnbYS9GjTfiGbAUMWndFTCVNSZAGAO5BZ1RDNeA69c1XNNmaSN55PJh4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751552335; c=relaxed/simple;
	bh=q/cqjbxULOib13bRfIR/vRF4c4I9GYhSa9ZGbwUiGAY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eprNKODmA0PhNej5gckj1pZSqd2WoQlJqVmVhDQW/89pd3TmeH6JiQTzktoK/ASgXtSphS/+l3lJSIVgv8o77mb/mBDodtCxeMxXgua1dQIE6PzvO+verIHOWqod3Sq+w+MavMSyrWDkL5IBWSwVT8hlhK+OxK/0Z9KjA0LQBs0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lBJDDEGc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CU/7ajOa; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lBJDDEGc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CU/7ajOa"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 563DZ5Me002392;
	Thu, 3 Jul 2025 14:18:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HhC8t3rjrdQBMcd7jRKokAmVuY1laHtkvm+kdzID2hI=; b=
	lBJDDEGc4Fc0gls7cta99vGYK7NxFHYVx3tavemaMTwrID1yTZ8x1qEYo177vnYg
	UZm6lmft+/Nst3LDXv/mdzHwujSnlY+9kanEdUopSIFQXbdNCSMRDriXvx4XkRiN
	OLCYe98Rr++ffLFowFde+M6YAJPwD2+PY1n5pLjz4ujeKwGkm6khym62sl+ZdwYh
	UKwMb0qKIZ7EslUBTnhd/+yx5+2x6gPaV1dELuVpbQLDk8dA/QeoTI1mZ3Km60N9
	GfBkXrVt1Nd7GPrrexSXlG6KtQz7WluIeUAILfhbo0z0x2Tr11N8Glok6OXoqyhU
	Uj3Ft7LcpV32Cn4iEDb11A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47jum80c9u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Jul 2025 14:18:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 563DbDMW018716;
	Thu, 3 Jul 2025 14:18:27 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47j6ucp6m9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Jul 2025 14:18:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m3v9kvxb/EgRMSK670NFpDmmmZ2h+kOg0dxrYU+5/Sm5RFo1pQT/SQO+N8RESKyhwGDpcPZ4XCzBuEfIeHhymmUnZe3I88kNGQQTxLl/1jPAH7girczdFPxJugey+wQxI5KOv9d1FcwmynXFVrIGxI4RLigL6z6USzngCmzYFwU3Ra9ILHE9j5XQoStvvjADisQIewL09tbHwiKmTB1k+5GDr2tVaI9rXo3BaUPbQM5BKbJUA7D5+AuzrwJRYCuhWa5LAcg6GB8vXwdznR4tU1izdDo8AZ/7jc61VmCtpgnGh3LzBleG46B07WnL2ger7Xm3Ldb+1sz2kVGFNjGz4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HhC8t3rjrdQBMcd7jRKokAmVuY1laHtkvm+kdzID2hI=;
 b=lZ4m7JVYw0mqBKB/6bOHUYIBYWQZVbP9isDrkoaLFaC9H4mplB/U4CGz6NgdI5jWvehxuFmoA0RcT6hUMxNvChXPOQXaVRpq9wXEmx/oh9/JRyy+utrMeDPyjRFlCp9sPfzzSX0G6pz6HEq8rmMR8ZPE9cHBcOmOfBCPlquUpCzv6IqAU5FZJJA9cvCd4Bb6+ekb4Qiw2R23x9cGihLJlCOOBfa548Kep3bptlrNPcJn2kBKwGgaClTKUEHVSuIVxPUyY/BKbAdCEnYdKABnggNQMDDQ+FQWiCgUSKmiklPuvnAxMDuaEW8OJOQxvbO2B7zNp+kAXEu75mF3sl1Ntg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HhC8t3rjrdQBMcd7jRKokAmVuY1laHtkvm+kdzID2hI=;
 b=CU/7ajOasXy+RC1bdZtK9Z0N2r/O5TKRnLSBQ3ZKflGt1Ersfw1l+G3epWzeVYp2Ox936aGfizyCHtC2rf+5mHICmMDP9WU3GcmiSd33O+yCCJZ/MZoj8FBIM76dTiAaui3bbkzxzwfygEKI3TPvZ3iKTjBaYaLLf4WknPt2jJQ=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DS0PR10MB6726.namprd10.prod.outlook.com (2603:10b6:8:139::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Thu, 3 Jul
 2025 14:18:02 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8880.027; Thu, 3 Jul 2025
 14:18:01 +0000
Message-ID: <f7f342de-1087-47f6-a0c1-e41574abe985@oracle.com>
Date: Thu, 3 Jul 2025 15:17:58 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/5] block: use chunk_sectors when evaluating stacked
 atomic write limits
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com
References: <20250703114613.9124-1-john.g.garry@oracle.com>
 <20250703114613.9124-6-john.g.garry@oracle.com>
 <b7bd63a0-7aa6-2fb3-0a2b-23285b9fc5fc@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <b7bd63a0-7aa6-2fb3-0a2b-23285b9fc5fc@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR03CA0108.eurprd03.prod.outlook.com
 (2603:10a6:208:69::49) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DS0PR10MB6726:EE_
X-MS-Office365-Filtering-Correlation-Id: 046c53d9-e0a3-4306-e423-08ddba3c6af2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SlVsRWI5SDdHemtmb2dMYkNQblYySlNBRDhtT2tLSzUyMzk1MCt3VkIvdU1G?=
 =?utf-8?B?cVdQbGJyUWZZdXpUdGVSM0pOVVR6bDhZVWk0TFY3R01sR3U3M2svZmlDdDZ0?=
 =?utf-8?B?b2piVzdDK3h4SElLR0FjY1lmWVNOaDJ3MWJ3MjNyN3FJbWl6MEtXeVp4V0Fj?=
 =?utf-8?B?VEQraWduYWFxOVNMR082RGFNRUxsQmREVkRhV1ltdTZNai9UeE9JSkR6ait6?=
 =?utf-8?B?Y1YzeklkekxBMkRHVkVNa2Q2OXpGSnBqM2tFQk5kTUQ0eTZUOFJJWXI0cU51?=
 =?utf-8?B?MmdkOUJHcjF5d0NOcS94ZXlNVFdNbmFKQlp4YTRKcG9wMG5Lck5GbE5lZlVz?=
 =?utf-8?B?b3JYSXh2YXl0ZkJsajZlVm1oa1pzUjJ1OHdJK0hRaVNkdG43aXlXMlB5V2xC?=
 =?utf-8?B?YUc1U0dJOW50K2hvTHBqQ2MydmpRUXRRbzVPR1piZTlIdG1FSlhxRW9TUlda?=
 =?utf-8?B?cUdvbmJRK1NEbFp0V0YrTzBjZW5kUGptdmtyaWZwV2pMT2thcnl4NjRvbi9n?=
 =?utf-8?B?Q29KRENpM1drbkhlcCtzUzVNa0lEVHFkYTd3UFZlcWN3Mk14Nkk4WndNMysv?=
 =?utf-8?B?TURGOWxtRGVyTHkzUmhnR3RnL1JJTEdJY0Y1Ym5mcEl1dGZFeVFBVThVa1hC?=
 =?utf-8?B?K1BuQmlFWGdZVkoxYnJkWHJ6QnVNRGcyeFg1enZYVlhGUFVGMnRPOURHZGh1?=
 =?utf-8?B?bHZseXl6R0VYT2tiNjZZbVlkakdKSUhhN3pLVXhkcVg1bkdzTTNPeEdraURJ?=
 =?utf-8?B?VE9UMVdDSHRCOWo5bGl0ay9jZDJlczRUdlMvaFlOVnhCZ2gxMW95bk9PelYr?=
 =?utf-8?B?R09OOEtURUtKRTlONmZUcUFxQ3Z2UjFuaEwwTXpCYnVaK09RMmRWU2YvMXdn?=
 =?utf-8?B?bmJRbUpyQVJiV1I3TVlna0JKbXI4UHRQZ0Z2REhNZU1vcTlXZ2h5VlVpMWRi?=
 =?utf-8?B?dERMdlJJcU1LTWEvYVdHVkVMc1N1MEVFaGt6TTFtRWt3d0hZQjhqYUZHQVdK?=
 =?utf-8?B?b1NURW00VzJmR2o4dlNucVlEZTZHZG5BbWc1RURGSXFXaEo1eGZLbVBxSVZp?=
 =?utf-8?B?cmVTSFlFZ2M5di9VcU5zbWNLNHNiZXdzM0F4Y04vaGhKOGc1Wkp6RzRidXhG?=
 =?utf-8?B?SWx0dGF6YlpnVkhaUnNqQVZGMW1PaXgrS0lDWGs3SVBQeHZZcmN2SUE5RnBH?=
 =?utf-8?B?N3luSXQxY1BPVmNKMGV0dXhvQm9jSktjdHdVNEdCdnJIckl1RkFEc2xSZjZ5?=
 =?utf-8?B?SXprUVlaaFRlQjR6U0F1dnZIbWRQbUNTQWNGY1dIb0gzampCRUZXaGN3bDMy?=
 =?utf-8?B?NW1sZE5WSmJQQlYya0I3WUxPVXU1R2czNWUzcEE3L1RzcjlJOWd6aFBpak4r?=
 =?utf-8?B?WDE1dHdZZUJhOHVkL1NQa2R5YmFSQXkxS2tJTUlja3V0cWxiRmR4QUNiWmVn?=
 =?utf-8?B?RG1SL0prVUpMMDRuWUVlb2hya1ZEYlllY0ZxUXBTdFNHY2NTbDk1YU90bkta?=
 =?utf-8?B?ejN2UGNyaDFqN2JRSnZaQ2lTdjk1NnFkU0hubThqOVZPaXBoYlNobVJXOXpt?=
 =?utf-8?B?Z1hXVzduVlJQaUtNVmxmaDFJSVpGcWo3MiticHBWcXdBRzVONFpENG1jd1N0?=
 =?utf-8?B?VmUyWG9WTjJwU1pML3pNSkk3Q1RZT0tmUElHbFd4RUxWUk5LY2wzdng3bG9P?=
 =?utf-8?B?anJsaG9XMUxjeStwRXJVdlB6ZnpRSHBtSlhuTXZqMnlZTHM2Ym5tbnM2TVlY?=
 =?utf-8?B?TWxBckcxcWpyQzJYekk0WW1sdXNDUGRXWDdGeWdRQXRNa2poekdzYjlmYzl4?=
 =?utf-8?B?OC9xektvNS9XOGkxdEQxZ1VMc0pKWDhpMmQzV3VEZ01IOEFWK1RNL2IrTVlO?=
 =?utf-8?Q?yg96tuYkan3os?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M3Q0bk5CNVpYanN1eDZLR1drczNQMVpBOFFXY3B0YW05eVNFdkdVRXhnMHlY?=
 =?utf-8?B?aXBUSUtDb0FiVCs2L25mbUs4a1NzOTl0dS9tT3pMY0RPNXBBcWRzeWJKd1Fl?=
 =?utf-8?B?UHBYaisxN0ZHODF0clNDRnlEcXMvbVNvY2NpQUVOZDZOeE5lckZneUp6Kzlt?=
 =?utf-8?B?bmxMNVFRWmdINUxSZkUyaEo1REppZzkzRHU3MHFwdXZtbklqbzRFaXdWZENk?=
 =?utf-8?B?S1VkNm9YdDlmZ1Nrb1pWZ2xZV0F5UklVNWJST0o2TStiN1JnbG5nbk5uNkE1?=
 =?utf-8?B?cHJVWTdxUXBCUkdXVnZtTTQreUdTYU5QTDRveUYwbmhsUGdPR2tyVnlwVTln?=
 =?utf-8?B?Q1B1NEJ6V3lkZ1hLZkZoNkxZS0lnSmpLMDRxQmZ1T09lMHhNa0FCTW9OVDVB?=
 =?utf-8?B?SW9QdzkvOURuMmk0Yk40QnlHSzkyd0FocHFqOXc2dzFrN3M2ZTRVeXRKb3BU?=
 =?utf-8?B?dnEzeEZ2WXZ1UzB0MHRVVDRUenU2TnFHc2prWWdISXRHMmZoak9ONGxhamRt?=
 =?utf-8?B?MEZEbXpXQVlvdVFUZ25HdFliemRwTWQwSTQ5NUlOYWhSUUh4ZVUwN1NWWDZM?=
 =?utf-8?B?R3FJbVZXQ0l1dmd4MXRSV1Nld1lVdjV5UyszQ2dPdHpSMlZseUxvSDhXR3pz?=
 =?utf-8?B?WXArelpqeTg2OGxuR1F2MkxmRllEcUJzUy9zTHgzanM2ZXo2Vmd6Tzl4cU1z?=
 =?utf-8?B?MjlJSUZzZnlUWUJZV2RDQU5COUNCQzlhdHdUSldWbk1MQXRiUlc1RGhMZjJQ?=
 =?utf-8?B?R1hnUW5XbDl5cmNBa3BOZktYOHczcnY0Z2d3Z2NucW93SndDRGZvQTYxSVFK?=
 =?utf-8?B?cEFGcE55QnFNMXVzV0RmMXBQNXo3dlA3T1podzBFTnJCdlZiLzl0RHRUckdG?=
 =?utf-8?B?a01ZdUhyTVRrTTN5ZmRUdWNrTWc2ZC9tWllsNEJmUzRaMXd3Q2lnazF0KzZz?=
 =?utf-8?B?RU9tV0JMYzZFMlBFUEhGNG9oL3E1MmNtTEY2UHNYYWZYZGpOTkt6NExza2dl?=
 =?utf-8?B?VTlkVFF4OW56dG9NNjZaalh0R0JETVBXUGM2VnpxS0dUb2VjYW5LNzYzRVpT?=
 =?utf-8?B?Nzd4ejgrZmJ1MzlhMUxKbnIxVkJlcTBMYkgrNnFuNXllVnNyaTU1WEZJTVMr?=
 =?utf-8?B?KzhCa1JGWWE2SGxTMUd6bVFEQ1haejBrdGtBWUF1UXhKcDhlYWRLUmIzS01L?=
 =?utf-8?B?WEw5SzdYSklyYUlvRXhxcExYL0t2cWpDTFFwYTlCT0hreHkvc25WditKRFBU?=
 =?utf-8?B?NUcybUFiRW9PVWZZdWU3ZSt1S0dDbzhSaWZwY1hCcGl5UVVOc0JuYi9sbWdX?=
 =?utf-8?B?MU1XUEh3YXRLVG5CRzlEaktFT2doMW94SDdJUEpTcytoS1F2NFBVT0pxVGp0?=
 =?utf-8?B?ZDVPTjV0VmdXYXZQQUx3cWQ0NUpyWiszYldVeS9uelNKL2tFbERMR0RKaFVY?=
 =?utf-8?B?VU1ZMGE3Uy90UDNzcEN6U3d1VUNVcFg0eTh0UmYrc0l2TXBtREpxcDFjUUdB?=
 =?utf-8?B?RHFqbzdjcVRrRTZvRG0rQyt0TDJOMUpDdS9hVjl0VTlDMTQrWmhseU9rcXhh?=
 =?utf-8?B?N1VjM3pFMURQcjgxQ01CSEd0L2E3L1pibFcweTVhUG11cHQ5Rm5oRTdhZnQ2?=
 =?utf-8?B?Wng2QVN3a2oxanAvbUFpQTBCY2dGQUROckxVeGpndk9GUGxYNjdiOVFZL2xa?=
 =?utf-8?B?Y095M0pqTmdHYTMzYnJYYlhybkpnbC8rTFRyM3dnMVhWNmY2aEZNV3hxVkda?=
 =?utf-8?B?c0YzUnN0anpTcFJDcnh1SzFmUFJ2ZUJmankzK0tKWU1JU0c5MXJmbk9jWHB6?=
 =?utf-8?B?eTlPNzBHQ3FZQnRCRnIzSFJuNlQwcnlUVm9IUHRDSTU4WnZKYW40Q3VIcFRu?=
 =?utf-8?B?NnNlUnVvcGNvQVJkSnF4SFlDdDRSRXVFeWIxMVQyVG5vNDVLc1JKMjVHS0tQ?=
 =?utf-8?B?NjBZVlQweWdTa253UkxzbEpaZUFvTGFpV3FybHJtUGdleTNTNStpbWZBY2lp?=
 =?utf-8?B?YVEvVmRlNnFid2hNNTRuclZWbEdjeG13cXpJbldyOW8yNTZHaWlBT21UZFZU?=
 =?utf-8?B?RmlUZzQ5bGMzb2YrdGw2UmlnUU1ZeWpGbkZLWGR2YlpEY2F3dXBFSUtTUzVH?=
 =?utf-8?B?TWJpQkF4Tis5NjRSQmxKMjFRMm92T3FEcEwrTW1TU2dnN1pHeXY2ZGFGVWNQ?=
 =?utf-8?B?ZkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2HcsPNX9rKy+luc05hrAqZ9Nv8ptY3uu617S7lr8RQS3FeZelWtJbJh843chp09hZCmwgMhYmnw9hr3L7XpRU4AwkgYZ9r0ou5YgAQX60tqBELGTLvJTJ4OOa2qUKb8LrMFxqUNd2WLLkBk8iE7eTw+/+Iym/IsJf2izF0mdzgHqd7s7T85BxfR15NXUHdgSz5xCtNkVGni1w8RYSbl7b8s2ymf+SGDg6HbuGFYlEhT8Plkr1CVIzlVlGkaWZDu9lLQOJgSaFZrmaZ45jY2Or6yqCkaLroufMXhl0YhtCxjLRbHNYd2bEbKRxBF7FrCqyNbcwXLMhctTebR0zRQb5y724DGHt6jd7wq2G2F5uSTQG3dn9fc5fit/sHYDBgzYtA9uibGSPvQDQmwnGuUe3ma1BgisUQyo8ClqAzCn6yQfS0RevVTTFdqtor/ThMHRfr28ovjEH7r7FLiZBQsyQn6FmFQHWzS+gbTfQlFimR2m0iGQUN37hruvWbdDK3ZgUzjrJmCwOGL/UJlspPwAFxdEOpkhwEhkVvk0+IDO37sn6MoCGQPsWLlQU6vu6ILFG4IEzjrb1NeOFqoufKSszq9+i550DJT8WERN18eQqNU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 046c53d9-e0a3-4306-e423-08ddba3c6af2
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2025 14:18:01.4501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tq/k6zCCOT+Wbj3w3YfoCYDSaXq+apIma/Qx8zb8ntlkXZwl4knu+CbT5Ao30GVXhx6XifP+dC3tfS2wJWOPWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6726
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-03_04,2025-07-02_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507030121
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAzMDEyMCBTYWx0ZWRfXxLWdZnOUzYuq 5pdonRoWQdRlQ1E0irsuCb5/6hS9jmi3ODhUt3FdqEMSMmV4I0Zg4A/Kt48sEZ5MmO5x0wipgME 9GJTSjPdbCBITUC97CILa7Rc/8BCpO1xbYkSeI7zQYV7GdT1RZxyj4jGHkN2OERt67mmOUJbXkV
 haOdWWEfAra+Lc/Pltyx9M27VjDW3LiCVqMUq9y6OMgl37Q1x3Yo0NsrHfvHnXubFxjzAs2DEuF 6P+b6CRu9w1phsph1U/Oy9nDWUp9CiZmvb5OjXAIViIkCOuF5Ir4+uoisHSJiVUh2u+WbLU0Jla qMWfw+Vrz6aOVgwsgtJdQtUiseTSzOE4w6uHmQQRj3NV+sABt31Ww5sESuJcIhs8XMSyNMATS2w
 Y+oXnIplSkDtgTv3DynkVAl4NaJesi/gAqOXZA72MN43dEJfsY3S9Yu42T7O+IH8PYSHHO7Z
X-Authority-Analysis: v=2.4 cv=MvBS63ae c=1 sm=1 tr=0 ts=68669134 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8 a=rGA1jo5RF5wQSXN2D2UA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: BivKi8NpLMn9EptE1PIhTMEVqbQhd3ZW
X-Proofpoint-GUID: BivKi8NpLMn9EptE1PIhTMEVqbQhd3ZW

On 03/07/2025 14:31, Mikulas Patocka wrote:
> 
> 
> On Thu, 3 Jul 2025, John Garry wrote:
> 
>> The atomic write unit max value is limited by any stacked device stripe
>> size.
>>
>> It is required that the atomic write unit is a power-of-2 factor of the
>> stripe size.
>>
>> Currently we use io_min limit to hold the stripe size, and check for a
>> io_min <= SECTOR_SIZE when deciding if we have a striped stacked device.
>>
>> Nilay reports that this causes a problem when the physical block size is
>> greater than SECTOR_SIZE [0].
>>
>> Furthermore, io_min may be mutated when stacking devices, and this makes
>> it a poor candidate to hold the stripe size. Such an example (of when
>> io_min may change) would be when the io_min is less than the physical
>> block size.
>>
>> Use chunk_sectors to hold the stripe size, which is more appropriate.
>>
>> [0] https://urldefense.com/v3/__https://lore.kernel.org/linux-block/888f3b1d-7817-4007-b3b3-1a2ea04df771@linux.ibm.com/T/*mecca17129f72811137d3c2f1e477634e77f06781__;Iw!!ACWV5N9M2RV99hQ!OoKnbVR6yxyDj7-7bpZceNOD59hud0wfw_-fZLPgcGi9XdFQyfpfFFmbYzR_HdvM8epaJqe_dCGnIEgDPMze$
>>
>> Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>> ---
>>   block/blk-settings.c | 51 +++++++++++++++++++++++++-------------------
>>   1 file changed, 29 insertions(+), 22 deletions(-)
>>
>> diff --git a/block/blk-settings.c b/block/blk-settings.c
>> index 7ca21fb32598..20d3563f5d3f 100644
>> --- a/block/blk-settings.c
>> +++ b/block/blk-settings.c
>> @@ -596,41 +596,47 @@ static bool blk_stack_atomic_writes_boundary_head(struct queue_limits *t,
>>   	return true;
>>   }
>>   
>> +static inline unsigned int max_pow_of_two_factor(const unsigned int nr)
>> +{
>> +	return 1 << (ffs(nr) - 1);
> 
> This could be changed to "nr & -nr".

Sure, but I doubt if that is a more natural form.

> 
>> +}
>>   
>> -/* Check stacking of first bottom device */
>> -static bool blk_stack_atomic_writes_head(struct queue_limits *t,
>> -				struct queue_limits *b)
>> +static void blk_stack_atomic_writes_chunk_sectors(struct queue_limits *t)
>>   {
>> -	if (b->atomic_write_hw_boundary &&
>> -	    !blk_stack_atomic_writes_boundary_head(t, b))
>> -		return false;
>> +	unsigned int chunk_bytes = t->chunk_sectors << SECTOR_SHIFT;
> 
> What about integer overflow?

I suppose theoretically it could happen, and I'm happy to change.

However there seems to be precedent in assuming it won't:

- in stripe_op_hints(), we hold chunk_size in an unsigned int
- in raid0_set_limits(), we hold mddev->chunk_sectors << 9 in 
lim.io_min, which is an unsigned int type.

Please let me know your thoughts on also changing these sort of 
instances. Is it realistic to expect chunk_bytes > UINT_MAX?

Thanks,
John

