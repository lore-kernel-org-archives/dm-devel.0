Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2086.outbound.protection.outlook.com [40.107.255.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C066FFC1F
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 09:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.255.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715677549; cv=fail; b=O4UwmH324RlPS9LfJo1c0XNRvqtqwhVvcDeaw9kHf2TB9V8OcN+rvEWhkU/8DdR4IQuYDmYqXcx9+U9O/IQ/MSYxVC/zYZdKZI5EAvNGyf8KHqgq3GI+Y/MFz/kYfcRvrqt4uSt95G3zDEJ1sf7YAlv1bP6nA8SmUm5lP0Nr+7o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715677549; c=relaxed/simple;
	bh=liVHYinpXH3a2/7J6fbY7ikGg3OeqjmcxDvXrthCT+A=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=BEn4kUaf/JAjKh+g9UB+9EwBJD0Sjvc0ful6wUCYzAJNCJZkaZJDe02NNg8/4mE1m4bYqPl4a7t2PjEDzzLdISd+Eu2xmVFQbQy+Q0sV7Oxn8bpN/pu97+tvXrv1dRmTUamT+E3xP31gjofdufMTdXkpXHRDWi11OaxUaXDW6jU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=nTEl3qxi; arc=fail smtp.client-ip=40.107.255.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="nTEl3qxi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IGKsAX1hVQGxC/g2srUzUVvkSvKuZu8UepW1Sfk/8sJD2uw21I4fBhCN8i3zg5LTqL/BXvAHrDZzAT18U0MKrEBeBoi3vJUP7h2h8xgJuwfLCKbUiYgV/FGkLkJM6o+BlJgvv4vgL/lq1NUynITw60LASkNwnMltKtj5xIVsep8Y2wwXlKXA8XBH7lMb01aYs505lsbNWbAgyj3jE6uuCYa6Vt3o4H3XoJQVlCkQPUowC50IFE+kAcRxr8KqW7gE/S8pV0LnEZTJhaiB1LzL/wRkhdABD3Bjkl731uPvEY7ClCCRhMf7Mn2Z4uFvzRM7VzAo4vDKgGiNt8ATDUR6vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BaE3wqdZHaqdvXtGnMdNijadmmg118QT7oTKiNY6NRM=;
 b=V30nQO7eoPzoBdOTQxdpkUE8RpjrJ58cyN4PcQlomRuNRn/0mCopcmWXwHQTuquiEDuggZDD6hbupjsh1MN/mIeDrnu54JAlsTeESYdTwiendzrG7a1ReoILaMmR1G9MZfhWQjBDH1m1h18T29t7RCEM9LKudZD0QQkP1oM13AY9LnjR/FYJ/dFa1PieopI0TLyXskgKF4XMF/tUSxtJVfnISENP5jOIEsPsiIZ2EHK1PJknwZM49rhJFullsmFxSPuI4zzccswlPbgqGMu6YQvIfPRuFmx5MZvhasQt+B0edkNhj79GTgJmHsY50PO3RKxfZxeFOU0x3oWLwbZmnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BaE3wqdZHaqdvXtGnMdNijadmmg118QT7oTKiNY6NRM=;
 b=nTEl3qxi6EmIOddEsMhb5cPmeOYHhmVXCdHCLf02zgT+dH16+JFZtV4DzKafdNjItVpD37SlyP7JbP015utXEbbndsBNhBRKGZ+Osk+vu8spvqsBVp9Z/sefSsPY70y5msZqivobz7FXgpIFlN33cUQxGScTg2/HM/MR3IO+wt0yzVOycM8Ea0BbPLCkk7P1CBfIS9oLa+CxftUeqain/n+ZxJxTYxjTGvTVkVQW/Tp0zkhu6AFAyFv9Jj01JlEDAYygw8wob6U0+k5kVHvEKLdSL6A9hSkJpi6y1qYn1mY4wLatM0Bzm5+FGRoYEh5nRBbSS/b2nuTp5ha4KvFYDQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEYPR06MB6398.apcprd06.prod.outlook.com (2603:1096:101:145::9)
 by PUZPR06MB6102.apcprd06.prod.outlook.com (2603:1096:301:112::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Tue, 14 May
 2024 09:05:44 +0000
Received: from SEYPR06MB6398.apcprd06.prod.outlook.com
 ([fe80::9784:d8bc:5eb5:b60e]) by SEYPR06MB6398.apcprd06.prod.outlook.com
 ([fe80::9784:d8bc:5eb5:b60e%6]) with mapi id 15.20.7544.052; Tue, 14 May 2024
 09:05:44 +0000
From: Yang Yang <yang.yang@vivo.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Yang Yang <yang.yang@vivo.com>
Subject: [PATCH 0/5] dm: empty flush optimization
Date: Tue, 14 May 2024 17:04:39 +0800
Message-Id: <20240514090445.2847-1-yang.yang@vivo.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-Office365-Filtering-Correlation-Id: d1326706-5b1b-4440-71fb-08dc73f50973
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|52116005|1800799015|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3c+LMXYh1G00/9coL4yrniZB4lbR6kKQEw+/W38bim2QTWxB6cJIUvSoZApR?=
 =?us-ascii?Q?1udTg6dof5Rv67B0UG9W43Mb7uzC53S4pXZ/KLFQ8JjbV1gfFUY+Vsu6un5y?=
 =?us-ascii?Q?lJvwOyGtye4Y5DYkmj76woDKNJxrJHRmVetmZGyIOT0OKv6LlNvdRFsNq5Ab?=
 =?us-ascii?Q?5OkLlgjPoHGYJIvRoi2BuF9tgfYzySn+2lKGdAMMFF3E/FIf67ltlEjpURQ/?=
 =?us-ascii?Q?grIerMdXGUCK1qbs+CCZNwBGtcNXsGYZ0dE1p3/2WRAWg9Qhmsi3p632LvIU?=
 =?us-ascii?Q?/1zvx8WuC0KzobZHEYM880clTx3Iy1WSgmod7kV/zPjOcKp1xbtsBH4A3zet?=
 =?us-ascii?Q?9Pdatf4p7aJyW1ll+Ot/u4EcquxpWli5WKNDW84V45PbIrxpepunOA9VOGs5?=
 =?us-ascii?Q?WNF01gu2gdx00LUhs6GK066jGQ1XaHa4o2eYV1R5DGfo2g++n2z5p4vsLn0I?=
 =?us-ascii?Q?bKtUyqvVHi13hedzfxuVXWkss2zuxpp4lt7Lnwu0+OD/Z+zHdSfhz9dhwb+8?=
 =?us-ascii?Q?7b1mveT9ZWPm5Gdi90A5Q15Hp5bFuF9AFCZYwGX7SwiiGVEDJKcQIENRfwJa?=
 =?us-ascii?Q?bBCznsQQ5upasmRJyKtfgbDE4XQJoYKhF9cOf6S/ExNNvJ5k9wUEihsJG4h7?=
 =?us-ascii?Q?XcDL+rrxfqGXsFZaVrwLW/mKSnYn+YrxUas8kK9UCgDB7p5q63chAXGel020?=
 =?us-ascii?Q?fjM1t9wSo6MVrAhB+xE+Bie2tBPqLcw0ElTmbyIPY1DHXjozOr66QSx+ag4Y?=
 =?us-ascii?Q?8d7titwM4glBo6kyvxEPaxDTqGp0F+3+wP1AuA3JnAGnX8mw0zDBAomhIBjw?=
 =?us-ascii?Q?A8kIM6TRZ972IO8uPVhEo/BqCYWoISFCEm5qJ2aom+BQai2WJvUz7wjtHbPw?=
 =?us-ascii?Q?Vl7T4zEKT4T6ZmM2TuzaIMNz2DCMoYj1IbIdS5XDFabwy63n1aYBykabY70r?=
 =?us-ascii?Q?6poqyHoEBW4Yho1JIj/oIW3Xjc5On9kKrhik1zq/48zw/2pU9yoV+l14MuiI?=
 =?us-ascii?Q?ww3LR060Xu3HnaMezro5RIJJPj2YFC3Bn4WXQUZ9uAx6m6icVPuSuEZQpxAz?=
 =?us-ascii?Q?o3Vp4i56OgGajVtTCu67/DM1c5ieOPFnwh43uAMdcSq/fao6x1MKuJY67w42?=
 =?us-ascii?Q?AnuhhODmT4OkSg4plguhRcsn94x+L9RmDPzGn0pChD9plgUZGT20U1aGxAAb?=
 =?us-ascii?Q?Gil+r9lzXqr7hIVwKdYytvA3k6aL6E1asE4uIDf05Ib/Qrkc/4GFfOrI5dwY?=
 =?us-ascii?Q?XZKu40qD3Y7BROC6OOKJfUPWyziC/gHFTB+HDzQHXsKq3jXGFsfSf4oIAAV5?=
 =?us-ascii?Q?NDgXn9FQmQvXRu/0IESHWPn+5SkgUqrKmLDXU/mE48Xqcw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEYPR06MB6398.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(52116005)(1800799015)(366007)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CwmoEReDlZaCydgVHFHAvVlpTKRd/5SUzqVZOKiGLKljZDPvKXvxXQLAk+Xu?=
 =?us-ascii?Q?Grpq1CdBh+mSQEa9b026CWBq7uExw21SmpRrbB1YU+esQnN7y7ZO13te5V7y?=
 =?us-ascii?Q?K//2/9THdcinqcZu8RCNEts+YGHBzKU34KiMNhYFUr0dhDg+2WDfjHv1VeE2?=
 =?us-ascii?Q?b3rLEn+gmb14pX5ZrLTgA6eJ2706PbahKGV9kPx6D1rhXm/t+rbX14t8mCew?=
 =?us-ascii?Q?d5sPAwc+Y4/FSqG5Qnd5dvZY37WJ//+E0WBnsxi9eZqZxVHbTBfBm0uTcbfm?=
 =?us-ascii?Q?TobU/uMz7OhJ/i/yX/kuRvFWXcS+SY0kx5oYkn6XFcSWksdvpFTpAEN70EGn?=
 =?us-ascii?Q?3bGlakA94O7t7NM/Ym16lZkm0imy2cQuJvbfNfCNZeNElBxq+9s8H6UPClkT?=
 =?us-ascii?Q?4ZON6Fhoj9YvvPuHl2FTyqcmMJA07oLK+1K+uChk6N7anjSZNxV2Hlr5TRnJ?=
 =?us-ascii?Q?HPY3Lic5DbvVkqgC84XK9BM4gVubmVrBGWZ5s3NbXhEnd10Xo/gUR/DDNuIn?=
 =?us-ascii?Q?MJPKyE7JR3MVfaerwOZ1Sf1LZiyoghGONcoLNOrDLvZY6uXrqXny7KxtjwH7?=
 =?us-ascii?Q?vNxYzJ+J35UJtd4Rjl+mzmFrV9UE8JJI0j4QWV9j3kGfYdecd3o5Oa1UVnEU?=
 =?us-ascii?Q?fT4AVNluDP7sbeI/r7uGkSqotdXCw3KJZuIO1J5SC2qTBNPC7QOF/YyQsAhI?=
 =?us-ascii?Q?HYWmhykI7AQuHYM24kphkHVpzwUaf8uG1Mc3Ig6hEBTzpOABCAR0af7GqVfb?=
 =?us-ascii?Q?nmK2quK0Rckfj4y4qGpTopq1FaHm5ylv1CjtHKbOXiYWi5M7ozzR7jxXPSjN?=
 =?us-ascii?Q?P+KW5oHnmzhFbseBn2RxvgQRpRC5QRRnTsHjxqSu//gENT7wpuk6JcPsAU7Q?=
 =?us-ascii?Q?GLW+D7GBz9Y54D2vB+0d9GajiQhahOflgIv1PGny6MNcux7i8Qut8rgKMaQc?=
 =?us-ascii?Q?l8PjDwwIJ1ex/PGetatOqV2l+Z/5OtWO4XSRC64ox6U/aUpZIJI5tTxdX1o+?=
 =?us-ascii?Q?j9jV/gbbPxKZ+Tpj8hxvq1BvSgsPBfuqP/mWPNr1UhZZE3P9ZadyNhBJ6qFd?=
 =?us-ascii?Q?fpnMmlqgfcNuYj2tztGNelZzh1zCLQbrjEnDZiXCmZNjfoDi81Hzu6+VFsOo?=
 =?us-ascii?Q?QqJCBz1MfIXUoyLdep+WmAcYER2qe4jBfpMXRHw0w4pFtAGkA/S7H1Vy94x0?=
 =?us-ascii?Q?tQH1abyhVFzB1yH8QyntdgdW+0X78GA5FiVtkIanUOquMaBjNM5etikMPZ5m?=
 =?us-ascii?Q?mNGz4hE4cQLH1c+uuJCh3boqBZym5gmJeLAllD1jiACNyFn0CTZMru9i4Q/f?=
 =?us-ascii?Q?l8A/cgdbrcUHlxfVTKHrfE0LwE1CmxsUB0aaU5LcxsuPopkC/nBdVV6sIjWe?=
 =?us-ascii?Q?4AfxW0AmowEJQixNMOV+53rqX1/6xUW++6utZgkDHm6PfLGM+jUWbPFshaQp?=
 =?us-ascii?Q?1fabfx7+X5VFCer5PGuDXLKbWHd1HQrGMNZHOe39uqJ23IUBHM2pFZgFjImo?=
 =?us-ascii?Q?hkSPGYWmcf+V1pJoTLrnzStVgyv5viJSacAtlLmOdS+C3DsfJCI4rwCbfL30?=
 =?us-ascii?Q?o029Vjg2hYfL7VFUIC82ssZ7YlcX4SfgXCjzK28b?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1326706-5b1b-4440-71fb-08dc73f50973
X-MS-Exchange-CrossTenant-AuthSource: SEYPR06MB6398.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2024 09:05:44.4552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E2NdhLQMuV9wt4G0+UcdqnWvGwCPEs3XRk3u1H/GtjSdF5ZkIjW9ISvK49JNXoXJP5F//UtDi+0oVFnoceHTuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB6102

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
 drivers/md/dm-table.c         | 39 +++++++++++++++++++++++++++++++++++
 drivers/md/dm.c               | 37 +++++++++++++++++++++++++--------
 include/linux/device-mapper.h |  8 +++++++
 6 files changed, 83 insertions(+), 9 deletions(-)

-- 
2.34.1

