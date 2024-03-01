Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6744F60D
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267569; cv=none; b=Z7hWuxQYuhmrwaGwAtgdQF5uhu2xr9BQDrabUAhkz1cYQNjj+hL84uQmb6hq897maB7cwsC+zppjJnMuRlRDSv0g/w2bqlzkGTEGlgFMIZ/99BKuQNof6/FW47kh1Uq4jupKtjY4k4y4s5uXvI9kaQIDPQHEgvYOMeRSABKoIIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267569; c=relaxed/simple;
	bh=pGay/sjyvdmdx5wgOFXObrwbtppCFrYGIbcM0L4ZtXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k1DiqOo/o3lLRYZxwLe0Oda2LvgBM1moLAtMdrBfSBPynxNLuKsUwuQufJZLeQY35ymehH5/BQrQfcsugmbvEt7J/NSWDXDOlNf54jLxpTTy8pfiZ3cHhZ+kkqnQrleQwAbD5J5mw+aFEOF4MsfH+GfWFdeC78XUHYdEOvfkUUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DE++MSm3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DE++MSm3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H87DhxVIYyWRnUs1bAAYRQ3HLkqcwTmSPeZXY3abj7M=;
	b=DE++MSm3aIKMO91MUvWNdp6NQYfJrWD+ZoMe/i/87BtBTQyqgoT0BS8HOfa3rkltZQnMn4
	Z9wQrt9m41RX9MfzUzkIzl0wNDYiOhF2CGS+P6QNR/Yhd71dBnshC/0dYN7CHKTEqCBDHz
	9+KPRXumfkls78Moo0WREStjJldQopo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-265-KaQ_zBhjPpGurhyU6Un9HQ-1; Thu,
 29 Feb 2024 23:32:38 -0500
X-MC-Unique: KaQ_zBhjPpGurhyU6Un9HQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B9193C0C134;
	Fri,  1 Mar 2024 04:32:38 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 74599492BC6;
	Fri,  1 Mar 2024 04:32:38 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 69B1DA15EF; Thu, 29 Feb 2024 23:32:38 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 1/2] dm vdo memory-alloc: change from uds_ to vdo_ namespace
Date: Thu, 29 Feb 2024 23:32:37 -0500
Message-ID: <56073f6b073749ec62664229399cefde7211cb31.1709267399.git.msakai@redhat.com>
In-Reply-To: <cover.1709267399.git.msakai@redhat.com>
References: <cover.1709267399.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/action-manager.c            |  2 +-
 drivers/md/dm-vdo/admin-state.c               |  2 +-
 drivers/md/dm-vdo/block-map.c                 | 60 ++++++------
 drivers/md/dm-vdo/data-vio.c                  | 24 ++---
 drivers/md/dm-vdo/dedupe.c                    | 34 +++----
 drivers/md/dm-vdo/dm-vdo-target.c             | 56 +++++------
 drivers/md/dm-vdo/dump.c                      |  2 +-
 drivers/md/dm-vdo/encodings.c                 |  4 +-
 drivers/md/dm-vdo/flush.c                     | 12 +--
 drivers/md/dm-vdo/funnel-queue.c              |  4 +-
 drivers/md/dm-vdo/funnel-workqueue.c          | 30 +++---
 drivers/md/dm-vdo/indexer/chapter-index.c     |  6 +-
 drivers/md/dm-vdo/indexer/config.c            |  4 +-
 drivers/md/dm-vdo/indexer/delta-index.c       | 20 ++--
 .../md/dm-vdo/indexer/funnel-requestqueue.c   |  4 +-
 drivers/md/dm-vdo/indexer/geometry.c          |  4 +-
 drivers/md/dm-vdo/indexer/index-layout.c      | 58 ++++++------
 drivers/md/dm-vdo/indexer/index-page-map.c    | 20 ++--
 drivers/md/dm-vdo/indexer/index-session.c     |  6 +-
 drivers/md/dm-vdo/indexer/index.c             | 26 +++---
 drivers/md/dm-vdo/indexer/io-factory.c        | 14 +--
 drivers/md/dm-vdo/indexer/open-chapter.c      |  8 +-
 drivers/md/dm-vdo/indexer/radix-sort.c        |  4 +-
 drivers/md/dm-vdo/indexer/sparse-cache.c      | 22 ++---
 drivers/md/dm-vdo/indexer/volume-index.c      | 16 ++--
 drivers/md/dm-vdo/indexer/volume.c            | 36 ++++----
 drivers/md/dm-vdo/int-map.c                   | 14 +--
 drivers/md/dm-vdo/io-submitter.c              | 10 +-
 drivers/md/dm-vdo/logical-zone.c              |  8 +-
 drivers/md/dm-vdo/memory-alloc.c              | 38 ++++----
 drivers/md/dm-vdo/memory-alloc.h              | 52 +++++------
 drivers/md/dm-vdo/message-stats.c             |  4 +-
 drivers/md/dm-vdo/packer.c                    | 14 +--
 drivers/md/dm-vdo/physical-zone.c             | 16 ++--
 drivers/md/dm-vdo/pool-sysfs.c                |  2 +-
 drivers/md/dm-vdo/priority-table.c            |  4 +-
 drivers/md/dm-vdo/recovery-journal.c          | 36 ++++----
 drivers/md/dm-vdo/repair.c                    | 24 ++---
 drivers/md/dm-vdo/slab-depot.c                | 80 ++++++++--------
 drivers/md/dm-vdo/slab-depot.h                |  2 +-
 drivers/md/dm-vdo/thread-utils.c              | 10 +-
 drivers/md/dm-vdo/uds-sysfs.c                 |  4 +-
 drivers/md/dm-vdo/vdo.c                       | 92 +++++++++----------
 drivers/md/dm-vdo/vio.c                       | 20 ++--
 44 files changed, 453 insertions(+), 455 deletions(-)

diff --git a/drivers/md/dm-vdo/action-manager.c b/drivers/md/dm-vdo/action-manager.c
index 973901fc3174..709be4c17d27 100644
--- a/drivers/md/dm-vdo/action-manager.c
+++ b/drivers/md/dm-vdo/action-manager.c
@@ -107,7 +107,7 @@ int vdo_make_action_manager(zone_count_t zones,
 			    struct action_manager **manager_ptr)
 {
 	struct action_manager *manager;
-	int result = uds_allocate(1, struct action_manager, __func__, &manager);
+	int result = vdo_allocate(1, struct action_manager, __func__, &manager);
 
 	if (result != VDO_SUCCESS)
 		return result;
diff --git a/drivers/md/dm-vdo/admin-state.c b/drivers/md/dm-vdo/admin-state.c
index 1423f4cebb8a..d695af42d140 100644
--- a/drivers/md/dm-vdo/admin-state.c
+++ b/drivers/md/dm-vdo/admin-state.c
@@ -206,7 +206,7 @@ bool vdo_finish_operation(struct admin_state *state, int result)
 	if (!state->starting) {
 		vdo_set_admin_state_code(state, state->next_state);
 		if (state->waiter != NULL)
-			vdo_launch_completion(uds_forget(state->waiter));
+			vdo_launch_completion(vdo_forget(state->waiter));
 	}
 
 	return true;
diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index b7274e94b269..b09974ad41d2 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -221,12 +221,12 @@ static int __must_check allocate_cache_components(struct vdo_page_cache *cache)
 	u64 size = cache->page_count * (u64) VDO_BLOCK_SIZE;
 	int result;
 
-	result = uds_allocate(cache->page_count, struct page_info, "page infos",
+	result = vdo_allocate(cache->page_count, struct page_info, "page infos",
 			      &cache->infos);
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = uds_allocate_memory(size, VDO_BLOCK_SIZE, "cache pages", &cache->pages);
+	result = vdo_allocate_memory(size, VDO_BLOCK_SIZE, "cache pages", &cache->pages);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -1341,7 +1341,7 @@ int vdo_invalidate_page_cache(struct vdo_page_cache *cache)
 	}
 
 	/* Reset the page map by re-allocating it. */
-	vdo_int_map_free(uds_forget(cache->page_map));
+	vdo_int_map_free(vdo_forget(cache->page_map));
 	return vdo_int_map_create(cache->page_count, &cache->page_map);
 }
 
@@ -2346,17 +2346,17 @@ static int make_segment(struct forest *old_forest, block_count_t new_pages,
 
 	forest->segments = index + 1;
 
-	result = uds_allocate(forest->segments, struct boundary,
+	result = vdo_allocate(forest->segments, struct boundary,
 			      "forest boundary array", &forest->boundaries);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = uds_allocate(forest->segments, struct tree_page *,
+	result = vdo_allocate(forest->segments, struct tree_page *,
 			      "forest page pointers", &forest->pages);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = uds_allocate(new_pages, struct tree_page,
+	result = vdo_allocate(new_pages, struct tree_page,
 			      "new forest pages", &forest->pages[index]);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -2382,7 +2382,7 @@ static int make_segment(struct forest *old_forest, block_count_t new_pages,
 		struct block_map_tree *tree = &(forest->trees[root]);
 		height_t height;
 
-		int result = uds_allocate(forest->segments,
+		int result = vdo_allocate(forest->segments,
 					  struct block_map_tree_segment,
 					  "tree root segments", &tree->segments);
 		if (result != VDO_SUCCESS)
@@ -2424,15 +2424,15 @@ static void deforest(struct forest *forest, size_t first_page_segment)
 		size_t segment;
 
 		for (segment = first_page_segment; segment < forest->segments; segment++)
-			uds_free(forest->pages[segment]);
-		uds_free(forest->pages);
+			vdo_free(forest->pages[segment]);
+		vdo_free(forest->pages);
 	}
 
 	for (root = 0; root < forest->map->root_count; root++)
-		uds_free(forest->trees[root].segments);
+		vdo_free(forest->trees[root].segments);
 
-	uds_free(forest->boundaries);
-	uds_free(forest);
+	vdo_free(forest->boundaries);
+	vdo_free(forest);
 }
 
 /**
@@ -2459,7 +2459,7 @@ static int make_forest(struct block_map *map, block_count_t entries)
 		return VDO_SUCCESS;
 	}
 
-	result = uds_allocate_extended(struct forest, map->root_count,
+	result = vdo_allocate_extended(struct forest, map->root_count,
 				       struct block_map_tree, __func__,
 				       &forest);
 	if (result != VDO_SUCCESS)
@@ -2485,7 +2485,7 @@ static void replace_forest(struct block_map *map)
 	if (map->next_forest != NULL) {
 		if (map->forest != NULL)
 			deforest(map->forest, map->forest->segments);
-		map->forest = uds_forget(map->next_forest);
+		map->forest = vdo_forget(map->next_forest);
 	}
 
 	map->entry_count = map->next_entry_count;
@@ -2501,11 +2501,11 @@ static void finish_cursor(struct cursor *cursor)
 	struct cursors *cursors = cursor->parent;
 	struct vdo_completion *completion = cursors->completion;
 
-	return_vio_to_pool(cursors->pool, uds_forget(cursor->vio));
+	return_vio_to_pool(cursors->pool, vdo_forget(cursor->vio));
 	if (--cursors->active_roots > 0)
 		return;
 
-	uds_free(cursors);
+	vdo_free(cursors);
 
 	vdo_finish_completion(completion);
 }
@@ -2681,7 +2681,7 @@ void vdo_traverse_forest(struct block_map *map, vdo_entry_callback_fn callback,
 	struct cursors *cursors;
 	int result;
 
-	result = uds_allocate_extended(struct cursors, map->root_count,
+	result = vdo_allocate_extended(struct cursors, map->root_count,
 				       struct cursor, __func__, &cursors);
 	if (result != VDO_SUCCESS) {
 		vdo_fail_completion(completion, result);
@@ -2729,7 +2729,7 @@ static int __must_check initialize_block_map_zone(struct block_map *map,
 	zone->thread_id = vdo->thread_config.logical_threads[zone_number];
 	zone->block_map = map;
 
-	result = uds_allocate_extended(struct dirty_lists, maximum_age,
+	result = vdo_allocate_extended(struct dirty_lists, maximum_age,
 				       dirty_era_t, __func__,
 				       &zone->dirty_lists);
 	if (result != VDO_SUCCESS)
@@ -2822,19 +2822,19 @@ static void uninitialize_block_map_zone(struct block_map_zone *zone)
 {
 	struct vdo_page_cache *cache = &zone->page_cache;
 
-	uds_free(uds_forget(zone->dirty_lists));
-	free_vio_pool(uds_forget(zone->vio_pool));
-	vdo_int_map_free(uds_forget(zone->loading_pages));
+	vdo_free(vdo_forget(zone->dirty_lists));
+	free_vio_pool(vdo_forget(zone->vio_pool));
+	vdo_int_map_free(vdo_forget(zone->loading_pages));
 	if (cache->infos != NULL) {
 		struct page_info *info;
 
 		for (info = cache->infos; info < cache->infos + cache->page_count; info++)
-			free_vio(uds_forget(info->vio));
+			free_vio(vdo_forget(info->vio));
 	}
 
-	vdo_int_map_free(uds_forget(cache->page_map));
-	uds_free(uds_forget(cache->infos));
-	uds_free(uds_forget(cache->pages));
+	vdo_int_map_free(vdo_forget(cache->page_map));
+	vdo_free(vdo_forget(cache->infos));
+	vdo_free(vdo_forget(cache->pages));
 }
 
 void vdo_free_block_map(struct block_map *map)
@@ -2849,9 +2849,9 @@ void vdo_free_block_map(struct block_map *map)
 
 	vdo_abandon_block_map_growth(map);
 	if (map->forest != NULL)
-		deforest(uds_forget(map->forest), 0);
-	uds_free(uds_forget(map->action_manager));
-	uds_free(map);
+		deforest(vdo_forget(map->forest), 0);
+	vdo_free(vdo_forget(map->action_manager));
+	vdo_free(map);
 }
 
 /* @journal may be NULL. */
@@ -2871,7 +2871,7 @@ int vdo_decode_block_map(struct block_map_state_2_0 state, block_count_t logical
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = uds_allocate_extended(struct block_map,
+	result = vdo_allocate_extended(struct block_map,
 				       vdo->thread_config.logical_zone_count,
 				       struct block_map_zone, __func__, &map);
 	if (result != UDS_SUCCESS)
@@ -3053,7 +3053,7 @@ void vdo_grow_block_map(struct block_map *map, struct vdo_completion *parent)
 
 void vdo_abandon_block_map_growth(struct block_map *map)
 {
-	struct forest *forest = uds_forget(map->next_forest);
+	struct forest *forest = vdo_forget(map->next_forest);
 
 	if (forest != NULL)
 		deforest(forest, forest->segments - 1);
diff --git a/drivers/md/dm-vdo/data-vio.c b/drivers/md/dm-vdo/data-vio.c
index 1630993e536f..dcdd767e40e5 100644
--- a/drivers/md/dm-vdo/data-vio.c
+++ b/drivers/md/dm-vdo/data-vio.c
@@ -789,20 +789,20 @@ static int initialize_data_vio(struct data_vio *data_vio, struct vdo *vdo)
 	int result;
 
 	BUILD_BUG_ON(VDO_BLOCK_SIZE > PAGE_SIZE);
-	result = uds_allocate_memory(VDO_BLOCK_SIZE, 0, "data_vio data",
+	result = vdo_allocate_memory(VDO_BLOCK_SIZE, 0, "data_vio data",
 				     &data_vio->vio.data);
 	if (result != VDO_SUCCESS)
 		return uds_log_error_strerror(result,
 					      "data_vio data allocation failure");
 
-	result = uds_allocate_memory(VDO_BLOCK_SIZE, 0, "compressed block",
+	result = vdo_allocate_memory(VDO_BLOCK_SIZE, 0, "compressed block",
 				     &data_vio->compression.block);
 	if (result != VDO_SUCCESS) {
 		return uds_log_error_strerror(result,
 					      "data_vio compressed block allocation failure");
 	}
 
-	result = uds_allocate_memory(VDO_BLOCK_SIZE, 0, "vio scratch",
+	result = vdo_allocate_memory(VDO_BLOCK_SIZE, 0, "vio scratch",
 				     &data_vio->scratch_block);
 	if (result != VDO_SUCCESS)
 		return uds_log_error_strerror(result,
@@ -825,10 +825,10 @@ static void destroy_data_vio(struct data_vio *data_vio)
 	if (data_vio == NULL)
 		return;
 
-	vdo_free_bio(uds_forget(data_vio->vio.bio));
-	uds_free(uds_forget(data_vio->vio.data));
-	uds_free(uds_forget(data_vio->compression.block));
-	uds_free(uds_forget(data_vio->scratch_block));
+	vdo_free_bio(vdo_forget(data_vio->vio.bio));
+	vdo_free(vdo_forget(data_vio->vio.data));
+	vdo_free(vdo_forget(data_vio->compression.block));
+	vdo_free(vdo_forget(data_vio->scratch_block));
 }
 
 /**
@@ -845,7 +845,7 @@ int make_data_vio_pool(struct vdo *vdo, data_vio_count_t pool_size,
 	struct data_vio_pool *pool;
 	data_vio_count_t i;
 
-	result = uds_allocate_extended(struct data_vio_pool, pool_size, struct data_vio,
+	result = vdo_allocate_extended(struct data_vio_pool, pool_size, struct data_vio,
 				       __func__, &pool);
 	if (result != UDS_SUCCESS)
 		return result;
@@ -867,7 +867,7 @@ int make_data_vio_pool(struct vdo *vdo, data_vio_count_t pool_size,
 
 	result = uds_make_funnel_queue(&pool->queue);
 	if (result != UDS_SUCCESS) {
-		free_data_vio_pool(uds_forget(pool));
+		free_data_vio_pool(vdo_forget(pool));
 		return result;
 	}
 
@@ -924,8 +924,8 @@ void free_data_vio_pool(struct data_vio_pool *pool)
 		destroy_data_vio(data_vio);
 	}
 
-	uds_free_funnel_queue(uds_forget(pool->queue));
-	uds_free(pool);
+	uds_free_funnel_queue(vdo_forget(pool->queue));
+	vdo_free(pool);
 }
 
 static bool acquire_permit(struct limiter *limiter)
@@ -1431,7 +1431,7 @@ void release_data_vio_allocation_lock(struct data_vio *data_vio, bool reset)
 		allocation->pbn = VDO_ZERO_BLOCK;
 
 	vdo_release_physical_zone_pbn_lock(allocation->zone, locked_pbn,
-					   uds_forget(allocation->lock));
+					   vdo_forget(allocation->lock));
 }
 
 /**
diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index b453a204239a..7cdbe825116f 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -700,7 +700,7 @@ static void unlock_duplicate_pbn(struct vdo_completion *completion)
 			"must have a duplicate lock to release");
 
 	vdo_release_physical_zone_pbn_lock(agent->duplicate.zone, agent->duplicate.pbn,
-					   uds_forget(lock->duplicate_lock));
+					   vdo_forget(lock->duplicate_lock));
 	if (lock->state == VDO_HASH_LOCK_BYPASSING) {
 		complete_data_vio(completion);
 		return;
@@ -896,7 +896,7 @@ static int __must_check acquire_lock(struct hash_zone *zone,
 	result = vdo_int_map_put(zone->hash_lock_map, hash_lock_key(new_lock),
 				 new_lock, (replace_lock != NULL), (void **) &lock);
 	if (result != VDO_SUCCESS) {
-		return_hash_lock_to_pool(zone, uds_forget(new_lock));
+		return_hash_lock_to_pool(zone, vdo_forget(new_lock));
 		return result;
 	}
 
@@ -915,7 +915,7 @@ static int __must_check acquire_lock(struct hash_zone *zone,
 		lock->registered = true;
 	} else {
 		/* There's already a lock for the hash, so we don't need the borrowed lock. */
-		return_hash_lock_to_pool(zone, uds_forget(new_lock));
+		return_hash_lock_to_pool(zone, vdo_forget(new_lock));
 	}
 
 	*lock_ptr = lock;
@@ -1980,7 +1980,7 @@ static void transfer_allocation_lock(struct data_vio *data_vio)
 	 * Since the lock is being transferred, the holder count doesn't change (and isn't even
 	 * safe to examine on this thread).
 	 */
-	hash_lock->duplicate_lock = uds_forget(allocation->lock);
+	hash_lock->duplicate_lock = vdo_forget(allocation->lock);
 }
 
 /**
@@ -2025,7 +2025,7 @@ void vdo_share_compressed_write_lock(struct data_vio *data_vio,
 
 static void dedupe_kobj_release(struct kobject *directory)
 {
-	uds_free(container_of(directory, struct hash_zones, dedupe_directory));
+	vdo_free(container_of(directory, struct hash_zones, dedupe_directory));
 }
 
 static ssize_t dedupe_status_show(struct kobject *directory, struct attribute *attr,
@@ -2083,12 +2083,12 @@ static void start_uds_queue(void *ptr)
 	 */
 	struct vdo_thread *thread = vdo_get_work_queue_owner(vdo_get_current_work_queue());
 
-	uds_register_allocating_thread(&thread->allocating_thread, NULL);
+	vdo_register_allocating_thread(&thread->allocating_thread, NULL);
 }
 
 static void finish_uds_queue(void *ptr __always_unused)
 {
-	uds_unregister_allocating_thread();
+	vdo_unregister_allocating_thread();
 }
 
 static void close_index(struct hash_zones *zones)
@@ -2259,7 +2259,7 @@ static int initialize_index(struct vdo *vdo, struct hash_zones *zones)
 	result = vdo_make_thread(vdo, vdo->thread_config.dedupe_thread, &uds_queue_type,
 				 1, NULL);
 	if (result != VDO_SUCCESS) {
-		uds_destroy_index_session(uds_forget(zones->index_session));
+		uds_destroy_index_session(vdo_forget(zones->index_session));
 		uds_log_error("UDS index queue initialization failed (%d)", result);
 		return result;
 	}
@@ -2417,7 +2417,7 @@ static int __must_check initialize_zone(struct vdo *vdo, struct hash_zones *zone
 	vdo_set_completion_callback(&zone->completion, timeout_index_operations_callback,
 				    zone->thread_id);
 	INIT_LIST_HEAD(&zone->lock_pool);
-	result = uds_allocate(LOCK_POOL_CAPACITY, struct hash_lock, "hash_lock array",
+	result = vdo_allocate(LOCK_POOL_CAPACITY, struct hash_lock, "hash_lock array",
 			      &zone->lock_array);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -2471,14 +2471,14 @@ int vdo_make_hash_zones(struct vdo *vdo, struct hash_zones **zones_ptr)
 	if (zone_count == 0)
 		return VDO_SUCCESS;
 
-	result = uds_allocate_extended(struct hash_zones, zone_count, struct hash_zone,
+	result = vdo_allocate_extended(struct hash_zones, zone_count, struct hash_zone,
 				       __func__, &zones);
 	if (result != VDO_SUCCESS)
 		return result;
 
 	result = initialize_index(vdo, zones);
 	if (result != VDO_SUCCESS) {
-		uds_free(zones);
+		vdo_free(zones);
 		return result;
 	}
 
@@ -2510,7 +2510,7 @@ void vdo_finish_dedupe_index(struct hash_zones *zones)
 	if (zones == NULL)
 		return;
 
-	uds_destroy_index_session(uds_forget(zones->index_session));
+	uds_destroy_index_session(vdo_forget(zones->index_session));
 }
 
 /**
@@ -2524,14 +2524,14 @@ void vdo_free_hash_zones(struct hash_zones *zones)
 	if (zones == NULL)
 		return;
 
-	uds_free(uds_forget(zones->manager));
+	vdo_free(vdo_forget(zones->manager));
 
 	for (i = 0; i < zones->zone_count; i++) {
 		struct hash_zone *zone = &zones->zones[i];
 
-		uds_free_funnel_queue(uds_forget(zone->timed_out_complete));
-		vdo_int_map_free(uds_forget(zone->hash_lock_map));
-		uds_free(uds_forget(zone->lock_array));
+		uds_free_funnel_queue(vdo_forget(zone->timed_out_complete));
+		vdo_int_map_free(vdo_forget(zone->hash_lock_map));
+		vdo_free(vdo_forget(zone->lock_array));
 	}
 
 	if (zones->index_session != NULL)
@@ -2539,7 +2539,7 @@ void vdo_free_hash_zones(struct hash_zones *zones)
 
 	ratelimit_state_exit(&zones->ratelimiter);
 	if (vdo_get_admin_state_code(&zones->state) == VDO_ADMIN_STATE_NEW)
-		uds_free(zones);
+		vdo_free(zones);
 	else
 		kobject_put(&zones->dedupe_directory);
 }
diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index 175ee56a89e1..86c30fbd75ca 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -189,12 +189,12 @@ static void free_device_config(struct device_config *config)
 	if (config->owned_device != NULL)
 		dm_put_device(config->owning_target, config->owned_device);
 
-	uds_free(config->parent_device_name);
-	uds_free(config->original_string);
+	vdo_free(config->parent_device_name);
+	vdo_free(config->original_string);
 
 	/* Reduce the chance a use-after-free (as in BZ 1669960) happens to work. */
 	memset(config, 0, sizeof(*config));
-	uds_free(config);
+	vdo_free(config);
 }
 
 /**
@@ -249,15 +249,15 @@ static void free_string_array(char **string_array)
 	unsigned int offset;
 
 	for (offset = 0; string_array[offset] != NULL; offset++)
-		uds_free(string_array[offset]);
-	uds_free(string_array);
+		vdo_free(string_array[offset]);
+	vdo_free(string_array);
 }
 
 /*
  * Split the input string into substrings, separated at occurrences of the indicated character,
  * returning a null-terminated list of string pointers.
  *
- * The string pointers and the pointer array itself should both be freed with uds_free() when no
+ * The string pointers and the pointer array itself should both be freed with vdo_free() when no
  * longer needed. This can be done with vdo_free_string_array (below) if the pointers in the array
  * are not changed. Since the array and copied strings are allocated by this function, it may only
  * be used in contexts where allocation is permitted.
@@ -278,7 +278,7 @@ static int split_string(const char *string, char separator, char ***substring_ar
 			substring_count++;
 	}
 
-	result = uds_allocate(substring_count + 1, char *, "string-splitting array",
+	result = vdo_allocate(substring_count + 1, char *, "string-splitting array",
 			      &substrings);
 	if (result != UDS_SUCCESS)
 		return result;
@@ -287,7 +287,7 @@ static int split_string(const char *string, char separator, char ***substring_ar
 		if (*s == separator) {
 			ptrdiff_t length = s - string;
 
-			result = uds_allocate(length + 1, char, "split string",
+			result = vdo_allocate(length + 1, char, "split string",
 					      &substrings[current_substring]);
 			if (result != UDS_SUCCESS) {
 				free_string_array(substrings);
@@ -308,7 +308,7 @@ static int split_string(const char *string, char separator, char ***substring_ar
 	BUG_ON(current_substring != (substring_count - 1));
 	length = strlen(string);
 
-	result = uds_allocate(length + 1, char, "split string",
+	result = vdo_allocate(length + 1, char, "split string",
 			      &substrings[current_substring]);
 	if (result != UDS_SUCCESS) {
 		free_string_array(substrings);
@@ -337,7 +337,7 @@ static int join_strings(char **substring_array, size_t array_length, char separa
 	for (i = 0; (i < array_length) && (substring_array[i] != NULL); i++)
 		string_length += strlen(substring_array[i]) + 1;
 
-	result = uds_allocate(string_length, char, __func__, &output);
+	result = vdo_allocate(string_length, char, __func__, &output);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -731,7 +731,7 @@ static int parse_device_config(int argc, char **argv, struct dm_target *ti,
 		return VDO_BAD_CONFIGURATION;
 	}
 
-	result = uds_allocate(1, struct device_config, "device_config", &config);
+	result = vdo_allocate(1, struct device_config, "device_config", &config);
 	if (result != VDO_SUCCESS) {
 		handle_parse_error(config, error_ptr,
 				   "Could not allocate config structure");
@@ -777,7 +777,7 @@ static int parse_device_config(int argc, char **argv, struct dm_target *ti,
 	if (config->version >= 1)
 		dm_shift_arg(&arg_set);
 
-	result = uds_duplicate_string(dm_shift_arg(&arg_set), "parent device name",
+	result = vdo_duplicate_string(dm_shift_arg(&arg_set), "parent device name",
 				      &config->parent_device_name);
 	if (result != VDO_SUCCESS) {
 		handle_parse_error(config, error_ptr,
@@ -1100,7 +1100,7 @@ static int vdo_message(struct dm_target *ti, unsigned int argc, char **argv,
 	}
 
 	vdo = get_vdo_for_target(ti);
-	uds_register_allocating_thread(&allocating_thread, NULL);
+	vdo_register_allocating_thread(&allocating_thread, NULL);
 	vdo_register_thread_device_id(&instance_thread, &vdo->instance);
 
 	/*
@@ -1115,7 +1115,7 @@ static int vdo_message(struct dm_target *ti, unsigned int argc, char **argv,
 	}
 
 	vdo_unregister_thread_device_id();
-	uds_unregister_allocating_thread();
+	vdo_unregister_allocating_thread();
 	return result;
 }
 
@@ -1536,7 +1536,7 @@ static int grow_bit_array(void)
 	unsigned long *new_words;
 	int result;
 
-	result = uds_reallocate_memory(instances.words,
+	result = vdo_reallocate_memory(instances.words,
 				       get_bit_array_size(instances.bit_count),
 				       get_bit_array_size(new_count),
 				       "instance number bit array", &new_words);
@@ -1702,7 +1702,7 @@ static int grow_layout(struct vdo *vdo, block_count_t old_size, block_count_t ne
 							  VDO_SLAB_SUMMARY_PARTITION),
 				       &vdo->next_layout);
 	if (result != VDO_SUCCESS) {
-		dm_kcopyd_client_destroy(uds_forget(vdo->partition_copier));
+		dm_kcopyd_client_destroy(vdo_forget(vdo->partition_copier));
 		return result;
 	}
 
@@ -1715,7 +1715,7 @@ static int grow_layout(struct vdo *vdo, block_count_t old_size, block_count_t ne
 	if (min_new_size > new_size) {
 		/* Copying the journal and summary would destroy some old metadata. */
 		vdo_uninitialize_layout(&vdo->next_layout);
-		dm_kcopyd_client_destroy(uds_forget(vdo->partition_copier));
+		dm_kcopyd_client_destroy(vdo_forget(vdo->partition_copier));
 		return VDO_INCREMENT_TOO_SMALL;
 	}
 
@@ -1901,7 +1901,7 @@ static int vdo_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	const char *device_name;
 	struct vdo *vdo;
 
-	uds_register_allocating_thread(&allocating_thread, NULL);
+	vdo_register_allocating_thread(&allocating_thread, NULL);
 	device_name = vdo_get_device_name(ti);
 	vdo = vdo_find_matching(vdo_is_named, device_name);
 	if (vdo == NULL) {
@@ -1912,14 +1912,14 @@ static int vdo_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		vdo_unregister_thread_device_id();
 	}
 
-	uds_unregister_allocating_thread();
+	vdo_unregister_allocating_thread();
 	return result;
 }
 
 static void vdo_dtr(struct dm_target *ti)
 {
 	struct device_config *config = ti->private;
-	struct vdo *vdo = uds_forget(config->vdo);
+	struct vdo *vdo = vdo_forget(config->vdo);
 
 	list_del_init(&config->config_list);
 	if (list_empty(&vdo->device_config_list)) {
@@ -1930,17 +1930,17 @@ static void vdo_dtr(struct dm_target *ti)
 		struct registered_thread allocating_thread, instance_thread;
 
 		vdo_register_thread_device_id(&instance_thread, &instance);
-		uds_register_allocating_thread(&allocating_thread, NULL);
+		vdo_register_allocating_thread(&allocating_thread, NULL);
 
 		device_name = vdo_get_device_name(ti);
 		uds_log_info("stopping device '%s'", device_name);
 		if (vdo->dump_on_shutdown)
 			vdo_dump_all(vdo, "device shutdown");
 
-		vdo_destroy(uds_forget(vdo));
+		vdo_destroy(vdo_forget(vdo));
 		uds_log_info("device '%s' stopped", device_name);
 		vdo_unregister_thread_device_id();
-		uds_unregister_allocating_thread();
+		vdo_unregister_allocating_thread();
 		release_instance(instance);
 	} else if (config == vdo->device_config) {
 		/*
@@ -2323,7 +2323,7 @@ static void handle_load_error(struct vdo_completion *completion)
 	    (vdo->admin.phase == LOAD_PHASE_MAKE_DIRTY)) {
 		uds_log_error_strerror(completion->result, "aborting load");
 		vdo->admin.phase = LOAD_PHASE_DRAIN_JOURNAL;
-		load_callback(uds_forget(completion));
+		load_callback(vdo_forget(completion));
 		return;
 	}
 
@@ -2633,7 +2633,7 @@ static void grow_physical_callback(struct vdo_completion *completion)
 	case GROW_PHYSICAL_PHASE_UPDATE_COMPONENTS:
 		vdo_uninitialize_layout(&vdo->layout);
 		vdo->layout = vdo->next_layout;
-		uds_forget(vdo->next_layout.head);
+		vdo_forget(vdo->next_layout.head);
 		vdo->states.vdo.config.physical_blocks = vdo->layout.size;
 		vdo_update_slab_depot_size(vdo->depot);
 		vdo_save_components(vdo, completion);
@@ -2893,7 +2893,7 @@ static void vdo_module_destroy(void)
 	ASSERT_LOG_ONLY(instances.count == 0,
 			"should have no instance numbers still in use, but have %u",
 			instances.count);
-	uds_free(instances.words);
+	vdo_free(instances.words);
 	memset(&instances, 0, sizeof(struct instance_tracker));
 
 	uds_log_info("unloaded version %s", CURRENT_VERSION);
@@ -2904,7 +2904,7 @@ static int __init vdo_init(void)
 	int result = 0;
 
 	/* Memory tracking must be initialized first for accurate accounting. */
-	uds_memory_init();
+	vdo_memory_init();
 	uds_init_sysfs();
 
 	vdo_initialize_thread_device_registry();
@@ -2935,7 +2935,7 @@ static void __exit vdo_exit(void)
 	vdo_module_destroy();
 	uds_put_sysfs();
 	/* Memory tracking cleanup must be done last. */
-	uds_memory_exit();
+	vdo_memory_exit();
 }
 
 module_init(vdo_init);
diff --git a/drivers/md/dm-vdo/dump.c b/drivers/md/dm-vdo/dump.c
index 2a0890b54186..52ee9a72781c 100644
--- a/drivers/md/dm-vdo/dump.c
+++ b/drivers/md/dm-vdo/dump.c
@@ -79,7 +79,7 @@ static void do_dump(struct vdo *vdo, unsigned int dump_options_requested,
 	if ((dump_options_requested & FLAG_SHOW_VDO_STATUS) != 0)
 		vdo_dump_status(vdo);
 
-	uds_report_memory_usage();
+	vdo_report_memory_usage();
 	uds_log_info("end of %s dump", UDS_LOGGING_MODULE_NAME);
 }
 
diff --git a/drivers/md/dm-vdo/encodings.c b/drivers/md/dm-vdo/encodings.c
index 4a0a6afea670..56d94339d2af 100644
--- a/drivers/md/dm-vdo/encodings.c
+++ b/drivers/md/dm-vdo/encodings.c
@@ -799,7 +799,7 @@ static int allocate_partition(struct layout *layout, u8 id,
 	struct partition *partition;
 	int result;
 
-	result = uds_allocate(1, struct partition, __func__, &partition);
+	result = vdo_allocate(1, struct partition, __func__, &partition);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -928,7 +928,7 @@ void vdo_uninitialize_layout(struct layout *layout)
 		struct partition *part = layout->head;
 
 		layout->head = part->next;
-		uds_free(part);
+		vdo_free(part);
 	}
 
 	memset(layout, 0, sizeof(struct layout));
diff --git a/drivers/md/dm-vdo/flush.c b/drivers/md/dm-vdo/flush.c
index 1bc13470a608..8d8d9cf4a24c 100644
--- a/drivers/md/dm-vdo/flush.c
+++ b/drivers/md/dm-vdo/flush.c
@@ -103,9 +103,9 @@ static void *allocate_flush(gfp_t gfp_mask, void *pool_data)
 	struct vdo_flush *flush = NULL;
 
 	if ((gfp_mask & GFP_NOWAIT) == GFP_NOWAIT) {
-		flush = uds_allocate_memory_nowait(sizeof(struct vdo_flush), __func__);
+		flush = vdo_allocate_memory_nowait(sizeof(struct vdo_flush), __func__);
 	} else {
-		int result = uds_allocate(1, struct vdo_flush, __func__, &flush);
+		int result = vdo_allocate(1, struct vdo_flush, __func__, &flush);
 
 		if (result != VDO_SUCCESS)
 			uds_log_error_strerror(result, "failed to allocate spare flush");
@@ -123,7 +123,7 @@ static void *allocate_flush(gfp_t gfp_mask, void *pool_data)
 
 static void free_flush(void *element, void *pool_data __always_unused)
 {
-	uds_free(element);
+	vdo_free(element);
 }
 
 /**
@@ -134,7 +134,7 @@ static void free_flush(void *element, void *pool_data __always_unused)
  */
 int vdo_make_flusher(struct vdo *vdo)
 {
-	int result = uds_allocate(1, struct flusher, __func__, &vdo->flusher);
+	int result = vdo_allocate(1, struct flusher, __func__, &vdo->flusher);
 
 	if (result != VDO_SUCCESS)
 		return result;
@@ -162,8 +162,8 @@ void vdo_free_flusher(struct flusher *flusher)
 		return;
 
 	if (flusher->flush_pool != NULL)
-		mempool_destroy(uds_forget(flusher->flush_pool));
-	uds_free(flusher);
+		mempool_destroy(vdo_forget(flusher->flush_pool));
+	vdo_free(flusher);
 }
 
 /**
diff --git a/drivers/md/dm-vdo/funnel-queue.c b/drivers/md/dm-vdo/funnel-queue.c
index d5d96bb38b94..67f7b52ecc86 100644
--- a/drivers/md/dm-vdo/funnel-queue.c
+++ b/drivers/md/dm-vdo/funnel-queue.c
@@ -14,7 +14,7 @@ int uds_make_funnel_queue(struct funnel_queue **queue_ptr)
 	int result;
 	struct funnel_queue *queue;
 
-	result = uds_allocate(1, struct funnel_queue, "funnel queue", &queue);
+	result = vdo_allocate(1, struct funnel_queue, "funnel queue", &queue);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -32,7 +32,7 @@ int uds_make_funnel_queue(struct funnel_queue **queue_ptr)
 
 void uds_free_funnel_queue(struct funnel_queue *queue)
 {
-	uds_free(queue);
+	vdo_free(queue);
 }
 
 static struct funnel_queue_entry *get_oldest(struct funnel_queue *queue)
diff --git a/drivers/md/dm-vdo/funnel-workqueue.c b/drivers/md/dm-vdo/funnel-workqueue.c
index 8f0ada13e549..ebf8dce67086 100644
--- a/drivers/md/dm-vdo/funnel-workqueue.c
+++ b/drivers/md/dm-vdo/funnel-workqueue.c
@@ -276,8 +276,8 @@ static void free_simple_work_queue(struct simple_work_queue *queue)
 
 	for (i = 0; i <= VDO_WORK_Q_MAX_PRIORITY; i++)
 		uds_free_funnel_queue(queue->priority_lists[i]);
-	uds_free(queue->common.name);
-	uds_free(queue);
+	vdo_free(queue->common.name);
+	vdo_free(queue);
 }
 
 static void free_round_robin_work_queue(struct round_robin_work_queue *queue)
@@ -290,9 +290,9 @@ static void free_round_robin_work_queue(struct round_robin_work_queue *queue)
 
 	for (i = 0; i < count; i++)
 		free_simple_work_queue(queue_table[i]);
-	uds_free(queue_table);
-	uds_free(queue->common.name);
-	uds_free(queue);
+	vdo_free(queue_table);
+	vdo_free(queue->common.name);
+	vdo_free(queue);
 }
 
 void vdo_free_work_queue(struct vdo_work_queue *queue)
@@ -323,7 +323,7 @@ static int make_simple_work_queue(const char *thread_name_prefix, const char *na
 			"queue priority count %u within limit %u", type->max_priority,
 			VDO_WORK_Q_MAX_PRIORITY);
 
-	result = uds_allocate(1, struct simple_work_queue, "simple work queue", &queue);
+	result = vdo_allocate(1, struct simple_work_queue, "simple work queue", &queue);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -333,9 +333,9 @@ static int make_simple_work_queue(const char *thread_name_prefix, const char *na
 	queue->common.owner = owner;
 	init_waitqueue_head(&queue->waiting_worker_threads);
 
-	result = uds_duplicate_string(name, "queue name", &queue->common.name);
+	result = vdo_duplicate_string(name, "queue name", &queue->common.name);
 	if (result != VDO_SUCCESS) {
-		uds_free(queue);
+		vdo_free(queue);
 		return -ENOMEM;
 	}
 
@@ -399,15 +399,15 @@ int vdo_make_work_queue(const char *thread_name_prefix, const char *name,
 		return result;
 	}
 
-	result = uds_allocate(1, struct round_robin_work_queue, "round-robin work queue",
+	result = vdo_allocate(1, struct round_robin_work_queue, "round-robin work queue",
 			      &queue);
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = uds_allocate(thread_count, struct simple_work_queue *,
+	result = vdo_allocate(thread_count, struct simple_work_queue *,
 			      "subordinate work queues", &queue->service_queues);
 	if (result != UDS_SUCCESS) {
-		uds_free(queue);
+		vdo_free(queue);
 		return result;
 	}
 
@@ -415,10 +415,10 @@ int vdo_make_work_queue(const char *thread_name_prefix, const char *name,
 	queue->common.round_robin_mode = true;
 	queue->common.owner = owner;
 
-	result = uds_duplicate_string(name, "queue name", &queue->common.name);
+	result = vdo_duplicate_string(name, "queue name", &queue->common.name);
 	if (result != VDO_SUCCESS) {
-		uds_free(queue->service_queues);
-		uds_free(queue);
+		vdo_free(queue->service_queues);
+		vdo_free(queue);
 		return -ENOMEM;
 	}
 
@@ -433,7 +433,7 @@ int vdo_make_work_queue(const char *thread_name_prefix, const char *name,
 		if (result != VDO_SUCCESS) {
 			queue->num_service_queues = i;
 			/* Destroy previously created subordinates. */
-			vdo_free_work_queue(uds_forget(*queue_ptr));
+			vdo_free_work_queue(vdo_forget(*queue_ptr));
 			return result;
 		}
 	}
diff --git a/drivers/md/dm-vdo/indexer/chapter-index.c b/drivers/md/dm-vdo/indexer/chapter-index.c
index 6487825ada90..9477150362ae 100644
--- a/drivers/md/dm-vdo/indexer/chapter-index.c
+++ b/drivers/md/dm-vdo/indexer/chapter-index.c
@@ -20,7 +20,7 @@ int uds_make_open_chapter_index(struct open_chapter_index **chapter_index,
 	size_t memory_size;
 	struct open_chapter_index *index;
 
-	result = uds_allocate(1, struct open_chapter_index, "open chapter index", &index);
+	result = vdo_allocate(1, struct open_chapter_index, "open chapter index", &index);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -37,7 +37,7 @@ int uds_make_open_chapter_index(struct open_chapter_index **chapter_index,
 					    geometry->chapter_payload_bits,
 					    memory_size, 'm');
 	if (result != UDS_SUCCESS) {
-		uds_free(index);
+		vdo_free(index);
 		return result;
 	}
 
@@ -52,7 +52,7 @@ void uds_free_open_chapter_index(struct open_chapter_index *chapter_index)
 		return;
 
 	uds_uninitialize_delta_index(&chapter_index->delta_index);
-	uds_free(chapter_index);
+	vdo_free(chapter_index);
 }
 
 /* Re-initialize an open chapter index for a new chapter. */
diff --git a/drivers/md/dm-vdo/indexer/config.c b/drivers/md/dm-vdo/indexer/config.c
index b572350a3d5f..cd20ee8b9a02 100644
--- a/drivers/md/dm-vdo/indexer/config.c
+++ b/drivers/md/dm-vdo/indexer/config.c
@@ -325,7 +325,7 @@ int uds_make_configuration(const struct uds_parameters *params,
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = uds_allocate(1, struct uds_configuration, __func__, &config);
+	result = vdo_allocate(1, struct uds_configuration, __func__, &config);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -356,7 +356,7 @@ void uds_free_configuration(struct uds_configuration *config)
 {
 	if (config != NULL) {
 		uds_free_index_geometry(config->geometry);
-		uds_free(config);
+		vdo_free(config);
 	}
 }
 
diff --git a/drivers/md/dm-vdo/indexer/delta-index.c b/drivers/md/dm-vdo/indexer/delta-index.c
index 8eece0ba6d93..11f7b85b6710 100644
--- a/drivers/md/dm-vdo/indexer/delta-index.c
+++ b/drivers/md/dm-vdo/indexer/delta-index.c
@@ -296,12 +296,12 @@ void uds_uninitialize_delta_index(struct delta_index *delta_index)
 		return;
 
 	for (z = 0; z < delta_index->zone_count; z++) {
-		uds_free(uds_forget(delta_index->delta_zones[z].new_offsets));
-		uds_free(uds_forget(delta_index->delta_zones[z].delta_lists));
-		uds_free(uds_forget(delta_index->delta_zones[z].memory));
+		vdo_free(vdo_forget(delta_index->delta_zones[z].new_offsets));
+		vdo_free(vdo_forget(delta_index->delta_zones[z].delta_lists));
+		vdo_free(vdo_forget(delta_index->delta_zones[z].memory));
 	}
 
-	uds_free(delta_index->delta_zones);
+	vdo_free(delta_index->delta_zones);
 	memset(delta_index, 0, sizeof(struct delta_index));
 }
 
@@ -311,17 +311,17 @@ static int initialize_delta_zone(struct delta_zone *delta_zone, size_t size,
 {
 	int result;
 
-	result = uds_allocate(size, u8, "delta list", &delta_zone->memory);
+	result = vdo_allocate(size, u8, "delta list", &delta_zone->memory);
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = uds_allocate(list_count + 2, u64, "delta list temp",
+	result = vdo_allocate(list_count + 2, u64, "delta list temp",
 			      &delta_zone->new_offsets);
 	if (result != UDS_SUCCESS)
 		return result;
 
 	/* Allocate the delta lists. */
-	result = uds_allocate(list_count + 2, struct delta_list, "delta lists",
+	result = vdo_allocate(list_count + 2, struct delta_list, "delta lists",
 			      &delta_zone->delta_lists);
 	if (result != UDS_SUCCESS)
 		return result;
@@ -352,7 +352,7 @@ int uds_initialize_delta_index(struct delta_index *delta_index, unsigned int zon
 	unsigned int z;
 	size_t zone_memory;
 
-	result = uds_allocate(zone_count, struct delta_zone, "Delta Index Zones",
+	result = vdo_allocate(zone_count, struct delta_zone, "Delta Index Zones",
 			      &delta_index->delta_zones);
 	if (result != UDS_SUCCESS)
 		return result;
@@ -1047,7 +1047,7 @@ int uds_finish_restoring_delta_index(struct delta_index *delta_index,
 	unsigned int z;
 	u8 *data;
 
-	result = uds_allocate(DELTA_LIST_MAX_BYTE_COUNT, u8, __func__, &data);
+	result = vdo_allocate(DELTA_LIST_MAX_BYTE_COUNT, u8, __func__, &data);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -1062,7 +1062,7 @@ int uds_finish_restoring_delta_index(struct delta_index *delta_index,
 		}
 	}
 
-	uds_free(data);
+	vdo_free(data);
 	return saved_result;
 }
 
diff --git a/drivers/md/dm-vdo/indexer/funnel-requestqueue.c b/drivers/md/dm-vdo/indexer/funnel-requestqueue.c
index d2b49e39550c..95a402ec31c9 100644
--- a/drivers/md/dm-vdo/indexer/funnel-requestqueue.c
+++ b/drivers/md/dm-vdo/indexer/funnel-requestqueue.c
@@ -198,7 +198,7 @@ int uds_make_request_queue(const char *queue_name,
 	int result;
 	struct uds_request_queue *queue;
 
-	result = uds_allocate(1, struct uds_request_queue, __func__, &queue);
+	result = vdo_allocate(1, struct uds_request_queue, __func__, &queue);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -275,5 +275,5 @@ void uds_request_queue_finish(struct uds_request_queue *queue)
 
 	uds_free_funnel_queue(queue->main_queue);
 	uds_free_funnel_queue(queue->retry_queue);
-	uds_free(queue);
+	vdo_free(queue);
 }
diff --git a/drivers/md/dm-vdo/indexer/geometry.c b/drivers/md/dm-vdo/indexer/geometry.c
index 38c18283cdde..c735e6cb4425 100644
--- a/drivers/md/dm-vdo/indexer/geometry.c
+++ b/drivers/md/dm-vdo/indexer/geometry.c
@@ -61,7 +61,7 @@ int uds_make_index_geometry(size_t bytes_per_page, u32 record_pages_per_chapter,
 	int result;
 	struct index_geometry *geometry;
 
-	result = uds_allocate(1, struct index_geometry, "geometry", &geometry);
+	result = vdo_allocate(1, struct index_geometry, "geometry", &geometry);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -121,7 +121,7 @@ int uds_copy_index_geometry(struct index_geometry *source,
 
 void uds_free_index_geometry(struct index_geometry *geometry)
 {
-	uds_free(geometry);
+	vdo_free(geometry);
 }
 
 u32 __must_check uds_map_to_physical_chapter(const struct index_geometry *geometry,
diff --git a/drivers/md/dm-vdo/indexer/index-layout.c b/drivers/md/dm-vdo/indexer/index-layout.c
index a0227a75814b..c1bcff03cc55 100644
--- a/drivers/md/dm-vdo/indexer/index-layout.c
+++ b/drivers/md/dm-vdo/indexer/index-layout.c
@@ -484,7 +484,7 @@ static int __must_check make_index_save_region_table(struct index_save_layout *i
 		type = RH_TYPE_UNSAVED;
 	}
 
-	result = uds_allocate_extended(struct region_table, region_count,
+	result = vdo_allocate_extended(struct region_table, region_count,
 				       struct layout_region,
 				       "layout region table for ISL", &table);
 	if (result != UDS_SUCCESS)
@@ -545,7 +545,7 @@ static int __must_check write_index_save_header(struct index_save_layout *isl,
 	u8 *buffer;
 	size_t offset = 0;
 
-	result = uds_allocate(table->encoded_size, u8, "index save data", &buffer);
+	result = vdo_allocate(table->encoded_size, u8, "index save data", &buffer);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -564,7 +564,7 @@ static int __must_check write_index_save_header(struct index_save_layout *isl,
 	}
 
 	result = uds_write_to_buffered_writer(writer, buffer, offset);
-	uds_free(buffer);
+	vdo_free(buffer);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -584,12 +584,12 @@ static int write_index_save_layout(struct index_layout *layout,
 
 	result = open_region_writer(layout, &isl->header, &writer);
 	if (result != UDS_SUCCESS) {
-		uds_free(table);
+		vdo_free(table);
 		return result;
 	}
 
 	result = write_index_save_header(isl, table, writer);
-	uds_free(table);
+	vdo_free(table);
 	uds_free_buffered_writer(writer);
 
 	return result;
@@ -667,7 +667,7 @@ static int __must_check make_layout_region_table(struct index_layout *layout,
 	struct region_table *table;
 	struct layout_region *lr;
 
-	result = uds_allocate_extended(struct region_table, region_count,
+	result = vdo_allocate_extended(struct region_table, region_count,
 				       struct layout_region, "layout region table",
 				       &table);
 	if (result != UDS_SUCCESS)
@@ -715,7 +715,7 @@ static int __must_check write_layout_header(struct index_layout *layout,
 	u8 *buffer;
 	size_t offset = 0;
 
-	result = uds_allocate(table->encoded_size, u8, "layout data", &buffer);
+	result = vdo_allocate(table->encoded_size, u8, "layout data", &buffer);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -739,7 +739,7 @@ static int __must_check write_layout_header(struct index_layout *layout,
 	}
 
 	result = uds_write_to_buffered_writer(writer, buffer, offset);
-	uds_free(buffer);
+	vdo_free(buffer);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -785,12 +785,12 @@ static int __must_check save_layout(struct index_layout *layout, off_t offset)
 
 	result = open_layout_writer(layout, &layout->header, offset, &writer);
 	if (result != UDS_SUCCESS) {
-		uds_free(table);
+		vdo_free(table);
 		return result;
 	}
 
 	result = write_layout_header(layout, table, writer);
-	uds_free(table);
+	vdo_free(table);
 	uds_free_buffered_writer(writer);
 
 	return result;
@@ -805,7 +805,7 @@ static int create_index_layout(struct index_layout *layout, struct uds_configura
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = uds_allocate(sizes.save_count, struct index_save_layout, __func__,
+	result = vdo_allocate(sizes.save_count, struct index_save_layout, __func__,
 			      &layout->index.saves);
 	if (result != UDS_SUCCESS)
 		return result;
@@ -1162,7 +1162,7 @@ static int __must_check load_region_table(struct buffered_reader *reader,
 					      header.version);
 	}
 
-	result = uds_allocate_extended(struct region_table, header.region_count,
+	result = vdo_allocate_extended(struct region_table, header.region_count,
 				       struct layout_region,
 				       "single file layout region table", &table);
 	if (result != UDS_SUCCESS)
@@ -1176,7 +1176,7 @@ static int __must_check load_region_table(struct buffered_reader *reader,
 		result = uds_read_from_buffered_reader(reader, region_buffer,
 						       sizeof(region_buffer));
 		if (result != UDS_SUCCESS) {
-			uds_free(table);
+			vdo_free(table);
 			return uds_log_error_strerror(UDS_CORRUPT_DATA,
 						      "cannot read region table layouts");
 		}
@@ -1201,13 +1201,13 @@ static int __must_check read_super_block_data(struct buffered_reader *reader,
 	u8 *buffer;
 	size_t offset = 0;
 
-	result = uds_allocate(saved_size, u8, "super block data", &buffer);
+	result = vdo_allocate(saved_size, u8, "super block data", &buffer);
 	if (result != UDS_SUCCESS)
 		return result;
 
 	result = uds_read_from_buffered_reader(reader, buffer, saved_size);
 	if (result != UDS_SUCCESS) {
-		uds_free(buffer);
+		vdo_free(buffer);
 		return uds_log_error_strerror(result, "cannot read region table header");
 	}
 
@@ -1232,7 +1232,7 @@ static int __must_check read_super_block_data(struct buffered_reader *reader,
 		super->start_offset = 0;
 	}
 
-	uds_free(buffer);
+	vdo_free(buffer);
 
 	if (memcmp(super->magic_label, LAYOUT_MAGIC, MAGIC_SIZE) != 0)
 		return uds_log_error_strerror(UDS_CORRUPT_DATA,
@@ -1335,7 +1335,7 @@ static int __must_check reconstitute_layout(struct index_layout *layout,
 	int result;
 	u64 next_block = first_block;
 
-	result = uds_allocate(layout->super.max_saves, struct index_save_layout,
+	result = vdo_allocate(layout->super.max_saves, struct index_save_layout,
 			      __func__, &layout->index.saves);
 	if (result != UDS_SUCCESS)
 		return result;
@@ -1386,19 +1386,19 @@ static int __must_check load_super_block(struct index_layout *layout, size_t blo
 		return result;
 
 	if (table->header.type != RH_TYPE_SUPER) {
-		uds_free(table);
+		vdo_free(table);
 		return uds_log_error_strerror(UDS_CORRUPT_DATA,
 					      "not a superblock region table");
 	}
 
 	result = read_super_block_data(reader, layout, table->header.payload);
 	if (result != UDS_SUCCESS) {
-		uds_free(table);
+		vdo_free(table);
 		return uds_log_error_strerror(result, "unknown superblock format");
 	}
 
 	if (super->block_size != block_size) {
-		uds_free(table);
+		vdo_free(table);
 		return uds_log_error_strerror(UDS_CORRUPT_DATA,
 					      "superblock saved block_size %u differs from supplied block_size %zu",
 					      super->block_size, block_size);
@@ -1406,7 +1406,7 @@ static int __must_check load_super_block(struct index_layout *layout, size_t blo
 
 	first_block -= (super->volume_offset - super->start_offset);
 	result = reconstitute_layout(layout, table, first_block);
-	uds_free(table);
+	vdo_free(table);
 	return result;
 }
 
@@ -1545,7 +1545,7 @@ static int __must_check load_index_save(struct index_save_layout *isl,
 	if (table->header.region_blocks != isl->index_save.block_count) {
 		u64 region_blocks = table->header.region_blocks;
 
-		uds_free(table);
+		vdo_free(table);
 		return uds_log_error_strerror(UDS_CORRUPT_DATA,
 					      "unexpected index save %u region block count %llu",
 					      instance,
@@ -1553,14 +1553,14 @@ static int __must_check load_index_save(struct index_save_layout *isl,
 	}
 
 	if (table->header.type == RH_TYPE_UNSAVED) {
-		uds_free(table);
+		vdo_free(table);
 		reset_index_save_layout(isl, 0);
 		return UDS_SUCCESS;
 	}
 
 
 	if (table->header.type != RH_TYPE_SAVE) {
-		uds_free(table);
+		vdo_free(table);
 		return uds_log_error_strerror(UDS_CORRUPT_DATA,
 					      "unexpected index save %u header type %u",
 					      instance, table->header.type);
@@ -1568,14 +1568,14 @@ static int __must_check load_index_save(struct index_save_layout *isl,
 
 	result = read_index_save_data(reader, isl, table->header.payload);
 	if (result != UDS_SUCCESS) {
-		uds_free(table);
+		vdo_free(table);
 		return uds_log_error_strerror(result,
 					      "unknown index save %u data format",
 					      instance);
 	}
 
 	result = reconstruct_index_save(isl, table);
-	uds_free(table);
+	vdo_free(table);
 	if (result != UDS_SUCCESS) {
 		return uds_log_error_strerror(result, "cannot reconstruct index save %u",
 					      instance);
@@ -1695,7 +1695,7 @@ int uds_make_index_layout(struct uds_configuration *config, bool new_layout,
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = uds_allocate(1, struct index_layout, __func__, &layout);
+	result = vdo_allocate(1, struct index_layout, __func__, &layout);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -1731,11 +1731,11 @@ void uds_free_index_layout(struct index_layout *layout)
 	if (layout == NULL)
 		return;
 
-	uds_free(layout->index.saves);
+	vdo_free(layout->index.saves);
 	if (layout->factory != NULL)
 		uds_put_io_factory(layout->factory);
 
-	uds_free(layout);
+	vdo_free(layout);
 }
 
 int uds_replace_index_layout_storage(struct index_layout *layout,
diff --git a/drivers/md/dm-vdo/indexer/index-page-map.c b/drivers/md/dm-vdo/indexer/index-page-map.c
index 37037ac8eee9..ddb6d843cbd9 100644
--- a/drivers/md/dm-vdo/indexer/index-page-map.c
+++ b/drivers/md/dm-vdo/indexer/index-page-map.c
@@ -38,13 +38,13 @@ int uds_make_index_page_map(const struct index_geometry *geometry,
 	int result;
 	struct index_page_map *map;
 
-	result = uds_allocate(1, struct index_page_map, "page map", &map);
+	result = vdo_allocate(1, struct index_page_map, "page map", &map);
 	if (result != UDS_SUCCESS)
 		return result;
 
 	map->geometry = geometry;
 	map->entries_per_chapter = geometry->index_pages_per_chapter - 1;
-	result = uds_allocate(get_entry_count(geometry), u16, "Index Page Map Entries",
+	result = vdo_allocate(get_entry_count(geometry), u16, "Index Page Map Entries",
 			      &map->entries);
 	if (result != UDS_SUCCESS) {
 		uds_free_index_page_map(map);
@@ -58,8 +58,8 @@ int uds_make_index_page_map(const struct index_geometry *geometry,
 void uds_free_index_page_map(struct index_page_map *map)
 {
 	if (map != NULL) {
-		uds_free(map->entries);
-		uds_free(map);
+		vdo_free(map->entries);
+		vdo_free(map);
 	}
 }
 
@@ -118,7 +118,7 @@ int uds_write_index_page_map(struct index_page_map *map, struct buffered_writer
 	u64 saved_size = uds_compute_index_page_map_save_size(map->geometry);
 	u32 i;
 
-	result = uds_allocate(saved_size, u8, "page map data", &buffer);
+	result = vdo_allocate(saved_size, u8, "page map data", &buffer);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -129,7 +129,7 @@ int uds_write_index_page_map(struct index_page_map *map, struct buffered_writer
 		encode_u16_le(buffer, &offset, map->entries[i]);
 
 	result = uds_write_to_buffered_writer(writer, buffer, offset);
-	uds_free(buffer);
+	vdo_free(buffer);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -145,20 +145,20 @@ int uds_read_index_page_map(struct index_page_map *map, struct buffered_reader *
 	u64 saved_size = uds_compute_index_page_map_save_size(map->geometry);
 	u32 i;
 
-	result = uds_allocate(saved_size, u8, "page map data", &buffer);
+	result = vdo_allocate(saved_size, u8, "page map data", &buffer);
 	if (result != UDS_SUCCESS)
 		return result;
 
 	result = uds_read_from_buffered_reader(reader, buffer, saved_size);
 	if (result != UDS_SUCCESS) {
-		uds_free(buffer);
+		vdo_free(buffer);
 		return result;
 	}
 
 	memcpy(&magic, buffer, PAGE_MAP_MAGIC_LENGTH);
 	offset += PAGE_MAP_MAGIC_LENGTH;
 	if (memcmp(magic, PAGE_MAP_MAGIC, PAGE_MAP_MAGIC_LENGTH) != 0) {
-		uds_free(buffer);
+		vdo_free(buffer);
 		return UDS_CORRUPT_DATA;
 	}
 
@@ -166,7 +166,7 @@ int uds_read_index_page_map(struct index_page_map *map, struct buffered_reader *
 	for (i = 0; i < get_entry_count(map->geometry); i++)
 		decode_u16_le(buffer, &offset, &map->entries[i]);
 
-	uds_free(buffer);
+	vdo_free(buffer);
 	uds_log_debug("read index page map, last update %llu",
 		      (unsigned long long) map->last_update);
 	return UDS_SUCCESS;
diff --git a/drivers/md/dm-vdo/indexer/index-session.c b/drivers/md/dm-vdo/indexer/index-session.c
index 07b478f57c68..0f920a583021 100644
--- a/drivers/md/dm-vdo/indexer/index-session.c
+++ b/drivers/md/dm-vdo/indexer/index-session.c
@@ -221,7 +221,7 @@ static int __must_check make_empty_index_session(struct uds_index_session **inde
 	int result;
 	struct uds_index_session *session;
 
-	result = uds_allocate(1, struct uds_index_session, __func__, &session);
+	result = vdo_allocate(1, struct uds_index_session, __func__, &session);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -233,7 +233,7 @@ static int __must_check make_empty_index_session(struct uds_index_session **inde
 	result = uds_make_request_queue("callbackW", &handle_callbacks,
 					&session->callback_queue);
 	if (result != UDS_SUCCESS) {
-		uds_free(session);
+		vdo_free(session);
 		return result;
 	}
 
@@ -673,7 +673,7 @@ int uds_destroy_index_session(struct uds_index_session *index_session)
 	uds_request_queue_finish(index_session->callback_queue);
 	index_session->callback_queue = NULL;
 	uds_log_debug("Destroyed index session");
-	uds_free(index_session);
+	vdo_free(index_session);
 	return uds_status_to_errno(result);
 }
 
diff --git a/drivers/md/dm-vdo/indexer/index.c b/drivers/md/dm-vdo/indexer/index.c
index 35e3b45cdb71..c576033b8a53 100644
--- a/drivers/md/dm-vdo/indexer/index.c
+++ b/drivers/md/dm-vdo/indexer/index.c
@@ -88,7 +88,7 @@ static int launch_zone_message(struct uds_zone_message message, unsigned int zon
 	int result;
 	struct uds_request *request;
 
-	result = uds_allocate(1, struct uds_request, __func__, &request);
+	result = vdo_allocate(1, struct uds_request, __func__, &request);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -623,7 +623,7 @@ static void execute_zone_request(struct uds_request *request)
 		}
 
 		/* Once the message is processed it can be freed. */
-		uds_free(uds_forget(request));
+		vdo_free(vdo_forget(request));
 		return;
 	}
 
@@ -755,8 +755,8 @@ static void free_chapter_writer(struct chapter_writer *writer)
 
 	stop_chapter_writer(writer);
 	uds_free_open_chapter_index(writer->open_chapter_index);
-	uds_free(writer->collated_records);
-	uds_free(writer);
+	vdo_free(writer->collated_records);
+	vdo_free(writer);
 }
 
 static int make_chapter_writer(struct uds_index *index,
@@ -767,7 +767,7 @@ static int make_chapter_writer(struct uds_index *index,
 	size_t collated_records_size =
 		(sizeof(struct uds_volume_record) * index->volume->geometry->records_per_chapter);
 
-	result = uds_allocate_extended(struct chapter_writer, index->zone_count,
+	result = vdo_allocate_extended(struct chapter_writer, index->zone_count,
 				       struct open_chapter_zone *, "Chapter Writer",
 				       &writer);
 	if (result != UDS_SUCCESS)
@@ -777,7 +777,7 @@ static int make_chapter_writer(struct uds_index *index,
 	mutex_init(&writer->mutex);
 	uds_init_cond(&writer->cond);
 
-	result = uds_allocate_cache_aligned(collated_records_size, "collated records",
+	result = vdo_allocate_cache_aligned(collated_records_size, "collated records",
 					    &writer->collated_records);
 	if (result != UDS_SUCCESS) {
 		free_chapter_writer(writer);
@@ -1118,7 +1118,7 @@ static void free_index_zone(struct index_zone *zone)
 
 	uds_free_open_chapter(zone->open_chapter);
 	uds_free_open_chapter(zone->writing_chapter);
-	uds_free(zone);
+	vdo_free(zone);
 }
 
 static int make_index_zone(struct uds_index *index, unsigned int zone_number)
@@ -1126,7 +1126,7 @@ static int make_index_zone(struct uds_index *index, unsigned int zone_number)
 	int result;
 	struct index_zone *zone;
 
-	result = uds_allocate(1, struct index_zone, "index zone", &zone);
+	result = vdo_allocate(1, struct index_zone, "index zone", &zone);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -1163,7 +1163,7 @@ int uds_make_index(struct uds_configuration *config, enum uds_open_index_type op
 	u64 nonce;
 	unsigned int z;
 
-	result = uds_allocate_extended(struct uds_index, config->zone_count,
+	result = vdo_allocate_extended(struct uds_index, config->zone_count,
 				       struct uds_request_queue *, "index", &index);
 	if (result != UDS_SUCCESS)
 		return result;
@@ -1176,7 +1176,7 @@ int uds_make_index(struct uds_configuration *config, enum uds_open_index_type op
 		return result;
 	}
 
-	result = uds_allocate(index->zone_count, struct index_zone *, "zones",
+	result = vdo_allocate(index->zone_count, struct index_zone *, "zones",
 			      &index->zones);
 	if (result != UDS_SUCCESS) {
 		uds_free_index(index);
@@ -1289,12 +1289,12 @@ void uds_free_index(struct uds_index *index)
 	if (index->zones != NULL) {
 		for (i = 0; i < index->zone_count; i++)
 			free_index_zone(index->zones[i]);
-		uds_free(index->zones);
+		vdo_free(index->zones);
 	}
 
 	uds_free_volume(index->volume);
-	uds_free_index_layout(uds_forget(index->layout));
-	uds_free(index);
+	uds_free_index_layout(vdo_forget(index->layout));
+	vdo_free(index);
 }
 
 /* Wait for the chapter writer to complete any outstanding writes. */
diff --git a/drivers/md/dm-vdo/indexer/io-factory.c b/drivers/md/dm-vdo/indexer/io-factory.c
index fecd436986ae..749c950c0189 100644
--- a/drivers/md/dm-vdo/indexer/io-factory.c
+++ b/drivers/md/dm-vdo/indexer/io-factory.c
@@ -64,7 +64,7 @@ int uds_make_io_factory(struct block_device *bdev, struct io_factory **factory_p
 	int result;
 	struct io_factory *factory;
 
-	result = uds_allocate(1, struct io_factory, __func__, &factory);
+	result = vdo_allocate(1, struct io_factory, __func__, &factory);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -85,7 +85,7 @@ int uds_replace_storage(struct io_factory *factory, struct block_device *bdev)
 void uds_put_io_factory(struct io_factory *factory)
 {
 	if (atomic_add_return(-1, &factory->ref_count) <= 0)
-		uds_free(factory);
+		vdo_free(factory);
 }
 
 size_t uds_get_writable_size(struct io_factory *factory)
@@ -129,7 +129,7 @@ void uds_free_buffered_reader(struct buffered_reader *reader)
 
 	dm_bufio_client_destroy(reader->client);
 	uds_put_io_factory(reader->factory);
-	uds_free(reader);
+	vdo_free(reader);
 }
 
 /* Create a buffered reader for an index region starting at offset. */
@@ -144,7 +144,7 @@ int uds_make_buffered_reader(struct io_factory *factory, off_t offset, u64 block
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = uds_allocate(1, struct buffered_reader, "buffered reader", &reader);
+	result = vdo_allocate(1, struct buffered_reader, "buffered reader", &reader);
 	if (result != UDS_SUCCESS) {
 		dm_bufio_client_destroy(client);
 		return result;
@@ -177,7 +177,7 @@ static int position_reader(struct buffered_reader *reader, sector_t block_number
 			return UDS_OUT_OF_RANGE;
 
 		if (reader->buffer != NULL)
-			dm_bufio_release(uds_forget(reader->buffer));
+			dm_bufio_release(vdo_forget(reader->buffer));
 
 		data = dm_bufio_read(reader->client, block_number, &buffer);
 		if (IS_ERR(data))
@@ -282,7 +282,7 @@ int uds_make_buffered_writer(struct io_factory *factory, off_t offset, u64 block
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = uds_allocate(1, struct buffered_writer, "buffered writer", &writer);
+	result = vdo_allocate(1, struct buffered_writer, "buffered writer", &writer);
 	if (result != UDS_SUCCESS) {
 		dm_bufio_client_destroy(client);
 		return result;
@@ -369,7 +369,7 @@ void uds_free_buffered_writer(struct buffered_writer *writer)
 
 	dm_bufio_client_destroy(writer->client);
 	uds_put_io_factory(writer->factory);
-	uds_free(writer);
+	vdo_free(writer);
 }
 
 /*
diff --git a/drivers/md/dm-vdo/indexer/open-chapter.c b/drivers/md/dm-vdo/indexer/open-chapter.c
index cd2d35e39c20..4a4dc94915dd 100644
--- a/drivers/md/dm-vdo/indexer/open-chapter.c
+++ b/drivers/md/dm-vdo/indexer/open-chapter.c
@@ -68,7 +68,7 @@ int uds_make_open_chapter(const struct index_geometry *geometry, unsigned int zo
 	size_t capacity = geometry->records_per_chapter / zone_count;
 	size_t slot_count = (1 << bits_per(capacity * LOAD_RATIO));
 
-	result = uds_allocate_extended(struct open_chapter_zone, slot_count,
+	result = vdo_allocate_extended(struct open_chapter_zone, slot_count,
 				       struct open_chapter_zone_slot, "open chapter",
 				       &open_chapter);
 	if (result != UDS_SUCCESS)
@@ -76,7 +76,7 @@ int uds_make_open_chapter(const struct index_geometry *geometry, unsigned int zo
 
 	open_chapter->slot_count = slot_count;
 	open_chapter->capacity = capacity;
-	result = uds_allocate_cache_aligned(records_size(open_chapter), "record pages",
+	result = vdo_allocate_cache_aligned(records_size(open_chapter), "record pages",
 					    &open_chapter->records);
 	if (result != UDS_SUCCESS) {
 		uds_free_open_chapter(open_chapter);
@@ -194,8 +194,8 @@ void uds_remove_from_open_chapter(struct open_chapter_zone *open_chapter,
 void uds_free_open_chapter(struct open_chapter_zone *open_chapter)
 {
 	if (open_chapter != NULL) {
-		uds_free(open_chapter->records);
-		uds_free(open_chapter);
+		vdo_free(open_chapter->records);
+		vdo_free(open_chapter);
 	}
 }
 
diff --git a/drivers/md/dm-vdo/indexer/radix-sort.c b/drivers/md/dm-vdo/indexer/radix-sort.c
index b86d55f0827e..74ea18b8e9be 100644
--- a/drivers/md/dm-vdo/indexer/radix-sort.c
+++ b/drivers/md/dm-vdo/indexer/radix-sort.c
@@ -211,7 +211,7 @@ int uds_make_radix_sorter(unsigned int count, struct radix_sorter **sorter)
 	unsigned int stack_size = count / INSERTION_SORT_THRESHOLD;
 	struct radix_sorter *radix_sorter;
 
-	result = uds_allocate_extended(struct radix_sorter, stack_size, struct task,
+	result = vdo_allocate_extended(struct radix_sorter, stack_size, struct task,
 				       __func__, &radix_sorter);
 	if (result != UDS_SUCCESS)
 		return result;
@@ -224,7 +224,7 @@ int uds_make_radix_sorter(unsigned int count, struct radix_sorter **sorter)
 
 void uds_free_radix_sorter(struct radix_sorter *sorter)
 {
-	uds_free(sorter);
+	vdo_free(sorter);
 }
 
 /*
diff --git a/drivers/md/dm-vdo/indexer/sparse-cache.c b/drivers/md/dm-vdo/indexer/sparse-cache.c
index 9e8672cba3fa..e297ba2d6ceb 100644
--- a/drivers/md/dm-vdo/indexer/sparse-cache.c
+++ b/drivers/md/dm-vdo/indexer/sparse-cache.c
@@ -222,12 +222,12 @@ static int __must_check initialize_cached_chapter_index(struct cached_chapter_in
 	chapter->virtual_chapter = NO_CHAPTER;
 	chapter->index_pages_count = geometry->index_pages_per_chapter;
 
-	result = uds_allocate(chapter->index_pages_count, struct delta_index_page,
+	result = vdo_allocate(chapter->index_pages_count, struct delta_index_page,
 			      __func__, &chapter->index_pages);
 	if (result != UDS_SUCCESS)
 		return result;
 
-	return uds_allocate(chapter->index_pages_count, struct dm_buffer *,
+	return vdo_allocate(chapter->index_pages_count, struct dm_buffer *,
 			    "sparse index volume pages", &chapter->page_buffers);
 }
 
@@ -241,7 +241,7 @@ static int __must_check make_search_list(struct sparse_cache *cache,
 
 	bytes = (sizeof(struct search_list) +
 		 (cache->capacity * sizeof(struct cached_chapter_index *)));
-	result = uds_allocate_cache_aligned(bytes, "search list", &list);
+	result = vdo_allocate_cache_aligned(bytes, "search list", &list);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -264,7 +264,7 @@ int uds_make_sparse_cache(const struct index_geometry *geometry, unsigned int ca
 	unsigned int bytes;
 
 	bytes = (sizeof(struct sparse_cache) + (capacity * sizeof(struct cached_chapter_index)));
-	result = uds_allocate_cache_aligned(bytes, "sparse cache", &cache);
+	result = vdo_allocate_cache_aligned(bytes, "sparse cache", &cache);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -294,7 +294,7 @@ int uds_make_sparse_cache(const struct index_geometry *geometry, unsigned int ca
 	}
 
 	/* purge_search_list() needs some temporary lists for sorting. */
-	result = uds_allocate(capacity * 2, struct cached_chapter_index *,
+	result = vdo_allocate(capacity * 2, struct cached_chapter_index *,
 			      "scratch entries", &cache->scratch_entries);
 	if (result != UDS_SUCCESS)
 		goto out;
@@ -338,7 +338,7 @@ static void release_cached_chapter_index(struct cached_chapter_index *chapter)
 
 	for (i = 0; i < chapter->index_pages_count; i++) {
 		if (chapter->page_buffers[i] != NULL)
-			dm_bufio_release(uds_forget(chapter->page_buffers[i]));
+			dm_bufio_release(vdo_forget(chapter->page_buffers[i]));
 	}
 }
 
@@ -349,18 +349,18 @@ void uds_free_sparse_cache(struct sparse_cache *cache)
 	if (cache == NULL)
 		return;
 
-	uds_free(cache->scratch_entries);
+	vdo_free(cache->scratch_entries);
 
 	for (i = 0; i < cache->zone_count; i++)
-		uds_free(cache->search_lists[i]);
+		vdo_free(cache->search_lists[i]);
 
 	for (i = 0; i < cache->capacity; i++) {
 		release_cached_chapter_index(&cache->chapters[i]);
-		uds_free(cache->chapters[i].index_pages);
-		uds_free(cache->chapters[i].page_buffers);
+		vdo_free(cache->chapters[i].index_pages);
+		vdo_free(cache->chapters[i].page_buffers);
 	}
 
-	uds_free(cache);
+	vdo_free(cache);
 }
 
 /*
diff --git a/drivers/md/dm-vdo/indexer/volume-index.c b/drivers/md/dm-vdo/indexer/volume-index.c
index a88e515ceef6..1a762e6dd709 100644
--- a/drivers/md/dm-vdo/indexer/volume-index.c
+++ b/drivers/md/dm-vdo/indexer/volume-index.c
@@ -279,8 +279,8 @@ static int compute_volume_sub_index_parameters(const struct uds_configuration *c
 
 static void uninitialize_volume_sub_index(struct volume_sub_index *sub_index)
 {
-	uds_free(uds_forget(sub_index->flush_chapters));
-	uds_free(uds_forget(sub_index->zones));
+	vdo_free(vdo_forget(sub_index->flush_chapters));
+	vdo_free(vdo_forget(sub_index->zones));
 	uds_uninitialize_delta_index(&sub_index->delta_index);
 }
 
@@ -290,11 +290,11 @@ void uds_free_volume_index(struct volume_index *volume_index)
 		return;
 
 	if (volume_index->zones != NULL)
-		uds_free(uds_forget(volume_index->zones));
+		vdo_free(vdo_forget(volume_index->zones));
 
 	uninitialize_volume_sub_index(&volume_index->vi_non_hook);
 	uninitialize_volume_sub_index(&volume_index->vi_hook);
-	uds_free(volume_index);
+	vdo_free(volume_index);
 }
 
 
@@ -1211,12 +1211,12 @@ static int initialize_volume_sub_index(const struct uds_configuration *config,
 				  (zone_count * sizeof(struct volume_sub_index_zone)));
 
 	/* The following arrays are initialized to all zeros. */
-	result = uds_allocate(params.list_count, u64, "first chapter to flush",
+	result = vdo_allocate(params.list_count, u64, "first chapter to flush",
 			      &sub_index->flush_chapters);
 	if (result != UDS_SUCCESS)
 		return result;
 
-	return uds_allocate(zone_count, struct volume_sub_index_zone,
+	return vdo_allocate(zone_count, struct volume_sub_index_zone,
 			    "volume index zones", &sub_index->zones);
 }
 
@@ -1228,7 +1228,7 @@ int uds_make_volume_index(const struct uds_configuration *config, u64 volume_non
 	struct volume_index *volume_index;
 	int result;
 
-	result = uds_allocate(1, struct volume_index, "volume index", &volume_index);
+	result = vdo_allocate(1, struct volume_index, "volume index", &volume_index);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -1249,7 +1249,7 @@ int uds_make_volume_index(const struct uds_configuration *config, u64 volume_non
 
 	volume_index->sparse_sample_rate = config->sparse_sample_rate;
 
-	result = uds_allocate(config->zone_count, struct volume_index_zone,
+	result = vdo_allocate(config->zone_count, struct volume_index_zone,
 			      "volume index zones", &volume_index->zones);
 	if (result != UDS_SUCCESS) {
 		uds_free_volume_index(volume_index);
diff --git a/drivers/md/dm-vdo/indexer/volume.c b/drivers/md/dm-vdo/indexer/volume.c
index 002a4264a163..2d8901732f5d 100644
--- a/drivers/md/dm-vdo/indexer/volume.c
+++ b/drivers/md/dm-vdo/indexer/volume.c
@@ -198,7 +198,7 @@ static void wait_for_pending_searches(struct page_cache *cache, u32 physical_pag
 static void release_page_buffer(struct cached_page *page)
 {
 	if (page->buffer != NULL)
-		dm_bufio_release(uds_forget(page->buffer));
+		dm_bufio_release(vdo_forget(page->buffer));
 }
 
 static void clear_cache_page(struct page_cache *cache, struct cached_page *page)
@@ -1482,7 +1482,7 @@ int __must_check uds_replace_volume_storage(struct volume *volume,
 	if (volume->sparse_cache != NULL)
 		uds_invalidate_sparse_cache(volume->sparse_cache);
 	if (volume->client != NULL)
-		dm_bufio_client_destroy(uds_forget(volume->client));
+		dm_bufio_client_destroy(vdo_forget(volume->client));
 
 	return uds_open_volume_bufio(layout, volume->geometry->bytes_per_page,
 				     volume->reserved_buffers, &volume->client);
@@ -1507,22 +1507,22 @@ static int __must_check initialize_page_cache(struct page_cache *cache,
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = uds_allocate(VOLUME_CACHE_MAX_QUEUED_READS, struct queued_read,
+	result = vdo_allocate(VOLUME_CACHE_MAX_QUEUED_READS, struct queued_read,
 			      "volume read queue", &cache->read_queue);
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = uds_allocate(cache->zone_count, struct search_pending_counter,
+	result = vdo_allocate(cache->zone_count, struct search_pending_counter,
 			      "Volume Cache Zones", &cache->search_pending_counters);
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = uds_allocate(cache->indexable_pages, u16, "page cache index",
+	result = vdo_allocate(cache->indexable_pages, u16, "page cache index",
 			      &cache->index);
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = uds_allocate(cache->cache_slots, struct cached_page, "page cache cache",
+	result = vdo_allocate(cache->cache_slots, struct cached_page, "page cache cache",
 			      &cache->cache);
 	if (result != UDS_SUCCESS)
 		return result;
@@ -1546,7 +1546,7 @@ int uds_make_volume(const struct uds_configuration *config, struct index_layout
 	unsigned int reserved_buffers;
 	int result;
 
-	result = uds_allocate(1, struct volume, "volume", &volume);
+	result = vdo_allocate(1, struct volume, "volume", &volume);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -1583,7 +1583,7 @@ int uds_make_volume(const struct uds_configuration *config, struct index_layout
 		return result;
 	}
 
-	result = uds_allocate(geometry->records_per_page,
+	result = vdo_allocate(geometry->records_per_page,
 			      const struct uds_volume_record *, "record pointers",
 			      &volume->record_pointers);
 	if (result != UDS_SUCCESS) {
@@ -1624,7 +1624,7 @@ int uds_make_volume(const struct uds_configuration *config, struct index_layout
 	uds_init_cond(&volume->read_threads_read_done_cond);
 	uds_init_cond(&volume->read_threads_cond);
 
-	result = uds_allocate(config->read_threads, struct thread *, "reader threads",
+	result = vdo_allocate(config->read_threads, struct thread *, "reader threads",
 			      &volume->reader_threads);
 	if (result != UDS_SUCCESS) {
 		uds_free_volume(volume);
@@ -1654,10 +1654,10 @@ static void uninitialize_page_cache(struct page_cache *cache)
 		for (i = 0; i < cache->cache_slots; i++)
 			release_page_buffer(&cache->cache[i]);
 	}
-	uds_free(cache->index);
-	uds_free(cache->cache);
-	uds_free(cache->search_pending_counters);
-	uds_free(cache->read_queue);
+	vdo_free(cache->index);
+	vdo_free(cache->cache);
+	vdo_free(cache->search_pending_counters);
+	vdo_free(cache->read_queue);
 }
 
 void uds_free_volume(struct volume *volume)
@@ -1675,7 +1675,7 @@ void uds_free_volume(struct volume *volume)
 		mutex_unlock(&volume->read_threads_mutex);
 		for (i = 0; i < volume->read_thread_count; i++)
 			vdo_join_threads(volume->reader_threads[i]);
-		uds_free(volume->reader_threads);
+		vdo_free(volume->reader_threads);
 		volume->reader_threads = NULL;
 	}
 
@@ -1683,11 +1683,11 @@ void uds_free_volume(struct volume *volume)
 	uninitialize_page_cache(&volume->page_cache);
 	uds_free_sparse_cache(volume->sparse_cache);
 	if (volume->client != NULL)
-		dm_bufio_client_destroy(uds_forget(volume->client));
+		dm_bufio_client_destroy(vdo_forget(volume->client));
 
 	uds_free_index_page_map(volume->index_page_map);
 	uds_free_radix_sorter(volume->radix_sorter);
-	uds_free(volume->geometry);
-	uds_free(volume->record_pointers);
-	uds_free(volume);
+	vdo_free(volume->geometry);
+	vdo_free(volume->record_pointers);
+	vdo_free(volume);
 }
diff --git a/drivers/md/dm-vdo/int-map.c b/drivers/md/dm-vdo/int-map.c
index e0953e013f15..0bd742ecbe2e 100644
--- a/drivers/md/dm-vdo/int-map.c
+++ b/drivers/md/dm-vdo/int-map.c
@@ -164,7 +164,7 @@ static int allocate_buckets(struct int_map *map, size_t capacity)
 	 * without have to wrap back around to element zero.
 	 */
 	map->bucket_count = capacity + (NEIGHBORHOOD - 1);
-	return uds_allocate(map->bucket_count, struct bucket,
+	return vdo_allocate(map->bucket_count, struct bucket,
 			    "struct int_map buckets", &map->buckets);
 }
 
@@ -182,7 +182,7 @@ int vdo_int_map_create(size_t initial_capacity, struct int_map **map_ptr)
 	int result;
 	size_t capacity;
 
-	result = uds_allocate(1, struct int_map, "struct int_map", &map);
+	result = vdo_allocate(1, struct int_map, "struct int_map", &map);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -197,7 +197,7 @@ int vdo_int_map_create(size_t initial_capacity, struct int_map **map_ptr)
 
 	result = allocate_buckets(map, capacity);
 	if (result != UDS_SUCCESS) {
-		vdo_int_map_free(uds_forget(map));
+		vdo_int_map_free(vdo_forget(map));
 		return result;
 	}
 
@@ -217,8 +217,8 @@ void vdo_int_map_free(struct int_map *map)
 	if (map == NULL)
 		return;
 
-	uds_free(uds_forget(map->buckets));
-	uds_free(uds_forget(map));
+	vdo_free(vdo_forget(map->buckets));
+	vdo_free(vdo_forget(map));
 }
 
 /**
@@ -399,14 +399,14 @@ static int resize_buckets(struct int_map *map)
 		result = vdo_int_map_put(map, entry->key, entry->value, true, NULL);
 		if (result != UDS_SUCCESS) {
 			/* Destroy the new partial map and restore the map from the stack. */
-			uds_free(uds_forget(map->buckets));
+			vdo_free(vdo_forget(map->buckets));
 			*map = old_map;
 			return result;
 		}
 	}
 
 	/* Destroy the old bucket array. */
-	uds_free(uds_forget(old_map.buckets));
+	vdo_free(vdo_forget(old_map.buckets));
 	return UDS_SUCCESS;
 }
 
diff --git a/drivers/md/dm-vdo/io-submitter.c b/drivers/md/dm-vdo/io-submitter.c
index 6c050f2b3b44..23549b7e9e6d 100644
--- a/drivers/md/dm-vdo/io-submitter.c
+++ b/drivers/md/dm-vdo/io-submitter.c
@@ -380,7 +380,7 @@ int vdo_make_io_submitter(unsigned int thread_count, unsigned int rotation_inter
 	struct io_submitter *io_submitter;
 	int result;
 
-	result = uds_allocate_extended(struct io_submitter, thread_count,
+	result = vdo_allocate_extended(struct io_submitter, thread_count,
 				       struct bio_queue_data, "bio submission data",
 				       &io_submitter);
 	if (result != UDS_SUCCESS)
@@ -422,7 +422,7 @@ int vdo_make_io_submitter(unsigned int thread_count, unsigned int rotation_inter
 			 * Clean up the partially initialized bio-queue entirely and indicate that
 			 * initialization failed.
 			 */
-			vdo_int_map_free(uds_forget(bio_queue_data->map));
+			vdo_int_map_free(vdo_forget(bio_queue_data->map));
 			uds_log_error("bio queue initialization failed %d", result);
 			vdo_cleanup_io_submitter(io_submitter);
 			vdo_free_io_submitter(io_submitter);
@@ -470,8 +470,8 @@ void vdo_free_io_submitter(struct io_submitter *io_submitter)
 	for (i = io_submitter->num_bio_queues_used - 1; i >= 0; i--) {
 		io_submitter->num_bio_queues_used--;
 		/* vdo_destroy() will free the work queue, so just give up our reference to it. */
-		uds_forget(io_submitter->bio_queue_data[i].queue);
-		vdo_int_map_free(uds_forget(io_submitter->bio_queue_data[i].map));
+		vdo_forget(io_submitter->bio_queue_data[i].queue);
+		vdo_int_map_free(vdo_forget(io_submitter->bio_queue_data[i].map));
 	}
-	uds_free(io_submitter);
+	vdo_free(io_submitter);
 }
diff --git a/drivers/md/dm-vdo/logical-zone.c b/drivers/md/dm-vdo/logical-zone.c
index c5b3b1c111e3..ca5bc3be7978 100644
--- a/drivers/md/dm-vdo/logical-zone.c
+++ b/drivers/md/dm-vdo/logical-zone.c
@@ -94,7 +94,7 @@ int vdo_make_logical_zones(struct vdo *vdo, struct logical_zones **zones_ptr)
 	if (zone_count == 0)
 		return VDO_SUCCESS;
 
-	result = uds_allocate_extended(struct logical_zones, zone_count,
+	result = vdo_allocate_extended(struct logical_zones, zone_count,
 				       struct logical_zone, __func__, &zones);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -132,12 +132,12 @@ void vdo_free_logical_zones(struct logical_zones *zones)
 	if (zones == NULL)
 		return;
 
-	uds_free(uds_forget(zones->manager));
+	vdo_free(vdo_forget(zones->manager));
 
 	for (index = 0; index < zones->zone_count; index++)
-		vdo_int_map_free(uds_forget(zones->zones[index].lbn_operations));
+		vdo_int_map_free(vdo_forget(zones->zones[index].lbn_operations));
 
-	uds_free(zones);
+	vdo_free(zones);
 }
 
 static inline void assert_on_zone_thread(struct logical_zone *zone, const char *what)
diff --git a/drivers/md/dm-vdo/memory-alloc.c b/drivers/md/dm-vdo/memory-alloc.c
index db085c1124be..8d5df3e45a24 100644
--- a/drivers/md/dm-vdo/memory-alloc.c
+++ b/drivers/md/dm-vdo/memory-alloc.c
@@ -37,7 +37,7 @@ static inline bool allocations_allowed(void)
  * @new_thread: registered_thread structure to use for the current thread
  * @flag_ptr: Location of the allocation-allowed flag
  */
-void uds_register_allocating_thread(struct registered_thread *new_thread,
+void vdo_register_allocating_thread(struct registered_thread *new_thread,
 				    const bool *flag_ptr)
 {
 	if (flag_ptr == NULL) {
@@ -50,7 +50,7 @@ void uds_register_allocating_thread(struct registered_thread *new_thread,
 }
 
 /* Unregister the current thread as an allocating thread. */
-void uds_unregister_allocating_thread(void)
+void vdo_unregister_allocating_thread(void)
 {
 	vdo_unregister_thread(&allocating_threads);
 }
@@ -148,7 +148,7 @@ static void remove_vmalloc_block(void *ptr)
 
 	spin_unlock_irqrestore(&memory_stats.lock, flags);
 	if (block != NULL)
-		uds_free(block);
+		vdo_free(block);
 	else
 		uds_log_info("attempting to remove ptr %px not found in vmalloc list", ptr);
 }
@@ -196,7 +196,7 @@ static inline bool use_kmalloc(size_t size)
  *
  * Return: UDS_SUCCESS or an error code
  */
-int uds_allocate_memory(size_t size, size_t align, const char *what, void *ptr)
+int vdo_allocate_memory(size_t size, size_t align, const char *what, void *ptr)
 {
 	/*
 	 * The __GFP_RETRY_MAYFAIL flag means the VM implementation will retry memory reclaim
@@ -245,8 +245,7 @@ int uds_allocate_memory(size_t size, size_t align, const char *what, void *ptr)
 	} else {
 		struct vmalloc_block_info *block;
 
-		if (uds_allocate(1, struct vmalloc_block_info, __func__, &block) ==
-		    UDS_SUCCESS) {
+		if (vdo_allocate(1, struct vmalloc_block_info, __func__, &block) == UDS_SUCCESS) {
 			/*
 			 * It is possible for __vmalloc to fail to allocate memory because there
 			 * are no pages available. A short sleep may allow the page reclaimer
@@ -259,7 +258,6 @@ int uds_allocate_memory(size_t size, size_t align, const char *what, void *ptr)
 			 */
 			for (;;) {
 				p = __vmalloc(size, gfp_flags | __GFP_NOWARN);
-
 				if (p != NULL)
 					break;
 
@@ -273,7 +271,7 @@ int uds_allocate_memory(size_t size, size_t align, const char *what, void *ptr)
 			}
 
 			if (p == NULL) {
-				uds_free(block);
+				vdo_free(block);
 			} else {
 				block->ptr = p;
 				block->size = PAGE_ALIGN(size);
@@ -304,7 +302,7 @@ int uds_allocate_memory(size_t size, size_t align, const char *what, void *ptr)
  *
  * Return: pointer to the allocated memory, or NULL if the required space is not available.
  */
-void *uds_allocate_memory_nowait(size_t size, const char *what __maybe_unused)
+void *vdo_allocate_memory_nowait(size_t size, const char *what __maybe_unused)
 {
 	void *p = kmalloc(size, GFP_NOWAIT | __GFP_ZERO);
 
@@ -314,7 +312,7 @@ void *uds_allocate_memory_nowait(size_t size, const char *what __maybe_unused)
 	return p;
 }
 
-void uds_free(void *ptr)
+void vdo_free(void *ptr)
 {
 	if (ptr != NULL) {
 		if (is_vmalloc_addr(ptr)) {
@@ -339,18 +337,18 @@ void uds_free(void *ptr)
  *
  * Return: UDS_SUCCESS or an error code
  */
-int uds_reallocate_memory(void *ptr, size_t old_size, size_t size, const char *what,
+int vdo_reallocate_memory(void *ptr, size_t old_size, size_t size, const char *what,
 			  void *new_ptr)
 {
 	int result;
 
 	if (size == 0) {
-		uds_free(ptr);
+		vdo_free(ptr);
 		*(void **) new_ptr = NULL;
 		return UDS_SUCCESS;
 	}
 
-	result = uds_allocate(size, char, what, new_ptr);
+	result = vdo_allocate(size, char, what, new_ptr);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -359,18 +357,18 @@ int uds_reallocate_memory(void *ptr, size_t old_size, size_t size, const char *w
 			size = old_size;
 
 		memcpy(*((void **) new_ptr), ptr, size);
-		uds_free(ptr);
+		vdo_free(ptr);
 	}
 
 	return UDS_SUCCESS;
 }
 
-int uds_duplicate_string(const char *string, const char *what, char **new_string)
+int vdo_duplicate_string(const char *string, const char *what, char **new_string)
 {
 	int result;
 	u8 *dup;
 
-	result = uds_allocate(strlen(string) + 1, u8, what, &dup);
+	result = vdo_allocate(strlen(string) + 1, u8, what, &dup);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -379,13 +377,13 @@ int uds_duplicate_string(const char *string, const char *what, char **new_string
 	return UDS_SUCCESS;
 }
 
-void uds_memory_init(void)
+void vdo_memory_init(void)
 {
 	spin_lock_init(&memory_stats.lock);
 	vdo_initialize_thread_registry(&allocating_threads);
 }
 
-void uds_memory_exit(void)
+void vdo_memory_exit(void)
 {
 	ASSERT_LOG_ONLY(memory_stats.kmalloc_bytes == 0,
 			"kmalloc memory used (%zd bytes in %zd blocks) is returned to the kernel",
@@ -396,7 +394,7 @@ void uds_memory_exit(void)
 	uds_log_debug("peak usage %zd bytes", memory_stats.peak_bytes);
 }
 
-void uds_get_memory_stats(u64 *bytes_used, u64 *peak_bytes_used)
+void vdo_get_memory_stats(u64 *bytes_used, u64 *peak_bytes_used)
 {
 	unsigned long flags;
 
@@ -410,7 +408,7 @@ void uds_get_memory_stats(u64 *bytes_used, u64 *peak_bytes_used)
  * Report stats on any allocated memory that we're tracking. Not all allocation types are
  * guaranteed to be tracked in bytes (e.g., bios).
  */
-void uds_report_memory_usage(void)
+void vdo_report_memory_usage(void)
 {
 	unsigned long flags;
 	u64 kmalloc_blocks;
diff --git a/drivers/md/dm-vdo/memory-alloc.h b/drivers/md/dm-vdo/memory-alloc.h
index d72d597f98cf..3f27dd722a2d 100644
--- a/drivers/md/dm-vdo/memory-alloc.h
+++ b/drivers/md/dm-vdo/memory-alloc.h
@@ -3,8 +3,8 @@
  * Copyright 2023 Red Hat
  */
 
-#ifndef UDS_MEMORY_ALLOC_H
-#define UDS_MEMORY_ALLOC_H
+#ifndef VDO_MEMORY_ALLOC_H
+#define VDO_MEMORY_ALLOC_H
 
 #include <linux/cache.h>
 #include <linux/io.h> /* for PAGE_SIZE */
@@ -12,8 +12,8 @@
 #include "permassert.h"
 #include "thread-registry.h"
 
-/* Custom memory allocation function for UDS that tracks memory usage */
-int __must_check uds_allocate_memory(size_t size, size_t align, const char *what, void *ptr);
+/* Custom memory allocation function that tracks memory usage */
+int __must_check vdo_allocate_memory(size_t size, size_t align, const char *what, void *ptr);
 
 /*
  * Allocate storage based on element counts, sizes, and alignment.
@@ -37,7 +37,7 @@ int __must_check uds_allocate_memory(size_t size, size_t align, const char *what
  *
  * Return: UDS_SUCCESS or an error code
  */
-static inline int uds_do_allocation(size_t count, size_t size, size_t extra,
+static inline int vdo_do_allocation(size_t count, size_t size, size_t extra,
 				    size_t align, const char *what, void *ptr)
 {
 	size_t total_size = count * size + extra;
@@ -53,7 +53,7 @@ static inline int uds_do_allocation(size_t count, size_t size, size_t extra,
 		total_size = SIZE_MAX;
 	}
 
-	return uds_allocate_memory(total_size, align, what, ptr);
+	return vdo_allocate_memory(total_size, align, what, ptr);
 }
 
 /*
@@ -67,8 +67,8 @@ static inline int uds_do_allocation(size_t count, size_t size, size_t extra,
  *
  * Return: UDS_SUCCESS or an error code
  */
-#define uds_allocate(COUNT, TYPE, WHAT, PTR) \
-	uds_do_allocation(COUNT, sizeof(TYPE), 0, __alignof__(TYPE), WHAT, PTR)
+#define vdo_allocate(COUNT, TYPE, WHAT, PTR) \
+	vdo_do_allocation(COUNT, sizeof(TYPE), 0, __alignof__(TYPE), WHAT, PTR)
 
 /*
  * Allocate one object of an indicated type, followed by one or more elements of a second type,
@@ -83,12 +83,12 @@ static inline int uds_do_allocation(size_t count, size_t size, size_t extra,
  *
  * Return: UDS_SUCCESS or an error code
  */
-#define uds_allocate_extended(TYPE1, COUNT, TYPE2, WHAT, PTR)            \
+#define vdo_allocate_extended(TYPE1, COUNT, TYPE2, WHAT, PTR)            \
 	__extension__({                                                  \
 		int _result;						 \
 		TYPE1 **_ptr = (PTR);                                    \
 		BUILD_BUG_ON(__alignof__(TYPE1) < __alignof__(TYPE2));   \
-		_result = uds_do_allocation(COUNT,                       \
+		_result = vdo_do_allocation(COUNT,                       \
 					    sizeof(TYPE2),               \
 					    sizeof(TYPE1),               \
 					    __alignof__(TYPE1),          \
@@ -107,9 +107,9 @@ static inline int uds_do_allocation(size_t count, size_t size, size_t extra,
  *
  * Return: UDS_SUCCESS or an error code
  */
-static inline int __must_check uds_allocate_cache_aligned(size_t size, const char *what, void *ptr)
+static inline int __must_check vdo_allocate_cache_aligned(size_t size, const char *what, void *ptr)
 {
-	return uds_allocate_memory(size, L1_CACHE_BYTES, what, ptr);
+	return vdo_allocate_memory(size, L1_CACHE_BYTES, what, ptr);
 }
 
 /*
@@ -121,18 +121,18 @@ static inline int __must_check uds_allocate_cache_aligned(size_t size, const cha
  *
  * Return: pointer to the memory, or NULL if the memory is not available.
  */
-void *__must_check uds_allocate_memory_nowait(size_t size, const char *what);
+void *__must_check vdo_allocate_memory_nowait(size_t size, const char *what);
 
-int __must_check uds_reallocate_memory(void *ptr, size_t old_size, size_t size,
+int __must_check vdo_reallocate_memory(void *ptr, size_t old_size, size_t size,
 				       const char *what, void *new_ptr);
 
-int __must_check uds_duplicate_string(const char *string, const char *what,
+int __must_check vdo_duplicate_string(const char *string, const char *what,
 				      char **new_string);
 
-/* Free memory allocated with uds_allocate(). */
-void uds_free(void *ptr);
+/* Free memory allocated with vdo_allocate(). */
+void vdo_free(void *ptr);
 
-static inline void *__uds_forget(void **ptr_ptr)
+static inline void *__vdo_forget(void **ptr_ptr)
 {
 	void *ptr = *ptr_ptr;
 
@@ -144,19 +144,19 @@ static inline void *__uds_forget(void **ptr_ptr)
  * Null out a pointer and return a copy to it. This macro should be used when passing a pointer to
  * a function for which it is not safe to access the pointer once the function returns.
  */
-#define uds_forget(ptr) __uds_forget((void **) &(ptr))
+#define vdo_forget(ptr) __vdo_forget((void **) &(ptr))
 
-void uds_memory_init(void);
+void vdo_memory_init(void);
 
-void uds_memory_exit(void);
+void vdo_memory_exit(void);
 
-void uds_register_allocating_thread(struct registered_thread *new_thread,
+void vdo_register_allocating_thread(struct registered_thread *new_thread,
 				    const bool *flag_ptr);
 
-void uds_unregister_allocating_thread(void);
+void vdo_unregister_allocating_thread(void);
 
-void uds_get_memory_stats(u64 *bytes_used, u64 *peak_bytes_used);
+void vdo_get_memory_stats(u64 *bytes_used, u64 *peak_bytes_used);
 
-void uds_report_memory_usage(void);
+void vdo_report_memory_usage(void);
 
-#endif /* UDS_MEMORY_ALLOC_H */
+#endif /* VDO_MEMORY_ALLOC_H */
diff --git a/drivers/md/dm-vdo/message-stats.c b/drivers/md/dm-vdo/message-stats.c
index cac7232f467b..ec24fff2a21b 100644
--- a/drivers/md/dm-vdo/message-stats.c
+++ b/drivers/md/dm-vdo/message-stats.c
@@ -419,7 +419,7 @@ int vdo_write_stats(struct vdo *vdo, char *buf, unsigned int maxlen)
 	struct vdo_statistics *stats;
 	int result;
 
-	result = uds_allocate(1, struct vdo_statistics, __func__, &stats);
+	result = vdo_allocate(1, struct vdo_statistics, __func__, &stats);
 	if (result != UDS_SUCCESS) {
 		uds_log_error("Cannot allocate memory to write VDO statistics");
 		return result;
@@ -427,6 +427,6 @@ int vdo_write_stats(struct vdo *vdo, char *buf, unsigned int maxlen)
 
 	vdo_fetch_statistics(vdo, stats);
 	write_vdo_statistics(NULL, stats, NULL, &buf, &maxlen);
-	uds_free(stats);
+	vdo_free(stats);
 	return VDO_SUCCESS;
 }
diff --git a/drivers/md/dm-vdo/packer.c b/drivers/md/dm-vdo/packer.c
index 3283c8d56c59..5774d8fd5c5a 100644
--- a/drivers/md/dm-vdo/packer.c
+++ b/drivers/md/dm-vdo/packer.c
@@ -120,7 +120,7 @@ static int __must_check make_bin(struct packer *packer)
 	struct packer_bin *bin;
 	int result;
 
-	result = uds_allocate_extended(struct packer_bin, VDO_MAX_COMPRESSION_SLOTS,
+	result = vdo_allocate_extended(struct packer_bin, VDO_MAX_COMPRESSION_SLOTS,
 				       struct vio *, __func__, &bin);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -146,7 +146,7 @@ int vdo_make_packer(struct vdo *vdo, block_count_t bin_count, struct packer **pa
 	block_count_t i;
 	int result;
 
-	result = uds_allocate(1, struct packer, __func__, &packer);
+	result = vdo_allocate(1, struct packer, __func__, &packer);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -168,7 +168,7 @@ int vdo_make_packer(struct vdo *vdo, block_count_t bin_count, struct packer **pa
 	 * bin must have a canceler for which it is waiting, and any canceler will only have
 	 * canceled one lock holder at a time.
 	 */
-	result = uds_allocate_extended(struct packer_bin, MAXIMUM_VDO_USER_VIOS / 2,
+	result = vdo_allocate_extended(struct packer_bin, MAXIMUM_VDO_USER_VIOS / 2,
 				       struct vio *, __func__, &packer->canceled_bin);
 	if (result != VDO_SUCCESS) {
 		vdo_free_packer(packer);
@@ -198,11 +198,11 @@ void vdo_free_packer(struct packer *packer)
 
 	list_for_each_entry_safe(bin, tmp, &packer->bins, list) {
 		list_del_init(&bin->list);
-		uds_free(bin);
+		vdo_free(bin);
 	}
 
-	uds_free(uds_forget(packer->canceled_bin));
-	uds_free(packer);
+	vdo_free(vdo_forget(packer->canceled_bin));
+	vdo_free(packer);
 }
 
 /**
@@ -669,7 +669,7 @@ void vdo_remove_lock_holder_from_packer(struct vdo_completion *completion)
 
 	assert_data_vio_in_packer_zone(data_vio);
 
-	lock_holder = uds_forget(data_vio->compression.lock_holder);
+	lock_holder = vdo_forget(data_vio->compression.lock_holder);
 	bin = lock_holder->compression.bin;
 	ASSERT_LOG_ONLY((bin != NULL), "data_vio in packer has a bin");
 
diff --git a/drivers/md/dm-vdo/physical-zone.c b/drivers/md/dm-vdo/physical-zone.c
index 62d142b28282..fadcea23288e 100644
--- a/drivers/md/dm-vdo/physical-zone.c
+++ b/drivers/md/dm-vdo/physical-zone.c
@@ -239,7 +239,7 @@ static int make_pbn_lock_pool(size_t capacity, struct pbn_lock_pool **pool_ptr)
 	struct pbn_lock_pool *pool;
 	int result;
 
-	result = uds_allocate_extended(struct pbn_lock_pool, capacity, idle_pbn_lock,
+	result = vdo_allocate_extended(struct pbn_lock_pool, capacity, idle_pbn_lock,
 				       __func__, &pool);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -270,7 +270,7 @@ static void free_pbn_lock_pool(struct pbn_lock_pool *pool)
 	ASSERT_LOG_ONLY(pool->borrowed == 0,
 			"All PBN locks must be returned to the pool before it is freed, but %zu locks are still on loan",
 			pool->borrowed);
-	uds_free(pool);
+	vdo_free(pool);
 }
 
 /**
@@ -344,7 +344,7 @@ static int initialize_zone(struct vdo *vdo, struct physical_zones *zones)
 	zone->next = &zones->zones[(zone_number + 1) % vdo->thread_config.physical_zone_count];
 	result = vdo_make_default_thread(vdo, zone->thread_id);
 	if (result != VDO_SUCCESS) {
-		free_pbn_lock_pool(uds_forget(zone->lock_pool));
+		free_pbn_lock_pool(vdo_forget(zone->lock_pool));
 		vdo_int_map_free(zone->pbn_operations);
 		return result;
 	}
@@ -367,7 +367,7 @@ int vdo_make_physical_zones(struct vdo *vdo, struct physical_zones **zones_ptr)
 	if (zone_count == 0)
 		return VDO_SUCCESS;
 
-	result = uds_allocate_extended(struct physical_zones, zone_count,
+	result = vdo_allocate_extended(struct physical_zones, zone_count,
 				       struct physical_zone, __func__, &zones);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -398,11 +398,11 @@ void vdo_free_physical_zones(struct physical_zones *zones)
 	for (index = 0; index < zones->zone_count; index++) {
 		struct physical_zone *zone = &zones->zones[index];
 
-		free_pbn_lock_pool(uds_forget(zone->lock_pool));
-		vdo_int_map_free(uds_forget(zone->pbn_operations));
+		free_pbn_lock_pool(vdo_forget(zone->lock_pool));
+		vdo_int_map_free(vdo_forget(zone->pbn_operations));
 	}
 
-	uds_free(zones);
+	vdo_free(zones);
 }
 
 /**
@@ -460,7 +460,7 @@ int vdo_attempt_physical_zone_pbn_lock(struct physical_zone *zone,
 
 	if (lock != NULL) {
 		/* The lock is already held, so we don't need the borrowed one. */
-		return_pbn_lock_to_pool(zone->lock_pool, uds_forget(new_lock));
+		return_pbn_lock_to_pool(zone->lock_pool, vdo_forget(new_lock));
 		result = ASSERT(lock->holder_count > 0, "physical block %llu lock held",
 				(unsigned long long) pbn);
 		if (result != VDO_SUCCESS)
diff --git a/drivers/md/dm-vdo/pool-sysfs.c b/drivers/md/dm-vdo/pool-sysfs.c
index f2be0f2bbd68..6769c5711cbc 100644
--- a/drivers/md/dm-vdo/pool-sysfs.c
+++ b/drivers/md/dm-vdo/pool-sysfs.c
@@ -110,7 +110,7 @@ static ssize_t pool_requests_maximum_show(struct vdo *vdo, char *buf)
 
 static void vdo_pool_release(struct kobject *directory)
 {
-	uds_free(container_of(directory, struct vdo, vdo_directory));
+	vdo_free(container_of(directory, struct vdo, vdo_directory));
 }
 
 static struct pool_attribute vdo_pool_compressing_attr = {
diff --git a/drivers/md/dm-vdo/priority-table.c b/drivers/md/dm-vdo/priority-table.c
index a59e9d40ca90..fc99268d2437 100644
--- a/drivers/md/dm-vdo/priority-table.c
+++ b/drivers/md/dm-vdo/priority-table.c
@@ -60,7 +60,7 @@ int vdo_make_priority_table(unsigned int max_priority, struct priority_table **t
 	if (max_priority > MAX_PRIORITY)
 		return UDS_INVALID_ARGUMENT;
 
-	result = uds_allocate_extended(struct priority_table, max_priority + 1,
+	result = vdo_allocate_extended(struct priority_table, max_priority + 1,
 				       struct bucket, __func__, &table);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -96,7 +96,7 @@ void vdo_free_priority_table(struct priority_table *table)
 	 */
 	vdo_reset_priority_table(table);
 
-	uds_free(table);
+	vdo_free(table);
 }
 
 /**
diff --git a/drivers/md/dm-vdo/recovery-journal.c b/drivers/md/dm-vdo/recovery-journal.c
index c1d355346bcf..615755697e60 100644
--- a/drivers/md/dm-vdo/recovery-journal.c
+++ b/drivers/md/dm-vdo/recovery-journal.c
@@ -591,31 +591,31 @@ static int __must_check initialize_lock_counter(struct recovery_journal *journal
 	struct thread_config *config = &vdo->thread_config;
 	struct lock_counter *counter = &journal->lock_counter;
 
-	result = uds_allocate(journal->size, u16, __func__, &counter->journal_counters);
+	result = vdo_allocate(journal->size, u16, __func__, &counter->journal_counters);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = uds_allocate(journal->size, atomic_t, __func__,
+	result = vdo_allocate(journal->size, atomic_t, __func__,
 			      &counter->journal_decrement_counts);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = uds_allocate(journal->size * config->logical_zone_count, u16, __func__,
+	result = vdo_allocate(journal->size * config->logical_zone_count, u16, __func__,
 			      &counter->logical_counters);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = uds_allocate(journal->size, atomic_t, __func__,
+	result = vdo_allocate(journal->size, atomic_t, __func__,
 			      &counter->logical_zone_counts);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = uds_allocate(journal->size * config->physical_zone_count, u16, __func__,
+	result = vdo_allocate(journal->size * config->physical_zone_count, u16, __func__,
 			      &counter->physical_counters);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = uds_allocate(journal->size, atomic_t, __func__,
+	result = vdo_allocate(journal->size, atomic_t, __func__,
 			      &counter->physical_zone_counts);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -670,14 +670,14 @@ static int initialize_recovery_block(struct vdo *vdo, struct recovery_journal *j
 	 * Allocate a full block for the journal block even though not all of the space is used
 	 * since the VIO needs to write a full disk block.
 	 */
-	result = uds_allocate(VDO_BLOCK_SIZE, char, __func__, &data);
+	result = vdo_allocate(VDO_BLOCK_SIZE, char, __func__, &data);
 	if (result != VDO_SUCCESS)
 		return result;
 
 	result = allocate_vio_components(vdo, VIO_TYPE_RECOVERY_JOURNAL,
 					 VIO_PRIORITY_HIGH, block, 1, data, &block->vio);
 	if (result != VDO_SUCCESS) {
-		uds_free(data);
+		vdo_free(data);
 		return result;
 	}
 
@@ -709,7 +709,7 @@ int vdo_decode_recovery_journal(struct recovery_journal_state_7_0 state, nonce_t
 	struct recovery_journal *journal;
 	int result;
 
-	result = uds_allocate_extended(struct recovery_journal,
+	result = vdo_allocate_extended(struct recovery_journal,
 				       RECOVERY_JOURNAL_RESERVED_BLOCKS,
 				       struct recovery_journal_block, __func__,
 				       &journal);
@@ -787,13 +787,13 @@ void vdo_free_recovery_journal(struct recovery_journal *journal)
 	if (journal == NULL)
 		return;
 
-	uds_free(uds_forget(journal->lock_counter.logical_zone_counts));
-	uds_free(uds_forget(journal->lock_counter.physical_zone_counts));
-	uds_free(uds_forget(journal->lock_counter.journal_counters));
-	uds_free(uds_forget(journal->lock_counter.journal_decrement_counts));
-	uds_free(uds_forget(journal->lock_counter.logical_counters));
-	uds_free(uds_forget(journal->lock_counter.physical_counters));
-	free_vio(uds_forget(journal->flush_vio));
+	vdo_free(vdo_forget(journal->lock_counter.logical_zone_counts));
+	vdo_free(vdo_forget(journal->lock_counter.physical_zone_counts));
+	vdo_free(vdo_forget(journal->lock_counter.journal_counters));
+	vdo_free(vdo_forget(journal->lock_counter.journal_decrement_counts));
+	vdo_free(vdo_forget(journal->lock_counter.logical_counters));
+	vdo_free(vdo_forget(journal->lock_counter.physical_counters));
+	free_vio(vdo_forget(journal->flush_vio));
 
 	/*
 	 * FIXME: eventually, the journal should be constructed in a quiescent state which
@@ -810,11 +810,11 @@ void vdo_free_recovery_journal(struct recovery_journal *journal)
 	for (i = 0; i < RECOVERY_JOURNAL_RESERVED_BLOCKS; i++) {
 		struct recovery_journal_block *block = &journal->blocks[i];
 
-		uds_free(uds_forget(block->vio.data));
+		vdo_free(vdo_forget(block->vio.data));
 		free_vio_components(&block->vio);
 	}
 
-	uds_free(journal);
+	vdo_free(journal);
 }
 
 /**
diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
index 847aca9fbe47..bfcdedeedb86 100644
--- a/drivers/md/dm-vdo/repair.c
+++ b/drivers/md/dm-vdo/repair.c
@@ -226,7 +226,7 @@ static void uninitialize_vios(struct repair_completion *repair)
 	while (repair->vio_count > 0)
 		free_vio_components(&repair->vios[--repair->vio_count]);
 
-	uds_free(uds_forget(repair->vios));
+	vdo_free(vdo_forget(repair->vios));
 }
 
 static void free_repair_completion(struct repair_completion *repair)
@@ -241,9 +241,9 @@ static void free_repair_completion(struct repair_completion *repair)
 	repair->completion.vdo->block_map->zones[0].page_cache.rebuilding = false;
 
 	uninitialize_vios(repair);
-	uds_free(uds_forget(repair->journal_data));
-	uds_free(uds_forget(repair->entries));
-	uds_free(repair);
+	vdo_free(vdo_forget(repair->journal_data));
+	vdo_free(vdo_forget(repair->entries));
+	vdo_free(repair);
 }
 
 static void finish_repair(struct vdo_completion *completion)
@@ -262,7 +262,7 @@ static void finish_repair(struct vdo_completion *completion)
 						    repair->highest_tail,
 						    repair->logical_blocks_used,
 						    repair->block_map_data_blocks);
-	free_repair_completion(uds_forget(repair));
+	free_repair_completion(vdo_forget(repair));
 
 	if (vdo_state_requires_read_only_rebuild(vdo->load_state)) {
 		uds_log_info("Read-only rebuild complete");
@@ -295,7 +295,7 @@ static void abort_repair(struct vdo_completion *completion)
 	else
 		uds_log_warning("Recovery aborted");
 
-	free_repair_completion(uds_forget(repair));
+	free_repair_completion(vdo_forget(repair));
 	vdo_continue_completion(parent, result);
 }
 
@@ -1108,7 +1108,7 @@ static void recover_block_map(struct vdo_completion *completion)
 
 	if (repair->block_map_entry_count == 0) {
 		uds_log_info("Replaying 0 recovery entries into block map");
-		uds_free(uds_forget(repair->journal_data));
+		vdo_free(vdo_forget(repair->journal_data));
 		launch_repair_completion(repair, load_slab_depot, VDO_ZONE_TYPE_ADMIN);
 		return;
 	}
@@ -1418,7 +1418,7 @@ static int parse_journal_for_rebuild(struct repair_completion *repair)
 	 * packed_recovery_journal_entry from every valid journal block.
 	 */
 	count = ((repair->highest_tail - repair->block_map_head + 1) * entries_per_block);
-	result = uds_allocate(count, struct numbered_block_mapping, __func__,
+	result = vdo_allocate(count, struct numbered_block_mapping, __func__,
 			      &repair->entries);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -1464,7 +1464,7 @@ static int extract_new_mappings(struct repair_completion *repair)
 	 * Allocate an array of numbered_block_mapping structs just large enough to transcribe
 	 * every packed_recovery_journal_entry from every valid journal block.
 	 */
-	result = uds_allocate(repair->entry_count, struct numbered_block_mapping,
+	result = vdo_allocate(repair->entry_count, struct numbered_block_mapping,
 			      __func__, &repair->entries);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -1709,7 +1709,7 @@ void vdo_repair(struct vdo_completion *parent)
 		uds_log_warning("Device was dirty, rebuilding reference counts");
 	}
 
-	result = uds_allocate_extended(struct repair_completion, page_count,
+	result = vdo_allocate_extended(struct repair_completion, page_count,
 				       struct vdo_page_completion, __func__,
 				       &repair);
 	if (result != VDO_SUCCESS) {
@@ -1723,12 +1723,12 @@ void vdo_repair(struct vdo_completion *parent)
 	prepare_repair_completion(repair, finish_repair, VDO_ZONE_TYPE_ADMIN);
 	repair->page_count = page_count;
 
-	result = uds_allocate(remaining * VDO_BLOCK_SIZE, char, __func__,
+	result = vdo_allocate(remaining * VDO_BLOCK_SIZE, char, __func__,
 			      &repair->journal_data);
 	if (abort_on_error(result, repair))
 		return;
 
-	result = uds_allocate(vio_count, struct vio, __func__, &repair->vios);
+	result = vdo_allocate(vio_count, struct vio, __func__, &repair->vios);
 	if (abort_on_error(result, repair))
 		return;
 
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 8c6376e79a23..2d2cccf89edb 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -415,7 +415,7 @@ static void complete_reaping(struct vdo_completion *completion)
 	struct slab_journal *journal = completion->parent;
 
 	return_vio_to_pool(journal->slab->allocator->vio_pool,
-			   vio_as_pooled_vio(as_vio(uds_forget(completion))));
+			   vio_as_pooled_vio(as_vio(vdo_forget(completion))));
 	finish_reaping(journal);
 	reap_slab_journal(journal);
 }
@@ -698,7 +698,7 @@ static void complete_write(struct vdo_completion *completion)
 	sequence_number_t committed = get_committing_sequence_number(pooled);
 
 	list_del_init(&pooled->list_entry);
-	return_vio_to_pool(journal->slab->allocator->vio_pool, uds_forget(pooled));
+	return_vio_to_pool(journal->slab->allocator->vio_pool, vdo_forget(pooled));
 
 	if (result != VDO_SUCCESS) {
 		vio_record_metadata_io_error(as_vio(completion));
@@ -777,7 +777,7 @@ static void write_slab_journal_block(struct vdo_waiter *waiter, void *context)
 	 * The slab summary update does a flush which is sufficient to protect us from corruption
 	 * due to out of order slab journal, reference block, or block map writes.
 	 */
-	vdo_submit_metadata_vio(uds_forget(vio), block_number, write_slab_journal_endio,
+	vdo_submit_metadata_vio(vdo_forget(vio), block_number, write_slab_journal_endio,
 				complete_write, REQ_OP_WRITE);
 
 	/* Since the write is submitted, the tail block structure can be reused. */
@@ -2367,7 +2367,7 @@ static int allocate_slab_counters(struct vdo_slab *slab)
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = uds_allocate(slab->reference_block_count, struct reference_block,
+	result = vdo_allocate(slab->reference_block_count, struct reference_block,
 			      __func__, &slab->reference_blocks);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -2377,10 +2377,10 @@ static int allocate_slab_counters(struct vdo_slab *slab)
 	 * so we can word-search even at the very end.
 	 */
 	bytes = (slab->reference_block_count * COUNTS_PER_BLOCK) + (2 * BYTES_PER_WORD);
-	result = uds_allocate(bytes, vdo_refcount_t, "ref counts array",
+	result = vdo_allocate(bytes, vdo_refcount_t, "ref counts array",
 			      &slab->counters);
 	if (result != UDS_SUCCESS) {
-		uds_free(uds_forget(slab->reference_blocks));
+		vdo_free(vdo_forget(slab->reference_blocks));
 		return result;
 	}
 
@@ -2658,7 +2658,7 @@ static inline bool __must_check has_slabs_to_scrub(struct slab_scrubber *scrubbe
  */
 static void uninitialize_scrubber_vio(struct slab_scrubber *scrubber)
 {
-	uds_free(uds_forget(scrubber->vio.data));
+	vdo_free(vdo_forget(scrubber->vio.data));
 	free_vio_components(&scrubber->vio);
 }
 
@@ -2679,7 +2679,7 @@ static void finish_scrubbing(struct slab_scrubber *scrubber, int result)
 
 	if (scrubber->high_priority_only) {
 		scrubber->high_priority_only = false;
-		vdo_fail_completion(uds_forget(scrubber->vio.completion.parent), result);
+		vdo_fail_completion(vdo_forget(scrubber->vio.completion.parent), result);
 	} else if (done && (atomic_add_return(-1, &allocator->depot->zones_to_scrub) == 0)) {
 		/* All of our slabs were scrubbed, and we're the last allocator to finish. */
 		enum vdo_state prior_state =
@@ -3382,7 +3382,7 @@ static void finish_loading_allocator(struct vdo_completion *completion)
 		vdo_get_admin_state_code(&allocator->state);
 
 	if (allocator->eraser != NULL)
-		dm_kcopyd_client_destroy(uds_forget(allocator->eraser));
+		dm_kcopyd_client_destroy(vdo_forget(allocator->eraser));
 
 	if (operation == VDO_ADMIN_STATE_LOADING_FOR_RECOVERY) {
 		void *context =
@@ -3485,7 +3485,7 @@ static int get_slab_statuses(struct block_allocator *allocator,
 	struct slab_status *statuses;
 	struct slab_iterator iterator = get_slab_iterator(allocator);
 
-	result = uds_allocate(allocator->slab_count, struct slab_status, __func__,
+	result = vdo_allocate(allocator->slab_count, struct slab_status, __func__,
 			      &statuses);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -3552,7 +3552,7 @@ static int __must_check vdo_prepare_slabs_for_allocation(struct block_allocator
 		register_slab_for_scrubbing(slab, high_priority);
 	}
 
-	uds_free(slab_statuses);
+	vdo_free(slab_statuses);
 	return VDO_SUCCESS;
 }
 
@@ -3648,11 +3648,11 @@ static void free_slab(struct vdo_slab *slab)
 		return;
 
 	list_del(&slab->allocq_entry);
-	uds_free(uds_forget(slab->journal.block));
-	uds_free(uds_forget(slab->journal.locks));
-	uds_free(uds_forget(slab->counters));
-	uds_free(uds_forget(slab->reference_blocks));
-	uds_free(slab);
+	vdo_free(vdo_forget(slab->journal.block));
+	vdo_free(vdo_forget(slab->journal.locks));
+	vdo_free(vdo_forget(slab->counters));
+	vdo_free(vdo_forget(slab->reference_blocks));
+	vdo_free(slab);
 }
 
 static int initialize_slab_journal(struct vdo_slab *slab)
@@ -3661,12 +3661,12 @@ static int initialize_slab_journal(struct vdo_slab *slab)
 	const struct slab_config *slab_config = &slab->allocator->depot->slab_config;
 	int result;
 
-	result = uds_allocate(slab_config->slab_journal_blocks, struct journal_lock,
+	result = vdo_allocate(slab_config->slab_journal_blocks, struct journal_lock,
 			      __func__, &journal->locks);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = uds_allocate(VDO_BLOCK_SIZE, char, "struct packed_slab_journal_block",
+	result = vdo_allocate(VDO_BLOCK_SIZE, char, "struct packed_slab_journal_block",
 			      (char **) &journal->block);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -3722,7 +3722,7 @@ static int __must_check make_slab(physical_block_number_t slab_origin,
 	struct vdo_slab *slab;
 	int result;
 
-	result = uds_allocate(1, struct vdo_slab, __func__, &slab);
+	result = vdo_allocate(1, struct vdo_slab, __func__, &slab);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -3779,7 +3779,7 @@ static int allocate_slabs(struct slab_depot *depot, slab_count_t slab_count)
 	physical_block_number_t slab_origin;
 	int result;
 
-	result = uds_allocate(slab_count, struct vdo_slab *,
+	result = vdo_allocate(slab_count, struct vdo_slab *,
 			      "slab pointer array", &depot->new_slabs);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -3821,10 +3821,10 @@ void vdo_abandon_new_slabs(struct slab_depot *depot)
 		return;
 
 	for (i = depot->slab_count; i < depot->new_slab_count; i++)
-		free_slab(uds_forget(depot->new_slabs[i]));
+		free_slab(vdo_forget(depot->new_slabs[i]));
 	depot->new_slab_count = 0;
 	depot->new_size = 0;
-	uds_free(uds_forget(depot->new_slabs));
+	vdo_free(vdo_forget(depot->new_slabs));
 }
 
 /**
@@ -3934,7 +3934,7 @@ static int initialize_slab_scrubber(struct block_allocator *allocator)
 	char *journal_data;
 	int result;
 
-	result = uds_allocate(VDO_BLOCK_SIZE * slab_journal_size,
+	result = vdo_allocate(VDO_BLOCK_SIZE * slab_journal_size,
 			      char, __func__, &journal_data);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -3945,7 +3945,7 @@ static int initialize_slab_scrubber(struct block_allocator *allocator)
 					 allocator, slab_journal_size,
 					 journal_data, &scrubber->vio);
 	if (result != VDO_SUCCESS) {
-		uds_free(journal_data);
+		vdo_free(journal_data);
 		return result;
 	}
 
@@ -3968,7 +3968,7 @@ static int __must_check initialize_slab_summary_block(struct block_allocator *al
 	struct slab_summary_block *block = &allocator->summary_blocks[index];
 	int result;
 
-	result = uds_allocate(VDO_BLOCK_SIZE, char, __func__, &block->outgoing_entries);
+	result = vdo_allocate(VDO_BLOCK_SIZE, char, __func__, &block->outgoing_entries);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -4024,7 +4024,7 @@ static int __must_check initialize_block_allocator(struct slab_depot *depot,
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = uds_allocate(VDO_SLAB_SUMMARY_BLOCKS_PER_ZONE,
+	result = vdo_allocate(VDO_SLAB_SUMMARY_BLOCKS_PER_ZONE,
 			      struct slab_summary_block, __func__,
 			      &allocator->summary_blocks);
 	if (result != VDO_SUCCESS)
@@ -4084,7 +4084,7 @@ static int allocate_components(struct slab_depot *depot,
 
 	depot->summary_origin = summary_partition->offset;
 	depot->hint_shift = vdo_get_slab_summary_hint_shift(depot->slab_size_shift);
-	result = uds_allocate(MAXIMUM_VDO_SLAB_SUMMARY_ENTRIES,
+	result = vdo_allocate(MAXIMUM_VDO_SLAB_SUMMARY_ENTRIES,
 			      struct slab_summary_entry, __func__,
 			      &depot->summary_entries);
 	if (result != VDO_SUCCESS)
@@ -4172,7 +4172,7 @@ int vdo_decode_slab_depot(struct slab_depot_state_2_0 state, struct vdo *vdo,
 	}
 	slab_size_shift = ilog2(slab_size);
 
-	result = uds_allocate_extended(struct slab_depot,
+	result = vdo_allocate_extended(struct slab_depot,
 				       vdo->thread_config.physical_zone_count,
 				       struct block_allocator, __func__, &depot);
 	if (result != VDO_SUCCESS)
@@ -4205,10 +4205,10 @@ static void uninitialize_allocator_summary(struct block_allocator *allocator)
 
 	for (i = 0; i < VDO_SLAB_SUMMARY_BLOCKS_PER_ZONE; i++) {
 		free_vio_components(&allocator->summary_blocks[i].vio);
-		uds_free(uds_forget(allocator->summary_blocks[i].outgoing_entries));
+		vdo_free(vdo_forget(allocator->summary_blocks[i].outgoing_entries));
 	}
 
-	uds_free(uds_forget(allocator->summary_blocks));
+	vdo_free(vdo_forget(allocator->summary_blocks));
 }
 
 /**
@@ -4228,25 +4228,25 @@ void vdo_free_slab_depot(struct slab_depot *depot)
 		struct block_allocator *allocator = &depot->allocators[zone];
 
 		if (allocator->eraser != NULL)
-			dm_kcopyd_client_destroy(uds_forget(allocator->eraser));
+			dm_kcopyd_client_destroy(vdo_forget(allocator->eraser));
 
 		uninitialize_allocator_summary(allocator);
 		uninitialize_scrubber_vio(&allocator->scrubber);
-		free_vio_pool(uds_forget(allocator->vio_pool));
-		vdo_free_priority_table(uds_forget(allocator->prioritized_slabs));
+		free_vio_pool(vdo_forget(allocator->vio_pool));
+		vdo_free_priority_table(vdo_forget(allocator->prioritized_slabs));
 	}
 
 	if (depot->slabs != NULL) {
 		slab_count_t i;
 
 		for (i = 0; i < depot->slab_count; i++)
-			free_slab(uds_forget(depot->slabs[i]));
+			free_slab(vdo_forget(depot->slabs[i]));
 	}
 
-	uds_free(uds_forget(depot->slabs));
-	uds_free(uds_forget(depot->action_manager));
-	uds_free(uds_forget(depot->summary_entries));
-	uds_free(depot);
+	vdo_free(vdo_forget(depot->slabs));
+	vdo_free(vdo_forget(depot->action_manager));
+	vdo_free(vdo_forget(depot->summary_entries));
+	vdo_free(depot);
 }
 
 /**
@@ -4447,7 +4447,7 @@ static void finish_combining_zones(struct vdo_completion *completion)
 	int result = completion->result;
 	struct vdo_completion *parent = completion->parent;
 
-	free_vio(as_vio(uds_forget(completion)));
+	free_vio(as_vio(vdo_forget(completion)));
 	vdo_fail_completion(parent, result);
 }
 
@@ -4708,7 +4708,7 @@ static int finish_registration(void *context)
 	struct slab_depot *depot = context;
 
 	WRITE_ONCE(depot->slab_count, depot->new_slab_count);
-	uds_free(depot->slabs);
+	vdo_free(depot->slabs);
 	depot->slabs = depot->new_slabs;
 	depot->new_slabs = NULL;
 	depot->new_slab_count = 0;
diff --git a/drivers/md/dm-vdo/slab-depot.h b/drivers/md/dm-vdo/slab-depot.h
index fba293f9713e..f234853501ca 100644
--- a/drivers/md/dm-vdo/slab-depot.h
+++ b/drivers/md/dm-vdo/slab-depot.h
@@ -241,7 +241,7 @@ struct vdo_slab {
 	/* The number of free blocks */
 	u32 free_blocks;
 	/* The array of reference counts */
-	vdo_refcount_t *counters; /* use uds_allocate() to align data ptr */
+	vdo_refcount_t *counters; /* use vdo_allocate() to align data ptr */
 
 	/* The saved block pointer and array indexes for the free block search */
 	struct search_cursor search_cursor;
diff --git a/drivers/md/dm-vdo/thread-utils.c b/drivers/md/dm-vdo/thread-utils.c
index 244abc6ad848..ad7682784459 100644
--- a/drivers/md/dm-vdo/thread-utils.c
+++ b/drivers/md/dm-vdo/thread-utils.c
@@ -66,9 +66,9 @@ static int thread_starter(void *arg)
 	mutex_lock(&thread_mutex);
 	hlist_add_head(&thread->thread_links, &thread_list);
 	mutex_unlock(&thread_mutex);
-	uds_register_allocating_thread(&allocating_thread, NULL);
+	vdo_register_allocating_thread(&allocating_thread, NULL);
 	thread->thread_function(thread->thread_data);
-	uds_unregister_allocating_thread();
+	vdo_unregister_allocating_thread();
 	complete(&thread->thread_done);
 	return 0;
 }
@@ -82,7 +82,7 @@ int vdo_create_thread(void (*thread_function)(void *), void *thread_data,
 	struct thread *thread;
 	int result;
 
-	result = uds_allocate(1, struct thread, __func__, &thread);
+	result = vdo_allocate(1, struct thread, __func__, &thread);
 	if (result != UDS_SUCCESS) {
 		uds_log_warning("Error allocating memory for %s", name);
 		return result;
@@ -114,7 +114,7 @@ int vdo_create_thread(void (*thread_function)(void *), void *thread_data,
 	}
 
 	if (IS_ERR(task)) {
-		uds_free(thread);
+		vdo_free(thread);
 		return PTR_ERR(task);
 	}
 
@@ -130,5 +130,5 @@ void vdo_join_threads(struct thread *thread)
 	mutex_lock(&thread_mutex);
 	hlist_del(&thread->thread_links);
 	mutex_unlock(&thread_mutex);
-	uds_free(thread);
+	vdo_free(thread);
 }
diff --git a/drivers/md/dm-vdo/uds-sysfs.c b/drivers/md/dm-vdo/uds-sysfs.c
index 2c4fb277ba38..d1d5a30b3717 100644
--- a/drivers/md/dm-vdo/uds-sysfs.c
+++ b/drivers/md/dm-vdo/uds-sysfs.c
@@ -35,7 +35,7 @@ static char *buffer_to_string(const char *buf, size_t length)
 {
 	char *string;
 
-	if (uds_allocate(length + 1, char, __func__, &string) != UDS_SUCCESS)
+	if (vdo_allocate(length + 1, char, __func__, &string) != UDS_SUCCESS)
 		return NULL;
 
 	memcpy(string, buf, length);
@@ -118,7 +118,7 @@ static ssize_t parameter_store(struct kobject *kobj, struct attribute *attr,
 		return -ENOMEM;
 
 	pa->store_string(string);
-	uds_free(string);
+	vdo_free(string);
 	return length;
 }
 
diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index 6baf319d79c6..ae62f260c5ec 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -134,13 +134,13 @@ static void start_vdo_request_queue(void *ptr)
 {
 	struct vdo_thread *thread = vdo_get_work_queue_owner(vdo_get_current_work_queue());
 
-	uds_register_allocating_thread(&thread->allocating_thread,
+	vdo_register_allocating_thread(&thread->allocating_thread,
 				       &thread->vdo->allocations_allowed);
 }
 
 static void finish_vdo_request_queue(void *ptr)
 {
-	uds_unregister_allocating_thread();
+	vdo_unregister_allocating_thread();
 }
 
 #ifdef MODULE
@@ -172,10 +172,10 @@ static const struct vdo_work_queue_type cpu_q_type = {
 
 static void uninitialize_thread_config(struct thread_config *config)
 {
-	uds_free(uds_forget(config->logical_threads));
-	uds_free(uds_forget(config->physical_threads));
-	uds_free(uds_forget(config->hash_zone_threads));
-	uds_free(uds_forget(config->bio_threads));
+	vdo_free(vdo_forget(config->logical_threads));
+	vdo_free(vdo_forget(config->physical_threads));
+	vdo_free(vdo_forget(config->hash_zone_threads));
+	vdo_free(vdo_forget(config->bio_threads));
 	memset(config, 0, sizeof(struct thread_config));
 }
 
@@ -214,28 +214,28 @@ static int __must_check initialize_thread_config(struct thread_count_config coun
 		config->hash_zone_count = counts.hash_zones;
 	}
 
-	result = uds_allocate(config->logical_zone_count, thread_id_t,
+	result = vdo_allocate(config->logical_zone_count, thread_id_t,
 			      "logical thread array", &config->logical_threads);
 	if (result != VDO_SUCCESS) {
 		uninitialize_thread_config(config);
 		return result;
 	}
 
-	result = uds_allocate(config->physical_zone_count, thread_id_t,
+	result = vdo_allocate(config->physical_zone_count, thread_id_t,
 			      "physical thread array", &config->physical_threads);
 	if (result != VDO_SUCCESS) {
 		uninitialize_thread_config(config);
 		return result;
 	}
 
-	result = uds_allocate(config->hash_zone_count, thread_id_t,
+	result = vdo_allocate(config->hash_zone_count, thread_id_t,
 			      "hash thread array", &config->hash_zone_threads);
 	if (result != VDO_SUCCESS) {
 		uninitialize_thread_config(config);
 		return result;
 	}
 
-	result = uds_allocate(config->bio_thread_count, thread_id_t,
+	result = vdo_allocate(config->bio_thread_count, thread_id_t,
 			      "bio thread array", &config->bio_threads);
 	if (result != VDO_SUCCESS) {
 		uninitialize_thread_config(config);
@@ -276,14 +276,14 @@ static int __must_check read_geometry_block(struct vdo *vdo)
 	char *block;
 	int result;
 
-	result = uds_allocate(VDO_BLOCK_SIZE, u8, __func__, &block);
+	result = vdo_allocate(VDO_BLOCK_SIZE, u8, __func__, &block);
 	if (result != VDO_SUCCESS)
 		return result;
 
 	result = create_metadata_vio(vdo, VIO_TYPE_GEOMETRY, VIO_PRIORITY_HIGH, NULL,
 				     block, &vio);
 	if (result != VDO_SUCCESS) {
-		uds_free(block);
+		vdo_free(block);
 		return result;
 	}
 
@@ -295,23 +295,23 @@ static int __must_check read_geometry_block(struct vdo *vdo)
 	result = vio_reset_bio(vio, block, NULL, REQ_OP_READ,
 			       VDO_GEOMETRY_BLOCK_LOCATION);
 	if (result != VDO_SUCCESS) {
-		free_vio(uds_forget(vio));
-		uds_free(block);
+		free_vio(vdo_forget(vio));
+		vdo_free(block);
 		return result;
 	}
 
 	bio_set_dev(vio->bio, vdo_get_backing_device(vdo));
 	submit_bio_wait(vio->bio);
 	result = blk_status_to_errno(vio->bio->bi_status);
-	free_vio(uds_forget(vio));
+	free_vio(vdo_forget(vio));
 	if (result != 0) {
 		uds_log_error_strerror(result, "synchronous read failed");
-		uds_free(block);
+		vdo_free(block);
 		return -EIO;
 	}
 
 	result = vdo_parse_geometry_block((u8 *) block, &vdo->geometry);
-	uds_free(block);
+	vdo_free(block);
 	return result;
 }
 
@@ -500,7 +500,7 @@ static int initialize_vdo(struct vdo *vdo, struct device_config *config,
 		     config->thread_counts.hash_zones, vdo->thread_config.thread_count);
 
 	/* Compression context storage */
-	result = uds_allocate(config->thread_counts.cpu_threads, char *, "LZ4 context",
+	result = vdo_allocate(config->thread_counts.cpu_threads, char *, "LZ4 context",
 			      &vdo->compression_context);
 	if (result != VDO_SUCCESS) {
 		*reason = "cannot allocate LZ4 context";
@@ -508,7 +508,7 @@ static int initialize_vdo(struct vdo *vdo, struct device_config *config,
 	}
 
 	for (i = 0; i < config->thread_counts.cpu_threads; i++) {
-		result = uds_allocate(LZ4_MEM_COMPRESS, char, "LZ4 context",
+		result = vdo_allocate(LZ4_MEM_COMPRESS, char, "LZ4 context",
 				      &vdo->compression_context[i]);
 		if (result != VDO_SUCCESS) {
 			*reason = "cannot allocate LZ4 context";
@@ -544,7 +544,7 @@ int vdo_make(unsigned int instance, struct device_config *config, char **reason,
 	/* Initialize with a generic failure reason to prevent returning garbage. */
 	*reason = "Unspecified error";
 
-	result = uds_allocate(1, struct vdo, __func__, &vdo);
+	result = vdo_allocate(1, struct vdo, __func__, &vdo);
 	if (result != UDS_SUCCESS) {
 		*reason = "Cannot allocate VDO";
 		return result;
@@ -562,7 +562,7 @@ int vdo_make(unsigned int instance, struct device_config *config, char **reason,
 	snprintf(vdo->thread_name_prefix, sizeof(vdo->thread_name_prefix),
 		 "%s%u", MODULE_NAME, instance);
 	BUG_ON(vdo->thread_name_prefix[0] == '\0');
-	result = uds_allocate(vdo->thread_config.thread_count,
+	result = vdo_allocate(vdo->thread_config.thread_count,
 			      struct vdo_thread, __func__, &vdo->threads);
 	if (result != VDO_SUCCESS) {
 		*reason = "Cannot allocate thread structures";
@@ -650,16 +650,16 @@ static void free_listeners(struct vdo_thread *thread)
 {
 	struct read_only_listener *listener, *next;
 
-	for (listener = uds_forget(thread->listeners); listener != NULL; listener = next) {
-		next = uds_forget(listener->next);
-		uds_free(listener);
+	for (listener = vdo_forget(thread->listeners); listener != NULL; listener = next) {
+		next = vdo_forget(listener->next);
+		vdo_free(listener);
 	}
 }
 
 static void uninitialize_super_block(struct vdo_super_block *super_block)
 {
 	free_vio_components(&super_block->vio);
-	uds_free(super_block->buffer);
+	vdo_free(super_block->buffer);
 }
 
 /**
@@ -701,36 +701,36 @@ void vdo_destroy(struct vdo *vdo)
 	finish_vdo(vdo);
 	unregister_vdo(vdo);
 	free_data_vio_pool(vdo->data_vio_pool);
-	vdo_free_io_submitter(uds_forget(vdo->io_submitter));
-	vdo_free_flusher(uds_forget(vdo->flusher));
-	vdo_free_packer(uds_forget(vdo->packer));
-	vdo_free_recovery_journal(uds_forget(vdo->recovery_journal));
-	vdo_free_slab_depot(uds_forget(vdo->depot));
+	vdo_free_io_submitter(vdo_forget(vdo->io_submitter));
+	vdo_free_flusher(vdo_forget(vdo->flusher));
+	vdo_free_packer(vdo_forget(vdo->packer));
+	vdo_free_recovery_journal(vdo_forget(vdo->recovery_journal));
+	vdo_free_slab_depot(vdo_forget(vdo->depot));
 	vdo_uninitialize_layout(&vdo->layout);
 	vdo_uninitialize_layout(&vdo->next_layout);
 	if (vdo->partition_copier)
-		dm_kcopyd_client_destroy(uds_forget(vdo->partition_copier));
+		dm_kcopyd_client_destroy(vdo_forget(vdo->partition_copier));
 	uninitialize_super_block(&vdo->super_block);
-	vdo_free_block_map(uds_forget(vdo->block_map));
-	vdo_free_hash_zones(uds_forget(vdo->hash_zones));
-	vdo_free_physical_zones(uds_forget(vdo->physical_zones));
-	vdo_free_logical_zones(uds_forget(vdo->logical_zones));
+	vdo_free_block_map(vdo_forget(vdo->block_map));
+	vdo_free_hash_zones(vdo_forget(vdo->hash_zones));
+	vdo_free_physical_zones(vdo_forget(vdo->physical_zones));
+	vdo_free_logical_zones(vdo_forget(vdo->logical_zones));
 
 	if (vdo->threads != NULL) {
 		for (i = 0; i < vdo->thread_config.thread_count; i++) {
 			free_listeners(&vdo->threads[i]);
-			vdo_free_work_queue(uds_forget(vdo->threads[i].queue));
+			vdo_free_work_queue(vdo_forget(vdo->threads[i].queue));
 		}
-		uds_free(uds_forget(vdo->threads));
+		vdo_free(vdo_forget(vdo->threads));
 	}
 
 	uninitialize_thread_config(&vdo->thread_config);
 
 	if (vdo->compression_context != NULL) {
 		for (i = 0; i < vdo->device_config->thread_counts.cpu_threads; i++)
-			uds_free(uds_forget(vdo->compression_context[i]));
+			vdo_free(vdo_forget(vdo->compression_context[i]));
 
-		uds_free(uds_forget(vdo->compression_context));
+		vdo_free(vdo_forget(vdo->compression_context));
 	}
 
 	/*
@@ -738,7 +738,7 @@ void vdo_destroy(struct vdo *vdo)
 	 * the count goes to zero the VDO object will be freed as a side effect.
 	 */
 	if (!vdo->sysfs_added)
-		uds_free(vdo);
+		vdo_free(vdo);
 	else
 		kobject_put(&vdo->vdo_directory);
 }
@@ -747,7 +747,7 @@ static int initialize_super_block(struct vdo *vdo, struct vdo_super_block *super
 {
 	int result;
 
-	result = uds_allocate(VDO_BLOCK_SIZE, char, "encoded super block",
+	result = vdo_allocate(VDO_BLOCK_SIZE, char, "encoded super block",
 			      (char **) &vdo->super_block.buffer);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -769,7 +769,7 @@ static void finish_reading_super_block(struct vdo_completion *completion)
 	struct vdo_super_block *super_block =
 		container_of(as_vio(completion), struct vdo_super_block, vio);
 
-	vdo_continue_completion(uds_forget(completion->parent),
+	vdo_continue_completion(vdo_forget(completion->parent),
 				vdo_decode_super_block(super_block->buffer));
 }
 
@@ -965,7 +965,7 @@ static void record_vdo(struct vdo *vdo)
  */
 static void continue_super_block_parent(struct vdo_completion *completion)
 {
-	vdo_continue_completion(uds_forget(completion->parent), completion->result);
+	vdo_continue_completion(vdo_forget(completion->parent), completion->result);
 }
 
 /**
@@ -1055,7 +1055,7 @@ int vdo_register_read_only_listener(struct vdo *vdo, void *listener,
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = uds_allocate(1, struct read_only_listener, __func__,
+	result = vdo_allocate(1, struct read_only_listener, __func__,
 			      &read_only_listener);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -1184,7 +1184,7 @@ static void finish_entering_read_only_mode(struct vdo_completion *completion)
 	spin_unlock(&notifier->lock);
 
 	if (notifier->waiter != NULL)
-		vdo_continue_completion(uds_forget(notifier->waiter),
+		vdo_continue_completion(vdo_forget(notifier->waiter),
 					completion->result);
 }
 
@@ -1621,7 +1621,7 @@ static void get_vdo_statistics(const struct vdo *vdo, struct vdo_statistics *sta
 	copy_bio_stat(&stats->bios_acknowledged_partial, &vdo->stats.bios_acknowledged_partial);
 	stats->bios_in_progress =
 		subtract_bio_stats(stats->bios_in, stats->bios_acknowledged);
-	uds_get_memory_stats(&stats->memory_usage.bytes_used,
+	vdo_get_memory_stats(&stats->memory_usage.bytes_used,
 			     &stats->memory_usage.peak_bytes_used);
 }
 
diff --git a/drivers/md/dm-vdo/vio.c b/drivers/md/dm-vdo/vio.c
index 4832ea46551f..83c36f7590de 100644
--- a/drivers/md/dm-vdo/vio.c
+++ b/drivers/md/dm-vdo/vio.c
@@ -52,7 +52,7 @@ static int create_multi_block_bio(block_count_t size, struct bio **bio_ptr)
 	struct bio *bio = NULL;
 	int result;
 
-	result = uds_allocate_extended(struct bio, size + 1, struct bio_vec,
+	result = vdo_allocate_extended(struct bio, size + 1, struct bio_vec,
 				       "bio", &bio);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -72,7 +72,7 @@ void vdo_free_bio(struct bio *bio)
 		return;
 
 	bio_uninit(bio);
-	uds_free(uds_forget(bio));
+	vdo_free(vdo_forget(bio));
 }
 
 int allocate_vio_components(struct vdo *vdo, enum vio_type vio_type,
@@ -129,7 +129,7 @@ int create_multi_block_metadata_vio(struct vdo *vdo, enum vio_type vio_type,
 	 * Metadata vios should use direct allocation and not use the buffer pool, which is
 	 * reserved for submissions from the linux block layer.
 	 */
-	result = uds_allocate(1, struct vio, __func__, &vio);
+	result = vdo_allocate(1, struct vio, __func__, &vio);
 	if (result != VDO_SUCCESS) {
 		uds_log_error("metadata vio allocation failure %d", result);
 		return result;
@@ -138,7 +138,7 @@ int create_multi_block_metadata_vio(struct vdo *vdo, enum vio_type vio_type,
 	result = allocate_vio_components(vdo, vio_type, priority, parent, block_count,
 					 data, vio);
 	if (result != VDO_SUCCESS) {
-		uds_free(vio);
+		vdo_free(vio);
 		return result;
 	}
 
@@ -156,7 +156,7 @@ void free_vio_components(struct vio *vio)
 		return;
 
 	BUG_ON(is_data_vio(vio));
-	vdo_free_bio(uds_forget(vio->bio));
+	vdo_free_bio(vdo_forget(vio->bio));
 }
 
 /**
@@ -166,7 +166,7 @@ void free_vio_components(struct vio *vio)
 void free_vio(struct vio *vio)
 {
 	free_vio_components(vio);
-	uds_free(vio);
+	vdo_free(vio);
 }
 
 /* Set bio properties for a VDO read or write. */
@@ -316,7 +316,7 @@ int make_vio_pool(struct vdo *vdo, size_t pool_size, thread_id_t thread_id,
 	char *ptr;
 	int result;
 
-	result = uds_allocate_extended(struct vio_pool, pool_size, struct pooled_vio,
+	result = vdo_allocate_extended(struct vio_pool, pool_size, struct pooled_vio,
 				       __func__, &pool);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -325,7 +325,7 @@ int make_vio_pool(struct vdo *vdo, size_t pool_size, thread_id_t thread_id,
 	INIT_LIST_HEAD(&pool->available);
 	INIT_LIST_HEAD(&pool->busy);
 
-	result = uds_allocate(pool_size * VDO_BLOCK_SIZE, char,
+	result = vdo_allocate(pool_size * VDO_BLOCK_SIZE, char,
 			      "VIO pool buffer", &pool->buffer);
 	if (result != VDO_SUCCESS) {
 		free_vio_pool(pool);
@@ -380,8 +380,8 @@ void free_vio_pool(struct vio_pool *pool)
 	ASSERT_LOG_ONLY(pool->size == 0,
 			"VIO pool must not have missing entries when being freed");
 
-	uds_free(uds_forget(pool->buffer));
-	uds_free(pool);
+	vdo_free(vdo_forget(pool->buffer));
+	vdo_free(pool);
 }
 
 /**
-- 
2.42.0

