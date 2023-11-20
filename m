Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFC03A28F
	for <dm-devel@lists.linux.dev>; Mon, 20 Nov 2023 22:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AZPJZl4T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700519398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5ZoGH6v5pyA6JsprUDQvThoj1+Oai/9i5Ne4s/nBYjI=;
	b=AZPJZl4Tne6uFja5nheZ6KPXtIQ3D4pI8lbHZuHyvnGgvpBGE7zQZlsypd4eB9xHroldrO
	2L2Pak7FSOPceajRcWNx1CivIAmC04ZW4aTQbxZd4lmDDQ99h1+mhx5w/CDn8emplz9mdN
	5WPpOv1H/1Lh59Ia7Ip0gtJZqffRcTM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-93-XOlHAi0oN4-QFzxGGw_9RA-1; Mon, 20 Nov 2023 17:29:57 -0500
X-MC-Unique: XOlHAi0oN4-QFzxGGw_9RA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C7BF8533D4
	for <dm-devel@lists.linux.dev>; Mon, 20 Nov 2023 22:29:57 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 10794492BFA;
	Mon, 20 Nov 2023 22:29:57 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 0E60651CDF; Mon, 20 Nov 2023 17:29:57 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Bruce Johnston <bjohnsto@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 3/3] dm vdo int-map: remove unused parameter from vdo_int_map_create
Date: Mon, 20 Nov 2023 17:29:56 -0500
Message-ID: <e743fed750348c329e5adb5af5f3e5a3bcc110fd.1700517230.git.msakai@redhat.com>
In-Reply-To: <cover.1700517230.git.msakai@redhat.com>
References: <cover.1700517230.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Bruce Johnston <bjohnsto@redhat.com>

Reviewed-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Bruce Johnston <bjohnsto@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.c     |  6 +++---
 drivers/md/dm-vdo/dedupe.c        |  2 +-
 drivers/md/dm-vdo/int-map.c       | 13 ++-----------
 drivers/md/dm-vdo/int-map.h       |  3 +--
 drivers/md/dm-vdo/io-submitter.c  |  2 +-
 drivers/md/dm-vdo/logical-zone.c  |  2 +-
 drivers/md/dm-vdo/physical-zone.c |  2 +-
 7 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index 953819943cd3..f9f68e8d4b0c 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -232,7 +232,7 @@ static int __must_check allocate_cache_components(struct vdo_page_cache *cache)
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = vdo_int_map_create(cache->page_count, 0, &cache->page_map);
+	result = vdo_int_map_create(cache->page_count, &cache->page_map);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -1347,7 +1347,7 @@ int vdo_invalidate_page_cache(struct vdo_page_cache *cache)
 
 	/* Reset the page map by re-allocating it. */
 	vdo_int_map_free(uds_forget(cache->page_map));
-	return vdo_int_map_create(cache->page_count, 0, &cache->page_map);
+	return vdo_int_map_create(cache->page_count, &cache->page_map);
 }
 
 /**
@@ -2751,7 +2751,7 @@ static int __must_check initialize_block_map_zone(struct block_map *map,
 		INIT_LIST_HEAD(&zone->dirty_lists->eras[i][VDO_CACHE_PAGE]);
 	}
 
-	result = vdo_int_map_create(VDO_LOCK_MAP_CAPACITY, 0, &zone->loading_pages);
+	result = vdo_int_map_create(VDO_LOCK_MAP_CAPACITY, &zone->loading_pages);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index b40ba499303f..dd3ee8e46b61 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -2405,7 +2405,7 @@ static int __must_check initialize_zone(struct vdo *vdo, struct hash_zones *zone
 	data_vio_count_t i;
 	struct hash_zone *zone = &zones->zones[zone_number];
 
-	result = vdo_int_map_create(VDO_LOCK_MAP_CAPACITY, 0,
+	result = vdo_int_map_create(VDO_LOCK_MAP_CAPACITY,
 				    &zone->hash_lock_map);
 	if (result != VDO_SUCCESS)
 		return result;
diff --git a/drivers/md/dm-vdo/int-map.c b/drivers/md/dm-vdo/int-map.c
index 94f13df7a2e1..99ccbb1339c6 100644
--- a/drivers/md/dm-vdo/int-map.c
+++ b/drivers/md/dm-vdo/int-map.c
@@ -174,25 +174,16 @@ static int allocate_buckets(struct int_map *map, size_t capacity)
  * vdo_int_map_create() - Allocate and initialize an int_map.
  * @initial_capacity: The number of entries the map should initially be capable of holding (zero
  *                    tells the map to use its own small default).
- * @initial_load: The load factor of the map, expressed as an integer percentage (typically in the
- *                range 50 to 90, with zero telling the map to use its own default).
  * @map_ptr: Output, a pointer to hold the new int_map.
  *
  * Return: UDS_SUCCESS or an error code.
  */
-int vdo_int_map_create(size_t initial_capacity, unsigned int initial_load,
-		       struct int_map **map_ptr)
+int vdo_int_map_create(size_t initial_capacity, struct int_map **map_ptr)
 {
 	struct int_map *map;
 	int result;
 	size_t capacity;
 
-	/* Use the default initial load if the caller did not specify one. */
-	if (initial_load == 0)
-		initial_load = DEFAULT_LOAD;
-	if (initial_load > 100)
-		return UDS_INVALID_ARGUMENT;
-
 	result = uds_allocate(1, struct int_map, "struct int_map", &map);
 	if (result != UDS_SUCCESS)
 		return result;
@@ -204,7 +195,7 @@ int vdo_int_map_create(size_t initial_capacity, unsigned int initial_load,
 	 * Scale up the capacity by the specified initial load factor. (i.e to hold 1000 entries at
 	 * 80% load we need a capacity of 1250)
 	 */
-	capacity = capacity * 100 / initial_load;
+	capacity = capacity * 100 / DEFAULT_LOAD;
 
 	result = allocate_buckets(map, capacity);
 	if (result != UDS_SUCCESS) {
diff --git a/drivers/md/dm-vdo/int-map.h b/drivers/md/dm-vdo/int-map.h
index edafb7569f51..1858ad799887 100644
--- a/drivers/md/dm-vdo/int-map.h
+++ b/drivers/md/dm-vdo/int-map.h
@@ -23,8 +23,7 @@
 
 struct int_map;
 
-int __must_check vdo_int_map_create(size_t initial_capacity, unsigned int initial_load,
-				    struct int_map **map_ptr);
+int __must_check vdo_int_map_create(size_t initial_capacity, struct int_map **map_ptr);
 
 void vdo_int_map_free(struct int_map *map);
 
diff --git a/drivers/md/dm-vdo/io-submitter.c b/drivers/md/dm-vdo/io-submitter.c
index 9471b6caabe6..74f33a3ddce5 100644
--- a/drivers/md/dm-vdo/io-submitter.c
+++ b/drivers/md/dm-vdo/io-submitter.c
@@ -401,7 +401,7 @@ int vdo_make_io_submitter(unsigned int thread_count, unsigned int rotation_inter
 		 * uneven. So for now, we'll assume that all requests *may* wind up on one thread,
 		 * and thus all in the same map.
 		 */
-		result = vdo_int_map_create(max_requests_active * 2, 0,
+		result = vdo_int_map_create(max_requests_active * 2,
 					    &bio_queue_data->map);
 		if (result != 0) {
 			/*
diff --git a/drivers/md/dm-vdo/logical-zone.c b/drivers/md/dm-vdo/logical-zone.c
index df69fb68db3d..cfbf1701ca84 100644
--- a/drivers/md/dm-vdo/logical-zone.c
+++ b/drivers/md/dm-vdo/logical-zone.c
@@ -57,7 +57,7 @@ static int initialize_zone(struct logical_zones *zones, zone_count_t zone_number
 	struct logical_zone *zone = &zones->zones[zone_number];
 	zone_count_t allocation_zone_number;
 
-	result = vdo_int_map_create(VDO_LOCK_MAP_CAPACITY, 0, &zone->lbn_operations);
+	result = vdo_int_map_create(VDO_LOCK_MAP_CAPACITY, &zone->lbn_operations);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/physical-zone.c b/drivers/md/dm-vdo/physical-zone.c
index 8ecc80ecbb53..3bcf6f1ba77f 100644
--- a/drivers/md/dm-vdo/physical-zone.c
+++ b/drivers/md/dm-vdo/physical-zone.c
@@ -330,7 +330,7 @@ static int initialize_zone(struct vdo *vdo, struct physical_zones *zones)
 	zone_count_t zone_number = zones->zone_count;
 	struct physical_zone *zone = &zones->zones[zone_number];
 
-	result = vdo_int_map_create(VDO_LOCK_MAP_CAPACITY, 0, &zone->pbn_operations);
+	result = vdo_int_map_create(VDO_LOCK_MAP_CAPACITY, &zone->pbn_operations);
 	if (result != VDO_SUCCESS)
 		return result;
 
-- 
2.42.0

