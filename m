Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5876FAC
	for <dm-devel@lists.linux.dev>; Sat, 11 Nov 2023 04:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LEQeKS4z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699677049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7T2uNjw7GSChXFq7gU1mjkrtCbSPaxvmGvJHI6luiww=;
	b=LEQeKS4zLi6gauvtB5Cld8I2BTe2uUmed+uUKzsDG/BXIpsPRZQ1F23zxs2zCyCMp6l96h
	ncQGmGWu2H/BnTGeTTloi/UTpUPuCRJA/igx74MLTtKR1ZsKMV2E+9xWoEz3izE5ldGGUC
	pBF9O3p98RIJpdsf45zsRY1/5/j3FWg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-148-WJbY0atuOF2lmoWNA9M51Q-1; Fri, 10 Nov 2023 23:30:46 -0500
X-MC-Unique: WJbY0atuOF2lmoWNA9M51Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1852D832D60;
	Sat, 11 Nov 2023 04:30:46 +0000 (UTC)
Received: from pbitcolo-build-10.permabit.com (pbitcolo-build-10.permabit.lab.eng.bos.redhat.com [10.19.117.76])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 02A03492BE7;
	Sat, 11 Nov 2023 04:30:46 +0000 (UTC)
Received: by pbitcolo-build-10.permabit.com (Postfix, from userid 1138)
	id ACFFF3003B; Fri, 10 Nov 2023 23:30:45 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 5/8] dm vdo memory-alloc: rename UDS_ALLOCATE_EXTENDED to uds_allocate_extended
Date: Fri, 10 Nov 2023 23:30:41 -0500
Message-Id: <83c37b65e56130a774ed3ecd5ee182eac7a8fbcc.1699675570.git.msakai@redhat.com>
In-Reply-To: <ccd28d21aede15fc56f1ff25b3582ddad5260883.1699675570.git.msakai@redhat.com>
References: <ccd28d21aede15fc56f1ff25b3582ddad5260883.1699675570.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

From: Mike Snitzer <snitzer@kernel.org>

Reviewed-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.c        | 8 ++++----
 drivers/md/dm-vdo/data-vio.c         | 2 +-
 drivers/md/dm-vdo/dedupe.c           | 2 +-
 drivers/md/dm-vdo/index-layout.c     | 6 +++---
 drivers/md/dm-vdo/index.c            | 4 ++--
 drivers/md/dm-vdo/io-submitter.c     | 2 +-
 drivers/md/dm-vdo/logical-zone.c     | 2 +-
 drivers/md/dm-vdo/memory-alloc.h     | 2 +-
 drivers/md/dm-vdo/open-chapter.c     | 2 +-
 drivers/md/dm-vdo/packer.c           | 4 ++--
 drivers/md/dm-vdo/physical-zone.c    | 4 ++--
 drivers/md/dm-vdo/priority-table.c   | 2 +-
 drivers/md/dm-vdo/radix-sort.c       | 2 +-
 drivers/md/dm-vdo/recovery-journal.c | 2 +-
 drivers/md/dm-vdo/repair.c           | 2 +-
 drivers/md/dm-vdo/slab-depot.c       | 2 +-
 drivers/md/dm-vdo/vio.c              | 4 ++--
 17 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index 345a9bb32ed9..0dfd6bedce63 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -2482,7 +2482,7 @@ static int make_forest(struct block_map *map, block_count_t entries)
 		return VDO_SUCCESS;
 	}
 
-	result = UDS_ALLOCATE_EXTENDED(struct forest, map->root_count,
+	result = uds_allocate_extended(struct forest, map->root_count,
 				       struct block_map_tree, __func__,
 				       &forest);
 	if (result != VDO_SUCCESS)
@@ -2709,7 +2709,7 @@ void vdo_traverse_forest(struct block_map *map,
 	struct cursors *cursors;
 	int result;
 
-	result = UDS_ALLOCATE_EXTENDED(struct cursors,
+	result = uds_allocate_extended(struct cursors,
 				       map->root_count,
 				       struct cursor,
 				       __func__,
@@ -2760,7 +2760,7 @@ static int __must_check initialize_block_map_zone(struct block_map *map,
 	zone->thread_id = vdo->thread_config.logical_threads[zone_number];
 	zone->block_map = map;
 
-	result = UDS_ALLOCATE_EXTENDED(struct dirty_lists,
+	result = uds_allocate_extended(struct dirty_lists,
 				       maximum_age,
 				       dirty_era_t,
 				       __func__,
@@ -2916,7 +2916,7 @@ int vdo_decode_block_map(struct block_map_state_2_0 state,
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = UDS_ALLOCATE_EXTENDED(struct block_map,
+	result = uds_allocate_extended(struct block_map,
 				       vdo->thread_config.logical_zone_count,
 				       struct block_map_zone,
 				       __func__,
diff --git a/drivers/md/dm-vdo/data-vio.c b/drivers/md/dm-vdo/data-vio.c
index 3af963becbdf..c322f12c17b8 100644
--- a/drivers/md/dm-vdo/data-vio.c
+++ b/drivers/md/dm-vdo/data-vio.c
@@ -844,7 +844,7 @@ int make_data_vio_pool(struct vdo *vdo,
 	struct data_vio_pool *pool;
 	data_vio_count_t i;
 
-	result = UDS_ALLOCATE_EXTENDED(struct data_vio_pool,
+	result = uds_allocate_extended(struct data_vio_pool,
 				       pool_size,
 				       struct data_vio,
 				       __func__,
diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index 1792cebf9529..dd5f2ae84c08 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -2463,7 +2463,7 @@ int vdo_make_hash_zones(struct vdo *vdo, struct hash_zones **zones_ptr)
 	if (zone_count == 0)
 		return VDO_SUCCESS;
 
-	result = UDS_ALLOCATE_EXTENDED(struct hash_zones,
+	result = uds_allocate_extended(struct hash_zones,
 				       zone_count,
 				       struct hash_zone,
 				       __func__,
diff --git a/drivers/md/dm-vdo/index-layout.c b/drivers/md/dm-vdo/index-layout.c
index cfeeeced35a0..2872db9d3bbb 100644
--- a/drivers/md/dm-vdo/index-layout.c
+++ b/drivers/md/dm-vdo/index-layout.c
@@ -491,7 +491,7 @@ make_index_save_region_table(struct index_save_layout *isl, struct region_table
 		type = RH_TYPE_UNSAVED;
 	}
 
-	result = UDS_ALLOCATE_EXTENDED(struct region_table,
+	result = uds_allocate_extended(struct region_table,
 				       region_count,
 				       struct layout_region,
 				       "layout region table for ISL",
@@ -674,7 +674,7 @@ make_layout_region_table(struct index_layout *layout, struct region_table **tabl
 	struct region_table *table;
 	struct layout_region *lr;
 
-	result = UDS_ALLOCATE_EXTENDED(struct region_table,
+	result = uds_allocate_extended(struct region_table,
 				       region_count,
 				       struct layout_region,
 				       "layout region table",
@@ -1175,7 +1175,7 @@ load_region_table(struct buffered_reader *reader, struct region_table **table_pt
 					      "unknown region table version %hu",
 					      header.version);
 
-	result = UDS_ALLOCATE_EXTENDED(struct region_table,
+	result = uds_allocate_extended(struct region_table,
 				       header.region_count,
 				       struct layout_region,
 				       "single file layout region table",
diff --git a/drivers/md/dm-vdo/index.c b/drivers/md/dm-vdo/index.c
index 410c0eedb01b..2314ea2ff011 100644
--- a/drivers/md/dm-vdo/index.c
+++ b/drivers/md/dm-vdo/index.c
@@ -767,7 +767,7 @@ static int make_chapter_writer(struct uds_index *index, struct chapter_writer **
 	size_t collated_records_size =
 		(sizeof(struct uds_volume_record) * index->volume->geometry->records_per_chapter);
 
-	result = UDS_ALLOCATE_EXTENDED(struct chapter_writer,
+	result = uds_allocate_extended(struct chapter_writer,
 				       index->zone_count,
 				       struct open_chapter_zone *,
 				       "Chapter Writer",
@@ -1178,7 +1178,7 @@ int uds_make_index(struct configuration *config,
 	u64 nonce;
 	unsigned int z;
 
-	result = UDS_ALLOCATE_EXTENDED(struct uds_index,
+	result = uds_allocate_extended(struct uds_index,
 				       config->zone_count,
 				       struct uds_request_queue *,
 				       "index",
diff --git a/drivers/md/dm-vdo/io-submitter.c b/drivers/md/dm-vdo/io-submitter.c
index 68370dea7067..6aa54923463f 100644
--- a/drivers/md/dm-vdo/io-submitter.c
+++ b/drivers/md/dm-vdo/io-submitter.c
@@ -382,7 +382,7 @@ int vdo_make_io_submitter(unsigned int thread_count,
 	struct io_submitter *io_submitter;
 	int result;
 
-	result = UDS_ALLOCATE_EXTENDED(struct io_submitter,
+	result = uds_allocate_extended(struct io_submitter,
 				       thread_count,
 				       struct bio_queue_data,
 				       "bio submission data",
diff --git a/drivers/md/dm-vdo/logical-zone.c b/drivers/md/dm-vdo/logical-zone.c
index 61cc55ebfe5b..23f36e2f454d 100644
--- a/drivers/md/dm-vdo/logical-zone.c
+++ b/drivers/md/dm-vdo/logical-zone.c
@@ -95,7 +95,7 @@ int vdo_make_logical_zones(struct vdo *vdo, struct logical_zones **zones_ptr)
 	if (zone_count == 0)
 		return VDO_SUCCESS;
 
-	result = UDS_ALLOCATE_EXTENDED(struct logical_zones, zone_count,
+	result = uds_allocate_extended(struct logical_zones, zone_count,
 				       struct logical_zone, __func__, &zones);
 	if (result != VDO_SUCCESS)
 		return result;
diff --git a/drivers/md/dm-vdo/memory-alloc.h b/drivers/md/dm-vdo/memory-alloc.h
index 8b750b4751e9..1429d5173dbd 100644
--- a/drivers/md/dm-vdo/memory-alloc.h
+++ b/drivers/md/dm-vdo/memory-alloc.h
@@ -112,7 +112,7 @@ int __must_check uds_reallocate_memory(void *ptr,
  *
  * Return: UDS_SUCCESS or an error code
  */
-#define UDS_ALLOCATE_EXTENDED(TYPE1, COUNT, TYPE2, WHAT, PTR)            \
+#define uds_allocate_extended(TYPE1, COUNT, TYPE2, WHAT, PTR)            \
 	__extension__({                                                  \
 		int _result;						 \
 		TYPE1 **_ptr = (PTR);                                    \
diff --git a/drivers/md/dm-vdo/open-chapter.c b/drivers/md/dm-vdo/open-chapter.c
index 0cbbbbc6602a..5c558aad024f 100644
--- a/drivers/md/dm-vdo/open-chapter.c
+++ b/drivers/md/dm-vdo/open-chapter.c
@@ -70,7 +70,7 @@ int uds_make_open_chapter(const struct geometry *geometry,
 	size_t capacity = geometry->records_per_chapter / zone_count;
 	size_t slot_count = (1 << bits_per(capacity * LOAD_RATIO));
 
-	result = UDS_ALLOCATE_EXTENDED(struct open_chapter_zone,
+	result = uds_allocate_extended(struct open_chapter_zone,
 				       slot_count,
 				       struct open_chapter_zone_slot,
 				       "open chapter",
diff --git a/drivers/md/dm-vdo/packer.c b/drivers/md/dm-vdo/packer.c
index 4d689d4c6a41..cec21e0138b1 100644
--- a/drivers/md/dm-vdo/packer.c
+++ b/drivers/md/dm-vdo/packer.c
@@ -123,7 +123,7 @@ static int __must_check make_bin(struct packer *packer)
 	struct packer_bin *bin;
 	int result;
 
-	result = UDS_ALLOCATE_EXTENDED(struct packer_bin,
+	result = uds_allocate_extended(struct packer_bin,
 				       VDO_MAX_COMPRESSION_SLOTS,
 				       struct vio *,
 				       __func__,
@@ -174,7 +174,7 @@ int vdo_make_packer(struct vdo *vdo, block_count_t bin_count, struct packer **pa
 	 * bin must have a canceler for which it is waiting, and any canceler will only have
 	 * canceled one lock holder at a time.
 	 */
-	result = UDS_ALLOCATE_EXTENDED(struct packer_bin,
+	result = uds_allocate_extended(struct packer_bin,
 				       MAXIMUM_VDO_USER_VIOS / 2,
 				       struct vio *, __func__,
 				       &packer->canceled_bin);
diff --git a/drivers/md/dm-vdo/physical-zone.c b/drivers/md/dm-vdo/physical-zone.c
index f32fe7ef0d0d..e115536d2b4f 100644
--- a/drivers/md/dm-vdo/physical-zone.c
+++ b/drivers/md/dm-vdo/physical-zone.c
@@ -241,7 +241,7 @@ static int make_pbn_lock_pool(size_t capacity, struct pbn_lock_pool **pool_ptr)
 	struct pbn_lock_pool *pool;
 	int result;
 
-	result = UDS_ALLOCATE_EXTENDED(struct pbn_lock_pool,
+	result = uds_allocate_extended(struct pbn_lock_pool,
 				       capacity,
 				       idle_pbn_lock,
 				       __func__,
@@ -372,7 +372,7 @@ int vdo_make_physical_zones(struct vdo *vdo, struct physical_zones **zones_ptr)
 	if (zone_count == 0)
 		return VDO_SUCCESS;
 
-	result = UDS_ALLOCATE_EXTENDED(struct physical_zones,
+	result = uds_allocate_extended(struct physical_zones,
 				       zone_count,
 				       struct physical_zone,
 				       __func__,
diff --git a/drivers/md/dm-vdo/priority-table.c b/drivers/md/dm-vdo/priority-table.c
index 7956ed7dd684..5b6a72354bd1 100644
--- a/drivers/md/dm-vdo/priority-table.c
+++ b/drivers/md/dm-vdo/priority-table.c
@@ -62,7 +62,7 @@ int vdo_make_priority_table(unsigned int max_priority, struct priority_table **t
 	if (max_priority > MAX_PRIORITY)
 		return UDS_INVALID_ARGUMENT;
 
-	result = UDS_ALLOCATE_EXTENDED(struct priority_table, max_priority + 1,
+	result = uds_allocate_extended(struct priority_table, max_priority + 1,
 				       struct bucket, __func__, &table);
 	if (result != VDO_SUCCESS)
 		return result;
diff --git a/drivers/md/dm-vdo/radix-sort.c b/drivers/md/dm-vdo/radix-sort.c
index 2b9b31177d03..11da279f6053 100644
--- a/drivers/md/dm-vdo/radix-sort.c
+++ b/drivers/md/dm-vdo/radix-sort.c
@@ -220,7 +220,7 @@ int uds_make_radix_sorter(unsigned int count, struct radix_sorter **sorter)
 	unsigned int stack_size = count / INSERTION_SORT_THRESHOLD;
 	struct radix_sorter *radix_sorter;
 
-	result = UDS_ALLOCATE_EXTENDED(struct radix_sorter,
+	result = uds_allocate_extended(struct radix_sorter,
 				       stack_size,
 				       struct task,
 				       __func__,
diff --git a/drivers/md/dm-vdo/recovery-journal.c b/drivers/md/dm-vdo/recovery-journal.c
index 6b96a6ccece7..142f98c3e93d 100644
--- a/drivers/md/dm-vdo/recovery-journal.c
+++ b/drivers/md/dm-vdo/recovery-journal.c
@@ -724,7 +724,7 @@ int vdo_decode_recovery_journal(struct recovery_journal_state_7_0 state,
 	struct recovery_journal *journal;
 	int result;
 
-	result = UDS_ALLOCATE_EXTENDED(struct recovery_journal,
+	result = uds_allocate_extended(struct recovery_journal,
 				       RECOVERY_JOURNAL_RESERVED_BLOCKS,
 				       struct recovery_journal_block,
 				       __func__,
diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
index d9613e7b7e9e..60e4fbbeb390 100644
--- a/drivers/md/dm-vdo/repair.c
+++ b/drivers/md/dm-vdo/repair.c
@@ -1722,7 +1722,7 @@ void vdo_repair(struct vdo_completion *parent)
 		uds_log_warning("Device was dirty, rebuilding reference counts");
 	}
 
-	result = UDS_ALLOCATE_EXTENDED(struct repair_completion,
+	result = uds_allocate_extended(struct repair_completion,
 				       page_count,
 				       struct vdo_page_completion,
 				       __func__,
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 53df3fac82bd..b45732818752 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -4264,7 +4264,7 @@ int vdo_decode_slab_depot(struct slab_depot_state_2_0 state,
 					      "slab size must be a power of two");
 	slab_size_shift = ilog2(slab_size);
 
-	result = UDS_ALLOCATE_EXTENDED(struct slab_depot,
+	result = uds_allocate_extended(struct slab_depot,
 				       vdo->thread_config.physical_zone_count,
 				       struct block_allocator,
 				       __func__,
diff --git a/drivers/md/dm-vdo/vio.c b/drivers/md/dm-vdo/vio.c
index 10fcfd93e782..659bbf237fce 100644
--- a/drivers/md/dm-vdo/vio.c
+++ b/drivers/md/dm-vdo/vio.c
@@ -52,7 +52,7 @@ static int create_multi_block_bio(block_count_t size, struct bio **bio_ptr)
 	struct bio *bio = NULL;
 	int result;
 
-	result = UDS_ALLOCATE_EXTENDED(struct bio, size + 1, struct bio_vec, "bio", &bio);
+	result = uds_allocate_extended(struct bio, size + 1, struct bio_vec, "bio", &bio);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -334,7 +334,7 @@ int make_vio_pool(struct vdo *vdo,
 	char *ptr;
 	int result;
 
-	result = UDS_ALLOCATE_EXTENDED(struct vio_pool,
+	result = uds_allocate_extended(struct vio_pool,
 				       pool_size,
 				       struct pooled_vio,
 				       __func__,
-- 
2.40.0

