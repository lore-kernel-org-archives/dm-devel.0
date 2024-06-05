Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723DE190463;
	Wed,  5 Jun 2024 06:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717569552; cv=none; b=WDUwBfTruVaDDlqwmX92mRlUDAYXF5ZI8TCg4KZG14cYxGeiYtO0/3P4YvCdLOO9S1XzWQui2VNWpCRdf1dJd5y0uh9quyamDLwfixTQ5IF79nvnxA9bogP/wGHyWrOAo1Adp7flUMBx9tNuMiku1e150dbeL89rfExPQ6+RrvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717569552; c=relaxed/simple;
	bh=y934cq7Vul1P9MkZBJElXBGQ9sSui/iRfNWQeppGFZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHt0hHMcBVfBmEgNRvRcSMosLFOkyV/tGRSpzfCTvIwM2P7nEl3KrRLcgGpFFaUQev1aw5PXMXz8rrCAAeB+OeVzEaB1NtrKr7LExyeUGMtF7iy0ichX3mcMcsoHt7KLZJQP7tD5qnqHDEHSHGUIzBvuGkCxDo9xeiQhAsmBQMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=itNmd6gw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="itNmd6gw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AD0C4AF09;
	Wed,  5 Jun 2024 06:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717569551;
	bh=y934cq7Vul1P9MkZBJElXBGQ9sSui/iRfNWQeppGFZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=itNmd6gwRj2QbKb/6Q4gX5u+HnBecdtg8NLeJ37Qd0SUKZ04F+ftIkqT59KtraDaz
	 k909Ol4SQUS82Q2JT7VoTObRPFpWmGg2iQwlwrTOrLVqgLm7ujk1DkVJ6CRqmJGqRW
	 p+H41L+bsnS1gNyHG615KfdJsvSBsOmmxyf46bGj3qwBt/LRvtpL7kv7bVN9eLPDXV
	 rPNIV9VWoRSLyWTwiYvO2pSD/X5UzWvnB9bvACwwwfUsc9UoNjFrP5HrAs3hllWcWH
	 6IdYK1HMdX1vIt49SoG27Tj4D5lYXsx8FWl5NGP7yuutbIZMgXRd9PZXvHa4h4Ps6w
	 g9cHkUBAcpCaQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v3 1/2] block: Imporve checks on zone resource limits
Date: Wed,  5 Jun 2024 15:39:05 +0900
Message-ID: <20240605063907.129120-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240605063907.129120-1-dlemoal@kernel.org>
References: <20240605063907.129120-1-dlemoal@kernel.org>
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

For (b), given that we need to number of sequential zones of the device,
this check is added to disk_update_zone_resources(). This is safe to do
as that function is executed with the disk queue frozen and the check
executed after queue_limits_start_update() with the queue limits lock
held.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-settings.c |  8 ++++++++
 block/blk-zoned.c    | 17 ++++++++++++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

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
index 52abebf56027..7a2dfbc8f614 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1650,6 +1650,20 @@ static int disk_update_zone_resources(struct gendisk *disk,
 	if (!disk->zone_wplugs_pool)
 		return 0;
 
+	lim = queue_limits_start_update(q);
+
+	/*
+	 * Some devices can advertize max open and max active zone limits that
+	 * are larger than the number of sequential zones of the zoned block
+	 * device, e.g. a small ZNS namespace. For such case, assume that the
+	 * zoned device has no limits.
+	 */
+	nr_seq_zones = disk->nr_zones - nr_conv_zones;
+	if (lim.max_active_zones > nr_seq_zones)
+		lim.max_active_zones = 0;
+	if (lim.max_open_zones > nr_seq_zones)
+		lim.max_open_zones = 0;
+
 	/*
 	 * If the device has no limit on the maximum number of open and active
 	 * zones, set its max open zone limit to the mempool size to indicate
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
-- 
2.45.1

