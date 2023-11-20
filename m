Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81F03A291
	for <dm-devel@lists.linux.dev>; Mon, 20 Nov 2023 22:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HrHLbt91"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700519398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TyX4wJ/9D3gQmXvonOtwo/yLvBc7WzJcAmtRjF92JVw=;
	b=HrHLbt91tkJkBmK7zi76TPQbiTz1XcUYeYOvX2eQWYk6BR/FbYH5HHUTvvfVEQoDJx1ZnI
	aQ96IfZ7HLdayc2r4HA5525hcwLbBu8rck3BTP6ncXqPKrR9uDvM6o2N9FZlvUO1ly7VXX
	9aVBhlGsLlvJ2wH1jbldp0CqdUcY0oo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-315-dJXITGXzMQK2kXEmjv413w-1; Mon, 20 Nov 2023 17:29:57 -0500
X-MC-Unique: dJXITGXzMQK2kXEmjv413w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 17AC585A58A
	for <dm-devel@lists.linux.dev>; Mon, 20 Nov 2023 22:29:57 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0C25940C6EB9;
	Mon, 20 Nov 2023 22:29:57 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 08D8951CDD; Mon, 20 Nov 2023 17:29:57 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Bruce Johnston <bjohnsto@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 2/3] dm vdo int-map: rename functions to match device-mapper name style
Date: Mon, 20 Nov 2023 17:29:55 -0500
Message-ID: <fc8f238c3b871431868da3dd3a3d0777f5ed7abf.1700517230.git.msakai@redhat.com>
In-Reply-To: <cover.1700517230.git.msakai@redhat.com>
References: <cover.1700517230.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Bruce Johnston <bjohnsto@redhat.com>

Reviewed-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Bruce Johnston <bjohnsto@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.c     | 12 ++++++------
 drivers/md/dm-vdo/dedupe.c        |  6 +++---
 drivers/md/dm-vdo/int-map.c       | 20 ++++++++++++--------
 drivers/md/dm-vdo/int-map.h       | 10 +++++-----
 drivers/md/dm-vdo/io-submitter.c  |  8 ++++----
 drivers/md/dm-vdo/logical-zone.c  |  4 ++--
 drivers/md/dm-vdo/physical-zone.c |  8 ++++----
 7 files changed, 36 insertions(+), 32 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index c5cb9da5d33e..953819943cd3 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -232,7 +232,7 @@ static int __must_check allocate_cache_components(struct vdo_page_cache *cache)
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = vdo_make_int_map(cache->page_count, 0, &cache->page_map);
+	result = vdo_int_map_create(cache->page_count, 0, &cache->page_map);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -1346,8 +1346,8 @@ int vdo_invalidate_page_cache(struct vdo_page_cache *cache)
 	}
 
 	/* Reset the page map by re-allocating it. */
-	vdo_free_int_map(uds_forget(cache->page_map));
-	return vdo_make_int_map(cache->page_count, 0, &cache->page_map);
+	vdo_int_map_free(uds_forget(cache->page_map));
+	return vdo_int_map_create(cache->page_count, 0, &cache->page_map);
 }
 
 /**
@@ -2751,7 +2751,7 @@ static int __must_check initialize_block_map_zone(struct block_map *map,
 		INIT_LIST_HEAD(&zone->dirty_lists->eras[i][VDO_CACHE_PAGE]);
 	}
 
-	result = vdo_make_int_map(VDO_LOCK_MAP_CAPACITY, 0, &zone->loading_pages);
+	result = vdo_int_map_create(VDO_LOCK_MAP_CAPACITY, 0, &zone->loading_pages);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -2831,7 +2831,7 @@ static void uninitialize_block_map_zone(struct block_map_zone *zone)
 
 	uds_free(uds_forget(zone->dirty_lists));
 	free_vio_pool(uds_forget(zone->vio_pool));
-	vdo_free_int_map(uds_forget(zone->loading_pages));
+	vdo_int_map_free(uds_forget(zone->loading_pages));
 	if (cache->infos != NULL) {
 		struct page_info *info;
 
@@ -2839,7 +2839,7 @@ static void uninitialize_block_map_zone(struct block_map_zone *zone)
 			free_vio(uds_forget(info->vio));
 	}
 
-	vdo_free_int_map(uds_forget(cache->page_map));
+	vdo_int_map_free(uds_forget(cache->page_map));
 	uds_free(uds_forget(cache->infos));
 	uds_free(uds_forget(cache->pages));
 }
diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index 00ad2e66872d..b40ba499303f 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -2405,8 +2405,8 @@ static int __must_check initialize_zone(struct vdo *vdo, struct hash_zones *zone
 	data_vio_count_t i;
 	struct hash_zone *zone = &zones->zones[zone_number];
 
-	result = vdo_make_int_map(VDO_LOCK_MAP_CAPACITY, 0,
-				  &zone->hash_lock_map);
+	result = vdo_int_map_create(VDO_LOCK_MAP_CAPACITY, 0,
+				    &zone->hash_lock_map);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -2530,7 +2530,7 @@ void vdo_free_hash_zones(struct hash_zones *zones)
 		struct hash_zone *zone = &zones->zones[i];
 
 		uds_free_funnel_queue(uds_forget(zone->timed_out_complete));
-		vdo_free_int_map(uds_forget(zone->hash_lock_map));
+		vdo_int_map_free(uds_forget(zone->hash_lock_map));
 		uds_free(uds_forget(zone->lock_array));
 	}
 
diff --git a/drivers/md/dm-vdo/int-map.c b/drivers/md/dm-vdo/int-map.c
index 463a4951e0d1..94f13df7a2e1 100644
--- a/drivers/md/dm-vdo/int-map.c
+++ b/drivers/md/dm-vdo/int-map.c
@@ -171,7 +171,7 @@ static int allocate_buckets(struct int_map *map, size_t capacity)
 }
 
 /**
- * vdo_make_int_map() - Allocate and initialize an int_map.
+ * vdo_int_map_create() - Allocate and initialize an int_map.
  * @initial_capacity: The number of entries the map should initially be capable of holding (zero
  *                    tells the map to use its own small default).
  * @initial_load: The load factor of the map, expressed as an integer percentage (typically in the
@@ -180,7 +180,8 @@ static int allocate_buckets(struct int_map *map, size_t capacity)
  *
  * Return: UDS_SUCCESS or an error code.
  */
-int vdo_make_int_map(size_t initial_capacity, unsigned int initial_load, struct int_map **map_ptr)
+int vdo_int_map_create(size_t initial_capacity, unsigned int initial_load,
+		       struct int_map **map_ptr)
 {
 	struct int_map *map;
 	int result;
@@ -207,7 +208,7 @@ int vdo_make_int_map(size_t initial_capacity, unsigned int initial_load, struct
 
 	result = allocate_buckets(map, capacity);
 	if (result != UDS_SUCCESS) {
-		vdo_free_int_map(uds_forget(map));
+		vdo_int_map_free(uds_forget(map));
 		return result;
 	}
 
@@ -216,13 +217,13 @@ int vdo_make_int_map(size_t initial_capacity, unsigned int initial_load, struct
 }
 
 /**
- * vdo_free_int_map() - Free an int_map.
+ * vdo_int_map_free() - Free an int_map.
  * @map: The int_map to free.
  *
  * NOTE: The map does not own the pointer values stored in the map and they are not freed by this
  * call.
  */
-void vdo_free_int_map(struct int_map *map)
+void vdo_int_map_free(struct int_map *map)
 {
 	if (map == NULL)
 		return;
@@ -464,7 +465,8 @@ find_empty_bucket(struct int_map *map, struct bucket *bucket, unsigned int max_p
  * Return: The bucket that was vacated by moving its entry to the provided hole, or NULL if no
  *         entry could be moved.
  */
-static struct bucket *move_empty_bucket(struct int_map *map __always_unused, struct bucket *hole)
+static struct bucket *move_empty_bucket(struct int_map *map __always_unused,
+					struct bucket *hole)
 {
 	/*
 	 * Examine every neighborhood that the empty bucket is part of, starting with the one in
@@ -572,7 +574,8 @@ static bool update_mapping(struct int_map *map,
  * Return: a pointer to an empty bucket in the desired neighborhood, or NULL if a vacancy could not
  *         be found or arranged.
  */
-static struct bucket *find_or_make_vacancy(struct int_map *map, struct bucket *neighborhood)
+static struct bucket *find_or_make_vacancy(struct int_map *map,
+					   struct bucket *neighborhood)
 {
 	/* Probe within and beyond the neighborhood for the first empty bucket. */
 	struct bucket *hole = find_empty_bucket(map, neighborhood, MAX_PROBES);
@@ -619,7 +622,8 @@ static struct bucket *find_or_make_vacancy(struct int_map *map, struct bucket *n
  *
  * Return: UDS_SUCCESS or an error code.
  */
-int vdo_int_map_put(struct int_map *map, u64 key, void *new_value, bool update, void **old_value_ptr)
+int vdo_int_map_put(struct int_map *map, u64 key, void *new_value, bool update,
+		    void **old_value_ptr)
 {
 	struct bucket *neighborhood, *bucket;
 
diff --git a/drivers/md/dm-vdo/int-map.h b/drivers/md/dm-vdo/int-map.h
index e85f12b30edc..edafb7569f51 100644
--- a/drivers/md/dm-vdo/int-map.h
+++ b/drivers/md/dm-vdo/int-map.h
@@ -23,17 +23,17 @@
 
 struct int_map;
 
-int __must_check
-vdo_make_int_map(size_t initial_capacity, unsigned int initial_load, struct int_map **map_ptr);
+int __must_check vdo_int_map_create(size_t initial_capacity, unsigned int initial_load,
+				    struct int_map **map_ptr);
 
-void vdo_free_int_map(struct int_map *map);
+void vdo_int_map_free(struct int_map *map);
 
 size_t vdo_int_map_size(const struct int_map *map);
 
 void *vdo_int_map_get(struct int_map *map, u64 key);
 
-int __must_check
-vdo_int_map_put(struct int_map *map, u64 key, void *new_value, bool update, void **old_value_ptr);
+int __must_check vdo_int_map_put(struct int_map *map, u64 key, void *new_value,
+				 bool update, void **old_value_ptr);
 
 void *vdo_int_map_remove(struct int_map *map, u64 key);
 
diff --git a/drivers/md/dm-vdo/io-submitter.c b/drivers/md/dm-vdo/io-submitter.c
index 39f5f202d69d..9471b6caabe6 100644
--- a/drivers/md/dm-vdo/io-submitter.c
+++ b/drivers/md/dm-vdo/io-submitter.c
@@ -401,8 +401,8 @@ int vdo_make_io_submitter(unsigned int thread_count, unsigned int rotation_inter
 		 * uneven. So for now, we'll assume that all requests *may* wind up on one thread,
 		 * and thus all in the same map.
 		 */
-		result = vdo_make_int_map(max_requests_active * 2, 0,
-					  &bio_queue_data->map);
+		result = vdo_int_map_create(max_requests_active * 2, 0,
+					    &bio_queue_data->map);
 		if (result != 0) {
 			/*
 			 * Clean up the partially initialized bio-queue entirely and indicate that
@@ -422,7 +422,7 @@ int vdo_make_io_submitter(unsigned int thread_count, unsigned int rotation_inter
 			 * Clean up the partially initialized bio-queue entirely and indicate that
 			 * initialization failed.
 			 */
-			vdo_free_int_map(uds_forget(bio_queue_data->map));
+			vdo_int_map_free(uds_forget(bio_queue_data->map));
 			uds_log_error("bio queue initialization failed %d", result);
 			vdo_cleanup_io_submitter(io_submitter);
 			vdo_free_io_submitter(io_submitter);
@@ -471,7 +471,7 @@ void vdo_free_io_submitter(struct io_submitter *io_submitter)
 		io_submitter->num_bio_queues_used--;
 		/* vdo_destroy() will free the work queue, so just give up our reference to it. */
 		uds_forget(io_submitter->bio_queue_data[i].queue);
-		vdo_free_int_map(uds_forget(io_submitter->bio_queue_data[i].map));
+		vdo_int_map_free(uds_forget(io_submitter->bio_queue_data[i].map));
 	}
 	uds_free(io_submitter);
 }
diff --git a/drivers/md/dm-vdo/logical-zone.c b/drivers/md/dm-vdo/logical-zone.c
index 7140e202798f..df69fb68db3d 100644
--- a/drivers/md/dm-vdo/logical-zone.c
+++ b/drivers/md/dm-vdo/logical-zone.c
@@ -57,7 +57,7 @@ static int initialize_zone(struct logical_zones *zones, zone_count_t zone_number
 	struct logical_zone *zone = &zones->zones[zone_number];
 	zone_count_t allocation_zone_number;
 
-	result = vdo_make_int_map(VDO_LOCK_MAP_CAPACITY, 0, &zone->lbn_operations);
+	result = vdo_int_map_create(VDO_LOCK_MAP_CAPACITY, 0, &zone->lbn_operations);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -137,7 +137,7 @@ void vdo_free_logical_zones(struct logical_zones *zones)
 	uds_free(uds_forget(zones->manager));
 
 	for (index = 0; index < zones->zone_count; index++)
-		vdo_free_int_map(uds_forget(zones->zones[index].lbn_operations));
+		vdo_int_map_free(uds_forget(zones->zones[index].lbn_operations));
 
 	uds_free(zones);
 }
diff --git a/drivers/md/dm-vdo/physical-zone.c b/drivers/md/dm-vdo/physical-zone.c
index 9b99c9a820a3..8ecc80ecbb53 100644
--- a/drivers/md/dm-vdo/physical-zone.c
+++ b/drivers/md/dm-vdo/physical-zone.c
@@ -330,13 +330,13 @@ static int initialize_zone(struct vdo *vdo, struct physical_zones *zones)
 	zone_count_t zone_number = zones->zone_count;
 	struct physical_zone *zone = &zones->zones[zone_number];
 
-	result = vdo_make_int_map(VDO_LOCK_MAP_CAPACITY, 0, &zone->pbn_operations);
+	result = vdo_int_map_create(VDO_LOCK_MAP_CAPACITY, 0, &zone->pbn_operations);
 	if (result != VDO_SUCCESS)
 		return result;
 
 	result = make_pbn_lock_pool(LOCK_POOL_CAPACITY, &zone->lock_pool);
 	if (result != VDO_SUCCESS) {
-		vdo_free_int_map(zone->pbn_operations);
+		vdo_int_map_free(zone->pbn_operations);
 		return result;
 	}
 
@@ -347,7 +347,7 @@ static int initialize_zone(struct vdo *vdo, struct physical_zones *zones)
 	result = vdo_make_default_thread(vdo, zone->thread_id);
 	if (result != VDO_SUCCESS) {
 		free_pbn_lock_pool(uds_forget(zone->lock_pool));
-		vdo_free_int_map(zone->pbn_operations);
+		vdo_int_map_free(zone->pbn_operations);
 		return result;
 	}
 	return result;
@@ -401,7 +401,7 @@ void vdo_free_physical_zones(struct physical_zones *zones)
 		struct physical_zone *zone = &zones->zones[index];
 
 		free_pbn_lock_pool(uds_forget(zone->lock_pool));
-		vdo_free_int_map(uds_forget(zone->pbn_operations));
+		vdo_int_map_free(uds_forget(zone->pbn_operations));
 	}
 
 	uds_free(zones);
-- 
2.42.0

