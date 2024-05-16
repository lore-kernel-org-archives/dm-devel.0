Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2070.outbound.protection.outlook.com [40.107.255.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489584688
	for <dm-devel@lists.linux.dev>; Thu, 16 May 2024 04:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.255.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715832185; cv=fail; b=ZLyegfvLyoFgAYbJZ51iymzvpQiA7Bpa0frUKiAn4rdl3nl4H4fFhFn9p05C2Sjl7uSMzVo0XZXksxFzbDI9K07yWZ9thG2bQPeREidj87J+VTSZNf2bk9Rracqat5f7tABWjVG4BVerkInbmcAli6SbKUL+MBt026/WZ0FrA7U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715832185; c=relaxed/simple;
	bh=vMja9I/nEgqe8g5Ku3lTK/HjOs89t7cyWu6BFkSc4Xs=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=tNnFR59R1isAJOpH+HhRRRrh3GXlSQGUtlpz1sCp+J2aoo8CL4B47aC9g31IIkc8mDR1402BAcufuEM6BTcxVnTetky+VF7Zu2WFYlDpM6wQpXhXmbw9XDbyj7qkL5bQG2UX7QgqzSA2nIa0+w1iiw+ZfDBy+sFTc5gX3eG5ZTI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=TYgY2qnh; arc=fail smtp.client-ip=40.107.255.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="TYgY2qnh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oBdYi15UuasLm3FBmdLn9/vDUXltrI55I7tz8JjpeRTAPzpok4GhD3cKTilJ425n8hnNBWOsWx3A8MjyDCsYHh25wNrxnPBDbDZQq5tYDhN+pcXYhDNl9WWZGOB4fXwWLeP74LW9VPRzOKsUQCnsiGjSx00urt9KK5ZKQ5aUrcFhqrYDCN7jkV39H7A6T0V3abl3zr06PxeAscKL0MbVQAZN9N48Gf8fvfEglTZ/5vtoIBmWrmlCYVbl7UTX5mXSI0yrPydrSEUY8ABsGKk+TqCu1SWMXri3ZQa1+uE/X4MWxg/gu60h237U2whHGCuPYUEmHAOcWEEhgoOFFN5Hxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wcyVJOxqAMnEJwEfpanskgt6u4AxCqKnZ8f7n3S7vj0=;
 b=TdakMuqiirl4BdQdmz7YNNgjlOqV2MRRYAPCT9nm1kotpkq9M4h62kyHD7q85reYBv5SBZFJv4tforfZ+F9t5ZEgHYCBewY4yZIAv0AcytjGTeyCK2PPEw1J8SRK6gGk6ZVNtG/vXuXeoJw/fsV2peuA/I/gVOgiI+KDeeIHe1E+9vDzkgEErps+4l7NtPxP0IeZW6fwyxaUTs5M5rwRbxy/oR5k+8il7ccpeggvHZ+k96MydFYYLrPMXcMwkGKhOZe27hxmLDuXiPwoF0cBLtGSNIdiHMEiwame/6XNSa4LdbpPDvAjUGUsDITjQ5joRLklC7mJv50Rj/KwOde8og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcyVJOxqAMnEJwEfpanskgt6u4AxCqKnZ8f7n3S7vj0=;
 b=TYgY2qnhv1rUjcSyIAuK5qcG/szJS+KUk0X7Co1eP+3yW6l6GMyHuS3+urfrzY7jb359FTZm02VJ80K/Jp2sSKOtUREgaDc8GT+CuvqFS73MDyONrpDTWVPRAWhFWoTpPUeo3EJVCnOWTJMjKCxzeKaIPQOwyjsGrBAiTGHBRJPZFOOq/VNxgm88mfyt6Uc8NTyavG8/R2rUbimaL99MvVQyYOOjDYAGUYEjSRBoVXIuqrrl4xhUy5lLe59TLhpBf2/7kXirYU2UGkX33nVlYLuZX30ILUTLocwrAKMOvjU7FKYFlTIxIP4cFUOr4tdBg7FXZ2uGy4YtsUhGkP3U3A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com (2603:1096:400:42a::11)
 by TYZPR06MB6807.apcprd06.prod.outlook.com (2603:1096:405:1c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Thu, 16 May
 2024 04:02:55 +0000
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee]) by TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::8e76:5af3:e027:ccee%3]) with mapi id 15.20.7587.025; Thu, 16 May 2024
 04:02:55 +0000
From: Yang Yang <yang.yang@vivo.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Yang Yang <yang.yang@vivo.com>
Subject: [PATCH v3 0/5] dm: empty flush optimization
Date: Thu, 16 May 2024 12:02:29 +0800
Message-Id: <20240516040235.115651-1-yang.yang@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0017.jpnprd01.prod.outlook.com
 (2603:1096:400:a9::22) To TYSPR06MB6411.apcprd06.prod.outlook.com
 (2603:1096:400:42a::11)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYSPR06MB6411:EE_|TYZPR06MB6807:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fbae2fc-60d8-410b-c005-08dc755d1103
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|52116005|366007|376005|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9r3VIRCcs3Cbn45jZFyyjnwTEax9+u0ge0NdXN6XjyC+lulorAKtK7A0aNeo?=
 =?us-ascii?Q?KO8w69K1CUmTsHHw5gQ2AD2UcSAosLeB8D50gEcHM+mRXW158QbQVSp4Lkms?=
 =?us-ascii?Q?hLXIoPrcfcAbxs/ekzGSmXBiIoII6vH4ho6ZBpMag4J+H2A9t4AqNI6EaOAh?=
 =?us-ascii?Q?RZQQpMYMeY5d301FwMeRaWuZCb3gf1hcZJx9is0oJLckO0FF7m+04wSEwul9?=
 =?us-ascii?Q?Omj79AJ6yEPZVGUSHc9W2rhUyriyQBA6/mdapOo21y4k/2mrg429XgCzGk88?=
 =?us-ascii?Q?6qyvLGj1YPKckVmKcuyQE7eheJDvScpfreHZ+FeKX5/zyWClpH/PTNIEcloz?=
 =?us-ascii?Q?2p3t3ik5KhlAULMkkd8tP3pHsdMJkSGBPP1h5hmLM71RCvaqO7jUgsd5aW/r?=
 =?us-ascii?Q?rZ6lghGL9/ueLBy19HT8XmMwGi70wcbjZxnXzqoxgD5QTfZCZ49mmBbeTA54?=
 =?us-ascii?Q?Rnda2lhyb3UXuqlzTw1s5+DlXGh6M/RzVsrwZZVYgM3yXm4iJPTJosx5sKau?=
 =?us-ascii?Q?44tdN4ILC83mLL536sSe3d6qIhF5usVvbKJxPd4tNPlWLClZcMWKu/2YVU+x?=
 =?us-ascii?Q?VNri8PYKF6Hlw+uF4lyQE6a3V9m7b8CZg1JI3j6kWOcxiobrYNDUUR9/DWio?=
 =?us-ascii?Q?BTzipVNokwvQOHIRR5xDt9nP1l2RcdrpwC0kYpDI98t5tgLXFdYPvMRRU3ih?=
 =?us-ascii?Q?U8auNhaiQvlV82uGmPn706n/Q+g7VDQRW84EpiTwJvC3W8Tpms9JopvN35mh?=
 =?us-ascii?Q?h/3yaTYB1SKosalluq4StKi8/7wU6rgARKRHj0dUuSDfszgSggWmzs6EgjUe?=
 =?us-ascii?Q?bN9MYlDOB3IRaidUJLS4luKcnc5aYHRJDGxPsKr2PATOfXj4K2sfZFa+MjSY?=
 =?us-ascii?Q?/lG3UC2D8IZHKp+EPnstMQaFTpOlaSMZGvcai70F20ddZp67nQYoEnps056E?=
 =?us-ascii?Q?VAZz6wFAmnjxm9pOifMU3xvFlqlmn1MWmvCumyfW+MjXrY+reNJ7/34dqfW/?=
 =?us-ascii?Q?WfXhKSTtOp6wnQbhuhAJpDG0it88lcFjrD/v7WxdV0+K2H2YgfPKUfUkjoP1?=
 =?us-ascii?Q?K82wcjdZYiiJ6F0NaMGQ8aW51A/EWrNR38c8LCaArhnKvCPrQd1kTtfPXyko?=
 =?us-ascii?Q?GvOnDskR3QRcxR7pFK1L0lDF6cCq0RvF+R6lhhZEJCMDElCrBG+KnHLWz7dH?=
 =?us-ascii?Q?HY974W80zl5pL3TsBQxnSxkpGrasGXOoNgKtKIuO8/SGhFLQptqHrto086DZ?=
 =?us-ascii?Q?7OI64jVVIt3+dUHY22FenJ7qJQgX+PXxaXLsnzSkE6kvWSu2xDAzlowq9IGH?=
 =?us-ascii?Q?3qnCxiiWUwksNSyxzN3/BWNJop/yAMwFLJzZZjts7bjzRw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6411.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(52116005)(366007)(376005)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mxohw8KwVCkXE9YQzDsE2BX7vl6NPXqjoj4UpZ0JThUg0Zc1uItnEY/2nXiR?=
 =?us-ascii?Q?ZwiQ+vvwARuF/md8xHl+3pHHieZxoEJ4aQqPnP21yxr8or/UbrpXyLlFS9RG?=
 =?us-ascii?Q?A4ghNPJw2+/myu5kyRU9/yRFP9AAvMPJpIuiiZcsR+fjMDzauKu8nFHL9+S6?=
 =?us-ascii?Q?dmTI/umfnBjZvnBrGIimYKdnyYaH4dQml3AwRPxHdtF4H2xrFtBNtEq4BTda?=
 =?us-ascii?Q?+wm6VqpRsPb2G0dz95qqOVK1R9AaIRWQbz2kBUAM15upB8j9whgYhxVu99AU?=
 =?us-ascii?Q?01uHFqZgaw7MJcxTRu6MWxMOvovyE8Cc8e+CIRluLY4CCdIbjrl3Krjguu9G?=
 =?us-ascii?Q?u/cPyuMr3k4mjFI/QqXvvi1QoAMIRi//R1XVATYDoQEeUhavLVSSt0MNoVMw?=
 =?us-ascii?Q?BPJ8Lc7VRQRAzb0fkz/iCYQWH12l0tL+DoDpXHneVy2xtp6lfGmcAD3pLqJB?=
 =?us-ascii?Q?Z/Pt9Tkora6/goltqXZ8jpbNNj0QrSZ9YExc2E76YxYvDoHDIJlaA0V1HRhD?=
 =?us-ascii?Q?RgO/uaySsPFtb4ZsY0gHnTeVznkBfwQWlp1MIcfrijjHV2/zB9UMA95BIXUL?=
 =?us-ascii?Q?EmnLmuHzVJiq/2FOYZLlCGoJFXbyoGuGwESXCogTDQYSZgwO0AHSvlXegpP5?=
 =?us-ascii?Q?knWhN39x5Sunvi71YCFIgjvuks0wifcB2yj1CwZqdOD4fd9AHVPdOXQssT/J?=
 =?us-ascii?Q?lgpQ3g6e2aag7dvoXAS6AXU0XkvtMCK2PKmdvy357Dir/QnapX+UoxAzGN+n?=
 =?us-ascii?Q?buooontc8sq7xu2Hsmg9VhQ+WerKAGH29lfBYqaOZjcmibT2UCvmFEk94+/1?=
 =?us-ascii?Q?rfQf9+zpH2lBAomVleYolB+uMdLaFqSaWD7vmvvG8jCBCHa8MUsea0gSR4wi?=
 =?us-ascii?Q?m2LfDogBTyUMotS/Au4oGkVFa11jh9xTp11pJKyD5rmc89NuBJQSRKOcb0wT?=
 =?us-ascii?Q?3I4taLL7+Ot/yvN72pNceQSs+u5FBiihEj4rQzZ9OU9S9huGRp7mk3qCUG4w?=
 =?us-ascii?Q?MLaiukJiaMKXxeCFr5loeQDJJKs4/4boSIioYtXWvwivqqXpxbiWtz+VEKVE?=
 =?us-ascii?Q?YMiiU2hm3mEbqbwIsbhRDCNXV9yHwLjmEOo3ZQoZLFGUE1KkxBz/eubEFNd1?=
 =?us-ascii?Q?QvkakTKbhjBsJQo8gUk124dZXwHL5SGBfk5Y+qqIncrXDkjVGCZF0VLYIv1F?=
 =?us-ascii?Q?SwwYRmQgFdDWQnQGPV0TVAKRBFGkt0gWE+2l2/0lC+hl9ZQhmD7fK9ws4WJ+?=
 =?us-ascii?Q?LVo2zfWpHOArJ+Eh1XlQOUNje6QmEkgUCO7jz18ThDE79tfrB3Z+XGdPrn6w?=
 =?us-ascii?Q?PvS1X9bBJgjrHUgBooGTAVqFnDpoukUpK9ZbnXRJtRlO2tIxu1zVbzPreda+?=
 =?us-ascii?Q?pIBlsSLXV0tUF/bURyvLp7hlcC74UJpOGaaSbgP5Kbss51s1/nq0+TEC9rX+?=
 =?us-ascii?Q?I1BvYl1nhF81WFOuKFE4UMWlilu3tTOWrIrmCWXUiSTzvjXESOeZx/7wd4Dz?=
 =?us-ascii?Q?iZNjTcK0qgdE2UuEhDQ1M2dfxKC9PDDJCYluRW+TZ/h0IFWNjgK4LEJFr5Cn?=
 =?us-ascii?Q?tJXJYc4/z0Qf2QmTx7ZbdLXWB+LHJn0J6IQfpOf4?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fbae2fc-60d8-410b-c005-08dc755d1103
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6411.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 04:02:55.9240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bMPuntpMXOEpsuoHncs1KT0rYuFKwI2ZKKMrZrTk2sZIXIJc4XE1cIkn8LQQLyuAeQvgfh1KMjBE/tiU3+1Isw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6807

__send_empty_flush() sends empty flush bios to every target in the
dm_table. However, if the num_targets exceeds the number of block
devices in the dm_table's device list, it could lead to multiple
invocations of __send_duplicate_bios() for the same block device.
Typically, a single thread sending numerous empty flush bios to one
block device is redundant, as these bios are likely to be merged by the
flush state machine. In scenarios where num_targets significantly
outweighs the number of block devices, such behavior may result in a
noteworthy decrease in performance.

This is a real-world scenario that we have encountered:
1) Call fallocate(file_fd, 0, 0, SZ_8G)
2) Call ioctl(file_fd, FS_IOC_FIEMAP, fiemap). In situations of severe
file system fragmentation, fiemap->fm_mapped_extents may exceed 1000.
3) Create a dm-linear device based on fiemap->fm_extents
4) Create a snapshot-cow device based on the dm-linear device 

Perf diff of fio test:
  fio --group_reporting --name=benchmark --filename=/dev/mapper/example \
      --ioengine=sync --invalidate=1 --numjobs=16 --rw=randwrite \
      --blocksize=4k --size=2G --time_based --runtime=30 --fdatasync=1

Scenario one:
  for i in {0..1023}; do
    echo $((8000*$i)) 8000 linear /dev/sda2 $((16384*$i))
  done | sudo dmsetup create example

  Before: bw=857KiB/
  After:  bw=30.8MiB/s    +3580%

Scenario two:
  for i in {0..1023}; do
    if [[ $i -gt 511 ]]; then
      echo $((8000*$i)) 8000 linear /dev/nvme0n1p6 $((16384*$i))
    else
      echo $((8000*$i)) 8000 linear /dev/sda2 $((16384*$i))
    fi
  done | sudo dmsetup create example

  Before: bw=1470KiB/
  After:  bw=33.9MiB/s    +2261%

Any comments are welcome!

V3:
-- Focus on targets with num_flush_bios equal to 1 to simplify the code
-- Use t->devices_lock to protect the dm_table's device list

V2:
-- Split into smaller pieces that are easier to review
-- Add flush_pass_around, suggested by Mikulas Patocka
-- Handling different target types separately

Yang Yang (5):
  dm: introduce flush_pass_around flag
  dm: add __send_empty_flush_bios() helper
  dm: support retrieving struct dm_target from struct dm_dev
  dm: Avoid sending redundant empty flush bios to the same block device
  dm linear: enable flush optimization function

 drivers/md/dm-core.h          |  3 +++
 drivers/md/dm-ioctl.c         |  4 ++++
 drivers/md/dm-linear.c        |  1 +
 drivers/md/dm-table.c         | 19 +++++++++++++++++++
 drivers/md/dm.c               | 34 +++++++++++++++++++++++++---------
 include/linux/device-mapper.h |  6 ++++++
 6 files changed, 58 insertions(+), 9 deletions(-)

-- 
2.34.1

