Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sg2apc01on2074.outbound.protection.outlook.com [40.107.215.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726781E1DFE
	for <dm-devel@lists.linux.dev>; Wed, 26 Mar 2025 13:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742995958; cv=fail; b=XTHWQ1VZkDcuFwBruyeUI6dEAYEzVFOcrtZNIrIhi2BPYa8/5XuIesyK6Eu3DGeVXFRCEsFUZrYAc+xWMf7ERuAu1vZ7uqZb+ZAN5Ds34+hB3f5MTS1BTnCDLM3fNlZ7le0SjpKD67FDNE9bmgg9Hw32HXqlsTuxMwx1XgKLcRA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742995958; c=relaxed/simple;
	bh=pzICWxnLub0IYJpZBHll+JPpSOxTqK5yG/N/1YlfqiI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cZTS9tX1mo7kn3WXRHT2t3AO6Ssg4hpRQvMstbGw/WBP/lSGuYhV/qYmrVwPV4BCxzEuQBf0xg2mUP2V7ps/9RmAKZuqOCtraUmXVGWjQQmEPTHCeK1wunInNtEfIB0v5lVOWEXKNgouksk8I33qy8UHodKf0EzhtUOix3sdxho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=c3wPjm2H; arc=fail smtp.client-ip=40.107.215.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="c3wPjm2H"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c5KazGSEdORMbCCk0UU2rxHV7oUNZF4hwl854ifvEPtGZlypo47iZaOJUdpClwIJLScizKR9zPSB0NDw/sfxRQWTKcsX+LYpWUDs6kvwqzUqinYIN+XJ2kgLZ5XXVRAXJVj6+uDxw3F9qovcsWbInD+sHfNqYC3q+8EUpPFgqPKrOuv8wYxco8qATqkySNTZQnODu5AsjXxAgDmSxJuDVtDvIpKACT0k0boejuUoiM+8WVgzLqiaE4+ujwEiyVhuS2fFsatCPW4GLIoKzr9+R48vF4UY36x+Rue8UAOOYgXEg5VOoWVFqv3bt1HqYbQ2nfMJG6R1OndrSZeCKbMXJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v7wjBN89p+HBZDr3yA2h0rBjYIXJQY2vCa7WJ5w5YMs=;
 b=zRrCUytNdWG65wIaRrQ6mKugpnFa9/LR/fjKycW8d+zWqQOk8shfdnGVN93XRJ9WbOql2EBlIbKuL/imzpB849917QvbvWVSaw6uCXTdMrKFqEP6cCHhHZjNo7G/JcdtSttH3pdM+zch5cht/AeQKKGK75iJLptH7kN6yWW4h5cQMKdVhoOgKCMbFKcEj+JFXDyavTsoyw1N7LuX7vG2ww9rs8TQvLQPGCelDwGcTiMCGyzv7f+LsdWwvmp/VBuuRtAYaERQ4zRvQDDCaJcjO4UqMy1xsi4dayMJAJduXkurKVau42HOuqQ0fq8BccT0Raa/69xsYyrK0umXc8XogQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v7wjBN89p+HBZDr3yA2h0rBjYIXJQY2vCa7WJ5w5YMs=;
 b=c3wPjm2H0rOHRhU1Lf+Z3D3Vl40Wg50vhBqzYFheQbrTLwUKvfv4GBGzI8kp2Uievj9o3PsTU995AzWvI7naVkuh0sd0rVIiUO4jQNPJjF0EhkPVR1FLiC9V7U2GTCFikFcct5FvvIjPANEQSvKn8ke5slmFo9zLNawb7+uipL0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by KL1PR02MB7429.apcprd02.prod.outlook.com (2603:1096:820:123::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.24; Wed, 26 Mar
 2025 13:32:32 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8583.023; Wed, 26 Mar 2025
 13:32:31 +0000
Message-ID: <431f8798-e0e5-362c-bf6b-fb6cddadd4b2@oppo.com>
Date: Wed, 26 Mar 2025 21:32:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2] dm-verity: support block number limits for different
 ioprio classes
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: agk@redhat.com, dm-devel@lists.linux.dev, guoweichao@oppo.com,
 snitzer@kernel.org, ebiggers@kernel.org
References: <50200020-3c4f-0667-1697-7c2ff62133b2@redhat.com>
 <20250326013049.1292617-1-weilongping@oppo.com>
 <93b863a6-24f3-2281-c9a7-c3e59b2a6ec2@redhat.com>
From: LongPing Wei <weilongping@oppo.com>
In-Reply-To: <93b863a6-24f3-2281-c9a7-c3e59b2a6ec2@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0101.apcprd02.prod.outlook.com
 (2603:1096:4:92::17) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|KL1PR02MB7429:EE_
X-MS-Office365-Filtering-Correlation-Id: 38deb937-1a75-40d0-d2fa-08dd6c6aa903
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ODFDbS9sMGs4QnhQc0dEQ3YrbFhYcjc2clpTSGtGYVExRnlIdXFiT2ZhYjI0?=
 =?utf-8?B?emFKbmlLM0sxd0JuTkNQTk1IWW5xYldZUm1KQkFIV3pwWk96eUh5eGg2Z0RU?=
 =?utf-8?B?dTE4WDlSQzE2VnRrVTNKaDFKZDEvWXRFN3ZuZk5VVmMxTDQzRm9Takp3QUls?=
 =?utf-8?B?MFF2OCttdTBJcmhFd2pWbi94eVFOUisva1EwMjdwSVc4MEFqR3krSmZaL1ZL?=
 =?utf-8?B?RThtOTRCTnNNLzFCV3V3d2FLRnk3NGpqbHFqQkpZNDlyUWk4Uk0wanVCMk5r?=
 =?utf-8?B?R0xaZXMyOHhnTUZ3RXZlMTgzTVozalJ1L0dLR2RDT1I3QnRqQVlnK2xWVFpC?=
 =?utf-8?B?d2ZjeXFuOW9zU0IzZURYYzd3NysrSUlINW1RVGtEN3dVQyttV1Vza1N2amlI?=
 =?utf-8?B?bjc4Q3ZqSWc0MmlCQThGdzVweWhtZ1cvZXg3V0lEKzczZVJJemNXVUdiRTdm?=
 =?utf-8?B?elJTZ1JQR2dWTWFhRFptMVRnSmdVR1hjd2ttYURsNk5YRDJXRkFYbWdhSlA2?=
 =?utf-8?B?R1VEK1R2TzlVNlp4RGN1QnE2dW1XanVxS2xNaUdVc2NySXhsNC9FUEdTNEtW?=
 =?utf-8?B?dVZ4VktTdzUyR0RsbndwdlMwV3k0ZzJ3ZDFsdXc2bXVUWElQaEJXYzBTL0xW?=
 =?utf-8?B?cE5JNUNoNVhBNXBzWHlOT2hJdHJ2KzFPWHBhNUVOeFRHUkpTL1lQb2RVeW5J?=
 =?utf-8?B?UURyTUd1MzhHVEpiMkY4NFZjcXFyRzhUUTVvSmsvVi9Ib04rZ0duQUhCc1Vq?=
 =?utf-8?B?SkJXUVpMNUxzc2xsWjJqZktnY2tSTDRRYmhPVFUySkF2dS9WUmJ2S2s2NVl2?=
 =?utf-8?B?eCs5bmtvWW1VbVZQc3dDQnlhUUxYanZiRHpwSElNQjVGUmFBMDBBN0lzWWlT?=
 =?utf-8?B?NjhjV1lSUkFGQmJQWCtHZEp1dzJMOC84eWJKNWJVZWxXZk5ma2FndFdxTHVI?=
 =?utf-8?B?SkorYVVYSFBDcUtBVTdvM2w1MjdNanFSLytwck5DS1UvNzZWbjVteDNFV1V1?=
 =?utf-8?B?OGs4UjlISGJOa2FHVUY0OEo5RzZCSFRsNUNQUkJzdWF1ZHIwN0FUdFo2U3kr?=
 =?utf-8?B?cCtnMEROT2IwWXU3ODFnQ1lLenJlYjJJeUNEU1F5akVlRTFYWTZUT1JUL0lr?=
 =?utf-8?B?bDBOUmR6VE1ReWExQmQ5UCswc0xVb2FJdTlaMktiaTRzcUVheSt5WEpaTisw?=
 =?utf-8?B?eEZBNDF1QU9MMFo2dGJ0SDlKRk0vNTR0UkR4c0RMbHBRcks1dS85cVJ5TEs3?=
 =?utf-8?B?ZU9VempxdTdRK2pYRFpIRG1hUnRwS2dHUXpXNHVFK3lVTmNibDd0aFplUjcr?=
 =?utf-8?B?a0d3ZVFuNWVHUHY0UFIxUjFEckF4Uy9HanVVREI5aVNqK2taem1aWXJaUXBR?=
 =?utf-8?B?Q0IrL3c0ZHZWUFlhM0tFSEdtWnV0b0xoTTdJSEdyRWhtMTQ0SnRPdjV6SlQ0?=
 =?utf-8?B?aWMvSjk3REJMNitsRG5JOGZYYndrWGVTVFRYQ3oycGZBWWtMV1pnY3FFUEdI?=
 =?utf-8?B?R0wydjhkZjlCUytTWEM4V3RONzVPZHNoTDMxV1dITDZWdmk4UjU5VXY3STZ3?=
 =?utf-8?B?cDhoYXFVYnppYUh0bVJrbHY2RG1TMnVNZDdHd0N0cGZNckEzQkhZcEFvbVRo?=
 =?utf-8?B?NTZtS1Izem1hOHFGcU9FWU0wNCtvQzNuWFRJL3hZb1hHYnRNOEc2OVZjOEVs?=
 =?utf-8?B?R2VqaElmbW5ZWXNtQXhydlFlNUYraGVrMEo5L25yY1lueXR0Z2w5djhjQldS?=
 =?utf-8?B?bGtwaTRMbWM2cG43Y0d3U2s3RkNGeHFzaVg5YVkxNEhCZ1U5azkwd3FGZUlC?=
 =?utf-8?B?Um1NYzZFd0JnOUdoT1I0WmtQT0lLanRXT0NYOW1DcGtqVU1jbWViVmwvcWEw?=
 =?utf-8?B?ai9DSVEyY3dkRzRReFNyUHNPV25YVFJRbE4vZE5IUzNkR3lTSHNJeEF4K2NO?=
 =?utf-8?Q?aj3Ck5QZWO0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SnhYV0QyYXcwM0NPaWtsdkpiUzU4dEdqQ0hxN1RQTklOaTlCNHM0TDN4bjhQ?=
 =?utf-8?B?N25KMnl6VE1kSkNFSGhDS0FNMlNFZXdzWkhBTDBVRW9Edkl3ZzBEMFByV014?=
 =?utf-8?B?US9iU21KcVI0VTkxejFsaHpsM2hzcUovZUlEK2Z2VjJVZ011ZHRMelorb0I2?=
 =?utf-8?B?T1c3WkEwMXlFOVAzWVI4VHFiQXoxRzRXeGhtM1RqcTM0YVVGTmJmd09tUUJC?=
 =?utf-8?B?UFZXVysveFF3Z0ppVXd6alA3U0RSWUswM1MxM0NyUWtST0xwY3VSc21DSGhN?=
 =?utf-8?B?MHhYazlPWGcvY3MrSTZqR3duZWRjWGZTVkxVbS9QbWhQMGFrMG95QVA5VmtO?=
 =?utf-8?B?RmRIUzJZdE9MaVRZTVAzYmpCVmJWQ1NaMXIyb2M0RTdRMG9TVzR2L2hyNnh0?=
 =?utf-8?B?cnRRMHZLRWJpVzROakRtMWM4V1FadFFCUUJMaVNqTHhrRU5YN1o5clN3Sk9Q?=
 =?utf-8?B?Q0gwZ1VTQ0dacHhjb2hmaFhpdVd6QXI5YlFIZEZFYnZOK0FCeGxlaW94OTQ0?=
 =?utf-8?B?UDZwb3ZlQm00WCtVV3ZDSGZRNjQxeWNZbVhhcFJ1RnQ0SGJqWk5rQVkrdzdS?=
 =?utf-8?B?MG1CRCt2ZXNwN1FxYUxIM0M1LzRNb1ZzUW1Qck5oZGM3T2t6NWwrck9DSmR3?=
 =?utf-8?B?ZGhQdExEUFYya1JjRVdEcmlVRmY2YWs2UUxDbFB4LytFR2xWME1QR1lES3pZ?=
 =?utf-8?B?a0xQY3Z2cHgwSksvRk44S0REQmFxcWhPdytwaVVTR2V6aVhzOGpXVnRNdkJX?=
 =?utf-8?B?VHM0eGUxNGVOUjdpeGh4VHMxWWUwOWhvUUU5cjF5eGV4N1R4M0NEVjZ5T1FX?=
 =?utf-8?B?YVNTUGhETUk3WkM2OTNrTWhBanlMejJhWktESnpSak9mUHVTcWY0TzNBSnhJ?=
 =?utf-8?B?eXZOWlJBVmJiV29kb2xiZ1dBVGtoMEJCUzlodUx6UWdvVnlseUR0aUVWUCtD?=
 =?utf-8?B?bHdVS0pLdjhUTnZHVmpFVVc2Y2Y2SVBMREhSZ2JhdGRKa2g4ZWt1YkcvdnRB?=
 =?utf-8?B?eDR0T3dRQmdEdm04bDU0R1FvWmpsdlI4NzJiNjdUeVp1TXdBVERvODNHbDVD?=
 =?utf-8?B?bjhzam1rOFlya3NRK3dVY2NWMTFGSkoxZlhJL2hpY1JueFlvRVJhVEdJaVVa?=
 =?utf-8?B?VWJZUVJDVlg3Q1hVOHRLenNJbE9uWkgvODNMaGRZR3BxRDhVWUN2RlNhUitZ?=
 =?utf-8?B?SDhETzh3SjJibytCUlQxVGNSclQrQTc5V2tybEcra21HZDd6RkRrSVFqN2Zj?=
 =?utf-8?B?YUVPLzlwV2VFdDFuNVQwV3NuNVI3RXdYQm1vK3h4VmxsMi9yUm9Ya3BEZDRj?=
 =?utf-8?B?aDgyTHNFMjZhS3FkV3pUcGY5bUFXbjB6MGlyd2hMTDJNR1JXUkxqYXVKb3VK?=
 =?utf-8?B?Y0l6NGM3ejMyVWdOT0RDTDl3alVsSVFaTmdnbHQ3MXBEaW9xampnNGFFYzR5?=
 =?utf-8?B?Sk9DTHdTd2dzRTk1dHJaNjh3WXpOaUdGZ0cxS2hwcUphWjlWaFBvSlJ2aTBJ?=
 =?utf-8?B?dll6L1BqUlVoZ3VZSnZRbDd6U0FQNHJPSk9WR2Y0eGVMbXZyZlc0ODBNKzl1?=
 =?utf-8?B?REdDREc1VGp0R3BOS1ZVS21ZYlBmcXdOKzhJTnJoOHY2UVErZEpJMmFaNW5z?=
 =?utf-8?B?Z1FuSDhteUdILzcyUlAvODRCTU1kUnZKdnFBUmFxdmk4a25BK1dhaURjd0hC?=
 =?utf-8?B?cGVkeXhOZ3lFZjJid0xxcUlEUzRJUHdtaFEwNjlwWm9aY0ZCV3NNWDZRcmNs?=
 =?utf-8?B?QXBsa0xFMnJDQSsySEZtRnZhY2VTTXU5WDJFOEh6ck9WTjAwNi9kQTR0L2tm?=
 =?utf-8?B?TGZHeDY0UXFINEVaUFRMTkxQNGFObWNCQnpiUjN2SUpHWitaZ0tVNFVBdHFr?=
 =?utf-8?B?bXBKYTdlbEZhOFI3TUNzS3BDUEMyY0VsaXdQalNiclRzblpVSUtKeGFhZC9n?=
 =?utf-8?B?bjA1dFBYQlM2ekZSbFlnYlhPbVJEUEFESERRQUdvU0dVaTMzQ1ZRMDVTTUo1?=
 =?utf-8?B?TE51WWljOFcvTTZUeFk0WXZFVGtHTTROd2RyRG92ZVVBZ2F1QTdLQlNtOFdn?=
 =?utf-8?B?bGxWTzJndHhpd0Q1NXhKNm92cTBjcHduZzBKVUpBU3pENEVmbS82T3hYNldz?=
 =?utf-8?B?OStBNkFGN2tNY2RJWGVRdlNoUURWbVlGQTZyczMyK2hNSHllS09scmYzb0Fz?=
 =?utf-8?Q?aZG4qH3hLF/Zb+MffrH8A3RaSXWRjqNuI1OEAyMFFQqo?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38deb937-1a75-40d0-d2fa-08dd6c6aa903
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2025 13:32:31.5970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cJ7B9xW0TxxE0rImHRE3/v/5+2TaxBwLYs9oK3iQugNAieEFu5wqhNUzhyr6H26i6nxCbHgk/607fgffCbG96A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR02MB7429

On 2025/3/26 19:04, Mikulas Patocka wrote:
> 
> 
> On Wed, 26 Mar 2025, LongPing Wei wrote:
> 
>> Calling verity_verify_io in bh for IO of all sizes is not suitable for
>> embedded devices. From our tests, it can improve the performance of 4K
>> synchronise random reads.
>> For example:
>> ./fio --name=rand_read --ioengine=psync --rw=randread --bs=4K \
>>   --direct=1 --numjobs=8 --runtime=60 --time_based --group_reporting \
>>   --filename=/dev/block/mapper/xx-verity
>>
>> But it will degrade the performance of 512K synchronise sequential reads
>> on our devices.
>> For example:
>> ./fio --name=read --ioengine=psync --rw=read --bs=512K --direct=1 \
>>   --numjobs=8 --runtime=60 --time_based --group_reporting \
>>   --filename=/dev/block/mapper/xx-verity
>>
>> A parameter array is introduced by this change. And users can modify the
>> default config by /sys/module/dm_verity/parameters/use_bh_bytes.
>>
>> The default limits for NONE/RT/BE/IDLE is set to 4096.
>>
>> Call verity_verify_io directly when verity_end_io is in softirq.
>>
>> Signed-off-by: LongPing Wei <weilongping@oppo.com>
> 
> Are you sure that 4096 bytes is the correct threshold?
> 
> I suggest that you run the benchmarks for 4k, 8k, 16k, 32k, 64k, 128k,
> 256k, 512k and set the default threshold to the largest value where bh
> code performs better than non-bh code.
> 
> Mikulas
> 

Hi, Mikulas

My test device is a smartphone based on SnapDragon 6gen1 with 512GB
UFS3.1 and 12GiB DDR.

./fio --name=rand_read --ioengine=psync --rw=randread --bs=4K \
    --direct=1 --numjobs=8 --runtime=60 --time_based --group_reporting \
    --filename=/dev/block/mapper/xx-verity

origin: 165~MiB/s
after: 215~ MiB/s

./fio --name=rand_read --ioengine=psync --rw=randread --bs=8K \
    --direct=1 --numjobs=8 --runtime=60 --time_based --group_reporting \
    --filename=/dev/block/mapper/xx-verity
origin: 265~ MiB/s
after: 132,268,308,302,116  avg:225.2MiB/s

Just like what I have explained to Eric:

 > On the low-end device I tested locally, soft interrupts would be
 > concentrated on CPU4~7. I tried to increase use_bh_bytes but got
 > negative effects. The time cost of a single block softirq becomes
 > higher, which will defer subsequent block softirq.
 >
 > But on the devices with UFS MCQ or NVME SSD, most verity_end_io should
 > be called in hardirq context directly but not softirq. These devices
 > have the potential to raise the threshold.

I cannot run the benchmarks on the high-end devices with UFS MCQ now
as I don't have a test device with 6.12 kernel. The existing Android
products will stay on the LTS version they are launched on until that
version is EOL. I will share you the results when I get a new product
with 6.12 and UFS MCQ and run the benckmarks in the future.

I would prefer 4096 to be the default threshold as it won't introduce
negative effects on all devices including low-end devices like mine.

LongPing
