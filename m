From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 09/14] dm-multisnap-mikulas-freelist
Date: Mon,  1 Mar 2010 19:23:53 -0500
Message-ID: <1267489438-6271-10-git-send-email-snitzer@redhat.com>
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

Freelist management.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-multisnap-freelist.c |  296 ++++++++++++++++++++++++++++++++++++
 1 files changed, 296 insertions(+), 0 deletions(-)
 create mode 100644 drivers/md/dm-multisnap-freelist.c

diff --git a/drivers/md/dm-multisnap-freelist.c b/drivers/md/dm-multisnap-freelist.c
new file mode 100644
index 0000000..6ec1476
--- /dev/null
+++ b/drivers/md/dm-multisnap-freelist.c
@@ -0,0 +1,296 @@
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
+ * Initialize in-memory freelist structure.
+ */
+void dm_multisnap_init_freelist(struct dm_multisnap_freelist *fl, unsigned chunk_size)
+{
+	cond_resched();
+	memset(fl, 0, chunk_size);
+	cond_resched();
+	fl->signature = FL_SIGNATURE;
+	write_48(fl, backlink, 0);
+	fl->n_entries = cpu_to_le32(0);
+}
+
+/*
+ * Add a given block to in-memory freelist.
+ * Returns:
+ *	-1 --- error
+ *	1 --- block was added
+ *	0 --- block could not be added because the freelist is full
+ */
+static int add_to_freelist(struct dm_exception_store *s, chunk_t block, unsigned flags)
+{
+	int i;
+	struct dm_multisnap_freelist *fl = s->freelist;
+	for (i = le32_to_cpu(fl->n_entries) - 1; i >= 0; i--) {
+		chunk_t x = read_48(&fl->entries[i], block);
+		unsigned r = le16_to_cpu(fl->entries[i].run_length) & FREELIST_RL_MASK;
+		unsigned f = le16_to_cpu(fl->entries[i].run_length) & FREELIST_DATA_FLAG;
+		if (block >= x && block < x + r) {
+			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+					       ("add_to_freelist: freeing already free block %llx (%llx - %x)",
+						(unsigned long long)block,
+						(unsigned long long)x,
+						r));
+			return -1;
+		}
+		if (likely(r < FREELIST_RL_MASK) && likely(f == flags)) {
+			if (block == x - 1) {
+				write_48(&fl->entries[i], block, x - 1);
+				goto inc_length;
+			}
+			if (block == x + r) {
+inc_length:
+				fl->entries[i].run_length = cpu_to_le16((r + 1) | f);
+				return 1;
+			}
+		}
+		cond_resched();
+	}
+	i = le32_to_cpu(fl->n_entries);
+	if (i < dm_multisnap_freelist_entries(s->chunk_size)) {
+		fl->n_entries = cpu_to_le32(i + 1);
+		write_48(&fl->entries[i], block, block);
+		fl->entries[i].run_length = cpu_to_le16(1 | flags);
+		return 1;
+	}
+	return 0;
+}
+
+/*
+ * Read a freelist block from the disk.
+ */
+static struct dm_multisnap_freelist *
+read_freelist(struct dm_exception_store *s, chunk_t block, struct dm_buffer **bp)
+{
+	struct dm_multisnap_freelist *fl;
+	fl = dm_bufio_read(s->bufio, block, bp);
+	if (IS_ERR(fl)) {
+		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(fl),
+				       ("read_freelist: can't read freelist block %llx",
+					(unsigned long long)block));
+		return NULL;
+	}
+	if (fl->signature != FL_SIGNATURE) {
+		dm_bufio_release(*bp);
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("read_freelist: bad signature freelist block %llx",
+					(unsigned long long)block));
+		return NULL;
+	}
+	if (le32_to_cpu(fl->n_entries) > dm_multisnap_freelist_entries(s->chunk_size)) {
+		dm_bufio_release(*bp);
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("read_freelist: bad number of entries in freelist block %llx",
+					(unsigned long long)block));
+		return NULL;
+	}
+	return fl;
+}
+
+/*
+ * Allocate a block and write the current in-memory freelist to it.
+ * Then, clear the in-memory freelist.
+ */
+static void alloc_write_freelist(struct dm_exception_store *s)
+{
+	chunk_t new_block;
+	struct dm_multisnap_freelist *fl;
+	struct dm_buffer *bp;
+
+	if (dm_multisnap_alloc_blocks(s, &new_block, 1, ALLOC_DRY))
+		return;
+
+	fl = dm_bufio_new(s->bufio, new_block, &bp);
+	if (IS_ERR(fl)) {
+		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(fl),
+				       ("alloc_write_freelist: can't make new freelist block %llx",
+					(unsigned long long)new_block));
+		return;
+	}
+
+	memcpy(fl, s->freelist, s->chunk_size);
+
+	dm_bufio_mark_buffer_dirty(bp);
+	dm_bufio_release(bp);
+
+	dm_multisnap_init_freelist(s->freelist, s->chunk_size);
+	write_48(s->freelist, backlink, new_block);
+}
+
+/*
+ * This function is called by other subsystems when they want to free a block.
+ * It adds the block to the current freelist, if the freelist is full, it
+ * flushes the freelist and makes a new one.
+ */
+void dm_multisnap_free_block(struct dm_exception_store *s, chunk_t block, unsigned flags)
+{
+	if (likely(add_to_freelist(s, block, flags)))
+		return;
+
+	alloc_write_freelist(s);
+	if (unlikely(dm_multisnap_has_error(s->dm)))
+		return;
+
+	if (likely(add_to_freelist(s, block, flags)))
+		return;
+
+	BUG();
+}
+
+/*
+ * Check if a given block is in a given freelist.
+ */
+static int check_against_freelist(struct dm_multisnap_freelist *fl, chunk_t block)
+{
+	int i;
+	for (i = le32_to_cpu(fl->n_entries) - 1; i >= 0; i--) {
+		chunk_t x = read_48(&fl->entries[i], block);
+		unsigned r = le16_to_cpu(fl->entries[i].run_length) & FREELIST_RL_MASK;
+		if (unlikely(block - x < r))
+			return 1;
+		cond_resched();
+	}
+	return 0;
+}
+
+/*
+ * Check if a given block is in any freelist in a freelist chain.
+ */
+static int check_against_freelist_chain(struct dm_exception_store *s,
+					chunk_t fl_block, chunk_t block)
+{
+	struct stop_cycles cy;
+	dm_multisnap_init_stop_cycles(&cy);
+
+	while (unlikely(fl_block != 0)) {
+		int c;
+		struct dm_buffer *bp;
+		struct dm_multisnap_freelist *fl;
+
+		if (dm_multisnap_stop_cycles(s, &cy, fl_block))
+			return -1;
+
+		if (unlikely(block == fl_block))
+			return 1;
+
+		fl = read_freelist(s, fl_block, &bp);
+		if (unlikely(!fl))
+			return -1;
+		c = check_against_freelist(fl, block);
+		fl_block = read_48(fl, backlink);
+		dm_bufio_release(bp);
+		if (unlikely(c))
+			return c;
+	}
+	return 0;
+}
+
+/*
+ * Check if a given block can be allocated. This checks against:
+ * - in-memory freelist
+ * - the current freelist chain
+ * - the freelist chain that was active on last commit
+ */
+int dm_multisnap_check_allocated_block(struct dm_exception_store *s, chunk_t block)
+{
+	int c;
+
+	c = check_against_freelist(s->freelist, block);
+	if (unlikely(c))
+		return c;
+
+	c = check_against_freelist_chain(s, read_48(s->freelist, backlink), block);
+	if (unlikely(c))
+		return c;
+
+	c = check_against_freelist_chain(s, s->freelist_ptr, block);
+	if (unlikely(c))
+		return c;
+
+	return 0;
+}
+
+/*
+ * This is called prior to commit, it writes the current freelist to the disk.
+ */
+void dm_multisnap_flush_freelist_before_commit(struct dm_exception_store *s)
+{
+	alloc_write_freelist(s);
+
+	if (dm_multisnap_has_error(s->dm))
+		return;
+
+	s->freelist_ptr = read_48(s->freelist, backlink);
+}
+
+/*
+ * Free the blocks in the freelist.
+ */
+static void free_blocks_in_freelist(struct dm_exception_store *s,
+				    struct dm_multisnap_freelist *fl)
+{
+	int i;
+	for (i = le32_to_cpu(fl->n_entries) - 1; i >= 0; i--) {
+		chunk_t x = read_48(&fl->entries[i], block);
+		unsigned r = le16_to_cpu(fl->entries[i].run_length) & FREELIST_RL_MASK;
+		unsigned f = le16_to_cpu(fl->entries[i].run_length) & FREELIST_DATA_FLAG;
+		dm_multisnap_free_blocks_immediate(s, x, r);
+		if (likely(f & FREELIST_DATA_FLAG)) {
+			dm_multisnap_status_lock(s->dm);
+			s->data_allocated -= r;
+			dm_multisnap_status_unlock(s->dm);
+		}
+		cond_resched();
+	}
+}
+
+/*
+ * This is called after a commit or after a mount. It walks the current freelist
+ * chain and frees the individual blocks.
+ *
+ * If the computer crashes while this operation is in progress, it is done again
+ * after a mount --- thus, it maintains data consistency.
+ */
+void dm_multisnap_load_freelist(struct dm_exception_store *s)
+{
+	chunk_t fl_block = s->freelist_ptr;
+
+	struct stop_cycles cy;
+	dm_multisnap_init_stop_cycles(&cy);
+
+	while (fl_block) {
+		struct dm_buffer *bp;
+		struct dm_multisnap_freelist *fl;
+
+		if (dm_multisnap_stop_cycles(s, &cy, fl_block))
+			break;
+
+		if (dm_multisnap_has_error(s->dm))
+			break;
+
+		fl = read_freelist(s, fl_block, &bp);
+		if (!fl)
+			break;
+		memcpy(s->freelist, fl, s->chunk_size);
+		dm_bufio_release(bp);
+
+		free_blocks_in_freelist(s, s->freelist);
+		fl_block = read_48(s->freelist, backlink);
+	}
+
+	/* Write the buffers eagerly to prevent further delays */
+	dm_bufio_write_dirty_buffers_async(s->bufio);
+
+	dm_multisnap_init_freelist(s->freelist, s->chunk_size);
+}
-- 
1.6.5.2
