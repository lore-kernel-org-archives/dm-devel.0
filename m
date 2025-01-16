Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6256C1DE8B0
	for <dm-devel@lists.linux.dev>; Thu, 16 Jan 2025 13:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737032646; cv=fail; b=RhWCJtzQYLhBfYjXjeKCDUMsE0koBI3R8CRJcWvEUiRktUqzpeCxHnY2bMn78ehj3p5aYFe4nqqj1fh/2tQSSk3vq749NALQHx2Mg/F8gDPrUw5ZqEFAWPwWThhkf09SPcIsNokjfleo/bM9Gs6XF+JPkY0yjSEg/l7OxhZscHg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737032646; c=relaxed/simple;
	bh=oAzM9KgXOBnVc43dwcEWFfNISwJC14pCZQwyW1aw38Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DyeuSmWsEwI1Oc6pGWY/qyeNzvgsoxLm7wQpmMOigm+hLh55fU0VADxvuk9Ks8rzUOzdG5IUeXCxYbXGqzvFXZehgLPhc2iRfFThyzUbSAbDM+zPpKsPtitHbNqMXOLPTho4aChpI7+kBys9q7pXFk1BgIu+pu52JWQldm8iz54=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DBbB+HQL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=i7XmXiRb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DBbB+HQL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="i7XmXiRb"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50GBN6tt010975;
	Thu, 16 Jan 2025 13:04:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=g7uNnnvZ7OmHQ2EzmpzI3BEbnNPirccjOj1WMGEiArU=; b=
	DBbB+HQLA3JIEOXlrKcn/gCuSxti/cCwbSLVEL+ihYmT0s1Px5Hbrc6P6Vjbqi0o
	bAHsRuiZtgnDJSDYAR0txka1HjmkKwveEQAjRknxYAMFxaksLW6eltx2LXx3PrYF
	hPXIwl+bHAdiHTuAxjTLqEBUZJJGqz3qE0u3BIoiT+/25Ibc47u5tOdELxfzV4Ew
	qLxFJ85mxH4Pkfpfoj7rjyGDuCNVzqlfUF5eS2c70r6IGLvekdMXfq7ztXvMJFl5
	RtNIsXvG+wV3+q1Eri06lXW22wdCMi+7UFt02koTRg8S9IPLuH4w1NUZeajRk6RE
	iyK0ls3bVszvSZKbo/nJPA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 446pdx118p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 13:04:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50GCUsWO036418;
	Thu, 16 Jan 2025 13:04:00 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 443f3bayc7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 13:04:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t+sXbrVELnjw0YCVOasB0RRcufpuJKhEO0+VcwSda+266nOAi7lp8+Kyyx42S2j+KpbuwUooqFvux5ysg/ASuqixAnkq4ktbVK2ucoP7QDN2HHf+EdMcrMW2i4O/zblQGCNnxNI1i9JWzHa/F5Ir6d5OBCKYRcDPb4mpk67gmQIN/wfx8gYVpyL7eaXyV3D9ZWve9zu0g4Uwjbghgczg64iAThTH9xbhZtYVaqY///YmpUdbFH40Xl7j9dm//fhYNdtJu8DHtS6cMXFSuF5MMt88fGhE0ZCcTSE6b2I10bdkYiOBdk9zOoTd1yfncl8pT4wQ8Q5aI+JmLz23OEopYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g7uNnnvZ7OmHQ2EzmpzI3BEbnNPirccjOj1WMGEiArU=;
 b=NeBtF7riYWgeq+1qNZVnBpOxZ93UmzbwRCVaWQb8X47k0IhucyWXpVheWyjqm2kJmcnU6eURry4DrWGOjP+DLtDC+cgjsla5cQABvNjpRB2gRrOnJ9k+69jJLwtedCoBUrIYpFqFPalbJhKgpXXm9gwIwyw16pdBsjb7L0jBBK8W7jBFESaK3NuoDBsj6RORIVf3VysPC884KkE8egl1vMRB/Pd4fpMi11CahajYqTHJ2foWKHLWQF8tl2aobBPiQhcU43Z1hetU6MC6N+VnPEEssF93bdegwpUL4FbTjulvz8TItWv8rtNqbwNhwUPIYzUEpDfAY2+heByyYz44kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g7uNnnvZ7OmHQ2EzmpzI3BEbnNPirccjOj1WMGEiArU=;
 b=i7XmXiRbDyYdmuWiW0fLyrOd6CESGKfDxA+dbToB5NXNS7ebyxMNIGYdTe9XV16llJS9EsbloqKVXQ4WE5nMoYpMCIzOwEPEIeGab7AjOHZZasTpUCaEKutI40V9cSMlf61QnRPM/t8q2T0YCL3m+Nz1nzdREWlErH4w68XJ87o=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BLAPR10MB4866.namprd10.prod.outlook.com (2603:10b6:208:325::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.14; Thu, 16 Jan
 2025 13:03:57 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8356.010; Thu, 16 Jan 2025
 13:03:57 +0000
Message-ID: <9384e8e2-dd4a-4b49-88a8-f15a9193c872@oracle.com>
Date: Thu, 16 Jan 2025 13:03:54 +0000
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
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <e2be0a8c-3b97-f75c-362e-2174340b1b2c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0299.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:391::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BLAPR10MB4866:EE_
X-MS-Office365-Filtering-Correlation-Id: ed6e3fa0-e81b-477b-0b63-08dd362e3cbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U2krNjJoNjl4U0FXZ21Gc0MvNGE4T2VrMGswNFhXTDhrQUc3OC8vdWFqZzVa?=
 =?utf-8?B?U0h0WXF0VE9yb0paVlJmd2o3NmFzbmV4QWszQVU3eW1wcWFJLytkUjNvZElX?=
 =?utf-8?B?UXVaWmFjc3Ztbk0yMldiL1hES0U0bjE3T2VpMGlNbThGSUNRalZUVk50UUJt?=
 =?utf-8?B?aHZmNURPUll3QldSd3VsN1V4aStVVDZXVXYvTkdKVm9JNHdodnRIK3VGaU1C?=
 =?utf-8?B?NzY5QUpCZ2xTL0Q2UGF2Q3BJUE5OM3ZTVGFnUGkrb2ErU0MyTy9aMDI4dGF6?=
 =?utf-8?B?N0FoOGJzaWpNcVp5cEQvYngvQXJjU2NkTmhkTGg4VEhKU0VRNGxoNytwRHdl?=
 =?utf-8?B?VElka3R3MFR4VVl6NmE3dWRYL1BkSHozbTkxMXMrV3RycjFuT2tWRTNoaERq?=
 =?utf-8?B?VVgrQ3prV0JLcmFadkdYZ2ZlTDlQV1ZjaXlCenRvNW12clFGV3FOYXB5MXho?=
 =?utf-8?B?eW42SmhnSy96OW1jN1oyMEc5RmwxdXZqVGl1NERad003cjhZeHl1TllzQ0hq?=
 =?utf-8?B?dStrVkEzUEtNUUVQNU53WXFXTmhCby9HM0VyVTlxLy85eFNqMG10alhNMEc4?=
 =?utf-8?B?YkVYSmJ4cmJFUnVBTXduL1JqZFAwbjJUTUlCZDd4OWUvMVJjdUYvaXo0QWQr?=
 =?utf-8?B?YmVlQUZES01iam9DZVhGbkRlejBjaVV2N2RTWC9zYmpxeEFSOTFUMlR1S2Jq?=
 =?utf-8?B?azdwNm1zVkN6dDB6dlQrU1JDUGVJOTZOS0JuYUxTWXhzY2dYOFRsdWlhb3d2?=
 =?utf-8?B?QkpyckNJdlNLVUkyN1VTOXdySWFMSFJsQzhnQzVzMXRqMjdSTFU0Ky9IcE8y?=
 =?utf-8?B?WHpXQmRlN05wc29mUUhZa3dvQU1tZUExdDl2S05ucXJZTGlSZWVvMStxR0s3?=
 =?utf-8?B?N3YvM09QSzNqVmRqS0wxdjllMlNMZFVLNDczdUNYOFlsN05JMWxhbThXSUxM?=
 =?utf-8?B?UUQwakpjMzRtaEsrREg0MDFkaEdzd0pvUS9WdEVDbHZaMUF6TTJMNStSY2Vo?=
 =?utf-8?B?SmQwTEd4MzkzdGJva01oa0NIVHVPY0xqK2Z6YVhzZkZCcC9NeXUwSnR2cXZy?=
 =?utf-8?B?WkwxaTVFVTRpcENtSEc0WjFjTXpUOVV0c3orZkhoZjluSUsxTi9VWXNPQ2tV?=
 =?utf-8?B?akpFUmNhVWxMLyt0ZFNYeUt0WWh6dGhmUnVsUzJlQ1luRlRBalN2RmpPdTZv?=
 =?utf-8?B?OUpUcjBzZWl1NWltRkNsTDNZZmtuRnlMTVF3eUNoY0ZLQmloRlZOZE1JSm1k?=
 =?utf-8?B?c3V3UmYrcVNGRURQNUg3ZWpFZFJHcFYyaHA3Q2pTNTBLNm9pK215d0xUMmZw?=
 =?utf-8?B?OGw2V2tBelkrL0tETnNnTUoxL0NZVTFKK1FxNERTZ0paaDJRNFVjK01uMzRx?=
 =?utf-8?B?NEViQzB4TjlhNTg1aUtBRmx1V1BSR3NHOHl4L1BHbDk2K0lNN2VjeDRSYlJs?=
 =?utf-8?B?V0R1UE14UThUVnlHeDdGQ2p1ekVIL2hDWHFEMlh0TDZIT2dQNXpLNXRPTWpJ?=
 =?utf-8?B?SXF3LzNpclpUaVo2aE5vRmNScVAyR2FOU0Q2clc1aTlkQjAySVpxMFNLSndG?=
 =?utf-8?B?Z0VuTjVhejMvWm9pTnh4ZTZyUjZtSHBaMHR3akdITXp4NzUvdFJud2Q2MS8v?=
 =?utf-8?B?V3dVWkhnbzFyd2NnSkxtb2o3S3lGYVRKWnZYTThaRWJYU0ZJWnRYTkFDYlJj?=
 =?utf-8?B?MVJOZE1oVHlPMzdCOXoxck82RHAwUXpxZ2JHbkFuQkc3cnF6MW1QY0ZUTGIx?=
 =?utf-8?B?NkxrRVZRQzQvNVpYOEJlTTBnZGFZRW5RS1JGOUpRUTg1WENtNCt3L3p2WUtJ?=
 =?utf-8?B?anhxNFFGcjlCTTVIU3YrM3BxLy9KSzgxNVJtUHBPOXVQblVEaGlnb0lGMUpD?=
 =?utf-8?Q?+50OsJnLSGbDs?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TEFUUjIvbEd2Znl5eDJlUGpHbkIxbG5tdTNnRjFJRUpWVHlXdExxZUo1NFEx?=
 =?utf-8?B?UVNUMmQwWjRXb2FYYXI4REh6aUJlL29RTCtDeGc1bTJPMXFxc0xrWVNXejVj?=
 =?utf-8?B?bUVONG1mUjJmZFhzS0ZYUVVpSHBoRVdxY0lTbDBqbGN2dSt2cFlTNUl2MVBu?=
 =?utf-8?B?WWJtQWpoNHVxN3JER2F2dmxzeTdiZjQyOFNWRURnQ0JJNG5CSCtWY0pJbk1x?=
 =?utf-8?B?dCtXYWY5d0lNZVBaTjcwOEtmYTg4cWVOTDNoc3lEek52a2cwSWNmRDFhQXdU?=
 =?utf-8?B?VXdraGNOU3Y2d3ZvY091anIyRlZncm9TWkh5SysrNTEyNUpzaFVHcTdRbHRn?=
 =?utf-8?B?WldORzBZVk9GRVQ5eXJzSXBOOTZoWkRaejRBVE5kL0VIanZEc3JGSUFxL2JK?=
 =?utf-8?B?QUNZUzVHVXh0RDR0R0VKYytSdzBVSXRWTTQrN00rQ3Q2eGR4U1RMVmtFKzJ5?=
 =?utf-8?B?MXAvaE9hMWtUMEtndVBSUm1YNUxkbUQ5R2wyQ3FkVnNyTTljeHczdTFSY0py?=
 =?utf-8?B?TE5wMTVLaXlWWVY5V2wrdi84UG1Ja3NqUFlmdGJuNlJlYSs0eUlSRnpPRFl3?=
 =?utf-8?B?eXJrbFFob002REdSOTZMMi9HSGtici9RWlVHR2M4UTZSS2FUMHNsNG5hM3FE?=
 =?utf-8?B?WnJKbmo0dzE3b3QrcXRweUJJS3dYeVFqY0E1dDgxZGU3UDgxcjdVV1N5UHI5?=
 =?utf-8?B?Q2F4ajd3OTh3TTdUY0RBcEdZMU5vUFNIN3QxbG5KWi96MHgvaUxwQjM3Mmlp?=
 =?utf-8?B?SGRmbzhwNXFYR2VlQXBMakRKclcxaEgrYm03RG1IeXNIR04waUpjeVpuWFVI?=
 =?utf-8?B?WFlpMkYwUTF3VS95eEpHUVp3OUVEVVQ5RXVkMG1oVCtoN2hPcUx2K28ySzF0?=
 =?utf-8?B?R2hnNWZHVmNxUzhYZXVXRm1hQ3B2ZzJmUExKNjBvakduMjg1Q3I1UHMxUnJV?=
 =?utf-8?B?SDdTaUZUTDF1bDJOU0JoWDU3WGFacDI5TGdoNWJNZjdQcTJPbUY2dkdEUmQ4?=
 =?utf-8?B?bUxSOHNKNnVVY0t3Qzg2QlhKclEvQjhmYnV3MGdpTVJyY1d6RXg4eWpRZUhZ?=
 =?utf-8?B?bmcwZDRYdGZna25ISW92VDVaRklxdStNNzl0WGk5RnZSb1I0WXdiNzRSOW1l?=
 =?utf-8?B?c2RoRUVBczMxanZ2QjdYUjE4U1hhT0l4MVZrNVgvekdtNE44WlhpL2lqb0hF?=
 =?utf-8?B?YkphMkFMbXNlR1BTWmlaT0wrdk5JWFZDTzBSOUYzQ2Y0SlBpdmNoNUdrNEE1?=
 =?utf-8?B?VzRyTU5OU0wxVHFCaVI1dlpXeGw1ZmVjTzJCL1lubFYvU3RQKzV4b1NReHZD?=
 =?utf-8?B?QWIrdVZYa0dNeTI0NGJ0QldrUkFUMVc3T2lXc1E2QW5zRGY3RnBGTmVGNVor?=
 =?utf-8?B?ZUpkc0plM3RRYU1GWUFmcElPb3lrRTk3YmFmUDlxL2Y4NnUvOG1mMTJVN0xD?=
 =?utf-8?B?TGVRVnBYOFAybVBjUVVsZVdLTFlYckpERTRaTDRyc3E2b2J4RkRiRU8zSGkr?=
 =?utf-8?B?bGMyTUV1RjRDcW9aK3JmME1CUW5XaVg3bHhZdXhOVnNBZjdia2g1dVU1eHVE?=
 =?utf-8?B?R09PRE92QUgxbEs1RklVc2c0VVlZZm5WZmV6WFJ6endCRlp3V3BSTm9pakF2?=
 =?utf-8?B?bjBpRklLVVRzNEdseVVvazRtQXFKZ2EvUVdtS1dCclcxTXc3UXVjZXBoWVBZ?=
 =?utf-8?B?cWlycHgxZit0eE9wTmVmTkRKbmdXSlJZWUhZb0J2VEIrZVQ3dDB0OWliZVU3?=
 =?utf-8?B?ckl1KzYydmVnUG1CQzlWRlJOU21rLzBHcjM1aWNjckJsWGh4azUxYm9TWjN3?=
 =?utf-8?B?dE0yR2FzRFZndC9RRFh5UmwyY0VOQUFqcGRKUFJYempWbnNQVUJ3c2VpeWdH?=
 =?utf-8?B?dm96ejNvWmNsM2h3QW96QjRRcmJmYWtud2prcTcxd3lUaWUxQ1lBcnFGM2dZ?=
 =?utf-8?B?MHZSQm9XQzlaMUs0eTE1L2d1V1RyRWdsaFBVK25ldFU2bHZsMUgyZ0ZhUHYx?=
 =?utf-8?B?WGY0eHJ1TUxzMWpOcjNEUG5LdEVSbWpISG43N281cUxTd1NLV2svMG94V2lJ?=
 =?utf-8?B?eTkzNllYazhma2Z4T3g5cW1xV3hXRDRaSEpML2ltQjZudVpyK25tZkVzejI5?=
 =?utf-8?B?TEZMSkJ6QTJ2dTQvbzFKM0JGZ3VleW52MnAzcG9pVzBTSkpXM1lxY3o0di9l?=
 =?utf-8?B?Q3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uzKV8Xw1JZUYi5x1SPA55S/rEwOn4sEMqjkzl0UMEP9m861Sr9Tfbyt8KzfbaipU+4QYtytdTysCjJpdZ95ozvCJbRTQV6PdDxZtNjRYiABSnL7bRLrR6WsE42BgEnDDzWSVvaPMwcvCbdvtvqcWhWe43LY001vaT8Pk6HTcmDXoNbDXgJvPjXY95/IFz+Ym4aFk5aW2YELjAXUfjZkitxqB0M6hWdziBHbyZ3tX49vrrQsZPVE8ZSuxRLwg15y4TZIykz6G3fVe3m8CUhxHSIzIoVf7Kp+YeG3W31cfgsSj9LNPC9fZTC5fSTKLoO5pEE77APpwts5RW0KdottO7nSOWVgIfKCi/YtD2TaLyEi5tkW4gCqpTGYbiZljqjv2nCX/2IV/DNJRUPR8Uli8u8/LaIsleONDHVX7n7FEYUXl42vWc5KGkGKrIOGuRIaEAg55x06g1NfPZjxEWYlSQpUdMTtB4gYLkoipzUpTIgKQYiioAxJtRqYD1rp8a5avfIyVMG7KT68+7bCzH1GzsZ0Spih/KXJlFisxgn0WwSKVIMujYrzfCmi8gkB1G+WDF/GWmPONnmgDbyhMmp0z0YYABw06fGdyPOyZLr9ynBs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed6e3fa0-e81b-477b-0b63-08dd362e3cbd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2025 13:03:57.3926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kfOmtUPedR14n9w7OVqDXRAC+gEdRqhkmJbppbrLBNRv/JrMLhLGWPzMPVxtp4c15TqNv8KYeYRj45cYyeG/pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4866
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_05,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501160099
X-Proofpoint-GUID: vRHxHcpKzfz2ukeQH3CwDuhIwnVYEl2x
X-Proofpoint-ORIG-GUID: vRHxHcpKzfz2ukeQH3CwDuhIwnVYEl2x

On 16/01/2025 12:59, Mikulas Patocka wrote:
>>> dm-mirror uses dm-io to perform the writes on multiple mirror legs (see
>>> the function do_write() -> dm_io()), I looked at the code and it seems
>>> that the support for atomic writes in dm-mirror and dm-io would be
>>> straightforward.
>> I tried this out, and it seems to work ok.
>>
>> However, I need to set DM_TARGET_ATOMIC_WRITES in the mirror_target.features
>> member, like:
>>
>> diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
>> index 9511dae5b556..913a92c55904 100644
>> --- a/drivers/md/dm-raid1.c
>> +++ b/drivers/md/dm-raid1.c
>> @@ -1485,6 +1485,7 @@ static struct target_type mirror_target = {
>> 	.name    = "mirror",
>> 	.version = {1, 14, 0},
>> 	.module  = THIS_MODULE,
>> +	.features = DM_TARGET_ATOMIC_WRITES,
>> 	.ctr     = mirror_ctr,
>> 	.dtr     = mirror_dtr,
>> 	.map     = mirror_map,
>>
>>
>> Is this the right thing to do? I ask, as none of the other DM_TARGET* flags
>> are set already, which makes me suspicious.
>>
>> Thanks,
>> John
> Yes - that's right. I suggest that you verify that the atomic flag is
> really passed through the dm-raid1.c and dm-io.c stack. Add a printk that
> tests if REQ_ATOMIC is set to the function do_region in dm-io.c just
> before "submit_bio(bio)".
> 
> Alternatively, you can use blktrace to test if the REQ_ATOMIC is passed
> through correctly.

Yes, it is passed ok.

JFYI, I can also verify proper atomic write functionality on /dev/dmX 
with fio in verify mode.

Thanks,
John
