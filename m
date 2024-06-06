Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173E513C80B;
	Thu,  6 Jun 2024 08:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717662113; cv=none; b=t/q5aFGLrBL8Fe9eG+oX3tWJ8P9Pwr2XJxE3CPxijiJ0cSwTnrECicEMJ6T8tjdKSEUeboXVYjOsCF0C6lVoIfUSeLtpC3Xk6YK7GdtSyRJImyoNBmST2nW+MPdA49Y5rBG0pI/yx8iqZSMVCYyKu1DYabaWu+ZA0L1IxA3TfeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717662113; c=relaxed/simple;
	bh=t6h+XbjMuJYKVtj2lKCILPFJuGlLTr7sOcrpwcQ6Reo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nRfPrMYNIy+6r17DR6FzQjnpkZJeohGMEXITIWlUJEbs2cDkXQxtO3DDJ0m6uUSvybr/mkSPkhiRFzZ7licpst9D1kWVyBxITYtEdwTCkgyzjYEkiwlbdUAKeXk9PqUdfZ5MmU0ST+G1odGOZZeWqGmDQ3EnHOU3h9OkhxO37oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ubMXJ/12; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ubMXJ/12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B83C32782;
	Thu,  6 Jun 2024 08:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717662112;
	bh=t6h+XbjMuJYKVtj2lKCILPFJuGlLTr7sOcrpwcQ6Reo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ubMXJ/12hO6XkyVbzDW2Dyj6L1esBDUIDWeVFFYPZU+T9xbYmYlOIj++hFg+JgdkK
	 46tvCOiuAFBWsWVbdMwrCNIyOPvKjB0YL2ufKMJ58fjoBN+QtbwWeZskXQmnsXgHHK
	 4EfwRfv3ExoHqb41LnrgT1MTUzbl5O+WsvmApSnEA+ImmHhYfDeSDrlVVDCKnDfifp
	 Mj6cV3B9doWJ5gvjt5cJMBsC+3sCN+Az3y7ePDVEumaCjNvlL59ugPL9+b9QuTslDS
	 N1uCCMWura23tL+sGDDbpIDFpKmELS5ZHx+L62CjroyLznaEvL96MbCVIpaZRjDr+S
	 rLzHWKHSk2UUA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v6 2/4] dm: Call dm_revalidate_zones() after setting the queue limits
Date: Thu,  6 Jun 2024 17:21:45 +0900
Message-ID: <20240606082147.96422-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606082147.96422-1-dlemoal@kernel.org>
References: <20240606082147.96422-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm_revalidate_zones() is called from dm_set_zone_restrictions() when the
mapped device queue limits are not yet set. However,
dm_revalidate_zones() calls blk_revalidate_disk_zones() and this
function consults and modifies the mapped device queue limits. Thus,
currently, blk_revalidate_disk_zones() operates on limits that are not
yet initialized.

Fix this by moving the call to dm_revalidate_zones() out of
dm_set_zone_restrictions() and into dm_table_set_restrictions() after
executing queue_limits_set().

To further cleanup dm_set_zones_restrictions(), the message about the
type of zone append (native or emulated) is also moved inside
dm_revalidate_zones().

Fixes: 1c0e720228ad ("dm: use queue_limits_set")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-table.c | 15 +++++++++++----
 drivers/md/dm-zone.c  | 25 ++++++++++---------------
 drivers/md/dm.h       |  1 +
 3 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index b2d5246cff21..2fc847af254d 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -2028,10 +2028,7 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	    dm_table_any_dev_attr(t, device_is_not_random, NULL))
 		blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
 
-	/*
-	 * For a zoned target, setup the zones related queue attributes
-	 * and resources necessary for zone append emulation if necessary.
-	 */
+	/* For a zoned table, setup the zone related queue attributes. */
 	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) && limits->zoned) {
 		r = dm_set_zones_restrictions(t, q, limits);
 		if (r)
@@ -2042,6 +2039,16 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	if (r)
 		return r;
 
+	/*
+	 * Now that the limits are set, check the zones mapped by the table
+	 * and setup the resources for zone append emulation if necessary.
+	 */
+	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) && limits->zoned) {
+		r = dm_revalidate_zones(t, q);
+		if (r)
+			return r;
+	}
+
 	dm_update_crypto_profile(q, t);
 
 	/*
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 5d66d916730e..75d0019a0649 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -166,14 +166,22 @@ static int dm_check_zoned_cb(struct blk_zone *zone, unsigned int idx,
  * blk_revalidate_disk_zones() function here as the mapped device is suspended
  * (this is called from __bind() context).
  */
-static int dm_revalidate_zones(struct mapped_device *md, struct dm_table *t)
+int dm_revalidate_zones(struct dm_table *t, struct request_queue *q)
 {
+	struct mapped_device *md = t->md;
 	struct gendisk *disk = md->disk;
 	int ret;
 
+	if (!get_capacity(disk))
+		return 0;
+
 	/* Revalidate only if something changed. */
-	if (!disk->nr_zones || disk->nr_zones != md->nr_zones)
+	if (!disk->nr_zones || disk->nr_zones != md->nr_zones) {
+		DMINFO("%s using %s zone append",
+		       disk->disk_name,
+		       queue_emulates_zone_append(q) ? "emulated" : "native");
 		md->nr_zones = 0;
+	}
 
 	if (md->nr_zones)
 		return 0;
@@ -240,9 +248,6 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
 		lim->max_zone_append_sectors = 0;
 	}
 
-	if (!get_capacity(md->disk))
-		return 0;
-
 	/*
 	 * Count conventional zones to check that the mapped device will indeed 
 	 * have sequential write required zones.
@@ -269,16 +274,6 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
 		return 0;
 	}
 
-	if (!md->disk->nr_zones) {
-		DMINFO("%s using %s zone append",
-		       md->disk->disk_name,
-		       queue_emulates_zone_append(q) ? "emulated" : "native");
-	}
-
-	ret = dm_revalidate_zones(md, t);
-	if (ret < 0)
-		return ret;
-
 	if (!static_key_enabled(&zoned_enabled.key))
 		static_branch_enable(&zoned_enabled);
 	return 0;
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 53ef8207fe2c..c984ecb64b1e 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -103,6 +103,7 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t);
  */
 int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
 		struct queue_limits *lim);
+int dm_revalidate_zones(struct dm_table *t, struct request_queue *q);
 void dm_zone_endio(struct dm_io *io, struct bio *clone);
 #ifdef CONFIG_BLK_DEV_ZONED
 int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
-- 
2.45.2

