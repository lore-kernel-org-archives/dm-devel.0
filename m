Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9760329E4C
	for <dm-devel@lists.linux.dev>; Thu,  6 Nov 2025 12:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762431511; cv=fail; b=lCnl25XVUtJ2zKDgFbzBRDmXJQsHPWR0GJ3ImDd5+szFrK0NxXzVgFfBCjypZeIIJh2+sNhAvvb1pJxQmI8gVwJ82hfKRRUfw5Eg87V81kyc7VY+6zlBcsOUwlU1TjCOtAwpTU3BdcBFX6zKRGu2EjeULj15CAs0oEifI2tHxN0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762431511; c=relaxed/simple;
	bh=1Oi/ddeOEDsaqpIvkU8PWoJ1Ovw3qCFx+PbMn3OCe1s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IIYj0S7rzAj6RIfcDSykLHaEWPjkYJ/Hy9P2e0ZKJZ3ucZ32pse6/5KNNP+ePEFsolFzHnJpYIxJv52hJwjhvxVyGL8ZpHeLPkhr6CRNokpCjKVASWBEw/WrHs7p1CiiJBjn5MSrqIEw8NvsHd2cYU6WP3ii5apEc3X5/CskEg4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Px7z4s4I; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=p99T0Ktt; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Px7z4s4I";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="p99T0Ktt"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A61CT9V030425;
	Thu, 6 Nov 2025 12:18:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=nD+Je75kV1bSJn4x/mVtwIwiFDj3jey5IgfoMLxM5M0=; b=
	Px7z4s4IRCZ1CqfOUqBXMvL9LVgqabRi5xE0OggByZpic2on1FHPxU/hyU4c5urM
	js7C35v9nM55yxNJYUccUHL2qWgU3UG+O3N1gm2Ff23/vXAk/SDNYV3SHpvoySQF
	fcM8RKY7fwfMdgRXvnFxNcneRlC9K9INiugl08AyXhSttLEvX9PBWIdqwHYKEezZ
	GjC+nUoFJQhH6Dde34SzADHf5iYglvlWukQwnEWsxJFlrdZDx7BBuvuC1Ukuod2L
	AybMgutBJfEx3E9OPEJDbPlAL49/RQO+D5mz5ImxjbP2c7zmGLA4b7aqlS1Eh5cU
	B7QbHef75xEVwuhssumjng==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8anjhut8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 12:18:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6BtvUV039714;
	Thu, 6 Nov 2025 12:18:24 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013063.outbound.protection.outlook.com [40.93.196.63])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nc2mab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 12:18:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BK5vV98RxvFSc0h077RxpV4zknaNd6gzFZsHv859mG3XXNlih8scD0i9/reteAmt5kV6a46PT1nuXdClR9PXKzh9skTJw/PJ6ceoOqRwOpIn9lT9kkkyceSFTbog0vXBa7IfQY133rcLG9U33MLaj6kVWfBGtEFDNypyDPk91mQkawqeB5Axcq7OKko414CLnZB1KrosEGeg4Iuvr6cvRfIxV/LgcfclGC1ckxqZqmbqB6zinc5YF5mPp/7fbHQY5qYndaTlyAJ50QOJGcdZSsdqc5Qqms52BXdsWObvKCw8ihMsRIfHGif3Uj8ZZzCloGyGDufKGgnlIjzCTGwILA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nD+Je75kV1bSJn4x/mVtwIwiFDj3jey5IgfoMLxM5M0=;
 b=w5mVEv2DR/cNA5wFHrtA6vLBWPDO9eJAt/37gMUtFNreHr9j7/4XjDncgtTQm1UYlbYSX55WDjfHbhgtqQbHxTTGu9zMkrWIhHrjHXjy/6T5s2ISVHhrRgeiIvwzNp0Vr26qYAGBZGQ5jK6oA38kYXDk/rhv12uT79iFXuob9tozVMSRgBMy5lE0ohTwtLIhaCft9E+fmjE5+lNNEmagwYqD/BT7U6IT0jDlqo0QSxYgYIM2fvJfaK5ALD0yEiuctSbMSuJvzgUwjRf+xpZIzm7x0OHRR8A0SvFAlOLVnxlZrsixuxeimTTGZV6yacIPFLw4zw0EQNxW+R7ZqUnmdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nD+Je75kV1bSJn4x/mVtwIwiFDj3jey5IgfoMLxM5M0=;
 b=p99T0KttM9TpNlNiDmDoTE1mBQyIaWRCXTx+dpEreVkBceqkOkTnHQlqGstnLBNArWkvfxBfLjrt9afejX0h03/9NsYlpWp9FKQQzE1Yi92mQhrUeXLtgRNANTJdMmV2N1RxxF0XME3o/BZ8ZXlEMKLooluEa/XPzLA1YX5L3u8=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by IA4PR10MB8373.namprd10.prod.outlook.com (2603:10b6:208:565::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Thu, 6 Nov
 2025 12:17:56 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.006; Thu, 6 Nov 2025
 12:17:56 +0000
Message-ID: <16e9a3d8-8334-4164-a41a-4a2da0467c65@oracle.com>
Date: Thu, 6 Nov 2025 12:17:54 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] dm-crypt: enable DM_TARGET_ATOMIC_WRITES
To: Mikulas Patocka <mpatocka@redhat.com>,
        Benjamin Marzinski <bmarzins@redhat.com>
Cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
        michael.christie@oracle.com, martin.petersen@oracle.com
References: <e0b99d8e-1159-a489-6df3-648b21c4f091@redhat.com>
 <aQwCHqrdNMy1wy75@redhat.com>
 <513ec9c1-a568-a98e-18ef-e42d9c73e3e1@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <513ec9c1-a568-a98e-18ef-e42d9c73e3e1@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0175.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::14) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|IA4PR10MB8373:EE_
X-MS-Office365-Filtering-Correlation-Id: 33d230c8-535f-4330-b297-08de1d2e84a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RSsxVnF2WVNCbTE3MmI1M3RuaG04bVVVaGh0QzRGM3g4ZlZuWGowRUJuQ3R4?=
 =?utf-8?B?N1RNN05ITEE1OUE4YnNMMnpYKzJldEJvSDNsWDJiajVod1dwb2V4TXUzcC8y?=
 =?utf-8?B?d1JDV2dHZVRTdUs1NGVvM0tUQnIwbm5VVHg0NE9QdkVkNWVJTWhsVjYzQ0ZY?=
 =?utf-8?B?WXV1UmZPQk95OW4rbVpiT3VSSjdGVjdaN2JWQmxkeGc0Z2haK2ZDNlBHUXRS?=
 =?utf-8?B?aWdkMzdHait1OUptSm9DS0hFd0pWY1YzbEQ5Q0RGbjBNVlh1MVI0aTl1Vzgr?=
 =?utf-8?B?cUNGbFZvaFlKVDJaRnRwSXE0a3hjeURma3lDdEpnWDU0YjFrQjFzS1J4UEtr?=
 =?utf-8?B?ZGcyenU0ZUNXczBraVgzN1pmdGFlT3VTOG12SVBwTmZjM2duQmFoQXM5YnNh?=
 =?utf-8?B?MkovU3hpSnRuSHhBdU1tR1ZsRkRjOFlNaEVIdllhaXhFUmhHYkIyQUZqZDRp?=
 =?utf-8?B?OU1XUzJWTGVEenlHVmJkZGVic25uMzdYQ1VHODlKWlQwc1FsN3NhNXdmTnhY?=
 =?utf-8?B?UCtlSzFYcWpGb1M2WHFXK3lWeDZ1eGJKNmtqU3VEZWErOERlUjdXeWxmcjhs?=
 =?utf-8?B?bHRTQkNNWm5NSlVoS2hMdjdWYkNNblVmQWFNN3lrdlNIYUxGcTZGSmdpS1NX?=
 =?utf-8?B?T3NQQzY2TzYwWFR6SS9kTitOTzlWUmE4K3NLQWNxZGpLdTl3NDhxTXdHcktO?=
 =?utf-8?B?cVh4dm12bVFIbEc3RlNCNWxiUXBCYlVyZHd5Y3VJbTFMbkV0aXV0M2g4ZkpJ?=
 =?utf-8?B?TUNPNFMweTh5M0VoK01KMFRRTjBjUXl1T2ZKYzAvWXlxUTFxSzZwTUczUFY2?=
 =?utf-8?B?SkVxWkRhNng3UklZc0JDcWU2cW9nR016WlBtbWdkQlp6ZVFaSmt4VDhUbkxt?=
 =?utf-8?B?MStBaTBPNEJ0ckxZbVFlemFHcGYyS29VOEZzOTk1Z0NUMzRKQ2FUVTB6eWZm?=
 =?utf-8?B?M1pkMGtYd2o4MzJWTklMNjhpZ1dReFhoWnh5cnBJb25FUFYvNnF2dmNBQlI3?=
 =?utf-8?B?ZlkvNWYwS3ZpSEZ2QlNJS1hzSTBDN2lsQU9QUnlDZU16MnM2bXNmNlUrWGI0?=
 =?utf-8?B?M1FsZ1M1UGdTaStPODRhVGtMT29VK1NpeHR5MXhreEQvZHNnN2doUnJ0Uk1K?=
 =?utf-8?B?VHY4Y2VpOEc5ZDBYQldEVDc5TFlUSDBJWjZwRFF3aGJvZWhrQ0ovbkgvT2U2?=
 =?utf-8?B?NjFvMVVyMjVkTER4alVsYi8yV0F4cXN5UHZWYzY0bXcwYm5uSXB6UXZzemcr?=
 =?utf-8?B?WEErdGswckFnN0V1M2JsT1Vpc0pIdlI3N3R1RkQvQjRmNmpzbE5Bc0I1OEV3?=
 =?utf-8?B?Z2wzRGJjSjFCUTZLSno2VUs3eUFQdnFvMVFMczhlOHlIcWVoR2NSUHcrc1Vo?=
 =?utf-8?B?SGRMNXJiYkoyTVUrOGw5ZDFtUU5SUnp2bGlhWDFhbkRGMG0xOUJlcTU0SStL?=
 =?utf-8?B?NkxsdWlhTXNtSER3NXZYWEQ2eHRjM3huYW5yclRqNlExSlJUUUtZTkozZ2d1?=
 =?utf-8?B?dTdOTTZudHZVRXZPdzE0WHpqRy9VYUhPMTFjWHZHTjk5MkZHTHFnNVlpbnZU?=
 =?utf-8?B?L3FvcEkxQStmNUp3dDJDQ3pQQ04vbTA3R1RUZkwvL2tMUzVGN3BHTW1VVnJw?=
 =?utf-8?B?YjVoOGtoZ2dhb0ZBOTJGYk8yMyt0WXRUL3EvNTBnUVp5endmTGV0MXZIeHVS?=
 =?utf-8?B?TGtrVCsyQjBCTXBYSXp1dkhBR2lvRUtoTE9NVnZvREFqM3U4R0U2YmF6QjZK?=
 =?utf-8?B?QkxiY2Q2enFXcVpONndjVVBwYXJzczFTVGF1b1l2ZG5haTNNUWtsdGV1VjZs?=
 =?utf-8?B?cWpMQ1hrdTBYQmo4UWhVU2VpWXZRSUIyYzBLSElCRWh3NWp0bzJ1SG9EdXRo?=
 =?utf-8?B?WmhIcmcyZEs0ZVVGVXdvYmhLaC85eDlFalB6bXZ6Zk9IaHFzUWZzTEZ5dExM?=
 =?utf-8?Q?J+PDU/15oX1sloRIZwEzM1vC0RslUvPu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?djZsWTNXT0Z0djZ6K2thOWlNcFRnZ1hiMHpYWlFWL2VITTVxN3RWckVWZzB3?=
 =?utf-8?B?Q1Q5WkJCUWVtYXIvajd1dlNQWkhnNCtWRzZnOU81V3BGQTBGZmhlLzBiNHdu?=
 =?utf-8?B?c1h4K3luSGtLUEpaV3oxeXB1czR1R1I1TW96aWNod3B2bjQwNDJLWG9ZNXh3?=
 =?utf-8?B?Rkp5bzkzcXBBYWgxME5tQjZwcXpVWGdMS3lXVDhrd2JUUlhzem9aeGpOc1Vy?=
 =?utf-8?B?QXptbVdOcEp4NXJtMDN4YXg4S29jdHEwOG1EcUpyRk1LY0FhMUpNeWxCdE5V?=
 =?utf-8?B?UDhRQWV3YldxdVpKRnJCZFZ6SjZPRHFORENKR2xSY04xcExCZDIxdGVzQUxB?=
 =?utf-8?B?RjNMdjdaMndVTDQ0alplZXVNTlF4NGtDVCs5bFY4MHFTcTEramFrTkU3VmVl?=
 =?utf-8?B?YmhCMlluTGtUdnAwUmE2QmlNN3Jhbno3eWJBS0JDbmh3ZkZEYy9ueXgzLzJ5?=
 =?utf-8?B?UzdVenUzaUgvRWNsRmJaZjJYcWNpdWI4Wk9aNVBKaElYOWxWK3pkRm5GZFRY?=
 =?utf-8?B?UmFDdk52Z3ZQVGlteU5kTWNscUpqZmI5dmdJcjZFZWNsUWxuWk8wTkFzQVpJ?=
 =?utf-8?B?eXgwbUlMd01DRXFyRk94UWh0VElQTU9LckJsL092V0tpVDgvSTNCOWNDVVMz?=
 =?utf-8?B?TTRyam4wazJtNXNIWXFpb0NVUmZEdjdlVFQvbGNZWFFDWXJsU1ZjVXVZSVBD?=
 =?utf-8?B?dHdLZi8reXNRZ2ZwbW9JYUtQMy9CQkQ1SDRYR0N2cHBtRVpRVmV5VERUWS90?=
 =?utf-8?B?VTU4ck0zRGJHVklkZkgycnNJa2FGMEkrNEc3V0hVQmNDY2hPR01HRjdReUMw?=
 =?utf-8?B?b2RHeUViSHc0a2xaMGNNcWpXSzN0cU5peXRVaERqOUFHTnNUcWtYNm5JS1JV?=
 =?utf-8?B?T21mMjJSMnY2bXNLZjlyZ0liUzVpQnljdXBpdUhrM0JSWThzRkRuTXk4L29l?=
 =?utf-8?B?cVV5bGdCa0hzb3ZVaUdjbGgyM2tCQkdJS0N4NWsrd1RteTdsL2Q0Rm40Rktp?=
 =?utf-8?B?Umw5cG9EQmlsOTQ1SE0rRFl4RVF0R0Z3QUpNSlQ4QkIzRG9oWU9HenZMWDY2?=
 =?utf-8?B?aU85RnZBbTdDb0hPcy9kSWx6ZWJYR0Qxa2c5Q3o0K2ZyY0ZyR2dKa3N6NEFV?=
 =?utf-8?B?VnJOZ3ZjZS9pd3BSK3VTS2krV1FHUHF2Q01vcDY1Nzd3RVlwTUh0ckRPZnQ2?=
 =?utf-8?B?MkY5MWx2NTJLSFh2bmxSNFlkWTkybTlDWVBNUzNWSGJpTGpPZjMwT1l0MXBr?=
 =?utf-8?B?Z1hTL3hER3pHWFZOd2tISHBsT295cFlnWTJmT1ovZVhXTktKZlJjWXJiYmdt?=
 =?utf-8?B?N0krRGEyVHpOM2FUU20xaU9lbTE4b29PbVQremNhY2djY3ZJeXBIcnNiYkd6?=
 =?utf-8?B?OGxrWlcwM096MVRMVVdzem9YV3dsNEY1Wi95ZGNvZ2VrM00xenI0cWkrOC92?=
 =?utf-8?B?aXlVb28zMk50Q1VReWl3ZTBtbmpTOFZFOThHQmFJTDRkNHFOWTVYbkNnbUlH?=
 =?utf-8?B?R0I1WTVLQUNOckNPWEdoNHRjVDBibi9VNTJBaDcvam90d1NyRkk5cWdMVVM3?=
 =?utf-8?B?SXJ1dGx4MC83WnZueHRHcTdTWE1KVnNnR1g2SUZFRE5kcVpQY1B1RlVpeFhQ?=
 =?utf-8?B?SGJZL3lVV2h5SVBkd0Vnb09UNFdET3ZxWDJTaWdGY1ZDM09tU3FQSWhKZG5V?=
 =?utf-8?B?Y2tkL1dTZ0lLV3ZVaXV3OEhieTA3eGwydHZCS2Y0R2FIWit0azVKenZQamVq?=
 =?utf-8?B?K2NqOWhtUXd5eFAxVzFUSmNQakN4b2ZDSEprY1hXTnBQbEZSMFFYRnU2Y2Jq?=
 =?utf-8?B?U3BNNC9vRGFJQWd4d2QrajJVRW1ZTUVYWDdsL3FzcG9ZV25uK215VmQxUXB2?=
 =?utf-8?B?K2Z6cnpjVE0xQjhwaXZmL3NmTFMxL1l4RFVuOFFVSHZrYTh1KzBodGNnVG1t?=
 =?utf-8?B?eFJIYmZLUWt2RWwvQW0vR1Zaa3Z1OGdnUFhENUtPZ2JEaUtkb3J2R01NRHNV?=
 =?utf-8?B?elBlZkVJczYzcjhJZDdnSXBBTkVLYzJZNHpROWNlWlhPVThlUVRBc1pleHZ4?=
 =?utf-8?B?WFlmbUlEWDV4WENoeTF2MUtDQ0dORDRuVGZTazludkEyRDE1bVl6dlBiUzBH?=
 =?utf-8?Q?whB0+o0sAFNV7s6ktICY6OKAM?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rcTsuIlKRyhbMMfIlunuWf1AUjp5cwth46iv8w9HqWbyJAeFY3DFIfjgmh+5O/SkARsBSD+q8Xugisfk7RbWi4OiMSRwh1G0dm/Tnngj+Z3n63FqFetd8pk0mhRfxqdg0iNCDjTqC/KVBLftUmWpbPuiL67NzqXwxCuUX5ZE9x7WKFa8cpASly3lHScxmmIyQvA8NcHxwLw3aw1yPpBhkqIAjhbnSxBJoED9LxVi1G3IP59I0BInTSzCXnAIj21samzydih6NgOGaW7ulKJmFXLRYN686SUFdeaFk1LrwoL4V9XTf3mFgNyWWf8lDdDHBkNU8d5erWGMEyhLTKtt8oaWhndgrfl35C+8GW4ee1kc7DFylD7ct3ZDiUzvhojAr3ia3sJ0u0VrK7dFYENWJ8ZoDsLWo4Q0JBZDlajULskTyR++MZ4oPewmmaIgJenIhZZ1gs0yHmHebBeKz4Iz/ow9DTPi05i1kJJRU+pGcCS4JR4ZZ5DvpxPQ6RrJASLA1AXJYmfJqrv+cGmSdPQgiUMNHa1+tx/zQ8vK4POqETpmq6NFYiBj6UxkQ4O6R9vvNwNatlKsGU7VA/CmuzUQnrMVh4uqoUvaVBcCAM8yJBw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33d230c8-535f-4330-b297-08de1d2e84a5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 12:17:56.7431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s/Qk0j6P4WHMFWajXjdmmnuSC9QrHN8Ejge3Wlj19W/szUqCgR2XBKAdhAFnA4Y7MsUjEKIzmHgrJHsQzwRXnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8373
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511060097
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDEzMyBTYWx0ZWRfX9Hbe14dr7EJ8
 zAskI7JtR9KSargPBlepI2iVR2u+0RkDy02WLYHy1dB2Z0wa41J7T9AlFF3YUHr9CRbRIA97tKZ
 Gi7UiHB50zQLBMbxX+ogkZCbfdyrwhapcS6Ee1ugDAEfK3vVNq47sReC5NzNk9hwmE7BPHFjFoE
 cpjO0B5g1Y6fXuKxyRZjwOe2LqhQzjBV0BrLZLgd1W2Vs2URdFmxGaCKC3la9wj4ZJGdq7tTCGq
 CIDAl56TG5TvCnlnKQtNgBJc/guAx6dGIEobXeKurNN9QMmm1sFJXQwyWsgrLVlE7VwAFOH36MQ
 Qn+KBZ1Oy7xDFI9jqBIXmyTJn7arBgz99qHsmVxMYQL11fh/MLX6ovSCHmKk+fRdUn8amLPqZQu
 sF1pvLAvtkHOGQRGiqugP+ON1kxK6A==
X-Authority-Analysis: v=2.4 cv=dfqNHHXe c=1 sm=1 tr=0 ts=690c9211 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=4JD-hu6fJVXvdqsbwl0A:9 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: tyX9m6v78W78w7fvRTIPrphB19N_3pVk
X-Proofpoint-ORIG-GUID: tyX9m6v78W78w7fvRTIPrphB19N_3pVk

On 06/11/2025 12:06, Mikulas Patocka wrote:
>> Neither of them are really used for IO.
>> atomic_write_unit_max, which is used for IO, will already get a capped
>> value from atomic_write_hw_unit_max in
>> blk_atomic_writes_update_limits(). And capping atomic_write_hw_max seems
>> wrong, since atomic_write_hw_max == UINT_MAX is used
>> blk_validate_atomic_write_limits() to indicate that atomic writes were
>> never set up, because no underlying device supported them. I don't think
>> these caps will actually break things, but in my mind they make some
>> already confusing limits even more confusing.
>>
>> Or am I missing some reason why this is needed?
>>
>> -Ben
> How do you think we should modify the limits, to make sure that atomic
> write size is capped at BIO_MAX_VECS << PAGE_SHIFT?

The atomic write size is limited elsewhere, specifically 
blk_atomic_writes_update_limits() - the limit there is quite similar (to 
what is added in this updated patch). So I don't think that we need to 
do anything special in dm-crypt, as that block limit is already tighter.

I suppose that this code can be kept with a comment (saying that it is 
unnecessary, but safer to keep). Or we can just drop the code and add a 
comment (saying that we don't need to limit here, as it is done elsewhere).

Thanks,
John
