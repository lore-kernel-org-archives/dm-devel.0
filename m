Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DEF2DAFA6
	for <dm-devel@lists.linux.dev>; Mon, 21 Jul 2025 14:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753106989; cv=fail; b=texWtpL/dl5gcgWjh2aoLvbS6Hz76abx1wpJ5SWqdy0EBfbGYoTsM+GRsxn9bNQIR9N/wQJkzWYM3H+ZF7pC4UHbzf92E4nVQjRX54HMtE3xyV9RlzBrFceX3DIwGRDp3vPNM/qnyfhajH5NaS4EbzyRpo7PNcyNAkiGMxVTcfI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753106989; c=relaxed/simple;
	bh=Bwc5zoijoZ6D4wSC6AolGeK58rmkb2l0IAlmRI1tzu8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=n43O2E0jGMnp3aV60lqu9VCluPhL9jVEY9qlM0Vo9aXPxD29Js4sj4Vzq3ahNc9S0UHo2skEvsQXBLo2z/escBzSVu4mq/nepuyRWG0J39OaXLchf9izm+6WugVNPCj6IsJFOQoRHiaW4N/df0bqjesUW0iNGXm5S/Tr1+z0Zz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Kt7wV6Fy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WzdytRKa; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Kt7wV6Fy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WzdytRKa"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56LCMkwC012787;
	Mon, 21 Jul 2025 14:09:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1VQXk/FH7ApQmp9mEb2ziM8btpES7e6KB+byO9JGXPA=; b=
	Kt7wV6Fy3Fo0A8EhXY98SPIUH+eGd10C1HVwRoPMjK4nSU/3L4qRQeyboOLd+Abt
	u0X6tTNkZvoupyzmeZd2W4n8FRUKvvhc/Cj7WKUNrLUZAhdghzAWm+/1KuMsaUja
	UxgX3w9UrUSGcxPK3IpSg2D5BmZriee8Hxxx/n2YgcG5HsZ9lk9eb0aKd/ZKItts
	TIOP2jjXOjnNW+eE42lYAZB4xwmZUz8WGpl582MnQuoxwFuDa2QuoqIY5oGcmaOB
	rnWtDT5m5tRqRA0OxEzQV89Ma/XvkE/+nGHwIyOCRR/EPJ1f3KpdH+SGBGupGsK8
	HZIW3jDQwp79pmsSN3VMPA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805gpjsfp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Jul 2025 14:09:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56LDEflm005877;
	Mon, 21 Jul 2025 14:09:30 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011052.outbound.protection.outlook.com [52.101.57.52])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801t83fdr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Jul 2025 14:09:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BuBeOtlBlAtBmLEGdImGfS3MTpWweV536h7F1VtvSOP28hrABOsn+8LOnuvUgo+k71iImiGm3F4rovTAlRCWmd50zjsb63mY2KGzSi6X08/T32TdF4rLk30fB+9ge0IVNCfZymuIEfsw8dFjs/zmwUhUkBVAqCFcu1Lqa9KQnZveADoC1tCZjKYiSn7eJQJJFO/ks2FDmkMrHN2FX92doE9V2AeZS9/EGVaAFUmmS3IqGWDIheh/jP7Jf/7ccdFr+XmpXJ9ziWC5grRWSe6C1hw4m3acQgNk0JjUKmFrRWEk1vqQ7X5R31+NITUgJTKu/yiGVDhIF8CDM4tFD28Q5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1VQXk/FH7ApQmp9mEb2ziM8btpES7e6KB+byO9JGXPA=;
 b=lQaWdN53mhROpXBqtaWI7eF+oJ48mq+cSXxfbLWNQYPdgLvMojmo9wyU7AT2L+6qZljuhgtHGJ77h+xf3k+XENYSHv4KCKaxpcxc1wP7TeaF5K2NEwrMOuO7nPjYB4mDD5K9YZGM4qQqeapC8snPH90vuU8x0B+QuiUkLsjTSNQsj5K+2C57l9hVg4ndt6FFrEKV84yR96QaoU6w7noI5sAdMWs6PBEzWRFTPi3AVfEXYva6MqfOQK+AWJES4e7jNAlK7y7ovAogsm/204NpV6NwOYHbSc0ZQOtexmPg9vFdV3hN/s2k/JocGuWN3d5n/f8yLdap1AcSMLy1kxhA0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1VQXk/FH7ApQmp9mEb2ziM8btpES7e6KB+byO9JGXPA=;
 b=WzdytRKaxh3gnRlLxFsD+finuaiGfR57jYo+SM5HJIpQGz0kq8SJzZiw619F1AcZjlEEn13lAZpfmmuBtnh4KUSUHyTkNjR26UEqMH9gWLNxg7IH9oW0tzRiI3UKaRa/1MXIPqcYQZYNmICp/NIQdD9dkTmGPRe5GDMakr6N33g=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH7PR10MB6457.namprd10.prod.outlook.com (2603:10b6:510:1ec::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Mon, 21 Jul
 2025 14:09:27 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.8943.029; Mon, 21 Jul 2025
 14:09:27 +0000
Message-ID: <cad33609-9a92-444b-9ff5-5f5a68598866@oracle.com>
Date: Mon, 21 Jul 2025 15:09:24 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/5] block: use chunk_sectors when evaluating stacked
 atomic write limits
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, axboe@kernel.dk, agk@redhat.com,
        snitzer@kernel.org, song@kernel.org, yukuai3@huawei.com, hch@lst.de,
        nilay@linux.ibm.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, ojaswin@linux.ibm.com
References: <20250703114613.9124-1-john.g.garry@oracle.com>
 <20250703114613.9124-6-john.g.garry@oracle.com>
 <b7bd63a0-7aa6-2fb3-0a2b-23285b9fc5fc@redhat.com>
 <f7f342de-1087-47f6-a0c1-e41574abe985@oracle.com>
 <8b5e009a-9e2a-4542-69fb-fc6d47287255@redhat.com>
 <803d0903-2382-4219-b81e-9d676bd5de1f@oracle.com>
 <yq1a55edu8i.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <yq1a55edu8i.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0296.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::13) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH7PR10MB6457:EE_
X-MS-Office365-Filtering-Correlation-Id: 7da283d1-27ad-42c3-9f53-08ddc86033bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K0srWWRLREpDbFEwZjdseXFrQVJycFJnaXBEaVFQT0xjTVA1T09pSDA3NkEz?=
 =?utf-8?B?cWtVeXROZXkrWkNDSFptb25XaTdqSWxtdXFrL1VpVGZFMEI3Um9FZDFEMGRp?=
 =?utf-8?B?MmtxVzl1MTZsampDQWNoQlllYm8zemtnbnM0UXRDa0ZQeEZ1eDRGb1pvZ0VY?=
 =?utf-8?B?K2F4TFA3S3FWU2FyN1l1VnJsRHF1WjdzQm1RbVhvTWxieFRiZkxLMVhmZnBj?=
 =?utf-8?B?SVhNeUlHYUM4bjBTRzFqRXhJcnM0dUJ4RGw3V1RheEpwWmJTcXBWcXd5RW00?=
 =?utf-8?B?by9MSklodzVXd2srRlRBdjBCNCt6NktoT0ZoeUNpWHJEVS9aenlJem1zd1U4?=
 =?utf-8?B?K2hFOUh4alpzQjl5dkFwRm9Ob2E1SFlYeERpdUNTb003cFlJcWx1M3JnVFBr?=
 =?utf-8?B?ZC9jaUxKQ3pUZ3Q2Wnp0NG84MHlKaEhsQUx6TFBHenRjWnZMZVpUWlZxa2FO?=
 =?utf-8?B?OGN4NUZnMlp1UHRFYjF4OEpoQWpic2dIZjN4TFFqOFpzaDY4VkZ4Slk5a2x1?=
 =?utf-8?B?eUI2VC80WkU4SitEdFc4ZE45RzFGbW82cDQ5SFA2VkhvVGpMRzU3RU0rODN3?=
 =?utf-8?B?c3l5SCtZL0pUZDNLM2FXM21qY3B4NmhJUnlmaXVvdFdjZHJNNHNieE4wRzY3?=
 =?utf-8?B?MHV1akZwTGN2aTUxeGJCSVV6eTRaK09kNDdaQVdIMzAwbmh2cEQxT25jajFw?=
 =?utf-8?B?aFNYd0NBUXkwVE9PYXVmd1NJbnJUWjVLbXRweGdpZzdtbDA5REV6cXZydWd4?=
 =?utf-8?B?UldaTHZmbXZlcUZOd1hCdE5jbGd4eEw3dDd6eWZhVXZZWWJpVC9wOFRNanRU?=
 =?utf-8?B?akNFMHhibXQ3Z0swaDJsSEU0WS83b0tka01LcU1NMU9TaGNENUFpUlBPV25V?=
 =?utf-8?B?S0RoVWM5RGRiOStsMXhPS01zUC9ncm9TRWRaNjlFMU1xTDBHRVZQWWJXZVVo?=
 =?utf-8?B?S0w2YnJhZ0tPbzVDUVEyMUtqWk5YNzYvNEpDS3h2czA1aXkyNnc3dUQ2bXdC?=
 =?utf-8?B?NnUwTTY4WTYzZHdwRHVRajlKMndEc3hzYzRyS3NoVUlGSjRpditLQUl1bmFI?=
 =?utf-8?B?elV5NTdFa0lrelhOMHJFOHRYWlhUejNCMkZ2SnN6SzlubHVTVFo5UXNpTHdq?=
 =?utf-8?B?dStFempYUjF1UjNrTHN6M2krV3hqYVFldzZDRGpOK0ZBTFJjdGpvR2FPcUEz?=
 =?utf-8?B?dHZ2c2d3UHdnMnJkOEJXV2dnQ0dHRnhkSENQclVnNkFoRnJGcWVGalkzYmUr?=
 =?utf-8?B?cThOTFZMR2NYMWtNZW1MQzhLd2NNUG9YRS9XSStZNm1ROXJqbGNxMTFzc0V2?=
 =?utf-8?B?amwvRUU0L1NTMUdsdjVmRGxXNFVsWUtna1RwTTBPakJMRG9VUzhyTk5sT3Bl?=
 =?utf-8?B?cFg0YmhvSldoeXVDWUdYS3hIeWYxS0RkWGhGL1I0RFgxVHNlRjBHTXp4QTBt?=
 =?utf-8?B?Nk51Wk8zdFFUR1VKalZCRVNjR2Y1YlJOWmxnQTBleHYzZjcyU1E0MXFBbEc3?=
 =?utf-8?B?VFFrd0loRzRXZzhya093N2pnNWlKUG9UWHBQMTJiREt1NmtROVBjendTQzJw?=
 =?utf-8?B?MDM3N1hMcGhVWWtyT1NmNVRwSW92UDhpQUVqYmtZNUJraEtTQlBIcjBQVkVT?=
 =?utf-8?B?ZVdZWjFXUllvaFlHeFYvakQ0WTQzakFJWHVQYTlkOVp4VlJrUEFoaCtGcXVR?=
 =?utf-8?B?eW5La1FxT2Jpa1VTcFd4MzJYTkt4R0poQ1JpMjkvZnd3Yi9aeW12Y0luM1Nr?=
 =?utf-8?B?bHFrTmZCMjVyUmhlZVk2U0dLUlJVbGV6eDM4QnZHMjVmc0tMVFZJSlNhdjB1?=
 =?utf-8?B?cnVobndSNFArQ1FyeFBLZkpzRUx4Y1FqU1hENUNud28rVlQrc05DUmNnbm5G?=
 =?utf-8?B?VEgrR1c4d3phNDVsUlRBNThUNVNCRWlSUll1UnNlTkRsQU9LcHV5Rmo5Z2hT?=
 =?utf-8?Q?ak6/yVYA2mA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YmVrQktVbE1tcmZxa2IwMStLcjNsRWNWZFJLTTBhbFFML0F6R2g3UHJrNlBx?=
 =?utf-8?B?RjhRVVlJMHJXL0pZcXRVOFQ5L3p4TXRpZ1J3VktxTy9FT3NEbTVRdWtmZEN0?=
 =?utf-8?B?NU93RWg5eXdYdVFHTGtyV0d6THlxLzdXRjRIWUhLSWdCRCtXdThxZ2E1eS9H?=
 =?utf-8?B?ODBab2w5bWl2c2JGWkxZRXhXbnpQTEg2a3RiOGx1ajFXVE1VMGZBSTRTSHhJ?=
 =?utf-8?B?c2RkeDNJcy9rUFdXajhWUWMzSFYvdU1XU2I5dlA5ZkV2bzRaN0VCQVRVK2wy?=
 =?utf-8?B?OFJET0xESUNaV2kvbDdzcVRCT2pXVjQ2M04rV2NMMWVhcjhrbXpEZjJhRU9r?=
 =?utf-8?B?OE52L21PY1Q0RG0zclQzRDFPZlpYWE9FQjVoSGxuQ0lpWGFJR3JIUlB2RHVG?=
 =?utf-8?B?dVVoSzZUVE1QWEduMzVIZHhJdkxhNFk2KzJtWkdSRXdDTWlzc3J2NjVEN1RO?=
 =?utf-8?B?V2VGUm1kbktwd2lyOFVtWFFndUJVd1MrczVaQ2M5dVpXVGkxNE5lVHBrWFBx?=
 =?utf-8?B?bjJRMTJKZ0VGRW9xUjBuUWtvRXdGbVpSaURvNndlRm5pWUl2L1R0UnhsR204?=
 =?utf-8?B?b25OSWRXVFFpbGlRYXZiK0V3M1ZlaTJZM1NvRkhBK1hibkFnSlBjVlV3ZkJs?=
 =?utf-8?B?WmJVcVhHSXN1dHJYWmNwbjRuaEZhcnJSYjNRTmFueUJ5NXg1TWhpbUtFMTMw?=
 =?utf-8?B?UHo5ZFh5d0xFODg2eGs4d1ZpbER5QjhsMUlmVmNuOFhhTDY2MEUvZEp6QW0v?=
 =?utf-8?B?cnRJMTRQL2plWWZXU2VpZ05jUzJIQm8ySkgxbEltR1BJbkh6RmRIQjhZVWtW?=
 =?utf-8?B?YU9lSkJpM04wTnJGUWFIQzI1SlozRkx1QXdoY01BOXVCZVpSSGZGYWZxRlZs?=
 =?utf-8?B?dEUrQkkzNGxUSjhIZGYzN1FYOTRyWGQ0OXV0aUJJb2pXakdFV0xveWJBVXJq?=
 =?utf-8?B?eTFBaloybmluNUwxZ0gxam44NVFuMFNXTVBlTG56WENxaUlGVXptUSs3aVZr?=
 =?utf-8?B?TkZhSHh1Sk0vWVhrVGlBWUVjdWpmTytqcGVVcUlOcGtaK0ppck5XUTlPVC9z?=
 =?utf-8?B?TGV4UXdJQS8rMmV4ZXlKNy9WOHg0OXJMN0doNDdXOEpreVRDZDdoSitvSnFC?=
 =?utf-8?B?ZnZ5M0FPLzFuSUVlaDhFRHJlTklFY0dTeEJZY25KcDF1bnpFRFQvempHcDV4?=
 =?utf-8?B?clUxVU94YjZBK0hzVlNXN2s5anhwRFhUQms0dnRpVkp6MC8yUHMySjMvYWZQ?=
 =?utf-8?B?WGxXbnJvYUN3cFpxWkw2MTZ4cTBxQVAra0liSlpSL2Exb0p5dzRyUFJEcjJu?=
 =?utf-8?B?dG1DOEVLRVNDZ0NNUDdvdzNub0U5ZFZMS0JLR2FrL0dWM2hyckxFTU9ydUxa?=
 =?utf-8?B?Z2ZzVlBFbmFTRU12L3UyZENsdmgrZmhGV3BZZWV5QVhhU3Y3S2tLaVg1SUps?=
 =?utf-8?B?SnhuZk05SEcvRkNEL1RXbllXMjltNXJ6WTRZWm8zeURETENaeUtsNmF2MkJK?=
 =?utf-8?B?cG9ISXBYMWVkc24xbHhXcU00ZFpQaEl0MG9vdDg5UTBpQm00VE5QbThMMHRz?=
 =?utf-8?B?b2RVcUpMM3N0d0E5UmVXWkgyUXArV0ZsNzk1M1RHRDdsK2JZQkJ1dTdVL3lG?=
 =?utf-8?B?c3ZUNjlsTHpGbjhSNG5LMGJNeHlHK3lYUUxBaGN5TDAwTnN4dDkybWdabmQ1?=
 =?utf-8?B?VU5NcEZQS3o2L0VvdHVvcDBOc1FyU2VhRUNWTVFyV1Avd0hjQVBUTzVLTEd6?=
 =?utf-8?B?U1ZUb2x5MStaaldWdXNYTEVnUHE3cWJIQVFrbjNod1VRRjlrQkd2NTdtRDQx?=
 =?utf-8?B?QTJObWFpYlpwUHB5UUQ3Yi9GeC9pbGNCWFdleU1qcVlTeXYrYU1CSnowTVFJ?=
 =?utf-8?B?eW5EQng0eXI1V21wZ3RoZGhOMWlsdXVhVHVNSmtMcnB2YWRpNGdOaW5JdWhI?=
 =?utf-8?B?SDFTdnBXVk1oQW1pd1V1cmtpdVFMSGEwMzJ6ampkVnYvRkJxUndxVkdrMDFK?=
 =?utf-8?B?K0twTWpPaGtERjNTVlJ5Y0tXYW5aLzBUcmRYQTdpVWZNT0p5SitOWU8vNEtS?=
 =?utf-8?B?MWRuL1o2WmpJV21tQ2NWQVFWamRPUytSUFVnclJ1K1JPenQzM0xLN2ZBS09z?=
 =?utf-8?B?SEZTbkFPSmJ1SnZodFA5T1JsTTltZkVpTG1BeGE5V0xtUWFKQnhBWnlEZ3hU?=
 =?utf-8?B?VGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JhcaORLO/Ydfb5jQMbIeEqCyKQPxZPe2FLmF11fx4SJVPVXBlsr4vLnCZgam6AKnutYFDwjkLtqySMDJwmlv3yUY62l+IzW+/YOE/RaurCJm0JLl1O60H1gUtRBhK9ssbWmLJGpmcjfS92r8iMqT6ppeYhIRs+md+H++Vav3/87OS44+4d2eGwXnCVMIE+o/Jg0f6x6EhFRDRrTLUoZ6C2oFlfYzw01YejGOr6S5q0z6YpOKZN8IUi+XAUdwJHWjwZp3oD7CaOfu3QJdKOSTDouPi30lNlSjAKl4rjEyIwe5ionpr9gqimonzvE22y2cJ/R05CJmjWyqznaK01VXe89kPXop2HZzEXQ0jwrRguSHB9PssMeOmQ9EPj+1daxvH4THphOsShwr/7TaqvCvhyMgJOms5dkR4nJPTen1GQKyLqv/rQh5CzkcnuNpSWnOv/LhGbySMGYY99jlFN9HJ6oXSWdbWOVzxh/XKbF9OLePnrt57A6d74s4rXTY8rEeI6S80jXVgD3EpqexW4R3VDuqP6vmB8SWy9BCkziK4zZ5ctrCBYH1gPgaEzMIIWu3t8vsE4U7jajRKak64kPvkpK/RRn+0UYZ/TnCF7vXHaY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7da283d1-27ad-42c3-9f53-08ddc86033bd
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2025 14:09:26.9961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rEwVhtlKqVNv1eh24MxgdqnsN5TW3gTRiyxil479RW5hl+j6QfHDaRDvv4uK8numGG9B9pZTuECrSUGPQfW76w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6457
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-21_04,2025-07-21_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507210126
X-Authority-Analysis: v=2.4 cv=TfGWtQQh c=1 sm=1 tr=0 ts=687e4a1b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=KwV4qE7swklyai2pZOUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: rCLFML8hsN0vcdkeYedUPCjrimpbH4Qk
X-Proofpoint-ORIG-GUID: rCLFML8hsN0vcdkeYedUPCjrimpbH4Qk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIxMDEyNSBTYWx0ZWRfXyg2jszdFzT0O
 0qds/okNEmzFzB3R4BjVFLSznsEF40zbQd8NYVecBvvG8l+JuCoMJjCLgLk4WEOervI8ibPHlIe
 f2se8z124TQNSuNrFeesVdIIbMpL+zqj8qrbXCleHQj1FRfYC0h3fcEVU9Ycqjd8SZftzyNQfvP
 Tg7lp0fR32ucYpbbZV8G30bG4aOis+bJp41L5rAlITC5GFRkbGhse1Hksfo7q29Dxhj69jAmgIp
 Z8Y1DTlhNFmUbPgtgo2Gy737CFkC7798gR4AblCbgUbGlQrTmOLvzeFGi7HlMvu1jOym47vC7YK
 +ybLC35pIIAne6M+zwBlfg/AvaQvkwigZvM1JTuj3bTvzghYzHX0II4TTTCgVDHTxRgtVstgJ0O
 ZvwlVUuUwt73+sIJpcnyQgOutq1Q2XNxkSq3vNuX7eFTSQfvOBrESqEpttemW0UH6HrQkh7e

On 09/07/2025 02:39, Martin K. Petersen wrote:
> The intent for io_min was to convey the physical_block_size in the case
> of an individual drive. And for it to be set to the stripe chunk size in
> stacking scenarios that would otherwise involve read-modify-write (i.e.
> RAID5 and RAID6).
> 
> io_opt was meant to communicate the stripe width. Reporting very large
> values for io_opt is generally counterproductive since we can't write
> multiple gigabytes in a single operation anyway.
> 
> logical <= physical <= io_min <= io_opt <= max_sectors <= max_hw_sectors

Does pbs need to be a power-of-2?

The block queue limits and splitting code seems to rely on that, but it 
is not policed AFAICS.

The stacking code seems to just want it to be a multiple of lbs, which 
itself must be a power-of-2.

Thanks,
John
