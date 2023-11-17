Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB6730F99
	for <dm-devel@lists.linux.dev>; Fri, 17 Nov 2023 17:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZyL1yQC6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700242598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IGlVPE10HljIvOZpQWFy+KcXQQhfWBJ9CYYIYIh5iLo=;
	b=ZyL1yQC62mwx6cAXKlU5sNEzsTJEcMnHrot06R4Cm5R1iZisLCc3g7D+MhlcUXG1ocuidY
	dbUFmhpI8HyTrCsisdWf8RRgeNe8Dl5cGgN74LEI53JuJ0ZnIQHJ/dfhFOuGg+Crls2uq6
	T9jD9SovhPC2RMlZdVfIklDs/4sZNdU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-s9qILTwzOfuoFX7NGXjolg-1; Fri, 17 Nov 2023 12:36:35 -0500
X-MC-Unique: s9qILTwzOfuoFX7NGXjolg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB37F81B161;
	Fri, 17 Nov 2023 17:36:34 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C0A2B1121306;
	Fri, 17 Nov 2023 17:36:34 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id AD31430C1A8C; Fri, 17 Nov 2023 17:36:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id AA85B3FB76;
	Fri, 17 Nov 2023 18:36:34 +0100 (CET)
Date: Fri, 17 Nov 2023 18:36:34 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>
cc: Joe Thornber <thornber@redhat.com>, Milan Broz <gmazyland@gmail.com>, 
    Nathan Huckleberry <nhuck@google.com>, dm-devel@lists.linux.dev
Subject: [PATCH 1/2] dm-bufio: fix no-sleep mode
In-Reply-To: <3bd19ce6-2f60-548f-acd7-cb98aa308661@redhat.com>
Message-ID: <57423ca-2ea-e688-7764-37c5b4b15dc4@redhat.com>
References: <3bd19ce6-2f60-548f-acd7-cb98aa308661@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

dm-bufio has a no-sleep mode. When activated (with the
DM_BUFIO_CLIENT_NO_SLEEP flag), the bufio client is read-only and we
could call dm_bufio_get from tasklets. This is used by dm-verity.

Unfortunatelly, the commit 450e8dee51aa broke this and the kernel would
warn that cache_get() was calling down_read() from no-sleeping context.
The bug can be reproduced by using "veritysetup open" with the
"--use-tasklets" flag.

This patch fixes dm-bufio, so that the tasklet mode works again.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v6.4
Fixes: 450e8dee51aa ("dm bufio: improve concurrent IO performance")

---
 drivers/md/dm-bufio.c |   87 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 62 insertions(+), 25 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c	2023-11-17 16:08:08.000000000 +0100
+++ linux-2.6/drivers/md/dm-bufio.c	2023-11-17 18:29:47.000000000 +0100
@@ -254,7 +254,7 @@ enum evict_result {
 
 typedef enum evict_result (*le_predicate)(struct lru_entry *le, void *context);
 
-static struct lru_entry *lru_evict(struct lru *lru, le_predicate pred, void *context)
+static struct lru_entry *lru_evict(struct lru *lru, le_predicate pred, void *context, bool no_sleep)
 {
 	unsigned long tested = 0;
 	struct list_head *h = lru->cursor;
@@ -295,7 +295,8 @@ static struct lru_entry *lru_evict(struc
 
 		h = h->next;
 
-		cond_resched();
+		if (!no_sleep)
+			cond_resched();
 	}
 
 	return NULL;
@@ -382,7 +383,10 @@ struct dm_buffer {
  */
 
 struct buffer_tree {
-	struct rw_semaphore lock;
+	union {
+		struct rw_semaphore lock;
+		rwlock_t spinlock;
+	} u;
 	struct rb_root root;
 } ____cacheline_aligned_in_smp;
 
@@ -393,9 +397,12 @@ struct dm_buffer_cache {
 	 * on the locks.
 	 */
 	unsigned int num_locks;
+	bool no_sleep;
 	struct buffer_tree trees[];
 };
 
+static DEFINE_STATIC_KEY_FALSE(no_sleep_enabled);
+
 static inline unsigned int cache_index(sector_t block, unsigned int num_locks)
 {
 	return dm_hash_locks_index(block, num_locks);
@@ -403,22 +410,34 @@ static inline unsigned int cache_index(s
 
 static inline void cache_read_lock(struct dm_buffer_cache *bc, sector_t block)
 {
-	down_read(&bc->trees[cache_index(block, bc->num_locks)].lock);
+	if (static_branch_unlikely(&no_sleep_enabled) && bc->no_sleep)
+		read_lock_bh(&bc->trees[cache_index(block, bc->num_locks)].u.spinlock);
+	else
+		down_read(&bc->trees[cache_index(block, bc->num_locks)].u.lock);
 }
 
 static inline void cache_read_unlock(struct dm_buffer_cache *bc, sector_t block)
 {
-	up_read(&bc->trees[cache_index(block, bc->num_locks)].lock);
+	if (static_branch_unlikely(&no_sleep_enabled) && bc->no_sleep)
+		read_unlock_bh(&bc->trees[cache_index(block, bc->num_locks)].u.spinlock);
+	else
+		up_read(&bc->trees[cache_index(block, bc->num_locks)].u.lock);
 }
 
 static inline void cache_write_lock(struct dm_buffer_cache *bc, sector_t block)
 {
-	down_write(&bc->trees[cache_index(block, bc->num_locks)].lock);
+	if (static_branch_unlikely(&no_sleep_enabled) && bc->no_sleep)
+		write_lock_bh(&bc->trees[cache_index(block, bc->num_locks)].u.spinlock);
+	else
+		down_write(&bc->trees[cache_index(block, bc->num_locks)].u.lock);
 }
 
 static inline void cache_write_unlock(struct dm_buffer_cache *bc, sector_t block)
 {
-	up_write(&bc->trees[cache_index(block, bc->num_locks)].lock);
+	if (static_branch_unlikely(&no_sleep_enabled) && bc->no_sleep)
+		write_unlock_bh(&bc->trees[cache_index(block, bc->num_locks)].u.spinlock);
+	else
+		up_write(&bc->trees[cache_index(block, bc->num_locks)].u.lock);
 }
 
 /*
@@ -442,18 +461,32 @@ static void lh_init(struct lock_history
 
 static void __lh_lock(struct lock_history *lh, unsigned int index)
 {
-	if (lh->write)
-		down_write(&lh->cache->trees[index].lock);
-	else
-		down_read(&lh->cache->trees[index].lock);
+	if (lh->write) {
+		if (static_branch_unlikely(&no_sleep_enabled) && lh->cache->no_sleep)
+			write_lock_bh(&lh->cache->trees[index].u.spinlock);
+		else
+			down_write(&lh->cache->trees[index].u.lock);
+	} else {
+		if (static_branch_unlikely(&no_sleep_enabled) && lh->cache->no_sleep)
+			read_lock_bh(&lh->cache->trees[index].u.spinlock);
+		else
+			down_read(&lh->cache->trees[index].u.lock);
+	}
 }
 
 static void __lh_unlock(struct lock_history *lh, unsigned int index)
 {
-	if (lh->write)
-		up_write(&lh->cache->trees[index].lock);
-	else
-		up_read(&lh->cache->trees[index].lock);
+	if (lh->write) {
+		if (static_branch_unlikely(&no_sleep_enabled) && lh->cache->no_sleep)
+			write_unlock_bh(&lh->cache->trees[index].u.spinlock);
+		else
+			up_write(&lh->cache->trees[index].u.lock);
+	} else {
+		if (static_branch_unlikely(&no_sleep_enabled) && lh->cache->no_sleep)
+			read_unlock_bh(&lh->cache->trees[index].u.spinlock);
+		else
+			up_read(&lh->cache->trees[index].u.lock);
+	}
 }
 
 /*
@@ -502,14 +535,18 @@ static struct dm_buffer *list_to_buffer(
 	return le_to_buffer(le);
 }
 
-static void cache_init(struct dm_buffer_cache *bc, unsigned int num_locks)
+static void cache_init(struct dm_buffer_cache *bc, unsigned int num_locks, bool no_sleep)
 {
 	unsigned int i;
 
 	bc->num_locks = num_locks;
+	bc->no_sleep = no_sleep;
 
 	for (i = 0; i < bc->num_locks; i++) {
-		init_rwsem(&bc->trees[i].lock);
+		if (no_sleep)
+			rwlock_init(&bc->trees[i].u.spinlock);
+		else
+			init_rwsem(&bc->trees[i].u.lock);
 		bc->trees[i].root = RB_ROOT;
 	}
 
@@ -648,7 +685,7 @@ static struct dm_buffer *__cache_evict(s
 	struct lru_entry *le;
 	struct dm_buffer *b;
 
-	le = lru_evict(&bc->lru[list_mode], __evict_pred, &w);
+	le = lru_evict(&bc->lru[list_mode], __evict_pred, &w, bc->no_sleep);
 	if (!le)
 		return NULL;
 
@@ -702,7 +739,7 @@ static void __cache_mark_many(struct dm_
 	struct evict_wrapper w = {.lh = lh, .pred = pred, .context = context};
 
 	while (true) {
-		le = lru_evict(&bc->lru[old_mode], __evict_pred, &w);
+		le = lru_evict(&bc->lru[old_mode], __evict_pred, &w, bc->no_sleep);
 		if (!le)
 			break;
 
@@ -915,10 +952,11 @@ static void cache_remove_range(struct dm
 {
 	unsigned int i;
 
+	BUG_ON(bc->no_sleep);
 	for (i = 0; i < bc->num_locks; i++) {
-		down_write(&bc->trees[i].lock);
+		down_write(&bc->trees[i].u.lock);
 		__remove_range(bc, &bc->trees[i].root, begin, end, pred, release);
-		up_write(&bc->trees[i].lock);
+		up_write(&bc->trees[i].u.lock);
 	}
 }
 
@@ -979,8 +1017,6 @@ struct dm_bufio_client {
 	struct dm_buffer_cache cache; /* must be last member */
 };
 
-static DEFINE_STATIC_KEY_FALSE(no_sleep_enabled);
-
 /*----------------------------------------------------------------*/
 
 #define dm_bufio_in_request()	(!!current->bio_list)
@@ -1871,7 +1907,8 @@ static void *new_read(struct dm_bufio_cl
 	if (need_submit)
 		submit_io(b, REQ_OP_READ, read_endio);
 
-	wait_on_bit_io(&b->state, B_READING, TASK_UNINTERRUPTIBLE);
+	if (nf != NF_GET)	/* we already tested this condition above */
+		wait_on_bit_io(&b->state, B_READING, TASK_UNINTERRUPTIBLE);
 
 	if (b->read_error) {
 		int error = blk_status_to_errno(b->read_error);
@@ -2421,7 +2458,7 @@ struct dm_bufio_client *dm_bufio_client_
 		r = -ENOMEM;
 		goto bad_client;
 	}
-	cache_init(&c->cache, num_locks);
+	cache_init(&c->cache, num_locks, (flags & DM_BUFIO_CLIENT_NO_SLEEP) != 0);
 
 	c->bdev = bdev;
 	c->block_size = block_size;

