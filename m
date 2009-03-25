From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 1] DM Exception Store:  shared type
Date: Wed, 25 Mar 2009 16:45:46 -0500
Message-ID: <200903252145.n2PLjkCO025167@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Patch name: dm-exception-store-shared-type.patch

This patch introduces the "shared" exception store.  The generalized
exception store API is a requirement for this patch.

The shared exception store allows snapshots to share a COW device.  This
greatly improves space and speed efficiency.  Preliminary tests show a
'n'-way improvement, where 'n' is the number of snapshots.

Using the shared exception store is exactly like using snapshots as you have
in the past.  The only thing that changes is the device-mapper constructor
table.  Example:

depricated-way> ctr_str="0 4194304 snapshot <origin> <cow> P 8"
depricated-way> echo $ctr_str | dmsetup create snapshot

non-shared-way> ctr_str="0 4194304 snapshot <origin> persistent 2 <cow> 8"
non-shared-way> echo $ctr_str | dmsetup create snapshot

# Last argument in ctr_str is the shared exception store ID (0-63)
shared-way> ctr_str="0 4194304 snapshot <origin> shared 3 <cow> 8 1"
shared-way> echo $ctr_str | dmsetup create snapshot


Things to do:
- shared_prepare_exception returns '1' instead of useful error values
- unify scheme of variable declaration (i.e. use u64, uint64_t, or __le64...
  but don't use them all - it just makes things ugly)
- Writing to snapshots causes bugs (only read-only snapshots work right now).
- Improve status output to show available shared slots

Index: linux-2.6/drivers/md/dm-ex-store-shared.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/md/dm-ex-store-shared.c
@@ -0,0 +1,2011 @@
+/*
+ * dm-exception-store.c
+ *
+ * Copyright (C) 2001-2002 Sistina Software (UK) Limited.
+ * Copyright (C) 2006 Red Hat GmbH
+ * Copyright (C) 2009 Red Hat
+ *
+ * The shared exception code is based on Zumastor (http://zumastor.org/)
+ *
+ * By: Daniel Phillips, Nov 2003 to Mar 2007
+ * (c) 2003 Sistina Software Inc.
+ * (c) 2004 Red Hat Software Inc.
+ * (c) 2005 Daniel Phillips
+ * (c) 2006 - 2007, Google Inc
+ * (c) 2009 Red Hat Software Inc.
+ *
+ * This file is released under the GPL.
+ */
+#include <linux/device-mapper.h>
+#include <linux/dm-io.h>
+#include "dm-exception-store.h"
+#include "dm-exception.h"
+
+#define DM_MSG_PREFIX "shared exception store"
+
+#define SHARED_EXCEPTION_MAGIC 0x55378008
+#define SHARED_EXCEPTION_DISK_VERSION 1
+#define FIRST_BITMAP_CHUNK 1
+
+#define MAX_SNAPSHOTS 64
+#define ORIGIN_SNAPID ULLONG_MAX
+
+#define DM_CHUNK_SIZE_DEFAULT_SECTORS 32	/* 16KB */
+#define MAX_CHUNK_BUFFERS 128
+
+struct disk_header {
+	uint32_t magic;
+	uint32_t valid;
+	uint32_t version;
+
+	/* In sectors */
+	uint32_t chunk_size;
+
+	__le64 root_tree_chunk;
+	__le64 snapmask;
+	__le32 tree_level;
+	__le32 h_nr_journal_chunks;
+};
+
+struct disk_exception {
+	uint64_t old_chunk;
+	uint64_t new_chunk;
+};
+
+struct commit_callback {
+	void (*callback)(void *, int success);
+	void *context;
+};
+
+/*
+ * The top level structure for a shared exception store.
+ */
+struct shared_store {
+	struct list_head list;
+
+	int version;
+	int valid;
+	uint32_t exceptions_per_area;
+
+	uint32_t ref_count;
+	atomic_t resume_counter;
+
+	/*
+	 * How do we know if stores are shared?  By their
+	 * COW devices - it becomes the 'key' that we go by.
+	 */
+	dev_t key;
+	struct rw_semaphore lock;
+
+	/*
+	 * Now that we have an asynchronous kcopyd there is no
+	 * need for large chunk sizes, so it wont hurt to have a
+	 * whole chunks worth of metadata in memory at once.
+	 */
+	void *area;
+
+	/*
+	 * An area of zeros used to clear the next area.
+	 */
+	void *zero_area;
+
+	/*
+	 * Used to keep track of which metadata area the data in
+	 * 'chunk' refers to.
+	 */
+	chunk_t current_area;
+
+	/*
+	 * The next free chunk for an exception.
+	 */
+	chunk_t next_free;
+
+	/*
+	 * The index of next free exception in the current
+	 * metadata area.
+	 */
+	uint32_t current_committed;
+
+	atomic_t pending_count;
+	uint32_t callback_count;
+	struct commit_callback *callbacks;
+	struct dm_io_client *io_client;
+
+	struct workqueue_struct *metadata_wq;
+
+	/*
+	 * for shared exception
+	 */
+	u64 root_tree_chunk;
+	u64 snapmask;
+	u64 snapmask_live;
+	u32 tree_level;
+
+	u32 nr_snapshots;
+
+	unsigned long nr_chunks;
+	unsigned long nr_bitmap_chunks;
+	unsigned long nr_journal_chunks;
+	unsigned long *bitmap;
+	unsigned long cur_bitmap_chunk;
+	unsigned long cur_bitmap_index;
+	unsigned long cur_journal_chunk;
+
+	struct list_head chunk_buffer_list;
+	struct list_head chunk_buffer_dirty_list;
+
+	int header_dirty;
+	int nr_chunk_buffers;
+};
+
+/*
+ * defines the unique portions of a shared_store, like the snapid.
+ */
+struct unique_store {
+	struct dm_exception_store *store;
+	struct shared_store *ss;
+
+	uint64_t id;
+};
+
+static struct list_head shared_store_list;
+static DECLARE_MUTEX(shared_store_list_lock);
+
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
+#define GET_UNIQUE(__store) ((struct unique_store *)(__store))
+static struct unique_store *get_unique_info(struct dm_exception_store *store)
+{
+	return (struct unique_store *)store->context;
+}
+
+#define GET_SHARED(__store) (GET_UNIQUE(__store)->ss)
+static struct shared_store *get_shared_info(struct dm_exception_store *store)
+{
+	struct unique_store *us = store->context;
+
+	return us->ss;
+}
+
+static unsigned sectors_to_pages(unsigned sectors)
+{
+	return DIV_ROUND_UP(sectors, PAGE_SIZE >> 9);
+}
+
+static int alloc_area(struct dm_exception_store *store)
+{
+	int r = -ENOMEM;
+	size_t len;
+	struct shared_store *ss = get_shared_info(store);
+
+	len = store->chunk_size << SECTOR_SHIFT;
+
+	/*
+	 * Allocate the chunk_size block of memory that will hold
+	 * a single metadata area.
+	 */
+	ss->area = vmalloc(len);
+	if (!ss->area)
+		return r;
+
+	ss->zero_area = vmalloc(len);
+	if (!ss->zero_area) {
+		vfree(ss->area);
+		return r;
+	}
+	memset(ss->zero_area, 0, len);
+
+	return 0;
+}
+
+static void free_area(struct dm_exception_store *store)
+{
+	struct shared_store *ss = get_shared_info(store);
+
+	if (ss->area)
+		vfree(ss->area);
+	ss->area = NULL;
+
+	if (ss->zero_area)
+		vfree(ss->zero_area);
+	ss->zero_area = NULL;
+}
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
+static struct chunk_buffer *alloc_chunk_buffer(struct dm_exception_store *store)
+{
+	struct chunk_buffer *b;
+	struct shared_store *ss = get_shared_info(store);
+
+	b = kzalloc(sizeof(*b), GFP_NOFS);
+	if (!b) {
+		DMERR("%s %d: out of memory", __func__, __LINE__);
+		return NULL;
+	}
+
+	b->data = vmalloc(store->chunk_size << SECTOR_SHIFT);
+	if (!b->data) {
+		DMERR("%s %d: out of memory", __func__, __LINE__);
+		kfree(b);
+		return NULL;
+	}
+
+	memset(b->data, 0, store->chunk_size << SECTOR_SHIFT);
+
+	list_add(&b->list, &ss->chunk_buffer_list);
+	INIT_LIST_HEAD(&b->dirty_list);
+
+	ss->nr_chunk_buffers++;
+
+	return b;
+}
+
+static void free_chunk_buffer(struct dm_exception_store *store,
+			      struct chunk_buffer *b)
+{
+	struct shared_store *ss = get_shared_info(store);
+
+	list_del(&b->list);
+	vfree(b->data);
+	kfree(b);
+
+	ss->nr_chunk_buffers--;
+}
+
+static struct shared_store *__shared_store_lookup(dev_t key)
+{
+	struct shared_store *ss;
+
+	list_for_each_entry(ss, &shared_store_list, list)
+		if (ss->key == key)
+			return ss;
+	return NULL;
+}
+
+/*
+ * __shared_store_alloc
+ * @key
+ *
+ * Allocate a new 'struct shared_store' and add it to the
+ * global list.
+ *
+ * Returns: ss on success, NULL on failure
+ */
+static struct shared_store *__shared_store_alloc(dev_t key)
+{
+	struct shared_store *ss, *old_ss;
+
+	/* allocate the shared store */
+	ss = kzalloc(sizeof(*ss), GFP_KERNEL);
+	if (!ss)
+		return NULL;
+
+	INIT_LIST_HEAD(&ss->list);
+	ss->version = SHARED_EXCEPTION_DISK_VERSION;
+	ss->valid = 1;
+	ss->key = key;
+
+	ss->area = NULL;
+	ss->next_free = 2;	/* skipping the header and first area */
+	ss->current_committed = 0;
+	init_rwsem(&ss->lock);
+
+	INIT_LIST_HEAD(&ss->chunk_buffer_list);
+	INIT_LIST_HEAD(&ss->chunk_buffer_dirty_list);
+
+	ss->callback_count = 0;
+	atomic_set(&ss->pending_count, 0);
+	ss->callbacks = NULL;
+
+	ss->metadata_wq = create_singlethread_workqueue("ksnaphd");
+	if (!ss->metadata_wq) {
+		kfree(ss);
+		DMERR("couldn't start header metadata update thread");
+		return NULL;
+	}
+
+	down(&shared_store_list_lock);
+	old_ss = __shared_store_lookup(key);
+	if (old_ss) {
+		/* We lost the race */
+		destroy_workqueue(ss->metadata_wq);
+		kfree(ss);
+		ss = old_ss;
+	} else
+		list_add(&ss->list, &shared_store_list);
+	up(&shared_store_list_lock);
+
+	return ss;
+}
+
+/*
+ * __shared_store_find
+ * @key
+ *
+ * Find the 'struct shared_store' associated with 'key'
+ * or allocate a new one if it does not exist.
+ *
+ * Returns: (struct shared_store *) on success, NULL on failure
+ */
+static struct shared_store *__shared_store_find(dev_t key)
+{
+	struct shared_store *ss;
+
+	ss = __shared_store_lookup(key);
+	if (!ss) {
+		up(&shared_store_list_lock);
+		ss = __shared_store_alloc(key);
+		down(&shared_store_list_lock);
+	}
+
+	return ss;
+}
+
+/*
+ * get_shared_store
+ * @key
+ *
+ * Find a 'struct shared_store' in the global list, and
+ * increment the reference count.
+ *
+ * Returns: ss on success, NULL on error
+ */
+static struct shared_store *get_shared_store(dev_t key)
+{
+	struct shared_store *ss;
+
+	down(&shared_store_list_lock);
+	ss = __shared_store_find(key);
+	if (ss)
+		ss->ref_count++;
+
+	up(&shared_store_list_lock);
+
+	return ss;
+}
+
+/*
+ * put_shared_store
+ * @ss
+ *
+ * Free a 'struct shared_store' and remove from the global list.
+ * Remember to flush the workqueue before calling this function.
+ */
+static void put_shared_store(struct dm_exception_store *store)
+{
+	struct shared_store *ss = get_shared_info(store);
+	struct chunk_buffer *bb, *n;
+
+	down(&shared_store_list_lock);
+	ss->ref_count--;
+	if (!ss->ref_count) {
+		/*
+		 * Some of these fields don't get allocated until
+		 * shared_resume is called.  So, check b4
+		 * freeing
+		 */
+		list_for_each_entry_safe(bb, n, &ss->chunk_buffer_list, list)
+			free_chunk_buffer(store, bb);
+
+		destroy_workqueue(ss->metadata_wq);
+		if (ss->io_client)
+			dm_io_client_destroy(ss->io_client);
+
+		if (ss->bitmap)
+			vfree(ss->bitmap);
+
+		if (ss->callbacks)
+			vfree(ss->callbacks);
+
+		free_area(store);
+
+		list_del(&ss->list);
+		kfree(ss);
+	}
+	up(&shared_store_list_lock);
+}
+
+struct mdata_req {
+	struct dm_io_region *where;
+	struct dm_io_request *io_req;
+	struct work_struct work;
+	int result;
+};
+
+static void do_metadata(struct work_struct *work)
+{
+	struct mdata_req *req = container_of(work, struct mdata_req, work);
+
+	req->result = dm_io(req->io_req, 1, req->where, NULL);
+}
+
+/*
+ * Read or write a chunk aligned and sized block of data from a device.
+ */
+static int chunk_io(struct dm_exception_store *store, chunk_t chunk,
+		    int rw, int metadata, void *data)
+{
+	struct shared_store *ss = get_shared_info(store);
+	struct dm_io_region where = {
+		.bdev = store->cow->bdev,
+		.sector = store->chunk_size * chunk,
+		.count = store->chunk_size,
+	};
+	struct dm_io_request io_req = {
+		.bi_rw = rw,
+		.mem.type = DM_IO_VMA,
+		.mem.ptr.vma = data,
+		.client = ss->io_client,
+		.notify.fn = NULL,
+	};
+	struct mdata_req req;
+
+	if (!metadata)
+		return dm_io(&io_req, 1, &where, NULL);
+
+	req.where = &where;
+	req.io_req = &io_req;
+
+	/*
+	 * Issue the synchronous I/O from a different thread
+	 * to avoid generic_make_request recursion.
+	 */
+	INIT_WORK(&req.work, do_metadata);
+	queue_work(ss->metadata_wq, &req.work);
+	flush_workqueue(ss->metadata_wq);
+
+	return req.result;
+}
+
+static int write_header(struct dm_exception_store *store)
+{
+	struct shared_store *ss = get_shared_info(store);
+	struct disk_header *dh;
+
+	memset(ss->area, 0, store->chunk_size << SECTOR_SHIFT);
+
+	dh = (struct disk_header *) ss->area;
+	dh->magic = cpu_to_le32(SHARED_EXCEPTION_MAGIC);
+	dh->valid = cpu_to_le32(ss->valid);
+	dh->version = cpu_to_le32(ss->version);
+	dh->chunk_size = cpu_to_le32(store->chunk_size);
+
+	dh->root_tree_chunk = cpu_to_le64(ss->root_tree_chunk);
+	dh->snapmask = cpu_to_le64(ss->snapmask);
+	dh->tree_level = cpu_to_le32(ss->tree_level);
+	dh->h_nr_journal_chunks = cpu_to_le32(ss->nr_journal_chunks);
+
+	ss->header_dirty = 0;
+
+	return chunk_io(store, 0, WRITE, 1, ss->area);
+}
+
+static int read_new_bitmap_chunk(struct dm_exception_store *store)
+{
+	struct shared_store *ss = get_shared_info(store);
+
+	chunk_io(store, ss->cur_bitmap_chunk, WRITE, 1, ss->bitmap);
+
+	ss->cur_bitmap_chunk++;
+	if (ss->cur_bitmap_chunk == ss->nr_bitmap_chunks)
+		ss->cur_bitmap_chunk = FIRST_BITMAP_CHUNK;
+
+	chunk_io(store, ss->cur_bitmap_chunk, READ, 1,  ss->bitmap);
+
+	return 0;
+}
+
+static unsigned long shared_allocate_chunk(struct dm_exception_store *store)
+{
+	unsigned long idx;
+	unsigned long limit;
+	unsigned long start_chunk;
+	unsigned long nr = (store->chunk_size << SECTOR_SHIFT) * 8;
+	struct shared_store *ss = get_shared_info(store);
+
+	start_chunk = ss->cur_bitmap_chunk;
+again:
+	if (ss->cur_bitmap_chunk == ss->nr_bitmap_chunks && ss->nr_chunks % nr)
+		limit = ss->nr_chunks % nr;
+	else
+		limit = nr;
+
+	idx = ext2_find_next_zero_bit(ss->bitmap, limit, ss->cur_bitmap_index);
+	if (idx < limit) {
+		ext2_set_bit(idx, ss->bitmap);
+
+		if (idx == limit - 1) {
+			ss->cur_bitmap_index = 0;
+
+			read_new_bitmap_chunk(store);
+		} else
+			ss->cur_bitmap_index++;
+	} else {
+		chunk_io(store, ss->cur_bitmap_chunk, WRITE, 1, ss->bitmap);
+
+		read_new_bitmap_chunk(store);
+
+		/* todo: check # free chunks */
+		if (start_chunk == ss->cur_bitmap_chunk) {
+			DMERR("%s %d: fail to find a new chunk",
+			      __func__, __LINE__);
+			return 0;
+		}
+
+		goto again;
+	}
+
+	return idx + (ss->cur_bitmap_chunk - FIRST_BITMAP_CHUNK) * nr;
+}
+
+static int shared_free_chunk(struct dm_exception_store *store, chunk_t chunk)
+{
+	struct shared_store *ss = get_shared_info(store);
+	unsigned long bits_per_chunk
+		= (store->chunk_size << SECTOR_SHIFT) * 8;
+	unsigned long idx = chunk % bits_per_chunk;
+
+	/* we don't always need to do this... */
+	chunk_io(store, ss->cur_bitmap_chunk, WRITE, 1, ss->bitmap);
+
+	ss->cur_bitmap_chunk = (chunk / bits_per_chunk) + FIRST_BITMAP_CHUNK;
+
+	chunk_io(store, ss->cur_bitmap_chunk, READ, 1, ss->bitmap);
+
+	if (!ext2_test_bit(idx, ss->bitmap))
+		DMERR("%s: try to a free block %lld %ld %ld", __func__,
+		      (unsigned long long)chunk, ss->cur_bitmap_chunk, idx);
+
+	ext2_clear_bit(idx, ss->bitmap);
+
+	chunk_io(store, ss->cur_bitmap_chunk, WRITE, 1, ss->bitmap);
+
+	DMINFO("%s %d: free a chunk, %llu", __func__, __LINE__,
+	       (unsigned long long)chunk);
+
+	return 0;
+}
+
+static void init_leaf(struct dm_exception_store *store, struct leaf *leaf)
+{
+	leaf->magic = cpu_to_le16(0x1eaf);
+	leaf->version = 0;
+	leaf->base_chunk = 0;
+	leaf->count = 0;
+	leaf->map[0].offset = cpu_to_le32(store->chunk_size << SECTOR_SHIFT);
+}
+
+static struct chunk_buffer *new_btree_obj(struct dm_exception_store *store)
+{
+	u64 chunk;
+	struct chunk_buffer *b;
+
+	b = alloc_chunk_buffer(store);
+	if (!b)
+		return NULL;
+
+	chunk =	shared_allocate_chunk(store);
+	if (!chunk) {
+		free_chunk_buffer(store, b);
+		return NULL;
+	}
+
+	b->chunk = chunk;
+
+	return b;
+}
+
+static int shared_create_bitmap(struct dm_exception_store *store)
+{
+	struct shared_store *ss = get_shared_info(store);
+	int i, r, rest, this;
+	chunk_t chunk;
+
+	/* bitmap + superblock */
+	rest = 1 + ss->nr_bitmap_chunks + ss->nr_journal_chunks;
+
+	for (chunk = 0; chunk < ss->nr_bitmap_chunks; chunk++) {
+		memset(ss->area, 0, store->chunk_size << SECTOR_SHIFT);
+
+		this = min_t(int, rest,
+			     (store->chunk_size << SECTOR_SHIFT) * 8);
+		if (this) {
+			rest -= this;
+
+			memset(ss->area, 0xff, this / 8);
+
+			for (i = 0; i < this % 8; i++) {
+				char *p = ss->area + (this / 8);
+				ext2_set_bit(i, (unsigned long *)p);
+			}
+		}
+
+		r = chunk_io(store, chunk + FIRST_BITMAP_CHUNK, WRITE, 1,
+			     ss->area);
+		if (r)
+			return r;
+	}
+
+	return 0;
+}
+
+static struct chunk_buffer *new_leaf(struct dm_exception_store *store)
+{
+	struct chunk_buffer *cb;
+
+	cb = new_btree_obj(store);
+	if (cb)
+		init_leaf(store, cb->data);
+
+	return cb;
+}
+
+static struct chunk_buffer *new_node(struct dm_exception_store *store)
+{
+	return new_btree_obj(store);
+}
+
+static int shared_create_btree(struct dm_exception_store *store)
+{
+	int r;
+	struct chunk_buffer *l, *n;
+	struct shared_store *ss = get_shared_info(store);
+
+	r = chunk_io(store, ss->cur_bitmap_chunk, READ,
+		     FIRST_BITMAP_CHUNK, ss->bitmap);
+	if (r)
+		return r;
+
+	l = new_leaf(store);
+	if (!l)
+		return -ENOMEM;
+
+	n = new_btree_obj(store);
+	if (!n)
+		return -ENOMEM;
+
+	buffer2node(n)->count = cpu_to_le32(1);
+	buffer2node(n)->entries[0].chunk = cpu_to_le64(l->chunk);
+
+	chunk_io(store, l->chunk, WRITE, 1, l->data);
+	chunk_io(store, n->chunk, WRITE, 1, n->data);
+
+	ss->root_tree_chunk = n->chunk;
+	ss->snapmask = 0;
+	ss->tree_level = 1;
+
+	return 0;
+}
+
+static int shared_create_header(struct dm_exception_store *store)
+{
+	int r;
+	struct shared_store *ss = get_shared_info(store);
+
+	/* 128MB by default, should be configurable. */
+	ss->nr_journal_chunks = (128 * 1024 * 1024) /
+		(store->chunk_size << SECTOR_SHIFT);
+
+	r = shared_create_bitmap(store);
+	if (r)
+		return r;
+
+	r = shared_create_btree(store);
+	if (r)
+		return r;
+
+	ss->valid = 1;
+	r = write_header(store);
+	if (r)
+		return r;
+
+	return r;
+}
+
+static int shared_read_header(struct dm_exception_store *store,
+			      int *new_snapshot)
+{
+	struct unique_store *us = get_unique_info(store);
+	struct shared_store *ss = us->ss;
+	struct disk_header *dh;
+	int r;
+
+	ss->io_client = dm_io_client_create(sectors_to_pages(store->chunk_size));
+	if (IS_ERR(ss->io_client))
+		return PTR_ERR(ss->io_client);
+
+	ss->bitmap = vmalloc(store->chunk_size << SECTOR_SHIFT);
+	if (!ss->bitmap)
+		return -ENOMEM;
+
+	r = alloc_area(store);
+	if (r)
+		goto fail_alloc_area;
+
+
+	r = chunk_io(store, 0, READ, 1, ss->area);
+	if (r)
+		goto fail_to_read_header;
+
+	dh = (struct disk_header *) ss->area;
+
+	if (le32_to_cpu(dh->magic) == 0) {
+		*new_snapshot = 1;
+		return 0;
+	}
+
+	if (le32_to_cpu(dh->magic) != SHARED_EXCEPTION_MAGIC) {
+		DMWARN("Invalid or corrupt snapshot");
+		r = -ENXIO;
+		goto fail_to_read_header;
+	}
+
+	*new_snapshot = 0;
+	ss->valid = le32_to_cpu(dh->valid);
+	ss->version = le32_to_cpu(dh->version);
+
+	ss->root_tree_chunk = le64_to_cpu(dh->root_tree_chunk);
+	ss->snapmask = le64_to_cpu(dh->snapmask);
+	ss->tree_level = le32_to_cpu(dh->tree_level);
+	ss->nr_journal_chunks = le32_to_cpu(dh->h_nr_journal_chunks);
+
+	if (store->chunk_size != le32_to_cpu(dh->chunk_size)) {
+		DMWARN("Invalid chunk size");
+		r = -ENXIO;
+		goto fail_to_read_header;
+	}
+
+	return 0;
+fail_to_read_header:
+	free_area(store);
+fail_alloc_area:
+	vfree(ss->bitmap);
+	ss->bitmap = NULL;
+	return r;
+}
+
+struct etree_path {
+	struct chunk_buffer *buffer;
+	struct index_entry *pnext;
+};
+
+static struct chunk_buffer *btbread(struct dm_exception_store *store, u64 chunk)
+{
+	struct shared_store *ss = get_shared_info(store);
+	struct chunk_buffer *b;
+
+	list_for_each_entry(b, &ss->chunk_buffer_list, list) {
+		if (b->chunk == chunk)
+			return b;
+	}
+
+	b = alloc_chunk_buffer(store);
+	if (!b)
+		return NULL;
+
+	b->chunk = chunk;
+
+	chunk_io(store, chunk, READ, 1, b->data);
+
+	return b;
+}
+
+static void brelse(struct chunk_buffer *buffer)
+{
+}
+
+static void brelse_dirty(struct shared_store *ss, struct chunk_buffer *b)
+{
+	if (list_empty(&b->dirty_list))
+		list_add(&b->dirty_list, &ss->chunk_buffer_dirty_list);
+}
+
+static void set_buffer_dirty(struct shared_store *ss, struct chunk_buffer *b)
+{
+	if (list_empty(&b->dirty_list))
+		list_add(&b->dirty_list, &ss->chunk_buffer_dirty_list);
+}
+
+static inline struct exception *emap(struct leaf *leaf, unsigned i)
+{
+	return	(struct exception *)
+		((char *)leaf + le32_to_cpu(leaf->map[i].offset));
+}
+
+static int add_exception_to_leaf(struct leaf *leaf, u64 chunk, u64 exception,
+				 int id, u64 active)
+{
+	unsigned target = chunk - le64_to_cpu(leaf->base_chunk);
+	u64 mask = 1ULL << id, sharemap;
+	struct exception *ins, *exceptions = emap(leaf, 0);
+	char *maptop = (char *)(&leaf->map[le32_to_cpu(leaf->count) + 1]);
+	unsigned i, j, free = (char *)exceptions - maptop;
+
+	/*
+	 * Find the chunk for which we're adding an exception entry.
+	 */
+	for (i = 0; i < le32_to_cpu(leaf->count); i++) /* !!! binsearch goes here */
+		if (le32_to_cpu(leaf->map[i].rchunk) >= target)
+			break;
+
+	/*
+	 * If we didn't find the chunk, insert a new one at map[i].
+	 */
+	if (i == le32_to_cpu(leaf->count) ||
+	    le32_to_cpu(leaf->map[i].rchunk) > target) {
+		if (free < sizeof(struct exception) + sizeof(struct tree_map))
+			return -1;
+		ins = emap(leaf, i);
+		memmove(&leaf->map[i+1], &leaf->map[i], maptop - (char *)&leaf->map[i]);
+		leaf->map[i].offset = cpu_to_le32((char *)ins - (char *)leaf);
+		leaf->map[i].rchunk = cpu_to_le32(target);
+		leaf->count = cpu_to_le32(le32_to_cpu(leaf->count) + 1);
+		sharemap = id == -1 ? active : mask;
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
+	if (id == -1) {
+		for (sharemap = 0, ins = emap(leaf, i); ins < emap(leaf, i+1); ins++)
+			sharemap |= le64_to_cpu(ins->share);
+		sharemap = (~sharemap) & active;
+	} else {
+		for (ins = emap(leaf, i); ins < emap(leaf, i+1); ins++) {
+			u64 val = le64_to_cpu(ins->share);
+			if (val & mask) {
+				ins->share = cpu_to_le64(val & ~mask);
+				break;
+			}
+		}
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
+	ins->share = cpu_to_le64(sharemap);
+	ins->chunk = cpu_to_le64(exception);
+
+	for (j = 0; j <= i; j++) {
+		u32 val = le32_to_cpu(leaf->map[j].offset);
+		leaf->map[j].offset = cpu_to_le32(val - sizeof(struct exception));
+	}
+
+	return 0;
+}
+
+static void insert_child(struct node *node, struct index_entry *p, u64 child,
+			 u64 childkey)
+{
+	size_t count = (char *)(&node->entries[0] + le32_to_cpu(node->count)) -
+		(char *)p;
+	memmove(p + 1, p, count);
+	p->chunk = cpu_to_le64(child);
+	p->key = cpu_to_le64(childkey);
+	node->count = cpu_to_le32(le32_to_cpu(node->count) + 1);
+}
+
+static u64 split_leaf(struct leaf *leaf, struct leaf *leaf2)
+{
+	unsigned i, nhead, ntail, tailsize;
+	u64 splitpoint;
+	char *phead, *ptail;
+
+	nhead = (le32_to_cpu(leaf->count) + 1) / 2;
+	ntail = le32_to_cpu(leaf->count) - nhead;
+
+	/* Should split at middle of data instead of median exception */
+	splitpoint = le32_to_cpu(leaf->map[nhead].rchunk) +
+		le64_to_cpu(leaf->base_chunk);
+
+	phead = (char *)emap(leaf, 0);
+	ptail = (char *)emap(leaf, nhead);
+	tailsize = (char *)emap(leaf, le32_to_cpu(leaf->count)) - ptail;
+
+	/* Copy upper half to new leaf */
+	memcpy(leaf2, leaf, offsetof(struct leaf, map));
+	memcpy(&leaf2->map[0], &leaf->map[nhead], (ntail + 1) * sizeof(struct tree_map));
+	memcpy(ptail - (char *)leaf + (char *)leaf2, ptail, tailsize);
+	leaf2->count = cpu_to_le32(ntail);
+
+	/* Move lower half to top of block */
+	memmove(phead + tailsize, phead, ptail - phead);
+	leaf->count = cpu_to_le32(nhead);
+	for (i = 0; i <= nhead; i++)
+		leaf->map[i].offset =
+			cpu_to_le32(le32_to_cpu(leaf->map[i].offset) + tailsize);
+	leaf->map[nhead].rchunk = 0;
+
+	return splitpoint;
+}
+
+static int add_exception_to_tree(struct dm_exception_store *store,
+				 struct chunk_buffer *leafbuf,
+				 u64 target, u64 exception, int snapbit,
+				 struct etree_path path[], unsigned levels)
+{
+	struct shared_store *ss = get_shared_info(store);
+	struct node *newroot;
+	struct chunk_buffer *newrootbuf, *childbuf;
+	struct leaf *leaf;
+	u64 childkey, childsector;
+	int ret;
+
+	ret = add_exception_to_leaf(buffer2leaf(leafbuf), target,
+				    exception, snapbit, ss->snapmask);
+	if (!ret) {
+		brelse_dirty(ss, leafbuf);
+		return 0;
+	}
+
+	/*
+	 * There wasn't room to add a new exception to the leaf.  Split it.
+	 */
+	childbuf = new_leaf(store);
+	if (!childbuf)
+		return -ENOMEM; /* this is the right thing to do? */
+
+	set_buffer_dirty(ss, childbuf);
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
+				    ss->snapmask);
+	if (ret)
+		return -ENOMEM;
+
+	brelse_dirty(ss, leafbuf);
+	brelse_dirty(ss, childbuf);
+
+	while (levels--) {
+		unsigned half;
+		u64 newkey;
+		struct index_entry *pnext = path[levels].pnext;
+		struct chunk_buffer *parentbuf = path[levels].buffer;
+		struct node *parent = buffer2node(parentbuf);
+		struct chunk_buffer *newbuf;
+		struct node *newnode;
+		int csize = store->chunk_size << SECTOR_SHIFT;
+		int alloc_per_node = (csize - offsetof(struct node, entries))
+			/ sizeof(struct index_entry);
+
+		if (le32_to_cpu(parent->count) < alloc_per_node) {
+			insert_child(parent, pnext, childsector, childkey);
+			set_buffer_dirty(ss, parentbuf);
+			return 0;
+		}
+		/*
+		 * Split the node.
+		 */
+		half = le32_to_cpu(parent->count) / 2;
+		newkey = le64_to_cpu(parent->entries[half].key);
+		newbuf = new_node(store);
+		if (!newbuf)
+			return -ENOMEM;
+		set_buffer_dirty(ss, newbuf);
+		newnode = buffer2node(newbuf);
+
+		newnode->count = cpu_to_le32(le32_to_cpu(parent->count) - half);
+		memcpy(&newnode->entries[0], &parent->entries[half],
+		       le32_to_cpu(newnode->count) * sizeof(struct index_entry));
+		parent->count = cpu_to_le32(half);
+		/*
+		 * If the path entry is in the new node, use that as the
+		 * parent.
+		 */
+		if (pnext > &parent->entries[half]) {
+			pnext = pnext - &parent->entries[half] + newnode->entries;
+			set_buffer_dirty(ss, parentbuf);
+			parentbuf = newbuf;
+			parent = newnode;
+		} else
+			set_buffer_dirty(ss, newbuf);
+		/*
+		 * Insert the child now that we have room in the parent, then
+		 * climb the path and insert the new child there.
+		 */
+		insert_child(parent, pnext, childsector, childkey);
+		set_buffer_dirty(ss, parentbuf);
+		childkey = newkey;
+		childsector = newbuf->chunk;
+		brelse(newbuf);
+	}
+
+	newrootbuf = new_node(store);
+	if (!newrootbuf)
+		return -ENOMEM;
+
+	newroot = buffer2node(newrootbuf);
+
+	newroot->count = cpu_to_le32(2);
+	newroot->entries[0].chunk = cpu_to_le64(ss->root_tree_chunk);
+	newroot->entries[1].key = cpu_to_le64(childkey);
+	newroot->entries[1].chunk = cpu_to_le64(childsector);
+	ss->root_tree_chunk = newrootbuf->chunk;
+	ss->tree_level++;
+	ss->header_dirty = 1;
+	brelse_dirty(ss, newrootbuf);
+	return 0;
+}
+
+static struct chunk_buffer *probe(struct dm_exception_store *store, u64 chunk,
+				  struct etree_path *path)
+{
+	struct shared_store *ss = get_shared_info(store);
+	unsigned i, levels = ss->tree_level;
+	struct node *node;
+	struct chunk_buffer *nodebuf = btbread(store, ss->root_tree_chunk);
+
+	if (!nodebuf)
+		return NULL;
+	node = buffer2node(nodebuf);
+
+	for (i = 0; i < levels; i++) {
+		struct index_entry *pnext = node->entries,
+			*top = pnext + le32_to_cpu(node->count);
+
+		while (++pnext < top)
+			if (le64_to_cpu(pnext->key) > chunk)
+				break;
+
+		path[i].buffer = nodebuf;
+		path[i].pnext = pnext;
+		nodebuf = btbread(store, le64_to_cpu((pnext - 1)->chunk));
+		if (!nodebuf)
+			return NULL;
+
+		node = (struct node *)nodebuf->data;
+	}
+	if (le16_to_cpu(((struct leaf *)nodebuf->data)->magic) != 0x1eaf) {
+		DMERR("Bad magic number for leaf");
+		BUG();
+	}
+
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
+	unsigned nhead, ntail, i;
+	unsigned tailsize;
+	char *phead, *ptail;
+
+	nhead = le32_to_cpu(leaf->count);
+	ntail = le32_to_cpu(leaf2->count);
+	tailsize = (char *)emap(leaf2, ntail) - (char *)emap(leaf2, 0);
+	phead = (char *)emap(leaf, 0);
+	ptail = (char *)emap(leaf, nhead);
+
+	/* move data down */
+	memmove(phead - tailsize, phead, ptail - phead);
+
+	/* adjust pointers */
+	for (i = 0; i <= nhead; i++) {
+		u32 val = le32_to_cpu(leaf->map[i].offset);
+		/* also adjust sentinel */
+		leaf->map[i].offset = cpu_to_le32(val - tailsize);
+	}
+
+	/* move data from leaf2 to top */
+	/* data */
+	memcpy(ptail - tailsize, (char *)emap(leaf2, 0), tailsize);
+	/* map */
+	memcpy(&leaf->map[nhead], &leaf2->map[0],
+	       (ntail + 1) * sizeof(struct tree_map));
+	leaf->count = cpu_to_le32(le32_to_cpu(leaf->count) + ntail);
+}
+
+/*
+ * Remove the index entry at path[level].pnext-1 by moving entries below it up
+ * into its place.  If it wasn't the last entry in the node but it _was_ the
+ * first entry (and we're not at the root), preserve the key by inserting it
+ * into the index entry of the parent node that refers to this node.
+ */
+static void remove_index(struct shared_store *ss, struct etree_path path[], int level)
+{
+	struct node *node = path_node(path, level);
+	/* !!! out of bounds for delete of last from full index */
+	chunk_t pivot = le64_to_cpu((path[level].pnext)->key);
+	int i, count = le32_to_cpu(node->count);
+
+	/* stomps the node count (if 0th key holds count) */
+	memmove(path[level].pnext - 1, path[level].pnext,
+		(char *)&node->entries[count] - (char *)path[level].pnext);
+	node->count = cpu_to_le32(count - 1);
+	--(path[level].pnext);
+	set_buffer_dirty(ss, path[level].buffer);
+
+	/* no pivot for last entry */
+	if (path[level].pnext == node->entries + le32_to_cpu(node->count))
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
+		(path[i].pnext - 1)->key = cpu_to_le64(pivot);
+		set_buffer_dirty(ss, path[i].buffer);
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
+	char *maptop = (char *)(&leaf->map[le32_to_cpu(leaf->count) + 1]);
+	return (char *)emap(leaf, 0) - maptop;
+}
+
+/*
+ * Returns the number of bytes used in the given leaf by computing the number
+ * of bytes used by the map entry list and all sets of exceptions.
+ */
+static unsigned leaf_payload(struct leaf *leaf)
+{
+	int count = le32_to_cpu(leaf->count);
+	int lower = (char *)(&leaf->map[count]) - (char *)leaf->map;
+	int upper = (char *)emap(leaf, count) - (char *)emap(leaf, 0);
+	return lower + upper;
+}
+
+static void check_leaf(struct leaf *leaf, u64 snapmask)
+{
+	struct exception *p;
+	int i;
+
+	for (i = 0; i < le32_to_cpu(leaf->count); i++) {
+		for (p = emap(leaf, i); p < emap(leaf, i+1); p++) {
+			/* !!! should also check for any zero sharemaps here */
+			if (le64_to_cpu(p->share) & snapmask)
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
+static int delete_snapshots_from_leaf(struct dm_exception_store *store,
+				      struct leaf *leaf, u64 snapmask)
+{
+	/* p points just past the last map[] entry in the leaf. */
+	struct exception *p = emap(leaf, le32_to_cpu(leaf->count)), *dest = p;
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
+	for (i = le32_to_cpu(leaf->count); i--;) {
+		/*
+		 * False the first time through, since i is leaf->count and p
+		 * was set to emap(leaf, leaf->count) above.
+		 */
+		while (p != emap(leaf, i)) {
+			u64 share = le64_to_cpu((--p)->share);
+			ret |= share & snapmask;
+			/* Unshare with given snapshot(s). */
+			p->share = cpu_to_le64(le64_to_cpu(p->share) & ~snapmask);
+			if (le64_to_cpu(p->share)) /* If still used, keep chunk. */
+				*--dest = *p;
+			else
+				shared_free_chunk(store, le64_to_cpu(p->chunk));
+			/* dirty_buffer_count_check(sb); */
+		}
+		leaf->map[i].offset = cpu_to_le32((char *)dest - (char *)leaf);
+	}
+	/* Remove empties from map */
+	/*
+	 * This runs through the map entries themselves, skipping entries
+	 * with matching offsets.  If all the exceptions for a given map
+	 * entry are skipped, its offset will be set to that of the following
+	 * map entry (since the dest pointer will not have moved).
+	 */
+	dmap = pmap = &leaf->map[0];
+	for (i = 0; i < le32_to_cpu(leaf->count); i++, pmap++)
+		if (le32_to_cpu(pmap->offset) != le32_to_cpu((pmap + 1)->offset))
+			*dmap++ = *pmap;
+	/*
+	 * There is always a phantom map entry after the last, that has the
+	 * offset of the end of the leaf and, of course, no chunk number.
+	 */
+	dmap->offset = pmap->offset;
+	dmap->rchunk = 0; /* tidy up */
+	leaf->count = cpu_to_le32(dmap - &leaf->map[0]);
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
+	return path[level].pnext == node->entries + le32_to_cpu(node->count);
+}
+
+/*
+ * Copy the index entries in 'node2' into 'node.'
+ */
+static void merge_nodes(struct node *node, struct node *node2)
+{
+	memcpy(&node->entries[le32_to_cpu(node->count)],
+	       &node2->entries[0],
+	       le32_to_cpu(node2->count) * sizeof(struct index_entry));
+	node->count = cpu_to_le32(le32_to_cpu(node->count) + le32_to_cpu(node2->count));
+}
+
+static void brelse_free(struct dm_exception_store *store, struct chunk_buffer *buffer)
+{
+	shared_free_chunk(store, buffer->chunk);
+	free_chunk_buffer(store, buffer);
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
+static int delete_tree_range(struct dm_exception_store *store,
+			     u64 snapmask, chunk_t resume)
+{
+	struct shared_store *ss = GET_SHARED(store);
+	int levels = ss->tree_level;
+	int level = levels - 1;
+	struct etree_path path[levels];
+	struct etree_path hold[levels];
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
+	leafbuf = probe(store, resume, path);
+	if (!leafbuf)
+		return -ENOMEM;
+
+	while (1) { /* in-order leaf walk */
+		if (delete_snapshots_from_leaf(store, buffer2leaf(leafbuf), snapmask))
+			set_buffer_dirty(ss, leafbuf);
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
+				remove_index(ss, path, level);
+				set_buffer_dirty(ss, prevleaf);
+				brelse_free(store, leafbuf);
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
+					int csize = store->chunk_size << SECTOR_SHIFT;
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
+					if (le32_to_cpu(this->count) <=
+					    alloc_per_node - le32_to_cpu(prev->count)) {
+						merge_nodes(prev, this);
+						remove_index(ss, path, level - 1);
+						set_buffer_dirty(ss, hold[level].buffer);
+						brelse_free(store, path[level].buffer);
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
+					while (levels > 1 &&
+					       le32_to_cpu(path_node(hold, 0)->count) == 1) {
+						/* Point root at the first level. */
+						ss->root_tree_chunk = hold[1].buffer->chunk;
+						brelse_free(store, hold[0].buffer);
+/* 						dirty_buffer_count_check(sb); */
+						levels = --ss->tree_level;
+						memcpy(hold, hold + 1, levels * sizeof(hold[0]));
+						ss->header_dirty = 1;
+					}
+					brelse(prevleaf);
+					brelse_path(hold, levels);
+
+/* 					if (dirty_buffer_count) */
+/* 						commit_transaction(sb, 0); */
+					ss->snapmask &= ~snapmask;
+					ss->header_dirty = 1;
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
+				struct chunk_buffer *nodebuf;
+
+				nodebuf = btbread(store,
+						  le64_to_cpu(path[level++].pnext++->chunk));
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
+		leafbuf = btbread(store, le64_to_cpu(path[level].pnext++->chunk));
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
+	u64 i, target = chunk - le64_to_cpu(leaf->base_chunk);
+	struct exception const *p;
+
+	for (i = 0; i < le32_to_cpu(leaf->count); i++)
+		if (le32_to_cpu(leaf->map[i].rchunk) == target)
+			goto found;
+	return !snapmask;
+found:
+	for (p = emap(leaf, i); p < emap(leaf, i+1); p++)
+		using |= le64_to_cpu(p->share);
+
+	return !(~using & snapmask);
+}
+
+static int snapshot_chunk_unique(struct leaf *leaf, u64 chunk, int snapbit,
+				 chunk_t *exception)
+{
+	u64 mask = 1LL << snapbit;
+	unsigned i, target = chunk - le64_to_cpu(leaf->base_chunk);
+	struct exception const *p;
+
+	for (i = 0; i < le32_to_cpu(leaf->count); i++)
+		if (le32_to_cpu(leaf->map[i].rchunk) == target)
+			goto found;
+	return 0;
+found:
+	for (p = emap(leaf, i); p < emap(leaf, i+1); p++)
+		/* shared if more than one bit set including this one */
+		if ((le64_to_cpu(p->share) & mask)) {
+			*exception = le64_to_cpu(p->chunk);
+			return !(le64_to_cpu(p->share) & ~mask);
+		}
+	return 0;
+}
+
+/*
+ * Exception store API functions follow
+ */
+
+/*
+ * shared_ctr
+ * @store
+ * @argc
+ * @argv
+ *
+ * Returns: 0 on success, -Exxx on error
+ */
+static int shared_ctr(struct dm_exception_store *store,
+		      unsigned argc, char **argv)
+{
+	uint32_t idx;
+	struct unique_store *us;
+
+	if (argc != 1)
+		return -EINVAL;
+
+	/*
+	 * FIXME: Allow use of UUID and later translate to an
+	 * index.  It should be possible to keep the conversion
+	 * table in the on-disk header.  This would be much
+	 * more flexible.  It also eliminates the need to always
+	 * be querying for an open slot/id.
+	 */
+	if (sscanf(argv[0], "%u", &idx) != 1)
+		return -EINVAL;
+
+	us = kzalloc(sizeof(*us), GFP_KERNEL);
+	if (!us)
+		return -ENOMEM;
+
+	us->store = store;
+	us->id = idx;
+	us->ss = get_shared_store(store->cow->bdev->bd_dev);
+	if (!us->ss) {
+		kfree(us);
+		return -ENOMEM;
+	}
+
+	/*
+	 * The memory address of the shared store makes a great
+	 * unique ID.
+	 */
+	store->shared_uuid = (uint64_t)us->ss;
+
+	store->context = us;
+
+	return 0;
+}
+
+static void shared_dtr(struct dm_exception_store *store)
+{
+	struct unique_store *us = get_unique_info(store);
+
+	put_shared_store(store);
+	kfree(us);
+}
+
+/*
+ * initial_shared_resume
+ * @store
+ *
+ * Initialize the common shared structure (i.e. perform the initial
+ * metadata read).
+ *
+ * Returns: 0 on success, -Exxx on error
+ */
+static int initial_shared_resume(struct dm_exception_store *store)
+{
+	int i, r, uninitialized_var(new_snapshot);
+	struct shared_store *ss = get_shared_info(store);
+	sector_t size = get_dev_size(store->cow->bdev);
+	unsigned long bitmap_chunk_bytes;
+	unsigned chunk_bytes = store->chunk_size << SECTOR_SHIFT;
+
+	ss->cur_bitmap_chunk = 1;
+	ss->cur_bitmap_index = 0;
+	ss->nr_chunks = size >> store->chunk_shift;
+
+	ss->exceptions_per_area = (store->chunk_size << SECTOR_SHIFT) /
+		sizeof(struct disk_exception);
+	ss->callbacks = dm_vcalloc(ss->exceptions_per_area,
+				   sizeof(*ss->callbacks));
+	if (!ss->callbacks)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&ss->chunk_buffer_list);
+	INIT_LIST_HEAD(&ss->chunk_buffer_dirty_list);
+	ss->nr_chunk_buffers = 0;
+
+	bitmap_chunk_bytes = DIV_ROUND_UP(ss->nr_chunks, 8);
+	ss->nr_bitmap_chunks = DIV_ROUND_UP(bitmap_chunk_bytes, chunk_bytes);
+
+	r = shared_read_header(store, &new_snapshot);
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
+		if (!ss->valid)
+			return -EINVAL;
+
+		r = chunk_io(store, ss->cur_bitmap_chunk,
+			     READ, 1, ss->bitmap);
+	}
+
+	/* Count the number of snapshots on-disk */
+	for (i = 0; i < MAX_SNAPSHOTS; i++)
+		if (test_bit(i, (unsigned long *)&ss->snapmask))
+			ss->nr_snapshots++;
+
+	return r;
+}
+
+static int shared_resume(struct dm_exception_store *store)
+{
+	int r;
+	struct unique_store *us = get_unique_info(store);
+	struct shared_store *ss = get_shared_info(store);
+
+	if (atomic_inc_return(&ss->resume_counter) == 1) {
+		r = initial_shared_resume(store);
+		if (r)
+			return r;
+	}
+
+	/* Is this slot already active? */
+	if (test_and_set_bit(us->id, (unsigned long *)&ss->snapmask_live))
+		DMERR("Multiple resume issued");
+
+	return 0;
+}
+
+static void shared_postsuspend(struct dm_exception_store *store)
+{
+	struct unique_store *us = get_unique_info(store);
+	struct shared_store *ss = get_shared_info(store);
+
+	atomic_dec(&ss->resume_counter);
+
+	/*
+	 * We should be able to just set 'snapmask_live' to
+	 * zero... because if one suspends, it technically means
+	 * they all should suspend.  We'll set them one by one,
+	 * just to follow the rules better.
+	 */
+	if (!test_and_clear_bit(us->id, (unsigned long *)&ss->snapmask_live))
+		DMERR("Multiple suspend issued");
+}
+
+static int shared_prepare_exception(struct dm_exception_store *store,
+				    struct dm_exception *e, int group)
+{
+	struct unique_store *us = get_unique_info(store);
+	struct shared_store *ss = get_shared_info(store);
+	struct chunk_buffer *cb;
+	struct etree_path path[ss->tree_level + 1];
+	chunk_t new_chunk, chunk = e->old_chunk;
+	int ret;
+
+	cb = probe(store, chunk, path);
+	if (!cb)
+		return 1;
+
+	if (group)
+		ret = origin_chunk_unique(buffer2leaf(cb), chunk, ss->snapmask);
+	else
+		ret = snapshot_chunk_unique(buffer2leaf(cb), chunk, us->id,
+					    &new_chunk);
+	if (ret) {
+		/*
+		 * If we are preparing an exception, it means we should have
+		 * checked and not found it through lookup... but if we are
+		 * here, it means the exception snuck in somehow, or the user
+		 * is screwing up.
+		 */
+		DMINFO("%s %d: BUG ID:%llu chunk:%llu group:%d ret:%d",
+		       __func__, __LINE__,
+		       (unsigned long long)us->id,
+		       (unsigned long long)chunk, group, ret);
+		return 1;
+	}
+
+	new_chunk = shared_allocate_chunk(store);
+	if (!new_chunk)
+		return 1;
+
+	ret = add_exception_to_tree(store, cb, chunk, new_chunk, -1, path,
+				    ss->tree_level);
+	if (ret)
+		return 1;
+
+	/*
+	DMINFO("%s %d: allocated new chunk, %llu", __func__, __LINE__,
+	       (unsigned long long)new_chunk);
+	*/
+	e->new_chunk = new_chunk;
+	atomic_inc(&ss->pending_count);
+
+	return 0;
+}
+
+static void shared_commit_exception(struct dm_exception_store *store,
+				    struct dm_exception *e,
+				    void (*callback) (void *, int success),
+				    void *callback_context)
+{
+	int i, r = 0;
+	struct shared_store *ss = get_shared_info(store);
+	struct commit_callback *cb;
+
+	cb = ss->callbacks + ss->callback_count++;
+	cb->callback = callback;
+	cb->context = callback_context;
+
+	if (atomic_dec_and_test(&ss->pending_count) ||
+	    (ss->callback_count == ss->exceptions_per_area)) {
+		struct chunk_buffer *b, *n;
+
+		down_write(&ss->lock);
+
+		list_for_each_entry_safe(b, n, &ss->chunk_buffer_dirty_list,
+					 dirty_list) {
+
+			list_del_init(&b->dirty_list);
+			list_move_tail(&b->list, &ss->chunk_buffer_list);
+
+			/* todo: can be async */
+			chunk_io(store, b->chunk, WRITE, 1, b->data);
+		}
+
+		if (ss->header_dirty)
+			write_header(store);
+
+		list_for_each_entry_safe(b, n, &ss->chunk_buffer_list, list) {
+			if (ss->nr_chunk_buffers < MAX_CHUNK_BUFFERS)
+				break;
+
+			free_chunk_buffer(store, b);
+		}
+
+		up_write(&ss->lock);
+
+		for (i = 0; i < ss->callback_count; i++) {
+			cb = ss->callbacks + i;
+			cb->callback(cb->context, r == 0 ? 1 : 0);
+		}
+
+		ss->callback_count = 0;
+	}
+}
+
+static int shared_lookup_exception(struct dm_exception_store *store,
+				   chunk_t old, chunk_t *new,
+				   int group, int can_block)
+{
+	struct unique_store *us = get_unique_info(store);
+	struct shared_store *ss = get_shared_info(store);
+	unsigned levels = ss->tree_level;
+	struct etree_path path[levels + 1];
+	struct chunk_buffer *leafbuf;
+	int r;
+	chunk_t new_chunk = ~0;
+
+	leafbuf = probe(store, (u64)old, path);
+	if (!leafbuf)
+		return 0;/* should make the snapshot invalid, EINVAL? */
+
+	if (group)
+		r = origin_chunk_unique(buffer2leaf(leafbuf),
+					old, ss->snapmask);
+	else
+		r = snapshot_chunk_unique(buffer2leaf(leafbuf), old,
+					  us->id, &new_chunk);
+
+	if (r) {
+		if (new)
+			*new = new_chunk;
+
+		return 0;
+	}
+
+	return -ENOENT;
+}
+
+static int shared_message(struct dm_exception_store *store,
+			  unsigned argc, char **argv)
+{
+	int r;
+	struct unique_store *us = get_unique_info(store);
+	struct shared_store *ss = get_shared_info(store);
+
+	if (argc != 1)
+		return -EINVAL;
+
+	if (!strcmp("ES_INVALIDATE", argv[0])) {
+		chunk_io(store, ss->cur_bitmap_chunk, WRITE, 1, ss->bitmap);
+		write_header(store);
+
+		ss->valid = 0;
+		return 0;
+	}
+
+	if (!strcmp("ES_DESTROY", argv[0])) {
+		u64 mask;
+
+		if (test_and_clear_bit(us->id, (unsigned long *)&ss->snapmask)) {
+			DMINFO("%s %d: delete %lluth snapshot.",
+			       __func__, __LINE__, us->id);
+
+			mask = 1ULL << us->id;
+
+			r = delete_tree_range(store, mask, 0);
+			if (!r)
+				ss->nr_snapshots--;
+
+			write_header(store);
+		} else
+			DMINFO("%s %d: %lluth snapshot doesn't exists.",
+			       __func__, __LINE__, us->id);
+		return 0;
+	}
+
+	return -ENOSYS;
+}
+
+static void shared_fraction_full(struct dm_exception_store *store,
+				 sector_t *numerator, sector_t *denominator)
+{
+	/* FIXME: implement */
+	*numerator = 0;
+	*denominator = 1;
+}
+
+static unsigned shared_status(struct dm_exception_store *store,
+			      status_type_t status,
+			      char *result, unsigned int maxlen)
+{
+	struct unique_store *us = get_unique_info(store);
+	int sz = 0;
+
+	switch (status) {
+	case STATUSTYPE_INFO:
+		/*
+		 * Here you could print whatever you want, like:
+		 * "shared <ID> <next available ID> ..."
+		 */
+		break;
+	case STATUSTYPE_TABLE:
+		DMEMIT("shared 3 %s %llu %llu", store->cow->name,
+		       (unsigned long long)store->chunk_size,
+		       (unsigned long long)us->id);
+	}
+
+	return sz;
+}
+
+static struct dm_exception_store_type _shared_type = {
+	.name = "shared",
+	.module = THIS_MODULE,
+	.ctr = shared_ctr,
+	.dtr = shared_dtr,
+	.resume = shared_resume,
+	.postsuspend = shared_postsuspend,
+	.prepare_exception = shared_prepare_exception,
+	.commit_exception = shared_commit_exception,
+	.lookup_exception = shared_lookup_exception,
+	.fraction_full = shared_fraction_full,
+	.status = shared_status,
+	.message = shared_message,
+};
+
+static int __init shared_exception_store_init(void)
+{
+	int r;
+
+	INIT_LIST_HEAD(&shared_store_list);
+
+	r = dm_exception_store_type_register(&_shared_type);
+	if (r) {
+		DMWARN("Unable to register shared exception store type");
+		return r;
+	}
+
+	DMINFO("(built %s %s) installed", __DATE__, __TIME__);
+	return 0;
+}
+
+static void __exit shared_exception_store_exit(void)
+{
+	dm_exception_store_type_unregister(&_shared_type);
+	DMINFO("(built %s %s) removed", __DATE__, __TIME__);
+}
+
+module_init(shared_exception_store_init);
+module_exit(shared_exception_store_exit);
+
+MODULE_DESCRIPTION("Shared exception store");
+MODULE_AUTHOR("D. Phillips, F. Tomonori, J. Brassow, others?");
+MODULE_LICENSE("GPL");
Index: linux-2.6/drivers/md/Kconfig
===================================================================
--- linux-2.6.orig/drivers/md/Kconfig
+++ linux-2.6/drivers/md/Kconfig
@@ -249,6 +249,14 @@ config DM_SNAPSHOT
        ---help---
          Allow volume managers to take writable snapshots of a device.
 
+config DM_EXSTORE_SHARED
+	tristate "Shared exception store (EXPERIMENTAL)"
+	depends on DM_SNAPSHOT && EXPERIMENTAL
+	---help---
+	  Allows the COW device used by snapshots to be shared.  This
+	  yields space and performance gains when more than one
+	  snapshot is taken of a device.
+
 config DM_MIRROR
        tristate "Mirror target"
        depends on BLK_DEV_DM
Index: linux-2.6/drivers/md/Makefile
===================================================================
--- linux-2.6.orig/drivers/md/Makefile
+++ linux-2.6/drivers/md/Makefile
@@ -7,6 +7,7 @@ dm-mod-objs	:= dm.o dm-table.o dm-target
 dm-multipath-objs := dm-path-selector.o dm-mpath.o
 dm-snapshot-objs := dm-snap.o dm-exception.o dm-exception-store.o \
 		    dm-snap-persistent.o dm-snap-transient.o
+dm-exstore-shared-objs := dm-ex-store-shared.o
 dm-mirror-objs	:= dm-raid1.o
 md-mod-objs     := md.o bitmap.o
 raid456-objs	:= raid5.o raid6algos.o raid6recov.o raid6tables.o \
@@ -35,6 +36,7 @@ obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
 obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
 obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
+obj-$(CONFIG_DM_EXSTORE_SHARED) += dm-exstore-shared.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-region-hash.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
 
