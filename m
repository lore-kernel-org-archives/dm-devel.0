Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393504A26;
	Sat,  9 Mar 2024 16:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710002506; cv=none; b=k5Z8nM5xeoEEAVyHzLwfX/yH8OH5cHINYGFzyU5IV3ocHMrHs6xIQdNb4HtUEwMUaP/qb14f6lff+z8xgPWntJ/Dyubkg/R0TEeW/2wV+iNbN9sl1+1F/4Ny0N6mwcKxRbfZh7MRR9WicAzbHL0Wl8lkCIsXULDu7F66x8CtAAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710002506; c=relaxed/simple;
	bh=5vvad8eHaMhQ+RjzxdPyyLaDhlKAFrCMCPHpuDVeC+0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=c7YbLg+a5G/JcmYLfscSxCmhdKNisdCrr/UBEQoqLkl9wBc+jJuaJJUeJ65eJFa9icQ+fF9XkrFBTslIrOfWuC3d6W2KK7p84x4zTbqjxT4DMU5SJrrGiyMSthWSgqcdVzuy4p1HXOcBc6KTlW2OGwTaW8lu8lo+4yM2izuDrog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1Z0A5EXg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1Z0A5EXg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=/MdF7Brr0INKSARrcMWokDvfp8eOiuz1VBdR+YYZTYs=; b=1Z0A5EXgMU1DeNsx/U3XIdK0uQ
	waThYG4GlBldRd2a/pM0JCllEqUpASV/40qqzbOOe6+S8+8UPxqSQQg1hiw6CooPUHXcmjp7M30gO
	xBfSZNWA+6sOM2bZ1Bf2vXQgIBQMmVpD4Pvg64whNgApaeztidjXfBZgGNRBejQKyn63ll87ZTV1K
	rAeCefx4D5tTYrkLL+0IXxzOD8CkGiVZMN8R4OtKawVWre3WuwO0Qs36hDrdAjn5ckMxEze5HJuhl
	WjxgQLmBO+nJK0eqz4oM0yopM2aU/5B/MqFEBgxOQvccerqnvp/mrnDdAS6Ic/BIeTUh8nM3PxzAV
	QYwIe2/w==;
Received: from 2603-8001-cc00-284c-0000-0000-0000-1235.res6.spectrum.com ([2603:8001:cc00:284c::1235] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rizlW-0000000DmCz-32jG;
	Sat, 09 Mar 2024 16:41:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: [PATCH] dm: set the correct discard_sectors limit
Date: Sat,  9 Mar 2024 09:41:40 -0700
Message-Id: <20240309164140.719752-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Since commit 0034af036554 ("block: make
/sys/block/<dev>/queue/discard_max_bytes writeable") there are two
max_discard_sectors limits, one provided by the driver and one set by the
user to optionally reduce the size below the hardware or driver limits.
Usage of the extra hw limits has been a bit convoluted and both were
set by the same driver API, leading to potential overrides of the user
setting by the driver updating the limits.

With the new atomic queue limits API the driver should only set the hw
limit, but I forgot to convert dm over to that as it was already using
a scheme where the queue_limits are passed around.  Fix dm to update
the max_hw_discard_sectors limits.

Note that this still leaves the non-hw update in place, which should
be removed to not override the user settings.  As that is a behavior
change I do not want to do it at the very end of the merge window.

This fixes a regression where dm bio poison v1 warns about exceeding
the discard bio size when running xfstests generic/500.

Fixes: 8e0ef4128694 ("dm: use queue_limits_set")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-cache-target.c | 5 +++--
 drivers/md/dm-clone-target.c | 3 ++-
 drivers/md/dm-log-writes.c   | 2 +-
 drivers/md/dm-snap.c         | 2 +-
 drivers/md/dm-thin.c         | 5 +++--
 drivers/md/dm.c              | 1 +
 6 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 911f73f7ebbaa0..71d7824c731862 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -3394,8 +3394,9 @@ static void set_discard_limits(struct cache *cache, struct queue_limits *limits)
 
 	if (!cache->features.discard_passdown) {
 		/* No passdown is done so setting own virtual limits */
-		limits->max_discard_sectors = min_t(sector_t, cache->discard_block_size * 1024,
-						    cache->origin_sectors);
+		limits->max_hw_discard_sectors =
+			min_t(sector_t, cache->discard_block_size * 1024,
+					cache->origin_sectors);
 		limits->discard_granularity = cache->discard_block_size << SECTOR_SHIFT;
 		return;
 	}
diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index 94b2fc33f64be3..861a8ff524154f 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -2050,7 +2050,8 @@ static void set_discard_limits(struct clone *clone, struct queue_limits *limits)
 	if (!test_bit(DM_CLONE_DISCARD_PASSDOWN, &clone->flags)) {
 		/* No passdown is done so we set our own virtual limits */
 		limits->discard_granularity = clone->region_size << SECTOR_SHIFT;
-		limits->max_discard_sectors = round_down(UINT_MAX >> SECTOR_SHIFT, clone->region_size);
+		limits->max_hw_discard_sectors =
+			round_down(UINT_MAX >> SECTOR_SHIFT, clone->region_size);
 		return;
 	}
 
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index f17a6cf2284ecf..8d7df8303d0a18 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -871,7 +871,7 @@ static void log_writes_io_hints(struct dm_target *ti, struct queue_limits *limit
 	if (!bdev_max_discard_sectors(lc->dev->bdev)) {
 		lc->device_supports_discard = false;
 		limits->discard_granularity = lc->sectorsize;
-		limits->max_discard_sectors = (UINT_MAX >> SECTOR_SHIFT);
+		limits->max_hw_discard_sectors = (UINT_MAX >> SECTOR_SHIFT);
 	}
 	limits->logical_block_size = bdev_logical_block_size(lc->dev->bdev);
 	limits->physical_block_size = bdev_physical_block_size(lc->dev->bdev);
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index bf7a574499a34d..07961e7e8382ab 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -2408,7 +2408,7 @@ static void snapshot_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 		/* All discards are split on chunk_size boundary */
 		limits->discard_granularity = snap->store->chunk_size;
-		limits->max_discard_sectors = snap->store->chunk_size;
+		limits->max_hw_discard_sectors = snap->store->chunk_size;
 
 		up_read(&_origins_lock);
 	}
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 07c7f9795b107b..d6adccda966f92 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -4096,7 +4096,7 @@ static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	if (pt->adjusted_pf.discard_enabled) {
 		disable_discard_passdown_if_not_supported(pt);
 		if (!pt->adjusted_pf.discard_passdown)
-			limits->max_discard_sectors = 0;
+			limits->max_hw_discard_sectors = 0;
 		/*
 		 * The pool uses the same discard limits as the underlying data
 		 * device.  DM core has already set this up.
@@ -4493,7 +4493,8 @@ static void thin_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 	if (pool->pf.discard_enabled) {
 		limits->discard_granularity = pool->sectors_per_block << SECTOR_SHIFT;
-		limits->max_discard_sectors = pool->sectors_per_block * BIO_PRISON_MAX_RANGE;
+		limits->max_hw_discard_sectors =
+			pool->sectors_per_block * BIO_PRISON_MAX_RANGE;
 	}
 }
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b5e6a10b9cfde3..de7703070905ff 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1077,6 +1077,7 @@ void disable_discard(struct mapped_device *md)
 	struct queue_limits *limits = dm_get_queue_limits(md);
 
 	/* device doesn't really support DISCARD, disable it */
+	limits->max_hw_discard_sectors = 0;
 	limits->max_discard_sectors = 0;
 }
 
-- 
2.39.2

