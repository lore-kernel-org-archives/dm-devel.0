Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EE227FB3C
	for <dm-devel@lists.linux.dev>; Fri, 27 Feb 2026 01:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772154735; cv=none; b=LQYvl0by6Z3S+yYNBISYFSRgun8aneh67P1M6WF9h3B02HpwGXWiEUSmLKY+GMGSAPoJU4ivMzyNhlBoMkI0+OFtc1ImBCbWFJOTAVafS3eUIQzdnpXaEx293sbnMrQUelJl79P/sbvpXcogoK1qxN2C4hXlKk5almf0x/Lwp6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772154735; c=relaxed/simple;
	bh=v/moEKjCqws0nqq/hRtknj3ueIBOVBkD32aQFDYuaYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=QXZ97BTvyWdCz31iKQBTOQlXZPxY3JdE6ZZDUCTXRWbdtb8sxXdzMyQaQbzXsIJuWblsxDwTe9/bG6xXZAUoA7F78iAW0cQYxRBFAWvJL2YcliEzhx5cEmq9dHw9MgAXghKaD70z9Wo420uJd2DZ0Ca9XqN8xlMSdL3GHQQ/VtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bnHzI8sU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bnHzI8sU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772154731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TwR00zyUGAVFIZS1I4ol5WTFMgOKH65NEVVOOuPg4yg=;
	b=bnHzI8sUQckBnX49EKpQIZp9v56JBbCZotSg1QMhAtChPTHk4pcgF2B5k3oJzqR7PXCsNR
	hYbxLMPrI1AXf+RNXQBQsH75z0We8UpXN7WX9OeXBVXU5tKYZNZ4/4WhQuwfm/Dx40c6mA
	+qSxVxPLTXBe4pfuk5/s1ixUysenW78=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-104-3n0EgD4MM0axxqAwBpysBA-1; Thu,
 26 Feb 2026 20:12:09 -0500
X-MC-Unique: 3n0EgD4MM0axxqAwBpysBA-1
X-Mimecast-MFC-AGG-ID: 3n0EgD4MM0axxqAwBpysBA_1772154729
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0A38F1956063
	for <dm-devel@lists.linux.dev>; Fri, 27 Feb 2026 01:12:09 +0000 (UTC)
Received: from vdo-builder-raeburn.permabit.com (unknown [10.0.101.17])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B65421956056;
	Fri, 27 Feb 2026 01:12:08 +0000 (UTC)
Received: by vdo-builder-raeburn.permabit.com (Postfix, from userid 1065)
	id 3A0A925694; Thu, 26 Feb 2026 20:12:08 -0500 (EST)
From: Ken Raeburn <raeburn@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Ken Raeburn <raeburn@redhat.com>
Subject: [PATCH 2/3] dm vdo: remove redundant TYPE argument from vdo_allocate macro
Date: Thu, 26 Feb 2026 20:12:07 -0500
Message-ID: <3120a844a149ef92151cfce7c0c7448e6909b85e.1772153845.git.raeburn@redhat.com>
In-Reply-To: <cover.1772153845.git.raeburn@redhat.com>
References: <cover.1772153845.git.raeburn@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HNdH0uPdb2KFp3DWdkxZHZwB3oKBW_lHNA_-Xy4_YDU_1772154729
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

We can infer the type needed from the supplied pointer argument. A
couple invocation sites needed fixing to supply the proper type of
pointer.

Use overflow.h's size_mul, and we can remove the __vdo_do_allocation
wrapper which did the same overflow check.

Signed-off-by: Ken Raeburn <raeburn@redhat.com>
---
 drivers/md/dm-vdo/action-manager.c            |  2 +-
 drivers/md/dm-vdo/block-map.c                 | 16 ++-----
 drivers/md/dm-vdo/dedupe.c                    |  3 +-
 drivers/md/dm-vdo/dm-vdo-target.c             | 12 ++---
 drivers/md/dm-vdo/encodings.c                 |  2 +-
 drivers/md/dm-vdo/flush.c                     |  4 +-
 drivers/md/dm-vdo/funnel-queue.c              |  2 +-
 drivers/md/dm-vdo/funnel-workqueue.c          |  8 ++--
 drivers/md/dm-vdo/indexer/chapter-index.c     |  2 +-
 drivers/md/dm-vdo/indexer/config.c            |  2 +-
 drivers/md/dm-vdo/indexer/delta-index.c       | 13 ++---
 .../md/dm-vdo/indexer/funnel-requestqueue.c   |  2 +-
 drivers/md/dm-vdo/indexer/geometry.c          |  2 +-
 drivers/md/dm-vdo/indexer/index-layout.c      | 14 +++---
 drivers/md/dm-vdo/indexer/index-page-map.c    |  8 ++--
 drivers/md/dm-vdo/indexer/index-session.c     |  2 +-
 drivers/md/dm-vdo/indexer/index.c             |  7 ++-
 drivers/md/dm-vdo/indexer/io-factory.c        |  6 +--
 drivers/md/dm-vdo/indexer/sparse-cache.c      | 10 ++--
 drivers/md/dm-vdo/indexer/volume-index.c      | 10 ++--
 drivers/md/dm-vdo/indexer/volume.c            | 22 ++++-----
 drivers/md/dm-vdo/int-map.c                   |  5 +-
 drivers/md/dm-vdo/memory-alloc.c              |  8 ++--
 drivers/md/dm-vdo/memory-alloc.h              | 47 ++-----------------
 drivers/md/dm-vdo/message-stats.c             |  2 +-
 drivers/md/dm-vdo/packer.c                    |  2 +-
 drivers/md/dm-vdo/recovery-journal.c          | 17 +++----
 drivers/md/dm-vdo/repair.c                    | 11 ++---
 drivers/md/dm-vdo/slab-depot.c                | 32 +++++--------
 drivers/md/dm-vdo/thread-utils.c              |  2 +-
 drivers/md/dm-vdo/vdo.c                       | 32 ++++++-------
 drivers/md/dm-vdo/vio.c                       |  5 +-
 32 files changed, 114 insertions(+), 198 deletions(-)

diff --git a/drivers/md/dm-vdo/action-manager.c b/drivers/md/dm-vdo/action-manager.c
index e3bba0b28aad..b8a3977b815d 100644
--- a/drivers/md/dm-vdo/action-manager.c
+++ b/drivers/md/dm-vdo/action-manager.c
@@ -107,7 +107,7 @@ int vdo_make_action_manager(zone_count_t zones,
 			    struct action_manager **manager_ptr)
 {
 	struct action_manager *manager;
-	int result = vdo_allocate(1, struct action_manager, __func__, &manager);
+	int result = vdo_allocate(1, __func__, &manager);
 
 	if (result != VDO_SUCCESS)
 		return result;
diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index 25eda82a9635..5ffc360540ed 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -221,8 +221,7 @@ static int __must_check allocate_cache_components(struct vdo_page_cache *cache)
 	u64 size = cache->page_count * (u64) VDO_BLOCK_SIZE;
 	int result;
 
-	result = vdo_allocate(cache->page_count, struct page_info, "page infos",
-			      &cache->infos);
+	result = vdo_allocate(cache->page_count, "page infos", &cache->infos);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -2364,18 +2363,15 @@ static int make_segment(struct forest *old_forest, block_count_t new_pages,
 
 	forest->segments = index + 1;
 
-	result = vdo_allocate(forest->segments, struct boundary,
-			      "forest boundary array", &forest->boundaries);
+	result = vdo_allocate(forest->segments, "forest boundary array", &forest->boundaries);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = vdo_allocate(forest->segments, struct tree_page *,
-			      "forest page pointers", &forest->pages);
+	result = vdo_allocate(forest->segments, "forest page pointers", &forest->pages);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = vdo_allocate(new_pages, struct tree_page,
-			      "new forest pages", &forest->pages[index]);
+	result = vdo_allocate(new_pages, "new forest pages", &forest->pages[index]);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -2400,9 +2396,7 @@ static int make_segment(struct forest *old_forest, block_count_t new_pages,
 		struct block_map_tree *tree = &(forest->trees[root]);
 		height_t height;
 
-		int result = vdo_allocate(forest->segments,
-					  struct block_map_tree_segment,
-					  "tree root segments", &tree->segments);
+		result = vdo_allocate(forest->segments, "tree root segments", &tree->segments);
 		if (result != VDO_SUCCESS)
 			return result;
 
diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index 36e9f1236025..4e0fefd077d0 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -2364,8 +2364,7 @@ static int __must_check initialize_zone(struct vdo *vdo, struct hash_zones *zone
 	vdo_set_completion_callback(&zone->completion, timeout_index_operations_callback,
 				    zone->thread_id);
 	INIT_LIST_HEAD(&zone->lock_pool);
-	result = vdo_allocate(LOCK_POOL_CAPACITY, struct hash_lock, "hash_lock array",
-			      &zone->lock_array);
+	result = vdo_allocate(LOCK_POOL_CAPACITY, "hash_lock array", &zone->lock_array);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index 6af40d40f255..7eb676e58ed5 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -273,8 +273,7 @@ static int split_string(const char *string, char separator, char ***substring_ar
 			substring_count++;
 	}
 
-	result = vdo_allocate(substring_count + 1, char *, "string-splitting array",
-			      &substrings);
+	result = vdo_allocate(substring_count + 1, "string-splitting array", &substrings);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -282,7 +281,7 @@ static int split_string(const char *string, char separator, char ***substring_ar
 		if (*s == separator) {
 			ptrdiff_t length = s - string;
 
-			result = vdo_allocate(length + 1, char, "split string",
+			result = vdo_allocate(length + 1, "split string",
 					      &substrings[current_substring]);
 			if (result != VDO_SUCCESS) {
 				free_string_array(substrings);
@@ -303,8 +302,7 @@ static int split_string(const char *string, char separator, char ***substring_ar
 	BUG_ON(current_substring != (substring_count - 1));
 	length = strlen(string);
 
-	result = vdo_allocate(length + 1, char, "split string",
-			      &substrings[current_substring]);
+	result = vdo_allocate(length + 1, "split string", &substrings[current_substring]);
 	if (result != VDO_SUCCESS) {
 		free_string_array(substrings);
 		return result;
@@ -332,7 +330,7 @@ static int join_strings(char **substring_array, size_t array_length, char separa
 	for (i = 0; (i < array_length) && (substring_array[i] != NULL); i++)
 		string_length += strlen(substring_array[i]) + 1;
 
-	result = vdo_allocate(string_length, char, __func__, &output);
+	result = vdo_allocate(string_length, __func__, &output);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -726,7 +724,7 @@ static int parse_device_config(int argc, char **argv, struct dm_target *ti,
 		return VDO_BAD_CONFIGURATION;
 	}
 
-	result = vdo_allocate(1, struct device_config, "device_config", &config);
+	result = vdo_allocate(1, "device_config", &config);
 	if (result != VDO_SUCCESS) {
 		handle_parse_error(config, error_ptr,
 				   "Could not allocate config structure");
diff --git a/drivers/md/dm-vdo/encodings.c b/drivers/md/dm-vdo/encodings.c
index bd60f4b3a0d0..ec98c539701e 100644
--- a/drivers/md/dm-vdo/encodings.c
+++ b/drivers/md/dm-vdo/encodings.c
@@ -798,7 +798,7 @@ static int allocate_partition(struct layout *layout, u8 id,
 	struct partition *partition;
 	int result;
 
-	result = vdo_allocate(1, struct partition, __func__, &partition);
+	result = vdo_allocate(1, __func__, &partition);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/flush.c b/drivers/md/dm-vdo/flush.c
index 82a259ef1601..6c1610ba91b6 100644
--- a/drivers/md/dm-vdo/flush.c
+++ b/drivers/md/dm-vdo/flush.c
@@ -105,7 +105,7 @@ static void *allocate_flush(gfp_t gfp_mask, void *pool_data)
 	if ((gfp_mask & GFP_NOWAIT) == GFP_NOWAIT) {
 		flush = vdo_allocate_memory_nowait(sizeof(struct vdo_flush), __func__);
 	} else {
-		int result = vdo_allocate(1, struct vdo_flush, __func__, &flush);
+		int result = vdo_allocate(1, __func__, &flush);
 
 		if (result != VDO_SUCCESS)
 			vdo_log_error_strerror(result, "failed to allocate spare flush");
@@ -134,7 +134,7 @@ static void free_flush(void *element, void *pool_data __always_unused)
  */
 int vdo_make_flusher(struct vdo *vdo)
 {
-	int result = vdo_allocate(1, struct flusher, __func__, &vdo->flusher);
+	int result = vdo_allocate(1, __func__, &vdo->flusher);
 
 	if (result != VDO_SUCCESS)
 		return result;
diff --git a/drivers/md/dm-vdo/funnel-queue.c b/drivers/md/dm-vdo/funnel-queue.c
index a63b2f2bfd7d..7011963c9073 100644
--- a/drivers/md/dm-vdo/funnel-queue.c
+++ b/drivers/md/dm-vdo/funnel-queue.c
@@ -14,7 +14,7 @@ int vdo_make_funnel_queue(struct funnel_queue **queue_ptr)
 	int result;
 	struct funnel_queue *queue;
 
-	result = vdo_allocate(1, struct funnel_queue, "funnel queue", &queue);
+	result = vdo_allocate(1, "funnel queue", &queue);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/funnel-workqueue.c b/drivers/md/dm-vdo/funnel-workqueue.c
index 8a79b33b8b09..62d300f70de9 100644
--- a/drivers/md/dm-vdo/funnel-workqueue.c
+++ b/drivers/md/dm-vdo/funnel-workqueue.c
@@ -322,7 +322,7 @@ static int make_simple_work_queue(const char *thread_name_prefix, const char *na
 			    "queue priority count %u within limit %u", type->max_priority,
 			    VDO_WORK_Q_MAX_PRIORITY);
 
-	result = vdo_allocate(1, struct simple_work_queue, "simple work queue", &queue);
+	result = vdo_allocate(1, "simple work queue", &queue);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -405,13 +405,11 @@ int vdo_make_work_queue(const char *thread_name_prefix, const char *name,
 		return result;
 	}
 
-	result = vdo_allocate(1, struct round_robin_work_queue, "round-robin work queue",
-			      &queue);
+	result = vdo_allocate(1, "round-robin work queue", &queue);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = vdo_allocate(thread_count, struct simple_work_queue *,
-			      "subordinate work queues", &queue->service_queues);
+	result = vdo_allocate(thread_count, "subordinate work queues", &queue->service_queues);
 	if (result != VDO_SUCCESS) {
 		vdo_free(queue);
 		return result;
diff --git a/drivers/md/dm-vdo/indexer/chapter-index.c b/drivers/md/dm-vdo/indexer/chapter-index.c
index fb1db41c794b..bb3b0ab5d50d 100644
--- a/drivers/md/dm-vdo/indexer/chapter-index.c
+++ b/drivers/md/dm-vdo/indexer/chapter-index.c
@@ -20,7 +20,7 @@ int uds_make_open_chapter_index(struct open_chapter_index **chapter_index,
 	size_t memory_size;
 	struct open_chapter_index *index;
 
-	result = vdo_allocate(1, struct open_chapter_index, "open chapter index", &index);
+	result = vdo_allocate(1, "open chapter index", &index);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/indexer/config.c b/drivers/md/dm-vdo/indexer/config.c
index 5532371b952f..4a2cc66cfd60 100644
--- a/drivers/md/dm-vdo/indexer/config.c
+++ b/drivers/md/dm-vdo/indexer/config.c
@@ -325,7 +325,7 @@ int uds_make_configuration(const struct uds_parameters *params,
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = vdo_allocate(1, struct uds_configuration, __func__, &config);
+	result = vdo_allocate(1, __func__, &config);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/indexer/delta-index.c b/drivers/md/dm-vdo/indexer/delta-index.c
index 0ac2443f0df3..b288749067de 100644
--- a/drivers/md/dm-vdo/indexer/delta-index.c
+++ b/drivers/md/dm-vdo/indexer/delta-index.c
@@ -311,18 +311,16 @@ static int initialize_delta_zone(struct delta_zone *delta_zone, size_t size,
 {
 	int result;
 
-	result = vdo_allocate(size, u8, "delta list", &delta_zone->memory);
+	result = vdo_allocate(size, "delta list", &delta_zone->memory);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = vdo_allocate(list_count + 2, u64, "delta list temp",
-			      &delta_zone->new_offsets);
+	result = vdo_allocate(list_count + 2, "delta list temp", &delta_zone->new_offsets);
 	if (result != VDO_SUCCESS)
 		return result;
 
 	/* Allocate the delta lists. */
-	result = vdo_allocate(list_count + 2, struct delta_list, "delta lists",
-			      &delta_zone->delta_lists);
+	result = vdo_allocate(list_count + 2, "delta lists", &delta_zone->delta_lists);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -352,8 +350,7 @@ int uds_initialize_delta_index(struct delta_index *delta_index, unsigned int zon
 	unsigned int z;
 	size_t zone_memory;
 
-	result = vdo_allocate(zone_count, struct delta_zone, "Delta Index Zones",
-			      &delta_index->delta_zones);
+	result = vdo_allocate(zone_count, "Delta Index Zones", &delta_index->delta_zones);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -1047,7 +1044,7 @@ int uds_finish_restoring_delta_index(struct delta_index *delta_index,
 	unsigned int z;
 	u8 *data;
 
-	result = vdo_allocate(DELTA_LIST_MAX_BYTE_COUNT, u8, __func__, &data);
+	result = vdo_allocate(DELTA_LIST_MAX_BYTE_COUNT, __func__, &data);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/indexer/funnel-requestqueue.c b/drivers/md/dm-vdo/indexer/funnel-requestqueue.c
index 1a5735375ddc..03797cf87b91 100644
--- a/drivers/md/dm-vdo/indexer/funnel-requestqueue.c
+++ b/drivers/md/dm-vdo/indexer/funnel-requestqueue.c
@@ -198,7 +198,7 @@ int uds_make_request_queue(const char *queue_name,
 	int result;
 	struct uds_request_queue *queue;
 
-	result = vdo_allocate(1, struct uds_request_queue, __func__, &queue);
+	result = vdo_allocate(1, __func__, &queue);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/indexer/geometry.c b/drivers/md/dm-vdo/indexer/geometry.c
index c0575612e820..49f122a223d5 100644
--- a/drivers/md/dm-vdo/indexer/geometry.c
+++ b/drivers/md/dm-vdo/indexer/geometry.c
@@ -61,7 +61,7 @@ int uds_make_index_geometry(size_t bytes_per_page, u32 record_pages_per_chapter,
 	int result;
 	struct index_geometry *geometry;
 
-	result = vdo_allocate(1, struct index_geometry, "geometry", &geometry);
+	result = vdo_allocate(1, "geometry", &geometry);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/indexer/index-layout.c b/drivers/md/dm-vdo/indexer/index-layout.c
index 180248bb4b20..798badcf80ea 100644
--- a/drivers/md/dm-vdo/indexer/index-layout.c
+++ b/drivers/md/dm-vdo/indexer/index-layout.c
@@ -519,7 +519,7 @@ static int __must_check write_index_save_header(struct index_save_layout *isl,
 	u8 *buffer;
 	size_t offset = 0;
 
-	result = vdo_allocate(table->encoded_size, u8, "index save data", &buffer);
+	result = vdo_allocate(table->encoded_size, "index save data", &buffer);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -688,7 +688,7 @@ static int __must_check write_layout_header(struct index_layout *layout,
 	u8 *buffer;
 	size_t offset = 0;
 
-	result = vdo_allocate(table->encoded_size, u8, "layout data", &buffer);
+	result = vdo_allocate(table->encoded_size, "layout data", &buffer);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -778,8 +778,7 @@ static int create_index_layout(struct index_layout *layout, struct uds_configura
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = vdo_allocate(sizes.save_count, struct index_save_layout, __func__,
-			      &layout->index.saves);
+	result = vdo_allocate(sizes.save_count, __func__, &layout->index.saves);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -1174,7 +1173,7 @@ static int __must_check read_super_block_data(struct buffered_reader *reader,
 	u8 *buffer;
 	size_t offset = 0;
 
-	result = vdo_allocate(saved_size, u8, "super block data", &buffer);
+	result = vdo_allocate(saved_size, "super block data", &buffer);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -1308,8 +1307,7 @@ static int __must_check reconstitute_layout(struct index_layout *layout,
 	int result;
 	u64 next_block = first_block;
 
-	result = vdo_allocate(layout->super.max_saves, struct index_save_layout,
-			      __func__, &layout->index.saves);
+	result = vdo_allocate(layout->super.max_saves, __func__, &layout->index.saves);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -1676,7 +1674,7 @@ int uds_make_index_layout(struct uds_configuration *config, bool new_layout,
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = vdo_allocate(1, struct index_layout, __func__, &layout);
+	result = vdo_allocate(1, __func__, &layout);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/indexer/index-page-map.c b/drivers/md/dm-vdo/indexer/index-page-map.c
index 00b44e07d0c1..1d45d466d07f 100644
--- a/drivers/md/dm-vdo/indexer/index-page-map.c
+++ b/drivers/md/dm-vdo/indexer/index-page-map.c
@@ -38,13 +38,13 @@ int uds_make_index_page_map(const struct index_geometry *geometry,
 	int result;
 	struct index_page_map *map;
 
-	result = vdo_allocate(1, struct index_page_map, "page map", &map);
+	result = vdo_allocate(1, "page map", &map);
 	if (result != VDO_SUCCESS)
 		return result;
 
 	map->geometry = geometry;
 	map->entries_per_chapter = geometry->index_pages_per_chapter - 1;
-	result = vdo_allocate(get_entry_count(geometry), u16, "Index Page Map Entries",
+	result = vdo_allocate(get_entry_count(geometry), "Index Page Map Entries",
 			      &map->entries);
 	if (result != VDO_SUCCESS) {
 		uds_free_index_page_map(map);
@@ -118,7 +118,7 @@ int uds_write_index_page_map(struct index_page_map *map, struct buffered_writer
 	u64 saved_size = uds_compute_index_page_map_save_size(map->geometry);
 	u32 i;
 
-	result = vdo_allocate(saved_size, u8, "page map data", &buffer);
+	result = vdo_allocate(saved_size, "page map data", &buffer);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -145,7 +145,7 @@ int uds_read_index_page_map(struct index_page_map *map, struct buffered_reader *
 	u64 saved_size = uds_compute_index_page_map_save_size(map->geometry);
 	u32 i;
 
-	result = vdo_allocate(saved_size, u8, "page map data", &buffer);
+	result = vdo_allocate(saved_size, "page map data", &buffer);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/indexer/index-session.c b/drivers/md/dm-vdo/indexer/index-session.c
index aa575a24e0b2..6c78070e1a05 100644
--- a/drivers/md/dm-vdo/indexer/index-session.c
+++ b/drivers/md/dm-vdo/indexer/index-session.c
@@ -217,7 +217,7 @@ static int __must_check make_empty_index_session(struct uds_index_session **inde
 	int result;
 	struct uds_index_session *session;
 
-	result = vdo_allocate(1, struct uds_index_session, __func__, &session);
+	result = vdo_allocate(1, __func__, &session);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/indexer/index.c b/drivers/md/dm-vdo/indexer/index.c
index d4724fe17bf1..793bd32c1179 100644
--- a/drivers/md/dm-vdo/indexer/index.c
+++ b/drivers/md/dm-vdo/indexer/index.c
@@ -88,7 +88,7 @@ static int launch_zone_message(struct uds_zone_message message, unsigned int zon
 	int result;
 	struct uds_request *request;
 
-	result = vdo_allocate(1, struct uds_request, __func__, &request);
+	result = vdo_allocate(1, __func__, &request);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -1121,7 +1121,7 @@ static int make_index_zone(struct uds_index *index, unsigned int zone_number)
 	int result;
 	struct index_zone *zone;
 
-	result = vdo_allocate(1, struct index_zone, "index zone", &zone);
+	result = vdo_allocate(1, "index zone", &zone);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -1170,8 +1170,7 @@ int uds_make_index(struct uds_configuration *config, enum uds_open_index_type op
 		return result;
 	}
 
-	result = vdo_allocate(index->zone_count, struct index_zone *, "zones",
-			      &index->zones);
+	result = vdo_allocate(index->zone_count, "zones", &index->zones);
 	if (result != VDO_SUCCESS) {
 		uds_free_index(index);
 		return result;
diff --git a/drivers/md/dm-vdo/indexer/io-factory.c b/drivers/md/dm-vdo/indexer/io-factory.c
index 1bee9d63dc0a..f42861372030 100644
--- a/drivers/md/dm-vdo/indexer/io-factory.c
+++ b/drivers/md/dm-vdo/indexer/io-factory.c
@@ -64,7 +64,7 @@ int uds_make_io_factory(struct block_device *bdev, struct io_factory **factory_p
 	int result;
 	struct io_factory *factory;
 
-	result = vdo_allocate(1, struct io_factory, __func__, &factory);
+	result = vdo_allocate(1, __func__, &factory);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -144,7 +144,7 @@ int uds_make_buffered_reader(struct io_factory *factory, off_t offset, u64 block
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = vdo_allocate(1, struct buffered_reader, "buffered reader", &reader);
+	result = vdo_allocate(1, "buffered reader", &reader);
 	if (result != VDO_SUCCESS) {
 		dm_bufio_client_destroy(client);
 		return result;
@@ -282,7 +282,7 @@ int uds_make_buffered_writer(struct io_factory *factory, off_t offset, u64 block
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = vdo_allocate(1, struct buffered_writer, "buffered writer", &writer);
+	result = vdo_allocate(1, "buffered writer", &writer);
 	if (result != VDO_SUCCESS) {
 		dm_bufio_client_destroy(client);
 		return result;
diff --git a/drivers/md/dm-vdo/indexer/sparse-cache.c b/drivers/md/dm-vdo/indexer/sparse-cache.c
index 28920167827c..eb62d3f01834 100644
--- a/drivers/md/dm-vdo/indexer/sparse-cache.c
+++ b/drivers/md/dm-vdo/indexer/sparse-cache.c
@@ -222,13 +222,12 @@ static int __must_check initialize_cached_chapter_index(struct cached_chapter_in
 	chapter->virtual_chapter = NO_CHAPTER;
 	chapter->index_pages_count = geometry->index_pages_per_chapter;
 
-	result = vdo_allocate(chapter->index_pages_count, struct delta_index_page,
-			      __func__, &chapter->index_pages);
+	result = vdo_allocate(chapter->index_pages_count, __func__, &chapter->index_pages);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	return vdo_allocate(chapter->index_pages_count, struct dm_buffer *,
-			    "sparse index volume pages", &chapter->page_buffers);
+	return vdo_allocate(chapter->index_pages_count, "sparse index volume pages",
+			    &chapter->page_buffers);
 }
 
 static int __must_check make_search_list(struct sparse_cache *cache,
@@ -294,8 +293,7 @@ int uds_make_sparse_cache(const struct index_geometry *geometry, unsigned int ca
 	}
 
 	/* purge_search_list() needs some temporary lists for sorting. */
-	result = vdo_allocate(capacity * 2, struct cached_chapter_index *,
-			      "scratch entries", &cache->scratch_entries);
+	result = vdo_allocate(capacity * 2, "scratch entries", &cache->scratch_entries);
 	if (result != VDO_SUCCESS)
 		goto out;
 
diff --git a/drivers/md/dm-vdo/indexer/volume-index.c b/drivers/md/dm-vdo/indexer/volume-index.c
index afb062e1f1fb..e78d2725ce8b 100644
--- a/drivers/md/dm-vdo/indexer/volume-index.c
+++ b/drivers/md/dm-vdo/indexer/volume-index.c
@@ -1211,13 +1211,12 @@ static int initialize_volume_sub_index(const struct uds_configuration *config,
 				  (zone_count * sizeof(struct volume_sub_index_zone)));
 
 	/* The following arrays are initialized to all zeros. */
-	result = vdo_allocate(params.list_count, u64, "first chapter to flush",
+	result = vdo_allocate(params.list_count, "first chapter to flush",
 			      &sub_index->flush_chapters);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	return vdo_allocate(zone_count, struct volume_sub_index_zone,
-			    "volume index zones", &sub_index->zones);
+	return vdo_allocate(zone_count, "volume index zones", &sub_index->zones);
 }
 
 int uds_make_volume_index(const struct uds_configuration *config, u64 volume_nonce,
@@ -1228,7 +1227,7 @@ int uds_make_volume_index(const struct uds_configuration *config, u64 volume_non
 	struct volume_index *volume_index;
 	int result;
 
-	result = vdo_allocate(1, struct volume_index, "volume index", &volume_index);
+	result = vdo_allocate(1, "volume index", &volume_index);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -1249,8 +1248,7 @@ int uds_make_volume_index(const struct uds_configuration *config, u64 volume_non
 
 	volume_index->sparse_sample_rate = config->sparse_sample_rate;
 
-	result = vdo_allocate(config->zone_count, struct volume_index_zone,
-			      "volume index zones", &volume_index->zones);
+	result = vdo_allocate(config->zone_count, "volume index zones", &volume_index->zones);
 	if (result != VDO_SUCCESS) {
 		uds_free_volume_index(volume_index);
 		return result;
diff --git a/drivers/md/dm-vdo/indexer/volume.c b/drivers/md/dm-vdo/indexer/volume.c
index 425b3a74f4db..af97c0cbeede 100644
--- a/drivers/md/dm-vdo/indexer/volume.c
+++ b/drivers/md/dm-vdo/indexer/volume.c
@@ -1509,23 +1509,21 @@ static int __must_check initialize_page_cache(struct page_cache *cache,
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = vdo_allocate(VOLUME_CACHE_MAX_QUEUED_READS, struct queued_read,
-			      "volume read queue", &cache->read_queue);
+	result = vdo_allocate(VOLUME_CACHE_MAX_QUEUED_READS, "volume read queue",
+			      &cache->read_queue);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = vdo_allocate(cache->zone_count, struct search_pending_counter,
-			      "Volume Cache Zones", &cache->search_pending_counters);
+	result = vdo_allocate(cache->zone_count, "Volume Cache Zones",
+			      &cache->search_pending_counters);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = vdo_allocate(cache->indexable_pages, u16, "page cache index",
-			      &cache->index);
+	result = vdo_allocate(cache->indexable_pages, "page cache index", &cache->index);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = vdo_allocate(cache->cache_slots, struct cached_page, "page cache cache",
-			      &cache->cache);
+	result = vdo_allocate(cache->cache_slots, "page cache cache", &cache->cache);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -1548,7 +1546,7 @@ int uds_make_volume(const struct uds_configuration *config, struct index_layout
 	unsigned int reserved_buffers;
 	int result;
 
-	result = vdo_allocate(1, struct volume, "volume", &volume);
+	result = vdo_allocate(1, "volume", &volume);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -1585,8 +1583,7 @@ int uds_make_volume(const struct uds_configuration *config, struct index_layout
 		return result;
 	}
 
-	result = vdo_allocate(geometry->records_per_page,
-			      const struct uds_volume_record *, "record pointers",
+	result = vdo_allocate(geometry->records_per_page, "record pointers",
 			      &volume->record_pointers);
 	if (result != VDO_SUCCESS) {
 		uds_free_volume(volume);
@@ -1626,8 +1623,7 @@ int uds_make_volume(const struct uds_configuration *config, struct index_layout
 	uds_init_cond(&volume->read_threads_read_done_cond);
 	uds_init_cond(&volume->read_threads_cond);
 
-	result = vdo_allocate(config->read_threads, struct thread *, "reader threads",
-			      &volume->reader_threads);
+	result = vdo_allocate(config->read_threads, "reader threads", &volume->reader_threads);
 	if (result != VDO_SUCCESS) {
 		uds_free_volume(volume);
 		return result;
diff --git a/drivers/md/dm-vdo/int-map.c b/drivers/md/dm-vdo/int-map.c
index aeb690415dbd..28d8af1f9be2 100644
--- a/drivers/md/dm-vdo/int-map.c
+++ b/drivers/md/dm-vdo/int-map.c
@@ -164,8 +164,7 @@ static int allocate_buckets(struct int_map *map, size_t capacity)
 	 * without have to wrap back around to element zero.
 	 */
 	map->bucket_count = capacity + (NEIGHBORHOOD - 1);
-	return vdo_allocate(map->bucket_count, struct bucket,
-			    "struct int_map buckets", &map->buckets);
+	return vdo_allocate(map->bucket_count, "struct int_map buckets", &map->buckets);
 }
 
 /**
@@ -182,7 +181,7 @@ int vdo_int_map_create(size_t initial_capacity, struct int_map **map_ptr)
 	int result;
 	size_t capacity;
 
-	result = vdo_allocate(1, struct int_map, "struct int_map", &map);
+	result = vdo_allocate(1, "struct int_map", &map);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/memory-alloc.c b/drivers/md/dm-vdo/memory-alloc.c
index 185f259c7245..a7f07522110d 100644
--- a/drivers/md/dm-vdo/memory-alloc.c
+++ b/drivers/md/dm-vdo/memory-alloc.c
@@ -245,7 +245,7 @@ int vdo_allocate_memory(size_t size, size_t align, const char *what, void *ptr)
 	} else {
 		struct vmalloc_block_info *block;
 
-		if (vdo_allocate(1, struct vmalloc_block_info, __func__, &block) == VDO_SUCCESS) {
+		if (vdo_allocate(1, __func__, &block) == VDO_SUCCESS) {
 			/*
 			 * It is possible for __vmalloc to fail to allocate memory because there
 			 * are no pages available. A short sleep may allow the page reclaimer
@@ -341,6 +341,7 @@ int vdo_reallocate_memory(void *ptr, size_t old_size, size_t size, const char *w
 			  void *new_ptr)
 {
 	int result;
+	char *temp_ptr;
 
 	if (size == 0) {
 		vdo_free(ptr);
@@ -348,9 +349,10 @@ int vdo_reallocate_memory(void *ptr, size_t old_size, size_t size, const char *w
 		return VDO_SUCCESS;
 	}
 
-	result = vdo_allocate(size, char, what, new_ptr);
+	result = vdo_allocate(size, what, &temp_ptr);
 	if (result != VDO_SUCCESS)
 		return result;
+	*(void **) new_ptr = temp_ptr;
 
 	if (ptr != NULL) {
 		if (old_size < size)
@@ -368,7 +370,7 @@ int vdo_duplicate_string(const char *string, const char *what, char **new_string
 	int result;
 	u8 *dup;
 
-	result = vdo_allocate(strlen(string) + 1, u8, what, &dup);
+	result = vdo_allocate(strlen(string) + 1, what, &dup);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/memory-alloc.h b/drivers/md/dm-vdo/memory-alloc.h
index ab2375d549f4..bc5527327ed8 100644
--- a/drivers/md/dm-vdo/memory-alloc.h
+++ b/drivers/md/dm-vdo/memory-alloc.h
@@ -16,60 +16,19 @@
 /* Custom memory allocation function that tracks memory usage */
 int __must_check vdo_allocate_memory(size_t size, size_t align, const char *what, void *ptr);
 
-/*
- * Allocate storage based on element counts, sizes, and alignment.
- *
- * This is a generalized form of our allocation use case: It allocates an array of objects,
- * optionally preceded by one object of another type (i.e., a struct with trailing variable-length
- * array), with the alignment indicated.
- *
- * Why is this inline? The sizes and alignment will always be constant, when invoked through the
- * macros below, and often the count will be a compile-time constant 1 or the number of extra bytes
- * will be a compile-time constant 0. So at least some of the arithmetic can usually be optimized
- * away, and the run-time selection between allocation functions always can. In many cases, it'll
- * boil down to just a function call with a constant size.
- *
- * @count: The number of objects to allocate
- * @size: The size of an object
- * @extra: The number of additional bytes to allocate
- * @align: The required alignment
- * @what: What is being allocated (for error logging)
- * @ptr: A pointer to hold the allocated memory
- *
- * Return: VDO_SUCCESS or an error code
- */
-static inline int __vdo_do_allocation(size_t count, size_t size, size_t extra,
-				      size_t align, const char *what, void *ptr)
-{
-	size_t total_size = count * size + extra;
-
-	/* Overflow check: */
-	if ((size > 0) && (count > ((SIZE_MAX - extra) / size))) {
-		/*
-		 * This is kind of a hack: We rely on the fact that SIZE_MAX would cover the entire
-		 * address space (minus one byte) and thus the system can never allocate that much
-		 * and the call will always fail. So we can report an overflow as "out of memory"
-		 * by asking for "merely" SIZE_MAX bytes.
-		 */
-		total_size = SIZE_MAX;
-	}
-
-	return vdo_allocate_memory(total_size, align, what, ptr);
-}
-
 /*
  * Allocate one or more elements of the indicated type, logging an error if the allocation fails.
  * The memory will be zeroed.
  *
  * @COUNT: The number of objects to allocate
- * @TYPE: The type of objects to allocate. This type determines the alignment of the allocation.
  * @WHAT: What is being allocated (for error logging)
  * @PTR: A pointer to hold the allocated memory
  *
  * Return: VDO_SUCCESS or an error code
  */
-#define vdo_allocate(COUNT, TYPE, WHAT, PTR) \
-	__vdo_do_allocation(COUNT, sizeof(TYPE), 0, __alignof__(TYPE), WHAT, PTR)
+#define vdo_allocate(COUNT, WHAT, PTR)					\
+	vdo_allocate_memory(size_mul((COUNT), sizeof(typeof(**(PTR)))),	\
+			    __alignof__(typeof(**(PTR))), WHAT, PTR)
 
 /*
  * Allocate a structure with a flexible array member, with a specified number of elements, logging
diff --git a/drivers/md/dm-vdo/message-stats.c b/drivers/md/dm-vdo/message-stats.c
index 75dfcd7c5f63..b4c919780c22 100644
--- a/drivers/md/dm-vdo/message-stats.c
+++ b/drivers/md/dm-vdo/message-stats.c
@@ -420,7 +420,7 @@ int vdo_write_stats(struct vdo *vdo, char *buf, unsigned int maxlen)
 	struct vdo_statistics *stats;
 	int result;
 
-	result = vdo_allocate(1, struct vdo_statistics, __func__, &stats);
+	result = vdo_allocate(1, __func__, &stats);
 	if (result != VDO_SUCCESS) {
 		vdo_log_error("Cannot allocate memory to write VDO statistics");
 		return result;
diff --git a/drivers/md/dm-vdo/packer.c b/drivers/md/dm-vdo/packer.c
index e638694d896c..ea2d8d14495c 100644
--- a/drivers/md/dm-vdo/packer.c
+++ b/drivers/md/dm-vdo/packer.c
@@ -145,7 +145,7 @@ int vdo_make_packer(struct vdo *vdo, block_count_t bin_count, struct packer **pa
 	block_count_t i;
 	int result;
 
-	result = vdo_allocate(1, struct packer, __func__, &packer);
+	result = vdo_allocate(1, __func__, &packer);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/recovery-journal.c b/drivers/md/dm-vdo/recovery-journal.c
index 6da303961376..f03939cc89e3 100644
--- a/drivers/md/dm-vdo/recovery-journal.c
+++ b/drivers/md/dm-vdo/recovery-journal.c
@@ -593,32 +593,29 @@ static int __must_check initialize_lock_counter(struct recovery_journal *journal
 	struct thread_config *config = &vdo->thread_config;
 	struct lock_counter *counter = &journal->lock_counter;
 
-	result = vdo_allocate(journal->size, u16, __func__, &counter->journal_counters);
+	result = vdo_allocate(journal->size, __func__, &counter->journal_counters);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = vdo_allocate(journal->size, atomic_t, __func__,
-			      &counter->journal_decrement_counts);
+	result = vdo_allocate(journal->size, __func__, &counter->journal_decrement_counts);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = vdo_allocate(journal->size * config->logical_zone_count, u16, __func__,
+	result = vdo_allocate(journal->size * config->logical_zone_count, __func__,
 			      &counter->logical_counters);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = vdo_allocate(journal->size, atomic_t, __func__,
-			      &counter->logical_zone_counts);
+	result = vdo_allocate(journal->size, __func__, &counter->logical_zone_counts);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = vdo_allocate(journal->size * config->physical_zone_count, u16, __func__,
+	result = vdo_allocate(journal->size * config->physical_zone_count, __func__,
 			      &counter->physical_counters);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = vdo_allocate(journal->size, atomic_t, __func__,
-			      &counter->physical_zone_counts);
+	result = vdo_allocate(journal->size, __func__, &counter->physical_zone_counts);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -672,7 +669,7 @@ static int initialize_recovery_block(struct vdo *vdo, struct recovery_journal *j
 	 * Allocate a full block for the journal block even though not all of the space is used
 	 * since the VIO needs to write a full disk block.
 	 */
-	result = vdo_allocate(VDO_BLOCK_SIZE, char, __func__, &data);
+	result = vdo_allocate(VDO_BLOCK_SIZE, __func__, &data);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
index e479d3582040..43ce65a69e61 100644
--- a/drivers/md/dm-vdo/repair.c
+++ b/drivers/md/dm-vdo/repair.c
@@ -1417,8 +1417,7 @@ static int parse_journal_for_rebuild(struct repair_completion *repair)
 	 * packed_recovery_journal_entry from every valid journal block.
 	 */
 	count = ((repair->highest_tail - repair->block_map_head + 1) * entries_per_block);
-	result = vdo_allocate(count, struct numbered_block_mapping, __func__,
-			      &repair->entries);
+	result = vdo_allocate(count, __func__, &repair->entries);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -1464,8 +1463,7 @@ static int extract_new_mappings(struct repair_completion *repair)
 	 * Allocate an array of numbered_block_mapping structs just large enough to transcribe
 	 * every packed_recovery_journal_entry from every valid journal block.
 	 */
-	result = vdo_allocate(repair->entry_count, struct numbered_block_mapping,
-			      __func__, &repair->entries);
+	result = vdo_allocate(repair->entry_count, __func__, &repair->entries);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -1727,12 +1725,11 @@ void vdo_repair(struct vdo_completion *parent)
 	prepare_repair_completion(repair, finish_repair, VDO_ZONE_TYPE_ADMIN);
 	repair->page_count = page_count;
 
-	result = vdo_allocate(remaining * VDO_BLOCK_SIZE, char, __func__,
-			      &repair->journal_data);
+	result = vdo_allocate(remaining * VDO_BLOCK_SIZE, __func__, &repair->journal_data);
 	if (abort_on_error(result, repair))
 		return;
 
-	result = vdo_allocate(vio_count, struct vio, __func__, &repair->vios);
+	result = vdo_allocate(vio_count, __func__, &repair->vios);
 	if (abort_on_error(result, repair))
 		return;
 
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 286fc4465a92..7fcbb361b38d 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -2453,8 +2453,7 @@ static int allocate_slab_counters(struct vdo_slab *slab)
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = vdo_allocate(slab->reference_block_count, struct reference_block,
-			      __func__, &slab->reference_blocks);
+	result = vdo_allocate(slab->reference_block_count, __func__, &slab->reference_blocks);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -2463,8 +2462,7 @@ static int allocate_slab_counters(struct vdo_slab *slab)
 	 * so we can word-search even at the very end.
 	 */
 	bytes = (slab->reference_block_count * COUNTS_PER_BLOCK) + (2 * BYTES_PER_WORD);
-	result = vdo_allocate(bytes, vdo_refcount_t, "ref counts array",
-			      &slab->counters);
+	result = vdo_allocate(bytes, "ref counts array", &slab->counters);
 	if (result != VDO_SUCCESS) {
 		vdo_free(vdo_forget(slab->reference_blocks));
 		return result;
@@ -3563,8 +3561,7 @@ static int get_slab_statuses(struct block_allocator *allocator,
 	struct slab_status *statuses;
 	struct slab_iterator iterator = get_slab_iterator(allocator);
 
-	result = vdo_allocate(allocator->slab_count, struct slab_status, __func__,
-			      &statuses);
+	result = vdo_allocate(allocator->slab_count, __func__, &statuses);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -3739,13 +3736,12 @@ static int initialize_slab_journal(struct vdo_slab *slab)
 	const struct slab_config *slab_config = &slab->allocator->depot->slab_config;
 	int result;
 
-	result = vdo_allocate(slab_config->slab_journal_blocks, struct journal_lock,
-			      __func__, &journal->locks);
+	result = vdo_allocate(slab_config->slab_journal_blocks, __func__, &journal->locks);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = vdo_allocate(VDO_BLOCK_SIZE, char, "struct packed_slab_journal_block",
-			      (char **) &journal->block);
+	BUILD_BUG_ON(sizeof(*journal->block) != VDO_BLOCK_SIZE);
+	result = vdo_allocate(1, "struct packed_slab_journal_block", &journal->block);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -3800,7 +3796,7 @@ static int __must_check make_slab(physical_block_number_t slab_origin,
 	struct vdo_slab *slab;
 	int result;
 
-	result = vdo_allocate(1, struct vdo_slab, __func__, &slab);
+	result = vdo_allocate(1, __func__, &slab);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -3857,8 +3853,7 @@ static int allocate_slabs(struct slab_depot *depot, slab_count_t slab_count)
 	physical_block_number_t slab_origin;
 	int result;
 
-	result = vdo_allocate(slab_count, struct vdo_slab *,
-			      "slab pointer array", &depot->new_slabs);
+	result = vdo_allocate(slab_count, "slab pointer array", &depot->new_slabs);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -4011,8 +4006,7 @@ static int initialize_slab_scrubber(struct block_allocator *allocator)
 	char *journal_data;
 	int result;
 
-	result = vdo_allocate(VDO_BLOCK_SIZE * slab_journal_size,
-			      char, __func__, &journal_data);
+	result = vdo_allocate(VDO_BLOCK_SIZE * slab_journal_size, __func__, &journal_data);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -4045,7 +4039,7 @@ static int __must_check initialize_slab_summary_block(struct block_allocator *al
 	struct slab_summary_block *block = &allocator->summary_blocks[index];
 	int result;
 
-	result = vdo_allocate(VDO_BLOCK_SIZE, char, __func__, &block->outgoing_entries);
+	result = vdo_allocate(VDO_BLOCK_SIZE, __func__, &block->outgoing_entries);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -4114,8 +4108,7 @@ static int __must_check initialize_block_allocator(struct slab_depot *depot,
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = vdo_allocate(VDO_SLAB_SUMMARY_BLOCKS_PER_ZONE,
-			      struct slab_summary_block, __func__,
+	result = vdo_allocate(VDO_SLAB_SUMMARY_BLOCKS_PER_ZONE, __func__,
 			      &allocator->summary_blocks);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -4174,8 +4167,7 @@ static int allocate_components(struct slab_depot *depot,
 
 	depot->summary_origin = summary_partition->offset;
 	depot->hint_shift = vdo_get_slab_summary_hint_shift(depot->slab_size_shift);
-	result = vdo_allocate(MAXIMUM_VDO_SLAB_SUMMARY_ENTRIES,
-			      struct slab_summary_entry, __func__,
+	result = vdo_allocate(MAXIMUM_VDO_SLAB_SUMMARY_ENTRIES, __func__,
 			      &depot->summary_entries);
 	if (result != VDO_SUCCESS)
 		return result;
diff --git a/drivers/md/dm-vdo/thread-utils.c b/drivers/md/dm-vdo/thread-utils.c
index ec08478dd013..826afc952b56 100644
--- a/drivers/md/dm-vdo/thread-utils.c
+++ b/drivers/md/dm-vdo/thread-utils.c
@@ -56,7 +56,7 @@ int vdo_create_thread(void (*thread_function)(void *), void *thread_data,
 	struct thread *thread;
 	int result;
 
-	result = vdo_allocate(1, struct thread, __func__, &thread);
+	result = vdo_allocate(1, __func__, &thread);
 	if (result != VDO_SUCCESS) {
 		vdo_log_warning("Error allocating memory for %s", name);
 		return result;
diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index 09fd0628d18c..167cf93a284a 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -207,29 +207,28 @@ static int __must_check initialize_thread_config(struct thread_count_config coun
 		config->hash_zone_count = counts.hash_zones;
 	}
 
-	result = vdo_allocate(config->logical_zone_count, thread_id_t,
-			      "logical thread array", &config->logical_threads);
+	result = vdo_allocate(config->logical_zone_count, "logical thread array",
+			      &config->logical_threads);
 	if (result != VDO_SUCCESS) {
 		uninitialize_thread_config(config);
 		return result;
 	}
 
-	result = vdo_allocate(config->physical_zone_count, thread_id_t,
-			      "physical thread array", &config->physical_threads);
+	result = vdo_allocate(config->physical_zone_count, "physical thread array",
+			      &config->physical_threads);
 	if (result != VDO_SUCCESS) {
 		uninitialize_thread_config(config);
 		return result;
 	}
 
-	result = vdo_allocate(config->hash_zone_count, thread_id_t,
-			      "hash thread array", &config->hash_zone_threads);
+	result = vdo_allocate(config->hash_zone_count, "hash thread array",
+			      &config->hash_zone_threads);
 	if (result != VDO_SUCCESS) {
 		uninitialize_thread_config(config);
 		return result;
 	}
 
-	result = vdo_allocate(config->bio_thread_count, thread_id_t,
-			      "bio thread array", &config->bio_threads);
+	result = vdo_allocate(config->bio_thread_count, "bio thread array", &config->bio_threads);
 	if (result != VDO_SUCCESS) {
 		uninitialize_thread_config(config);
 		return result;
@@ -269,7 +268,7 @@ static int __must_check read_geometry_block(struct vdo *vdo)
 	char *block;
 	int result;
 
-	result = vdo_allocate(VDO_BLOCK_SIZE, u8, __func__, &block);
+	result = vdo_allocate(VDO_BLOCK_SIZE, __func__, &block);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -493,7 +492,7 @@ static int initialize_vdo(struct vdo *vdo, struct device_config *config,
 		     config->thread_counts.hash_zones, vdo->thread_config.thread_count);
 
 	/* Compression context storage */
-	result = vdo_allocate(config->thread_counts.cpu_threads, char *, "LZ4 context",
+	result = vdo_allocate(config->thread_counts.cpu_threads, "LZ4 context",
 			      &vdo->compression_context);
 	if (result != VDO_SUCCESS) {
 		*reason = "cannot allocate LZ4 context";
@@ -501,7 +500,7 @@ static int initialize_vdo(struct vdo *vdo, struct device_config *config,
 	}
 
 	for (i = 0; i < config->thread_counts.cpu_threads; i++) {
-		result = vdo_allocate(LZ4_MEM_COMPRESS, char, "LZ4 context",
+		result = vdo_allocate(LZ4_MEM_COMPRESS, "LZ4 context",
 				      &vdo->compression_context[i]);
 		if (result != VDO_SUCCESS) {
 			*reason = "cannot allocate LZ4 context";
@@ -537,7 +536,7 @@ int vdo_make(unsigned int instance, struct device_config *config, char **reason,
 	/* Initialize with a generic failure reason to prevent returning garbage. */
 	*reason = "Unspecified error";
 
-	result = vdo_allocate(1, struct vdo, __func__, &vdo);
+	result = vdo_allocate(1, __func__, &vdo);
 	if (result != VDO_SUCCESS) {
 		*reason = "Cannot allocate VDO";
 		return result;
@@ -554,8 +553,7 @@ int vdo_make(unsigned int instance, struct device_config *config, char **reason,
 
 	snprintf(vdo->thread_name_prefix, sizeof(vdo->thread_name_prefix),
 		 "vdo%u", instance);
-	result = vdo_allocate(vdo->thread_config.thread_count,
-			      struct vdo_thread, __func__, &vdo->threads);
+	result = vdo_allocate(vdo->thread_config.thread_count, __func__, &vdo->threads);
 	if (result != VDO_SUCCESS) {
 		*reason = "Cannot allocate thread structures";
 		return result;
@@ -724,8 +722,7 @@ static int initialize_super_block(struct vdo *vdo, struct vdo_super_block *super
 {
 	int result;
 
-	result = vdo_allocate(VDO_BLOCK_SIZE, char, "encoded super block",
-			      (char **) &vdo->super_block.buffer);
+	result = vdo_allocate(VDO_BLOCK_SIZE, "encoded super block", &vdo->super_block.buffer);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -997,8 +994,7 @@ int vdo_register_read_only_listener(struct vdo *vdo, void *listener,
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = vdo_allocate(1, struct read_only_listener, __func__,
-			      &read_only_listener);
+	result = vdo_allocate(1, __func__, &read_only_listener);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/vio.c b/drivers/md/dm-vdo/vio.c
index cc739d52a70c..ea8ac619ff1b 100644
--- a/drivers/md/dm-vdo/vio.c
+++ b/drivers/md/dm-vdo/vio.c
@@ -129,7 +129,7 @@ int create_multi_block_metadata_vio(struct vdo *vdo, enum vio_type vio_type,
 	 * Metadata vios should use direct allocation and not use the buffer pool, which is
 	 * reserved for submissions from the linux block layer.
 	 */
-	result = vdo_allocate(1, struct vio, __func__, &vio);
+	result = vdo_allocate(1, __func__, &vio);
 	if (result != VDO_SUCCESS) {
 		vdo_log_error("metadata vio allocation failure %d", result);
 		return result;
@@ -335,8 +335,7 @@ int make_vio_pool(struct vdo *vdo, size_t pool_size, size_t block_count, thread_
 	INIT_LIST_HEAD(&pool->available);
 	INIT_LIST_HEAD(&pool->busy);
 
-	result = vdo_allocate(pool_size * per_vio_size, char,
-			      "VIO pool buffer", &pool->buffer);
+	result = vdo_allocate(pool_size * per_vio_size, "VIO pool buffer", &pool->buffer);
 	if (result != VDO_SUCCESS) {
 		free_vio_pool(pool);
 		return result;
-- 
2.53.0

