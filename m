Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460AE86262
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 14:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716560988; cv=none; b=gRPS9PTN9l5WvW5MYPpTD6yrP9VOsCbR8d/MjTMJH2anDlBM7DaOu8QzwIr+3r4fhhWbCsRAMPusT1aX7ahaBT10VhdRBupYrjJAzlJZoTYuZVVnm9R6kOt1UVmHMXkMFkhc9ypTs6PvpXh/cgoxNasdLv01q5Mj3xXCKUhiYJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716560988; c=relaxed/simple;
	bh=f6b1oq2XR17tzZKT2KpSPO4AcWqaA3+exze5MLhdonk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rB85+VQeDzeUDrM7JrBchpiJ+qEcemgIE4iYX+kJGES59wrd2CA0cBrd9mJ9rWI9CFORzktV9q0LBG4oLSAWvM709fPeHopb4AdGewZQHnwjBFg/mBQVDZ7pmpr0bzU+NboaqaDOGmdZ4egtoUFGoZhRX/x5XZ7p8Ik+idEoEow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ll8LHhxP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ll8LHhxP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EloC0hg3AK7jpk8XFiSg9G3Mz8fEBoZkLmqpwNpsZ+M=; b=ll8LHhxPxi+D9NfNwOi81G5x4h
	H+uB1cs1UEzYQJXWOiZu6uUPyyjzPbs3DSJ4SaEsdqHODHCuwK2vs9cL0GUGUtidoo7ZhIGjsxdEv
	hKscavOCVxsy+mzzN1TpVzfeKGNMGjPEUGiKUUuXf+3wBLRCdz4ZBRyihPogb/j+S2pQLpcx7ym/I
	yXk3w3jMXp2JQrSKTzvy1eFHSe7yBZMa5JGpWS2kBs+RyU9qnSbY2dKkX0yaE5UmfxiYpQd50zB6S
	JnXOi8mdoMM7VgeQLRi8XaKfc1BqX4vT8BQS5Us64pLuPiSzZjhWrX6LZMBd1zcgC7j+PETeewHCC
	Tz37Itcg==;
Received: from [2001:4bb8:2dd:2931:3dd2:5393:218b:4dfd] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sAVvU-000000097cq-2IXC;
	Fri, 24 May 2024 14:29:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	dm-devel@lists.linux.dev
Subject: [PATCH 3/3] dm: make dm_set_zones_restrictions work on the queue limits
Date: Fri, 24 May 2024 16:29:11 +0200
Message-ID: <20240524142929.817565-4-hch@lst.de>
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

Don't stuff the values directly into the queue without any
synchronization, but instead delay applying the queue limits in
the caller and let dm_set_zones_restrictions work on the limit
structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-table.c | 16 +++++++++-------
 drivers/md/dm-zone.c  | 11 ++++++-----
 drivers/md/dm.h       |  3 ++-
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index e291b78b307b13..6e4ee829005e92 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1981,10 +1981,6 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	if (!dm_table_supports_secure_erase(t))
 		limits->max_secure_erase_sectors = 0;
 
-	r = queue_limits_set(q, limits);
-	if (r)
-		return r;
-
 	if (dm_table_supports_flush(t, (1UL << QUEUE_FLAG_WC))) {
 		wc = true;
 		if (dm_table_supports_flush(t, (1UL << QUEUE_FLAG_FUA)))
@@ -2036,12 +2032,18 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	 * For a zoned target, setup the zones related queue attributes
 	 * and resources necessary for zone append emulation if necessary.
 	 */
-	if (blk_queue_is_zoned(q)) {
-		r = dm_set_zones_restrictions(t, q);
-		if (r)
+	if (limits->zoned) {
+		r = dm_set_zones_restrictions(t, q, limits);
+		if (r) {
+			queue_limits_cancel_update(q);
 			return r;
+		}
 	}
 
+	r = queue_limits_set(q, limits);
+	if (r)
+		return r;
+
 	dm_update_crypto_profile(q, t);
 
 	/*
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 13b4857d98fe5b..719238aa3006ba 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -220,7 +220,8 @@ static bool dm_table_supports_zone_append(struct dm_table *t)
 	return true;
 }
 
-int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
+int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
+		struct queue_limits *lim)
 {
 	struct mapped_device *md = t->md;
 	struct gendisk *disk = md->disk;
@@ -236,7 +237,7 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
 		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
 	} else {
 		set_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
-		blk_queue_max_zone_append_sectors(q, 0);
+		lim->max_zone_append_sectors = 0;
 	}
 
 	if (!get_capacity(md->disk))
@@ -260,9 +261,9 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
 	 * a regular device.
 	 */
 	if (nr_conv_zones >= ret) {
-		disk->queue->limits.max_open_zones = 0;
-		disk->queue->limits.max_active_zones = 0;
-		disk->queue->limits.zoned = false;
+		lim->max_open_zones = 0;
+		lim->max_active_zones = 0;
+		lim->zoned = false;
 		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
 		disk->nr_zones = 0;
 		return 0;
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index e0c57f19839b29..53ef8207fe2c15 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -101,7 +101,8 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t);
 /*
  * Zoned targets related functions.
  */
-int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q);
+int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
+		struct queue_limits *lim);
 void dm_zone_endio(struct dm_io *io, struct bio *clone);
 #ifdef CONFIG_BLK_DEV_ZONED
 int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
-- 
2.43.0

