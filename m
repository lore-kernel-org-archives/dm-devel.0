Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539DB171651
	for <dm-devel@lists.linux.dev>; Tue, 28 May 2024 13:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716904481; cv=fail; b=QIfaTHMH5og1IXnhwtss+IMlML6Kay58heL+XvozTXpCRQWcDc/jmH7aTTAucwbhP7NPY9eaaG4eMy+xfWGCS8ZeAmtTYEmrBxTl/YARvpiaAjTQ5dPFBnInto6X3c22m3R24BaCjssnFCH8WArWhTA4gj3+apHF2a4ecGbjcD4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716904481; c=relaxed/simple;
	bh=dI/hnrAg2GPjFEHpcUPhKhhSb9QWIJ0u9Qb3hF8nWMs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=L0BT3NpMYlTglBWVyVPEVXM+t9LGN2kaMysZVHv5AvYHk2dC8F5CQOnvkIjiGQDhsGet914mboxvzPxrMxrnN7Du00wyk26MggdZGkG8t8lmXwwTehxqTqGQkrPfcZadIkP/cVimN1IGl1o35E7LtoZHmuHSqhGqzXQRvTdTT40=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=oracle.com; spf=fail smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44SBn1WR031927;
	Tue, 28 May 2024 13:54:35 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-transfer-encoding:content-type:date:from:in-reply?=
 =?UTF-8?Q?-to:message-id:mime-version:references:subject:to;_s=3Dcorp-202?=
 =?UTF-8?Q?3-11-20;_bh=3DynritowtHKZ+L0vMLtVsqkbhhv/acDCbUx6lCjbj7Z4=3D;_b?=
 =?UTF-8?Q?=3DAIg//JIvtDXK/UXbjAhBrhPNp7mKdGCe+qdeArXen5x7pNV/GtzZAkAwOjIL?=
 =?UTF-8?Q?LrA0dN/K_6ZVygMzDGZe18+RuEb6BFq5loSBpdK3tpGzRD9+vSyp/IvkJYJb5FI?=
 =?UTF-8?Q?vclxBhYvR0mQFz_6juJdU8A3v5+PHIQ42EfzOWJpr8Uc4dmLcdsviGF+KuYMYEM?=
 =?UTF-8?Q?4AgJbHOM/a8bAboD8O0r_y5tpQef6VFDT+Mw0pBhIt6BDdSw2QPnXzr+v0tdUQn?=
 =?UTF-8?Q?YUdUVfN7tNrGIfLZ0oL5R6p4mH_IlZvaHl0nlX18K/2129/leU8Qf9WEc86jOiG?=
 =?UTF-8?Q?ExFNAUe49Vu+R+iTMlOnxRUg0GQNDB4Y_QQ=3D=3D_?=
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8g9mexc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 May 2024 13:54:35 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44SD0iMf025732;
	Tue, 28 May 2024 13:54:34 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yc50pvt7x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 May 2024 13:54:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SOe/ZbcdjrUG26P24HGHVtja8sKHM34T0+AQcv7HXJpu4Sd4JmC5/WDXULg4/pW9E4eEOIulte8yDBPwnvtrMKyVef1Py5+TEIJek9Zxd3HDZIBArMWX1JOXSFuS62GcJqlf1mXBnzFDu95Fl2NZX7FPPSSMcWuOqD7LMH8lvmekc82ltnSaDAIJBQhgZV+uvSVeG6IOylYdiaGMZO1R3bdoQCZtMczylDWoB88K1yf7hWXH5giXSWa56EqMaEApxY8jIrsPhYRUjfrctw7mGK2kA9QiJ5j0MGDjMPUENERjZQ5ZH6BR8/+IfswN9zI9Tc8U8RN2ITEQAbUrAl3WcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ynritowtHKZ+L0vMLtVsqkbhhv/acDCbUx6lCjbj7Z4=;
 b=Wgb91tD69kf9mPkvM9pAONnwgOuMs6QReRjSdYlsuxPKgqVdKhI7hRV9YKs24idEbkNeQmnKLk8UjfPAJsKhKHsG6SMGSaqfHMAMIyNVbAAgQzVhYPpadQ1bJA51SMlchsTT57d7eMoiC7wBcFBJYrgnAl4sYz3ZSNvSNGPYyjJQnBZ4zUKfqkwDZOCbnyxEbGMSCrnV3yJFdOOAhZBw3a7Yr6mvMMhF1Tqd1J7K776B8HntaedF97wjrOjLAVdlJvG+90MiLmLAOutBNl31g14die7pV5Yq8ik8LnDTxkjGbvaPZsloUNrzmoxctzA0aLJ2IAxhpF9+Tbudu+xgVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ynritowtHKZ+L0vMLtVsqkbhhv/acDCbUx6lCjbj7Z4=;
 b=wz7xNb4zOPDSbQzrqTZ2P0JjACY49i7Y4dDF0yBDLQkCcGBYMtZONwPiJjeaH4AIGAZ4+SyPemWjnsLzWiSOegy5nVQYJ0SXTVYvL+rh1fqx17ad/KJOulJPiqu8+HE0JsrTVeMvQsfd5tGuZZoZ5e6n/HPR9MhLVAP5hVuNLQs=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4733.namprd10.prod.outlook.com (2603:10b6:a03:2ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Tue, 28 May
 2024 13:54:31 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7611.030; Tue, 28 May 2024
 13:54:31 +0000
Message-ID: <10b3e3fe-6ad5-4e0e-b822-f51656c976ee@oracle.com>
Date: Tue, 28 May 2024 14:54:27 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2] block: check for max_hw_sectors underflow
To: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org,
        dm-devel@lists.linux.dev
References: <20240524104651.92506-1-hare@kernel.org>
 <acf3e39c-36ae-4792-b870-26d392be5241@oracle.com>
 <20240528105837.GA15290@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240528105837.GA15290@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0066.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::30) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4733:EE_
X-MS-Office365-Filtering-Correlation-Id: caccf4a4-25f5-4138-1029-08dc7f1db2fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?QVVvcjVaeXRtZTJOOFlDM0FqZnZDTi9jMUt6UzlwRVVHaGlkSkFSUW0wbzdk?=
 =?utf-8?B?dEEyMTduaEZzbVZGbWxFZzZ3azg0R1AxYWZET0JlMmI2N2REaTlWd3BqeWF4?=
 =?utf-8?B?bWJMbkwwakVXVkV5bllaVkFjbDdMMWRXR0RQZXhQZitKT2RkVFhwZDh4WThQ?=
 =?utf-8?B?LytFZmZaSWxBY080R2lBcEEyUTRZUFowZ1pJbXdEN2RCbzMwNzdrMVA0SDBE?=
 =?utf-8?B?QXp5dk41WFhkWHVkeGdmRDl1cnJsTUhMcEFmUENScjRhdDhtVmlja1E1OUtr?=
 =?utf-8?B?WG1VK2xybjVDMFkyM0tRejY4OWVWTFBRR1VaVGg4blFycm1oU2U5M1Q2Nndr?=
 =?utf-8?B?VlVMS0RrZVBKUnM0aWhRejV1Z2FQUzNnbkVWTUNsTUJxSDBLeURyM3lxTVVH?=
 =?utf-8?B?Z1RDeXVLZDNZRnBIWWV3WDhMRWN3cm9OUXRlOG80K1daZUQ5UW1iWHlZdml2?=
 =?utf-8?B?WnJpb0N0VTNCQ1FOV2V2WTJWNE1hTGt2eGlOVTdRd1pFdldnRytTZnpMN2Jn?=
 =?utf-8?B?L0xEWHVYVGh3R2Y5bTNMUUFQelJ1R0U4aGxrR2hiTDBEdU4xRG82QjBKeWFP?=
 =?utf-8?B?dnh4UUgzY1NVUENhbENmTC9Pdm55S01jRFFGazRMMzJCNHVzR01KKzl4UC9N?=
 =?utf-8?B?blZ2SnRDcTRKRWlQUGJuS2VQdy9ZdnNuTTM1TFZCbWYvYUxuSzFuelNmbFFX?=
 =?utf-8?B?c3BHTXRhem4xakgvcGFOeit1aktZTkkwTm5PeEJoOXZubkkvaUJTaEsvYlVG?=
 =?utf-8?B?STAyRnA3VDFzTm9HUTJ4dHJFM2VkTzFxSlRLOVI3QTJLaVU3cG1xL2hHc3Rw?=
 =?utf-8?B?dXEwVUVOakd1RVZFTk93VGxuQS9jWWdmVHJyUksrZjU1Z2drSTZsUEhEQWY4?=
 =?utf-8?B?QXZiMHJUaFlzeW9yOXJ0bWJqbUI5ZjZ6dkcyZGoxa285UjRuQkhQS3FCUkda?=
 =?utf-8?B?UEltbjF3RjQ5VDF2aFpGQXVuanBHd2pkb2w5bldxTEJkc0JmNU5wOXllZVM1?=
 =?utf-8?B?NVdOdE5CZXk0L3YrR0tKVzZCajM1RFNRWWJieXdURUdicXJoTy9Ha2JsdVM5?=
 =?utf-8?B?ZnlWbEJMQStUcUJJdU9Ua2RiRG1lb1JqNC9ycWowbUxwUC9JRGZDWUpEZXdz?=
 =?utf-8?B?ekRTTHRGRE9ncDh0VnVVUVc5WGhIS3lSSHpOM1M5Zi8xOFFQaU5VLytvUC84?=
 =?utf-8?B?WGU5ZkcxanVDeXBjU1dFSVlxK0hZdVBpaEc1M1FZR2dOQmpQR2JDU0RvWlR2?=
 =?utf-8?B?YUxtcVNIeERkSzUrcTR1T01hcllpUktaL1hxY09ZUzd0dnVpTnpXci9SMkEr?=
 =?utf-8?B?ejVDczRkODFHNFdvRldrWmRKYVVRNnNrblhkekFKWFFmQ2Z4eE5PdDNNckpD?=
 =?utf-8?B?RkVvdHFXRXpGeUtEa3dVVGs0eEQ5TE1xZVFRRlBLak42cjVUcEt4ZXgwT2Mv?=
 =?utf-8?B?Tmc3UXowRXFHeGo0Q0l6b09vOEhMOXlhV2VYM0lhemVhNVlvTmtLUG90NmJo?=
 =?utf-8?B?dWJpNWE3emxEMmJGMnJ3WDVZNWZ6SHR4QURLbE5PSTBpVWZEQXRtME1LN2tu?=
 =?utf-8?B?QnVQV2d4aGNpZ3ozbDU5aGdoOFlVN2hJazRwRTNWTDRGYlVDVmRzUW9SemhO?=
 =?utf-8?B?RUdpYjRKR2d0bUMzSyt4V0M5NVp5MVVWUXJwRW1TbTBXNE1NNXVUd3R3MnY2?=
 =?utf-8?B?amFqRUVKc0NKZysvL0ZWZ3RMNTNLVW93OUZ0RnhrYml5ZlJ6NncvMUFBPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?OFRhNTUyME53aW5pS3JQNEEyRFlmTUpJS1VVd0ZVWmJIMFliNzNtNUJPWFZy?=
 =?utf-8?B?Y1kyYk5VQjB0TE5jclF1RUcwQlhXeVBNcG5BSG50SGl1NzNUVE5UamxVUjY5?=
 =?utf-8?B?TVRYbnJJaFBaYzM3UlJPbWNMSGRCSUp3NWxpdlZIVVFYaUhZY3V5NXBLZVlu?=
 =?utf-8?B?SnQ2V3llYyszZy81RW14UTBvcXErK2FGSjZVOGJWNkgrb2Y3R2UwZXlVY1ps?=
 =?utf-8?B?bitaWURJZ3Q0R1VRekNGaVBLMUFlZkcydDFIa09wZzQ5aVJuN2w5U2ZNc3dr?=
 =?utf-8?B?UnlUOXdZRWoxTURjN3Y1eVp4Nmd6V2xPdVJXTnBXT0NzNUV0czA2VXgrWVk2?=
 =?utf-8?B?WHZXdjZQcFkyUGJXaHVram5mU2ZpTldsV05nVEZBY2FGVS8wbkRNN25WVTI0?=
 =?utf-8?B?WVZyZmJaNndPWXB5Zlk4VTV2QXZEaXBxWXNzN3lqZzVybW5wTTM0TUpXSTh4?=
 =?utf-8?B?WHROTmpVNXNEZUcvT21ybzNWdE5zQklUenZYMlVha2lHZHMycDM0YjV2cjBS?=
 =?utf-8?B?TklwKzZjSjVtUWFKaC84a0tDR2doT2N3b090dElJa0tDaHRuUEZFeW1mdm1F?=
 =?utf-8?B?QzRHNEVDT2x6d2ZaOXNLOGZHeHFBUmZKeWtnNWhsbVJ2QnpmL3JQdWlhYndI?=
 =?utf-8?B?ejdPR0hOaG51OFdSY2xocjByVkd1akN1emwydnRFYmVoZ0ZXNzNJWnlQSi84?=
 =?utf-8?B?RDZ3RWhYNXkxZnR0UUgzVnRoQU5hTnpxYjVyTmdXd2Viajhid0Z0NUJZbTU4?=
 =?utf-8?B?dVpzbXUwNlNVSkhEUUcvaDAxazNQZEp5OVJOZ2JIYnU2Wks5Zmp3QUxnbjh5?=
 =?utf-8?B?eGVabk5xbUZPUHBqV1ZKbEZwOTJ0SENiTVFnWmQ0dmRrbC9KY09ZdkdkbVpC?=
 =?utf-8?B?UlhsZCtoN1JzckdlR0ZrUk85b3hURzhta21uM3pJSmpOaHkwNFJLSDFFcGNm?=
 =?utf-8?B?b0RQbzVBZ0dIMUQ0Skgxdk5Fc2RYRzVkeFk0clh1ZmltK0hwSUlFUFBCVHcv?=
 =?utf-8?B?V0FyTE0zKzZ3MUIzTlhRUzlRUUFRMkVXNDJuSXNxaXB4NENkQVh2cDlHTkRY?=
 =?utf-8?B?SlRIM1RVTU1wa2Z5OE1odE5FQTdsenVHc1k4SktEWUN5SVJMeFU4TE5VQW1i?=
 =?utf-8?B?czJ4VmlvdGVmaWlKTndVY0lSUWFvTjFoc09WZ1g2ZUJDaDJnRE9uc1hYM0Jv?=
 =?utf-8?B?SFRLN2M2NFNLRGRlaHJIcjRMelRTa1NpQmtkL052aXpXaVZMdEppOEdNVHZy?=
 =?utf-8?B?eTM2TGhNcG1QdGV1c0V5RDM2RGJoOXVmRERkeUdSMHI4ZlEzcGpkOTZjc2hh?=
 =?utf-8?B?Y2VyZXZaOFZCT0NrbWRVSmVnSk1wZzRrM3Ruc1pxQ2dUZXlHblFYWXhCSlQx?=
 =?utf-8?B?TGVoZy8walZDc2VzQm5MUytTTkZORGNvdFFBQWpyRVBudnhLUm5sSGVrdE5Y?=
 =?utf-8?B?MVBPNVR3b3NvVVc0ZUpJL3RmMzE1NjMwbHhRUVFUeHd4T0VkeUUwQU52WG13?=
 =?utf-8?B?cE9NQUwxVXBGdDd2Y3lCUXdLeDdpSjl5U2hPNGU3eVRWdkpyMWtZUWJLTkF6?=
 =?utf-8?B?ZzBPZXJZZWlpTE1IYXJCNmhjS2I1RnRQdVIxZHZYTEdFODhvUllwMDVwdjBu?=
 =?utf-8?B?NWR0bUJrQjlDeVZ4R2FoVlE1R1AzYzRxdHBGMXE5Sm0yV0kyeThPUFZtbldI?=
 =?utf-8?B?YVNmeml6bnpveXpoTDlvZFUvWm5ENFVyamdoYWFZK0YrTmNoZnk3VzMrZGVJ?=
 =?utf-8?B?YnpsaVB5WU14U0VBQ3kxUDc4REswand2dHM5cGJ5TGhrRFZZWFBCNVc4UmNI?=
 =?utf-8?B?WkwvU2VrUzJPL1NMWDkzZU5CRHNXWU8wZzVJSkdnSUFhNVgzU0EydTJxM1or?=
 =?utf-8?B?cldobkFYbG40Yi9DeW4xOVdmc0VKYkR2K0RKVndHeUZXVDU0RjJwU25zcTRy?=
 =?utf-8?B?TG9raHVrd3NMWVd5SzNlQ1Q1eldFTFJlemVvdHM2OW1zekVqVFMzVTRNYzNN?=
 =?utf-8?B?b1hBZjltRjhuRWJSelE3M0hKVnBhSWlvcjNkbEFCWmQ1SGtBZmRTY2FoN1Z5?=
 =?utf-8?B?NkI5b05pRFFpQmNGRC9JZ3M0YUQwMUk2NEpqMGorZDlLSWpSUUpQOVplR3ph?=
 =?utf-8?B?ZmtaMHRlK3c0c24zVStGYlR3RVM3cnpJVnRJSSszeU55SGtmdVhPTXN1Y0Nt?=
 =?utf-8?B?c3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	5GSKWvk5YvyLKGvyoSfW6PL8jC0k7/2wH2g3q38aNuYjuy4nyIT6pL2XbAv2XQnm/BSwHAbYs7x4pniPdRyjhxKYVYPckacxd/sOCPhPU2d0ahp2+YXHY/zIRWPUYQeOUoE+Grs+IX/+RsSQbdRJ9bWCstVbwxzjH7xqYotWuQWA0O9hlJBASaEvFQlQb3yWmbALIe0/MkpaHPSurteTl3KtgKGoqp2O3+Lcfqj6kgkVb3Rvqn34aCh9tgAAhYBvOlcdvS0vonP56e9hOagUh36nXZP/nr7gwg4WOj33O1NdNCeazG0A4N/iaQHM9UAmdp+hmKFqRla2GHPymdGoCKvaYriC03l2DmuQbs0aICl6+PqtS3kWFCrNqC0vQ/TkbJBGqehHY8kE5gooQHnilnyC1znge3Ljb0u3SnleKCV7eegmVWUEvas0erEnKOHKEhguVpQq6U+uRfsjTPZ//NnCL4Mrnwl/J32bWwmcy6bceVWN5La2HL3wTVrg6BZ5fPUm/ZMUuHhjBfdSWv66hpojegsRZDMHeygqewC7qDu0CH57DGYxESepBOipWuEiF/5SPsEsN42UCZALR3vokez+aCY+QeZsCxy/GvrUH4c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caccf4a4-25f5-4138-1029-08dc7f1db2fa
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2024 13:54:31.6753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iissGouD4hkfZnw+UHj0j1qhh/F8k2CGgO7glCspiMw71Hf7dCwM6rqXo147Nwlp4aO2vcG0vhNBoQBZGpK9SA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4733
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-28_09,2024-05-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=863 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405280104
X-Proofpoint-GUID: 5ZIJPw72Uij8-rJpqPsOfA3ZJwHiSEIW
X-Proofpoint-ORIG-GUID: 5ZIJPw72Uij8-rJpqPsOfA3ZJwHiSEIW

On 28/05/2024 11:58, Christoph Hellwig wrote:
> On Tue, May 28, 2024 at 11:54:42AM +0100, John Garry wrote:
>> I don't think that we ever check if lim->logical_block_size is a power-of-2
>> - but that's a given, right?
> It has to be for the block stack to work.  That being said now that we
> do have a single good place for sanity checks it's probably worth to
> add this check explicitly.

I think that we might be able to get rid of some of the driver 
blk_validate_block_size() calls (if we do that), like __nbd_set_size() 
-> blk_validate_block_size()
