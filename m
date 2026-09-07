Received: from mail.stuffedcow.net (mail.stuffedcow.net [38.49.217.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31F6384CD6
	for <dm-devel@lists.linux.dev>; Mon,  7 Sep 2026 21:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=38.49.217.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788817613; cv=none; b=JxhKzjhsxINUsQbswl5ZVYUCpZJjYhxt7WAJ5paUr40P1BGrjU0bAhois28QyTUwJVoZGfGC+gmlnyqo8L9frH3sg7n9x4IJZvkhgr6Bmt4tytMeUvRxDOEv6YgvRAApT6hVGr/AvfppAl8/1tflceQtvf1qVcElC1eURfFBwKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788817613; c=relaxed/simple;
	bh=N06VxEFZrP3n7gYkbRQ20f/cnV6HsRvZ53CmfsQejec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cTsMNZ62DevSJwyLRonXH6ee6q2DUKM94A1XMkPw2HG/KSuYqeGOGyx9t1X8U6BROZ/zacydUdx+s8B1yjT2bPS1wkz0phmhQY4PbxKKYD8BImkqJp9uhoS6Vfo8XHAkROuDRrL643RwllC7TAxKZxrQm4PZ9fHWR902ZhuEv14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stuffedcow.net; spf=pass smtp.mailfrom=stuffedcow.net; arc=none smtp.client-ip=38.49.217.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stuffedcow.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stuffedcow.net
Received: from henry2.or.stuffedcow.lan (henry2.or.stuffedcow.lan [192.168.1.227])
	by mail.stuffedcow.net (Postfix) with ESMTP id 825601E0EA8;
	Mon, 07 Sep 2026 17:46:50 -0400 (EDT)
From: Henry Wong <henry@stuffedcow.net>
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com
Subject: [PATCH 2/2] dm-writecache: Add evict_clean_blocks option to allow read hits on clean blocks
Date: Mon,  7 Sep 2026 14:46:48 -0700
Message-ID: <20260907214648.3691695-3-henry@stuffedcow.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260907214648.3691695-1-henry@stuffedcow.net>
References: <20260907214648.3691695-1-henry@stuffedcow.net>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the current dm-writecache, there is a trade-off in setting the watermark levels
because cache blocks are evicted as soon as they have been written back:
Setting it low writes back sooner and keeps more free entries to absorb a larger write
burst, but setting it high retains more recently-written data to increase read hits.

This patch adds the ability to retain clean blocks in the rbtree so cache blocks can
serve read hits even after writing back. This allows writing back dirty data early to
make space for a large write burst AND using the entire cache capacity to service reads
until that write burst actually arrives.

This adds a new "clean" state to a cache block, but does not modify the eviction policy
(still roughly FIFO), and read hits do not affect when a cache block is invalidated and
recycled. Read hits are still opportunistic best-effort.

When a cache block is reused for a new write, it needs to be removed from the rbtree
and then re-inserted for the new block. The current behaviour (evict_clean_blocks=1)
removes the block from the rbtree in the writeback thread as soon as writeback is done.
This patch adds the option of deferring the rbtree removal until the cache block is
popped off the free list, immediately before reuse. The "clean" state represents a
cache block has has been put back onto the free list, but is still in the rbtree.

The write_in_progress bit has been removed and rolled into a new enum of cache states:
  WC_INVALID:            in free list,     not in rbtree
  WC_VALID_DIRTY:        not in free list, in rbtree, write_in_progress=0
  WC_VALID_WRITING_BACK: not in free list, in rbtree, write_in_progress=1
  WC_VALID_CLEAN:        in free list,     in rbtree (New state)

Signed-off-by: Henry Wong <henry@stuffedcow.net>
---
 .../admin-guide/device-mapper/writecache.rst  |  19 ++-
 drivers/md/Kconfig                            |   5 +-
 drivers/md/dm-writecache.c                    | 148 ++++++++++++------
 3 files changed, 123 insertions(+), 49 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/writecache.rst b/Documentation/admin-guide/device-mapper/writecache.rst
index 60c16b7fd5ac..d32551d986b0 100644
--- a/Documentation/admin-guide/device-mapper/writecache.rst
+++ b/Documentation/admin-guide/device-mapper/writecache.rst
@@ -2,9 +2,11 @@
 Writecache target
 =================
 
-The writecache target caches writes on persistent memory or on SSD. It
-doesn't cache reads because reads are supposed to be cached in page cache
-in normal RAM.
+The writecache target caches writes on persistent memory or on SSD.
+Although writecache is mainly intended to buffer bursts of writes and then
+drain them over time to slower storage, it also has read caching effects.
+Read requests that miss the in-memory page cache but hit recently-written
+data in the writecache will be served as a cache hit from the writecache.
 
 When the device is constructed, the first sector should be zeroed or the
 first sector should contain valid superblock from previous invocation.
@@ -73,6 +75,17 @@ Constructor parameters:
 	pause_writeback n	(default: 3000)
 		pause writeback if there was some write I/O redirected to
 		the origin volume in the last n milliseconds
+	evict_clean_blocks 0|1  (default: 1)
+		Under the default setting (1), cache blocks are evicted
+		from the writecache immediately after they write back to
+		the origin volume. Subsequent reads of these blocks will
+		be serviced directly from the origin volume.
+
+		When set to 0, blocks that have written back (clean) stay
+		in the cache until the block needs to be reused, allowing
+		these blocks to continue serving read requests for longer.
+		This increases the read caching effect, especially for very
+		large caches, even when watermark levels are set low.
 
 Status:
 
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index df27c7d066d2..b6d6d5c37e57 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -374,8 +374,9 @@ config DM_WRITECACHE
 	   It is intended for databases or other programs that need extremely
 	   low commit latency.
 
-	   The writecache target doesn't cache reads because reads are supposed
-	   to be cached in standard RAM.
+	   The writecache target is mainly intended to buffer bursts of writes,
+	   but there are opportunistic read caching effects as well (hits on
+	   recently-written data).
 
 config DM_EBS
 	tristate "Emulated block size target (EXPERIMENTAL)"
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 68e3fb300fc1..6277656a2ef1 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -78,12 +78,22 @@ struct wc_memory_superblock {
 	struct wc_memory_entry entries[];
 };
 
+typedef enum {
+	WC_INVALID,
+	WC_VALID_DIRTY,
+	WC_VALID_WRITING_BACK,
+	WC_VALID_CLEAN
+} wc_entry_state;
+
 struct wc_entry {
 	struct rb_node rb_node;
-	struct list_head lru;
+	union {
+		struct rb_node freelist_rb_node;
+		struct list_head lru;
+	};
 	u32 age; // jiffies
 	unsigned short wc_list_contiguous;
-	bool write_in_progress;
+	wc_entry_state state : 8;
 #ifdef DM_WRITECACHE_HANDLE_HARDWARE_ERRORS
 	uint64_t original_sector;
 	uint64_t seq_count;
@@ -167,6 +177,7 @@ struct dm_writecache {
 	bool cleaner_set:1;
 	bool metadata_only:1;
 	bool pause_set:1;
+	bool evict_clean_blocks:1;
 
 	unsigned int high_wm_percent_value;
 	unsigned int low_wm_percent_value;
@@ -671,12 +682,8 @@ static void writecache_insert_entry(struct dm_writecache *wc, struct wc_entry *i
 	rb_insert_color(&ins->rb_node, &wc->tree);
 	list_add(&ins->lru, &wc->lru);
 	ins->age = (u32)jiffies;
-}
-
-static void writecache_unlink(struct dm_writecache *wc, struct wc_entry *e)
-{
-	list_del(&e->lru);
-	rb_erase(&e->rb_node, &wc->tree);
+	BUG_ON(ins->state != WC_INVALID);
+	ins->state = WC_VALID_DIRTY;
 }
 
 static void writecache_add_to_freelist(struct dm_writecache *wc, struct wc_entry *e)
@@ -688,13 +695,13 @@ static void writecache_add_to_freelist(struct dm_writecache *wc, struct wc_entry
 			wc->current_free = e;
 		while (*node) {
 			parent = *node;
-			if (&e->rb_node < *node)
+			if (&e->freelist_rb_node < *node)
 				node = &parent->rb_left;
 			else
 				node = &parent->rb_right;
 		}
-		rb_link_node(&e->rb_node, parent, node);
-		rb_insert_color(&e->rb_node, &wc->freetree);
+		rb_link_node(&e->freelist_rb_node, parent, node);
+		rb_insert_color(&e->freelist_rb_node, &wc->freetree);
 	} else {
 		list_add_tail(&e->lru, &wc->freelist);
 	}
@@ -717,6 +724,31 @@ static void writecache_max_age_timer(struct timer_list *t)
 	}
 }
 
+static void writecache_clean_entry(struct dm_writecache *wc, struct wc_entry *e)
+{
+	// Put entry on free list to allow reuse, but leave it in the rb tree to allow read hits on clean blocks
+	BUG_ON(e->state != WC_VALID_DIRTY && e->state != WC_VALID_WRITING_BACK);
+	e->state = WC_VALID_CLEAN;
+	list_del(&e->lru);
+	writecache_add_to_freelist(wc, e);
+	clear_seq_count(wc, e);
+	writecache_flush_region(wc, memory_entry(wc, e), sizeof(struct wc_memory_entry));
+	if (unlikely(waitqueue_active(&wc->freelist_wait)))
+		wake_up(&wc->freelist_wait);
+}
+
+static void writecache_invalidate_entry(struct dm_writecache *wc, struct wc_entry *e)
+{
+	// Make a clean or invalid entry invalid.
+	// - Clean:   Remove it from the rb tree in preparation for reusing the block.
+	// - Invalid: Do nothing, it is already invalid.
+	if (e->state == WC_VALID_CLEAN)
+		rb_erase(&e->rb_node, &wc->tree);
+	else
+		BUG_ON(e->state != WC_INVALID);
+	e->state = WC_INVALID;
+}
+
 static struct wc_entry *writecache_pop_from_freelist(struct dm_writecache *wc, sector_t expected_sector)
 {
 	struct wc_entry *e;
@@ -729,11 +761,11 @@ static struct wc_entry *writecache_pop_from_freelist(struct dm_writecache *wc, s
 		e = wc->current_free;
 		if (expected_sector != (sector_t)-1 && unlikely(cache_sector(wc, e) != expected_sector))
 			return NULL;
-		next = rb_next(&e->rb_node);
-		rb_erase(&e->rb_node, &wc->freetree);
+		next = rb_next(&e->freelist_rb_node);
+		rb_erase(&e->freelist_rb_node, &wc->freetree);
 		if (unlikely(!next))
 			next = rb_first(&wc->freetree);
-		wc->current_free = next ? container_of(next, struct wc_entry, rb_node) : NULL;
+		wc->current_free = next ? container_of(next, struct wc_entry, freelist_rb_node) : NULL;
 	} else {
 		if (unlikely(list_empty(&wc->freelist)))
 			return NULL;
@@ -743,6 +775,7 @@ static struct wc_entry *writecache_pop_from_freelist(struct dm_writecache *wc, s
 		list_del(&e->lru);
 	}
 	wc->freelist_size--;
+	writecache_invalidate_entry(wc, e); // Remove clean block from rb tree if it is still there.
 
 	writecache_verify_watermark(wc);
 
@@ -751,12 +784,8 @@ static struct wc_entry *writecache_pop_from_freelist(struct dm_writecache *wc, s
 
 static void writecache_free_entry(struct dm_writecache *wc, struct wc_entry *e)
 {
-	writecache_unlink(wc, e);
-	writecache_add_to_freelist(wc, e);
-	clear_seq_count(wc, e);
-	writecache_flush_region(wc, memory_entry(wc, e), sizeof(struct wc_memory_entry));
-	if (unlikely(waitqueue_active(&wc->freelist_wait)))
-		wake_up(&wc->freelist_wait);
+	writecache_clean_entry(wc, e);
+	writecache_invalidate_entry(wc, e);
 }
 
 static void writecache_wait_on_freelist(struct dm_writecache *wc)
@@ -791,7 +820,7 @@ static void writecache_flush_entry(struct dm_writecache *wc, struct wc_entry *e)
 
 static bool writecache_entry_is_committed(struct dm_writecache *wc, struct wc_entry *e)
 {
-	return read_seq_count(wc, e) < wc->seq_count;
+	return e->state == WC_VALID_CLEAN || read_seq_count(wc, e) < wc->seq_count;
 }
 
 static void writecache_flush(struct dm_writecache *wc)
@@ -842,10 +871,13 @@ static void writecache_flush(struct dm_writecache *wc)
 
 		if (rb_node) {
 			e2 = container_of(rb_node, struct wc_entry, rb_node);
-			if (read_original_sector(wc, e2) == read_original_sector(wc, e) &&
-			    likely(!e2->write_in_progress)) {
-				writecache_free_entry(wc, e2);
-				need_flush_after_free = true;
+			if (read_original_sector(wc, e2) == read_original_sector(wc, e)) {
+				if (likely(e2->state == WC_VALID_DIRTY)) {
+					writecache_free_entry(wc, e2);
+					need_flush_after_free = true;
+				} else if (likely(e2->state == WC_VALID_CLEAN)) {
+					writecache_invalidate_entry(wc, e2); // invalidate doesn't update metadata, no flush needed.
+				}
 			}
 		}
 		if (unlikely(e->lru.prev == &wc->lru))
@@ -893,7 +925,9 @@ static void writecache_discard(struct dm_writecache *wc, sector_t start, sector_
 	while (read_original_sector(wc, e) < end) {
 		struct rb_node *node = rb_next(&e->rb_node);
 
-		if (likely(!e->write_in_progress)) {
+		if (likely(e->state == WC_VALID_CLEAN)) {
+			writecache_invalidate_entry(wc, e);
+		} else if (likely(e->state == WC_VALID_DIRTY)) {
 			if (!discarded_something) {
 				if (!WC_MODE_PMEM(wc)) {
 					writecache_wait_for_ios(wc, READ);
@@ -971,7 +1005,7 @@ static int writecache_alloc_entries(struct dm_writecache *wc)
 	for (b = 0; b < wc->n_blocks; b++) {
 		struct wc_entry *e = &wc->entries[b];
 
-		e->write_in_progress = false;
+		e->state = WC_INVALID;
 		cond_resched();
 	}
 
@@ -1065,6 +1099,7 @@ static void writecache_resume(struct dm_target *ti)
 #endif
 	for (b = 0; b < wc->n_blocks; b++) {
 		struct wc_entry *e = &wc->entries[b];
+		e->state = WC_INVALID;
 
 		if (!writecache_entry_is_committed(wc, e)) {
 			if (read_seq_count(wc, e) != -1) {
@@ -1410,7 +1445,7 @@ static void writecache_bio_copy_ssd(struct dm_writecache *wc, struct bio *bio,
 			if (read_original_sector(wc, f) !=
 			    read_original_sector(wc, e) + (wc->block_size >> SECTOR_SHIFT))
 				break;
-			if (unlikely(f->write_in_progress))
+			if (unlikely(f->state != WC_VALID_DIRTY))
 				break;
 			if (writecache_entry_is_committed(wc, f))
 				wc->overwrote_committed = true;
@@ -1448,20 +1483,24 @@ static enum wc_map_op writecache_map_write(struct dm_writecache *wc, struct bio
 			return WC_MAP_ERROR;
 		}
 		e = writecache_find_entry(wc, bio->bi_iter.bi_sector, 0);
-		if (e) {
+		if (e && (e->state != WC_VALID_CLEAN)) {
 			if (!writecache_entry_is_committed(wc, e)) {
 				wc->stats.write_hits_uncommitted++;
 				search_used = true;
 				goto bio_copy;
 			}
 			wc->stats.write_hits_committed++;
-			if (!WC_MODE_PMEM(wc) && !e->write_in_progress) {
+			if (!WC_MODE_PMEM(wc) && e->state != WC_VALID_WRITING_BACK) {
 				wc->overwrote_committed = true;
 				search_used = true;
 				goto bio_copy;
 			}
 			found_entry = true;
 		} else {
+			if (e && e->state == WC_VALID_CLEAN) {
+				// Write hits a clean block. Drop the clean block and treat it as a miss.
+				writecache_invalidate_entry(wc, e);
+			}
 			if (unlikely(wc->cleaner) ||
 			    (wc->metadata_only && !(bio->bi_opf & REQ_META)))
 				goto direct_write;
@@ -1690,11 +1729,17 @@ static void __writecache_endio_pmem(struct dm_writecache *wc, struct list_head *
 		i = 0;
 		do {
 			e = wb->wc_list[i];
-			BUG_ON(!e->write_in_progress);
-			e->write_in_progress = false;
+			BUG_ON(e->state != WC_VALID_WRITING_BACK);
 			INIT_LIST_HEAD(&e->lru);
-			if (!writecache_has_error(wc))
-				writecache_free_entry(wc, e);
+
+			if (likely(!writecache_has_error(wc))) {
+				writecache_clean_entry(wc, e);
+				// Invalidate clean blocks now, or defer until block leaves the free list.
+				if (wc->evict_clean_blocks)
+					writecache_invalidate_entry(wc, e);
+			} else {
+				e->state = WC_VALID_DIRTY;
+			}
 			BUG_ON(!wc->writeback_size);
 			wc->writeback_size--;
 			n_walked++;
@@ -1726,12 +1771,16 @@ static void __writecache_endio_ssd(struct dm_writecache *wc, struct list_head *l
 
 		e = c->e;
 		do {
-			BUG_ON(!e->write_in_progress);
-			e->write_in_progress = false;
+			BUG_ON(e->state != WC_VALID_WRITING_BACK);
 			INIT_LIST_HEAD(&e->lru);
-			if (!writecache_has_error(wc))
-				writecache_free_entry(wc, e);
-
+			if (likely(!writecache_has_error(wc))) {
+				writecache_clean_entry(wc, e);
+				// Invalidate clean blocks now, or defer until block leaves the free list.
+				if (wc->evict_clean_blocks)
+					writecache_invalidate_entry(wc, e);
+			} else {
+				e->state = WC_VALID_DIRTY;
+			}
 			BUG_ON(!wc->writeback_size);
 			wc->writeback_size--;
 			e++;
@@ -2006,7 +2055,7 @@ static void writecache_writeback(struct work_struct *work)
 				e = g;
 		} else
 			e = container_of(wc->lru.prev, struct wc_entry, lru);
-		BUG_ON(e->write_in_progress);
+		BUG_ON(e->state == WC_VALID_WRITING_BACK);
 		if (unlikely(!writecache_entry_is_committed(wc, e)))
 			writecache_flush(wc);
 
@@ -2015,7 +2064,7 @@ static void writecache_writeback(struct work_struct *work)
 			f = container_of(node, struct wc_entry, rb_node);
 			if (unlikely(read_original_sector(wc, f) ==
 				     read_original_sector(wc, e))) {
-				BUG_ON(!f->write_in_progress);
+				BUG_ON(f->state != WC_VALID_WRITING_BACK);
 				list_move(&e->lru, &skipped);
 				cond_resched();
 				continue;
@@ -2024,7 +2073,8 @@ static void writecache_writeback(struct work_struct *work)
 		wc->writeback_size++;
 		list_move(&e->lru, &wbl.list);
 		wbl.size++;
-		e->write_in_progress = true;
+		BUG_ON(e->state != WC_VALID_DIRTY);
+		e->state = WC_VALID_WRITING_BACK;
 		e->wc_list_contiguous = 1;
 
 		f = e;
@@ -2042,7 +2092,7 @@ static void writecache_writeback(struct work_struct *work)
 			if (read_original_sector(wc, g) !=
 			    read_original_sector(wc, f) + (wc->block_size >> SECTOR_SHIFT))
 				break;
-			if (unlikely(g->write_in_progress))
+			if (unlikely(g->state == WC_VALID_WRITING_BACK))
 				break;
 			if (unlikely(!writecache_entry_is_committed(wc, g)))
 				break;
@@ -2059,7 +2109,8 @@ static void writecache_writeback(struct work_struct *work)
 			wc->writeback_size++;
 			list_move(&g->lru, &wbl.list);
 			wbl.size++;
-			g->write_in_progress = true;
+			BUG_ON(g->state != WC_VALID_DIRTY);
+			g->state = WC_VALID_WRITING_BACK;
 			g->wc_list_contiguous = BIO_MAX_VECS;
 			f = g;
 			e->wc_list_contiguous++;
@@ -2245,6 +2296,7 @@ static int writecache_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	mutex_init(&wc->lock);
 	wc->max_age = MAX_AGE_UNSPECIFIED;
+	wc->evict_clean_blocks = true;
 	writecache_poison_lists(wc);
 	init_waitqueue_head(&wc->freelist_wait);
 	timer_setup(&wc->autocommit_timer, writecache_autocommit_timer, 0);
@@ -2480,6 +2532,12 @@ static int writecache_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 			wc->pause = msecs_to_jiffies(pause_msecs);
 			wc->pause_set = true;
 			wc->pause_value = pause_msecs;
+		} else if (!strcasecmp(string, "evict_clean_blocks") && opt_params >= 1) {
+			unsigned int enable;
+			string = dm_shift_arg(&as), opt_params--;
+			if (sscanf(string, "%u%c", &enable, &dummy) != 1)
+				goto invalid_optional;
+			wc->evict_clean_blocks = (enable != 0);
 		} else {
 invalid_optional:
 			r = -EINVAL;
@@ -2741,6 +2799,8 @@ static void writecache_status(struct dm_target *ti, status_type_t type,
 			DMEMIT(" metadata_only");
 		if (wc->pause_set)
 			DMEMIT(" pause_writeback %u", wc->pause_value);
+		if (!wc->evict_clean_blocks)
+			DMEMIT(" evict_clean_blocks %u", wc->evict_clean_blocks);
 		break;
 	case STATUSTYPE_IMA:
 		*result = '\0';
-- 
2.52.0

