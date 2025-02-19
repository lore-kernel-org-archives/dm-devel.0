Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9746E1B2193
	for <dm-devel@lists.linux.dev>; Wed, 19 Feb 2025 22:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740005747; cv=none; b=GWtC9z1chu1ueZSzfwuw3rhaLyTIghPBiMWZjSJ8b08IfJ0kHf1EdjLnNBm2Kn2KODK79oEmiN76iKcrOsN2bQRUOC9rPb5W5dGiSNNKHOZVhNdPNeKBsnAxmVQClwZiY1YJQ/LtFwuOgvdwusAM6x9t1S4jMvDvjGxuc7NRefs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740005747; c=relaxed/simple;
	bh=ZiU1qHLBLckYNtqguOkT2M23ZlO/CXOKUCIWzLiDAis=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=aX981rhAMqoGVghj/B09Lj8bfAsZe3xO5o3KN6ubP9f1/Yw//tW9p3ehWrnwY5/v+nQLRxdU/s9feKFQDPjQ676lNkC3Dx5ZgtcNi2LC88J4kdRvuQ4s1B8kRk0C4iPtmgH1H/tYs5Cpt1AzGMg6B7+iyErkzmrpa42mh685dDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fNdcyx0v; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fNdcyx0v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740005744;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rR48Z/dierVzBSUzYyXf4uLQbM6D+6VWLNUJFktP91U=;
	b=fNdcyx0vVVrzEXMYynm4tzT8nEWKYNkehBoDVXalIDAZZUCtFVLlYO7LkXhUrNNno/sfgx
	SaA9I6Kk+flojF7TwbT1+r7X0lDwWWbz7cEXzlzLPrli7dfE37utUgQ3FeKW4b+7PjC4hL
	hx0ZrF4ZDKsaxbNx390nLUeKzW9GGp8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-312-u-8QkBzfO-K5kTna0VvblA-1; Wed,
 19 Feb 2025 17:55:41 -0500
X-MC-Unique: u-8QkBzfO-K5kTna0VvblA-1
X-Mimecast-MFC-AGG-ID: u-8QkBzfO-K5kTna0VvblA_1740005740
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 01FC01975AFC;
	Wed, 19 Feb 2025 22:55:40 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C470319412A3;
	Wed, 19 Feb 2025 22:55:39 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 1222760392; Wed, 19 Feb 2025 17:55:39 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo: remove remaining ring references
Date: Wed, 19 Feb 2025 17:55:39 -0500
Message-ID: <20250219225539.1335924-1-msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1Oh9sBd4LuAatH2wLMxUK_I3xP-6QfjpCtiLPq_sauI_1740005740
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

Lists are the new rings, so update all remaining references to rings to
talk about lists.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.c        |  2 +-
 drivers/md/dm-vdo/dedupe.c           | 20 ++++++++++----------
 drivers/md/dm-vdo/packer.h           |  2 +-
 drivers/md/dm-vdo/priority-table.c   |  2 +-
 drivers/md/dm-vdo/recovery-journal.h |  6 +++---
 drivers/md/dm-vdo/slab-depot.c       | 10 +++++-----
 drivers/md/dm-vdo/wait-queue.c       |  2 +-
 7 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index 1f7cdd837ff9..baf683cabb1b 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -451,7 +451,7 @@ static struct page_info * __must_check find_page(struct vdo_page_cache *cache,
  * select_lru_page() - Determine which page is least recently used.
  *
  * Picks the least recently used from among the non-busy entries at the front of each of the lru
- * ring. Since whenever we mark a page busy we also put it to the end of the ring it is unlikely
+ * list. Since whenever we mark a page busy we also put it to the end of the list it is unlikely
  * that the entries at the front are busy unless the queue is very short, but not impossible.
  *
  * Return: A pointer to the info structure for a relevant page, or NULL if no such page can be
diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index b6f8e2dc7729..00fff21b8058 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -226,7 +226,7 @@ struct hash_lock {
 	 * A list containing the data VIOs sharing this lock, all having the same record name and
 	 * data block contents, linked by their hash_lock_node fields.
 	 */
-	struct list_head duplicate_ring;
+	struct list_head duplicate_vios;
 
 	/* The number of data_vios sharing this lock instance */
 	data_vio_count_t reference_count;
@@ -343,7 +343,7 @@ static void return_hash_lock_to_pool(struct hash_zone *zone, struct hash_lock *l
 {
 	memset(lock, 0, sizeof(*lock));
 	INIT_LIST_HEAD(&lock->pool_node);
-	INIT_LIST_HEAD(&lock->duplicate_ring);
+	INIT_LIST_HEAD(&lock->duplicate_vios);
 	vdo_waitq_init(&lock->waiters);
 	list_add_tail(&lock->pool_node, &zone->lock_pool);
 }
@@ -441,7 +441,7 @@ static void set_hash_lock(struct data_vio *data_vio, struct hash_lock *new_lock)
 		VDO_ASSERT_LOG_ONLY(data_vio->hash_zone != NULL,
 				    "must have a hash zone when holding a hash lock");
 		VDO_ASSERT_LOG_ONLY(!list_empty(&data_vio->hash_lock_entry),
-				    "must be on a hash lock ring when holding a hash lock");
+				    "must be on a hash lock list when holding a hash lock");
 		VDO_ASSERT_LOG_ONLY(old_lock->reference_count > 0,
 				    "hash lock reference must be counted");
 
@@ -464,10 +464,10 @@ static void set_hash_lock(struct data_vio *data_vio, struct hash_lock *new_lock)
 
 	if (new_lock != NULL) {
 		/*
-		 * Keep all data_vios sharing the lock on a ring since they can complete in any
+		 * Keep all data_vios sharing the lock on a list since they can complete in any
 		 * order and we'll always need a pointer to one to compare data.
 		 */
-		list_move_tail(&data_vio->hash_lock_entry, &new_lock->duplicate_ring);
+		list_move_tail(&data_vio->hash_lock_entry, &new_lock->duplicate_vios);
 		new_lock->reference_count += 1;
 		if (new_lock->max_references < new_lock->reference_count)
 			new_lock->max_references = new_lock->reference_count;
@@ -1789,10 +1789,10 @@ static bool is_hash_collision(struct hash_lock *lock, struct data_vio *candidate
 	struct hash_zone *zone;
 	bool collides;
 
-	if (list_empty(&lock->duplicate_ring))
+	if (list_empty(&lock->duplicate_vios))
 		return false;
 
-	lock_holder = list_first_entry(&lock->duplicate_ring, struct data_vio,
+	lock_holder = list_first_entry(&lock->duplicate_vios, struct data_vio,
 				       hash_lock_entry);
 	zone = candidate->hash_zone;
 	collides = !blocks_equal(lock_holder->vio.data, candidate->vio.data);
@@ -1815,7 +1815,7 @@ static inline int assert_hash_lock_preconditions(const struct data_vio *data_vio
 		return result;
 
 	result = VDO_ASSERT(list_empty(&data_vio->hash_lock_entry),
-			    "must not already be a member of a hash lock ring");
+			    "must not already be a member of a hash lock list");
 	if (result != VDO_SUCCESS)
 		return result;
 
@@ -1942,8 +1942,8 @@ void vdo_release_hash_lock(struct data_vio *data_vio)
 			    "returned hash lock must not be in use with state %s",
 			    get_hash_lock_state_name(lock->state));
 	VDO_ASSERT_LOG_ONLY(list_empty(&lock->pool_node),
-			    "hash lock returned to zone must not be in a pool ring");
-	VDO_ASSERT_LOG_ONLY(list_empty(&lock->duplicate_ring),
+			    "hash lock returned to zone must not be in a pool list");
+	VDO_ASSERT_LOG_ONLY(list_empty(&lock->duplicate_vios),
 			    "hash lock returned to zone must not reference DataVIOs");
 
 	return_hash_lock_to_pool(zone, lock);
diff --git a/drivers/md/dm-vdo/packer.h b/drivers/md/dm-vdo/packer.h
index 0f3be44710b5..8c8d6892582d 100644
--- a/drivers/md/dm-vdo/packer.h
+++ b/drivers/md/dm-vdo/packer.h
@@ -46,7 +46,7 @@ struct compressed_block {
 
 /*
  * Each packer_bin holds an incomplete batch of data_vios that only partially fill a compressed
- * block. The bins are kept in a ring sorted by the amount of unused space so the first bin with
+ * block. The bins are kept in a list sorted by the amount of unused space so the first bin with
  * enough space to hold a newly-compressed data_vio can easily be found. When the bin fills up or
  * is flushed, the first uncanceled data_vio in the bin is selected to be the agent for that bin.
  * Upon entering the packer, each data_vio already has its compressed data in the first slot of the
diff --git a/drivers/md/dm-vdo/priority-table.c b/drivers/md/dm-vdo/priority-table.c
index 42d3d8d0e4b5..9bae8256ba4e 100644
--- a/drivers/md/dm-vdo/priority-table.c
+++ b/drivers/md/dm-vdo/priority-table.c
@@ -199,7 +199,7 @@ void vdo_priority_table_remove(struct priority_table *table, struct list_head *e
 
 	/*
 	 * Remove the entry from the bucket list, remembering a pointer to another entry in the
-	 * ring.
+	 * list.
 	 */
 	next_entry = entry->next;
 	list_del_init(entry);
diff --git a/drivers/md/dm-vdo/recovery-journal.h b/drivers/md/dm-vdo/recovery-journal.h
index 899071173015..25e7ec6d19f6 100644
--- a/drivers/md/dm-vdo/recovery-journal.h
+++ b/drivers/md/dm-vdo/recovery-journal.h
@@ -43,9 +43,9 @@
  * has a vio which is used to commit that block to disk. The vio's data is the on-disk
  * representation of the journal block. In addition each in-memory block has a buffer which is used
  * to accumulate entries while a partial commit of the block is in progress. In-memory blocks are
- * kept on two rings. Free blocks live on the 'free_tail_blocks' ring. When a block becomes active
- * (see below) it is moved to the 'active_tail_blocks' ring. When a block is fully committed, it is
- * moved back to the 'free_tail_blocks' ring.
+ * kept on two lists. Free blocks live on the 'free_tail_blocks' list. When a block becomes active
+ * (see below) it is moved to the 'active_tail_blocks' list. When a block is fully committed, it is
+ * moved back to the 'free_tail_blocks' list.
  *
  * When entries are added to the journal, they are added to the active in-memory block, as
  * indicated by the 'active_block' field. If the caller wishes to wait for the entry to be
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 9da457c9cc42..823b78b9f5b5 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -139,7 +139,7 @@ static bool is_slab_journal_blank(const struct vdo_slab *slab)
 }
 
 /**
- * mark_slab_journal_dirty() - Put a slab journal on the dirty ring of its allocator in the correct
+ * mark_slab_journal_dirty() - Put a slab journal on the dirty list of its allocator in the correct
  *                             order.
  * @journal: The journal to be marked dirty.
  * @lock: The recovery journal lock held by the slab journal.
@@ -821,7 +821,7 @@ static void commit_tail(struct slab_journal *journal)
 
 	/*
 	 * Since we are about to commit the tail block, this journal no longer needs to be on the
-	 * ring of journals which the recovery journal might ask to commit.
+	 * list of journals which the recovery journal might ask to commit.
 	 */
 	mark_slab_journal_clean(journal);
 
@@ -1371,7 +1371,7 @@ static unsigned int calculate_slab_priority(struct vdo_slab *slab)
 static void prioritize_slab(struct vdo_slab *slab)
 {
 	VDO_ASSERT_LOG_ONLY(list_empty(&slab->allocq_entry),
-			    "a slab must not already be on a ring when prioritizing");
+			    "a slab must not already be on a list when prioritizing");
 	slab->priority = calculate_slab_priority(slab);
 	vdo_priority_table_enqueue(slab->allocator->prioritized_slabs,
 				   slab->priority, &slab->allocq_entry);
@@ -2562,7 +2562,7 @@ static void queue_slab(struct vdo_slab *slab)
 	int result;
 
 	VDO_ASSERT_LOG_ONLY(list_empty(&slab->allocq_entry),
-			"a requeued slab must not already be on a ring");
+			"a requeued slab must not already be on a list");
 
 	if (vdo_is_read_only(allocator->depot->vdo))
 		return;
@@ -3297,7 +3297,7 @@ int vdo_release_block_reference(struct block_allocator *allocator,
  * This is a min_heap callback function orders slab_status structures using the 'is_clean' field as
  * the primary key and the 'emptiness' field as the secondary key.
  *
- * Slabs need to be pushed onto the rings in the same order they are to be popped off. Popping
+ * Slabs need to be pushed onto the lists in the same order they are to be popped off. Popping
  * should always get the most empty first, so pushing should be from most empty to least empty.
  * Thus, the ordering is reversed from the usual sense since min_heap returns smaller elements
  * before larger ones.
diff --git a/drivers/md/dm-vdo/wait-queue.c b/drivers/md/dm-vdo/wait-queue.c
index 6e1e739277ef..f81ed0cee2bf 100644
--- a/drivers/md/dm-vdo/wait-queue.c
+++ b/drivers/md/dm-vdo/wait-queue.c
@@ -34,7 +34,7 @@ void vdo_waitq_enqueue_waiter(struct vdo_wait_queue *waitq, struct vdo_waiter *w
 		waitq->last_waiter->next_waiter = waiter;
 	}
 
-	/* In both cases, the waiter we added to the ring becomes the last waiter. */
+	/* In both cases, the waiter we added to the list becomes the last waiter. */
 	waitq->last_waiter = waiter;
 	waitq->length += 1;
 }
-- 
2.45.2

