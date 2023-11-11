Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E4C6FA8
	for <dm-devel@lists.linux.dev>; Sat, 11 Nov 2023 04:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eGt5Mk+2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699677049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N7Q6mHD6ZLWMUiWdPJc6Mvo+Nsk51jujm2iZ8kTGJu8=;
	b=eGt5Mk+2jd7snT5I04ic1FmC9LnlS2hlC0KsKX6xNahjY9zsVbIqfjRhibz/uYZwZRXXEc
	6cAju7X08phyRk4WuNzTDtoPS/Mi5w4Q4dXYYCaJiNq5Nvl4FsjZ7GtbyPLKUvQZoGjP12
	4R/RlXQe4tkEmkjVUQAcgnoUna/CufM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-148-X1Ms7SbBMo-3Hwvm4zUxgw-1; Fri, 10 Nov 2023 23:30:46 -0500
X-MC-Unique: X1Ms7SbBMo-3Hwvm4zUxgw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1C96811000;
	Sat, 11 Nov 2023 04:30:45 +0000 (UTC)
Received: from pbitcolo-build-10.permabit.com (pbitcolo-build-10.permabit.lab.eng.bos.redhat.com [10.19.117.76])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B875240C6EB9;
	Sat, 11 Nov 2023 04:30:45 +0000 (UTC)
Received: by pbitcolo-build-10.permabit.com (Postfix, from userid 1138)
	id 823953003F; Fri, 10 Nov 2023 23:30:45 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 3/8] dm vdo memory-alloc: rename UDS_FREE to uds_free
Date: Fri, 10 Nov 2023 23:30:39 -0500
Message-Id: <239b922426e8d73a30ff43e8f99d750e087f5d3e.1699675570.git.msakai@redhat.com>
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
 drivers/md/dm-vdo-target.c              | 14 ++++-----
 drivers/md/dm-vdo/block-map.c           | 22 +++++++-------
 drivers/md/dm-vdo/chapter-index.c       |  4 +--
 drivers/md/dm-vdo/config.c              |  2 +-
 drivers/md/dm-vdo/data-vio.c            |  8 ++---
 drivers/md/dm-vdo/dedupe.c              | 10 +++----
 drivers/md/dm-vdo/delta-index.c         | 10 +++----
 drivers/md/dm-vdo/encodings.c           |  2 +-
 drivers/md/dm-vdo/flush.c               |  4 +--
 drivers/md/dm-vdo/funnel-queue.c        |  2 +-
 drivers/md/dm-vdo/funnel-requestqueue.c |  2 +-
 drivers/md/dm-vdo/funnel-workqueue.c    | 18 +++++------
 drivers/md/dm-vdo/geometry.c            |  2 +-
 drivers/md/dm-vdo/index-layout.c        | 40 ++++++++++++-------------
 drivers/md/dm-vdo/index-page-map.c      | 12 ++++----
 drivers/md/dm-vdo/index-session.c       | 12 ++++----
 drivers/md/dm-vdo/index.c               | 16 +++++-----
 drivers/md/dm-vdo/int-map.c             |  8 ++---
 drivers/md/dm-vdo/io-factory.c          |  6 ++--
 drivers/md/dm-vdo/io-submitter.c        |  2 +-
 drivers/md/dm-vdo/logical-zone.c        |  4 +--
 drivers/md/dm-vdo/memory-alloc.c        |  8 ++---
 drivers/md/dm-vdo/memory-alloc.h        |  2 +-
 drivers/md/dm-vdo/message-stats.c       |  2 +-
 drivers/md/dm-vdo/open-chapter.c        |  4 +--
 drivers/md/dm-vdo/packer.c              |  6 ++--
 drivers/md/dm-vdo/physical-zone.c       |  4 +--
 drivers/md/dm-vdo/pointer-map.c         |  8 ++---
 drivers/md/dm-vdo/pool-sysfs.c          |  2 +-
 drivers/md/dm-vdo/priority-table.c      |  2 +-
 drivers/md/dm-vdo/radix-sort.c          |  2 +-
 drivers/md/dm-vdo/recovery-journal.c    | 18 +++++------
 drivers/md/dm-vdo/repair.c              | 10 +++----
 drivers/md/dm-vdo/slab-depot.c          | 34 ++++++++++-----------
 drivers/md/dm-vdo/sparse-cache.c        | 10 +++----
 drivers/md/dm-vdo/uds-sysfs.c           |  2 +-
 drivers/md/dm-vdo/uds-threads.c         |  4 +--
 drivers/md/dm-vdo/vdo.c                 | 28 ++++++++---------
 drivers/md/dm-vdo/vio.c                 | 10 +++----
 drivers/md/dm-vdo/volume-index.c        |  8 ++---
 drivers/md/dm-vdo/volume.c              | 16 +++++-----
 41 files changed, 190 insertions(+), 190 deletions(-)

diff --git a/drivers/md/dm-vdo-target.c b/drivers/md/dm-vdo-target.c
index e54fc3a92fc0..f2455895d8ae 100644
--- a/drivers/md/dm-vdo-target.c
+++ b/drivers/md/dm-vdo-target.c
@@ -192,12 +192,12 @@ static void free_device_config(struct device_config *config)
 	if (config->owned_device != NULL)
 		dm_put_device(config->owning_target, config->owned_device);
 
-	UDS_FREE(config->parent_device_name);
-	UDS_FREE(config->original_string);
+	uds_free(config->parent_device_name);
+	uds_free(config->original_string);
 
 	/* Reduce the chance a use-after-free (as in BZ 1669960) happens to work. */
 	memset(config, 0, sizeof(*config));
-	UDS_FREE(config);
+	uds_free(config);
 }
 
 /**
@@ -252,15 +252,15 @@ static void free_string_array(char **string_array)
 	unsigned int offset;
 
 	for (offset = 0; string_array[offset] != NULL; offset++)
-		UDS_FREE(string_array[offset]);
-	UDS_FREE(string_array);
+		uds_free(string_array[offset]);
+	uds_free(string_array);
 }
 
 /*
  * Split the input string into substrings, separated at occurrences of the indicated character,
  * returning a null-terminated list of string pointers.
  *
- * The string pointers and the pointer array itself should both be freed with UDS_FREE() when no
+ * The string pointers and the pointer array itself should both be freed with uds_free() when no
  * longer needed. This can be done with vdo_free_string_array (below) if the pointers in the array
  * are not changed. Since the array and copied strings are allocated by this function, it may only
  * be used in contexts where allocation is permitted.
@@ -2924,7 +2924,7 @@ static void vdo_module_destroy(void)
 	ASSERT_LOG_ONLY(instances.count == 0,
 			"should have no instance numbers still in use, but have %u",
 			instances.count);
-	UDS_FREE(instances.words);
+	uds_free(instances.words);
 	memset(&instances, 0, sizeof(struct instance_tracker));
 
 	uds_log_info("unloaded version %s", CURRENT_VERSION);
diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index ad03109db716..3ef0f1469ec0 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -2447,15 +2447,15 @@ static void deforest(struct forest *forest, size_t first_page_segment)
 		size_t segment;
 
 		for (segment = first_page_segment; segment < forest->segments; segment++)
-			UDS_FREE(forest->pages[segment]);
-		UDS_FREE(forest->pages);
+			uds_free(forest->pages[segment]);
+		uds_free(forest->pages);
 	}
 
 	for (root = 0; root < forest->map->root_count; root++)
-		UDS_FREE(forest->trees[root].segments);
+		uds_free(forest->trees[root].segments);
 
-	UDS_FREE(forest->boundaries);
-	UDS_FREE(forest);
+	uds_free(forest->boundaries);
+	uds_free(forest);
 }
 
 /**
@@ -2528,7 +2528,7 @@ static void finish_cursor(struct cursor *cursor)
 	if (--cursors->active_roots > 0)
 		return;
 
-	UDS_FREE(cursors);
+	uds_free(cursors);
 
 	vdo_finish_completion(parent);
 }
@@ -2863,7 +2863,7 @@ static void uninitialize_block_map_zone(struct block_map_zone *zone)
 {
 	struct vdo_page_cache *cache = &zone->page_cache;
 
-	UDS_FREE(uds_forget(zone->dirty_lists));
+	uds_free(uds_forget(zone->dirty_lists));
 	free_vio_pool(uds_forget(zone->vio_pool));
 	vdo_free_int_map(uds_forget(zone->loading_pages));
 	if (cache->infos != NULL) {
@@ -2874,8 +2874,8 @@ static void uninitialize_block_map_zone(struct block_map_zone *zone)
 	}
 
 	vdo_free_int_map(uds_forget(cache->page_map));
-	UDS_FREE(uds_forget(cache->infos));
-	UDS_FREE(uds_forget(cache->pages));
+	uds_free(uds_forget(cache->infos));
+	uds_free(uds_forget(cache->pages));
 }
 
 void vdo_free_block_map(struct block_map *map)
@@ -2891,8 +2891,8 @@ void vdo_free_block_map(struct block_map *map)
 	vdo_abandon_block_map_growth(map);
 	if (map->forest != NULL)
 		deforest(uds_forget(map->forest), 0);
-	UDS_FREE(uds_forget(map->action_manager));
-	UDS_FREE(map);
+	uds_free(uds_forget(map->action_manager));
+	uds_free(map);
 }
 
 /* @journal may be NULL. */
diff --git a/drivers/md/dm-vdo/chapter-index.c b/drivers/md/dm-vdo/chapter-index.c
index 29eb7fb8b4fe..117a3e041fea 100644
--- a/drivers/md/dm-vdo/chapter-index.c
+++ b/drivers/md/dm-vdo/chapter-index.c
@@ -39,7 +39,7 @@ int uds_make_open_chapter_index(struct open_chapter_index **chapter_index,
 					    memory_size,
 					    'm');
 	if (result != UDS_SUCCESS) {
-		UDS_FREE(index);
+		uds_free(index);
 		return result;
 	}
 
@@ -54,7 +54,7 @@ void uds_free_open_chapter_index(struct open_chapter_index *chapter_index)
 		return;
 
 	uds_uninitialize_delta_index(&chapter_index->delta_index);
-	UDS_FREE(chapter_index);
+	uds_free(chapter_index);
 }
 
 /* Re-initialize an open chapter index for a new chapter. */
diff --git a/drivers/md/dm-vdo/config.c b/drivers/md/dm-vdo/config.c
index 6a89f029dc21..09a2d9891099 100644
--- a/drivers/md/dm-vdo/config.c
+++ b/drivers/md/dm-vdo/config.c
@@ -369,7 +369,7 @@ void uds_free_configuration(struct configuration *config)
 {
 	if (config != NULL) {
 		uds_free_geometry(config->geometry);
-		UDS_FREE(config);
+		uds_free(config);
 	}
 }
 
diff --git a/drivers/md/dm-vdo/data-vio.c b/drivers/md/dm-vdo/data-vio.c
index 7b10926131a9..3af963becbdf 100644
--- a/drivers/md/dm-vdo/data-vio.c
+++ b/drivers/md/dm-vdo/data-vio.c
@@ -823,9 +823,9 @@ static void destroy_data_vio(struct data_vio *data_vio)
 		return;
 
 	vdo_free_bio(uds_forget(data_vio->vio.bio));
-	UDS_FREE(uds_forget(data_vio->vio.data));
-	UDS_FREE(uds_forget(data_vio->compression.block));
-	UDS_FREE(uds_forget(data_vio->scratch_block));
+	uds_free(uds_forget(data_vio->vio.data));
+	uds_free(uds_forget(data_vio->compression.block));
+	uds_free(uds_forget(data_vio->scratch_block));
 }
 
 /**
@@ -927,7 +927,7 @@ void free_data_vio_pool(struct data_vio_pool *pool)
 	}
 
 	uds_free_funnel_queue(uds_forget(pool->queue));
-	UDS_FREE(pool);
+	uds_free(pool);
 }
 
 static bool acquire_permit(struct limiter *limiter, struct bio *bio)
diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index daaeeb29ad0f..844d0f3ab3ca 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -2016,7 +2016,7 @@ static u32 hash_key(const void *key)
 
 static void dedupe_kobj_release(struct kobject *directory)
 {
-	UDS_FREE(container_of(directory, struct hash_zones, dedupe_directory));
+	uds_free(container_of(directory, struct hash_zones, dedupe_directory));
 }
 
 static ssize_t dedupe_status_show(struct kobject *directory, struct attribute *attr, char *buf)
@@ -2473,7 +2473,7 @@ int vdo_make_hash_zones(struct vdo *vdo, struct hash_zones **zones_ptr)
 
 	result = initialize_index(vdo, zones);
 	if (result != VDO_SUCCESS) {
-		UDS_FREE(zones);
+		uds_free(zones);
 		return result;
 	}
 
@@ -2523,14 +2523,14 @@ void vdo_free_hash_zones(struct hash_zones *zones)
 	if (zones == NULL)
 		return;
 
-	UDS_FREE(uds_forget(zones->manager));
+	uds_free(uds_forget(zones->manager));
 
 	for (i = 0; i < zones->zone_count; i++) {
 		struct hash_zone *zone = &zones->zones[i];
 
 		uds_free_funnel_queue(uds_forget(zone->timed_out_complete));
 		vdo_free_pointer_map(uds_forget(zone->hash_lock_map));
-		UDS_FREE(uds_forget(zone->lock_array));
+		uds_free(uds_forget(zone->lock_array));
 	}
 
 	if (zones->index_session != NULL)
@@ -2538,7 +2538,7 @@ void vdo_free_hash_zones(struct hash_zones *zones)
 
 	ratelimit_state_exit(&zones->ratelimiter);
 	if (vdo_get_admin_state_code(&zones->state) == VDO_ADMIN_STATE_NEW)
-		UDS_FREE(zones);
+		uds_free(zones);
 	else
 		kobject_put(&zones->dedupe_directory);
 }
diff --git a/drivers/md/dm-vdo/delta-index.c b/drivers/md/dm-vdo/delta-index.c
index a16e81f41c2e..c639b0c8bf8d 100644
--- a/drivers/md/dm-vdo/delta-index.c
+++ b/drivers/md/dm-vdo/delta-index.c
@@ -310,12 +310,12 @@ void uds_uninitialize_delta_index(struct delta_index *delta_index)
 		return;
 
 	for (z = 0; z < delta_index->zone_count; z++) {
-		UDS_FREE(uds_forget(delta_index->delta_zones[z].new_offsets));
-		UDS_FREE(uds_forget(delta_index->delta_zones[z].delta_lists));
-		UDS_FREE(uds_forget(delta_index->delta_zones[z].memory));
+		uds_free(uds_forget(delta_index->delta_zones[z].new_offsets));
+		uds_free(uds_forget(delta_index->delta_zones[z].delta_lists));
+		uds_free(uds_forget(delta_index->delta_zones[z].memory));
 	}
 
-	UDS_FREE(delta_index->delta_zones);
+	uds_free(delta_index->delta_zones);
 	memset(delta_index, 0, sizeof(struct delta_index));
 }
 
@@ -1101,7 +1101,7 @@ int uds_finish_restoring_delta_index(struct delta_index *delta_index,
 		}
 	}
 
-	UDS_FREE(data);
+	uds_free(data);
 	return saved_result;
 }
 
diff --git a/drivers/md/dm-vdo/encodings.c b/drivers/md/dm-vdo/encodings.c
index abe7fe55e8fb..d4abb7e2829e 100644
--- a/drivers/md/dm-vdo/encodings.c
+++ b/drivers/md/dm-vdo/encodings.c
@@ -932,7 +932,7 @@ void vdo_uninitialize_layout(struct layout *layout)
 		struct partition *part = layout->head;
 
 		layout->head = part->next;
-		UDS_FREE(part);
+		uds_free(part);
 	}
 
 	memset(layout, 0, sizeof(struct layout));
diff --git a/drivers/md/dm-vdo/flush.c b/drivers/md/dm-vdo/flush.c
index 7de201886f55..5bcbcb01703b 100644
--- a/drivers/md/dm-vdo/flush.c
+++ b/drivers/md/dm-vdo/flush.c
@@ -123,7 +123,7 @@ static void *allocate_flush(gfp_t gfp_mask, void *pool_data)
 
 static void free_flush(void *element, void *pool_data __always_unused)
 {
-	UDS_FREE(element);
+	uds_free(element);
 }
 
 /**
@@ -162,7 +162,7 @@ void vdo_free_flusher(struct flusher *flusher)
 
 	if (flusher->flush_pool != NULL)
 		mempool_destroy(uds_forget(flusher->flush_pool));
-	UDS_FREE(flusher);
+	uds_free(flusher);
 }
 
 /**
diff --git a/drivers/md/dm-vdo/funnel-queue.c b/drivers/md/dm-vdo/funnel-queue.c
index bf7f0d8bc04d..92809607e4d6 100644
--- a/drivers/md/dm-vdo/funnel-queue.c
+++ b/drivers/md/dm-vdo/funnel-queue.c
@@ -33,7 +33,7 @@ int uds_make_funnel_queue(struct funnel_queue **queue_ptr)
 
 void uds_free_funnel_queue(struct funnel_queue *queue)
 {
-	UDS_FREE(queue);
+	uds_free(queue);
 }
 
 static struct funnel_queue_entry *get_oldest(struct funnel_queue *queue)
diff --git a/drivers/md/dm-vdo/funnel-requestqueue.c b/drivers/md/dm-vdo/funnel-requestqueue.c
index 18ac5ee6cded..b90982393843 100644
--- a/drivers/md/dm-vdo/funnel-requestqueue.c
+++ b/drivers/md/dm-vdo/funnel-requestqueue.c
@@ -280,5 +280,5 @@ void uds_request_queue_finish(struct uds_request_queue *queue)
 
 	uds_free_funnel_queue(queue->main_queue);
 	uds_free_funnel_queue(queue->retry_queue);
-	UDS_FREE(queue);
+	uds_free(queue);
 }
diff --git a/drivers/md/dm-vdo/funnel-workqueue.c b/drivers/md/dm-vdo/funnel-workqueue.c
index d3b94a8b7b4e..ff86a4cfb323 100644
--- a/drivers/md/dm-vdo/funnel-workqueue.c
+++ b/drivers/md/dm-vdo/funnel-workqueue.c
@@ -278,8 +278,8 @@ static void free_simple_work_queue(struct simple_work_queue *queue)
 
 	for (i = 0; i <= VDO_WORK_Q_MAX_PRIORITY; i++)
 		uds_free_funnel_queue(queue->priority_lists[i]);
-	UDS_FREE(queue->common.name);
-	UDS_FREE(queue);
+	uds_free(queue->common.name);
+	uds_free(queue);
 }
 
 static void free_round_robin_work_queue(struct round_robin_work_queue *queue)
@@ -292,9 +292,9 @@ static void free_round_robin_work_queue(struct round_robin_work_queue *queue)
 
 	for (i = 0; i < count; i++)
 		free_simple_work_queue(queue_table[i]);
-	UDS_FREE(queue_table);
-	UDS_FREE(queue->common.name);
-	UDS_FREE(queue);
+	uds_free(queue_table);
+	uds_free(queue->common.name);
+	uds_free(queue);
 }
 
 void vdo_free_work_queue(struct vdo_work_queue *queue)
@@ -340,7 +340,7 @@ static int make_simple_work_queue(const char *thread_name_prefix,
 
 	result = uds_duplicate_string(name, "queue name", &queue->common.name);
 	if (result != VDO_SUCCESS) {
-		UDS_FREE(queue);
+		uds_free(queue);
 		return -ENOMEM;
 	}
 
@@ -423,7 +423,7 @@ int vdo_make_work_queue(const char *thread_name_prefix,
 			      "subordinate work queues",
 			      &queue->service_queues);
 	if (result != UDS_SUCCESS) {
-		UDS_FREE(queue);
+		uds_free(queue);
 		return result;
 	}
 
@@ -433,8 +433,8 @@ int vdo_make_work_queue(const char *thread_name_prefix,
 
 	result = uds_duplicate_string(name, "queue name", &queue->common.name);
 	if (result != VDO_SUCCESS) {
-		UDS_FREE(queue->service_queues);
-		UDS_FREE(queue);
+		uds_free(queue->service_queues);
+		uds_free(queue);
 		return -ENOMEM;
 	}
 
diff --git a/drivers/md/dm-vdo/geometry.c b/drivers/md/dm-vdo/geometry.c
index f4a4bcee5b73..0ff717cb72f6 100644
--- a/drivers/md/dm-vdo/geometry.c
+++ b/drivers/md/dm-vdo/geometry.c
@@ -123,7 +123,7 @@ int uds_copy_geometry(struct geometry *source, struct geometry **geometry_ptr)
 
 void uds_free_geometry(struct geometry *geometry)
 {
-	UDS_FREE(geometry);
+	uds_free(geometry);
 }
 
 u32 __must_check uds_map_to_physical_chapter(const struct geometry *geometry, u64 virtual_chapter)
diff --git a/drivers/md/dm-vdo/index-layout.c b/drivers/md/dm-vdo/index-layout.c
index a3bd56e3ef2d..3e9fa7028358 100644
--- a/drivers/md/dm-vdo/index-layout.c
+++ b/drivers/md/dm-vdo/index-layout.c
@@ -573,7 +573,7 @@ static int __must_check write_index_save_header(struct index_save_layout *isl,
 	}
 
 	result = uds_write_to_buffered_writer(writer, buffer, offset);
-	UDS_FREE(buffer);
+	uds_free(buffer);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -592,12 +592,12 @@ static int write_index_save_layout(struct index_layout *layout, struct index_sav
 
 	result = open_region_writer(layout, &isl->header, &writer);
 	if (result != UDS_SUCCESS) {
-		UDS_FREE(table);
+		uds_free(table);
 		return result;
 	}
 
 	result = write_index_save_header(isl, table, writer);
-	UDS_FREE(table);
+	uds_free(table);
 	uds_free_buffered_writer(writer);
 
 	return result;
@@ -747,7 +747,7 @@ static int __must_check write_layout_header(struct index_layout *layout,
 	}
 
 	result = uds_write_to_buffered_writer(writer, buffer, offset);
-	UDS_FREE(buffer);
+	uds_free(buffer);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -793,12 +793,12 @@ static int __must_check save_layout(struct index_layout *layout, off_t offset)
 
 	result = open_layout_writer(layout, &layout->header, offset, &writer);
 	if (result != UDS_SUCCESS) {
-		UDS_FREE(table);
+		uds_free(table);
 		return result;
 	}
 
 	result = write_layout_header(layout, table, writer);
-	UDS_FREE(table);
+	uds_free(table);
 	uds_free_buffered_writer(writer);
 
 	return result;
@@ -1192,7 +1192,7 @@ load_region_table(struct buffered_reader *reader, struct region_table **table_pt
 						       region_buffer,
 						       sizeof(region_buffer));
 		if (result != UDS_SUCCESS) {
-			UDS_FREE(table);
+			uds_free(table);
 			return uds_log_error_strerror(UDS_CORRUPT_DATA,
 						      "cannot read region table layouts");
 		}
@@ -1223,7 +1223,7 @@ static int __must_check read_super_block_data(struct buffered_reader *reader,
 
 	result = uds_read_from_buffered_reader(reader, buffer, saved_size);
 	if (result != UDS_SUCCESS) {
-		UDS_FREE(buffer);
+		uds_free(buffer);
 		return uds_log_error_strerror(result, "cannot read region table header");
 	}
 
@@ -1248,7 +1248,7 @@ static int __must_check read_super_block_data(struct buffered_reader *reader,
 		super->start_offset = 0;
 	}
 
-	UDS_FREE(buffer);
+	uds_free(buffer);
 
 	if (memcmp(super->magic_label, LAYOUT_MAGIC, MAGIC_SIZE) != 0)
 		return uds_log_error_strerror(UDS_CORRUPT_DATA, "unknown superblock magic label");
@@ -1398,18 +1398,18 @@ static int __must_check load_super_block(struct index_layout *layout,
 		return result;
 
 	if (table->header.type != RH_TYPE_SUPER) {
-		UDS_FREE(table);
+		uds_free(table);
 		return uds_log_error_strerror(UDS_CORRUPT_DATA, "not a superblock region table");
 	}
 
 	result = read_super_block_data(reader, layout, table->header.payload);
 	if (result != UDS_SUCCESS) {
-		UDS_FREE(table);
+		uds_free(table);
 		return uds_log_error_strerror(result, "unknown superblock format");
 	}
 
 	if (super->block_size != block_size) {
-		UDS_FREE(table);
+		uds_free(table);
 		return uds_log_error_strerror(UDS_CORRUPT_DATA,
 					      "superblock saved block_size %u differs from supplied block_size %zu",
 					      super->block_size,
@@ -1418,7 +1418,7 @@ static int __must_check load_super_block(struct index_layout *layout,
 
 	first_block -= (super->volume_offset - super->start_offset);
 	result = reconstitute_layout(layout, table, first_block);
-	UDS_FREE(table);
+	uds_free(table);
 	return result;
 }
 
@@ -1557,7 +1557,7 @@ static int __must_check load_index_save(struct index_save_layout *isl,
 	if (table->header.region_blocks != isl->index_save.block_count) {
 		u64 region_blocks = table->header.region_blocks;
 
-		UDS_FREE(table);
+		uds_free(table);
 		return uds_log_error_strerror(UDS_CORRUPT_DATA,
 					      "unexpected index save %u region block count %llu",
 					      instance,
@@ -1565,14 +1565,14 @@ static int __must_check load_index_save(struct index_save_layout *isl,
 	}
 
 	if (table->header.type == RH_TYPE_UNSAVED) {
-		UDS_FREE(table);
+		uds_free(table);
 		reset_index_save_layout(isl, 0);
 		return UDS_SUCCESS;
 	}
 
 
 	if (table->header.type != RH_TYPE_SAVE) {
-		UDS_FREE(table);
+		uds_free(table);
 		return uds_log_error_strerror(UDS_CORRUPT_DATA,
 					      "unexpected index save %u header type %u",
 					      instance,
@@ -1581,14 +1581,14 @@ static int __must_check load_index_save(struct index_save_layout *isl,
 
 	result = read_index_save_data(reader, isl, table->header.payload);
 	if (result != UDS_SUCCESS) {
-		UDS_FREE(table);
+		uds_free(table);
 		return uds_log_error_strerror(result,
 					      "unknown index save %u data format",
 					      instance);
 	}
 
 	result = reconstruct_index_save(isl, table);
-	UDS_FREE(table);
+	uds_free(table);
 	if (result != UDS_SUCCESS)
 		return uds_log_error_strerror(result,
 					      "cannot reconstruct index save %u",
@@ -1744,11 +1744,11 @@ void uds_free_index_layout(struct index_layout *layout)
 	if (layout == NULL)
 		return;
 
-	UDS_FREE(layout->index.saves);
+	uds_free(layout->index.saves);
 	if (layout->factory != NULL)
 		uds_put_io_factory(layout->factory);
 
-	UDS_FREE(layout);
+	uds_free(layout);
 }
 
 int uds_replace_index_layout_storage(struct index_layout *layout, struct block_device *bdev)
diff --git a/drivers/md/dm-vdo/index-page-map.c b/drivers/md/dm-vdo/index-page-map.c
index 592d5aff7c77..93c6a2235682 100644
--- a/drivers/md/dm-vdo/index-page-map.c
+++ b/drivers/md/dm-vdo/index-page-map.c
@@ -60,8 +60,8 @@ int uds_make_index_page_map(const struct geometry *geometry, struct index_page_m
 void uds_free_index_page_map(struct index_page_map *map)
 {
 	if (map != NULL) {
-		UDS_FREE(map->entries);
-		UDS_FREE(map);
+		uds_free(map->entries);
+		uds_free(map);
 	}
 }
 
@@ -137,7 +137,7 @@ int uds_write_index_page_map(struct index_page_map *map, struct buffered_writer
 		encode_u16_le(buffer, &offset, map->entries[i]);
 
 	result = uds_write_to_buffered_writer(writer, buffer, offset);
-	UDS_FREE(buffer);
+	uds_free(buffer);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -159,14 +159,14 @@ int uds_read_index_page_map(struct index_page_map *map, struct buffered_reader *
 
 	result = uds_read_from_buffered_reader(reader, buffer, saved_size);
 	if (result != UDS_SUCCESS) {
-		UDS_FREE(buffer);
+		uds_free(buffer);
 		return result;
 	}
 
 	memcpy(&magic, buffer, PAGE_MAP_MAGIC_LENGTH);
 	offset += PAGE_MAP_MAGIC_LENGTH;
 	if (memcmp(magic, PAGE_MAP_MAGIC, PAGE_MAP_MAGIC_LENGTH) != 0) {
-		UDS_FREE(buffer);
+		uds_free(buffer);
 		return UDS_CORRUPT_DATA;
 	}
 
@@ -174,7 +174,7 @@ int uds_read_index_page_map(struct index_page_map *map, struct buffered_reader *
 	for (i = 0; i < get_entry_count(map->geometry); i++)
 		decode_u16_le(buffer, &offset, &map->entries[i]);
 
-	UDS_FREE(buffer);
+	uds_free(buffer);
 	uds_log_debug("read index page map, last update %llu",
 		      (unsigned long long) map->last_update);
 	return UDS_SUCCESS;
diff --git a/drivers/md/dm-vdo/index-session.c b/drivers/md/dm-vdo/index-session.c
index 5c14b0917c4d..d15ec2b339ef 100644
--- a/drivers/md/dm-vdo/index-session.c
+++ b/drivers/md/dm-vdo/index-session.c
@@ -224,14 +224,14 @@ static int __must_check make_empty_index_session(struct uds_index_session **inde
 
 	result = uds_init_mutex(&session->request_mutex);
 	if (result != UDS_SUCCESS) {
-		UDS_FREE(session);
+		uds_free(session);
 		return result;
 	}
 
 	result = uds_init_cond(&session->request_cond);
 	if (result != UDS_SUCCESS) {
 		uds_destroy_mutex(&session->request_mutex);
-		UDS_FREE(session);
+		uds_free(session);
 		return result;
 	}
 
@@ -239,7 +239,7 @@ static int __must_check make_empty_index_session(struct uds_index_session **inde
 	if (result != UDS_SUCCESS) {
 		uds_destroy_cond(&session->request_cond);
 		uds_destroy_mutex(&session->request_mutex);
-		UDS_FREE(session);
+		uds_free(session);
 		return result;
 	}
 
@@ -248,7 +248,7 @@ static int __must_check make_empty_index_session(struct uds_index_session **inde
 		uds_destroy_mutex(&session->load_context.mutex);
 		uds_destroy_cond(&session->request_cond);
 		uds_destroy_mutex(&session->request_mutex);
-		UDS_FREE(session);
+		uds_free(session);
 		return result;
 	}
 
@@ -258,7 +258,7 @@ static int __must_check make_empty_index_session(struct uds_index_session **inde
 		uds_destroy_mutex(&session->load_context.mutex);
 		uds_destroy_cond(&session->request_cond);
 		uds_destroy_mutex(&session->request_mutex);
-		UDS_FREE(session);
+		uds_free(session);
 		return result;
 	}
 
@@ -691,7 +691,7 @@ int uds_destroy_index_session(struct uds_index_session *index_session)
 	uds_destroy_cond(&index_session->request_cond);
 	uds_destroy_mutex(&index_session->request_mutex);
 	uds_log_debug("Destroyed index session");
-	UDS_FREE(index_session);
+	uds_free(index_session);
 	return uds_map_to_system_error(result);
 }
 
diff --git a/drivers/md/dm-vdo/index.c b/drivers/md/dm-vdo/index.c
index e118755c5f60..ff0239c361a8 100644
--- a/drivers/md/dm-vdo/index.c
+++ b/drivers/md/dm-vdo/index.c
@@ -623,7 +623,7 @@ static void execute_zone_request(struct uds_request *request)
 					       request->zone_message.type);
 
 		/* Once the message is processed it can be freed. */
-		UDS_FREE(uds_forget(request));
+		uds_free(uds_forget(request));
 		return;
 	}
 
@@ -756,8 +756,8 @@ static void free_chapter_writer(struct chapter_writer *writer)
 	uds_destroy_mutex(&writer->mutex);
 	uds_destroy_cond(&writer->cond);
 	uds_free_open_chapter_index(writer->open_chapter_index);
-	UDS_FREE(writer->collated_records);
-	UDS_FREE(writer);
+	uds_free(writer->collated_records);
+	uds_free(writer);
 }
 
 static int make_chapter_writer(struct uds_index *index, struct chapter_writer **writer_ptr)
@@ -778,14 +778,14 @@ static int make_chapter_writer(struct uds_index *index, struct chapter_writer **
 	writer->index = index;
 	result = uds_init_mutex(&writer->mutex);
 	if (result != UDS_SUCCESS) {
-		UDS_FREE(writer);
+		uds_free(writer);
 		return result;
 	}
 
 	result = uds_init_cond(&writer->cond);
 	if (result != UDS_SUCCESS) {
 		uds_destroy_mutex(&writer->mutex);
-		UDS_FREE(writer);
+		uds_free(writer);
 		return result;
 	}
 
@@ -1129,7 +1129,7 @@ static void free_index_zone(struct index_zone *zone)
 
 	uds_free_open_chapter(zone->open_chapter);
 	uds_free_open_chapter(zone->writing_chapter);
-	UDS_FREE(zone);
+	uds_free(zone);
 }
 
 static int make_index_zone(struct uds_index *index, unsigned int zone_number)
@@ -1304,12 +1304,12 @@ void uds_free_index(struct uds_index *index)
 	if (index->zones != NULL) {
 		for (i = 0; i < index->zone_count; i++)
 			free_index_zone(index->zones[i]);
-		UDS_FREE(index->zones);
+		uds_free(index->zones);
 	}
 
 	uds_free_volume(index->volume);
 	uds_free_index_layout(uds_forget(index->layout));
-	UDS_FREE(index);
+	uds_free(index);
 }
 
 /* Wait for the chapter writer to complete any outstanding writes. */
diff --git a/drivers/md/dm-vdo/int-map.c b/drivers/md/dm-vdo/int-map.c
index 86fa5abdb6fe..1c1195451d05 100644
--- a/drivers/md/dm-vdo/int-map.c
+++ b/drivers/md/dm-vdo/int-map.c
@@ -227,8 +227,8 @@ void vdo_free_int_map(struct int_map *map)
 	if (map == NULL)
 		return;
 
-	UDS_FREE(uds_forget(map->buckets));
-	UDS_FREE(uds_forget(map));
+	uds_free(uds_forget(map->buckets));
+	uds_free(uds_forget(map));
 }
 
 /**
@@ -408,14 +408,14 @@ static int resize_buckets(struct int_map *map)
 		result = vdo_int_map_put(map, entry->key, entry->value, true, NULL);
 		if (result != UDS_SUCCESS) {
 			/* Destroy the new partial map and restore the map from the stack. */
-			UDS_FREE(uds_forget(map->buckets));
+			uds_free(uds_forget(map->buckets));
 			*map = old_map;
 			return result;
 		}
 	}
 
 	/* Destroy the old bucket array. */
-	UDS_FREE(uds_forget(old_map.buckets));
+	uds_free(uds_forget(old_map.buckets));
 	return UDS_SUCCESS;
 }
 
diff --git a/drivers/md/dm-vdo/io-factory.c b/drivers/md/dm-vdo/io-factory.c
index 69708eb87786..90159fb5eaa7 100644
--- a/drivers/md/dm-vdo/io-factory.c
+++ b/drivers/md/dm-vdo/io-factory.c
@@ -85,7 +85,7 @@ int uds_replace_storage(struct io_factory *factory, struct block_device *bdev)
 void uds_put_io_factory(struct io_factory *factory)
 {
 	if (atomic_add_return(-1, &factory->ref_count) <= 0)
-		UDS_FREE(factory);
+		uds_free(factory);
 }
 
 size_t uds_get_writable_size(struct io_factory *factory)
@@ -137,7 +137,7 @@ void uds_free_buffered_reader(struct buffered_reader *reader)
 
 	dm_bufio_client_destroy(reader->client);
 	uds_put_io_factory(reader->factory);
-	UDS_FREE(reader);
+	uds_free(reader);
 }
 
 /* Create a buffered reader for an index region starting at offset. */
@@ -378,7 +378,7 @@ void uds_free_buffered_writer(struct buffered_writer *writer)
 
 	dm_bufio_client_destroy(writer->client);
 	uds_put_io_factory(writer->factory);
-	UDS_FREE(writer);
+	uds_free(writer);
 }
 
 /*
diff --git a/drivers/md/dm-vdo/io-submitter.c b/drivers/md/dm-vdo/io-submitter.c
index 8f1c5380e729..68370dea7067 100644
--- a/drivers/md/dm-vdo/io-submitter.c
+++ b/drivers/md/dm-vdo/io-submitter.c
@@ -479,5 +479,5 @@ void vdo_free_io_submitter(struct io_submitter *io_submitter)
 		uds_forget(io_submitter->bio_queue_data[i].queue);
 		vdo_free_int_map(uds_forget(io_submitter->bio_queue_data[i].map));
 	}
-	UDS_FREE(io_submitter);
+	uds_free(io_submitter);
 }
diff --git a/drivers/md/dm-vdo/logical-zone.c b/drivers/md/dm-vdo/logical-zone.c
index 9c924368e027..61cc55ebfe5b 100644
--- a/drivers/md/dm-vdo/logical-zone.c
+++ b/drivers/md/dm-vdo/logical-zone.c
@@ -137,12 +137,12 @@ void vdo_free_logical_zones(struct logical_zones *zones)
 	if (zones == NULL)
 		return;
 
-	UDS_FREE(uds_forget(zones->manager));
+	uds_free(uds_forget(zones->manager));
 
 	for (index = 0; index < zones->zone_count; index++)
 		vdo_free_int_map(uds_forget(zones->zones[index].lbn_operations));
 
-	UDS_FREE(zones);
+	uds_free(zones);
 }
 
 static inline void assert_on_zone_thread(struct logical_zone *zone, const char *what)
diff --git a/drivers/md/dm-vdo/memory-alloc.c b/drivers/md/dm-vdo/memory-alloc.c
index 41b15f7a7ba6..73f841289f9e 100644
--- a/drivers/md/dm-vdo/memory-alloc.c
+++ b/drivers/md/dm-vdo/memory-alloc.c
@@ -149,7 +149,7 @@ static void remove_vmalloc_block(void *ptr)
 
 	spin_unlock_irqrestore(&memory_stats.lock, flags);
 	if (block != NULL)
-		UDS_FREE(block);
+		uds_free(block);
 	else
 		uds_log_info("attempting to remove ptr %px not found in vmalloc list", ptr);
 }
@@ -274,7 +274,7 @@ int uds_allocate_memory(size_t size, size_t align, const char *what, void *ptr)
 			}
 
 			if (p == NULL) {
-				UDS_FREE(block);
+				uds_free(block);
 			} else {
 				block->ptr = p;
 				block->size = PAGE_ALIGN(size);
@@ -349,7 +349,7 @@ int uds_reallocate_memory(void *ptr, size_t old_size, size_t size, const char *w
 	int result;
 
 	if (size == 0) {
-		UDS_FREE(ptr);
+		uds_free(ptr);
 		*(void **) new_ptr = NULL;
 		return UDS_SUCCESS;
 	}
@@ -363,7 +363,7 @@ int uds_reallocate_memory(void *ptr, size_t old_size, size_t size, const char *w
 			size = old_size;
 
 		memcpy(*((void **) new_ptr), ptr, size);
-		UDS_FREE(ptr);
+		uds_free(ptr);
 	}
 
 	return UDS_SUCCESS;
diff --git a/drivers/md/dm-vdo/memory-alloc.h b/drivers/md/dm-vdo/memory-alloc.h
index 251816897081..03d8f69f6cdc 100644
--- a/drivers/md/dm-vdo/memory-alloc.h
+++ b/drivers/md/dm-vdo/memory-alloc.h
@@ -19,7 +19,7 @@ int __must_check uds_allocate_memory(size_t size, size_t align, const char *what
 void uds_free_memory(void *ptr);
 
 /* Free memory allocated with UDS_ALLOCATE(). */
-#define UDS_FREE(PTR) uds_free_memory(PTR)
+#define uds_free(PTR) uds_free_memory(PTR)
 
 static inline void *__uds_forget(void **ptr_ptr)
 {
diff --git a/drivers/md/dm-vdo/message-stats.c b/drivers/md/dm-vdo/message-stats.c
index b91a841043eb..7910576f8b57 100644
--- a/drivers/md/dm-vdo/message-stats.c
+++ b/drivers/md/dm-vdo/message-stats.c
@@ -1210,6 +1210,6 @@ int vdo_write_stats(struct vdo *vdo,
 
 	vdo_fetch_statistics(vdo, stats);
 	result = write_vdo_statistics(NULL, stats, NULL, &buf, &maxlen);
-	UDS_FREE(stats);
+	uds_free(stats);
 	return result;
 }
diff --git a/drivers/md/dm-vdo/open-chapter.c b/drivers/md/dm-vdo/open-chapter.c
index d54c8fb6f118..0cbbbbc6602a 100644
--- a/drivers/md/dm-vdo/open-chapter.c
+++ b/drivers/md/dm-vdo/open-chapter.c
@@ -200,8 +200,8 @@ void uds_remove_from_open_chapter(struct open_chapter_zone *open_chapter,
 void uds_free_open_chapter(struct open_chapter_zone *open_chapter)
 {
 	if (open_chapter != NULL) {
-		UDS_FREE(open_chapter->records);
-		UDS_FREE(open_chapter);
+		uds_free(open_chapter->records);
+		uds_free(open_chapter);
 	}
 }
 
diff --git a/drivers/md/dm-vdo/packer.c b/drivers/md/dm-vdo/packer.c
index 7641318b3007..d06e654fc9e5 100644
--- a/drivers/md/dm-vdo/packer.c
+++ b/drivers/md/dm-vdo/packer.c
@@ -206,11 +206,11 @@ void vdo_free_packer(struct packer *packer)
 
 	list_for_each_entry_safe(bin, tmp, &packer->bins, list) {
 		list_del_init(&bin->list);
-		UDS_FREE(bin);
+		uds_free(bin);
 	}
 
-	UDS_FREE(uds_forget(packer->canceled_bin));
-	UDS_FREE(packer);
+	uds_free(uds_forget(packer->canceled_bin));
+	uds_free(packer);
 }
 
 /**
diff --git a/drivers/md/dm-vdo/physical-zone.c b/drivers/md/dm-vdo/physical-zone.c
index 08c1c7a1b366..f32fe7ef0d0d 100644
--- a/drivers/md/dm-vdo/physical-zone.c
+++ b/drivers/md/dm-vdo/physical-zone.c
@@ -275,7 +275,7 @@ static void free_pbn_lock_pool(struct pbn_lock_pool *pool)
 	ASSERT_LOG_ONLY(pool->borrowed == 0,
 			"All PBN locks must be returned to the pool before it is freed, but %zu locks are still on loan",
 			pool->borrowed);
-	UDS_FREE(pool);
+	uds_free(pool);
 }
 
 /**
@@ -410,7 +410,7 @@ void vdo_free_physical_zones(struct physical_zones *zones)
 		vdo_free_int_map(uds_forget(zone->pbn_operations));
 	}
 
-	UDS_FREE(zones);
+	uds_free(zones);
 }
 
 /**
diff --git a/drivers/md/dm-vdo/pointer-map.c b/drivers/md/dm-vdo/pointer-map.c
index 1b22c42b5d5d..64e6f8ef4541 100644
--- a/drivers/md/dm-vdo/pointer-map.c
+++ b/drivers/md/dm-vdo/pointer-map.c
@@ -197,8 +197,8 @@ void vdo_free_pointer_map(struct pointer_map *map)
 	if (map == NULL)
 		return;
 
-	UDS_FREE(uds_forget(map->buckets));
-	UDS_FREE(uds_forget(map));
+	uds_free(uds_forget(map->buckets));
+	uds_free(uds_forget(map));
 }
 
 /**
@@ -369,14 +369,14 @@ static int resize_buckets(struct pointer_map *map)
 		result = vdo_pointer_map_put(map, entry->key, entry->value, true, NULL);
 		if (result != UDS_SUCCESS) {
 			/* Destroy the new partial map and restore the map from the stack. */
-			UDS_FREE(uds_forget(map->buckets));
+			uds_free(uds_forget(map->buckets));
 			*map = old_map;
 			return result;
 		}
 	}
 
 	/* Destroy the old bucket array. */
-	UDS_FREE(uds_forget(old_map.buckets));
+	uds_free(uds_forget(old_map.buckets));
 	return UDS_SUCCESS;
 }
 
diff --git a/drivers/md/dm-vdo/pool-sysfs.c b/drivers/md/dm-vdo/pool-sysfs.c
index 413a5194586e..573fdde3fad0 100644
--- a/drivers/md/dm-vdo/pool-sysfs.c
+++ b/drivers/md/dm-vdo/pool-sysfs.c
@@ -105,7 +105,7 @@ static ssize_t pool_requests_maximum_show(struct vdo *vdo, char *buf)
 
 static void vdo_pool_release(struct kobject *directory)
 {
-	UDS_FREE(container_of(directory, struct vdo, vdo_directory));
+	uds_free(container_of(directory, struct vdo, vdo_directory));
 }
 
 static struct pool_attribute vdo_pool_compressing_attr = {
diff --git a/drivers/md/dm-vdo/priority-table.c b/drivers/md/dm-vdo/priority-table.c
index f8b81d6410c7..7956ed7dd684 100644
--- a/drivers/md/dm-vdo/priority-table.c
+++ b/drivers/md/dm-vdo/priority-table.c
@@ -98,7 +98,7 @@ void vdo_free_priority_table(struct priority_table *table)
 	 */
 	vdo_reset_priority_table(table);
 
-	UDS_FREE(table);
+	uds_free(table);
 }
 
 /**
diff --git a/drivers/md/dm-vdo/radix-sort.c b/drivers/md/dm-vdo/radix-sort.c
index 7eeb81a6deb6..2b9b31177d03 100644
--- a/drivers/md/dm-vdo/radix-sort.c
+++ b/drivers/md/dm-vdo/radix-sort.c
@@ -236,7 +236,7 @@ int uds_make_radix_sorter(unsigned int count, struct radix_sorter **sorter)
 
 void uds_free_radix_sorter(struct radix_sorter *sorter)
 {
-	UDS_FREE(sorter);
+	uds_free(sorter);
 }
 
 /*
diff --git a/drivers/md/dm-vdo/recovery-journal.c b/drivers/md/dm-vdo/recovery-journal.c
index 02fc4cb812f4..157a6f3c5131 100644
--- a/drivers/md/dm-vdo/recovery-journal.c
+++ b/drivers/md/dm-vdo/recovery-journal.c
@@ -689,7 +689,7 @@ static int initialize_recovery_block(struct vdo *vdo,
 					 data,
 					 &block->vio);
 	if (result != VDO_SUCCESS) {
-		UDS_FREE(data);
+		uds_free(data);
 		return result;
 	}
 
@@ -808,12 +808,12 @@ void vdo_free_recovery_journal(struct recovery_journal *journal)
 	if (journal == NULL)
 		return;
 
-	UDS_FREE(uds_forget(journal->lock_counter.logical_zone_counts));
-	UDS_FREE(uds_forget(journal->lock_counter.physical_zone_counts));
-	UDS_FREE(uds_forget(journal->lock_counter.journal_counters));
-	UDS_FREE(uds_forget(journal->lock_counter.journal_decrement_counts));
-	UDS_FREE(uds_forget(journal->lock_counter.logical_counters));
-	UDS_FREE(uds_forget(journal->lock_counter.physical_counters));
+	uds_free(uds_forget(journal->lock_counter.logical_zone_counts));
+	uds_free(uds_forget(journal->lock_counter.physical_zone_counts));
+	uds_free(uds_forget(journal->lock_counter.journal_counters));
+	uds_free(uds_forget(journal->lock_counter.journal_decrement_counts));
+	uds_free(uds_forget(journal->lock_counter.logical_counters));
+	uds_free(uds_forget(journal->lock_counter.physical_counters));
 	free_vio(uds_forget(journal->flush_vio));
 
 	/*
@@ -829,11 +829,11 @@ void vdo_free_recovery_journal(struct recovery_journal *journal)
 	for (i = 0; i < RECOVERY_JOURNAL_RESERVED_BLOCKS; i++) {
 		struct recovery_journal_block *block = &journal->blocks[i];
 
-		UDS_FREE(uds_forget(block->vio.data));
+		uds_free(uds_forget(block->vio.data));
 		free_vio_components(&block->vio);
 	}
 
-	UDS_FREE(journal);
+	uds_free(journal);
 }
 
 /**
diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
index c3e9a67986db..956a98166cf5 100644
--- a/drivers/md/dm-vdo/repair.c
+++ b/drivers/md/dm-vdo/repair.c
@@ -229,7 +229,7 @@ static void uninitialize_vios(struct repair_completion *repair)
 	while (repair->vio_count > 0)
 		free_vio_components(&repair->vios[--repair->vio_count]);
 
-	UDS_FREE(uds_forget(repair->vios));
+	uds_free(uds_forget(repair->vios));
 }
 
 static void free_repair_completion(struct repair_completion *repair)
@@ -244,9 +244,9 @@ static void free_repair_completion(struct repair_completion *repair)
 	repair->completion.vdo->block_map->zones[0].page_cache.rebuilding = false;
 
 	uninitialize_vios(repair);
-	UDS_FREE(uds_forget(repair->journal_data));
-	UDS_FREE(uds_forget(repair->entries));
-	UDS_FREE(repair);
+	uds_free(uds_forget(repair->journal_data));
+	uds_free(uds_forget(repair->entries));
+	uds_free(repair);
 }
 
 static void finish_repair(struct vdo_completion *completion)
@@ -1120,7 +1120,7 @@ static void recover_block_map(struct vdo_completion *completion)
 
 	if (repair->block_map_entry_count == 0) {
 		uds_log_info("Replaying 0 recovery entries into block map");
-		UDS_FREE(uds_forget(repair->journal_data));
+		uds_free(uds_forget(repair->journal_data));
 		launch_repair_completion(repair, load_slab_depot, VDO_ZONE_TYPE_ADMIN);
 		return;
 	}
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index b38b0ce4b35d..15df2a6bb14a 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -2439,7 +2439,7 @@ static int allocate_slab_counters(struct vdo_slab *slab)
 	bytes = (slab->reference_block_count * COUNTS_PER_BLOCK) + (2 * BYTES_PER_WORD);
 	result = UDS_ALLOCATE(bytes, vdo_refcount_t, "ref counts array", &slab->counters);
 	if (result != UDS_SUCCESS) {
-		UDS_FREE(uds_forget(slab->reference_blocks));
+		uds_free(uds_forget(slab->reference_blocks));
 		return result;
 	}
 
@@ -2715,7 +2715,7 @@ static bool __must_check has_slabs_to_scrub(struct slab_scrubber *scrubber)
  */
 static void uninitialize_scrubber_vio(struct slab_scrubber *scrubber)
 {
-	UDS_FREE(uds_forget(scrubber->vio.data));
+	uds_free(uds_forget(scrubber->vio.data));
 	free_vio_components(&scrubber->vio);
 }
 
@@ -3616,7 +3616,7 @@ vdo_prepare_slabs_for_allocation(struct block_allocator *allocator)
 		register_slab_for_scrubbing(slab, high_priority);
 	}
 
-	UDS_FREE(slab_statuses);
+	uds_free(slab_statuses);
 	return VDO_SUCCESS;
 }
 
@@ -3713,11 +3713,11 @@ static void free_slab(struct vdo_slab *slab)
 		return;
 
 	list_del(&slab->allocq_entry);
-	UDS_FREE(uds_forget(slab->journal.block));
-	UDS_FREE(uds_forget(slab->journal.locks));
-	UDS_FREE(uds_forget(slab->counters));
-	UDS_FREE(uds_forget(slab->reference_blocks));
-	UDS_FREE(slab);
+	uds_free(uds_forget(slab->journal.block));
+	uds_free(uds_forget(slab->journal.locks));
+	uds_free(uds_forget(slab->counters));
+	uds_free(uds_forget(slab->reference_blocks));
+	uds_free(slab);
 }
 
 static int initialize_slab_journal(struct vdo_slab *slab)
@@ -3900,7 +3900,7 @@ void vdo_abandon_new_slabs(struct slab_depot *depot)
 		free_slab(uds_forget(depot->new_slabs[i]));
 	depot->new_slab_count = 0;
 	depot->new_size = 0;
-	UDS_FREE(uds_forget(depot->new_slabs));
+	uds_free(uds_forget(depot->new_slabs));
 }
 
 /**
@@ -4022,7 +4022,7 @@ static int initialize_slab_scrubber(struct block_allocator *allocator)
 					 journal_data,
 					 &scrubber->vio);
 	if (result != VDO_SUCCESS) {
-		UDS_FREE(journal_data);
+		uds_free(journal_data);
 		return result;
 	}
 
@@ -4299,10 +4299,10 @@ static void uninitialize_allocator_summary(struct block_allocator *allocator)
 
 	for (i = 0; i < VDO_SLAB_SUMMARY_BLOCKS_PER_ZONE; i++) {
 		free_vio_components(&allocator->summary_blocks[i].vio);
-		UDS_FREE(uds_forget(allocator->summary_blocks[i].outgoing_entries));
+		uds_free(uds_forget(allocator->summary_blocks[i].outgoing_entries));
 	}
 
-	UDS_FREE(uds_forget(allocator->summary_blocks));
+	uds_free(uds_forget(allocator->summary_blocks));
 }
 
 /**
@@ -4337,10 +4337,10 @@ void vdo_free_slab_depot(struct slab_depot *depot)
 			free_slab(uds_forget(depot->slabs[i]));
 	}
 
-	UDS_FREE(uds_forget(depot->slabs));
-	UDS_FREE(uds_forget(depot->action_manager));
-	UDS_FREE(uds_forget(depot->summary_entries));
-	UDS_FREE(depot);
+	uds_free(uds_forget(depot->slabs));
+	uds_free(uds_forget(depot->action_manager));
+	uds_free(uds_forget(depot->summary_entries));
+	uds_free(depot);
 }
 
 /**
@@ -4804,7 +4804,7 @@ static int finish_registration(void *context)
 	struct slab_depot *depot = context;
 
 	WRITE_ONCE(depot->slab_count, depot->new_slab_count);
-	UDS_FREE(depot->slabs);
+	uds_free(depot->slabs);
 	depot->slabs = depot->new_slabs;
 	depot->new_slabs = NULL;
 	depot->new_slab_count = 0;
diff --git a/drivers/md/dm-vdo/sparse-cache.c b/drivers/md/dm-vdo/sparse-cache.c
index d4ae28b89b5b..5895b283c8e6 100644
--- a/drivers/md/dm-vdo/sparse-cache.c
+++ b/drivers/md/dm-vdo/sparse-cache.c
@@ -308,20 +308,20 @@ void uds_free_sparse_cache(struct sparse_cache *cache)
 	if (cache == NULL)
 		return;
 
-	UDS_FREE(cache->scratch_entries);
+	uds_free(cache->scratch_entries);
 
 	for (i = 0; i < cache->zone_count; i++)
-		UDS_FREE(cache->search_lists[i]);
+		uds_free(cache->search_lists[i]);
 
 	for (i = 0; i < cache->capacity; i++) {
 		release_cached_chapter_index(&cache->chapters[i]);
-		UDS_FREE(cache->chapters[i].index_pages);
-		UDS_FREE(cache->chapters[i].page_buffers);
+		uds_free(cache->chapters[i].index_pages);
+		uds_free(cache->chapters[i].page_buffers);
 	}
 
 	uds_destroy_barrier(&cache->begin_update_barrier);
 	uds_destroy_barrier(&cache->end_update_barrier);
-	UDS_FREE(cache);
+	uds_free(cache);
 }
 
 /*
diff --git a/drivers/md/dm-vdo/uds-sysfs.c b/drivers/md/dm-vdo/uds-sysfs.c
index 8700a028a11c..71dfaf49780d 100644
--- a/drivers/md/dm-vdo/uds-sysfs.c
+++ b/drivers/md/dm-vdo/uds-sysfs.c
@@ -117,7 +117,7 @@ parameter_store(struct kobject *kobj, struct attribute *attr, const char *buf, s
 		return -ENOMEM;
 
 	pa->store_string(string);
-	UDS_FREE(string);
+	uds_free(string);
 	return length;
 }
 
diff --git a/drivers/md/dm-vdo/uds-threads.c b/drivers/md/dm-vdo/uds-threads.c
index 17737246d28c..2552263f1b3d 100644
--- a/drivers/md/dm-vdo/uds-threads.c
+++ b/drivers/md/dm-vdo/uds-threads.c
@@ -119,7 +119,7 @@ int uds_create_thread(void (*thread_function)(void *),
 		task = kthread_run(thread_starter, thread, "%s", name);
 
 	if (IS_ERR(task)) {
-		UDS_FREE(thread);
+		uds_free(thread);
 		return PTR_ERR(task);
 	}
 
@@ -136,7 +136,7 @@ int uds_join_threads(struct thread *thread)
 	mutex_lock(&thread_mutex);
 	hlist_del(&thread->thread_links);
 	mutex_unlock(&thread_mutex);
-	UDS_FREE(thread);
+	uds_free(thread);
 	return UDS_SUCCESS;
 }
 
diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index 3d3909172ba1..6c9d62f899b3 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -173,10 +173,10 @@ static const struct vdo_work_queue_type cpu_q_type = {
 
 static void uninitialize_thread_config(struct thread_config *config)
 {
-	UDS_FREE(uds_forget(config->logical_threads));
-	UDS_FREE(uds_forget(config->physical_threads));
-	UDS_FREE(uds_forget(config->hash_zone_threads));
-	UDS_FREE(uds_forget(config->bio_threads));
+	uds_free(uds_forget(config->logical_threads));
+	uds_free(uds_forget(config->physical_threads));
+	uds_free(uds_forget(config->hash_zone_threads));
+	uds_free(uds_forget(config->bio_threads));
 	memset(config, 0, sizeof(struct thread_config));
 }
 
@@ -291,7 +291,7 @@ static int __must_check read_geometry_block(struct vdo *vdo)
 
 	result = create_metadata_vio(vdo, VIO_TYPE_GEOMETRY, VIO_PRIORITY_HIGH, NULL, block, &vio);
 	if (result != VDO_SUCCESS) {
-		UDS_FREE(block);
+		uds_free(block);
 		return result;
 	}
 
@@ -303,7 +303,7 @@ static int __must_check read_geometry_block(struct vdo *vdo)
 	result = vio_reset_bio(vio, block, NULL, REQ_OP_READ, VDO_GEOMETRY_BLOCK_LOCATION);
 	if (result != VDO_SUCCESS) {
 		free_vio(uds_forget(vio));
-		UDS_FREE(block);
+		uds_free(block);
 		return result;
 	}
 
@@ -313,12 +313,12 @@ static int __must_check read_geometry_block(struct vdo *vdo)
 	free_vio(uds_forget(vio));
 	if (result != 0) {
 		uds_log_error_strerror(result, "synchronous read failed");
-		UDS_FREE(block);
+		uds_free(block);
 		return -EIO;
 	}
 
 	result = vdo_parse_geometry_block((u8 *) block, &vdo->geometry);
-	UDS_FREE(block);
+	uds_free(block);
 	return result;
 }
 
@@ -703,14 +703,14 @@ static void free_listeners(struct vdo_thread *thread)
 
 	for (listener = uds_forget(thread->listeners); listener != NULL; listener = next) {
 		next = uds_forget(listener->next);
-		UDS_FREE(listener);
+		uds_free(listener);
 	}
 }
 
 static void uninitialize_super_block(struct vdo_super_block *super_block)
 {
 	free_vio_components(&super_block->vio);
-	UDS_FREE(super_block->buffer);
+	uds_free(super_block->buffer);
 }
 
 /**
@@ -772,16 +772,16 @@ void vdo_destroy(struct vdo *vdo)
 			free_listeners(&vdo->threads[i]);
 			vdo_free_work_queue(uds_forget(vdo->threads[i].queue));
 		}
-		UDS_FREE(uds_forget(vdo->threads));
+		uds_free(uds_forget(vdo->threads));
 	}
 
 	uninitialize_thread_config(&vdo->thread_config);
 
 	if (vdo->compression_context != NULL) {
 		for (i = 0; i < vdo->device_config->thread_counts.cpu_threads; i++)
-			UDS_FREE(uds_forget(vdo->compression_context[i]));
+			uds_free(uds_forget(vdo->compression_context[i]));
 
-		UDS_FREE(uds_forget(vdo->compression_context));
+		uds_free(uds_forget(vdo->compression_context));
 	}
 
 	/*
@@ -789,7 +789,7 @@ void vdo_destroy(struct vdo *vdo)
 	 * the count goes to zero the VDO object will be freed as a side effect.
 	 */
 	if (!vdo->sysfs_added)
-		UDS_FREE(vdo);
+		uds_free(vdo);
 	else
 		kobject_put(&vdo->vdo_directory);
 }
diff --git a/drivers/md/dm-vdo/vio.c b/drivers/md/dm-vdo/vio.c
index 7fe9b2fbd105..4cc27c3ddb58 100644
--- a/drivers/md/dm-vdo/vio.c
+++ b/drivers/md/dm-vdo/vio.c
@@ -71,7 +71,7 @@ void vdo_free_bio(struct bio *bio)
 		return;
 
 	bio_uninit(bio);
-	UDS_FREE(uds_forget(bio));
+	uds_free(uds_forget(bio));
 }
 
 int allocate_vio_components(struct vdo *vdo,
@@ -146,7 +146,7 @@ int create_multi_block_metadata_vio(struct vdo *vdo,
 
 	result = allocate_vio_components(vdo, vio_type, priority, parent, block_count, data, vio);
 	if (result != VDO_SUCCESS) {
-		UDS_FREE(vio);
+		uds_free(vio);
 		return result;
 	}
 
@@ -174,7 +174,7 @@ void free_vio_components(struct vio *vio)
 void free_vio(struct vio *vio)
 {
 	free_vio_components(vio);
-	UDS_FREE(vio);
+	uds_free(vio);
 }
 
 /* Set bio properties for a VDO read or write. */
@@ -405,8 +405,8 @@ void free_vio_pool(struct vio_pool *pool)
 	ASSERT_LOG_ONLY(pool->size == 0,
 			"VIO pool must not have missing entries when being freed");
 
-	UDS_FREE(uds_forget(pool->buffer));
-	UDS_FREE(pool);
+	uds_free(uds_forget(pool->buffer));
+	uds_free(pool);
 }
 
 /**
diff --git a/drivers/md/dm-vdo/volume-index.c b/drivers/md/dm-vdo/volume-index.c
index ce1dfe4deeca..93f64fd7c09f 100644
--- a/drivers/md/dm-vdo/volume-index.c
+++ b/drivers/md/dm-vdo/volume-index.c
@@ -272,8 +272,8 @@ static int compute_volume_sub_index_parameters(const struct configuration *confi
 
 static void uninitialize_volume_sub_index(struct volume_sub_index *sub_index)
 {
-	UDS_FREE(uds_forget(sub_index->flush_chapters));
-	UDS_FREE(uds_forget(sub_index->zones));
+	uds_free(uds_forget(sub_index->flush_chapters));
+	uds_free(uds_forget(sub_index->zones));
 	uds_uninitialize_delta_index(&sub_index->delta_index);
 }
 
@@ -287,12 +287,12 @@ void uds_free_volume_index(struct volume_index *volume_index)
 
 		for (zone = 0; zone < volume_index->zone_count; zone++)
 			uds_destroy_mutex(&volume_index->zones[zone].hook_mutex);
-		UDS_FREE(uds_forget(volume_index->zones));
+		uds_free(uds_forget(volume_index->zones));
 	}
 
 	uninitialize_volume_sub_index(&volume_index->vi_non_hook);
 	uninitialize_volume_sub_index(&volume_index->vi_hook);
-	UDS_FREE(volume_index);
+	uds_free(volume_index);
 }
 
 
diff --git a/drivers/md/dm-vdo/volume.c b/drivers/md/dm-vdo/volume.c
index 55cf1f68481d..b43ce9814216 100644
--- a/drivers/md/dm-vdo/volume.c
+++ b/drivers/md/dm-vdo/volume.c
@@ -1751,10 +1751,10 @@ static void uninitialize_page_cache(struct page_cache *cache)
 		for (i = 0; i < cache->cache_slots; i++)
 			release_page_buffer(&cache->cache[i]);
 	}
-	UDS_FREE(cache->index);
-	UDS_FREE(cache->cache);
-	UDS_FREE(cache->search_pending_counters);
-	UDS_FREE(cache->read_queue);
+	uds_free(cache->index);
+	uds_free(cache->cache);
+	uds_free(cache->search_pending_counters);
+	uds_free(cache->read_queue);
 }
 
 void uds_free_volume(struct volume *volume)
@@ -1772,7 +1772,7 @@ void uds_free_volume(struct volume *volume)
 		uds_unlock_mutex(&volume->read_threads_mutex);
 		for (i = 0; i < volume->read_thread_count; i++)
 			uds_join_threads(volume->reader_threads[i]);
-		UDS_FREE(volume->reader_threads);
+		uds_free(volume->reader_threads);
 		volume->reader_threads = NULL;
 	}
 
@@ -1787,7 +1787,7 @@ void uds_free_volume(struct volume *volume)
 	uds_destroy_mutex(&volume->read_threads_mutex);
 	uds_free_index_page_map(volume->index_page_map);
 	uds_free_radix_sorter(volume->radix_sorter);
-	UDS_FREE(volume->geometry);
-	UDS_FREE(volume->record_pointers);
-	UDS_FREE(volume);
+	uds_free(volume->geometry);
+	uds_free(volume->record_pointers);
+	uds_free(volume);
 }
-- 
2.40.0

