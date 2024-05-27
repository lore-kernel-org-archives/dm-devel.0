Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D62538FA6;
	Mon, 27 May 2024 12:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716813407; cv=none; b=bvQXJRtJbfMwrapusHCMPLTeFg68YQYqPPDZBR6Ozl/BlgjxjXats0OjQR7YJJgbAkQ/o3dgejj51BD19ItK1dlZcXlkna6t5VOO8cGlmy997cU2WUpx4BWoYW4N8RM0LyowUPazUQQTdy4DRJKBTs4eZ3LzSG48G+uFWCvSJag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716813407; c=relaxed/simple;
	bh=NYriYXpSqsJDrM118vsvzmvGe9hyyTAwI1K2iX7bjOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PY2L02wRAqwF0JTAhIdxqjeXaeJO38YEwHReVv6WZLcKbFf94ThIljoaDto81pAd0/B2te2Knz6T1oEZVnb7TCEuQexx90jM4O5o3C8ISi2vX9mK2wgkc8t/oCWGY6XpAcz57zCFqC+mi9sC/D++rqLDBxRtsq3efLE/3zfonao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kEgK4bHG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kEgK4bHG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5zOWSMAOrJq6SM1TFr3PCDRviHqL9Ywl/qlOfyrySuc=; b=kEgK4bHGbFdcMSsKk8AmCnuGqD
	v9P+IvRhceCfr0hRd5vNRAG3NqJrlsSyjgz21fat2elPDIHaY5OAJU/dzFYlEQRUI3ISTMF3j8pQW
	YHNLFndgZrQweFHMyYWWo/XIcB0sICF4fzsyhpmuq6qc3Tn3aiZAD3dwlA54Gf7OlxqjUvtHnI2he
	KMj2oYqaLcBu7ALAV/aKsQ/BvFX9fvar6gRFoS7LVtH6qq5gwv95HwaX4sBWET5HXaf5Txp9W3atj
	UKRI60PHJhiYwWKgA9X4iw80ML+jWhKOxQ5QOOFvbVw2DCIeT2TwIolAKnNVJmgwYJYFWhD/XXUXt
	e+GJKYrA==;
Received: from 2a02-8389-2341-5b80-3177-e4c1-2108-f294.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3177:e4c1:2108:f294] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sBZam-0000000Eu1c-2jDE;
	Mon, 27 May 2024 12:36:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 2/3] dm: remove dm_check_zoned
Date: Mon, 27 May 2024 14:36:19 +0200
Message-ID: <20240527123634.1116952-3-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240527123634.1116952-1-hch@lst.de>
References: <20240527123634.1116952-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Fold it into the only caller in preparation to changes in the
queue limits setup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/md/dm-zone.c | 59 +++++++++++++++++---------------------------
 1 file changed, 23 insertions(+), 36 deletions(-)

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 3103360ce7f040..0ee22494857d07 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -160,37 +160,6 @@ static int dm_check_zoned_cb(struct blk_zone *zone, unsigned int idx,
 	return 0;
 }
 
-static int dm_check_zoned(struct mapped_device *md, struct dm_table *t)
-{
-	struct gendisk *disk = md->disk;
-	unsigned int nr_conv_zones = 0;
-	int ret;
-
-	/* Count conventional zones */
-	md->zone_revalidate_map = t;
-	ret = dm_blk_report_zones(disk, 0, UINT_MAX,
-				  dm_check_zoned_cb, &nr_conv_zones);
-	md->zone_revalidate_map = NULL;
-	if (ret < 0) {
-		DMERR("Check zoned failed %d", ret);
-		return ret;
-	}
-
-	/*
-	 * If we only have conventional zones, expose the mapped device as
-	 * a regular device.
-	 */
-	if (nr_conv_zones >= ret) {
-		disk->queue->limits.max_open_zones = 0;
-		disk->queue->limits.max_active_zones = 0;
-		disk->queue->limits.zoned = false;
-		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
-		disk->nr_zones = 0;
-	}
-
-	return 0;
-}
-
 /*
  * Revalidate the zones of a mapped device to initialize resource necessary
  * for zone append emulation. Note that we cannot simply use the block layer
@@ -254,6 +223,8 @@ static bool dm_table_supports_zone_append(struct dm_table *t)
 int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
 {
 	struct mapped_device *md = t->md;
+	struct gendisk *disk = md->disk;
+	unsigned int nr_conv_zones = 0;
 	int ret;
 
 	/*
@@ -272,14 +243,30 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
 		return 0;
 
 	/*
-	 * Check that the mapped device will indeed be zoned, that is, that it
-	 * has sequential write required zones.
+	 * Count conventional zones to check that the mapped device will indeed 
+	 * have sequential write required zones.
 	 */
-	ret = dm_check_zoned(md, t);
-	if (ret)
+	md->zone_revalidate_map = t;
+	ret = dm_blk_report_zones(disk, 0, UINT_MAX,
+				  dm_check_zoned_cb, &nr_conv_zones);
+	md->zone_revalidate_map = NULL;
+	if (ret < 0) {
+		DMERR("Check zoned failed %d", ret);
 		return ret;
-	if (!blk_queue_is_zoned(q))
+	}
+
+	/*
+	 * If we only have conventional zones, expose the mapped device as
+	 * a regular device.
+	 */
+	if (nr_conv_zones >= ret) {
+		disk->queue->limits.max_open_zones = 0;
+		disk->queue->limits.max_active_zones = 0;
+		disk->queue->limits.zoned = false;
+		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
+		disk->nr_zones = 0;
 		return 0;
+	}
 
 	if (!md->disk->nr_zones) {
 		DMINFO("%s using %s zone append",
-- 
2.43.0

