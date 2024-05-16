Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2075.outbound.protection.outlook.com [40.107.255.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A663E138C
	for <dm-devel@lists.linux.dev>; Thu, 16 May 2024 02:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.255.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715825554; cv=fail; b=egaSSQA2lFTEIxQ7rScmGKUTXtQ68tTRoUZGOOYD9czCpFABlcDAYw2r3nkht+O0H/1iFlN/voMobO1KIhhxAhjaOZKZKVGjTQFuE5Wfh3IkN0nn1wmq7XJTyKfcOE+wz94duAV+/9RZBjlBT9GyhSetvan64R9BZcaZ87UokKY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715825554; c=relaxed/simple;
	bh=HRBU9hwcF0B7XIAG9a34mK4X7oov3Pl1/J5aiWmkQ1I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=P31WrLNoBM7/EIZPQcBoNAh36fbP5msLaLgX6BANwXduYkjdQuulpQqgfhZf+Uo1I18nB0sSwdbedCNd4foe8H82++KPwsu9GVY8xZ/lD7fAV+gyfE9fKvIAAXyihinp+xZSxaV7Z0YY55mIoGZ81ds6n7b9Bf8JJ1czLFyr1VU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=a2PcGGnc; arc=fail smtp.client-ip=40.107.255.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="a2PcGGnc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i1vFUvB//HI8VSmrHj7swF0DkXwCKWU+LUwm10mYOw5cq8jo1On1iPMFJP23URFczsD5VXCGwPPP5MyU2ZQmIyshhHiD0l+flUxXqiUKu7HIUmxzhx3ieiujKtvgoTwzXdtx5mq6kswUQEXAMVf5rYSmo1BguubuomHdAh4LPyguX8fxxrxVNieYEcq3SAh/z2kVaQ28po1xsbV6JKUWIQl8UxsMKT5SVRNGlxSCTDvivH1gY1dP1Engnyno/wlMBv3tkioBjq0Lml8VH2AxUYodCfJFeirsODy06vOvvjsm9X8vhU6zxGz2xcJ6kz81a1DtNUVPaUIvNgBPV6vbUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RDncA7JL+fHBgPPreoZiU/9mKgwsLEruoJ00xhctmFI=;
 b=kgAlPURzPxG3YWpepEUmg37ccAByxGW6RwS7Z2EZLeRIhp/OPLyaLdcIJMKDG50l5Pme8Dvt4mmQISCEutqzGbBeHYSNsfmkijEYBDho5INaZHCTuJV4Gn6A6OeioB7lYiKvCEZUUpKVedMvoueUAqEegSRD/vEd6W3fAN5/P96qfDjfEp57JE8ulett0fF5/qZnDyML2JsQrRZdDAs4WcXfbnFsrvo2jcuvwn6vhwrTOWFjKxlMJwNdWqByCMK2E9qCq/2xNXuFjXB+4FJqMI7mTdxquf4T0nxzYLt6RRSl2hoQgvN9hOAQmkhXC3le6Z+w/dbEJc6fakEfVaDuIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RDncA7JL+fHBgPPreoZiU/9mKgwsLEruoJ00xhctmFI=;
 b=a2PcGGncGnJ/naPjbG/hP+CvMEV2et7IsSR3hR/xHJeG0nW7B7JYhGT6C6gKe6ZhB7hXeSj9RSQEZ/UFtyv5puTahQX4yPyLZTJeBQX3LKUQMaGCGlo3KMMPkUykpR1wB4rkFfN16RsyWAgHCtT7YxZvOj2r317BQbEqdgeFI1bIFFT3Ng69cFpWVtnj+6RYUXVIjdTOWXUyzD7ddeh6FQYU18JuuoQzb3Gau4USkaxFdRfzj4aPc5K6iyMR5WPI+NcmaDLY14OC9J4Ix3GnZsQ1kfY0nGSdwfTVs6RiGH7gcRKp1l1SN1jlSlOCnFiM2pEtSvjjjwnboWm5sM8LGQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com (2603:1096:400:42a::11)
 by PUZPR06MB6128.apcprd06.prod.outlook.com (2603:1096:301:116::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.26; Thu, 16 May
 2024 02:12:29 +0000
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee]) by TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee%3]) with mapi id 15.20.7587.025; Thu, 16 May 2024
 02:12:29 +0000
Message-ID: <4971046c-213b-494b-bf4b-ebe3feaa03c1@vivo.com>
Date: Thu, 16 May 2024 10:12:25 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] dm: support retrieving struct dm_target from struct
 dm_dev
Content-Language: en-US
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20240514090445.2847-1-yang.yang@vivo.com>
 <20240514090445.2847-4-yang.yang@vivo.com> <ZkTXzG1yrPmW64Z6@redhat.com>
 <ZkTcHCM49DDqhaYD@redhat.com>
From: YangYang <yang.yang@vivo.com>
In-Reply-To: <ZkTcHCM49DDqhaYD@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0163.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::19) To TYSPR06MB6411.apcprd06.prod.outlook.com
 (2603:1096:400:42a::11)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYSPR06MB6411:EE_|PUZPR06MB6128:EE_
X-MS-Office365-Filtering-Correlation-Id: 238e4c2d-bc8b-415b-724f-08dc754da362
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ejFaSGVHeTduUEg0a01kaW94R1hnK3EzNGF6VkxEQ2J6cW9SVkVxMnM3Ri9V?=
 =?utf-8?B?c2ZDb2QzTUpUNWc3QnBzT0c1dUlGWVhobHVUWEpRT0Z5Nkw4b1g0bmUwVkVZ?=
 =?utf-8?B?TGhhVkdSSnFOeE5oV3FGSHRoUW9ya1NEQTJmRndCTFZDQU0yS3JVYnIvaHUz?=
 =?utf-8?B?amVOd3NCUDBIWVg2a0xUZmRtRnRvcm9yRzZRR3NIM0VwUit0T0ZRTVczcXRo?=
 =?utf-8?B?MXlvV1dvRnNpaWEvSmRQT0NWM2JieUlqNWhyU0J0Z1JzdnkvUXNuaEJXMGZq?=
 =?utf-8?B?ekJUL2Y2S0cvMFIySGhDem1UUWN5ZC9FQmFuV1RaUnFHUnliOTZxU29lNXps?=
 =?utf-8?B?cURQbDcyTnZGd0xkN0ZvOVV4Ymt0d25tdlVMdWlzeUJGU1dFd1RJbjlQSW5K?=
 =?utf-8?B?L01nellzakFlWTVOUnB3d0NoOFE1TnR1UWZYQThoUmxHUC8rMnVucWFENDNk?=
 =?utf-8?B?TkdiMjZBNmlqZFJGakd4ZXhjb3pqOTN5UDQ1Y3JkQ0llU1ZTelF5Wlg5cXVZ?=
 =?utf-8?B?WkpIUjhpaXFlMjFFTFB1bndNZkNRN1BPTGpBdVBXU254RS9rR0hZS2t6dWZU?=
 =?utf-8?B?UU9OazAxUjJvcmFEMUhrWDFNTjM3cXpsWXVUUzMraEdIUG5pTTdDUnN2cTVH?=
 =?utf-8?B?V0N0UXBCVTljSndNMFBhU255amtGbWJJVGxOUk95am84M2pXMWoySG4ydkhh?=
 =?utf-8?B?MCtSaVU4OENkSUdxYkFkQnRyRnhmWUJpVkNVaUprWWh6VWpuK0tFM2NTZEdD?=
 =?utf-8?B?R09WN25ocUNmV2Z2SjJwRUEwaGZjR0NpZEZTT0NXKzBaVmhiLzB6MjM0ZnNY?=
 =?utf-8?B?NERocnI4VnFiOXBqUURMeW4rTUw0Nzk4TkRQbzJFbWRXb3JOODdmN2dkbFhG?=
 =?utf-8?B?MWdGRkNVRDk5M08wUU0rN1JPNWtNNWk2ZFhza0hnN2RkYk9xR0N6Vzh1dnhl?=
 =?utf-8?B?UmlESXpwY2d6czdhVkxoL0dZQUhZZEowVnZpdnR5dFRWd05rRW1mOS9ESWlt?=
 =?utf-8?B?aDVCWjNKREdkY3VVS1NWWFFNclh5QzgrYkVwcnpUWlRBUmVhSUI0SXVLNnJ0?=
 =?utf-8?B?NzFINmFFWjJIN3FrRVlkeUZJdTcwVE50dVVWdkF1aFBHK1dWR0lra2RPdkZE?=
 =?utf-8?B?S2ZjV3RTM3FyN2c1MnFqQ0VIRm9FMG8zaDZubWs1QnQ1bzBJZ3MzYTdrYzJs?=
 =?utf-8?B?RWxrRWZqV25MdkpHdWlOUmR2RjRFY20vQTZYU1QvQWNQZGdhazlCTE5DYitj?=
 =?utf-8?B?c2J5bllTSU9iVmRDNGl5QXhUazdKVEVSRVlMcWZVM2czZktjWWhSTHJyaEJV?=
 =?utf-8?B?Q0srQWJ1OVVEdjZPS3MzRUl4eVNRYzY5RGdCbHJkMHhERksrdHlTMnFvbWlE?=
 =?utf-8?B?aStTZnJ1c0tLSTdUTkhoeHFoL1p6Z1VKU1o0QTRnVW0zdTNaN2wxU3JWYU9P?=
 =?utf-8?B?aDlSSG1ocUpPZTFkMndYZkgyVGp4N0lVUDJJRUhhWlgrYWF1bjBXeGtGWG1a?=
 =?utf-8?B?aS9mcVhLeUt0RGczT0llR0ozRG1seVl5STJrMjE0VzdUNjVRU3pFSDNxMU1l?=
 =?utf-8?B?QkN4a05GSkxWQWw5SWlBL2tzcEFwK3dYdXI4L1cxK3lGek0xdmdOZVd3QjBu?=
 =?utf-8?B?OUE3SXI4UDFua3VlZ2xlbUhTSzllaHVVUHFjSy9hZ3MvdEpWQzYwcGlXNm9s?=
 =?utf-8?B?R2dNMVg5R3I3dHRNZzA3ZVpad1JZV2ZWU215MTZXTDhJNWpLSzBQVmNRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6411.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?STA2R0hTZVBmbk4weGl4M3pYcFFZYVpPYnlObGFYNFU0dTB3YzRBK0RQMHZS?=
 =?utf-8?B?YnFlS1VROEI5cStvRWE3QlpWTGN6cEVsWDN6Z2pXUjRwN1owZ2FWT1YxWVdJ?=
 =?utf-8?B?b3F1eGhva252cnN0eG5nYUZkK3gyMFNROHR6dUppS2ZTTWVOVUQ1UWJ3ZFJP?=
 =?utf-8?B?THhrQVYxTXpUWGhJUU1HSHNnRzNSaFBicWMxVnpRb1dSSmtwT1Vmc2ZZZGto?=
 =?utf-8?B?cmpwM2k0QTBlR0tzS085SlZ5dXEyNzhDUzM5UVNOWVNGUFIvTWF2SlRlV2pi?=
 =?utf-8?B?RGhaYWEzdmYvbW9WSEpDa1oyOU9RNzVpenkrWlF3TFRsbWpzUVVXcWR0MlRW?=
 =?utf-8?B?L1M2T2piOXZyMjI0T1lRd2puSmZMUk9uT1pINzNPZnBwWVJTMjloaFI2dllo?=
 =?utf-8?B?bWFqUS9DVCtubGdpNkJzMDcvZituQUlFRkRncllxRmdlSEVWWHNoMkhLTS9F?=
 =?utf-8?B?ckRQREJZTS9DZE1yb3JjTnRmd3c0cW1vZllFQzRhaFZyUXlVRVNTY0htb2dY?=
 =?utf-8?B?eHNyZU1KUFJjTHpDWXNDRXhPRmN2ckhSK1kvU3QxT1lPRzlsdHo3L3dJbVg0?=
 =?utf-8?B?QXNFNTh2TFdHV05tejhMSWJQMzYyV2lqSXZXN0dTK2hXTFFzdFdScnAwU3pD?=
 =?utf-8?B?TGRQMkpqVnlCQXcyM0lyamhaQTV5Wjl5NEpZOStmeGtPR3ViamxtMWwzOTJS?=
 =?utf-8?B?V1VQS01PNXp6NXV6a0t2TGpBWXNib0NvaVVXc0hrR001ZUZITUxjMXV6azlY?=
 =?utf-8?B?UXRocTFXVHpXSVB0eUNoYm9PdkRzc3pURk94a3UzelhDQ1ZJYnQrSmM1aVdQ?=
 =?utf-8?B?NWNQcEhBVmxLYzI3OVEzc3pLT2ROU01zTkx2WE9LYittRjdOTFFqVXNzMEdQ?=
 =?utf-8?B?SVM3YWEzRThTcWF0LzR4ZmxQRFJHTW1GbUVzaEh1N1hoTzl2YWV2UmRHc2NS?=
 =?utf-8?B?cUhPRTRlQUV1ZkJ5bUhrbVBISGdha09HNnV2ZGVNeGdHQnQ4SlVQZXNEL0Zx?=
 =?utf-8?B?VjdYL0w5YXZmYU5UOVJLVUVjSVRFSG0ybmxoR0ZpSzdhRlBQekQ4Q0c4bGo3?=
 =?utf-8?B?Q0pIOXRxcmNHYnBLR2JlS1VBaFdTdnRZdkVta3MxSVcrMHYwemQrRzhhNHlx?=
 =?utf-8?B?dmovN1NMY0RHczFBT2kxUnV5SkJxZ1pDU0lMQUJFL1lSQjAwZ0lyNVE3Y3dT?=
 =?utf-8?B?Um42M3FQWDh2b0JCWjVNdVovL0JpdVk4eW80TklYNDJkY1B0OXVQdTRQOUlW?=
 =?utf-8?B?WkJVZWJ2VHRDcXZzNFlaZXd5SWJUYWsweld3MW85cncwKzhKT0d4YjhYVEUv?=
 =?utf-8?B?NllQM2RKaXN3RkVSVThvTFVpbUZLbFNQbHNKNzV1YUxuZUtoaUVmMEpYRWxj?=
 =?utf-8?B?MTdHTk1ZOTJzc2UyZERwR1VvY0RMOHFFVEI5WnI4YmpBdUFLQzYxK1N6a0Vk?=
 =?utf-8?B?dDdyK3F1V2FibW9iOHdXTkMyZ2pGREJsa29HUjlHUXBoVW1zSXNtL2U5SjVh?=
 =?utf-8?B?TE5kNWcveDg2NnVLcXZJbWRacXJwU204K2l3RElOZW42MmdtSTNHWmR4OGI4?=
 =?utf-8?B?ZXBJcHRuZllrb3lEaVlDcjNGSDNQQzZJTWFSU3Z1QXpxeFJIZjM1c09EK0xp?=
 =?utf-8?B?NSs3Ym9VbXF4SzNhVDVTb25MbnVabG9JM3hrcnNnM1lTWnFERm4vTWIwdVpJ?=
 =?utf-8?B?NEthRmJpSUoxRTNmVmx4QSs1aCszdm9aMG5xbkhvTmNZeFRTRmIwWVJtZXhW?=
 =?utf-8?B?NkJ6cTBURGZpQkg5ZklIZUZpUHF1c0IyVEVSY3pvSVNRRUFEOXRaUndzYmVM?=
 =?utf-8?B?VTBnekdjbWczUXk4OVIzWkdsYzJKSHBWb0VIUFMyOW5qRU9TWXJ6ZGF0TUJh?=
 =?utf-8?B?MzVPUHREV2szMi9sb3RkYzI3bVBpeGpzVUJqOGU0SkN5WHlKU1NuYTRIM0Qv?=
 =?utf-8?B?UEViNWZPb1FsalliSnhsaDV2SW1qZmlDKzUzaXRTc0wxNkpJNUpCZW9JcDhq?=
 =?utf-8?B?Rm9yaytta3UzcXZ6ZGpqdDJSZ3Q4Zk05dWVUaWVIY0E0eTFSUVoxMnRaQmxK?=
 =?utf-8?B?bFZqMDFlQmM2S0l0eXN2T09QYUlpV1hNZTR3bUpKekRRd3BFeGtEZXIwRTJN?=
 =?utf-8?Q?xqVrI2OjFSzmyEfvJDMvSFEss?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 238e4c2d-bc8b-415b-724f-08dc754da362
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6411.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 02:12:29.5078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uWat1srdjWteF7vHzxa7keKWEJNedIHBPfkCLz9yrUix/XYhDfEa4SiskQ77bnqGXwLIpJnjaB5gwimoOIKXnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB6128

On 2024/5/16 0:00, Benjamin Marzinski wrote:
> On Wed, May 15, 2024 at 11:42:04AM -0400, Benjamin Marzinski wrote:
>> When a target calls dm_get_device(), if it adds a new table device to
>> t->devices, then it's the first target in this table to use that device.
>> If flush_pass_around is set for this target, then it also sets
>> sends_pass_around_flush. In __send_empty_flush() if the table has
>> flush_pass_around set, when you iterate through the devices, you only
> 
> Err, "When you iterate through the *targets*, you only ..." In this
> method you don't iterate through the list of devices (which is supposed
> to be protected by t->devices_lock).

I'm not very familiar with this area, I thought that the device list
of an active table cannot be modified, so it doesn't need to be
protected by t->devices_lock.

> 
>> call __send_empty_flush_bios() for the ones with sends_pass_around_flush
>> set.
>>
>> Or am I overlooking something?
>>
>> -Ben
> 

