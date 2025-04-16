Received: from HK3PR03CU002.outbound.protection.outlook.com (mail-eastasiaazon11011027.outbound.protection.outlook.com [52.101.129.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0FE184E
	for <dm-devel@lists.linux.dev>; Wed, 16 Apr 2025 12:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.129.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744808232; cv=fail; b=oFpR0JZb9DPz0FtI5SeXyvgDZSy5+NHaHAgNh01a3o1sEGzj3tG9nkLyEAm6/Oxngyik/JSUgZ5nfTPzO1+SFm48K3dlAHBEEu17Z5Z1XkKcWxzPI8He959b6zfg9bV8e0BCzjGbwyOZswxLJBSBPbYz0QRK6UbdOiKBtwuC4NM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744808232; c=relaxed/simple;
	bh=L3kovuTUzuzr7KBAxWlX6uZ8Hg1kocwgZtyg112JMzc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lx7CdRJcFzjFbw/Uj+MuBoZ3oUGrfoN+7pimIeLqeqS9SW3Plb+MgrsSyJncFcUJFh1oqSlbodrwnCKIvUzL6ks38b74UvyjOfY+J7ABfQ1ASSTGnxS54p0yubt/tdjfPO1ANEUEnQINa/xgfFT5rL3L5+GW96UH7O6n40blWVA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=WW6Bdf1O; arc=fail smtp.client-ip=52.101.129.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="WW6Bdf1O"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hrY2n5bD6mOTc8TWte+XNeQ+ZMICpde9eXJK4a+2Oq5eL5JD7+OORfQZ+jNtZGSB+LQSw2ZgedjP+Yk1klbEZl1+uMYEe6ROLeVUqzpPjY8IC3C4+nHlgxPGlwzsxpCuglKTxsYEUWpZmR1mZEsIf1zsu81vK3XClEEtd5i/1xyxLPUnJczopI2F6DvbAwTlh0Xi+fL+rkLtjqWoVcEJctEG0YPXDGs6fsNty2X+LLR9vsPpvzbdxhkZerQa/VNQfgmMIRXGOW7HEuyDAwDxgPEWZg0I807xw+/zRYVeSrNXqc+0KqfTBtcDYPjEF+ioQe+kNuJLH9vwIKsD9fUMWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k9ow1jCUt0jT7qsdI3DE2BGsgRIVi3BHxXaxUTqmjFg=;
 b=BlGUHmNt4+hLCD2HWvMIHPBYPLlT/SBApSYy6g86Ab3FabvOt3Bovoa85mOHQMkL1CKW5yqiIUTbAGfflvgEAAI2RquqVcbDqwsZ6CNi7TuXzRUWWcEg3qq/lqTg+/9yLPO6j6lddj2Fn5k08Xv2hDgzVDcrcVvr5MXuCsqfotT5EmndJ15cVd9cW8hByERw3o6m+GcpC4/aa9x//sHXUhfolX5pYC877+DhMyruMXX4mOVN7eK8uujodD9OxRioVwn9SxwqKaEbX6KZOCxymgKbWo2axdnoULrd3BeA8/3ZRZFeOaNzlsbN5eAVrMjW71qqGuH/Hik3UUD6m70pIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k9ow1jCUt0jT7qsdI3DE2BGsgRIVi3BHxXaxUTqmjFg=;
 b=WW6Bdf1OzKEuYaJTgPwuC4KrpiZOsDj3glFTaAIMGUWZmJIS1AZ64JV/tBSS/DB5V5V42qi4iaMGp7bPrsK8UajGFzE7/5iCdvWGJQwl76L8Aq+hMzGMz3lZQBcAjwbidNUAyfsnFLgSV0NcnKvI0lwBnNhG9a1KwrscXeWmTLI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by SG2PR02MB5746.apcprd02.prod.outlook.com (2603:1096:4:1ce::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.14; Wed, 16 Apr
 2025 12:57:06 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8655.012; Wed, 16 Apr 2025
 12:57:05 +0000
From: LongPing Wei <weilongping@oppo.com>
To: mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	guoweichao@oppo.com,
	snitzer@kernel.org,
	weilongping@oppo.com,
	stable@vger.kernel.org
Subject: [PATCH v2] dm-bufio: don't schedule in atomic context
Date: Wed, 16 Apr 2025 20:54:37 +0800
Message-Id: <20250416125435.3677117-1-weilongping@oppo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <16733109-69f6-e347-e1af-02af6223ca8d@redhat.com>
References: <16733109-69f6-e347-e1af-02af6223ca8d@redhat.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0018.apcprd04.prod.outlook.com
 (2603:1096:4:197::9) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|SG2PR02MB5746:EE_
X-MS-Office365-Filtering-Correlation-Id: af247b69-9400-48d5-0926-08dd7ce6302a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|1800799024|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?s5L5+ZUQYXLeqGW98fdeYabCxPzEx+qwNAG/dBfKyjNzb/MGQCCgFdXVzpKG?=
 =?us-ascii?Q?7xvGktXTZbTSVC/5+HS07bIJiLbqiDfblY3Eecq+3JfnfxWBoWVyqszThBkA?=
 =?us-ascii?Q?wx0unEiMEaeh2/X2fOKrgz2/2wkVvaftPwyfqFAHz3DpDjxbCRmo0vrbrbo5?=
 =?us-ascii?Q?3iKJLOoH7fvZVh8cI8iKuQOuFxLy0nBHCStu7m/1QJp1pvmPNEWAhxv8vB5w?=
 =?us-ascii?Q?Updb0VQxwSb5NOOMLT9LM1eQXNTRFtJ4vbbDBW0iakyBYPN/M/J3flQ9U6eg?=
 =?us-ascii?Q?mDCnsyzD+TeCXiBzMKnautgK0v3uLAfIW9WwA/rf5dLMMmGPaHOmMTmislcW?=
 =?us-ascii?Q?QXB9+SVSIF7ZJDjwZhhmLokW2W0G8VpnP5F465e+nABKt5+QTVwS/dLRY1gK?=
 =?us-ascii?Q?1tgmu1k5KJ7Vx4kn4qzuxI7qG7I09TlFic+rh/QQlO9jozUJwzZalYBIVCA+?=
 =?us-ascii?Q?0AIqtOjm1c1ioo/9m6+DWmDpvYCCsK1KxQzWDLHSOYiSXYgC/c0bWm0GtBGt?=
 =?us-ascii?Q?A8rB1fpIlxyklj4a851HXVa3I4SNv21CsmKq8Z8G2fCxVgdicxqREJtzHxNC?=
 =?us-ascii?Q?l6WgGk/csSOv1ExZfP/N2tcXMBKMpfAlU3qIh2shCyvE2L++HwAMJPfyS7zV?=
 =?us-ascii?Q?uyGO4XOsZPtCp5XFLV85gdEciSnrrJZ5HDegOA8TCQBjivuXffHWUhr2QTJJ?=
 =?us-ascii?Q?Yptmk5lR7d5Me1pOhG+vEqItf0AFXwWTOaRJ3HA7KBUB8fTD9Lojy7cDXYeL?=
 =?us-ascii?Q?lOKZfwUKmwBsOWL/cimKFQqJ6erIVCeJLpklhg+d62DnsCk2sFuvqXu8vuSA?=
 =?us-ascii?Q?xe+Bw+AV/bJJ0PxuwLQnX6doSK0yloOMkKDiw543y5t0KiDf50Bqmh92y1MJ?=
 =?us-ascii?Q?S3JEsnV2c4A0tR4S+nWWFEUmzD8GE2hsZU89mLhLq5NwBRaH3pCLgJh5iaNe?=
 =?us-ascii?Q?Nqhf1YxkxPEDv9lRxrMvvlHgNyENiB6zrVuS4VXP46fb//5S0J+My4z8Ao4F?=
 =?us-ascii?Q?SPjuQ9yunSZbPWwX3seOqgSlboIEG+WoFQcfFD0yAgAakWE47fdGvFlBGNNR?=
 =?us-ascii?Q?6lE8iuRya0nD0LcgE4oREoF0nLMoJeZjkNLwnCut1Vo0D1vSrgGRQI0EaHpO?=
 =?us-ascii?Q?hiN/BHzzfQUHA/YdlFYgScJ4xa3haGujSQGTt3W/ANCJZEnzfXt6EEhPIQ9I?=
 =?us-ascii?Q?ysZmeBnSDZp3KHZm4Mk0s60Yn3Lb9glCyf+EFtf7d+PhvO1HVqW/rauhSW4k?=
 =?us-ascii?Q?eo2SfnYTM7UEOcG8YmbOXkURPrX8LQ5MDrPxH+VGBqMrkKNqZZdx+VlPMYAI?=
 =?us-ascii?Q?oZe47GwkwBCky+YxXwtQHdlDTmxMDqX7BiPF8qlAeVhIndVzNqoweuEUQ78D?=
 =?us-ascii?Q?r4aLpOLdjV8gvXMLskWuJ3S0gcMhpuREMqwzdho3mfgYyu6w5/qdy3U3TH5x?=
 =?us-ascii?Q?2lO2hpoU5vrJ9lG3CTgXAjfwZGQ2uBdSwj/re7iZtrbjL/kyBjJxXQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(1800799024)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1P3jm+EJJK25XkDzmBoNycspayT0jOwK8e1Qkw3yg5CMdp62BfCNghv4p5ux?=
 =?us-ascii?Q?hEBbTUsokBM3b8eHuDjMFOqZwOZaKel/xxUQeO5ldvoVgX4+6Cz2i9dqkdX3?=
 =?us-ascii?Q?LEVeQOBspRaZnKTjrqUknleuIS8fDxRxUoWgk6UZJwpE6CddFlYjjv4CVY0R?=
 =?us-ascii?Q?6TRJD79K3rbuQs3YlO1x0XPlf7ZgYfsqzRCXGVA3gnTkDClXE8vysMDmbBKS?=
 =?us-ascii?Q?Yfy74zuHQgPE89q5sL5cQkw07u3UnL/8JQ7YgitpmKCvYZ+XR2a+MkYudAoL?=
 =?us-ascii?Q?BrTeoQ4Kn7KfRsyZY/jlhuFwnOkb03BNT/1tqn9znsbpti8gliHV6OrEW2ZN?=
 =?us-ascii?Q?FHKsrJQxxBmltZDBnGXo7KwXd30qQR8EPg9TQCancpav/y4X2uIqmzr9R1IA?=
 =?us-ascii?Q?Itd1RW7sbYx14rWfakjtWuBfZmX4JUw1Bq7Ni2QhZTMjB9VpRsGk7ontF/Hk?=
 =?us-ascii?Q?mU7pcADqUuHX50qrLPKueux/TovErZLUOKd6xViCCQOIL/q79A4dFtioBSjo?=
 =?us-ascii?Q?wr95w3cFYdz1FkmFawWkCrWQkkesIyufckZqpZ+mOvW9NYLc4zLFNimbNVeF?=
 =?us-ascii?Q?I5lG9tx/AJgVHWmW0t+0q9RpGFpPkF6Bcf+E4fBEB67sAFdz7OUNEA8INst6?=
 =?us-ascii?Q?5ev+v0YYfG9XkylmX2RIjIVtEZoIIyXKPqtgIMAoBZlgXDx+jDNL9balDOZt?=
 =?us-ascii?Q?Fi+zYd43IHwetFJLpyKWgDGRtHX18vyehrqhUVJ/mxRPzZ3COVao8XUvRbn8?=
 =?us-ascii?Q?iEokJqYyqLNvWCbJ04CFEj4LOT9bNisRbmx7zfdKtcz9dya+xY0grpVipJlM?=
 =?us-ascii?Q?zT0kmEskF+9nxH0z4eMH1Zwu2EQYozfKwUnGwMstJvkQcqL0OPJqDoHjTdfl?=
 =?us-ascii?Q?/Qd1qVslPfp805G9eS3v4dQDNcIb2jdI05AdhqwkF0qWd9HWvxocb95O4dys?=
 =?us-ascii?Q?6oQp5rPA/KUXMAou8AWOGTa4GgZIjLwLrrCiUadZXzf0nNEW98nOyVy3vhke?=
 =?us-ascii?Q?JVuGr7RjUqq5CCqaGGVu9RxHWxkmhuv/Mr/1KbpgvcXQJiK9fPlviEO2XTZx?=
 =?us-ascii?Q?4CCgxGTO9udGZXegs0CA6Xo2rIz9ij11X4BakRgsBCWdNOq5qaS6dxzCcAAf?=
 =?us-ascii?Q?blt1XbyHLil5y6LsYYWsJfrpg81zupwhvEen6YelxB98tR3mO1eTwrL/ZDCM?=
 =?us-ascii?Q?D4za1kLluDvTH0VM8rOC/ITV+JJadbC45HOVf2gbEPk+vQ40kZWl+Ct/q4PX?=
 =?us-ascii?Q?xgBs3ONau1t71MJFGIZ4X9NkXNW/1771VrqR2qJLJVBbaWFe87wwTuPpU7ke?=
 =?us-ascii?Q?RBqqpi9B219K7nUIQfvp7LzwEeLFLFQAyUnD43v6lEyOC4sM4NdPNQSJ5j1E?=
 =?us-ascii?Q?AGnBnRy6lqayniAh12WJYpOdYTGgNDy3RRLBCCUGaf2AWgzlpyBWQs0ZoWeX?=
 =?us-ascii?Q?/tTxTZr511IMFZu5IaKuRKeHVbJftwOg2tuVmqJygeCFWYDk5bPMWr1cmdWD?=
 =?us-ascii?Q?z6r5vY00SyLIze+BzZsr+k7mW6NG+u2atcsHsIQJjhbYxtdONOYaqYOKtpFG?=
 =?us-ascii?Q?9GSkHUzFbHjjMV6GcdesFcgl4BbS1IbhEsgiAO4I?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af247b69-9400-48d5-0926-08dd7ce6302a
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2025 12:57:05.1773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ILNHze6yyv0ZlqQJCMHJ+IDFcQEbOcOo+tCvPWUbrv+I7DIRWSaiMKxIUa4vHscj1aEz8px8kouilvpt69TZag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR02MB5746

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
---
v2: When no_sleep is enabled, drops the lock after every 16 iterations and calls
cond_resched() with the lock dropped.
---
 drivers/md/dm-bufio.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 9c8ed65cd87e..e82e85591499 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -2424,7 +2424,15 @@ static void __scan(struct dm_bufio_client *c)
 
 			atomic_long_dec(&c->need_shrink);
 			freed++;
-			cond_resched();
+
+			if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep) {
+				if (!(freed & 15)) {
+					dm_bufio_unlock(c);
+					cond_resched();
+					dm_bufio_lock(c);
+				}
+			} else
+				cond_resched();
 		}
 	}
 }
-- 
2.34.1

