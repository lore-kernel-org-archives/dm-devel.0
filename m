Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8497B86349
	for <dm-devel@lists.linux.dev>; Mon, 28 Apr 2025 14:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745849035; cv=fail; b=g7HCIyPwWGL2VYSiLFkWnRPypJkd6KcZZbVZaI9ZQyL5VaBn7ZBQ+Y7oPP0Ylvri7FRdD3LHFU3Rjluf9S+mMp+1TIxid8bo0N/SVgoHoDBLEakl4iiPppzyAr+BDZKZFxGNJEi0A0c2FnvPFw7DDHweLFLMBB55n5tZ/yncifQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745849035; c=relaxed/simple;
	bh=kvj1mpfLL30kxrbPT/GUL6BbiVfpO25Hp7SEZFoTAWE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tWxsjdvJSSemRyvMS+KDDhKL9Kcgc0rhVY5BD2pN+QRiKhKvxXcyX40fORSR+iKoH4U/JeM+88F9CZnjJ/m14XYdsMdUVguW+P6DSCy3SM7k5QdoSNHJOKMQOUvzmsjxdpYOuW0tPBg5q+uRd9+nFw1vVVBY2yBWE/F2mLTI6ng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kYxjr1Do; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JrcS7NF5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kYxjr1Do";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JrcS7NF5"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53SDqAGY017722;
	Mon, 28 Apr 2025 14:03:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=pVRDD4NwcrLSyrOXGIU0nnQwp9M1tFsAT3/sHZ04zvQ=; b=
	kYxjr1Do2BaKP+Qisc4NnvWcjayrn2FcLOuHjaEEJkik+XDA1MitWpcp0xmGYK06
	4kUpwVHn1kQjnjVeMzfcIJY+0CspDmIDgyqiGKuLnKhVuZI1oUXOOTI0BsotyVLK
	x385wfvDukuuzkOzWJMsNq0c9h9C0IkHHbm0zT2ZaqwQo34AeAIdOrTj8rXtDY4C
	sSszPe3yaFvP7HUdd7JWYPaw3z2yze7BqguliWMwZsXaDeNaQd03FKBiNAqT5oR9
	osuQ0gxZ0BBcu7fx3pOqYhwQvOp4BKFb3cmAuhj+i4hC83cLott1KCDmHmAgQ6CL
	DvYPoO0b5BwmFKHK3hBMRQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46aaxb00yu-9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Apr 2025 14:03:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53SCW6RS003870;
	Mon, 28 Apr 2025 13:47:32 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazlp17010002.outbound.protection.outlook.com [40.93.11.2])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 468nx8ewhh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Apr 2025 13:47:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KqIyq0ygqu64jFfFyN58jiikQuqIolFDHpS/+NZv7RgI9RpCbXkQYTf37oOvLlgUK/IQp+kAG1T+DxlzqsBc7lMMVZ5FnlVzoQBWEWc5ZrIkuuQTJQocAagPGJ10zyY8sONzJHEoP2xrBqfBPYrLvEMBWIE26h1i6Kfh+AZEPm3BeVy0sWR4bkWxp2/pvsQnugKaQgcLvftCUTYdVLdp4wsYubC+WPehPHj8wDTXbqBbPC96CaVFpj+Vom2amCHgOuojr3SwPJmXLvYOx8h3hDoYoYp+t0qQ55v87uioaenWxxo6pahlr+T89F0WNxewTFFYsMvyUwYoamKidAaOSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pVRDD4NwcrLSyrOXGIU0nnQwp9M1tFsAT3/sHZ04zvQ=;
 b=oTrlYBdGp48kRBf7AwP6OwMWpWOWWm30LJ0Ki6eYSwcJiZrWmeHh9YXANUasVHH3hpHDdRw8OzM6t0/27o8QCZWmR8Mx8rzkUeZ+IuzwN9BfyGaZviJ+aS/fha0BmCjrQxaxyfGeUBOHV7rjlN0k4AbvzJ2XEF+E6qAN5PPY6Nhcjp7gqMh8IoSDBhb7QD+9NyfkeslnenzWeaaSkwRBrRmloR2lHDSli87rxapB6G226Wag8+hV9uQ9b/7t5xmQTB4E7upbu86266LZWbZauBnZn+mWKGXfmjj1yc23sL93ETuUdoYX3riNZtNwp1F3mSKFDyVGwX5L/pwZif48iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pVRDD4NwcrLSyrOXGIU0nnQwp9M1tFsAT3/sHZ04zvQ=;
 b=JrcS7NF55LN+zIs/eFCmn0rhUMfD/c0a2TB2CFJu4ub8u7XfpxbT9SZq8mzff3T0FSfGKZ3TvnqiFiDSnYceP2EY3jfn7QvwXznhsB/Rq2wCh1aeYNKXWbtF8zHA8PxUtMppSzbPumVzI8VN1qd7bCTd6+bHCviZBEtYdMm+fyY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB6629.namprd10.prod.outlook.com (2603:10b6:303:22e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.37; Mon, 28 Apr
 2025 13:47:28 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8678.028; Mon, 28 Apr 2025
 13:47:28 +0000
Message-ID: <e6d80355-62df-4ff8-b352-825dea059ef7@oracle.com>
Date: Mon, 28 Apr 2025 14:47:23 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/9] block: reuse part_in_flight_rw for part_in_flight
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@infradead.org, axboe@kernel.dk,
        xni@redhat.com, agk@redhat.com, snitzer@kernel.org,
        mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com, cl@linux.com,
        nadav.amit@gmail.com, ubizjak@gmail.com, akpm@linux-foundation.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
        yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
References: <20250427082928.131295-1-yukuai1@huaweicloud.com>
 <20250427082928.131295-3-yukuai1@huaweicloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250427082928.131295-3-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0125.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::42) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB6629:EE_
X-MS-Office365-Filtering-Correlation-Id: bb3edd66-589c-4a17-fa71-08dd865b36f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eXQ1b2pnSy9rd2wrOGxaQlVjVDlLcSsyRDN0S0RDb1pOT2tMQkU0WWRKa0JU?=
 =?utf-8?B?SERjOVovUFNTMU8vVHg3cVJuTWdUVGhzUllOSExQRUhtR2tHZEV2ZDVYQ0oy?=
 =?utf-8?B?Tk9keks1OXdMVnkyOGw4TUVobGczTEpiQnFCNnM1T2xwZDZucjZmdWlkd2xQ?=
 =?utf-8?B?WVVlL1ozUUZ6TVVnWU5lby9PKzZOVUhBc2VTOUpoZjFEd2VwdVhMT0FQNWdj?=
 =?utf-8?B?c3N0d2UxSDcxd016RjhHdGdOSm1VQiszS3B4b2l4T3YxUWgyTXpiOEtSamEz?=
 =?utf-8?B?M2IwYTIwRlB4VVJlWE44T0ZhVHMzTnY5K1JDK202RWRhME1zTS9jTUZQdmNt?=
 =?utf-8?B?ZDBpcGlVK0x4SDErU056dFh6NEJjMk82OVpRUVk2bUhxVEJjVWNxamkyZTJI?=
 =?utf-8?B?dmxIeXFEYUI5YzByTmdFYVdhUDNRZTNTWC9jenZNb0RUaDJ3M0VEdXlCNHl2?=
 =?utf-8?B?UlRxWmo2OGxiR2lnQWhkMjNneC9XbjY0RUd6ckxPNUJtRTJVb2V0TzdraVZU?=
 =?utf-8?B?R1RZa3MrbHI0a3p4MWpBYlRqOTJhVkIxQlR4Q2lZazE2QWpzSG5kRlpiWUVZ?=
 =?utf-8?B?djE0WG5aRHgvaTU4cE8xeVVQSDN1MWNMeUVmNFA2WWxTTWdhSDBKZ3VEV1VL?=
 =?utf-8?B?ZHNKc1haN3pzemtlNXZXWjNLTXFXS1NjSmFMOU4wRWZCbG5ZRmYrZ2RxK09v?=
 =?utf-8?B?dEExNUxkMm1rV0hsVGFwb1g5RENIOU5FOElwaE1HYWF4TTd3bmpoYTE2a2hL?=
 =?utf-8?B?Njc1eC85Ujk1K1FnbWE5UFdjODhGdFFudzdBR0RvM09NYTZ1SEd4K2srcmk1?=
 =?utf-8?B?UmNPV2kyWmxpZ0ljRDhiWTBPZ2dYYmJwRTJRU0JFb091V2NJWDA4aURJa2ZG?=
 =?utf-8?B?YlRFU1FQUmVoSVgxYmgwYWNJQ1h2QjdRRGdmWEszU2VFVTZGWEptMzZxNHVB?=
 =?utf-8?B?NUV4eU1CY0ZCK2VYanhseVB4amN4bW1lbVB0bTlXVVF5UlBFYlRMNzl5NVBC?=
 =?utf-8?B?NDJ3RmE4YVlYM05naEF5NWExQTh6WS9EcjB2ZTQ2RGxxRFFHOXQwbW1sNExx?=
 =?utf-8?B?N0ErdG0vL3ZMWWo4c3MvbGhrVzJsTXNrRVJNWm9jTU9Ha0Z3YUFuayt3UHYx?=
 =?utf-8?B?VTRrYXllcm4zZUFQMFRGUzZFeEd1WVBDSnVtNU9xRWM2Q1lHR0hQaXZkTDVW?=
 =?utf-8?B?dmRGQmU0YnFLcEc1dE82bWRnK0Z2VzhyOUJHRVpxdHdEam1JUkZieCswWE8r?=
 =?utf-8?B?eFowd2tJZGZ4OE92Z3dNdzJjcHVCZUZUS2VZVUxBcTR3NHp5bHFhMXdUVStT?=
 =?utf-8?B?b1ZYb1VqUGIyVCt1b1h4aXBwNFpJYy9Fb3RxRmg1WVB2ZFp0TVBhc3dJTzN1?=
 =?utf-8?B?bzdFZW45QUVaTmFVcXVYell0RzVsbEQ1aStuVkJlSFM4YXJzMksrTUJzaC9Q?=
 =?utf-8?B?UGx3RmR1VHlEL3FPRndraGsrcVVMMjVISFU4dGxLUW5Ra1NKZ055UlBTSlJN?=
 =?utf-8?B?RHNiNGJSeHhteG5vSlg3djVrZms4cysxMXRFUU8rU29lcVhFSHFlZ1AyeTR3?=
 =?utf-8?B?ajNiK09QYmdVTGtabVlWYW5NVkVaVmVnRTB4VFdScXhodGljcUk0cnAyNi9i?=
 =?utf-8?B?UWpadTQrbldWLy9iVjAzc3BzZ00yQmJZWGYweWtNV0lWTTJOK0FOblBFdUoy?=
 =?utf-8?B?VHRtbmxBRUhDVGtBZVUwZXo3VGYvSkErR2F6RXFUWWhEL2RlakFzR3VUd2Jv?=
 =?utf-8?B?Zm1ES2E4MmJrTVRyaEZpank2ZkVKYjZjUUdpekRnSUJOaS9yTnFsaWozVmlX?=
 =?utf-8?B?MHM0dWtTVUR1NndpRm9wVTFxQzJIUDIvcWdlbjNVYjYzbzJCL3pzOVdLWUha?=
 =?utf-8?B?NXhUeU9VZ0VjeC9SU0NScytFcjhFQk1pU3Q5MCt0SWc2bmxhaEhNZFkxV0NB?=
 =?utf-8?B?ak9xMmp6QmllRDJLU1NvWkd5YnFvdFAzMHFuZC96dVMyK2NSeEZDKzV5d2Rr?=
 =?utf-8?B?dGZ6Q1E5bnB3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UTRwOVNYVVQ2aGtUOTJxalVXWDgyMFcwK1VydE1nak84V0Ryc09VVVRCMXQx?=
 =?utf-8?B?UUNVdUlEUzI5d0VxdTZkZXFwdUhIdUFLNVBDQXVKYUt4OGRWMkl1UXNuNGE5?=
 =?utf-8?B?KzRRR0dzUjFGeThWZVB2Mzk3bFZLdXNGUVpZWG95SzBTT1ZuVVF3bms4eEtB?=
 =?utf-8?B?YVd5ZVhvWnNwQjQ4Y2Rvc0RvRU1BeVIyTE1mVms1NzZkcExMOXVDeSt6T2JP?=
 =?utf-8?B?Sk5QMXpnZVd4cW05N053UHBYOTJpWFpEelpjY0hjcDZQR2hJSnBPdmtrU1dt?=
 =?utf-8?B?SllCb25KVHB6MXhIeVhYTkp0UjNTcFdCQitHUnl0aEt6K09tcnQxeUllNVhG?=
 =?utf-8?B?RURFL2NlR043c3ZLMnN5cDdWUzVWcVlsWFg2UWlDM2dkNE9GSmgxY1NvTlNT?=
 =?utf-8?B?cmJmenZJNkxiZEJReEdOcERTdDNsRGNGVC8zNlZMSjRleDB0bmFEL2FRc1Rx?=
 =?utf-8?B?M3FlTTNkWG4zeHlQbENSY3VyQnhIK3hiOUZjd1VBVkhOM0V3MDJ0aTFwc0ht?=
 =?utf-8?B?S0RnN1lDRFNwdTNjdHgwam5hSGY2S1hGUEk4QVBIc3FWSWFCUmJoeVpDU0lY?=
 =?utf-8?B?OXp0OTNhb3c4KzVNZG5DQ2VpZEdjSklZVENPblZNeThPaGVYbXNaeXZNa3dQ?=
 =?utf-8?B?NTFtcmFVaGJZZVQwVzVndnJKNjRkSGVQZkpjb3JLRm01VHZnNVNzaWU2SHhq?=
 =?utf-8?B?cUdsVzg5OThIbFBNTkNieGVGc3BKUlRnODN5RTBZT1Q3LzBVMU9TWDc3M1pH?=
 =?utf-8?B?WTFMSEdiWkNtV1FYMy9rd1o4OTlmTnVBVEtVR2E5VEZRYnVKTkpWOFFiaVNI?=
 =?utf-8?B?WFFOMVhhcW5NWWdqblByL1E4QkxaNkRvVkRob1pIbVh6VjhRRVhQZXRMc1la?=
 =?utf-8?B?UlJPKzdOVUc0WVoxL3BrMmo0S0dJeWtTeDBoSFJpNkFNVEZWVW9ESjV5WFJB?=
 =?utf-8?B?aW91M0FrU204cFlzc1psOEd3eUFtU0V1SnpFdGJYQVljRklqTzREVVc0blk5?=
 =?utf-8?B?cmdtaDFzeEYxQ2FqNENLMGxmWVVkL3RaWGRIbXowQU9CWEtKaTJsdzNUY2xr?=
 =?utf-8?B?SWVOaHBhQ0JWcWl5Z01tLy8xRWJNQlBZTlF5cmNndlJpb3FzQnRGTWNPcytv?=
 =?utf-8?B?ZlRwUFR5TElQeE0zYzBYdkFaY0xlWEZ5azFIZ1dqQVhaUWpLay81NFpYUE5p?=
 =?utf-8?B?SU0zVnlHRGtOTjV3UVBrak1ZYldRMWFMMzdFcTNZNmpDVmpzUUFySVdLcjNR?=
 =?utf-8?B?MDhKbXYzVHVoUzJYS0ZEZGpYcHJwMjhrZU5HNWtNblVZZVF2YXlhS25zZ3Mr?=
 =?utf-8?B?K2FOenZTbXNRTU11MS9yUTZqTEhBdm1IRnpVSVhxNmk0Z3RpRFVRblJDRmVY?=
 =?utf-8?B?dERoaTFGNmowUFl3L1R0RzU5RnF2emQ4QjRTYW5EVUFHZ0pEYWEwM3plZ0l6?=
 =?utf-8?B?UE16blgyUkgzSlMzYTE2dU4wbjlHdHJ2ZXgrR0hnaUNMdDlIUGRXbHAwWGY2?=
 =?utf-8?B?eS9QWGtFOVNEZVRhQ0tVQUF2L3NGekVpVVFHRXArVTVEcEJNZytqMTE0NGQ5?=
 =?utf-8?B?bmhtdS9tZXJtSVR1M2xxVXIxQlU1QXBRRmo1RjBpQlkyUFAwcENnVjh4dE1P?=
 =?utf-8?B?bzhTZUJ4aU5xOUZZekh3MlM3ODduNVV1R3NOSURCaXNVc3Fab2lJcjlWdlZV?=
 =?utf-8?B?S2hiVGovNkpMSllndThJTm9XUXFFUjZpTjlKZGRCWEQ0Y0syYVlpUUJ2SWE1?=
 =?utf-8?B?cFRKTXpKeDVCZG9rQWtrdGxwMDNZNFYvYldSS2Zvcm9Dek9GWlBTcU5UeUF6?=
 =?utf-8?B?ejZCYlFmR3dqQmh2UmJJQkNSZ3o0NjNMUXZEcnhVUzhrQXpPTHRyZlBzZ2ov?=
 =?utf-8?B?SHJ6NlRFTWUrN1FYaElKMkVRY0NqWXRUT2lYbkplWFF3bWlGdFAzOUE4c1JS?=
 =?utf-8?B?ZTA0dmkwUzVXNWdpYU8xN3dZZjdUdjlEVmpjbDlXc3dCZFlqSng1Ky9sL3NJ?=
 =?utf-8?B?Zkk5V2RNS1BtaW1mL2lkT0o0U0R2TXFDaXFXUFlJS0dwYjRveld4aE5xL3dT?=
 =?utf-8?B?bHBpZFBaVnozVGRaUm82dVU5VkhvVkhob1JhQ0ZOSHJ6YXFaVUNWSWhYY05L?=
 =?utf-8?Q?usxSSNlWzrzQqjoCcJqESC0MI?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8dKs/abWLftPaJGb0eYGudds4DHrdr77misYaoIN6VMFqSemtdGa8UVDf5cENqY/r0jZi/Scuscj4jzJogjFhw49LtJIZPpcU1MidijlxZm7ZI98vEJDNW8IGbcqp8Dq/MizEgbRW9A7H+80wbAKYlGd8nUI6t4+UXvRPu/G4kGmORxYUfR1FpV+GCZh/V6362PyBWZHu6v7rVCqeahxTunMyLJlntTs5bVKOVgTxDFJ0+McgSkjNfm1XcmRVVa6n4HWs5XX3Lhra9sL6hwVVP6+Q+dZu0oHIQnpWB/OY087oduE/Mn3SywibqH0Obc7aMmQZJ7YSNh9lFuAqiW83vuPZreSdhGS30V2+cgT3Ghyv+Wwhe052yQiNq9hGLvlOZLIq2n8Ay6T6xDWjx1SACxf5fRWqbjSx0ioVlBtxBk01/TD0/sKlq02qxLZOzRJ6simp2Va0+jPdCs9aqOvQkLxSgFYn315Y76VLG55/ZRto/q0nGNyJpAFbL3RZ29mYHXZQz7vbsMU9LaefXiqnklZW1P/9TJH33oE3Ev6LKkufwmy7B5KuLuSeBMKIzpkVn3jFYc8dpbCiVNt6WzxtIZ2xHZE66d3J+tUlISyZq8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb3edd66-589c-4a17-fa71-08dd865b36f4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2025 13:47:28.1432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3lzWbDu1E/2lwUy8A5pSzhXLyCtlWCM/yFuoQNLt4ReX6z1PZTcd0Q9crj1DgDPsy3zeBzlidrKERasBas9SgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6629
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-28_05,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2504280113
X-Proofpoint-GUID: j-B_naoyHwQEShS7EvPIPnJ3zZeHN_1y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI4MDExNiBTYWx0ZWRfX+yXpZgSrQAkQ NY94Zkqm1k4nutbFoI5wgpn/Sp6QAvu/VLy5MpD1R0O5po1zafk5zLhLYsJRbiwI+o+PoWlsrWk FHD8BwroT4gT1G0MqPAKDPtx/Jgl3l7f1p3c2JWvxgcxTqaEJ1QbpLhtw+8TuttFEqVMq4qepl5
 /QkbM409ga/9rCT9T3MPUpHVJAXYo5vw6TAb2Po2M03gqktgkqs9YBwf9W9tdMX20ipweub9jWY sctWnscXX++rm52hOK7aG9xx8Rnp2jMGYHxP3ZncWQ12ORFZidVVTh8JOPZl2GyVJZWUiGSzot6 /pzmeTZzPaCL4XnwXrmKeUEMAjlQMwakjRHR7BVMKWKzmt4ckEhlDN/DL959+IkhJdCYyUcaylF nilP/jSy
X-Proofpoint-ORIG-GUID: j-B_naoyHwQEShS7EvPIPnJ3zZeHN_1y

On 27/04/2025 09:29, Yu Kuai wrote:
> From: Yu Kuai<yukuai3@huawei.com>
> 
> They are almost identical, to make code cleaner.
> 
> Signed-off-by: Yu Kuai<yukuai3@huawei.com>

FWIW:
Reviewed-by: John Garry <john.g.garry@oracle.com>
