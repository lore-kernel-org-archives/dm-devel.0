Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B3918C350;
	Wed,  5 Jun 2024 07:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717573910; cv=none; b=ioCdPOHe9TGnGzZ16lfewdMSoDRAKV0GAuf7+yDjvNdZZQDltL+E52Im7IR4zaPxy7igWJYwJh6DhqmKT4zDlmI614yMvYTA4TOrRhNbBH1KzM3NOTWaF6np7QCr18s7TAJWUfh/zsUkpSrlHhU9pJyx0CnnuYa/yl3GmcyJb6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717573910; c=relaxed/simple;
	bh=2/76gKMNOSqKOO4QACmFAurtB5XWL5K1v2WLb929urQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6aKC31ST48JhFfhRXmdMXl3b96drp9vRO6dtFbi2mvJwrTdB4DuELx9JTxQgbvMgPWZKNdiV2wqMoApbyUd9yR/EFD0hD0IaTK6xTTr+coO2BdyMIdo7CePR1gnvnFd0b8fYaNxK3/2iBkVobJU6lmZOcqox28zHh2VueylYls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f3y+9tBL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f3y+9tBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51966C4AF07;
	Wed,  5 Jun 2024 07:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717573909;
	bh=2/76gKMNOSqKOO4QACmFAurtB5XWL5K1v2WLb929urQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f3y+9tBL+lw6L3wVCBn1E7swjcIzGHKreB/kDXU16bfrNSVGBKnpeKdUFvq8b/7K7
	 8T6ixIOqGvg7zZpYJMthLNMq/eKLoYZSC/vdhvVLlYvq2IQaEtuTkomkOBlDrTN3+9
	 9tBCay8XekSpz982JLvuMhfxdFQQI+fyY962Ade+bdR5qI6r5ErycBUg+5x3hIFh3y
	 q71aR8kzI1GrLWMNSLWGXEcZbWUjH7v7EcVQGRKHktvTgOgBBdGsmEk0gpQxWV0MDK
	 Jvkwy7mbI8+RX8LIGEyAqXW/uQj5jIYA/kAfzDHVBXpboQsjb7gd2EYLHyHV9a/2ia
	 QcwBLXYSP+Rxg==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v4 1/3] block: Improve checks on zone resource limits
Date: Wed,  5 Jun 2024 16:51:42 +0900
Message-ID: <20240605075144.153141-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240605075144.153141-1-dlemoal@kernel.org>
References: <20240605075144.153141-1-dlemoal@kernel.org>
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
---
 block/blk-settings.c |  8 ++++++++
 block/blk-zoned.c    | 20 ++++++++++++++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index effeb9a639bb..474c709ea85b 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -80,6 +80,14 @@ static int blk_validate_zoned_limits(struct queue_limits *lim)
 	if (WARN_ON_ONCE(!IS_ENABLED(CONFIG_BLK_DEV_ZONED)))
 		return -EINVAL;
 
+	/*
+	 * Given that active zones include open zones, the maximum number of
+	 * open zones cannot be larger than the maximum numbber of active zones.
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
2.45.1

