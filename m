Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8700622064;
	Mon, 27 May 2024 08:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716797087; cv=none; b=IFEeq00CcdXjvhCW3YPguSkrpFSSag4LXL9S8TgtjpkSGpbN2kmmlaCvqmxcYgZl26OARfoifsLzF8l8idimu8MnIEoSt+TrycsJOcTM1t86nxhGCHOQVcBlfROaLdUuvZO4vUbCFR30iewjQm2fqFhHvFNQhQUu3q2T4ZoIKfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716797087; c=relaxed/simple;
	bh=J3Sg4YwTVp/79+lhFzCb8z/RnEN7h9efuinMRpk7Vqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apTa8a+AoeazqoacTl27aNsLIpLubl4H+e8fCg0ygTpQc42DE/xIX7aESuaKAFEw1Jm8Sh9emTWG0+NNIk1QH3QYAyjsrINBEkJqUlZDOdcSI+PrbYb7VZrhMWyPLdLkaKOTMiC9REkUuL5Tc1dxyPhHqikw4+A2l77aWCZ6nxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=i0tvWjGW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i0tvWjGW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6DkYMyOULdedhk/4nMLsECp+rsvb5FND6u2c2SP/QTA=; b=i0tvWjGWFbbA+DELwkk5tpzf7Q
	h5xeoeDvZ/TrpL5MXsQ1Eny26mJKJjUK2JLJPN47q8M5ZnbktCxpzLFgJOg8MS677y7jMhbIizWrH
	ktQlp13I8MmRsDqTJ7xDQsw9jZ8nKG9nmigq+PG97cPdSLXjpiZDnalB1WDLtR3rdfLX4Hf0UEDJA
	xSVrp57v0bGnhJerydGkMxHqO51CyaA2DTgyWVpWW6SHlY7IbunZUdOtVCEedKodXdusu4I7cy/4e
	mEJT6oRMv62hJ0Qin7pf8i4VZtxkWXvkmnjULXyyzA1JF6UPABSPPinH5KvFmvrb6JErK2pB/klXm
	UbQVFjdg==;
Received: from 2a02-8389-2341-5b80-3177-e4c1-2108-f294.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3177:e4c1:2108:f294] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sBVLY-0000000EAj3-1cQr;
	Mon, 27 May 2024 08:04:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: [PATCH 2/3] dm: remove dm_check_zoned
Date: Mon, 27 May 2024 10:04:25 +0200
Message-ID: <20240527080435.1029612-3-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240527080435.1029612-1-hch@lst.de>
References: <20240527080435.1029612-1-hch@lst.de>
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

