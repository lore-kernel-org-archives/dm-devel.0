Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E7E13AD22;
	Thu,  6 Jun 2024 07:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717659445; cv=none; b=AWh6TrPx1CVTCED09YAI15cwifWPpaiKGAFYw6aGz7pR55KGRlkFHuEnpYcV9gisapJu7I0xO2U8si5B45ArHBFfTbx4jYB42q94ZxxyjX2/ATBv7r60GRByLaMsvOU7lUXoSHQdrz4eIyXo+m9DPbTBDoQZX+2w8v5gVfB7pd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717659445; c=relaxed/simple;
	bh=UTS3ToDyEPmayEpKX3ALx48mU8ZpnPOhzlJJikS5kY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QevgAHSLihQRit/KO/+VYhkRG4SRF8EkL7TFuqaJlubFMoComRxd20SuTgSiB1IiLbmZFUOEXyThwsFLiSsOBVhpliuxJvoIbyo7EYkQC94JVCIvPQEslfeGv1gzlx+iUE+sQw/iOh9VQfryKwY3FabDVovgMrO/XKl+ax20ess=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GUzHlggi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GUzHlggi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57423C4AF15;
	Thu,  6 Jun 2024 07:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717659445;
	bh=UTS3ToDyEPmayEpKX3ALx48mU8ZpnPOhzlJJikS5kY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GUzHlggizcc6bE2KWoK/VibC/v5C5eRwXUtngVhB+Xqrbp0Bdu/sNyd4+DxXC/Nm8
	 D45DJGsv+bnew/EJhrv4unR/BvN9b0BWyp9E4PWAy/p5iLEpFhFHTqwNXYNIreYJc5
	 /BE9nRIoVRo4eGEEJzfWXagp76mqR6KWgKUm+eg7VGVdCLYUb/NI1gU4Se+bJXwmMh
	 sIMeuNV4f6fjhaoBsG3Cf5lWcsjTnNvGKL34eXY0twOPQgi0fTYKuVZ/lZrDOWtDbj
	 V/58yaeYAtysItoUy8vIEw9gpf8fy4i361rk1Ewuk9A26jfUbS/BQeiYKX+JSCxEMo
	 XBIL0oRHRpEwQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v5 1/4] block: Improve checks on zone resource limits
Date: Thu,  6 Jun 2024 16:37:18 +0900
Message-ID: <20240606073721.88621-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606073721.88621-1-dlemoal@kernel.org>
References: <20240606073721.88621-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make sure that the zone resource limits of a zoned block device are
correct by checking that:
(a) If the device has a max active zones limit, make sure that the max
    open zones limit is lower than the max active zones limit.
(b) If the device has zone resource limits, check that the limits
    values are lower than the number of sequential zones of the device.
    If it is not, assume that the zoned device has no limits by setting
    the limits to 0.

For (a), a check is added to blk_validate_zoned_limits() and an error
returned if the max open zones limit exceeds the value of the max active
zone limit (if there is one).

For (b), given that we need the number of sequential zones of the zoned
device, this check is added to disk_update_zone_resources(). This is
safe to do as that function is executed with the disk queue frozen and
the check executed after queue_limits_start_update() which takes the
queue limits lock. Of note is that the early return in this function
for zoned devices that do not use zone write plugging (e.g. DM devices
using native zone append) is moved to after the new check and adjustment
of the zone resource limits so that the check applies to any zoned
device.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/blk-settings.c |  8 ++++++++
 block/blk-zoned.c    | 20 ++++++++++++++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index effeb9a639bb..607f888fe93b 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -80,6 +80,14 @@ static int blk_validate_zoned_limits(struct queue_limits *lim)
 	if (WARN_ON_ONCE(!IS_ENABLED(CONFIG_BLK_DEV_ZONED)))
 		return -EINVAL;
 
+	/*
+	 * Given that active zones include open zones, the maximum number of
+	 * open zones cannot be larger than the maximum number of active zones.
+	 */
+	if (lim->max_active_zones &&
+	    lim->max_open_zones > lim->max_active_zones)
+		return -EINVAL;
+
 	if (lim->zone_write_granularity < lim->logical_block_size)
 		lim->zone_write_granularity = lim->logical_block_size;
 
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 52abebf56027..8f89705f5e1c 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1647,8 +1647,22 @@ static int disk_update_zone_resources(struct gendisk *disk,
 		return -ENODEV;
 	}
 
+	lim = queue_limits_start_update(q);
+
+	/*
+	 * Some devices can advertize zone resource limits that are larger than
+	 * the number of sequential zones of the zoned block device, e.g. a
+	 * small ZNS namespace. For such case, assume that the zoned device has
+	 * no zone resource limits.
+	 */
+	nr_seq_zones = disk->nr_zones - nr_conv_zones;
+	if (lim.max_open_zones >= nr_seq_zones)
+		lim.max_open_zones = 0;
+	if (lim.max_active_zones >= nr_seq_zones)
+		lim.max_active_zones = 0;
+
 	if (!disk->zone_wplugs_pool)
-		return 0;
+		goto commit;
 
 	/*
 	 * If the device has no limit on the maximum number of open and active
@@ -1657,9 +1671,6 @@ static int disk_update_zone_resources(struct gendisk *disk,
 	 * dynamic zone write plug allocation when simultaneously writing to
 	 * more zones than the size of the mempool.
 	 */
-	lim = queue_limits_start_update(q);
-
-	nr_seq_zones = disk->nr_zones - nr_conv_zones;
 	pool_size = max(lim.max_open_zones, lim.max_active_zones);
 	if (!pool_size)
 		pool_size = min(BLK_ZONE_WPLUG_DEFAULT_POOL_SIZE, nr_seq_zones);
@@ -1673,6 +1684,7 @@ static int disk_update_zone_resources(struct gendisk *disk,
 			lim.max_open_zones = 0;
 	}
 
+commit:
 	return queue_limits_commit_update(q, &lim);
 }
 
-- 
2.45.2

