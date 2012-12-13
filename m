From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 8/8] [dm-cache] cache target
Date: Thu, 13 Dec 2012 20:19:16 +0000
Message-ID: <1355429956-22785-9-git-send-email-ejt@redhat.com>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1355429956-22785-1-git-send-email-ejt@redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

---
 Documentation/device-mapper/dm-cache.txt      |  209 +++
 drivers/md/Kconfig                            |   22 +
 drivers/md/Makefile                           |    6 +
 drivers/md/dm-cache-metadata.c                | 1135 ++++++++++++
 drivers/md/dm-cache-metadata.h                |  170 ++
 drivers/md/dm-cache-policy-cleaner.c          |  482 +++++
 drivers/md/dm-cache-policy-internal.h         |  120 ++
 drivers/md/dm-cache-policy-mq.c               | 1254 +++++++++++++
 drivers/md/dm-cache-policy.c                  |  147 ++
 drivers/md/dm-cache-policy.h                  |  220 +++
 drivers/md/dm-cache-target.c                  | 2443 +++++++++++++++++++++++++
 drivers/md/persistent-data/dm-block-manager.c |    1 +
 12 files changed, 6209 insertions(+)
 create mode 100644 Documentation/device-mapper/dm-cache.txt
 create mode 100644 drivers/md/dm-cache-metadata.c
 create mode 100644 drivers/md/dm-cache-metadata.h
 create mode 100644 drivers/md/dm-cache-policy-cleaner.c
 create mode 100644 drivers/md/dm-cache-policy-internal.h
 create mode 100644 drivers/md/dm-cache-policy-mq.c
 create mode 100644 drivers/md/dm-cache-policy.c
 create mode 100644 drivers/md/dm-cache-policy.h
 create mode 100644 drivers/md/dm-cache-target.c

diff --git a/Documentation/device-mapper/dm-cache.txt b/Documentation/device-mapper/dm-cache.txt
new file mode 100644
index 0000000..9abcd93
--- /dev/null
+++ b/Documentation/device-mapper/dm-cache.txt
@@ -0,0 +1,209 @@
+* Introduction
+
+dm-cache is a device mapper target written by Joe Thornber, Heinz
+Maueslhagen, and Mike Snitzer.
+
+It aims to improve performance of a block device (eg, a spindle) by
+dynamically migrating some of its data to a faster, smaller device
+(eg, an SSD).
+
+There are various caching solutions out there, for example bcache, we
+feel there is a need for a purely device-mapper solution that allows
+us to insert this caching at different levels of the dm stack.  For
+instance above the data device for a thin-provisioning pool.  Caching
+solutions that are integrated more closely with the virtual memory
+system should give better performance.
+
+The target reuses the metadata library used in the thin-provisioning
+library.
+
+The decision of what and when to migrate data is left to a plug-in
+policy module.  Several of these have been written as we experiment,
+and we hope other people will contribute others for specific io
+scenarios (eg. a vm image server).
+
+* Glossary
+
+- Migration -  Movement of a logical block from one device to the other.
+- Promotion -  Migration from slow device to fast device.
+- Demotion  -  Migration from fast device to slow device.
+
+* Design
+
+** Sub devices
+
+The target is constructed by passing three devices to it (along with
+other params detailed later):
+
+- An origin device (the big, slow one).
+
+- A cache device (the small, fast one).
+
+- A small metadata device.
+
+  Device that records which blocks are in the cache.  Which are dirty,
+  and extra hints for use by the policy object.
+
+  This information could be put on the cache device, but having it
+  separate allows the volume manager to configure it differently.  eg,
+  as a mirror for extra robustness.
+
+
+** Fixed block size
+
+The origin is divided up into blocks of a fixed size.  This block size
+is configurable when you first create the cache.  Typically we've been
+using block sizes of 256k - 1024k.
+
+Having a fixed block size simplifies the target a lot.  But it is
+something of a compromise.  For instance a small part of a block may
+be getting hit a lot (eg, /etc/passwd), yet the whole block will be
+promoted to the cache.  So large block sizes are bad, because they
+waste cache space.  And small block sizes are bad because they
+increase the amount of metadata (both in core and on disk).
+
+** Writeback/writethrough
+
+The cache has these two modes.
+
+If writeback is selected then writes to blocks that are cached will
+only go to the cache, and the block will be marked dirty in the
+metadata.
+
+If writethrough mode is selected then a write to a cached block will
+not complete until has hit both the origin and cache device.  Clean
+blocks should remain clean.
+
+A simple cleaner policy is provided, which will clean all dirty blocks
+in a cache.  Useful for decommissioning a cache.
+
+** Migration throttling
+
+Migrating data between the origin and cache device uses bandwidth.
+The user can set a throttle to prevent more than a certain amount of
+migrations occuring at any one time.  Currently we're not taking any
+account of normal io traffic going to the devs.  More work needs to be
+done here to avoid migrating during those peak io moments.
+
+** Updating on disk metadata
+
+On disk metadata is committed everytime a REQ_SYNC or REQ_FUA bio is
+written.  If no such requests are made then commits will occur every
+second.  This means the cache behaves like a physical disk that has a
+write cache (the same is true of the thin-provisioning target).  If
+power is lost you may lose some recent writes.  The metadata should
+always be consistent in spite of a crash.
+
+The 'dirty' state for a cache block changes far too frequently for us
+to keep updating it on the fly.  So we treat it as a hint.  In normal
+operation it will be written when the dm device is suspended.  If the
+system crashes all cache blocks will be assumed dirty when restarted.
+
+** per block policy hints
+
+Policy plug-ins can store a chunk of data per cache block.  It's up to
+the policy how big this chunk is (please keep it small).  Like the
+dirty flags this data is lost if there's a crash so a safe fallback
+value should always be possible.
+
+For instance the 'mq' policy, which is currently the default policy,
+uses this facility to store the hit count of the cache blocks.  If
+there's a crash this information will be lost, which means the cache
+may be less efficient until those hit counts are regenerated.
+
+Policy hints effect performance, not correctness.
+
+** Policy messaging
+
+Policies will have different tunables, specific to each one.  So we
+need a generic way of getting and setting these.  One way would be
+through a sysfs interface; much as we do with a block device's queue
+parameters.  Another is to use the device-mapper message facility.
+We're using that latter method currently, though don't feel strongly
+one way or the other.
+
+** discard bitset resolution
+
+We can avoid copying data during migration if we know the block has
+been discarded.  A prime example of this is when mkfs discards the
+whole block device.  We store a bitset tracking the discard state of
+blocks.  However, we allow this bitset to have a different block size
+from the cache blocks.  This is because we need to track the discard
+state for all of the origin device (compare with the dirty bitset
+which is just for the smaller cache device).
+
+** Target interface
+
+ cache <metadata dev>
+       <cache dev>
+       <origin dev>
+       <block size>
+       <#feature args> [<feature arg>]*
+       <policy>
+       <#policy args>
+       [policy args]*
+
+ metadata dev    : fast device holding the persistent metadata
+ cache dev	 : fast device holding cached data blocks
+ origin dev	 : slow device holding original data blocks
+ block size      : cache unit size in sectors
+ policy          : the replacement policy to use
+
+ #feature args   : number of feature arguments passed
+ feature args    : 'writeback' or 'writethrough' (one or the other).
+
+ #policy args    : an even number of arguments corresponding to
+                   key/value pairs passed to the policy.
+ policy args     : key/value pairs (eg, 'migration_threshold 1024000')
+
+A policy called 'default' is always registered.  This is an alias for
+the policy we currently think is giving best all round performance.
+
+* Example usage
+
+The test suite can be found here:
+
+https://github.com/jthornber/thinp-test-suite
+
+0 41943040 cache /dev/mapper/metadata /dev/mapper/ssd /dev/mapper/origin 512 1 writeback default 0
+
+* Policy interface
+
+- Try to keep transactionality out of it.  The core is careful to
+  avoid asking about anything that is migrating.  This is a pain, but
+  makes it easier to write the policies.
+
+- Mappings are loaded into the policy at construction time.
+
+- Every bio that is mapped by the target is referred to the policy, it
+  can give a simple HIT or MISS or issue a migration.
+
+- Currently there's no way for the policy to issue background work,
+  eg, start writing back dirty blocks that are soon going to be evicted.
+
+- Because we map bios, rather than requests it's easy for the policy
+  to get fooled by many small bios.  For this reason the core target
+  issues periodic ticks to the policy.  It's suggested that the policy
+  doesn't update states (eg, hit counts) for a block more than once
+  for each tick.  [The core ticks by watching bios complete, and so
+  trying to see when the io scheduler has let the ios run]
+
+
+	void (*destroy)(struct dm_cache_policy *p);
+	void (*map)(struct dm_cache_policy *p, dm_block_t origin_block, int data_dir,
+		    bool can_migrate, bool cheap_copy, struct bio *bio,
+		    struct policy_result *result);
+
+	int (*load_mapping)(struct dm_cache_policy *p, dm_block_t oblock, dm_block_t cblock);
+
+	/* must succeed */
+	void (*remove_mapping)(struct dm_cache_policy *p, dm_block_t oblock);
+	void (*force_mapping)(struct dm_cache_policy *p, dm_block_t current_oblock,
+			      dm_block_t new_oblock);
+
+	dm_block_t (*residency)(struct dm_cache_policy *p);
+	void (*set_seq_io_threshold)(struct dm_cache_policy *p,
+				     unsigned int seq_io_thresh);
+
+	void (*tick)(struct dm_cache_policy *p);
+
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 91a02ee..7974c8b 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -268,6 +268,28 @@ config DM_DEBUG_BLOCK_STACK_TRACING
 
 	  If unsure, say N.
 
+config DM_CACHE
+       tristate "Cache target (EXPERIMENTAL)"
+       depends on BLK_DEV_DM && EXPERIMENTAL
+       select DM_PERSISTENT_DATA
+       select DM_PRISON
+       ---help---
+         Use an SSD to speed up a slower device.
+
+config DM_CACHE_MQ
+       tristate "MQ Cache Policy (EXPERIMENTAL)"
+       depends on DM_CACHE
+       default y
+       ---help---
+         Under development
+
+config DM_CACHE_CLEANER
+       tristate "Cleaner Cache Policy (EXPERIMENTAL)"
+       depends on DM_CACHE
+       default y
+       ---help---
+         Under development
+
 config DM_MIRROR
        tristate "Mirror target"
        depends on BLK_DEV_DM
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 94dce8b..b9964d0 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -11,6 +11,9 @@ dm-mirror-y	+= dm-raid1.o
 dm-log-userspace-y \
 		+= dm-log-userspace-base.o dm-log-userspace-transfer.o
 dm-thin-pool-y	+= dm-thin.o dm-thin-metadata.o
+dm-cache-y	+= dm-cache-target.o dm-cache-metadata.o dm-cache-policy.o
+dm-cache-mq-y   += dm-cache-policy-mq.o
+dm-cache-cleaner-y += dm-cache-policy-cleaner.o
 md-mod-y	+= md.o bitmap.o
 raid456-y	+= raid5.o
 
@@ -43,6 +46,9 @@ obj-$(CONFIG_DM_LOG_USERSPACE)	+= dm-log-userspace.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
 obj-$(CONFIG_DM_RAID)	+= dm-raid.o
 obj-$(CONFIG_DM_THIN_PROVISIONING)	+= dm-thin-pool.o
+obj-$(CONFIG_DM_CACHE)		+= dm-cache.o
+obj-$(CONFIG_DM_CACHE_MQ)	+= dm-cache-mq.o
+obj-$(CONFIG_DM_CACHE_CLEANER) += dm-cache-cleaner.o
 obj-$(CONFIG_DM_VERITY)		+= dm-verity.o
 
 ifeq ($(CONFIG_DM_UEVENT),y)
diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
new file mode 100644
index 0000000..b5f459c
--- /dev/null
+++ b/drivers/md/dm-cache-metadata.c
@@ -0,0 +1,1135 @@
+/*
+ * Copyright (C) 2012 Red Hat, Inc.
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm-cache-metadata.h"
+
+#include "persistent-data/dm-array.h"
+#include "persistent-data/dm-bitset.h"
+#include "persistent-data/dm-space-map.h"
+#include "persistent-data/dm-space-map-disk.h"
+#include "persistent-data/dm-transaction-manager.h"
+
+#include <linux/device-mapper.h>
+
+/*----------------------------------------------------------------*/
+
+//#define debug(x...) pr_alert(x)
+#define debug(x...) ;
+
+#define DM_MSG_PREFIX   "cache metadata"
+
+#define CACHE_SUPERBLOCK_MAGIC 06142003
+#define CACHE_SUPERBLOCK_LOCATION 0
+#define CACHE_VERSION 1
+#define CACHE_METADATA_CACHE_SIZE 64
+
+/*
+ *  3 for btree insert +
+ *  2 for btree lookup used within space map
+ */
+#define CACHE_MAX_CONCURRENT_LOCKS 5
+#define SPACE_MAP_ROOT_SIZE 128
+
+enum superblock_flag_bits {
+	/* for spotting crashes that would invalidate the dirty bitset */
+	CLEAN_SHUTDOWN,
+};
+
+/*
+ * Each mapping from cache block -> origin block carries a set of flags.
+ */
+enum mapping_bits {
+	/*
+	 * A valid mapping.  Because we're using an array we clear this
+	 * flag for an non existant mapping.
+	 */
+	M_VALID = 1,
+
+	/*
+	 * The data on the cache is different from that on the origin.
+	 */
+	M_DIRTY = 2
+};
+
+struct cache_disk_superblock {
+	__le32 csum;
+	__le32 flags;
+	__le64 blocknr;
+
+	__u8 uuid[16];
+	__le64 magic;
+	__le32 version;
+
+	__u8 policy_name[CACHE_POLICY_NAME_SIZE];
+
+	__u8 metadata_space_map_root[SPACE_MAP_ROOT_SIZE];
+	__le64 mapping_root;
+	__le64 hint_root;
+
+	__le64 discard_root;
+	__le64 discard_block_size;
+	__le64 discard_nr_blocks;
+
+	__le32 data_block_size;
+	__le32 metadata_block_size;
+	__le32 cache_blocks;
+
+	__le32 compat_flags;
+	__le32 compat_ro_flags;
+	__le32 incompat_flags;
+
+	__le32 read_hits;
+	__le32 read_misses;
+	__le32 write_hits;
+	__le32 write_misses;
+} __packed;
+
+struct dm_cache_metadata {
+	struct block_device *bdev;
+	struct dm_block_manager *bm;
+	struct dm_space_map *metadata_sm;
+	struct dm_transaction_manager *tm;
+
+	struct dm_array_info info;
+	struct dm_array_info hint_info;
+	struct dm_bitset_info discard_info;
+
+	struct rw_semaphore root_lock;
+	dm_block_t root;
+	dm_block_t hint_root;
+	dm_block_t discard_root;
+
+	sector_t discard_block_size;
+	dm_dblock_t discard_nr_blocks;
+
+	sector_t data_block_size;
+	dm_cblock_t cache_blocks;
+	bool changed:1;
+	bool clean_when_opened:1;
+
+	char policy_name[CACHE_POLICY_NAME_SIZE];
+	struct dm_cache_statistics stats;
+};
+
+/*-------------------------------------------------------------------
+ * superblock validator
+ *-----------------------------------------------------------------*/
+
+#define SUPERBLOCK_CSUM_XOR 9031977
+
+static void sb_prepare_for_write(struct dm_block_validator *v,
+				 struct dm_block *b,
+				 size_t block_size)
+{
+	struct cache_disk_superblock *disk_super = dm_block_data(b);
+
+	disk_super->blocknr = cpu_to_le64(dm_block_location(b));
+	disk_super->csum = cpu_to_le32(dm_bm_checksum(&disk_super->flags,
+						      block_size - sizeof(__le32),
+						      SUPERBLOCK_CSUM_XOR));
+}
+
+static int sb_check(struct dm_block_validator *v,
+		    struct dm_block *b,
+		    size_t block_size)
+{
+	struct cache_disk_superblock *disk_super = dm_block_data(b);
+	__le32 csum_le;
+
+	if (dm_block_location(b) != le64_to_cpu(disk_super->blocknr)) {
+		DMERR("sb_check failed: blocknr %llu: "
+		      "wanted %llu", le64_to_cpu(disk_super->blocknr),
+		      (unsigned long long)dm_block_location(b));
+		return -ENOTBLK;
+	}
+
+	if (le64_to_cpu(disk_super->magic) != CACHE_SUPERBLOCK_MAGIC) {
+		DMERR("sb_check failed: magic %llu: "
+		      "wanted %llu", le64_to_cpu(disk_super->magic),
+		      (unsigned long long)CACHE_SUPERBLOCK_MAGIC);
+		return -EILSEQ;
+	}
+
+	csum_le = cpu_to_le32(dm_bm_checksum(&disk_super->flags,
+					     block_size - sizeof(__le32),
+					     SUPERBLOCK_CSUM_XOR));
+	if (csum_le != disk_super->csum) {
+		DMERR("sb_check failed: csum %u: wanted %u",
+		      le32_to_cpu(csum_le), le32_to_cpu(disk_super->csum));
+		return -EILSEQ;
+	}
+
+	return 0;
+}
+
+static struct dm_block_validator sb_validator = {
+	.name = "superblock",
+	.prepare_for_write = sb_prepare_for_write,
+	.check = sb_check
+};
+
+/*----------------------------------------------------------------*/
+
+static int superblock_read_lock(struct dm_cache_metadata *cmd,
+				struct dm_block **sblock)
+{
+	return dm_bm_read_lock(cmd->bm, CACHE_SUPERBLOCK_LOCATION,
+			       &sb_validator, sblock);
+}
+
+static int superblock_lock_zero(struct dm_cache_metadata *cmd,
+				struct dm_block **sblock)
+{
+	return dm_bm_write_lock_zero(cmd->bm, CACHE_SUPERBLOCK_LOCATION,
+				     &sb_validator, sblock);
+}
+
+static int superblock_lock(struct dm_cache_metadata *cmd,
+			   struct dm_block **sblock)
+{
+	return dm_bm_write_lock(cmd->bm, CACHE_SUPERBLOCK_LOCATION,
+				&sb_validator, sblock);
+}
+
+/*----------------------------------------------------------------*/
+
+static int __superblock_all_zeroes(struct dm_block_manager *bm, int *result)
+{
+	int r;
+	unsigned i;
+	struct dm_block *b;
+	__le64 *data_le, zero = cpu_to_le64(0);
+	unsigned block_size = dm_bm_block_size(bm) / sizeof(__le64);
+
+	/*
+	 * We can't use a validator here - it may be all zeroes.
+	 */
+	r = dm_bm_read_lock(bm, CACHE_SUPERBLOCK_LOCATION, NULL, &b);
+	if (r)
+		return r;
+
+	data_le = dm_block_data(b);
+	*result = 1;
+	for (i = 0; i < block_size; i++) {
+		if (data_le[i] != zero) {
+			*result = 0;
+			break;
+		}
+	}
+
+	return dm_bm_unlock(b);
+}
+
+static void __setup_mapping_info(struct dm_cache_metadata *cmd)
+{
+	struct dm_btree_value_type vt;
+
+	vt.context = NULL;
+	vt.size = sizeof(__le64);
+	vt.inc = NULL;
+	vt.dec = NULL;
+	vt.equal = NULL;
+	dm_setup_array_info(&cmd->info, cmd->tm, &vt);
+
+	vt.size = sizeof(__le32);
+	dm_setup_array_info(&cmd->hint_info, cmd->tm, &vt);
+}
+
+static int __write_initial_superblock(struct dm_cache_metadata *cmd)
+{
+	int r;
+	struct dm_block *sblock;
+	size_t metadata_len;
+	struct cache_disk_superblock *disk_super;
+	sector_t bdev_size = i_size_read(cmd->bdev->bd_inode) >> SECTOR_SHIFT;
+
+	/* FIXME: see if we can lose the max sectors limit */
+	if (bdev_size > CACHE_METADATA_MAX_SECTORS)
+		bdev_size = CACHE_METADATA_MAX_SECTORS;
+
+	r = dm_sm_root_size(cmd->metadata_sm, &metadata_len);
+	if (r < 0)
+		return r;
+
+	r = dm_tm_pre_commit(cmd->tm);
+	if (r < 0)
+		return r;
+
+	r = superblock_lock_zero(cmd, &sblock);
+	if (r)
+		return r;
+
+	disk_super = dm_block_data(sblock);
+	disk_super->flags = 0;
+	memset(disk_super->uuid, 0, sizeof(disk_super->uuid));
+	disk_super->magic = cpu_to_le64(CACHE_SUPERBLOCK_MAGIC);
+	disk_super->version = cpu_to_le32(CACHE_VERSION);
+	memset(disk_super->policy_name, 0, CACHE_POLICY_NAME_SIZE);
+
+	r = dm_sm_copy_root(cmd->metadata_sm, &disk_super->metadata_space_map_root,
+			    metadata_len);
+	if (r < 0)
+		goto bad_locked;
+
+	disk_super->mapping_root = cpu_to_le64(cmd->root);
+	disk_super->hint_root = cpu_to_le64(cmd->hint_root);
+	disk_super->discard_root = cpu_to_le64(cmd->discard_root);
+	disk_super->discard_block_size = cpu_to_le64(cmd->discard_block_size);
+	disk_super->discard_nr_blocks = cpu_to_le64(from_dblock(cmd->discard_nr_blocks));
+	disk_super->metadata_block_size = cpu_to_le32(CACHE_METADATA_BLOCK_SIZE >> SECTOR_SHIFT);
+	disk_super->data_block_size = cpu_to_le32(cmd->data_block_size);
+	disk_super->cache_blocks = cpu_to_le32(0);
+	memset(disk_super->policy_name, 0, sizeof(disk_super->policy_name));
+
+	disk_super->read_hits = cpu_to_le32(0);
+	disk_super->read_misses = cpu_to_le32(0);
+	disk_super->write_hits = cpu_to_le32(0);
+	disk_super->write_misses = cpu_to_le32(0);
+
+	return dm_tm_commit(cmd->tm, sblock);
+
+bad_locked:
+	dm_bm_unlock(sblock);
+	return r;
+}
+
+static int __format_metadata(struct dm_cache_metadata *cmd)
+{
+	int r;
+
+	debug("formatting metadata dev");
+	r = dm_tm_create_with_sm(cmd->bm, CACHE_SUPERBLOCK_LOCATION,
+				 &cmd->tm, &cmd->metadata_sm);
+	if (r < 0) {
+		DMERR("tm_create_with_sm failed");
+		return r;
+	}
+
+	__setup_mapping_info(cmd);
+
+	r = dm_array_empty(&cmd->info, &cmd->root);
+	if (r < 0)
+		goto bad;
+
+	dm_bitset_info_init(cmd->tm, &cmd->discard_info);
+
+	r = dm_bitset_empty(&cmd->discard_info, &cmd->discard_root);
+	if (r < 0)
+		goto bad;
+
+	cmd->discard_block_size = 0;
+	cmd->discard_nr_blocks = 0;
+
+	r = __write_initial_superblock(cmd);
+	if (r)
+		goto bad;
+
+	cmd->clean_when_opened = true;
+	return 0;
+
+bad:
+	dm_tm_destroy(cmd->tm);
+	dm_sm_destroy(cmd->metadata_sm);
+
+	return r;
+}
+
+static int __check_incompat_features(struct cache_disk_superblock *disk_super,
+				     struct dm_cache_metadata *cmd)
+{
+	uint32_t features;
+
+	features = le32_to_cpu(disk_super->incompat_flags) & ~CACHE_FEATURE_INCOMPAT_SUPP;
+	if (features) {
+		DMERR("could not access metadata due to unsupported optional features (%lx).",
+		      (unsigned long)features);
+		return -EINVAL;
+	}
+
+	/*
+	 * Check for read-only metadata to skip the following RDWR checks.
+	 */
+	if (get_disk_ro(cmd->bdev->bd_disk))
+		return 0;
+
+	features = le32_to_cpu(disk_super->compat_ro_flags) & ~CACHE_FEATURE_COMPAT_RO_SUPP;
+	if (features) {
+		DMERR("could not access metadata RDWR due to unsupported optional features (%lx).",
+		      (unsigned long)features);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int __open_metadata(struct dm_cache_metadata *cmd)
+{
+	int r;
+	struct dm_block *sblock;
+	struct cache_disk_superblock *disk_super;
+	unsigned long sb_flags;
+
+	r = superblock_read_lock(cmd, &sblock);
+	if (r < 0) {
+		DMERR("couldn't read lock superblock");
+		return r;
+	}
+
+	disk_super = dm_block_data(sblock);
+
+	r = __check_incompat_features(disk_super, cmd);
+	if (r < 0)
+		goto bad;
+
+	r = dm_tm_open_with_sm(cmd->bm, CACHE_SUPERBLOCK_LOCATION,
+			       disk_super->metadata_space_map_root,
+			       sizeof(disk_super->metadata_space_map_root),
+			       &cmd->tm, &cmd->metadata_sm);
+	if (r < 0) {
+		DMERR("tm_open_with_sm failed");
+		goto bad;
+	}
+
+	__setup_mapping_info(cmd);
+	dm_bitset_info_init(cmd->tm, &cmd->discard_info);
+	sb_flags = le32_to_cpu(disk_super->flags);
+	cmd->clean_when_opened = test_bit(CLEAN_SHUTDOWN, &sb_flags);
+	return dm_bm_unlock(sblock);
+
+bad:
+	dm_bm_unlock(sblock);
+	return r;
+}
+
+static int __open_or_format_metadata(struct dm_cache_metadata *cmd,
+				     bool format_device)
+{
+	int r, unformatted;
+
+	r = __superblock_all_zeroes(cmd->bm, &unformatted);
+	if (r)
+		return r;
+
+	if (unformatted)
+		return format_device ? __format_metadata(cmd) : -EPERM;
+
+	return __open_metadata(cmd);
+}
+
+static int __create_persistent_data_objects(struct dm_cache_metadata *cmd,
+					    bool may_format_device)
+{
+	int r;
+	cmd->bm = dm_block_manager_create(cmd->bdev, CACHE_METADATA_BLOCK_SIZE,
+					  CACHE_METADATA_CACHE_SIZE,
+					  CACHE_MAX_CONCURRENT_LOCKS);
+	if (IS_ERR(cmd->bm)) {
+		DMERR("could not create block manager");
+		return PTR_ERR(cmd->bm);
+	}
+
+	r = __open_or_format_metadata(cmd, may_format_device);
+	if (r)
+		dm_block_manager_destroy(cmd->bm);
+
+	return r;
+}
+
+static void __destroy_persistent_data_objects(struct dm_cache_metadata *cmd)
+{
+	dm_sm_destroy(cmd->metadata_sm);
+	dm_tm_destroy(cmd->tm);
+	dm_block_manager_destroy(cmd->bm);
+}
+
+typedef unsigned long (*flags_mutator)(unsigned long);
+
+static void update_flags(struct cache_disk_superblock *disk_super,
+			 flags_mutator mutator)
+{
+	uint32_t sb_flags = mutator(le32_to_cpu(disk_super->flags));
+	disk_super->flags = cpu_to_le32(sb_flags);
+}
+
+static unsigned long set_clean_shutdown(unsigned long flags)
+{
+	set_bit(CLEAN_SHUTDOWN, &flags);
+	return flags;
+}
+
+static unsigned long clear_clean_shutdown(unsigned long flags)
+{
+	clear_bit(CLEAN_SHUTDOWN, &flags);
+	return flags;
+}
+
+static void read_superblock_fields(struct dm_cache_metadata *cmd,
+				   struct cache_disk_superblock *disk_super)
+{
+	cmd->root = le64_to_cpu(disk_super->mapping_root);
+	cmd->hint_root = le64_to_cpu(disk_super->hint_root);
+	cmd->discard_root = le64_to_cpu(disk_super->discard_root);
+	cmd->discard_block_size = le64_to_cpu(disk_super->discard_block_size);
+	cmd->discard_nr_blocks = to_dblock(le64_to_cpu(disk_super->discard_nr_blocks));
+	cmd->data_block_size = le32_to_cpu(disk_super->data_block_size);
+	cmd->cache_blocks = to_cblock(le32_to_cpu(disk_super->cache_blocks));
+	strncpy(cmd->policy_name, disk_super->policy_name, sizeof(cmd->policy_name));
+
+	cmd->stats.read_hits = le32_to_cpu(disk_super->read_hits);
+	cmd->stats.read_misses = le32_to_cpu(disk_super->read_misses);
+	cmd->stats.write_hits = le32_to_cpu(disk_super->write_hits);
+	cmd->stats.write_misses = le32_to_cpu(disk_super->write_misses);
+
+	cmd->changed = false;
+}
+
+/*
+ * The mutator updates the superblock flags.
+ */
+static int __begin_transaction_flags(struct dm_cache_metadata *cmd,
+				     flags_mutator mutator)
+{
+	int r;
+	struct cache_disk_superblock *disk_super;
+	struct dm_block *sblock;
+
+	r = superblock_lock(cmd, &sblock);
+	if (r)
+		return r;
+
+	disk_super = dm_block_data(sblock);
+	update_flags(disk_super, mutator);
+	read_superblock_fields(cmd, disk_super);
+
+	return dm_bm_flush_and_unlock(cmd->bm, sblock);
+}
+
+static int __begin_transaction(struct dm_cache_metadata *cmd)
+{
+	int r;
+	struct cache_disk_superblock *disk_super;
+	struct dm_block *sblock;
+
+	/*
+	 * We re-read the superblock every time.  Shouldn't need to do this
+	 * really.
+	 */
+	r = superblock_read_lock(cmd, &sblock);
+	if (r)
+		return r;
+
+	disk_super = dm_block_data(sblock);
+	read_superblock_fields(cmd, disk_super);
+	dm_bm_unlock(sblock);
+
+	return 0;
+}
+
+static int __commit_transaction(struct dm_cache_metadata *cmd,
+				flags_mutator mutator)
+{
+	int r;
+	size_t metadata_len;
+	struct cache_disk_superblock *disk_super;
+	struct dm_block *sblock;
+
+	/*
+	 * We need to know if the cache_disk_superblock exceeds a 512-byte sector.
+	 */
+	BUILD_BUG_ON(sizeof(struct cache_disk_superblock) > 512);
+
+	r = dm_bitset_flush(&cmd->discard_info, cmd->discard_root,
+			    &cmd->discard_root);
+	if (r)
+		return r;
+
+	r = dm_tm_pre_commit(cmd->tm);
+	if (r < 0)
+		return r;
+
+	r = dm_sm_root_size(cmd->metadata_sm, &metadata_len);
+	if (r < 0)
+		return r;
+
+	r = superblock_lock(cmd, &sblock);
+	if (r)
+		return r;
+
+	disk_super = dm_block_data(sblock);
+
+	if (mutator)
+		update_flags(disk_super, mutator);
+
+	debug("root = %lu\n", (unsigned long) cmd->root);
+	disk_super->mapping_root = cpu_to_le64(cmd->root);
+	disk_super->hint_root = cpu_to_le64(cmd->hint_root);
+	disk_super->discard_root = cpu_to_le64(cmd->discard_root);
+	disk_super->discard_block_size = cpu_to_le64(cmd->discard_block_size);
+	disk_super->discard_nr_blocks = cpu_to_le64(from_dblock(cmd->discard_nr_blocks));
+	disk_super->cache_blocks = cpu_to_le32(from_cblock(cmd->cache_blocks));
+	strncpy(disk_super->policy_name, cmd->policy_name, sizeof(disk_super->policy_name));
+
+	disk_super->read_hits = cpu_to_le32(cmd->stats.read_hits);
+	disk_super->read_misses = cpu_to_le32(cmd->stats.read_misses);
+	disk_super->write_hits = cpu_to_le32(cmd->stats.write_hits);
+	disk_super->write_misses = cpu_to_le32(cmd->stats.write_misses);
+
+	r = dm_sm_copy_root(cmd->metadata_sm, &disk_super->metadata_space_map_root,
+			    metadata_len);
+	if (r < 0) {
+		dm_bm_unlock(sblock);
+		return r;
+	}
+
+	return dm_tm_commit(cmd->tm, sblock);
+}
+
+/*----------------------------------------------------------------*/
+
+/*
+ * The mappings are held in a dm-array that has 64-bit values stored in
+ * little-endian format.  The index is the cblock, the high 48bits of the
+ * value are the oblock and the low 16 bit the flags.
+ */
+#define FLAGS_MASK ((1 << 16) - 1)
+
+static __le64 pack_value(dm_oblock_t block, unsigned flags)
+{
+	uint64_t value = from_oblock(block);
+	value <<= 16;
+	value = value | (flags & FLAGS_MASK);
+	return cpu_to_le64(value);
+}
+
+static void unpack_value(__le64 value_le, dm_oblock_t *block, unsigned *flags)
+{
+	uint64_t value = le64_to_cpu(value_le);
+	uint64_t b = value >> 16;
+	*block = to_oblock(b);
+	*flags = value & FLAGS_MASK;
+}
+
+/*----------------------------------------------------------------*/
+
+struct dm_cache_metadata *dm_cache_metadata_open(struct block_device *bdev,
+						 sector_t data_block_size,
+						 bool may_format_device)
+{
+	int r;
+	struct dm_cache_metadata *cmd;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		DMERR("could not allocate metadata struct");
+		return NULL;
+	}
+
+	init_rwsem(&cmd->root_lock);
+	cmd->bdev = bdev;
+	cmd->data_block_size = data_block_size;
+	cmd->cache_blocks = 0;
+	cmd->changed = true;
+
+	r = __create_persistent_data_objects(cmd, may_format_device);
+	if (r) {
+		kfree(cmd);
+		return ERR_PTR(r);
+	}
+
+	r = __begin_transaction_flags(cmd, clear_clean_shutdown);
+	if (r < 0) {
+		dm_cache_metadata_close(cmd);
+		return ERR_PTR(r);
+	}
+
+	return cmd;
+}
+
+void dm_cache_metadata_close(struct dm_cache_metadata *cmd)
+{
+	__destroy_persistent_data_objects(cmd);
+	kfree(cmd);
+}
+
+int dm_cache_resize(struct dm_cache_metadata *cmd, dm_cblock_t new_cache_size)
+{
+	int r;
+	__le64 null_mapping = pack_value(0, 0);
+
+	down_write(&cmd->root_lock);
+	__dm_bless_for_disk(&null_mapping);
+	r = dm_array_resize(&cmd->info, cmd->root, from_cblock(cmd->cache_blocks),
+			    from_cblock(new_cache_size),
+			    &null_mapping, &cmd->root);
+	if (!r)
+		cmd->cache_blocks = new_cache_size;
+	cmd->changed = true;
+	up_write(&cmd->root_lock);
+
+	return r;
+}
+
+int dm_cache_discard_bitset_resize(struct dm_cache_metadata *cmd,
+				   sector_t discard_block_size,
+				   dm_dblock_t new_nr_entries)
+{
+	int r;
+
+	down_write(&cmd->root_lock);
+	r = dm_bitset_resize(&cmd->discard_info,
+			     cmd->discard_root,
+			     from_dblock(cmd->discard_nr_blocks),
+			     from_dblock(new_nr_entries),
+			     false, &cmd->discard_root);
+	if (!r) {
+		cmd->discard_block_size = discard_block_size;
+		cmd->discard_nr_blocks = new_nr_entries;
+	}
+
+	cmd->changed = true;
+	up_write(&cmd->root_lock);
+
+	return r;
+}
+
+static int __set_discard(struct dm_cache_metadata *cmd, dm_dblock_t b)
+{
+	return dm_bitset_set_bit(&cmd->discard_info, cmd->discard_root,
+				 from_dblock(b), &cmd->discard_root);
+}
+
+static int __clear_discard(struct dm_cache_metadata *cmd, dm_dblock_t b)
+{
+	return dm_bitset_clear_bit(&cmd->discard_info, cmd->discard_root,
+				   from_dblock(b), &cmd->discard_root);
+}
+
+static int __is_discarded(struct dm_cache_metadata *cmd, dm_dblock_t b,
+			  bool *is_discarded)
+{
+	return dm_bitset_test_bit(&cmd->discard_info, cmd->discard_root,
+				  from_dblock(b), &cmd->discard_root,
+				  is_discarded);
+}
+
+static int __discard(struct dm_cache_metadata *cmd,
+		     dm_dblock_t dblock, bool discard)
+{
+	int r;
+
+	r = (discard ? __set_discard : __clear_discard)(cmd, dblock);
+	if (r)
+		return r;
+
+	cmd->changed = true;
+	return 0;
+}
+
+int dm_cache_set_discard(struct dm_cache_metadata *cmd,
+			 dm_dblock_t dblock, bool discard)
+{
+	int r;
+
+	down_write(&cmd->root_lock);
+	r = __discard(cmd, dblock, discard);
+	up_write(&cmd->root_lock);
+
+	return r;
+}
+
+static int __load_discards(struct dm_cache_metadata *cmd,
+			   load_discard_fn fn, void *context)
+{
+	int r = 0;
+	dm_block_t b;
+	bool discard;
+
+	for (b = 0; b < from_dblock(cmd->discard_nr_blocks); b++) {
+		dm_dblock_t dblock = to_dblock(b);
+
+		if (cmd->clean_when_opened) {
+			r = __is_discarded(cmd, dblock, &discard);
+			if (r)
+				return r;
+		} else
+			discard = false;
+
+		r = fn(context, cmd->discard_block_size, dblock, discard);
+		if (r)
+			break;
+	}
+
+	return r;
+}
+
+int dm_cache_load_discards(struct dm_cache_metadata *cmd,
+			   load_discard_fn fn, void *context)
+{
+	int r;
+
+	down_read(&cmd->root_lock);
+	r = __load_discards(cmd, fn, context);
+	up_read(&cmd->root_lock);
+
+	return r;
+}
+
+dm_cblock_t dm_cache_size(struct dm_cache_metadata *cmd)
+{
+	dm_cblock_t r;
+
+	down_read(&cmd->root_lock);
+	r = cmd->cache_blocks;
+	up_read(&cmd->root_lock);
+
+	return r;
+}
+
+static int __remove(struct dm_cache_metadata *cmd, dm_cblock_t cblock)
+{
+	int r;
+	__le64 value = pack_value(0, 0);
+
+	debug("__remove %lu\n", (unsigned long) oblock);
+	__dm_bless_for_disk(&value);
+	r = dm_array_set(&cmd->info, cmd->root, from_cblock(cblock),
+			 &value, &cmd->root);
+	if (r)
+		return r;
+
+	cmd->changed = true;
+	return 0;
+}
+
+int dm_cache_remove_mapping(struct dm_cache_metadata *cmd, dm_cblock_t cblock)
+{
+	int r;
+
+	down_write(&cmd->root_lock);
+	r = __remove(cmd, cblock);
+	up_write(&cmd->root_lock);
+
+	return r;
+}
+
+static int __insert(struct dm_cache_metadata *cmd,
+		    dm_cblock_t cblock, dm_oblock_t oblock)
+{
+	int r;
+	__le64 value = pack_value(oblock, M_VALID);
+	__dm_bless_for_disk(&value);
+
+	r = dm_array_set(&cmd->info, cmd->root, from_cblock(cblock),
+			 &value, &cmd->root);
+	if (r)
+		return r;
+
+	cmd->changed = true;
+	return 0;
+}
+
+int dm_cache_insert_mapping(struct dm_cache_metadata *cmd,
+			    dm_cblock_t cblock, dm_oblock_t oblock)
+{
+	int r;
+
+	down_write(&cmd->root_lock);
+	r = __insert(cmd, cblock, oblock);
+	up_write(&cmd->root_lock);
+
+	return r;
+}
+
+struct thunk {
+	load_mapping_fn fn;
+	void *context;
+
+	struct dm_cache_metadata *cmd;
+	bool respect_dirty_flags;
+	bool hints_valid;
+};
+
+static bool hints_array_available(struct dm_cache_metadata *cmd,
+				  const char *policy_name)
+{
+	bool policy_names_match = !strncmp(cmd->policy_name, policy_name,
+					   sizeof(cmd->policy_name));
+
+	return cmd->clean_when_opened && policy_names_match && cmd->hint_root;
+}
+
+static int __load_mapping(void *context, uint64_t cblock, void *leaf)
+{
+	int r = 0;
+	bool dirty;
+	__le64 value;
+	__le32 hint_value = 0;
+	dm_oblock_t oblock;
+	unsigned flags;
+	struct thunk *thunk = context;
+	struct dm_cache_metadata *cmd = thunk->cmd;
+
+	memcpy(&value, leaf, sizeof(value));
+	unpack_value(value, &oblock, &flags);
+
+	if (flags & M_VALID) {
+		if (thunk->hints_valid) {
+			r = dm_array_get(&cmd->hint_info, cmd->hint_root,
+					 cblock, &hint_value);
+			if (r && r != -ENODATA)
+				return r;
+		}
+
+		dirty = thunk->respect_dirty_flags ? (flags & M_DIRTY) : true;
+		r = thunk->fn(thunk->context, oblock, to_cblock(cblock),
+			      dirty, le32_to_cpu(hint_value), thunk->hints_valid);
+	}
+
+	return r;
+}
+
+static int __load_mappings(struct dm_cache_metadata *cmd, const char *policy_name,
+			   load_mapping_fn fn, void *context)
+{
+	struct thunk thunk;
+
+	thunk.fn = fn;
+	thunk.context = context;
+
+	thunk.cmd = cmd;
+	thunk.respect_dirty_flags = cmd->clean_when_opened;
+	thunk.hints_valid = hints_array_available(cmd, policy_name);
+
+	return dm_array_walk(&cmd->info, cmd->root, __load_mapping, &thunk);
+}
+
+int dm_cache_load_mappings(struct dm_cache_metadata *cmd, const char *policy_name,
+			   load_mapping_fn fn, void *context)
+{
+	int r;
+
+	debug("> dm_cache_load_mappings\n");
+	down_read(&cmd->root_lock);
+	r = __load_mappings(cmd, policy_name, fn, context);
+	up_read(&cmd->root_lock);
+	debug("< dm_cache_load_mappings\n");
+
+	return r;
+}
+
+static int __dump_mapping(void *context, uint64_t cblock, void *leaf)
+{
+	int r = 0;
+	__le64 value;
+	dm_oblock_t oblock;
+	unsigned flags;
+
+	memcpy(&value, leaf, sizeof(value));
+	unpack_value(value, &oblock, &flags);
+
+	if (flags & M_VALID)
+		pr_alert("%p o(%u) -> c(%u)\n", leaf,
+			 (unsigned) from_oblock(oblock),
+			 (unsigned) cblock);
+
+	return r;
+}
+
+static int __dump_mappings(struct dm_cache_metadata *cmd)
+{
+	return dm_array_walk(&cmd->info, cmd->root, __dump_mapping, NULL);
+}
+
+void dm_cache_dump(struct dm_cache_metadata *cmd)
+{
+	down_read(&cmd->root_lock);
+	__dump_mappings(cmd);
+	up_read(&cmd->root_lock);
+}
+
+int dm_cache_changed_this_transaction(struct dm_cache_metadata *cmd)
+{
+	int r;
+
+	down_read(&cmd->root_lock);
+	r = cmd->changed;
+	up_read(&cmd->root_lock);
+
+	return r;
+}
+
+static int __dirty(struct dm_cache_metadata *cmd, dm_cblock_t cblock, bool dirty)
+{
+	int r;
+	unsigned flags;
+	dm_oblock_t oblock;
+	__le64 value;
+
+	r = dm_array_get(&cmd->info, cmd->root, from_cblock(cblock), &value);
+	if (r)
+		return r;
+
+	unpack_value(value, &oblock, &flags);
+
+	if (((flags & M_DIRTY) && dirty) || (!(flags & M_DIRTY) && !dirty))
+		/* nothing to be done */
+		return 0;
+
+	value = pack_value(oblock, flags | (dirty ? M_DIRTY : 0));
+	__dm_bless_for_disk(&value);
+
+	r = dm_array_set(&cmd->info, cmd->root, from_cblock(cblock),
+			 &value, &cmd->root);
+	if (r)
+		return r;
+
+	cmd->changed = true;
+	return 0;
+
+}
+
+int dm_cache_set_dirty(struct dm_cache_metadata *cmd,
+		       dm_cblock_t cblock, bool dirty)
+{
+	int r;
+
+	down_write(&cmd->root_lock);
+	r = __dirty(cmd, cblock, dirty);
+	up_write(&cmd->root_lock);
+
+	return r;
+}
+
+void dm_cache_get_stats(struct dm_cache_metadata *cmd,
+			struct dm_cache_statistics *stats)
+{
+	down_read(&cmd->root_lock);
+	memcpy(stats, &cmd->stats, sizeof(*stats));
+	up_read(&cmd->root_lock);
+}
+
+void dm_cache_set_stats(struct dm_cache_metadata *cmd,
+			struct dm_cache_statistics *stats)
+{
+	down_write(&cmd->root_lock);
+	memcpy(&cmd->stats, stats, sizeof(*stats));
+	up_write(&cmd->root_lock);
+}
+
+int dm_cache_commit(struct dm_cache_metadata *cmd, bool clean_shutdown)
+{
+	int r;
+	flags_mutator mutator = (clean_shutdown ? set_clean_shutdown :
+				 clear_clean_shutdown);
+
+	down_write(&cmd->root_lock);
+	r = __commit_transaction(cmd, mutator);
+	if (r)
+		goto out;
+
+	r = __begin_transaction(cmd);
+
+out:
+	up_write(&cmd->root_lock);
+	return r;
+}
+
+int dm_cache_get_free_metadata_block_count(struct dm_cache_metadata *cmd,
+					   dm_block_t *result)
+{
+	int r = -EINVAL;
+
+	down_read(&cmd->root_lock);
+	r = dm_sm_get_nr_free(cmd->metadata_sm, result);
+	up_read(&cmd->root_lock);
+
+	return r;
+}
+
+int dm_cache_get_metadata_dev_size(struct dm_cache_metadata *cmd,
+				   dm_block_t *result)
+{
+	int r = -EINVAL;
+
+	down_read(&cmd->root_lock);
+	r = dm_sm_get_nr_blocks(cmd->metadata_sm, result);
+	up_read(&cmd->root_lock);
+
+	return r;
+}
+
+/*----------------------------------------------------------------*/
+
+static int begin_hints(struct dm_cache_metadata *cmd, const char *policy_name)
+{
+	int r;
+	__le32 value;
+
+	if (!policy_name[0] ||
+	    (strlen(policy_name) > sizeof(cmd->policy_name) - 1))
+		return -EINVAL;
+
+	if (strcmp(cmd->policy_name, policy_name)) {
+		strncpy(cmd->policy_name, policy_name, sizeof(cmd->policy_name));
+
+		if (cmd->hint_root) {
+			r = dm_array_del(&cmd->hint_info, cmd->hint_root);
+			if (r)
+				return r;
+		}
+
+		r = dm_array_empty(&cmd->hint_info, &cmd->hint_root);
+		if (r)
+			return r;
+
+		value = cpu_to_le32(0);
+		__dm_bless_for_disk(&value);
+		r = dm_array_resize(&cmd->hint_info, cmd->hint_root, 0,
+				    from_cblock(cmd->cache_blocks),
+				    &value, &cmd->hint_root);
+		if (r)
+			return r;
+	}
+
+	return 0;
+}
+
+int dm_cache_begin_hints(struct dm_cache_metadata *cmd, const char *policy_name)
+{
+	int r;
+
+	down_write(&cmd->root_lock);
+	r = begin_hints(cmd, policy_name);
+	up_write(&cmd->root_lock);
+
+	return r;
+}
+
+static int save_hint(struct dm_cache_metadata *cmd, dm_cblock_t cblock,
+		     uint32_t hint)
+{
+	int r;
+	__le32 value = cpu_to_le32(hint);
+	__dm_bless_for_disk(&value);
+
+	r = dm_array_set(&cmd->hint_info, cmd->hint_root,
+			 from_cblock(cblock), &value, &cmd->hint_root);
+	cmd->changed = true;
+
+	return r;
+}
+
+int dm_cache_save_hint(struct dm_cache_metadata *cmd, dm_cblock_t cblock,
+		       uint32_t hint)
+{
+	int r;
+
+	down_write(&cmd->root_lock);
+	r = save_hint(cmd, cblock, hint);
+	up_write(&cmd->root_lock);
+
+	return r;
+}
diff --git a/drivers/md/dm-cache-metadata.h b/drivers/md/dm-cache-metadata.h
new file mode 100644
index 0000000..e0eef0d
--- /dev/null
+++ b/drivers/md/dm-cache-metadata.h
@@ -0,0 +1,170 @@
+/*
+ * Copyright (C) 2012 Red Hat, Inc.
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef DM_CACHE_METADATA_H
+#define DM_CACHE_METADATA_H
+
+#include "persistent-data/dm-block-manager.h"
+
+/*----------------------------------------------------------------*/
+
+/*
+ * It's helpful to get sparse to differentiate between indexes into the
+ * origin device, indexes into the cache device, and indexes into the
+ * discard bitset.
+ */
+
+typedef dm_block_t __bitwise__ dm_oblock_t;
+typedef uint32_t __bitwise__ dm_cblock_t;
+typedef dm_block_t __bitwise__ dm_dblock_t;
+
+static inline dm_oblock_t to_oblock(dm_block_t b)
+{
+	return (__force dm_oblock_t) b;
+}
+
+static inline dm_block_t from_oblock(dm_oblock_t b)
+{
+	return (__force dm_block_t) b;
+}
+
+static inline dm_cblock_t to_cblock(uint32_t b)
+{
+	return (__force dm_cblock_t) b;
+}
+
+static inline uint32_t from_cblock(dm_cblock_t b)
+{
+	return (__force uint32_t) b;
+}
+
+static inline dm_dblock_t to_dblock(dm_block_t b)
+{
+	return (__force dm_dblock_t) b;
+}
+
+static inline dm_block_t from_dblock(dm_dblock_t b)
+{
+	return (__force dm_block_t) b;
+}
+
+/*----------------------------------------------------------------*/
+
+#define CACHE_POLICY_NAME_SIZE 16
+#define CACHE_METADATA_BLOCK_SIZE 4096
+
+/* FIXME: remove this restriction */
+/*
+ * The metadata device is currently limited in size.
+ *
+ * We have one block of index, which can hold 255 index entries.  Each
+ * index entry contains allocation info about 16k metadata blocks.
+ */
+#define CACHE_METADATA_MAX_SECTORS (255 * (1 << 14) * (CACHE_METADATA_BLOCK_SIZE / (1 << SECTOR_SHIFT)))
+
+/*
+ * A metadata device larger than 16GB triggers a warning.
+ */
+#define CACHE_METADATA_MAX_SECTORS_WARNING (16 * (1024 * 1024 * 1024 >> SECTOR_SHIFT))
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Compat feature flags.  Any incompat flags beyond the ones
+ * specified below will prevent use of the thin metadata.
+ */
+#define CACHE_FEATURE_COMPAT_SUPP	  0UL
+#define CACHE_FEATURE_COMPAT_RO_SUPP	  0UL
+#define CACHE_FEATURE_INCOMPAT_SUPP	  0UL
+
+/*
+ * Reopens or creates a new, empty metadata volume.
+ * Returns an ERR_PTR on failure.
+ */
+struct dm_cache_metadata *dm_cache_metadata_open(struct block_device *bdev,
+						 sector_t data_block_size,
+						 bool may_format_device);
+
+void dm_cache_metadata_close(struct dm_cache_metadata *cmd);
+
+/*
+ * The metadata needs to know how many cache blocks there are.  We're dont
+ * care about the origin, assuming the core target is giving us valid
+ * origin blocks to map to.
+ */
+int dm_cache_resize(struct dm_cache_metadata *cmd, dm_cblock_t new_cache_size);
+dm_cblock_t dm_cache_size(struct dm_cache_metadata *cmd);
+
+int dm_cache_discard_bitset_resize(struct dm_cache_metadata *cmd,
+				   sector_t discard_block_size,
+				   dm_dblock_t new_nr_entries);
+
+typedef int (*load_discard_fn)(void *context, sector_t discard_block_size,
+			       dm_dblock_t dblock, bool discarded);
+int dm_cache_load_discards(struct dm_cache_metadata *cmd,
+			   load_discard_fn fn, void *context);
+
+int dm_cache_set_discard(struct dm_cache_metadata *cmd, dm_dblock_t dblock, bool discard);
+
+int dm_cache_remove_mapping(struct dm_cache_metadata *cmd, dm_cblock_t cblock);
+int dm_cache_insert_mapping(struct dm_cache_metadata *cmd, dm_cblock_t cblock, dm_oblock_t oblock);
+int dm_cache_changed_this_transaction(struct dm_cache_metadata *cmd);
+
+typedef int (*load_mapping_fn)(void *context, dm_oblock_t oblock,
+			       dm_cblock_t cblock, bool dirty,
+			       uint32_t hint, bool hint_valid);
+int dm_cache_load_mappings(struct dm_cache_metadata *cmd,
+			   const char *policy_name,
+			   load_mapping_fn fn,
+			   void *context);
+
+int dm_cache_set_dirty(struct dm_cache_metadata *cmd, dm_cblock_t cblock, bool dirty);
+
+struct dm_cache_statistics {
+	uint32_t read_hits;
+	uint32_t read_misses;
+	uint32_t write_hits;
+	uint32_t write_misses;
+};
+
+void dm_cache_get_stats(struct dm_cache_metadata *cmd,
+			struct dm_cache_statistics *stats);
+void dm_cache_set_stats(struct dm_cache_metadata *cmd,
+			struct dm_cache_statistics *stats);
+
+int dm_cache_commit(struct dm_cache_metadata *cmd, bool clean_shutdown);
+
+int dm_cache_get_free_metadata_block_count(struct dm_cache_metadata *cmd,
+					   dm_block_t *result);
+
+int dm_cache_get_metadata_dev_size(struct dm_cache_metadata *cmd,
+				   dm_block_t *result);
+
+void dm_cache_dump(struct dm_cache_metadata *cmd);
+
+/*
+ * The policy is invited to save a 32bit hint value for every cblock (eg,
+ * for a hit count).  These are stored against the policy name.  If
+ * policies are changed, then hints will be lost.  If the machine crashes,
+ * hints will be lost.
+ *
+ * The hints are indexed by the cblock, but many policies will not
+ * neccessarily have a fast way of accessing efficiently via cblock.  So
+ * rather than querying the policy for each cblock, we let it walk its data
+ * structures and fill in the hints in whatever order it wishes.
+ */
+
+int dm_cache_begin_hints(struct dm_cache_metadata *cmd, const char *policy_name);
+
+/*
+ * requests hints for every cblock and stores in the metadata device.
+ */
+int dm_cache_save_hint(struct dm_cache_metadata *cmd,
+		       dm_cblock_t cblock, uint32_t hint);
+
+/*----------------------------------------------------------------*/
+
+#endif
diff --git a/drivers/md/dm-cache-policy-cleaner.c b/drivers/md/dm-cache-policy-cleaner.c
new file mode 100644
index 0000000..089c432
--- /dev/null
+++ b/drivers/md/dm-cache-policy-cleaner.c
@@ -0,0 +1,482 @@
+/*
+ * Copyright (C) 2012 Red Hat. All rights reserved.
+ *
+ * writeback cache policy supporting flushing out dirty cache blocks.
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm-cache-policy.h"
+#include "dm.h"
+
+#include <linux/hash.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+/*----------------------------------------------------------------*/
+
+/* Cache entry struct. */
+struct wb_cache_entry {
+	struct list_head list;
+	struct hlist_node hlist;
+
+	dm_oblock_t oblock;
+	dm_cblock_t cblock;
+	bool dirty:1;
+	bool pending:1;
+};
+
+struct hash {
+	struct hlist_head *table;
+	dm_block_t hash_bits;
+	unsigned nr_buckets;
+};
+
+struct policy {
+	struct dm_cache_policy policy;
+	spinlock_t lock;
+
+	struct list_head free;
+	struct list_head clean;
+	struct list_head clean_pending;
+	struct list_head dirty;
+
+	/*
+	 * We know exactly how many cblocks will be needed,
+	 * so we can allocate them up front.
+	 */
+	dm_cblock_t cache_size, nr_cblocks_allocated;
+	struct wb_cache_entry *cblocks;
+	struct hash chash;
+};
+
+/*----------------------------------------------------------------------------*/
+
+/*
+ * Low-level functions.
+ */
+static unsigned next_power(unsigned n, unsigned min)
+{
+	return roundup_pow_of_two(max(n, min));
+}
+
+static struct policy *to_policy(struct dm_cache_policy *p)
+{
+	return container_of(p, struct policy, policy);
+}
+
+static struct list_head *list_pop(struct list_head *q)
+{
+	struct list_head *r = q->next;
+	list_del(r);
+	return r;
+}
+
+/*----------------------------------------------------------------------------*/
+
+/* Allocate/free various resources. */
+static int alloc_hash(struct hash *hash, unsigned elts)
+{
+	hash->nr_buckets = next_power(elts >> 4, 16);
+	hash->hash_bits = ffs(hash->nr_buckets) - 1;
+	hash->table = vzalloc(sizeof(*hash->table) * hash->nr_buckets);
+
+	return hash->table ? 0 : -ENOMEM;
+}
+
+static void free_hash(struct hash *hash)
+{
+	vfree(hash->table);
+}
+
+static int alloc_cache_blocks_with_hash(struct policy *p, dm_cblock_t cache_size)
+{
+	int r;
+
+	p->cblocks = vzalloc(sizeof(*p->cblocks) * from_cblock(cache_size));
+	if (p->cblocks) {
+		unsigned u = from_cblock(cache_size);
+
+		while (u--)
+			list_add(&p->cblocks[u].list, &p->free);
+
+		p->nr_cblocks_allocated = 0;
+
+		/* Cache entries hash. */
+		r = alloc_hash(&p->chash, from_cblock(cache_size));
+		if (r)
+			vfree(p->cblocks);
+
+	} else
+		r = -ENOMEM;
+
+	return r;
+}
+
+static void free_cache_blocks_and_hash(struct policy *p)
+{
+	free_hash(&p->chash);
+	vfree(p->cblocks);
+}
+
+static struct wb_cache_entry *alloc_cache_entry(struct policy *p)
+{
+	struct wb_cache_entry *e;
+
+	BUG_ON(from_cblock(p->nr_cblocks_allocated) >= from_cblock(p->cache_size));
+
+	e = list_entry(list_pop(&p->free), struct wb_cache_entry, list);
+	p->nr_cblocks_allocated = to_cblock(from_cblock(p->nr_cblocks_allocated) + 1);
+
+	return e;
+}
+
+/*----------------------------------------------------------------------------*/
+
+/* Hash functions (lookup, insert, remove). */
+static struct wb_cache_entry *lookup_cache_entry(struct policy *p, dm_oblock_t oblock)
+{
+	struct hash *hash = &p->chash;
+	unsigned h = hash_64(from_oblock(oblock), hash->hash_bits);
+	struct wb_cache_entry *cur;
+	struct hlist_node *tmp;
+	struct hlist_head *bucket = &hash->table[h];
+
+	hlist_for_each_entry(cur, tmp, bucket, hlist) {
+		if (cur->oblock == oblock) {
+			/* Move upfront bucket for faster access. */
+			hlist_del(&cur->hlist);
+			hlist_add_head(&cur->hlist, bucket);
+			return cur;
+		}
+	}
+
+	return NULL;
+}
+
+static void insert_cache_hash_entry(struct policy *p, struct wb_cache_entry *e)
+{
+	unsigned h = hash_64(from_oblock(e->oblock), p->chash.hash_bits);
+
+	hlist_add_head(&e->hlist, &p->chash.table[h]);
+}
+
+static void remove_cache_hash_entry(struct wb_cache_entry *e)
+{
+	hlist_del(&e->hlist);
+}
+
+/* Public interface (see dm-cache-policy.h */
+static int wb_map(struct dm_cache_policy *pe, dm_oblock_t oblock,
+		  bool can_block, bool can_migrate, bool discarded_oblock,
+		  struct bio *bio, struct policy_result *result)
+{
+	struct policy *p = to_policy(pe);
+	struct wb_cache_entry *e;
+	unsigned long flags;
+
+	result->op = POLICY_MISS;
+
+	if (can_block)
+		spin_lock_irqsave(&p->lock, flags);
+
+	else if (!spin_trylock_irqsave(&p->lock, flags))
+		return -EWOULDBLOCK;
+
+	e = lookup_cache_entry(p, oblock);
+	if (e) {
+		result->op = POLICY_HIT;
+		result->cblock = e->cblock;
+
+	}
+
+	spin_unlock_irqrestore(&p->lock, flags);
+
+	return 0;
+}
+
+static int wb_lookup(struct dm_cache_policy *pe, dm_oblock_t oblock, dm_cblock_t *cblock)
+{
+	int r;
+	struct policy *p = to_policy(pe);
+	struct wb_cache_entry *e;
+	unsigned long flags;
+
+	if (!spin_trylock_irqsave(&p->lock, flags))
+		return -EWOULDBLOCK;
+
+	e = lookup_cache_entry(p, oblock);
+	if (e) {
+		*cblock = e->cblock;
+		r = 0;
+
+	} else
+		r = -ENOENT;
+
+	spin_unlock_irqrestore(&p->lock, flags);
+
+	return r;
+}
+
+
+static void __set_clear_dirty(struct dm_cache_policy *pe, dm_oblock_t oblock, bool set)
+{
+	struct policy *p = to_policy(pe);
+	struct wb_cache_entry *e;
+
+	e = lookup_cache_entry(p, oblock);
+	BUG_ON(!e);
+
+	if (set) {
+		if (!e->dirty) {
+			e->dirty = true;
+			list_move(&e->list, &p->dirty);
+		}
+
+	} else {
+		if (e->dirty) {
+			e->pending = false;
+			e->dirty = false;
+			list_move(&e->list, &p->clean);
+		}
+	}
+}
+
+static void wb_set_dirty(struct dm_cache_policy *pe, dm_oblock_t oblock)
+{
+	struct policy *p = to_policy(pe);
+	unsigned long flags;
+
+	spin_lock_irqsave(&p->lock, flags);
+	__set_clear_dirty(pe, oblock, true);
+	spin_unlock_irqrestore(&p->lock, flags);
+}
+
+static void wb_clear_dirty(struct dm_cache_policy *pe, dm_oblock_t oblock)
+{
+	struct policy *p = to_policy(pe);
+	unsigned long flags;
+
+	spin_lock_irqsave(&p->lock, flags);
+	__set_clear_dirty(pe, oblock, false);
+	spin_unlock_irqrestore(&p->lock, flags);
+}
+
+static void add_cache_entry(struct policy *p, struct wb_cache_entry *e)
+{
+	insert_cache_hash_entry(p, e);
+	if (e->dirty)
+		list_add(&e->list, &p->dirty);
+	else
+		list_add(&e->list, &p->clean);
+}
+
+static int wb_load_mapping(struct dm_cache_policy *pe,
+			   dm_oblock_t oblock, dm_cblock_t cblock,
+			   uint32_t hint, bool hint_valid)
+{
+	int r;
+	struct policy *p = to_policy(pe);
+	struct wb_cache_entry *e = alloc_cache_entry(p);
+
+	if (e) {
+		e->cblock = cblock;
+		e->oblock = oblock;
+		e->dirty = false; /* blocks default to clean */
+		add_cache_entry(p, e);
+		r = 0;
+
+	} else
+		r = -ENOMEM;
+
+	return r;
+}
+
+static void wb_destroy(struct dm_cache_policy *pe)
+{
+	struct policy *p = to_policy(pe);
+
+	free_cache_blocks_and_hash(p);
+	kfree(p);
+}
+
+static struct wb_cache_entry *__wb_force_remove_mapping(struct policy *p, dm_oblock_t oblock)
+{
+	struct wb_cache_entry *r = lookup_cache_entry(p, oblock);
+
+	BUG_ON(!r);
+
+	remove_cache_hash_entry(r);
+	list_del(&r->list);
+
+	return r;
+}
+
+static void wb_remove_mapping(struct dm_cache_policy *pe, dm_oblock_t oblock)
+{
+	struct policy *p = to_policy(pe);
+	struct wb_cache_entry *e;
+	unsigned long flags;
+
+	spin_lock_irqsave(&p->lock, flags);
+	e = __wb_force_remove_mapping(p, oblock);
+	list_add_tail(&e->list, &p->free);
+	BUG_ON(!from_cblock(p->nr_cblocks_allocated));
+	p->nr_cblocks_allocated = to_cblock(from_cblock(p->nr_cblocks_allocated) - 1);
+	spin_unlock_irqrestore(&p->lock, flags);
+}
+
+static void wb_force_mapping(struct dm_cache_policy *pe,
+				dm_oblock_t current_oblock, dm_oblock_t oblock)
+{
+	struct policy *p = to_policy(pe);
+	struct wb_cache_entry *e;
+	unsigned long flags;
+
+	spin_lock_irqsave(&p->lock, flags);
+	e = __wb_force_remove_mapping(p, current_oblock);
+	e->oblock = oblock;
+	add_cache_entry(p, e);
+	spin_unlock_irqrestore(&p->lock, flags);
+}
+
+static struct wb_cache_entry *get_next_dirty_entry(struct policy *p)
+{
+	struct list_head *l;
+	struct wb_cache_entry *r;
+
+	if (list_empty(&p->dirty))
+		return NULL;
+
+	l = list_pop(&p->dirty);
+	r = container_of(l, struct wb_cache_entry, list);
+	list_add(l, &p->clean_pending);
+
+	return r;
+}
+
+static int wb_writeback_work(struct dm_cache_policy *pe,
+			     dm_oblock_t *oblock,
+			     dm_cblock_t *cblock)
+{
+	int r = -ENOENT;
+	struct policy *p = to_policy(pe);
+	struct wb_cache_entry *e;
+	unsigned long flags;
+
+	spin_lock_irqsave(&p->lock, flags);
+
+	e = get_next_dirty_entry(p);
+	if (e) {
+		*oblock = e->oblock;
+		*cblock = e->cblock;
+		r = 0;
+	}
+
+	spin_unlock_irqrestore(&p->lock, flags);
+
+	return r;
+}
+
+static dm_cblock_t wb_residency(struct dm_cache_policy *pe)
+{
+	return to_policy(pe)->nr_cblocks_allocated;
+}
+
+#if 0
+static int wb_status(struct dm_cache_policy *pe, status_type_t type, unsigned status_flags, char *result, unsigned maxlen)
+{
+	ssize_t sz = 0;
+	struct policy *p = to_policy(pe);
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		DMEMIT("%u", from_cblock(p->nr_dirty));
+		break;
+
+	case STATUSTYPE_TABLE:
+		break;
+	}
+
+	return 0;
+}
+#endif
+
+/* Init the policy plugin interface function pointers. */
+static void init_policy_functions(struct policy *p)
+{
+	p->policy.destroy = wb_destroy;
+	p->policy.map = wb_map;
+	p->policy.lookup = wb_lookup;
+	p->policy.set_dirty = wb_set_dirty;
+	p->policy.clear_dirty = wb_clear_dirty;
+	p->policy.load_mapping = wb_load_mapping;
+	p->policy.walk_mappings = NULL;
+	p->policy.remove_mapping = wb_remove_mapping;
+	p->policy.writeback_work = wb_writeback_work;
+	p->policy.force_mapping = wb_force_mapping;
+	p->policy.residency = wb_residency;
+	p->policy.tick = NULL;
+#if 0
+	p->policy.status = wb_status;
+	p->policy.message = NULL;
+#endif
+}
+
+static struct dm_cache_policy *wb_create(dm_cblock_t cache_size,
+					 sector_t origin_size,
+					 sector_t block_size,
+					 int argc, char **argv)
+{
+	int r;
+	struct policy *p = kzalloc(sizeof(*p), GFP_KERNEL);
+
+	if (!p)
+		return NULL;
+
+	init_policy_functions(p);
+	INIT_LIST_HEAD(&p->free);
+	INIT_LIST_HEAD(&p->clean);
+	INIT_LIST_HEAD(&p->clean_pending);
+	INIT_LIST_HEAD(&p->dirty);
+
+	p->cache_size = cache_size;
+	spin_lock_init(&p->lock);
+
+	/* Allocate cache entry structs and add them to free list. */
+	r = alloc_cache_blocks_with_hash(p, cache_size);
+	if (!r)
+		return &p->policy;
+
+	kfree(p);
+
+	return NULL;
+}
+/*----------------------------------------------------------------------------*/
+
+static struct dm_cache_policy_type wb_policy_type = {
+	.name = "cleaner",
+	.hint_size = 0,
+	.owner = THIS_MODULE,
+        .create = wb_create
+};
+
+static int __init wb_init(void)
+{
+	return dm_cache_policy_register(&wb_policy_type);
+}
+
+static void __exit wb_exit(void)
+{
+	dm_cache_policy_unregister(&wb_policy_type);
+}
+
+module_init(wb_init);
+module_exit(wb_exit);
+
+MODULE_AUTHOR("Heinz Mauelshagen");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("cleaner cache policy");
+
+/*----------------------------------------------------------------------------*/
diff --git a/drivers/md/dm-cache-policy-internal.h b/drivers/md/dm-cache-policy-internal.h
new file mode 100644
index 0000000..a7795b8
--- /dev/null
+++ b/drivers/md/dm-cache-policy-internal.h
@@ -0,0 +1,120 @@
+/*
+ * Copyright (C) 2012 Red Hat. All rights reserved.
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef DM_CACHE_POLICY_INTERNAL_H
+#define DM_CACHE_POLICY_INTERNAL_H
+
+#include "dm-cache-policy.h"
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Little inline functions that simplify calling the policy methods.
+ */
+static inline int policy_map(struct dm_cache_policy *p, dm_oblock_t oblock,
+			     bool can_block, bool can_migrate, bool discarded_oblock,
+			     struct bio *bio, struct policy_result *result)
+{
+	return p->map(p, oblock, can_block, can_migrate, discarded_oblock, bio, result);
+}
+
+static inline int policy_lookup(struct dm_cache_policy *p, dm_oblock_t oblock, dm_cblock_t *cblock)
+{
+	BUG_ON(!p->lookup);
+	return p->lookup(p, oblock, cblock);
+}
+
+static inline void policy_set_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
+{
+	if (p->set_dirty)
+		p->set_dirty(p, oblock);
+}
+
+static inline void policy_clear_dirty(struct dm_cache_policy *p, dm_oblock_t oblock)
+{
+	if (p->clear_dirty)
+		p->clear_dirty(p, oblock);
+}
+
+static inline int policy_load_mapping(struct dm_cache_policy *p,
+				      dm_oblock_t oblock, dm_cblock_t cblock,
+				      uint32_t hint, bool hint_valid)
+{
+	return p->load_mapping(p, oblock, cblock, hint, hint_valid);
+}
+
+static inline int policy_walk_mappings(struct dm_cache_policy *p,
+				      policy_walk_fn fn, void *context)
+{
+	return p->walk_mappings ? p->walk_mappings(p, fn, context) : 0;
+}
+
+static inline int policy_writeback_work(struct dm_cache_policy *p,
+					dm_oblock_t *oblock,
+					dm_cblock_t *cblock)
+{
+	return p->writeback_work ? p->writeback_work(p, oblock, cblock) : -ENOENT;
+}
+
+static inline void policy_remove_mapping(struct dm_cache_policy *p, dm_oblock_t oblock)
+{
+	return p->remove_mapping(p, oblock);
+}
+
+static inline void policy_force_mapping(struct dm_cache_policy *p,
+					dm_oblock_t current_oblock, dm_oblock_t new_oblock)
+{
+	return p->force_mapping(p, current_oblock, new_oblock);
+}
+
+static inline dm_cblock_t policy_residency(struct dm_cache_policy *p)
+{
+	return p->residency(p);
+}
+
+static inline void policy_tick(struct dm_cache_policy *p)
+{
+	if (p->tick)
+		return p->tick(p);
+}
+
+static inline int policy_status(struct dm_cache_policy *p, status_type_t type,
+				unsigned status_flags, char *result, unsigned maxlen)
+{
+	return p->status ? p->status(p, type, status_flags, result, maxlen) : 0;
+}
+
+static inline int policy_message(struct dm_cache_policy *p, unsigned argc, char **argv)
+{
+	return p->message ? p->message(p, argc, argv) : 0;
+}
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Creates a new cache policy given a policy name, a cache size, an origin size and the block size.
+ */
+struct dm_cache_policy *dm_cache_policy_create(const char *name, dm_cblock_t cache_size,
+					       sector_t origin_size, sector_t block_size,
+					       int argc, char **argv);
+
+/*
+ * Destroys the policy.  This drops references to the policy module as well
+ * as calling it's destroy method.  So always use this rather than calling
+ * the policy->destroy method directly.
+ */
+void dm_cache_policy_destroy(struct dm_cache_policy *p);
+
+/*
+ * In case we've forgotten.
+ */
+const char *dm_cache_policy_get_name(struct dm_cache_policy *p);
+
+size_t dm_cache_policy_get_hint_size(struct dm_cache_policy *p);
+
+/*----------------------------------------------------------------*/
+
+#endif
diff --git a/drivers/md/dm-cache-policy-mq.c b/drivers/md/dm-cache-policy-mq.c
new file mode 100644
index 0000000..f4cb941
--- /dev/null
+++ b/drivers/md/dm-cache-policy-mq.c
@@ -0,0 +1,1254 @@
+/*
+ * Copyright (C) 2012 Red Hat. All rights reserved.
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm-cache-policy.h"
+#include "dm.h"
+
+#include <linux/hash.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+
+#define DM_MSG_PREFIX "cache-policy-mq"
+
+static struct kmem_cache *mq_entry_cache;
+
+/*----------------------------------------------------------------*/
+
+static unsigned next_power(unsigned n, unsigned min)
+{
+	return roundup_pow_of_two(max(n, min));
+}
+
+/*----------------------------------------------------------------*/
+
+static unsigned long *alloc_bitset(unsigned nr_entries)
+{
+	size_t s = sizeof(unsigned long) * dm_div_up(nr_entries, BITS_PER_LONG);
+	return vzalloc(s);
+}
+
+static void free_bitset(unsigned long *bits)
+{
+	vfree(bits);
+}
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Large, sequential ios are probably better left on the origin device since
+ * spindles tend to have good bandwidth.
+ *
+ * The io_tracker tries to spot when the io is in one of these sequential
+ * modes.
+ *
+ * The two thresholds are hard coded for now.  I'd like them to be
+ * accessible through a sysfs interface, rather than via the target line.
+ */
+#define RANDOM_THRESHOLD_DEFAULT 4
+#define SEQUENTIAL_THRESHOLD_DEFAULT 512
+
+enum io_pattern {
+	PATTERN_SEQUENTIAL,
+	PATTERN_RANDOM
+};
+
+struct io_tracker {
+	enum io_pattern pattern;
+
+	unsigned nr_seq_samples;
+	unsigned nr_rand_samples;
+	int thresholds[2];
+
+	dm_oblock_t last_end_oblock;
+};
+
+static void iot_init(struct io_tracker *t,
+		     int sequential_threshold, int random_threshold)
+{
+	t->pattern = PATTERN_RANDOM;
+	t->nr_seq_samples = 0;
+	t->nr_rand_samples = 0;
+	t->thresholds[PATTERN_SEQUENTIAL] = sequential_threshold > -1 ? sequential_threshold : SEQUENTIAL_THRESHOLD_DEFAULT;
+	t->thresholds[PATTERN_RANDOM] = random_threshold > -1 ? random_threshold : RANDOM_THRESHOLD_DEFAULT;
+	t->last_end_oblock = 0;
+}
+
+static enum io_pattern iot_pattern(struct io_tracker *t)
+{
+	return t->pattern;
+}
+
+static void iot_update_stats(struct io_tracker *t, struct bio *bio)
+{
+	if (bio->bi_sector == from_oblock(t->last_end_oblock) + 1) {
+		t->nr_seq_samples++;
+
+	} else {
+		/*
+		 * Just one non-sequential IO is enough to reset the
+		 * counters.
+		 */
+		if (t->nr_seq_samples) {
+			t->nr_seq_samples = 0;
+			t->nr_rand_samples = 0;
+		}
+
+		t->nr_rand_samples++;
+	}
+
+	t->last_end_oblock = to_oblock(bio->bi_sector + bio_sectors(bio) - 1);
+}
+
+static void iot_check_for_pattern_switch(struct io_tracker *t)
+{
+	switch (t->pattern) {
+	case PATTERN_SEQUENTIAL:
+		if (t->nr_rand_samples >= t->thresholds[PATTERN_RANDOM]) {
+			t->pattern = PATTERN_RANDOM;
+			t->nr_seq_samples = t->nr_rand_samples = 0;
+		}
+		break;
+
+	case PATTERN_RANDOM:
+		if (t->nr_seq_samples >= t->thresholds[PATTERN_SEQUENTIAL]) {
+			t->pattern = PATTERN_SEQUENTIAL;
+			t->nr_seq_samples = t->nr_rand_samples = 0;
+		}
+		break;
+	}
+}
+
+static void iot_examine_bio(struct io_tracker *t, struct bio *bio)
+{
+	iot_update_stats(t, bio);
+	iot_check_for_pattern_switch(t);
+}
+
+/*----------------------------------------------------------------*/
+
+
+/*
+ * This queue is divided up into different levels.  Allowing us to push
+ * entries to the back of any of the levels.  Think of it as a partially
+ * sorted queue.
+ */
+#define NR_QUEUE_LEVELS 16u
+
+struct queue {
+	struct list_head qs[NR_QUEUE_LEVELS];
+};
+
+static void queue_init(struct queue *q)
+{
+	unsigned i;
+
+	for (i = 0; i < NR_QUEUE_LEVELS; i++)
+		INIT_LIST_HEAD(q->qs + i);
+}
+
+/*
+ * Insert an entry to the back of the given level.
+ */
+static void queue_push(struct queue *q, unsigned level, struct list_head *elt)
+{
+	list_add_tail(elt, q->qs + level);
+}
+
+static void queue_remove(struct list_head *elt)
+{
+	list_del(elt);
+}
+
+/*
+ * Shifts all regions down one level.  This has no effect on the order of
+ * the queue.
+ */
+static void queue_shift_down(struct queue *q)
+{
+	unsigned level;
+
+	for (level = 1; level < NR_QUEUE_LEVELS; level++)
+		list_splice_init(q->qs + level, q->qs + level - 1);
+}
+
+/*
+ * Gives us the oldest entry of the lowest popoulated level.  If the first
+ * level is emptied then we shift down one level.
+ */
+static struct list_head *queue_pop(struct queue *q)
+{
+	unsigned level;
+	struct list_head *r;
+
+	for (level = 0; level < NR_QUEUE_LEVELS; level++)
+		if (!list_empty(q->qs + level)) {
+			r = q->qs[level].next;
+			list_del(r);
+
+			/* have we just emptied the bottom level? */
+			if (level == 0 && list_empty(q->qs))
+				queue_shift_down(q);
+
+			return r;
+		}
+
+	return NULL;
+}
+
+static struct list_head *list_pop(struct list_head *lh)
+{
+	struct list_head *r = lh->next;
+
+	BUG_ON(!r);
+	list_del_init(r);
+
+	return r;
+}
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Describes a cache entry.  Used in both the cache and the pre_cache.
+ */
+struct entry {
+	struct hlist_node hlist;
+	struct list_head list;
+	dm_oblock_t oblock;
+	dm_cblock_t cblock;	/* valid iff in_cache */
+
+	// FIXME: pack these better
+	bool in_cache:1;
+	unsigned hit_count;
+	unsigned generation;
+	unsigned tick;
+};
+
+struct mq_policy {
+	struct dm_cache_policy policy;
+
+	/* protects everything */
+	struct mutex lock;
+	dm_cblock_t cache_size;
+	struct io_tracker tracker;
+
+	/*
+	 * We maintain two queues of entries.  The cache proper contains
+	 * the currently active mappings.  Whereas the pre_cache tracks
+	 * blocks that are being hit frequently and potential candidates
+	 * for promotion to the cache.
+	 */
+	struct queue pre_cache;
+	struct queue cache;
+
+	/*
+	 * Keeps track of time, incremented by the core.  We use this to
+	 * avoid attributing multiple hits within the same tick.
+	 *
+	 * Access to tick_protected should be done with the spin lock held.
+	 * It's copied to tick at the start of the map function (within the
+	 * mutex).
+	 */
+	spinlock_t tick_lock;
+	unsigned tick_protected;
+	unsigned tick;
+
+	/*
+	 * A count of the number of times the map function has been called
+	 * and found an entry in the pre_cache or cache.  Currently used to
+	 * calculate the generation.
+	 */
+	unsigned hit_count;
+
+	/*
+	 * A generation is a longish period that is used to trigger some
+	 * book keeping effects.  eg, decrementing hit counts on entries.
+	 * This is needed to allow the cache to evolve as io patterns
+	 * change.
+	 */
+	unsigned generation;
+	unsigned generation_period; /* in lookups (will probably change) */
+
+	/*
+	 * Entries in the pre_cache whose hit count passes the promotion
+	 * threshold move to the cache proper.  Working out the correct
+	 * value for the promotion_threshold is crucial to this policy.
+	 */
+	unsigned promote_threshold;
+
+	/*
+	 * We need cache_size entries for the cache, and choose to have
+	 * cache_size entries for the pre_cache too.  One motivation for
+	 * using the same size is to make the hit counts directly
+	 * comparable between pre_cache and cache.
+	 */
+	unsigned nr_entries;
+	unsigned nr_entries_allocated;
+	struct list_head free;
+
+	/*
+	 * Cache blocks may be unallocated.  We store this info in a
+	 * bitset.
+	 */
+	unsigned long *allocation_bitset;
+	unsigned nr_cblocks_allocated;
+	unsigned find_free_nr_words;
+	unsigned find_free_last_word;
+
+	/*
+	 * The hash table allows us to quickly find an entry by origin
+	 * block.  Both pre_cache and cache entries are in here.
+	 */
+	unsigned nr_buckets;
+	dm_block_t hash_bits;
+	struct hlist_head *table;
+
+	int threshold_args[2];
+};
+
+/*----------------------------------------------------------------*/
+/* Free/alloc mq cache entry structures. */
+static void takeout_queue(struct list_head *lh, struct queue *q)
+{
+	unsigned level;
+
+	for (level = 0; level < NR_QUEUE_LEVELS; level++)
+		list_splice(q->qs + level, lh);
+}
+
+static void free_entries(struct mq_policy *mq)
+{
+	struct entry *e, *tmp;
+
+	takeout_queue(&mq->free, &mq->pre_cache);
+	takeout_queue(&mq->free, &mq->cache);
+
+	list_for_each_entry_safe(e, tmp, &mq->free, list)
+		kmem_cache_free(mq_entry_cache, e);
+}
+
+static int alloc_entries(struct mq_policy *mq, unsigned elts)
+{
+	unsigned u = mq->nr_entries;
+
+	INIT_LIST_HEAD(&mq->free);
+	mq->nr_entries_allocated = 0;
+
+	while (u--) {
+		struct entry *e = kmem_cache_zalloc(mq_entry_cache, GFP_KERNEL);
+
+		if (!e) {
+			free_entries(mq);
+			return -ENOMEM;
+		}
+
+
+		list_add(&e->list, &mq->free);
+	}
+
+	return 0;
+}
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Simple hash table implementation.  Should replace with the standard hash
+ * table that's making its way upstream.
+ */
+static void hash_insert(struct mq_policy *mq, struct entry *e)
+{
+	unsigned h = hash_64(from_oblock(e->oblock), mq->hash_bits);
+	hlist_add_head(&e->hlist, mq->table + h);
+}
+
+static struct entry *hash_lookup(struct mq_policy *mq, dm_oblock_t oblock)
+{
+	unsigned h = hash_64(from_oblock(oblock), mq->hash_bits);
+	struct hlist_head *bucket = mq->table + h;
+	struct hlist_node *tmp;
+	struct entry *e;
+
+	hlist_for_each_entry(e, tmp, bucket, hlist)
+		if (e->oblock == oblock) {
+			hlist_del(&e->hlist);
+			hlist_add_head(&e->hlist, bucket);
+			return e;
+		}
+
+	return NULL;
+}
+
+static void hash_remove(struct entry *e)
+{
+	hlist_del(&e->hlist);
+}
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Allocates a new entry structure.  The memory is allocated in one lump,
+ * so we just handing it out here.  Returns NULL if all entries have
+ * already been allocated.  Cannot fail otherwise.
+ */
+static struct entry *alloc_entry(struct mq_policy *mq)
+{
+	struct entry *e;
+
+	if (mq->nr_entries_allocated >= mq->nr_entries) {
+		BUG_ON(!list_empty(&mq->free));
+		return NULL;
+	}
+
+	e = list_entry(list_pop(&mq->free), struct entry, list);
+	INIT_LIST_HEAD(&e->list);
+	INIT_HLIST_NODE(&e->hlist);
+
+	mq->nr_entries_allocated++;
+	return e;
+}
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Mark cache blocks allocated or not in the bitset.
+ */
+static void alloc_cblock(struct mq_policy *mq, dm_cblock_t cblock)
+{
+	BUG_ON(from_cblock(cblock) > from_cblock(mq->cache_size));
+	BUG_ON(test_bit(from_cblock(cblock), mq->allocation_bitset));
+	set_bit(from_cblock(cblock), mq->allocation_bitset);
+	mq->nr_cblocks_allocated++;
+}
+
+static void free_cblock(struct mq_policy *mq, dm_cblock_t cblock)
+{
+	BUG_ON(from_cblock(cblock) > from_cblock(mq->cache_size));
+	BUG_ON(!test_bit(from_cblock(cblock), mq->allocation_bitset));
+	clear_bit(from_cblock(cblock), mq->allocation_bitset);
+	mq->nr_cblocks_allocated--;
+}
+
+static bool any_free_cblocks(struct mq_policy *mq)
+{
+	return mq->nr_cblocks_allocated < from_cblock(mq->cache_size);
+}
+
+/*
+ * Fills result out with a cache block that isn't in use, or return
+ * -ENOSPC.  This does _not_ mark the cblock as allocated, the caller is
+ * reponsible for that.
+ */
+static int __find_free_cblock(struct mq_policy *mq, unsigned begin, unsigned end,
+			      dm_cblock_t *result, unsigned *last_word)
+{
+	int r = -ENOSPC;
+	unsigned w;
+
+	for (w = begin; w < end; w++) {
+		/*
+		 * ffz is undefined if no zero exists
+		 */
+		if (mq->allocation_bitset[w] != ~0UL) {
+			*last_word = w;
+			*result = to_cblock((w * BITS_PER_LONG) + ffz(mq->allocation_bitset[w]));
+			if (from_cblock(*result) < from_cblock(mq->cache_size))
+				r = 0;
+
+			break;
+		}
+	}
+
+	return r;
+}
+
+static int find_free_cblock(struct mq_policy *mq, dm_cblock_t *result)
+{
+	int r;
+
+	if (!any_free_cblocks(mq))
+		return -ENOSPC;
+
+	r = __find_free_cblock(mq, mq->find_free_last_word, mq->find_free_nr_words, result, &mq->find_free_last_word);
+	if (r == -ENOSPC && mq->find_free_last_word)
+		r = __find_free_cblock(mq, 0, mq->find_free_last_word, result, &mq->find_free_last_word);
+
+	return r;
+}
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Now we get to the meat of the policy.  This section deals with deciding
+ * when to to add entries to the pre_cache and cache, and move between
+ * them.
+ */
+
+/*
+ * The queue level is based on the log2 of the hit count.
+ */
+static unsigned queue_level(struct entry *e)
+{
+	return min((unsigned) ilog2(e->hit_count), NR_QUEUE_LEVELS - 1u);
+}
+
+/*
+ * Inserts the entry into the pre_cache or the cache.  Ensures the cache
+ * block is marked as allocated if necc.  Inserts into the hash table.  Sets the
+ * tick which records when the entry was last moved about.
+ */
+static void push(struct mq_policy *mq, struct entry *e)
+{
+	e->tick = mq->tick;
+	hash_insert(mq, e);
+
+	if (e->in_cache) {
+		alloc_cblock(mq, e->cblock);
+		queue_push(&mq->cache, queue_level(e), &e->list);
+	} else
+		queue_push(&mq->pre_cache, queue_level(e), &e->list);
+}
+
+/*
+ * Removes an entry from pre_cache or cache.  Removes from the hash table.
+ * Frees off the cache block if necc.
+ */
+static void del(struct mq_policy *mq, struct entry *e)
+{
+	queue_remove(&e->list);
+	hash_remove(e);
+	if (e->in_cache)
+		free_cblock(mq, e->cblock);
+}
+
+/*
+ * Like del, except it removes the first entry in the queue (ie. the least
+ * recently used).
+ */
+static struct entry *pop(struct mq_policy *mq, struct queue *q)
+{
+	struct entry *e = container_of(queue_pop(q), struct entry, list);
+
+	if (e) {
+		hash_remove(e);
+
+		if (e->in_cache)
+			free_cblock(mq, e->cblock);
+	}
+
+	return e;
+}
+
+/*
+ * Has this entry already been updated?
+ */
+static bool updated_this_tick(struct mq_policy *mq, struct entry *e)
+{
+	return mq->tick == e->tick;
+}
+
+/*
+ * The promotion threshold is adjusted every generation.  As are the counts
+ * of the entries.
+ *
+ * At the moment the threshold is taken by averaging the hit counts of some
+ * of the entries in the cache (the first 20 entries of the first level).
+ *
+ * We can be much cleverer than this though.  For example, each promotion
+ * could bump up the threshold helping to prevent churn.  Much more to do
+ * here.
+ */
+
+#define MAX_TO_AVERAGE 20
+
+static void check_generation(struct mq_policy *mq)
+{
+	unsigned total = 0, nr = 0, count = 0, level;
+	struct list_head *head;
+	struct entry *e;
+
+	if ((mq->hit_count >= mq->generation_period) &&
+	    (mq->nr_cblocks_allocated == from_cblock(mq->cache_size))) {
+
+		mq->hit_count = 0;
+		mq->generation++;
+
+		for (level = 0; level < NR_QUEUE_LEVELS && count < MAX_TO_AVERAGE; level++) {
+			head = mq->cache.qs + level;
+			list_for_each_entry (e, head, list) {
+				nr++;
+				total += e->hit_count;
+
+				if (++count >= MAX_TO_AVERAGE)
+					break;
+			}
+		}
+
+		mq->promote_threshold = nr ? total / nr : 1;
+		if (mq->promote_threshold * nr < total)
+			mq->promote_threshold++;
+
+		pr_alert("promote threshold = %u, nr = %u\n", mq->promote_threshold, nr);
+	}
+}
+
+/*
+ * Whenever we use an entry we bump up it's hit counter, and push it to the
+ * back to it's current level.
+ */
+static void requeue_and_update_tick(struct mq_policy *mq, struct entry *e)
+{
+	if (updated_this_tick(mq, e))
+		return;
+
+	e->hit_count++;
+	mq->hit_count++;
+	check_generation(mq);
+
+	/* generation adjustment, to stop the counts increasing forever. */
+	/* FIXME: divide? */
+	//e->hit_count -= min(e->hit_count - 1, mq->generation - e->generation);
+	e->generation = mq->generation;
+
+	del(mq, e);
+	push(mq, e);
+}
+
+/*
+ * Demote the least recently used entry from the cache to the pre_cache.
+ * Returns the new cache entry to use, and the old origin block it was
+ * mapped to.
+ *
+ * We drop the hit count on the demoted entry back to 1 to stop it bouncing
+ * straight back into the cache if it's subsequently hit.  There are
+ * various options here, and more experimentation would be good:
+ *
+ * - just forget about the demoted entry completely (ie. don't insert it
+     into the pre_cache).
+ * - divide the hit count rather that setting to some hard coded value.
+ * - set the hit count to a hard coded value other than 1, eg, is it better
+ *   if it goes in at level 2?
+ */
+static dm_cblock_t demote_cblock(struct mq_policy *mq, dm_oblock_t *oblock)
+{
+	dm_cblock_t result;
+	struct entry *demoted = pop(mq, &mq->cache);
+
+	BUG_ON(!demoted);
+	result = demoted->cblock;
+	*oblock = demoted->oblock;
+	demoted->in_cache = false;
+	demoted->hit_count = 1;
+	push(mq, demoted);
+
+	return result;
+}
+
+/*
+ * We modify the basic promotion_threshold depending on the specific io.
+ *
+ * If the origin block has been discarded then there's no cost to copy it
+ * to the cache.
+ *
+ * We bias towards reads, since they can be demoted at no cost if they
+ * haven't been dirtied.
+ */
+#define DISCARDED_PROMOTE_THRESHOLD 1
+#define READ_PROMOTE_THRESHOLD 4
+#define WRITE_PROMOTE_THRESHOLD 8
+
+static unsigned adjusted_promote_threshold(struct mq_policy *mq,
+					   bool discarded_oblock, int data_dir)
+{
+	if (discarded_oblock && any_free_cblocks(mq) && data_dir == WRITE)
+		/*
+		 * We don't need to do any copying at all, so give this a
+		 * very low threshold.  In practice this only triggers
+		 * during initial population after a format.
+		 */
+		return DISCARDED_PROMOTE_THRESHOLD;
+
+	return data_dir == READ ?
+		(mq->promote_threshold + READ_PROMOTE_THRESHOLD) :
+		(mq->promote_threshold + WRITE_PROMOTE_THRESHOLD);
+}
+
+static bool should_promote(struct mq_policy *mq, struct entry *e,
+			   bool discarded_oblock, int data_dir)
+{
+	return e->hit_count >=
+		adjusted_promote_threshold(mq, discarded_oblock, data_dir);
+}
+
+static int cache_entry_found(struct mq_policy *mq,
+			     struct entry *e,
+			     struct policy_result *result)
+{
+	requeue_and_update_tick(mq, e);
+
+	if (e->in_cache) {
+		result->op = POLICY_HIT;
+		result->cblock = e->cblock;
+		return 0;
+	}
+
+	return 0;
+}
+
+/*
+ * Moves and entry from the pre_cache to the cache.  The main work is
+ * finding which cache block to use.
+ */
+static int pre_cache_to_cache(struct mq_policy *mq, struct entry *e,
+			      struct policy_result *result)
+{
+	dm_cblock_t cblock;
+
+	if (find_free_cblock(mq, &cblock) == -ENOSPC) {
+		result->op = POLICY_REPLACE;
+		cblock = demote_cblock(mq, &result->old_oblock);
+	} else
+		result->op = POLICY_NEW;
+
+	result->cblock = e->cblock = cblock;
+
+	del(mq, e);
+	e->in_cache = true;
+	push(mq, e);
+
+	return 0;
+}
+
+static int pre_cache_entry_found(struct mq_policy *mq, struct entry *e,
+				 bool can_migrate, bool discarded_oblock,
+				 int data_dir, struct policy_result *result)
+{
+	int r = 0;
+	bool updated = updated_this_tick(mq, e);
+
+	requeue_and_update_tick(mq, e);
+
+	if ((!discarded_oblock && updated) ||
+	    !should_promote(mq, e, discarded_oblock, data_dir))
+		result->op = POLICY_MISS;
+
+	else if (!can_migrate)
+		r = -EWOULDBLOCK;
+
+	else
+		r = pre_cache_to_cache(mq, e, result);
+
+	return r;
+}
+
+static void insert_in_pre_cache(struct mq_policy *mq,
+				dm_oblock_t oblock)
+{
+	struct entry *e = alloc_entry(mq);
+
+	if (!e)
+		/*
+		 * There's no spare entry structure, so we grab the least
+		 * used one from the pre_cache.
+		 */
+		e = pop(mq, &mq->pre_cache);
+
+	if (unlikely(!e)) {
+		DMWARN("couldn't pop from pre cache");
+		return;
+	}
+
+	e->in_cache = false;
+	e->oblock = oblock;
+	e->hit_count = 1;
+	e->generation = mq->generation;
+	push(mq, e);
+}
+
+static void insert_in_cache(struct mq_policy *mq, dm_oblock_t oblock,
+			    struct policy_result *result)
+{
+	struct entry *e;
+	dm_cblock_t cblock;
+
+	if (find_free_cblock(mq, &cblock) == -ENOSPC) {
+		result->op = POLICY_MISS;
+		insert_in_pre_cache(mq, oblock);
+		return;
+	}
+
+	e = alloc_entry(mq);
+	if (unlikely(!e)) {
+		result->op = POLICY_MISS;
+		return;
+	}
+
+	e->oblock = oblock;
+	e->cblock = cblock;
+	e->in_cache = true;
+	e->hit_count = 1;
+	e->generation = mq->generation;
+	push(mq, e);
+
+	result->op = POLICY_NEW;
+	result->cblock = e->cblock;
+}
+
+static int no_entry_found(struct mq_policy *mq, dm_oblock_t oblock,
+			  bool can_migrate, bool discarded_oblock,
+			  int data_dir, struct policy_result *result)
+{
+	if (adjusted_promote_threshold(mq, discarded_oblock, data_dir) == 1) {
+		if (can_migrate) {
+			insert_in_cache(mq, oblock, result);
+			return 0;
+		} else
+			return -EWOULDBLOCK;
+
+	} else {
+		insert_in_pre_cache(mq, oblock);
+		result->op = POLICY_MISS;
+		return 0;
+	}
+}
+
+/*
+ * Looks the oblock up in the hash table, then decides whether to put in
+ * pre_cache, or cache etc.
+ */
+static int map(struct mq_policy *mq, dm_oblock_t oblock,
+	       bool can_migrate, bool discarded_oblock,
+	       int data_dir, struct policy_result *result)
+{
+	int r = 0;
+	struct entry *e = hash_lookup(mq, oblock);
+
+	if (e && e->in_cache)
+		r = cache_entry_found(mq, e, result);
+
+	else if (iot_pattern(&mq->tracker) == PATTERN_SEQUENTIAL)
+		result->op = POLICY_MISS;
+
+	else if (e)
+		r = pre_cache_entry_found(mq, e, can_migrate, discarded_oblock,
+					  data_dir, result);
+	else
+		r = no_entry_found(mq, oblock, can_migrate, discarded_oblock,
+				   data_dir, result);
+
+	if (r == -EWOULDBLOCK)
+		result->op = POLICY_MISS;
+	return r;
+}
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Public interface, via the policy struct.  See dm-cache-policy.h for a
+ * description of these.
+ */
+
+static struct mq_policy *to_mq_policy(struct dm_cache_policy *p)
+{
+	return container_of(p, struct mq_policy, policy);
+}
+
+static void mq_destroy(struct dm_cache_policy *p)
+{
+	struct mq_policy *mq = to_mq_policy(p);
+
+	free_bitset(mq->allocation_bitset);
+	kfree(mq->table);
+	free_entries(mq);
+	kfree(mq);
+}
+
+static void copy_tick(struct mq_policy *mq)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mq->tick_lock, flags);
+	mq->tick = mq->tick_protected;
+	spin_unlock_irqrestore(&mq->tick_lock, flags);
+}
+
+static int mq_map(struct dm_cache_policy *p, dm_oblock_t oblock,
+		  bool can_block, bool can_migrate, bool discarded_oblock,
+		  struct bio *bio, struct policy_result *result)
+{
+	int r;
+	struct mq_policy *mq = to_mq_policy(p);
+
+	result->op = POLICY_MISS;
+
+	if (can_block)
+		mutex_lock(&mq->lock);
+	else
+		if (!mutex_trylock(&mq->lock))
+			return -EWOULDBLOCK;
+
+	copy_tick(mq);
+
+	iot_examine_bio(&mq->tracker, bio);
+	r = map(mq, oblock, can_migrate, discarded_oblock,
+		bio_data_dir(bio), result);
+
+	mutex_unlock(&mq->lock);
+
+	return r;
+}
+
+static int mq_lookup(struct dm_cache_policy *p, dm_oblock_t oblock, dm_cblock_t *cblock)
+{
+	int r;
+	struct mq_policy *mq = to_mq_policy(p);
+	struct entry *e;
+
+	if (!mutex_trylock(&mq->lock))
+		return -EWOULDBLOCK;
+
+	e = hash_lookup(mq, oblock);
+	if (e && e->in_cache) {
+		*cblock = e->cblock;
+		r = 0;
+
+	} else
+		r = -ENOENT;
+
+	mutex_unlock(&mq->lock);
+
+	return r;
+}
+
+static int mq_load_mapping(struct dm_cache_policy *p,
+			   dm_oblock_t oblock, dm_cblock_t cblock,
+			   uint32_t hint, bool hint_valid)
+{
+	struct mq_policy *mq = to_mq_policy(p);
+	struct entry *e;
+
+	e = alloc_entry(mq);
+	if (!e)
+		return -ENOMEM;
+
+	e->cblock = cblock;
+	e->oblock = oblock;
+	e->in_cache = true;
+	e->hit_count = hint_valid ? hint : 1;
+	e->generation = mq->generation;
+	push(mq, e);
+
+	return 0;
+}
+
+static int mq_walk_mappings(struct dm_cache_policy *p, policy_walk_fn fn,
+			    void *context)
+{
+	struct mq_policy *mq = to_mq_policy(p);
+	int r = 0;
+	struct entry *e;
+	unsigned level;
+
+	mutex_lock(&mq->lock);
+	for (level = 0; level < NR_QUEUE_LEVELS; level++)
+		list_for_each_entry(e, &mq->cache.qs[level], list) {
+			r = fn(context, e->cblock, e->oblock, e->hit_count);
+			if (r)
+				goto out;
+		}
+
+out:
+	mutex_unlock(&mq->lock);
+	return r;
+}
+
+static void remove_mapping(struct mq_policy *mq, dm_oblock_t oblock)
+{
+	struct entry *e = hash_lookup(mq, oblock);
+
+	BUG_ON(!e || !e->in_cache);
+
+	del(mq, e);
+	e->in_cache = false;
+	push(mq, e);
+}
+
+static void mq_remove_mapping(struct dm_cache_policy *p, dm_oblock_t oblock)
+{
+	struct mq_policy *mq = to_mq_policy(p);
+
+	mutex_lock(&mq->lock);
+	remove_mapping(mq, oblock);
+	mutex_unlock(&mq->lock);
+}
+
+static void force_mapping(struct mq_policy *mq,
+			  dm_oblock_t current_oblock, dm_oblock_t new_oblock)
+{
+	struct entry *e = hash_lookup(mq, current_oblock);
+
+	BUG_ON(!e || !e->in_cache);
+
+	del(mq, e);
+	e->oblock = new_oblock;
+	push(mq, e);
+}
+
+static void mq_force_mapping(struct dm_cache_policy *p,
+			     dm_oblock_t current_oblock, dm_oblock_t new_oblock)
+{
+	struct mq_policy *mq = to_mq_policy(p);
+
+	mutex_lock(&mq->lock);
+	force_mapping(mq, current_oblock, new_oblock);
+	mutex_unlock(&mq->lock);
+}
+
+static dm_cblock_t mq_residency(struct dm_cache_policy *p)
+{
+	struct mq_policy *mq = to_mq_policy(p);
+
+	// FIXME: lock mutex, not sure we can block here
+	return to_cblock(mq->nr_cblocks_allocated);
+}
+
+static void mq_tick(struct dm_cache_policy *p)
+{
+	struct mq_policy *mq = to_mq_policy(p);
+	unsigned long flags;
+
+	spin_lock_irqsave(&mq->tick_lock, flags);
+	mq->tick_protected++;
+	spin_unlock_irqrestore(&mq->tick_lock, flags);
+}
+
+static int process_config_option(struct mq_policy *mq, char **argv, bool set_ctr_arg)
+{
+	enum io_pattern pattern;
+	unsigned long tmp;
+
+	if (!strcasecmp(argv[0], "sequential_threshold"))
+		pattern = PATTERN_SEQUENTIAL;
+	else if (!strcasecmp(argv[0], "random_threshold"))
+		pattern = PATTERN_RANDOM;
+	else
+		return -EINVAL;
+
+	if (kstrtoul(argv[1], 10, &tmp))
+		return -EINVAL;
+
+
+	if (set_ctr_arg) {
+		if (mq->threshold_args[pattern] > -1)
+			return -EINVAL;
+
+		mq->threshold_args[pattern] = tmp;
+	}
+
+	mq->tracker.thresholds[pattern] = tmp;
+
+	return 0;
+}
+
+static int mq_message(struct dm_cache_policy *p, unsigned argc, char **argv)
+{
+	int r = -EINVAL;
+	struct mq_policy *mq = to_mq_policy(p);
+
+	if (argc != 3)
+		return -EINVAL;
+
+	if (!strcasecmp(argv[0], "set_config"))
+		r = process_config_option(mq, argv + 1, false);
+
+	return r;
+}
+
+static int mq_status(struct dm_cache_policy *p, status_type_t type,
+		     unsigned status_flags, char *result, unsigned maxlen)
+{
+	ssize_t sz = 0;
+	struct mq_policy *mq = to_mq_policy(p);
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		DMEMIT(" %u %u",
+		       mq->tracker.thresholds[PATTERN_SEQUENTIAL],
+		       mq->tracker.thresholds[PATTERN_RANDOM]);
+		break;
+
+	case STATUSTYPE_TABLE:
+		if (mq->threshold_args[PATTERN_SEQUENTIAL] > -1)
+			DMEMIT(" sequential_threshold %u", mq->threshold_args[PATTERN_SEQUENTIAL]);
+
+		if (mq->threshold_args[PATTERN_RANDOM] > -1)
+			DMEMIT(" random_threshold %u", mq->threshold_args[PATTERN_RANDOM]);
+	}
+
+	return 0;
+}
+
+static int process_policy_args(struct mq_policy *mq, int argc, char **argv)
+{
+	int r;
+	unsigned u;
+
+	mq->threshold_args[0] = mq->threshold_args[1] = -1;
+
+	if (!argc)
+		return 0;
+
+	if (argc != 2 && argc != 4)
+		return -EINVAL;
+
+	for (r = u = 0; u < argc && !r; u += 2)
+		r = process_config_option(mq, argv + u, true);
+
+	return r;
+}
+
+/* Init the policy plugin interface function pointers. */
+static void init_policy_functions(struct mq_policy *mq)
+{
+	mq->policy.destroy = mq_destroy;
+	mq->policy.map = mq_map;
+	mq->policy.lookup = mq_lookup;
+	mq->policy.load_mapping = mq_load_mapping;
+	mq->policy.walk_mappings = mq_walk_mappings;
+	mq->policy.remove_mapping = mq_remove_mapping;
+	mq->policy.writeback_work = NULL;
+	mq->policy.force_mapping = mq_force_mapping;
+	mq->policy.residency = mq_residency;
+	mq->policy.tick = mq_tick;
+	mq->policy.status = mq_status;
+	mq->policy.message = mq_message;
+}
+
+static struct dm_cache_policy *mq_create(dm_cblock_t cache_size,
+					 sector_t origin_size,
+					 sector_t block_size,
+					 int argc, char **argv)
+{
+	int r;
+	struct mq_policy *mq = kzalloc(sizeof(*mq), GFP_KERNEL);
+
+	if (!mq)
+		return NULL;
+
+	init_policy_functions(mq);
+
+	/* Need to do that before iot_init(). */
+	r = process_policy_args(mq, argc, argv);
+	if (r)
+		goto bad_free_policy;
+
+	iot_init(&mq->tracker, mq->threshold_args[PATTERN_SEQUENTIAL], mq->threshold_args[PATTERN_RANDOM]);
+
+	mq->cache_size = cache_size;
+	mq->tick_protected = 0;
+	mq->tick = 0;
+	mq->hit_count = 0;
+	mq->generation = 0;
+	mq->promote_threshold = 0;
+	mutex_init(&mq->lock);
+	spin_lock_init(&mq->tick_lock);
+	mq->find_free_nr_words = dm_div_up(from_cblock(mq->cache_size), BITS_PER_LONG);
+	mq->find_free_last_word = 0;
+
+	queue_init(&mq->pre_cache);
+	queue_init(&mq->cache);
+	mq->generation_period = max((unsigned) from_cblock(cache_size), 1024U);
+
+	mq->nr_entries = 2 * from_cblock(cache_size);
+	r = alloc_entries(mq, mq->nr_entries);
+	if (r)
+		goto bad_cache_alloc;
+
+	mq->nr_entries_allocated = 0;
+	mq->nr_cblocks_allocated = 0;
+
+	mq->nr_buckets = next_power(from_cblock(cache_size) / 2, 16);
+	mq->hash_bits = ffs(mq->nr_buckets) - 1;
+	mq->table = kzalloc(sizeof(*mq->table) * mq->nr_buckets, GFP_KERNEL);
+	if (!mq->table)
+		goto bad_alloc_table;
+
+	mq->allocation_bitset = alloc_bitset(from_cblock(cache_size));
+	if (!mq->allocation_bitset)
+		goto bad_alloc_bitset;
+
+	return &mq->policy;
+
+bad_alloc_bitset:
+	kfree(mq->table);
+bad_alloc_table:
+	free_entries(mq);
+bad_free_policy:
+bad_cache_alloc:
+	kfree(mq);
+
+	return NULL;
+}
+
+/*----------------------------------------------------------------*/
+
+static struct dm_cache_policy_type mq_policy_type = {
+	.name = "mq",
+	.hint_size = 0,
+	.owner = THIS_MODULE,
+        .create = mq_create
+};
+
+static struct dm_cache_policy_type default_policy_type = {
+	.name = "default",
+	.hint_size = 0,
+	.owner = THIS_MODULE,
+        .create = mq_create
+};
+
+static int __init mq_init(void)
+{
+	int r;
+
+	mq_entry_cache = kmem_cache_create("dm_mq_policy_cache_entry",
+					   sizeof(struct entry),
+					   __alignof__(struct entry),
+					   0, NULL);
+	if (!mq_entry_cache)
+		goto bad;
+
+	r = dm_cache_policy_register(&mq_policy_type);
+	if (r)
+		goto bad_register_mq;
+
+	r = dm_cache_policy_register(&default_policy_type);
+	if (!r)
+		return 0;
+
+	dm_cache_policy_unregister(&mq_policy_type);
+bad_register_mq:
+	kmem_cache_destroy(mq_entry_cache);
+bad:
+	return -ENOMEM;
+}
+
+static void __exit mq_exit(void)
+{
+	dm_cache_policy_unregister(&mq_policy_type);
+	dm_cache_policy_unregister(&default_policy_type);
+	kmem_cache_destroy(mq_entry_cache);
+}
+
+module_init(mq_init);
+module_exit(mq_exit);
+
+MODULE_AUTHOR("Joe Thornber");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("mq cache policy");
+
+MODULE_ALIAS("dm-cache-default");
+
+/*----------------------------------------------------------------*/
diff --git a/drivers/md/dm-cache-policy.c b/drivers/md/dm-cache-policy.c
new file mode 100644
index 0000000..6c57873
--- /dev/null
+++ b/drivers/md/dm-cache-policy.c
@@ -0,0 +1,147 @@
+/*
+ * Copyright (C) 2012 Red Hat. All rights reserved.
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm-cache-policy-internal.h"
+#include "dm.h"
+
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+/*----------------------------------------------------------------*/
+
+#define DM_MSG_PREFIX "cache-policy"
+static DEFINE_SPINLOCK(register_lock);
+static LIST_HEAD(register_list);
+
+static struct dm_cache_policy_type *__find_policy(const char *name)
+{
+	struct dm_cache_policy_type *t;
+
+	list_for_each_entry (t, &register_list, list)
+		if (!strcmp(t->name, name))
+			return t;
+
+	return NULL;
+}
+
+static struct dm_cache_policy_type *__get_policy(const char *name)
+{
+	struct dm_cache_policy_type *t = __find_policy(name);
+
+	if (!t) {
+		spin_unlock(&register_lock);
+		request_module("dm-cache-%s", name);
+		spin_lock(&register_lock);
+		t = __find_policy(name);
+	}
+
+	if (t && !try_module_get(t->owner)) {
+		DMWARN("couldn't get module");
+		t = NULL;
+	}
+
+	return t;
+}
+
+static struct dm_cache_policy_type *get_policy(const char *name)
+{
+	struct dm_cache_policy_type *t;
+
+	spin_lock(&register_lock);
+	t = __get_policy(name);
+	spin_unlock(&register_lock);
+
+	return t;
+}
+
+static void put_policy(struct dm_cache_policy_type *t)
+{
+	module_put(t->owner);
+}
+
+int dm_cache_policy_register(struct dm_cache_policy_type *type)
+{
+	int r;
+
+	/* One size fits all for now */
+	if (type->hint_size != 0 && type->hint_size != 4)
+		return -EINVAL;
+
+	spin_lock(&register_lock);
+	if (__find_policy(type->name)) {
+		DMWARN("attempt to register policy under duplicate name");
+		r = -EINVAL;
+	} else {
+		list_add(&type->list, &register_list);
+		r = 0;
+	}
+	spin_unlock(&register_lock);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(dm_cache_policy_register);
+
+void dm_cache_policy_unregister(struct dm_cache_policy_type *type)
+{
+	spin_lock(&register_lock);
+	list_del_init(&type->list);
+	spin_unlock(&register_lock);
+}
+EXPORT_SYMBOL_GPL(dm_cache_policy_unregister);
+
+struct dm_cache_policy *dm_cache_policy_create(const char *name,
+					       dm_cblock_t cache_size,
+					       sector_t origin_size,
+					       sector_t block_size,
+					       int argc, char **argv)
+{
+	struct dm_cache_policy *p = NULL;
+	struct dm_cache_policy_type *type;
+
+	type = get_policy(name);
+	if (!type) {
+		DMWARN("unknown policy type");
+		return NULL;
+	}
+
+	p = type->create(cache_size, origin_size, block_size, argc, argv);
+	if (!p) {
+		put_policy(type);
+		return NULL;
+	}
+	p->private = type;
+
+	return p;
+}
+EXPORT_SYMBOL_GPL(dm_cache_policy_create);
+
+void dm_cache_policy_destroy(struct dm_cache_policy *p)
+{
+	struct dm_cache_policy_type *t = p->private;
+
+	put_policy(t);
+	p->destroy(p);
+}
+EXPORT_SYMBOL_GPL(dm_cache_policy_destroy);
+
+const char *dm_cache_policy_get_name(struct dm_cache_policy *p)
+{
+	struct dm_cache_policy_type *t = p->private;
+
+	return t->name;
+}
+EXPORT_SYMBOL_GPL(dm_cache_policy_get_name);
+
+size_t dm_cache_policy_get_hint_size(struct dm_cache_policy *p)
+{
+	struct dm_cache_policy_type *t = p->private;
+
+	return t->hint_size;
+}
+EXPORT_SYMBOL_GPL(dm_cache_policy_get_hint_size);
+
+/*----------------------------------------------------------------*/
diff --git a/drivers/md/dm-cache-policy.h b/drivers/md/dm-cache-policy.h
new file mode 100644
index 0000000..942bc1e
--- /dev/null
+++ b/drivers/md/dm-cache-policy.h
@@ -0,0 +1,220 @@
+/*
+ * Copyright (C) 2012 Red Hat. All rights reserved.
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef DM_CACHE_POLICY_H
+#define DM_CACHE_POLICY_H
+
+#include "dm-cache-metadata.h"
+#include "persistent-data/dm-block-manager.h"
+
+#include <linux/device-mapper.h>
+
+/*----------------------------------------------------------------*/
+
+/* FIXME: make it clear which methods are optional.  Get debug policy to
+ * double check this at start.
+ */
+
+/*
+ * The cache policy makes the important decisions about which blocks get to
+ * live on the faster cache device.
+ *
+ * When the core target has to remap a bio it calls the 'map' method of the
+ * policy.  This returns an instruction telling the core target what to do.
+ *
+ * POLICY_HIT:
+ *   That block is in the cache.  Remap to the cache and carry on.
+ *
+ * POLICY_MISS:
+ *   This block is on the origin device.  Remap and carry on.
+ *
+ * POLICY_NEW:
+ *   This block is currently on the origin device, but the policy wants to
+ *   move it.  The core should:
+ *
+ *   - hold any further io to this origin block
+ *   - copy the origin to the given cache block
+ *   - release all the held blocks
+ *   - remap the original block to the cache
+ *
+ * POLICY_REPLACE:
+ *   This block is currently on the origin device.  The policy wants to
+ *   move it to the cache, with the added complication that the destination
+ *   cache block needs a writeback first.  The core should:
+ *
+ *   - hold any further io to this origin block
+ *   - hold any further io to the origin block that's being written back
+ *   - writeback
+ *   - copy new block to cache
+ *   - release held blocks
+ *   - remap bio to cache and reissue.
+ *
+ * Should the core run into trouble while processing a POLICY_NEW or
+ * POLICY_REPLACE instruction it will roll back the policies mapping using
+ * remove_mapping() or force_mapping().  These methods must not fail.  This
+ * approach avoids having transactional semantics in the policy (ie, the
+ * core informing the policy when a migration is complete), and hence makes
+ * it easier to write new policies.
+ *
+ * In general policy methods should never block, except in the case of the
+ * map function when can_migrate is set.  So be careful to implement using
+ * bounded, preallocated memory.
+ */
+enum policy_operation {
+	POLICY_HIT,
+	POLICY_MISS,
+	POLICY_NEW,
+	POLICY_REPLACE
+};
+
+/*
+ * This is the instruction passed back to the core target.
+ */
+struct policy_result {
+	enum policy_operation op;
+	dm_oblock_t old_oblock;	/* POLICY_REPLACE */
+	dm_cblock_t cblock;	/* POLICY_HIT, POLICY_NEW, POLICY_REPLACE */
+};
+
+typedef int (*policy_walk_fn)(void *context, dm_cblock_t cblock,
+			      dm_oblock_t oblock, uint32_t hint);
+
+/*
+ * The cache policy object.  Just a bunch of methods.  It is envisaged that
+ * this structure will be embedded in a bigger, policy specific structure
+ * (ie. use container_of()).
+ */
+struct dm_cache_policy {
+
+	// FIXME: make it clear which methods are optional, and which may
+	// block.
+
+	/*
+	 * Destroys this object.
+	 */
+	void (*destroy)(struct dm_cache_policy *p);
+
+	/*
+	 * See large comment above.
+	 *
+	 * oblock      - the origin block we're interested in.
+	 *
+	 * can_block - indicates whether the current thread is allowed to
+	 *             block.  -EWOULDBLOCK returned if it can't and would.
+	 *
+	 * can_migrate - gives permission for POLICY_NEW or POLICY_REPLACE
+	 *               instructions.  If denied and the policy would have
+	 *               returned one of these instructions it should
+	 *               return -EWOULDBLOCK.
+	 *
+	 * discarded_oblock - indicates whether the whole origin block is
+	 *               in a discarded state (FIXME: better to tell the
+	 *               policy about this sooner, so it can recycle that
+	 *               cache block if it wants.)
+	 * bio         - the bio that triggered this call.
+	 * result      - gets filled in with the instruction.
+	 *
+	 * May only return 0, or -EWOULDBLOCK (if !can_migrate)
+	 */
+	int (*map)(struct dm_cache_policy *p, dm_oblock_t oblock,
+		   bool can_block, bool can_migrate, bool discarded_oblock,
+		   struct bio *bio, struct policy_result *result);
+
+	/*
+	 * Sometimes we want to see if a block is in the cache, without
+	 * triggering any update of stats.  (ie. it's not a real hit).
+	 *
+	 * Must not block.
+	 *
+	 * Returns 1 iff in cache, 0 iff not, < 0 on error (-EWOULDBLOCK
+	 * would be typical).
+	 */
+	int (*lookup)(struct dm_cache_policy *p, dm_oblock_t oblock, dm_cblock_t *cblock);
+
+	/*
+	 * oblock must be a mapped block.  Must not block.
+	 */
+	void (*set_dirty)(struct dm_cache_policy *p, dm_oblock_t oblock);
+	void (*clear_dirty)(struct dm_cache_policy *p, dm_oblock_t oblock);
+
+	/*
+	 * Called when a cache target is first created.  Used to load a
+	 * mapping from the metadata device into the policy.
+	 */
+	int (*load_mapping)(struct dm_cache_policy *p, dm_oblock_t oblock,
+			    dm_cblock_t cblock, uint32_t hint, bool hint_valid);
+
+	int (*walk_mappings)(struct dm_cache_policy *p, policy_walk_fn fn,
+			     void *context);
+
+	/*
+	 * Override functions used on the error paths of the core target.
+	 * They must succeed.
+	 */
+	void (*remove_mapping)(struct dm_cache_policy *p, dm_oblock_t oblock);
+	void (*force_mapping)(struct dm_cache_policy *p, dm_oblock_t current_oblock,
+			      dm_oblock_t new_oblock);
+
+	int (*writeback_work)(struct dm_cache_policy *p, dm_oblock_t *oblock, dm_cblock_t *cblock);
+
+
+	/*
+	 * How full is the cache?
+	 */
+	dm_cblock_t (*residency)(struct dm_cache_policy *p);
+
+	/*
+	 * Because of where we sit in the block layer, we can be asked to
+	 * map a lot of little bios that are all in the same block (no
+	 * queue merging has occurred).  To stop the policy being fooled by
+	 * these the core target sends regular tick() calls to the policy.
+	 * The policy should only count an entry as hit once per tick.
+	 */
+	void (*tick)(struct dm_cache_policy *p);
+
+	/*
+	 * Status and message.
+	 */
+	int (*status) (struct dm_cache_policy *p, status_type_t type,
+		       unsigned status_flags, char *result, unsigned maxlen);
+	int (*message) (struct dm_cache_policy *p, unsigned argc, char **argv);
+
+	/*
+	 * Book keeping ptr for the policy register, not for general use.
+	 */
+	void *private;
+};
+
+/*----------------------------------------------------------------*/
+
+/*
+ * We maintain a little register of the different policy types.
+ */
+#define CACHE_POLICY_NAME_MAX 16
+
+struct dm_cache_policy_type {
+	/* For use by the register code only. */
+	struct list_head list;
+
+	/*
+	 * Policy writers should fill in these fields.  The name field is
+	 * what gets passed on the target line to select your policy.
+	 */
+	char name[CACHE_POLICY_NAME_MAX];
+	size_t hint_size;	/* in bytes, must be 0 or 4 */
+	struct module *owner;
+	struct dm_cache_policy *(*create)(dm_cblock_t cache_size,
+					  sector_t origin_size,
+					  sector_t block_size,
+					  int argc, char **argv);
+};
+
+int dm_cache_policy_register(struct dm_cache_policy_type *type);
+void dm_cache_policy_unregister(struct dm_cache_policy_type *type);
+
+/*----------------------------------------------------------------*/
+
+#endif
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
new file mode 100644
index 0000000..34b76b2
--- /dev/null
+++ b/drivers/md/dm-cache-target.c
@@ -0,0 +1,2443 @@
+/*
+ * Copyright (C) 2012 Red Hat. All rights reserved.
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm.h"
+#include "dm-bio-prison.h"
+#include "dm-cache-metadata.h"
+#include "dm-cache-policy-internal.h"
+
+#include <asm/div64.h>
+
+#include <linux/blkdev.h>
+#include <linux/dm-io.h>
+#include <linux/dm-kcopyd.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/mempool.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#define DM_MSG_PREFIX "cache"
+#define DAEMON "cached"
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Glossary:
+ *
+ * oblock: index of an origin block
+ * cblock: index of a cache block
+ * promotion: movement of a block from origin to cache
+ * demotion: movement of a block from cache to origin
+ * migration: movement of a block between the origin and cache device,
+ *	      either direction
+ */
+
+/*----------------------------------------------------------------*/
+
+static size_t bitset_size_in_bytes(unsigned nr_entries)
+{
+	return sizeof(unsigned long) * dm_div_up(nr_entries, BITS_PER_LONG);
+}
+
+static unsigned long *alloc_bitset(unsigned nr_entries)
+{
+	size_t s = bitset_size_in_bytes(nr_entries);
+	return vzalloc(s);
+}
+
+static void clear_bitset(void *bitset, unsigned nr_entries)
+{
+	size_t s = bitset_size_in_bytes(nr_entries);
+	memset(bitset, 0, s);
+}
+
+static void free_bitset(unsigned long *bits)
+{
+	vfree(bits);
+}
+
+/*----------------------------------------------------------------*/
+
+#define PRISON_CELLS 1024
+#define MIGRATION_POOL_SIZE 128
+#define COMMIT_PERIOD HZ
+#define MIGRATION_COUNT_WINDOW 10
+
+/*
+ * The block size of the device holding cache data must be >= 32KB
+ */
+#define DATA_DEV_BLOCK_SIZE_MIN_SECTORS (32 * 1024 >> SECTOR_SHIFT)
+
+/*
+ * FIXME: the cache is read/write for the time being.
+ */
+enum cache_mode {
+	CM_WRITE,		/* metadata may be changed */
+	CM_READ_ONLY,		/* metadata may not be changed */
+};
+
+struct cache_features {
+	enum cache_mode mode;
+	bool write_through:1;
+};
+
+struct cache {
+	struct dm_target *ti;
+	struct dm_target_callbacks callbacks;
+
+	/*
+	 * Metadata is written to this device.
+	 */
+	struct dm_dev *metadata_dev;
+
+	/*
+	 * The slower of the two data devices.  Typically a spindle.
+	 */
+	struct dm_dev *origin_dev;
+
+	/*
+	 * The faster of the two data devices.  Typically an SSD.
+	 */
+	struct dm_dev *cache_dev;
+
+	/*
+	 * Cache features such as write-through.
+	 */
+	struct cache_features features;
+
+	/*
+	 * Size of the origin device in _complete_ blocks and native sectors.
+	 */
+	dm_oblock_t origin_blocks;
+	sector_t origin_sectors;
+
+	/*
+	 * Size of the cache device in blocks.
+	 */
+	dm_cblock_t cache_size;
+
+	/*
+	 * Fields for converting from sectors to blocks.
+	 */
+	sector_t sectors_per_block;
+	int sectors_per_block_shift;
+
+	struct dm_cache_metadata *cmd;
+
+	spinlock_t lock;
+	struct bio_list deferred_bios;
+	struct bio_list deferred_flush_bios;
+	struct list_head quiesced_migrations;
+	struct list_head completed_migrations;
+	struct list_head need_commit_migrations;
+	sector_t migration_threshold;
+	atomic_t nr_migrations;
+	wait_queue_head_t migration_wait;
+
+	/*
+	 * cache_size entries, dirty if set
+	 */
+	dm_cblock_t nr_dirty;
+	unsigned long *dirty_bitset;
+
+	/*
+	 * origin_blocks entries, discarded if set.
+	 */
+	sector_t discard_block_size; /* a power of 2 times sectors per block */
+	dm_dblock_t discard_nr_blocks;
+	unsigned long *discard_bitset;
+
+	struct dm_kcopyd_client *copier;
+	struct workqueue_struct *wq;
+	struct work_struct worker;
+
+	struct delayed_work waker;
+	unsigned long last_commit_jiffies;
+
+	struct dm_bio_prison *prison;
+	struct dm_deferred_set *all_io_ds;
+
+	mempool_t *migration_pool;
+	struct dm_cache_migration *next_migration;
+
+	struct dm_cache_policy *policy;
+	unsigned policy_nr_args;
+
+	bool need_tick_bio:1;
+	bool sized:1;
+	bool quiescing:1;
+	bool commit_requested:1;
+	bool loaded_mappings:1;
+	bool loaded_discards:1;
+
+	atomic_t read_hit;
+	atomic_t read_miss;
+	atomic_t write_hit;
+	atomic_t write_miss;
+	atomic_t demotion;
+	atomic_t promotion;
+	atomic_t copies_avoided;
+	atomic_t cache_cell_clash;
+	atomic_t commit_count;
+	atomic_t discard_count;
+};
+
+struct per_bio_data {
+	bool tick:1;
+	unsigned req_nr:2;
+	struct dm_deferred_entry *all_io_entry;
+};
+
+struct dm_cache_migration {
+	struct list_head list;
+	struct cache *cache;
+
+	unsigned long start_jiffies;
+	dm_oblock_t old_oblock;
+	dm_oblock_t new_oblock;
+	dm_cblock_t cblock;
+
+	bool err:1;
+	bool writeback:1;
+	bool demote:1;
+	bool promote:1;
+
+	struct dm_bio_prison_cell *old_ocell;
+	struct dm_bio_prison_cell *new_ocell;
+};
+
+/*
+ * Processing a bio in the worker thread may require these memory
+ * allocations.  We prealloc to avoid deadlocks (the same worker thread
+ * frees them back to the mempool).
+ */
+struct prealloc {
+	struct dm_cache_migration *mg;
+	struct dm_bio_prison_cell *cell1;
+	struct dm_bio_prison_cell *cell2;
+};
+
+static void wake_worker(struct cache *cache)
+{
+	queue_work(cache->wq, &cache->worker);
+}
+
+/*----------------------------------------------------------------*/
+
+static int prealloc_data_structs(struct cache *cache, struct prealloc *p)
+{
+	if (!p->mg) {
+		p->mg = mempool_alloc(cache->migration_pool, GFP_NOWAIT);
+		if (!p->mg)
+			return -ENOMEM;
+	}
+
+	if (!p->cell1) {
+		p->cell1 = dm_bio_prison_alloc_cell(cache->prison, GFP_NOWAIT);
+		if (!p->cell1)
+			return -ENOMEM;
+	}
+
+	if (!p->cell2) {
+		p->cell2 = dm_bio_prison_alloc_cell(cache->prison, GFP_NOWAIT);
+		if (!p->cell2)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void prealloc_free_structs(struct cache *cache, struct prealloc *p)
+{
+	if (p->cell2)
+		dm_bio_prison_free_cell(cache->prison, p->cell2);
+
+	if (p->cell1)
+		dm_bio_prison_free_cell(cache->prison, p->cell1);
+
+	if (p->mg)
+		mempool_free(p->mg, cache->migration_pool);
+}
+
+static struct dm_cache_migration *prealloc_get_migration(struct prealloc *p)
+{
+	struct dm_cache_migration *mg = p->mg;
+
+	BUG_ON(!mg);
+	p->mg = NULL;
+
+	return mg;
+}
+
+static struct dm_bio_prison_cell *prealloc_get_cell(struct prealloc *p)
+{
+	struct dm_bio_prison_cell *r = NULL;
+
+	if (p->cell1) {
+		r = p->cell1;
+		p->cell1 = NULL;
+
+	} else if (p->cell2) {
+		r = p->cell2;
+		p->cell2 = NULL;
+	} else
+		BUG();
+
+	return r;
+}
+
+static void prealloc_put_cell(struct prealloc *p, struct dm_bio_prison_cell *cell)
+{
+	if (!p->cell2)
+		p->cell2 = cell;
+
+	else if (!p->cell1)
+		p->cell1 = cell;
+
+	else
+		BUG();
+}
+
+/*----------------------------------------------------------------*/
+
+static void build_key(dm_oblock_t oblock, struct dm_cell_key *key)
+{
+	key->virtual = 0;
+	key->dev = 0;
+	key->block = from_oblock(oblock);
+}
+
+/*
+ * The caller hands in a preallocated cell, and a free function for it.
+ * The cell will be freed if there's an error, or if it wasn't used because
+ * a cell with that key already exists.
+ */
+typedef void (*cell_free_fn)(void *context, struct dm_bio_prison_cell *cell);
+
+static int bio_detain(struct cache *cache, dm_oblock_t oblock,
+		      struct bio *bio, struct dm_bio_prison_cell *cell,
+		      cell_free_fn free_fn, void *free_context,
+		      struct dm_bio_prison_cell **result)
+{
+	int r;
+	struct dm_cell_key key;
+
+	build_key(oblock, &key);
+	r = dm_bio_detain(cache->prison, &key, bio, cell, result);
+	if (r)
+		free_fn(free_context, cell);
+
+	return r;
+}
+
+static int get_cell(struct cache *cache,
+		    dm_oblock_t oblock,
+		    struct prealloc *structs,
+		    struct dm_bio_prison_cell **result)
+{
+	int r;
+	struct dm_cell_key key;
+	struct dm_bio_prison_cell *cell;
+
+	cell = prealloc_get_cell(structs);
+
+	build_key(oblock, &key);
+	r = dm_get_cell(cache->prison, &key, cell, result);
+	if (r)
+		prealloc_put_cell(structs, cell);
+
+	return r;
+}
+
+ /*----------------------------------------------------------------*/
+
+static bool is_dirty(struct cache *cache, dm_cblock_t b)
+{
+	return test_bit(from_cblock(b), cache->dirty_bitset);
+}
+
+static void set_dirty(struct cache *cache, dm_oblock_t oblock, dm_cblock_t cblock)
+{
+	if (!test_and_set_bit(from_cblock(cblock), cache->dirty_bitset)) {
+		cache->nr_dirty = to_cblock(from_cblock(cache->nr_dirty) + 1);
+		policy_set_dirty(cache->policy, oblock);
+	}
+}
+
+static void clear_dirty(struct cache *cache, dm_oblock_t oblock, dm_cblock_t cblock)
+{
+	if (test_and_clear_bit(from_cblock(cblock), cache->dirty_bitset)) {
+		policy_clear_dirty(cache->policy, oblock);
+		cache->nr_dirty = to_cblock(from_cblock(cache->nr_dirty) - 1);
+		if (!from_cblock(cache->nr_dirty))
+			dm_table_event(cache->ti->table);
+	}
+}
+
+/*----------------------------------------------------------------*/
+
+static dm_dblock_t oblock_to_dblock(struct cache *cache, dm_oblock_t oblock)
+{
+	sector_t tmp = cache->discard_block_size;
+	dm_block_t b = from_oblock(oblock);
+
+	do_div(tmp, cache->sectors_per_block);
+	do_div(b, tmp);
+	return to_dblock(b);
+}
+
+static void set_discard(struct cache *cache, dm_dblock_t b)
+{
+	unsigned long flags;
+
+	atomic_inc(&cache->discard_count);
+
+	spin_lock_irqsave(&cache->lock, flags);
+	set_bit(from_dblock(b), cache->discard_bitset);
+	spin_unlock_irqrestore(&cache->lock, flags);
+}
+
+static void clear_discard(struct cache *cache, dm_dblock_t b)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cache->lock, flags);
+	clear_bit(from_dblock(b), cache->discard_bitset);
+	spin_unlock_irqrestore(&cache->lock, flags);
+}
+
+static bool is_discarded(struct cache *cache, dm_dblock_t b)
+{
+	int r;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cache->lock, flags);
+	r = test_bit(from_dblock(b), cache->discard_bitset);
+	spin_unlock_irqrestore(&cache->lock, flags);
+
+	return r;
+}
+
+static bool is_discarded_oblock(struct cache *cache, dm_oblock_t b)
+{
+	int r;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cache->lock, flags);
+	r = test_bit(from_dblock(oblock_to_dblock(cache, b)),
+		     cache->discard_bitset);
+	spin_unlock_irqrestore(&cache->lock, flags);
+
+	return r;
+}
+
+/*----------------------------------------------------------------*/
+
+static void load_stats(struct cache *cache)
+{
+	struct dm_cache_statistics stats;
+
+	dm_cache_get_stats(cache->cmd, &stats);
+	atomic_set(&cache->read_hit, stats.read_hits);
+	atomic_set(&cache->read_miss, stats.read_misses);
+	atomic_set(&cache->write_hit, stats.write_hits);
+	atomic_set(&cache->write_miss, stats.write_misses);
+}
+
+static void save_stats(struct cache *cache)
+{
+	struct dm_cache_statistics stats;
+
+	stats.read_hits = atomic_read(&cache->read_hit);
+	stats.read_misses = atomic_read(&cache->read_miss);
+	stats.write_hits = atomic_read(&cache->write_hit);
+	stats.write_misses = atomic_read(&cache->write_miss);
+
+	dm_cache_set_stats(cache->cmd, &stats);
+}
+
+/*----------------------------------------------------------------
+ * Per request data
+ *--------------------------------------------------------------*/
+static struct per_bio_data *get_per_bio_data(struct bio *bio)
+{
+	struct per_bio_data *pb = dm_per_bio_data(bio, sizeof(struct per_bio_data));
+	BUG_ON(!pb);
+	return pb;
+}
+
+static struct per_bio_data *init_per_bio_data(struct bio *bio)
+{
+	struct per_bio_data *pb = get_per_bio_data(bio);
+
+	pb->tick = false;
+	pb->req_nr = dm_bio_get_target_request_nr(bio);
+	pb->all_io_entry = NULL;
+
+	return pb;
+}
+
+/*----------------------------------------------------------------
+ * Remapping
+ *--------------------------------------------------------------*/
+static bool block_size_is_power_of_two(struct cache *cache)
+{
+	return cache->sectors_per_block_shift >= 0;
+}
+
+static void remap_to_origin(struct cache *cache, struct bio *bio)
+{
+	bio->bi_bdev = cache->origin_dev->bdev;
+}
+
+static void remap_to_cache(struct cache *cache, struct bio *bio,
+			   dm_cblock_t cblock)
+{
+	sector_t bi_sector = bio->bi_sector;
+
+	bio->bi_bdev = cache->cache_dev->bdev;
+	if (!block_size_is_power_of_two(cache))
+		bio->bi_sector = (from_cblock(cblock) * cache->sectors_per_block) +
+				sector_div(bi_sector, cache->sectors_per_block);
+	else
+		bio->bi_sector = (from_cblock(cblock) << cache->sectors_per_block_shift) |
+				(bi_sector & (cache->sectors_per_block - 1));
+}
+
+static void check_if_tick_bio_needed(struct cache *cache, struct bio *bio)
+{
+	unsigned long flags;
+	struct per_bio_data *pb = get_per_bio_data(bio);
+
+	spin_lock_irqsave(&cache->lock, flags);
+	if (cache->need_tick_bio &&
+	    !(bio->bi_rw & (REQ_FUA | REQ_FLUSH | REQ_DISCARD))) {
+		pb->tick = true;
+		cache->need_tick_bio = false;
+	}
+	spin_unlock_irqrestore(&cache->lock, flags);
+}
+
+static void remap_to_origin_clear_discard(struct cache *cache, struct bio *bio,
+				  dm_oblock_t oblock)
+{
+	check_if_tick_bio_needed(cache, bio);
+	remap_to_origin(cache, bio);
+	if (bio_data_dir(bio) == WRITE)
+		clear_discard(cache, oblock_to_dblock(cache, oblock));
+}
+
+static void remap_to_cache_dirty(struct cache *cache, struct bio *bio,
+				 dm_oblock_t oblock, dm_cblock_t cblock)
+{
+	remap_to_cache(cache, bio, cblock);
+	if (bio_data_dir(bio) == WRITE) {
+		set_dirty(cache, oblock, cblock);
+		clear_discard(cache, oblock_to_dblock(cache, oblock));
+	}
+}
+
+static dm_oblock_t get_bio_block(struct cache *cache, struct bio *bio)
+{
+	sector_t block_nr = bio->bi_sector;
+
+	if (!block_size_is_power_of_two(cache))
+		(void) sector_div(block_nr, cache->sectors_per_block);
+	else
+		block_nr >>= cache->sectors_per_block_shift;
+
+	return to_oblock(block_nr);
+}
+
+static int bio_triggers_commit(struct cache *cache, struct bio *bio)
+{
+	return bio->bi_rw & (REQ_FLUSH | REQ_FUA);
+}
+
+static void issue(struct cache *cache, struct bio *bio)
+{
+	unsigned long flags;
+
+	if (!bio_triggers_commit(cache, bio)) {
+		generic_make_request(bio);
+		return;
+	}
+
+	/*
+	 * Batch together any bios that trigger commits and then issue a
+	 * single commit for them in do_worker().
+	 */
+	spin_lock_irqsave(&cache->lock, flags);
+	cache->commit_requested = true;
+	bio_list_add(&cache->deferred_flush_bios, bio);
+	spin_unlock_irqrestore(&cache->lock, flags);
+}
+
+/*----------------------------------------------------------------
+ * Migration processing
+ *
+ * Migration covers moving data from the origin device to the cache, or
+ * vice versa.
+ *--------------------------------------------------------------*/
+static void free_migration(struct dm_cache_migration *mg)
+{
+	mempool_free(mg, mg->cache->migration_pool);
+}
+
+static void inc_nr_migrations(struct cache *cache)
+{
+	atomic_inc(&cache->nr_migrations);
+}
+
+static void dec_nr_migrations(struct cache *cache)
+{
+	atomic_dec(&cache->nr_migrations);
+
+	/*
+	 * Wake the worker in case we're suspending the target.
+	 */
+	wake_up(&cache->migration_wait);
+}
+
+static void __cell_defer(struct cache *cache, struct dm_bio_prison_cell *cell,
+			 bool holder)
+{
+	(holder ? dm_cell_release : dm_cell_release_no_holder)
+		(cache->prison, cell, &cache->deferred_bios);
+	dm_bio_prison_free_cell(cache->prison, cell);
+}
+
+static void cell_defer(struct cache *cache, struct dm_bio_prison_cell *cell,
+		       bool holder)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cache->lock, flags);
+	__cell_defer(cache, cell, holder);
+	spin_unlock_irqrestore(&cache->lock, flags);
+
+	wake_worker(cache);
+}
+
+static void cleanup_migration(struct dm_cache_migration *mg)
+{
+	dec_nr_migrations(mg->cache);
+	free_migration(mg);
+}
+
+static void migration_failure(struct dm_cache_migration *mg)
+{
+	struct cache *cache = mg->cache;
+
+	if (mg->writeback) {
+		DMWARN_LIMIT("writeback failed; couldn't copy block");
+		set_dirty(cache, mg->old_oblock, mg->cblock);
+		cell_defer(cache, mg->old_ocell, false);
+
+	} else if (mg->demote) {
+		DMWARN_LIMIT("demotion failed; couldn't copy block");
+		policy_force_mapping(cache->policy, mg->new_oblock, mg->old_oblock);
+
+		cell_defer(cache, mg->old_ocell, mg->promote ? 0 : 1);
+		if (mg->promote)
+			cell_defer(cache, mg->new_ocell, 1);
+	} else {
+		DMWARN_LIMIT("promotion failed; couldn't copy block");
+		policy_remove_mapping(cache->policy, mg->new_oblock);
+		cell_defer(cache, mg->new_ocell, 1);
+	}
+
+	cleanup_migration(mg);
+}
+
+static void migration_success_pre_commit(struct dm_cache_migration *mg)
+{
+	unsigned long flags;
+	struct cache *cache = mg->cache;
+
+	if (mg->writeback) {
+		cell_defer(cache, mg->old_ocell, false);
+		clear_dirty(cache, mg->old_oblock, mg->cblock);
+		cleanup_migration(mg);
+		return;
+
+	} else if (mg->demote) {
+		if (dm_cache_remove_mapping(cache->cmd, mg->cblock)) {
+			DMWARN_LIMIT("demotion failed; couldn't update on disk metadata");
+			policy_force_mapping(cache->policy, mg->new_oblock,
+					     mg->old_oblock);
+			if (mg->promote)
+				cell_defer(cache, mg->new_ocell, true);
+			cleanup_migration(mg);
+			return;
+		}
+	} else {
+		if (dm_cache_insert_mapping(cache->cmd, mg->cblock, mg->new_oblock)) {
+			DMWARN_LIMIT("promotion failed; couldn't update on disk metadata");
+			policy_remove_mapping(cache->policy, mg->new_oblock);
+			cleanup_migration(mg);
+			return;
+		}
+	}
+
+	spin_lock_irqsave(&cache->lock, flags);
+	list_add_tail(&mg->list, &cache->need_commit_migrations);
+	cache->commit_requested = true;
+	spin_unlock_irqrestore(&cache->lock, flags);
+}
+
+static void migration_success_post_commit(struct dm_cache_migration *mg)
+{
+	unsigned long flags;
+	struct cache *cache = mg->cache;
+
+	if (mg->writeback) {
+		DMWARN("shouldn't get here");
+		return;
+
+	} else if (mg->demote) {
+		cell_defer(cache, mg->old_ocell, mg->promote ? 0 : 1);
+
+		if (mg->promote) {
+			mg->demote = false;
+
+			spin_lock_irqsave(&cache->lock, flags);
+			list_add_tail(&mg->list, &cache->quiesced_migrations);
+			spin_unlock_irqrestore(&cache->lock, flags);
+
+		} else
+			cleanup_migration(mg);
+
+	} else {
+		cell_defer(cache, mg->new_ocell, true);
+		clear_dirty(cache, mg->new_oblock, mg->cblock);
+		cleanup_migration(mg);
+	}
+}
+
+static void copy_complete(int read_err, unsigned long write_err, void *context)
+{
+	unsigned long flags;
+	struct dm_cache_migration *mg = (struct dm_cache_migration *) context;
+	struct cache *cache = mg->cache;
+
+	if (read_err || write_err)
+		mg->err = true;
+
+	spin_lock_irqsave(&cache->lock, flags);
+	list_add_tail(&mg->list, &cache->completed_migrations);
+	spin_unlock_irqrestore(&cache->lock, flags);
+
+	wake_worker(cache);
+}
+
+static void issue_copy_real(struct dm_cache_migration *mg)
+{
+	int r;
+	struct dm_io_region o_region, c_region;
+	struct cache *cache = mg->cache;
+
+	o_region.bdev = cache->origin_dev->bdev;
+	o_region.count = cache->sectors_per_block;
+
+	c_region.bdev = cache->cache_dev->bdev;
+	c_region.sector = from_cblock(mg->cblock) * cache->sectors_per_block;
+	c_region.count = cache->sectors_per_block;
+
+	if (mg->writeback || mg->demote) {
+		/* demote */
+		o_region.sector = from_oblock(mg->old_oblock) * cache->sectors_per_block;
+		r = dm_kcopyd_copy(cache->copier, &c_region, 1, &o_region, 0, copy_complete, mg);
+	} else {
+		/* promote */
+		o_region.sector = from_oblock(mg->new_oblock) * cache->sectors_per_block;
+		r = dm_kcopyd_copy(cache->copier, &o_region, 1, &c_region, 0, copy_complete, mg);
+	}
+
+	if (r < 0)
+		migration_failure(mg);
+}
+
+static void avoid_copy(struct dm_cache_migration *mg)
+{
+	atomic_inc(&mg->cache->copies_avoided);
+	migration_success_pre_commit(mg);
+}
+
+static void issue_copy(struct dm_cache_migration *mg)
+{
+	bool avoid;
+	struct cache *cache = mg->cache;
+
+	if (mg->writeback || mg->demote)
+		avoid = !is_dirty(cache, mg->cblock) ||
+			is_discarded_oblock(cache, mg->old_oblock);
+	else
+		avoid = is_discarded_oblock(cache, mg->new_oblock);
+
+	avoid ? avoid_copy(mg) : issue_copy_real(mg);
+}
+
+static void complete_migration(struct dm_cache_migration *mg)
+{
+	if (mg->err)
+		migration_failure(mg);
+	else
+		migration_success_pre_commit(mg);
+}
+
+static void process_migrations(struct cache *cache, struct list_head *head,
+			       void (*fn)(struct dm_cache_migration *))
+{
+	unsigned long flags;
+	struct list_head list;
+	struct dm_cache_migration *mg, *tmp;
+
+	INIT_LIST_HEAD(&list);
+	spin_lock_irqsave(&cache->lock, flags);
+	list_splice_init(head, &list);
+	spin_unlock_irqrestore(&cache->lock, flags);
+
+	list_for_each_entry_safe(mg, tmp, &list, list)
+		fn(mg);
+}
+
+static void __queue_quiesced_migration(struct dm_cache_migration *mg)
+{
+	list_add_tail(&mg->list, &mg->cache->quiesced_migrations);
+}
+
+static void queue_quiesced_migration(struct dm_cache_migration *mg)
+{
+	unsigned long flags;
+	struct cache *cache = mg->cache;
+
+	spin_lock_irqsave(&cache->lock, flags);
+	__queue_quiesced_migration(mg);
+	spin_unlock_irqrestore(&cache->lock, flags);
+
+	wake_worker(cache);
+}
+
+static void queue_quiesced_migrations(struct cache *cache, struct list_head *work)
+{
+	unsigned long flags;
+	struct dm_cache_migration *mg, *tmp;
+
+	spin_lock_irqsave(&cache->lock, flags);
+	list_for_each_entry_safe(mg, tmp, work, list)
+		__queue_quiesced_migration(mg);
+	spin_unlock_irqrestore(&cache->lock, flags);
+
+	wake_worker(cache);
+}
+
+static void check_for_quiesced_migrations(struct cache *cache,
+					  struct per_bio_data *pb)
+{
+	struct list_head work;
+
+	if (!pb->all_io_entry)
+		return;
+
+	INIT_LIST_HEAD(&work);
+	if (pb->all_io_entry)
+		dm_deferred_entry_dec(pb->all_io_entry, &work);
+
+	if (!list_empty(&work))
+		queue_quiesced_migrations(cache, &work);
+}
+
+static void quiesce_migration(struct dm_cache_migration *mg)
+{
+	if (!dm_deferred_set_add_work(mg->cache->all_io_ds, &mg->list))
+		queue_quiesced_migration(mg);
+}
+
+static void promote(struct cache *cache, struct prealloc *structs,
+		    dm_oblock_t oblock, dm_cblock_t cblock,
+		    struct dm_bio_prison_cell *cell)
+{
+	struct dm_cache_migration *mg = prealloc_get_migration(structs);
+
+	mg->err = false;
+	mg->writeback = false;
+	mg->demote = false;
+	mg->promote = true;
+	mg->cache = cache;
+	mg->new_oblock = oblock;
+	mg->cblock = cblock;
+	mg->old_ocell = NULL;
+	mg->new_ocell = cell;
+	mg->start_jiffies = jiffies;
+
+	inc_nr_migrations(cache);
+	quiesce_migration(mg);
+}
+
+static void writeback(struct cache *cache, struct prealloc *structs,
+		      dm_oblock_t oblock, dm_cblock_t cblock,
+		      struct dm_bio_prison_cell *cell)
+{
+	struct dm_cache_migration *mg = prealloc_get_migration(structs);
+
+	mg->err = false;
+	mg->writeback = true;
+	mg->demote = false;
+	mg->promote = false;
+	mg->cache = cache;
+	mg->old_oblock = oblock;
+	mg->cblock = cblock;
+	mg->old_ocell = cell;
+	mg->new_ocell = NULL;
+	mg->start_jiffies = jiffies;
+
+	inc_nr_migrations(cache);
+	quiesce_migration(mg);
+}
+
+static void demote_then_promote(struct cache *cache, struct prealloc *structs,
+				dm_oblock_t old_oblock, dm_oblock_t new_oblock,
+				dm_cblock_t cblock,
+				struct dm_bio_prison_cell *old_ocell,
+				struct dm_bio_prison_cell *new_ocell)
+{
+	struct dm_cache_migration *mg = prealloc_get_migration(structs);
+
+	mg->err = false;
+	mg->writeback = false;
+	mg->demote = true;
+	mg->promote = true;
+	mg->cache = cache;
+	mg->old_oblock = old_oblock;
+	mg->new_oblock = new_oblock;
+	mg->cblock = cblock;
+	mg->old_ocell = old_ocell;
+	mg->new_ocell = new_ocell;
+	mg->start_jiffies = jiffies;
+
+	inc_nr_migrations(cache);
+	quiesce_migration(mg);
+}
+
+/*----------------------------------------------------------------
+ * bio processing
+ *--------------------------------------------------------------*/
+static void defer_bio(struct cache *cache, struct bio *bio)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cache->lock, flags);
+	bio_list_add(&cache->deferred_bios, bio);
+	spin_unlock_irqrestore(&cache->lock, flags);
+
+	wake_worker(cache);
+}
+
+static void process_flush_bio(struct cache *cache, struct bio *bio)
+{
+	struct per_bio_data *pb = get_per_bio_data(bio);
+
+	BUG_ON(bio->bi_size);
+	if (!pb->req_nr)
+		remap_to_origin(cache, bio);
+	else
+		remap_to_cache(cache, bio, 0);
+
+	issue(cache, bio);
+}
+
+/*
+ * People generally discard large parts of a device, eg, the whole device
+ * when formatting.  Splitting these large discards up into cache block
+ * sized ios and then quiescing (always neccessary for discard) takes too
+ * long.
+ *
+ * We keep it simple, and allow any size of discard to come in, and just
+ * mark off blocks on the discard bitset.  No passdown occurs!
+ *
+ * To implement passdown we need to change the bio_prison such that a cell
+ * can have a key that spans many blocks.  This change is planned for
+ * thin-provisioning.
+ */
+static void process_discard_bio(struct cache *cache, struct bio *bio)
+{
+	dm_block_t start_block = dm_sector_div_up(bio->bi_sector,
+						  cache->discard_block_size);
+	dm_block_t end_block = bio->bi_sector + bio_sectors(bio);
+	dm_block_t b;
+
+	do_div(end_block, cache->discard_block_size);
+
+	for (b = start_block; b < end_block; b++)
+		set_discard(cache, to_dblock(b));
+
+	bio_endio(bio, 0);
+}
+
+static bool spare_migration_bandwidth(struct cache *cache)
+{
+	sector_t current_volume = (atomic_read(&cache->nr_migrations) + 1) *
+		cache->sectors_per_block;
+	return current_volume < cache->migration_threshold;
+}
+
+static bool is_writethrough_io(struct cache *cache, struct bio *bio,
+			       dm_cblock_t cblock)
+{
+	return bio_data_dir(bio) == WRITE &&
+		cache->features.write_through && !is_dirty(cache, cblock);
+}
+
+static void inc_hit_counter(struct cache *cache, struct bio *bio)
+{
+	atomic_inc(bio_data_dir(bio) == READ ?
+		   &cache->read_hit : &cache->write_hit);
+}
+
+static void inc_miss_counter(struct cache *cache, struct bio *bio)
+{
+	atomic_inc(bio_data_dir(bio) == READ ?
+		   &cache->read_miss : &cache->write_miss);
+}
+
+static void process_bio(struct cache *cache, struct prealloc *structs,
+			struct bio *bio)
+{
+	int r;
+	bool release_cell = true;
+	dm_oblock_t block = get_bio_block(cache, bio);
+	struct dm_bio_prison_cell *cell, *old_ocell, *new_ocell;
+	struct policy_result lookup_result;
+	struct per_bio_data *pb = get_per_bio_data(bio);
+	bool discarded_block = is_discarded_oblock(cache, block);
+	bool can_migrate = discarded_block || spare_migration_bandwidth(cache);
+
+	/*
+	 * Check to see if that block is currently migrating.
+	 */
+	cell = prealloc_get_cell(structs);
+	r = bio_detain(cache, block, bio, cell,
+		       (cell_free_fn) prealloc_put_cell,
+		       structs, &new_ocell);
+	if (r > 0)
+		return;
+
+	r = policy_map(cache->policy, block, true, can_migrate, discarded_block,
+		       bio, &lookup_result);
+
+	if (r == -EWOULDBLOCK)
+		/* migration has been denied */
+		lookup_result.op = POLICY_MISS;
+
+	switch (lookup_result.op) {
+	case POLICY_HIT:
+		inc_hit_counter(cache, bio);
+		pb->all_io_entry = dm_deferred_entry_inc(cache->all_io_ds);
+
+		if (is_writethrough_io(cache, bio, lookup_result.cblock)) {
+			/*
+			 * No need to mark anything dirty in write through mode.
+			 */
+			pb->req_nr == 0 ?
+				remap_to_cache(cache, bio, lookup_result.cblock) :
+				remap_to_origin_clear_discard(cache, bio, block);
+		} else
+			remap_to_cache_dirty(cache, bio, block, lookup_result.cblock);
+
+		issue(cache, bio);
+		break;
+
+	case POLICY_MISS:
+		inc_miss_counter(cache, bio);
+		pb->all_io_entry = dm_deferred_entry_inc(cache->all_io_ds);
+
+		if (pb->req_nr != 0) {
+			/*
+			 * This is a duplicate writethrough io that is no
+			 * longer needed because the block has been demoted.
+			 */
+			bio_endio(bio, 0);
+		} else {
+			remap_to_origin_clear_discard(cache, bio, block);
+			issue(cache, bio);
+		}
+		break;
+
+	case POLICY_NEW:
+		atomic_inc(&cache->promotion);
+		promote(cache, structs, block, lookup_result.cblock, new_ocell);
+		release_cell = false;
+		break;
+
+	case POLICY_REPLACE:
+		cell = prealloc_get_cell(structs);
+		r = bio_detain(cache, lookup_result.old_oblock, bio, cell,
+			       (cell_free_fn) prealloc_put_cell,
+			       structs, &old_ocell);
+		if (r > 0) {
+			/*
+			 * We have to be careful to avoid lock inversion of
+			 * the cells.  So we back off, and wait for the
+			 * old_ocell to become free.
+			 */
+			policy_force_mapping(cache->policy, block,
+					     lookup_result.old_oblock);
+			atomic_inc(&cache->cache_cell_clash);
+			break;
+		}
+		atomic_inc(&cache->demotion);
+		atomic_inc(&cache->promotion);
+
+		demote_then_promote(cache, structs, lookup_result.old_oblock,
+				    block, lookup_result.cblock,
+				    old_ocell, new_ocell);
+		release_cell = false;
+		break;
+
+	default:
+		DMERR_LIMIT("%s: erroring bio, unknown policy op: %u", __func__,
+			    (unsigned) lookup_result.op);
+		bio_io_error(bio);
+	}
+
+	if (release_cell)
+		cell_defer(cache, new_ocell, false);
+}
+
+static int need_commit_due_to_time(struct cache *cache)
+{
+	return jiffies < cache->last_commit_jiffies ||
+	       jiffies > cache->last_commit_jiffies + COMMIT_PERIOD;
+}
+
+static int commit_if_needed(struct cache *cache)
+{
+	if (dm_cache_changed_this_transaction(cache->cmd) &&
+	    (cache->commit_requested || need_commit_due_to_time(cache))) {
+		atomic_inc(&cache->commit_count);
+		cache->last_commit_jiffies = jiffies;
+		cache->commit_requested = false;
+		return dm_cache_commit(cache->cmd, false);
+	}
+
+	return 0;
+}
+
+static void process_deferred_bios(struct cache *cache)
+{
+	unsigned long flags;
+	struct bio_list bios;
+	struct bio *bio;
+	struct prealloc structs;
+
+	memset(&structs, 0, sizeof(structs));
+	bio_list_init(&bios);
+
+	spin_lock_irqsave(&cache->lock, flags);
+	bio_list_merge(&bios, &cache->deferred_bios);
+	bio_list_init(&cache->deferred_bios);
+	spin_unlock_irqrestore(&cache->lock, flags);
+
+	while (!bio_list_empty(&bios)) {
+		/*
+		 * If we've got no free migration structs, and processing
+		 * this bio might require one, we pause until there are some
+		 * prepared mappings to process.
+		 */
+		if (prealloc_data_structs(cache, &structs)) {
+			spin_lock_irqsave(&cache->lock, flags);
+			bio_list_merge(&cache->deferred_bios, &bios);
+			spin_unlock_irqrestore(&cache->lock, flags);
+			break;
+		}
+
+		bio = bio_list_pop(&bios);
+
+		if (bio->bi_rw & REQ_FLUSH)
+			process_flush_bio(cache, bio);
+		else if (bio->bi_rw & REQ_DISCARD)
+			process_discard_bio(cache, bio);
+		else
+			process_bio(cache, &structs, bio);
+	}
+
+	prealloc_free_structs(cache, &structs);
+}
+
+static void process_deferred_flush_bios(struct cache *cache, bool submit_bios)
+{
+	unsigned long flags;
+	struct bio_list bios;
+	struct bio *bio;
+
+	bio_list_init(&bios);
+
+	spin_lock_irqsave(&cache->lock, flags);
+	bio_list_merge(&bios, &cache->deferred_flush_bios);
+	bio_list_init(&cache->deferred_flush_bios);
+	spin_unlock_irqrestore(&cache->lock, flags);
+
+	while ((bio = bio_list_pop(&bios)))
+		submit_bios ? generic_make_request(bio) : bio_io_error(bio);
+}
+
+static void writeback_some_dirty_blocks(struct cache *cache)
+{
+	int r = 0;
+	dm_oblock_t oblock;
+	dm_cblock_t cblock;
+	struct prealloc structs;
+	struct dm_bio_prison_cell *old_ocell;
+
+	memset(&structs, 0, sizeof(structs));
+
+	while (spare_migration_bandwidth(cache)) {
+		if (prealloc_data_structs(cache, &structs))
+			break;
+
+		r = policy_writeback_work(cache->policy, &oblock, &cblock);
+		if (r)
+			break;
+
+		r = get_cell(cache, oblock, &structs, &old_ocell);
+		if (r) {
+			policy_set_dirty(cache->policy, oblock);
+			break;
+		}
+
+		writeback(cache, &structs, oblock, cblock, old_ocell);
+	}
+
+	prealloc_free_structs(cache, &structs);
+}
+
+/*----------------------------------------------------------------
+ * Main worker loop
+ *--------------------------------------------------------------*/
+static void start_quiescing(struct cache *cache)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cache->lock, flags);
+	cache->quiescing = 1;
+	spin_unlock_irqrestore(&cache->lock, flags);
+}
+
+static void stop_quiescing(struct cache *cache)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cache->lock, flags);
+	cache->quiescing = 0;
+	spin_unlock_irqrestore(&cache->lock, flags);
+}
+
+static bool is_quiescing(struct cache *cache)
+{
+	int r;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cache->lock, flags);
+	r = cache->quiescing;
+	spin_unlock_irqrestore(&cache->lock, flags);
+
+	return r;
+}
+
+static void wait_for_migrations(struct cache *cache)
+{
+	wait_event(cache->migration_wait, !atomic_read(&cache->nr_migrations));
+}
+
+static void stop_worker(struct cache *cache)
+{
+	cancel_delayed_work(&cache->waker);
+	flush_workqueue(cache->wq);
+}
+
+static void requeue_deferred_io(struct cache *cache)
+{
+	struct bio *bio;
+	struct bio_list bios;
+
+	bio_list_init(&bios);
+	bio_list_merge(&bios, &cache->deferred_bios);
+	bio_list_init(&cache->deferred_bios);
+
+	while ((bio = bio_list_pop(&bios)))
+		bio_endio(bio, DM_ENDIO_REQUEUE);
+}
+
+static int more_work(struct cache *cache)
+{
+	if (is_quiescing(cache))
+		return !list_empty(&cache->quiesced_migrations) ||
+			!list_empty(&cache->completed_migrations) ||
+			!list_empty(&cache->need_commit_migrations);
+	else
+		return !bio_list_empty(&cache->deferred_bios) ||
+			!bio_list_empty(&cache->deferred_flush_bios) ||
+			!list_empty(&cache->quiesced_migrations) ||
+			!list_empty(&cache->completed_migrations) ||
+			!list_empty(&cache->need_commit_migrations);
+}
+
+static void do_worker(struct work_struct *ws)
+{
+	struct cache *cache = container_of(ws, struct cache, worker);
+
+	do {
+		if (!is_quiescing(cache))
+			process_deferred_bios(cache);
+
+		process_migrations(cache, &cache->quiesced_migrations, issue_copy);
+		process_migrations(cache, &cache->completed_migrations, complete_migration);
+
+		writeback_some_dirty_blocks(cache);
+
+		if (commit_if_needed(cache)) {
+			process_deferred_flush_bios(cache, false);
+
+			/*
+			 * FIXME: rollback metadata or just go into a
+			 * failure mode and error everything
+			 */
+		} else {
+			process_deferred_flush_bios(cache, true);
+			process_migrations(cache, &cache->need_commit_migrations,
+					   migration_success_post_commit);
+		}
+	} while (more_work(cache));
+}
+
+/*
+ * We want to commit periodically so that not too much
+ * unwritten metadata builds up.
+ */
+static void do_waker(struct work_struct *ws)
+{
+	struct cache *cache = container_of(to_delayed_work(ws), struct cache, waker);
+	wake_worker(cache);
+	queue_delayed_work(cache->wq, &cache->waker, COMMIT_PERIOD);
+}
+
+/*----------------------------------------------------------------*/
+
+static int is_congested(struct dm_dev *dev, int bdi_bits)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+	return bdi_congested(&q->backing_dev_info, bdi_bits);
+}
+
+static int cache_is_congested(struct dm_target_callbacks *cb, int bdi_bits)
+{
+	struct cache *cache = container_of(cb, struct cache, callbacks);
+
+	return is_congested(cache->origin_dev, bdi_bits) ||
+		is_congested(cache->cache_dev, bdi_bits);
+}
+
+/*----------------------------------------------------------------
+ * Target methods
+ *--------------------------------------------------------------*/
+
+/*
+ * This function gets called on the error paths of the constructor, so we
+ * have to cope with a partially initialised struct.
+ */
+static void destroy(struct cache *cache)
+{
+	if (cache->next_migration)
+		mempool_free(cache->next_migration, cache->migration_pool);
+
+	if (cache->migration_pool)
+		mempool_destroy(cache->migration_pool);
+
+	if (cache->all_io_ds)
+		dm_deferred_set_destroy(cache->all_io_ds);
+
+	if (cache->prison)
+		dm_bio_prison_destroy(cache->prison);
+
+	if (cache->wq)
+		destroy_workqueue(cache->wq);
+
+	if (cache->dirty_bitset)
+		free_bitset(cache->dirty_bitset);
+
+	if (cache->discard_bitset)
+		free_bitset(cache->discard_bitset);
+
+	if (cache->copier)
+		dm_kcopyd_client_destroy(cache->copier);
+
+	if (cache->cmd)
+		dm_cache_metadata_close(cache->cmd);
+
+	if (cache->metadata_dev)
+		dm_put_device(cache->ti, cache->metadata_dev);
+
+	if (cache->origin_dev)
+		dm_put_device(cache->ti, cache->origin_dev);
+
+	if (cache->cache_dev)
+		dm_put_device(cache->ti, cache->cache_dev);
+
+	if (cache->policy)
+		dm_cache_policy_destroy(cache->policy);
+
+	kfree(cache);
+}
+
+static void cache_dtr(struct dm_target *ti)
+{
+	struct cache *cache = ti->private;
+
+	pr_alert("dm-cache statistics:\n");
+	pr_alert("read hits:\t%u\n", (unsigned) atomic_read(&cache->read_hit));
+	pr_alert("read misses:\t%u\n", (unsigned) atomic_read(&cache->read_miss));
+	pr_alert("write hits:\t%u\n", (unsigned) atomic_read(&cache->write_hit));
+	pr_alert("write misses:\t%u\n", (unsigned) atomic_read(&cache->write_miss));
+	pr_alert("demotions:\t%u\n", (unsigned) atomic_read(&cache->demotion));
+	pr_alert("promotions:\t%u\n", (unsigned) atomic_read(&cache->promotion));
+	pr_alert("copies avoided:\t%u\n", (unsigned) atomic_read(&cache->copies_avoided));
+	pr_alert("cache cell clashs:\t%u\n", (unsigned) atomic_read(&cache->cache_cell_clash));
+	pr_alert("commits:\t\t%u\n", (unsigned) atomic_read(&cache->commit_count));
+	pr_alert("discards:\t\t%u\n", (unsigned) atomic_read(&cache->discard_count));
+
+	destroy(cache);
+}
+
+static sector_t get_dev_size(struct dm_dev *dev)
+{
+	return i_size_read(dev->bdev->bd_inode) >> SECTOR_SHIFT;
+}
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Construct a cache device mapping.
+ *
+ * cache <metadata dev> <cache dev> <origin dev> <block size>
+ *       <#feature_args> [<arg>]* <policy> <#policy_args> [<arg>]*
+ *
+ * metadata dev    : fast device holding the persistent metadata
+ * cache dev	   : fast device holding cached data blocks
+ * origin dev	   : slow device holding original data blocks
+ * block size	   : cache unit size in sectors
+ * #feature args [<arg>]* : number of feature arguments followed by
+ *                          optional arguments * cache dev
+ * policy          : the replacement policy to use
+
+ * #policy_args  [<arg>]* : number of policy arguments followed by optional
+ *                          arguments; see policy plugin for instances
+ *			    (key value pairs count as 2; delimiter is space)
+ *
+ * Optional feature arguments are:
+ *	writeback: write back cache allowing cache block contents to
+ *                 differ from origin blocks for performance reasons
+ *	writethrough: write through caching prohibiting cache block
+ *                    content from being distinct from origin block content
+ */
+struct cache_args {
+	struct dm_target *ti;
+
+	struct dm_dev *metadata_dev;
+
+	struct dm_dev *cache_dev;
+	sector_t cache_sectors;
+
+	struct dm_dev *origin_dev;
+	sector_t origin_sectors;
+
+	sector_t block_size;
+
+	const char *policy_name;
+	int policy_argc;
+	char **policy_argv;
+
+	struct cache_features features;
+};
+
+static void destroy_cache_args(struct cache_args *ca)
+{
+	if (ca->metadata_dev)
+		dm_put_device(ca->ti, ca->metadata_dev);
+
+	if (ca->cache_dev)
+		dm_put_device(ca->ti, ca->cache_dev);
+
+	if (ca->origin_dev)
+		dm_put_device(ca->ti, ca->origin_dev);
+
+	kfree(ca);
+}
+
+static int ensure_args__(struct dm_arg_set *as,
+		       unsigned count, char **error)
+{
+	if (as->argc < count) {
+		*error = "Insufficient args";
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+#define ensure_args(n) \
+	r = ensure_args__(as, n, error); \
+	if (r) \
+		return r;
+
+static int parse_metadata_dev(struct cache_args *ca, struct dm_arg_set *as,
+			      char **error)
+{
+	int r;
+	sector_t metadata_dev_size;
+	char b[BDEVNAME_SIZE];
+
+	ensure_args(1);
+
+	r = dm_get_device(ca->ti, dm_shift_arg(as), FMODE_READ | FMODE_WRITE,
+			  &ca->metadata_dev);
+	if (r) {
+		*error = "Error opening metadata device";
+		return r;
+	}
+
+	metadata_dev_size = get_dev_size(ca->metadata_dev);
+	if (metadata_dev_size > CACHE_METADATA_MAX_SECTORS_WARNING)
+		DMWARN("Metadata device %s is larger than %u sectors: excess space will not be used.",
+		       bdevname(ca->metadata_dev->bdev, b), THIN_METADATA_MAX_SECTORS);
+
+	return 0;
+}
+
+static int parse_cache_dev(struct cache_args *ca, struct dm_arg_set *as,
+			   char **error)
+{
+	int r;
+
+	ensure_args(1);
+	r = dm_get_device(ca->ti, dm_shift_arg(as), FMODE_READ | FMODE_WRITE,
+			  &ca->cache_dev);
+	if (r) {
+		*error = "Error opening cache device";
+		return r;
+	}
+	ca->cache_sectors = get_dev_size(ca->cache_dev);
+
+	return 0;
+}
+
+static int parse_origin_dev(struct cache_args *ca, struct dm_arg_set *as,
+			    char **error)
+{
+	int r;
+
+	ensure_args(1);
+	r = dm_get_device(ca->ti, dm_shift_arg(as), FMODE_READ | FMODE_WRITE,
+			  &ca->origin_dev);
+	if (r) {
+		*error = "Error opening origin device";
+		return r;
+	}
+
+	ca->origin_sectors = get_dev_size(ca->origin_dev);
+	if (ca->ti->len > ca->origin_sectors) {
+		*error = "Device size larger than cached device";
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int parse_block_size(struct cache_args *ca, struct dm_arg_set *as,
+			    char **error)
+{
+	int r;
+	unsigned long tmp;
+
+	ensure_args(1);
+	if (kstrtoul(dm_shift_arg(as), 10, &tmp) || !tmp ||
+	    tmp < DATA_DEV_BLOCK_SIZE_MIN_SECTORS ||
+	    tmp & (DATA_DEV_BLOCK_SIZE_MIN_SECTORS - 1)) {
+		*error = "Invalid data block size";
+		return -EINVAL;
+	}
+
+	if (tmp > ca->cache_sectors) {
+		*error = "Data block size is larger than the cache device";
+		return -EINVAL;
+	}
+
+	ca->block_size = tmp;
+
+	return 0;
+}
+
+static void init_features(struct cache_features *cf)
+{
+	cf->mode = CM_WRITE;
+	cf->write_through = false;
+}
+
+static int parse_features(struct cache_args *ca, struct dm_arg_set *as,
+			  char **error)
+{
+	static struct dm_arg _args[] = {
+		{0, 1, "Invalid number of cache feature arguments"},
+	};
+
+	int r;
+	unsigned argc;
+	const char *arg;
+	struct cache_features *cf = &ca->features;
+
+	init_features(cf);
+
+	r = dm_read_arg_group(_args, as, &argc, error);
+	if (r)
+		return -EINVAL;
+
+	while (argc--) {
+		arg = dm_shift_arg(as);
+
+		if (!strcasecmp(arg, "writeback"))
+			cf->write_through = false;
+
+		else if (!strcasecmp(arg, "writethrough"))
+			cf->write_through = true;
+
+		else {
+			*error = "Unrecognised cache feature requested";
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int parse_policy(struct cache_args *ca, struct dm_arg_set *as,
+			char **error)
+{
+	static struct dm_arg _args[] = {
+		{0, 1024, "Invalid number of policy arguments"},
+	};
+
+	int r;
+	ensure_args(1);
+	ca->policy_name = dm_shift_arg(as);
+
+	r = dm_read_arg_group(_args, as, &ca->policy_argc, error);
+	if (r)
+		return -EINVAL;
+
+	ca->policy_argv = as->argv;
+	dm_consume_args(as, ca->policy_argc);
+
+	return 0;
+}
+
+static int parse_cache_args(struct cache_args *ca, int argc, char **argv,
+			    char **error)
+{
+	int r;
+	struct dm_arg_set as;
+
+	as.argc = argc;
+	as.argv = argv;
+
+#define parse(name) \
+	r = parse_ ## name(ca, &as, error); \
+	if (r) \
+		return r;
+
+	parse(metadata_dev);
+	parse(cache_dev);
+	parse(origin_dev);
+	parse(block_size);
+	parse(features);
+	parse(policy);
+#undef parse
+
+	return 0;
+}
+
+/*----------------------------------------------------------------*/
+
+static struct kmem_cache *_migration_cache;
+
+static int create_cache_policy(struct cache *cache, struct cache_args *ca,
+			       char **error)
+{
+	cache->policy =	dm_cache_policy_create(ca->policy_name,
+					       cache->cache_size,
+					       cache->origin_sectors,
+					       cache->sectors_per_block,
+					       ca->policy_argc, ca->policy_argv);
+	if (!cache->policy) {
+		*error = "Error creating cache's policy";
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+/*
+ * We want the discard block size to be a power of two, at least the size
+ * of the cache block size, and have no more than 2^14 discard blocks
+ * across the origin.
+ */
+#define MAX_DISCARD_BLOCKS (1 << 14)
+
+static bool too_many_discard_blocks(sector_t block_size,
+				    sector_t origin_size)
+{
+	do_div(origin_size, block_size);
+	return origin_size > MAX_DISCARD_BLOCKS;
+}
+
+static sector_t calculate_discard_block_size(sector_t cache_block_size,
+					     sector_t origin_size)
+{
+	sector_t r;
+
+	r = roundup_pow_of_two(cache_block_size);
+
+	if (origin_size)
+		while (too_many_discard_blocks(r, origin_size))
+			r *= 2;
+
+	return r;
+}
+
+#define DEFAULT_MIGRATION_THRESHOLD (2048 * 100)
+
+static int cache_create(struct cache_args *ca, struct cache **result)
+{
+	int r = 0;
+	char **error = &ca->ti->error;
+	struct cache *cache;
+	struct dm_target *ti = ca->ti;
+	dm_block_t origin_blocks;
+	struct dm_cache_metadata *cmd;
+	bool may_format = ca->features.mode == CM_WRITE;
+
+	cache = kzalloc(sizeof(*cache), GFP_KERNEL);
+	if (!cache)
+		return -ENOMEM;
+
+	cache->ti = ca->ti;
+	ti->private = cache;
+	ti->per_bio_data_size = sizeof(struct per_bio_data);
+	ti->num_flush_requests = 2;
+	ti->flush_supported = true;
+
+	ti->num_discard_requests = 1;
+	ti->discards_supported = true;
+	ti->discard_zeroes_data_unsupported = true;
+
+	cache->callbacks.congested_fn = cache_is_congested;
+	dm_table_add_target_callbacks(ti->table, &cache->callbacks);
+
+#define consume(n) n; n = NULL;
+
+	cache->metadata_dev = consume(ca->metadata_dev);
+	cache->origin_dev = consume(ca->origin_dev);
+	cache->cache_dev = consume(ca->cache_dev);
+	memcpy(&cache->features, &ca->features, sizeof(cache->features));
+
+	// FIXME: factor out this whole section
+	origin_blocks = cache->origin_sectors = ca->origin_sectors;
+	do_div(origin_blocks, ca->block_size);
+	cache->origin_blocks = to_oblock(origin_blocks);
+
+	cache->sectors_per_block = ca->block_size;
+	if (dm_set_target_max_io_len(ti, cache->sectors_per_block)) {
+		r = -EINVAL;
+		goto bad;
+	}
+
+	if (ca->block_size & (ca->block_size - 1)) {
+		dm_block_t cache_size = ca->cache_sectors;
+
+		cache->sectors_per_block_shift = -1;
+		(void) sector_div(cache_size, ca->block_size);
+		cache->cache_size = to_cblock(cache_size);
+	} else {
+		cache->sectors_per_block_shift = __ffs(ca->block_size);
+		cache->cache_size = to_cblock(ca->cache_sectors >> cache->sectors_per_block_shift);
+	}
+
+	cmd = dm_cache_metadata_open(cache->metadata_dev->bdev,
+				     ca->block_size, may_format);
+	if (IS_ERR(cmd)) {
+		*error = "Error creating metadata object";
+		r = PTR_ERR(cmd);
+		goto bad;
+	}
+	cache->cmd = cmd;
+
+	spin_lock_init(&cache->lock);
+	bio_list_init(&cache->deferred_bios);
+	bio_list_init(&cache->deferred_flush_bios);
+	INIT_LIST_HEAD(&cache->quiesced_migrations);
+	INIT_LIST_HEAD(&cache->completed_migrations);
+	INIT_LIST_HEAD(&cache->need_commit_migrations);
+	cache->migration_threshold = DEFAULT_MIGRATION_THRESHOLD;
+	atomic_set(&cache->nr_migrations, 0);
+	init_waitqueue_head(&cache->migration_wait);
+
+	cache->nr_dirty = 0;
+	cache->dirty_bitset = alloc_bitset(from_cblock(cache->cache_size));
+	if (!cache->dirty_bitset) {
+		*error = "could not allocate dirty bitset";
+		goto bad;
+	}
+	clear_bitset(cache->dirty_bitset, from_cblock(cache->cache_size));
+
+	cache->discard_block_size =
+		calculate_discard_block_size(cache->sectors_per_block,
+					     cache->origin_sectors);
+	cache->discard_nr_blocks = oblock_to_dblock(cache, cache->origin_blocks);
+	cache->discard_bitset = alloc_bitset(from_dblock(cache->discard_nr_blocks));
+	if (!cache->discard_bitset) {
+		*error = "could not allocate discard bitset";
+		goto bad;
+	}
+	clear_bitset(cache->discard_bitset, from_dblock(cache->discard_nr_blocks));
+
+	cache->copier = dm_kcopyd_client_create();
+	if (IS_ERR(cache->copier)) {
+		*error = "could not create kcopyd client";
+		r = PTR_ERR(cache->copier);
+		goto bad;
+	}
+
+	cache->wq = alloc_ordered_workqueue(DAEMON, WQ_MEM_RECLAIM);
+	if (!cache->wq) {
+		*error = "could not create workqueue for metadata object";
+		goto bad;
+	}
+	INIT_WORK(&cache->worker, do_worker);
+	INIT_DELAYED_WORK(&cache->waker, do_waker);
+	cache->last_commit_jiffies = jiffies;
+
+	cache->prison = dm_bio_prison_create(PRISON_CELLS);
+	if (!cache->prison) {
+		*error = "could not create bio prison";
+		goto bad;
+	}
+
+	cache->all_io_ds = dm_deferred_set_create();
+	if (!cache->all_io_ds) {
+		*error = "could not create all_io deferred set";
+		goto bad;
+	}
+
+	cache->migration_pool = mempool_create_slab_pool(MIGRATION_POOL_SIZE,
+							 _migration_cache);
+	if (!cache->migration_pool) {
+		*error = "Error creating cache's endio_hook mempool";
+		goto bad;
+	}
+
+	cache->next_migration = NULL;
+
+	r = create_cache_policy(cache, ca, error);
+	if (r)
+		goto bad;
+
+	cache->policy_nr_args = ca->policy_argc;
+
+	cache->need_tick_bio = true;
+	cache->sized = false;
+	cache->quiescing = false;
+	cache->commit_requested = false;
+	cache->loaded_mappings = false;
+	cache->loaded_discards = false;
+
+	load_stats(cache);
+
+	atomic_set(&cache->demotion, 0);
+	atomic_set(&cache->promotion, 0);
+	atomic_set(&cache->copies_avoided, 0);
+	atomic_set(&cache->cache_cell_clash, 0);
+	atomic_set(&cache->commit_count, 0);
+	atomic_set(&cache->discard_count, 0);
+
+	*result = cache;
+	return 0;
+
+bad:
+	destroy(cache);
+	return r;
+}
+
+static int cache_ctr(struct dm_target *ti, unsigned argc, char **argv)
+{
+	int r = -EINVAL;
+	struct cache_args *ca;
+	struct cache *cache = NULL;
+
+	ca = kzalloc(sizeof(*ca), GFP_KERNEL);
+	if (!ca) {
+		ti->error = "Error allocating memory for cache";
+		return -ENOMEM;
+	}
+	ca->ti = ti;
+
+	r = parse_cache_args(ca, argc, argv, &ti->error);
+	if (r)
+		goto out;
+
+	r = cache_create(ca, &cache);
+	ti->private = cache;
+
+out:
+	destroy_cache_args(ca);
+	return r;
+}
+
+static unsigned cache_get_num_duplicates(struct dm_target *ti,
+					 struct bio *bio)
+{
+	int r;
+	struct cache *cache = ti->private;
+	dm_oblock_t block = get_bio_block(cache, bio);
+	dm_cblock_t cblock;
+
+	if (bio_data_dir(bio) != WRITE || !cache->features.write_through)
+		return 1;
+
+#if 0
+	r = policy_lookup(cache->policy, block, &cblock);
+	if (r < 0)
+		return 2;	/* assume the worst */
+
+	return (!r && !is_dirty(cache, cblock)) ? 2 : 1;
+#else
+	// testing the failure case
+	return 2;
+#endif
+}
+
+static int cache_map(struct dm_target *ti, struct bio *bio)
+{
+	struct cache *cache = ti->private;
+
+	int r;
+	dm_oblock_t block = get_bio_block(cache, bio);
+	bool can_migrate = false;
+	bool discarded_block;
+	struct dm_bio_prison_cell *cell;
+	struct policy_result lookup_result;
+	struct per_bio_data *pb;
+
+	if (from_oblock(block) > from_oblock(cache->origin_blocks)) {
+		/*
+		 * This can only occur if the io goes to a partial block at
+		 * the end of the origin device.  We don't cache these.
+		 * Just remap to the origin and carry on.
+		 */
+		remap_to_origin_clear_discard(cache, bio, block);
+		return DM_MAPIO_REMAPPED;
+	}
+
+	pb = init_per_bio_data(bio);
+
+	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA | REQ_DISCARD)) {
+		defer_bio(cache, bio);
+		return DM_MAPIO_SUBMITTED;
+	}
+
+	/*
+	 * Check to see if that block is currently migrating.
+	 */
+	cell = dm_bio_prison_alloc_cell(cache->prison, GFP_NOWAIT);
+	r = bio_detain(cache, block, bio, cell,
+		       (cell_free_fn) dm_bio_prison_free_cell,
+		       cache->prison, &cell);
+	if (r) {
+		if (r < 0)
+			defer_bio(cache, bio);
+
+		return DM_MAPIO_SUBMITTED;
+	}
+
+	discarded_block = is_discarded_oblock(cache, block);
+
+	r = policy_map(cache->policy, block, false, can_migrate, discarded_block,
+		       bio, &lookup_result);
+	if (r == -EWOULDBLOCK) {
+		cell_defer(cache, cell, true);
+		return DM_MAPIO_SUBMITTED;
+
+	} else if (r) {
+		DMERR("Bug in policy\n");
+		bio_io_error(bio);
+		return DM_MAPIO_SUBMITTED;
+	}
+
+	switch (lookup_result.op) {
+	case POLICY_HIT:
+		inc_hit_counter(cache, bio);
+		pb->all_io_entry = dm_deferred_entry_inc(cache->all_io_ds);
+
+		if (is_writethrough_io(cache, bio, lookup_result.cblock)) {
+			/*
+			 * No need to mark anything dirty in write through mode.
+			 */
+			pb->req_nr == 0 ?
+				remap_to_cache(cache, bio, lookup_result.cblock) :
+				remap_to_origin_clear_discard(cache, bio, block);
+			cell_defer(cache, cell, false);
+		} else {
+			remap_to_cache_dirty(cache, bio, block, lookup_result.cblock);
+			cell_defer(cache, cell, false);
+		}
+		break;
+
+	case POLICY_MISS:
+		inc_miss_counter(cache, bio);
+		pb->all_io_entry = dm_deferred_entry_inc(cache->all_io_ds);
+
+		if (pb->req_nr != 0) {
+			/*
+			 * This is a duplicate writethrough io that is no
+			 * longer needed because the block has been demoted.
+			 */
+			bio_endio(bio, 0);
+			cell_defer(cache, cell, false);
+			return DM_MAPIO_SUBMITTED;
+		} else {
+			remap_to_origin_clear_discard(cache, bio, block);
+			cell_defer(cache, cell, false);
+		}
+		break;
+
+	default:
+		DMERR_LIMIT("%s: erroring bio, unknown policy op: %u", __func__,
+			    (unsigned) lookup_result.op);
+		bio_io_error(bio);
+		return DM_MAPIO_SUBMITTED;
+	}
+
+	return DM_MAPIO_REMAPPED;
+}
+
+static int cache_end_io(struct dm_target *ti, struct bio *bio, int error)
+{
+	struct cache *cache = ti->private;
+	unsigned long flags;
+	struct per_bio_data *pb = get_per_bio_data(bio);
+
+	if (pb->tick) {
+		policy_tick(cache->policy);
+
+		spin_lock_irqsave(&cache->lock, flags);
+		cache->need_tick_bio = true;
+		spin_unlock_irqrestore(&cache->lock, flags);
+	}
+
+	check_for_quiesced_migrations(cache, pb);
+	return 0;
+}
+
+static int write_dirty_bitset(struct cache *cache)
+{
+	unsigned i, r;
+
+	for (i = 0; i < from_cblock(cache->cache_size); i++) {
+		r = dm_cache_set_dirty(cache->cmd, to_cblock(i),
+				       is_dirty(cache, to_cblock(i)));
+		if (r)
+			return r;
+	}
+
+	return 0;
+}
+
+static int write_discard_bitset(struct cache *cache)
+{
+	unsigned i, r;
+
+	r = dm_cache_discard_bitset_resize(cache->cmd, cache->discard_block_size,
+					   cache->discard_nr_blocks);
+	if (r) {
+		DMERR("could not resize on-disk discard bitset");
+		return r;
+	}
+
+	for (i = 0; i < from_dblock(cache->discard_nr_blocks); i++) {
+		r = dm_cache_set_discard(cache->cmd, to_dblock(i),
+					 is_discarded(cache, to_dblock(i)));
+		if (r)
+			return r;
+	}
+
+	return 0;
+}
+
+static int save_hint(void *context, dm_cblock_t cblock, dm_oblock_t oblock,
+		     uint32_t hint)
+{
+	struct cache *cache = context;
+	return dm_cache_save_hint(cache->cmd, cblock, hint);
+}
+
+static int write_hints(struct cache *cache)
+{
+	int r;
+
+	r = dm_cache_begin_hints(cache->cmd,
+				 dm_cache_policy_get_name(cache->policy));
+	if (r) {
+		DMERR("dm_cache_begin_hints failed");
+		return r;
+	}
+
+	r = policy_walk_mappings(cache->policy, save_hint, cache);
+	if (r)
+		DMERR("policy_walk_mappings failed");
+
+	return r;
+}
+
+/*
+ * returns true on success
+ */
+static bool sync_metadata(struct cache *cache)
+{
+	int r1, r2, r3, r4;
+
+	r1 = write_dirty_bitset(cache);
+	if (r1)
+		DMERR("could not write dirty bitset");
+
+	r2 = write_discard_bitset(cache);
+	if (r2)
+		DMERR("could not write discard bitset");
+
+	save_stats(cache);
+
+	r3 = write_hints(cache);
+	if (r3)
+		DMERR("could not write hints");
+
+	/*
+	 * If writing the above metadata failed, we still commit, but don't
+	 * set the clean shutdown flag.  This will effectively force every
+	 * dirty bit to be set on reload.
+	 */
+	r4 = dm_cache_commit(cache->cmd, !r1 && !r2 && !r3);
+	if (r4)
+		DMERR("could not write cache metadata.  Data loss may occur.");
+
+	return !r1 && !r2 && !r3 && !r4;
+}
+
+static void cache_postsuspend(struct dm_target *ti)
+{
+	struct cache *cache = ti->private;
+
+	start_quiescing(cache);
+	wait_for_migrations(cache);
+	stop_worker(cache);
+	requeue_deferred_io(cache);
+	stop_quiescing(cache);
+
+	(void) sync_metadata(cache);
+}
+
+static int load_mapping(void *context, dm_oblock_t oblock, dm_cblock_t cblock,
+			bool dirty, uint32_t hint, bool hint_valid)
+{
+	int r;
+	struct cache *cache = context;
+
+	r = policy_load_mapping(cache->policy, oblock, cblock, hint, hint_valid);
+	if (r)
+		return r;
+
+	if (dirty)
+		set_dirty(cache, oblock, cblock);
+	else
+		clear_dirty(cache, oblock, cblock);
+
+	return 0;
+}
+
+static int load_discard(void *context, sector_t discard_block_size,
+			dm_dblock_t dblock, bool discard)
+{
+	struct cache *cache = context;
+
+	// FIXME: handle mis-matched block size
+
+	if (discard)
+		set_discard(cache, dblock);
+	else
+		clear_discard(cache, dblock);
+
+	return 0;
+}
+
+static int cache_preresume(struct dm_target *ti)
+{
+	int r = 0;
+	struct cache *cache = ti->private;
+	sector_t actual_cache_size = get_dev_size(cache->cache_dev);
+	(void) sector_div(actual_cache_size, cache->sectors_per_block);
+
+	/*
+	 * Check to see if the cache has resized.
+	 */
+	if (from_cblock(cache->cache_size) != actual_cache_size || !cache->sized) {
+		cache->cache_size = to_cblock(actual_cache_size);
+
+		r = dm_cache_resize(cache->cmd, cache->cache_size);
+		if (r) {
+			DMERR("could not resize cache metadata");
+			return r;
+		}
+
+		cache->sized = true;
+	}
+
+	if (!cache->loaded_mappings) {
+		r = dm_cache_load_mappings(cache->cmd,
+					   dm_cache_policy_get_name(cache->policy),
+					   load_mapping, cache);
+		if (r) {
+			DMERR("could not load cache mappings");
+			return r;
+		}
+
+		cache->loaded_mappings = true;
+	}
+
+	if (!cache->loaded_discards) {
+		r = dm_cache_load_discards(cache->cmd, load_discard, cache);
+		if (r) {
+			DMERR("could not load origin discards");
+			return r;
+		}
+
+		cache->loaded_discards = true;
+	}
+
+	return r;
+}
+
+static void cache_resume(struct dm_target *ti)
+{
+	struct cache *cache = ti->private;
+
+	cache->need_tick_bio = true;
+	do_waker(&cache->waker.work);
+}
+
+static int cache_status(struct dm_target *ti, status_type_t type,
+			unsigned status_flags, char *result, unsigned maxlen)
+{
+	int r = 0;
+	ssize_t sz = 0;
+	dm_block_t nr_free_blocks_metadata = 0;
+	dm_block_t nr_blocks_metadata = 0;
+	char buf[BDEVNAME_SIZE];
+	struct cache *cache = ti->private;
+	dm_cblock_t residency;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		/* Commit to ensure statistics aren't out-of-date */
+		if (!(status_flags & DM_STATUS_NOFLUSH_FLAG) && !dm_suspended(ti)) {
+			r = dm_cache_commit(cache->cmd, false);
+			if (r)
+				DMERR("could not commit metadata for accurate status");
+		}
+
+		r = dm_cache_get_free_metadata_block_count(cache->cmd,
+							   &nr_free_blocks_metadata);
+		if (r)
+			DMERR("could not get metadata free block count");
+
+		r = dm_cache_get_metadata_dev_size(cache->cmd, &nr_blocks_metadata);
+		if (r)
+			DMERR("could not get metadata device size");
+
+		residency = policy_residency(cache->policy);
+
+		DMEMIT("%llu/%llu %u %u %u %u %u %u %llu %u %llu",
+		       (unsigned long long)(nr_blocks_metadata - nr_free_blocks_metadata),
+		       (unsigned long long)nr_blocks_metadata,
+		       (unsigned) atomic_read(&cache->read_hit),
+		       (unsigned) atomic_read(&cache->read_miss),
+		       (unsigned) atomic_read(&cache->write_hit),
+		       (unsigned) atomic_read(&cache->write_miss),
+		       (unsigned) atomic_read(&cache->demotion),
+		       (unsigned) atomic_read(&cache->promotion),
+		       (unsigned long long) from_cblock(residency),
+		       cache->nr_dirty,
+		       (unsigned long long) cache->migration_threshold);
+		break;
+
+	case STATUSTYPE_TABLE:
+		format_dev_t(buf, cache->metadata_dev->bdev->bd_dev);
+		DMEMIT("%s ", buf);
+		format_dev_t(buf, cache->cache_dev->bdev->bd_dev);
+		DMEMIT("%s ", buf);
+		format_dev_t(buf, cache->origin_dev->bdev->bd_dev);
+		DMEMIT("%s ", buf);
+		DMEMIT("%llu ", (unsigned long long) cache->sectors_per_block);
+
+		DMEMIT("1 %s ", cache->features.write_through ?
+		       "writethrough" : "writeback");
+
+		DMEMIT("%s %u ", dm_cache_policy_get_name(cache->policy),
+		       cache->policy_nr_args);
+	}
+
+	if (sz < maxlen)
+		r = policy_status(cache->policy, type, status_flags,
+				  result + sz, maxlen - sz);
+
+	return r;
+}
+
+static int process_config_option(struct cache *cache, char **argv)
+{
+	if (!strcasecmp(argv[1], "migration_threshold")) {
+		unsigned long tmp;
+
+		if (kstrtoul(argv[2], 10, &tmp))
+			return -EINVAL;
+
+		cache->migration_threshold = tmp;
+
+	} else
+		return 1; /* Inform caller it's not our option. */
+
+	return 0;
+}
+
+static int cache_message(struct dm_target *ti, unsigned argc, char **argv)
+{
+	int r = 0;
+	struct cache *cache = ti->private;
+
+	if (argc != 3)
+		return -EINVAL;
+
+	r = !strcasecmp(argv[0], "set_config") ? process_config_option(cache, argv) : 1;
+
+	if (r == 1) /* Message is for the target -> hand over to policy plugin. */
+		r = policy_message(cache->policy, argc, argv);
+
+	return r;
+}
+
+static int cache_iterate_devices(struct dm_target *ti,
+				 iterate_devices_callout_fn fn, void *data)
+{
+	int r = 0;
+	struct cache *cache = ti->private;
+
+	r = fn(ti, cache->cache_dev, 0, get_dev_size(cache->cache_dev), data);
+	if (!r)
+		r = fn(ti, cache->origin_dev, 0, ti->len, data);
+
+	return r;
+}
+
+static int cache_bvec_merge(struct dm_target *ti,
+			  struct bvec_merge_data *bvm,
+			  struct bio_vec *biovec, int max_size)
+{
+	struct cache *cache = ti->private;
+	struct request_queue *q = bdev_get_queue(cache->origin_dev->bdev);
+
+	if (!q->merge_bvec_fn)
+		return max_size;
+
+	bvm->bi_bdev = cache->origin_dev->bdev;
+	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
+}
+
+static void set_discard_limits(struct cache *cache, struct queue_limits *limits)
+{
+	/*
+	 * FIXME: these limits may be incompatible with the cache device
+	 */
+	limits->max_discard_sectors = cache->discard_block_size * 1024;
+	limits->discard_granularity = cache->discard_block_size << SECTOR_SHIFT;
+}
+
+static void cache_io_hints(struct dm_target *ti, struct queue_limits *limits)
+{
+	struct cache *cache = ti->private;
+
+	blk_limits_io_min(limits, 0);
+	blk_limits_io_opt(limits, cache->sectors_per_block << SECTOR_SHIFT);
+	set_discard_limits(cache, limits);
+}
+
+/*----------------------------------------------------------------*/
+
+static struct target_type cache_target = {
+	.name = "cache",
+	.version = {1, 0, 0},
+	.module = THIS_MODULE,
+	.ctr = cache_ctr,
+	.dtr = cache_dtr,
+	.get_num_duplicates = cache_get_num_duplicates,
+	.map = cache_map,
+	.end_io = cache_end_io,
+	.postsuspend = cache_postsuspend,
+	.preresume = cache_preresume,
+	.resume = cache_resume,
+	.status = cache_status,
+	.message = cache_message,
+	.iterate_devices = cache_iterate_devices,
+	.merge = cache_bvec_merge,
+	.io_hints = cache_io_hints,
+};
+
+static int __init dm_cache_init(void)
+{
+	int r;
+
+	r = dm_register_target(&cache_target);
+	if (r)
+		return r;
+
+	r = -ENOMEM;
+
+	_migration_cache = KMEM_CACHE(dm_cache_migration, 0);
+	if (!_migration_cache) {
+		dm_unregister_target(&cache_target);
+		return r;
+	}
+
+	return 0;
+}
+
+static void dm_cache_exit(void)
+{
+	dm_unregister_target(&cache_target);
+	kmem_cache_destroy(_migration_cache);
+}
+
+module_init(dm_cache_init);
+module_exit(dm_cache_exit);
+
+MODULE_DESCRIPTION(DM_NAME " cache target");
+MODULE_AUTHOR("Joe Thornber <ejt@redhat.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
index ec4cb3c..fb50478 100644
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -613,6 +613,7 @@ int dm_bm_flush_and_unlock(struct dm_block_manager *bm,
 
 	return dm_bufio_write_dirty_buffers(bm->bufio);
 }
+EXPORT_SYMBOL_GPL(dm_bm_flush_and_unlock);
 
 void dm_bm_set_read_only(struct dm_block_manager *bm)
 {
-- 
1.7.10.4
