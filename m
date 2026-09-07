Received: from mail.stuffedcow.net (mail.stuffedcow.net [38.49.217.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BD2369208
	for <dm-devel@lists.linux.dev>; Mon,  7 Sep 2026 21:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=38.49.217.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788817613; cv=none; b=Z/btlPmDnOtE7G0ssVTOhs63P4MR+eRYhRyv4vyZs8plRF0u+4Hc9I5meoC3ct8EyghcOMSvyXifXMszE0F7yfKURLtYGXWeUqHXQRPMJe3O8RMCfttMnKt+b6xeLDnwm6N7mZv+/IDafynOsJxuo+m/31bMMG/4KaTi/jP8EiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788817613; c=relaxed/simple;
	bh=t1d/NDRFL6fkkRb18aCYmfhAMHiZYVGGxIT3QZuv/Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vD6sDuYEech3D8rgZt+KTkCnD4XmNkrn/ECRUUpu2aobQBbHEMmiDJ0A2ATJZg2h1fP75/NZOrKrVuwV39Vr9fg21L3fc5vENnoo9VU6tgrPAqAtSgq1OWrlNBPgeKgY82/toiV6/8GNu4Zozl/X6R8+u3tefqVbWkdZ789iI5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stuffedcow.net; spf=pass smtp.mailfrom=stuffedcow.net; arc=none smtp.client-ip=38.49.217.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stuffedcow.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stuffedcow.net
Received: from henry2.or.stuffedcow.lan (henry2.or.stuffedcow.lan [192.168.1.227])
	by mail.stuffedcow.net (Postfix) with ESMTP id F3BB01E0EA7;
	Mon, 07 Sep 2026 17:46:49 -0400 (EDT)
From: Henry Wong <henry@stuffedcow.net>
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com
Subject: [PATCH 1/2] dm-writecache: Reduce metadata memory use by 8 bytes per cache block.
Date: Mon,  7 Sep 2026 14:46:47 -0700
Message-ID: <20260907214648.3691695-2-henry@stuffedcow.net>
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

wc_entry.index removed: This can be computed by pointer arithmetic without storage.
wc_entry.age reduced to 32 bits: It only needs to be big enough to hold max_age, which is limited to well below 32-bit range.

Reduces wc_entry size from 56 bytes to 48 bytes (from 72 to 64 bytes if DM_WRITECACHE_HANDLE_HARDWARE_ERRORS enabled).

Signed-off-by: Henry Wong <henry@stuffedcow.net>
---
 drivers/md/dm-writecache.c | 39 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 978646f71f99..68e3fb300fc1 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -81,15 +81,9 @@ struct wc_memory_superblock {
 struct wc_entry {
 	struct rb_node rb_node;
 	struct list_head lru;
+	u32 age; // jiffies
 	unsigned short wc_list_contiguous;
-#if BITS_PER_LONG == 64
-	bool write_in_progress : 1;
-	unsigned long index : 47;
-#else
 	bool write_in_progress;
-	unsigned long index;
-#endif
-	unsigned long age;
 #ifdef DM_WRITECACHE_HANDLE_HARDWARE_ERRORS
 	uint64_t original_sector;
 	uint64_t seq_count;
@@ -389,20 +383,28 @@ static struct wc_memory_superblock *sb(struct dm_writecache *wc)
 	return wc->memory_map;
 }
 
+static inline unsigned long wc_entry_index(const struct wc_entry *base, const struct wc_entry *entry)
+{
+	return entry - base;
+}
+
 static struct wc_memory_entry *memory_entry(struct dm_writecache *wc, struct wc_entry *e)
 {
-	return &sb(wc)->entries[e->index];
+	const unsigned long index = wc_entry_index(wc->entries, e);
+	return &sb(wc)->entries[index];
 }
 
 static void *memory_data(struct dm_writecache *wc, struct wc_entry *e)
 {
-	return (char *)wc->block_start + (e->index << wc->block_size_bits);
+	const unsigned long index = wc_entry_index(wc->entries, e);
+	return (char *)wc->block_start + (index << wc->block_size_bits);
 }
 
 static sector_t cache_sector(struct dm_writecache *wc, struct wc_entry *e)
 {
+	const unsigned long index = wc_entry_index(wc->entries, e);
 	return wc->start_sector + wc->metadata_sectors +
-		((sector_t)e->index << (wc->block_size_bits - SECTOR_SHIFT));
+		((sector_t)index << (wc->block_size_bits - SECTOR_SHIFT));
 }
 
 static uint64_t read_original_sector(struct dm_writecache *wc, struct wc_entry *e)
@@ -668,7 +670,7 @@ static void writecache_insert_entry(struct dm_writecache *wc, struct wc_entry *i
 	rb_link_node(&ins->rb_node, parent, node);
 	rb_insert_color(&ins->rb_node, &wc->tree);
 	list_add(&ins->lru, &wc->lru);
-	ins->age = jiffies;
+	ins->age = (u32)jiffies;
 }
 
 static void writecache_unlink(struct dm_writecache *wc, struct wc_entry *e)
@@ -969,7 +971,6 @@ static int writecache_alloc_entries(struct dm_writecache *wc)
 	for (b = 0; b < wc->n_blocks; b++) {
 		struct wc_entry *e = &wc->entries[b];
 
-		e->index = b;
 		e->write_in_progress = false;
 		cond_resched();
 	}
@@ -1986,7 +1987,7 @@ static void writecache_writeback(struct work_struct *work)
 	while (!list_empty(&wc->lru) &&
 	       (wc->writeback_all ||
 		wc->freelist_size + wc->writeback_size <= wc->freelist_low_watermark ||
-		(jiffies - container_of(wc->lru.prev, struct wc_entry, lru)->age >=
+		((u32)(jiffies - container_of(wc->lru.prev, struct wc_entry, lru)->age) >=
 		 wc->max_age - wc->max_age / MAX_AGE_DIV))) {
 
 		n_walked++;
@@ -2107,7 +2108,6 @@ static int calculate_memory_size(uint64_t device_size, unsigned int block_size,
 				 size_t *n_blocks_p, size_t *n_metadata_blocks_p)
 {
 	uint64_t n_blocks, offset;
-	struct wc_entry e;
 
 	n_blocks = device_size;
 	do_div(n_blocks, block_size + sizeof(struct wc_memory_entry));
@@ -2126,11 +2126,6 @@ static int calculate_memory_size(uint64_t device_size, unsigned int block_size,
 		n_blocks--;
 	}
 
-	/* check if the bit field overflows */
-	e.index = n_blocks;
-	if (e.index != n_blocks)
-		return -EFBIG;
-
 	if (n_blocks_p)
 		*n_blocks_p = n_blocks;
 	if (n_metadata_blocks_p)
@@ -2444,13 +2439,15 @@ static int writecache_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 			wc->autocommit_time_set = true;
 		} else if (!strcasecmp(string, "max_age") && opt_params >= 1) {
 			unsigned int max_age_msecs;
+			unsigned long max_age_jiffies;
 
 			string = dm_shift_arg(&as), opt_params--;
 			if (sscanf(string, "%u%c", &max_age_msecs, &dummy) != 1)
 				goto invalid_optional;
-			if (max_age_msecs > 86400000)
+			max_age_jiffies = msecs_to_jiffies(max_age_msecs);
+			if (max_age_jiffies >= min(MAX_JIFFY_OFFSET, (7 << 28))) // 7/8ths of 1 << 31
 				goto invalid_optional;
-			wc->max_age = msecs_to_jiffies(max_age_msecs);
+			wc->max_age = max_age_jiffies;
 			wc->max_age_set = true;
 			wc->max_age_value = max_age_msecs;
 		} else if (!strcasecmp(string, "cleaner")) {
-- 
2.52.0

