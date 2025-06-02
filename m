Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EFF1A8F60
	for <dm-devel@lists.linux.dev>; Mon,  2 Jun 2025 10:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748858941; cv=fail; b=Vgov/RVN84d/+QTY1FxoCdudDiQdI/smEE7otYlm3zvfYQeaXe6EpdoIBJLwyDUXzDz/gc9A9Sr8ep12DMxXftJCTy52IvARfSSYXISXVpvYGihAV2uEzM9i7dNUK22WmRFVm0Fy8YrQQ1hJVsXHurrMzVwGDEfIOiIHxpuWJVw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748858941; c=relaxed/simple;
	bh=mg3e8NyS6AMN/gfo7jMKDFZQNJC9Asxc+vjXj3pZF2U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=i8eKg1htITk88y6Jgm9YoumtPcepe6V0YwXxYD2JDoTPvLsG+VZDO2IuCnTRkN2/2v8S9Etrv0Ea3ytpUDWmanVaOlmAHQks7gX4T8uuTKXjuwGl4hDy4tBmgQdcGZlPvMkj2sn+PkZVypG3rE1/QFyVH/yWzK+maQcOeRDogII=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CI1Tr+XX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ig9dX0uM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CI1Tr+XX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ig9dX0uM"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5525tviZ020147;
	Mon, 2 Jun 2025 10:08:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=d4TaGdXfE5w5WSIZ+yefF3LE6pfvTsKJiPgcL1XjZxs=; b=
	CI1Tr+XXmoXYgucvOj36J7FcQWvsp/NnejL8xkQv6SKHjasrvu2mPM6pqndJHE7C
	Gfo1vN4Wat9NqKV8exvdnoUC9xwj9O6Ad4RIDd44+1jCir2H1qT8YnffLfQ9lJmD
	35jVTWcT9Nw3x19NN4he7+E8xAw0MqMsV79QAFf1gdvx126YqEABvOCw7Agm8ygx
	h0swQHh3fP+hv598DK+XQMQFh/Ub9AHP5lJmn5Oovtt34C1ypoS80MyE/8O3bBfw
	BwB9tpW7LOweBMGDZiXPfk3cEiij6YKIL3dmKEMNOAMSjo897OgS89wgY4C9GoAK
	D2wG03mTanX9Wg0H3Pt/wQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46yr6faans-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Jun 2025 10:08:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5529Ov8V016350;
	Mon, 2 Jun 2025 10:08:57 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2080.outbound.protection.outlook.com [40.107.92.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46yr77scp7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Jun 2025 10:08:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f2rJlWl0NnMCWxWyv0dyYGLtuRHfr5UDqho3tEIVofNK/GEoeQoRbltucG+FI1H6OVqaws/Pa2T2SxQrFUd2r8iKAqoNnq6fn1Quco1mvXQCzEfjy1QNo+BEdoLChxmiV+uIDx01+UvoiHLjcUiUH7KC34Bsdgo4mhMkJWHY93SzMRmU/LhAnDDXogd+JXafI3nRI+aH4FQTAPM/IMG1FZaUq3eKOBKsZY7AyGp9hOS9FkQrs7XCQje7FYRSoyRblJQgMX9U2eP7WRqU4C87JIF1kHy9OPk6YKAopnLzWYTQJ1Ri71lm15qwiF+CcpiG26Hscgn/C5Ic5B7Ar9a55Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d4TaGdXfE5w5WSIZ+yefF3LE6pfvTsKJiPgcL1XjZxs=;
 b=eDclIbCr+WceXtMt/pvklYIrNWf05RZlOwiVWgj/G9YRVuLYmyYHnjxmFt/eJnrunR38UH82GgA4E77VVo6ECJ4kHsibdVLcI/jXsQpMKXw6whPB++aGPd1cz+YvOrvl+YMGt+Se7+VAm7cXMM0tJlt4s8lKcFUClSv9e7eaISBKwBIi2hcK3uSDJVXwB+lHZ40AOj1UgFfRDDN0USth+sHLIpiCAkshkTvn4nrZEDpW/oecENRmAHqsjtjFI10Wa5HmGBAKjCXnkCcBA1nqr7LEYdUdZRnV+lg4ZLb/8kIHiLGm+N7ipwC3jDBs2RygDi0qaSJjG/soBQgHu66/YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d4TaGdXfE5w5WSIZ+yefF3LE6pfvTsKJiPgcL1XjZxs=;
 b=Ig9dX0uMAegIPjKe5oJb+Cs7qfNIDAYp/b4mo7zJLWfaoMvqkAfDEdvRgcOlELomNWihHfgnL0lNXLhmJ7S2fh3SPmUduZ3e3i4Ol8SxANWneChVZ2ypUXsUgQymKgkNqpqLRtMJXgSUzOTRaL3PciUPDb6hV9G684PXjUmJ/G0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM3PR10MB7927.namprd10.prod.outlook.com (2603:10b6:0:42::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.41; Mon, 2 Jun 2025 10:08:50 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8746.041; Mon, 2 Jun 2025
 10:08:50 +0000
Message-ID: <d9d13fea-e75f-4fa4-86c8-dc7053a553b9@oracle.com>
Date: Mon, 2 Jun 2025 11:08:46 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-table: check BLK_FEAT_ATOMIC_WRITES inside limits_lock
To: Benjamin Marzinski <bmarzins@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, hch@lst.de
References: <20250530145032.1491277-1-bmarzins@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250530145032.1491277-1-bmarzins@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0168.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM3PR10MB7927:EE_
X-MS-Office365-Filtering-Correlation-Id: 1be692f5-08c6-42d6-346f-08dda1bd786b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ejBQbnNwbG1JUHlzVjNwNCtDYWliVDZZeGR5YWpMOUJKcnRuZ1FCdkpOUUNx?=
 =?utf-8?B?M2R2U3ltRnNxR3lSZ3VnVFJ6d0lFOGIxWXZqOFlnMzdpUHdVUTAxWFhlT2pr?=
 =?utf-8?B?OGZoVmhXMnI0bHZyN1Rqd2FMV3czL3NEVTRHKytGaFhYd0dUYm5aMVVpR0Jw?=
 =?utf-8?B?YnNVTUp6azdya3NURXpZVFhXMUlyRU5Jdkl6OVRHU3FQTWhvTVU3WlJpUXcv?=
 =?utf-8?B?MWtLK3F1cmpFWWNoVU1NaG53Mi9GOWRBeGVHMDAzWHRqaWkzVnZ6NmF2ais1?=
 =?utf-8?B?b1FneDF6TnFTemZUazZpR1k2RnZ4Nmt6T0djYmZKZHZDaGNlWEs5Y2wrZVhx?=
 =?utf-8?B?VFRXRk9mQWw1ZXJsRUZuVFJnUHlTeHhFd3ZQVXlYeVU3TFJ4ODllZmd2YlJs?=
 =?utf-8?B?Q1BiMnJ6dFBSQ1UwU1ZMSnltY2FqL1JJSkp2VGJFdnZVY3ArWk9XNmdXa3l4?=
 =?utf-8?B?SWR6ZkwrZlRPeHl2UHZJZXovUG9xcWhOUUlPV0VKRHg2RkoxRVd4YmVSN2Nr?=
 =?utf-8?B?RlpGUkdtNExILzZCZ0JvdzUrZ0YzQVpETUw0d3ZwRlZkSHpDUGc3MlNmM2hH?=
 =?utf-8?B?R1Q4eGozYllGZ240NjBqN1Z5TWRQN25uMi9DT1Z6REcrRS9XTVhpd2VELzJN?=
 =?utf-8?B?eklDTUFDeGs4MHAvcHJaOURZWjZvVVhiaEVMdTFkQ3Qzblg3UDZjZkF0ZDZ2?=
 =?utf-8?B?ZW5Ucng5c1pLYWNNaTg3anRtMmlxZ2JpSERCYTlDU3Z3bUc5MzdQSzdYSDU2?=
 =?utf-8?B?YlplUWlaa3UxSHRScWZyTUMwL0Y4ZThCSGMxV3FkbFFKMndmZmhQaDFScmtS?=
 =?utf-8?B?TDY1WHlNSlRoMDVRL2t1RFNub211QXE2bTJrblVHb2VaRy92Wk1tMVBUZUFR?=
 =?utf-8?B?NWNGVXc2VTUxdVMxbjhhMjc1TGdremZZMHUxOHd5RzhoUVkyLzF6QmYvWldE?=
 =?utf-8?B?bHY2eHBhL241ZFY2VEV3TFJHR2lmTzcrY0oxTVNHSTlFWGN5cjJZZmM2bXhL?=
 =?utf-8?B?SDMxZUlONjlmMCtYbjhPZVMvdTc0UVBmVFFpTlF1Z2x4NGF2TXVKSTZQSWp0?=
 =?utf-8?B?WlJNV2ltaUd2R1E3eTROYklEVVpiN2hIdnMyWmZxT2ZnNU8yK1k2RFhOamhq?=
 =?utf-8?B?WEE3aDhKTnovUE9RYmpFbzQwdXMwcm4wU1FEY0Znb0N0N1pTYlZZVlJDMUNL?=
 =?utf-8?B?SHM0Q0RMTU9IeE9aNGppOCsrMUx2S0NYZlZJcnBjbm96cmRId3lmZTdXR0ZZ?=
 =?utf-8?B?SmhQa1VqUG9jTm9rQUlnTU85dzhLYXNLcy82V3hpamtGcUJCb0YwQWdyM09S?=
 =?utf-8?B?akxhTGNPSm55RFRkVm93ZzBwMS94SGcxOUdnNXlDYjZ3U3dsR2VmNWVkL044?=
 =?utf-8?B?Yjd2bzZDcm52VWd1a3lEOG9vdk5PY2lsQThaVWFnQnJLbHRnb2l4SjFSSkFj?=
 =?utf-8?B?YVBlSHNpcy9pUlBSZDMvUllmVkZTT2xGa0d6ZExzZjdBMk9vRjBTMjRnUmZY?=
 =?utf-8?B?RG0vV3I3VEczUnlyYWRWRG1PM2lZRHUyNERrc1NWSHNhQ0srZ01XWGNEZW9r?=
 =?utf-8?B?OERXM2lxN3lxS2lMSjFucTl1eTlseVlCcTZkVmZLZmJ5bzVoMlZsRFo2OStX?=
 =?utf-8?B?VzY3cVltbnRaR1U0YnkxSTAyOGFvR2tTUTEzcFliaVpwUk1rSzgzdE9Dckt4?=
 =?utf-8?B?dTBKWmZpWmxhY3FHU28rWGJxVnhFVXhYNEdUeS9uYkRaY0Z0MXZzU3gxbnRl?=
 =?utf-8?B?bTRiektCQkIxU0VWTnFvT295cjl4eXJwaG9KbzZtQ0FIalNXcURQZDdmQU8z?=
 =?utf-8?B?UXlCZDFBZWt5Tmk3VHQ3eWR2K3IwbVJySlZQNjJJQzRjeWEyMnR3ejRIL3Jj?=
 =?utf-8?B?M3BnaFp6aURIeXJOOUJZYk9iK1pHRWoxMGE3NkF0N0k2YVYrNVlyMFlRVjZt?=
 =?utf-8?Q?up5pRGLcwWc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N1ZYNnVPUkkrWk5vdlZtTkcvZzZJYi94eGdHY1c3VHFZU1dCd3BUYS8yU0xq?=
 =?utf-8?B?TlBOUFBHTnZqTVhRMWk1YzNsYlZLT0QzNXl4Q24wK2tKbnptcHNPSnV5b1p0?=
 =?utf-8?B?dFZ3cmhPUEZYZklZbU15YWVxMHpFUlFMdC8rbUt0YkNmMjlFUUZSUUNUOXcr?=
 =?utf-8?B?QWVJaGNQQS9sam9BWjh5bGhqS1hDUGhVaHpicHRxNVNpb1B5UkNGR2pWNHVm?=
 =?utf-8?B?dGNPblNSM1Bvc0d2SVdQLzdUNis5QnNZbDN1RFplcWE5Q2s2RE5CUVc5K1NC?=
 =?utf-8?B?dG9QVjlrWGdDSnIwNml0WVFXQ2svUUJjQTR1TENCV1ltWmVJeGRlOTFDMlIx?=
 =?utf-8?B?WU1NMHBBcWR2NCtNZ2pxRUJwK1NYNW1pNk1xRVcrMnhDQ09MdkpsRWwrVWVu?=
 =?utf-8?B?eTRsTlUxVlE2aHRtVHNST3BVR0lRc3ZJMW1LT1JPbFpXZWIxcW00aThvOE9D?=
 =?utf-8?B?NUlMK1MzWm5yZkFLdjdmN1JKV3ZrRlNkNEhheWVreE5SL3l2UWVkYVI3cFhE?=
 =?utf-8?B?eXp1d1JsOGNSZFprMTkyTkdPK2QvRFVBelp1RHZxSU55Y2txeXg1VUJBM0VW?=
 =?utf-8?B?S3N0eFBjSitkYkl0dXcxMW93UkdNUFMyTWR0SDh6blRFR1ZZcEw1eW1zcVVO?=
 =?utf-8?B?Qk9hSlJZMWhvM00yUXNCZFIxYWxpYlVyRWdjVkxmbmhPaHZod0lWaVZBK1Ju?=
 =?utf-8?B?emUycE5JTVhFMmI4N0dWVjhXSmZ5NTNCUDIwcHlRSjNDV3dPZmNlS29lUEoy?=
 =?utf-8?B?NmRSU1czSy9MMUZpY0N4WWJQY3J6ZzNQN0hXZ0FoSjAvb282aE56dmR6Z3B2?=
 =?utf-8?B?V0h0T2RzM3FsVkNvV2ZyVlp5S0YzTytoaGhpUTZxUGdjKzhROENWeW43aVBE?=
 =?utf-8?B?a2crZjhNdjViMVQyTWdFMFJ6eEpMS2FSRXFiQmRxNEduWUdYUHZHeXdoQy9a?=
 =?utf-8?B?VmE4SmhFT3lNaGFlMUNPMGY3azFEVTQycUNLZy9xa0RlcmM0MmlmbU4wMkhv?=
 =?utf-8?B?eEhCZ3RSM2J1TC84ZlhHaXVNQTQ1VFlOWlFUdXpZTFBucERxaFNQUnFIN0di?=
 =?utf-8?B?TkxrNzNKNzM2WnhEcXlPdXlQZW5DVnZjT1h1by9NSzZPcTFRbzQzd1dYRU9k?=
 =?utf-8?B?VUpyRVRvU3NhSUF6YjdSNEpYUlZnUll6cXdwTkpVUG9NQXVqR2pabjZibFNJ?=
 =?utf-8?B?bnRQWlR1L3RTcjJUVHRBd2pNNTBMbmQxL0JqYWRKMTJMTnJ6ZnY3QXhubkJX?=
 =?utf-8?B?L1k4TDA5V1dyMkNwc0lvUThCS0JGTHhsYjJ5RHNQNW04WHJyU2ZKMnBtbGoy?=
 =?utf-8?B?OEFJUUtHa3BVMXI5RUxTSHNxdGo2SklpWmdhTkVaYmFaTnltUWtZaG1ic1Qx?=
 =?utf-8?B?dE0yaGZ5dzhrazB1NC9ITXFkZ2xVNUZnWXRWcFJSM1luc25Gc3ExQ0liZDAr?=
 =?utf-8?B?WWUwZFl0V1JvdjRPODBZZkZ6bmpiVXJSNEduZHpneFExbTBlcDVXckR3amNK?=
 =?utf-8?B?R1YydnF2Vkp4YThueEs1eDNEaEp1eEdPejlhMmpJS240emd1VHhxMWluRGlp?=
 =?utf-8?B?eHk2Qm5UMzIvWU9IbzFoRDk5elI4NGxhYWd3cC9seEpDTzdrTVE5QkhpQWps?=
 =?utf-8?B?UzhNNkVQVmdKckVsbVJIeEZZbDltMzgwZzZLYXpQZC9GV0N3WkpWMnltWjRQ?=
 =?utf-8?B?M2gzbGR0MGNYelpVTWpiVlYzekpGdGF3V0pIWkJzVHFaRklBNTlsOThMYm81?=
 =?utf-8?B?aXA0T2p4ejArbW91NDlDMHRvY1hVSmRDWUc2T1NXRWcrZjUyRHBGdXE4VnVy?=
 =?utf-8?B?VHBlU2JPaXp5dFZhNHFJL29STzJFeFdEN3A5cHZJcFRqZWxMUXd3ZUhlNjJw?=
 =?utf-8?B?Z3gzM2cycldJTXdLUVJmRFpFVDNGbkZKeVplWkxReldBcVlneXRyYnJFV1Q4?=
 =?utf-8?B?aEhwSHQ5V2JJelhHMklGbDEvcjJoZDhFUzY1Rjd1Z2ZkaVNiZ3d3bXUyYjVu?=
 =?utf-8?B?a0h1YzZ2Qm5aUVhkYkdadnJ5V1pVQ052K1kvMjhDZkZUZUdldGZ3bGJqWUNE?=
 =?utf-8?B?SjdZNi85bzZhdjhGdmRGbHlHbmpwRFVnRVgrMEs3a1l1aUtOOEVYbGJaSmMy?=
 =?utf-8?Q?SA1ZNbwf8LQ2CbieueZKVO6Tr?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xVQHDkx6GMdiW+g7o0pbwe+p1VxLCo4hrb6NlcMgFcrzA689oSh753DPjbAwAJ/WiQ+2tcr3g6TDzUkbS5vD92Am4OdrpLUAKshvHOeTKSHdMCa69vtMXkTpgbIYz3nnnN5rJ5WnWFbOTqD369j15/eazU2n9E5l7DoO95hKNXAaMuQ51mKzabPlfKNkl6Dd3qYSvy5pHkvkA+dEqZwX1fOuteYiLG7Quvn4cOG8edAjFiWlefHTcRS7WwLS9YsKwU5d5V1F1i0MIVcLEpLsbAVNm46uyOlbpua/y76qVNYWIBgNOsZDYX0LncuAF3kecJVyA95Bh88XWSwiC6MmszozAHewGtcxxWo1/3QejT4AmvJaxSwyA73SHaI2GrPN6aLNd8LAU3Q/mzhWC/FXTc1p/GSRHWq2XWZwJl6lAofuCh98nEabM8mmH4VvytuAD6AluJXvP/vUKrWR5ejslqohANkV23QJhmEtvkP9EIJLQMXlzoUyk4VDBJlIwq5nhHqcl+lgFyyp9ag1QyKaF5Tm//VtfYgPUZzxSsPn1AimnZDWRMGzCeqxqhBt7Zlt54UNiisTtI7mu19Tcf5lwq0OY2typM06twuPwLwGj4A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1be692f5-08c6-42d6-346f-08dda1bd786b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2025 10:08:50.0015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YRD7VUIaPHSwRjAyzouP/T2bbaUd+YRmjAo2rgTK22I/MvxFELV6EpTWYFDkAFVyTFmoo2CluoF9KBMhPeuFww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR10MB7927
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-02_04,2025-05-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506020087
X-Authority-Analysis: v=2.4 cv=G/4cE8k5 c=1 sm=1 tr=0 ts=683d783a cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=I6HSgfU79e2sXK_uDBEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 5tPJ8-chxXswmyjsHIENOAeYP208Pkn2
X-Proofpoint-GUID: 5tPJ8-chxXswmyjsHIENOAeYP208Pkn2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAyMDA4NyBTYWx0ZWRfX72Hkpa5MJDGe znACH8CbKe9vQo1utAvD7DFWGPoc686fhO3HJGULWYegZYV0rI+/9Au8WS2HeYSCCl2+DJYfGjr JdPv3ZKXHlqBziQpNS3pI6Bcea5RSkpuD+Ze6rqd30jAvsaqIZxgRHNGGjxm7WFbI30a30wjt/O
 QwbmV1u2XZTMxo83QiCIUi/uiza72PdZkYak38W9MTsca/EbAbwT1S/rZYoyNLcTaI2sf4aUM3k r/6fSpkMPQ2Byz40+OFuG8rdCwujfqGnSKqS/fEnLblxkwQgmvJYvDj2swBbFn/RTsvehNInGRC +qxnDbae1psMnAEwxx5i/EuCLCk+VKCShDNwCykbeW5gkV5GOkP509tlE+tlUhhyKptj89P3s/7
 oEIkC25eI6CxjdR25ZE9856tsGzu8OxKqaKGLfnJ1OfUjO8Xx1OjDf+Zk4g2Q+y/sM28gjK8

On 30/05/2025 15:50, Benjamin Marzinski wrote:

+

> dm_set_device_limits() should check q->limits.features for
> BLK_FEAT_ATOMIC_WRITES while holding q->limits_lock, like it does for
> the rest of the queue limits.
> 
> Fixes: b7c18b17a173 ("dm-table: Set BLK_FEAT_ATOMIC_WRITES for target queue limits")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

In itself, the change seems fine, but I have doubts whether it's 
preferred to even grab the q->limits_lock outside block layer / its helpers.

And, apart from this, if the bottom device limits change later, do we 
actually trigger a top device limits evaluation update?

> ---
>   drivers/md/dm-table.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 57573e8b5aa9..9f95f77687ef 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -430,13 +430,13 @@ static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
>   		return 0;
>   	}
>   
> +	mutex_lock(&q->limits_lock);
>   	/*
>   	 * BLK_FEAT_ATOMIC_WRITES is not inherited from the bottom device in
>   	 * blk_stack_limits(), so do it manually.
>   	 */
>   	limits->features |= (q->limits.features & BLK_FEAT_ATOMIC_WRITES);
>   
> -	mutex_lock(&q->limits_lock);
>   	if (blk_stack_limits(limits, &q->limits,
>   			get_start_sect(bdev) + start) < 0)
>   		DMWARN("%s: adding target device %pg caused an alignment inconsistency: "

