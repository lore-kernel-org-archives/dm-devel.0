Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E110A17164C;
	Tue, 30 Apr 2024 12:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481496; cv=none; b=uP/QOGmjdgFeKxLEzleB42y1N1fd3+3ECMGfHu8ck9PUPjBqKWQk9bN0S9gDMHHtfctJlSKEVRNXXUReFwncTCu8WP3Htsr27ofFUcvEC/LrU7trlVIeB1OMX3eVSItbAr8fWUYabuZ7mCzNrr2kqxrFDSEn+NbWeIrmVF7cSNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481496; c=relaxed/simple;
	bh=NkeWfqpZRcpRuri12wck+tEOdIlu09m2GlIdM9dPNyM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqQGQMOGi2fl6O3nrmaKZ7UL2AorsJNs4LuaZhCihFRcE4GueXluLPn5pK/r1ZoVEaCzZD8jRaT6u0viemCpksZbJxusR3aYkMDILXwUiWtKzsAyOTeJgKquHKoqpMerVDFlhg4XhzzS7qUnAJ0JU4+wGVbQx3X9iG+bN+anJ0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hZ5qm3wP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hZ5qm3wP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1B5C4AF1A;
	Tue, 30 Apr 2024 12:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714481495;
	bh=NkeWfqpZRcpRuri12wck+tEOdIlu09m2GlIdM9dPNyM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=hZ5qm3wPtk/hoBrE4o/BqW1JfyHdlo+qyjtHrZ+yPCYkcQi2x2s2FL4JLiCGIligg
	 92zUtEwnndbJ6pcN/ut3Vvy9RpTGqgFwVc/1tUOfH0UUjUPwKeX5hOqE8G1YTChV/P
	 wImMyAB2gSS09jlWgNiczdgI0NoleMMp87vxzKy4uhn3N5vFBSuTYpvZgwbYW3hOUN
	 bMeqT+OujY942fpKgXtDAUoQmSxt/EI70yf0TxM3kwInFvI3nP6vyo+nzejYzCkVNB
	 oNr9ZyYrqS7NHXRw/fkcfAU/451axi/azzbram6zIKfMkDCrk+KAoVTPkeS7eLCTlI
	 fEWhlCIrweXzw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 02/13] block: Exclude conventional zones when faking max open limit
Date: Tue, 30 Apr 2024 21:51:20 +0900
Message-ID: <20240430125131.668482-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430125131.668482-1-dlemoal@kernel.org>
References: <20240430125131.668482-1-dlemoal@kernel.org>
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

