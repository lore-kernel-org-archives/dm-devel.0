Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0441312C483
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 14:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716560983; cv=none; b=o6wox3PvW7raOnHX/t9SvBd6nHj1hwUx+lzYK9Uj12z2xeQjnhAIolCTgHvN2ysbfSoX4m0t34wTt1qPV9qKVIMESP/+6ufbYRTKwc/GDXfaesHk1CaZFitiwGyGgD1X6Yzgtnn9ZyXRV+vaiEEhNBF3vmpteS/xanpQBTsNeM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716560983; c=relaxed/simple;
	bh=aYIybanKyqBH47FDinttBmlmSvJRWUTpQlgX7nP6zlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZTvjRXbb2akYhiwqf7jhije97FGNkyGdsLBu4p7dq63o0QT9Yokzt3JNZ89ESroXgrE9LExgiOnAP9Ys5BTXke8qT50p+lqKPIyIRSS8ehecvkNF/g9ofKzlC/DIUDRq3CVwr4kKzlXahZgPAyTXMB/2whEyGo3PKixkBNsna4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fq6V1zOI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fq6V1zOI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Tk2ound9ipIJbf+jfeJ65KHCVqvIKlGFAaDHqk/3fZY=; b=fq6V1zOITYvQ5AtLkOlCaacpEX
	3/U7uwPuKEb7BRtNMvy0idZoBRxq4GnYLz7Ocyn4kj15q2JydnlDqUBPNlbafTZRyJVaRWQZ2KM19
	87PFedtiNJ58ERElM3aBbq8rlG1QTAwx7+iH0EiyPtYgoIrAOfger0kFf45FNBuZ3TBvdU/mf5D1W
	x1pHa26JWFHZNDMi6yQIT4EGnEhR78kmtjj7um4qQp4VQwoB7UfGEckMDZ2Tu8z94rTmA3JmY+YEm
	qMXDD5OqkprpCnXJ4t7/2jWhVAWaXCCHkuIO3h6a3JH0haWIHDGS6vnj1nni7QPXY/4Os3CmhuqJV
	S1UY5uBA==;
Received: from [2001:4bb8:2dd:2931:3dd2:5393:218b:4dfd] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sAVvQ-000000097ci-37rG;
	Fri, 24 May 2024 14:29:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	dm-devel@lists.linux.dev
Subject: [PATCH 2/3] dm: remove dm_check_zoned
Date: Fri, 24 May 2024 16:29:10 +0200
Message-ID: <20240524142929.817565-3-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240524142929.817565-1-hch@lst.de>
References: <20240524142929.817565-1-hch@lst.de>
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
---
 drivers/md/dm-zone.c | 59 +++++++++++++++++---------------------------
 1 file changed, 23 insertions(+), 36 deletions(-)

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index eb1165324ab047..13b4857d98fe5b 100644
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

