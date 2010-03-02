From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 05/14] dm-multisnap-mikulas-blocks
Date: Mon,  1 Mar 2010 19:23:49 -0500
Message-ID: <1267489438-6271-6-git-send-email-snitzer@redhat.com>
References: <1267489438-6271-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1267489438-6271-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>

Common operations with blocks.

Management of tmp_remap array and some helper functions.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-multisnap-blocks.c |  333 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 333 insertions(+), 0 deletions(-)
 create mode 100644 drivers/md/dm-multisnap-blocks.c

diff --git a/drivers/md/dm-multisnap-blocks.c b/drivers/md/dm-multisnap-blocks.c
new file mode 100644
index 0000000..8715ed9
--- /dev/null
+++ b/drivers/md/dm-multisnap-blocks.c
@@ -0,0 +1,333 @@
+/*
+ * Copyright (C) 2009 Red Hat Czech, s.r.o.
+ *
+ * Mikulas Patocka <mpatocka@redhat.com>
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm-multisnap-mikulas.h"
+
+/*
+ * Check that the block is valid.
+ */
+static int check_invalid(struct dm_exception_store *s, chunk_t block)
+{
+	if (unlikely(block >= s->dev_size) ||
+	    unlikely(block == SB_BLOCK) ||
+	    unlikely(dm_multisnap_is_commit_block(s, block))) {
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("check_invalid: access to invalid part of the device: %llx, size %llx",
+					(unsigned long long)block, (unsigned long long)s->dev_size));
+		return 1;
+	}
+	return 0;
+}
+
+static struct tmp_remap *find_tmp_remap(struct dm_exception_store *s, chunk_t block)
+{
+	struct tmp_remap *t;
+	struct hlist_node *hn;
+	unsigned hash = TMP_REMAP_HASH(block);
+	hlist_for_each_entry(t, hn, &s->tmp_remap[hash], hash_list) {
+		if (t->old == block)
+			return t;
+		cond_resched();
+	}
+	return NULL;
+}
+
+/*
+ * Remap a block number according to tmp_remap table.
+ */
+chunk_t dm_multisnap_remap_block(struct dm_exception_store *s, chunk_t block)
+{
+	struct tmp_remap *t;
+	t = find_tmp_remap(s, block);
+	if (t)
+		return t->new;
+	return block;
+}
+
+/*
+ * Read a metadata block, return pointer to the dataand hold a buffer for that
+ * block.
+ *
+ * Do a possible block remapping according to tmp_remap table.
+ */
+void *dm_multisnap_read_block(struct dm_exception_store *s, chunk_t block,
+			      struct dm_buffer **bp)
+{
+	void *buf;
+	cond_resched();
+
+	if (unlikely(check_invalid(s, block)))
+		return NULL;
+
+	block = dm_multisnap_remap_block(s, block);
+
+	if (unlikely(check_invalid(s, block)))
+		return NULL;
+
+	buf = dm_bufio_read(s->bufio, block, bp);
+	if (unlikely(IS_ERR(buf))) {
+		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(buf),
+				       ("dm_multisnap_read_block: error read chunk %llx",
+					(unsigned long long)block));
+		return NULL;
+	}
+	return buf;
+}
+
+struct uncommitted_record {
+	struct hlist_node hash;
+	chunk_t block;
+};
+
+/*
+ * Check if the block is not yet committed.
+ *
+ * If this function returns 1, the block is surely uncommitted.
+ * If it returns 0, the block may be committed or may be uncommitted.
+ * This function is used for optimizations, if it returns 0
+ * it doesn't break correctness, it only degrades performance.
+ */
+int dm_multisnap_block_is_uncommitted(struct dm_exception_store *s, chunk_t block)
+{
+	struct tmp_remap *t;
+
+	struct uncommitted_record *ur;
+	struct hlist_node *hn;
+
+	check_invalid(s, block);
+	t = find_tmp_remap(s, block);
+	if (t) {
+		if (t->uncommitted)
+			return 1;
+		block = t->new;
+	}
+	hlist_for_each_entry(ur, hn, &s->uncommitted_blocks[UNCOMMITTED_BLOCK_HASH(block)], hash)
+		if (ur->block == block)
+			return 1;
+	return 0;
+}
+
+/*
+ * Set the given block as uncommitted.
+ *
+ * The allocation may fail, in this case we see only a performance degradation
+ * (the block will be copied again), there is no functionality loss.
+ *
+ * We can't use non-failing allocation because it could deadlock (wait for some
+ * pages being written and that write could be directed through this driver).
+ */
+void dm_multisnap_block_set_uncommitted(struct dm_exception_store *s, chunk_t block)
+{
+	struct uncommitted_record *ur;
+	/*
+	 * GFP_ATOMIC allows to exhaust reserves. We don't want it (we can
+	 * afford failure), so we use GFP_NOWAIT.
+	 * __GFP_NOWARN supresses the log message on failure.
+	 * __GFP_NOMEMALLOC makes it less aggressive if the allocator recurses
+	 * into itself.
+	 */
+	ur = kmalloc(sizeof(struct uncommitted_record),
+		     GFP_NOWAIT | __GFP_NOWARN | __GFP_NOMEMALLOC);
+	if (!ur)
+		return;
+	ur->block = block;
+	hlist_add_head(&ur->hash, &s->uncommitted_blocks[UNCOMMITTED_BLOCK_HASH(block)]);
+}
+
+/*
+ * Clear the register of uncommitted blocks. This is called on commit and
+ * on unload.
+ */
+void dm_multisnap_clear_uncommitted(struct dm_exception_store *s)
+{
+	int i;
+	for (i = 0; i < UNCOMMITTED_BLOCK_HASH_SIZE; i++) {
+		struct hlist_head *h = &s->uncommitted_blocks[i];
+		while (!hlist_empty(h)) {
+			struct uncommitted_record *ur =
+				hlist_entry(h->first, struct uncommitted_record, hash);
+			hlist_del(&ur->hash);
+			kfree(ur);
+		}
+	}
+}
+
+/*
+ * This function is called by an allocation code when needing to modify a
+ * committed block.
+ *
+ * It will create new remap for old_chunk->new_chunk.
+ * bitmap_idx is the index of bitmap if we are remapping bitmap, otherwise
+ * CB_BITMAP_IDX_NONE.
+ *
+ * *bp must be open buffer for old_chunk. New buffer for new_chunk is returned
+ * there.
+ *
+ * A block that needs to be freed is returned in to_free. If to_free is NULL,
+ * that block is freed immediatelly.
+ */
+void *dm_multisnap_duplicate_block(struct dm_exception_store *s, chunk_t old_chunk,
+				   chunk_t new_chunk, bitmap_t bitmap_idx,
+				   struct dm_buffer **bp, chunk_t *to_free_ptr)
+{
+	chunk_t to_free_val;
+	void *buf;
+	struct tmp_remap *t;
+
+	if (unlikely(check_invalid(s, old_chunk)) ||
+	    unlikely(check_invalid(s, new_chunk)))
+		return NULL;
+
+	if (!to_free_ptr)
+		to_free_ptr = &to_free_val;
+	*to_free_ptr = 0;
+
+	t = find_tmp_remap(s, old_chunk);
+	if (t) {
+		if (unlikely(t->bitmap_idx != bitmap_idx)) {
+			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+					       ("dm_multisnap_duplicate_block: bitmap_idx doesn't match, %X != %X",
+						t->bitmap_idx, bitmap_idx));
+			return NULL;
+		}
+		*to_free_ptr = t->new;
+		t->new = new_chunk;
+	} else {
+		if (unlikely(list_empty(&s->free_tmp_remaps))) {
+			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+					       ("dm_multisnap_duplicate_block: all remap blocks used"));
+			return NULL;
+		}
+		t = list_first_entry(&s->free_tmp_remaps, struct tmp_remap, list);
+		t->new = new_chunk;
+		t->old = old_chunk;
+		t->bitmap_idx = bitmap_idx;
+		hlist_add_head(&t->hash_list, &s->tmp_remap[TMP_REMAP_HASH(old_chunk)]);
+		s->n_used_tmp_remaps++;
+	}
+	list_del(&t->list);
+	if (bitmap_idx == CB_BITMAP_IDX_NONE)
+		list_add_tail(&t->list, &s->used_bt_tmp_remaps);
+	else
+		list_add_tail(&t->list, &s->used_bitmap_tmp_remaps);
+	t->uncommitted = 1;
+	dm_bufio_release_move(*bp, new_chunk);
+
+	if (to_free_ptr == &to_free_val && to_free_val)
+		dm_multisnap_free_block(s, to_free_val, 0);
+
+	buf = dm_bufio_read(s->bufio, new_chunk, bp);
+	if (IS_ERR(buf)) {
+		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(buf),
+				       ("dm_multisnap_duplicate_block: error reading chunk %llx",
+					(unsigned long long)new_chunk));
+		return NULL;
+	}
+	return buf;
+}
+
+/*
+ * Remove an entry from tmp_remap table.
+ */
+void dm_multisnap_free_tmp_remap(struct dm_exception_store *s, struct tmp_remap *t)
+{
+	list_del(&t->list);
+	hlist_del(&t->hash_list);
+	s->n_used_tmp_remaps--;
+	list_add(&t->list, &s->free_tmp_remaps);
+}
+
+/*
+ * Get a new block. Just a wrapper around dm_bufio_new.
+ * It is expected that the caller fills all the data in the block, calls
+ * dm_bufio_mark_buffer_dirty and releases the buffer.
+ */
+void *dm_multisnap_make_block(struct dm_exception_store *s, chunk_t new_chunk,
+			      struct dm_buffer **bp)
+{
+	void *buf;
+
+	if (unlikely(check_invalid(s, new_chunk)))
+		return NULL;
+
+	dm_multisnap_block_set_uncommitted(s, new_chunk);
+
+	buf = dm_bufio_new(s->bufio, new_chunk, bp);
+	if (unlikely(IS_ERR(buf))) {
+		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(buf),
+				       ("dm_multisnap_make_block: error creating new block at chunk %llx",
+					(unsigned long long)new_chunk));
+		return NULL;
+	}
+	return buf;
+}
+
+/*
+ * Free the given block and a possible tmp_remap shadow of it.
+ */
+void dm_multisnap_free_block_and_duplicates(struct dm_exception_store *s, chunk_t block)
+{
+	struct tmp_remap *t;
+
+	if (unlikely(check_invalid(s, block)))
+		return;
+
+	t = find_tmp_remap(s, block);
+	if (t) {
+		dm_multisnap_free_block(s, t->new, 0);
+		dm_multisnap_free_tmp_remap(s, t);
+	}
+	dm_multisnap_free_block(s, block, 0);
+}
+
+/*
+ * Return true if the block is a commit block.
+ */
+int dm_multisnap_is_commit_block(struct dm_exception_store *s, chunk_t block)
+{
+	if (unlikely(block < FIRST_CB_BLOCK))
+		return 0;
+	/*
+	 * Division is very slow, thus we optimize the most common case
+	 * if cb_stride is the power of 2.
+	 */
+	if (likely(!(s->cb_stride & (s->cb_stride - 1))))
+		return (block & (s->cb_stride - 1)) == (FIRST_CB_BLOCK & (s->cb_stride - 1));
+	else
+		return sector_div(block, s->cb_stride) == FIRST_CB_BLOCK % s->cb_stride;
+}
+
+/*
+ * These two functions are used to avoid cycling on a corrupted device.
+ *
+ * If the data on the device is corrupted, we mark the device as errorneous,
+ * but we don't want to lockup the whole system. These functions help to achieve
+ * this goal.
+ *
+ * cy->count is the number of processed blocks.
+ * cy->key is the recorded block at last power-of-two count.
+ */
+void dm_multisnap_init_stop_cycles(struct stop_cycles *cy)
+{
+	cy->key = 0;
+	cy->count = 0;
+}
+
+int dm_multisnap_stop_cycles(struct dm_exception_store *s, struct stop_cycles *cy, chunk_t key)
+{
+	if (unlikely(cy->key == key) && unlikely(cy->count != 0)) {
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("dm_multisnap_stop_cycles: cycle detected at chunk %llx",
+					(unsigned long long)key));
+		return -1;
+	}
+	cy->count++;
+	if (!((cy->count - 1) & cy->count))
+		cy->key = key;
+	return 0;
+}
-- 
1.6.5.2
