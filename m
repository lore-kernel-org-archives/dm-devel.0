Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5441A6FD5
	for <dm-devel@lists.linux.dev>; Sat, 11 Nov 2023 04:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LEKnJGHn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699677050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6H6FIGgFMHPsIyngwYwGaXB2kn9KSKKBEylo9WnJje0=;
	b=LEKnJGHn4K2abXHDAvpOpHC2lTaCbgLyRZNvagJNm4F+ms8mA8t4wa6eA3q2/H50Mf68mM
	67l52e+fkfzVvOHvE+/HSL5Gfp8yGwUX/zOI1ULN8pXWxBJJo78kVQhL8Eyb+GHZPG7yg1
	lm9xAv3Buavpeea7TlZ1w8JpoTO3IGs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-bztvXMqZP8GFUJ-owa8C2w-1; Fri, 10 Nov 2023 23:30:46 -0500
X-MC-Unique: bztvXMqZP8GFUJ-owa8C2w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D20A3811E82;
	Sat, 11 Nov 2023 04:30:45 +0000 (UTC)
Received: from pbitcolo-build-10.permabit.com (pbitcolo-build-10.permabit.lab.eng.bos.redhat.com [10.19.117.76])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C2D8940C6EBB;
	Sat, 11 Nov 2023 04:30:45 +0000 (UTC)
Received: by pbitcolo-build-10.permabit.com (Postfix, from userid 1138)
	id 9730D3003C; Fri, 10 Nov 2023 23:30:45 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 4/8] dm vdo memory-alloc: rename UDS_ALLOCATE to uds_allocate
Date: Fri, 10 Nov 2023 23:30:40 -0500
Message-Id: <ac5261d89ffdbe66bf19880431cc8127d39b86c9.1699675570.git.msakai@redhat.com>
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
 drivers/md/dm-vdo-target.c              | 10 +++++-----
 drivers/md/dm-vdo/action-manager.c      |  2 +-
 drivers/md/dm-vdo/block-map.c           | 10 +++++-----
 drivers/md/dm-vdo/chapter-index.c       |  2 +-
 drivers/md/dm-vdo/config.c              |  2 +-
 drivers/md/dm-vdo/dedupe.c              |  2 +-
 drivers/md/dm-vdo/delta-index.c         | 10 +++++-----
 drivers/md/dm-vdo/encodings.c           |  2 +-
 drivers/md/dm-vdo/flush.c               |  4 ++--
 drivers/md/dm-vdo/funnel-queue.c        |  2 +-
 drivers/md/dm-vdo/funnel-requestqueue.c |  2 +-
 drivers/md/dm-vdo/funnel-workqueue.c    |  6 +++---
 drivers/md/dm-vdo/geometry.c            |  2 +-
 drivers/md/dm-vdo/index-layout.c        | 12 ++++++------
 drivers/md/dm-vdo/index-page-map.c      |  8 ++++----
 drivers/md/dm-vdo/index-session.c       |  2 +-
 drivers/md/dm-vdo/index.c               |  6 +++---
 drivers/md/dm-vdo/int-map.c             |  4 ++--
 drivers/md/dm-vdo/io-factory.c          |  6 +++---
 drivers/md/dm-vdo/memory-alloc.c        |  6 +++---
 drivers/md/dm-vdo/memory-alloc.h        |  4 ++--
 drivers/md/dm-vdo/message-stats.c       |  2 +-
 drivers/md/dm-vdo/packer.c              |  2 +-
 drivers/md/dm-vdo/pointer-map.c         |  4 ++--
 drivers/md/dm-vdo/recovery-journal.c    | 14 +++++++-------
 drivers/md/dm-vdo/repair.c              |  8 ++++----
 drivers/md/dm-vdo/slab-depot.c          | 22 +++++++++++-----------
 drivers/md/dm-vdo/slab-depot.h          |  2 +-
 drivers/md/dm-vdo/sparse-cache.c        |  6 +++---
 drivers/md/dm-vdo/uds-sysfs.c           |  2 +-
 drivers/md/dm-vdo/uds-threads.c         |  2 +-
 drivers/md/dm-vdo/vdo.c                 | 22 +++++++++++-----------
 drivers/md/dm-vdo/vio.c                 |  4 ++--
 drivers/md/dm-vdo/volume-index.c        |  8 ++++----
 drivers/md/dm-vdo/volume.c              | 14 +++++++-------
 35 files changed, 108 insertions(+), 108 deletions(-)

diff --git a/drivers/md/dm-vdo-target.c b/drivers/md/dm-vdo-target.c
index f2455895d8ae..efc02c665fa8 100644
--- a/drivers/md/dm-vdo-target.c
+++ b/drivers/md/dm-vdo-target.c
@@ -280,7 +280,7 @@ static int split_string(const char *string, char separator, char ***substring_ar
 		if (*s == separator)
 			substring_count++;
 
-	result = UDS_ALLOCATE(substring_count + 1, char *, "string-splitting array", &substrings);
+	result = uds_allocate(substring_count + 1, char *, "string-splitting array", &substrings);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -288,7 +288,7 @@ static int split_string(const char *string, char separator, char ***substring_ar
 		if (*s == separator) {
 			ptrdiff_t length = s - string;
 
-			result = UDS_ALLOCATE(length + 1,
+			result = uds_allocate(length + 1,
 					      char,
 					      "split string",
 					      &substrings[current_substring]);
@@ -311,7 +311,7 @@ static int split_string(const char *string, char separator, char ***substring_ar
 	BUG_ON(current_substring != (substring_count - 1));
 	length = strlen(string);
 
-	result = UDS_ALLOCATE(length + 1, char, "split string", &substrings[current_substring]);
+	result = uds_allocate(length + 1, char, "split string", &substrings[current_substring]);
 	if (result != UDS_SUCCESS) {
 		free_string_array(substrings);
 		return result;
@@ -339,7 +339,7 @@ join_strings(char **substring_array, size_t array_length, char separator, char *
 	for (i = 0; (i < array_length) && (substring_array[i] != NULL); i++)
 		string_length += strlen(substring_array[i]) + 1;
 
-	result = UDS_ALLOCATE(string_length, char, __func__, &output);
+	result = uds_allocate(string_length, char, __func__, &output);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -733,7 +733,7 @@ static int parse_device_config(int argc,
 		return VDO_BAD_CONFIGURATION;
 	}
 
-	result = UDS_ALLOCATE(1, struct device_config, "device_config", &config);
+	result = uds_allocate(1, struct device_config, "device_config", &config);
 	if (result != VDO_SUCCESS) {
 		handle_parse_error(config, error_ptr, "Could not allocate config structure");
 		return VDO_BAD_CONFIGURATION;
diff --git a/drivers/md/dm-vdo/action-manager.c b/drivers/md/dm-vdo/action-manager.c
index fb3586a4140c..29bdf7df7d75 100644
--- a/drivers/md/dm-vdo/action-manager.c
+++ b/drivers/md/dm-vdo/action-manager.c
@@ -110,7 +110,7 @@ int vdo_make_action_manager(zone_count_t zones,
 			    struct action_manager **manager_ptr)
 {
 	struct action_manager *manager;
-	int result = UDS_ALLOCATE(1, struct action_manager, __func__, &manager);
+	int result = uds_allocate(1, struct action_manager, __func__, &manager);
 
 	if (result != VDO_SUCCESS)
 		return result;
diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index 3ef0f1469ec0..345a9bb32ed9 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -225,7 +225,7 @@ static int __must_check allocate_cache_components(struct vdo_page_cache *cache)
 	u64 size = cache->page_count * (u64) VDO_BLOCK_SIZE;
 	int result;
 
-	result = UDS_ALLOCATE(cache->page_count, struct page_info, "page infos", &cache->infos);
+	result = uds_allocate(cache->page_count, struct page_info, "page infos", &cache->infos);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -2363,19 +2363,19 @@ static int make_segment(struct forest *old_forest,
 
 	forest->segments = index + 1;
 
-	result = UDS_ALLOCATE(forest->segments, struct boundary,
+	result = uds_allocate(forest->segments, struct boundary,
 			      "forest boundary array", &forest->boundaries);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = UDS_ALLOCATE(forest->segments,
+	result = uds_allocate(forest->segments,
 			      struct tree_page *,
 			      "forest page pointers",
 			      &forest->pages);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = UDS_ALLOCATE(new_pages,
+	result = uds_allocate(new_pages,
 			      struct tree_page,
 			      "new forest pages",
 			      &forest->pages[index]);
@@ -2403,7 +2403,7 @@ static int make_segment(struct forest *old_forest,
 		struct block_map_tree *tree = &(forest->trees[root]);
 		height_t height;
 
-		int result = UDS_ALLOCATE(forest->segments,
+		int result = uds_allocate(forest->segments,
 					  struct block_map_tree_segment,
 					  "tree root segments",
 					  &tree->segments);
diff --git a/drivers/md/dm-vdo/chapter-index.c b/drivers/md/dm-vdo/chapter-index.c
index 117a3e041fea..7b52c2de4e48 100644
--- a/drivers/md/dm-vdo/chapter-index.c
+++ b/drivers/md/dm-vdo/chapter-index.c
@@ -20,7 +20,7 @@ int uds_make_open_chapter_index(struct open_chapter_index **chapter_index,
 	size_t memory_size;
 	struct open_chapter_index *index;
 
-	result = UDS_ALLOCATE(1, struct open_chapter_index, "open chapter index", &index);
+	result = uds_allocate(1, struct open_chapter_index, "open chapter index", &index);
 	if (result != UDS_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/config.c b/drivers/md/dm-vdo/config.c
index 09a2d9891099..89b1eef486b3 100644
--- a/drivers/md/dm-vdo/config.c
+++ b/drivers/md/dm-vdo/config.c
@@ -334,7 +334,7 @@ int uds_make_configuration(const struct uds_parameters *params, struct configura
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = UDS_ALLOCATE(1, struct configuration, __func__, &config);
+	result = uds_allocate(1, struct configuration, __func__, &config);
 	if (result != UDS_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index 844d0f3ab3ca..1792cebf9529 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -2407,7 +2407,7 @@ initialize_zone(struct vdo *vdo, struct hash_zones *zones, zone_count_t zone_num
 				    timeout_index_operations_callback,
 				    zone->thread_id);
 	INIT_LIST_HEAD(&zone->lock_pool);
-	result = UDS_ALLOCATE(LOCK_POOL_CAPACITY,
+	result = uds_allocate(LOCK_POOL_CAPACITY,
 			      struct hash_lock,
 			      "hash_lock array",
 			      &zone->lock_array);
diff --git a/drivers/md/dm-vdo/delta-index.c b/drivers/md/dm-vdo/delta-index.c
index c639b0c8bf8d..08504535817c 100644
--- a/drivers/md/dm-vdo/delta-index.c
+++ b/drivers/md/dm-vdo/delta-index.c
@@ -329,16 +329,16 @@ static int initialize_delta_zone(struct delta_zone *delta_zone,
 {
 	int result;
 
-	result = UDS_ALLOCATE(size, u8, "delta list", &delta_zone->memory);
+	result = uds_allocate(size, u8, "delta list", &delta_zone->memory);
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = UDS_ALLOCATE(list_count + 2, u64, "delta list temp", &delta_zone->new_offsets);
+	result = uds_allocate(list_count + 2, u64, "delta list temp", &delta_zone->new_offsets);
 	if (result != UDS_SUCCESS)
 		return result;
 
 	/* Allocate the delta lists. */
-	result = UDS_ALLOCATE(list_count + 2,
+	result = uds_allocate(list_count + 2,
 			      struct delta_list,
 			      "delta lists",
 			      &delta_zone->delta_lists);
@@ -377,7 +377,7 @@ int uds_initialize_delta_index(struct delta_index *delta_index,
 	unsigned int z;
 	size_t zone_memory;
 
-	result = UDS_ALLOCATE(zone_count,
+	result = uds_allocate(zone_count,
 			      struct delta_zone,
 			      "Delta Index Zones",
 			      &delta_index->delta_zones);
@@ -1084,7 +1084,7 @@ int uds_finish_restoring_delta_index(struct delta_index *delta_index,
 	unsigned int z;
 	u8 *data;
 
-	result = UDS_ALLOCATE(DELTA_LIST_MAX_BYTE_COUNT, u8, __func__, &data);
+	result = uds_allocate(DELTA_LIST_MAX_BYTE_COUNT, u8, __func__, &data);
 	if (result != UDS_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/encodings.c b/drivers/md/dm-vdo/encodings.c
index d4abb7e2829e..b1d78e025423 100644
--- a/drivers/md/dm-vdo/encodings.c
+++ b/drivers/md/dm-vdo/encodings.c
@@ -800,7 +800,7 @@ static int allocate_partition(struct layout *layout,
 	struct partition *partition;
 	int result;
 
-	result = UDS_ALLOCATE(1, struct partition, __func__, &partition);
+	result = uds_allocate(1, struct partition, __func__, &partition);
 	if (result != UDS_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/flush.c b/drivers/md/dm-vdo/flush.c
index 5bcbcb01703b..54b9ed80ca47 100644
--- a/drivers/md/dm-vdo/flush.c
+++ b/drivers/md/dm-vdo/flush.c
@@ -106,7 +106,7 @@ static void *allocate_flush(gfp_t gfp_mask, void *pool_data)
 	if ((gfp_mask & GFP_NOWAIT) == GFP_NOWAIT) {
 		flush = uds_allocate_memory_nowait(sizeof(struct vdo_flush), __func__);
 	} else {
-		int result = UDS_ALLOCATE(1, struct vdo_flush, __func__, &flush);
+		int result = uds_allocate(1, struct vdo_flush, __func__, &flush);
 
 		if (result != VDO_SUCCESS)
 			uds_log_error_strerror(result, "failed to allocate spare flush");
@@ -134,7 +134,7 @@ static void free_flush(void *element, void *pool_data __always_unused)
  */
 int vdo_make_flusher(struct vdo *vdo)
 {
-	int result = UDS_ALLOCATE(1, struct flusher, __func__, &vdo->flusher);
+	int result = uds_allocate(1, struct flusher, __func__, &vdo->flusher);
 
 	if (result != VDO_SUCCESS)
 		return result;
diff --git a/drivers/md/dm-vdo/funnel-queue.c b/drivers/md/dm-vdo/funnel-queue.c
index 92809607e4d6..c5997750820c 100644
--- a/drivers/md/dm-vdo/funnel-queue.c
+++ b/drivers/md/dm-vdo/funnel-queue.c
@@ -15,7 +15,7 @@ int uds_make_funnel_queue(struct funnel_queue **queue_ptr)
 	int result;
 	struct funnel_queue *queue;
 
-	result = UDS_ALLOCATE(1, struct funnel_queue, "funnel queue", &queue);
+	result = uds_allocate(1, struct funnel_queue, "funnel queue", &queue);
 	if (result != UDS_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/funnel-requestqueue.c b/drivers/md/dm-vdo/funnel-requestqueue.c
index b90982393843..8d12feb035b3 100644
--- a/drivers/md/dm-vdo/funnel-requestqueue.c
+++ b/drivers/md/dm-vdo/funnel-requestqueue.c
@@ -201,7 +201,7 @@ int uds_make_request_queue(const char *queue_name,
 	int result;
 	struct uds_request_queue *queue;
 
-	result = UDS_ALLOCATE(1, struct uds_request_queue, __func__, &queue);
+	result = uds_allocate(1, struct uds_request_queue, __func__, &queue);
 	if (result != UDS_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/funnel-workqueue.c b/drivers/md/dm-vdo/funnel-workqueue.c
index ff86a4cfb323..7f5cc0114329 100644
--- a/drivers/md/dm-vdo/funnel-workqueue.c
+++ b/drivers/md/dm-vdo/funnel-workqueue.c
@@ -328,7 +328,7 @@ static int make_simple_work_queue(const char *thread_name_prefix,
 			type->max_priority,
 			VDO_WORK_Q_MAX_PRIORITY);
 
-	result = UDS_ALLOCATE(1, struct simple_work_queue, "simple work queue", &queue);
+	result = uds_allocate(1, struct simple_work_queue, "simple work queue", &queue);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -414,11 +414,11 @@ int vdo_make_work_queue(const char *thread_name_prefix,
 		return result;
 	}
 
-	result = UDS_ALLOCATE(1, struct round_robin_work_queue, "round-robin work queue", &queue);
+	result = uds_allocate(1, struct round_robin_work_queue, "round-robin work queue", &queue);
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = UDS_ALLOCATE(thread_count,
+	result = uds_allocate(thread_count,
 			      struct simple_work_queue *,
 			      "subordinate work queues",
 			      &queue->service_queues);
diff --git a/drivers/md/dm-vdo/geometry.c b/drivers/md/dm-vdo/geometry.c
index 0ff717cb72f6..ceed4928dca1 100644
--- a/drivers/md/dm-vdo/geometry.c
+++ b/drivers/md/dm-vdo/geometry.c
@@ -63,7 +63,7 @@ int uds_make_geometry(size_t bytes_per_page,
 	int result;
 	struct geometry *geometry;
 
-	result = UDS_ALLOCATE(1, struct geometry, "geometry", &geometry);
+	result = uds_allocate(1, struct geometry, "geometry", &geometry);
 	if (result != UDS_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/index-layout.c b/drivers/md/dm-vdo/index-layout.c
index 3e9fa7028358..cfeeeced35a0 100644
--- a/drivers/md/dm-vdo/index-layout.c
+++ b/drivers/md/dm-vdo/index-layout.c
@@ -554,7 +554,7 @@ static int __must_check write_index_save_header(struct index_save_layout *isl,
 	u8 *buffer;
 	size_t offset = 0;
 
-	result = UDS_ALLOCATE(table->encoded_size, u8, "index save data", &buffer);
+	result = uds_allocate(table->encoded_size, u8, "index save data", &buffer);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -723,7 +723,7 @@ static int __must_check write_layout_header(struct index_layout *layout,
 	u8 *buffer;
 	size_t offset = 0;
 
-	result = UDS_ALLOCATE(table->encoded_size, u8, "layout data", &buffer);
+	result = uds_allocate(table->encoded_size, u8, "layout data", &buffer);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -813,7 +813,7 @@ static int create_index_layout(struct index_layout *layout, struct configuration
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = UDS_ALLOCATE(sizes.save_count,
+	result = uds_allocate(sizes.save_count,
 			      struct index_save_layout,
 			      __func__,
 			      &layout->index.saves);
@@ -1217,7 +1217,7 @@ static int __must_check read_super_block_data(struct buffered_reader *reader,
 	u8 *buffer;
 	size_t offset = 0;
 
-	result = UDS_ALLOCATE(saved_size, u8, "super block data", &buffer);
+	result = uds_allocate(saved_size, u8, "super block data", &buffer);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -1344,7 +1344,7 @@ reconstitute_layout(struct index_layout *layout, struct region_table *table, u64
 	int result;
 	u64 next_block = first_block;
 
-	result = UDS_ALLOCATE(layout->super.max_saves,
+	result = uds_allocate(layout->super.max_saves,
 			      struct index_save_layout,
 			      __func__,
 			      &layout->index.saves);
@@ -1708,7 +1708,7 @@ int uds_make_index_layout(struct configuration *config,
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = UDS_ALLOCATE(1, struct index_layout, __func__, &layout);
+	result = uds_allocate(1, struct index_layout, __func__, &layout);
 	if (result != UDS_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/index-page-map.c b/drivers/md/dm-vdo/index-page-map.c
index 93c6a2235682..b8e0885ac9cd 100644
--- a/drivers/md/dm-vdo/index-page-map.c
+++ b/drivers/md/dm-vdo/index-page-map.c
@@ -38,13 +38,13 @@ int uds_make_index_page_map(const struct geometry *geometry, struct index_page_m
 	int result;
 	struct index_page_map *map;
 
-	result = UDS_ALLOCATE(1, struct index_page_map, "page map", &map);
+	result = uds_allocate(1, struct index_page_map, "page map", &map);
 	if (result != UDS_SUCCESS)
 		return result;
 
 	map->geometry = geometry;
 	map->entries_per_chapter = geometry->index_pages_per_chapter - 1;
-	result = UDS_ALLOCATE(get_entry_count(geometry),
+	result = uds_allocate(get_entry_count(geometry),
 			      u16,
 			      "Index Page Map Entries",
 			      &map->entries);
@@ -126,7 +126,7 @@ int uds_write_index_page_map(struct index_page_map *map, struct buffered_writer
 	u64 saved_size = uds_compute_index_page_map_save_size(map->geometry);
 	u32 i;
 
-	result = UDS_ALLOCATE(saved_size, u8, "page map data", &buffer);
+	result = uds_allocate(saved_size, u8, "page map data", &buffer);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -153,7 +153,7 @@ int uds_read_index_page_map(struct index_page_map *map, struct buffered_reader *
 	u64 saved_size = uds_compute_index_page_map_save_size(map->geometry);
 	u32 i;
 
-	result = UDS_ALLOCATE(saved_size, u8, "page map data", &buffer);
+	result = uds_allocate(saved_size, u8, "page map data", &buffer);
 	if (result != UDS_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/index-session.c b/drivers/md/dm-vdo/index-session.c
index d15ec2b339ef..78dd9616a9d5 100644
--- a/drivers/md/dm-vdo/index-session.c
+++ b/drivers/md/dm-vdo/index-session.c
@@ -218,7 +218,7 @@ static int __must_check make_empty_index_session(struct uds_index_session **inde
 	int result;
 	struct uds_index_session *session;
 
-	result = UDS_ALLOCATE(1, struct uds_index_session, __func__, &session);
+	result = uds_allocate(1, struct uds_index_session, __func__, &session);
 	if (result != UDS_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/index.c b/drivers/md/dm-vdo/index.c
index ff0239c361a8..410c0eedb01b 100644
--- a/drivers/md/dm-vdo/index.c
+++ b/drivers/md/dm-vdo/index.c
@@ -88,7 +88,7 @@ launch_zone_message(struct uds_zone_message message, unsigned int zone, struct u
 	int result;
 	struct uds_request *request;
 
-	result = UDS_ALLOCATE(1, struct uds_request, __func__, &request);
+	result = uds_allocate(1, struct uds_request, __func__, &request);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -1137,7 +1137,7 @@ static int make_index_zone(struct uds_index *index, unsigned int zone_number)
 	int result;
 	struct index_zone *zone;
 
-	result = UDS_ALLOCATE(1, struct index_zone, "index zone", &zone);
+	result = uds_allocate(1, struct index_zone, "index zone", &zone);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -1194,7 +1194,7 @@ int uds_make_index(struct configuration *config,
 		return result;
 	}
 
-	result = UDS_ALLOCATE(index->zone_count, struct index_zone *, "zones", &index->zones);
+	result = uds_allocate(index->zone_count, struct index_zone *, "zones", &index->zones);
 	if (result != UDS_SUCCESS) {
 		uds_free_index(index);
 		return result;
diff --git a/drivers/md/dm-vdo/int-map.c b/drivers/md/dm-vdo/int-map.c
index 1c1195451d05..323e5c1ac346 100644
--- a/drivers/md/dm-vdo/int-map.c
+++ b/drivers/md/dm-vdo/int-map.c
@@ -166,7 +166,7 @@ static int allocate_buckets(struct int_map *map, size_t capacity)
 	 * without have to wrap back around to element zero.
 	 */
 	map->bucket_count = capacity + (NEIGHBORHOOD - 1);
-	return UDS_ALLOCATE(map->bucket_count, struct bucket,
+	return uds_allocate(map->bucket_count, struct bucket,
 			    "struct int_map buckets", &map->buckets);
 }
 
@@ -192,7 +192,7 @@ int vdo_make_int_map(size_t initial_capacity, unsigned int initial_load, struct
 	if (initial_load > 100)
 		return UDS_INVALID_ARGUMENT;
 
-	result = UDS_ALLOCATE(1, struct int_map, "struct int_map", &map);
+	result = uds_allocate(1, struct int_map, "struct int_map", &map);
 	if (result != UDS_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/io-factory.c b/drivers/md/dm-vdo/io-factory.c
index 90159fb5eaa7..d929e556f330 100644
--- a/drivers/md/dm-vdo/io-factory.c
+++ b/drivers/md/dm-vdo/io-factory.c
@@ -64,7 +64,7 @@ int uds_make_io_factory(struct block_device *bdev, struct io_factory **factory_p
 	int result;
 	struct io_factory *factory;
 
-	result = UDS_ALLOCATE(1, struct io_factory, __func__, &factory);
+	result = uds_allocate(1, struct io_factory, __func__, &factory);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -154,7 +154,7 @@ int uds_make_buffered_reader(struct io_factory *factory,
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = UDS_ALLOCATE(1, struct buffered_reader, "buffered reader", &reader);
+	result = uds_allocate(1, struct buffered_reader, "buffered reader", &reader);
 	if (result != UDS_SUCCESS) {
 		dm_bufio_client_destroy(client);
 		return result;
@@ -291,7 +291,7 @@ int uds_make_buffered_writer(struct io_factory *factory,
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = UDS_ALLOCATE(1, struct buffered_writer, "buffered writer", &writer);
+	result = uds_allocate(1, struct buffered_writer, "buffered writer", &writer);
 	if (result != UDS_SUCCESS) {
 		dm_bufio_client_destroy(client);
 		return result;
diff --git a/drivers/md/dm-vdo/memory-alloc.c b/drivers/md/dm-vdo/memory-alloc.c
index 73f841289f9e..81069698dd5a 100644
--- a/drivers/md/dm-vdo/memory-alloc.c
+++ b/drivers/md/dm-vdo/memory-alloc.c
@@ -246,7 +246,7 @@ int uds_allocate_memory(size_t size, size_t align, const char *what, void *ptr)
 	} else {
 		struct vmalloc_block_info *block;
 
-		if (UDS_ALLOCATE(1, struct vmalloc_block_info, __func__, &block) ==
+		if (uds_allocate(1, struct vmalloc_block_info, __func__, &block) ==
 		    UDS_SUCCESS) {
 			/*
 			 * It is possible for __vmalloc to fail to allocate memory because there
@@ -354,7 +354,7 @@ int uds_reallocate_memory(void *ptr, size_t old_size, size_t size, const char *w
 		return UDS_SUCCESS;
 	}
 
-	result = UDS_ALLOCATE(size, char, what, new_ptr);
+	result = uds_allocate(size, char, what, new_ptr);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -374,7 +374,7 @@ int uds_duplicate_string(const char *string, const char *what, char **new_string
 	int result;
 	u8 *dup;
 
-	result = UDS_ALLOCATE(strlen(string) + 1, u8, what, &dup);
+	result = uds_allocate(strlen(string) + 1, u8, what, &dup);
 	if (result != UDS_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/memory-alloc.h b/drivers/md/dm-vdo/memory-alloc.h
index 03d8f69f6cdc..8b750b4751e9 100644
--- a/drivers/md/dm-vdo/memory-alloc.h
+++ b/drivers/md/dm-vdo/memory-alloc.h
@@ -18,7 +18,7 @@ int __must_check uds_allocate_memory(size_t size, size_t align, const char *what
 
 void uds_free_memory(void *ptr);
 
-/* Free memory allocated with UDS_ALLOCATE(). */
+/* Free memory allocated with uds_allocate(). */
 #define uds_free(PTR) uds_free_memory(PTR)
 
 static inline void *__uds_forget(void **ptr_ptr)
@@ -96,7 +96,7 @@ int __must_check uds_reallocate_memory(void *ptr,
  *
  * Return: UDS_SUCCESS or an error code
  */
-#define UDS_ALLOCATE(COUNT, TYPE, WHAT, PTR) \
+#define uds_allocate(COUNT, TYPE, WHAT, PTR) \
 	uds_do_allocation(COUNT, sizeof(TYPE), 0, __alignof__(TYPE), WHAT, PTR)
 
 /*
diff --git a/drivers/md/dm-vdo/message-stats.c b/drivers/md/dm-vdo/message-stats.c
index 7910576f8b57..5be8503ed96e 100644
--- a/drivers/md/dm-vdo/message-stats.c
+++ b/drivers/md/dm-vdo/message-stats.c
@@ -1204,7 +1204,7 @@ int vdo_write_stats(struct vdo *vdo,
 	struct vdo_statistics *stats;
 	int result;
 
-	result = UDS_ALLOCATE(1, struct vdo_statistics, __func__, &stats);
+	result = uds_allocate(1, struct vdo_statistics, __func__, &stats);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/packer.c b/drivers/md/dm-vdo/packer.c
index d06e654fc9e5..4d689d4c6a41 100644
--- a/drivers/md/dm-vdo/packer.c
+++ b/drivers/md/dm-vdo/packer.c
@@ -152,7 +152,7 @@ int vdo_make_packer(struct vdo *vdo, block_count_t bin_count, struct packer **pa
 	block_count_t i;
 	int result;
 
-	result = UDS_ALLOCATE(1, struct packer, __func__, &packer);
+	result = uds_allocate(1, struct packer, __func__, &packer);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/pointer-map.c b/drivers/md/dm-vdo/pointer-map.c
index 64e6f8ef4541..87f7e6614ba3 100644
--- a/drivers/md/dm-vdo/pointer-map.c
+++ b/drivers/md/dm-vdo/pointer-map.c
@@ -125,7 +125,7 @@ static int allocate_buckets(struct pointer_map *map, size_t capacity)
 	 * without have to wrap back around to element zero.
 	 */
 	map->bucket_count = capacity + (NEIGHBORHOOD - 1);
-	return UDS_ALLOCATE(map->bucket_count,
+	return uds_allocate(map->bucket_count,
 			    struct bucket,
 			    "pointer_map buckets",
 			    &map->buckets);
@@ -159,7 +159,7 @@ int vdo_make_pointer_map(size_t initial_capacity,
 	if (initial_load > 100)
 		return UDS_INVALID_ARGUMENT;
 
-	result = UDS_ALLOCATE(1, struct pointer_map, "pointer_map", &map);
+	result = uds_allocate(1, struct pointer_map, "pointer_map", &map);
 	if (result != UDS_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/recovery-journal.c b/drivers/md/dm-vdo/recovery-journal.c
index 157a6f3c5131..6b96a6ccece7 100644
--- a/drivers/md/dm-vdo/recovery-journal.c
+++ b/drivers/md/dm-vdo/recovery-journal.c
@@ -592,36 +592,36 @@ static int __must_check initialize_lock_counter(struct recovery_journal *journal
 	struct thread_config *config = &vdo->thread_config;
 	struct lock_counter *counter = &journal->lock_counter;
 
-	result = UDS_ALLOCATE(journal->size, u16, __func__, &counter->journal_counters);
+	result = uds_allocate(journal->size, u16, __func__, &counter->journal_counters);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = UDS_ALLOCATE(journal->size,
+	result = uds_allocate(journal->size,
 			      atomic_t,
 			      __func__,
 			      &counter->journal_decrement_counts);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = UDS_ALLOCATE(journal->size * config->logical_zone_count,
+	result = uds_allocate(journal->size * config->logical_zone_count,
 			      u16,
 			      __func__,
 			      &counter->logical_counters);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = UDS_ALLOCATE(journal->size, atomic_t, __func__, &counter->logical_zone_counts);
+	result = uds_allocate(journal->size, atomic_t, __func__, &counter->logical_zone_counts);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = UDS_ALLOCATE(journal->size * config->physical_zone_count,
+	result = uds_allocate(journal->size * config->physical_zone_count,
 			      u16,
 			      __func__,
 			      &counter->physical_counters);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = UDS_ALLOCATE(journal->size, atomic_t, __func__, &counter->physical_zone_counts);
+	result = uds_allocate(journal->size, atomic_t, __func__, &counter->physical_zone_counts);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -677,7 +677,7 @@ static int initialize_recovery_block(struct vdo *vdo,
 	 * Allocate a full block for the journal block even though not all of the space is used
 	 * since the VIO needs to write a full disk block.
 	 */
-	result = UDS_ALLOCATE(VDO_BLOCK_SIZE, char, __func__, &data);
+	result = uds_allocate(VDO_BLOCK_SIZE, char, __func__, &data);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
index 956a98166cf5..d9613e7b7e9e 100644
--- a/drivers/md/dm-vdo/repair.c
+++ b/drivers/md/dm-vdo/repair.c
@@ -1432,7 +1432,7 @@ static int parse_journal_for_rebuild(struct repair_completion *repair)
 	 * packed_recovery_journal_entry from every valid journal block.
 	 */
 	count = ((repair->highest_tail - repair->block_map_head + 1) * entries_per_block);
-	result = UDS_ALLOCATE(count, struct numbered_block_mapping, __func__, &repair->entries);
+	result = uds_allocate(count, struct numbered_block_mapping, __func__, &repair->entries);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -1477,7 +1477,7 @@ static int extract_new_mappings(struct repair_completion *repair)
 	 * Allocate an array of numbered_block_mapping structs just large enough to transcribe
 	 * every packed_recovery_journal_entry from every valid journal block.
 	 */
-	result = UDS_ALLOCATE(repair->entry_count,
+	result = uds_allocate(repair->entry_count,
 			      struct numbered_block_mapping,
 			      __func__,
 			      &repair->entries);
@@ -1738,11 +1738,11 @@ void vdo_repair(struct vdo_completion *parent)
 	prepare_repair_completion(repair, finish_repair, VDO_ZONE_TYPE_ADMIN);
 	repair->page_count = page_count;
 
-	result = UDS_ALLOCATE(remaining * VDO_BLOCK_SIZE, char, __func__, &repair->journal_data);
+	result = uds_allocate(remaining * VDO_BLOCK_SIZE, char, __func__, &repair->journal_data);
 	if (abort_on_error(result, repair))
 		return;
 
-	result = UDS_ALLOCATE(vio_count, struct vio, __func__, &repair->vios);
+	result = uds_allocate(vio_count, struct vio, __func__, &repair->vios);
 	if (abort_on_error(result, repair))
 		return;
 
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 15df2a6bb14a..53df3fac82bd 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -2425,7 +2425,7 @@ static int allocate_slab_counters(struct vdo_slab *slab)
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = UDS_ALLOCATE(slab->reference_block_count,
+	result = uds_allocate(slab->reference_block_count,
 			      struct reference_block,
 			      __func__,
 			      &slab->reference_blocks);
@@ -2437,7 +2437,7 @@ static int allocate_slab_counters(struct vdo_slab *slab)
 	 * so we can word-search even at the very end.
 	 */
 	bytes = (slab->reference_block_count * COUNTS_PER_BLOCK) + (2 * BYTES_PER_WORD);
-	result = UDS_ALLOCATE(bytes, vdo_refcount_t, "ref counts array", &slab->counters);
+	result = uds_allocate(bytes, vdo_refcount_t, "ref counts array", &slab->counters);
 	if (result != UDS_SUCCESS) {
 		uds_free(uds_forget(slab->reference_blocks));
 		return result;
@@ -3549,7 +3549,7 @@ get_slab_statuses(struct block_allocator *allocator, struct slab_status **status
 	struct slab_status *statuses;
 	struct slab_iterator iterator = get_slab_iterator(allocator);
 
-	result = UDS_ALLOCATE(allocator->slab_count, struct slab_status, __func__, &statuses);
+	result = uds_allocate(allocator->slab_count, struct slab_status, __func__, &statuses);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -3726,14 +3726,14 @@ static int initialize_slab_journal(struct vdo_slab *slab)
 	const struct slab_config *slab_config = &slab->allocator->depot->slab_config;
 	int result;
 
-	result = UDS_ALLOCATE(slab_config->slab_journal_blocks,
+	result = uds_allocate(slab_config->slab_journal_blocks,
 			      struct journal_lock,
 			      __func__,
 			      &journal->locks);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = UDS_ALLOCATE(VDO_BLOCK_SIZE,
+	result = uds_allocate(VDO_BLOCK_SIZE,
 			      char,
 			      "struct packed_slab_journal_block",
 			      (char **) &journal->block);
@@ -3793,7 +3793,7 @@ make_slab(physical_block_number_t slab_origin,
 	struct vdo_slab *slab;
 	int result;
 
-	result = UDS_ALLOCATE(1, struct vdo_slab, __func__, &slab);
+	result = uds_allocate(1, struct vdo_slab, __func__, &slab);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -3849,7 +3849,7 @@ static int allocate_slabs(struct slab_depot *depot, slab_count_t slab_count)
 	physical_block_number_t slab_origin;
 	int result;
 
-	result = UDS_ALLOCATE(slab_count,
+	result = uds_allocate(slab_count,
 			      struct vdo_slab *,
 			      "slab pointer array",
 			      &depot->new_slabs);
@@ -4010,7 +4010,7 @@ static int initialize_slab_scrubber(struct block_allocator *allocator)
 	char *journal_data;
 	int result;
 
-	result = UDS_ALLOCATE(VDO_BLOCK_SIZE * slab_journal_size, char, __func__, &journal_data);
+	result = uds_allocate(VDO_BLOCK_SIZE * slab_journal_size, char, __func__, &journal_data);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -4045,7 +4045,7 @@ initialize_slab_summary_block(struct block_allocator *allocator, block_count_t i
 	struct slab_summary_block *block = &allocator->summary_blocks[index];
 	int result;
 
-	result = UDS_ALLOCATE(VDO_BLOCK_SIZE, char, __func__, &block->outgoing_entries);
+	result = uds_allocate(VDO_BLOCK_SIZE, char, __func__, &block->outgoing_entries);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -4109,7 +4109,7 @@ static int __must_check initialize_block_allocator(struct slab_depot *depot, zon
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = UDS_ALLOCATE(VDO_SLAB_SUMMARY_BLOCKS_PER_ZONE,
+	result = uds_allocate(VDO_SLAB_SUMMARY_BLOCKS_PER_ZONE,
 			      struct slab_summary_block,
 			      __func__,
 			      &allocator->summary_blocks);
@@ -4172,7 +4172,7 @@ static int allocate_components(struct slab_depot *depot,
 
 	depot->summary_origin = summary_partition->offset;
 	depot->hint_shift = vdo_get_slab_summary_hint_shift(depot->slab_size_shift);
-	result = UDS_ALLOCATE(MAXIMUM_VDO_SLAB_SUMMARY_ENTRIES,
+	result = uds_allocate(MAXIMUM_VDO_SLAB_SUMMARY_ENTRIES,
 			      struct slab_summary_entry,
 			      __func__,
 			      &depot->summary_entries);
diff --git a/drivers/md/dm-vdo/slab-depot.h b/drivers/md/dm-vdo/slab-depot.h
index 44655d697fa0..01bc9b60de4f 100644
--- a/drivers/md/dm-vdo/slab-depot.h
+++ b/drivers/md/dm-vdo/slab-depot.h
@@ -235,7 +235,7 @@ struct vdo_slab {
 	/* The number of free blocks */
 	u32 free_blocks;
 	/* The array of reference counts */
-	vdo_refcount_t *counters; /* use UDS_ALLOCATE to align data ptr */
+	vdo_refcount_t *counters; /* use uds_allocate() to align data ptr */
 
 	/* The saved block pointer and array indexes for the free block search */
 	struct search_cursor search_cursor;
diff --git a/drivers/md/dm-vdo/sparse-cache.c b/drivers/md/dm-vdo/sparse-cache.c
index 5895b283c8e6..fa8ed2073d82 100644
--- a/drivers/md/dm-vdo/sparse-cache.c
+++ b/drivers/md/dm-vdo/sparse-cache.c
@@ -165,14 +165,14 @@ initialize_cached_chapter_index(struct cached_chapter_index *chapter,
 	chapter->virtual_chapter = NO_CHAPTER;
 	chapter->index_pages_count = geometry->index_pages_per_chapter;
 
-	result = UDS_ALLOCATE(chapter->index_pages_count,
+	result = uds_allocate(chapter->index_pages_count,
 			      struct delta_index_page,
 			      __func__,
 			      &chapter->index_pages);
 	if (result != UDS_SUCCESS)
 		return result;
 
-	return UDS_ALLOCATE(chapter->index_pages_count,
+	return uds_allocate(chapter->index_pages_count,
 			    struct dm_buffer *,
 			    "sparse index volume pages",
 			    &chapter->page_buffers);
@@ -255,7 +255,7 @@ int uds_make_sparse_cache(const struct geometry *geometry,
 	}
 
 	/* purge_search_list() needs some temporary lists for sorting. */
-	result = UDS_ALLOCATE(capacity * 2,
+	result = uds_allocate(capacity * 2,
 			      struct cached_chapter_index *,
 			      "scratch entries",
 			      &cache->scratch_entries);
diff --git a/drivers/md/dm-vdo/uds-sysfs.c b/drivers/md/dm-vdo/uds-sysfs.c
index 71dfaf49780d..2657fa8c20b4 100644
--- a/drivers/md/dm-vdo/uds-sysfs.c
+++ b/drivers/md/dm-vdo/uds-sysfs.c
@@ -34,7 +34,7 @@ static char *buffer_to_string(const char *buf, size_t length)
 {
 	char *string;
 
-	if (UDS_ALLOCATE(length + 1, char, __func__, &string) != UDS_SUCCESS)
+	if (uds_allocate(length + 1, char, __func__, &string) != UDS_SUCCESS)
 		return NULL;
 
 	memcpy(string, buf, length);
diff --git a/drivers/md/dm-vdo/uds-threads.c b/drivers/md/dm-vdo/uds-threads.c
index 2552263f1b3d..a8c073cfa790 100644
--- a/drivers/md/dm-vdo/uds-threads.c
+++ b/drivers/md/dm-vdo/uds-threads.c
@@ -85,7 +85,7 @@ int uds_create_thread(void (*thread_function)(void *),
 	struct thread *thread;
 	int result;
 
-	result = UDS_ALLOCATE(1, struct thread, __func__, &thread);
+	result = uds_allocate(1, struct thread, __func__, &thread);
 	if (result != UDS_SUCCESS) {
 		uds_log_warning("Error allocating memory for %s", name);
 		return result;
diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index 6c9d62f899b3..29234c509664 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -215,7 +215,7 @@ initialize_thread_config(struct thread_count_config counts, struct thread_config
 		config->hash_zone_count = counts.hash_zones;
 	}
 
-	result = UDS_ALLOCATE(config->logical_zone_count,
+	result = uds_allocate(config->logical_zone_count,
 			      thread_id_t,
 			      "logical thread array",
 			      &config->logical_threads);
@@ -224,7 +224,7 @@ initialize_thread_config(struct thread_count_config counts, struct thread_config
 		return result;
 	}
 
-	result = UDS_ALLOCATE(config->physical_zone_count,
+	result = uds_allocate(config->physical_zone_count,
 			      thread_id_t,
 			      "physical thread array",
 			      &config->physical_threads);
@@ -233,7 +233,7 @@ initialize_thread_config(struct thread_count_config counts, struct thread_config
 		return result;
 	}
 
-	result = UDS_ALLOCATE(config->hash_zone_count,
+	result = uds_allocate(config->hash_zone_count,
 			      thread_id_t,
 			      "hash thread array",
 			      &config->hash_zone_threads);
@@ -242,7 +242,7 @@ initialize_thread_config(struct thread_count_config counts, struct thread_config
 		return result;
 	}
 
-	result = UDS_ALLOCATE(config->bio_thread_count,
+	result = uds_allocate(config->bio_thread_count,
 			      thread_id_t,
 			      "bio thread array",
 			      &config->bio_threads);
@@ -285,7 +285,7 @@ static int __must_check read_geometry_block(struct vdo *vdo)
 	char *block;
 	int result;
 
-	result = UDS_ALLOCATE(VDO_BLOCK_SIZE, u8, __func__, &block);
+	result = uds_allocate(VDO_BLOCK_SIZE, u8, __func__, &block);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -531,7 +531,7 @@ initialize_vdo(struct vdo *vdo, struct device_config *config, unsigned int insta
 		     vdo->thread_config.thread_count);
 
 	/* Compression context storage */
-	result = UDS_ALLOCATE(config->thread_counts.cpu_threads,
+	result = uds_allocate(config->thread_counts.cpu_threads,
 			      char *,
 			      "LZ4 context",
 			      &vdo->compression_context);
@@ -541,7 +541,7 @@ initialize_vdo(struct vdo *vdo, struct device_config *config, unsigned int insta
 	}
 
 	for (i = 0; i < config->thread_counts.cpu_threads; i++) {
-		result = UDS_ALLOCATE(LZ4_MEM_COMPRESS,
+		result = uds_allocate(LZ4_MEM_COMPRESS,
 				      char,
 				      "LZ4 context",
 				      &vdo->compression_context[i]);
@@ -581,7 +581,7 @@ int vdo_make(unsigned int instance,
 	/* VDO-3769 - Set a generic reason so we don't ever return garbage. */
 	*reason = "Unspecified error";
 
-	result = UDS_ALLOCATE(1, struct vdo, __func__, &vdo);
+	result = uds_allocate(1, struct vdo, __func__, &vdo);
 	if (result != UDS_SUCCESS) {
 		*reason = "Cannot allocate VDO";
 		return result;
@@ -602,7 +602,7 @@ int vdo_make(unsigned int instance,
 		 MODULE_NAME,
 		 instance);
 	BUG_ON(vdo->thread_name_prefix[0] == '\0');
-	result = UDS_ALLOCATE(vdo->thread_config.thread_count,
+	result = uds_allocate(vdo->thread_config.thread_count,
 			      struct vdo_thread,
 			      __func__,
 			      &vdo->threads);
@@ -798,7 +798,7 @@ static int initialize_super_block(struct vdo *vdo, struct vdo_super_block *super
 {
 	int result;
 
-	result = UDS_ALLOCATE(VDO_BLOCK_SIZE,
+	result = uds_allocate(VDO_BLOCK_SIZE,
 			      char,
 			      "encoded super block",
 			      (char **) &vdo->super_block.buffer);
@@ -1111,7 +1111,7 @@ int vdo_register_read_only_listener(struct vdo *vdo,
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = UDS_ALLOCATE(1, struct read_only_listener, __func__, &read_only_listener);
+	result = uds_allocate(1, struct read_only_listener, __func__, &read_only_listener);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/vio.c b/drivers/md/dm-vdo/vio.c
index 4cc27c3ddb58..10fcfd93e782 100644
--- a/drivers/md/dm-vdo/vio.c
+++ b/drivers/md/dm-vdo/vio.c
@@ -138,7 +138,7 @@ int create_multi_block_metadata_vio(struct vdo *vdo,
 	 * Metadata vios should use direct allocation and not use the buffer pool, which is
 	 * reserved for submissions from the linux block layer.
 	 */
-	result = UDS_ALLOCATE(1, struct vio, __func__, &vio);
+	result = uds_allocate(1, struct vio, __func__, &vio);
 	if (result != VDO_SUCCESS) {
 		uds_log_error("metadata vio allocation failure %d", result);
 		return result;
@@ -346,7 +346,7 @@ int make_vio_pool(struct vdo *vdo,
 	INIT_LIST_HEAD(&pool->available);
 	INIT_LIST_HEAD(&pool->busy);
 
-	result = UDS_ALLOCATE(pool_size * VDO_BLOCK_SIZE, char, "VIO pool buffer", &pool->buffer);
+	result = uds_allocate(pool_size * VDO_BLOCK_SIZE, char, "VIO pool buffer", &pool->buffer);
 	if (result != VDO_SUCCESS) {
 		free_vio_pool(pool);
 		return result;
diff --git a/drivers/md/dm-vdo/volume-index.c b/drivers/md/dm-vdo/volume-index.c
index 93f64fd7c09f..150bb4ad7aa4 100644
--- a/drivers/md/dm-vdo/volume-index.c
+++ b/drivers/md/dm-vdo/volume-index.c
@@ -1189,14 +1189,14 @@ static int initialize_volume_sub_index(const struct configuration *config,
 				  (zone_count * sizeof(struct volume_sub_index_zone)));
 
 	/* The following arrays are initialized to all zeros. */
-	result = UDS_ALLOCATE(params.list_count,
+	result = uds_allocate(params.list_count,
 			      u64,
 			      "first chapter to flush",
 			      &sub_index->flush_chapters);
 	if (result != UDS_SUCCESS)
 		return result;
 
-	return UDS_ALLOCATE(zone_count,
+	return uds_allocate(zone_count,
 			    struct volume_sub_index_zone,
 			    "volume index zones",
 			    &sub_index->zones);
@@ -1211,7 +1211,7 @@ int uds_make_volume_index(const struct configuration *config,
 	struct volume_index *volume_index;
 	int result;
 
-	result = UDS_ALLOCATE(1, struct volume_index, "volume index", &volume_index);
+	result = uds_allocate(1, struct volume_index, "volume index", &volume_index);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -1234,7 +1234,7 @@ int uds_make_volume_index(const struct configuration *config,
 
 	volume_index->sparse_sample_rate = config->sparse_sample_rate;
 
-	result = UDS_ALLOCATE(config->zone_count,
+	result = uds_allocate(config->zone_count,
 			      struct volume_index_zone,
 			      "volume index zones",
 			      &volume_index->zones);
diff --git a/drivers/md/dm-vdo/volume.c b/drivers/md/dm-vdo/volume.c
index b43ce9814216..874dc2ec7ca7 100644
--- a/drivers/md/dm-vdo/volume.c
+++ b/drivers/md/dm-vdo/volume.c
@@ -1576,25 +1576,25 @@ initialize_page_cache(struct page_cache *cache,
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = UDS_ALLOCATE(VOLUME_CACHE_MAX_QUEUED_READS,
+	result = uds_allocate(VOLUME_CACHE_MAX_QUEUED_READS,
 			      struct queued_read,
 			      "volume read queue",
 			      &cache->read_queue);
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = UDS_ALLOCATE(cache->zone_count,
+	result = uds_allocate(cache->zone_count,
 			      struct search_pending_counter,
 			      "Volume Cache Zones",
 			      &cache->search_pending_counters);
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = UDS_ALLOCATE(cache->indexable_pages, u16, "page cache index", &cache->index);
+	result = uds_allocate(cache->indexable_pages, u16, "page cache index", &cache->index);
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = UDS_ALLOCATE(cache->cache_slots,
+	result = uds_allocate(cache->cache_slots,
 			      struct cached_page,
 			      "page cache cache",
 			      &cache->cache);
@@ -1621,7 +1621,7 @@ int uds_make_volume(const struct configuration *config,
 	unsigned int reserved_buffers;
 	int result;
 
-	result = UDS_ALLOCATE(1, struct volume, "volume", &volume);
+	result = uds_allocate(1, struct volume, "volume", &volume);
 	if (result != UDS_SUCCESS)
 		return result;
 
@@ -1658,7 +1658,7 @@ int uds_make_volume(const struct configuration *config,
 		return result;
 	}
 
-	result = UDS_ALLOCATE(geometry->records_per_page,
+	result = uds_allocate(geometry->records_per_page,
 			      const struct uds_volume_record *,
 			      "record pointers",
 			      &volume->record_pointers);
@@ -1717,7 +1717,7 @@ int uds_make_volume(const struct configuration *config,
 		return result;
 	}
 
-	result = UDS_ALLOCATE(config->read_threads,
+	result = uds_allocate(config->read_threads,
 			      struct thread *,
 			      "reader threads",
 			      &volume->reader_threads);
-- 
2.40.0

