Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5139749F
	for <dm-devel@lists.linux.dev>; Sat,  2 Mar 2024 02:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709348345; cv=none; b=hikkg6LtqmQPvA4LKrg/e/JLxeMKQDpwYRXw6fpZ6lgLo7SSJx3L1Q0UpzSNiKm7J1VoF9ZiAuuLVPJM1riy3Css27fRFkdJ/7tmyGu2BiU329zubUluOEZJ6RukftyVvgdhuQhLBkxscGeiMF5+eohN/CXPQ2OTGKoPgOT0RNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709348345; c=relaxed/simple;
	bh=Nlaa6180LxCXL7kwMNirE6s/1X2EH8YO3cWNvy/U9Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FIUGEZFGdQsqNyILz5kqymIuwYAE8d7QdCW8iyQ7n2oOD1i+3IzSlR7T3U/YJto7C1uL2eh0np84c3eaGd1kXg7CQqtdVEdimPtuOgkAZIdcXEUADGo46DHr/wJf63SV/vI+SKUWuZU/Tw7FcN90mGrEKRv5uufGfUiP/7VrP0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YqFZsdB7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YqFZsdB7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709348337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XlDon+zD+GNt3+QHJ5/4uasD3yNGAqYZakFg9i8Sn5M=;
	b=YqFZsdB77KNl8Yu83IjyRuzxzG8YoMsvJ1PEsdUo8OTF/GHI8YsGqWpQjjH710GgwkyXkr
	qfK9GaKukkc7gIiB+cxH0nhdURE/7AxZ8EwZvnqsMGOz3WMTp+9GBvgICS54Wipmc28lUA
	ECuNOe95QYC8zEzPY6eSHVK2RfLoCL8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-631-HYDgWaTmPX2zKGYh4pAOaQ-1; Fri,
 01 Mar 2024 21:58:55 -0500
X-MC-Unique: HYDgWaTmPX2zKGYh4pAOaQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A8AA3C025D7;
	Sat,  2 Mar 2024 02:58:55 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 73129492BE2;
	Sat,  2 Mar 2024 02:58:55 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 6DC58A1C09; Fri,  1 Mar 2024 21:58:55 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 2/3] dm vdo logger: change from uds_ to vdo_ namespace
Date: Fri,  1 Mar 2024 21:58:54 -0500
Message-ID: <585ecd36b731073269e8fa394a4b2a3e3b029f76.1709348197.git.msakai@redhat.com>
In-Reply-To: <cover.1709348197.git.msakai@redhat.com>
References: <cover.1709348197.git.msakai@redhat.com>
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

Rename all uds_log_* to vdo_log_*.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Chung Chung <cchung@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/admin-state.c            |   8 +-
 drivers/md/dm-vdo/block-map.c              |  20 +--
 drivers/md/dm-vdo/data-vio.c               |  18 +--
 drivers/md/dm-vdo/dedupe.c                 |  36 +++---
 drivers/md/dm-vdo/dm-vdo-target.c          | 144 ++++++++++-----------
 drivers/md/dm-vdo/dump.c                   |  14 +-
 drivers/md/dm-vdo/encodings.c              |  26 ++--
 drivers/md/dm-vdo/errors.c                 |   6 +-
 drivers/md/dm-vdo/errors.h                 |   4 +-
 drivers/md/dm-vdo/flush.c                  |   8 +-
 drivers/md/dm-vdo/funnel-workqueue.c       |   2 +-
 drivers/md/dm-vdo/indexer/chapter-index.c  |   4 +-
 drivers/md/dm-vdo/indexer/config.c         |  48 +++----
 drivers/md/dm-vdo/indexer/delta-index.c    |  50 +++----
 drivers/md/dm-vdo/indexer/index-layout.c   |  82 ++++++------
 drivers/md/dm-vdo/indexer/index-page-map.c |   2 +-
 drivers/md/dm-vdo/indexer/index-session.c  |  44 +++----
 drivers/md/dm-vdo/indexer/index.c          |  52 ++++----
 drivers/md/dm-vdo/indexer/io-factory.c     |   2 +-
 drivers/md/dm-vdo/indexer/open-chapter.c   |   6 +-
 drivers/md/dm-vdo/indexer/volume-index.c   |  46 +++----
 drivers/md/dm-vdo/indexer/volume.c         |  64 ++++-----
 drivers/md/dm-vdo/int-map.c                |   2 +-
 drivers/md/dm-vdo/io-submitter.c           |   4 +-
 drivers/md/dm-vdo/logger.c                 |  52 ++++----
 drivers/md/dm-vdo/logger.h                 |  84 ++++++------
 drivers/md/dm-vdo/logical-zone.c           |   4 +-
 drivers/md/dm-vdo/memory-alloc.c           |  14 +-
 drivers/md/dm-vdo/message-stats.c          |   2 +-
 drivers/md/dm-vdo/packer.c                 |   6 +-
 drivers/md/dm-vdo/permassert.c             |   4 +-
 drivers/md/dm-vdo/physical-zone.c          |   6 +-
 drivers/md/dm-vdo/recovery-journal.c       |  16 +--
 drivers/md/dm-vdo/repair.c                 |  46 +++----
 drivers/md/dm-vdo/slab-depot.c             |  54 ++++----
 drivers/md/dm-vdo/status-codes.c           |   6 +-
 drivers/md/dm-vdo/thread-utils.c           |   2 +-
 drivers/md/dm-vdo/vdo.c                    |  14 +-
 drivers/md/dm-vdo/vio.c                    |  10 +-
 39 files changed, 506 insertions(+), 506 deletions(-)

diff --git a/drivers/md/dm-vdo/admin-state.c b/drivers/md/dm-vdo/admin-state.c
index d695af42d140..3f9dba525154 100644
--- a/drivers/md/dm-vdo/admin-state.c
+++ b/drivers/md/dm-vdo/admin-state.c
@@ -228,12 +228,12 @@ static int __must_check begin_operation(struct admin_state *state,
 	const struct admin_state_code *next_state = get_next_state(state, operation);
 
 	if (next_state == NULL) {
-		result = uds_log_error_strerror(VDO_INVALID_ADMIN_STATE,
+		result = vdo_log_error_strerror(VDO_INVALID_ADMIN_STATE,
 						"Can't start %s from %s",
 						operation->name,
 						vdo_get_admin_state_code(state)->name);
 	} else if (state->waiter != NULL) {
-		result = uds_log_error_strerror(VDO_COMPONENT_BUSY,
+		result = vdo_log_error_strerror(VDO_COMPONENT_BUSY,
 						"Can't start %s with extant waiter",
 						operation->name);
 	} else {
@@ -291,7 +291,7 @@ static bool check_code(bool valid, const struct admin_state_code *code, const ch
 	if (valid)
 		return true;
 
-	result = uds_log_error_strerror(VDO_INVALID_ADMIN_STATE,
+	result = vdo_log_error_strerror(VDO_INVALID_ADMIN_STATE,
 					"%s is not a %s", code->name, what);
 	if (waiter != NULL)
 		vdo_continue_completion(waiter, result);
@@ -334,7 +334,7 @@ bool vdo_start_draining(struct admin_state *state,
 	}
 
 	if (!code->normal) {
-		uds_log_error_strerror(VDO_INVALID_ADMIN_STATE, "can't start %s from %s",
+		vdo_log_error_strerror(VDO_INVALID_ADMIN_STATE, "can't start %s from %s",
 				       operation->name, code->name);
 		vdo_continue_completion(waiter, VDO_INVALID_ADMIN_STATE);
 		return false;
diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index b70294d8bb61..e79156dc7cc9 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -264,7 +264,7 @@ static void report_cache_pressure(struct vdo_page_cache *cache)
 	ADD_ONCE(cache->stats.cache_pressure, 1);
 	if (cache->waiter_count > cache->page_count) {
 		if ((cache->pressure_report % LOG_INTERVAL) == 0)
-			uds_log_info("page cache pressure %u", cache->stats.cache_pressure);
+			vdo_log_info("page cache pressure %u", cache->stats.cache_pressure);
 
 		if (++cache->pressure_report >= DISPLAY_INTERVAL)
 			cache->pressure_report = 0;
@@ -483,7 +483,7 @@ static void complete_with_page(struct page_info *info,
 	bool available = vdo_page_comp->writable ? is_present(info) : is_valid(info);
 
 	if (!available) {
-		uds_log_error_strerror(VDO_BAD_PAGE,
+		vdo_log_error_strerror(VDO_BAD_PAGE,
 				       "Requested cache page %llu in state %s is not %s",
 				       (unsigned long long) info->pbn,
 				       get_page_state_name(info->state),
@@ -563,7 +563,7 @@ static void set_persistent_error(struct vdo_page_cache *cache, const char *conte
 	struct vdo *vdo = cache->vdo;
 
 	if ((result != VDO_READ_ONLY) && !vdo_is_read_only(vdo)) {
-		uds_log_error_strerror(result, "VDO Page Cache persistent error: %s",
+		vdo_log_error_strerror(result, "VDO Page Cache persistent error: %s",
 				       context);
 		vdo_enter_read_only_mode(vdo, result);
 	}
@@ -704,7 +704,7 @@ static void page_is_loaded(struct vdo_completion *completion)
 	validity = vdo_validate_block_map_page(page, nonce, info->pbn);
 	if (validity == VDO_BLOCK_MAP_PAGE_BAD) {
 		physical_block_number_t pbn = vdo_get_block_map_page_pbn(page);
-		int result = uds_log_error_strerror(VDO_BAD_PAGE,
+		int result = vdo_log_error_strerror(VDO_BAD_PAGE,
 						    "Expected page %llu but got page %llu instead",
 						    (unsigned long long) info->pbn,
 						    (unsigned long long) pbn);
@@ -894,7 +894,7 @@ static void allocate_free_page(struct page_info *info)
 
 	if (!vdo_waitq_has_waiters(&cache->free_waiters)) {
 		if (cache->stats.cache_pressure > 0) {
-			uds_log_info("page cache pressure relieved");
+			vdo_log_info("page cache pressure relieved");
 			WRITE_ONCE(cache->stats.cache_pressure, 0);
 		}
 
@@ -1012,7 +1012,7 @@ static void handle_page_write_error(struct vdo_completion *completion)
 
 	/* If we're already read-only, write failures are to be expected. */
 	if (result != VDO_READ_ONLY) {
-		uds_log_ratelimit(uds_log_error,
+		vdo_log_ratelimit(vdo_log_error,
 				  "failed to write block map page %llu",
 				  (unsigned long long) info->pbn);
 	}
@@ -1397,7 +1397,7 @@ bool vdo_copy_valid_page(char *buffer, nonce_t nonce,
 	}
 
 	if (validity == VDO_BLOCK_MAP_PAGE_BAD) {
-		uds_log_error_strerror(VDO_BAD_PAGE,
+		vdo_log_error_strerror(VDO_BAD_PAGE,
 				       "Expected page %llu but got page %llu instead",
 				       (unsigned long long) pbn,
 				       (unsigned long long) vdo_get_block_map_page_pbn(loaded));
@@ -1785,7 +1785,7 @@ static void continue_with_loaded_page(struct data_vio *data_vio,
 		vdo_unpack_block_map_entry(&page->entries[slot.block_map_slot.slot]);
 
 	if (is_invalid_tree_entry(vdo_from_data_vio(data_vio), &mapping, lock->height)) {
-		uds_log_error_strerror(VDO_BAD_MAPPING,
+		vdo_log_error_strerror(VDO_BAD_MAPPING,
 				       "Invalid block map tree PBN: %llu with state %u for page index %u at height %u",
 				       (unsigned long long) mapping.pbn, mapping.state,
 				       lock->tree_slots[lock->height - 1].page_index,
@@ -2263,7 +2263,7 @@ void vdo_find_block_map_slot(struct data_vio *data_vio)
 	/* The page at this height has been allocated and loaded. */
 	mapping = vdo_unpack_block_map_entry(&page->entries[tree_slot.block_map_slot.slot]);
 	if (is_invalid_tree_entry(vdo_from_data_vio(data_vio), &mapping, lock->height)) {
-		uds_log_error_strerror(VDO_BAD_MAPPING,
+		vdo_log_error_strerror(VDO_BAD_MAPPING,
 				       "Invalid block map tree PBN: %llu with state %u for page index %u at height %u",
 				       (unsigned long long) mapping.pbn, mapping.state,
 				       lock->tree_slots[lock->height - 1].page_index,
@@ -3140,7 +3140,7 @@ static int __must_check set_mapped_location(struct data_vio *data_vio,
 	 * Log the corruption even if we wind up ignoring it for write VIOs, converting all cases
 	 * to VDO_BAD_MAPPING.
 	 */
-	uds_log_error_strerror(VDO_BAD_MAPPING,
+	vdo_log_error_strerror(VDO_BAD_MAPPING,
 			       "PBN %llu with state %u read from the block map was invalid",
 			       (unsigned long long) mapped.pbn, mapped.state);
 
diff --git a/drivers/md/dm-vdo/data-vio.c b/drivers/md/dm-vdo/data-vio.c
index 2b0d42c77e05..94f6f1ccfb7d 100644
--- a/drivers/md/dm-vdo/data-vio.c
+++ b/drivers/md/dm-vdo/data-vio.c
@@ -792,25 +792,25 @@ static int initialize_data_vio(struct data_vio *data_vio, struct vdo *vdo)
 	result = vdo_allocate_memory(VDO_BLOCK_SIZE, 0, "data_vio data",
 				     &data_vio->vio.data);
 	if (result != VDO_SUCCESS)
-		return uds_log_error_strerror(result,
+		return vdo_log_error_strerror(result,
 					      "data_vio data allocation failure");
 
 	result = vdo_allocate_memory(VDO_BLOCK_SIZE, 0, "compressed block",
 				     &data_vio->compression.block);
 	if (result != VDO_SUCCESS) {
-		return uds_log_error_strerror(result,
+		return vdo_log_error_strerror(result,
 					      "data_vio compressed block allocation failure");
 	}
 
 	result = vdo_allocate_memory(VDO_BLOCK_SIZE, 0, "vio scratch",
 				     &data_vio->scratch_block);
 	if (result != VDO_SUCCESS)
-		return uds_log_error_strerror(result,
+		return vdo_log_error_strerror(result,
 					      "data_vio scratch allocation failure");
 
 	result = vdo_create_bio(&bio);
 	if (result != VDO_SUCCESS)
-		return uds_log_error_strerror(result,
+		return vdo_log_error_strerror(result,
 					      "data_vio data bio allocation failure");
 
 	vdo_initialize_completion(&data_vio->decrement_completion, vdo,
@@ -1025,7 +1025,7 @@ void resume_data_vio_pool(struct data_vio_pool *pool, struct vdo_completion *com
 
 static void dump_limiter(const char *name, struct limiter *limiter)
 {
-	uds_log_info("%s: %u of %u busy (max %u), %s", name, limiter->busy,
+	vdo_log_info("%s: %u of %u busy (max %u), %s", name, limiter->busy,
 		     limiter->limit, limiter->max_busy,
 		     ((bio_list_empty(&limiter->waiters) &&
 		       bio_list_empty(&limiter->new_waiters)) ?
@@ -1323,7 +1323,7 @@ static void perform_cleanup_stage(struct data_vio *data_vio,
 		if ((data_vio->recovery_sequence_number > 0) &&
 		    (READ_ONCE(vdo->read_only_notifier.read_only_error) == VDO_SUCCESS) &&
 		    (data_vio->vio.completion.result != VDO_READ_ONLY))
-			uds_log_warning("VDO not read-only when cleaning data_vio with RJ lock");
+			vdo_log_warning("VDO not read-only when cleaning data_vio with RJ lock");
 		fallthrough;
 
 	case VIO_RELEASE_LOGICAL:
@@ -1353,7 +1353,7 @@ static void enter_read_only_mode(struct vdo_completion *completion)
 	if (completion->result != VDO_READ_ONLY) {
 		struct data_vio *data_vio = as_data_vio(completion);
 
-		uds_log_error_strerror(completion->result,
+		vdo_log_error_strerror(completion->result,
 				       "Preparing to enter read-only mode: data_vio for LBN %llu (becoming mapped to %llu, previously mapped to %llu, allocated %llu) is completing with a fatal error after operation %s",
 				       (unsigned long long) data_vio->logical.lbn,
 				       (unsigned long long) data_vio->new_mapped.pbn,
@@ -1449,14 +1449,14 @@ int uncompress_data_vio(struct data_vio *data_vio,
 						       &fragment_offset, &fragment_size);
 
 	if (result != VDO_SUCCESS) {
-		uds_log_debug("%s: compressed fragment error %d", __func__, result);
+		vdo_log_debug("%s: compressed fragment error %d", __func__, result);
 		return result;
 	}
 
 	size = LZ4_decompress_safe((block->data + fragment_offset), buffer,
 				   fragment_size, VDO_BLOCK_SIZE);
 	if (size != VDO_BLOCK_SIZE) {
-		uds_log_debug("%s: lz4 error", __func__);
+		vdo_log_debug("%s: lz4 error", __func__);
 		return VDO_INVALID_FRAGMENT;
 	}
 
diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index c031ab01054d..117266e1b3ae 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -1287,7 +1287,7 @@ static bool acquire_provisional_reference(struct data_vio *agent, struct pbn_loc
 	if (result == VDO_SUCCESS)
 		return true;
 
-	uds_log_warning_strerror(result,
+	vdo_log_warning_strerror(result,
 				 "Error acquiring provisional reference for dedupe candidate; aborting dedupe");
 	agent->is_duplicate = false;
 	vdo_release_physical_zone_pbn_lock(agent->duplicate.zone,
@@ -1614,7 +1614,7 @@ static bool decode_uds_advice(struct dedupe_context *context)
 
 	version = encoding->data[offset++];
 	if (version != UDS_ADVICE_VERSION) {
-		uds_log_error("invalid UDS advice version code %u", version);
+		vdo_log_error("invalid UDS advice version code %u", version);
 		return false;
 	}
 
@@ -1625,7 +1625,7 @@ static bool decode_uds_advice(struct dedupe_context *context)
 
 	/* Don't use advice that's clearly meaningless. */
 	if ((advice->state == VDO_MAPPING_STATE_UNMAPPED) || (advice->pbn == VDO_ZERO_BLOCK)) {
-		uds_log_debug("Invalid advice from deduplication server: pbn %llu, state %u. Giving up on deduplication of logical block %llu",
+		vdo_log_debug("Invalid advice from deduplication server: pbn %llu, state %u. Giving up on deduplication of logical block %llu",
 			      (unsigned long long) advice->pbn, advice->state,
 			      (unsigned long long) data_vio->logical.lbn);
 		atomic64_inc(&vdo->stats.invalid_advice_pbn_count);
@@ -1634,7 +1634,7 @@ static bool decode_uds_advice(struct dedupe_context *context)
 
 	result = vdo_get_physical_zone(vdo, advice->pbn, &advice->zone);
 	if ((result != VDO_SUCCESS) || (advice->zone == NULL)) {
-		uds_log_debug("Invalid physical block number from deduplication server: %llu, giving up on deduplication of logical block %llu",
+		vdo_log_debug("Invalid physical block number from deduplication server: %llu, giving up on deduplication of logical block %llu",
 			      (unsigned long long) advice->pbn,
 			      (unsigned long long) data_vio->logical.lbn);
 		atomic64_inc(&vdo->stats.invalid_advice_pbn_count);
@@ -2053,7 +2053,7 @@ static void close_index(struct hash_zones *zones)
 	result = uds_close_index(zones->index_session);
 
 	if (result != UDS_SUCCESS)
-		uds_log_error_strerror(result, "Error closing index");
+		vdo_log_error_strerror(result, "Error closing index");
 	spin_lock(&zones->lock);
 	zones->index_state = IS_CLOSED;
 	zones->error_flag |= result != UDS_SUCCESS;
@@ -2080,7 +2080,7 @@ static void open_index(struct hash_zones *zones)
 	result = uds_open_index(create_flag ? UDS_CREATE : UDS_LOAD,
 				&zones->parameters, zones->index_session);
 	if (result != UDS_SUCCESS)
-		uds_log_error_strerror(result, "Error opening index");
+		vdo_log_error_strerror(result, "Error opening index");
 
 	spin_lock(&zones->lock);
 	if (!create_flag) {
@@ -2104,7 +2104,7 @@ static void open_index(struct hash_zones *zones)
 		zones->index_target = IS_CLOSED;
 		zones->error_flag = true;
 		spin_unlock(&zones->lock);
-		uds_log_info("Setting UDS index target state to error");
+		vdo_log_info("Setting UDS index target state to error");
 		spin_lock(&zones->lock);
 	}
 	/*
@@ -2160,7 +2160,7 @@ static void report_dedupe_timeouts(struct hash_zones *zones, unsigned int timeou
 		u64 unreported = atomic64_read(&zones->timeouts);
 
 		unreported -= zones->reported_timeouts;
-		uds_log_debug("UDS index timeout on %llu requests",
+		vdo_log_debug("UDS index timeout on %llu requests",
 			      (unsigned long long) unreported);
 		zones->reported_timeouts += unreported;
 	}
@@ -2207,7 +2207,7 @@ static int initialize_index(struct vdo *vdo, struct hash_zones *zones)
 				 1, NULL);
 	if (result != VDO_SUCCESS) {
 		uds_destroy_index_session(vdo_forget(zones->index_session));
-		uds_log_error("UDS index queue initialization failed (%d)", result);
+		vdo_log_error("UDS index queue initialization failed (%d)", result);
 		return result;
 	}
 
@@ -2502,7 +2502,7 @@ static void initiate_suspend_index(struct admin_state *state)
 
 		result = uds_suspend_index_session(zones->index_session, save);
 		if (result != UDS_SUCCESS)
-			uds_log_error_strerror(result, "Error suspending dedupe index");
+			vdo_log_error_strerror(result, "Error suspending dedupe index");
 	}
 
 	vdo_finish_draining(state);
@@ -2585,7 +2585,7 @@ static void resume_index(void *context, struct vdo_completion *parent)
 	zones->parameters.bdev = config->owned_device->bdev;
 	result = uds_resume_index_session(zones->index_session, zones->parameters.bdev);
 	if (result != UDS_SUCCESS)
-		uds_log_error_strerror(result, "Error resuming dedupe index");
+		vdo_log_error_strerror(result, "Error resuming dedupe index");
 
 	spin_lock(&zones->lock);
 	vdo_resume_if_quiescent(&zones->state);
@@ -2665,7 +2665,7 @@ static void get_index_statistics(struct hash_zones *zones,
 
 	result = uds_get_index_session_stats(zones->index_session, &index_stats);
 	if (result != UDS_SUCCESS) {
-		uds_log_error_strerror(result, "Error reading index stats");
+		vdo_log_error_strerror(result, "Error reading index stats");
 		return;
 	}
 
@@ -2750,7 +2750,7 @@ static void dump_hash_lock(const struct hash_lock *lock)
 	 * unambiguous. 'U' indicates a lock not registered in the map.
 	 */
 	state = get_hash_lock_state_name(lock->state);
-	uds_log_info("  hl %px: %3.3s %c%llu/%u rc=%u wc=%zu agt=%px",
+	vdo_log_info("  hl %px: %3.3s %c%llu/%u rc=%u wc=%zu agt=%px",
 		     lock, state, (lock->registered ? 'D' : 'U'),
 		     (unsigned long long) lock->duplicate.pbn,
 		     lock->duplicate.state, lock->reference_count,
@@ -2784,11 +2784,11 @@ static void dump_hash_zone(const struct hash_zone *zone)
 	data_vio_count_t i;
 
 	if (zone->hash_lock_map == NULL) {
-		uds_log_info("struct hash_zone %u: NULL map", zone->zone_number);
+		vdo_log_info("struct hash_zone %u: NULL map", zone->zone_number);
 		return;
 	}
 
-	uds_log_info("struct hash_zone %u: mapSize=%zu",
+	vdo_log_info("struct hash_zone %u: mapSize=%zu",
 		     zone->zone_number, vdo_int_map_size(zone->hash_lock_map));
 	for (i = 0; i < LOCK_POOL_CAPACITY; i++)
 		dump_hash_lock(&zone->lock_array[i]);
@@ -2808,9 +2808,9 @@ void vdo_dump_hash_zones(struct hash_zones *zones)
 	target = (zones->changing ? index_state_to_string(zones, zones->index_target) : NULL);
 	spin_unlock(&zones->lock);
 
-	uds_log_info("UDS index: state: %s", state);
+	vdo_log_info("UDS index: state: %s", state);
 	if (target != NULL)
-		uds_log_info("UDS index: changing to state: %s", target);
+		vdo_log_info("UDS index: changing to state: %s", target);
 
 	for (zone = 0; zone < zones->zone_count; zone++)
 		dump_hash_zone(&zones->zones[zone]);
@@ -2957,7 +2957,7 @@ static void set_target_state(struct hash_zones *zones, enum index_state target,
 	spin_unlock(&zones->lock);
 
 	if (old_state != new_state)
-		uds_log_info("Setting UDS index target state to %s", new_state);
+		vdo_log_info("Setting UDS index target state to %s", new_state);
 }
 
 const char *vdo_get_dedupe_index_state_name(struct hash_zones *zones)
diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index 288e9b79bf16..4908996f5224 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -232,9 +232,9 @@ static int get_version_number(int argc, char **argv, char **error_ptr,
 	}
 
 	if (*version_ptr != TABLE_VERSION) {
-		uds_log_warning("Detected version mismatch between kernel module and tools kernel: %d, tool: %d",
+		vdo_log_warning("Detected version mismatch between kernel module and tools kernel: %d, tool: %d",
 				TABLE_VERSION, *version_ptr);
-		uds_log_warning("Please consider upgrading management tools to match kernel.");
+		vdo_log_warning("Please consider upgrading management tools to match kernel.");
 	}
 	return VDO_SUCCESS;
 }
@@ -399,10 +399,10 @@ static int process_one_thread_config_spec(const char *thread_param_type,
 	/* Handle limited thread parameters */
 	if (strcmp(thread_param_type, "bioRotationInterval") == 0) {
 		if (count == 0) {
-			uds_log_error("thread config string error:  'bioRotationInterval' of at least 1 is required");
+			vdo_log_error("thread config string error:  'bioRotationInterval' of at least 1 is required");
 			return -EINVAL;
 		} else if (count > VDO_BIO_ROTATION_INTERVAL_LIMIT) {
-			uds_log_error("thread config string error: 'bioRotationInterval' cannot be higher than %d",
+			vdo_log_error("thread config string error: 'bioRotationInterval' cannot be higher than %d",
 				      VDO_BIO_ROTATION_INTERVAL_LIMIT);
 			return -EINVAL;
 		}
@@ -411,7 +411,7 @@ static int process_one_thread_config_spec(const char *thread_param_type,
 	}
 	if (strcmp(thread_param_type, "logical") == 0) {
 		if (count > MAX_VDO_LOGICAL_ZONES) {
-			uds_log_error("thread config string error: at most %d 'logical' threads are allowed",
+			vdo_log_error("thread config string error: at most %d 'logical' threads are allowed",
 				      MAX_VDO_LOGICAL_ZONES);
 			return -EINVAL;
 		}
@@ -420,7 +420,7 @@ static int process_one_thread_config_spec(const char *thread_param_type,
 	}
 	if (strcmp(thread_param_type, "physical") == 0) {
 		if (count > MAX_VDO_PHYSICAL_ZONES) {
-			uds_log_error("thread config string error: at most %d 'physical' threads are allowed",
+			vdo_log_error("thread config string error: at most %d 'physical' threads are allowed",
 				      MAX_VDO_PHYSICAL_ZONES);
 			return -EINVAL;
 		}
@@ -429,7 +429,7 @@ static int process_one_thread_config_spec(const char *thread_param_type,
 	}
 	/* Handle other thread count parameters */
 	if (count > MAXIMUM_VDO_THREADS) {
-		uds_log_error("thread config string error: at most %d '%s' threads are allowed",
+		vdo_log_error("thread config string error: at most %d '%s' threads are allowed",
 			      MAXIMUM_VDO_THREADS, thread_param_type);
 		return -EINVAL;
 	}
@@ -439,7 +439,7 @@ static int process_one_thread_config_spec(const char *thread_param_type,
 	}
 	if (strcmp(thread_param_type, "cpu") == 0) {
 		if (count == 0) {
-			uds_log_error("thread config string error: at least one 'cpu' thread required");
+			vdo_log_error("thread config string error: at least one 'cpu' thread required");
 			return -EINVAL;
 		}
 		config->cpu_threads = count;
@@ -451,7 +451,7 @@ static int process_one_thread_config_spec(const char *thread_param_type,
 	}
 	if (strcmp(thread_param_type, "bio") == 0) {
 		if (count == 0) {
-			uds_log_error("thread config string error: at least one 'bio' thread required");
+			vdo_log_error("thread config string error: at least one 'bio' thread required");
 			return -EINVAL;
 		}
 		config->bio_threads = count;
@@ -462,7 +462,7 @@ static int process_one_thread_config_spec(const char *thread_param_type,
 	 * Don't fail, just log. This will handle version mismatches between user mode tools and
 	 * kernel.
 	 */
-	uds_log_info("unknown thread parameter type \"%s\"", thread_param_type);
+	vdo_log_info("unknown thread parameter type \"%s\"", thread_param_type);
 	return VDO_SUCCESS;
 }
 
@@ -484,7 +484,7 @@ static int parse_one_thread_config_spec(const char *spec,
 		return result;
 
 	if ((fields[0] == NULL) || (fields[1] == NULL) || (fields[2] != NULL)) {
-		uds_log_error("thread config string error: expected thread parameter assignment, saw \"%s\"",
+		vdo_log_error("thread config string error: expected thread parameter assignment, saw \"%s\"",
 			      spec);
 		free_string_array(fields);
 		return -EINVAL;
@@ -492,7 +492,7 @@ static int parse_one_thread_config_spec(const char *spec,
 
 	result = kstrtouint(fields[1], 10, &count);
 	if (result) {
-		uds_log_error("thread config string error: integer value needed, found \"%s\"",
+		vdo_log_error("thread config string error: integer value needed, found \"%s\"",
 			      fields[1]);
 		free_string_array(fields);
 		return result;
@@ -564,12 +564,12 @@ static int process_one_key_value_pair(const char *key, unsigned int value,
 	/* Non thread optional parameters */
 	if (strcmp(key, "maxDiscard") == 0) {
 		if (value == 0) {
-			uds_log_error("optional parameter error: at least one max discard block required");
+			vdo_log_error("optional parameter error: at least one max discard block required");
 			return -EINVAL;
 		}
 		/* Max discard sectors in blkdev_issue_discard is UINT_MAX >> 9 */
 		if (value > (UINT_MAX / VDO_BLOCK_SIZE)) {
-			uds_log_error("optional parameter error: at most %d max discard	 blocks are allowed",
+			vdo_log_error("optional parameter error: at most %d max discard	 blocks are allowed",
 				      UINT_MAX / VDO_BLOCK_SIZE);
 			return -EINVAL;
 		}
@@ -604,7 +604,7 @@ static int parse_one_key_value_pair(const char *key, const char *value,
 	/* The remaining arguments must have integral values. */
 	result = kstrtouint(value, 10, &count);
 	if (result) {
-		uds_log_error("optional config string error: integer value needed, found \"%s\"",
+		vdo_log_error("optional config string error: integer value needed, found \"%s\"",
 			      value);
 		return result;
 	}
@@ -745,7 +745,7 @@ static int parse_device_config(int argc, char **argv, struct dm_target *ti,
 		return VDO_BAD_CONFIGURATION;
 	}
 
-	uds_log_info("table line: %s", config->original_string);
+	vdo_log_info("table line: %s", config->original_string);
 
 	config->thread_counts = (struct thread_count_config) {
 		.bio_ack_threads = 1,
@@ -872,7 +872,7 @@ static int parse_device_config(int argc, char **argv, struct dm_target *ti,
 	result = dm_get_device(ti, config->parent_device_name,
 			       dm_table_get_mode(ti->table), &config->owned_device);
 	if (result != 0) {
-		uds_log_error("couldn't open device \"%s\": error %d",
+		vdo_log_error("couldn't open device \"%s\": error %d",
 			      config->parent_device_name, result);
 		handle_parse_error(config, error_ptr, "Unable to open storage device");
 		return VDO_BAD_CONFIGURATION;
@@ -1029,12 +1029,12 @@ static int __must_check process_vdo_message_locked(struct vdo *vdo, unsigned int
 			return 0;
 		}
 
-		uds_log_warning("invalid argument '%s' to dmsetup compression message",
+		vdo_log_warning("invalid argument '%s' to dmsetup compression message",
 				argv[1]);
 		return -EINVAL;
 	}
 
-	uds_log_warning("unrecognized dmsetup message '%s' received", argv[0]);
+	vdo_log_warning("unrecognized dmsetup message '%s' received", argv[0]);
 	return -EINVAL;
 }
 
@@ -1091,7 +1091,7 @@ static int vdo_message(struct dm_target *ti, unsigned int argc, char **argv,
 	int result;
 
 	if (argc == 0) {
-		uds_log_warning("unspecified dmsetup message");
+		vdo_log_warning("unspecified dmsetup message");
 		return -EINVAL;
 	}
 
@@ -1211,7 +1211,7 @@ static int perform_admin_operation(struct vdo *vdo, u32 starting_phase,
 	struct vdo_administrator *admin = &vdo->admin;
 
 	if (atomic_cmpxchg(&admin->busy, 0, 1) != 0) {
-		return uds_log_error_strerror(VDO_COMPONENT_BUSY,
+		return vdo_log_error_strerror(VDO_COMPONENT_BUSY,
 					      "Can't start %s operation, another operation is already in progress",
 					      type);
 	}
@@ -1285,7 +1285,7 @@ static int __must_check decode_from_super_block(struct vdo *vdo)
 	 * block, just accept it.
 	 */
 	if (vdo->states.vdo.config.logical_blocks < config->logical_blocks) {
-		uds_log_warning("Growing logical size: a logical size of %llu blocks was specified, but that differs from the %llu blocks configured in the vdo super block",
+		vdo_log_warning("Growing logical size: a logical size of %llu blocks was specified, but that differs from the %llu blocks configured in the vdo super block",
 				(unsigned long long) config->logical_blocks,
 				(unsigned long long) vdo->states.vdo.config.logical_blocks);
 		vdo->states.vdo.config.logical_blocks = config->logical_blocks;
@@ -1328,14 +1328,14 @@ static int __must_check decode_vdo(struct vdo *vdo)
 	journal_length =
 		vdo_get_recovery_journal_length(vdo->states.vdo.config.recovery_journal_size);
 	if (maximum_age > (journal_length / 2)) {
-		return uds_log_error_strerror(VDO_BAD_CONFIGURATION,
+		return vdo_log_error_strerror(VDO_BAD_CONFIGURATION,
 					      "maximum age: %llu exceeds limit %llu",
 					      (unsigned long long) maximum_age,
 					      (unsigned long long) (journal_length / 2));
 	}
 
 	if (maximum_age == 0) {
-		return uds_log_error_strerror(VDO_BAD_CONFIGURATION,
+		return vdo_log_error_strerror(VDO_BAD_CONFIGURATION,
 					      "maximum age must be greater than 0");
 	}
 
@@ -1451,19 +1451,19 @@ static int vdo_initialize(struct dm_target *ti, unsigned int instance,
 	u64 logical_size = to_bytes(ti->len);
 	block_count_t logical_blocks = logical_size / block_size;
 
-	uds_log_info("loading device '%s'", vdo_get_device_name(ti));
-	uds_log_debug("Logical block size     = %llu", (u64) config->logical_block_size);
-	uds_log_debug("Logical blocks         = %llu", logical_blocks);
-	uds_log_debug("Physical block size    = %llu", (u64) block_size);
-	uds_log_debug("Physical blocks        = %llu", config->physical_blocks);
-	uds_log_debug("Block map cache blocks = %u", config->cache_size);
-	uds_log_debug("Block map maximum age  = %u", config->block_map_maximum_age);
-	uds_log_debug("Deduplication          = %s", (config->deduplication ? "on" : "off"));
-	uds_log_debug("Compression            = %s", (config->compression ? "on" : "off"));
+	vdo_log_info("loading device '%s'", vdo_get_device_name(ti));
+	vdo_log_debug("Logical block size     = %llu", (u64) config->logical_block_size);
+	vdo_log_debug("Logical blocks         = %llu", logical_blocks);
+	vdo_log_debug("Physical block size    = %llu", (u64) block_size);
+	vdo_log_debug("Physical blocks        = %llu", config->physical_blocks);
+	vdo_log_debug("Block map cache blocks = %u", config->cache_size);
+	vdo_log_debug("Block map maximum age  = %u", config->block_map_maximum_age);
+	vdo_log_debug("Deduplication          = %s", (config->deduplication ? "on" : "off"));
+	vdo_log_debug("Compression            = %s", (config->compression ? "on" : "off"));
 
 	vdo = vdo_find_matching(vdo_uses_device, config);
 	if (vdo != NULL) {
-		uds_log_error("Existing vdo already uses device %s",
+		vdo_log_error("Existing vdo already uses device %s",
 			      vdo->device_config->parent_device_name);
 		ti->error = "Cannot share storage device with already-running VDO";
 		return VDO_BAD_CONFIGURATION;
@@ -1471,7 +1471,7 @@ static int vdo_initialize(struct dm_target *ti, unsigned int instance,
 
 	result = vdo_make(instance, config, &ti->error, &vdo);
 	if (result != VDO_SUCCESS) {
-		uds_log_error("Could not create VDO device. (VDO error %d, message %s)",
+		vdo_log_error("Could not create VDO device. (VDO error %d, message %s)",
 			      result, ti->error);
 		vdo_destroy(vdo);
 		return result;
@@ -1483,7 +1483,7 @@ static int vdo_initialize(struct dm_target *ti, unsigned int instance,
 		ti->error = ((result == VDO_INVALID_ADMIN_STATE) ?
 			     "Pre-load is only valid immediately after initialization" :
 			     "Cannot load metadata from device");
-		uds_log_error("Could not start VDO device. (VDO error %d, message %s)",
+		vdo_log_error("Could not start VDO device. (VDO error %d, message %s)",
 			      result, ti->error);
 		vdo_destroy(vdo);
 		return result;
@@ -1594,7 +1594,7 @@ static int construct_new_vdo_registered(struct dm_target *ti, unsigned int argc,
 
 	result = parse_device_config(argc, argv, ti, &config);
 	if (result != VDO_SUCCESS) {
-		uds_log_error_strerror(result, "parsing failed: %s", ti->error);
+		vdo_log_error_strerror(result, "parsing failed: %s", ti->error);
 		release_instance(instance);
 		return -EINVAL;
 	}
@@ -1723,7 +1723,7 @@ static int prepare_to_grow_physical(struct vdo *vdo, block_count_t new_physical_
 	int result;
 	block_count_t current_physical_blocks = vdo->states.vdo.config.physical_blocks;
 
-	uds_log_info("Preparing to resize physical to %llu",
+	vdo_log_info("Preparing to resize physical to %llu",
 		     (unsigned long long) new_physical_blocks);
 	VDO_ASSERT_LOG_ONLY((new_physical_blocks > current_physical_blocks),
 			    "New physical size is larger than current physical size");
@@ -1746,7 +1746,7 @@ static int prepare_to_grow_physical(struct vdo *vdo, block_count_t new_physical_
 		return result;
 	}
 
-	uds_log_info("Done preparing to resize physical");
+	vdo_log_info("Done preparing to resize physical");
 	return VDO_SUCCESS;
 }
 
@@ -1823,7 +1823,7 @@ static int prepare_to_modify(struct dm_target *ti, struct device_config *config,
 	if (config->logical_blocks > vdo->device_config->logical_blocks) {
 		block_count_t logical_blocks = vdo->states.vdo.config.logical_blocks;
 
-		uds_log_info("Preparing to resize logical to %llu",
+		vdo_log_info("Preparing to resize logical to %llu",
 			     (unsigned long long) config->logical_blocks);
 		VDO_ASSERT_LOG_ONLY((config->logical_blocks > logical_blocks),
 				    "New logical size is larger than current size");
@@ -1835,7 +1835,7 @@ static int prepare_to_modify(struct dm_target *ti, struct device_config *config,
 			return result;
 		}
 
-		uds_log_info("Done preparing to resize logical");
+		vdo_log_info("Done preparing to resize logical");
 	}
 
 	if (config->physical_blocks > vdo->device_config->physical_blocks) {
@@ -1861,7 +1861,7 @@ static int prepare_to_modify(struct dm_target *ti, struct device_config *config,
 	if (strcmp(config->parent_device_name, vdo->device_config->parent_device_name) != 0) {
 		const char *device_name = vdo_get_device_name(config->owning_target);
 
-		uds_log_info("Updating backing device of %s from %s to %s", device_name,
+		vdo_log_info("Updating backing device of %s from %s to %s", device_name,
 			     vdo->device_config->parent_device_name,
 			     config->parent_device_name);
 	}
@@ -1879,7 +1879,7 @@ static int update_existing_vdo(const char *device_name, struct dm_target *ti,
 	if (result != VDO_SUCCESS)
 		return -EINVAL;
 
-	uds_log_info("preparing to modify device '%s'", device_name);
+	vdo_log_info("preparing to modify device '%s'", device_name);
 	result = prepare_to_modify(ti, config, vdo);
 	if (result != VDO_SUCCESS) {
 		free_device_config(config);
@@ -1929,12 +1929,12 @@ static void vdo_dtr(struct dm_target *ti)
 		vdo_register_allocating_thread(&allocating_thread, NULL);
 
 		device_name = vdo_get_device_name(ti);
-		uds_log_info("stopping device '%s'", device_name);
+		vdo_log_info("stopping device '%s'", device_name);
 		if (vdo->dump_on_shutdown)
 			vdo_dump_all(vdo, "device shutdown");
 
 		vdo_destroy(vdo_forget(vdo));
-		uds_log_info("device '%s' stopped", device_name);
+		vdo_log_info("device '%s' stopped", device_name);
 		vdo_unregister_thread_device_id();
 		vdo_unregister_allocating_thread();
 		release_instance(instance);
@@ -2096,7 +2096,7 @@ static void vdo_postsuspend(struct dm_target *ti)
 
 	vdo_register_thread_device_id(&instance_thread, &vdo->instance);
 	device_name = vdo_get_device_name(vdo->device_config->owning_target);
-	uds_log_info("suspending device '%s'", device_name);
+	vdo_log_info("suspending device '%s'", device_name);
 
 	/*
 	 * It's important to note any error here does not actually stop device-mapper from
@@ -2110,12 +2110,12 @@ static void vdo_postsuspend(struct dm_target *ti)
 		 * Treat VDO_READ_ONLY as a success since a read-only suspension still leaves the
 		 * VDO suspended.
 		 */
-		uds_log_info("device '%s' suspended", device_name);
+		vdo_log_info("device '%s' suspended", device_name);
 	} else if (result == VDO_INVALID_ADMIN_STATE) {
-		uds_log_error("Suspend invoked while in unexpected state: %s",
+		vdo_log_error("Suspend invoked while in unexpected state: %s",
 			      vdo_get_admin_state(vdo)->name);
 	} else {
-		uds_log_error_strerror(result, "Suspend of device '%s' failed",
+		vdo_log_error_strerror(result, "Suspend of device '%s' failed",
 				       device_name);
 	}
 
@@ -2288,13 +2288,13 @@ static void handle_load_error(struct vdo_completion *completion)
 
 	if (vdo_state_requires_read_only_rebuild(vdo->load_state) &&
 	    (vdo->admin.phase == LOAD_PHASE_MAKE_DIRTY)) {
-		uds_log_error_strerror(completion->result, "aborting load");
+		vdo_log_error_strerror(completion->result, "aborting load");
 		vdo->admin.phase = LOAD_PHASE_DRAIN_JOURNAL;
 		load_callback(vdo_forget(completion));
 		return;
 	}
 
-	uds_log_error_strerror(completion->result,
+	vdo_log_error_strerror(completion->result,
 			       "Entering read-only mode due to load error");
 	vdo->admin.phase = LOAD_PHASE_WAIT_FOR_READ_ONLY;
 	vdo_enter_read_only_mode(vdo, completion->result);
@@ -2386,7 +2386,7 @@ static void resume_callback(struct vdo_completion *completion)
 
 		if (enable != was_enabled)
 			WRITE_ONCE(vdo->compressing, enable);
-		uds_log_info("compression is %s", (enable ? "enabled" : "disabled"));
+		vdo_log_info("compression is %s", (enable ? "enabled" : "disabled"));
 
 		vdo_resume_packer(vdo->packer, completion);
 		return;
@@ -2426,7 +2426,7 @@ static void grow_logical_callback(struct vdo_completion *completion)
 	switch (advance_phase(vdo)) {
 	case GROW_LOGICAL_PHASE_START:
 		if (vdo_is_read_only(vdo)) {
-			uds_log_error_strerror(VDO_READ_ONLY,
+			vdo_log_error_strerror(VDO_READ_ONLY,
 					       "Can't grow logical size of a read-only VDO");
 			vdo_set_completion_result(completion, VDO_READ_ONLY);
 			break;
@@ -2505,7 +2505,7 @@ static int perform_grow_logical(struct vdo *vdo, block_count_t new_logical_block
 		return VDO_SUCCESS;
 	}
 
-	uds_log_info("Resizing logical to %llu",
+	vdo_log_info("Resizing logical to %llu",
 		     (unsigned long long) new_logical_blocks);
 	if (vdo->block_map->next_entry_count != new_logical_blocks)
 		return VDO_PARAMETER_MISMATCH;
@@ -2516,7 +2516,7 @@ static int perform_grow_logical(struct vdo *vdo, block_count_t new_logical_block
 	if (result != VDO_SUCCESS)
 		return result;
 
-	uds_log_info("Logical blocks now %llu", (unsigned long long) new_logical_blocks);
+	vdo_log_info("Logical blocks now %llu", (unsigned long long) new_logical_blocks);
 	return VDO_SUCCESS;
 }
 
@@ -2576,7 +2576,7 @@ static void grow_physical_callback(struct vdo_completion *completion)
 	switch (advance_phase(vdo)) {
 	case GROW_PHYSICAL_PHASE_START:
 		if (vdo_is_read_only(vdo)) {
-			uds_log_error_strerror(VDO_READ_ONLY,
+			vdo_log_error_strerror(VDO_READ_ONLY,
 					       "Can't grow physical size of a read-only VDO");
 			vdo_set_completion_result(completion, VDO_READ_ONLY);
 			break;
@@ -2685,7 +2685,7 @@ static int perform_grow_physical(struct vdo *vdo, block_count_t new_physical_blo
 	if (result != VDO_SUCCESS)
 		return result;
 
-	uds_log_info("Physical block count was %llu, now %llu",
+	vdo_log_info("Physical block count was %llu, now %llu",
 		     (unsigned long long) old_physical_blocks,
 		     (unsigned long long) new_physical_blocks);
 	return VDO_SUCCESS;
@@ -2707,13 +2707,13 @@ static int __must_check apply_new_vdo_configuration(struct vdo *vdo,
 
 	result = perform_grow_logical(vdo, config->logical_blocks);
 	if (result != VDO_SUCCESS) {
-		uds_log_error("grow logical operation failed, result = %d", result);
+		vdo_log_error("grow logical operation failed, result = %d", result);
 		return result;
 	}
 
 	result = perform_grow_physical(vdo, config->physical_blocks);
 	if (result != VDO_SUCCESS)
-		uds_log_error("resize operation failed, result = %d", result);
+		vdo_log_error("resize operation failed, result = %d", result);
 
 	return result;
 }
@@ -2728,14 +2728,14 @@ static int vdo_preresume_registered(struct dm_target *ti, struct vdo *vdo)
 	backing_blocks = get_underlying_device_block_count(vdo);
 	if (backing_blocks < config->physical_blocks) {
 		/* FIXME: can this still happen? */
-		uds_log_error("resume of device '%s' failed: backing device has %llu blocks but VDO physical size is %llu blocks",
+		vdo_log_error("resume of device '%s' failed: backing device has %llu blocks but VDO physical size is %llu blocks",
 			      device_name, (unsigned long long) backing_blocks,
 			      (unsigned long long) config->physical_blocks);
 		return -EINVAL;
 	}
 
 	if (vdo_get_admin_state(vdo) == VDO_ADMIN_STATE_PRE_LOADED) {
-		uds_log_info("starting device '%s'", device_name);
+		vdo_log_info("starting device '%s'", device_name);
 		result = perform_admin_operation(vdo, LOAD_PHASE_START, load_callback,
 						 handle_load_error, "load");
 		if ((result != VDO_SUCCESS) && (result != VDO_READ_ONLY)) {
@@ -2743,7 +2743,7 @@ static int vdo_preresume_registered(struct dm_target *ti, struct vdo *vdo)
 			 * Something has gone very wrong. Make sure everything has drained and
 			 * leave the device in an unresumable state.
 			 */
-			uds_log_error_strerror(result,
+			vdo_log_error_strerror(result,
 					       "Start failed, could not load VDO metadata");
 			vdo->suspend_type = VDO_ADMIN_STATE_STOPPING;
 			perform_admin_operation(vdo, SUSPEND_PHASE_START,
@@ -2753,10 +2753,10 @@ static int vdo_preresume_registered(struct dm_target *ti, struct vdo *vdo)
 		}
 
 		/* Even if the VDO is read-only, it is now able to handle read requests. */
-		uds_log_info("device '%s' started", device_name);
+		vdo_log_info("device '%s' started", device_name);
 	}
 
-	uds_log_info("resuming device '%s'", device_name);
+	vdo_log_info("resuming device '%s'", device_name);
 
 	/* If this fails, the VDO was not in a state to be resumed. This should never happen. */
 	result = apply_new_vdo_configuration(vdo, config);
@@ -2774,7 +2774,7 @@ static int vdo_preresume_registered(struct dm_target *ti, struct vdo *vdo)
 	 * written to disk.
 	 */
 	if (result != VDO_SUCCESS) {
-		uds_log_error_strerror(result,
+		vdo_log_error_strerror(result,
 				       "Commit of modifications to device '%s' failed",
 				       device_name);
 		vdo_enter_read_only_mode(vdo, result);
@@ -2795,7 +2795,7 @@ static int vdo_preresume_registered(struct dm_target *ti, struct vdo *vdo)
 	}
 
 	if (result != VDO_SUCCESS)
-		uds_log_error("resume of device '%s' failed with error: %d", device_name,
+		vdo_log_error("resume of device '%s' failed with error: %d", device_name,
 			      result);
 
 	return result;
@@ -2821,7 +2821,7 @@ static void vdo_resume(struct dm_target *ti)
 
 	vdo_register_thread_device_id(&instance_thread,
 				      &get_vdo_for_target(ti)->instance);
-	uds_log_info("device '%s' resumed", vdo_get_device_name(ti));
+	vdo_log_info("device '%s' resumed", vdo_get_device_name(ti));
 	vdo_unregister_thread_device_id();
 }
 
@@ -2852,7 +2852,7 @@ static bool dm_registered;
 
 static void vdo_module_destroy(void)
 {
-	uds_log_debug("unloading");
+	vdo_log_debug("unloading");
 
 	if (dm_registered)
 		dm_unregister_target(&vdo_target_bio);
@@ -2863,7 +2863,7 @@ static void vdo_module_destroy(void)
 	vdo_free(instances.words);
 	memset(&instances, 0, sizeof(struct instance_tracker));
 
-	uds_log_info("unloaded version %s", CURRENT_VERSION);
+	vdo_log_info("unloaded version %s", CURRENT_VERSION);
 }
 
 static int __init vdo_init(void)
@@ -2874,19 +2874,19 @@ static int __init vdo_init(void)
 	vdo_memory_init();
 	vdo_initialize_thread_device_registry();
 	vdo_initialize_device_registry_once();
-	uds_log_info("loaded version %s", CURRENT_VERSION);
+	vdo_log_info("loaded version %s", CURRENT_VERSION);
 
 	/* Add VDO errors to the set of errors registered by the indexer. */
 	result = vdo_register_status_codes();
 	if (result != VDO_SUCCESS) {
-		uds_log_error("vdo_register_status_codes failed %d", result);
+		vdo_log_error("vdo_register_status_codes failed %d", result);
 		vdo_module_destroy();
 		return result;
 	}
 
 	result = dm_register_target(&vdo_target_bio);
 	if (result < 0) {
-		uds_log_error("dm_register_target failed %d", result);
+		vdo_log_error("dm_register_target failed %d", result);
 		vdo_module_destroy();
 		return result;
 	}
diff --git a/drivers/md/dm-vdo/dump.c b/drivers/md/dm-vdo/dump.c
index 52ee9a72781c..00e575d7d773 100644
--- a/drivers/md/dm-vdo/dump.c
+++ b/drivers/md/dm-vdo/dump.c
@@ -58,12 +58,12 @@ static void do_dump(struct vdo *vdo, unsigned int dump_options_requested,
 	u32 active, maximum;
 	s64 outstanding;
 
-	uds_log_info("%s dump triggered via %s", UDS_LOGGING_MODULE_NAME, why);
+	vdo_log_info("%s dump triggered via %s", VDO_LOGGING_MODULE_NAME, why);
 	active = get_data_vio_pool_active_requests(vdo->data_vio_pool);
 	maximum = get_data_vio_pool_maximum_requests(vdo->data_vio_pool);
 	outstanding = (atomic64_read(&vdo->stats.bios_submitted) -
 		       atomic64_read(&vdo->stats.bios_completed));
-	uds_log_info("%u device requests outstanding (max %u), %lld bio requests outstanding, device '%s'",
+	vdo_log_info("%u device requests outstanding (max %u), %lld bio requests outstanding, device '%s'",
 		     active, maximum, outstanding,
 		     vdo_get_device_name(vdo->device_config->owning_target));
 	if (((dump_options_requested & FLAG_SHOW_QUEUES) != 0) && (vdo->threads != NULL)) {
@@ -80,7 +80,7 @@ static void do_dump(struct vdo *vdo, unsigned int dump_options_requested,
 		vdo_dump_status(vdo);
 
 	vdo_report_memory_usage();
-	uds_log_info("end of %s dump", UDS_LOGGING_MODULE_NAME);
+	vdo_log_info("end of %s dump", VDO_LOGGING_MODULE_NAME);
 }
 
 static int parse_dump_options(unsigned int argc, char *const *argv,
@@ -114,7 +114,7 @@ static int parse_dump_options(unsigned int argc, char *const *argv,
 			}
 		}
 		if (j == ARRAY_SIZE(option_names)) {
-			uds_log_warning("dump option name '%s' unknown", argv[i]);
+			vdo_log_warning("dump option name '%s' unknown", argv[i]);
 			options_okay = false;
 		}
 	}
@@ -159,13 +159,13 @@ static void dump_vio_waiters(struct vdo_wait_queue *waitq, char *wait_on)
 
 	data_vio = vdo_waiter_as_data_vio(first);
 
-	uds_log_info("      %s is locked. Waited on by: vio %px pbn %llu lbn %llu d-pbn %llu lastOp %s",
+	vdo_log_info("      %s is locked. Waited on by: vio %px pbn %llu lbn %llu d-pbn %llu lastOp %s",
 		     wait_on, data_vio, data_vio->allocation.pbn, data_vio->logical.lbn,
 		     data_vio->duplicate.pbn, get_data_vio_operation_name(data_vio));
 
 	for (waiter = first->next_waiter; waiter != first; waiter = waiter->next_waiter) {
 		data_vio = vdo_waiter_as_data_vio(waiter);
-		uds_log_info("     ... and : vio %px pbn %llu lbn %llu d-pbn %llu lastOp %s",
+		vdo_log_info("     ... and : vio %px pbn %llu lbn %llu d-pbn %llu lastOp %s",
 			     data_vio, data_vio->allocation.pbn, data_vio->logical.lbn,
 			     data_vio->duplicate.pbn,
 			     get_data_vio_operation_name(data_vio));
@@ -258,7 +258,7 @@ void dump_data_vio(void *data)
 
 	encode_vio_dump_flags(data_vio, flags_dump_buffer);
 
-	uds_log_info("	vio %px %s%s %s %s%s", data_vio,
+	vdo_log_info("	vio %px %s%s %s %s%s", data_vio,
 		     vio_block_number_dump_buffer,
 		     vio_flush_generation_buffer,
 		     get_data_vio_operation_name(data_vio),
diff --git a/drivers/md/dm-vdo/encodings.c b/drivers/md/dm-vdo/encodings.c
index ebb0a4edd109..a34ea0229d53 100644
--- a/drivers/md/dm-vdo/encodings.c
+++ b/drivers/md/dm-vdo/encodings.c
@@ -146,7 +146,7 @@ static int __must_check validate_version(struct version_number expected_version,
 					 const char *component_name)
 {
 	if (!vdo_are_same_version(expected_version, actual_version)) {
-		return uds_log_error_strerror(VDO_UNSUPPORTED_VERSION,
+		return vdo_log_error_strerror(VDO_UNSUPPORTED_VERSION,
 					      "%s version mismatch, expected %d.%d, got %d.%d",
 					      component_name,
 					      expected_version.major_version,
@@ -179,7 +179,7 @@ int vdo_validate_header(const struct header *expected_header,
 	int result;
 
 	if (expected_header->id != actual_header->id) {
-		return uds_log_error_strerror(VDO_INCORRECT_COMPONENT,
+		return vdo_log_error_strerror(VDO_INCORRECT_COMPONENT,
 					      "%s ID mismatch, expected %d, got %d",
 					      name, expected_header->id,
 					      actual_header->id);
@@ -192,7 +192,7 @@ int vdo_validate_header(const struct header *expected_header,
 
 	if ((expected_header->size > actual_header->size) ||
 	    (exact_size && (expected_header->size < actual_header->size))) {
-		return uds_log_error_strerror(VDO_UNSUPPORTED_VERSION,
+		return vdo_log_error_strerror(VDO_UNSUPPORTED_VERSION,
 					      "%s size mismatch, expected %zu, got %zu",
 					      name, expected_header->size,
 					      actual_header->size);
@@ -653,7 +653,7 @@ int vdo_configure_slab_depot(const struct partition *partition,
 	physical_block_number_t last_block;
 	block_count_t slab_size = slab_config.slab_blocks;
 
-	uds_log_debug("slabDepot %s(block_count=%llu, first_block=%llu, slab_size=%llu, zone_count=%u)",
+	vdo_log_debug("slabDepot %s(block_count=%llu, first_block=%llu, slab_size=%llu, zone_count=%u)",
 		      __func__, (unsigned long long) partition->count,
 		      (unsigned long long) partition->offset,
 		      (unsigned long long) slab_size, zone_count);
@@ -677,7 +677,7 @@ int vdo_configure_slab_depot(const struct partition *partition,
 		.zone_count = zone_count,
 	};
 
-	uds_log_debug("slab_depot last_block=%llu, total_data_blocks=%llu, slab_count=%zu, left_over=%llu",
+	vdo_log_debug("slab_depot last_block=%llu, total_data_blocks=%llu, slab_count=%zu, left_over=%llu",
 		      (unsigned long long) last_block,
 		      (unsigned long long) total_data_blocks, slab_count,
 		      (unsigned long long) (partition->count - (last_block - partition->offset)));
@@ -875,7 +875,7 @@ int vdo_initialize_layout(block_count_t size, physical_block_number_t offset,
 		(offset + block_map_blocks + journal_blocks + summary_blocks);
 
 	if (necessary_size > size)
-		return uds_log_error_strerror(VDO_NO_SPACE,
+		return vdo_log_error_strerror(VDO_NO_SPACE,
 					      "Not enough space to make a VDO");
 
 	*layout = (struct layout) {
@@ -1045,7 +1045,7 @@ static int decode_layout(u8 *buffer, size_t *offset, physical_block_number_t sta
 	layout->num_partitions = layout_header.partition_count;
 
 	if (layout->num_partitions > VDO_PARTITION_COUNT) {
-		return uds_log_error_strerror(VDO_UNKNOWN_PARTITION,
+		return vdo_log_error_strerror(VDO_UNKNOWN_PARTITION,
 					      "layout has extra partitions");
 	}
 
@@ -1070,7 +1070,7 @@ static int decode_layout(u8 *buffer, size_t *offset, physical_block_number_t sta
 		result = vdo_get_partition(layout, REQUIRED_PARTITIONS[i], &partition);
 		if (result != VDO_SUCCESS) {
 			vdo_uninitialize_layout(layout);
-			return uds_log_error_strerror(result,
+			return vdo_log_error_strerror(result,
 						      "layout is missing required partition %u",
 						      REQUIRED_PARTITIONS[i]);
 		}
@@ -1080,7 +1080,7 @@ static int decode_layout(u8 *buffer, size_t *offset, physical_block_number_t sta
 
 	if (start != size) {
 		vdo_uninitialize_layout(layout);
-		return uds_log_error_strerror(UDS_BAD_STATE,
+		return vdo_log_error_strerror(UDS_BAD_STATE,
 					      "partitions do not cover the layout");
 	}
 
@@ -1253,7 +1253,7 @@ int vdo_validate_config(const struct vdo_config *config,
 		return VDO_OUT_OF_RANGE;
 
 	if (physical_block_count != config->physical_blocks) {
-		uds_log_error("A physical size of %llu blocks was specified, not the %llu blocks configured in the vdo super block",
+		vdo_log_error("A physical size of %llu blocks was specified, not the %llu blocks configured in the vdo super block",
 			      (unsigned long long) physical_block_count,
 			      (unsigned long long) config->physical_blocks);
 		return VDO_PARAMETER_MISMATCH;
@@ -1266,7 +1266,7 @@ int vdo_validate_config(const struct vdo_config *config,
 			return result;
 
 		if (logical_block_count != config->logical_blocks) {
-			uds_log_error("A logical size of %llu blocks was specified, but that differs from the %llu blocks configured in the vdo super block",
+			vdo_log_error("A logical size of %llu blocks was specified, but that differs from the %llu blocks configured in the vdo super block",
 				      (unsigned long long) logical_block_count,
 				      (unsigned long long) config->logical_blocks);
 			return VDO_PARAMETER_MISMATCH;
@@ -1390,7 +1390,7 @@ int vdo_validate_component_states(struct vdo_component_states *states,
 				  block_count_t logical_size)
 {
 	if (geometry_nonce != states->vdo.nonce) {
-		return uds_log_error_strerror(VDO_BAD_NONCE,
+		return vdo_log_error_strerror(VDO_BAD_NONCE,
 					      "Geometry nonce %llu does not match superblock nonce %llu",
 					      (unsigned long long) geometry_nonce,
 					      (unsigned long long) states->vdo.nonce);
@@ -1463,7 +1463,7 @@ int vdo_decode_super_block(u8 *buffer)
 		 * We can't check release version or checksum until we know the content size, so we
 		 * have to assume a version mismatch on unexpected values.
 		 */
-		return uds_log_error_strerror(VDO_UNSUPPORTED_VERSION,
+		return vdo_log_error_strerror(VDO_UNSUPPORTED_VERSION,
 					      "super block contents too large: %zu",
 					      header.size);
 	}
diff --git a/drivers/md/dm-vdo/errors.c b/drivers/md/dm-vdo/errors.c
index 3b5fddad8ddf..8b2d22381274 100644
--- a/drivers/md/dm-vdo/errors.c
+++ b/drivers/md/dm-vdo/errors.c
@@ -215,8 +215,8 @@ const char *uds_string_error_name(int errnum, char *buf, size_t buflen)
  */
 int uds_status_to_errno(int error)
 {
-	char error_name[UDS_MAX_ERROR_NAME_SIZE];
-	char error_message[UDS_MAX_ERROR_MESSAGE_SIZE];
+	char error_name[VDO_MAX_ERROR_NAME_SIZE];
+	char error_message[VDO_MAX_ERROR_MESSAGE_SIZE];
 
 	/* 0 is success, and negative values are already system error codes. */
 	if (likely(error <= 0))
@@ -248,7 +248,7 @@ int uds_status_to_errno(int error)
 
 	default:
 		/* Translate an unexpected error into something generic. */
-		uds_log_info("%s: mapping status code %d (%s: %s) to -EIO",
+		vdo_log_info("%s: mapping status code %d (%s: %s) to -EIO",
 			     __func__, error,
 			     uds_string_error_name(error, error_name,
 						   sizeof(error_name)),
diff --git a/drivers/md/dm-vdo/errors.h b/drivers/md/dm-vdo/errors.h
index c6c085b26a0e..24e0e745fd5f 100644
--- a/drivers/md/dm-vdo/errors.h
+++ b/drivers/md/dm-vdo/errors.h
@@ -51,8 +51,8 @@ enum uds_status_codes {
 };
 
 enum {
-	UDS_MAX_ERROR_NAME_SIZE = 80,
-	UDS_MAX_ERROR_MESSAGE_SIZE = 128,
+	VDO_MAX_ERROR_NAME_SIZE = 80,
+	VDO_MAX_ERROR_MESSAGE_SIZE = 128,
 };
 
 struct error_info {
diff --git a/drivers/md/dm-vdo/flush.c b/drivers/md/dm-vdo/flush.c
index e03679e4d1ba..57e87f0d7069 100644
--- a/drivers/md/dm-vdo/flush.c
+++ b/drivers/md/dm-vdo/flush.c
@@ -108,7 +108,7 @@ static void *allocate_flush(gfp_t gfp_mask, void *pool_data)
 		int result = vdo_allocate(1, struct vdo_flush, __func__, &flush);
 
 		if (result != VDO_SUCCESS)
-			uds_log_error_strerror(result, "failed to allocate spare flush");
+			vdo_log_error_strerror(result, "failed to allocate spare flush");
 	}
 
 	if (flush != NULL) {
@@ -349,11 +349,11 @@ void vdo_complete_flushes(struct flusher *flusher)
  */
 void vdo_dump_flusher(const struct flusher *flusher)
 {
-	uds_log_info("struct flusher");
-	uds_log_info("  flush_generation=%llu first_unacknowledged_generation=%llu",
+	vdo_log_info("struct flusher");
+	vdo_log_info("  flush_generation=%llu first_unacknowledged_generation=%llu",
 		     (unsigned long long) flusher->flush_generation,
 		     (unsigned long long) flusher->first_unacknowledged_generation);
-	uds_log_info("  notifiers queue is %s; pending_flushes queue is %s",
+	vdo_log_info("  notifiers queue is %s; pending_flushes queue is %s",
 		     (vdo_waitq_has_waiters(&flusher->notifiers) ? "not empty" : "empty"),
 		     (vdo_waitq_has_waiters(&flusher->pending_flushes) ? "not empty" : "empty"));
 }
diff --git a/drivers/md/dm-vdo/funnel-workqueue.c b/drivers/md/dm-vdo/funnel-workqueue.c
index cf04cdef0750..ae11941c90a9 100644
--- a/drivers/md/dm-vdo/funnel-workqueue.c
+++ b/drivers/md/dm-vdo/funnel-workqueue.c
@@ -485,7 +485,7 @@ static void dump_simple_work_queue(struct simple_work_queue *queue)
 		thread_status = atomic_read(&queue->idle) ? "idle" : "running";
 	}
 
-	uds_log_info("workQ %px (%s) %s (%c)", &queue->common, queue->common.name,
+	vdo_log_info("workQ %px (%s) %s (%c)", &queue->common, queue->common.name,
 		     thread_status, task_state_report);
 
 	/* ->waiting_worker_threads wait queue status? anyone waiting? */
diff --git a/drivers/md/dm-vdo/indexer/chapter-index.c b/drivers/md/dm-vdo/indexer/chapter-index.c
index 47e4ed234242..7e32a25d3f2f 100644
--- a/drivers/md/dm-vdo/indexer/chapter-index.c
+++ b/drivers/md/dm-vdo/indexer/chapter-index.c
@@ -166,7 +166,7 @@ int uds_pack_open_chapter_index_page(struct open_chapter_index *chapter_index,
 
 		if (removals == 0) {
 			uds_get_delta_index_stats(delta_index, &stats);
-			uds_log_warning("The chapter index for chapter %llu contains %llu entries with %llu collisions",
+			vdo_log_warning("The chapter index for chapter %llu contains %llu entries with %llu collisions",
 					(unsigned long long) chapter_number,
 					(unsigned long long) stats.record_count,
 					(unsigned long long) stats.collision_count);
@@ -198,7 +198,7 @@ int uds_pack_open_chapter_index_page(struct open_chapter_index *chapter_index,
 	}
 
 	if (removals > 0) {
-		uds_log_warning("To avoid chapter index page overflow in chapter %llu, %u entries were removed from the chapter index",
+		vdo_log_warning("To avoid chapter index page overflow in chapter %llu, %u entries were removed from the chapter index",
 				(unsigned long long) chapter_number, removals);
 	}
 
diff --git a/drivers/md/dm-vdo/indexer/config.c b/drivers/md/dm-vdo/indexer/config.c
index 69bf27a9d61b..5532371b952f 100644
--- a/drivers/md/dm-vdo/indexer/config.c
+++ b/drivers/md/dm-vdo/indexer/config.c
@@ -33,54 +33,54 @@ static bool are_matching_configurations(struct uds_configuration *saved_config,
 	bool result = true;
 
 	if (saved_geometry->record_pages_per_chapter != geometry->record_pages_per_chapter) {
-		uds_log_error("Record pages per chapter (%u) does not match (%u)",
+		vdo_log_error("Record pages per chapter (%u) does not match (%u)",
 			      saved_geometry->record_pages_per_chapter,
 			      geometry->record_pages_per_chapter);
 		result = false;
 	}
 
 	if (saved_geometry->chapters_per_volume != geometry->chapters_per_volume) {
-		uds_log_error("Chapter count (%u) does not match (%u)",
+		vdo_log_error("Chapter count (%u) does not match (%u)",
 			      saved_geometry->chapters_per_volume,
 			      geometry->chapters_per_volume);
 		result = false;
 	}
 
 	if (saved_geometry->sparse_chapters_per_volume != geometry->sparse_chapters_per_volume) {
-		uds_log_error("Sparse chapter count (%u) does not match (%u)",
+		vdo_log_error("Sparse chapter count (%u) does not match (%u)",
 			      saved_geometry->sparse_chapters_per_volume,
 			      geometry->sparse_chapters_per_volume);
 		result = false;
 	}
 
 	if (saved_config->cache_chapters != user->cache_chapters) {
-		uds_log_error("Cache size (%u) does not match (%u)",
+		vdo_log_error("Cache size (%u) does not match (%u)",
 			      saved_config->cache_chapters, user->cache_chapters);
 		result = false;
 	}
 
 	if (saved_config->volume_index_mean_delta != user->volume_index_mean_delta) {
-		uds_log_error("Volume index mean delta (%u) does not match (%u)",
+		vdo_log_error("Volume index mean delta (%u) does not match (%u)",
 			      saved_config->volume_index_mean_delta,
 			      user->volume_index_mean_delta);
 		result = false;
 	}
 
 	if (saved_geometry->bytes_per_page != geometry->bytes_per_page) {
-		uds_log_error("Bytes per page value (%zu) does not match (%zu)",
+		vdo_log_error("Bytes per page value (%zu) does not match (%zu)",
 			      saved_geometry->bytes_per_page, geometry->bytes_per_page);
 		result = false;
 	}
 
 	if (saved_config->sparse_sample_rate != user->sparse_sample_rate) {
-		uds_log_error("Sparse sample rate (%u) does not match (%u)",
+		vdo_log_error("Sparse sample rate (%u) does not match (%u)",
 			      saved_config->sparse_sample_rate,
 			      user->sparse_sample_rate);
 		result = false;
 	}
 
 	if (saved_config->nonce != user->nonce) {
-		uds_log_error("Nonce (%llu) does not match (%llu)",
+		vdo_log_error("Nonce (%llu) does not match (%llu)",
 			      (unsigned long long) saved_config->nonce,
 			      (unsigned long long) user->nonce);
 		result = false;
@@ -109,11 +109,11 @@ int uds_validate_config_contents(struct buffered_reader *reader,
 	result = uds_read_from_buffered_reader(reader, version_buffer,
 					       INDEX_CONFIG_VERSION_LENGTH);
 	if (result != UDS_SUCCESS)
-		return uds_log_error_strerror(result, "cannot read index config version");
+		return vdo_log_error_strerror(result, "cannot read index config version");
 
 	if (!is_version(INDEX_CONFIG_VERSION_6_02, version_buffer) &&
 	    !is_version(INDEX_CONFIG_VERSION_8_02, version_buffer)) {
-		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+		return vdo_log_error_strerror(UDS_CORRUPT_DATA,
 					      "unsupported configuration version: '%.*s'",
 					      INDEX_CONFIG_VERSION_LENGTH,
 					      version_buffer);
@@ -121,7 +121,7 @@ int uds_validate_config_contents(struct buffered_reader *reader,
 
 	result = uds_read_from_buffered_reader(reader, buffer, sizeof(buffer));
 	if (result != UDS_SUCCESS)
-		return uds_log_error_strerror(result, "cannot read config data");
+		return vdo_log_error_strerror(result, "cannot read config data");
 
 	decode_u32_le(buffer, &offset, &geometry.record_pages_per_chapter);
 	decode_u32_le(buffer, &offset, &geometry.chapters_per_volume);
@@ -149,7 +149,7 @@ int uds_validate_config_contents(struct buffered_reader *reader,
 		result = uds_read_from_buffered_reader(reader, remapping,
 						       sizeof(remapping));
 		if (result != UDS_SUCCESS)
-			return uds_log_error_strerror(result, "cannot read converted config");
+			return vdo_log_error_strerror(result, "cannot read converted config");
 
 		offset = 0;
 		decode_u64_le(remapping, &offset,
@@ -159,7 +159,7 @@ int uds_validate_config_contents(struct buffered_reader *reader,
 	}
 
 	if (!are_matching_configurations(&config, &geometry, user_config)) {
-		uds_log_warning("Supplied configuration does not match save");
+		vdo_log_warning("Supplied configuration does not match save");
 		return UDS_NO_INDEX;
 	}
 
@@ -263,7 +263,7 @@ static int compute_memory_sizes(uds_memory_config_size_t mem_gb, bool sparse,
 				 DEFAULT_CHAPTERS_PER_VOLUME);
 		*record_pages_per_chapter = DEFAULT_RECORD_PAGES_PER_CHAPTER;
 	} else {
-		uds_log_error("received invalid memory size");
+		vdo_log_error("received invalid memory size");
 		return -EINVAL;
 	}
 
@@ -292,7 +292,7 @@ static unsigned int __must_check normalize_zone_count(unsigned int requested)
 	if (zone_count > MAX_ZONES)
 		zone_count = MAX_ZONES;
 
-	uds_log_info("Using %u indexing zone%s for concurrency.",
+	vdo_log_info("Using %u indexing zone%s for concurrency.",
 		     zone_count, zone_count == 1 ? "" : "s");
 	return zone_count;
 }
@@ -364,13 +364,13 @@ void uds_log_configuration(struct uds_configuration *config)
 {
 	struct index_geometry *geometry = config->geometry;
 
-	uds_log_debug("Configuration:");
-	uds_log_debug("  Record pages per chapter:   %10u", geometry->record_pages_per_chapter);
-	uds_log_debug("  Chapters per volume:        %10u", geometry->chapters_per_volume);
-	uds_log_debug("  Sparse chapters per volume: %10u", geometry->sparse_chapters_per_volume);
-	uds_log_debug("  Cache size (chapters):      %10u", config->cache_chapters);
-	uds_log_debug("  Volume index mean delta:    %10u", config->volume_index_mean_delta);
-	uds_log_debug("  Bytes per page:             %10zu", geometry->bytes_per_page);
-	uds_log_debug("  Sparse sample rate:         %10u", config->sparse_sample_rate);
-	uds_log_debug("  Nonce:                      %llu", (unsigned long long) config->nonce);
+	vdo_log_debug("Configuration:");
+	vdo_log_debug("  Record pages per chapter:   %10u", geometry->record_pages_per_chapter);
+	vdo_log_debug("  Chapters per volume:        %10u", geometry->chapters_per_volume);
+	vdo_log_debug("  Sparse chapters per volume: %10u", geometry->sparse_chapters_per_volume);
+	vdo_log_debug("  Cache size (chapters):      %10u", config->cache_chapters);
+	vdo_log_debug("  Volume index mean delta:    %10u", config->volume_index_mean_delta);
+	vdo_log_debug("  Bytes per page:             %10zu", geometry->bytes_per_page);
+	vdo_log_debug("  Sparse sample rate:         %10u", config->sparse_sample_rate);
+	vdo_log_debug("  Nonce:                      %llu", (unsigned long long) config->nonce);
 }
diff --git a/drivers/md/dm-vdo/indexer/delta-index.c b/drivers/md/dm-vdo/indexer/delta-index.c
index b49066554248..0ac2443f0df3 100644
--- a/drivers/md/dm-vdo/indexer/delta-index.c
+++ b/drivers/md/dm-vdo/indexer/delta-index.c
@@ -375,7 +375,7 @@ int uds_initialize_delta_index(struct delta_index *delta_index, unsigned int zon
 			 */
 			if (delta_index->list_count <= first_list_in_zone) {
 				uds_uninitialize_delta_index(delta_index);
-				return uds_log_error_strerror(UDS_INVALID_ARGUMENT,
+				return vdo_log_error_strerror(UDS_INVALID_ARGUMENT,
 							      "%u delta lists not enough for %u zones",
 							      list_count, zone_count);
 			}
@@ -732,7 +732,7 @@ int uds_pack_delta_index_page(const struct delta_index *delta_index, u64 header_
 	free_bits -= GUARD_BITS;
 	if (free_bits < IMMUTABLE_HEADER_SIZE) {
 		/* This page is too small to store any delta lists. */
-		return uds_log_error_strerror(UDS_OVERFLOW,
+		return vdo_log_error_strerror(UDS_OVERFLOW,
 					      "Chapter Index Page of %zu bytes is too small",
 					      memory_size);
 	}
@@ -843,7 +843,7 @@ int uds_start_restoring_delta_index(struct delta_index *delta_index,
 		result = uds_read_from_buffered_reader(buffered_readers[z], buffer,
 						       sizeof(buffer));
 		if (result != UDS_SUCCESS) {
-			return uds_log_warning_strerror(result,
+			return vdo_log_warning_strerror(result,
 							"failed to read delta index header");
 		}
 
@@ -860,23 +860,23 @@ int uds_start_restoring_delta_index(struct delta_index *delta_index,
 				    "%zu bytes decoded of %zu expected", offset,
 				    sizeof(struct delta_index_header));
 		if (result != VDO_SUCCESS) {
-			return uds_log_warning_strerror(result,
+			return vdo_log_warning_strerror(result,
 							"failed to read delta index header");
 		}
 
 		if (memcmp(header.magic, DELTA_INDEX_MAGIC, MAGIC_SIZE) != 0) {
-			return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+			return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
 							"delta index file has bad magic number");
 		}
 
 		if (zone_count != header.zone_count) {
-			return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+			return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
 							"delta index files contain mismatched zone counts (%u,%u)",
 							zone_count, header.zone_count);
 		}
 
 		if (header.zone_number != z) {
-			return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+			return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
 							"delta index zone %u found in slot %u",
 							header.zone_number, z);
 		}
@@ -887,7 +887,7 @@ int uds_start_restoring_delta_index(struct delta_index *delta_index,
 		collision_count += header.collision_count;
 
 		if (first_list[z] != list_next) {
-			return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+			return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
 							"delta index file for zone %u starts with list %u instead of list %u",
 							z, first_list[z], list_next);
 		}
@@ -896,13 +896,13 @@ int uds_start_restoring_delta_index(struct delta_index *delta_index,
 	}
 
 	if (list_next != delta_index->list_count) {
-		return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+		return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
 						"delta index files contain %u delta lists instead of %u delta lists",
 						list_next, delta_index->list_count);
 	}
 
 	if (collision_count > record_count) {
-		return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+		return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
 						"delta index files contain %llu collisions and %llu records",
 						(unsigned long long) collision_count,
 						(unsigned long long) record_count);
@@ -927,7 +927,7 @@ int uds_start_restoring_delta_index(struct delta_index *delta_index,
 							       size_data,
 							       sizeof(size_data));
 			if (result != UDS_SUCCESS) {
-				return uds_log_warning_strerror(result,
+				return vdo_log_warning_strerror(result,
 								"failed to read delta index size");
 			}
 
@@ -960,7 +960,7 @@ static int restore_delta_list_to_zone(struct delta_zone *delta_zone,
 	u32 list_number = save_info->index - delta_zone->first_list;
 
 	if (list_number >= delta_zone->list_count) {
-		return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+		return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
 						"invalid delta list number %u not in range [%u,%u)",
 						save_info->index, delta_zone->first_list,
 						delta_zone->first_list + delta_zone->list_count);
@@ -968,7 +968,7 @@ static int restore_delta_list_to_zone(struct delta_zone *delta_zone,
 
 	delta_list = &delta_zone->delta_lists[list_number + 1];
 	if (delta_list->size == 0) {
-		return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+		return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
 						"unexpected delta list number %u",
 						save_info->index);
 	}
@@ -976,7 +976,7 @@ static int restore_delta_list_to_zone(struct delta_zone *delta_zone,
 	bit_count = delta_list->size + save_info->bit_offset;
 	byte_count = BITS_TO_BYTES(bit_count);
 	if (save_info->byte_count != byte_count) {
-		return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+		return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
 						"unexpected delta list size %u != %u",
 						save_info->byte_count, byte_count);
 	}
@@ -996,7 +996,7 @@ static int restore_delta_list_data(struct delta_index *delta_index, unsigned int
 
 	result = uds_read_from_buffered_reader(buffered_reader, buffer, sizeof(buffer));
 	if (result != UDS_SUCCESS) {
-		return uds_log_warning_strerror(result,
+		return vdo_log_warning_strerror(result,
 						"failed to read delta list data");
 	}
 
@@ -1009,7 +1009,7 @@ static int restore_delta_list_data(struct delta_index *delta_index, unsigned int
 
 	if ((save_info.bit_offset >= BITS_PER_BYTE) ||
 	    (save_info.byte_count > DELTA_LIST_MAX_BYTE_COUNT)) {
-		return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+		return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
 						"corrupt delta list data");
 	}
 
@@ -1018,7 +1018,7 @@ static int restore_delta_list_data(struct delta_index *delta_index, unsigned int
 		return UDS_CORRUPT_DATA;
 
 	if (save_info.index >= delta_index->list_count) {
-		return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+		return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
 						"invalid delta list number %u of %u",
 						save_info.index,
 						delta_index->list_count);
@@ -1027,7 +1027,7 @@ static int restore_delta_list_data(struct delta_index *delta_index, unsigned int
 	result = uds_read_from_buffered_reader(buffered_reader, data,
 					       save_info.byte_count);
 	if (result != UDS_SUCCESS) {
-		return uds_log_warning_strerror(result,
+		return vdo_log_warning_strerror(result,
 						"failed to read delta list data");
 	}
 
@@ -1102,7 +1102,7 @@ static int flush_delta_list(struct delta_zone *zone, u32 flush_index)
 	result = uds_write_to_buffered_writer(zone->buffered_writer, buffer,
 					      sizeof(buffer));
 	if (result != UDS_SUCCESS) {
-		uds_log_warning_strerror(result, "failed to write delta list memory");
+		vdo_log_warning_strerror(result, "failed to write delta list memory");
 		return result;
 	}
 
@@ -1110,7 +1110,7 @@ static int flush_delta_list(struct delta_zone *zone, u32 flush_index)
 					      zone->memory + get_delta_list_byte_start(delta_list),
 					      get_delta_list_byte_size(delta_list));
 	if (result != UDS_SUCCESS)
-		uds_log_warning_strerror(result, "failed to write delta list memory");
+		vdo_log_warning_strerror(result, "failed to write delta list memory");
 
 	return result;
 }
@@ -1144,7 +1144,7 @@ int uds_start_saving_delta_index(const struct delta_index *delta_index,
 
 	result = uds_write_to_buffered_writer(buffered_writer, buffer, offset);
 	if (result != UDS_SUCCESS)
-		return uds_log_warning_strerror(result,
+		return vdo_log_warning_strerror(result,
 						"failed to write delta index header");
 
 	for (i = 0; i < delta_zone->list_count; i++) {
@@ -1156,7 +1156,7 @@ int uds_start_saving_delta_index(const struct delta_index *delta_index,
 		result = uds_write_to_buffered_writer(buffered_writer, data,
 						      sizeof(data));
 		if (result != UDS_SUCCESS)
-			return uds_log_warning_strerror(result,
+			return vdo_log_warning_strerror(result,
 							"failed to write delta list size");
 	}
 
@@ -1197,7 +1197,7 @@ int uds_write_guard_delta_list(struct buffered_writer *buffered_writer)
 
 	result = uds_write_to_buffered_writer(buffered_writer, buffer, sizeof(buffer));
 	if (result != UDS_SUCCESS)
-		uds_log_warning_strerror(result, "failed to write guard delta list");
+		vdo_log_warning_strerror(result, "failed to write guard delta list");
 
 	return UDS_SUCCESS;
 }
@@ -1378,7 +1378,7 @@ noinline int uds_next_delta_index_entry(struct delta_index_entry *delta_entry)
 		 * This is not an assertion because uds_validate_chapter_index_page() wants to
 		 * handle this error.
 		 */
-		uds_log_warning("Decoded past the end of the delta list");
+		vdo_log_warning("Decoded past the end of the delta list");
 		return UDS_CORRUPT_DATA;
 	}
 
@@ -1959,7 +1959,7 @@ u32 uds_get_delta_index_page_count(u32 entry_count, u32 list_count, u32 mean_del
 
 void uds_log_delta_index_entry(struct delta_index_entry *delta_entry)
 {
-	uds_log_ratelimit(uds_log_info,
+	vdo_log_ratelimit(vdo_log_info,
 			  "List 0x%X Key 0x%X Offset 0x%X%s%s List_size 0x%X%s",
 			  delta_entry->list_number, delta_entry->key,
 			  delta_entry->offset, delta_entry->at_end ? " end" : "",
diff --git a/drivers/md/dm-vdo/indexer/index-layout.c b/drivers/md/dm-vdo/indexer/index-layout.c
index 74fd44c20e5c..627adc24af3b 100644
--- a/drivers/md/dm-vdo/indexer/index-layout.c
+++ b/drivers/md/dm-vdo/indexer/index-layout.c
@@ -231,7 +231,7 @@ static int __must_check compute_sizes(const struct uds_configuration *config,
 	result = uds_compute_volume_index_save_blocks(config, sls->block_size,
 						      &sls->volume_index_blocks);
 	if (result != UDS_SUCCESS)
-		return uds_log_error_strerror(result, "cannot compute index save size");
+		return vdo_log_error_strerror(result, "cannot compute index save size");
 
 	sls->page_map_blocks =
 		DIV_ROUND_UP(uds_compute_index_page_map_save_size(geometry),
@@ -255,13 +255,13 @@ int uds_compute_index_size(const struct uds_parameters *parameters, u64 *index_s
 	struct save_layout_sizes sizes;
 
 	if (index_size == NULL) {
-		uds_log_error("Missing output size pointer");
+		vdo_log_error("Missing output size pointer");
 		return -EINVAL;
 	}
 
 	result = uds_make_configuration(parameters, &index_config);
 	if (result != UDS_SUCCESS) {
-		uds_log_error_strerror(result, "cannot compute index size");
+		vdo_log_error_strerror(result, "cannot compute index size");
 		return uds_status_to_errno(result);
 	}
 
@@ -648,7 +648,7 @@ static int discard_index_state_data(struct index_layout *layout)
 	}
 
 	if (saved_result != UDS_SUCCESS) {
-		return uds_log_error_strerror(result,
+		return vdo_log_error_strerror(result,
 					      "%s: cannot destroy all index saves",
 					      __func__);
 	}
@@ -755,18 +755,18 @@ static int __must_check write_uds_index_config(struct index_layout *layout,
 
 	result = open_layout_writer(layout, &layout->config, offset, &writer);
 	if (result != UDS_SUCCESS)
-		return uds_log_error_strerror(result, "failed to open config region");
+		return vdo_log_error_strerror(result, "failed to open config region");
 
 	result = uds_write_config_contents(writer, config, layout->super.version);
 	if (result != UDS_SUCCESS) {
 		uds_free_buffered_writer(writer);
-		return uds_log_error_strerror(result, "failed to write config region");
+		return vdo_log_error_strerror(result, "failed to write config region");
 	}
 
 	result = uds_flush_buffered_writer(writer);
 	if (result != UDS_SUCCESS) {
 		uds_free_buffered_writer(writer);
-		return uds_log_error_strerror(result, "cannot flush config writer");
+		return vdo_log_error_strerror(result, "cannot flush config writer");
 	}
 
 	uds_free_buffered_writer(writer);
@@ -873,7 +873,7 @@ static int find_latest_uds_index_save_slot(struct index_layout *layout,
 	}
 
 	if (latest == NULL) {
-		uds_log_error("No valid index save found");
+		vdo_log_error("No valid index save found");
 		return UDS_INDEX_NOT_SAVED_CLEANLY;
 	}
 
@@ -1145,7 +1145,7 @@ static int __must_check load_region_table(struct buffered_reader *reader,
 
 	result = uds_read_from_buffered_reader(reader, buffer, sizeof(buffer));
 	if (result != UDS_SUCCESS)
-		return uds_log_error_strerror(result, "cannot read region table header");
+		return vdo_log_error_strerror(result, "cannot read region table header");
 
 	decode_u64_le(buffer, &offset, &header.magic);
 	decode_u64_le(buffer, &offset, &header.region_blocks);
@@ -1158,7 +1158,7 @@ static int __must_check load_region_table(struct buffered_reader *reader,
 		return UDS_NO_INDEX;
 
 	if (header.version != 1) {
-		return uds_log_error_strerror(UDS_UNSUPPORTED_VERSION,
+		return vdo_log_error_strerror(UDS_UNSUPPORTED_VERSION,
 					      "unknown region table version %hu",
 					      header.version);
 	}
@@ -1178,7 +1178,7 @@ static int __must_check load_region_table(struct buffered_reader *reader,
 						       sizeof(region_buffer));
 		if (result != UDS_SUCCESS) {
 			vdo_free(table);
-			return uds_log_error_strerror(UDS_CORRUPT_DATA,
+			return vdo_log_error_strerror(UDS_CORRUPT_DATA,
 						      "cannot read region table layouts");
 		}
 
@@ -1209,7 +1209,7 @@ static int __must_check read_super_block_data(struct buffered_reader *reader,
 	result = uds_read_from_buffered_reader(reader, buffer, saved_size);
 	if (result != UDS_SUCCESS) {
 		vdo_free(buffer);
-		return uds_log_error_strerror(result, "cannot read region table header");
+		return vdo_log_error_strerror(result, "cannot read region table header");
 	}
 
 	memcpy(&super->magic_label, buffer, MAGIC_SIZE);
@@ -1236,19 +1236,19 @@ static int __must_check read_super_block_data(struct buffered_reader *reader,
 	vdo_free(buffer);
 
 	if (memcmp(super->magic_label, LAYOUT_MAGIC, MAGIC_SIZE) != 0)
-		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+		return vdo_log_error_strerror(UDS_CORRUPT_DATA,
 					      "unknown superblock magic label");
 
 	if ((super->version < SUPER_VERSION_MINIMUM) ||
 	    (super->version == 4) || (super->version == 5) || (super->version == 6) ||
 	    (super->version > SUPER_VERSION_MAXIMUM)) {
-		return uds_log_error_strerror(UDS_UNSUPPORTED_VERSION,
+		return vdo_log_error_strerror(UDS_UNSUPPORTED_VERSION,
 					      "unknown superblock version number %u",
 					      super->version);
 	}
 
 	if (super->volume_offset < super->start_offset) {
-		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+		return vdo_log_error_strerror(UDS_CORRUPT_DATA,
 					      "inconsistent offsets (start %llu, volume %llu)",
 					      (unsigned long long) super->start_offset,
 					      (unsigned long long) super->volume_offset);
@@ -1256,13 +1256,13 @@ static int __must_check read_super_block_data(struct buffered_reader *reader,
 
 	/* Sub-indexes are no longer used but the layout retains this field. */
 	if (super->index_count != 1) {
-		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+		return vdo_log_error_strerror(UDS_CORRUPT_DATA,
 					      "invalid subindex count %u",
 					      super->index_count);
 	}
 
 	if (generate_primary_nonce(super->nonce_info, sizeof(super->nonce_info)) != super->nonce) {
-		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+		return vdo_log_error_strerror(UDS_CORRUPT_DATA,
 					      "inconsistent superblock nonce");
 	}
 
@@ -1273,15 +1273,15 @@ static int __must_check verify_region(struct layout_region *lr, u64 start_block,
 				      enum region_kind kind, unsigned int instance)
 {
 	if (lr->start_block != start_block)
-		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+		return vdo_log_error_strerror(UDS_CORRUPT_DATA,
 					      "incorrect layout region offset");
 
 	if (lr->kind != kind)
-		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+		return vdo_log_error_strerror(UDS_CORRUPT_DATA,
 					      "incorrect layout region kind");
 
 	if (lr->instance != instance) {
-		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+		return vdo_log_error_strerror(UDS_CORRUPT_DATA,
 					      "incorrect layout region instance");
 	}
 
@@ -1323,7 +1323,7 @@ static int __must_check verify_sub_index(struct index_layout *layout, u64 start_
 
 	next_block -= layout->super.volume_offset;
 	if (next_block != start_block + sil->sub_index.block_count) {
-		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+		return vdo_log_error_strerror(UDS_CORRUPT_DATA,
 					      "sub index region does not span all saves");
 	}
 
@@ -1368,7 +1368,7 @@ static int __must_check reconstitute_layout(struct index_layout *layout,
 		return result;
 
 	if (++next_block != (first_block + layout->total_blocks)) {
-		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+		return vdo_log_error_strerror(UDS_CORRUPT_DATA,
 					      "layout table does not span total blocks");
 	}
 
@@ -1388,19 +1388,19 @@ static int __must_check load_super_block(struct index_layout *layout, size_t blo
 
 	if (table->header.type != RH_TYPE_SUPER) {
 		vdo_free(table);
-		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+		return vdo_log_error_strerror(UDS_CORRUPT_DATA,
 					      "not a superblock region table");
 	}
 
 	result = read_super_block_data(reader, layout, table->header.payload);
 	if (result != UDS_SUCCESS) {
 		vdo_free(table);
-		return uds_log_error_strerror(result, "unknown superblock format");
+		return vdo_log_error_strerror(result, "unknown superblock format");
 	}
 
 	if (super->block_size != block_size) {
 		vdo_free(table);
-		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+		return vdo_log_error_strerror(UDS_CORRUPT_DATA,
 					      "superblock saved block_size %u differs from supplied block_size %zu",
 					      super->block_size, block_size);
 	}
@@ -1421,14 +1421,14 @@ static int __must_check read_index_save_data(struct buffered_reader *reader,
 	size_t offset = 0;
 
 	if (saved_size != sizeof(buffer)) {
-		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+		return vdo_log_error_strerror(UDS_CORRUPT_DATA,
 					      "unexpected index save data size %zu",
 					      saved_size);
 	}
 
 	result = uds_read_from_buffered_reader(reader, buffer, sizeof(buffer));
 	if (result != UDS_SUCCESS)
-		return uds_log_error_strerror(result, "cannot read index save data");
+		return vdo_log_error_strerror(result, "cannot read index save data");
 
 	decode_u64_le(buffer, &offset, &isl->save_data.timestamp);
 	decode_u64_le(buffer, &offset, &isl->save_data.nonce);
@@ -1436,7 +1436,7 @@ static int __must_check read_index_save_data(struct buffered_reader *reader,
 	offset += sizeof(u32);
 
 	if (isl->save_data.version > 1) {
-		return uds_log_error_strerror(UDS_UNSUPPORTED_VERSION,
+		return vdo_log_error_strerror(UDS_UNSUPPORTED_VERSION,
 					      "unknown index save version number %u",
 					      isl->save_data.version);
 	}
@@ -1446,7 +1446,7 @@ static int __must_check read_index_save_data(struct buffered_reader *reader,
 
 	if ((file_version.signature != INDEX_STATE_VERSION_301.signature) ||
 	    (file_version.version_id != INDEX_STATE_VERSION_301.version_id)) {
-		return uds_log_error_strerror(UDS_UNSUPPORTED_VERSION,
+		return vdo_log_error_strerror(UDS_UNSUPPORTED_VERSION,
 					      "index state version %d,%d is unsupported",
 					      file_version.signature,
 					      file_version.version_id);
@@ -1523,7 +1523,7 @@ static int __must_check reconstruct_index_save(struct index_save_layout *isl,
 
 	next_block += isl->free_space.block_count;
 	if (next_block != last_block) {
-		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+		return vdo_log_error_strerror(UDS_CORRUPT_DATA,
 					      "index save layout table incomplete");
 	}
 
@@ -1539,7 +1539,7 @@ static int __must_check load_index_save(struct index_save_layout *isl,
 
 	result = load_region_table(reader, &table);
 	if (result != UDS_SUCCESS) {
-		return uds_log_error_strerror(result, "cannot read index save %u header",
+		return vdo_log_error_strerror(result, "cannot read index save %u header",
 					      instance);
 	}
 
@@ -1547,7 +1547,7 @@ static int __must_check load_index_save(struct index_save_layout *isl,
 		u64 region_blocks = table->header.region_blocks;
 
 		vdo_free(table);
-		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+		return vdo_log_error_strerror(UDS_CORRUPT_DATA,
 					      "unexpected index save %u region block count %llu",
 					      instance,
 					      (unsigned long long) region_blocks);
@@ -1561,7 +1561,7 @@ static int __must_check load_index_save(struct index_save_layout *isl,
 
 
 	if (table->header.type != RH_TYPE_SAVE) {
-		uds_log_error_strerror(UDS_CORRUPT_DATA,
+		vdo_log_error_strerror(UDS_CORRUPT_DATA,
 				       "unexpected index save %u header type %u",
 				       instance, table->header.type);
 		vdo_free(table);
@@ -1571,7 +1571,7 @@ static int __must_check load_index_save(struct index_save_layout *isl,
 	result = read_index_save_data(reader, isl, table->header.payload);
 	if (result != UDS_SUCCESS) {
 		vdo_free(table);
-		return uds_log_error_strerror(result,
+		return vdo_log_error_strerror(result,
 					      "unknown index save %u data format",
 					      instance);
 	}
@@ -1579,7 +1579,7 @@ static int __must_check load_index_save(struct index_save_layout *isl,
 	result = reconstruct_index_save(isl, table);
 	vdo_free(table);
 	if (result != UDS_SUCCESS) {
-		return uds_log_error_strerror(result, "cannot reconstruct index save %u",
+		return vdo_log_error_strerror(result, "cannot reconstruct index save %u",
 					      instance);
 	}
 
@@ -1598,7 +1598,7 @@ static int __must_check load_sub_index_regions(struct index_layout *layout)
 		result = open_region_reader(layout, &isl->index_save, &reader);
 
 		if (result != UDS_SUCCESS) {
-			uds_log_error_strerror(result,
+			vdo_log_error_strerror(result,
 					       "cannot get reader for index 0 save %u",
 					       j);
 			return result;
@@ -1626,12 +1626,12 @@ static int __must_check verify_uds_index_config(struct index_layout *layout,
 	offset = layout->super.volume_offset - layout->super.start_offset;
 	result = open_layout_reader(layout, &layout->config, offset, &reader);
 	if (result != UDS_SUCCESS)
-		return uds_log_error_strerror(result, "failed to open config reader");
+		return vdo_log_error_strerror(result, "failed to open config reader");
 
 	result = uds_validate_config_contents(reader, config);
 	if (result != UDS_SUCCESS) {
 		uds_free_buffered_reader(reader);
-		return uds_log_error_strerror(result, "failed to read config region");
+		return vdo_log_error_strerror(result, "failed to read config region");
 	}
 
 	uds_free_buffered_reader(reader);
@@ -1646,7 +1646,7 @@ static int load_index_layout(struct index_layout *layout, struct uds_configurati
 	result = uds_make_buffered_reader(layout->factory,
 					  layout->offset / UDS_BLOCK_SIZE, 1, &reader);
 	if (result != UDS_SUCCESS)
-		return uds_log_error_strerror(result, "unable to read superblock");
+		return vdo_log_error_strerror(result, "unable to read superblock");
 
 	result = load_super_block(layout, UDS_BLOCK_SIZE,
 				  layout->offset / UDS_BLOCK_SIZE, reader);
@@ -1675,7 +1675,7 @@ static int create_layout_factory(struct index_layout *layout,
 	writable_size = uds_get_writable_size(factory) & -UDS_BLOCK_SIZE;
 	if (writable_size < config->size + config->offset) {
 		uds_put_io_factory(factory);
-		uds_log_error("index storage (%zu) is smaller than the requested size %zu",
+		vdo_log_error("index storage (%zu) is smaller than the requested size %zu",
 			      writable_size, config->size + config->offset);
 		return -ENOSPC;
 	}
@@ -1708,7 +1708,7 @@ int uds_make_index_layout(struct uds_configuration *config, bool new_layout,
 	}
 
 	if (layout->factory_size < sizes.total_size) {
-		uds_log_error("index storage (%zu) is smaller than the required size %llu",
+		vdo_log_error("index storage (%zu) is smaller than the required size %llu",
 			      layout->factory_size,
 			      (unsigned long long) sizes.total_size);
 		uds_free_index_layout(layout);
diff --git a/drivers/md/dm-vdo/indexer/index-page-map.c b/drivers/md/dm-vdo/indexer/index-page-map.c
index c5d1b9995846..00b44e07d0c1 100644
--- a/drivers/md/dm-vdo/indexer/index-page-map.c
+++ b/drivers/md/dm-vdo/indexer/index-page-map.c
@@ -167,7 +167,7 @@ int uds_read_index_page_map(struct index_page_map *map, struct buffered_reader *
 		decode_u16_le(buffer, &offset, &map->entries[i]);
 
 	vdo_free(buffer);
-	uds_log_debug("read index page map, last update %llu",
+	vdo_log_debug("read index page map, last update %llu",
 		      (unsigned long long) map->last_update);
 	return UDS_SUCCESS;
 }
diff --git a/drivers/md/dm-vdo/indexer/index-session.c b/drivers/md/dm-vdo/indexer/index-session.c
index 9eae00548095..aee0914d604a 100644
--- a/drivers/md/dm-vdo/indexer/index-session.c
+++ b/drivers/md/dm-vdo/indexer/index-session.c
@@ -104,7 +104,7 @@ int uds_launch_request(struct uds_request *request)
 	int result;
 
 	if (request->callback == NULL) {
-		uds_log_error("missing required callback");
+		vdo_log_error("missing required callback");
 		return -EINVAL;
 	}
 
@@ -116,7 +116,7 @@ int uds_launch_request(struct uds_request *request)
 	case UDS_UPDATE:
 		break;
 	default:
-		uds_log_error("received invalid callback type");
+		vdo_log_error("received invalid callback type");
 		return -EINVAL;
 	}
 
@@ -244,7 +244,7 @@ static int __must_check make_empty_index_session(struct uds_index_session **inde
 int uds_create_index_session(struct uds_index_session **session)
 {
 	if (session == NULL) {
-		uds_log_error("missing session pointer");
+		vdo_log_error("missing session pointer");
 		return -EINVAL;
 	}
 
@@ -257,10 +257,10 @@ static int __must_check start_loading_index_session(struct uds_index_session *in
 
 	mutex_lock(&index_session->request_mutex);
 	if (index_session->state & IS_FLAG_SUSPENDED) {
-		uds_log_info("Index session is suspended");
+		vdo_log_info("Index session is suspended");
 		result = -EBUSY;
 	} else if (index_session->state != 0) {
-		uds_log_info("Index is already loaded");
+		vdo_log_info("Index is already loaded");
 		result = -EBUSY;
 	} else {
 		index_session->state |= IS_FLAG_LOADING;
@@ -290,7 +290,7 @@ static int initialize_index_session(struct uds_index_session *index_session,
 
 	result = uds_make_configuration(&index_session->parameters, &config);
 	if (result != UDS_SUCCESS) {
-		uds_log_error_strerror(result, "Failed to allocate config");
+		vdo_log_error_strerror(result, "Failed to allocate config");
 		return result;
 	}
 
@@ -298,7 +298,7 @@ static int initialize_index_session(struct uds_index_session *index_session,
 	result = uds_make_index(config, open_type, &index_session->load_context,
 				enter_callback_stage, &index_session->index);
 	if (result != UDS_SUCCESS)
-		uds_log_error_strerror(result, "Failed to make index");
+		vdo_log_error_strerror(result, "Failed to make index");
 	else
 		uds_log_configuration(config);
 
@@ -332,15 +332,15 @@ int uds_open_index(enum uds_open_index_type open_type,
 	char name[BDEVNAME_SIZE];
 
 	if (parameters == NULL) {
-		uds_log_error("missing required parameters");
+		vdo_log_error("missing required parameters");
 		return -EINVAL;
 	}
 	if (parameters->bdev == NULL) {
-		uds_log_error("missing required block device");
+		vdo_log_error("missing required block device");
 		return -EINVAL;
 	}
 	if (session == NULL) {
-		uds_log_error("missing required session pointer");
+		vdo_log_error("missing required session pointer");
 		return -EINVAL;
 	}
 
@@ -350,11 +350,11 @@ int uds_open_index(enum uds_open_index_type open_type,
 
 	session->parameters = *parameters;
 	format_dev_t(name, parameters->bdev->bd_dev);
-	uds_log_info("%s: %s", get_open_type_string(open_type), name);
+	vdo_log_info("%s: %s", get_open_type_string(open_type), name);
 
 	result = initialize_index_session(session, open_type);
 	if (result != UDS_SUCCESS)
-		uds_log_error_strerror(result, "Failed %s",
+		vdo_log_error_strerror(result, "Failed %s",
 				       get_open_type_string(open_type));
 
 	finish_loading_index_session(session, result);
@@ -426,7 +426,7 @@ int uds_suspend_index_session(struct uds_index_session *session, bool save)
 
 	if ((session->state & IS_FLAG_WAITING) || (session->state & IS_FLAG_DESTROYING)) {
 		no_work = true;
-		uds_log_info("Index session is already changing state");
+		vdo_log_info("Index session is already changing state");
 		result = -EBUSY;
 	} else if (session->state & IS_FLAG_SUSPENDED) {
 		no_work = true;
@@ -485,7 +485,7 @@ int uds_resume_index_session(struct uds_index_session *session,
 
 	mutex_lock(&session->request_mutex);
 	if (session->state & IS_FLAG_WAITING) {
-		uds_log_info("Index session is already changing state");
+		vdo_log_info("Index session is already changing state");
 		no_work = true;
 		result = -EBUSY;
 	} else if (!(session->state & IS_FLAG_SUSPENDED)) {
@@ -562,7 +562,7 @@ static int save_and_free_index(struct uds_index_session *index_session)
 	if (!suspended) {
 		result = uds_save_index(index);
 		if (result != UDS_SUCCESS)
-			uds_log_warning_strerror(result,
+			vdo_log_warning_strerror(result,
 						 "ignoring error from save_index");
 	}
 	uds_free_index(index);
@@ -598,7 +598,7 @@ int uds_close_index(struct uds_index_session *index_session)
 	}
 
 	if (index_session->state & IS_FLAG_SUSPENDED) {
-		uds_log_info("Index session is suspended");
+		vdo_log_info("Index session is suspended");
 		result = -EBUSY;
 	} else if ((index_session->state & IS_FLAG_DESTROYING) ||
 		   !(index_session->state & IS_FLAG_LOADED)) {
@@ -611,10 +611,10 @@ int uds_close_index(struct uds_index_session *index_session)
 	if (result != UDS_SUCCESS)
 		return uds_status_to_errno(result);
 
-	uds_log_debug("Closing index");
+	vdo_log_debug("Closing index");
 	wait_for_no_requests_in_progress(index_session);
 	result = save_and_free_index(index_session);
-	uds_log_debug("Closed index");
+	vdo_log_debug("Closed index");
 
 	mutex_lock(&index_session->request_mutex);
 	index_session->state &= ~IS_FLAG_CLOSING;
@@ -629,7 +629,7 @@ int uds_destroy_index_session(struct uds_index_session *index_session)
 	int result;
 	bool load_pending = false;
 
-	uds_log_debug("Destroying index session");
+	vdo_log_debug("Destroying index session");
 
 	/* Wait for any current index state change to complete. */
 	mutex_lock(&index_session->request_mutex);
@@ -641,7 +641,7 @@ int uds_destroy_index_session(struct uds_index_session *index_session)
 
 	if (index_session->state & IS_FLAG_DESTROYING) {
 		mutex_unlock(&index_session->request_mutex);
-		uds_log_info("Index session is already closing");
+		vdo_log_info("Index session is already closing");
 		return -EBUSY;
 	}
 
@@ -672,7 +672,7 @@ int uds_destroy_index_session(struct uds_index_session *index_session)
 	result = save_and_free_index(index_session);
 	uds_request_queue_finish(index_session->callback_queue);
 	index_session->callback_queue = NULL;
-	uds_log_debug("Destroyed index session");
+	vdo_log_debug("Destroyed index session");
 	vdo_free(index_session);
 	return uds_status_to_errno(result);
 }
@@ -710,7 +710,7 @@ int uds_get_index_session_stats(struct uds_index_session *index_session,
 				struct uds_index_stats *stats)
 {
 	if (stats == NULL) {
-		uds_log_error("received a NULL index stats pointer");
+		vdo_log_error("received a NULL index stats pointer");
 		return -EINVAL;
 	}
 
diff --git a/drivers/md/dm-vdo/indexer/index.c b/drivers/md/dm-vdo/indexer/index.c
index 221af95ca2a4..1ba767144426 100644
--- a/drivers/md/dm-vdo/indexer/index.c
+++ b/drivers/md/dm-vdo/indexer/index.c
@@ -188,7 +188,7 @@ static int finish_previous_chapter(struct uds_index *index, u64 current_chapter_
 	mutex_unlock(&writer->mutex);
 
 	if (result != UDS_SUCCESS)
-		return uds_log_error_strerror(result,
+		return vdo_log_error_strerror(result,
 					      "Writing of previous open chapter failed");
 
 	return UDS_SUCCESS;
@@ -258,7 +258,7 @@ static int open_next_chapter(struct index_zone *zone)
 	unsigned int finished_zones;
 	u32 expire_chapters;
 
-	uds_log_debug("closing chapter %llu of zone %u after %u entries (%u short)",
+	vdo_log_debug("closing chapter %llu of zone %u after %u entries (%u short)",
 		      (unsigned long long) zone->newest_virtual_chapter, zone->id,
 		      zone->open_chapter->size,
 		      zone->open_chapter->capacity - zone->open_chapter->size);
@@ -315,7 +315,7 @@ static int dispatch_index_zone_control_request(struct uds_request *request)
 		return handle_chapter_closed(zone, message->virtual_chapter);
 
 	default:
-		uds_log_error("invalid message type: %d", message->type);
+		vdo_log_error("invalid message type: %d", message->type);
 		return UDS_INVALID_ARGUMENT;
 	}
 }
@@ -600,7 +600,7 @@ static int dispatch_index_request(struct uds_index *index, struct uds_request *r
 		break;
 
 	default:
-		result = uds_log_warning_strerror(UDS_INVALID_ARGUMENT,
+		result = vdo_log_warning_strerror(UDS_INVALID_ARGUMENT,
 						  "invalid request type: %d",
 						  request->type);
 		break;
@@ -618,7 +618,7 @@ static void execute_zone_request(struct uds_request *request)
 	if (request->zone_message.type != UDS_MESSAGE_NONE) {
 		result = dispatch_index_zone_control_request(request);
 		if (result != UDS_SUCCESS) {
-			uds_log_error_strerror(result, "error executing message: %d",
+			vdo_log_error_strerror(result, "error executing message: %d",
 					       request->zone_message.type);
 		}
 
@@ -678,7 +678,7 @@ static void close_chapters(void *arg)
 	struct chapter_writer *writer = arg;
 	struct uds_index *index = writer->index;
 
-	uds_log_debug("chapter writer starting");
+	vdo_log_debug("chapter writer starting");
 	mutex_lock(&writer->mutex);
 	for (;;) {
 		while (writer->zones_to_write < index->zone_count) {
@@ -688,7 +688,7 @@ static void close_chapters(void *arg)
 				 * open chapter, so we can exit now.
 				 */
 				mutex_unlock(&writer->mutex);
-				uds_log_debug("chapter writer stopping");
+				vdo_log_debug("chapter writer stopping");
 				return;
 			}
 			uds_wait_cond(&writer->cond, &writer->mutex);
@@ -711,7 +711,7 @@ static void close_chapters(void *arg)
 			index->has_saved_open_chapter = false;
 			result = uds_discard_open_chapter(index->layout);
 			if (result == UDS_SUCCESS)
-				uds_log_debug("Discarding saved open chapter");
+				vdo_log_debug("Discarding saved open chapter");
 		}
 
 		result = uds_close_open_chapter(writer->chapters, index->zone_count,
@@ -818,7 +818,7 @@ static int load_index(struct uds_index *index)
 
 	last_save_chapter = ((index->last_save != NO_LAST_SAVE) ? index->last_save : 0);
 
-	uds_log_info("loaded index from chapter %llu through chapter %llu",
+	vdo_log_info("loaded index from chapter %llu through chapter %llu",
 		     (unsigned long long) index->oldest_virtual_chapter,
 		     (unsigned long long) last_save_chapter);
 
@@ -843,7 +843,7 @@ static int rebuild_index_page_map(struct uds_index *index, u64 vcn)
 						   index_page_number,
 						   &chapter_index_page);
 		if (result != UDS_SUCCESS) {
-			return uds_log_error_strerror(result,
+			return vdo_log_error_strerror(result,
 						      "failed to read index page %u in chapter %u",
 						      index_page_number, chapter);
 		}
@@ -851,7 +851,7 @@ static int rebuild_index_page_map(struct uds_index *index, u64 vcn)
 		lowest_delta_list = chapter_index_page->lowest_list_number;
 		highest_delta_list = chapter_index_page->highest_list_number;
 		if (lowest_delta_list != expected_list_number) {
-			return uds_log_error_strerror(UDS_CORRUPT_DATA,
+			return vdo_log_error_strerror(UDS_CORRUPT_DATA,
 						      "chapter %u index page %u is corrupt",
 						      chapter, index_page_number);
 		}
@@ -980,7 +980,7 @@ static int replay_chapter(struct uds_index *index, u64 virtual, bool sparse)
 	u32 physical_chapter;
 
 	if (check_for_suspend(index)) {
-		uds_log_info("Replay interrupted by index shutdown at chapter %llu",
+		vdo_log_info("Replay interrupted by index shutdown at chapter %llu",
 			     (unsigned long long) virtual);
 		return -EBUSY;
 	}
@@ -992,7 +992,7 @@ static int replay_chapter(struct uds_index *index, u64 virtual, bool sparse)
 
 	result = rebuild_index_page_map(index, virtual);
 	if (result != UDS_SUCCESS) {
-		return uds_log_error_strerror(result,
+		return vdo_log_error_strerror(result,
 					      "could not rebuild index page map for chapter %u",
 					      physical_chapter);
 	}
@@ -1005,7 +1005,7 @@ static int replay_chapter(struct uds_index *index, u64 virtual, bool sparse)
 		result = uds_get_volume_record_page(index->volume, physical_chapter,
 						    record_page_number, &record_page);
 		if (result != UDS_SUCCESS) {
-			return uds_log_error_strerror(result, "could not get page %d",
+			return vdo_log_error_strerror(result, "could not get page %d",
 						      record_page_number);
 		}
 
@@ -1034,7 +1034,7 @@ static int replay_volume(struct uds_index *index)
 	u64 upto_virtual = index->newest_virtual_chapter;
 	bool will_be_sparse;
 
-	uds_log_info("Replaying volume from chapter %llu through chapter %llu",
+	vdo_log_info("Replaying volume from chapter %llu through chapter %llu",
 		     (unsigned long long) from_virtual,
 		     (unsigned long long) upto_virtual);
 
@@ -1064,7 +1064,7 @@ static int replay_volume(struct uds_index *index)
 
 	new_map_update = index->volume->index_page_map->last_update;
 	if (new_map_update != old_map_update) {
-		uds_log_info("replay changed index page map update from %llu to %llu",
+		vdo_log_info("replay changed index page map update from %llu to %llu",
 			     (unsigned long long) old_map_update,
 			     (unsigned long long) new_map_update);
 	}
@@ -1084,7 +1084,7 @@ static int rebuild_index(struct uds_index *index)
 	result = uds_find_volume_chapter_boundaries(index->volume, &lowest, &highest,
 						    &is_empty);
 	if (result != UDS_SUCCESS) {
-		return uds_log_fatal_strerror(result,
+		return vdo_log_fatal_strerror(result,
 					      "cannot rebuild index: unknown volume chapter boundaries");
 	}
 
@@ -1194,7 +1194,7 @@ int uds_make_index(struct uds_configuration *config, enum uds_open_index_type op
 		result = make_index_zone(index, z);
 		if (result != UDS_SUCCESS) {
 			uds_free_index(index);
-			return uds_log_error_strerror(result,
+			return vdo_log_error_strerror(result,
 						      "Could not create index zone");
 		}
 	}
@@ -1203,7 +1203,7 @@ int uds_make_index(struct uds_configuration *config, enum uds_open_index_type op
 	result = uds_make_volume_index(config, nonce, &index->volume_index);
 	if (result != UDS_SUCCESS) {
 		uds_free_index(index);
-		return uds_log_error_strerror(result, "could not make volume index");
+		return vdo_log_error_strerror(result, "could not make volume index");
 	}
 
 	index->load_context = load_context;
@@ -1229,14 +1229,14 @@ int uds_make_index(struct uds_configuration *config, enum uds_open_index_type op
 			break;
 		case -ENOMEM:
 			/* We should not try a rebuild for this error. */
-			uds_log_error_strerror(result, "index could not be loaded");
+			vdo_log_error_strerror(result, "index could not be loaded");
 			break;
 		default:
-			uds_log_error_strerror(result, "index could not be loaded");
+			vdo_log_error_strerror(result, "index could not be loaded");
 			if (open_type == UDS_LOAD) {
 				result = rebuild_index(index);
 				if (result != UDS_SUCCESS) {
-					uds_log_error_strerror(result,
+					vdo_log_error_strerror(result,
 							       "index could not be rebuilt");
 				}
 			}
@@ -1246,7 +1246,7 @@ int uds_make_index(struct uds_configuration *config, enum uds_open_index_type op
 
 	if (result != UDS_SUCCESS) {
 		uds_free_index(index);
-		return uds_log_error_strerror(result, "fatal error in %s()", __func__);
+		return vdo_log_error_strerror(result, "fatal error in %s()", __func__);
 	}
 
 	for (z = 0; z < index->zone_count; z++) {
@@ -1320,16 +1320,16 @@ int uds_save_index(struct uds_index *index)
 	index->prev_save = index->last_save;
 	index->last_save = ((index->newest_virtual_chapter == 0) ?
 			    NO_LAST_SAVE : index->newest_virtual_chapter - 1);
-	uds_log_info("beginning save (vcn %llu)", (unsigned long long) index->last_save);
+	vdo_log_info("beginning save (vcn %llu)", (unsigned long long) index->last_save);
 
 	result = uds_save_index_state(index->layout, index);
 	if (result != UDS_SUCCESS) {
-		uds_log_info("save index failed");
+		vdo_log_info("save index failed");
 		index->last_save = index->prev_save;
 	} else {
 		index->has_saved_open_chapter = true;
 		index->need_to_save = false;
-		uds_log_info("finished save (vcn %llu)",
+		vdo_log_info("finished save (vcn %llu)",
 			     (unsigned long long) index->last_save);
 	}
 
diff --git a/drivers/md/dm-vdo/indexer/io-factory.c b/drivers/md/dm-vdo/indexer/io-factory.c
index 0dcf6d596653..515765d35794 100644
--- a/drivers/md/dm-vdo/indexer/io-factory.c
+++ b/drivers/md/dm-vdo/indexer/io-factory.c
@@ -365,7 +365,7 @@ void uds_free_buffered_writer(struct buffered_writer *writer)
 	flush_previous_buffer(writer);
 	result = -dm_bufio_write_dirty_buffers(writer->client);
 	if (result != UDS_SUCCESS)
-		uds_log_warning_strerror(result, "%s: failed to sync storage", __func__);
+		vdo_log_warning_strerror(result, "%s: failed to sync storage", __func__);
 
 	dm_bufio_client_destroy(writer->client);
 	uds_put_io_factory(writer->factory);
diff --git a/drivers/md/dm-vdo/indexer/open-chapter.c b/drivers/md/dm-vdo/indexer/open-chapter.c
index 46b7bc1ac324..4a67bcadaae0 100644
--- a/drivers/md/dm-vdo/indexer/open-chapter.c
+++ b/drivers/md/dm-vdo/indexer/open-chapter.c
@@ -259,14 +259,14 @@ static int fill_delta_chapter_index(struct open_chapter_zone **chapter_zones,
 			overflow_count++;
 			break;
 		default:
-			uds_log_error_strerror(result,
+			vdo_log_error_strerror(result,
 					       "failed to build open chapter index");
 			return result;
 		}
 	}
 
 	if (overflow_count > 0)
-		uds_log_warning("Failed to add %d entries to chapter index",
+		vdo_log_warning("Failed to add %d entries to chapter index",
 				overflow_count);
 
 	return UDS_SUCCESS;
@@ -417,7 +417,7 @@ int uds_load_open_chapter(struct uds_index *index, struct buffered_reader *reade
 		return result;
 
 	if (memcmp(OPEN_CHAPTER_VERSION, version, sizeof(version)) != 0) {
-		return uds_log_error_strerror(UDS_CORRUPT_DATA,
+		return vdo_log_error_strerror(UDS_CORRUPT_DATA,
 					      "Invalid open chapter version: %.*s",
 					      (int) sizeof(version), version);
 	}
diff --git a/drivers/md/dm-vdo/indexer/volume-index.c b/drivers/md/dm-vdo/indexer/volume-index.c
index e2b0600d82b9..12f954a0c532 100644
--- a/drivers/md/dm-vdo/indexer/volume-index.c
+++ b/drivers/md/dm-vdo/indexer/volume-index.c
@@ -225,13 +225,13 @@ static int compute_volume_sub_index_parameters(const struct uds_configuration *c
 	params->address_bits = bits_per(address_count - 1);
 	params->chapter_bits = bits_per(rounded_chapters - 1);
 	if ((u32) params->list_count != params->list_count) {
-		return uds_log_warning_strerror(UDS_INVALID_ARGUMENT,
+		return vdo_log_warning_strerror(UDS_INVALID_ARGUMENT,
 						"cannot initialize volume index with %llu delta lists",
 						(unsigned long long) params->list_count);
 	}
 
 	if (params->address_bits > 31) {
-		return uds_log_warning_strerror(UDS_INVALID_ARGUMENT,
+		return vdo_log_warning_strerror(UDS_INVALID_ARGUMENT,
 						"cannot initialize volume index with %u address bits",
 						params->address_bits);
 	}
@@ -568,7 +568,7 @@ int uds_put_volume_index_record(struct volume_index_record *record, u64 virtual_
 		u64 low = get_zone_for_record(record)->virtual_chapter_low;
 		u64 high = get_zone_for_record(record)->virtual_chapter_high;
 
-		return uds_log_warning_strerror(UDS_INVALID_ARGUMENT,
+		return vdo_log_warning_strerror(UDS_INVALID_ARGUMENT,
 						"cannot put record into chapter number %llu that is out of the valid range %llu to %llu",
 						(unsigned long long) virtual_chapter,
 						(unsigned long long) low,
@@ -590,7 +590,7 @@ int uds_put_volume_index_record(struct volume_index_record *record, u64 virtual_
 		record->is_found = true;
 		break;
 	case UDS_OVERFLOW:
-		uds_log_ratelimit(uds_log_warning_strerror, UDS_OVERFLOW,
+		vdo_log_ratelimit(vdo_log_warning_strerror, UDS_OVERFLOW,
 				  "Volume index entry dropped due to overflow condition");
 		uds_log_delta_index_entry(&record->delta_entry);
 		break;
@@ -606,7 +606,7 @@ int uds_remove_volume_index_record(struct volume_index_record *record)
 	int result;
 
 	if (!record->is_found)
-		return uds_log_warning_strerror(UDS_BAD_STATE,
+		return vdo_log_warning_strerror(UDS_BAD_STATE,
 						"illegal operation on new record");
 
 	/* Mark the record so that it cannot be used again */
@@ -644,7 +644,7 @@ static void set_volume_sub_index_zone_open_chapter(struct volume_sub_index *sub_
 			1 + (used_bits - sub_index->max_zone_bits) / sub_index->chapter_zone_bits;
 
 		if (expire_count == 1) {
-			uds_log_ratelimit(uds_log_info,
+			vdo_log_ratelimit(vdo_log_info,
 					  "zone %u:  At chapter %llu, expiring chapter %llu early",
 					  zone_number,
 					  (unsigned long long) virtual_chapter,
@@ -662,7 +662,7 @@ static void set_volume_sub_index_zone_open_chapter(struct volume_sub_index *sub_
 					zone->virtual_chapter_high - zone->virtual_chapter_low;
 				zone->virtual_chapter_low = zone->virtual_chapter_high;
 			}
-			uds_log_ratelimit(uds_log_info,
+			vdo_log_ratelimit(vdo_log_info,
 					  "zone %u:  At chapter %llu, expiring chapters %llu to %llu early",
 					  zone_number,
 					  (unsigned long long) virtual_chapter,
@@ -713,14 +713,14 @@ int uds_set_volume_index_record_chapter(struct volume_index_record *record,
 	int result;
 
 	if (!record->is_found)
-		return uds_log_warning_strerror(UDS_BAD_STATE,
+		return vdo_log_warning_strerror(UDS_BAD_STATE,
 						"illegal operation on new record");
 
 	if (!is_virtual_chapter_indexed(record, virtual_chapter)) {
 		u64 low = get_zone_for_record(record)->virtual_chapter_low;
 		u64 high = get_zone_for_record(record)->virtual_chapter_high;
 
-		return uds_log_warning_strerror(UDS_INVALID_ARGUMENT,
+		return vdo_log_warning_strerror(UDS_INVALID_ARGUMENT,
 						"cannot set chapter number %llu that is out of the valid range %llu to %llu",
 						(unsigned long long) virtual_chapter,
 						(unsigned long long) low,
@@ -820,7 +820,7 @@ static int start_restoring_volume_sub_index(struct volume_sub_index *sub_index,
 		result = uds_read_from_buffered_reader(readers[i], buffer,
 						       sizeof(buffer));
 		if (result != UDS_SUCCESS) {
-			return uds_log_warning_strerror(result,
+			return vdo_log_warning_strerror(result,
 							"failed to read volume index header");
 		}
 
@@ -839,14 +839,14 @@ static int start_restoring_volume_sub_index(struct volume_sub_index *sub_index,
 			result = UDS_CORRUPT_DATA;
 
 		if (memcmp(header.magic, MAGIC_START_5, MAGIC_SIZE) != 0) {
-			return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+			return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
 							"volume index file had bad magic number");
 		}
 
 		if (sub_index->volume_nonce == 0) {
 			sub_index->volume_nonce = header.volume_nonce;
 		} else if (header.volume_nonce != sub_index->volume_nonce) {
-			return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+			return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
 							"volume index volume nonce incorrect");
 		}
 
@@ -857,7 +857,7 @@ static int start_restoring_volume_sub_index(struct volume_sub_index *sub_index,
 			u64 low = header.virtual_chapter_low;
 			u64 high = header.virtual_chapter_high;
 
-			return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+			return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
 							"Inconsistent volume index zone files: Chapter range is [%llu,%llu], chapter range %d is [%llu,%llu]",
 							(unsigned long long) virtual_chapter_low,
 							(unsigned long long) virtual_chapter_high,
@@ -873,7 +873,7 @@ static int start_restoring_volume_sub_index(struct volume_sub_index *sub_index,
 			result = uds_read_from_buffered_reader(readers[i], decoded,
 							       sizeof(u64));
 			if (result != UDS_SUCCESS) {
-				return uds_log_warning_strerror(result,
+				return vdo_log_warning_strerror(result,
 								"failed to read volume index flush ranges");
 			}
 
@@ -891,7 +891,7 @@ static int start_restoring_volume_sub_index(struct volume_sub_index *sub_index,
 	result = uds_start_restoring_delta_index(&sub_index->delta_index, readers,
 						 reader_count);
 	if (result != UDS_SUCCESS)
-		return uds_log_warning_strerror(result, "restoring delta index failed");
+		return vdo_log_warning_strerror(result, "restoring delta index failed");
 
 	return UDS_SUCCESS;
 }
@@ -916,7 +916,7 @@ static int start_restoring_volume_index(struct volume_index *volume_index,
 		result = uds_read_from_buffered_reader(buffered_readers[i], buffer,
 						       sizeof(buffer));
 		if (result != UDS_SUCCESS) {
-			return uds_log_warning_strerror(result,
+			return vdo_log_warning_strerror(result,
 							"failed to read volume index header");
 		}
 
@@ -931,13 +931,13 @@ static int start_restoring_volume_index(struct volume_index *volume_index,
 			result = UDS_CORRUPT_DATA;
 
 		if (memcmp(header.magic, MAGIC_START_6, MAGIC_SIZE) != 0)
-			return uds_log_warning_strerror(UDS_CORRUPT_DATA,
+			return vdo_log_warning_strerror(UDS_CORRUPT_DATA,
 							"volume index file had bad magic number");
 
 		if (i == 0) {
 			volume_index->sparse_sample_rate = header.sparse_sample_rate;
 		} else if (volume_index->sparse_sample_rate != header.sparse_sample_rate) {
-			uds_log_warning_strerror(UDS_CORRUPT_DATA,
+			vdo_log_warning_strerror(UDS_CORRUPT_DATA,
 						 "Inconsistent sparse sample rate in delta index zone files: %u vs. %u",
 						 volume_index->sparse_sample_rate,
 						 header.sparse_sample_rate);
@@ -1031,7 +1031,7 @@ static int start_saving_volume_sub_index(const struct volume_sub_index *sub_inde
 
 	result = uds_write_to_buffered_writer(buffered_writer, buffer, offset);
 	if (result != UDS_SUCCESS)
-		return uds_log_warning_strerror(result,
+		return vdo_log_warning_strerror(result,
 						"failed to write volume index header");
 
 	for (i = 0; i < list_count; i++) {
@@ -1041,7 +1041,7 @@ static int start_saving_volume_sub_index(const struct volume_sub_index *sub_inde
 		result = uds_write_to_buffered_writer(buffered_writer, encoded,
 						      sizeof(u64));
 		if (result != UDS_SUCCESS) {
-			return uds_log_warning_strerror(result,
+			return vdo_log_warning_strerror(result,
 							"failed to write volume index flush ranges");
 		}
 	}
@@ -1074,7 +1074,7 @@ static int start_saving_volume_index(const struct volume_index *volume_index,
 
 	result = uds_write_to_buffered_writer(writer, buffer, offset);
 	if (result != UDS_SUCCESS) {
-		uds_log_warning_strerror(result, "failed to write volume index header");
+		vdo_log_warning_strerror(result, "failed to write volume index header");
 		return result;
 	}
 
@@ -1264,7 +1264,7 @@ int uds_make_volume_index(const struct uds_configuration *config, u64 volume_non
 					     &volume_index->vi_non_hook);
 	if (result != UDS_SUCCESS) {
 		uds_free_volume_index(volume_index);
-		return uds_log_error_strerror(result,
+		return vdo_log_error_strerror(result,
 					      "Error creating non hook volume index");
 	}
 
@@ -1272,7 +1272,7 @@ int uds_make_volume_index(const struct uds_configuration *config, u64 volume_non
 					     &volume_index->vi_hook);
 	if (result != UDS_SUCCESS) {
 		uds_free_volume_index(volume_index);
-		return uds_log_error_strerror(result,
+		return vdo_log_error_strerror(result,
 					      "Error creating hook volume index");
 	}
 
diff --git a/drivers/md/dm-vdo/indexer/volume.c b/drivers/md/dm-vdo/indexer/volume.c
index 701f2220d803..655453bb276b 100644
--- a/drivers/md/dm-vdo/indexer/volume.c
+++ b/drivers/md/dm-vdo/indexer/volume.c
@@ -357,7 +357,7 @@ static void enqueue_page_read(struct volume *volume, struct uds_request *request
 {
 	/* Mark the page as queued, so that chapter invalidation knows to cancel a read. */
 	while (!enqueue_read(&volume->page_cache, request, physical_page)) {
-		uds_log_debug("Read queue full, waiting for reads to finish");
+		vdo_log_debug("Read queue full, waiting for reads to finish");
 		uds_wait_cond(&volume->read_threads_read_done_cond,
 			      &volume->read_threads_mutex);
 	}
@@ -431,7 +431,7 @@ static int init_chapter_index_page(const struct volume *volume, u8 *index_page,
 		return result;
 
 	if (result != UDS_SUCCESS) {
-		return uds_log_error_strerror(result,
+		return vdo_log_error_strerror(result,
 					      "Reading chapter index page for chapter %u page %u",
 					      chapter, index_page_number);
 	}
@@ -445,14 +445,14 @@ static int init_chapter_index_page(const struct volume *volume, u8 *index_page,
 	    (highest_list == chapter_index_page->highest_list_number))
 		return UDS_SUCCESS;
 
-	uds_log_warning("Index page map updated to %llu",
+	vdo_log_warning("Index page map updated to %llu",
 			(unsigned long long) volume->index_page_map->last_update);
-	uds_log_warning("Page map expects that chapter %u page %u has range %u to %u, but chapter index page has chapter %llu with range %u to %u",
+	vdo_log_warning("Page map expects that chapter %u page %u has range %u to %u, but chapter index page has chapter %llu with range %u to %u",
 			chapter, index_page_number, lowest_list, highest_list,
 			(unsigned long long) ci_virtual,
 			chapter_index_page->lowest_list_number,
 			chapter_index_page->highest_list_number);
-	return uds_log_error_strerror(UDS_CORRUPT_DATA,
+	return vdo_log_error_strerror(UDS_CORRUPT_DATA,
 				      "index page map mismatch with chapter index");
 }
 
@@ -547,7 +547,7 @@ static int process_entry(struct volume *volume, struct queued_read *entry)
 	int result;
 
 	if (entry->invalid) {
-		uds_log_debug("Requeuing requests for invalid page");
+		vdo_log_debug("Requeuing requests for invalid page");
 		return UDS_SUCCESS;
 	}
 
@@ -558,7 +558,7 @@ static int process_entry(struct volume *volume, struct queued_read *entry)
 	mutex_lock(&volume->read_threads_mutex);
 	if (IS_ERR(page_data)) {
 		result = -PTR_ERR(page_data);
-		uds_log_warning_strerror(result,
+		vdo_log_warning_strerror(result,
 					 "error reading physical page %u from volume",
 					 page_number);
 		cancel_page_in_cache(&volume->page_cache, page_number, page);
@@ -566,7 +566,7 @@ static int process_entry(struct volume *volume, struct queued_read *entry)
 	}
 
 	if (entry->invalid) {
-		uds_log_warning("Page %u invalidated after read", page_number);
+		vdo_log_warning("Page %u invalidated after read", page_number);
 		cancel_page_in_cache(&volume->page_cache, page_number, page);
 		return UDS_SUCCESS;
 	}
@@ -574,7 +574,7 @@ static int process_entry(struct volume *volume, struct queued_read *entry)
 	if (!is_record_page(volume->geometry, page_number)) {
 		result = initialize_index_page(volume, page_number, page);
 		if (result != UDS_SUCCESS) {
-			uds_log_warning("Error initializing chapter index page");
+			vdo_log_warning("Error initializing chapter index page");
 			cancel_page_in_cache(&volume->page_cache, page_number, page);
 			return result;
 		}
@@ -582,7 +582,7 @@ static int process_entry(struct volume *volume, struct queued_read *entry)
 
 	result = put_page_in_cache(&volume->page_cache, page_number, page);
 	if (result != UDS_SUCCESS) {
-		uds_log_warning("Error putting page %u in cache", page_number);
+		vdo_log_warning("Error putting page %u in cache", page_number);
 		cancel_page_in_cache(&volume->page_cache, page_number, page);
 		return result;
 	}
@@ -624,7 +624,7 @@ static void read_thread_function(void *arg)
 {
 	struct volume *volume = arg;
 
-	uds_log_debug("reader starting");
+	vdo_log_debug("reader starting");
 	mutex_lock(&volume->read_threads_mutex);
 	while (true) {
 		struct queued_read *queue_entry;
@@ -638,7 +638,7 @@ static void read_thread_function(void *arg)
 		release_queued_requests(volume, queue_entry, result);
 	}
 	mutex_unlock(&volume->read_threads_mutex);
-	uds_log_debug("reader done");
+	vdo_log_debug("reader done");
 }
 
 static void get_page_and_index(struct page_cache *cache, u32 physical_page,
@@ -701,7 +701,7 @@ static int read_page_locked(struct volume *volume, u32 physical_page,
 	page_data = dm_bufio_read(volume->client, physical_page, &page->buffer);
 	if (IS_ERR(page_data)) {
 		result = -PTR_ERR(page_data);
-		uds_log_warning_strerror(result,
+		vdo_log_warning_strerror(result,
 					 "error reading physical page %u from volume",
 					 physical_page);
 		cancel_page_in_cache(&volume->page_cache, physical_page, page);
@@ -712,7 +712,7 @@ static int read_page_locked(struct volume *volume, u32 physical_page,
 		result = initialize_index_page(volume, physical_page, page);
 		if (result != UDS_SUCCESS) {
 			if (volume->lookup_mode != LOOKUP_FOR_REBUILD)
-				uds_log_warning("Corrupt index page %u", physical_page);
+				vdo_log_warning("Corrupt index page %u", physical_page);
 			cancel_page_in_cache(&volume->page_cache, physical_page, page);
 			return result;
 		}
@@ -720,7 +720,7 @@ static int read_page_locked(struct volume *volume, u32 physical_page,
 
 	result = put_page_in_cache(&volume->page_cache, physical_page, page);
 	if (result != UDS_SUCCESS) {
-		uds_log_warning("Error putting page %u in cache", physical_page);
+		vdo_log_warning("Error putting page %u in cache", physical_page);
 		cancel_page_in_cache(&volume->page_cache, physical_page, page);
 		return result;
 	}
@@ -947,7 +947,7 @@ int uds_read_chapter_index_from_volume(const struct volume *volume, u64 virtual_
 					   &volume_buffers[i]);
 		if (IS_ERR(index_page)) {
 			result = -PTR_ERR(index_page);
-			uds_log_warning_strerror(result,
+			vdo_log_warning_strerror(result,
 						 "error reading physical page %u",
 						 physical_page);
 			return result;
@@ -1039,7 +1039,7 @@ static void invalidate_page(struct page_cache *cache, u32 physical_page)
 		wait_for_pending_searches(cache, page->physical_page);
 		clear_cache_page(cache, page);
 	} else if (queue_index > -1) {
-		uds_log_debug("setting pending read to invalid");
+		vdo_log_debug("setting pending read to invalid");
 		cache->read_queue[queue_index].invalid = true;
 	}
 }
@@ -1051,7 +1051,7 @@ void uds_forget_chapter(struct volume *volume, u64 virtual_chapter)
 	u32 first_page = map_to_physical_page(volume->geometry, physical_chapter, 0);
 	u32 i;
 
-	uds_log_debug("forgetting chapter %llu", (unsigned long long) virtual_chapter);
+	vdo_log_debug("forgetting chapter %llu", (unsigned long long) virtual_chapter);
 	mutex_lock(&volume->read_threads_mutex);
 	for (i = 0; i < volume->geometry->pages_per_chapter; i++)
 		invalidate_page(&volume->page_cache, first_page + i);
@@ -1077,14 +1077,14 @@ static int donate_index_page_locked(struct volume *volume, u32 physical_chapter,
 					 physical_chapter, index_page_number,
 					 &page->index_page);
 	if (result != UDS_SUCCESS) {
-		uds_log_warning("Error initialize chapter index page");
+		vdo_log_warning("Error initialize chapter index page");
 		cancel_page_in_cache(&volume->page_cache, physical_page, page);
 		return result;
 	}
 
 	result = put_page_in_cache(&volume->page_cache, physical_page, page);
 	if (result != UDS_SUCCESS) {
-		uds_log_warning("Error putting page %u in cache", physical_page);
+		vdo_log_warning("Error putting page %u in cache", physical_page);
 		cancel_page_in_cache(&volume->page_cache, physical_page, page);
 		return result;
 	}
@@ -1112,7 +1112,7 @@ static int write_index_pages(struct volume *volume, u32 physical_chapter_number,
 
 		page_data = dm_bufio_new(volume->client, physical_page, &page_buffer);
 		if (IS_ERR(page_data)) {
-			return uds_log_warning_strerror(-PTR_ERR(page_data),
+			return vdo_log_warning_strerror(-PTR_ERR(page_data),
 							"failed to prepare index page");
 		}
 
@@ -1122,14 +1122,14 @@ static int write_index_pages(struct volume *volume, u32 physical_chapter_number,
 							  &lists_packed);
 		if (result != UDS_SUCCESS) {
 			dm_bufio_release(page_buffer);
-			return uds_log_warning_strerror(result,
+			return vdo_log_warning_strerror(result,
 							"failed to pack index page");
 		}
 
 		dm_bufio_mark_buffer_dirty(page_buffer);
 
 		if (lists_packed == 0) {
-			uds_log_debug("no delta lists packed on chapter %u page %u",
+			vdo_log_debug("no delta lists packed on chapter %u page %u",
 				      physical_chapter_number, index_page_number);
 		} else {
 			delta_list_number += lists_packed;
@@ -1221,14 +1221,14 @@ static int write_record_pages(struct volume *volume, u32 physical_chapter_number
 
 		page_data = dm_bufio_new(volume->client, physical_page, &page_buffer);
 		if (IS_ERR(page_data)) {
-			return uds_log_warning_strerror(-PTR_ERR(page_data),
+			return vdo_log_warning_strerror(-PTR_ERR(page_data),
 							"failed to prepare record page");
 		}
 
 		result = encode_record_page(volume, next_record, page_data);
 		if (result != UDS_SUCCESS) {
 			dm_bufio_release(page_buffer);
-			return uds_log_warning_strerror(result,
+			return vdo_log_warning_strerror(result,
 							"failed to encode record page %u",
 							record_page_number);
 		}
@@ -1259,7 +1259,7 @@ int uds_write_chapter(struct volume *volume, struct open_chapter_index *chapter_
 
 	result = -dm_bufio_write_dirty_buffers(volume->client);
 	if (result != UDS_SUCCESS)
-		uds_log_error_strerror(result, "cannot sync chapter to volume");
+		vdo_log_error_strerror(result, "cannot sync chapter to volume");
 
 	return result;
 }
@@ -1286,7 +1286,7 @@ static void probe_chapter(struct volume *volume, u32 chapter_number,
 			return;
 
 		if (page->virtual_chapter_number == BAD_CHAPTER) {
-			uds_log_error("corrupt index page in chapter %u",
+			vdo_log_error("corrupt index page in chapter %u",
 				      chapter_number);
 			return;
 		}
@@ -1294,14 +1294,14 @@ static void probe_chapter(struct volume *volume, u32 chapter_number,
 		if (vcn == BAD_CHAPTER) {
 			vcn = page->virtual_chapter_number;
 		} else if (page->virtual_chapter_number != vcn) {
-			uds_log_error("inconsistent chapter %u index page %u: expected vcn %llu, got vcn %llu",
+			vdo_log_error("inconsistent chapter %u index page %u: expected vcn %llu, got vcn %llu",
 				      chapter_number, i, (unsigned long long) vcn,
 				      (unsigned long long) page->virtual_chapter_number);
 			return;
 		}
 
 		if (expected_list_number != page->lowest_list_number) {
-			uds_log_error("inconsistent chapter %u index page %u: expected list number %u, got list number %u",
+			vdo_log_error("inconsistent chapter %u index page %u: expected list number %u, got list number %u",
 				      chapter_number, i, expected_list_number,
 				      page->lowest_list_number);
 			return;
@@ -1314,7 +1314,7 @@ static void probe_chapter(struct volume *volume, u32 chapter_number,
 	}
 
 	if (chapter_number != uds_map_to_physical_chapter(geometry, vcn)) {
-		uds_log_error("chapter %u vcn %llu is out of phase (%u)", chapter_number,
+		vdo_log_error("chapter %u vcn %llu is out of phase (%u)", chapter_number,
 			      (unsigned long long) vcn, geometry->chapters_per_volume);
 		return;
 	}
@@ -1431,7 +1431,7 @@ static int find_chapter_limits(struct volume *volume, u32 chapter_limit, u64 *lo
 
 		probe_chapter(volume, right_chapter, &highest);
 		if (bad_chapters++ >= MAX_BAD_CHAPTERS) {
-			uds_log_error("too many bad chapters in volume: %u",
+			vdo_log_error("too many bad chapters in volume: %u",
 				      bad_chapters);
 			return UDS_CORRUPT_DATA;
 		}
@@ -1555,7 +1555,7 @@ int uds_make_volume(const struct uds_configuration *config, struct index_layout
 	result = uds_copy_index_geometry(config->geometry, &volume->geometry);
 	if (result != UDS_SUCCESS) {
 		uds_free_volume(volume);
-		return uds_log_warning_strerror(result,
+		return vdo_log_warning_strerror(result,
 						"failed to allocate geometry: error");
 	}
 	geometry = volume->geometry;
diff --git a/drivers/md/dm-vdo/int-map.c b/drivers/md/dm-vdo/int-map.c
index a909a11204c1..3aa438f84ea1 100644
--- a/drivers/md/dm-vdo/int-map.c
+++ b/drivers/md/dm-vdo/int-map.c
@@ -381,7 +381,7 @@ static int resize_buckets(struct int_map *map)
 	/* Re-initialize the map to be empty and 50% larger. */
 	size_t new_capacity = map->capacity / 2 * 3;
 
-	uds_log_info("%s: attempting resize from %zu to %zu, current size=%zu",
+	vdo_log_info("%s: attempting resize from %zu to %zu, current size=%zu",
 		     __func__, map->capacity, new_capacity, map->size);
 	result = allocate_buckets(map, new_capacity);
 	if (result != VDO_SUCCESS) {
diff --git a/drivers/md/dm-vdo/io-submitter.c b/drivers/md/dm-vdo/io-submitter.c
index 61bb48068c3a..9a3716bb3c05 100644
--- a/drivers/md/dm-vdo/io-submitter.c
+++ b/drivers/md/dm-vdo/io-submitter.c
@@ -408,7 +408,7 @@ int vdo_make_io_submitter(unsigned int thread_count, unsigned int rotation_inter
 			 * Clean up the partially initialized bio-queue entirely and indicate that
 			 * initialization failed.
 			 */
-			uds_log_error("bio map initialization failed %d", result);
+			vdo_log_error("bio map initialization failed %d", result);
 			vdo_cleanup_io_submitter(io_submitter);
 			vdo_free_io_submitter(io_submitter);
 			return result;
@@ -423,7 +423,7 @@ int vdo_make_io_submitter(unsigned int thread_count, unsigned int rotation_inter
 			 * initialization failed.
 			 */
 			vdo_int_map_free(vdo_forget(bio_queue_data->map));
-			uds_log_error("bio queue initialization failed %d", result);
+			vdo_log_error("bio queue initialization failed %d", result);
 			vdo_cleanup_io_submitter(io_submitter);
 			vdo_free_io_submitter(io_submitter);
 			return result;
diff --git a/drivers/md/dm-vdo/logger.c b/drivers/md/dm-vdo/logger.c
index 80f1e4c62ac6..3f7dc2cb6b98 100644
--- a/drivers/md/dm-vdo/logger.c
+++ b/drivers/md/dm-vdo/logger.c
@@ -16,14 +16,14 @@
 #include "thread-device.h"
 #include "thread-utils.h"
 
-int vdo_log_level = UDS_LOG_DEFAULT;
+int vdo_log_level = VDO_LOG_DEFAULT;
 
-int uds_get_log_level(void)
+int vdo_get_log_level(void)
 {
 	int log_level_latch = READ_ONCE(vdo_log_level);
 
-	if (unlikely(log_level_latch > UDS_LOG_MAX)) {
-		log_level_latch = UDS_LOG_DEFAULT;
+	if (unlikely(log_level_latch > VDO_LOG_MAX)) {
+		log_level_latch = VDO_LOG_DEFAULT;
 		WRITE_ONCE(vdo_log_level, log_level_latch);
 	}
 	return log_level_latch;
@@ -54,7 +54,7 @@ static void emit_log_message_to_kernel(int priority, const char *fmt, ...)
 	va_list args;
 	struct va_format vaf;
 
-	if (priority > uds_get_log_level())
+	if (priority > vdo_get_log_level())
 		return;
 
 	va_start(args, fmt);
@@ -62,22 +62,22 @@ static void emit_log_message_to_kernel(int priority, const char *fmt, ...)
 	vaf.va = &args;
 
 	switch (priority) {
-	case UDS_LOG_EMERG:
-	case UDS_LOG_ALERT:
-	case UDS_LOG_CRIT:
+	case VDO_LOG_EMERG:
+	case VDO_LOG_ALERT:
+	case VDO_LOG_CRIT:
 		pr_crit("%pV", &vaf);
 		break;
-	case UDS_LOG_ERR:
+	case VDO_LOG_ERR:
 		pr_err("%pV", &vaf);
 		break;
-	case UDS_LOG_WARNING:
+	case VDO_LOG_WARNING:
 		pr_warn("%pV", &vaf);
 		break;
-	case UDS_LOG_NOTICE:
-	case UDS_LOG_INFO:
+	case VDO_LOG_NOTICE:
+	case VDO_LOG_INFO:
 		pr_info("%pV", &vaf);
 		break;
-	case UDS_LOG_DEBUG:
+	case VDO_LOG_DEBUG:
 		pr_debug("%pV", &vaf);
 		break;
 	default:
@@ -150,7 +150,7 @@ static void emit_log_message(int priority, const char *module, const char *prefi
 }
 
 /*
- * uds_log_embedded_message() - Log a message embedded within another message.
+ * vdo_log_embedded_message() - Log a message embedded within another message.
  * @priority: the priority at which to log the message
  * @module: the name of the module doing the logging
  * @prefix: optional string prefix to message, may be NULL
@@ -158,7 +158,7 @@ static void emit_log_message(int priority, const char *module, const char *prefi
  * @args1: arguments for message first part (required)
  * @fmt2: format of message second part
  */
-void uds_log_embedded_message(int priority, const char *module, const char *prefix,
+void vdo_log_embedded_message(int priority, const char *module, const char *prefix,
 			      const char *fmt1, va_list args1, const char *fmt2, ...)
 {
 	va_list args1_copy;
@@ -168,7 +168,7 @@ void uds_log_embedded_message(int priority, const char *module, const char *pref
 	va_start(args2, fmt2);
 
 	if (module == NULL)
-		module = UDS_LOGGING_MODULE_NAME;
+		module = VDO_LOGGING_MODULE_NAME;
 
 	if (prefix == NULL)
 		prefix = "";
@@ -191,41 +191,41 @@ void uds_log_embedded_message(int priority, const char *module, const char *pref
 	va_end(args2);
 }
 
-int uds_vlog_strerror(int priority, int errnum, const char *module, const char *format,
+int vdo_vlog_strerror(int priority, int errnum, const char *module, const char *format,
 		      va_list args)
 {
-	char errbuf[UDS_MAX_ERROR_MESSAGE_SIZE];
+	char errbuf[VDO_MAX_ERROR_MESSAGE_SIZE];
 	const char *message = uds_string_error(errnum, errbuf, sizeof(errbuf));
 
-	uds_log_embedded_message(priority, module, NULL, format, args, ": %s (%d)",
+	vdo_log_embedded_message(priority, module, NULL, format, args, ": %s (%d)",
 				 message, errnum);
 	return errnum;
 }
 
-int __uds_log_strerror(int priority, int errnum, const char *module, const char *format, ...)
+int __vdo_log_strerror(int priority, int errnum, const char *module, const char *format, ...)
 {
 	va_list args;
 
 	va_start(args, format);
-	uds_vlog_strerror(priority, errnum, module, format, args);
+	vdo_vlog_strerror(priority, errnum, module, format, args);
 	va_end(args);
 	return errnum;
 }
 
-void uds_log_backtrace(int priority)
+void vdo_log_backtrace(int priority)
 {
-	if (priority > uds_get_log_level())
+	if (priority > vdo_get_log_level())
 		return;
 
 	dump_stack();
 }
 
-void __uds_log_message(int priority, const char *module, const char *format, ...)
+void __vdo_log_message(int priority, const char *module, const char *format, ...)
 {
 	va_list args;
 
 	va_start(args, format);
-	uds_log_embedded_message(priority, module, NULL, format, args, "%s", "");
+	vdo_log_embedded_message(priority, module, NULL, format, args, "%s", "");
 	va_end(args);
 }
 
@@ -233,7 +233,7 @@ void __uds_log_message(int priority, const char *module, const char *format, ...
  * Sleep or delay a few milliseconds in an attempt to allow the log buffers to be flushed lest they
  * be overrun.
  */
-void uds_pause_for_logger(void)
+void vdo_pause_for_logger(void)
 {
 	fsleep(4000);
 }
diff --git a/drivers/md/dm-vdo/logger.h b/drivers/md/dm-vdo/logger.h
index a8cdf46b6fc1..ae6ad691c027 100644
--- a/drivers/md/dm-vdo/logger.h
+++ b/drivers/md/dm-vdo/logger.h
@@ -3,8 +3,8 @@
  * Copyright 2023 Red Hat
  */
 
-#ifndef UDS_LOGGER_H
-#define UDS_LOGGER_H
+#ifndef VDO_LOGGER_H
+#define VDO_LOGGER_H
 
 #include <linux/kern_levels.h>
 #include <linux/module.h>
@@ -14,26 +14,26 @@
 /* Custom logging utilities for UDS */
 
 enum {
-	UDS_LOG_EMERG = LOGLEVEL_EMERG,
-	UDS_LOG_ALERT = LOGLEVEL_ALERT,
-	UDS_LOG_CRIT = LOGLEVEL_CRIT,
-	UDS_LOG_ERR = LOGLEVEL_ERR,
-	UDS_LOG_WARNING = LOGLEVEL_WARNING,
-	UDS_LOG_NOTICE = LOGLEVEL_NOTICE,
-	UDS_LOG_INFO = LOGLEVEL_INFO,
-	UDS_LOG_DEBUG = LOGLEVEL_DEBUG,
-
-	UDS_LOG_MAX = UDS_LOG_DEBUG,
-	UDS_LOG_DEFAULT = UDS_LOG_INFO,
+	VDO_LOG_EMERG = LOGLEVEL_EMERG,
+	VDO_LOG_ALERT = LOGLEVEL_ALERT,
+	VDO_LOG_CRIT = LOGLEVEL_CRIT,
+	VDO_LOG_ERR = LOGLEVEL_ERR,
+	VDO_LOG_WARNING = LOGLEVEL_WARNING,
+	VDO_LOG_NOTICE = LOGLEVEL_NOTICE,
+	VDO_LOG_INFO = LOGLEVEL_INFO,
+	VDO_LOG_DEBUG = LOGLEVEL_DEBUG,
+
+	VDO_LOG_MAX = VDO_LOG_DEBUG,
+	VDO_LOG_DEFAULT = VDO_LOG_INFO,
 };
 
 extern int vdo_log_level;
 
 #define DM_MSG_PREFIX "vdo"
-#define UDS_LOGGING_MODULE_NAME DM_NAME ": " DM_MSG_PREFIX
+#define VDO_LOGGING_MODULE_NAME DM_NAME ": " DM_MSG_PREFIX
 
 /* Apply a rate limiter to a log method call. */
-#define uds_log_ratelimit(log_fn, ...)                                    \
+#define vdo_log_ratelimit(log_fn, ...)                                    \
 	do {                                                              \
 		static DEFINE_RATELIMIT_STATE(_rs,                        \
 					      DEFAULT_RATELIMIT_INTERVAL, \
@@ -43,58 +43,58 @@ extern int vdo_log_level;
 		}                                                         \
 	} while (0)
 
-int uds_get_log_level(void);
+int vdo_get_log_level(void);
 
-void uds_log_embedded_message(int priority, const char *module, const char *prefix,
+void vdo_log_embedded_message(int priority, const char *module, const char *prefix,
 			      const char *fmt1, va_list args1, const char *fmt2, ...)
 	__printf(4, 0) __printf(6, 7);
 
-void uds_log_backtrace(int priority);
+void vdo_log_backtrace(int priority);
 
 /* All log functions will preserve the caller's value of errno. */
 
-#define uds_log_strerror(priority, errnum, ...) \
-	__uds_log_strerror(priority, errnum, UDS_LOGGING_MODULE_NAME, __VA_ARGS__)
+#define vdo_log_strerror(priority, errnum, ...) \
+	__vdo_log_strerror(priority, errnum, VDO_LOGGING_MODULE_NAME, __VA_ARGS__)
 
-int __uds_log_strerror(int priority, int errnum, const char *module,
+int __vdo_log_strerror(int priority, int errnum, const char *module,
 		       const char *format, ...)
 	__printf(4, 5);
 
-int uds_vlog_strerror(int priority, int errnum, const char *module, const char *format,
+int vdo_vlog_strerror(int priority, int errnum, const char *module, const char *format,
 		      va_list args)
 	__printf(4, 0);
 
 /* Log an error prefixed with the string associated with the errnum. */
-#define uds_log_error_strerror(errnum, ...) \
-	uds_log_strerror(UDS_LOG_ERR, errnum, __VA_ARGS__)
+#define vdo_log_error_strerror(errnum, ...) \
+	vdo_log_strerror(VDO_LOG_ERR, errnum, __VA_ARGS__)
 
-#define uds_log_debug_strerror(errnum, ...) \
-	uds_log_strerror(UDS_LOG_DEBUG, errnum, __VA_ARGS__)
+#define vdo_log_debug_strerror(errnum, ...) \
+	vdo_log_strerror(VDO_LOG_DEBUG, errnum, __VA_ARGS__)
 
-#define uds_log_info_strerror(errnum, ...) \
-	uds_log_strerror(UDS_LOG_INFO, errnum, __VA_ARGS__)
+#define vdo_log_info_strerror(errnum, ...) \
+	vdo_log_strerror(VDO_LOG_INFO, errnum, __VA_ARGS__)
 
-#define uds_log_warning_strerror(errnum, ...) \
-	uds_log_strerror(UDS_LOG_WARNING, errnum, __VA_ARGS__)
+#define vdo_log_warning_strerror(errnum, ...) \
+	vdo_log_strerror(VDO_LOG_WARNING, errnum, __VA_ARGS__)
 
-#define uds_log_fatal_strerror(errnum, ...) \
-	uds_log_strerror(UDS_LOG_CRIT, errnum, __VA_ARGS__)
+#define vdo_log_fatal_strerror(errnum, ...) \
+	vdo_log_strerror(VDO_LOG_CRIT, errnum, __VA_ARGS__)
 
-#define uds_log_message(priority, ...) \
-	__uds_log_message(priority, UDS_LOGGING_MODULE_NAME, __VA_ARGS__)
+#define vdo_log_message(priority, ...) \
+	__vdo_log_message(priority, VDO_LOGGING_MODULE_NAME, __VA_ARGS__)
 
-void __uds_log_message(int priority, const char *module, const char *format, ...)
+void __vdo_log_message(int priority, const char *module, const char *format, ...)
 	__printf(3, 4);
 
-#define uds_log_debug(...) uds_log_message(UDS_LOG_DEBUG, __VA_ARGS__)
+#define vdo_log_debug(...) vdo_log_message(VDO_LOG_DEBUG, __VA_ARGS__)
 
-#define uds_log_info(...) uds_log_message(UDS_LOG_INFO, __VA_ARGS__)
+#define vdo_log_info(...) vdo_log_message(VDO_LOG_INFO, __VA_ARGS__)
 
-#define uds_log_warning(...) uds_log_message(UDS_LOG_WARNING, __VA_ARGS__)
+#define vdo_log_warning(...) vdo_log_message(VDO_LOG_WARNING, __VA_ARGS__)
 
-#define uds_log_error(...) uds_log_message(UDS_LOG_ERR, __VA_ARGS__)
+#define vdo_log_error(...) vdo_log_message(VDO_LOG_ERR, __VA_ARGS__)
 
-#define uds_log_fatal(...) uds_log_message(UDS_LOG_CRIT, __VA_ARGS__)
+#define vdo_log_fatal(...) vdo_log_message(VDO_LOG_CRIT, __VA_ARGS__)
 
-void uds_pause_for_logger(void);
-#endif /* UDS_LOGGER_H */
+void vdo_pause_for_logger(void);
+#endif /* VDO_LOGGER_H */
diff --git a/drivers/md/dm-vdo/logical-zone.c b/drivers/md/dm-vdo/logical-zone.c
index 300f9d2d2d5c..258bc55e419b 100644
--- a/drivers/md/dm-vdo/logical-zone.c
+++ b/drivers/md/dm-vdo/logical-zone.c
@@ -363,8 +363,8 @@ struct physical_zone *vdo_get_next_allocation_zone(struct logical_zone *zone)
  */
 void vdo_dump_logical_zone(const struct logical_zone *zone)
 {
-	uds_log_info("logical_zone %u", zone->zone_number);
-	uds_log_info("  flush_generation=%llu oldest_active_generation=%llu notification_generation=%llu notifying=%s ios_in_flush_generation=%llu",
+	vdo_log_info("logical_zone %u", zone->zone_number);
+	vdo_log_info("  flush_generation=%llu oldest_active_generation=%llu notification_generation=%llu notifying=%s ios_in_flush_generation=%llu",
 		     (unsigned long long) READ_ONCE(zone->flush_generation),
 		     (unsigned long long) READ_ONCE(zone->oldest_active_generation),
 		     (unsigned long long) READ_ONCE(zone->notification_generation),
diff --git a/drivers/md/dm-vdo/memory-alloc.c b/drivers/md/dm-vdo/memory-alloc.c
index 62bb717c4c50..185f259c7245 100644
--- a/drivers/md/dm-vdo/memory-alloc.c
+++ b/drivers/md/dm-vdo/memory-alloc.c
@@ -150,7 +150,7 @@ static void remove_vmalloc_block(void *ptr)
 	if (block != NULL)
 		vdo_free(block);
 	else
-		uds_log_info("attempting to remove ptr %px not found in vmalloc list", ptr);
+		vdo_log_info("attempting to remove ptr %px not found in vmalloc list", ptr);
 }
 
 /*
@@ -284,7 +284,7 @@ int vdo_allocate_memory(size_t size, size_t align, const char *what, void *ptr)
 		memalloc_noio_restore(noio_flags);
 
 	if (unlikely(p == NULL)) {
-		uds_log_error("Could not allocate %zu bytes for %s in %u msecs",
+		vdo_log_error("Could not allocate %zu bytes for %s in %u msecs",
 			      size, what, jiffies_to_msecs(jiffies - start_time));
 		return -ENOMEM;
 	}
@@ -391,7 +391,7 @@ void vdo_memory_exit(void)
 	VDO_ASSERT_LOG_ONLY(memory_stats.vmalloc_bytes == 0,
 			    "vmalloc memory used (%zd bytes in %zd blocks) is returned to the kernel",
 			    memory_stats.vmalloc_bytes, memory_stats.vmalloc_blocks);
-	uds_log_debug("peak usage %zd bytes", memory_stats.peak_bytes);
+	vdo_log_debug("peak usage %zd bytes", memory_stats.peak_bytes);
 }
 
 void vdo_get_memory_stats(u64 *bytes_used, u64 *peak_bytes_used)
@@ -426,13 +426,13 @@ void vdo_report_memory_usage(void)
 	peak_usage = memory_stats.peak_bytes;
 	spin_unlock_irqrestore(&memory_stats.lock, flags);
 	total_bytes = kmalloc_bytes + vmalloc_bytes;
-	uds_log_info("current module memory tracking (actual allocation sizes, not requested):");
-	uds_log_info("  %llu bytes in %llu kmalloc blocks",
+	vdo_log_info("current module memory tracking (actual allocation sizes, not requested):");
+	vdo_log_info("  %llu bytes in %llu kmalloc blocks",
 		     (unsigned long long) kmalloc_bytes,
 		     (unsigned long long) kmalloc_blocks);
-	uds_log_info("  %llu bytes in %llu vmalloc blocks",
+	vdo_log_info("  %llu bytes in %llu vmalloc blocks",
 		     (unsigned long long) vmalloc_bytes,
 		     (unsigned long long) vmalloc_blocks);
-	uds_log_info("  total %llu bytes, peak usage %llu bytes",
+	vdo_log_info("  total %llu bytes, peak usage %llu bytes",
 		     (unsigned long long) total_bytes, (unsigned long long) peak_usage);
 }
diff --git a/drivers/md/dm-vdo/message-stats.c b/drivers/md/dm-vdo/message-stats.c
index 18c9d2af8aed..2802cf92922b 100644
--- a/drivers/md/dm-vdo/message-stats.c
+++ b/drivers/md/dm-vdo/message-stats.c
@@ -421,7 +421,7 @@ int vdo_write_stats(struct vdo *vdo, char *buf, unsigned int maxlen)
 
 	result = vdo_allocate(1, struct vdo_statistics, __func__, &stats);
 	if (result != VDO_SUCCESS) {
-		uds_log_error("Cannot allocate memory to write VDO statistics");
+		vdo_log_error("Cannot allocate memory to write VDO statistics");
 		return result;
 	}
 
diff --git a/drivers/md/dm-vdo/packer.c b/drivers/md/dm-vdo/packer.c
index 4d45243161a6..16cf29b4c90a 100644
--- a/drivers/md/dm-vdo/packer.c
+++ b/drivers/md/dm-vdo/packer.c
@@ -748,7 +748,7 @@ static void dump_packer_bin(const struct packer_bin *bin, bool canceled)
 		/* Don't dump empty bins. */
 		return;
 
-	uds_log_info("	  %sBin slots_used=%u free_space=%zu",
+	vdo_log_info("	  %sBin slots_used=%u free_space=%zu",
 		     (canceled ? "Canceled" : ""), bin->slots_used, bin->free_space);
 
 	/*
@@ -767,8 +767,8 @@ void vdo_dump_packer(const struct packer *packer)
 {
 	struct packer_bin *bin;
 
-	uds_log_info("packer");
-	uds_log_info("	flushGeneration=%llu state %s  packer_bin_count=%llu",
+	vdo_log_info("packer");
+	vdo_log_info("	flushGeneration=%llu state %s  packer_bin_count=%llu",
 		     (unsigned long long) packer->flush_generation,
 		     vdo_get_admin_state_code(&packer->state)->name,
 		     (unsigned long long) packer->size);
diff --git a/drivers/md/dm-vdo/permassert.c b/drivers/md/dm-vdo/permassert.c
index 6fe49c4b7e51..bf9eccea1cb3 100644
--- a/drivers/md/dm-vdo/permassert.c
+++ b/drivers/md/dm-vdo/permassert.c
@@ -15,10 +15,10 @@ int vdo_assertion_failed(const char *expression_string, const char *file_name,
 
 	va_start(args, format);
 
-	uds_log_embedded_message(UDS_LOG_ERR, UDS_LOGGING_MODULE_NAME, "assertion \"",
+	vdo_log_embedded_message(VDO_LOG_ERR, VDO_LOGGING_MODULE_NAME, "assertion \"",
 				 format, args, "\" (%s) failed at %s:%d",
 				 expression_string, file_name, line_number);
-	uds_log_backtrace(UDS_LOG_ERR);
+	vdo_log_backtrace(VDO_LOG_ERR);
 
 	va_end(args);
 
diff --git a/drivers/md/dm-vdo/physical-zone.c b/drivers/md/dm-vdo/physical-zone.c
index 6678f472fb44..2fee3a7c1191 100644
--- a/drivers/md/dm-vdo/physical-zone.c
+++ b/drivers/md/dm-vdo/physical-zone.c
@@ -163,7 +163,7 @@ static void release_pbn_lock_provisional_reference(struct pbn_lock *lock,
 
 	result = vdo_release_block_reference(allocator, locked_pbn);
 	if (result != VDO_SUCCESS) {
-		uds_log_error_strerror(result,
+		vdo_log_error_strerror(result,
 				       "Failed to release reference to %s physical block %llu",
 				       lock->implementation->release_reason,
 				       (unsigned long long) locked_pbn);
@@ -294,7 +294,7 @@ static int __must_check borrow_pbn_lock_from_pool(struct pbn_lock_pool *pool,
 	idle_pbn_lock *idle;
 
 	if (pool->borrowed >= pool->capacity)
-		return uds_log_error_strerror(VDO_LOCK_ERROR,
+		return vdo_log_error_strerror(VDO_LOCK_ERROR,
 					      "no free PBN locks left to borrow");
 	pool->borrowed += 1;
 
@@ -499,7 +499,7 @@ static int allocate_and_lock_block(struct allocation *allocation)
 
 	if (lock->holder_count > 0) {
 		/* This block is already locked, which should be impossible. */
-		return uds_log_error_strerror(VDO_LOCK_ERROR,
+		return vdo_log_error_strerror(VDO_LOCK_ERROR,
 					      "Newly allocated block %llu was spuriously locked (holder_count=%u)",
 					      (unsigned long long) allocation->pbn,
 					      lock->holder_count);
diff --git a/drivers/md/dm-vdo/recovery-journal.c b/drivers/md/dm-vdo/recovery-journal.c
index 6df373b88042..ee6321a3e523 100644
--- a/drivers/md/dm-vdo/recovery-journal.c
+++ b/drivers/md/dm-vdo/recovery-journal.c
@@ -804,7 +804,7 @@ void vdo_free_recovery_journal(struct recovery_journal *journal)
 				    "journal being freed has no active tail blocks");
 	} else if (!vdo_is_state_saved(&journal->state) &&
 		   !list_empty(&journal->active_tail_blocks)) {
-		uds_log_warning("journal being freed has uncommitted entries");
+		vdo_log_warning("journal being freed has uncommitted entries");
 	}
 
 	for (i = 0; i < RECOVERY_JOURNAL_RESERVED_BLOCKS; i++) {
@@ -1305,7 +1305,7 @@ static void handle_write_error(struct vdo_completion *completion)
 	struct recovery_journal *journal = block->journal;
 
 	vio_record_metadata_io_error(as_vio(completion));
-	uds_log_error_strerror(completion->result,
+	vdo_log_error_strerror(completion->result,
 			       "cannot write recovery journal block %llu",
 			       (unsigned long long) block->sequence_number);
 	enter_journal_read_only_mode(journal, completion->result);
@@ -1719,7 +1719,7 @@ vdo_get_recovery_journal_statistics(const struct recovery_journal *journal)
  */
 static void dump_recovery_block(const struct recovery_journal_block *block)
 {
-	uds_log_info("    sequence number %llu; entries %u; %s; %zu entry waiters; %zu commit waiters",
+	vdo_log_info("    sequence number %llu; entries %u; %s; %zu entry waiters; %zu commit waiters",
 		     (unsigned long long) block->sequence_number, block->entry_count,
 		     (block->committing ? "committing" : "waiting"),
 		     vdo_waitq_num_waiters(&block->entry_waiters),
@@ -1736,8 +1736,8 @@ void vdo_dump_recovery_journal_statistics(const struct recovery_journal *journal
 	const struct recovery_journal_block *block;
 	struct recovery_journal_statistics stats = vdo_get_recovery_journal_statistics(journal);
 
-	uds_log_info("Recovery Journal");
-	uds_log_info("	block_map_head=%llu slab_journal_head=%llu last_write_acknowledged=%llu tail=%llu block_map_reap_head=%llu slab_journal_reap_head=%llu disk_full=%llu slab_journal_commits_requested=%llu entry_waiters=%zu",
+	vdo_log_info("Recovery Journal");
+	vdo_log_info("	block_map_head=%llu slab_journal_head=%llu last_write_acknowledged=%llu tail=%llu block_map_reap_head=%llu slab_journal_reap_head=%llu disk_full=%llu slab_journal_commits_requested=%llu entry_waiters=%zu",
 		     (unsigned long long) journal->block_map_head,
 		     (unsigned long long) journal->slab_journal_head,
 		     (unsigned long long) journal->last_write_acknowledged,
@@ -1747,16 +1747,16 @@ void vdo_dump_recovery_journal_statistics(const struct recovery_journal *journal
 		     (unsigned long long) stats.disk_full,
 		     (unsigned long long) stats.slab_journal_commits_requested,
 		     vdo_waitq_num_waiters(&journal->entry_waiters));
-	uds_log_info("	entries: started=%llu written=%llu committed=%llu",
+	vdo_log_info("	entries: started=%llu written=%llu committed=%llu",
 		     (unsigned long long) stats.entries.started,
 		     (unsigned long long) stats.entries.written,
 		     (unsigned long long) stats.entries.committed);
-	uds_log_info("	blocks: started=%llu written=%llu committed=%llu",
+	vdo_log_info("	blocks: started=%llu written=%llu committed=%llu",
 		     (unsigned long long) stats.blocks.started,
 		     (unsigned long long) stats.blocks.written,
 		     (unsigned long long) stats.blocks.committed);
 
-	uds_log_info("	active blocks:");
+	vdo_log_info("	active blocks:");
 	list_for_each_entry(block, &journal->active_tail_blocks, list_node)
 		dump_recovery_block(block);
 }
diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
index c7abb8078336..defc9359f10e 100644
--- a/drivers/md/dm-vdo/repair.c
+++ b/drivers/md/dm-vdo/repair.c
@@ -265,13 +265,13 @@ static void finish_repair(struct vdo_completion *completion)
 	free_repair_completion(vdo_forget(repair));
 
 	if (vdo_state_requires_read_only_rebuild(vdo->load_state)) {
-		uds_log_info("Read-only rebuild complete");
+		vdo_log_info("Read-only rebuild complete");
 		vdo_launch_completion(parent);
 		return;
 	}
 
 	/* FIXME: shouldn't this say either "recovery" or "repair"? */
-	uds_log_info("Rebuild complete");
+	vdo_log_info("Rebuild complete");
 
 	/*
 	 * Now that we've freed the repair completion and its vast array of journal entries, we
@@ -291,9 +291,9 @@ static void abort_repair(struct vdo_completion *completion)
 	struct repair_completion *repair = as_repair_completion(completion);
 
 	if (vdo_state_requires_read_only_rebuild(completion->vdo->load_state))
-		uds_log_info("Read-only rebuild aborted");
+		vdo_log_info("Read-only rebuild aborted");
 	else
-		uds_log_warning("Recovery aborted");
+		vdo_log_warning("Recovery aborted");
 
 	free_repair_completion(vdo_forget(repair));
 	vdo_continue_completion(parent, result);
@@ -329,10 +329,10 @@ static void drain_slab_depot(struct vdo_completion *completion)
 
 	prepare_repair_completion(repair, finish_repair, VDO_ZONE_TYPE_ADMIN);
 	if (vdo_state_requires_read_only_rebuild(vdo->load_state)) {
-		uds_log_info("Saving rebuilt state");
+		vdo_log_info("Saving rebuilt state");
 		operation = VDO_ADMIN_STATE_REBUILDING;
 	} else {
-		uds_log_info("Replayed %zu journal entries into slab journals",
+		vdo_log_info("Replayed %zu journal entries into slab journals",
 			     repair->entries_added_to_slab_journals);
 		operation = VDO_ADMIN_STATE_RECOVERING;
 	}
@@ -350,7 +350,7 @@ static void flush_block_map_updates(struct vdo_completion *completion)
 {
 	vdo_assert_on_admin_thread(completion->vdo, __func__);
 
-	uds_log_info("Flushing block map changes");
+	vdo_log_info("Flushing block map changes");
 	prepare_repair_completion(as_repair_completion(completion), drain_slab_depot,
 				  VDO_ZONE_TYPE_ADMIN);
 	vdo_drain_block_map(completion->vdo->block_map, VDO_ADMIN_STATE_RECOVERING,
@@ -449,7 +449,7 @@ static bool process_slot(struct block_map_page *page, struct vdo_completion *com
 	if (result == VDO_SUCCESS)
 		return true;
 
-	uds_log_error_strerror(result,
+	vdo_log_error_strerror(result,
 			       "Could not adjust reference count for PBN %llu, slot %u mapped to PBN %llu",
 			       (unsigned long long) vdo_get_block_map_page_pbn(page),
 			       slot, (unsigned long long) mapping.pbn);
@@ -615,7 +615,7 @@ static int process_entry(physical_block_number_t pbn, struct vdo_completion *com
 	int result;
 
 	if ((pbn == VDO_ZERO_BLOCK) || !vdo_is_physical_data_block(depot, pbn)) {
-		return uds_log_error_strerror(VDO_BAD_CONFIGURATION,
+		return vdo_log_error_strerror(VDO_BAD_CONFIGURATION,
 					      "PBN %llu out of range",
 					      (unsigned long long) pbn);
 	}
@@ -623,7 +623,7 @@ static int process_entry(physical_block_number_t pbn, struct vdo_completion *com
 	result = vdo_adjust_reference_count_for_rebuild(depot, pbn,
 							VDO_JOURNAL_BLOCK_MAP_REMAPPING);
 	if (result != VDO_SUCCESS) {
-		return uds_log_error_strerror(result,
+		return vdo_log_error_strerror(result,
 					      "Could not adjust reference count for block map tree PBN %llu",
 					      (unsigned long long) pbn);
 	}
@@ -758,7 +758,7 @@ static int validate_recovery_journal_entry(const struct vdo *vdo,
 	    !vdo_is_valid_location(&entry->unmapping) ||
 	    !vdo_is_physical_data_block(vdo->depot, entry->mapping.pbn) ||
 	    !vdo_is_physical_data_block(vdo->depot, entry->unmapping.pbn)) {
-		return uds_log_error_strerror(VDO_CORRUPT_JOURNAL,
+		return vdo_log_error_strerror(VDO_CORRUPT_JOURNAL,
 					      "Invalid entry: %s (%llu, %u) from %llu to %llu is not within bounds",
 					      vdo_get_journal_operation_name(entry->operation),
 					      (unsigned long long) entry->slot.pbn,
@@ -772,7 +772,7 @@ static int validate_recovery_journal_entry(const struct vdo *vdo,
 	     (entry->mapping.pbn == VDO_ZERO_BLOCK) ||
 	     (entry->unmapping.state != VDO_MAPPING_STATE_UNMAPPED) ||
 	     (entry->unmapping.pbn != VDO_ZERO_BLOCK))) {
-		return uds_log_error_strerror(VDO_CORRUPT_JOURNAL,
+		return vdo_log_error_strerror(VDO_CORRUPT_JOURNAL,
 					      "Invalid entry: %s (%llu, %u) from %llu to %llu is not a valid tree mapping",
 					      vdo_get_journal_operation_name(entry->operation),
 					      (unsigned long long) entry->slot.pbn,
@@ -875,7 +875,7 @@ void vdo_replay_into_slab_journals(struct block_allocator *allocator, void *cont
 		.entry_count = 0,
 	};
 
-	uds_log_info("Replaying entries into slab journals for zone %u",
+	vdo_log_info("Replaying entries into slab journals for zone %u",
 		     allocator->zone_number);
 	completion->parent = repair;
 	add_slab_journal_entries(completion);
@@ -907,7 +907,7 @@ static void flush_block_map(struct vdo_completion *completion)
 
 	vdo_assert_on_admin_thread(completion->vdo, __func__);
 
-	uds_log_info("Flushing block map changes");
+	vdo_log_info("Flushing block map changes");
 	prepare_repair_completion(repair, load_slab_depot, VDO_ZONE_TYPE_ADMIN);
 	operation = (vdo_state_requires_read_only_rebuild(completion->vdo->load_state) ?
 		     VDO_ADMIN_STATE_REBUILDING :
@@ -1107,7 +1107,7 @@ static void recover_block_map(struct vdo_completion *completion)
 		vdo_state_requires_read_only_rebuild(vdo->load_state);
 
 	if (repair->block_map_entry_count == 0) {
-		uds_log_info("Replaying 0 recovery entries into block map");
+		vdo_log_info("Replaying 0 recovery entries into block map");
 		vdo_free(vdo_forget(repair->journal_data));
 		launch_repair_completion(repair, load_slab_depot, VDO_ZONE_TYPE_ADMIN);
 		return;
@@ -1124,7 +1124,7 @@ static void recover_block_map(struct vdo_completion *completion)
 	};
 	min_heapify_all(&repair->replay_heap, &repair_min_heap);
 
-	uds_log_info("Replaying %zu recovery entries into block map",
+	vdo_log_info("Replaying %zu recovery entries into block map",
 		     repair->block_map_entry_count);
 
 	repair->current_entry = &repair->entries[repair->block_map_entry_count - 1];
@@ -1437,7 +1437,7 @@ static int validate_heads(struct repair_completion *repair)
 		return VDO_SUCCESS;
 
 
-	return uds_log_error_strerror(VDO_CORRUPT_JOURNAL,
+	return vdo_log_error_strerror(VDO_CORRUPT_JOURNAL,
 				      "Journal tail too early. block map head: %llu, slab journal head: %llu, tail: %llu",
 				      (unsigned long long) repair->block_map_head,
 				      (unsigned long long) repair->slab_journal_head,
@@ -1571,7 +1571,7 @@ static int parse_journal_for_recovery(struct repair_completion *repair)
 		header = get_recovery_journal_block_header(journal, repair->journal_data, i);
 		if (header.metadata_type == VDO_METADATA_RECOVERY_JOURNAL) {
 			/* This is an old format block, so we need to upgrade */
-			uds_log_error_strerror(VDO_UNSUPPORTED_VERSION,
+			vdo_log_error_strerror(VDO_UNSUPPORTED_VERSION,
 					       "Recovery journal is in the old format, a read-only rebuild is required.");
 			vdo_enter_read_only_mode(repair->completion.vdo,
 						 VDO_UNSUPPORTED_VERSION);
@@ -1628,7 +1628,7 @@ static int parse_journal_for_recovery(struct repair_completion *repair)
 	if (result != VDO_SUCCESS)
 		return result;
 
-	uds_log_info("Highest-numbered recovery journal block has sequence number %llu, and the highest-numbered usable block is %llu",
+	vdo_log_info("Highest-numbered recovery journal block has sequence number %llu, and the highest-numbered usable block is %llu",
 		     (unsigned long long) repair->highest_tail,
 		     (unsigned long long) repair->tail);
 
@@ -1656,7 +1656,7 @@ static void finish_journal_load(struct vdo_completion *completion)
 	if (++repair->vios_complete != repair->vio_count)
 		return;
 
-	uds_log_info("Finished reading recovery journal");
+	vdo_log_info("Finished reading recovery journal");
 	uninitialize_vios(repair);
 	prepare_repair_completion(repair, recover_block_map, VDO_ZONE_TYPE_LOGICAL);
 	vdo_continue_completion(&repair->completion, parse_journal(repair));
@@ -1701,12 +1701,12 @@ void vdo_repair(struct vdo_completion *parent)
 	vdo_assert_on_admin_thread(vdo, __func__);
 
 	if (vdo->load_state == VDO_FORCE_REBUILD) {
-		uds_log_warning("Rebuilding reference counts to clear read-only mode");
+		vdo_log_warning("Rebuilding reference counts to clear read-only mode");
 		vdo->states.vdo.read_only_recoveries++;
 	} else if (vdo->load_state == VDO_REBUILD_FOR_UPGRADE) {
-		uds_log_warning("Rebuilding reference counts for upgrade");
+		vdo_log_warning("Rebuilding reference counts for upgrade");
 	} else {
-		uds_log_warning("Device was dirty, rebuilding reference counts");
+		vdo_log_warning("Device was dirty, rebuilding reference counts");
 	}
 
 	result = vdo_allocate_extended(struct repair_completion, page_count,
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 00746de09c12..dc9f3d3c3995 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -568,7 +568,7 @@ static void release_journal_locks(struct vdo_waiter *waiter, void *context)
 			 * Don't bother logging what might be lots of errors if we are already in
 			 * read-only mode.
 			 */
-			uds_log_error_strerror(result, "failed slab summary update %llu",
+			vdo_log_error_strerror(result, "failed slab summary update %llu",
 					       (unsigned long long) journal->summarized);
 		}
 
@@ -702,7 +702,7 @@ static void complete_write(struct vdo_completion *completion)
 
 	if (result != VDO_SUCCESS) {
 		vio_record_metadata_io_error(as_vio(completion));
-		uds_log_error_strerror(result, "cannot write slab journal block %llu",
+		vdo_log_error_strerror(result, "cannot write slab journal block %llu",
 				       (unsigned long long) committed);
 		vdo_enter_read_only_mode(journal->slab->allocator->depot->vdo, result);
 		check_if_slab_drained(journal->slab);
@@ -1020,7 +1020,7 @@ static void finish_summary_update(struct vdo_waiter *waiter, void *context)
 	slab->active_count--;
 
 	if ((result != VDO_SUCCESS) && (result != VDO_READ_ONLY)) {
-		uds_log_error_strerror(result, "failed to update slab summary");
+		vdo_log_error_strerror(result, "failed to update slab summary");
 		vdo_enter_read_only_mode(slab->allocator->depot->vdo, result);
 	}
 
@@ -1440,7 +1440,7 @@ static int increment_for_data(struct vdo_slab *slab, struct reference_block *blo
 	default:
 		/* Single or shared */
 		if (*counter_ptr >= MAXIMUM_REFERENCE_COUNT) {
-			return uds_log_error_strerror(VDO_REF_COUNT_INVALID,
+			return vdo_log_error_strerror(VDO_REF_COUNT_INVALID,
 						      "Incrementing a block already having 254 references (slab %u, offset %u)",
 						      slab->slab_number, block_number);
 		}
@@ -1473,7 +1473,7 @@ static int decrement_for_data(struct vdo_slab *slab, struct reference_block *blo
 {
 	switch (old_status) {
 	case RS_FREE:
-		return uds_log_error_strerror(VDO_REF_COUNT_INVALID,
+		return vdo_log_error_strerror(VDO_REF_COUNT_INVALID,
 					      "Decrementing free block at offset %u in slab %u",
 					      block_number, slab->slab_number);
 
@@ -1537,7 +1537,7 @@ static int increment_for_block_map(struct vdo_slab *slab, struct reference_block
 	switch (old_status) {
 	case RS_FREE:
 		if (normal_operation) {
-			return uds_log_error_strerror(VDO_REF_COUNT_INVALID,
+			return vdo_log_error_strerror(VDO_REF_COUNT_INVALID,
 						      "Incrementing unallocated block map block (slab %u, offset %u)",
 						      slab->slab_number, block_number);
 		}
@@ -1552,7 +1552,7 @@ static int increment_for_block_map(struct vdo_slab *slab, struct reference_block
 
 	case RS_PROVISIONAL:
 		if (!normal_operation)
-			return uds_log_error_strerror(VDO_REF_COUNT_INVALID,
+			return vdo_log_error_strerror(VDO_REF_COUNT_INVALID,
 						      "Block map block had provisional reference during replay (slab %u, offset %u)",
 						      slab->slab_number, block_number);
 
@@ -1562,7 +1562,7 @@ static int increment_for_block_map(struct vdo_slab *slab, struct reference_block
 		return VDO_SUCCESS;
 
 	default:
-		return uds_log_error_strerror(VDO_REF_COUNT_INVALID,
+		return vdo_log_error_strerror(VDO_REF_COUNT_INVALID,
 					      "Incrementing a block map block which is already referenced %u times (slab %u, offset %u)",
 					      *counter_ptr, slab->slab_number,
 					      block_number);
@@ -2219,7 +2219,7 @@ static void unpack_reference_block(struct packed_reference_block *packed,
 					  block->commit_points[i])) {
 			size_t block_index = block - block->slab->reference_blocks;
 
-			uds_log_warning("Torn write detected in sector %u of reference block %zu of slab %u",
+			vdo_log_warning("Torn write detected in sector %u of reference block %zu of slab %u",
 					i, block_index, block->slab->slab_number);
 		}
 	}
@@ -2698,9 +2698,9 @@ static void finish_scrubbing(struct slab_scrubber *scrubber, int result)
 		 * thread does not yet know about.
 		 */
 		if (prior_state == VDO_DIRTY)
-			uds_log_info("VDO commencing normal operation");
+			vdo_log_info("VDO commencing normal operation");
 		else if (prior_state == VDO_RECOVERING)
-			uds_log_info("Exiting recovery mode");
+			vdo_log_info("Exiting recovery mode");
 	}
 
 	/*
@@ -2790,7 +2790,7 @@ static int apply_block_entries(struct packed_slab_journal_block *block,
 
 		if (entry.sbn > max_sbn) {
 			/* This entry is out of bounds. */
-			return uds_log_error_strerror(VDO_CORRUPT_JOURNAL,
+			return vdo_log_error_strerror(VDO_CORRUPT_JOURNAL,
 						      "vdo_slab journal entry (%llu, %u) had invalid offset %u in slab (size %u blocks)",
 						      (unsigned long long) block_number,
 						      entry_point.entry_count,
@@ -2799,7 +2799,7 @@ static int apply_block_entries(struct packed_slab_journal_block *block,
 
 		result = replay_reference_count_change(slab, &entry_point, entry);
 		if (result != VDO_SUCCESS) {
-			uds_log_error_strerror(result,
+			vdo_log_error_strerror(result,
 					       "vdo_slab journal entry (%llu, %u) (%s of offset %u) could not be applied in slab %u",
 					       (unsigned long long) block_number,
 					       entry_point.entry_count,
@@ -2857,7 +2857,7 @@ static void apply_journal_entries(struct vdo_completion *completion)
 		    (header.has_block_map_increments &&
 		     (header.entry_count > journal->full_entries_per_block))) {
 			/* The block is not what we expect it to be. */
-			uds_log_error("vdo_slab journal block for slab %u was invalid",
+			vdo_log_error("vdo_slab journal block for slab %u was invalid",
 				      slab->slab_number);
 			abort_scrubbing(scrubber, VDO_CORRUPT_JOURNAL);
 			return;
@@ -3580,22 +3580,22 @@ void vdo_dump_block_allocator(const struct block_allocator *allocator)
 	struct slab_iterator iterator = get_slab_iterator(allocator);
 	const struct slab_scrubber *scrubber = &allocator->scrubber;
 
-	uds_log_info("block_allocator zone %u", allocator->zone_number);
+	vdo_log_info("block_allocator zone %u", allocator->zone_number);
 	while (iterator.next != NULL) {
 		struct vdo_slab *slab = next_slab(&iterator);
 		struct slab_journal *journal = &slab->journal;
 
 		if (slab->reference_blocks != NULL) {
 			/* Terse because there are a lot of slabs to dump and syslog is lossy. */
-			uds_log_info("slab %u: P%u, %llu free", slab->slab_number,
+			vdo_log_info("slab %u: P%u, %llu free", slab->slab_number,
 				     slab->priority,
 				     (unsigned long long) slab->free_blocks);
 		} else {
-			uds_log_info("slab %u: status %s", slab->slab_number,
+			vdo_log_info("slab %u: status %s", slab->slab_number,
 				     status_to_string(slab->status));
 		}
 
-		uds_log_info("  slab journal: entry_waiters=%zu waiting_to_commit=%s updating_slab_summary=%s head=%llu unreapable=%llu tail=%llu next_commit=%llu summarized=%llu last_summarized=%llu recovery_lock=%llu dirty=%s",
+		vdo_log_info("  slab journal: entry_waiters=%zu waiting_to_commit=%s updating_slab_summary=%s head=%llu unreapable=%llu tail=%llu next_commit=%llu summarized=%llu last_summarized=%llu recovery_lock=%llu dirty=%s",
 			     vdo_waitq_num_waiters(&journal->entry_waiters),
 			     uds_bool_to_string(journal->waiting_to_commit),
 			     uds_bool_to_string(journal->updating_slab_summary),
@@ -3614,7 +3614,7 @@ void vdo_dump_block_allocator(const struct block_allocator *allocator)
 
 		if (slab->counters != NULL) {
 			/* Terse because there are a lot of slabs to dump and syslog is lossy. */
-			uds_log_info("  slab: free=%u/%u blocks=%u dirty=%zu active=%zu journal@(%llu,%u)",
+			vdo_log_info("  slab: free=%u/%u blocks=%u dirty=%zu active=%zu journal@(%llu,%u)",
 				     slab->free_blocks, slab->block_count,
 				     slab->reference_block_count,
 				     vdo_waitq_num_waiters(&slab->dirty_blocks),
@@ -3622,7 +3622,7 @@ void vdo_dump_block_allocator(const struct block_allocator *allocator)
 				     (unsigned long long) slab->slab_journal_point.sequence_number,
 				     slab->slab_journal_point.entry_count);
 		} else {
-			uds_log_info("  no counters");
+			vdo_log_info("  no counters");
 		}
 
 		/*
@@ -3631,11 +3631,11 @@ void vdo_dump_block_allocator(const struct block_allocator *allocator)
 		 */
 		if (pause_counter++ == 31) {
 			pause_counter = 0;
-			uds_pause_for_logger();
+			vdo_pause_for_logger();
 		}
 	}
 
-	uds_log_info("slab_scrubber slab_count %u waiters %zu %s%s",
+	vdo_log_info("slab_scrubber slab_count %u waiters %zu %s%s",
 		     READ_ONCE(scrubber->slab_count),
 		     vdo_waitq_num_waiters(&scrubber->waiters),
 		     vdo_get_admin_state_code(&scrubber->admin_state)->name,
@@ -4109,7 +4109,7 @@ static int allocate_components(struct slab_depot *depot,
 	slab_count = vdo_compute_slab_count(depot->first_block, depot->last_block,
 					    depot->slab_size_shift);
 	if (thread_config->physical_zone_count > slab_count) {
-		return uds_log_error_strerror(VDO_BAD_CONFIGURATION,
+		return vdo_log_error_strerror(VDO_BAD_CONFIGURATION,
 					      "%u physical zones exceeds slab count %u",
 					      thread_config->physical_zone_count,
 					      slab_count);
@@ -4167,7 +4167,7 @@ int vdo_decode_slab_depot(struct slab_depot_state_2_0 state, struct vdo *vdo,
 	block_count_t slab_size = state.slab_config.slab_blocks;
 
 	if (!is_power_of_2(slab_size)) {
-		return uds_log_error_strerror(UDS_INVALID_ARGUMENT,
+		return vdo_log_error_strerror(UDS_INVALID_ARGUMENT,
 					      "slab size must be a power of two");
 	}
 	slab_size_shift = ilog2(slab_size);
@@ -4676,7 +4676,7 @@ int vdo_prepare_to_grow_slab_depot(struct slab_depot *depot,
 						new_state.last_block,
 						depot->slab_size_shift);
 	if (new_slab_count <= depot->slab_count)
-		return uds_log_error_strerror(VDO_INCREMENT_TOO_SMALL,
+		return vdo_log_error_strerror(VDO_INCREMENT_TOO_SMALL,
 					      "Depot can only grow");
 	if (new_slab_count == depot->new_slab_count) {
 		/* Check it out, we've already got all the new slabs allocated! */
@@ -5092,8 +5092,8 @@ void vdo_get_slab_depot_statistics(const struct slab_depot *depot,
  */
 void vdo_dump_slab_depot(const struct slab_depot *depot)
 {
-	uds_log_info("vdo slab depot");
-	uds_log_info("  zone_count=%u old_zone_count=%u slabCount=%u active_release_request=%llu new_release_request=%llu",
+	vdo_log_info("vdo slab depot");
+	vdo_log_info("  zone_count=%u old_zone_count=%u slabCount=%u active_release_request=%llu new_release_request=%llu",
 		     (unsigned int) depot->zone_count,
 		     (unsigned int) depot->old_zone_count, READ_ONCE(depot->slab_count),
 		     (unsigned long long) depot->active_release_request,
diff --git a/drivers/md/dm-vdo/status-codes.c b/drivers/md/dm-vdo/status-codes.c
index 42e87b2344bc..918e46e7121f 100644
--- a/drivers/md/dm-vdo/status-codes.c
+++ b/drivers/md/dm-vdo/status-codes.c
@@ -87,8 +87,8 @@ int vdo_register_status_codes(void)
  */
 int vdo_status_to_errno(int error)
 {
-	char error_name[UDS_MAX_ERROR_NAME_SIZE];
-	char error_message[UDS_MAX_ERROR_MESSAGE_SIZE];
+	char error_name[VDO_MAX_ERROR_NAME_SIZE];
+	char error_message[VDO_MAX_ERROR_MESSAGE_SIZE];
 
 	/* 0 is success, negative a system error code */
 	if (likely(error <= 0))
@@ -103,7 +103,7 @@ int vdo_status_to_errno(int error)
 	case VDO_READ_ONLY:
 		return -EIO;
 	default:
-		uds_log_info("%s: mapping internal status code %d (%s: %s) to EIO",
+		vdo_log_info("%s: mapping internal status code %d (%s: %s) to EIO",
 			     __func__, error,
 			     uds_string_error_name(error, error_name, sizeof(error_name)),
 			     uds_string_error(error, error_message, sizeof(error_message)));
diff --git a/drivers/md/dm-vdo/thread-utils.c b/drivers/md/dm-vdo/thread-utils.c
index c822df86f731..bd620be61c1d 100644
--- a/drivers/md/dm-vdo/thread-utils.c
+++ b/drivers/md/dm-vdo/thread-utils.c
@@ -84,7 +84,7 @@ int vdo_create_thread(void (*thread_function)(void *), void *thread_data,
 
 	result = vdo_allocate(1, struct thread, __func__, &thread);
 	if (result != VDO_SUCCESS) {
-		uds_log_warning("Error allocating memory for %s", name);
+		vdo_log_warning("Error allocating memory for %s", name);
 		return result;
 	}
 
diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index 28e6352c758e..fff847767755 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -304,7 +304,7 @@ static int __must_check read_geometry_block(struct vdo *vdo)
 	result = blk_status_to_errno(vio->bio->bi_status);
 	free_vio(vdo_forget(vio));
 	if (result != 0) {
-		uds_log_error_strerror(result, "synchronous read failed");
+		vdo_log_error_strerror(result, "synchronous read failed");
 		vdo_free(block);
 		return -EIO;
 	}
@@ -493,7 +493,7 @@ static int initialize_vdo(struct vdo *vdo, struct device_config *config,
 		return result;
 	}
 
-	uds_log_info("zones: %d logical, %d physical, %d hash; total threads: %d",
+	vdo_log_info("zones: %d logical, %d physical, %d hash; total threads: %d",
 		     config->thread_counts.logical_zones,
 		     config->thread_counts.physical_zones,
 		     config->thread_counts.hash_zones, vdo->thread_config.thread_count);
@@ -841,7 +841,7 @@ int vdo_synchronous_flush(struct vdo *vdo)
 
 	atomic64_inc(&vdo->stats.flush_out);
 	if (result != 0) {
-		uds_log_error_strerror(result, "synchronous flush failed");
+		vdo_log_error_strerror(result, "synchronous flush failed");
 		result = -EIO;
 	}
 
@@ -928,7 +928,7 @@ static void handle_save_error(struct vdo_completion *completion)
 		container_of(as_vio(completion), struct vdo_super_block, vio);
 
 	vio_record_metadata_io_error(&super_block->vio);
-	uds_log_error_strerror(completion->result, "super block save failed");
+	vdo_log_error_strerror(completion->result, "super block save failed");
 	/*
 	 * Mark the super block as unwritable so that we won't attempt to write it again. This
 	 * avoids the case where a growth attempt fails writing the super block with the new size,
@@ -1154,7 +1154,7 @@ static void make_thread_read_only(struct vdo_completion *completion)
 		thread->is_read_only = true;
 		listener = thread->listeners;
 		if (thread_id == 0)
-			uds_log_error_strerror(READ_ONCE(notifier->read_only_error),
+			vdo_log_error_strerror(READ_ONCE(notifier->read_only_error),
 					       "Unrecoverable error, entering read-only mode");
 	} else {
 		/* We've just finished notifying a listener */
@@ -1329,7 +1329,7 @@ void vdo_enter_recovery_mode(struct vdo *vdo)
 	if (vdo_in_read_only_mode(vdo))
 		return;
 
-	uds_log_info("Entering recovery mode");
+	vdo_log_info("Entering recovery mode");
 	vdo_set_state(vdo, VDO_RECOVERING);
 }
 
@@ -1382,7 +1382,7 @@ static void set_compression_callback(struct vdo_completion *completion)
 		}
 	}
 
-	uds_log_info("compression is %s", (*enable ? "enabled" : "disabled"));
+	vdo_log_info("compression is %s", (*enable ? "enabled" : "disabled"));
 	*enable = was_enabled;
 	complete_synchronous_action(completion);
 }
diff --git a/drivers/md/dm-vdo/vio.c b/drivers/md/dm-vdo/vio.c
index b1e4e604c2c3..b291578f726f 100644
--- a/drivers/md/dm-vdo/vio.c
+++ b/drivers/md/dm-vdo/vio.c
@@ -131,7 +131,7 @@ int create_multi_block_metadata_vio(struct vdo *vdo, enum vio_type vio_type,
 	 */
 	result = vdo_allocate(1, struct vio, __func__, &vio);
 	if (result != VDO_SUCCESS) {
-		uds_log_error("metadata vio allocation failure %d", result);
+		vdo_log_error("metadata vio allocation failure %d", result);
 		return result;
 	}
 
@@ -225,7 +225,7 @@ int vio_reset_bio(struct vio *vio, char *data, bio_end_io_t callback,
 		bytes_added = bio_add_page(bio, page, bytes, offset);
 
 		if (bytes_added != bytes) {
-			return uds_log_error_strerror(VDO_BIO_CREATION_FAILED,
+			return vdo_log_error_strerror(VDO_BIO_CREATION_FAILED,
 						      "Could only add %i bytes to bio",
 						      bytes_added);
 		}
@@ -258,18 +258,18 @@ void update_vio_error_stats(struct vio *vio, const char *format, ...)
 
 	case VDO_NO_SPACE:
 		atomic64_inc(&vdo->stats.no_space_error_count);
-		priority = UDS_LOG_DEBUG;
+		priority = VDO_LOG_DEBUG;
 		break;
 
 	default:
-		priority = UDS_LOG_ERR;
+		priority = VDO_LOG_ERR;
 	}
 
 	if (!__ratelimit(&error_limiter))
 		return;
 
 	va_start(args, format);
-	uds_vlog_strerror(priority, vio->completion.result, UDS_LOGGING_MODULE_NAME,
+	vdo_vlog_strerror(priority, vio->completion.result, VDO_LOGGING_MODULE_NAME,
 			  format, args);
 	va_end(args);
 }
-- 
2.42.0

