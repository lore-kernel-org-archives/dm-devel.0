Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6133D13DBB9
	for <dm-devel@lists.linux.dev>; Thu, 25 Jan 2024 16:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706201630; cv=none; b=PdL8x0Qja8XXlYdOeWae/Y4tq1FpNeahsaRE1KxGYynQTABRQSdIMcDe7AGRlJDxJNptwWwBz305z86S3ZuhttKjuXYW7jeW7pvAsqTUNJOO4LnETaO8mAYxKIYlln4WgWx4sMwqeGbcrP/D3X9eicPJTU4r2EenJQNIICrmX0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706201630; c=relaxed/simple;
	bh=MadywNv3PPpA8atuGcDj3Vd17mnoG/ezGAm6iZoKSro=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NE9UJvfVy9IF0Q9jut6WErMz/hrXDrNU73oxL3rMqVaxvVpKGwB6yl8x3ogD5Os7PmsQNSJ1Ij+lgsAV6Xbau84Y33bgrIkALhf2EXJIZih3rfzfCo6luqPm4//UjGvLuMf7LrKIjsEitx5IlDzu3R6NrIQRcKQfdZoeqCOLsRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gUw4ZSsa; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gUw4ZSsa"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1706201629; x=1737737629;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=MadywNv3PPpA8atuGcDj3Vd17mnoG/ezGAm6iZoKSro=;
  b=gUw4ZSsaMPVw6BDW2Ur1J4TOcTxSzQBkZf9W22xtg03oe80n3m6oCKaz
   ZGmnXALnNavnq0VoP2FIRh7IeV+rBAwqw5K1K6UAWv7J2bP7ZJPFH+hoI
   2bK2oqtnRsgrFKGy43U+4CqEhp7IUBbbAFBUUVa5wnsdB/ChPbEj6xFMK
   XtT6ImgkIq2XM5hQXScEZCBGHxRua2LF9stJ5KFQuenb+Ma5JsF2iYH5s
   xkh+tgSrYbTKZwnstgcLRpIpw3dXsZAaHag3bIASCGXH+DJbTLXZEXiXC
   6BhX9gDddZnDpVOF6Wflhkhu4s2fO8EMTEr0YzPXsxxEjIurAjayRA3ac
   Q==;
X-CSE-ConnectionGUID: qt6tztg5Td6/Oz/7KRaLlg==
X-CSE-MsgGUID: 2JiG61gJQjWTZAHT+Bmx3w==
X-IronPort-AV: E=Sophos;i="6.05,216,1701100800"; 
   d="scan'208";a="7456565"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 26 Jan 2024 00:53:44 +0800
IronPort-SDR: HYP6dqe4GqOHN8i7j11FySSKfVsTd6E+YxyCwS0DItVvfzsvEL9sKxAOfCqdzxjC60GB035faA
 pl2aWlpgqh2g==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Jan 2024 07:58:03 -0800
IronPort-SDR: iGbJfwTm9aux0HAHn2Hu4+5MaKexoPy7oBPg1gDFb4sShWjqtqNmtHUakx83XvcY7OzLhKfXSU
 svTD8SbpHGFQ==
WDCIronportException: Internal
Received: from unknown (HELO redsun91.ssa.fujisawa.hgst.com) ([10.149.66.6])
  by uls-op-cesaip01.wdc.com with ESMTP; 25 Jan 2024 08:53:41 -0800
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Date: Thu, 25 Jan 2024 08:53:26 -0800
Subject: [PATCH v2 3/5] btrfs: zoned: call blkdev_zone_mgmt in nofs scope
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240125-zonefs_nofs-v2-3-2d975c8c1690@wdc.com>
References: <20240125-zonefs_nofs-v2-0-2d975c8c1690@wdc.com>
In-Reply-To: <20240125-zonefs_nofs-v2-0-2d975c8c1690@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev, 
 Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, 
 David Sterba <dsterba@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>, 
 Chao Yu <chao@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
 Chaitanya Kulkarni <kch@nvidia.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
 Johannes Thumshirn <johannes.thumshirn@wdc.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1706201608; l=3714;
 i=johannes.thumshirn@wdc.com; s=20230613; h=from:subject:message-id;
 bh=MadywNv3PPpA8atuGcDj3Vd17mnoG/ezGAm6iZoKSro=;
 b=OeiWcP8kl57wFLapxrMUtXeqJjNXTQJbNM0ivK0560YCzP4hJ0iOZeaEiCTU0BJrEPblLrrlV
 hEAm7xgua+VD3na0CHCBXETqitu+y+6zukGX52zzUrvhHVDMFcgECJ1
X-Developer-Key: i=johannes.thumshirn@wdc.com; a=ed25519;
 pk=TGmHKs78FdPi+QhrViEvjKIGwReUGCfa+3LEnGoR2KM=

Add a memalloc_nofs scope around all calls to blkdev_zone_mgmt(). This
allows us to further get rid of the GFP_NOFS argument for
blkdev_zone_mgmt().

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 168af9d000d1..05640d61e435 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -824,11 +824,15 @@ static int sb_log_location(struct block_device *bdev, struct blk_zone *zones,
 			reset = &zones[1];
 
 		if (reset && reset->cond != BLK_ZONE_COND_EMPTY) {
+			unsigned int nofs_flags;
+
 			ASSERT(sb_zone_is_full(reset));
 
+			nofs_flags = memalloc_nofs_save();
 			ret = blkdev_zone_mgmt(bdev, REQ_OP_ZONE_RESET,
 					       reset->start, reset->len,
-					       GFP_NOFS);
+					       GFP_KERNEL);
+			memalloc_nofs_restore(nofs_flags);
 			if (ret)
 				return ret;
 
@@ -974,11 +978,14 @@ int btrfs_advance_sb_log(struct btrfs_device *device, int mirror)
 			 * explicit ZONE_FINISH is not necessary.
 			 */
 			if (zone->wp != zone->start + zone->capacity) {
+				unsigned int nofs_flags;
 				int ret;
 
+				nofs_flags = memalloc_nofs_save();
 				ret = blkdev_zone_mgmt(device->bdev,
 						REQ_OP_ZONE_FINISH, zone->start,
-						zone->len, GFP_NOFS);
+						zone->len, GFP_KERNEL);
+				memalloc_nofs_restore(nofs_flags);
 				if (ret)
 					return ret;
 			}
@@ -996,11 +1003,13 @@ int btrfs_advance_sb_log(struct btrfs_device *device, int mirror)
 
 int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror)
 {
+	unsigned int nofs_flags;
 	sector_t zone_sectors;
 	sector_t nr_sectors;
 	u8 zone_sectors_shift;
 	u32 sb_zone;
 	u32 nr_zones;
+	int ret;
 
 	zone_sectors = bdev_zone_sectors(bdev);
 	zone_sectors_shift = ilog2(zone_sectors);
@@ -1011,9 +1020,13 @@ int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror)
 	if (sb_zone + 1 >= nr_zones)
 		return -ENOENT;
 
-	return blkdev_zone_mgmt(bdev, REQ_OP_ZONE_RESET,
-				zone_start_sector(sb_zone, bdev),
-				zone_sectors * BTRFS_NR_SB_LOG_ZONES, GFP_NOFS);
+	nofs_flags = memalloc_nofs_save();
+	ret = blkdev_zone_mgmt(bdev, REQ_OP_ZONE_RESET,
+			       zone_start_sector(sb_zone, bdev),
+			       zone_sectors * BTRFS_NR_SB_LOG_ZONES,
+			       GFP_KERNEL);
+	memalloc_nofs_restore(nofs_flags);
+	return ret;
 }
 
 /*
@@ -1124,12 +1137,15 @@ static void btrfs_dev_clear_active_zone(struct btrfs_device *device, u64 pos)
 int btrfs_reset_device_zone(struct btrfs_device *device, u64 physical,
 			    u64 length, u64 *bytes)
 {
+	unsigned int nofs_flags;
 	int ret;
 
 	*bytes = 0;
+	nofs_flags = memalloc_nofs_save();
 	ret = blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_RESET,
 			       physical >> SECTOR_SHIFT, length >> SECTOR_SHIFT,
-			       GFP_NOFS);
+			       GFP_KERNEL);
+	memalloc_nofs_restore(nofs_flags);
 	if (ret)
 		return ret;
 
@@ -2234,14 +2250,17 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 		struct btrfs_device *device = map->stripes[i].dev;
 		const u64 physical = map->stripes[i].physical;
 		struct btrfs_zoned_device_info *zinfo = device->zone_info;
+		unsigned int nofs_flags;
 
 		if (zinfo->max_active_zones == 0)
 			continue;
 
+		nofs_flags = memalloc_nofs_save();
 		ret = blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
 				       physical >> SECTOR_SHIFT,
 				       zinfo->zone_size >> SECTOR_SHIFT,
-				       GFP_NOFS);
+				       GFP_KERNEL);
+		memalloc_nofs_restore(nofs_flags);
 
 		if (ret)
 			return ret;

-- 
2.43.0

