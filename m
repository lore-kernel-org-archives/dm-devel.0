Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B918022B8DB
	for <dm-devel@lists.linux.dev>; Thu, 16 Jan 2025 15:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737039729; cv=fail; b=sduj0B4mp1Iz7XLIop42X6OkzTh+63LPuCn+uykAzzGlKDrxbOr5HYkbWdTzgnjLcieHJsejglEBLAjbUDF3RzcaKBbrUBBAvbCqyYzlIBkibtHP4WFpmUeGBvS5LTfsFv+0cQwWJaY4qlibBqO8IPBFyb/OVO0F2cGqekPXdNM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737039729; c=relaxed/simple;
	bh=p5eAxrZUdxZXRdiv5bspOkaFCm+FcR51xLBTcQD2ftc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JbuGqV0GiPP4J58CQEU7zfQEOJfDEGyVnH7mVfDDs9Opwwt+GwjOxQgdyJhu+81WxBHqeP7uatoanjqiAg2IKEXjFvHgm02zMWCviUPGqS6+KeXDB+nN7ShaaASBgX03njZ+SWgHdV8anA803wgTQORovQ3D7QgjKuM5fKaJYJY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Un/0ZaCM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bm66bMax; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Un/0ZaCM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bm66bMax"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50GEuMGL007825;
	Thu, 16 Jan 2025 15:02:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=kr8evgi0ReEv7PMCMVAzOrTwrFczEI0v5zXESWJL0HQ=; b=
	Un/0ZaCMRUKBuR6ds/UpBiJnKIC/xHdavRmiOFk1iFpANv2jqlm5rnsQ4GrdKv40
	EcoukTmQ5MK69HzFpDP7h8P8eKKDs0WyELLyDsofbRNQcHcPDzUczEBhQGM/SQ1f
	Zl5CK42d7dCltxoXTbG+BW9ln7XDbfpbz+Tm2GYlcMIJIw97qjXDMgPaqfwiZ2Jb
	GaOSE/wqYgWe4MXxvEUEktncDfSlZUj1rueROO0nnsKofrSOwISLiEmdeY+p6v4+
	/qwExywxSKhKsxJGY1lx2HGlnAJib0vS56IsxXS1UVD5lHFQs1op+7AkNeI8Q//O
	CU9jp1UI+JIJCwE2jzfIiA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 446wtp8r15-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 15:02:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50GDUAZP036286;
	Thu, 16 Jan 2025 15:02:01 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 443f3bf89k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 15:02:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bh/UQc8oAFpxKTLi4PazxxtRU/Sn4yqCQa9jnvw5NcWUs/Htn3huB/xsjMPZT1JTqN0KgIeTEZOVOSGmr8OSLW/qN01R8OA7Ph1WWgv5hkspuuSMy51GOvzvMRGXMdXd8hNomqxLubHG8NNEdSiJzznoHEH1lgmC4q3CgAiiuI2fdfzJEUHIpATi1HaymUjvsyWS5MtJm/xdjVfk7Ji57X1/cmqiNQFSiS7ObPsWK0W/9Gi0QhRl+ssT5/ll2E4wHitCuXlvpTtaV1K5I/NlYa9TrVJzVc7gmEJza+Pna29e80CSOZHIfjswVe2j1HnA8TIJUI5k6YqgxKz6hk999A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kr8evgi0ReEv7PMCMVAzOrTwrFczEI0v5zXESWJL0HQ=;
 b=PqjNZm22DqCIact9mVstSeoLw+xBcrLBSmAHLs5TuYImB3437RBuqpGtDLNSvyDem2CivficdNgBAayd4tQglpntYiAIlZCAF244y8On51Uwbjkq7DCWDej4S0/3gc7J4ZTD5Rih4rUIVXhY0Z6M+HB0bsCQuuEF6SjOGAz9ANgBppth9IggwHPjOcobl7+j4JvAmVa3lJI/ewuMpQiC7N8bsqdGmc7VYXv0xAUzO0fTRAIIBsxGtpAYVAPQ9bo8OBxKXtAo7VvaVwvBvhWxPkbRpRIYxLwFyeTYQ6Eudwoc2fz1de/5p5H9ooG2EkCGR7i/jIvq0oaIPKrmwmLHPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kr8evgi0ReEv7PMCMVAzOrTwrFczEI0v5zXESWJL0HQ=;
 b=bm66bMaxX1FTBytohIIoC+0AcPkxHca3i/lpPm/2tG4fmhSYHrzUhAQhPN9pgKxkBLcsYR5FYRkPfVXn0sE4lB4PpPxJ2jKE4sRXxPnuWgqdruJvUBxUpYRjUU5vEj52vY0+NAoavhyFoUpoTcB3nOEiYzyFiTa29TH2/yawGx0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB5068.namprd10.prod.outlook.com (2603:10b6:610:c7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.16; Thu, 16 Jan
 2025 15:02:00 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8356.010; Thu, 16 Jan 2025
 15:01:59 +0000
Message-ID: <1e63e90c-592d-4bdc-9c94-2a6a747729b1@oracle.com>
Date: Thu, 16 Jan 2025 15:01:56 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/5] device mapper atomic write support
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@hammerspace.com>, axboe@kernel.dk, agk@redhat.com,
        hch@lst.de, martin.petersen@oracle.com, linux-block@vger.kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250106124119.1318428-1-john.g.garry@oracle.com>
 <Z3wSV0YkR39muivP@hammerspace.com>
 <dcbaadea-66c1-4d98-8a37-945d8b336d5b@oracle.com>
 <5328db9a-8345-2938-7204-3d4cdb138ee4@redhat.com>
 <6a6f8cff-bd19-4079-8867-4ac17d09e915@oracle.com>
 <e2be0a8c-3b97-f75c-362e-2174340b1b2c@redhat.com>
 <9384e8e2-dd4a-4b49-88a8-f15a9193c872@oracle.com>
 <0aeae777-5468-c0e9-3196-e81135da2d8e@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <0aeae777-5468-c0e9-3196-e81135da2d8e@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0007.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB5068:EE_
X-MS-Office365-Filtering-Correlation-Id: fa281bd1-bdbb-4795-22a4-08dd363eba2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ODVXT0NaYThCZ1MzMEdTakhNUEtSbWQwNmlaaDJuaXpNTWdkQ0NwTjVMYWx3?=
 =?utf-8?B?a1RqalZDNHl5Mm4xb3c5K09FSU5pcG9ZOFBNUnI1Y1VDYlY2all3SFhpdHhv?=
 =?utf-8?B?ZW5wdjltbG5Ba0VmelIxYkcrc1lLMmo1Q09CTGl6QVJwUjQyV3N0VklEQkZK?=
 =?utf-8?B?SExuc3NHRVNPcjkxOXlNT1d5RUliWkkwRURkZFBWcFREc0lCeWIvY2tkcWhy?=
 =?utf-8?B?MHJ5R2lJbTE1WTdqZnRvTUtvWXVWQkZrc3NQUkc5d1JUVURpUmx0S0dUNWpX?=
 =?utf-8?B?bE5TMkNWeHZXcmNBN3QwWkpTQUlDa2dKVGMwc1ZjWVFFRE9QUUVjOVUydW1M?=
 =?utf-8?B?eTd4eVNoQXhGdDlaMEhZWHZHNHRvSDVDTnhCNzBYd1Q4QkJ3UVlhZEZlS29m?=
 =?utf-8?B?ZVAvbHhCV3cxOSt1VzBIbWFybFV1c2VFVTJoZnVOcWlBVS9DYUdvdzJ0amxP?=
 =?utf-8?B?dFVld0tDUloyNmZkck1Sc1doQXRhemNQNENXV0Q0c3Q2NXkyMUdVZUJEZEVt?=
 =?utf-8?B?TEVLSTFaZ2ZJOWVvK25qRkloZmJWNWdjZEV1L0pDSGpUbnF0djFXWjBSNHBq?=
 =?utf-8?B?WjBMKytVek45bHBMYjZUTElRaUJDcHhVSmhmKzhIL29hY0dxd3VTMkJrSkJx?=
 =?utf-8?B?aktCQVR1VlJheWZ5eUYxUExDVHZ6bTdrVXVqOXg1TWlZZ0l2djlvam9VeUcy?=
 =?utf-8?B?TVFYZTBEcDRUOHQ2STZPdXU2TDNaUlFFYTNuRHB0T2IyUGpkK0JES0Z3eGo4?=
 =?utf-8?B?ZDhtVDFpTjNDUWhkTmlpVjlMRWE2d1hoYjVMbHpWazdxUUFNVE8wS1JIdVlu?=
 =?utf-8?B?NWQ4N09SK2VSTStZMkR4ZVBpVEN4eUI4OHhGcUFNUG9rWktDa1ZyaU9mY2NW?=
 =?utf-8?B?Y1pTU1RzTnVOZytqNWtZc2lVcEhHSVM3Y1RkNHpkWXlFb3Z1LzBZZzZlZkFF?=
 =?utf-8?B?VEdxMGl5bHN4Zk9NMVVCRm9sdE5EamRCWVI4RXhMQmZlR3JmNTloUFF5WFZG?=
 =?utf-8?B?NnFRa2FXZXB1SlhYRktxQkY1UUJwZXJ6NTU3M25KOGdyUEZueGdqQlZXZWFL?=
 =?utf-8?B?VUR6UEQwZHlqek5PQWpRcnZFM2pRUWsrV1hiVjZnNnUzdzFEd3ZiQkxEbkZQ?=
 =?utf-8?B?UzlmS3J6M0dxSk9IL29jR0M0V0VlMGcvRU9DYnlHTmRUQkZiNXpGWDR6LzBG?=
 =?utf-8?B?VHlnSjcwcEFMdjdreStGeEZ6WHFwK0JjRHdhZ2M1TW5rc1RtQ3lpSVBQenZa?=
 =?utf-8?B?UGREUTV0TW9VVmFCQjFkcW5GaklVT1Flak13L1RnV3d2SDNKVm9yTlppdzJV?=
 =?utf-8?B?QXpVS1pOeVRyTndHQzZtRXkxNVhoMmVzRWNmbkFtREYvWkJsUXg5d2owbmY4?=
 =?utf-8?B?U2sxMDVEZ1ozSUpIYUt2N3RFZ29UL1I1NnNIc3oxOWxDbkJJY0VEci9xdUtv?=
 =?utf-8?B?bzhRa3A3RWFndmN3c1VuOXZxVlRuVmxQYU9yZ1NlT1l1TmtqanhOY1JPdHNx?=
 =?utf-8?B?WFIrSzdIOEZ0OVhYNlR4S0RucEM1MEVIelhlaDdmeEdTcTZBVkNYelA2ZWVY?=
 =?utf-8?B?WHV4VXJHb3Jna05Qb014dSs3aE91d1NNdlNlNVlYdmsvbnFERHV6ZC9Za2hO?=
 =?utf-8?B?L1c5N3BGTGNlckNFRlZNd3ZRdTYxcmU2L0FKWE9iaUd3WHpzcE95NzBQVmRU?=
 =?utf-8?B?bmlvbEhkck8yM013Z0lTeEdBYlRXMlVCMHJ1SzNZMTVxaWpRM0lSYzRmaktk?=
 =?utf-8?B?bE5CemFzYnM5UDFtU1JrWFU3bTJmYnM1ZWVRODBpaVkwV3hPZTZPOEhXUEJH?=
 =?utf-8?B?STFOTFNUSkJaTzFvRzUvWkxya2NRM3hBc3M1VkZmYU1tUUNJN3llTzRmMVZ0?=
 =?utf-8?Q?Tma9dxDb2xaFS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WXU5V3VDN0poSENlOGNXbHF2bllyZnNkU284OEJvV0EybG1mYzlvTjROd1VP?=
 =?utf-8?B?UDFEYjh6Y3kydmQvZlg4L2tMY3ljd2drZUR0eXZsbStZTE1neURST0ZzVlNi?=
 =?utf-8?B?eTU3cDN6czB5MjdSY05CS28yd21rcEE1MkI2RmZQY0Rwc2NocGljRGRFWm9V?=
 =?utf-8?B?TWJ5OWI0N0VKa0lrSXp3UkVLRmhpWko3TVRBM2Y0WEpUVXZ0NFg0RmJxUndO?=
 =?utf-8?B?LzQ3R2QwV3IrcDZ4NkRWSERGdjBMbWtFODFwTTduclBZRFdEUCtLTjhmYkp1?=
 =?utf-8?B?OUNMQndjcXJjano2V2hDN2lMbU9LVUdvejBCU0Z3MGxqWURUejdFRytuSHZk?=
 =?utf-8?B?c1IzREhPaEc1RjNKRUhmRXRNSmxqM05scFVwM2o5cndJMEFsb01FcjVxdS9k?=
 =?utf-8?B?dDhWRU9MMzNSSEoyWFNGbGJ1blRNblIzY0ZVSWdnMFh0NVNLdEFFVVRYR3N0?=
 =?utf-8?B?NWt3QzJpZ0hZRWoxdWY5VFRCcVNINDh2Q0o0TFZscmQ0TmxuTzhaOTI2ZHFP?=
 =?utf-8?B?ZEpXUHlwNWlLUUdOZGd5YkJTQlFOak1HZVR1ZnBsZ1lDSDVrZmI5TDNuVkoy?=
 =?utf-8?B?VHJWZlQwTWdZTjNYVGpCdnVqU3cvVjRlbEJwcnViNnBPTlJSR0I4MGh1ZGIx?=
 =?utf-8?B?aGNEZjdXdzFjNTZGQlZnYTdMNlRsN012V3dQVXVmUFUrL3Z2RDhEaWY1anp5?=
 =?utf-8?B?Z2RIZXk0eGEyd0ttS2RwbUNTZ1ZXWnFtM0ZmQUc5NUYyS1ZqL2NnZmdSb3Zt?=
 =?utf-8?B?UWd1STFGZE5PbUdLNmEyaE8wS0kya1R3R0QxcDgrUU1aOUdOcXllVDI2UDM4?=
 =?utf-8?B?Z0daSVJja21DcDZtcTIyTm1QMGRWdkdtbDlNVC9MdDMvZldPS3RiUmVNRjR4?=
 =?utf-8?B?RTYzSm5xWVpVYkRlMStzclVWYnMvQTVIaTJPcjRsWXlQSTJKUDNwSzNOSWVO?=
 =?utf-8?B?aUxxaDVHWUxjUlh1WXFHeWV0Sm0xd3pWZTlZdjRua3JocVNKeTR0QnlxLzRn?=
 =?utf-8?B?b0doKytwaGUxTWRRbmtsMGh4LzBxTjFWY0M4K0MzZDUvbWdOWUpxRUFLdjBV?=
 =?utf-8?B?R2ZXVDJjbjlkNjVyaGQzd0h5bVpGbU9UU2xDb2lzQVhlSU9zMUxjeDRZQTN3?=
 =?utf-8?B?a0RvVmo2OVgvMHdhZnh2cWNZaVlHWHFuMkQvYlpIU29YcFFyY08yQVJhOFVP?=
 =?utf-8?B?YTZLNGJ3alhDYTQwQ3RRUjhQN3hqZnd6Wm4wcE9ZaXBpTG9UZEdKVkdJbXlv?=
 =?utf-8?B?Nk5oanhHaUVqT1ZuaElLbXRFY3hIbWFKenFRT3FuYzRSKzliQlV0eVcyTXdE?=
 =?utf-8?B?L1NHQU5CeUlpUXEwbzRBaEhDOGlneUxKVmRKdm9RbDk5NFFxR3ZXekNxN3pC?=
 =?utf-8?B?K3QramJlN1pHZ0tJeVZYK1dIUng5SnR2bHdYeG1hb1JTdGhHeE45MG9yWnVp?=
 =?utf-8?B?TnllM2RNMHNnRW5QUWNVOFpuVTAzUVdUcUdpeUlPUm5iSWRSZ0l3TzM5aHRs?=
 =?utf-8?B?YkxhSXBPMDJnRzVkeXlZQTF0ZjhGVXl0Ty9sWGZOYzVEU0d0cVV5Y1QyWkJi?=
 =?utf-8?B?QkFDeU50QVdhTHlFTytYOHQraUFoNTFlaHRHbWVzK20vdXZIaDVVSnZKeGlM?=
 =?utf-8?B?V29SL1JlL2hjTEVETGFUNFF6L09kTTF2dVlFRy9UTldXUk0vbW9NUVpOOHNZ?=
 =?utf-8?B?aTFWNlpSOWg0WStDSEdOaHlDMWttNVdnRHI5ZHZGMDhST0l3U1JiUERwNEN4?=
 =?utf-8?B?OW1jWXZWVElwZnRQM0ZRWEgwVzM3bEVLZ2Vjb2doZnRSTlRWZDFYZjBwdDlx?=
 =?utf-8?B?b0JFU0JiSnZ1aEovSVoyOTM1ZFJWRytLc0NXdGd3NGRNdUk1TVlib3lqdjBB?=
 =?utf-8?B?YXUrQnlyOTBrMUtkMEduMGUrcEpYTkZxUWNYMXExVkVNeThNUTNVZTZQWlVT?=
 =?utf-8?B?bk5xbE8xMnpLMm1NUFFrQkhZcjFGSHMybkc3RzlIRUIyelJnZkFpd0V1ZmRh?=
 =?utf-8?B?QTZYK3VSVUU3QVhEcnpHUzRzU0FLMnFBV01DalAza2t5bVR6RmFzUGQ0bUtL?=
 =?utf-8?B?RXhCOElvK3Jac3h2dS83L3lrRkxVN0pjNHgvMlpSKzZXTnA5bVZISzVPamFX?=
 =?utf-8?B?Zlh4bkVqUUhkSkRjbTc2dDhBRnBVcFMyTVhuY2JLV0h4MGlYWWF5MkpTcnV2?=
 =?utf-8?B?a1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4srWJFhOJJ3xhJFjToXYilXY4rYGBZ03wRaOtvYw5HD211k8f5tZXf6onKY0tJaZESdNMObGzV/gwgS+KLnWIISY5Q4bVJHTWE+LZRtRDCvdGC6huM7IhUzuWZCa8lEV2NZ/egxQBQyim/oOjUj8vNP/JiUqsVk225ztA1os0pqpz9/FVWTBlOzA++e+5VC7KZnqo5g4J2S655bzQwTYnbDupk6kLtjKr6kLLj9A0fdalLQxxNyhxioOFxzTHRfcEVMiCCb5zB1oH0AzH0MjrBW8hh9wH67g5MLlozDwks0+wjFFyBqGTcTIOl2CoPRW0hGMBSPQ/nyoSgm74zaRm6zEo65cHQbLLMxAlzMTw2OWd3aUjOubOpTAlXf8a2H3rQtrooX74FktyMRntOeWlbuTidUxRCfr/OwJI1mmICIbPOGOx5+9RHLqNDxCSkLJ4jx4/qamnhA9svNG1F6Q8V4hOLWnCZb7D/DCG6v6H/A5o++Ch0lnySHQI9PjMUY+fHgn0LakjusCcjzTpDy2+yoff6cJcgdMEOLJqpAW24YQ621Y8XlbbL4rIcg+tzOx+IV8WKu6X227XEmIggxJM6a+mWIYYfxr6JbbLYjGnO8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa281bd1-bdbb-4795-22a4-08dd363eba2e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2025 15:01:59.8210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rNRa43L0eeNK7VJTSZJW6NsRUn2+YqSXpiSSPq2l3BlBgiyZSyWAyZxELGhtmEWXwKgxHg86VZLayyQHUfIVAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5068
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_06,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501160113
X-Proofpoint-ORIG-GUID: VvVe2TLZqeXFujwN5GC4cnBEfC6my8Wh
X-Proofpoint-GUID: VvVe2TLZqeXFujwN5GC4cnBEfC6my8Wh

On 16/01/2025 14:58, Mikulas Patocka wrote:
> Yes - so please send version 2 of the patches and I will stage them for
> this merge window.

I'll send a v2 today, however I made some block changes based on the 
feedback from Mike on the dm-table changes in v1.

So prob quite late for this cycle, considering that it touches many 
trees ...

Cheers,
John
