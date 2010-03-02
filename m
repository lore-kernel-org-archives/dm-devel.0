From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 06/14] dm-multisnap-mikulas-btree
Date: Mon,  1 Mar 2010 19:23:50 -0500
Message-ID: <1267489438-6271-7-git-send-email-snitzer@redhat.com>
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

B+tree operations.

Adding and deleting entries and walking the whole b+tree.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-multisnap-btree.c |  838 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 838 insertions(+), 0 deletions(-)
 create mode 100644 drivers/md/dm-multisnap-btree.c

diff --git a/drivers/md/dm-multisnap-btree.c b/drivers/md/dm-multisnap-btree.c
new file mode 100644
index 0000000..a7e3b60
--- /dev/null
+++ b/drivers/md/dm-multisnap-btree.c
@@ -0,0 +1,838 @@
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
+ * Read one btree node and do basic consistency checks.
+ * Any btree access should be done with this function.
+ */
+static struct dm_multisnap_bt_node *
+dm_multisnap_read_btnode(struct dm_exception_store *s, int depth,
+			 chunk_t block, unsigned want_entries, struct dm_buffer **bp)
+{
+	struct dm_multisnap_bt_node *node;
+
+	BUG_ON((unsigned)depth >= s->bt_depth);
+
+	node = dm_multisnap_read_block(s, block, bp);
+	if (unlikely(!node))
+		return NULL;
+
+	if (unlikely(node->signature != BT_SIGNATURE)) {
+		dm_bufio_release(*bp);
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("dm_multisnap_read_btnode: bad signature on btree node %llx",
+					(unsigned long long)block));
+		return NULL;
+	}
+
+	if (unlikely((unsigned)(le32_to_cpu(node->n_entries) - 1) >= s->btree_entries) ||
+	    (want_entries && unlikely(le32_to_cpu(node->n_entries) != want_entries))) {
+		dm_bufio_release(*bp);
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("dm_multisnap_read_btnode: bad number of entries in btree node "
+					"%llx: %x, wanted %x",
+					(unsigned long long)block,
+					le32_to_cpu(node->n_entries),
+					want_entries));
+		return NULL;
+	}
+
+	return node;
+}
+
+/*
+ * Write orig_chunk entry.
+ *
+ * If we are compiled with 32-bit chunk_t, we must write the special fields
+ * with bits 32-47 set, so that the store could be read on a system with
+ * 64-bit chunk_t.
+ */
+static void write_orig_chunk(struct dm_multisnap_bt_entry *be, chunk_t n)
+{
+	write_48(be, orig_chunk, n);
+	if (sizeof(chunk_t) == 4 && unlikely(n > DM_CHUNK_T_MAX))
+		be->orig_chunk2 = cpu_to_le16(0xffff);
+}
+
+/*
+ * Add an entry (key, new_chunk) at an appropriate index to the btree node.
+ * Move the existing entries
+ */
+static void add_at_idx(struct dm_multisnap_bt_node *node, unsigned index,
+		       struct bt_key *key, chunk_t new_chunk)
+{
+	memmove(&node->entries[index + 1], &node->entries[index],
+		(le32_to_cpu(node->n_entries) - index) * sizeof(struct dm_multisnap_bt_entry));
+	write_orig_chunk(&node->entries[index], key->chunk);
+	write_48(&node->entries[index], new_chunk, new_chunk);
+	node->entries[index].snap_from = cpu_to_mikulas_snapid(key->snap_from);
+	node->entries[index].snap_to = cpu_to_mikulas_snapid(key->snap_to);
+	node->entries[index].flags = cpu_to_le32(0);
+	node->n_entries = cpu_to_le32(le32_to_cpu(node->n_entries) + 1);
+}
+
+/*
+ * Create an initial btree.
+ * (*writing_block) is updated to point after the btree.
+ */
+void dm_multisnap_create_btree(struct dm_exception_store *s, chunk_t *writing_block)
+{
+	struct dm_buffer *bp;
+	struct dm_multisnap_bt_node *node;
+	struct bt_key new_key;
+
+	while (dm_multisnap_is_commit_block(s, *writing_block))
+		(*writing_block)++;
+
+	if (*writing_block >= s->dev_size) {
+		DM_MULTISNAP_SET_ERROR(s->dm, -ENOSPC,
+				       ("dm_multisnap_create_btree: device is too small"));
+		return;
+	}
+
+	node = dm_bufio_new(s->bufio, *writing_block, &bp);
+	if (IS_ERR(node)) {
+		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(node),
+				       ("dm_multisnap_create_btree: 't create direct bitmap block at %llx",
+					(unsigned long long)*writing_block));
+		return;
+	}
+	memset(node, 0, s->chunk_size);
+	node->signature = BT_SIGNATURE;
+	node->n_entries = cpu_to_le32(0);
+
+	/*
+	 * A btree node must have at least one entry --- so create this empty
+	 * one
+	 */
+	new_key.snap_from = new_key.snap_to = DM_SNAPID_T_LAST;
+	new_key.chunk = DM_CHUNK_T_LAST;
+	add_at_idx(node, 0, &new_key, 0);
+
+	dm_bufio_mark_buffer_dirty(bp);
+	dm_bufio_release(bp);
+	s->bt_root = *writing_block;
+	s->bt_depth = 1;
+	(*writing_block)++;
+}
+
+/*
+ * Compare btree entry and a search key. Returns:
+ *	-1: the entry is lower than the key
+ *	1: the entry is higher than the key
+ *	0: the entry matches the key (both entry and key have ranges, a match
+ *		is returned when the ranges overlap)
+ */
+static int compare_key(struct dm_multisnap_bt_entry *e, struct bt_key *key)
+{
+	chunk_t orig_chunk = read_48(e, orig_chunk);
+	if (orig_chunk < key->chunk)
+		return -1;
+	if (orig_chunk > key->chunk)
+		return 1;
+
+	if (mikulas_snapid_to_cpu(e->snap_to) < key->snap_from)
+		return -1;
+	if (mikulas_snapid_to_cpu(e->snap_from) > key->snap_to)
+		return 1;
+
+	return 0;
+}
+
+/*
+ * Perform binary search on the btree node.
+ * Returns: 1 - found, 0 - not found
+ * 	*result - if found, then the first entry in the requested range
+ *		- if not found, then the first entry after the requested range
+ */
+static int binary_search(struct dm_multisnap_bt_node *node, struct bt_key *key,
+			 unsigned *result)
+{
+	int c;
+	int first = 0;
+	int last = le32_to_cpu(node->n_entries) - 1;
+
+	while (1) {
+		int middle = (first + last) >> 1;
+		struct dm_multisnap_bt_entry *e = &node->entries[middle];
+
+		c = compare_key(e, key);
+
+		if (first == last)
+			break;
+
+		if (c < 0)
+			first = middle + 1;
+		else
+			last = middle;
+
+		cond_resched();
+	}
+
+	*result = first;
+	return !c;
+}
+
+/*
+ * Find a given key in the btree.
+ *
+ * Returns: 1 - found, 0 - not found, -1 - error
+ *	In case of not error (0 or 1 is returned), the node and held buffer for
+ *	this node is returned (the buffer must be released with
+ *	dm_bufio_release). Also, path with s->bt_depth entries is returned.
+ */
+static int walk_btree(struct dm_exception_store *s, struct bt_key *key,
+		      struct dm_multisnap_bt_node **nodep, struct dm_buffer **bp,
+		      struct path_element path[MAX_BT_DEPTH])
+{
+#define		node (*nodep)
+	int r;
+	chunk_t block = s->bt_root;
+	unsigned d = 0;
+
+	/*
+	 * These four are purely to check tree consistency.
+	 * They could be commented out. But it's safer to leave them there.
+	 */
+	chunk_t want_last_chunk = DM_CHUNK_T_LAST;
+	mikulas_snapid_t want_last_snapid = DM_SNAPID_T_LAST;
+	chunk_t last_chunk;
+	mikulas_snapid_t last_snapid;
+
+	while (1) {
+		path[d].block = block;
+		node = dm_multisnap_read_btnode(s, d, block, 0, bp);
+		if (!node)
+			return -1;
+		path[d].n_entries = le32_to_cpu(node->n_entries);
+
+		/* Check consistency (can be commented out) */
+		last_chunk = read_48(&node->entries[path[d].n_entries - 1], orig_chunk);
+		last_snapid = mikulas_snapid_to_cpu(node->entries[path[d].n_entries - 1].snap_to);
+		if (unlikely(last_chunk != want_last_chunk) ||
+		    unlikely(last_snapid != want_last_snapid)) {
+			dm_bufio_release(*bp);
+			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+					       ("walk_btree: invalid last entry in node %llx/%llx: "
+						"last_chunk %llx, want_last_chunk %llx, last_snapid: %llx, "
+						"want_last_snapid: %llx, searching for %llx, %llx-%llx",
+						(unsigned long long)block,
+						(unsigned long long)dm_multisnap_remap_block(s, block),
+						(unsigned long long)last_chunk,
+						(unsigned long long)want_last_chunk,
+						(unsigned long long)last_snapid,
+						(unsigned long long)want_last_snapid,
+						(unsigned long long)key->chunk,
+						(unsigned long long)key->snap_from,
+						(unsigned long long)key->snap_to));
+			return -1;
+		}
+
+		r = binary_search(node, key, &path[d].idx);
+
+		want_last_chunk = read_48(&node->entries[path[d].idx], orig_chunk);
+		want_last_snapid = mikulas_snapid_to_cpu(node->entries[path[d].idx].snap_to);
+
+		block = read_48(&node->entries[path[d].idx], new_chunk);
+		if (++d == s->bt_depth)
+			break;
+		dm_bufio_release(*bp);
+	}
+	if (unlikely(compare_key(&node->entries[path[s->bt_depth - 1].idx], key) < 0))
+		path[s->bt_depth - 1].idx++;
+	return r;
+#undef node
+}
+
+/*
+ * Find a given key in the btree.
+ *
+ * Returns: 1 - found, 0 - not found, -1 - error
+ *	In case the node is found, key contains updated key and result contains
+ *	the resulting chunk.
+ */
+int dm_multisnap_find_in_btree(struct dm_exception_store *s, struct bt_key *key,
+			       chunk_t *result)
+{
+	struct dm_multisnap_bt_node *node;
+	struct path_element path[MAX_BT_DEPTH];
+	struct dm_buffer *bp;
+
+	int r = walk_btree(s, key, &node, &bp, path);
+	if (unlikely(r < 0))
+		return r;
+
+	if (r) {
+		struct dm_multisnap_bt_entry *entry = &node->entries[path[s->bt_depth - 1].idx];
+		*result = read_48(entry, new_chunk);
+		key->chunk = read_48(entry, orig_chunk);
+		key->snap_from = mikulas_snapid_to_cpu(entry->snap_from);
+		key->snap_to = mikulas_snapid_to_cpu(entry->snap_to);
+	}
+	dm_bufio_release(bp);
+
+	return r;
+}
+
+/*
+ * Scan the btree sequentially.
+ * Start with the given key. Perform "call" on each leaf node. When call returns
+ * nonzero, terminate the scan and return the value returned from call.
+ * When the whole tree is scanned, return 0.
+ * On error, return -1.
+ */
+int dm_multisnap_list_btree(struct dm_exception_store *s, struct bt_key *key,
+			    int (*call)(struct dm_exception_store *, struct dm_multisnap_bt_node *,
+					struct dm_multisnap_bt_entry *, void *),
+			    void *cookie)
+{
+	struct dm_multisnap_bt_node *node;
+	struct path_element path[MAX_BT_DEPTH];
+	struct dm_buffer *bp;
+	int depth;
+	int i;
+	int r;
+
+	r = walk_btree(s, key, &node, &bp, path);
+	if (unlikely(r < 0))
+		return r;
+
+list_next_node:
+	for (i = path[s->bt_depth - 1].idx; i < le32_to_cpu(node->n_entries); i++) {
+		cond_resched();
+		r = call(s, node, &node->entries[i], cookie);
+		if (unlikely(r)) {
+			dm_bufio_release(bp);
+			return r;
+		}
+	}
+	dm_bufio_release(bp);
+
+	for (depth = s->bt_depth - 2; depth >= 0; depth--) {
+		int idx;
+		node = dm_multisnap_read_btnode(s, depth, path[depth].block,
+						path[depth].n_entries, &bp);
+		if (!node)
+			return -1;
+		idx = path[depth].idx + 1;
+		if (idx < path[depth].n_entries) {
+			r = compare_key(&node->entries[idx], key);
+			if (unlikely(r <= 0)) {
+				dm_bufio_release(bp);
+				DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+						       ("dm_multisnap_list_btree: non-monotonic btree: node "
+							"%llx, index %x",
+							(unsigned long long)path[depth].block, idx));
+				return 0;
+			}
+			path[depth].idx = idx;
+			do {
+				depth++;
+				path[depth].block = read_48(&node->entries[path[depth - 1].idx], new_chunk);
+				path[depth].idx = 0;
+				dm_bufio_release(bp);
+				node = dm_multisnap_read_btnode(s, depth, path[depth].block, 0, &bp);
+				if (!node)
+					return -1;
+				path[depth].n_entries = le32_to_cpu(node->n_entries);
+			} while (depth < s->bt_depth - 1);
+			goto list_next_node;
+		}
+		dm_bufio_release(bp);
+	}
+
+	return 0;
+}
+
+/*
+ * Add a key and chunk to the btree.
+ * The key must not overlap with any existing btree entry.
+ */
+
+void dm_multisnap_add_to_btree(struct dm_exception_store *s, struct bt_key *key, chunk_t new_chunk)
+{
+	struct dm_multisnap_bt_node *node;
+	struct dm_buffer *bp;
+	struct path_element path[MAX_BT_DEPTH];
+	int depth;
+
+	unsigned split_entries, split_index, split_offset, split_size;
+	struct bt_key new_key;
+	struct dm_multisnap_bt_entry *last_one;
+	chunk_t new_root;
+
+	int r = walk_btree(s, key, &node, &bp, path);
+
+	if (unlikely(r)) {
+		if (r > 0) {
+			dm_bufio_release(bp);
+			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+					       ("dm_multisnap_add_to_btree: adding key that already exists: "
+						"%llx, %llx-%llx",
+						(unsigned long long)key->chunk,
+						(unsigned long long)key->snap_from,
+						(unsigned long long)key->snap_to));
+		}
+		return;
+	}
+
+	depth = s->bt_depth - 1;
+
+go_up:
+	node = dm_multisnap_alloc_duplicate_block(s, path[depth].block, &bp, node);
+	if (unlikely(!node))
+		return;
+
+	if (likely(le32_to_cpu(node->n_entries) < s->btree_entries)) {
+		add_at_idx(node, path[depth].idx, key, new_chunk);
+		dm_bufio_mark_buffer_dirty(bp);
+		dm_bufio_release(bp);
+		return;
+	}
+	cond_resched();
+	memcpy(s->tmp_chunk, node, s->chunk_size);
+	cond_resched();
+	add_at_idx(s->tmp_chunk, path[depth].idx, key, new_chunk);
+
+	split_entries = le32_to_cpu(((struct dm_multisnap_bt_node *)s->tmp_chunk)->n_entries);
+	split_index = split_entries / 2;
+	split_offset = sizeof(struct dm_multisnap_bt_node) + split_index * sizeof(struct dm_multisnap_bt_entry);
+	split_size = sizeof(struct dm_multisnap_bt_node) + split_entries * sizeof(struct dm_multisnap_bt_entry);
+	cond_resched();
+	memcpy(node, s->tmp_chunk, sizeof(struct dm_multisnap_bt_node));
+	cond_resched();
+	memcpy((char *)node + sizeof(struct dm_multisnap_bt_node),
+	       (char *)s->tmp_chunk + split_offset, split_size - split_offset);
+	cond_resched();
+	memset((char *)node + sizeof(struct dm_multisnap_bt_node) + split_size - split_offset, 0,
+	       s->chunk_size - (sizeof(struct dm_multisnap_bt_node) + split_size - split_offset));
+	cond_resched();
+	node->n_entries = cpu_to_le32(split_entries - split_index);
+
+	dm_bufio_mark_buffer_dirty(bp);
+	dm_bufio_release(bp);
+
+	node = dm_multisnap_alloc_make_block(s, &new_chunk, &bp);
+	if (unlikely(!node))
+		return;
+
+	cond_resched();
+	memcpy(node, s->tmp_chunk, split_offset);
+	cond_resched();
+	memset((char *)node + split_offset, 0, s->chunk_size - split_offset);
+	cond_resched();
+	node->n_entries = cpu_to_le32(split_index);
+
+	last_one = &node->entries[split_index - 1];
+	new_key.chunk = read_48(last_one, orig_chunk);
+	new_key.snap_from = mikulas_snapid_to_cpu(last_one->snap_to);
+	new_key.snap_to = mikulas_snapid_to_cpu(last_one->snap_to);
+
+	key = &new_key;
+
+	dm_bufio_mark_buffer_dirty(bp);
+	dm_bufio_release(bp);
+
+	if (depth--) {
+		node = dm_multisnap_read_btnode(s, depth, path[depth].block,
+						path[depth].n_entries, &bp);
+		if (unlikely(!node))
+			return;
+		goto go_up;
+	}
+
+	if (s->bt_depth >= MAX_BT_DEPTH) {
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("dm_multisnap_add_to_btree: max b+-tree depth reached"));
+		return;
+	}
+
+	node = dm_multisnap_alloc_make_block(s, &new_root, &bp);
+	if (unlikely(!node))
+		return;
+
+	cond_resched();
+	memset(node, 0, s->chunk_size);
+	cond_resched();
+	node->signature = BT_SIGNATURE;
+	node->n_entries = cpu_to_le32(0);
+	add_at_idx(node, 0, &new_key, new_chunk);
+	new_key.snap_from = new_key.snap_to = DM_SNAPID_T_LAST;
+	new_key.chunk = DM_CHUNK_T_LAST;
+	add_at_idx(node, 1, &new_key, path[0].block);
+
+	dm_bufio_mark_buffer_dirty(bp);
+	dm_bufio_release(bp);
+
+	s->bt_root = new_root;
+	s->bt_depth++;
+}
+
+/*
+ * Change the last entry from old_chunk/old_snapid to new_chunk/new_snapid.
+ * Start at a given depth and go upward to the root.
+ */
+static void dm_multisnap_fixup_backlimits(struct dm_exception_store *s,
+					  struct path_element path[MAX_BT_DEPTH], int depth,
+					  chunk_t old_chunk, mikulas_snapid_t old_snapid,
+					  chunk_t new_chunk, mikulas_snapid_t new_snapid)
+{
+	int idx;
+	struct dm_multisnap_bt_node *node;
+	struct dm_buffer *bp;
+
+	if (old_chunk == new_chunk && old_snapid == new_snapid)
+		return;
+
+	for (depth--; depth >= 0; depth--) {
+		node = dm_multisnap_read_btnode(s, depth, path[depth].block,
+						path[depth].n_entries, &bp);
+		if (unlikely(!node))
+			return;
+
+		node = dm_multisnap_alloc_duplicate_block(s, path[depth].block, &bp, node);
+		if (unlikely(!node))
+			return;
+
+		idx = path[depth].idx;
+
+		if (unlikely(read_48(&node->entries[idx], orig_chunk) != old_chunk) ||
+		    unlikely(mikulas_snapid_to_cpu(node->entries[idx].snap_from) != old_snapid) ||
+		    unlikely(mikulas_snapid_to_cpu(node->entries[idx].snap_to) != old_snapid)) {
+			dm_bufio_release(bp);
+			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+					       ("dm_multisnap_fixup_backlimits: btree limit does not match, block "
+						"%llx, idx %x, orig_chunk %llx, snap_from %llx, snap_to "
+						"%llx, want %llx, %llx",
+						(unsigned long long)path[depth].block,
+						idx,
+						(unsigned long long)read_48(&node->entries[idx], orig_chunk),
+						(unsigned long long)mikulas_snapid_to_cpu(node->entries[idx].snap_from),
+						(unsigned long long)mikulas_snapid_to_cpu(node->entries[idx].snap_to),
+						(unsigned long long)old_chunk,
+						(unsigned long long)old_snapid));
+			return;
+		}
+		write_48(&node->entries[idx], orig_chunk, new_chunk);
+		node->entries[idx].snap_from = node->entries[idx].snap_to = cpu_to_mikulas_snapid(new_snapid);
+
+		dm_bufio_mark_buffer_dirty(bp);
+		dm_bufio_release(bp);
+
+		if (path[depth].idx != path[depth].n_entries - 1)
+			return;
+	}
+	DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+			       ("dm_multisnap_fixup_backlimits: the last entry modified, %llx/%llx -> %llx/%llx",
+				(unsigned long long)old_chunk,
+				(unsigned long long)old_snapid,
+				(unsigned long long)new_chunk,
+				(unsigned long long)new_snapid));
+}
+
+/*
+ * Restrict the range of an existing btree entry.
+ * The key must have the same beginning or end as some existing entry (not both)
+ * The range of the key is excluded from the entry.
+ */
+void dm_multisnap_restrict_btree_entry(struct dm_exception_store *s, struct bt_key *key)
+{
+	struct dm_multisnap_bt_node *node;
+	struct path_element path[MAX_BT_DEPTH];
+	struct dm_buffer *bp;
+	int idx;
+	struct dm_multisnap_bt_entry *entry;
+	mikulas_snapid_t from, to, new_to;
+
+	int r = walk_btree(s, key, &node, &bp, path);
+	if (unlikely(r < 0))
+		return;
+
+	if (!r) {
+		dm_bufio_release(bp);
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("dm_multisnap_restrict_btree_entry: unknown key: %llx, %llx-%llx",
+					(unsigned long long)key->chunk,
+					(unsigned long long)key->snap_from,
+					(unsigned long long)key->snap_to));
+		return;
+	}
+
+	node = dm_multisnap_alloc_duplicate_block(s, path[s->bt_depth - 1].block, &bp, node);
+	if (unlikely(!node))
+		return;
+
+	idx = path[s->bt_depth - 1].idx;
+	entry = &node->entries[idx];
+	from = mikulas_snapid_to_cpu(entry->snap_from);
+	to = new_to = mikulas_snapid_to_cpu(entry->snap_to);
+	if (key->snap_from == from && key->snap_to < to) {
+		entry->snap_from = cpu_to_mikulas_snapid(key->snap_to + 1);
+	} else if (key->snap_from > from && key->snap_to == to) {
+		new_to = key->snap_from - 1;
+		entry->snap_to = cpu_to_mikulas_snapid(new_to);
+	} else {
+		dm_bufio_release(bp);
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("dm_multisnap_restrict_btree_entry: invali range to restruct: "
+					"%llx, %llx-%llx %llx-%llx",
+					(unsigned long long)key->chunk,
+					(unsigned long long)from,
+					(unsigned long long)to,
+					(unsigned long long)key->snap_from,
+					(unsigned long long)key->snap_to));
+		return;
+	}
+
+	dm_bufio_mark_buffer_dirty(bp);
+	dm_bufio_release(bp);
+
+	if (unlikely(idx == path[s->bt_depth - 1].n_entries - 1))
+		dm_multisnap_fixup_backlimits(s, path, s->bt_depth - 1,
+					      key->chunk, to, key->chunk, new_to);
+}
+
+/*
+ * Expand range of an existing btree entry.
+ * The key represents the whole new range (including the old and new part).
+ */
+void dm_multisnap_extend_btree_entry(struct dm_exception_store *s, struct bt_key *key)
+{
+	struct dm_multisnap_bt_node *node;
+	struct path_element path[MAX_BT_DEPTH];
+	struct dm_buffer *bp;
+	int idx;
+	struct dm_multisnap_bt_entry *entry;
+	mikulas_snapid_t from, to, new_to;
+
+	int r = walk_btree(s, key, &node, &bp, path);
+	if (unlikely(r < 0))
+		return;
+
+	if (!r) {
+		dm_bufio_release(bp);
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("dm_multisnap_extend_btree_entry: unknown key: "
+					"%llx, %llx-%llx",
+					(unsigned long long)key->chunk,
+					(unsigned long long)key->snap_from,
+					(unsigned long long)key->snap_to));
+		return;
+	}
+
+	node = dm_multisnap_alloc_duplicate_block(s, path[s->bt_depth - 1].block,
+						  &bp, node);
+	if (unlikely(!node))
+		return;
+
+	idx = path[s->bt_depth - 1].idx;
+	entry = &node->entries[idx];
+	from = mikulas_snapid_to_cpu(entry->snap_from);
+	to = new_to = mikulas_snapid_to_cpu(entry->snap_to);
+	if (key->snap_from < from)
+		entry->snap_from = cpu_to_mikulas_snapid(key->snap_from);
+	if (key->snap_to > to) {
+		new_to = key->snap_to;
+		entry->snap_to = cpu_to_mikulas_snapid(new_to);
+	}
+
+	dm_bufio_mark_buffer_dirty(bp);
+	dm_bufio_release(bp);
+
+	if (unlikely(idx == path[s->bt_depth - 1].n_entries - 1))
+		dm_multisnap_fixup_backlimits(s, path, s->bt_depth - 1,
+					      key->chunk, to, key->chunk, new_to);
+}
+
+/*
+ * Delete an entry from the btree.
+ */
+void dm_multisnap_delete_from_btree(struct dm_exception_store *s, struct bt_key *key)
+{
+	struct dm_multisnap_bt_node *node;
+	struct path_element path[MAX_BT_DEPTH];
+	struct dm_buffer *bp;
+	int idx;
+	struct dm_multisnap_bt_entry *entry;
+	mikulas_snapid_t from, to;
+	int depth, n_entries;
+
+	struct dm_multisnap_bt_entry *last_one;
+	chunk_t last_one_chunk;
+	mikulas_snapid_t last_one_snap_to;
+
+	int r = walk_btree(s, key, &node, &bp, path);
+	if (unlikely(r < 0))
+		return;
+
+	if (unlikely(!r)) {
+		dm_bufio_release(bp);
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("dm_multisnap_delete_from_btree: unknown key: %llx, %llx-%llx",
+					(unsigned long long)key->chunk,
+					(unsigned long long)key->snap_from,
+					(unsigned long long)key->snap_to));
+		return;
+	}
+
+	depth = s->bt_depth - 1;
+
+	idx = path[depth].idx;
+	entry = &node->entries[idx];
+	from = mikulas_snapid_to_cpu(entry->snap_from);
+	to = mikulas_snapid_to_cpu(entry->snap_to);
+	if (unlikely(from != key->snap_from) || unlikely(to != key->snap_to)) {
+		dm_bufio_release(bp);
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("dm_multisnap_delete_from_btree: invalid range to restrict: "
+					"%llx, %llx-%llx %llx-%llx",
+					(unsigned long long)key->chunk,
+					(unsigned long long)from,
+					(unsigned long long)to,
+					(unsigned long long)key->snap_from,
+					(unsigned long long)key->snap_to));
+		return;
+	}
+
+	while (unlikely((n_entries = le32_to_cpu(node->n_entries)) == 1)) {
+		dm_bufio_release(bp);
+		if (unlikely(!depth)) {
+			DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+					       ("dm_multisnap_delete_from_btree: b-tree is empty"));
+			return;
+		}
+		dm_multisnap_free_block_and_duplicates(s, path[depth].block);
+		depth--;
+		node = dm_multisnap_read_btnode(s, depth, path[depth].block,
+						path[depth].n_entries, &bp);
+		if (!node)
+			return;
+	}
+
+	node = dm_multisnap_alloc_duplicate_block(s, path[depth].block, &bp, node);
+	if (unlikely(!node))
+		return;
+
+	idx = path[depth].idx;
+
+	cond_resched();
+	memmove(node->entries + idx, node->entries + idx + 1,
+		(n_entries - idx - 1) * sizeof(struct dm_multisnap_bt_entry));
+	cond_resched();
+	n_entries--;
+	memset(node->entries + n_entries, 0, sizeof(struct dm_multisnap_bt_entry));
+
+	node->n_entries = cpu_to_le32(n_entries);
+
+	last_one = &node->entries[n_entries - 1];
+	last_one_chunk = read_48(last_one, orig_chunk);
+	last_one_snap_to = mikulas_snapid_to_cpu(last_one->snap_to);
+
+	dm_bufio_mark_buffer_dirty(bp);
+	dm_bufio_release(bp);
+
+	if (unlikely(idx == n_entries))
+		dm_multisnap_fixup_backlimits(s, path, depth, key->chunk,
+					      key->snap_to, last_one_chunk,
+					      last_one_snap_to);
+}
+
+/*
+ * Process btree tmp remaps.
+ * Find the whole path for tmp_remap and write the path as new entries, from
+ * the root.
+ */
+void dm_multisnap_bt_finalize_tmp_remap(struct dm_exception_store *s,
+					struct tmp_remap *tmp_remap)
+{
+	struct dm_buffer *bp;
+	struct dm_multisnap_bt_node *node;
+	struct bt_key key;
+	struct path_element path[MAX_BT_DEPTH];
+	int results_ptr;
+
+	chunk_t new_blockn;
+	int r;
+	int i;
+
+	if (s->n_preallocated_blocks < s->bt_depth) {
+		if (dm_multisnap_alloc_blocks(s, s->preallocated_blocks + s->n_preallocated_blocks,
+					      s->bt_depth - s->n_preallocated_blocks, 0) < 0)
+			return;
+		s->n_preallocated_blocks = s->bt_depth;
+	}
+	results_ptr = 0;
+
+	/*
+	 * Read the key from this node --- we'll walk the btree according
+	 * to this key to find a path from the root.
+	 */
+	node = dm_multisnap_read_btnode(s, s->bt_depth - 1, tmp_remap->new, 0, &bp);
+	if (!node)
+		return;
+	key.chunk = read_48(&node->entries[0], orig_chunk);
+	key.snap_from = key.snap_to = mikulas_snapid_to_cpu(node->entries[0].snap_from);
+	dm_bufio_release(bp);
+
+	r = walk_btree(s, &key, &node, &bp, path);
+	if (r < 0)
+		return;
+
+	dm_bufio_release(bp);
+
+	for (i = s->bt_depth - 1; i >= 0; i--)
+		if (path[i].block == tmp_remap->old)
+			goto found;
+
+	DMERR("block %llx/%llx was not found in btree when searching for %llx/%llx",
+	      (unsigned long long)tmp_remap->old,
+	      (unsigned long long)tmp_remap->new,
+	      (unsigned long long)key.chunk,
+	      (unsigned long long)key.snap_from);
+	for (i = 0; i < s->bt_depth; i++)
+		DMERR("path[%d]: %llx/%x", i, (unsigned long long)path[i].block, path[i].idx);
+	dm_multisnap_set_error(s->dm, -EFSERROR);
+	return;
+
+found:
+	dm_multisnap_free_block(s, tmp_remap->old, 0);
+
+	new_blockn = tmp_remap->new;
+	for (i--; i >= 0; i--) {
+		int remapped = 0;
+		node = dm_multisnap_read_btnode(s, i, path[i].block, path[i].n_entries, &bp);
+		if (!node)
+			return;
+		if (!dm_multisnap_block_is_uncommitted(s, path[i].block)) {
+			remapped = 1;
+			dm_bufio_release_move(bp, s->preallocated_blocks[results_ptr]);
+			dm_multisnap_free_block_and_duplicates(s, path[i].block);
+			node = dm_multisnap_read_btnode(s, i, s->preallocated_blocks[results_ptr],
+							path[i].n_entries, &bp);
+			if (!node)
+				return;
+			dm_multisnap_block_set_uncommitted(s, s->preallocated_blocks[results_ptr]);
+		}
+		write_48(&node->entries[path[i].idx], new_chunk, new_blockn);
+		dm_bufio_mark_buffer_dirty(bp);
+		dm_bufio_release(bp);
+
+		if (!remapped)
+			goto skip_it;
+		new_blockn = s->preallocated_blocks[results_ptr];
+		results_ptr++;
+	}
+
+	s->bt_root = new_blockn;
+
+skip_it:
+	memmove(s->preallocated_blocks, s->preallocated_blocks + results_ptr,
+		(s->n_preallocated_blocks -= results_ptr) * sizeof(chunk_t));
+}
-- 
1.6.5.2
