Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF956FB6
	for <dm-devel@lists.linux.dev>; Sat, 11 Nov 2023 04:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KzKftcXK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699677047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Unk8jvuNnzl+IuPQW5NWw2n6y9TP67EYh+hW8l5MY8=;
	b=KzKftcXKKRx5mYZ/eJ2hsHpl7RdcEt8aTopTmmpQuT9DGHmL7Om6nYgxkqFAPCAyPpTzB9
	BZn3O3QT6xKHPz97J7wKCyDn1XOvGwd+CuvVpOa3gE3vTnMM6+oWFjFx+szJQ/YvV0Zu78
	g0ta4hwALBJ91J+jARUTVnRgRJiF6Y0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-673-C7S70OesOoCjYJ5G7inVWw-1; Fri,
 10 Nov 2023 23:30:46 -0500
X-MC-Unique: C7S70OesOoCjYJ5G7inVWw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB6671C0518D;
	Sat, 11 Nov 2023 04:30:45 +0000 (UTC)
Received: from pbitcolo-build-10.permabit.com (pbitcolo-build-10.permabit.lab.eng.bos.redhat.com [10.19.117.76])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9854940C6EB9;
	Sat, 11 Nov 2023 04:30:45 +0000 (UTC)
Received: by pbitcolo-build-10.permabit.com (Postfix, from userid 1138)
	id 59ADA3003E; Fri, 10 Nov 2023 23:30:45 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 2/8] dm vdo memory-alloc: rename UDS_FORGET to uds_forget
Date: Fri, 10 Nov 2023 23:30:38 -0500
Message-Id: <012a8b4e61a16b54295e39636bbcd24d7e509109.1699675570.git.msakai@redhat.com>
In-Reply-To: <ccd28d21aede15fc56f1ff25b3582ddad5260883.1699675570.git.msakai@redhat.com>
References: <ccd28d21aede15fc56f1ff25b3582ddad5260883.1699675570.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

From: Mike Snitzer <snitzer@kernel.org>

Reviewed-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo-target.c           | 12 +++----
 drivers/md/dm-vdo/admin-state.c      |  2 +-
 drivers/md/dm-vdo/block-map.c        | 26 +++++++--------
 drivers/md/dm-vdo/data-vio.c         | 14 ++++----
 drivers/md/dm-vdo/dedupe.c           | 20 +++++------
 drivers/md/dm-vdo/delta-index.c      |  6 ++--
 drivers/md/dm-vdo/flush.c            |  2 +-
 drivers/md/dm-vdo/funnel-workqueue.c |  2 +-
 drivers/md/dm-vdo/index.c            |  4 +--
 drivers/md/dm-vdo/int-map.c          | 10 +++---
 drivers/md/dm-vdo/io-factory.c       |  2 +-
 drivers/md/dm-vdo/io-submitter.c     |  6 ++--
 drivers/md/dm-vdo/logical-zone.c     |  4 +--
 drivers/md/dm-vdo/memory-alloc.h     |  4 +--
 drivers/md/dm-vdo/packer.c           |  4 +--
 drivers/md/dm-vdo/physical-zone.c    |  8 ++---
 drivers/md/dm-vdo/pointer-map.c      | 10 +++---
 drivers/md/dm-vdo/recovery-journal.c | 16 ++++-----
 drivers/md/dm-vdo/repair.c           | 12 +++----
 drivers/md/dm-vdo/slab-depot.c       | 46 ++++++++++++-------------
 drivers/md/dm-vdo/sparse-cache.c     |  2 +-
 drivers/md/dm-vdo/vdo.c              | 50 ++++++++++++++--------------
 drivers/md/dm-vdo/vio.c              |  6 ++--
 drivers/md/dm-vdo/volume-index.c     |  6 ++--
 drivers/md/dm-vdo/volume.c           |  6 ++--
 25 files changed, 140 insertions(+), 140 deletions(-)

diff --git a/drivers/md/dm-vdo-target.c b/drivers/md/dm-vdo-target.c
index 4415e9bd31b4..e54fc3a92fc0 100644
--- a/drivers/md/dm-vdo-target.c
+++ b/drivers/md/dm-vdo-target.c
@@ -1723,7 +1723,7 @@ static int grow_layout(struct vdo *vdo, block_count_t old_size, block_count_t ne
 							  VDO_SLAB_SUMMARY_PARTITION),
 				       &vdo->next_layout);
 	if (result != VDO_SUCCESS) {
-		dm_kcopyd_client_destroy(UDS_FORGET(vdo->partition_copier));
+		dm_kcopyd_client_destroy(uds_forget(vdo->partition_copier));
 		return result;
 	}
 
@@ -1734,7 +1734,7 @@ static int grow_layout(struct vdo *vdo, block_count_t old_size, block_count_t ne
 	if (min_new_size > new_size) {
 		/* Copying the journal and summary would destroy some old metadata. */
 		vdo_uninitialize_layout(&vdo->next_layout);
-		dm_kcopyd_client_destroy(UDS_FORGET(vdo->partition_copier));
+		dm_kcopyd_client_destroy(uds_forget(vdo->partition_copier));
 		return VDO_INCREMENT_TOO_SMALL;
 	}
 
@@ -1941,7 +1941,7 @@ static int vdo_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 static void vdo_dtr(struct dm_target *ti)
 {
 	struct device_config *config = ti->private;
-	struct vdo *vdo = UDS_FORGET(config->vdo);
+	struct vdo *vdo = uds_forget(config->vdo);
 
 	list_del_init(&config->config_list);
 	if (list_empty(&vdo->device_config_list)) {
@@ -1959,7 +1959,7 @@ static void vdo_dtr(struct dm_target *ti)
 		if (vdo->dump_on_shutdown)
 			vdo_dump_all(vdo, "device shutdown");
 
-		vdo_destroy(UDS_FORGET(vdo));
+		vdo_destroy(uds_forget(vdo));
 		uds_log_info("device '%s' stopped", device_name);
 		uds_unregister_thread_device_id();
 		uds_unregister_allocating_thread();
@@ -2346,7 +2346,7 @@ static void handle_load_error(struct vdo_completion *completion)
 	    (vdo->admin.phase == LOAD_PHASE_MAKE_DIRTY)) {
 		uds_log_error_strerror(completion->result, "aborting load");
 		vdo->admin.phase = LOAD_PHASE_DRAIN_JOURNAL;
-		load_callback(UDS_FORGET(completion));
+		load_callback(uds_forget(completion));
 		return;
 	}
 
@@ -2659,7 +2659,7 @@ static void grow_physical_callback(struct vdo_completion *completion)
 	case GROW_PHYSICAL_PHASE_UPDATE_COMPONENTS:
 		vdo_uninitialize_layout(&vdo->layout);
 		vdo->layout = vdo->next_layout;
-		UDS_FORGET(vdo->next_layout.head);
+		uds_forget(vdo->next_layout.head);
 		vdo->states.vdo.config.physical_blocks = vdo->layout.size;
 		vdo_update_slab_depot_size(vdo->depot);
 		vdo_save_components(vdo, completion);
diff --git a/drivers/md/dm-vdo/admin-state.c b/drivers/md/dm-vdo/admin-state.c
index e2ba354508b2..90ed1330e2b7 100644
--- a/drivers/md/dm-vdo/admin-state.c
+++ b/drivers/md/dm-vdo/admin-state.c
@@ -204,7 +204,7 @@ bool vdo_finish_operation(struct admin_state *state, int result)
 	if (!state->starting) {
 		vdo_set_admin_state_code(state, state->next_state);
 		if (state->waiter != NULL)
-			vdo_launch_completion(UDS_FORGET(state->waiter));
+			vdo_launch_completion(uds_forget(state->waiter));
 	}
 
 	return true;
diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index e163c45ef4d5..ad03109db716 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -1341,7 +1341,7 @@ int vdo_invalidate_page_cache(struct vdo_page_cache *cache)
 	}
 
 	/* Reset the page map by re-allocating it. */
-	vdo_free_int_map(UDS_FORGET(cache->page_map));
+	vdo_free_int_map(uds_forget(cache->page_map));
 	return vdo_make_int_map(cache->page_count, 0, &cache->page_map);
 }
 
@@ -2508,7 +2508,7 @@ static void replace_forest(struct block_map *map)
 	if (map->next_forest != NULL) {
 		if (map->forest != NULL)
 			deforest(map->forest, map->forest->segments);
-		map->forest = UDS_FORGET(map->next_forest);
+		map->forest = uds_forget(map->next_forest);
 	}
 
 	map->entry_count = map->next_entry_count;
@@ -2524,7 +2524,7 @@ static void finish_cursor(struct cursor *cursor)
 	struct cursors *cursors = cursor->parent;
 	struct vdo_completion *parent = cursors->parent;
 
-	return_vio_to_pool(cursors->pool, UDS_FORGET(cursor->vio));
+	return_vio_to_pool(cursors->pool, uds_forget(cursor->vio));
 	if (--cursors->active_roots > 0)
 		return;
 
@@ -2863,19 +2863,19 @@ static void uninitialize_block_map_zone(struct block_map_zone *zone)
 {
 	struct vdo_page_cache *cache = &zone->page_cache;
 
-	UDS_FREE(UDS_FORGET(zone->dirty_lists));
-	free_vio_pool(UDS_FORGET(zone->vio_pool));
-	vdo_free_int_map(UDS_FORGET(zone->loading_pages));
+	UDS_FREE(uds_forget(zone->dirty_lists));
+	free_vio_pool(uds_forget(zone->vio_pool));
+	vdo_free_int_map(uds_forget(zone->loading_pages));
 	if (cache->infos != NULL) {
 		struct page_info *info;
 
 		for (info = cache->infos; info < cache->infos + cache->page_count; ++info)
-			free_vio(UDS_FORGET(info->vio));
+			free_vio(uds_forget(info->vio));
 	}
 
-	vdo_free_int_map(UDS_FORGET(cache->page_map));
-	UDS_FREE(UDS_FORGET(cache->infos));
-	UDS_FREE(UDS_FORGET(cache->pages));
+	vdo_free_int_map(uds_forget(cache->page_map));
+	UDS_FREE(uds_forget(cache->infos));
+	UDS_FREE(uds_forget(cache->pages));
 }
 
 void vdo_free_block_map(struct block_map *map)
@@ -2890,8 +2890,8 @@ void vdo_free_block_map(struct block_map *map)
 
 	vdo_abandon_block_map_growth(map);
 	if (map->forest != NULL)
-		deforest(UDS_FORGET(map->forest), 0);
-	UDS_FREE(UDS_FORGET(map->action_manager));
+		deforest(uds_forget(map->forest), 0);
+	UDS_FREE(uds_forget(map->action_manager));
 	UDS_FREE(map);
 }
 
@@ -3108,7 +3108,7 @@ void vdo_grow_block_map(struct block_map *map, struct vdo_completion *parent)
 
 void vdo_abandon_block_map_growth(struct block_map *map)
 {
-	struct forest *forest = UDS_FORGET(map->next_forest);
+	struct forest *forest = uds_forget(map->next_forest);
 
 	if (forest != NULL)
 		deforest(forest, forest->segments - 1);
diff --git a/drivers/md/dm-vdo/data-vio.c b/drivers/md/dm-vdo/data-vio.c
index 700f945669dd..7b10926131a9 100644
--- a/drivers/md/dm-vdo/data-vio.c
+++ b/drivers/md/dm-vdo/data-vio.c
@@ -822,10 +822,10 @@ static void destroy_data_vio(struct data_vio *data_vio)
 	if (data_vio == NULL)
 		return;
 
-	vdo_free_bio(UDS_FORGET(data_vio->vio.bio));
-	UDS_FREE(UDS_FORGET(data_vio->vio.data));
-	UDS_FREE(UDS_FORGET(data_vio->compression.block));
-	UDS_FREE(UDS_FORGET(data_vio->scratch_block));
+	vdo_free_bio(uds_forget(data_vio->vio.bio));
+	UDS_FREE(uds_forget(data_vio->vio.data));
+	UDS_FREE(uds_forget(data_vio->compression.block));
+	UDS_FREE(uds_forget(data_vio->scratch_block));
 }
 
 /**
@@ -869,7 +869,7 @@ int make_data_vio_pool(struct vdo *vdo,
 
 	result = uds_make_funnel_queue(&pool->queue);
 	if (result != UDS_SUCCESS) {
-		free_data_vio_pool(UDS_FORGET(pool));
+		free_data_vio_pool(uds_forget(pool));
 		return result;
 	}
 
@@ -926,7 +926,7 @@ void free_data_vio_pool(struct data_vio_pool *pool)
 		destroy_data_vio(data_vio);
 	}
 
-	uds_free_funnel_queue(UDS_FORGET(pool->queue));
+	uds_free_funnel_queue(uds_forget(pool->queue));
 	UDS_FREE(pool);
 }
 
@@ -1425,7 +1425,7 @@ void release_data_vio_allocation_lock(struct data_vio *data_vio, bool reset)
 
 	vdo_release_physical_zone_pbn_lock(allocation->zone,
 					   locked_pbn,
-					   UDS_FORGET(allocation->lock));
+					   uds_forget(allocation->lock));
 }
 
 /**
diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index f230ab64a39c..daaeeb29ad0f 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -686,7 +686,7 @@ static void unlock_duplicate_pbn(struct vdo_completion *completion)
 
 	vdo_release_physical_zone_pbn_lock(agent->duplicate.zone,
 					   agent->duplicate.pbn,
-					   UDS_FORGET(lock->duplicate_lock));
+					   uds_forget(lock->duplicate_lock));
 	if (lock->state == VDO_HASH_LOCK_BYPASSING) {
 		complete_data_vio(completion);
 		return;
@@ -883,7 +883,7 @@ static int __must_check acquire_lock(struct hash_zone *zone,
 				     (replace_lock != NULL),
 				     (void **) &lock);
 	if (result != VDO_SUCCESS) {
-		return_hash_lock_to_pool(zone, UDS_FORGET(new_lock));
+		return_hash_lock_to_pool(zone, uds_forget(new_lock));
 		return result;
 	}
 
@@ -901,7 +901,7 @@ static int __must_check acquire_lock(struct hash_zone *zone,
 		lock->registered = true;
 	} else {
 		/* There's already a lock for the hash, so we don't need the borrowed lock. */
-		return_hash_lock_to_pool(zone, UDS_FORGET(new_lock));
+		return_hash_lock_to_pool(zone, uds_forget(new_lock));
 	}
 
 	*lock_ptr = lock;
@@ -1956,7 +1956,7 @@ static void transfer_allocation_lock(struct data_vio *data_vio)
 	 * Since the lock is being transferred, the holder count doesn't change (and isn't even
 	 * safe to examine on this thread).
 	 */
-	hash_lock->duplicate_lock = UDS_FORGET(allocation->lock);
+	hash_lock->duplicate_lock = uds_forget(allocation->lock);
 }
 
 /**
@@ -2247,7 +2247,7 @@ static int initialize_index(struct vdo *vdo, struct hash_zones *zones)
 
 	result = vdo_make_thread(vdo, vdo->thread_config.dedupe_thread, &uds_queue_type, 1, NULL);
 	if (result != VDO_SUCCESS) {
-		uds_destroy_index_session(UDS_FORGET(zones->index_session));
+		uds_destroy_index_session(uds_forget(zones->index_session));
 		uds_log_error("UDS index queue initialization failed (%d)", result);
 		return result;
 	}
@@ -2509,7 +2509,7 @@ void vdo_finish_dedupe_index(struct hash_zones *zones)
 	if (zones == NULL)
 		return;
 
-	uds_destroy_index_session(UDS_FORGET(zones->index_session));
+	uds_destroy_index_session(uds_forget(zones->index_session));
 }
 
 /**
@@ -2523,14 +2523,14 @@ void vdo_free_hash_zones(struct hash_zones *zones)
 	if (zones == NULL)
 		return;
 
-	UDS_FREE(UDS_FORGET(zones->manager));
+	UDS_FREE(uds_forget(zones->manager));
 
 	for (i = 0; i < zones->zone_count; i++) {
 		struct hash_zone *zone = &zones->zones[i];
 
-		uds_free_funnel_queue(UDS_FORGET(zone->timed_out_complete));
-		vdo_free_pointer_map(UDS_FORGET(zone->hash_lock_map));
-		UDS_FREE(UDS_FORGET(zone->lock_array));
+		uds_free_funnel_queue(uds_forget(zone->timed_out_complete));
+		vdo_free_pointer_map(uds_forget(zone->hash_lock_map));
+		UDS_FREE(uds_forget(zone->lock_array));
 	}
 
 	if (zones->index_session != NULL)
diff --git a/drivers/md/dm-vdo/delta-index.c b/drivers/md/dm-vdo/delta-index.c
index 2cdcd9d4ea27..a16e81f41c2e 100644
--- a/drivers/md/dm-vdo/delta-index.c
+++ b/drivers/md/dm-vdo/delta-index.c
@@ -310,9 +310,9 @@ void uds_uninitialize_delta_index(struct delta_index *delta_index)
 		return;
 
 	for (z = 0; z < delta_index->zone_count; z++) {
-		UDS_FREE(UDS_FORGET(delta_index->delta_zones[z].new_offsets));
-		UDS_FREE(UDS_FORGET(delta_index->delta_zones[z].delta_lists));
-		UDS_FREE(UDS_FORGET(delta_index->delta_zones[z].memory));
+		UDS_FREE(uds_forget(delta_index->delta_zones[z].new_offsets));
+		UDS_FREE(uds_forget(delta_index->delta_zones[z].delta_lists));
+		UDS_FREE(uds_forget(delta_index->delta_zones[z].memory));
 	}
 
 	UDS_FREE(delta_index->delta_zones);
diff --git a/drivers/md/dm-vdo/flush.c b/drivers/md/dm-vdo/flush.c
index f5b96f9f76ab..7de201886f55 100644
--- a/drivers/md/dm-vdo/flush.c
+++ b/drivers/md/dm-vdo/flush.c
@@ -161,7 +161,7 @@ void vdo_free_flusher(struct flusher *flusher)
 		return;
 
 	if (flusher->flush_pool != NULL)
-		mempool_destroy(UDS_FORGET(flusher->flush_pool));
+		mempool_destroy(uds_forget(flusher->flush_pool));
 	UDS_FREE(flusher);
 }
 
diff --git a/drivers/md/dm-vdo/funnel-workqueue.c b/drivers/md/dm-vdo/funnel-workqueue.c
index 119f813ea4cb..d3b94a8b7b4e 100644
--- a/drivers/md/dm-vdo/funnel-workqueue.c
+++ b/drivers/md/dm-vdo/funnel-workqueue.c
@@ -453,7 +453,7 @@ int vdo_make_work_queue(const char *thread_name_prefix,
 		if (result != VDO_SUCCESS) {
 			queue->num_service_queues = i;
 			/* Destroy previously created subordinates. */
-			vdo_free_work_queue(UDS_FORGET(*queue_ptr));
+			vdo_free_work_queue(uds_forget(*queue_ptr));
 			return result;
 		}
 	}
diff --git a/drivers/md/dm-vdo/index.c b/drivers/md/dm-vdo/index.c
index 89ed4c0251f2..e118755c5f60 100644
--- a/drivers/md/dm-vdo/index.c
+++ b/drivers/md/dm-vdo/index.c
@@ -623,7 +623,7 @@ static void execute_zone_request(struct uds_request *request)
 					       request->zone_message.type);
 
 		/* Once the message is processed it can be freed. */
-		UDS_FREE(UDS_FORGET(request));
+		UDS_FREE(uds_forget(request));
 		return;
 	}
 
@@ -1308,7 +1308,7 @@ void uds_free_index(struct uds_index *index)
 	}
 
 	uds_free_volume(index->volume);
-	uds_free_index_layout(UDS_FORGET(index->layout));
+	uds_free_index_layout(uds_forget(index->layout));
 	UDS_FREE(index);
 }
 
diff --git a/drivers/md/dm-vdo/int-map.c b/drivers/md/dm-vdo/int-map.c
index 6676f39c758c..86fa5abdb6fe 100644
--- a/drivers/md/dm-vdo/int-map.c
+++ b/drivers/md/dm-vdo/int-map.c
@@ -207,7 +207,7 @@ int vdo_make_int_map(size_t initial_capacity, unsigned int initial_load, struct
 
 	result = allocate_buckets(map, capacity);
 	if (result != UDS_SUCCESS) {
-		vdo_free_int_map(UDS_FORGET(map));
+		vdo_free_int_map(uds_forget(map));
 		return result;
 	}
 
@@ -227,8 +227,8 @@ void vdo_free_int_map(struct int_map *map)
 	if (map == NULL)
 		return;
 
-	UDS_FREE(UDS_FORGET(map->buckets));
-	UDS_FREE(UDS_FORGET(map));
+	UDS_FREE(uds_forget(map->buckets));
+	UDS_FREE(uds_forget(map));
 }
 
 /**
@@ -408,14 +408,14 @@ static int resize_buckets(struct int_map *map)
 		result = vdo_int_map_put(map, entry->key, entry->value, true, NULL);
 		if (result != UDS_SUCCESS) {
 			/* Destroy the new partial map and restore the map from the stack. */
-			UDS_FREE(UDS_FORGET(map->buckets));
+			UDS_FREE(uds_forget(map->buckets));
 			*map = old_map;
 			return result;
 		}
 	}
 
 	/* Destroy the old bucket array. */
-	UDS_FREE(UDS_FORGET(old_map.buckets));
+	UDS_FREE(uds_forget(old_map.buckets));
 	return UDS_SUCCESS;
 }
 
diff --git a/drivers/md/dm-vdo/io-factory.c b/drivers/md/dm-vdo/io-factory.c
index 9e99d0043fd8..69708eb87786 100644
--- a/drivers/md/dm-vdo/io-factory.c
+++ b/drivers/md/dm-vdo/io-factory.c
@@ -186,7 +186,7 @@ static int position_reader(struct buffered_reader *reader, sector_t block_number
 			return UDS_OUT_OF_RANGE;
 
 		if (reader->buffer != NULL)
-			dm_bufio_release(UDS_FORGET(reader->buffer));
+			dm_bufio_release(uds_forget(reader->buffer));
 
 		data = dm_bufio_read(reader->client, block_number, &buffer);
 		if (IS_ERR(data))
diff --git a/drivers/md/dm-vdo/io-submitter.c b/drivers/md/dm-vdo/io-submitter.c
index 995c8c7c908d..8f1c5380e729 100644
--- a/drivers/md/dm-vdo/io-submitter.c
+++ b/drivers/md/dm-vdo/io-submitter.c
@@ -428,7 +428,7 @@ int vdo_make_io_submitter(unsigned int thread_count,
 			 * Clean up the partially initialized bio-queue entirely and indicate that
 			 * initialization failed.
 			 */
-			vdo_free_int_map(UDS_FORGET(bio_queue_data->map));
+			vdo_free_int_map(uds_forget(bio_queue_data->map));
 			uds_log_error("bio queue initialization failed %d", result);
 			vdo_cleanup_io_submitter(io_submitter);
 			vdo_free_io_submitter(io_submitter);
@@ -476,8 +476,8 @@ void vdo_free_io_submitter(struct io_submitter *io_submitter)
 	for (i = io_submitter->num_bio_queues_used - 1; i >= 0; i--) {
 		io_submitter->num_bio_queues_used--;
 		/* vdo_destroy() will free the work queue, so just give up our reference to it. */
-		UDS_FORGET(io_submitter->bio_queue_data[i].queue);
-		vdo_free_int_map(UDS_FORGET(io_submitter->bio_queue_data[i].map));
+		uds_forget(io_submitter->bio_queue_data[i].queue);
+		vdo_free_int_map(uds_forget(io_submitter->bio_queue_data[i].map));
 	}
 	UDS_FREE(io_submitter);
 }
diff --git a/drivers/md/dm-vdo/logical-zone.c b/drivers/md/dm-vdo/logical-zone.c
index 1cb2b39c64ed..9c924368e027 100644
--- a/drivers/md/dm-vdo/logical-zone.c
+++ b/drivers/md/dm-vdo/logical-zone.c
@@ -137,10 +137,10 @@ void vdo_free_logical_zones(struct logical_zones *zones)
 	if (zones == NULL)
 		return;
 
-	UDS_FREE(UDS_FORGET(zones->manager));
+	UDS_FREE(uds_forget(zones->manager));
 
 	for (index = 0; index < zones->zone_count; index++)
-		vdo_free_int_map(UDS_FORGET(zones->zones[index].lbn_operations));
+		vdo_free_int_map(uds_forget(zones->zones[index].lbn_operations));
 
 	UDS_FREE(zones);
 }
diff --git a/drivers/md/dm-vdo/memory-alloc.h b/drivers/md/dm-vdo/memory-alloc.h
index d6bf5e3dae2a..251816897081 100644
--- a/drivers/md/dm-vdo/memory-alloc.h
+++ b/drivers/md/dm-vdo/memory-alloc.h
@@ -21,7 +21,7 @@ void uds_free_memory(void *ptr);
 /* Free memory allocated with UDS_ALLOCATE(). */
 #define UDS_FREE(PTR) uds_free_memory(PTR)
 
-static inline void *uds_forget(void **ptr_ptr)
+static inline void *__uds_forget(void **ptr_ptr)
 {
 	void *ptr = *ptr_ptr;
 
@@ -33,7 +33,7 @@ static inline void *uds_forget(void **ptr_ptr)
  * Null out a pointer and return a copy to it. This macro should be used when passing a pointer to
  * a function for which it is not safe to access the pointer once the function returns.
  */
-#define UDS_FORGET(ptr) uds_forget((void **) &(ptr))
+#define uds_forget(ptr) __uds_forget((void **) &(ptr))
 
 /*
  * Allocate storage based on element counts, sizes, and alignment.
diff --git a/drivers/md/dm-vdo/packer.c b/drivers/md/dm-vdo/packer.c
index 40757e62eec1..7641318b3007 100644
--- a/drivers/md/dm-vdo/packer.c
+++ b/drivers/md/dm-vdo/packer.c
@@ -209,7 +209,7 @@ void vdo_free_packer(struct packer *packer)
 		UDS_FREE(bin);
 	}
 
-	UDS_FREE(UDS_FORGET(packer->canceled_bin));
+	UDS_FREE(uds_forget(packer->canceled_bin));
 	UDS_FREE(packer);
 }
 
@@ -683,7 +683,7 @@ void vdo_remove_lock_holder_from_packer(struct vdo_completion *completion)
 
 	assert_data_vio_in_packer_zone(data_vio);
 
-	lock_holder = UDS_FORGET(data_vio->compression.lock_holder);
+	lock_holder = uds_forget(data_vio->compression.lock_holder);
 	bin = lock_holder->compression.bin;
 	ASSERT_LOG_ONLY((bin != NULL), "data_vio in packer has a bin");
 
diff --git a/drivers/md/dm-vdo/physical-zone.c b/drivers/md/dm-vdo/physical-zone.c
index 822da4e8f579..08c1c7a1b366 100644
--- a/drivers/md/dm-vdo/physical-zone.c
+++ b/drivers/md/dm-vdo/physical-zone.c
@@ -349,7 +349,7 @@ static int initialize_zone(struct vdo *vdo, struct physical_zones *zones)
 	zone->next = &zones->zones[(zone_number + 1) % vdo->thread_config.physical_zone_count];
 	result = vdo_make_default_thread(vdo, zone->thread_id);
 	if (result != VDO_SUCCESS) {
-		free_pbn_lock_pool(UDS_FORGET(zone->lock_pool));
+		free_pbn_lock_pool(uds_forget(zone->lock_pool));
 		vdo_free_int_map(zone->pbn_operations);
 		return result;
 	}
@@ -406,8 +406,8 @@ void vdo_free_physical_zones(struct physical_zones *zones)
 	for (index = 0; index < zones->zone_count; index++) {
 		struct physical_zone *zone = &zones->zones[index];
 
-		free_pbn_lock_pool(UDS_FORGET(zone->lock_pool));
-		vdo_free_int_map(UDS_FORGET(zone->pbn_operations));
+		free_pbn_lock_pool(uds_forget(zone->lock_pool));
+		vdo_free_int_map(uds_forget(zone->pbn_operations));
 	}
 
 	UDS_FREE(zones);
@@ -467,7 +467,7 @@ int vdo_attempt_physical_zone_pbn_lock(struct physical_zone *zone,
 
 	if (lock != NULL) {
 		/* The lock is already held, so we don't need the borrowed one. */
-		return_pbn_lock_to_pool(zone->lock_pool, UDS_FORGET(new_lock));
+		return_pbn_lock_to_pool(zone->lock_pool, uds_forget(new_lock));
 		result = ASSERT(lock->holder_count > 0,
 				"physical block %llu lock held",
 				(unsigned long long) pbn);
diff --git a/drivers/md/dm-vdo/pointer-map.c b/drivers/md/dm-vdo/pointer-map.c
index a5a0acc7fd73..1b22c42b5d5d 100644
--- a/drivers/md/dm-vdo/pointer-map.c
+++ b/drivers/md/dm-vdo/pointer-map.c
@@ -177,7 +177,7 @@ int vdo_make_pointer_map(size_t initial_capacity,
 
 	result = allocate_buckets(map, capacity);
 	if (result != UDS_SUCCESS) {
-		vdo_free_pointer_map(UDS_FORGET(map));
+		vdo_free_pointer_map(uds_forget(map));
 		return result;
 	}
 
@@ -197,8 +197,8 @@ void vdo_free_pointer_map(struct pointer_map *map)
 	if (map == NULL)
 		return;
 
-	UDS_FREE(UDS_FORGET(map->buckets));
-	UDS_FREE(UDS_FORGET(map));
+	UDS_FREE(uds_forget(map->buckets));
+	UDS_FREE(uds_forget(map));
 }
 
 /**
@@ -369,14 +369,14 @@ static int resize_buckets(struct pointer_map *map)
 		result = vdo_pointer_map_put(map, entry->key, entry->value, true, NULL);
 		if (result != UDS_SUCCESS) {
 			/* Destroy the new partial map and restore the map from the stack. */
-			UDS_FREE(UDS_FORGET(map->buckets));
+			UDS_FREE(uds_forget(map->buckets));
 			*map = old_map;
 			return result;
 		}
 	}
 
 	/* Destroy the old bucket array. */
-	UDS_FREE(UDS_FORGET(old_map.buckets));
+	UDS_FREE(uds_forget(old_map.buckets));
 	return UDS_SUCCESS;
 }
 
diff --git a/drivers/md/dm-vdo/recovery-journal.c b/drivers/md/dm-vdo/recovery-journal.c
index 7ebb4827d39c..02fc4cb812f4 100644
--- a/drivers/md/dm-vdo/recovery-journal.c
+++ b/drivers/md/dm-vdo/recovery-journal.c
@@ -808,13 +808,13 @@ void vdo_free_recovery_journal(struct recovery_journal *journal)
 	if (journal == NULL)
 		return;
 
-	UDS_FREE(UDS_FORGET(journal->lock_counter.logical_zone_counts));
-	UDS_FREE(UDS_FORGET(journal->lock_counter.physical_zone_counts));
-	UDS_FREE(UDS_FORGET(journal->lock_counter.journal_counters));
-	UDS_FREE(UDS_FORGET(journal->lock_counter.journal_decrement_counts));
-	UDS_FREE(UDS_FORGET(journal->lock_counter.logical_counters));
-	UDS_FREE(UDS_FORGET(journal->lock_counter.physical_counters));
-	free_vio(UDS_FORGET(journal->flush_vio));
+	UDS_FREE(uds_forget(journal->lock_counter.logical_zone_counts));
+	UDS_FREE(uds_forget(journal->lock_counter.physical_zone_counts));
+	UDS_FREE(uds_forget(journal->lock_counter.journal_counters));
+	UDS_FREE(uds_forget(journal->lock_counter.journal_decrement_counts));
+	UDS_FREE(uds_forget(journal->lock_counter.logical_counters));
+	UDS_FREE(uds_forget(journal->lock_counter.physical_counters));
+	free_vio(uds_forget(journal->flush_vio));
 
 	/*
 	 * FIXME: eventually, the journal should be constructed in a quiescent state which
@@ -829,7 +829,7 @@ void vdo_free_recovery_journal(struct recovery_journal *journal)
 	for (i = 0; i < RECOVERY_JOURNAL_RESERVED_BLOCKS; i++) {
 		struct recovery_journal_block *block = &journal->blocks[i];
 
-		UDS_FREE(UDS_FORGET(block->vio.data));
+		UDS_FREE(uds_forget(block->vio.data));
 		free_vio_components(&block->vio);
 	}
 
diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
index 3f4aa570befc..c3e9a67986db 100644
--- a/drivers/md/dm-vdo/repair.c
+++ b/drivers/md/dm-vdo/repair.c
@@ -229,7 +229,7 @@ static void uninitialize_vios(struct repair_completion *repair)
 	while (repair->vio_count > 0)
 		free_vio_components(&repair->vios[--repair->vio_count]);
 
-	UDS_FREE(UDS_FORGET(repair->vios));
+	UDS_FREE(uds_forget(repair->vios));
 }
 
 static void free_repair_completion(struct repair_completion *repair)
@@ -244,8 +244,8 @@ static void free_repair_completion(struct repair_completion *repair)
 	repair->completion.vdo->block_map->zones[0].page_cache.rebuilding = false;
 
 	uninitialize_vios(repair);
-	UDS_FREE(UDS_FORGET(repair->journal_data));
-	UDS_FREE(UDS_FORGET(repair->entries));
+	UDS_FREE(uds_forget(repair->journal_data));
+	UDS_FREE(uds_forget(repair->entries));
 	UDS_FREE(repair);
 }
 
@@ -265,7 +265,7 @@ static void finish_repair(struct vdo_completion *completion)
 						    repair->highest_tail,
 						    repair->logical_blocks_used,
 						    repair->block_map_data_blocks);
-	free_repair_completion(UDS_FORGET(repair));
+	free_repair_completion(uds_forget(repair));
 
 	if (vdo_state_requires_read_only_rebuild(vdo->load_state)) {
 		uds_log_info("Read-only rebuild complete");
@@ -298,7 +298,7 @@ static void abort_repair(struct vdo_completion *completion)
 	else
 		uds_log_warning("Recovery aborted");
 
-	free_repair_completion(UDS_FORGET(repair));
+	free_repair_completion(uds_forget(repair));
 	vdo_continue_completion(parent, result);
 }
 
@@ -1120,7 +1120,7 @@ static void recover_block_map(struct vdo_completion *completion)
 
 	if (repair->block_map_entry_count == 0) {
 		uds_log_info("Replaying 0 recovery entries into block map");
-		UDS_FREE(UDS_FORGET(repair->journal_data));
+		UDS_FREE(uds_forget(repair->journal_data));
 		launch_repair_completion(repair, load_slab_depot, VDO_ZONE_TYPE_ADMIN);
 		return;
 	}
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 638529d38865..b38b0ce4b35d 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -416,7 +416,7 @@ static void complete_reaping(struct vdo_completion *completion)
 	struct slab_journal *journal = completion->parent;
 
 	return_vio_to_pool(journal->slab->allocator->vio_pool,
-			   vio_as_pooled_vio(as_vio(UDS_FORGET(completion))));
+			   vio_as_pooled_vio(as_vio(uds_forget(completion))));
 	finish_reaping(journal);
 	reap_slab_journal(journal);
 }
@@ -698,7 +698,7 @@ static void complete_write(struct vdo_completion *completion)
 	sequence_number_t committed = get_committing_sequence_number(pooled);
 
 	list_del_init(&pooled->list_entry);
-	return_vio_to_pool(journal->slab->allocator->vio_pool, UDS_FORGET(pooled));
+	return_vio_to_pool(journal->slab->allocator->vio_pool, uds_forget(pooled));
 
 	if (result != VDO_SUCCESS) {
 		vio_record_metadata_io_error(as_vio(completion));
@@ -777,7 +777,7 @@ static void write_slab_journal_block(struct waiter *waiter, void *context)
 	 * This block won't be read in recovery until the slab summary is updated to refer to it.
 	 * The slab summary update does a flush which is sufficient to protect us from VDO-2331.
 	 */
-	submit_metadata_vio(UDS_FORGET(vio),
+	submit_metadata_vio(uds_forget(vio),
 			    block_number,
 			    write_slab_journal_endio,
 			    complete_write,
@@ -2439,7 +2439,7 @@ static int allocate_slab_counters(struct vdo_slab *slab)
 	bytes = (slab->reference_block_count * COUNTS_PER_BLOCK) + (2 * BYTES_PER_WORD);
 	result = UDS_ALLOCATE(bytes, vdo_refcount_t, "ref counts array", &slab->counters);
 	if (result != UDS_SUCCESS) {
-		UDS_FREE(UDS_FORGET(slab->reference_blocks));
+		UDS_FREE(uds_forget(slab->reference_blocks));
 		return result;
 	}
 
@@ -2715,7 +2715,7 @@ static bool __must_check has_slabs_to_scrub(struct slab_scrubber *scrubber)
  */
 static void uninitialize_scrubber_vio(struct slab_scrubber *scrubber)
 {
-	UDS_FREE(UDS_FORGET(scrubber->vio.data));
+	UDS_FREE(uds_forget(scrubber->vio.data));
 	free_vio_components(&scrubber->vio);
 }
 
@@ -2736,7 +2736,7 @@ static void finish_scrubbing(struct slab_scrubber *scrubber, int result)
 
 	if (scrubber->high_priority_only) {
 		scrubber->high_priority_only = false;
-		vdo_fail_completion(UDS_FORGET(scrubber->vio.completion.parent), result);
+		vdo_fail_completion(uds_forget(scrubber->vio.completion.parent), result);
 	} else if (done && (atomic_add_return(-1, &allocator->depot->zones_to_scrub) == 0)) {
 		/* All of our slabs were scrubbed, and we're the last allocator to finish. */
 		enum vdo_state prior_state =
@@ -3449,7 +3449,7 @@ static void finish_loading_allocator(struct vdo_completion *completion)
 	const struct admin_state_code *operation = vdo_get_admin_state_code(&allocator->state);
 
 	if (allocator->eraser != NULL)
-		dm_kcopyd_client_destroy(UDS_FORGET(allocator->eraser));
+		dm_kcopyd_client_destroy(uds_forget(allocator->eraser));
 
 	if (operation == VDO_ADMIN_STATE_LOADING_FOR_RECOVERY) {
 		void *context = vdo_get_current_action_context(allocator->depot->action_manager);
@@ -3713,10 +3713,10 @@ static void free_slab(struct vdo_slab *slab)
 		return;
 
 	list_del(&slab->allocq_entry);
-	UDS_FREE(UDS_FORGET(slab->journal.block));
-	UDS_FREE(UDS_FORGET(slab->journal.locks));
-	UDS_FREE(UDS_FORGET(slab->counters));
-	UDS_FREE(UDS_FORGET(slab->reference_blocks));
+	UDS_FREE(uds_forget(slab->journal.block));
+	UDS_FREE(uds_forget(slab->journal.locks));
+	UDS_FREE(uds_forget(slab->counters));
+	UDS_FREE(uds_forget(slab->reference_blocks));
 	UDS_FREE(slab);
 }
 
@@ -3897,10 +3897,10 @@ void vdo_abandon_new_slabs(struct slab_depot *depot)
 		return;
 
 	for (i = depot->slab_count; i < depot->new_slab_count; i++)
-		free_slab(UDS_FORGET(depot->new_slabs[i]));
+		free_slab(uds_forget(depot->new_slabs[i]));
 	depot->new_slab_count = 0;
 	depot->new_size = 0;
-	UDS_FREE(UDS_FORGET(depot->new_slabs));
+	UDS_FREE(uds_forget(depot->new_slabs));
 }
 
 /**
@@ -4299,10 +4299,10 @@ static void uninitialize_allocator_summary(struct block_allocator *allocator)
 
 	for (i = 0; i < VDO_SLAB_SUMMARY_BLOCKS_PER_ZONE; i++) {
 		free_vio_components(&allocator->summary_blocks[i].vio);
-		UDS_FREE(UDS_FORGET(allocator->summary_blocks[i].outgoing_entries));
+		UDS_FREE(uds_forget(allocator->summary_blocks[i].outgoing_entries));
 	}
 
-	UDS_FREE(UDS_FORGET(allocator->summary_blocks));
+	UDS_FREE(uds_forget(allocator->summary_blocks));
 }
 
 /**
@@ -4322,24 +4322,24 @@ void vdo_free_slab_depot(struct slab_depot *depot)
 		struct block_allocator *allocator = &depot->allocators[zone];
 
 		if (allocator->eraser != NULL)
-			dm_kcopyd_client_destroy(UDS_FORGET(allocator->eraser));
+			dm_kcopyd_client_destroy(uds_forget(allocator->eraser));
 
 		uninitialize_allocator_summary(allocator);
 		uninitialize_scrubber_vio(&allocator->scrubber);
-		free_vio_pool(UDS_FORGET(allocator->vio_pool));
-		vdo_free_priority_table(UDS_FORGET(allocator->prioritized_slabs));
+		free_vio_pool(uds_forget(allocator->vio_pool));
+		vdo_free_priority_table(uds_forget(allocator->prioritized_slabs));
 	}
 
 	if (depot->slabs != NULL) {
 		slab_count_t i;
 
 		for (i = 0; i < depot->slab_count; i++)
-			free_slab(UDS_FORGET(depot->slabs[i]));
+			free_slab(uds_forget(depot->slabs[i]));
 	}
 
-	UDS_FREE(UDS_FORGET(depot->slabs));
-	UDS_FREE(UDS_FORGET(depot->action_manager));
-	UDS_FREE(UDS_FORGET(depot->summary_entries));
+	UDS_FREE(uds_forget(depot->slabs));
+	UDS_FREE(uds_forget(depot->action_manager));
+	UDS_FREE(uds_forget(depot->summary_entries));
 	UDS_FREE(depot);
 }
 
@@ -4537,7 +4537,7 @@ static void finish_combining_zones(struct vdo_completion *completion)
 	int result = completion->result;
 	struct vdo_completion *parent = completion->parent;
 
-	free_vio(as_vio(UDS_FORGET(completion)));
+	free_vio(as_vio(uds_forget(completion)));
 	vdo_fail_completion(parent, result);
 }
 
diff --git a/drivers/md/dm-vdo/sparse-cache.c b/drivers/md/dm-vdo/sparse-cache.c
index b13aaa61e3f6..d4ae28b89b5b 100644
--- a/drivers/md/dm-vdo/sparse-cache.c
+++ b/drivers/md/dm-vdo/sparse-cache.c
@@ -298,7 +298,7 @@ static void release_cached_chapter_index(struct cached_chapter_index *chapter)
 
 	for (i = 0; i < chapter->index_pages_count; i++)
 		if (chapter->page_buffers[i] != NULL)
-			dm_bufio_release(UDS_FORGET(chapter->page_buffers[i]));
+			dm_bufio_release(uds_forget(chapter->page_buffers[i]));
 }
 
 void uds_free_sparse_cache(struct sparse_cache *cache)
diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index 5089a53516f8..3d3909172ba1 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -173,10 +173,10 @@ static const struct vdo_work_queue_type cpu_q_type = {
 
 static void uninitialize_thread_config(struct thread_config *config)
 {
-	UDS_FREE(UDS_FORGET(config->logical_threads));
-	UDS_FREE(UDS_FORGET(config->physical_threads));
-	UDS_FREE(UDS_FORGET(config->hash_zone_threads));
-	UDS_FREE(UDS_FORGET(config->bio_threads));
+	UDS_FREE(uds_forget(config->logical_threads));
+	UDS_FREE(uds_forget(config->physical_threads));
+	UDS_FREE(uds_forget(config->hash_zone_threads));
+	UDS_FREE(uds_forget(config->bio_threads));
 	memset(config, 0, sizeof(struct thread_config));
 }
 
@@ -302,7 +302,7 @@ static int __must_check read_geometry_block(struct vdo *vdo)
 	 */
 	result = vio_reset_bio(vio, block, NULL, REQ_OP_READ, VDO_GEOMETRY_BLOCK_LOCATION);
 	if (result != VDO_SUCCESS) {
-		free_vio(UDS_FORGET(vio));
+		free_vio(uds_forget(vio));
 		UDS_FREE(block);
 		return result;
 	}
@@ -310,7 +310,7 @@ static int __must_check read_geometry_block(struct vdo *vdo)
 	bio_set_dev(vio->bio, vdo_get_backing_device(vdo));
 	submit_bio_wait(vio->bio);
 	result = blk_status_to_errno(vio->bio->bi_status);
-	free_vio(UDS_FORGET(vio));
+	free_vio(uds_forget(vio));
 	if (result != 0) {
 		uds_log_error_strerror(result, "synchronous read failed");
 		UDS_FREE(block);
@@ -701,8 +701,8 @@ static void free_listeners(struct vdo_thread *thread)
 {
 	struct read_only_listener *listener, *next;
 
-	for (listener = UDS_FORGET(thread->listeners); listener != NULL; listener = next) {
-		next = UDS_FORGET(listener->next);
+	for (listener = uds_forget(thread->listeners); listener != NULL; listener = next) {
+		next = uds_forget(listener->next);
 		UDS_FREE(listener);
 	}
 }
@@ -752,36 +752,36 @@ void vdo_destroy(struct vdo *vdo)
 	finish_vdo(vdo);
 	unregister_vdo(vdo);
 	free_data_vio_pool(vdo->data_vio_pool);
-	vdo_free_io_submitter(UDS_FORGET(vdo->io_submitter));
-	vdo_free_flusher(UDS_FORGET(vdo->flusher));
-	vdo_free_packer(UDS_FORGET(vdo->packer));
-	vdo_free_recovery_journal(UDS_FORGET(vdo->recovery_journal));
-	vdo_free_slab_depot(UDS_FORGET(vdo->depot));
+	vdo_free_io_submitter(uds_forget(vdo->io_submitter));
+	vdo_free_flusher(uds_forget(vdo->flusher));
+	vdo_free_packer(uds_forget(vdo->packer));
+	vdo_free_recovery_journal(uds_forget(vdo->recovery_journal));
+	vdo_free_slab_depot(uds_forget(vdo->depot));
 	vdo_uninitialize_layout(&vdo->layout);
 	vdo_uninitialize_layout(&vdo->next_layout);
 	if (vdo->partition_copier)
-		dm_kcopyd_client_destroy(UDS_FORGET(vdo->partition_copier));
+		dm_kcopyd_client_destroy(uds_forget(vdo->partition_copier));
 	uninitialize_super_block(&vdo->super_block);
-	vdo_free_block_map(UDS_FORGET(vdo->block_map));
-	vdo_free_hash_zones(UDS_FORGET(vdo->hash_zones));
-	vdo_free_physical_zones(UDS_FORGET(vdo->physical_zones));
-	vdo_free_logical_zones(UDS_FORGET(vdo->logical_zones));
+	vdo_free_block_map(uds_forget(vdo->block_map));
+	vdo_free_hash_zones(uds_forget(vdo->hash_zones));
+	vdo_free_physical_zones(uds_forget(vdo->physical_zones));
+	vdo_free_logical_zones(uds_forget(vdo->logical_zones));
 
 	if (vdo->threads != NULL) {
 		for (i = 0; i < vdo->thread_config.thread_count; i++) {
 			free_listeners(&vdo->threads[i]);
-			vdo_free_work_queue(UDS_FORGET(vdo->threads[i].queue));
+			vdo_free_work_queue(uds_forget(vdo->threads[i].queue));
 		}
-		UDS_FREE(UDS_FORGET(vdo->threads));
+		UDS_FREE(uds_forget(vdo->threads));
 	}
 
 	uninitialize_thread_config(&vdo->thread_config);
 
 	if (vdo->compression_context != NULL) {
 		for (i = 0; i < vdo->device_config->thread_counts.cpu_threads; i++)
-			UDS_FREE(UDS_FORGET(vdo->compression_context[i]));
+			UDS_FREE(uds_forget(vdo->compression_context[i]));
 
-		UDS_FREE(UDS_FORGET(vdo->compression_context));
+		UDS_FREE(uds_forget(vdo->compression_context));
 	}
 
 	/*
@@ -825,7 +825,7 @@ static void finish_reading_super_block(struct vdo_completion *completion)
 	struct vdo_super_block *super_block =
 		container_of(as_vio(completion), struct vdo_super_block, vio);
 
-	vdo_continue_completion(UDS_FORGET(completion->parent),
+	vdo_continue_completion(uds_forget(completion->parent),
 				vdo_decode_super_block(super_block->buffer));
 }
 
@@ -1020,7 +1020,7 @@ static void record_vdo(struct vdo *vdo)
  */
 static void continue_super_block_parent(struct vdo_completion *completion)
 {
-	vdo_continue_completion(UDS_FORGET(completion->parent), completion->result);
+	vdo_continue_completion(uds_forget(completion->parent), completion->result);
 }
 
 /**
@@ -1240,7 +1240,7 @@ static void finish_entering_read_only_mode(struct vdo_completion *completion)
 	spin_unlock(&notifier->lock);
 
 	if (notifier->waiter != NULL)
-		vdo_continue_completion(UDS_FORGET(notifier->waiter), completion->result);
+		vdo_continue_completion(uds_forget(notifier->waiter), completion->result);
 }
 
 /**
diff --git a/drivers/md/dm-vdo/vio.c b/drivers/md/dm-vdo/vio.c
index 3d20ee87b562..7fe9b2fbd105 100644
--- a/drivers/md/dm-vdo/vio.c
+++ b/drivers/md/dm-vdo/vio.c
@@ -71,7 +71,7 @@ void vdo_free_bio(struct bio *bio)
 		return;
 
 	bio_uninit(bio);
-	UDS_FREE(UDS_FORGET(bio));
+	UDS_FREE(uds_forget(bio));
 }
 
 int allocate_vio_components(struct vdo *vdo,
@@ -164,7 +164,7 @@ void free_vio_components(struct vio *vio)
 		return;
 
 	BUG_ON(is_data_vio(vio));
-	vdo_free_bio(UDS_FORGET(vio->bio));
+	vdo_free_bio(uds_forget(vio->bio));
 }
 
 /**
@@ -405,7 +405,7 @@ void free_vio_pool(struct vio_pool *pool)
 	ASSERT_LOG_ONLY(pool->size == 0,
 			"VIO pool must not have missing entries when being freed");
 
-	UDS_FREE(UDS_FORGET(pool->buffer));
+	UDS_FREE(uds_forget(pool->buffer));
 	UDS_FREE(pool);
 }
 
diff --git a/drivers/md/dm-vdo/volume-index.c b/drivers/md/dm-vdo/volume-index.c
index 0c91a2765449..ce1dfe4deeca 100644
--- a/drivers/md/dm-vdo/volume-index.c
+++ b/drivers/md/dm-vdo/volume-index.c
@@ -272,8 +272,8 @@ static int compute_volume_sub_index_parameters(const struct configuration *confi
 
 static void uninitialize_volume_sub_index(struct volume_sub_index *sub_index)
 {
-	UDS_FREE(UDS_FORGET(sub_index->flush_chapters));
-	UDS_FREE(UDS_FORGET(sub_index->zones));
+	UDS_FREE(uds_forget(sub_index->flush_chapters));
+	UDS_FREE(uds_forget(sub_index->zones));
 	uds_uninitialize_delta_index(&sub_index->delta_index);
 }
 
@@ -287,7 +287,7 @@ void uds_free_volume_index(struct volume_index *volume_index)
 
 		for (zone = 0; zone < volume_index->zone_count; zone++)
 			uds_destroy_mutex(&volume_index->zones[zone].hook_mutex);
-		UDS_FREE(UDS_FORGET(volume_index->zones));
+		UDS_FREE(uds_forget(volume_index->zones));
 	}
 
 	uninitialize_volume_sub_index(&volume_index->vi_non_hook);
diff --git a/drivers/md/dm-vdo/volume.c b/drivers/md/dm-vdo/volume.c
index 3eb36166c73c..55cf1f68481d 100644
--- a/drivers/md/dm-vdo/volume.c
+++ b/drivers/md/dm-vdo/volume.c
@@ -197,7 +197,7 @@ static void wait_for_pending_searches(struct page_cache *cache, u32 physical_pag
 static void release_page_buffer(struct cached_page *page)
 {
 	if (page->buffer != NULL)
-		dm_bufio_release(UDS_FORGET(page->buffer));
+		dm_bufio_release(uds_forget(page->buffer));
 }
 
 static void clear_cache_page(struct page_cache *cache, struct cached_page *page)
@@ -1547,7 +1547,7 @@ int __must_check uds_replace_volume_storage(struct volume *volume,
 	if (volume->sparse_cache != NULL)
 		uds_invalidate_sparse_cache(volume->sparse_cache);
 	if (volume->client != NULL)
-		dm_bufio_client_destroy(UDS_FORGET(volume->client));
+		dm_bufio_client_destroy(uds_forget(volume->client));
 
 	return uds_open_volume_bufio(layout,
 				     volume->geometry->bytes_per_page,
@@ -1780,7 +1780,7 @@ void uds_free_volume(struct volume *volume)
 	uninitialize_page_cache(&volume->page_cache);
 	uds_free_sparse_cache(volume->sparse_cache);
 	if (volume->client != NULL)
-		dm_bufio_client_destroy(UDS_FORGET(volume->client));
+		dm_bufio_client_destroy(uds_forget(volume->client));
 
 	uds_destroy_cond(&volume->read_threads_cond);
 	uds_destroy_cond(&volume->read_threads_read_done_cond);
-- 
2.40.0

