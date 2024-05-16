Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2045.outbound.protection.outlook.com [40.107.215.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1432E2031D
	for <dm-devel@lists.linux.dev>; Thu, 16 May 2024 07:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715845395; cv=fail; b=oPMGkhzPqcRNdjzZ7kYEBnEJqJ4RQyhmyoPedxyWEJ8ewKgIC6dqRn1IGaj/qgqWlU7VlSGct6VZEUWFBaCoEjtu+ADyDOB6HYv2FHNvoN41ldHjnn/FoEJytE2+qQ97VSoqRdFfZ6UHjEfcKJebrWthY1u4Z5/dtX50N9pfnyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715845395; c=relaxed/simple;
	bh=QlDupdg8sJ3EnBzBEmFpa2xfkoq/LFfkdJLDSDyXMpc=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JoRQORnhh+/tp7JL8Ih93thESDXRrOfjUAo0TkWcCQSSkXwaQW8ZDtClIm9u42nI2BpsWVdYxI5v9S2g3fOcogcygeLfrBKbaJ1zXUiqqcRoPtmEit7CdnTwD2QkCtStOV+yzosdl4ai33ihYYfCMCOGC3wLPRdfO6wrVb92N4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=kQcNMzQQ; arc=fail smtp.client-ip=40.107.215.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="kQcNMzQQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hb2jc86Ah12hQot8UXpr8+F+uEXWzP6wx+ro33aGfEoFiR4mkwvlpzAP4ndDb+aD8mPAHHpSL+mrsJqg4yQQ9yq6xyfVv4phMcxrFahhLcK6b3fe/fK4k+idK/NPVmIa7VxoHxaAiJGaomi18w1hSEE0jJNgrE/aP3W+chv1UdRYCo963VIJs+gb9eh0OWZWXtfhhZ207GiLqKTu1R5tvF9d3ROI8cn0TRL21YilOdr8E9J+FROD43AHUr+6BKHQJiklw7ogCf8cVticCIaBmFCJZTU2vW2ue5s3poWTirlAmlHEllses8avJXB99rIjG9BZDttk66FkQxekVtm5ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KfTGmahX3n26orNwhDgLhuS6DAJu/b64HX+JYVtS41U=;
 b=Zqqnk3q9KnB5sdxJZSCgiOJXI0/G40MstS9y88AIMoOQ4OjK2UDM0hU4Zzor1wfJ9fMeRBN6bZZPoGY6bDI4LleW+iSGrigVLKulsWlxT3hFHtXT0S+zx1p2bQ+T2HOSoeXlenFUFHpLmyYJsQOTraGSCStyMdDL6nP7OAhWCE5OjZd1yD7iwAlMum0qBtHAz5u/qd7tWp6VfVqV41LZJIHWWiKhV/YSDSiLCGLbVQX13NZYKsCs2kRJEfhLyWok0X6rlVL3bmezMr/XTqHrTg1EJFHjCmyH6T4d4r8tTm/k5Lfe1oaE8BALfDBD4CZkol5vo/9U42EEv0Ccu/JvMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KfTGmahX3n26orNwhDgLhuS6DAJu/b64HX+JYVtS41U=;
 b=kQcNMzQQQaSePYnu6XBo1IwzxdLTYnjjB8RicAnyApbHtq1Dq8GctybxNx5lJ9W3q8koYoIN0qD96tprn1hfcdWmqkZE+/DLJ4NNRYr1UWSNbN+1n2QNkNOWokW8qeIqPnNXukQw7YQhHydvbhdV2zJXyqR9LEUFScaDuzKd7StdLgFNBo6AbZSoA4JgaOxXyXqQl+w2qbhW+06NYpqmEywYL8k/A4iBDBt7Zs/xQdJv2GA4+EhDT1G+QtLn/9KGsabOiYLSbR4QD9ZPIlVal7lf+EOds9xiyaFZLX0k2oe0UnhENGsG/gmNknzAFwzmmqpdxXtgi04S7KKvNlTPkg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com (2603:1096:400:42a::11)
 by SEZPR06MB7060.apcprd06.prod.outlook.com (2603:1096:101:1f3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.25; Thu, 16 May
 2024 07:43:05 +0000
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee]) by TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee%3]) with mapi id 15.20.7587.025; Thu, 16 May 2024
 07:43:05 +0000
Message-ID: <c795cdeb-17e3-4a34-8405-a11144dad0a4@vivo.com>
Date: Thu, 16 May 2024 15:43:01 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/5] dm: empty flush optimization
Content-Language: en-US
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20240516040235.115651-1-yang.yang@vivo.com>
From: YangYang <yang.yang@vivo.com>
In-Reply-To: <20240516040235.115651-1-yang.yang@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCPR01CA0011.jpnprd01.prod.outlook.com (2603:1096:405::23)
 To TYSPR06MB6411.apcprd06.prod.outlook.com (2603:1096:400:42a::11)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYSPR06MB6411:EE_|SEZPR06MB7060:EE_
X-MS-Office365-Filtering-Correlation-Id: 272c859a-d973-4630-5820-08dc757bd255
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VThzdk9NWVM5b0JqYmJZOU5KUDZkQUFiaWNMOXNaTWlrWVZNbDFDMDI0STlj?=
 =?utf-8?B?VXN5OU9HSklrNnlTT04rWWs5VDNOUGZwSU1BNzhzZDlTT0NNUU1KRVhTbFNJ?=
 =?utf-8?B?VzFHSGVHamtBeEc5blI3TXhrUHQrZTFqNnJHVUV2eERKRjJ4YWdTZi8vdEFo?=
 =?utf-8?B?TFFnUktTVnFzSzJaR1NDK2VvaVNKbkwxMExxa1hqU0J4cHVHMGFrU0JVVk9U?=
 =?utf-8?B?eHUrckxiM3htMCt2OTJnUlY5MytBMjF4RUJEdG5uU3VoSllWWG16T0M4bm83?=
 =?utf-8?B?S0twOWtReFViQWJsS2RseDVkS3dnMk9TeDcveUZtTG05cFplZnhOVlZYL3BL?=
 =?utf-8?B?MWpNWVlHY3duaUpjZENYWnh1WFhyU2Fxa2J2eGdjWTBEMHZyMEVkY1hDQnFr?=
 =?utf-8?B?b0RWTmlzejFXZTFGazBVWDlxSmlva1RmU25tYXdwaGh1Lys4SGhxU0hHQURo?=
 =?utf-8?B?aFU3SVZPWDFLa0N4WDVtN0JUUHJxbDJMOVVNZWZXdVpnMnorN0YxRlNabktw?=
 =?utf-8?B?cEcvZEFRemlhQnc0VE5VeVNFWVU4M2RyYUNwcHNGZTRjTDYrOE1rMkdiSUM0?=
 =?utf-8?B?bGRmelZiVjZtbTlCT1pZWUgxbGtvd3FZR29nOXI3Q1Z3dnlrVXFPSXl4V1ow?=
 =?utf-8?B?Z3ViMHQ1SjIzd1RJQ05OWkpMa0hNbHpkM1FXallVbFlqaE0wTVp2MFRCbW4r?=
 =?utf-8?B?SGFDY0xwcXlaMytWTml2NDBOOE9WVlJQNVovS01qb1BGMXV4QVJMUS8xbnVG?=
 =?utf-8?B?WjdNNS9IUGk4N29hZnhCQU5NY285cURGa0xlVWsxeVJxTjZFSUJ1aDhnUFNH?=
 =?utf-8?B?RS9GTktGNjNLbjZjOTZUd2Z5eXdHd2ovV1E3b05wV21odEpiSU51RkxLZnhv?=
 =?utf-8?B?RUNEZFFkWSttaGRrM1lkcHBVdjBZd0x5K2l5azFFVmhOTG9SbzBkMG5rNWdy?=
 =?utf-8?B?YlBNeGFKenJDeVptOE1iRFd1Q3JwdFlpRlFEYmlkTTdUNkhHNU9mNnJJZHFY?=
 =?utf-8?B?T200emVOTEdsdGRCWGZjNEVJZ21CamJiWUxKUGRsZzVmL2toc0pYRE1DQWVR?=
 =?utf-8?B?cVdzeWVoTUhSa2gzZVZUNlU1WlVIQXNMYXVHem1oK1RqekJuMmpLclNPbWJu?=
 =?utf-8?B?T2JSYkM1Vkp3ZkUwWGZZUXJQRDNqUyt2cWVwRGdQNHpIc3dxZUNDTG5EQjZs?=
 =?utf-8?B?V0tHZGdJMEhBV1JtRnd4MHU2RGE1cStFdTdiMURyU0dzUmF6dVVoV3dRVVVo?=
 =?utf-8?B?dmxsS3J6VzVtZEV6MU11QnJtSW5WVVhyRWxtaEtGVkRqVlprY3lCMDV1bEM0?=
 =?utf-8?B?QXUvRUY4V3htVkhQNFhiN3NCTWNaYXNrR3dLUzVBWElxYllCMUtLVzNxd2hD?=
 =?utf-8?B?LzZSeWpnTStlcVJLUk4yNHFTc0JwSEtIWllXeU9WNDNKcVluY0VWMlR1QzJM?=
 =?utf-8?B?c0NxWnVidDQ3NmwwSmdZVUpsRGFSQm1IZWgyK0FFMEhsTHBXUDhwMmU4YlZO?=
 =?utf-8?B?ZXFFSkFTS0Q0MnRNc1dVa2h6OEZmR0pnbjN6cmNYNVZvY2NzWk8ybkdudFIv?=
 =?utf-8?B?Y0kvWUNWdEg1ckQzMHR4NGYzNHM1YmlUNk5HYnkvNmVCVlorWUw5U1VFalVY?=
 =?utf-8?B?aGNxU3AvbnlMdjlQRWF0ek9QYjFxNWxVYitISnAwdDRJNlJtMXVNVkhHZnZ6?=
 =?utf-8?B?UGFWQS8ybHM2TzJzc3JaYVlNV0pYM0lhcFFYNmNFSFFCK0grdnAwbEx3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6411.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TXlDcncwUml0NWI5VkxiQkZ1M2hEcDJpZ1RyVDQ5clVCbzNwbDZYS0laSHhD?=
 =?utf-8?B?N0QrcENmUzdvbkdidUo2SmFZQ0dhM0F0TjZDbHBpSWhnMlozNHpIa2tHUmhK?=
 =?utf-8?B?UTE3SDd1di9XU01vYzVXckVKUW5rVlRNdDN3dVIvdjF6K3J6TG1JU1FFS0NM?=
 =?utf-8?B?MXA3RytMdlZOak9OSjJNTlpSNnNtNFZxeExPZjBzMEpjalV2ejFOa1czcEZU?=
 =?utf-8?B?TEk3dCtaa3JWZnJ5SWd3ZjBmZXJGTmZSTEVnVzVITHo4TEhyUGxZY0YweFht?=
 =?utf-8?B?MlFEdTJsclZJOHpPTlk0ZGk2YlY1MXFNVGtTZU80WmNNSlBhQjJWTURJVHo3?=
 =?utf-8?B?Q0NpNHFWckZNYVVHR1dHanBqT1dSZkYrektHeUJVMG13V00yaVB3NVdLTXlw?=
 =?utf-8?B?QXZMVEJhNk5JMytOQWZqYVg5VlYrbUlWMHFWUXh6amRCYUlNdGtFSFhYVlVG?=
 =?utf-8?B?MTkvUzQyOU1iQ3c1b0FxdmV6bmZxei9tekw0VllzazBLbkVGcGlZbTFoSHBy?=
 =?utf-8?B?cWJtYkdtTU9lMkVWL0xpNmFyV1dTeXF4VE1CUUR0Ri9tNW01WWRFMndOMHR5?=
 =?utf-8?B?dlpOak9mSFNGaXpUT2hiQlp3RUdWWDlsd2N1N1pmTFZlMU1aOWMxMUpzV3Qv?=
 =?utf-8?B?SEVlVDNGVE1rZUZ4bWE1RytXNDRsc3A1U3Y5VkNZVitLN3JmZmtzR3k0SXUz?=
 =?utf-8?B?dlN2bTZZMWQ0b212clkrNGdRYmNXS0hpUXJERnpFWElTUnlnMHBsaVRRRFhK?=
 =?utf-8?B?citweVF6ak5HOElTcTFvenRhTG9nZEhvQTFQVy93Q1lZUFhmcDZhZnVjaElY?=
 =?utf-8?B?c3JRMnZnUitwSWJFaFcwZGtyazk5K1pvbGFvb3I4eTF3WWhhdDZSckxLQmg1?=
 =?utf-8?B?a1pyOEhWOGhlTUVZZzBPeTREemdieklVRUxBbFVSbUpnSFF3U3pnMnpuSkpZ?=
 =?utf-8?B?dGZ6UWtDQlBlSUpvRyt5R1RDNFl2V0hYVmNsZlI3R3dDYjJQTDd5ZmVPWnRN?=
 =?utf-8?B?emh6bFpwSjRjYitWT2Z3OTdSL2tNZkxDMktBQVRRd1E2KzltOGl2QUFRWEI5?=
 =?utf-8?B?STYwd081aXVXWkJ6Q1pDKzJQRXZranoxcGZPREQ4emNtNWI5cTR3UGhRMWdq?=
 =?utf-8?B?bHg0V1NVcCtPZk1MODlKd2xxY21wSWlUUyt1VW1RQkxSYjBrT0NqM3V3SnFM?=
 =?utf-8?B?MjBLMnppVEVDNXRmaWc2c092VTdLaHo4RzVxaTVHRkQ0c0JlLzE2UjBzcDgr?=
 =?utf-8?B?VmtKMHRxcThVR3JUMitLd05Mai9lMU5qV1JuWnBWRllZaDVGVUpjbGV0UTA2?=
 =?utf-8?B?ZE5BYS9XLzdLRjFMZ2IxK2w3UUpWZzVKaVFGK3d0YzNwcW8vVVE2VnhLVG5q?=
 =?utf-8?B?MzBlaEVrc2N0dXlPYWNRYWVlUXdnZkgyNUNFeGMrNUc5YjIvUERGWkxLTmxD?=
 =?utf-8?B?NkMzY3ZyOVNaTHZmSWVES1hIWkVTOGhuRzk5c0pLQlJ3U2ZwS2w2WTdDYjNI?=
 =?utf-8?B?TzBRU1ZRSnJJUjNRTVhrUEJHWlVybFgxd1pBQVZCeG40QzU0WTJDQlVqeFdM?=
 =?utf-8?B?NEhYY0pmV0tJanVlcFFPNDhQUkMvZldSb281S3RXNzduU3IxWldPMlJacXR0?=
 =?utf-8?B?YmtGbkQ4dkxWb1dFLzczY3ZSK1QwVUxDVDA1bjBrbm5YQVlBcktoa0o1TnJ4?=
 =?utf-8?B?TWFyek5DRnAwZENhdEYwQTJPVVo4cVErNm9xNk8wdEdIMjhxalM4OGR5cUZz?=
 =?utf-8?B?NnlnWmhqcm53THNqdFcwSHNRS01wS2Zwd3EzcGM5NTRaNGNEQ25Jd3pxdys0?=
 =?utf-8?B?eGJqRGFCK1dpSHA3ajNrR2x1VHZ5bWk1Y1FiSWdKeUE1L2thZFU4MnN6TTBx?=
 =?utf-8?B?UmxQTW0ySUNmRFN3YXllYzhNTFFUVkRIT29MQTN4aVpRQjd6dmdZUnQ4a0M3?=
 =?utf-8?B?R1FCRTA2Rm5uTk9jdndjTFc0SUNraklkQ1dOL3FGNFVyanRJSDZSNHVwb0w5?=
 =?utf-8?B?YmZnL0d2TXhYN2ttNUQzOVhVRFppMm5kejltYzByTTNrMjRsd0VrTHBoL0Iw?=
 =?utf-8?B?OXVoVThMTG9iTHI1TjNYZGd4WnBNOERBMm55SGpRNzVRUmNEeTFYZEttdW4r?=
 =?utf-8?Q?t+5tvMYu6h3vZiuSxuITeYawP?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 272c859a-d973-4630-5820-08dc757bd255
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6411.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 07:43:05.1188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GrGZl0PCjOWnQHK0j8bOTkjHHAHkA6vqVZqBJnNKt3Zf0iyE8JY6OcdhB4VZwtU+ZBfAx6h/+yzYYHuP++1Rsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB7060

On 2024/5/16 12:02, Yang Yang wrote:
> __send_empty_flush() sends empty flush bios to every target in the
> dm_table. However, if the num_targets exceeds the number of block
> devices in the dm_table's device list, it could lead to multiple
> invocations of __send_duplicate_bios() for the same block device.
> Typically, a single thread sending numerous empty flush bios to one
> block device is redundant, as these bios are likely to be merged by the
> flush state machine. In scenarios where num_targets significantly
> outweighs the number of block devices, such behavior may result in a
> noteworthy decrease in performance.
> 
> This is a real-world scenario that we have encountered:
> 1) Call fallocate(file_fd, 0, 0, SZ_8G)
> 2) Call ioctl(file_fd, FS_IOC_FIEMAP, fiemap). In situations of severe
> file system fragmentation, fiemap->fm_mapped_extents may exceed 1000.
> 3) Create a dm-linear device based on fiemap->fm_extents
> 4) Create a snapshot-cow device based on the dm-linear device
> 
> Perf diff of fio test:
>    fio --group_reporting --name=benchmark --filename=/dev/mapper/example \
>        --ioengine=sync --invalidate=1 --numjobs=16 --rw=randwrite \
>        --blocksize=4k --size=2G --time_based --runtime=30 --fdatasync=1
> 
> Scenario one:
>    for i in {0..1023}; do
>      echo $((8000*$i)) 8000 linear /dev/sda2 $((16384*$i))
>    done | sudo dmsetup create example
> 
>    Before: bw=857KiB/
>    After:  bw=30.8MiB/s    +3580%
> 
> Scenario two:
>    for i in {0..1023}; do
>      if [[ $i -gt 511 ]]; then
>        echo $((8000*$i)) 8000 linear /dev/nvme0n1p6 $((16384*$i))
>      else
>        echo $((8000*$i)) 8000 linear /dev/sda2 $((16384*$i))
>      fi
>    done | sudo dmsetup create example
> 
>    Before: bw=1470KiB/
>    After:  bw=33.9MiB/s    +2261%
> 
> Any comments are welcome!
> 
> V3:
> -- Focus on targets with num_flush_bios equal to 1 to simplify the code
> -- Use t->devices_lock to protect the dm_table's device list

Please ignore V3, which has a build warning. I will send V4 with the fix.

Thanks

