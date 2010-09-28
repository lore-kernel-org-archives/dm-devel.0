From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH] dm-thinp: new device mapper target to thin
 provision storage
Date: Tue, 28 Sep 2010 22:49:37 +0200
Message-ID: <1285706977.22966.20.camel@o>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: agk@redhat.com
List-Id: dm-devel.ids


These are 2 new device mapper targets "thinp" and "thinp-dev"
implemented in one module, which allow for thin provisioning of storage
on a single host from a storage pool to an arbitrary amount of devices.

Storage is being late committed on writes in units of extents which can
be sized at pool creation time (typically relatively large like 1/2 GB
to minimize allocation overhead). The pool can be resized to adjust to
varying needs. Any allocated extents are being freed when a device
shrinks, thus being subject to allocation by other thin provisioned
devices allocating from the same pool.

The status interface provides information about pool and device
allocation. Device-mapper table events are being thrown when pool is
running full or on io errors.

Please read Documentation/device-mapper/thinp.txt for how to use it.


Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Tested-by:     Heinz Mauelshagen <heinzm@redhat.com>


 Documentation/device-mapper/thinp.txt |   86 +
 drivers/md/Kconfig                    |    7 +
 drivers/md/Makefile                   |    1 +
 drivers/md/dm-thinp.c                 | 3424 +++++++++++++++++++++++++++++++++
 4 files changed, 3518 insertions(+), 0 deletions(-)

diff --git a/Documentation/device-mapper/thinp.txt b/Documentation/device-mapper/thinp.txt
new file mode 100644
index 0000000..620f48a
--- /dev/null
+++ b/Documentation/device-mapper/thinp.txt
@@ -0,0 +1,86 @@
+Device-mapper thin provisioning support
+=======================================
+
+Allows you to:
+
+- create a pool of extents to allocate to an arbitray
+  amount of devices on write requests.
+- create devices and bind them to a thin provisioning pool
+  for late allocation.on writes
+- grow (and shrink) the pool on the fly in case it runs
+  full or is too large.
+
+
+There are two dm targets available: "thinp" and "thinp-dev".
+
+thinp <pool_dev_path> <pool_dev_start> <#varible_params> [<params>...]
+
+which will normally have one or more thinp provisioned devices based on it.
+Any writes to any of the thin provisioned devices trigger the allocation
+of extents from the pool and mapping them to the address space the write
+occured to.
+
+"thinp" parameter syntax as follows:
+ *
+ * #variable_params = 0-2
+ *
+ * params = {auto/create/open} [#pool_extent_size [policy]]
+ *
+ * 'auto' causes open of a pool with a valid header or
+ * creation of a new pool if there's no vaild one sized to ti->len.
+ *
+ * 'create' enforces creation of a new pool with length ti->len
+ * WARNING: this overwrites an existing pool!!!
+ *
+ * 'open' requires a valid pool to exist. No new one will be
+ * created ever.
+ *
+ * #variable_params:
+ * 0: the pool device must exist and will be opened or the constructor fails
+ * 1 + 'open': equal to '0'
+ * 1 + 'auto': open existing pool or create new one with length ti->len;
+ *             implies resizing of an existing pool if ti->len differs
+ *             from pool size in header
+ * 1 + 'create': the pool device will get initialized and sized to ti->len
+ * 2 + 'auto': the pool device will either be opened and tried to resize
+ *             or get initialized and sized to ti->lem setting the extent
+ *             size to pool_extent_size
+ * 3: on create (either implicit or via 'auto'),
+ *    this pool_extent_size will be used.
+ * 4: policy = "error|postpone" defaults to postpone:
+ *             if pool runs full, bios will be errored or postponed
+ *             (ie. application writes will stall
+
+thinp-dev <pool_device> <device_nr>
+
+Creates a thin provisioned device and binds it to the pool internal <device_nr>.
+
+When tearing down a thin provisioned device, it is impossible to tell if
+it's meant transient (eg. on LVM VG deactivation in order to recreate the
+mapping on VG activation again) or persistent (ie. remove the device
+permanently and free any allocated extents). Thus a message is supported
+for the later case of permanently removing the thin provisioned device.
+
+Message format:
+
+remove_device <device_nr>
+
+
+Examples:
+
+Create an 8GB large thinp provisioning pool with extent size 1MB:
+echo "0 16777216 thinp 0 2 auto 2048" | dmsetup create thinp_pool
+
+Create an 1TB large thinp provisioned device with internal #1:
+echo "0 2147483648 thinp-dev thinp_pool 1" | dmsetup create thinp1
+
+Create an ext4 filesystem on the thin provisioned device:
+mkfs -t ext4 /dev/mapper/thinp1
+
+Retrieve status of pool and thin provisioned device:
+dmsetup status thinp_pool
+dmsetup status thinp1
+
+Drop device #1:
+dmsetup remove thinp1
+dmsetup message thinp_pool remove_device 1
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index bf1a95e..985c589 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -297,6 +297,13 @@ config DM_DELAY
 
 	If unsure, say N.
 
+config DM_THINP
+	tristate "Thin provisioning target (EXPERIMENTAL)"
+	depends on BLK_DEV_DM && EXPERIMENTAL
+	---help---
+	A target that supports thin provisioning storage capacity
+	from a large storage pool to multiple devices.
+
 config DM_UEVENT
 	bool "DM uevents (EXPERIMENTAL)"
 	depends on BLK_DEV_DM && EXPERIMENTAL
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 5e3aac4..184785e 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-region-hash.o
 obj-$(CONFIG_DM_LOG_USERSPACE)	+= dm-log-userspace.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
+obj-$(CONFIG_DM_THINP)		+= dm-thinp.o
 
 ifeq ($(CONFIG_DM_UEVENT),y)
 dm-mod-objs			+= dm-uevent.o
diff --git a/drivers/md/dm-thinp.c b/drivers/md/dm-thinp.c
new file mode 100644
index 0000000..4bd48aa
--- /dev/null
+++ b/drivers/md/dm-thinp.c
@@ -0,0 +1,3424 @@
+/*
+ * Copyright (C) 2010 Red Hat GmbH. All rights reserved.
+ *
+ * Module Author: Heinz Mauelshagen <heinzm@redhat.com>
+ *
+ * This file is released under the GPL.
+ *
+ * Thin provisioning target.
+ *
+ * Features:
+ * o manages a storage pool of free extents to
+ *   allocate to an arbitrary number of devices
+ * o extent size selectable (2^^N)
+ * o initializes metadata for extents in pool in the background
+ *   in order to fasten construction -> immediate pool access
+ * o supports storage pool resizing via message interface or constructor
+ * o stores CRCs with extent metadata and runs integrity checks on read
+ * o stores versions with metadata to support future metadata changes
+ * o frees any allocated extents when existing device shrinks
+ * o support freeing all allocated extents of a (closed) device
+ *   via message interface (mandatory because of dtr lag of semantics)
+ *
+ *
+ * Disk layout of storage pool backing store:
+ *
+ * H.M1.M2.M3..Mn D1.D2.D3..Dn with n = 64
+ *
+ * H  : Pool header storing pool and extent size etc.
+ * En : Data sectors belonging to extent n and device m
+ * Mn : metadata for extent n holding pool and provisioned device offsets
+ *
+ * FIXME:
+ * o support DISCARD requests to free unused extents
+ * o support relocation of extents to allow for pool shrinking in case
+ *   of free extents in the middle with provisioned ones by the end
+ *   of the pool (dm-kcopyd!)
+ * o support relocation of extents to allow for hot spot removal.
+ *
+ */
+
+static const char version[] = "1.0";
+
+#include "dm.h"
+
+#include <linux/dm-io.h>
+#include <linux/dm-kcopyd.h>
+#include <linux/bio.h>
+#include <linux/blkdev.h>
+#include <linux/crc32.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/workqueue.h>
+
+#define	DM_MSG_PREFIX	"dm-thinp"
+#define	DAEMON		DM_MSG_PREFIX	"d"
+#define	POOL_TARGET	DM_MSG_PREFIX
+#define	DEV_TARGET	DM_MSG_PREFIX "-dev"
+
+/* Minimum parallel IO for resource allocation in dm_*() client creation. */
+#define	PARALLEL_IO_MAX	256
+
+/* Maximum number of per device hash buckets. */
+#define	BUCKETS_MAX	16384
+
+/* FIXME: factor these macros out to dm.h */
+#define	TI_ERR_RET(ret, str) \
+	do { ti->error = DM_MSG_PREFIX ": " str; return ret; } while (0);
+#define	TI_ERR(str)	TI_ERR_RET(-EINVAL, str)
+#define	DM_ERR_RET(ret, x...) \
+	do { DMERR(x); return ret; } while (0);
+#define	DM_ERR(x...)	DM_ERR_RET(-EINVAL, x)
+
+#define	EXTENT_SECTORS_DEFAULT	to_sector(512*1024*1024) /* 512MB */
+#define	SECTOR_SIZE		to_bytes(1)	/* Sector size in bytes. */
+
+/* Check a parameter is within min/max range (inclusive). */
+static inline int range_ok(unsigned long long n,
+			   unsigned long long min, unsigned long long max)
+{
+	return n >= min && n <= max;
+}
+
+/*
+ * Fixed size of all ondisk metadata areas
+ * (ie. header and per extent metadata).
+ */
+#define	META_SECTORS	to_sector(4096)
+#define	EXTENTS_MIN	128
+#define	EXTENTS_PER_GROUP	128
+#define	MIN_POOL_SIZE	(128*2*1024) /* 128MB */
+
+/* Maximum parallel extent creation in order to avoid starvation on writes. */
+#define	PARALLEL_INIT_READ_MAX	1024
+#define	PARALLEL_INIT_WRITE_MAX	128
+
+/* Reasonable extent size maximum. */
+#define	MAX_EXTENT_SIZE		(128*2*1024*1024) /* 128 GB */
+
+#define	LLU	long long unsigned
+
+static struct list_head pool_contexts_list;
+static struct mutex pool_contexts_list_lock;
+
+/* A thinp extent hash. */
+struct extent_hash {
+	struct list_head *hash;
+	unsigned buckets;
+	unsigned mask;
+	unsigned prime;
+	unsigned shift;
+};
+
+struct extent_dev_hash {
+	struct list_head list;	/* To list on thinp_pool_c. */
+	struct mutex lock;	/* Lock to access hash. */
+	struct extent_hash hash; /* The actual hash embeded. */
+};
+
+/* On disk metadata for pool extents. */
+static const char extent_magic[] = "DmThinPr";
+#define	EXTENT_MAGIC_SIZE 8
+struct extent_disk {
+	uint8_t magic[EXTENT_MAGIC_SIZE];	/* Magic key */
+	uint32_t crc;
+	uint32_t filler;
+	uint64_t flags;		/* Status flag. */
+	struct {
+		uint64_t data_offset;	/* Pool device byte offset. */
+		uint64_t dev_offset;	/* Thin provisioned device offset. */
+		uint64_t dev_nr;	/* Extent belonging to device number. */
+	} addr;
+} __attribute__ ((packed));
+
+/* Incore housekeeping of extents in pool and ios from/to them. */
+struct extent {
+	struct thinp_pool_c *pc; /* For extent_meta_endio(). */
+	struct thinp_dev_c *dc; /* Extent belongs to this provisioned dev. */
+
+	uint64_t nr;	/* Extent number. */
+
+	/* Lists for various extent states. */
+	struct {
+		struct list_head hash;		/* Hash. */
+		struct list_head flush;		/* Flush to pool. */
+		struct list_head endio;		/* Endio. */
+		struct list_head free_init;	/* Extent free/init.  */
+		struct list_head ordered;	/* Address ordered list. */
+		atomic_t endio_ref;		/* # of endio references. */
+	} lists;
+
+	struct extent_io {
+		/*
+		 * Endio lock against races between worker and
+		 * bio_submit_callback()/extent_meta_endio().
+		 */
+		spinlock_t endio_lock;
+		struct bio_list in;	/* Bio input queue. */
+		struct bio_list endio;	/* Bios to endio. */
+		unsigned long flags;	/* Status flag */
+	} io;
+
+	/* Device addresses. */
+	struct {
+		struct pool_address {
+			sector_t meta_offset;	/* Metadata sector offset. */
+			sector_t data_offset;	/* Data sector offset. */
+		} pool;
+		union {
+			sector_t key;	/* Hash key. */
+			sector_t offset;/* Extent offset on original device. */
+		} dev;
+
+		uint64_t dev_nr;	/* Device number. */
+	} addr;
+
+
+	/*
+	 * Extent metadata on disk representation
+	 * (allocated from mempool during IO only).
+	 */
+	struct extent_disk *disk;
+};
+
+/* Pool device header. */
+static const char header_magic[] = "dm_thinpr_HM4711";
+#define	HEADER_MAGIC_SIZE	16
+struct disk_pool_header {
+	uint8_t magic[HEADER_MAGIC_SIZE];
+	uint32_t crc;
+	struct {
+		uint8_t major;
+		uint8_t minor;
+		uint8_t subminor;
+		uint8_t filler;
+	} version;
+
+	struct {
+		uint64_t dev;		  /* Pool device size. */
+		uint64_t dev_initialized; /* Initialized to this byte offset- */
+		uint64_t extent;	  /* Provisioned extent size. */
+		uint64_t extents_per_chunk;/* Extents per allocation chunk. */
+	} size;
+
+	uint64_t flags;		/* Feature flags. */
+} __attribute__ ((packed));
+
+/* Macros to access object state flags. */
+#define	BITOPS(name, what, var, flag) \
+static inline int TestClear ## name ## what(struct var *v) \
+{ return test_and_clear_bit(flag, &v->io.flags); } \
+static inline int TestSet ## name ## what(struct var *v) \
+{ return test_and_set_bit(flag, &v->io.flags); } \
+static inline void Clear ## name ## what(struct var *v) \
+{ clear_bit(flag, &v->io.flags); } \
+static inline void Set ## name ## what(struct var *v) \
+{ set_bit(flag, &v->io.flags); } \
+static inline int name ## what(struct var *v) \
+{ return test_bit(flag, &v->io.flags); }
+
+/* Extent state flags. */
+enum extent_flags {
+	/* Persistent extent state flags. */
+	EXTENT_ERROR,		/* IO error on extent ocurred. */
+	EXTENT_FREE,		/* Extent is available. */
+
+	/*
+	 * Don't change the order of the previous ones
+	 * because they are persistent in the ondisk metadata!
+	 *
+	 * Those following below are transient.
+	 */
+	EXTENT_COPYING,		/* Extent is being copied via dm-kcopyd. xXx */
+	EXTENT_INIT,		/* Extent to init. */
+	EXTENT_META_IO,		/* Extent metadata io active. */
+	EXTENT_META_READ,	/* Extent metadata read. */
+	EXTENT_DROPPED,		/* Extent dropped from device. */
+};
+
+BITOPS(Extent, Error, extent, EXTENT_ERROR)
+BITOPS(Extent, Free, extent, EXTENT_FREE)
+
+BITOPS(Extent, Copying, extent, EXTENT_COPYING)
+BITOPS(Extent, Init, extent, EXTENT_INIT)
+BITOPS(Extent, MetaIo, extent, EXTENT_META_IO)
+BITOPS(Extent, MetaRead, extent, EXTENT_META_READ)
+BITOPS(Extent, Dropped, extent, EXTENT_DROPPED)
+
+/* REMOVEME: */
+/* Development pool statistics. */
+struct pool_stats {
+	atomic_t io[2];
+	atomic_t hits[2];
+	atomic_t misses[2];
+	atomic_t submitted_io[2];
+	atomic_t extent_meta_io[2];
+	atomic_t bios_endiod[2];
+	atomic_t extents_hashed;
+};
+
+/* Reset pool statistics variables. */
+static void pool_stats_init(struct pool_stats *ps)
+{
+	int i = ARRAY_SIZE(ps->io);
+
+	while (i--) {
+		atomic_set(ps->io + i, 0);
+		atomic_set(ps->hits + i, 0);
+		atomic_set(ps->misses + i, 0);
+		atomic_set(ps->submitted_io + i, 0);
+		atomic_set(ps->extent_meta_io + i, 0);
+		atomic_set(ps->bios_endiod + i, 0);
+	}
+
+	atomic_set(&ps->extents_hashed, 0);
+}
+
+/* Development device statistics. */
+struct dev_stats {
+	atomic_t io[2];
+	atomic_t submitted_io[2];
+	atomic_t extent_meta_io[2];
+	atomic_t bios_endiod[2];
+	atomic_t bios_requeued;
+	atomic_t merge_bvec_fn;
+	atomic_t extents_hashed;
+};
+
+/* Reset device statistics variables. */
+static void dev_stats_init(struct dev_stats *ds)
+{
+	int i = ARRAY_SIZE(ds->io);
+
+	while (i--) {
+		atomic_set(ds->io + i, 0);
+		atomic_set(ds->submitted_io + i, 0);
+		atomic_set(ds->extent_meta_io + i, 0);
+		atomic_set(ds->bios_endiod + i, 0);
+	}
+
+	atomic_set(&ds->merge_bvec_fn, 0);
+	atomic_set(&ds->extents_hashed, 0);
+}
+
+/* Create new or open existing pool. */
+enum handle_type {
+	AUTO_POOL = 0,	/* Auto pool discovery (open existing/create new). */
+	CREATE_POOL,	/* Force create new pool. */
+	OPEN_POOL,	/* Open existing pool. */
+};
+
+/* Maps a range of a device. */
+struct c_dev {
+	struct dm_dev *dev;
+	unsigned block_size; /* Bytes. */
+	sector_t start;
+	sector_t size;
+	sector_t initialized;
+};
+
+/* Pool context. */
+struct thinp_pool_c {
+	struct dm_target *ti;
+	atomic_t ref;	/* Device references. */
+
+	struct {
+		atomic_t ref;	/* IO in flight reference counting. */
+		atomic_t errors;/* # of IO errors on pool backing store. */
+
+		struct bio_list in;
+		struct bio_list work;
+		struct bio_list wait;
+		spinlock_t lock;
+
+		struct workqueue_struct *wq;	/* Work queue. */
+		struct work_struct ws;		/* IO work. */
+
+		/* IO services used. */
+		struct dm_io_client *dm_io_client;
+		struct dm_kcopyd_client *dm_kcopyd_client;
+
+		/* Mempool of metadata sectors. */
+		mempool_t *metadata_pool;
+
+		unsigned long flags;
+
+		wait_queue_head_t suspendq;	/* Suspend synchronization. */
+	} io;
+
+	/* Pool device properties. */
+	struct c_dev pool;
+	dev_t ctrl_dev;
+
+	/* Extent properties. */
+	struct {
+		sector_t size;
+		atomic_t allocated;	/* # of allocated extents. */
+		atomic_t free;		/* # of free extents. */
+		atomic_t initialized;	/* # of initialized extents. */
+		atomic_t total;		/* Total # of extents. */
+		atomic_t init_max;	/* max # of init flushing extents. */
+
+		/* Extent address masks to quicken calculation... */
+		sector_t mask;		/* of hash key. */
+		sector_t mask_inv;	/* of extent address. */
+
+		unsigned per_chunk;	/* # of extents per chunk. */
+	} extents;
+
+	struct thinp_lists {
+		/* To hang off of global pool contexts list. */
+		struct list_head context;
+
+		/* Endio list. */
+		struct list_head endio;
+
+		/* Flush list. */
+		struct list_head flush;
+
+		/* List of free ondisk pool extents. */
+		struct list_head free;
+
+		/* To list extent_dev_hash structures. */
+		struct list_head dev_hashs;
+		struct mutex dev_hashs_lock;
+
+		/* List of extents to initialize in do_extents_init(). */
+		struct list_head init;
+
+		/* Address ordered list of all extents. */
+		struct list_head ordered;
+
+		spinlock_t lock_endio; /* Protect endio list */
+	} lists;
+
+	/* Pool ctr parameters for status output epc. */
+	struct pool_params {
+		sector_t pool_start;
+		unsigned params;
+		enum handle_type handle;
+		sector_t pool_size;
+		sector_t extent_size;
+		sector_t pool_new_size;
+		sector_t policy_error;
+	} params;
+
+	struct pool_stats stats;
+
+	/* Pool device disk header. */
+	struct disk_pool_header *disk;
+};
+
+/* Pool state flags. */
+enum thinp_pool_c_flags {
+	POOL_INITIALIZED,		/* Pool completely initializated. */
+	POOL_DO_INITIALIZE,		/* Run initialization of extents. */
+	POOL_INITIALIZE_NEW,		/* Write " */
+	POOL_INITIALIZATION_ACTIVE,	/* Initialization IO active. */
+	POOL_RESIZE,			/* Pool resizing. */
+	POOL_DEAD,			/* Pool deead because of fatal error. */
+	POOL_SUSPEND,			/* Pool suspension. */
+	POOL_POOL_IO_QUEUED,		/* IOs to pool device queued. */
+	POOL_NEW_BIOS_QUEUED,		/* New bios queued. */
+	POOL_STATISTICS,		/* Pool statisitics. */
+	POOL_CHANGE_POLICY_ERROR,	/* Pool policy error change. */
+	POOL_POLICY_ERROR,		/* Pool policy to error bios on full. */
+};
+
+BITOPS(Pool, Initialized, thinp_pool_c, POOL_INITIALIZED)
+BITOPS(Pool, DoInitialize, thinp_pool_c, POOL_DO_INITIALIZE)
+BITOPS(Pool, InitializeNew, thinp_pool_c, POOL_INITIALIZE_NEW)
+BITOPS(Pool, InitializationActive, thinp_pool_c, POOL_INITIALIZATION_ACTIVE)
+BITOPS(Pool, Resize, thinp_pool_c, POOL_RESIZE)
+BITOPS(Pool, Dead, thinp_pool_c, POOL_DEAD)
+BITOPS(Pool, Suspend, thinp_pool_c, POOL_SUSPEND)
+BITOPS(Pool, IOQueued, thinp_pool_c, POOL_POOL_IO_QUEUED)
+BITOPS(Pool, NewBiosQueued, thinp_pool_c, POOL_NEW_BIOS_QUEUED)
+BITOPS(Pool, Statistics, thinp_pool_c, POOL_STATISTICS)
+BITOPS(Pool, ChangePolicyError, thinp_pool_c, POOL_CHANGE_POLICY_ERROR)
+BITOPS(Pool, PolicyError, thinp_pool_c, POOL_POLICY_ERROR)
+
+/* Pool context. */
+struct thinp_dev_c {
+	struct dm_target *ti;
+	struct thinp_pool_c *pc;
+
+	/* Extent hash. */
+	struct extent_dev_hash dev_hash;
+
+	struct {
+		spinlock_t lock;	/* Protects central input list above. */
+		atomic_t ref;		/* IO in flight reference counting. */
+		wait_queue_head_t suspendq;	/* Suspend synchronization. */
+		unsigned long flags;		/* IO flags. */
+	} io;
+
+	/* Reference to pool control device. */
+	struct dm_dev *dm_dev;
+
+	/* Pool ctr parameters for status output etc. */
+	struct dev_params {
+		uint64_t dev_nr;
+	} params;
+
+	struct dev_stats stats;
+};
+
+/* Device state flags. */
+enum thinp_dev_c_flags {
+	DEV_ERROR,		/* Device error. */
+	DEV_STATISTICS,		/* Device statisitics. */
+};
+
+BITOPS(Dev, Error, thinp_dev_c, DEV_ERROR)
+BITOPS(Dev, Statistics, thinp_dev_c, DEV_STATISTICS)
+#undef BITOPS
+
+/* Return extent size (extent sectors + metadata sectors). */
+static inline sector_t extent_data_size(struct thinp_pool_c *pc)
+{
+	return pc->extents.size;
+}
+
+/* Return extent size (extent sectors + metadata sectors). */
+static inline sector_t extent_total_size(struct thinp_pool_c *pc)
+{
+	return extent_data_size(pc) + META_SECTORS;
+}
+
+/* Return start of first extent. */
+static inline sector_t extents_start(struct thinp_pool_c *pc)
+{
+	return pc->pool.start + META_SECTORS;
+}
+
+/* Return true if extent has read/write bios on input queues. */
+static inline int extent_has_bios_queued(struct extent *extent)
+{
+	return !bio_list_empty(&extent->io.in);
+}
+
+/* Return true if extent is idle. */
+static int endio_ref(struct extent *extent);
+static int extent_is_idle(struct extent *extent)
+{
+	return !(endio_ref(extent) ||
+		 extent_has_bios_queued(extent));
+}
+
+/*
+ * Disk metadata sectors alloc/free.
+ */
+static void *metadata_zalloc(struct thinp_pool_c *pc)
+{
+	void *r = mempool_alloc(pc->io.metadata_pool, GFP_NOIO);
+
+	if (r)
+		memset(r, 0, SECTOR_SIZE);
+
+	return r;
+}
+
+static void metadata_free(struct thinp_pool_c *pc, void **disk)
+{
+	mempool_free(*disk, pc->io.metadata_pool);
+	*disk = NULL;
+}
+
+/*
+ * Extent struct allocation/free.
+ */
+static struct extent *extent_alloc(struct thinp_pool_c *pc, gfp_t flags)
+{
+	struct extent *extent = kzalloc(sizeof(*extent), flags);
+
+	if (likely(extent)) {
+		extent->pc = pc;
+		INIT_LIST_HEAD(&extent->lists.hash);
+		INIT_LIST_HEAD(&extent->lists.flush);
+		INIT_LIST_HEAD(&extent->lists.endio);
+		INIT_LIST_HEAD(&extent->lists.free_init);
+		INIT_LIST_HEAD(&extent->lists.ordered);
+		atomic_set(&extent->lists.endio_ref, 0);
+		bio_list_init(&extent->io.in);
+		bio_list_init(&extent->io.endio);
+		spin_lock_init(&extent->io.endio_lock);
+	}
+
+	return extent;
+}
+
+/* Free one extent. */
+static void extent_free(struct extent *extent)
+{
+	BUG_ON(!extent_is_idle(extent));
+	kfree(extent);
+}
+
+/* Check no ios inflight. */
+static int pool_ios_inflight(struct thinp_pool_c *pc)
+{
+	return atomic_read(&pc->io.ref);
+}
+
+/* Check for maximum ios inflight. */
+static int pool_max_ios_inflight(struct thinp_pool_c *pc)
+{
+	return pool_ios_inflight(pc) >= PARALLEL_IO_MAX;
+}
+
+/* Check pool idle. */
+static int pool_idle(struct thinp_pool_c *pc)
+{
+	int r;
+
+	spin_lock_irq(&pc->io.lock);
+	r = bio_list_empty(&pc->io.in);
+	spin_unlock_irq(&pc->io.lock);
+
+	return r && !pool_ios_inflight(pc) && bio_list_empty(&pc->io.work);
+}
+
+/* Check no device ios inflight. */
+static int dev_ios_inflight(struct thinp_dev_c *dc)
+{
+	return atomic_read(&dc->io.ref);
+}
+
+/* Add an element to a list safely. */
+static inline void _extent_add_safe(struct list_head *from,
+				    struct list_head *to)
+{
+	if (list_empty(from))
+		list_add_tail(from, to);
+}
+
+/* Delete an element from a list safely. */
+static inline void _extent_del_safe(struct list_head *list)
+{
+
+	if (!list_empty(list))
+		list_del_init(list);
+}
+
+/* Free a list of pool extent structures listed on the free/init/lru list. */
+static void extents_free_list(struct list_head *list)
+{
+	struct extent *extent;
+	struct list_head *pos, *tmp;
+
+	list_for_each_safe(pos, tmp, list) {
+		list_del(pos);
+		extent = list_entry(pos, struct extent, lists.free_init);
+		_extent_del_safe(&extent->lists.ordered);
+		extent_free(extent);
+	}
+}
+
+/* Factor out to dm.c */
+static int multiple(sector_t a, sector_t b)
+{
+	sector_t r = a;
+
+	do_div(r, b);
+	return a == r * b;
+}
+
+/* Derive hash key from bio sector. */
+static inline sector_t _sector_to_key(struct thinp_pool_c *pc, sector_t sector)
+{
+	return sector & pc->extents.mask;
+}
+
+/* Derive hash key from bio sector. */
+static inline sector_t _bio_to_key(struct thinp_pool_c *pc, struct bio *bio)
+{
+	return _sector_to_key(pc, bio->bi_sector);
+}
+
+/* Derive offset within extent from bio. */
+static inline sector_t _bio_to_extent(struct thinp_pool_c *pc, struct bio *bio)
+{
+	return bio->bi_sector & pc->extents.mask_inv;
+}
+
+/* Return # of free extents. */
+static unsigned extents_free(struct thinp_pool_c *pc)
+{
+	return atomic_read(&pc->extents.free);
+}
+
+/* Return # of initialized extents. */
+static unsigned extents_initialized(struct thinp_pool_c *pc)
+{
+	return atomic_read(&pc->extents.initialized);
+}
+
+/* Return # of total extents. */
+static unsigned extents_total(struct thinp_pool_c *pc)
+{
+	return atomic_read(&pc->extents.total);
+}
+
+/* Remove extent from hash. */
+static void extent_hash_del(struct extent *extent)
+{
+	if (!list_empty(&extent->lists.hash)) {
+		list_del_init(&extent->lists.hash);
+
+		/* REMOVEME: stats. */
+		atomic_dec(&extent->pc->stats.extents_hashed);
+	}
+}
+
+/* Initialize a (device) hash. */
+static int hash_init(struct extent_hash *hash, unsigned extents)
+{
+	unsigned buckets = roundup_pow_of_two(extents) >> 6;
+	static unsigned hash_primes[] = {
+		/* Table of primes for hash_fn optimization. */
+		1, 2, 3, 7, 13, 27, 53, 97, 193, 389, 769,
+		1543, 3079, 6151, 12289, 24593, 49157, 98317,
+	};
+
+	if (!range_ok(buckets, 2, BUCKETS_MAX))
+		buckets = buckets < 2 ? 2 : BUCKETS_MAX;
+
+	/* Allocate stripe hash buckets. */
+	hash->hash = vmalloc(buckets * sizeof(*hash->hash));
+	if (!hash->hash)
+		return -ENOMEM;
+
+	hash->buckets = buckets;
+	hash->mask = buckets - 1;
+	hash->shift = ffs(buckets);
+	if (hash->shift > ARRAY_SIZE(hash_primes) - 1)
+		hash->shift = ARRAY_SIZE(hash_primes) - 1;
+
+	BUG_ON(hash->shift < 2);
+	hash->prime = hash_primes[hash->shift];
+
+	/* Initialize buckets. */
+	while (buckets--)
+		INIT_LIST_HEAD(hash->hash + buckets);
+
+	return 0;
+}
+
+/*
+ * Either count entries in the device hash or depopulate it.
+ */
+enum hash_process_action { HASH_COUNT, HASH_DEPOPULATE };
+static uint64_t hash_process(struct extent_hash *hash,
+			     enum hash_process_action action)
+{
+	uint64_t ret = 0;
+
+	if (hash->hash) {
+		unsigned buckets = hash->buckets;
+		struct list_head *pos, *tmp;
+
+		while (buckets--) {
+			list_for_each_safe(pos, tmp, hash->hash + buckets) {
+				if (action == HASH_DEPOPULATE) {
+					struct extent *extent =
+						list_entry(pos, struct extent,
+							   lists.hash);
+
+					extent->dc = NULL;
+					list_del_init(&extent->lists.hash);
+				} else
+					ret++;
+			}
+		}
+	}
+
+	return ret;
+}
+
+/*
+ * Depopulate a hash.
+ *
+ * Delete extents from hash so that I can cleanly reinsert
+ * them into a new hash on reconstruction of the device.
+ */
+static void hash_depopulate(struct extent_hash *hash)
+{
+	hash_process(hash, HASH_DEPOPULATE);
+}
+
+/* Return number of entries in the hash. */
+static uint64_t hash_entries(struct extent_hash *hash)
+{
+	return hash_process(hash, HASH_COUNT);
+}
+
+/* Free a (device) hash. */
+static void hash_exit(struct extent_hash *hash)
+{
+	if (hash->hash) {
+		vfree(hash->hash);
+		hash->hash = NULL;
+	}
+}
+
+/* Extent hash function. */
+static inline unsigned hash_fn(struct extent_hash *hash, sector_t key)
+{
+	return ((key * hash->prime) >> hash->shift) & hash->mask;
+}
+
+/* Return bucket within hash. */
+static struct list_head *hash_bucket(struct extent_hash *hash, sector_t key)
+{
+	return hash->hash + hash_fn(hash, key);
+}
+
+/* Insert an entry into a hash. */
+static inline void hash_insert(struct extent_hash *hash, struct extent *extent)
+{
+	list_add_tail(&extent->lists.hash,
+		      hash_bucket(hash, extent->addr.dev.key));
+}
+
+/*
+ * Lookup an extent in the hash.
+ *
+ * Need to hold hash lock when calling.
+ */
+static struct extent *hash_lookup(struct extent_dev_hash *dev_hash,
+				  sector_t key)
+{
+	struct list_head *bucket;
+	struct extent *extent;
+
+	BUG_ON(!dev_hash->hash.hash);
+	bucket = hash_bucket(&dev_hash->hash, key);
+
+	list_for_each_entry(extent, bucket, lists.hash) {
+		if (key == extent->addr.dev.key)
+			return extent;
+	}
+
+	return NULL;
+}
+
+/* Wake pool worker. */
+static void wake_do_thinp(struct thinp_pool_c *pc)
+{
+	queue_work(pc->io.wq, &pc->io.ws);
+}
+
+/* Unplug pool: let any queued io role on the pool and/or origin devices. */
+static void unplug_pool(struct thinp_pool_c *pc)
+{
+	if (TestClearPoolIOQueued(pc))
+		blk_unplug(bdev_get_queue(pc->pool.dev->bdev));
+}
+
+/* return # of IO references on extent. */
+static int endio_ref(struct extent *extent)
+{
+	return atomic_read(&extent->lists.endio_ref);
+}
+
+/* Get an IO reference for endio processing. */
+enum io_type { BIO_IO, EXTENT_IO };
+static void endio_get(enum io_type type, struct extent *extent)
+{
+	if (type == BIO_IO)
+		atomic_inc(&extent->dc->io.ref);
+
+	if (atomic_inc_return(&extent->pc->io.ref) >= PARALLEL_IO_MAX)
+		unplug_pool(extent->pc);
+
+	atomic_inc(&extent->lists.endio_ref);
+}
+
+/* Drop an endio reference and return true on zero. */
+static void endio_put(enum io_type type, struct extent *extent)
+{
+	atomic_dec(&extent->lists.endio_ref);
+	
+	/* If this is a bio IO, wake up any waiters on extent going idle. */
+	if (type == BIO_IO &&
+	    atomic_dec_and_test(&extent->dc->io.ref))
+		wake_up(&extent->dc->io.suspendq);
+
+	atomic_dec(&extent->pc->io.ref);
+}
+
+/* Push an extent to the end of the endio list. */
+static void extent_endio_add(struct extent *extent)
+{
+	unsigned long flags;
+	struct thinp_pool_c *pc = extent->pc;
+
+	/* Push to the endio list and flag to wake worker. */
+	spin_lock_irqsave(&pc->lists.lock_endio, flags);
+	_extent_add_safe(&extent->lists.endio, &pc->lists.endio);
+	spin_unlock_irqrestore(&pc->lists.lock_endio, flags);
+}
+
+/* Return data offset of extent. */
+static sector_t extent_data_offset(struct extent *extent)
+{
+	return extent->addr.pool.data_offset;
+}
+
+/* Return metadata offset of extent. */
+static sector_t extent_meta_offset(struct extent *extent)
+{
+	return extent->addr.pool.meta_offset;
+}
+
+/* Transfer core extent representation to disk. */
+static void extent_to_disk(struct extent *extent)
+{
+	struct extent_disk *ed = extent->disk;
+
+	strncpy(ed->magic, extent_magic, sizeof(ed->magic));
+	ed->flags = cpu_to_le64(extent->io.flags);
+	ed->crc = ed->filler = 0;
+	ed->addr.data_offset =
+		cpu_to_le64(to_bytes(extent->addr.pool.data_offset));
+	ed->addr.dev_offset = cpu_to_le64(to_bytes(extent->addr.dev.offset));
+	ed->addr.dev_nr = cpu_to_le64(extent->addr.dev_nr);
+	ed->crc = cpu_to_le32(crc32(~0, ed, sizeof(*ed)));
+}
+
+/* Transfer disk extent representation to core. */
+static void extent_to_core(struct extent *extent)
+{
+	struct extent_disk *ed = extent->disk;
+
+	extent->io.flags = le64_to_cpu(ed->flags);
+	extent->addr.pool.data_offset =
+		to_sector(le64_to_cpu(ed->addr.data_offset));
+	extent->addr.dev.offset = to_sector(le64_to_cpu(ed->addr.dev_offset));
+	extent->addr.dev_nr = le64_to_cpu(ed->addr.dev_nr);
+	ed->crc = le32_to_cpu(ed->crc);
+}
+
+/* Check extent magic. */
+static int extent_check(struct thinp_pool_c *pc,
+			struct extent *extent, sector_t offset)
+{
+	struct extent_disk *ed = extent->disk;
+	unsigned crc = ed->crc;
+
+	ed->crc = 0;
+	/* FIXME: what about extent->addr.dev.number? */
+	if (strncmp(ed->magic, extent_magic, sizeof(ed->magic)) ||
+	    crc != crc32(~0, ed, sizeof(*ed)) ||
+	    ed->filler ||
+	    extent_data_offset(extent) < pc->pool.start ||
+	    extent_data_offset(extent) > pc->pool.size ||
+	    extent_data_offset(extent) != offset)
+		return -EINVAL;
+
+	return 0;
+}
+
+/* Pop an extent off the endio list locked vs. endio routine. */
+static struct extent *extent_endio_pop(struct thinp_pool_c *pc)
+{
+	struct extent *extent;
+
+	spin_lock_irq(&pc->lists.lock_endio);
+	if (list_empty(&pc->lists.endio))
+		extent = NULL;
+	else {
+		extent = list_first_entry(&pc->lists.endio,
+					  struct extent, lists.endio);
+		list_del_init(&extent->lists.endio);
+	}
+
+	spin_unlock_irq(&pc->lists.lock_endio);
+	return extent;
+}
+
+/* Pop an extent off the flush list. */
+static struct extent *extent_flush_pop(struct thinp_pool_c *pc)
+{
+	struct extent *extent;
+
+	if (list_empty(&pc->lists.flush))
+		extent = NULL;
+	else {
+		extent = list_first_entry(&pc->lists.flush,
+					  struct extent, lists.flush);
+		list_del_init(&extent->lists.flush);
+	}
+
+	return extent;
+}
+
+/* Pop an extent off the init list. */
+static struct extent *extent_init_pop(struct thinp_pool_c *pc)
+{
+	struct extent *extent;
+
+	if (list_empty(&pc->lists.init))
+		extent = NULL;
+	else {
+		extent = list_first_entry(&pc->lists.init,
+					  struct extent, lists.free_init);
+		list_del_init(&extent->lists.free_init);
+	}
+
+	return extent;
+}
+
+/* Asynchronuous IO if fn != NULL, else synchronuous. */
+static int io(int rw, struct thinp_pool_c *pc,
+	      void *ptr, enum dm_io_mem_type mtype,
+	      sector_t sector, sector_t count, io_notify_fn fn, void *context)
+{
+	struct dm_io_region region = {
+		.bdev = pc->pool.dev->bdev,
+		.sector = sector,
+		.count = count,
+	};
+	struct dm_io_request control = {
+		.bi_rw = rw,
+		.mem = { .type = mtype, .ptr.addr = ptr },
+		.notify = { .fn = fn, .context = context },
+		.client = pc->io.dm_io_client,
+	};
+
+	SetPoolIOQueued(pc);
+	return dm_io(&control, 1, &region, NULL);
+}
+
+/* Endio function for extent_metadata_io_async(). */
+static void extent_meta_endio(unsigned long error, void *context)
+{
+	struct extent *extent = context;
+
+	/* Clear before adding to endio list. */
+	BUG_ON(!TestClearExtentMetaIo(extent));
+
+	if (unlikely(error))
+		SetExtentError(extent);
+
+	extent_endio_add(extent);
+
+	/* Wakeup worker to deal with endio list. */
+	wake_do_thinp(extent->pc);
+}
+
+/* Asynchronously read/write a pool device extent metadata struct. */
+static int extent_metadata_io_async(int rw, struct extent *extent)
+{
+	int write = !!(rw == WRITE);
+	struct thinp_pool_c *pc = extent->pc;
+
+	/* Removeme: statistics. */
+	atomic_inc(pc->stats.extent_meta_io + write);
+	if (extent->dc)
+		atomic_inc(extent->dc->stats.extent_meta_io + write);
+
+	BUG_ON(TestSetExtentMetaIo(extent));
+
+	/* Write metadata immediately after extent data w/o gap. */
+	endio_get(EXTENT_IO, extent);
+	return io(rw, pc, extent->disk, DM_IO_KMEM,
+		  extent_meta_offset(extent), 1, 
+		  extent_meta_endio, extent);
+}
+
+/* Read/write the pool device header synchronuously. */
+static int header_io_sync(struct thinp_pool_c *pc, int rw)
+{
+	return io(rw, pc, pc->disk, DM_IO_KMEM, pc->pool.start, 1, NULL, NULL);
+}
+
+/* Endio bio adjusting stats. */
+static void _bio_endio(struct thinp_dev_c *dc, struct bio *bio, int error)
+{
+	int write = !!(bio_data_dir(bio) == WRITE);
+
+	/* Emit dm table event on first device error. */
+	if (error && !TestSetDevError(dc))
+		dm_table_event(dc->ti->table);
+
+	/* REMOVEME: stats. */
+	atomic_inc(dc->stats.bios_endiod + write);
+	atomic_inc(dc->pc->stats.bios_endiod + write);
+
+	bio_endio(bio, error);
+}
+
+/* Endio function for dm_io_bio_submit(). */
+static void bio_submit_callback(unsigned long error, void *context)
+{
+	struct bio *bio = context;
+	struct extent *extent = (struct extent *) bio->bi_bdev;
+	struct thinp_dev_c *dc;
+
+	BUG_ON(!extent);
+	dc = extent->dc;
+	BUG_ON(!dc);
+
+	/* We've got a bio IO error and flag that on the extent. */
+	if (unlikely(error)) {
+		SetExtentError(extent);
+		atomic_inc(&extent->pc->io.errors);
+	}
+
+	/*
+	 * If the metadata is still being written, endio
+	 * on bios needs to be postponed until finished.
+	 *
+	 * Else we can endio here immediately avoiding a
+	 * worker run for bio endio processing.
+	 */
+	if (ExtentMetaIo(extent)) {
+		unsigned long flags;
+
+		/*
+		 * Need a spinlock here, because endios can
+		 * be processed in parallel with my worker.
+		 */
+		spin_lock_irqsave(&extent->io.endio_lock, flags);
+		bio_list_add(&extent->io.endio, bio);
+		spin_unlock_irqrestore(&extent->io.endio_lock, flags);
+
+		/* REMOVEME: stats. */
+		atomic_inc(&dc->stats.bios_requeued);
+
+		/* Wakeup worker to deal with endio list. */
+		extent_endio_add(extent);
+	} else {
+		_bio_endio(dc, bio, error);
+		endio_put(BIO_IO, extent); /* Drop the reference. */
+	}
+
+	wake_do_thinp(extent->pc);
+}
+
+/* Asynchronously submit a bio. */
+static int dm_io_bio_submit(struct extent *extent, struct bio *bio)
+{
+	int write = !!(bio_data_dir(bio) == WRITE);
+	struct thinp_pool_c *pc = extent->pc;
+
+	BUG_ON(!pc);
+
+	/* REMOVEME: stats. */
+	atomic_inc(pc->stats.submitted_io + write);
+	atomic_inc(extent->dc->stats.submitted_io + write);
+
+	/*
+	 * I can squirrel the extent to the callback in bio->bi_dev,
+	 * because dm_io() allocates new bios for the io anyway.
+	 */
+	bio->bi_bdev = (struct block_device *) extent;
+	bio->bi_sector = extent_data_offset(extent) + _bio_to_extent(pc, bio);
+	endio_get(BIO_IO, extent);
+	return io(bio_data_dir(bio), pc,
+		  bio->bi_io_vec + bio->bi_idx, DM_IO_BVEC,
+		  bio->bi_sector, bio_sectors(bio),
+		  bio_submit_callback, bio);
+}
+
+
+/* Transfer pool device header from/to CPU. */
+static void header_to_disk(struct thinp_pool_c *pc)
+{
+	struct disk_pool_header *dh = pc->disk;
+
+	dh->crc = 0;
+	dh->crc = cpu_to_le32(crc32(~0, dh, sizeof(*dh)));
+	dh->size.dev = cpu_to_le64(to_bytes(dh->size.dev));
+	dh->size.dev_initialized =
+		cpu_to_le64(to_bytes(dh->size.dev_initialized));
+	dh->size.extent = cpu_to_le64(to_bytes(dh->size.extent));
+	dh->size.extents_per_chunk = cpu_to_le64(dh->size.extents_per_chunk);
+	dh->flags = cpu_to_le64(dh->flags);
+}
+
+static void header_to_core(struct thinp_pool_c *pc)
+{
+	struct disk_pool_header *dh = pc->disk;
+
+	dh->crc = le32_to_cpu(dh->crc);
+	dh->size.dev = to_sector(le64_to_cpu(dh->size.dev));
+	dh->size.dev_initialized =
+		to_sector(le64_to_cpu(dh->size.dev_initialized));
+	dh->size.extent = to_sector(le64_to_cpu(dh->size.extent));
+	dh->size.extents_per_chunk = le64_to_cpu(dh->size.extents_per_chunk);
+	dh->flags = cpu_to_le64(dh->flags);
+}
+
+/* Initialize disk header version. */
+static void header_version_init(struct disk_pool_header *dh)
+{
+	dh->version.major = 1;
+	dh->version.minor = 0;
+	dh->version.subminor = 0;
+	dh->version.filler = 0;
+}
+
+/* Initialize pool device header */
+static void header_init(struct thinp_pool_c *pc)
+{
+	struct disk_pool_header *dh = pc->disk;
+
+	strncpy(dh->magic, header_magic, sizeof(dh->magic));
+	header_version_init(dh);
+	dh->size.dev = pc->pool.size;
+	dh->size.dev_initialized = pc->pool.initialized;
+	dh->size.extent = extent_data_size(pc);
+	dh->size.extents_per_chunk = pc->extents.per_chunk;
+
+	/* Mask out any transient flags. */
+	dh->flags = pc->io.flags; // xXx no flags so far. */
+}
+
+/* Check that disk header version's right. */
+static int header_version_check(struct disk_pool_header *dh)
+{
+	return dh->version.major == 1 &&
+	       !dh->version.minor &&
+	       !dh->version.subminor &&
+	       !dh->version.filler;
+}
+
+/* Write new pool device header. */
+static int header_write(struct thinp_pool_c *pc)
+{
+	int r;
+
+	pc->disk = metadata_zalloc(pc);
+	BUG_ON(!pc->disk);
+	header_init(pc);
+	header_to_disk(pc);
+	r = header_io_sync(pc, WRITE);
+	metadata_free(pc, (void **) &pc->disk);
+	
+	/* Fatal pool write error. */
+	if (r) {
+		DMERR("Fatal pool header write error");
+		atomic_inc(&pc->io.errors);
+
+		/* Emit dm table event on first pool error. */
+		if (!TestSetPoolDead(pc))
+			dm_table_event(pc->ti->table);
+	}
+
+	return r;
+}
+
+/* Check pool device header validity. */
+static int header_check(struct thinp_pool_c *pc)
+{
+	int r, hm;
+	struct disk_pool_header *dh = pc->disk;
+	unsigned crc = dh->crc;
+
+	dh->crc = 0;
+	hm = strncmp(dh->magic, header_magic, sizeof(dh->magic));
+	r = hm || !header_version_check(dh) ||
+	    crc != crc32(~0, dh, sizeof(*dh)) ||
+	    !dh->size.dev || !dh->size.dev_initialized || !dh->size.extent ?
+	    -EINVAL : 0;
+
+	return (r && !hm) ? -EPERM : r;
+}
+
+/* Add to free list sorted by ascending disk address. */
+static void extent_free_add_sorted(struct thinp_pool_c *pc,
+				   struct extent *extent)
+{
+	struct extent *e;
+	struct list_head *insert = &pc->lists.free;
+
+	list_for_each_entry(e, &pc->lists.free, lists.free_init) {
+		if (extent_data_offset(extent) < extent_data_offset(e))
+			insert = &e->lists.free_init;
+		else
+			break;
+	}
+
+	list_add(&extent->lists.free_init, insert);
+}
+
+/* Add extent to end of free/init list. */
+static void extent_free_init_add(struct extent *extent)
+{
+	struct thinp_pool_c *pc = extent->pc;
+
+	if (list_empty(&extent->lists.free_init)) {
+		BUG_ON(!extent_is_idle(extent));
+
+		if (ExtentFree(extent)) {
+			extent_free_add_sorted(pc, extent);
+			atomic_inc(&pc->extents.free);
+		} else if (ExtentInit(extent)) {
+			if (ExtentDropped(extent))
+				list_add(&extent->lists.free_init,
+					 &pc->lists.init);
+			else
+				list_add_tail(&extent->lists.free_init,
+					      &pc->lists.init);
+		} else
+			BUG();
+
+	}
+}
+
+/* Remove extent from free/init list. */
+static void extent_free_init_del(struct thinp_pool_c *pc,
+				 struct extent *extent)
+{
+	if (!list_empty(&extent->lists.free_init)) {
+		list_del_init(&extent->lists.free_init);
+
+		if (ExtentFree(extent))
+			atomic_dec(&pc->extents.free);
+	}
+}
+
+/*
+ * Pop an extent off the free list triggering
+ * any new metadata header writes.
+ */
+struct extent *extent_free_pop(struct thinp_pool_c *pc)
+{
+	unsigned free;
+	struct extent *extent;
+
+	/* None while active. */
+	if (PoolInitializationActive(pc))
+		return NULL;
+
+	free = extents_free(pc);
+	if (!free) {
+		/* If we're not done with initializing the whole pool... */
+		if (!PoolInitialized(pc)) {
+			/*
+			 * Need to write more free metadata extents
+			 * first in order to grow the free list.
+			 */
+			if (PoolInitializeNew(pc))
+				SetPoolDoInitialize(pc);
+		} 
+
+		return NULL;
+	}
+
+	/* Fetch one extent from proper list. */
+	extent = list_first_entry(&pc->lists.free,
+				  struct extent, lists.free_init);
+	extent_free_init_del(pc, extent);
+	BUG_ON(!extent_is_idle(extent));
+	return extent;
+}
+
+/* Add extent to end of flush list. */
+static void extent_flush_add(struct extent *extent)
+{
+	_extent_add_safe(&extent->lists.flush, &extent->pc->lists.flush);
+}
+
+/* Insert an entry into the extent hash, deleting it before if in. */
+static void extent_hash_insert(struct extent *extent,
+			       struct extent_dev_hash *dev_hash)
+{
+	BUG_ON(!list_empty(&extent->lists.hash));
+	hash_insert(&dev_hash->hash, extent);/* Hash the extent. */
+
+	/* REMOVEME: stats. */
+	atomic_inc(&extent->pc->stats.extents_hashed);
+	atomic_inc(&extent->dc->stats.extents_hashed);
+}
+
+/*
+ * If extent still is in devices address space add to hash.
+ *
+ * If not so, set extent to free and put on init list to
+ * initialize on disk setting flags accordingly.
+ */
+static void extent_hash_or_init_add(struct extent *extent)
+{
+	struct thinp_dev_c *dc = extent->dc;
+	struct thinp_pool_c *pc = extent->pc;
+
+	BUG_ON(!pc);
+
+	if (dc) {
+		if (extent->addr.dev.offset < dc->ti->len) {
+			extent_hash_insert(extent, &dc->dev_hash);
+			return;
+		} else  {
+			extent_hash_del(extent);
+			SetExtentDropped(extent);
+		}
+	}
+
+	ClearExtentFree(extent);
+	SetExtentInit(extent);
+
+	extent_free_init_add(extent);
+
+	ClearPoolInitialized(pc);
+	SetPoolInitializeNew(pc);
+	SetPoolDoInitialize(pc);
+}
+
+/* Try to get an extent either from the hash or off the free list. */
+static struct extent *extent_get(struct thinp_dev_c *dc, struct bio *bio)
+{
+	/* Key is relative (0 based) start address of extent on device. */
+	struct thinp_pool_c *pc = dc->pc;
+	sector_t key = _bio_to_key(pc, bio);
+	struct extent *extent;
+
+	/* Try to look extent up in the hash. */
+	mutex_lock(&dc->dev_hash.lock);
+	extent = hash_lookup(&dc->dev_hash, key);
+	mutex_unlock(&dc->dev_hash.lock);
+
+	/* Found extent in hash -> return it. */
+	if (extent)
+		goto out;
+
+	/*
+	 * If it's not in the hash while we're
+	 * still reading the pool metadata ->
+	 * wait until all extents have been read.
+	 */
+	if (!PoolInitialized(pc) && !PoolInitializeNew(pc))
+		goto out;
+
+	/* If it's not in the hash and a read -> fail */
+	if (bio_data_dir(bio) == READ)
+		goto out;
+
+	/* Try to fetch an extent off the free list. */
+	extent = extent_free_pop(pc);
+	if (extent) {
+		BUG_ON(!ExtentFree(extent));
+
+		/* Reset state, adjust key and insert into hash. */ 
+		extent->io.flags = 0;
+		extent->dc = dc;
+		SetExtentInit(extent);	/* Flag do_flush() metadata write. */
+		extent->addr.dev.key = key; /* key == offset */
+		extent->addr.dev_nr = dc->params.dev_nr;
+
+		/* Count as allocated. */
+		atomic_inc(&pc->extents.allocated);
+
+		mutex_lock(&dc->dev_hash.lock);
+		extent_hash_insert(extent, &dc->dev_hash);
+		mutex_unlock(&dc->dev_hash.lock);
+	}
+
+out:
+	return extent;
+}
+
+/* Return data and metadata offsets in sectors for a given extent number. */
+static void extent_address(struct thinp_pool_c *pc, uint64_t extent_nr,
+			   struct pool_address *addr)
+{
+	sector_t chunk_nr = extent_nr,
+		 rest = do_div(chunk_nr, pc->extents.per_chunk);
+
+	addr->data_offset = addr->meta_offset =
+		extents_start(pc) +
+		chunk_nr * pc->extents.per_chunk * extent_total_size(pc);
+	addr->data_offset += pc->extents.per_chunk * META_SECTORS +
+			     rest * extent_data_size(pc);
+	addr->meta_offset += rest * META_SECTORS;
+}
+
+/* Calculate how many extents fit into the pool backing store. */
+static sector_t extents_fit_pool(struct thinp_pool_c *pc, sector_t size)
+{
+	sector_t extents = size, rest, size_for_chunks, tmp;
+
+	do_div(extents, extent_total_size(pc));
+	tmp = extents;
+	rest = do_div(tmp, pc->extents.per_chunk);
+	size_for_chunks = tmp * pc->extents.per_chunk * extent_total_size(pc);
+	return (size - size_for_chunks < pc->extents.per_chunk * META_SECTORS +
+					 rest * extent_data_size(pc)) ?
+	       extents - rest : extents;
+}
+
+/* Initialize pool extent structures in memory and add them to init list. */
+static int pool_extents_alloc(struct thinp_pool_c *pc, 
+			      uint64_t start_nr, unsigned count,
+			      struct list_head *list, gfp_t flags)
+{
+	unsigned e;
+	struct extent *extent;
+
+	for (e = 0; e < count; e++) {
+		extent = extent_alloc(pc, flags);
+		if (!extent)
+			return -ENOMEM;
+
+		extent->nr = start_nr++;
+		extent_address(pc, extent->nr, &extent->addr.pool);
+		SetExtentFree(extent);
+		SetExtentInit(extent);
+
+		/* All extents to end of list for caller processing. */
+		_extent_add_safe(&extent->lists.ordered, list);
+	}
+
+	return 0;
+}
+
+/* Read @sector off @dev and return @sector if readable, else 0. */
+static sector_t check_dev_access(struct thinp_pool_c *pc, sector_t sector)
+{
+	int r;
+	void *ptr = metadata_zalloc(pc);
+
+	BUG_ON(!ptr);
+	r = io(READ, pc, ptr, DM_IO_KMEM, sector - 1, 1, NULL, NULL);
+	metadata_free(pc, &ptr);
+	return r ? 0 : sector;
+}
+
+/*
+ * Resize pool device.
+ *
+ * Checks address orderered list of extents backwards
+ * on free or just adds to init list on grow.
+ *
+ * Done in 3 steps outlined below.
+ */
+static int pool_resize(struct thinp_pool_c *pc)
+{
+	int grow, r;
+	unsigned count, todo;
+	sector_t pool_size = pc->params.pool_new_size,
+		 pool_size_old, extents, extents_old;
+	struct c_dev *pool = &pc->pool;
+	struct extent *extent, *tmp;
+	struct list_head list;
+
+	INIT_LIST_HEAD(&list);
+
+	if (pool_size < extents_start(pc))
+		return 0;
+
+	/* Check pool device limits. */
+	if (pool_size != check_dev_access(pc, pool_size))
+		DM_ERR("pool device size %llu too small", (LLU) pool_size);
+
+	/* Calculate absolute number of extents fitting pool device size. */
+	extents = extents_fit_pool(pc, pool_size);
+	if (extents < EXTENTS_MIN)
+		DM_ERR("pool size requested is smaller than minimum %llu",
+		       (LLU) extents_start(pc) +
+			     EXTENTS_MIN * extent_total_size(pc));
+
+	extents_old = extents_total(pc);
+	if (extents == extents_old)
+		DM_ERR("pool size wouldn't change");
+
+	/* Save given pool size for potential restore. */
+	pool_size_old = pool->size;
+
+	/*
+ 	 * Step 1: Either allocate new extents on grow or
+ 	 *	   pull any idle extents out of the work lists
+ 	 *	   (init/free lists that is)
+	 */
+	grow = extents > extents_old;
+	if (grow) {
+		/*
+		 * Grow: try allocating additional extent structures;
+	 	 *	 initially add to a private list so that we can bail
+		 *	 out smoothly in case the header update should fail.
+		 */
+		uint64_t nr = list_entry(pc->lists.ordered.prev,
+					 struct extent, lists.ordered)->nr;
+
+		count = todo = extents - extents_old;
+		r = pool_extents_alloc(pc, nr, count, &list, GFP_NOIO);
+		if (r) {
+			DMERR("can't allocate requested %u extents for %s",
+			      count, pool->dev->name);
+			goto err_free;
+		}
+
+		todo = 0;
+		pool->size += count * extent_total_size(pc);
+	} else {
+		/*
+		 * Shrink: move extents to be freed off the free/init lists.
+		 *	   Again to a private list first to be
+		 *	   able to stand a header write failure.
+		 */
+		todo = count = extents_old - extents;
+		while (todo) {
+			/*
+			 * Check ordered list from
+			 * the end for free extents.
+			 */
+			extent = list_entry(pc->lists.ordered.prev,
+					    struct extent, lists.ordered);
+			if (ExtentFree(extent)) {
+				BUG_ON(!list_empty(&extent->lists.flush));
+				BUG_ON(!list_empty(&extent->lists.endio));
+
+				/* Move from ordered to private list. */
+				list_move(&extent->lists.ordered, &list);
+				todo--;
+			} else
+				break;
+		}
+
+		if (todo == count)
+			goto out;
+
+		if (count - todo)
+			DMWARN_LIMIT("Freeing %u extents of requested %u.",
+				     count - todo, count);
+
+		pool->size -= (count - todo) * extent_total_size(pc);
+	}
+
+	/*
+ 	 * Step 2: Write header
+	 *
+	 * Update disk header with new pool size.
+	 */
+	r = header_write(pc);
+	if (r) {
+		if (grow)
+			goto err_free;
+
+		/*
+		 * Work any extents to free back
+		 * onto the pool's ordered list.
+		 */
+		list_for_each_entry_safe(extent, tmp, &list,
+					 lists.ordered)
+			list_move_tail(&extent->lists.ordered,
+				      &pc->lists.ordered);
+
+		goto err;
+	}
+
+	/*
+ 	 * Step 3: if growing, work private extent list into init list
+ 	 *	   and tell worker to start extent initialization again.
+ 	 * 	   If shrinking, free extents on private lirt.
+	 */
+	if (grow) {
+		/* Move/add new extents to init and ordered list. */
+		list_for_each_entry_safe(extent, tmp, &list,
+					 lists.ordered) {
+			list_move_tail(&extent->lists.ordered,
+				       &pc->lists.ordered);
+			list_add_tail(&extent->lists.free_init,
+				      &pc->lists.init);
+			atomic_inc(&pc->extents.total);
+		}
+
+		/* Tell worker that there's new extents to initialize. */
+		ClearPoolInitialized(pc);
+		SetPoolInitializeNew(pc);
+	} else {
+	 	/*
+		 * Free any extents we shrunk the pool by pulling
+		 * them out of work list adjusting counters.
+		 */
+		list_for_each_entry_safe(extent, tmp, &list,
+					 lists.ordered) {
+			list_del(&extent->lists.ordered);
+
+			/*
+			 * Pull out of hash and free/init
+			 * lists adjusting counters.
+			 */
+			extent_hash_del(extent);
+			extent_free_init_del(pc, extent);
+
+			if (!ExtentInit(extent))
+				atomic_dec(&pc->extents.initialized);
+
+			atomic_dec(&pc->extents.total);
+			extent_free(extent);
+		}
+	}
+
+	DMINFO("%s pool on %s to %llu sectors",
+	       grow ? "Grown" : "Shrunk", pool->dev->name, (LLU) pool->size);
+	wake_do_thinp(pc);
+out:
+	return todo ? 1 : 0;
+
+err_free:
+	/* Free any allocated extents before the allocation failure. */
+	extents_free_list(&list);
+	pool->size = pool_size_old;
+err:
+	return -EINVAL;
+}
+
+/* Process bios on an extents input queue. */
+static void bios_io(struct extent *extent)
+{
+	struct bio *bio;
+	struct bio_list *bios = &extent->io.in;
+
+	BUG_ON(bio_list_empty(bios));
+
+	/*
+	 * Remap all queued bios, take out an endio
+	 * reference per bio and submit them.
+	 */
+	while ((bio = bio_list_pop(bios)))
+		BUG_ON(dm_io_bio_submit(extent, bio));
+}
+
+/*
+ * Get pool context from global list for match by
+ * control device taking out reference if found.
+ *
+ * Must be called with lock hold.
+ */
+static struct thinp_pool_c *pc_get_by_dev(dev_t dev)
+{
+	struct thinp_pool_c *pc;
+
+	list_for_each_entry(pc, &pool_contexts_list, lists.context) {
+		if (pc->ctrl_dev == dev) {
+			atomic_inc(&pc->ref);
+			return pc;
+		}
+	}
+
+	return NULL;
+}
+
+/* Drop reference on pool context. */
+static void pc_put(struct thinp_pool_c *pc)
+{
+	atomic_dec(&pc->ref);
+}
+
+/* Get extent_dev_hash from pool contexts global list by device number. */
+static struct extent_dev_hash *
+extent_dev_hash_get_by_devnr(struct thinp_pool_c *pc, uint64_t dev_nr)
+{
+	struct extent_dev_hash *dev_hash;
+
+	list_for_each_entry(dev_hash, &pc->lists.dev_hashs, list) {
+		struct thinp_dev_c *dc =
+			container_of(dev_hash, struct thinp_dev_c, dev_hash);
+
+		if (dc->params.dev_nr == dev_nr)
+			return dev_hash;
+	}
+
+	return NULL;
+}
+
+static void extent_validate_read(struct thinp_pool_c *pc, struct extent *extent)
+{
+	/* If used; ie. device number > 0. */
+	if (extent->addr.dev_nr) {
+		struct extent_dev_hash *dev_hash;
+
+		/* Count as allocated. */
+		atomic_inc(&pc->extents.allocated);
+
+		/* See if hash has been created yet. */
+		mutex_lock(&pc->lists.dev_hashs_lock);
+		dev_hash = extent_dev_hash_get_by_devnr(pc,
+							extent->addr.dev_nr);
+		/*
+		 * Insert used extent into hash unless
+		 * not in devices address space any more.
+		 */
+		if (dev_hash) {
+			mutex_lock(&dev_hash->lock);
+			/* If extent not hashed yet by hash_populate(). */
+			if (!hash_lookup(dev_hash, extent->addr.dev.key)) {
+				extent->dc = container_of(dev_hash,
+							  struct thinp_dev_c,
+							  dev_hash);
+				extent_hash_or_init_add(extent);
+			}
+
+			mutex_unlock(&dev_hash->lock);
+		}
+
+		mutex_unlock(&pc->lists.dev_hashs_lock);
+	}
+}
+
+/* Validate extents on pool initialization. */
+static void extent_validate(struct extent *extent)
+{
+	struct thinp_pool_c *pc = extent->pc;
+
+	BUG_ON(!pc);
+	BUG_ON(!PoolDoInitialize(pc));
+	BUG_ON(!TestClearExtentInit(extent));
+
+	if (ExtentError(extent))
+		DMERR_LIMIT("extent=%llu metadata IO error",
+			    (LLU) extent_data_offset(extent));
+
+	/* Extent is free (either new or read) -> put on free list. */
+	if (ExtentFree(extent)) {
+		/* Add to free list. */
+		BUG_ON(!list_empty(&extent->lists.free_init));
+		extent_free_init_add(extent);
+	/*
+	 * Metadata read -> insert into hash if device hash exists,
+	 * so that hash hits for bios can start to happen in
+	 * thinp_dev_map() and do_bios()->extent_get() unless
+	 * extent is outside devices current address space.
+	 */
+	} else if (ExtentMetaRead(extent))
+		extent_validate_read(pc, extent);
+
+	ClearExtentMetaRead(extent);
+
+	/* Count as initialized. */
+	atomic_inc(&pc->extents.initialized);
+
+	/* Reset pool initialization active after max init extents. */
+	if (atomic_dec_and_test(&pc->extents.init_max)) {
+		/* End offset of last initialized extent. */
+		sector_t offset = extents_initialized(pc) *
+				  extent_total_size(pc) + extents_start(pc);
+
+		/*
+		 * Stop writing extents after init_max metadata
+		 * writes and update pool header initialization offset.
+		 */
+		if (PoolInitializeNew(pc)) {
+			pc->pool.initialized = offset;
+
+			if (!ExtentDropped(extent))
+				ClearPoolDoInitialize(pc);
+
+			header_write(pc);
+		/* If reading and finished -> switch to writing. */
+		} else if (offset >= pc->pool.initialized) {
+			SetPoolInitializeNew(pc);
+			ClearPoolDoInitialize(pc);
+		}
+
+		ClearPoolInitializationActive(pc);
+	}
+
+	/* Reduce allocated count after metadata update on disk. */
+	if (TestClearExtentDropped(extent))
+		atomic_dec(&pc->extents.allocated);
+
+	/* All extents done. */
+	if (extents_initialized(pc) == extents_total(pc)) {
+		/* Flag done with extents initialization. */
+		SetPoolInitialized(pc);
+		ClearPoolDoInitialize(pc);
+		ClearPoolInitializeNew(pc);
+		DMINFO("completely initialized %s, %u total/%u "
+		       "free thinp pool extents",
+				pc->pool.dev->name,
+				extents_total(pc), extents_free(pc));
+	}
+}
+
+/* Pop a bio safely off the endio list. */
+static struct bio *_bio_list_pop_safe(struct extent *extent,
+				      struct bio_list *endio_list)
+{
+	struct bio *bio;
+
+	spin_lock_irq(&extent->io.endio_lock);
+	bio = bio_list_pop(endio_list);
+	spin_unlock_irq(&extent->io.endio_lock);
+
+	return bio;
+}
+
+/* bio_endio() an extents endio write bio_list. */
+static void extent_endio_bio_list(struct extent *extent)
+{
+	int error = ExtentError(extent) ? -EIO : 0;
+	struct bio *bio;
+
+	BUG_ON(ExtentMetaIo(extent));
+
+	while ((bio = _bio_list_pop_safe(extent, &extent->io.endio))) {
+		_bio_endio(extent->dc, bio, error);
+		endio_put(BIO_IO, extent);
+	}
+}
+
+/* Handle any settings changes. */
+static void do_settings(struct thinp_pool_c *pc)
+{
+	if (TestClearPoolChangePolicyError(pc)) {
+		if (PoolPolicyError(pc))
+			ClearPoolPolicyError(pc);
+		else
+			SetPoolPolicyError(pc);
+	}
+}
+
+/* Handle all endios on extents. */
+static void do_endios(struct thinp_pool_c *pc)
+{
+	struct extent *extent;
+
+	while ((extent = extent_endio_pop(pc))) {
+		/* Can't go further with active metadata io. */
+		if (ExtentMetaIo(extent))
+			continue;
+
+		if (ExtentError(extent))
+			atomic_inc(&pc->io.errors);
+
+		if (extent->disk) {
+			endio_put(EXTENT_IO, extent);
+
+			/* Transfer metadata to CPU on read. */
+			if (unlikely(ExtentMetaRead(extent))) {
+				int error = ExtentError(extent), r;
+				uint64_t nr = extent->nr;
+				sector_t data_offset =
+					extent_data_offset(extent);
+				sector_t meta_offset =
+					extent_meta_offset(extent);
+
+				BUG_ON(!ExtentFree(extent));
+				BUG_ON(!ExtentInit(extent));
+
+				/*
+				 * Need to set flags again, because they're
+				 * transient and got overwritten from disk.
+				 */
+				extent_to_core(extent);
+				r = extent_check(pc, extent, data_offset);
+				if (r || error) {
+					/* Restore in case of error. */
+					extent->nr = nr;
+					extent->addr.pool.data_offset =
+						data_offset;
+					extent->addr.pool.meta_offset =
+						meta_offset;
+	
+					/* Init bogus members. */
+					extent->addr.dev.offset = 0;
+					extent->addr.dev_nr = 0; /* Invalid # */
+					extent->io.flags = 0;
+
+					if (error)
+						SetExtentError(extent);
+				}
+
+				/*
+				 * Set flag again after read+check,
+				 * bacause it's been overwritten.
+				 */
+				SetExtentMetaRead(extent);
+				SetExtentInit(extent);
+			}
+
+			/* Free disk header structure. */
+			metadata_free(pc, (void **) &extent->disk);
+
+			if (unlikely(ExtentInit(extent))) {
+				/* Validate the extent. */
+				extent_validate(extent);
+				continue;
+			}
+		}
+
+		/* End IO *after* the metadata got updated. */
+		extent_endio_bio_list(extent);
+
+		if (extent_has_bios_queued(extent))
+			/* There's bios pending -> put on flush list. */
+			extent_flush_add(extent);
+	}
+}
+
+/*
+ * Initialize extent metadata by either reading off the backing
+ * store in case of existing metadata or writing to it in case
+ * of a pool initialization or writing of init extents.
+ */
+static void do_extents_init(struct thinp_pool_c *pc)
+{
+	if (!PoolDoInitialize(pc) ||
+	    PoolInitializationActive(pc))
+		return;
+	else {
+		int i = 0, max, rw;
+		struct extent *extent;
+
+		if (PoolInitializeNew(pc))
+			max = PARALLEL_INIT_WRITE_MAX, rw = WRITE;
+		else
+			max = PARALLEL_INIT_READ_MAX, rw = READ;
+
+		/* Count extents on init list. */
+		list_for_each_entry(extent, &pc->lists.init, lists.free_init) {
+			BUG_ON(!ExtentInit(extent));
+
+			if (++i == max)
+				break;
+
+			/* On read, stop at last initialized extent. */
+			if (!PoolInitializeNew(pc) &&
+			    extent_data_offset(extent) >= pc->pool.initialized)
+				break;
+		}
+
+		/* Set expected calls for extent_validate(). */
+		atomic_set(&pc->extents.init_max, i);
+
+		while (i && (extent = extent_init_pop(pc))) {
+			extent->disk = metadata_zalloc(pc);
+			BUG_ON(!extent->disk);
+
+			if (rw == WRITE) {
+				ClearExtentMetaRead(extent);
+				extent_to_disk(extent);
+			} else
+				SetExtentMetaRead(extent);
+
+			/* Flag pool is actively initializing. */
+			SetPoolInitializationActive(pc);
+			/* Take endio reference out and initiate IO. */
+			BUG_ON(extent_metadata_io_async(rw, extent));
+			i--;
+		}
+
+		BUG_ON(i);
+	}
+}
+
+/* Resize pool on ctr argument request. */
+static void do_resize(struct thinp_pool_c *pc)
+{
+	if (!PoolDoInitialize(pc) && TestClearPoolResize(pc)) {
+		int r = pool_resize(pc);
+
+		/* Need to shrink more because too few where free. */
+		if (r > 0)
+			SetPoolResize(pc);
+		else
+			/* Done with resizing. */
+			pc->params.pool_new_size = 0;
+	}
+}
+
+/* Process list of bios trying to get extents form free list. */
+/*
+ * Handle all incoming/deferred bios.
+ *
+ * The following extent states are handled here:
+ *   o can't get extent from hash or free list ->
+ *     put bio off for later processing.
+ *   o else add bio to the extents input list and add extent to pool flush list.
+ */
+static void do_bios(struct thinp_pool_c *pc)
+{
+	struct bio *bio;
+	struct bio_list *bios = &pc->io.work;
+	struct extent *extent;
+	struct thinp_dev_c *dc;
+
+	/* In case of free extents, nerge any bios waiting into work list. */
+	if (extents_free(pc))
+		bio_list_merge_head(bios, &pc->io.wait);
+
+	/* Quickly add any new bios queued to the end of the work list. */
+	if (TestClearPoolNewBiosQueued(pc)) {
+		spin_lock_irq(&pc->io.lock);
+		bio_list_merge(bios, &pc->io.in);
+		bio_list_init(&pc->io.in);
+		spin_unlock_irq(&pc->io.lock);
+	}
+
+	/* Work all deferred or new bios on work list. */
+	while ((bio = bio_list_pop(bios))) {
+		int write;
+
+		/* Fail early on fatal pool error (ie. corrupt header). */
+		if (unlikely(PoolDead(pc))) {
+error:
+			_bio_endio(dc, bio, -EIO);
+			continue;
+		}
+		
+		write = !!(bio_data_dir(bio) == WRITE);
+
+		/* Retrieve squirreled device reference. */
+		dc = (struct thinp_dev_c *) bio->bi_bdev;
+		extent = extent_get(dc, bio);
+		if (extent) {
+			/* REMOVEME: stats */
+			atomic_inc(pc->stats.hits + write);
+	
+			/* If extent is errored, error bio here. */
+			if (unlikely(ExtentError(extent)))
+				goto error;
+			else {
+				/*
+				 * Put bio on extents input queue
+				 * and extent on flush list,
+				 */
+				bio_list_add(&extent->io.in, bio);
+				extent_flush_add(extent);
+			}
+		/*
+		 * If I can't get one -> put IO off
+		 * or error depending on policy.
+		 */
+		} else {
+			/* REMOVEME: stats */
+			atomic_inc(pc->stats.misses + write);
+
+			/*
+			 * Pool initialized and no free extents ->
+			 * need to grow pool.
+			 */
+			if (PoolInitialized(pc)) {
+				if (extents_free(pc) < extents_total(pc) / 10)
+					dm_table_event(pc->ti->table);
+
+				if (!extents_free(pc)) {
+					DMWARN_LIMIT("thinp pool full");
+
+					if (!write) {
+endio:
+						zero_fill_bio(bio);
+						_bio_endio(dc, bio, 0);
+						continue;
+					}
+
+					/* 
+					 * Error bio / postpone
+					 * depending on policy.
+					 */
+					if (PoolPolicyError(pc))
+						goto error;
+					else
+						bio_list_add(&pc->io.wait, bio);
+				}
+
+			/* Pool initializing and a read -> endio. */
+			} else if (PoolInitializeNew(pc) && !write)
+				goto  endio;
+
+			/* Wait for new extents to become acailable. */
+			else {
+				bio_list_add_head(bios, bio);
+				break;
+			}
+		}
+	}
+}
+
+/*
+ * Walk the list of extents on flush list and write new
+ * metadata headers out before allowing the to get through.
+ *
+ */
+static void do_flush(struct thinp_pool_c *pc)
+{
+	struct extent *extent;
+
+	/* No extents on flush list. */
+	if (list_empty(&pc->lists.flush))
+		return;
+
+	/* Work all extents on flush list. */
+	while (!pool_max_ios_inflight(pc) &&
+	       (extent = extent_flush_pop(pc))) {
+		/* Extent flagged init -> metadata needs to be updated. */
+		if (TestClearExtentInit(extent)) {
+			extent->disk = metadata_zalloc(pc);
+			BUG_ON(!extent->disk);
+			extent_to_disk(extent);
+			BUG_ON(extent_metadata_io_async(WRITE, extent));
+		}
+
+		/*
+		 * Submit any bios hanging off this extents
+		 * input queue but don't endio them until
+		 * after the metadata got updated on disk.
+		 */
+		bios_io(extent);
+	}
+}
+
+/* Wake up any waiters in case we're idle. */
+static void do_wake(struct thinp_pool_c *pc)
+{
+	/* Wake up any suspend waiter. */
+	if (pool_idle(pc))
+		wake_up(&pc->io.suspendq);
+}
+
+/*
+ * Thin provisioning worker thread.
+ *
+ * o handle all outstanding endios on extents
+ * o resize provisioning pool if requested by constructor/message interface
+ * o work on all new queued and any postponed bios
+ *   putting them on extents bio queue
+ * o initialize any uninitialized extents metadata
+ *   (read preallocated in or write free (new) ones)
+ * o flush to recognize any bios and extent metadata io
+ *   requests and unplug pool device request queues
+ * o wake any suspend waiters if idle
+ */
+static void do_thinp(struct work_struct *ws)
+{
+	struct thinp_pool_c *pc = container_of(ws, struct thinp_pool_c, io.ws);
+
+	do_settings(pc);
+	do_endios(pc);
+
+	if (!PoolSuspend(pc))
+		do_resize(pc);
+
+	do_bios(pc);
+
+	if (!PoolSuspend(pc))
+		do_extents_init(pc);
+
+	do_flush(pc);
+	unplug_pool(pc);
+	do_wake(pc);
+}
+
+/*
+ * Create or read the pool device header.
+ */
+static int pool_init(struct thinp_pool_c *pc)
+{
+	int r;
+	enum handle_type handle = pc->params.handle;
+	struct thinp_pool_c *pc_read;
+
+	/* Read any existing header into temporary thinp_pool_c strcuture. */
+	pc_read = kzalloc(sizeof(*pc_read), GFP_KERNEL);
+	if (!pc_read)
+		return -ENOMEM;
+
+	/* Safe content. */
+	*pc_read = *pc;
+
+	pc_read->disk = metadata_zalloc(pc);
+	BUG_ON(!pc_read->disk);
+	r = header_io_sync(pc_read, READ);
+	if (r) {
+		DM_ERR("reading thinp pool header from %s",
+		       pc->pool.dev->name);
+		goto err;
+	}
+
+	header_to_core(pc_read);
+
+	/* Found disk header magic but invalid metadata -> WARN and bail out. */
+	r = header_check(pc_read);
+	if (r == -EPERM) {
+		DMWARN("header magic found but header data invalid "
+		       "(thinp pool metadata version invalid?)");
+		goto err;
+	}
+
+	/* Create new pool. */
+	if (handle == CREATE_POOL || (handle == AUTO_POOL && r)) {
+		if (handle == AUTO_POOL && pc->params.params < 2) {
+			DMERR("need pool size with auto to initialize");
+			r = -EINVAL;
+			goto err;
+		}
+
+		pc->pool.initialized = extents_start(pc);
+		pc->extents.per_chunk = EXTENTS_PER_GROUP;
+		r = header_write(pc);
+		if (!r)
+			DMINFO("written pool header to %s",
+			       pc->pool.dev->name);
+	
+		/* Flag extent initialization writes. */
+		SetPoolInitializeNew(pc);
+	/* Read existing pool. */
+	} else {
+		if (r)
+			goto err;
+
+		DMINFO("read pool device %s header",
+		       pc->pool.dev->name);
+		pc->extents.size = pc_read->disk->size.extent;
+		pc->pool.size = pc_read->disk->size.dev;
+		pc->pool.initialized = pc_read->disk->size.dev_initialized;
+		pc->extents.per_chunk = pc_read->disk->size.extents_per_chunk;
+		// xXx flags needed?
+		pc->io.flags |= pc_read->disk->flags;
+
+		/* Flag extent initialization reads. */
+		ClearPoolInitializeNew(pc);
+	}
+
+	/*
+	 * Pool may not be initialized yet ->
+	 * trigger initialization in worker.
+	 */
+	ClearPoolInitialized(pc);
+	ClearPoolInitializationActive(pc);
+	SetPoolDoInitialize(pc);
+err:
+	metadata_free(pc, (void **) &pc_read->disk);
+	kfree(pc_read);
+	return r;
+}
+
+/* Constructor <dev_path> <offset> helper */
+static int get_dev(struct dm_target *ti, char **argv, struct c_dev *dev)
+{
+	int r;
+	unsigned long long tmp;
+
+	dev->start = 0;
+	r = sscanf(argv[1], "%llu", &tmp);
+	if (r != 1)
+		DM_ERR("Invalid device start sector");
+
+	dev->start = tmp;
+
+	if (dev->start >= dev->size - MIN_POOL_SIZE)
+		DM_ERR("Invalid device start/length");
+
+	r = dm_get_device(ti, argv[0], FMODE_READ | FMODE_WRITE, &dev->dev);
+	if (r) {
+		DM_ERR_RET(-ENXIO, "Device lookup failed");
+	} else {
+		/* Check device limits. */
+		if (dev->size != check_dev_access(ti->private, dev->size))
+				DM_ERR("Device size");
+	}
+
+	return 0;
+}
+
+/* Check helper: device sizes make sense? */
+static int size_check(struct thinp_pool_c *pc)
+{
+	if (!multiple(pc->pool.start, META_SECTORS))
+		DM_ERR("thinp pool offset is not divisable by %llu",
+		       (LLU) META_SECTORS);
+
+	if (extents_total(pc) < EXTENTS_MIN)
+		DM_ERR("thinp pool too small for extent size");
+
+	return 0;
+}
+
+/* Return string for pool open handle. */
+static const char *handle_str(enum handle_type handle)
+{
+	static const char *handle_to_str[] = {
+		"auto",
+		"create",
+		"open",
+	};
+
+	return handle_to_str[handle];
+}
+
+/*
+ * Check, if @str is listed on variable (const char *) list of strings.
+ *
+ * Returns index 1..N for strings hit on list and 0 if no hit.
+ */
+static int str_listed(const char *str, ...)
+{
+	int r = 0, i = 1;
+	const char *s;
+	va_list str_list;
+
+	va_start(str_list, str);
+
+	while ((s = va_arg(str_list, const char *))) {
+		if (!strnicmp(str, s, strlen(str))) {
+			r = i;
+			break;
+		}
+
+		i++;
+	}
+
+	va_end(str_list);
+	return r;
+}
+
+/* Get replicator control device major:minor. */
+static dev_t
+get_pool_ctrl_dev(struct dm_target *ti)
+{
+	dev_t dev;
+	struct mapped_device *md = dm_table_get_md(ti->table);
+	struct block_device *bdev = bdget_disk(dm_disk(md), 0);
+
+	dev = bdev->bd_dev;
+	bdput(bdev);
+	return dev;
+}
+
+/* Allocate and initialize a thinp_pool_c context. */
+static int
+pool_context_create(struct dm_target *ti, char **argv, struct pool_params *p)
+{
+	int r;
+	/* Contingency reserve for bios. */
+	unsigned parallel_io_max = PARALLEL_IO_MAX * 3 / 2;
+	sector_t extents;
+	struct list_head list;
+	struct thinp_pool_c *pc;
+	struct extent *extent, *tmp;
+
+	INIT_LIST_HEAD(&list);
+
+	/* Got all constructor information to allocate context. */
+	pc = kzalloc(sizeof(*pc), GFP_KERNEL);
+	if (!pc)
+		TI_ERR_RET(-ENOMEM, "Cannot allocate thinp pool context");
+
+	/* Preserve ctr parameters for message interface. */
+	pc->params = *p;
+
+	/* Preset extent size. */
+	pc->extents.size = p->extent_size ?
+			   p->extent_size : EXTENT_SECTORS_DEFAULT;
+
+	init_waitqueue_head(&pc->io.suspendq);	/* Suspend waiters. */
+	atomic_set(&pc->ref, 0);
+	atomic_set(&pc->io.ref, 0);
+	atomic_set(&pc->io.errors, 0);
+	atomic_set(&pc->extents.allocated, 0);
+	atomic_set(&pc->extents.free, 0);
+	atomic_set(&pc->extents.initialized, 0);
+	atomic_set(&pc->extents.total, 0);
+	atomic_set(&pc->extents.init_max, 0);
+	bio_list_init(&pc->io.in);
+	bio_list_init(&pc->io.work);
+	bio_list_init(&pc->io.wait);
+	spin_lock_init(&pc->io.lock);
+	spin_lock_init(&pc->lists.lock_endio);
+	INIT_LIST_HEAD(&pc->lists.endio);
+	INIT_LIST_HEAD(&pc->lists.flush);
+	INIT_LIST_HEAD(&pc->lists.dev_hashs);
+	INIT_LIST_HEAD(&pc->lists.free);
+	INIT_LIST_HEAD(&pc->lists.init);
+	INIT_LIST_HEAD(&pc->lists.ordered);
+	INIT_LIST_HEAD(&pc->lists.context);
+	mutex_init(&pc->lists.dev_hashs_lock);
+	pc->ctrl_dev = get_pool_ctrl_dev(ti);
+	pc->pool.size = p->pool_size ? p->pool_size : extents_start(pc);
+	pc->ti = ti;
+	ti->private = pc;
+
+	/*
+	 * Create metadata mempool and dm_io_client first
+	 * because it's being used during pool initialization.
+	 */
+	/* Create mempool for disk headers. */
+	pc->io.metadata_pool = mempool_create_kmalloc_pool(parallel_io_max,
+							   SECTOR_SIZE);
+	if (!pc->io.metadata_pool)
+		TI_ERR_RET(-ENOMEM, "Failure allocating thinp memory pool");
+
+	/* Use dm_io to io pool metadata. */
+	pc->io.dm_io_client = dm_io_client_create(parallel_io_max / 4);
+	if (IS_ERR(pc->io.dm_io_client))
+		TI_ERR_RET(PTR_ERR(pc->io.dm_io_client),
+			   "Failure creating dm_io client");
+
+	/* Get reference on pool control device. */
+	r = get_dev(ti, argv, &pc->pool);
+	if (r)
+		TI_ERR_RET(r, "thinp pool device access error");
+
+	/* Initialize the pool header and initial extents if new. */
+	r = pool_init(pc);
+	if (r)
+		TI_ERR_RET(r, "Initializing thinp pool header");
+
+	/*
+	 * Try reaquiring the pool device when size
+	 * in header differs from ctr parameter.
+	 */
+	if (p->pool_size && p->pool_size != pc->pool.size) {
+		if (p->pool_size != check_dev_access(pc, p->pool_size))
+			TI_ERR_RET(-ENOMEM,
+				   "Invalid thinp pool size; device too small");
+
+		/* Flag for worker thread, that pool needs resizing. */
+		pc->params.pool_new_size = p->pool_size;
+		SetPoolResize(pc);
+		DMINFO("Resizing pool");
+	}
+
+	/* Calculate after potential read and set total extents. */
+	extents = extents_fit_pool(pc, pc->pool.size);
+	atomic_set(&pc->extents.total, extents);
+
+	/* Check, if device sizes and offsets are valid. */
+	r = size_check(pc);
+	if (r)
+		TI_ERR_RET(r, "Pool/origin size check failed");
+
+	/*
+	 * Allocate extent structs and put them on init list.
+	 *
+	 * In case of error, error out afterwards because
+	 * the destructor needs the extents on the init list.
+	 */
+	r = pool_extents_alloc(pc, 1, extents_total(pc), &list, GFP_KERNEL);
+
+	/* Move/add new extents to init and ordered list. */
+	list_for_each_entry_safe(extent, tmp, &list, lists.ordered) {
+		list_move_tail(&extent->lists.ordered, &pc->lists.ordered);
+		list_add_tail(&extent->lists.free_init, &pc->lists.init);
+	}
+
+	if (r)
+		TI_ERR_RET(r, "Failure allocating thinp pool extents");
+
+	/* Create singlethreaded workqueue for this thinp device. */
+	INIT_WORK(&pc->io.ws, do_thinp);
+	pc->io.wq = create_singlethread_workqueue(DAEMON);
+	if (!pc->io.wq) 
+		TI_ERR_RET(-ENOMEM,
+			   "Failure creating thinp pool io work queue");
+
+	/* Set masks for fast bio -> extent mapping. */
+	pc->extents.mask_inv = extent_data_size(pc) - 1;
+	pc->extents.mask = ~pc->extents.mask_inv;
+
+	/* No larger bios than the extent size and no boundary crossing. */
+	ti->split_io = extent_data_size(pc);
+	BUG_ON(!ti->split_io);
+
+	/* REMOVEME: stats. */
+	pool_stats_init(&pc->stats);
+	ClearPoolStatistics(pc); /* If wanted, enable via message interface. */
+
+	/* Set pool full error policy. */
+	p->policy_error ? SetPoolPolicyError(pc) : ClearPoolPolicyError(pc);
+
+	mutex_lock(&pool_contexts_list_lock);
+	list_add_tail(&pc->lists.context, &pool_contexts_list);
+	mutex_unlock(&pool_contexts_list_lock);
+	return 0;
+}
+
+/* Destruct a thinp pool mapping. */
+static void thinp_pool_dtr(struct dm_target *ti)
+{
+	struct thinp_pool_c *pc = ti->private;
+
+	/* To be able to call in case of early constructor failure. */
+	if (!pc)
+		return;
+
+	BUG_ON(!pool_idle(pc));
+	BUG_ON(atomic_read(&pc->ref));
+
+	/* Remove from global list. */
+	mutex_lock(&pool_contexts_list_lock);
+	list_del(&pc->lists.context);
+	mutex_unlock(&pool_contexts_list_lock);
+
+	if (pc->io.wq)
+		destroy_workqueue(pc->io.wq);
+
+	/* Free any extents on free/init list. */
+	extents_free_list(&pc->lists.init);
+	BUG_ON(!list_empty(&pc->lists.init));
+	extents_free_list(&pc->lists.free);
+	BUG_ON(!list_empty(&pc->lists.free));
+
+	/* There may not be any dev_hashs any more after device destructions. */
+	BUG_ON(!list_empty(&pc->lists.dev_hashs));
+
+	if (pc->io.dm_io_client)
+		dm_io_client_destroy(pc->io.dm_io_client);
+
+	if (pc->io.metadata_pool)
+		mempool_destroy(pc->io.metadata_pool);
+
+	if (pc->pool.dev)
+		dm_put_device(ti, pc->pool.dev);
+
+	kfree(pc);
+}
+
+/*
+ * Construct a pool mapping:
+ *
+ * <start> <length> thinp \
+ * <pool_dev_path> <pool_dev_start> <#varible_params> [<params>...]
+ *
+ * #variable_params = 0-2
+ *
+ * params = {auto/create/open} [#pool_extent_size [policy]]
+ *
+ * 'auto' causes open of a pool with a valid header or
+ * creation of a new pool if there's no vaild one sized to ti->len.
+ *
+ * 'create' enforces creation of a new pool with length ti->len
+ * WARNING: this overwrites an existing pool!!!
+ *
+ * 'open' requires a valid pool to exist. No new one will be
+ * created ever.
+ *
+ * #variable_params:
+ * 0: the pool device must exist and will be opened or the constructor fails
+ * 1 + 'open': equal to '0'
+ * 1 + 'auto': open existing pool or create new one with length ti->len;
+ * 	       implies resizing of an existing pool if ti->len differs
+ * 	       from pool size in header
+ * 1 + 'create': the pool device will get initialized and sized to ti->len
+ * 2 + 'auto': the pool device will either be opened and tried to resize
+ * 	       or get initialized and sized to ti->lem setting the extent
+ * 	       size to pool_extent_size
+ * 3: on create (either implicit or via 'auto'),
+ *    this pool_extent_size will be used.
+ * 4: policy = "error|postpone":
+ *             if pool runs full, bios will be errored or postponed
+ *             (ie. application writes will stall)
+ */
+#define MIN_PARAMS	3
+#define VAR_PARAMS	3
+#define MAX_PARAMS	(MIN_PARAMS + VAR_PARAMS)
+static int thinp_pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
+{
+	int r, num_params;
+	unsigned long long tmp;
+	struct pool_params params = {
+		.pool_start = 0,
+		.params = 0,
+		.handle = OPEN_POOL,
+		.pool_size = 0,
+		.extent_size = EXTENT_SECTORS_DEFAULT,
+		.pool_new_size = 0,
+		.policy_error = 0,
+	};
+
+	if (!range_ok(argc, MIN_PARAMS, MAX_PARAMS))
+		TI_ERR("Invalid argument count");
+
+	/* Get pool device offset. */
+	if (sscanf(argv[1], "%llu", &tmp) != 1 ||
+	    (tmp && (!is_power_of_2(tmp) || tmp < META_SECTORS)))
+		TI_ERR("Invalid thin provisioning pool device start argument");
+
+	params.pool_start = tmp;
+
+	/* Get #num_params. */
+	if (sscanf(argv[2], "%d", &num_params) != 1 ||
+	    !range_ok(num_params, 0, VAR_PARAMS))
+		TI_ERR("Invalid thin provisioning pool "
+		       "parameter number argument");
+
+	if (argc - num_params - 1 != 2)
+		TI_ERR("Invalid number of pool device arguments");
+
+	params.pool_size = ti->len;
+
+	/* Handle any variable pool parameters. */
+	params.params = num_params;
+	if (num_params) {
+		if (str_listed(argv[3], handle_str(CREATE_POOL), NULL)) {
+			params.handle = CREATE_POOL;
+			if (num_params == 1)
+				TI_ERR("thinp create needs another argument");
+		} else if (str_listed(argv[3], handle_str(OPEN_POOL), NULL)) {
+			params.handle = OPEN_POOL;
+			if (num_params > 5)
+				TI_ERR("Too many arguments with thinp 'open'");
+		} else if (str_listed(argv[3], handle_str(AUTO_POOL), NULL))
+			params.handle = AUTO_POOL;
+		else
+			TI_ERR("Invalid thinp auto/create/open argument");
+
+		/* Get pool extent size. */
+		if (num_params > 1) {
+			if (sscanf(argv[4], "%llu", &tmp) != 1 ||
+			    !is_power_of_2(tmp) ||
+			    (tmp && (tmp < META_SECTORS ||
+				     tmp < to_sector(PAGE_SIZE) ||
+				     tmp > MAX_EXTENT_SIZE)))
+				TI_ERR("Invalid pool extent size argument")
+
+			params.extent_size = tmp;
+		}
+
+		if (num_params > 2) {
+			if (str_listed(argv[5], "error", NULL))
+				params.policy_error = 1;
+			if (str_listed(argv[5], "postpone", NULL))
+				params.policy_error = 0;
+			else
+				TI_ERR("Invalid thinp policy argument");
+		}
+	}
+
+	/* Got all parameters -> create thinp pool context. */
+	r = pool_context_create(ti, argv, &params);
+	if (r)
+		thinp_pool_dtr(ti);
+
+	return r;
+}
+
+/*
+ * Populate a device extent hash after its creation by searching
+ * by device number for any entries on the ordered list of extents.
+ */
+/* FIXME: avoid linear search and searching all extents on ordered list. */
+static void hash_populate(struct thinp_dev_c *dc)
+{
+	struct extent *extent;
+
+	list_for_each_entry(extent, &dc->pc->lists.ordered, lists.ordered) {
+		if (ExtentFree(extent) || ExtentInit(extent))
+			continue;
+
+		if (extent->addr.dev_nr == dc->params.dev_nr) {
+			if (!hash_lookup(&dc->dev_hash, extent->addr.dev.key)) {
+				extent->dc = dc;
+				extent_hash_or_init_add(extent);
+			}
+		}
+	}
+}
+
+/*
+ * Create a new hash for the device context,
+ * populate it and add it to the pools list.
+ */
+static int dc_add_to_pc(struct thinp_dev_c *dc)
+{
+	int r;
+	sector_t extents;
+	struct extent_dev_hash *dev_hash;
+	struct thinp_pool_c *pc;
+
+	mutex_lock(&pool_contexts_list_lock);
+	pc = pc_get_by_dev(dc->dm_dev->bdev->bd_dev); /* Pool control device.*/
+	mutex_unlock(&pool_contexts_list_lock);
+
+	BUG_ON(!pc);
+	dc->pc = pc;
+
+	/* Calculate amount of extents for the device. */
+	extents = dc->ti->len;
+	do_div(extents, extent_total_size(pc));	
+	r = hash_init(&dc->dev_hash.hash, extents);
+	if (r) {
+		DMERR("Error initializing pool extent hash");
+		pc_put(pc);
+		return r;
+	}
+
+	/* The hash may not exist before the device got created! */
+	mutex_lock(&pc->lists.dev_hashs_lock);
+	dev_hash = extent_dev_hash_get_by_devnr(pc, dc->params.dev_nr);
+	if (dev_hash) {
+		DMERR("Device with number=%llu already exists",
+		      (LLU) dc->params.dev_nr);
+		pc_put(pc);
+		r = -EEXIST;
+		goto out;
+	}
+
+	/*
+	 * Populate the hash and add to pool list.
+	 *
+	 * We have to do this locked because of the concurrent
+	 * update in the worker (extent_validate()).
+	 */
+	mutex_lock(&dc->dev_hash.lock);
+	hash_populate(dc);
+	mutex_unlock(&dc->dev_hash.lock);
+
+	list_add_tail(&dc->dev_hash.list, &pc->lists.dev_hashs);
+out:
+	mutex_unlock(&pc->lists.dev_hashs_lock);
+	return r;
+}
+
+/* Delete device from pool context safely. */
+static void dc_del_from_pc(struct thinp_dev_c *dc)
+{
+	struct thinp_pool_c *pc = dc->pc;
+
+	/* Allow for early calls from dtr. */
+	if (!pc)
+		return;
+
+	mutex_lock(&pc->lists.dev_hashs_lock);
+	if (!list_empty(&dc->dev_hash.list)) {
+		list_del(&dc->dev_hash.list);
+		pc_put(pc);
+	}
+
+	mutex_unlock(&pc->lists.dev_hashs_lock);
+}
+
+/* Allocate and initialize a thinp_dev_c context. */
+static int
+dev_context_create(struct dm_target *ti, char **argv, struct dev_params *p)
+{
+	int r;
+	struct thinp_dev_c *dc;
+
+	/* Got all constructor information to allocate context. */
+	dc = kzalloc(sizeof(*dc), GFP_KERNEL);
+	if (!dc)
+		TI_ERR_RET(-ENOMEM, "Cannot allocate thinp device context");
+
+	/* Preserve ctr parameters for message interface. */
+	dc->params = *p;
+
+	init_waitqueue_head(&dc->io.suspendq);	/* Suspend waiters. */
+	INIT_LIST_HEAD(&dc->dev_hash.list);
+	atomic_set(&dc->io.ref, 0);
+	dc->ti = ti;
+	mutex_init(&dc->dev_hash.lock);
+	ti->private = dc;
+
+	r = dm_get_device(ti, argv[0], FMODE_READ | FMODE_WRITE, &dc->dm_dev);
+	if (r)
+		DM_ERR_RET(r, "thinp pool device lookup failed");
+
+	r = dc_add_to_pc(dc);
+	if (r)
+		DM_ERR_RET(r, "Failure adding thinp device to pool");
+
+	/* No larger bios than the extent size and no boundary crossing. */
+	ti->split_io = extent_data_size(dc->pc);
+	BUG_ON(!ti->split_io);
+
+	/* REMOVEME: stats. */
+	dev_stats_init(&dc->stats);
+	ClearDevStatistics(dc); /* If wanted, enable via message interface. */
+	return 0;
+}
+
+/* Destruct a thinp device mapping. */
+static void thinp_dev_dtr(struct dm_target *ti)
+{
+	struct thinp_dev_c *dc = ti->private;
+
+	/* To be able to call in case of early constructor failure. */
+	if (!dc)
+		return;
+
+	BUG_ON(dev_ios_inflight(dc));
+	dc_del_from_pc(dc);
+	hash_depopulate(&dc->dev_hash.hash);
+	hash_exit(&dc->dev_hash.hash);
+
+	/* Release reference on pool control device. */
+	if (dc->dm_dev)
+		dm_put_device(ti, dc->dm_dev);
+
+	kfree(dc);
+}
+
+/*
+ * Construct a thin provisioned device mapping:
+ *
+ * <start> <length> thinp-dev <pool_dev> <dev_nr>		\
+ *
+ * pool_dev: pool device previously created with the "thinp" constructor
+ * dev_size: size of the thin provisioned device // xXx drop extents on shrink
+ * dev_nr: unsigned number the device is being referenced by in the pool
+ *
+ */
+#define CTR_PARAMS	2
+static int thinp_dev_ctr(struct dm_target *ti, unsigned argc, char **argv)
+{
+	int r;
+	unsigned long long tmp;
+	struct dev_params params = {
+		.dev_nr = 0, /* 0 is invalid device number */
+	};
+
+	if (argc != CTR_PARAMS)
+		TI_ERR("Invalid argument count");
+
+	/* Get device number and verify. */
+	if (sscanf(argv[1], "%llu", &tmp) != 1 ||
+	    !range_ok(tmp, 1, ULLONG_MAX))
+		TI_ERR("Invalid thin provisioning device number argument");
+
+	params.dev_nr = tmp;
+
+	/* Got all parameters -> create thinp device context. */
+	r = dev_context_create(ti, argv, &params);
+	if (r)
+		thinp_dev_dtr(ti);
+
+	return r;
+}
+
+/*
+ * Map a pool io.
+ *
+ * This is a dummy, because io on the pool device is void
+ * but pool will get read by udev and other weird things.
+ */
+static int thinp_pool_map(struct dm_target *ti, struct bio *bio,
+			  union map_info *map_context)
+{
+	bio_endio(bio, bio_rw(bio) == READA ? -EIO : 0);
+	return DM_MAPIO_SUBMITTED; /* Accepted bio, don't make new request. */
+}
+
+/* Map a device io. */
+static int thinp_dev_map(struct dm_target *ti, struct bio *bio,
+			 union map_info *map_context)
+{
+	struct thinp_dev_c *dc = ti->private;
+	struct thinp_pool_c *pc = dc->pc;
+	struct extent *extent;
+
+	/* I don't want to waste pool capacity. */
+	if (bio_rw(bio) == READA)
+		return -EIO;
+
+	/* Fail early on fatal pool error (ie. corrupt header). */
+	if (unlikely(PoolDead(pc)))
+		return -EIO;
+
+	bio->bi_sector -= ti->begin;	/* Remap sector to target begin. */
+
+	/*
+	 * If there's a valid extent in the hash for this bio, just remap
+	 * the request to it unless it is being copied (relocated).
+	 */
+	mutex_lock(&dc->dev_hash.lock);
+	extent = hash_lookup(&dc->dev_hash, _bio_to_key(pc, bio));
+	if (extent && !ExtentCopying(extent)) {
+		endio_get(BIO_IO, extent);
+		mutex_unlock(&dc->dev_hash.lock);
+
+		if (ExtentError(extent))
+			_bio_endio(dc, bio, -EIO);
+		else
+			BUG_ON(dm_io_bio_submit(extent, bio));
+
+		endio_put(BIO_IO, extent);
+	/*
+	 * If not so, queue to the pool worker to try allocating
+	 * one or mypping it after a copy finished.
+	 */
+	} else {
+		int write;
+
+		mutex_unlock(&dc->dev_hash.lock);
+		write = !!(bio_data_dir(bio) == WRITE);
+
+		/*
+		 * I can use bi_bdev to squirrel the dc
+		 * reference to the pool worker, because
+		 * it'll remap it to the pool backing
+		 * store device anyway.
+		 */
+		bio->bi_bdev = (struct block_device *) dc;
+
+		spin_lock_irq(&pc->io.lock);
+		bio_list_add(&pc->io.in, bio);
+		spin_unlock_irq(&pc->io.lock);
+
+		atomic_inc(dc->stats.io + write);
+		atomic_inc(pc->stats.io + write);
+
+		/* Wakeup worker to deal with bio input list. */
+		SetPoolNewBiosQueued(pc);
+		wake_do_thinp(pc);
+	}
+
+	return DM_MAPIO_SUBMITTED;	/* Handle later. */
+}
+
+/* thinp pool flush method. */
+static void thinp_pool_flush(struct dm_target *ti)
+{
+	struct thinp_pool_c *pc = ti->private;
+
+	flush_workqueue(pc->io.wq);
+
+	/* Wait until all io has been processed. */
+	wait_event(pc->io.suspendq, pool_idle(pc));
+}
+
+/* thinp pool post suspend method. */
+static void thinp_pool_postsuspend(struct dm_target *ti)
+{
+	struct thinp_pool_c *pc = ti->private;
+
+	/* Tell worker thread to stop initiationg new pool metadata IO. */
+	SetPoolSuspend(pc);
+	thinp_pool_flush(ti);
+}
+
+/* thinp pool resume method. */
+static void thinp_pool_resume(struct dm_target *ti)
+{
+	struct thinp_pool_c *pc = ti->private;
+
+	/* Tell worker thread to start initiationg any new pool metadata IO. */
+	ClearPoolSuspend(pc);
+	wake_do_thinp(pc);
+}
+
+/* thinp device flush method. */
+static void thinp_dev_flush(struct dm_target *ti)
+{
+	struct thinp_dev_c *dc = ti->private;
+
+	flush_workqueue(dc->pc->io.wq);
+
+	/* Wait until all io has been processed. */
+	wait_event(dc->io.suspendq, !dev_ios_inflight(dc));
+}
+
+/* thinp device post suspend method. */
+static void thinp_dev_postsuspend(struct dm_target *ti)
+{
+	thinp_dev_flush(ti);
+}
+
+/*
+ * Message handler functions.
+ */
+
+/* Change pool error policy. */
+static int pool_msg_policy(struct thinp_pool_c *pc, char *arg)
+{
+	if (str_listed(arg, "toggle", NULL)) {
+		SetPoolChangePolicyError(pc);
+		wake_do_thinp(pc);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+/* Message handler to remove a dtr'ed device from the pool. */
+/*
+ * FIXME: if machine crashs during remove, removal of dropped extents
+ * 	  doesn't restart but message needs to be called again.
+ */
+static int pool_msg_remove_device(struct thinp_pool_c *pc, char *arg)
+{
+	unsigned long long dev_nr, extents_freed = 0;
+	struct extent *extent;
+	struct extent_dev_hash *dev_hash;
+
+	if (PoolDoInitialize(pc))
+		DM_ERR_RET(-EPERM, "Prohibited during pool initialization");
+
+	if (sscanf(arg, "%llu", &dev_nr) != 1 ||
+	    !range_ok(dev_nr, 1, ULLONG_MAX))
+		DM_ERR("Invalid thin provisioning device number argument");
+
+	/* If hash exists the device exists and we need to bail out. */
+	mutex_lock(&pc->lists.dev_hashs_lock);
+	dev_hash = extent_dev_hash_get_by_devnr(pc, dev_nr);
+	if (dev_hash) {
+		mutex_unlock(&pc->lists.dev_hashs_lock);
+		DM_ERR_RET(-EPERM, "device %llu is active!", (LLU) dev_nr);
+	}
+
+	/* Put any extents for dev_nr on init list. */
+	list_for_each_entry(extent, &pc->lists.ordered, lists.ordered) {
+		if (ExtentFree(extent) ||
+		    ExtentInit(extent) ||
+		    extent->addr.dev_nr != dev_nr)
+			continue;
+
+		extent->dc = NULL;
+		extent->io.flags = 0;
+		extent->addr.dev.offset = 0;
+		extent->addr.dev_nr = 0; /* Invalid # */
+
+		SetExtentDropped(extent);
+		atomic_dec(&pc->extents.initialized);
+		BUG_ON(!list_empty(&extent->lists.hash));
+		extent_hash_or_init_add(extent);
+		extents_freed++;
+	}
+
+	mutex_unlock(&pc->lists.dev_hashs_lock);
+
+	if (extents_freed) {
+		DMINFO("Freeing %llu extents for device %llu",
+		       (LLU) extents_freed, (LLU) dev_nr);
+		wake_do_thinp(pc);
+	} else
+		DMWARN("No extents to free for device %llu", (LLU) dev_nr);
+
+	return 0;
+}
+
+/* Message handler to resize pool device. */
+static int pool_msg_resize(struct thinp_pool_c *pc, char *arg)
+{
+	unsigned long long tmp;
+
+	/* Wait for initialization or resizing to finish. */
+	if (PoolResize(pc) ||
+	    pc->params.pool_new_size)
+		return -EPERM;
+
+	if (sscanf(arg, "%llu", &tmp) != 1 ||
+	    tmp < extents_start(pc) + EXTENTS_MIN * extent_total_size(pc)) {
+		DMERR("Size smaller than pool minimum size");
+		return -EINVAL;
+	}
+
+	if (tmp != check_dev_access(pc, tmp)) {
+		DMERR("Size larger than pool device");
+		return -EINVAL;
+	}
+
+	/* Set requested pool size. */
+	pc->params.pool_new_size = tmp;
+
+	/* Flag worker thread has to resize the pool. */
+	SetPoolResize(pc);
+	wake_do_thinp(pc);
+	return 0;
+}
+
+/* Message handler to change pool/dev statistics status output. */
+static int _msg_statistics(struct thinp_pool_c *pc,
+			   struct thinp_dev_c *dc, char *arg)
+{
+	int o = str_listed(arg, "on", "off", "reset", NULL), r = 0;
+
+	if (o == 1)
+		pc ? SetPoolStatistics(pc) : SetDevStatistics(dc);
+	else if (o == 2)
+		pc ? ClearPoolStatistics(pc) : ClearDevStatistics(dc);
+	else if (o == 3)
+		pc ? pool_stats_init(&pc->stats) : dev_stats_init(&dc->stats);
+	else
+		r = -EINVAL;
+
+	return r;
+}
+
+/* Message handler to change pool statistics status output. */
+static int pool_msg_statistics(struct thinp_pool_c *pc, char *arg)
+{
+	return _msg_statistics(pc, NULL, arg);
+}
+
+/* Thinp pool message method. */
+static int thinp_pool_message(struct dm_target *ti, unsigned argc, char **argv)
+{
+	struct thinp_pool_c *pc = ti->private;
+
+	/* Statistics ok while suspended. */
+	if (argc == 2 &&
+	    str_listed(argv[0], "statistics", NULL))
+		return pool_msg_statistics(pc, argv[1]);
+
+	if (PoolSuspend(pc))
+		DM_ERR_RET(-EPERM, "Pool suspended");
+
+	if (argc == 1) {
+		if (str_listed(argv[0], "flush", NULL)) {
+			thinp_pool_flush(ti);
+			return 0;
+		}
+	} else if (argc == 2) {
+		if (str_listed(argv[0], "policy", NULL))
+			return pool_msg_policy(pc, argv[1]);
+		else if (str_listed(argv[0], "remove_device", NULL))
+			return pool_msg_remove_device(pc, argv[1]);
+		else if (str_listed(argv[0], "resize", NULL))
+			return pool_msg_resize(pc, argv[1]);
+	}
+
+	DMWARN("Unrecognised pool message received.");
+	return -EINVAL;
+}
+
+/* Message handler to change device statistics status output. */
+static int dev_msg_statistics(struct thinp_dev_c *dc, char *arg)
+{
+	return _msg_statistics(NULL, dc, arg);
+}
+
+/* Thinp device message method. */
+static int thinp_dev_message(struct dm_target *ti, unsigned argc, char **argv)
+{
+	struct thinp_dev_c *dc = ti->private;
+
+	if (argc == 2 &&
+	    str_listed(argv[0], "statistics", NULL))
+		return dev_msg_statistics(dc, argv[1]);
+
+	if (PoolSuspend(dc->pc))
+		DM_ERR_RET(-EPERM, "Pool suspended");
+
+	if (argc == 1 &&
+	    str_listed(argv[0], "flush", NULL)) {
+		thinp_dev_flush(ti);
+		return 0;
+	}
+
+	DMWARN("Unrecognised pool message received.");
+	return -EINVAL;
+}
+
+/* bvec merge method. */
+static int thinp_dev_bvec_merge(struct dm_target *ti,
+				struct bvec_merge_data *bvm,
+				struct bio_vec *biovec, int max_size)
+{
+	struct thinp_dev_c *dc = ti->private;
+	struct thinp_pool_c *pc = dc->pc;
+	struct extent *extent;
+	struct request_queue *q  = bdev_get_queue(pc->pool.dev->bdev);
+
+	BUG_ON(!pc);
+
+	if (!q->merge_bvec_fn)
+		return max_size;
+
+	bvm->bi_bdev = pc->pool.dev->bdev;
+	mutex_lock(&dc->dev_hash.lock);
+	extent = hash_lookup(&dc->dev_hash, _sector_to_key(pc, bvm->bi_sector));
+
+	/* Go by sector 0 for best bet unless extent hashed. */
+	bvm->bi_sector = extent ? extent_data_offset(extent) : 0;
+	mutex_unlock(&dc->dev_hash.lock);
+
+	/* REMOVEME: stats. */
+	atomic_inc(&dc->stats.merge_bvec_fn);
+	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
+}
+
+/* Thinp pool status output method. */
+static int thinp_pool_status(struct dm_target *ti, status_type_t type,
+			     char *result, unsigned maxlen)
+{
+	ssize_t sz = 0;
+	struct thinp_pool_c *pc = ti->private;
+	struct pool_stats *s;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		s = &pc->stats;
+		DMEMIT("%llu %llu/%llu %s/%s/%s %s %u",
+		     (LLU) pc->pool.size,
+		     (LLU) atomic_read(&pc->extents.allocated),
+		     (LLU) extents_total(pc),
+		     PoolDead(pc) ? "ERROR" : "-",
+		     PoolDoInitialize(pc) ? "init" : "-",
+		     PoolInitialized(pc) ? "complete" : "-",
+		     PoolInitialized(pc) &&
+		     pc->params.pool_new_size ?
+		     (pc->params.pool_new_size > pc->pool.size ? "growing" :
+								 "shrinking") :
+		     "-",
+		     atomic_read(&pc->io.errors));
+
+		if (PoolStatistics(pc))
+			DMEMIT(" v=%s es=%llu flgs=0x%lx r=%u/%u w=%u/%u "
+			     "h=%u/%u m=%u/%u sub=%u/%u m=%u/%u "
+			     "ef=%u ei=%u et=%u eh=%u iof=%u pi=%u",
+			     version,
+			     (LLU) extent_data_size(pc),
+			     pc->io.flags,
+			     atomic_read(s->io),
+			     atomic_read(s->bios_endiod),
+			     atomic_read(s->io + 1),
+			     atomic_read(s->bios_endiod + 1),
+			     atomic_read(s->hits), atomic_read(s->hits + 1),
+			     atomic_read(s->misses),
+			     atomic_read(s->misses + 1),
+			     atomic_read(s->submitted_io),
+			     atomic_read(s->submitted_io + 1),
+			     atomic_read(s->extent_meta_io),
+			     atomic_read(s->extent_meta_io + 1),
+			     extents_free(pc),
+			     extents_initialized(pc),
+			     extents_total(pc),
+			     atomic_read(&s->extents_hashed),
+			     pool_ios_inflight(pc),
+			     pool_idle(pc));
+		break;
+
+	case STATUSTYPE_TABLE:
+		DMEMIT("%s %llu %u", pc->pool.dev->name,
+		       (LLU) pc->pool.start, pc->params.params);
+
+		if (pc->params.params)
+			DMEMIT(" %s", handle_str(pc->params.handle));
+
+		if (pc->params.params > 1)
+			DMEMIT(" %llu", (LLU) pc->params.pool_size);
+
+		if (pc->params.params > 2)
+			DMEMIT(" %llu", (LLU) pc->params.extent_size);
+	}
+
+	return 0;
+}
+
+/* Thinp device status output method. */
+static int thinp_dev_status(struct dm_target *ti, status_type_t type,
+			    char *result, unsigned maxlen)
+{
+	uint64_t extents_provisioned, extents_total;
+	ssize_t sz = 0;
+	char buf[BDEVNAME_SIZE];
+	struct thinp_dev_c *dc = ti->private;
+	struct dev_stats *s;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		mutex_lock(&dc->dev_hash.lock);
+		extents_provisioned = hash_entries(&dc->dev_hash.hash);
+		mutex_unlock(&dc->dev_hash.lock);
+
+		extents_total = ti->len;
+		do_div(extents_total, extent_data_size(dc->pc));
+		DMEMIT("%llu/%llu",
+		       (LLU) extents_provisioned, (LLU) extents_total);
+
+		if (DevStatistics(dc)) {
+			s = &dc->stats;
+
+			DMEMIT(" v=%s flgs=0x%lx bkts=%u r=%u/%u w=%u/%u "
+			       "hi=%u req=%u mbf=%u",
+			       version,
+			       dc->io.flags, dc->dev_hash.hash.buckets,
+			       atomic_read(s->io),
+			       atomic_read(s->bios_endiod),
+			       atomic_read(s->io + 1),
+			       atomic_read(s->bios_endiod + 1),
+			       atomic_read(&s->extents_hashed),
+			       atomic_read(&s->bios_requeued),
+			       atomic_read(&s->merge_bvec_fn));
+		}
+
+		break;
+
+	case STATUSTYPE_TABLE:
+		DMEMIT("%s %llu",
+		       format_dev_t(buf, dc->pc->ctrl_dev), dc->params.dev_nr);
+	}
+
+	return 0;
+}
+
+/* Provide io hints. */
+static void
+thinp_dev_io_hints(struct dm_target *ti, struct queue_limits *limits)
+{
+	struct thinp_dev_c *dc = ti->private;
+
+	blk_limits_io_min(limits, 0);
+	blk_limits_io_opt(limits, extent_data_size(dc->pc));
+}
+
+/* Thinp pool control target interface. */
+static struct target_type thinp_pool_target = {
+	.name = "thinp",
+	.version = {1, 0, 0},
+	.module = THIS_MODULE,
+	.ctr = thinp_pool_ctr,
+	.dtr = thinp_pool_dtr,
+	.flush = thinp_pool_flush,
+	.map = thinp_pool_map,
+	.postsuspend = thinp_pool_postsuspend,
+	.resume = thinp_pool_resume,
+	.message = thinp_pool_message,
+	.status = thinp_pool_status,
+};
+
+/* Thinp device target interface. */
+static struct target_type thinp_dev_target = {
+	.name = "thinp-dev",
+	.version = {1, 0, 0},
+	.module = THIS_MODULE,
+	.ctr = thinp_dev_ctr,
+	.dtr = thinp_dev_dtr,
+	.flush = thinp_dev_flush,
+	.map = thinp_dev_map,
+	.postsuspend = thinp_dev_postsuspend,
+	.message = thinp_dev_message,
+	.status = thinp_dev_status,
+	.merge = thinp_dev_bvec_merge,
+	.io_hints = thinp_dev_io_hints,
+};
+
+static int __init dm_thinp_init(void)
+{
+	int r;
+
+	INIT_LIST_HEAD(&pool_contexts_list);
+	mutex_init(&pool_contexts_list_lock);
+
+	r = dm_register_target(&thinp_pool_target);
+	if (r)
+		DMERR("Failed to register %s [%d]", POOL_TARGET, r);
+	else {
+		DMINFO("registered %s %s", POOL_TARGET, version);
+
+		r = dm_register_target(&thinp_dev_target);
+		if (r) {
+			DMERR("Failed to register %s [%d]", DEV_TARGET, r);
+			dm_unregister_target(&thinp_pool_target);
+		} else
+			DMINFO("registered %s %s", DEV_TARGET, version);
+	}
+
+	return r;
+}
+
+static void dm_thinp_exit(void)
+{
+	dm_unregister_target(&thinp_dev_target);
+	DMINFO("unregistered %s %s", DEV_TARGET, version);
+	dm_unregister_target(&thinp_pool_target);
+	DMINFO("unregistered %s %s", POOL_TARGET, version);
+}
+
+/* Module hooks */
+module_init(dm_thinp_init);
+module_exit(dm_thinp_exit);
+
+MODULE_DESCRIPTION(DM_NAME "device-mapper thin provisioning targets");
+MODULE_AUTHOR("Heinz Mauelshagen <heinzm@redhat.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("dm-thinp-dev");
+MODULE_ALIAS("dm-thinp-pool");
