Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C1A50A88
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267944; cv=none; b=iOlgXP4G3LljSwXvXOEnQGl/buJ1YFdcbhf6AbPV6lVg1b/huJONW5kTIofn86A+70iQUhCYiLRTxMKtt/9sCCwvvGHN+l+keyeRXlAAcA96rFaCVdlGExacNecp38UhIGT+7yyteyh3BdUukt2uzRIRqjnKVGaUSNoLhVNnxkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267944; c=relaxed/simple;
	bh=AkoUG2fyDMjLKQaLtJW8aQeTH775Sm/P/9SKHLjMGEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fjx3371OMz2Ic0IVYCnEsvci1aRVhf16+Y0Aso6mXUWi7lQuoUGYoXWC95ER3awxUiU9jJLUv/ZK6icONTy2I5hQ9BCs/2LxjxLn0vZsrEqBLk5L0obihK58/DoogZvkUbmpPH+hIFG0yrBxetGesv9gnfBo2pAIGAuyaOG01lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H+C+hfso; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H+C+hfso"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yw5Hd7BxZiUufCvj3IIKJrrXP5d3BqS9z8dhY5/+ag4=;
	b=H+C+hfsolFAI8fEzkGcKhAvo2FUnX1Nmi+t5+54ndQ5SUAmRKFJOcT5mDaVB/W+sNldGm5
	mjT1nWEEOht+ftolbq+qXQOc9V0DAOU6j48kCXc2gtdrbBhrTSToP9PS+EW3cNi+GqgwQf
	rXCr5ILZfN+mtokQxvPfjboLUocaC78=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-w-27WFe4P2SFA7zyvGSEQA-1; Thu, 29 Feb 2024 23:38:54 -0500
X-MC-Unique: w-27WFe4P2SFA7zyvGSEQA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8F8B185A782;
	Fri,  1 Mar 2024 04:38:53 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D2E4410793;
	Fri,  1 Mar 2024 04:38:53 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id D02CCA1628; Thu, 29 Feb 2024 23:38:53 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 07/10] dm vdo permassert: audit all of ASSERT to test for VDO_SUCCESS
Date: Thu, 29 Feb 2024 23:38:50 -0500
Message-ID: <de3a33a6d0aa0bf7aee926c3702a2f2877813f00.1709267597.git.msakai@redhat.com>
In-Reply-To: <cover.1709267597.git.msakai@redhat.com>
References: <cover.1709267597.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Also rename ASSERT to VDO_ASSERT and ASSERT_LOG_ONLY to
VDO_ASSERT_LOG_ONLY.

But re-introduce ASSERT and ASSERT_LOG_ONLY as a placeholder
for the benefit of dm-vdo/indexer.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/action-manager.c   |   8 +-
 drivers/md/dm-vdo/block-map.c        | 118 +++++++++----------
 drivers/md/dm-vdo/completion.c       |  10 +-
 drivers/md/dm-vdo/completion.h       |   6 +-
 drivers/md/dm-vdo/data-vio.c         | 108 +++++++++---------
 drivers/md/dm-vdo/data-vio.h         |  68 +++++------
 drivers/md/dm-vdo/dedupe.c           | 165 +++++++++++++--------------
 drivers/md/dm-vdo/dm-vdo-target.c    |  38 +++---
 drivers/md/dm-vdo/encodings.c        | 156 ++++++++++++-------------
 drivers/md/dm-vdo/errors.c           |   5 +-
 drivers/md/dm-vdo/flush.c            |  22 ++--
 drivers/md/dm-vdo/funnel-workqueue.c |  22 ++--
 drivers/md/dm-vdo/io-submitter.c     |   8 +-
 drivers/md/dm-vdo/logical-zone.c     |  22 ++--
 drivers/md/dm-vdo/memory-alloc.c     |  12 +-
 drivers/md/dm-vdo/packer.c           |  12 +-
 drivers/md/dm-vdo/permassert.h       |  15 ++-
 drivers/md/dm-vdo/physical-zone.c    |  48 ++++----
 drivers/md/dm-vdo/priority-table.c   |   4 +-
 drivers/md/dm-vdo/recovery-journal.c |  60 +++++-----
 drivers/md/dm-vdo/repair.c           |  12 +-
 drivers/md/dm-vdo/slab-depot.c       | 116 +++++++++----------
 drivers/md/dm-vdo/thread-registry.c  |   4 +-
 drivers/md/dm-vdo/vdo.c              |  32 +++---
 drivers/md/dm-vdo/vio.c              |  40 +++----
 drivers/md/dm-vdo/vio.h              |   8 +-
 26 files changed, 561 insertions(+), 558 deletions(-)

diff --git a/drivers/md/dm-vdo/action-manager.c b/drivers/md/dm-vdo/action-manager.c
index 709be4c17d27..a0e5e7077d13 100644
--- a/drivers/md/dm-vdo/action-manager.c
+++ b/drivers/md/dm-vdo/action-manager.c
@@ -177,8 +177,8 @@ static void apply_to_zone(struct vdo_completion *completion)
 	zone_count_t zone;
 	struct action_manager *manager = as_action_manager(completion);
 
-	ASSERT_LOG_ONLY((vdo_get_callback_thread_id() == get_acting_zone_thread_id(manager)),
-			"%s() called on acting zones's thread", __func__);
+	VDO_ASSERT_LOG_ONLY((vdo_get_callback_thread_id() == get_acting_zone_thread_id(manager)),
+			    "%s() called on acting zones's thread", __func__);
 
 	zone = manager->acting_zone++;
 	if (manager->acting_zone == manager->zones) {
@@ -357,8 +357,8 @@ bool vdo_schedule_operation_with_context(struct action_manager *manager,
 {
 	struct action *current_action;
 
-	ASSERT_LOG_ONLY((vdo_get_callback_thread_id() == manager->initiator_thread_id),
-			"action initiated from correct thread");
+	VDO_ASSERT_LOG_ONLY((vdo_get_callback_thread_id() == manager->initiator_thread_id),
+			    "action initiated from correct thread");
 	if (!manager->current_action->in_use) {
 		current_action = manager->current_action;
 	} else if (!manager->current_action->next->in_use) {
diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index 320e76527e2b..b70294d8bb61 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -246,16 +246,16 @@ static inline void assert_on_cache_thread(struct vdo_page_cache *cache,
 {
 	thread_id_t thread_id = vdo_get_callback_thread_id();
 
-	ASSERT_LOG_ONLY((thread_id == cache->zone->thread_id),
-			"%s() must only be called on cache thread %d, not thread %d",
-			function_name, cache->zone->thread_id, thread_id);
+	VDO_ASSERT_LOG_ONLY((thread_id == cache->zone->thread_id),
+			    "%s() must only be called on cache thread %d, not thread %d",
+			    function_name, cache->zone->thread_id, thread_id);
 }
 
 /** assert_io_allowed() - Assert that a page cache may issue I/O. */
 static inline void assert_io_allowed(struct vdo_page_cache *cache)
 {
-	ASSERT_LOG_ONLY(!vdo_is_state_quiescent(&cache->zone->state),
-			"VDO page cache may issue I/O");
+	VDO_ASSERT_LOG_ONLY(!vdo_is_state_quiescent(&cache->zone->state),
+			    "VDO page cache may issue I/O");
 }
 
 /** report_cache_pressure() - Log and, if enabled, report cache pressure. */
@@ -287,9 +287,9 @@ static const char * __must_check get_page_state_name(enum vdo_page_buffer_state
 
 	BUILD_BUG_ON(ARRAY_SIZE(state_names) != PAGE_STATE_COUNT);
 
-	result = ASSERT(state < ARRAY_SIZE(state_names),
-			"Unknown page_state value %d", state);
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(state < ARRAY_SIZE(state_names),
+			    "Unknown page_state value %d", state);
+	if (result != VDO_SUCCESS)
 		return "[UNKNOWN PAGE STATE]";
 
 	return state_names[state];
@@ -378,8 +378,8 @@ static int __must_check set_info_pbn(struct page_info *info, physical_block_numb
 	struct vdo_page_cache *cache = info->cache;
 
 	/* Either the new or the old page number must be NO_PAGE. */
-	int result = ASSERT((pbn == NO_PAGE) || (info->pbn == NO_PAGE),
-			    "Must free a page before reusing it.");
+	int result = VDO_ASSERT((pbn == NO_PAGE) || (info->pbn == NO_PAGE),
+				"Must free a page before reusing it.");
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -401,13 +401,13 @@ static int reset_page_info(struct page_info *info)
 {
 	int result;
 
-	result = ASSERT(info->busy == 0, "VDO Page must not be busy");
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(info->busy == 0, "VDO Page must not be busy");
+	if (result != VDO_SUCCESS)
 		return result;
 
-	result = ASSERT(!vdo_waitq_has_waiters(&info->waiting),
-			"VDO Page must not have waiters");
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(!vdo_waitq_has_waiters(&info->waiting),
+			    "VDO Page must not have waiters");
+	if (result != VDO_SUCCESS)
 		return result;
 
 	result = set_info_pbn(info, NO_PAGE);
@@ -592,29 +592,29 @@ static int __must_check validate_completed_page(struct vdo_page_completion *comp
 {
 	int result;
 
-	result = ASSERT(completion->ready, "VDO Page completion not ready");
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(completion->ready, "VDO Page completion not ready");
+	if (result != VDO_SUCCESS)
 		return result;
 
-	result = ASSERT(completion->info != NULL,
-			"VDO Page Completion must be complete");
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(completion->info != NULL,
+			    "VDO Page Completion must be complete");
+	if (result != VDO_SUCCESS)
 		return result;
 
-	result = ASSERT(completion->info->pbn == completion->pbn,
-			"VDO Page Completion pbn must be consistent");
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(completion->info->pbn == completion->pbn,
+			    "VDO Page Completion pbn must be consistent");
+	if (result != VDO_SUCCESS)
 		return result;
 
-	result = ASSERT(is_valid(completion->info),
-			"VDO Page Completion page must be valid");
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(is_valid(completion->info),
+			    "VDO Page Completion page must be valid");
+	if (result != VDO_SUCCESS)
 		return result;
 
 	if (writable) {
-		result = ASSERT(completion->writable,
-				"VDO Page Completion must be writable");
-		if (result != UDS_SUCCESS)
+		result = VDO_ASSERT(completion->writable,
+				    "VDO Page Completion must be writable");
+		if (result != VDO_SUCCESS)
 			return result;
 	}
 
@@ -776,7 +776,7 @@ static int __must_check launch_page_load(struct page_info *info,
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = ASSERT((info->busy == 0), "Page is not busy before loading.");
+	result = VDO_ASSERT((info->busy == 0), "Page is not busy before loading.");
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -949,8 +949,8 @@ static void discard_a_page(struct vdo_page_cache *cache)
 		return;
 	}
 
-	ASSERT_LOG_ONLY(!is_in_flight(info),
-			"page selected for discard is not in flight");
+	VDO_ASSERT_LOG_ONLY(!is_in_flight(info),
+			    "page selected for discard is not in flight");
 
 	cache->discard_count++;
 	info->write_status = WRITE_STATUS_DISCARD;
@@ -1153,8 +1153,8 @@ void vdo_release_page_completion(struct vdo_completion *completion)
 			discard_info = page_completion->info;
 	}
 
-	ASSERT_LOG_ONLY((page_completion->waiter.next_waiter == NULL),
-			"Page being released after leaving all queues");
+	VDO_ASSERT_LOG_ONLY((page_completion->waiter.next_waiter == NULL),
+			    "Page being released after leaving all queues");
 
 	page_completion->info = NULL;
 	cache = page_completion->cache;
@@ -1217,8 +1217,8 @@ void vdo_get_page(struct vdo_page_completion *page_completion,
 	struct page_info *info;
 
 	assert_on_cache_thread(cache, __func__);
-	ASSERT_LOG_ONLY((page_completion->waiter.next_waiter == NULL),
-			"New page completion was not already on a wait queue");
+	VDO_ASSERT_LOG_ONLY((page_completion->waiter.next_waiter == NULL),
+			    "New page completion was not already on a wait queue");
 
 	*page_completion = (struct vdo_page_completion) {
 		.pbn = pbn,
@@ -1265,7 +1265,7 @@ void vdo_get_page(struct vdo_page_completion *page_completion,
 		}
 
 		/* Something horrible has gone wrong. */
-		ASSERT_LOG_ONLY(false, "Info found in a usable state.");
+		VDO_ASSERT_LOG_ONLY(false, "Info found in a usable state.");
 	}
 
 	/* The page must be fetched. */
@@ -1334,7 +1334,7 @@ int vdo_invalidate_page_cache(struct vdo_page_cache *cache)
 
 	/* Make sure we don't throw away any dirty pages. */
 	for (info = cache->infos; info < cache->infos + cache->page_count; info++) {
-		int result = ASSERT(!is_dirty(info), "cache must have no dirty pages");
+		int result = VDO_ASSERT(!is_dirty(info), "cache must have no dirty pages");
 
 		if (result != VDO_SUCCESS)
 			return result;
@@ -1440,10 +1440,10 @@ static bool __must_check is_not_older(struct block_map_zone *zone, u8 a, u8 b)
 {
 	int result;
 
-	result = ASSERT((in_cyclic_range(zone->oldest_generation, a, zone->generation, 1 << 8) &&
-			 in_cyclic_range(zone->oldest_generation, b, zone->generation, 1 << 8)),
-			"generation(s) %u, %u are out of range [%u, %u]",
-			a, b, zone->oldest_generation, zone->generation);
+	result = VDO_ASSERT((in_cyclic_range(zone->oldest_generation, a, zone->generation, 1 << 8) &&
+			     in_cyclic_range(zone->oldest_generation, b, zone->generation, 1 << 8)),
+			    "generation(s) %u, %u are out of range [%u, %u]",
+			    a, b, zone->oldest_generation, zone->generation);
 	if (result != VDO_SUCCESS) {
 		enter_zone_read_only_mode(zone, result);
 		return true;
@@ -1456,8 +1456,8 @@ static void release_generation(struct block_map_zone *zone, u8 generation)
 {
 	int result;
 
-	result = ASSERT((zone->dirty_page_counts[generation] > 0),
-			"dirty page count underflow for generation %u", generation);
+	result = VDO_ASSERT((zone->dirty_page_counts[generation] > 0),
+			    "dirty page count underflow for generation %u", generation);
 	if (result != VDO_SUCCESS) {
 		enter_zone_read_only_mode(zone, result);
 		return;
@@ -1482,8 +1482,8 @@ static void set_generation(struct block_map_zone *zone, struct tree_page *page,
 
 	page->generation = new_generation;
 	new_count = ++zone->dirty_page_counts[new_generation];
-	result = ASSERT((new_count != 0), "dirty page count overflow for generation %u",
-			new_generation);
+	result = VDO_ASSERT((new_count != 0), "dirty page count overflow for generation %u",
+			    new_generation);
 	if (result != VDO_SUCCESS) {
 		enter_zone_read_only_mode(zone, result);
 		return;
@@ -1698,15 +1698,15 @@ static void release_page_lock(struct data_vio *data_vio, char *what)
 	struct tree_lock *lock_holder;
 	struct tree_lock *lock = &data_vio->tree_lock;
 
-	ASSERT_LOG_ONLY(lock->locked,
-			"release of unlocked block map page %s for key %llu in tree %u",
-			what, (unsigned long long) lock->key, lock->root_index);
+	VDO_ASSERT_LOG_ONLY(lock->locked,
+			    "release of unlocked block map page %s for key %llu in tree %u",
+			    what, (unsigned long long) lock->key, lock->root_index);
 
 	zone = data_vio->logical.zone->block_map_zone;
 	lock_holder = vdo_int_map_remove(zone->loading_pages, lock->key);
-	ASSERT_LOG_ONLY((lock_holder == lock),
-			"block map page %s mismatch for key %llu in tree %u",
-			what, (unsigned long long) lock->key, lock->root_index);
+	VDO_ASSERT_LOG_ONLY((lock_holder == lock),
+			    "block map page %s mismatch for key %llu in tree %u",
+			    what, (unsigned long long) lock->key, lock->root_index);
 	lock->locked = false;
 }
 
@@ -2008,8 +2008,8 @@ static void write_expired_elements(struct block_map_zone *zone)
 
 		list_del_init(&page->entry);
 
-		result = ASSERT(!vdo_waiter_is_waiting(&page->waiter),
-				"Newly expired page not already waiting to write");
+		result = VDO_ASSERT(!vdo_waiter_is_waiting(&page->waiter),
+				    "Newly expired page not already waiting to write");
 		if (result != VDO_SUCCESS) {
 			enter_zone_read_only_mode(zone, result);
 			continue;
@@ -2867,8 +2867,8 @@ int vdo_decode_block_map(struct block_map_state_2_0 state, block_count_t logical
 	BUILD_BUG_ON(VDO_BLOCK_MAP_ENTRIES_PER_PAGE !=
 		     ((VDO_BLOCK_SIZE - sizeof(struct block_map_page)) /
 		      sizeof(struct block_map_entry)));
-	result = ASSERT(cache_size > 0, "block map cache size is specified");
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(cache_size > 0, "block map cache size is specified");
+	if (result != VDO_SUCCESS)
 		return result;
 
 	result = vdo_allocate_extended(struct block_map,
@@ -2937,7 +2937,7 @@ void vdo_initialize_block_map_from_journal(struct block_map *map,
 	for (z = 0; z < map->zone_count; z++) {
 		struct dirty_lists *dirty_lists = map->zones[z].dirty_lists;
 
-		ASSERT_LOG_ONLY(dirty_lists->next_period == 0, "current period not set");
+		VDO_ASSERT_LOG_ONLY(dirty_lists->next_period == 0, "current period not set");
 		dirty_lists->oldest_period = map->current_era_point;
 		dirty_lists->next_period = map->current_era_point + 1;
 		dirty_lists->offset = map->current_era_point % dirty_lists->maximum_age;
@@ -2971,8 +2971,8 @@ static void initiate_drain(struct admin_state *state)
 {
 	struct block_map_zone *zone = container_of(state, struct block_map_zone, state);
 
-	ASSERT_LOG_ONLY((zone->active_lookups == 0),
-			"%s() called with no active lookups", __func__);
+	VDO_ASSERT_LOG_ONLY((zone->active_lookups == 0),
+			    "%s() called with no active lookups", __func__);
 
 	if (!vdo_is_state_suspending(state)) {
 		while (zone->dirty_lists->oldest_period < zone->dirty_lists->next_period)
diff --git a/drivers/md/dm-vdo/completion.c b/drivers/md/dm-vdo/completion.c
index 9e2381dc3683..5ad85334632d 100644
--- a/drivers/md/dm-vdo/completion.c
+++ b/drivers/md/dm-vdo/completion.c
@@ -60,7 +60,7 @@ void vdo_initialize_completion(struct vdo_completion *completion,
 
 static inline void assert_incomplete(struct vdo_completion *completion)
 {
-	ASSERT_LOG_ONLY(!completion->complete, "completion is not complete");
+	VDO_ASSERT_LOG_ONLY(!completion->complete, "completion is not complete");
 }
 
 /**
@@ -111,10 +111,10 @@ void vdo_enqueue_completion(struct vdo_completion *completion,
 	struct vdo *vdo = completion->vdo;
 	thread_id_t thread_id = completion->callback_thread_id;
 
-	if (ASSERT(thread_id < vdo->thread_config.thread_count,
-		   "thread_id %u (completion type %d) is less than thread count %u",
-		   thread_id, completion->type,
-		   vdo->thread_config.thread_count) != UDS_SUCCESS)
+	if (VDO_ASSERT(thread_id < vdo->thread_config.thread_count,
+		       "thread_id %u (completion type %d) is less than thread count %u",
+		       thread_id, completion->type,
+		       vdo->thread_config.thread_count) != VDO_SUCCESS)
 		BUG();
 
 	completion->requeue = false;
diff --git a/drivers/md/dm-vdo/completion.h b/drivers/md/dm-vdo/completion.h
index aa145d73a686..3407f34ce58c 100644
--- a/drivers/md/dm-vdo/completion.h
+++ b/drivers/md/dm-vdo/completion.h
@@ -85,9 +85,9 @@ static inline void vdo_fail_completion(struct vdo_completion *completion, int re
 static inline int vdo_assert_completion_type(struct vdo_completion *completion,
 					     enum vdo_completion_type expected)
 {
-	return ASSERT(expected == completion->type,
-		      "completion type should be %u, not %u", expected,
-		      completion->type);
+	return VDO_ASSERT(expected == completion->type,
+			  "completion type should be %u, not %u", expected,
+			  completion->type);
 }
 
 static inline void vdo_set_completion_callback(struct vdo_completion *completion,
diff --git a/drivers/md/dm-vdo/data-vio.c b/drivers/md/dm-vdo/data-vio.c
index 3d5054e61330..51c49fad1b8b 100644
--- a/drivers/md/dm-vdo/data-vio.c
+++ b/drivers/md/dm-vdo/data-vio.c
@@ -232,8 +232,8 @@ static bool check_for_drain_complete_locked(struct data_vio_pool *pool)
 	if (pool->limiter.busy > 0)
 		return false;
 
-	ASSERT_LOG_ONLY((pool->discard_limiter.busy == 0),
-			"no outstanding discard permits");
+	VDO_ASSERT_LOG_ONLY((pool->discard_limiter.busy == 0),
+			    "no outstanding discard permits");
 
 	return (bio_list_empty(&pool->limiter.new_waiters) &&
 		bio_list_empty(&pool->discard_limiter.new_waiters));
@@ -277,9 +277,9 @@ static void acknowledge_data_vio(struct data_vio *data_vio)
 	if (bio == NULL)
 		return;
 
-	ASSERT_LOG_ONLY((data_vio->remaining_discard <=
-			 (u32) (VDO_BLOCK_SIZE - data_vio->offset)),
-			"data_vio to acknowledge is not an incomplete discard");
+	VDO_ASSERT_LOG_ONLY((data_vio->remaining_discard <=
+			     (u32) (VDO_BLOCK_SIZE - data_vio->offset)),
+			    "data_vio to acknowledge is not an incomplete discard");
 
 	data_vio->user_bio = NULL;
 	vdo_count_bios(&vdo->stats.bios_acknowledged, bio);
@@ -443,7 +443,7 @@ static void attempt_logical_block_lock(struct vdo_completion *completion)
 		return;
 	}
 
-	result = ASSERT(lock_holder->logical.locked, "logical block lock held");
+	result = VDO_ASSERT(lock_holder->logical.locked, "logical block lock held");
 	if (result != VDO_SUCCESS) {
 		continue_data_vio_with_error(data_vio, result);
 		return;
@@ -627,9 +627,9 @@ static void update_limiter(struct limiter *limiter)
 	struct bio_list *waiters = &limiter->waiters;
 	data_vio_count_t available = limiter->limit - limiter->busy;
 
-	ASSERT_LOG_ONLY((limiter->release_count <= limiter->busy),
-			"Release count %u is not more than busy count %u",
-			limiter->release_count, limiter->busy);
+	VDO_ASSERT_LOG_ONLY((limiter->release_count <= limiter->busy),
+			    "Release count %u is not more than busy count %u",
+			    limiter->release_count, limiter->busy);
 
 	get_waiters(limiter);
 	for (; (limiter->release_count > 0) && !bio_list_empty(waiters); limiter->release_count--)
@@ -850,8 +850,8 @@ int make_data_vio_pool(struct vdo *vdo, data_vio_count_t pool_size,
 	if (result != VDO_SUCCESS)
 		return result;
 
-	ASSERT_LOG_ONLY((discard_limit <= pool_size),
-			"discard limit does not exceed pool size");
+	VDO_ASSERT_LOG_ONLY((discard_limit <= pool_size),
+			    "discard limit does not exceed pool size");
 	initialize_limiter(&pool->discard_limiter, pool, assign_discard_permit,
 			   discard_limit);
 	pool->discard_limiter.permitted_waiters = &pool->permitted_discards;
@@ -908,15 +908,15 @@ void free_data_vio_pool(struct data_vio_pool *pool)
 	BUG_ON(atomic_read(&pool->processing));
 
 	spin_lock(&pool->lock);
-	ASSERT_LOG_ONLY((pool->limiter.busy == 0),
-			"data_vio pool must not have %u busy entries when being freed",
-			pool->limiter.busy);
-	ASSERT_LOG_ONLY((bio_list_empty(&pool->limiter.waiters) &&
-			 bio_list_empty(&pool->limiter.new_waiters)),
-			"data_vio pool must not have threads waiting to read or write when being freed");
-	ASSERT_LOG_ONLY((bio_list_empty(&pool->discard_limiter.waiters) &&
-			 bio_list_empty(&pool->discard_limiter.new_waiters)),
-			"data_vio pool must not have threads waiting to discard when being freed");
+	VDO_ASSERT_LOG_ONLY((pool->limiter.busy == 0),
+			    "data_vio pool must not have %u busy entries when being freed",
+			    pool->limiter.busy);
+	VDO_ASSERT_LOG_ONLY((bio_list_empty(&pool->limiter.waiters) &&
+			     bio_list_empty(&pool->limiter.new_waiters)),
+			    "data_vio pool must not have threads waiting to read or write when being freed");
+	VDO_ASSERT_LOG_ONLY((bio_list_empty(&pool->discard_limiter.waiters) &&
+			     bio_list_empty(&pool->discard_limiter.new_waiters)),
+			    "data_vio pool must not have threads waiting to discard when being freed");
 	spin_unlock(&pool->lock);
 
 	list_for_each_entry_safe(data_vio, tmp, &pool->available, pool_entry) {
@@ -961,8 +961,8 @@ void vdo_launch_bio(struct data_vio_pool *pool, struct bio *bio)
 {
 	struct data_vio *data_vio;
 
-	ASSERT_LOG_ONLY(!vdo_is_state_quiescent(&pool->state),
-			"data_vio_pool not quiescent on acquire");
+	VDO_ASSERT_LOG_ONLY(!vdo_is_state_quiescent(&pool->state),
+			    "data_vio_pool not quiescent on acquire");
 
 	bio->bi_private = (void *) jiffies;
 	spin_lock(&pool->lock);
@@ -998,8 +998,8 @@ static void initiate_drain(struct admin_state *state)
 
 static void assert_on_vdo_cpu_thread(const struct vdo *vdo, const char *name)
 {
-	ASSERT_LOG_ONLY((vdo_get_callback_thread_id() == vdo->thread_config.cpu_thread),
-			"%s called on cpu thread", name);
+	VDO_ASSERT_LOG_ONLY((vdo_get_callback_thread_id() == vdo->thread_config.cpu_thread),
+			    "%s called on cpu thread", name);
 }
 
 /**
@@ -1173,17 +1173,17 @@ static void release_lock(struct data_vio *data_vio, struct lbn_lock *lock)
 		/*  The lock is not locked, so it had better not be registered in the lock map. */
 		struct data_vio *lock_holder = vdo_int_map_get(lock_map, lock->lbn);
 
-		ASSERT_LOG_ONLY((data_vio != lock_holder),
-				"no logical block lock held for block %llu",
-				(unsigned long long) lock->lbn);
+		VDO_ASSERT_LOG_ONLY((data_vio != lock_holder),
+				    "no logical block lock held for block %llu",
+				    (unsigned long long) lock->lbn);
 		return;
 	}
 
 	/* Release the lock by removing the lock from the map. */
 	lock_holder = vdo_int_map_remove(lock_map, lock->lbn);
-	ASSERT_LOG_ONLY((data_vio == lock_holder),
-			"logical block lock mismatch for block %llu",
-			(unsigned long long) lock->lbn);
+	VDO_ASSERT_LOG_ONLY((data_vio == lock_holder),
+			    "logical block lock mismatch for block %llu",
+			    (unsigned long long) lock->lbn);
 	lock->locked = false;
 }
 
@@ -1193,7 +1193,7 @@ static void transfer_lock(struct data_vio *data_vio, struct lbn_lock *lock)
 	struct data_vio *lock_holder, *next_lock_holder;
 	int result;
 
-	ASSERT_LOG_ONLY(lock->locked, "lbn_lock with waiters is not locked");
+	VDO_ASSERT_LOG_ONLY(lock->locked, "lbn_lock with waiters is not locked");
 
 	/* Another data_vio is waiting for the lock, transfer it in a single lock map operation. */
 	next_lock_holder =
@@ -1210,9 +1210,9 @@ static void transfer_lock(struct data_vio *data_vio, struct lbn_lock *lock)
 		return;
 	}
 
-	ASSERT_LOG_ONLY((lock_holder == data_vio),
-			"logical block lock mismatch for block %llu",
-			(unsigned long long) lock->lbn);
+	VDO_ASSERT_LOG_ONLY((lock_holder == data_vio),
+			    "logical block lock mismatch for block %llu",
+			    (unsigned long long) lock->lbn);
 	lock->locked = false;
 
 	/*
@@ -1275,10 +1275,10 @@ static void finish_cleanup(struct data_vio *data_vio)
 {
 	struct vdo_completion *completion = &data_vio->vio.completion;
 
-	ASSERT_LOG_ONLY(data_vio->allocation.lock == NULL,
-			"complete data_vio has no allocation lock");
-	ASSERT_LOG_ONLY(data_vio->hash_lock == NULL,
-			"complete data_vio has no hash lock");
+	VDO_ASSERT_LOG_ONLY(data_vio->allocation.lock == NULL,
+			    "complete data_vio has no allocation lock");
+	VDO_ASSERT_LOG_ONLY(data_vio->hash_lock == NULL,
+			    "complete data_vio has no hash lock");
 	if ((data_vio->remaining_discard <= VDO_BLOCK_SIZE) ||
 	    (completion->result != VDO_SUCCESS)) {
 		struct data_vio_pool *pool = completion->vdo->data_vio_pool;
@@ -1404,8 +1404,8 @@ void data_vio_allocate_data_block(struct data_vio *data_vio,
 {
 	struct allocation *allocation = &data_vio->allocation;
 
-	ASSERT_LOG_ONLY((allocation->pbn == VDO_ZERO_BLOCK),
-			"data_vio does not have an allocation");
+	VDO_ASSERT_LOG_ONLY((allocation->pbn == VDO_ZERO_BLOCK),
+			    "data_vio does not have an allocation");
 	allocation->write_lock_type = write_lock_type;
 	allocation->zone = vdo_get_next_allocation_zone(data_vio->logical.zone);
 	allocation->first_allocation_zone = allocation->zone->zone_number;
@@ -1796,11 +1796,11 @@ static void compress_data_vio(struct vdo_completion *completion)
  */
 void launch_compress_data_vio(struct data_vio *data_vio)
 {
-	ASSERT_LOG_ONLY(!data_vio->is_duplicate, "compressing a non-duplicate block");
-	ASSERT_LOG_ONLY(data_vio->hash_lock != NULL,
-			"data_vio to compress has a hash_lock");
-	ASSERT_LOG_ONLY(data_vio_has_allocation(data_vio),
-			"data_vio to compress has an allocation");
+	VDO_ASSERT_LOG_ONLY(!data_vio->is_duplicate, "compressing a non-duplicate block");
+	VDO_ASSERT_LOG_ONLY(data_vio->hash_lock != NULL,
+			    "data_vio to compress has a hash_lock");
+	VDO_ASSERT_LOG_ONLY(data_vio_has_allocation(data_vio),
+			    "data_vio to compress has an allocation");
 
 	/*
 	 * There are 4 reasons why a data_vio which has reached this point will not be eligible for
@@ -1841,7 +1841,7 @@ static void hash_data_vio(struct vdo_completion *completion)
 	struct data_vio *data_vio = as_data_vio(completion);
 
 	assert_data_vio_on_cpu_thread(data_vio);
-	ASSERT_LOG_ONLY(!data_vio->is_zero, "zero blocks should not be hashed");
+	VDO_ASSERT_LOG_ONLY(!data_vio->is_zero, "zero blocks should not be hashed");
 
 	murmurhash3_128(data_vio->vio.data, VDO_BLOCK_SIZE, 0x62ea60be,
 			&data_vio->record_name);
@@ -1856,7 +1856,7 @@ static void hash_data_vio(struct vdo_completion *completion)
 static void prepare_for_dedupe(struct data_vio *data_vio)
 {
 	/* We don't care what thread we are on. */
-	ASSERT_LOG_ONLY(!data_vio->is_zero, "must not prepare to dedupe zero blocks");
+	VDO_ASSERT_LOG_ONLY(!data_vio->is_zero, "must not prepare to dedupe zero blocks");
 
 	/*
 	 * Before we can dedupe, we need to know the record name, so the first
@@ -1929,11 +1929,11 @@ static void acknowledge_write_callback(struct vdo_completion *completion)
 	struct data_vio *data_vio = as_data_vio(completion);
 	struct vdo *vdo = completion->vdo;
 
-	ASSERT_LOG_ONLY((!vdo_uses_bio_ack_queue(vdo) ||
-			 (vdo_get_callback_thread_id() == vdo->thread_config.bio_ack_thread)),
-			"%s() called on bio ack queue", __func__);
-	ASSERT_LOG_ONLY(data_vio_has_flush_generation_lock(data_vio),
-			"write VIO to be acknowledged has a flush generation lock");
+	VDO_ASSERT_LOG_ONLY((!vdo_uses_bio_ack_queue(vdo) ||
+			     (vdo_get_callback_thread_id() == vdo->thread_config.bio_ack_thread)),
+			    "%s() called on bio ack queue", __func__);
+	VDO_ASSERT_LOG_ONLY(data_vio_has_flush_generation_lock(data_vio),
+			    "write VIO to be acknowledged has a flush generation lock");
 	acknowledge_data_vio(data_vio);
 	if (data_vio->new_mapped.pbn == VDO_ZERO_BLOCK) {
 		/* This is a zero write or discard */
@@ -1998,8 +1998,8 @@ static void handle_allocation_error(struct vdo_completion *completion)
 
 static int assert_is_discard(struct data_vio *data_vio)
 {
-	int result = ASSERT(data_vio->is_discard,
-			    "data_vio with no block map page is a discard");
+	int result = VDO_ASSERT(data_vio->is_discard,
+				"data_vio with no block map page is a discard");
 
 	return ((result == VDO_SUCCESS) ? result : VDO_READ_ONLY);
 }
diff --git a/drivers/md/dm-vdo/data-vio.h b/drivers/md/dm-vdo/data-vio.h
index 44fd0d8ccb76..25926b6cd98b 100644
--- a/drivers/md/dm-vdo/data-vio.h
+++ b/drivers/md/dm-vdo/data-vio.h
@@ -280,7 +280,7 @@ struct data_vio {
 
 static inline struct data_vio *vio_as_data_vio(struct vio *vio)
 {
-	ASSERT_LOG_ONLY((vio->type == VIO_TYPE_DATA), "vio is a data_vio");
+	VDO_ASSERT_LOG_ONLY((vio->type == VIO_TYPE_DATA), "vio is a data_vio");
 	return container_of(vio, struct data_vio, vio);
 }
 
@@ -374,9 +374,9 @@ static inline void assert_data_vio_in_hash_zone(struct data_vio *data_vio)
 	 * It's odd to use the LBN, but converting the record name to hex is a bit clunky for an
 	 * inline, and the LBN better than nothing as an identifier.
 	 */
-	ASSERT_LOG_ONLY((expected == thread_id),
-			"data_vio for logical block %llu on thread %u, should be on hash zone thread %u",
-			(unsigned long long) data_vio->logical.lbn, thread_id, expected);
+	VDO_ASSERT_LOG_ONLY((expected == thread_id),
+			    "data_vio for logical block %llu on thread %u, should be on hash zone thread %u",
+			    (unsigned long long) data_vio->logical.lbn, thread_id, expected);
 }
 
 static inline void set_data_vio_hash_zone_callback(struct data_vio *data_vio,
@@ -402,9 +402,9 @@ static inline void assert_data_vio_in_logical_zone(struct data_vio *data_vio)
 	thread_id_t expected = data_vio->logical.zone->thread_id;
 	thread_id_t thread_id = vdo_get_callback_thread_id();
 
-	ASSERT_LOG_ONLY((expected == thread_id),
-			"data_vio for logical block %llu on thread %u, should be on thread %u",
-			(unsigned long long) data_vio->logical.lbn, thread_id, expected);
+	VDO_ASSERT_LOG_ONLY((expected == thread_id),
+			    "data_vio for logical block %llu on thread %u, should be on thread %u",
+			    (unsigned long long) data_vio->logical.lbn, thread_id, expected);
 }
 
 static inline void set_data_vio_logical_callback(struct data_vio *data_vio,
@@ -430,10 +430,10 @@ static inline void assert_data_vio_in_allocated_zone(struct data_vio *data_vio)
 	thread_id_t expected = data_vio->allocation.zone->thread_id;
 	thread_id_t thread_id = vdo_get_callback_thread_id();
 
-	ASSERT_LOG_ONLY((expected == thread_id),
-			"struct data_vio for allocated physical block %llu on thread %u, should be on thread %u",
-			(unsigned long long) data_vio->allocation.pbn, thread_id,
-			expected);
+	VDO_ASSERT_LOG_ONLY((expected == thread_id),
+			    "struct data_vio for allocated physical block %llu on thread %u, should be on thread %u",
+			    (unsigned long long) data_vio->allocation.pbn, thread_id,
+			    expected);
 }
 
 static inline void set_data_vio_allocated_zone_callback(struct data_vio *data_vio,
@@ -460,10 +460,10 @@ static inline void assert_data_vio_in_duplicate_zone(struct data_vio *data_vio)
 	thread_id_t expected = data_vio->duplicate.zone->thread_id;
 	thread_id_t thread_id = vdo_get_callback_thread_id();
 
-	ASSERT_LOG_ONLY((expected == thread_id),
-			"data_vio for duplicate physical block %llu on thread %u, should be on thread %u",
-			(unsigned long long) data_vio->duplicate.pbn, thread_id,
-			expected);
+	VDO_ASSERT_LOG_ONLY((expected == thread_id),
+			    "data_vio for duplicate physical block %llu on thread %u, should be on thread %u",
+			    (unsigned long long) data_vio->duplicate.pbn, thread_id,
+			    expected);
 }
 
 static inline void set_data_vio_duplicate_zone_callback(struct data_vio *data_vio,
@@ -490,9 +490,9 @@ static inline void assert_data_vio_in_mapped_zone(struct data_vio *data_vio)
 	thread_id_t expected = data_vio->mapped.zone->thread_id;
 	thread_id_t thread_id = vdo_get_callback_thread_id();
 
-	ASSERT_LOG_ONLY((expected == thread_id),
-			"data_vio for mapped physical block %llu on thread %u, should be on thread %u",
-			(unsigned long long) data_vio->mapped.pbn, thread_id, expected);
+	VDO_ASSERT_LOG_ONLY((expected == thread_id),
+			    "data_vio for mapped physical block %llu on thread %u, should be on thread %u",
+			    (unsigned long long) data_vio->mapped.pbn, thread_id, expected);
 }
 
 static inline void set_data_vio_mapped_zone_callback(struct data_vio *data_vio,
@@ -507,10 +507,10 @@ static inline void assert_data_vio_in_new_mapped_zone(struct data_vio *data_vio)
 	thread_id_t expected = data_vio->new_mapped.zone->thread_id;
 	thread_id_t thread_id = vdo_get_callback_thread_id();
 
-	ASSERT_LOG_ONLY((expected == thread_id),
-			"data_vio for new_mapped physical block %llu on thread %u, should be on thread %u",
-			(unsigned long long) data_vio->new_mapped.pbn, thread_id,
-			expected);
+	VDO_ASSERT_LOG_ONLY((expected == thread_id),
+			    "data_vio for new_mapped physical block %llu on thread %u, should be on thread %u",
+			    (unsigned long long) data_vio->new_mapped.pbn, thread_id,
+			    expected);
 }
 
 static inline void set_data_vio_new_mapped_zone_callback(struct data_vio *data_vio,
@@ -525,10 +525,10 @@ static inline void assert_data_vio_in_journal_zone(struct data_vio *data_vio)
 	thread_id_t journal_thread = vdo_from_data_vio(data_vio)->thread_config.journal_thread;
 	thread_id_t thread_id = vdo_get_callback_thread_id();
 
-	ASSERT_LOG_ONLY((journal_thread == thread_id),
-			"data_vio for logical block %llu on thread %u, should be on journal thread %u",
-			(unsigned long long) data_vio->logical.lbn, thread_id,
-			journal_thread);
+	VDO_ASSERT_LOG_ONLY((journal_thread == thread_id),
+			    "data_vio for logical block %llu on thread %u, should be on journal thread %u",
+			    (unsigned long long) data_vio->logical.lbn, thread_id,
+			    journal_thread);
 }
 
 static inline void set_data_vio_journal_callback(struct data_vio *data_vio,
@@ -555,10 +555,10 @@ static inline void assert_data_vio_in_packer_zone(struct data_vio *data_vio)
 	thread_id_t packer_thread = vdo_from_data_vio(data_vio)->thread_config.packer_thread;
 	thread_id_t thread_id = vdo_get_callback_thread_id();
 
-	ASSERT_LOG_ONLY((packer_thread == thread_id),
-			"data_vio for logical block %llu on thread %u, should be on packer thread %u",
-			(unsigned long long) data_vio->logical.lbn, thread_id,
-			packer_thread);
+	VDO_ASSERT_LOG_ONLY((packer_thread == thread_id),
+			    "data_vio for logical block %llu on thread %u, should be on packer thread %u",
+			    (unsigned long long) data_vio->logical.lbn, thread_id,
+			    packer_thread);
 }
 
 static inline void set_data_vio_packer_callback(struct data_vio *data_vio,
@@ -585,10 +585,10 @@ static inline void assert_data_vio_on_cpu_thread(struct data_vio *data_vio)
 	thread_id_t cpu_thread = vdo_from_data_vio(data_vio)->thread_config.cpu_thread;
 	thread_id_t thread_id = vdo_get_callback_thread_id();
 
-	ASSERT_LOG_ONLY((cpu_thread == thread_id),
-			"data_vio for logical block %llu on thread %u, should be on cpu thread %u",
-			(unsigned long long) data_vio->logical.lbn, thread_id,
-			cpu_thread);
+	VDO_ASSERT_LOG_ONLY((cpu_thread == thread_id),
+			    "data_vio for logical block %llu on thread %u, should be on cpu thread %u",
+			    (unsigned long long) data_vio->logical.lbn, thread_id,
+			    cpu_thread);
 }
 
 static inline void set_data_vio_cpu_callback(struct data_vio *data_vio,
diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index 7cdbe825116f..52bdf657db64 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -327,8 +327,8 @@ static inline struct hash_zones *as_hash_zones(struct vdo_completion *completion
 
 static inline void assert_in_hash_zone(struct hash_zone *zone, const char *name)
 {
-	ASSERT_LOG_ONLY((vdo_get_callback_thread_id() == zone->thread_id),
-			"%s called on hash zone thread", name);
+	VDO_ASSERT_LOG_ONLY((vdo_get_callback_thread_id() == zone->thread_id),
+			    "%s called on hash zone thread", name);
 }
 
 static inline bool change_context_state(struct dedupe_context *context, int old, int new)
@@ -404,8 +404,8 @@ static void assert_hash_lock_agent(struct data_vio *data_vio, const char *where)
 {
 	/* Not safe to access the agent field except from the hash zone. */
 	assert_data_vio_in_hash_zone(data_vio);
-	ASSERT_LOG_ONLY(data_vio == data_vio->hash_lock->agent,
-			"%s must be for the hash lock agent", where);
+	VDO_ASSERT_LOG_ONLY(data_vio == data_vio->hash_lock->agent,
+			    "%s must be for the hash lock agent", where);
 }
 
 /**
@@ -416,9 +416,8 @@ static void assert_hash_lock_agent(struct data_vio *data_vio, const char *where)
  */
 static void set_duplicate_lock(struct hash_lock *hash_lock, struct pbn_lock *pbn_lock)
 {
-	ASSERT_LOG_ONLY((hash_lock->duplicate_lock == NULL),
-			"hash lock must not already hold a duplicate lock");
-
+	VDO_ASSERT_LOG_ONLY((hash_lock->duplicate_lock == NULL),
+			    "hash lock must not already hold a duplicate lock");
 	pbn_lock->holder_count += 1;
 	hash_lock->duplicate_lock = pbn_lock;
 }
@@ -446,12 +445,12 @@ static void set_hash_lock(struct data_vio *data_vio, struct hash_lock *new_lock)
 	struct hash_lock *old_lock = data_vio->hash_lock;
 
 	if (old_lock != NULL) {
-		ASSERT_LOG_ONLY(data_vio->hash_zone != NULL,
-				"must have a hash zone when holding a hash lock");
-		ASSERT_LOG_ONLY(!list_empty(&data_vio->hash_lock_entry),
-				"must be on a hash lock ring when holding a hash lock");
-		ASSERT_LOG_ONLY(old_lock->reference_count > 0,
-				"hash lock reference must be counted");
+		VDO_ASSERT_LOG_ONLY(data_vio->hash_zone != NULL,
+				    "must have a hash zone when holding a hash lock");
+		VDO_ASSERT_LOG_ONLY(!list_empty(&data_vio->hash_lock_entry),
+				    "must be on a hash lock ring when holding a hash lock");
+		VDO_ASSERT_LOG_ONLY(old_lock->reference_count > 0,
+				    "hash lock reference must be counted");
 
 		if ((old_lock->state != VDO_HASH_LOCK_BYPASSING) &&
 		    (old_lock->state != VDO_HASH_LOCK_UNLOCKING)) {
@@ -459,9 +458,9 @@ static void set_hash_lock(struct data_vio *data_vio, struct hash_lock *new_lock)
 			 * If the reference count goes to zero in a non-terminal state, we're most
 			 * likely leaking this lock.
 			 */
-			ASSERT_LOG_ONLY(old_lock->reference_count > 1,
-					"hash locks should only become unreferenced in a terminal state, not state %s",
-					get_hash_lock_state_name(old_lock->state));
+			VDO_ASSERT_LOG_ONLY(old_lock->reference_count > 1,
+					    "hash locks should only become unreferenced in a terminal state, not state %s",
+					    get_hash_lock_state_name(old_lock->state));
 		}
 
 		list_del_init(&data_vio->hash_lock_entry);
@@ -641,8 +640,8 @@ static void finish_unlocking(struct vdo_completion *completion)
 
 	assert_hash_lock_agent(agent, __func__);
 
-	ASSERT_LOG_ONLY(lock->duplicate_lock == NULL,
-			"must have released the duplicate lock for the hash lock");
+	VDO_ASSERT_LOG_ONLY(lock->duplicate_lock == NULL,
+			    "must have released the duplicate lock for the hash lock");
 
 	if (!lock->verified) {
 		/*
@@ -696,8 +695,8 @@ static void unlock_duplicate_pbn(struct vdo_completion *completion)
 	struct hash_lock *lock = agent->hash_lock;
 
 	assert_data_vio_in_duplicate_zone(agent);
-	ASSERT_LOG_ONLY(lock->duplicate_lock != NULL,
-			"must have a duplicate lock to release");
+	VDO_ASSERT_LOG_ONLY(lock->duplicate_lock != NULL,
+			    "must have a duplicate lock to release");
 
 	vdo_release_physical_zone_pbn_lock(agent->duplicate.zone, agent->duplicate.pbn,
 					   vdo_forget(lock->duplicate_lock));
@@ -799,8 +798,8 @@ static void start_updating(struct hash_lock *lock, struct data_vio *agent)
 {
 	lock->state = VDO_HASH_LOCK_UPDATING;
 
-	ASSERT_LOG_ONLY(lock->verified, "new advice should have been verified");
-	ASSERT_LOG_ONLY(lock->update_advice, "should only update advice if needed");
+	VDO_ASSERT_LOG_ONLY(lock->verified, "new advice should have been verified");
+	VDO_ASSERT_LOG_ONLY(lock->update_advice, "should only update advice if needed");
 
 	agent->last_async_operation = VIO_ASYNC_OP_UPDATE_DEDUPE_INDEX;
 	set_data_vio_hash_zone_callback(agent, finish_updating);
@@ -822,9 +821,9 @@ static void finish_deduping(struct hash_lock *lock, struct data_vio *data_vio)
 {
 	struct data_vio *agent = data_vio;
 
-	ASSERT_LOG_ONLY(lock->agent == NULL, "shouldn't have an agent in DEDUPING");
-	ASSERT_LOG_ONLY(!vdo_waitq_has_waiters(&lock->waiters),
-			"shouldn't have any lock waiters in DEDUPING");
+	VDO_ASSERT_LOG_ONLY(lock->agent == NULL, "shouldn't have an agent in DEDUPING");
+	VDO_ASSERT_LOG_ONLY(!vdo_waitq_has_waiters(&lock->waiters),
+			    "shouldn't have any lock waiters in DEDUPING");
 
 	/* Just release the lock reference if other data_vios are still deduping. */
 	if (lock->reference_count > 1) {
@@ -879,8 +878,8 @@ static int __must_check acquire_lock(struct hash_zone *zone,
 	 * Borrow and prepare a lock from the pool so we don't have to do two int_map accesses
 	 * in the common case of no lock contention.
 	 */
-	result = ASSERT(!list_empty(&zone->lock_pool),
-			"never need to wait for a free hash lock");
+	result = VDO_ASSERT(!list_empty(&zone->lock_pool),
+			    "never need to wait for a free hash lock");
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -902,11 +901,11 @@ static int __must_check acquire_lock(struct hash_zone *zone,
 
 	if (replace_lock != NULL) {
 		/* On mismatch put the old lock back and return a severe error */
-		ASSERT_LOG_ONLY(lock == replace_lock,
-				"old lock must have been in the lock map");
+		VDO_ASSERT_LOG_ONLY(lock == replace_lock,
+				    "old lock must have been in the lock map");
 		/* TODO: Check earlier and bail out? */
-		ASSERT_LOG_ONLY(replace_lock->registered,
-				"old lock must have been marked registered");
+		VDO_ASSERT_LOG_ONLY(replace_lock->registered,
+				    "old lock must have been marked registered");
 		replace_lock->registered = false;
 	}
 
@@ -1018,15 +1017,15 @@ static void start_deduping(struct hash_lock *lock, struct data_vio *agent,
 	 * deduplicate against it.
 	 */
 	if (lock->duplicate_lock == NULL) {
-		ASSERT_LOG_ONLY(!vdo_is_state_compressed(agent->new_mapped.state),
-				"compression must have shared a lock");
-		ASSERT_LOG_ONLY(agent_is_done,
-				"agent must have written the new duplicate");
+		VDO_ASSERT_LOG_ONLY(!vdo_is_state_compressed(agent->new_mapped.state),
+				    "compression must have shared a lock");
+		VDO_ASSERT_LOG_ONLY(agent_is_done,
+				    "agent must have written the new duplicate");
 		transfer_allocation_lock(agent);
 	}
 
-	ASSERT_LOG_ONLY(vdo_is_pbn_read_lock(lock->duplicate_lock),
-			"duplicate_lock must be a PBN read lock");
+	VDO_ASSERT_LOG_ONLY(vdo_is_pbn_read_lock(lock->duplicate_lock),
+			    "duplicate_lock must be a PBN read lock");
 
 	/*
 	 * This state is not like any of the other states. There is no designated agent--the agent
@@ -1204,7 +1203,7 @@ static void start_verifying(struct hash_lock *lock, struct data_vio *agent)
 			agent->scratch_block);
 
 	lock->state = VDO_HASH_LOCK_VERIFYING;
-	ASSERT_LOG_ONLY(!lock->verified, "hash lock only verifies advice once");
+	VDO_ASSERT_LOG_ONLY(!lock->verified, "hash lock only verifies advice once");
 
 	agent->last_async_operation = VIO_ASYNC_OP_VERIFY_DUPLICATION;
 	result = vio_reset_bio(vio, buffer, verify_endio, REQ_OP_READ,
@@ -1234,8 +1233,8 @@ static void finish_locking(struct vdo_completion *completion)
 	assert_hash_lock_agent(agent, __func__);
 
 	if (!agent->is_duplicate) {
-		ASSERT_LOG_ONLY(lock->duplicate_lock == NULL,
-				"must not hold duplicate_lock if not flagged as a duplicate");
+		VDO_ASSERT_LOG_ONLY(lock->duplicate_lock == NULL,
+				    "must not hold duplicate_lock if not flagged as a duplicate");
 		/*
 		 * LOCKING -> WRITING transition: The advice block is being modified or has no
 		 * available references, so try to write or compress the data, remembering to
@@ -1247,8 +1246,8 @@ static void finish_locking(struct vdo_completion *completion)
 		return;
 	}
 
-	ASSERT_LOG_ONLY(lock->duplicate_lock != NULL,
-			"must hold duplicate_lock if flagged as a duplicate");
+	VDO_ASSERT_LOG_ONLY(lock->duplicate_lock != NULL,
+			    "must hold duplicate_lock if flagged as a duplicate");
 
 	if (!lock->verified) {
 		/*
@@ -1418,8 +1417,8 @@ static void lock_duplicate_pbn(struct vdo_completion *completion)
  */
 static void start_locking(struct hash_lock *lock, struct data_vio *agent)
 {
-	ASSERT_LOG_ONLY(lock->duplicate_lock == NULL,
-			"must not acquire a duplicate lock when already holding it");
+	VDO_ASSERT_LOG_ONLY(lock->duplicate_lock == NULL,
+			    "must not acquire a duplicate lock when already holding it");
 
 	lock->state = VDO_HASH_LOCK_LOCKING;
 
@@ -1725,8 +1724,8 @@ static void start_querying(struct hash_lock *lock, struct data_vio *data_vio)
  */
 static void report_bogus_lock_state(struct hash_lock *lock, struct data_vio *data_vio)
 {
-	ASSERT_LOG_ONLY(false, "hash lock must not be in unimplemented state %s",
-			get_hash_lock_state_name(lock->state));
+	VDO_ASSERT_LOG_ONLY(false, "hash lock must not be in unimplemented state %s",
+			    get_hash_lock_state_name(lock->state));
 	continue_data_vio_with_error(data_vio, VDO_LOCK_ERROR);
 }
 
@@ -1748,8 +1747,8 @@ void vdo_continue_hash_lock(struct vdo_completion *completion)
 
 	switch (lock->state) {
 	case VDO_HASH_LOCK_WRITING:
-		ASSERT_LOG_ONLY(data_vio == lock->agent,
-				"only the lock agent may continue the lock");
+		VDO_ASSERT_LOG_ONLY(data_vio == lock->agent,
+				    "only the lock agent may continue the lock");
 		finish_writing(lock, data_vio);
 		break;
 
@@ -1815,18 +1814,18 @@ static inline int assert_hash_lock_preconditions(const struct data_vio *data_vio
 	int result;
 
 	/* FIXME: BUG_ON() and/or enter read-only mode? */
-	result = ASSERT(data_vio->hash_lock == NULL,
-			"must not already hold a hash lock");
+	result = VDO_ASSERT(data_vio->hash_lock == NULL,
+			    "must not already hold a hash lock");
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = ASSERT(list_empty(&data_vio->hash_lock_entry),
-			"must not already be a member of a hash lock ring");
+	result = VDO_ASSERT(list_empty(&data_vio->hash_lock_entry),
+			    "must not already be a member of a hash lock ring");
 	if (result != VDO_SUCCESS)
 		return result;
 
-	return ASSERT(data_vio->recovery_sequence_number == 0,
-		      "must not hold a recovery lock when getting a hash lock");
+	return VDO_ASSERT(data_vio->recovery_sequence_number == 0,
+			  "must not hold a recovery lock when getting a hash lock");
 }
 
 /**
@@ -1933,24 +1932,24 @@ void vdo_release_hash_lock(struct data_vio *data_vio)
 		struct hash_lock *removed;
 
 		removed = vdo_int_map_remove(zone->hash_lock_map, lock_key);
-		ASSERT_LOG_ONLY(lock == removed,
-				"hash lock being released must have been mapped");
+		VDO_ASSERT_LOG_ONLY(lock == removed,
+				    "hash lock being released must have been mapped");
 	} else {
-		ASSERT_LOG_ONLY(lock != vdo_int_map_get(zone->hash_lock_map, lock_key),
-				"unregistered hash lock must not be in the lock map");
-	}
-
-	ASSERT_LOG_ONLY(!vdo_waitq_has_waiters(&lock->waiters),
-			"hash lock returned to zone must have no waiters");
-	ASSERT_LOG_ONLY((lock->duplicate_lock == NULL),
-			"hash lock returned to zone must not reference a PBN lock");
-	ASSERT_LOG_ONLY((lock->state == VDO_HASH_LOCK_BYPASSING),
-			"returned hash lock must not be in use with state %s",
-			get_hash_lock_state_name(lock->state));
-	ASSERT_LOG_ONLY(list_empty(&lock->pool_node),
-			"hash lock returned to zone must not be in a pool ring");
-	ASSERT_LOG_ONLY(list_empty(&lock->duplicate_ring),
-			"hash lock returned to zone must not reference DataVIOs");
+		VDO_ASSERT_LOG_ONLY(lock != vdo_int_map_get(zone->hash_lock_map, lock_key),
+				    "unregistered hash lock must not be in the lock map");
+	}
+
+	VDO_ASSERT_LOG_ONLY(!vdo_waitq_has_waiters(&lock->waiters),
+			    "hash lock returned to zone must have no waiters");
+	VDO_ASSERT_LOG_ONLY((lock->duplicate_lock == NULL),
+			    "hash lock returned to zone must not reference a PBN lock");
+	VDO_ASSERT_LOG_ONLY((lock->state == VDO_HASH_LOCK_BYPASSING),
+			    "returned hash lock must not be in use with state %s",
+			    get_hash_lock_state_name(lock->state));
+	VDO_ASSERT_LOG_ONLY(list_empty(&lock->pool_node),
+			    "hash lock returned to zone must not be in a pool ring");
+	VDO_ASSERT_LOG_ONLY(list_empty(&lock->duplicate_ring),
+			    "hash lock returned to zone must not reference DataVIOs");
 
 	return_hash_lock_to_pool(zone, lock);
 }
@@ -1965,13 +1964,13 @@ static void transfer_allocation_lock(struct data_vio *data_vio)
 	struct allocation *allocation = &data_vio->allocation;
 	struct hash_lock *hash_lock = data_vio->hash_lock;
 
-	ASSERT_LOG_ONLY(data_vio->new_mapped.pbn == allocation->pbn,
-			"transferred lock must be for the block written");
+	VDO_ASSERT_LOG_ONLY(data_vio->new_mapped.pbn == allocation->pbn,
+			    "transferred lock must be for the block written");
 
 	allocation->pbn = VDO_ZERO_BLOCK;
 
-	ASSERT_LOG_ONLY(vdo_is_pbn_read_lock(allocation->lock),
-			"must have downgraded the allocation lock before transfer");
+	VDO_ASSERT_LOG_ONLY(vdo_is_pbn_read_lock(allocation->lock),
+			    "must have downgraded the allocation lock before transfer");
 
 	hash_lock->duplicate = data_vio->new_mapped;
 	data_vio->duplicate = data_vio->new_mapped;
@@ -1997,10 +1996,10 @@ void vdo_share_compressed_write_lock(struct data_vio *data_vio,
 {
 	bool claimed;
 
-	ASSERT_LOG_ONLY(vdo_get_duplicate_lock(data_vio) == NULL,
-			"a duplicate PBN lock should not exist when writing");
-	ASSERT_LOG_ONLY(vdo_is_state_compressed(data_vio->new_mapped.state),
-			"lock transfer must be for a compressed write");
+	VDO_ASSERT_LOG_ONLY(vdo_get_duplicate_lock(data_vio) == NULL,
+			    "a duplicate PBN lock should not exist when writing");
+	VDO_ASSERT_LOG_ONLY(vdo_is_state_compressed(data_vio->new_mapped.state),
+			    "lock transfer must be for a compressed write");
 	assert_data_vio_in_new_mapped_zone(data_vio);
 
 	/* First sharer downgrades the lock. */
@@ -2020,7 +2019,7 @@ void vdo_share_compressed_write_lock(struct data_vio *data_vio,
 	 * deduplicating against it before our incRef.
 	 */
 	claimed = vdo_claim_pbn_lock_increment(pbn_lock);
-	ASSERT_LOG_ONLY(claimed, "impossible to fail to claim an initial increment");
+	VDO_ASSERT_LOG_ONLY(claimed, "impossible to fail to claim an initial increment");
 }
 
 static void dedupe_kobj_release(struct kobject *directory)
@@ -2296,8 +2295,8 @@ static void finish_index_operation(struct uds_request *request)
 	 */
 	if (!change_context_state(context, DEDUPE_CONTEXT_TIMED_OUT,
 				  DEDUPE_CONTEXT_TIMED_OUT_COMPLETE)) {
-		ASSERT_LOG_ONLY(false, "uds request was timed out (state %d)",
-				atomic_read(&context->state));
+		VDO_ASSERT_LOG_ONLY(false, "uds request was timed out (state %d)",
+				    atomic_read(&context->state));
 	}
 
 	uds_funnel_queue_put(context->zone->timed_out_complete, &context->queue_entry);
@@ -2341,7 +2340,7 @@ static void check_for_drain_complete(struct hash_zone *zone)
 
 	if (recycled > 0)
 		WRITE_ONCE(zone->active, zone->active - recycled);
-	ASSERT_LOG_ONLY(READ_ONCE(zone->active) == 0, "all contexts inactive");
+	VDO_ASSERT_LOG_ONLY(READ_ONCE(zone->active) == 0, "all contexts inactive");
 	vdo_finish_draining(&zone->state);
 }
 
diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index 90ba379f8d3e..e493b2fec90b 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -904,8 +904,8 @@ static int vdo_map_bio(struct dm_target *ti, struct bio *bio)
 	struct vdo_work_queue *current_work_queue;
 	const struct admin_state_code *code = vdo_get_admin_state_code(&vdo->admin.state);
 
-	ASSERT_LOG_ONLY(code->normal, "vdo should not receive bios while in state %s",
-			code->name);
+	VDO_ASSERT_LOG_ONLY(code->normal, "vdo should not receive bios while in state %s",
+			    code->name);
 
 	/* Count all incoming bios. */
 	vdo_count_bios(&vdo->stats.bios_in, bio);
@@ -1244,9 +1244,9 @@ static int perform_admin_operation(struct vdo *vdo, u32 starting_phase,
 /* Assert that we are operating on the correct thread for the current phase. */
 static void assert_admin_phase_thread(struct vdo *vdo, const char *what)
 {
-	ASSERT_LOG_ONLY(vdo_get_callback_thread_id() == get_thread_id_for_phase(vdo),
-			"%s on correct thread for %s", what,
-			ADMIN_PHASE_NAMES[vdo->admin.phase]);
+	VDO_ASSERT_LOG_ONLY(vdo_get_callback_thread_id() == get_thread_id_for_phase(vdo),
+			    "%s on correct thread for %s", what,
+			    ADMIN_PHASE_NAMES[vdo->admin.phase]);
 }
 
 /**
@@ -1424,11 +1424,11 @@ static void release_instance(unsigned int instance)
 {
 	mutex_lock(&instances_lock);
 	if (instance >= instances.bit_count) {
-		ASSERT_LOG_ONLY(false,
-				"instance number %u must be less than bit count %u",
-				instance, instances.bit_count);
+		VDO_ASSERT_LOG_ONLY(false,
+				    "instance number %u must be less than bit count %u",
+				    instance, instances.bit_count);
 	} else if (test_bit(instance, instances.words) == 0) {
-		ASSERT_LOG_ONLY(false, "instance number %u must be allocated", instance);
+		VDO_ASSERT_LOG_ONLY(false, "instance number %u must be allocated", instance);
 	} else {
 		__clear_bit(instance, instances.words);
 		instances.count -= 1;
@@ -1577,9 +1577,9 @@ static int allocate_instance(unsigned int *instance_ptr)
 	if (instance >= instances.bit_count) {
 		/* Nothing free after next, so wrap around to instance zero. */
 		instance = find_first_zero_bit(instances.words, instances.bit_count);
-		result = ASSERT(instance < instances.bit_count,
-				"impossibly, no zero bit found");
-		if (result != UDS_SUCCESS)
+		result = VDO_ASSERT(instance < instances.bit_count,
+				    "impossibly, no zero bit found");
+		if (result != VDO_SUCCESS)
 			return result;
 	}
 
@@ -1729,8 +1729,8 @@ static int prepare_to_grow_physical(struct vdo *vdo, block_count_t new_physical_
 
 	uds_log_info("Preparing to resize physical to %llu",
 		     (unsigned long long) new_physical_blocks);
-	ASSERT_LOG_ONLY((new_physical_blocks > current_physical_blocks),
-			"New physical size is larger than current physical size");
+	VDO_ASSERT_LOG_ONLY((new_physical_blocks > current_physical_blocks),
+			    "New physical size is larger than current physical size");
 	result = perform_admin_operation(vdo, PREPARE_GROW_PHYSICAL_PHASE_START,
 					 check_may_grow_physical,
 					 finish_operation_callback,
@@ -1829,8 +1829,8 @@ static int prepare_to_modify(struct dm_target *ti, struct device_config *config,
 
 		uds_log_info("Preparing to resize logical to %llu",
 			     (unsigned long long) config->logical_blocks);
-		ASSERT_LOG_ONLY((config->logical_blocks > logical_blocks),
-				"New logical size is larger than current size");
+		VDO_ASSERT_LOG_ONLY((config->logical_blocks > logical_blocks),
+				    "New logical size is larger than current size");
 
 		result = vdo_prepare_to_grow_block_map(vdo->block_map,
 						       config->logical_blocks);
@@ -2890,9 +2890,9 @@ static void vdo_module_destroy(void)
 	if (dm_registered)
 		dm_unregister_target(&vdo_target_bio);
 
-	ASSERT_LOG_ONLY(instances.count == 0,
-			"should have no instance numbers still in use, but have %u",
-			instances.count);
+	VDO_ASSERT_LOG_ONLY(instances.count == 0,
+			    "should have no instance numbers still in use, but have %u",
+			    instances.count);
 	vdo_free(instances.words);
 	memset(&instances, 0, sizeof(struct instance_tracker));
 
diff --git a/drivers/md/dm-vdo/encodings.c b/drivers/md/dm-vdo/encodings.c
index a97771fe0a43..e24c31bc3524 100644
--- a/drivers/md/dm-vdo/encodings.c
+++ b/drivers/md/dm-vdo/encodings.c
@@ -320,8 +320,8 @@ int __must_check vdo_parse_geometry_block(u8 *block, struct volume_geometry *geo
 
 	decode_volume_geometry(block, &offset, geometry, header.version.major_version);
 
-	result = ASSERT(header.size == offset + sizeof(u32),
-			"should have decoded up to the geometry checksum");
+	result = VDO_ASSERT(header.size == offset + sizeof(u32),
+			    "should have decoded up to the geometry checksum");
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -380,25 +380,25 @@ static int decode_block_map_state_2_0(u8 *buffer, size_t *offset,
 	initial_offset = *offset;
 
 	decode_u64_le(buffer, offset, &flat_page_origin);
-	result = ASSERT(flat_page_origin == VDO_BLOCK_MAP_FLAT_PAGE_ORIGIN,
-			"Flat page origin must be %u (recorded as %llu)",
-			VDO_BLOCK_MAP_FLAT_PAGE_ORIGIN,
-			(unsigned long long) state->flat_page_origin);
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(flat_page_origin == VDO_BLOCK_MAP_FLAT_PAGE_ORIGIN,
+			    "Flat page origin must be %u (recorded as %llu)",
+			    VDO_BLOCK_MAP_FLAT_PAGE_ORIGIN,
+			    (unsigned long long) state->flat_page_origin);
+	if (result != VDO_SUCCESS)
 		return result;
 
 	decode_u64_le(buffer, offset, &flat_page_count);
-	result = ASSERT(flat_page_count == 0,
-			"Flat page count must be 0 (recorded as %llu)",
-			(unsigned long long) state->flat_page_count);
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(flat_page_count == 0,
+			    "Flat page count must be 0 (recorded as %llu)",
+			    (unsigned long long) state->flat_page_count);
+	if (result != VDO_SUCCESS)
 		return result;
 
 	decode_u64_le(buffer, offset, &root_origin);
 	decode_u64_le(buffer, offset, &root_count);
 
-	result = ASSERT(VDO_BLOCK_MAP_HEADER_2_0.size == *offset - initial_offset,
-			"decoded block map component size must match header size");
+	result = VDO_ASSERT(VDO_BLOCK_MAP_HEADER_2_0.size == *offset - initial_offset,
+			    "decoded block map component size must match header size");
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -425,8 +425,8 @@ static void encode_block_map_state_2_0(u8 *buffer, size_t *offset,
 	encode_u64_le(buffer, offset, state.root_origin);
 	encode_u64_le(buffer, offset, state.root_count);
 
-	ASSERT_LOG_ONLY(VDO_BLOCK_MAP_HEADER_2_0.size == *offset - initial_offset,
-			"encoded block map component size must match header size");
+	VDO_ASSERT_LOG_ONLY(VDO_BLOCK_MAP_HEADER_2_0.size == *offset - initial_offset,
+			    "encoded block map component size must match header size");
 }
 
 /**
@@ -477,8 +477,8 @@ static void encode_recovery_journal_state_7_0(u8 *buffer, size_t *offset,
 	encode_u64_le(buffer, offset, state.logical_blocks_used);
 	encode_u64_le(buffer, offset, state.block_map_data_blocks);
 
-	ASSERT_LOG_ONLY(VDO_RECOVERY_JOURNAL_HEADER_7_0.size == *offset - initial_offset,
-			"encoded recovery journal component size must match header size");
+	VDO_ASSERT_LOG_ONLY(VDO_RECOVERY_JOURNAL_HEADER_7_0.size == *offset - initial_offset,
+			    "encoded recovery journal component size must match header size");
 }
 
 /**
@@ -508,9 +508,9 @@ static int __must_check decode_recovery_journal_state_7_0(u8 *buffer, size_t *of
 	decode_u64_le(buffer, offset, &logical_blocks_used);
 	decode_u64_le(buffer, offset, &block_map_data_blocks);
 
-	result = ASSERT(VDO_RECOVERY_JOURNAL_HEADER_7_0.size == *offset - initial_offset,
-			"decoded recovery journal component size must match header size");
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(VDO_RECOVERY_JOURNAL_HEADER_7_0.size == *offset - initial_offset,
+			    "decoded recovery journal component size must match header size");
+	if (result != VDO_SUCCESS)
 		return result;
 
 	*state = (struct recovery_journal_state_7_0) {
@@ -566,8 +566,8 @@ static void encode_slab_depot_state_2_0(u8 *buffer, size_t *offset,
 	encode_u64_le(buffer, offset, state.last_block);
 	buffer[(*offset)++] = state.zone_count;
 
-	ASSERT_LOG_ONLY(VDO_SLAB_DEPOT_HEADER_2_0.size == *offset - initial_offset,
-			"encoded block map component size must match header size");
+	VDO_ASSERT_LOG_ONLY(VDO_SLAB_DEPOT_HEADER_2_0.size == *offset - initial_offset,
+			    "encoded block map component size must match header size");
 }
 
 /**
@@ -618,9 +618,9 @@ static int decode_slab_depot_state_2_0(u8 *buffer, size_t *offset,
 	decode_u64_le(buffer, offset, &last_block);
 	zone_count = buffer[(*offset)++];
 
-	result = ASSERT(VDO_SLAB_DEPOT_HEADER_2_0.size == *offset - initial_offset,
-			"decoded slab depot component size must match header size");
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(VDO_SLAB_DEPOT_HEADER_2_0.size == *offset - initial_offset,
+			    "decoded slab depot component size must match header size");
+	if (result != VDO_SUCCESS)
 		return result;
 
 	*state = (struct slab_depot_state_2_0) {
@@ -970,7 +970,7 @@ struct partition *vdo_get_known_partition(struct layout *layout, enum partition_
 	struct partition *partition;
 	int result = vdo_get_partition(layout, id, &partition);
 
-	ASSERT_LOG_ONLY(result == VDO_SUCCESS, "layout has expected partition: %u", id);
+	VDO_ASSERT_LOG_ONLY(result == VDO_SUCCESS, "layout has expected partition: %u", id);
 
 	return partition;
 }
@@ -982,8 +982,8 @@ static void encode_layout(u8 *buffer, size_t *offset, const struct layout *layou
 	struct header header = VDO_LAYOUT_HEADER_3_0;
 
 	BUILD_BUG_ON(sizeof(enum partition_id) != sizeof(u8));
-	ASSERT_LOG_ONLY(layout->num_partitions <= U8_MAX,
-			"layout partition count must fit in a byte");
+	VDO_ASSERT_LOG_ONLY(layout->num_partitions <= U8_MAX,
+			    "layout partition count must fit in a byte");
 
 	vdo_encode_header(buffer, offset, &header);
 
@@ -992,8 +992,8 @@ static void encode_layout(u8 *buffer, size_t *offset, const struct layout *layou
 	encode_u64_le(buffer, offset, layout->last_free);
 	buffer[(*offset)++] = layout->num_partitions;
 
-	ASSERT_LOG_ONLY(sizeof(struct layout_3_0) == *offset - initial_offset,
-			"encoded size of a layout header must match structure");
+	VDO_ASSERT_LOG_ONLY(sizeof(struct layout_3_0) == *offset - initial_offset,
+			    "encoded size of a layout header must match structure");
 
 	for (partition = layout->head; partition != NULL; partition = partition->next) {
 		buffer[(*offset)++] = partition->id;
@@ -1003,8 +1003,8 @@ static void encode_layout(u8 *buffer, size_t *offset, const struct layout *layou
 		encode_u64_le(buffer, offset, partition->count);
 	}
 
-	ASSERT_LOG_ONLY(header.size == *offset - initial_offset,
-			"encoded size of a layout must match header size");
+	VDO_ASSERT_LOG_ONLY(header.size == *offset - initial_offset,
+			    "encoded size of a layout must match header size");
 }
 
 static int decode_layout(u8 *buffer, size_t *offset, physical_block_number_t start,
@@ -1035,8 +1035,8 @@ static int decode_layout(u8 *buffer, size_t *offset, physical_block_number_t sta
 		.partition_count = partition_count,
 	};
 
-	result = ASSERT(sizeof(struct layout_3_0) == *offset - initial_offset,
-			"decoded size of a layout header must match structure");
+	result = VDO_ASSERT(sizeof(struct layout_3_0) == *offset - initial_offset,
+			    "decoded size of a layout header must match structure");
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -1208,29 +1208,29 @@ int vdo_validate_config(const struct vdo_config *config,
 	struct slab_config slab_config;
 	int result;
 
-	result = ASSERT(config->slab_size > 0, "slab size unspecified");
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(config->slab_size > 0, "slab size unspecified");
+	if (result != VDO_SUCCESS)
 		return result;
 
-	result = ASSERT(is_power_of_2(config->slab_size),
-			"slab size must be a power of two");
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(is_power_of_2(config->slab_size),
+			    "slab size must be a power of two");
+	if (result != VDO_SUCCESS)
 		return result;
 
-	result = ASSERT(config->slab_size <= (1 << MAX_VDO_SLAB_BITS),
-			"slab size must be less than or equal to 2^%d",
-			MAX_VDO_SLAB_BITS);
+	result = VDO_ASSERT(config->slab_size <= (1 << MAX_VDO_SLAB_BITS),
+			    "slab size must be less than or equal to 2^%d",
+			    MAX_VDO_SLAB_BITS);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = ASSERT(config->slab_journal_blocks >= MINIMUM_VDO_SLAB_JOURNAL_BLOCKS,
-			"slab journal size meets minimum size");
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(config->slab_journal_blocks >= MINIMUM_VDO_SLAB_JOURNAL_BLOCKS,
+			    "slab journal size meets minimum size");
+	if (result != VDO_SUCCESS)
 		return result;
 
-	result = ASSERT(config->slab_journal_blocks <= config->slab_size,
-			"slab journal size is within expected bound");
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(config->slab_journal_blocks <= config->slab_size,
+			    "slab journal size is within expected bound");
+	if (result != VDO_SUCCESS)
 		return result;
 
 	result = vdo_configure_slab(config->slab_size, config->slab_journal_blocks,
@@ -1238,20 +1238,20 @@ int vdo_validate_config(const struct vdo_config *config,
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = ASSERT((slab_config.data_blocks >= 1),
-			"slab must be able to hold at least one block");
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT((slab_config.data_blocks >= 1),
+			    "slab must be able to hold at least one block");
+	if (result != VDO_SUCCESS)
 		return result;
 
-	result = ASSERT(config->physical_blocks > 0, "physical blocks unspecified");
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(config->physical_blocks > 0, "physical blocks unspecified");
+	if (result != VDO_SUCCESS)
 		return result;
 
-	result = ASSERT(config->physical_blocks <= MAXIMUM_VDO_PHYSICAL_BLOCKS,
-			"physical block count %llu exceeds maximum %llu",
-			(unsigned long long) config->physical_blocks,
-			(unsigned long long) MAXIMUM_VDO_PHYSICAL_BLOCKS);
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(config->physical_blocks <= MAXIMUM_VDO_PHYSICAL_BLOCKS,
+			    "physical block count %llu exceeds maximum %llu",
+			    (unsigned long long) config->physical_blocks,
+			    (unsigned long long) MAXIMUM_VDO_PHYSICAL_BLOCKS);
+	if (result != VDO_SUCCESS)
 		return VDO_OUT_OF_RANGE;
 
 	if (physical_block_count != config->physical_blocks) {
@@ -1262,9 +1262,9 @@ int vdo_validate_config(const struct vdo_config *config,
 	}
 
 	if (logical_block_count > 0) {
-		result = ASSERT((config->logical_blocks > 0),
-				"logical blocks unspecified");
-		if (result != UDS_SUCCESS)
+		result = VDO_ASSERT((config->logical_blocks > 0),
+				    "logical blocks unspecified");
+		if (result != VDO_SUCCESS)
 			return result;
 
 		if (logical_block_count != config->logical_blocks) {
@@ -1275,19 +1275,19 @@ int vdo_validate_config(const struct vdo_config *config,
 		}
 	}
 
-	result = ASSERT(config->logical_blocks <= MAXIMUM_VDO_LOGICAL_BLOCKS,
-			"logical blocks too large");
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(config->logical_blocks <= MAXIMUM_VDO_LOGICAL_BLOCKS,
+			    "logical blocks too large");
+	if (result != VDO_SUCCESS)
 		return result;
 
-	result = ASSERT(config->recovery_journal_size > 0,
-			"recovery journal size unspecified");
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(config->recovery_journal_size > 0,
+			    "recovery journal size unspecified");
+	if (result != VDO_SUCCESS)
 		return result;
 
-	result = ASSERT(is_power_of_2(config->recovery_journal_size),
-			"recovery journal size must be a power of two");
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(is_power_of_2(config->recovery_journal_size),
+			    "recovery journal size must be a power of two");
+	if (result != VDO_SUCCESS)
 		return result;
 
 	return result;
@@ -1341,8 +1341,8 @@ static int __must_check decode_components(u8 *buffer, size_t *offset,
 	if (result != VDO_SUCCESS)
 		return result;
 
-	ASSERT_LOG_ONLY(*offset == VDO_COMPONENT_DATA_OFFSET + VDO_COMPONENT_DATA_SIZE,
-			"All decoded component data was used");
+	VDO_ASSERT_LOG_ONLY(*offset == VDO_COMPONENT_DATA_OFFSET + VDO_COMPONENT_DATA_SIZE,
+			    "All decoded component data was used");
 	return VDO_SUCCESS;
 }
 
@@ -1416,8 +1416,8 @@ static void vdo_encode_component_states(u8 *buffer, size_t *offset,
 	encode_slab_depot_state_2_0(buffer, offset, states->slab_depot);
 	encode_block_map_state_2_0(buffer, offset, states->block_map);
 
-	ASSERT_LOG_ONLY(*offset == VDO_COMPONENT_DATA_OFFSET + VDO_COMPONENT_DATA_SIZE,
-			"All super block component data was encoded");
+	VDO_ASSERT_LOG_ONLY(*offset == VDO_COMPONENT_DATA_OFFSET + VDO_COMPONENT_DATA_SIZE,
+			    "All super block component data was encoded");
 }
 
 /**
@@ -1440,8 +1440,8 @@ void vdo_encode_super_block(u8 *buffer, struct vdo_component_states *states)
 	 * Even though the buffer is a full block, to avoid the potential corruption from a torn
 	 * write, the entire encoding must fit in the first sector.
 	 */
-	ASSERT_LOG_ONLY(offset <= VDO_SECTOR_SIZE,
-			"entire superblock must fit in one sector");
+	VDO_ASSERT_LOG_ONLY(offset <= VDO_SECTOR_SIZE,
+			    "entire superblock must fit in one sector");
 }
 
 /**
@@ -1476,8 +1476,8 @@ int vdo_decode_super_block(u8 *buffer)
 	checksum = vdo_crc32(buffer, offset);
 	decode_u32_le(buffer, &offset, &saved_checksum);
 
-	result = ASSERT(offset == VDO_SUPER_BLOCK_FIXED_SIZE + VDO_COMPONENT_DATA_SIZE,
-			"must have decoded entire superblock payload");
+	result = VDO_ASSERT(offset == VDO_SUPER_BLOCK_FIXED_SIZE + VDO_COMPONENT_DATA_SIZE,
+			    "must have decoded entire superblock payload");
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/errors.c b/drivers/md/dm-vdo/errors.c
index df2498553312..3b5fddad8ddf 100644
--- a/drivers/md/dm-vdo/errors.c
+++ b/drivers/md/dm-vdo/errors.c
@@ -281,8 +281,9 @@ int uds_register_error_block(const char *block_name, int first_error,
 		.infos = infos,
 	};
 
-	result = ASSERT(first_error < next_free_error, "well-defined error block range");
-	if (result != UDS_SUCCESS)
+	result = VDO_ASSERT(first_error < next_free_error,
+			    "well-defined error block range");
+	if (result != VDO_SUCCESS)
 		return result;
 
 	if (registered_errors.count == registered_errors.allocated) {
diff --git a/drivers/md/dm-vdo/flush.c b/drivers/md/dm-vdo/flush.c
index 8d8d9cf4a24c..e03679e4d1ba 100644
--- a/drivers/md/dm-vdo/flush.c
+++ b/drivers/md/dm-vdo/flush.c
@@ -59,8 +59,8 @@ struct flusher {
  */
 static inline void assert_on_flusher_thread(struct flusher *flusher, const char *caller)
 {
-	ASSERT_LOG_ONLY((vdo_get_callback_thread_id() == flusher->thread_id),
-			"%s() called from flusher thread", caller);
+	VDO_ASSERT_LOG_ONLY((vdo_get_callback_thread_id() == flusher->thread_id),
+			    "%s() called from flusher thread", caller);
 }
 
 /**
@@ -272,8 +272,8 @@ static void flush_vdo(struct vdo_completion *completion)
 	int result;
 
 	assert_on_flusher_thread(flusher, __func__);
-	result = ASSERT(vdo_is_state_normal(&flusher->state),
-			"flusher is in normal operation");
+	result = VDO_ASSERT(vdo_is_state_normal(&flusher->state),
+			    "flusher is in normal operation");
 	if (result != VDO_SUCCESS) {
 		vdo_enter_read_only_mode(flusher->vdo, result);
 		vdo_complete_flush(flush);
@@ -330,11 +330,11 @@ void vdo_complete_flushes(struct flusher *flusher)
 		if (flush->flush_generation >= oldest_active_generation)
 			return;
 
-		ASSERT_LOG_ONLY((flush->flush_generation ==
-				 flusher->first_unacknowledged_generation),
-				"acknowledged next expected flush, %llu, was: %llu",
-				(unsigned long long) flusher->first_unacknowledged_generation,
-				(unsigned long long) flush->flush_generation);
+		VDO_ASSERT_LOG_ONLY((flush->flush_generation ==
+				     flusher->first_unacknowledged_generation),
+				    "acknowledged next expected flush, %llu, was: %llu",
+				    (unsigned long long) flusher->first_unacknowledged_generation,
+				    (unsigned long long) flush->flush_generation);
 		vdo_waitq_dequeue_waiter(&flusher->pending_flushes);
 		vdo_complete_flush(flush);
 		flusher->first_unacknowledged_generation++;
@@ -400,8 +400,8 @@ void vdo_launch_flush(struct vdo *vdo, struct bio *bio)
 	struct flusher *flusher = vdo->flusher;
 	const struct admin_state_code *code = vdo_get_admin_state_code(&flusher->state);
 
-	ASSERT_LOG_ONLY(!code->quiescent, "Flushing not allowed in state %s",
-			code->name);
+	VDO_ASSERT_LOG_ONLY(!code->quiescent, "Flushing not allowed in state %s",
+			    code->name);
 
 	spin_lock(&flusher->lock);
 
diff --git a/drivers/md/dm-vdo/funnel-workqueue.c b/drivers/md/dm-vdo/funnel-workqueue.c
index a923432f0a37..03296e7fec12 100644
--- a/drivers/md/dm-vdo/funnel-workqueue.c
+++ b/drivers/md/dm-vdo/funnel-workqueue.c
@@ -110,14 +110,14 @@ static struct vdo_completion *poll_for_completion(struct simple_work_queue *queu
 static void enqueue_work_queue_completion(struct simple_work_queue *queue,
 					  struct vdo_completion *completion)
 {
-	ASSERT_LOG_ONLY(completion->my_queue == NULL,
-			"completion %px (fn %px) to enqueue (%px) is not already queued (%px)",
-			completion, completion->callback, queue, completion->my_queue);
+	VDO_ASSERT_LOG_ONLY(completion->my_queue == NULL,
+			    "completion %px (fn %px) to enqueue (%px) is not already queued (%px)",
+			    completion, completion->callback, queue, completion->my_queue);
 	if (completion->priority == VDO_WORK_Q_DEFAULT_PRIORITY)
 		completion->priority = queue->common.type->default_priority;
 
-	if (ASSERT(completion->priority <= queue->common.type->max_priority,
-		   "priority is in range for queue") != VDO_SUCCESS)
+	if (VDO_ASSERT(completion->priority <= queue->common.type->max_priority,
+		       "priority is in range for queue") != VDO_SUCCESS)
 		completion->priority = 0;
 
 	completion->my_queue = &queue->common;
@@ -222,9 +222,9 @@ static struct vdo_completion *wait_for_next_completion(struct simple_work_queue
 static void process_completion(struct simple_work_queue *queue,
 			       struct vdo_completion *completion)
 {
-	if (ASSERT(completion->my_queue == &queue->common,
-		   "completion %px from queue %px marked as being in this queue (%px)",
-		   completion, queue, completion->my_queue) == UDS_SUCCESS)
+	if (VDO_ASSERT(completion->my_queue == &queue->common,
+		       "completion %px from queue %px marked as being in this queue (%px)",
+		       completion, queue, completion->my_queue) == VDO_SUCCESS)
 		completion->my_queue = NULL;
 
 	vdo_run_completion(completion);
@@ -319,9 +319,9 @@ static int make_simple_work_queue(const char *thread_name_prefix, const char *na
 	struct task_struct *thread = NULL;
 	int result;
 
-	ASSERT_LOG_ONLY((type->max_priority <= VDO_WORK_Q_MAX_PRIORITY),
-			"queue priority count %u within limit %u", type->max_priority,
-			VDO_WORK_Q_MAX_PRIORITY);
+	VDO_ASSERT_LOG_ONLY((type->max_priority <= VDO_WORK_Q_MAX_PRIORITY),
+			    "queue priority count %u within limit %u", type->max_priority,
+			    VDO_WORK_Q_MAX_PRIORITY);
 
 	result = vdo_allocate(1, struct simple_work_queue, "simple work queue", &queue);
 	if (result != VDO_SUCCESS)
diff --git a/drivers/md/dm-vdo/io-submitter.c b/drivers/md/dm-vdo/io-submitter.c
index e82b4a8c6fc4..61bb48068c3a 100644
--- a/drivers/md/dm-vdo/io-submitter.c
+++ b/drivers/md/dm-vdo/io-submitter.c
@@ -94,7 +94,7 @@ static void count_all_bios(struct vio *vio, struct bio *bio)
  */
 static void assert_in_bio_zone(struct vio *vio)
 {
-	ASSERT_LOG_ONLY(!in_interrupt(), "not in interrupt context");
+	VDO_ASSERT_LOG_ONLY(!in_interrupt(), "not in interrupt context");
 	assert_vio_in_bio_zone(vio);
 }
 
@@ -300,7 +300,7 @@ static bool try_bio_map_merge(struct vio *vio)
 	mutex_unlock(&bio_queue_data->lock);
 
 	/* We don't care about failure of int_map_put in this case. */
-	ASSERT_LOG_ONLY(result == VDO_SUCCESS, "bio map insertion succeeds");
+	VDO_ASSERT_LOG_ONLY(result == VDO_SUCCESS, "bio map insertion succeeds");
 	return merged;
 }
 
@@ -345,8 +345,8 @@ void __submit_metadata_vio(struct vio *vio, physical_block_number_t physical,
 	const struct admin_state_code *code = vdo_get_admin_state(completion->vdo);
 
 
-	ASSERT_LOG_ONLY(!code->quiescent, "I/O not allowed in state %s", code->name);
-	ASSERT_LOG_ONLY(vio->bio->bi_next == NULL, "metadata bio has no next bio");
+	VDO_ASSERT_LOG_ONLY(!code->quiescent, "I/O not allowed in state %s", code->name);
+	VDO_ASSERT_LOG_ONLY(vio->bio->bi_next == NULL, "metadata bio has no next bio");
 
 	vdo_reset_completion(completion);
 	completion->error_handler = error_handler;
diff --git a/drivers/md/dm-vdo/logical-zone.c b/drivers/md/dm-vdo/logical-zone.c
index ca5bc3be7978..300f9d2d2d5c 100644
--- a/drivers/md/dm-vdo/logical-zone.c
+++ b/drivers/md/dm-vdo/logical-zone.c
@@ -142,8 +142,8 @@ void vdo_free_logical_zones(struct logical_zones *zones)
 
 static inline void assert_on_zone_thread(struct logical_zone *zone, const char *what)
 {
-	ASSERT_LOG_ONLY((vdo_get_callback_thread_id() == zone->thread_id),
-			"%s() called on correct thread", what);
+	VDO_ASSERT_LOG_ONLY((vdo_get_callback_thread_id() == zone->thread_id),
+			    "%s() called on correct thread", what);
 }
 
 /**
@@ -247,10 +247,10 @@ void vdo_increment_logical_zone_flush_generation(struct logical_zone *zone,
 						 sequence_number_t expected_generation)
 {
 	assert_on_zone_thread(zone, __func__);
-	ASSERT_LOG_ONLY((zone->flush_generation == expected_generation),
-			"logical zone %u flush generation %llu should be %llu before increment",
-			zone->zone_number, (unsigned long long) zone->flush_generation,
-			(unsigned long long) expected_generation);
+	VDO_ASSERT_LOG_ONLY((zone->flush_generation == expected_generation),
+			    "logical zone %u flush generation %llu should be %llu before increment",
+			    zone->zone_number, (unsigned long long) zone->flush_generation,
+			    (unsigned long long) expected_generation);
 
 	zone->flush_generation++;
 	zone->ios_in_flush_generation = 0;
@@ -267,7 +267,7 @@ void vdo_acquire_flush_generation_lock(struct data_vio *data_vio)
 	struct logical_zone *zone = data_vio->logical.zone;
 
 	assert_on_zone_thread(zone, __func__);
-	ASSERT_LOG_ONLY(vdo_is_state_normal(&zone->state), "vdo state is normal");
+	VDO_ASSERT_LOG_ONLY(vdo_is_state_normal(&zone->state), "vdo state is normal");
 
 	data_vio->flush_generation = zone->flush_generation;
 	list_add_tail(&data_vio->write_entry, &zone->write_vios);
@@ -332,10 +332,10 @@ void vdo_release_flush_generation_lock(struct data_vio *data_vio)
 		return;
 
 	list_del_init(&data_vio->write_entry);
-	ASSERT_LOG_ONLY((zone->oldest_active_generation <= data_vio->flush_generation),
-			"data_vio releasing lock on generation %llu is not older than oldest active generation %llu",
-			(unsigned long long) data_vio->flush_generation,
-			(unsigned long long) zone->oldest_active_generation);
+	VDO_ASSERT_LOG_ONLY((zone->oldest_active_generation <= data_vio->flush_generation),
+			    "data_vio releasing lock on generation %llu is not older than oldest active generation %llu",
+			    (unsigned long long) data_vio->flush_generation,
+			    (unsigned long long) zone->oldest_active_generation);
 
 	if (!update_oldest_active_generation(zone) || zone->notifying)
 		return;
diff --git a/drivers/md/dm-vdo/memory-alloc.c b/drivers/md/dm-vdo/memory-alloc.c
index dd5acc582fb3..62bb717c4c50 100644
--- a/drivers/md/dm-vdo/memory-alloc.c
+++ b/drivers/md/dm-vdo/memory-alloc.c
@@ -385,12 +385,12 @@ void vdo_memory_init(void)
 
 void vdo_memory_exit(void)
 {
-	ASSERT_LOG_ONLY(memory_stats.kmalloc_bytes == 0,
-			"kmalloc memory used (%zd bytes in %zd blocks) is returned to the kernel",
-			memory_stats.kmalloc_bytes, memory_stats.kmalloc_blocks);
-	ASSERT_LOG_ONLY(memory_stats.vmalloc_bytes == 0,
-			"vmalloc memory used (%zd bytes in %zd blocks) is returned to the kernel",
-			memory_stats.vmalloc_bytes, memory_stats.vmalloc_blocks);
+	VDO_ASSERT_LOG_ONLY(memory_stats.kmalloc_bytes == 0,
+			    "kmalloc memory used (%zd bytes in %zd blocks) is returned to the kernel",
+			    memory_stats.kmalloc_bytes, memory_stats.kmalloc_blocks);
+	VDO_ASSERT_LOG_ONLY(memory_stats.vmalloc_bytes == 0,
+			    "vmalloc memory used (%zd bytes in %zd blocks) is returned to the kernel",
+			    memory_stats.vmalloc_bytes, memory_stats.vmalloc_blocks);
 	uds_log_debug("peak usage %zd bytes", memory_stats.peak_bytes);
 }
 
diff --git a/drivers/md/dm-vdo/packer.c b/drivers/md/dm-vdo/packer.c
index 5774d8fd5c5a..4d45243161a6 100644
--- a/drivers/md/dm-vdo/packer.c
+++ b/drivers/md/dm-vdo/packer.c
@@ -86,8 +86,8 @@ int vdo_get_compressed_block_fragment(enum block_mapping_state mapping_state,
  */
 static inline void assert_on_packer_thread(struct packer *packer, const char *caller)
 {
-	ASSERT_LOG_ONLY((vdo_get_callback_thread_id() == packer->thread_id),
-			"%s() called from packer thread", caller);
+	VDO_ASSERT_LOG_ONLY((vdo_get_callback_thread_id() == packer->thread_id),
+			    "%s() called from packer thread", caller);
 }
 
 /**
@@ -569,9 +569,9 @@ void vdo_attempt_packing(struct data_vio *data_vio)
 
 	assert_on_packer_thread(packer, __func__);
 
-	result = ASSERT((status.stage == DATA_VIO_COMPRESSING),
-			"attempt to pack data_vio not ready for packing, stage: %u",
-			status.stage);
+	result = VDO_ASSERT((status.stage == DATA_VIO_COMPRESSING),
+			    "attempt to pack data_vio not ready for packing, stage: %u",
+			    status.stage);
 	if (result != VDO_SUCCESS)
 		return;
 
@@ -671,7 +671,7 @@ void vdo_remove_lock_holder_from_packer(struct vdo_completion *completion)
 
 	lock_holder = vdo_forget(data_vio->compression.lock_holder);
 	bin = lock_holder->compression.bin;
-	ASSERT_LOG_ONLY((bin != NULL), "data_vio in packer has a bin");
+	VDO_ASSERT_LOG_ONLY((bin != NULL), "data_vio in packer has a bin");
 
 	slot = lock_holder->compression.slot;
 	bin->slots_used--;
diff --git a/drivers/md/dm-vdo/permassert.h b/drivers/md/dm-vdo/permassert.h
index ee978bc115ec..8774dde7927a 100644
--- a/drivers/md/dm-vdo/permassert.h
+++ b/drivers/md/dm-vdo/permassert.h
@@ -13,7 +13,6 @@
 /* Utilities for asserting that certain conditions are met */
 
 #define STRINGIFY(X) #X
-#define STRINGIFY_VALUE(X) STRINGIFY(X)
 
 /*
  * A hack to apply the "warn if unused" attribute to an integral expression.
@@ -23,19 +22,23 @@
  * expression. With optimization enabled, this function contributes no additional instructions, but
  * the warn_unused_result attribute still applies to the code calling it.
  */
-static inline int __must_check uds_must_use(int value)
+static inline int __must_check vdo_must_use(int value)
 {
 	return value;
 }
 
 /* Assert that an expression is true and return an error if it is not. */
-#define ASSERT(expr, ...) uds_must_use(__UDS_ASSERT(expr, __VA_ARGS__))
+#define VDO_ASSERT(expr, ...) vdo_must_use(__VDO_ASSERT(expr, __VA_ARGS__))
 
 /* Log a message if the expression is not true. */
-#define ASSERT_LOG_ONLY(expr, ...) __UDS_ASSERT(expr, __VA_ARGS__)
+#define VDO_ASSERT_LOG_ONLY(expr, ...) __VDO_ASSERT(expr, __VA_ARGS__)
 
-#define __UDS_ASSERT(expr, ...)				      \
-	(likely(expr) ? UDS_SUCCESS			      \
+/* For use by UDS */
+#define ASSERT(expr, ...) VDO_ASSERT(expr, __VA_ARGS__)
+#define ASSERT_LOG_ONLY(expr, ...) __VDO_ASSERT(expr, __VA_ARGS__)
+
+#define __VDO_ASSERT(expr, ...)				      \
+	(likely(expr) ? VDO_SUCCESS			      \
 		      : uds_assertion_failed(STRINGIFY(expr), __FILE__, __LINE__, __VA_ARGS__))
 
 /* Log an assertion failure message. */
diff --git a/drivers/md/dm-vdo/physical-zone.c b/drivers/md/dm-vdo/physical-zone.c
index fadcea23288e..6678f472fb44 100644
--- a/drivers/md/dm-vdo/physical-zone.c
+++ b/drivers/md/dm-vdo/physical-zone.c
@@ -80,13 +80,13 @@ static inline void set_pbn_lock_type(struct pbn_lock *lock, enum pbn_lock_type t
  */
 void vdo_downgrade_pbn_write_lock(struct pbn_lock *lock, bool compressed_write)
 {
-	ASSERT_LOG_ONLY(!vdo_is_pbn_read_lock(lock),
-			"PBN lock must not already have been downgraded");
-	ASSERT_LOG_ONLY(!has_lock_type(lock, VIO_BLOCK_MAP_WRITE_LOCK),
-			"must not downgrade block map write locks");
-	ASSERT_LOG_ONLY(lock->holder_count == 1,
-			"PBN write lock should have one holder but has %u",
-			lock->holder_count);
+	VDO_ASSERT_LOG_ONLY(!vdo_is_pbn_read_lock(lock),
+			    "PBN lock must not already have been downgraded");
+	VDO_ASSERT_LOG_ONLY(!has_lock_type(lock, VIO_BLOCK_MAP_WRITE_LOCK),
+			    "must not downgrade block map write locks");
+	VDO_ASSERT_LOG_ONLY(lock->holder_count == 1,
+			    "PBN write lock should have one holder but has %u",
+			    lock->holder_count);
 	/*
 	 * data_vio write locks are downgraded in place--the writer retains the hold on the lock.
 	 * If this was a compressed write, the holder has not yet journaled its own inc ref,
@@ -128,8 +128,8 @@ bool vdo_claim_pbn_lock_increment(struct pbn_lock *lock)
  */
 void vdo_assign_pbn_lock_provisional_reference(struct pbn_lock *lock)
 {
-	ASSERT_LOG_ONLY(!lock->has_provisional_reference,
-			"lock does not have a provisional reference");
+	VDO_ASSERT_LOG_ONLY(!lock->has_provisional_reference,
+			    "lock does not have a provisional reference");
 	lock->has_provisional_reference = true;
 }
 
@@ -221,7 +221,7 @@ static void return_pbn_lock_to_pool(struct pbn_lock_pool *pool, struct pbn_lock
 	INIT_LIST_HEAD(&idle->entry);
 	list_add_tail(&idle->entry, &pool->idle_list);
 
-	ASSERT_LOG_ONLY(pool->borrowed > 0, "shouldn't return more than borrowed");
+	VDO_ASSERT_LOG_ONLY(pool->borrowed > 0, "shouldn't return more than borrowed");
 	pool->borrowed -= 1;
 }
 
@@ -267,9 +267,9 @@ static void free_pbn_lock_pool(struct pbn_lock_pool *pool)
 	if (pool == NULL)
 		return;
 
-	ASSERT_LOG_ONLY(pool->borrowed == 0,
-			"All PBN locks must be returned to the pool before it is freed, but %zu locks are still on loan",
-			pool->borrowed);
+	VDO_ASSERT_LOG_ONLY(pool->borrowed == 0,
+			    "All PBN locks must be returned to the pool before it is freed, but %zu locks are still on loan",
+			    pool->borrowed);
 	vdo_free(pool);
 }
 
@@ -298,8 +298,8 @@ static int __must_check borrow_pbn_lock_from_pool(struct pbn_lock_pool *pool,
 					      "no free PBN locks left to borrow");
 	pool->borrowed += 1;
 
-	result = ASSERT(!list_empty(&pool->idle_list),
-			"idle list should not be empty if pool not at capacity");
+	result = VDO_ASSERT(!list_empty(&pool->idle_list),
+			    "idle list should not be empty if pool not at capacity");
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -447,7 +447,7 @@ int vdo_attempt_physical_zone_pbn_lock(struct physical_zone *zone,
 
 	result = borrow_pbn_lock_from_pool(zone->lock_pool, type, &new_lock);
 	if (result != VDO_SUCCESS) {
-		ASSERT_LOG_ONLY(false, "must always be able to borrow a PBN lock");
+		VDO_ASSERT_LOG_ONLY(false, "must always be able to borrow a PBN lock");
 		return result;
 	}
 
@@ -461,8 +461,8 @@ int vdo_attempt_physical_zone_pbn_lock(struct physical_zone *zone,
 	if (lock != NULL) {
 		/* The lock is already held, so we don't need the borrowed one. */
 		return_pbn_lock_to_pool(zone->lock_pool, vdo_forget(new_lock));
-		result = ASSERT(lock->holder_count > 0, "physical block %llu lock held",
-				(unsigned long long) pbn);
+		result = VDO_ASSERT(lock->holder_count > 0, "physical block %llu lock held",
+				    (unsigned long long) pbn);
 		if (result != VDO_SUCCESS)
 			return result;
 		*lock_ptr = lock;
@@ -485,8 +485,8 @@ static int allocate_and_lock_block(struct allocation *allocation)
 	int result;
 	struct pbn_lock *lock;
 
-	ASSERT_LOG_ONLY(allocation->lock == NULL,
-			"must not allocate a block while already holding a lock on one");
+	VDO_ASSERT_LOG_ONLY(allocation->lock == NULL,
+			    "must not allocate a block while already holding a lock on one");
 
 	result = vdo_allocate_block(allocation->zone->allocator, &allocation->pbn);
 	if (result != VDO_SUCCESS)
@@ -617,8 +617,8 @@ void vdo_release_physical_zone_pbn_lock(struct physical_zone *zone,
 	if (lock == NULL)
 		return;
 
-	ASSERT_LOG_ONLY(lock->holder_count > 0,
-			"should not be releasing a lock that is not held");
+	VDO_ASSERT_LOG_ONLY(lock->holder_count > 0,
+			    "should not be releasing a lock that is not held");
 
 	lock->holder_count -= 1;
 	if (lock->holder_count > 0) {
@@ -627,8 +627,8 @@ void vdo_release_physical_zone_pbn_lock(struct physical_zone *zone,
 	}
 
 	holder = vdo_int_map_remove(zone->pbn_operations, locked_pbn);
-	ASSERT_LOG_ONLY((lock == holder), "physical block lock mismatch for block %llu",
-			(unsigned long long) locked_pbn);
+	VDO_ASSERT_LOG_ONLY((lock == holder), "physical block lock mismatch for block %llu",
+			    (unsigned long long) locked_pbn);
 
 	release_pbn_lock_provisional_reference(lock, locked_pbn, zone->allocator);
 	return_pbn_lock_to_pool(zone->lock_pool, lock);
diff --git a/drivers/md/dm-vdo/priority-table.c b/drivers/md/dm-vdo/priority-table.c
index fc99268d2437..42d3d8d0e4b5 100644
--- a/drivers/md/dm-vdo/priority-table.c
+++ b/drivers/md/dm-vdo/priority-table.c
@@ -127,8 +127,8 @@ void vdo_reset_priority_table(struct priority_table *table)
 void vdo_priority_table_enqueue(struct priority_table *table, unsigned int priority,
 				struct list_head *entry)
 {
-	ASSERT_LOG_ONLY((priority <= table->max_priority),
-			"entry priority must be valid for the table");
+	VDO_ASSERT_LOG_ONLY((priority <= table->max_priority),
+			    "entry priority must be valid for the table");
 
 	/* Append the entry to the queue in the specified bucket. */
 	list_move_tail(entry, &table->buckets[priority].queue);
diff --git a/drivers/md/dm-vdo/recovery-journal.c b/drivers/md/dm-vdo/recovery-journal.c
index 615755697e60..6df373b88042 100644
--- a/drivers/md/dm-vdo/recovery-journal.c
+++ b/drivers/md/dm-vdo/recovery-journal.c
@@ -119,8 +119,8 @@ static bool is_journal_zone_locked(struct recovery_journal *journal,
 
 	/* Pairs with barrier in vdo_release_journal_entry_lock() */
 	smp_rmb();
-	ASSERT_LOG_ONLY((decrements <= journal_value),
-			"journal zone lock counter must not underflow");
+	VDO_ASSERT_LOG_ONLY((decrements <= journal_value),
+			    "journal zone lock counter must not underflow");
 	return (journal_value != decrements);
 }
 
@@ -150,8 +150,8 @@ void vdo_release_recovery_journal_block_reference(struct recovery_journal *journ
 	lock_number = vdo_get_recovery_journal_block_number(journal, sequence_number);
 	current_value = get_counter(journal, lock_number, zone_type, zone_id);
 
-	ASSERT_LOG_ONLY((*current_value >= 1),
-			"decrement of lock counter must not underflow");
+	VDO_ASSERT_LOG_ONLY((*current_value >= 1),
+			    "decrement of lock counter must not underflow");
 	*current_value -= 1;
 
 	if (zone_type == VDO_ZONE_TYPE_JOURNAL) {
@@ -254,8 +254,8 @@ static inline bool __must_check is_block_full(const struct recovery_journal_bloc
 static void assert_on_journal_thread(struct recovery_journal *journal,
 				     const char *function_name)
 {
-	ASSERT_LOG_ONLY((vdo_get_callback_thread_id() == journal->thread_id),
-			"%s() called on journal thread", function_name);
+	VDO_ASSERT_LOG_ONLY((vdo_get_callback_thread_id() == journal->thread_id),
+			    "%s() called on journal thread", function_name);
 }
 
 /**
@@ -353,14 +353,14 @@ static void check_for_drain_complete(struct recovery_journal *journal)
 
 	if (vdo_is_state_saving(&journal->state)) {
 		if (journal->active_block != NULL) {
-			ASSERT_LOG_ONLY(((result == VDO_READ_ONLY) ||
-					 !is_block_dirty(journal->active_block)),
-					"journal being saved has clean active block");
+			VDO_ASSERT_LOG_ONLY(((result == VDO_READ_ONLY) ||
+					     !is_block_dirty(journal->active_block)),
+					    "journal being saved has clean active block");
 			recycle_journal_block(journal->active_block);
 		}
 
-		ASSERT_LOG_ONLY(list_empty(&journal->active_tail_blocks),
-				"all blocks in a journal being saved must be inactive");
+		VDO_ASSERT_LOG_ONLY(list_empty(&journal->active_tail_blocks),
+				    "all blocks in a journal being saved must be inactive");
 	}
 
 	vdo_finish_draining_with_result(&journal->state, result);
@@ -800,8 +800,8 @@ void vdo_free_recovery_journal(struct recovery_journal *journal)
 	 *        requires opening before use.
 	 */
 	if (!vdo_is_state_quiescent(&journal->state)) {
-		ASSERT_LOG_ONLY(list_empty(&journal->active_tail_blocks),
-				"journal being freed has no active tail blocks");
+		VDO_ASSERT_LOG_ONLY(list_empty(&journal->active_tail_blocks),
+				    "journal being freed has no active tail blocks");
 	} else if (!vdo_is_state_saved(&journal->state) &&
 		   !list_empty(&journal->active_tail_blocks)) {
 		uds_log_warning("journal being freed has uncommitted entries");
@@ -989,8 +989,8 @@ static void initialize_lock_count(struct recovery_journal *journal)
 	atomic_t *decrement_counter = get_decrement_counter(journal, lock_number);
 
 	journal_value = get_counter(journal, lock_number, VDO_ZONE_TYPE_JOURNAL, 0);
-	ASSERT_LOG_ONLY((*journal_value == atomic_read(decrement_counter)),
-			"count to be initialized not in use");
+	VDO_ASSERT_LOG_ONLY((*journal_value == atomic_read(decrement_counter)),
+			    "count to be initialized not in use");
 	*journal_value = journal->entries_per_block + 1;
 	atomic_set(decrement_counter, 0);
 }
@@ -1175,13 +1175,13 @@ static void continue_committed_waiter(struct vdo_waiter *waiter, void *context)
 	int result = (is_read_only(journal) ? VDO_READ_ONLY : VDO_SUCCESS);
 	bool has_decrement;
 
-	ASSERT_LOG_ONLY(vdo_before_journal_point(&journal->commit_point,
-						 &data_vio->recovery_journal_point),
-			"DataVIOs released from recovery journal in order. Recovery journal point is (%llu, %u), but commit waiter point is (%llu, %u)",
-			(unsigned long long) journal->commit_point.sequence_number,
-			journal->commit_point.entry_count,
-			(unsigned long long) data_vio->recovery_journal_point.sequence_number,
-			data_vio->recovery_journal_point.entry_count);
+	VDO_ASSERT_LOG_ONLY(vdo_before_journal_point(&journal->commit_point,
+						     &data_vio->recovery_journal_point),
+			    "DataVIOs released from recovery journal in order. Recovery journal point is (%llu, %u), but commit waiter point is (%llu, %u)",
+			    (unsigned long long) journal->commit_point.sequence_number,
+			    journal->commit_point.entry_count,
+			    (unsigned long long) data_vio->recovery_journal_point.sequence_number,
+			    data_vio->recovery_journal_point.entry_count);
 
 	journal->commit_point = data_vio->recovery_journal_point;
 	data_vio->last_async_operation = VIO_ASYNC_OP_UPDATE_REFERENCE_COUNTS;
@@ -1281,8 +1281,8 @@ static void complete_write(struct vdo_completion *completion)
 		journal->last_write_acknowledged = block->sequence_number;
 
 	last_active_block = get_journal_block(&journal->active_tail_blocks);
-	ASSERT_LOG_ONLY((block->sequence_number >= last_active_block->sequence_number),
-			"completed journal write is still active");
+	VDO_ASSERT_LOG_ONLY((block->sequence_number >= last_active_block->sequence_number),
+			    "completed journal write is still active");
 
 	notify_commit_waiters(journal);
 
@@ -1456,8 +1456,8 @@ void vdo_add_recovery_journal_entry(struct recovery_journal *journal,
 		return;
 	}
 
-	ASSERT_LOG_ONLY(data_vio->recovery_sequence_number == 0,
-			"journal lock not held for new entry");
+	VDO_ASSERT_LOG_ONLY(data_vio->recovery_sequence_number == 0,
+			    "journal lock not held for new entry");
 
 	vdo_advance_journal_point(&journal->append_point, journal->entries_per_block);
 	vdo_waitq_enqueue_waiter(&journal->entry_waiters, &data_vio->waiter);
@@ -1564,13 +1564,13 @@ void vdo_acquire_recovery_journal_block_reference(struct recovery_journal *journ
 	if (sequence_number == 0)
 		return;
 
-	ASSERT_LOG_ONLY((zone_type != VDO_ZONE_TYPE_JOURNAL),
-			"invalid lock count increment from journal zone");
+	VDO_ASSERT_LOG_ONLY((zone_type != VDO_ZONE_TYPE_JOURNAL),
+			    "invalid lock count increment from journal zone");
 
 	lock_number = vdo_get_recovery_journal_block_number(journal, sequence_number);
 	current_value = get_counter(journal, lock_number, zone_type, zone_id);
-	ASSERT_LOG_ONLY(*current_value < U16_MAX,
-			"increment of lock counter must not overflow");
+	VDO_ASSERT_LOG_ONLY(*current_value < U16_MAX,
+			    "increment of lock counter must not overflow");
 
 	if (*current_value == 0) {
 		/*
diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
index bfcdedeedb86..c7abb8078336 100644
--- a/drivers/md/dm-vdo/repair.c
+++ b/drivers/md/dm-vdo/repair.c
@@ -976,8 +976,8 @@ find_entry_starting_next_page(struct repair_completion *repair,
 		if (needs_sort) {
 			struct numbered_block_mapping *just_sorted_entry =
 				sort_next_heap_element(repair);
-			ASSERT_LOG_ONLY(just_sorted_entry < current_entry,
-					"heap is returning elements in an unexpected order");
+			VDO_ASSERT_LOG_ONLY(just_sorted_entry < current_entry,
+					    "heap is returning elements in an unexpected order");
 		}
 
 		current_entry--;
@@ -1129,8 +1129,8 @@ static void recover_block_map(struct vdo_completion *completion)
 
 	repair->current_entry = &repair->entries[repair->block_map_entry_count - 1];
 	first_sorted_entry = sort_next_heap_element(repair);
-	ASSERT_LOG_ONLY(first_sorted_entry == repair->current_entry,
-			"heap is returning elements in an unexpected order");
+	VDO_ASSERT_LOG_ONLY(first_sorted_entry == repair->current_entry,
+			    "heap is returning elements in an unexpected order");
 
 	/* Prevent any page from being processed until all pages have been launched. */
 	repair->launching = true;
@@ -1489,8 +1489,8 @@ static int extract_new_mappings(struct repair_completion *repair)
 		repair->block_map_entry_count++;
 	}
 
-	result = ASSERT((repair->block_map_entry_count <= repair->entry_count),
-			"approximate entry count is an upper bound");
+	result = VDO_ASSERT((repair->block_map_entry_count <= repair->entry_count),
+			    "approximate entry count is an upper bound");
 	if (result != VDO_SUCCESS)
 		vdo_enter_read_only_mode(vdo, result);
 
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 97208c9e0062..00746de09c12 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -149,7 +149,7 @@ static void mark_slab_journal_dirty(struct slab_journal *journal, sequence_numbe
 	struct slab_journal *dirty_journal;
 	struct list_head *dirty_list = &journal->slab->allocator->dirty_slab_journals;
 
-	ASSERT_LOG_ONLY(journal->recovery_lock == 0, "slab journal was clean");
+	VDO_ASSERT_LOG_ONLY(journal->recovery_lock == 0, "slab journal was clean");
 
 	journal->recovery_lock = lock;
 	list_for_each_entry_reverse(dirty_journal, dirty_list, dirty_entry) {
@@ -216,7 +216,7 @@ static u8 __must_check compute_fullness_hint(struct slab_depot *depot,
 {
 	block_count_t hint;
 
-	ASSERT_LOG_ONLY((free_blocks < (1 << 23)), "free blocks must be less than 2^23");
+	VDO_ASSERT_LOG_ONLY((free_blocks < (1 << 23)), "free blocks must be less than 2^23");
 
 	if (free_blocks == 0)
 		return 0;
@@ -532,13 +532,13 @@ static void adjust_slab_journal_block_reference(struct slab_journal *journal,
 		return;
 	}
 
-	ASSERT_LOG_ONLY((adjustment != 0), "adjustment must be non-zero");
+	VDO_ASSERT_LOG_ONLY((adjustment != 0), "adjustment must be non-zero");
 	lock = get_lock(journal, sequence_number);
 	if (adjustment < 0) {
-		ASSERT_LOG_ONLY((-adjustment <= lock->count),
-				"adjustment %d of lock count %u for slab journal block %llu must not underflow",
-				adjustment, lock->count,
-				(unsigned long long) sequence_number);
+		VDO_ASSERT_LOG_ONLY((-adjustment <= lock->count),
+				    "adjustment %d of lock count %u for slab journal block %llu must not underflow",
+				    adjustment, lock->count,
+				    (unsigned long long) sequence_number);
 	}
 
 	lock->count += adjustment;
@@ -661,16 +661,16 @@ static void reopen_slab_journal(struct vdo_slab *slab)
 	struct slab_journal *journal = &slab->journal;
 	sequence_number_t block;
 
-	ASSERT_LOG_ONLY(journal->tail_header.entry_count == 0,
-			"vdo_slab journal's active block empty before reopening");
+	VDO_ASSERT_LOG_ONLY(journal->tail_header.entry_count == 0,
+			    "vdo_slab journal's active block empty before reopening");
 	journal->head = journal->tail;
 	initialize_journal_state(journal);
 
 	/* Ensure no locks are spuriously held on an empty journal. */
 	for (block = 1; block <= journal->size; block++) {
-		ASSERT_LOG_ONLY((get_lock(journal, block)->count == 0),
-				"Scrubbed journal's block %llu is not locked",
-				(unsigned long long) block);
+		VDO_ASSERT_LOG_ONLY((get_lock(journal, block)->count == 0),
+				    "Scrubbed journal's block %llu is not locked",
+				    (unsigned long long) block);
 	}
 
 	add_entries(journal);
@@ -757,7 +757,7 @@ static void write_slab_journal_block(struct vdo_waiter *waiter, void *context)
 	/* Copy the tail block into the vio. */
 	memcpy(pooled->vio.data, journal->block, VDO_BLOCK_SIZE);
 
-	ASSERT_LOG_ONLY(unused_entries >= 0, "vdo_slab journal block is not overfull");
+	VDO_ASSERT_LOG_ONLY(unused_entries >= 0, "vdo_slab journal block is not overfull");
 	if (unused_entries > 0) {
 		/*
 		 * Release the per-entry locks for any unused entries in the block we are about to
@@ -907,22 +907,22 @@ static void add_entry(struct slab_journal *journal, physical_block_number_t pbn,
 	struct packed_slab_journal_block *block = journal->block;
 	int result;
 
-	result = ASSERT(vdo_before_journal_point(&journal->tail_header.recovery_point,
-						 &recovery_point),
-			"recovery journal point is monotonically increasing, recovery point: %llu.%u, block recovery point: %llu.%u",
-			(unsigned long long) recovery_point.sequence_number,
-			recovery_point.entry_count,
-			(unsigned long long) journal->tail_header.recovery_point.sequence_number,
-			journal->tail_header.recovery_point.entry_count);
+	result = VDO_ASSERT(vdo_before_journal_point(&journal->tail_header.recovery_point,
+						     &recovery_point),
+			    "recovery journal point is monotonically increasing, recovery point: %llu.%u, block recovery point: %llu.%u",
+			    (unsigned long long) recovery_point.sequence_number,
+			    recovery_point.entry_count,
+			    (unsigned long long) journal->tail_header.recovery_point.sequence_number,
+			    journal->tail_header.recovery_point.entry_count);
 	if (result != VDO_SUCCESS) {
 		vdo_enter_read_only_mode(journal->slab->allocator->depot->vdo, result);
 		return;
 	}
 
 	if (operation == VDO_JOURNAL_BLOCK_MAP_REMAPPING) {
-		result = ASSERT((journal->tail_header.entry_count <
-				 journal->full_entries_per_block),
-				"block has room for full entries");
+		result = VDO_ASSERT((journal->tail_header.entry_count <
+				     journal->full_entries_per_block),
+				    "block has room for full entries");
 		if (result != VDO_SUCCESS) {
 			vdo_enter_read_only_mode(journal->slab->allocator->depot->vdo,
 						 result);
@@ -1371,8 +1371,8 @@ static unsigned int calculate_slab_priority(struct vdo_slab *slab)
  */
 static void prioritize_slab(struct vdo_slab *slab)
 {
-	ASSERT_LOG_ONLY(list_empty(&slab->allocq_entry),
-			"a slab must not already be on a ring when prioritizing");
+	VDO_ASSERT_LOG_ONLY(list_empty(&slab->allocq_entry),
+			    "a slab must not already be on a ring when prioritizing");
 	slab->priority = calculate_slab_priority(slab);
 	vdo_priority_table_enqueue(slab->allocator->prioritized_slabs,
 				   slab->priority, &slab->allocq_entry);
@@ -1655,8 +1655,8 @@ static int __must_check adjust_reference_count(struct vdo_slab *slab,
 		 * the last time it was clean. We must release the per-entry slab journal lock for
 		 * the entry associated with the update we are now doing.
 		 */
-		result = ASSERT(is_valid_journal_point(slab_journal_point),
-				"Reference count adjustments need slab journal points.");
+		result = VDO_ASSERT(is_valid_journal_point(slab_journal_point),
+				    "Reference count adjustments need slab journal points.");
 		if (result != VDO_SUCCESS)
 			return result;
 
@@ -1825,16 +1825,16 @@ static void add_entries(struct slab_journal *journal)
 			 * scrubbing thresholds, this should never happen.
 			 */
 			if (lock->count > 0) {
-				ASSERT_LOG_ONLY((journal->head + journal->size) == journal->tail,
-						"New block has locks, but journal is not full");
+				VDO_ASSERT_LOG_ONLY((journal->head + journal->size) == journal->tail,
+						    "New block has locks, but journal is not full");
 
 				/*
 				 * The blocking threshold must let the journal fill up if the new
 				 * block has locks; if the blocking threshold is smaller than the
 				 * journal size, the new block cannot possibly have locks already.
 				 */
-				ASSERT_LOG_ONLY((journal->blocking_threshold >= journal->size),
-						"New block can have locks already iff blocking threshold is at the end of the journal");
+				VDO_ASSERT_LOG_ONLY((journal->blocking_threshold >= journal->size),
+						    "New block can have locks already iff blocking threshold is at the end of the journal");
 
 				WRITE_ONCE(journal->events->disk_full_count,
 					   journal->events->disk_full_count + 1);
@@ -2361,9 +2361,9 @@ static int allocate_slab_counters(struct vdo_slab *slab)
 	int result;
 	size_t index, bytes;
 
-	result = ASSERT(slab->reference_blocks == NULL,
-			"vdo_slab %u doesn't allocate refcounts twice",
-			slab->slab_number);
+	result = VDO_ASSERT(slab->reference_blocks == NULL,
+			    "vdo_slab %u doesn't allocate refcounts twice",
+			    slab->slab_number);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -2503,9 +2503,9 @@ static void load_slab_journal(struct vdo_slab *slab)
 		 * 1. This is impossible, due to the scrubbing threshold, on a real system, so
 		 * don't bother reading the (bogus) data off disk.
 		 */
-		ASSERT_LOG_ONLY(((journal->size < 16) ||
-				 (journal->scrubbing_threshold < (journal->size - 1))),
-				"Scrubbing threshold protects against reads of unwritten slab journal blocks");
+		VDO_ASSERT_LOG_ONLY(((journal->size < 16) ||
+				     (journal->scrubbing_threshold < (journal->size - 1))),
+				    "Scrubbing threshold protects against reads of unwritten slab journal blocks");
 		vdo_finish_loading_with_result(&slab->state,
 					       allocate_counters_if_clean(slab));
 		return;
@@ -2519,8 +2519,8 @@ static void register_slab_for_scrubbing(struct vdo_slab *slab, bool high_priorit
 {
 	struct slab_scrubber *scrubber = &slab->allocator->scrubber;
 
-	ASSERT_LOG_ONLY((slab->status != VDO_SLAB_REBUILT),
-			"slab to be scrubbed is unrecovered");
+	VDO_ASSERT_LOG_ONLY((slab->status != VDO_SLAB_REBUILT),
+			    "slab to be scrubbed is unrecovered");
 
 	if (slab->status != VDO_SLAB_REQUIRES_SCRUBBING)
 		return;
@@ -2547,17 +2547,17 @@ static void queue_slab(struct vdo_slab *slab)
 	block_count_t free_blocks;
 	int result;
 
-	ASSERT_LOG_ONLY(list_empty(&slab->allocq_entry),
+	VDO_ASSERT_LOG_ONLY(list_empty(&slab->allocq_entry),
 			"a requeued slab must not already be on a ring");
 
 	if (vdo_is_read_only(allocator->depot->vdo))
 		return;
 
 	free_blocks = slab->free_blocks;
-	result = ASSERT((free_blocks <= allocator->depot->slab_config.data_blocks),
-			"rebuilt slab %u must have a valid free block count (has %llu, expected maximum %llu)",
-			slab->slab_number, (unsigned long long) free_blocks,
-			(unsigned long long) allocator->depot->slab_config.data_blocks);
+	result = VDO_ASSERT((free_blocks <= allocator->depot->slab_config.data_blocks),
+			    "rebuilt slab %u must have a valid free block count (has %llu, expected maximum %llu)",
+			    slab->slab_number, (unsigned long long) free_blocks,
+			    (unsigned long long) allocator->depot->slab_config.data_blocks);
 	if (result != VDO_SUCCESS) {
 		vdo_enter_read_only_mode(allocator->depot->vdo, result);
 		return;
@@ -2880,9 +2880,9 @@ static void apply_journal_entries(struct vdo_completion *completion)
 	 * At the end of rebuild, the reference counters should be accurate to the end of the
 	 * journal we just applied.
 	 */
-	result = ASSERT(!vdo_before_journal_point(&last_entry_applied,
-						  &ref_counts_point),
-			"Refcounts are not more accurate than the slab journal");
+	result = VDO_ASSERT(!vdo_before_journal_point(&last_entry_applied,
+						      &ref_counts_point),
+			    "Refcounts are not more accurate than the slab journal");
 	if (result != VDO_SUCCESS) {
 		abort_scrubbing(scrubber, result);
 		return;
@@ -2993,8 +2993,8 @@ static void scrub_slabs(struct block_allocator *allocator, struct vdo_completion
 static inline void assert_on_allocator_thread(thread_id_t thread_id,
 					      const char *function_name)
 {
-	ASSERT_LOG_ONLY((vdo_get_callback_thread_id() == thread_id),
-			"%s called on correct thread", function_name);
+	VDO_ASSERT_LOG_ONLY((vdo_get_callback_thread_id() == thread_id),
+			    "%s called on correct thread", function_name);
 }
 
 static void register_slab_with_allocator(struct block_allocator *allocator,
@@ -3142,8 +3142,8 @@ static int __must_check allocate_slab_block(struct vdo_slab *slab,
 	if (!search_reference_blocks(slab, &free_index))
 		return VDO_NO_SPACE;
 
-	ASSERT_LOG_ONLY((slab->counters[free_index] == EMPTY_REFERENCE_COUNT),
-			"free block must have ref count of zero");
+	VDO_ASSERT_LOG_ONLY((slab->counters[free_index] == EMPTY_REFERENCE_COUNT),
+			    "free block must have ref count of zero");
 	make_provisional_reference(slab, free_index);
 	adjust_free_block_count(slab, false);
 
@@ -3850,8 +3850,8 @@ static bool __must_check release_recovery_journal_lock(struct slab_journal *jour
 						       sequence_number_t recovery_lock)
 {
 	if (recovery_lock > journal->recovery_lock) {
-		ASSERT_LOG_ONLY((recovery_lock < journal->recovery_lock),
-				"slab journal recovery lock is not older than the recovery journal head");
+		VDO_ASSERT_LOG_ONLY((recovery_lock < journal->recovery_lock),
+				    "slab journal recovery lock is not older than the recovery journal head");
 		return false;
 	}
 
@@ -4665,8 +4665,8 @@ int vdo_prepare_to_grow_slab_depot(struct slab_depot *depot,
 		return VDO_INCREMENT_TOO_SMALL;
 
 	/* Generate the depot configuration for the new block count. */
-	ASSERT_LOG_ONLY(depot->first_block == partition->offset,
-			"New slab depot partition doesn't change origin");
+	VDO_ASSERT_LOG_ONLY(depot->first_block == partition->offset,
+			    "New slab depot partition doesn't change origin");
 	result = vdo_configure_slab_depot(partition, depot->slab_config,
 					  depot->zone_count, &new_state);
 	if (result != VDO_SUCCESS)
@@ -4740,7 +4740,7 @@ static void register_new_slabs(void *context, zone_count_t zone_number,
  */
 void vdo_use_new_slabs(struct slab_depot *depot, struct vdo_completion *parent)
 {
-	ASSERT_LOG_ONLY(depot->new_slabs != NULL, "Must have new slabs to use");
+	VDO_ASSERT_LOG_ONLY(depot->new_slabs != NULL, "Must have new slabs to use");
 	vdo_schedule_operation(depot->action_manager,
 			       VDO_ADMIN_STATE_SUSPENDED_OPERATION,
 			       NULL, register_new_slabs,
@@ -4796,8 +4796,8 @@ static void do_drain_step(struct vdo_completion *completion)
 		return;
 
 	case VDO_DRAIN_ALLOCATOR_STEP_FINISHED:
-		ASSERT_LOG_ONLY(!is_vio_pool_busy(allocator->vio_pool),
-				"vio pool not busy");
+		VDO_ASSERT_LOG_ONLY(!is_vio_pool_busy(allocator->vio_pool),
+				    "vio pool not busy");
 		vdo_finish_draining_with_result(&allocator->state, completion->result);
 		return;
 
diff --git a/drivers/md/dm-vdo/thread-registry.c b/drivers/md/dm-vdo/thread-registry.c
index 03e2f45e8e78..d4a077d58c60 100644
--- a/drivers/md/dm-vdo/thread-registry.c
+++ b/drivers/md/dm-vdo/thread-registry.c
@@ -44,7 +44,7 @@ void vdo_register_thread(struct thread_registry *registry,
 	list_add_tail_rcu(&new_thread->links, &registry->links);
 	spin_unlock(&registry->lock);
 
-	ASSERT_LOG_ONLY(!found_it, "new thread not already in registry");
+	VDO_ASSERT_LOG_ONLY(!found_it, "new thread not already in registry");
 	if (found_it) {
 		/* Ensure no RCU iterators see it before re-initializing. */
 		synchronize_rcu();
@@ -67,7 +67,7 @@ void vdo_unregister_thread(struct thread_registry *registry)
 	}
 	spin_unlock(&registry->lock);
 
-	ASSERT_LOG_ONLY(found_it, "thread found in registry");
+	VDO_ASSERT_LOG_ONLY(found_it, "thread found in registry");
 	if (found_it) {
 		/* Ensure no RCU iterators see it before re-initializing. */
 		synchronize_rcu();
diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index b4dd0634a5cb..11be2ab17e29 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -425,9 +425,9 @@ int vdo_make_thread(struct vdo *vdo, thread_id_t thread_id,
 		type = &default_queue_type;
 
 	if (thread->queue != NULL) {
-		return ASSERT(vdo_work_queue_type_is(thread->queue, type),
-			      "already constructed vdo thread %u is of the correct type",
-			      thread_id);
+		return VDO_ASSERT(vdo_work_queue_type_is(thread->queue, type),
+				  "already constructed vdo thread %u is of the correct type",
+				  thread_id);
 	}
 
 	thread->vdo = vdo;
@@ -448,8 +448,8 @@ static int register_vdo(struct vdo *vdo)
 	int result;
 
 	write_lock(&registry.lock);
-	result = ASSERT(filter_vdos_locked(vdo_is_equal, vdo) == NULL,
-			"VDO not already registered");
+	result = VDO_ASSERT(filter_vdos_locked(vdo_is_equal, vdo) == NULL,
+			    "VDO not already registered");
 	if (result == VDO_SUCCESS) {
 		INIT_LIST_HEAD(&vdo->registration);
 		list_add_tail(&vdo->registration, &registry.links);
@@ -1050,8 +1050,8 @@ int vdo_register_read_only_listener(struct vdo *vdo, void *listener,
 	struct read_only_listener *read_only_listener;
 	int result;
 
-	result = ASSERT(thread_id != vdo->thread_config.dedupe_thread,
-			"read only listener not registered on dedupe thread");
+	result = VDO_ASSERT(thread_id != vdo->thread_config.dedupe_thread,
+			    "read only listener not registered on dedupe thread");
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -1704,8 +1704,8 @@ void vdo_dump_status(const struct vdo *vdo)
  */
 void vdo_assert_on_admin_thread(const struct vdo *vdo, const char *name)
 {
-	ASSERT_LOG_ONLY((vdo_get_callback_thread_id() == vdo->thread_config.admin_thread),
-			"%s called on admin thread", name);
+	VDO_ASSERT_LOG_ONLY((vdo_get_callback_thread_id() == vdo->thread_config.admin_thread),
+			    "%s called on admin thread", name);
 }
 
 /**
@@ -1718,9 +1718,9 @@ void vdo_assert_on_admin_thread(const struct vdo *vdo, const char *name)
 void vdo_assert_on_logical_zone_thread(const struct vdo *vdo, zone_count_t logical_zone,
 				       const char *name)
 {
-	ASSERT_LOG_ONLY((vdo_get_callback_thread_id() ==
-			 vdo->thread_config.logical_threads[logical_zone]),
-			"%s called on logical thread", name);
+	VDO_ASSERT_LOG_ONLY((vdo_get_callback_thread_id() ==
+			     vdo->thread_config.logical_threads[logical_zone]),
+			    "%s called on logical thread", name);
 }
 
 /**
@@ -1733,9 +1733,9 @@ void vdo_assert_on_logical_zone_thread(const struct vdo *vdo, zone_count_t logic
 void vdo_assert_on_physical_zone_thread(const struct vdo *vdo,
 					zone_count_t physical_zone, const char *name)
 {
-	ASSERT_LOG_ONLY((vdo_get_callback_thread_id() ==
-			 vdo->thread_config.physical_threads[physical_zone]),
-			"%s called on physical thread", name);
+	VDO_ASSERT_LOG_ONLY((vdo_get_callback_thread_id() ==
+			     vdo->thread_config.physical_threads[physical_zone]),
+			    "%s called on physical thread", name);
 }
 
 /**
@@ -1773,7 +1773,7 @@ int vdo_get_physical_zone(const struct vdo *vdo, physical_block_number_t pbn,
 
 	/* With the PBN already checked, we should always succeed in finding a slab. */
 	slab = vdo_get_slab(vdo->depot, pbn);
-	result = ASSERT(slab != NULL, "vdo_get_slab must succeed on all valid PBNs");
+	result = VDO_ASSERT(slab != NULL, "vdo_get_slab must succeed on all valid PBNs");
 	if (result != VDO_SUCCESS)
 		return result;
 
diff --git a/drivers/md/dm-vdo/vio.c b/drivers/md/dm-vdo/vio.c
index 83c36f7590de..b1e4e604c2c3 100644
--- a/drivers/md/dm-vdo/vio.c
+++ b/drivers/md/dm-vdo/vio.c
@@ -82,14 +82,14 @@ int allocate_vio_components(struct vdo *vdo, enum vio_type vio_type,
 	struct bio *bio;
 	int result;
 
-	result = ASSERT(block_count <= MAX_BLOCKS_PER_VIO,
-			"block count %u does not exceed maximum %u", block_count,
-			MAX_BLOCKS_PER_VIO);
+	result = VDO_ASSERT(block_count <= MAX_BLOCKS_PER_VIO,
+			    "block count %u does not exceed maximum %u", block_count,
+			    MAX_BLOCKS_PER_VIO);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	result = ASSERT(((vio_type != VIO_TYPE_UNINITIALIZED) && (vio_type != VIO_TYPE_DATA)),
-			"%d is a metadata type", vio_type);
+	result = VDO_ASSERT(((vio_type != VIO_TYPE_UNINITIALIZED) && (vio_type != VIO_TYPE_DATA)),
+			    "%d is a metadata type", vio_type);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -363,13 +363,13 @@ void free_vio_pool(struct vio_pool *pool)
 		return;
 
 	/* Remove all available vios from the object pool. */
-	ASSERT_LOG_ONLY(!vdo_waitq_has_waiters(&pool->waiting),
-			"VIO pool must not have any waiters when being freed");
-	ASSERT_LOG_ONLY((pool->busy_count == 0),
-			"VIO pool must not have %zu busy entries when being freed",
-			pool->busy_count);
-	ASSERT_LOG_ONLY(list_empty(&pool->busy),
-			"VIO pool must not have busy entries when being freed");
+	VDO_ASSERT_LOG_ONLY(!vdo_waitq_has_waiters(&pool->waiting),
+			    "VIO pool must not have any waiters when being freed");
+	VDO_ASSERT_LOG_ONLY((pool->busy_count == 0),
+			    "VIO pool must not have %zu busy entries when being freed",
+			    pool->busy_count);
+	VDO_ASSERT_LOG_ONLY(list_empty(&pool->busy),
+			    "VIO pool must not have busy entries when being freed");
 
 	list_for_each_entry_safe(pooled, tmp, &pool->available, pool_entry) {
 		list_del(&pooled->pool_entry);
@@ -377,8 +377,8 @@ void free_vio_pool(struct vio_pool *pool)
 		pool->size--;
 	}
 
-	ASSERT_LOG_ONLY(pool->size == 0,
-			"VIO pool must not have missing entries when being freed");
+	VDO_ASSERT_LOG_ONLY(pool->size == 0,
+			    "VIO pool must not have missing entries when being freed");
 
 	vdo_free(vdo_forget(pool->buffer));
 	vdo_free(pool);
@@ -403,8 +403,8 @@ void acquire_vio_from_pool(struct vio_pool *pool, struct vdo_waiter *waiter)
 {
 	struct pooled_vio *pooled;
 
-	ASSERT_LOG_ONLY((pool->thread_id == vdo_get_callback_thread_id()),
-			"acquire from active vio_pool called from correct thread");
+	VDO_ASSERT_LOG_ONLY((pool->thread_id == vdo_get_callback_thread_id()),
+			    "acquire from active vio_pool called from correct thread");
 
 	if (list_empty(&pool->available)) {
 		vdo_waitq_enqueue_waiter(&pool->waiting, waiter);
@@ -424,8 +424,8 @@ void acquire_vio_from_pool(struct vio_pool *pool, struct vdo_waiter *waiter)
  */
 void return_vio_to_pool(struct vio_pool *pool, struct pooled_vio *vio)
 {
-	ASSERT_LOG_ONLY((pool->thread_id == vdo_get_callback_thread_id()),
-			"vio pool entry returned on same thread as it was acquired");
+	VDO_ASSERT_LOG_ONLY((pool->thread_id == vdo_get_callback_thread_id()),
+			    "vio pool entry returned on same thread as it was acquired");
 
 	vio->vio.completion.error_handler = NULL;
 	vio->vio.completion.parent = NULL;
@@ -465,8 +465,8 @@ void vdo_count_bios(struct atomic_bio_stats *bio_stats, struct bio *bio)
 		 * shouldn't exist.
 		 */
 	default:
-		ASSERT_LOG_ONLY(0, "Bio operation %d not a write, read, discard, or empty flush",
-				bio_op(bio));
+		VDO_ASSERT_LOG_ONLY(0, "Bio operation %d not a write, read, discard, or empty flush",
+				    bio_op(bio));
 	}
 
 	if ((bio->bi_opf & REQ_PREFLUSH) != 0)
diff --git a/drivers/md/dm-vdo/vio.h b/drivers/md/dm-vdo/vio.h
index fbfee5e3415d..3490e9f59b04 100644
--- a/drivers/md/dm-vdo/vio.h
+++ b/drivers/md/dm-vdo/vio.h
@@ -67,10 +67,10 @@ static inline void assert_vio_in_bio_zone(struct vio *vio)
 	thread_id_t expected = get_vio_bio_zone_thread_id(vio);
 	thread_id_t thread_id = vdo_get_callback_thread_id();
 
-	ASSERT_LOG_ONLY((expected == thread_id),
-			"vio I/O for physical block %llu on thread %u, should be on bio zone thread %u",
-			(unsigned long long) pbn_from_vio_bio(vio->bio), thread_id,
-			expected);
+	VDO_ASSERT_LOG_ONLY((expected == thread_id),
+			    "vio I/O for physical block %llu on thread %u, should be on bio zone thread %u",
+			    (unsigned long long) pbn_from_vio_bio(vio->bio), thread_id,
+			    expected);
 }
 
 int vdo_create_bio(struct bio **bio_ptr);
-- 
2.42.0

