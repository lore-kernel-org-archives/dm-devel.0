Received: from MEUPR01CU001.outbound.protection.outlook.com (mail-australiasoutheastazolkn19010001.outbound.protection.outlook.com [52.103.73.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FF22989B0
	for <dm-devel@lists.linux.dev>; Thu,  5 Mar 2026 12:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.73.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772712464; cv=fail; b=nRNwUN3f7A8cOR7raQS3XERbTRs6YZi4DAYnA+8et9ETnz5i+uTfEpYhXOl2AF/U5i0q6H97Sp445QKjQfAgpjCJjTnZ/N6mwk3lcneSADwqK5MI5B2ozX61Yw1q8uEQlYI3RAohhaR19WtqhCzxtppIuE4CqWEw7OQaCCk+wdo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772712464; c=relaxed/simple;
	bh=MQbg3dHyZMTSIailAOeSUlj5Q52Wk3oSnjNeMF4u36o=;
	h=From:Date:Subject:Content-Type:Message-ID:To:Cc:MIME-Version; b=UXn8IKlffPkpa7ihfehCwdiptZEV3/GUa3gI802JhN6T+Aws0LG7mAd/0Tde4tO1oab+Xu8K3InpYeQPDbsZl0gGLB0V4aKDH5JdasJUxYwiufRgnHvsDSZBCe/Hub7CNTjICR/zycs/dyb3iJiCekCYKg/rF6hrZxl6T94Q5RQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=PMkhkbBB; arc=fail smtp.client-ip=52.103.73.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="PMkhkbBB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VKFowHtDEWzAJRjqmljav46p9whDknpJvuj95zNtoNwn2GvsvxAnZd+OT/k296h10s2IHm3q009bhkTeRsn+m5DQ0xlpp3OQJEol/s397P4nQu4DGKM2n2QWQ2DvdBUZZOU91ZLgXjoWZN2pRIMO3Ag4LuppghrJvR4GgI2alZ/nwN086epDIlBFPmuZfrrnRXQWdIxcrAXDCSH26C8fHMs6Pumh0zrqdoxSTxIm0bkiVMtcVsnNpysqv+l41Y9z5mUSsyhQqYgA3sPNpdqIMyjHp7tA8sbqyxilHcvSnIFnuxHcDgDAxyGxwK9l5i0p6qbo8vWMPJ/IK7D/qDIqMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BI6WMnTjoTZ8PVvzMffd2uKfx1OXh9vKBjozOFAPUz8=;
 b=B5Djeg/imUszmTKmMScZEDoHRoyYjVxPGwOdBSi2dsn4EkHMSrXYgCBghDLNVtBkoeEggrBuoiW8cZ3NYywQLq3i5pGwCRLedhV9zqT8MAbGdrxmwrHJP+2PyNlKlKJJ88cavRuZnJ1ydZ8cjNTQ7sk3kx2rO6x6MYIqVIn2lG9T+KeufAMB2+CEKJblAikukzJK6ACxEEzzlJ1WzyZr89SQH2Ak901MbDyAe/6HV7pRFNktMP5WP9Ip3GSN1I/+IvjELYCAYrsvwh3/JANNV+JWX5yQ5Xwgu2Xj5zKsCrtkAPgs1ZbYSK/iO1p4pCofLioNbgRV1sGxjhCxidcb+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BI6WMnTjoTZ8PVvzMffd2uKfx1OXh9vKBjozOFAPUz8=;
 b=PMkhkbBBQHwHuFmYU+Pt+H4G0Z3rJ5aF3BTUOPgJjw53vf1cJnOfzQFSlxPQ7sa5cDCVSPtBxdn4kOo58xf+BW3i5OhaBWrxvOn1jAv8H9WFLkNTgHeFtpnnmPOvZ3bD9wDmAEggVaVLOvzYflcxORAGOuKgE6kqRNzvpXtcu/QPzupRwqF4vnkPRyJeJ+rIHmmEKrQl4hbfJWX6tT6almQBiDkajwy4aJYfjicSc3nAq+uOSZnNOr57thWKmCi7pPr138yHRdklBYMnZkxXfYRUzhJbsXj10JjTfwpM7AjQgJdbLdzd+svXO4rgfJZHp3m8YMVY44lthYWhOHgO1A==
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com (2603:10c6:10:1b0::5)
 by SYBPR01MB6763.ausprd01.prod.outlook.com (2603:10c6:10:12e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Thu, 5 Mar
 2026 12:07:38 +0000
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c]) by SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c%5]) with mapi id 15.20.9678.017; Thu, 5 Mar 2026
 12:07:38 +0000
From: Junrui Luo <moonafterrain@outlook.com>
Date: Thu, 05 Mar 2026 20:05:48 +0800
Subject: [PATCH] dm log: fix out-of-bounds write due to region_count
 overflow
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID:
 <SYBPR01MB78815DE79C53C5ED03058FB9AF7DA@SYBPR01MB7881.ausprd01.prod.outlook.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDYwNT3bTMitRiXUNTsyQLSwMD41QzAyWg2oKiVLAEUGl0bG0tABsT9Jd
 XAAAA
X-Change-ID: 20260305-fixes-156b89003e60
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Yuhao Jiang <danisjiang@gmail.com>, Junrui Luo <moonafterrain@outlook.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2683;
 i=moonafterrain@outlook.com; h=from:subject:message-id;
 bh=MQbg3dHyZMTSIailAOeSUlj5Q52Wk3oSnjNeMF4u36o=;
 b=owGbwMvMwCVW+MIioLvvgwPjabUkhsyVRayce3/d+uBTZiTR++s6xzNOw1zlvHQGocLHJv8E7
 LR2bV7WUcrCIMbFICumyHK84NI3C98tult8tiTDzGFlAhnCwMUpABPJyWFk2FP2++Lr2ed9rbv4
 ZPZ4OvXIRxxzXMaspufvINzW3Lk9k5Fh4UoHE8VoZreD/Der59+dFJ6YnfmxLv/3AdVTnxK236x
 jAwA=
X-Developer-Key: i=moonafterrain@outlook.com; a=openpgp;
 fpr=C770D2F6384DB42DB44CB46371E838508B8EF040
X-ClientProxiedBy: TY4P286CA0121.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:37c::10) To SYBPR01MB7881.ausprd01.prod.outlook.com
 (2603:10c6:10:1b0::5)
X-Microsoft-Original-Message-ID:
 <20260305-fixes-v1-1-bd3a1343570c@outlook.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYBPR01MB7881:EE_|SYBPR01MB6763:EE_
X-MS-Office365-Filtering-Correlation-Id: 3348e31f-53b5-461f-ae7d-08de7aafcb0b
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|41001999006|15080799012|8060799015|461199028|5072599009|19110799012|6090799003|5062599005|23021999003|12121999013|51005399006|3412199025|440099028|40105399003|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b1M5T0twaXBTc2oyVlZNdVZjT2lKNEhCMHJhbTdJUytwTHZrdlhPV0FGT0Jp?=
 =?utf-8?B?WXRJelh3NHhJUDlQOXYxd2FuaURTY1hEd1pCZ2hQeWZaUTZva3dlcWQxdi9p?=
 =?utf-8?B?T0NOZ3pHemZMdkd6dUFHS29PemlTS1dWYTV4bmdYa2FseDRNOEtMakVVUmFC?=
 =?utf-8?B?Vm9rSmQ1UHJObk05eXNmdnh4ckVQWXpLQnBmVy91T0FCQ21ZdWcrZDJPZlpP?=
 =?utf-8?B?RVBDcHBOMUZaUTlwSzJhRy9lRVFuQzhiVHZ3eWE2SFdwWkZrRUFtMTRLUVJm?=
 =?utf-8?B?bGlzSi9BUWFKTUpqWktCSDZqMFJ4K09DLzhoak84eERYM01iejBLMWJhODNw?=
 =?utf-8?B?NUN6UjNSenMxalpXdFprSm14OXdvRkovU0QrNFZqVFVmRzloUWhzMmwzMzNs?=
 =?utf-8?B?WjEwUE1hbkI4enNER0NmVXpyTDBISVE3U0kvakVobXhMYVRzWDZGSnY0ZnFT?=
 =?utf-8?B?eFJoVjdyQkhGR3BnOUtSSDhtU1V6SXBiSDQxR21WdzF2QUM0RW5sSTNjTkNH?=
 =?utf-8?B?S0lDb0gwK09HK3ZiMHQ5VnEwVkc5czZ6VG91U0xwL3Y5NTllNU5ZdEYzMjFY?=
 =?utf-8?B?SUNZUWdEZDZXQlJZeGRlMHVUaExqcnRGNzFtbDVINEl0L0tBWStUSndYVWYy?=
 =?utf-8?B?Mlp0RDBoMis3L2pWT1RLZG5wT1B3RHBPSGFWam9ZaGxlaUIzZnpHanJGV0hY?=
 =?utf-8?B?NWY1N1NJaGk5UDNGbTNFUHE5SDM1UGtlenF3K1VHVXVGQzU2eUd1UXl2MkJp?=
 =?utf-8?B?NzlYM3B5WEdLdm12dDR6djFLbW92ZzkvTTRvdFFlSnRFRW12c1QyVHFtUFFW?=
 =?utf-8?B?MUlwdXRGcHBzUVNqL2pzVWkxUHVMaGNCeXYyT3VnNDQ5RFYxbEdham1EV05y?=
 =?utf-8?B?RkRMQk1GQWZSLy8wd3hhVXpsZkFQL2x3cGd3U3cyYXJLS0pzNHFMbllFNnZy?=
 =?utf-8?B?UjRDTTZ5MjhBbDdQamRPQTJrdFVMdG9MUVZ0NnBySWVUV0tGZTlZY2FDZGJh?=
 =?utf-8?B?TDdCVVJUNmdycVpNTEpnRlZ1VWRWQ1preWMwVXpvQmxEZ255RGVjOFJxSExS?=
 =?utf-8?B?dnJxdVlWaFNsRzFiTUJYempINk1UU0NzRDUyeVg2ZUpVN0h6dmtqTi9TSU14?=
 =?utf-8?B?YjFBY0ZRa0FVdk12TFA4L3p0ZnYwb2w5T004SXBZS2ttNW9OVW9hN25xTEY2?=
 =?utf-8?B?dHNtSFZwNlFhVlVrRTgrRVRqMGJrMGp6Y0JDeXNaTHhCK012SUlXNllZNm5u?=
 =?utf-8?B?dkFRb3MxZVRveXBiNi9zZkltWlNjZlI3TUR1NXVXNWJVVEVwTjNFRjBwa3kx?=
 =?utf-8?B?enpRdzh3a0ZwUm1WemluMGRlSXdZY2tEdThRVzdLUkJzQ25WeTN2eGpnOHpt?=
 =?utf-8?B?TU9aU0ZLR0VDa0kvQ2VaSzNOdEJQWkJFYUdPRk1kb0FaQjdxY3docW8veHZL?=
 =?utf-8?Q?/fmcnkdB?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NUlHa01KdWcwUWc2WmZSelhWbWdxTzJKZG91UGpqenZZV3k3d3drKzZYVW1h?=
 =?utf-8?B?VVpKTXZiT2RiWVRWMGZMekJwWXRtNVZDVDBhWEVkaXNsOW1oYTFVVHlmdW4w?=
 =?utf-8?B?TndWd0h0UGd1Y09KMnJlckhHb3NHUWJDWjFoMXVSZnBCRUllcU85OW9EUXls?=
 =?utf-8?B?WmV5UkR0RkhIMmEyUUpRZGxGMHR4bVFMMDZKQ2tqVEFUYjVRNGtoVzJLZW0v?=
 =?utf-8?B?T1BvaFFiQ0N5MWNMOGFWMkJLTG1SNVlOT0VLUjNlN0VWN0x2UUpLc0pmanlQ?=
 =?utf-8?B?V3ByWk1ROVEzc1BqYlBRbVNhQVZGU0J0OTlhck9meVJQVWVXSjB5K1RDL0lm?=
 =?utf-8?B?b1NvdFR0TnRNdUdOd0hmY2xMcHExL3VkUWNIVEtYOElpeGN0blo2NVhLM0lB?=
 =?utf-8?B?bDlPOVZEUWh2dmpERVFyMGp5T1JJOEtvM0QxeVF1WFoyeWFpRlpVeDFkaHB2?=
 =?utf-8?B?WUwvamNHakl6dXJNZnJHWHppMVB0U2hNWXYvekVZOXV0TU9WcHFrU2hpR1Jj?=
 =?utf-8?B?Nk1KQnhMN0VDTml1eU42WDJpTGVCbWJGMUw2bTlpbzJBVGJobnB2SXlKVUN1?=
 =?utf-8?B?NkkwVno4QVVVSjBHSW9OckhIZ1ZYOUV3WXJIMXdaSWM0VjloZnl0VXhzYXJU?=
 =?utf-8?B?NHNZVUtiMUpzcFNXblRMdlprOUNta0p2c2x1Zm5LNXpvWnplVGkvSk1QR3R0?=
 =?utf-8?B?eGlESDNCYy9qZTMzU0tBb2JNcXg5NSszUWRsQ2FSS2g5T3BKZFk5N1FQMWEz?=
 =?utf-8?B?SWxlS1ZNZG5rdzJ3QkErL0NVajdhbWhhc1IwajlHMngyb2RzM1dndzlBWFZr?=
 =?utf-8?B?YXJGdE9GQ1FJWTFFZkpRbWZtOGRiRnE5enoxcXpuSHJneDdORnRXUEc3amRZ?=
 =?utf-8?B?eXRSdURQb3VPV1N0Q0twa0ZQbWZ2Q0h1Szl2aElxT1JpdVdvMWpyUWRrUnBL?=
 =?utf-8?B?d3lpT2M0UTBTQ05aTnNnUUg0Znl2TzVMSEFSaDNiYWFQZnljc3ZRbzd0eEc0?=
 =?utf-8?B?Q2dlc2s3WGRtNmlpUWlacmRmN0FHUHI0a2JkV214MEhRL2pWcFZkMk5KK2VH?=
 =?utf-8?B?VjVwYXNsUWpCMnZNMlJ5QmN6Uzk3RzQrQk1uUUM3UmxiVkFIYm9sZWcxR05Z?=
 =?utf-8?B?ekhhdm01L2ZoK2xXaEVaMWNaclAxOHB5cGJZT0Q2UHF2TndHRmhraUc3OC9I?=
 =?utf-8?B?c05GYVhEelhVQlZlc3FxQlo2L0RMVy9jVmZsemZuVWRmQkNhZnRibWNZVmtk?=
 =?utf-8?B?Z1dJNWI5Zy9GQm5DV2kvZVpFQjZIaCtSMDE3R2h0ZG1aQ1cwZmdWeWludjNS?=
 =?utf-8?B?ei9ISzM3SEVXeG9mNTZVYjBWcmVhNWdmSzE0bXlPNk9mZEhYSCtsRHRSTVQw?=
 =?utf-8?B?VmNZR2dIQmYwS1lTeWFOSHZ5TXFSQnBsbkN2Wkp4enptaVpXVEFLaFdLN29N?=
 =?utf-8?B?UXVXZEV4Tzg0Q0RoQUV5UjdpUXd4NU9NNGRRUDFYSTQ0cVh0ckM4bXBTVitP?=
 =?utf-8?B?OGRIa0pIWjl5ZjgxaTQ4NEtTWU8xcVhTRG5ZL0p4cmtFSEZjbnhtNDVHRlhL?=
 =?utf-8?B?U3BnUVFIRGJxMkg0b3ZZN1FLbWUraE9jKzdrOUMySWlLSGlIUGl2ZHZKZnV1?=
 =?utf-8?B?bjNoNlhHQ2dKR2ViT21URDJyMUZQV0h1OHFZYlZvV3pHWWhpd3IvVEtBZVpn?=
 =?utf-8?B?eUhWUFB0TDI1TUc2SmNPeG9UOTI2TWx1eG10RE9UWTlmQjdWZHA4SWdMKzJ3?=
 =?utf-8?B?RmwvTXljT1dBeCt6bEM1anAvNjFLNks3a3RqWURzZzcyL3dtdy9YdVBLT2Z3?=
 =?utf-8?B?eXBnUXJWcncvSFBoYnVkaDJVVElhblJ0Qm5CK1BvSWJjRlU3Ykl2cEhBL1BP?=
 =?utf-8?B?OEljWUhXTTBwQ1U4ajJSN09TTURnaGlBWmxmNEtIdDQxSFE9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3348e31f-53b5-461f-ae7d-08de7aafcb0b
X-MS-Exchange-CrossTenant-AuthSource: SYBPR01MB7881.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2026 12:07:38.2650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SYBPR01MB6763

The local variable region_count in create_log_context() is declared as
unsigned int (32-bit), but dm_sector_div_up() returns sector_t (64-bit).
When a device-mapper target has a sufficiently large ti->len with a small
region_size, the division result can exceed UINT_MAX. The truncated
value is then used to calculate bitset_size, causing clean_bits,
sync_bits, and recovering_bits to be allocated far smaller than needed
for the actual number of regions.

Subsequent log operations (log_set_bit, log_clear_bit, log_test_bit) use
region indices derived from the full untruncated region space, causing
out-of-bounds writes to kernel heap memory allocated by vmalloc.

This can be reproduced by creating a mirror target whose region_count
overflows 32 bits:

  dmsetup create bigzero --table '0 8589934594 zero'
  dmsetup create mymirror --table '0 8589934594 mirror \
    core 2 2 nosync 2 /dev/mapper/bigzero 0 \
    /dev/mapper/bigzero 0'

The status output confirms the truncation (sync_count=1 instead of
4294967297, because 0x100000001 was truncated to 1):

  $ dmsetup status mymirror
  0 8589934594 mirror 2 254:1 254:1 1/4294967297 ...

This leads to a kernel crash in core_in_sync:

  BUG: scheduling while atomic: (udev-worker)/9150/0x00000000
  RIP: 0010:core_in_sync+0x14/0x30 [dm_log]
  CR2: 0000000000000008
  Fixing recursive fault but reboot is needed!

Fix by widening the local region_count to sector_t and adding an
explicit overflow check before the value is assigned to lc->region_count.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
---
 drivers/md/dm-log.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 1aa6a4a7d232..d316757a328b 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -373,7 +373,7 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
 
 	struct log_c *lc;
 	uint32_t region_size;
-	unsigned int region_count;
+	sector_t region_count;
 	size_t bitset_size, buf_size;
 	int r;
 	char dummy;
@@ -401,6 +401,10 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
 	}
 
 	region_count = dm_sector_div_up(ti->len, region_size);
+	if (region_count > UINT_MAX) {
+		DMWARN("region count exceeds limit of %u", UINT_MAX);
+		return -EINVAL;
+	}
 
 	lc = kmalloc_obj(*lc);
 	if (!lc) {

---
base-commit: 0031c06807cfa8aa51a759ff8aa09e1aa48149af
change-id: 20260305-fixes-156b89003e60

Best regards,
-- 
Junrui Luo <moonafterrain@outlook.com>

