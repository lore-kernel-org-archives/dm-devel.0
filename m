From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 04/14] dm-multisnap-mikulas-alloc
Date: Mon,  1 Mar 2010 19:23:48 -0500
Message-ID: <1267489438-6271-5-git-send-email-snitzer@redhat.com>
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

Management of allocation bitmaps.

Creating the bitmaps.
Allocating and freeing blocks.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-multisnap-alloc.c |  590 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 590 insertions(+), 0 deletions(-)
 create mode 100644 drivers/md/dm-multisnap-alloc.c

diff --git a/drivers/md/dm-multisnap-alloc.c b/drivers/md/dm-multisnap-alloc.c
new file mode 100644
index 0000000..02f89be
--- /dev/null
+++ b/drivers/md/dm-multisnap-alloc.c
@@ -0,0 +1,590 @@
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
+#define rshift_roundup(val, bits)	(((val) + ((chunk_t)1 << (bits)) - 1) >> (bits))
+
+#define BITS_PER_BYTE_SHIFT	3
+#define BYTES_PER_POINTER_SHIFT	3
+
+/*
+ * Initialize the root bitmap, write it at the position "writing block".
+ */
+void dm_multisnap_create_bitmaps(struct dm_exception_store *s, chunk_t *writing_block)
+{
+	struct dm_buffer *bp;
+	unsigned i;
+	void *bmp;
+
+	while (dm_multisnap_is_commit_block(s, *writing_block))
+		(*writing_block)++;
+
+	if (*writing_block >= s->dev_size) {
+		DM_MULTISNAP_SET_ERROR(s->dm, -ENOSPC,
+				       ("dm_multisnap_create_bitmaps: device is too small"));
+		return;
+	}
+
+	if (*writing_block >= s->chunk_size << BITS_PER_BYTE_SHIFT) {
+		DM_MULTISNAP_SET_ERROR(s->dm, -ENOSPC,
+				       ("dm_multisnap_create_bitmaps: invalid block to write: %llx",
+					(unsigned long long)*writing_block));
+		return;
+	}
+
+	bmp = dm_bufio_new(s->bufio, *writing_block, &bp);
+	if (IS_ERR(bmp)) {
+		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(bmp),
+				       ("dm_multisnap_create_bitmaps: can't create direct bitmap block at %llx",
+					(unsigned long long)*writing_block));
+		return;
+	}
+	cond_resched();
+	memset(bmp, 0, s->chunk_size);
+	for (i = 0; i <= *writing_block; i++) {
+		generic___set_le_bit(i, bmp);
+		dm_multisnap_status_lock(s->dm);
+		s->total_allocated++;
+		dm_multisnap_status_unlock(s->dm);
+		cond_resched();
+	}
+	s->bitmap_root = *writing_block;
+	s->bitmap_depth = 0;
+
+	dm_bufio_mark_buffer_dirty(bp);
+	dm_bufio_release(bp);
+
+	(*writing_block)++;
+}
+
+static void dm_multisnap_add_bitmap(struct dm_exception_store *s);
+
+/*
+ * Extend bitmaps to cover "new_size" area.
+ *
+ * While we extend bitmaps we increase s->dev_size so that the newly mapped
+ * space can be used to hold further bitmaps.
+ */
+void dm_multisnap_extend_bitmaps(struct dm_exception_store *s, chunk_t new_size)
+{
+	while (s->dev_size < new_size) {
+		struct dm_buffer *bp;
+		void *bmp;
+		bitmap_t bitmap_no = s->dev_size >> (s->chunk_shift + BITS_PER_BYTE_SHIFT);
+		unsigned i = s->dev_size & ((1 << (s->chunk_shift + BITS_PER_BYTE_SHIFT)) - 1);
+		chunk_t c = s->dev_size;
+		if (!i) {
+			dm_multisnap_add_bitmap(s);
+			if (unlikely(dm_multisnap_has_error(s->dm)))
+				return;
+		}
+		bmp = dm_multisnap_map_bitmap(s, bitmap_no, &bp, NULL, NULL);
+		if (unlikely(!bmp))
+			return;
+		for (; i < s->chunk_size << BITS_PER_BYTE_SHIFT; i++, c++) {
+			if (unlikely(dm_multisnap_is_commit_block(s, c)))
+				generic___set_le_bit(i, bmp);
+			else
+				generic___clear_le_bit(i, bmp);
+		}
+		dm_bufio_mark_buffer_dirty(bp);
+		dm_bufio_release(bp);
+
+		s->dev_size = ((chunk_t)bitmap_no + 1) << (s->chunk_shift + BITS_PER_BYTE_SHIFT);
+		if (s->dev_size > new_size)
+			s->dev_size = new_size;
+	}
+}
+
+/*
+ * Add one bitmap after the last bitmap. A helper function for
+ * dm_multisnap_extend_bitmaps
+ */
+static void dm_multisnap_add_bitmap(struct dm_exception_store *s)
+{
+	struct path_element path[MAX_BITMAP_DEPTH];
+	struct dm_buffer *bp;
+	int d;
+	__u64 *bmpp;
+	unsigned i;
+	chunk_t c, bitmap_blk, new_blk;
+	bitmap_t bitmap_no = s->dev_size >> (s->chunk_shift + BITS_PER_BYTE_SHIFT);
+	void *bmp = dm_multisnap_alloc_make_block(s, &bitmap_blk, &bp);
+	if (!bmp)
+		return;
+	c = (chunk_t)bitmap_no << (s->chunk_shift + BITS_PER_BYTE_SHIFT);
+	for (i = 0; i < s->chunk_size << BITS_PER_BYTE_SHIFT; i++, c++) {
+		if (unlikely(dm_multisnap_is_commit_block(s, c)))
+			generic___set_le_bit(i, bmp);
+		else
+			generic___clear_le_bit(i, bmp);
+	}
+	dm_bufio_mark_buffer_dirty(bp);
+	dm_bufio_release(bp);
+
+	/* just get the path to the last block */
+	bmp = dm_multisnap_map_bitmap(s, bitmap_no - 1, &bp, NULL, path);
+	if (unlikely(!bmp))
+		return;
+	dm_bufio_release(bp);
+
+	for (d = s->bitmap_depth - 1; d >= 0; d--) {
+		if (path[d].idx + 1 < path[d].n_entries) {
+			bmpp = dm_multisnap_read_block(s, path[d].block, &bp);
+			if (!bmpp)
+				return;
+			bmpp[path[d].idx + 1] = cpu_to_le64(bitmap_blk);
+			dm_bufio_mark_buffer_dirty(bp);
+			dm_bufio_release(bp);
+			return;
+		} else {
+			bmpp = dm_multisnap_alloc_make_block(s, &new_blk, &bp);
+			if (!bmpp)
+				return;
+			memset(bmpp, 0, s->chunk_size);
+			bmpp[0] = cpu_to_le64(bitmap_blk);
+			dm_bufio_mark_buffer_dirty(bp);
+			dm_bufio_release(bp);
+			bitmap_blk = new_blk;
+		}
+	}
+
+	/* make new root */
+	bmpp = dm_multisnap_alloc_make_block(s, &new_blk, &bp);
+	if (!bmpp)
+		return;
+	memset(bmpp, 0, s->chunk_size);
+	bmpp[0] = cpu_to_le64(s->bitmap_root);
+	bmpp[1] = cpu_to_le64(bitmap_blk);
+	dm_bufio_mark_buffer_dirty(bp);
+	dm_bufio_release(bp);
+	s->bitmap_root = new_blk;
+	s->bitmap_depth++;
+}
+
+/*
+ * Read a leaf bitmap node with index "bitmap".
+ * Return the pointer to the data, store the held buffer to bl.
+ * Return the block in block and path in path.
+ */
+void *dm_multisnap_map_bitmap(struct dm_exception_store *s, bitmap_t bitmap,
+			      struct dm_buffer **bp, chunk_t *block, struct path_element *path)
+{
+	__u64 *bmp;
+	unsigned idx;
+	unsigned d = s->bitmap_depth;
+	chunk_t blk = s->bitmap_root;
+	chunk_t parent = 0;
+
+	while (1) {
+		bmp = dm_multisnap_read_block(s, blk, bp);
+		if (unlikely(!bmp)) {
+			/* error is already set in dm_multisnap_read_block */
+			DMERR("dm_multisnap_map_bitmap: can't read bitmap at "
+			      "%llx (%llx), pointed to by %llx (%llx), depth %d/%d, index %llx",
+			      (unsigned long long)blk,
+			      (unsigned long long)dm_multisnap_remap_block(s, blk),
+			      (unsigned long long)parent,
+			      (unsigned long long)dm_multisnap_remap_block(s, parent),
+			      s->bitmap_depth - d,
+			      s->bitmap_depth,
+			      (unsigned long long)bitmap);
+			return NULL;
+		}
+		if (!d) {
+			if (block)
+				*block = blk;
+			return bmp;
+		}
+
+		idx = (bitmap >> ((d - 1) * (s->chunk_shift - BYTES_PER_POINTER_SHIFT))) &
+			((s->chunk_size - 1) >> BYTES_PER_POINTER_SHIFT);
+
+		if (unlikely(path != NULL)) {
+			path[s->bitmap_depth - d].block = blk;
+			path[s->bitmap_depth - d].idx = idx;
+			path[s->bitmap_depth - d].n_entries = s->chunk_size >> BYTES_PER_POINTER_SHIFT;
+		}
+
+		parent = blk;
+		blk = le64_to_cpu(bmp[idx]);
+
+		dm_bufio_release(*bp);
+
+		d--;
+	}
+}
+
+/*
+ * Find a free bit from "start" to "end" (in bits).
+ * If wide_search is nonzero, search for the whole free byte first.
+ */
+static int find_bit(const void *bmp, unsigned start, unsigned end, int wide_search)
+{
+	const void *p;
+	unsigned bit;
+	if (unlikely(start >= end))
+		return -ENOSPC;
+	if (likely(!generic_test_le_bit(start, bmp)))
+		return start;
+	cond_resched();
+	if (likely(wide_search)) {
+		p = memchr((const char *)bmp + (start >> 3), 0, (end >> 3) - (start >> 3));
+		cond_resched();
+		if (p) {
+			bit = (((const __u8 *)p - (const __u8 *)bmp) << 3) | (start & 7);
+			while (bit > start && !generic_test_le_bit(bit - 1, bmp))
+				bit--;
+			goto ret_bit;
+		}
+	}
+	bit = generic_find_next_zero_le_bit(bmp, end, start);
+	cond_resched();
+
+ret_bit:
+	if (unlikely(bit >= end))
+		return -ENOSPC;
+	return bit;
+}
+
+/*
+ * Find the bitmap limit in bits.
+ *
+ * All the bitmaps hold s->chunk_size << BITS_PER_BYTE_SHIFT bits, except
+ * the last one where we must use s->dev_size modulo number of bits in bitmap
+ * to find the valid number of bits. Note that bits past s->dev_size are
+ * undefined, there can be anything, so we must not scan past this limit.
+ */
+static unsigned bitmap_limit(struct dm_exception_store *s, bitmap_t bmp)
+{
+	if (bmp == (bitmap_t)(s->dev_size >> (s->chunk_shift + BITS_PER_BYTE_SHIFT)))
+		return (unsigned)s->dev_size & ((s->chunk_size << BITS_PER_BYTE_SHIFT) - 1);
+	return s->chunk_size << BITS_PER_BYTE_SHIFT;
+}
+
+/*
+ * The central allocation routine.
+ *
+ * Allocation strategy:
+ *
+ * We maintain s->alloc_rover to point past the last allocated blocks (and wraps
+ * around back to 0 if it would point past the device end).
+ *
+ * We attempt to allocate at the rover and increment the rover, this will
+ * minimize seek times for writes. I assume that this snapshot driver will be
+ * mostly loaded with write requests (it happens when writing to the origin),
+ * so I attempt to optimize for writes.
+ *
+ * If there is no space at the rover, find the whole free byte (8 bits) in the
+ * current chunk. If there is not any free byte, we search the individual bits.
+ * If we don't find any bit, continue with the next bitmap. If we scan the whole
+ * device linearly and still don't find anything, abort with a failure.
+ *
+ * This is similar to what ext[23] does, so I suppose it is tuned well enough
+ * that it won't fragment too much.
+ */
+int dm_multisnap_alloc_blocks(struct dm_exception_store *s, chunk_t *results,
+			      unsigned n_blocks, int flags)
+{
+	void *bmp;
+	struct dm_buffer *bp;
+	chunk_t block;
+	int wrap_around = 0;
+	int start_bit;
+	int wide_search;
+	int i;
+	bitmap_t bitmap_no;
+	int c;
+	int bit;
+	chunk_t to_free = 0;
+
+	bitmap_no = s->alloc_rover >> (s->chunk_shift + BITS_PER_BYTE_SHIFT);
+next_bitmap:
+	bmp = dm_multisnap_map_bitmap(s, bitmap_no, &bp, &block, NULL);
+	if (unlikely(!bmp))
+		return -1;
+
+	wide_search = 1;
+find_again:
+	start_bit = s->alloc_rover & ((s->chunk_size << BITS_PER_BYTE_SHIFT) - 1);
+
+	for (i = 0; i < n_blocks; i++) {
+find_another_bit:
+		bit = find_bit(bmp, start_bit, bitmap_limit(s, bitmap_no), wide_search);
+		if (unlikely(bit < 0)) {
+bit_find_failed:
+			if (wide_search) {
+				wide_search = 0;
+				goto find_again;
+			}
+			dm_bufio_release(bp);
+			s->alloc_rover = (chunk_t) ++bitmap_no << (s->chunk_shift + BITS_PER_BYTE_SHIFT);
+			if (unlikely(s->alloc_rover >= s->dev_size)) {
+				s->alloc_rover = 0;
+				bitmap_no = 0;
+				wrap_around++;
+				if (wrap_around >= 2) {
+					DM_MULTISNAP_SET_ERROR(s->dm, -ENOSPC, ("snapshot overflow"));
+					return -1;
+				}
+			}
+			goto next_bitmap;
+		}
+		results[i] = ((chunk_t)bitmap_no << (s->chunk_shift + BITS_PER_BYTE_SHIFT)) | bit;
+		start_bit = bit + 1;
+		dm_bufio_release(bp);
+
+		c = dm_multisnap_check_allocated_block(s, results[i]);
+		if (dm_multisnap_has_error(s->dm))
+			return -1;
+
+		bmp = dm_multisnap_read_block(s, block, &bp);
+		if (unlikely(!bmp))
+			return -1;
+
+		if (unlikely(c))
+			goto find_another_bit;
+	}
+
+	if (flags & ALLOC_DRY)
+		goto bp_release_return;
+
+	if (!dm_multisnap_block_is_uncommitted(s, block)) {
+		chunk_t new_block;
+find_another_bit_for_bitmap:
+		bit = find_bit(bmp, start_bit, bitmap_limit(s, bitmap_no), wide_search);
+		if (unlikely(bit < 0))
+			goto bit_find_failed;
+
+		new_block = ((chunk_t)bitmap_no << (s->chunk_shift + BITS_PER_BYTE_SHIFT)) | bit;
+		start_bit = bit + 1;
+
+		dm_bufio_release(bp);
+		c = dm_multisnap_check_allocated_block(s, new_block);
+		if (dm_multisnap_has_error(s->dm))
+			return -1;
+
+		bmp = dm_multisnap_read_block(s, block, &bp);
+		if (unlikely(!bmp))
+			return -1;
+
+		if (unlikely(c))
+			goto find_another_bit_for_bitmap;
+
+		/*
+		 * Warning: record the address of a block to free in a special
+		 * variable.
+		 *
+		 * If we freed it here, that could recurse back to
+		 * dm_multisnap_alloc_blocks and corrupt allocations. Free it
+		 * later when we are done with the allocation and all the
+		 * allocated blocks are marked in the bitmap.
+		 */
+		bmp = dm_multisnap_duplicate_block(s, block, new_block, bitmap_no, &bp, &to_free);
+		if (unlikely(!bmp))
+			return -1;
+
+		generic___set_le_bit(bit, bmp);
+		dm_multisnap_status_lock(s->dm);
+		s->total_allocated++;
+		dm_multisnap_status_unlock(s->dm);
+	}
+
+	for (i = 0; i < n_blocks; i++)
+		generic___set_le_bit(results[i] & ((s->chunk_size << BITS_PER_BYTE_SHIFT) - 1), bmp);
+	dm_multisnap_status_lock(s->dm);
+	s->total_allocated += n_blocks;
+	dm_multisnap_status_unlock(s->dm);
+
+	dm_bufio_mark_buffer_dirty(bp);
+
+bp_release_return:
+	dm_bufio_release(bp);
+
+	s->alloc_rover = (s->alloc_rover & ~(chunk_t)((s->chunk_size << BITS_PER_BYTE_SHIFT) - 1)) + start_bit;
+	if (unlikely(s->alloc_rover >= s->dev_size))
+		s->alloc_rover = 0;
+
+	if (unlikely(to_free != 0))
+		dm_multisnap_free_block(s, to_free, 0);
+
+	return 0;
+}
+
+/*
+ * This function gets a valid block number (block), buffer for this block (bp)
+ * and data in this buffer (ptr) and returns new writeable block. It possibly
+ * moves the data to another buffer and updates *bp.
+ *
+ * Note that to maintain log-structured storage, we must not write to the block,
+ * but we must allocate new block and copy the data there.
+ *
+ * The only case where we can write to the provided block directly is if the
+ * block was created since last commit.
+ */
+
+void *dm_multisnap_alloc_duplicate_block(struct dm_exception_store *s, chunk_t block,
+					 struct dm_buffer **bp, void *ptr)
+{
+	int r;
+	chunk_t new_chunk;
+	void *data;
+
+	if (dm_multisnap_block_is_uncommitted(s, block))
+		return ptr;
+
+	dm_bufio_release(*bp);
+
+	r = dm_multisnap_alloc_blocks(s, &new_chunk, 1, 0);
+	if (r)
+		return NULL;
+
+	data = dm_multisnap_read_block(s, block, bp);
+	if (!data)
+		return NULL;
+
+	return dm_multisnap_duplicate_block(s, block, new_chunk,
+					    CB_BITMAP_IDX_NONE, bp, NULL);
+}
+
+/*
+ * Allocate a new block and return its data. Return the block number in *result
+ * and buffer pointer in *bp.
+ */
+void *dm_multisnap_alloc_make_block(struct dm_exception_store *s, chunk_t *result,
+				    struct dm_buffer **bp)
+{
+	int r = dm_multisnap_alloc_blocks(s, result, 1, 0);
+	if (unlikely(r < 0))
+		return NULL;
+
+	return dm_multisnap_make_block(s, *result, bp);
+}
+
+/*
+ * Free the block immediately. You must be careful with this function because
+ * it doesn't follow log-structured protocol.
+ *
+ * It may be used only if
+ * - the blocks to free were allocated since last transactions.
+ * - or from freelist management, which means the blocks were already recorded in
+ *   a freelist (thus it would be freed again in case of machine crash).
+ */
+void dm_multisnap_free_blocks_immediate(struct dm_exception_store *s, chunk_t block,
+					unsigned n_blocks)
+{
+	void *bmp;
+	struct dm_buffer *bp;
+
+	if (!n_blocks)
+		return;
+
+	if (unlikely(block + n_blocks > s->dev_size)) {
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("dm_multisnap_free_block_immediate: freeing invalid blocks %llx, %x",
+					(unsigned long long)block, n_blocks));
+		return;
+	}
+
+	if (block + n_blocks == s->alloc_rover)
+		s->alloc_rover = block;
+
+	do {
+		bitmap_t bitmap_no = block >> (s->chunk_shift + BITS_PER_BYTE_SHIFT);
+
+		bmp = dm_multisnap_map_bitmap(s, bitmap_no, &bp, NULL, NULL);
+		if (!bmp)
+			return;
+
+		do {
+			generic___clear_le_bit(block & ((s->chunk_size << BITS_PER_BYTE_SHIFT) - 1), bmp);
+			dm_multisnap_status_lock(s->dm);
+			s->total_allocated--;
+			dm_multisnap_status_unlock(s->dm);
+			n_blocks--;
+			block++;
+			cond_resched();
+		} while (n_blocks && (block & ((s->chunk_size << BITS_PER_BYTE_SHIFT) - 1)));
+
+		dm_bufio_mark_buffer_dirty(bp);
+		dm_bufio_release(bp);
+	} while (unlikely(n_blocks != 0));
+}
+
+/*
+ * Flush tmp_remaps for bitmaps. Write the path from modified bitmaps to the
+ * root.
+ */
+void dm_multisnap_bitmap_finalize_tmp_remap(struct dm_exception_store *s, struct tmp_remap *tmp_remap)
+{
+	chunk_t block;
+	struct dm_buffer *bp;
+	__u64 *new_block;
+	struct path_element path[MAX_BITMAP_DEPTH];
+	int results_ptr;
+
+	chunk_t new_blockn;
+	int i;
+
+	/*
+	 * Preallocate twice the required amount of blocks, so that resolving
+	 * the next tmp_remap (created here, in dm_multisnap_alloc_blocks)
+	 * doesn't have to allocate anything.
+	 */
+	if (s->n_preallocated_blocks < s->bitmap_depth) {
+		if (unlikely(dm_multisnap_alloc_blocks(s, s->preallocated_blocks + s->n_preallocated_blocks,
+						       s->bitmap_depth * 2 - s->n_preallocated_blocks, 0) < 0))
+			return;
+		s->n_preallocated_blocks = s->bitmap_depth * 2;
+	}
+	results_ptr = 0;
+
+	new_block = dm_multisnap_map_bitmap(s, tmp_remap->bitmap_idx, &bp, &block, path);
+	if (unlikely(!new_block))
+		return;
+
+	dm_bufio_release(bp);
+
+	new_blockn = tmp_remap->new;
+	for (i = s->bitmap_depth - 1; i >= 0; i--) {
+		chunk_t block_to_free;
+		int remapped = 0;
+		__u64 *bmp = dm_multisnap_read_block(s, path[i].block, &bp);
+		if (unlikely(!bmp))
+			return;
+
+		if (!dm_multisnap_block_is_uncommitted(s, path[i].block)) {
+			remapped = 1;
+			dm_bufio_release_move(bp, s->preallocated_blocks[results_ptr]);
+			bmp = dm_multisnap_read_block(s, s->preallocated_blocks[results_ptr], &bp);
+			if (!bmp)
+				return;
+			dm_multisnap_block_set_uncommitted(s, s->preallocated_blocks[results_ptr]);
+		}
+
+		block_to_free = le64_to_cpu(bmp[path[i].idx]);
+		bmp[path[i].idx] = cpu_to_le64(new_blockn);
+		dm_bufio_mark_buffer_dirty(bp);
+		dm_bufio_release(bp);
+
+		dm_multisnap_free_block(s, block_to_free, 0);
+
+		if (!remapped)
+			goto skip_it;
+		new_blockn = s->preallocated_blocks[results_ptr];
+		results_ptr++;
+	}
+
+	dm_multisnap_free_block(s, s->bitmap_root, 0);
+	s->bitmap_root = new_blockn;
+
+skip_it:
+	memmove(s->preallocated_blocks, s->preallocated_blocks + results_ptr,
+		(s->n_preallocated_blocks -= results_ptr) * sizeof(chunk_t));
+}
-- 
1.6.5.2
