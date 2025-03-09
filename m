Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BAA1F585D
	for <dm-devel@lists.linux.dev>; Sun,  9 Mar 2025 22:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741559355; cv=none; b=g/Ds/b2Bk3blR7S50Z7PA6eYOtI8ZUQbLINLI9wwS1OQ+RzW+bkk2kBBNr/CZuzv0BUOIZe+4BP69EAAUFwEz01y4DnVSpqvt5kI7rusTGW7jClHd4+gjw8EXaV1gl9DaiXpMWqzdRUqKwl1srtQr45U/orcYYEZh0esXRlTuTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741559355; c=relaxed/simple;
	bh=wEBY7Oj29M2D0Dmp362L0Hp7USy1ZPKfP0Cp+xoOaHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e64in/IZgp3vVEDAJBQ6fLpjgGYUBdDK9Gno7dD7c249YzsR0COS3rgdcN/0aMQ76oukRjePPLk63Rc0xv7Io59fmAcL0CQIfr3PAfBzvsOQkNCqkOxzGw/e7/eqVx6+z7TPa61cU+8WAemyWRs1TYYIO5itXBIaipxPiLmv8g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DPM36FLN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DPM36FLN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741559352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yTmrroXbLUYBu+54zjexbe1SJ0Kvrf2MRZCMFkFLWhY=;
	b=DPM36FLNP3a/Tg2oVlshjHx9OARRU66V2EiUcNBGBTurRR/W0YMy+in88OVuZPn1X8xnKJ
	aMxSBYXe4Qi45LBIUVDExNEDhJKR3logl2CEPSJnejHHx+5n7Trs3s4nOiYiPFE7wgLGto
	J3NVYya17oamehHDJzQN/gtyTvduODM=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-679-TCwUvQ0qM1edNUrtcDfbuA-1; Sun,
 09 Mar 2025 18:29:08 -0400
X-MC-Unique: TCwUvQ0qM1edNUrtcDfbuA-1
X-Mimecast-MFC-AGG-ID: TCwUvQ0qM1edNUrtcDfbuA_1741559347
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CF90219560A3;
	Sun,  9 Mar 2025 22:29:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D6C511955BCB;
	Sun,  9 Mar 2025 22:29:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 529MT5po449843
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 9 Mar 2025 18:29:05 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 529MT5b8449842;
	Sun, 9 Mar 2025 18:29:05 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
        Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: [RFC PATCH 6/7] blk-zoned: modify blk_revalidate_disk_zones for bio-based drivers
Date: Sun,  9 Mar 2025 18:29:02 -0400
Message-ID: <20250309222904.449803-7-bmarzins@redhat.com>
In-Reply-To: <20250309222904.449803-1-bmarzins@redhat.com>
References: <20250309222904.449803-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

If device-mapper is swapping zoned tables, and
blk_revalidate_disk_zones() fails. It must retain its current zoned
resources since device-mapper will be failing back to using the previous
table and the zoned settings need to match the table. Allocating
unnecessary zwplugs is acceptable, but the zoned configuration must not
change.  Otherwise it can run into errors like bdev_zone_is_seq()
reading invalid memory because disk->conv_zones_bitmap is the wrong
size. However if device-mapper did not previously have a zoned table, it
should free up the zoned resources, instead of leaving them allocated
and unused.

To solve this, do not free the zone resources when
blk_revalidate_disk_zones() fails for bio based drivers. Additionally,
delay copying the zoned settings to the gendisk until
disk_update_zone_resources() can no longer fail, and do not freeze the
queue for bio-based drivers, since this will hang if there are any
plugged zone write bios.

Also, export disk_free_zone_resources() so that device-mapper can choose
when to free the zoned resources.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 block/blk-zoned.c      | 49 +++++++++++++++++++++++-------------------
 block/blk.h            |  4 ----
 drivers/md/dm-zone.c   |  3 +++
 include/linux/blkdev.h |  4 ++++
 4 files changed, 34 insertions(+), 26 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index d7dc89cbdccb..3bec289d27db 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1343,22 +1343,17 @@ static void disk_destroy_zone_wplugs_hash_table(struct gendisk *disk)
 	disk->zone_wplugs_hash_bits = 0;
 }
 
-static unsigned int disk_set_conv_zones_bitmap(struct gendisk *disk,
-					       unsigned long *bitmap)
+static void disk_set_conv_zones_bitmap(struct gendisk *disk,
+				       unsigned long *bitmap)
 {
-	unsigned int nr_conv_zones = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
-	if (bitmap)
-		nr_conv_zones = bitmap_weight(bitmap, disk->nr_zones);
 	bitmap = rcu_replace_pointer(disk->conv_zones_bitmap, bitmap,
 				     lockdep_is_held(&disk->zone_wplugs_lock));
 	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
 
 	kfree_rcu_mightsleep(bitmap);
-
-	return nr_conv_zones;
 }
 
 void disk_free_zone_resources(struct gendisk *disk)
@@ -1386,6 +1381,7 @@ void disk_free_zone_resources(struct gendisk *disk)
 	disk->last_zone_capacity = 0;
 	disk->nr_zones = 0;
 }
+EXPORT_SYMBOL_GPL(disk_free_zone_resources);
 
 static inline bool disk_need_zone_resources(struct gendisk *disk)
 {
@@ -1434,24 +1430,23 @@ struct blk_revalidate_zone_args {
 
 /*
  * Update the disk zone resources information and device queue limits.
- * The disk queue is frozen when this is executed.
+ * The disk queue is frozen when this is executed on blk-mq drivers.
  */
 static int disk_update_zone_resources(struct gendisk *disk,
 				      struct blk_revalidate_zone_args *args)
 {
 	struct request_queue *q = disk->queue;
-	unsigned int nr_seq_zones, nr_conv_zones;
+	unsigned int nr_seq_zones, nr_conv_zones = 0;
 	unsigned int pool_size;
 	struct queue_limits lim;
+	int ret;
 
-	disk->nr_zones = args->nr_zones;
-	disk->zone_capacity = args->zone_capacity;
-	disk->last_zone_capacity = args->last_zone_capacity;
-	nr_conv_zones =
-		disk_set_conv_zones_bitmap(disk, args->conv_zones_bitmap);
-	if (nr_conv_zones >= disk->nr_zones) {
+	if (args->conv_zones_bitmap)
+		nr_conv_zones = bitmap_weight(args->conv_zones_bitmap,
+					      args->nr_zones);
+	if (nr_conv_zones >= args->nr_zones) {
 		pr_warn("%s: Invalid number of conventional zones %u / %u\n",
-			disk->disk_name, nr_conv_zones, disk->nr_zones);
+			disk->disk_name, nr_conv_zones, args->nr_zones);
 		return -ENODEV;
 	}
 
@@ -1463,7 +1458,7 @@ static int disk_update_zone_resources(struct gendisk *disk,
 	 * small ZNS namespace. For such case, assume that the zoned device has
 	 * no zone resource limits.
 	 */
-	nr_seq_zones = disk->nr_zones - nr_conv_zones;
+	nr_seq_zones = args->nr_zones - nr_conv_zones;
 	if (lim.max_open_zones >= nr_seq_zones)
 		lim.max_open_zones = 0;
 	if (lim.max_active_zones >= nr_seq_zones)
@@ -1493,7 +1488,19 @@ static int disk_update_zone_resources(struct gendisk *disk,
 	}
 
 commit:
-	return queue_limits_commit_update_frozen(q, &lim);
+	if (queue_is_mq(disk->queue))
+		ret = queue_limits_commit_update_frozen(q, &lim);
+	else
+		ret = queue_limits_commit_update(q, &lim);
+
+	if (!ret) {
+		disk->nr_zones = args->nr_zones;
+		disk->zone_capacity = args->zone_capacity;
+		disk->last_zone_capacity = args->last_zone_capacity;
+		disk_set_conv_zones_bitmap(disk, args->conv_zones_bitmap);
+	}
+
+	return ret;
 }
 
 static int blk_revalidate_conv_zone(struct blk_zone *zone, unsigned int idx,
@@ -1648,8 +1655,6 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
  * and when the zone configuration of the gendisk changes (e.g. after a format).
  * Before calling this function, the device driver must already have set the
  * device zone size (chunk_sector limit) and the max zone append limit.
- * BIO based drivers can also use this function as long as the device queue
- * can be safely frozen.
  */
 int blk_revalidate_disk_zones(struct gendisk *disk)
 {
@@ -1709,13 +1714,13 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 
 	/*
 	 * Set the new disk zone parameters only once the queue is frozen and
-	 * all I/Os are completed.
+	 * all I/Os are completed on blk-mq drivers.
 	 */
 	if (ret > 0)
 		ret = disk_update_zone_resources(disk, &args);
 	else
 		pr_warn("%s: failed to revalidate zones\n", disk->disk_name);
-	if (ret) {
+	if (ret && queue_is_mq(disk->queue)) {
 		unsigned int memflags = blk_mq_freeze_queue(q);
 
 		disk_free_zone_resources(disk);
diff --git a/block/blk.h b/block/blk.h
index 90fa5f28ccab..c84af503b77b 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -454,7 +454,6 @@ static inline struct bio *blk_queue_bounce(struct bio *bio,
 
 #ifdef CONFIG_BLK_DEV_ZONED
 void disk_init_zone_resources(struct gendisk *disk);
-void disk_free_zone_resources(struct gendisk *disk);
 static inline bool bio_zone_write_plugging(struct bio *bio)
 {
 	return bio_flagged(bio, BIO_ZONE_WRITE_PLUGGING);
@@ -500,9 +499,6 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, blk_mode_t mode,
 static inline void disk_init_zone_resources(struct gendisk *disk)
 {
 }
-static inline void disk_free_zone_resources(struct gendisk *disk)
-{
-}
 static inline bool bio_zone_write_plugging(struct bio *bio)
 {
 	return false;
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 11e19281bb64..ac86011640c3 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -159,6 +159,7 @@ int dm_revalidate_zones(struct dm_table *t, struct request_queue *q)
 	struct mapped_device *md = t->md;
 	struct gendisk *disk = md->disk;
 	int ret;
+	bool was_zoned = disk->nr_zones != 0;
 
 	if (!get_capacity(disk))
 		return 0;
@@ -187,6 +188,8 @@ int dm_revalidate_zones(struct dm_table *t, struct request_queue *q)
 
 	if (ret) {
 		DMERR("Revalidate zones failed %d", ret);
+		if (!was_zoned)
+			disk_free_zone_resources(disk);
 		return ret;
 	}
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 248416ecd01c..51edf35ff715 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -690,12 +690,16 @@ static inline bool blk_queue_is_zoned(struct request_queue *q)
 }
 
 #ifdef CONFIG_BLK_DEV_ZONED
+void disk_free_zone_resources(struct gendisk *disk);
 static inline unsigned int disk_nr_zones(struct gendisk *disk)
 {
 	return disk->nr_zones;
 }
 bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs);
 #else /* CONFIG_BLK_DEV_ZONED */
+static inline void disk_free_zone_resources(struct gendisk *disk)
+{
+}
 static inline unsigned int disk_nr_zones(struct gendisk *disk)
 {
 	return 0;
-- 
2.48.1

