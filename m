Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5291EE7D3
	for <dm-devel@lists.linux.dev>; Thu, 10 Apr 2025 19:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744314592; cv=none; b=rmhsesOt9JIzFUfaDv/lNdsVBJr+eS9a6hrtLdQqVBJCeQ7sV9Zhghe44cLN/2goYaSh3yZ2nK4I98x7znI9pJcoNgXnZq6Tmw2IyLAqoL6AeDtbPGar+Fz04BLQGGNrfWUBdYjbUFFzW01ndn1XkMSu5QNrkc5Rwuc2HHHlX6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744314592; c=relaxed/simple;
	bh=Lm1EP1rbLgxUh3KpbtscGzJEpzzog2z/rjnfrsHvrWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=KNVPkOBUhne8S3BOw3q2v01krSTzycrJGulrq6b1LdqWQ5lu7vt90v2o7YBFBrrXVJ0s+iOOoLd13Z7lrJLMmW4w0OdN9OQcWmlSBLfuVCD7TItp2grU8l6wZaRVNLFDoNP+GCZIzlRQufHcvi6vi+2nYSCrPa0ArC5yWMxLQs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QtjOgQ5d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QtjOgQ5d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744314589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jWIotH+/eF6D6agbBCgp6ONvFJx9P/Pp2raxsIYqSVo=;
	b=QtjOgQ5dRGBvtjFlkQIyAWrP7wTw4wPqYLOA3rFSdrVnHENynCBGTc1Xv4hUZei3NQT3/2
	XLq9c/HP3v3I8l+NSLSOEz3pDe8IKrWQyppqBwn/+BAk/rjmJOPGKcT7Jjk/4H8VJQ2S1x
	4mr8FhcqxpDV+Lso+Jn8jhb9ulb6kcE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-81-4w_t9uktMYiJ22vJBq7d5Q-1; Thu,
 10 Apr 2025 15:49:47 -0400
X-MC-Unique: 4w_t9uktMYiJ22vJBq7d5Q-1
X-Mimecast-MFC-AGG-ID: 4w_t9uktMYiJ22vJBq7d5Q_1744314586
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5119D1800263;
	Thu, 10 Apr 2025 19:49:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F3D061809B65;
	Thu, 10 Apr 2025 19:49:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53AJniOg009361
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Apr 2025 15:49:44 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53AJniHE009360;
	Thu, 10 Apr 2025 15:49:44 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Damien Le Moal <dlemoal@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4 5/6] dm: limit swapping tables for devices with zone write plugs
Date: Thu, 10 Apr 2025 15:49:42 -0400
Message-ID: <20250410194943.9326-6-bmarzins@redhat.com>
In-Reply-To: <20250410194943.9326-1-bmarzins@redhat.com>
References: <20250410194943.9326-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4bUdPB4UZnPBXLYBOGInc5zqTppipgp3VaTVb1NkDYw_1744314586
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

dm_revalidate_zones() only allowed new or previously unzoned devices to
call blk_revalidate_disk_zones(). If the device was already zoned,
disk->nr_zones would always equal md->nr_zones, so dm_revalidate_zones()
returned without doing any work. This would make the zoned settings for
the device not match the new table. If the device had zone write plug
resources, it could run into errors like bdev_zone_is_seq() reading
invalid memory because disk->conv_zones_bitmap was the wrong size.

If the device doesn't have any zone write plug resources, calling
blk_revalidate_disk_zones() will always correctly update device.  If
blk_revalidate_disk_zones() fails, it can still overwrite or clear the
current disk->nr_zones value. In this case, DM must restore the previous
value of disk->nr_zones, so that the zoned settings will continue to
match the previous value that it fell back to.

If the device already has zone write plug resources,
blk_revalidate_disk_zones() will not correctly update them, if it is
called for arbitrary zoned device changes.  Since there is not much need
for this ability, the easiest solution is to disallow any table reloads
that change the zoned settings, for devices that already have zone plug
resources.  Specifically, if a device already has zone plug resources
allocated, it can only switch to another zoned table that also emulates
zone append.  Also, it cannot change the device size or the zone size. A
device can switch to an error target.

Fixes: bb37d77239af2 ("dm: introduce zone append emulation")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-table.c | 41 ++++++++++++++++++++++++++++++++++++-----
 drivers/md/dm-zone.c  | 35 ++++++++++++++++++++++++++---------
 drivers/md/dm.c       |  6 ++++++
 drivers/md/dm.h       |  5 +++++
 4 files changed, 73 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index b8191ce691f1..04680c0950b7 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1496,6 +1496,18 @@ bool dm_table_has_no_data_devices(struct dm_table *t)
 	return true;
 }
 
+bool dm_table_is_wildcard(struct dm_table *t)
+{
+	for (unsigned int i = 0; i < t->num_targets; i++) {
+		struct dm_target *ti = dm_table_get_target(t, i);
+
+		if (!dm_target_is_wildcard(ti->type))
+			return false;
+	}
+
+	return true;
+}
+
 static int device_not_zoned(struct dm_target *ti, struct dm_dev *dev,
 			    sector_t start, sector_t len, void *data)
 {
@@ -1836,6 +1848,19 @@ static bool dm_table_supports_atomic_writes(struct dm_table *t)
 	return true;
 }
 
+bool dm_table_supports_size_change(struct dm_table *t, sector_t old_size,
+				   sector_t new_size)
+{
+	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) && dm_has_zone_plugs(t->md) &&
+	    old_size != new_size) {
+		DMWARN("%s: device has zone write plug resources. "
+		       "Cannot change size",
+		       dm_device_name(t->md));
+		return false;
+	}
+	return true;
+}
+
 int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			      struct queue_limits *limits)
 {
@@ -1873,11 +1898,17 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 		limits->features &= ~BLK_FEAT_DAX;
 
 	/* For a zoned table, setup the zone related queue attributes. */
-	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
-	    (limits->features & BLK_FEAT_ZONED)) {
-		r = dm_set_zones_restrictions(t, q, limits);
-		if (r)
-			return r;
+	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED)) {
+		if (limits->features & BLK_FEAT_ZONED) {
+			r = dm_set_zones_restrictions(t, q, limits);
+			if (r)
+				return r;
+		} else if (dm_has_zone_plugs(t->md)) {
+			DMWARN("%s: device has zone write plug resources. "
+			       "Cannot switch to non-zoned table.",
+			       dm_device_name(t->md));
+			return -EINVAL;
+		}
 	}
 
 	if (dm_table_supports_atomic_writes(t))
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 11e19281bb64..037295db1c2d 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -158,22 +158,22 @@ int dm_revalidate_zones(struct dm_table *t, struct request_queue *q)
 {
 	struct mapped_device *md = t->md;
 	struct gendisk *disk = md->disk;
+	unsigned int nr_zones = disk->nr_zones;
 	int ret;
 
 	if (!get_capacity(disk))
 		return 0;
 
-	/* Revalidate only if something changed. */
-	if (!disk->nr_zones || disk->nr_zones != md->nr_zones) {
-		DMINFO("%s using %s zone append",
-		       disk->disk_name,
-		       queue_emulates_zone_append(q) ? "emulated" : "native");
-		md->nr_zones = 0;
-	}
-
-	if (md->nr_zones)
+	/*
+	 * Do not revalidate if zone write plug resources have already
+	 * been allocated.
+	 */
+	if (dm_has_zone_plugs(md))
 		return 0;
 
+	DMINFO("%s using %s zone append", disk->disk_name,
+	       queue_emulates_zone_append(q) ? "emulated" : "native");
+
 	/*
 	 * Our table is not live yet. So the call to dm_get_live_table()
 	 * in dm_blk_report_zones() will fail. Set a temporary pointer to
@@ -187,6 +187,7 @@ int dm_revalidate_zones(struct dm_table *t, struct request_queue *q)
 
 	if (ret) {
 		DMERR("Revalidate zones failed %d", ret);
+		disk->nr_zones = nr_zones;
 		return ret;
 	}
 
@@ -383,12 +384,28 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
 		lim->max_open_zones = 0;
 		lim->max_active_zones = 0;
 		lim->max_hw_zone_append_sectors = 0;
+		lim->max_zone_append_sectors = 0;
 		lim->zone_write_granularity = 0;
 		lim->chunk_sectors = 0;
 		lim->features &= ~BLK_FEAT_ZONED;
 		return 0;
 	}
 
+	if (get_capacity(disk) && dm_has_zone_plugs(t->md)) {
+		if (q->limits.chunk_sectors != lim->chunk_sectors) {
+			DMWARN("%s: device has zone write plug resources. "
+			       "Cannot change zone size",
+			       disk->disk_name);
+			return -EINVAL;
+		}
+		if (lim->max_hw_zone_append_sectors != 0 &&
+		    !dm_table_is_wildcard(t)) {
+			DMWARN("%s: device has zone write plug resources. "
+			       "New table must emulate zone append",
+			       disk->disk_name);
+			return -EINVAL;
+		}
+	}
 	/*
 	 * Warn once (when the capacity is not yet set) if the mapped device is
 	 * partially using zone resources of the target devices as that leads to
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 292414da871d..240f6dab8dda 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2429,6 +2429,12 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 	size = dm_table_get_size(t);
 
 	old_size = dm_get_size(md);
+
+	if (!dm_table_supports_size_change(t, old_size, size)) {
+		old_map = ERR_PTR(-EINVAL);
+		goto out;
+	}
+
 	set_capacity(md->disk, size);
 
 	ret = dm_table_set_restrictions(t, md->queue, limits);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index e5d3a9f46a91..245f52b59215 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -58,6 +58,7 @@ void dm_table_event_callback(struct dm_table *t,
 			     void (*fn)(void *), void *context);
 struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector);
 bool dm_table_has_no_data_devices(struct dm_table *table);
+bool dm_table_is_wildcard(struct dm_table *t);
 int dm_calculate_queue_limits(struct dm_table *table,
 			      struct queue_limits *limits);
 int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
@@ -72,6 +73,8 @@ struct target_type *dm_table_get_immutable_target_type(struct dm_table *t);
 struct dm_target *dm_table_get_immutable_target(struct dm_table *t);
 struct dm_target *dm_table_get_wildcard_target(struct dm_table *t);
 bool dm_table_request_based(struct dm_table *t);
+bool dm_table_supports_size_change(struct dm_table *t, sector_t old_size,
+				   sector_t new_size);
 
 void dm_lock_md_type(struct mapped_device *md);
 void dm_unlock_md_type(struct mapped_device *md);
@@ -111,12 +114,14 @@ bool dm_is_zone_write(struct mapped_device *md, struct bio *bio);
 int dm_zone_get_reset_bitmap(struct mapped_device *md, struct dm_table *t,
 			     sector_t sector, unsigned int nr_zones,
 			     unsigned long *need_reset);
+#define dm_has_zone_plugs(md) ((md)->disk->zone_wplugs_hash != NULL)
 #else
 #define dm_blk_report_zones	NULL
 static inline bool dm_is_zone_write(struct mapped_device *md, struct bio *bio)
 {
 	return false;
 }
+#define dm_has_zone_plugs(md) false
 #endif
 
 /*
-- 
2.48.1

