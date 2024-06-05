Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA0419048C;
	Wed,  5 Jun 2024 06:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717569552; cv=none; b=Wl4hcAPDEgmOagtQOcAHLsLPxwQtytVw3qqdefbgT+ZOjwh51CWMsdSoL1sh/xsHhpLbFTeHe++wFvTykGpi1oGMY2871WHG+lZFqbNFnLs22g73XJa+SsGw6bf2XGYGO00ZfuOPMPan9ItWESLo0umPSCQucOgizHfaKauuIV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717569552; c=relaxed/simple;
	bh=vHENwwhdO7A7mg4H3rI1h3q/Eixi55xDx0L/9AkBom4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OkEq1irUc40cBZOM3FMXqKDpoHar3YgxsOUBYtg6W47c8Pt74f6x4sho+7QSVZgoqppAmFFiUB7q0kfOtCbx3D1gX2S4+s3/KLN8cOD6qN2RKPOcP5NxIDA8lavnklVqYwIMDufcNmJ5KaZSM1ns7MvUwoIH7q7CeQcIXFZH0oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ci+Vzhgz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ci+Vzhgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D63AC4AF08;
	Wed,  5 Jun 2024 06:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717569552;
	bh=vHENwwhdO7A7mg4H3rI1h3q/Eixi55xDx0L/9AkBom4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ci+VzhgzSNh85wvWs+lhrnMD/vjIT629+E+1IbM1Rq23Q3RSP3wW+1MOeDY79dOXM
	 +n19ZlV4lgpWxB2g10mxfTwn1HsfvqQlhxuDVwEfucFk4ThNLCY0oIE/mzNN0n6Xq2
	 2FirOJ9DTzrMYASn8jmjxlfFt9dWr+wECjXb60fWom/v8ekqcIFYn2YAJU79B6YgDo
	 d68N92tN3B7US2lCQN5Bvxr/GS60w+psa7UvehFi35GIzzL1WS1W93C4nBPdCSDewJ
	 CCrOt7xlrmIVyZpYJqhzpAcZerlXR7KsvIVYLnSvhIHCLCjisNywJc2g1UJCZwYeVw
	 oooqM0v2pskYg==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v3 2/2] dm: Improve zone resource limits handling
Date: Wed,  5 Jun 2024 15:39:06 +0900
Message-ID: <20240605063907.129120-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240605063907.129120-1-dlemoal@kernel.org>
References: <20240605063907.129120-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The generic stacking of limits implemented in the block layer cannot
correctly handle stacking of zone resource limits (max open zones and
max active zones) because these limits are for an entire device but the
stacking may be for a portion of that device (e.g. a dm-linear target
that does not cover an entire block device). As a result, when DM
devices are created on top of zoned block devices, the DM device never
has any zone resource limits advertized, which is only correct if all
underlying target devices also have no zone resource limits.
If at least one target device has resource limits, the user may see
either performance issues (if the max open zone limit of the device is
exceeded) or write I/O errors if the max active zone limit of one of
the underlying target devices is exceeded.

While it is very difficult to correctly and reliably stack zone resource
limits in general, cases where targets are not sharing zone resources of
the same device can be dealt with relatively easily. Such situation
happens when a target maps all sequential zones of a zoned block device:
for such mapping, other targets mapping other parts of the same zoned
block device can only contain conventional zones and thus will not
require any zone resource to correctly handle write operations.

For a mapped device constructed with such targets, which includes mapped
devices constructed with targets mapping entire zoned block devices, the
zone resource limits can be reliably determined using the non-zero
minimum of the zone resource limits of all targets.

For mapped devices that include targets partially mapping the set of
sequential write required zones of zoned block devices, instead of
advertizing no zone resource limits, it is also better to set the mapped
device limits to the non-zero minimum of the limits of all targets. In
this case the limits for a target depend on the number of sequential
zones being mapped: if this number of zone is larger than the limits,
then the limits of the device apply and can be used. If on the other
hand the target maps a number of zones smaller than the limits, then no
limits is needed and we can assume that the target has no limits (limits
set to 0).

This commit improves zone resource limits handling as described above
using the function dm_set_zone_resource_limits(). This function is
executed from dm_set_zones_restrictions() and iterates the targets of a
mapped device to evaluate the max open and max active zone limits. This
relies on an internal "stacking" of the limits of the target devices
combined with a direct counting of the number of sequential zones
mapped by the targets.
1) For a target mapping an entire zoned block device, the limits for the
   target are set to the limits of the device.
2) For a target partially mapping a zoned block device, the number of
   mapped sequential zones is used to determine the limits: if the
   target maps more sequential write required zones than the device
   limits, then the limits of the device are used as-is. If the number
   of mapped sequential zones is lower than the limits, then we assume
   that the target has no limits (limits set to 0).
As this evaluation is done for each target, the zone resource limits
for the mapped device are evaluated as the non-zero minimum of the
limits of all the targets.

For configurations resulting in unreliable limits, i.e. a table
containing a target partially mapping a zoned device, a warning message
is issued.

The counting of mapped sequential zones for the target is done using the
new function dm_device_count_zones() which performs a report zones on
the entire block device with the callback dm_device_count_zones_cb().
This count of mapped sequential zones is used to determine if the mapped
device contains only conventional zones. This allows simplifying
dm_set_zones_restrictions() to not do a report zones. For mapped devices
mapping only conventional zones, dm_set_zone_resource_limits() changes
the mapped device to a regular device.

To further cleanup dm_set_zones_restrictions(), the message about the
type of zone append (native or emulated) is moved inside
dm_revalidate_zones().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/md/dm-zone.c | 220 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 183 insertions(+), 37 deletions(-)

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 5d66d916730e..e81e3101107a 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -145,17 +145,180 @@ bool dm_is_zone_write(struct mapped_device *md, struct bio *bio)
 	}
 }
 
+struct dm_device_zone_count {
+	sector_t start;
+	sector_t len;
+	unsigned int total_nr_seq_zones;
+	unsigned int target_nr_seq_zones;
+};
+
 /*
- * Count conventional zones of a mapped zoned device. If the device
- * only has conventional zones, do not expose it as zoned.
+ * Count the total number of and the number of mapped sequential zones of a
+ * target zoned device.
  */
-static int dm_check_zoned_cb(struct blk_zone *zone, unsigned int idx,
-			     void *data)
+static int dm_device_count_zones_cb(struct blk_zone *zone,
+				    unsigned int idx, void *data)
+{
+	struct dm_device_zone_count *zc = data;
+
+	if (zone->type != BLK_ZONE_TYPE_CONVENTIONAL) {
+		zc->total_nr_seq_zones++;
+		if (zone->start >= zc->start &&
+		    zone->start < zc->start + zc->len)
+			zc->target_nr_seq_zones++;
+	}
+
+	return 0;
+}
+
+static int dm_device_count_zones(struct dm_dev *dev,
+				 struct dm_device_zone_count *zc)
 {
-	unsigned int *nr_conv_zones = data;
+	int ret;
+
+	ret = blkdev_report_zones(dev->bdev, 0, UINT_MAX,
+				  dm_device_count_zones_cb, zc);
+	if (ret < 0)
+		return ret;
+	if (!ret)
+		return -EIO;
+	return 0;
+}
+
+struct dm_zone_resource_limits {
+	unsigned int mapped_nr_seq_zones;
+	struct queue_limits *lim;
+	bool reliable_limits;
+};
+
+static int device_get_zone_resource_limits(struct dm_target *ti,
+					   struct dm_dev *dev, sector_t start,
+					   sector_t len, void *data)
+{
+	struct dm_zone_resource_limits *zlim = data;
+	struct gendisk *disk = dev->bdev->bd_disk;
+	unsigned int max_open_zones, max_active_zones;
+	int ret;
+	struct dm_device_zone_count zc = {
+		.start = start,
+		.len = len,
+	};
+
+	/*
+	 * If the target is not the whole device, the device zone resources may
+	 * be shared between different targets. Check this by counting the
+	 * number of mapped sequential zones: if this number is smaller than the
+	 * total number of sequential zones of the target device, then resource
+	 * sharing may happen and the zone limits will not be reliable.
+	 */
+	ret = dm_device_count_zones(dev, &zc);
+	if (ret) {
+		DMERR("Count device %s zones failed",
+		      disk->disk_name);
+		return ret;
+	}
+
+	zlim->mapped_nr_seq_zones += zc.target_nr_seq_zones;
+
+	/*
+	 * If the target does not map any sequential zones, then we do not need
+	 * any zone resource limits.
+	 */
+	if (!zc.target_nr_seq_zones)
+		return 0;
+
+	/*
+	 * If the target does not map all sequential zones, the limits
+	 * will not be reliable.
+	 */
+	if (zc.target_nr_seq_zones < zc.total_nr_seq_zones)
+		zlim->reliable_limits = false;
+
+	/*
+	 * If the target maps less sequential zones than the limit values, then
+	 * we do not have limits for this target.
+	 */
+	max_active_zones = disk->queue->limits.max_active_zones;
+	if (max_active_zones >= zc.target_nr_seq_zones)
+		max_active_zones = 0;
+	zlim->lim->max_active_zones =
+		min_not_zero(max_active_zones, zlim->lim->max_active_zones);
+
+	max_open_zones = disk->queue->limits.max_open_zones;
+	if (max_open_zones >= zc.target_nr_seq_zones)
+		max_open_zones = 0;
+	zlim->lim->max_open_zones =
+		min_not_zero(max_open_zones, zlim->lim->max_open_zones);
+
+	return 0;
+}
+
+static int dm_set_zone_resource_limits(struct mapped_device *md,
+				struct dm_table *t, struct queue_limits *lim)
+{
+	struct gendisk *disk = md->disk;
+	struct dm_zone_resource_limits zlim = {
+		.reliable_limits = true,
+		.lim = lim,
+	};
+
+	lim->max_open_zones = UINT_MAX;
+	lim->max_active_zones = UINT_MAX;
 
-	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
-		(*nr_conv_zones)++;
+	/* Get the zone resource limits from the targets. */
+	for (unsigned int i = 0; i < t->num_targets; i++) {
+		struct dm_target *ti = dm_table_get_target(t, i);
+
+		if (!ti->type->iterate_devices ||
+		    ti->type->iterate_devices(ti,
+				device_get_zone_resource_limits, &zlim)) {
+			DMERR("Could not determine %s zone resource limits",
+			      md->disk->disk_name);
+			return -ENODEV;
+		}
+	}
+
+	/*
+	 * If we only have conventional zones mapped, expose the mapped device
+	 + as a regular device.
+	 */
+	if (!zlim.mapped_nr_seq_zones) {
+		lim->max_open_zones = 0;
+		lim->max_active_zones = 0;
+		lim->max_zone_append_sectors = 0;
+		lim->zone_write_granularity = 0;
+		lim->zoned = false;
+		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
+		md->nr_zones = 0;
+		disk->nr_zones = 0;
+		return 0;
+	}
+
+	/*
+	 * Warn if the mapped device is partially using zone resources of the
+	 * target devices as that leads to unreliable limits, i.e. if another
+	 * mapped device uses the same underlying devices, we cannot enforce
+	 * zone limits to guarantee that writing will not lead to errors.
+	 * Note that we really should return an error for such case but there is
+	 * no easy way to find out if another mapped device uses the same
+	 * underlying zoned devices.
+	 */
+	if (!zlim.reliable_limits)
+		DMWARN("%s zone resource limits may be unreliable",
+		       disk->disk_name);
+
+	/*
+	 * If the limits are larger than the number of mapped sequential zones,
+	 * assume no limits. Note that blk_revalidate_disk_zones() also executes
+	 * this adjustment, but only for mapped devices that use zone write
+	 * plugging, that is, for mapped devices needing zone append emulation.
+	 * So for DM devices using native zone append of the target devices, we
+	 * need to adjust the zone resource limits here.
+	 */
+	if (lim->max_active_zones > zlim.mapped_nr_seq_zones)
+		lim->max_active_zones = 0;
+	if (lim->max_open_zones > zlim.mapped_nr_seq_zones)
+		lim->max_open_zones = 0;
 
 	return 0;
 }
@@ -172,8 +335,13 @@ static int dm_revalidate_zones(struct mapped_device *md, struct dm_table *t)
 	int ret;
 
 	/* Revalidate only if something changed. */
-	if (!disk->nr_zones || disk->nr_zones != md->nr_zones)
+	if (!disk->nr_zones || disk->nr_zones != md->nr_zones) {
+		DMINFO("%s using %s zone append",
+		       md->disk->disk_name,
+		       queue_emulates_zone_append(disk->queue) ?
+		       "emulated" : "native");
 		md->nr_zones = 0;
+	}
 
 	if (md->nr_zones)
 		return 0;
@@ -224,8 +392,6 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
 		struct queue_limits *lim)
 {
 	struct mapped_device *md = t->md;
-	struct gendisk *disk = md->disk;
-	unsigned int nr_conv_zones = 0;
 	int ret;
 
 	/*
@@ -244,36 +410,16 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
 		return 0;
 
 	/*
-	 * Count conventional zones to check that the mapped device will indeed 
-	 * have sequential write required zones.
+	 * Determine the max open and max active zone limits for the mapped
+	 * device. For a mapped device containing only conventional zones, the
+	 * mapped device is changed to be a regular block device, so exit early
+	 * for such case.
 	 */
-	md->zone_revalidate_map = t;
-	ret = dm_blk_report_zones(disk, 0, UINT_MAX,
-				  dm_check_zoned_cb, &nr_conv_zones);
-	md->zone_revalidate_map = NULL;
-	if (ret < 0) {
-		DMERR("Check zoned failed %d", ret);
+	ret = dm_set_zone_resource_limits(md, t, lim);
+	if (ret)
 		return ret;
-	}
-
-	/*
-	 * If we only have conventional zones, expose the mapped device as
-	 * a regular device.
-	 */
-	if (nr_conv_zones >= ret) {
-		lim->max_open_zones = 0;
-		lim->max_active_zones = 0;
-		lim->zoned = false;
-		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
-		disk->nr_zones = 0;
+	if (!lim->zoned)
 		return 0;
-	}
-
-	if (!md->disk->nr_zones) {
-		DMINFO("%s using %s zone append",
-		       md->disk->disk_name,
-		       queue_emulates_zone_append(q) ? "emulated" : "native");
-	}
 
 	ret = dm_revalidate_zones(md, t);
 	if (ret < 0)
-- 
2.45.1

