Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB43C48CE0;
	Wed,  1 May 2024 11:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714561765; cv=none; b=eOCGIzn5+1+U0vnD1ldkNWBGhoM1WIoDZS92j5ZqNrWHnrksmRGqvYe9HSUztUgwMgZHGFlATQz3dojfYzuq7ueEBdqtqfjETuIt+ntyNfi0tUfBjq1SU66+kebFE2lCcm1KWWMBBaVVlGcfqcI+OS2966LCIcrEfpwCoKRS188=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714561765; c=relaxed/simple;
	bh=MSRDFEdBwPqkuZNym8HCtTIVxfyLWOeBU4cc8kv4sNY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKv3oLb+iD7U1MgfW3i6tpB2XPTQkqq7mOpIiDIFa3s3srqm4nAF9Xgjtywrt0ScY71pmrtbuwgF4QutyMFgJRggNihQrbwS3wKiTgPq9faZx2+3x0kRKYIZqGq3TSj3GmUKgS2kyvb3TTpkXpfhtgpA2JVaRIsnuqYT1Y/h8/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lRV8cXcg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lRV8cXcg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94F1C4AF1C;
	Wed,  1 May 2024 11:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714561765;
	bh=MSRDFEdBwPqkuZNym8HCtTIVxfyLWOeBU4cc8kv4sNY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=lRV8cXcgGuBS9hVahaGt9hDh76jPCtM6eE7oBF4J36fXObNyDgRAg2Pocd/VMoVhj
	 LEqqo6f/yLONgm/Xh+NxHRjQdfOIIF6bNGRDLlmWoSVy/1L5LkKOBC3LLaLpoe0BFh
	 UG3CWivqE8bt9uNvIPOBTETygXrFbRbT3/dpG9igPbHO/p7TM2uT5XvgZU4p6dhMyg
	 xIYCBmT/dSd0jHnRHXDzH1Fzj8TDJiMXOHIatGoNmpmQc+RpN5IBb/jb8+1e9q3P4m
	 sD+wzfB0WYwDk1Ao+mu3yGlXrNTsHidWqdmvGIzi5S3O72oHTCIX5m7Z0oLizDhzTL
	 L7Fp1t4FxJCHg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 14/14] block: Cleanup blk_revalidate_zone_cb()
Date: Wed,  1 May 2024 20:09:07 +0900
Message-ID: <20240501110907.96950-15-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240501110907.96950-1-dlemoal@kernel.org>
References: <20240501110907.96950-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define the code for checking conventional and sequential write required
zones suing the functions blk_revalidate_conv_zone() and
blk_revalidate_seq_zone() respectively. This simplifies the zone type
switch-case in blk_revalidate_zone_cb().

No functional changes.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c | 129 +++++++++++++++++++++++++++-------------------
 1 file changed, 77 insertions(+), 52 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 15e4e14e16f7..48e5e3bbb89c 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1656,6 +1656,74 @@ static int disk_update_zone_resources(struct gendisk *disk,
 	return queue_limits_commit_update(q, &lim);
 }
 
+static int blk_revalidate_conv_zone(struct blk_zone *zone, unsigned int idx,
+				    struct blk_revalidate_zone_args *args)
+{
+	struct gendisk *disk = args->disk;
+	struct request_queue *q = disk->queue;
+
+	if (zone->capacity != zone->len) {
+		pr_warn("%s: Invalid conventional zone capacity\n",
+			disk->disk_name);
+		return -ENODEV;
+	}
+
+	if (!disk_need_zone_resources(disk))
+		return 0;
+
+	if (!args->conv_zones_bitmap) {
+		args->conv_zones_bitmap =
+			blk_alloc_zone_bitmap(q->node, args->nr_zones);
+		if (!args->conv_zones_bitmap)
+			return -ENOMEM;
+	}
+
+	set_bit(idx, args->conv_zones_bitmap);
+
+	return 0;
+}
+
+static int blk_revalidate_seq_zone(struct blk_zone *zone, unsigned int idx,
+				   struct blk_revalidate_zone_args *args)
+{
+	struct gendisk *disk = args->disk;
+	struct blk_zone_wplug *zwplug;
+	unsigned int wp_offset;
+	unsigned long flags;
+
+	/*
+	 * Remember the capacity of the first sequential zone and check
+	 * if it is constant for all zones.
+	 */
+	if (!args->zone_capacity)
+		args->zone_capacity = zone->capacity;
+	if (zone->capacity != args->zone_capacity) {
+		pr_warn("%s: Invalid variable zone capacity\n",
+			disk->disk_name);
+		return -ENODEV;
+	}
+
+	/*
+	 * We need to track the write pointer of all zones that are not
+	 * empty nor full. So make sure we have a zone write plug for
+	 * such zone if the device has a zone write plug hash table.
+	 */
+	if (!disk->zone_wplugs_hash)
+		return 0;
+
+	wp_offset = blk_zone_wp_offset(zone);
+	if (!wp_offset || wp_offset >= zone->capacity)
+		return 0;
+
+	zwplug = disk_get_and_lock_zone_wplug(disk, zone->wp, GFP_NOIO, &flags);
+	if (!zwplug)
+		return -ENOMEM;
+	spin_unlock_irqrestore(&zwplug->lock, flags);
+	disk_put_zone_wplug(zwplug);
+
+	return 0;
+}
+
 /*
  * Helper function to check the validity of zones of a zoned block device.
  */
@@ -1664,12 +1732,9 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 {
 	struct blk_revalidate_zone_args *args = data;
 	struct gendisk *disk = args->disk;
-	struct request_queue *q = disk->queue;
 	sector_t capacity = get_capacity(disk);
-	sector_t zone_sectors = q->limits.chunk_sectors;
-	struct blk_zone_wplug *zwplug;
-	unsigned long flags;
-	unsigned int wp_offset;
+	sector_t zone_sectors = disk->queue->limits.chunk_sectors;
+	int ret;
 
 	/* Check for bad zones and holes in the zone report */
 	if (zone->start != args->sector) {
@@ -1709,62 +1774,22 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 	/* Check zone type */
 	switch (zone->type) {
 	case BLK_ZONE_TYPE_CONVENTIONAL:
-		if (zone->capacity != zone->len) {
-			pr_warn("%s: Invalid conventional zone capacity\n",
-				disk->disk_name);
-			return -ENODEV;
-		}
-
-		if (!disk_need_zone_resources(disk))
-			break;
-		if (!args->conv_zones_bitmap) {
-			args->conv_zones_bitmap =
-				blk_alloc_zone_bitmap(q->node, args->nr_zones);
-			if (!args->conv_zones_bitmap)
-				return -ENOMEM;
-		}
-		set_bit(idx, args->conv_zones_bitmap);
+		ret = blk_revalidate_conv_zone(zone, idx, args);
 		break;
 	case BLK_ZONE_TYPE_SEQWRITE_REQ:
-		/*
-		 * Remember the capacity of the first sequential zone and check
-		 * if it is constant for all zones.
-		 */
-		if (!args->zone_capacity)
-			args->zone_capacity = zone->capacity;
-		if (zone->capacity != args->zone_capacity) {
-			pr_warn("%s: Invalid variable zone capacity\n",
-				disk->disk_name);
-			return -ENODEV;
-		}
-
-		/*
-		 * We need to track the write pointer of all zones that are not
-		 * empty nor full. So make sure we have a zone write plug for
-		 * such zone if the device has a zone write plug hash table.
-		 */
-		if (!disk->zone_wplugs_hash)
-			break;
-		wp_offset = blk_zone_wp_offset(zone);
-		if (wp_offset && wp_offset < zone->capacity) {
-			zwplug = disk_get_and_lock_zone_wplug(disk, zone->wp,
-							      GFP_NOIO, &flags);
-			if (!zwplug)
-				return -ENOMEM;
-			spin_unlock_irqrestore(&zwplug->lock, flags);
-			disk_put_zone_wplug(zwplug);
-		}
-
+		ret = blk_revalidate_seq_zone(zone, idx, args);
 		break;
 	case BLK_ZONE_TYPE_SEQWRITE_PREF:
 	default:
 		pr_warn("%s: Invalid zone type 0x%x at sectors %llu\n",
 			disk->disk_name, (int)zone->type, zone->start);
-		return -ENODEV;
+		ret = -ENODEV;
 	}
 
-	args->sector += zone->len;
-	return 0;
+	if (!ret)
+		args->sector += zone->len;
+
+	return ret;
 }
 
 /**
-- 
2.44.0

