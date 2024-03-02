Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440667490
	for <dm-devel@lists.linux.dev>; Sat,  2 Mar 2024 02:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709348340; cv=none; b=o5QgyfMZLlrRSelJmmsWCcYah6B6UC0lGMFTOW/siGTpvBm5K/qqii4uJwhbRhPjK/zXeKKeUvqYSNB3nznBI1UO3tAvR0V4WiNZbEk7zBwfBQAZwvlUku/kQKxLQ8n9mguhFAXLq/yIF0k9102JmHnU8kDyHo/LdKFW95RA0Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709348340; c=relaxed/simple;
	bh=fDWYtjWKR4G2MRzo8Ij7A+zAK6IYJw3OB5+MZnXgTpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FLjxf0sfdqLYQ1JaqyK6Izh5DKYgJZGu5lpXuAjLsfjiG4t3YPYRdbUvK3+6qxhzcnrRn/hmZFwPZcQ4rl7W7+VN1hu1sjjBJvwEjv9EuApjxNSDUiGZJhB6FUZlpJfqSzvXGmD+0vGe3G8WrKnFAfglfbCKj9w58ZBZAgKXZsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fV09gSj1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fV09gSj1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709348337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ek4uUCiYIxaXwklZvB9JsrGq+L9i6TErZYf/t2BDr18=;
	b=fV09gSj1Rxe1xXFmuq3dienplBvZr23sR0SykT3vFPY6ncdoYaRofnGeeHkLHXfia+J1di
	pfhD1w7/LH7Geux7rH7S+skDaPtPxRUG8RYyolM4DN1o048xtEJh3uJxItdbHQQ/4Or/ei
	GLD8NkX+RdrdhT9qMP3lxOLYl/T61h8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-362-S_ZVeC1YP6aUUd0XHvELxQ-1; Fri,
 01 Mar 2024 21:58:55 -0500
X-MC-Unique: S_ZVeC1YP6aUUd0XHvELxQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7811638060EB;
	Sat,  2 Mar 2024 02:58:55 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6BC11200AE6F;
	Sat,  2 Mar 2024 02:58:55 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 647FFA1C07; Fri,  1 Mar 2024 21:58:55 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 1/3] dm vdo funnel-queue: change from uds_ to vdo_ namespace
Date: Fri,  1 Mar 2024 21:58:53 -0500
Message-ID: <2f9baef1292c127ace4dfaf228ff05f96703d253.1709348197.git.msakai@redhat.com>
In-Reply-To: <cover.1709348197.git.msakai@redhat.com>
References: <cover.1709348197.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Also return VDO_SUCCESS from vdo_make_funnel_queue.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Chung Chung <cchung@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/data-vio.c                  | 12 ++++-----
 drivers/md/dm-vdo/dedupe.c                    | 10 +++----
 drivers/md/dm-vdo/funnel-queue.c              | 18 ++++++-------
 drivers/md/dm-vdo/funnel-queue.h              | 26 +++++++++----------
 drivers/md/dm-vdo/funnel-workqueue.c          | 10 +++----
 .../md/dm-vdo/indexer/funnel-requestqueue.c   | 22 ++++++++--------
 6 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/drivers/md/dm-vdo/data-vio.c b/drivers/md/dm-vdo/data-vio.c
index 51c49fad1b8b..2b0d42c77e05 100644
--- a/drivers/md/dm-vdo/data-vio.c
+++ b/drivers/md/dm-vdo/data-vio.c
@@ -718,7 +718,7 @@ static void process_release_callback(struct vdo_completion *completion)
 
 	for (processed = 0; processed < DATA_VIO_RELEASE_BATCH_SIZE; processed++) {
 		struct data_vio *data_vio;
-		struct funnel_queue_entry *entry = uds_funnel_queue_poll(pool->queue);
+		struct funnel_queue_entry *entry = vdo_funnel_queue_poll(pool->queue);
 
 		if (entry == NULL)
 			break;
@@ -748,7 +748,7 @@ static void process_release_callback(struct vdo_completion *completion)
 	/* Pairs with the barrier in schedule_releases(). */
 	smp_mb();
 
-	reschedule = !uds_is_funnel_queue_empty(pool->queue);
+	reschedule = !vdo_is_funnel_queue_empty(pool->queue);
 	drained = (!reschedule &&
 		   vdo_is_state_draining(&pool->state) &&
 		   check_for_drain_complete_locked(pool));
@@ -865,8 +865,8 @@ int make_data_vio_pool(struct vdo *vdo, data_vio_count_t pool_size,
 			       process_release_callback, vdo->thread_config.cpu_thread,
 			       NULL);
 
-	result = uds_make_funnel_queue(&pool->queue);
-	if (result != UDS_SUCCESS) {
+	result = vdo_make_funnel_queue(&pool->queue);
+	if (result != VDO_SUCCESS) {
 		free_data_vio_pool(vdo_forget(pool));
 		return result;
 	}
@@ -924,7 +924,7 @@ void free_data_vio_pool(struct data_vio_pool *pool)
 		destroy_data_vio(data_vio);
 	}
 
-	uds_free_funnel_queue(vdo_forget(pool->queue));
+	vdo_free_funnel_queue(vdo_forget(pool->queue));
 	vdo_free(pool);
 }
 
@@ -1283,7 +1283,7 @@ static void finish_cleanup(struct data_vio *data_vio)
 	    (completion->result != VDO_SUCCESS)) {
 		struct data_vio_pool *pool = completion->vdo->data_vio_pool;
 
-		uds_funnel_queue_put(pool->queue, &completion->work_queue_entry_link);
+		vdo_funnel_queue_put(pool->queue, &completion->work_queue_entry_link);
 		schedule_releases(pool);
 		return;
 	}
diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index 8550a9a7958b..c031ab01054d 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -2246,7 +2246,7 @@ static void finish_index_operation(struct uds_request *request)
 				    atomic_read(&context->state));
 	}
 
-	uds_funnel_queue_put(context->zone->timed_out_complete, &context->queue_entry);
+	vdo_funnel_queue_put(context->zone->timed_out_complete, &context->queue_entry);
 }
 
 /**
@@ -2275,7 +2275,7 @@ static void check_for_drain_complete(struct hash_zone *zone)
 		struct dedupe_context *context;
 		struct funnel_queue_entry *entry;
 
-		entry = uds_funnel_queue_poll(zone->timed_out_complete);
+		entry = vdo_funnel_queue_poll(zone->timed_out_complete);
 		if (entry == NULL)
 			break;
 
@@ -2373,7 +2373,7 @@ static int __must_check initialize_zone(struct vdo *vdo, struct hash_zones *zone
 
 	INIT_LIST_HEAD(&zone->available);
 	INIT_LIST_HEAD(&zone->pending);
-	result = uds_make_funnel_queue(&zone->timed_out_complete);
+	result = vdo_make_funnel_queue(&zone->timed_out_complete);
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -2475,7 +2475,7 @@ void vdo_free_hash_zones(struct hash_zones *zones)
 	for (i = 0; i < zones->zone_count; i++) {
 		struct hash_zone *zone = &zones->zones[i];
 
-		uds_free_funnel_queue(vdo_forget(zone->timed_out_complete));
+		vdo_free_funnel_queue(vdo_forget(zone->timed_out_complete));
 		vdo_int_map_free(vdo_forget(zone->hash_lock_map));
 		vdo_free(vdo_forget(zone->lock_array));
 	}
@@ -2875,7 +2875,7 @@ static struct dedupe_context * __must_check acquire_context(struct hash_zone *zo
 		return context;
 	}
 
-	entry = uds_funnel_queue_poll(zone->timed_out_complete);
+	entry = vdo_funnel_queue_poll(zone->timed_out_complete);
 	return ((entry == NULL) ?
 		NULL : container_of(entry, struct dedupe_context, queue_entry));
 }
diff --git a/drivers/md/dm-vdo/funnel-queue.c b/drivers/md/dm-vdo/funnel-queue.c
index ce0e801fd955..a63b2f2bfd7d 100644
--- a/drivers/md/dm-vdo/funnel-queue.c
+++ b/drivers/md/dm-vdo/funnel-queue.c
@@ -9,7 +9,7 @@
 #include "memory-alloc.h"
 #include "permassert.h"
 
-int uds_make_funnel_queue(struct funnel_queue **queue_ptr)
+int vdo_make_funnel_queue(struct funnel_queue **queue_ptr)
 {
 	int result;
 	struct funnel_queue *queue;
@@ -27,10 +27,10 @@ int uds_make_funnel_queue(struct funnel_queue **queue_ptr)
 	queue->oldest = &queue->stub;
 
 	*queue_ptr = queue;
-	return UDS_SUCCESS;
+	return VDO_SUCCESS;
 }
 
-void uds_free_funnel_queue(struct funnel_queue *queue)
+void vdo_free_funnel_queue(struct funnel_queue *queue)
 {
 	vdo_free(queue);
 }
@@ -40,7 +40,7 @@ static struct funnel_queue_entry *get_oldest(struct funnel_queue *queue)
 	/*
 	 * Barrier requirements: We need a read barrier between reading a "next" field pointer
 	 * value and reading anything it points to. There's an accompanying barrier in
-	 * uds_funnel_queue_put() between its caller setting up the entry and making it visible.
+	 * vdo_funnel_queue_put() between its caller setting up the entry and making it visible.
 	 */
 	struct funnel_queue_entry *oldest = queue->oldest;
 	struct funnel_queue_entry *next = READ_ONCE(oldest->next);
@@ -80,7 +80,7 @@ static struct funnel_queue_entry *get_oldest(struct funnel_queue *queue)
 		 * Put the stub entry back on the queue, ensuring a successor will eventually be
 		 * seen.
 		 */
-		uds_funnel_queue_put(queue, &queue->stub);
+		vdo_funnel_queue_put(queue, &queue->stub);
 
 		/* Check again for a successor. */
 		next = READ_ONCE(oldest->next);
@@ -100,7 +100,7 @@ static struct funnel_queue_entry *get_oldest(struct funnel_queue *queue)
  * Poll a queue, removing the oldest entry if the queue is not empty. This function must only be
  * called from a single consumer thread.
  */
-struct funnel_queue_entry *uds_funnel_queue_poll(struct funnel_queue *queue)
+struct funnel_queue_entry *vdo_funnel_queue_poll(struct funnel_queue *queue)
 {
 	struct funnel_queue_entry *oldest = get_oldest(queue);
 
@@ -134,7 +134,7 @@ struct funnel_queue_entry *uds_funnel_queue_poll(struct funnel_queue *queue)
  * or more entries being added such that the list view is incomplete, this function will report the
  * queue as empty.
  */
-bool uds_is_funnel_queue_empty(struct funnel_queue *queue)
+bool vdo_is_funnel_queue_empty(struct funnel_queue *queue)
 {
 	return get_oldest(queue) == NULL;
 }
@@ -143,9 +143,9 @@ bool uds_is_funnel_queue_empty(struct funnel_queue *queue)
  * Check whether the funnel queue is idle or not. If the queue has entries available to be
  * retrieved, it is not idle. If the queue is in a transition state with one or more entries being
  * added such that the list view is incomplete, it may not be possible to retrieve an entry with
- * the uds_funnel_queue_poll() function, but the queue will not be considered idle.
+ * the vdo_funnel_queue_poll() function, but the queue will not be considered idle.
  */
-bool uds_is_funnel_queue_idle(struct funnel_queue *queue)
+bool vdo_is_funnel_queue_idle(struct funnel_queue *queue)
 {
 	/*
 	 * Oldest is not the stub, so there's another entry, though if next is NULL we can't
diff --git a/drivers/md/dm-vdo/funnel-queue.h b/drivers/md/dm-vdo/funnel-queue.h
index 88a30c593fdc..bde0f1deff98 100644
--- a/drivers/md/dm-vdo/funnel-queue.h
+++ b/drivers/md/dm-vdo/funnel-queue.h
@@ -3,8 +3,8 @@
  * Copyright 2023 Red Hat
  */
 
-#ifndef UDS_FUNNEL_QUEUE_H
-#define UDS_FUNNEL_QUEUE_H
+#ifndef VDO_FUNNEL_QUEUE_H
+#define VDO_FUNNEL_QUEUE_H
 
 #include <linux/atomic.h>
 #include <linux/cache.h>
@@ -25,19 +25,19 @@
  * the queue entries, and pointers to those structures are used exclusively by the queue. No macros
  * are defined to template the queue, so the offset of the funnel_queue_entry in the records placed
  * in the queue must all be the same so the client can derive their structure pointer from the
- * entry pointer returned by uds_funnel_queue_poll().
+ * entry pointer returned by vdo_funnel_queue_poll().
  *
  * Callers are wholly responsible for allocating and freeing the entries. Entries may be freed as
  * soon as they are returned since this queue is not susceptible to the "ABA problem" present in
  * many lock-free data structures. The queue is dynamically allocated to ensure cache-line
  * alignment, but no other dynamic allocation is used.
  *
- * The algorithm is not actually 100% lock-free. There is a single point in uds_funnel_queue_put()
+ * The algorithm is not actually 100% lock-free. There is a single point in vdo_funnel_queue_put()
  * at which a preempted producer will prevent the consumers from seeing items added to the queue by
  * later producers, and only if the queue is short enough or the consumer fast enough for it to
  * reach what was the end of the queue at the time of the preemption.
  *
- * The consumer function, uds_funnel_queue_poll(), will return NULL when the queue is empty. To
+ * The consumer function, vdo_funnel_queue_poll(), will return NULL when the queue is empty. To
  * wait for data to consume, spin (if safe) or combine the queue with a struct event_count to
  * signal the presence of new entries.
  */
@@ -51,7 +51,7 @@ struct funnel_queue_entry {
 /*
  * The dynamically allocated queue structure, which is allocated on a cache line boundary so the
  * producer and consumer fields in the structure will land on separate cache lines. This should be
- * consider opaque but it is exposed here so uds_funnel_queue_put() can be inlined.
+ * consider opaque but it is exposed here so vdo_funnel_queue_put() can be inlined.
  */
 struct __aligned(L1_CACHE_BYTES) funnel_queue {
 	/*
@@ -67,9 +67,9 @@ struct __aligned(L1_CACHE_BYTES) funnel_queue {
 	struct funnel_queue_entry stub;
 };
 
-int __must_check uds_make_funnel_queue(struct funnel_queue **queue_ptr);
+int __must_check vdo_make_funnel_queue(struct funnel_queue **queue_ptr);
 
-void uds_free_funnel_queue(struct funnel_queue *queue);
+void vdo_free_funnel_queue(struct funnel_queue *queue);
 
 /*
  * Put an entry on the end of the queue.
@@ -79,7 +79,7 @@ void uds_free_funnel_queue(struct funnel_queue *queue);
  * from the pointer that passed in here, so every entry in the queue must have the struct
  * funnel_queue_entry at the same offset within the client's structure.
  */
-static inline void uds_funnel_queue_put(struct funnel_queue *queue,
+static inline void vdo_funnel_queue_put(struct funnel_queue *queue,
 					struct funnel_queue_entry *entry)
 {
 	struct funnel_queue_entry *previous;
@@ -101,10 +101,10 @@ static inline void uds_funnel_queue_put(struct funnel_queue *queue,
 	WRITE_ONCE(previous->next, entry);
 }
 
-struct funnel_queue_entry *__must_check uds_funnel_queue_poll(struct funnel_queue *queue);
+struct funnel_queue_entry *__must_check vdo_funnel_queue_poll(struct funnel_queue *queue);
 
-bool __must_check uds_is_funnel_queue_empty(struct funnel_queue *queue);
+bool __must_check vdo_is_funnel_queue_empty(struct funnel_queue *queue);
 
-bool __must_check uds_is_funnel_queue_idle(struct funnel_queue *queue);
+bool __must_check vdo_is_funnel_queue_idle(struct funnel_queue *queue);
 
-#endif /* UDS_FUNNEL_QUEUE_H */
+#endif /* VDO_FUNNEL_QUEUE_H */
diff --git a/drivers/md/dm-vdo/funnel-workqueue.c b/drivers/md/dm-vdo/funnel-workqueue.c
index 03296e7fec12..cf04cdef0750 100644
--- a/drivers/md/dm-vdo/funnel-workqueue.c
+++ b/drivers/md/dm-vdo/funnel-workqueue.c
@@ -98,7 +98,7 @@ static struct vdo_completion *poll_for_completion(struct simple_work_queue *queu
 	int i;
 
 	for (i = queue->common.type->max_priority; i >= 0; i--) {
-		struct funnel_queue_entry *link = uds_funnel_queue_poll(queue->priority_lists[i]);
+		struct funnel_queue_entry *link = vdo_funnel_queue_poll(queue->priority_lists[i]);
 
 		if (link != NULL)
 			return container_of(link, struct vdo_completion, work_queue_entry_link);
@@ -123,7 +123,7 @@ static void enqueue_work_queue_completion(struct simple_work_queue *queue,
 	completion->my_queue = &queue->common;
 
 	/* Funnel queue handles the synchronization for the put. */
-	uds_funnel_queue_put(queue->priority_lists[completion->priority],
+	vdo_funnel_queue_put(queue->priority_lists[completion->priority],
 			     &completion->work_queue_entry_link);
 
 	/*
@@ -275,7 +275,7 @@ static void free_simple_work_queue(struct simple_work_queue *queue)
 	unsigned int i;
 
 	for (i = 0; i <= VDO_WORK_Q_MAX_PRIORITY; i++)
-		uds_free_funnel_queue(queue->priority_lists[i]);
+		vdo_free_funnel_queue(queue->priority_lists[i]);
 	vdo_free(queue->common.name);
 	vdo_free(queue);
 }
@@ -340,8 +340,8 @@ static int make_simple_work_queue(const char *thread_name_prefix, const char *na
 	}
 
 	for (i = 0; i <= type->max_priority; i++) {
-		result = uds_make_funnel_queue(&queue->priority_lists[i]);
-		if (result != UDS_SUCCESS) {
+		result = vdo_make_funnel_queue(&queue->priority_lists[i]);
+		if (result != VDO_SUCCESS) {
 			free_simple_work_queue(queue);
 			return result;
 		}
diff --git a/drivers/md/dm-vdo/indexer/funnel-requestqueue.c b/drivers/md/dm-vdo/indexer/funnel-requestqueue.c
index 84c7c1ae1333..1a5735375ddc 100644
--- a/drivers/md/dm-vdo/indexer/funnel-requestqueue.c
+++ b/drivers/md/dm-vdo/indexer/funnel-requestqueue.c
@@ -69,11 +69,11 @@ static inline struct uds_request *poll_queues(struct uds_request_queue *queue)
 {
 	struct funnel_queue_entry *entry;
 
-	entry = uds_funnel_queue_poll(queue->retry_queue);
+	entry = vdo_funnel_queue_poll(queue->retry_queue);
 	if (entry != NULL)
 		return container_of(entry, struct uds_request, queue_link);
 
-	entry = uds_funnel_queue_poll(queue->main_queue);
+	entry = vdo_funnel_queue_poll(queue->main_queue);
 	if (entry != NULL)
 		return container_of(entry, struct uds_request, queue_link);
 
@@ -82,8 +82,8 @@ static inline struct uds_request *poll_queues(struct uds_request_queue *queue)
 
 static inline bool are_queues_idle(struct uds_request_queue *queue)
 {
-	return uds_is_funnel_queue_idle(queue->retry_queue) &&
-	       uds_is_funnel_queue_idle(queue->main_queue);
+	return vdo_is_funnel_queue_idle(queue->retry_queue) &&
+	       vdo_is_funnel_queue_idle(queue->main_queue);
 }
 
 /*
@@ -207,14 +207,14 @@ int uds_make_request_queue(const char *queue_name,
 	atomic_set(&queue->dormant, false);
 	init_waitqueue_head(&queue->wait_head);
 
-	result = uds_make_funnel_queue(&queue->main_queue);
-	if (result != UDS_SUCCESS) {
+	result = vdo_make_funnel_queue(&queue->main_queue);
+	if (result != VDO_SUCCESS) {
 		uds_request_queue_finish(queue);
 		return result;
 	}
 
-	result = uds_make_funnel_queue(&queue->retry_queue);
-	if (result != UDS_SUCCESS) {
+	result = vdo_make_funnel_queue(&queue->retry_queue);
+	if (result != VDO_SUCCESS) {
 		uds_request_queue_finish(queue);
 		return result;
 	}
@@ -244,7 +244,7 @@ void uds_request_queue_enqueue(struct uds_request_queue *queue,
 	bool unbatched = request->unbatched;
 
 	sub_queue = request->requeued ? queue->retry_queue : queue->main_queue;
-	uds_funnel_queue_put(sub_queue, &request->queue_link);
+	vdo_funnel_queue_put(sub_queue, &request->queue_link);
 
 	/*
 	 * We must wake the worker thread when it is dormant. A read fence isn't needed here since
@@ -273,7 +273,7 @@ void uds_request_queue_finish(struct uds_request_queue *queue)
 		vdo_join_threads(queue->thread);
 	}
 
-	uds_free_funnel_queue(queue->main_queue);
-	uds_free_funnel_queue(queue->retry_queue);
+	vdo_free_funnel_queue(queue->main_queue);
+	vdo_free_funnel_queue(queue->retry_queue);
 	vdo_free(queue);
 }
-- 
2.42.0

