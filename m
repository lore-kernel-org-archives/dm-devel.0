Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F2322FDEC
	for <dm-devel@lists.linux.dev>; Mon, 10 Nov 2025 16:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762790778; cv=fail; b=PPpHOLjn4YcQ2KaROLWV5D0ms+eku9EUcdsKFJrlyOl3ZcOCHrJc3GIB8efERMygQEPWPNh+dja/Bv0nRwH4bHAAiaK6GihvBhwQ7ZCY4Mwl66i552dyFA05+M7OcWHKGk0mxcCdVPsHy7+4DQ0HTUQQFJoLxBgXsiHrGAgjha0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762790778; c=relaxed/simple;
	bh=dDS7bIhPkjoQ+xc3M2tYIAm/a/EfW8gVMEin/eNJOUo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K9mPITZDiBomc11rmryCRpFBA7AVYtDXC53f6aoNKmdTkuU2Gak8YeXAT/Yjm630FoOWc+/QYFWctoO1qBwYDwYBzpZqv71qnkbaohvv1GCoJ6qSXN+JX6KDUONly3qTfLYiEzwfGDD0Re6j58cGxCvoiSFyrKNuoYg59G8C8TQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GR3yB0oH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ao6+0U8W; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GR3yB0oH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ao6+0U8W"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAFFB0g005579;
	Mon, 10 Nov 2025 16:06:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hB5ymLLJS5Gsqb164Mx9W7FtccpQc30Zis1VEsyjVOk=; b=
	GR3yB0oHtDI2uktOdFdnmSWYYc9sXZUtS5XJyc+aIeV6lvi7W3KK0+PiCqrkvCKI
	UKfzNetvr9ptn1sGA9TjqAbyRp5tLAkGrRoGUNBK35dfKCdAyaF4duNJ1O2gpsLw
	zbC4a6v14tJ4q6r+BExtfjzeLOciSyv/kGqjeaI4QctH3+fBhYLMBuqEx2QnFd9x
	Z7pqMmEHer9nsEsYl6emqRZuq7zP3W2kHgBsv42osF3d6ayHSqWbbO5HmTlSGlpw
	fqFAFT3rPerVtmj3ERWzk8M5IebctxYJawAiN8xrXO7PfnikioZZM9FEunan0x81
	wWheFJjgUNAQ/Ii66OYKpA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abjhbr49n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 16:06:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAFa8Mp000748;
	Mon, 10 Nov 2025 16:06:13 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011023.outbound.protection.outlook.com [52.101.52.23])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vacbmmr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 16:06:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pC96Xmwi92noO3/Ejskmeno/QoNU2KmWx2jvPyZj1d0rgqAMiYfDiS5wd2hFu92l/2kFZfNBEQkOJYSh3iwg9+z4fL2q67JoZ/BiEruGR7f/1NWr+ipU5yyvz2P/pDOClqSxALlcbmb4CRab2ec9ryKGuTjJsxZbQ1L5bZrnnTuVpwuCWxBKCGsbzC6l/Ghq++jj9WMFkMWjXZ1F+U/6gvDc1GfLrPKv5kPXEx0mMGOL8LDRg5Nl6jj/0jCQ1Y6mpjpMowjg3Ib+v0h6QDoBLypj48vW8mKuBYlOFzYTFJNYNCDCL5TnPpFzlD+pOWVn62ra9nP6/z3Y0b+mP2eRwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hB5ymLLJS5Gsqb164Mx9W7FtccpQc30Zis1VEsyjVOk=;
 b=icd8IFqCs/8Yu80urBP3JZLMhiwpxIgEqHf7OexTIz0MEqhpRZQx1K09AHKglNI07OkIh0xWw1ujmTRcCRMvR7HQ+kXQv34TLTiswUtemrdCRf2J2EIfsfxmuC7mQnylqKCjWYH4sJYJp9JsrS9gEJdUdkbhNcHdrivJ01ghiwJTgucEeZ5TAyqPlGuBqh/6TGly/dZBzI9RXAZwpn7l1WBl+SxzDyCFuqe8w95eBuXjvY8mbkC6Lyoow+xduhsPw5VGD9xojHF6ilBnui4azovVSgzHCsmhlQ09btEjVtt8KpymzlInnghjltcyunlzC/CuTCsk+tFfO3hjb5AhJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hB5ymLLJS5Gsqb164Mx9W7FtccpQc30Zis1VEsyjVOk=;
 b=ao6+0U8W/uuf77wkF2I5MM3I3B2irTykWZOCS5jFREUcZ4nV5K1oI+QwrqYMDYwJthK6xUXaBtsYWLCns3DeRu0bi4wIbMSQ/gR0WlpY3Wk04JIXRa9dcNUeMVW/bb7mR5l+MVKig+dPdK/U1yMSc9+IeZloaw9Sw2sf2sDikEg=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by MW4PR10MB6557.namprd10.prod.outlook.com (2603:10b6:303:22a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Mon, 10 Nov
 2025 16:06:08 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 16:06:06 +0000
Message-ID: <cbe9170c-53a3-42be-affc-002f00b384c2@oracle.com>
Date: Mon, 10 Nov 2025 16:06:04 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm mpath: enable DM_TARGET_ATOMIC_WRITES
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev, michael.christie@oracle.com,
        martin.petersen@oracle.com
References: <20251028150805.1564068-1-john.g.garry@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251028150805.1564068-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0116.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:bb::16) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|MW4PR10MB6557:EE_
X-MS-Office365-Filtering-Correlation-Id: ee076e0e-97ee-4917-060c-08de20730e51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U2RhTU1jRFd2YnBQR3haTS9yajB1Tk4vOW5EQnRhRXloeXdtOXZlS3VoOHJk?=
 =?utf-8?B?cGs2aG1IM2MrTDRBcE5uYkNkT3RoVU44bnBpa0Q5bS96MmpnTXhoakRST1R2?=
 =?utf-8?B?cTFveldzWmlIRkZDazdmRmt0QzB0VEExelkvQ1VYZTk4SENTWThWdjJWL1Az?=
 =?utf-8?B?bndvZklHZVBPa2g2S2YzVGllNzkrQkk0UW1xM04zM1g4YnR3Vk5pbHhrd2ov?=
 =?utf-8?B?cFY5M1UxamNnclNNYzBpWTlZVURELzJRVUo2ZmxaTUFjRUlRaGphUWIxbkZV?=
 =?utf-8?B?REQ2UnN2K3hIV1U3aXN2QTB0NmRCVVFSOUNrQW5aVG1vVHBGbk5hc3J1bHhq?=
 =?utf-8?B?a0ZXZmcvVmlIZzVsZWRWOC9OUXErVlpVckdmdkhwSmZLdHlBclhKamtkbU9N?=
 =?utf-8?B?Y3JOVWJYUmxYK1VTRTFKRlgvRm53eGZhYTU3Nnh1OHhJZm5YYkZIbHZhZHBU?=
 =?utf-8?B?M3BBWFRNNE9FVnF1STlyWlJNaC93RXVVUlczenhQN0ZhRnJkYXAvM0gxTFlH?=
 =?utf-8?B?SW0zRlRLcUZuRG1uak5welZPTGxNSWhZbEJuR1F4Vk1WcGhQQkQwSGdCYWpr?=
 =?utf-8?B?UnRsbk1KelFrMWxEbDZxUlhvUnpYWnhVYkZ1V3Z2RDVYckxySkNYNmhGaUc2?=
 =?utf-8?B?QkJJcnc3REhHN2d5YVRmbnJtNWJSMWErQ0NzSWkzUzRMYjNNRm1XdEh2eG1s?=
 =?utf-8?B?NU1Uc1pLRW9TZHZvY2lzaFFQV0tXK1N5dXlkRDBmc3lUUU1rU1RHMnZuQU90?=
 =?utf-8?B?dHR4NnpjYkdQb3hrUlZuVWNldzlKbmJ6K0wrdmFRMnJyRlladVhXU00wRFNE?=
 =?utf-8?B?eDUyV0hrcHJpS0FlUVZlb0RlTEN6bUpEUGlqUlBlNTVOZWxDZEN5OVZzSUFp?=
 =?utf-8?B?b2RyOGVKdkdtVzFmemxKRzVsTFZXcUpqQzAzVWh5eTdTN1FFWStKb1BGaXk0?=
 =?utf-8?B?Z1RtdG44alFEbzZHa2EyN2VCS2poSkQralFHT3dNOHY2WjYxWmNyWUh4ZCt4?=
 =?utf-8?B?b0lqZ1ZpNzgwMk9jaEc0STNqMmo5NnA0T25JN1p0NG00MnI2UkFDOEVHWVVE?=
 =?utf-8?B?cFFFTFdJRHNTTnNPSU0vRHBFWXV6cFFORDJ1UmpRMjA2VG1QQUE1M1dSS1pD?=
 =?utf-8?B?b2ZRZmZxckZrVEwyT0t3YXAyZ1Y2Ukp2alI1MHB5dlFHbzBHNkFMWnZvWWxH?=
 =?utf-8?B?TlN1N1hvd3ljbk1CenR6UW4vbklrcE8yMzd2QlphNll3UGJvY2tMMURLb0lX?=
 =?utf-8?B?c2NlSjRjWk5ZSFlVM3hMZldJazkxbEMxUW16aGJUZk0wTmNQU1FCT0htVWRq?=
 =?utf-8?B?UUJDdjZxTlpsa29nVGhHbjQzS0FJc2V6MWl1RFdwMjBCK3NHRE11ak9VNnFo?=
 =?utf-8?B?MjM5Q2ZCMTgwNDZyaElBcHp3YnRLZG12bmlFK01rQ1pQN041VkU0TnUwM1h0?=
 =?utf-8?B?akdGam5UQndVQlNuNHY5NndIRUJ0SVZLMEVvSnZBbnlidXA4OTIrUTJYTmU0?=
 =?utf-8?B?TjVPZk1UMXlkMmE3eDluNTVQZzFkVkY2Z1FlSytvMlhVK2s1YVRIaDg1dWRu?=
 =?utf-8?B?SE1oSlp4N0d2d203b0I1NDVWRVNvc0Y2QnkrSDFTTzRMZVlnK0l0Z2YwbXZ2?=
 =?utf-8?B?OENBdzU0MnlTRjJpbXg1T2doS3c5VUNwU3lCeWlaRmlYZUxza1VCcHpSZHpO?=
 =?utf-8?B?K2pKVWZuTFoyRlEzVkNFNHJjOHgzOVVlWnhpNk1NSjVsbUhSRTlUMGFwb0RE?=
 =?utf-8?B?OFZYd3FwWjdiZXIwYzd5bGRlWldVb2l2NTJCaEl4blZ6S3g4NXIyRGtTd012?=
 =?utf-8?B?eGV6ekNmUUVSd2pUMWxpc015eCtKK0lPcEt4QWdpeDhXQmlVY0FMbDl5bU54?=
 =?utf-8?B?bzRxQ2lrSUJZTVk1QnR2dGRsMEwvQjNmWVRtMHArQWt4Z0lKd2N1THpHdXE5?=
 =?utf-8?Q?N2DXu1ONxB8cHpzeIytvykOKZ7qbjAim?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RzYxQTVxUVRUY2tlYUVESTYzcmg5U0xyK0ppUHJSSzNOclBCRVFSaUpWSkox?=
 =?utf-8?B?NjFMWkF4am14aktxVnFhVytvb0tCMVdsKzFTdERFWW1LZjJNaHFkTXprU3Jh?=
 =?utf-8?B?SGVmWWpGTXlBWnVZTitNZ3lmMEx2OUpLSmVHZjAybzgvcTdlRGNJOTZLakJW?=
 =?utf-8?B?SHZEdmVrYnpZK2pGV3ArS0tRdE5yQUlySEZQa3hLTUF0cUIwNy83Q1kzbjd0?=
 =?utf-8?B?cXVBQVkyemZwYTUrQkFkWmF5TFBld0hIaHVHQWEyNWMxSWE5MWVjeEh5ZzV0?=
 =?utf-8?B?cFhmamRIV2tEdXV2T1pSL3diZFo2b3lHSjRzYkNrOEVsWlpMUjQzMGg4VWpw?=
 =?utf-8?B?bVBxd1V1c3pyQ2ZSbkRsaklySDNpeXExc3lhMGJvdGU3L3Bka21jRGEzRFVS?=
 =?utf-8?B?VUFGZmpkdVBybGJPb0tuQy93Z2huR1VBenBCSVRia3BIei9aMkpjeExTZ3Fr?=
 =?utf-8?B?c1FsR2wyWlBhajFLcDYyWWtJMUlyMjNLSWV4RGRJSHVtZE9IOStxMURkYjJH?=
 =?utf-8?B?Tkc3eExhZEpMSjZ5THN1WXFIZUNNREdoMHR2aVROZDBUeUpzZzBVcUNqOHFF?=
 =?utf-8?B?dlRzMkx3Zmh6MTNDamE3eTdjUjVaa2UwVTZCTXZpNGRVeDVRWEhUVlhqYllY?=
 =?utf-8?B?YmM5MnA1NFhldU9YVFkvTE9Ga2NFUkQrNytlSkI1YXV0L2VMQzEzbzkyYkJn?=
 =?utf-8?B?NlBXT3FRaVJEUXNLM1o1RktMYk9MMVNya2g5OEdaclBTdzkvMGp2dnZNSlov?=
 =?utf-8?B?NU1VK0FkTXQ3Y1FsYnQxbFc3MWQxcU84eWdTZjl3SGp1MStlUWU1SkxRL2tw?=
 =?utf-8?B?QTNZYVVKRml5ZTZoeks2QmFXUElVNzI1eXpyVUNHTjhRNnlmUUZ4WTZsY0JI?=
 =?utf-8?B?cjNoc0dxVW5RVkY2MkwyZVJVbDZCa3lQMzlaOEJBVDdyaG5sczBqMWVyK0V3?=
 =?utf-8?B?blJuWUJ6ZjRxa0x3SEtVTno1ZzdVdHVFell2aTBnM2ZlU0txeExUL1ZFano4?=
 =?utf-8?B?WUFDVXdsT1pPbHNkSDJRQjJYNlZwUGJacGlCWnhTbXJMK1RNNXBpN0N3aTZI?=
 =?utf-8?B?TzZrWGU4SDNzaENTRXJnZlVWVTB0ekV6ZnpvV1V1M2tjM2NsNDBOQVdtRU5m?=
 =?utf-8?B?eDVSU3k5bzhSUUdJQUVyVysreXlzbDN2OHdYeUVnbU8rdUg1SGVhSGxaelZU?=
 =?utf-8?B?WDdwaklOWXAvY3FXdXh0S2pMUzUvdjI3VWtHN0ZUczRHd0ZqN0k2dFJLWFhF?=
 =?utf-8?B?WDUyUWw2djhncVJNMVdJNHA4SEpVTUkxVzhnZVRNeGlCQ1p3dWNqc09FaE13?=
 =?utf-8?B?L3kwZG1iYmd4SWMvanYwVUJsNHNJZ2hsM0ovVkRtM3ZsZlZVS1pXS2ZSY0o4?=
 =?utf-8?B?NE9SSjM1YVNwZmtLc2dNNDlPMkloUTlMWmZmdG42UGJxUmFLRFo4SjdKRi9r?=
 =?utf-8?B?RnQwTWZRdm1wbElOa0JUSVVESXU3b0xoZytBelVVcEJ4aWV1Tm1vQnpxME1X?=
 =?utf-8?B?Y0czMGVFMWxJSWhxZXFmM1Awa1h3Y3pkTzU1VGFZTHh5Zm1yZEk3dVZFT3RL?=
 =?utf-8?B?SVU4V1paNklMd2liUEtoM1lvTGFrUDRVV25sa1FySWZlb2RrdE50eVhnbUNN?=
 =?utf-8?B?NUpxQzdJcTdsN3hxUFo2ei80dHpEcGVJSmNmV0FjSVJBMTBhZm5jeXJwUXcz?=
 =?utf-8?B?cnZKNytBZFF0cFNDbTRsWENWUUhiajhMdU5CTElHdTJJWlRSWURpZlF2cXpk?=
 =?utf-8?B?NjZ2cmkrdUc1TGJqNGRuRUh6ZFZ6eUM2NytJTy9wU0NhNHFUa1BRZ29wdEZQ?=
 =?utf-8?B?MmRWUmwvekxFUXY5Vys4VEpjL3NmMnNvOGdEeHBUaXpPWnBQN3ZSTm9yOXQ0?=
 =?utf-8?B?SzdBcDNYaUt3ajJwRVRRSXppZkxPYXF2azkwbFlTckRFYURBblo2b0s2UXdm?=
 =?utf-8?B?SHR0SU9adC9GSi8wVmsrWXNMNFhQOVlDNUlvaDQ5elhnMFAwd0tHZEFvQ3Za?=
 =?utf-8?B?Y050M0I5aGhidUY5ZXpzQzdLeW0yd05Xa1NzOGVHck1hVk9nUUlsYkdDZURp?=
 =?utf-8?B?RlBvdVNheG5NRnA2ajlsdG1CQm5XSjNkczZaR0ROUEM3bGp6ZC9nQ3RaTENW?=
 =?utf-8?B?dVhhZlduT2lsOWdxWkM2Vk5JWkFZSG1aQ0hGL08yeTFkamh5VGNrUEljd1Fa?=
 =?utf-8?B?a3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kiSjc1fMCOyDdrgt4eDTXYT/Qtdla9JS9yeJlWcxNPLCcAHLaS86wqW3rG9GWXFp0sFbUeke+vmEQnqVFc9vqrD2PTQIYX+UxJQ+FyLsjIrZ2oCw4SI7TSfbKS1S06FuUipDe1IQdEipQeSkgi44Iq7kQTIi0z/bHHTh9jQ+c0dBsksidfF4cEUgr4awGBuWaTjhl9OKa6ydRzPTTzKY2y+jdtu0eYwfouEMyYsaw+c3oPo59Y+j1qM1ebPLjbOl18QfgOena8pbEmWAFyvaYCivP3zd7xglsDGkThG2W4kKtkzU9Hpjj0ZxZLhdIUncAg6Euqkg/ADK11+0ryzTRJRK9rTbF4sbIZqp2YnkNDFSua/SDGVCP2CNrTH/X4CJUTSwMUF+3I7BTPKXFNhP8+KGITSaZnB8HhuPli6GEKLLn111gzMk/I7l9bZowqJDnIqhGn72ncFa9YsmYsILWuLsk4D7N8sq9yuxKwasbXAfcvzqqIcx+bbWuvTGaffMmYX+XRyznqKnQ8XqaLwciLg76tt6/NYFvwbg8d7VkAkc0qHCpf5QYHLtzOqfDvYD0FQn07zogq9XX9Apfk6E6SfaxD3DOcovkPjPygYyAdo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee076e0e-97ee-4917-060c-08de20730e51
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 16:06:06.9275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Msjj5EHiD6txJmIwujG2tfyes17YVxEqwavgquKaHPSSaXA4gbIPTC5G+bwruGBk0p/4YMcm0FsGXTwm2+FUXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6557
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_05,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511100135
X-Proofpoint-GUID: Ho63_V3q86ol1JXcqUG1b9Oojn6_oPB_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDEzMCBTYWx0ZWRfX6C5a2SXCI3Ye
 yvdlXLvfQTjjEKh5U3I/nj5ugF6pQL8DDgFpoEctAiRpbSFRhR96sEHD7mShCPCJR3Hxkv6TPKw
 HB7ulRGhyh8gPpwUGiEi0WdQXD9kNmBrJfsk/nDotaB3pYs1/P9wDYE7ONFVnAScEBD8449MKf1
 kkKzHzgDn3Ej+Q1T1EiFLeFleJP/37cfhiNOhklOBj2wJrGHejkBM/wswyZB55m+ojDmF33iicS
 R30qM0LieiFAvam3nXG3MqaC0CblSVx2KuBslCSihTSu0rcaDxmMekPp0wTxCHbP8VjXa5WJSBm
 5aBapTGAtha8Oay5ccxsEjBXxWn0G1VXlEqN5lp9onP3cAGrbVGyrat937wBHdCVYXOIE8FzW6E
 La5sfC7X7oAevxoMbCH2lArvtgmgJxUfBd12tl0cZkkcqXJS0I0=
X-Authority-Analysis: v=2.4 cv=I81ohdgg c=1 sm=1 tr=0 ts=69120d76 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=yjc16onb1CBWiB77HNEA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13634
X-Proofpoint-ORIG-GUID: Ho63_V3q86ol1JXcqUG1b9Oojn6_oPB_

On 28/10/2025 15:08, John Garry wrote:
> Both the bio- and rq-based paths have no problem supporting REQ_ATOMIC,
> so enable DM_TARGET_ATOMIC_WRITES.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>

This is just a friendly reminder on this change. It has not been picked 
up AFAICS.

Cheers,
John

> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index aaf4a0a4b0ebb..5dd90b2cdb9bb 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -2307,7 +2307,7 @@ static struct target_type multipath_target = {
>   	.name = "multipath",
>   	.version = {1, 15, 0},
>   	.features = DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE |
> -		    DM_TARGET_PASSES_INTEGRITY,
> +		    DM_TARGET_PASSES_INTEGRITY | DM_TARGET_ATOMIC_WRITES,
>   	.module = THIS_MODULE,
>   	.ctr = multipath_ctr,
>   	.dtr = multipath_dtr,

