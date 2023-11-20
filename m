Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098C03A286
	for <dm-devel@lists.linux.dev>; Mon, 20 Nov 2023 22:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NHa1VKFw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700519364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w69zkfIanJmrVCsHFX4Z/G31WQ/V9XE+rDoT/0mlwQA=;
	b=NHa1VKFwvy1m/2Rl58lS/9xgBT1UaYC1V1PjZ/lcEbz4fuMshK6wIoKMLwNZ+P02sc6vMr
	ejmEfPUu4qKI+YxS/VQF6EVrfl42hOPMHX5NLgNv+CkTN5N2jo/RNFE7lO52XdLsKH4Cd1
	HD+X93HK7v+IWUgTIsUtWdasjLLJziE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-439-GwgfANZMN9SUls4B3IgyuQ-1; Mon,
 20 Nov 2023 17:29:21 -0500
X-MC-Unique: GwgfANZMN9SUls4B3IgyuQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E37C299E749;
	Mon, 20 Nov 2023 22:29:21 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 298721C060AE;
	Mon, 20 Nov 2023 22:29:21 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 270A351CD2; Mon, 20 Nov 2023 17:29:21 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 5/5] dm vdo wait-queue: rename to vdo_waitq_dequeue_waiter
Date: Mon, 20 Nov 2023 17:29:20 -0500
Message-ID: <87627e7af9e4627c90cb220d4eb6a9061eaac17e.1700516271.git.msakai@redhat.com>
In-Reply-To: <cover.1700516271.git.msakai@redhat.com>
References: <cover.1700516271.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Rename vdo_waitq_dequeue_next_waiter to vdo_waitq_dequeue_waiter.  The
"next" aspect of returned waiter is implied. "next" also isn't
informative ("oldest" would be). Removing "next_" adds symmetry to
vdo_waitq_enqueue_waiter().

Also fix whitespace and comments from previous waitq commit.

Reviewed-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.c        |  7 +++----
 drivers/md/dm-vdo/data-vio.c         |  2 +-
 drivers/md/dm-vdo/dedupe.c           |  4 ++--
 drivers/md/dm-vdo/flush.c            |  4 ++--
 drivers/md/dm-vdo/recovery-journal.c |  2 +-
 drivers/md/dm-vdo/wait-queue.c       | 18 +++++++++---------
 drivers/md/dm-vdo/wait-queue.h       |  4 ++--
 7 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index 7f9c4bc05f02..c5cb9da5d33e 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -913,7 +913,7 @@ static void allocate_free_page(struct page_info *info)
 
 	/*
 	 * Remove all entries which match the page number in question and push them onto the page
-	 * info's wait queue.
+	 * info's waitq.
 	 */
 	vdo_waitq_dequeue_matching_waiters(&cache->free_waiters, completion_needs_page,
 					   &pbn, &info->waiting);
@@ -1593,9 +1593,8 @@ static void finish_page_write(struct vdo_completion *completion)
 		enqueue_page(page, zone);
 	} else if ((zone->flusher == NULL) && vdo_waitq_has_waiters(&zone->flush_waiters) &&
 		   attempt_increment(zone)) {
-		zone->flusher =
-			container_of(vdo_waitq_dequeue_next_waiter(&zone->flush_waiters),
-				     struct tree_page, waiter);
+		zone->flusher = container_of(vdo_waitq_dequeue_waiter(&zone->flush_waiters),
+					     struct tree_page, waiter);
 		write_page(zone->flusher, pooled);
 		return;
 	}
diff --git a/drivers/md/dm-vdo/data-vio.c b/drivers/md/dm-vdo/data-vio.c
index 821155ca3761..711396e7a77d 100644
--- a/drivers/md/dm-vdo/data-vio.c
+++ b/drivers/md/dm-vdo/data-vio.c
@@ -1191,7 +1191,7 @@ static void transfer_lock(struct data_vio *data_vio, struct lbn_lock *lock)
 
 	/* Another data_vio is waiting for the lock, transfer it in a single lock map operation. */
 	next_lock_holder =
-		vdo_waiter_as_data_vio(vdo_waitq_dequeue_next_waiter(&lock->waiters));
+		vdo_waiter_as_data_vio(vdo_waitq_dequeue_waiter(&lock->waiters));
 
 	/* Transfer the remaining lock waiters to the next lock holder. */
 	vdo_waitq_transfer_all_waiters(&lock->waiters,
diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index 02e36896ca3c..f882d56581dc 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -413,14 +413,14 @@ static void set_duplicate_lock(struct hash_lock *hash_lock, struct pbn_lock *pbn
 }
 
 /**
- * dequeue_lock_waiter() - Remove the first data_vio from the lock's wait queue and return it.
+ * dequeue_lock_waiter() - Remove the first data_vio from the lock's waitq and return it.
  * @lock: The lock containing the wait queue.
  *
  * Return: The first (oldest) waiter in the queue, or NULL if the queue is empty.
  */
 static inline struct data_vio *dequeue_lock_waiter(struct hash_lock *lock)
 {
-	return vdo_waiter_as_data_vio(vdo_waitq_dequeue_next_waiter(&lock->waiters));
+	return vdo_waiter_as_data_vio(vdo_waitq_dequeue_waiter(&lock->waiters));
 }
 
 /**
diff --git a/drivers/md/dm-vdo/flush.c b/drivers/md/dm-vdo/flush.c
index e7195c677773..a6eeb425d721 100644
--- a/drivers/md/dm-vdo/flush.c
+++ b/drivers/md/dm-vdo/flush.c
@@ -196,7 +196,7 @@ static void finish_notification(struct vdo_completion *completion)
 	assert_on_flusher_thread(flusher, __func__);
 
 	vdo_waitq_enqueue_waiter(&flusher->pending_flushes,
-				 vdo_waitq_dequeue_next_waiter(&flusher->notifiers));
+				 vdo_waitq_dequeue_waiter(&flusher->notifiers));
 	vdo_complete_flushes(flusher);
 	if (vdo_waitq_has_waiters(&flusher->notifiers))
 		notify_flush(flusher);
@@ -335,7 +335,7 @@ void vdo_complete_flushes(struct flusher *flusher)
 				"acknowledged next expected flush, %llu, was: %llu",
 				(unsigned long long) flusher->first_unacknowledged_generation,
 				(unsigned long long) flush->flush_generation);
-		vdo_waitq_dequeue_next_waiter(&flusher->pending_flushes);
+		vdo_waitq_dequeue_waiter(&flusher->pending_flushes);
 		vdo_complete_flush(flush);
 		flusher->first_unacknowledged_generation++;
 	}
diff --git a/drivers/md/dm-vdo/recovery-journal.c b/drivers/md/dm-vdo/recovery-journal.c
index 5126e670e97e..a6981e5dd017 100644
--- a/drivers/md/dm-vdo/recovery-journal.c
+++ b/drivers/md/dm-vdo/recovery-journal.c
@@ -1332,7 +1332,7 @@ static void add_queued_recovery_entries(struct recovery_journal_block *block)
 {
 	while (vdo_waitq_has_waiters(&block->entry_waiters)) {
 		struct data_vio *data_vio =
-			vdo_waiter_as_data_vio(vdo_waitq_dequeue_next_waiter(&block->entry_waiters));
+			vdo_waiter_as_data_vio(vdo_waitq_dequeue_waiter(&block->entry_waiters));
 		struct tree_lock *lock = &data_vio->tree_lock;
 		struct packed_recovery_journal_entry *packed_entry;
 		struct recovery_journal_entry new_entry;
diff --git a/drivers/md/dm-vdo/wait-queue.c b/drivers/md/dm-vdo/wait-queue.c
index 7e4cf9f03249..6e1e739277ef 100644
--- a/drivers/md/dm-vdo/wait-queue.c
+++ b/drivers/md/dm-vdo/wait-queue.c
@@ -135,7 +135,7 @@ void vdo_waitq_dequeue_matching_waiters(struct vdo_wait_queue *waitq,
 	vdo_waitq_transfer_all_waiters(waitq, &iteration_waitq);
 
 	while (vdo_waitq_has_waiters(&iteration_waitq)) {
-		struct vdo_waiter *waiter = vdo_waitq_dequeue_next_waiter(&iteration_waitq);
+		struct vdo_waiter *waiter = vdo_waitq_dequeue_waiter(&iteration_waitq);
 
 		vdo_waitq_enqueue_waiter((waiter_match(waiter, match_context) ?
 					  matched_waitq : waitq), waiter);
@@ -143,15 +143,15 @@ void vdo_waitq_dequeue_matching_waiters(struct vdo_wait_queue *waitq,
 }
 
 /**
- * vdo_waitq_dequeue_next_waiter() - Remove the first waiter from the head end of a waitq.
+ * vdo_waitq_dequeue_waiter() - Remove the first (oldest) waiter from a waitq.
  * @waitq: The vdo_wait_queue from which to remove the first entry.
  *
- * The caller will be responsible for waking the waiter by invoking the correct callback function
- * to resume its execution.
+ * The caller will be responsible for waking the waiter by continuing its
+ * execution appropriately.
  *
  * Return: The first (oldest) waiter in the waitq, or NULL if the waitq is empty.
  */
-struct vdo_waiter *vdo_waitq_dequeue_next_waiter(struct vdo_wait_queue *waitq)
+struct vdo_waiter *vdo_waitq_dequeue_waiter(struct vdo_wait_queue *waitq)
 {
 	struct vdo_waiter *first_waiter = vdo_waitq_get_first_waiter(waitq);
 	struct vdo_waiter *last_waiter = waitq->last_waiter;
@@ -160,12 +160,12 @@ struct vdo_waiter *vdo_waitq_dequeue_next_waiter(struct vdo_wait_queue *waitq)
 		return NULL;
 
 	if (first_waiter == last_waiter) {
-		/* The waitq has a single entry, so just empty it out by nulling the tail. */
+		/* The waitq has a single entry, so empty it by nulling the tail. */
 		waitq->last_waiter = NULL;
 	} else {
 		/*
-		 * The waitq has more than one entry, so splice the first waiter out of the
-		 * circular waitq.
+		 * The waitq has multiple waiters, so splice the first waiter out
+		 * of the circular waitq.
 		 */
 		last_waiter->next_waiter = first_waiter->next_waiter;
 	}
@@ -192,7 +192,7 @@ struct vdo_waiter *vdo_waitq_dequeue_next_waiter(struct vdo_wait_queue *waitq)
 bool vdo_waitq_notify_next_waiter(struct vdo_wait_queue *waitq,
 				  vdo_waiter_callback_fn callback, void *context)
 {
-	struct vdo_waiter *waiter = vdo_waitq_dequeue_next_waiter(waitq);
+	struct vdo_waiter *waiter = vdo_waitq_dequeue_waiter(waitq);
 
 	if (waiter == NULL)
 		return false;
diff --git a/drivers/md/dm-vdo/wait-queue.h b/drivers/md/dm-vdo/wait-queue.h
index e514bdcf7d32..7e8ee6afe7c7 100644
--- a/drivers/md/dm-vdo/wait-queue.h
+++ b/drivers/md/dm-vdo/wait-queue.h
@@ -106,6 +106,8 @@ static inline bool __must_check vdo_waitq_has_waiters(const struct vdo_wait_queu
 void vdo_waitq_enqueue_waiter(struct vdo_wait_queue *waitq,
 			      struct vdo_waiter *waiter);
 
+struct vdo_waiter *vdo_waitq_dequeue_waiter(struct vdo_wait_queue *waitq);
+
 void vdo_waitq_notify_all_waiters(struct vdo_wait_queue *waitq,
 				  vdo_waiter_callback_fn callback, void *context);
 
@@ -122,8 +124,6 @@ void vdo_waitq_dequeue_matching_waiters(struct vdo_wait_queue *waitq,
 					void *match_context,
 					struct vdo_wait_queue *matched_waitq);
 
-struct vdo_waiter *vdo_waitq_dequeue_next_waiter(struct vdo_wait_queue *waitq);
-
 /**
  * vdo_waitq_num_waiters() - Return the number of waiters in a vdo_wait_queue.
  * @waitq: The vdo_wait_queue to query.
-- 
2.42.0

