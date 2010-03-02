From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 07/14] dm-multisnap-mikulas-commit
Date: Mon,  1 Mar 2010 19:23:51 -0500
Message-ID: <1267489438-6271-8-git-send-email-snitzer@redhat.com>
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

Writing the commit block.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-multisnap-commit.c |  245 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 245 insertions(+), 0 deletions(-)
 create mode 100644 drivers/md/dm-multisnap-commit.c

diff --git a/drivers/md/dm-multisnap-commit.c b/drivers/md/dm-multisnap-commit.c
new file mode 100644
index 0000000..78b2583
--- /dev/null
+++ b/drivers/md/dm-multisnap-commit.c
@@ -0,0 +1,245 @@
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
+ * Flush existing tmp_remaps.
+ */
+static void dm_multisnap_finalize_tmp_remaps(struct dm_exception_store *s)
+{
+	struct tmp_remap *t;
+	int i;
+
+	while (s->n_used_tmp_remaps) {
+		if (dm_multisnap_has_error(s->dm))
+			return;
+		if (s->n_used_tmp_remaps < N_REMAPS - 1) {
+			/*
+			 * prefer btree remaps ...
+			 * if there are none, do bitmap remaps
+			 */
+			if (!list_empty(&s->used_bt_tmp_remaps)) {
+				t = container_of(s->used_bt_tmp_remaps.next,
+						 struct tmp_remap, list);
+				dm_multisnap_bt_finalize_tmp_remap(s, t);
+				dm_multisnap_free_tmp_remap(s, t);
+				continue;
+			}
+		}
+
+		/* else: 0 or 1 free remaps : finalize bitmaps */
+		if (!list_empty(&s->used_bitmap_tmp_remaps)) {
+			t = container_of(s->used_bitmap_tmp_remaps.next,
+					 struct tmp_remap, list);
+			dm_multisnap_bitmap_finalize_tmp_remap(s, t);
+			dm_multisnap_free_tmp_remap(s, t);
+			continue;
+		} else {
+			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+					       ("dm_multisnap_finalize_tmp_remaps: no bitmap tmp remaps, n_used_tmp_remaps %u",
+						s->n_used_tmp_remaps));
+			return;
+		}
+	}
+
+	if (dm_multisnap_has_error(s->dm))
+		return;
+
+	for (i = s->n_preallocated_blocks - 1; i >= 0; i--)
+		dm_multisnap_free_blocks_immediate(s, s->preallocated_blocks[i], 1);
+	s->n_preallocated_blocks = 0;
+}
+
+/*
+ * This function must be called before any two b+tree modification at a point
+ * when b+tree is consistent. It flushes tmp_remaps, so that tmp_remap array
+ * doesn't overflow. This function doesn't commit anything.
+ */
+void dm_multisnap_transition_mark(struct dm_exception_store *s)
+{
+	/*
+	 * Accounting:
+	 * max number of modified/allocated blocks during btree add:
+	 *	s->bt_depth * 2 + 1
+	 * one additional entry for newly allocated data chunk
+	 * one additional entry for bitmap finalization
+	 */
+	if (unlikely(N_REMAPS - s->n_used_tmp_remaps < s->bt_depth * 2 + 3))
+		dm_multisnap_finalize_tmp_remaps(s);
+}
+
+/*
+ * Flush buffers. This is called without the lock to reduce lock contention.
+ * The buffers will be flushed again, with the lock.
+ */
+void dm_multisnap_prepare_for_commit(struct dm_exception_store *s)
+{
+	int r;
+
+	r = dm_bufio_write_dirty_buffers(s->bufio);
+	if (unlikely(r < 0)) {
+		DM_MULTISNAP_SET_ERROR(s->dm, r,
+				       ("dm_multisnap_prepare_for_commit: error writing data"));
+		return;
+	}
+}
+
+/*
+ * This function makes any modifications make so far permanent.
+ *
+ * It is valid to make multiple modifications to the exception store and
+ * then commit them atomically at once with this function.
+ */
+void dm_multisnap_commit(struct dm_exception_store *s)
+{
+	struct tmp_remap *t;
+	chunk_t cb_addr;
+	chunk_t cb_div, cb_offset;
+	struct multisnap_commit_block *cb;
+	struct multisnap_superblock *sb;
+	unsigned idx;
+	struct dm_buffer *bp;
+	int r;
+
+	dm_multisnap_transition_mark(s);
+
+	/* Forget all uncommitted blocks --- they are going to be committed */
+	dm_multisnap_clear_uncommitted(s);
+
+	dm_multisnap_flush_freelist_before_commit(s);
+
+	if (dm_multisnap_has_error(s->dm)) {
+		if (!dm_multisnap_drop_on_error(s->dm))
+			return;
+
+		sb = dm_bufio_read(s->bufio, SB_BLOCK, &bp);
+		if (IS_ERR(sb))
+			return;
+
+		if (!le32_to_cpu(sb->error)) {
+			sb->error = cpu_to_le32(dm_multisnap_has_error(s->dm));
+			dm_bufio_mark_buffer_dirty(bp);
+		}
+
+		dm_bufio_release(bp);
+		return;
+	}
+
+	list_for_each_entry(t, &s->used_bitmap_tmp_remaps, list)
+		t->uncommitted = 0;
+
+	list_for_each_entry(t, &s->used_bt_tmp_remaps, list)
+		t->uncommitted = 0;
+
+	r = dm_bufio_write_dirty_buffers(s->bufio);
+	if (unlikely(r < 0)) {
+		DM_MULTISNAP_SET_ERROR(s->dm, r,
+				       ("dm_multisnap_commit: error writing data"));
+		return;
+	}
+
+	cb_addr = s->alloc_rover;
+
+	if (cb_addr < FIRST_CB_BLOCK)
+		cb_addr = FIRST_CB_BLOCK;
+	cb_div = cb_addr - FIRST_CB_BLOCK;
+	cb_offset = sector_div(cb_div, s->cb_stride);
+	cb_addr += s->cb_stride - cb_offset;
+	if (cb_offset < s->cb_stride / 2 || cb_addr >= s->dev_size)
+		cb_addr -= s->cb_stride;
+
+	cb = dm_bufio_new(s->bufio, cb_addr, &bp);
+	if (IS_ERR(cb)) {
+		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(cb),
+				       ("dm_multisnap_commit: can't allocate new commit block at %llx",
+					(unsigned long long)cb_addr));
+		return;
+	}
+
+	s->commit_sequence++;
+
+	cb->signature = CB_SIGNATURE;
+	cb->snapshot_num = cpu_to_le32(s->snapshot_num);
+	cb->sequence = cpu_to_le64(s->commit_sequence);
+	write_48(cb, dev_size, s->dev_size);
+	write_48(cb, total_allocated, s->total_allocated);
+	write_48(cb, data_allocated, s->data_allocated);
+	write_48(cb, bitmap_root, s->bitmap_root);
+	write_48(cb, alloc_rover, s->alloc_rover);
+	write_48(cb, freelist, s->freelist_ptr);
+	write_48(cb, delete_rover, s->delete_rover_chunk);
+	write_48(cb, bt_root, s->bt_root);
+	cb->bt_depth = s->bt_depth;
+	cb->flags = s->flags;
+	memset(cb->pad, 0, sizeof cb->pad);
+	idx = 0;
+	list_for_each_entry(t, &s->used_bitmap_tmp_remaps, list) {
+		BUG_ON(idx >= N_REMAPS);
+		write_48(&cb->tmp_remap[idx], old, t->old);
+		write_48(&cb->tmp_remap[idx], new, t->new);
+		cb->tmp_remap[idx].bitmap_idx = cpu_to_le32(t->bitmap_idx);
+		idx++;
+	}
+	list_for_each_entry(t, &s->used_bt_tmp_remaps, list) {
+		BUG_ON(idx >= N_REMAPS);
+		write_48(&cb->tmp_remap[idx], old, t->old);
+		write_48(&cb->tmp_remap[idx], new, t->new);
+		cb->tmp_remap[idx].bitmap_idx = cpu_to_le32(t->bitmap_idx);
+		idx++;
+	}
+	for (; idx < N_REMAPS; idx++) {
+		write_48(&cb->tmp_remap[idx], old, 0);
+		write_48(&cb->tmp_remap[idx], new, 0);
+		cb->tmp_remap[idx].bitmap_idx = cpu_to_le32(0);
+	}
+	dm_bufio_mark_buffer_dirty(bp);
+	dm_bufio_release(bp);
+	r = dm_bufio_write_dirty_buffers(s->bufio);
+	if (unlikely(r < 0)) {
+		DM_MULTISNAP_SET_ERROR(s->dm, r,
+				       ("dm_multisnap_commit: can't write commit block at %llx",
+					(unsigned long long)cb_addr));
+		return;
+	}
+
+	if (likely(cb_addr == s->valid_commit_block) ||
+	    likely(cb_addr == s->valid_commit_block + s->cb_stride))
+		goto return_success;
+
+	sb = dm_bufio_read(s->bufio, SB_BLOCK, &bp);
+	if (IS_ERR(sb)) {
+		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(sb),
+				       ("dm_multisnap_commit: can't read super block"));
+		return;
+	}
+
+	if (unlikely(sb->signature != SB_SIGNATURE)) {
+		dm_bufio_release(bp);
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("dm_multisnap_commit: invalid super block signature when committing"));
+		return;
+	}
+
+	sb->commit_block = cpu_to_le64(cb_addr);
+
+	dm_bufio_mark_buffer_dirty(bp);
+	dm_bufio_release(bp);
+	r = dm_bufio_write_dirty_buffers(s->bufio);
+	if (unlikely(r < 0)) {
+		DM_MULTISNAP_SET_ERROR(s->dm, r, ("dm_multisnap_commit: can't write super block"));
+		return;
+	}
+
+return_success:
+	s->valid_commit_block = cb_addr;
+
+	dm_multisnap_load_freelist(s);
+
+	return;
+}
-- 
1.6.5.2
