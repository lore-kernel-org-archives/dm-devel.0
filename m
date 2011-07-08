From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3/3] dm thin: thin provisioning target
Date: Fri,  8 Jul 2011 18:19:52 -0400
Message-ID: <1310163592-29683-4-git-send-email-snitzer@redhat.com>
References: <1310163592-29683-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1310163592-29683-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, Joe Thornber <thornber@redhat.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, Dave Chinner <dchinner@redhat.com>
List-Id: dm-devel.ids

From: Joe Thornber <thornber@redhat.com>

Initial EXPERIMENTAL implementation of device-mapper thin provisioning
with snapshot support.  The 'thin' target is used to create instances of
the virtual devices that are hosted in the 'thin-pool' target.  The
thin-pool target provides data sharing among devices.  This sharing is
made possible via the new persistent-data library.

The main highlight of this implementation, compared to the previous
implementation of snapshots, is it allows many virtual devices to be
stored on the same data volume.  Simplifying administration and
allowing sharing of data between volumes (thus reducing disk usage).

Another big feature is support for arbitrary depth of recursive
snapshots (snapshots of snapshots of snapshots ...).  The previous
implementation of snapshots did this by chaining together lookup
tables, and so performance was O(depth).  This new implementation uses
a single data structure so we won't get this degradation with depth
(fragmentation may be an issue however in some scenarios).

Metadata is stored on a separate device from data, this gives the
administrator a bit more freedom.  For instance:

- Improve metadata resilience by storing metadata on a mirrored volume
  but data on a non-mirrored one.

- Improve performance by storing the metadata on an SSD.

Please see: Documentation/device-mapper/thin-provisioning.txt

Signed-off-by: Joe Thornber <thornber@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 Documentation/device-mapper/thin-provisioning.txt |  248 +++
 drivers/md/Kconfig                                |    8 +
 drivers/md/Makefile                               |    3 +
 drivers/md/dm-thin-metadata.c                     | 1281 ++++++++++++
 drivers/md/dm-thin-metadata.h                     |  164 ++
 drivers/md/dm-thin.c                              | 2204 +++++++++++++++++++++
 6 files changed, 3908 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/device-mapper/thin-provisioning.txt
 create mode 100644 drivers/md/dm-thin-metadata.c
 create mode 100644 drivers/md/dm-thin-metadata.h
 create mode 100644 drivers/md/dm-thin.c

diff --git a/Documentation/device-mapper/thin-provisioning.txt b/Documentation/device-mapper/thin-provisioning.txt
new file mode 100644
index 0000000..ad971cf
--- /dev/null
+++ b/Documentation/device-mapper/thin-provisioning.txt
@@ -0,0 +1,248 @@
+Introduction
+============
+
+This document descibes a collection of device-mapper targets that
+between them implement thin provisioning and snapshots.
+
+The main highlight of this implementation, compared to the previous
+implementation of snapshots, is it allows many virtual devices to be
+stored on the same data volume.  Simplifying administration and
+allowing sharing of data between volumes (thus reducing disk usage).
+
+Another big feature is support for arbitrary depth of recursive
+snapshots (snapshots of snapshots of snapshots ...).  The previous
+implementation of snapshots did this by chaining together lookup
+tables, and so performance was O(depth).  This new implementation uses
+a single data structure so we won't get this degradation with depth
+(fragmentation may be an issue however in some scenarios).
+
+Metadata is stored on a separate device from data, this gives the
+administrator a bit more freedom.  For instance:
+
+- Improve metadata resilience by storing metadata on a mirrored volume
+  but data on a non-mirrored one.
+
+- Improve performance by storing the metadata on an SSD.
+
+
+Status
+======
+
+These targets are very much in the EXPERIMENTAL state.  Do not use in
+production.
+
+_Do_ experiment with it and give us feedback.  Different use cases
+will have different performance characteristics (for example due to
+fragmentation of the data volume).  If you find this software is not
+performing as expected please mail dm-devel@redhat.com with details and
+we'll try our best to improve things for you.
+
+
+Cookbook
+========
+
+This section describes some quick recipes for using thin provisioning
+using the dmsetup program to control the device-mapper driver
+directly.  End users are advised to use a higher level volume manager
+such as LVM2.
+
+
+Pool device
+-----------
+
+The pool device ties together the metadata volume and the data volume.
+It linearly maps to the data volume, and updates the metadata via two
+mechanisms:
+
+- Function calls from the thin targets
+
+- device-mapper 'messages' from userland which control creation of new
+  virtual devices among other things.
+
+
+Setting up a fresh pool device
+------------------------------
+
+Setting up a pool device requires a _valid_ metadata device, and a
+data device.  If you do not have an existing metadata device you can
+make one by zeroing the first 4k to indicate empty metadata.
+
+    dd if=/dev/zero of=$metadata_dev bs=4096 count=1
+
+Reloading a pool table
+----------------------
+
+You may reload a pool's table, indeed this is how the pool is resized
+if it runs out of space.  Its advisable that you reload with a pool
+target that points to the same metadata area.
+
+
+Using an existing pool device
+-----------------------------
+
+    dmsetup create pool --table "0 20971520 thin-pool $metadata_dev $data_dev $data_block_size $low_water_mark"
+
+The $data_block_size gives the smallest unit of disk space that can be
+allocated at a time.  This is expressed in 512 byte sectors.  People
+primarily interested in thin provisioning may want to set this larger
+(e.g., 1024).  People doing lots of snapshotting may want it smaller
+(e.g., 128).  $data_block_size must be the same for the lifetime of
+the metadata device.
+
+The $low_water_mark is expressed in 512 byte sectors, if free space on
+the data device drops below this level then a dm event will be sent to
+userland which should extend the pool device.
+
+
+Thin provisioning
+-----------------
+
+i) Creating a new thinly provisioned volume
+
+  To create a new thin provision volume you must send a message to an
+  active pool device.
+
+    dmsetup message /dev/mapper/pool 0 "new-thin 0"
+
+  Here '0' is an identifier for the volume (32bit range).  It's up to
+  the caller to allocate and manage these identifiers.  If there's a
+  collision the message will fail.
+
+ii) Using a thinp volume
+
+  Thin provisioned volumes are instanced using the 'thin' target.
+
+    dmsetup create thin --table "0 2097152 thin /dev/mapper/pool 0"
+
+  The last parameter is the 32bit identifier for the thinp device.
+
+
+Internal snapshots
+------------------
+
+i) Creating an internal snapshot
+
+  Snapshots are created with another message to the pool.
+
+  You _must_ suspend the origin device before creating the snapshot.
+  If the origin hasn't been instanced via the 'thin' target then you
+  may proceed without doing anything.
+
+    dmsetup suspend /dev/mapper/thin
+    dmsetup message /dev/mapper/pool 0 "new-snap 1 0"
+    dmsetup resume /dev/mapper/thin
+
+  Here '1' is an identifier for the volume (32bit range).  '0' is the
+  identifier for the origin device.
+
+ii) Using an internal snapshot
+
+  Once created, the user doesn't have to worry about any connection
+  between the origin and the snapshot.  Indeed the snapshot is no
+  different from any other thinly provisioned device, and can be
+  snapshotted itself via the same method.  It's perfectly legal to
+  have only one of them active, and there's no ordering requirement on
+  activating/removing them both.
+
+  Activate exactly the same way as any other thin provisioned volume.
+
+    dmsetup create snap --table "0 2097152 thin /dev/mapper/pool 1"
+
+Teardown
+--------
+
+Always teardown the pool last.
+
+    dmsetup remove thin
+    dmsetup remove snap
+    dmsetup remove pool
+
+
+Reference
+=========
+
+'thin-pool' target
+------------------
+
+i) Constructor
+
+ thin-pool <metadata dev>
+           <data dev>
+           <data block size in sectors>
+           <low water mark (sectors)>
+	   [number of feature args> [<arg>]*]
+
+ optional feature args:
+   - 'skip_block_zeroing': skips the zeroing of newly provisioned blocks
+
+ii) Status
+
+   <transaction id> <data free space in sectors> <metadata free space in sectors> <held metadata root>
+
+  where,
+
+    - transaction id: A 64bit number used by userland to help
+      synchronise with metadata from volume managers.
+
+    - held metadata root: The location, in sectors, of the metadata
+      root that has been 'held' for userland read access.  '-'
+      indicates there is no held root.
+
+    - data free space in sectors: If this drops below the pool's low
+      water mark a dm event will be sent to userland.  This event is
+      edge triggered, it will occur only once, so volume manager
+      writers should register for the event, then double check the
+      status of the target.
+
+iii) Messages
+
+ new-thin <dev id>
+
+   Create a new thin provisioned device.  <dev id> is an arbitrary
+   unique 32 bit number, chosen by the caller.
+
+ new-snap <dev id> <origin id>
+
+   Create a new snapshot of another thin device.  <origin id> is the
+   dev id of the thin dev that you wish to snap.
+
+ del      <dev id>
+
+   Deletes a thin device.  Irreversible.
+
+ trim     <dev id> <new size in sectors>
+
+   Delete mappings from the back of a thin device.  Irreversible.  You
+   might want to do this if you're shrinking the size of your thin
+   device.
+
+ trans-id <current id> <new id>
+
+   Userland volume managers, such as LVM, need a way to synchonise
+   their external metadata with the internal metadata of the pool
+   target.  The minimal facilities that pool provides is offering to
+   store a 64bit transaction id (which is available on the pool
+   targets status line).  To avoid races you must provide what you
+   think the current transaction id is when you change it (compare and
+   swap).
+
+'thin' target
+-------------
+
+ thin <pool dev> <dev id>
+
+ pool dev: the path to the pool (eg, /dev/mapper/my_pool)
+ dev id: the internal device identifier (32bit value)
+
+ The pool doesn't store any size against the thin devices.  If you
+ load a thin target that is smaller than you've been using previously,
+ then you wont be able to access mapped blocks beyond the end.  If
+ load a target that is bigger than previously used, then extra blocks
+ will be provisioned as and when needed.
+
+ If you wish to shrink your thin device and potentially regain some
+ data blocks then use the 'trim' message to the pool.
+
+i) Status
+
+ <nr mapped sectors> <highest mapped sector>
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 8420129..02518b3 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -208,6 +208,8 @@ config DM_DEBUG
 
 	  If unsure, say N.
 
+source "drivers/md/persistent-data/Kconfig"
+
 config DM_CRYPT
 	tristate "Crypt target support"
 	depends on BLK_DEV_DM
@@ -233,6 +235,12 @@ config DM_SNAPSHOT
        ---help---
          Allow volume managers to take writable snapshots of a device.
 
+config DM_THIN_PROVISIONING
+       tristate "Thin provisioning target (EXPERIMENTAL)"
+       depends on BLK_DEV_DM && DM_PERSISTENT_DATA && EXPERIMENTAL
+       ---help---
+         Provides thin provisioning and snapshots that share a data store.
+
 config DM_MIRROR
        tristate "Mirror target"
        depends on BLK_DEV_DM
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 448838b..8e7aac7 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -10,6 +10,7 @@ dm-snapshot-y	+= dm-snap.o dm-exception-store.o dm-snap-transient.o \
 dm-mirror-y	+= dm-raid1.o
 dm-log-userspace-y \
 		+= dm-log-userspace-base.o dm-log-userspace-transfer.o
+dm-thinp-y	+= dm-thin.o dm-thin-metadata.o
 md-mod-y	+= md.o bitmap.o
 raid456-y	+= raid5.o
 
@@ -34,10 +35,12 @@ obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
 obj-$(CONFIG_DM_MULTIPATH_QL)	+= dm-queue-length.o
 obj-$(CONFIG_DM_MULTIPATH_ST)	+= dm-service-time.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
+obj-$(CONFIG_DM_PERSISTENT_DATA)	+= persistent-data/
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-region-hash.o
 obj-$(CONFIG_DM_LOG_USERSPACE)	+= dm-log-userspace.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
 obj-$(CONFIG_DM_RAID)	+= dm-raid.o
+obj-$(CONFIG_DM_THIN_PROVISIONING)	+= dm-thinp.o
 
 ifeq ($(CONFIG_DM_UEVENT),y)
 dm-mod-objs			+= dm-uevent.o
diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
new file mode 100644
index 0000000..bf4d937
--- /dev/null
+++ b/drivers/md/dm-thin-metadata.c
@@ -0,0 +1,1281 @@
+/*
+ * Copyright (C) 2011 Red Hat, Inc. All rights reserved.
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm-thin-metadata.h"
+#include "persistent-data/dm-transaction-manager.h"
+#include "persistent-data/dm-space-map-disk.h"
+
+#include <linux/list.h>
+#include <linux/device-mapper.h>
+#include <linux/workqueue.h>
+
+/*----------------------------------------------------------------*/
+
+#define DM_MSG_PREFIX   "thin-metadata"
+
+#define THIN_SUPERBLOCK_MAGIC 27022010
+#define THIN_SUPERBLOCK_LOCATION 0
+#define THIN_VERSION 1
+#define THIN_METADATA_BLOCK_SIZE 4096
+#define THIN_METADATA_CACHE_SIZE 64
+#define SECTOR_TO_BLOCK_SHIFT 3
+
+/* This should be plenty */
+#define SPACE_MAP_ROOT_SIZE 128
+
+struct thin_super_block {
+	__le32 csum;
+	__le32 flags;
+	__le64 blocknr; /* this block number, dm_block_t */
+
+	__u8 uuid[16]; /* uuid_t */
+	__le64 magic;
+	__le32 version;
+	__le32 time;
+
+	__le64 trans_id;
+	/* root for userspace's transaction (for migration and friends) */
+	__le64 held_root;
+
+	__u8 data_space_map_root[SPACE_MAP_ROOT_SIZE];
+	__u8 metadata_space_map_root[SPACE_MAP_ROOT_SIZE];
+
+	/* 2 level btree mapping (dev_id, (dev block, time)) -> data block */
+	__le64 data_mapping_root;
+
+	/* device detail root mapping dev_id -> device_details */
+	__le64 device_details_root;
+
+	__le32 data_block_size;	/* in 512-byte sectors */
+
+	__le32 metadata_block_size; /* in 512-byte sectors */
+	__le64 metadata_nr_blocks;
+
+	__le32 compat_flags;
+	__le32 compat_ro_flags;
+	__le32 incompat_flags;
+} __packed;
+
+struct device_details {
+	__le64 mapped_blocks;
+	__le64 transaction_id;	/* when created */
+	__le32 creation_time;
+	__le32 snapshotted_time;
+} __packed;
+
+struct dm_thin_metadata {
+	struct hlist_node hash;
+
+	struct block_device *bdev;
+	struct dm_block_manager *bm;
+	struct dm_space_map *metadata_sm;
+	struct dm_space_map *data_sm;
+	struct dm_transaction_manager *tm;
+	struct dm_transaction_manager *nb_tm;
+
+	/*
+	 * Two level btree, first level is thin_dev_t, second level
+	 * mappings.
+	 */
+	struct dm_btree_info info;
+
+	/* non-blocking version of the above */
+	struct dm_btree_info nb_info;
+
+	/* just the top level, for deleting whole devices */
+	struct dm_btree_info tl_info;
+
+	/* just the bottom level for creating new devices */
+	struct dm_btree_info bl_info;
+
+	/* Describes the device details btree */
+	struct dm_btree_info details_info;
+
+	struct rw_semaphore root_lock;
+	uint32_t time;
+	int need_commit;
+	struct dm_block *sblock;
+	dm_block_t root;
+	dm_block_t details_root;
+	struct list_head ms_devices;
+	uint64_t trans_id;
+	unsigned long flags;
+	sector_t data_block_size;
+};
+
+struct dm_ms_device {
+	struct list_head list;
+	struct dm_thin_metadata *mmd;
+	dm_thin_dev_t id;
+
+	int open_count;
+	int changed;
+	uint64_t mapped_blocks;
+	uint64_t transaction_id;
+	uint32_t creation_time;
+	uint32_t snapshotted_time;
+};
+
+/*----------------------------------------------------------------
+ * superblock validator
+ *--------------------------------------------------------------*/
+
+static void sb_prepare_for_write(struct dm_block_validator *v,
+				 struct dm_block *b,
+				 size_t block_size)
+{
+	struct thin_super_block *sb = dm_block_data(b);
+
+	sb->blocknr = __cpu_to_le64(dm_block_location(b));
+	sb->csum = dm_block_csum_data(&sb->flags,
+				      sizeof(*sb) - sizeof(u32));
+}
+
+static int sb_check(struct dm_block_validator *v,
+		    struct dm_block *b,
+		    size_t block_size)
+{
+	struct thin_super_block *sb = dm_block_data(b);
+	__le32 csum;
+
+	if (dm_block_location(b) != __le64_to_cpu(sb->blocknr)) {
+		DMERR("sb_check failed blocknr %llu "
+		      "wanted %llu", __le64_to_cpu(sb->blocknr),
+		      dm_block_location(b));
+		return -ENOTBLK;
+	}
+
+	if (__le64_to_cpu(sb->magic) != THIN_SUPERBLOCK_MAGIC) {
+		DMERR("sb_check failed magic %llu "
+		      "wanted %llu", __le64_to_cpu(sb->magic),
+		      (unsigned long long)THIN_SUPERBLOCK_MAGIC);
+		return -EILSEQ;
+	}
+
+	csum = dm_block_csum_data(&sb->flags,
+				  sizeof(*sb) - sizeof(u32));
+	if (csum != sb->csum) {
+		DMERR("sb_check failed csum %u wanted %u",
+		      __le32_to_cpu(csum), __le32_to_cpu(sb->csum));
+		return -EILSEQ;
+	}
+
+	return 0;
+}
+
+static struct dm_block_validator sb_validator_ = {
+	.name = "superblock",
+	.prepare_for_write = sb_prepare_for_write,
+	.check = sb_check
+};
+
+/*----------------------------------------------------------------
+ * Methods for the btree value types
+ *--------------------------------------------------------------*/
+
+static uint64_t pack_dm_block_time(dm_block_t b, uint32_t t)
+{
+	return (b << 24) | t;
+}
+
+static void unpack_dm_block_time(uint64_t v, dm_block_t *b, uint32_t *t)
+{
+	*b = v >> 24;
+	*t = v & ((1 << 24) - 1);
+}
+
+static void data_block_inc(void *context, void *value)
+{
+	struct dm_space_map *sm = context;
+	__le64 v;
+	uint64_t b;
+	uint32_t t;
+
+	memcpy(&v, value, sizeof(v));
+	unpack_dm_block_time(v, &b, &t);
+	dm_sm_inc_block(sm, b);
+}
+
+static void data_block_dec(void *context, void *value)
+{
+	struct dm_space_map *sm = context;
+	__le64 v;
+	uint64_t b;
+	uint32_t t;
+
+	memcpy(&v, value, sizeof(v));
+	unpack_dm_block_time(v, &b, &t);
+	dm_sm_dec_block(sm, b);
+}
+
+static int data_block_equal(void *context, void *value1, void *value2)
+{
+	__le64 v1, v2;
+	uint64_t b1, b2;
+	uint32_t t;
+
+	memcpy(&v1, value1, sizeof(v1));
+	memcpy(&v2, value2, sizeof(v2));
+	unpack_dm_block_time(v1, &b1, &t);
+	unpack_dm_block_time(v2, &b2, &t);
+	return b1 == b2;
+}
+
+static void subtree_inc(void *context, void *value)
+{
+	struct dm_btree_info *info = context;
+	__le64 le_root;
+	uint64_t root;
+
+	memcpy(&le_root, value, sizeof(le_root));
+	root = __le64_to_cpu(le_root);
+	dm_tm_inc(info->tm, root);
+}
+
+static void subtree_dec(void *context, void *value)
+{
+	struct dm_btree_info *info = context;
+	__le64 le_root;
+	uint64_t root;
+
+	memcpy(&le_root, value, sizeof(le_root));
+	root = __le64_to_cpu(le_root);
+	if (dm_btree_del(info, root))
+		DMERR("btree delete failed\n");
+}
+
+static int subtree_equal(void *context, void *value1, void *value2)
+{
+	__le64 v1, v2;
+	memcpy(&v1, value1, sizeof(v1));
+	memcpy(&v2, value2, sizeof(v2));
+	return v1 == v2;
+}
+
+/*----------------------------------------------------------------*/
+
+static int superblock_all_zeroes(struct dm_block_manager *bm, int *result)
+{
+	int r, i;
+	struct dm_block *b;
+	uint64_t *data;
+	unsigned block_size = dm_bm_block_size(bm) / sizeof(uint64_t);
+
+	/*
+	 * We can't use a validator here, it may be all zeroes.
+	 */
+	r = dm_bm_read_lock(bm, THIN_SUPERBLOCK_LOCATION, NULL, &b);
+	if (r)
+		return r;
+
+	data = dm_block_data(b);
+	*result = 1;
+	for (i = 0; i < block_size; i++) {
+		if (data[i] != 0LL) {
+			*result = 0;
+			break;
+		}
+	}
+
+	return dm_bm_unlock(b);
+}
+
+static struct dm_thin_metadata *alloc_mmd(struct dm_block_manager *bm,
+					  dm_block_t nr_blocks, int create)
+{
+	int r;
+	struct dm_space_map *sm, *data_sm;
+	struct dm_transaction_manager *tm;
+	struct dm_thin_metadata *mmd;
+	struct dm_block *sblock;
+
+	if (create) {
+		r = dm_tm_create_with_sm(bm, THIN_SUPERBLOCK_LOCATION,
+					 &sb_validator_, &tm, &sm, &sblock);
+		if (r < 0) {
+			DMERR("tm_create_with_sm failed");
+			dm_block_manager_destroy(bm);
+			return ERR_PTR(r);
+		}
+
+		data_sm = dm_sm_disk_create(tm, nr_blocks);
+		if (IS_ERR(data_sm)) {
+			DMERR("sm_disk_create failed");
+			r = PTR_ERR(data_sm);
+			goto bad;
+		}
+
+		r = dm_tm_pre_commit(tm);
+		if (r < 0) {
+			DMERR("couldn't pre commit");
+			goto bad;
+		}
+
+		r = dm_tm_commit(tm, sblock);
+		if (r < 0) {
+			DMERR("couldn't commit");
+			goto bad;
+		}
+	} else {
+		struct thin_super_block *sb = NULL;
+		size_t space_map_root_offset =
+			offsetof(struct thin_super_block, metadata_space_map_root);
+
+		r = dm_tm_open_with_sm(bm, THIN_SUPERBLOCK_LOCATION,
+				       &sb_validator_, space_map_root_offset,
+				       SPACE_MAP_ROOT_SIZE, &tm, &sm, &sblock);
+		if (r < 0) {
+			DMERR("tm_open_with_sm failed");
+			dm_block_manager_destroy(bm);
+			return ERR_PTR(r);
+		}
+
+		sb = dm_block_data(sblock);
+		data_sm = dm_sm_disk_open(tm, sb->data_space_map_root,
+					  sizeof(sb->data_space_map_root));
+		if (IS_ERR(data_sm)) {
+			DMERR("sm_disk_open failed");
+			r = PTR_ERR(data_sm);
+			goto bad;
+		}
+
+		dm_tm_unlock(tm, sblock);
+	}
+
+	mmd = kmalloc(sizeof(*mmd), GFP_KERNEL);
+	if (!mmd) {
+		DMERR("could not allocate metadata struct");
+		r = -ENOMEM;
+		goto bad;
+	}
+
+	mmd->bm = bm;
+	mmd->metadata_sm = sm;
+	mmd->data_sm = data_sm;
+	mmd->tm = tm;
+	mmd->nb_tm = dm_tm_create_non_blocking_clone(tm);
+	if (!mmd->nb_tm) {
+		DMERR("could not create clone tm");
+		r = -ENOMEM;
+		goto bad;
+	}
+
+	mmd->sblock = NULL;
+
+	mmd->info.tm = tm;
+	mmd->info.levels = 2;
+	mmd->info.value_type.context = mmd->data_sm;
+	mmd->info.value_type.size = sizeof(__le64);
+	mmd->info.value_type.inc = data_block_inc;
+	mmd->info.value_type.dec = data_block_dec;
+	mmd->info.value_type.equal = data_block_equal;
+
+	memcpy(&mmd->nb_info, &mmd->info, sizeof(mmd->nb_info));
+	mmd->nb_info.tm = mmd->nb_tm;
+
+	mmd->tl_info.tm = tm;
+	mmd->tl_info.levels = 1;
+	mmd->tl_info.value_type.context = &mmd->info;
+	mmd->tl_info.value_type.size = sizeof(__le64);
+	mmd->tl_info.value_type.inc = subtree_inc;
+	mmd->tl_info.value_type.dec = subtree_dec;
+	mmd->tl_info.value_type.equal = subtree_equal;
+
+	mmd->bl_info.tm = tm;
+	mmd->bl_info.levels = 1;
+	mmd->bl_info.value_type.context = mmd->data_sm;
+	mmd->bl_info.value_type.size = sizeof(__le64);
+	mmd->bl_info.value_type.inc = data_block_inc;
+	mmd->bl_info.value_type.dec = data_block_dec;
+	mmd->bl_info.value_type.equal = data_block_equal;
+
+	mmd->details_info.tm = tm;
+	mmd->details_info.levels = 1;
+	mmd->details_info.value_type.context = NULL;
+	mmd->details_info.value_type.size = sizeof(struct device_details);
+	mmd->details_info.value_type.inc = NULL;
+	mmd->details_info.value_type.dec = NULL;
+	mmd->details_info.value_type.equal = NULL;
+
+	mmd->root = 0;
+
+	init_rwsem(&mmd->root_lock);
+	mmd->time = 0;
+	mmd->need_commit = 0;
+	mmd->details_root = 0;
+	INIT_LIST_HEAD(&mmd->ms_devices);
+
+	return mmd;
+
+bad:
+	dm_tm_destroy(tm);
+	dm_sm_destroy(sm);
+	dm_block_manager_destroy(bm);
+
+	return ERR_PTR(r);
+}
+
+static int begin_transaction(struct dm_thin_metadata *mmd)
+{
+	int r;
+	u32 features;
+	struct thin_super_block *sb;
+
+	/* dm_thin_metadata_commit() resets mmd->sblock */
+	WARN_ON(mmd->sblock);
+	mmd->need_commit = 0;
+	/* superblock is unlocked via dm_tm_commit() */
+	r = dm_bm_write_lock(mmd->bm, THIN_SUPERBLOCK_LOCATION,
+			     &sb_validator_, &mmd->sblock);
+	if (r)
+		return r;
+
+	sb = dm_block_data(mmd->sblock);
+	mmd->time = __le32_to_cpu(sb->time);
+	mmd->root = __le64_to_cpu(sb->data_mapping_root);
+	mmd->details_root = __le64_to_cpu(sb->device_details_root);
+	mmd->trans_id = __le64_to_cpu(sb->trans_id);
+	mmd->flags = __le32_to_cpu(sb->flags);
+	mmd->data_block_size = __le32_to_cpu(sb->data_block_size);
+
+	features = __le32_to_cpu(sb->incompat_flags) &
+		~THIN_FEATURE_INCOMPAT_SUPP;
+	if (features) {
+		DMERR("could not access metadata due to "
+		      "unsupported optional features (%lx).",
+		      (unsigned long)features);
+		return -EINVAL;
+	}
+
+	/* check for read-only metadata to skip the following RDWR checks */
+	if (get_disk_ro(mmd->bdev->bd_disk))
+		return 0;
+
+	features = __le32_to_cpu(sb->compat_ro_flags) &
+		~THIN_FEATURE_COMPAT_RO_SUPP;
+	if (features) {
+		DMERR("could not access metadata RDWR due to "
+		      "unsupported optional features (%lx).",
+		      (unsigned long)features);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+struct dm_thin_metadata *
+dm_thin_metadata_open(struct block_device *bdev, sector_t data_block_size)
+{
+	int r;
+	struct thin_super_block *sb;
+	struct dm_thin_metadata *mmd;
+	sector_t bdev_size = i_size_read(bdev->bd_inode) >> SECTOR_SHIFT;
+	struct dm_block_manager *bm;
+	int create;
+
+	bm = dm_block_manager_create(bdev, THIN_METADATA_BLOCK_SIZE,
+				     THIN_METADATA_CACHE_SIZE);
+	if (!bm) {
+		DMERR("could not create block manager");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	r = superblock_all_zeroes(bm, &create);
+	if (r) {
+		dm_block_manager_destroy(bm);
+		return ERR_PTR(r);
+	}
+
+	mmd = alloc_mmd(bm, 0, create);
+	if (IS_ERR(mmd)) {
+		/* alloc_mmd() destroys the block manager on failure */
+		return mmd; /* already an ERR_PTR */
+	}
+	mmd->bdev = bdev;
+
+	if (!create) {
+		r = begin_transaction(mmd);
+		if (r < 0)
+			goto bad;
+		return mmd;
+	}
+
+	/* Create */
+	if (!mmd->sblock) {
+		r = begin_transaction(mmd);
+		if (r < 0)
+			goto bad;
+	}
+
+	sb = dm_block_data(mmd->sblock);
+	sb->magic = __cpu_to_le64(THIN_SUPERBLOCK_MAGIC);
+	sb->version = __cpu_to_le32(THIN_VERSION);
+	sb->time = 0;
+	sb->metadata_block_size = __cpu_to_le32(THIN_METADATA_BLOCK_SIZE >> SECTOR_SHIFT);
+	sb->metadata_nr_blocks = __cpu_to_le64(bdev_size >> SECTOR_TO_BLOCK_SHIFT);
+	sb->data_block_size = __cpu_to_le32(data_block_size);
+
+	r = dm_btree_empty(&mmd->info, &mmd->root);
+	if (r < 0)
+		goto bad;
+
+	r = dm_btree_empty(&mmd->details_info, &mmd->details_root);
+	if (r < 0) {
+		DMERR("couldn't create devices root");
+		goto bad;
+	}
+
+	mmd->flags = 0;
+	mmd->need_commit = 1;
+	r = dm_thin_metadata_commit(mmd);
+	if (r < 0) {
+		DMERR("%s: dm_thin_metadata_commit() failed, error = %d",
+		      __func__, r);
+		goto bad;
+	}
+
+	return mmd;
+bad:
+	if (dm_thin_metadata_close(mmd) < 0)
+		DMWARN("%s: dm_thin_metadata_close() failed.", __func__);
+	return ERR_PTR(r);
+}
+
+int dm_thin_metadata_close(struct dm_thin_metadata *mmd)
+{
+	int r;
+	unsigned open_devices = 0;
+	struct dm_ms_device *msd, *tmp;
+
+	down_read(&mmd->root_lock);
+	list_for_each_entry_safe(msd, tmp, &mmd->ms_devices, list) {
+		if (msd->open_count)
+			open_devices++;
+		else {
+			list_del(&msd->list);
+			kfree(msd);
+		}
+	}
+	up_read(&mmd->root_lock);
+
+	if (open_devices) {
+		DMERR("attempt to close mmd when %u device(s) are still open",
+		       open_devices);
+		return -EBUSY;
+	}
+
+	if (mmd->sblock) {
+		r = dm_thin_metadata_commit(mmd);
+		if (r)
+			DMWARN("%s: dm_thin_metadata_commit() failed, error = %d",
+			       __func__, r);
+	}
+
+	dm_tm_destroy(mmd->tm);
+	dm_tm_destroy(mmd->nb_tm);
+	dm_block_manager_destroy(mmd->bm);
+	dm_sm_destroy(mmd->metadata_sm);
+	dm_sm_destroy(mmd->data_sm);
+	kfree(mmd);
+
+	return 0;
+}
+
+static int __open_device(struct dm_thin_metadata *mmd,
+			 dm_thin_dev_t dev, int create,
+			 struct dm_ms_device **msd)
+{
+	int r, changed = 0;
+	struct dm_ms_device *msd2;
+	uint64_t key = dev;
+	struct device_details details;
+
+	/* check the device isn't already open */
+	list_for_each_entry(msd2, &mmd->ms_devices, list)
+		if (msd2->id == dev) {
+			msd2->open_count++;
+			*msd = msd2;
+			return 0;
+		}
+
+	/* check the device exists */
+	r = dm_btree_lookup(&mmd->details_info, mmd->details_root,
+			    &key, &details);
+	if (r) {
+		if (r == -ENODATA && create) {
+			changed = 1;
+			details.mapped_blocks = 0;
+			details.transaction_id = __cpu_to_le64(mmd->trans_id);
+			details.creation_time = __cpu_to_le32(mmd->time);
+			details.snapshotted_time = __cpu_to_le32(mmd->time);
+
+		} else
+			return r;
+	}
+
+	*msd = kmalloc(sizeof(**msd), GFP_NOIO);
+	if (!*msd)
+		return -ENOMEM;
+
+	(*msd)->mmd = mmd;
+	(*msd)->id = dev;
+	(*msd)->open_count = 1;
+	(*msd)->changed = changed;
+	(*msd)->mapped_blocks = __le64_to_cpu(details.mapped_blocks);
+	(*msd)->transaction_id = __le64_to_cpu(details.transaction_id);
+	(*msd)->creation_time = __le32_to_cpu(details.creation_time);
+	(*msd)->snapshotted_time = __le32_to_cpu(details.snapshotted_time);
+
+	list_add(&(*msd)->list, &mmd->ms_devices);
+
+	return 0;
+}
+
+static void __close_device(struct dm_ms_device *msd)
+{
+	--msd->open_count;
+}
+
+static int __create_thin(struct dm_thin_metadata *mmd,
+			 dm_thin_dev_t dev)
+{
+	int r;
+	dm_block_t dev_root;
+	uint64_t key = dev;
+	struct device_details detail;
+	struct dm_ms_device *msd;
+	__le64 value;
+
+	r = dm_btree_lookup(&mmd->details_info, mmd->details_root,
+			    &key, &detail);
+	if (!r)
+		return -EEXIST;
+
+	/* create an empty btree for the mappings */
+	r = dm_btree_empty(&mmd->bl_info, &dev_root);
+	if (r)
+		return r;
+
+	/* insert it into the main mapping tree */
+	value = __cpu_to_le64(dev_root);
+	r = dm_btree_insert(&mmd->tl_info, mmd->root, &key, &value, &mmd->root);
+	if (r) {
+		dm_btree_del(&mmd->bl_info, dev_root);
+		return r;
+	}
+
+	r = __open_device(mmd, dev, 1, &msd);
+	if (r) {
+		__close_device(msd);
+		dm_btree_remove(&mmd->tl_info, mmd->root, &key, &mmd->root);
+		dm_btree_del(&mmd->bl_info, dev_root);
+		return r;
+	}
+	msd->changed = 1;
+	__close_device(msd);
+
+	return r;
+}
+
+int dm_thin_metadata_create_thin(struct dm_thin_metadata *mmd,
+				 dm_thin_dev_t dev)
+{
+	int r;
+
+	down_write(&mmd->root_lock);
+	r = __create_thin(mmd, dev);
+	up_write(&mmd->root_lock);
+
+	return r;
+}
+
+static int __set_snapshot_details(struct dm_thin_metadata *mmd,
+				  struct dm_ms_device *snap,
+				  dm_thin_dev_t origin, uint32_t time)
+{
+	int r;
+	struct dm_ms_device *msd;
+
+	r = __open_device(mmd, origin, 0, &msd);
+	if (r)
+		return r;
+
+	msd->changed = 1;
+	msd->snapshotted_time = time;
+
+	snap->mapped_blocks = msd->mapped_blocks;
+	snap->snapshotted_time = time;
+	__close_device(msd);
+
+	return 0;
+}
+
+static int __create_snap(struct dm_thin_metadata *mmd,
+			 dm_thin_dev_t dev, dm_thin_dev_t origin)
+{
+	int r;
+	dm_block_t origin_root, snap_root;
+	uint64_t key = origin, dev_key = dev;
+	struct dm_ms_device *msd;
+	struct device_details detail;
+	__le64 value;
+
+	/* check this device is unused */
+	r = dm_btree_lookup(&mmd->details_info, mmd->details_root,
+			    &dev_key, &detail);
+	if (!r)
+		return -EEXIST;
+
+	/* find the mapping tree for the origin */
+	r = dm_btree_lookup(&mmd->tl_info, mmd->root, &key, &value);
+	if (r)
+		return r;
+	origin_root = __le64_to_cpu(value);
+
+	/* clone the origin */
+	r = dm_btree_clone(&mmd->bl_info, origin_root, &snap_root);
+	if (r)
+		return r;
+
+	/* insert into the main mapping tree */
+	value = __cpu_to_le64(snap_root);
+	key = dev;
+	r = dm_btree_insert(&mmd->tl_info, mmd->root, &key, &value, &mmd->root);
+	if (r) {
+		dm_btree_del(&mmd->bl_info, snap_root);
+		return r;
+	}
+
+	mmd->time++;
+
+	r = __open_device(mmd, dev, 1, &msd);
+	if (r)
+		goto bad;
+
+	r = __set_snapshot_details(mmd, msd, origin, mmd->time);
+	if (r)
+		goto bad;
+
+	__close_device(msd);
+	return 0;
+
+bad:
+	__close_device(msd);
+	dm_btree_remove(&mmd->tl_info, mmd->root, &key, &mmd->root);
+	dm_btree_remove(&mmd->details_info, mmd->details_root,
+			&key, &mmd->details_root);
+	return r;
+}
+
+int dm_thin_metadata_create_snap(struct dm_thin_metadata *mmd,
+				 dm_thin_dev_t dev,
+				 dm_thin_dev_t origin)
+{
+	int r;
+
+	down_write(&mmd->root_lock);
+	r = __create_snap(mmd, dev, origin);
+	up_write(&mmd->root_lock);
+
+	return r;
+}
+
+static int __delete_device(struct dm_thin_metadata *mmd,
+			   dm_thin_dev_t dev)
+{
+	int r;
+	uint64_t key = dev;
+	struct dm_ms_device *msd;
+
+	/* TODO: failure should mark the transaction invalid */
+	r = __open_device(mmd, dev, 0, &msd);
+	if (r)
+		return r;
+
+	if (msd->open_count > 1) {
+		__close_device(msd);
+		return -EBUSY;
+	}
+
+	list_del(&msd->list);
+	kfree(msd);
+	r = dm_btree_remove(&mmd->details_info, mmd->details_root,
+			    &key, &mmd->details_root);
+	if (r)
+		return r;
+
+	r = dm_btree_remove(&mmd->tl_info, mmd->root, &key, &mmd->root);
+	if (r)
+		return r;
+
+	mmd->need_commit = 1;
+	return 0;
+}
+
+int dm_thin_metadata_delete_device(struct dm_thin_metadata *mmd,
+				   dm_thin_dev_t dev)
+{
+	int r;
+
+	down_write(&mmd->root_lock);
+	r = __delete_device(mmd, dev);
+	up_write(&mmd->root_lock);
+
+	return r;
+}
+
+static int __trim_thin_dev(struct dm_ms_device *msd, sector_t new_size)
+{
+	struct dm_thin_metadata *mmd = msd->mmd;
+	/* FIXME: convert new size to blocks */
+	uint64_t key[2] = { msd->id, new_size - 1 };
+
+	msd->changed = 1;
+
+	/*
+	 * We need to truncate all the extraneous mappings.
+	 *
+	 * FIXME: We have to be careful to do this atomically.
+	 * Perhaps clone the bottom layer first so we can revert?
+	 */
+	return dm_btree_del_gt(&mmd->info, mmd->root, key, &mmd->root);
+}
+
+int dm_thin_metadata_trim_thin_dev(struct dm_thin_metadata *mmd,
+				   dm_thin_dev_t dev,
+				   sector_t new_size)
+{
+	int r;
+	struct dm_ms_device *msd;
+
+	down_write(&mmd->root_lock);
+	r = __open_device(mmd, dev, 1, &msd);
+	if (r)
+		DMERR("couldn't open virtual device");
+	else {
+		r = __trim_thin_dev(msd, new_size);
+		__close_device(msd);
+	}
+
+	/* FIXME: update mapped_blocks */
+
+	up_write(&mmd->root_lock);
+
+	return r;
+}
+
+int dm_thin_metadata_set_transaction_id(struct dm_thin_metadata *mmd,
+					uint64_t current_id,
+					uint64_t new_id)
+{
+	down_write(&mmd->root_lock);
+	if (mmd->trans_id != current_id) {
+		up_write(&mmd->root_lock);
+		DMERR("mismatched transaction id");
+		return -EINVAL;
+	}
+
+	mmd->trans_id = new_id;
+	mmd->need_commit = 1;
+	up_write(&mmd->root_lock);
+
+	return 0;
+}
+
+int dm_thin_metadata_get_transaction_id(struct dm_thin_metadata *mmd,
+					uint64_t *result)
+{
+	down_read(&mmd->root_lock);
+	*result = mmd->trans_id;
+	up_read(&mmd->root_lock);
+
+	return 0;
+}
+
+int dm_thin_metadata_hold_root(struct dm_thin_metadata *mmd)
+{
+	/* FIXME implement */
+
+	return 0;
+}
+
+int dm_thin_metadata_get_held_root(struct dm_thin_metadata *mmd,
+				   dm_block_t *result)
+{
+	struct thin_super_block *sb;
+
+	down_read(&mmd->root_lock);
+	sb = dm_block_data(mmd->sblock);
+	*result = __le64_to_cpu(sb->held_root);
+	up_read(&mmd->root_lock);
+
+	return 0;
+}
+
+int dm_thin_metadata_open_device(struct dm_thin_metadata *mmd,
+				 dm_thin_dev_t dev,
+				 struct dm_ms_device **msd)
+{
+	int r;
+
+	down_write(&mmd->root_lock);
+	r = __open_device(mmd, dev, 0, msd);
+	up_write(&mmd->root_lock);
+
+	return r;
+}
+
+int dm_thin_metadata_close_device(struct dm_ms_device *msd)
+{
+	down_write(&msd->mmd->root_lock);
+	__close_device(msd);
+	up_write(&msd->mmd->root_lock);
+
+	return 0;
+}
+
+dm_thin_dev_t dm_thin_device_dev(struct dm_ms_device *msd)
+{
+	return msd->id;
+}
+
+static int __snapshotted_since(struct dm_ms_device *msd, uint32_t time)
+{
+	return msd->snapshotted_time > time;
+}
+
+int dm_thin_metadata_lookup(struct dm_ms_device *msd,
+			    dm_block_t block, int can_block,
+			    struct dm_thin_lookup_result *result)
+{
+	int r;
+	uint64_t keys[2], dm_block_time = 0;
+	__le64 value;
+	struct dm_thin_metadata *mmd = msd->mmd;
+
+	keys[0] = msd->id;
+	keys[1] = block;
+
+	if (can_block) {
+		down_read(&mmd->root_lock);
+		r = dm_btree_lookup(&mmd->info, mmd->root, keys, &value);
+		if (!r)
+			dm_block_time = __le64_to_cpu(value);
+		up_read(&mmd->root_lock);
+
+	} else if (down_read_trylock(&mmd->root_lock)) {
+		r = dm_btree_lookup(&mmd->nb_info, mmd->root, keys, &value);
+		if (!r)
+			dm_block_time = __le64_to_cpu(value);
+		up_read(&mmd->root_lock);
+
+	} else
+		return -EWOULDBLOCK;
+
+	if (!r) {
+		dm_block_t exception_block;
+		uint32_t exception_time;
+		unpack_dm_block_time(dm_block_time, &exception_block,
+				     &exception_time);
+		result->block = exception_block;
+		result->shared = __snapshotted_since(msd, exception_time);
+	}
+
+	return r;
+}
+
+static int __insert(struct dm_ms_device *msd,
+		    dm_block_t block, dm_block_t data_block)
+{
+	int r, inserted;
+	dm_block_t keys[2];
+	__le64 value;
+	struct dm_thin_metadata *mmd = msd->mmd;
+
+	keys[0] = msd->id;
+	keys[1] = block;
+
+	mmd->need_commit = 1;
+	value = __cpu_to_le64(pack_dm_block_time(data_block, mmd->time));
+
+	r = dm_btree_insert_notify(&mmd->info, mmd->root, keys, &value,
+				   &mmd->root, &inserted);
+	if (r)
+		return r;
+
+	if (inserted) {
+		msd->mapped_blocks++;
+		msd->changed = 1;
+	}
+
+	return 0;
+}
+
+int dm_thin_metadata_insert(struct dm_ms_device *msd,
+			    dm_block_t block, dm_block_t data_block)
+{
+	int r;
+
+	down_write(&msd->mmd->root_lock);
+	r = __insert(msd, block, data_block);
+	up_write(&msd->mmd->root_lock);
+
+	return r;
+}
+
+static int __remove(struct dm_ms_device *msd, dm_block_t block)
+{
+	int r;
+	struct dm_thin_metadata *mmd = msd->mmd;
+	dm_block_t keys[2] = { msd->id, block };
+
+	r = dm_btree_remove(&mmd->info, mmd->root, keys, &mmd->root);
+	if (r)
+		return r;
+
+	mmd->need_commit = 1;
+	return 0;
+}
+
+int dm_thin_metadata_remove(struct dm_ms_device *msd, dm_block_t block)
+{
+	int r;
+
+	down_write(&msd->mmd->root_lock);
+	r = __remove(msd, block);
+	up_write(&msd->mmd->root_lock);
+
+	return r;
+}
+
+int dm_thin_metadata_alloc_data_block(struct dm_ms_device *msd,
+				      dm_block_t *result)
+{
+	int r;
+	struct dm_thin_metadata *mmd = msd->mmd;
+
+	down_write(&mmd->root_lock);
+	r = dm_sm_new_block(mmd->data_sm, result);
+	mmd->need_commit = 1;
+	up_write(&mmd->root_lock);
+
+	return r;
+}
+
+static int __write_changed_details(struct dm_thin_metadata *mmd)
+{
+	int r;
+	struct dm_ms_device *msd, *tmp;
+
+	list_for_each_entry_safe(msd, tmp, &mmd->ms_devices, list) {
+		if (msd->changed) {
+			struct device_details dd;
+			uint64_t key = msd->id;
+
+			dd.mapped_blocks = __cpu_to_le64(msd->mapped_blocks);
+			dd.transaction_id = __cpu_to_le64(msd->transaction_id);
+			dd.creation_time = __cpu_to_le32(msd->creation_time);
+			dd.snapshotted_time = __cpu_to_le32(msd->snapshotted_time);
+
+			r = dm_btree_insert(&mmd->details_info, mmd->details_root,
+					    &key, &dd, &mmd->details_root);
+			if (r)
+				return r;
+
+			if (msd->open_count)
+				msd->changed = 0;
+			else {
+				list_del(&msd->list);
+				kfree(msd);
+			}
+
+			mmd->need_commit = 1;
+		}
+	}
+
+	return 0;
+}
+
+int dm_thin_metadata_commit(struct dm_thin_metadata *mmd)
+{
+	/*
+	 * FIXME: associated pool should be made read-only on
+	 * dm_thin_metadata_commit failure.
+	 */
+	int r;
+	size_t len;
+	struct thin_super_block *sb;
+
+	/* We want to know if/when the thin_super_block exceeds a 512b sector */
+	BUILD_BUG_ON(sizeof(struct thin_super_block) > 512);
+
+	down_write(&mmd->root_lock);
+	r = __write_changed_details(mmd);
+	if (r < 0)
+		goto out;
+
+	if (!mmd->need_commit)
+		goto out;
+
+	r = dm_tm_pre_commit(mmd->tm);
+	if (r < 0)
+		goto out;
+
+	r = dm_sm_root_size(mmd->metadata_sm, &len);
+	if (r < 0)
+		goto out;
+
+	sb = dm_block_data(mmd->sblock);
+	sb->time = __cpu_to_le32(mmd->time);
+	sb->data_mapping_root = __cpu_to_le64(mmd->root);
+	sb->device_details_root = __cpu_to_le64(mmd->details_root);
+	sb->trans_id = __cpu_to_le64(mmd->trans_id);
+	sb->flags = __cpu_to_le32(mmd->flags);
+	r = dm_sm_copy_root(mmd->metadata_sm, &sb->metadata_space_map_root, len);
+	if (r < 0)
+		goto out;
+
+	r = dm_sm_copy_root(mmd->data_sm, &sb->data_space_map_root, len);
+	if (r < 0)
+		goto out;
+
+	r = dm_tm_commit(mmd->tm, mmd->sblock);
+	if (r < 0)
+		goto out;
+
+	/* open the next transaction */
+	mmd->sblock = NULL;
+
+	r = begin_transaction(mmd);
+out:
+	up_write(&mmd->root_lock);
+	return r;
+}
+
+int dm_thin_metadata_get_free_blocks(struct dm_thin_metadata *mmd,
+				     dm_block_t *result)
+{
+	int r;
+
+	down_read(&mmd->root_lock);
+	r = dm_sm_get_nr_free(mmd->data_sm, result);
+	up_read(&mmd->root_lock);
+
+	return r;
+}
+
+int
+dm_thin_metadata_get_free_blocks_metadata(struct dm_thin_metadata *mmd,
+					  dm_block_t *result)
+{
+	int r;
+
+	down_read(&mmd->root_lock);
+	r = dm_sm_get_nr_free(mmd->metadata_sm, result);
+	up_read(&mmd->root_lock);
+
+	return r;
+}
+
+int dm_thin_metadata_get_data_block_size(struct dm_thin_metadata *mmd,
+					 sector_t *result)
+{
+	down_read(&mmd->root_lock);
+	*result = mmd->data_block_size;
+	up_read(&mmd->root_lock);
+
+	return 0;
+}
+
+int dm_thin_metadata_get_data_dev_size(struct dm_thin_metadata *mmd,
+				       dm_block_t *result)
+{
+	int r;
+
+	down_read(&mmd->root_lock);
+	r = dm_sm_get_nr_blocks(mmd->data_sm, result);
+	up_read(&mmd->root_lock);
+
+	return r;
+}
+
+int dm_thin_metadata_get_mapped_count(struct dm_ms_device *msd,
+				      dm_block_t *result)
+{
+	struct dm_thin_metadata *mmd = msd->mmd;
+
+	down_read(&mmd->root_lock);
+	*result = msd->mapped_blocks;
+	up_read(&mmd->root_lock);
+
+	return 0;
+}
+
+static int __highest_block(struct dm_ms_device *msd, dm_block_t *result)
+{
+	int r;
+	__le64 value;
+	dm_block_t thin_root;
+	struct dm_thin_metadata *mmd = msd->mmd;
+
+	r = dm_btree_lookup(&mmd->tl_info, mmd->root, &msd->id, &value);
+	if (r)
+		return r;
+
+	thin_root = __le64_to_cpu(value);
+	return dm_btree_find_highest_key(&mmd->bl_info, thin_root, result);
+}
+
+int dm_thin_metadata_get_highest_mapped_block(struct dm_ms_device *msd,
+					      dm_block_t *result)
+{
+	int r;
+	struct dm_thin_metadata *mmd = msd->mmd;
+
+	down_read(&mmd->root_lock);
+	r = __highest_block(msd, result);
+	up_read(&mmd->root_lock);
+
+	return r;
+}
+
+static int __resize_data_dev(struct dm_thin_metadata *mmd,
+			     dm_block_t new_count)
+{
+	int r;
+	dm_block_t old_count;
+
+	r = dm_sm_get_nr_blocks(mmd->data_sm, &old_count);
+	if (r)
+		return r;
+
+	if (new_count < old_count) {
+		DMERR("cannot reduce size of data device");
+		return -EINVAL;
+	}
+
+	if (new_count > old_count) {
+		r = dm_sm_extend(mmd->data_sm, new_count - old_count);
+		if (!r)
+			mmd->need_commit = 1;
+		return r;
+	} else
+		return 0;
+}
+
+int dm_thin_metadata_resize_data_dev(struct dm_thin_metadata *mmd,
+				     dm_block_t new_count)
+{
+	int r;
+
+	down_write(&mmd->root_lock);
+	r = __resize_data_dev(mmd, new_count);
+	up_write(&mmd->root_lock);
+
+	return r;
+}
+
+/*----------------------------------------------------------------*/
diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
new file mode 100644
index 0000000..c14e150
--- /dev/null
+++ b/drivers/md/dm-thin-metadata.h
@@ -0,0 +1,164 @@
+/*
+ * Copyright (C) 2010 Red Hat, Inc. All rights reserved.
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef DM_THIN_METADATA_H
+#define DM_THIN_METADATA_H
+
+#include "persistent-data/dm-btree.h"
+
+/*----------------------------------------------------------------*/
+
+struct dm_thin_metadata;
+struct dm_ms_device;
+typedef uint64_t dm_thin_dev_t;
+
+/*
+ * Reopens or creates a new, empty metadata volume.
+ */
+struct dm_thin_metadata *
+dm_thin_metadata_open(struct block_device *bdev,
+		      sector_t data_block_size);
+
+int dm_thin_metadata_close(struct dm_thin_metadata *mmd);
+
+/*
+ * Compat feature flags.  Any incompat flags beyond the ones
+ * specified below will prevent use of the thin metadata.
+ */
+#define THIN_FEATURE_COMPAT_SUPP	  0UL
+#define THIN_FEATURE_COMPAT_RO_SUPP	  0UL
+#define THIN_FEATURE_INCOMPAT_SUPP	  0UL
+
+/*
+ * Device creation/deletion.
+ */
+int dm_thin_metadata_create_thin(struct dm_thin_metadata *mmd,
+				 dm_thin_dev_t dev);
+
+/*
+ * An internal snapshot.
+ *
+ * You can only snapshot a quiesced origin.  i.e. one that is either
+ * suspended or not instanced at all.
+ */
+int dm_thin_metadata_create_snap(struct dm_thin_metadata *mmd,
+				 dm_thin_dev_t dev,
+				 dm_thin_dev_t origin);
+
+/*
+ * Deletes a virtual device from the metadata.  It _is_ safe to call this
+ * when that device is open, operations on that device will just start
+ * failing.  You still need to call close() on the device.
+ */
+int dm_thin_metadata_delete_device(struct dm_thin_metadata *mmd,
+				   dm_thin_dev_t dev);
+
+/*
+ * Thin devices don't have a size, however they do keep track of the
+ * highest mapped block.  This trimming function allows the user to remove
+ * mappings above a certain virtual block.
+ */
+int dm_thin_metadata_trim_thin_dev(struct dm_thin_metadata *mmd,
+				   dm_thin_dev_t dev,
+				   sector_t new_size);
+
+/*
+ * Commits _all_ metadata changes: device creation, deletion, mapping
+ * updates.
+ */
+int dm_thin_metadata_commit(struct dm_thin_metadata *mmd);
+
+/*
+ * Set/get userspace transaction id
+ */
+int dm_thin_metadata_set_transaction_id(struct dm_thin_metadata *mmd,
+					uint64_t current_id,
+					uint64_t new_id);
+
+int dm_thin_metadata_get_transaction_id(struct dm_thin_metadata *mmd,
+					uint64_t *result);
+
+/*
+ * hold/get root for userspace transaction
+ */
+int dm_thin_metadata_hold_root(struct dm_thin_metadata *mmd);
+
+int dm_thin_metadata_get_held_root(struct dm_thin_metadata *mmd,
+				   dm_block_t *result);
+
+/*
+ * Actions on a single virtual device.
+ */
+
+/*
+ * Opening the same device more than once will fail with -EBUSY.
+ */
+int dm_thin_metadata_open_device(struct dm_thin_metadata *mmd,
+				 dm_thin_dev_t dev,
+				 struct dm_ms_device **msd);
+
+int dm_thin_metadata_close_device(struct dm_ms_device *msd);
+
+dm_thin_dev_t dm_thin_device_dev(struct dm_ms_device *msd);
+
+struct dm_thin_lookup_result {
+	dm_block_t block;
+	int shared;
+};
+
+/*
+ * Returns:
+ *   -EWOULDBLOCK iff @can_block is set and would block.
+ *   -ENODATA iff that mapping is not present.
+ *   0 success
+ */
+int dm_thin_metadata_lookup(struct dm_ms_device *msd,
+			    dm_block_t block, int can_block,
+			    struct dm_thin_lookup_result *result);
+
+/* Inserts a new mapping */
+int dm_thin_metadata_insert(struct dm_ms_device *msd, dm_block_t block,
+			    dm_block_t data_block);
+
+int dm_thin_metadata_remove(struct dm_ms_device *msd,
+			    dm_block_t block);
+
+int dm_thin_metadata_thin_highest_mapped_block(struct dm_ms_device *msd,
+					       dm_block_t *highest_mapped);
+
+/* FIXME: why are these passed an msd, rather than an mmd ? */
+int dm_thin_metadata_alloc_data_block(struct dm_ms_device *msd,
+				      dm_block_t *result);
+
+int dm_thin_metadata_get_free_blocks(struct dm_thin_metadata *mmd,
+				     dm_block_t *result);
+
+int
+dm_thin_metadata_get_free_blocks_metadata(struct dm_thin_metadata *mmd,
+					  dm_block_t *result);
+
+int dm_thin_metadata_get_data_block_size(struct dm_thin_metadata *mmd,
+					 sector_t *result);
+
+int dm_thin_metadata_get_data_dev_size(struct dm_thin_metadata *mmd,
+				       dm_block_t *result);
+
+int dm_thin_metadata_get_mapped_count(struct dm_ms_device *msd,
+				      dm_block_t *result);
+
+int dm_thin_metadata_get_highest_mapped_block(struct dm_ms_device *msd,
+					      dm_block_t *result);
+
+/*
+ * Returns -ENOSPC if the new size is too small and already allocated
+ * blocks would be lost.
+ */
+int dm_thin_metadata_resize_data_dev(struct dm_thin_metadata *mmd,
+				     dm_block_t new_size);
+
+/*----------------------------------------------------------------*/
+
+#endif
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
new file mode 100644
index 0000000..171bdaf
--- /dev/null
+++ b/drivers/md/dm-thin.c
@@ -0,0 +1,2204 @@
+/*
+ * Copyright (C) 2011 Red Hat UK.  All rights reserved.
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm.h"
+#include "dm-thin-metadata.h"
+#include "persistent-data/dm-transaction-manager.h"
+
+#include <linux/blkdev.h>
+#include <linux/dm-io.h>
+#include <linux/dm-kcopyd.h>
+#include <linux/list.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#define	DM_MSG_PREFIX	"thin"
+
+/*
+ * How do we handle breaking sharing of data blocks?
+ * =================================================
+ *
+ * We use a standard copy-on-write btree to store the mappings for the
+ * devices (note I'm talking about copy-on-write of the metadata here, not
+ * the data).  When you take an internal snapshot you clone the root node
+ * of the origin btree.  After this there is no concept of an origin or a
+ * snapshot.  They are just two device trees that happen to point to the
+ * same data blocks.
+ *
+ * When we get a write in we decide if it's to a shared data block using
+ * some timestamp magic.  If it is, we have to break sharing.
+ *
+ * Let's say we write to a shared block in what was the origin.  The
+ * steps are:
+ *
+ * i) plug io further to this physical block. (see bio_prison code).
+ *
+ * ii) quiesce any read io to that shared data block.  Obviously
+ * including all devices that share this block.  (see deferred_set code)
+ *
+ * iii) copy the data block to a newly allocate block.  This step can be
+ * missed out if the io covers the block. (schedule_copy).
+ *
+ * iv) insert the new mapping into the origin's btree
+ * (process_prepared_mappings).  This act of inserting breaks some
+ * sharing of btree nodes between the two devices.  Breaking sharing only
+ * effects the btree of that specific device.  Btrees for the other
+ * devices that share the block never change.  The btree for the origin
+ * device as it was after the last commit is untouched, ie. we're using
+ * persistent data structures in the functional programming sense.
+ *
+ * v) unplug io to this physical block, including the io that triggered
+ * the breaking of sharing.
+ *
+ * Steps (ii) and (iii) occur in parallel.
+ *
+ * The metadata _doesn't_ need to be committed before the io continues.  We
+ * get away with this because the io is always written to a _new_ block.
+ * If there's a crash, then:
+ *
+ * - The origin mapping will point to the old origin block (the shared
+ * one).  This will contain the data as it was before the io that triggered
+ * the breaking of sharing came in.
+ *
+ * - The snap mapping still points to the old block.  As it would after
+ * the commit.
+ *
+ * The downside of this scheme is the timestamp magic isn't perfect, and
+ * will continue to think that data block in the snapshot device is shared
+ * even after the write to the origin has broken sharing.  I suspect data
+ * blocks will typically be shared by many different devices, so we're
+ * breaking sharing n + 1 times, rather than n, where n is the number of
+ * devices that reference this data block.  At the moment I think the
+ * benefits far, far outweigh the disadvantages.
+ */
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Function that breaks abstraction layering.
+ */
+static struct block_device *get_target_bdev(struct dm_target *ti)
+{
+	return dm_bdev(dm_table_get_md(ti->table));
+}
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Sometimes we can't deal with a bio straight away.  We put them in prison
+ * where they can't cause any mischief.  Bios are put in a cell identified
+ * by a key, multiple bios can be in the same cell.  When the cell is
+ * subsequently unlocked the bios become available.
+ */
+struct bio_prison;
+
+struct cell_key {
+	int virtual;
+	dm_thin_dev_t dev;
+	dm_block_t block;
+};
+
+struct cell {
+	struct hlist_node list;
+	struct bio_prison *prison;
+	struct cell_key key;
+	unsigned count;
+	struct bio_list bios;
+};
+
+struct bio_prison {
+	spinlock_t lock;
+	mempool_t *cell_pool;
+
+	unsigned nr_buckets;
+	unsigned hash_mask;
+	struct hlist_head *cells;
+};
+
+static uint32_t calc_nr_buckets(unsigned nr_cells)
+{
+	uint32_t n = 128;
+	nr_cells /= 4;
+	nr_cells = min(nr_cells, 8192u);
+	while (n < nr_cells)
+		n <<= 1;
+
+	return n;
+}
+
+/*
+ * @nr_cells should be the number of cells you want in use _concurrently_.
+ * Don't confuse it with the number of distinct keys.
+ */
+static struct bio_prison *prison_create(unsigned nr_cells)
+{
+	int i;
+	uint32_t nr_buckets = calc_nr_buckets(nr_cells);
+	size_t len = sizeof(struct bio_prison) +
+		(sizeof(struct hlist_head) * nr_buckets);
+	struct bio_prison *prison = kmalloc(len, GFP_KERNEL);
+	if (!prison)
+		return NULL;
+
+	spin_lock_init(&prison->lock);
+	prison->cell_pool = mempool_create_kmalloc_pool(nr_cells,
+							sizeof(struct cell));
+	prison->nr_buckets = nr_buckets;
+	prison->hash_mask = nr_buckets - 1;
+	prison->cells = (struct hlist_head *) (prison + 1);
+	for (i = 0; i < nr_buckets; i++)
+		INIT_HLIST_HEAD(prison->cells + i);
+
+	return prison;
+}
+
+static void prison_destroy(struct bio_prison *prison)
+{
+	mempool_destroy(prison->cell_pool);
+	kfree(prison);
+}
+
+static uint32_t hash_key(struct bio_prison *prison, struct cell_key *key)
+{
+	const unsigned BIG_PRIME = 4294967291UL;
+	uint64_t hash = key->block * BIG_PRIME;
+	return (uint32_t) (hash & prison->hash_mask);
+}
+
+static struct cell *__search_bucket(struct hlist_head *bucket,
+				    struct cell_key *key)
+{
+	struct cell *cell;
+	struct hlist_node *tmp;
+
+	hlist_for_each_entry(cell, tmp, bucket, list)
+		if (!memcmp(&cell->key, key, sizeof(cell->key)))
+			return cell;
+
+	return NULL;
+}
+
+/*
+ * This may block if a new cell needs allocating.  You must ensure that
+ * cells will be unlocked even if the calling thread is blocked.
+ *
+ * returns the number of entries in the cell prior to the new addition. or
+ * < 0 on failure.
+ */
+static int bio_detain(struct bio_prison *prison, struct cell_key *key,
+		      struct bio *inmate, struct cell **ref)
+{
+	int r;
+	unsigned long flags;
+	uint32_t hash = hash_key(prison, key);
+	struct cell *uninitialized_var(cell), *cell2 = NULL;
+
+	BUG_ON(hash > prison->nr_buckets);
+
+	spin_lock_irqsave(&prison->lock, flags);
+	cell = __search_bucket(prison->cells + hash, key);
+
+	if (!cell) {
+		/* allocate a new cell */
+		spin_unlock_irqrestore(&prison->lock, flags);
+		cell2 = mempool_alloc(prison->cell_pool, GFP_NOIO);
+		spin_lock_irqsave(&prison->lock, flags);
+
+		/*
+		 * We've been unlocked, so we have to double check that
+		 * nobody else has inserted this cell in the mean time.
+		 */
+		cell = __search_bucket(prison->cells + hash, key);
+
+		if (!cell) {
+			cell = cell2;
+			cell2 = NULL;
+
+			cell->prison = prison;
+			memcpy(&cell->key, key, sizeof(cell->key));
+			cell->count = 0;
+			bio_list_init(&cell->bios);
+			hlist_add_head(&cell->list, prison->cells + hash);
+		}
+	}
+
+	r = cell->count++;
+	bio_list_add(&cell->bios, inmate);
+	spin_unlock_irqrestore(&prison->lock, flags);
+
+	if (cell2)
+		mempool_free(cell2, prison->cell_pool);
+
+	*ref = cell;
+	return r;
+}
+
+static int bio_detain_if_occupied(struct bio_prison *prison, struct cell_key *key,
+				  struct bio *inmate, struct cell **ref)
+{
+	int r;
+	unsigned long flags;
+	uint32_t hash = hash_key(prison, key);
+	struct cell *uninitialized_var(cell);
+
+	BUG_ON(hash > prison->nr_buckets);
+
+	spin_lock_irqsave(&prison->lock, flags);
+	cell = __search_bucket(prison->cells + hash, key);
+
+	if (!cell) {
+		spin_unlock_irqrestore(&prison->lock, flags);
+		return 0;
+	}
+
+	r = cell->count++;
+	bio_list_add(&cell->bios, inmate);
+	spin_unlock_irqrestore(&prison->lock, flags);
+
+	*ref = cell;
+	return r;
+}
+
+/* @inmates must have been initialised prior to this call */
+static void __cell_release(struct cell *cell, struct bio_list *inmates)
+{
+	struct bio_prison *prison = cell->prison;
+	hlist_del(&cell->list);
+	if (inmates)
+		bio_list_merge(inmates, &cell->bios);
+	mempool_free(cell, prison->cell_pool);
+}
+
+static void cell_release(struct cell *cell, struct bio_list *bios)
+{
+	unsigned long flags;
+	struct bio_prison *prison = cell->prison;
+
+	spin_lock_irqsave(&prison->lock, flags);
+	__cell_release(cell, bios);
+	spin_unlock_irqrestore(&prison->lock, flags);
+}
+
+static void cell_error(struct cell *cell)
+{
+	struct bio_prison *prison = cell->prison;
+	struct bio_list bios;
+	struct bio *bio;
+	unsigned long flags;
+
+	bio_list_init(&bios);
+
+	spin_lock_irqsave(&prison->lock, flags);
+	__cell_release(cell, &bios);
+	spin_unlock_irqrestore(&prison->lock, flags);
+
+	while ((bio = bio_list_pop(&bios)))
+		bio_io_error(bio);
+}
+
+/*----------------------------------------------------------------*/
+
+/*
+ * We use the deferred set to keep track of pending reads to shared blocks.
+ * We do this to ensure the new mapping caused by a write isn't performed
+ * until these prior reads have completed.  Otherwise the insertion of the
+ * new mapping could free the old block that the read bios are mapped to.
+ */
+#define DEFERRED_SET_SIZE 64
+
+struct deferred_set;
+struct deferred_entry {
+	struct deferred_set *ds;
+	unsigned count;
+	struct list_head work_items;
+};
+
+struct deferred_set {
+	spinlock_t lock;
+	unsigned current_entry;
+	unsigned sweeper;
+	struct deferred_entry entries[DEFERRED_SET_SIZE];
+};
+
+static void ds_init(struct deferred_set *ds)
+{
+	int i;
+
+	spin_lock_init(&ds->lock);
+	ds->current_entry = 0;
+	ds->sweeper = 0;
+	for (i = 0; i < DEFERRED_SET_SIZE; i++) {
+		ds->entries[i].ds = ds;
+		ds->entries[i].count = 0;
+		INIT_LIST_HEAD(&ds->entries[i].work_items);
+	}
+}
+
+static struct deferred_entry *ds_inc(struct deferred_set *ds)
+{
+	unsigned long flags;
+	struct deferred_entry *entry;
+
+	spin_lock_irqsave(&ds->lock, flags);
+	entry = ds->entries + ds->current_entry;
+	entry->count++;
+	spin_unlock_irqrestore(&ds->lock, flags);
+
+	return entry;
+}
+
+static unsigned ds_next(unsigned index)
+{
+	return (index + 1) % DEFERRED_SET_SIZE;
+}
+
+static void __sweep(struct deferred_set *ds, struct list_head *head)
+{
+	while ((ds->sweeper != ds->current_entry) &&
+	       !ds->entries[ds->sweeper].count) {
+		list_splice_init(&ds->entries[ds->sweeper].work_items, head);
+		ds->sweeper = ds_next(ds->sweeper);
+	}
+
+	if ((ds->sweeper == ds->current_entry) && !ds->entries[ds->sweeper].count)
+		list_splice_init(&ds->entries[ds->sweeper].work_items, head);
+}
+
+static void ds_dec(struct deferred_entry *entry, struct list_head *head)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&entry->ds->lock, flags);
+	BUG_ON(!entry->count);
+	--entry->count;
+	__sweep(entry->ds, head);
+	spin_unlock_irqrestore(&entry->ds->lock, flags);
+}
+
+/* 1 if deferred, 0 if no pending items to delay job */
+static int ds_add_work(struct deferred_set *ds, struct list_head *work)
+{
+	int r = 1;
+	unsigned long flags;
+	unsigned next_entry;
+
+	spin_lock_irqsave(&ds->lock, flags);
+	if ((ds->sweeper == ds->current_entry) &&
+	    !ds->entries[ds->current_entry].count)
+		r = 0;
+	else {
+		list_add(work, &ds->entries[ds->current_entry].work_items);
+		next_entry = ds_next(ds->current_entry);
+		if (!ds->entries[next_entry].count) {
+			BUG_ON(!list_empty(&ds->entries[next_entry].work_items));
+			ds->current_entry = next_entry;
+		}
+	}
+	spin_unlock_irqrestore(&ds->lock, flags);
+
+	return r;
+}
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Key building.
+ */
+static void build_data_key(struct dm_ms_device *msd,
+			   dm_block_t b, struct cell_key *key)
+{
+	key->virtual = 0;
+	key->dev = dm_thin_device_dev(msd);
+	key->block = b;
+}
+
+static void build_virtual_key(struct dm_ms_device *msd, dm_block_t b,
+			      struct cell_key *key)
+{
+	key->virtual = 1;
+	key->dev = dm_thin_device_dev(msd);
+	key->block = b;
+}
+
+/*----------------------------------------------------------------*/
+
+/*
+ * A pool device ties together a metadata device and a data device.  It
+ * also provides the interface for creating and destroying internal
+ * devices.
+ */
+struct pool {
+	struct hlist_node hlist;
+	struct dm_target *ti;	/* only set if a pool target is bound */
+
+	struct block_device *pool_dev;
+	struct block_device *metadata_dev;
+	struct dm_thin_metadata *mmd;
+
+	uint32_t sectors_per_block;
+	unsigned block_shift;
+	dm_block_t offset_mask;
+	dm_block_t low_water_mark;
+	unsigned zero_new_blocks;
+
+	struct bio_prison *prison;
+	struct dm_kcopyd_client *copier;
+
+	struct workqueue_struct *producer_wq;
+	struct workqueue_struct *consumer_wq;
+	struct work_struct producer;
+	struct work_struct consumer;
+
+	spinlock_t lock;
+	struct bio_list deferred_bios;
+	struct list_head prepared_mappings;
+
+	int triggered;		/* a dm event has been sent */
+	struct bio_list retry_list;
+
+	struct deferred_set ds;	/* FIXME: move to thin_c */
+
+	mempool_t *mapping_pool;
+	mempool_t *endio_hook_pool;
+
+	atomic_t ref_count;
+};
+
+/* FIXME: can cells and new_mappings be combined? */
+
+struct new_mapping {
+	struct list_head list;
+
+	int prepared;
+
+	struct pool *pool;
+	struct dm_ms_device *msd;
+	dm_block_t virt_block;
+	dm_block_t data_block;
+	struct cell *cell;
+	int err;
+
+	/*
+	 * If the bio covers the whole area of a block then we can avoid
+	 * zeroing or copying.  Instead this bio is hooked.  The bio will
+	 * still be in the cell, so care has to be taken to avoid issuing
+	 * the bio twice.
+	 */
+	struct bio *bio;
+	bio_end_io_t *bi_end_io;
+	void *bi_private;
+};
+
+/*
+ * Target context for a pool.
+ */
+struct pool_c {
+	struct dm_target *ti;
+	struct pool *pool;
+	struct dm_dev *data_dev;
+
+	sector_t low_water_mark;
+	unsigned zero_new_blocks;
+};
+
+/*
+ * Target context for a thin.
+ */
+struct thin_c {
+	struct dm_dev *pool_dev;
+	dm_thin_dev_t dev_id;
+
+	/*
+	 * These fields are only valid while the device is resumed.  This
+	 * is because the pool_c may totally change due to table reloads
+	 * (where as the pool_dev above remains constant).
+	 */
+	struct pool *pool;
+	struct dm_ms_device *msd;
+};
+
+struct endio_hook {
+	struct pool *pool;
+	bio_end_io_t *bi_end_io;
+	void *bi_private;
+	struct deferred_entry *entry;
+};
+
+/*----------------------------------------------------------------*/
+
+/*
+ * A global table that uses a struct block_device as a key.
+ */
+#define TABLE_SIZE 32
+#define TABLE_PRIME 27 /* Largest prime smaller than table size. */
+#define	TABLE_SHIFT 5  /* Shift fitting prime. */
+struct bdev_table {
+	spinlock_t lock;
+	struct hlist_head buckets[TABLE_SIZE];
+};
+
+static void bdev_table_init(struct bdev_table *t)
+{
+	unsigned i;
+	spin_lock_init(&t->lock);
+	for (i = 0; i < TABLE_SIZE; i++)
+		INIT_HLIST_HEAD(t->buckets + i);
+}
+
+static unsigned hash_bdev(struct block_device *bdev)
+{
+	unsigned long p = (unsigned long) bdev;
+
+	do_div(p, cache_line_size());
+	return ((p * TABLE_PRIME) >> TABLE_SHIFT) & (TABLE_SIZE - 1);
+}
+
+static void bdev_table_insert(struct bdev_table *t, struct pool *pool)
+{
+	unsigned bucket = hash_bdev(pool->pool_dev);
+	spin_lock(&t->lock);
+	hlist_add_head(&pool->hlist, t->buckets + bucket);
+	spin_unlock(&t->lock);
+}
+
+static void bdev_table_remove(struct bdev_table *t, struct pool *pool)
+{
+	spin_lock(&t->lock);
+	hlist_del(&pool->hlist);
+	spin_unlock(&t->lock);
+}
+
+static struct pool *bdev_table_lookup(struct bdev_table *t,
+				      struct block_device *bdev)
+{
+	unsigned bucket = hash_bdev(bdev);
+	struct hlist_node *n;
+	struct pool *pool;
+
+	hlist_for_each_entry(pool, n, t->buckets + bucket, hlist)
+		if (pool->pool_dev == bdev)
+			return pool;
+
+	return NULL;
+}
+
+static struct bdev_table bdev_table_;
+
+/*----------------------------------------------------------------*/
+
+/*
+ * We need to maintain an association between a bio and a target.  To
+ * save lookups in an auxillary table, or wrapping bios in objects from a
+ * mempool we hide this value in the bio->bi_bdev field, which we know is
+ * not used while the bio is being processed.
+ */
+static void set_ti(struct bio *bio, struct dm_target *ti)
+{
+	bio->bi_bdev = (struct block_device *) ti;
+}
+
+static struct dm_ms_device *get_msd(struct bio *bio)
+{
+	struct dm_target *ti = (struct dm_target *) bio->bi_bdev;
+	struct thin_c *mc = ti->private;
+	return mc->msd;
+}
+
+static struct dm_target *get_ti(struct bio *bio)
+{
+	return (struct dm_target *) bio->bi_bdev;
+}
+
+/*----------------------------------------------------------------*/
+
+static dm_block_t get_bio_block(struct pool *pool, struct bio *bio)
+{
+	return bio->bi_sector >> pool->block_shift;
+}
+
+static void remap(struct pool *pool, struct bio *bio, dm_block_t block)
+{
+	bio->bi_bdev = pool->pool_dev;
+	bio->bi_sector = (block << pool->block_shift) +
+		(bio->bi_sector & pool->offset_mask);
+}
+
+static void remap_and_issue(struct pool *pool, struct bio *bio,
+			    dm_block_t block)
+{
+	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA)) {
+		int r = dm_thin_metadata_commit(pool->mmd);
+		if (r) {
+			DMERR("%s: dm_thin_metadata_commit() failed, error = %d",
+			      __func__, r);
+			bio_io_error(bio);
+			return;
+		}
+	}
+
+	remap(pool, bio, block);
+	generic_make_request(bio);
+}
+
+static void wake_producer(struct pool *pool)
+{
+	queue_work(pool->producer_wq, &pool->producer);
+}
+
+static void __maybe_add_mapping(struct pool *pool, struct new_mapping *m)
+{
+	if (list_empty(&m->list) && m->prepared) {
+		list_add(&m->list, &pool->prepared_mappings);
+		queue_work(pool->consumer_wq, &pool->consumer);
+	}
+}
+
+static void copy_complete(int read_err, unsigned long write_err, void *context)
+{
+	unsigned long flags;
+	struct new_mapping *m = (struct new_mapping *) context;
+
+	m->err = read_err || write_err ? -EIO : 0;
+
+	spin_lock_irqsave(&m->pool->lock, flags);
+	m->prepared = 1;
+	__maybe_add_mapping(m->pool, m);
+	spin_unlock_irqrestore(&m->pool->lock, flags);
+}
+
+static void overwrite_complete(struct bio *bio, int err)
+{
+	unsigned long flags;
+	struct new_mapping *m = (struct new_mapping *) bio->bi_private;
+
+	m->err = err;
+
+	spin_lock_irqsave(&m->pool->lock, flags);
+	m->prepared = 1;
+	__maybe_add_mapping(m->pool, m);
+	spin_unlock_irqrestore(&m->pool->lock, flags);
+}
+
+static void shared_read_complete(struct bio *bio, int err)
+{
+	struct list_head mappings;
+	struct new_mapping *m, *tmp;
+	struct endio_hook *h = (struct endio_hook *) bio->bi_private;
+	unsigned long flags;
+
+	bio->bi_end_io = h->bi_end_io;
+	bio->bi_private = h->bi_private;
+	bio_endio(bio, err);
+
+	INIT_LIST_HEAD(&mappings);
+	ds_dec(h->entry, &mappings);
+
+	spin_lock_irqsave(&h->pool->lock, flags);
+	list_for_each_entry_safe(m, tmp, &mappings, list) {
+		list_del(&m->list);
+		INIT_LIST_HEAD(&m->list);
+		__maybe_add_mapping(m->pool, m);
+	}
+	spin_unlock_irqrestore(&h->pool->lock, flags);
+
+	mempool_free(h, h->pool->endio_hook_pool);
+}
+
+static int io_covers_block(struct pool *pool, struct bio *bio)
+{
+	return ((bio->bi_sector & pool->offset_mask) == 0) &&
+		(bio->bi_size == (pool->sectors_per_block << SECTOR_SHIFT));
+}
+
+static void schedule_copy(struct pool *pool, struct dm_ms_device *msd,
+			  dm_block_t virt_block, dm_block_t data_origin,
+			  dm_block_t data_dest, struct cell *cell,
+			  struct bio *bio)
+{
+	int r;
+	struct new_mapping *m = mempool_alloc(pool->mapping_pool, GFP_NOIO);
+
+	INIT_LIST_HEAD(&m->list);
+	m->prepared = 0;
+	m->pool = pool;
+	m->msd = msd;
+	m->virt_block = virt_block;
+	m->data_block = data_dest;
+	m->cell = cell;
+	m->err = 0;
+	m->bio = NULL;
+	ds_add_work(&pool->ds, &m->list);
+
+	if (io_covers_block(pool, bio)) {
+		/* no copy needed, since all data is going to change */
+		m->bio = bio;
+		m->bi_end_io = bio->bi_end_io;
+		m->bi_private = bio->bi_private;
+		bio->bi_end_io = overwrite_complete;
+		bio->bi_private = m;
+		remap_and_issue(pool, bio, data_dest);
+
+	} else {
+		/* use kcopyd */
+		struct dm_io_region from, to;
+
+		/* IO to pool->pool_dev remaps to the pool target's data_dev */
+		from.bdev = pool->pool_dev;
+		from.sector = data_origin * pool->sectors_per_block;
+		from.count = pool->sectors_per_block;
+
+		to.bdev = pool->pool_dev;
+		to.sector = data_dest * pool->sectors_per_block;
+		to.count = pool->sectors_per_block;
+
+		r = dm_kcopyd_copy(pool->copier, &from, 1, &to,
+				   0, copy_complete, m);
+		if (r < 0) {
+			mempool_free(m, pool->mapping_pool);
+			DMERR("dm_kcopyd_copy() failed");
+			cell_error(cell);
+		}
+	}
+}
+
+static void schedule_zero(struct pool *pool, struct dm_ms_device *msd,
+			  dm_block_t virt_block, dm_block_t data_block,
+			  struct cell *cell, struct bio *bio)
+{
+	struct new_mapping *m = mempool_alloc(pool->mapping_pool, GFP_NOIO);
+
+	INIT_LIST_HEAD(&m->list);
+	m->prepared = 0;
+	m->pool = pool;
+	m->msd = msd;
+	m->virt_block = virt_block;
+	m->data_block = data_block;
+	m->cell = cell;
+	m->err = 0;
+	m->bio = NULL;
+
+	if (!pool->zero_new_blocks || io_covers_block(pool, bio)) {
+		/* no copy needed, since all data is going to change */
+		m->bio = bio;
+		m->bi_end_io = bio->bi_end_io;
+		m->bi_private = bio->bi_private;
+		bio->bi_end_io = overwrite_complete;
+		bio->bi_private = m;
+		remap_and_issue(pool, bio, data_block);
+
+	} else {
+		int r;
+		struct dm_io_region to;
+
+		to.bdev = pool->pool_dev;
+		to.sector = data_block * pool->sectors_per_block;
+		to.count = pool->sectors_per_block;
+
+		r = dm_kcopyd_zero(pool->copier, 1, &to, 0, copy_complete, m);
+		if (r < 0) {
+			mempool_free(m, pool->mapping_pool);
+			DMERR("dm_kcopyd_zero() failed");
+			cell_error(cell);
+		}
+	}
+}
+
+static void cell_remap_and_issue(struct pool *pool, struct cell *cell,
+				 dm_block_t data_block)
+{
+	struct bio_list bios;
+	struct bio *bio;
+	bio_list_init(&bios);
+	cell_release(cell, &bios);
+
+	while ((bio = bio_list_pop(&bios)))
+		remap_and_issue(pool, bio, data_block);
+}
+
+static void cell_remap_and_issue_except(struct pool *pool, struct cell *cell,
+					dm_block_t data_block,
+					struct bio *exception)
+{
+	struct bio_list bios;
+	struct bio *bio;
+	bio_list_init(&bios);
+	cell_release(cell, &bios);
+
+	while ((bio = bio_list_pop(&bios)))
+		if (bio != exception)
+			remap_and_issue(pool, bio, data_block);
+}
+
+static void retry_later(struct bio *bio)
+{
+	struct dm_target *ti = get_ti(bio);
+	struct thin_c *mc = ti->private;
+	struct pool *pool = mc->pool;
+	unsigned long flags;
+
+	/* push it onto the retry list */
+	spin_lock_irqsave(&pool->lock, flags);
+	bio_list_add(&pool->retry_list, bio);
+	spin_unlock_irqrestore(&pool->lock, flags);
+}
+
+static int alloc_data_block(struct pool *pool, struct dm_ms_device *msd,
+			    dm_block_t *result)
+{
+	int r;
+	dm_block_t free_blocks;
+	unsigned long flags;
+
+	r = dm_thin_metadata_get_free_blocks(pool->mmd, &free_blocks);
+	if (r)
+		return r;
+
+	if (free_blocks <= pool->low_water_mark && !pool->triggered) {
+		spin_lock_irqsave(&pool->lock, flags);
+		pool->triggered = 1;
+		spin_unlock_irqrestore(&pool->lock, flags);
+		dm_table_event(pool->ti->table);
+	}
+
+	r = dm_thin_metadata_alloc_data_block(msd, result);
+	if (r)
+		return r;
+
+	return 0;
+}
+
+static void process_discard(struct pool *pool, struct dm_ms_device *msd,
+			    struct bio *bio)
+{
+	int r;
+	dm_block_t block = get_bio_block(pool, bio);
+	struct dm_thin_lookup_result lookup_result;
+
+	r = dm_thin_metadata_lookup(msd, block, 1, &lookup_result);
+	switch (r) {
+	case 0:
+		if (lookup_result.shared)
+			/*
+			 * We just ignore shared discards for now, these
+			 * are hard, and I want to get deferred
+			 * deallocation working first.
+			 */
+			bio_endio(bio, 0);
+
+		else {
+			r = dm_thin_metadata_remove(msd, block);
+			if (r) {
+				DMERR("dm_thin_metadata_remove() failed");
+				bio_io_error(bio);
+			} else
+				remap_and_issue(pool, bio, lookup_result.block);
+		}
+		break;
+
+	case -ENODATA:
+		/* Either this isn't provisioned, or preparation for
+		 * provisioning may be pending (we could find out by
+		 * calling bio_detain_if_occupied).  But even in this case
+		 * it's easier to just forget the discard.
+		 */
+		bio_endio(bio, 0);
+		break;
+
+	default:
+		DMERR("dm_thin_metadata_lookup() failed, error = %d", r);
+		bio_io_error(bio);
+		break;
+	}
+}
+
+static void no_space(struct cell *cell)
+{
+	struct bio *bio;
+	struct bio_list bios;
+
+	bio_list_init(&bios);
+	cell_release(cell, &bios);
+	while ((bio = bio_list_pop(&bios)))
+		retry_later(bio);
+}
+
+static void break_sharing(struct pool *pool, struct dm_ms_device *msd,
+			  struct bio *bio, dm_block_t block, struct cell_key *key,
+			  struct dm_thin_lookup_result *lookup_result)
+{
+	int r;
+	dm_block_t data_block;
+	struct cell *cell;
+
+	bio_detain(pool->prison, key, bio, &cell);
+
+	r = alloc_data_block(pool, msd, &data_block);
+	switch (r) {
+	case 0:
+		schedule_copy(pool, msd, block, lookup_result->block,
+			      data_block, cell, bio);
+		break;
+
+	case -ENOSPC:
+		no_space(cell);
+		break;
+
+	default:
+		DMERR("%s: alloc_data_block() failed, error = %d", __func__, r);
+		cell_error(cell);
+		break;
+	}
+}
+
+static void process_shared_bio(struct pool *pool, struct dm_ms_device *msd,
+			       struct bio *bio, dm_block_t block,
+			       struct dm_thin_lookup_result *lookup_result)
+{
+	struct cell *cell;
+	struct cell_key key;
+
+	build_data_key(msd, lookup_result->block, &key);
+	if (bio_detain_if_occupied(pool->prison, &key, bio, &cell))
+		return; /* already underway */
+
+	if (bio_data_dir(bio) == WRITE)
+		break_sharing(pool, msd, bio, block, &key, lookup_result);
+	else {
+		struct endio_hook *h = mempool_alloc(pool->endio_hook_pool,
+						     GFP_NOIO);
+
+		h->pool = pool;
+		h->bi_end_io = bio->bi_end_io;
+		h->bi_private = bio->bi_private;
+		h->entry = ds_inc(&pool->ds);
+
+		bio->bi_end_io = shared_read_complete;
+		bio->bi_private = h;
+
+		remap_and_issue(pool, bio, lookup_result->block);
+	}
+}
+
+static void provision_block(struct pool *pool, struct dm_ms_device *msd,
+			    struct bio *bio, dm_block_t block)
+{
+	int r;
+	dm_block_t data_block;
+	struct cell *cell;
+	struct cell_key key;
+
+	build_virtual_key(msd, block, &key);
+	if (bio_detain(pool->prison, &key, bio, &cell))
+		return; /* already underway */
+
+	r = alloc_data_block(pool, msd, &data_block);
+	switch (r) {
+	case 0:
+		schedule_zero(pool, msd, block, data_block, cell, bio);
+		break;
+
+	case -ENOSPC:
+		no_space(cell);
+		break;
+
+	default:
+		DMERR("%s: alloc_data_block() failed, error = %d", __func__, r);
+		cell_error(cell);
+		break;
+	}
+}
+
+static void process_bio(struct pool *pool, struct dm_ms_device *msd,
+			struct bio *bio)
+{
+	int r;
+	dm_block_t block = get_bio_block(pool, bio);
+	struct dm_thin_lookup_result lookup_result;
+
+	r = dm_thin_metadata_lookup(msd, block, 1, &lookup_result);
+	switch (r) {
+	case 0:
+		if (lookup_result.shared)
+			process_shared_bio(pool, msd, bio, block, &lookup_result);
+		else
+			remap_and_issue(pool, bio, lookup_result.block);
+		break;
+
+	case -ENODATA:
+		if (bio_rw(bio) == READ || bio_rw(bio) == READA) {
+			bio->bi_bdev = pool->pool_dev;
+			zero_fill_bio(bio);
+			bio_endio(bio, 0);
+		} else
+			provision_block(pool, msd, bio, block);
+		break;
+
+	default:
+		DMERR("dm_thin_metadata_lookup() failed, error = %d", r);
+		bio_io_error(bio);
+		break;
+	}
+}
+
+static void process_bios(struct pool *pool)
+{
+	unsigned long flags;
+	struct bio *bio;
+	struct bio_list bios;
+	bio_list_init(&bios);
+
+	spin_lock_irqsave(&pool->lock, flags);
+	bio_list_merge(&bios, &pool->deferred_bios);
+	bio_list_init(&pool->deferred_bios);
+	spin_unlock_irqrestore(&pool->lock, flags);
+
+	while ((bio = bio_list_pop(&bios))) {
+		struct dm_ms_device *msd = get_msd(bio);
+
+		if (bio->bi_rw & REQ_DISCARD)
+			process_discard(pool, msd, bio);
+		else
+			process_bio(pool, msd, bio);
+	}
+}
+
+static void process_prepared_mappings(struct pool *pool)
+{
+	int r;
+	unsigned long flags;
+	struct list_head maps;
+	struct new_mapping *m, *tmp;
+	struct bio *bio;
+
+	INIT_LIST_HEAD(&maps);
+	spin_lock_irqsave(&pool->lock, flags);
+	list_splice_init(&pool->prepared_mappings, &maps);
+	spin_unlock_irqrestore(&pool->lock, flags);
+
+	list_for_each_entry_safe(m, tmp, &maps, list) {
+		if (m->err) {
+			cell_error(m->cell);
+			continue;
+		}
+
+		bio = m->bio;
+		if (bio) {
+			bio->bi_end_io = m->bi_end_io;
+			bio->bi_private = m->bi_private;
+		}
+
+		r = dm_thin_metadata_insert(m->msd, m->virt_block,
+					    m->data_block);
+		if (r) {
+			DMERR("dm_thin_metadata_insert() failed");
+			cell_error(m->cell);
+		} else {
+			if (m->bio) {
+				cell_remap_and_issue_except(pool, m->cell,
+							    m->data_block, bio);
+				bio_endio(bio, 0);
+			} else
+				cell_remap_and_issue(pool, m->cell, m->data_block);
+
+			list_del(&m->list);
+			mempool_free(m, pool->mapping_pool);
+		}
+	}
+}
+
+static void do_producer(struct work_struct *ws)
+{
+	struct pool *pool = container_of(ws, struct pool, producer);
+	process_bios(pool);
+}
+
+static void do_consumer(struct work_struct *ws)
+{
+	struct pool *pool = container_of(ws, struct pool, consumer);
+	process_prepared_mappings(pool);
+}
+
+static void defer_bio(struct pool *pool, struct dm_target *ti, struct bio *bio)
+{
+	unsigned long flags;
+
+	set_ti(bio, ti);
+
+	spin_lock_irqsave(&pool->lock, flags);
+	bio_list_add(&pool->deferred_bios, bio);
+	spin_unlock_irqrestore(&pool->lock, flags);
+
+	wake_producer(pool);
+}
+
+/*
+ * Non-blocking function designed to be called from the targets map
+ * function.
+ */
+static int bio_map(struct pool *pool, struct dm_target *ti, struct bio *bio)
+{
+	int r;
+	dm_block_t block = get_bio_block(pool, bio);
+	struct thin_c *mc = ti->private;
+	struct dm_ms_device *msd = mc->msd;
+	struct dm_thin_lookup_result result;
+
+	/*
+	 * XXX(hch): in theory higher level code should prevent this
+	 * from happening, not sure why we ever get here.
+	 */
+	if ((bio->bi_rw & REQ_DISCARD) &&
+	    bio->bi_size < (pool->sectors_per_block << SECTOR_SHIFT)) {
+		DMERR("discard IO smaller than pool block size (%llu)",
+		      (unsigned long long)pool->sectors_per_block << SECTOR_SHIFT);
+		bio_endio(bio, 0);
+		return DM_MAPIO_SUBMITTED;
+	}
+
+	if (bio->bi_rw & (REQ_DISCARD | REQ_FLUSH | REQ_FUA)) {
+		defer_bio(pool, ti, bio);
+		return DM_MAPIO_SUBMITTED;
+	}
+
+	r = dm_thin_metadata_lookup(msd, block, 0, &result);
+	switch (r) {
+	case 0:
+		if (unlikely(result.shared)) {
+			/*
+			 * We have a race condition here between the
+			 * result.shared value returned by the lookup and
+			 * snapshot creation, which may cause new
+			 * sharing.
+			 *
+			 * To avoid this always quiesce the origin before
+			 * taking the snap.  You want to do this anyway to
+			 * ensure a consistent application view
+			 * (i.e. lockfs).
+			 *
+			 * More distant ancestors are irrelevant, the
+			 * shared flag will be set in their case.
+			 */
+			defer_bio(pool, ti, bio);
+			r = DM_MAPIO_SUBMITTED;
+		} else {
+			remap(pool, bio, result.block);
+			r = DM_MAPIO_REMAPPED;
+		}
+		break;
+
+	case -ENODATA:
+		if (bio_rw(bio) == READA || bio_rw(bio) == READ) {
+			zero_fill_bio(bio);
+			bio_endio(bio, 0);
+		} else
+			defer_bio(pool, ti, bio);
+		r = DM_MAPIO_SUBMITTED;
+		break;
+
+	case -EWOULDBLOCK:
+		defer_bio(pool, ti, bio);
+		r = DM_MAPIO_SUBMITTED;
+		break;
+	}
+
+	return r;
+}
+
+static int is_congested(void *congested_data, int bdi_bits)
+{
+	int r;
+	struct pool_c *pt = congested_data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pt->pool->lock, flags);
+	r = !bio_list_empty(&pt->pool->retry_list);
+	spin_unlock_irqrestore(&pt->pool->lock, flags);
+
+	if (!r) {
+		struct request_queue *q = bdev_get_queue(pt->data_dev->bdev);
+		r = bdi_congested(&q->backing_dev_info, bdi_bits);
+	}
+
+	return r;
+}
+
+static void set_congestion_fn(struct dm_target *ti, struct pool_c *pt)
+{
+	struct mapped_device *md = dm_table_get_md(ti->table);
+	struct backing_dev_info *bdi = &dm_disk(md)->queue->backing_dev_info;
+
+	/* Set congested function and data. */
+	bdi->congested_fn = is_congested;
+	bdi->congested_data = pt;
+}
+
+static void requeue_bios(struct pool *pool)
+{
+	struct bio *bio;
+	struct bio_list bios;
+	unsigned long flags;
+
+	bio_list_init(&bios);
+	spin_lock_irqsave(&pool->lock, flags);
+	bio_list_merge(&bios, &pool->retry_list);
+	bio_list_init(&pool->retry_list);
+	spin_unlock_irqrestore(&pool->lock, flags);
+
+	while ((bio = bio_list_pop(&bios)))
+		bio_list_add(&pool->deferred_bios, bio);
+}
+
+/*----------------------------------------------------------------
+ * Binding of control targets to a pool object
+ *--------------------------------------------------------------*/
+/* FIXME: add locking */
+static int bind_control_target(struct pool *pool, struct dm_target *ti)
+{
+	struct pool_c *pt = ti->private;
+
+	pool->ti = ti;
+	pool->low_water_mark = dm_div_up(pt->low_water_mark,
+					 pool->sectors_per_block);
+	pool->zero_new_blocks = pt->zero_new_blocks;
+	return 0;
+}
+
+static void unbind_control_target(struct pool *pool, struct dm_target *ti)
+{
+	if (pool->ti == ti)
+		pool->ti = NULL;
+}
+
+/*----------------------------------------------------------------
+ * Pool creation
+ *--------------------------------------------------------------*/
+static void pool_destroy(struct pool *pool)
+{
+	if (dm_thin_metadata_close(pool->mmd) < 0)
+		DMWARN("%s: dm_thin_metadata_close() failed.", __func__);
+	blkdev_put(pool->metadata_dev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
+
+	prison_destroy(pool->prison);
+	dm_kcopyd_client_destroy(pool->copier);
+
+	if (pool->producer_wq)
+		destroy_workqueue(pool->producer_wq);
+
+	if (pool->consumer_wq)
+		destroy_workqueue(pool->consumer_wq);
+
+	mempool_destroy(pool->mapping_pool);
+	mempool_destroy(pool->endio_hook_pool);
+	kfree(pool);
+}
+
+/*
+ * The lifetime of the pool object is potentially longer than that of the
+ * pool target.  thin_get_device() is very similar to
+ * dm_get_device() except it doesn't associate the device with the target,
+ * which would prevent the target to be destroyed.
+ */
+static struct block_device *thin_get_device(const char *path, fmode_t mode)
+{
+	dev_t uninitialized_var(dev);
+	unsigned int major, minor;
+	struct block_device *bdev;
+
+	if (sscanf(path, "%u:%u", &major, &minor) == 2) {
+		/* Extract the major/minor numbers */
+		dev = MKDEV(major, minor);
+		if (MAJOR(dev) != major || MINOR(dev) != minor)
+			return ERR_PTR(-EOVERFLOW);
+		bdev = blkdev_get_by_dev(dev, mode, &thin_get_device);
+	} else
+		bdev = blkdev_get_by_path(path, mode, &thin_get_device);
+
+	if (!bdev)
+		return ERR_PTR(-EINVAL);
+
+	return bdev;
+}
+
+static struct pool *pool_create(const char *metadata_path,
+				unsigned long block_size, char **error)
+{
+	int r;
+	void *err_p;
+	struct pool *pool;
+	struct dm_thin_metadata *mmd;
+	struct block_device *metadata_dev;
+	fmode_t metadata_dev_mode = FMODE_READ | FMODE_WRITE | FMODE_EXCL;
+
+	metadata_dev = thin_get_device(metadata_path, metadata_dev_mode);
+	if (IS_ERR(metadata_dev)) {
+		r = PTR_ERR(metadata_dev);
+		*error = "Error opening metadata block device";
+		return ERR_PTR(r);
+	}
+
+	mmd = dm_thin_metadata_open(metadata_dev, block_size);
+	if (IS_ERR(mmd)) {
+		*error = "Error creating metadata object";
+		err_p = mmd; /* already an ERR_PTR */
+		goto bad_mmd_open;
+	}
+
+	pool = kmalloc(sizeof(*pool), GFP_KERNEL);
+	if (!pool) {
+		*error = "Error allocating memory for pool";
+		err_p = ERR_PTR(-ENOMEM);
+		goto bad_pool;
+	}
+
+	pool->metadata_dev = metadata_dev;
+	pool->mmd = mmd;
+	pool->sectors_per_block = block_size;
+	pool->block_shift = ffs(block_size) - 1;
+	pool->offset_mask = block_size - 1;
+	pool->low_water_mark = 0;
+	pool->zero_new_blocks = 1;
+	pool->prison = prison_create(1024); /* FIXME: magic number */
+	if (!pool->prison) {
+		*error = "Error creating pool's bio prison";
+		err_p = ERR_PTR(-ENOMEM);
+		goto bad_prison;
+	}
+
+	pool->copier = dm_kcopyd_client_create();
+	if (IS_ERR(pool->copier)) {
+		r = PTR_ERR(pool->copier);
+		*error = "Error creating pool's kcopyd client";
+		err_p = ERR_PTR(r);
+		goto bad_kcopyd_client;
+	}
+
+	/* Create singlethreaded workqueue that will service all devices
+	 * that use this metadata.
+	 */
+	pool->producer_wq = alloc_ordered_workqueue(DM_MSG_PREFIX "-producer",
+						    WQ_MEM_RECLAIM);
+	if (!pool->producer_wq) {
+		*error = "Error creating pool's producer workqueue";
+		err_p = ERR_PTR(-ENOMEM);
+		goto bad_producer_wq;
+	}
+
+	pool->consumer_wq = alloc_ordered_workqueue(DM_MSG_PREFIX "-consumer",
+						    WQ_MEM_RECLAIM);
+	if (!pool->consumer_wq) {
+		*error = "Error creating pool's consumer workqueue";
+		err_p = ERR_PTR(-ENOMEM);
+		goto bad_consumer_wq;
+	}
+
+	INIT_WORK(&pool->producer, do_producer);
+	INIT_WORK(&pool->consumer, do_consumer);
+	spin_lock_init(&pool->lock);
+	bio_list_init(&pool->deferred_bios);
+	INIT_LIST_HEAD(&pool->prepared_mappings);
+	pool->triggered = 0;
+	bio_list_init(&pool->retry_list);
+	ds_init(&pool->ds);
+	/* FIXME: magic number */
+	pool->mapping_pool =
+		mempool_create_kmalloc_pool(1024, sizeof(struct new_mapping));
+	if (!pool->mapping_pool) {
+		*error = "Error creating pool's mapping mempool";
+		err_p = ERR_PTR(-ENOMEM);
+		goto bad_mapping_pool;
+	}
+	/* FIXME: magic number */
+	pool->endio_hook_pool =
+		mempool_create_kmalloc_pool(10240, sizeof(struct endio_hook));
+	if (!pool->endio_hook_pool) {
+		*error = "Error creating pool's endio_hook mempool";
+		err_p = ERR_PTR(-ENOMEM);
+		goto bad_endio_hook_pool;
+	}
+	atomic_set(&pool->ref_count, 1);
+
+	return pool;
+
+bad_endio_hook_pool:
+	mempool_destroy(pool->mapping_pool);
+bad_mapping_pool:
+	destroy_workqueue(pool->consumer_wq);
+bad_consumer_wq:
+	destroy_workqueue(pool->producer_wq);
+bad_producer_wq:
+	dm_kcopyd_client_destroy(pool->copier);
+bad_kcopyd_client:
+	prison_destroy(pool->prison);
+bad_prison:
+	kfree(pool);
+bad_pool:
+	if (dm_thin_metadata_close(mmd))
+		DMWARN("%s: dm_thin_metadata_close() failed.", __func__);
+bad_mmd_open:
+	blkdev_put(metadata_dev, metadata_dev_mode);
+
+	return err_p;
+}
+
+static void pool_inc(struct pool *pool)
+{
+	atomic_inc(&pool->ref_count);
+}
+
+static void pool_dec(struct pool *pool)
+{
+	if (atomic_dec_and_test(&pool->ref_count))
+		pool_destroy(pool);
+}
+
+static struct pool *pool_find(struct block_device *pool_bdev,
+			      const char *metadata_path,
+			      unsigned long block_size,
+			      char **error)
+{
+	struct pool *pool;
+
+	pool = bdev_table_lookup(&bdev_table_, pool_bdev);
+	if (pool)
+		pool_inc(pool);
+	else
+		pool = pool_create(metadata_path, block_size, error);
+
+	return pool;
+}
+
+/*----------------------------------------------------------------
+ * Pool target methods
+ *--------------------------------------------------------------*/
+static void pool_dtr(struct dm_target *ti)
+{
+	struct pool_c *pt = ti->private;
+
+	dm_put_device(ti, pt->data_dev);
+	unbind_control_target(pt->pool, ti);
+	pool_dec(pt->pool);
+	kfree(pt);
+}
+
+struct pool_features {
+	unsigned zero_new_blocks;
+};
+
+static int parse_pool_features(struct dm_arg_set *as, struct pool_features *pf,
+			       struct dm_target *ti)
+{
+	int r;
+	unsigned argc;
+	const char *arg_name;
+
+	static struct dm_arg _args[] = {
+		{0, 1, "invalid number of pool feature args"},
+	};
+
+	/* No feature arguments supplied. */
+	if (!as->argc)
+		return 0;
+
+	r = dm_read_arg(_args, as, &argc, &ti->error);
+	if (r)
+		return -EINVAL;
+
+	if (argc > as->argc) {
+		ti->error = "not enough arguments for pool features";
+		return -EINVAL;
+	}
+
+	while (argc && !r) {
+		arg_name = dm_shift_arg(as);
+		argc--;
+
+		if (!strcasecmp(arg_name, "skip_block_zeroing")) {
+			pf->zero_new_blocks = 0;
+			continue;
+		}
+
+		ti->error = "Unrecognised pool feature request";
+		r = -EINVAL;
+	}
+
+	return r;
+}
+
+/*
+ * thin-pool <metadata dev>
+ *           <data dev>
+ *           <data block size in sectors>
+ *           <low water mark (sectors)>
+ *           [<#feature args> [<arg>]*]
+ */
+static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
+{
+	int r;
+	struct pool_c *pt;
+	struct pool *pool;
+	struct pool_features pf;
+	struct dm_arg_set as;
+	struct dm_dev *data_dev;
+	unsigned long block_size;
+	dm_block_t low_water;
+	const char *metadata_devname;
+	char *end;
+
+	if (argc < 4) {
+		ti->error = "Invalid argument count";
+		return -EINVAL;
+	}
+	as.argc = argc;
+	as.argv = argv;
+
+	metadata_devname = argv[0];
+
+	r = dm_get_device(ti, argv[1], FMODE_READ | FMODE_WRITE, &data_dev);
+	if (r) {
+		ti->error = "Error getting data device";
+		return r;
+	}
+
+	block_size = simple_strtoul(argv[2], &end, 10);
+	if (!block_size || *end) {
+		ti->error = "Invalid block size";
+		r = -EINVAL;
+		goto out;
+	}
+
+	low_water = simple_strtoull(argv[3], &end, 10);
+	if (!low_water || *end) {
+		ti->error = "Invalid low water mark";
+		r = -EINVAL;
+		goto out;
+	}
+
+	/* set pool feature defaults */
+	memset(&pf, 0, sizeof(pf));
+	pf.zero_new_blocks = 1;
+
+	dm_consume_args(&as, 4);
+	r = parse_pool_features(&as, &pf, ti);
+	if (r)
+		goto out;
+
+	pool = pool_find(get_target_bdev(ti), metadata_devname,
+			 block_size, &ti->error);
+	if (IS_ERR(pool)) {
+		r = PTR_ERR(pool);
+		goto out;
+	}
+
+	pt = kmalloc(sizeof(*pt), GFP_KERNEL);
+	if (!pt) {
+		pool_destroy(pool);
+		r = -ENOMEM;
+		goto out;
+	}
+	pt->pool = pool;
+	pt->ti = ti;
+	pt->data_dev = data_dev;
+	pt->low_water_mark = low_water;
+	pt->zero_new_blocks = pf.zero_new_blocks;
+	ti->num_flush_requests = 1;
+	ti->num_discard_requests = 1;
+	ti->private = pt;
+	set_congestion_fn(ti, pt);
+
+	return 0;
+out:
+	dm_put_device(ti, data_dev);
+	return r;
+}
+
+static int pool_map(struct dm_target *ti, struct bio *bio,
+		    union map_info *map_context)
+{
+	int r;
+	struct pool_c *pt = ti->private;
+	struct pool *pool = pt->pool;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pool->lock, flags);
+	bio->bi_bdev = pt->data_dev->bdev;
+	r = DM_MAPIO_REMAPPED;
+	spin_unlock_irqrestore(&pool->lock, flags);
+
+	return r;
+}
+
+/*
+ * Retrieves the number of blocks of the data device from
+ * the superblock and compares it to the actual device size,
+ * thus resizing the data device in case it has grown.
+ *
+ * This both copes with opening preallocated data devices in the ctr
+ * being followed by a resume
+ * -and-
+ * calling the resume method individually after userspace has
+ * grown the data device in reaction to a table event.
+ */
+static int pool_preresume(struct dm_target *ti)
+{
+	int r;
+	struct pool_c *pt = ti->private;
+	struct pool *pool = pt->pool;
+	dm_block_t data_size, sb_data_size;
+	unsigned long flags;
+
+	/* take control of the pool object */
+	r = bind_control_target(pool, ti);
+	if (r)
+		return r;
+
+	data_size = ti->len >> pool->block_shift;
+	r = dm_thin_metadata_get_data_dev_size(pool->mmd, &sb_data_size);
+	if (r) {
+		DMERR("failed to retrieve data device size");
+		return r;
+	}
+
+	if (data_size < sb_data_size) {
+		DMERR("pool target too small, is %llu blocks (expected %llu)",
+		      data_size, sb_data_size);
+		return -EINVAL;
+
+	} else if (data_size > sb_data_size) {
+		r = dm_thin_metadata_resize_data_dev(pool->mmd, data_size);
+		if (r) {
+			DMERR("failed to resize data device");
+			return r;
+		}
+
+		r = dm_thin_metadata_commit(pool->mmd);
+		if (r) {
+			DMERR("%s: dm_thin_metadata_commit() failed, error = %d",
+			      __func__, r);
+			return r;
+		}
+	}
+
+	spin_lock_irqsave(&pool->lock, flags);
+	pool->triggered = 0;
+	spin_unlock_irqrestore(&pool->lock, flags);
+
+	requeue_bios(pool);
+	wake_producer(pool);
+
+	/* The pool object is only present if the pool is active */
+	pool->pool_dev = get_target_bdev(ti);
+	bdev_table_insert(&bdev_table_, pool);
+
+	return 0;
+}
+
+static void pool_presuspend(struct dm_target *ti)
+{
+	int r;
+	struct pool_c *pt = ti->private;
+	struct pool *pool = pt->pool;
+
+	r = dm_thin_metadata_commit(pool->mmd);
+	if (r < 0) {
+		DMERR("%s: dm_thin_metadata_commit() failed, error = %d",
+		      __func__, r);
+		/* FIXME: invalidate device? error the next FUA or FLUSH bio ?*/
+	}
+}
+
+static void pool_postsuspend(struct dm_target *ti)
+{
+	struct pool_c *pt = ti->private;
+	struct pool *pool = pt->pool;
+
+	bdev_table_remove(&bdev_table_, pool);
+	pool->pool_dev = NULL;
+}
+
+/*
+ * Messages supported:
+ *   new-thin        <dev id>
+ *   new-snap        <dev id> <origin id>
+ *   del             <dev id>
+ *   trim            <dev id> <size in sectors>
+ *   trans-id        <current trans id> <new trans id>
+ */
+static int pool_message(struct dm_target *ti, unsigned argc, char **argv)
+{
+	/* ti->error doesn't have a const qualifier :( */
+	char *invalid_args = "Incorrect number of arguments";
+
+	int r;
+	struct pool_c *pt = ti->private;
+	struct pool *pool = pt->pool;
+	dm_thin_dev_t dev_id;
+	char *end;
+
+	if (!strcmp(argv[0], "new-thin")) {
+		if (argc != 2) {
+			ti->error = invalid_args;
+			return -EINVAL;
+		}
+
+		dev_id = simple_strtoull(argv[1], &end, 10);
+		if (*end) {
+			ti->error = "Invalid device id";
+			return -EINVAL;
+		}
+
+		r = dm_thin_metadata_create_thin(pool->mmd, dev_id);
+		if (r) {
+			ti->error = "Creation of thin provisioned device failed";
+			return r;
+		}
+
+	} else if (!strcmp(argv[0], "new-snap")) {
+		dm_thin_dev_t origin_id;
+
+		if (argc != 3) {
+			ti->error = invalid_args;
+			return -EINVAL;
+		}
+
+		dev_id = simple_strtoull(argv[1], &end, 10);
+		if (*end) {
+			ti->error = "Invalid device id";
+			return -EINVAL;
+		}
+
+		origin_id = simple_strtoull(argv[2], &end, 10);
+		if (*end) {
+			ti->error = "Invalid origin id";
+			return -EINVAL;
+		}
+
+		r = dm_thin_metadata_create_snap(pool->mmd, dev_id, origin_id);
+		if (r) {
+			ti->error = "Creation of snapshot failed";
+			return r;
+		}
+
+	} else if (!strcmp(argv[0], "del")) {
+		if (argc != 2) {
+			ti->error = invalid_args;
+			return -EINVAL;
+		}
+
+		dev_id = simple_strtoull(argv[1], &end, 10);
+		if (*end) {
+			ti->error = "Invalid device id";
+			return -EINVAL;
+		}
+
+		r = dm_thin_metadata_delete_device(pool->mmd, dev_id);
+
+	} else if (!strcmp(argv[0], "trim")) {
+		sector_t new_size;
+
+		if (argc != 3) {
+			ti->error = invalid_args;
+			return -EINVAL;
+		}
+
+		dev_id = simple_strtoull(argv[1], &end, 10);
+		if (*end) {
+			ti->error = "Invalid device id";
+			return -EINVAL;
+		}
+
+		new_size = simple_strtoull(argv[2], &end, 10);
+		if (*end) {
+			ti->error = "Invalid size";
+			return -EINVAL;
+		}
+
+		r = dm_thin_metadata_trim_thin_dev(
+			pool->mmd, dev_id,
+			dm_div_up(new_size, pool->sectors_per_block));
+		if (r) {
+			ti->error = "Couldn't trim thin device";
+			return r;
+		}
+
+	} else if (!strcmp(argv[0], "trans-id")) {
+		uint64_t old_id, new_id;
+
+		if (argc != 3) {
+			ti->error = invalid_args;
+			return -EINVAL;
+		}
+
+		old_id = simple_strtoull(argv[1], &end, 10);
+		if (*end) {
+			ti->error = "Invalid current transaction id";
+			return -EINVAL;
+		}
+
+		new_id = simple_strtoull(argv[2], &end, 10);
+		if (*end) {
+			ti->error = "Invalid new transaction id";
+			return -EINVAL;
+		}
+
+		r = dm_thin_metadata_set_transaction_id(pool->mmd,
+							old_id, new_id);
+		if (r) {
+			ti->error = "Setting userspace transaction id failed";
+			return r;
+		}
+	} else
+		return -EINVAL;
+
+	if (!r) {
+		r = dm_thin_metadata_commit(pool->mmd);
+		if (r)
+			DMERR("%s: dm_thin_metadata_commit() failed, error = %d",
+			      __func__, r);
+	}
+
+	return r;
+}
+
+static int pool_status(struct dm_target *ti, status_type_t type,
+		       char *result, unsigned maxlen)
+{
+	int r;
+	unsigned sz = 0;
+	uint64_t transaction_id;
+	dm_block_t nr_free_blocks_data;
+	dm_block_t nr_free_blocks_metadata;
+	dm_block_t held_root;
+	char buf[BDEVNAME_SIZE];
+	char buf2[BDEVNAME_SIZE];
+	struct pool_c *pt = ti->private;
+	struct pool *pool = pt->pool;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		r = dm_thin_metadata_get_transaction_id(pool->mmd,
+							&transaction_id);
+		if (r)
+			return r;
+
+		r = dm_thin_metadata_get_free_blocks(pool->mmd,
+						     &nr_free_blocks_data);
+		if (r)
+			return r;
+
+		r = dm_thin_metadata_get_free_blocks_metadata(pool->mmd,
+							      &nr_free_blocks_metadata);
+		if (r)
+			return r;
+
+		r = dm_thin_metadata_get_held_root(pool->mmd, &held_root);
+		if (r)
+			return r;
+
+		DMEMIT("%llu %llu %llu ", transaction_id,
+		       nr_free_blocks_data * pool->sectors_per_block,
+		       nr_free_blocks_metadata * pool->sectors_per_block);
+
+		if (held_root)
+			DMEMIT("%llu", held_root);
+		else
+			DMEMIT("-");
+
+		break;
+
+	case STATUSTYPE_TABLE:
+		DMEMIT("%s %s %lu %lu ",
+		       format_dev_t(buf, pool->metadata_dev->bd_dev),
+		       format_dev_t(buf2, pt->data_dev->bdev->bd_dev),
+		       (unsigned long) pool->sectors_per_block,
+		       (unsigned long) pt->low_water_mark);
+
+		DMEMIT("%u ", !pool->zero_new_blocks);
+
+		if (!pool->zero_new_blocks)
+			DMEMIT("skip_block_zeroing ");
+		break;
+	}
+
+	return 0;
+}
+
+static int pool_iterate_devices(struct dm_target *ti,
+				iterate_devices_callout_fn fn, void *data)
+{
+	struct pool_c *pt = ti->private;
+	return fn(ti, pt->data_dev, 0, ti->len, data);
+}
+
+static int pool_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
+		      struct bio_vec *biovec, int max_size)
+{
+	struct pool_c *pt = ti->private;
+	struct request_queue *q = bdev_get_queue(pt->data_dev->bdev);
+
+	if (!q->merge_bvec_fn)
+		return max_size;
+
+	bvm->bi_bdev = pt->data_dev->bdev;
+	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
+}
+
+static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
+{
+	struct pool_c *pt = ti->private;
+	struct pool *pool = pt->pool;
+
+	blk_limits_io_min(limits, 0);
+	blk_limits_io_opt(limits, pool->sectors_per_block << SECTOR_SHIFT);
+}
+
+static struct target_type pool_target = {
+	.name = "thin-pool",
+	.version = {1, 0, 0},
+	.module = THIS_MODULE,
+	.ctr = pool_ctr,
+	.dtr = pool_dtr,
+	.map = pool_map,
+	.presuspend = pool_presuspend,
+	.postsuspend = pool_postsuspend,
+	.preresume = pool_preresume,
+	.message = pool_message,
+	.status = pool_status,
+	.merge = pool_merge,
+	.iterate_devices = pool_iterate_devices,
+	.io_hints = pool_io_hints,
+};
+
+/*----------------------------------------------------------------*/
+
+static void thin_dtr(struct dm_target *ti)
+{
+	struct thin_c *mc = ti->private;
+
+	pool_dec(mc->pool);
+	dm_thin_metadata_close_device(mc->msd);
+	dm_put_device(ti, mc->pool_dev);
+	kfree(mc);
+}
+
+/*
+ * Construct a thin device:
+ *
+ * <start> <length> thin <pool dev> <dev id>
+ *
+ * pool dev: the path to the pool (eg, /dev/mapper/my_pool)
+ * dev id: the internal device identifier
+ */
+static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
+{
+	int r;
+	struct thin_c *mc;
+	struct dm_dev *pool_dev;
+	char *end;
+
+	if (argc != 2) {
+		ti->error = "Invalid argument count";
+		return -EINVAL;
+	}
+
+	mc = ti->private = kzalloc(sizeof(*mc), GFP_KERNEL);
+	if (!mc) {
+		ti->error = "Out of memory";
+		return -ENOMEM;
+	}
+
+	r = dm_get_device(ti, argv[0], FMODE_READ | FMODE_WRITE, &pool_dev);
+	if (r) {
+		ti->error = "Error opening pool device";
+		goto bad_pool_dev;
+	}
+	mc->pool_dev = pool_dev;
+
+	mc->dev_id = simple_strtoull(argv[1], &end, 10);
+	if (*end) {
+		ti->error = "Invalid device id";
+		r = -EINVAL;
+		goto bad_dev_id;
+	}
+
+	mc->pool = bdev_table_lookup(&bdev_table_, mc->pool_dev->bdev);
+	if (!mc->pool) {
+		ti->error = "Couldn't find pool object";
+		r = -EINVAL;
+		goto bad_pool_lookup;
+	}
+	pool_inc(mc->pool);
+
+	r = dm_thin_metadata_open_device(mc->pool->mmd, mc->dev_id, &mc->msd);
+	if (r) {
+		ti->error = "Couldn't open thin internal device";
+		goto bad_thin_open;
+	}
+
+	ti->split_io = mc->pool->sectors_per_block;
+	ti->num_flush_requests = 1;
+	ti->num_discard_requests = 1;
+
+	return 0;
+
+bad_thin_open:
+	pool_dec(mc->pool);
+bad_pool_lookup:
+bad_dev_id:
+	dm_put_device(ti, mc->pool_dev);
+bad_pool_dev:
+	kfree(mc);
+
+	return r;
+}
+
+static int thin_map(struct dm_target *ti, struct bio *bio,
+		    union map_info *map_context)
+{
+	struct thin_c *mc = ti->private;
+
+	bio->bi_sector -= ti->begin;
+	return bio_map(mc->pool, ti, bio);
+}
+
+static int thin_status(struct dm_target *ti, status_type_t type,
+		       char *result, unsigned maxlen)
+{
+	int r;
+	ssize_t sz = 0;
+	dm_block_t mapped, highest;
+	char buf[BDEVNAME_SIZE];
+	struct thin_c *mc = ti->private;
+
+	if (mc->msd) {
+		switch (type) {
+		case STATUSTYPE_INFO:
+			r = dm_thin_metadata_get_mapped_count(mc->msd,
+							      &mapped);
+			if (r)
+				return r;
+
+			r = dm_thin_metadata_get_highest_mapped_block(mc->msd,
+								      &highest);
+			if (r < 0)
+				return r;
+
+			DMEMIT("%llu ", mapped * mc->pool->sectors_per_block);
+			if (r)
+				DMEMIT("%llu", ((highest + 1) *
+						mc->pool->sectors_per_block) - 1);
+			else
+				DMEMIT("-");
+			break;
+
+		case STATUSTYPE_TABLE:
+			DMEMIT("%s %lu",
+			       format_dev_t(buf, mc->pool_dev->bdev->bd_dev),
+			       (unsigned long) mc->dev_id);
+			break;
+		}
+	} else {
+		DMEMIT("-");
+	}
+
+	return 0;
+}
+
+static int thin_bvec_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
+			   struct bio_vec *biovec, int max_size)
+{
+	struct thin_c *mc = ti->private;
+	struct pool *pool = mc->pool;
+
+	/*
+	 * We fib here, because the space may not have been provisioned yet
+	 * we can't give a good answer.  It's better to return the block
+	 * size, and incur extra splitting in a few cases than always
+	 * return the smallest, page sized, chunk.
+	 */
+	return pool->sectors_per_block << SECTOR_SHIFT;
+}
+
+static int thin_iterate_devices(struct dm_target *ti,
+				iterate_devices_callout_fn fn, void *data)
+{
+	struct thin_c *mc = ti->private;
+	struct pool *pool;
+
+	pool = bdev_table_lookup(&bdev_table_, mc->pool_dev->bdev);
+	if (!pool) {
+		DMERR("%s: Couldn't find pool object", __func__);
+		return -EINVAL;
+	}
+
+	return fn(ti, mc->pool_dev, 0, pool->sectors_per_block, data);
+}
+
+static void thin_io_hints(struct dm_target *ti, struct queue_limits *limits)
+{
+	struct thin_c *mc = ti->private;
+	struct pool *pool;
+
+	pool = bdev_table_lookup(&bdev_table_, mc->pool_dev->bdev);
+	if (!pool) {
+		DMERR("%s: Couldn't find pool object", __func__);
+		return;
+	}
+
+	blk_limits_io_min(limits, 0);
+	blk_limits_io_opt(limits, pool->sectors_per_block << SECTOR_SHIFT);
+
+	/*
+	 * Only allow discard requests aligned to our block size, and make
+	 * sure that we never get sent larger discard requests either.
+	 */
+	limits->max_discard_sectors = pool->sectors_per_block;
+	limits->discard_granularity = pool->sectors_per_block << SECTOR_SHIFT;
+}
+
+static struct target_type thin_target = {
+	.name = "thin",
+	.version = {1, 0, 0},
+	.module	= THIS_MODULE,
+	.ctr = thin_ctr,
+	.dtr = thin_dtr,
+	.map = thin_map,
+	.status = thin_status,
+	.merge = thin_bvec_merge,
+	.iterate_devices = thin_iterate_devices,
+	.io_hints = thin_io_hints,
+};
+
+/*----------------------------------------------------------------*/
+
+static int __init dm_thin_init(void)
+{
+	int r = dm_register_target(&thin_target);
+	if (r)
+		return r;
+
+	r = dm_register_target(&pool_target);
+	if (r)
+		dm_unregister_target(&thin_target);
+
+	bdev_table_init(&bdev_table_);
+	return r;
+}
+
+static void dm_thin_exit(void)
+{
+	dm_unregister_target(&thin_target);
+	dm_unregister_target(&pool_target);
+}
+
+module_init(dm_thin_init);
+module_exit(dm_thin_exit);
+
+MODULE_DESCRIPTION(DM_NAME "device-mapper thin provisioning target");
+MODULE_AUTHOR("Joe Thornber <thornber@redhat.com>");
+MODULE_LICENSE("GPL");
+
+/*----------------------------------------------------------------*/
-- 
1.7.1
