Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58748C76195
	for <dm-devel@archiver.kernel.org>; Fri, 24 Mar 2023 17:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679680665;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6mgK2leDuOxOVJVtXOPpvdrDqdU3/qsUNKQBkW9ALqA=;
	b=hWddJ2UgN7Ioa1I3kiqldRYULhRe2GX8iDo5a39QrqX0FDzDkh+lyV5A/cAkzwcLhLa7py
	7Ls+fTESjVj/0iB/V82/qEqp/Lt/QW87tGfLd0IVp26Vzv5KejBanqXci4+aUh0OUTER1v
	uARXhtjXdnZF+OdLah29c0cZLJzczLk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-OrsG7maIP5iFBhONIMTZbA-1; Fri, 24 Mar 2023 13:57:42 -0400
X-MC-Unique: OrsG7maIP5iFBhONIMTZbA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 893ED28135BE;
	Fri, 24 Mar 2023 17:57:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6F3DEC15BA0;
	Fri, 24 Mar 2023 17:57:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 35B4119472C3;
	Fri, 24 Mar 2023 17:57:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CD2341946A6D
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Mar 2023 17:57:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B21B5140E950; Fri, 24 Mar 2023 17:57:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A8D1B140EBF4
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 17:57:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D4C01C0515A
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 17:57:08 +0000 (UTC)
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com
 [209.85.160.177]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-Vu20Ltu2M6GZSp-vq7oinQ-1; Fri, 24 Mar 2023 13:57:07 -0400
X-MC-Unique: Vu20Ltu2M6GZSp-vq7oinQ-1
Received: by mail-qt1-f177.google.com with SMTP id x1so2199023qtr.7
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 10:57:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679680626;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=Nj6DtiIEI7gaS0D990upy6UUpNiFit8Er0V6FxawCuA=;
 b=2eM0vJiXt8bWcj/cBuN+K8r3qu0au0sgx+QYkN4lGVw6mCjQMf8d/CkOi3LMklFz8l
 tMx8+9FhyQP40AbqXv+/RuqUb182TAZ0qMJj63n+dLDyIA4z+qfF/q5pNZnDCZ3ekEco
 X21DB/7tbEEzcK+SocHGorkgXEaFKlR3qCSTPd9JlN3dofx6ciyFSI3PeZjR1LOCxYaU
 P5mKql0SFPjq9ZKmR4/euBdI5CjLrGNqPtxXeUWZdLwc/lEgvUloU0vEkHaujauy6Zz4
 YLbkn2zwcBsyJnlVobBheZ3qGo07P87ekVeiLaxL0cCsEyvQAWPUceZRWYkFLAUO4SzM
 g7jg==
X-Gm-Message-State: AAQBX9dd4uj8d7XfYuJ7EebAMkZkIpPRWkZixlQM7nxqcLH1cT0ZXMJ4
 Tesb4NqhZSpgu6OlkBSHuX+FTKCrokxRv36LmaQTluyqk/UNqHKjS+O4kG4jhzbCumrskXHIAo3
 sO75ba1m+2zp5eXRGgmFvm3LKUlTKBSp/uUIO+uJ+12Wjk7nhJGbw+lq4zdurS1lhm6SAs+Sbp9
 E=
X-Google-Smtp-Source: AKy350YGux+DhQEuFl2HKl4LCF9nudv/mGplpFO+C4fnNA73IBwzc7dKC0R4UG8n+0svBCqjp9xMkg==
X-Received: by 2002:a05:622a:352:b0:3e4:d90a:b12a with SMTP id
 r18-20020a05622a035200b003e4d90ab12amr2103549qtw.17.1679680624894; 
 Fri, 24 Mar 2023 10:57:04 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 o5-20020a375a05000000b007464fcca543sm14425019qkb.50.2023.03.24.10.57.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 24 Mar 2023 10:57:04 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Fri, 24 Mar 2023 13:56:50 -0400
Message-Id: <20230324175656.85082-4-snitzer@kernel.org>
In-Reply-To: <20230324175656.85082-1-snitzer@kernel.org>
References: <20230324175656.85082-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [dm-6.4 PATCH v2 3/9] dm bufio: improve concurrent IO
 performance
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: ebiggers@kernel.org, keescook@chromium.org, heinzm@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, nhuck@google.com,
 linux-block@vger.kernel.org, ejt@redhat.com, mpatocka@redhat.com,
 luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Joe Thornber <ejt@redhat.com>

When multiple threads perform IO to a thin device, the underlying
dm_bufio object can become a bottleneck; slowing down access to btree
nodes that store the thin metadata. Prior to this commit, each bufio
instance had a single mutex that was taken for every bufio operation.

This commit concentrates on improving the common case where: a user of
dm_bufio wishes to access, but not modify, a buffer which is already
within the dm_bufio cache.

Implementation::

  The code has been refactored; pulling out an 'lru' abstraction and a
  'buffer cache' abstraction.

 LRU:
  A clock algorithm is used in the LRU abstraction.  This avoids
  relinking list nodes, which would require a write lock protecting
  it.

  None of the lru methods are threadsafe; locking must be done at a
  higher level.

 Buffer cache:
  The buffer cache is responsible for managing the holder count,
  tracking clean/dirty state, and choosing buffers via predicates.
  Higher level code is responsible for allocation of buffers, IO and
  eviction/cache sizing.

  The buffer cache has thread safe methods for acquiring a reference
  to an existing buffer. All other methods in buffer cache are _not_
  threadsafe, and only contain enough locking to guarantee the safe
  methods.

  Rather than a single mutex, sharded rw_semaphores are used to allow
  concurrent threads to 'get' buffers. Each rw_semaphore protects its
  own rbtree of buffer entries.

Testing::

  Some of the low level functions have been unit tested using dm-unit:
    https://github.com/jthornber/dm-unit/blob/main/src/tests/bufio.rs

  Higher level concurrency and IO is tested via a test only target
  found here:
    https://github.com/jthornber/linux/blob/2023-03-24-thin-concurrency-9/drivers/md/dm-bufio-test.c

  The associated userland side of these tests is here:
    https://github.com/jthornber/dmtest-python/blob/main/src/dmtest/bufio/bufio_tests.py

  In addition the full dmtest suite of tests (dm-thin, dm-cache, etc)
  has been run (~450 tests).

Performance::

  Most bufio operations have unchanged performance. But if multiple
  threads are attempting to get buffers concurrently, and these
  buffers are already in the cache then there's a big speed up. Eg,
  one test has 16 'hotspot' threads simulating btree lookups while
  another thread dirties the whole device. In this case the hotspot
  threads acquire the buffers about 25 times faster.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bufio.c | 1769 ++++++++++++++++++++++++++++++-----------
 1 file changed, 1292 insertions(+), 477 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 1de1bdcda1ce..a58f8ac3ba75 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -66,6 +66,247 @@
 #define LIST_DIRTY	1
 #define LIST_SIZE	2
 
+/*--------------------------------------------------------------*/
+
+/*
+ * Rather than use an LRU list, we use a clock algorithm where entries
+ * are held in a circular list.  When an entry is 'hit' a reference bit
+ * is set.  The least recently used entry is approximated by running a
+ * cursor around the list selecting unreferenced entries. Referenced
+ * entries have their reference bit cleared as the cursor passes them.
+ */
+struct lru_entry {
+	struct list_head list;
+	atomic_t referenced;
+};
+
+struct lru_iter {
+	struct lru *lru;
+	struct list_head list;
+	struct lru_entry *stop;
+	struct lru_entry *e;
+};
+
+struct lru {
+	struct list_head *cursor;
+	unsigned long count;
+
+	struct list_head iterators;
+};
+
+/*--------------*/
+
+static void lru_init(struct lru *lru)
+{
+	lru->cursor = NULL;
+	lru->count = 0;
+	INIT_LIST_HEAD(&lru->iterators);
+}
+
+static void lru_destroy(struct lru *lru)
+{
+	BUG_ON(lru->cursor);
+	BUG_ON(!list_empty(&lru->iterators));
+}
+
+static inline unsigned long lru_count(struct lru *lru)
+{
+	return lru->count;
+}
+
+/*
+ * Insert a new entry into the lru.
+ */
+static void lru_insert(struct lru *lru, struct lru_entry *le)
+{
+	/*
+	 * Don't be tempted to set to 1, makes the lru aspect
+	 * perform poorly.
+	 */
+	atomic_set(&le->referenced, 0);
+
+	if (lru->cursor)
+		list_add_tail(&le->list, lru->cursor);
+
+	else {
+		INIT_LIST_HEAD(&le->list);
+		lru->cursor = &le->list;
+	}
+	lru->count++;
+}
+
+/*--------------*/
+
+/*
+ * Convert a list_head pointer to an lru_entry pointer.
+ */
+static inline struct lru_entry *to_le(struct list_head *l)
+{
+	return container_of(l, struct lru_entry, list);
+}
+
+/*
+ * Initialize an lru_iter and add it to the list of cursors in the lru.
+ */
+static void lru_iter_begin(struct lru *lru, struct lru_iter *it)
+{
+	it->lru = lru;
+	it->stop = lru->cursor ? to_le(lru->cursor->prev) : NULL;
+	it->e = lru->cursor ? to_le(lru->cursor) : NULL;
+	list_add(&it->list, &lru->iterators);
+}
+
+/*
+ * Remove an lru_iter from the list of cursors in the lru.
+ */
+static void lru_iter_end(struct lru_iter *it)
+{
+	list_del(&it->list);
+}
+
+/* Predicate function type to be used with lru_iter_next */
+typedef bool (*iter_predicate)(struct lru_entry *le, void *context);
+
+/*
+ * Advance the cursor to the next entry that passes the
+ * predicate, and return that entry.  Returns NULL if the
+ * iteration is complete.
+ */
+static struct lru_entry *lru_iter_next(struct lru_iter *it,
+				       iter_predicate pred, void *context)
+{
+	struct lru_entry *e;
+
+	while (it->e) {
+		e = it->e;
+
+		/* advance the cursor */
+		if (it->e == it->stop)
+			it->e = NULL;
+		else
+			it->e = to_le(it->e->list.next);
+
+		if (pred(e, context))
+			return e;
+	}
+
+	return NULL;
+}
+
+/*
+ * Invalidate a specific lru_entry and update all cursors in
+ * the lru accordingly.
+ */
+static void lru_iter_invalidate(struct lru *lru, struct lru_entry *e)
+{
+	struct lru_iter *it;
+
+	list_for_each_entry(it, &lru->iterators, list) {
+		/* Move c->e forwards if necc. */
+		if (it->e == e) {
+			it->e = to_le(it->e->list.next);
+			if (it->e == e)
+				it->e = NULL;
+		}
+
+		/* Move it->stop backwards if necc. */
+		if (it->stop == e) {
+			it->stop = to_le(it->stop->list.prev);
+			if (it->stop == e)
+				it->stop = NULL;
+		}
+	}
+}
+
+/*--------------*/
+
+/*
+ * Remove a specific entry from the lru.
+ */
+static void lru_remove(struct lru *lru, struct lru_entry *le)
+{
+	lru_iter_invalidate(lru, le);
+	if (lru->count == 1)
+		lru->cursor = NULL;
+	else {
+		if (lru->cursor == &le->list)
+			lru->cursor = lru->cursor->next;
+		list_del(&le->list);
+	}
+	lru->count--;
+}
+
+/*
+ * Mark as referenced.
+ */
+static inline void lru_reference(struct lru_entry *le)
+{
+	atomic_set(&le->referenced, 1);
+}
+
+/*--------------*/
+
+/*
+ * Remove the least recently used entry (approx), that passes the predicate.
+ * Returns NULL on failure.
+ */
+enum evict_result {
+	ER_EVICT,
+	ER_DONT_EVICT,
+	ER_STOP, /* stop looking for something to evict */
+};
+
+typedef enum evict_result (*le_predicate)(struct lru_entry *le, void *context);
+
+static struct lru_entry *lru_evict(struct lru *lru, le_predicate pred, void *context)
+{
+	unsigned long tested = 0;
+	struct list_head *h = lru->cursor;
+	struct lru_entry *le;
+
+	if (!h)
+		return NULL;
+	/*
+	 * In the worst case we have to loop around twice. Once to clear
+	 * the reference flags, and then again to discover the predicate
+	 * fails for all entries.
+	 */
+	while (tested < lru->count) {
+		le = container_of(h, struct lru_entry, list);
+
+		if (atomic_read(&le->referenced))
+			atomic_set(&le->referenced, 0);
+		else {
+			tested++;
+			switch (pred(le, context)) {
+			case ER_EVICT:
+				/*
+				 * Adjust the cursor, so we start the next
+				 * search from here.
+				 */
+				lru->cursor = le->list.next;
+				lru_remove(lru, le);
+				return le;
+
+			case ER_DONT_EVICT:
+				break;
+
+			case ER_STOP:
+				lru->cursor = le->list.next;
+				return NULL;
+			}
+		}
+
+		h = h->next;
+
+		cond_resched();
+	}
+
+	return NULL;
+}
+
+/*--------------------------------------------------------------*/
+
 /*
  * Buffer state bits.
  */
@@ -86,28 +327,37 @@ enum data_mode {
 };
 
 struct dm_buffer {
+	/* protected by the locks in dm_buffer_cache */
 	struct rb_node node;
-	struct list_head lru_list;
-	struct list_head global_list;
 
+	/* immutable, so don't need protecting */
 	sector_t block;
 	void *data;
 	unsigned char data_mode;		/* DATA_MODE_* */
 
-	unsigned int accessed;
-	unsigned int hold_count;
+	/*
+	 * These two fields are used in isolation, so do not need
+	 * a surrounding lock. NOTE: attempting to use refcount_t
+	 * instead of atomic_t caused crashes!
+	 */
+	atomic_t hold_count;
 	unsigned long last_accessed;
 
+	/*
+	 * Everything else is protected by the mutex in
+	 * dm_bufio_client
+	 */
+	unsigned long state;
+	struct lru_entry lru;
 	unsigned char list_mode;		/* LIST_* */
 	blk_status_t read_error;
 	blk_status_t write_error;
-	unsigned long state;
 	unsigned int dirty_start;
 	unsigned int dirty_end;
 	unsigned int write_start;
 	unsigned int write_end;
-	struct dm_bufio_client *c;
 	struct list_head write_list;
+	struct dm_bufio_client *c;
 	void (*end_io)(struct dm_buffer *b, blk_status_t bs);
 #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
 #define MAX_STACK 10
@@ -116,9 +366,579 @@ struct dm_buffer {
 #endif
 };
 
+/*--------------------------------------------------------------*/
+
+/*
+ * The buffer cache manages buffers, particularly:
+ *  - inc/dec of holder count
+ *  - setting the last_accessed field
+ *  - maintains clean/dirty state along with lru
+ *  - selecting buffers that match predicates
+ *
+ * It does *not* handle:
+ *  - allocation/freeing of buffers.
+ *  - IO
+ *  - Eviction or cache sizing.
+ *
+ * cache_get() and cache_put() are threadsafe, you do not need to
+ * protect these calls with a surrounding mutex.  All the other
+ * methods are not threadsafe; they do use locking primitives, but
+ * only enough to ensure get/put are threadsafe.
+ */
+
+#define NR_LOCKS 64
+#define LOCKS_MASK (NR_LOCKS - 1)
+
+struct tree_lock {
+	struct rw_semaphore lock;
+} ____cacheline_aligned_in_smp;
+
+struct dm_buffer_cache {
+	/*
+	 * We spread entries across multiple trees to reduce contention
+	 * on the locks.
+	 */
+	struct tree_lock locks[NR_LOCKS];
+	struct rb_root roots[NR_LOCKS];
+	struct lru lru[LIST_SIZE];
+};
+
+/*
+ * We want to scatter the buffers across the different rbtrees
+ * to improve concurrency, but we also want to encourage the
+ * lock_history optimisation (below). Scattering runs of 16
+ * buffers seems to be a good compromise.
+ */
+static inline unsigned int cache_index(sector_t block)
+{
+	return block & LOCKS_MASK;
+}
+
+static inline void cache_read_lock(struct dm_buffer_cache *bc, sector_t block)
+{
+	down_read(&bc->locks[cache_index(block)].lock);
+}
+
+static inline void cache_read_unlock(struct dm_buffer_cache *bc, sector_t block)
+{
+	up_read(&bc->locks[cache_index(block)].lock);
+}
+
+static inline void cache_write_lock(struct dm_buffer_cache *bc, sector_t block)
+{
+	down_write(&bc->locks[cache_index(block)].lock);
+}
+
+static inline void cache_write_unlock(struct dm_buffer_cache *bc, sector_t block)
+{
+	up_write(&bc->locks[cache_index(block)].lock);
+}
+
+/*
+ * Sometimes we want to repeatedly get and drop locks as part of an iteration.
+ * This struct helps avoid redundant drop and gets of the same lock.
+ */
+struct lock_history {
+	struct dm_buffer_cache *cache;
+	bool write;
+	unsigned int previous;
+};
+
+static void lh_init(struct lock_history *lh, struct dm_buffer_cache *cache, bool write)
+{
+	lh->cache = cache;
+	lh->write = write;
+	lh->previous = NR_LOCKS;  /* indicates no previous */
+}
+
+static void __lh_lock(struct lock_history *lh, unsigned int index)
+{
+	if (lh->write)
+		down_write(&lh->cache->locks[index].lock);
+	else
+		down_read(&lh->cache->locks[index].lock);
+}
+
+static void __lh_unlock(struct lock_history *lh, unsigned int index)
+{
+	if (lh->write)
+		up_write(&lh->cache->locks[index].lock);
+	else
+		up_read(&lh->cache->locks[index].lock);
+}
+
+/*
+ * Make sure you call this since it will unlock the final lock.
+ */
+static void lh_exit(struct lock_history *lh)
+{
+	if (lh->previous != NR_LOCKS) {
+		__lh_unlock(lh, lh->previous);
+		lh->previous = NR_LOCKS;
+	}
+}
+
+/*
+ * Named 'next' because there is no corresponding
+ * 'up/unlock' call since it's done automatically.
+ */
+static void lh_next(struct lock_history *lh, sector_t b)
+{
+	unsigned int index = cache_index(b);
+
+	if (lh->previous != NR_LOCKS) {
+		if (lh->previous != index) {
+			__lh_unlock(lh, lh->previous);
+			__lh_lock(lh, index);
+			lh->previous = index;
+		}
+	} else {
+		__lh_lock(lh, index);
+		lh->previous = index;
+	}
+}
+
+static struct dm_buffer *le_to_buffer(struct lru_entry *le)
+{
+	return container_of(le, struct dm_buffer, lru);
+}
+
+static struct dm_buffer *list_to_buffer(struct list_head *l)
+{
+	struct lru_entry *le = list_entry(l, struct lru_entry, list);
+
+	if (!le)
+		return NULL;
+
+	return le_to_buffer(le);
+}
+
+static void cache_init(struct dm_buffer_cache *bc)
+{
+	unsigned int i;
+
+	for (i = 0; i < NR_LOCKS; i++) {
+		init_rwsem(&bc->locks[i].lock);
+		bc->roots[i] = RB_ROOT;
+	}
+
+	lru_init(&bc->lru[LIST_CLEAN]);
+	lru_init(&bc->lru[LIST_DIRTY]);
+}
+
+static void cache_destroy(struct dm_buffer_cache *bc)
+{
+	unsigned int i;
+
+	for (i = 0; i < NR_LOCKS; i++)
+		BUG_ON(!RB_EMPTY_ROOT(&bc->roots[i]));
+
+	lru_destroy(&bc->lru[LIST_CLEAN]);
+	lru_destroy(&bc->lru[LIST_DIRTY]);
+}
+
+/*
+ * not threadsafe, or racey depending how you look at it
+ */
+static unsigned long cache_count(struct dm_buffer_cache *bc, int list_mode)
+{
+	return lru_count(&bc->lru[list_mode]);
+}
+
+/*--------------*/
+
+/*
+ * not threadsafe
+ */
+static unsigned long cache_total(struct dm_buffer_cache *bc)
+{
+	return lru_count(&bc->lru[LIST_CLEAN]) +
+		lru_count(&bc->lru[LIST_DIRTY]);
+}
+
+/*--------------*/
+
+/*
+ * Gets a specific buffer, indexed by block.
+ * If the buffer is found then its holder count will be incremented and
+ * lru_reference will be called.
+ *
+ * threadsafe
+ */
+static struct dm_buffer *__cache_get(const struct rb_root *root, sector_t block)
+{
+	struct rb_node *n = root->rb_node;
+	struct dm_buffer *b;
+
+	while (n) {
+		b = container_of(n, struct dm_buffer, node);
+
+		if (b->block == block)
+			return b;
+
+		n = block < b->block ? n->rb_left : n->rb_right;
+	}
+
+	return NULL;
+}
+
+static void __cache_inc_buffer(struct dm_buffer *b)
+{
+	atomic_inc(&b->hold_count);
+	WRITE_ONCE(b->last_accessed, jiffies);
+}
+
+static struct dm_buffer *cache_get(struct dm_buffer_cache *bc, sector_t block)
+{
+	struct dm_buffer *b;
+
+	cache_read_lock(bc, block);
+	b = __cache_get(&bc->roots[cache_index(block)], block);
+	if (b) {
+		lru_reference(&b->lru);
+		__cache_inc_buffer(b);
+	}
+	cache_read_unlock(bc, block);
+
+	return b;
+}
+
+/*--------------*/
+
+/*
+ * Returns true if the hold count hits zero.
+ * threadsafe
+ */
+static bool cache_put(struct dm_buffer_cache *bc, struct dm_buffer *b)
+{
+	bool r;
+
+	cache_read_lock(bc, b->block);
+	BUG_ON(!atomic_read(&b->hold_count));
+	r = atomic_dec_and_test(&b->hold_count);
+	cache_read_unlock(bc, b->block);
+
+	return r;
+}
+
+/*--------------*/
+
+typedef enum evict_result (*b_predicate)(struct dm_buffer *, void *);
+
+/*
+ * Evicts a buffer based on a predicate.  The oldest buffer that
+ * matches the predicate will be selected.  In addition to the
+ * predicate the hold_count of the selected buffer will be zero.
+ */
+struct evict_wrapper {
+	struct lock_history *lh;
+	b_predicate pred;
+	void *context;
+};
+
+/*
+ * Wraps the buffer predicate turning it into an lru predicate.  Adds
+ * extra test for hold_count.
+ */
+static enum evict_result __evict_pred(struct lru_entry *le, void *context)
+{
+	struct evict_wrapper *w = context;
+	struct dm_buffer *b = le_to_buffer(le);
+
+	lh_next(w->lh, b->block);
+
+	if (atomic_read(&b->hold_count))
+		return ER_DONT_EVICT;
+
+	return w->pred(b, w->context);
+}
+
+static struct dm_buffer *__cache_evict(struct dm_buffer_cache *bc, int list_mode,
+				       b_predicate pred, void *context,
+				       struct lock_history *lh)
+{
+	struct evict_wrapper w = {.lh = lh, .pred = pred, .context = context};
+	struct lru_entry *le;
+	struct dm_buffer *b;
+
+	le = lru_evict(&bc->lru[list_mode], __evict_pred, &w);
+	if (!le)
+		return NULL;
+
+	b = le_to_buffer(le);
+	/* __evict_pred will have locked the appropriate tree. */
+	rb_erase(&b->node, &bc->roots[cache_index(b->block)]);
+
+	return b;
+}
+
+static struct dm_buffer *cache_evict(struct dm_buffer_cache *bc, int list_mode,
+				     b_predicate pred, void *context)
+{
+	struct dm_buffer *b;
+	struct lock_history lh;
+
+	lh_init(&lh, bc, true);
+	b = __cache_evict(bc, list_mode, pred, context, &lh);
+	lh_exit(&lh);
+
+	return b;
+}
+
+/*--------------*/
+
+/*
+ * Mark a buffer as clean or dirty. Not threadsafe.
+ */
+static void cache_mark(struct dm_buffer_cache *bc, struct dm_buffer *b, int list_mode)
+{
+	cache_write_lock(bc, b->block);
+	if (list_mode != b->list_mode) {
+		lru_remove(&bc->lru[b->list_mode], &b->lru);
+		b->list_mode = list_mode;
+		lru_insert(&bc->lru[b->list_mode], &b->lru);
+	}
+	cache_write_unlock(bc, b->block);
+}
+
+/*--------------*/
+
+/*
+ * Runs through the lru associated with 'old_mode', if the predicate matches then
+ * it moves them to 'new_mode'.  Not threadsafe.
+ */
+static void __cache_mark_many(struct dm_buffer_cache *bc, int old_mode, int new_mode,
+			      b_predicate pred, void *context, struct lock_history *lh)
+{
+	struct lru_entry *le;
+	struct dm_buffer *b;
+	struct evict_wrapper w = {.lh = lh, .pred = pred, .context = context};
+
+	while (true) {
+		le = lru_evict(&bc->lru[old_mode], __evict_pred, &w);
+		if (!le)
+			break;
+
+		b = le_to_buffer(le);
+		b->list_mode = new_mode;
+		lru_insert(&bc->lru[b->list_mode], &b->lru);
+	}
+}
+
+static void cache_mark_many(struct dm_buffer_cache *bc, int old_mode, int new_mode,
+			    b_predicate pred, void *context)
+{
+	struct lock_history lh;
+
+	lh_init(&lh, bc, true);
+	__cache_mark_many(bc, old_mode, new_mode, pred, context, &lh);
+	lh_exit(&lh);
+}
+
+/*--------------*/
+
+/*
+ * Iterates through all clean or dirty entries calling a function for each
+ * entry.  The callback may terminate the iteration early.  Not threadsafe.
+ */
+
+/*
+ * Iterator functions should return one of these actions to indicate
+ * how the iteration should proceed.
+ */
+enum it_action {
+	IT_NEXT,
+	IT_COMPLETE,
+};
+
+typedef enum it_action (*iter_fn)(struct dm_buffer *b, void *context);
+
+static void __cache_iterate(struct dm_buffer_cache *bc, int list_mode,
+			    iter_fn fn, void *context, struct lock_history *lh)
+{
+	struct lru *lru = &bc->lru[list_mode];
+	struct lru_entry *le, *first;
+
+	if (!lru->cursor)
+		return;
+
+	first = le = to_le(lru->cursor);
+	do {
+		struct dm_buffer *b = le_to_buffer(le);
+
+		lh_next(lh, b->block);
+
+		switch (fn(b, context)) {
+		case IT_NEXT:
+			break;
+
+		case IT_COMPLETE:
+			return;
+		}
+		cond_resched();
+
+		le = to_le(le->list.next);
+	} while (le != first);
+}
+
+static void cache_iterate(struct dm_buffer_cache *bc, int list_mode,
+			  iter_fn fn, void *context)
+{
+	struct lock_history lh;
+
+	lh_init(&lh, bc, false);
+	__cache_iterate(bc, list_mode, fn, context, &lh);
+	lh_exit(&lh);
+}
+
+/*--------------*/
+
+/*
+ * Passes ownership of the buffer to the cache. Returns false if the
+ * buffer was already present (in which case ownership does not pass).
+ * eg, a race with another thread.
+ *
+ * Holder count should be 1 on insertion.
+ *
+ * Not threadsafe.
+ */
+static bool __cache_insert(struct rb_root *root, struct dm_buffer *b)
+{
+	struct rb_node **new = &root->rb_node, *parent = NULL;
+	struct dm_buffer *found;
+
+	while (*new) {
+		found = container_of(*new, struct dm_buffer, node);
+
+		if (found->block == b->block)
+			return false;
+
+		parent = *new;
+		new = b->block < found->block ?
+			&found->node.rb_left : &found->node.rb_right;
+	}
+
+	rb_link_node(&b->node, parent, new);
+	rb_insert_color(&b->node, root);
+
+	return true;
+}
+
+static bool cache_insert(struct dm_buffer_cache *bc, struct dm_buffer *b)
+{
+	bool r;
+
+	BUG_ON(b->list_mode >= LIST_SIZE);
+
+	cache_write_lock(bc, b->block);
+	BUG_ON(atomic_read(&b->hold_count) != 1);
+	r = __cache_insert(&bc->roots[cache_index(b->block)], b);
+	if (r)
+		lru_insert(&bc->lru[b->list_mode], &b->lru);
+	cache_write_unlock(bc, b->block);
+
+	return r;
+}
+
+/*--------------*/
+
+/*
+ * Removes buffer from cache, ownership of the buffer passes back to the caller.
+ * Fails if the hold_count is not one (ie. the caller holds the only reference).
+ *
+ * Not threadsafe.
+ */
+static bool cache_remove(struct dm_buffer_cache *bc, struct dm_buffer *b)
+{
+	bool r;
+
+	cache_write_lock(bc, b->block);
+
+	if (atomic_read(&b->hold_count) != 1)
+		r = false;
+
+	else {
+		r = true;
+		rb_erase(&b->node, &bc->roots[cache_index(b->block)]);
+		lru_remove(&bc->lru[b->list_mode], &b->lru);
+	}
+
+	cache_write_unlock(bc, b->block);
+
+	return r;
+}
+
+/*--------------*/
+
+typedef void (*b_release)(struct dm_buffer *);
+
+static struct dm_buffer *__find_next(struct rb_root *root, sector_t block)
+{
+	struct rb_node *n = root->rb_node;
+	struct dm_buffer *b;
+	struct dm_buffer *best = NULL;
+
+	while (n) {
+		b = container_of(n, struct dm_buffer, node);
+
+		if (b->block == block)
+			return b;
+
+		if (block <= b->block) {
+			n = n->rb_left;
+			best = b;
+		} else
+			n = n->rb_right;
+	}
+
+	return best;
+}
+
+static void __remove_range(struct dm_buffer_cache *bc,
+			   struct rb_root *root,
+			   sector_t begin, sector_t end,
+			   b_predicate pred, b_release release)
+{
+	struct dm_buffer *b;
+
+	while (true) {
+		cond_resched();
+
+		b = __find_next(root, begin);
+		if (!b || (b->block >= end))
+			break;
+
+		begin = b->block + 1;
+
+		if (atomic_read(&b->hold_count))
+			continue;
+
+		if (pred(b, NULL) == ER_EVICT) {
+			rb_erase(&b->node, root);
+			lru_remove(&bc->lru[b->list_mode], &b->lru);
+			release(b);
+		}
+	}
+}
+
+static void cache_remove_range(struct dm_buffer_cache *bc,
+			       sector_t begin, sector_t end,
+			       b_predicate pred, b_release release)
+{
+	unsigned int i;
+
+	for (i = 0; i < NR_LOCKS; i++) {
+		down_write(&bc->locks[i].lock);
+		__remove_range(bc, &bc->roots[i], begin, end, pred, release);
+		up_write(&bc->locks[i].lock);
+	}
+}
+
+/*----------------------------------------------------------------*/
+
 /*
  * Linking of buffers:
- *	All buffers are linked to buffer_tree with their node field.
+ *	All buffers are linked to buffer_cache with their node field.
  *
  *	Clean buffers that are not being written (B_WRITING not set)
  *	are linked to lru[LIST_CLEAN] with their lru_list field.
@@ -136,9 +956,6 @@ struct dm_bufio_client {
 	spinlock_t spinlock;
 	bool no_sleep;
 
-	struct list_head lru[LIST_SIZE];
-	unsigned long n_buffers[LIST_SIZE];
-
 	struct block_device *bdev;
 	unsigned int block_size;
 	s8 sectors_per_block_bits;
@@ -153,7 +970,7 @@ struct dm_bufio_client {
 
 	unsigned int minimum_buffers;
 
-	struct rb_root buffer_tree;
+	struct dm_buffer_cache cache;
 	wait_queue_head_t free_buffer_wait;
 
 	sector_t start;
@@ -165,6 +982,11 @@ struct dm_bufio_client {
 	struct shrinker shrinker;
 	struct work_struct shrink_work;
 	atomic_long_t need_shrink;
+
+	/*
+	 * Used by global_cleanup to sort the clients list.
+	 */
+	unsigned long oldest_buffer;
 };
 
 static DEFINE_STATIC_KEY_FALSE(no_sleep_enabled);
@@ -181,14 +1003,6 @@ static void dm_bufio_lock(struct dm_bufio_client *c)
 		mutex_lock_nested(&c->lock, dm_bufio_in_request());
 }
 
-static int dm_bufio_trylock(struct dm_bufio_client *c)
-{
-	if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep)
-		return spin_trylock_bh(&c->spinlock);
-	else
-		return mutex_trylock(&c->lock);
-}
-
 static void dm_bufio_unlock(struct dm_bufio_client *c)
 {
 	if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep)
@@ -217,10 +1031,6 @@ static unsigned long dm_bufio_cache_size_latch;
 
 static DEFINE_SPINLOCK(global_spinlock);
 
-static LIST_HEAD(global_queue);
-
-static unsigned long global_num;
-
 /*
  * Buffers are freed after this timeout
  */
@@ -254,7 +1064,6 @@ static struct workqueue_struct *dm_bufio_wq;
 static struct delayed_work dm_bufio_cleanup_old_work;
 static struct work_struct dm_bufio_replacement_work;
 
-
 #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
 static void buffer_record_stack(struct dm_buffer *b)
 {
@@ -262,78 +1071,6 @@ static void buffer_record_stack(struct dm_buffer *b)
 }
 #endif
 
-/*
- *----------------------------------------------------------------
- * A red/black tree acts as an index for all the buffers.
- *----------------------------------------------------------------
- */
-static struct dm_buffer *__find(struct dm_bufio_client *c, sector_t block)
-{
-	struct rb_node *n = c->buffer_tree.rb_node;
-	struct dm_buffer *b;
-
-	while (n) {
-		b = container_of(n, struct dm_buffer, node);
-
-		if (b->block == block)
-			return b;
-
-		n = block < b->block ? n->rb_left : n->rb_right;
-	}
-
-	return NULL;
-}
-
-static struct dm_buffer *__find_next(struct dm_bufio_client *c, sector_t block)
-{
-	struct rb_node *n = c->buffer_tree.rb_node;
-	struct dm_buffer *b;
-	struct dm_buffer *best = NULL;
-
-	while (n) {
-		b = container_of(n, struct dm_buffer, node);
-
-		if (b->block == block)
-			return b;
-
-		if (block <= b->block) {
-			n = n->rb_left;
-			best = b;
-		} else {
-			n = n->rb_right;
-		}
-	}
-
-	return best;
-}
-
-static void __insert(struct dm_bufio_client *c, struct dm_buffer *b)
-{
-	struct rb_node **new = &c->buffer_tree.rb_node, *parent = NULL;
-	struct dm_buffer *found;
-
-	while (*new) {
-		found = container_of(*new, struct dm_buffer, node);
-
-		if (found->block == b->block) {
-			BUG_ON(found != b);
-			return;
-		}
-
-		parent = *new;
-		new = b->block < found->block ?
-			&found->node.rb_left : &found->node.rb_right;
-	}
-
-	rb_link_node(&b->node, parent, new);
-	rb_insert_color(&b->node, &c->buffer_tree);
-}
-
-static void __remove(struct dm_bufio_client *c, struct dm_buffer *b)
-{
-	rb_erase(&b->node, &c->buffer_tree);
-}
-
 /*----------------------------------------------------------------*/
 
 static void adjust_total_allocated(struct dm_buffer *b, bool unlink)
@@ -361,16 +1098,9 @@ static void adjust_total_allocated(struct dm_buffer *b, bool unlink)
 	if (dm_bufio_current_allocated > dm_bufio_peak_allocated)
 		dm_bufio_peak_allocated = dm_bufio_current_allocated;
 
-	b->accessed = 1;
-
 	if (!unlink) {
-		list_add(&b->global_list, &global_queue);
-		global_num++;
 		if (dm_bufio_current_allocated > dm_bufio_cache_size)
 			queue_work(dm_bufio_wq, &dm_bufio_replacement_work);
-	} else {
-		list_del(&b->global_list);
-		global_num--;
 	}
 
 	spin_unlock(&global_spinlock);
@@ -486,8 +1216,9 @@ static void free_buffer_data(struct dm_bufio_client *c,
  */
 static struct dm_buffer *alloc_buffer(struct dm_bufio_client *c, gfp_t gfp_mask)
 {
-	struct dm_buffer *b = kmem_cache_alloc(c->slab_buffer, gfp_mask);
+	struct dm_buffer *b;
 
+	b = kmem_cache_alloc(c->slab_buffer, gfp_mask);
 	if (!b)
 		return NULL;
 
@@ -498,6 +1229,7 @@ static struct dm_buffer *alloc_buffer(struct dm_bufio_client *c, gfp_t gfp_mask)
 		kmem_cache_free(c->slab_buffer, b);
 		return NULL;
 	}
+	adjust_total_allocated(b, false);
 
 #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
 	b->stack_len = 0;
@@ -512,61 +1244,11 @@ static void free_buffer(struct dm_buffer *b)
 {
 	struct dm_bufio_client *c = b->c;
 
+	adjust_total_allocated(b, true);
 	free_buffer_data(c, b->data, b->data_mode);
 	kmem_cache_free(c->slab_buffer, b);
 }
 
-/*
- * Link buffer to the buffer tree and clean or dirty queue.
- */
-static void __link_buffer(struct dm_buffer *b, sector_t block, int dirty)
-{
-	struct dm_bufio_client *c = b->c;
-
-	c->n_buffers[dirty]++;
-	b->block = block;
-	b->list_mode = dirty;
-	list_add(&b->lru_list, &c->lru[dirty]);
-	__insert(b->c, b);
-	b->last_accessed = jiffies;
-
-	adjust_total_allocated(b, false);
-}
-
-/*
- * Unlink buffer from the buffer tree and dirty or clean queue.
- */
-static void __unlink_buffer(struct dm_buffer *b)
-{
-	struct dm_bufio_client *c = b->c;
-
-	BUG_ON(!c->n_buffers[b->list_mode]);
-
-	c->n_buffers[b->list_mode]--;
-	__remove(b->c, b);
-	list_del(&b->lru_list);
-
-	adjust_total_allocated(b, true);
-}
-
-/*
- * Place the buffer to the head of dirty or clean LRU queue.
- */
-static void __relink_lru(struct dm_buffer *b, int dirty)
-{
-	struct dm_bufio_client *c = b->c;
-
-	b->accessed = 1;
-
-	BUG_ON(!c->n_buffers[b->list_mode]);
-
-	c->n_buffers[b->list_mode]--;
-	c->n_buffers[dirty]++;
-	b->list_mode = dirty;
-	list_move(&b->lru_list, &c->lru[dirty]);
-	b->last_accessed = jiffies;
-}
-
 /*
  *--------------------------------------------------------------------------
  * Submit I/O on the buffer.
@@ -806,7 +1488,7 @@ static void __flush_write_list(struct list_head *write_list)
  */
 static void __make_buffer_clean(struct dm_buffer *b)
 {
-	BUG_ON(b->hold_count);
+	BUG_ON(atomic_read(&b->hold_count));
 
 	/* smp_load_acquire() pairs with read_endio()'s smp_mb__before_atomic() */
 	if (!smp_load_acquire(&b->state))	/* fast case */
@@ -817,6 +1499,26 @@ static void __make_buffer_clean(struct dm_buffer *b)
 	wait_on_bit_io(&b->state, B_WRITING, TASK_UNINTERRUPTIBLE);
 }
 
+static enum evict_result is_clean(struct dm_buffer *b, void *context)
+{
+	struct dm_bufio_client *c = context;
+
+	BUG_ON(test_bit(B_WRITING, &b->state));
+	BUG_ON(test_bit(B_DIRTY, &b->state));
+
+	if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep &&
+	    unlikely(test_bit(B_READING, &b->state)))
+		return ER_DONT_EVICT;
+
+	return ER_EVICT;
+}
+
+static enum evict_result is_dirty(struct dm_buffer *b, void *context)
+{
+	BUG_ON(test_bit(B_READING, &b->state));
+	return ER_EVICT;
+}
+
 /*
  * Find some buffer that is not held by anybody, clean it, unlink it and
  * return it.
@@ -825,34 +1527,20 @@ static struct dm_buffer *__get_unclaimed_buffer(struct dm_bufio_client *c)
 {
 	struct dm_buffer *b;
 
-	list_for_each_entry_reverse(b, &c->lru[LIST_CLEAN], lru_list) {
-		BUG_ON(test_bit(B_WRITING, &b->state));
-		BUG_ON(test_bit(B_DIRTY, &b->state));
-
-		if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep &&
-		    unlikely(test_bit_acquire(B_READING, &b->state)))
-			continue;
-
-		if (!b->hold_count) {
-			__make_buffer_clean(b);
-			__unlink_buffer(b);
-			return b;
-		}
-		cond_resched();
+	b = cache_evict(&c->cache, LIST_CLEAN, is_clean, c);
+	if (b) {
+		/* this also waits for pending reads */
+		__make_buffer_clean(b);
+		return b;
 	}
 
 	if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep)
 		return NULL;
 
-	list_for_each_entry_reverse(b, &c->lru[LIST_DIRTY], lru_list) {
-		BUG_ON(test_bit(B_READING, &b->state));
-
-		if (!b->hold_count) {
-			__make_buffer_clean(b);
-			__unlink_buffer(b);
-			return b;
-		}
-		cond_resched();
+	b = cache_evict(&c->cache, LIST_DIRTY, is_dirty, NULL);
+	if (b) {
+		__make_buffer_clean(b);
+		return b;
 	}
 
 	return NULL;
@@ -873,7 +1561,12 @@ static void __wait_for_free_buffer(struct dm_bufio_client *c)
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	dm_bufio_unlock(c);
 
-	io_schedule();
+	/*
+	 * It's possible to miss a wake up event since we don't always
+	 * hold c->lock when wake_up is called.  So we have a timeout here,
+	 * just in case.
+	 */
+	io_schedule_timeout(5 * HZ);
 
 	remove_wait_queue(&c->free_buffer_wait, &wait);
 
@@ -931,9 +1624,8 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
 		}
 
 		if (!list_empty(&c->reserved_buffers)) {
-			b = list_entry(c->reserved_buffers.next,
-				       struct dm_buffer, lru_list);
-			list_del(&b->lru_list);
+			b = list_to_buffer(c->reserved_buffers.next);
+			list_del(&b->lru.list);
 			c->need_reserved_buffers++;
 
 			return b;
@@ -967,36 +1659,55 @@ static void __free_buffer_wake(struct dm_buffer *b)
 {
 	struct dm_bufio_client *c = b->c;
 
+	b->block = -1;
 	if (!c->need_reserved_buffers)
 		free_buffer(b);
 	else {
-		list_add(&b->lru_list, &c->reserved_buffers);
+		list_add(&b->lru.list, &c->reserved_buffers);
 		c->need_reserved_buffers--;
 	}
 
 	wake_up(&c->free_buffer_wait);
 }
 
+static enum evict_result cleaned(struct dm_buffer *b, void *context)
+{
+	BUG_ON(test_bit(B_READING, &b->state));
+
+	if (test_bit(B_DIRTY, &b->state) || test_bit(B_WRITING, &b->state))
+		return ER_DONT_EVICT;
+	else
+		return ER_EVICT;
+}
+
+static void __move_clean_buffers(struct dm_bufio_client *c)
+{
+	cache_mark_many(&c->cache, LIST_DIRTY, LIST_CLEAN, cleaned, NULL);
+}
+
+struct write_context {
+	int no_wait;
+	struct list_head *write_list;
+};
+
+static enum it_action write_one(struct dm_buffer *b, void *context)
+{
+	struct write_context *wc = context;
+
+	if (wc->no_wait && test_bit(B_WRITING, &b->state))
+		return IT_COMPLETE;
+
+	__write_dirty_buffer(b, wc->write_list);
+	return IT_NEXT;
+}
+
 static void __write_dirty_buffers_async(struct dm_bufio_client *c, int no_wait,
 					struct list_head *write_list)
 {
-	struct dm_buffer *b, *tmp;
+	struct write_context wc = {.no_wait = no_wait, .write_list = write_list};
 
-	list_for_each_entry_safe_reverse(b, tmp, &c->lru[LIST_DIRTY], lru_list) {
-		BUG_ON(test_bit(B_READING, &b->state));
-
-		if (!test_bit(B_DIRTY, &b->state) &&
-		    !test_bit(B_WRITING, &b->state)) {
-			__relink_lru(b, LIST_CLEAN);
-			continue;
-		}
-
-		if (no_wait && test_bit(B_WRITING, &b->state))
-			return;
-
-		__write_dirty_buffer(b, write_list);
-		cond_resched();
-	}
+	__move_clean_buffers(c);
+	cache_iterate(&c->cache, LIST_DIRTY, write_one, &wc);
 }
 
 /*
@@ -1007,7 +1718,8 @@ static void __write_dirty_buffers_async(struct dm_bufio_client *c, int no_wait,
 static void __check_watermark(struct dm_bufio_client *c,
 			      struct list_head *write_list)
 {
-	if (c->n_buffers[LIST_DIRTY] > c->n_buffers[LIST_CLEAN] * DM_BUFIO_WRITEBACK_RATIO)
+	if (cache_count(&c->cache, LIST_DIRTY) >
+		cache_count(&c->cache, LIST_CLEAN) * DM_BUFIO_WRITEBACK_RATIO)
 		__write_dirty_buffers_async(c, 1, write_list);
 }
 
@@ -1017,20 +1729,30 @@ static void __check_watermark(struct dm_bufio_client *c,
  *--------------------------------------------------------------
  */
 
+static void cache_put_and_wake(struct dm_bufio_client *c, struct dm_buffer *b)
+{
+	/*
+	 * Relying on waitqueue_active() is racey, but we sleep
+	 * with schedule_timeout anyway.
+	 */
+	if (cache_put(&c->cache, b) &&
+	    unlikely(waitqueue_active(&c->free_buffer_wait)))
+		wake_up(&c->free_buffer_wait);
+}
+
+/*
+ * This assumes you have already checked the cache to see if the buffer
+ * is already present (it will recheck after dropping the lock for allocation).
+ */
 static struct dm_buffer *__bufio_new(struct dm_bufio_client *c, sector_t block,
 				     enum new_flag nf, int *need_submit,
 				     struct list_head *write_list)
 {
 	struct dm_buffer *b, *new_b = NULL;
-
 	*need_submit = 0;
 
-	b = __find(c, block);
-	if (b)
-		goto found_buffer;
-
-	if (nf == NF_GET)
-		return NULL;
+	/* This can't be called with NF_GET */
+	BUG_ON(nf == NF_GET);
 
 	new_b = __alloc_buffer_wait(c, nf);
 	if (!new_b)
@@ -1040,7 +1762,7 @@ static struct dm_buffer *__bufio_new(struct dm_bufio_client *c, sector_t block,
 	 * We've had a period where the mutex was unlocked, so need to
 	 * recheck the buffer tree.
 	 */
-	b = __find(c, block);
+	b = cache_get(&c->cache, block);
 	if (b) {
 		__free_buffer_wake(new_b);
 		goto found_buffer;
@@ -1049,24 +1771,35 @@ static struct dm_buffer *__bufio_new(struct dm_bufio_client *c, sector_t block,
 	__check_watermark(c, write_list);
 
 	b = new_b;
-	b->hold_count = 1;
+	atomic_set(&b->hold_count, 1);
+	WRITE_ONCE(b->last_accessed, jiffies);
+	b->block = block;
 	b->read_error = 0;
 	b->write_error = 0;
-	__link_buffer(b, block, LIST_CLEAN);
+	b->list_mode = LIST_CLEAN;
 
-	if (nf == NF_FRESH) {
+	if (nf == NF_FRESH)
 		b->state = 0;
-		return b;
+	else {
+		b->state = 1 << B_READING;
+		*need_submit = 1;
 	}
 
-	b->state = 1 << B_READING;
-	*need_submit = 1;
+	/*
+	 * We mustn't insert into the cache until the B_READING state
+	 * is set.  Otherwise another thread could get it and use
+	 * it before it had been read.
+	 */
+	cache_insert(&c->cache, b);
 
 	return b;
 
 found_buffer:
-	if (nf == NF_PREFETCH)
+	if (nf == NF_PREFETCH) {
+		cache_put_and_wake(c, b);
 		return NULL;
+	}
+
 	/*
 	 * Note: it is essential that we don't wait for the buffer to be
 	 * read if dm_bufio_get function is used. Both dm_bufio_get and
@@ -1074,12 +1807,11 @@ static struct dm_buffer *__bufio_new(struct dm_bufio_client *c, sector_t block,
 	 * If the user called both dm_bufio_prefetch and dm_bufio_get on
 	 * the same buffer, it would deadlock if we waited.
 	 */
-	if (nf == NF_GET && unlikely(test_bit_acquire(B_READING, &b->state)))
+	if (nf == NF_GET && unlikely(test_bit_acquire(B_READING, &b->state))) {
+		cache_put_and_wake(c, b);
 		return NULL;
+	}
 
-	b->hold_count++;
-	__relink_lru(b, test_bit(B_DIRTY, &b->state) ||
-		     test_bit(B_WRITING, &b->state));
 	return b;
 }
 
@@ -1109,18 +1841,49 @@ static void read_endio(struct dm_buffer *b, blk_status_t status)
 static void *new_read(struct dm_bufio_client *c, sector_t block,
 		      enum new_flag nf, struct dm_buffer **bp)
 {
-	int need_submit;
+	int need_submit = 0;
 	struct dm_buffer *b;
 
 	LIST_HEAD(write_list);
+	*bp = NULL;
+
+	/*
+	 * Fast path, hopefully the block is already in the cache.  No need
+	 * to get the client lock for this.
+	 */
+	b = cache_get(&c->cache, block);
+	if (b) {
+		if (nf == NF_PREFETCH) {
+			cache_put_and_wake(c, b);
+			return NULL;
+		}
+
+		/*
+		 * Note: it is essential that we don't wait for the buffer to be
+		 * read if dm_bufio_get function is used. Both dm_bufio_get and
+		 * dm_bufio_prefetch can be used in the driver request routine.
+		 * If the user called both dm_bufio_prefetch and dm_bufio_get on
+		 * the same buffer, it would deadlock if we waited.
+		 */
+		if (nf == NF_GET && unlikely(test_bit_acquire(B_READING, &b->state))) {
+			cache_put_and_wake(c, b);
+			return NULL;
+		}
+	}
+
+	if (!b) {
+		if (nf == NF_GET)
+			return NULL;
+
+		dm_bufio_lock(c);
+		b = __bufio_new(c, block, nf, &need_submit, &write_list);
+		dm_bufio_unlock(c);
+	}
 
-	dm_bufio_lock(c);
-	b = __bufio_new(c, block, nf, &need_submit, &write_list);
 #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
-	if (b && b->hold_count == 1)
+	if (b && (atomic_read(&b->hold_count) == 1))
 		buffer_record_stack(b);
 #endif
-	dm_bufio_unlock(c);
 
 	__flush_write_list(&write_list);
 
@@ -1141,7 +1904,6 @@ static void *new_read(struct dm_bufio_client *c, sector_t block,
 	}
 
 	*bp = b;
-
 	return b->data;
 }
 
@@ -1156,7 +1918,6 @@ void *dm_bufio_read(struct dm_bufio_client *c, sector_t block,
 		    struct dm_buffer **bp)
 {
 	BUG_ON(dm_bufio_in_request());
-
 	return new_read(c, block, NF_READ, bp);
 }
 EXPORT_SYMBOL_GPL(dm_bufio_read);
@@ -1165,7 +1926,6 @@ void *dm_bufio_new(struct dm_bufio_client *c, sector_t block,
 		   struct dm_buffer **bp)
 {
 	BUG_ON(dm_bufio_in_request());
-
 	return new_read(c, block, NF_FRESH, bp);
 }
 EXPORT_SYMBOL_GPL(dm_bufio_new);
@@ -1180,12 +1940,19 @@ void dm_bufio_prefetch(struct dm_bufio_client *c,
 	BUG_ON(dm_bufio_in_request());
 
 	blk_start_plug(&plug);
-	dm_bufio_lock(c);
 
 	for (; n_blocks--; block++) {
 		int need_submit;
 		struct dm_buffer *b;
 
+		b = cache_get(&c->cache, block);
+		if (b) {
+			/* already in cache */
+			cache_put_and_wake(c, b);
+			continue;
+		}
+
+		dm_bufio_lock(c);
 		b = __bufio_new(c, block, NF_PREFETCH, &need_submit,
 				&write_list);
 		if (unlikely(!list_empty(&write_list))) {
@@ -1195,6 +1962,7 @@ void dm_bufio_prefetch(struct dm_bufio_client *c,
 			blk_start_plug(&plug);
 			dm_bufio_lock(c);
 		}
+
 		if (unlikely(b != NULL)) {
 			dm_bufio_unlock(c);
 
@@ -1208,10 +1976,9 @@ void dm_bufio_prefetch(struct dm_bufio_client *c,
 				goto flush_plug;
 			dm_bufio_lock(c);
 		}
+		dm_bufio_unlock(c);
 	}
 
-	dm_bufio_unlock(c);
-
 flush_plug:
 	blk_finish_plug(&plug);
 }
@@ -1221,29 +1988,28 @@ void dm_bufio_release(struct dm_buffer *b)
 {
 	struct dm_bufio_client *c = b->c;
 
-	dm_bufio_lock(c);
+	/*
+	 * If there were errors on the buffer, and the buffer is not
+	 * to be written, free the buffer. There is no point in caching
+	 * invalid buffer.
+	 */
+	if ((b->read_error || b->write_error) &&
+	    !test_bit_acquire(B_READING, &b->state) &&
+	    !test_bit(B_WRITING, &b->state) &&
+	    !test_bit(B_DIRTY, &b->state)) {
+		dm_bufio_lock(c);
 
-	BUG_ON(!b->hold_count);
-
-	b->hold_count--;
-	if (!b->hold_count) {
-		wake_up(&c->free_buffer_wait);
-
-		/*
-		 * If there were errors on the buffer, and the buffer is not
-		 * to be written, free the buffer. There is no point in caching
-		 * invalid buffer.
-		 */
-		if ((b->read_error || b->write_error) &&
-		    !test_bit_acquire(B_READING, &b->state) &&
-		    !test_bit(B_WRITING, &b->state) &&
-		    !test_bit(B_DIRTY, &b->state)) {
-			__unlink_buffer(b);
+		/* cache remove can fail if there are other holders */
+		if (cache_remove(&c->cache, b)) {
 			__free_buffer_wake(b);
+			dm_bufio_unlock(c);
+			return;
 		}
+
+		dm_bufio_unlock(c);
 	}
 
-	dm_bufio_unlock(c);
+	cache_put_and_wake(c, b);
 }
 EXPORT_SYMBOL_GPL(dm_bufio_release);
 
@@ -1262,7 +2028,7 @@ void dm_bufio_mark_partial_buffer_dirty(struct dm_buffer *b,
 	if (!test_and_set_bit(B_DIRTY, &b->state)) {
 		b->dirty_start = start;
 		b->dirty_end = end;
-		__relink_lru(b, LIST_DIRTY);
+		cache_mark(&c->cache, b, LIST_DIRTY);
 	} else {
 		if (start < b->dirty_start)
 			b->dirty_start = start;
@@ -1300,11 +2066,19 @@ EXPORT_SYMBOL_GPL(dm_bufio_write_dirty_buffers_async);
  *
  * Finally, we flush hardware disk cache.
  */
+static bool is_writing(struct lru_entry *e, void *context)
+{
+	struct dm_buffer *b = le_to_buffer(e);
+
+	return test_bit(B_WRITING, &b->state);
+}
+
 int dm_bufio_write_dirty_buffers(struct dm_bufio_client *c)
 {
 	int a, f;
-	unsigned long buffers_processed = 0;
-	struct dm_buffer *b, *tmp;
+	unsigned long nr_buffers;
+	struct lru_entry *e;
+	struct lru_iter it;
 
 	LIST_HEAD(write_list);
 
@@ -1314,52 +2088,32 @@ int dm_bufio_write_dirty_buffers(struct dm_bufio_client *c)
 	__flush_write_list(&write_list);
 	dm_bufio_lock(c);
 
-again:
-	list_for_each_entry_safe_reverse(b, tmp, &c->lru[LIST_DIRTY], lru_list) {
-		int dropped_lock = 0;
-
-		if (buffers_processed < c->n_buffers[LIST_DIRTY])
-			buffers_processed++;
+	nr_buffers = cache_count(&c->cache, LIST_DIRTY);
+	lru_iter_begin(&c->cache.lru[LIST_DIRTY], &it);
+	while ((e = lru_iter_next(&it, is_writing, c))) {
+		struct dm_buffer *b = le_to_buffer(e);
+		__cache_inc_buffer(b);
 
 		BUG_ON(test_bit(B_READING, &b->state));
 
-		if (test_bit(B_WRITING, &b->state)) {
-			if (buffers_processed < c->n_buffers[LIST_DIRTY]) {
-				dropped_lock = 1;
-				b->hold_count++;
-				dm_bufio_unlock(c);
-				wait_on_bit_io(&b->state, B_WRITING,
-					       TASK_UNINTERRUPTIBLE);
-				dm_bufio_lock(c);
-				b->hold_count--;
-			} else
-				wait_on_bit_io(&b->state, B_WRITING,
-					       TASK_UNINTERRUPTIBLE);
-		}
+		if (nr_buffers) {
+			nr_buffers--;
+			dm_bufio_unlock(c);
+			wait_on_bit_io(&b->state, B_WRITING, TASK_UNINTERRUPTIBLE);
+			dm_bufio_lock(c);
+		} else
+			wait_on_bit_io(&b->state, B_WRITING, TASK_UNINTERRUPTIBLE);
 
-		if (!test_bit(B_DIRTY, &b->state) &&
-		    !test_bit(B_WRITING, &b->state))
-			__relink_lru(b, LIST_CLEAN);
+		if (!test_bit(B_DIRTY, &b->state) && !test_bit(B_WRITING, &b->state))
+			cache_mark(&c->cache, b, LIST_CLEAN);
+
+		cache_put_and_wake(c, b);
 
 		cond_resched();
-
-		/*
-		 * If we dropped the lock, the list is no longer consistent,
-		 * so we must restart the search.
-		 *
-		 * In the most common case, the buffer just processed is
-		 * relinked to the clean list, so we won't loop scanning the
-		 * same buffer again and again.
-		 *
-		 * This may livelock if there is another thread simultaneously
-		 * dirtying buffers, so we count the number of buffers walked
-		 * and if it exceeds the total number of buffers, it means that
-		 * someone is doing some writes simultaneously with us.  In
-		 * this case, stop, dropping the lock.
-		 */
-		if (dropped_lock)
-			goto again;
 	}
+
+	lru_iter_end(&it);
+
 	wake_up(&c->free_buffer_wait);
 	dm_bufio_unlock(c);
 
@@ -1418,12 +2172,22 @@ int dm_bufio_issue_discard(struct dm_bufio_client *c, sector_t block, sector_t c
 }
 EXPORT_SYMBOL_GPL(dm_bufio_issue_discard);
 
-static void forget_buffer_locked(struct dm_buffer *b)
+static bool forget_buffer(struct dm_bufio_client *c, sector_t block)
 {
-	if (likely(!b->hold_count) && likely(!smp_load_acquire(&b->state))) {
-		__unlink_buffer(b);
-		__free_buffer_wake(b);
+	struct dm_buffer *b;
+
+	b = cache_get(&c->cache, block);
+	if (b) {
+		if (likely(!smp_load_acquire(&b->state))) {
+			if (cache_remove(&c->cache, b))
+				__free_buffer_wake(b);
+			else
+				cache_put_and_wake(c, b);
+		} else
+			cache_put_and_wake(c, b);
 	}
+
+	return b ? true : false;
 }
 
 /*
@@ -1434,38 +2198,22 @@ static void forget_buffer_locked(struct dm_buffer *b)
  */
 void dm_bufio_forget(struct dm_bufio_client *c, sector_t block)
 {
-	struct dm_buffer *b;
-
 	dm_bufio_lock(c);
-
-	b = __find(c, block);
-	if (b)
-		forget_buffer_locked(b);
-
+	forget_buffer(c, block);
 	dm_bufio_unlock(c);
 }
 EXPORT_SYMBOL_GPL(dm_bufio_forget);
 
+static enum evict_result idle(struct dm_buffer *b, void *context)
+{
+	return b->state ? ER_DONT_EVICT : ER_EVICT;
+}
+
 void dm_bufio_forget_buffers(struct dm_bufio_client *c, sector_t block, sector_t n_blocks)
 {
-	struct dm_buffer *b;
-	sector_t end_block = block + n_blocks;
-
-	while (block < end_block) {
-		dm_bufio_lock(c);
-
-		b = __find_next(c, block);
-		if (b) {
-			block = b->block + 1;
-			forget_buffer_locked(b);
-		}
-
-		dm_bufio_unlock(c);
-
-		if (!b)
-			break;
-	}
-
+	dm_bufio_lock(c);
+	cache_remove_range(&c->cache, block, block + n_blocks, idle, __free_buffer_wake);
+	dm_bufio_unlock(c);
 }
 EXPORT_SYMBOL_GPL(dm_bufio_forget_buffers);
 
@@ -1527,11 +2275,26 @@ struct dm_bufio_client *dm_bufio_get_client(struct dm_buffer *b)
 }
 EXPORT_SYMBOL_GPL(dm_bufio_get_client);
 
+static enum it_action warn_leak(struct dm_buffer *b, void *context)
+{
+	bool *warned = context;
+
+	WARN_ON(!(*warned));
+	*warned = true;
+	DMERR("leaked buffer %llx, hold count %u, list %d",
+	      (unsigned long long)b->block, atomic_read(&b->hold_count), b->list_mode);
+#ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
+	stack_trace_print(b->stack_entries, b->stack_len, 1);
+	/* mark unclaimed to avoid BUG_ON below */
+	atomic_set(&b->hold_count, 0);
+#endif
+	return IT_NEXT;
+}
+
 static void drop_buffers(struct dm_bufio_client *c)
 {
-	struct dm_buffer *b;
 	int i;
-	bool warned = false;
+	struct dm_buffer *b;
 
 	BUG_ON(dm_bufio_in_request());
 
@@ -1545,18 +2308,11 @@ static void drop_buffers(struct dm_bufio_client *c)
 	while ((b = __get_unclaimed_buffer(c)))
 		__free_buffer_wake(b);
 
-	for (i = 0; i < LIST_SIZE; i++)
-		list_for_each_entry(b, &c->lru[i], lru_list) {
-			WARN_ON(!warned);
-			warned = true;
-			DMERR("leaked buffer %llx, hold count %u, list %d",
-			      (unsigned long long)b->block, b->hold_count, i);
-#ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
-			stack_trace_print(b->stack_entries, b->stack_len, 1);
-			/* mark unclaimed to avoid BUG_ON below */
-			b->hold_count = 0;
-#endif
-		}
+	for (i = 0; i < LIST_SIZE; i++) {
+		bool warned = false;
+
+		cache_iterate(&c->cache, i, warn_leak, &warned);
+	}
 
 #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
 	while ((b = __get_unclaimed_buffer(c)))
@@ -1564,39 +2320,11 @@ static void drop_buffers(struct dm_bufio_client *c)
 #endif
 
 	for (i = 0; i < LIST_SIZE; i++)
-		BUG_ON(!list_empty(&c->lru[i]));
+		BUG_ON(cache_count(&c->cache, i));
 
 	dm_bufio_unlock(c);
 }
 
-/*
- * We may not be able to evict this buffer if IO pending or the client
- * is still using it.  Caller is expected to know buffer is too old.
- *
- * And if GFP_NOFS is used, we must not do any I/O because we hold
- * dm_bufio_clients_lock and we would risk deadlock if the I/O gets
- * rerouted to different bufio client.
- */
-static bool __try_evict_buffer(struct dm_buffer *b, gfp_t gfp)
-{
-	if (!(gfp & __GFP_FS) ||
-	    (static_branch_unlikely(&no_sleep_enabled) && b->c->no_sleep)) {
-		if (test_bit_acquire(B_READING, &b->state) ||
-		    test_bit(B_WRITING, &b->state) ||
-		    test_bit(B_DIRTY, &b->state))
-			return false;
-	}
-
-	if (b->hold_count)
-		return false;
-
-	__make_buffer_clean(b);
-	__unlink_buffer(b);
-	__free_buffer_wake(b);
-
-	return true;
-}
-
 static unsigned long get_retain_buffers(struct dm_bufio_client *c)
 {
 	unsigned long retain_bytes = READ_ONCE(dm_bufio_retain_bytes);
@@ -1612,22 +2340,30 @@ static unsigned long get_retain_buffers(struct dm_bufio_client *c)
 static void __scan(struct dm_bufio_client *c)
 {
 	int l;
-	struct dm_buffer *b, *tmp;
+	struct dm_buffer *b;
 	unsigned long freed = 0;
-	unsigned long count = c->n_buffers[LIST_CLEAN] +
-			      c->n_buffers[LIST_DIRTY];
 	unsigned long retain_target = get_retain_buffers(c);
+	unsigned long count = cache_total(&c->cache);
 
 	for (l = 0; l < LIST_SIZE; l++) {
-		list_for_each_entry_safe_reverse(b, tmp, &c->lru[l], lru_list) {
+		while (true) {
 			if (count - freed <= retain_target)
 				atomic_long_set(&c->need_shrink, 0);
+
 			if (!atomic_long_read(&c->need_shrink))
-				return;
-			if (__try_evict_buffer(b, GFP_KERNEL)) {
-				atomic_long_dec(&c->need_shrink);
-				freed++;
-			}
+				break;
+
+			b = cache_evict(&c->cache, l,
+					l == LIST_CLEAN ? is_clean : is_dirty, c);
+			if (!b)
+				break;
+
+			BUG_ON(b->list_mode != l);
+			__make_buffer_clean(b);
+			__free_buffer_wake(b);
+
+			atomic_long_dec(&c->need_shrink);
+			freed++;
 			cond_resched();
 		}
 	}
@@ -1656,8 +2392,7 @@ static unsigned long dm_bufio_shrink_scan(struct shrinker *shrink, struct shrink
 static unsigned long dm_bufio_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct dm_bufio_client *c = container_of(shrink, struct dm_bufio_client, shrinker);
-	unsigned long count = READ_ONCE(c->n_buffers[LIST_CLEAN]) +
-			      READ_ONCE(c->n_buffers[LIST_DIRTY]);
+	unsigned long count = cache_total(&c->cache);
 	unsigned long retain_target = get_retain_buffers(c);
 	unsigned long queued_for_cleanup = atomic_long_read(&c->need_shrink);
 
@@ -1685,7 +2420,6 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 {
 	int r;
 	struct dm_bufio_client *c;
-	unsigned int i;
 	char slab_name[27];
 
 	if (!block_size || block_size & ((1 << SECTOR_SHIFT) - 1)) {
@@ -1699,7 +2433,7 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 		r = -ENOMEM;
 		goto bad_client;
 	}
-	c->buffer_tree = RB_ROOT;
+	cache_init(&c->cache);
 
 	c->bdev = bdev;
 	c->block_size = block_size;
@@ -1716,11 +2450,6 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 		static_branch_inc(&no_sleep_enabled);
 	}
 
-	for (i = 0; i < LIST_SIZE; i++) {
-		INIT_LIST_HEAD(&c->lru[i]);
-		c->n_buffers[i] = 0;
-	}
-
 	mutex_init(&c->lock);
 	spin_lock_init(&c->spinlock);
 	INIT_LIST_HEAD(&c->reserved_buffers);
@@ -1792,9 +2521,9 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 
 bad:
 	while (!list_empty(&c->reserved_buffers)) {
-		struct dm_buffer *b = list_entry(c->reserved_buffers.next,
-						 struct dm_buffer, lru_list);
-		list_del(&b->lru_list);
+		struct dm_buffer *b = list_to_buffer(c->reserved_buffers.next);
+
+		list_del(&b->lru.list);
 		free_buffer(b);
 	}
 	kmem_cache_destroy(c->slab_cache);
@@ -1831,23 +2560,23 @@ void dm_bufio_client_destroy(struct dm_bufio_client *c)
 
 	mutex_unlock(&dm_bufio_clients_lock);
 
-	BUG_ON(!RB_EMPTY_ROOT(&c->buffer_tree));
 	BUG_ON(c->need_reserved_buffers);
 
 	while (!list_empty(&c->reserved_buffers)) {
-		struct dm_buffer *b = list_entry(c->reserved_buffers.next,
-						 struct dm_buffer, lru_list);
-		list_del(&b->lru_list);
+		struct dm_buffer *b = list_to_buffer(c->reserved_buffers.next);
+
+		list_del(&b->lru.list);
 		free_buffer(b);
 	}
 
 	for (i = 0; i < LIST_SIZE; i++)
-		if (c->n_buffers[i])
-			DMERR("leaked buffer count %d: %ld", i, c->n_buffers[i]);
+		if (cache_count(&c->cache, i))
+			DMERR("leaked buffer count %d: %lu", i, cache_count(&c->cache, i));
 
 	for (i = 0; i < LIST_SIZE; i++)
-		BUG_ON(c->n_buffers[i]);
+		BUG_ON(cache_count(&c->cache, i));
 
+	cache_destroy(&c->cache);
 	kmem_cache_destroy(c->slab_cache);
 	kmem_cache_destroy(c->slab_buffer);
 	dm_io_client_destroy(c->dm_io);
@@ -1864,6 +2593,8 @@ void dm_bufio_set_sector_offset(struct dm_bufio_client *c, sector_t start)
 }
 EXPORT_SYMBOL_GPL(dm_bufio_set_sector_offset);
 
+/*--------------------------------------------------------------*/
+
 static unsigned int get_max_age_hz(void)
 {
 	unsigned int max_age = READ_ONCE(dm_bufio_max_age);
@@ -1876,13 +2607,74 @@ static unsigned int get_max_age_hz(void)
 
 static bool older_than(struct dm_buffer *b, unsigned long age_hz)
 {
-	return time_after_eq(jiffies, b->last_accessed + age_hz);
+	return time_after_eq(jiffies, READ_ONCE(b->last_accessed) + age_hz);
 }
 
-static void __evict_old_buffers(struct dm_bufio_client *c, unsigned long age_hz)
+struct evict_params {
+	gfp_t gfp;
+	unsigned long age_hz;
+
+	/*
+	 * This gets updated with the largest last_accessed (ie. most
+	 * recently used) of the evicted buffers.  It will not be reinitialised
+	 * by __evict_many(), so you can use it across multiple invocations.
+	 */
+	unsigned long last_accessed;
+};
+
+/*
+ * We may not be able to evict this buffer if IO pending or the client
+ * is still using it.
+ *
+ * And if GFP_NOFS is used, we must not do any I/O because we hold
+ * dm_bufio_clients_lock and we would risk deadlock if the I/O gets
+ * rerouted to different bufio client.
+ */
+static enum evict_result select_for_evict(struct dm_buffer *b, void *context)
+{
+	struct evict_params *params = context;
+
+	if (!(params->gfp & __GFP_FS) ||
+	    (static_branch_unlikely(&no_sleep_enabled) && b->c->no_sleep)) {
+		if (test_bit_acquire(B_READING, &b->state) ||
+		    test_bit(B_WRITING, &b->state) ||
+		    test_bit(B_DIRTY, &b->state))
+			return ER_DONT_EVICT;
+	}
+
+	return older_than(b, params->age_hz) ? ER_EVICT : ER_STOP;
+}
+
+static unsigned long __evict_many(struct dm_bufio_client *c,
+				  struct evict_params *params,
+				  int list_mode, unsigned long max_count)
+{
+	unsigned long count;
+	unsigned long last_accessed;
+	struct dm_buffer *b;
+
+	for (count = 0; count < max_count; count++) {
+		b = cache_evict(&c->cache, list_mode, select_for_evict, params);
+		if (!b)
+			break;
+
+		last_accessed = READ_ONCE(b->last_accessed);
+		if (time_after_eq(params->last_accessed, last_accessed))
+			params->last_accessed = last_accessed;
+
+		__make_buffer_clean(b);
+		__free_buffer_wake(b);
+
+		cond_resched();
+	}
+
+	return count;
+}
+
+static void evict_old_buffers(struct dm_bufio_client *c, unsigned long age_hz)
 {
-	struct dm_buffer *b, *tmp;
-	unsigned long retain_target = get_retain_buffers(c);
+	struct evict_params params = {.gfp = 0, .age_hz = age_hz, .last_accessed = 0};
+	unsigned long retain = get_retain_buffers(c);
 	unsigned long count;
 	LIST_HEAD(write_list);
 
@@ -1895,91 +2687,13 @@ static void __evict_old_buffers(struct dm_bufio_client *c, unsigned long age_hz)
 		dm_bufio_lock(c);
 	}
 
-	count = c->n_buffers[LIST_CLEAN] + c->n_buffers[LIST_DIRTY];
-	list_for_each_entry_safe_reverse(b, tmp, &c->lru[LIST_CLEAN], lru_list) {
-		if (count <= retain_target)
-			break;
-
-		if (!older_than(b, age_hz))
-			break;
-
-		if (__try_evict_buffer(b, 0))
-			count--;
-
-		cond_resched();
-	}
+	count = cache_total(&c->cache);
+	if (count > retain)
+		__evict_many(c, &params, LIST_CLEAN, count - retain);
 
 	dm_bufio_unlock(c);
 }
 
-static void do_global_cleanup(struct work_struct *w)
-{
-	struct dm_bufio_client *locked_client = NULL;
-	struct dm_bufio_client *current_client;
-	struct dm_buffer *b;
-	unsigned int spinlock_hold_count;
-	unsigned long threshold = dm_bufio_cache_size -
-		dm_bufio_cache_size / DM_BUFIO_LOW_WATERMARK_RATIO;
-	unsigned long loops = global_num * 2;
-
-	mutex_lock(&dm_bufio_clients_lock);
-
-	while (1) {
-		cond_resched();
-
-		spin_lock(&global_spinlock);
-		if (unlikely(dm_bufio_current_allocated <= threshold))
-			break;
-
-		spinlock_hold_count = 0;
-get_next:
-		if (!loops--)
-			break;
-		if (unlikely(list_empty(&global_queue)))
-			break;
-		b = list_entry(global_queue.prev, struct dm_buffer, global_list);
-
-		if (b->accessed) {
-			b->accessed = 0;
-			list_move(&b->global_list, &global_queue);
-			if (likely(++spinlock_hold_count < 16))
-				goto get_next;
-			spin_unlock(&global_spinlock);
-			continue;
-		}
-
-		current_client = b->c;
-		if (unlikely(current_client != locked_client)) {
-			if (locked_client)
-				dm_bufio_unlock(locked_client);
-
-			if (!dm_bufio_trylock(current_client)) {
-				spin_unlock(&global_spinlock);
-				dm_bufio_lock(current_client);
-				locked_client = current_client;
-				continue;
-			}
-
-			locked_client = current_client;
-		}
-
-		spin_unlock(&global_spinlock);
-
-		if (unlikely(!__try_evict_buffer(b, GFP_KERNEL))) {
-			spin_lock(&global_spinlock);
-			list_move(&b->global_list, &global_queue);
-			spin_unlock(&global_spinlock);
-		}
-	}
-
-	spin_unlock(&global_spinlock);
-
-	if (locked_client)
-		dm_bufio_unlock(locked_client);
-
-	mutex_unlock(&dm_bufio_clients_lock);
-}
-
 static void cleanup_old_buffers(void)
 {
 	unsigned long max_age_hz = get_max_age_hz();
@@ -1990,7 +2704,7 @@ static void cleanup_old_buffers(void)
 	__cache_size_refresh();
 
 	list_for_each_entry(c, &dm_bufio_all_clients, client_list)
-		__evict_old_buffers(c, max_age_hz);
+		evict_old_buffers(c, max_age_hz);
 
 	mutex_unlock(&dm_bufio_clients_lock);
 }
@@ -2003,6 +2717,107 @@ static void work_fn(struct work_struct *w)
 			   DM_BUFIO_WORK_TIMER_SECS * HZ);
 }
 
+/*--------------------------------------------------------------*/
+
+/*
+ * Global cleanup tries to evict the oldest buffers from across _all_
+ * the clients.  It does this by repeatedly evicting a few buffers from
+ * the client that holds the oldest buffer.  It's approximate, but hopefully
+ * good enough.
+ */
+static struct dm_bufio_client *__pop_client(void)
+{
+	struct list_head *h;
+
+	if (list_empty(&dm_bufio_all_clients))
+		return NULL;
+
+	h = dm_bufio_all_clients.next;
+	list_del(h);
+	return container_of(h, struct dm_bufio_client, client_list);
+}
+
+/*
+ * Inserts the client in the global client list based on its
+ * 'oldest_buffer' field.
+ */
+static void __insert_client(struct dm_bufio_client *new_client)
+{
+	struct dm_bufio_client *c;
+	struct list_head *h = dm_bufio_all_clients.next;
+
+	while (h != &dm_bufio_all_clients) {
+		c = container_of(h, struct dm_bufio_client, client_list);
+		if (time_after_eq(c->oldest_buffer, new_client->oldest_buffer))
+			break;
+		h = h->next;
+	}
+
+	list_add_tail(&new_client->client_list, h);
+}
+
+static unsigned long __evict_a_few(unsigned long nr_buffers)
+{
+	unsigned long count;
+	struct dm_bufio_client *c;
+	struct evict_params params = {
+		.gfp = GFP_KERNEL,
+		.age_hz = 0,
+		/* set to jiffies in case there are no buffers in this client */
+		.last_accessed = jiffies
+	};
+
+	c = __pop_client();
+	if (!c)
+		return 0;
+
+	dm_bufio_lock(c);
+	count = __evict_many(c, &params, LIST_CLEAN, nr_buffers);
+	dm_bufio_unlock(c);
+
+	if (count)
+		c->oldest_buffer = params.last_accessed;
+	__insert_client(c);
+
+	return count;
+}
+
+static void check_watermarks(void)
+{
+	LIST_HEAD(write_list);
+	struct dm_bufio_client *c;
+
+	mutex_lock(&dm_bufio_clients_lock);
+	list_for_each_entry(c, &dm_bufio_all_clients, client_list) {
+		dm_bufio_lock(c);
+		__check_watermark(c, &write_list);
+		dm_bufio_unlock(c);
+	}
+	mutex_unlock(&dm_bufio_clients_lock);
+
+	__flush_write_list(&write_list);
+}
+
+static void evict_old(void)
+{
+	unsigned long threshold = dm_bufio_cache_size -
+		dm_bufio_cache_size / DM_BUFIO_LOW_WATERMARK_RATIO;
+
+	mutex_lock(&dm_bufio_clients_lock);
+	while (dm_bufio_current_allocated > threshold) {
+		if (!__evict_a_few(64))
+			break;
+		cond_resched();
+	}
+	mutex_unlock(&dm_bufio_clients_lock);
+}
+
+static void do_global_cleanup(struct work_struct *w)
+{
+	check_watermarks();
+	evict_old();
+}
+
 /*
  *--------------------------------------------------------------
  * Module setup
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

