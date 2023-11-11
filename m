Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33568568A
	for <dm-devel@lists.linux.dev>; Sat, 11 Nov 2023 04:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i44b0Qeq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699675284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=J/47rDLmByWF0rM8W3SzuLGJK+67cIq+s7+2lfTfXsc=;
	b=i44b0Qeq3JoPEFyJ/tee2OdFbHLaVmv7BEoD2lInf026QoCpbSlxJIFeYpy8kbMNQQXa8W
	y9ctQuDkTlBbOrX7pUa/nEDXmj+XQS2WrG29p8h/zjWYBtGs8lZn4HwlqtRuZ1SR83AF10
	ZuULKkVo3BXPJS/6dlr32waHEzx88io=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-553-zO4_CYe3NZe-eXpdEGgOaw-1; Fri,
 10 Nov 2023 23:01:20 -0500
X-MC-Unique: zO4_CYe3NZe-eXpdEGgOaw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C28F129AA2C9;
	Sat, 11 Nov 2023 04:01:19 +0000 (UTC)
Received: from pbitcolo-build-10.permabit.com (pbitcolo-build-10.permabit.lab.eng.bos.redhat.com [10.19.117.76])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B19E41121306;
	Sat, 11 Nov 2023 04:01:19 +0000 (UTC)
Received: by pbitcolo-build-10.permabit.com (Postfix, from userid 1138)
	id 73D213003C; Fri, 10 Nov 2023 23:01:19 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo: use BUILD_BUG_ON instead of STATIC_ASSERT
Date: Fri, 10 Nov 2023 23:01:19 -0500
Message-Id: <186d2b86f9831d586be4d3ba70a38b1faae21211.1699674691.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

From: Mike Snitzer <snitzer@kernel.org>

Also convert STATIC_ASSERT_SIZEOF callers to using BUILD_BUG_ON.

Reviewed-by: Chung Chung <cchung@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.c        | 10 +++++-----
 drivers/md/dm-vdo/data-vio.c         |  6 +++---
 drivers/md/dm-vdo/dedupe.c           |  2 +-
 drivers/md/dm-vdo/encodings.c        |  4 ++--
 drivers/md/dm-vdo/int-map.c          |  2 +-
 drivers/md/dm-vdo/memory-alloc.h     |  2 +-
 drivers/md/dm-vdo/packer.c           |  2 +-
 drivers/md/dm-vdo/permassert.h       | 16 ----------------
 drivers/md/dm-vdo/pointer-map.c      |  2 +-
 drivers/md/dm-vdo/recovery-journal.c |  6 +++---
 drivers/md/dm-vdo/slab-depot.c       |  2 +-
 drivers/md/dm-vdo/status-codes.c     |  4 ++--
 drivers/md/dm-vdo/vio.c              |  2 +-
 drivers/md/dm-vdo/volume.c           |  2 +-
 14 files changed, 23 insertions(+), 39 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index a25d333f43d6..e163c45ef4d5 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -289,7 +289,7 @@ static const char * __must_check get_page_state_name(enum vdo_page_buffer_state
 		"UDS_FREE", "INCOMING", "FAILED", "RESIDENT", "DIRTY", "OUTGOING"
 	};
 
-	STATIC_ASSERT(ARRAY_SIZE(state_names) == PAGE_STATE_COUNT);
+	BUILD_BUG_ON(ARRAY_SIZE(state_names) != PAGE_STATE_COUNT);
 
 	result = ASSERT(state < ARRAY_SIZE(state_names), "Unknown page_state value %d", state);
 	if (result != UDS_SUCCESS)
@@ -2754,7 +2754,7 @@ static int __must_check initialize_block_map_zone(struct block_map *map,
 	block_count_t i;
 	struct block_map_zone *zone = &map->zones[zone_number];
 
-	STATIC_ASSERT_SIZEOF(struct page_descriptor, sizeof(u64));
+	BUILD_BUG_ON(sizeof(struct page_descriptor) != sizeof(u64));
 
 	zone->zone_number = zone_number;
 	zone->thread_id = vdo->thread_config.logical_threads[zone_number];
@@ -2909,9 +2909,9 @@ int vdo_decode_block_map(struct block_map_state_2_0 state,
 	int result;
 	zone_count_t zone = 0;
 
-	STATIC_ASSERT(VDO_BLOCK_MAP_ENTRIES_PER_PAGE ==
-		      ((VDO_BLOCK_SIZE - sizeof(struct block_map_page)) /
-		       sizeof(struct block_map_entry)));
+	BUILD_BUG_ON(VDO_BLOCK_MAP_ENTRIES_PER_PAGE !=
+		     ((VDO_BLOCK_SIZE - sizeof(struct block_map_page)) /
+		      sizeof(struct block_map_entry)));
 	result = ASSERT(cache_size > 0, "block map cache size is specified");
 	if (result != UDS_SUCCESS)
 		return result;
diff --git a/drivers/md/dm-vdo/data-vio.c b/drivers/md/dm-vdo/data-vio.c
index 6f03b4fac569..700f945669dd 100644
--- a/drivers/md/dm-vdo/data-vio.c
+++ b/drivers/md/dm-vdo/data-vio.c
@@ -790,7 +790,7 @@ static int initialize_data_vio(struct data_vio *data_vio, struct vdo *vdo)
 	struct bio *bio;
 	int result;
 
-	STATIC_ASSERT(VDO_BLOCK_SIZE <= PAGE_SIZE);
+	BUILD_BUG_ON(VDO_BLOCK_SIZE > PAGE_SIZE);
 	result = uds_allocate_memory(VDO_BLOCK_SIZE, 0, "data_vio data", &data_vio->vio.data);
 	if (result != VDO_SUCCESS)
 		return uds_log_error_strerror(result, "data_vio data allocation failure");
@@ -1374,8 +1374,8 @@ void handle_data_vio_error(struct vdo_completion *completion)
  */
 const char *get_data_vio_operation_name(struct data_vio *data_vio)
 {
-	STATIC_ASSERT((MAX_VIO_ASYNC_OPERATION_NUMBER - MIN_VIO_ASYNC_OPERATION_NUMBER) ==
-		      ARRAY_SIZE(ASYNC_OPERATION_NAMES));
+	BUILD_BUG_ON((MAX_VIO_ASYNC_OPERATION_NUMBER - MIN_VIO_ASYNC_OPERATION_NUMBER) !=
+		     ARRAY_SIZE(ASYNC_OPERATION_NAMES));
 
 	return ((data_vio->last_async_operation < MAX_VIO_ASYNC_OPERATION_NUMBER) ?
 		ASYNC_OPERATION_NAMES[data_vio->last_async_operation] :
diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index a6546a903120..f230ab64a39c 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -379,7 +379,7 @@ struct pbn_lock *vdo_get_duplicate_lock(struct data_vio *data_vio)
 static const char *get_hash_lock_state_name(enum hash_lock_state state)
 {
 	/* Catch if a state has been added without updating the name array. */
-	STATIC_ASSERT((VDO_HASH_LOCK_BYPASSING + 1) == ARRAY_SIZE(LOCK_STATE_NAMES));
+	BUILD_BUG_ON((VDO_HASH_LOCK_BYPASSING + 1) != ARRAY_SIZE(LOCK_STATE_NAMES));
 	return (state < ARRAY_SIZE(LOCK_STATE_NAMES)) ? LOCK_STATE_NAMES[state] : "INVALID";
 }
 
diff --git a/drivers/md/dm-vdo/encodings.c b/drivers/md/dm-vdo/encodings.c
index 00ed1e70b647..abe7fe55e8fb 100644
--- a/drivers/md/dm-vdo/encodings.c
+++ b/drivers/md/dm-vdo/encodings.c
@@ -341,7 +341,7 @@ vdo_validate_block_map_page(struct block_map_page *page,
 			    nonce_t nonce,
 			    physical_block_number_t pbn)
 {
-	STATIC_ASSERT_SIZEOF(struct block_map_page_header, PAGE_HEADER_4_1_SIZE);
+	BUILD_BUG_ON(sizeof(struct block_map_page_header) != PAGE_HEADER_4_1_SIZE);
 
 	if (!vdo_are_same_version(BLOCK_MAP_4_1, vdo_unpack_version_number(page->version)) ||
 	    !page->header.initialized ||
@@ -986,7 +986,7 @@ static void encode_layout(u8 *buffer, size_t *offset, const struct layout *layou
 	size_t initial_offset;
 	struct header header = VDO_LAYOUT_HEADER_3_0;
 
-	STATIC_ASSERT_SIZEOF(enum partition_id, sizeof(u8));
+	BUILD_BUG_ON(sizeof(enum partition_id) != sizeof(u8));
 	ASSERT_LOG_ONLY(layout->num_partitions <= U8_MAX,
 			"layout partition count must fit in a byte");
 
diff --git a/drivers/md/dm-vdo/int-map.c b/drivers/md/dm-vdo/int-map.c
index 76431ea64f63..6676f39c758c 100644
--- a/drivers/md/dm-vdo/int-map.c
+++ b/drivers/md/dm-vdo/int-map.c
@@ -253,10 +253,10 @@ size_t vdo_int_map_size(const struct int_map *map)
  */
 static struct bucket *dereference_hop(struct bucket *neighborhood, unsigned int hop_offset)
 {
+	BUILD_BUG_ON(NULL_HOP_OFFSET != 0);
 	if (hop_offset == NULL_HOP_OFFSET)
 		return NULL;
 
-	STATIC_ASSERT(NULL_HOP_OFFSET == 0);
 	return &neighborhood[hop_offset - 1];
 }
 
diff --git a/drivers/md/dm-vdo/memory-alloc.h b/drivers/md/dm-vdo/memory-alloc.h
index f02eadf08984..1f0ac0500334 100644
--- a/drivers/md/dm-vdo/memory-alloc.h
+++ b/drivers/md/dm-vdo/memory-alloc.h
@@ -116,7 +116,7 @@ int __must_check uds_reallocate_memory(void *ptr,
 	__extension__({                                                  \
 		int _result;						 \
 		TYPE1 **_ptr = (PTR);                                    \
-		STATIC_ASSERT(__alignof__(TYPE1) >= __alignof__(TYPE2)); \
+		BUILD_BUG_ON(__alignof__(TYPE1) < __alignof__(TYPE2));   \
 		_result = uds_do_allocation(COUNT,                       \
 					    sizeof(TYPE2),               \
 					    sizeof(TYPE1),               \
diff --git a/drivers/md/dm-vdo/packer.c b/drivers/md/dm-vdo/packer.c
index 03d2c77931b2..40757e62eec1 100644
--- a/drivers/md/dm-vdo/packer.c
+++ b/drivers/md/dm-vdo/packer.c
@@ -379,7 +379,7 @@ static void initialize_compressed_block(struct compressed_block *block, u16 size
 	 * Make sure the block layout isn't accidentally changed by changing the length of the
 	 * block header.
 	 */
-	STATIC_ASSERT_SIZEOF(struct compressed_block_header, COMPRESSED_BLOCK_1_0_SIZE);
+	BUILD_BUG_ON(sizeof(struct compressed_block_header) != COMPRESSED_BLOCK_1_0_SIZE);
 
 	block->header.version = vdo_pack_version_number(COMPRESSED_BLOCK_1_0);
 	block->header.sizes[0] = __cpu_to_le16(size);
diff --git a/drivers/md/dm-vdo/permassert.h b/drivers/md/dm-vdo/permassert.h
index bc0db0b187b6..e77c10a96c1f 100644
--- a/drivers/md/dm-vdo/permassert.h
+++ b/drivers/md/dm-vdo/permassert.h
@@ -46,20 +46,4 @@ int uds_assertion_failed(const char *expression_string,
 			 ...)
 	__printf(4, 5);
 
-#define STATIC_ASSERT(expr)	     \
-	do {			     \
-		switch (0) {	     \
-		case 0:		     \
-			;	     \
-			fallthrough; \
-		case expr:	     \
-			;	     \
-			fallthrough; \
-		default:	     \
-			break;	     \
-		}		     \
-	} while (0)
-
-#define STATIC_ASSERT_SIZEOF(type, expected_size) STATIC_ASSERT(sizeof(type) == (expected_size))
-
 #endif /* PERMASSERT_H */
diff --git a/drivers/md/dm-vdo/pointer-map.c b/drivers/md/dm-vdo/pointer-map.c
index 21ccb40c73d2..a5a0acc7fd73 100644
--- a/drivers/md/dm-vdo/pointer-map.c
+++ b/drivers/md/dm-vdo/pointer-map.c
@@ -223,10 +223,10 @@ size_t vdo_pointer_map_size(const struct pointer_map *map)
  */
 static struct bucket *dereference_hop(struct bucket *neighborhood, unsigned int hop_offset)
 {
+	BUILD_BUG_ON(NULL_HOP_OFFSET != 0);
 	if (hop_offset == NULL_HOP_OFFSET)
 		return NULL;
 
-	STATIC_ASSERT(NULL_HOP_OFFSET == 0);
 	return &neighborhood[hop_offset - 1];
 }
 
diff --git a/drivers/md/dm-vdo/recovery-journal.c b/drivers/md/dm-vdo/recovery-journal.c
index 6abf43e99a48..7ebb4827d39c 100644
--- a/drivers/md/dm-vdo/recovery-journal.c
+++ b/drivers/md/dm-vdo/recovery-journal.c
@@ -669,9 +669,9 @@ static int initialize_recovery_block(struct vdo *vdo,
 	/*
 	 * Ensure that a block is large enough to store RECOVERY_JOURNAL_ENTRIES_PER_BLOCK entries.
 	 */
-	STATIC_ASSERT(RECOVERY_JOURNAL_ENTRIES_PER_BLOCK
-		      <= ((VDO_BLOCK_SIZE - sizeof(struct packed_journal_header)) /
-			  sizeof(struct packed_recovery_journal_entry)));
+	BUILD_BUG_ON(RECOVERY_JOURNAL_ENTRIES_PER_BLOCK >
+		     ((VDO_BLOCK_SIZE - sizeof(struct packed_journal_header)) /
+		      sizeof(struct packed_recovery_journal_entry)));
 
 	/*
 	 * Allocate a full block for the journal block even though not all of the space is used
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index ba9cdb720506..638529d38865 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -4168,7 +4168,7 @@ static int allocate_components(struct slab_depot *depot,
 	depot->origin = depot->first_block;
 
 	/* block size must be a multiple of entry size */
-	STATIC_ASSERT((VDO_BLOCK_SIZE % sizeof(struct slab_summary_entry)) == 0);
+	BUILD_BUG_ON((VDO_BLOCK_SIZE % sizeof(struct slab_summary_entry)) != 0);
 
 	depot->summary_origin = summary_partition->offset;
 	depot->hint_shift = vdo_get_slab_summary_hint_shift(depot->slab_size_shift);
diff --git a/drivers/md/dm-vdo/status-codes.c b/drivers/md/dm-vdo/status-codes.c
index 2e886597e995..a6f1cd1732bf 100644
--- a/drivers/md/dm-vdo/status-codes.c
+++ b/drivers/md/dm-vdo/status-codes.c
@@ -58,8 +58,8 @@ static void do_status_code_registration(void)
 {
 	int result;
 
-	STATIC_ASSERT((VDO_STATUS_CODE_LAST - VDO_STATUS_CODE_BASE) ==
-		      ARRAY_SIZE(vdo_status_list));
+	BUILD_BUG_ON((VDO_STATUS_CODE_LAST - VDO_STATUS_CODE_BASE) !=
+		     ARRAY_SIZE(vdo_status_list));
 
 	result = uds_register_error_block("VDO Status",
 					  VDO_STATUS_CODE_BASE,
diff --git a/drivers/md/dm-vdo/vio.c b/drivers/md/dm-vdo/vio.c
index 634add0be453..3d20ee87b562 100644
--- a/drivers/md/dm-vdo/vio.c
+++ b/drivers/md/dm-vdo/vio.c
@@ -132,7 +132,7 @@ int create_multi_block_metadata_vio(struct vdo *vdo,
 	int result;
 
 	/* If struct vio grows past 256 bytes, we'll lose benefits of VDOSTORY-176. */
-	STATIC_ASSERT(sizeof(struct vio) <= 256);
+	BUILD_BUG_ON(sizeof(struct vio) > 256);
 
 	/*
 	 * Metadata vios should use direct allocation and not use the buffer pool, which is
diff --git a/drivers/md/dm-vdo/volume.c b/drivers/md/dm-vdo/volume.c
index fef5c25248db..3eb36166c73c 100644
--- a/drivers/md/dm-vdo/volume.c
+++ b/drivers/md/dm-vdo/volume.c
@@ -1248,7 +1248,7 @@ encode_record_page(const struct volume *volume,
 	 * Sort the record pointers by using just the names in the records, which is less work than
 	 * sorting the entire record values.
 	 */
-	STATIC_ASSERT(offsetof(struct uds_volume_record, name) == 0);
+	BUILD_BUG_ON(offsetof(struct uds_volume_record, name) != 0);
 	result = uds_radix_sort(volume->radix_sorter,
 				(const u8 **) record_pointers,
 				records_per_page,
-- 
2.40.0

