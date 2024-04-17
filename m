Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2087.outbound.protection.outlook.com [40.107.117.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC79D7D06E
	for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 08:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713341072; cv=fail; b=PXNagm0cZdjk+6pfOMYxShMJ+lPEVWTMoJAm2uFuWlFY+YRDKWsXjo2WcGrWXxDiz5ifa02Le2ycV0u7XjxnS7cohm+7+mdhXJwohKGULhKowJmBbpH04qcc6/NVladL02JvPjEDd5xj989MIgPuhigwchakDWfFBKVlk4eW9kY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713341072; c=relaxed/simple;
	bh=zkcRz3wVXbRLdWQlSuOoZqiweRUrhOHHPcIDkju2Lms=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=BdTNxm763EC5R3zCQtx7Sk9peJum05V1wYgS9AqhEqo17AVVBaoZ6bEIMXeGDyr/0Z5/2G092p6Lfq+hRqqtoG0zlRGnDU1fwo0VxPHS3w1fyAIEjUWwGio3jsecIMgK4UpGoE6j4OCEkZFO3c02Y22oQp2o8IrRtIwhreIXoOQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=df2uXNFT; arc=fail smtp.client-ip=40.107.117.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="df2uXNFT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0n88Efxz1jqyTwUH/pCsX6PKA7dpiWZy/BGRlKCEYJmmhQeer3O8lsBM1Xn+TOA30cztgzWX3RhCWxlewS2B+YT5CQcFF8Qcuy4nHFLxd+Ib56KS2x896aRyiIJJtFgkmloMQcMii+Q2xv0VrpHtdDj0/jONz5L2dGuQtdlYt5qfLtWiKSXMaImDNdylV6S8dzewKDoVE3LTmJawTa8aCPUOHshjQ50ro9QT7OQrAAyOWzk3UGWVdPSrdAaDNiErBIlu64sQUP8mCbpXohr3vTBb+eR57mK+NXl3sOE4vb2qpyVGHAjOsaUcUbxma8IG1vuImCxORywr1kx7TOaNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=msSiQsbO5mdiWzvTW2gO1Ngk7B+FDQNoL7e2nHr3x8w=;
 b=FqpNWpD/62Ib6vLbxIx5sHZrr9CcBqfDgfQb4vNeFDBNPI5Xz/cs3kgDKEuREdJqmH1B0JIeOR7blSpV4IsEIjyS/ExjwRIBCODmPnIt0sFf93UU4RGyZ/Z78yMK8sV7ujm/ybwf8WXe8OJmHFovId3V/Bwm/vOwhDl1bAlGVsBFbnPaELjWQQUHs3jyOuZgsR2ar7O1/QCe5HAA7yZrysAbe54HfFHwGe1tjRFkE0H8Nf8gE/HR/vtP4gEBZGkMIx1SnfyJS5wZ1GEzDUhZgBpCxzyzH5QJzlRMs7eSeEavuJGTtKHGWoJej/wGkU79t27EYO0E56yYI8wYT3ZbBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=msSiQsbO5mdiWzvTW2gO1Ngk7B+FDQNoL7e2nHr3x8w=;
 b=df2uXNFTfq6UgUwfF7w8QaygFcxzoVncU7YdRPVo2QK2yRx/uBqU6JKPlUjXb5zrwtFoL6kcLibtYNvJpaEHOXdsS7+F5fg59aFoFDLA5tcKAAAM9q93JzL7NSu1g0QXOg/8dIaPVCtabh4vRaHNpSzoBhzmZZnfQ0SpgvsHxBdbQP4LXc/tkETdZQ5mA988AR7a8GZCwIx9ZhyAFdygv1/8D5UypZLhLHNOi4/HikD82hhcck9i8zzn6Igy8hcgnN0e6kaCdHcl5hcYei15o80CnktqLX0QWvxXDbr4WKoaYraYjx2jw6vAAc0vxIVs70YY2kmISZ/MX4ITjE922Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com (2603:1096:400:42a::11)
 by OSQPR06MB7181.apcprd06.prod.outlook.com (2603:1096:604:291::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.55; Wed, 17 Apr
 2024 08:04:21 +0000
Received: from TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::af33:ff9c:cf31:45e9]) by TYSPR06MB6411.apcprd06.prod.outlook.com
 ([fe80::af33:ff9c:cf31:45e9%3]) with mapi id 15.20.7452.049; Wed, 17 Apr 2024
 08:04:20 +0000
From: Yang Yang <yang.yang@vivo.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Yang Yang <yang.yang@vivo.com>
Subject: [PATCH] dm: Avoid sending redundant empty flush bios to the same block device
Date: Wed, 17 Apr 2024 16:03:31 +0800
Message-Id: <20240417080332.9288-1-yang.yang@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0004.apcprd06.prod.outlook.com
 (2603:1096:404:42::16) To TYSPR06MB6411.apcprd06.prod.outlook.com
 (2603:1096:400:42a::11)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYSPR06MB6411:EE_|OSQPR06MB7181:EE_
X-MS-Office365-Filtering-Correlation-Id: a8ce3f85-79cd-4d62-ea6a-08dc5eb4fcab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	KNPq9WVY6qLaiQX0mSIRUKhBqFVnJ7czpBYrhiVaFlGuK+FfjCs92dWLirsJb8wPjmkl2tYi/i5X1GktPjrLFOY3wHcUs2u5thcwL27yXkLgE+ofiUMWJGNvVVuldHIaE36z3FEq2o/0LuLjCiy9s5jx2PGuKdq9kCMXhwaGszqCUjcRXqVOBph31dxG1QrS9CNiZhy1tuECK6l1c++IbbBRtlfmX+aoJphxMLpcjXkbQYU9VAWufp0XnIOHd3fyAjutrmJv7K2qRQhJbMRa5B/4l9r3GQyJGczEuxbWw9PrtOdTZZmXWqqdPBbjMKJffOeC1t9zqMQKct+fJo/N7tjwovNCwCFCaqsQDunp/vYRwT3SH+HcQ+E6NVm3wOG5E7rmnTnH8zDARArOmKot9TWBiRt3NfhAquMG69P5cxIFkXmfcT1KILtwAhxyJQPI0gwnuNAMLF97yFWAykrWAsRYvl+ng7HNG/ADZKIb1LazbTiW/faoRQXx0teKtRZrjUVO0b5oIcISpDFB/jOFD+S2CzBuT7jgph/edtRCTB2MUuPmYfbI6F/NNFCt9ubB58SVPiT/Jd2aplO0qj/9fLm4oO/CDMjHD+dVksGcU4eDZS0ItURtH/SYmYlG0UGYMgYtbY89hkyzN2J8Qqksj0+z22UX+vP/m4BtgCIYVnlHu/We3IyEteEnHwQUv6ZFdS/3ER/jzI62/69IhydZ1Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6411.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(52116005)(1800799015)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kPZ0v4lg+JtVUMSoOkJAE4sJOF/jzFTEQaRlz6/Yav4wwiYtHre9YsrMdQEe?=
 =?us-ascii?Q?tluDTZDqUynW6pxK3iI1uHD9lkZFk3V5E9MBw0+Y9T3YdGJZ4SEBMnrdc7sI?=
 =?us-ascii?Q?EDgDgcgKAyhs1mlVnpNcECymQ2zQNcMjQT/phtN7lvYjr5uY4P7B9+aNGkzK?=
 =?us-ascii?Q?9ZDcTEqzTXH2oXsC6qa6B6ZcnFgccS7LPVsBEjYq2XBXx+M3tGbJQUsPLWs9?=
 =?us-ascii?Q?3V1SK3SfT04yZKWTfC28T1CHXofIbkeR1lZUAd4aQsW1cdfhnWIEyYklaZYG?=
 =?us-ascii?Q?GhPyx2Nbf1VLtd0WWeL5WPb1+vxdLGnZwicrqrhEHmF60Fuq3Fc0Kjgoq+PJ?=
 =?us-ascii?Q?mH4STky//ANok/KetrG9in+F1iRBCwNwbAreibATJCaJtRGCewSINe6Mexuj?=
 =?us-ascii?Q?edQV/GbLk9ipfjg9cpnJ4tROewiqYSBUNhwDl6ZpDuyGM+H1nbnG1pckue39?=
 =?us-ascii?Q?Qv6t1yc1SkiSEZpCL9cKBscmX2KmFbZA6XR7wh3jUizdIGlPldRmIZSGdLI/?=
 =?us-ascii?Q?20FbZ9BbI1zyhidU5WpI5NpgPZmfySAcwvs59VmSX4MhxEXod9xErPG8xw/i?=
 =?us-ascii?Q?TQ65kUEqyj2kLkJjmVgAD6QRgFlONBo+MRp1BKFQZHNvZlV9BLjoDJNaxWJw?=
 =?us-ascii?Q?XoEMjWSmTMw49IZ/bJUeQU3W6y9mBCPt14XnucGB9/Fm5bIi9ma4xWkGF56d?=
 =?us-ascii?Q?xCkTIk2o2pAyRSrdOO2E6p6YDC/fE7aYiNcp0zzUZswA66MySS9thlVHhw/Z?=
 =?us-ascii?Q?LEE+ApGTYk4LK1BDBjhUB9y4WyrzKuf9Cag4ig29HrwE6w9llzJdGj/RK/NH?=
 =?us-ascii?Q?tzlc2+qpee2VvIDbgcwmkKjcLGJNpVvIxi1Sk8NDPBkNQ08eJrJTRWdtPXwu?=
 =?us-ascii?Q?nH1VYr7FxEC20JHJHXYHQE8eUut+DoAIprLLF9FEOvVva804klPViYLpd47Q?=
 =?us-ascii?Q?7WgX1jVVw8d1mr0XpaMQoReUx/C4CrUL4egCTXS0Qu3tFSo0TdrbDUtf7oR4?=
 =?us-ascii?Q?0wekGkZlJCWHRQecfeWuqaQoKtpFOrieNrfNFKzkdrq8KEg4FbXJudoIrlEe?=
 =?us-ascii?Q?UX+G0Mp4jScJUdEW2i3j83EQWPbQrmtnhSdNAmIulJgsCUanosG7Qe/NUIFR?=
 =?us-ascii?Q?9VYBanFayvqu1mLf0BLG53qROMYRyg9Ei1mwURve6BV1GMDSynRowBO/b58q?=
 =?us-ascii?Q?vfyuQ0KWoSDOwSyNBFZK5hd7nGQsdmZbOAUtd+nwN/TSVHIftfcLbx0+Ji/y?=
 =?us-ascii?Q?QPvCry15usCRbWGFlY27YpqLkJCBMUjI3PUFlXEWIzPe4bjNfVpiik2FC2sC?=
 =?us-ascii?Q?06NLRxKVJzAzqhoVDmgPiLzGPhVLPmaBfTPxr0ifwk2CPOutj59bnN8AL0zV?=
 =?us-ascii?Q?bCw1oWiDHW9pvceBpsTHzYTCgdGONtpgQdz187W/OtxmQU3pNGXeqPTMqxSh?=
 =?us-ascii?Q?in3vexa+pXhTynk9LtbOevNApfL459HPmH9WuhDEs2xm04DR/nFjhjP4P6tQ?=
 =?us-ascii?Q?4RXSYaj6zXrCB6XjclI34AZ+62G8bkUKL0I0qweAqmigP9Ak+r7UNNsG8ZzY?=
 =?us-ascii?Q?XwafuQKoK4WZ3yyD5QT8luGCpo7I1mQ8SZi6ZVS5?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8ce3f85-79cd-4d62-ea6a-08dc5eb4fcab
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6411.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2024 08:04:20.7553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VXfIbANN/Ug2ZqEdygvytMQEV73k8fP9GMfv/ER2XrfXdaIhNvXmaIp684qNRrHCxF0VWbg1+clHdbg5rq9KgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR06MB7181

__send_empty_flush() sends empty flush bios to every target in the
dm_table. However, if the num_targets exceeds the number of block
devices in the dm_table's device list, it could lead to multiple
invocations of __send_duplicate_bios() for the same block device.
Typically, a single thread sending numerous empty flush bios to one
block device is redundant, as these bios are likely to be merged by the
flush state machine. In scenarios where num_targets significantly
outweighs the number of block devices, such behavior may result in a
noteworthy decrease in performance.

This issue can be reproduced using this command line:
  for i in {0..1023}; do
    echo $((8000*$i)) 8000 linear /dev/sda2 $((16384*$i))
  done | dmsetup create example

With this fix, a random write with fsync workload executed with the
following fio command:

  fio --group_reporting --name=benchmark --filename=/dev/mapper/example \
      --ioengine=sync --invalidate=1 --numjobs=16 --rw=randwrite \
      --blocksize=4k --size=2G --time_based --runtime=30 --fdatasync=1

results in an increase from 857 KB/s to 30.8 MB/s of the write
throughput (3580% increase).

Signed-off-by: Yang Yang <yang.yang@vivo.com>
---
 drivers/md/dm-core.h          |  1 +
 drivers/md/dm-table.c         |  7 ++++
 drivers/md/dm.c               | 60 +++++++++++++++++++++++++++++++++++
 include/linux/device-mapper.h |  6 ++++
 4 files changed, 74 insertions(+)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index e6757a30dcca..7e3f2168289f 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -217,6 +217,7 @@ struct dm_table {
 	/* a list of devices used by this table */
 	struct list_head devices;
 	struct rw_semaphore devices_lock;
+	unsigned short num_devices;
 
 	/* events get handed up using this callback */
 	void (*event_fn)(void *data);
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 41f1d731ae5a..ddc60e498afb 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -2133,6 +2133,8 @@ void dm_table_postsuspend_targets(struct dm_table *t)
 
 int dm_table_resume_targets(struct dm_table *t)
 {
+	struct list_head *devices = dm_table_get_devices(t);
+	struct dm_dev_internal *dd;
 	unsigned int i;
 	int r = 0;
 
@@ -2159,6 +2161,11 @@ int dm_table_resume_targets(struct dm_table *t)
 			ti->type->resume(ti);
 	}
 
+	t->num_devices = 0;
+
+	list_for_each_entry(dd, devices, list)
+		dd->dm_dev->index = ++(t->num_devices);
+
 	return 0;
 }
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 56aa2a8b9d71..e46bafa13601 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -48,6 +48,8 @@
  */
 #define REQ_DM_POLL_LIST	REQ_DRV
 
+#define DM_MAX_TABLE_DEVICES	1024
+
 static const char *_name = DM_NAME;
 
 static unsigned int major;
@@ -1543,10 +1545,39 @@ static unsigned int __send_duplicate_bios(struct clone_info *ci, struct dm_targe
 	return ret;
 }
 
+static inline bool has_redundant_flush(struct dm_table *t,
+		unsigned long **bitmap)
+{
+	/* Add a limit here to prevent excessive memory usage for bitmaps */
+	if (t->num_devices >= DM_MAX_TABLE_DEVICES)
+		return false;
+
+	if (t->num_devices < t->num_targets) {
+		/* dm_dev's index starts from 1, so need plus 1 here */
+		*bitmap = bitmap_zalloc(min(t->num_devices + 1, DM_MAX_TABLE_DEVICES),
+						GFP_KERNEL);
+		if (*bitmap)
+			return true;
+	}
+
+	return false;
+}
+
+static int dm_get_dev_index(struct dm_target *ti, struct dm_dev *dev,
+				     sector_t start, sector_t len, void *data)
+{
+	unsigned short *index = data;
+	*index = dev->index;
+	return 0;
+}
+
 static void __send_empty_flush(struct clone_info *ci)
 {
 	struct dm_table *t = ci->map;
 	struct bio flush_bio;
+	unsigned long *handled_map;
+	unsigned int nr_handled = 0;
+	bool check = has_redundant_flush(t, &handled_map);
 
 	/*
 	 * Use an on-stack bio for this, it's safe since we don't
@@ -1562,17 +1593,46 @@ static void __send_empty_flush(struct clone_info *ci)
 
 	for (unsigned int i = 0; i < t->num_targets; i++) {
 		unsigned int bios;
+		unsigned short index = 0;
 		struct dm_target *ti = dm_table_get_target(t, i);
 
 		if (unlikely(ti->num_flush_bios == 0))
 			continue;
 
+		/*
+		 * If the num_targets is greater than the number of block devices
+		 * in the dm_table's devices list, __send_empty_flush() might
+		 * invoke __send_duplicate_bios() multiple times for the same
+		 * block device. This could lead to a substantial decrease in
+		 * performance when num_targets significantly exceeds the number
+		 * of block devices.
+		 * Ensure that __send_duplicate_bios() is only called once for
+		 * each block device.
+		 */
+		if (check) {
+			if (nr_handled == t->num_devices)
+				break;
+
+			if (ti->type->iterate_devices)
+				ti->type->iterate_devices(ti, dm_get_dev_index, &index);
+
+			if (index > 0) {
+				if (__test_and_set_bit(index, handled_map))
+					continue;
+				else
+					nr_handled++;
+			}
+		}
+
 		atomic_add(ti->num_flush_bios, &ci->io->io_count);
 		bios = __send_duplicate_bios(ci, ti, ti->num_flush_bios,
 					     NULL, GFP_NOWAIT);
 		atomic_sub(ti->num_flush_bios - bios, &ci->io->io_count);
 	}
 
+	if (check)
+		bitmap_free(handled_map);
+
 	/*
 	 * alloc_io() takes one extra reference for submission, so the
 	 * reference won't reach 0 without the following subtraction
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 82b2195efaca..4a54b4f0a609 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -169,6 +169,12 @@ struct dm_dev {
 	struct dax_device *dax_dev;
 	blk_mode_t mode;
 	char name[16];
+
+	/*
+	 * sequential number for each dm_dev in dm_table's devices list,
+	 * start from 1
+	 */
+	unsigned short index;
 };
 
 /*
-- 
2.34.1

