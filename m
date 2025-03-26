Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sg2apc01on2065.outbound.protection.outlook.com [40.107.215.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3B0199BC
	for <dm-devel@lists.linux.dev>; Wed, 26 Mar 2025 02:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742954972; cv=fail; b=Z8ExfR8hcrisAtyaib1fu9rZBuBXCJPXDqd2VBMuZlykaDKkoFJwXwnY+paO9TC5p8yAchZWV5TtSAgVVucy1g/r0mTRepy4kTrAmXk50djZ0xKxGkA+ISY3nEeIb7eX1dhvkhoiydSgimZieMpoah32d9mhJ4DFw0VNGZPigpE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742954972; c=relaxed/simple;
	bh=8jnGTMMHV5nm7PjWlYEW03VMs9XWVlGOlVYqhQDV930=;
	h=Message-ID:Date:To:Cc:References:Subject:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AeSMpwsXwMXLWjY9uMtj/cEJeCIMIfAOEsIjcdZszxTJ2SrNkxxtlCrvOWYacqXM3g5wVu10ke1QsdgdukGkZnv8cMn/fdyxGH4Zam/0z8IZ9eMoWQ8Eq6OZ4rwilWQe90S07qUnC98d4tNu1K0NYHI/zuJ6PstOGbInncxQpq0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=ROfrt5Bc; arc=fail smtp.client-ip=40.107.215.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="ROfrt5Bc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j5oos9awSvNaAuJ+y1MkrFQhWYhtdu5jpk2yQLx+BU61lldfUzy1oZqtPI1fqz2P4j3p1CczIfDrQDaS2IdVM95INOXgKHvtcbMBDctIDT2mrXGYc+QJYb0k8A6FZ3x/ImgzJObSNujhhBDgEki5bDU0EfA0QcAanbE76uhLR3HQj6s4GumX+tQeifvDglsPTCch0GakoaZ2FSAfvHw2E2ZkQdOiURSgFsV2V6TrNCTUSllA+QQJk9ngxV3wDykjutCTtgIo/FBrruEXeamovMNTQ4E6ZTIDyx0UyJ7UZMfXOCNI1iyXdjR8Xei2fcP8v9TQozYiG7AZQ4AXuKj58A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ycSZcO10/2CInMBXLpBtQxVkf40DnhOEsD2ExnYlNEk=;
 b=Dyx9ZY8u/dg4QNAY2fNgFLuksNxgUO4miNKnY06Y+IEi5t2CtQDw/6vRYmqg4CCq44IPpavMcJE7L8DrQbxgzsNY06xkXyN5SDkCe4oMql8a5Mu1P22XIjo2rpyq4IjW7jqes8YJTBA9Nq6H2FU0NG20Q5adAEfZbCoEvX3IsKQ0GNS4k69DYYkFxgcTQfMBU3SfBH2lSeSHYXwXwaQSUuimXviPAaDJuDuhrVtXT7FncJZQOxx5nrZ0lSYbfq6NsEmugdYdzvv8Zaq1YF8oQw+uXyxINMrT3sqcQaJeBVQxsHYN6k6GeHVGrX8ovwpY1QnEkv7Y5wYXLjzwotulDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ycSZcO10/2CInMBXLpBtQxVkf40DnhOEsD2ExnYlNEk=;
 b=ROfrt5BcqE94GE+k7kfgAQiUHFLL3Y6nEScTPRm4vrlyUsLBZXWBAF09sBsQQHg+LXXFx/HvLe6qx6IRlDMOpgvEAIdoXphqptiKt6hVYdfjxyyOrhP4FC1ipGKlU8AdZMCU1B5/3jwqlDAr6kHlkVdB7NX9qLA3aIm9y0ggoDE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by TYZPR02MB7987.apcprd02.prod.outlook.com (2603:1096:405:a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.23; Wed, 26 Mar
 2025 02:09:27 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8583.023; Wed, 26 Mar 2025
 02:09:26 +0000
Message-ID: <6c4f18d8-39f9-4eac-9bb2-d6f0d9c3b376@oppo.com>
Date: Wed, 26 Mar 2025 10:09:22 +0800
User-Agent: Mozilla Thunderbird
To: ebiggers@kernel.org
Cc: dm-devel@lists.linux.dev, eranm@google.com, guoweichao@oppo.com,
 mpatocka@redhat.com, snitzer@kernel.org, weilongping@oppo.com
References: <20250325174318.GA559858@google.com>
Subject: Re: [PATCH] dm-verity: support block number limits for different
 ioprio classes
From: LongPing Wei <weilongping@oppo.com>
In-Reply-To: <20250325174318.GA559858@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0002.apcprd02.prod.outlook.com
 (2603:1096:4:194::22) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|TYZPR02MB7987:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ffb17c7-e6e9-4885-9d92-08dd6c0b3c0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZE51K1BndnJrQmh0MFZLdTAxcXRtOTVvV3FsbzJhRndadkV2RzRVb3I5MkdE?=
 =?utf-8?B?MGhSRXdNeHByTS9UYXdSeXhxVWtRc1ZhUWJmM0hEdE13WlhuRnROMW1aSDV5?=
 =?utf-8?B?MlFadG9YTDQrWC90RDFEdU9lS1duNi9DYWJXSHFxSmo2bWwwZTJFcFZXNlJ6?=
 =?utf-8?B?WXFYUm5MbU01ckk4eFV5MnBsV3RzelhKRTdEaWp2SHFYY2NvZ2kxd1NIejVv?=
 =?utf-8?B?SEIxL3Qza0FNN2hUR0hhV1h1M01RRWY1S0F1TFovblcvaDZHS1FKVUk0dDZI?=
 =?utf-8?B?NDFFR2lTVEo3MjdFd2VxcEI0TFdpRkdDSWJialc1ZkZuMzRuWko5dkRnRTQx?=
 =?utf-8?B?WW94OEJlbGtmTjliK1R0ZVUybTFSYm5CRk1oVzBMMHZEcEE0MXEvN0dKK3lP?=
 =?utf-8?B?dldMeUdFTWdUWHcwVnNTaTZDTEd5eU9mazNDOHJwWnVyMmVmL2ROTzVOdzRX?=
 =?utf-8?B?VC9Xd3h2cXl4eGtPb2oxMjlxZ2hSNlg3MlIwUy9mVXZ4aGNBdjhPaGJkM0V2?=
 =?utf-8?B?dTFYcnBucFpaRGxRS2FnSDl3d0VFQkE3dEg4V3kyclVzeEdBQlM4amxtSjdj?=
 =?utf-8?B?bis0UXgxRzdsSHpDcGtBZFQyTS9GN3ZoRXo4MDZielBuUGpQMW1BVkgwa2JG?=
 =?utf-8?B?SnlmWmIva09tRHZuZ2w3U2s0VzNMK1pEWnZWOVZEcHdLRjZkWHVKeVl6Yjc1?=
 =?utf-8?B?dnJmeWFNZHViQW5ianpUOEExTnFTSmxJelozZjI3WlRxYWkxcjFObkRCRHI3?=
 =?utf-8?B?UkRhbzY5WEorUytPUW9xYUFNR2VlREhaU3ZyOWpZbmFVelB2ZWl0TDZZWXIw?=
 =?utf-8?B?c3BhQkVJZzF3WXYrOFd3N0I0NEg4ZUlkUWltRE5DQzJTck5KUDEva3Aza2hD?=
 =?utf-8?B?MElhbCtkUDlYL1A1Yi9PRW1XMVdkNFRUUEs1RHlHSnJlWExyVC91RTZKemNI?=
 =?utf-8?B?R3ZBUmRwTDFXeXFKVmJZNGNOck9mbXBqYjBTMHczZml6KzU1TXRJVGl0SEdm?=
 =?utf-8?B?SVZFZFVXY3QrdENTYndpNXhXRytNK0oxTWhLbldjTTJ0ODdWWEFZM2FkZ1k1?=
 =?utf-8?B?T29LYnNpSW41WFcraFJSdTB2THhQWkk3OTg5UUJlZ1J1a1kyZnJhR29wN0s2?=
 =?utf-8?B?ZHVhcWh3a2RRTmMrcTRNWEtkWE8yMWFqMVRTMWx0elkyMDhqSGllY0YxWXd1?=
 =?utf-8?B?NFV1eDdPK0VoY3RxSU0va0I1aHpWblkzaDN2ck1jODBPV3RaMVBZNkw0MjEx?=
 =?utf-8?B?RXA5T3hILzJkWXl6dlM2RFlHZ2F3MjAvcDcrZnZYeUNHODVwZUpicWFJT1hn?=
 =?utf-8?B?MjVmWWJ0QlBNUnNNK0VzdFh3NXorUk1uenVWMjlpd3hUdXJqSHNPblVTUGlK?=
 =?utf-8?B?YW0yamNxM3B6SjZWNlVWWEMxK29INWd2b28zVUd6RzI3dTZJbEo0YTRkSjRT?=
 =?utf-8?B?b0lMM1MwMXpqcW1jdG1zYk1FZ2FlOC9iaFBDNU9WSG0xWVVOMUo2UnVIbUUy?=
 =?utf-8?B?WFM4WE5ROU5aZXZSWWthTkhNRzdxKy9DOW92TWRhd0lVSm5scGpVZEIyZ0VE?=
 =?utf-8?B?cDlvNzV2TzhYQWJ1QXB5cFpSZWNzZnVBZmZtYXJ4b2w0cmNMUEY3b0ZjSVJE?=
 =?utf-8?B?bmNubFBuVnhSZ3lzUlA2NHlZalh0SENJaWdZQlpqd0w5ZFJYd2xQQ2piQTBR?=
 =?utf-8?B?c0JMNTBNN2FiSGlBU2h6MFE4L20xbTBtUVpCempHZ1BvVjU2VE5rWHN4QTNY?=
 =?utf-8?B?alcvVmZaZk8rczcvbGd2K21vNWFtL2N3Q2dtam10VVJ1OWZyNTdaMmZnVmVB?=
 =?utf-8?B?WU8xOUJwMDljM0g5OS90aHNKV1ZDbU1TcEh5MzJuVUZzUmZ0OTRYbThXUlNH?=
 =?utf-8?Q?SBDugLufLn32M?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZFBxS0FVYkpmUkh3OHpxSUhQSjdIOXdib2Fyck5kYjN0LzR1blBlVTdsMk5i?=
 =?utf-8?B?TU1ubnI4ZTZTM2IwQzRzUklmb3IvUWdheW4renVPRmtsVEttSDZlWTUzaVRX?=
 =?utf-8?B?dzNJMGowV2VZUityVGw3TDRzZ0g3U2IxS1lpQ0RrYXlxY2g1MlBnblRSakps?=
 =?utf-8?B?SHpUWkFLQnJnckFsQmNyaEpJYzhSek8rNVREUnpKU0l1TVhIVWNESFpOYjRJ?=
 =?utf-8?B?SHBQcmFtVGg3NFpzeCswUTI3QWg4bFUzL2VpZHZ4QStXU09UL3RReVg2QXdK?=
 =?utf-8?B?K3RGQ04rcVdjK01JT2RvM1RTaW5QWDJNQTF4Q0MrR1dlMVhpZDZucU5Dcm02?=
 =?utf-8?B?WFI3emF1NmR2N1FsUHhMVXVBZENUbjByZmpCS3BSeFJHeXE3NVhrRWtzWS80?=
 =?utf-8?B?WDhhUG5BVkY4ZGN4S3RuS0EvR2tpaHRlUjkxc09NenZkY24xVW1FaU5HZkRG?=
 =?utf-8?B?MUplMXR5ZUY4T3lTeVl6Y1ZFcUFrMUpWYXhMSFplMmpZR3kwL0lBQmZVYUQx?=
 =?utf-8?B?bUdqRGJuQmc4WW0zKzRLVUJYNFV1a213N1VZUnkxLzhlUFB1dEtXVzRqRWVU?=
 =?utf-8?B?aFBBeG0wRFFtYUJvc01Wcno0NEk2RmFUeDFHT0thM2NLMGI0dGFSbmZZb1Nl?=
 =?utf-8?B?Mm9TeWNqWTRKU1JpTWV2cjlOV0o3alF2MWtiV044bTI4SjN1T1RNK1NldUFW?=
 =?utf-8?B?bENPTkpIM29aNXBlU0xCTVBoQzJZTEp0bTRZUDN6ajIzUStMRnpoOXFvU2xv?=
 =?utf-8?B?Z0dGS3BicEdiZlQ2OFdPRDJnM3EwWExWSlJqdkNGNWVMd0o0YjJNT1dzTXQ0?=
 =?utf-8?B?MEJ0bGpIdUJDcXlDZDlaYTlOR1pBTzd3S29zeFR4Z1J4aWJjYXY2RE40czk5?=
 =?utf-8?B?ckcvbndLcDNwWjNqZjlUdlVrL2ZMSkVTVU1SdHJvN1BLcmdYWlQ1cURhaUdS?=
 =?utf-8?B?bldCTU5WTlE4Q3pndkZRK0RieWErMlFMWkF2Q0ZXUEhwMk9IYzFTQzk0SU5P?=
 =?utf-8?B?ZDR5NmJEZVdYbm5WQ09sbm9ibXFyZWZUNnRpNUw3bHBWd29EczN6Nk41em5K?=
 =?utf-8?B?Y2ZQWnZsanBpQ2cxcExENThoWEEwRFNKSjR4ZGZPZlcweFoyc2xBZDVkcmNk?=
 =?utf-8?B?YWFzM1ZsSkhqYXprT3BrSEp4TkZENjJoY080THE2b3k5Wmxnd0NReTBMM2JL?=
 =?utf-8?B?YlAwUkVUaTdzdjZBS0Z3dzUvVGtjNzZuZHkrSk5NZEpoVUFXWEZUZ0V3NDZx?=
 =?utf-8?B?K1l6b1VzTXZWOEhjbXVmWjdHbm9WZmVoaXQzU0dQeDV2OWxHUE5EWnFXOXdu?=
 =?utf-8?B?OXhsMy8zdzhHbEtwamJuV3diZUtpeUVITi9ZU2ZDVUFHelB3VUN3OUxJRk1D?=
 =?utf-8?B?YUlCK245di92QzNqMXIxWVd2ZFYxVW4zWWRDanhvdGZlZGR0NzNrelVWMEhw?=
 =?utf-8?B?OUVuYVV6dlpxSy82R09UMkV0NFBUT3JCaHlCTkxUQXhtbWJBdkxNRkNWMnNo?=
 =?utf-8?B?WnhuTk81TUhaNDJ5QzdIVDlLalhoVW1ZMmJ1L1k1T1V2N1g3Vm5ySlpLSjJY?=
 =?utf-8?B?WDdoV0NmcVRvWEhoUkdEa3JXNXZpMGtJanc2Rk15THpHaWVkYWlzSlMxSlk0?=
 =?utf-8?B?TUlROC9udVQ0VHlBaGNDRS9ldkVsQmEyaC9memU4dkQyV3hDV3F2TW93SkFv?=
 =?utf-8?B?VysyblJ0aU05SHRtVFdmbDlVM0F6NE9maVpreHhjTzIzV1FhQktYWWhzcmtW?=
 =?utf-8?B?N3g3T3FxSWd4eGhOcDgrbndvYlZUZHdPL05KUVFZdEk3U1I0b01xSktWSFlk?=
 =?utf-8?B?bFhzOHBZQVJOQWl1L1lBaGt6eDlJbENtdWFURTVrYkp3U2t6THpWdzVqUWFM?=
 =?utf-8?B?OE1pWTV5K2w2TDVaT2w4RU13WGxDc2RFb2g1emM0SExCTGU0MEpkMVBpazBz?=
 =?utf-8?B?Z0l2eG1mZWdBVllkSm1GYTJGOHpmQ3E2ZjBwNEJBTXdaeDJvZ3RDWWJSOWRS?=
 =?utf-8?B?NEpwVkszVTF4UGV5WmpWUS9LOUdwK1d6bER5N1AyZ2ZyOFVrYks3bUF1TEFF?=
 =?utf-8?B?N0ZsKzlpYWkyY1RwSXQ0TFdoKzV3aEVGd1ZoQWRBSUk4dlhMRk01VFNIeGxQ?=
 =?utf-8?Q?yEWJ0f/jBd3wwJJLnLitq05GE?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ffb17c7-e6e9-4885-9d92-08dd6c0b3c0e
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2025 02:09:26.6970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mae6ISnd5DosyURSEMXWmbD4lQkyG+t5YHJ/NtESMaiyvTVw1xbm05Xeic0/q8HIjKkFFcfstTtgw71Hl4KpJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR02MB7987

Hi, Eric

 > If the CPU has been in softirq context for too long, then stop
 > choosing softirq context and instead fall back to the traditional
 > workqueue.  This could help address objections about increased use of 
 > softirq context.

Could you share me some example about this?

 > When possible, make dm-verity do the work inline in the existing block
 > softirq, instead of using the BH workqueue.  This would reduce the
 > amount of overhead.  Note that dm-crypt does it this way.

 > Let's just set good parameters by default instead.
 > "try_verify_in_tasklet" is kind of useless as-is, and we should just
 > fix it.  Especially since it only affects performance and not other
 > behavior, I don't think there are any compatibility concerns with
 > changing what it does exactly.

These ideas have been implemented in patch v2. Thanks for your suggestions.

- LongPing
