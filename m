Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2051.outbound.protection.outlook.com [40.107.215.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C4C2554B
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 09:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715677561; cv=fail; b=nEcYEiHSY4wXtTZeccR12z2KABW6gFuHJf7ETIDrU4xQ6jIdpc8ryiD/xabS/B4+OLkaUH2sVbekHW0tCc7jnzC7KKwoB9bSYYY68rdi2bsOWGs6TYxCMNpvuur6unQWso4nxmM+qT2grHrVzIvNnv1PqJCcn2VUNBEUOg+xOvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715677561; c=relaxed/simple;
	bh=1o14Mua+SqeY4LUvV8RgJ9XYncUl4tlLf41aVfYF+D8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tWhdETj4D+d3qOCMCE4fqW3WopwVdKv9oj6rj/A3pjDY3yj3TPdgfv3rZvREn4aWisiIXkf3oHLJFUWqhNZ4eYq1DyMrTzeClNAE1+O2qASePWZWUx+5cVyWoV1bDSZFuyH77U0S61ez6Gu/mNijLPGnSOLGTusxa8i6CiuUf38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=fp/EKCYx; arc=fail smtp.client-ip=40.107.215.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="fp/EKCYx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sgk9rq8hFLZZz+it3OdmUmUIfMrPg05SnmLT7aK9VzkUSGF7YK3HhNTTL/sU/pkYpVu66UpoVoUP9CO6cLeL0rc9yl24vmKDDy7MMMI8VxpJR7HjVXPAmko67JJTs9TXSmhegVyjREZHRclwCopjhPMTnOyYsOm21QraKs15mUCM7w7gPR0/IT3KqriR+JIrDOCuZ6l4V9oVcdCCx3xQnBU6oJD+ZLsuAhv2N/YszKGular/+fjbvA7HMRB4ejSU1451JPHkrH5ih/PLAmH0jPQEk2u5v3TYqmKjMNDCVGDYsdPjxP91a83NhDrNBiDdjlS2TSWgwd708LJHc2pi0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3dEkBvgw1T5f89zF0xw1Ge5vvbQ0RyN1jXaZ/3XW04E=;
 b=acBNIXBb9AA+ZpA+nIAwnzTyIDVUz/u/s8Oe61jpPDUGUewSIA4lBmmYRDHFtwZcyPduOJjeEkVWbyWp6vyFmSzNt+1OsAsHulB+XwF+szNZGv3U7fz2uTCQdTL/VA79mraPPcBAI0IE3k7Pu5vJa0SuUn94pbTmWhb1t88TQkq1lxm+VEmpwCOtYp2OFGc/j6ePulsXSHUkzqatnBHiN2yOCSUX+wp+CmuEnk3d4LyciCNiIpLhXOY1ufMH4dcA54fjMKV2MsLJ3I2WFUi0SDGgGgNdJOggzmuRXm/lil4mZCP4lLLwVyYNZpmI/kc1PskuWkXEpd4jTe18iLyaXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3dEkBvgw1T5f89zF0xw1Ge5vvbQ0RyN1jXaZ/3XW04E=;
 b=fp/EKCYxNXkgIFi2duxz9bXvzp6mzKPahJGe4vgkfq7Z0afMNnveDXf47ymcCWaeThYElD3GhJX26DfdnrAqx5mU9JglfnMtpoW+lRVmDzGLMKw3WwulHOmQj7jzSc3yL7F0oWnFRT/mdbO48z2C3tqFyNUP3GbHbRd5mbAqriH8fn/HIqYHgidAPmg7M0HkoUY7PUqZfcsQPP33W6Iw8omsaY+6paUpD6uF3NCeQjc1klh7kMgK4cCkCqt3ifeJAuMqemShyaEy9l6OTKxYTW5H/XSeaFR8/4bqk7ZRJy0aE4G6Hye7p+2t4D6nPdh6evZ3eTSsYuGVjQb+qh/LEQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEYPR06MB6398.apcprd06.prod.outlook.com (2603:1096:101:145::9)
 by PUZPR06MB6102.apcprd06.prod.outlook.com (2603:1096:301:112::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Tue, 14 May
 2024 09:05:58 +0000
Received: from SEYPR06MB6398.apcprd06.prod.outlook.com
 ([fe80::9784:d8bc:5eb5:b60e]) by SEYPR06MB6398.apcprd06.prod.outlook.com
 ([fe80::9784:d8bc:5eb5:b60e%6]) with mapi id 15.20.7544.052; Tue, 14 May 2024
 09:05:58 +0000
From: Yang Yang <yang.yang@vivo.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Yang Yang <yang.yang@vivo.com>
Subject: [PATCH 4/5] dm: Avoid sending redundant empty flush bios to the same block device
Date: Tue, 14 May 2024 17:04:43 +0800
Message-Id: <20240514090445.2847-5-yang.yang@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240514090445.2847-1-yang.yang@vivo.com>
References: <20240514090445.2847-1-yang.yang@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0046.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::14) To SEYPR06MB6398.apcprd06.prod.outlook.com
 (2603:1096:101:145::9)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEYPR06MB6398:EE_|PUZPR06MB6102:EE_
X-MS-Office365-Filtering-Correlation-Id: 782f40a1-db33-4e00-54da-08dc73f511f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|52116005|1800799015|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2EbnNnlXKT+KfHsiRQnsDKO3s+QbXp6xAsHutx1ImZ0JviAQVYydZaEbRp65?=
 =?us-ascii?Q?3POAkqQd5Ly6bB/lZaGE9olj/fVXIYhf8sXkC6i9lzjjTHvDO1ImhrNEZndz?=
 =?us-ascii?Q?NEE9B7LYGxFJHFKPCcxANsp1+Z32qtTaFDJQULoQwU4arklRp0YkMZeu9oo0?=
 =?us-ascii?Q?zEpef+Wbe6KspuVisYmlqv+0QsWITKnm+58mg9+V5OXWn/G/1RjLntGGbn3E?=
 =?us-ascii?Q?xh9WOaXiv5KzX953r6/qPTBuDe+r2ENjV/4N2gQxHc6mQTa7DsbDZWV4T7Lx?=
 =?us-ascii?Q?l+KiOLLc48ZVa5eq5EiHXKdhsApIYi4EMo1PAxcYxIEDd7Osd/V9O46InoaE?=
 =?us-ascii?Q?DYV0NvbPmDvxX4wn+bnQ/WEpnvLbIiJf3oO/2I8NaCXu2sumx51mIefMFkTB?=
 =?us-ascii?Q?2ZuQXsFKa1XnWuBp1AXkq7JtyZ0v5NHGAOlZ6o7JJHS7bKDT+0GzmGhjElTp?=
 =?us-ascii?Q?X9uMkrCvePRm05Vr1xsTLQapOq3TvG4UFNCEDzz7KUJ8MEUy04hqVo1rIbsI?=
 =?us-ascii?Q?ECvd4fR9YCx/fPUa3iFc1+gZKXQCdrW1NNSJfdYLsBJO/63HQLli5JFRkIE8?=
 =?us-ascii?Q?p2dfomH2b1HJZChlxEhyKrWU+VTk3Xc9/VwLTI1qzUPuyeU3uaKXuuPa5hNW?=
 =?us-ascii?Q?dog/fpBSqC4XXq46QY2JCQMdp7JK6FCQ26F/O03SZ80O+0vwsCEcFK69JPvl?=
 =?us-ascii?Q?NLHANVObAZN3f6vZwCeTVAtGNsS9uVTLaZQBjh4+w/vORKhS7S3ygKQKZZs5?=
 =?us-ascii?Q?KM7KQLXjQwoh+C7wGmwSL0037/l0mcKrLMPMhkDpypXen+6dn03HGiv+8CTX?=
 =?us-ascii?Q?nftBgbC/sPU1PN7szOQn/5UiiBpCM8qHxzNqNBv3mFre79XPnUNTRnSAmOL8?=
 =?us-ascii?Q?k3VJf72K0FuOymJyXS8deYzkYqJZfQmNrxc+2aKmodMLCjkrrx9ZRQGCSgbg?=
 =?us-ascii?Q?1JECS74YGGAbQFbAY6L9m5yUpeBf3ZTkGZJg5Jw3P9gncPDGcaJFO1kbVIec?=
 =?us-ascii?Q?7L63C/q3U8lyFuhzkEaqXsz4u7ETKmVSQK9F6GyL0otxHUNlfVyltC7bU4MF?=
 =?us-ascii?Q?GGdpyQom2rjRdjnW8TJ5V87I4z/K93oXeMErzRhNSrTaG0wieTJBd9KWiypU?=
 =?us-ascii?Q?7XlarQxja9Y0BwaCOoDihmNn7Ni22/rjeiPDSgwqc9PuKKIpHgO+s8zC9aqy?=
 =?us-ascii?Q?09loN9U0raQVitpSZMc7k5npGiDpl7aJ3C+l8A9LpJWQQk/nfXj40G0blKJx?=
 =?us-ascii?Q?XlcOqxzJa7ccQ11T3zsVbWGvW2qrfkpZzky4VvOB8tNompPy7sjgYUiTHzkg?=
 =?us-ascii?Q?gP8tEslJe/4rCmdagw5+z+D0dMEbfgkKA+6hw+keoLCeHA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEYPR06MB6398.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(52116005)(1800799015)(366007)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UrlzF9nCRUX71F9pnbrPJ9Xqj/xTGvEustcLkzqMkGAoNi6lyVTdJi+j8kAz?=
 =?us-ascii?Q?jofCKLH1NxTUB3bvKfG7tw6gWvHSca5jcGl9drksUw5tgNimJFcS8/2gEvvh?=
 =?us-ascii?Q?raJfUL/BktY8YL/UpnpXH6T1gI9LPwIYKORZhqUlL1g3wl6LATKZQMwF/Uj2?=
 =?us-ascii?Q?Pby0xPw3YW2t1YhO6rIqD3FrijW4gPVQ6RV89un1X6p+otvflpn+lopnyVgC?=
 =?us-ascii?Q?Q6eQ1WoHMZ4sJqdI06uKo5r5ay295v1MIJDh8VP0ZpGLVbbGHKTd45JDTdVr?=
 =?us-ascii?Q?VtIQaMJJZpISUUaKQOWAV0z8acq9GoUFa8dsky92uuPPEhiWpXbBbwJw/XLf?=
 =?us-ascii?Q?Y8P+TAmESBWOM+Kix2P7PxiMo4hpHAuxwmQkTmwwdSEkCdUmdIy7S9yvI2DR?=
 =?us-ascii?Q?MIEDJf3WFSi0+3gJ88SciDzpcAjaaDK7IQVI+fHq/G5+N1ycx7Qba7XxBrpd?=
 =?us-ascii?Q?gnge7oWtbdBHSig2C89C1qU9rPZrT4mLiHRd2ilUuW/jImKkvmZdf1TILLtz?=
 =?us-ascii?Q?BkeFOEz7P1pXci3zQBGu0uQwGcfnbcT4CFRvFMik3McPH3YiCdAnqU8if7X7?=
 =?us-ascii?Q?DzLFwg6M5L9CGJJ5DMLyBqUmTEirSFzJLwyzye//9Abq6LQSVqYosWkalpkD?=
 =?us-ascii?Q?mWAiafA7MKyNm3bAIqXsN21AhWOKMGbgaD464tLQt+VDoGHcPoqyXGA2fF+o?=
 =?us-ascii?Q?B55yQ9jrsgkvisidVQ4fITyypNka3HbsB0nP7tnNgTnGPtRJq2djxCSae4X5?=
 =?us-ascii?Q?1Pq7gTCOQH/58slFGLotiy99FqyWbtOETKv1x6fENFvXUoCShzc8NizUAyIH?=
 =?us-ascii?Q?uhoUBZlSCDRi0UkECKOedXeF5mCRy5q1oHVLXsugrVldDawAeopJ7gsv9Owt?=
 =?us-ascii?Q?c2tqcNVMOnjNgz/ZxFJWiELRLgoqNM6/5H/KENbdDrO03v49k0Sg4EghXAcU?=
 =?us-ascii?Q?PrLGiCie44dlAcxWEGLlmCsGmccBSTm5Zwqui6nAXkCsXRCRqaOFkjRtezgd?=
 =?us-ascii?Q?2JrHg+IEAj0YWvdbXPSXOsyLZimzFSd3PNOjPlEyxEXRlv1lEt0CJy1EyVbc?=
 =?us-ascii?Q?pirK/dS+4kChg1PZJFi6puC8U310C6lC15ZZ32LIhbCoo1ikoURE9pWfGqvo?=
 =?us-ascii?Q?z+ej7KPc8K0rnH4OAOneh33FHP29BVBPZFVQstMmmUey48aKlOvYvOKDes6d?=
 =?us-ascii?Q?pI1gDOfgjP7HpjrKFTFiA6YrRtxlqqivyhkgBWn7cw71ZG9f1prpr9c64TlC?=
 =?us-ascii?Q?KbpX8g4KdHtEbTiWRfm2Chu8U/ki8fvSoi7x8fwZXYV7cFZPFwecA07ZbW8F?=
 =?us-ascii?Q?JC+DTGu8X+vT1433lvb8G/WCEWA5m/r7D6LYyaw+hQijAYkrHiXWmAetO9Gl?=
 =?us-ascii?Q?LhdL4hFPQtRG5p31IFuizzwO7CVPLTqto0V0RD1RognSajkaTRhxdyQJyQpz?=
 =?us-ascii?Q?/S6lsjlfdpi8udZtUQ+9cbHZGJEaui+BMOtm3tz+PF/hPkIhKT37dIZhodE2?=
 =?us-ascii?Q?I0RAWarJOkBXm84/5BN3dkslxVxbn+nsN1tW8Rro8+OAotN4JKFEGk9x4ZOk?=
 =?us-ascii?Q?R0z1wltD5rxC0JnT/A29lkSAU1YIrMYKbtrfU2qE?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 782f40a1-db33-4e00-54da-08dc73f511f7
X-MS-Exchange-CrossTenant-AuthSource: SEYPR06MB6398.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2024 09:05:58.7054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mYMua6HthxQQWn3FReyaHltBAVKlpESTVcV2G90rkhgSkS/BxjpxYfLLeoj1WEXg/rY3+zghPQoi3+k96BS4Cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB6102

If the num_targets is greater than the number of dm_devs in the
dm_table's devices list, __send_empty_flush() might invoke
__send_duplicate_bios() multiple times for the same block device.
This could lead to a substantial decrease in performance when
num_targets significantly exceeds the number of dm_devs.
This patch ensure that __send_duplicate_bios() is only called once
for each dm_dev with different target type.

Signed-off-by: Yang Yang <yang.yang@vivo.com>
---
 drivers/md/dm.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 25215b93c3cf..9dbddc214084 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1561,6 +1561,7 @@ static void __send_empty_flush(struct clone_info *ci)
 {
 	struct dm_table *t = ci->map;
 	struct bio flush_bio;
+	struct dm_target *ti;
 
 	/*
 	 * Use an on-stack bio for this, it's safe since we don't
@@ -1574,10 +1575,21 @@ static void __send_empty_flush(struct clone_info *ci)
 	ci->sector_count = 0;
 	ci->io->tio.clone.bi_iter.bi_size = 0;
 
-	for (unsigned int i = 0; i < t->num_targets; i++) {
-		struct dm_target *ti = dm_table_get_target(t, i);
+	if (!t->flush_pass_around) {
+		for (unsigned int i = 0; i < t->num_targets; i++) {
+			ti = dm_table_get_target(t, i);
+			__send_empty_flush_bios(t, ti, ci);
+		}
+	} else {
+		struct list_head *devices = dm_table_get_devices(t);
+		struct dm_dev_internal *dd;
 
-		__send_empty_flush_bios(t, ti, ci);
+		list_for_each_entry(dd, devices, list) {
+			struct list_head *targets = &dd->dm_dev->targets;
+
+			list_for_each_entry(ti, targets, list)
+				__send_empty_flush_bios(t, ti, ci);
+		}
 	}
 
 	/*
-- 
2.34.1

