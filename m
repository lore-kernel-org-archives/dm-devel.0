Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C8633F9;
	Wed,  1 May 2024 00:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714522180; cv=none; b=X/xiFv3lQh+ShCliQvd822FKVfGnfNCzeyVSth6Csvd8HTTr5YAT23ZUG4yohXLg3rqquLI0KAgSNMJt7H8knAt3mEumByKwUWoluvPQxCx/rCtbBiNGUt5ybfZPf6GlcUDnxXk7x1M+57s+ZV4+PbJ0YYNaZLP33M0tnC7eB2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714522180; c=relaxed/simple;
	bh=fFeesJRkVknw7/RMtxm8FMNxBrpXsSCO1ccVPKN7cd0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDZZ7MuRMEpJ54NFSwXCauXU3Tk/MkP/q7Gj5UZm3IOtjphalAKnw5re2s3PpLk2yMyhrmrNpCoAhY8K3gL1VGdTAvR905w6buv2f//DxYaSTHr8D6R0K9m2Pmd5vY9IN8ZJznL43B05bwLjJNzwBUSnZUU9W8tm51SXobIsu74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M9Jy2BKS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M9Jy2BKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFDFC2BBFC;
	Wed,  1 May 2024 00:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714522179;
	bh=fFeesJRkVknw7/RMtxm8FMNxBrpXsSCO1ccVPKN7cd0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=M9Jy2BKS1ydoEQYDyTT4+GfMFXaHLAzAZ5n/t1FOQFFoZ79xi03fg2bKXh2Au9/b7
	 r/s6H0kTWFkXB/CjHAWLODWpEZLIq8RORbKAGEjnHlrSEgKnxMHvBHEfZYNRuL/vq6
	 srX59bZwXe9H7rpx4zy3vel1BzcutPYXASrvL3TiErJYhjEexyDSAT4BueN+YqdCiY
	 Aifvryy99rWYyYiN7M06IRDjP/HM23yRDGOtj0qiUEiNLgIvbPJZFlA4mZeOgZodq+
	 HSTOrLXuYZGwHx1xWw3QW7AHjh5VWITeHOwae7c+WMHraEx/p2rSec7ar8jD8o9rPE
	 yT1PosPvkYPQA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 02/14] block: Exclude conventional zones when faking max open limit
Date: Wed,  1 May 2024 09:09:23 +0900
Message-ID: <20240501000935.100534-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240501000935.100534-1-dlemoal@kernel.org>
References: <20240501000935.100534-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For a device that has no limits for the maximum number of open and
active zones, we default to using the number of zones, limited to
BLK_ZONE_WPLUG_DEFAULT_POOL_SIZE (128), for the maximum number of open
zones indicated to the user. However, for a device that has conventional
zones and less zones than BLK_ZONE_WPLUG_DEFAULT_POOL_SIZE, we should
not account conventional zones and set the limit to the number of
sequential write required zones. Furthermore, for cases where the limit
is equal to the number of sequential write required zones, we can
advertize a limit of 0 to indicate "no limits".

Fix this by moving the zone write plug mempool resizing from
disk_revalidate_zone_resources() to disk_update_zone_resources() where
we can safely compute the number of conventional zones and update the
limits.

Fixes: 843283e96e5a ("block: Fake max open zones limit when there is no limit")
Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/blk-zoned.c | 42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index bad68277c0b2..6cf3e319513c 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1513,10 +1513,6 @@ static int disk_revalidate_zone_resources(struct gendisk *disk,
 	if (!disk->zone_wplugs_hash)
 		return disk_alloc_zone_resources(disk, pool_size);
 
-	/* Resize the zone write plug memory pool if needed. */
-	if (disk->zone_wplugs_pool->min_nr != pool_size)
-		return mempool_resize(disk->zone_wplugs_pool, pool_size);
-
 	return 0;
 }
 
@@ -1536,27 +1532,51 @@ static int disk_update_zone_resources(struct gendisk *disk,
 				      struct blk_revalidate_zone_args *args)
 {
 	struct request_queue *q = disk->queue;
+	unsigned int nr_seq_zones, nr_conv_zones = 0;
+	unsigned int pool_size;
 	struct queue_limits lim;
 
 	disk->nr_zones = args->nr_zones;
 	disk->zone_capacity = args->zone_capacity;
 	swap(disk->conv_zones_bitmap, args->conv_zones_bitmap);
+	if (disk->conv_zones_bitmap)
+		nr_conv_zones = bitmap_weight(disk->conv_zones_bitmap,
+					      disk->nr_zones);
+	if (nr_conv_zones >= disk->nr_zones) {
+		pr_warn("%s: Invalid number of conventional zones %u / %u\n",
+			disk->disk_name, nr_conv_zones, disk->nr_zones);
+		return -ENODEV;
+	}
+
+	if (!disk->zone_wplugs_pool)
+		return 0;
 
 	/*
-	 * If the device has no limit on the maximum number of open and active
+	 * If the device has no limits on the maximum number of open and active
 	 * zones, set its max open zone limit to the mempool size to indicate
 	 * to the user that there is a potential performance impact due to
 	 * dynamic zone write plug allocation when simultaneously writing to
 	 * more zones than the size of the mempool.
 	 */
-	if (disk->zone_wplugs_pool) {
-		lim = queue_limits_start_update(q);
-		if (!lim.max_open_zones && !lim.max_active_zones)
-			lim.max_open_zones = disk->zone_wplugs_pool->min_nr;
-		return queue_limits_commit_update(q, &lim);
+	lim = queue_limits_start_update(q);
+
+	nr_seq_zones = disk->nr_zones - nr_conv_zones;
+	pool_size = max(lim.max_open_zones, lim.max_active_zones);
+	if (!pool_size)
+		pool_size = min(BLK_ZONE_WPLUG_DEFAULT_POOL_SIZE, nr_seq_zones);
+
+	/* Resize the zone write plug memory pool if needed. */
+	if (disk->zone_wplugs_pool->min_nr != pool_size)
+		mempool_resize(disk->zone_wplugs_pool, pool_size);
+
+	if (!lim.max_open_zones && !lim.max_active_zones) {
+		if (pool_size < nr_seq_zones)
+			lim.max_open_zones = pool_size;
+		else
+			lim.max_open_zones = 0;
 	}
 
-	return 0;
+	return queue_limits_commit_update(q, &lim);
 }
 
 /*
-- 
2.44.0

