Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11023123.outbound.protection.outlook.com [40.93.201.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE91440EB98
	for <dm-devel@lists.linux.dev>; Mon, 27 Jul 2026 13:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.123
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785159796; cv=fail; b=dYppN7v0Kkn1KdmqKcwxBpWEReTHu0/xt6hmOeIUF66Biwq2G4/2lJP0/NN66WhulsLXS4YYh2we/Ura6gF08x56Bs+PMJ9wYRK4mojLOtZnIF367IEDUkU91LCyIz6udT74V8p3VGcypzaTbgLkWuiUWRsA1snRgY1MBjlrxe8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785159796; c=relaxed/simple;
	bh=51p+mUjs9O7WYP8ow8tbULW3m6X7zyH0Fyy7jnrd85A=;
	h=Message-ID:Date:From:Subject:To:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S5RewrDbXo8aBfIMbg/NGMDd8Bi33fxR+t0xtt5jBX08alIvmEbptrhiINkQH5S02aXRlhLsXMEqx3C6HrGgKDeRMLAbFz1digekeiFKbJKwpmbiU3poFwFowr+tfxQveJxfsKzO6sH5ov0XuIRl+3e26RK1BWUYtJYYaFMwqyA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pythonplayer123.dev; spf=pass smtp.mailfrom=is-likely.gay; dkim=pass (2048-bit key) header.d=pythonplayer123.dev header.i=@pythonplayer123.dev header.b=lFVQEomM; arc=fail smtp.client-ip=40.93.201.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pythonplayer123.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=is-likely.gay
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pythonplayer123.dev header.i=@pythonplayer123.dev header.b="lFVQEomM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yTmsmZdls90vlmZ5jybz6FOFHYBte9EGp7rj0nr700gAMvlMK+I7wd/AzJ37xkw+T7PVwxjcPep9xH3TpU7ZEsgk4mU6p/RKcmtIU3FixsDJQM8FOXw/MFxXrFAyafFaumQczPBiBVxqYrp4yC3i5oF03xoBa1s3HCasokEklHYTvAtdn9neEB2gdZvLvID84oGmoN7Or+01O/YVESQfS6/47mhhfrJ86qK6LmGAqJr0XGCJS5JJ6u94/RfZNAJX9myyGPRThuzlONGlwXvXrMTLs1KXoM/E4CjIl26uGtjfUjPETcnbLdB0Or1D8wVQuNvf6ko5oO6XInSa+Uptgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=51p+mUjs9O7WYP8ow8tbULW3m6X7zyH0Fyy7jnrd85A=;
 b=lDNb8+Bx4UI7e1u5coxwzsF+eNpVuo2Ngt5UZR4NfCSvZnUMEg9iHMCfed/ABTTx+8oGIiBI8DCFcM1bgjH37EYYt/zubS7v42S3pMR8TgNhVavxM2JCi3xs5f+Ya9+dwxaP560ndXfEQmxtaPVTGUh9bHLcPg1ZhHbceRMGCdgMZxWrZIGxz/Jw8XYXiB0HqfEfUHBHds7aNePQJk5kWipo0YfKu+8N74nBKTchluOPEDRpTrigM+PxjDk5qyEMuMDGxzXBLy3aJ8oiyK3asfFHdeLaF3VkSo0vn5ijfLSG5pqWZ0HgUF3ma3IiMAOZq4vFyrWd6Xs4YUQXQywJrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=is-likely.gay; dmarc=pass action=none
 header.from=pythonplayer123.dev; dkim=pass header.d=pythonplayer123.dev;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pythonplayer123.dev;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51p+mUjs9O7WYP8ow8tbULW3m6X7zyH0Fyy7jnrd85A=;
 b=lFVQEomMLS60+/z8XJxbFqIZX5UZ4tH7mNVgHa8173JjpSGURbq8YKM7q0rnbSfuZYoFrvjmzJtsIm8cXKOIdfyOdO7A3YmVtyUaxpd/TXJFIdd23wZdH1LGRGjS4amRKQvIUncOjqsVK2NWxddw96mRYTBr90GfcY4JFnY2uX5uM0Dy57esjZcQ5XqTIy/Gx0DAJFFerxNpTc8vRKPrHMAy9qP+m2wI8o4L1NPcuTgYn6zLSlxj2cydesvDVm6ZWsOOJhnDjbHbld5XNTg2Hxgm3ipYCWoEjD9uLdT+3sHahknBWArJ/pIRkXFtjdGgB/EUpbI9OAFvO6K9Mciu2w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=pythonplayer123.dev;
Received: from SJ0PR20MB5160.namprd20.prod.outlook.com (2603:10b6:a03:47e::16)
 by MW4PR20MB5252.namprd20.prod.outlook.com (2603:10b6:303:209::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 13:43:11 +0000
Received: from SJ0PR20MB5160.namprd20.prod.outlook.com
 ([fe80::6a30:68dc:9faa:1ec2]) by SJ0PR20MB5160.namprd20.prod.outlook.com
 ([fe80::6a30:68dc:9faa:1ec2%3]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 13:43:10 +0000
Message-ID: <012e81d2-dd6e-4977-b385-d7ac890be2a2@pythonplayer123.dev>
Date: Mon, 27 Jul 2026 22:43:06 +0900
User-Agent: Mozilla Thunderbird
From: June Park <june@pythonplayer123.dev>
Subject: Re: [PATCH 1/2] vdo: add zstd compression support
To: Matthew Sakai <msakai@redhat.com>, dm-devel@lists.linux.dev
References: <20260723161350.1080473-1-june@pythonplayer123.dev>
 <178a5039-1817-4e13-8937-12eee8b26cc6@redhat.com>
Content-Language: en-US
In-Reply-To: <178a5039-1817-4e13-8937-12eee8b26cc6@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SE2P216CA0125.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c7::17) To SJ0PR20MB5160.namprd20.prod.outlook.com
 (2603:10b6:a03:47e::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR20MB5160:EE_|MW4PR20MB5252:EE_
X-MS-Office365-Filtering-Correlation-Id: 3aa2c212-2841-4cdb-49cd-08deebe4fef4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|34036016|23010399003|376014|41320700013|19092799006|1800799024|4143699003|10067099003|22082099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	9hCoNaMwJbUhoFjPj8OMBeRukdN4nXd0wHgCk94MABrJHJDvU8ykhbkzA8SKWyzx2njY16ShIFPOc3WwyfxQZDHQddts47Z3CDaOPMbt6u7mXf4QYr9/oQ7vI637Ogp7Vz2fIWTIsIIRfOkg3+os9aqEAzvR4fMpPuVBwwn6xRh8vmBFVzSx1O058U74j6/PrYtXfLBo6bgaBAV67YyU7p2YFm47kA4sFsZmnCU5aamZ3qwwSOEELjg3V2ke0aE0RcgywGbQXnauCk2sXmarGiIf2T3Ke8hvyJzSI7+xU+D2KWnbEpzcSsAyBgzp8+P+gnfFKU4ZxVTsBJ5NY5qjmGgiQxJ8b6UCKtKCRn1cC9K8TFzabuqk8iD7c1l57HpzTChxQW8koOTf0ievpVKRuz+oFyTTj9LPzZdE4vai/eCU0457prNbAGAXpZyHKupgPx7Ut8ETy35FybmZpDpQRluASDv+Ri2nPz3CCBeuXJ/ocspOt1RMvTR1i3w2sgcxw17ddtLWqJ1w0NFVc458Wb9ZGDSLYti4QyGcdufjA8UP9GIWu/Fv5XERbUQlHF3D8KdXiS/z1mILdgCH/qYuXRaxcq4uRbxxDhKo3hiDIUUsEYh8bgGwOI6BF6/fn/r7nXz9rBQjXNLyq4GXDzbjO5uYXA/6izgWdvMv1Ekl9TU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR20MB5160.namprd20.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(34036016)(23010399003)(376014)(41320700013)(19092799006)(1800799024)(4143699003)(10067099003)(22082099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M1lLcXh0L2R4dWkzUVVPVFRFRE1CYzdCZVZBYUIxUmRCT0VyT3h6aVFmQkxV?=
 =?utf-8?B?dk9MNVowZFZZc0NJK2FTU2hxbHJzT3U1Ni8yUkVMamJsak9NZ3Z6NkFKb1Mr?=
 =?utf-8?B?enAwU3BlNU43QUFuejQrN2VZODFCSkJHTFRmUnM2WGlwa3pOdUkvRjJBclJr?=
 =?utf-8?B?U1RkWnJmelJZNmh4UjNzb2xMM0FWSkZmVHJQNUlsQXdYTXBIekpiL0lSb2ZS?=
 =?utf-8?B?NjdRdTJ5cVRtVjF2UXRwNXloSlFCZ0k1bkdGMXdlR3ZaMWJ6Nkk5NkpJOXpW?=
 =?utf-8?B?WVpEYzROQUlMdjN5YzB2OHNhRTJWUGlzNzlrVUt1UGNjdGdvTUpmZTRxdmxs?=
 =?utf-8?B?RjloVjZqTE5GOThTVk9nNktZeCtVYzV5ZExYZ2hqSGNRTkoyR0ZLcUt1R3Z3?=
 =?utf-8?B?VSsvNUd6V1ZZYS9Md2doVGRydzAyaUY3YXhJNlAyVDdpU25DVUNycUJQMkJT?=
 =?utf-8?B?NDRUamxDckJsT3l4QTdjMDRxL3BmbnZYZ203Mks0SURucUJSOEo5ZEJlem16?=
 =?utf-8?B?amN6eUc1cytLYVFJbDl0M2pTQWZUMXR2MEZBS0lWNmxINkFpVlZhMXRnUWM1?=
 =?utf-8?B?b2tnMDhCZlZSTVhHd1pKais5ekYrNDIxVFhIVldNeUU5aUtZckhBQ2o4cHg5?=
 =?utf-8?B?b1BBRzFscy9DK3Z4WnRVd2lJZGQ3VHJhbGhKVlllcFlCL09aY3NFeXo0VFEx?=
 =?utf-8?B?c1dnUk1JUlA0Yml1OEJLeHhreFcyTzFOaERIWWM0WU5PUEprazcxQUFKNlE2?=
 =?utf-8?B?SG9hMW5EOXRmRU1waVpYekl2SjZ1d1drWXl6VjdwNklNdnl6RW8xUmF1YXll?=
 =?utf-8?B?VjhJOStMYnlCMFZnREl1N2hBOHZIQUorZE1XeXBuUm1NQ2RROW4zWkFNcWty?=
 =?utf-8?B?MkRISXlmeW9nWTNrTk1HcXpUMm95WEEwblVkaFB1ZG5GRGh0aVNMRWJRWHF1?=
 =?utf-8?B?RTRzSnpJcVdMTTJTdVI1anZQOTZRbEFJK1REVWlpcitENHAwaDJ6LzFESHJ1?=
 =?utf-8?B?Ny9LeVRoMitJL1R4cGtzK1hhaVIzWnFsV01Cc1BzL0dqZHNORlR5V0VoUlRy?=
 =?utf-8?B?Tm5iU2MzZ29WTUZ2R3UrOTVrNm8ybDd2YTRMeVVKd2ZzbUZESVZKVGZOcGtH?=
 =?utf-8?B?c0FIdXR2NkM3RjluVVUzSU1TWHQxVFJMMTNlVVFEQmtVOC9hUkJ3Y3dxdEtz?=
 =?utf-8?B?QjhTREVtZiswc1d5b2o0ajhXai9aV0JOTXJZNi82Q25va3kvTWRQa2tDYzdO?=
 =?utf-8?B?UlpsTmxJKzJjc0VYWnhkU0d6SFlrU05NV3BWLzg5c2ttZWZvRGNQVzZCaHlZ?=
 =?utf-8?B?WkluS2w4L1RMUktwVzFyNlVaNXVEZU9PeEYwNDNXYmRLV1YwS2ZqUUxRMytV?=
 =?utf-8?B?UlJtMVRWamVIZHBHRjE4eVF0SmJOa0l1ZzNQSEYyWitnamRzMi8zM1JxZmhP?=
 =?utf-8?B?WmpENjdKQW9mNEhTcFlWL1dDekx2UENyQWU3aGEvN1FFOEZEYVFBZ0FveCtI?=
 =?utf-8?B?R0EyTFFxMEoxQ3NxSUpMZldjZFhDUHZUL3FBMEFneXNxU045bmZFWlZ6RStV?=
 =?utf-8?B?T05VYVczVy82cFNKMThWRThXMExBamQxdnJtWVhkNjlSMkNIUVVvNHNCeWZk?=
 =?utf-8?B?OXVGWUxDcEVNOUVLTzF5K3FDakVFUDd0dUdZVG52TGMzaUNtTWVjSFpMYTVp?=
 =?utf-8?B?QzZSdVFGbUlrUHIrRGp5bFY1OGJDRFF0ck4xcG1hd1hHWldxUHhxaStGaG5S?=
 =?utf-8?B?Z2N5UmxrZU9JM2F4RGVUWEpXSGdZeUVpenJHMWFBM3VSbFhWMHFsNVBWRTgv?=
 =?utf-8?B?eHJvYkJuL1QrLzVOQkNxandQY3pWbUhiY3hUU2JTUTVBRVgzWDNGQzY1VmNm?=
 =?utf-8?B?SzlnL3hiRG52bHAwMlNFSWhzNDZqSTkzaEZhYmluZ1hZSlVaaW55WUxvNG9h?=
 =?utf-8?B?cml0c0FtSW5XNVVSc2tJdGI5TXlOYjRQMFhDWUlNend4RUdJZGd1ajNQTmdR?=
 =?utf-8?B?bnNzZ2hibjVuWENMdE9SQlB3a1RvZE1VVXVpV0FtTDhJK05IcUx2cmlJV09p?=
 =?utf-8?B?S3dLajlGMzJUcDIyT09VZUdRTDd4T2FBbERrLzVMM0Q0ZTZyOVVwZDVlSU1u?=
 =?utf-8?B?Mlk3bTZKbUtDRi9oR05La3JUaE8vKzFYN0pROFUwM1ptdGxnY2lLQWFOOEsx?=
 =?utf-8?B?a1BRaGFJREx0UU0zeVp6bzRqTTdMK3oydzNuU3Z0dVhZL1FKUUg0RllQQ2xS?=
 =?utf-8?B?YWNqRW5wU1BtUStVZ3VpYzB5Wkd4MEUrVTJTVDZNTnppQS81NExDZE15K056?=
 =?utf-8?B?dEVvNjZvazhQVTVjdndsakpROEN3VitLeGhaMGxmSk1KMEZhakttQT09?=
X-OriginatorOrg: pythonplayer123.dev
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aa2c212-2841-4cdb-49cd-08deebe4fef4
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR20MB5160.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 13:43:09.9437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a3ce53b7-1063-4e66-9486-3ad7281a5cc5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a8UWHdH91VCmm2BKcemap3G/S6SbVMGCCE4GY7ECmZsG7kHTe1ji/7NjklFoZd5IImpObtKh6p8zwSlvxRP4Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR20MB5252

Hello! Thank you for the thoughtful comments.

> I have to ask, what is the motivation for this change? Do you have a workload that shows some kind of improvement from this proposal?

My initial testing in QEMU, storing files from the kernel source tree, showed noticeable improvements in compression ratio (around 2.4 to 3.5), even though vdo uses small block sizes. However, I did notice that certain types of data (such as long synthetic streams of repeating bytes) showed far less improvement with zstd, at the expense of more CPU cycles. I had concluded that it could outperform LZ4 in some workloads in terms of compression ratio, for more CPU, a trade-off that could be made on a case-by-case basis.

The discussion you linked to proposes the ability to swap the algorithm without reformatting. My current implementation tries to reduce breaking changes as much as possible, so I had decided on storing the compression algorithm directly in the volume geometry, instead of for every block. This has the downside of requiring reformatting, but since the focus of vdo is deduplication, I don't think the large amounts of additional machinery needed to support live changes is justified.

June
