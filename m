Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DF323A9;
	Wed,  1 May 2024 00:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714522178; cv=none; b=Osbc4mNkFYmAANu1YPyKlfh4yatBmuPMqATn638iRjRwlmYJSiwBqcL45NSEsEFDHvkagQC0JAFLe00Ts+ZbRZpxmdkuLDCDq+X6lRQUnMj9kIy/0pd2gwlwx6XovNbWdrcFibXRVlVAG/lKjEBc0HGzjkmInQ8lJo83qAaGUvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714522178; c=relaxed/simple;
	bh=ChfFb/6we4dypVrsro7WzU7smRAFTQaHLrdAlWc0GnU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcDBDdHoU6etVJq96YmqMkMcz0xAemVc+LnMvc0CBmRRF51mLTs+Z9gSyFIHWX4cr0O87lzn1pfzMU2npVPLJFoyOV21CEYsblvrlLWsDYj7F2Lh+8yHH3Buc1fKSnKOOdCM5tAP7hDk8YKHUO0Y7zKCwdFDF4L4dTGgCqbdu+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kr3Wv5AG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kr3Wv5AG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E47C4AF19;
	Wed,  1 May 2024 00:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714522178;
	bh=ChfFb/6we4dypVrsro7WzU7smRAFTQaHLrdAlWc0GnU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Kr3Wv5AGRHWWmpOXdsAkqZJ/sNchKnSu4UxPUGmD+UtrE026OYNIqp2NMymlNHqs9
	 ZOYXNeNQOc/q6egNnNqnFp5MzgOCmVSfE9KMPgAPEuneny0FbRVewZBIRZDJ3Vhp9l
	 PRPJHSIhc0Ete0zrhztw9612RIqFrCVbk0LPlZ2FlxhZsYvoO+4qzRK0JE9CGNIj65
	 mcEItNqwl23clFCXbfB4J6nRkJll5SwERuknsPfOrSRUSZ+7q/CH4c5Iu5V/fdp0O7
	 gm5yJIFMt6698lnqtaNZ1OB+p9pFrmELT9NHw9g7fF5pgr2qlGiYDLSng4JiKJggjE
	 inxGXPjNJ3AsQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 01/14] dm: Check that a zoned table leads to a valid mapped device
Date: Wed,  1 May 2024 09:09:22 +0900
Message-ID: <20240501000935.100534-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240501000935.100534-1-dlemoal@kernel.org>
References: <20240501000935.100534-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Using targets such as dm-linear, a mapped device can be created to
contain only conventional zones. Such device should not be treated as
zoned as it does not contain any mandatory sequential write required
zone. Since such device can be randomly written, we can modify
dm_set_zones_restrictions() to set the mapped device zoned queue limit
to false to expose it as a regular block device. The function
dm_check_zoned() does this after counting the number of conventional
zones of the mapped device and comparing it to the total number of zones
reported. The special dm_check_zoned_cb() report zones callback function
is used to count conventional zones.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/md/dm-table.c |  3 ++-
 drivers/md/dm-zone.c  | 53 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 41f1d731ae5a..2c6fbd87363f 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -2042,7 +2042,8 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 		r = dm_set_zones_restrictions(t, q);
 		if (r)
 			return r;
-		if (!static_key_enabled(&zoned_enabled.key))
+		if (blk_queue_is_zoned(q) &&
+		    !static_key_enabled(&zoned_enabled.key))
 			static_branch_enable(&zoned_enabled);
 	}
 
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index d17ae4486a6a..3071f67d72aa 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -145,6 +145,48 @@ bool dm_is_zone_write(struct mapped_device *md, struct bio *bio)
 	}
 }
 
+/*
+ * Count conventional zones of a mapped zoned device. If the device
+ * only has conventional zones, do not expose it as zoned.
+ */
+static int dm_check_zoned_cb(struct blk_zone *zone, unsigned int idx,
+			     void *data)
+{
+	unsigned int *nr_conv_zones = data;
+
+	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
+		(*nr_conv_zones)++;
+
+	return 0;
+}
+
+static int dm_check_zoned(struct mapped_device *md, struct dm_table *t)
+{
+	struct gendisk *disk = md->disk;
+	unsigned int nr_conv_zones = 0;
+	int ret;
+
+	/* Revalidate only if something changed. */
+	md->zone_revalidate_map = t;
+	ret = dm_blk_report_zones(disk, 0, UINT_MAX,
+				  dm_check_zoned_cb, &nr_conv_zones);
+	md->zone_revalidate_map = NULL;
+	if (ret < 0) {
+		DMERR("Check zoned failed %d", ret);
+		return ret;
+	}
+
+	if (nr_conv_zones >= ret) {
+		disk->queue->limits.max_open_zones = 0;
+		disk->queue->limits.max_active_zones = 0;
+		disk->queue->limits.zoned = false;
+		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
+		disk->nr_zones = 0;
+	}
+
+	return 0;
+}
+
 /*
  * Revalidate the zones of a mapped device to initialize resource necessary
  * for zone append emulation. Note that we cannot simply use the block layer
@@ -208,6 +250,7 @@ static bool dm_table_supports_zone_append(struct dm_table *t)
 int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
 {
 	struct mapped_device *md = t->md;
+	int ret;
 
 	/*
 	 * Check if zone append is natively supported, and if not, set the
@@ -224,6 +267,16 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
 	if (!get_capacity(md->disk))
 		return 0;
 
+	/*
+	 * Check that the mapped device will indeed be zoned, that is, that it
+	 * has sequential write required zones.
+	 */
+	ret = dm_check_zoned(md, t);
+	if (ret)
+		return ret;
+	if (!blk_queue_is_zoned(q))
+		return 0;
+
 	if (!md->disk->nr_zones) {
 		DMINFO("%s using %s zone append",
 		       md->disk->disk_name,
-- 
2.44.0

