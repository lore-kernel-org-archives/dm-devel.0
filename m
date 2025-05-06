Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C72226C3BB
	for <dm-devel@lists.linux.dev>; Tue,  6 May 2025 14:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746540113; cv=fail; b=bmXaVfD1fPr0A41rrxsWeLk62NEzlUEBmM3qnOWnHKlVKtp+4kD+ZTz8TjhkexIYjoMwQcGWKY60wM41+BF7ehpNtb9OmdZpih4Ee7CvCKrDGxmJxGDSLzEACoc/3tWrYtzmDmZE0Bi8/tsqdwUpUGXuGBGFgUdSkgZrnu9yifo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746540113; c=relaxed/simple;
	bh=6lrYa6igqbH7AUSIcb8QxlUY2qTmay5/fPEr8MSO+wI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oIpfaO4EbQz+zOWeisMsa8sepaEcOW1gId7RP2y5amHPCucv95XlyE0pWoFWAHKoQgRMKoboJdTZshX2LElJJ7PhzV98GrOPOGUjhM4cusdh182GESvapcUugsUhtgtgJZmdVcFFQSUTq/Kfig8jYr5sOKdzfbYIpvAijQJrDqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jOcGM1/L; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SJv08/p1; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jOcGM1/L";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SJv08/p1"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 546DqDfB000456;
	Tue, 6 May 2025 14:01:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZCstEBUm0TSMsWK6LFDUsH8mvcBhhr4l5lAS7iqPMTU=; b=
	jOcGM1/LEEULVamr61BPAWgRVtuYak2pstiCMy5qBTrTcxxJmJGwvBAPeUz8KUF0
	K6dXq+W6RIICkO8JqcgI/WjPNFvAuGJ7sGWyejxANOWkO3LcMgu6TbflY147ciyn
	3qQFQeruV3O5KW/tES8unWXlgLkLnUcBeBm9TQbONudDnHdjeB8+8HXg6yvFjlR6
	SQdDf3Tc2C8pQis4PW7JFs1UpiuPIxnFuxWRSoV0ePAvVcwD7N3zamfVIN4wI32G
	l/SIPVfgamC0G8SC3ybWaX9IpHM+bkfDMIAnahPKZ18LgUwF9SHc/spFEzmCe+Yb
	0wogVkynjulf3/rsPhwynQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46fkpag122-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 14:01:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 546E0FIR035985;
	Tue, 6 May 2025 14:01:33 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazlp17013063.outbound.protection.outlook.com [40.93.20.63])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46d9k9t0ay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 14:01:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v/7IQCZmKwr/nS6QC+RyPFUHzDEv+u+nJoXzyQPFu+zHrHUAIDZZb88uqBPl/HGt8phRVT9xI7pGg0zDQVbQY8z8v85kdTpvTSemevyh1cz4dURcPYZBWZNVFfT+BnU4o8XoA+5SO2Vr0SfiOo4mSlrzreG5+Lg8UDWWa2GtGMiumMVo364AzO3ZgIBnpLgITfSAux6P2QeigpeRb/XyxxkXPiksMRMcJOLN26VN63d8es9xlkUvvZNDKiJmLVgiMky8Vuqta37M1cts4by5AJZLe/YcqqRmFda0XXs5mw41Be9yQJ0GgdPTFBbJBRRat4ScgMbt2fQ4hTqAdw6uNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZCstEBUm0TSMsWK6LFDUsH8mvcBhhr4l5lAS7iqPMTU=;
 b=KrRzTEksa0NDvqI4OpSW3kDy/83E+BqK049UOB1uEQz/xcXHjfwe4HsoaWx07Z0JGIlMgvxnWK7DA3bmPhTmnJuBIPiqD2E24ObF1wa1QOdKkgGvcxDc8sX+GcT3NINPbxdR/8VMsuitivQoGInjwlZbz/qb2MDNSWpRqpnK296nJpQyMQSyDC9MDrlGjnDXpe9GDf14dqRYDI/wQVS53iRiNtYa9ZPt8FE2GeHWm4KxIc2OQpVVBI7HIhH0XmE5qpqN9vrKQYGoimtSFJLOBJOxB5iitlTe/XrqRnB+hJvlIIDTTp1mQ7l7SDdUYShn40d1WNvFvfyDbw5BdPmitg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZCstEBUm0TSMsWK6LFDUsH8mvcBhhr4l5lAS7iqPMTU=;
 b=SJv08/p1c+xQicKxUuQWylGrbzZvC/NEh/5W7hbsdRCPMkqDftO9HE8JFzsdJhxC2vPbpxOEde8IMb09EW/LbTn5iCFetjCcIWWzvTUnnFot5gJuSEz+2Eol546eYxu/D8gg+mTM9r48YfBefWKBKqbs9ek3GlggugpERmKXMno=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA0PR10MB6698.namprd10.prod.outlook.com (2603:10b6:208:442::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.23; Tue, 6 May
 2025 14:01:04 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8699.022; Tue, 6 May 2025
 14:01:04 +0000
Message-ID: <f6d714fb-46ef-4b57-885a-644036b6c8d9@oracle.com>
Date: Tue, 6 May 2025 15:01:00 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/9] block: WARN if bdev inflight counter is negative
To: Yu Kuai <yukuai1@huaweicloud.com>, axboe@kernel.dk, agk@redhat.com,
        song@kernel.org, hch@lst.de, hare@suse.de, xni@redhat.com,
        pmenzel@molgen.mpg.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
        yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com,
        johnny.chenyi@huawei.com
References: <20250506124658.2537886-1-yukuai1@huaweicloud.com>
 <20250506124903.2540268-1-yukuai1@huaweicloud.com>
 <20250506124903.2540268-3-yukuai1@huaweicloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250506124903.2540268-3-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P265CA0026.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:387::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA0PR10MB6698:EE_
X-MS-Office365-Filtering-Correlation-Id: c8e7b782-d65c-4a02-3a4f-08dd8ca670e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NzkrRmtUdXNybUhhdEhNL05TY0pKY2IyVmxUaEd4RytHMVJMZ1drWEV3OTNB?=
 =?utf-8?B?d3BBNWlXOEJBN0pEY1VocFhINHhJSW5wRHZ4WkZVZlN1bllBZ2QzZGlka2J0?=
 =?utf-8?B?U29XRTRUcWZuY0tnSytHd3pDa0FRc0tJUUo1RXVDR0hHcys5SVhuSHQyVmtJ?=
 =?utf-8?B?V3U4aXR3QUJNQi9tbEpPSFBLdC9zSmZqdGdNUzFXNCtWNTJ3dCtZK3J3b0x4?=
 =?utf-8?B?YXB5dm5aVHI3NlVLNnFWYXErQTdOUTJGdUYyRXFPcm1hV0t5UG9UQ1M3WDVV?=
 =?utf-8?B?a3ZVOGJwMFJFYnIrdjhxbW1GM3g4RWxkNldsZXA3Z1ZVSWxIYWZNTUpIQ3pv?=
 =?utf-8?B?OUllTGEycG8xQmIrRjZQU3dvNHJBejhhUktkS1llMGFIOEFNZnA3K2pSOSt1?=
 =?utf-8?B?UkFaTHpYdEVsc3hJanRzR0xKL3dXOXd1TFRsMEF2KzJsSE9VdkFlVC9pVVda?=
 =?utf-8?B?aTJyR2dqbWlmS3RxQjRuc29FTkhHaFdyOElleVpGUzN2MnJyWWZQMm1CcHB6?=
 =?utf-8?B?QXp1ejcrWkNvUC9JVWVvU1k3ckJjMlRGYm90bVdrc3lXSko3VEw3NjNwdUVy?=
 =?utf-8?B?NFg2QTMydUZEemZWOFhRSXN3SlVKa3I0dzZNMXpjbklyOWlUOFkyeFVBNnVM?=
 =?utf-8?B?QjJMeWlKclJqYjZuV2pjUEYwS2lOSkc3TnJETmR4cjY4a3B0MFNUb2xNTEtu?=
 =?utf-8?B?dkVBaC9GTTg0U01IZnVhdis4NEJlNEJkS3pLaDdweFp0VnMzenhYaFJpS09n?=
 =?utf-8?B?MHRGd3o1REJYYUQ1czBjZ3hZOXpEaytvS1ZHbXhwbCthV20vRExNRENRVDE3?=
 =?utf-8?B?MDdqd0hDYzRsclZqUFdNTWZOUWZiWVRvdDFwNjNvbk9jV3luc2phdFJ3bHhU?=
 =?utf-8?B?OGs5cnZTeVNjOWpNb1ZWUktyMU9DdlhxLzVObmhEV1JVYkJKQ1p5dFl3Z0Mr?=
 =?utf-8?B?V2RwNng0SjdOWUZHdkx5MG9Lc1BXM2UrbzJrbG1HdmhGSnpxemdEb1RoUlJy?=
 =?utf-8?B?YmtjUG9kNjJLdTNCTGxocndRSjhJZ2xvc1lJVXpURDJRQ05EWFUxZU9rL2FG?=
 =?utf-8?B?S1NxUmRJYk5rNHZ5cGZCbS9keUsvK3ZqQjJyMWt2dHFjdnA5RE55ZzdTdTFm?=
 =?utf-8?B?MTRuY1ltYk1SOHV4ZzM3Tk1qZ2h4bW5KUVpnSVBSdXRCRFB2UFBtNCtKbTk4?=
 =?utf-8?B?M1VEWUV6T0U0S1czUTFlMlMra2k0MHA1c0NuamllVHkvZUI0NzBEdzd4VkFR?=
 =?utf-8?B?TVdPejVPSE5jb0wwSW42RndpQlhyZFVKZ1BBSGFsamt1Y3J6aXk4YzhYaUZR?=
 =?utf-8?B?WDVTRFVVc3prL3h0L256Zy8vVnFTUGl0cVVFTk5TbzViZmVBd2xEMkhjTU15?=
 =?utf-8?B?Z1BJZDlBSVdnaVpscTREYVBrVlVueTQwWCtLQTJFNllRekZXM1JhbCtQNWl5?=
 =?utf-8?B?RDZ5U2FhVk9YdjBBQWx6MnJ1NG5BSkprUEN2aDJNZE1IeEdkRlBTUXI2YVpT?=
 =?utf-8?B?SkZ1Y0x1ZFZrRDNTem5oSGdTTlA2R2xSNDA0cEdtRG13TFl4WWk1dStSR2Vx?=
 =?utf-8?B?Skw3YlpsaVFDNkR4TGtWS1JLb05kTU5ES0l5OHhiRW90SjNldkFsdWdxTGFN?=
 =?utf-8?B?R2xIZ0JpQzh3Zy9DelpQbG45azVrbTc1RXdhZlZBcHV2a0ZuV2VIN3BKRzdZ?=
 =?utf-8?B?NjRFZXV1ajE1VUI3dVRRdWYyN1JPZTNDVTM5YldMd01NRWp1anVyYmUyb2lZ?=
 =?utf-8?B?ZnhFWkFRUzBPNHJoZHBNL2lPQ05mVG50ZWFhN3hBT1lnSmpzS3I0MFJrMkxS?=
 =?utf-8?B?aHkzZzdLa1ltQ1laOTRkZFd6c0Z5ZnZuM3UzM0RWOGNhTWJjRVh3dDNPRXdI?=
 =?utf-8?B?dWgwMWZOSHRja0xQYmVpUm04NlFFd0VDVlVVQXl1ZUd1MDhmM2xoT0xDZVRq?=
 =?utf-8?Q?OxaLaSSvGcQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WE1PcWxtOXd3L2wveTllR3Nra2pTRGQrQXRmVGJ0aDhIT3hFZ3RrbGcyeks4?=
 =?utf-8?B?bkFnRmN5MFZMVXFhQmY2WHJvV0l0WmFxWlF3THk2MHZnSGpROElsWG4yK3Vs?=
 =?utf-8?B?ZmRHbDZRa2xiaFFwaUNJOHNXQkdneUtac3JCajBiVVdDS2Uxck44ZzBHRUZi?=
 =?utf-8?B?eUlXanFPY1dlMzE1TnJJRFBQMEs3YmJjZWdPODJvVWx5bllDR0N4QjRBQjhr?=
 =?utf-8?B?eVV6YmdlVWgvcExYbjJGZzJBdWIyaWZNVnJ3UHRNUmhSZ2xmSy9TMWVtdkVP?=
 =?utf-8?B?eWlOMlZpMEtaSlA5Y2w3SGhENXptb0t2VVNFYnV4bk1Ob0lKTVowc05sakRy?=
 =?utf-8?B?U2lUUFd2elI2YTVRcFc2NWludVk0dDY0WkwzdE9WSjV3aW90dTlHVnNxQkhV?=
 =?utf-8?B?SE0zdWZqaVIza05BV2MwenpLcC9NU29OYnZFVFMwRTEzREJGdGpBUXd4WWhK?=
 =?utf-8?B?OFdlREV5QjdqVkExSkp0TTVmRzZ5cnBQYmp3UW5vcllIMUxlWmt0TWRTMi8z?=
 =?utf-8?B?UjhkMmxtdUh4cnFtc0NVY2tHMTdzc3RUY1RjMXlVV0loRzYwZTVuamtDTkZl?=
 =?utf-8?B?TzgrNzU1b0FrbjZiQVhnd2U0cEMrblVqL3Ewd2VMUHpHeXh0UG4yd0h0SUpn?=
 =?utf-8?B?UThVcW9XMnQ4WGlCMSs2NVBZcmo4dW42TWdqd3JZYlNlL0kxRXVMOFNEdDJ5?=
 =?utf-8?B?TkNQaHF6dFdIalQzVXdhajkxRUNVRmRhTHNPZnBVUmE2UEt3Y1dOcUNCZE00?=
 =?utf-8?B?QkFuZmMzZEdmMU9xQXFpNm5IQ3VCZnJSMjllQm9TdDRYZy9Tajg5UzR0SkN4?=
 =?utf-8?B?TU5Uc3lHT2YzdDcwWlZVUkVOdWlwWmlOMVdETThJNXNGcEc1aTJGc1JkaUNW?=
 =?utf-8?B?S0hvSVhKTnMySlVaT2V1NTcvRGZsMG5sTzVON0ZIRmE0MVF4dFI5azhIU0Zv?=
 =?utf-8?B?TTdIQ0hnbXUzRTk0S0RGd29BZGpOaXIrK0ZjVGppWTVFZkQzSHNySnJ3L0tR?=
 =?utf-8?B?cU9xS3dKZFBlNFdsMVJtUUJXUDY4VE9HckQvOUE5dW1oWVNtbWdBOXcxTmFm?=
 =?utf-8?B?UFRsdnA4Um1XMUVWcEJCbWt0eU10ZXUrbEtwdUloSkRqTW5qSU1hcEJtMkkw?=
 =?utf-8?B?eFIvUUg5RkIvRzVqMDYvL1Vmb2QvT3dsSk9jZmFUVStHZG9pZzZhLzJBQ0VK?=
 =?utf-8?B?NWpRZWN5bElrVGRSOVRZWHJYR2x3SGRWUjBkdHlWZFg4ZVlrVDNIUno4SXpy?=
 =?utf-8?B?T1pSYU5CNWRMNUM4bDAzQzROS0tiOWFUQ2htSEVKdjVvRTU1Z1J2TW5zTXY5?=
 =?utf-8?B?ZTNHL1JFUy8rVlpyTlkvSTJhWG4rODh5UmgrZXJoVmE5QVJoSE81Kzk1ejUy?=
 =?utf-8?B?cTdOK1ZvdEdZb3FrV2Q3WXpML1dnZCsvZEdxWGQ2TUhwWWVGeTA4R0NXclNv?=
 =?utf-8?B?UTJ4OExMVzM0MFVqcCtUbEE5bGRTT0tpdGhLUm1qSjFkamZkd00yYXN2WUtE?=
 =?utf-8?B?SDVZZENoUGx4bDJmRzk3VExnalArUXJXRmtOVGpHaFdwL0FqQkJGUC9XRWlv?=
 =?utf-8?B?STJZMzNuT1JzbnhDT3NxNThKQkhTQm9WTmNHOTBZeWlCR1p1aE5RNXdvOUVn?=
 =?utf-8?B?NkRRU0ZwdmNIR1BYODV3NWNRQkhWRlcrS280ZHBsdWpQRG9RR2UyN0FyN0Zx?=
 =?utf-8?B?SGtzWkpCMjRVWnhwUEFjYi9vWUZBUW5EZGtyeHRjcHFkM01Icnlrdk1WcEVL?=
 =?utf-8?B?MXV5L2I1QzZTR2RaUlZIVVgrU051T05rb0Nva0NYa2pRWmhSc1VKK1A2WGlX?=
 =?utf-8?B?bzl0ZDZ4azFWbG9DTEMyMFRyTmg3QUJlTHJCRXNXYnlYQmRIQWxWdmExTVhJ?=
 =?utf-8?B?aHdsM1ZSZzVyRlRxcHI3YWIzbXlDZm9BOVhHdUJmRlg4c2pybngreHR2a2Vv?=
 =?utf-8?B?bXUrTUdQRnQ5N2ZQWndLekxuOUZidEx0a0dUeTJJZGE3WjA0cWllbTlGT3Nz?=
 =?utf-8?B?OTNpOXFWOXpWTUJxZjFySnNIY0pQNnpzZGhKbTBMVkFvMGZ2Rnp6NDNsS0Uv?=
 =?utf-8?B?NUVRc2pUYklVMnVSdjFySGl6cUorSlh1MVdFUU1yMm9peFBBdUhJWGpyb0k0?=
 =?utf-8?B?bzBmTk8vRWgrYm1hYlY2bFN4Tms3Wk4xckpYeU40dlVpS2E4KzU2dmtXeHM4?=
 =?utf-8?B?a2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	URGZt7TwM9hYw53jjNynbxBtGOAi+HLFWsOM1W/MofgaN5PT2qWkrXHVxPl5NodcYQt72yQeX6fuLjIRdWb2rvvkPR/eGifFAUfzQRZp3ri+Gktxk6po1Z8dQqwuqiTPaz84Hu7ugG1AxidrQAfEDMYKpJg7gAVTF4qNFu0Me8tMO9Iw1lmgXn+OXmX+xNJIKTyeuPKU2BcFDS6lfgUkkp+cphS20fpiquDxG6Z/pLucBEr+pVoqPdvCkU8XtNjVZbsT82MK8OxxIBGtYv4IxBDWRo9BNss4IRuCT+CVefE0tlmlrHFby/yVTUmUcRjyiKUx30o2QfC7T/0MqnIEnCcvUfC8Xiv+POu9HMxOjRcSxiDZVi8CVipchQR06E9vM+nttJGiCdPdmZYpcLKsVOmoZhItbhNfmxO2lHmLNHMJh/mSFjjPMQfVh5DWcldYo2Whuv1ULZ5D5bnJAqfJVKoIsn+vRn+cR2cn35ShDprxIPMMqalAfktD8XWLNus0+9UnAWVsnBfxcIFnXHZIXopOdTVFkKHch9iuo6NLmmopWAIpxK3NBl/HolvbLDf2qFrKXDno+lagXs1llm25U9JS5idQxPUQtfOsMbPir6o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8e7b782-d65c-4a02-3a4f-08dd8ca670e8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2025 14:01:04.6199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ts4pR2Jh0GbWlvqyZoujMRqJgge6XO8rDXYyI9UfBgRnImfrrj0bzNkL8R+j3AToHG7E/U60VSTU0gIqlWu7kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6698
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-06_06,2025-05-05_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2505060135
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA2MDEzNSBTYWx0ZWRfX7Z+bJVxrVeDp wGWCj9Vekl6XkhkI/z58cP7xVjLMvIgjO7iwsDOol7r11jSDEd3Zv6r/fnLPl3iZmQZVYwVUA/Z RALtxbdKDxWJANl9TxDLIVPCpgv6fdql99kmCtRQRNn8ac3vMncPkwYJNbJ3ggwawXueVDhZ/ws
 +4/OXHEvXma3PdZw4kmTfwLx2tOUj07+sMmJLTudz//Oia8LvL3/PNzGAT70pByafq2fE7a828d P/uL94e0+RnSRRtdNS6h18TGNaNizWoOWTqUIv8aLcu2iM7YFSaMJAZ0X9K7VcqQgyI7Wtj9FxO PhEl3dV/3Q3QimD69jsqE5S/aLAggUqnWFB77Fq5wlmjuFfjEzNDniRVAiVGL2dWvrqo3ed4pYA
 xA2KZbcmnEvPjWKDDtyj5H3DAzT0YrF2xTcp0A3QYaqa7xVogO+FEZX6a+sZCl12rWBRDfS3
X-Proofpoint-ORIG-GUID: cDu9NuOIsnEtTHbmt4p_1VYFz4tcsUSj
X-Authority-Analysis: v=2.4 cv=bOEWIO+Z c=1 sm=1 tr=0 ts=681a163e cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8 a=216YDRbFfpvQL93ebg4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: cDu9NuOIsnEtTHbmt4p_1VYFz4tcsUSj

On 06/05/2025 13:48, Yu Kuai wrote:
> From: Yu Kuai<yukuai3@huawei.com>
> 
> Which means there is a bug for related bio-based disk driver, or blk-mq
> for rq-based disk, it's better not to hide the bug.
> 
> Signed-off-by: Yu Kuai<yukuai3@huawei.com>
> Reviewed-by: Christoph Hellwig<hch@lst.de>
> Reviewed-by: Hannes Reinecke<hare@suse.de>

Reviewed-by: John Garry <john.g.garry@oracle.com>
