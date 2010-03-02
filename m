From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 12/14] dm-multisnap-mikulas-common
Date: Mon,  1 Mar 2010 19:23:56 -0500
Message-ID: <1267489438-6271-13-git-send-email-snitzer@redhat.com>
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

The topmost file used to initialize and unload the exception store.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-multisnap-mikulas.c |  760 +++++++++++++++++++++++++++++++++++++
 1 files changed, 760 insertions(+), 0 deletions(-)
 create mode 100644 drivers/md/dm-multisnap-mikulas.c

diff --git a/drivers/md/dm-multisnap-mikulas.c b/drivers/md/dm-multisnap-mikulas.c
new file mode 100644
index 0000000..ec6e30f
--- /dev/null
+++ b/drivers/md/dm-multisnap-mikulas.c
@@ -0,0 +1,760 @@
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
+ * Initialize in-memory structures, belonging to the commit block.
+ */
+static void init_commit_block(struct dm_exception_store *s)
+{
+	int i;
+
+	dm_multisnap_init_freelist(s->freelist, s->chunk_size);
+
+	s->snapshot_num = 0;
+	s->total_allocated = 0;
+	s->data_allocated = 0;
+	s->bitmap_root = 0;
+	s->alloc_rover = 0;
+	s->freelist_ptr = 0;
+	s->delete_rover_chunk = 0;
+	s->delete_rover_snapid = 0;
+	s->bt_root = 0;
+	s->bt_depth = 0;
+	s->flags = 0;
+
+	for (i = 0; i < TMP_REMAP_HASH_SIZE; i++)
+		INIT_HLIST_HEAD(&s->tmp_remap[i]);
+	s->n_used_tmp_remaps = 0;
+	INIT_LIST_HEAD(&s->used_bitmap_tmp_remaps);
+	INIT_LIST_HEAD(&s->used_bt_tmp_remaps);
+	INIT_LIST_HEAD(&s->free_tmp_remaps);
+
+	for (i = 0; i < N_REMAPS; i++) {
+		struct tmp_remap *t = &s->tmp_remap_store[i];
+		list_add(&t->list, &s->free_tmp_remaps);
+	}
+
+	s->dev_size = 0;
+	s->bitmap_depth = 0;
+	s->btree_entries = dm_multisnap_btree_entries(s->chunk_size);
+}
+
+/*
+ * Load the commit block specified in s->valid_commit_block to memory
+ * and populate in-memory structures.
+ */
+static void load_commit_block(struct dm_exception_store *s)
+{
+	struct dm_buffer *bp;
+	struct multisnap_commit_block *cb;
+	__u64 dev_size;
+	int bitmap_depth;
+	unsigned i;
+
+	dm_multisnap_clear_uncommitted(s);
+
+	cb = dm_bufio_read(s->bufio, s->valid_commit_block, &bp);
+	if (IS_ERR(cb)) {
+		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(cb),
+				       ("load_commit_block: can't re-read commit block %llx",
+					(unsigned long long)s->valid_commit_block));
+		return;
+	}
+	if (cb->signature != CB_SIGNATURE) {
+		dm_bufio_release(bp);
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("load_commit_block: bad signature when re-reading commit block %llx",
+					(unsigned long long)s->valid_commit_block));
+		return;
+	}
+
+	init_commit_block(s);
+
+	dev_size = read_48(cb, dev_size);
+	s->snapshot_num = le32_to_cpu(cb->snapshot_num);
+	s->total_allocated = read_48(cb, total_allocated);
+	s->data_allocated = read_48(cb, data_allocated);
+	s->bitmap_root = read_48(cb, bitmap_root);
+	s->alloc_rover = read_48(cb, alloc_rover);
+	s->freelist_ptr = read_48(cb, freelist);
+	s->delete_rover_chunk = read_48(cb, delete_rover);
+	s->delete_rover_snapid = 0;
+	s->bt_root = read_48(cb, bt_root);
+	s->bt_depth = cb->bt_depth;
+	s->flags = cb->flags;
+
+	if (s->bt_depth > MAX_BT_DEPTH || !s->bt_depth) {
+		dm_bufio_release(bp);
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("load_commit_block: invalid b+-tree depth in commit block %llx",
+					(unsigned long long)s->valid_commit_block));
+		return;
+	}
+
+	INIT_LIST_HEAD(&s->free_tmp_remaps);
+	for (i = 0; i < N_REMAPS; i++) {
+		struct tmp_remap *t = &s->tmp_remap_store[i];
+		if (read_48(&cb->tmp_remap[i], old)) {
+			t->old = read_48(&cb->tmp_remap[i], old);
+			t->new = read_48(&cb->tmp_remap[i], new);
+			t->uncommitted = 0;
+			t->bitmap_idx = le32_to_cpu(cb->tmp_remap[i].bitmap_idx);
+			hlist_add_head(&t->hash_list, &s->tmp_remap[TMP_REMAP_HASH(t->old)]);
+			if (t->bitmap_idx == CB_BITMAP_IDX_NONE)
+				list_add(&t->list, &s->used_bt_tmp_remaps);
+			else
+				list_add(&t->list, &s->used_bitmap_tmp_remaps);
+			s->n_used_tmp_remaps++;
+		} else {
+			list_add(&t->list, &s->free_tmp_remaps);
+		}
+	}
+
+	dm_bufio_release(bp);
+
+	if ((chunk_t)(dev_size + s->cb_stride) < (chunk_t)dev_size) {
+		DM_MULTISNAP_SET_ERROR(s->dm, -ERANGE,
+				       ("load_commit_block: device is too large. Compile kernel with 64-bit sector numbers"));
+		return;
+	}
+	bitmap_depth = dm_multisnap_bitmap_depth(s->chunk_shift, dev_size);
+	if (bitmap_depth < 0) {
+		DM_MULTISNAP_SET_ERROR(s->dm, bitmap_depth,
+				       ("load_commit_block: device is too large"));
+		return;
+	}
+	s->dev_size = dev_size;
+	s->bitmap_depth = bitmap_depth;
+
+	dm_multisnap_load_freelist(s);
+}
+
+/*
+ * Find the valid commit block.
+ *
+ * Read the initial commit block number from the superblock and then scan the
+ * commit blocks linearly as long as the sequence number in the commit block
+ * increases.
+ */
+static void find_commit_block(struct dm_exception_store *s)
+{
+	struct dm_buffer *bp;
+	struct multisnap_commit_block *cb;
+	chunk_t cb_addr = s->sb_commit_block;
+	__u64 sequence;
+	__u64 dev_size;
+	s->valid_commit_block = 0;
+	s->commit_sequence = 0;
+
+try_next:
+	cb = dm_bufio_read(s->bufio, cb_addr, &bp);
+	if (IS_ERR(cb)) {
+		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(cb),
+				       ("find_commit_block: can't read commit block %llx",
+					(unsigned long long)cb_addr));
+		return;
+	}
+	if (cb->signature != CB_SIGNATURE) {
+		dm_bufio_release(bp);
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("find_commit_block: bad signature on commit block %llx",
+					(unsigned long long)cb_addr));
+		return;
+	}
+
+	sequence = le64_to_cpu(cb->sequence);
+	dev_size = read_48(cb, dev_size);
+
+	dm_bufio_release(bp);
+
+	if (sequence > s->commit_sequence) {
+		s->commit_sequence = sequence;
+		s->valid_commit_block = cb_addr;
+		if ((__u64)cb_addr + s->cb_stride < dev_size) {
+			cb_addr += s->cb_stride;
+			goto try_next;
+		}
+	}
+	if (!s->valid_commit_block) {
+		DM_MULTISNAP_SET_ERROR(s->dm, -EFSERROR,
+				       ("find_commit_block: no valid commit block"));
+		return;
+	}
+}
+
+/*
+ * Return device size in chunks.
+ */
+static int get_size(struct dm_exception_store *s, chunk_t *size)
+{
+	__u64 dev_size;
+	dev_size = i_size_read(dm_multisnap_snapshot_bdev(s->dm)->bd_inode) >> s->chunk_shift;
+	*size = dev_size;
+	if ((chunk_t)(dev_size + s->cb_stride) < dev_size)
+		return -EFBIG;
+
+	return 0;
+}
+
+/*
+ * Initialize the whole snapshot store.
+ */
+static void initialize_device(struct dm_exception_store *s)
+{
+	int r;
+	struct dm_buffer *bp;
+	struct multisnap_superblock *sb;
+	struct multisnap_commit_block *cb;
+	chunk_t cb_block;
+	chunk_t block_to_write;
+
+	s->cb_stride = CB_STRIDE_DEFAULT;
+
+	r = get_size(s, &s->dev_size);
+	if (r) {
+		DM_MULTISNAP_SET_ERROR(s->dm, r,
+				       ("initialize_device: device is too large. Compile kernel with 64-bit sector numbers"));
+		return;
+	}
+
+	s->total_allocated = 0;
+	s->data_allocated = 0;
+
+	block_to_write = SB_BLOCK + 1;
+
+	/* Write btree */
+	dm_multisnap_create_btree(s, &block_to_write);
+	if (dm_multisnap_has_error(s->dm))
+		return;
+
+	/* Write bitmaps */
+	dm_multisnap_create_bitmaps(s, &block_to_write);
+	if (dm_multisnap_has_error(s->dm))
+		return;
+
+	s->dev_size = block_to_write;
+
+	/* Write commit blocks */
+	if (FIRST_CB_BLOCK >= s->dev_size) {
+		DM_MULTISNAP_SET_ERROR(s->dm, -ENOSPC,
+				       ("initialize_device: device is too small"));
+		return;
+	}
+	for (cb_block = FIRST_CB_BLOCK; cb_block < s->dev_size; cb_block += s->cb_stride) {
+		cb = dm_bufio_new(s->bufio, cb_block, &bp);
+		if (IS_ERR(cb)) {
+			DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(cb),
+					       ("initialize_device: can't allocate commit block at %llx",
+						(unsigned long long)cb_block));
+			return;
+		}
+		memset(cb, 0, s->chunk_size);
+		cb->signature = CB_SIGNATURE;
+		cb->sequence = cpu_to_le64(cb_block == FIRST_CB_BLOCK);
+		if (cb_block == FIRST_CB_BLOCK) {
+			cb->snapshot_num = cpu_to_le32(0);
+			write_48(cb, dev_size, s->dev_size);
+			write_48(cb, total_allocated, s->total_allocated);
+			write_48(cb, data_allocated, s->data_allocated);
+			write_48(cb, bitmap_root, s->bitmap_root);
+			write_48(cb, freelist, 0);
+			write_48(cb, delete_rover, 0);
+			write_48(cb, bt_root, s->bt_root);
+			cb->bt_depth = s->bt_depth;
+			cb->flags = 0;
+		}
+		dm_bufio_mark_buffer_dirty(bp);
+		dm_bufio_release(bp);
+	}
+	r = dm_bufio_write_dirty_buffers(s->bufio);
+	if (r) {
+		DM_MULTISNAP_SET_ERROR(s->dm, r,
+				       ("initialize_device: write error when initializing device"));
+		return;
+	}
+
+	/* Write super block */
+	sb = dm_bufio_new(s->bufio, SB_BLOCK, &bp);
+	if (IS_ERR(sb)) {
+		DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(sb),
+				       ("initialize_device: can't allocate super block"));
+		return;
+	}
+	memset(sb, 0, s->chunk_size);
+	sb->signature = SB_SIGNATURE;
+	sb->chunk_size = cpu_to_le32(s->chunk_size);
+	sb->cb_stride = cpu_to_le32(s->cb_stride);
+	sb->error = cpu_to_le32(0);
+	sb->commit_block = cpu_to_le64(FIRST_CB_BLOCK);
+	dm_bufio_mark_buffer_dirty(bp);
+	dm_bufio_release(bp);
+	r = dm_bufio_write_dirty_buffers(s->bufio);
+	if (r) {
+		DM_MULTISNAP_SET_ERROR(s->dm, r,
+				       ("initialize_device: can't write super block"));
+		return;
+	}
+}
+
+/*
+ * Extend the snapshot store if its size increases.
+ *
+ * Note: the size can never decrease.
+ */
+static void extend_exception_store(struct dm_exception_store *s, chunk_t new_size)
+{
+	struct dm_buffer *bp;
+	chunk_t cb_block;
+	struct multisnap_commit_block *cb;
+
+	/* Write commit blocks */
+	for (cb_block = FIRST_CB_BLOCK; cb_block < new_size; cb_block += s->cb_stride) {
+		cond_resched();
+		if (cb_block < s->dev_size)
+			continue;
+		cb = dm_bufio_new(s->bufio, cb_block, &bp);
+		if (IS_ERR(cb)) {
+			DM_MULTISNAP_SET_ERROR(s->dm, PTR_ERR(cb),
+					       ("initialize_device: can't allocate commit block at %llx",
+						(unsigned long long)cb_block));
+			return;
+		}
+		memset(cb, 0, s->chunk_size);
+		cb->signature = CB_SIGNATURE;
+		cb->sequence = cpu_to_le64(0);
+		dm_bufio_mark_buffer_dirty(bp);
+		dm_bufio_release(bp);
+	}
+
+	dm_multisnap_extend_bitmaps(s, new_size);
+
+	s->valid_commit_block = (chunk_t)-1;
+
+	dm_multisnap_commit(s);
+}
+
+/*
+ * Read the super block and possibly initialize the device.
+ *
+ * If the super block contains valid signature, we assume that the device
+ * is initialized and read all the data.
+ * If the super block is zeroed, we do initialization.
+ * Otherwise we report error.
+ */
+static int read_super(struct dm_exception_store *s, char **error)
+{
+	struct dm_buffer *bp;
+	struct multisnap_superblock *sb;
+	int initialized;
+	__s32 e;
+
+	init_commit_block(s);
+
+	initialized = 0;
+re_read:
+	sb = dm_bufio_read(s->bufio, SB_BLOCK, &bp);
+	if (IS_ERR(sb)) {
+		*error = "Could not read superblock";
+		return PTR_ERR(sb);
+	}
+
+	if (sb->signature != SB_SIGNATURE) {
+		int i;
+		if (initialized) {
+			*error = "Invalid signature after initialization";
+			return -EIO;
+		}
+		for (i = 0; i < 1 << SECTOR_SHIFT; i++) {
+			if (((char *)sb)[i]) {
+				dm_bufio_release(bp);
+				*error = "Uninitialized device";
+				return -ENXIO;
+			}
+		}
+		dm_bufio_release(bp);
+		initialize_device(s);
+		if (dm_multisnap_has_error(s->dm)) {
+			*error = "Can't initialize device";
+			return dm_multisnap_has_error(s->dm);
+		}
+		initialized = 1;
+		goto re_read;
+	}
+	if (le32_to_cpu(sb->chunk_size) != s->chunk_size) {
+		dm_bufio_release(bp);
+		*error = "Bad chunk size";
+		return -EINVAL;
+	}
+	s->cb_stride = le32_to_cpu(sb->cb_stride);
+	if (s->cb_stride <= 1) {
+		dm_bufio_release(bp);
+		*error = "Bad commit block stride in superblock";
+		return -EFSERROR;
+	}
+	s->sb_commit_block = le64_to_cpu(sb->commit_block);
+	e = le32_to_cpu(sb->error);
+	dm_bufio_release(bp);
+
+	find_commit_block(s);
+
+	if (dm_multisnap_has_error(s->dm)) {
+		if (dm_multisnap_drop_on_error(s->dm))
+			return 0;
+		*error = "Unable to find commit block";
+		return dm_multisnap_has_error(s->dm);
+	}
+
+	load_commit_block(s);
+
+	if (dm_multisnap_has_error(s->dm)) {
+		if (dm_multisnap_drop_on_error(s->dm))
+			return 0;
+		*error = "Unable to load commit block";
+		return dm_multisnap_has_error(s->dm);
+	}
+
+	if (e < 0) {
+		/* Don't read the B+-tree if there was an error */
+		DM_MULTISNAP_SET_ERROR(s->dm, e,
+				       ("read_super: activating invalidated snapshot store, error %d", e));
+		return 0;
+	}
+
+	dm_multisnap_read_snapshots(s);
+	if (dm_multisnap_has_error(s->dm)) {
+		if (dm_multisnap_drop_on_error(s->dm))
+			return 0;
+		*error = "Could not read snapshot list";
+		return dm_multisnap_has_error(s->dm);
+	}
+
+	return 0;
+}
+
+/*
+ * This is a callback that is being called each time the generic code acquires
+ * the master lock. Thus, it is guaranteed that other operations won't race with
+ * this callback.
+ *
+ * Currently, we test if the device size has grown, and if so, we extend the
+ * exception store.
+ *
+ * If the device size has shrunk, we report an error and stop further
+ * operations.
+ */
+static void dm_multisnap_mikulas_lock_acquired(struct dm_exception_store *s, int flags)
+{
+	int r;
+	chunk_t new_size;
+
+	if (!dm_multisnap_can_commit(s->dm))
+		return;
+
+	r = get_size(s, &new_size);
+	if (unlikely(r))
+		return;
+
+	if (unlikely(new_size != s->dev_size)) {
+		if (unlikely(new_size < s->dev_size)) {
+			DM_MULTISNAP_SET_ERROR(s->dm, -EINVAL,
+					       ("dm_multisnap_mikulas_lock_acquired: device shrinked"));
+			return;
+		}
+		extend_exception_store(s, new_size);
+	}
+}
+
+/*
+ * Debug code.
+ */
+
+/*#define PRINT_BTREE*/
+
+#ifdef PRINT_BTREE
+static int print_btree_callback(struct dm_exception_store *s,
+				struct dm_multisnap_bt_node *node,
+				struct dm_multisnap_bt_entry *bt, void *cookie)
+{
+	printk(KERN_DEBUG "entry: %llx, %llx-%llx -> %llx\n",
+		(unsigned long long)read_48(bt, orig_chunk),
+		(unsigned long long)cpu_to_mikulas_snapid(bt->snap_from),
+		(unsigned long long)cpu_to_mikulas_snapid(bt->snap_to),
+		(unsigned long long)read_48(bt, new_chunk));
+	return 0;
+}
+
+static void print_btree(struct dm_exception_store *s)
+{
+	struct bt_key key = { 0, 0, 0 };
+	int r = dm_multisnap_list_btree(s, &key, print_btree_callback, NULL);
+	printk(KERN_DEBUG "list ended: %d\n", r);
+}
+#endif
+
+/*#define PRINT_BITMAPS*/
+
+#ifdef PRINT_BITMAPS
+static void print_bitmaps(struct dm_exception_store *s)
+{
+	chunk_t c;
+	printk(KERN_DEBUG "allocated:");
+	for (c = 0; c < s->dev_size; c += s->chunk_size * 8) {
+		struct dm_buffer *bp;
+		unsigned i;
+		void *bmp = dm_multisnap_map_bitmap(s, c >> (s->chunk_shift + 3),
+						    &bp, NULL, NULL);
+		if (!bmp)
+			continue;
+		for (i = 0; i < s->chunk_size * 8; i++)
+			if (generic_test_le_bit(i, bmp)) {
+				chunk_t block = c + i;
+				if (!dm_multisnap_is_commit_block(s, block))
+					printk(" %llx", (unsigned long long)block);
+				cond_resched();
+			}
+		}
+
+		dm_bufio_release(bp);
+	}
+	printk("\n");
+}
+#endif
+
+/*
+ * The initialization callback.
+ * Parse arguments, allocate structures and call read_super to read the data
+ * from the disk.
+ */
+static int dm_multisnap_mikulas_init(struct dm_multisnap *dm,
+				     struct dm_exception_store **sp,
+				     unsigned argc, char **argv, char **error)
+{
+	int r, i;
+	struct dm_exception_store *s;
+
+	s = kzalloc(sizeof(struct dm_exception_store), GFP_KERNEL);
+	if (!s) {
+		*error = "Could not allocate private area";
+		r = -ENOMEM;
+		goto bad_private;
+	}
+	*sp = s;
+
+	s->dm = dm;
+	s->chunk_size = dm_multisnap_chunk_size(dm);
+	s->chunk_shift = ffs(s->chunk_size) - 1;
+
+	s->active_snapshots = RB_ROOT;
+	s->n_preallocated_blocks = 0;
+	s->query_active = 0;
+
+	s->delete_work.work = dm_multisnap_background_delete;
+	s->delete_work.queued = 0;
+	s->delete_commit_count = 0;
+
+	s->cache_threshold = 0;
+	s->cache_limit = 0;
+
+	for (i = 0; i < UNCOMMITTED_BLOCK_HASH_SIZE; i++)
+		INIT_HLIST_HEAD(&s->uncommitted_blocks[i]);
+
+	while (argc) {
+		char *string;
+		r = dm_multisnap_get_string(&argv, &argc, &string, error);
+		if (r)
+			goto bad_arguments;
+		if (!strcasecmp(string, "cache-threshold")) {
+			r = dm_multisnap_get_uint64(&argv, &argc,
+						    &s->cache_threshold, error);
+			if (r)
+				goto bad_arguments;
+		} else if (!strcasecmp(string, "cache-limit")) {
+			r = dm_multisnap_get_uint64(&argv, &argc,
+						    &s->cache_limit, error);
+			if (r)
+				goto bad_arguments;
+		} else {
+			*error = "Unknown parameter";
+			r = -EINVAL;
+			goto bad_arguments;
+		}
+	}
+
+
+	s->tmp_chunk = vmalloc(s->chunk_size + sizeof(struct dm_multisnap_bt_entry));
+	if (!s->tmp_chunk) {
+		*error = "Can't allocate temporary chunk";
+		r = -ENOMEM;
+		goto bad_tmp_chunk;
+	}
+
+	s->freelist = vmalloc(s->chunk_size);
+	if (!s->freelist) {
+		*error = "Can't allocate freelist";
+		r = -ENOMEM;
+		goto bad_freelist;
+	}
+
+	s->bufio = dm_bufio_client_create(dm_multisnap_snapshot_bdev(s->dm),
+					  s->chunk_size, 0, s->cache_threshold,
+					  s->cache_limit);
+	if (IS_ERR(s->bufio)) {
+		*error = "Can't create bufio client";
+		r = PTR_ERR(s->bufio);
+		goto bad_bufio;
+	}
+
+	r = read_super(s, error);
+	if (r)
+		goto bad_super;
+
+	if (s->flags & (DM_MULTISNAP_FLAG_DELETING |
+			DM_MULTISNAP_FLAG_PENDING_DELETE))
+		dm_multisnap_queue_work(s->dm, &s->delete_work);
+
+#ifdef PRINT_BTREE
+	print_btree(s);
+#endif
+#ifdef PRINT_BITMAPS
+	print_bitmaps(s);
+#endif
+
+	return 0;
+
+bad_super:
+	dm_bufio_client_destroy(s->bufio);
+bad_bufio:
+	vfree(s->freelist);
+bad_freelist:
+	vfree(s->tmp_chunk);
+bad_tmp_chunk:
+bad_arguments:
+	kfree(s);
+bad_private:
+	return r;
+}
+
+/*
+ * Exit the exception store.
+ */
+static void dm_multisnap_mikulas_exit(struct dm_exception_store *s)
+{
+	int i;
+
+	dm_multisnap_cancel_work(s->dm, &s->delete_work);
+
+	i = 0;
+	while (!list_empty(&s->used_bitmap_tmp_remaps)) {
+		struct tmp_remap *t = list_first_entry(&s->used_bitmap_tmp_remaps,
+						       struct tmp_remap, list);
+		list_del(&t->list);
+		hlist_del(&t->hash_list);
+		i++;
+	}
+
+	while (!list_empty(&s->used_bt_tmp_remaps)) {
+		struct tmp_remap *t = list_first_entry(&s->used_bt_tmp_remaps,
+						       struct tmp_remap, list);
+		list_del(&t->list);
+		hlist_del(&t->hash_list);
+		i++;
+	}
+
+	BUG_ON(i != s->n_used_tmp_remaps);
+	while (!list_empty(&s->free_tmp_remaps)) {
+		struct tmp_remap *t = list_first_entry(&s->free_tmp_remaps, struct tmp_remap, list);
+		list_del(&t->list);
+		i++;
+	}
+	BUG_ON(i != N_REMAPS);
+
+	for (i = 0; i < TMP_REMAP_HASH_SIZE; i++)
+		BUG_ON(!hlist_empty(&s->tmp_remap[i]));
+
+	dm_multisnap_clear_uncommitted(s);
+
+	dm_bufio_client_destroy(s->bufio);
+	vfree(s->freelist);
+	vfree(s->tmp_chunk);
+	kfree(s);
+}
+
+/*
+ * Return exception-store specific arguments. This is used in the proces of
+ * constructing the table returned by device mapper.
+ */
+static void dm_multisnap_status_table(struct dm_exception_store *s,
+				      char *result, unsigned maxlen)
+{
+	int npar = 0;
+	if (s->cache_threshold)
+		npar += 2;
+	if (s->cache_limit)
+		npar += 2;
+
+	snprintf(result, maxlen, " %d", npar);
+	dm_multisnap_adjust_string(&result, &maxlen);
+
+	if (s->cache_threshold) {
+		snprintf(result, maxlen, " cache-threshold %llu",
+			 (unsigned long long)s->cache_threshold);
+		dm_multisnap_adjust_string(&result, &maxlen);
+	}
+	if (s->cache_limit) {
+		snprintf(result, maxlen, " cache-limit %llu",
+			 (unsigned long long)s->cache_limit);
+		dm_multisnap_adjust_string(&result, &maxlen);
+	}
+}
+
+struct dm_multisnap_exception_store dm_multisnap_mikulas_store = {
+	.name			= "mikulas",
+	.module			= THIS_MODULE,
+	.init_exception_store	= dm_multisnap_mikulas_init,
+	.exit_exception_store	= dm_multisnap_mikulas_exit,
+	.store_lock_acquired	= dm_multisnap_mikulas_lock_acquired,
+#ifdef CONFIG_DM_MULTISNAPSHOT_MIKULAS_SNAP_OF_SNAP
+	.print_snapid		= dm_multisnap_print_snapid,
+	.read_snapid		= dm_multisnap_read_snapid,
+#endif
+	.status_table		= dm_multisnap_status_table,
+	.get_space		= dm_multisnap_get_space,
+	.allocate_snapid	= dm_multisnap_allocate_snapid,
+	.create_snapshot	= dm_multisnap_create_snapshot,
+	.delete_snapshot	= dm_multisnap_delete_snapshot,
+	.get_next_snapid	= dm_multisnap_get_next_snapid,
+	.compare_snapids_for_create = dm_multisnap_compare_snapids_for_create,
+	.find_snapshot_chunk	= dm_multisnap_find_snapshot_chunk,
+	.reset_query		= dm_multisnap_reset_query,
+	.query_next_remap	= dm_multisnap_query_next_remap,
+	.add_next_remap		= dm_multisnap_add_next_remap,
+	.make_chunk_writeable	= dm_multisnap_make_chunk_writeable,
+	.check_conflict		= dm_multisnap_check_conflict,
+	.prepare_for_commit	= dm_multisnap_prepare_for_commit,
+	.commit			= dm_multisnap_commit,
+};
+
+static int __init dm_multisnapshot_mikulas_module_init(void)
+{
+	BUG_ON(sizeof(struct multisnap_commit_block) != 512);
+	return dm_multisnap_register_exception_store(&dm_multisnap_mikulas_store);
+}
+
+static void __exit dm_multisnapshot_mikulas_module_exit(void)
+{
+	dm_multisnap_unregister_exception_store(&dm_multisnap_mikulas_store);
+}
+
+module_init(dm_multisnapshot_mikulas_module_init);
+module_exit(dm_multisnapshot_mikulas_module_exit);
+
+MODULE_DESCRIPTION(DM_NAME " multisnapshot Mikulas' exceptions store");
+MODULE_AUTHOR("Mikulas Patocka");
+MODULE_LICENSE("GPL");
-- 
1.6.5.2
