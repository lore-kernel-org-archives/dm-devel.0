Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40601BD4F7
	for <dm-devel@lists.linux.dev>; Thu,  3 Jul 2025 16:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751558484; cv=fail; b=qcs4C6L/gmK+b+UZHe6Jjn8SaDUGNp9tsEhqDbzuaxHC1d/fRD6EI3q/R3FWGqkoyjGKWZILBSSxll2mNFUac5V7PjIYoOQ0HpM6jrJNU7PJoZAYfZeO/FVF/QqYR+StqHoJPXVfQyNJfpb0b4megDFThkW/13pJLkV7zpqiOEs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751558484; c=relaxed/simple;
	bh=4szWrWmUcKMJ3nNbODKeeWVBdlayZpfcpamCfhdAQsY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ANDO9RWciiIA9MkKxo2mvkVJs3etY1RhJa0TrVHORKsjJe946u+YX6LBRul+deHRwYMVMwV6paFfZbQLTrdJ/lQmhZLVZ++gvoHm43i02GCMof1uyHmB0Fe6AHndKm7sIT3W5ewE9uAdl3YHATWcgbHKxK0VwsIx2IsGEumGC9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FG4I6xud; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ad7u1Fcd; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FG4I6xud";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ad7u1Fcd"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 563DZ4Tv009613;
	Thu, 3 Jul 2025 16:01:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=QkKJab7sZOnw+Y/jpoouOVSocxt+IlxPXH1cj2JCrzU=; b=
	FG4I6xudLkyYZpLuP7PTF65tDci3QTnMnH1lDAIL0pXROnqEbZVk/1XvNdk7DdGz
	n99SbMflj8AweiZaafknyjt71hwRjCB6oYXwdos6yHJiIjXQnW9PL0xIfQ6sMj8q
	4Wv/buBMqG63OWk/jdZy5z/1EBAZ4khV7GtDxktRcXeKrnEeFjZVMjwo4xL4/jKq
	XbHOHim4HzSte8TGe/GZt5B12m0UzyHhjjSY3YrSwjea/UZXJKyiJGrXvBM+fAWc
	Yllf31+vQY/9+Dj4D5pgTSCETdiw8OMMvTdEPyxvK4XKog6tuEW9q+WS2PT61fmj
	S7WizFugkq2qS/6rinZSRQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47j766hcts-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Jul 2025 16:01:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 563FMd3d023906;
	Thu, 3 Jul 2025 16:01:08 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010003.outbound.protection.outlook.com [52.101.193.3])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47jy1hkwjv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Jul 2025 16:01:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wX5sZFC/juq4T+wy4OWX/2a10f0utdXLf2AIV1W9IwIla7gtsebYndqwZaY/0c7lKbYFca+ENCvLLTZWbbfzGKWKQDOShoJlJ+obYA6fm0uX3UhPi25vUI9dxpwrmotyo9UTygCRKuQSeG0ebZiltBDm2MLcDt9V5HfoRbfSF+1BzdhDvoMoEr3To9O3HlbZULtTbFmUymEP/MI5ctZo+lpqdS3jB5tkZVuvkWOPdmAYMGufZAkTmD4xfuHmxGwWMnMkj4LNnpEWGNJNqhDZAC5W8TQNwy9mOF3+cbPiJiEtq4LT0wyI9/zTsSDKpKFIkTMaa2LMGRSf3Mu97diGYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QkKJab7sZOnw+Y/jpoouOVSocxt+IlxPXH1cj2JCrzU=;
 b=LwThAnSFqkpbbZxV0us9fMLjiuIz25/ij0Jb8eCEdMgJKcvzaoFwkiKL4v48UFSb6MJW4m4W7bIWIsiuFPawelLFyvxM53fhdEUJv/aBOuptQwB8azysxUHCkIgnFJn2kVyb8B7QudUXcTdR1aD0u6ahc6pNUTfgAzp5lyfRPyaqu0LoW3LS9LtsvTTrppfAPUR2lPrjUPUhc5+LKDHO3eeskEpKwjrXJDfVwqHgZmX8N4+iXPnEIDdth0LRneoE84e6+Ev7FB1luEaMcaxoM7AQYFhar1NLUDmQYn26TwK7KiAVgPFr507xZVF+6m26DKbIDs6n+JkS1cDjCrBBWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QkKJab7sZOnw+Y/jpoouOVSocxt+IlxPXH1cj2JCrzU=;
 b=ad7u1FcdXvs2cxaSm++ifnqFDuyyopE0+jfjy6ZPDb1qrrDtJwn39xeCuSgw0XKs0PiudJyK1DU00pyeKSwTjfw0+6b3WjvZJ1UMTsM01FwU1dlzJ1r/B1JYesqx8rUSReHuNhNMwvQKZh7sI9MpsxkPu4ims1dR5LxKsOBMYAg=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CH0PR10MB5033.namprd10.prod.outlook.com (2603:10b6:610:c0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.23; Thu, 3 Jul
 2025 16:01:04 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8880.027; Thu, 3 Jul 2025
 16:01:03 +0000
Message-ID: <803d0903-2382-4219-b81e-9d676bd5de1f@oracle.com>
Date: Thu, 3 Jul 2025 17:01:00 +0100
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
 <f7f342de-1087-47f6-a0c1-e41574abe985@oracle.com>
 <8b5e009a-9e2a-4542-69fb-fc6d47287255@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <8b5e009a-9e2a-4542-69fb-fc6d47287255@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P251CA0021.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::26) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CH0PR10MB5033:EE_
X-MS-Office365-Filtering-Correlation-Id: eac67379-ae2b-42f7-7715-08ddba4ad003
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MkxUZHJlUnZZMTAwbENyMjVoV0pyM3h5ZWJPRWxWTEloSlJaSHpEYWJEcmgx?=
 =?utf-8?B?MHlDNnZibjZWSDZvYWRUblUxMXl2WjRJZEZrRTZQSWRCeHBLWTk0UXUvS1l2?=
 =?utf-8?B?OFhBSGxyUWJNeGtzbEpyUTJGdFNSeWNlV3pRblR5K2xFNXk5MGI3OUVvUTFV?=
 =?utf-8?B?elRlUGxING15UGswTnA3TEhhaHNrNmNwdGVYZUNCMXRncDJLQjNmd2xLSmR1?=
 =?utf-8?B?NDZTeW90UlVHUi9abWxoWVZsZUZjVDl6MG53VkVyY1ZwMC96Z1JjR1pmYlEv?=
 =?utf-8?B?Q1drV0l2M2xRa0w5YkUvNVhWL2o2LzhOKzh0c3RKem5nNE9vTkZiWkVpdG40?=
 =?utf-8?B?NG01MFNTUmlMVktoV2lkNW5Ub0V5TzlXblUwUi9nc2VMVkp1dzRNRGVDdUxN?=
 =?utf-8?B?WUhyZ0lmOUpZUTZPaitjVnRHbWtpY0Z1ZzAzM3E3WGp0ZkJRMVA0U1hUUE1i?=
 =?utf-8?B?TEJ0TUFFa0VMNkxyeUZQTFFmMC9oL0NENFVpTVJKbjQvY3Y0Y0UvWE5hSnpa?=
 =?utf-8?B?Y0Z1WWY5RXlyTkd4Wmp3b1FHMDIvaXlyV0FQQ28ySlQ0andud0R0d0NGWmtN?=
 =?utf-8?B?eDYxcU5oakRqVHR0VnlTY1J0cytrZmtUbWhxcDR4SEhFcGF0SXVhVGNjR2Zk?=
 =?utf-8?B?OFgrNXFmUzU3a1pyYm95SFFPNUd5SEdGUFZRN2JTK0FNVnlpcDVEUm4xODF0?=
 =?utf-8?B?allFUWh1UUh5S0kvdjdkeUFoYkRyRERJNXNSbWdaeEtrMWlsK3FKQVl3YnRB?=
 =?utf-8?B?R1JWd0RMQW9rUVlkangzNFZ6MzRCSk5sVHlZQUU1K0dlYjJpS3JvNWVjU2Vo?=
 =?utf-8?B?WG51MkgwZmhaOGdiakFOQ0FmVXFyd2FGTWQ0dk80SXc2ZVpEclRUSXd4alN0?=
 =?utf-8?B?NXJvejhKUE9xa2gyUTcrMXhVUmd2d084K0FnU0NNWnlYdHliaUl2VFFyWGpU?=
 =?utf-8?B?RVlSb1pJeTdaakVlcjROSE9vZ1RESWNYUURDd2o5Y2RaNHhaeVZBTWxvSWRS?=
 =?utf-8?B?eEVXa2N4eUpmbXduL1UrY3BVYkdEK0p4bHN6eXJSNnBZc0VhWmdpU2Z4TW9C?=
 =?utf-8?B?NnRqeUtmYUZ4OVRqdVVHd2NmQzZvNko2VWxuTzJQbTYvd3d3VzZhOHFXNUF2?=
 =?utf-8?B?RThBWkNkQzMxaTByZXpCczlhUVJmWWV5djNrQ04yemZYRkJWbXdsbFB0amlk?=
 =?utf-8?B?WXpHMWxkN1BOalQzTWQxV25aQlhlcmRNdU55OGxPbjh1aVV2L3lEazU0ejRs?=
 =?utf-8?B?dGVFeFpzYUx1S0VKazV0WEdqbHFEakhLaUd4TDNkSWg1ZmdQRDMvV0dNS0Vm?=
 =?utf-8?B?eXAxQUJvc1NjQ2h0QTBMeklyMDFZN1pFNjhiZytYTm9yQWtDQ21uWkNwYkNC?=
 =?utf-8?B?NW03cGFIUXhFY1lWL3Jmeis5Y0JHZFZjYVlLTlZqK2ZOQkJ4VVp0ZmxycXFO?=
 =?utf-8?B?ZnBVNkxSRVc4ZWVrYWZhNnlrbzhIYk1EQWJVUDhBUkFxNGxPaEdRTHd5QjFG?=
 =?utf-8?B?bTI0a0g0QWFQM1Frd2RlY1NIK2NXSjl3TTBML0RvU1B5NXY2VExmOVRod1Vj?=
 =?utf-8?B?ekpkTVhRRUhMMXMwMkRrSnpBc2VJaFAyNWtiZDcvVEpTWDNDU3dyNU5vTVJi?=
 =?utf-8?B?TGlqa1VGRjJBaC83M0xUdUxPYzlYUGtCVVRYRzRCc2M5MDNoS3F3RGZKMzN4?=
 =?utf-8?B?UjR5NTdUZ21MRGdDYWJuWXBnRFQxOVV0cFNOTGFmWW9FSmUvS2tyUFRiTmhF?=
 =?utf-8?B?QzRKY0didm4wRUVhcS8zWVEvZ25nWGFNQVJiN1A4eThBUE1pRDJHdmpmWnhY?=
 =?utf-8?B?WTgybWw1RllWUEo1VzdGNUJWNFo3NVhrbWdZNVc3Rng5T1Bmbng5RUxJR2ZI?=
 =?utf-8?B?OW1Sc2hMeFpyd2k2V0pkRDFJMVNoV1U1VlBaQXphQzRCTVE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cU04RmZOTnl0Y003V1RHREorZlJwQ2JQa2xLTHQ1MVB1TVVrNitNUzJNQ09E?=
 =?utf-8?B?VCt0NHV3WDlETjlQQmh2c3BSb0trUWtBc0NBdFBwUW5Cb2Vnckcva0IxR3k5?=
 =?utf-8?B?c3RpanhWU0hNY3R0UVprS0NUM2pvUFR5V2VuN2V6VFBuZDdkMHIyS09zY0x1?=
 =?utf-8?B?QkJNK3lxSDhsY3BJUDFUbVZsb2hkU0xaV2VaWlRxS0pKak9FUUx1Ujk5djV4?=
 =?utf-8?B?YVRZM2NPdGgzZXA3VTNKK2syaE5aVUN5M3cyNFpDRWdnMDFrUHVKYnQrQ05z?=
 =?utf-8?B?Z2pwVE4vdDl4MG92ZjFYMjZrQkdnamQremFidlNpM2lHTFhSRHBxbmtsaEdU?=
 =?utf-8?B?Zm1KT1dTaHZTM0ZiTllvSms1ZnMvamxsUVBHWFJCcy9vQ2l6NzFDaVI2SE9j?=
 =?utf-8?B?K0p2QlZkSk5TWkdZdDNEQWE3ZGZLQmhvNUJZRU1qNXdqN3NxT3pDb2J1Tk9O?=
 =?utf-8?B?MnVSVjlqN0N6Y0JiMmxPMktxSjB2NTBaKzF4YThybzRHZG00WUhrbWswM2pv?=
 =?utf-8?B?TXNKQ29zNnZTZEkwaGNKWEs1SXhEalN3NXBKdldZZW5uOG5odHp0TE5VVkJj?=
 =?utf-8?B?OWZORkMrWDJjS1BweW1SYm9pek4wUm91b2V4MHByS1RIQnNGUE5rbUdtUFFl?=
 =?utf-8?B?c2hBZHJsZHVXdlFkVXFoODVUL0RwOHhFM2k0MHE4emd1Z0lzNlJZUkV4Z0V6?=
 =?utf-8?B?bStYY1JHTUNmRVQyRXNtS0l4NGVPTTlkUWMrMmZJU290N0prMjdtZC9WYzJB?=
 =?utf-8?B?UkR0d01iYWlIVDl4ek9KT01ZeEFjNVkycC83b0R0b0Y3WU5QWjl3OXRTZUZN?=
 =?utf-8?B?dnBwZFdPQTRBSWR1TWpSQWhGRS9yc0FyanNnbTJVdlF1ZTFvM2h5ZUFkeFBH?=
 =?utf-8?B?Wno2YjF6aTNGZjdSUE83OHl0Z0tZMzc5dXZHa2RHZEgvQ2xpenZyRlREa3V4?=
 =?utf-8?B?bEtqaVZmaVpJTUhoNEEwemhRdHRDaUxLSEFBNm1vYm8xUVZIek5IR2ZyR1hu?=
 =?utf-8?B?VTBHd0xMa3NlcUpXcUFwbkt0S0dzdDVPMWFIWHQwRWk5aGhmSzV3L3JOMWJu?=
 =?utf-8?B?UjQ1Mm8rRW12bnd1TVlKbHJzbFA4TFJ1SVVwMHo2M1NVOHNnM2lVeFJScUpN?=
 =?utf-8?B?NzZsYytlbUJ1Z3hRNFFQTm9JdjdwRnpVbnhENTQrTmN0cFhqS3ZqY20vekRv?=
 =?utf-8?B?U0tqMC9aL242a0Y0eVlIQXFCS1RsL0VmNjVKeWd4T01WZXp1OVV1aGVpdXVx?=
 =?utf-8?B?K1k3S3lCN1YwWGZERWxjYTZYYUljVG5OVFVkVVMrdFl5TGxqKzl5Z20yQlRW?=
 =?utf-8?B?OXhSVXVWRWZKeXU4eUdWZFJ3NGx0V01hbHFuZ1BsQjNJOFhxeVdHcDVXbVg2?=
 =?utf-8?B?ek5kSmc3eTZnblVMWXVaamVReWZ5dGExZUM0bFhPbU1MdEo2dENxVzBxYlNL?=
 =?utf-8?B?d3dwaExrZ3dHc2VXVnlyQW52bS94NEd2aG5rMnErc1dETXVqSzVaK1Y4U2Rt?=
 =?utf-8?B?TWRMNTN3OVZzTVVieEFZdU4xMUwzRzh3OTRuTUxSKzNkSExDUGpSM2ZFT3ZB?=
 =?utf-8?B?RkRMb0tyOHhTTnpjVU1vRUhGS0Zrd3FWOHc5QU16ZXVFZ3dtMWRXWFcvbkNB?=
 =?utf-8?B?QWx6aHhWd2JQNkw5NlNsWTl6K0F2OU9UeWpMQXljNllRMjZxd0xTZWt6RUV2?=
 =?utf-8?B?TmpEdlpPbVJ1S08zK0Ezc2NMYnkxdEVpMk5JWXNMajRIWjlUWmExV0g4YmRF?=
 =?utf-8?B?eUFqTlUvb2k2bnJvTTY0QzZFcHVwalJTMmV4YVhLMENBZ2xvQjFpY3ZsZksv?=
 =?utf-8?B?Umo5K0tISDIxNVRNYUdzbWtvQWNBQTRLYnAzVnU4eGV0aXhhUEdUT1Z2REsx?=
 =?utf-8?B?eHJ3cjF6R1V1eHhhZCtTOTNTMkp1MjM3K2hNV2VlWm9vVG1Fak5pcXI3ci9k?=
 =?utf-8?B?WWxGZnZlVU9VZkx0clczdUhCbmEwbldhZlhYWmFCSTVCTnlkS1RlbUltY0x1?=
 =?utf-8?B?VVNRdzFYU3BoSnVCTXdaQWF1SUhyTFZHK3RTYzFXZUZVRnhiYkR6ZHlNTmRR?=
 =?utf-8?B?QW5YUlNGK1FjakFNTCtvWU5UUitEVS9WVnIvdkE3dXd6RUgwTFU2eTJ3NHZw?=
 =?utf-8?B?R0JJd2ZIVmtYQUNIMytET1VzVGRvTlZaQW44M2VvWk1RVnRiMUhibFZDSy9l?=
 =?utf-8?B?MGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hLaUuyRNAxD1SxWRkCUoHka1LMZr8XMjVEYDNUQAPJ5slUDDNQ9/KC+oVwwi17n7Rx9+pVO+igZu1cU+g8JX5wyAyx/5ar2wh6bd2wcCHaEO3Xq3BbNtauTxbQ6OttTi/FN8XNEEG24uCZjMX263N5WsOLuZTIRCMI5ihU+afN5uzW8dI7GX/N9HNf6gqAzgPkS47p5F+7T9Xn7l6oxorPyBK/wG36G2qiww09rCtYnB0SA/LQNW7Ve0PZxWEWuRVavOm6liMdZx2d2EHIbTxzmLL+SVIU5jaIZAAZ45aW8k9vZhK2OKpjUcqrWHETKhIh5lNX3IpSTn7++p1g3bvaZLiE1ZM9PUqAHrLokMurpxEaV9VQsStcOM6m5lB3ydP7+0tZIfs7tmdv/V2Rf89YZvDN0zZH8RE8pK160KxIXzkozB9SopOjm3PPrT/JaT4YXDXEw8EcWLKgyyXkl0uqLvWR241Uq/bt4ePPLRKdShHCLvwBVerb2vEh0Twy0V/8BfeK30u3IUIK8S/X3CVoyrwKl9J1G606d6mx3fCooe0XL0B1HOS3aGwyeIEOm/dcWvU/KxlKYyAjiAfdFWwVMDaShhgz26j9Jx1xkJOHc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eac67379-ae2b-42f7-7715-08ddba4ad003
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2025 16:01:03.9264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d0MZeX10ngdJLG4AE129itaF6KkefE3yMlwj/Gr72As7AYYpq/vr/ElIkMDpFp2cCORnivxdEKl8z9v/pu2+ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5033
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-03_04,2025-07-02_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507030132
X-Proofpoint-GUID: yXPCRb8X0nGYIuM79J2oE8HEJSiaWu_o
X-Proofpoint-ORIG-GUID: yXPCRb8X0nGYIuM79J2oE8HEJSiaWu_o
X-Authority-Analysis: v=2.4 cv=b82y4sGx c=1 sm=1 tr=0 ts=6866a945 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=vILngSUHaWQOPQsE9VUA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12058
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAzMDEzMiBTYWx0ZWRfXz64wlXvVmDRn CdqutEB8uiPkg+IS0laLMWhQuOy0rg1waJZfuNRetmjj9j2eUSr7/S+vTiH2bjL4ndUcj7t/Ei5 LgsCbfmWfY91y4jhz1JoaqtaJYMI/1vV2NctJS1vZfFTrW8aiLkmeCYmbfMtQQV2Z67IWS63GGR
 KKyoHfQeWz7eqoxXtecd3u1Ciio4KXolW7J2KWuDJAn7cx3iZFmkOx8xawBtDgdYBFVIQmCiCpS DjLCt+0SL+CQV5tAVQKQg+vVO6Wu+KxbXV3faWozdLMI4TQawvf6lt4Dtc1Nf4cQmkrZD3RoqQt ugTAaIIXSL1giPD82c/6faO0FoPeN3TkQR0paWyYuV/3cL2JJ5qODYTgzkNHeOnqEXccATFjacy
 FPfA+r4QCNeyMeQoxDpsbgWjZwgea0N5xyNCX9zuc1h1V7t9gIMZcIAcMhPURpPI8psA5bGs

On 03/07/2025 16:36, Mikulas Patocka wrote:
>> I suppose theoretically it could happen, and I'm happy to change.
>>
>> However there seems to be precedent in assuming it won't:
>>
>> - in stripe_op_hints(), we hold chunk_size in an unsigned int
>> - in raid0_set_limits(), we hold mddev->chunk_sectors << 9 in lim.io_min,
>> which is an unsigned int type.
>>
>> Please let me know your thoughts on also changing these sort of instances. Is
>> it realistic to expect chunk_bytes > UINT_MAX?
>>
>> Thanks,
>> John
> dm-stripe can be created with a stripe size that is more than 0xffffffff
> bytes.
> 
> Though, the integer overflow already exists in the existing dm-stripe
> target:
> static void stripe_io_hints(struct dm_target *ti,
>                              struct queue_limits *limits)
> {
>          struct stripe_c *sc = ti->private;
>          unsigned int chunk_size = sc->chunk_size << SECTOR_SHIFT;
> 
>          limits->io_min = chunk_size;
>          limits->io_opt = chunk_size * sc->stripes;
> }
> What should we set there as io_min and io_opt if sc->chunk_size <<
> SECTOR_SHIFT overflows?


> Should we set nothing?

For io_min/opt, maybe reduce to a factor of the stripe size / width (and 
which fits in a unsigned int).

I am not sure if it is even sane to have such huge values in io_min and 
the bottom disk io_min should be used directly instead.

Martin Petersen might have a better idea.. he added those sysfs files :)

Thanks,
John
