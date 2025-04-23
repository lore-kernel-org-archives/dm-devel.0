Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013029.outbound.protection.outlook.com [52.101.127.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E311128EC
	for <dm-devel@lists.linux.dev>; Wed, 23 Apr 2025 00:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745367291; cv=fail; b=IyMDvzBp715WIxec5a2iYdg4rubS+RKsnzztpXi26pwQmtbXypD3tOXNC1sKBdOCOZ0bss8HgfYuL7hfrC+qITLudm2UAkVquRy+Dcegzmrknd6bhdyz4NoZxNmOmJNBD560mn/jkFy5L3mF04XIsd6OIS1mtryK402ndSOLOu4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745367291; c=relaxed/simple;
	bh=GuXIngE7To2YRKgpX5qpoZrpAsO9yG73ENCjy89/pQI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=R8DgSko8BUxIfmytGdzyAk7ItWvESGF0HTQ9sxGLAYydtAtqhmmzAaKHyikHh2rHmfvbTxUJSy4cRpl1LmyqNRkrBZTKz0O+68+K9FSsXW2NUhWatWmlC5VUtES7Bd7BRgajDQ51j9qHhrmrJvzUCYmFJm19CN7DEko5eGpe+6A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=Un2buV8z; arc=fail smtp.client-ip=52.101.127.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="Un2buV8z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SNJOBm0pvzl6IGomfLRtSId2HLSg+2ZA0W94UKv24A/IiCYw4+/oZn9J2WotPI1D8QkkPu32CSaB4zV/AjYoC6kY2H1gsB/a5XuBWZZ4Va5D39lJjebamTUCRmF/6syTQjwYwWmCS2Bu+KYKllNCloXEV8MwGyUa/u+TQ4DcRK6VLCXixJegFKHQEvWPDQRFahfxbCcCrKZRZKe22ygmS2lx+jxpG3sTn+APM0wD21HJ7/zwVkr3S6XTac/wYJZhDNnDS5ddmjcAfeyXQndrHYCY0JZ2/oBRW6MZr6wdTUL1xU1eu8oypdq1Bt88hIiu45qrW2qmCyL+LCZ4ZM+heA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6VglFwQc1y/67uUIHRygpcclQ0wmfTTL2JBTHMdyzos=;
 b=oDlEXQlWcsCkSpAgn5Swwezlhis0Ra1JFlGcAi7rvwRFe8g2HV4+B5Q4K/FHopvFzxy/JMkZiiAYs5XW87xIPaUn9bTddzvCz+6q8QWUaTYPJjrQ76HFbXqFyF9NYdsDn+mjeEfn/wVAZBHZ9QmUbP5y8zEJIM03ALOBeRnJ9WfdNKmehRoKIz/waphbx/8Tx2jRU8vUllK/5USzTvkvsl3ld6B4yY9p+p1HHH1/U5GettEyTPi2BXhC13Y2xR/qZ65D/fOYmvIk8+z5vEMuLvkyU+PjNFEBD6NGjgxJpOTrW00LZBZbhi1OjULKTTmzkdTSc+7K+4Z5+Vddj2KnGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6VglFwQc1y/67uUIHRygpcclQ0wmfTTL2JBTHMdyzos=;
 b=Un2buV8zpBBcK87towjvYiyHFGT+9/K69ktdyors82WsCvuRFA/tq/sj3I0nKBjGgWJSx+CgCR++ql7oEycqj6VkIbAgqCjrLcHSxY/sOF1mMfiWTw3HCGCK46TF9iH4wXtBsXFLWdeW7xS6r4xQxZxk/v1RrPQqpOm0YB/4pOE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by TY1PPFF4FC7B568.apcprd02.prod.outlook.com (2603:1096:408::972) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.18; Wed, 23 Apr
 2025 00:14:37 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8655.033; Wed, 23 Apr 2025
 00:14:37 +0000
From: LongPing Wei <weilongping@oppo.com>
To: jstultz@google.com,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	guoweichao@oppo.com,
	snitzer@kernel.org,
	stable@vger.kernel.org,
	weilongping@oppo.com
Subject: [PATCH v4] dm-bufio: don't schedule in atomic context
Date: Wed, 23 Apr 2025 08:12:04 +0800
Message-Id: <20250423001203.3776241-1-weilongping@oppo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CANDhNCrpSApv55_0LN816nNaGhPWiWZNODr-_1egjPpgGGb1-A@mail.gmail.com>
References: <CANDhNCrpSApv55_0LN816nNaGhPWiWZNODr-_1egjPpgGGb1-A@mail.gmail.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR0101CA0006.apcprd01.prod.exchangelabs.com
 (2603:1096:404:92::18) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|TY1PPFF4FC7B568:EE_
X-MS-Office365-Filtering-Correlation-Id: b62455c4-7084-438e-c5be-08dd81fbd4a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gX2LhxLJxuZji+33DZUNhos4dnmnPGJJAb8P6KFQoc7es9AYOpHZnpT5nwNm?=
 =?us-ascii?Q?SZoLUFQREvps+Y9CJ0+vSFYGFt+SdaUupYxeOVDBKKFuAcupaWMhiB2A5Gdb?=
 =?us-ascii?Q?QhFa2TiCniU4242MzCTGZnfB4Pnda7gmYIgRx/XulAC+K/pypD8n9EYCbFEw?=
 =?us-ascii?Q?yeED+NuD5MZLah231IVSG2TK4TgvCKG58XsTLfeaEiw7IVEPXIvjDmps2gdm?=
 =?us-ascii?Q?SzNRpudX/DjSSSy84PVDZd7CtsejUAitJ9hjIhj8Q+oSfNe5lCQECi2KNUOK?=
 =?us-ascii?Q?5xNA1KjUxO9OU7XWmJuuL6id6iYQm7XuvOCHuAPntyN5F6US3LpxvTy9RQjR?=
 =?us-ascii?Q?NkfozVv3LX93kDHqO5lpI+FAw20q2aewCbHjgDdzHNG2NWyWKKBXGdZ0Zmeb?=
 =?us-ascii?Q?tC33i60LVAVxYT2ZK+9ZhqrP0ilrEyWC7ihKT9zao8/X0ZLcNYg+6gdte8vd?=
 =?us-ascii?Q?u1ZsCgG5kr9rvpd57ygT7H9OKconVg4xBWtPQzwn1xWKJE17PgEZ7P1pHfpY?=
 =?us-ascii?Q?2EMrYnDa4oIfYZG5JibATfvNcBJvDxB2+0hQ+n6vlDYqgQOcDMgpfCtEXHb1?=
 =?us-ascii?Q?wFqRp1R2ukRGcd7oEbWXN+mMWXlbHijwd6p/gmSYPJY2vv/0KUooq6wTfaBV?=
 =?us-ascii?Q?hH4UQgQf6R0iyWsKeK19rOrLpoMQmdcMdVa/gzZCX4czsC5a03v+/cwLQLic?=
 =?us-ascii?Q?nLxhYx9l9FWYrwMsPmCDR+4ETAoQJwqelOVeDlpMkLihaEgpJu2mZo34P2v4?=
 =?us-ascii?Q?LS5F1GEAr02plCi305y/6yE9+bWcc8uFoSpn1TIHR+yIFKfgTm6X42lP+ERa?=
 =?us-ascii?Q?BfjRD0StF1DBwJzTxQltRmqtG6G1eXhp3GHgm1oQ4sQby0mHU7dOFPLuoYk1?=
 =?us-ascii?Q?hRGAmJ/yDiccaAIrXF1wycxWqSYGlz+Kk36bzPh6Eeiu7WUIPZ3UgBnIy9+T?=
 =?us-ascii?Q?Q7Ag4oFEa8xTXFvZd62Zi0TxTMmLsYradX9SKeJEOY6K5E3El8J+o38Nu/Gw?=
 =?us-ascii?Q?pGVdkDQu8vM7auvj+PVu9ctEmvhqXqdYouvctBAkUWdA6TULK43ifbm5cRVd?=
 =?us-ascii?Q?zJYraEnbG03NU+ZviOpGVt80LxS+8u4AKWOSjTylgkFXHA3UPxHNmDBPEvm5?=
 =?us-ascii?Q?SdlnR1SJW46fZp3SXY/T2dc1lMABkDULrykGqXXTWTYTdesDzoOM3ig/d/x7?=
 =?us-ascii?Q?h4gfc8Q+hid9vw+xO61TMJyfjX+da1o0zE49QTkU5AuYU3VTPMz9aMiIGWIP?=
 =?us-ascii?Q?zrvJYkIM+G5gGPWrD42lvXs72WcEULRYgq+tecJvpcEqzU+vajfpW08mF9zR?=
 =?us-ascii?Q?mtv6Z5Z/34klQ9sSJxa2sVuBzqLsQ3I6PBI4fn2xsOiBABB73DV/PSqtKlwx?=
 =?us-ascii?Q?cDwx+6fUwsS0+SLBPLGcXh6i1wk0NJDeVCWRDP5XYsA4EbXf+Lj+U/0/t3HY?=
 =?us-ascii?Q?vXaaxwHMuj98LDRrALLWuMZVgksiRlnRsgOmHiiyszM+Ah1bjKkecg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mDNh7Hh0SCHNns+4xfWTULwTaRTfeFy1NV4+16TIVynhPhNUPu+6BZ7VwKcK?=
 =?us-ascii?Q?/Y9xQQkAOpwAvDFHacyTQUwFamfNsglQVWb2Ps8uAaWyMU1QRGv0FBxaQcVG?=
 =?us-ascii?Q?Jkn7x2TEBuqrCMacusCVWbaeInrlVY4jVpzLvyDOWeWEbT7HZ/Qi2gcLR7R8?=
 =?us-ascii?Q?eol8PrWBX5XD7HGDlG6nN0WqKQ239S+R/chQ04aVA8Fx6i0R40KsMdA9+U/g?=
 =?us-ascii?Q?4gKSLwGJfBd68/nUsaAWTwynXgMqNxYnYBsui6fNso81ImZPkpMCHf3UvTQg?=
 =?us-ascii?Q?WlmFPgFy1bMo81cUFTfXGEAkzPnWfYiZVDxEcOav5qcGEwq+vIsUuDTVK+ft?=
 =?us-ascii?Q?+D8zDI0tVwKD+yLmkOb62YpHES78Vqt8WQFqetyY/tB3OQAotiv9hSyYfc+H?=
 =?us-ascii?Q?CHYeW5jwN53vRyVLzWFRo2ZmTugHX56e7nwqbko9zGrxf7U0hZkuF4OAvKeP?=
 =?us-ascii?Q?eUcl/F4P5ackC6CD+fXDKdQL8hUyZOVSvz3NKKcJA83zUn7bKlaTYYUg/Lu9?=
 =?us-ascii?Q?Ja7xLqcA4rusrfiR9s/oONJu/hO8U9kJUwTlphkNABlEQ2KwTzgh+MThX8+z?=
 =?us-ascii?Q?SK19Zlk68JiD/GVVu+UiLwyGVBQURTW2bcqM7PCwQJgA7fikJ/nrEdeeWwaK?=
 =?us-ascii?Q?ZDe0goZSyjYajDhXBbxy66yBJpnWfOt1EkdGagYqkgOnAnQxru8L3bmhp2cR?=
 =?us-ascii?Q?cInin/7Uq0KBQGhDS3NLziMb3e7duqzRpLdNfIF4D1/32AJ/5TQ/cq4vUjG5?=
 =?us-ascii?Q?u7cKw7MOPqSRnsB0YUsV25cTQ9sRp+DGwvwBksahQ+8PiDITPB0fHi4VjoQ8?=
 =?us-ascii?Q?ycnch2nYdDAdIM4tXW3wkFa8O9tDfc9/KHvXT0n0/WAHeG59URiLAL+uMuw2?=
 =?us-ascii?Q?cOEDFNHCupUj1zimYPznD9Nl6Lchpe+LZoZT07N/+9ySQluL2GH2VyDcsXW6?=
 =?us-ascii?Q?pdRaW8aH7V2dvJ1FkwB1AJ74tMQtxWbuu3aTkUfeKhC6A5D85/dfmkiFUBgn?=
 =?us-ascii?Q?l4OfcTk4r5PcqCoMBe6if919K7bQ14MSJSDBWICJeAKdGNvium2AUp+MpYGY?=
 =?us-ascii?Q?DhfnjnluNvllf9Umwo4zwcgPeZ3NuBOp0f4b3rKhzQxPPpPmRs27EbM9O9HT?=
 =?us-ascii?Q?DtffqfOEaae0hL9H3u1Jrxu3utFU7K5KD/p5w0a6Ofl0HVPMlMiFUYCZh2au?=
 =?us-ascii?Q?3GT0gaoQmIMc5T5AM9YDifHR0+nbpiOeDHEwejhHKzvAyX0hkwX/XJaqpES9?=
 =?us-ascii?Q?284QazqsdWIMyjsR8N23NOSdX54iX0YUod8Ysyq3OB6tMuYfB+ICMxrE2K2R?=
 =?us-ascii?Q?JOgjubmd8SbDgTplv1Wh4QDTaH26MFAwVO3/xC3OCU4QogPcWumWQ/Pu+8wV?=
 =?us-ascii?Q?gDkx0TRpPL5S4cNNzcWwdpMPHhnO+rpbMHX0r2K5RFsL6uLSX6gSmGqgF1O8?=
 =?us-ascii?Q?ekpY6rvG8wLurX0jCrP/tWrPbJym06vbXl771SxBrUhN4A9wzVj4ZgJkFMY7?=
 =?us-ascii?Q?7bJHvzgcPzH0PO1lPyM8qUrVw+hB2BAyL8e6JHjtr5d/BZw/FdyLYT8Lzx/K?=
 =?us-ascii?Q?zQodtU0dLCyTMErnPT40QzshnkqnzbGMTlAKX32W?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b62455c4-7084-438e-c5be-08dd81fbd4a1
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2025 00:14:36.9081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zs5J2QoBq9vUpIqftLSsWv05xaxmQQ77hlBjRi+OPUSBGQXVOo56HvbZZSMJJTCnL1Q+Z2JBIZPqPEyTtczT7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY1PPFF4FC7B568

A BUG was reported as below when CONFIG_DEBUG_ATOMIC_SLEEP and
try_verify_in_tasklet are enabled.
[  129.444685][  T934] BUG: sleeping function called from invalid context at drivers/md/dm-bufio.c:2421
[  129.444723][  T934] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 934, name: kworker/1:4
[  129.444740][  T934] preempt_count: 201, expected: 0
[  129.444756][  T934] RCU nest depth: 0, expected: 0
[  129.444781][  T934] Preemption disabled at:
[  129.444789][  T934] [<ffffffd816231900>] shrink_work+0x21c/0x248
[  129.445167][  T934] kernel BUG at kernel/sched/walt/walt_debug.c:16!
[  129.445183][  T934] Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
[  129.445204][  T934] Skip md ftrace buffer dump for: 0x1609e0
[  129.447348][  T934] CPU: 1 PID: 934 Comm: kworker/1:4 Tainted: G        W  OE      6.6.56-android15-8-o-g6f82312b30b9-debug #1 1400000003000000474e5500b3187743670464e8
[  129.447362][  T934] Hardware name: Qualcomm Technologies, Inc. Parrot QRD, Alpha-M (DT)
[  129.447373][  T934] Workqueue: dm_bufio_cache shrink_work
[  129.447394][  T934] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  129.447406][  T934] pc : android_rvh_schedule_bug+0x0/0x8 [sched_walt_debug]
[  129.447435][  T934] lr : __traceiter_android_rvh_schedule_bug+0x44/0x6c
[  129.447451][  T934] sp : ffffffc0843dbc90
[  129.447459][  T934] x29: ffffffc0843dbc90 x28: ffffffffffffffff x27: 0000000000000c8b
[  129.447479][  T934] x26: 0000000000000040 x25: ffffff804b3d6260 x24: ffffffd816232b68
[  129.447497][  T934] x23: ffffff805171c5b4 x22: 0000000000000000 x21: ffffffd816231900
[  129.447517][  T934] x20: ffffff80306ba898 x19: 0000000000000000 x18: ffffffc084159030
[  129.447535][  T934] x17: 00000000d2b5dd1f x16: 00000000d2b5dd1f x15: ffffffd816720358
[  129.447554][  T934] x14: 0000000000000004 x13: ffffff89ef978000 x12: 0000000000000003
[  129.447572][  T934] x11: ffffffd817a823c4 x10: 0000000000000202 x9 : 7e779c5735de9400
[  129.447591][  T934] x8 : ffffffd81560d004 x7 : 205b5d3938373434 x6 : ffffffd8167397c8
[  129.447610][  T934] x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffffffc0843db9e0
[  129.447629][  T934] x2 : 0000000000002f15 x1 : 0000000000000000 x0 : 0000000000000000
[  129.447647][  T934] Call trace:
[  129.447655][  T934]  android_rvh_schedule_bug+0x0/0x8 [sched_walt_debug 1400000003000000474e550080cce8a8a78606b6]
[  129.447681][  T934]  __might_resched+0x190/0x1a8
[  129.447694][  T934]  shrink_work+0x180/0x248
[  129.447706][  T934]  process_one_work+0x260/0x624
[  129.447718][  T934]  worker_thread+0x28c/0x454
[  129.447729][  T934]  kthread+0x118/0x158
[  129.447742][  T934]  ret_from_fork+0x10/0x20
[  129.447761][  T934] Code: ???????? ???????? ???????? d2b5dd1f (d4210000)
[  129.447772][  T934] ---[ end trace 0000000000000000 ]---

dm_bufio_lock will call spin_lock_bh when try_verify_in_tasklet
is enabled, and __scan will be called in atomic context.

Fixes: 7cd326747f46 ("dm bufio: remove dm_bufio_cond_resched()")
Signed-off-by: LongPing Wei <weilongping@oppo.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
v4: Fix indent error
v3: Always drops the lock after every 16 iterations and
calls cond_resched() with the lock dropped;
Change the judgment condition to a more understandable way.
v2: When no_sleep is enabled, drops the lock after every 16 iterations and calls
cond_resched() with the lock dropped.
v1: skip cond_resched when no_sleep is enabled
---
 drivers/md/dm-bufio.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 9c8ed65cd87e..f0b5a6931161 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -68,6 +68,8 @@
 #define LIST_DIRTY	1
 #define LIST_SIZE	2
 
+#define SCAN_RESCHED_CYCLE	16
+
 /*--------------------------------------------------------------*/
 
 /*
@@ -2424,7 +2426,12 @@ static void __scan(struct dm_bufio_client *c)
 
 			atomic_long_dec(&c->need_shrink);
 			freed++;
-			cond_resched();
+
+			if (unlikely(freed % SCAN_RESCHED_CYCLE == 0)) {
+				dm_bufio_unlock(c);
+				cond_resched();
+				dm_bufio_lock(c);
+			}
 		}
 	}
 }
-- 
2.34.1

