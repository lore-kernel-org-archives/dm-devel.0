Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D5542A96
	for <dm-devel@lists.linux.dev>; Tue,  3 Jun 2025 07:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748937461; cv=fail; b=jr0qJ38iMxEBK/uP9YxXfwf91qk4L348iZ3pTAnE/lT1E98W3xx8CUWGSALkxbnkMAXJVy3oT8OJydST6Z6n4Eq3x4EyOMbCJ83xrYhmVYAlr+N/RQIRYLvH252jd8TgHx5G+8sxtD6rB3Y3Zt7TktR7AWwSJMYq66tV675Vl38=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748937461; c=relaxed/simple;
	bh=wT3gygP28QQTPijGBmcabEuurKTIUthwELutEh75xpg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iANEzlDFyPNH+vvLBGFS/qBYVd0o7WKnE9SE4BnKPQ7fXzqff7FEw6ayus9/d+NwvN2bk49PL8CRB17U3j2qOKIfB3r+dL3gSvELuoPAcmSmmtSaJ/d02cTFgXkmsGcALEi6kOpC3vlLsBeOzJidiKUI0pvjbFYo+fAtNRjnSU8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A73RJpPt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xMa3gEwk; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A73RJpPt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xMa3gEwk"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5537u0Vg017556;
	Tue, 3 Jun 2025 07:57:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=05JVmx5aEBq3b8RsRyQ7CK5vMZLxJERfTEeMv1z7LEw=; b=
	A73RJpPtfRGWpr8Zm7YjuM0b4u2x/Odzm/1+gLhgDxmSz1RrS1geLWegS7hmjYqu
	fn/yE4ZRYAS7y0ihn7xr5M5K02dGLvkyRRqHw/ev7cBcQBXyaG20+3fY//CRc29y
	u+8ci5wZ3xhRU91e3wa1vtPoBdW46HNX87/Mx57JdgsD7Fn1naeMJqSS8Get4XbW
	DmZkmM9YMO39wZj1WqUmzoO+7jIJDhRy9L9PBzcJacn+MgmUD7NlaL21Om7zfipS
	+/3emLP8at1PaBD3dYXQqFFZvZKkNq2irBUUR0H3O0+h2mhktadV51qRv0rGbYvw
	a4VdqxN+hIBC4SM/lZ3p4g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8j1buj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Jun 2025 07:57:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5537ZBEx030611;
	Tue, 3 Jun 2025 07:57:37 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11011001.outbound.protection.outlook.com [40.93.194.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46yr78yqpm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Jun 2025 07:57:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NPgrxBn+hUl0dXYGi+iZrj20e+cpmoAUbLjO0oflB8SmVPcaWtocDkdE6JCqTOZSQ4hVFAEcrvl4zHuGv2cqLrvxgHepuuwzAa6L/qitwKeq+4FJKFvE3a1kVltWJDTwT/Gz2btX6EV8fsBLbZ/CmZyH0bAL+CeaGexlIMU19EJ7LpV5QNcHQKu0bwWyyAoyvJaVfwnr5iMSVkHFd9EVjQ+RaPmsqE7C+uDg1AFb4euD8NWh5GFPHJu71qxru/OlXrK2QbPbt6ojCN3d+UnuteuuDSOBhd7qHwVbBfSaVwkG/V6Npnq4IL8KqYSPkJywGQTMa0PrWJQe6wWYPpUH5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=05JVmx5aEBq3b8RsRyQ7CK5vMZLxJERfTEeMv1z7LEw=;
 b=A51pNeHuosHrhEdACXf949SiNjDrN4jO3io+O9CJjsVFNiJCRedO6v7qlPyOdeo2vYRLZDgd64wZGhSFjk90Kmg0v1r/c8D4XpnazHwQl7aXAjJWOhs6SWbTs9C8E/yNjQUk4hAxD2PrN+0xLHCz/lRUvTLz0CG5ClSJ8dif1EY0t0oG3FGAdQacvrLmQzpqDNTtLrscYeMLYJAkySjgbeewWl38JZvDTfUMpGJrx3j+DrHqMivODvHH7siPVCt/4ZUpNGOoNsx1pKnmKe8pzzjF7S1pR/D+lykPNZhLqe2suxLdjjzSGO9oh3GIM+Y4gfjkj/OKk86ZsfsQcMvluQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=05JVmx5aEBq3b8RsRyQ7CK5vMZLxJERfTEeMv1z7LEw=;
 b=xMa3gEwkWlYmpwVr6IJa9u8AmVPPAjHZmOLKfUWKnm7ZyGkKruoGMfJI6l59/44hGTVAD5rpXnhRzLWoTJojgSCj7+jg/2pKfiCF5oAmHfJl78HzkR87RxJ3wBw/VirCjgIlR9imTI7E55dPJk7L7RcjBsMiKnJ5ZhrthvHyGHo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA0PR10MB7206.namprd10.prod.outlook.com (2603:10b6:208:402::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Tue, 3 Jun
 2025 07:57:35 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8746.041; Tue, 3 Jun 2025
 07:57:35 +0000
Message-ID: <9f8cb209-00c4-4596-b6df-3bf5ed2f1505@oracle.com>
Date: Tue, 3 Jun 2025 08:57:32 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-table: check BLK_FEAT_ATOMIC_WRITES inside limits_lock
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@lists.linux.dev, hch@lst.de
References: <20250530145032.1491277-1-bmarzins@redhat.com>
 <d9d13fea-e75f-4fa4-86c8-dc7053a553b9@oracle.com>
 <aD3QccNaBXLQ2xPP@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aD3QccNaBXLQ2xPP@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0382.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA0PR10MB7206:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ef91eaf-111f-465e-10f9-08dda2744d42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L2ovV3ZtOEZJdmNqV00rTDJ1SW40N3VHd3F5UkR0U1JRTG9uQzUvOUFJaWlq?=
 =?utf-8?B?OHpjS1RHbmFWdFpiRGFZcElrQm45S1I3NVdlclBIcktRTHE5Zlh6bklWcFpo?=
 =?utf-8?B?Y2ZFeEdtMU1ndDFmOFAvMWQzL3RpS0JjSk9ORzlNeFQxSlhwdUlRbGJ1Nk9M?=
 =?utf-8?B?cTVxMEgrS2FwcnZpc2U0eXZCZ3krM0d0TU9IclJ4WDR5NmZ1a2dhUzJjWXR6?=
 =?utf-8?B?ZzYwcGpCUHI0UkcyT3EzanM3b0FMengzY2NiVUxUZFFOT09xZDZoTzJ0dkla?=
 =?utf-8?B?Yy9hWlFXbGZ2S0Y2L2U1WWFtOVg5Q0lYeHlCYkM0cnFueUIxck16Y0JuaWNB?=
 =?utf-8?B?dVM3R3FkWnludU1wZnRGejUzTFJwT0sreUZkbGNXRndJbVMyMHg4VC83OVpy?=
 =?utf-8?B?ZEhOazViRVJNNm05Yi8yYk9xeHpvYjJ4amFLUy92ZXdDQitmd05kME5vcHRi?=
 =?utf-8?B?QmliQzdCUkcyUitxejQwendLbWZ5OEtBRkRZbjc5SnNRSStmajdURnBVeGVL?=
 =?utf-8?B?WEE0MTdUTlJBTm5oM1ZRbkx2LzhRT3pWK3A1ZnFzM2dLNG5UQnV4SDNpdXBj?=
 =?utf-8?B?Q3VlMmZJTTJsWHd1ZjhQUkQ0eWp1Witack84cGNmSmVGRHFrMEVLTzVNR3F6?=
 =?utf-8?B?UXdnbDZ4M1NLWTI0aklWTXhmdjZrdzB2cjBJYzRRSURsa3JJSmZhUDBlZkxK?=
 =?utf-8?B?M0tNWEZDVStEamJHbVloVmZHSDZBRHVQbDlXWHB6SGU5bkMyRXBnQ1Y0NVBJ?=
 =?utf-8?B?cWV4YmtUVXF0MlF3SXFDdG4wdFcwVFdGKzg1V1M5OWZPK3FkTUhTeVg2Nk9l?=
 =?utf-8?B?ZXVGSmk2NFFyYTh3RG9SOHluK3lLdHFrNUI0Y3dpSkFEMjJ6NXpvWCtJTU5W?=
 =?utf-8?B?TXJnRzh3cW5lNkxFLzJYd21FQTBmbmFWTGxIMXBEaGQvdmhRRjRsZWh2eXA3?=
 =?utf-8?B?TCtNcHhnNGZZdjAraXZTSm8xejg5SVZlcGUyRUppeEFCcnVIZ2lucDlJalVT?=
 =?utf-8?B?MWwrNjNEVmltV1VvUDJpVCtRS3pZd1YrdnF2WVJoVTNHZUlQcHlkcWVIZi9m?=
 =?utf-8?B?ejB5bEIzSllOc2lhbEpsWWRrRVpFd1NvNlB4WWVOa2RWYnhCZ1FLdlR4OW0y?=
 =?utf-8?B?ZXdrWVZvNmRpNFNxUExVUmxJR0xGWGd4RGlBR1ZiR1lwaXhycWpyY3BOQkdK?=
 =?utf-8?B?MzRnVG1YWXdTVjV4bS9uckhFR21yNVdYY3Y4S2JtNEJwLzBQREdVb3FYSlZO?=
 =?utf-8?B?M0EvTlZrNjBTN0t0eThsSTVJVGNIUTFqak1kUEg2NittejBwa0I2RU5JYkF0?=
 =?utf-8?B?L1JWekdtOFYzZGpacjk0TVVWeS9SQWh6OSs5V1VpdFdyNWxCSmY4ODNwZlFr?=
 =?utf-8?B?Q1BCL09vbHB5VDdUb3VwdXlCcm04ZmVvZm9xdC8yd0J3TE8ycC91Yk5vREpQ?=
 =?utf-8?B?cjNPT2tUaCtabHFUeW93eldmbnhVWHJrQmFWTFI2dHUvd0lGcGJ6cjd0eXZS?=
 =?utf-8?B?YTVjK3BML2hBN1lTM1VBTHFXaFJhQTNGdE1YZkF6UlV6RGphV1BuR01uVkYy?=
 =?utf-8?B?VzdsMzJXYVFjNmM5Y01FVk1rSGQyVGlIdjByOHN3RlBvMHJwWGd1aW4rWWdL?=
 =?utf-8?B?d2xZbGwrMmVabUZ0b1VibHcxa0orbms1YVY0Nms1MC9HUGpQTStWR201U2xx?=
 =?utf-8?B?TXdhcDI2dm5DVldyV3hDSU10VDVFRTdmZmpobDZYTXE4QXk3eGliai9ZL1Bi?=
 =?utf-8?B?c043SGtTWkhPYnV3WDZseFVXMXJTcjNFRHpkZnhRbGpWdStRcG44cExCVEpQ?=
 =?utf-8?B?V09Cdm54cVlQWDkvM1FsL3dwUlQ0Vk16YURBN28xaXJuOFpFY1N4bWdZLzls?=
 =?utf-8?B?LzdVeXdKTEZHeHduRXlsUFJxUkVHTm9JbVhGLzl3QmloSlR2ZzBDR2lYdVZX?=
 =?utf-8?Q?uhYnr4cZEkw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dS9IdUg3eHI0N1g2VmZJTElLclEralRCRzRZYkVwYmozSzliU2NSY240S2Vn?=
 =?utf-8?B?bmxFbmNaVUMzRE1iVHNwcXZsRHBITGpwZlRVc2owKzJsOWZoR1BUd2lsaW1V?=
 =?utf-8?B?S3pSSmorUXhRbEtQTGpmeUptZ3BGaGJ5cStUQmVhME51OTlvbXVlbnhOejJ2?=
 =?utf-8?B?ODBFUXlCazBLTmtzTUlhcHlaVXJWamhUSFpNaUZsRWlCYVM5N1c5UnM2OTNy?=
 =?utf-8?B?NVp6RFNrMGdJemxJVkUydkh2U05ITkpHRVlBNWNIbzNGZGI5Rmk3VFFtNnA3?=
 =?utf-8?B?SkFxYjVYUEI5aXdMa0djK1NOeHhyODk4TmVGck1nRi81UGduMEl4UElUV1pp?=
 =?utf-8?B?WGNDQ2x1UGxISTErRmF1bnN1TFVoN0FCb1Vld2tkTDZQTFBvbXJqU0VxRk01?=
 =?utf-8?B?VS9hR1lzZ2FJQVdPeVUvb2tsWjNTTUhjNmw2cXhpRDFFTzNBMXdTc20zcmNX?=
 =?utf-8?B?bmxEZHAzR2pPSEsvaUw1VUNnWEk3bkxNNEVuVlQrbXFUbFIyTE5MUEJoaGJR?=
 =?utf-8?B?R1NlZzNhdTFnOFFodEk3ODQreFBUcEx0WDVxcHFBS09XcDE3TmMzQWZralhB?=
 =?utf-8?B?NVNEdUNRYURIUG9XK3QxbVpxMXdqT21Fa1lMUzVJbEJyRTJRT2M3TzB3YWtE?=
 =?utf-8?B?dEE1SGJINFpyU212QkRrenQvK0hJY2dpYnJJcVNzNnVOTmdYQWt1cDVtUksx?=
 =?utf-8?B?WFN6Tm0zSnowR3VFWktsUGw1ZlZCTkxtMkhCMzVEbTlGQWRGMFM3MVFjN3VO?=
 =?utf-8?B?d2VHTVdGWEJSdE9nd21KZlRKZ0c1elczNDV6VCtra1NkV2xySG00Q1VVeWpM?=
 =?utf-8?B?UytvLzVXR20veGMra1RoVHF6Yld1WWZYaWJpMU5IY2lidGZvU3gzZ3ExSjB6?=
 =?utf-8?B?RVhNc3crYjhNQng2NnhxTWFVMHlITjJYQUMxaGhSWDQ1SzZYbm5GZVNKSHJF?=
 =?utf-8?B?WHRtTTdsd2Fta3piNXVoZGdURjVHVSt3dXBQbmdsWDJyeXlBdmFtSlZnV2Nx?=
 =?utf-8?B?K2p2NzhONWhwS3FBK2VhUTAvOFN1SDdJcGI2YmVORjBVZ1BVSklsVjlrTXo0?=
 =?utf-8?B?ZFZsVlBzOFVMUGFXY2FUZGUvK1RjeHhJUXliSGluekpxQzBiamtUNjZDam54?=
 =?utf-8?B?V1d2L25hVmtramFzSndQK1NPWDBMaW1oT3c1K1BXVk9yTlJJK2ZtYmJLaExz?=
 =?utf-8?B?UzVKdFBwQVBMMFZaSEJ1azN1TE44Mk5LZFZha0QwbENHNy9sMUl0UiswcHE0?=
 =?utf-8?B?c1Z2Qi9RTXZxNGU3eXhkczBsbFNlMVNsME15b1Q1TkxQdlBmbUUrMHRjdWxT?=
 =?utf-8?B?ZXJyT3FUM0ZPajBrMVgzanZiL0FtemNvYnBKS3liejlBeGhwZ2hKOFRBQkE0?=
 =?utf-8?B?bGdDTUNrdC9GUXJ3dG5Ra2NvNytOaTBZMDFEWU45YjBhMUhiS3hlMU8weWFR?=
 =?utf-8?B?R1NUNjRzVHZEY09wQWJYMlZJenB4T3I1ekRMdTNYdjNIZGdHVlhjQzJ1OXBB?=
 =?utf-8?B?Wk1oTTVGMk5SbjVSeXI4Q3UvOXJXL3VRTnVwemNBcjNxTzNoT3NJMzJ6R0RT?=
 =?utf-8?B?TEo2enB6SitxcmpTT3l4YS8zT1I3OVlvWVp0RUlxTW43VUt5MEpIaHlDdlVQ?=
 =?utf-8?B?ZVNmS3ZNajBkeW9xNktWRmtlbytTRzQ0aXcyaXdMUUwxK1FrakY3VFRmTUZs?=
 =?utf-8?B?NDJkRVI1SzRZQ2pEWXhXcUhOZ1JnWGZpemJOYTd4OXMvK1NwbC9tQjU1aDBH?=
 =?utf-8?B?R0ZMTkVsRFVuNnYxZzZBZXdkU1RFU2hPSFAvdWpPRzVPZlBHb0tvbFI2YVpU?=
 =?utf-8?B?WTVHelcvMGw3MkFOZlBBSDlnZzk0aU9kaXRybmUvK211R3ZwaVpocytCU1I5?=
 =?utf-8?B?UHhteWhLMHlNbHVabDBvckwxU2NUTWd0azExbzYyZ3BFL0h4M0R3RTYyUFlt?=
 =?utf-8?B?Uk51cnBYL0tmR044T3VTcFFkenI3VUJzSXRGcWRoWFlHQ1pmUXRvdm1UcUh1?=
 =?utf-8?B?Zk1CbFREQ2poNWdFK2NlR0FxWGJKQXN2L21saW1FK0hKb1ZhaUEvM0d5a0Jn?=
 =?utf-8?B?T0pHWjcwZVNuTlpnK05SUDNKck5pYi9oT2JXaXo0T2tJZWoxY01OeG1DSjd1?=
 =?utf-8?Q?N6Q7HYYXt5jf9eRV7Iy6Wy+DT?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WWuN1bJCTu2PQKxojTLClNYeVtndgGR8o7avvJpvM+wkUN0OFvPVrmtv3Rg8rNXoFzvfqO/yK21qnuwV4soj+nDYAdnthtjlH7qejSXYu/OwZbljKxcYUIni6Bc2ROHdjjTtUJf+LgxqcU0IPQkHxIjkmYlTzKETQAJwBeVPXjDkf7VXHw6o/1AL9e6kZR7df9qsU419VdlfeK7dlwKAoDKZ0ydY/15fLGQlIt1OxyRJkD2D82hW2+wvpbneCmaV4zW/EyTgWDumTdd2u6IZoA9In+XExYVV26KPWLQ2JK7ivG1yXEdfIVfOLzuhz10+2TQsAAhUjC+c5xLMMrZLLwhU2xhv+YM5rX6r1d9zy9y1Opt9ZSPgMKZCLerKlzpHjfovPwot7zCd9CAT7jmvXGpcHCpLYjO21AFkpEs/4BWiekbqqdIt0aiUmubxuh1SZCLgzCp7rum8ZlNbQtYjm/FpoEnMR4mJQxJW0H7a/xEIErfH8CuTJ7gk6/CKblLbcssFNH65bEIt3kQtWy+rjCbWou5Iz482B/HLT/ds/6OJHSdZJZBdLJlmgn1PRhWxkzt8+HXj3yAb9by1Q+s2VqqmHPfeQKF6R8qSG5HwzRo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ef91eaf-111f-465e-10f9-08dda2744d42
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 07:57:35.5842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v230WcJlOoSlFjQyzB1MV2aIRA/JPntMOR2a9SehuhhPqzWpKZYYYMQh88q+mt5/dUcgr6eUogYMHk000s0vQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7206
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-03_01,2025-06-02_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506030068
X-Proofpoint-GUID: YnTEVuKCltJNCsKEBPj6lyhJvNLsTOp7
X-Proofpoint-ORIG-GUID: YnTEVuKCltJNCsKEBPj6lyhJvNLsTOp7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAzMDA2OCBTYWx0ZWRfXwlvIxsoqxP4k BvALRlKI9rmRMm3cemUrldsNDQOSgVXYNgR4EAAJXmH9+OhtNPAvxz7N/J6OwMSo/SJajDqJcCT bcMYdHg1favFYzIssdQrDMnCneJFapKthAomHXrBaD3MrahiJ0+Azlpg35wakDRsryRe9NQb4JQ
 4U/jg1zfYt2FJT5QG08/A7eqrd7LMpQJA5GvXyxEwpwLv1C2+/yMCoRzrAK68kQAQOn9Xgn8x4M EYSFYpvwEMz9MbX7XiYLABu/zWQLzwgUjVPfLe5fPnMlRiMwjiXZMWCxe/9AdMAGHnbJ76so+Wd YX6Pg7W2Ul+pPWNsP429XGWq5q4gJp+elnHSu5khm9EUqpSvKpP7/kT8oSY+WzSK2PhPWfdlX5f
 5ypqXCwA20ycygs7uGmOh9zt3KM5Rg/Ieo3o+6zpvG1K71PUZMtT1YNWs9iho5r9qmqeM/7d
X-Authority-Analysis: v=2.4 cv=QI1oRhLL c=1 sm=1 tr=0 ts=683eaaf2 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=S6Zm0o5Hc5mUBLDcmWsA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:14714

On 02/06/2025 17:25, Benjamin Marzinski wrote:
> On Mon, Jun 02, 2025 at 11:08:46AM +0100, John Garry wrote:
>> On 30/05/2025 15:50, Benjamin Marzinski wrote:
>>
>> +
>>
>>> dm_set_device_limits() should check q->limits.features for
>>> BLK_FEAT_ATOMIC_WRITES while holding q->limits_lock, like it does for
>>> the rest of the queue limits.
>>>
>>> Fixes: b7c18b17a173 ("dm-table: Set BLK_FEAT_ATOMIC_WRITES for target queue limits")
>>> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>>
>> In itself, the change seems fine, but I have doubts whether it's preferred
>> to even grab the q->limits_lock outside block layer / its helpers.
> 
> I'm pretty sure Mikulas added the q->limits_lock around DM's queue
> limits accesses as the result of a discussion with some block layer
> developers.

Do you have a pointer for that?

> 
>>
>> And, apart from this, if the bottom device limits change later, do we
>> actually trigger a top device limits evaluation update?
> 
> DM will obviously re-evaluate the limits if you reload the table. In
> some cases, DM will also disable features if turns out that they aren't
> supported when it actually tries to use them. Dumb question: Is there
> much chance of a SCSI device's atomic write support changing while it's
> in-use?

No, I would not think so.

thanks,
John
