From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/2] dm-zoned: split off random and cache zones
Date: Wed, 13 May 2020 09:07:29 +0200
Message-ID: <20200513070729.71461-3-hare@suse.de>
References: <20200513070729.71461-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200513070729.71461-1-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Damien LeMoal <damien.lemoal@wdc.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Instead of emulating zones on the regular disk as random zones
this patch adds a new 'cache' zone type.
This allows us to use the random zones on the zoned disk as
data zones (if cache zones are present), and improves performance
as the zones on the (slower) zoned disk are then never used
for caching.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 .../admin-guide/device-mapper/dm-zoned.rst    |  17 +-
 drivers/md/dm-zoned-metadata.c                | 145 ++++++++++++++----
 drivers/md/dm-zoned-reclaim.c                 |  70 +++++----
 drivers/md/dm-zoned-target.c                  |  19 ++-
 drivers/md/dm-zoned.h                         |   7 +-
 5 files changed, 181 insertions(+), 77 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-zoned.rst b/Documentation/admin-guide/device-mapper/dm-zoned.rst
index 553752ea2521..d4933638737a 100644
--- a/Documentation/admin-guide/device-mapper/dm-zoned.rst
+++ b/Documentation/admin-guide/device-mapper/dm-zoned.rst
@@ -174,17 +174,18 @@ Ex::
 
 will return a line
 
-	0 <size> zoned <nr_zones> zones <nr_unmap_rnd>/<nr_rnd> random <nr_unmap_seq>/<nr_seq> sequential
+	0 <size> zoned <nr_zones> zones <nr_unmap/nr_total> cache <nr_unmap>/<nr_total> random <nr_unmap>/<nr_total> sequential
 
-where <nr_zones> is the total number of zones, <nr_unmap_rnd> is the number
-of unmapped (ie free) random zones, <nr_rnd> the total number of zones,
-<nr_unmap_seq> the number of unmapped sequential zones, and <nr_seq> the
-total number of sequential zones.
+where <nr_zones> is the total number of zones, followed by statistics for
+the zone types (cache, random, and sequential), where <nr_unmap>/<nr_total>
+is the number of unmapped (ie free) vs the overall number of zones.
+'cache' zones are located on the regular disk, 'random' and 'sequential'
+on the zoned disk.
 
 Normally the reclaim process will be started once there are less than 50
-percent free random zones. In order to start the reclaim process manually
-even before reaching this threshold the 'dmsetup message' function can be
-used:
+percent free cache or random zones. In order to start the reclaim process
+manually even before reaching this threshold the 'dmsetup message' function
+can be used:
 
 Ex::
 
diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 9b93d7ff1dfc..dbcbcb0ddf56 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -166,6 +166,7 @@ struct dmz_metadata {
 	unsigned int		nr_meta_blocks;
 	unsigned int		nr_meta_zones;
 	unsigned int		nr_data_zones;
+	unsigned int		nr_cache_zones;
 	unsigned int		nr_rnd_zones;
 	unsigned int		nr_reserved_seq;
 	unsigned int		nr_chunks;
@@ -196,6 +197,11 @@ struct dmz_metadata {
 	struct list_head	unmap_rnd_list;
 	struct list_head	map_rnd_list;
 
+	unsigned int		nr_cache;
+	atomic_t		unmap_nr_cache;
+	struct list_head	unmap_cache_list;
+	struct list_head	map_cache_list;
+
 	unsigned int		nr_seq;
 	atomic_t		unmap_nr_seq;
 	struct list_head	unmap_seq_list;
@@ -301,6 +307,16 @@ unsigned int dmz_nr_unmap_rnd_zones(struct dmz_metadata *zmd)
 	return atomic_read(&zmd->unmap_nr_rnd);
 }
 
+unsigned int dmz_nr_cache_zones(struct dmz_metadata *zmd)
+{
+	return zmd->nr_cache;
+}
+
+unsigned int dmz_nr_unmap_cache_zones(struct dmz_metadata *zmd)
+{
+	return atomic_read(&zmd->unmap_nr_cache);
+}
+
 unsigned int dmz_nr_seq_zones(struct dmz_metadata *zmd)
 {
 	return zmd->nr_seq;
@@ -1390,9 +1406,9 @@ static void dmz_emulate_zones(struct dmz_metadata *zmd, struct dmz_dev *dev)
 		atomic_set(&zone->refcount, 0);
 		zone->id = idx;
 		zone->chunk = DMZ_MAP_UNMAPPED;
-		set_bit(DMZ_RND, &zone->flags);
+		set_bit(DMZ_CACHE, &zone->flags);
 		zone->wp_block = 0;
-		zmd->nr_rnd_zones++;
+		zmd->nr_cache_zones++;
 		zmd->nr_useable_zones++;
 		if (dev->capacity - zone_offset < zmd->zone_nr_sectors) {
 			/* Disable runt zone */
@@ -1651,7 +1667,9 @@ static int dmz_load_mapping(struct dmz_metadata *zmd)
 		dzone->chunk = chunk;
 		dmz_get_zone_weight(zmd, dzone);
 
-		if (dmz_is_rnd(dzone))
+		if (dmz_is_cache(dzone))
+			list_add_tail(&dzone->link, &zmd->map_cache_list);
+		else if (dmz_is_rnd(dzone))
 			list_add_tail(&dzone->link, &zmd->map_rnd_list);
 		else
 			list_add_tail(&dzone->link, &zmd->map_seq_list);
@@ -1668,7 +1686,7 @@ static int dmz_load_mapping(struct dmz_metadata *zmd)
 		}
 
 		bzone = dmz_get(zmd, bzone_id);
-		if (!dmz_is_rnd(bzone)) {
+		if (!dmz_is_rnd(bzone) && !dmz_is_cache(bzone)) {
 			dmz_zmd_err(zmd, "Chunk %u mapping: invalid buffer zone %u",
 				    chunk, bzone_id);
 			return -EIO;
@@ -1680,7 +1698,10 @@ static int dmz_load_mapping(struct dmz_metadata *zmd)
 		bzone->bzone = dzone;
 		dzone->bzone = bzone;
 		dmz_get_zone_weight(zmd, bzone);
-		list_add_tail(&bzone->link, &zmd->map_rnd_list);
+		if (dmz_is_cache(bzone))
+			list_add_tail(&bzone->link, &zmd->map_cache_list);
+		else
+			list_add_tail(&bzone->link, &zmd->map_rnd_list);
 next:
 		chunk++;
 		e++;
@@ -1697,8 +1718,12 @@ static int dmz_load_mapping(struct dmz_metadata *zmd)
 		dzone = dmz_get(zmd, i);
 		if (dmz_is_meta(dzone))
 			continue;
+		if (dmz_is_offline(dzone))
+			continue;
 
-		if (dmz_is_rnd(dzone))
+		if (dmz_is_cache(dzone))
+			zmd->nr_cache++;
+		else if (dmz_is_rnd(dzone))
 			zmd->nr_rnd++;
 		else
 			zmd->nr_seq++;
@@ -1711,7 +1736,10 @@ static int dmz_load_mapping(struct dmz_metadata *zmd)
 		/* Unmapped data zone */
 		set_bit(DMZ_DATA, &dzone->flags);
 		dzone->chunk = DMZ_MAP_UNMAPPED;
-		if (dmz_is_rnd(dzone)) {
+		if (dmz_is_cache(dzone)) {
+			list_add_tail(&dzone->link, &zmd->unmap_cache_list);
+			atomic_inc(&zmd->unmap_nr_cache);
+		} else if (dmz_is_rnd(dzone)) {
 			list_add_tail(&dzone->link, &zmd->unmap_rnd_list);
 			atomic_inc(&zmd->unmap_nr_rnd);
 		} else if (atomic_read(&zmd->nr_reserved_seq_zones) < zmd->nr_reserved_seq) {
@@ -1755,6 +1783,9 @@ static void __dmz_lru_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
 	if (dmz_is_seq(zone)) {
 		/* LRU rotate sequential zone */
 		list_add_tail(&zone->link, &zmd->map_seq_list);
+	} else if (dmz_is_cache(zone)) {
+		/* LRU rotate cache zone */
+		list_add_tail(&zone->link, &zmd->map_cache_list);
 	} else {
 		/* LRU rotate random zone */
 		list_add_tail(&zone->link, &zmd->map_rnd_list);
@@ -1830,17 +1861,19 @@ static void dmz_wait_for_reclaim(struct dmz_metadata *zmd, struct dm_zone *zone)
 }
 
 /*
- * Select a random write zone for reclaim.
+ * Select a cache or random write zone for reclaim.
  */
 static struct dm_zone *dmz_get_rnd_zone_for_reclaim(struct dmz_metadata *zmd)
 {
 	struct dm_zone *dzone = NULL;
 	struct dm_zone *zone;
+	struct list_head *zone_list = &zmd->map_rnd_list;
 
-	if (list_empty(&zmd->map_rnd_list))
-		return ERR_PTR(-EBUSY);
+	/* If we have cache zones select from the cache zone list */
+	if (zmd->nr_cache)
+		zone_list = &zmd->map_cache_list;
 
-	list_for_each_entry(zone, &zmd->map_rnd_list, link) {
+	list_for_each_entry(zone, zone_list, link) {
 		if (dmz_is_buf(zone))
 			dzone = zone->bzone;
 		else
@@ -1853,15 +1886,21 @@ static struct dm_zone *dmz_get_rnd_zone_for_reclaim(struct dmz_metadata *zmd)
 }
 
 /*
- * Select a buffered sequential zone for reclaim.
+ * Select a buffered random write or sequential zone for reclaim.
  */
 static struct dm_zone *dmz_get_seq_zone_for_reclaim(struct dmz_metadata *zmd)
 {
 	struct dm_zone *zone;
 
-	if (list_empty(&zmd->map_seq_list))
-		return ERR_PTR(-EBUSY);
-
+	if (zmd->nr_cache) {
+		/* If we have cache zones start with random zones */
+		list_for_each_entry(zone, &zmd->map_rnd_list, link) {
+			if (!zone->bzone)
+				continue;
+			if (dmz_lock_zone_reclaim(zone))
+				return zone;
+		}
+	}
 	list_for_each_entry(zone, &zmd->map_seq_list, link) {
 		if (!zone->bzone)
 			continue;
@@ -1911,6 +1950,7 @@ struct dm_zone *dmz_get_chunk_mapping(struct dmz_metadata *zmd, unsigned int chu
 	unsigned int dzone_id;
 	struct dm_zone *dzone = NULL;
 	int ret = 0;
+	int alloc_flags = zmd->nr_cache ? DMZ_ALLOC_CACHE : DMZ_ALLOC_RND;
 
 	dmz_lock_map(zmd);
 again:
@@ -1925,7 +1965,7 @@ struct dm_zone *dmz_get_chunk_mapping(struct dmz_metadata *zmd, unsigned int chu
 			goto out;
 
 		/* Allocate a random zone */
-		dzone = dmz_alloc_zone(zmd, DMZ_ALLOC_RND);
+		dzone = dmz_alloc_zone(zmd, alloc_flags);
 		if (!dzone) {
 			if (dmz_dev_is_dying(zmd)) {
 				dzone = ERR_PTR(-EIO);
@@ -2018,6 +2058,7 @@ struct dm_zone *dmz_get_chunk_buffer(struct dmz_metadata *zmd,
 				     struct dm_zone *dzone)
 {
 	struct dm_zone *bzone;
+	int alloc_flags = zmd->nr_cache ? DMZ_ALLOC_CACHE : DMZ_ALLOC_RND;
 
 	dmz_lock_map(zmd);
 again:
@@ -2026,7 +2067,7 @@ struct dm_zone *dmz_get_chunk_buffer(struct dmz_metadata *zmd,
 		goto out;
 
 	/* Allocate a random zone */
-	bzone = dmz_alloc_zone(zmd, DMZ_ALLOC_RND);
+	bzone = dmz_alloc_zone(zmd, alloc_flags);
 	if (!bzone) {
 		if (dmz_dev_is_dying(zmd)) {
 			bzone = ERR_PTR(-EIO);
@@ -2043,7 +2084,10 @@ struct dm_zone *dmz_get_chunk_buffer(struct dmz_metadata *zmd,
 	bzone->chunk = dzone->chunk;
 	bzone->bzone = dzone;
 	dzone->bzone = bzone;
-	list_add_tail(&bzone->link, &zmd->map_rnd_list);
+	if (alloc_flags == DMZ_ALLOC_CACHE)
+		list_add_tail(&bzone->link, &zmd->map_cache_list);
+	else
+		list_add_tail(&bzone->link, &zmd->map_rnd_list);
 out:
 	dmz_unlock_map(zmd);
 
@@ -2059,31 +2103,53 @@ struct dm_zone *dmz_alloc_zone(struct dmz_metadata *zmd, unsigned long flags)
 	struct list_head *list;
 	struct dm_zone *zone;
 
-	if (flags & DMZ_ALLOC_RND)
+	switch (flags) {
+	case DMZ_ALLOC_CACHE:
+		list = &zmd->unmap_cache_list;
+		break;
+	case DMZ_ALLOC_RND:
 		list = &zmd->unmap_rnd_list;
-	else
-		list = &zmd->unmap_seq_list;
+		break;
+	default:
+		if (zmd->nr_cache)
+			list = &zmd->unmap_rnd_list;
+		else
+			list = &zmd->unmap_seq_list;
+		break;
+	}
 again:
 	if (list_empty(list)) {
 		/*
-		 * No free zone: if this is for reclaim, allow using the
-		 * reserved sequential zones.
+		 * No free zone: return NULL if this is for not reclaim.
 		 */
-		if (!(flags & DMZ_ALLOC_RECLAIM) ||
-		    list_empty(&zmd->reserved_seq_zones_list))
+		if (!(flags & DMZ_ALLOC_RECLAIM))
 			return NULL;
-
-		zone = list_first_entry(&zmd->reserved_seq_zones_list,
-					struct dm_zone, link);
-		list_del_init(&zone->link);
-		atomic_dec(&zmd->nr_reserved_seq_zones);
+		/*
+		 * Use sequential write zones if we started off with random
+		 * zones and the list is empty
+		 */
+		if (list == &zmd->unmap_rnd_list) {
+			list = &zmd->unmap_seq_list;
+			goto again;
+		}
+		/*
+		 * Fallback to the reserved sequential zones
+		 */
+		zone = list_first_entry_or_null(&zmd->reserved_seq_zones_list,
+						struct dm_zone, link);
+		if (zone) {
+			list_del_init(&zone->link);
+			atomic_dec(&zmd->nr_reserved_seq_zones);
+		}
 		return zone;
 	}
 
 	zone = list_first_entry(list, struct dm_zone, link);
 	list_del_init(&zone->link);
 
-	if (dmz_is_rnd(zone))
+	if (dmz_is_cache(zone))
+		atomic_dec(&zmd->unmap_nr_cache);
+	else if (dmz_is_rnd(zone))
 		atomic_dec(&zmd->unmap_nr_rnd);
 	else
 		atomic_dec(&zmd->unmap_nr_seq);
@@ -2114,7 +2180,10 @@ void dmz_free_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
 		dmz_reset_zone(zmd, zone);
 
 	/* Return the zone to its type unmap list */
-	if (dmz_is_rnd(zone)) {
+	if (dmz_is_cache(zone)) {
+		list_add_tail(&zone->link, &zmd->unmap_cache_list);
+		atomic_inc(&zmd->unmap_nr_cache);
+	} else if (dmz_is_rnd(zone)) {
 		list_add_tail(&zone->link, &zmd->unmap_rnd_list);
 		atomic_inc(&zmd->unmap_nr_rnd);
 	} else if (atomic_read(&zmd->nr_reserved_seq_zones) <
@@ -2140,7 +2209,9 @@ void dmz_map_zone(struct dmz_metadata *zmd, struct dm_zone *dzone,
 	dmz_set_chunk_mapping(zmd, chunk, dzone->id,
 			      DMZ_MAP_UNMAPPED);
 	dzone->chunk = chunk;
-	if (dmz_is_rnd(dzone))
+	if (dmz_is_cache(dzone))
+		list_add_tail(&dzone->link, &zmd->map_cache_list);
+	else if (dmz_is_rnd(dzone))
 		list_add_tail(&dzone->link, &zmd->map_rnd_list);
 	else
 		list_add_tail(&dzone->link, &zmd->map_seq_list);
@@ -2714,6 +2785,10 @@ int dmz_ctr_metadata(struct dmz_dev *dev, int num_dev,
 	INIT_LIST_HEAD(&zmd->unmap_rnd_list);
 	INIT_LIST_HEAD(&zmd->map_rnd_list);
 
+	atomic_set(&zmd->unmap_nr_cache, 0);
+	INIT_LIST_HEAD(&zmd->unmap_cache_list);
+	INIT_LIST_HEAD(&zmd->map_cache_list);
+
 	atomic_set(&zmd->unmap_nr_seq, 0);
 	INIT_LIST_HEAD(&zmd->unmap_seq_list);
 	INIT_LIST_HEAD(&zmd->map_seq_list);
@@ -2736,7 +2811,7 @@ int dmz_ctr_metadata(struct dmz_dev *dev, int num_dev,
 	/* Set metadata zones starting from sb_zone */
 	for (i = 0; i < zmd->nr_meta_zones << 1; i++) {
 		zone = dmz_get(zmd, zmd->sb[0].zone->id + i);
-		if (!dmz_is_rnd(zone)) {
+		if (!dmz_is_rnd(zone) && !dmz_is_cache(zone)) {
 			dmz_zmd_err(zmd,
 				    "metadata zone %d is not random", i);
 			ret = -ENXIO;
@@ -2788,6 +2863,8 @@ int dmz_ctr_metadata(struct dmz_dev *dev, int num_dev,
 		      zmd->nr_meta_zones * 2);
 	dmz_zmd_debug(zmd, "  %u data zones for %u chunks",
 		      zmd->nr_data_zones, zmd->nr_chunks);
+	dmz_zmd_debug(zmd, "    %u cache zones (%u unmapped)",
+		      zmd->nr_cache, atomic_read(&zmd->unmap_nr_cache));
 	dmz_zmd_debug(zmd, "    %u random zones (%u unmapped)",
 		      zmd->nr_rnd, atomic_read(&zmd->unmap_nr_rnd));
 	dmz_zmd_debug(zmd, "    %u sequential zones (%u unmapped)",
diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index 39ea0d5d4706..6004cf71a000 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -43,13 +43,13 @@ enum {
  * Percentage of unmapped (free) random zones below which reclaim starts
  * even if the target is busy.
  */
-#define DMZ_RECLAIM_LOW_UNMAP_RND	30
+#define DMZ_RECLAIM_LOW_UNMAP_ZONES	30
 
 /*
  * Percentage of unmapped (free) random zones above which reclaim will
  * stop if the target is busy.
  */
-#define DMZ_RECLAIM_HIGH_UNMAP_RND	50
+#define DMZ_RECLAIM_HIGH_UNMAP_ZONES	50
 
 /*
  * Align a sequential zone write pointer to chunk_block.
@@ -289,9 +289,11 @@ static int dmz_reclaim_rnd_data(struct dmz_reclaim *zrc, struct dm_zone *dzone)
 	if (!szone)
 		return -ENOSPC;
 
-	DMDEBUG("(%s): Chunk %u, move rnd zone %u (weight %u) to seq zone %u",
-		dmz_metadata_label(zmd),
-		chunk, dzone->id, dmz_weight(dzone), szone->id);
+	DMDEBUG("(%s): Chunk %u, move %s zone %u (weight %u) to %s zone %u",
+		dmz_metadata_label(zmd), chunk,
+		dmz_is_cache(dzone) ? "cache" : "rnd",
+		dzone->id, dmz_weight(dzone),
+		dmz_is_rnd(szone) ? "rnd" : "seq", szone->id);
 
 	/* Flush the random data zone into the sequential zone */
 	ret = dmz_reclaim_copy(zrc, dzone, szone);
@@ -358,7 +360,7 @@ static int dmz_do_reclaim(struct dmz_reclaim *zrc)
 
 	start = jiffies;
 	dev = dmz_zone_to_dev(zmd, dzone);
-	if (dmz_is_rnd(dzone)) {
+	if (dmz_is_cache(dzone) || dmz_is_rnd(dzone)) {
 		if (!dmz_weight(dzone)) {
 			/* Empty zone */
 			dmz_reclaim_empty(zrc, dzone);
@@ -424,29 +426,41 @@ static inline int dmz_target_idle(struct dmz_reclaim *zrc)
 	return time_is_before_jiffies(zrc->atime + DMZ_IDLE_PERIOD);
 }
 
-/*
- * Test if reclaim is necessary.
- */
-static bool dmz_should_reclaim(struct dmz_reclaim *zrc)
+static unsigned int dmz_reclaim_percentage(struct dmz_reclaim *zrc)
 {
 	struct dmz_metadata *zmd = zrc->metadata;
+	unsigned int nr_cache = dmz_nr_cache_zones(zmd);
 	unsigned int nr_rnd = dmz_nr_rnd_zones(zmd);
-	unsigned int nr_unmap_rnd = dmz_nr_unmap_rnd_zones(zmd);
-	unsigned int p_unmap_rnd = nr_unmap_rnd * 100 / nr_rnd;
+	unsigned int nr_unmap, nr_zones;
 
+	if (nr_cache) {
+		nr_zones = nr_cache;
+		nr_unmap = dmz_nr_unmap_cache_zones(zmd);
+	} else {
+		nr_zones = nr_rnd;
+		nr_unmap = dmz_nr_unmap_rnd_zones(zmd);
+	}
+	return nr_unmap * 100 / nr_zones;
+}
+
+/*
+ * Test if reclaim is necessary.
+ */
+static bool dmz_should_reclaim(struct dmz_reclaim *zrc, unsigned int p_unmap)
+{
 	/* Reclaim when idle */
-	if (dmz_target_idle(zrc) && nr_unmap_rnd < nr_rnd)
+	if (dmz_target_idle(zrc) && p_unmap < 100)
 		return true;
 
-	/* If there are still plenty of random zones, do not reclaim */
-	if (p_unmap_rnd >= DMZ_RECLAIM_HIGH_UNMAP_RND)
+	/* If there are still plenty of cache zones, do not reclaim */
+	if (p_unmap >= DMZ_RECLAIM_HIGH_UNMAP_ZONES)
 		return false;
 
 	/*
-	 * If the percentage of unmapped random zones is low,
+	 * If the percentage of unmapped cache zones is low,
 	 * reclaim even if the target is busy.
 	 */
-	return p_unmap_rnd <= DMZ_RECLAIM_LOW_UNMAP_RND;
+	return p_unmap <= DMZ_RECLAIM_LOW_UNMAP_ZONES;
 }
 
 /*
@@ -456,14 +470,14 @@ static void dmz_reclaim_work(struct work_struct *work)
 {
 	struct dmz_reclaim *zrc = container_of(work, struct dmz_reclaim, work.work);
 	struct dmz_metadata *zmd = zrc->metadata;
-	unsigned int nr_rnd, nr_unmap_rnd;
-	unsigned int p_unmap_rnd;
+	unsigned int p_unmap;
 	int ret;
 
 	if (dmz_dev_is_dying(zmd))
 		return;
 
-	if (!dmz_should_reclaim(zrc)) {
+	p_unmap = dmz_reclaim_percentage(zrc);
+	if (!dmz_should_reclaim(zrc, p_unmap)) {
 		mod_delayed_work(zrc->wq, &zrc->work, DMZ_IDLE_PERIOD);
 		return;
 	}
@@ -474,22 +488,20 @@ static void dmz_reclaim_work(struct work_struct *work)
 	 * and slower if there are still some free random zones to avoid
 	 * as much as possible to negatively impact the user workload.
 	 */
-	nr_rnd = dmz_nr_rnd_zones(zmd);
-	nr_unmap_rnd = dmz_nr_unmap_rnd_zones(zmd);
-	p_unmap_rnd = nr_unmap_rnd * 100 / nr_rnd;
-	if (dmz_target_idle(zrc) || p_unmap_rnd < DMZ_RECLAIM_LOW_UNMAP_RND / 2) {
+	if (dmz_target_idle(zrc) || p_unmap < DMZ_RECLAIM_LOW_UNMAP_ZONES / 2) {
 		/* Idle or very low percentage: go fast */
 		zrc->kc_throttle.throttle = 100;
 	} else {
 		/* Busy but we still have some random zone: throttle */
-		zrc->kc_throttle.throttle = min(75U, 100U - p_unmap_rnd / 2);
+		zrc->kc_throttle.throttle = min(75U, 100U - p_unmap / 2);
 	}
 
-	DMDEBUG("(%s): Reclaim (%u): %s, %u%% free rnd zones (%u/%u)",
+	DMDEBUG("(%s): Reclaim (%u): %s, %u%% free cache zones (%u/%u)",
 		dmz_metadata_label(zmd),
 		zrc->kc_throttle.throttle,
 		(dmz_target_idle(zrc) ? "Idle" : "Busy"),
-		p_unmap_rnd, nr_unmap_rnd, nr_rnd);
+		p_unmap, dmz_nr_unmap_cache_zones(zmd),
+		dmz_nr_cache_zones(zmd));
 
 	ret = dmz_do_reclaim(zrc);
 	if (ret) {
@@ -587,7 +599,9 @@ void dmz_reclaim_bio_acc(struct dmz_reclaim *zrc)
  */
 void dmz_schedule_reclaim(struct dmz_reclaim *zrc)
 {
-	if (dmz_should_reclaim(zrc))
+	unsigned int p_unmap = dmz_reclaim_percentage(zrc);
+
+	if (dmz_should_reclaim(zrc, p_unmap))
 		mod_delayed_work(zrc->wq, &zrc->work, 0);
 }
 
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index ea43f6892ced..8999de07cddb 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -190,7 +190,8 @@ static int dmz_handle_read(struct dmz_target *dmz, struct dm_zone *zone,
 	DMDEBUG("(%s): READ chunk %llu -> %s zone %u, block %llu, %u blocks",
 		dmz_metadata_label(zmd),
 		(unsigned long long)dmz_bio_chunk(zmd, bio),
-		(dmz_is_rnd(zone) ? "RND" : "SEQ"),
+		(dmz_is_rnd(zone) ? "RND" :
+		 (dmz_is_cache(zone) ? "CACHE" : "SEQ")),
 		zone->id,
 		(unsigned long long)chunk_block, nr_blocks);
 
@@ -198,7 +199,8 @@ static int dmz_handle_read(struct dmz_target *dmz, struct dm_zone *zone,
 	bzone = zone->bzone;
 	while (chunk_block < end_block) {
 		nr_blocks = 0;
-		if (dmz_is_rnd(zone) || chunk_block < zone->wp_block) {
+		if (dmz_is_rnd(zone) || dmz_is_cache(zone) ||
+		    chunk_block < zone->wp_block) {
 			/* Test block validity in the data zone */
 			ret = dmz_block_valid(zmd, zone, chunk_block);
 			if (ret < 0)
@@ -331,11 +333,13 @@ static int dmz_handle_write(struct dmz_target *dmz, struct dm_zone *zone,
 	DMDEBUG("(%s): WRITE chunk %llu -> %s zone %u, block %llu, %u blocks",
 		dmz_metadata_label(zmd),
 		(unsigned long long)dmz_bio_chunk(zmd, bio),
-		(dmz_is_rnd(zone) ? "RND" : "SEQ"),
+		(dmz_is_rnd(zone) ? "RND" :
+		 (dmz_is_cache(zone) ? "CACHE" : "SEQ")),
 		zone->id,
 		(unsigned long long)chunk_block, nr_blocks);
 
-	if (dmz_is_rnd(zone) || chunk_block == zone->wp_block) {
+	if (dmz_is_rnd(zone) || dmz_is_cache(zone) ||
+	    chunk_block == zone->wp_block) {
 		/*
 		 * zone is a random zone or it is a sequential zone
 		 * and the BIO is aligned to the zone write pointer:
@@ -381,7 +385,8 @@ static int dmz_handle_discard(struct dmz_target *dmz, struct dm_zone *zone,
 	 * Invalidate blocks in the data zone and its
 	 * buffer zone if one is mapped.
 	 */
-	if (dmz_is_rnd(zone) || chunk_block < zone->wp_block)
+	if (dmz_is_rnd(zone) || dmz_is_cache(zone) ||
+	    chunk_block < zone->wp_block)
 		ret = dmz_invalidate_blocks(zmd, zone, chunk_block, nr_blocks);
 	if (ret == 0 && zone->bzone)
 		ret = dmz_invalidate_blocks(zmd, zone->bzone,
@@ -1064,8 +1069,10 @@ static void dmz_status(struct dm_target *ti, status_type_t type,
 
 	switch (type) {
 	case STATUSTYPE_INFO:
-		DMEMIT("%u zones %u/%u random %u/%u sequential",
+		DMEMIT("%u zones %u/%u cache %u/%u random %u/%u sequential",
 		       dmz_nr_zones(dmz->metadata),
+		       dmz_nr_unmap_cache_zones(dmz->metadata),
+		       dmz_nr_cache_zones(dmz->metadata),
 		       dmz_nr_unmap_rnd_zones(dmz->metadata),
 		       dmz_nr_rnd_zones(dmz->metadata),
 		       dmz_nr_unmap_seq_zones(dmz->metadata),
diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
index 4971a765be55..b1bdfa3c957a 100644
--- a/drivers/md/dm-zoned.h
+++ b/drivers/md/dm-zoned.h
@@ -111,6 +111,7 @@ struct dm_zone {
  */
 enum {
 	/* Zone write type */
+	DMZ_CACHE,
 	DMZ_RND,
 	DMZ_SEQ,
 
@@ -131,6 +132,7 @@ enum {
 /*
  * Zone data accessors.
  */
+#define dmz_is_cache(z)		test_bit(DMZ_CACHE, &(z)->flags)
 #define dmz_is_rnd(z)		test_bit(DMZ_RND, &(z)->flags)
 #define dmz_is_seq(z)		test_bit(DMZ_SEQ, &(z)->flags)
 #define dmz_is_empty(z)		((z)->wp_block == 0)
@@ -189,7 +191,8 @@ bool dmz_check_dev(struct dmz_metadata *zmd);
 bool dmz_dev_is_dying(struct dmz_metadata *zmd);
 
 #define DMZ_ALLOC_RND		0x01
-#define DMZ_ALLOC_RECLAIM	0x02
+#define DMZ_ALLOC_CACHE		0x02
+#define DMZ_ALLOC_RECLAIM	0x04
 
 struct dm_zone *dmz_alloc_zone(struct dmz_metadata *zmd, unsigned long flags);
 void dmz_free_zone(struct dmz_metadata *zmd, struct dm_zone *zone);
@@ -198,6 +201,8 @@ void dmz_map_zone(struct dmz_metadata *zmd, struct dm_zone *zone,
 		  unsigned int chunk);
 void dmz_unmap_zone(struct dmz_metadata *zmd, struct dm_zone *zone);
 unsigned int dmz_nr_zones(struct dmz_metadata *zmd);
+unsigned int dmz_nr_cache_zones(struct dmz_metadata *zmd);
+unsigned int dmz_nr_unmap_cache_zones(struct dmz_metadata *zmd);
 unsigned int dmz_nr_rnd_zones(struct dmz_metadata *zmd);
 unsigned int dmz_nr_unmap_rnd_zones(struct dmz_metadata *zmd);
 unsigned int dmz_nr_seq_zones(struct dmz_metadata *zmd);
-- 
2.25.0
