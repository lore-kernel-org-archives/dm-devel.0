Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEB7572668;
	Fri, 16 Oct 2026 17:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792171649; cv=none; b=ZJCCT8RbWe/mit3kZIO42ymNwPVHtCL0p1+xzwMYw/EIP3pMcrUdEoGDgBXAlGIW3gVt27WnaXOc4xODMzs2gHblnj0tCvMaDVYLCahnwZeZR2Q4RHIBS/SUD17kY4r2e1BgW/IyyPtO1+BFCfKmxs763ixjKeP4+EzWrdLtooM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792171649; c=relaxed/simple;
	bh=tP9TgBPJx7ApSwRvorqjJCxrly09t8avgNAQMKwgC4o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UdM2kT7v+r5nTbLkEm1LCb64fzMNX2n3bETllEQOavZB1a8GWtVHUMJHfrrED67SbBxzlD24rgPwHdrfqgHte+GDgjVsCo1/Mq0lPtN9rotpOqv+mgrymuGh6CXdaLD9CyxpBpyNfXWTelWRCWq/WerrrGP732HJevFTG9LIy3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=POJpdEig; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="POJpdEig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE3C1F000C5;
	Fri, 16 Oct 2026 17:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792171647;
	bh=ZHNihi6SpYfKbCOBPVGEQJ/1C5kQXsYwhIVxMcoUKK4=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=POJpdEiguJ1GLVaGb6IwE/93/Pm2Pm5UFtF925mUj843HzxgQFTRJhhaPKn1mCsuf
	 GcIPtM+L5zaofQo8BylG240ByzOyobRwKS5lpvWK0d18gpUkLssgWb+MT5jkcOUwet
	 WZKEpjM25II6+GwrkR8T4UJY8Ifsn9ryAX6B1qRDV3E4TDsSAQt0H4xUW9cfIIeVSH
	 txsfjyxi3wIa9KYGWGeyp74y42748yvIFOSB2/qs27wt7OF3PVAWbdXvxGlNoPM+fy
	 nVdjUSNl9y0hzgNvXseEy3Fg+1n33Eq4w5IiLps/k/wkarE2b3tLYmMgVEYfutOS+d
	 qgzFIrlfPemug==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	hch@lst.de
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm: stop using blk_limits_io_{min,opt}" has been added to the 6.6-stable tree
Date: Fri, 16 Oct 2026 13:27:25 -0400
Message-ID: <20261016172726.4009674-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
Reply-To: stable@vger.kernel.org
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

This is a note to let you know that I've just added the patch titled

    dm: stop using blk_limits_io_{min,opt}

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-stop-using-blk_limits_io_-min-opt.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit e127244cba9583bce11a40caf2f1e66a7c5142d9
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed Jul 3 15:12:08 2024 +0200

    dm: stop using blk_limits_io_{min,opt}
    
    [ Upstream commit 0a94a469a4f02bdcc223517fd578810ffc21c548 ]
    
    Remove use of the blk_limits_io_{min,opt} and assign the values directly
    to the queue_limits structure.  For the io_opt this is a completely
    mechanical change, for io_min it removes flooring the limit to the
    physical and logical block size in the particular caller.  But as
    blk_validate_limits will do the same later when actually applying the
    limits, there still is no change in overall behavior.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Stable-dep-of: 1071d560afb4 ("dm-stripe: fix a possible integer overflow")
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 5522f8e9443f2..bbc5c8bb2b856 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -3539,8 +3539,8 @@ static void cache_io_hints(struct dm_target *ti, struct queue_limits *limits)
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
index 94b2fc33f64be..56e9a4911d968 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -2078,8 +2078,8 @@ static void clone_io_hints(struct dm_target *ti, struct queue_limits *limits)
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
index 45b8d314ef0d7..3a609ef221688 100644
--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -434,7 +434,7 @@ static void ebs_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	limits->logical_block_size = to_bytes(ec->e_bs);
 	limits->physical_block_size = to_bytes(ec->u_bs);
 	limits->alignment_offset = limits->physical_block_size;
-	blk_limits_io_min(limits, limits->logical_block_size);
+	limits->io_min = limits->logical_block_size;
 }
 
 static int ebs_iterate_devices(struct dm_target *ti,
diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index 2fe173a9880b2..c8508a0891232 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1743,8 +1743,8 @@ static void era_io_hints(struct dm_target *ti, struct queue_limits *limits)
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
index 1b562d2189c54..aa6f3e71c4fa2 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3512,7 +3512,7 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
 	if (ic->sectors_per_block > 1) {
 		limits->logical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
 		limits->physical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
-		blk_limits_io_min(limits, ic->sectors_per_block << SECTOR_SHIFT);
+		limits->io_min = ic->sectors_per_block << SECTOR_SHIFT;
 		limits->dma_alignment = limits->logical_block_size - 1;
 	}
 }
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 0c4ab6865182b..2d6a35803c1e8 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3782,8 +3782,8 @@ static void raid_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	struct raid_set *rs = ti->private;
 	unsigned int chunk_size_bytes = to_bytes(rs->md.chunk_sectors);
 
-	blk_limits_io_min(limits, chunk_size_bytes);
-	blk_limits_io_opt(limits, chunk_size_bytes * mddev_data_stripes(rs));
+	limits->io_min = chunk_size_bytes;
+	limits->io_opt = chunk_size_bytes * mddev_data_stripes(rs);
 }
 
 static void raid_postsuspend(struct dm_target *ti)
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index e2854a3cbd282..67026e1cbc857 100644
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
index 7935363d13b1d..1e860940293ab 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -4081,10 +4081,10 @@ static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
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
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index bfd0e80bb9f3a..27ef5c0167cb6 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -996,7 +996,7 @@ static void verity_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	if (limits->physical_block_size < 1 << v->data_dev_block_bits)
 		limits->physical_block_size = 1 << v->data_dev_block_bits;
 
-	blk_limits_io_min(limits, limits->logical_block_size);
+	limits->io_min = limits->logical_block_size;
 
 	/*
 	 * Similar to what dm-crypt does, opt dm-verity out of support for
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index 36e55a5bcb0de..b57f7259f999d 100644
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
