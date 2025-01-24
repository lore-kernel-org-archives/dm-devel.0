Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434DF70802
	for <dm-devel@lists.linux.dev>; Fri, 24 Jan 2025 13:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725309; cv=fail; b=jAuJmaXNmGFumsuJzt4/mKjDdu9rLBzlifjSUYGdiUuBYt8cWwqgYXN0FQ3xgpn3C6Y5zsUHyWukkZhiAZTj8SZBwqk8EcmgmBU8EGTiwiy8cit2UnfUlQEcMpR0kzIwA1KjhLUtWasBh0y68wJtTIWm4tdq8ZvrDTR8M2U30Ag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725309; c=relaxed/simple;
	bh=5+vssfjkiy5c4ml3ho49nSu8hSr06kZmf3TgkrXZkzw=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UDjD5202LUR5NDI871Y3+kkX9a86RPmZcBvwAikCaeeFI4Sx74En6HFIgFbwaGP17CKP+m1INf9bUNJVMOIbzgwVcoeMWDraz3z28b103gP54mRGFaTX6yBNLlHsM5PItoR7XmdzIXw6wJf/EPc1ynUbv30zDCdO2er0BhNJNFM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YoaF4QwE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=renh8g/d; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YoaF4QwE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="renh8g/d"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50O8gktQ001375;
	Fri, 24 Jan 2025 13:28:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ocO/6jO0QG7SZ0i/zcF/+IWS/3ArTASo7V4uZh15mbo=; b=
	YoaF4QwEKp7NQbOkZ1Jm8BxIBXiAVvf4+7moGHxVJoTHIeBf846UH9hkuP217DPr
	3LzmQow9w7Q3rXKxDsW2Mokk988QeIs3SwfcN3RBgbucxsQpNhezMrnGYCfhZJ0X
	feNI7qwYXzlgeCJKhp1rjtlaDJ/OEzy+dxSJhrwxhH0cXLHNg7IRdIVNEPGkNvrw
	mcvVuOVJHNjwMb/RkB8cKSof+OyZmn2EVoj9AMNeDbILHUtWWoDooCkeyzy4RJdS
	fUlimpLv4bD2iu8CFU11SbONJF67l0AKpuOIbYLu8kF+P0wytfC5kE88qvIRSP+Z
	r23/X9NDXorkGCykWhtCiQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44awyh4pap-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Jan 2025 13:28:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50OBisOA030420;
	Fri, 24 Jan 2025 13:28:24 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4491fnv2rp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Jan 2025 13:28:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d23E7eVWopW2qQh/h7pvQzxarzZsLm11gIgrhb1yMa16vsLRkshbR7wkQZrSb/eb/nUvslSx0h2gpkKeQveYS2Y6nnkdSKbDSflI3XEEr1f/EvxxpnPgXwwB/WN5DS9a9LVK1p9hdsoy4SUAQZY2UzVzKmFTVf9DS1sw6rHR+7WoMzbfP5YGAxi25DwFoc0ZPeKMb1f6E12PAimey83ubov8lN86Ro31hedbK4ifo5M/E0giyeVREO5lPMkoMVKsjSIIpxkLhP9lbS0oBJYu6Jw3uYLij7GvTZXYdjA3bAAT00+K1uxitDA4mIAn21HbVzfgf4Gr8q4xU4g3VBC2Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ocO/6jO0QG7SZ0i/zcF/+IWS/3ArTASo7V4uZh15mbo=;
 b=Yj63+MWdOWiPn1eEgjWExJhMctpHqNYI+r+g6pNOHZ5IsdGkFK6fz+BRvIrJW84CNyXUxmU9xN35HKeUVNdWcD+RLbaflPlFVd8uYR4Se010nx0zWkJMKxOxTvHgEvKqN6m+HbzR10esxSBs6hbKQ1STMyG2OQgtvaoDhYL3lNXgii4aDnk4FYRHJPbOMqGsJQ1fgtMSgB/uZcsX5Rbq/ere6yatZuZMud7JhVkTRUFRH6IhYMhmH74CL/qaSU20LRm5zjUfQc6V1DgsdBreUATgIY7e7q5ScQSqfn9B0uHbQY4+86YGdm25RZNZU77ArFc3ooA7bJXbu6PEULDGCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ocO/6jO0QG7SZ0i/zcF/+IWS/3ArTASo7V4uZh15mbo=;
 b=renh8g/dngkX+DMeVTJgTcIm1sAXVooATtwPmJcTgQoK5q5MzScgkI7wAcui/wNh5eB+IJtiQCT1kwy5310l9Mm5fPnOh3bIZ5uigybuk8ZAbvRUB2INCCaDCB1ChMGq7BKXDEXEJGoaw9wAkeyq/lNI8p3naM2fOv4IO55NGDQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV8PR10MB7822.namprd10.prod.outlook.com (2603:10b6:408:1e8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.17; Fri, 24 Jan
 2025 13:28:13 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8377.009; Fri, 24 Jan 2025
 13:28:13 +0000
Message-ID: <3be87d52-2e0f-494e-8583-a80680b0a4ec@oracle.com>
Date: Fri, 24 Jan 2025 13:28:10 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] dm vdo: use a short static string for thread name
 prefix
To: Matthew Sakai <msakai@redhat.com>, dm-devel@lists.linux.dev
References: <ba07663c444baf7dfe539f41f9cb088354af4106.1737584895.git.msakai@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ba07663c444baf7dfe539f41f9cb088354af4106.1737584895.git.msakai@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0462.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV8PR10MB7822:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ece1b5d-eabd-4f60-e7ca-08dd3c7af373
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L3doRGxSa2llYzdRVWRYcGtBOUJsTloxd3BSbGtvRkdZUG9RRFBmNzVvbnVp?=
 =?utf-8?B?SVZxRVB3UVZXSkN0cTh4dFNBcE5CR3BZZTBlaFJPaEhjNnNiOVNzcVRjTFll?=
 =?utf-8?B?WHF0a00xVDI3TEs3ZExJbUY2a3BjcUtDUFlhaTRZMlM5Ky9QYTE2dGhsLzdq?=
 =?utf-8?B?RXBYTWRGbFJoaUlGbzdOaDMxV1B4clZnem9Ud0paYVV4SUF2Y2l3TFpvOW9Y?=
 =?utf-8?B?SnBWNmI2MmZBbldNVHdZTzRRTVhRd0ZyT2Rkcm5XdUEyQU9ZOXNmRmFWNkpM?=
 =?utf-8?B?L21mWEhnTHpaNERCeXNTOEVFWTlTNlpjcks5cjJYcEsvQVE0ZWIxRVpDbUpp?=
 =?utf-8?B?eSttQVVNeU5WSFZmQVk4MzZyMUF6ZmoyUElLc2lEdjBQTDBnOVRZK2w3OHkw?=
 =?utf-8?B?cWNZeVBERnU5TUNXWnpMRS9mMGRXbk0zRHIyQUNhSUxsbEpGM3pXNlJ4ZTRS?=
 =?utf-8?B?MzlET3Z3bjY5R2g3MVErRXZPVHJxNWh6dDB3UGVEdDBxSnlUL2FIbVV5Z25K?=
 =?utf-8?B?bHlpUDRlaXVPbEk3LzlSVkx0ekpZTVU4NVZyU2ZSYmx4Zk1kTVgrdkJnVU1C?=
 =?utf-8?B?Rmp2YUhRT1hHZEZLOCs3QldqRXdidytvUHJuYzNqbnh3WnZhN0l5SzFYZlFz?=
 =?utf-8?B?Um80R0ZTanJSU01LdFZiMmEwRURDWVRvTkYzN1N4UlVHZC9EUUVQYVFiNlhq?=
 =?utf-8?B?THc4TXlIYklnYUMrNUczOU1BdDlCVXpFd1I4N0JFbU51S3U0RGEyc2dRSUIw?=
 =?utf-8?B?VU8wUGk5cGNWczhOWG1BZ1RQaHVIVGhJNTRIR2IvSWFYdzJNNGFjU3BxY0lW?=
 =?utf-8?B?dkQrR1pySG52Ui9hS2VJMzdkcmRMRndMNHhieVBhSFpsQ0k1c1hSay9RWVQr?=
 =?utf-8?B?alZ2Wm5pM0ZDYzBXbE43d3ZCY0VGb3ZhbjR5WGYyWFVQN3ZSRVNaOENiVWVx?=
 =?utf-8?B?N0w4cXRDdW5DYy8reWFTR0FnOGROVW15TFViTGg3M0UvdytSbnNqRnhrQXVp?=
 =?utf-8?B?dEg3TUE4QlFxMWJ1RVpvUzJRR056YXFXa3JzaXQreHJSeis4SitlcyswWjJH?=
 =?utf-8?B?akQrTXAxU1FZMG9ia1Rjc1VwVVNRdUZ1b1dpcWRVWGhxRTBML1B1VjVPNzNJ?=
 =?utf-8?B?a1lPWTFiS2tKU3dDYklMUkJnQ3lXbnNxWm9NSGZlNHRlUlFqbE5sL2VHL1Q5?=
 =?utf-8?B?SUEzalVEdHl4OUhOQ0Z2Mno3aUJZYWVJQ1g2dU1aTlpVenV3Qk42RWNwdlpm?=
 =?utf-8?B?enNKTytwNEFSenhxc21wak5tZDNYL1RDZ0VzdS9OQ2l0bmNCZFd6TDFrS0E0?=
 =?utf-8?B?OTByMmEwdm9UVjRFVlJvMHRZRml0QzlWdkM1bDZSNS94UzYzRk9hWXp4c3Bo?=
 =?utf-8?B?bU1CaDZqdWtWWlVrVytiVjdGVVJ2UFFVWlcxQUVDamxFUnRsWGFwNDBKeVhz?=
 =?utf-8?B?YXZFcXRLcmEwanVUZXByaXk5cTRkeG9RK01pQnZ3YWNiUWhEeXMxOXRRTmlm?=
 =?utf-8?B?NXluWWNkS1FBSGp6NTE0YWFQSTJKVzA0ay9PMXk0SlRQVGd3ZzhFMlBTNmcv?=
 =?utf-8?B?RFlkVFJkdVJ3OTZneTBVdlpQVUp6Y2VMaWxwK0hJTHVRbWxadG5LQ1JId3U4?=
 =?utf-8?B?bi9NT29Ta2t1dGE0UVdMS0RObWdna29zR01NeDdIS2RXNUhTYVA4Qmc5eWM4?=
 =?utf-8?B?VkZxQkl5SHN0RCtOeWhuV05iTm9oR0dZZVA4R2g2dlFPN0Y1b1Q1aUpoQkht?=
 =?utf-8?B?dk9KRzliaHNMeWttWnYrVkdRN2NxWjFSdWNzZUtZdEFvVWZjaFZYOVM3RTdh?=
 =?utf-8?B?MFZTSHZYTjRleXNHa0xXUVV1aE9UalpHQVNTcnZQOGtLUXI2V2NzNzQ5UldO?=
 =?utf-8?Q?QpqHS0jyJXFz8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UjNIWWxqc1pxeXd4eVNsRlU0S25icDJvRDVGTC90SXRVMFY2NlRVSUtxaGta?=
 =?utf-8?B?eTd5L0Y3YVRGb2VhY0MxQzNSU0NvUi9OQzF2OG1VSDJ2VlpTVzBoaVhUd1VT?=
 =?utf-8?B?VnhCZ0lESVIwcTFUdTZjSll0NTBQKzk4Y2FTL3E4TjVMK0N5UFBDS3hkT3dp?=
 =?utf-8?B?aFc4bGN5bEtuOWtseXV0S00rbzlrLy9aV002VkEyMlNpaWJNeUdWT2M1bGtD?=
 =?utf-8?B?MFpiUUpFVU13bTllZGNuemJ1N1RmMDV1a3NCZ3ZpeGxVaGdNd3JPc084TUI0?=
 =?utf-8?B?TmE5Y3YwZ24zOVoxUVdXemNjY1ViOEk5U0M4eDMzQVR0c2kzMSs4cldWOC92?=
 =?utf-8?B?THpBM0dxMXZIeXIyNTJ5OE8veTU4VXhZRXhVOWJJNnFGbEpaYkx2amtyZUJa?=
 =?utf-8?B?bCtET3F5blFKSHBRRU5ZMWxhamhXaU9xbGtRbVE1NWxaZFFrd2xuVjd5K2Fu?=
 =?utf-8?B?SUxObnV0ZHEzZGVuSXlvaDdkNVZPbFVYTmlPaWxacFpQanNmZnUzL3gwblpw?=
 =?utf-8?B?N1gvNzMrVXcvNEJkOGdEaVRiR216OGdieTlCbGI1S1pFLzR2TDhzNjJkU0F5?=
 =?utf-8?B?dFpuYU1NZGFFbHFXSkZSa3liUnNNcTcxTDMwOHJOT1dtY05hTmV2OFRjaWg2?=
 =?utf-8?B?WW11SktPS1EvVjdQYkNxUDNwNDBldUdDdTJsUFhuV3hGcHNJeG5Xd2U1cjR2?=
 =?utf-8?B?aE4yamxKOFJTRk9DRC9yWkQ2S01reC84K1FSS2gvT3hSRldoVjZmMGJZN0x4?=
 =?utf-8?B?KzFYbzk1WUJTMVVsSmU0YncvUktGbXlUNXZyNGNzRHVSbjhEVXpVT1A5QzZ5?=
 =?utf-8?B?K0xNNHIxSVRpNGNFbkVIa1RhQkwyQ2NHVkF0M1FackdJamlwYmdOcEZCeWlP?=
 =?utf-8?B?aTJNaE5YYVZHcGhURkp0bEt3SHNvdldua3pWMFV6bDJpb0krejQ5R2d1WWtM?=
 =?utf-8?B?QWVQdHBpaisrcW0wVmdzWTdtUWRyS0h5ZGZmcXNhSmh0TUh4UmRzblF0MXE5?=
 =?utf-8?B?Ty9Ub3VySXBLWjNsVXRtRUpPQ3IzSGtBKzgxVE9SUGY1dGE1bzFrcmxYMmRr?=
 =?utf-8?B?WVNjNmxJenN6OXJLK1JSaDVnWklBQkFEOVlDYWczZndKTFlQS2c2R1MxME1S?=
 =?utf-8?B?d2J4cFF3ZTFncmNjTHFCMC9rcERYdXpoWTVrTlVicjJ0YU8wQXFRV3dwSEUr?=
 =?utf-8?B?TVhrQXpCVXp5SW05OHRBeGhEMU43SFFNWnFWcnlSVGJRTTZaZk0veVBydlVG?=
 =?utf-8?B?UWpPY2c5ZTNybDFxVGRQSTZrM0lZODJWMkdKb0VDNTNjdXVjUmlpQWxVeCtB?=
 =?utf-8?B?WFFodm5lUlVSaTdkbytCZnZabkFma0tUeksxbE11WVBUbUVxYmxnKzZ1SUZ0?=
 =?utf-8?B?QnBMYTFtNEVNWVBMeFJ0Y3pZNTR5OXV3RkpzTzhpTXB3OXNZaktLTGp4b3Er?=
 =?utf-8?B?d2pQTXp3VXJBMWhSNkYwNmlpYVphODBNWlF5TTZ5SmFpWXM2dFF2L21jZjN3?=
 =?utf-8?B?bjJ2REVHMjkxZjF1U0F5eDA3YnBJdXhNTURuUnhUT1JZcnBqRXhyQkNKTFdL?=
 =?utf-8?B?Rnk0RHBNam9EckpIc3hXYmpGak83SCtnb0d2R1gxRm1MRm1SRGlCSmVOUmVE?=
 =?utf-8?B?Z0c3WlBaVTBaSWdLT3V4RG5wWEV2YWVDL0ZHTEkyYlB3Y1grNy9CeWVFM3VL?=
 =?utf-8?B?TUxJOFk5SkNncTgrS3dLSE03MUlqdy9HTTV0cU9oNFowcHJvREFkTzNOOVFy?=
 =?utf-8?B?dHNXNUNhSXppM2l6cFB5M2FBVTZ2c3cxUEdua0cwS0dUQkR6UFhHOWFpY3ZI?=
 =?utf-8?B?NUFSdllaQjBMSllTYWV6aTNWTk9McTl3S3MzRHludkNacUpCZy9PUllpQ21L?=
 =?utf-8?B?d3pJeGxpRGFOWTdrVE9BbTNXTFc2K1ZHRldkakpGZGpaQTEva0JBTVljVG5X?=
 =?utf-8?B?eE9NZnVTTGFKTFlnejRkeGNEZEtpSEkzK1NSRUN2U3dzRE0rVXh3LzZGbDRV?=
 =?utf-8?B?ZDJQWVAzZ25yUFBZSENVN2RZUnNRWnBlTTJwQ3lnSlZYZnlFbmx6cVlGUmt3?=
 =?utf-8?B?dG9kMWVlYzVsNDlRMWhKQ0ZRczNTUm1CcnUxUkVuU1grN1dNYkJvNTdjOUZZ?=
 =?utf-8?B?Z0dGMmxkWUdGUjR6WTZjTzM2MEl0RE5BT202eXhqaWRkVHlFdFNuRXVNZll0?=
 =?utf-8?B?L0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	r7DkiSaiodCP5QidPLPq/cFMpJsZvw1NyRSpi25ZokLx4SMH0fZur9DzgVwSVMYiEUdI+5+L83FqaPph8EXvAPvPU82+9sUbiSsi+Hw8zAlRAsI39nWRHvbHnGHNov08cMhcPXeDJvO9xmEBXCwgR5US/Fu0mKD9DEyn83TWCUbj4phIqXIVDTeeo9bqHdJX3xhgpewaVf1nyd+5nrbJJ1x9x85S3htHlgYPXH0Eib7URSrx0MSDsgxiqpdrgeGs+LPI5/5aK28RS8bcgpokeIKTHU5TC42ui6MZfs8KrHTkdVf7bHmWoIy8vA8or7x87rTMhfy34f8HmPewp/1X8Jy4ASMPIlUFQ4wR4RtXXKLnvSmRMYcHvTaLvyMS01FMeWBah9X0iI8Ywk1DChfddLJz9TbfWHTKNoWVI4KDDwy4OH6SUxL9g4wHG5U5b0d6veERiRaswHc5IGXxIg1Kz2YjCacRn4dk+n7FpWgboVFwkZWo0tUstq2HwTUqsJE8rrWnD0el88k/5q4U9pY5NaBvhXqNm0liTkqGT0/hFXGvC3m4tAy34jYOQuFzC6NtCOArBpXTPm2FFBfCxk3j5rmP307U7reHyrCkDr5J2q4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ece1b5d-eabd-4f60-e7ca-08dd3c7af373
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2025 13:28:13.0825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 64MmEXKR9BAddbYABs8f2MV6/CeqSKdfqviJC9SgPMMHV3fA/RYhmIwkbCPvDKPcLm3zYDUEizPc7ROHwH9gyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7822
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-24_05,2025-01-23_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2501240099
X-Proofpoint-ORIG-GUID: Ju6gn1NUvRkto_mhEjuWElYULNL95mqF
X-Proofpoint-GUID: Ju6gn1NUvRkto_mhEjuWElYULNL95mqF

On 22/01/2025 22:30, Matthew Sakai wrote:
> Also remove MODULE_NAME and a BUG_ON check, both unneeded.
> 
> This fixes a warning about string truncation in snprintf that
> will never happen in practice:
> 
> drivers/md/dm-vdo/vdo.c: In function ‘vdo_make’:
> drivers/md/dm-vdo/vdo.c:564:5: error: ‘%s’ directive output may be truncated writing up to 55 bytes into a region of size 16 [-Werror=format-truncation=]
>      "%s%u", MODULE_NAME, instance);
>       ^~
> drivers/md/dm-vdo/vdo.c:563:2: note: ‘snprintf’ output between 2 and 66 bytes into a destination of size 16
>    snprintf(vdo->thread_name_prefix, sizeof(vdo->thread_name_prefix),
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>      "%s%u", MODULE_NAME, instance);
>      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Reported-by: John Garry<john.g.garry@oracle.com>
> Signed-off-by: Matthew Sakai<msakai@redhat.com>
> ---

Looks ok:

Reviewed-by: John Garry <john.g.garry@oracle.com>

btw, maybe there is some #include which is not required since 
MODULE_NAME is no longer referenced. I am not sure.

Cheers
