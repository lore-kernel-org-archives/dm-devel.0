Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903ED2D0C8B;
	Sun, 11 Jan 2026 21:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768167547; cv=none; b=PY0iI76PwO7B9VCD/E8GaVvuxjydvlOeU8d3PGd7IRL5ed20XCNynUxZigif4kL7mnh9Y/9woE3TE31PK639zC5lx147/9Okg5mFS8pelRFWF5ICcDk/HgKrSOZdAcv2bGYEl/Zh8Yj/cD0/DprMEhiYnQ/na6i5+t0Gctbn/zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768167547; c=relaxed/simple;
	bh=Af8W62bv0jW+bAoYRq25YAcvSaktAJ/vliRDwFM+uF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1pkLMRVTHkYqQ/6rrYAhaq/syQu/dBcbZ/ptgr5gKbDqWy/g/OfZemvQF5T51/i14ycLlQPqV/FcTZL9Ga4RtwZyGz7oUwiw0Ku/KexCSeI1V/sbancIDlDWDgJwdp0bG0MWQhRkwZNZAbUJ6CckjDJH/T+qDP5bR1wuva8gdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t3mJ5Tqx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t3mJ5Tqx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1117DC4CEF7;
	Sun, 11 Jan 2026 21:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768167547;
	bh=Af8W62bv0jW+bAoYRq25YAcvSaktAJ/vliRDwFM+uF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t3mJ5TqxwFctbY4ftZwt30Etwdj+1P1yvEOYEK7JRqCAdtBP0y3lHJl0ZjRSR6ktI
	 WKkgvzhJWbh9PIggCq9VKaTPegvm8Lf/p7/NziWsR1tSHceWnq56iu98Q/PzCVsWwS
	 BKYN5iUJ9aTelomNjj7foBjybQu+9IM+nOHMX7OErvwzjBiDjOZAtx4iu7mQgtYXxv
	 My3cY5LVs5MBZwI8NaXDYosdtjNjLh5c5VXnbGPzeQzGt85DCpIMt2A2alFMNvLufO
	 /rfNDlo/h0mvdUWP4bkQ1U3b58A7VlyBI6PYHlpLz1QLkFG/f7kROdrKAd4e1qZa9e
	 A0FSg5GXwVHdQ==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/2] dm-bufio: avoid redundant buffer_tree lookups
Date: Sun, 11 Jan 2026 13:38:21 -0800
Message-ID: <20260111213821.94895-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260111213821.94895-1-ebiggers@kernel.org>
References: <20260111213821.94895-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm-bufio's map from block number to buffer is organized as a hash table
of red-black trees.  It does far more lookups in this hash table than
necessary: typically one lookup to lock the tree, one lookup to search
the tree, and one lookup to unlock the tree.  Only one of those lookups
is needed.  Optimize it to do only the minimum number of lookups.

This improves performance.   It also reduces the object code size,
considering that the redundant hash table lookups were being inlined.
For example, the size of the text section of dm-bufio.o decreases from
15599 to 15070 bytes with gcc 15 and x86_64, or from 20652 to 20244
bytes with clang 21 and arm64.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-bufio.c | 142 ++++++++++++++++++++++++++----------------
 1 file changed, 89 insertions(+), 53 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 6e61982c9b92..ae169f3091e3 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -399,40 +399,55 @@ static DEFINE_STATIC_KEY_FALSE(no_sleep_enabled);
 static inline unsigned int cache_index(sector_t block, unsigned int num_locks)
 {
 	return dm_hash_locks_index(block, num_locks);
 }
 
-static inline void cache_read_lock(struct dm_buffer_cache *bc, sector_t block)
+/* Get the buffer tree in the cache for the given block.  Doesn't lock it. */
+static inline struct buffer_tree *cache_get_tree(struct dm_buffer_cache *bc,
+						 sector_t block)
+{
+	return &bc->trees[cache_index(block, bc->num_locks)];
+}
+
+/* Lock the given buffer tree in the cache for reading. */
+static inline void cache_read_lock(struct dm_buffer_cache *bc,
+				   struct buffer_tree *tree)
 {
 	if (static_branch_unlikely(&no_sleep_enabled) && bc->no_sleep)
-		read_lock_bh(&bc->trees[cache_index(block, bc->num_locks)].u.spinlock);
+		read_lock_bh(&tree->u.spinlock);
 	else
-		down_read(&bc->trees[cache_index(block, bc->num_locks)].u.lock);
+		down_read(&tree->u.lock);
 }
 
-static inline void cache_read_unlock(struct dm_buffer_cache *bc, sector_t block)
+/* Unlock the given buffer tree in the cache for reading. */
+static inline void cache_read_unlock(struct dm_buffer_cache *bc,
+				     struct buffer_tree *tree)
 {
 	if (static_branch_unlikely(&no_sleep_enabled) && bc->no_sleep)
-		read_unlock_bh(&bc->trees[cache_index(block, bc->num_locks)].u.spinlock);
+		read_unlock_bh(&tree->u.spinlock);
 	else
-		up_read(&bc->trees[cache_index(block, bc->num_locks)].u.lock);
+		up_read(&tree->u.lock);
 }
 
-static inline void cache_write_lock(struct dm_buffer_cache *bc, sector_t block)
+/* Lock the given buffer tree in the cache for writing. */
+static inline void cache_write_lock(struct dm_buffer_cache *bc,
+				    struct buffer_tree *tree)
 {
 	if (static_branch_unlikely(&no_sleep_enabled) && bc->no_sleep)
-		write_lock_bh(&bc->trees[cache_index(block, bc->num_locks)].u.spinlock);
+		write_lock_bh(&tree->u.spinlock);
 	else
-		down_write(&bc->trees[cache_index(block, bc->num_locks)].u.lock);
+		down_write(&tree->u.lock);
 }
 
-static inline void cache_write_unlock(struct dm_buffer_cache *bc, sector_t block)
+/* Unlock the given buffer tree in the cache for writing. */
+static inline void cache_write_unlock(struct dm_buffer_cache *bc,
+				      struct buffer_tree *tree)
 {
 	if (static_branch_unlikely(&no_sleep_enabled) && bc->no_sleep)
-		write_unlock_bh(&bc->trees[cache_index(block, bc->num_locks)].u.spinlock);
+		write_unlock_bh(&tree->u.spinlock);
 	else
-		up_write(&bc->trees[cache_index(block, bc->num_locks)].u.lock);
+		up_write(&tree->u.lock);
 }
 
 /*
  * Sometimes we want to repeatedly get and drop locks as part of an iteration.
  * This struct helps avoid redundant drop and gets of the same lock.
@@ -600,21 +615,23 @@ static void __cache_inc_buffer(struct dm_buffer *b)
 {
 	atomic_inc(&b->hold_count);
 	WRITE_ONCE(b->last_accessed, jiffies);
 }
 
-static struct dm_buffer *cache_get(struct dm_buffer_cache *bc, sector_t block)
+static struct dm_buffer *cache_get(struct dm_buffer_cache *bc,
+				   struct buffer_tree *tree, sector_t block)
 {
 	struct dm_buffer *b;
 
-	cache_read_lock(bc, block);
-	b = __cache_get(&bc->trees[cache_index(block, bc->num_locks)].root, block);
+	/* Assuming tree == cache_get_tree(bc, block) */
+	cache_read_lock(bc, tree);
+	b = __cache_get(&tree->root, block);
 	if (b) {
 		lru_reference(&b->lru);
 		__cache_inc_buffer(b);
 	}
-	cache_read_unlock(bc, block);
+	cache_read_unlock(bc, tree);
 
 	return b;
 }
 
 /*--------------*/
@@ -661,11 +678,11 @@ static struct dm_buffer *__cache_evict(struct dm_buffer_cache *bc, int list_mode
 	if (!le)
 		return NULL;
 
 	b = le_to_buffer(le);
 	/* __evict_pred will have locked the appropriate tree. */
-	rb_erase(&b->node, &bc->trees[cache_index(b->block, bc->num_locks)].root);
+	rb_erase(&b->node, &cache_get_tree(bc, b->block)->root);
 
 	return b;
 }
 
 static struct dm_buffer *cache_evict(struct dm_buffer_cache *bc, int list_mode,
@@ -684,19 +701,21 @@ static struct dm_buffer *cache_evict(struct dm_buffer_cache *bc, int list_mode,
 /*--------------*/
 
 /*
  * Mark a buffer as clean or dirty. Not threadsafe.
  */
-static void cache_mark(struct dm_buffer_cache *bc, struct dm_buffer *b, int list_mode)
+static void cache_mark(struct dm_buffer_cache *bc, struct buffer_tree *tree,
+		       struct dm_buffer *b, int list_mode)
 {
-	cache_write_lock(bc, b->block);
+	/* Assuming tree == cache_get_tree(bc, b->block) */
+	cache_write_lock(bc, tree);
 	if (list_mode != b->list_mode) {
 		lru_remove(&bc->lru[b->list_mode], &b->lru);
 		b->list_mode = list_mode;
 		lru_insert(&bc->lru[b->list_mode], &b->lru);
 	}
-	cache_write_unlock(bc, b->block);
+	cache_write_unlock(bc, tree);
 }
 
 /*--------------*/
 
 /*
@@ -818,23 +837,25 @@ static bool __cache_insert(struct rb_root *root, struct dm_buffer *b)
 	rb_insert_color(&b->node, root);
 
 	return true;
 }
 
-static bool cache_insert(struct dm_buffer_cache *bc, struct dm_buffer *b)
+static bool cache_insert(struct dm_buffer_cache *bc, struct buffer_tree *tree,
+			 struct dm_buffer *b)
 {
 	bool r;
 
 	if (WARN_ON_ONCE(b->list_mode >= LIST_SIZE))
 		return false;
 
-	cache_write_lock(bc, b->block);
+	/* Assuming tree == cache_get_tree(bc, b->block) */
+	cache_write_lock(bc, tree);
 	BUG_ON(atomic_read(&b->hold_count) != 1);
-	r = __cache_insert(&bc->trees[cache_index(b->block, bc->num_locks)].root, b);
+	r = __cache_insert(&tree->root, b);
 	if (r)
 		lru_insert(&bc->lru[b->list_mode], &b->lru);
-	cache_write_unlock(bc, b->block);
+	cache_write_unlock(bc, tree);
 
 	return r;
 }
 
 /*--------------*/
@@ -843,25 +864,27 @@ static bool cache_insert(struct dm_buffer_cache *bc, struct dm_buffer *b)
  * Removes buffer from cache, ownership of the buffer passes back to the caller.
  * Fails if the hold_count is not one (ie. the caller holds the only reference).
  *
  * Not threadsafe.
  */
-static bool cache_remove(struct dm_buffer_cache *bc, struct dm_buffer *b)
+static bool cache_remove(struct dm_buffer_cache *bc, struct buffer_tree *tree,
+			 struct dm_buffer *b)
 {
 	bool r;
 
-	cache_write_lock(bc, b->block);
+	/* Assuming tree == cache_get_tree(bc, b->block) */
+	cache_write_lock(bc, tree);
 
 	if (atomic_read(&b->hold_count) != 1) {
 		r = false;
 	} else {
 		r = true;
-		rb_erase(&b->node, &bc->trees[cache_index(b->block, bc->num_locks)].root);
+		rb_erase(&b->node, &tree->root);
 		lru_remove(&bc->lru[b->list_mode], &b->lru);
 	}
 
-	cache_write_unlock(bc, b->block);
+	cache_write_unlock(bc, tree);
 
 	return r;
 }
 
 /*--------------*/
@@ -1723,18 +1746,20 @@ static void __check_watermark(struct dm_bufio_client *c,
  *--------------------------------------------------------------
  * Getting a buffer
  *--------------------------------------------------------------
  */
 
-static void cache_put_and_wake(struct dm_bufio_client *c, struct dm_buffer *b)
+static void cache_put_and_wake(struct dm_bufio_client *c,
+			       struct buffer_tree *tree, struct dm_buffer *b)
 {
 	bool wake;
 
-	cache_read_lock(&c->cache, b->block);
+	/* Assuming tree == cache_get_tree(&c->cache, b->block) */
+	cache_read_lock(&c->cache, tree);
 	BUG_ON(!atomic_read(&b->hold_count));
 	wake = atomic_dec_and_test(&b->hold_count);
-	cache_read_unlock(&c->cache, b->block);
+	cache_read_unlock(&c->cache, tree);
 
 	/*
 	 * Relying on waitqueue_active() is racey, but we sleep
 	 * with schedule_timeout anyway.
 	 */
@@ -1744,11 +1769,12 @@ static void cache_put_and_wake(struct dm_bufio_client *c, struct dm_buffer *b)
 
 /*
  * This assumes you have already checked the cache to see if the buffer
  * is already present (it will recheck after dropping the lock for allocation).
  */
-static struct dm_buffer *__bufio_new(struct dm_bufio_client *c, sector_t block,
+static struct dm_buffer *__bufio_new(struct dm_bufio_client *c,
+				     struct buffer_tree *tree, sector_t block,
 				     enum new_flag nf, int *need_submit,
 				     struct list_head *write_list)
 {
 	struct dm_buffer *b, *new_b = NULL;
 
@@ -1764,11 +1790,11 @@ static struct dm_buffer *__bufio_new(struct dm_bufio_client *c, sector_t block,
 
 	/*
 	 * We've had a period where the mutex was unlocked, so need to
 	 * recheck the buffer tree.
 	 */
-	b = cache_get(&c->cache, block);
+	b = cache_get(&c->cache, tree, block);
 	if (b) {
 		__free_buffer_wake(new_b);
 		goto found_buffer;
 	}
 
@@ -1792,17 +1818,17 @@ static struct dm_buffer *__bufio_new(struct dm_bufio_client *c, sector_t block,
 	/*
 	 * We mustn't insert into the cache until the B_READING state
 	 * is set.  Otherwise another thread could get it and use
 	 * it before it had been read.
 	 */
-	cache_insert(&c->cache, b);
+	cache_insert(&c->cache, tree, b);
 
 	return b;
 
 found_buffer:
 	if (nf == NF_PREFETCH) {
-		cache_put_and_wake(c, b);
+		cache_put_and_wake(c, tree, b);
 		return NULL;
 	}
 
 	/*
 	 * Note: it is essential that we don't wait for the buffer to be
@@ -1810,11 +1836,11 @@ static struct dm_buffer *__bufio_new(struct dm_bufio_client *c, sector_t block,
 	 * dm_bufio_prefetch can be used in the driver request routine.
 	 * If the user called both dm_bufio_prefetch and dm_bufio_get on
 	 * the same buffer, it would deadlock if we waited.
 	 */
 	if (nf == NF_GET && unlikely(test_bit_acquire(B_READING, &b->state))) {
-		cache_put_and_wake(c, b);
+		cache_put_and_wake(c, tree, b);
 		return NULL;
 	}
 
 	return b;
 }
@@ -1844,10 +1870,11 @@ static void read_endio(struct dm_buffer *b, blk_status_t status)
  */
 static void *new_read(struct dm_bufio_client *c, sector_t block,
 		      enum new_flag nf, struct dm_buffer **bp,
 		      unsigned short ioprio)
 {
+	struct buffer_tree *tree;
 	int need_submit = 0;
 	struct dm_buffer *b;
 
 	LIST_HEAD(write_list);
 
@@ -1855,14 +1882,15 @@ static void *new_read(struct dm_bufio_client *c, sector_t block,
 
 	/*
 	 * Fast path, hopefully the block is already in the cache.  No need
 	 * to get the client lock for this.
 	 */
-	b = cache_get(&c->cache, block);
+	tree = cache_get_tree(&c->cache, block);
+	b = cache_get(&c->cache, tree, block);
 	if (b) {
 		if (nf == NF_PREFETCH) {
-			cache_put_and_wake(c, b);
+			cache_put_and_wake(c, tree, b);
 			return NULL;
 		}
 
 		/*
 		 * Note: it is essential that we don't wait for the buffer to be
@@ -1870,21 +1898,21 @@ static void *new_read(struct dm_bufio_client *c, sector_t block,
 		 * dm_bufio_prefetch can be used in the driver request routine.
 		 * If the user called both dm_bufio_prefetch and dm_bufio_get on
 		 * the same buffer, it would deadlock if we waited.
 		 */
 		if (nf == NF_GET && unlikely(test_bit_acquire(B_READING, &b->state))) {
-			cache_put_and_wake(c, b);
+			cache_put_and_wake(c, tree, b);
 			return NULL;
 		}
 	}
 
 	if (!b) {
 		if (nf == NF_GET)
 			return NULL;
 
 		dm_bufio_lock(c);
-		b = __bufio_new(c, block, nf, &need_submit, &write_list);
+		b = __bufio_new(c, tree, block, nf, &need_submit, &write_list);
 		dm_bufio_unlock(c);
 	}
 
 #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
 	if (b && (atomic_read(&b->hold_count) == 1))
@@ -1967,22 +1995,24 @@ static void __dm_bufio_prefetch(struct dm_bufio_client *c,
 		return; /* should never happen */
 
 	blk_start_plug(&plug);
 
 	for (; n_blocks--; block++) {
-		int need_submit;
+		struct buffer_tree *tree;
 		struct dm_buffer *b;
+		int need_submit;
 
-		b = cache_get(&c->cache, block);
+		tree = cache_get_tree(&c->cache, block);
+		b = cache_get(&c->cache, tree, block);
 		if (b) {
 			/* already in cache */
-			cache_put_and_wake(c, b);
+			cache_put_and_wake(c, tree, b);
 			continue;
 		}
 
 		dm_bufio_lock(c);
-		b = __bufio_new(c, block, NF_PREFETCH, &need_submit,
+		b = __bufio_new(c, tree, block, NF_PREFETCH, &need_submit,
 				&write_list);
 		if (unlikely(!list_empty(&write_list))) {
 			dm_bufio_unlock(c);
 			blk_finish_plug(&plug);
 			__flush_write_list(&write_list);
@@ -2023,10 +2053,11 @@ void dm_bufio_prefetch_with_ioprio(struct dm_bufio_client *c, sector_t block,
 EXPORT_SYMBOL_GPL(dm_bufio_prefetch_with_ioprio);
 
 void dm_bufio_release(struct dm_buffer *b)
 {
 	struct dm_bufio_client *c = b->c;
+	struct buffer_tree *tree = cache_get_tree(&c->cache, b->block);
 
 	/*
 	 * If there were errors on the buffer, and the buffer is not
 	 * to be written, free the buffer. There is no point in caching
 	 * invalid buffer.
@@ -2036,20 +2067,20 @@ void dm_bufio_release(struct dm_buffer *b)
 	    !test_bit(B_WRITING, &b->state) &&
 	    !test_bit(B_DIRTY, &b->state)) {
 		dm_bufio_lock(c);
 
 		/* cache remove can fail if there are other holders */
-		if (cache_remove(&c->cache, b)) {
+		if (cache_remove(&c->cache, tree, b)) {
 			__free_buffer_wake(b);
 			dm_bufio_unlock(c);
 			return;
 		}
 
 		dm_bufio_unlock(c);
 	}
 
-	cache_put_and_wake(c, b);
+	cache_put_and_wake(c, tree, b);
 }
 EXPORT_SYMBOL_GPL(dm_bufio_release);
 
 void dm_bufio_mark_partial_buffer_dirty(struct dm_buffer *b,
 					unsigned int start, unsigned int end)
@@ -2064,11 +2095,12 @@ void dm_bufio_mark_partial_buffer_dirty(struct dm_buffer *b,
 	BUG_ON(test_bit(B_READING, &b->state));
 
 	if (!test_and_set_bit(B_DIRTY, &b->state)) {
 		b->dirty_start = start;
 		b->dirty_end = end;
-		cache_mark(&c->cache, b, LIST_DIRTY);
+		cache_mark(&c->cache, cache_get_tree(&c->cache, b->block), b,
+			   LIST_DIRTY);
 	} else {
 		if (start < b->dirty_start)
 			b->dirty_start = start;
 		if (end > b->dirty_end)
 			b->dirty_end = end;
@@ -2129,10 +2161,11 @@ int dm_bufio_write_dirty_buffers(struct dm_bufio_client *c)
 
 	nr_buffers = cache_count(&c->cache, LIST_DIRTY);
 	lru_iter_begin(&c->cache.lru[LIST_DIRTY], &it);
 	while ((e = lru_iter_next(&it, is_writing, c))) {
 		struct dm_buffer *b = le_to_buffer(e);
+		struct buffer_tree *tree;
 		__cache_inc_buffer(b);
 
 		BUG_ON(test_bit(B_READING, &b->state));
 
 		if (nr_buffers) {
@@ -2142,14 +2175,16 @@ int dm_bufio_write_dirty_buffers(struct dm_bufio_client *c)
 			dm_bufio_lock(c);
 		} else {
 			wait_on_bit_io(&b->state, B_WRITING, TASK_UNINTERRUPTIBLE);
 		}
 
+		tree = cache_get_tree(&c->cache, b->block);
+
 		if (!test_bit(B_DIRTY, &b->state) && !test_bit(B_WRITING, &b->state))
-			cache_mark(&c->cache, b, LIST_CLEAN);
+			cache_mark(&c->cache, tree, b, LIST_CLEAN);
 
-		cache_put_and_wake(c, b);
+		cache_put_and_wake(c, tree, b);
 
 		cond_resched();
 	}
 	lru_iter_end(&it);
 
@@ -2213,21 +2248,22 @@ int dm_bufio_issue_discard(struct dm_bufio_client *c, sector_t block, sector_t c
 }
 EXPORT_SYMBOL_GPL(dm_bufio_issue_discard);
 
 static void forget_buffer(struct dm_bufio_client *c, sector_t block)
 {
+	struct buffer_tree *tree = cache_get_tree(&c->cache, block);
 	struct dm_buffer *b;
 
-	b = cache_get(&c->cache, block);
+	b = cache_get(&c->cache, tree, block);
 	if (b) {
 		if (likely(!smp_load_acquire(&b->state))) {
-			if (cache_remove(&c->cache, b))
+			if (cache_remove(&c->cache, tree, b))
 				__free_buffer_wake(b);
 			else
-				cache_put_and_wake(c, b);
+				cache_put_and_wake(c, tree, b);
 		} else {
-			cache_put_and_wake(c, b);
+			cache_put_and_wake(c, tree, b);
 		}
 	}
 }
 
 /*
-- 
2.52.0

