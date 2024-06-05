Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F55817C79;
	Wed,  5 Jun 2024 02:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717554289; cv=none; b=RaCqjzQa7jDHnTqMC6yD/fY1hmWQJzr/ZfgbNRi5caElezlrMN9UrZiJcrGwVhZy5fo+JujzanEImZtU2fqTLc5I8UgFlG5q3nf5gj2jUECbH0+taLpdmGAdV9K9ehT6xqMbf5keVVz1RxFpWXOW0le+1K3xd0kB0Vqk6eyAni8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717554289; c=relaxed/simple;
	bh=t/kzthqmGeR6g0jDb3joAL2bnxgzUJbzQ6Hht65aX2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8Y7vncEeIsHxW0LGucG28+TybdEmelt4xC/o5SVQKLIsdv3cXwsDWou6Vx+Y8QU7LUzMOZfgvpje8Dy6QYsJzXAHg3AeroKQlHtW1a/rsOCrRzEw9NnnJP9TU0xbLTv60UQvlWGNz9KOtrrnEPBtraxsd2dez0ZlqEXMtlEMUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SFeROKNt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SFeROKNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4131DC4AF08;
	Wed,  5 Jun 2024 02:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717554289;
	bh=t/kzthqmGeR6g0jDb3joAL2bnxgzUJbzQ6Hht65aX2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SFeROKNtUrEytXXPUlO9Nn+8/NrPFhGBt9xoRg8ruIpxxR1QjTG5wnsK9X0w49PQk
	 c9QqYOBygr982djyuiH/6TuKlIlrj4Qrf6aJR+yHH9zs8h1Gi4ZNCY5g9U+RteTMqX
	 qt5Fcq0oSs8rqGB08TmZv5Eue0w35p1Ube0rTlON1q68zWxy3aDOykwMZ4cEWz22OV
	 oy/DEDlPKXEd9bsjZ0ZkO/9Ksk77NgiERZC/BU2xtzcMWUPI3QW9PKA5ak/dsaA2xF
	 oNPbqJRALrQJ9kMy/0cIFfwbdug0SKFIaToxUS+wDij0othC+kLgBvTiV9/VLVHA1Z
	 s0bDyxy9OZdIg==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 1/2] block: Imporve checks on zone resource limits
Date: Wed,  5 Jun 2024 11:24:44 +0900
Message-ID: <20240605022445.105747-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240605022445.105747-1-dlemoal@kernel.org>
References: <20240605022445.105747-1-dlemoal@kernel.org>
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
(b) If the device has a max open zones or a max active zones limit,
    check that the limits are lower than the number of sequential zones
    of the device.

For (a), a check is added to blk_validate_zoned_limits(). For (b), given
that we need to number of sequential zones of the device, this check is
added to disk_update_zone_resources(). This is safe to do as that
function is executed with the queue frozen and the check executed after
queue_limits_start_update() with the queue limits lock held.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-settings.c | 4 ++++
 block/blk-zoned.c    | 5 +++++
 2 files changed, 9 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index effeb9a639bb..a79c57376ef7 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -80,6 +80,10 @@ static int blk_validate_zoned_limits(struct queue_limits *lim)
 	if (WARN_ON_ONCE(!IS_ENABLED(CONFIG_BLK_DEV_ZONED)))
 		return -EINVAL;
 
+	if (lim->max_active_zones &&
+	    WARN_ON_ONCE(lim->max_open_zones > lim->max_active_zones))
+		lim->max_open_zones = lim->max_active_zones;
+
 	if (lim->zone_write_granularity < lim->logical_block_size)
 		lim->zone_write_granularity = lim->logical_block_size;
 
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 52abebf56027..2af4d5ca81d2 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1660,6 +1660,11 @@ static int disk_update_zone_resources(struct gendisk *disk,
 	lim = queue_limits_start_update(q);
 
 	nr_seq_zones = disk->nr_zones - nr_conv_zones;
+	if (WARN_ON_ONCE(lim.max_active_zones > nr_seq_zones))
+		lim.max_active_zones = 0;
+	if (WARN_ON_ONCE(lim.max_open_zones > nr_seq_zones))
+		lim.max_open_zones = 0;
+
 	pool_size = max(lim.max_open_zones, lim.max_active_zones);
 	if (!pool_size)
 		pool_size = min(BLK_ZONE_WPLUG_DEFAULT_POOL_SIZE, nr_seq_zones);
-- 
2.45.1

