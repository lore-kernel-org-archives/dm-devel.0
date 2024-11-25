Received: from HK2PR02CU002.outbound.protection.outlook.com (mail-eastasiaazon11010042.outbound.protection.outlook.com [52.101.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A35122071
	for <dm-devel@lists.linux.dev>; Mon, 25 Nov 2024 03:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.128.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732505019; cv=fail; b=buvIueMsC4Pw8+M3XHoFTW3UwRxl1TyiIFaDnGdP7WhVGZW/AhQ4D6QJEzG/mtAAnL+1A0dipHU5Kd7JLSv0hQA/RtiAux8bmIREyENbjb4yjz2wAJMNWw8H3t70Ja9KzucnM1SO14WL2kLsjKP76tyJTnIJtuvAusAMO3uTi8E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732505019; c=relaxed/simple;
	bh=lj2xCptAEW7Nrz+bzucPea9RlFfpG625tpoWHKasnus=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=W1V2V8etP7EDtOqCXUghmcocqHoWISp7kZurG0N8Kkru+YTEpa+I7gEk48iKSvF214PgktKItu5zBiA1tTXZQ+IYTv1CMeHFFQc3vtvfUOUKHhL6lOkf9KisLdsUx/KgvOIC5zZ69rNax6fZO/rE6QWTX1FXBSCSKVXz+MXTxEg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=F8rHga9a; arc=fail smtp.client-ip=52.101.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="F8rHga9a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KMMhidTA2qIDxtZlRArdG/kX2wBQ3FWXVic6zHOvu8GSEN6f9pvy/4WMw0ktknUPwAsZCiWZC0lXSM/ZuMjec+hpwy4ZR4l25GzvovgqFLwZMQOj+ugA5/D9FNMQeKpMJd07uZrpo9+hx6vwf/n8J2r7+UPNGqt0uFAT/cHIISgzgXXsaj5X6sqx1Cp0xKuMxzdJGDfZ6gZ9n4vTEfXYygR1M3w8PpfUqb8JybIPhpn3nghzp1D+5ouFlU+CaT2xFhmaj0iyLvxnxvHxEH2VFUbzTuvOzTbo5pLevx/PoZaqCBclh3PEF+ZfvoWlFb7C1/C+gcpEXlkLPJYIkE1F6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oRZM6oSVSAqdeuFmeyT0d7/+mhIYe6LRWtAclejQt4I=;
 b=AGZGuSIYtYSwSUkrD51zslK36+C7sVuwwaXl6Btv7+Wb6r2Vn2k9MeHep6crkI5GVO34SkHAP3F8Kcnmiv50a/lkWFdb0T6kQotNhdM8IGTvgq0hvUcJKhwb4xou5RYDUVLAQ+e6GIwxofWkAyM7yUInf4dYgLS7Ayhi/okZ5nttg03SSsaqwdiIPRlHFrg5grgIXFTfiWirLdVLw31BjH6P2ZaUxEO20zqz3aBch2o1UbI8h8XI7lCNJJllmNQZUABsEtFn/mqU/W8qvKUmnifU/inFkW5jGWwoBAX2qcNykavmmg9ogAQc0tKeRfDxVuygCr1IyhWamUwUfOiErA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oRZM6oSVSAqdeuFmeyT0d7/+mhIYe6LRWtAclejQt4I=;
 b=F8rHga9a0QvTDS85r2biBs6TFwHx6RyxPnhseNe2wS6zxl5BjYb7e/GdTGSeDToMgQnFi5RnTcrOPX0goVae+2KBZHatfiavkEIgArH2r1jvbkBHkpicvw17ia7PyfaVnNYrh8K4rsOychxpLj3J/VHuprkRXAJGznk6rd5YQDM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com (2603:1096:101:22a::14)
 by SEZPR02MB6109.apcprd02.prod.outlook.com (2603:1096:101:95::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.20; Mon, 25 Nov
 2024 03:23:32 +0000
Received: from SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b]) by SEZPR02MB7967.apcprd02.prod.outlook.com
 ([fe80::5723:5b88:ed4c:d49b%3]) with mapi id 15.20.8182.018; Mon, 25 Nov 2024
 03:23:32 +0000
From: LongPing Wei <weilongping@oppo.com>
To: dm-devel@lists.linux.dev,
	snitzer@redhat.com
Cc: dlemoal@kernel.org,
	bvanassche@acm.org,
	ebiggers@google.com,
	LongPing Wei <weilongping@oppo.com>
Subject: [PATCH] dm-crypt: set max_io_len as chunk_sectors of zoned device
Date: Mon, 25 Nov 2024 11:22:51 +0800
Message-Id: <20241125032250.1329977-1-weilongping@oppo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0372.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:79::20) To SEZPR02MB7967.apcprd02.prod.outlook.com
 (2603:1096:101:22a::14)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR02MB7967:EE_|SEZPR02MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 27a3a638-1494-43e3-c936-08dd0d0089a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0cdFF3+3zdB1+l5+4NCDef5mmXY+cRAEemm/O5tSOUqzaLyEN2VN4X/2v+ZM?=
 =?us-ascii?Q?/HkANtSTKMw+Lq2a6IyBSTY9Qa0lyr9hW4tNvGC6GDqUXPRlG7BQLdECoAdI?=
 =?us-ascii?Q?dtz+WcI+wMVfM+CsdqagKf7Mbp6Xr9vTRLpQcf0ngAUKtxpFD+filuBH+Er8?=
 =?us-ascii?Q?13zohuMjmB4DRXumIpTWSqvj3YXJ8VjSsKkP1FbHc+Cb57kYKCLvIV2Odexa?=
 =?us-ascii?Q?tbMK80+u+yK6tc+r4nH3KH9DMbK8v4lEyVOqbNj1OMnGV6APJllBucRKSxPL?=
 =?us-ascii?Q?XL7SdiVsFfCvxTOATHmw0sxF3mvMz8MybHwwfrXAp0ez51yePkRNaDI8zcr8?=
 =?us-ascii?Q?TPIkA7EYukW+bK+YUH9Zq8L6LD7BzB+cwTWHqzeGg+kQkpwldroPxUFusbpa?=
 =?us-ascii?Q?YymGbupUbfazacVcqwsacefHrf38iLsUGoHWO2wVutFTQeiFAsyBPtRbTq0Z?=
 =?us-ascii?Q?lke7kc0/SOUWVsCKLJ36oeRGdPgPaqbtZcH845vKHxGB7eHNzTEuPZ8u4AGG?=
 =?us-ascii?Q?OFj8DNBO7vxw9ytI6Md1tl5csybQK5bwflqn0mfU1hbMm0w7p02sNaO37wo5?=
 =?us-ascii?Q?rWLJk6PiAuneoF4KJQ6FS2e+jPa237mwm2w/MXZJd63Fz1kKHFJS1HzFEWXX?=
 =?us-ascii?Q?AE9P/swD2o1y4nkYM+U64/bs6s3YYIG00S3G6LA+P86LgnhA0Bj9lBWHTxLX?=
 =?us-ascii?Q?MalcGXrDAantlujCATbkWtqn6NKP+x7cHTHkJsaGzkC6gQZpR6VsTiLzBsl1?=
 =?us-ascii?Q?X9KYHzuoropMjpw3z3pwmj19O8jj2Ca18dw4wk2L8cJsChx/zzwK9wCCBMp5?=
 =?us-ascii?Q?AExCYgLS3r7PbWl+XWohOhSzAo4TtpSpUlbDwMEIhXUCHaZ6dXraMwH5CEtw?=
 =?us-ascii?Q?My/iWaU+m1GPLbg0q0x5pOpeB78kkV1qDSpYIT0vSviC9WMsHYwflpyA8I02?=
 =?us-ascii?Q?cYzL0cnkcNbpPoX7Pr2lNkb6vieI1AmD5dkf3VoLd3XRRRFTfvptjSASTTDd?=
 =?us-ascii?Q?963/3/D8ovWDkpYIIIpu+qGXfdMbmFuJBl9+e/8+2U/+v2eDp7G/R/KNSgU0?=
 =?us-ascii?Q?PtcoIausAahhE+JQeOAS6Wlb12Gchb7oieWWTNAsmjUA7cpSGzjU2baXzgIl?=
 =?us-ascii?Q?+pO7DQcAgxIgHB2Gtma7GcPJMKc57AMWS+bjWkxoP05t1KGMI+P3IqqKAJMV?=
 =?us-ascii?Q?rPvXEp5KzhwkXjZt2Ztup61qTZcwpsi8O6+slPtsStg/EQDCS0etdI7udH3G?=
 =?us-ascii?Q?Tlnly8sO4pLDYhxMCy3tt9uQdOGSusIqoph1uJ/Fl9tyvzf6FiZit7b7b8to?=
 =?us-ascii?Q?HOXhalYrOCmOn4RAIHIJt9YIJ/UkkHj7cULUvk6J0aMd2HNskWxR7zrSc3ve?=
 =?us-ascii?Q?QOebCbUye0CkUrr8oOi2lFwHiJNt34MvAwCYT8A+9W5u7fKnHw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR02MB7967.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OB4F8W2uGaDd1gy1srB2RAzNtkbGdmUZMVDUgvx/ouz9qNe9rbdreqKD/lGr?=
 =?us-ascii?Q?HVfZweWCARP8+qeeTTUKO9cUw8PR/dK1Zjzaep6Hq9TPcZ+WCiaQm4LXxWpG?=
 =?us-ascii?Q?CdvPJ22Cxusbk+SWvEfH/Wg7G3h8RON59tCIAptQX88RP1B7RDZliAKjs4Uy?=
 =?us-ascii?Q?kilbpXFKFxx9KXD0Aswj3i8UZGKkzyluS6IYkt8STx9F95aIRPOwtfVNpPer?=
 =?us-ascii?Q?78F8oD+i2hv+BTgKlv0NsPrrcCEEka/J+LeAbEYPhMhQe/drc/CvvgyXCium?=
 =?us-ascii?Q?rAFGJH1fVpwlDTtJFMuxHk1oLuOJ+fZz84Gl+EHCZQn+ITNA+Oam0OH37Ly9?=
 =?us-ascii?Q?K/kf1vgbhhBWsWW5uLyMbOv1Pe0pwCM3Fe9usd7a4zXDWmvEQdKEz7G0RX0L?=
 =?us-ascii?Q?yrHmak4bu7fkNdEKUPfguYw/c5U5NPaUzjKhpej+d17QnLradoYfo7ZKRwuM?=
 =?us-ascii?Q?gEkNApDBwyTQKUbcPbeYfLh5AduGnit6P0me/nlmef0pugq5iZLWPls+TBv2?=
 =?us-ascii?Q?lZ8tx0XtxwNmuRiIKCB1mbudG4Ay8H5eenSuNyVa+2taXIwnhOPCGmr6SIlo?=
 =?us-ascii?Q?Hl5r8xvfHQBhWLtDSz4g+ntA14pXEudWs2PNTS66JeEdFyvcsHjKjSfXMovH?=
 =?us-ascii?Q?s663AAi4GayG+hBF/ULQWaTPQUUEFxVt8zzSNPZE5ubdR1jeXJXjQf+Vg0j/?=
 =?us-ascii?Q?CYmBP0YqwV6a9lSJSwcaULNndaK1Z2JS43Lk4Xz2uJZ3jLmnIG9KTsy13PuN?=
 =?us-ascii?Q?9dItrbHdNMfZ9gRqtauoaXFqCYqkfd58S469KsGQP2hbiDuLwLEsIDgP45zO?=
 =?us-ascii?Q?byvVV1gr2R+n/FIQVRzKV1LAwDu26tYJjjLtOV7vjWP9izLG6FpWmNuVwhhj?=
 =?us-ascii?Q?NzmJX645lEHLblHVF8KPCa8OX3Lb9w2z82z8eWTkYKAuhfU6M7mqCkNz85XP?=
 =?us-ascii?Q?hX9GEH4sJah2+z4KZEsOBvwnwJkCbVkeh8mx1zAm1MxouGUHAh872nCBDgu4?=
 =?us-ascii?Q?4dCJcio9l40lQHnY+E4XB2ayvmBmT48lpnNjjtT1+avwo6/lEbm6NJPKtG0n?=
 =?us-ascii?Q?QUilMqpw805ZPSUbjFTiLWWMZlRjlYsUTWgNeH428sQ6W9V2hiWtcV8HxKtA?=
 =?us-ascii?Q?gAA+S/8IJPBHQd7t+MxpS7CINMRbUPRyqLZq4hranAhPryPwV5RXnlCEY1Lb?=
 =?us-ascii?Q?48zVfE6UFtI6H8Y/DZt3ltLz6wCqVRpwOYTRt8jx6NBd1gLMW3RTJZpATkjT?=
 =?us-ascii?Q?hHNK8sI7CYcGNuFGlXkaAhh5gSvFXsk7xuzagvmbrSSD84UqSAyi2xv0NYF4?=
 =?us-ascii?Q?0iv2CorQNFY2Z2sgMBT+lTduwkiP3+qbT8c3WTWFau3FCAaWe/rW+Axl/H+F?=
 =?us-ascii?Q?7cp/RTgOGtDx8pbIyHiuLh98M538Mxuvi6YR8fSo0C3OLnXorXwHfdwVfb7k?=
 =?us-ascii?Q?K4MUYy0gNGgjJYu3xPBJS0a4hj+e50UX+GyYZSfGo+awuuirOCHPFAO99QXf?=
 =?us-ascii?Q?0Hl1ZTO5D3f0mJ/T+ha6o+5S5vLjPz5L3oPXWhzA1fEiV03YalabbbqeX7bm?=
 =?us-ascii?Q?KPs4OwaSMSjzz/8o/co2YAk4sGj3ZWsR8H/nG8E28AFXT1aFAsW2TXzf8Mfv?=
 =?us-ascii?Q?Yg=3D=3D?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27a3a638-1494-43e3-c936-08dd0d0089a8
X-MS-Exchange-CrossTenant-AuthSource: SEZPR02MB7967.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2024 03:23:31.9542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 86l/nC5xoNESatQbDv6TzZYm6D54q+DZqbmm8Yoh2LJ5XKi2G5EqFS2DpXQRDbXk8UhnqzfOXA8ozc4tbTyl3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR02MB6109

When dm level submit a bio with bi_size > max_sectors_kb of lower device,
blk_mq_submit_bio will split it into several ones with limited bi_size.
It may be a potential unordered issue as it breaks the ZWL design in dm
on 6.6.
It would be better to split bio by dm_split_and_process_bio in dm level.
Considering the design of __max_io_len in dm.c, setting max_io_len for the
target is needed to make __max_io_len return a len <= max_sectors.

Signed-off-by: LongPing Wei <weilongping@oppo.com>
---
A potential case is:
f2fs submit a bio to zoned device with 1024KiB size, and the max sectors is 1024(512KiB).

ZWL of dm will just re-submit it to the lower device, then the bios will be splited into two bios.

They would be submitted to differect software queue as the context may run on different cpus.

If the previous one is on CPU0 and the later one is on CPU1, then the software queue of CPU1 dispatch the request before CPU0, the issue will be triggered.

CPU0:                     CPU1:
f2fs_submit_bio[task x]
dm_submit_bio[task x]
blk_mq_split_bios[task x]
submit_bio_noacct[task x]
                          submit_bio_noacct[task x]
                          dispatch requrest in queue[kworker1]
dispatch requrest in queue[kworker0]
---
 drivers/md/dm-crypt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 1ae2c71bb383..9b487ccb1ebc 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3417,6 +3417,8 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		 */
 		DMDEBUG("Zone append operations will be emulated");
 		ti->emulate_zone_append = true;
+		WARN_ON(dm_set_target_max_io_len(ti,
+			cc->dev->bdev->bd_queue->limits.chunk_sectors));
 	}
 
 	if (crypt_integrity_aead(cc) || cc->integrity_iv_size) {
-- 
2.34.1

