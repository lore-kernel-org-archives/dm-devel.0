Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDF23A269
	for <dm-devel@lists.linux.dev>; Mon, 20 Nov 2023 22:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="amw7wCy2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700519363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L7jNSyIFcAyCXFAbdelyjB9IwU8rm1PKQ6OMKcD5V54=;
	b=amw7wCy2bJaS6QmN+vq+0y249JYmZVKpaNOfmJkzeutsl/iG27L9YgUM93mqez/PeZeCyH
	LaGdUKCUQdKcenGkRYjwg51c8qARf41T2lPU9gENX6YaDmw4pdeMblnbLFtnpCkZdzSkDr
	PRiXtg0Z0YOGJofZlKcZWKxhq3sBoSg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-7EU2kzAANy-2fTN9two8ew-1; Mon, 20 Nov 2023 17:29:21 -0500
X-MC-Unique: 7EU2kzAANy-2fTN9two8ew-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19F28101A53B;
	Mon, 20 Nov 2023 22:29:21 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 135072166B26;
	Mon, 20 Nov 2023 22:29:21 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 0D6E751CCA; Mon, 20 Nov 2023 17:29:21 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 1/5] dm vdo wait-queue: add proper namespace to interface
Date: Mon, 20 Nov 2023 17:29:16 -0500
Message-ID: <b98d854c88588474a12540e2fcb12bf2a960b363.1700516271.git.msakai@redhat.com>
In-Reply-To: <cover.1700516271.git.msakai@redhat.com>
References: <cover.1700516271.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Rename various interfaces and structs associated with vdo's wait-queue,
e.g.: s/wait_queue/vdo_wait_queue/, s/waiter/vdo_waiter/, etc.

Now all function names start with "vdo_waitq_" or "vdo_waiter_".

Reviewed-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.c        | 134 ++++++++++---------
 drivers/md/dm-vdo/block-map.h        |  10 +-
 drivers/md/dm-vdo/data-vio.c         |  14 +-
 drivers/md/dm-vdo/data-vio.h         |  12 +-
 drivers/md/dm-vdo/dedupe.c           |  48 +++----
 drivers/md/dm-vdo/dump.c             |  12 +-
 drivers/md/dm-vdo/flush.c            |  32 ++---
 drivers/md/dm-vdo/flush.h            |   2 +-
 drivers/md/dm-vdo/physical-zone.c    |   4 +-
 drivers/md/dm-vdo/recovery-journal.c |  69 +++++-----
 drivers/md/dm-vdo/recovery-journal.h |  10 +-
 drivers/md/dm-vdo/slab-depot.c       |  99 +++++++-------
 drivers/md/dm-vdo/slab-depot.h       |  22 ++--
 drivers/md/dm-vdo/vio.c              |  12 +-
 drivers/md/dm-vdo/vio.h              |   2 +-
 drivers/md/dm-vdo/wait-queue.c       | 190 ++++++++++++++-------------
 drivers/md/dm-vdo/wait-queue.h       | 130 +++++++++---------
 17 files changed, 413 insertions(+), 389 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index 1edb3b2a80eb..a1f2c9d38192 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -85,7 +85,7 @@ struct cursor_level {
 struct cursors;
 
 struct cursor {
-	struct waiter waiter;
+	struct vdo_waiter waiter;
 	struct block_map_tree *tree;
 	height_t height;
 	struct cursors *parent;
@@ -162,7 +162,7 @@ static char *get_page_buffer(struct page_info *info)
 	return &cache->pages[(info - cache->infos) * VDO_BLOCK_SIZE];
 }
 
-static inline struct vdo_page_completion *page_completion_from_waiter(struct waiter *waiter)
+static inline struct vdo_page_completion *page_completion_from_waiter(struct vdo_waiter *waiter)
 {
 	struct vdo_page_completion *completion;
 
@@ -407,7 +407,7 @@ static int reset_page_info(struct page_info *info)
 	if (result != UDS_SUCCESS)
 		return result;
 
-	result = ASSERT(!vdo_has_waiters(&info->waiting),
+	result = ASSERT(!vdo_waitq_has_waiters(&info->waiting),
 			"VDO Page must not have waiters");
 	if (result != UDS_SUCCESS)
 		return result;
@@ -506,7 +506,7 @@ static void complete_with_page(struct page_info *info,
  *
  * Implements waiter_callback_fn.
  */
-static void complete_waiter_with_error(struct waiter *waiter, void *result_ptr)
+static void complete_waiter_with_error(struct vdo_waiter *waiter, void *result_ptr)
 {
 	int *result = result_ptr;
 
@@ -520,25 +520,25 @@ static void complete_waiter_with_error(struct waiter *waiter, void *result_ptr)
  *
  * Implements waiter_callback_fn.
  */
-static void complete_waiter_with_page(struct waiter *waiter, void *page_info)
+static void complete_waiter_with_page(struct vdo_waiter *waiter, void *page_info)
 {
 	complete_with_page(page_info, page_completion_from_waiter(waiter));
 }
 
 /**
- * distribute_page_over_queue() - Complete a queue of VDO page completions with a page result.
+ * distribute_page_over_waitq() - Complete a waitq of VDO page completions with a page result.
  *
- * Upon completion the queue will be empty.
+ * Upon completion the waitq will be empty.
  *
  * Return: The number of pages distributed.
  */
-static unsigned int distribute_page_over_queue(struct page_info *info,
-					       struct wait_queue *queue)
+static unsigned int distribute_page_over_waitq(struct page_info *info,
+					       struct vdo_wait_queue *waitq)
 {
 	size_t pages;
 
 	update_lru(info);
-	pages = vdo_count_waiters(queue);
+	pages = vdo_waitq_num_waiters(waitq);
 
 	/*
 	 * Increment the busy count once for each pending completion so that this page does not
@@ -546,7 +546,7 @@ static unsigned int distribute_page_over_queue(struct page_info *info,
 	 */
 	info->busy += pages;
 
-	vdo_notify_all_waiters(queue, complete_waiter_with_page, info);
+	vdo_waitq_notify_all_waiters(waitq, complete_waiter_with_page, info);
 	return pages;
 }
 
@@ -572,13 +572,14 @@ static void set_persistent_error(struct vdo_page_cache *cache, const char *conte
 
 	assert_on_cache_thread(cache, __func__);
 
-	vdo_notify_all_waiters(&cache->free_waiters, complete_waiter_with_error,
-			       &result);
+	vdo_waitq_notify_all_waiters(&cache->free_waiters,
+				     complete_waiter_with_error, &result);
 	cache->waiter_count = 0;
 
-	for (info = cache->infos; info < cache->infos + cache->page_count; info++)
-		vdo_notify_all_waiters(&info->waiting, complete_waiter_with_error,
-				       &result);
+	for (info = cache->infos; info < cache->infos + cache->page_count; info++) {
+		vdo_waitq_notify_all_waiters(&info->waiting,
+					     complete_waiter_with_error, &result);
+	}
 }
 
 /**
@@ -625,7 +626,7 @@ static void check_for_drain_complete(struct block_map_zone *zone)
 {
 	if (vdo_is_state_draining(&zone->state) &&
 	    (zone->active_lookups == 0) &&
-	    !vdo_has_waiters(&zone->flush_waiters) &&
+	    !vdo_waitq_has_waiters(&zone->flush_waiters) &&
 	    !is_vio_pool_busy(zone->vio_pool) &&
 	    (zone->page_cache.outstanding_reads == 0) &&
 	    (zone->page_cache.outstanding_writes == 0)) {
@@ -643,8 +644,8 @@ static void enter_zone_read_only_mode(struct block_map_zone *zone, int result)
 	 * We are in read-only mode, so we won't ever write any page out. Just take all waiters off
 	 * the queue so the zone can drain.
 	 */
-	while (vdo_has_waiters(&zone->flush_waiters))
-		vdo_dequeue_next_waiter(&zone->flush_waiters);
+	while (vdo_waitq_has_waiters(&zone->flush_waiters))
+		vdo_waitq_dequeue_next_waiter(&zone->flush_waiters);
 
 	check_for_drain_complete(zone);
 }
@@ -677,7 +678,7 @@ static void handle_load_error(struct vdo_completion *completion)
 	vdo_enter_read_only_mode(cache->zone->block_map->vdo, result);
 	ADD_ONCE(cache->stats.failed_reads, 1);
 	set_info_state(info, PS_FAILED);
-	vdo_notify_all_waiters(&info->waiting, complete_waiter_with_error, &result);
+	vdo_waitq_notify_all_waiters(&info->waiting, complete_waiter_with_error, &result);
 	reset_page_info(info);
 
 	/*
@@ -720,7 +721,7 @@ static void page_is_loaded(struct vdo_completion *completion)
 
 	info->recovery_lock = 0;
 	set_info_state(info, PS_RESIDENT);
-	distribute_page_over_queue(info, &info->waiting);
+	distribute_page_over_waitq(info, &info->waiting);
 
 	/*
 	 * Don't decrement until right before calling check_for_drain_complete() to
@@ -874,7 +875,7 @@ static void launch_page_save(struct page_info *info)
  *
  * Return: true if the page completion is for the desired page number.
  */
-static bool completion_needs_page(struct waiter *waiter, void *context)
+static bool completion_needs_page(struct vdo_waiter *waiter, void *context)
 {
 	physical_block_number_t *pbn = context;
 
@@ -888,13 +889,13 @@ static bool completion_needs_page(struct waiter *waiter, void *context)
 static void allocate_free_page(struct page_info *info)
 {
 	int result;
-	struct waiter *oldest_waiter;
+	struct vdo_waiter *oldest_waiter;
 	physical_block_number_t pbn;
 	struct vdo_page_cache *cache = info->cache;
 
 	assert_on_cache_thread(cache, __func__);
 
-	if (!vdo_has_waiters(&cache->free_waiters)) {
+	if (!vdo_waitq_has_waiters(&cache->free_waiters)) {
 		if (cache->stats.cache_pressure > 0) {
 			uds_log_info("page cache pressure relieved");
 			WRITE_ONCE(cache->stats.cache_pressure, 0);
@@ -909,20 +910,22 @@ static void allocate_free_page(struct page_info *info)
 		return;
 	}
 
-	oldest_waiter = vdo_get_first_waiter(&cache->free_waiters);
+	oldest_waiter = vdo_waitq_get_first_waiter(&cache->free_waiters);
 	pbn = page_completion_from_waiter(oldest_waiter)->pbn;
 
 	/*
 	 * Remove all entries which match the page number in question and push them onto the page
 	 * info's wait queue.
 	 */
-	vdo_dequeue_matching_waiters(&cache->free_waiters, completion_needs_page,
-				     &pbn, &info->waiting);
-	cache->waiter_count -= vdo_count_waiters(&info->waiting);
+	vdo_waitq_dequeue_matching_waiters(&cache->free_waiters, completion_needs_page,
+					   &pbn, &info->waiting);
+	cache->waiter_count -= vdo_waitq_num_waiters(&info->waiting);
 
 	result = launch_page_load(info, pbn);
-	if (result != VDO_SUCCESS)
-		vdo_notify_all_waiters(&info->waiting, complete_waiter_with_error, &result);
+	if (result != VDO_SUCCESS) {
+		vdo_waitq_notify_all_waiters(&info->waiting,
+					     complete_waiter_with_error, &result);
+	}
 }
 
 /**
@@ -966,7 +969,7 @@ static void discard_page_for_completion(struct vdo_page_completion *vdo_page_com
 	struct vdo_page_cache *cache = vdo_page_comp->cache;
 
 	cache->waiter_count++;
-	vdo_enqueue_waiter(&cache->free_waiters, &vdo_page_comp->waiter);
+	vdo_waitq_enqueue_waiter(&cache->free_waiters, &vdo_page_comp->waiter);
 	discard_a_page(cache);
 }
 
@@ -1069,11 +1072,11 @@ static void page_is_written_out(struct vdo_completion *completion)
 						     cache->zone->zone_number);
 	info->recovery_lock = 0;
 	was_discard = write_has_finished(info);
-	reclaimed = (!was_discard || (info->busy > 0) || vdo_has_waiters(&info->waiting));
+	reclaimed = (!was_discard || (info->busy > 0) || vdo_waitq_has_waiters(&info->waiting));
 
 	set_info_state(info, PS_RESIDENT);
 
-	reclamations = distribute_page_over_queue(info, &info->waiting);
+	reclamations = distribute_page_over_waitq(info, &info->waiting);
 	ADD_ONCE(cache->stats.reclaimed, reclamations);
 
 	if (was_discard)
@@ -1187,10 +1190,12 @@ static void load_page_for_completion(struct page_info *info,
 {
 	int result;
 
-	vdo_enqueue_waiter(&info->waiting, &vdo_page_comp->waiter);
+	vdo_waitq_enqueue_waiter(&info->waiting, &vdo_page_comp->waiter);
 	result = launch_page_load(info, vdo_page_comp->pbn);
-	if (result != VDO_SUCCESS)
-		vdo_notify_all_waiters(&info->waiting, complete_waiter_with_error, &result);
+	if (result != VDO_SUCCESS) {
+		vdo_waitq_notify_all_waiters(&info->waiting,
+					     complete_waiter_with_error, &result);
+	}
 }
 
 /**
@@ -1251,7 +1256,7 @@ void vdo_get_page(struct vdo_page_completion *page_completion,
 		    (is_outgoing(info) && page_completion->writable)) {
 			/* The page is unusable until it has finished I/O. */
 			ADD_ONCE(cache->stats.wait_for_page, 1);
-			vdo_enqueue_waiter(&info->waiting, &page_completion->waiter);
+			vdo_waitq_enqueue_waiter(&info->waiting, &page_completion->waiter);
 			return;
 		}
 
@@ -1476,7 +1481,7 @@ static void set_generation(struct block_map_zone *zone, struct tree_page *page,
 {
 	u32 new_count;
 	int result;
-	bool decrement_old = vdo_is_waiting(&page->waiter);
+	bool decrement_old = vdo_waiter_is_waiting(&page->waiter);
 	u8 old_generation = page->generation;
 
 	if (decrement_old && (old_generation == new_generation))
@@ -1498,12 +1503,12 @@ static void set_generation(struct block_map_zone *zone, struct tree_page *page,
 static void write_page(struct tree_page *tree_page, struct pooled_vio *vio);
 
 /* Implements waiter_callback_fn */
-static void write_page_callback(struct waiter *waiter, void *context)
+static void write_page_callback(struct vdo_waiter *waiter, void *context)
 {
 	write_page(container_of(waiter, struct tree_page, waiter), context);
 }
 
-static void acquire_vio(struct waiter *waiter, struct block_map_zone *zone)
+static void acquire_vio(struct vdo_waiter *waiter, struct block_map_zone *zone)
 {
 	waiter->callback = write_page_callback;
 	acquire_vio_from_pool(zone->vio_pool, waiter);
@@ -1530,10 +1535,10 @@ static void enqueue_page(struct tree_page *page, struct block_map_zone *zone)
 		return;
 	}
 
-	vdo_enqueue_waiter(&zone->flush_waiters, &page->waiter);
+	vdo_waitq_enqueue_waiter(&zone->flush_waiters, &page->waiter);
 }
 
-static void write_page_if_not_dirtied(struct waiter *waiter, void *context)
+static void write_page_if_not_dirtied(struct vdo_waiter *waiter, void *context)
 {
 	struct tree_page *page = container_of(waiter, struct tree_page, waiter);
 	struct write_if_not_dirtied_context *write_context = context;
@@ -1576,8 +1581,8 @@ static void finish_page_write(struct vdo_completion *completion)
 			.generation = page->writing_generation,
 		};
 
-		vdo_notify_all_waiters(&zone->flush_waiters,
-				       write_page_if_not_dirtied, &context);
+		vdo_waitq_notify_all_waiters(&zone->flush_waiters,
+					     write_page_if_not_dirtied, &context);
 		if (dirty && attempt_increment(zone)) {
 			write_page(page, pooled);
 			return;
@@ -1588,10 +1593,10 @@ static void finish_page_write(struct vdo_completion *completion)
 
 	if (dirty) {
 		enqueue_page(page, zone);
-	} else if ((zone->flusher == NULL) && vdo_has_waiters(&zone->flush_waiters) &&
+	} else if ((zone->flusher == NULL) && vdo_waitq_has_waiters(&zone->flush_waiters) &&
 		   attempt_increment(zone)) {
 		zone->flusher =
-			container_of(vdo_dequeue_next_waiter(&zone->flush_waiters),
+			container_of(vdo_waitq_dequeue_next_waiter(&zone->flush_waiters),
 				     struct tree_page, waiter);
 		write_page(zone->flusher, pooled);
 		return;
@@ -1724,9 +1729,9 @@ static void finish_lookup(struct data_vio *data_vio, int result)
 	continue_data_vio_with_error(data_vio, result);
 }
 
-static void abort_lookup_for_waiter(struct waiter *waiter, void *context)
+static void abort_lookup_for_waiter(struct vdo_waiter *waiter, void *context)
 {
-	struct data_vio *data_vio = waiter_as_data_vio(waiter);
+	struct data_vio *data_vio = vdo_waiter_as_data_vio(waiter);
 	int result = *((int *) context);
 
 	if (!data_vio->write) {
@@ -1746,8 +1751,9 @@ static void abort_lookup(struct data_vio *data_vio, int result, char *what)
 
 	if (data_vio->tree_lock.locked) {
 		release_page_lock(data_vio, what);
-		vdo_notify_all_waiters(&data_vio->tree_lock.waiters,
-				       abort_lookup_for_waiter, &result);
+		vdo_waitq_notify_all_waiters(&data_vio->tree_lock.waiters,
+					     abort_lookup_for_waiter,
+					     &result);
 	}
 
 	finish_lookup(data_vio, result);
@@ -1813,9 +1819,9 @@ static void continue_with_loaded_page(struct data_vio *data_vio,
 	load_block_map_page(data_vio->logical.zone->block_map_zone, data_vio);
 }
 
-static void continue_load_for_waiter(struct waiter *waiter, void *context)
+static void continue_load_for_waiter(struct vdo_waiter *waiter, void *context)
 {
-	struct data_vio *data_vio = waiter_as_data_vio(waiter);
+	struct data_vio *data_vio = vdo_waiter_as_data_vio(waiter);
 
 	data_vio->tree_lock.height--;
 	continue_with_loaded_page(data_vio, context);
@@ -1845,7 +1851,7 @@ static void finish_block_map_page_load(struct vdo_completion *completion)
 
 	/* Release our claim to the load and wake any waiters */
 	release_page_lock(data_vio, "load");
-	vdo_notify_all_waiters(&tree_lock->waiters, continue_load_for_waiter, page);
+	vdo_waitq_notify_all_waiters(&tree_lock->waiters, continue_load_for_waiter, page);
 	continue_with_loaded_page(data_vio, page);
 }
 
@@ -1871,10 +1877,10 @@ static void load_page_endio(struct bio *bio)
 			      data_vio->logical.zone->thread_id);
 }
 
-static void load_page(struct waiter *waiter, void *context)
+static void load_page(struct vdo_waiter *waiter, void *context)
 {
 	struct pooled_vio *pooled = context;
-	struct data_vio *data_vio = waiter_as_data_vio(waiter);
+	struct data_vio *data_vio = vdo_waiter_as_data_vio(waiter);
 	struct tree_lock *lock = &data_vio->tree_lock;
 	physical_block_number_t pbn = lock->tree_slots[lock->height - 1].block_map_slot.pbn;
 
@@ -1916,7 +1922,7 @@ static int attempt_page_lock(struct block_map_zone *zone, struct data_vio *data_
 	}
 
 	/* Someone else is loading or allocating the page we need */
-	vdo_enqueue_waiter(&lock_holder->waiters, &data_vio->waiter);
+	vdo_waitq_enqueue_waiter(&lock_holder->waiters, &data_vio->waiter);
 	return VDO_SUCCESS;
 }
 
@@ -1948,9 +1954,9 @@ static void allocation_failure(struct vdo_completion *completion)
 	abort_lookup(data_vio, completion->result, "allocation");
 }
 
-static void continue_allocation_for_waiter(struct waiter *waiter, void *context)
+static void continue_allocation_for_waiter(struct vdo_waiter *waiter, void *context)
 {
-	struct data_vio *data_vio = waiter_as_data_vio(waiter);
+	struct data_vio *data_vio = vdo_waiter_as_data_vio(waiter);
 	struct tree_lock *tree_lock = &data_vio->tree_lock;
 	physical_block_number_t pbn = *((physical_block_number_t *) context);
 
@@ -2010,7 +2016,7 @@ static void write_expired_elements(struct block_map_zone *zone)
 
 		list_del_init(&page->entry);
 
-		result = ASSERT(!vdo_is_waiting(&page->waiter),
+		result = ASSERT(!vdo_waiter_is_waiting(&page->waiter),
 				"Newly expired page not already waiting to write");
 		if (result != VDO_SUCCESS) {
 			enter_zone_read_only_mode(zone, result);
@@ -2089,7 +2095,7 @@ static void finish_block_map_allocation(struct vdo_completion *completion)
 				  VDO_MAPPING_STATE_UNCOMPRESSED,
 				  &tree_page->recovery_lock);
 
-	if (vdo_is_waiting(&tree_page->waiter)) {
+	if (vdo_waiter_is_waiting(&tree_page->waiter)) {
 		/* This page is waiting to be written out. */
 		if (zone->flusher != tree_page) {
 			/*
@@ -2117,8 +2123,8 @@ static void finish_block_map_allocation(struct vdo_completion *completion)
 
 	/* Release our claim to the allocation and wake any waiters */
 	release_page_lock(data_vio, "allocation");
-	vdo_notify_all_waiters(&tree_lock->waiters, continue_allocation_for_waiter,
-			       &pbn);
+	vdo_waitq_notify_all_waiters(&tree_lock->waiters,
+				     continue_allocation_for_waiter, &pbn);
 	if (tree_lock->height == 0) {
 		finish_lookup(data_vio, VDO_SUCCESS);
 		return;
@@ -2324,7 +2330,7 @@ physical_block_number_t vdo_find_block_map_page_pbn(struct block_map *map,
  */
 void vdo_write_tree_page(struct tree_page *page, struct block_map_zone *zone)
 {
-	bool waiting = vdo_is_waiting(&page->waiter);
+	bool waiting = vdo_waiter_is_waiting(&page->waiter);
 
 	if (waiting && (zone->flusher == page))
 		return;
@@ -2630,7 +2636,7 @@ static void traverse(struct cursor *cursor)
  *
  * Implements waiter_callback_fn.
  */
-static void launch_cursor(struct waiter *waiter, void *context)
+static void launch_cursor(struct vdo_waiter *waiter, void *context)
 {
 	struct cursor *cursor = container_of(waiter, struct cursor, waiter);
 	struct pooled_vio *pooled = context;
diff --git a/drivers/md/dm-vdo/block-map.h b/drivers/md/dm-vdo/block-map.h
index dc807111b0e6..cc98d19309ce 100644
--- a/drivers/md/dm-vdo/block-map.h
+++ b/drivers/md/dm-vdo/block-map.h
@@ -68,7 +68,7 @@ struct vdo_page_cache {
 	/* how many VPCs waiting for free page */
 	unsigned int waiter_count;
 	/* queue of waiters who want a free page */
-	struct wait_queue free_waiters;
+	struct vdo_wait_queue free_waiters;
 	/*
 	 * Statistics are only updated on the logical zone thread, but are accessed from other
 	 * threads.
@@ -129,7 +129,7 @@ struct page_info {
 	/* page state */
 	enum vdo_page_buffer_state state;
 	/* queue of completions awaiting this item */
-	struct wait_queue waiting;
+	struct vdo_wait_queue waiting;
 	/* state linked list entry */
 	struct list_head state_entry;
 	/* LRU entry */
@@ -153,7 +153,7 @@ struct vdo_page_completion {
 	/* The cache involved */
 	struct vdo_page_cache *cache;
 	/* The waiter for the pending list */
-	struct waiter waiter;
+	struct vdo_waiter waiter;
 	/* The absolute physical block number of the page on disk */
 	physical_block_number_t pbn;
 	/* Whether the page may be modified */
@@ -167,7 +167,7 @@ struct vdo_page_completion {
 struct forest;
 
 struct tree_page {
-	struct waiter waiter;
+	struct vdo_waiter waiter;
 
 	/* Dirty list entry */
 	struct list_head entry;
@@ -228,7 +228,7 @@ struct block_map_zone {
 	struct vio_pool *vio_pool;
 	/* The tree page which has issued or will be issuing a flush */
 	struct tree_page *flusher;
-	struct wait_queue flush_waiters;
+	struct vdo_wait_queue flush_waiters;
 	/* The generation after the most recent flush */
 	u8 generation;
 	u8 oldest_generation;
diff --git a/drivers/md/dm-vdo/data-vio.c b/drivers/md/dm-vdo/data-vio.c
index 54c06e86d321..821155ca3761 100644
--- a/drivers/md/dm-vdo/data-vio.c
+++ b/drivers/md/dm-vdo/data-vio.c
@@ -249,7 +249,7 @@ static void initialize_lbn_lock(struct data_vio *data_vio, logical_block_number_
 
 	lock->lbn = lbn;
 	lock->locked = false;
-	vdo_initialize_wait_queue(&lock->waiters);
+	vdo_waitq_init(&lock->waiters);
 	zone_number = vdo_compute_logical_zone(data_vio);
 	lock->zone = &vdo->logical_zones->zones[zone_number];
 }
@@ -466,7 +466,7 @@ static void attempt_logical_block_lock(struct vdo_completion *completion)
 	}
 
 	data_vio->last_async_operation = VIO_ASYNC_OP_ATTEMPT_LOGICAL_BLOCK_LOCK;
-	vdo_enqueue_waiter(&lock_holder->logical.waiters, &data_vio->waiter);
+	vdo_waitq_enqueue_waiter(&lock_holder->logical.waiters, &data_vio->waiter);
 
 	/*
 	 * Prevent writes and read-modify-writes from blocking indefinitely on lock holders in the
@@ -1191,11 +1191,11 @@ static void transfer_lock(struct data_vio *data_vio, struct lbn_lock *lock)
 
 	/* Another data_vio is waiting for the lock, transfer it in a single lock map operation. */
 	next_lock_holder =
-		waiter_as_data_vio(vdo_dequeue_next_waiter(&lock->waiters));
+		vdo_waiter_as_data_vio(vdo_waitq_dequeue_next_waiter(&lock->waiters));
 
 	/* Transfer the remaining lock waiters to the next lock holder. */
-	vdo_transfer_all_waiters(&lock->waiters,
-				 &next_lock_holder->logical.waiters);
+	vdo_waitq_transfer_all_waiters(&lock->waiters,
+				       &next_lock_holder->logical.waiters);
 
 	result = vdo_int_map_put(lock->zone->lbn_operations, lock->lbn,
 				 next_lock_holder, true, (void **) &lock_holder);
@@ -1213,7 +1213,7 @@ static void transfer_lock(struct data_vio *data_vio, struct lbn_lock *lock)
 	 * If there are still waiters, other data_vios must be trying to get the lock we just
 	 * transferred. We must ensure that the new lock holder doesn't block in the packer.
 	 */
-	if (vdo_has_waiters(&next_lock_holder->logical.waiters))
+	if (vdo_waitq_has_waiters(&next_lock_holder->logical.waiters))
 		cancel_data_vio_compression(next_lock_holder);
 
 	/*
@@ -1235,7 +1235,7 @@ static void release_logical_lock(struct vdo_completion *completion)
 
 	assert_data_vio_in_logical_zone(data_vio);
 
-	if (vdo_has_waiters(&lock->waiters))
+	if (vdo_waitq_has_waiters(&lock->waiters))
 		transfer_lock(data_vio, lock);
 	else
 		release_lock(data_vio, lock);
diff --git a/drivers/md/dm-vdo/data-vio.h b/drivers/md/dm-vdo/data-vio.h
index aa415b8c7d91..f5a683968d1c 100644
--- a/drivers/md/dm-vdo/data-vio.h
+++ b/drivers/md/dm-vdo/data-vio.h
@@ -54,7 +54,7 @@ enum async_operation_number {
 struct lbn_lock {
 	logical_block_number_t lbn;
 	bool locked;
-	struct wait_queue waiters;
+	struct vdo_wait_queue waiters;
 	struct logical_zone *zone;
 };
 
@@ -75,7 +75,7 @@ struct tree_lock {
 	/* The key for the lock map */
 	u64 key;
 	/* The queue of waiters for the page this vio is allocating or loading */
-	struct wait_queue waiters;
+	struct vdo_wait_queue waiters;
 	/* The block map tree slots for this LBN */
 	struct block_map_tree_slot tree_slots[VDO_BLOCK_MAP_TREE_HEIGHT + 1];
 };
@@ -168,13 +168,13 @@ struct reference_updater {
 	bool increment;
 	struct zoned_pbn zpbn;
 	struct pbn_lock *lock;
-	struct waiter waiter;
+	struct vdo_waiter waiter;
 };
 
 /* A vio for processing user data requests. */
 struct data_vio {
-	/* The wait_queue entry structure */
-	struct waiter waiter;
+	/* The vdo_wait_queue entry structure */
+	struct vdo_waiter waiter;
 
 	/* The logical block of this request */
 	struct lbn_lock logical;
@@ -288,7 +288,7 @@ static inline struct data_vio *as_data_vio(struct vdo_completion *completion)
 	return vio_as_data_vio(as_vio(completion));
 }
 
-static inline struct data_vio *waiter_as_data_vio(struct waiter *waiter)
+static inline struct data_vio *vdo_waiter_as_data_vio(struct vdo_waiter *waiter)
 {
 	if (waiter == NULL)
 		return NULL;
diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index 8cc31110f5a8..02e36896ca3c 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -270,7 +270,7 @@ struct hash_lock {
 	 * to get the information they all need to deduplicate--either against each other, or
 	 * against an existing duplicate on disk.
 	 */
-	struct wait_queue waiters;
+	struct vdo_wait_queue waiters;
 };
 
 enum {
@@ -351,7 +351,7 @@ static void return_hash_lock_to_pool(struct hash_zone *zone, struct hash_lock *l
 	memset(lock, 0, sizeof(*lock));
 	INIT_LIST_HEAD(&lock->pool_node);
 	INIT_LIST_HEAD(&lock->duplicate_ring);
-	vdo_initialize_wait_queue(&lock->waiters);
+	vdo_waitq_init(&lock->waiters);
 	list_add_tail(&lock->pool_node, &zone->lock_pool);
 }
 
@@ -420,7 +420,7 @@ static void set_duplicate_lock(struct hash_lock *hash_lock, struct pbn_lock *pbn
  */
 static inline struct data_vio *dequeue_lock_waiter(struct hash_lock *lock)
 {
-	return waiter_as_data_vio(vdo_dequeue_next_waiter(&lock->waiters));
+	return vdo_waiter_as_data_vio(vdo_waitq_dequeue_next_waiter(&lock->waiters));
 }
 
 /**
@@ -536,7 +536,7 @@ static struct data_vio *retire_lock_agent(struct hash_lock *lock)
  */
 static void wait_on_hash_lock(struct hash_lock *lock, struct data_vio *data_vio)
 {
-	vdo_enqueue_waiter(&lock->waiters, &data_vio->waiter);
+	vdo_waitq_enqueue_waiter(&lock->waiters, &data_vio->waiter);
 
 	/*
 	 * Make sure the agent doesn't block indefinitely in the packer since it now has at least
@@ -562,9 +562,9 @@ static void wait_on_hash_lock(struct hash_lock *lock, struct data_vio *data_vio)
  * @waiter: The data_vio's waiter link.
  * @context: Not used.
  */
-static void abort_waiter(struct waiter *waiter, void *context __always_unused)
+static void abort_waiter(struct vdo_waiter *waiter, void *context __always_unused)
 {
-	write_data_vio(waiter_as_data_vio(waiter));
+	write_data_vio(vdo_waiter_as_data_vio(waiter));
 }
 
 /**
@@ -602,7 +602,7 @@ void vdo_clean_failed_hash_lock(struct data_vio *data_vio)
 	/* Ensure we don't attempt to update advice when cleaning up. */
 	lock->update_advice = false;
 
-	vdo_notify_all_waiters(&lock->waiters, abort_waiter, NULL);
+	vdo_waitq_notify_all_waiters(&lock->waiters, abort_waiter, NULL);
 
 	if (lock->duplicate_lock != NULL) {
 		/* The agent must reference the duplicate zone to launch it. */
@@ -650,7 +650,7 @@ static void finish_unlocking(struct vdo_completion *completion)
 	 */
 	lock->verified = false;
 
-	if (vdo_has_waiters(&lock->waiters)) {
+	if (vdo_waitq_has_waiters(&lock->waiters)) {
 		/*
 		 * UNLOCKING -> LOCKING transition: A new data_vio entered the hash lock while the
 		 * agent was releasing the PBN lock. The current agent exits and the waiter has to
@@ -750,7 +750,7 @@ static void finish_updating(struct vdo_completion *completion)
 	 */
 	lock->update_advice = false;
 
-	if (vdo_has_waiters(&lock->waiters)) {
+	if (vdo_waitq_has_waiters(&lock->waiters)) {
 		/*
 		 * UPDATING -> DEDUPING transition: A new data_vio arrived during the UDS update.
 		 * Send it on the verified dedupe path. The agent is done with the lock, but the
@@ -812,7 +812,7 @@ static void finish_deduping(struct hash_lock *lock, struct data_vio *data_vio)
 	struct data_vio *agent = data_vio;
 
 	ASSERT_LOG_ONLY(lock->agent == NULL, "shouldn't have an agent in DEDUPING");
-	ASSERT_LOG_ONLY(!vdo_has_waiters(&lock->waiters),
+	ASSERT_LOG_ONLY(!vdo_waitq_has_waiters(&lock->waiters),
 			"shouldn't have any lock waiters in DEDUPING");
 
 	/* Just release the lock reference if other data_vios are still deduping. */
@@ -917,9 +917,9 @@ static int __must_check acquire_lock(struct hash_zone *zone,
  * Implements waiter_callback_fn. Binds the data_vio that was waiting to a new hash lock and waits
  * on that lock.
  */
-static void enter_forked_lock(struct waiter *waiter, void *context)
+static void enter_forked_lock(struct vdo_waiter *waiter, void *context)
 {
-	struct data_vio *data_vio = waiter_as_data_vio(waiter);
+	struct data_vio *data_vio = vdo_waiter_as_data_vio(waiter);
 	struct hash_lock *new_lock = context;
 
 	set_hash_lock(data_vio, new_lock);
@@ -956,7 +956,7 @@ static void fork_hash_lock(struct hash_lock *old_lock, struct data_vio *new_agen
 	set_hash_lock(new_agent, new_lock);
 	new_lock->agent = new_agent;
 
-	vdo_notify_all_waiters(&old_lock->waiters, enter_forked_lock, new_lock);
+	vdo_waitq_notify_all_waiters(&old_lock->waiters, enter_forked_lock, new_lock);
 
 	new_agent->is_duplicate = false;
 	start_writing(new_lock, new_agent);
@@ -1033,7 +1033,7 @@ static void start_deduping(struct hash_lock *lock, struct data_vio *agent,
 		launch_dedupe(lock, agent, true);
 		agent = NULL;
 	}
-	while (vdo_has_waiters(&lock->waiters))
+	while (vdo_waitq_has_waiters(&lock->waiters))
 		launch_dedupe(lock, dequeue_lock_waiter(lock), false);
 
 	if (agent_is_done) {
@@ -1454,7 +1454,7 @@ static void finish_writing(struct hash_lock *lock, struct data_vio *agent)
 		lock->update_advice = true;
 
 	/* If there are any waiters, we need to start deduping them. */
-	if (vdo_has_waiters(&lock->waiters)) {
+	if (vdo_waitq_has_waiters(&lock->waiters)) {
 		/*
 		 * WRITING -> DEDUPING transition: an asynchronously-written block failed to
 		 * compress, so the PBN lock on the written copy was already transferred. The agent
@@ -1502,10 +1502,10 @@ static void finish_writing(struct hash_lock *lock, struct data_vio *agent)
  */
 static struct data_vio *select_writing_agent(struct hash_lock *lock)
 {
-	struct wait_queue temp_queue;
+	struct vdo_wait_queue temp_queue;
 	struct data_vio *data_vio;
 
-	vdo_initialize_wait_queue(&temp_queue);
+	vdo_waitq_init(&temp_queue);
 
 	/*
 	 * Move waiters to the temp queue one-by-one until we find an allocation. Not ideal to
@@ -1514,7 +1514,7 @@ static struct data_vio *select_writing_agent(struct hash_lock *lock)
 	while (((data_vio = dequeue_lock_waiter(lock)) != NULL) &&
 	       !data_vio_has_allocation(data_vio)) {
 		/* Use the lower-level enqueue since we're just moving waiters around. */
-		vdo_enqueue_waiter(&temp_queue, &data_vio->waiter);
+		vdo_waitq_enqueue_waiter(&temp_queue, &data_vio->waiter);
 	}
 
 	if (data_vio != NULL) {
@@ -1522,13 +1522,13 @@ static struct data_vio *select_writing_agent(struct hash_lock *lock)
 		 * Move the rest of the waiters over to the temp queue, preserving the order they
 		 * arrived at the lock.
 		 */
-		vdo_transfer_all_waiters(&lock->waiters, &temp_queue);
+		vdo_waitq_transfer_all_waiters(&lock->waiters, &temp_queue);
 
 		/*
 		 * The current agent is being replaced and will have to wait to dedupe; make it the
 		 * first waiter since it was the first to reach the lock.
 		 */
-		vdo_enqueue_waiter(&lock->waiters, &lock->agent->waiter);
+		vdo_waitq_enqueue_waiter(&lock->waiters, &lock->agent->waiter);
 		lock->agent = data_vio;
 	} else {
 		/* No one has an allocation, so keep the current agent. */
@@ -1536,7 +1536,7 @@ static struct data_vio *select_writing_agent(struct hash_lock *lock)
 	}
 
 	/* Swap all the waiters back onto the lock's queue. */
-	vdo_transfer_all_waiters(&temp_queue, &lock->waiters);
+	vdo_waitq_transfer_all_waiters(&temp_queue, &lock->waiters);
 	return data_vio;
 }
 
@@ -1577,7 +1577,7 @@ static void start_writing(struct hash_lock *lock, struct data_vio *agent)
 	 * If the agent compresses, it might wait indefinitely in the packer, which would be bad if
 	 * there are any other data_vios waiting.
 	 */
-	if (vdo_has_waiters(&lock->waiters))
+	if (vdo_waitq_has_waiters(&lock->waiters))
 		cancel_data_vio_compression(agent);
 
 	/*
@@ -1928,7 +1928,7 @@ void vdo_release_hash_lock(struct data_vio *data_vio)
 				"unregistered hash lock must not be in the lock map");
 	}
 
-	ASSERT_LOG_ONLY(!vdo_has_waiters(&lock->waiters),
+	ASSERT_LOG_ONLY(!vdo_waitq_has_waiters(&lock->waiters),
 			"hash lock returned to zone must have no waiters");
 	ASSERT_LOG_ONLY((lock->duplicate_lock == NULL),
 			"hash lock returned to zone must not reference a PBN lock");
@@ -2812,7 +2812,7 @@ static void dump_hash_lock(const struct hash_lock *lock)
 		     lock, state, (lock->registered ? 'D' : 'U'),
 		     (unsigned long long) lock->duplicate.pbn,
 		     lock->duplicate.state, lock->reference_count,
-		     vdo_count_waiters(&lock->waiters), lock->agent);
+		     vdo_waitq_num_waiters(&lock->waiters), lock->agent);
 }
 
 static const char *index_state_to_string(struct hash_zones *zones,
diff --git a/drivers/md/dm-vdo/dump.c b/drivers/md/dm-vdo/dump.c
index 99266a946ed7..91bc8ed36aa7 100644
--- a/drivers/md/dm-vdo/dump.c
+++ b/drivers/md/dm-vdo/dump.c
@@ -146,25 +146,25 @@ void vdo_dump_all(struct vdo *vdo, const char *why)
 }
 
 /*
- * Dump out the data_vio waiters on a wait queue.
+ * Dump out the data_vio waiters on a waitq.
  * wait_on should be the label to print for queue (e.g. logical or physical)
  */
-static void dump_vio_waiters(struct wait_queue *queue, char *wait_on)
+static void dump_vio_waiters(struct vdo_wait_queue *waitq, char *wait_on)
 {
-	struct waiter *waiter, *first = vdo_get_first_waiter(queue);
+	struct vdo_waiter *waiter, *first = vdo_waitq_get_first_waiter(waitq);
 	struct data_vio *data_vio;
 
 	if (first == NULL)
 		return;
 
-	data_vio = waiter_as_data_vio(first);
+	data_vio = vdo_waiter_as_data_vio(first);
 
 	uds_log_info("      %s is locked. Waited on by: vio %px pbn %llu lbn %llu d-pbn %llu lastOp %s",
 		     wait_on, data_vio, data_vio->allocation.pbn, data_vio->logical.lbn,
 		     data_vio->duplicate.pbn, get_data_vio_operation_name(data_vio));
 
 	for (waiter = first->next_waiter; waiter != first; waiter = waiter->next_waiter) {
-		data_vio = waiter_as_data_vio(waiter);
+		data_vio = vdo_waiter_as_data_vio(waiter);
 		uds_log_info("     ... and : vio %px pbn %llu lbn %llu d-pbn %llu lastOp %s",
 			     data_vio, data_vio->allocation.pbn, data_vio->logical.lbn,
 			     data_vio->duplicate.pbn,
@@ -177,7 +177,7 @@ static void dump_vio_waiters(struct wait_queue *queue, char *wait_on)
  * logging brevity:
  *
  * R => vio completion result not VDO_SUCCESS
- * W => vio is on a wait queue
+ * W => vio is on a waitq
  * D => vio is a duplicate
  * p => vio is a partial block operation
  * z => vio is a zero block
diff --git a/drivers/md/dm-vdo/flush.c b/drivers/md/dm-vdo/flush.c
index a99607e23fb0..e7195c677773 100644
--- a/drivers/md/dm-vdo/flush.c
+++ b/drivers/md/dm-vdo/flush.c
@@ -31,9 +31,9 @@ struct flusher {
 	/** The first unacknowledged flush generation */
 	sequence_number_t first_unacknowledged_generation;
 	/** The queue of flush requests waiting to notify other threads */
-	struct wait_queue notifiers;
+	struct vdo_wait_queue notifiers;
 	/** The queue of flush requests waiting for VIOs to complete */
-	struct wait_queue pending_flushes;
+	struct vdo_wait_queue pending_flushes;
 	/** The flush generation for which notifications are being sent */
 	sequence_number_t notify_generation;
 	/** The logical zone to notify next */
@@ -93,7 +93,7 @@ static inline struct vdo_flush *completion_as_vdo_flush(struct vdo_completion *c
  *
  * Return: The wait queue entry as a vdo_flush.
  */
-static struct vdo_flush *waiter_as_flush(struct waiter *waiter)
+static struct vdo_flush *vdo_waiter_as_flush(struct vdo_waiter *waiter)
 {
 	return container_of(waiter, struct vdo_flush, waiter);
 }
@@ -195,10 +195,10 @@ static void finish_notification(struct vdo_completion *completion)
 
 	assert_on_flusher_thread(flusher, __func__);
 
-	vdo_enqueue_waiter(&flusher->pending_flushes,
-			   vdo_dequeue_next_waiter(&flusher->notifiers));
+	vdo_waitq_enqueue_waiter(&flusher->pending_flushes,
+				 vdo_waitq_dequeue_next_waiter(&flusher->notifiers));
 	vdo_complete_flushes(flusher);
-	if (vdo_has_waiters(&flusher->notifiers))
+	if (vdo_waitq_has_waiters(&flusher->notifiers))
 		notify_flush(flusher);
 }
 
@@ -248,7 +248,8 @@ static void increment_generation(struct vdo_completion *completion)
  */
 static void notify_flush(struct flusher *flusher)
 {
-	struct vdo_flush *flush = waiter_as_flush(vdo_get_first_waiter(&flusher->notifiers));
+	struct vdo_flush *flush =
+		vdo_waiter_as_flush(vdo_waitq_get_first_waiter(&flusher->notifiers));
 
 	flusher->notify_generation = flush->flush_generation;
 	flusher->logical_zone_to_notify = &flusher->vdo->logical_zones->zones[0];
@@ -280,8 +281,8 @@ static void flush_vdo(struct vdo_completion *completion)
 	}
 
 	flush->flush_generation = flusher->flush_generation++;
-	may_notify = !vdo_has_waiters(&flusher->notifiers);
-	vdo_enqueue_waiter(&flusher->notifiers, &flush->waiter);
+	may_notify = !vdo_waitq_has_waiters(&flusher->notifiers);
+	vdo_waitq_enqueue_waiter(&flusher->notifiers, &flush->waiter);
 	if (may_notify)
 		notify_flush(flusher);
 }
@@ -294,7 +295,8 @@ static void check_for_drain_complete(struct flusher *flusher)
 {
 	bool drained;
 
-	if (!vdo_is_state_draining(&flusher->state) || vdo_has_waiters(&flusher->pending_flushes))
+	if (!vdo_is_state_draining(&flusher->state) ||
+	    vdo_waitq_has_waiters(&flusher->pending_flushes))
 		return;
 
 	spin_lock(&flusher->lock);
@@ -321,9 +323,9 @@ void vdo_complete_flushes(struct flusher *flusher)
 			min(oldest_active_generation,
 			    READ_ONCE(zone->oldest_active_generation));
 
-	while (vdo_has_waiters(&flusher->pending_flushes)) {
+	while (vdo_waitq_has_waiters(&flusher->pending_flushes)) {
 		struct vdo_flush *flush =
-			waiter_as_flush(vdo_get_first_waiter(&flusher->pending_flushes));
+			vdo_waiter_as_flush(vdo_waitq_get_first_waiter(&flusher->pending_flushes));
 
 		if (flush->flush_generation >= oldest_active_generation)
 			return;
@@ -333,7 +335,7 @@ void vdo_complete_flushes(struct flusher *flusher)
 				"acknowledged next expected flush, %llu, was: %llu",
 				(unsigned long long) flusher->first_unacknowledged_generation,
 				(unsigned long long) flush->flush_generation);
-		vdo_dequeue_next_waiter(&flusher->pending_flushes);
+		vdo_waitq_dequeue_next_waiter(&flusher->pending_flushes);
 		vdo_complete_flush(flush);
 		flusher->first_unacknowledged_generation++;
 	}
@@ -352,8 +354,8 @@ void vdo_dump_flusher(const struct flusher *flusher)
 		     (unsigned long long) flusher->flush_generation,
 		     (unsigned long long) flusher->first_unacknowledged_generation);
 	uds_log_info("  notifiers queue is %s; pending_flushes queue is %s",
-		     (vdo_has_waiters(&flusher->notifiers) ? "not empty" : "empty"),
-		     (vdo_has_waiters(&flusher->pending_flushes) ? "not empty" : "empty"));
+		     (vdo_waitq_has_waiters(&flusher->notifiers) ? "not empty" : "empty"),
+		     (vdo_waitq_has_waiters(&flusher->pending_flushes) ? "not empty" : "empty"));
 }
 
 /**
diff --git a/drivers/md/dm-vdo/flush.h b/drivers/md/dm-vdo/flush.h
index 4d40908462bb..97252d6656e0 100644
--- a/drivers/md/dm-vdo/flush.h
+++ b/drivers/md/dm-vdo/flush.h
@@ -18,7 +18,7 @@ struct vdo_flush {
 	/* The flush bios covered by this request */
 	struct bio_list bios;
 	/* The wait queue entry for this flush */
-	struct waiter waiter;
+	struct vdo_waiter waiter;
 	/* Which flush this struct represents */
 	sequence_number_t flush_generation;
 };
diff --git a/drivers/md/dm-vdo/physical-zone.c b/drivers/md/dm-vdo/physical-zone.c
index d3fc4666c3c2..9b99c9a820a3 100644
--- a/drivers/md/dm-vdo/physical-zone.c
+++ b/drivers/md/dm-vdo/physical-zone.c
@@ -519,9 +519,9 @@ static int allocate_and_lock_block(struct allocation *allocation)
  * @waiter: The allocating_vio that was waiting to allocate.
  * @context: The context (unused).
  */
-static void retry_allocation(struct waiter *waiter, void *context __always_unused)
+static void retry_allocation(struct vdo_waiter *waiter, void *context __always_unused)
 {
-	struct data_vio *data_vio = waiter_as_data_vio(waiter);
+	struct data_vio *data_vio = vdo_waiter_as_data_vio(waiter);
 
 	/* Now that some slab has scrubbed, restart the allocation process. */
 	data_vio->allocation.wait_for_clean_slab = false;
diff --git a/drivers/md/dm-vdo/recovery-journal.c b/drivers/md/dm-vdo/recovery-journal.c
index 2dfc39deef94..5126e670e97e 100644
--- a/drivers/md/dm-vdo/recovery-journal.c
+++ b/drivers/md/dm-vdo/recovery-journal.c
@@ -267,9 +267,9 @@ static void assert_on_journal_thread(struct recovery_journal *journal,
  * Invoked whenever a data_vio is to be released from the journal, either because its entry was
  * committed to disk, or because there was an error. Implements waiter_callback_fn.
  */
-static void continue_waiter(struct waiter *waiter, void *context)
+static void continue_waiter(struct vdo_waiter *waiter, void *context)
 {
-	continue_data_vio_with_error(waiter_as_data_vio(waiter), *((int *) context));
+	continue_data_vio_with_error(vdo_waiter_as_data_vio(waiter), *((int *) context));
 }
 
 /**
@@ -287,8 +287,8 @@ static inline bool has_block_waiters(struct recovery_journal *journal)
 	 * has waiters.
 	 */
 	return ((block != NULL) &&
-		(vdo_has_waiters(&block->entry_waiters) ||
-		 vdo_has_waiters(&block->commit_waiters)));
+		(vdo_waitq_has_waiters(&block->entry_waiters) ||
+		 vdo_waitq_has_waiters(&block->commit_waiters)));
 }
 
 static void recycle_journal_blocks(struct recovery_journal *journal);
@@ -343,14 +343,14 @@ static void check_for_drain_complete(struct recovery_journal *journal)
 		recycle_journal_blocks(journal);
 
 		/* Release any data_vios waiting to be assigned entries. */
-		vdo_notify_all_waiters(&journal->entry_waiters, continue_waiter,
-				       &result);
+		vdo_waitq_notify_all_waiters(&journal->entry_waiters,
+					     continue_waiter, &result);
 	}
 
 	if (!vdo_is_state_draining(&journal->state) ||
 	    journal->reaping ||
 	    has_block_waiters(journal) ||
-	    vdo_has_waiters(&journal->entry_waiters) ||
+	    vdo_waitq_has_waiters(&journal->entry_waiters) ||
 	    !suspend_lock_counter(&journal->lock_counter))
 		return;
 
@@ -721,7 +721,7 @@ int vdo_decode_recovery_journal(struct recovery_journal_state_7_0 state, nonce_t
 
 	INIT_LIST_HEAD(&journal->free_tail_blocks);
 	INIT_LIST_HEAD(&journal->active_tail_blocks);
-	vdo_initialize_wait_queue(&journal->pending_writes);
+	vdo_waitq_init(&journal->pending_writes);
 
 	journal->thread_id = vdo->thread_config.journal_thread;
 	journal->origin = partition->offset;
@@ -1047,7 +1047,7 @@ static void schedule_block_write(struct recovery_journal *journal,
 				 struct recovery_journal_block *block)
 {
 	if (!block->committing)
-		vdo_enqueue_waiter(&journal->pending_writes, &block->write_waiter);
+		vdo_waitq_enqueue_waiter(&journal->pending_writes, &block->write_waiter);
 	/*
 	 * At the end of adding entries, or discovering this partial block is now full and ready to
 	 * rewrite, we will call write_blocks() and write a whole batch.
@@ -1084,9 +1084,9 @@ static void update_usages(struct recovery_journal *journal, struct data_vio *dat
  *
  * Implements waiter_callback_fn.
  */
-static void assign_entry(struct waiter *waiter, void *context)
+static void assign_entry(struct vdo_waiter *waiter, void *context)
 {
-	struct data_vio *data_vio = waiter_as_data_vio(waiter);
+	struct data_vio *data_vio = vdo_waiter_as_data_vio(waiter);
 	struct recovery_journal_block *block = context;
 	struct recovery_journal *journal = block->journal;
 
@@ -1099,10 +1099,10 @@ static void assign_entry(struct waiter *waiter, void *context)
 	update_usages(journal, data_vio);
 	journal->available_space--;
 
-	if (!vdo_has_waiters(&block->entry_waiters))
+	if (!vdo_waitq_has_waiters(&block->entry_waiters))
 		journal->events.blocks.started++;
 
-	vdo_enqueue_waiter(&block->entry_waiters, &data_vio->waiter);
+	vdo_waitq_enqueue_waiter(&block->entry_waiters, &data_vio->waiter);
 	block->entry_count++;
 	block->uncommitted_entry_count++;
 	journal->events.entries.started++;
@@ -1127,9 +1127,10 @@ static void assign_entries(struct recovery_journal *journal)
 	}
 
 	journal->adding_entries = true;
-	while (vdo_has_waiters(&journal->entry_waiters) && prepare_to_assign_entry(journal)) {
-		vdo_notify_next_waiter(&journal->entry_waiters, assign_entry,
-				       journal->active_block);
+	while (vdo_waitq_has_waiters(&journal->entry_waiters) &&
+	       prepare_to_assign_entry(journal)) {
+		vdo_waitq_notify_next_waiter(&journal->entry_waiters,
+					     assign_entry, journal->active_block);
 	}
 
 	/* Now that we've finished with entries, see if we have a batch of blocks to write. */
@@ -1170,9 +1171,9 @@ static void recycle_journal_block(struct recovery_journal_block *block)
  *
  * Implements waiter_callback_fn.
  */
-static void continue_committed_waiter(struct waiter *waiter, void *context)
+static void continue_committed_waiter(struct vdo_waiter *waiter, void *context)
 {
-	struct data_vio *data_vio = waiter_as_data_vio(waiter);
+	struct data_vio *data_vio = vdo_waiter_as_data_vio(waiter);
 	struct recovery_journal *journal = context;
 	int result = (is_read_only(journal) ? VDO_READ_ONLY : VDO_SUCCESS);
 	bool has_decrement;
@@ -1216,11 +1217,12 @@ static void notify_commit_waiters(struct recovery_journal *journal)
 		if (block->committing)
 			return;
 
-		vdo_notify_all_waiters(&block->commit_waiters, continue_committed_waiter,
-				       journal);
+		vdo_waitq_notify_all_waiters(&block->commit_waiters,
+					     continue_committed_waiter, journal);
 		if (is_read_only(journal)) {
-			vdo_notify_all_waiters(&block->entry_waiters,
-					       continue_committed_waiter, journal);
+			vdo_waitq_notify_all_waiters(&block->entry_waiters,
+						     continue_committed_waiter,
+						     journal);
 		} else if (is_block_dirty(block) || !is_block_full(block)) {
 			/* Stop at partially-committed or partially-filled blocks. */
 			return;
@@ -1328,9 +1330,9 @@ static void complete_write_endio(struct bio *bio)
  */
 static void add_queued_recovery_entries(struct recovery_journal_block *block)
 {
-	while (vdo_has_waiters(&block->entry_waiters)) {
+	while (vdo_waitq_has_waiters(&block->entry_waiters)) {
 		struct data_vio *data_vio =
-			waiter_as_data_vio(vdo_dequeue_next_waiter(&block->entry_waiters));
+			vdo_waiter_as_data_vio(vdo_waitq_dequeue_next_waiter(&block->entry_waiters));
 		struct tree_lock *lock = &data_vio->tree_lock;
 		struct packed_recovery_journal_entry *packed_entry;
 		struct recovery_journal_entry new_entry;
@@ -1357,7 +1359,7 @@ static void add_queued_recovery_entries(struct recovery_journal_block *block)
 		data_vio->recovery_sequence_number = block->sequence_number;
 
 		/* Enqueue the data_vio to wait for its entry to commit. */
-		vdo_enqueue_waiter(&block->commit_waiters, &data_vio->waiter);
+		vdo_waitq_enqueue_waiter(&block->commit_waiters, &data_vio->waiter);
 	}
 }
 
@@ -1366,17 +1368,18 @@ static void add_queued_recovery_entries(struct recovery_journal_block *block)
  *
  * Implements waiter_callback_fn.
  */
-static void write_block(struct waiter *waiter, void *context __always_unused)
+static void write_block(struct vdo_waiter *waiter, void *context __always_unused)
 {
 	struct recovery_journal_block *block =
 		container_of(waiter, struct recovery_journal_block, write_waiter);
 	struct recovery_journal *journal = block->journal;
 	struct packed_journal_header *header = get_block_header(block);
 
-	if (block->committing || !vdo_has_waiters(&block->entry_waiters) || is_read_only(journal))
+	if (block->committing || !vdo_waitq_has_waiters(&block->entry_waiters) ||
+	    is_read_only(journal))
 		return;
 
-	block->entries_in_commit = vdo_count_waiters(&block->entry_waiters);
+	block->entries_in_commit = vdo_waitq_num_waiters(&block->entry_waiters);
 	add_queued_recovery_entries(block);
 
 	journal->pending_write_count += 1;
@@ -1419,7 +1422,7 @@ static void write_blocks(struct recovery_journal *journal)
 		return;
 
 	/* Write all the full blocks. */
-	vdo_notify_all_waiters(&journal->pending_writes, write_block, NULL);
+	vdo_waitq_notify_all_waiters(&journal->pending_writes, write_block, NULL);
 
 	/*
 	 * Do we need to write the active block? Only if we have no outstanding writes, even after
@@ -1459,7 +1462,7 @@ void vdo_add_recovery_journal_entry(struct recovery_journal *journal,
 			"journal lock not held for new entry");
 
 	vdo_advance_journal_point(&journal->append_point, journal->entries_per_block);
-	vdo_enqueue_waiter(&journal->entry_waiters, &data_vio->waiter);
+	vdo_waitq_enqueue_waiter(&journal->entry_waiters, &data_vio->waiter);
 	assign_entries(journal);
 }
 
@@ -1721,8 +1724,8 @@ static void dump_recovery_block(const struct recovery_journal_block *block)
 	uds_log_info("    sequence number %llu; entries %u; %s; %zu entry waiters; %zu commit waiters",
 		     (unsigned long long) block->sequence_number, block->entry_count,
 		     (block->committing ? "committing" : "waiting"),
-		     vdo_count_waiters(&block->entry_waiters),
-		     vdo_count_waiters(&block->commit_waiters));
+		     vdo_waitq_num_waiters(&block->entry_waiters),
+		     vdo_waitq_num_waiters(&block->commit_waiters));
 }
 
 /**
@@ -1745,7 +1748,7 @@ void vdo_dump_recovery_journal_statistics(const struct recovery_journal *journal
 		     (unsigned long long) journal->slab_journal_reap_head,
 		     (unsigned long long) stats.disk_full,
 		     (unsigned long long) stats.slab_journal_commits_requested,
-		     vdo_count_waiters(&journal->entry_waiters));
+		     vdo_waitq_num_waiters(&journal->entry_waiters));
 	uds_log_info("	entries: started=%llu written=%llu committed=%llu",
 		     (unsigned long long) stats.entries.started,
 		     (unsigned long long) stats.entries.written,
diff --git a/drivers/md/dm-vdo/recovery-journal.h b/drivers/md/dm-vdo/recovery-journal.h
index c6d83019f918..19fa7ed9648a 100644
--- a/drivers/md/dm-vdo/recovery-journal.h
+++ b/drivers/md/dm-vdo/recovery-journal.h
@@ -113,7 +113,7 @@ struct recovery_journal_block {
 	/* The doubly linked pointers for the free or active lists */
 	struct list_head list_node;
 	/* The waiter for the pending full block list */
-	struct waiter write_waiter;
+	struct vdo_waiter write_waiter;
 	/* The journal to which this block belongs */
 	struct recovery_journal *journal;
 	/* A pointer to the current sector in the packed block buffer */
@@ -133,9 +133,9 @@ struct recovery_journal_block {
 	/* The number of new entries in the current commit */
 	journal_entry_count_t entries_in_commit;
 	/* The queue of vios which will make entries for the next commit */
-	struct wait_queue entry_waiters;
+	struct vdo_wait_queue entry_waiters;
 	/* The queue of vios waiting for the current commit */
-	struct wait_queue commit_waiters;
+	struct vdo_wait_queue commit_waiters;
 };
 
 struct recovery_journal {
@@ -146,7 +146,7 @@ struct recovery_journal {
 	/* The block map which can hold locks on this journal */
 	struct block_map *block_map;
 	/* The queue of vios waiting to make entries */
-	struct wait_queue entry_waiters;
+	struct vdo_wait_queue entry_waiters;
 	/* The number of free entries in the journal */
 	u64 available_space;
 	/* The number of decrement entries which need to be made */
@@ -184,7 +184,7 @@ struct recovery_journal {
 	/* A pointer to the active block (the one we are adding entries to now) */
 	struct recovery_journal_block *active_block;
 	/* Journal blocks that need writing */
-	struct wait_queue pending_writes;
+	struct vdo_wait_queue pending_writes;
 	/* The new block map reap head after reaping */
 	sequence_number_t block_map_reap_head;
 	/* The head block number for the block map rebuild range */
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 670a464ddbb0..2125e256aa86 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -65,7 +65,7 @@ static bool is_slab_open(struct vdo_slab *slab)
 static inline bool __must_check must_make_entries_to_flush(struct slab_journal *journal)
 {
 	return ((journal->slab->status != VDO_SLAB_REBUILDING) &&
-		vdo_has_waiters(&journal->entry_waiters));
+		vdo_waitq_has_waiters(&journal->entry_waiters));
 }
 
 /**
@@ -122,7 +122,7 @@ static bool __must_check block_is_full(struct slab_journal *journal)
 
 static void add_entries(struct slab_journal *journal);
 static void update_tail_block_location(struct slab_journal *journal);
-static void release_journal_locks(struct waiter *waiter, void *context);
+static void release_journal_locks(struct vdo_waiter *waiter, void *context);
 
 /**
  * is_slab_journal_blank() - Check whether a slab's journal is blank.
@@ -184,7 +184,7 @@ static void check_if_slab_drained(struct vdo_slab *slab)
 	code = vdo_get_admin_state_code(&slab->state);
 	read_only = vdo_is_read_only(slab->allocator->depot->vdo);
 	if (!read_only &&
-	    vdo_has_waiters(&slab->dirty_blocks) &&
+	    vdo_waitq_has_waiters(&slab->dirty_blocks) &&
 	    (code != VDO_ADMIN_STATE_SUSPENDING) &&
 	    (code != VDO_ADMIN_STATE_RECOVERING))
 		return;
@@ -229,14 +229,13 @@ static u8 __must_check compute_fullness_hint(struct slab_depot *depot,
  */
 static void check_summary_drain_complete(struct block_allocator *allocator)
 {
-	struct vdo *vdo = allocator->depot->vdo;
-
 	if (!vdo_is_state_draining(&allocator->summary_state) ||
 	    (allocator->summary_write_count > 0))
 		return;
 
 	vdo_finish_operation(&allocator->summary_state,
-			     (vdo_is_read_only(vdo) ? VDO_READ_ONLY : VDO_SUCCESS));
+			     (vdo_is_read_only(allocator->depot->vdo) ?
+			      VDO_READ_ONLY : VDO_SUCCESS));
 }
 
 /**
@@ -245,11 +244,12 @@ static void check_summary_drain_complete(struct block_allocator *allocator)
  * @queue: The queue to notify.
  */
 static void notify_summary_waiters(struct block_allocator *allocator,
-				   struct wait_queue *queue)
+				   struct vdo_wait_queue *queue)
 {
-	int result = (vdo_is_read_only(allocator->depot->vdo) ? VDO_READ_ONLY : VDO_SUCCESS);
+	int result = (vdo_is_read_only(allocator->depot->vdo) ?
+		      VDO_READ_ONLY : VDO_SUCCESS);
 
-	vdo_notify_all_waiters(queue, NULL, &result);
+	vdo_waitq_notify_all_waiters(queue, NULL, &result);
 }
 
 static void launch_write(struct slab_summary_block *summary_block);
@@ -264,7 +264,7 @@ static void finish_updating_slab_summary_block(struct slab_summary_block *block)
 	notify_summary_waiters(block->allocator, &block->current_update_waiters);
 	block->writing = false;
 	block->allocator->summary_write_count--;
-	if (vdo_has_waiters(&block->next_update_waiters))
+	if (vdo_waitq_has_waiters(&block->next_update_waiters))
 		launch_write(block);
 	else
 		check_summary_drain_complete(block->allocator);
@@ -320,8 +320,8 @@ static void launch_write(struct slab_summary_block *block)
 		return;
 
 	allocator->summary_write_count++;
-	vdo_transfer_all_waiters(&block->next_update_waiters,
-				 &block->current_update_waiters);
+	vdo_waitq_transfer_all_waiters(&block->next_update_waiters,
+				       &block->current_update_waiters);
 	block->writing = true;
 
 	if (vdo_is_read_only(depot->vdo)) {
@@ -351,7 +351,7 @@ static void launch_write(struct slab_summary_block *block)
  * @is_clean: Whether the slab is clean.
  * @free_blocks: The number of free blocks.
  */
-static void update_slab_summary_entry(struct vdo_slab *slab, struct waiter *waiter,
+static void update_slab_summary_entry(struct vdo_slab *slab, struct vdo_waiter *waiter,
 				      tail_block_offset_t tail_block_offset,
 				      bool load_ref_counts, bool is_clean,
 				      block_count_t free_blocks)
@@ -382,7 +382,7 @@ static void update_slab_summary_entry(struct vdo_slab *slab, struct waiter *wait
 		.is_dirty = !is_clean,
 		.fullness_hint = compute_fullness_hint(allocator->depot, free_blocks),
 	};
-	vdo_enqueue_waiter(&block->next_update_waiters, waiter);
+	vdo_waitq_enqueue_waiter(&block->next_update_waiters, waiter);
 	launch_write(block);
 }
 
@@ -441,7 +441,7 @@ static void flush_endio(struct bio *bio)
  * @waiter: The journal as a flush waiter.
  * @context: The newly acquired flush vio.
  */
-static void flush_for_reaping(struct waiter *waiter, void *context)
+static void flush_for_reaping(struct vdo_waiter *waiter, void *context)
 {
 	struct slab_journal *journal =
 		container_of(waiter, struct slab_journal, flush_waiter);
@@ -550,7 +550,7 @@ static void adjust_slab_journal_block_reference(struct slab_journal *journal,
  *
  * Implements waiter_callback_fn.
  */
-static void release_journal_locks(struct waiter *waiter, void *context)
+static void release_journal_locks(struct vdo_waiter *waiter, void *context)
 {
 	sequence_number_t first, i;
 	struct slab_journal *journal =
@@ -734,7 +734,7 @@ static void write_slab_journal_endio(struct bio *bio)
  *
  * Callback from acquire_vio_from_pool() registered in commit_tail().
  */
-static void write_slab_journal_block(struct waiter *waiter, void *context)
+static void write_slab_journal_block(struct vdo_waiter *waiter, void *context)
 {
 	struct pooled_vio *pooled = context;
 	struct vio *vio = &pooled->vio;
@@ -1006,7 +1006,7 @@ static bool requires_reaping(const struct slab_journal *journal)
 }
 
 /** finish_summary_update() - A waiter callback that resets the writing state of a slab. */
-static void finish_summary_update(struct waiter *waiter, void *context)
+static void finish_summary_update(struct vdo_waiter *waiter, void *context)
 {
 	struct vdo_slab *slab = container_of(waiter, struct vdo_slab, summary_waiter);
 	int result = *((int *) context);
@@ -1021,7 +1021,7 @@ static void finish_summary_update(struct waiter *waiter, void *context)
 	check_if_slab_drained(slab);
 }
 
-static void write_reference_block(struct waiter *waiter, void *context);
+static void write_reference_block(struct vdo_waiter *waiter, void *context);
 
 /**
  * launch_reference_block_write() - Launch the write of a dirty reference block by first acquiring
@@ -1032,7 +1032,7 @@ static void write_reference_block(struct waiter *waiter, void *context);
  * This can be asynchronous since the writer will have to wait if all VIOs in the pool are
  * currently in use.
  */
-static void launch_reference_block_write(struct waiter *waiter, void *context)
+static void launch_reference_block_write(struct vdo_waiter *waiter, void *context)
 {
 	struct vdo_slab *slab = context;
 
@@ -1047,7 +1047,8 @@ static void launch_reference_block_write(struct waiter *waiter, void *context)
 
 static void save_dirty_reference_blocks(struct vdo_slab *slab)
 {
-	vdo_notify_all_waiters(&slab->dirty_blocks, launch_reference_block_write, slab);
+	vdo_waitq_notify_all_waiters(&slab->dirty_blocks,
+				     launch_reference_block_write, slab);
 	check_if_slab_drained(slab);
 }
 
@@ -1084,7 +1085,7 @@ static void finish_reference_block_write(struct vdo_completion *completion)
 
 	/* Re-queue the block if it was re-dirtied while it was writing. */
 	if (block->is_dirty) {
-		vdo_enqueue_waiter(&block->slab->dirty_blocks, &block->waiter);
+		vdo_waitq_enqueue_waiter(&block->slab->dirty_blocks, &block->waiter);
 		if (vdo_is_state_draining(&slab->state)) {
 			/* We must be saving, and this block will otherwise not be relaunched. */
 			save_dirty_reference_blocks(slab);
@@ -1097,7 +1098,7 @@ static void finish_reference_block_write(struct vdo_completion *completion)
 	 * Mark the slab as clean in the slab summary if there are no dirty or writing blocks
 	 * and no summary update in progress.
 	 */
-	if ((slab->active_count > 0) || vdo_has_waiters(&slab->dirty_blocks)) {
+	if ((slab->active_count > 0) || vdo_waitq_has_waiters(&slab->dirty_blocks)) {
 		check_if_slab_drained(slab);
 		return;
 	}
@@ -1175,7 +1176,7 @@ static void handle_io_error(struct vdo_completion *completion)
  * @waiter: The waiter of the dirty block.
  * @context: The VIO returned by the pool.
  */
-static void write_reference_block(struct waiter *waiter, void *context)
+static void write_reference_block(struct vdo_waiter *waiter, void *context)
 {
 	size_t block_offset;
 	physical_block_number_t pbn;
@@ -1213,7 +1214,7 @@ static void reclaim_journal_space(struct slab_journal *journal)
 {
 	block_count_t length = journal_length(journal);
 	struct vdo_slab *slab = journal->slab;
-	block_count_t write_count = vdo_count_waiters(&slab->dirty_blocks);
+	block_count_t write_count = vdo_waitq_num_waiters(&slab->dirty_blocks);
 	block_count_t written;
 
 	if ((length < journal->flushing_threshold) || (write_count == 0))
@@ -1228,8 +1229,8 @@ static void reclaim_journal_space(struct slab_journal *journal)
 	}
 
 	for (written = 0; written < write_count; written++) {
-		vdo_notify_next_waiter(&slab->dirty_blocks,
-				       launch_reference_block_write, slab);
+		vdo_waitq_notify_next_waiter(&slab->dirty_blocks,
+					     launch_reference_block_write, slab);
 	}
 }
 
@@ -1263,7 +1264,7 @@ static void dirty_block(struct reference_block *block)
 
 	block->is_dirty = true;
 	if (!block->is_writing)
-		vdo_enqueue_waiter(&block->slab->dirty_blocks, &block->waiter);
+		vdo_waitq_enqueue_waiter(&block->slab->dirty_blocks, &block->waiter);
 }
 
 /**
@@ -1678,7 +1679,7 @@ static int __must_check adjust_reference_count(struct vdo_slab *slab,
  * This callback is invoked by add_entries() once it has determined that we are ready to make
  * another entry in the slab journal. Implements waiter_callback_fn.
  */
-static void add_entry_from_waiter(struct waiter *waiter, void *context)
+static void add_entry_from_waiter(struct vdo_waiter *waiter, void *context)
 {
 	int result;
 	struct reference_updater *updater =
@@ -1744,7 +1745,7 @@ static void add_entry_from_waiter(struct waiter *waiter, void *context)
  */
 static inline bool is_next_entry_a_block_map_increment(struct slab_journal *journal)
 {
-	struct waiter *waiter = vdo_get_first_waiter(&journal->entry_waiters);
+	struct vdo_waiter *waiter = vdo_waitq_get_first_waiter(&journal->entry_waiters);
 	struct reference_updater *updater = container_of(waiter,
 							 struct reference_updater,
 							 waiter);
@@ -1767,7 +1768,7 @@ static void add_entries(struct slab_journal *journal)
 	}
 
 	journal->adding_entries = true;
-	while (vdo_has_waiters(&journal->entry_waiters)) {
+	while (vdo_waitq_has_waiters(&journal->entry_waiters)) {
 		struct slab_journal_block_header *header = &journal->tail_header;
 
 		if (journal->partial_write_in_progress ||
@@ -1864,8 +1865,8 @@ static void add_entries(struct slab_journal *journal)
 			}
 		}
 
-		vdo_notify_next_waiter(&journal->entry_waiters,
-				       add_entry_from_waiter, journal);
+		vdo_waitq_notify_next_waiter(&journal->entry_waiters,
+					     add_entry_from_waiter, journal);
 	}
 
 	journal->adding_entries = false;
@@ -1873,7 +1874,7 @@ static void add_entries(struct slab_journal *journal)
 	/* If there are no waiters, and we are flushing or saving, commit the tail block. */
 	if (vdo_is_state_draining(&journal->slab->state) &&
 	    !vdo_is_state_suspending(&journal->slab->state) &&
-	    !vdo_has_waiters(&journal->entry_waiters))
+	    !vdo_waitq_has_waiters(&journal->entry_waiters))
 		commit_tail(journal);
 }
 
@@ -2259,7 +2260,7 @@ static void load_reference_block_endio(struct bio *bio)
  * @waiter: The waiter of the block to load.
  * @context: The VIO returned by the pool.
  */
-static void load_reference_block(struct waiter *waiter, void *context)
+static void load_reference_block(struct vdo_waiter *waiter, void *context)
 {
 	struct pooled_vio *pooled = context;
 	struct vio *vio = &pooled->vio;
@@ -2284,7 +2285,7 @@ static void load_reference_blocks(struct vdo_slab *slab)
 	slab->free_blocks = slab->block_count;
 	slab->active_count = slab->reference_block_count;
 	for (i = 0; i < slab->reference_block_count; i++) {
-		struct waiter *waiter = &slab->reference_blocks[i].waiter;
+		struct vdo_waiter *waiter = &slab->reference_blocks[i].waiter;
 
 		waiter->callback = load_reference_block;
 		acquire_vio_from_pool(slab->allocator->vio_pool, waiter);
@@ -2455,7 +2456,7 @@ static void handle_load_error(struct vdo_completion *completion)
  *
  * This is the success callback from acquire_vio_from_pool() when loading a slab journal.
  */
-static void read_slab_journal_tail(struct waiter *waiter, void *context)
+static void read_slab_journal_tail(struct vdo_waiter *waiter, void *context)
 {
 	struct slab_journal *journal =
 		container_of(waiter, struct slab_journal, resource_waiter);
@@ -2662,7 +2663,7 @@ static void uninitialize_scrubber_vio(struct slab_scrubber *scrubber)
  */
 static void finish_scrubbing(struct slab_scrubber *scrubber, int result)
 {
-	bool notify = vdo_has_waiters(&scrubber->waiters);
+	bool notify = vdo_waitq_has_waiters(&scrubber->waiters);
 	bool done = !has_slabs_to_scrub(scrubber);
 	struct block_allocator *allocator =
 		container_of(scrubber, struct block_allocator, scrubber);
@@ -2709,7 +2710,7 @@ static void finish_scrubbing(struct slab_scrubber *scrubber, int result)
 	 * Fortunately if there were waiters, we can't have been freed yet.
 	 */
 	if (notify)
-		vdo_notify_all_waiters(&scrubber->waiters, NULL, NULL);
+		vdo_waitq_notify_all_waiters(&scrubber->waiters, NULL, NULL);
 }
 
 static void scrub_next_slab(struct slab_scrubber *scrubber);
@@ -2933,7 +2934,7 @@ static void scrub_next_slab(struct slab_scrubber *scrubber)
 	 * Note: this notify call is always safe only because scrubbing can only be started when
 	 * the VDO is quiescent.
 	 */
-	vdo_notify_all_waiters(&scrubber->waiters, NULL, NULL);
+	vdo_waitq_notify_all_waiters(&scrubber->waiters, NULL, NULL);
 
 	if (vdo_is_read_only(completion->vdo)) {
 		finish_scrubbing(scrubber, VDO_READ_ONLY);
@@ -3053,7 +3054,7 @@ static struct vdo_slab *next_slab(struct slab_iterator *iterator)
  * This callback is invoked on all vios waiting to make slab journal entries after the VDO has gone
  * into read-only mode. Implements waiter_callback_fn.
  */
-static void abort_waiter(struct waiter *waiter, void *context __always_unused)
+static void abort_waiter(struct vdo_waiter *waiter, void *context __always_unused)
 {
 	struct reference_updater *updater =
 		container_of(waiter, struct reference_updater, waiter);
@@ -3079,8 +3080,8 @@ static void notify_block_allocator_of_read_only_mode(void *listener,
 	while (iterator.next != NULL) {
 		struct vdo_slab *slab = next_slab(&iterator);
 
-		vdo_notify_all_waiters(&slab->journal.entry_waiters,
-				       abort_waiter, &slab->journal);
+		vdo_waitq_notify_all_waiters(&slab->journal.entry_waiters,
+					     abort_waiter, &slab->journal);
 		check_if_slab_drained(slab);
 	}
 
@@ -3210,7 +3211,7 @@ int vdo_allocate_block(struct block_allocator *allocator,
  *         some other error otherwise.
  */
 int vdo_enqueue_clean_slab_waiter(struct block_allocator *allocator,
-				  struct waiter *waiter)
+				  struct vdo_waiter *waiter)
 {
 	if (vdo_is_read_only(allocator->depot->vdo))
 		return VDO_READ_ONLY;
@@ -3218,7 +3219,7 @@ int vdo_enqueue_clean_slab_waiter(struct block_allocator *allocator,
 	if (vdo_is_state_quiescent(&allocator->scrubber.admin_state))
 		return VDO_NO_SPACE;
 
-	vdo_enqueue_waiter(&allocator->scrubber.waiters, waiter);
+	vdo_waitq_enqueue_waiter(&allocator->scrubber.waiters, waiter);
 	return VDO_SUCCESS;
 }
 
@@ -3244,7 +3245,7 @@ void vdo_modify_reference_count(struct vdo_completion *completion,
 		return;
 	}
 
-	vdo_enqueue_waiter(&slab->journal.entry_waiters, &updater->waiter);
+	vdo_waitq_enqueue_waiter(&slab->journal.entry_waiters, &updater->waiter);
 	if ((slab->status != VDO_SLAB_REBUILT) && requires_reaping(&slab->journal))
 		register_slab_for_scrubbing(slab, true);
 
@@ -3587,7 +3588,7 @@ void vdo_dump_block_allocator(const struct block_allocator *allocator)
 		}
 
 		uds_log_info("  slab journal: entry_waiters=%zu waiting_to_commit=%s updating_slab_summary=%s head=%llu unreapable=%llu tail=%llu next_commit=%llu summarized=%llu last_summarized=%llu recovery_lock=%llu dirty=%s",
-			     vdo_count_waiters(&journal->entry_waiters),
+			     vdo_waitq_num_waiters(&journal->entry_waiters),
 			     uds_bool_to_string(journal->waiting_to_commit),
 			     uds_bool_to_string(journal->updating_slab_summary),
 			     (unsigned long long) journal->head,
@@ -3608,7 +3609,7 @@ void vdo_dump_block_allocator(const struct block_allocator *allocator)
 			uds_log_info("  slab: free=%u/%u blocks=%u dirty=%zu active=%zu journal@(%llu,%u)",
 				     slab->free_blocks, slab->block_count,
 				     slab->reference_block_count,
-				     vdo_count_waiters(&slab->dirty_blocks),
+				     vdo_waitq_num_waiters(&slab->dirty_blocks),
 				     slab->active_count,
 				     (unsigned long long) slab->slab_journal_point.sequence_number,
 				     slab->slab_journal_point.entry_count);
@@ -3628,7 +3629,7 @@ void vdo_dump_block_allocator(const struct block_allocator *allocator)
 
 	uds_log_info("slab_scrubber slab_count %u waiters %zu %s%s",
 		     READ_ONCE(scrubber->slab_count),
-		     vdo_count_waiters(&scrubber->waiters),
+		     vdo_waitq_num_waiters(&scrubber->waiters),
 		     vdo_get_admin_state_code(&scrubber->admin_state)->name,
 		     scrubber->high_priority_only ? ", high_priority_only " : "");
 }
diff --git a/drivers/md/dm-vdo/slab-depot.h b/drivers/md/dm-vdo/slab-depot.h
index 169021b0811a..efdef566709a 100644
--- a/drivers/md/dm-vdo/slab-depot.h
+++ b/drivers/md/dm-vdo/slab-depot.h
@@ -60,13 +60,13 @@ struct journal_lock {
 
 struct slab_journal {
 	/* A waiter object for getting a VIO pool entry */
-	struct waiter resource_waiter;
+	struct vdo_waiter resource_waiter;
 	/* A waiter object for updating the slab summary */
-	struct waiter slab_summary_waiter;
+	struct vdo_waiter slab_summary_waiter;
 	/* A waiter object for getting a vio with which to flush */
-	struct waiter flush_waiter;
+	struct vdo_waiter flush_waiter;
 	/* The queue of VIOs waiting to make an entry */
-	struct wait_queue entry_waiters;
+	struct vdo_wait_queue entry_waiters;
 	/* The parent slab reference of this journal */
 	struct vdo_slab *slab;
 
@@ -149,7 +149,7 @@ struct slab_journal {
  */
 struct reference_block {
 	/* This block waits on the ref_counts to tell it to write */
-	struct waiter waiter;
+	struct vdo_waiter waiter;
 	/* The slab to which this reference_block belongs */
 	struct vdo_slab *slab;
 	/* The number of references in this block that represent allocations */
@@ -241,12 +241,12 @@ struct vdo_slab {
 	struct search_cursor search_cursor;
 
 	/* A list of the dirty blocks waiting to be written out */
-	struct wait_queue dirty_blocks;
+	struct vdo_wait_queue dirty_blocks;
 	/* The number of blocks which are currently writing */
 	size_t active_count;
 
 	/* A waiter object for updating the slab summary */
-	struct waiter summary_waiter;
+	struct vdo_waiter summary_waiter;
 
 	/* The latest slab journal for which there has been a reference count update */
 	struct journal_point slab_journal_point;
@@ -271,7 +271,7 @@ struct slab_scrubber {
 	/* The queue of slabs to scrub once there are no high_priority_slabs */
 	struct list_head slabs;
 	/* The queue of VIOs waiting for a slab to be scrubbed */
-	struct wait_queue waiters;
+	struct vdo_wait_queue waiters;
 
 	/*
 	 * The number of slabs that are unrecovered or being scrubbed. This field is modified by
@@ -341,9 +341,9 @@ struct slab_summary_block {
 	/* Whether this block has a write outstanding */
 	bool writing;
 	/* Ring of updates waiting on the outstanding write */
-	struct wait_queue current_update_waiters;
+	struct vdo_wait_queue current_update_waiters;
 	/* Ring of updates waiting on the next write */
-	struct wait_queue next_update_waiters;
+	struct vdo_wait_queue next_update_waiters;
 	/* The active slab_summary_entry array for this block */
 	struct slab_summary_entry *entries;
 	/* The vio used to write this block */
@@ -522,7 +522,7 @@ int __must_check vdo_allocate_block(struct block_allocator *allocator,
 				    physical_block_number_t *block_number_ptr);
 
 int vdo_enqueue_clean_slab_waiter(struct block_allocator *allocator,
-				  struct waiter *waiter);
+				  struct vdo_waiter *waiter);
 
 void vdo_modify_reference_count(struct vdo_completion *completion,
 				struct reference_updater *updater);
diff --git a/drivers/md/dm-vdo/vio.c b/drivers/md/dm-vdo/vio.c
index f83b56acc8e4..6acaba149c75 100644
--- a/drivers/md/dm-vdo/vio.c
+++ b/drivers/md/dm-vdo/vio.c
@@ -25,7 +25,7 @@ struct vio_pool {
 	/** The list of objects which are available */
 	struct list_head available;
 	/** The queue of requestors waiting for objects from the pool */
-	struct wait_queue waiting;
+	struct vdo_wait_queue waiting;
 	/** The number of objects currently in use */
 	size_t busy_count;
 	/** The list of objects which are in use */
@@ -364,7 +364,7 @@ void free_vio_pool(struct vio_pool *pool)
 		return;
 
 	/* Remove all available vios from the object pool. */
-	ASSERT_LOG_ONLY(!vdo_has_waiters(&pool->waiting),
+	ASSERT_LOG_ONLY(!vdo_waitq_has_waiters(&pool->waiting),
 			"VIO pool must not have any waiters when being freed");
 	ASSERT_LOG_ONLY((pool->busy_count == 0),
 			"VIO pool must not have %zu busy entries when being freed",
@@ -400,7 +400,7 @@ bool is_vio_pool_busy(struct vio_pool *pool)
  * @pool: The vio pool.
  * @waiter: Object that is requesting a vio.
  */
-void acquire_vio_from_pool(struct vio_pool *pool, struct waiter *waiter)
+void acquire_vio_from_pool(struct vio_pool *pool, struct vdo_waiter *waiter)
 {
 	struct pooled_vio *pooled;
 
@@ -408,7 +408,7 @@ void acquire_vio_from_pool(struct vio_pool *pool, struct waiter *waiter)
 			"acquire from active vio_pool called from correct thread");
 
 	if (list_empty(&pool->available)) {
-		vdo_enqueue_waiter(&pool->waiting, waiter);
+		vdo_waitq_enqueue_waiter(&pool->waiting, waiter);
 		return;
 	}
 
@@ -430,8 +430,8 @@ void return_vio_to_pool(struct vio_pool *pool, struct pooled_vio *vio)
 
 	vio->vio.completion.error_handler = NULL;
 	vio->vio.completion.parent = NULL;
-	if (vdo_has_waiters(&pool->waiting)) {
-		vdo_notify_next_waiter(&pool->waiting, NULL, vio);
+	if (vdo_waitq_has_waiters(&pool->waiting)) {
+		vdo_waitq_notify_next_waiter(&pool->waiting, NULL, vio);
 		return;
 	}
 
diff --git a/drivers/md/dm-vdo/vio.h b/drivers/md/dm-vdo/vio.h
index 3c72fded69b0..71585424f85b 100644
--- a/drivers/md/dm-vdo/vio.h
+++ b/drivers/md/dm-vdo/vio.h
@@ -193,7 +193,7 @@ int __must_check make_vio_pool(struct vdo *vdo, size_t pool_size, thread_id_t th
 			       void *context, struct vio_pool **pool_ptr);
 void free_vio_pool(struct vio_pool *pool);
 bool __must_check is_vio_pool_busy(struct vio_pool *pool);
-void acquire_vio_from_pool(struct vio_pool *pool, struct waiter *waiter);
+void acquire_vio_from_pool(struct vio_pool *pool, struct vdo_waiter *waiter);
 void return_vio_to_pool(struct vio_pool *pool, struct pooled_vio *vio);
 
 #endif /* VIO_H */
diff --git a/drivers/md/dm-vdo/wait-queue.c b/drivers/md/dm-vdo/wait-queue.c
index 8acc24e79d2b..9c12a9893823 100644
--- a/drivers/md/dm-vdo/wait-queue.c
+++ b/drivers/md/dm-vdo/wait-queue.c
@@ -12,211 +12,213 @@
 #include "status-codes.h"
 
 /**
- * vdo_enqueue_waiter() - Add a waiter to the tail end of a wait queue.
- * @queue: The queue to which to add the waiter.
- * @waiter: The waiter to add to the queue.
+ * vdo_waitq_enqueue_waiter() - Add a waiter to the tail end of a waitq.
+ * @waitq: The vdo_wait_queue to which to add the waiter.
+ * @waiter: The waiter to add to the waitq.
  *
- * The waiter must not already be waiting in a queue.
- *
- * Return: VDO_SUCCESS or an error code.
+ * The waiter must not already be waiting in a waitq.
  */
-void vdo_enqueue_waiter(struct wait_queue *queue, struct waiter *waiter)
+void vdo_waitq_enqueue_waiter(struct vdo_wait_queue *waitq, struct vdo_waiter *waiter)
 {
 	BUG_ON(waiter->next_waiter != NULL);
 
-	if (queue->last_waiter == NULL) {
+	if (waitq->last_waiter == NULL) {
 		/*
-		 * The queue is empty, so form the initial circular list by self-linking the
+		 * The waitq is empty, so form the initial circular list by self-linking the
 		 * initial waiter.
 		 */
 		waiter->next_waiter = waiter;
 	} else {
-		/* Splice the new waiter in at the end of the queue. */
-		waiter->next_waiter = queue->last_waiter->next_waiter;
-		queue->last_waiter->next_waiter = waiter;
+		/* Splice the new waiter in at the end of the waitq. */
+		waiter->next_waiter = waitq->last_waiter->next_waiter;
+		waitq->last_waiter->next_waiter = waiter;
 	}
 
 	/* In both cases, the waiter we added to the ring becomes the last waiter. */
-	queue->last_waiter = waiter;
-	queue->queue_length += 1;
+	waitq->last_waiter = waiter;
+	waitq->length += 1;
 }
 
 /**
- * vdo_transfer_all_waiters() - Transfer all waiters from one wait queue to a second queue,
- *                              emptying the first queue.
- * @from_queue: The queue containing the waiters to move.
- * @to_queue: The queue that will receive the waiters from the first queue.
+ * vdo_waitq_transfer_all_waiters() - Transfer all waiters from one waitq to
+ *                                    a second waitq, emptying the first waitq.
+ * @from_waitq: The waitq containing the waiters to move.
+ * @to_waitq: The waitq that will receive the waiters from the first waitq.
  */
-void vdo_transfer_all_waiters(struct wait_queue *from_queue, struct wait_queue *to_queue)
+void vdo_waitq_transfer_all_waiters(struct vdo_wait_queue *from_waitq,
+				    struct vdo_wait_queue *to_waitq)
 {
-	/* If the source queue is empty, there's nothing to do. */
-	if (!vdo_has_waiters(from_queue))
+	/* If the source waitq is empty, there's nothing to do. */
+	if (!vdo_waitq_has_waiters(from_waitq))
 		return;
 
-	if (vdo_has_waiters(to_queue)) {
+	if (vdo_waitq_has_waiters(to_waitq)) {
 		/*
-		 * Both queues are non-empty. Splice the two circular lists together by swapping
-		 * the next (head) pointers in the list tails.
+		 * Both are non-empty. Splice the two circular lists together
+		 * by swapping the next (head) pointers in the list tails.
 		 */
-		struct waiter *from_head = from_queue->last_waiter->next_waiter;
-		struct waiter *to_head = to_queue->last_waiter->next_waiter;
+		struct vdo_waiter *from_head = from_waitq->last_waiter->next_waiter;
+		struct vdo_waiter *to_head = to_waitq->last_waiter->next_waiter;
 
-		to_queue->last_waiter->next_waiter = from_head;
-		from_queue->last_waiter->next_waiter = to_head;
+		to_waitq->last_waiter->next_waiter = from_head;
+		from_waitq->last_waiter->next_waiter = to_head;
 	}
 
-	to_queue->last_waiter = from_queue->last_waiter;
-	to_queue->queue_length += from_queue->queue_length;
-	vdo_initialize_wait_queue(from_queue);
+	to_waitq->last_waiter = from_waitq->last_waiter;
+	to_waitq->length += from_waitq->length;
+	vdo_waitq_init(from_waitq);
 }
 
 /**
- * vdo_notify_all_waiters() - Notify all the entries waiting in a queue.
- * @queue: The wait queue containing the waiters to notify.
+ * vdo_waitq_notify_all_waiters() - Notify all the entries waiting in a waitq.
+ * @waitq: The vdo_wait_queue containing the waiters to notify.
  * @callback: The function to call to notify each waiter, or NULL to invoke the callback field
  *            registered in each waiter.
  * @context: The context to pass to the callback function.
  *
- * Notifies all the entries waiting in a queue to continue execution by invoking a callback
- * function on each of them in turn. The queue is copied and emptied before invoking any callbacks,
- * and only the waiters that were in the queue at the start of the call will be notified.
+ * Notifies all the entries waiting in a waitq to continue execution by invoking a callback
+ * function on each of them in turn. The waitq is copied and emptied before invoking any callbacks,
+ * and only the waiters that were in the waitq at the start of the call will be notified.
  */
-void vdo_notify_all_waiters(struct wait_queue *queue, waiter_callback_fn callback,
-			    void *context)
+void vdo_waitq_notify_all_waiters(struct vdo_wait_queue *waitq,
+				  vdo_waiter_callback_fn callback, void *context)
 {
 	/*
-	 * Copy and empty the queue first, avoiding the possibility of an infinite loop if entries
-	 * are returned to the queue by the callback function.
+	 * Copy and empty the waitq first, avoiding the possibility of an infinite
+	 * loop if entries are returned to the waitq by the callback function.
 	 */
-	struct wait_queue waiters;
+	struct vdo_wait_queue waiters;
 
-	vdo_initialize_wait_queue(&waiters);
-	vdo_transfer_all_waiters(queue, &waiters);
+	vdo_waitq_init(&waiters);
+	vdo_waitq_transfer_all_waiters(waitq, &waiters);
 
-	/* Drain the copied queue, invoking the callback on every entry. */
-	while (vdo_has_waiters(&waiters))
-		vdo_notify_next_waiter(&waiters, callback, context);
+	/* Drain the copied waitq, invoking the callback on every entry. */
+	while (vdo_waitq_has_waiters(&waiters))
+		vdo_waitq_notify_next_waiter(&waiters, callback, context);
 }
 
 /**
- * vdo_get_first_waiter() - Return the waiter that is at the head end of a wait queue.
- * @queue: The queue from which to get the first waiter.
+ * vdo_waitq_get_first_waiter() - Return the waiter that is at the head end of a waitq.
+ * @waitq: The vdo_wait_queue from which to get the first waiter.
  *
- * Return: The first (oldest) waiter in the queue, or NULL if the queue is empty.
+ * Return: The first (oldest) waiter in the waitq, or NULL if the waitq is empty.
  */
-struct waiter *vdo_get_first_waiter(const struct wait_queue *queue)
+struct vdo_waiter *vdo_waitq_get_first_waiter(const struct vdo_wait_queue *waitq)
 {
-	struct waiter *last_waiter = queue->last_waiter;
+	struct vdo_waiter *last_waiter = waitq->last_waiter;
 
 	if (last_waiter == NULL) {
 		/* There are no waiters, so we're done. */
 		return NULL;
 	}
 
-	/* The queue is circular, so the last entry links to the head of the queue. */
+	/* The waitq is circular, so the last entry links to the head of the waitq. */
 	return last_waiter->next_waiter;
 }
 
 /**
- * vdo_dequeue_matching_waiters() - Remove all waiters that match based on the specified matching
- *                                  method and append them to a wait_queue.
- * @queue: The wait queue to process.
- * @match_method: The method to determine matching.
+ * vdo_waitq_dequeue_matching_waiters() - Remove all waiters that match based on the specified
+ *                                        matching method and append them to a vdo_wait_queue.
+ * @waitq: The vdo_wait_queue to process.
+ * @waiter_match: The method to determine matching.
  * @match_context: Contextual info for the match method.
- * @matched_queue: A wait_queue to store matches.
+ * @matched_waitq: A wait_waitq to store matches.
  */
-void vdo_dequeue_matching_waiters(struct wait_queue *queue, waiter_match_fn match_method,
-				  void *match_context, struct wait_queue *matched_queue)
+void vdo_waitq_dequeue_matching_waiters(struct vdo_wait_queue *waitq,
+					vdo_waiter_match_fn waiter_match,
+					void *match_context,
+					struct vdo_wait_queue *matched_waitq)
 {
-	struct wait_queue matched_waiters, iteration_queue;
+	// FIXME: copying a waitq just to iterate it, with matching, is unfortunate
+	struct vdo_wait_queue matched_waiters, iteration_waitq;
 
-	vdo_initialize_wait_queue(&matched_waiters);
+	vdo_waitq_init(&matched_waiters);
+	vdo_waitq_init(&iteration_waitq);
+	vdo_waitq_transfer_all_waiters(waitq, &iteration_waitq);
 
-	vdo_initialize_wait_queue(&iteration_queue);
-	vdo_transfer_all_waiters(queue, &iteration_queue);
-	while (vdo_has_waiters(&iteration_queue)) {
-		struct waiter *waiter = vdo_dequeue_next_waiter(&iteration_queue);
+	while (vdo_waitq_has_waiters(&iteration_waitq)) {
+		struct vdo_waiter *waiter = vdo_waitq_dequeue_next_waiter(&iteration_waitq);
 
-		vdo_enqueue_waiter((match_method(waiter, match_context) ?
-				    &matched_waiters : queue), waiter);
+		vdo_waitq_enqueue_waiter((waiter_match(waiter, match_context) ?
+					  &matched_waiters : waitq), waiter);
 	}
 
-	vdo_transfer_all_waiters(&matched_waiters, matched_queue);
+	vdo_waitq_transfer_all_waiters(&matched_waiters, matched_waitq);
 }
 
 /**
- * vdo_dequeue_next_waiter() - Remove the first waiter from the head end of a wait queue.
- * @queue: The wait queue from which to remove the first entry.
+ * vdo_waitq_dequeue_next_waiter() - Remove the first waiter from the head end of a waitq.
+ * @waitq: The vdo_wait_queue from which to remove the first entry.
  *
  * The caller will be responsible for waking the waiter by invoking the correct callback function
  * to resume its execution.
  *
- * Return: The first (oldest) waiter in the queue, or NULL if the queue is empty.
+ * Return: The first (oldest) waiter in the waitq, or NULL if the waitq is empty.
  */
-struct waiter *vdo_dequeue_next_waiter(struct wait_queue *queue)
+struct vdo_waiter *vdo_waitq_dequeue_next_waiter(struct vdo_wait_queue *waitq)
 {
-	struct waiter *first_waiter = vdo_get_first_waiter(queue);
-	struct waiter *last_waiter = queue->last_waiter;
+	struct vdo_waiter *first_waiter = vdo_waitq_get_first_waiter(waitq);
+	struct vdo_waiter *last_waiter = waitq->last_waiter;
 
 	if (first_waiter == NULL)
 		return NULL;
 
 	if (first_waiter == last_waiter) {
-		/* The queue has a single entry, so just empty it out by nulling the tail. */
-		queue->last_waiter = NULL;
+		/* The waitq has a single entry, so just empty it out by nulling the tail. */
+		waitq->last_waiter = NULL;
 	} else {
 		/*
-		 * The queue has more than one entry, so splice the first waiter out of the
-		 * circular queue.
+		 * The waitq has more than one entry, so splice the first waiter out of the
+		 * circular waitq.
 		 */
 		last_waiter->next_waiter = first_waiter->next_waiter;
 	}
 
-	/* The waiter is no longer in a wait queue. */
+	/* The waiter is no longer in a waitq. */
 	first_waiter->next_waiter = NULL;
-	queue->queue_length -= 1;
+	waitq->length -= 1;
 
 	return first_waiter;
 }
 
 /**
- * vdo_notify_next_waiter() - Notify the next entry waiting in a queue.
- * @queue: The wait queue containing the waiter to notify.
+ * vdo_waitq_notify_next_waiter() - Notify the next entry waiting in a waitq.
+ * @waitq: The vdo_wait_queue containing the waiter to notify.
  * @callback: The function to call to notify the waiter, or NULL to invoke the callback field
  *            registered in the waiter.
  * @context: The context to pass to the callback function.
  *
- * Notifies the next entry waiting in a queue to continue execution by invoking a callback function
- * on it after removing it from the queue.
+ * Notifies the next entry waiting in a waitq to continue execution by invoking a callback function
+ * on it after removing it from the waitq.
  *
- * Return: true if there was a waiter in the queue.
+ * Return: true if there was a waiter in the waitq.
  */
-bool vdo_notify_next_waiter(struct wait_queue *queue, waiter_callback_fn callback,
-			    void *context)
+bool vdo_waitq_notify_next_waiter(struct vdo_wait_queue *waitq,
+				  vdo_waiter_callback_fn callback, void *context)
 {
-	struct waiter *waiter = vdo_dequeue_next_waiter(queue);
+	struct vdo_waiter *waiter = vdo_waitq_dequeue_next_waiter(waitq);
 
 	if (waiter == NULL)
 		return false;
 
 	if (callback == NULL)
 		callback = waiter->callback;
-	(*callback)(waiter, context);
+	callback(waiter, context);
 
 	return true;
 }
 
 /**
- * vdo_get_next_waiter() - Get the waiter after this one, for debug iteration.
- * @queue: The wait queue.
+ * vdo_waitq_get_next_waiter() - Get the waiter after this one, for debug iteration.
+ * @waitq: The vdo_wait_queue.
  * @waiter: A waiter.
  *
  * Return: The next waiter, or NULL.
  */
-const struct waiter *vdo_get_next_waiter(const struct wait_queue *queue,
-					 const struct waiter *waiter)
+const struct vdo_waiter *vdo_waitq_get_next_waiter(const struct vdo_wait_queue *waitq,
+						   const struct vdo_waiter *waiter)
 {
-	struct waiter *first_waiter = vdo_get_first_waiter(queue);
+	struct vdo_waiter *first_waiter = vdo_waitq_get_first_waiter(waitq);
 
 	if (waiter == NULL)
 		return first_waiter;
diff --git a/drivers/md/dm-vdo/wait-queue.h b/drivers/md/dm-vdo/wait-queue.h
index 50f1e2a1ea67..b92f12dd5b4b 100644
--- a/drivers/md/dm-vdo/wait-queue.h
+++ b/drivers/md/dm-vdo/wait-queue.h
@@ -10,122 +10,132 @@
 #include <linux/types.h>
 
 /**
- * DOC: Wait queues.
+ * A vdo_wait_queue is a circular singly linked list of entries waiting to be notified
+ * of a change in a condition. Keeping a circular list allows the vdo_wait_queue
+ * structure to simply be a pointer to the tail (newest) entry, supporting
+ * constant-time enqueue and dequeue operations. A null pointer is an empty waitq.
  *
- * A wait queue is a circular list of entries waiting to be notified of a change in a condition.
- * Keeping a circular list allows the queue structure to simply be a pointer to the tail (newest)
- * entry in the queue, supporting constant-time enqueue and dequeue operations. A null pointer is
- * an empty queue.
+ *   An empty waitq:
+ *     waitq0.last_waiter -> NULL
  *
- *   An empty queue:
- *     queue0.last_waiter -> NULL
+ *   A singleton waitq:
+ *     waitq1.last_waiter -> entry1 -> entry1 -> [...]
  *
- *   A singleton queue:
- *     queue1.last_waiter -> entry1 -> entry1 -> [...]
+ *   A three-element waitq:
+ *     waitq2.last_waiter -> entry3 -> entry1 -> entry2 -> entry3 -> [...]
  *
- *   A three-element queue:
- *     queue2.last_waiter -> entry3 -> entry1 -> entry2 -> entry3 -> [...]
+ *   linux/wait.h's wait_queue_head is _not_ used because vdo_wait_queue's
+ *   interface is much less complex (doesn't need locking, priorities or timers).
+ *   Made possible by vdo's thread-based resource allocation and locking; and
+ *   the polling nature of vdo_wait_queue consumers.
+ *
+ *   FIXME: could be made to use a linux/list.h's list_head but its extra barriers
+ *   really aren't needed. Nor is a doubly linked list, but vdo_wait_queue could
+ *   make use of __list_del_clearprev() -- but that would compromise the ability
+ *   to make full use of linux's list interface.
  */
 
-struct waiter;
+struct vdo_waiter;
 
-struct wait_queue {
+struct vdo_wait_queue {
 	/* The tail of the queue, the last (most recently added) entry */
-	struct waiter *last_waiter;
+	struct vdo_waiter *last_waiter;
 	/* The number of waiters currently in the queue */
-	size_t queue_length;
+	size_t length;
 };
 
 /**
- * typedef waiter_callback_fn - Callback type for functions which will be called to resume
- *                              processing of a waiter after it has been removed from its wait
- *                              queue.
+ * vdo_waiter_callback_fn - Callback type that will be called to resume processing
+ *                          of a waiter after it has been removed from its wait queue.
  */
-typedef void (*waiter_callback_fn)(struct waiter *waiter, void *context);
+typedef void (*vdo_waiter_callback_fn)(struct vdo_waiter *waiter, void *context);
 
 /**
- * typedef waiter_match_fn - Method type for waiter matching methods.
+ * vdo_waiter_match_fn - Method type for waiter matching methods.
  *
- * A waiter_match_fn method returns false if the waiter does not match.
+ * Returns false if the waiter does not match.
  */
-typedef bool (*waiter_match_fn)(struct waiter *waiter, void *context);
+typedef bool (*vdo_waiter_match_fn)(struct vdo_waiter *waiter, void *context);
 
-/* The queue entry structure for entries in a wait_queue. */
-struct waiter {
+/* The structure for entries in a vdo_wait_queue. */
+struct vdo_waiter {
 	/*
-	 * The next waiter in the queue. If this entry is the last waiter, then this is actually a
-	 * pointer back to the head of the queue.
+	 * The next waiter in the waitq. If this entry is the last waiter, then this
+	 * is actually a pointer back to the head of the waitq.
 	 */
-	struct waiter *next_waiter;
+	struct vdo_waiter *next_waiter;
 
-	/* Optional waiter-specific callback to invoke when waking this waiter. */
-	waiter_callback_fn callback;
+	/* Optional waiter-specific callback to invoke when dequeuing this waiter. */
+	vdo_waiter_callback_fn callback;
 };
 
 /**
- * is_waiting() - Check whether a waiter is waiting.
+ * vdo_waiter_is_waiting() - Check whether a waiter is waiting.
  * @waiter: The waiter to check.
  *
- * Return: true if the waiter is on some wait_queue.
+ * Return: true if the waiter is on some vdo_wait_queue.
  */
-static inline bool vdo_is_waiting(struct waiter *waiter)
+static inline bool vdo_waiter_is_waiting(struct vdo_waiter *waiter)
 {
 	return (waiter->next_waiter != NULL);
 }
 
 /**
- * initialize_wait_queue() - Initialize a wait queue.
- * @queue: The queue to initialize.
+ * vdo_waitq_init() - Initialize a vdo_wait_queue.
+ * @waitq: The vdo_wait_queue to initialize.
  */
-static inline void vdo_initialize_wait_queue(struct wait_queue *queue)
+static inline void vdo_waitq_init(struct vdo_wait_queue *waitq)
 {
-	*queue = (struct wait_queue) {
+	*waitq = (struct vdo_wait_queue) {
 		.last_waiter = NULL,
-		.queue_length = 0,
+		.length = 0,
 	};
 }
 
 /**
- * has_waiters() - Check whether a wait queue has any entries waiting in it.
- * @queue: The queue to query.
+ * vdo_waitq_has_waiters() - Check whether a vdo_wait_queue has any entries waiting.
+ * @waitq: The vdo_wait_queue to query.
  *
- * Return: true if there are any waiters in the queue.
+ * Return: true if there are any waiters in the waitq.
  */
-static inline bool __must_check vdo_has_waiters(const struct wait_queue *queue)
+static inline bool __must_check vdo_waitq_has_waiters(const struct vdo_wait_queue *waitq)
 {
-	return (queue->last_waiter != NULL);
+	return (waitq->last_waiter != NULL);
 }
 
-void vdo_enqueue_waiter(struct wait_queue *queue, struct waiter *waiter);
+void vdo_waitq_enqueue_waiter(struct vdo_wait_queue *waitq,
+			      struct vdo_waiter *waiter);
 
-void vdo_notify_all_waiters(struct wait_queue *queue, waiter_callback_fn callback,
-			    void *context);
+void vdo_waitq_notify_all_waiters(struct vdo_wait_queue *waitq,
+				  vdo_waiter_callback_fn callback, void *context);
 
-bool vdo_notify_next_waiter(struct wait_queue *queue, waiter_callback_fn callback,
-			    void *context);
+bool vdo_waitq_notify_next_waiter(struct vdo_wait_queue *waitq,
+				  vdo_waiter_callback_fn callback, void *context);
 
-void vdo_transfer_all_waiters(struct wait_queue *from_queue,
-			      struct wait_queue *to_queue);
+void vdo_waitq_transfer_all_waiters(struct vdo_wait_queue *from_waitq,
+				    struct vdo_wait_queue *to_waitq);
 
-struct waiter *vdo_get_first_waiter(const struct wait_queue *queue);
+struct vdo_waiter *vdo_waitq_get_first_waiter(const struct vdo_wait_queue *waitq);
 
-void vdo_dequeue_matching_waiters(struct wait_queue *queue, waiter_match_fn match_method,
-				  void *match_context, struct wait_queue *matched_queue);
+void vdo_waitq_dequeue_matching_waiters(struct vdo_wait_queue *waitq,
+					vdo_waiter_match_fn waiter_match,
+					void *match_context,
+					struct vdo_wait_queue *matched_waitq);
 
-struct waiter *vdo_dequeue_next_waiter(struct wait_queue *queue);
+struct vdo_waiter *vdo_waitq_dequeue_next_waiter(struct vdo_wait_queue *waitq);
 
 /**
- * count_waiters() - Count the number of waiters in a wait queue.
- * @queue: The wait queue to query.
+ * vdo_waitq_num_waiters() - Return the number of waiters in a vdo_wait_queue.
+ * @waitq: The vdo_wait_queue to query.
  *
- * Return: The number of waiters in the queue.
+ * Return: The number of waiters in the waitq.
  */
-static inline size_t __must_check vdo_count_waiters(const struct wait_queue *queue)
+static inline size_t __must_check vdo_waitq_num_waiters(const struct vdo_wait_queue *waitq)
 {
-	return queue->queue_length;
+	return waitq->length;
 }
 
-const struct waiter * __must_check vdo_get_next_waiter(const struct wait_queue *queue,
-						       const struct waiter *waiter);
+const struct vdo_waiter * __must_check
+vdo_waitq_get_next_waiter(const struct vdo_wait_queue *waitq, const struct vdo_waiter *waiter);
 
 #endif /* VDO_WAIT_QUEUE_H */
-- 
2.42.0

