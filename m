Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4817651C52
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267941; cv=none; b=jdtOh7C084ajPbQ392/elWDNcG11CLCKPkDSR0Tu91CFIlr7SgnaI7kNBYsWX9dgTuq5kVf5mkjpPJJ15piH/WGxlCcej2cs/HnCFpCO8rQCLlY9IuEwwnyp+es2lIW40qhoGIJu9w3G6I1ytEpet7fU0zunH4TcNclHkGAHsGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267941; c=relaxed/simple;
	bh=Jy+bmkN5idybLkMLGfdxJwOUaZK805dicUHGdf0focY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ifAbRECZGaxdmV20yfx6MdSnJbTUm4vRcIT/EV5Yg0DOcBRu9cOFlLfQexwRIOaiStQNMkDja2sd3Wr186XdUIX518nVK1xjx2+8Szb2XnB6lHkcCw/w0UibXzTaB3owH/++TMNQZYXhYcEWj1BBOZGkDC/xZFRDzVZX+BXVUmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PCO1D1N1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PCO1D1N1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZGwmPXlq0vQCwEykQrU/KEnBODSaqWE2leMAMplKws=;
	b=PCO1D1N1Np2KTrzpfvqlZyteyj8gTjf+bYM+8mKpJb8Dm6+Si4JSufH7nXjvlILgRwRV7L
	UL16dQHSa1iIoDUu9gmVxuF8FK2s7gV2yME8ZBOyj3B8asP663SGZ9ruDSbIH5Mt5jpz+D
	z9H1WVRlW3F+gPuIMIVZv+ZOf/uvWyo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-gUjQv--5OWKYlObVf4oTwA-1; Thu, 29 Feb 2024 23:38:55 -0500
X-MC-Unique: gUjQv--5OWKYlObVf4oTwA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2928832BCB;
	Fri,  1 Mar 2024 04:38:53 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BCA07492BE8;
	Fri,  1 Mar 2024 04:38:53 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id B87FEA161E; Thu, 29 Feb 2024 23:38:53 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 03/10] dm vdo: check for VDO_SUCCESS return value from memory-alloc functions
Date: Thu, 29 Feb 2024 23:38:46 -0500
Message-ID: <7df964ed1e80ee3e2cf32a1c7057da1a3adad46d.1709267597.git.msakai@redhat.com>
In-Reply-To: <cover.1709267597.git.msakai@redhat.com>
References: <cover.1709267597.git.msakai@redhat.com>
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

From: Mike Snitzer <snitzer@kernel.org>

VDO_SUCCESS and UDS_SUCCESS were used interchangably, update all
callers of VDO's memory-alloc functions to consistently check for
VDO_SUCCESS.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.c                  |  6 +++---
 drivers/md/dm-vdo/data-vio.c                   |  2 +-
 drivers/md/dm-vdo/dm-vdo-target.c              | 18 +++++++++---------
 drivers/md/dm-vdo/encodings.c                  |  2 +-
 drivers/md/dm-vdo/funnel-queue.c               |  2 +-
 drivers/md/dm-vdo/funnel-workqueue.c           |  6 +++---
 drivers/md/dm-vdo/indexer/chapter-index.c      |  2 +-
 drivers/md/dm-vdo/indexer/config.c             |  2 +-
 drivers/md/dm-vdo/indexer/delta-index.c        | 10 +++++-----
 .../md/dm-vdo/indexer/funnel-requestqueue.c    |  2 +-
 drivers/md/dm-vdo/indexer/geometry.c           |  2 +-
 drivers/md/dm-vdo/indexer/index-layout.c       | 18 +++++++++---------
 drivers/md/dm-vdo/indexer/index-page-map.c     |  8 ++++----
 drivers/md/dm-vdo/indexer/index-session.c      |  2 +-
 drivers/md/dm-vdo/indexer/index.c              | 12 ++++++------
 drivers/md/dm-vdo/indexer/io-factory.c         |  6 +++---
 drivers/md/dm-vdo/indexer/open-chapter.c       |  4 ++--
 drivers/md/dm-vdo/indexer/radix-sort.c         |  2 +-
 drivers/md/dm-vdo/indexer/sparse-cache.c       |  8 ++++----
 drivers/md/dm-vdo/indexer/volume-index.c       |  6 +++---
 drivers/md/dm-vdo/indexer/volume.c             | 14 +++++++-------
 drivers/md/dm-vdo/int-map.c                    | 18 +++++++++---------
 drivers/md/dm-vdo/io-submitter.c               |  2 +-
 drivers/md/dm-vdo/message-stats.c              |  2 +-
 drivers/md/dm-vdo/slab-depot.c                 |  2 +-
 drivers/md/dm-vdo/thread-utils.c               |  2 +-
 drivers/md/dm-vdo/uds-sysfs.c                  |  2 +-
 drivers/md/dm-vdo/vdo.c                        |  2 +-
 28 files changed, 82 insertions(+), 82 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index b09974ad41d2..c4719fb30f86 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -223,11 +223,11 @@ static int __must_check allocate_cache_components(struct vdo_page_cache *cache)
 
 	result = vdo_allocate(cache->page_count, struct page_info, "page infos",
 			      &cache->infos);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	result = vdo_allocate_memory(size, VDO_BLOCK_SIZE, "cache pages", &cache->pages);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	result = vdo_int_map_create(cache->page_count, &cache->page_map);
@@ -2874,7 +2874,7 @@ int vdo_decode_block_map(struct block_map_state_2_0 state, block_count_t logical
 	result = vdo_allocate_extended(struct block_map,
 				       vdo->thread_config.logical_zone_count,
 				       struct block_map_zone, __func__, &map);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	map->vdo = vdo;
diff --git a/drivers/md/dm-vdo/data-vio.c b/drivers/md/dm-vdo/data-vio.c
index dcdd767e40e5..3d5054e61330 100644
--- a/drivers/md/dm-vdo/data-vio.c
+++ b/drivers/md/dm-vdo/data-vio.c
@@ -847,7 +847,7 @@ int make_data_vio_pool(struct vdo *vdo, data_vio_count_t pool_size,
 
 	result = vdo_allocate_extended(struct data_vio_pool, pool_size, struct data_vio,
 				       __func__, &pool);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	ASSERT_LOG_ONLY((discard_limit <= pool_size),
diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index 86c30fbd75ca..90ba379f8d3e 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -280,7 +280,7 @@ static int split_string(const char *string, char separator, char ***substring_ar
 
 	result = vdo_allocate(substring_count + 1, char *, "string-splitting array",
 			      &substrings);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	for (s = string; *s != 0; s++) {
@@ -289,7 +289,7 @@ static int split_string(const char *string, char separator, char ***substring_ar
 
 			result = vdo_allocate(length + 1, char, "split string",
 					      &substrings[current_substring]);
-			if (result != UDS_SUCCESS) {
+			if (result != VDO_SUCCESS) {
 				free_string_array(substrings);
 				return result;
 			}
@@ -310,7 +310,7 @@ static int split_string(const char *string, char separator, char ***substring_ar
 
 	result = vdo_allocate(length + 1, char, "split string",
 			      &substrings[current_substring]);
-	if (result != UDS_SUCCESS) {
+	if (result != VDO_SUCCESS) {
 		free_string_array(substrings);
 		return result;
 	}
@@ -1527,7 +1527,7 @@ static size_t get_bit_array_size(unsigned int bit_count)
  * Since the array is initially NULL, this also initializes the array the first time we allocate an
  * instance number.
  *
- * Return: UDS_SUCCESS or an error code from the allocation
+ * Return: VDO_SUCCESS or an error code from the allocation
  */
 static int grow_bit_array(void)
 {
@@ -1540,19 +1540,19 @@ static int grow_bit_array(void)
 				       get_bit_array_size(instances.bit_count),
 				       get_bit_array_size(new_count),
 				       "instance number bit array", &new_words);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	instances.bit_count = new_count;
 	instances.words = new_words;
-	return UDS_SUCCESS;
+	return VDO_SUCCESS;
 }
 
 /**
  * allocate_instance() - Allocate an instance number.
  * @instance_ptr: A point to hold the instance number
  *
- * Return: UDS_SUCCESS or an error code
+ * Return: VDO_SUCCESS or an error code
  *
  * This function must be called while holding the instances lock.
  */
@@ -1564,7 +1564,7 @@ static int allocate_instance(unsigned int *instance_ptr)
 	/* If there are no unallocated instances, grow the bit array. */
 	if (instances.count >= instances.bit_count) {
 		result = grow_bit_array();
-		if (result != UDS_SUCCESS)
+		if (result != VDO_SUCCESS)
 			return result;
 	}
 
@@ -1587,7 +1587,7 @@ static int allocate_instance(unsigned int *instance_ptr)
 	instances.count++;
 	instances.next = instance + 1;
 	*instance_ptr = instance;
-	return UDS_SUCCESS;
+	return VDO_SUCCESS;
 }
 
 static int construct_new_vdo_registered(struct dm_target *ti, unsigned int argc,
diff --git a/drivers/md/dm-vdo/encodings.c b/drivers/md/dm-vdo/encodings.c
index 56d94339d2af..a97771fe0a43 100644
--- a/drivers/md/dm-vdo/encodings.c
+++ b/drivers/md/dm-vdo/encodings.c
@@ -800,7 +800,7 @@ static int allocate_partition(struct layout *layout, u8 id,
 	int result;
 
 	result = vdo_allocate(1, struct partition, __func__, &partition);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	partition->id = id;
diff --git a/drivers/md/dm-vdo/funnel-queue.c b/drivers/md/dm-vdo/funnel-queue.c
index 67f7b52ecc86..ce0e801fd955 100644
--- a/drivers/md/dm-vdo/funnel-queue.c
+++ b/drivers/md/dm-vdo/funnel-queue.c
@@ -15,7 +15,7 @@ int uds_make_funnel_queue(struct funnel_queue **queue_ptr)
 	struct funnel_queue *queue;
 
 	result = vdo_allocate(1, struct funnel_queue, "funnel queue", &queue);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	/*
diff --git a/drivers/md/dm-vdo/funnel-workqueue.c b/drivers/md/dm-vdo/funnel-workqueue.c
index ebf8dce67086..a88f5c93eae5 100644
--- a/drivers/md/dm-vdo/funnel-workqueue.c
+++ b/drivers/md/dm-vdo/funnel-workqueue.c
@@ -324,7 +324,7 @@ static int make_simple_work_queue(const char *thread_name_prefix, const char *na
 			VDO_WORK_Q_MAX_PRIORITY);
 
 	result = vdo_allocate(1, struct simple_work_queue, "simple work queue", &queue);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	queue->private = private;
@@ -401,12 +401,12 @@ int vdo_make_work_queue(const char *thread_name_prefix, const char *name,
 
 	result = vdo_allocate(1, struct round_robin_work_queue, "round-robin work queue",
 			      &queue);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	result = vdo_allocate(thread_count, struct simple_work_queue *,
 			      "subordinate work queues", &queue->service_queues);
-	if (result != UDS_SUCCESS) {
+	if (result != VDO_SUCCESS) {
 		vdo_free(queue);
 		return result;
 	}
diff --git a/drivers/md/dm-vdo/indexer/chapter-index.c b/drivers/md/dm-vdo/indexer/chapter-index.c
index 9477150362ae..68d86028dbb7 100644
--- a/drivers/md/dm-vdo/indexer/chapter-index.c
+++ b/drivers/md/dm-vdo/indexer/chapter-index.c
@@ -21,7 +21,7 @@ int uds_make_open_chapter_index(struct open_chapter_index **chapter_index,
 	struct open_chapter_index *index;
 
 	result = vdo_allocate(1, struct open_chapter_index, "open chapter index", &index);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	/*
diff --git a/drivers/md/dm-vdo/indexer/config.c b/drivers/md/dm-vdo/indexer/config.c
index cd20ee8b9a02..5da39043b9ae 100644
--- a/drivers/md/dm-vdo/indexer/config.c
+++ b/drivers/md/dm-vdo/indexer/config.c
@@ -326,7 +326,7 @@ int uds_make_configuration(const struct uds_parameters *params,
 		return result;
 
 	result = vdo_allocate(1, struct uds_configuration, __func__, &config);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	result = uds_make_index_geometry(DEFAULT_BYTES_PER_PAGE, record_pages_per_chapter,
diff --git a/drivers/md/dm-vdo/indexer/delta-index.c b/drivers/md/dm-vdo/indexer/delta-index.c
index 11f7b85b6710..5bba9a48c5a0 100644
--- a/drivers/md/dm-vdo/indexer/delta-index.c
+++ b/drivers/md/dm-vdo/indexer/delta-index.c
@@ -312,18 +312,18 @@ static int initialize_delta_zone(struct delta_zone *delta_zone, size_t size,
 	int result;
 
 	result = vdo_allocate(size, u8, "delta list", &delta_zone->memory);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	result = vdo_allocate(list_count + 2, u64, "delta list temp",
 			      &delta_zone->new_offsets);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	/* Allocate the delta lists. */
 	result = vdo_allocate(list_count + 2, struct delta_list, "delta lists",
 			      &delta_zone->delta_lists);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	compute_coding_constants(mean_delta, &delta_zone->min_bits,
@@ -354,7 +354,7 @@ int uds_initialize_delta_index(struct delta_index *delta_index, unsigned int zon
 
 	result = vdo_allocate(zone_count, struct delta_zone, "Delta Index Zones",
 			      &delta_index->delta_zones);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	delta_index->zone_count = zone_count;
@@ -1048,7 +1048,7 @@ int uds_finish_restoring_delta_index(struct delta_index *delta_index,
 	u8 *data;
 
 	result = vdo_allocate(DELTA_LIST_MAX_BYTE_COUNT, u8, __func__, &data);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	for (z = 0; z < reader_count; z++) {
diff --git a/drivers/md/dm-vdo/indexer/funnel-requestqueue.c b/drivers/md/dm-vdo/indexer/funnel-requestqueue.c
index 95a402ec31c9..eee7b980960f 100644
--- a/drivers/md/dm-vdo/indexer/funnel-requestqueue.c
+++ b/drivers/md/dm-vdo/indexer/funnel-requestqueue.c
@@ -199,7 +199,7 @@ int uds_make_request_queue(const char *queue_name,
 	struct uds_request_queue *queue;
 
 	result = vdo_allocate(1, struct uds_request_queue, __func__, &queue);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	queue->processor = processor;
diff --git a/drivers/md/dm-vdo/indexer/geometry.c b/drivers/md/dm-vdo/indexer/geometry.c
index c735e6cb4425..c0575612e820 100644
--- a/drivers/md/dm-vdo/indexer/geometry.c
+++ b/drivers/md/dm-vdo/indexer/geometry.c
@@ -62,7 +62,7 @@ int uds_make_index_geometry(size_t bytes_per_page, u32 record_pages_per_chapter,
 	struct index_geometry *geometry;
 
 	result = vdo_allocate(1, struct index_geometry, "geometry", &geometry);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	geometry->bytes_per_page = bytes_per_page;
diff --git a/drivers/md/dm-vdo/indexer/index-layout.c b/drivers/md/dm-vdo/indexer/index-layout.c
index c1bcff03cc55..01e0db4184aa 100644
--- a/drivers/md/dm-vdo/indexer/index-layout.c
+++ b/drivers/md/dm-vdo/indexer/index-layout.c
@@ -487,7 +487,7 @@ static int __must_check make_index_save_region_table(struct index_save_layout *i
 	result = vdo_allocate_extended(struct region_table, region_count,
 				       struct layout_region,
 				       "layout region table for ISL", &table);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	lr = &table->regions[0];
@@ -546,7 +546,7 @@ static int __must_check write_index_save_header(struct index_save_layout *isl,
 	size_t offset = 0;
 
 	result = vdo_allocate(table->encoded_size, u8, "index save data", &buffer);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	encode_region_table(buffer, &offset, table);
@@ -670,7 +670,7 @@ static int __must_check make_layout_region_table(struct index_layout *layout,
 	result = vdo_allocate_extended(struct region_table, region_count,
 				       struct layout_region, "layout region table",
 				       &table);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	lr = &table->regions[0];
@@ -716,7 +716,7 @@ static int __must_check write_layout_header(struct index_layout *layout,
 	size_t offset = 0;
 
 	result = vdo_allocate(table->encoded_size, u8, "layout data", &buffer);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	encode_region_table(buffer, &offset, table);
@@ -807,7 +807,7 @@ static int create_index_layout(struct index_layout *layout, struct uds_configura
 
 	result = vdo_allocate(sizes.save_count, struct index_save_layout, __func__,
 			      &layout->index.saves);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	initialize_layout(layout, &sizes);
@@ -1165,7 +1165,7 @@ static int __must_check load_region_table(struct buffered_reader *reader,
 	result = vdo_allocate_extended(struct region_table, header.region_count,
 				       struct layout_region,
 				       "single file layout region table", &table);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	table->header = header;
@@ -1202,7 +1202,7 @@ static int __must_check read_super_block_data(struct buffered_reader *reader,
 	size_t offset = 0;
 
 	result = vdo_allocate(saved_size, u8, "super block data", &buffer);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	result = uds_read_from_buffered_reader(reader, buffer, saved_size);
@@ -1337,7 +1337,7 @@ static int __must_check reconstitute_layout(struct index_layout *layout,
 
 	result = vdo_allocate(layout->super.max_saves, struct index_save_layout,
 			      __func__, &layout->index.saves);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	layout->total_blocks = table->header.region_blocks;
@@ -1696,7 +1696,7 @@ int uds_make_index_layout(struct uds_configuration *config, bool new_layout,
 		return result;
 
 	result = vdo_allocate(1, struct index_layout, __func__, &layout);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	result = create_layout_factory(layout, config);
diff --git a/drivers/md/dm-vdo/indexer/index-page-map.c b/drivers/md/dm-vdo/indexer/index-page-map.c
index ddb6d843cbd9..c5d1b9995846 100644
--- a/drivers/md/dm-vdo/indexer/index-page-map.c
+++ b/drivers/md/dm-vdo/indexer/index-page-map.c
@@ -39,14 +39,14 @@ int uds_make_index_page_map(const struct index_geometry *geometry,
 	struct index_page_map *map;
 
 	result = vdo_allocate(1, struct index_page_map, "page map", &map);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	map->geometry = geometry;
 	map->entries_per_chapter = geometry->index_pages_per_chapter - 1;
 	result = vdo_allocate(get_entry_count(geometry), u16, "Index Page Map Entries",
 			      &map->entries);
-	if (result != UDS_SUCCESS) {
+	if (result != VDO_SUCCESS) {
 		uds_free_index_page_map(map);
 		return result;
 	}
@@ -119,7 +119,7 @@ int uds_write_index_page_map(struct index_page_map *map, struct buffered_writer
 	u32 i;
 
 	result = vdo_allocate(saved_size, u8, "page map data", &buffer);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	memcpy(buffer, PAGE_MAP_MAGIC, PAGE_MAP_MAGIC_LENGTH);
@@ -146,7 +146,7 @@ int uds_read_index_page_map(struct index_page_map *map, struct buffered_reader *
 	u32 i;
 
 	result = vdo_allocate(saved_size, u8, "page map data", &buffer);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	result = uds_read_from_buffered_reader(reader, buffer, saved_size);
diff --git a/drivers/md/dm-vdo/indexer/index-session.c b/drivers/md/dm-vdo/indexer/index-session.c
index 0f920a583021..22445dcb3fe0 100644
--- a/drivers/md/dm-vdo/indexer/index-session.c
+++ b/drivers/md/dm-vdo/indexer/index-session.c
@@ -222,7 +222,7 @@ static int __must_check make_empty_index_session(struct uds_index_session **inde
 	struct uds_index_session *session;
 
 	result = vdo_allocate(1, struct uds_index_session, __func__, &session);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	mutex_init(&session->request_mutex);
diff --git a/drivers/md/dm-vdo/indexer/index.c b/drivers/md/dm-vdo/indexer/index.c
index c576033b8a53..243a9deab4de 100644
--- a/drivers/md/dm-vdo/indexer/index.c
+++ b/drivers/md/dm-vdo/indexer/index.c
@@ -89,7 +89,7 @@ static int launch_zone_message(struct uds_zone_message message, unsigned int zon
 	struct uds_request *request;
 
 	result = vdo_allocate(1, struct uds_request, __func__, &request);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	request->index = index;
@@ -770,7 +770,7 @@ static int make_chapter_writer(struct uds_index *index,
 	result = vdo_allocate_extended(struct chapter_writer, index->zone_count,
 				       struct open_chapter_zone *, "Chapter Writer",
 				       &writer);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	writer->index = index;
@@ -779,7 +779,7 @@ static int make_chapter_writer(struct uds_index *index,
 
 	result = vdo_allocate_cache_aligned(collated_records_size, "collated records",
 					    &writer->collated_records);
-	if (result != UDS_SUCCESS) {
+	if (result != VDO_SUCCESS) {
 		free_chapter_writer(writer);
 		return result;
 	}
@@ -1127,7 +1127,7 @@ static int make_index_zone(struct uds_index *index, unsigned int zone_number)
 	struct index_zone *zone;
 
 	result = vdo_allocate(1, struct index_zone, "index zone", &zone);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	result = uds_make_open_chapter(index->volume->geometry, index->zone_count,
@@ -1165,7 +1165,7 @@ int uds_make_index(struct uds_configuration *config, enum uds_open_index_type op
 
 	result = vdo_allocate_extended(struct uds_index, config->zone_count,
 				       struct uds_request_queue *, "index", &index);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	index->zone_count = config->zone_count;
@@ -1178,7 +1178,7 @@ int uds_make_index(struct uds_configuration *config, enum uds_open_index_type op
 
 	result = vdo_allocate(index->zone_count, struct index_zone *, "zones",
 			      &index->zones);
-	if (result != UDS_SUCCESS) {
+	if (result != VDO_SUCCESS) {
 		uds_free_index(index);
 		return result;
 	}
diff --git a/drivers/md/dm-vdo/indexer/io-factory.c b/drivers/md/dm-vdo/indexer/io-factory.c
index 749c950c0189..0dcf6d596653 100644
--- a/drivers/md/dm-vdo/indexer/io-factory.c
+++ b/drivers/md/dm-vdo/indexer/io-factory.c
@@ -65,7 +65,7 @@ int uds_make_io_factory(struct block_device *bdev, struct io_factory **factory_p
 	struct io_factory *factory;
 
 	result = vdo_allocate(1, struct io_factory, __func__, &factory);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	factory->bdev = bdev;
@@ -145,7 +145,7 @@ int uds_make_buffered_reader(struct io_factory *factory, off_t offset, u64 block
 		return result;
 
 	result = vdo_allocate(1, struct buffered_reader, "buffered reader", &reader);
-	if (result != UDS_SUCCESS) {
+	if (result != VDO_SUCCESS) {
 		dm_bufio_client_destroy(client);
 		return result;
 	}
@@ -283,7 +283,7 @@ int uds_make_buffered_writer(struct io_factory *factory, off_t offset, u64 block
 		return result;
 
 	result = vdo_allocate(1, struct buffered_writer, "buffered writer", &writer);
-	if (result != UDS_SUCCESS) {
+	if (result != VDO_SUCCESS) {
 		dm_bufio_client_destroy(client);
 		return result;
 	}
diff --git a/drivers/md/dm-vdo/indexer/open-chapter.c b/drivers/md/dm-vdo/indexer/open-chapter.c
index 4a4dc94915dd..46b7bc1ac324 100644
--- a/drivers/md/dm-vdo/indexer/open-chapter.c
+++ b/drivers/md/dm-vdo/indexer/open-chapter.c
@@ -71,14 +71,14 @@ int uds_make_open_chapter(const struct index_geometry *geometry, unsigned int zo
 	result = vdo_allocate_extended(struct open_chapter_zone, slot_count,
 				       struct open_chapter_zone_slot, "open chapter",
 				       &open_chapter);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	open_chapter->slot_count = slot_count;
 	open_chapter->capacity = capacity;
 	result = vdo_allocate_cache_aligned(records_size(open_chapter), "record pages",
 					    &open_chapter->records);
-	if (result != UDS_SUCCESS) {
+	if (result != VDO_SUCCESS) {
 		uds_free_open_chapter(open_chapter);
 		return result;
 	}
diff --git a/drivers/md/dm-vdo/indexer/radix-sort.c b/drivers/md/dm-vdo/indexer/radix-sort.c
index 74ea18b8e9be..66b8c706a1ef 100644
--- a/drivers/md/dm-vdo/indexer/radix-sort.c
+++ b/drivers/md/dm-vdo/indexer/radix-sort.c
@@ -213,7 +213,7 @@ int uds_make_radix_sorter(unsigned int count, struct radix_sorter **sorter)
 
 	result = vdo_allocate_extended(struct radix_sorter, stack_size, struct task,
 				       __func__, &radix_sorter);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	radix_sorter->count = count;
diff --git a/drivers/md/dm-vdo/indexer/sparse-cache.c b/drivers/md/dm-vdo/indexer/sparse-cache.c
index e297ba2d6ceb..28920167827c 100644
--- a/drivers/md/dm-vdo/indexer/sparse-cache.c
+++ b/drivers/md/dm-vdo/indexer/sparse-cache.c
@@ -224,7 +224,7 @@ static int __must_check initialize_cached_chapter_index(struct cached_chapter_in
 
 	result = vdo_allocate(chapter->index_pages_count, struct delta_index_page,
 			      __func__, &chapter->index_pages);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	return vdo_allocate(chapter->index_pages_count, struct dm_buffer *,
@@ -242,7 +242,7 @@ static int __must_check make_search_list(struct sparse_cache *cache,
 	bytes = (sizeof(struct search_list) +
 		 (cache->capacity * sizeof(struct cached_chapter_index *)));
 	result = vdo_allocate_cache_aligned(bytes, "search list", &list);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	list->capacity = cache->capacity;
@@ -265,7 +265,7 @@ int uds_make_sparse_cache(const struct index_geometry *geometry, unsigned int ca
 
 	bytes = (sizeof(struct sparse_cache) + (capacity * sizeof(struct cached_chapter_index)));
 	result = vdo_allocate_cache_aligned(bytes, "sparse cache", &cache);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	cache->geometry = geometry;
@@ -296,7 +296,7 @@ int uds_make_sparse_cache(const struct index_geometry *geometry, unsigned int ca
 	/* purge_search_list() needs some temporary lists for sorting. */
 	result = vdo_allocate(capacity * 2, struct cached_chapter_index *,
 			      "scratch entries", &cache->scratch_entries);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		goto out;
 
 	*cache_ptr = cache;
diff --git a/drivers/md/dm-vdo/indexer/volume-index.c b/drivers/md/dm-vdo/indexer/volume-index.c
index 1a762e6dd709..1cc9ac4fe510 100644
--- a/drivers/md/dm-vdo/indexer/volume-index.c
+++ b/drivers/md/dm-vdo/indexer/volume-index.c
@@ -1213,7 +1213,7 @@ static int initialize_volume_sub_index(const struct uds_configuration *config,
 	/* The following arrays are initialized to all zeros. */
 	result = vdo_allocate(params.list_count, u64, "first chapter to flush",
 			      &sub_index->flush_chapters);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	return vdo_allocate(zone_count, struct volume_sub_index_zone,
@@ -1229,7 +1229,7 @@ int uds_make_volume_index(const struct uds_configuration *config, u64 volume_non
 	int result;
 
 	result = vdo_allocate(1, struct volume_index, "volume index", &volume_index);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	volume_index->zone_count = config->zone_count;
@@ -1251,7 +1251,7 @@ int uds_make_volume_index(const struct uds_configuration *config, u64 volume_non
 
 	result = vdo_allocate(config->zone_count, struct volume_index_zone,
 			      "volume index zones", &volume_index->zones);
-	if (result != UDS_SUCCESS) {
+	if (result != VDO_SUCCESS) {
 		uds_free_volume_index(volume_index);
 		return result;
 	}
diff --git a/drivers/md/dm-vdo/indexer/volume.c b/drivers/md/dm-vdo/indexer/volume.c
index 2d8901732f5d..959dd82ef665 100644
--- a/drivers/md/dm-vdo/indexer/volume.c
+++ b/drivers/md/dm-vdo/indexer/volume.c
@@ -1509,22 +1509,22 @@ static int __must_check initialize_page_cache(struct page_cache *cache,
 
 	result = vdo_allocate(VOLUME_CACHE_MAX_QUEUED_READS, struct queued_read,
 			      "volume read queue", &cache->read_queue);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	result = vdo_allocate(cache->zone_count, struct search_pending_counter,
 			      "Volume Cache Zones", &cache->search_pending_counters);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	result = vdo_allocate(cache->indexable_pages, u16, "page cache index",
 			      &cache->index);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	result = vdo_allocate(cache->cache_slots, struct cached_page, "page cache cache",
 			      &cache->cache);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	/* Initialize index values to invalid values. */
@@ -1547,7 +1547,7 @@ int uds_make_volume(const struct uds_configuration *config, struct index_layout
 	int result;
 
 	result = vdo_allocate(1, struct volume, "volume", &volume);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	volume->nonce = uds_get_volume_nonce(layout);
@@ -1586,7 +1586,7 @@ int uds_make_volume(const struct uds_configuration *config, struct index_layout
 	result = vdo_allocate(geometry->records_per_page,
 			      const struct uds_volume_record *, "record pointers",
 			      &volume->record_pointers);
-	if (result != UDS_SUCCESS) {
+	if (result != VDO_SUCCESS) {
 		uds_free_volume(volume);
 		return result;
 	}
@@ -1626,7 +1626,7 @@ int uds_make_volume(const struct uds_configuration *config, struct index_layout
 
 	result = vdo_allocate(config->read_threads, struct thread *, "reader threads",
 			      &volume->reader_threads);
-	if (result != UDS_SUCCESS) {
+	if (result != VDO_SUCCESS) {
 		uds_free_volume(volume);
 		return result;
 	}
diff --git a/drivers/md/dm-vdo/int-map.c b/drivers/md/dm-vdo/int-map.c
index 0bd742ecbe2e..9849d12f2a36 100644
--- a/drivers/md/dm-vdo/int-map.c
+++ b/drivers/md/dm-vdo/int-map.c
@@ -152,7 +152,7 @@ static u64 hash_key(u64 key)
  * @map: The map to initialize.
  * @capacity: The initial capacity of the map.
  *
- * Return: UDS_SUCCESS or an error code.
+ * Return: VDO_SUCCESS or an error code.
  */
 static int allocate_buckets(struct int_map *map, size_t capacity)
 {
@@ -174,7 +174,7 @@ static int allocate_buckets(struct int_map *map, size_t capacity)
  *                    tells the map to use its own small default).
  * @map_ptr: Output, a pointer to hold the new int_map.
  *
- * Return: UDS_SUCCESS or an error code.
+ * Return: VDO_SUCCESS or an error code.
  */
 int vdo_int_map_create(size_t initial_capacity, struct int_map **map_ptr)
 {
@@ -183,7 +183,7 @@ int vdo_int_map_create(size_t initial_capacity, struct int_map **map_ptr)
 	size_t capacity;
 
 	result = vdo_allocate(1, struct int_map, "struct int_map", &map);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	/* Use the default capacity if the caller did not specify one. */
@@ -196,13 +196,13 @@ int vdo_int_map_create(size_t initial_capacity, struct int_map **map_ptr)
 	capacity = capacity * 100 / DEFAULT_LOAD;
 
 	result = allocate_buckets(map, capacity);
-	if (result != UDS_SUCCESS) {
+	if (result != VDO_SUCCESS) {
 		vdo_int_map_free(vdo_forget(map));
 		return result;
 	}
 
 	*map_ptr = map;
-	return UDS_SUCCESS;
+	return VDO_SUCCESS;
 }
 
 /**
@@ -368,7 +368,7 @@ void *vdo_int_map_get(struct int_map *map, u64 key)
  *
  * Resizes and rehashes all the existing entries, storing them in the new buckets.
  *
- * Return: UDS_SUCCESS or an error code.
+ * Return: VDO_SUCCESS or an error code.
  */
 static int resize_buckets(struct int_map *map)
 {
@@ -384,7 +384,7 @@ static int resize_buckets(struct int_map *map)
 	uds_log_info("%s: attempting resize from %zu to %zu, current size=%zu",
 		     __func__, map->capacity, new_capacity, map->size);
 	result = allocate_buckets(map, new_capacity);
-	if (result != UDS_SUCCESS) {
+	if (result != VDO_SUCCESS) {
 		*map = old_map;
 		return result;
 	}
@@ -407,7 +407,7 @@ static int resize_buckets(struct int_map *map)
 
 	/* Destroy the old bucket array. */
 	vdo_free(vdo_forget(old_map.buckets));
-	return UDS_SUCCESS;
+	return VDO_SUCCESS;
 }
 
 /**
@@ -647,7 +647,7 @@ int vdo_int_map_put(struct int_map *map, u64 key, void *new_value, bool update,
 		 * large maps).
 		 */
 		result = resize_buckets(map);
-		if (result != UDS_SUCCESS)
+		if (result != VDO_SUCCESS)
 			return result;
 
 		/*
diff --git a/drivers/md/dm-vdo/io-submitter.c b/drivers/md/dm-vdo/io-submitter.c
index 23549b7e9e6d..b0f1ba810cd0 100644
--- a/drivers/md/dm-vdo/io-submitter.c
+++ b/drivers/md/dm-vdo/io-submitter.c
@@ -383,7 +383,7 @@ int vdo_make_io_submitter(unsigned int thread_count, unsigned int rotation_inter
 	result = vdo_allocate_extended(struct io_submitter, thread_count,
 				       struct bio_queue_data, "bio submission data",
 				       &io_submitter);
-	if (result != UDS_SUCCESS)
+	if (result != VDO_SUCCESS)
 		return result;
 
 	io_submitter->bio_queue_rotation_interval = rotation_interval;
diff --git a/drivers/md/dm-vdo/message-stats.c b/drivers/md/dm-vdo/message-stats.c
index ec24fff2a21b..18c9d2af8aed 100644
--- a/drivers/md/dm-vdo/message-stats.c
+++ b/drivers/md/dm-vdo/message-stats.c
@@ -420,7 +420,7 @@ int vdo_write_stats(struct vdo *vdo, char *buf, unsigned int maxlen)
 	int result;
 
 	result = vdo_allocate(1, struct vdo_statistics, __func__, &stats);
-	if (result != UDS_SUCCESS) {
+	if (result != VDO_SUCCESS) {
 		uds_log_error("Cannot allocate memory to write VDO statistics");
 		return result;
 	}
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 2d2cccf89edb..97208c9e0062 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -2379,7 +2379,7 @@ static int allocate_slab_counters(struct vdo_slab *slab)
 	bytes = (slab->reference_block_count * COUNTS_PER_BLOCK) + (2 * BYTES_PER_WORD);
 	result = vdo_allocate(bytes, vdo_refcount_t, "ref counts array",
 			      &slab->counters);
-	if (result != UDS_SUCCESS) {
+	if (result != VDO_SUCCESS) {
 		vdo_free(vdo_forget(slab->reference_blocks));
 		return result;
 	}
diff --git a/drivers/md/dm-vdo/thread-utils.c b/drivers/md/dm-vdo/thread-utils.c
index ad7682784459..b4aa71fffdbf 100644
--- a/drivers/md/dm-vdo/thread-utils.c
+++ b/drivers/md/dm-vdo/thread-utils.c
@@ -83,7 +83,7 @@ int vdo_create_thread(void (*thread_function)(void *), void *thread_data,
 	int result;
 
 	result = vdo_allocate(1, struct thread, __func__, &thread);
-	if (result != UDS_SUCCESS) {
+	if (result != VDO_SUCCESS) {
 		uds_log_warning("Error allocating memory for %s", name);
 		return result;
 	}
diff --git a/drivers/md/dm-vdo/uds-sysfs.c b/drivers/md/dm-vdo/uds-sysfs.c
index d1d5a30b3717..753d81d6f207 100644
--- a/drivers/md/dm-vdo/uds-sysfs.c
+++ b/drivers/md/dm-vdo/uds-sysfs.c
@@ -35,7 +35,7 @@ static char *buffer_to_string(const char *buf, size_t length)
 {
 	char *string;
 
-	if (vdo_allocate(length + 1, char, __func__, &string) != UDS_SUCCESS)
+	if (vdo_allocate(length + 1, char, __func__, &string) != VDO_SUCCESS)
 		return NULL;
 
 	memcpy(string, buf, length);
diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index ae62f260c5ec..b4dd0634a5cb 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -545,7 +545,7 @@ int vdo_make(unsigned int instance, struct device_config *config, char **reason,
 	*reason = "Unspecified error";
 
 	result = vdo_allocate(1, struct vdo, __func__, &vdo);
-	if (result != UDS_SUCCESS) {
+	if (result != VDO_SUCCESS) {
 		*reason = "Cannot allocate VDO";
 		return result;
 	}
-- 
2.42.0

