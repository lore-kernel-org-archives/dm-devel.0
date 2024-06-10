Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD28A2CCB7;
	Mon, 10 Jun 2024 07:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718006218; cv=none; b=pOr0wlSJigL5rI56j663+i4Dd5FAqDKg1Wjh5WWHc9324qO5/vEZP0WxGYh8xYad3OQ353eFBWeO3/WLrz2ykA0Whbg9B9vG37gN58qq2wA67TRsvCW6tNVK8fMwyTe/d+dmlhtxN1idpBE0yhx7Yvj859qbQ74jS0t3fpHX39c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718006218; c=relaxed/simple;
	bh=fU7TfXef3r8dQkWoSseolnUvXb1vhzxWz6xAwj65vPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SSJpXCLoq8xwRQqdd7lpF1Vdn+4eHUdhJh8dvTzDEqsEgjfaZz8A7rI1n2d1TlRDqBVWEFB8zvJGhl5szf97hvTvh/2ZFi0mhfusyQL+I1jF6WvKJB1QDhge3MgH4iWFcae4bY/l2m+wLd4xr42Ys+2Wdxd5LozAJUvNXAnyYxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b+olpxU2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b+olpxU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836A9C4AF48;
	Mon, 10 Jun 2024 07:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718006218;
	bh=fU7TfXef3r8dQkWoSseolnUvXb1vhzxWz6xAwj65vPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+olpxU2Y9AQYgkzuwmXywbMCMRZ8zDrgTjOuhSgJUwycOs5qc5HBx7ob+LBh9i4D
	 HT8KNghb7CMwjEhd+ZpNssdmM8y27Cm7FM+GVUnqCrAnvMWfxFq4tRXMKgYCi3bTNG
	 c+76n2u8qrVNCpIXrj+HXjitX9QAtKCz8VOecivZn7zyAMwTIJ6bg8DQDDLvqn6iUr
	 zq0rR2QmJNVGSsF2QiZBtKPAAy6enwkmOsi8EgymFUl8hkqKPjUd7iRwsC1iyuOFYp
	 EjgeZ/IW+y/S6e5vFnvTPjTDtwJ/wfwtkRz3TybVa5MMRBIAgs/9uXOIRKDJhlJeJx
	 1im45hx1otGMA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v7 1/4] block: Improve checks on zone resource limits
Date: Mon, 10 Jun 2024 16:56:52 +0900
Message-ID: <20240610075655.249301-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240610075655.249301-1-dlemoal@kernel.org>
References: <20240610075655.249301-1-dlemoal@kernel.org>
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
Reviewed-by: Niklas Cassel <cassel@kernel.org>
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
index 08d7dfe8bd93..137842dbb59a 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1650,8 +1650,22 @@ static int disk_update_zone_resources(struct gendisk *disk,
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
@@ -1660,9 +1674,6 @@ static int disk_update_zone_resources(struct gendisk *disk,
 	 * dynamic zone write plug allocation when simultaneously writing to
 	 * more zones than the size of the mempool.
 	 */
-	lim = queue_limits_start_update(q);
-
-	nr_seq_zones = disk->nr_zones - nr_conv_zones;
 	pool_size = max(lim.max_open_zones, lim.max_active_zones);
 	if (!pool_size)
 		pool_size = min(BLK_ZONE_WPLUG_DEFAULT_POOL_SIZE, nr_seq_zones);
@@ -1676,6 +1687,7 @@ static int disk_update_zone_resources(struct gendisk *disk,
 			lim.max_open_zones = 0;
 	}
 
+commit:
 	return queue_limits_commit_update(q, &lim);
 }
 
-- 
2.45.2

