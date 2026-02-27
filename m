Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2735A274FD0
	for <dm-devel@lists.linux.dev>; Fri, 27 Feb 2026 01:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772154734; cv=none; b=ErazeFq03CnZ10NnNKSn5pe1Hdr5GlQl13FjhTDWGAd6Pz+T8LBHv6hLUdTxBMzH4SZsOfRi7JKUbEXUBKtSby+0JPrnA21Co4fmVaPTIh9Ils26fnq6uaQdPVXAxE0RXQQq3/N/WErw/uoekAN1KA1KfLvym+t4AzQDhS5yuTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772154734; c=relaxed/simple;
	bh=iQdBW9lPGfBlnWRfYOYMwBSzm8JvZ2wjBO3EJwMgLVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=q4GsY5VuMipt4/L6miduMhQxY/S+CNKhW5RVG5IJy1e7T4ybowENNDVIhjSXi97OJ9NEI3KjR+AUg8g+BDFoj/paZRdj65xJtRaimgcZL448r5nLqXsEAe4PdYEvBtpAsz7ptZckLygToUMGvRrf/hI+4v8MMIGwMm1InKa0skY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E0lmz1Hc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E0lmz1Hc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772154731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OLz9RwxBkQxKYt25fCThlQJN4g9AkHe61fxhioxbaho=;
	b=E0lmz1HcPGnCD7JBs+hvwhFbM1dVhJKoNObIMsIKZH8JGT6jU/RDbJq+Ygtbzram4RwaNP
	ajKiTIka1Lb7JQSbu8R3yjaDHd3TvD1FzSWkmpi8dz4KehR/LH2w80khycLxgKKjaZ0OYy
	lQACZN+2Y3uBsZRMijIz2uB+18OwUgo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-496-PmTk7YRvOv2kyKz1NF-2aw-1; Thu,
 26 Feb 2026 20:12:09 -0500
X-MC-Unique: PmTk7YRvOv2kyKz1NF-2aw-1
X-Mimecast-MFC-AGG-ID: PmTk7YRvOv2kyKz1NF-2aw_1772154729
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C75F2195608A
	for <dm-devel@lists.linux.dev>; Fri, 27 Feb 2026 01:12:08 +0000 (UTC)
Received: from vdo-builder-raeburn.permabit.com (unknown [10.0.101.17])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 95C971800465;
	Fri, 27 Feb 2026 01:12:08 +0000 (UTC)
Received: by vdo-builder-raeburn.permabit.com (Postfix, from userid 1065)
	id 3177F25692; Thu, 26 Feb 2026 20:12:08 -0500 (EST)
From: Ken Raeburn <raeburn@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Ken Raeburn <raeburn@redhat.com>
Subject: [PATCH 1/3] dm vdo: update vdo_allocate_extended to take a field name, no types
Date: Thu, 26 Feb 2026 20:12:06 -0500
Message-ID: <805b816e1b467a9fb4af15c9704ab2c34be218a9.1772153845.git.raeburn@redhat.com>
In-Reply-To: <cover.1772153845.git.raeburn@redhat.com>
References: <cover.1772153845.git.raeburn@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZRmSmRjMp_5lodxoHmfppbTjca69Jl0kmHPGZiunDfc_1772154729
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

All of VDO's "extended" allocations use a flexible array field at the
end of the allocated structure. We can infer the struct type from the
supplied pointer. Replacing the array field type with the field name
lets us use struct_size from overflow.h to compute the size instead of
the local __vdo_do_allocation version.

One allocation of bio structures doesn't conform to this pattern,
since the removal of bi_inline_vecs; directly compute the total size
for that case.

Signed-off-by: Ken Raeburn <raeburn@redhat.com>
---
 drivers/md/dm-vdo/block-map.c            | 16 +++++---------
 drivers/md/dm-vdo/data-vio.c             |  3 +--
 drivers/md/dm-vdo/dedupe.c               |  3 +--
 drivers/md/dm-vdo/indexer/index-layout.c | 11 ++++------
 drivers/md/dm-vdo/indexer/index.c        |  7 ++----
 drivers/md/dm-vdo/indexer/open-chapter.c |  4 +---
 drivers/md/dm-vdo/indexer/radix-sort.c   |  3 +--
 drivers/md/dm-vdo/io-submitter.c         |  3 +--
 drivers/md/dm-vdo/logical-zone.c         |  3 +--
 drivers/md/dm-vdo/memory-alloc.h         | 27 ++++++++----------------
 drivers/md/dm-vdo/packer.c               |  7 +++---
 drivers/md/dm-vdo/physical-zone.c        |  6 ++----
 drivers/md/dm-vdo/priority-table.c       |  3 +--
 drivers/md/dm-vdo/recovery-journal.c     |  6 ++----
 drivers/md/dm-vdo/repair.c               |  4 +---
 drivers/md/dm-vdo/slab-depot.c           |  5 ++---
 drivers/md/dm-vdo/vio.c                  |  7 +++---
 17 files changed, 40 insertions(+), 78 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index a7db5b41155e..25eda82a9635 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -2478,9 +2478,7 @@ static int make_forest(struct block_map *map, block_count_t entries)
 		return VDO_SUCCESS;
 	}
 
-	result = vdo_allocate_extended(struct forest, map->root_count,
-				       struct block_map_tree, __func__,
-				       &forest);
+	result = vdo_allocate_extended(map->root_count, trees, __func__, &forest);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -2707,8 +2705,7 @@ void vdo_traverse_forest(struct block_map *map, vdo_entry_callback_fn callback,
 	struct cursors *cursors;
 	int result;
 
-	result = vdo_allocate_extended(struct cursors, map->root_count,
-				       struct cursor, __func__, &cursors);
+	result = vdo_allocate_extended(map->root_count, cursors, __func__, &cursors);
 	if (result != VDO_SUCCESS) {
 		vdo_fail_completion(completion, result);
 		return;
@@ -2758,9 +2755,7 @@ static int __must_check initialize_block_map_zone(struct block_map *map,
 	zone->thread_id = vdo->thread_config.logical_threads[zone_number];
 	zone->block_map = map;
 
-	result = vdo_allocate_extended(struct dirty_lists, maximum_age,
-				       dirty_era_t, __func__,
-				       &zone->dirty_lists);
+	result = vdo_allocate_extended(maximum_age, eras, __func__, &zone->dirty_lists);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -2900,9 +2895,8 @@ int vdo_decode_block_map(struct block_map_state_2_0 state, block_count_t logical
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = vdo_allocate_extended(struct block_map,
-				       vdo->thread_config.logical_zone_count,
-				       struct block_map_zone, __func__, &map);
+	result = vdo_allocate_extended(vdo->thread_config.logical_zone_count,
+				       zones, __func__, &map);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/data-vio.c b/drivers/md/dm-vdo/data-vio.c
index 3333e1e5b02e..370d4239ba31 100644
--- a/drivers/md/dm-vdo/data-vio.c
+++ b/drivers/md/dm-vdo/data-vio.c
@@ -842,8 +842,7 @@ int make_data_vio_pool(struct vdo *vdo, data_vio_count_t pool_size,
 	struct data_vio_pool *pool;
 	data_vio_count_t i;
 
-	result = vdo_allocate_extended(struct data_vio_pool, pool_size, struct data_vio,
-				       __func__, &pool);
+	result = vdo_allocate_extended(pool_size, data_vios, __func__, &pool);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index 75a26f3f4461..36e9f1236025 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -2418,8 +2418,7 @@ int vdo_make_hash_zones(struct vdo *vdo, struct hash_zones **zones_ptr)
 	if (zone_count == 0)
 		return VDO_SUCCESS;
 
-	result = vdo_allocate_extended(struct hash_zones, zone_count, struct hash_zone,
-				       __func__, &zones);
+	result = vdo_allocate_extended(zone_count, zones, __func__, &zones);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/indexer/index-layout.c b/drivers/md/dm-vdo/indexer/index-layout.c
index 90a2e4b7345c..180248bb4b20 100644
--- a/drivers/md/dm-vdo/indexer/index-layout.c
+++ b/drivers/md/dm-vdo/indexer/index-layout.c
@@ -459,8 +459,7 @@ static int __must_check make_index_save_region_table(struct index_save_layout *i
 		type = RH_TYPE_UNSAVED;
 	}
 
-	result = vdo_allocate_extended(struct region_table, region_count,
-				       struct layout_region,
+	result = vdo_allocate_extended(region_count, regions,
 				       "layout region table for ISL", &table);
 	if (result != VDO_SUCCESS)
 		return result;
@@ -642,9 +641,8 @@ static int __must_check make_layout_region_table(struct index_layout *layout,
 	struct region_table *table;
 	struct layout_region *lr;
 
-	result = vdo_allocate_extended(struct region_table, region_count,
-				       struct layout_region, "layout region table",
-				       &table);
+	result = vdo_allocate_extended(region_count, regions,
+				       "layout region table", &table);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -1138,8 +1136,7 @@ static int __must_check load_region_table(struct buffered_reader *reader,
 					      header.version);
 	}
 
-	result = vdo_allocate_extended(struct region_table, header.region_count,
-				       struct layout_region,
+	result = vdo_allocate_extended(header.region_count, regions,
 				       "single file layout region table", &table);
 	if (result != VDO_SUCCESS)
 		return result;
diff --git a/drivers/md/dm-vdo/indexer/index.c b/drivers/md/dm-vdo/indexer/index.c
index df4934846244..d4724fe17bf1 100644
--- a/drivers/md/dm-vdo/indexer/index.c
+++ b/drivers/md/dm-vdo/indexer/index.c
@@ -764,9 +764,7 @@ static int make_chapter_writer(struct uds_index *index,
 	size_t collated_records_size =
 		(sizeof(struct uds_volume_record) * index->volume->geometry->records_per_chapter);
 
-	result = vdo_allocate_extended(struct chapter_writer, index->zone_count,
-				       struct open_chapter_zone *, "Chapter Writer",
-				       &writer);
+	result = vdo_allocate_extended(index->zone_count, chapters, "Chapter Writer", &writer);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -1160,8 +1158,7 @@ int uds_make_index(struct uds_configuration *config, enum uds_open_index_type op
 	u64 nonce;
 	unsigned int z;
 
-	result = vdo_allocate_extended(struct uds_index, config->zone_count,
-				       struct uds_request_queue *, "index", &index);
+	result = vdo_allocate_extended(config->zone_count, zone_queues, "index", &index);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/indexer/open-chapter.c b/drivers/md/dm-vdo/indexer/open-chapter.c
index 4a67bcadaae0..89b91c600bfd 100644
--- a/drivers/md/dm-vdo/indexer/open-chapter.c
+++ b/drivers/md/dm-vdo/indexer/open-chapter.c
@@ -68,9 +68,7 @@ int uds_make_open_chapter(const struct index_geometry *geometry, unsigned int zo
 	size_t capacity = geometry->records_per_chapter / zone_count;
 	size_t slot_count = (1 << bits_per(capacity * LOAD_RATIO));
 
-	result = vdo_allocate_extended(struct open_chapter_zone, slot_count,
-				       struct open_chapter_zone_slot, "open chapter",
-				       &open_chapter);
+	result = vdo_allocate_extended(slot_count, slots, "open chapter", &open_chapter);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/indexer/radix-sort.c b/drivers/md/dm-vdo/indexer/radix-sort.c
index 66b8c706a1ef..4b81e130d18a 100644
--- a/drivers/md/dm-vdo/indexer/radix-sort.c
+++ b/drivers/md/dm-vdo/indexer/radix-sort.c
@@ -211,8 +211,7 @@ int uds_make_radix_sorter(unsigned int count, struct radix_sorter **sorter)
 	unsigned int stack_size = count / INSERTION_SORT_THRESHOLD;
 	struct radix_sorter *radix_sorter;
 
-	result = vdo_allocate_extended(struct radix_sorter, stack_size, struct task,
-				       __func__, &radix_sorter);
+	result = vdo_allocate_extended(stack_size, stack, __func__, &radix_sorter);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/io-submitter.c b/drivers/md/dm-vdo/io-submitter.c
index e26d75f8366d..0e9932929fee 100644
--- a/drivers/md/dm-vdo/io-submitter.c
+++ b/drivers/md/dm-vdo/io-submitter.c
@@ -383,8 +383,7 @@ int vdo_make_io_submitter(unsigned int thread_count, unsigned int rotation_inter
 	struct io_submitter *io_submitter;
 	int result;
 
-	result = vdo_allocate_extended(struct io_submitter, thread_count,
-				       struct bio_queue_data, "bio submission data",
+	result = vdo_allocate_extended(thread_count, bio_queue_data, "bio submission data",
 				       &io_submitter);
 	if (result != VDO_SUCCESS)
 		return result;
diff --git a/drivers/md/dm-vdo/logical-zone.c b/drivers/md/dm-vdo/logical-zone.c
index 0a27e60a9dfd..fa7c3eb7ee6b 100644
--- a/drivers/md/dm-vdo/logical-zone.c
+++ b/drivers/md/dm-vdo/logical-zone.c
@@ -94,8 +94,7 @@ int vdo_make_logical_zones(struct vdo *vdo, struct logical_zones **zones_ptr)
 	if (zone_count == 0)
 		return VDO_SUCCESS;
 
-	result = vdo_allocate_extended(struct logical_zones, zone_count,
-				       struct logical_zone, __func__, &zones);
+	result = vdo_allocate_extended(zone_count, zones, __func__, &zones);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/memory-alloc.h b/drivers/md/dm-vdo/memory-alloc.h
index 0093d9f940d9..ab2375d549f4 100644
--- a/drivers/md/dm-vdo/memory-alloc.h
+++ b/drivers/md/dm-vdo/memory-alloc.h
@@ -8,6 +8,7 @@
 
 #include <linux/cache.h>
 #include <linux/io.h> /* for PAGE_SIZE */
+#include <linux/overflow.h>
 
 #include "permassert.h"
 #include "thread-registry.h"
@@ -71,31 +72,21 @@ static inline int __vdo_do_allocation(size_t count, size_t size, size_t extra,
 	__vdo_do_allocation(COUNT, sizeof(TYPE), 0, __alignof__(TYPE), WHAT, PTR)
 
 /*
- * Allocate one object of an indicated type, followed by one or more elements of a second type,
- * logging an error if the allocation fails. The memory will be zeroed.
+ * Allocate a structure with a flexible array member, with a specified number of elements, logging
+ * an error if the allocation fails. The memory will be zeroed.
  *
- * @TYPE1: The type of the primary object to allocate. This type determines the alignment of the
- *         allocated memory.
  * @COUNT: The number of objects to allocate
- * @TYPE2: The type of array objects to allocate
+ * @FIELD: The flexible array field at the end of the structure
  * @WHAT: What is being allocated (for error logging)
  * @PTR: A pointer to hold the allocated memory
  *
  * Return: VDO_SUCCESS or an error code
  */
-#define vdo_allocate_extended(TYPE1, COUNT, TYPE2, WHAT, PTR)		\
-	__extension__({							\
-		int _result;						\
-		TYPE1 **_ptr = (PTR);					\
-		BUILD_BUG_ON(__alignof__(TYPE1) < __alignof__(TYPE2));	\
-		_result = __vdo_do_allocation(COUNT,			\
-					      sizeof(TYPE2),		\
-					      sizeof(TYPE1),		\
-					      __alignof__(TYPE1),	\
-					      WHAT,			\
-					      _ptr);			\
-		_result;						\
-	})
+#define vdo_allocate_extended(COUNT, FIELD, WHAT, PTR)			\
+	vdo_allocate_memory(struct_size(*(PTR), FIELD, (COUNT)),	\
+			    __alignof__(typeof(**(PTR))),		\
+			    WHAT,					\
+			    (PTR))
 
 /*
  * Allocate memory starting on a cache line boundary, logging an error if the allocation fails. The
diff --git a/drivers/md/dm-vdo/packer.c b/drivers/md/dm-vdo/packer.c
index 666be6d557e1..e638694d896c 100644
--- a/drivers/md/dm-vdo/packer.c
+++ b/drivers/md/dm-vdo/packer.c
@@ -120,8 +120,7 @@ static int __must_check make_bin(struct packer *packer)
 	struct packer_bin *bin;
 	int result;
 
-	result = vdo_allocate_extended(struct packer_bin, VDO_MAX_COMPRESSION_SLOTS,
-				       struct vio *, __func__, &bin);
+	result = vdo_allocate_extended(VDO_MAX_COMPRESSION_SLOTS, incoming, __func__, &bin);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -168,8 +167,8 @@ int vdo_make_packer(struct vdo *vdo, block_count_t bin_count, struct packer **pa
 	 * bin must have a canceler for which it is waiting, and any canceler will only have
 	 * canceled one lock holder at a time.
 	 */
-	result = vdo_allocate_extended(struct packer_bin, MAXIMUM_VDO_USER_VIOS / 2,
-				       struct vio *, __func__, &packer->canceled_bin);
+	result = vdo_allocate_extended(MAXIMUM_VDO_USER_VIOS / 2, incoming, __func__,
+				       &packer->canceled_bin);
 	if (result != VDO_SUCCESS) {
 		vdo_free_packer(packer);
 		return result;
diff --git a/drivers/md/dm-vdo/physical-zone.c b/drivers/md/dm-vdo/physical-zone.c
index 686eb7d714e6..a8c7a57516eb 100644
--- a/drivers/md/dm-vdo/physical-zone.c
+++ b/drivers/md/dm-vdo/physical-zone.c
@@ -240,8 +240,7 @@ static int make_pbn_lock_pool(size_t capacity, struct pbn_lock_pool **pool_ptr)
 	struct pbn_lock_pool *pool;
 	int result;
 
-	result = vdo_allocate_extended(struct pbn_lock_pool, capacity, idle_pbn_lock,
-				       __func__, &pool);
+	result = vdo_allocate_extended(capacity, locks, __func__, &pool);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -368,8 +367,7 @@ int vdo_make_physical_zones(struct vdo *vdo, struct physical_zones **zones_ptr)
 	if (zone_count == 0)
 		return VDO_SUCCESS;
 
-	result = vdo_allocate_extended(struct physical_zones, zone_count,
-				       struct physical_zone, __func__, &zones);
+	result = vdo_allocate_extended(zone_count, zones, __func__, &zones);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/priority-table.c b/drivers/md/dm-vdo/priority-table.c
index 9bae8256ba4e..bb8a878ce4e5 100644
--- a/drivers/md/dm-vdo/priority-table.c
+++ b/drivers/md/dm-vdo/priority-table.c
@@ -60,8 +60,7 @@ int vdo_make_priority_table(unsigned int max_priority, struct priority_table **t
 	if (max_priority > MAX_PRIORITY)
 		return UDS_INVALID_ARGUMENT;
 
-	result = vdo_allocate_extended(struct priority_table, max_priority + 1,
-				       struct bucket, __func__, &table);
+	result = vdo_allocate_extended(max_priority + 1, buckets, __func__, &table);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/recovery-journal.c b/drivers/md/dm-vdo/recovery-journal.c
index 9cc0f0ff1664..6da303961376 100644
--- a/drivers/md/dm-vdo/recovery-journal.c
+++ b/drivers/md/dm-vdo/recovery-journal.c
@@ -711,10 +711,8 @@ int vdo_decode_recovery_journal(struct recovery_journal_state_7_0 state, nonce_t
 	struct recovery_journal *journal;
 	int result;
 
-	result = vdo_allocate_extended(struct recovery_journal,
-				       RECOVERY_JOURNAL_RESERVED_BLOCKS,
-				       struct recovery_journal_block, __func__,
-				       &journal);
+	result = vdo_allocate_extended(RECOVERY_JOURNAL_RESERVED_BLOCKS, blocks,
+				       __func__, &journal);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
index 8c006fb3afcf..e479d3582040 100644
--- a/drivers/md/dm-vdo/repair.c
+++ b/drivers/md/dm-vdo/repair.c
@@ -1715,9 +1715,7 @@ void vdo_repair(struct vdo_completion *parent)
 		vdo_log_warning("Device was dirty, rebuilding reference counts");
 	}
 
-	result = vdo_allocate_extended(struct repair_completion, page_count,
-				       struct vdo_page_completion, __func__,
-				       &repair);
+	result = vdo_allocate_extended(page_count, page_completions, __func__, &repair);
 	if (result != VDO_SUCCESS) {
 		vdo_fail_completion(parent, result);
 		return;
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index ad00afc2c168..286fc4465a92 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -4266,9 +4266,8 @@ int vdo_decode_slab_depot(struct slab_depot_state_2_0 state, struct vdo *vdo,
 		return vdo_log_error_strerror(UDS_CORRUPT_DATA,
 					      "invalid zone count");
 
-	result = vdo_allocate_extended(struct slab_depot,
-				       vdo->thread_config.physical_zone_count,
-				       struct block_allocator, __func__, &depot);
+	result = vdo_allocate_extended(vdo->thread_config.physical_zone_count,
+				       allocators, __func__, &depot);
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/vio.c b/drivers/md/dm-vdo/vio.c
index 5ffc867d9c5e..cc739d52a70c 100644
--- a/drivers/md/dm-vdo/vio.c
+++ b/drivers/md/dm-vdo/vio.c
@@ -52,8 +52,8 @@ static int create_multi_block_bio(block_count_t size, struct bio **bio_ptr)
 	struct bio *bio = NULL;
 	int result;
 
-	result = vdo_allocate_extended(struct bio, size + 1, struct bio_vec,
-				       "bio", &bio);
+	result = vdo_allocate_memory(sizeof(struct bio) + sizeof(struct bio_vec) * (size + 1),
+				     __alignof__(struct bio), "bio", &bio);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -327,8 +327,7 @@ int make_vio_pool(struct vdo *vdo, size_t pool_size, size_t block_count, thread_
 	int result;
 	size_t per_vio_size = VDO_BLOCK_SIZE * block_count;
 
-	result = vdo_allocate_extended(struct vio_pool, pool_size, struct pooled_vio,
-				       __func__, &pool);
+	result = vdo_allocate_extended(pool_size, vios, __func__, &pool);
 	if (result != VDO_SUCCESS)
 		return result;
 
-- 
2.53.0

