From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 14/14] dm-multisnap-daniel
Date: Mon,  1 Mar 2010 19:23:58 -0500
Message-ID: <1267489438-6271-15-git-send-email-snitzer@redhat.com>
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

An implementation of snapshot store.
Designed by Daniel Phillips, ported to kernelspace by Fujita Tomonorig.

This implementation plugs as a module into dm-multisnapshot interface.

The interface is almost the same as in Mikulas' exception store. You have to
specify "daniel" instead of "mikulas" as a type of exception store.
The only supported chunk size is 16384 bytes (but the code is general enough and
this restriction may be removed in the future).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/Kconfig               |   14 +
 drivers/md/Makefile              |    2 +
 drivers/md/dm-multisnap-daniel.c | 1711 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 1727 insertions(+), 0 deletions(-)
 create mode 100644 drivers/md/dm-multisnap-daniel.c

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 0c3ce3b..c30bf70 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -268,6 +268,20 @@ config DM_MULTISNAPSHOT_MIKULAS
 	  A B+-tree-based log-structured storage allowing unlimited
 	  number of snapshots.
 
+config DM_MULTISNAPSHOT_DANIEL
+	tristate "Daniel's snapshot store"
+	depends on DM_MULTISNAPSHOT
+	---help---
+	  Daniel Philips' exception store. The data structures were
+	  designed by Daniel Phillips for Zumastore project, a porting
+	  to kernel space was done by Fujita Tomonorig.
+
+	  This store has limit of at most 64 snapshots and supports
+	  snapshot deletion.
+
+	  So far it doesn't support maintaining consistency across
+	  crashes; journaling is under development.
+
 config DM_MIRROR
        tristate "Mirror target"
        depends on BLK_DEV_DM
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 084d632..836cd95 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -13,6 +13,7 @@ dm-store-mikulas-y += dm-multisnap-mikulas.o dm-multisnap-alloc.o \
 		   dm-multisnap-commit.o dm-multisnap-delete.o \
 		   dm-multisnap-freelist.o dm-multisnap-io.o \
 		   dm-multisnap-snaps.o dm-bufio.o
+dm-store-daniel-y += dm-multisnap-daniel.o
 dm-mirror-y	+= dm-raid1.o
 dm-log-userspace-y \
 		+= dm-log-userspace-base.o dm-log-userspace-transfer.o
@@ -49,6 +50,7 @@ obj-$(CONFIG_DM_MULTIPATH_ST)	+= dm-service-time.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_MULTISNAPSHOT)	+= dm-multisnapshot.o
 obj-$(CONFIG_DM_MULTISNAPSHOT_MIKULAS) += dm-store-mikulas.o
+obj-$(CONFIG_DM_MULTISNAPSHOT_DANIEL) += dm-store-daniel.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-region-hash.o
 obj-$(CONFIG_DM_LOG_USERSPACE)	+= dm-log-userspace.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
diff --git a/drivers/md/dm-multisnap-daniel.c b/drivers/md/dm-multisnap-daniel.c
new file mode 100644
index 0000000..00fd3c0
--- /dev/null
+++ b/drivers/md/dm-multisnap-daniel.c
@@ -0,0 +1,1711 @@
+/*
+ * dm-exception-store.c
+ *
+ * Copyright (C) 2001-2002 Sistina Software (UK) Limited.
+ * Copyright (C) 2006 Red Hat GmbH
+ *
+ * The shared exception code is based on Zumastor (http://zumastor.org/)
+ *
+ * By: Daniel Phillips, Nov 2003 to Mar 2007
+ * (c) 2003, Sistina Software Inc.
+ * (c) 2004, Red Hat Software Inc.
+ * (c) 2005 Daniel Phillips
+ * (c) 2006 - 2007, Google Inc
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm-multisnap.h"
+
+#include <linux/mm.h>
+#include <linux/pagemap.h>
+#include <linux/vmalloc.h>
+#include <linux/slab.h>
+#include <linux/dm-io.h>
+#include <linux/dm-kcopyd.h>
+
+#define DM_CHUNK_SIZE_DEFAULT_SECTORS 32	/* 16KB */
+
+#define MAX_SNAPSHOTS 64
+
+#define MAX_CHUNK_BUFFERS 128
+
+/*-----------------------------------------------------------------
+ * Persistent snapshots, by persistent we mean that the snapshot
+ * will survive a reboot.
+ *---------------------------------------------------------------
+ */
+
+/*
+ * We need to store a record of which parts of the origin have
+ * been copied to the snapshot device.  The snapshot code
+ * requires that we copy exception chunks to chunk aligned areas
+ * of the COW store.  It makes sense therefore, to store the
+ * metadata in chunk size blocks.
+ *
+ * There is no backward or forward compatibility implemented,
+ * snapshots with different disk versions than the kernel will
+ * not be usable.  It is expected that "lvcreate" will blank out
+ * the start of a fresh COW device before calling the snapshot
+ * constructor.
+ *
+ * The first chunk of the COW device just contains the header.
+ * After this there is a chunk filled with exception metadata,
+ * followed by as many exception chunks as can fit in the
+ * metadata areas.
+ *
+ * All on disk structures are in little-endian format.  The end
+ * of the exceptions info is indicated by an exception with a
+ * new_chunk of 0, which is invalid since it would point to the
+ * header chunk.
+ */
+
+/*
+ * Magic for persistent snapshots: "SnAp" - Feeble isn't it.
+ */
+#define SNAP_MAGIC 0x70416e53
+
+struct disk_header {
+	uint32_t magic;
+
+	/*
+	 * Is this snapshot valid.  There is no way of recovering
+	 * an invalid snapshot.
+	 */
+	uint32_t valid;
+
+	/*
+	 * Simple, incrementing version. no backward
+	 * compatibility.
+	 */
+	uint32_t version;
+
+	/* In sectors */
+	uint32_t chunk_size;
+
+	/*
+	 * for shared exception
+	 */
+	__le64 root_tree_chunk;
+	__le64 snapmask;	/* Mikulas: don't mix bit_test/set w.r.t. direct reading, it's unportable */
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
+ * The top level structure for a persistent exception store.
+ */
+struct dm_exception_store {
+	struct dm_multisnap *dm;
+
+	void *area;
+
+	struct dm_io_client *io_client;
+
+	unsigned chunk_size;
+	unsigned char chunk_shift;
+
+	int version;
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
+	chunk_t nr_chunks;
+	chunk_t nr_bitmap_chunks;
+	chunk_t nr_journal_chunks;
+	unsigned long *bitmap;
+	chunk_t cur_bitmap_chunk;
+	chunk_t cur_bitmap_index;
+	chunk_t cur_journal_chunk;
+
+	struct list_head chunk_buffer_list;
+	struct list_head chunk_buffer_dirty_list;
+
+	int header_dirty;
+	int nr_chunk_buffers;
+
+	chunk_t chunk_to_add;
+};
+
+static unsigned sectors_to_pages(unsigned sectors)
+{
+	return DIV_ROUND_UP(sectors, PAGE_SIZE >> 9);
+}
+
+static int alloc_area(struct dm_exception_store *ps)
+{
+	int r = -ENOMEM;
+	size_t len;
+
+	len = ps->chunk_size;
+
+	/*
+	 * Allocate the chunk_size block of memory that will hold
+	 * a single metadata area.
+	 */
+	ps->area = vmalloc(len);
+	if (!ps->area)
+		return r;
+
+	return 0;
+}
+
+static void free_area(struct dm_exception_store *ps)
+{
+	vfree(ps->area);
+	ps->area = NULL;
+}
+
+/*
+ * Read or write a chunk aligned and sized block of data from a device.
+ */
+static int chunk_io(struct dm_exception_store *ps, chunk_t chunk, int rw, void *data)
+{
+	struct dm_io_region where = {
+		.bdev = dm_multisnap_snapshot_bdev(ps->dm),
+		.sector = (ps->chunk_size >> SECTOR_SHIFT) * chunk,
+		.count = (ps->chunk_size >> SECTOR_SHIFT),
+	};
+	struct dm_io_request io_req = {
+		.bi_rw = rw,
+		.mem.type = DM_IO_VMA,
+		.mem.ptr.vma = data,
+		.client = ps->io_client,
+		.notify.fn = NULL,
+	};
+
+	int r = dm_io(&io_req, 1, &where, NULL);
+	if (r) {
+		DM_MULTISNAP_SET_ERROR(ps->dm, r, ("io error when %s %llx: %d",
+			rw == WRITE ? "writing" : "reading",
+			(unsigned long long)chunk, r));
+	}
+	return r;
+}
+
+static int write_header(struct dm_exception_store *ps)
+{
+	struct disk_header *dh;
+
+	memset(ps->area, 0, ps->chunk_size);
+
+	dh = (struct disk_header *) ps->area;
+	dh->magic = cpu_to_le32(SNAP_MAGIC);
+	dh->valid = cpu_to_le32(dm_multisnap_drop_on_error(ps->dm) && dm_multisnap_has_error(ps->dm));
+	dh->version = cpu_to_le32(ps->version);
+	dh->chunk_size = cpu_to_le32(ps->chunk_size >> SECTOR_SHIFT);
+
+	dh->root_tree_chunk = cpu_to_le64(ps->root_tree_chunk);
+	dh->snapmask = cpu_to_le64(ps->snapmask);
+	dh->tree_level = cpu_to_le32(ps->tree_level);
+	dh->h_nr_journal_chunks = cpu_to_le32(ps->nr_journal_chunks);
+
+	ps->header_dirty = 0;
+
+	return chunk_io(ps, 0, WRITE, ps->area);
+}
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
+static struct chunk_buffer *alloc_chunk_buffer(struct dm_exception_store *ps)
+{
+	struct chunk_buffer *b;
+
+	/* Mikulas: changed to GFP_NOIO */
+	b = kzalloc(sizeof(*b), GFP_NOIO);
+	if (!b) {
+		DM_MULTISNAP_SET_ERROR(ps->dm, -ENOMEM,
+				       ("%s %d: out of memory", __func__, __LINE__));
+		return NULL;
+	}
+
+	/* Mikulas: must use GFP_NOIO; vmalloc without it may deadlock */
+	b->data = __vmalloc(ps->chunk_size, GFP_NOIO | __GFP_HIGHMEM, PAGE_KERNEL);
+	if (!b->data) {
+		kfree(b);
+		DM_MULTISNAP_SET_ERROR(ps->dm, -ENOMEM,
+				       ("%s %d: out of memory", __func__, __LINE__));
+		return NULL;
+	}
+
+	memset(b->data, 0, ps->chunk_size);
+
+	list_add(&b->list, &ps->chunk_buffer_list);
+	INIT_LIST_HEAD(&b->dirty_list);
+
+	ps->nr_chunk_buffers++;
+
+	return b;
+}
+
+static void free_chunk_buffer(struct dm_exception_store *ps, struct chunk_buffer *b)
+{
+	list_del(&b->list);
+	vfree(b->data);
+	kfree(b);
+
+	ps->nr_chunk_buffers--;
+}
+
+static int read_new_bitmap_chunk(struct dm_exception_store *ps)
+{
+	chunk_io(ps, ps->cur_bitmap_chunk, WRITE, ps->bitmap);
+
+	ps->cur_bitmap_chunk++;
+	if (ps->cur_bitmap_chunk == ps->nr_bitmap_chunks + FIRST_BITMAP_CHUNK /* --- I couldn't get it working without this. I wonder how it ever worked? --- Mikulas */)
+		ps->cur_bitmap_chunk = FIRST_BITMAP_CHUNK;
+
+	chunk_io(ps, ps->cur_bitmap_chunk, READ, ps->bitmap);
+
+	return 0;
+}
+
+static chunk_t shared_allocate_chunk(struct dm_exception_store *ps)
+{
+	/* !!! FIXME: replace multiply/divide/modulo with bit shifts */
+	unsigned idx;
+	unsigned limit;
+	chunk_t start_chunk;
+	unsigned nr_bits = ps->chunk_shift + 3;
+
+	start_chunk = ps->cur_bitmap_chunk;
+again:
+	if (ps->cur_bitmap_chunk == ps->nr_bitmap_chunks && ps->nr_chunks & ((1 << nr_bits) - 1))
+		limit = ps->nr_chunks & ((1 << nr_bits) - 1);
+	else
+		limit = 1 << nr_bits;
+
+	idx = ext2_find_next_zero_bit(ps->bitmap, limit, ps->cur_bitmap_index);
+	if (idx < limit) {
+		ext2_set_bit(idx, ps->bitmap);
+
+		if (idx == limit - 1) {
+			ps->cur_bitmap_index = 0;
+
+			read_new_bitmap_chunk(ps);
+		} else
+			ps->cur_bitmap_index++;
+	} else {
+		/* chunk_io(ps, ps->cur_bitmap_chunk, WRITE, ps->bitmap); don't write it twice -- Mikulas */
+
+		read_new_bitmap_chunk(ps);
+
+		/* todo: check # free chunks */
+		if (start_chunk == ps->cur_bitmap_chunk) {
+			DM_MULTISNAP_SET_ERROR(ps->dm, -ENOSPC, ("%s %d: fail to find a new chunk", __func__, __LINE__));
+			return 0;
+		}
+
+		goto again;
+	}
+
+	return idx + ((ps->cur_bitmap_chunk - FIRST_BITMAP_CHUNK) << nr_bits);
+}
+
+static int shared_free_chunk(struct dm_exception_store *ps, chunk_t chunk)
+{
+	unsigned bits_per_chunk_shift = ps->chunk_shift + 3;
+	unsigned idx = chunk & ((1 << bits_per_chunk_shift) - 1);
+
+	/* we don't always need to do this... */
+	chunk_io(ps, ps->cur_bitmap_chunk, WRITE, ps->bitmap);
+
+	ps->cur_bitmap_chunk = (chunk >> bits_per_chunk_shift) + FIRST_BITMAP_CHUNK;
+
+	chunk_io(ps, ps->cur_bitmap_chunk, READ, ps->bitmap);
+
+	if (!ext2_test_bit(idx, ps->bitmap)) {
+		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+				       ("%s: trying to free free block %lld %lld %u", __func__,
+					(unsigned long long)chunk,
+					(unsigned long long)ps->cur_bitmap_chunk, idx));
+	}
+
+	ext2_clear_bit(idx, ps->bitmap);
+
+	chunk_io(ps, ps->cur_bitmap_chunk, WRITE, ps->bitmap);
+
+	DMINFO("%s %d: free a chunk, %llu", __func__, __LINE__,
+	       (unsigned long long)chunk);
+
+	return 0;
+}
+
+static void init_leaf(struct dm_exception_store *ps, struct leaf *leaf)
+{
+	leaf->magic = cpu_to_le16(0x1eaf);
+	leaf->version = 0;
+	leaf->base_chunk = 0;
+	leaf->count = 0;
+	leaf->map[0].offset = cpu_to_le32(ps->chunk_size);
+}
+
+static struct chunk_buffer *new_btree_obj(struct dm_exception_store *ps)
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
+static int shared_create_bitmap(struct dm_exception_store *ps)
+{
+	int i, r, rest, this;
+	chunk_t chunk;
+
+	/* bitmap + superblock */
+	rest = 1 + ps->nr_bitmap_chunks + ps->nr_journal_chunks;
+
+	for (chunk = 0; chunk < ps->nr_bitmap_chunks; chunk++) {
+		memset(ps->area, 0, ps->chunk_size);
+
+		this = min_t(int, rest, ps->chunk_size * 8);
+		if (this) {
+			rest -= this;
+
+			memset(ps->area, 0xff, this / 8);
+
+			for (i = 0; i < this % 8; i++) {
+				/* Mikulas: this produces unaligned accesses
+				char *p = ps->area + (this / 8);
+				ext2_set_bit(i, (unsigned long *)p);*/
+				ext2_set_bit(this - this % 8 + i, (unsigned long *)ps->area);
+			}
+		}
+
+		r = chunk_io(ps, chunk + FIRST_BITMAP_CHUNK, WRITE,
+			     ps->area);
+		if (r)
+			return r;
+	}
+
+	return 0;
+}
+
+static struct chunk_buffer *new_leaf(struct dm_exception_store *ps)
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
+static struct chunk_buffer *new_node(struct dm_exception_store *ps)
+{
+	return new_btree_obj(ps);
+}
+
+static int shared_create_btree(struct dm_exception_store *ps)
+{
+	struct chunk_buffer *l, *n;
+	int r;
+
+	r = chunk_io(ps, ps->cur_bitmap_chunk, READ, ps->bitmap);
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
+	buffer2node(n)->count = cpu_to_le32(1);
+	buffer2node(n)->entries[0].chunk = cpu_to_le64(l->chunk);
+
+	chunk_io(ps, l->chunk, WRITE, l->data);
+	chunk_io(ps, n->chunk, WRITE, n->data);
+
+	ps->root_tree_chunk = n->chunk;
+	ps->snapmask = 0;
+	ps->tree_level = 1;
+
+	return 0;
+}
+
+static int shared_create_header(struct dm_exception_store *ps)
+{
+	int r;
+
+	/* 128MB by default, should be configurable. */
+	ps->nr_journal_chunks = (128 * 1024 * 1024) / ps->chunk_size;
+
+	/* Mikulas: if the device is smaller than 128MB, we need something smaller */
+	if (ps->nr_journal_chunks > ps->nr_chunks / 8)
+		ps->nr_journal_chunks = ps->nr_chunks / 8;
+
+	r = shared_create_bitmap(ps);
+	if (r)
+		return r;
+
+	r = shared_create_btree(ps);
+	if (r)
+		return r;
+
+	r = write_header(ps);
+	if (r)
+		return r;
+
+	return r;
+}
+
+static int shared_read_header(struct dm_exception_store *ps, int *new_snapshot)
+{
+	struct disk_header *dh;
+	int r;
+
+	ps->io_client = dm_io_client_create(sectors_to_pages(ps->chunk_size >> SECTOR_SHIFT));
+	if (IS_ERR(ps->io_client)) {
+		r = PTR_ERR(ps->io_client);
+		goto fail_io_client;
+	}
+
+	ps->bitmap = vmalloc(ps->chunk_size);
+	if (!ps->bitmap) {
+		r = -ENOMEM;
+		goto fail_bitmap;
+	}
+
+	r = alloc_area(ps);
+	if (r)
+		goto fail_alloc_area;
+
+
+	r = chunk_io(ps, 0, READ, ps->area);
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
+	if (le32_to_cpu(dh->valid))
+		dm_multisnap_set_error(ps->dm, -EINVAL);
+	ps->version = le32_to_cpu(dh->version);
+
+	ps->root_tree_chunk = le64_to_cpu(dh->root_tree_chunk);
+	ps->snapmask = le64_to_cpu(dh->snapmask);
+	ps->tree_level = le32_to_cpu(dh->tree_level);
+	ps->nr_journal_chunks = le32_to_cpu(dh->h_nr_journal_chunks);
+
+	if (ps->chunk_size >> SECTOR_SHIFT != le32_to_cpu(dh->chunk_size)) {
+		DMWARN("Invalid chunk size");
+		r = -ENXIO;
+		goto fail_to_read_header;
+	}
+
+	return 0;
+
+fail_to_read_header:
+	free_area(ps);
+fail_alloc_area:
+	vfree(ps->bitmap);
+	ps->bitmap = NULL;
+fail_bitmap:
+	dm_io_client_destroy(ps->io_client);
+fail_io_client:
+	return r;
+}
+
+static void shared_drop_header(struct dm_exception_store *ps)
+{
+	free_area(ps);
+	vfree(ps->bitmap);
+	ps->bitmap = NULL;
+	dm_io_client_destroy(ps->io_client);
+}
+
+static int shared_read_metadata(struct dm_exception_store *ps, char **error)
+{
+	int i, r, uninitialized_var(new_snapshot);
+	size_t size = i_size_read(dm_multisnap_snapshot_bdev(ps->dm)->bd_inode);
+	chunk_t bitmap_chunk_bytes;
+	unsigned chunk_bytes = ps->chunk_size;
+
+	ps->cur_bitmap_chunk = FIRST_BITMAP_CHUNK;
+	ps->cur_bitmap_index = 0;
+	ps->nr_chunks = size >> ps->chunk_shift;
+
+	INIT_LIST_HEAD(&ps->chunk_buffer_list);
+	INIT_LIST_HEAD(&ps->chunk_buffer_dirty_list);
+	ps->nr_chunk_buffers = 0;
+
+	bitmap_chunk_bytes = DIV_ROUND_UP(ps->nr_chunks, 8);
+	ps->nr_bitmap_chunks = (bitmap_chunk_bytes + chunk_bytes - 1) >> ps->chunk_shift;
+
+	r = shared_read_header(ps, &new_snapshot);
+	if (r) {
+		*error = "Failed to read header";
+		return r;
+	}
+
+	if (new_snapshot)
+		DMINFO("%s %d: creates a new cow device", __func__, __LINE__);
+	else
+		DMINFO("%s %d: loads the cow device", __func__, __LINE__);
+
+	if (new_snapshot) {
+		r = shared_create_header(ps);
+		if (r) {
+			*error = "Failed to create header";
+			goto bad_header;
+		}
+	} else {
+		r = chunk_io(ps, ps->cur_bitmap_chunk, READ, ps->bitmap);
+		if (r) {
+			*error = "Failed to read bitmap";
+			goto bad_header;
+		}
+	}
+
+	for (i = 0; i < MAX_SNAPSHOTS; i++)
+		if (ps->snapmask & 1LL << i)
+			ps->nr_snapshots++;
+
+	return 0;
+
+bad_header:
+	shared_drop_header(ps);
+	return r;
+}
+
+struct etree_path {
+	struct chunk_buffer *buffer;
+	struct index_entry *pnext;
+};
+
+static struct chunk_buffer *btbread(struct dm_exception_store *ps, u64 chunk)
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
+	chunk_io(ps, chunk, READ, b->data);
+
+	return b;
+}
+
+static void brelse(struct chunk_buffer *buffer)
+{
+}
+
+static void brelse_dirty(struct dm_exception_store *ps, struct chunk_buffer *b)
+{
+	if (list_empty(&b->dirty_list))
+		list_add(&b->dirty_list, &ps->chunk_buffer_dirty_list);
+}
+
+static void set_buffer_dirty(struct dm_exception_store *ps, struct chunk_buffer *b)
+{
+	if (list_empty(&b->dirty_list))
+		list_add(&b->dirty_list, &ps->chunk_buffer_dirty_list);
+}
+
+static inline struct exception *emap(struct leaf *leaf, unsigned i)
+{
+	return	(struct exception *)
+		((char *)leaf + le32_to_cpu(leaf->map[i].offset));
+}
+
+static int add_exception_to_leaf(struct leaf *leaf, u64 chunk, u64 exception,
+				 int snapshot, u64 active)
+{
+	unsigned target = chunk - le64_to_cpu(leaf->base_chunk);
+	u64 mask = 1ULL << snapshot, sharemap;
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
+static int add_exception_to_tree(struct dm_exception_store *ps,
+				 struct chunk_buffer *leafbuf,
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
+		int csize = ps->chunk_size;
+		int alloc_per_node = (csize - offsetof(struct node, entries))
+			/ sizeof(struct index_entry);
+
+		if (le32_to_cpu(parent->count) < alloc_per_node) {
+			insert_child(parent, pnext, childsector, childkey);
+			set_buffer_dirty(ps, parentbuf);
+			return 0;
+		}
+		/*
+		 * Split the node.
+		 */
+		half = le32_to_cpu(parent->count) / 2;
+		newkey = le64_to_cpu(parent->entries[half].key);
+		newbuf = new_node(ps);
+		if (!newbuf)
+			return -ENOMEM;
+		set_buffer_dirty(ps, newbuf);
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
+	newroot->count = cpu_to_le32(2);
+	newroot->entries[0].chunk = cpu_to_le64(ps->root_tree_chunk);
+	newroot->entries[1].key = cpu_to_le64(childkey);
+	newroot->entries[1].chunk = cpu_to_le64(childsector);
+	ps->root_tree_chunk = newrootbuf->chunk;
+	ps->tree_level++;
+	ps->header_dirty = 1;
+	brelse_dirty(ps, newrootbuf);
+	return 0;
+}
+
+static struct chunk_buffer *probe(struct dm_exception_store *ps, u64 chunk,
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
+		struct index_entry *pnext = node->entries,
+			*top = pnext + le32_to_cpu(node->count);
+
+		while (++pnext < top)
+			if (le64_to_cpu(pnext->key) > chunk)
+				break;
+
+		path[i].buffer = nodebuf;
+		path[i].pnext = pnext;
+		nodebuf = btbread(ps, le64_to_cpu((pnext - 1)->chunk));
+		if (!nodebuf)
+			return NULL;
+
+		node = (struct node *)nodebuf->data;
+	}
+	BUG_ON(le16_to_cpu(((struct leaf *)nodebuf->data)->magic) != 0x1eaf);
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
+static void remove_index(struct dm_exception_store *ps, struct etree_path path[], int level)
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
+	set_buffer_dirty(ps, path[level].buffer);
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
+static void check_leaf(struct dm_exception_store *ps, struct leaf *leaf, u64 snapmask)
+{
+	struct exception *p;
+	int i;
+
+	for (i = 0; i < le32_to_cpu(leaf->count); i++) {
+		for (p = emap(leaf, i); p < emap(leaf, i+1); p++) {
+			/* !!! should also check for any zero sharemaps here */
+			if (le64_to_cpu(p->share) & snapmask) {
+				DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+						       ("nonzero bits %016llx outside snapmask %016llx",
+							(unsigned long long)p->share,
+							(unsigned long long)snapmask));
+			}
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
+static int delete_snapshots_from_leaf(struct dm_exception_store *ps,
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
+				shared_free_chunk(ps, le64_to_cpu(p->chunk));
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
+	check_leaf(ps, leaf, snapmask);
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
+static void brelse_free(struct dm_exception_store *ps, struct chunk_buffer *buffer)
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
+static int delete_tree_range(struct dm_exception_store *ps, u64 snapmask, chunk_t resume)
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
+					int csize = ps->chunk_size;
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
+					while (levels > 1 &&
+					       le32_to_cpu(path_node(hold, 0)->count) == 1) {
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
+				struct chunk_buffer *nodebuf;
+
+				nodebuf = btbread(ps,
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
+		/* dirty_buffer_count_check(sb); */
+		/*
+		 * Get the leaf indicated in the next index entry in the node
+		 * at this level.
+		 */
+		leafbuf = btbread(ps, le64_to_cpu(path[level].pnext++->chunk));
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
+static int shared_init(struct dm_multisnap *dm, struct dm_exception_store **sp,
+		       unsigned argc, char **argv, char **error)
+{
+	int r;
+	struct dm_exception_store *ps;
+
+	ps = kzalloc(sizeof(struct dm_exception_store), GFP_KERNEL);
+	if (!ps) {
+		*error = "Could not allocate private area";
+		r = -ENOMEM;
+		goto bad_private;
+	}
+	*sp = ps;
+
+	ps->dm = dm;
+	ps->chunk_size = dm_multisnap_chunk_size(dm);
+	ps->chunk_shift = ffs(ps->chunk_size) - 1;
+
+	if (argc != 0) {
+		*error = "Bad number of arguments";
+		r = -EINVAL;
+		goto bad_arguments;
+	}
+
+	if (ps->chunk_size != DM_CHUNK_SIZE_DEFAULT_SECTORS << SECTOR_SHIFT) {
+		*error = "Unsupported chunk size";
+		r = -EINVAL;
+		goto bad_arguments;
+	}
+
+	ps->area = NULL;
+
+	r = shared_read_metadata(ps, error);
+	if (r)
+		goto bad_metadata;
+
+	return 0;
+
+bad_metadata:
+bad_arguments:
+	kfree(ps);
+bad_private:
+	return r;
+}
+
+static void shared_destroy(struct dm_exception_store *ps)
+{
+	struct chunk_buffer *bb, *n;
+
+	list_for_each_entry_safe(bb, n, &ps->chunk_buffer_list, list)
+		free_chunk_buffer(ps, bb);
+
+	shared_drop_header(ps);
+
+	kfree(ps);
+}
+
+static int shared_allocate_snapid(struct dm_exception_store *ps,
+				  snapid_t *snapid, int snap_of_snap, snapid_t master)
+{
+	int i;
+
+	if (snap_of_snap) {
+		DMERR("shared_allocate_snapid: this exception store doesn't support snapshots of snapshots");
+		return -EOPNOTSUPP;
+	}
+
+	for (i = 0; i < MAX_SNAPSHOTS; i++)
+		if (!(ps->snapmask & 1LL << i)) {
+			*snapid = i;
+			return 0;
+		}
+
+	DMERR("shared_allocate_snapid: limit of 64 snapshots reached");
+	return -ENOSPC;
+}
+
+static int shared_create_snapshot(struct dm_exception_store *ps, snapid_t snapid)
+{
+	if (snapid >= MAX_SNAPSHOTS) {
+		DMERR("shared_create_snapshot: invalid snapshot id %llx",
+		      (unsigned long long)snapid);
+		return -EINVAL;
+	}
+	if (ps->snapmask & 1LL << snapid) {
+		DMERR("shared_create_snapshot: snapshot with id %llx already exists",
+		      (unsigned long long)snapid);
+		return -EINVAL;
+	}
+	ps->snapmask |= 1LL << snapid;
+	ps->nr_snapshots++;
+	write_header(ps);
+	return 0;
+}
+
+static void shared_commit(struct dm_exception_store *ps);
+
+static int shared_delete_snapshot(struct dm_exception_store *ps, snapid_t idx)
+{
+	int r;
+
+	if (ps->snapmask & 1LL << idx) {
+		u64 mask;
+		DMINFO("%s %d: delete %uth snapshot.",
+		       __func__, __LINE__, (int)idx);
+
+		mask = 1ULL << idx;
+
+		r = delete_tree_range(ps, mask, 0);
+		if (!r) {
+			ps->snapmask &= ~(1LL << idx);
+			ps->nr_snapshots--;
+		}
+
+		write_header(ps);
+
+		shared_commit(ps);
+	} else {
+		BUG();	/* checked in the caller */
+	}
+
+	return r;
+}
+
+static snapid_t shared_get_next_snapid(struct dm_exception_store *ps, snapid_t snapid)
+{
+	for (; snapid < MAX_SNAPSHOTS; snapid++)
+		if ((ps->snapmask >> snapid) & 1)
+			return snapid;
+	return DM_SNAPID_T_ORIGIN;
+}
+
+static int shared_find_snapshot_chunk(struct dm_exception_store *ps, snapid_t snapid,
+				      chunk_t chunk, int write, chunk_t *result)
+{
+	unsigned levels = ps->tree_level;
+	struct etree_path path[levels + 1];
+	struct chunk_buffer *leafbuf;
+
+	leafbuf = probe(ps, (u64)chunk, path);
+	if (!leafbuf)	/* should make the snapshot invalid */
+		return -1;
+
+	return snapshot_chunk_unique(buffer2leaf(leafbuf), chunk, snapid, result);
+}
+
+static void shared_reset_query(struct dm_exception_store *ps)
+{
+}
+
+static int shared_query_next_remap(struct dm_exception_store *ps, chunk_t chunk)
+{
+	unsigned levels = ps->tree_level;
+	struct etree_path path[levels + 1];
+	struct chunk_buffer *leafbuf;
+
+	leafbuf = probe(ps, (u64)chunk, path);
+	if (!leafbuf)	/* should make the snapshot invalid */
+		return -1;
+
+	ps->chunk_to_add = chunk;
+
+	return !origin_chunk_unique(buffer2leaf(leafbuf), chunk, ps->snapmask);
+}
+
+static void shared_add_next_remap(struct dm_exception_store *ps,
+				  union chunk_descriptor *cd, chunk_t *new_chunk)
+{
+	struct chunk_buffer *cb;
+	struct etree_path path[ps->tree_level + 1];
+	chunk_t chunk = ps->chunk_to_add;
+	int ret;
+
+	/*
+	 * Mikulas: TODO: we could set just bits that we are really relocating.
+	 * But setting more bits won't cause incorrect behavior, it'll just
+	 * temporarily block access to already remapped snapshots.
+	 */
+	cd->bitmask = ps->snapmask;
+
+	cb = probe(ps, chunk, path);
+	if (!cb)
+		return;
+
+	ret = origin_chunk_unique(buffer2leaf(cb), chunk, ps->snapmask);
+	if (ret) {
+		DM_MULTISNAP_SET_ERROR(ps->dm, -EFSERROR,
+				       ("%s %d: bug %llu %d", __func__, __LINE__,
+					(unsigned long long)chunk, ret));
+		return;
+	}
+
+	*new_chunk = shared_allocate_chunk(ps);
+	if (!*new_chunk)
+		return;
+
+	add_exception_to_tree(ps, cb, chunk, *new_chunk, -1, path,
+			      ps->tree_level);
+
+	/*DMINFO("%s %d: allocated new chunk, %llu", __func__, __LINE__,
+	       (unsigned long long)*new_chunk);*/
+}
+
+static int shared_check_conflict(struct dm_exception_store *ps,
+				 union chunk_descriptor *cd, snapid_t snapid)
+{
+	return !!(cd->bitmask & (1LL << snapid));
+}
+
+static void shared_commit(struct dm_exception_store *ps)
+{
+	struct chunk_buffer *b, *n;
+
+	/* Write bitmap */
+	chunk_io(ps, ps->cur_bitmap_chunk, WRITE, ps->bitmap);
+
+	list_for_each_entry_safe(b, n, &ps->chunk_buffer_dirty_list,
+				 dirty_list) {
+
+		list_del_init(&b->dirty_list);
+		list_move_tail(&b->list, &ps->chunk_buffer_list);
+
+		/* todo: can be async */
+		chunk_io(ps, b->chunk, WRITE, b->data);
+	}
+
+	if (ps->header_dirty)
+		write_header(ps);
+
+	list_for_each_entry_safe(b, n, &ps->chunk_buffer_list, list) {
+		if (ps->nr_chunk_buffers < MAX_CHUNK_BUFFERS)
+			break;
+
+		free_chunk_buffer(ps, b);
+	}
+}
+
+struct dm_multisnap_exception_store dm_multisnap_daniel_store = {
+	.name			= "daniel",
+	.module			= THIS_MODULE,
+	.init_exception_store	= shared_init,
+	.exit_exception_store	= shared_destroy,
+	.allocate_snapid	= shared_allocate_snapid,
+	.create_snapshot	= shared_create_snapshot,
+	.delete_snapshot	= shared_delete_snapshot,
+	.get_next_snapid	= shared_get_next_snapid,
+	.find_snapshot_chunk	= shared_find_snapshot_chunk,
+	.reset_query		= shared_reset_query,
+	.query_next_remap	= shared_query_next_remap,
+	.add_next_remap		= shared_add_next_remap,
+	.check_conflict		= shared_check_conflict,
+	.commit			= shared_commit,
+};
+
+static int __init dm_multisnapshot_daniel_module_init(void)
+{
+	return dm_multisnap_register_exception_store(&dm_multisnap_daniel_store);
+}
+
+static void __exit dm_multisnapshot_daniel_module_exit(void)
+{
+	dm_multisnap_unregister_exception_store(&dm_multisnap_daniel_store);
+}
+
+module_init(dm_multisnapshot_daniel_module_init);
+module_exit(dm_multisnapshot_daniel_module_exit);
+
+MODULE_DESCRIPTION(DM_NAME " multisnapshot Fujita/Daniel's exceptions store");
+MODULE_AUTHOR("Fujita Tomonorig, Daniel Phillips");
+MODULE_LICENSE("GPL");
-- 
1.6.5.2
