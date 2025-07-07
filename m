Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E100D275867
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 13:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751894140; cv=fail; b=uH+xVuG68Rt/tcGxlvLWP9C7cTnbyDz7Jl1najUIDs7jrRgG5vjCluI0potzX5dqbw5TUImjtmsFPwqeHUem/ttOa3Wimd5lAKs+YD7ACKziTXCFKJPScIpSLoBp0r6h2vguSHrzAkiQfjJIH7SFZRk7qCj6+ojvkO2gtjHflq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751894140; c=relaxed/simple;
	bh=d1TYsUVOe7vrIZeo0iiXAxlIyjtKUN7pOyCq4852v/Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NwGmN03JJFF0eYBiBslRszeo/WBZJllFivIc6IjabPGuDde8f4zq5XrzIE5/7ZgPN4tZiCwtrizMJ73GqrHMRbQ/ak3/HJfx8YoGLxS5F1GefQoQFARoyCMgJ6iazu64GZ4wrkSTVGcSjRLI14WN1lJCi3bsLeMIZDityuQq2vY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g1WgHDVc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JIJmMEqw; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g1WgHDVc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JIJmMEqw"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 567BMcIm030154;
	Mon, 7 Jul 2025 13:15:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=BWphf5UrGOnKs535X+mbH7HEphlKv7rwnoeEt1L5HRQ=; b=
	g1WgHDVcqwwpS3YDZ1AUCkYDBZLIljfElOr8SP2e+WQiFCT43hgiKCJwQ4m5g6zW
	fa/NHB+kc0O7VCZqkEW7Cf/vzxwCIFoBSaxRpGyUMLyp38R3cDKVP8ejo23jL/1w
	lyFQ4JkS0SUdQBrXsuuO2v8UagxtPiUY2h2MENLXEUz/dmHEh3CeDT93I/ofYkFn
	YszEX6daCoI1ntZbgRACYA+R3nW7gXhLA2M+JGIR1GP1IjhZETKsD/H8bdaddIiY
	exxQIc4vg8qvIx5j2cM64SdKaZL/tcDAFdXlm/NTRk65qf6s3f6u9RERK5LOc3Lv
	Gau3jC0f53weg5dsAOrAWQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47rd9yr670-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Jul 2025 13:15:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 567CoUAU027434;
	Mon, 7 Jul 2025 13:15:32 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11012055.outbound.protection.outlook.com [40.93.200.55])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ptg87bjr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Jul 2025 13:15:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LAk1L1fei140W62hjkvxScbr1LJHKw59MXNw/k25K2qMHkSOWEJPHhAyS+9lSYL7AYdMFIo27N3TlzPbOeP09gJo/RXzQqvTf3UH7OH51O0VQ4Z+qaImS6hUf+poKAVUvTwj4AQurHBiORCCvPNOEQGk7Himx2KiZDPPw5U6WiONgaR6RADRJ+6Gb9z48vVCZKrWfGjI5tfG/SUWtXlxXgf2k+hfreW1/QQ0XntHquMQ3eQqH9YwP07FsLociDhhcPs7TZiYBy1x967VG8t9fz4tjIEqSBS6HsLuBUa1ShXHPRsN18spTDxUgBagtklx+XCmRswTPdtokwb6cWOguA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BWphf5UrGOnKs535X+mbH7HEphlKv7rwnoeEt1L5HRQ=;
 b=F1tF3Lxxc+khEDPuYOk2iEDv4sk+FqeArsNKrUiNS6CCxqyCpAbJNYQ8rx72RkL1VjrGtlUpseWFDkZTODEA+N3ApdS657ZldmOlkdi7kUFmnCawkGtyACpECS28xwu2ZWKIMX19H9G15Xc+I2f5oFye+TZGLALYelhFPhGW1P+K3llS51keaT8PrEGwgg/nXcEJIBWqS7A09s05Yi1WnEMeMYUaQ431DXL32QEXifitOzOmdkCzP3m+Svly8SqBrw4WyvTLVz7oObIfuWyoMfTjjFiTJnoAesCKQw6TfEyMD6A2d0nOYu/W2mHU/gDaZNum+DBlNekhq0/EtYCsVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BWphf5UrGOnKs535X+mbH7HEphlKv7rwnoeEt1L5HRQ=;
 b=JIJmMEqweC1jufujn1yTPWZ+pTYAzQjarNQ5SclFOvjVGCmEG46ia0fURBdI6G7LfznwWUWw0cNYkudR9+q+IKdSuvcH8/q3MdkUU1DQZ2pf91FZBZ5p5lbjWEPN4Lp82+d3siz4uPqYuPgwTyYZN8fzi4ovDMknSXERaEVQpig=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DM6PR10MB4201.namprd10.prod.outlook.com (2603:10b6:5:216::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Mon, 7 Jul
 2025 13:15:29 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8901.024; Mon, 7 Jul 2025
 13:15:29 +0000
Message-ID: <a7053dc4-aa58-40c3-ad46-ad082902ef2d@oracle.com>
Date: Mon, 7 Jul 2025 14:15:26 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-stripe: fix a possible integer overflow
To: Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev, martin.petersen@oracle.com
References: <0f1d0d2d-8840-a256-d628-39e074f021c1@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <0f1d0d2d-8840-a256-d628-39e074f021c1@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0037.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::17) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DM6PR10MB4201:EE_
X-MS-Office365-Filtering-Correlation-Id: 975ded1a-f414-4426-2a73-08ddbd5857f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M1JiSXltU2hPK0R0R3dtdTdKSlZhY0xIVW9qbUdxazg0YjNtbDdSOWlrdjlJ?=
 =?utf-8?B?SDhaM0hML2RhK3ZNVUx3cVVJUCtjazF4WXhQejhCSWJTdnlacnd1cW1KZGRp?=
 =?utf-8?B?RndVdjJ1QXJhSUtMb1VSaFQyM1YxKzk3d2FGK2FiUVBtQkZVbkJPc2IvckRs?=
 =?utf-8?B?WnN6blRpZDhBTFRFemtpU0NpNEVvV1A2bXlxNEJ4eWlCd3ZPbHRyMzVSSzlm?=
 =?utf-8?B?YWpjOFQzNW8rSVNJczVoVUovdDg1TmJxMDE3SWp2VTZqUkdEVHRrdFk1azl1?=
 =?utf-8?B?N3ZtTVIyMktXMk96M3FaQnJhZW0rTXdPd0tqaU5kYytTdUhYWjdkZituNFRT?=
 =?utf-8?B?aFA1ZTdpUDRhcWlMODJYK014aTE4V2F1QWNHb3dkV3FaK1ZrYzFvSzFhWW5Z?=
 =?utf-8?B?RitZUmxycEMrVkRsYThjczBzMEdXMXJQTVBmck9sVFJLdlFQaUFGcnUxd2lK?=
 =?utf-8?B?eHJ4OVdBYkZmVkVsdVVUOGZ2NW5SUGxkTGVJdFZISkVKYlNDd2JHR25NeWo2?=
 =?utf-8?B?bWNsdUgxSDRZclAwL0VoekhYVDEvbnV0S1YxRGtPVnFvZWFjMzRvV0QxNW1X?=
 =?utf-8?B?b0NoU0xLQ0Y2MmYvNzNzaG1aTjRQQUdBSm9YczRDdzRlUWhvTXRHTTFNK1Mz?=
 =?utf-8?B?OUljMWY2Sktjd2Z3d0tEdkJxam1aSUV2UHRqYTRKWDZwc3BrSEQ5OU1tSzlF?=
 =?utf-8?B?UVkwTHU1TzFhSTJ3dFRsMHIrWkVQWWNTODl4QWdBZm1iRWtYN08zMWsxQ21D?=
 =?utf-8?B?M29VWmZsakdLN3dQREJNSU95b0dIWUhsYUptYy9mN1ErcjU3Mm43aUlnamFj?=
 =?utf-8?B?N21GdEI1YVRVVW1ibTJlbEo4c0V3YXY5Y0EzWWN4QWMyZzFuUXF5anhOZkNv?=
 =?utf-8?B?N25HUnJZdnBSZDQxb09TczhrdXcwc2NKZGNjOXVVVVhLNU9GSElRZlJpNjlp?=
 =?utf-8?B?MnI4ZHpKckQ4SEdBTng5cHRDa1FNL3JzeVlBYjA4YStqSjY2TzI0L3UwektC?=
 =?utf-8?B?aFpualB2dEgxN0V4eVJiRUNnSkFTTWtQNnVkZG85dWJWdndwNmwyRXRwTEcx?=
 =?utf-8?B?eG5OWFYxVHNQNG5Pc1pMTVFBVTZIL2dubXFub1hPVmhyL3pxSzJuTU9ESElr?=
 =?utf-8?B?bkZYOW1lT3IzL3RtbjhvR3EwQ3N4S3NKSWRZZkpkY1NTWTdrWU5RWmhrUG9P?=
 =?utf-8?B?SmVha2dyVVluaCtoWGh1ZGQ1djZ6Q08rVnQvQ0pURFA0aUFIUk9jWVJSZzhP?=
 =?utf-8?B?cmVVMmZCTFhybFQ2cVI5dVJ5eE5IelI2aHQ3eVBJbFpjTmM4SFg4NCsyZXk5?=
 =?utf-8?B?VXo4emFQOVN3WFBPcjd5cFZvTWNWU0tYTDhpMElYWHZiRzhlT2tsRHlzUFdI?=
 =?utf-8?B?eGl1YlRqK0F6cVZUSU5NQzZaekxVeVNmeDlLaEVIQi9zdEgvTUt6NkZ1VW5u?=
 =?utf-8?B?NUpZY3dSL0I5YmV3b1p2WngwUWVFekFpUkpLS0xqVnhmV3l6bXJ6a1lWRWxq?=
 =?utf-8?B?R2Y5T1RYNEV5Y0ZvVG9JQVU2NzBzSVhTeWFibGNlc2thSlJ6N2FhM1BkNGM0?=
 =?utf-8?B?VyswVmI1V2pwVlpQaFJiNnIzUUtMeHVoL2VqRWw5Y3NtSmF6MHpjcXBhTmQz?=
 =?utf-8?B?SEttclg3SDh1ZHZOTzhCaTNRZ0kydDd0V3ppSEROOUY2RUF3cldtTWJMKzhs?=
 =?utf-8?B?YXlWdGJEZ1BmMVlOTGsrZ21kOXIzU1RWQ2FCNDcvbG00OFNvOHpyNHc3SXpm?=
 =?utf-8?B?U25scmR2Y3MvYUFidUhOY3RNbThEMXhwK0dINFBxc2ZMMmpPNjE4RlRUU1BH?=
 =?utf-8?B?S29Ja0xwT2tDbFNrSXo0MHAzVVpvYlEzOHhkblhoaDIyRDlxaGJJQTdVaEI3?=
 =?utf-8?Q?qgwNe4ucHqWds?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bStqaXptSm9HWHQrWStFelAxQ3M0cXpoSVN2QWNEbHlHZElldk5KUnUzNjJC?=
 =?utf-8?B?encwTFlXT0RJNEo2dGlyY2VDQk9rUFY2SnVId0w5dkk2NXZyckZtK1VUVXN6?=
 =?utf-8?B?cmorMlRYZVU5QlVudWMxbHUySFBvU1VPTlphVGZmQndUMGxsbUV3alU2U09m?=
 =?utf-8?B?REIvOHZjZnV1R2JZVk93cGxLUE1jTHBlRTAwVUVMRGNScThsQWF2SFR3bGhK?=
 =?utf-8?B?NmVYTkhwWlJrbXREU3NWM3RwSW1xdW1tcUlwYUZ4RTZHYjlpVUY1YnY5cVpD?=
 =?utf-8?B?d1hIVGxURFlEaURFUWtBeTV6UlNFZzgwMDFyQTRoRWtjaUlhVVJtSVI2VmJr?=
 =?utf-8?B?ak03cndGcWtlSnNlb1VtRlFqdlZqT2I3N0lRdk41RUN1aUthN1pVNGZTR3g0?=
 =?utf-8?B?RWg3bk8xRnArZ1pyUW5MOTRmNFR2WWdNRUpzT2VPZ0tXclZuS3diZ2pLYnFo?=
 =?utf-8?B?bmIxM3NNRjNVWlFYN2xVUnJRckEwcEhNR2pnR3h6VFlEbDNmcG9xUHhqb3Ra?=
 =?utf-8?B?cVNVdHNpMy9oRU93ZWlVUkljTmM0ZGV5cU92bDVjN3BKQkx2OVoxNHZiOXp5?=
 =?utf-8?B?MFRiMm9EQW03TG8wdkJDSnY2WlNpRUFIQjh4VmVhelpnSkxOOXFMek1ZZ2tS?=
 =?utf-8?B?b0x0Q0c1Wmx5bjNFbmI3WEVKbC95K2ZOUmV1SnFOOUlFTDhMblZCd3dpaFRj?=
 =?utf-8?B?VkdsWmJwNHkwZzNISGRKVmZRUTBlMUdxR3A4SW9RcTRpSEF5NnZwWHRRVEdW?=
 =?utf-8?B?aWNXU0h0Ylc5WDBBT0tnSUx1TDZHaHJNMDRSOVRiL0NjWmtWNjlEdm4rVkZS?=
 =?utf-8?B?VGZXTjUyK2xDNFNhV0dSYWhvVmVVanh0TGR3ZDd4OWpIZjZ6Z3FITlI5bXJl?=
 =?utf-8?B?VzRDU01ZbG05RjlkeE4yWlBRUDhQT1E2RHF6SHlKbHc2Uk9RSDNYNWt3ZCtV?=
 =?utf-8?B?TDhvOC9aZzNsRDR0ZDdDYUFwM1hDVFJQRkhvUnZxeWZMRWpUeS9jMkFhaFBi?=
 =?utf-8?B?YitvTXNHTldUU1BRZTlxanlwQTUvMUI2dmNDVFFtVG9GN1JSQ1F0S2RFS1pU?=
 =?utf-8?B?MTBTZ0t0anRUNnByQmJsV3Jqdm5jTXd1dUJEb2xIaFdVUnl6N1RyNlZXenMw?=
 =?utf-8?B?R1BQMzhwNVFra0huTWhmMWFkLytwbUU4M2xjaHpsUFB1SDJ0K2VJUUxZV2Fu?=
 =?utf-8?B?K3oyb2syMm5nYkR4ZGcrRXg0TkdTdGhLTjZUWjlyV0hYMU11Z3h5WGo1c3Y5?=
 =?utf-8?B?VktvQlpXTGFRbGZmUUVzOS9EMTVsNGlmalI4MXI4anpSN1RpbTlxek92MGxR?=
 =?utf-8?B?Yzd1VDh2blIzNWRWV0xRR3FMTk5wS1kvdVRxMERiWm9SOXdZdURlN3A3bDc1?=
 =?utf-8?B?R2JrK3N0cUJ3QjN5VzM4SkE2OEl4NFVSd05tS0RMZ2IyYnVac05UK0VSZTZp?=
 =?utf-8?B?SVlGRkUzVzFyMHpxYUNDQTNjS3djMGdiYUd1Zkt6RiswanV6eDRsVy9heWJr?=
 =?utf-8?B?NUV3ODU4T2g0Rk9GZitwZmJ2c0oyd1ROZEtML1lURlIwa1ljNGhuQjFVRDBJ?=
 =?utf-8?B?UGVwTmVSQ2lvWVJTdVdaa0hnbDJ6eUl0U2FEL1dOQWJOVVV3bVJuTWtXMjdU?=
 =?utf-8?B?RHdVUnB4YkNCMWN2NmVIZGhtT25hQWttUGxXL2JyMldHbk9FUzFVZ1hJV0pz?=
 =?utf-8?B?amttTVBTWVcyNGw5VUMzdjhlTW9pcFlhUTVZeWRNMmxjUHM0akF0TGdnaHJN?=
 =?utf-8?B?aG5IYVdkb2tzajYrRGsrTnRnUml2djVTaHZ3NnB5enNBMlBLNUVJU2FrUTNP?=
 =?utf-8?B?U3RyVmFQRHl1cW5zQ3RMR0dxYzlqOGVIblZIUmN6TzUrTmZyUDY4UlBSeTVw?=
 =?utf-8?B?cGVaL29BUzZIOERtQ1YxeGJMalcyc0xNOHVSVTVBV2oxNWY3QUNSREVwcXpo?=
 =?utf-8?B?OUgrOEJ3c29FVEtrM1JNTk91dG43SldYSjkwQWpCNy9DL0tNOUpxNVJ0Vjln?=
 =?utf-8?B?Z25JMFJsRnZPaU05QWVWOEVQM2o5VWlBd2twK25tM3A4U3JocGNvbHlXUkVj?=
 =?utf-8?B?RHBLVmRHcm5oMmg0MGNrWWQ3cEJJaWFlNUcxMnRNZnhueHdGdnhkR01ZaWVW?=
 =?utf-8?B?cjFUMG1VVnlQWTFRR0t4ekVSV2tsV2ppZVh4OGxuSTNiOGNEL25qSWpveEI2?=
 =?utf-8?B?b0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AsuJrl4a6vEopi0LXglDE30VIYtqZCJdjPh1o1XMnGtWl78LIuKiyReuKeKVMhQW3X2xUHlQg8XH7cFvrm423DRC6J6Gjn/WXWw1wD15BmXQtwxhjY1nNYtG8z4eLVAER0k6aPwi8z4SDru/cJhOHY+xJpcfD2AHMzHzlcBSa2sPO+LVCbfH2S5Eu5ds2AXh7pyxE3KwuCc9Gd/2zb+ElE/F2IQg0LVN/K779H8XgjEDlKJVx+y9Zu6gRxL4qz0eOXQRl91VKtdjCwSh6LOBhrajjMOcyewtfI228GTXUrFEXNDTliXFJ1U0jmxWaWSVK18Z3nWGExYqhrNyZn23UPgpXJp38nNbnXeplUlY8twYjx7HOTalFc2M1PdXo26ZwFS9avB8mYIhYzoeSIXNzc/Ax4JNgXzlSfygALvcnD2L0ng17Ujgs8b5PYBzmbSStu1XJ8l99yumoI9NVPR2H+GLGbpvukl+AbGm84mg/wf63ktIxqGPJWQF3EqcZ8MQ24O/MtS9Z7RAuiasjbiBOKSmJwzlcMDAkFWsyoaW80nUlhgarIN6mwurkwmiTB3Ugmdfqr8sZvbvN15LlfXeH8JK8LpxTbWWOsmlWr5OsPw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 975ded1a-f414-4426-2a73-08ddbd5857f9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 13:15:28.9351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ll6nyxP8ZOyro2RsnGPdmzzWgYiwr+GgWG8LOaJe/jLxOkfzfRv4zWoa4fOAQA+7wjENnNszYHvd84CZUGqdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4201
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-07_03,2025-07-07_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507070077
X-Proofpoint-ORIG-GUID: b4rDLBiAcF109oUn58mc2KpTCcjiLoJt
X-Proofpoint-GUID: b4rDLBiAcF109oUn58mc2KpTCcjiLoJt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA3MDA3NyBTYWx0ZWRfXyV2nhmyErK/p 40NYgrV2SXnw7h9RNjJwPx1g9B9Rk9ipcQICm78V7K9iSjvMJRJcBee58WAYmz+nw2B9d/OKsWa v+I23YKv8trLw+39fwyZx5LQsQNL1e2Up601w4gmU93rj5iB92iwVAmlr7nnI/vMNaREWkJMAff
 kgjb1vig4cxJw3WIgoVcg+aWuAJx9kB1un92hHAwW/scckHM0J4ssYiStDIqyUsy774Kc4U8PB7 T/jZnkEUVRZRTDm/xgo2q0a1GpzCWzO+oNVU1o//RanXsuw5osxmJF9KekLXYvHFyitqvilbRjd o+5n9oxtUeApQQCzyb3a7rmJRsC+Ef8WsHLlvln7GwQ4gyMFA0OOpAOH6wLqllgXyNSv6/mag8V
 W55HMD5siPesajhKu1Bfl9s4oyylbVjT2c7L0fqgiiIkl5XoFf67WLgWX7DBFn22Y0hsJDJB
X-Authority-Analysis: v=2.4 cv=Rc+QC0tv c=1 sm=1 tr=0 ts=686bc874 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=uBPd93XGxqCW12TeSeoA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12057

On 07/07/2025 11:39, Mikulas Patocka wrote:
> There's a possible integer overflow in stripe_io_hints if we have too
> large chunk size. Test if the overflow happened, and if it did, don't set
> limits->io_min and limits->io_opt;
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
> 

Seems fine, I cc'ed Martin as I asked him about this earlier:

Reviewed-by: John Garry <john.g.garry@oracle.com>

And this will conflict with 
https://lore.kernel.org/linux-xfs/20250707131135.1572830-1-john.g.garry@oracle.com/T/#t, 
as to be expected

> ---
>   drivers/md/dm-stripe.c |   10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/drivers/md/dm-stripe.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-stripe.c	2025-07-06 15:02:23.000000000 +0200
> +++ linux-2.6/drivers/md/dm-stripe.c	2025-07-07 12:32:49.000000000 +0200
> @@ -456,10 +456,14 @@ static void stripe_io_hints(struct dm_ta
>   			    struct queue_limits *limits)
>   {
>   	struct stripe_c *sc = ti->private;
> -	unsigned int chunk_size = sc->chunk_size << SECTOR_SHIFT;
> +	unsigned int io_min = sc->chunk_size << SECTOR_SHIFT;
> +	unsigned int io_opt = io_min * sc->stripes;
>   
> -	limits->io_min = chunk_size;
> -	limits->io_opt = chunk_size * sc->stripes;
> +	if (io_min >> SECTOR_SHIFT == sc->chunk_size &&
> +	    io_opt / sc->stripes == io_min) {
> +		limits->io_min = io_min;
> +		limits->io_opt = io_opt;
> +	}
>   }
>   
>   static struct target_type stripe_target = {
> 

