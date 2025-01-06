Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C2B38F9C
	for <dm-devel@lists.linux.dev>; Mon,  6 Jan 2025 18:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736187520; cv=fail; b=sEuphW5c+zRId3xvMlIZ2iDcnRLt5NeidTgdB92f3trW0tD0AQ3VBr/H/1DYfWRahSS4HMPpC5nFpHWrpOl6Z3WMU1iBpYM5151bUADotCRiSItoWGICwGmiqeQQufag0EB3eY8C2STik0nT35py59RUPPavhvLIbeImmzquxn0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736187520; c=relaxed/simple;
	bh=RHvaJn4Si8kQ2sq4mCkW7C6pigMdepUlROoZTx4IGoY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PvNHWR3KU0emL3SGdVMOyqf2wCbhgittbJo0GigMfrNB+fRBc3tq6jZZ+31zU5oNOj15j6P7YLzpX4mOIEWdPJvnNmLhB6IAScUHB2jjctKge55xFHFNwm6tTyfa8jjkO8g6rs7PZxGBB6bMBCjUnGlcPKPW4UUKZfHML/NbfXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HcCrF244; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JH7HWQmK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HcCrF244";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JH7HWQmK"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 506Htjtq024527;
	Mon, 6 Jan 2025 18:18:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=KCdPXMgo7qylTApPxnRs85s5Py/h1foznTD0izoH904=; b=
	HcCrF244jBem0gdHbtEF5W6pxVGFzLeSUhEOrL3nqC1crwyJi2e+P8SnubiyQIwR
	WArc6IZ5avxYM7S8Nyx3Qh3VDvgM3F/lMXNBDzf69rxYRJudKC5DJL1XuAGqQ9sx
	692wv7QurVI+lYBGeYR2D2jTZ1QJNp9OFgUNk/1efwB1CMBVSvJ8ye7Xqi9dAVod
	GtJWu+MkeLaFM74E+CCcRLwKENKiFlHFROK0x03VMbcUEwZdjhuYWTVHRK7plMZt
	ujODSSekMwbPmeLwYS+NEeP8kDzyVfqk2VyHJ6/ie/L/e53Pw3i+WOLBe2QzpfUi
	DnFeb3E6gRoVNltQRruCzw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xwhsjveh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jan 2025 18:18:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 506GexIr011008;
	Mon, 6 Jan 2025 18:18:32 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xue7bpj1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jan 2025 18:18:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vjCUk6iHz1laCfeLmCgSgjlJXfnrttZqXdzWsby2YNT/gStp+gzoJWxa39wnpsfJfRYvJIDL/r4Ep5eRlXH9ssugBd9VjdK83MHAqeCMkOV/9DohqUt5/Y0nbX3t+PA1TsPDbDlng9GxMCaOT/XBvboyDqZgelT/9c1FguciuPBl77fFlhk+cg/9xn5Hv2kj3gVLx3Cg6iQZhVYwS9lCVgwDE4R/bCO0u+77g16amJY5ZkOniT18bfiJM86yBuIJfYjV7TNoyzMwiXAuk/3e6/Qbj0eAWwsz2x9UdYY6kyYJfSwdNr5uLTOuFPGd0N4PdgjzvvE+0Kbxj5ATL9f85Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KCdPXMgo7qylTApPxnRs85s5Py/h1foznTD0izoH904=;
 b=RJYs3cSrTBHYmMo7f0Prf1QX0OWc3Z98+vyyGSMH8xLlSKPxtGgVQbTHGInICWPYVluwH9JrcfCz2c1LNoSxUpyi5uhZiUX/UIUED83na+G0pSmQ/iErubAqWbWhsjj0JWCPPAykJ9SLEFcC1uc5F2lLPY2JuYBOZzzsH7C4fMftBtBvjcxW3TMbmHQ0sSSRITEHARspCuOO/a3qtp4DXANKKldhBSc1TwOaUMtyTn9UEfrqRDp6GEot0YZOkaYvvaZERIEtd8ru/Q8ickjGsBnj6R9TiYdo2F72aYPIcWJ3FPC+JXIgSU/YrOFmfYxmoB57qq4GaK/unsOsYiyy2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KCdPXMgo7qylTApPxnRs85s5Py/h1foznTD0izoH904=;
 b=JH7HWQmKwpw57DykIDrNov4sp6pENsDmo1eOUmB//Mi8kOGPHLq9uEAAVcj1RYSsWwGNBahaGQw/urTqn0Y/CLfByfnNugF3gkRnHdotGvHP8f6gjLBQOftS3v1biIie4gb8NAVxh1T4ph/SUc1WDFI+n1ff1/Cflk7iqwuKrag=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4781.namprd10.prod.outlook.com (2603:10b6:a03:2d0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 18:18:26 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8314.012; Mon, 6 Jan 2025
 18:18:26 +0000
Message-ID: <8f759a68-22fd-430d-85b9-743d4025ecbc@oracle.com>
Date: Mon, 6 Jan 2025 18:18:23 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 3/5] dm-table: Atomic writes support
To: Mike Snitzer <snitzer@hammerspace.com>
Cc: axboe@kernel.dk, agk@redhat.com, hch@lst.de, mpatocka@redhat.com,
        martin.petersen@oracle.com, linux-block@vger.kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250106124119.1318428-1-john.g.garry@oracle.com>
 <20250106124119.1318428-4-john.g.garry@oracle.com>
 <Z3wXoytvSU96ZAHj@hammerspace.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Z3wXoytvSU96ZAHj@hammerspace.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4PR10CA0019.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4781:EE_
X-MS-Office365-Filtering-Correlation-Id: 995c0b7c-ed81-44c7-b729-08dd2e7e837c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TkkzUWpET28va0NQdlRoVVVYYmJSRTVuR3k4cE5PRDJzSUVxK2g1bGtHOFYv?=
 =?utf-8?B?eUIvK2tuSGFSU1psekgrQ0NmaXBLZzd1bjUxZFVtUlBNaVhuYjhWQXVlZEtp?=
 =?utf-8?B?ekpYOUE1SEdLdUlQVytrYmxyNTdiTTRSdXoxM2xHNEJZZTJNN0ZhdTdSZEts?=
 =?utf-8?B?bFVvSXpxU2Vpc0I3cWlJeGM2ZTVaUEQ2cFNmOFUwK25ORDZncEtKcmZRRVZM?=
 =?utf-8?B?elJrb216UUNZZ0IwRkJrSC9FUTFjMk55RTB4YzNGa1J0NmxSUFFtNjNHeXZC?=
 =?utf-8?B?YVBKK2FCK0JSTDVDTzdYb3ZpOEliNGdvL09FSDZvdngzSUpUck5uTDRRVVpz?=
 =?utf-8?B?blAxbS9MNTdlak03SllTSGRSL2xaU0pxSXdTS0t2WkxzVFJXc0hicGtRU0h3?=
 =?utf-8?B?UXViQzR1RDdxQ0tjNFZUbkZVTUZ1OHRhZHRZRFE3RzE3ZmdLVEl5RzhBbUVY?=
 =?utf-8?B?blJSa0p0cGpIOGdtRG1Pd3hhOFEyQWhpMWJVWEh4WkY3UnkwdHFRQ3d2UXJ1?=
 =?utf-8?B?b3hjNXJuL0QvSEtXdHlqdzNIblV5blhYYVozTERyUEtFajNsT1pWaFUzT0dC?=
 =?utf-8?B?cm8zOFJFbTNLWVV2RnQrVFdTT3VTamUvMzBXa2xKd3JwOEpLSHdwTXVJcnlV?=
 =?utf-8?B?UDVOUDhZQW1Lb3R2MkxZOXk5eFZrSjZKSWVOVmEyMWxUUHRLNVFnN0hwYUc0?=
 =?utf-8?B?anBVamxjdm5mN3NHTFdPU1U3RXA0bEV3NU5RRDM1QjVFRWEzbXlPMWtGaEZv?=
 =?utf-8?B?SmM5RmF2ZU9RYWE2Um9sc1Z1OWhPdUpidDRRSHo1NHVLMVI3T3k3TGdEUUJI?=
 =?utf-8?B?c0Z3L0tUblhzZS9rbnFtKzBzVjRMUkJjdHhCSmNvT283WjA5NWJwT1BRLzc5?=
 =?utf-8?B?ZkUrNkJVS01wT3k1ZlNVbkxtRC9VWFB1V2k1eWVkYzlJY2d5REhhRTF3RUdq?=
 =?utf-8?B?b2FzWkNpYnZWS2YzNHlUbnp5MW1GQWN6aFMrT2lERGprdTNDRFFEd00xeFJU?=
 =?utf-8?B?U1VxMzZZUjEyVUtYa2RwMjg3clFRNTlMd1ROR3U2R2s4N3N1RDNwa1Nnd21l?=
 =?utf-8?B?bFBZcmFSRVdzZGJscUxlc01GSGRjeXloT1ZwcG5CMHB1VDQvWTVkaGF6L2Nl?=
 =?utf-8?B?MGdEdGlhODdWcnovbUhVUFB2TFF0M1U3SjdFNXM1QVVnazYxNjdLcGRrZHVt?=
 =?utf-8?B?QzFRb0ZHa0lhTVJKOHFtY3hiTTRFNTFnYUg3bVJURm41TW15SDd1TGs4Z3lI?=
 =?utf-8?B?WG8vaFdhRXA3a0RORCtOYmJqSkJNQmRoM0xTYzJJTnZWamZ5d3dQcngvK0tT?=
 =?utf-8?B?bTVsMzd0SHk4MndDVHdnTWRvRlkxbDNvM1VpUWVYc1E5bG4zOHRuWVd0aElN?=
 =?utf-8?B?U08zVmVkeVJBdWhkMEg4Qm1nMktYbE5yNndBNDlFRG9LbjdUR0NWSHBUbEVy?=
 =?utf-8?B?bkduamRNWnFQRDArSy80M0xiM3NZRWRnKzVpdVczeHlmb0dvTHJsOUxsMjVL?=
 =?utf-8?B?M2RLSGtTNXFmeVRpbHZkSWNvTnNsRUlMUmdhNWRoaFFiY2JscU9vK0RCOTRz?=
 =?utf-8?B?bDZUeFlud0hKb2lMZ1gyQjZGQkxycnozOEZBRnN3Z3RHMDIrUVZTU3o4NW5M?=
 =?utf-8?B?QmNKaU14UTNqaVlXTEFKZ1hoNHY4M2IrMXVtazJiNmd6bUtNd1dxc3QrMlk2?=
 =?utf-8?B?SnMwVlpsRit4SHI4TUNxc0ZnWFkxMi9jbmgzVi9PM3BYYloyTUswWE1IbWVI?=
 =?utf-8?B?NmpKTHFibytHMVBjRFVtL3BQYUExcEQ2UmpSSkVPVU9KVzZFWVJlZ0tnMmlI?=
 =?utf-8?B?MVJLNXRBd2h3SjZIRGRBWnlRQlR5NjVRVlNtWm03bTBsU0FOYTBGekF3dmtG?=
 =?utf-8?Q?jvWC1GOeNxQxR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cTIzSmtUT2tPYXg3R0hJRndNMmQ1SEliZ3BSd0VnVlF6Y1pVVzBEMXNSYTBV?=
 =?utf-8?B?RlNHSlRGQ3VZem5CZ1BPR2twamNROStucEQ3VCtIOUdBR0dvemwrM21uU1Ru?=
 =?utf-8?B?SjVpd0pVTitEaGFLNnNEZWt2UU5rRytxcWdCVFNBeTBXRmFnQ1JPUmhYc2Fj?=
 =?utf-8?B?TThIaGUveHc2ZXcxRXZlKzBrR1phM1V3bFNLRnVCUGhrVE1YR3UvcUFpekhC?=
 =?utf-8?B?UEZBclNyMGtNeDY3YkNxeU1laUl0WVVCWXV3QXZVRDUveU1RMnZaeW1BS0tp?=
 =?utf-8?B?TVN3eWk3L3hyTUQyclRHZWNRaGM0S0xUK0RmbVh1UzRtQTlGVmFrYUl6WmV1?=
 =?utf-8?B?WU9qVGo2YURzVjBYS0ZFM1R5UlR0S0NDb1RZbWtKS0xyZE5ta0VxKytuWWMw?=
 =?utf-8?B?QW1ydnAvUUxWbzBtZzdYMS9ZemVNNDRFS1RUMzhaa1VVTXcyTjlBUEpOTXpQ?=
 =?utf-8?B?VkpPMTNXemVzejFBMjhhMUxpUENKZDlFV0tOV2VqTVUrRURJcSs4MDdLL1lu?=
 =?utf-8?B?Qmk1L2pSWDdnNXErd2thVGZzNlJreG95d3VMdkFmUmxSZU43anROSUVBTW9W?=
 =?utf-8?B?djQvYi8vZkRVc0VkY01uOEltNVBBalZrVUFNM1I2eExwK3VvZTVadlVYMUYy?=
 =?utf-8?B?TkRDSVQzWk0ycXZFTWhhZ0pmVm5pamtXN1RRVzdHa0FsajZySllKSGNacXpz?=
 =?utf-8?B?QmZoOXYzVWRJaU92Rmd6Q3pXQ2drZDRpU3hXWS8zM2xvVW9UU1VlTmJrNFVG?=
 =?utf-8?B?cUx3WGltaHJub1hJWFhQMWRLSDVWUEJ1QkNXN1N1R3BCenVzSm1XZk9Zc3cz?=
 =?utf-8?B?WUxOOGZVSWFwRzc3RHkxK3FjT25ETkpDVHJjekgxamQ0TmFJeFFqMmxIRS9h?=
 =?utf-8?B?NWx4SUpxdUxHcnZVVUMrMTE1U2Z4VlNuelBrWWdDK1pJdWxnK0lQampPK1Ay?=
 =?utf-8?B?Vk1QTS93VTVIZ05qb0lQeEd1bi9CYi9IQVRVM0pSMExRMzdhdHJ2clJYelZO?=
 =?utf-8?B?WkJnRmg4TFhnenVMVDR2Q0d6TWhhKzlGbkNvMktUT3ptZlNNdkRVaW8zUHBX?=
 =?utf-8?B?WlllWlUvV0J2ak5vMmNIT3dNYWlIdVpGMXB4RFlTQzllelcrSFdIVGpBSzhO?=
 =?utf-8?B?SWdTbjR4NVZ1NlZtMFU1ZVlaM1lvK25OeVVOY3ZETmN2M2FKQUFFVEVCYjhO?=
 =?utf-8?B?ZVA4eFVWVUxMODBaQndMRDNtVFplcThKd1drSGxiWDIvK3hIWitud0xpMnl3?=
 =?utf-8?B?UlVvNjJ6RlAvd0dHbUFyQVdOcjFWKzJlUFo3ZXdkWlJEYXVsNFpRQ3o3NEVl?=
 =?utf-8?B?R01RSTRScnJrUWJ6djFRT2xQOFdQUlNLL2NrSk0rOTV5clFLWHVyRFRqNnE3?=
 =?utf-8?B?UWU3UDk5WW5kd2VUTGgwY25Dem1DUE51NmVGSVdSMWNmdWNOUStPZWQ5cEUr?=
 =?utf-8?B?eWFRNzBraE51K0diQ0NENkZwcUZkdFFPZENPOCtPb2hXQVgzMmpkcEN2WHhF?=
 =?utf-8?B?ZVBxUnhFSGtaTGRoWERBQzhIV1NwN2h5Tm1XZG5pVjlqNXVaaUZpOXh5aExa?=
 =?utf-8?B?WHd3NnJxM242Y1p3MWZTbTFxakN6bDRpa0NtcFZCR3JzTVMyR1RmUFFCVXpI?=
 =?utf-8?B?dFRxM1pDTkFJdE12bTJ1RGNjYlZCTzMzd3hWUCtUVWlSZnk3czVYbkx0ajNo?=
 =?utf-8?B?WXZ2WXhGQk9leThzQUw0TS95VWM0eUFNNjBXdG96NDlCZVl0SjZnL2FES2tr?=
 =?utf-8?B?TTFTVW9sWlRNQ044RmN4VVFZdTBHWldqdUM1eVNSQnNhTjNMRHE2ZEdmd1hx?=
 =?utf-8?B?V3ZJVHNjQ1crNkp6RXlxMHg1cXNJTXY5dzV6RUVZSGhtbFdNMXk0bURURzRz?=
 =?utf-8?B?RXZ5dXIrVVRGYzBCZ3lRVHl3K3FmNmwxT0w1RE8yMHJRVnpXbDJxYW9UN3lU?=
 =?utf-8?B?NjRKZDIySlZXbDRFUzY4V2d4dGdFRElJN1FxRWN4WVVvSnFVcDVIUGYrcDg3?=
 =?utf-8?B?TWd3bkdpTlM0SjR5YjFwVlZsZGVBVXMzZmV5YlJ3MDl0b0ErNTQxcHAxNjI0?=
 =?utf-8?B?TDBZQVlpZGxJZko4ZE55bE03UVlzT2NZMERHMytwY013dFNWdnpCNWNZVmN5?=
 =?utf-8?B?ZjNMVkJHcGIvTDJ4cjhDMjZ3QjQ5c0lvQmc2dDdPc2R3VHhrZStOOXp1dzlT?=
 =?utf-8?B?T3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Y+q1t0gvU7pj3v8zIH32gWrKkAILy9Y+wyvqMkYm1ZKUpxGpcnv3zDyAaDa/PCiVU8+UQ7fhAYrTbb/HSg3XcExR849+1D4TL9SiJe3StkCRLqVIFMT78RO9mJuyhbQstY8aDiCjJA+Cvhwq4BKktJs9TFJzxVg+XAV1Tyv8mqklNWn5uP+vouKwjwMiFJGg8kDLlVwYHvW3AtHXKalV3lYjwZ0GDa7odOuIIjUqasyxUeaAGacRcyxec/Ei7iJwXrUD/d3BCmhbTMsnkc66VZvWS2ZQZqd7UYvqMhUlnHZhqNpv7rOq3364ovTw1G9te6a9qv0ecFF0T/tYc8y47gqQtt/OcD/jYa9qtwXOy1OOfCQJlq15xi+/bvunfSiYnej2lRd27KLLHpfCyZBzKJ5KrN9EuLUmS4kxyFKK5Pm7yuCSv333fFBUqzvzTU8sMTgK5DQt4XFBADyLUQUCKBCcdivqklp9usRFAKrztuzJcduWy8EKtfQnUDSBapL8A+/bQ4BL17L4UTGftj4peFi77TZHus082Zs+kEfY0yee1jDVGlWvOpxYfJNBHYY1VsPAoA0YlQErEbPVY3y3dNGsDjG3Th5iiUymYmHhqc4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 995c0b7c-ed81-44c7-b729-08dd2e7e837c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 18:18:26.5453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2t8vhZgUo/FdnAqaEmxKRAeeAE5kR9XH1qJPAoJVNKOMW5ZK88HvbTMY52JmC3o0aZJdCR1roMd/ytnCUE+QmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4781
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-06_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501060161
X-Proofpoint-GUID: hawy0mHC_n8vZLFvKsZzF0MUXBRj_gaR
X-Proofpoint-ORIG-GUID: hawy0mHC_n8vZLFvKsZzF0MUXBRj_gaR

On 06/01/2025 17:49, Mike Snitzer wrote:
>> +++ b/drivers/md/dm-table.c
>> @@ -1593,6 +1593,7 @@ int dm_calculate_queue_limits(struct dm_table *t,
>>   	struct queue_limits ti_limits;
>>   	unsigned int zone_sectors = 0;
>>   	bool zoned = false;
>> +	bool atomic_writes = true;
>>   
>>   	dm_set_stacking_limits(limits);
>>   
>> @@ -1602,8 +1603,12 @@ int dm_calculate_queue_limits(struct dm_table *t,
>>   
>>   		if (!dm_target_passes_integrity(ti->type))
>>   			t->integrity_supported = false;
>> +		if (!dm_target_supports_atomic_writes(ti->type))
>> +			atomic_writes = false;
>>   	}
>>   
>> +	if (atomic_writes)
>> +		limits->features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
>>   	for (unsigned int i = 0; i < t->num_targets; i++) {
>>   		struct dm_target *ti = dm_table_get_target(t, i);
>>   
>> @@ -1616,6 +1621,13 @@ int dm_calculate_queue_limits(struct dm_table *t,
>>   			goto combine_limits;
>>   		}
>>   
>> +		/*
>> +		 * dm_set_device_limits() -> blk_stack_limits() considers
>> +		 * ti_limits as 'top', so set BLK_FEAT_ATOMIC_WRITES_STACKED
>> +		 * here also.
>> +		 */
>> +		if (atomic_writes)
>> +			ti_limits.features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
>>   		/*
>>   		 * Combine queue limits of all the devices this target uses.
>>   		 */
> You're referring to this code that immediately follows this ^ comment
> which stacks up the limits of a target's potential to have N component
> data devices:
> 
>                  ti->type->iterate_devices(ti, dm_set_device_limits,
>                                            &ti_limits);
> 
> Your comment and redundant feature flag setting is feels wrong.  I'd
> expect code comparable to what is done for zoned, e.g.:
> 
>                  if (!zoned && (ti_limits.features & BLK_FEAT_ZONED)) {
>                          /*
>                           * After stacking all limits, validate all devices
>                           * in table support this zoned model and zone sectors.
>                           */
>                          zoned = (ti_limits.features & BLK_FEAT_ZONED);
>                          zone_sectors = ti_limits.chunk_sectors;
>                  }
> 
> Meaning, for zoned devices, a side-effect of the
> ti->type->iterate_devices() call (and N blk_stack_limits calls) is
> ti_limits.features having BLK_FEAT_ZONED enabled.  Why wouldn't the same
> side-effect happen for BLK_FEAT_ATOMIC_WRITES_STACKED (speaks to
> blk_stack_limits being different/wrong for atomic writes support)?

ok, do I admit that my code did not feel quite right, so I will check 
the zoned code as a reference.

> 
> Just feels not quite right... but I could be wrong, please see if
> there is any "there" there

Will do.

Cheers,
John

