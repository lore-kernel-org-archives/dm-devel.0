From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 7/9] dm snapshot: add shared exception store
Date: Mon, 27 Oct 2008 21:07:54 +0900
Message-ID: <1225109276-16491-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1225109276-16491-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1225109276-16491-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This adds a new exception store implementation, shared exception
store. The important design differences from the current two exception
store implementations:

- It uses one exception store (cow disk) per origin device that is
  shared by all snapshots.
- It doesn't keep the complete exception tables in memory.

The shared exception store uses struct pstore, which the persistent
exception store uses because there are many useful functions that
struct pstore works with. The shared exception adds some variants to
struct pstore, but not many.

This code is based on based on Zumastor (http://zumastor.org/).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/md/dm-exception-store.c | 1462 +++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-snap.h            |    3 +
 2 files changed, 1465 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-exception-store.c b/drivers/md/dm-exception-store.c
index 122e2f9..0de09f7 100644
--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -4,6 +4,14 @@
  * Copyright (C) 2001-2002 Sistina Software (UK) Limited.
  * Copyright (C) 2006 Red Hat GmbH
  *
+ * The shared exception code is based on Zumastor (http://zumastor.org/)
+ *
+ * By: Daniel Phillips, Nov 2003 to Mar 2007
+ * (c) 2003, Sistina Software Inc.
+ * (c) 2004, Red Hat Software Inc.
+ * (c) 2005 Daniel Phillips
+ * (c) 2006 - 2007, Google Inc
+ *
  * This file is released under the GPL.
  */
 
@@ -75,6 +83,13 @@ struct disk_header {
 
 	/* In sectors */
 	uint32_t chunk_size;
+
+	/*
+	 * for shared exception
+	 */
+	__le64 root_tree_chunk;
+	__le64 snapmask;
+	__le32 tree_level;
 };
 
 struct disk_exception {
@@ -131,6 +146,27 @@ struct pstore {
 	struct dm_io_client *io_client;
 
 	struct workqueue_struct *metadata_wq;
+
+	/*
+	 * for shared exception
+	 */
+	u64 root_tree_chunk;
+	u64 snapmask;
+	u32 tree_level;
+
+	u32 nr_snapshots;
+
+	unsigned long nr_chunks;
+	unsigned long nr_bitmap_chunks;
+	unsigned long *bitmap;
+	unsigned long cur_bitmap_chunk;
+	unsigned long cur_bitmap_index;
+
+	struct list_head chunk_buffer_list;
+	struct list_head chunk_buffer_dirty_list;
+
+	int header_dirty;
+	int nr_chunk_buffers;
 };
 
 static unsigned sectors_to_pages(unsigned sectors)
@@ -360,6 +396,12 @@ static int write_header(struct pstore *ps)
 	dh->version = cpu_to_le32(ps->version);
 	dh->chunk_size = cpu_to_le32(ps->snap->chunk_size);
 
+	dh->root_tree_chunk = cpu_to_le64(ps->root_tree_chunk);
+	dh->snapmask = cpu_to_le64(ps->snapmask);
+	dh->tree_level = cpu_to_le32(ps->tree_level);
+
+	ps->header_dirty = 0;
+
 	return chunk_io(ps, 0, WRITE, 1, ps->area);
 }
 
@@ -755,3 +797,1423 @@ int dm_create_transient(struct exception_store *store)
 
 	return 0;
 }
+
+/*
+ * shared exception code
+ */
+
+#define SNAP_MAGIC 0x70416e53
+#define FIRST_BITMAP_CHUNK 1
+
+struct chunk_buffer {
+	struct list_head list;
+	struct list_head dirty_list;
+	u64 chunk;
+	void *data;
+};
+
+struct node {
+	__le32 count;
+	__le32 unused;
+	struct index_entry {
+		__le64 key; /* note: entries[0].key never accessed */
+		__le64 chunk; /* node sector address goes here */
+	} entries[];
+};
+
+struct leaf {
+	__le16 magic;
+	__le16 version;
+	__le32 count;
+	/* !!! FIXME the code doesn't use the base_chunk properly */
+	__le64 base_chunk;
+	__le64 using_mask;
+
+	struct tree_map	{
+		__le32 offset;
+		__le32 rchunk;
+	} map[];
+};
+
+struct exception {
+	__le64 share;
+	__le64 chunk;
+};
+
+static inline struct node *buffer2node(struct chunk_buffer *buffer)
+{
+	return (struct node *)buffer->data;
+}
+
+static inline struct leaf *buffer2leaf(struct chunk_buffer *buffer)
+{
+	return (struct leaf *)buffer->data;
+}
+
+static struct chunk_buffer *alloc_chunk_buffer(struct pstore *ps)
+{
+	struct chunk_buffer *b;
+
+	b = kzalloc(sizeof(*b), GFP_NOFS);
+	if (!b) {
+		DMERR("%s %d: out of memory", __func__, __LINE__);
+		return NULL;
+	}
+
+	b->data = vmalloc(ps->snap->chunk_size << SECTOR_SHIFT);
+	if (!b->data) {
+		DMERR("%s %d: out of memory", __func__, __LINE__);
+		kfree(b);
+		return NULL;
+	}
+
+	memset(b->data, 0, ps->snap->chunk_size << SECTOR_SHIFT);
+
+	list_add(&b->list, &ps->chunk_buffer_list);
+	INIT_LIST_HEAD(&b->dirty_list);
+
+	ps->nr_chunk_buffers++;
+
+	return b;
+}
+
+static void free_chunk_buffer(struct pstore *ps, struct chunk_buffer *b)
+{
+	list_del(&b->list);
+	vfree(b->data);
+	kfree(b);
+
+	ps->nr_chunk_buffers--;
+}
+
+static void shared_drop(struct exception_store *store)
+{
+	struct pstore *ps = get_info(store);
+
+	chunk_io(ps, ps->cur_bitmap_chunk, WRITE, 1, ps->bitmap);
+	write_header(ps);
+
+	ps->valid = 0;
+}
+
+static void shared_destroy(struct exception_store *store)
+{
+	struct pstore *ps = get_info(store);
+	struct chunk_buffer *bb, *n;
+
+	list_for_each_entry_safe(bb, n, &ps->chunk_buffer_list, list)
+		free_chunk_buffer(ps, bb);
+
+	shared_drop(store);
+
+	destroy_workqueue(ps->metadata_wq);
+	dm_io_client_destroy(ps->io_client);
+	vfree(ps->bitmap);
+	ps->bitmap = NULL;
+	vfree(ps->callbacks);
+	free_area(ps);
+	kfree(ps);
+}
+
+static int read_new_bitmap_chunk(struct pstore *ps)
+{
+	chunk_io(ps, ps->cur_bitmap_chunk, WRITE, 1, ps->bitmap);
+
+	ps->cur_bitmap_chunk++;
+	if (ps->cur_bitmap_chunk == ps->nr_bitmap_chunks)
+		ps->cur_bitmap_chunk = FIRST_BITMAP_CHUNK;
+
+	chunk_io(ps, ps->cur_bitmap_chunk, READ, 1,  ps->bitmap);
+
+	return 0;
+}
+
+static unsigned long shared_allocate_chunk(struct pstore *ps)
+{
+	unsigned long idx;
+	unsigned long limit;
+	unsigned long start_chunk;
+	unsigned long nr = (ps->snap->chunk_size << SECTOR_SHIFT) * 8;
+
+	start_chunk = ps->cur_bitmap_chunk;
+again:
+	if (ps->cur_bitmap_chunk == ps->nr_bitmap_chunks)
+		limit = ps->nr_chunks - (nr * (ps->nr_bitmap_chunks - 1));
+	else
+		limit = nr;
+
+	idx = find_next_zero_bit(ps->bitmap, limit, ps->cur_bitmap_index);
+	if (idx < limit) {
+		set_bit(idx, ps->bitmap);
+
+		if (idx == limit - 1) {
+			ps->cur_bitmap_index = 0;
+
+			read_new_bitmap_chunk(ps);
+		} else
+			ps->cur_bitmap_index++;
+	} else {
+		chunk_io(ps, ps->cur_bitmap_chunk, WRITE, 1, ps->bitmap);
+
+		read_new_bitmap_chunk(ps);
+
+		/* todo: check # free chunks */
+		if (start_chunk == ps->cur_bitmap_chunk) {
+			DMERR("%s %d: fail to find a new chunk",
+			      __func__, __LINE__);
+			return 0;
+		}
+
+		goto again;
+	}
+
+	return idx + (ps->cur_bitmap_chunk - FIRST_BITMAP_CHUNK) * nr;
+}
+
+static int shared_free_chunk(struct pstore *ps, chunk_t chunk)
+{
+	unsigned long bits_per_chunk
+		= (ps->snap->chunk_size << SECTOR_SHIFT) * 8;
+	unsigned long idx = chunk % bits_per_chunk;
+
+	/* we don't always need to do this... */
+	chunk_io(ps, ps->cur_bitmap_chunk, WRITE, 1, ps->bitmap);
+
+	ps->cur_bitmap_chunk = (chunk / bits_per_chunk) + FIRST_BITMAP_CHUNK;
+
+	chunk_io(ps, ps->cur_bitmap_chunk, READ, 1, ps->bitmap);
+
+	if (!test_and_clear_bit(idx, ps->bitmap))
+		DMERR("%s: try to a free block %lld %ld %ld", __func__,
+		      (unsigned long long)chunk, ps->cur_bitmap_chunk, idx);
+
+	chunk_io(ps, ps->cur_bitmap_chunk, WRITE, 1, ps->bitmap);
+
+	DMINFO("%s %d: free a chunk, %llu", __func__, __LINE__,
+	       (unsigned long long)chunk);
+
+	return 0;
+}
+
+static void init_leaf(struct pstore *ps, struct leaf *leaf)
+{
+	leaf->magic = 0x1eaf;
+	leaf->version = 0;
+	leaf->base_chunk = 0;
+	leaf->count = 0;
+	leaf->map[0].offset = ps->snap->chunk_size << SECTOR_SHIFT;
+}
+
+static struct chunk_buffer *new_btree_obj(struct pstore *ps)
+{
+	u64 chunk;
+	struct chunk_buffer *b;
+
+	b = alloc_chunk_buffer(ps);
+	if (!b)
+		return NULL;
+
+	chunk =	shared_allocate_chunk(ps);
+	if (!chunk) {
+		free_chunk_buffer(ps, b);
+		return NULL;
+	}
+
+	b->chunk = chunk;
+
+	return b;
+}
+
+static int shared_create_bitmap(struct exception_store *store)
+{
+	struct pstore *ps = get_info(store);
+	int i, r, rest, this;
+	chunk_t chunk;
+
+	/* bitmap + superblock */
+	rest = ps->nr_bitmap_chunks + 1;
+
+	for (chunk = 0; chunk < ps->nr_bitmap_chunks; chunk++) {
+		memset(ps->area, 0, ps->snap->chunk_size << SECTOR_SHIFT);
+
+		this = min_t(int, rest, ps->snap->chunk_size * 512 * 8);
+		if (this) {
+			rest -= this;
+
+			memset(ps->area, 0xff, this / 8);
+
+			for (i = 0; i < this % 8; i++)
+				set_bit(i, (unsigned long *)ps->area + this / 8);
+		}
+
+		r = chunk_io(ps, chunk + FIRST_BITMAP_CHUNK, WRITE, 1,
+			     ps->area);
+		if (r)
+			return r;
+	}
+
+	return 0;
+}
+
+static struct chunk_buffer *new_leaf(struct pstore *ps)
+{
+	struct chunk_buffer *cb;
+
+	cb = new_btree_obj(ps);
+	if (cb)
+		init_leaf(ps, cb->data);
+
+	return cb;
+}
+
+static struct chunk_buffer *new_node(struct pstore *ps)
+{
+	return new_btree_obj(ps);
+}
+
+static int shared_create_btree(struct pstore *ps)
+{
+	struct chunk_buffer *l, *n;
+	int r;
+
+	r = chunk_io(ps, ps->cur_bitmap_chunk, READ, FIRST_BITMAP_CHUNK,
+		     ps->bitmap);
+	if (r)
+		return r;
+
+	l = new_btree_obj(ps);
+	if (!l)
+		return -ENOMEM;
+	init_leaf(ps, l->data);
+
+	n = new_btree_obj(ps);
+	if (!n)
+		return -ENOMEM;
+
+	buffer2node(n)->count = 1;
+	buffer2node(n)->entries[0].chunk = l->chunk;
+
+	chunk_io(ps, l->chunk, WRITE, 1, l->data);
+	chunk_io(ps, n->chunk, WRITE, 1, n->data);
+
+	ps->root_tree_chunk = n->chunk;
+	ps->snapmask = 0;
+	ps->tree_level = 1;
+
+	return 0;
+}
+
+static int shared_create_header(struct exception_store *store)
+{
+	struct pstore *ps = get_info(store);
+	int r;
+
+	r = shared_create_bitmap(store);
+	if (r)
+		return r;
+
+	r = shared_create_btree(ps);
+	if (r)
+		return r;
+
+	ps->valid = 1;
+	r = write_header(ps);
+	if (r)
+		return r;
+
+	return r;
+}
+
+static int shared_read_header(struct pstore *ps, int *new_snapshot)
+{
+	struct disk_header *dh;
+	int r;
+
+	ps->io_client = dm_io_client_create(sectors_to_pages(ps->snap->
+							     chunk_size));
+	if (IS_ERR(ps->io_client))
+		return PTR_ERR(ps->io_client);
+
+	ps->bitmap = vmalloc(ps->snap->chunk_size << SECTOR_SHIFT);
+	if (!ps->bitmap)
+		return -ENOMEM;
+
+	r = alloc_area(ps);
+	if (r)
+		goto fail_alloc_area;
+
+
+	r = chunk_io(ps, 0, READ, 1, ps->area);
+	if (r)
+		goto fail_to_read_header;
+
+	dh = (struct disk_header *) ps->area;
+
+	if (le32_to_cpu(dh->magic) == 0) {
+		*new_snapshot = 1;
+		return 0;
+	}
+
+	if (le32_to_cpu(dh->magic) != SNAP_MAGIC) {
+		DMWARN("Invalid or corrupt snapshot");
+		r = -ENXIO;
+		goto fail_to_read_header;
+	}
+
+	*new_snapshot = 0;
+	ps->valid = le32_to_cpu(dh->valid);
+	ps->version = le32_to_cpu(dh->version);
+
+	ps->root_tree_chunk = cpu_to_le64(dh->root_tree_chunk);
+	ps->snapmask = cpu_to_le64(dh->snapmask);
+	ps->tree_level = cpu_to_le32(dh->tree_level);
+
+	if (ps->snap->chunk_size != le32_to_cpu(dh->chunk_size)) {
+		DMWARN("Invalid chunk size");
+		r = -ENXIO;
+		goto fail_to_read_header;
+	}
+
+	return 0;
+fail_to_read_header:
+	free_area(ps);
+fail_alloc_area:
+	vfree(ps->bitmap);
+	ps->bitmap = NULL;
+	return r;
+}
+
+static int shared_read_metadata(struct exception_store *store)
+{
+	int i, r, uninitialized_var(new_snapshot);
+	struct pstore *ps = get_info(store);
+	sector_t size = get_dev_size(store->snap->cow->bdev);
+	unsigned long bitmap_chunk_bytes;
+	unsigned chunk_bytes = ps->snap->chunk_size << SECTOR_SHIFT;
+
+	ps->cur_bitmap_chunk = 1;
+	ps->cur_bitmap_index = 0;
+	ps->nr_chunks = size >> ps->snap->chunk_shift;
+
+	ps->exceptions_per_area = (ps->snap->chunk_size << SECTOR_SHIFT) /
+		sizeof(struct disk_exception);
+	ps->callbacks = dm_vcalloc(ps->exceptions_per_area,
+				   sizeof(*ps->callbacks));
+	if (!ps->callbacks)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&ps->chunk_buffer_list);
+	INIT_LIST_HEAD(&ps->chunk_buffer_dirty_list);
+	ps->nr_chunk_buffers = 0;
+
+	bitmap_chunk_bytes = DIV_ROUND_UP(ps->nr_chunks, 8);
+	ps->nr_bitmap_chunks = DIV_ROUND_UP(bitmap_chunk_bytes, chunk_bytes);
+
+	r = shared_read_header(ps, &new_snapshot);
+	if (r)
+		return r;
+
+	if (new_snapshot)
+		DMINFO("%s %d: creates a new cow device", __func__, __LINE__);
+	else
+		DMINFO("%s %d: loads the cow device", __func__, __LINE__);
+
+	if (new_snapshot) {
+		r = shared_create_header(store);
+		if (r) {
+			DMWARN("write_header failed");
+			return r;
+		}
+	} else {
+		/*
+		 * Metadata are valid, but snapshot is invalidated
+		 */
+		if (!ps->valid)
+			return 1;
+
+		r = chunk_io(ps, ps->cur_bitmap_chunk, READ, 1,
+			     ps->bitmap);
+	}
+
+	for (i = 0; i < MAX_SNAPSHOTS; i++)
+		if (test_bit(i, (unsigned long *)&ps->snapmask))
+			ps->nr_snapshots++;
+
+	return r;
+}
+
+struct etree_path {
+	struct chunk_buffer *buffer;
+	struct index_entry *pnext;
+};
+
+static struct chunk_buffer *btbread(struct pstore *ps, u64 chunk)
+{
+	struct chunk_buffer *b;
+
+	list_for_each_entry(b, &ps->chunk_buffer_list, list) {
+		if (b->chunk == chunk)
+			return b;
+	}
+
+	b = alloc_chunk_buffer(ps);
+	if (!b)
+		return NULL;
+
+	b->chunk = chunk;
+
+	chunk_io(ps, chunk, READ, 1, b->data);
+
+	return b;
+}
+
+static void brelse(struct chunk_buffer *buffer)
+{
+}
+
+static void brelse_dirty(struct pstore *ps, struct chunk_buffer *b)
+{
+	if (list_empty(&b->dirty_list))
+		list_add(&b->dirty_list, &ps->chunk_buffer_dirty_list);
+}
+
+static void set_buffer_dirty(struct pstore *ps, struct chunk_buffer *b)
+{
+	if (list_empty(&b->dirty_list))
+		list_add(&b->dirty_list, &ps->chunk_buffer_dirty_list);
+}
+
+static inline struct exception *emap(struct leaf *leaf, unsigned i)
+{
+	return	(struct exception *)((char *) leaf + leaf->map[i].offset);
+}
+
+static int add_exception_to_leaf(struct leaf *leaf, u64 chunk, u64 exception,
+				 int snapshot, u64 active)
+{
+	unsigned target = chunk - leaf->base_chunk;
+	u64 mask = 1ULL << snapshot, sharemap;
+	struct exception *ins, *exceptions = emap(leaf, 0);
+	char *maptop = (char *)(&leaf->map[leaf->count + 1]);
+	unsigned i, j, free = (char *)exceptions - maptop;
+
+	/*
+	 * Find the chunk for which we're adding an exception entry.
+	 */
+	for (i = 0; i < leaf->count; i++) /* !!! binsearch goes here */
+		if (leaf->map[i].rchunk >= target)
+			break;
+
+	/*
+	 * If we didn't find the chunk, insert a new one at map[i].
+	 */
+	if (i == leaf->count || leaf->map[i].rchunk > target) {
+		if (free < sizeof(struct exception) + sizeof(struct tree_map))
+			return -1;
+		ins = emap(leaf, i);
+		memmove(&leaf->map[i+1], &leaf->map[i], maptop - (char *)&leaf->map[i]);
+		leaf->map[i].offset = (char *)ins - (char *)leaf;
+		leaf->map[i].rchunk = target;
+		leaf->count++;
+		sharemap = snapshot == -1 ? active : mask;
+		goto insert;
+	}
+
+	if (free < sizeof(struct exception))
+		return -1;
+	/*
+	 * Compute the share map from that of each existing exception entry
+	 * for this chunk.  If we're doing this for a chunk on the origin,
+	 * the new exception is shared between those snapshots that weren't
+	 * already sharing exceptions for this chunk.  (We combine the sharing
+	 * that already exists, invert it, then mask off everything but the
+	 * active snapshots.)
+	 *
+	 * If this is a chunk on a snapshot we go through the existing
+	 * exception list to turn off sharing with this snapshot (with the
+	 * side effect that if the chunk was only shared by this snapshot it
+	 * becomes unshared).  We then set sharing for this snapshot in the
+	 * new exception entry.
+	 */
+	if (snapshot == -1) {
+		for (sharemap = 0, ins = emap(leaf, i); ins < emap(leaf, i+1); ins++)
+			sharemap |= ins->share;
+		sharemap = (~sharemap) & active;
+	} else {
+		for (ins = emap(leaf, i); ins < emap(leaf, i+1); ins++)
+			if ((ins->share & mask)) {
+				ins->share &= ~mask;
+				break;
+			}
+		sharemap = mask;
+	}
+	ins = emap(leaf, i);
+insert:
+	/*
+	 * Insert the new exception entry.  These grow from the end of the
+	 * block toward the beginning.  First move any earlier exceptions up
+	 * to make room for the new one, then insert the new entry in the
+	 * space freed.  Adjust the offsets for all earlier chunks.
+	 */
+	memmove(exceptions - 1, exceptions, (char *)ins - (char *)exceptions);
+	ins--;
+	ins->share = sharemap;
+	ins->chunk = exception;
+
+	for (j = 0; j <= i; j++)
+		leaf->map[j].offset -= sizeof(struct exception);
+
+	return 0;
+}
+
+static void insert_child(struct node *node, struct index_entry *p, u64 child,
+			 u64 childkey)
+{
+	memmove(p + 1, p, (char *)(&node->entries[0] + node->count) - (char *)p);
+	p->chunk = child;
+	p->key = childkey;
+	node->count++;
+}
+
+static u64 split_leaf(struct leaf *leaf, struct leaf *leaf2)
+{
+	unsigned i, nhead = (leaf->count + 1) / 2, ntail = leaf->count - nhead, tailsize;
+	/* Should split at middle of data instead of median exception */
+	u64 splitpoint = leaf->map[nhead].rchunk + leaf->base_chunk;
+	char *phead, *ptail;
+
+	phead = (char *)emap(leaf, 0);
+	ptail = (char *)emap(leaf, nhead);
+	tailsize = (char *)emap(leaf, leaf->count) - ptail;
+
+	/* Copy upper half to new leaf */
+	memcpy(leaf2, leaf, offsetof(struct leaf, map));
+	memcpy(&leaf2->map[0], &leaf->map[nhead], (ntail + 1) * sizeof(struct tree_map));
+	memcpy(ptail - (char *)leaf + (char *)leaf2, ptail, tailsize);
+	leaf2->count = ntail;
+
+	/* Move lower half to top of block */
+	memmove(phead + tailsize, phead, ptail - phead);
+	leaf->count = nhead;
+	for (i = 0; i <= nhead; i++)
+		leaf->map[i].offset += tailsize;
+	leaf->map[nhead].rchunk = 0;
+
+	return splitpoint;
+}
+
+static int add_exception_to_tree(struct pstore *ps, struct chunk_buffer *leafbuf,
+				 u64 target, u64 exception, int snapbit,
+				 struct etree_path path[], unsigned levels)
+{
+	struct node *newroot;
+	struct chunk_buffer *newrootbuf, *childbuf;
+	struct leaf *leaf;
+	u64 childkey, childsector;
+	int ret;
+
+	ret = add_exception_to_leaf(buffer2leaf(leafbuf), target,
+				    exception, snapbit, ps->snapmask);
+	if (!ret) {
+		brelse_dirty(ps, leafbuf);
+		return 0;
+	}
+
+	/*
+	 * There wasn't room to add a new exception to the leaf.  Split it.
+	 */
+
+	childbuf = new_leaf(ps);
+	if (!childbuf)
+		return -ENOMEM; /* this is the right thing to do? */
+
+	set_buffer_dirty(ps, childbuf);
+
+	childkey = split_leaf(buffer2leaf(leafbuf), buffer2leaf(childbuf));
+	childsector = childbuf->chunk;
+
+	/*
+	 * Now add the exception to the appropriate leaf.  Childkey has the
+	 * first chunk in the new leaf we just created.
+	 */
+	if (target < childkey)
+		leaf = buffer2leaf(leafbuf);
+	else
+		leaf = buffer2leaf(childbuf);
+
+	ret = add_exception_to_leaf(leaf, target, exception, snapbit,
+				    ps->snapmask);
+	if (ret)
+		return -ENOMEM;
+
+	brelse_dirty(ps, leafbuf);
+	brelse_dirty(ps, childbuf);
+
+	while (levels--) {
+		unsigned half;
+		u64 newkey;
+		struct index_entry *pnext = path[levels].pnext;
+		struct chunk_buffer *parentbuf = path[levels].buffer;
+		struct node *parent = buffer2node(parentbuf);
+		struct chunk_buffer *newbuf;
+		struct node *newnode;
+		int csize = ps->snap->chunk_size << SECTOR_SHIFT;
+		int alloc_per_node = (csize - offsetof(struct node, entries))
+			/ sizeof(struct index_entry);
+
+		if (parent->count < alloc_per_node) {
+			insert_child(parent, pnext, childsector, childkey);
+			set_buffer_dirty(ps, parentbuf);
+			return 0;
+		}
+		/*
+		 * Split the node.
+		 */
+		half = parent->count / 2;
+		newkey = parent->entries[half].key;
+		newbuf = new_node(ps);
+		if (!newbuf)
+			return -ENOMEM;
+		set_buffer_dirty(ps, newbuf);
+		newnode = buffer2node(newbuf);
+
+		newnode->count = parent->count - half;
+		memcpy(&newnode->entries[0], &parent->entries[half],
+		       newnode->count * sizeof(struct index_entry));
+		parent->count = half;
+		/*
+		 * If the path entry is in the new node, use that as the
+		 * parent.
+		 */
+		if (pnext > &parent->entries[half]) {
+			pnext = pnext - &parent->entries[half] + newnode->entries;
+			set_buffer_dirty(ps, parentbuf);
+			parentbuf = newbuf;
+			parent = newnode;
+		} else
+			set_buffer_dirty(ps, newbuf);
+		/*
+		 * Insert the child now that we have room in the parent, then
+		 * climb the path and insert the new child there.
+		 */
+		insert_child(parent, pnext, childsector, childkey);
+		set_buffer_dirty(ps, parentbuf);
+		childkey = newkey;
+		childsector = newbuf->chunk;
+		brelse(newbuf);
+	}
+
+	newrootbuf = new_node(ps);
+	if (!newrootbuf)
+		return -ENOMEM;
+
+	newroot = buffer2node(newrootbuf);
+
+	newroot->count = 2;
+	newroot->entries[0].chunk = ps->root_tree_chunk;
+	newroot->entries[1].key = childkey;
+	newroot->entries[1].chunk = childsector;
+	ps->root_tree_chunk = newrootbuf->chunk;
+	ps->tree_level++;
+	ps->header_dirty = 1;
+	brelse_dirty(ps, newrootbuf);
+	return 0;
+}
+
+static struct chunk_buffer *probe(struct pstore *ps, u64 chunk,
+				  struct etree_path *path)
+{
+	unsigned i, levels = ps->tree_level;
+	struct node *node;
+	struct chunk_buffer *nodebuf = btbread(ps, ps->root_tree_chunk);
+
+	if (!nodebuf)
+		return NULL;
+	node = buffer2node(nodebuf);
+
+	for (i = 0; i < levels; i++) {
+		struct index_entry *pnext = node->entries, *top = pnext + node->count;
+
+		while (++pnext < top)
+			if (pnext->key > chunk)
+				break;
+
+		path[i].buffer = nodebuf;
+		path[i].pnext = pnext;
+		nodebuf = btbread(ps, (pnext - 1)->chunk);
+		if (!nodebuf)
+			return NULL;
+
+		node = (struct node *)nodebuf->data;
+	}
+	BUG_ON(((struct leaf *)nodebuf->data)->magic != 0x1eaf);
+	return nodebuf;
+}
+
+static inline struct node *path_node(struct etree_path path[], int level)
+{
+	return buffer2node(path[level].buffer);
+}
+
+/*
+ * Release each buffer in the given path array.
+ */
+static void brelse_path(struct etree_path *path, unsigned levels)
+{
+	unsigned i;
+	for (i = 0; i < levels; i++)
+		brelse(path[i].buffer);
+}
+
+/*
+ * Merge the contents of 'leaf2' into 'leaf.'  The leaves are contiguous and
+ * 'leaf2' follows 'leaf.'  Move the exception lists in 'leaf' up to make room
+ * for those of 'leaf2,' adjusting the offsets in the map entries, then copy
+ * the map entries and exception lists straight from 'leaf2.'
+ */
+static void merge_leaves(struct leaf *leaf, struct leaf *leaf2)
+{
+	unsigned nhead = leaf->count, ntail = leaf2->count, i;
+	unsigned tailsize = (char *)emap(leaf2, ntail) - (char *)emap(leaf2, 0);
+	char *phead = (char *)emap(leaf, 0), *ptail = (char *)emap(leaf, nhead);
+
+	/* move data down */
+	memmove(phead - tailsize, phead, ptail - phead);
+
+	/* adjust pointers */
+	for (i = 0; i <= nhead; i++) /* also adjust sentinel */
+		leaf->map[i].offset -= tailsize;
+
+	/* move data from leaf2 to top */
+	/* data */
+	memcpy(ptail - tailsize, (char *)emap(leaf2, 0), tailsize);
+	/* map */
+	memcpy(&leaf->map[nhead], &leaf2->map[0],
+	       (ntail + 1) * sizeof(struct tree_map));
+	leaf->count += ntail;
+}
+
+/*
+ * Remove the index entry at path[level].pnext-1 by moving entries below it up
+ * into its place.  If it wasn't the last entry in the node but it _was_ the
+ * first entry (and we're not at the root), preserve the key by inserting it
+ * into the index entry of the parent node that refers to this node.
+ */
+static void remove_index(struct pstore *ps, struct etree_path path[], int level)
+{
+	struct node *node = path_node(path, level);
+	/* !!! out of bounds for delete of last from full index */
+	chunk_t pivot = (path[level].pnext)->key;
+	int count = node->count, i;
+
+	/* stomps the node count (if 0th key holds count) */
+	memmove(path[level].pnext - 1, path[level].pnext,
+		(char *)&node->entries[count] - (char *)path[level].pnext);
+	node->count = count - 1;
+	--(path[level].pnext);
+	set_buffer_dirty(ps, path[level].buffer);
+
+	/* no pivot for last entry */
+	if (path[level].pnext == node->entries + node->count)
+		return;
+
+	/*
+	 * climb up to common parent and set pivot to deleted key
+	 * what if index is now empty? (no deleted key)
+	 * then some key above is going to be deleted and used to set pivot
+	 */
+	if (path[level].pnext == node->entries && level) {
+		/* Keep going up the path if we're at the first index entry. */
+		for (i = level - 1; path[i].pnext - 1 == path_node(path, i)->entries; i--)
+			if (!i)		/* If we hit the root, we're done.    */
+				return;
+		/*
+		 * Found a node where we're not at the first entry.
+		 * Set the key here to that of the deleted index
+		 * entry.
+		 */
+		(path[i].pnext - 1)->key = pivot;
+		set_buffer_dirty(ps, path[i].buffer);
+	}
+}
+
+/*
+ * Returns the number of bytes of free space in the given leaf by computing
+ * the difference between the end of the map entry list and the beginning
+ * of the first set of exceptions.
+ */
+static unsigned leaf_freespace(struct leaf *leaf)
+{
+	/* include sentinel */
+	char *maptop = (char *)(&leaf->map[leaf->count + 1]);
+	return (char *)emap(leaf, 0) - maptop;
+}
+
+/*
+ * Returns the number of bytes used in the given leaf by computing the number
+ * of bytes used by the map entry list and all sets of exceptions.
+ */
+static unsigned leaf_payload(struct leaf *leaf)
+{
+	int lower = (char *)(&leaf->map[leaf->count]) - (char *)leaf->map;
+	int upper = (char *)emap(leaf, leaf->count) - (char *)emap(leaf, 0);
+	return lower + upper;
+}
+
+static void check_leaf(struct leaf *leaf, u64 snapmask)
+{
+	struct exception *p;
+	int i;
+
+	for (i = 0; i < leaf->count; i++) {
+		for (p = emap(leaf, i); p < emap(leaf, i+1); p++) {
+			/* !!! should also check for any zero sharemaps here */
+			if (p->share & snapmask)
+				DMERR("nonzero bits %016Lx outside snapmask %016Lx",
+				      (unsigned long long)p->share,
+				      (unsigned long long)snapmask);
+		}
+	}
+}
+
+/*
+ * Remove all exceptions belonging to a given snapshot from the passed leaf.
+ *
+ * This clears the "share" bits on each chunk for the snapshot mask passed
+ * in the delete_info structure.  In the process, it compresses out any
+ * exception entries that are entirely unshared and/or unused.  In a second
+ * pass, it compresses out any map entries for which there are no exception
+ * entries remaining.
+ */
+static int delete_snapshots_from_leaf(struct pstore *ps, struct leaf *leaf,
+				      u64 snapmask)
+{
+	/* p points just past the last map[] entry in the leaf. */
+	struct exception *p = emap(leaf, leaf->count), *dest = p;
+	struct tree_map *pmap, *dmap;
+	unsigned i;
+	int ret = 0;
+
+	/* Scan top to bottom clearing snapshot bit and moving
+	 * non-zero entries to top of block */
+	/*
+	 * p points at each original exception; dest points at the location
+	 * to receive an exception that is being moved down in the leaf.
+	 * Exceptions that are unshared after clearing the share bit for
+	 * the passed snapshot mask are skipped and the associated "exception"
+	 * chunk is freed.  This operates on the exceptions for one map entry
+	 * at a time; when the beginning of a list of exceptions is reached,
+	 * the associated map entry offset is adjusted.
+	 */
+	for (i = leaf->count; i--;) {
+		/*
+		 * False the first time through, since i is leaf->count and p
+		 * was set to emap(leaf, leaf->count) above.
+		 */
+		while (p != emap(leaf, i)) {
+			u64 share = (--p)->share;
+			ret |= share & snapmask;
+					/* Unshare with given snapshot(s).    */
+			p->share &= ~snapmask;
+			if (p->share)	/* If still used, keep chunk.         */
+				*--dest = *p;
+			else
+				shared_free_chunk(ps, p->chunk);
+/* 			dirty_buffer_count_check(sb); */
+		}
+		leaf->map[i].offset = (char *)dest - (char *)leaf;
+	}
+	/* Remove empties from map */
+	/*
+	 * This runs through the map entries themselves, skipping entries
+	 * with matching offsets.  If all the exceptions for a given map
+	 * entry are skipped, its offset will be set to that of the following
+	 * map entry (since the dest pointer will not have moved).
+	 */
+	dmap = pmap = &leaf->map[0];
+	for (i = 0; i < leaf->count; i++, pmap++)
+		if (pmap->offset != (pmap + 1)->offset)
+			*dmap++ = *pmap;
+	/*
+	 * There is always a phantom map entry after the last, that has the
+	 * offset of the end of the leaf and, of course, no chunk number.
+	 */
+	dmap->offset = pmap->offset;
+	dmap->rchunk = 0; /* tidy up */
+	leaf->count = dmap - &leaf->map[0];
+	check_leaf(leaf, snapmask);
+
+	return ret;
+}
+
+/*
+ * Return true if path[level].pnext points at the end of the list of index
+ * entries.
+ */
+static inline int finished_level(struct etree_path path[], int level)
+{
+	struct node *node = path_node(path, level);
+	return path[level].pnext == node->entries + node->count;
+}
+
+/*
+ * Copy the index entries in 'node2' into 'node.'
+ */
+static void merge_nodes(struct node *node, struct node *node2)
+{
+	memcpy(&node->entries[node->count], &node2->entries[0], node2->count * sizeof(struct index_entry));
+	node->count += node2->count;
+}
+
+static void brelse_free(struct pstore *ps, struct chunk_buffer *buffer)
+{
+	shared_free_chunk(ps, buffer->chunk);
+	free_chunk_buffer(ps, buffer);
+}
+
+/*
+ * Delete all chunks in the B-tree for the snapshot(s) indicated by the
+ * passed snapshot mask, beginning at the passed chunk.
+ *
+ * Walk the tree (a stack-based inorder traversal) starting with the passed
+ * chunk, calling delete_snapshots_from_leaf() on each leaf to remove chunks
+ * associated with the snapshot(s) we're removing.  As leaves and nodes become
+ * sparsely filled, merge them with their neighbors.  When we reach the root
+ * we've finished the traversal; if there are empty levels (that is, level(s)
+ * directly below the root that only contain a single node), remove those
+ * empty levels until either the second level is no longer empty or we only
+ * have one level remaining.
+ */
+static int delete_tree_range(struct pstore *ps, u64 snapmask, chunk_t resume)
+{
+	int levels = ps->tree_level, level = levels - 1;
+	struct etree_path path[levels], hold[levels];
+	struct chunk_buffer *leafbuf, *prevleaf = NULL;
+	unsigned i;
+
+	/* can be initializer if not dynamic array (change it?) */
+	for (i = 0; i < levels; i++)
+		hold[i] = (struct etree_path){ };
+	/*
+	 * Find the B-tree leaf with the chunk we were passed.  Often
+	 * this will be chunk 0.
+	 */
+	leafbuf = probe(ps, resume, path);
+	if (!leafbuf)
+		return -ENOMEM;
+
+	while (1) { /* in-order leaf walk */
+		if (delete_snapshots_from_leaf(ps, buffer2leaf(leafbuf), snapmask))
+			set_buffer_dirty(ps, leafbuf);
+		/*
+		 * If we have a previous leaf (i.e. we're past the first),
+		 * try to merge the current leaf with it.
+		 */
+		if (prevleaf) { /* try to merge this leaf with prev */
+			struct leaf *this = buffer2leaf(leafbuf);
+			struct leaf *prev = buffer2leaf(prevleaf);
+
+			/*
+			 * If there's room in the previous leaf for this leaf,
+			 * merge this leaf into the previous leaf and remove
+			 * the index entry that points to this leaf.
+			 */
+			if (leaf_payload(this) <= leaf_freespace(prev)) {
+				merge_leaves(prev, this);
+				remove_index(ps, path, level);
+				set_buffer_dirty(ps, prevleaf);
+				brelse_free(ps, leafbuf);
+				/* dirty_buffer_count_check(sb); */
+				goto keep_prev_leaf;
+			}
+			brelse(prevleaf);
+		}
+		prevleaf = leafbuf;	/* Save leaf for next time through.   */
+keep_prev_leaf:
+		/*
+		 * If we've reached the end of the index entries in the B-tree
+		 * node at the current level, try to merge the node referred
+		 * to at this level of the path with a prior node.  Repeat
+		 * this process at successively higher levels up the path; if
+		 * we reach the root, clean up and exit.  If we don't reach
+		 * the root, we've reached a node with multiple entries;
+		 * rebuild the path from the next index entry to the next
+		 * leaf.
+		 */
+		if (finished_level(path, level)) {
+			do { /* pop and try to merge finished nodes */
+				/*
+				 * If we have a previous node at this level
+				 * (again, we're past the first node), try to
+				 * merge the current node with it.
+				 */
+				if (hold[level].buffer) {
+					struct node *this = path_node(path, level);
+					struct node *prev = path_node(hold, level);
+					int csize = ps->snap->chunk_size << SECTOR_SHIFT;
+					int alloc_per_node =
+						(csize - offsetof(struct node, entries))
+						/ sizeof(struct index_entry);
+
+					/*
+					 * If there's room in the previous node
+					 * for the entries in this node, merge
+					 * this node into the previous node and
+					 * remove the index entry that points
+					 * to this node.
+					 */
+					if (this->count <= alloc_per_node - prev->count) {
+						merge_nodes(prev, this);
+						remove_index(ps, path, level - 1);
+						set_buffer_dirty(ps, hold[level].buffer);
+						brelse_free(ps, path[level].buffer);
+/* 						dirty_buffer_count_check(sb); */
+						goto keep_prev_node;
+					}
+					brelse(hold[level].buffer);
+				}
+				/* Save the node for the next time through.   */
+				hold[level].buffer = path[level].buffer;
+keep_prev_node:
+				/*
+				 * If we're at the root, we need to clean up
+				 * and return.  First, though, try to reduce
+				 * the number of levels.  If the tree at the
+				 * root has been reduced to only the nodes in
+				 * our path, eliminate nodes with only one
+				 * entry until we either have a new root node
+				 * with multiple entries or we have only one
+				 * level remaining in the B-tree.
+				 */
+				if (!level) { /* remove levels if possible */
+					/*
+					 * While above the first level and the
+					 * root only has one entry, point the
+					 * root at the (only) first-level node,
+					 * reduce the number of levels and
+					 * shift the path up one level.
+					 */
+					while (levels > 1 && path_node(hold, 0)->count == 1) {
+						/* Point root at the first level. */
+						ps->root_tree_chunk = hold[1].buffer->chunk;
+						brelse_free(ps, hold[0].buffer);
+/* 						dirty_buffer_count_check(sb); */
+						levels = --ps->tree_level;
+						memcpy(hold, hold + 1, levels * sizeof(hold[0]));
+						ps->header_dirty = 1;
+					}
+					brelse(prevleaf);
+					brelse_path(hold, levels);
+
+/* 					if (dirty_buffer_count) */
+/* 						commit_transaction(sb, 0); */
+					ps->snapmask &= ~snapmask;
+					ps->header_dirty = 1;
+					return 0;
+				}
+
+				level--;
+			} while (finished_level(path, level));
+			/*
+			 * Now rebuild the path from where we are (one entry
+			 * past the last leaf we processed, which may have
+			 * been adjusted in operations above) down to the node
+			 * above the next leaf.
+			 */
+			do { /* push back down to leaf level */
+				struct chunk_buffer *nodebuf = btbread(ps, path[level++].pnext++->chunk);
+				if (!nodebuf) {
+					brelse_path(path, level - 1); /* anything else needs to be freed? */
+					return -ENOMEM;
+				}
+				path[level].buffer = nodebuf;
+				path[level].pnext = buffer2node(nodebuf)->entries;
+			} while (level < levels - 1);
+		}
+
+/* 		dirty_buffer_count_check(sb); */
+		/*
+		 * Get the leaf indicated in the next index entry in the node
+		 * at this level.
+		 */
+		leafbuf = btbread(ps, path[level].pnext++->chunk);
+		if (!leafbuf) {
+			brelse_path(path, level);
+			return -ENOMEM;
+		}
+	}
+}
+
+static int origin_chunk_unique(struct leaf *leaf, u64 chunk, u64 snapmask)
+{
+	u64 using = 0;
+	u64 i, target = chunk - leaf->base_chunk;
+	struct exception const *p;
+
+	for (i = 0; i < leaf->count; i++)
+		if (leaf->map[i].rchunk == target)
+			goto found;
+	return !snapmask;
+found:
+	for (p = emap(leaf, i); p < emap(leaf, i+1); p++)
+		using |= p->share;
+
+	return !(~using & snapmask);
+}
+
+static int snapshot_chunk_unique(struct leaf *leaf, u64 chunk, int snapbit,
+				 chunk_t *exception)
+{
+	u64 mask = 1LL << snapbit;
+	unsigned i, target = chunk - leaf->base_chunk;
+	struct exception const *p;
+
+	for (i = 0; i < leaf->count; i++)
+		if (leaf->map[i].rchunk == target)
+			goto found;
+	return 0;
+found:
+	for (p = emap(leaf, i); p < emap(leaf, i+1); p++)
+		/* shared if more than one bit set including this one */
+		if ((p->share & mask)) {
+			*exception = p->chunk;
+			return !(p->share & ~mask);
+		}
+	return 0;
+}
+
+static int shared_prepare(struct exception_store *store,
+			  struct dm_snap_exception *e, u64 snapid)
+{
+	struct pstore *ps = get_info(store);
+	struct chunk_buffer *cb;
+	struct etree_path path[ps->tree_level + 1];
+	chunk_t new_chunk, chunk = e->old_chunk;
+	int ret;
+
+	cb = probe(ps, chunk, path);
+	if (!cb)
+		return 1;
+
+	if (snapid == ORIGIN_SNAPID)
+		ret = origin_chunk_unique(buffer2leaf(cb), chunk, ps->snapmask);
+	else
+		ret = snapshot_chunk_unique(buffer2leaf(cb), chunk, snapid,
+					    &new_chunk);
+	if (ret) {
+		DMINFO("%s %d: bug %llu %llu %d", __func__, __LINE__,
+		       (unsigned long long)snapid, (unsigned long long)chunk, ret);
+		return 1;
+	}
+
+	new_chunk = shared_allocate_chunk(ps);
+	if (!new_chunk)
+		return 1;
+
+	ret = add_exception_to_tree(ps, cb, chunk, new_chunk, -1, path,
+				    ps->tree_level);
+	if (ret)
+		return 1;
+
+	DMINFO("%s %d: allocated new chunk, %llu", __func__, __LINE__,
+	       (unsigned long long)new_chunk);
+
+	e->new_chunk = new_chunk;
+	atomic_inc(&ps->pending_count);
+
+	return 0;
+}
+
+#define MAX_CHUNK_BUFFERS 128
+
+static void shared_commit(struct exception_store *store,
+			  struct dm_snap_exception *e,
+			  void (*callback) (void *, int success),
+			  void *callback_context)
+{
+	int i, r = 0;
+	struct pstore *ps = get_info(store);
+	struct commit_callback *cb;
+
+	cb = ps->callbacks + ps->callback_count++;
+	cb->callback = callback;
+	cb->context = callback_context;
+
+	if (atomic_dec_and_test(&ps->pending_count) ||
+	    (ps->callback_count == ps->exceptions_per_area)) {
+		struct chunk_buffer *b, *n;
+
+		down_write(&ps->snap->lock);
+
+		list_for_each_entry_safe(b, n, &ps->chunk_buffer_dirty_list,
+					 dirty_list) {
+
+			list_del_init(&b->dirty_list);
+			list_move_tail(&b->list, &ps->chunk_buffer_list);
+
+			/* todo: can be async */
+			chunk_io(ps, b->chunk, WRITE, 1, b->data);
+		}
+
+		if (ps->header_dirty)
+			write_header(ps);
+
+		list_for_each_entry_safe(b, n, &ps->chunk_buffer_list, list) {
+			if (ps->nr_chunk_buffers < MAX_CHUNK_BUFFERS)
+				break;
+
+			free_chunk_buffer(ps, b);
+		}
+
+		up_write(&ps->snap->lock);
+
+		for (i = 0; i < ps->callback_count; i++) {
+			cb = ps->callbacks + i;
+			cb->callback(cb->context, r == 0 ? 1 : 0);
+		}
+
+		ps->callback_count = 0;
+	}
+}
+
+static struct dm_snap_exception dummy_exception;
+
+static struct dm_snap_exception *shared_lookup_exception(struct exception_store *store,
+							 chunk_t chunk, u64 snapid)
+{
+	struct pstore *ps = get_info(store);
+	unsigned levels = ps->tree_level;
+	struct etree_path path[levels + 1];
+	struct chunk_buffer *leafbuf;
+	int r;
+	chunk_t new_chunk = ~0;
+
+	leafbuf = probe(ps, (u64)chunk, path);
+	if (!leafbuf)	/* should make the snapshot invalid */
+		return NULL;
+
+	if (snapid == ORIGIN_SNAPID)
+		r = origin_chunk_unique(buffer2leaf(leafbuf), chunk, ps->snapmask);
+	else
+		r = snapshot_chunk_unique(buffer2leaf(leafbuf), chunk, snapid, &new_chunk);
+
+	if (r) {
+		dummy_exception.old_chunk = chunk;
+		dummy_exception.new_chunk = new_chunk;
+		return &dummy_exception;
+	}
+
+	return NULL;
+}
+
+#define MSG_STR(x) x, sizeof(x)
+
+static int shared_message(struct exception_store *store, unsigned argc,
+			  char **argv)
+{
+	struct pstore *ps = get_info(store);
+	struct dm_snapshot *snap = ps->snap;
+	unsigned idx;
+	int r = -EINVAL;
+
+	if (argc != 3)
+		return r;
+
+	if (strnicmp(argv[0], MSG_STR("snapshot")))
+		return r;
+
+	if (!strnicmp(argv[1], MSG_STR("create"))) {
+		idx = simple_strtoul(argv[2], NULL, 0);
+
+		down_write(&snap->lock);
+		if (test_and_set_bit(idx, (unsigned long *)&ps->snapmask))
+			DMINFO("%s %d: %dth snapshot exists.",
+			       __func__, __LINE__, idx);
+		else {
+			r = 0;
+			ps->nr_snapshots++;
+
+			write_header(ps);
+			DMINFO("%s %d: create %uth snapshot.",
+			       __func__, __LINE__, idx);
+		}
+		up_write(&snap->lock);
+
+	} else if (!strnicmp(argv[1], MSG_STR("delete"))) {
+		u64 mask;
+
+		idx = simple_strtoul(argv[2], NULL, 0);
+
+		down_write(&snap->lock);
+		if (test_and_clear_bit(idx, (unsigned long *)&ps->snapmask)) {
+			DMINFO("%s %d: delete %uth snapshot.",
+			       __func__, __LINE__, idx);
+
+			mask = 1ULL << idx;
+
+			r = delete_tree_range(ps, mask, 0);
+			if (!r)
+				ps->nr_snapshots--;
+
+			write_header(ps);
+		} else
+			DMINFO("%s %d: %dth snapshot doesn't exists.",
+			       __func__, __LINE__, idx);
+
+		up_write(&snap->lock);
+	} else
+		DMERR("%s %d: %s is an unknown option.",
+		      __func__, __LINE__, argv[1]);
+
+	return r;
+}
+
+static u32 shared_get_snapshot_info(struct exception_store *store,
+				    unsigned long *map, size_t size)
+{
+	struct pstore *ps = get_info(store);
+
+	memcpy(map, &ps->snapmask, min(size, sizeof(ps->snapmask)));
+
+	return ps->nr_snapshots;
+}
+
+int dm_create_shared(struct exception_store *store)
+{
+	struct pstore *ps;
+
+	/* allocate the pstore */
+	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
+	if (!ps)
+		return -ENOMEM;
+
+	ps->snap = store->snap;
+	ps->valid = 1;
+	ps->area = NULL;
+	ps->next_free = 2;	/* skipping the header and first area */
+	ps->current_committed = 0;
+
+	ps->callback_count = 0;
+	atomic_set(&ps->pending_count, 0);
+	ps->callbacks = NULL;
+
+	ps->metadata_wq = create_singlethread_workqueue("ksnaphd");
+	if (!ps->metadata_wq) {
+		kfree(ps);
+		DMERR("couldn't start header metadata update thread");
+		return -ENOMEM;
+	}
+
+	store->destroy = shared_destroy;
+	store->read_metadata = shared_read_metadata;
+	store->prepare_exception = shared_prepare;
+	store->commit_exception = shared_commit;
+	store->drop_snapshot = shared_drop;
+	store->lookup_completed_exception = shared_lookup_exception;
+	store->get_snapshot_info = shared_get_snapshot_info;
+	store->fraction_full = NULL;
+	store->message = shared_message;
+	store->context = ps;
+
+	return 0;
+}
diff --git a/drivers/md/dm-snap.h b/drivers/md/dm-snap.h
index c7529bf..d053756 100644
--- a/drivers/md/dm-snap.h
+++ b/drivers/md/dm-snap.h
@@ -83,6 +83,7 @@ static inline void dm_consecutive_chunk_count_inc(struct dm_snap_exception *e)
 
 #  endif
 
+#define MAX_SNAPSHOTS 64
 #define ORIGIN_SNAPID ULLONG_MAX
 
 /*
@@ -219,6 +220,8 @@ int dm_create_persistent(struct exception_store *store);
 
 int dm_create_transient(struct exception_store *store);
 
+int dm_create_shared(struct exception_store *store);
+
 /*
  * Return the number of sectors in the device.
  */
-- 
1.5.5.GIT
