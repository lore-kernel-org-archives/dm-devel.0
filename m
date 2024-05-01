Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC0F14AB8;
	Wed,  1 May 2024 00:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714522192; cv=none; b=tv7ZAUm0FjIr3zTddgcRYjYwxU0MahSTtPi7qsczVnmjpP3Zj4erMdZdP2I9YiPbY2Q1PGcExQMCCp1ePjItWFs57J9/b4Co60UXvpUcVzbvQht7ZL+2+DnZ9IWverX+CaMV6V5Pk6bY9HEHZ5I8oOPQpvjNDersWiCdgnsUGww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714522192; c=relaxed/simple;
	bh=GgkXYMOex8Wwx3Wzdyn0crJ3gWNnGAT0xhN76cGFAbg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzylothoGZdKHDzSKMfj8KD673Lm+l2juhhiBM2DfQbzU3FpyVV1VJR459JMxWlO2YCHtbVBU0vYlFPX3TEfBUMg6RcKKumb/YmpcKEhOSzayqb896569rxtRQRct+yQeBpMYp2DN9wT2bl2ZZPHbYDijThhwIq1nTa0mziBZEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZFw56VAU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZFw56VAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17CFC2BBFC;
	Wed,  1 May 2024 00:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714522192;
	bh=GgkXYMOex8Wwx3Wzdyn0crJ3gWNnGAT0xhN76cGFAbg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ZFw56VAUR/2FKxOkQPr/EuKA8CBZtw8FFKiFFx//2frZFgtFN5li7b1LOsJ/meBNI
	 EDp1AffsQQ/CxSjN5H64CgDyfhxRJMxA9zlc0fDA61jgYknLyQbW2ruMs7cCAcDkSG
	 R2vffBZqEQeGjOFcmhQarHESGP8I3UkSAkQGczXqUkoPZhkaGDy0r3m8mEJTMLTpXH
	 +KiyXuBPvTso6uIXEu7QD5gslTm3p0t/XawZSXX+qevZcYfu0tOVAv37j7Op+sjOuU
	 lPcKzrUlG3dlyJfSGp9G7fPtYTc58Jy1tVc/f3luo2VH+JfgHUm7pcX6uEJgW8oSOD
	 p337LtJYvM3bA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 14/14] block: Cleanup blk_revalidate_zone_cb()
Date: Wed,  1 May 2024 09:09:35 +0900
Message-ID: <20240501000935.100534-15-dlemoal@kernel.org>
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
index 9026e83e0746..a2030089081c 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1658,6 +1658,74 @@ static int disk_update_zone_resources(struct gendisk *disk,
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
@@ -1666,12 +1734,9 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
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
@@ -1711,62 +1776,22 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
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

