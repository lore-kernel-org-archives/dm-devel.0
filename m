Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F8A49626;
	Mon, 24 Jun 2024 08:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719218050; cv=none; b=Hp4nZ0G6d/TqxA2P3Pt1AXT5aD04e7b//Ewt5uxqXixkOb/hIKoHiV6kZDjAldx7jIwgaQuYGbu05vaIuVvc/VVe5bzms2hNm4NKvtC8z0n3g+qERh2NRWbyADAN/8cMTGMSYvTJDMyNO20iQKnp2NqNpFCM6tEStAwuWcB9SM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719218050; c=relaxed/simple;
	bh=1noSXkc2epeoKrYH57A5Y14iOmWMcuCjkRBzVaXAQeg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XXKKfgo0CX4nC+j7Se5oMJ3W4hYj9yjF0+ekNzDjUT01fu1xBu+6+MB1fqScoJ2PNpoffpCDrTEC2qr+K2gLVjnBA6RbhHZunXNpVLH5FsVDk6vNy0uS8sw1gwSUvSQj1QsSzlHtbQWOHlR6J/1emoWMUiyu0uHE6ZXts+N4G+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2LxiJOI7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2LxiJOI7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=bGMcXGHA6jGmKOQVBoRvDTyQ1xqq+0C6YEtDisKjbjo=; b=2LxiJOI7WbjTCFvUTXZthcdXzA
	1BxscTZ6nk21Z28TNg1VvJ57VftITNHekS+0iuPhTT3eyFE7GDI8sgqAPztTANnQD5pMQGP4Q1aNe
	iWvsWajanLdtGah853G/UBxx9x/PlrjwUibXdO0NR8fC2ljlYfS+WxjQ8gEPTyAFswVL17Zwq167v
	/MoIXZ2q992fw74f2EKMDDzgrBL7RTUEkKVI8aRwrdV2iZwP//f45ChCe2TRtecZ5+Wvps3Jiat5M
	/t7SSukANwiGE/EL7+ldUNYlORhBmHi/24QSomx91EHeeZVI8zMUoftsAwvmhVhiITwqo6BdoxHpH
	wUKGIqTg==;
Received: from [213.208.157.109] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sLf9K-0000000G4cM-2PWe;
	Mon, 24 Jun 2024 08:34:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: snitzer@kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: [PATCH] dm: stop using blk_limits_io_{min,opt}
Date: Mon, 24 Jun 2024 10:34:03 +0200
Message-ID: <20240624083403.1002327-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Remove use of the blk_limits_io_{min,opt} and assign the values directly
to the queue_limits structure.  For the io_opt this is a completely
mechanical change, for io_min it removes flooring the limit to the
physical and logical block size in the particular caller.  But as
blk_validate_limits will do the same later when actually applying the
limits, there still is no change in overall behavior.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-cache-target.c      | 4 ++--
 drivers/md/dm-clone-target.c      | 4 ++--
 drivers/md/dm-ebs-target.c        | 2 +-
 drivers/md/dm-era-target.c        | 4 ++--
 drivers/md/dm-integrity.c         | 2 +-
 drivers/md/dm-raid.c              | 4 ++--
 drivers/md/dm-stripe.c            | 4 ++--
 drivers/md/dm-thin.c              | 6 +++---
 drivers/md/dm-vdo/dm-vdo-target.c | 4 ++--
 drivers/md/dm-verity-target.c     | 2 +-
 drivers/md/dm-zoned-target.c      | 4 ++--
 11 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 2d8dd9283ff4cf..17f0fab1e25496 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -3416,8 +3416,8 @@ static void cache_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	 */
 	if (io_opt_sectors < cache->sectors_per_block ||
 	    do_div(io_opt_sectors, cache->sectors_per_block)) {
-		blk_limits_io_min(limits, cache->sectors_per_block << SECTOR_SHIFT);
-		blk_limits_io_opt(limits, cache->sectors_per_block << SECTOR_SHIFT);
+		limits->io_min = cache->sectors_per_block << SECTOR_SHIFT;
+		limits->io_opt = cache->sectors_per_block << SECTOR_SHIFT;
 	}
 
 	disable_passdown_if_not_supported(cache);
diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index b4384a8b13e360..12bbe487a4c895 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -2073,8 +2073,8 @@ static void clone_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	 */
 	if (io_opt_sectors < clone->region_size ||
 	    do_div(io_opt_sectors, clone->region_size)) {
-		blk_limits_io_min(limits, clone->region_size << SECTOR_SHIFT);
-		blk_limits_io_opt(limits, clone->region_size << SECTOR_SHIFT);
+		limits->io_min = clone->region_size << SECTOR_SHIFT;
+		limits->io_opt = clone->region_size << SECTOR_SHIFT;
 	}
 
 	disable_passdown_if_not_supported(clone);
diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
index b70d4016c2acd0..ec5db1478b2fce 100644
--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -428,7 +428,7 @@ static void ebs_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	limits->logical_block_size = to_bytes(ec->e_bs);
 	limits->physical_block_size = to_bytes(ec->u_bs);
 	limits->alignment_offset = limits->physical_block_size;
-	blk_limits_io_min(limits, limits->logical_block_size);
+	limits->io_min = limits->logical_block_size;
 }
 
 static int ebs_iterate_devices(struct dm_target *ti,
diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index 8f81e597858d5c..e627781b1420e3 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1733,8 +1733,8 @@ static void era_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	 */
 	if (io_opt_sectors < era->sectors_per_block ||
 	    do_div(io_opt_sectors, era->sectors_per_block)) {
-		blk_limits_io_min(limits, 0);
-		blk_limits_io_opt(limits, era->sectors_per_block << SECTOR_SHIFT);
+		limits->io_min = 0;
+		limits->io_opt = era->sectors_per_block << SECTOR_SHIFT;
 	}
 }
 
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 2a89f8eb4713c9..3c18d58358f5df 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3471,7 +3471,7 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
 	if (ic->sectors_per_block > 1) {
 		limits->logical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
 		limits->physical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
-		blk_limits_io_min(limits, ic->sectors_per_block << SECTOR_SHIFT);
+		limits->io_min = ic->sectors_per_block << SECTOR_SHIFT;
 		limits->dma_alignment = limits->logical_block_size - 1;
 		limits->discard_granularity = ic->sectors_per_block << SECTOR_SHIFT;
 	}
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 052c00c1eb1542..65392f9efad670 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3802,8 +3802,8 @@ static void raid_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	struct raid_set *rs = ti->private;
 	unsigned int chunk_size_bytes = to_bytes(rs->md.chunk_sectors);
 
-	blk_limits_io_min(limits, chunk_size_bytes);
-	blk_limits_io_opt(limits, chunk_size_bytes * mddev_data_stripes(rs));
+	limits->io_min = chunk_size_bytes;
+	limits->io_opt = chunk_size_bytes * mddev_data_stripes(rs);
 }
 
 static void raid_presuspend(struct dm_target *ti)
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 16b93ae51d964d..1a6aefb25fd689 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -458,8 +458,8 @@ static void stripe_io_hints(struct dm_target *ti,
 	struct stripe_c *sc = ti->private;
 	unsigned int chunk_size = sc->chunk_size << SECTOR_SHIFT;
 
-	blk_limits_io_min(limits, chunk_size);
-	blk_limits_io_opt(limits, chunk_size * sc->stripes);
+	limits->io_min = chunk_size;
+	limits->io_opt = chunk_size * sc->stripes;
 }
 
 static struct target_type stripe_target = {
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 991f77a5885b72..a0c1620e90c8ce 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -4079,10 +4079,10 @@ static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	if (io_opt_sectors < pool->sectors_per_block ||
 	    !is_factor(io_opt_sectors, pool->sectors_per_block)) {
 		if (is_factor(pool->sectors_per_block, limits->max_sectors))
-			blk_limits_io_min(limits, limits->max_sectors << SECTOR_SHIFT);
+			limits->io_min = limits->max_sectors << SECTOR_SHIFT;
 		else
-			blk_limits_io_min(limits, pool->sectors_per_block << SECTOR_SHIFT);
-		blk_limits_io_opt(limits, pool->sectors_per_block << SECTOR_SHIFT);
+			limits->io_min = pool->sectors_per_block << SECTOR_SHIFT;
+		limits->io_opt = pool->sectors_per_block << SECTOR_SHIFT;
 	}
 
 	/*
diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index b423bec6458bbe..b1a62de1562f34 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -928,9 +928,9 @@ static void vdo_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	limits->physical_block_size = VDO_BLOCK_SIZE;
 
 	/* The minimum io size for random io */
-	blk_limits_io_min(limits, VDO_BLOCK_SIZE);
+	limits->io_min = VDO_BLOCK_SIZE;
 	/* The optimal io size for streamed/sequential io */
-	blk_limits_io_opt(limits, VDO_BLOCK_SIZE);
+	limits->io_opt = VDO_BLOCK_SIZE;
 
 	/*
 	 * Sets the maximum discard size that will be passed into VDO. This value comes from a
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index bb5da66da4c17d..ecbf6b752ce231 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1014,7 +1014,7 @@ static void verity_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	if (limits->physical_block_size < 1 << v->data_dev_block_bits)
 		limits->physical_block_size = 1 << v->data_dev_block_bits;
 
-	blk_limits_io_min(limits, limits->logical_block_size);
+	limits->io_min = limits->logical_block_size;
 }
 
 static void verity_dtr(struct dm_target *ti)
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index cd0ee144973f9f..6141fc25d8421a 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -996,8 +996,8 @@ static void dmz_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	limits->logical_block_size = DMZ_BLOCK_SIZE;
 	limits->physical_block_size = DMZ_BLOCK_SIZE;
 
-	blk_limits_io_min(limits, DMZ_BLOCK_SIZE);
-	blk_limits_io_opt(limits, DMZ_BLOCK_SIZE);
+	limits->io_min = DMZ_BLOCK_SIZE;
+	limits->io_opt = DMZ_BLOCK_SIZE;
 
 	limits->discard_alignment = 0;
 	limits->discard_granularity = DMZ_BLOCK_SIZE;
-- 
2.43.0

