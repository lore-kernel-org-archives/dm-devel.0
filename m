Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sg2apc01on2050.outbound.protection.outlook.com [40.107.215.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E01720ADE9
	for <dm-devel@lists.linux.dev>; Wed, 16 Apr 2025 09:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744796760; cv=fail; b=Ognl8xF7MkE6eoZMJvqRnRmq88y89bDgye83icBNwWBASSwLID0zNMCEBsbeU5+mDHk7ZMWWTjgTBMe6406pjWvFqIeOYufDAvjNNeAkCdn23m7PPGmmt4NeQvl5eogaEyxswXv/3wiKRBUvnPOgT8PtfCQ5lsEoWAUFh9K/COs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744796760; c=relaxed/simple;
	bh=n6HvBvACQZm6SYOkFzzC5WDKA+FgUi5anLw+dfN1kr4=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=cNOFy9ufEY8Q5DpdPHMtl1qzpoFAphyBSxKv1H7VNTvIIoRk/UpW2K02QZCEhybNTk272CMHfvBuO3GprkQpMVGQtL32N+/b6gv75gy0/2DEORQtffHV+D+zALHrEmqIOc1NXqKP1M9GGumrxUaZxlfCQfcJ+8mx+vVeRyj/gzs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=HGrXqUlk; arc=fail smtp.client-ip=40.107.215.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="HGrXqUlk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M1UDYZq3C0PgShYDL7Y6aKQd/8ZAh/hhMgvkVapxwL1bCNY364oXzxg8z6xkzcF0fP/HPSp0MaMJfeL26gWZvJPxLVjytouU9sdAjrNnvicxFLSw8iUk8qWxCiro+Hmplx4TUajjXavttpXhHfDsdWtKqj9IypDJRVfjJMjEq/guAbJtzAoSIp6106LE8BgF1w2zwZnho4oNwpqE3BZX0fiUdr+3z0Ct8ZPBR8+YRzdaDpFEEhoUnnS1qLqjvUfkSx4ZBJF7nnruMUifXlYBvzKrXJ9L0U4TEwmo6IiyqEQcQvv13r8HvhN4CDCManohqKu/vYvTL3/haCqwknFrNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nJGDijpK9LUsO1kap2Z8gN1o0P2OFCu4kMSkCOhLMJw=;
 b=qGpT8pDPTmtrAJjt5KkXmI5Ws6DW+/CjXPnN3mtu76R2FChs2mqe/L3uxrrWBT2NW0zfv8E4ijK9zn6Vt6UGY8Qs7IVUBonibJ+46twYtbqNPlEqZ1+PhgMKfPdVrysO6ie+3D/OZ+tyB6xWwNZr0aVIowWQefrajnZaVss3wANw9Gihq/zA5vdK+gTJ6qiFZmU10QNwjj+inM4a5YvuKG1+lRrclYyeqoGhavEJ1j98zrcj2MyUvsGH6doP/MdjHpGZsjlC3ECHtMudefE55tOAMR6FzYrzhJBLoqmkTa1IqbH+MTEwYwWIJ84PFg8I2gxbxDKxg6PUMe0oQYqeXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nJGDijpK9LUsO1kap2Z8gN1o0P2OFCu4kMSkCOhLMJw=;
 b=HGrXqUlkQFCKqDPc3vdsj9f+o9V4bBvCRy0+/kL0nwyjU9dil1Xu68lZIaIShChc3VubB4HKJT1gpaGo6X3dPyWAAMG5n36AxrbhjWvKe25hYga5gpL8uwUDYgMGk4rSqKaj3QbkjO11q2+1WH3eJgUz5gG1u/FytEg1nXOFNXc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from TYSPR02MB7970.apcprd02.prod.outlook.com (2603:1096:405:91::6)
 by SEYPR02MB5631.apcprd02.prod.outlook.com (2603:1096:101:58::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.16; Wed, 16 Apr
 2025 09:45:51 +0000
Received: from TYSPR02MB7970.apcprd02.prod.outlook.com
 ([fe80::e36:2f4b:2770:2106]) by TYSPR02MB7970.apcprd02.prod.outlook.com
 ([fe80::e36:2f4b:2770:2106%3]) with mapi id 15.20.8655.018; Wed, 16 Apr 2025
 09:45:48 +0000
From: LongPing Wei <weilongping@oppo.com>
To: snitzer@kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	guoweichao@oppo.com,
	LongPing Wei <weilongping@oppo.com>
Subject: [PATCH] dm-bufio: skip cond_resched when no_sleep is enabled
Date: Wed, 16 Apr 2025 17:45:13 +0800
Message-Id: <20250416094512.3561667-1-weilongping@oppo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0125.jpnprd01.prod.outlook.com
 (2603:1096:400:26d::7) To TYSPR02MB7970.apcprd02.prod.outlook.com
 (2603:1096:405:91::6)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYSPR02MB7970:EE_|SEYPR02MB5631:EE_
X-MS-Office365-Filtering-Correlation-Id: 83679767-5873-4c86-c1ab-08dd7ccb77c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|366016|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pRqrH3BWcCxOaAWg7eU64nbaLc5HVIafvPaBG4Y19gfMkZSVa/Qm/ni31ZCV?=
 =?us-ascii?Q?gtNIb6oHPM4OGJ64XrW12iqMlf9ie+uO1/Tt9GGsk4StMDiVR4SBcrV5zhP6?=
 =?us-ascii?Q?IjS8xgtmoURJDjqiGBCkRhwBSVOyO00ZQqFP1Jtfr1kPVPxpcrRXLCAnpm24?=
 =?us-ascii?Q?DTeQv1SuDpHnQmnrh0szJHK/AXndc5MFk/1nAz0x70KH6JBkIHwSWW2u0N5K?=
 =?us-ascii?Q?HwUgP/rjy2Pvfny6DWMgxh7N/lqvNLeS8Ub+uEX3om2U8zTEh6VjYzZxYSml?=
 =?us-ascii?Q?eSAqTSRH7LGu0wGzvxYXr2T1Nlg9Oc0KgyOWdo21c0i5rwMUI/MT6Q5fHvr8?=
 =?us-ascii?Q?dooO96EiYf56tzDBlPnuqhkP2ty1ufVmsQRkzGQwXG5XKc8jQwcz9AyP8crE?=
 =?us-ascii?Q?B0ztGtJNzNR6zNmTaWsTEb3upR0gr1W0l1gj9YNUG44GYHcif/Q4cV27BhwE?=
 =?us-ascii?Q?cuyfUW6j6341IB2uXB6jji532O8d2dR1xkJQOFwK6jNbT0LoakbKHz7Arz9l?=
 =?us-ascii?Q?zULtYiAlPL+lSJQC3flIzsl4QM1yOBQ0e4tRIemsVrSgE9hk7JgZ86WRyXWi?=
 =?us-ascii?Q?C4tQcZkIt4/hbPG54NvP3UFZT8+xsmX2IiCTxyilgs21y5AG6qlx5aKRCq2t?=
 =?us-ascii?Q?lMXyZNwatTD+BdIWA3m9WBb4pjkaNYUY1JOVa5fmlvytY6M64uccqP05KAtZ?=
 =?us-ascii?Q?UBgsd0mAeNzCaiyjLC1H0/FtAARfB/CU4VwbT4Iptb6lBVfnkXOMytd3TVwt?=
 =?us-ascii?Q?VG8o4goxMT+J/MqC0Wsvin+KUryoKYMvUEfyFxgqnOYvxx/eRUtBfsuhp+mK?=
 =?us-ascii?Q?S4cdbGvwtGPsQz+PIYGfXDL4FoPRZwCTWMVayf06w4no9tBKuC/RjbV//33/?=
 =?us-ascii?Q?fFCBlKj9PHXLkfNXHONOGGEd/VxHp9EDH2Q5tXUAl3A7CjFVgI5+MoAaIHPe?=
 =?us-ascii?Q?S4xrlse0xaudfQB4eCGSHJh5nvLdjEdyG3//vjjujSXfP2bwu3hF8bvuztAm?=
 =?us-ascii?Q?8norDF5SRJmgrkiQBeo8W3sffToYaTat+QWLaFGiiPpoliIm+Z2wHY+HvdOO?=
 =?us-ascii?Q?XB/M5LIpMMUJHVwRwV5vh71gIn94FdxkCjNdvsYH7HzZvTrqi0TnmnLBEWVp?=
 =?us-ascii?Q?AsUDVRzm8GPgLY4hvbNujXScc1BAngzhEWxdXNyqT5H65yoJ0BnKweC51AAq?=
 =?us-ascii?Q?tmrPg7n0iO8ED/WDmZBBtJASb8PPVx5moJiLmZDAFTOG1RcN906L2vWnIwtO?=
 =?us-ascii?Q?2wFQfwcNfCdGKLNdK9LOFv+OiQj9njdW3SCA4/QMxfyFcuU37n9ymhJ21ofW?=
 =?us-ascii?Q?WZ0MwdW/D1Nx9Cl/Qr8jYWZ2fYub426AlES9FJm50x/IghmnSbBiTIhyysdV?=
 =?us-ascii?Q?8UnxfXDpxeck+OmC5hb7i13l2JZ/vIVfrNNDxQzbugjZghDyW9L/Cf0RNpiE?=
 =?us-ascii?Q?ODcLnKzI6epeg38siqcERrCUMioStWDaGziuv6U3OxFbz0+76SZGDg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR02MB7970.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(366016)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aY56ijU2wYuETPhjdaXIYStThRUdL+Erqp8A9GLfihjWeeB803y0cRD6KhVN?=
 =?us-ascii?Q?wHUWVLCJb+OnqTPO6N3pgPk48qvx4DlGsxvrG7PKdqNjpmXFlfcTta8BsQvu?=
 =?us-ascii?Q?6CFUd0NVt000aHhIvvm0GgsWIkR37EJkQmNeZzNKts6nUDw0Jey1bLGAk3jo?=
 =?us-ascii?Q?EdSEiDafzWPbd1lymr4S7WnMazoHWTFkBMagKdDM9qe6h1itjZ0VNmBA0xW6?=
 =?us-ascii?Q?i+itogL1BVuM80XWYymcD7KNaGDk1JvCGCWnzMRnZ5kAlCR/WWNI3d6gGL0L?=
 =?us-ascii?Q?/7C4mMvY94a6Fxn/PcsFM6nAFPDdToGWJUgh8C1BqEiUbgHkWHSejjKAT9vP?=
 =?us-ascii?Q?EDRmNH98c+D8u7dXGLHok210/59KxR2vVGpxpbRzkeH6p5j/5kmztgsdi2ii?=
 =?us-ascii?Q?ueOSfYa7Re4+Xp8mXxHIsGcwAofYlfKD8f2AmZOP0W+9sG1ZqegqE5uJO6uU?=
 =?us-ascii?Q?tioY/FNPxHt2W9n0e2VB3ddUI+15xJ2N9Fhfio42I7ue8W0p7qsLOTh2vPBX?=
 =?us-ascii?Q?W2KDDnEBntV3dLrv4dgdbKQMin0LJjcPvXfNp5XXUQsb/rUsQS2b4CFi/oe8?=
 =?us-ascii?Q?fM6ZGSuQMPgwoQlhoiX5VOtbso3NSl9wbkVWeD5C2cXCsdKXrG7gjRnWwqUa?=
 =?us-ascii?Q?h4T/JC7cXJWEmsC3auSU33f3ro5D8TMlqttWJV6wg1a0g3Rlfh5XU41ca43K?=
 =?us-ascii?Q?c535cqxTFdBqnrcYTqibqeKhg1yNIyYYSdOugPXoIaKRBUoC5Y2rMuWGKHQX?=
 =?us-ascii?Q?bjTCrFLbPkoU0uAM3r0WnLQF4LgtoYjYtpoz1REwx4csYncm/My7NkcQNnBM?=
 =?us-ascii?Q?uvnaUmZyash6BbqWfQGgyTaEhDhhZA4Neh5eukbGeYkXnUBxfaKoaY6u0AT7?=
 =?us-ascii?Q?870CXFLOLfaw14QRvc5I8cLGjLFQdDQQ721wHF0IfHwGh7/OQ29kNraFWhhD?=
 =?us-ascii?Q?Gfc5RRh2qc0wIQzs+S8r6Mxj5iIW1fIYpXXId3RnipzQppBgr2wH3dhjT0aQ?=
 =?us-ascii?Q?WmdvvSbnhsoP7zfb5IOJFhvzWlQNGZPbIVsxWRVhakQj5hPVyBMkqig+kPTy?=
 =?us-ascii?Q?3AZDWg7/zqSYlEcd6K2Ht4lrRZ7vC6E8zgJGV4mG1M6QlgBUwQ8i7nM7fzji?=
 =?us-ascii?Q?qskBY2uwtooMqIQogRvzdTydrYpDUwM1Jt6sX2e4l/4404mbXadNoiyI5Mpn?=
 =?us-ascii?Q?LecaIJ32KItonaMWKoUv+/bEuRwztXA3NxKprPMIygVaoG59jf0smhhQQXzH?=
 =?us-ascii?Q?6BhL1YKHEkgHf+xBgQDKT8FBjv81CD3h46eTp75WUPwD0Q20bEoGVY0bOsTK?=
 =?us-ascii?Q?IobsWZXAKz21cSRQ3M+C3cpziWQpvmtbwcZwR7y2Zv94//H2jXxMAVQ+Zdzj?=
 =?us-ascii?Q?PKhTZz9xs+DA3MfttX94MzYBiR3ZUHcfkvNZt2ICLhYhRfehdp8lAGfHB0Xv?=
 =?us-ascii?Q?tp+Y5SSHZqhUnuGdxnwX50iQWEP7dpjUW+XpR3ijwL3Jxk8fnWmCEoXocGjI?=
 =?us-ascii?Q?TH+L2f3i7u5HlBJx2ZxMYKd3NKfmTnwHc0yrPL7z4wQ26S8YYXv2WSZMyIjZ?=
 =?us-ascii?Q?ikvAYKQ/Do8M2gAQFKwAdpgbhgjod9zxttUJCHe5?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83679767-5873-4c86-c1ab-08dd7ccb77c5
X-MS-Exchange-CrossTenant-AuthSource: TYSPR02MB7970.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2025 09:45:48.9462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4qsXoFbCwbZc5yZCIh5N/PKFEZJS4CTrWZDL5Dc2FdyA5J2MlTsuT21hD3hVVkWPMTmJ6HTLIr4dx8vONciU/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR02MB5631

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
---
 drivers/md/dm-bufio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 9c8ed65cd87e..bdbd79e76f96 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -2424,6 +2424,10 @@ static void __scan(struct dm_bufio_client *c)
 
 			atomic_long_dec(&c->need_shrink);
 			freed++;
+
+			if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep)
+				continue;
+
 			cond_resched();
 		}
 	}
-- 
2.34.1

