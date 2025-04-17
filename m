Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013041.outbound.protection.outlook.com [40.107.44.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D493135A53
	for <dm-devel@lists.linux.dev>; Thu, 17 Apr 2025 03:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744859319; cv=fail; b=FeGPDS2cJLQe4YOpDG3Z3vkEBuJF/Ass0dYJ+NZU9pQL9fBVP0zUOF9xlvg8I/tHg4FpHXD718EMsIYveQRlmlig+SiW5uhsHKZ7VkKfjSkFylhYGbSTff4aJzP+Vbk/tjRevLoY47bmF/NpzdxbQZinHTcR9n5nawSQXDOqBQk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744859319; c=relaxed/simple;
	bh=UXvqATvjfMNVo3eFQyyeeJq7RULKL1Tx14JD9EaxL5s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=D3he5FgsZejfH0aGzAnLrguSZ6FjbEFaZVmBBctgxJ9stFeYLO+e+m+7/lMPIk/GGL3hL9ufYLznUfpbRneUPRy8onQnuy3c9YHQzDVoAob433pfnHMRfuJr3Y+jr1OIp1fUdSZU4HutdSw+FUo8yoS2IpB2FGZuyLXQZhgwOm0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=q5Fko9T+; arc=fail smtp.client-ip=40.107.44.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="q5Fko9T+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K6V5dKe4uIB1zPYDYl2qzly+Vl+O5UNF7DAZ6czmAfjMm/rVJzFUq8onMSAhPHjCJ1evFEfyXpl1LYpdqHRe00cBSg0END1b8sOZsKLXYiPkvoa6L4qS5X5KC6uaBpnG8ePw6BFxHDmNZQKiKd8FN4keGXIAiGnafpVUDxV32lCnIE7de1HUjDLbnMlEvzNImZZJOJJ1ykvet3Xgrk4GxJT6Yyw5fyTQMW7m4E/+bYGT/vnPutE16IpVReTSVO3HbjQD2K9T3Luq1ThKOczzmbMkt7XF6xaRXywY2dg07EaQ/evCWNdoXjBAq/N7bk2WneAr2i8ACNzApck2rm9hcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wX50mcunxZGEN36FIsN2RXo8U51g83OHSfzpz1JGdrI=;
 b=qkNFzm7GP63ZZVM/4yDzuplTEArKiyb5ppkclC/VJsKEX2AiypOuS365JEzPzwaD0vVcmWt7e4dW8E/xT15MH/v3fij0SSQ6nnSyCHB20Ssw8W1nOagBKD83+3nwcOdjZUEwYa0/R+mGIgXR5woMIFS2GZUcCu5LxjCdsWk+J2hlRqTBo7i4c3dJfdieRmFGjpyH69uJfvJMJNXs9R5CZTBmiqPvCSQe11fgknvIRM91nGG+qsY0Pdt6EShOT9lTkbUj+j7jF8jICnHiq/yNwd9DNnMw9gS9i7u6te3ZPoUWXLH1LULzcM4MeAR1kzZ5knPJRFkFUaN1Vvk3C5TGVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wX50mcunxZGEN36FIsN2RXo8U51g83OHSfzpz1JGdrI=;
 b=q5Fko9T+Lixu9cdBI7jpGjpK4DVCXs8oTg7NBurfrdZg2yRyi84PV+T3Lcb8i67+ebiJUTPZZhzgRAB9Oi1XaSwetjJlenWn+/kLzWijLSM8SFUDd+bacVoldqEb5zpQNES3yqGwifTygBOG1S75AoDChafdBDYRltUDbHnkE1w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by TYSPR02MB7241.apcprd02.prod.outlook.com (2603:1096:400:467::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.16; Thu, 17 Apr
 2025 03:08:32 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%5]) with mapi id 15.20.8655.012; Thu, 17 Apr 2025
 03:08:30 +0000
From: LongPing Wei <weilongping@oppo.com>
To: mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	guoweichao@oppo.com,
	snitzer@kernel.org,
	weilongping@oppo.com,
	stable@vger.kernel.org
Subject: [PATCH v3] dm-bufio: don't schedule in atomic context
Date: Thu, 17 Apr 2025 11:07:38 +0800
Message-Id: <20250417030737.3683876-1-weilongping@oppo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <16733109-69f6-e347-e1af-02af6223ca8d@redhat.com>
References: <16733109-69f6-e347-e1af-02af6223ca8d@redhat.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0015.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::18) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|TYSPR02MB7241:EE_
X-MS-Office365-Filtering-Correlation-Id: cac50ed5-5bc6-4724-d53e-08dd7d5d214a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|52116014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cd13sfO3rGmEkK+mSm4FmD42BOCnkEZ0RVtPpzNRyc6XOSAxQRcP/mJ3DAqv?=
 =?us-ascii?Q?uoO5tyrACvExXbpfwod0kzFuBl2eveULjmbHIqjzLqMIl3kNP7tVrVQgc+WF?=
 =?us-ascii?Q?0XXN/4ystJlNzUVWUOdCMP0Vk/fLy/zyYaQ3IevP32SgcoV6YXANAgl13ZAO?=
 =?us-ascii?Q?EnV18RSFUeqLjZq8OvOAD5oO+oEuHbn3mycYVQ7evCBB7UkPysQz/8aS+yYL?=
 =?us-ascii?Q?2ZjegGJwqpDqIY0U4X1hDC4q57LjGJC/WWGw/hmjIeetT/fiDfcQOSNXTwEs?=
 =?us-ascii?Q?mu8eCiELQit1w0mK5JFi6YziXakNK+xbIgAGzLnlkzd73Fq8LfQvw1NpbZyI?=
 =?us-ascii?Q?gipSuyKDaj4+G7L7gB/n/UgVAmjjyqYqrsLsjwIaKakfU0VD2OaQ0YLNDynX?=
 =?us-ascii?Q?ZzUdHystzNLSA6zR3WErJz1cwZv6MIO8gzi4RiE9j80V2U47W7G5//nGcpvS?=
 =?us-ascii?Q?SnWwF5Df6xsqwiRvjUyjF0OkigzJvBx+jnH1mG8uN64qMe74A/HjJRIGu5wg?=
 =?us-ascii?Q?2qoRDkojANm1mDCAbDM5tudtub6LQObpbWqe1tprcptxznz/Su6wV1Ne0GK+?=
 =?us-ascii?Q?xOGjOaPkat6AeBxYCwaCkoyvkBofmYVBlxEPAHwm2BPTtMyKXAdPO8VyBi1k?=
 =?us-ascii?Q?sIkmSMzz4iBaiqslLkn7r2s7mch2EB5nk40pS3468zbALfhqRgBQ0neR4zGc?=
 =?us-ascii?Q?ssw4fJo6geo1b62hrjz3xbiKRtTpEiRxL/InLkzhHTVfA/JjrM2ZK8duxWYu?=
 =?us-ascii?Q?TkhzO6EQhR5UWSAZrxj4FTmn9JLvebGla8RT4hTh65oqzQCp4nfmvCCaP7y1?=
 =?us-ascii?Q?AAJ8MPkuuyDk2CBJ1gFv6XS3LiqVGtSEMyh5gyCzLWHPxxtEnrAXrdzs8xxP?=
 =?us-ascii?Q?U/Z9tY1b2lOce/RcPBT8tnNLAMSAYw0956cQVlClDXSOaiQdp/O8gmM0TcuL?=
 =?us-ascii?Q?sNuhRGuZy5qYCr34WcakIt9PomLBc5G3x5jbuujguGKM/2OOEAFrVbYe8hoq?=
 =?us-ascii?Q?uM09+b/+BWu7IVkGd+owitPSz+Hi+2iHWLOaC0IPO6AtckTRrNe69oGR5L/n?=
 =?us-ascii?Q?jKUbs6mqB4FZNmV4HFkUjE8GdI+/8Ecgcz66FszQZxpO7Q4PHktTIT412NLI?=
 =?us-ascii?Q?PmsVkBnZ/qCIhRb/4QxR7KQgMK2j4HcL2ofDkX5inSC4dJRUjnqtEs+POOTR?=
 =?us-ascii?Q?ZMbfuiohIsjtwXznEvIhoa/eti5n61GTzbF0pf5YcCJU9QZBpy5n4QIkmvvt?=
 =?us-ascii?Q?ThkAQZ2vSJ7UspvSjCaEDbG9QekdeUDCpCRNppmgMirxL9Sux8Lt8GfKYcma?=
 =?us-ascii?Q?JA3smE8HtSVySMOu2AgiYXx95/5bJ5OyKPvED79+gEsrCUilsQuBpEwsA3BO?=
 =?us-ascii?Q?EqCQvUPRXMdrFm/UWrXCemGbkX+kjkyXfL1t/ihLTOQdYDqZRvtres8TOfZE?=
 =?us-ascii?Q?q3dOCZKtAxiEdQKATpOGmanTujUzCDB0APYlLKcbtiqc1wVxIX1ACA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(52116014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GnSo2HirocDQy4dskamGdVd5psTozYbTVkXSDk5KeX2JKb4KSG+cdUV95VHR?=
 =?us-ascii?Q?b9GsHpCnjkNxDS0yuG7aQt+Tg+4Flwf2TNVEjZX3LbvOPTy7WeQG+LfbZrYc?=
 =?us-ascii?Q?v2z6S3WBsKlkybG7+BUH5wUuhnrNgUjSb0W95ZDy4eRqAbTgcvz97PYBIS3f?=
 =?us-ascii?Q?KiEmcequ4OVN9Hlp5136XP/3Kbj860vBUS1CzjxX/0rxJcHG2EvJSQ1u45qT?=
 =?us-ascii?Q?pCyCnxiWnu+NsgP7GSL2q3EeyJP3ov21C/Z4RqH/RLjLgko2XqduiXxy77fq?=
 =?us-ascii?Q?ny/Slp4E9O7NDq7kUgpkWQASxHz+ZGgoC4ifQu9NhT7NsqvKOHUKhDczlP+j?=
 =?us-ascii?Q?+mttnuc1kLXoNrQHPN9HJtBzDL0FcsLngUMhu5sCB+jZVP0JjbIOQbKjkV9b?=
 =?us-ascii?Q?Avu//seigAliX4URaEJP6+zfueKIt/09sL9LkFuU5CrqTyv5ZYuLaCuQykV2?=
 =?us-ascii?Q?bn+RZbGgFgaym8TVydhheq4GvD+pMd41RwoYpPw40SpzVYwnV0MH1Ww73OHw?=
 =?us-ascii?Q?1dos7KWcBWMGjCFPdggx7d7ANcR8CQTkDR+J0UiyYYHVuzQK5SaH41PawCmP?=
 =?us-ascii?Q?bRPfiQ9oZuQ1URfycjY4yexzBm6e3ViLPQrdavJHsF4ak3odlBCQgK5Y5TDI?=
 =?us-ascii?Q?764jKgqkWl9QYKqmFbMEK1gA5NV3dWuuU2kxnpDESLl2QSveM1+6epUyFbva?=
 =?us-ascii?Q?+dRtFh3W95pRSdWoP+ffuItL+gjA+rts7EcCIJc8WHgwKqe1MxX6Jlfh5WMu?=
 =?us-ascii?Q?AzFarEuuiwEHHfI+dsUGeVIzpMv7YEA6R9+x7c5TZZmFgy0srEIWnKb0NkWL?=
 =?us-ascii?Q?+9erJtOfBhcVGASWFwL0a4SIyXItT4kLHROjYaDCc/udvuXQbLBggIQMJDv8?=
 =?us-ascii?Q?4guCFlZJ98nUAnhIeAriJv4Lq9y0wUTdLTPjYf22xJzcYfNMrz9COban2YQC?=
 =?us-ascii?Q?2qD1PejA4ygFh/uHshoPQWCrpsabfwKTDHOh/abuDcglcjq/hE8rIxI2E06x?=
 =?us-ascii?Q?+xgmI+7+3Fjszm+Xj5RHt9YAwdRb8N+7hIEPukvif5QR+lKowVUMLfpL1HG+?=
 =?us-ascii?Q?yziezonmj6jjPbSLZMi3PNc0/uRaFJeW/q4hsS9Dbm+3ledx9HZmsOLMYuSN?=
 =?us-ascii?Q?GWwPAEroEPN+KC2iuQN5BjqDo6sDVrCq09+7nZOU1MC5OgyW9r1VTQXd1Jzq?=
 =?us-ascii?Q?NI4qiCVaM4CRaiupbEeGFuI4z7ynW/dncuiufxYCfhTh4G9nra4o9XPmv/lg?=
 =?us-ascii?Q?NVNH8cjxylrq+nmxQ/uBy5vFMdrOqzlVld6uhfi28N3HnM2WkGYvcXEO6+nD?=
 =?us-ascii?Q?DamUnxp3WOfbXGzH4YYKPBtJh4CQYgUgIN9/MRvk36CcFYVLlq3Oau0bpwBz?=
 =?us-ascii?Q?/qF2w9K5RQe0qPpQuiI8GemZn9P0spl8xhLDj9TSibup/MqHfdQU46g88KkT?=
 =?us-ascii?Q?V3pznpIODtQa8a0kZQ49LTHcqHKWqiLqxeoSA4UeRYHkmXan9pk5pZZPg+hv?=
 =?us-ascii?Q?hBaNMivWFntDrUr3fu/NpDmmp2W2RAIeOy6raJaygBxk2OX5Im50kWIbFdcx?=
 =?us-ascii?Q?MdD2DQpsCcYGzjgZnW+DH1XaDnmYoCnCymSJmazY?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cac50ed5-5bc6-4724-d53e-08dd7d5d214a
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 03:08:30.4105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 09Yt/1Gr+vo8RmMLHkviY2MWmBfpWUrPZgZF8uJWJC4X+a1CSuRNs7axEx8pjxy9Gd/P3jk5g7mVXustPbdUSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR02MB7241

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
v3: Always drops the lock after every 16 iterations and
calls cond_resched() with the lock dropped;
Change the judgment condition to a more understandable way.
v2: When no_sleep is enabled, drops the lock after every 16 iterations and calls
cond_resched() with the lock dropped.
v1: skip cond_resched when no_sleep is enabled
---
 drivers/md/dm-bufio.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 9c8ed65cd87e..3088f9f9169a 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -68,6 +68,8 @@
 #define LIST_DIRTY	1
 #define LIST_SIZE	2
 
+#define SCAN_RESCHED_CYCLE	16
+
 /*--------------------------------------------------------------*/
 
 /*
@@ -2424,8 +2426,13 @@ static void __scan(struct dm_bufio_client *c)
 
 			atomic_long_dec(&c->need_shrink);
 			freed++;
-			cond_resched();
-		}
+
+			if (unlikely(freed % SCAN_RESCHED_CYCLE == 0)) {
+				dm_bufio_unlock(c);
+				cond_resched();
+				dm_bufio_lock(c);
+			}
+	}
 	}
 }
 
-- 
2.34.1

