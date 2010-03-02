From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 03/14] dm-multisnap-mikulas-headers
Date: Mon,  1 Mar 2010 19:23:47 -0500
Message-ID: <1267489438-6271-4-git-send-email-snitzer@redhat.com>
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

Common header files for the exception store.

dm-multisnap-mikulas-struct.h contains on-disk structure definitions.

dm-multisnap-mikulas.h contains in-memory structures and kernel function
prototypes.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-multisnap-mikulas-struct.h |  380 ++++++++++++++++++++++++++++++
 drivers/md/dm-multisnap-mikulas.h        |  247 +++++++++++++++++++
 2 files changed, 627 insertions(+), 0 deletions(-)
 create mode 100644 drivers/md/dm-multisnap-mikulas-struct.h
 create mode 100644 drivers/md/dm-multisnap-mikulas.h

diff --git a/drivers/md/dm-multisnap-mikulas-struct.h b/drivers/md/dm-multisnap-mikulas-struct.h
new file mode 100644
index 0000000..39eaa16
--- /dev/null
+++ b/drivers/md/dm-multisnap-mikulas-struct.h
@@ -0,0 +1,380 @@
+/*
+ * Copyright (C) 2009 Red Hat Czech, s.r.o.
+ *
+ * Mikulas Patocka <mpatocka@redhat.com>
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef DM_MULTISNAP_MIKULAS_STRUCT_H
+#define DM_MULTISNAP_MIKULAS_STRUCT_H
+
+/* on-disk structures */
+
+#include <linux/types.h>
+#include <asm/byteorder.h>
+
+#include "dm-multisnap.h"
+
+/*
+ * Encoding of snapshot numbers:
+ *
+ * If CONFIG_DM_MULTISNAPSHOT_MIKULAS_SNAP_OF_SNAP is not selected (normally it
+ * is), then mikulas_snapid_t is 32-bit sequential number. It continually grows.
+ *
+ * IF CONFIG_DM_MULTISNAPSHOT_MIKULAS_SNAP_OF_SNAP is selected (by default),
+ * then mikulas_snapid_t is 64-bit number. The high 32 bits are sequential
+ * snapshot number. With each new snapshot, it is incremented. The low 32 bits
+ * are subsnapshot number. Single snapshots (snapshots of the origin) have
+ * low 32 bits equal to all ones. Snapshots-of-snapshots have high 32 bits
+ * equal as their master snapshot and low 32 bits start with zero and is
+ * incremented with each new snapshot-of-snapshot.
+ *
+ * More levels (snapshots-of-snapshots-of-snapshots) are not allowed.
+ */
+
+/*
+ *	Description of on-disk format:
+ *
+ * The device is composed of blocks (also called chunks). The block size (also
+ * called chunk size) is specified in the superblock.
+ *
+ * The chunk and block mean the same. "chunk" comes from old snapshots.
+ * "block" comes from filesystems. We tend to use "chunk" in
+ * exception-store-independent code to make it consistent with snapshot
+ * terminology and "block" in exception-store code to make it consistent with
+ * filesystem terminology.
+ *
+ * The minimum block size is 512, the maximum block size is not specified (it is
+ * limited by 32-bit integer size and available memory). All on-disk pointers
+ * are in the units of blocks. The pointers are 48-bit, making this format
+ * capable of handling 2^48 blocks.
+ *
+ * Log-structured update is used, new data are only written to unallocated parts
+ * of the device. By writing a new commit block, these unallocated parts become
+ * allocated and the store makes a transition to the new state. This maintains
+ * data consistency across crashes.
+ *
+ *	Super block
+ *
+ * Chunk 0 is the superblock. It is defined in 'struct multisnap_superblock'.
+ * The superblock contains chunk size, commit block stride, error (if non-zero,
+ * then the exception store is invalid) and pointer to the current commit block.
+ *
+ *	Commit blocks
+ *
+ * Chunks 1, 1+cb_stride, 1+2*cb_stride, 1+3*cb_stride, etc. are commit blocks.
+ * Chunks at these locations ((location % cb_stride) == 1) are only used for
+ * commit blocks, they can't be used for anything else. A commit block is
+ * written each time a new state is committed. The snapshot store transitions
+ * from one consistent state to another consistent state by writing a commit
+ * block.
+ *
+ * All commit blocks must be present and initialized (i.e. have valid signature
+ * and sequence number). They are created when the device is initialized or
+ * extended. It is not allowed to have random uninitialized data in any commit
+ * block.
+ *
+ * For correctness, one commit block would be sufficient --- but to improve
+ * performance and minimize seek times, there are multiple commit blocks and
+ * we use the commit block that is near currently written data.
+ *
+ * The current commit block is stored in the super block. However, updates to
+ * the super block would make excessive disk seeks too, so the updates to super
+ * block are skipped if the commit block is written at the currently valid
+ * commit block or at the next location following the currently valid commit
+ * block. The following algorithm is used to find the commit block at mount:
+ *	1. read the commit block multisnap_superblock->commit_block
+ *	2. get its sequence number
+ *	3. read the next commit block
+ *	4. if the sequence number of the next commit block is higher than
+ *	   the sequence number of the previous block, go to step 3. (i.e. read
+ *	   another commit block)
+ *	5. if the sequence number of the next commit block is lower than
+ *	   the sequence number of the previous block, use the previous block
+ *	   as the most recent valid commit block
+ *
+ * Note: because the disks only support atomic writes of 512 bytes, the commit
+ * block has only 512 bytes of valid data. The remaining data in the commit
+ * block up to the chunk size is unused.
+ *
+ *	B+tree
+ *
+ * To hold the information about reallocated chunks, we use b+tree. The b+tree
+ * leaf entry contains: old chunk (in the origin), new chunk (in the snapshot
+ * store), the range of snapshot IDs for which this mapping applies. The b+tree
+ * is keyed by (old chunk, snapshot ID range). The b+tree node is specified
+ * in 'struct dm_multisnap_bt_node', the b+tree entry is in 'struct
+ * dm_multisnap_bt_entry'. The maximum number of entries in one node is specified
+ * so that the node fits into one chunk.
+ *
+ * The internal nodes have the same structure as the leaf nodes, except that:
+ * Both snapshot ID range entries (snap_from and snap_to) must be equal.
+ * New_chunk is really pointer to the subordinate b+tree node.
+ *
+ * The pointer to the root node and the depth of the b+tree is stored in the
+ * commit block.
+ *
+ *	Snapshot IDs
+ *
+ * We use 64-bit snapshot IDs. The high 32 bits is the number of a snapshot.
+ * This number always increases by one when creating a new snapshot. The
+ * snapshot IDs are never reused. It is expected that the admin won't create
+ * 2^32 snapshots.
+ *
+ * The low 32 bits is the subsnapshot ID and it allows to create snapshots of
+ * snapshots. The store allow holding snapshots of 2 levels --- i.e. master
+ * snapshots (they have all low 32 bits set to 1) and snapshots-of-snapshots
+ * (they have low 32 bits incrementing from 0 to 2^32-1).
+ *
+ * The valid snapshots IDs are stored in the b+tree. Special entries with chunk
+ * number DM_CHUNK_T_SNAP_PRESENT denote the present snapshot IDs. These entries
+ * point to no chunk, instead their presence shows the presence of the specified
+ * snapshot ID.
+ *
+ * When the snapshot is deleted, its entry is removed from the b+tree and the
+ * whole b+tree is scanned on background --- entries whose range doesn't cover
+ * any present snapshot are deleted.
+ *
+ *	Bitmaps
+ *
+ * Free space is managed by bitmaps. Bitmaps are pointed to by a radix-tree.
+ * Each internal node contains 64-bit pointers to subordinate nodes, each leaf
+ * node contains individual bits, '1' meaning allocated and '0' meaning free.
+ * There are no structs defined for the radix tree because the internal node is
+ * just an array of "u64" and the leaf node is just a bit mask.
+ *
+ * The depth of the radix tree is dependent on the device size and chunk size.
+ * The smallest depth that covers the whole device is used. The depth is not
+ * stored on the device, it is calculated with
+ * dm_multisnap_bitmap_depth function.
+ *
+ * The bitmap root is stored in the commit block.
+ * If the depth is 0, this root bitmap contains just individual bits (the device
+ * is so small that its bitmap fits within one chunk), if the depth is 1, the
+ * bitmap root points to a block with 64-bit pointers to individual bitmaps.
+ * If the depth is 2, there are two levels of pointers ... etc.
+ *
+ *	Remaps
+ *
+ * If we wanted to follow the log-structure principle (writing only to
+ * unallocated parts), we would have to always write a new pathway up to the
+ * b+tree root or bitmap root.
+ *
+ * To avoid these multiple writes, remaps are used. There are limited number
+ * of remap entries in the commit block: 27 entries of commit_block_tmp_remap.
+ * Each entry contains (old, new) pair of chunk numbers.
+ *
+ * When we need to update a b+tree block or a bitmap block, we write the new
+ * block to a new location and store the old block and the new block in the
+ * commit block remap. When reading a block, we check if the number is present
+ * in the remap array --- if it is, we read the new location from the remap
+ * instead.
+ *
+ * This way, if we need to update one bitmap or one b+tree block, we don't have
+ * to write the whole path down from the root. Eventually, the remap entries in
+ * the commit block will be exhausted and if this happens, we must free the
+ * remap entries by writing the path from the root.
+ *
+ * The bitmap_idx field in the remap is the index of the bitmap that the
+ * remapped chunk represents or CB_BITMAP_IDX_NONE if it represents a b+tree
+ * node. It is used to construct the path to the root. Bitmaps don't contain
+ * any other data except the bits, so the path must be constructed using this
+ * index. b+tree nodes contain the entries, so the path can be constructed by
+ * looking at the b+tree entries.
+ *
+ * Example: let's have a b+tree with depth 4 and pointers 10 -> 20 -> 30 -> 40.
+ * Now, if we want to change node 40: so write a new version to a chunk 41 and
+ * store the pair (40, 41) into the commit block.
+ * Now, we want to change this node again: so write a new version to a chunk 42
+ * and store the pair (40, 42) into the commit block.
+ * Now, let's do the same operation for other node --- the remap array in the
+ * commit block eventually fills up. When this happens, we expunge (40, 42) map
+ * by writing the path from the root:
+ * copy node 30 to 43, change the pointer from 40 to 42
+ * copy node 20 to 44, change the pointer from 30 to 43
+ * copy node 10 to 45, change the pointer from 20 to 44
+ * change the root pointer from 10 to 45.
+ * Now, the remap entry (40, 42) can be removed from the remap array.
+ *
+ *	Freelist
+ *
+ * Freeing blocks is a bit tricky. If we freed blocks using the log-structured
+ * method, freeing would allocate and free more bitmap blocks, and the whole
+ * thing would get into an infinite loop. So, to free blocks, a different method
+ * is used: freelists.
+ *
+ * We have a 'struct dm_multisnap_freelist' that contains an array of runs of
+ * blocks to free. Each run is the pair (start, length). When we need to free
+ * a block, we add the block to the freelist. We optionally allocate a free
+ * list, if there is no freelist, or if the current freelist is full. If one
+ * freelist is not sufficient, a linked list of freelists is being created.
+ * In the commit we write the freelist location to the commit block and after
+ * the commit, we free individual bits in the bitmaps. If the computer crashes
+ * during freeing the bits we just free the bits again on next mount.
+ */
+
+#ifndef CONFIG_DM_MULTISNAPSHOT_MIKULAS_SNAP_OF_SNAP
+typedef __u32 mikulas_snapid_t;
+#define DM_MIKULAS_SNAPID_STEP_BITS	0
+#define mikulas_snapid_to_cpu		le32_to_cpu
+#define cpu_to_mikulas_snapid		cpu_to_le32
+#else
+typedef __u64 mikulas_snapid_t;
+#define DM_MIKULAS_SNAPID_STEP_BITS	32
+#define mikulas_snapid_to_cpu		le64_to_cpu
+#define cpu_to_mikulas_snapid		cpu_to_le64
+#endif
+
+#define DM_MIKULAS_SUBSNAPID_MASK (((mikulas_snapid_t)1 << DM_MIKULAS_SNAPID_STEP_BITS) - 1)
+#define DM_SNAPID_T_LAST	((mikulas_snapid_t)0xffffffffffffffffULL)
+#define DM_SNAPID_T_MAX		((mikulas_snapid_t)0xfffffffffffffffeULL)
+
+#define DM_CHUNK_BITS		48
+#define DM_CHUNK_T_LAST		((chunk_t)(1LL << DM_CHUNK_BITS) - 1)
+#define DM_CHUNK_T_SNAP_PRESENT	((chunk_t)(1LL << DM_CHUNK_BITS) - 1)
+#define DM_CHUNK_T_MAX		((chunk_t)(1LL << DM_CHUNK_BITS) - 2)
+
+#define CB_STRIDE_DEFAULT	1024
+
+#define SB_BLOCK	0
+
+#define SB_SIGNATURE	cpu_to_be32(0xF6015342)
+
+struct multisnap_superblock {
+	__u32 signature;
+	__u32 chunk_size;
+	__u32 cb_stride;
+	__s32 error;
+	__u64 commit_block;
+};
+
+
+#define FIRST_CB_BLOCK	1
+
+#define CB_SIGNATURE	cpu_to_be32(0xF6014342)
+
+struct commit_block_tmp_remap {
+	__u32 old1;
+	__u16 old2;
+	__u16 new2;
+	__u32 new1;
+	__u32 bitmap_idx;	/* CB_BITMAP_IDX_* */
+};
+
+#define CB_BITMAP_IDX_MAX	0xfffffffd
+#define CB_BITMAP_IDX_NONE	0xfffffffe
+
+#define N_REMAPS	27
+
+struct multisnap_commit_block {
+	__u32 signature;
+	__u32 snapshot_num;	/* new snapshot number to allocate */
+	__u64 sequence;		/* a sequence, increased with each commit */
+
+	__u32 dev_size1;	/* total size of the device in chunks */
+	__u16 dev_size2;
+	__u16 total_allocated2;	/* total allocated chunks */
+	__u32 total_allocated1;
+	__u32 data_allocated1;	/* chunks allocated for data */
+
+	__u16 data_allocated2;
+	__u16 bitmap_root2;	/* bitmap root */
+	__u32 bitmap_root1;
+	__u32 alloc_rover1;	/* the next place where to try allocation */
+	__u16 alloc_rover2;
+	__u16 freelist2;	/* pointer to dm_multisnap_freelist */
+
+	__u32 freelist1;
+	__u32 delete_rover1;	/* an index in the btree where to continue */
+	__u16 delete_rover2;	/* searching for data to delete */
+	__u16 bt_root2;		/* btree root chunk */
+	__u32 bt_root1;
+
+	__u8 bt_depth;		/* depth of the btree */
+	__u8 flags;		/* DM_MULTISNAP_FLAG_* */
+	__u8 pad[14];
+
+	struct commit_block_tmp_remap tmp_remap[N_REMAPS];
+};
+
+#define DM_MULTISNAP_FLAG_DELETING		0x01
+#define DM_MULTISNAP_FLAG_PENDING_DELETE	0x02
+
+#define MAX_BITMAP_DEPTH		6
+
+static inline int dm_multisnap_bitmap_depth(unsigned chunk_shift, __u64 device_size)
+{
+	unsigned depth = 0;
+	__u64 entries = 8 << chunk_shift;
+	while (entries < device_size) {
+		depth++;
+		entries <<= chunk_shift - 3;
+		if (!entries)
+			return -ERANGE;
+	}
+
+	if (depth > MAX_BITMAP_DEPTH)
+		return -ERANGE;
+
+	return depth;
+}
+
+
+/* B+-tree entry. Sorted by orig_chunk and snap_from/to */
+
+#define MAX_BT_DEPTH		12
+
+struct dm_multisnap_bt_entry {
+	__u32 orig_chunk1;
+	__u16 orig_chunk2;
+	__u16 new_chunk2;
+	__u32 new_chunk1;
+	__u32 flags;
+	mikulas_snapid_t snap_from;
+	mikulas_snapid_t snap_to;
+};
+
+#define BT_SIGNATURE	cpu_to_be32(0xF6014254)
+
+struct dm_multisnap_bt_node {
+	__u32 signature;
+	__u32 n_entries;
+	struct dm_multisnap_bt_entry entries[0];
+};
+
+static inline unsigned dm_multisnap_btree_entries(unsigned chunk_size)
+{
+	return (chunk_size - sizeof(struct dm_multisnap_bt_node)) /
+		sizeof(struct dm_multisnap_bt_entry);
+}
+
+
+/* Freelist */
+
+struct dm_multisnap_freelist_entry {
+	__u32 block1;
+	__u16 block2;
+	__u16 run_length;		/* FREELIST_* */
+};
+
+#define FREELIST_RL_MASK	0x7fff	/* Run length */
+#define FREELIST_DATA_FLAG	0x8000	/* Represents a data block */
+
+#define FL_SIGNATURE	cpu_to_be32(0xF601464C)
+
+struct dm_multisnap_freelist {
+	__u32 signature;
+	__u32 backlink1;
+	__u16 backlink2;
+	__u32 n_entries;
+	struct dm_multisnap_freelist_entry entries[0];
+};
+
+static inline unsigned dm_multisnap_freelist_entries(unsigned chunk_size)
+{
+	return (chunk_size - sizeof(struct dm_multisnap_freelist)) /
+		sizeof(struct dm_multisnap_freelist);
+}
+
+#endif
diff --git a/drivers/md/dm-multisnap-mikulas.h b/drivers/md/dm-multisnap-mikulas.h
new file mode 100644
index 0000000..52c87e0
--- /dev/null
+++ b/drivers/md/dm-multisnap-mikulas.h
@@ -0,0 +1,247 @@
+/*
+ * Copyright (C) 2009 Red Hat Czech, s.r.o.
+ *
+ * Mikulas Patocka <mpatocka@redhat.com>
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef DM_MULTISNAP_MIKULAS_H
+#define DM_MULTISNAP_MIKULAS_H
+
+/*
+ * This can be optionally undefined to get 32-bit snapshot numbers.
+ * Breaks on-disk format compatibility.
+ */
+#define CONFIG_DM_MULTISNAPSHOT_MIKULAS_SNAP_OF_SNAP
+
+#include "dm-multisnap.h"
+#include "dm-multisnap-mikulas-struct.h"
+
+#include "dm-bufio.h"
+
+#include <linux/vmalloc.h>
+
+typedef __u32 bitmap_t;
+
+#define read_48(struc, entry)		(le32_to_cpu((struc)->entry##1) |\
+					 ((chunk_t)le16_to_cpu((struc)->entry##2) << 31 << 1))
+
+#define write_48(struc, entry, val)	do { (struc)->entry##1 = cpu_to_le32(val); \
+		(struc)->entry##2 = cpu_to_le16((chunk_t)(val) >> 31 >> 1); } while (0)
+
+#define TMP_REMAP_HASH_SIZE		256
+#define TMP_REMAP_HASH(c)		((c) & (TMP_REMAP_HASH_SIZE - 1))
+
+#define UNCOMMITTED_BLOCK_HASH_SIZE	256
+#define UNCOMMITTED_BLOCK_HASH(c)	((c) & (UNCOMMITTED_BLOCK_HASH_SIZE - 1))
+
+struct tmp_remap {
+	/* List entry for tmp_remap */
+	struct hlist_node hash_list;
+	/* List entry for used_tmp_remaps/free_tmp_remaps */
+	struct list_head list;
+	chunk_t old;
+	chunk_t new;
+	bitmap_t bitmap_idx;
+	int uncommitted;
+};
+
+struct bt_key {
+	chunk_t chunk;
+	mikulas_snapid_t snap_from;
+	mikulas_snapid_t snap_to;
+};
+
+struct path_element {
+	chunk_t block;
+	unsigned idx;
+	unsigned n_entries;
+};
+
+struct dm_exception_store {
+	struct dm_multisnap *dm;
+	struct dm_bufio_client *bufio;
+
+	chunk_t dev_size;
+	unsigned chunk_size;
+	unsigned char chunk_shift;
+	unsigned char bitmap_depth;
+	unsigned btree_entries;
+	__u8 bt_depth;
+	__u8 flags;
+	__u32 snapshot_num;
+	unsigned cb_stride;
+
+	chunk_t bitmap_root;
+	chunk_t alloc_rover;
+	chunk_t bt_root;
+	chunk_t sb_commit_block;
+	chunk_t valid_commit_block;
+	chunk_t delete_rover_chunk;
+	mikulas_snapid_t delete_rover_snapid;
+
+	chunk_t total_allocated;
+	chunk_t data_allocated;
+
+	__u64 commit_sequence;
+
+	void *tmp_chunk;
+
+	struct rb_root active_snapshots;
+
+	/* Used during query/add remap */
+	chunk_t query_snapid;
+	struct bt_key query_new_key;
+	unsigned char query_active;
+	chunk_t query_block_from;
+	chunk_t query_block_to;
+
+	/* List heads for struct tmp_remap->list */
+	unsigned n_used_tmp_remaps;
+	struct list_head used_bitmap_tmp_remaps;
+	struct list_head used_bt_tmp_remaps;
+	struct list_head free_tmp_remaps;
+	/* List head for struct tmp_remap->hash_list */
+	struct hlist_head tmp_remap[TMP_REMAP_HASH_SIZE];
+	struct tmp_remap tmp_remap_store[N_REMAPS];
+
+	unsigned n_preallocated_blocks;
+	chunk_t preallocated_blocks[MAX_BITMAP_DEPTH * 2];
+
+	struct dm_multisnap_freelist *freelist;
+	chunk_t freelist_ptr;
+
+	struct dm_multisnap_background_work delete_work;
+	unsigned delete_commit_count;
+
+	__u64 cache_threshold;
+	__u64 cache_limit;
+
+	struct hlist_head uncommitted_blocks[UNCOMMITTED_BLOCK_HASH_SIZE];
+};
+
+/* dm-multisnap-alloc.c */
+
+void dm_multisnap_create_bitmaps(struct dm_exception_store *s, chunk_t *writing_block);
+void dm_multisnap_extend_bitmaps(struct dm_exception_store *s, chunk_t new_size);
+void *dm_multisnap_map_bitmap(struct dm_exception_store *s, bitmap_t bitmap,
+			      struct dm_buffer **bp, chunk_t *block,
+			      struct path_element *path);
+int dm_multisnap_alloc_blocks(struct dm_exception_store *s, chunk_t *results,
+			      unsigned n_blocks, int flags);
+#define ALLOC_DRY	1
+void *dm_multisnap_alloc_duplicate_block(struct dm_exception_store *s, chunk_t block,
+					 struct dm_buffer **bp, void *ptr);
+void *dm_multisnap_alloc_make_block(struct dm_exception_store *s, chunk_t *result,
+				    struct dm_buffer **bp);
+void dm_multisnap_free_blocks_immediate(struct dm_exception_store *s, chunk_t block,
+					unsigned n_blocks);
+void dm_multisnap_bitmap_finalize_tmp_remap(struct dm_exception_store *s,
+					    struct tmp_remap *tmp_remap);
+
+/* dm-multisnap-blocks.c */
+
+chunk_t dm_multisnap_remap_block(struct dm_exception_store *s, chunk_t block);
+void *dm_multisnap_read_block(struct dm_exception_store *s, chunk_t block,
+			      struct dm_buffer **bp);
+int dm_multisnap_block_is_uncommitted(struct dm_exception_store *s, chunk_t block);
+void dm_multisnap_block_set_uncommitted(struct dm_exception_store *s, chunk_t block);
+void dm_multisnap_clear_uncommitted(struct dm_exception_store *s);
+void *dm_multisnap_duplicate_block(struct dm_exception_store *s, chunk_t old_chunk,
+				   chunk_t new_chunk, bitmap_t bitmap_idx,
+				   struct dm_buffer **bp, chunk_t *to_free);
+void dm_multisnap_free_tmp_remap(struct dm_exception_store *s, struct tmp_remap *t);
+void *dm_multisnap_make_block(struct dm_exception_store *s, chunk_t new_chunk,
+			      struct dm_buffer **bp);
+void dm_multisnap_free_block_and_duplicates(struct dm_exception_store *s,
+					    chunk_t block);
+
+int dm_multisnap_is_commit_block(struct dm_exception_store *s, chunk_t block);
+
+struct stop_cycles {
+	chunk_t key;
+	__u64 count;
+};
+
+void dm_multisnap_init_stop_cycles(struct stop_cycles *cy);
+int dm_multisnap_stop_cycles(struct dm_exception_store *s,
+			     struct stop_cycles *cy, chunk_t key);
+
+/* dm-multisnap-btree.c */
+
+void dm_multisnap_create_btree(struct dm_exception_store *s, chunk_t *writing_block);
+int dm_multisnap_find_in_btree(struct dm_exception_store *s, struct bt_key *key,
+			       chunk_t *result);
+void dm_multisnap_add_to_btree(struct dm_exception_store *s, struct bt_key *key,
+			       chunk_t new_chunk);
+void dm_multisnap_restrict_btree_entry(struct dm_exception_store *s, struct bt_key *key);
+void dm_multisnap_extend_btree_entry(struct dm_exception_store *s, struct bt_key *key);
+void dm_multisnap_delete_from_btree(struct dm_exception_store *s, struct bt_key *key);
+void dm_multisnap_bt_finalize_tmp_remap(struct dm_exception_store *s,
+					struct tmp_remap *tmp_remap);
+int dm_multisnap_list_btree(struct dm_exception_store *s, struct bt_key *key,
+			    int (*call)(struct dm_exception_store *,
+					struct dm_multisnap_bt_node *,
+					struct dm_multisnap_bt_entry *, void *),
+			    void *cookie);
+
+/* dm-multisnap-commit.c */
+
+void dm_multisnap_transition_mark(struct dm_exception_store *s);
+void dm_multisnap_prepare_for_commit(struct dm_exception_store *s);
+void dm_multisnap_commit(struct dm_exception_store *s);
+
+/* dm-multisnap-delete.c */
+
+void dm_multisnap_background_delete(struct dm_exception_store *s,
+				    struct dm_multisnap_background_work *bw);
+
+/* dm-multisnap-freelist.c */
+
+void dm_multisnap_init_freelist(struct dm_multisnap_freelist *fl, unsigned chunk_size);
+void dm_multisnap_free_block(struct dm_exception_store *s, chunk_t block, unsigned flags);
+int dm_multisnap_check_allocated_block(struct dm_exception_store *s, chunk_t block);
+void dm_multisnap_flush_freelist_before_commit(struct dm_exception_store *s);
+void dm_multisnap_load_freelist(struct dm_exception_store *s);
+
+/* dm-multisnap-io.c */
+
+int dm_multisnap_find_snapshot_chunk(struct dm_exception_store *s, snapid_t snapid,
+				     chunk_t chunk, int write, chunk_t *result);
+void dm_multisnap_reset_query(struct dm_exception_store *s);
+int dm_multisnap_query_next_remap(struct dm_exception_store *s, chunk_t chunk);
+void dm_multisnap_add_next_remap(struct dm_exception_store *s,
+				 union chunk_descriptor *cd, chunk_t *new_chunk);
+void dm_multisnap_make_chunk_writeable(struct dm_exception_store *s,
+				       union chunk_descriptor *cd, chunk_t *new_chunk);
+int dm_multisnap_check_conflict(struct dm_exception_store *s, union chunk_descriptor *cd,
+				snapid_t snapid);
+
+/* dm-multisnap-snaps.c */
+
+snapid_t dm_multisnap_get_next_snapid(struct dm_exception_store *s, snapid_t snapid);
+int dm_multisnap_compare_snapids_for_create(const void *p1, const void *p2);
+int dm_multisnap_find_next_snapid_range(struct dm_exception_store *s, snapid_t snapid,
+					snapid_t *from, snapid_t *to);
+snapid_t dm_multisnap_find_next_subsnapshot(struct dm_exception_store *s, snapid_t snapid);
+
+void dm_multisnap_destroy_snapshot_tree(struct dm_exception_store *s);
+void dm_multisnap_read_snapshots(struct dm_exception_store *s);
+int dm_multisnap_allocate_snapid(struct dm_exception_store *s, snapid_t *snapid,
+				 int snap_of_snap, snapid_t master);
+int dm_multisnap_create_snapshot(struct dm_exception_store *s, snapid_t snapid);
+int dm_multisnap_delete_snapshot(struct dm_exception_store *s, snapid_t snapid);
+
+void dm_multisnap_get_space(struct dm_exception_store *s, unsigned long long *chunks_total,
+			    unsigned long long *chunks_allocated,
+			    unsigned long long *chunks_metadata_allocated);
+
+#ifdef CONFIG_DM_MULTISNAPSHOT_MIKULAS_SNAP_OF_SNAP
+void dm_multisnap_print_snapid(struct dm_exception_store *s, char *string,
+			       unsigned maxlen, snapid_t snapid);
+int dm_multisnap_read_snapid(struct dm_exception_store *s, char *string,
+			     snapid_t *snapid, char **error);
+#endif
+
+#endif
-- 
1.6.5.2
