Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1363A21CA1F
	for <dm-devel@lists.linux.dev>; Thu,  9 Jan 2025 15:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736436053; cv=fail; b=a948RAMyzwNxDS4W+mwBKEWuOOK2KMfcVBVigiAh6I4aGwd+CEt55CHxNo1JIJNSySjBqk2eRUGF1kUqVUB0YFSdwjyHkgrVAyBsrdEXf/jiJWNivpCWoBgqQOA1dZtxXxQwx3H9Fj2FymglWDHTKmhQcp58EYCQq5TinSspv1k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736436053; c=relaxed/simple;
	bh=jWxq7kAhqA7U1GyIhHkGkxxnCU/eXNn31N3qI2hhTcs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HgRufMsi+4S5LSES+MgmAVcAWxyKEcz34sNUkME6RINmT2jpqjegCrCcg6h80089hunU34bCgDxcxam2/1CvDKfobdcqvkHScTcFRNODsYTCr6qmrq2SUD7i5hvidWzjRMay4twqNGbV1hdu4ljLeLg8E7wNGVjXhplbSww5kyo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=G3mlkcy7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0LPlUt9+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G3mlkcy7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0LPlUt9+"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 509CfxLm032527;
	Thu, 9 Jan 2025 15:20:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=6aEaqHaMmD2jtRflk27MeOSW5nuCPGntnmb0puYUN3Q=; b=
	G3mlkcy7wY2MrsjNeoETrfW5PYG3Z8Ro3LFzfIL8lKgIWnuYSnamqXM/2EVNxDYM
	1R0aNLIiJvAu1H9468kl4ZNMuOD3Cz+56C92c+clqzE0+9OBTdarbByH68/SCSHc
	UDQVQDVE2WPuPAcC57DRwWz17Zl5EG81++U2Xha/8QKvPccHRgduvce/coSMpMlI
	FE/M+gsLfjnukDf9EdJOUECn1opzG6KZHVw5X01l8SA+hvTqKNjM1P61FX68vEN/
	BOeTYSGXWBGfEAM4ghWX9b6ls5iOHjzHSA8hdYB30dmqu7C23QJduhQVwtbIJf9G
	zESLpa6lquD9WV7EQVTheg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xvkt0w4q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Jan 2025 15:20:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 509ErrQv008543;
	Thu, 9 Jan 2025 15:20:50 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xueb23eh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Jan 2025 15:20:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pYnFvAndjcsahDFzyzJWAn6mwJPzJokRNpvY+Yb1tY+G0FHi5CJcHUMUWfziFLzQfOAqsCHoPViqZKdPSAmdfaLqg5llq3SHr9XCkdjV2Wcgwq2dr9qL9CV1S1QT1I8KhMM4PB846EbUA3B7YOz+m0++p3jboSFW7ENX+NyWQlD8qUHg39HwTWPrypnafoPdT+PCb1e9UNk8SMdA/fGNYkCUkQJ++fWnXjr6hIEf52oASny4fz3Bwo4NPZj8c57vIRWM0L0y4FyvgGGcd4ZpEXqb0SUxSF0S/VS/OFc1Dd9XCTETvq0t+GMtpzKxo43EKRJwbI955JP3CjgD3YjfKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6aEaqHaMmD2jtRflk27MeOSW5nuCPGntnmb0puYUN3Q=;
 b=tPaQm9wWpzbhhWvWr0zKQMPt9pq1alFkmZjnv83hTsK7X4Lg5ZGXXCcQHzrv0Y6V1qXuAL0SuOwcnjLTkoPJ6+8P3295991ES+ek8Q86blki2eVeWQuHY1EoNkYNROu2Vb8LcGafeeHOC4MjaXicajbDX0UJalOtE7k6WqmDgOfpJyrIzplO51bx+bucJbPP4oqeF/VYt8hqCF8NMNuz0NlA4eTvSknL8USAz5BmPLAdxHdD5Ldh76cqdUewZADX2vSCcchWQjg17qzgc6vOWStkZdSZqitzqNpgE7a248u1mMx3tvHL6FsBH2oudtgilUHvnsktR5U+kIc6zW/j3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6aEaqHaMmD2jtRflk27MeOSW5nuCPGntnmb0puYUN3Q=;
 b=0LPlUt9+j4AFQypSG8JpOymlb8k3BRmwAgPCkQ7rehqsKLpPjdmVnfK5XYRk5NF83mTewIrVgBNU8P9p0g+JmJrQuD83OXxVpn98gpkdY0UtX44Ug5QdFPp/yE8r0obJwGVCs5okmfX+BVdoLn1EGZ52YFvHoL0lGM+eXzZzcfA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY8PR10MB7378.namprd10.prod.outlook.com (2603:10b6:930:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.13; Thu, 9 Jan
 2025 15:20:48 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8335.011; Thu, 9 Jan 2025
 15:20:48 +0000
Message-ID: <be0b975b-232a-4fea-a1b8-85755b81eb74@oracle.com>
Date: Thu, 9 Jan 2025 15:20:45 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm vdo: Fix W=1 allmodconfig build error
To: Matthew Sakai <msakai@redhat.com>
Cc: dm-devel@lists.linux.dev
References: <20250106141731.1341034-1-john.g.garry@oracle.com>
 <1d3beb46-c244-4ecf-8bd6-1895954c8e4d@redhat.com>
 <a9b32c24-f380-4a0b-a59f-16e2e87a833b@oracle.com>
 <d0742bb0-bd51-4338-97a2-6454d806de90@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <d0742bb0-bd51-4338-97a2-6454d806de90@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P189CA0009.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::13) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY8PR10MB7378:EE_
X-MS-Office365-Filtering-Correlation-Id: 13ac4f6c-a8a8-4798-74ef-08dd30c13206
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZzQvUmNYQWxRVFRRc2pRU2NpZHVtUDRRRXVvclNFM1FZeUw0a1VGemdrN3lE?=
 =?utf-8?B?c2dPb1dGUzhEWitoNTc0V3p6R1libWY2ek8xY0ErV09PeGZva2o3M0hXQkNL?=
 =?utf-8?B?T3RiTUcxR05LeXN1NG0zTUJHU2Z0YUduNlBtcVRDaHZHNGdqdnlNcUFQNWZh?=
 =?utf-8?B?NmxoWndVcm11RkJleE9FQVVYQW4vbDI0eGpSNExzYlJycW1RaGJ4ZFphRWRn?=
 =?utf-8?B?NXhybks2Nkw0MlYxemY0VnE1M2VUMlZ4cEEzZ3p6aHZrUHFqOVA4ekdURlUv?=
 =?utf-8?B?TVI3aXNKQWY5L1ZBa1pQL2xNeTlXQ0c4UHF2MUk4N0lwQnNJenJOV1JoN0lS?=
 =?utf-8?B?ZlBsV0g5Q3dJbXRLUEc0c0x3dThVMjFWZng2Q3UycGN5K0pxdWZkL0NuTEtK?=
 =?utf-8?B?dDJjVE42clZwYXRwWlEyQXhCd3cxVmhpQ3RGQTBTemtIWjAzMFpieDk0TzdC?=
 =?utf-8?B?M3pyR1BSODVXd2xvWlp4S1gzaEpxSi81TWlxQ09zbm5Ucm1rSTZhOHFCbGt4?=
 =?utf-8?B?dGRkb01MalMvLzE4SS9EQjhhWGhtQml3QTFBYXBDL3N2cWlDZStlWHZGbDVH?=
 =?utf-8?B?dGxoR1RmMG4wTDAvSTRQOVhPc21nSnYraWZ0M2Vlbk1IK1dNcGtZVGhtTU5E?=
 =?utf-8?B?THhGakNRaUM1Tm5hT1YwSlFSZC9SNHJPOUR2Tyt1Zm5JekdzcU0vTWZWZXRq?=
 =?utf-8?B?WDV2dHNsdzJvR0h3d0lHZzA0WnRnN0o3WmVhazZ6Vnhld0oyd3lBR1Vid0Fq?=
 =?utf-8?B?a3hBWEtmbnhYR0E2QnFoREdPZjUwcnhqTGEwZzNxbFJ4ZlZaTis2OUtqbjU3?=
 =?utf-8?B?aDJsYUVzOVdnT0NleHBtc013bjBUaGdobllERUF3TmJTQjVNUndqaWcvOXFu?=
 =?utf-8?B?eS90ZU5vZiswTEhxTVRacjlaSjcwYmZHY1JiYTdKR3pORjRjbWtLdGRVVzc5?=
 =?utf-8?B?ZFo2R2V4cUZUSDdjSUNHaWVhY0JNU2s0RFNvZ3N4Yk9OcEwycnNMOTQrMHl4?=
 =?utf-8?B?dGtsNjBVUzRGOUcycUhRTzQ2bEdUcWk2L3JrVmVWZko2K1lwN1QyMzduKzJ5?=
 =?utf-8?B?MDlINUFRbDF3WGMyeGhpNXB6VEREdSt0U1MzT2VEdTUxcU9pU2N3aGVhSzZU?=
 =?utf-8?B?TG40WGUwSkIxYlpoRHhUbnVaaDV6TU5lNUFwM2FxbityWk5NSkRQZHo3dGsz?=
 =?utf-8?B?VzBrMDE2TFNaUVpmbW1ZNlQ5eG5tMi9NZWRWSjM4ZjJGRVM3a2FoNGJWMitE?=
 =?utf-8?B?VUlCWmU0VzZzdGxydUZidXpqU2NEQnFHM1JOOGxCb29UU0FlRW1KTHFVditK?=
 =?utf-8?B?T25wN2V3U0poS1F0Q2pPVndjNVFwcUx5aUxSaEQ1dmZZNnRCQkVOVFZBaGty?=
 =?utf-8?B?SFBGL2xTRjZPY3oyR3lwd2NrWlk0Ym5LcGJsd1NScE9TQ0VyYlRneVd4S0Zj?=
 =?utf-8?B?QVRNbDhoU0tiREk5K0hhMHpSMG0vYU9sTG1oYlZYUE9XbjVYWVRqTXNNeGVX?=
 =?utf-8?B?N3FTTFpPaHBVbVJvMUZRRlhnSS9tYkdIbVgyQ1RFMU9kaS9KeGdjYlV5ZVNo?=
 =?utf-8?B?eXoxZmVZZUpjZ3I5SkRScjZ4bkRIUHZEM3RFTVgzQVNhTVk3S3ZpQ3duVUVz?=
 =?utf-8?B?eWpOMytXZHJuVjdsVy81OTh6QmRza2ZIU2UxWVhqYkdoOVpYRXpuNWJtMkFU?=
 =?utf-8?B?L2h1eVEydElXNWhhNzl5SEcwY0tEQ3RsUHNEQk1SQmNhM1VZTndOaExFaFhj?=
 =?utf-8?B?ODJ1RkcyTEJYR3ZtREhpemV3SXhxaGhDU1JvTkpWK21lWTFBdUVVSEYxbndp?=
 =?utf-8?B?VUZCL1ViNDY2d3k4YUFCRm9DMklMWlJna3hBeVkybHg3eFVYQnpkTWdGTnR6?=
 =?utf-8?Q?Pixfwny1vRh74?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MnprcU9KZE1Rb0h4R3lRS0tWNTZwQXZRY2hiODlUME5ZVlp1NjdvbCsyOTBt?=
 =?utf-8?B?WDl0a2JDazVZdmEzQ1JuQmZjY3podFh3di8rbXlIU1ArLyswL1dLSHd3bmVz?=
 =?utf-8?B?YU9yUzdSd3pacXdKdnRwejVJMkxXZjR6TE4wQTh6dk9saWd5cFlxL256WVF6?=
 =?utf-8?B?aitOSjhONHV6UDgxbG5Lby9FV2dmSHVnMUZFN0htcnZpM3kwMkdpRXdPZGVp?=
 =?utf-8?B?QitSUEN4TGM3Q0l3L2V3RUZhSlNzSHRHdXR1SCswWmtGTitzRnl4cGZCaUxw?=
 =?utf-8?B?RjRzeUhReERpUVpINWE0Q0IzejJOZnVVWXFjSkJBTVEwUnJMRnZ6aEFhWUxZ?=
 =?utf-8?B?M1J1amN1ZllnS1Jvd3Y0ZDdUTkVUczN0RTA5YnYyc1J1TVQ1SnFCNW1DZGxR?=
 =?utf-8?B?VDNDdzE5WC9KVnFDTWZBVGhLNGNNWHIvcFlMSVZrNURjY1Z0UzlsN1lmRzBH?=
 =?utf-8?B?eVFQN0E4TWl4U2NQTGx2cFpIdEpEWXJuRmlNTUFtZFlNNDYrWDdoMzVHRnM3?=
 =?utf-8?B?RnNVaFkzZ2tOT1JNQ3NCY1ZVanBsN3NpdTRab056NFRWVDVCZjVrUW1wNWJO?=
 =?utf-8?B?aE5LM2xTSzBjU2V0REtNYm1tWXRDd081dVpXKzN4SG5QU3NyUGh4Y0JPeDlt?=
 =?utf-8?B?c3NpVDBQWTJ3Wjh3eTZ5WS85SXlRL09wZ1VwUEJCOHpvbnpJa2ZKVndvT2Jl?=
 =?utf-8?B?UndHWUJTdmxJY3pKaG1TZzFYZVQrQkN5MTViUXdPa2RqY2orcUZHZ3MveEh1?=
 =?utf-8?B?RmMxMitOeW1vSGxVdlhTWWdyK0s2RXo0TW82aDJiWVlnWDNLRGlzMUs1NFNk?=
 =?utf-8?B?YmtNV1BsWGlzUFdvSmxqUzNrZFFXdEdBZmtKZnBlSWIxaUJKU0NVZDd0QWpM?=
 =?utf-8?B?VU5pOGg5dWpZYmcrVllQMmFubVBXMG9ZaUJXQlMrQSs0aUovYXpzZHNjT1lD?=
 =?utf-8?B?YXFxNDFia1R5dW9vYkRGYUtkQUgzc3c4emFaUmdWTFVMd2ZJWTRlRVFGSVVZ?=
 =?utf-8?B?TkthNmVWVHg4dDFKcFlncS9oMnMyZWt1UitteCtZV3RGWGNGeHRTN0dwR0ZS?=
 =?utf-8?B?WTJEcVhQMEpXU3lRUWlIa0dPaGpyWE5jTFpXTnRlcVVJQVJtUEdQemY3Mml5?=
 =?utf-8?B?KzlndVZXUnUzeTQ3YmdqaHBEeUM4MHNvSncvbGpRRXAyeVBIQm9pUkwySTJy?=
 =?utf-8?B?ZUNNSUtIQ3FvR0dJZy93UDZNMUVLRFIyOU1YUUQ3Z0tmaUhya3BCcGJvcGor?=
 =?utf-8?B?WXBxQnBqNFlES1pTa296M1ZvUFZONkkrdW1zUUhIOFJjSnpzM1dwci9pbVZV?=
 =?utf-8?B?M1diNXlvRFNCczNaWTRMY3FBSG5kcGxVZ2pPOVRVclNPNHdrK2UxZjhZWGNZ?=
 =?utf-8?B?dWtaVEVPb2twR1BGZ1hXSEtTeHVUclFoSm55b1dyVEZ1b1MyMWhmcjk1UEsy?=
 =?utf-8?B?cW5rbHRYVGRWMlo2dzB4MUxibzZPUUlDOHB3bU1ldzJTbjg0UnNxSnd6S2pJ?=
 =?utf-8?B?ek4xOTBZYnBIOUpLcnhuOElyNTUyNmRHUlRtZ1E2TGJ0YnF4RTFFNWZ6TGln?=
 =?utf-8?B?Mzl3TloxUGJGYXJlZ0FhSVBTWmJYWTdQYmt1azEzUUZZTTRxb3YzbkZYUldx?=
 =?utf-8?B?Tmg4cFE2WElCOUZPV0ZLRFdzYUFqbTY3MlR6VWhKZkExMEJyVXdkeDgySmN6?=
 =?utf-8?B?WGFtUHpKVG9UTllCbVgrYlRFNGRHNHI0WVFSaU9mWHdJZFJhQXZNTnBGUzd5?=
 =?utf-8?B?YytVZkx4Y3M5NWJzdjBFWU9GajdPVklXMU1yOTZCQ3FTTjgwZFEzZ2tNVjVB?=
 =?utf-8?B?c2E2Nzk4TmFsUjQzdEp4em00MlNkQ3ZtaG1pZU84dERDa3RNeTE3TERMR3pV?=
 =?utf-8?B?QkNWaDg3Q3ZVUG13WEdzTFFFSDlpR0p2U1RBeEJTT1Q4b1laYTVkYzg4blVY?=
 =?utf-8?B?aVBNanBNRDVGYkl1OXlVT0lYbG1BK1BTa1dCK0RVY1NIOEtyQmo3eGVqSTJB?=
 =?utf-8?B?WUtydTRSbHZCUlo4R2VnY2ZaVFUxZ3JlSFQ1dm5jZ1pZOFZBbjhVdWcwd2dW?=
 =?utf-8?B?eTdnQW5vRHROWDhXRzI5TnhWTGhqaUxLVTBReS91YTdQbnVXVzkyQm54WGtz?=
 =?utf-8?B?WEpLa2o5NDNvRGVFUzFFOTdmNE1TdDMwR2xidC9RZjBEU0NnQ0hjNDhSK2ZV?=
 =?utf-8?B?NFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZwahdY0X3xmJzQ9QkqS1eNcHlqvjfeCLqayVUAKDmY47LdbTBopqdUsn+lbMh5bAlKfu47lBvnHgrCGKl1tC8ucauc6w/t1W72cKCqSTav55gqVSdKludKWw+XDvj8HKx0ClkmPilaRKTyfsXX4+HmRHIof8sSFAuXxo6LXI1PLms78OsAnnk1ikMhpzuVSk+vpAd+nPkpR+Vn4n79J5DdiwMXqCt9OJT76WtzWNrOXkV/WcjoMhVKmLMj/i5B06vMuBZoYpbL1X7CF9u26J5xGcvnIpPxqS/bmZwRzP4fhLQOpHkF8n212HlsCcsgveMzeGh0fUU5GE7wTAOvivAbBGKrdSJ52wpYzQJBpZSoSlD11mZTu7aRWsAIlkj0S4nk9W4ho5Qo7ZgMg9ywGEVUvOFLeDkSq9QIAb2rdvwbijFkE7Hw6mxzSzKqHSFz5HFMWMlaysieCNX1z2tGLvTF/EKDiXJvPohaFPjulBlME790b7r5rUFmalnh/p66pXDocCq8c/3jlO0PNfF++DvWRsD1xNoslc0wG6axN82sfPoWVHT/J7pGyx8pEMaOnxj9QFNgmnvXG+h2VWhJ1rFvIedB7UktuUf7Fdx+a2YK4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13ac4f6c-a8a8-4798-74ef-08dd30c13206
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2025 15:20:48.5665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AvI5f2N2/ud5HW9uHfFB/F4isH4DQM1WUTnfon4CzIO8IJU7xpQ7r4IZ6xBc7zZqOREWYsENdBxwO6RMjvBCdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7378
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-09_06,2025-01-09_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 mlxlogscore=895 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2501090122
X-Proofpoint-GUID: gOdH8SHEAEAFXXOtiPTkd3xtQa80wkvS
X-Proofpoint-ORIG-GUID: gOdH8SHEAEAFXXOtiPTkd3xtQa80wkvS

On 08/01/2025 22:44, Matthew Sakai wrote:
>> BTW, as I understand, for CONFIG_DM_VDO=m, the module name is 
>> "dm_vdo". So why different MODULE_NAME if MODULE is not defined ("dm- 
>> vdo")?
> 
> That is a historical artifact and it should just get removed. The module 
> name should just be a constant string. I could write up a patch to do 
> this if you don't want to.

Yes, please do when you get a chance.

Thanks

> It might take me a couple of days though 
> because I'm still dealing with some holiday backlog.
> 
> Even after we do this, I still think the prefix string should no longer 
> rely on the module name.

