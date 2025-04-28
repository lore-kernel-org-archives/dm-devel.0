Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A40D86349
	for <dm-devel@lists.linux.dev>; Mon, 28 Apr 2025 14:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745849247; cv=fail; b=dIPCyVaFCaO/5GCdy2ig9bbrfkbEzNZLLFMnp/LWiZsGYPNrdPzq8xox3Ab6zizGPvi4+N7Q64o9KaE/RiPX33Khf4Vh4X0zh9QG2va1yvje9pbKUdJ6JngxKSsCh7JXaSdYsbIGDiVOAQBF3tzZZmTzFqpAUsNmrGnVtnHJ9Gk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745849247; c=relaxed/simple;
	bh=fEtn1Af5p+Zic2qK8NLQIgwI+iXXxY0QD5N8muctH7w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CGrfZ0pm2RlnhUAlUmR6hnREWDDWv85ZGD5fc3oeZQnscYAnPlIe2+n/PCKX1TmtEE/NwetVRRK0+8r0d+I+lrAqUafsDq4Rk/4AkliILxoPqut6Co+Fo2FrmCnfebXELtqDyER6Gp7I5Z6rrFN9s3BzTR59W9S2gKmhiLCPW2o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fQGIQ7Od; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FuMFk3uk; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fQGIQ7Od";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FuMFk3uk"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53SDoq5Z013777;
	Mon, 28 Apr 2025 14:07:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=wV7q0bkPsqXTrVHqRccaxp00lMU7phufCv5LNeV64nw=; b=
	fQGIQ7Od78vhOzcPuFHokKWlH8OcmoGkX5UKNu71A7C9EQQHocSKT00u3z8shTMa
	HKeqLePhyJlyUv46OwOvll+jlfO0B1ZmED+tL49q4+f80t8vpyK7jkhHFiEMlV5e
	5MZuH4XabGcSDEcZBPylhgu1cjpWQ+X0r8Lbhtj1ySjzp8WXPvVngp+ycWT1Gnc3
	eVpWGnFL+x56CzjCPlbPiNBYoZU0sEF030ckHSmIVPMkDJ3ztfWGmzYtTQYreX89
	LMFmgoLLwlF+ba53C02ZA+hlvCuELIo2W1O2tQ6r9FQWu8ydb0RTYFTqTZk3TbUi
	QgpiREviWQjctIOOEy+d1Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46aaq901t7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Apr 2025 14:07:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53SE3R2i003707;
	Mon, 28 Apr 2025 14:07:00 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 468nx8fsfj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Apr 2025 14:07:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bm5XcI4NrGT+BV59RgyWBe80ZxyfqpDuxTpJ93HSZHJKYT42nNHH+KU8MaImEL5MdaL7R3KPGefuT+4cTtkGCc+4Lp1YD332/2PZ3unswDukNk+UPUNRO6++cLbdvfBRjl5lPBJK1MA8PrfYNMZ8bHRhlL0Gn6oFX2s5fErZR4eOB+9hsR8hAz1ZIcR40ES3oPDUjONaqgnJTVOdz8NqiYSqkamRlIAnzDO6TJH1+ruuzlsUS/zEVIrl3tgCmnVIPjiN80FTP0Uoi77hrrM/3HJKxfcuI9nAxCpN7PpE77/56lphCsVX7FT/lhE7oHgLk1fXkv9rC61rUFotHNujKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wV7q0bkPsqXTrVHqRccaxp00lMU7phufCv5LNeV64nw=;
 b=H1S8sVoLCLZ1UfJGVwRNWk0xu0V+6cKgG7OVvd40heW+dLKmFwV9C9F1p08PWU1aaZXW5EkSKgAM0F5paYESiUhDSf4pHMkZeqULtp8xxMIcZJtrilLlAIzF6axDugOsB17lvzfCNCg0KSyUaLdyjTaOMeQfomgj+EwkBVGJreR5QiX+sAu7LYPlgPgTMcyEc0ilhq4vkvE1p9llnAEPSbiuUrMwggFrM9S/SmCkqX6sxUq+xupdmq58DAohfMOMi4FFOn1aJw8FFuLM0O9anPbbCrEFKH5bOkbua2sGu6+kbWXyboN/4CVTDMZSQd2RkwPY8AZYeTbkdcWXfuUcZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wV7q0bkPsqXTrVHqRccaxp00lMU7phufCv5LNeV64nw=;
 b=FuMFk3uk862zw1meKq+Fy3ib4/w4cggt4jc1vVdFl8HDtpHmG6TKQetjF/9FbgFQmlXg7Jz7zf+ZrwhfNoFCIi0SvI/70EPLpkvf4Kyarwh3H40qkx4Dn6IbhTGByOgMgM2DC4lS5Xj7ut+gpHn4aAwPZAphnwEXBg90xxFyGm0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA3PR10MB8114.namprd10.prod.outlook.com (2603:10b6:208:513::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.30; Mon, 28 Apr
 2025 14:06:57 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8678.028; Mon, 28 Apr 2025
 14:06:57 +0000
Message-ID: <4c6ac59f-0589-4cb9-b909-354d02ee1a44@oracle.com>
Date: Mon, 28 Apr 2025 15:06:51 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/9] block: WARN if bdev inflight counter is negative
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@infradead.org, axboe@kernel.dk,
        xni@redhat.com, agk@redhat.com, snitzer@kernel.org,
        mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com, cl@linux.com,
        nadav.amit@gmail.com, ubizjak@gmail.com, akpm@linux-foundation.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
        yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
References: <20250427082928.131295-1-yukuai1@huaweicloud.com>
 <20250427082928.131295-4-yukuai1@huaweicloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250427082928.131295-4-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR03CA0065.eurprd03.prod.outlook.com (2603:10a6:208::42)
 To DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA3PR10MB8114:EE_
X-MS-Office365-Filtering-Correlation-Id: 88728f7a-63e9-4197-03ae-08dd865defb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WmxBNkFuc0JaOTVnVkF5azQrQ3lzTkdMV0NjWkp6cC9WcjUxQXdGYlh0aml1?=
 =?utf-8?B?N0syaE4vS0dnb0p5ci9MQmZsVHloZitHNDFCYzNBYkc2VTFnaEdNWU5iV3RH?=
 =?utf-8?B?L3c2WDkxWjhBeXpuejdCeTA2bEt1R003OXlyelpHZjFlT3BlSkFyejVvNmNm?=
 =?utf-8?B?emlSYTd0ZWtTMnZkZFpBTiswSXJmVjRYeXhSQnVpTGxCZ3AybnBoa3U3YjJF?=
 =?utf-8?B?Z1Z0WjdoY0xLUVdkRmlpRE1GVmlUZ1hXbkdQdzZKZG52VnlEK01OOW9XcE9l?=
 =?utf-8?B?c2VhWU5oWGh0K1FkcEY3YmRqTUtGNFEvZys2c2hocHZYbHFlbHZIMnQzaWto?=
 =?utf-8?B?dHpyV1J1NUhtOFUrMDEyS25ETlFhdmd2c09nYU9GU1pueGdsTDVCSWZNaldj?=
 =?utf-8?B?TlB4UEFPVDBoWldEL3Via3R4YXhRTDBUYmxBWWFsMkh1eUlxaC96eXlCcHJl?=
 =?utf-8?B?dEpZYk50cXN1OUxQa0NCeDBpODJUVGpWSjVtcGxyMzFFYW1uUGF4Z2NEUjd6?=
 =?utf-8?B?bmhBWFFLSTN4cjFLeE9LVkxxSzlsN3VBdmtJaUVDT3JhZUxaRDRKY0lHZ3RN?=
 =?utf-8?B?TWVvNUxXbklLbk56YkVFTWFtRDRJR0JTeldHV3kvaHpaOTBHQ256bEcxUUtx?=
 =?utf-8?B?ZmdyV3FwZHpEaEkzTnpTYUdXNkZwUkEyOGpzeGJGUlhPRGxrV3FoU2h6YUlH?=
 =?utf-8?B?eFBFQllZTTJnQWtTNVlSWTQ0RmhtaHMrTEdoOGltMjVUa2xTTnlSaTlvbFRq?=
 =?utf-8?B?enFydlVLNzQxeFBsRXl5K0VsM1drejBCZ1JMR2hmMUlvR1lLdDJWZ25GVGJt?=
 =?utf-8?B?MnV1eHEzUjVsMWk4ejFRNTlla3NjcGVaSWhmeFZpMmNGY3pERkxxK0VqWEtM?=
 =?utf-8?B?ZWdoYWFQOTdPN0Q3cEFEd1UxWkE2NDhLd3FFSXdwOThBVmU5ekxxdXFiUlpL?=
 =?utf-8?B?T0ZjMzhJS040bXIxRnhlMFIyRnp1bTJNdDIvQnh5Q1FLVUJUUXZHRkhnV3dV?=
 =?utf-8?B?ZTBldU9hb1dGSkovM3ZZdWtkSmsrQ2tZelRnZTZQc1FGaThuZTUwL2dDbUoy?=
 =?utf-8?B?aitadFJES2UwOHVkdzErV0NOOXd6NjZlc2hWQTg3ajNHbnhBN1dpZW1TVTVM?=
 =?utf-8?B?aGlxeFZ0MlRoRjY3SXoxemhtakV4MEpQeFRJenRSbjhFM0o4c25uaGdzblRG?=
 =?utf-8?B?YmFVc0lnaHlaaU94SFptMEI5bGsrbW8xbmRBMUdySjlyN1Y2SWlaS0xqWUJN?=
 =?utf-8?B?R2RQOWp4N2tMNVVJYjFyUjB2THlUbzRBc2VKSnJWZXkrclJtT05Cc3Nid3d2?=
 =?utf-8?B?VVNNMk9qT0tscUM5TTJyd28xZWM1L2hTWm5tS3p4STFQdy8zQjdsQlVUQnpm?=
 =?utf-8?B?YURta21ES291MlNCVllvU1ZSRExmOFA0VVVLNG8xYndNQzB5NGM0SWVZUlFh?=
 =?utf-8?B?aHRLeXdQL3p5bUM4Sng1QmFrMWg1K04zRHhBVUpWNGZjUnJibDZjVlVqampv?=
 =?utf-8?B?V1g2Q2JMZWNVNW5BY3lqdmNVaUJXZE5jV1g4cGRwQmhObXd1UmlDeHBYc3E1?=
 =?utf-8?B?ZnNSV1VzQjluZ2hvS1M4blVJNHNvU2FydVczazdxVU9qNjNXZk1LY0ZSMnFh?=
 =?utf-8?B?RGdKV1RZQ21pRGthRk1iaWtFNW5FYk5GekIrU1RFMkRyZFFyMVlCTXVZcUFr?=
 =?utf-8?B?eWI1WmdGZ0JRSjRLNFh3b25MeXM2TVpnN0JYc0lXRXJJMDdwclhnMVNLbzZm?=
 =?utf-8?B?WjlBend3VXkrak9MazJ4aGlvRWkxMnlNSDFmeTlTK0tDUnhwOEozZVpFVnI1?=
 =?utf-8?B?c1kvM1lmNFU4eHlHUllXYnZGL0poTkJTcHRkZ2RMNzRVUS9DK0ordWVyT2oz?=
 =?utf-8?B?amVtOXV2aHk3ZjRXWk41OUNnT0JPK2hpWmI5UThQK0IyRDh4UWNIa3A1TnB6?=
 =?utf-8?B?akg3aStiT09Ma3hjR0tHVzRkUGs4cnhsQzZEaU1KWXZSdkQwUHpveVkxQkt4?=
 =?utf-8?B?VUtSbGNGR1VBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ukg3ZXh0WElwWG0yQjQrdkYzc0NLdVlFbytVVHc5cTMxczRxb1ZMb0xJTUVY?=
 =?utf-8?B?SDJFVWNaSm4zdjVwUEl1aTQvc1J5TUVMQloyTWNlWHRsSDNnajRIZGo2YVJh?=
 =?utf-8?B?b0p4UGZoMzB3SjZZUW16VkVhYnA1cHlRajExY09NVVA0eEtnejVnZ3Y1R2lU?=
 =?utf-8?B?R0ErWnVuNHBqS3NxOGlGSEM0Mkt0djY0b2t3MG9pcWVzMkNWNkNiN0h0T0dy?=
 =?utf-8?B?MC9EdHZlN2o2dmhkck5rWFZqdzUxaDROQnpVY0ZwVkdwRVpoYmd1cE1qcmNE?=
 =?utf-8?B?YkZXclZnRGNCNXRiclBybXgrN0xZS1I5emY1MEVKTVRhMjZ3VmhYL3c1cCtz?=
 =?utf-8?B?akJKL2I4aWswc244RXlYRFJHRGg5TTlLZ0tUWER3SVVzRVhydDBrUXRoSlNX?=
 =?utf-8?B?NFNYdFBtMXBHdXpYbCt6K2lBcEFwN1VjdWtyRGNiRlQzZllGZGxCRG9UdnQ5?=
 =?utf-8?B?SXNQUGdnRGhWQVViQUV1djNCYXBCQ0FXTGMrRnNzQThwM0VLRHowY1ZqYmxz?=
 =?utf-8?B?U2dEMldUYzN2Rm80eWNqMEQ1ZWE5THEzaUhZWWNIWlZhM1hBQkZ3ZlQ2YURD?=
 =?utf-8?B?WjFkNk5NdFdNOEgvR21tNWNCUHJ3bExObjlhZm8zc0w0dGwyUjEzT3BnNG43?=
 =?utf-8?B?TFVnLzVGSW9xV29yWjVwTXpnZzJ5U1lwd3dzY0hYaUFWd3B3NWJESlBJeVAx?=
 =?utf-8?B?KzhnbHZKd1Nqa1F3WnIwR0RCb2NtZEpETXcvNXdBVENnTXVhR2Zzd2tQQlRZ?=
 =?utf-8?B?cnpJcnhUUUczWmRIMGlicnF6N3o1bFZWUlJ6VDIwdW9YTkJaWjdNbXBNVkh1?=
 =?utf-8?B?UTVkRWt3cTFPNWtPV1FndVZEQklwbEhIY01mNFg4RXEzU2pBdG5NWnFNK2hI?=
 =?utf-8?B?VWwzc1lHWWJHZjFRWStyMmRuUllnTTYyNDVCaFdFZmtvUDFUcEFFaHIxQ0hk?=
 =?utf-8?B?WEVLd2t1L0JJbmpBWE02WTZvTkppWWJ4TlRUdmdmRTZSWGRjdmhtV0pLZTNv?=
 =?utf-8?B?RkkyZmVmNDcvLzR0MmNOemRnRStRY0h6NkNWdTlCL2NCcUlkT2hJS2RBbG00?=
 =?utf-8?B?ZDdGR1lRZHI1V3BNRmFiV2NiL1JCN0p1N1dMVlR6VzJhUk04UCtxbVNUNEU2?=
 =?utf-8?B?QmUzV2VSbjFRUUpGNHdrWWo0R1dEYVdxTTR2R0ZmREtDYWZ5TndVUFd4UmQ2?=
 =?utf-8?B?TVV6alY3UjZTaC9wZnFoajFFRDJwYStOMUF2NkFxZndnNE9zMFk5cnhCeHgy?=
 =?utf-8?B?dlFIV01hQi90ZHhYODZTVWpURjRHTmwrK081Q1hVR2FDNzlpVU5yT25RK1Fu?=
 =?utf-8?B?Mm1LUEg2dFZxV01lcGFJRFJnRkdDSXd1eXFpOVBsellnZEhoT0s1N1BERG5U?=
 =?utf-8?B?SU9KVCsvVURMdVFSSG55RE5lZHlBQlZkWDBZUVNJOHl5Wk9Pem5tMUlwd2VZ?=
 =?utf-8?B?Ulp0SWtvUHErNUw2TWpmRnlmWWhIMGp4RURuaUJxWCtJVzB4QVJvdkJ0VEda?=
 =?utf-8?B?U2s3YXd0ZE5aM0JrVk0vQjVrR2VOaTBTeW1NMUc1YXhjdTUvd3JqZHVBTTht?=
 =?utf-8?B?KzJLQlFESTRQN20xWmpuS3c4NUo5L292b3dOZC9Uamk2a29ldEladVNGQitr?=
 =?utf-8?B?RTRTb0RaaVhKR3JHdnVidm1mbktxaGZBNEIrMW00Qnc4dFFzbnFCU2VzYnVT?=
 =?utf-8?B?RUhLRzFvVDJDQUVBanFaOXhvd0FFT0s4SERiSzdPemZGcTk5K2hjUHRSU0dl?=
 =?utf-8?B?SVJUMHBEOUJteGZ3UUtlUzFramFIYjU5cHVjRHhtWFMyekswSEtIUEd3WWg2?=
 =?utf-8?B?WWpjMWszc1YrUXJOQW9NOEl5dVlRbS92cVByREJMblhocHpkTEh6eE1UMnRx?=
 =?utf-8?B?ZG5HUHVWMlVyanF2YkV0T2ErZEd4aWJRd2VLOG1ENzUzdWJndER3SElVYWdR?=
 =?utf-8?B?U2Q2ZXp1eFFHTXpOcVcyaFovMis1YmhNTmpwaFlFYzdkbm1OZFNNaVJpR25i?=
 =?utf-8?B?c211bVBLTTRkVHZQbitaVEJpaHlFL2RxUGFZZythYWVoMEdpNXh6YVU5cTlT?=
 =?utf-8?B?UXJuQyttUk5uc2ZSbFB0b3d2dlVwN3I2U0NPKzFqaFViUnVjUWplV2xXN3pi?=
 =?utf-8?Q?jiMUkI4ONVJhWXmQPSYMHCqir?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uXEOj4svdh3R8fLswu50b4bhPExjsPXZecArXshr66qhAwX2/X2cvwX96oBSicSLPUyO2pTPgiOe5lKenzx9y/eugm8Tz9ZH2WqpPSo64a13mLjS3wRr45By7w/4Itj4eG/Jr0SO1KYSx25iKwiGLEIXTdahqm4g6yIs5hSZOyLXvHDo/c/bFa3mycP35KJTzXbBfIHreRihqX3pVD9z98Bk+YO/nLL+IFEfGcC8agRfX0XRxnXCO4enP9F8754TMmtCI4wX4D53GTz1WmYxPT9LSdaLpCFnba6FLc3HczdgRspTbhxlPe1dRWS/Z+orgT/iA5C9TtVNQnICUjiTeB7QioNjo44ovfbAbVZY7JXBCj16N7Kf0FoarqKGamCaBo4MJsQI5Y5Ia5s0B/nrSZ7AaTRMw8iq4izTdc/c2WSlHfi40TgksZqvLcp5cnNdtAqOGAAj1eeuss+a8n2EJYNei8poGvlmOAdTXifRls2G667YGmCfnde0gd5xTG4JsfXeFB9BC5l6vUE6rLsVMmD6yyihiMWIYzZTR+fOvg/Cxp6OD3QrYIfLwmVinFk7QRETR3GRKGfQgQDZreXykZFMMT7b/gesKUZwz35QBHc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88728f7a-63e9-4197-03ae-08dd865defb1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2025 14:06:57.0461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /SuvSJF5bXZZSxeRIVaHnHUdrFy1nXYsJ++MPfEEzoQPgerqRLCVRu4WzAMwqgfBcYB4Rk2QrKMn9D4d/WXYkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8114
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-28_05,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2504280116
X-Proofpoint-ORIG-GUID: LWC3OZabwWA2qK7g1MijT_puOaahGI_G
X-Proofpoint-GUID: LWC3OZabwWA2qK7g1MijT_puOaahGI_G
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI4MDExNSBTYWx0ZWRfX0/0n+qxIQPp1 cT/iGdLoYdAfGdJhqszN50dJrTLmUxDXcJqsyvKIcztSDnufU4DNnpJMDJX4jSqYrKkzUKf+Xnf cPZhzDQZ+/hmL3AE4PHDKxfPBYM6NNwz6rsoBjatwOudCTmFE0EU35rLyF+sIYiLaDNT+Cej5Va
 3nasVq+lcFuRC5QakZj3E3fVxs2HuvTvL0l8L+rsADchKUtoMooagdF9C57AZCArbdRa3DhDgz/ UOYUuDE1+7nYtPXVIif4/21gULBvm0e7LqTf2wlVpW3k5zrjC0zr9ssCWUKVc+3Q8hEuujphSOQ fkLZdpqFN+8HoFbJYsccYEeIPmfEoNs4BpDZ3LYHvqIMX4+Ghr6xHAxYhlsNzpvL1vO3gEU6NiN 3l8cZ8ZW

On 27/04/2025 09:29, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Which means there is a BUG

nit: to me, BUG means symbol BUG(), and not a software bug (which I 
think that you mean)

> for related bio-based disk driver, or blk-mq
> for rq-based disk, it's better not to hide the BUG.

AFICS, this check was not present for mq, so is it really required now? 
I suppose that the code is simpler to always have the check. I find it 
an odd check to begin with...

> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   block/genhd.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index f671d9ee00c4..d158c25237b6 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -136,9 +136,9 @@ static void part_in_flight_rw(struct block_device *part,
>   		inflight[0] += part_stat_local_read_cpu(part, in_flight[0], cpu);
>   		inflight[1] += part_stat_local_read_cpu(part, in_flight[1], cpu);
>   	}
> -	if ((int)inflight[0] < 0)
> +	if (WARN_ON_ONCE((int)inflight[0] < 0))
>   		inflight[0] = 0;
> -	if ((int)inflight[1] < 0)
> +	if (WARN_ON_ONCE((int)inflight[1] < 0))
>   		inflight[1] = 0;
>   }
>   

