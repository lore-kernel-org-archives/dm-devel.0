From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/3] dm persistent data: a library for storing
	metadata in DM targets
Date: Fri,  8 Jul 2011 18:19:51 -0400
Message-ID: <1310163592-29683-3-git-send-email-snitzer@redhat.com>
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

The more sophisticated device mapper targets require complex metadata
that is managed in kernel.  In late 2010 we were seeing that various
different targets were rolling their own data strutures, for example:

- Mikulas Patocka's multisnap implementation
- Heinz Mauelshagen's thin provisioning target
- Another btree based caching target posted to dm-devel
- Another multi-snapshot target based on a design of Daniel Phillips

Maintaining these data structures takes a lot of work, so if possible
we'd like to reduce the number.

The persistent-data library is an attempt to provide a re-usable
framework for people who want to store metadata in device mapper
targets.  It's currently used by the thin-provisioning target and an
upcoming hierarchical storage target.

Please see: Documentation/device-mapper/persistent-data.txt

Signed-off-by: Joe Thornber <thornber@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 Documentation/device-mapper/persistent-data.txt    |   90 ++
 drivers/md/persistent-data/Kconfig                 |    9 +
 drivers/md/persistent-data/Makefile                |   10 +
 drivers/md/persistent-data/dm-block-manager.c      |  931 ++++++++++++++++++++
 drivers/md/persistent-data/dm-block-manager.h      |  110 +++
 drivers/md/persistent-data/dm-btree-internal.h     |  141 +++
 drivers/md/persistent-data/dm-btree-remove.c       |  540 ++++++++++++
 drivers/md/persistent-data/dm-btree-spine.c        |  192 ++++
 drivers/md/persistent-data/dm-btree.c              |  871 ++++++++++++++++++
 drivers/md/persistent-data/dm-btree.h              |  146 +++
 drivers/md/persistent-data/dm-pd-module.c          |   18 +
 drivers/md/persistent-data/dm-space-map-common.h   |   99 +++
 drivers/md/persistent-data/dm-space-map-disk.c     |  624 +++++++++++++
 drivers/md/persistent-data/dm-space-map-disk.h     |   21 +
 drivers/md/persistent-data/dm-space-map-metadata.c |  878 ++++++++++++++++++
 drivers/md/persistent-data/dm-space-map-metadata.h |   29 +
 drivers/md/persistent-data/dm-space-map.h          |  116 +++
 .../md/persistent-data/dm-transaction-manager.c    |  442 ++++++++++
 .../md/persistent-data/dm-transaction-manager.h    |  139 +++
 19 files changed, 5406 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/device-mapper/persistent-data.txt
 create mode 100644 drivers/md/persistent-data/Kconfig
 create mode 100644 drivers/md/persistent-data/Makefile
 create mode 100644 drivers/md/persistent-data/dm-block-manager.c
 create mode 100644 drivers/md/persistent-data/dm-block-manager.h
 create mode 100644 drivers/md/persistent-data/dm-btree-internal.h
 create mode 100644 drivers/md/persistent-data/dm-btree-remove.c
 create mode 100644 drivers/md/persistent-data/dm-btree-spine.c
 create mode 100644 drivers/md/persistent-data/dm-btree.c
 create mode 100644 drivers/md/persistent-data/dm-btree.h
 create mode 100644 drivers/md/persistent-data/dm-pd-module.c
 create mode 100644 drivers/md/persistent-data/dm-space-map-common.h
 create mode 100644 drivers/md/persistent-data/dm-space-map-disk.c
 create mode 100644 drivers/md/persistent-data/dm-space-map-disk.h
 create mode 100644 drivers/md/persistent-data/dm-space-map-metadata.c
 create mode 100644 drivers/md/persistent-data/dm-space-map-metadata.h
 create mode 100644 drivers/md/persistent-data/dm-space-map.h
 create mode 100644 drivers/md/persistent-data/dm-transaction-manager.c
 create mode 100644 drivers/md/persistent-data/dm-transaction-manager.h

diff --git a/Documentation/device-mapper/persistent-data.txt b/Documentation/device-mapper/persistent-data.txt
new file mode 100644
index 0000000..399c958
--- /dev/null
+++ b/Documentation/device-mapper/persistent-data.txt
@@ -0,0 +1,90 @@
+Introduction
+============
+
+The more sophisticated device mapper targets require complex metadata
+that is managed in kernel.  In late 2010 we were seeing that various
+different targets were rolling their own data strutures, for example:
+
+- Mikulas Patocka's multisnap implementation
+- Heinz Mauelshagen's thin provisioning target
+- Another btree based caching target posted to dm-devel
+- Another multi-snapshot target based on a design of Daniel Phillips
+
+Maintaining these data structures takes a lot of work, so if possible
+we'd like to reduce the number.
+
+The persistent-data library is an attempt to provide a re-usable
+framework for people who want to store metadata in device mapper
+targets.  It's currently used by the thin-provisioning target and an
+upcoming hierarchical storage target.
+
+
+Overview
+========
+
+The main documentation is in the header files, which can all be found
+under drivers/md/persistent-data.  But here is an overview:
+
+The block manager
+-----------------
+
+dm-block-manager.[hc]
+
+This provides access to the data on disk in fixed sized blocks.  There
+is a read/write locking interface to prevent concurrent accesses, and
+keep data that is being used in the cache.
+
+Clients of persistent-data are unlikely to use this directly.
+
+The transaction manager
+-----------------------
+
+dm-transaction-manager.[hc]
+
+This restricts access to blocks and enforces copy-on-write semantics.
+The only way you can get hold of a writable block through the
+transaction manager is by shadowing an existing block (ie. doing
+copy-on-write), or allocating a fresh one.  Shadowing is elided within
+the same transaction, so performance is reasonable.  The commit method
+ensures that all data is flushed, before your superblock, and then the
+superblock written.  On power failure your metadata will be as it was
+when last committed.
+
+Clients will need to be familiar with tm to use persistent-data.
+
+The Space Maps
+--------------
+
+dm-space-map.h
+dm-space-map-metadata.[hc]
+dm-space-map-disk.[hc]
+
+On disk data structures that keep track of reference counts of blocks.
+Also acts as the allocator of new blocks.  Currently two
+implementations, a simpler one for managing blocks on a different
+device (eg. thinly provisioned data blocks), and another for managing
+the metadata space.  The latter is complicated by the need to store
+it's own data within the space it's managing.
+
+Clients do not need to use space maps directly.
+
+The data structures
+-------------------
+
+dm-btree.[hc]
+dm-btree-remove.c
+dm-btree-spine.c
+dm-btree-internal.h
+
+Currently there is only one data structure.  A hierarchical btree.
+There are plans to add more, for example something with an array like
+interface would see a lot of use.
+
+The btree is 'hierarchical' in that you can define it to be composed
+of nested btrees, and take multiple keys.  For example the
+thin-provisioning target uses a btree with two levels of nesting, the
+first mapping a device id to a mapping tree, which in turn maps a
+virtual block to a physical block.
+
+Values stored in the btrees can have arbitrary size.  Keys are always
+64bits (though nesting allows you to use multiple keys).
diff --git a/drivers/md/persistent-data/Kconfig b/drivers/md/persistent-data/Kconfig
new file mode 100644
index 0000000..ee81085
--- /dev/null
+++ b/drivers/md/persistent-data/Kconfig
@@ -0,0 +1,9 @@
+config DM_PERSISTENT_DATA
+       tristate "Persistent data library"
+       depends on BLK_DEV_DM && EXPERIMENTAL
+       select LIBCRC32C
+       ---help---
+         Library of code for metadata support for dm targets.  The
+         term persistent isn't referring to the fact that the data is
+         written to disk (which of course it is).  But that these data
+         structures are immutable.
diff --git a/drivers/md/persistent-data/Makefile b/drivers/md/persistent-data/Makefile
new file mode 100644
index 0000000..8b8455d
--- /dev/null
+++ b/drivers/md/persistent-data/Makefile
@@ -0,0 +1,10 @@
+obj-$(CONFIG_DM_PERSISTENT_DATA) += dm-persistent-data.o
+dm-persistent-data-objs := \
+	dm-block-manager.o \
+	dm-pd-module.o \
+	dm-space-map-disk.o \
+	dm-space-map-metadata.o \
+	dm-transaction-manager.o \
+	dm-btree.o \
+	dm-btree-remove.o \
+	dm-btree-spine.o
diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
new file mode 100644
index 0000000..5fb696d
--- /dev/null
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -0,0 +1,931 @@
+#include "dm-block-manager.h"
+
+#include <linux/dm-io.h>
+#include <linux/slab.h>
+#include <linux/device-mapper.h> /* For SECTOR_SHIFT and DMERR */
+
+#define DM_MSG_PREFIX "block manager"
+
+/*----------------------------------------------------------------*/
+
+#define SECTOR_SIZE 512
+
+enum dm_block_state {
+	BS_EMPTY,
+	BS_CLEAN,
+	BS_READING,
+	BS_WRITING,
+	BS_READ_LOCKED,
+	BS_READ_LOCKED_DIRTY,	/* block was dirty before it was read locked */
+	BS_WRITE_LOCKED,
+	BS_DIRTY,
+	BS_ERROR
+};
+
+struct dm_block {
+	struct list_head list;
+	struct hlist_node hlist;
+
+	dm_block_t where;
+	struct dm_block_validator *validator;
+	void *data_actual;
+	void *data;
+	wait_queue_head_t io_q;
+	unsigned read_lock_count;
+	unsigned write_lock_pending;
+	enum dm_block_state state;
+
+	/* Extra flags like REQ_FLUSH and REQ_FUA can be set here.  This is
+	 * mainly as to avoid a race condition in flush_and_unlock() where
+	 * the newly unlocked superblock may have been submitted for a
+	 * write before the write_all_dirty() call is made.
+	 */
+	int io_flags;
+
+	/*
+	 * Sadly we need an up pointer so we can get to the bm on io
+	 * completion.
+	 */
+	struct dm_block_manager *bm;
+};
+
+struct dm_block_manager {
+	struct block_device *bdev;
+	unsigned cache_size; /* in bytes */
+	unsigned block_size; /* in bytes */
+	dm_block_t nr_blocks;
+
+	/* this will trigger everytime an io completes */
+	wait_queue_head_t io_q;
+
+	struct dm_io_client *io;
+
+	/* |lock| protects all the lists and the hash table */
+	spinlock_t lock;
+	struct list_head empty_list; /* no block assigned */
+	struct list_head clean_list; /* unlocked and clean */
+	struct list_head dirty_list; /* unlocked and dirty */
+	struct list_head error_list;
+	unsigned available_count;
+	unsigned reading_count;
+	unsigned writing_count;
+
+	/*
+	 * Hash table of cached blocks, holds everything that isn't in the
+	 * BS_EMPTY state.
+	 */
+	unsigned hash_size;
+	unsigned hash_mask;
+	struct hlist_head buckets[0]; /* must be last member of struct */
+};
+
+dm_block_t dm_block_location(struct dm_block *b)
+{
+	return b->where;
+}
+EXPORT_SYMBOL_GPL(dm_block_location);
+
+void *dm_block_data(struct dm_block *b)
+{
+	return b->data;
+}
+EXPORT_SYMBOL_GPL(dm_block_data);
+
+/*----------------------------------------------------------------
+ * Hash table
+ *--------------------------------------------------------------*/
+static unsigned hash_block(struct dm_block_manager *bm, dm_block_t b)
+{
+	const unsigned BIG_PRIME = 4294967291UL;
+
+	return (((unsigned) b) * BIG_PRIME) & bm->hash_mask;
+}
+
+static struct dm_block *__find_block(struct dm_block_manager *bm, dm_block_t b)
+{
+	unsigned bucket = hash_block(bm, b);
+	struct dm_block *blk;
+	struct hlist_node *n;
+
+	hlist_for_each_entry(blk, n, bm->buckets + bucket, hlist)
+		if (blk->where == b)
+			return blk;
+
+	return NULL;
+}
+
+static void __insert_block(struct dm_block_manager *bm, struct dm_block *b)
+{
+	unsigned bucket = hash_block(bm, b->where);
+
+	hlist_add_head(&b->hlist, bm->buckets + bucket);
+}
+
+/*----------------------------------------------------------------
+ * Block state:
+ * __transition() handles transition of a block between different states.
+ * Study this to understand the state machine.
+ *
+ * Alternatively install graphviz and run:
+ *     grep DOT dm-block-manager.c | grep -v '	' |
+ *	 sed -e 's/.*DOT: //' -e 's/\*\///' |
+ *	 dot -Tps -o states.ps
+ *
+ * Assumes bm->lock is held.
+ *--------------------------------------------------------------*/
+static void __transition(struct dm_block *b, enum dm_block_state new_state)
+{
+	/* DOT: digraph BlockStates { */
+	struct dm_block_manager *bm = b->bm;
+
+	switch (new_state) {
+	case BS_EMPTY:
+		/* DOT: error -> empty */
+		/* DOT: clean -> empty */
+		BUG_ON(!((b->state == BS_ERROR) ||
+			 (b->state == BS_CLEAN)));
+		hlist_del(&b->hlist);
+		list_move(&b->list, &bm->empty_list);
+		b->write_lock_pending = 0;
+		b->read_lock_count = 0;
+		b->io_flags = 0;
+		b->validator = NULL;
+
+		if (b->state == BS_ERROR)
+			bm->available_count++;
+		break;
+
+	case BS_CLEAN:
+		/* DOT: reading -> clean */
+		/* DOT: writing -> clean */
+		/* DOT: read_locked -> clean */
+		BUG_ON(!((b->state == BS_READING) ||
+			 (b->state == BS_WRITING) ||
+			 (b->state == BS_READ_LOCKED)));
+		switch (b->state) {
+		case BS_READING:
+			BUG_ON(bm->reading_count == 0);
+			bm->reading_count--;
+			break;
+
+		case BS_WRITING:
+			BUG_ON(bm->writing_count == 0);
+			bm->writing_count--;
+			b->io_flags = 0;
+			break;
+
+		default:
+			break;
+		}
+		list_add_tail(&b->list, &bm->clean_list);
+		bm->available_count++;
+		break;
+
+	case BS_READING:
+		/* DOT: empty -> reading */
+		BUG_ON(!(b->state == BS_EMPTY));
+		/* FIXME: insert into the hash */
+		__insert_block(bm, b);
+		list_del(&b->list);
+		bm->available_count--;
+		bm->reading_count++;
+		break;
+
+	case BS_WRITING:
+		/* DOT: dirty -> writing */
+		BUG_ON(!(b->state == BS_DIRTY));
+		list_del(&b->list);
+		bm->writing_count++;
+		break;
+
+	case BS_READ_LOCKED:
+		/* DOT: clean -> read_locked */
+		BUG_ON(!(b->state == BS_CLEAN));
+		list_del(&b->list);
+		bm->available_count--;
+		break;
+
+	case BS_READ_LOCKED_DIRTY:
+		/* DOT: dirty -> read_locked_dirty */
+		BUG_ON(!((b->state == BS_DIRTY)));
+		list_del(&b->list);
+		break;
+
+	case BS_WRITE_LOCKED:
+		/* DOT: dirty -> write_locked */
+		/* DOT: clean -> write_locked */
+		BUG_ON(!((b->state == BS_DIRTY) ||
+			 (b->state == BS_CLEAN)));
+		list_del(&b->list);
+
+		if (b->state == BS_CLEAN)
+			bm->available_count--;
+		break;
+
+	case BS_DIRTY:
+		/* DOT: write_locked -> dirty */
+		/* DOT: read_locked_dirty -> dirty */
+		BUG_ON(!((b->state == BS_WRITE_LOCKED) ||
+			 (b->state == BS_READ_LOCKED_DIRTY)));
+		list_add_tail(&b->list, &bm->dirty_list);
+		break;
+
+	case BS_ERROR:
+		/* DOT: writing -> error */
+		/* DOT: reading -> error */
+		BUG_ON(!((b->state == BS_WRITING) ||
+			 (b->state == BS_READING)));
+		list_add_tail(&b->list, &bm->error_list);
+		break;
+	}
+
+	b->state = new_state;
+	/* DOT: } */
+}
+
+/*----------------------------------------------------------------
+ * low level io
+ *--------------------------------------------------------------*/
+typedef void (completion_fn)(unsigned long error, struct dm_block *b);
+
+static void submit_io(struct dm_block *b, int rw,
+		      completion_fn fn)
+{
+	struct dm_block_manager *bm = b->bm;
+	struct dm_io_request req;
+	struct dm_io_region region;
+	unsigned sectors_per_block = bm->block_size >> SECTOR_SHIFT;
+
+	region.bdev = bm->bdev;
+	region.sector = b->where * sectors_per_block;
+	region.count = sectors_per_block;
+
+	req.bi_rw = rw;
+	req.mem.type = DM_IO_KMEM;
+	req.mem.offset = 0;
+	req.mem.ptr.addr = b->data;
+	req.notify.fn = (void (*)(unsigned long, void *)) fn;
+	req.notify.context = b;
+	req.client = bm->io;
+
+	if (dm_io(&req, 1, &region, NULL) < 0)
+		fn(1, b);
+}
+
+/*----------------------------------------------------------------
+ * High level io
+ *--------------------------------------------------------------*/
+static void __complete_io(unsigned long error, struct dm_block *b)
+{
+	struct dm_block_manager *bm = b->bm;
+
+	if (error) {
+		DMERR("io error = %lu, block = %llu",
+		      error , (unsigned long long)b->where);
+		__transition(b, BS_ERROR);
+	} else
+		__transition(b, BS_CLEAN);
+
+	wake_up(&b->io_q);
+	wake_up(&bm->io_q);
+}
+
+static void complete_io(unsigned long error, struct dm_block *b)
+{
+	struct dm_block_manager *bm = b->bm;
+	unsigned long flags;
+
+	spin_lock_irqsave(&bm->lock, flags);
+	__complete_io(error, b);
+	spin_unlock_irqrestore(&bm->lock, flags);
+}
+
+static void read_block(struct dm_block *b)
+{
+	submit_io(b, READ, complete_io);
+}
+
+static void write_block(struct dm_block *b)
+{
+	if (b->validator)
+		b->validator->prepare_for_write(b->validator, b,
+						b->bm->block_size);
+
+	submit_io(b, WRITE | b->io_flags, complete_io);
+}
+
+static void write_dirty(struct dm_block_manager *bm, unsigned count)
+{
+	struct dm_block *b, *tmp;
+	struct list_head dirty;
+	unsigned long flags;
+
+	/* Grab the first |count| entries from the dirty list */
+	INIT_LIST_HEAD(&dirty);
+	spin_lock_irqsave(&bm->lock, flags);
+	list_for_each_entry_safe(b, tmp, &bm->dirty_list, list) {
+		if (count-- == 0)
+			break;
+		__transition(b, BS_WRITING);
+		list_add_tail(&b->list, &dirty);
+	}
+	spin_unlock_irqrestore(&bm->lock, flags);
+
+	list_for_each_entry_safe(b, tmp, &dirty, list) {
+		list_del(&b->list);
+		write_block(b);
+	}
+}
+
+static void write_all_dirty(struct dm_block_manager *bm)
+{
+	write_dirty(bm, bm->cache_size);
+}
+
+static void __clear_errors(struct dm_block_manager *bm)
+{
+	struct dm_block *b, *tmp;
+	list_for_each_entry_safe(b, tmp, &bm->error_list, list)
+		__transition(b, BS_EMPTY);
+}
+
+/*----------------------------------------------------------------
+ * Waiting
+ *--------------------------------------------------------------*/
+#ifdef __CHECKER__
+# define __retains(x)	__attribute__((context(x, 1, 1)))
+#else
+# define __retains(x)
+#endif
+
+#ifdef USE_PLUGGING
+static inline unplug(void)
+{
+	blk_flush_plug(current);
+}
+#else
+static inline void unplug(void) {}
+#endif
+
+#define __wait_block(wq, lock, flags, sched_fn, condition)	\
+do {								\
+	int ret = 0;						\
+								\
+	DEFINE_WAIT(wait);					\
+	add_wait_queue(wq, &wait);				\
+								\
+	for (;;) {						\
+		prepare_to_wait(wq, &wait, TASK_INTERRUPTIBLE); \
+		if (condition)					\
+			break;					\
+								\
+		spin_unlock_irqrestore(lock, flags);		\
+		if (signal_pending(current)) {			\
+			ret = -ERESTARTSYS;			\
+			spin_lock_irqsave(lock, flags);		\
+			break;					\
+		}						\
+								\
+		sched_fn();					\
+		spin_lock_irqsave(lock, flags);			\
+	}							\
+								\
+	finish_wait(wq, &wait);					\
+	return ret;						\
+} while (0)
+
+static int __wait_io(struct dm_block *b, unsigned long *flags)
+	__retains(&b->bm->lock)
+{
+	unplug();
+	__wait_block(&b->io_q, &b->bm->lock, *flags, io_schedule,
+		     ((b->state != BS_READING) && (b->state != BS_WRITING)));
+}
+
+static int __wait_unlocked(struct dm_block *b, unsigned long *flags)
+	__retains(&b->bm->lock)
+{
+	__wait_block(&b->io_q, &b->bm->lock, *flags, schedule,
+		     ((b->state == BS_CLEAN) || (b->state == BS_DIRTY)));
+}
+
+static int __wait_read_lockable(struct dm_block *b, unsigned long *flags)
+	__retains(&b->bm->lock)
+{
+	__wait_block(&b->io_q, &b->bm->lock, *flags, schedule,
+		     (!b->write_lock_pending && (b->state == BS_CLEAN ||
+						 b->state == BS_DIRTY ||
+						 b->state == BS_READ_LOCKED)));
+}
+
+static int __wait_all_writes(struct dm_block_manager *bm, unsigned long *flags)
+	__retains(&bm->lock)
+{
+	unplug();
+	__wait_block(&bm->io_q, &bm->lock, *flags, io_schedule,
+		     !bm->writing_count);
+}
+
+static int __wait_clean(struct dm_block_manager *bm, unsigned long *flags)
+	__retains(&bm->lock)
+{
+	unplug();
+	__wait_block(&bm->io_q, &bm->lock, *flags, io_schedule,
+		     (!list_empty(&bm->clean_list) ||
+		      (bm->writing_count == 0)));
+}
+
+/*----------------------------------------------------------------
+ * Finding a free block to recycle
+ *--------------------------------------------------------------*/
+static int recycle_block(struct dm_block_manager *bm, dm_block_t where,
+			 int need_read, struct dm_block_validator *v,
+			 struct dm_block **result)
+{
+	int ret = 0;
+	struct dm_block *b;
+	unsigned long flags, available;
+
+	/* wait for a block to appear on the empty or clean lists */
+	spin_lock_irqsave(&bm->lock, flags);
+	while (1) {
+		/*
+		 * Once we can lock and do io concurrently then we should
+		 * probably flush at bm->cache_size / 2 and write _all_
+		 * dirty blocks.
+		 */
+		available = bm->available_count + bm->writing_count;
+		if (available < bm->cache_size / 4) {
+			spin_unlock_irqrestore(&bm->lock, flags);
+			write_dirty(bm, bm->cache_size / 4);
+			spin_lock_irqsave(&bm->lock, flags);
+		}
+
+		if (!list_empty(&bm->empty_list)) {
+			b = list_first_entry(&bm->empty_list, struct dm_block, list);
+			break;
+
+		} else if (!list_empty(&bm->clean_list)) {
+			b = list_first_entry(&bm->clean_list, struct dm_block, list);
+			__transition(b, BS_EMPTY);
+			break;
+		}
+
+		__wait_clean(bm, &flags);
+	}
+
+	b->where = where;
+	b->validator = v;
+	__transition(b, BS_READING);
+
+	if (!need_read) {
+		memset(b->data, 0, bm->block_size);
+		__transition(b, BS_CLEAN);
+	} else {
+		spin_unlock_irqrestore(&bm->lock, flags);
+		read_block(b);
+		spin_lock_irqsave(&bm->lock, flags);
+		__wait_io(b, &flags);
+
+		/* FIXME: can |b| have been recycled between io completion and here ? */
+
+		/* did the io succeed ? */
+		if (b->state == BS_ERROR) {
+			/* Since this is a read that has failed we can
+			 * clear the error immediately.	 Failed writes are
+			 * revealed during a commit.
+			 */
+			__transition(b, BS_EMPTY);
+			ret = -EIO;
+		}
+
+		if (b->validator) {
+			ret = b->validator->check(b->validator, b, bm->block_size);
+			if (ret) {
+				DMERR("%s validator check failed for block %llu",
+				      b->validator->name, (unsigned long long)b->where);
+				__transition(b, BS_EMPTY);
+			}
+		}
+	}
+	spin_unlock_irqrestore(&bm->lock, flags);
+
+	if (ret == 0)
+		*result = b;
+	return ret;
+}
+
+#ifdef USE_PLUGGING
+static int recycle_block_with_plugging(struct dm_block_manager *bm,
+				       dm_block_t where, int need_read,
+				       struct dm_block_validator *v,
+				       struct dm_block **result)
+{
+	int r;
+	struct blk_plug plug;
+
+	blk_start_plug(&plug);
+	r = recycle_block(bm, where, need_read, v, result);
+	blk_finish_plug(&plug);
+
+	return r;
+}
+#endif
+
+/*----------------------------------------------------------------
+ * Low level block management
+ *--------------------------------------------------------------*/
+static void *align(void *ptr, size_t amount)
+{
+	size_t offset = (uint64_t) ptr & (amount - 1);
+	return offset ? ((unsigned char *) ptr) + (amount - offset) : ptr;
+}
+
+/* Alloc a page if block_size equals PAGE_SIZE or kmalloc it. */
+static void *_alloc_block(struct dm_block_manager *bm)
+{
+	void *r;
+
+	if (bm->block_size == PAGE_SIZE) {
+		struct page *p = alloc_page(GFP_KERNEL);
+		r = p ? page_address(p) : NULL;
+
+	} else
+		r = kmalloc(bm->block_size + SECTOR_SIZE, GFP_KERNEL);
+
+	return r;
+}
+
+static struct dm_block *alloc_block(struct dm_block_manager *bm)
+{
+	struct dm_block *b = kmalloc(sizeof(*b), GFP_KERNEL);
+	if (!b)
+		return NULL;
+
+	INIT_LIST_HEAD(&b->list);
+	INIT_HLIST_NODE(&b->hlist);
+
+	b->data_actual = _alloc_block(bm);
+	if (!b->data_actual) {
+		kfree(b);
+		return NULL;
+	}
+
+	b->validator = NULL;
+	b->data = align(b->data_actual, SECTOR_SIZE);
+	b->state = BS_EMPTY;
+	init_waitqueue_head(&b->io_q);
+	b->read_lock_count = 0;
+	b->write_lock_pending = 0;
+	b->io_flags = 0;
+	b->bm = bm;
+
+	return b;
+}
+
+static void free_block(struct dm_block *b)
+{
+	if (b->bm->block_size == PAGE_SIZE)
+		free_page((unsigned long) b->data_actual);
+	else
+		kfree(b->data_actual);
+
+	kfree(b);
+}
+
+static int populate_bm(struct dm_block_manager *bm, unsigned count)
+{
+	int i;
+	LIST_HEAD(bs);
+
+	for (i = 0; i < count; i++) {
+		struct dm_block *b = alloc_block(bm);
+		if (!b) {
+			struct dm_block *tmp;
+			list_for_each_entry_safe(b, tmp, &bs, list)
+				free_block(b);
+			return -ENOMEM;
+		}
+
+		list_add(&b->list, &bs);
+	}
+
+	list_replace(&bs, &bm->empty_list);
+	bm->available_count = count;
+
+	return 0;
+}
+
+/*----------------------------------------------------------------
+ * Public interface
+ *--------------------------------------------------------------*/
+static unsigned calc_hash_size(unsigned cache_size)
+{
+	unsigned r = 32;	/* minimum size is 16 */
+
+	while (r < cache_size)
+		r <<= 1;
+
+	return r >> 1;
+}
+
+struct dm_block_manager *
+dm_block_manager_create(struct block_device *bdev,
+			unsigned block_size, unsigned cache_size)
+{
+	unsigned i;
+	unsigned hash_size = calc_hash_size(cache_size);
+	size_t len = sizeof(struct dm_block_manager) +
+		sizeof(struct hlist_head) * hash_size;
+	struct dm_block_manager *bm;
+
+	bm = kmalloc(len, GFP_KERNEL);
+	if (!bm)
+		return NULL;
+	bm->bdev = bdev;
+	bm->cache_size = max(16u, cache_size);
+	bm->block_size = block_size;
+	bm->nr_blocks = i_size_read(bdev->bd_inode);
+	do_div(bm->nr_blocks, block_size);
+	init_waitqueue_head(&bm->io_q);
+	spin_lock_init(&bm->lock);
+
+	INIT_LIST_HEAD(&bm->empty_list);
+	INIT_LIST_HEAD(&bm->clean_list);
+	INIT_LIST_HEAD(&bm->dirty_list);
+	INIT_LIST_HEAD(&bm->error_list);
+	bm->available_count = 0;
+	bm->reading_count = 0;
+	bm->writing_count = 0;
+
+	bm->hash_size = hash_size;
+	bm->hash_mask = hash_size - 1;
+	for (i = 0; i < hash_size; i++)
+		INIT_HLIST_HEAD(bm->buckets + i);
+
+	bm->io = dm_io_client_create();
+	if (!bm->io) {
+		kfree(bm);
+		return NULL;
+	}
+
+	if (populate_bm(bm, cache_size) < 0) {
+		dm_io_client_destroy(bm->io);
+		kfree(bm);
+		return NULL;
+	}
+
+	return bm;
+}
+EXPORT_SYMBOL_GPL(dm_block_manager_create);
+
+void dm_block_manager_destroy(struct dm_block_manager *bm)
+{
+	int i;
+	struct dm_block *b, *btmp;
+	struct hlist_node *n, *tmp;
+
+	dm_io_client_destroy(bm->io);
+
+	for (i = 0; i < bm->hash_size; i++)
+		hlist_for_each_entry_safe(b, n, tmp, bm->buckets + i, hlist)
+			free_block(b);
+
+	list_for_each_entry_safe(b, btmp, &bm->empty_list, list)
+		free_block(b);
+
+	kfree(bm);
+}
+EXPORT_SYMBOL_GPL(dm_block_manager_destroy);
+
+unsigned dm_bm_block_size(struct dm_block_manager *bm)
+{
+	return bm->block_size;
+}
+EXPORT_SYMBOL_GPL(dm_bm_block_size);
+
+dm_block_t dm_bm_nr_blocks(struct dm_block_manager *bm)
+{
+	return bm->nr_blocks;
+}
+EXPORT_SYMBOL_GPL(dm_bm_nr_blocks);
+
+static int lock_internal(struct dm_block_manager *bm, dm_block_t block,
+			 int how, int need_read, int can_block,
+			 struct dm_block_validator *v,
+			 struct dm_block **result)
+{
+	int r = 0;
+	struct dm_block *b;
+	unsigned long flags;
+
+	spin_lock_irqsave(&bm->lock, flags);
+retry:
+	b = __find_block(bm, block);
+	if (b) {
+		if (need_read) {
+			if (b->validator && (v != b->validator)) {
+				DMERR("validator mismatch (old=%s vs new=%s) for block %llu",
+				      b->validator->name, v->name,
+				      (unsigned long long)b->where);
+				spin_unlock_irqrestore(&bm->lock, flags);
+				return -EINVAL;
+
+			} else if (!b->validator && v) {
+				b->validator = v;
+				r = b->validator->check(b->validator, b, bm->block_size);
+				if (r) {
+					DMERR("%s validator check failed for block %llu",
+					      b->validator->name,
+					      (unsigned long long)b->where);
+					spin_unlock_irqrestore(&bm->lock, flags);
+					return r;
+				}
+			}
+		} else
+			b->validator = v;
+
+		switch (how) {
+		case READ:
+			if (b->write_lock_pending || (b->state != BS_CLEAN &&
+						      b->state != BS_DIRTY &&
+						      b->state != BS_READ_LOCKED)) {
+				if (!can_block) {
+					spin_unlock_irqrestore(&bm->lock, flags);
+					return -EWOULDBLOCK;
+				}
+
+				__wait_read_lockable(b, &flags);
+
+				if (b->where != block)
+					goto retry;
+			}
+			break;
+
+		case WRITE:
+			while (b->state != BS_CLEAN && b->state != BS_DIRTY) {
+				if (!can_block) {
+					spin_unlock_irqrestore(&bm->lock, flags);
+					return -EWOULDBLOCK;
+				}
+
+				b->write_lock_pending++;
+				__wait_unlocked(b, &flags);
+				b->write_lock_pending--;
+				if (b->where != block)
+					goto retry;
+			}
+			break;
+		}
+
+	} else if (!can_block) {
+		r = -EWOULDBLOCK;
+		goto out;
+
+	} else {
+		spin_unlock_irqrestore(&bm->lock, flags);
+#ifdef USE_PLUGGING
+		r = recycle_block_with_plugging(bm, block, need_read, v, &b);
+#else
+		r = recycle_block(bm, block, need_read, v, &b);
+#endif
+		spin_lock_irqsave(&bm->lock, flags);
+	}
+
+	if (r == 0) {
+		switch (how) {
+		case READ:
+			b->read_lock_count++;
+
+			if (b->state == BS_DIRTY)
+				__transition(b, BS_READ_LOCKED_DIRTY);
+			else if (b->state == BS_CLEAN)
+				__transition(b, BS_READ_LOCKED);
+			break;
+
+		case WRITE:
+			__transition(b, BS_WRITE_LOCKED);
+			break;
+		}
+
+		*result = b;
+	}
+
+out:
+	spin_unlock_irqrestore(&bm->lock, flags);
+	return r;
+}
+
+int dm_bm_read_lock(struct dm_block_manager *bm, dm_block_t b,
+		    struct dm_block_validator *v,
+		    struct dm_block **result)
+{
+	return lock_internal(bm, b, READ, 1, 1, v, result);
+}
+EXPORT_SYMBOL_GPL(dm_bm_read_lock);
+
+int dm_bm_write_lock(struct dm_block_manager *bm,
+		     dm_block_t b, struct dm_block_validator *v,
+		     struct dm_block **result)
+{
+	return lock_internal(bm, b, WRITE, 1, 1, v, result);
+}
+EXPORT_SYMBOL_GPL(dm_bm_write_lock);
+
+int dm_bm_read_try_lock(struct dm_block_manager *bm,
+			dm_block_t b, struct dm_block_validator *v,
+			struct dm_block **result)
+{
+	return lock_internal(bm, b, READ, 1, 0, v, result);
+}
+EXPORT_SYMBOL_GPL(dm_bm_read_try_lock);
+
+int dm_bm_write_lock_zero(struct dm_block_manager *bm,
+			  dm_block_t b, struct dm_block_validator *v,
+			  struct dm_block **result)
+{
+	int r = lock_internal(bm, b, WRITE, 0, 1, v, result);
+	if (!r)
+		memset((*result)->data, 0, bm->block_size);
+	return r;
+}
+EXPORT_SYMBOL_GPL(dm_bm_write_lock_zero);
+
+int dm_bm_unlock(struct dm_block *b)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&b->bm->lock, flags);
+	switch (b->state) {
+	case BS_WRITE_LOCKED:
+		__transition(b, BS_DIRTY);
+		wake_up(&b->io_q);
+		break;
+
+	case BS_READ_LOCKED:
+		if (!--b->read_lock_count) {
+			__transition(b, BS_CLEAN);
+			wake_up(&b->io_q);
+		}
+		break;
+
+	case BS_READ_LOCKED_DIRTY:
+		if (!--b->read_lock_count) {
+			__transition(b, BS_DIRTY);
+			wake_up(&b->io_q);
+		}
+		break;
+
+	default:
+		DMERR("block = %llu not locked",
+		      (unsigned long long)b->where);
+		ret = -EINVAL;
+		break;
+	}
+	spin_unlock_irqrestore(&b->bm->lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dm_bm_unlock);
+
+static int __wait_flush(struct dm_block_manager *bm)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&bm->lock, flags);
+	__wait_all_writes(bm, &flags);
+
+	if (!list_empty(&bm->error_list)) {
+		ret = -EIO;
+		__clear_errors(bm);
+	}
+	spin_unlock_irqrestore(&bm->lock, flags);
+
+	return ret;
+}
+
+int dm_bm_flush_and_unlock(struct dm_block_manager *bm,
+			   struct dm_block *superblock)
+{
+	int r;
+	unsigned long flags;
+
+	write_all_dirty(bm);
+	r = __wait_flush(bm);
+	if (r)
+		return r;
+
+	spin_lock_irqsave(&bm->lock, flags);
+	superblock->io_flags = REQ_FUA | REQ_FLUSH;
+	spin_unlock_irqrestore(&bm->lock, flags);
+
+	dm_bm_unlock(superblock);
+	write_all_dirty(bm);
+
+	return __wait_flush(bm);
+}
+EXPORT_SYMBOL_GPL(dm_bm_flush_and_unlock);
+
+/*----------------------------------------------------------------*/
diff --git a/drivers/md/persistent-data/dm-block-manager.h b/drivers/md/persistent-data/dm-block-manager.h
new file mode 100644
index 0000000..55b96cb
--- /dev/null
+++ b/drivers/md/persistent-data/dm-block-manager.h
@@ -0,0 +1,110 @@
+#ifndef DM_BLOCK_MANAGER_H
+#define DM_BLOCK_MANAGER_H
+
+#include <linux/blkdev.h>
+#include <linux/types.h>
+#include <linux/crc32c.h>
+
+/*----------------------------------------------------------------*/
+
+typedef uint64_t dm_block_t;
+
+/* An opaque handle to a block of data */
+struct dm_block;
+dm_block_t dm_block_location(struct dm_block *b);
+void *dm_block_data(struct dm_block *b);
+
+static inline __le32 dm_block_csum_data(const void *data, unsigned int length)
+{
+	return __cpu_to_le32(crc32c(~(u32)0, data, length));
+}
+
+/*----------------------------------------------------------------*/
+
+struct dm_block_manager;
+struct dm_block_manager *
+dm_block_manager_create(struct block_device *bdev, unsigned block_size,
+			unsigned cache_size);
+void dm_block_manager_destroy(struct dm_block_manager *bm);
+
+unsigned dm_bm_block_size(struct dm_block_manager *bm);
+dm_block_t dm_bm_nr_blocks(struct dm_block_manager *bm);
+
+/*----------------------------------------------------------------*/
+
+/* 4 bytes for CRC32c */
+#define PERSISTENT_DATA_CSUM_SIZE 4
+
+/*
+ * The validator allows the caller to verify newly read data, and modify
+ * the data just before writing.  eg, to calculate checksums.  It's
+ * important to be consistent with your use of validators.  The only time
+ * you can change validators is if you call dm_bm_write_lock_zero.
+ */
+struct dm_block_validator {
+	const char *name;
+	void (*prepare_for_write)(struct dm_block_validator *v, struct dm_block *b, size_t block_size);
+
+	/* return 0 if valid, < 0 on error */
+	int (*check)(struct dm_block_validator *v, struct dm_block *b, size_t block_size);
+};
+
+/*----------------------------------------------------------------*/
+
+/*
+ * You can have multiple concurrent readers, or a single writer holding a
+ * block lock.
+ */
+
+/*
+ * dm_bm_lock() locks a block, and returns via |data| a pointer to memory that
+ * holds a copy of that block.  If you have write locked the block then any
+ * changes you make to memory pointed to by |data| will be written back to
+ * the disk sometime after dm_bm_unlock is called.
+ */
+int dm_bm_read_lock(struct dm_block_manager *bm, dm_block_t b,
+		    struct dm_block_validator *v,
+		    struct dm_block **result);
+
+int dm_bm_write_lock(struct dm_block_manager *bm, dm_block_t b,
+		     struct dm_block_validator *v,
+		     struct dm_block **result);
+
+/*
+ * The *_try_lock variants return -EWOULDBLOCK if the block isn't
+ * immediately available.
+ */
+int dm_bm_read_try_lock(struct dm_block_manager *bm, dm_block_t b,
+			struct dm_block_validator *v,
+			struct dm_block **result);
+
+/*
+ * dm_bm_write_lock_zero() is for use when you know you're going to completely
+ * overwrite the block.  It saves a disk read.
+ */
+int dm_bm_write_lock_zero(struct dm_block_manager *bm, dm_block_t b,
+			  struct dm_block_validator *v,
+			  struct dm_block **result);
+
+int dm_bm_unlock(struct dm_block *b);
+
+/*
+ * It's a common idiom to have a superblock that should be committed last.
+ *
+ * |superblock| should be write locked, it will be unlocked during this
+ * function.  All dirty blocks are guaranteed to be written and flushed
+ * before the superblock.
+ *
+ * This method always blocks.
+ */
+int dm_bm_flush_and_unlock(struct dm_block_manager *bm,
+			   struct dm_block *superblock);
+
+/*
+ * Debug routines.
+ */
+unsigned dm_bm_locks_held(struct dm_block_manager *bm);
+
+/*----------------------------------------------------------------*/
+
+#endif
diff --git a/drivers/md/persistent-data/dm-btree-internal.h b/drivers/md/persistent-data/dm-btree-internal.h
new file mode 100644
index 0000000..be688a1
--- /dev/null
+++ b/drivers/md/persistent-data/dm-btree-internal.h
@@ -0,0 +1,141 @@
+#ifndef DM_BTREE_INTERNAL_H
+#define DM_BTREE_INTERNAL_H
+
+#include "dm-btree.h"
+
+#include <linux/list.h>
+
+/*----------------------------------------------------------------*/
+
+/* TODO: move all this into btree.c */
+/*
+ * We'll need 2 accessor functions for n->csum and n->blocknr
+ * to support dm-btree-spine.c in that case.
+ */
+
+enum node_flags {
+	INTERNAL_NODE = 1,
+	LEAF_NODE = 1 << 1
+};
+
+/*
+ * To ease coding I'm packing all the different node types into one
+ * structure.  We can optimise later.
+ */
+struct node_header {
+	__le32 csum;
+	__le32 flags;
+	__le64 blocknr; /* which block this node is supposed to live in */
+
+	__le32 nr_entries;
+	__le32 max_entries;
+} __packed;
+
+struct node {
+	struct node_header header;
+	__le64 keys[0];
+} __packed;
+
+
+/*
+ * Based on the ideas in ["B-trees, Shadowing, and Clones" Ohad Rodeh]
+ */
+
+/* FIXME: enable close packing for on disk structures */
+
+void inc_children(struct dm_transaction_manager *tm, struct node *n,
+		  struct dm_btree_value_type *vt);
+
+/* FIXME: change bn_ prefix for these, refers to an old struct block_node */
+int bn_read_lock(struct dm_btree_info *info, dm_block_t b,
+		 struct dm_block **result);
+int bn_shadow(struct dm_btree_info *info, dm_block_t orig,
+	      struct dm_btree_value_type *vt, struct dm_block **result, int *inc);
+int bn_new_block(struct dm_btree_info *info, struct dm_block **result);
+int bn_unlock(struct dm_btree_info *info, struct dm_block *b);
+
+/*
+ * Spines keep track of the rolling locks.  There are 2 variants, read-only
+ * and one that uses shadowing.  These are separate structs to allow the
+ * type checker to spot misuse, for example accidentally calling read_lock
+ * on a shadow spine.
+ */
+struct ro_spine {
+	struct dm_btree_info *info;
+
+	int count;
+	struct dm_block *nodes[2];
+};
+
+void init_ro_spine(struct ro_spine *s, struct dm_btree_info *info);
+int exit_ro_spine(struct ro_spine *s);
+int ro_step(struct ro_spine *s, dm_block_t new_child);
+struct node *ro_node(struct ro_spine *s);
+
+struct shadow_spine {
+	struct dm_btree_info *info;
+
+	int count;
+	struct dm_block *nodes[2];
+
+	dm_block_t root;
+};
+
+void init_shadow_spine(struct shadow_spine *s, struct dm_btree_info *info);
+int exit_shadow_spine(struct shadow_spine *s);
+
+int shadow_step(struct shadow_spine *s, dm_block_t b,
+		struct dm_btree_value_type *vt, int *inc);
+
+struct dm_block *shadow_current(struct shadow_spine *s);
+
+struct dm_block *shadow_parent(struct shadow_spine *s);
+
+int shadow_root(struct shadow_spine *s);
+
+/*
+ * Some inlines.
+ */
+static inline __le64 *key_ptr(struct node *n, uint32_t index)
+{
+	return n->keys + index;
+}
+
+static inline void *value_base(struct node *n)
+{
+	return &n->keys[__le32_to_cpu(n->header.max_entries)];
+}
+
+static inline void *value_ptr(struct node *n, uint32_t index, size_t value_size)
+{
+	return value_base(n) + (value_size * index);
+}
+
+/* assumes the values are suitably aligned and converts to core format */
+static inline uint64_t value64(struct node *n, uint32_t index)
+{
+	__le64 *values = value_base(n);
+	return __le64_to_cpu(values[index]);
+}
+
+/* searching for a key within a single node */
+int lower_bound(struct node *n, uint64_t key);
+
+int upper_bound(struct node *n, uint64_t key);
+
+/*
+ * Exported for testing.
+ */
+uint32_t calc_max_entries(size_t value_size, size_t block_size);
+
+void insert_at(size_t value_size, struct node *node,
+	       unsigned index, uint64_t key, void *value);
+
+int dm_btree_merge(struct shadow_spine *s, unsigned parent_index,
+		   size_t value_size);
+
+extern struct dm_block_validator btree_node_validator;
+
+/*----------------------------------------------------------------*/
+
+#endif
diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/persistent-data/dm-btree-remove.c
new file mode 100644
index 0000000..4b616e3
--- /dev/null
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -0,0 +1,540 @@
+#include "dm-btree.h"
+#include "dm-btree-internal.h"
+
+/*
+ * Removing an entry from a btree
+ * ==============================
+ *
+ * A very important constraint for our btree is that no node, except the
+ * root, may have fewer than a certain number of entries.
+ * (MIN_ENTRIES <= nr_entries <= MAX_ENTRIES).
+ *
+ * Ensuring this is complicated by the way we want to only ever hold the
+ * locks on 2 nodes concurrently, and only change nodes in a top to bottom
+ * fashion.
+ *
+ * Each node may have a left or right sibling.  When decending the spine,
+ * if a node contains only MIN_ENTRIES then we try and increase this to at
+ * least MIN_ENTRIES + 1.  We do this in the following ways:
+ *
+ * [A] No siblings => this can only happen if the node is the root, in which
+ *     case we copy the childs contents over the root.
+ *
+ * [B] No left sibling
+ *     ==> rebalance(node, right sibling)
+ *
+ * [C] No right sibling
+ *     ==> rebalance(left sibling, node)
+ *
+ * [D] Both siblings, total_entries(left, node, right) <= DEL_THRESHOLD
+ *     ==> delete node adding it's contents to left and right
+ *
+ * [E] Both siblings, total_entries(left, node, right) > DEL_THRESHOLD
+ *     ==> rebalance(left, node, right)
+ *
+ * After these operations it's possible that the our original node no
+ * longer contains the desired sub tree.  For this reason this rebalancing
+ * is performed on the children of the current node.  This also avoids
+ * having a special case for the root.
+ *
+ * Once this rebalancing has occurred we can then step into the child node
+ * for internal nodes.  Or delete the entry for leaf nodes.
+ */
+
+/*
+ * Some little utilities for moving node data around.
+ */
+static void node_shift(struct node *n, int shift)
+{
+	uint32_t nr_entries = __le32_to_cpu(n->header.nr_entries);
+
+	if (shift < 0) {
+		shift = -shift;
+		memmove(key_ptr(n, 0),
+			key_ptr(n, shift),
+			(nr_entries - shift) * sizeof(__le64));
+		memmove(value_ptr(n, 0, sizeof(__le64)),
+			value_ptr(n, shift, sizeof(__le64)),
+			(nr_entries - shift) * sizeof(__le64));
+	} else {
+		memmove(key_ptr(n, shift),
+			key_ptr(n, 0),
+			nr_entries * sizeof(__le64));
+		memmove(value_ptr(n, shift, sizeof(__le64)),
+			value_ptr(n, 0, sizeof(__le64)),
+			nr_entries * sizeof(__le64));
+	}
+}
+
+static void node_copy(struct node *left, struct node *right, int shift)
+{
+	uint32_t nr_left = __le32_to_cpu(left->header.nr_entries);
+
+	if (shift < 0) {
+		shift = -shift;
+		memcpy(key_ptr(left, nr_left),
+		       key_ptr(right, 0),
+		       shift * sizeof(__le64));
+		memcpy(value_ptr(left, nr_left, sizeof(__le64)),
+		       value_ptr(right, 0, sizeof(__le64)),
+		       shift * sizeof(__le64));
+	} else {
+		memcpy(key_ptr(right, 0),
+		       key_ptr(left, nr_left - shift),
+		       shift * sizeof(__le64));
+		memcpy(value_ptr(right, 0, sizeof(__le64)),
+		       value_ptr(left, nr_left - shift, sizeof(__le64)),
+		       shift * sizeof(__le64));
+	}
+}
+
+/*
+ * Delete a specific entry from a leaf node.
+ */
+static void delete_at(struct node *n, unsigned index, size_t value_size)
+{
+	unsigned nr_entries = __le32_to_cpu(n->header.nr_entries);
+	unsigned nr_to_copy = nr_entries - (index + 1);
+
+	if (nr_to_copy) {
+		memmove(key_ptr(n, index),
+			key_ptr(n, index + 1),
+			nr_to_copy * sizeof(__le64));
+
+		memmove(value_ptr(n, index, value_size),
+			value_ptr(n, index + 1, value_size),
+			nr_to_copy * value_size);
+	}
+
+	n->header.nr_entries = __cpu_to_le32(nr_entries - 1);
+}
+
+static unsigned del_threshold(struct node *n)
+{
+	return __le32_to_cpu(n->header.max_entries) / 3;
+}
+
+static unsigned merge_threshold(struct node *n)
+{
+	/*
+	 * The extra one is because we know we're potentially going to
+	 * delete an entry.
+	 */
+	return 2 * (__le32_to_cpu(n->header.max_entries) / 3) + 1;
+}
+
+struct child {
+	unsigned index;
+	struct dm_block *block;
+	struct node *n;
+};
+
+static struct dm_btree_value_type le64_type_ = {
+	.context = NULL,
+	.size = sizeof(__le64),
+	.inc = NULL,
+	.dec = NULL,
+	.equal = NULL
+};
+
+static int init_child(struct dm_btree_info *info, struct node *parent,
+		      unsigned index, struct child *result)
+{
+	int r, inc;
+	dm_block_t root;
+
+	result->index = index;
+	root = value64(parent, index);
+
+	r = dm_tm_shadow_block(info->tm, root, &btree_node_validator,
+			       &result->block, &inc);
+	if (r)
+		return r;
+
+	result->n = dm_block_data(result->block);
+	if (inc)
+		inc_children(info->tm, result->n, &le64_type_);
+	return 0;
+}
+
+static int exit_child(struct dm_btree_info *info, struct child *c)
+{
+	return dm_tm_unlock(info->tm, c->block);
+}
+
+static void shift(struct node *left, struct node *right, int count)
+{
+	if (count == 0)
+		return;
+
+	if (count > 0) {
+		node_shift(right, count);
+		node_copy(left, right, count);
+
+	} else {
+		node_copy(left, right, count);
+		node_shift(right, count);
+	}
+
+	left->header.nr_entries =
+		__cpu_to_le32(__le32_to_cpu(left->header.nr_entries) - count);
+	right->header.nr_entries =
+		__cpu_to_le32(__le32_to_cpu(right->header.nr_entries) + count);
+}
+
+static void __rebalance2(struct dm_btree_info *info, struct node *parent,
+			 struct child *l, struct child *r)
+{
+	struct node *left = l->n;
+	struct node *right = r->n;
+	uint32_t nr_left = __le32_to_cpu(left->header.nr_entries);
+	uint32_t nr_right = __le32_to_cpu(right->header.nr_entries);
+
+	if (nr_left + nr_right <= merge_threshold(left)) {
+		/* merge */
+		node_copy(left, right, -nr_right);
+		left->header.nr_entries = __cpu_to_le32(nr_left + nr_right);
+
+		*((__le64 *) value_ptr(parent, l->index, sizeof(__le64))) =
+			__cpu_to_le64(dm_block_location(l->block));
+		delete_at(parent, r->index, sizeof(__le64));
+
+		/*
+		 * We need to decrement the right block, but not it's
+		 * children, since they're still referenced by @left
+		 */
+		dm_tm_dec(info->tm, dm_block_location(r->block));
+
+	} else {
+		/* rebalance */
+		unsigned target_left = (nr_left + nr_right) / 2;
+		shift(left, right, nr_left - target_left);
+		*((__le64 *) value_ptr(parent, l->index, sizeof(__le64))) =
+			__cpu_to_le64(dm_block_location(l->block));
+		*((__le64 *) value_ptr(parent, r->index, sizeof(__le64))) =
+			__cpu_to_le64(dm_block_location(r->block));
+		*key_ptr(parent, r->index) = right->keys[0];
+	}
+}
+
+static int rebalance2(struct shadow_spine *s, struct dm_btree_info *info,
+		      unsigned left_index)
+{
+	int r;
+	struct node *parent;
+	struct child left, right;
+
+	parent = dm_block_data(shadow_current(s));
+
+	r = init_child(info, parent, left_index, &left);
+	if (r)
+		return r;
+
+	r = init_child(info, parent, left_index + 1, &right);
+	if (r) {
+		exit_child(info, &left);
+		return r;
+	}
+
+	__rebalance2(info, parent, &left, &right);
+
+	r = exit_child(info, &left);
+	if (r) {
+		exit_child(info, &right);
+		return r;
+	}
+
+	r = exit_child(info, &right);
+	if (r)
+		return r;
+
+	return 0;
+}
+
+static void __rebalance3(struct dm_btree_info *info, struct node *parent,
+			 struct child *l, struct child *c, struct child *r)
+{
+	struct node *left = l->n;
+	struct node *center = c->n;
+	struct node *right = r->n;
+
+	uint32_t nr_left = __le32_to_cpu(left->header.nr_entries);
+	uint32_t nr_center = __le32_to_cpu(center->header.nr_entries);
+	uint32_t nr_right = __le32_to_cpu(right->header.nr_entries);
+	uint32_t max_entries = __le32_to_cpu(left->header.max_entries);
+
+	if (((nr_left + nr_center + nr_right) / 2) < merge_threshold(center)) {
+		/* delete center node:
+		 *
+		 * We dump as many entries from center as possible into
+		 * left, then the rest in right, then rebalance2.  This
+		 * wastes some cpu, but I want something simple atm.
+		 */
+
+		unsigned shift = min(max_entries - nr_left, nr_center);
+		node_copy(left, center, -shift);
+		left->header.nr_entries = __cpu_to_le32(nr_left + shift);
+
+		if (shift != nr_center) {
+			shift = nr_center - shift;
+			node_shift(right, shift);
+			node_copy(center, right, shift);
+			right->header.nr_entries = __cpu_to_le32(nr_right + shift);
+		}
+
+		*((__le64 *) value_ptr(parent, l->index, sizeof(__le64))) =
+			__cpu_to_le64(dm_block_location(l->block));
+		*((__le64 *) value_ptr(parent, r->index, sizeof(__le64))) =
+			__cpu_to_le64(dm_block_location(r->block));
+		*key_ptr(parent, r->index) = right->keys[0];
+
+		delete_at(parent, c->index, sizeof(__le64));
+		r->index--;
+
+		dm_tm_dec(info->tm, dm_block_location(c->block));
+		__rebalance2(info, parent, l, r);
+
+	} else {
+		/* rebalance */
+		unsigned target = (nr_left + nr_center + nr_right) / 3;
+		BUG_ON(target == nr_center);
+
+		/* adjust the left node */
+		shift(left, center, nr_left - target);
+
+		/* adjust the right node */
+		shift(center, right, target - nr_right);
+
+		*((__le64 *) value_ptr(parent, l->index, sizeof(__le64))) =
+			__cpu_to_le64(dm_block_location(l->block));
+		*((__le64 *) value_ptr(parent, c->index, sizeof(__le64))) =
+			__cpu_to_le64(dm_block_location(c->block));
+		*((__le64 *) value_ptr(parent, r->index, sizeof(__le64))) =
+			__cpu_to_le64(dm_block_location(r->block));
+
+		*key_ptr(parent, c->index) = center->keys[0];
+		*key_ptr(parent, r->index) = right->keys[0];
+	}
+}
+
+static int rebalance3(struct shadow_spine *s, struct dm_btree_info *info,
+		      unsigned left_index)
+{
+	int r;
+	struct node *parent = dm_block_data(shadow_current(s));
+	struct child left, center, right;
+
+	/* FIXME: fill out an array? */
+	r = init_child(info, parent, left_index, &left);
+	if (r)
+		return r;
+
+	r = init_child(info, parent, left_index + 1, &center);
+	if (r) {
+		exit_child(info, &left);
+		return r;
+	}
+
+	r = init_child(info, parent, left_index + 2, &right);
+	if (r) {
+		exit_child(info, &left);
+		exit_child(info, &center);
+		return r;
+	}
+
+	__rebalance3(info, parent, &left, &center, &right);
+
+	r = exit_child(info, &left);
+	if (r) {
+		exit_child(info, &center);
+		exit_child(info, &right);
+		return r;
+	}
+
+	r = exit_child(info, &center);
+	if (r) {
+		exit_child(info, &right);
+		return r;
+	}
+
+	r = exit_child(info, &right);
+	if (r)
+		return r;
+
+	return 0;
+}
+
+static int get_nr_entries(struct dm_transaction_manager *tm,
+			  dm_block_t b, uint32_t *result)
+{
+	int r;
+	struct dm_block *block;
+	struct node *c;
+
+	r = dm_tm_read_lock(tm, b, &btree_node_validator, &block);
+	if (r)
+		return r;
+
+	c = dm_block_data(block);
+	*result = __le32_to_cpu(c->header.nr_entries);
+
+	return dm_tm_unlock(tm, block);
+}
+
+static int rebalance_children(struct shadow_spine *s,
+			      struct dm_btree_info *info, uint64_t key)
+{
+	int i, r, has_left_sibling, has_right_sibling;
+	uint32_t child_entries;
+	struct node *n;
+
+	n = dm_block_data(shadow_current(s));
+
+	if (__le32_to_cpu(n->header.nr_entries) == 1) {
+		struct dm_block *child;
+		dm_block_t b = value64(n, 0);
+
+		r = dm_tm_read_lock(info->tm, b, &btree_node_validator, &child);
+		if (r)
+			return r;
+
+		memcpy(n, dm_block_data(child),
+		       dm_bm_block_size(dm_tm_get_bm(info->tm)));
+		r = dm_tm_unlock(info->tm, child);
+		dm_tm_dec(info->tm, dm_block_location(child));
+
+	} else {
+		i = lower_bound(n, key);
+
+		if (i < 0)
+			return -ENODATA;
+
+		r = get_nr_entries(info->tm, value64(n, i), &child_entries);
+		if (r)
+			return r;
+
+		if (child_entries > del_threshold(n))
+			return 0;
+
+		has_left_sibling = i > 0 ? 1 : 0;
+		has_right_sibling =
+			(i >= (__le32_to_cpu(n->header.nr_entries) - 1)) ? 0 : 1;
+
+		if (!has_left_sibling)
+			r = rebalance2(s, info, i);
+
+		else if (!has_right_sibling)
+			r = rebalance2(s, info, i - 1);
+
+		else
+			r = rebalance3(s, info, i - 1);
+	}
+
+	return r;
+}
+
+static int do_leaf(struct node *n, uint64_t key, unsigned *index)
+{
+	int i = lower_bound(n, key);
+
+	if ((i < 0) ||
+	    (i >= __le32_to_cpu(n->header.nr_entries)) ||
+	    (__le64_to_cpu(n->keys[i]) != key))
+		return -ENODATA;
+
+	*index = i;
+	return 0;
+}
+
+/*
+ * Prepares for removal from one level of the hierarchy.  The caller must
+ * actually call delete_at() to remove the entry at index.
+ */
+static int remove_raw(struct shadow_spine *s, struct dm_btree_info *info,
+		      struct dm_btree_value_type *vt, dm_block_t root,
+		      uint64_t key, unsigned *index)
+{
+	int i = *index, inc, r;
+	struct node *n;
+
+	for (;;) {
+		r = shadow_step(s, root, vt, &inc);
+		if (r < 0)
+			break;
+
+		/* We have to patch up the parent node, ugly, but I don't
+		 * see a way to do this automatically as part of the spine
+		 * op. */
+		if (shadow_parent(s)) {
+			__le64 location = __cpu_to_le64(dm_block_location(shadow_current(s)));
+			memcpy(value_ptr(dm_block_data(shadow_parent(s)), i, sizeof(uint64_t)),
+			       &location, sizeof(__le64));
+		}
+
+		n = dm_block_data(shadow_current(s));
+		if (inc)
+			inc_children(info->tm, n, vt);
+
+		if (__le32_to_cpu(n->header.flags) & LEAF_NODE)
+			return do_leaf(n, key, index);
+
+		else {
+			r = rebalance_children(s, info, key);
+			if (r)
+				break;
+
+			n = dm_block_data(shadow_current(s));
+			if (__le32_to_cpu(n->header.flags) & LEAF_NODE)
+				return do_leaf(n, key, index);
+
+			i = lower_bound(n, key);
+
+			/* We know the key is present, or else
+			 * rebalance_children would have returned
+			 * -ENODATA
+			 */
+			root = value64(n, i);
+		}
+	}
+
+	return r;
+}
+
+int dm_btree_remove(struct dm_btree_info *info, dm_block_t root,
+		    uint64_t *keys, dm_block_t *new_root)
+{
+	unsigned level, last_level = info->levels - 1;
+	int index = 0, r = 0;
+	struct shadow_spine spine;
+	struct node *n;
+
+	init_shadow_spine(&spine, info);
+	for (level = 0; level < info->levels; level++) {
+		r = remove_raw(&spine, info,
+			       (level == last_level ?
+				&info->value_type : &le64_type_),
+			       root, keys[level], &index);
+		if (r < 0)
+			break;
+
+		n = dm_block_data(shadow_current(&spine));
+		if (level == last_level) {
+			BUG_ON(index < 0 ||
+			       index >= __le32_to_cpu(n->header.nr_entries));
+			if (info->value_type.dec)
+				info->value_type.dec(info->value_type.context,
+						     value_ptr(n, index, info->value_type.size));
+			delete_at(n, index, info->value_type.size);
+			r = 0;
+			*new_root = shadow_root(&spine);
+
+		} else
+			root = value64(n, index);
+	}
+	exit_shadow_spine(&spine);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(dm_btree_remove);
+
+/*----------------------------------------------------------------*/
diff --git a/drivers/md/persistent-data/dm-btree-spine.c b/drivers/md/persistent-data/dm-btree-spine.c
new file mode 100644
index 0000000..cacdfda
--- /dev/null
+++ b/drivers/md/persistent-data/dm-btree-spine.c
@@ -0,0 +1,192 @@
+#include "dm-btree-internal.h"
+
+#include <linux/device-mapper.h> /* For DMERR */
+
+#define DM_MSG_PREFIX "btree spine"
+
+/*----------------------------------------------------------------*/
+
+static void node_prepare_for_write(struct dm_block_validator *v,
+				   struct dm_block *b,
+				   size_t block_size)
+{
+	struct node_header *node = dm_block_data(b);
+
+	node->blocknr = __cpu_to_le64(dm_block_location(b));
+	node->csum = dm_block_csum_data(&node->flags,
+					block_size - sizeof(u32));
+}
+
+static int node_check(struct dm_block_validator *v,
+		      struct dm_block *b,
+		      size_t block_size)
+{
+	struct node_header *node = dm_block_data(b);
+	__le32 csum;
+
+	if (dm_block_location(b) != __le64_to_cpu(node->blocknr)) {
+		DMERR("node_check failed blocknr %llu wanted %llu",
+		      __le64_to_cpu(node->blocknr), dm_block_location(b));
+		return -ENOTBLK;
+	}
+
+	csum = dm_block_csum_data(&node->flags,
+				  block_size - sizeof(u32));
+	if (csum != node->csum) {
+		DMERR("node_check failed csum %u wanted %u",
+		      __le32_to_cpu(csum), __le32_to_cpu(node->csum));
+		return -EILSEQ;
+	}
+
+	return 0;
+}
+
+struct dm_block_validator btree_node_validator = {
+	.name = "btree_node",
+	.prepare_for_write = node_prepare_for_write,
+	.check = node_check
+};
+
+/*----------------------------------------------------------------*/
+
+int bn_read_lock(struct dm_btree_info *info, dm_block_t b,
+		 struct dm_block **result)
+{
+	return dm_tm_read_lock(info->tm, b, &btree_node_validator, result);
+}
+
+int bn_shadow(struct dm_btree_info *info, dm_block_t orig,
+	      struct dm_btree_value_type *vt,
+	      struct dm_block **result, int *inc)
+{
+	int r;
+
+	r = dm_tm_shadow_block(info->tm, orig, &btree_node_validator,
+			       result, inc);
+	if (r == 0 && *inc)
+		inc_children(info->tm, dm_block_data(*result), vt);
+
+	return r;
+}
+
+int bn_new_block(struct dm_btree_info *info, struct dm_block **result)
+{
+	return dm_tm_new_block(info->tm, &btree_node_validator, result);
+}
+
+int bn_unlock(struct dm_btree_info *info, struct dm_block *b)
+{
+	return dm_tm_unlock(info->tm, b);
+}
+
+/*----------------------------------------------------------------*/
+
+void init_ro_spine(struct ro_spine *s, struct dm_btree_info *info)
+{
+	s->info = info;
+	s->count = 0;
+	s->nodes[0] = NULL;
+	s->nodes[1] = NULL;
+}
+
+int exit_ro_spine(struct ro_spine *s)
+{
+	int r = 0, i;
+
+	for (i = 0; i < s->count; i++) {
+		int r2 = bn_unlock(s->info, s->nodes[i]);
+		if (r2 < 0)
+			r = r2;
+	}
+
+	return r;
+}
+
+int ro_step(struct ro_spine *s, dm_block_t new_child)
+{
+	int r;
+
+	if (s->count == 2) {
+		r = bn_unlock(s->info, s->nodes[0]);
+		if (r < 0)
+			return r;
+		s->nodes[0] = s->nodes[1];
+		s->count--;
+	}
+
+	r = bn_read_lock(s->info, new_child, s->nodes + s->count);
+	if (r == 0)
+		s->count++;
+
+	return r;
+}
+
+struct node *ro_node(struct ro_spine *s)
+{
+	struct dm_block *n;
+	BUG_ON(!s->count);
+	n = s->nodes[s->count - 1];
+	return dm_block_data(n);
+}
+
+/*----------------------------------------------------------------*/
+
+void init_shadow_spine(struct shadow_spine *s, struct dm_btree_info *info)
+{
+	s->info = info;
+	s->count = 0;
+}
+
+int exit_shadow_spine(struct shadow_spine *s)
+{
+	int r = 0, i;
+
+	for (i = 0; i < s->count; i++) {
+		int r2 = bn_unlock(s->info, s->nodes[i]);
+		if (r2 < 0)
+			r = r2;
+	}
+
+	return r;
+}
+
+int shadow_step(struct shadow_spine *s, dm_block_t b,
+		struct dm_btree_value_type *vt, int *inc)
+{
+	int r;
+
+	if (s->count == 2) {
+		r = bn_unlock(s->info, s->nodes[0]);
+		if (r < 0)
+			return r;
+		s->nodes[0] = s->nodes[1];
+		s->count--;
+	}
+
+	r = bn_shadow(s->info, b, vt, s->nodes + s->count, inc);
+	if (r == 0) {
+		if (s->count == 0)
+			s->root = dm_block_location(s->nodes[0]);
+
+		s->count++;
+	}
+
+	return r;
+}
+
+struct dm_block *shadow_current(struct shadow_spine *s)
+{
+	return s->nodes[s->count - 1];
+}
+
+struct dm_block *shadow_parent(struct shadow_spine *s)
+{
+	return s->count == 2 ? s->nodes[0] : NULL;
+}
+
+int shadow_root(struct shadow_spine *s)
+{
+	return s->root;
+}
+
+/*----------------------------------------------------------------*/
diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
new file mode 100644
index 0000000..7ec3dcd
--- /dev/null
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -0,0 +1,871 @@
+#include "dm-btree-internal.h"
+#include "dm-space-map.h"
+
+/*----------------------------------------------------------------
+ * Array manipulation
+ *--------------------------------------------------------------*/
+static void array_insert(void *base, size_t elt_size, unsigned nr_elts,
+			 unsigned index, void *elt)
+{
+	if (index < nr_elts)
+		memmove(base + (elt_size * (index + 1)),
+			base + (elt_size * index),
+			(nr_elts - index) * elt_size);
+	memcpy(base + (elt_size * index), elt, elt_size);
+}
+
+/*----------------------------------------------------------------*/
+
+/* makes the assumption that no two keys are the same. */
+static int bsearch(struct node *n, uint64_t key, int want_hi)
+{
+	int lo = -1, hi = __le32_to_cpu(n->header.nr_entries);
+
+	while (hi - lo > 1) {
+		int mid = lo + ((hi - lo) / 2);
+		uint64_t mid_key = __le64_to_cpu(n->keys[mid]);
+
+		if (mid_key == key)
+			return mid;
+
+		if (mid_key < key)
+			lo = mid;
+		else
+			hi = mid;
+	}
+
+	return want_hi ? hi : lo;
+}
+
+int lower_bound(struct node *n, uint64_t key)
+{
+	return bsearch(n, key, 0);
+}
+
+int upper_bound(struct node *n, uint64_t key)
+{
+	return bsearch(n, key, 1);
+}
+
+void inc_children(struct dm_transaction_manager *tm, struct node *n,
+		  struct dm_btree_value_type *vt)
+{
+	unsigned i;
+	uint32_t nr_entries = __le32_to_cpu(n->header.nr_entries);
+
+	if (__le32_to_cpu(n->header.flags) & INTERNAL_NODE)
+		for (i = 0; i < nr_entries; i++)
+			dm_tm_inc(tm, value64(n, i));
+	else if (vt->inc)
+		for (i = 0; i < nr_entries; i++)
+			vt->inc(vt->context,
+				value_ptr(n, i, vt->size));
+}
+
+void insert_at(size_t value_size, struct node *node, unsigned index,
+	       uint64_t key, void *value)
+{
+	uint32_t nr_entries = __le32_to_cpu(node->header.nr_entries);
+
+	BUG_ON(index > nr_entries ||
+	       index >= __le32_to_cpu(node->header.max_entries));
+
+	array_insert(node->keys, sizeof(*node->keys), nr_entries, index, &key);
+	array_insert(value_base(node), value_size, nr_entries, index, value);
+	node->header.nr_entries = __cpu_to_le32(nr_entries + 1);
+}
+
+/*----------------------------------------------------------------*/
+
+/*
+ * We want 3n entries (for some n).  This works more nicely for repeated
+ * insert remove loops than (2n + 1).
+ */
+uint32_t calc_max_entries(size_t value_size, size_t block_size)
+{
+	uint32_t total, n;
+	size_t elt_size = sizeof(uint64_t) + value_size; /* key + value */
+
+	block_size -= sizeof(struct node_header);
+	total = block_size / elt_size;
+	n = total / 3;		/* rounds down */
+
+	return 3 * n;
+}
+
+int dm_btree_empty(struct dm_btree_info *info, dm_block_t *root)
+{
+	int r;
+	struct dm_block *b;
+	struct node *n;
+	size_t block_size;
+	uint32_t max_entries;
+
+	r = bn_new_block(info, &b);
+	if (r < 0)
+		return r;
+
+	block_size = dm_bm_block_size(dm_tm_get_bm(info->tm));
+	max_entries = calc_max_entries(info->value_type.size, block_size);
+
+	n = (struct node *) dm_block_data(b);
+	memset(n, 0, block_size);
+	n->header.flags = __cpu_to_le32(LEAF_NODE);
+	n->header.nr_entries = __cpu_to_le32(0);
+	n->header.max_entries =	__cpu_to_le32(max_entries);
+
+	*root = dm_block_location(b);
+	return bn_unlock(info, b);
+}
+EXPORT_SYMBOL_GPL(dm_btree_empty);
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Deletion uses a recursive algorithm, since we have limited stack space
+ * we explicitly manage our own stack on the heap.
+ */
+#define MAX_SPINE_DEPTH 64
+struct frame {
+	struct dm_block *b;
+	struct node *n;
+	unsigned level;
+	unsigned nr_children;
+	unsigned current_child;
+};
+
+struct del_stack {
+	struct dm_transaction_manager *tm;
+	int top;
+	struct frame spine[MAX_SPINE_DEPTH];
+};
+
+static void top_frame(struct del_stack *s, struct frame **f)
+{
+	BUG_ON(s->top < 0);
+	*f = s->spine + s->top;
+}
+
+static int unprocessed_frames(struct del_stack *s)
+{
+	return s->top >= 0;
+}
+
+static int push_frame(struct del_stack *s, dm_block_t b, unsigned level)
+{
+	int r;
+	uint32_t ref_count;
+
+	BUG_ON(s->top >= MAX_SPINE_DEPTH);
+
+	r = dm_tm_ref(s->tm, b, &ref_count);
+	if (r)
+		return r;
+
+	if (ref_count > 1)
+		/*
+		 * This is a shared node, so we can just decrement it's
+		 * reference counter and leave the children.
+		 */
+		dm_tm_dec(s->tm, b);
+
+	else {
+		struct frame *f = s->spine + ++s->top;
+
+		r = dm_tm_read_lock(s->tm, b, &btree_node_validator, &f->b);
+		if (r) {
+			s->top--;
+			return r;
+		}
+
+		f->n = dm_block_data(f->b);
+		f->level = level;
+		f->nr_children = __le32_to_cpu(f->n->header.nr_entries);
+		f->current_child = 0;
+	}
+
+	return 0;
+}
+
+static void pop_frame(struct del_stack *s)
+{
+	struct frame *f = s->spine + s->top--;
+
+	dm_tm_dec(s->tm, dm_block_location(f->b));
+	dm_tm_unlock(s->tm, f->b);
+}
+
+int dm_btree_del(struct dm_btree_info *info, dm_block_t root)
+{
+	struct del_stack *s;
+
+	s = kmalloc(sizeof(*s), GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+	s->tm = info->tm;
+	s->top = -1;
+
+	push_frame(s, root, 1);
+	while (unprocessed_frames(s)) {
+		int r;
+		uint32_t flags;
+		struct frame *f;
+		dm_block_t b;
+
+		top_frame(s, &f);
+
+		if (f->current_child >= f->nr_children) {
+			pop_frame(s);
+			continue;
+		}
+
+		flags = __le32_to_cpu(f->n->header.flags);
+		if (flags & INTERNAL_NODE) {
+			b = value64(f->n, f->current_child);
+			f->current_child++;
+			r = push_frame(s, b, f->level);
+			if (r)
+				goto bad;
+
+		} else if (f->level != (info->levels - 1)) {
+			b = value64(f->n, f->current_child);
+			f->current_child++;
+			r = push_frame(s, b, f->level + 1);
+			if (r)
+				goto bad;
+
+		} else {
+			if (info->value_type.dec) {
+				unsigned i;
+
+				for (i = 0; i < f->nr_children; i++)
+					info->value_type.dec(info->value_type.context,
+							     value_ptr(f->n, i, info->value_type.size));
+			}
+			f->current_child = f->nr_children;
+		}
+	}
+
+	return 0;
+
+bad:
+	/* what happens if we've deleted half a tree? */
+	return -1; /* FIXME: return error code rather than -1? */
+}
+EXPORT_SYMBOL_GPL(dm_btree_del);
+
+int dm_btree_del_gt(struct dm_btree_info *info, dm_block_t root, uint64_t *key,
+		    dm_block_t *new_root)
+{
+	/* FIXME: implement */
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_btree_del_gt);
+
+/*----------------------------------------------------------------*/
+
+static int btree_lookup_raw(struct ro_spine *s, dm_block_t block, uint64_t key,
+			    int (*search_fn)(struct node *, uint64_t),
+			    uint64_t *result_key, void *v, size_t value_size)
+{
+	int i, r;
+	uint32_t flags, nr_entries;
+
+	do {
+		r = ro_step(s, block);
+		if (r < 0)
+			return r;
+
+		i = search_fn(ro_node(s), key);
+
+		flags = __le32_to_cpu(ro_node(s)->header.flags);
+		nr_entries = __le32_to_cpu(ro_node(s)->header.nr_entries);
+		if (i < 0 || i >= nr_entries)
+			return -ENODATA;
+
+		if (flags & INTERNAL_NODE)
+			block = value64(ro_node(s), i);
+
+	} while (!(flags & LEAF_NODE));
+
+	*result_key = __le64_to_cpu(ro_node(s)->keys[i]);
+	memcpy(v, value_ptr(ro_node(s), i, value_size), value_size);
+
+	return 0;
+}
+
+int dm_btree_lookup(struct dm_btree_info *info, dm_block_t root,
+		    uint64_t *keys, void *value)
+{
+	unsigned level, last_level = info->levels - 1;
+	int r;
+	uint64_t rkey;
+	__le64 internal_value;
+	struct ro_spine spine;
+
+	init_ro_spine(&spine, info);
+	for (level = 0; level < info->levels; level++) {
+		size_t size;
+		void *value_p;
+
+		if (level == last_level) {
+			value_p = value;
+			size = info->value_type.size;
+
+		} else {
+			value_p = &internal_value;
+			size = sizeof(uint64_t);
+		}
+
+		r = btree_lookup_raw(&spine, root, keys[level],
+				     lower_bound, &rkey,
+				     value_p, size);
+
+		if (r == 0) {
+			if (rkey != keys[level]) {
+				exit_ro_spine(&spine);
+				return -ENODATA;
+			}
+		} else {
+			exit_ro_spine(&spine);
+			return r;
+		}
+
+		root = __le64_to_cpu(internal_value);
+	}
+	exit_ro_spine(&spine);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(dm_btree_lookup);
+
+int dm_btree_lookup_le(struct dm_btree_info *info, dm_block_t root,
+		       uint64_t *keys, uint64_t *key, void *value)
+{
+	unsigned level, last_level = info->levels - 1;
+	int r;
+	__le64 internal_value;
+	struct ro_spine spine;
+
+	init_ro_spine(&spine, info);
+	for (level = 0; level < info->levels; level++) {
+		size_t size;
+		void *value_p;
+
+		if (level == last_level) {
+			value_p = value;
+			size = info->value_type.size;
+
+		} else {
+			value_p = &internal_value;
+			size = sizeof(uint64_t);
+		}
+
+		r = btree_lookup_raw(&spine, root, keys[level],
+				     lower_bound, key,
+				     value_p, size);
+
+		if (r != 0) {
+			exit_ro_spine(&spine);
+			return r;
+		}
+
+		root = __le64_to_cpu(internal_value);
+	}
+	exit_ro_spine(&spine);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(dm_btree_lookup_le);
+
+int dm_btree_lookup_ge(struct dm_btree_info *info, dm_block_t root,
+		       uint64_t *keys, uint64_t *key, void *value)
+{
+	unsigned level, last_level = info->levels - 1;
+	int r;
+	__le64 internal_value;
+	struct ro_spine spine;
+
+	init_ro_spine(&spine, info);
+	for (level = 0; level < info->levels; level++) {
+		size_t size;
+		void *value_p;
+
+		if (level == last_level) {
+			value_p = value;
+			size = info->value_type.size;
+
+		} else {
+			value_p = &internal_value;
+			size = sizeof(uint64_t);
+		}
+
+		r = btree_lookup_raw(&spine, root, keys[level],
+				     upper_bound, key,
+				     value_p, size);
+
+		if (r != 0) {
+			exit_ro_spine(&spine);
+			return r;
+		}
+
+		root = __le64_to_cpu(internal_value);
+	}
+	exit_ro_spine(&spine);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(dm_btree_lookup_ge);
+
+/*
+ * Splits a node by creating a sibling node and shifting half the nodes
+ * contents across.  Assumes there is a parent node, and it has room for
+ * another child.
+ *
+ * Before:
+ *	  +--------+
+ *	  | Parent |
+ *	  +--------+
+ *	     |
+ *	     v
+ *	+----------+
+ *	| A ++++++ |
+ *	+----------+
+ *
+ *
+ * After:
+ *		+--------+
+ *		| Parent |
+ *		+--------+
+ *		  |	|
+ *		  v	+------+
+ *	    +---------+	       |
+ *	    | A* +++  |	       v
+ *	    +---------+	  +-------+
+ *			  | B +++ |
+ *			  +-------+
+ *
+ * Where A* is a shadow of A.
+ */
+static int btree_split_sibling(struct shadow_spine *s, dm_block_t root,
+			       unsigned parent_index, uint64_t key)
+{
+	int ret;
+	size_t size;
+	unsigned nr_left, nr_right;
+	struct dm_block *left, *right, *parent;
+	struct node *l, *r, *p;
+	__le64 location;
+
+	left = shadow_current(s);
+	BUG_ON(!left);
+
+	ret = bn_new_block(s->info, &right);
+	if (ret < 0)
+		return ret;
+
+	l = dm_block_data(left);
+	r = (struct node *) dm_block_data(right);
+
+	nr_left = __le32_to_cpu(l->header.nr_entries) / 2;
+	nr_right = __le32_to_cpu(l->header.nr_entries) - nr_left;
+
+	l->header.nr_entries = __cpu_to_le32(nr_left);
+
+	r->header.flags = l->header.flags;
+	r->header.nr_entries = __cpu_to_le32(nr_right);
+	r->header.max_entries = l->header.max_entries;
+	memcpy(r->keys, l->keys + nr_left, nr_right * sizeof(r->keys[0]));
+
+	size = __le32_to_cpu(l->header.flags) & INTERNAL_NODE ?
+		sizeof(uint64_t) : s->info->value_type.size;
+	memcpy(value_ptr(r, 0, size), value_ptr(l, nr_left, size),
+	       size * nr_right);
+
+	/* Patch up the parent */
+	parent = shadow_parent(s);
+	BUG_ON(!parent);
+
+	p = dm_block_data(parent);
+	location = __cpu_to_le64(dm_block_location(left));
+	memcpy(value_ptr(p, parent_index, sizeof(__le64)),
+	       &location, sizeof(__le64));
+
+	location = __cpu_to_le64(dm_block_location(right));
+	insert_at(sizeof(__le64), p, parent_index + 1,
+		  __le64_to_cpu(r->keys[0]), &location);
+
+	if (key < __le64_to_cpu(r->keys[0])) {
+		bn_unlock(s->info, right);
+		s->nodes[1] = left;
+	} else {
+		bn_unlock(s->info, left);
+		s->nodes[1] = right;
+	}
+
+	return 0;
+}
+
+/*
+ * Splits a node by creating two new children beneath the given node.
+ *
+ * Before:
+ *	  +----------+
+ *	  | A ++++++ |
+ *	  +----------+
+ *
+ *
+ * After:
+ *	+------------+
+ *	| A (shadow) |
+ *	+------------+
+ *	    |	|
+ *   +------+	+----+
+ *   |		     |
+ *   v		     v
+ * +-------+	 +-------+
+ * | B +++ |	 | C +++ |
+ * +-------+	 +-------+
+ */
+static int btree_split_beneath(struct shadow_spine *s, uint64_t key)
+{
+	int ret;
+	size_t size;
+	unsigned nr_left, nr_right;
+	struct dm_block *left, *right, *new_parent;
+	struct node *p, *l, *r;
+	__le64 val;
+
+	new_parent = shadow_current(s);
+	BUG_ON(!new_parent);
+
+	ret = bn_new_block(s->info, &left);
+	if (ret < 0)
+		return ret;
+
+	ret = bn_new_block(s->info, &right);
+	if (ret < 0) {
+		/* FIXME: put left */
+		return ret;
+	}
+
+	p = dm_block_data(new_parent);
+	l = (struct node *) dm_block_data(left);
+	r = (struct node *) dm_block_data(right);
+
+	nr_left = __le32_to_cpu(p->header.nr_entries) / 2;
+	nr_right = __le32_to_cpu(p->header.nr_entries) - nr_left;
+
+	l->header.flags = p->header.flags;
+	l->header.nr_entries = __cpu_to_le32(nr_left);
+	l->header.max_entries = p->header.max_entries;
+
+	r->header.flags = p->header.flags;
+	r->header.nr_entries = __cpu_to_le32(nr_right);
+	r->header.max_entries = p->header.max_entries;
+
+	memcpy(l->keys, p->keys, nr_left * sizeof(p->keys[0]));
+	memcpy(r->keys, p->keys + nr_left, nr_right * sizeof(p->keys[0]));
+
+	size = __le32_to_cpu(p->header.flags) & INTERNAL_NODE ?
+		sizeof(__le64) : s->info->value_type.size;
+	memcpy(value_ptr(l, 0, size), value_ptr(p, 0, size), nr_left * size);
+	memcpy(value_ptr(r, 0, size), value_ptr(p, nr_left, size),
+	       nr_right * size);
+
+	/* new_parent should just point to l and r now */
+	p->header.flags = __cpu_to_le32(INTERNAL_NODE);
+	p->header.nr_entries = __cpu_to_le32(2);
+
+	val = __cpu_to_le64(dm_block_location(left));
+	p->keys[0] = l->keys[0];
+	memcpy(value_ptr(p, 0, sizeof(__le64)), &val, sizeof(__le64));
+
+	val = __cpu_to_le64(dm_block_location(right));
+	p->keys[1] = r->keys[0];
+	memcpy(value_ptr(p, 1, sizeof(__le64)), &val, sizeof(__le64));
+
+	/*
+	 * rejig the spine.  This is ugly, since it knows too
+	 * much about the spine
+	 */
+	if (s->nodes[0] != new_parent) {
+		bn_unlock(s->info, s->nodes[0]);
+		s->nodes[0] = new_parent;
+	}
+	if (key < __le64_to_cpu(r->keys[0])) {
+		bn_unlock(s->info, right);
+		s->nodes[1] = left;
+	} else {
+		bn_unlock(s->info, left);
+		s->nodes[1] = right;
+	}
+	s->count = 2;
+
+	return 0;
+}
+
+static int btree_insert_raw(struct shadow_spine *s, dm_block_t root,
+			    struct dm_btree_value_type *vt,
+			    uint64_t key, unsigned *index)
+{
+	int r, i = *index, inc, top = 1;
+	struct node *node;
+
+	for (;;) {
+		r = shadow_step(s, root, vt, &inc);
+		if (r < 0) {
+			/* FIXME: unpick any allocations */
+			return r;
+		}
+
+		node = dm_block_data(shadow_current(s));
+		if (inc)
+			inc_children(s->info->tm, node, vt);
+
+		/*
+		 * We have to patch up the parent node, ugly, but I don't
+		 * see a way to do this automatically as part of the spine
+		 * op.
+		 */
+		if (shadow_parent(s) && i >= 0) { /* FIXME: second clause unness. */
+			__le64 location = __cpu_to_le64(dm_block_location(shadow_current(s)));
+			memcpy(value_ptr(dm_block_data(shadow_parent(s)), i, sizeof(uint64_t)),
+			       &location, sizeof(__le64));
+		}
+
+		BUG_ON(!shadow_current(s));
+		node = dm_block_data(shadow_current(s));
+
+		if (node->header.nr_entries == node->header.max_entries) {
+			if (top)
+				r = btree_split_beneath(s, key);
+			else
+				r = btree_split_sibling(s, root, i, key);
+
+			if (r < 0)
+				return r;
+		}
+
+		BUG_ON(!shadow_current(s));
+		node = dm_block_data(shadow_current(s));
+
+		i = lower_bound(node, key);
+
+		if (__le32_to_cpu(node->header.flags) & LEAF_NODE)
+			break;
+
+		if (i < 0) {
+			/* change the bounds on the lowest key */
+			node->keys[0] = __cpu_to_le64(key);
+			i = 0;
+		}
+
+		root = value64(node, i);
+		top = 0;
+	}
+
+	if (i < 0 || __le64_to_cpu(node->keys[i]) != key)
+		i++;
+
+	/* we're about to overwrite this value, so undo the increment for it */
+	/* FIXME: shame that inc information is leaking outside the spine.
+	 * Plus inc is just plain wrong in the event of a split */
+	if (__le64_to_cpu(node->keys[i]) == key && inc)
+		if (vt->dec)
+			vt->dec(vt->context, value_ptr(node, i, vt->size));
+
+	*index = i;
+	return 0;
+}
+
+static int insert(struct dm_btree_info *info, dm_block_t root,
+		  uint64_t *keys, void *value, dm_block_t *new_root,
+		  int *inserted)
+{
+	int r, need_insert;
+	unsigned level, index = -1, last_level = info->levels - 1;
+	dm_block_t *block = &root;
+	struct shadow_spine spine;
+	struct node *n;
+	struct dm_btree_value_type le64_type;
+
+	le64_type.context = NULL;
+	le64_type.size = sizeof(__le64);
+	le64_type.inc = NULL;
+	le64_type.dec = NULL;
+	le64_type.equal = NULL;
+
+	init_shadow_spine(&spine, info);
+
+	for (level = 0; level < info->levels; level++) {
+		r = btree_insert_raw(&spine, *block,
+				     (level == last_level ?
+				      &info->value_type : &le64_type),
+				     keys[level], &index);
+		if (r < 0) {
+			exit_shadow_spine(&spine);
+			/* FIXME: avoid block leaks */
+			return r;
+		}
+
+		BUG_ON(!shadow_current(&spine));
+		n = dm_block_data(shadow_current(&spine));
+		need_insert = ((index >= __le32_to_cpu(n->header.nr_entries)) ||
+			       (__le64_to_cpu(n->keys[index]) != keys[level]));
+
+		if (level == last_level) {
+			if (need_insert) {
+				if (inserted)
+					*inserted = 1;
+
+				insert_at(info->value_type.size, n, index,
+					  keys[level], value);
+			} else {
+				if (inserted)
+					*inserted = 0;
+
+				if (info->value_type.dec &&
+				    (!info->value_type.equal ||
+				     !info->value_type.equal(
+					     info->value_type.context,
+					     value_ptr(n, index, info->value_type.size),
+					     value))) {
+					info->value_type.dec(info->value_type.context,
+					     value_ptr(n, index, info->value_type.size));
+				}
+				memcpy(value_ptr(n, index, info->value_type.size),
+				       value, info->value_type.size);
+			}
+		} else {
+			if (need_insert) {
+				dm_block_t new_tree;
+				r = dm_btree_empty(info, &new_tree);
+				if (r < 0) {
+					/* FIXME: avoid block leaks */
+					exit_shadow_spine(&spine);
+					return r;
+				}
+
+				insert_at(sizeof(uint64_t), n, index,
+					  keys[level], &new_tree);
+			}
+		}
+
+		if (level < last_level)
+			block = value_ptr(n, index, sizeof(uint64_t));
+	}
+
+	*new_root = shadow_root(&spine);
+	exit_shadow_spine(&spine);
+
+	return 0;
+}
+
+
+int dm_btree_insert(struct dm_btree_info *info, dm_block_t root,
+		    uint64_t *keys, void *value, dm_block_t *new_root)
+{
+	return insert(info, root, keys, value, new_root, NULL);
+}
+EXPORT_SYMBOL_GPL(dm_btree_insert);
+
+int dm_btree_insert_notify(struct dm_btree_info *info, dm_block_t root,
+			   uint64_t *keys, void *value, dm_block_t *new_root,
+			   int *inserted)
+{
+	return insert(info, root, keys, value, new_root, inserted);
+}
+EXPORT_SYMBOL_GPL(dm_btree_insert_notify);
+
+/*----------------------------------------------------------------*/
+
+int dm_btree_clone(struct dm_btree_info *info, dm_block_t root,
+		   dm_block_t *clone)
+{
+	int r;
+	struct dm_block *b, *orig_b;
+	struct node *b_node, *orig_node;
+
+	/* Copy the root node */
+	r = bn_new_block(info, &b);
+	if (r < 0)
+		return r;
+
+	r = dm_tm_read_lock(info->tm, root, &btree_node_validator, &orig_b);
+	if (r < 0) {
+		dm_block_t location = dm_block_location(b);
+
+		bn_unlock(info, b);
+		dm_tm_dec(info->tm, location);
+	}
+
+	*clone = dm_block_location(b);
+	b_node = (struct node *) dm_block_data(b);
+	orig_node = dm_block_data(orig_b);
+
+	memcpy(b_node, orig_node,
+	       dm_bm_block_size(dm_tm_get_bm(info->tm)));
+	dm_tm_unlock(info->tm, orig_b);
+	inc_children(info->tm, b_node, &info->value_type);
+	dm_tm_unlock(info->tm, b);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_btree_clone);
+
+/*----------------------------------------------------------------*/
+
+static int find_highest_key(struct ro_spine *s, dm_block_t block,
+			    uint64_t *result_key, dm_block_t *next_block)
+{
+	int i, r;
+	uint32_t flags;
+
+	do {
+		r = ro_step(s, block);
+		if (r < 0)
+			return r;
+
+		flags = __le32_to_cpu(ro_node(s)->header.flags);
+		i = __le32_to_cpu(ro_node(s)->header.nr_entries);
+		if (i == 0)
+			return -ENODATA;
+		else
+			i--;
+
+		*result_key = __le64_to_cpu(ro_node(s)->keys[i]);
+		if (next_block || flags & INTERNAL_NODE)
+			block = value64(ro_node(s), i);
+
+	} while (flags & INTERNAL_NODE);
+
+	if (next_block)
+		*next_block = block;
+	return 0;
+}
+
+int dm_btree_find_highest_key(struct dm_btree_info *info, dm_block_t root,
+			      uint64_t *result_keys)
+{
+	int r = 0, count = 0, level;
+	struct ro_spine spine;
+
+	init_ro_spine(&spine, info);
+	for (level = 0; level < info->levels; level++) {
+		r = find_highest_key(&spine, root, result_keys + level,
+				     level == info->levels - 1 ? NULL : &root);
+		if (r == -ENODATA) {
+			r = 0;
+			break;
+
+		} else if (r)
+			break;
+
+		count++;
+	}
+	exit_ro_spine(&spine);
+
+	return r ? r : count;
+}
+EXPORT_SYMBOL_GPL(dm_btree_find_highest_key);
diff --git a/drivers/md/persistent-data/dm-btree.h b/drivers/md/persistent-data/dm-btree.h
new file mode 100644
index 0000000..3128382
--- /dev/null
+++ b/drivers/md/persistent-data/dm-btree.h
@@ -0,0 +1,146 @@
+#ifndef DM_BTREE_H
+#define DM_BTREE_H
+
+#include "dm-transaction-manager.h"
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Manipulates hierarchical B+ trees with 64bit keys and arbitrary sized
+ * values.
+ */
+
+/*
+ * The btree needs some knowledge about the values stored within it.  This
+ * is provided by a |btree_value_type| structure.
+ */
+struct dm_btree_value_type {
+	void *context;
+
+	/*
+	 * The size in bytes of each value.
+	 */
+	uint32_t size;
+
+	/*
+	 * Any of these methods can be safely set to NULL if you do not
+	 * need this feature.
+	 */
+
+	/*
+	 * The btree is making a duplicate of the value, for instance
+	 * because previously shared btree nodes have now diverged.  The
+	 * |value| argument is the new copy, the copy function may modify
+	 * it.  Probably it just wants to increment a reference count
+	 * somewhere.  This method is _not_ called for insertion of a new
+	 * value, it's assumed the ref count is already 1.
+	 */
+	void (*inc)(void *context, void *value);
+
+	/*
+	 * This value is being deleted.  The btree takes care of freeing
+	 * the memory pointed to by |value|.  Often the |del| function just
+	 * needs to decrement a reference count somewhere.
+	 */
+	void (*dec)(void *context, void *value);
+
+	/*
+	 * An test for equality between two values.  When a value is
+	 * overwritten with a new one the old one has the |dec| method
+	 * called, _unless_ the new and old value are deemed equal.
+	 */
+	int (*equal)(void *context, void *value1, void *value2);
+};
+
+/*
+ * The |btree_info| structure describes the shape and contents of a btree.
+ */
+struct dm_btree_info {
+	struct dm_transaction_manager *tm;
+
+	/* number of nested btrees (not the depth of a single tree). */
+	unsigned levels;
+	struct dm_btree_value_type value_type;
+};
+
+/* Set up an empty tree.  O(1). */
+int dm_btree_empty(struct dm_btree_info *info, dm_block_t *root);
+
+/*
+ * Delete a tree.  O(n) - this is the slow one!  It can also block, so
+ * please don't call it on an io path.
+ */
+int dm_btree_del(struct dm_btree_info *info, dm_block_t root);
+
+/*
+ * Delete part of a tree.  This is really specific to truncation of
+ * multisnap devs.  It only removes keys from the bottom level btree that
+ * are greater than key[info->levels - 1].
+ */
+int dm_btree_del_gt(struct dm_btree_info *info, dm_block_t root, uint64_t *key,
+		    dm_block_t *new_root);
+
+/*
+ * All the lookup functions return -ENODATA if the key cannot be found.
+ */
+
+/* Tries to find a key that matches exactly.  O(ln(n)) */
+int dm_btree_lookup(struct dm_btree_info *info, dm_block_t root,
+		    uint64_t *keys, void *value);
+
+/*
+ * Find the greatest key that is less than or equal to that requested.  A
+ * ENODATA result indicates the key would appear in front of all (possibly
+ * zero) entries.  O(ln(n))
+ */
+int dm_btree_lookup_le(struct dm_btree_info *info, dm_block_t root,
+		       uint64_t *keys, uint64_t *rkey, void *value);
+
+/*
+ * Find the least key that is greater than or equal to that requested.
+ * ENODATA indicates all the keys are below.  O(ln(n))
+ */
+int dm_btree_lookup_ge(struct dm_btree_info *info, dm_block_t root,
+		       uint64_t *keys, uint64_t *rkey, void *value);
+
+/*
+ * Insertion (or overwrite an existing value).
+ * O(ln(n))
+ */
+int dm_btree_insert(struct dm_btree_info *info, dm_block_t root,
+		    uint64_t *keys, void *value, dm_block_t *new_root);
+
+/*
+ * A variant of insert that indicates whether it actually inserted or just
+ * overwrote.  Useful if you're keeping track of the number of entries in a
+ * tree.
+ */
+int dm_btree_insert_notify(struct dm_btree_info *info, dm_block_t root,
+			   uint64_t *keys, void *value, dm_block_t *new_root,
+			   int *inserted);
+
+/*
+ * Remove a key if present.  This doesn't remove empty sub trees.  Normally
+ * subtrees represent a separate entity, like a snapshot map, so this is
+ * correct behaviour.
+ * O(ln(n)).
+ * Returns ENODATA if the key isn't present.
+ */
+int dm_btree_remove(struct dm_btree_info *info, dm_block_t root,
+		    uint64_t *keys, dm_block_t *new_root);
+
+/* Clone a tree. O(1) */
+int dm_btree_clone(struct dm_btree_info *info, dm_block_t root,
+		   dm_block_t *clone);
+
+/*
+ * Returns < 0 on failure.  Otherwise the number of key entries that have
+ * been filled out.  Remember trees can have zero entries, and as such have
+ * no highest key.
+ */
+int dm_btree_find_highest_key(struct dm_btree_info *info, dm_block_t root,
+			      uint64_t *result_keys);
+
+/*----------------------------------------------------------------*/
+
+#endif
diff --git a/drivers/md/persistent-data/dm-pd-module.c b/drivers/md/persistent-data/dm-pd-module.c
new file mode 100644
index 0000000..eac6083
--- /dev/null
+++ b/drivers/md/persistent-data/dm-pd-module.c
@@ -0,0 +1,18 @@
+#include <linux/init.h>
+#include <linux/module.h>
+
+static int dm_persistent_data_init(void)
+{
+	return 0;
+}
+
+static void dm_persistent_data_exit(void)
+{
+}
+
+module_init(dm_persistent_data_init);
+module_exit(dm_persistent_data_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Joe Thornber");
+MODULE_DESCRIPTION("Immutable metadata library for dm");
diff --git a/drivers/md/persistent-data/dm-space-map-common.h b/drivers/md/persistent-data/dm-space-map-common.h
new file mode 100644
index 0000000..6635d5b
--- /dev/null
+++ b/drivers/md/persistent-data/dm-space-map-common.h
@@ -0,0 +1,99 @@
+#ifndef DM_SPACE_MAP_COMMON_H
+#define DM_SPACE_MAP_COMMON_H
+
+#include "dm-transaction-manager.h"
+#include "dm-btree.h"
+
+/*----------------------------------------------------------------
+ * Low level disk format
+ *
+ * Bitmap btree
+ * ------------
+ *
+ * Each value stored in the btree is an index_entry.  This points to a
+ * block that is used as a bitmap.  Within the bitmap hold 2 bits per
+ * entry, which represent UNUSED = 0, REF_COUNT = 1, REF_COUNT = 2 and
+ * REF_COUNT = many.
+ *
+ * Refcount btree
+ * --------------
+ *
+ * Any entry that has a ref count higher than 2 gets entered in the ref
+ * count tree.  The leaf values for this tree is the 32bit ref count.
+ *--------------------------------------------------------------*/
+struct index_entry {
+	__le64 blocknr;
+	__le32 nr_free;
+	__le32 none_free_before;
+} __packed;
+
+
+#define MAX_METADATA_BITMAPS 255
+struct metadata_index {
+	__le32 csum;
+	__le32 padding;
+	__le64 blocknr;
+
+	struct index_entry index[MAX_METADATA_BITMAPS];
+} __packed;
+
+struct ll_disk {
+	struct dm_transaction_manager *tm;
+	struct dm_btree_info bitmap_info;
+	struct dm_btree_info ref_count_info;
+
+	uint32_t block_size;
+	uint32_t entries_per_block;
+	dm_block_t nr_blocks;
+	dm_block_t nr_allocated;
+	dm_block_t bitmap_root;	/* sometimes a btree root,
+				 * sometimes a simple index */
+	dm_block_t ref_count_root;
+
+	struct metadata_index mi;
+};
+
+struct sm_root {
+	__le64 nr_blocks;
+	__le64 nr_allocated;
+	__le64 bitmap_root;
+	__le64 ref_count_root;
+} __packed;
+
+#define ENTRIES_PER_BYTE 4
+
+struct bitmap_header {
+	__le32 csum;
+	__le32 not_used;
+	__le64 blocknr;
+} __packed;
+
+/*
+ * These bitops work on a blocks worth of bits.
+ */
+unsigned sm_lookup_bitmap(void *addr, unsigned b);
+void sm_set_bitmap(void *addr, unsigned b, unsigned val);
+int sm_find_free(void *addr, unsigned begin, unsigned end,
+		 unsigned *result);
+
+void *dm_bitmap_data(struct dm_block *b);
+
+extern struct dm_block_validator dm_sm_bitmap_validator;
+
+/*----------------------------------------------------------------*/
+
+static inline uint64_t div_up(uint64_t v, uint64_t n)
+{
+	uint64_t t = v;
+	uint64_t rem = do_div(t, n);
+	return t + (rem > 0 ? 1 : 0);
+}
+
+static inline uint64_t mod64(uint64_t n, uint64_t d)
+{
+	return do_div(n, d);
+}
+
+/*----------------------------------------------------------------*/
+
+#endif
diff --git a/drivers/md/persistent-data/dm-space-map-disk.c b/drivers/md/persistent-data/dm-space-map-disk.c
new file mode 100644
index 0000000..a2f1b37
--- /dev/null
+++ b/drivers/md/persistent-data/dm-space-map-disk.c
@@ -0,0 +1,624 @@
+#include "dm-space-map-common.h"
+#include "dm-space-map-disk.h"
+
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <asm-generic/bitops/le.h>
+#include <linux/device-mapper.h> /* For DMERR */
+
+#define DM_MSG_PREFIX "space map disk"
+
+/*----------------------------------------------------------------
+ * bitmap validator
+ *--------------------------------------------------------------*/
+static void bitmap_prepare_for_write(struct dm_block_validator *v,
+				     struct dm_block *b,
+				     size_t block_size)
+{
+	struct bitmap_header *header = dm_block_data(b);
+
+	header->blocknr = __cpu_to_le64(dm_block_location(b));
+	header->csum = dm_block_csum_data(&header->not_used,
+					  block_size - sizeof(u32));
+}
+
+static int bitmap_check(struct dm_block_validator *v,
+			struct dm_block *b,
+			size_t block_size)
+{
+	struct bitmap_header *header = dm_block_data(b);
+	__le32 csum;
+
+	if (dm_block_location(b) != __le64_to_cpu(header->blocknr)) {
+		DMERR("bitmap check failed blocknr %llu wanted %llu",
+		      __le64_to_cpu(header->blocknr), dm_block_location(b));
+		return -ENOTBLK;
+	}
+
+	csum = dm_block_csum_data(&header->not_used,
+				  block_size - sizeof(u32));
+	if (csum != header->csum) {
+		DMERR("bitmap check failed csum %u wanted %u",
+		      __le32_to_cpu(csum), __le32_to_cpu(header->csum));
+		return -EILSEQ;
+	}
+
+	return 0;
+}
+
+struct dm_block_validator dm_sm_bitmap_validator = {
+	.name = "sm_bitmap",
+	.prepare_for_write = bitmap_prepare_for_write,
+	.check = bitmap_check
+};
+
+/*----------------------------------------------------------------*/
+
+#define ENTRIES_PER_WORD 32
+#define ENTRIES_SHIFT	5
+
+void *dm_bitmap_data(struct dm_block *b)
+{
+	return dm_block_data(b) + sizeof(struct bitmap_header);
+}
+
+#define WORD_MASK_LOW 0x5555555555555555ULL
+#define WORD_MASK_HIGH 0xAAAAAAAAAAAAAAAAULL
+#define WORD_MASK_ALL 0xFFFFFFFFFFFFFFFFULL
+
+static unsigned bitmap_word_used(void *addr, unsigned b)
+{
+	__le64 *words = (__le64 *) addr;
+	__le64 *w = words + (b >> ENTRIES_SHIFT);
+
+	uint64_t bits = __le64_to_cpu(*w);
+	return ((bits & WORD_MASK_LOW) == WORD_MASK_LOW ||
+		(bits & WORD_MASK_HIGH) == WORD_MASK_HIGH ||
+		(bits & WORD_MASK_ALL) == WORD_MASK_ALL);
+}
+
+unsigned sm_lookup_bitmap(void *addr, unsigned b)
+{
+	__le64 *words = (__le64 *) addr;
+	__le64 *w = words + (b >> ENTRIES_SHIFT);
+
+	b = (b & (ENTRIES_PER_WORD - 1)) << 1;
+	return ((!!test_bit_le(b, (void *) w) << 1)) |
+		(!!test_bit_le(b + 1, (void *) w));
+}
+
+
+void sm_set_bitmap(void *addr, unsigned b, unsigned val)
+{
+	__le64 *words = (__le64 *) addr;
+	__le64 *w = words + (b >> ENTRIES_SHIFT);
+
+	b = (b & (ENTRIES_PER_WORD - 1)) << 1;
+
+	if (val & 2)
+		__set_bit_le(b, (void *) w);
+	else
+		__clear_bit_le(b, (void *) w);
+
+	if (val & 1)
+		__set_bit_le(b + 1, (void *) w);
+	else
+		__clear_bit_le(b + 1, (void *) w);
+}
+
+int sm_find_free(void *addr, unsigned begin, unsigned end,
+		 unsigned *result)
+{
+	while (begin < end) {
+		if (!(begin & (ENTRIES_PER_WORD - 1)) &&
+		    bitmap_word_used(addr, begin)) {
+			begin += ENTRIES_PER_WORD;
+			continue;
+		}
+
+		if (sm_lookup_bitmap(addr, begin))
+			begin++;
+		else {
+			*result = begin;
+			return 0;
+		}
+	}
+
+	return -ENOSPC;
+}
+
+static int ll_init(struct ll_disk *io, struct dm_transaction_manager *tm)
+{
+	io->tm = tm;
+	io->bitmap_info.tm = tm;
+	io->bitmap_info.levels = 1;
+
+	/*
+	 * Because the new bitmap blocks are created via a shadow
+	 * operation, the old entry has already had it's reference count
+	 * decremented.	 So we don't need the btree to do any book
+	 * keeping.
+	 */
+	io->bitmap_info.value_type.size = sizeof(struct index_entry);
+	io->bitmap_info.value_type.inc = NULL;
+	io->bitmap_info.value_type.dec = NULL;
+	io->bitmap_info.value_type.equal = NULL;
+
+	io->ref_count_info.tm = tm;
+	io->ref_count_info.levels = 1;
+	io->ref_count_info.value_type.size = sizeof(uint32_t);
+	io->ref_count_info.value_type.inc = NULL;
+	io->ref_count_info.value_type.dec = NULL;
+	io->ref_count_info.value_type.equal = NULL;
+
+	io->block_size = dm_bm_block_size(dm_tm_get_bm(tm));
+
+	if (io->block_size > (1 << 30)) {
+		DMERR("block size too big to hold bitmaps");
+		return -EINVAL;
+	}
+	io->entries_per_block = (io->block_size - sizeof(struct bitmap_header)) *
+		ENTRIES_PER_BYTE;
+	io->nr_blocks = 0;
+	io->bitmap_root = 0;
+	io->ref_count_root = 0;
+
+	return 0;
+}
+
+static int ll_new(struct ll_disk *io, struct dm_transaction_manager *tm)
+{
+	int r;
+
+	r = ll_init(io, tm);
+	if (r < 0)
+		return r;
+
+	io->nr_blocks = 0;
+	io->nr_allocated = 0;
+	r = dm_btree_empty(&io->bitmap_info, &io->bitmap_root);
+	if (r < 0)
+		return r;
+
+	r = dm_btree_empty(&io->ref_count_info, &io->ref_count_root);
+	if (r < 0) {
+		dm_btree_del(&io->bitmap_info, io->bitmap_root);
+		return r;
+	}
+
+	return 0;
+}
+
+static int ll_extend(struct ll_disk *io, dm_block_t extra_blocks)
+{
+	int r;
+	dm_block_t i, nr_blocks;
+	unsigned old_blocks, blocks;
+
+	nr_blocks = io->nr_blocks + extra_blocks;
+	old_blocks = div_up(io->nr_blocks, io->entries_per_block);
+	blocks = div_up(nr_blocks, io->entries_per_block);
+	for (i = old_blocks; i < blocks; i++) {
+		struct dm_block *b;
+		struct index_entry idx;
+
+		r = dm_tm_new_block(io->tm, &dm_sm_bitmap_validator, &b);
+		if (r < 0)
+			return r;
+		idx.blocknr = __cpu_to_le64(dm_block_location(b));
+
+		r = dm_tm_unlock(io->tm, b);
+		if (r < 0)
+			return r;
+
+		idx.nr_free = __cpu_to_le32(io->entries_per_block);
+		idx.none_free_before = 0;
+
+		r = dm_btree_insert(&io->bitmap_info, io->bitmap_root,
+				    &i, &idx, &io->bitmap_root);
+		if (r < 0)
+			return r;
+	}
+
+	io->nr_blocks = nr_blocks;
+	return 0;
+}
+
+static int ll_open(struct ll_disk *ll, struct dm_transaction_manager *tm,
+		   void *root, size_t len)
+{
+	int r;
+	struct sm_root *smr = (struct sm_root *) root;
+
+	if (len < sizeof(struct sm_root)) {
+		DMERR("sm_disk root too small");
+		return -ENOMEM;
+	}
+
+	r = ll_init(ll, tm);
+	if (r < 0)
+		return r;
+
+	ll->nr_blocks = __le64_to_cpu(smr->nr_blocks);
+	ll->nr_allocated = __le64_to_cpu(smr->nr_allocated);
+	ll->bitmap_root = __le64_to_cpu(smr->bitmap_root);
+	ll->ref_count_root = __le64_to_cpu(smr->ref_count_root);
+
+	return 0;
+}
+
+static int ll_lookup_bitmap(struct ll_disk *io, dm_block_t b, uint32_t *result)
+{
+	int r;
+	dm_block_t index = b;
+	struct index_entry ie;
+	struct dm_block *blk;
+
+	do_div(index, io->entries_per_block);
+	r = dm_btree_lookup(&io->bitmap_info, io->bitmap_root, &index, &ie);
+	if (r < 0)
+		return r;
+
+	r = dm_tm_read_lock(io->tm, __le64_to_cpu(ie.blocknr),
+			    &dm_sm_bitmap_validator, &blk);
+	if (r < 0)
+		return r;
+	*result = sm_lookup_bitmap(dm_bitmap_data(blk),
+				   mod64(b, io->entries_per_block));
+	return dm_tm_unlock(io->tm, blk);
+}
+
+static int ll_lookup(struct ll_disk *io, dm_block_t b, uint32_t *result)
+{
+	int r = ll_lookup_bitmap(io, b, result);
+
+	if (r)
+		return r;
+
+	if (*result == 3) {
+		__le32 le_rc;
+		r = dm_btree_lookup(&io->ref_count_info, io->ref_count_root,
+				    &b, &le_rc);
+		if (r < 0)
+			return r;
+
+		*result = __le32_to_cpu(le_rc);
+	}
+
+	return r;
+}
+
+static int ll_find_free_block(struct ll_disk *io, dm_block_t begin,
+			      dm_block_t end, dm_block_t *result)
+{
+	int r;
+	struct index_entry ie;
+	dm_block_t i, index_begin = begin;
+	dm_block_t index_end = div_up(end, io->entries_per_block);
+
+	begin = do_div(index_begin, io->entries_per_block);
+	for (i = index_begin; i < index_end; i++, begin = 0) {
+		r = dm_btree_lookup(&io->bitmap_info, io->bitmap_root, &i, &ie);
+		if (r < 0)
+			return r;
+
+		if (__le32_to_cpu(ie.nr_free) > 0) {
+			struct dm_block *blk;
+			unsigned position;
+			uint32_t bit_end;
+
+			r = dm_tm_read_lock(io->tm, __le64_to_cpu(ie.blocknr),
+					    &dm_sm_bitmap_validator, &blk);
+			if (r < 0)
+				return r;
+
+			bit_end = (i == index_end - 1) ?
+				mod64(end, io->entries_per_block) : io->entries_per_block;
+
+			r = sm_find_free(dm_bitmap_data(blk),
+					 max((unsigned)begin,
+					     (unsigned)__le32_to_cpu(ie.none_free_before)),
+					 bit_end, &position);
+			if (r < 0) {
+				dm_tm_unlock(io->tm, blk);
+				continue;
+			}
+
+			r = dm_tm_unlock(io->tm, blk);
+			if (r < 0)
+				return r;
+
+			*result = i * io->entries_per_block + (dm_block_t) position;
+			return 0;
+		}
+	}
+
+	return -ENOSPC;
+}
+
+static int ll_insert(struct ll_disk *io, dm_block_t b, uint32_t ref_count)
+{
+	int r;
+	uint32_t bit, old;
+	struct dm_block *nb;
+	dm_block_t index = b;
+	struct index_entry ie;
+	void *bm;
+	int inc;
+
+	do_div(index, io->entries_per_block);
+	r = dm_btree_lookup(&io->bitmap_info, io->bitmap_root, &index, &ie);
+	if (r < 0)
+		return r;
+
+	r = dm_tm_shadow_block(io->tm, __le64_to_cpu(ie.blocknr),
+			       &dm_sm_bitmap_validator, &nb, &inc);
+	if (r < 0) {
+		DMERR("dm_tm_shadow_block() failed");
+		return r;
+	}
+	ie.blocknr = __cpu_to_le64(dm_block_location(nb));
+
+	bm = dm_bitmap_data(nb);
+	bit = mod64(b, io->entries_per_block);
+	old = sm_lookup_bitmap(bm, bit);
+
+	if (ref_count <= 2) {
+		sm_set_bitmap(bm, bit, ref_count);
+
+		if (old > 2) {
+			r = dm_btree_remove(&io->ref_count_info, io->ref_count_root,
+					    &b, &io->ref_count_root);
+			if (r) {
+				dm_tm_unlock(io->tm, nb);
+				return r;
+			}
+		}
+	} else {
+		__le32 le_rc = __cpu_to_le32(ref_count);
+		sm_set_bitmap(bm, bit, 3);
+		r = dm_btree_insert(&io->ref_count_info, io->ref_count_root,
+				    &b, &le_rc, &io->ref_count_root);
+		if (r < 0) {
+			dm_tm_unlock(io->tm, nb);
+			DMERR("ref count insert failed");
+			return r;
+		}
+	}
+
+	r = dm_tm_unlock(io->tm, nb);
+	if (r < 0)
+		return r;
+
+	if (ref_count && !old) {
+		io->nr_allocated++;
+		ie.nr_free = __cpu_to_le32(__le32_to_cpu(ie.nr_free) - 1);
+		if (__le32_to_cpu(ie.none_free_before) == b)
+			ie.none_free_before = __cpu_to_le32(b + 1);
+
+	} else if (old && !ref_count) {
+		io->nr_allocated--;
+		ie.nr_free = __cpu_to_le32(__le32_to_cpu(ie.nr_free) + 1);
+		ie.none_free_before = __cpu_to_le32(min((dm_block_t) __le32_to_cpu(ie.none_free_before), b));
+	}
+
+	r = dm_btree_insert(&io->bitmap_info, io->bitmap_root,
+			    &index, &ie, &io->bitmap_root);
+	if (r < 0)
+		return r;
+
+	return 0;
+}
+
+static int ll_inc(struct ll_disk *ll, dm_block_t b)
+{
+	int r;
+	uint32_t rc;
+
+	r = ll_lookup(ll, b, &rc);
+	if (r)
+		return r;
+
+	return ll_insert(ll, b, rc + 1);
+}
+
+static int ll_dec(struct ll_disk *ll, dm_block_t b)
+{
+	int r;
+	uint32_t rc;
+
+	r = ll_lookup(ll, b, &rc);
+	if (r)
+		return r;
+
+	if (!rc)
+		return -EINVAL;
+
+	return ll_insert(ll, b, rc - 1);
+}
+
+/*----------------------------------------------------------------
+ * Space map interface.
+ *--------------------------------------------------------------*/
+struct sm_disk {
+	struct dm_space_map sm;
+
+	struct ll_disk ll;
+};
+
+static void sm_disk_destroy(struct dm_space_map *sm)
+{
+	struct sm_disk *smd = container_of(sm, struct sm_disk, sm);
+	kfree(smd);
+}
+
+static int sm_disk_extend(struct dm_space_map *sm, dm_block_t extra_blocks)
+{
+	struct sm_disk *smd = container_of(sm, struct sm_disk, sm);
+	return ll_extend(&smd->ll, extra_blocks);
+}
+
+static int sm_disk_get_nr_blocks(struct dm_space_map *sm, dm_block_t *count)
+{
+	struct sm_disk *smd = container_of(sm, struct sm_disk, sm);
+	*count = smd->ll.nr_blocks;
+	return 0;
+}
+
+static int sm_disk_get_nr_free(struct dm_space_map *sm, dm_block_t *count)
+{
+	struct sm_disk *smd = container_of(sm, struct sm_disk, sm);
+
+	*count = smd->ll.nr_blocks - smd->ll.nr_allocated;
+	return 0;
+}
+
+static int sm_disk_get_count(struct dm_space_map *sm, dm_block_t b,
+			     uint32_t *result)
+{
+	struct sm_disk *smd = container_of(sm, struct sm_disk, sm);
+	return ll_lookup(&smd->ll, b, result);
+}
+
+static int sm_disk_count_is_more_than_one(struct dm_space_map *sm, dm_block_t b,
+					  int *result)
+{
+	int r;
+	uint32_t count;
+
+	r = sm_disk_get_count(sm, b, &count);
+	if (r)
+		return r;
+
+	return count > 1;
+}
+
+static int sm_disk_set_count(struct dm_space_map *sm, dm_block_t b,
+			     uint32_t count)
+{
+	struct sm_disk *smd = container_of(sm, struct sm_disk, sm);
+	return ll_insert(&smd->ll, b, count);
+}
+
+static int sm_disk_inc_block(struct dm_space_map *sm, dm_block_t b)
+{
+	struct sm_disk *smd = container_of(sm, struct sm_disk, sm);
+	return ll_inc(&smd->ll, b);
+}
+
+static int sm_disk_dec_block(struct dm_space_map *sm, dm_block_t b)
+{
+	struct sm_disk *smd = container_of(sm, struct sm_disk, sm);
+	return ll_dec(&smd->ll, b);
+}
+
+static int sm_disk_new_block(struct dm_space_map *sm, dm_block_t *b)
+{
+	int r;
+	struct sm_disk *smd = container_of(sm, struct sm_disk, sm);
+
+	/* FIXME: we should start the search where we left off */
+	r = ll_find_free_block(&smd->ll, 0, smd->ll.nr_blocks, b);
+	if (r)
+		return r;
+
+	return ll_inc(&smd->ll, *b);
+}
+
+static int sm_disk_commit(struct dm_space_map *sm)
+{
+	return 0;
+}
+
+static int sm_disk_root_size(struct dm_space_map *sm, size_t *result)
+{
+	*result = sizeof(struct sm_root);
+	return 0;
+}
+
+static int sm_disk_copy_root(struct dm_space_map *sm, void *where, size_t max)
+{
+	struct sm_disk *smd = container_of(sm, struct sm_disk, sm);
+	struct sm_root root;
+
+	root.nr_blocks = __cpu_to_le64(smd->ll.nr_blocks);
+	root.nr_allocated = __cpu_to_le64(smd->ll.nr_allocated);
+	root.bitmap_root = __cpu_to_le64(smd->ll.bitmap_root);
+	root.ref_count_root = __cpu_to_le64(smd->ll.ref_count_root);
+
+	if (max < sizeof(root))
+		return -ENOSPC;
+
+	memcpy(where, &root, sizeof(root));
+	return 0;
+}
+
+/*----------------------------------------------------------------*/
+
+static struct dm_space_map ops_ = {
+	.destroy = sm_disk_destroy,
+	.extend = sm_disk_extend,
+	.get_nr_blocks = sm_disk_get_nr_blocks,
+	.get_nr_free = sm_disk_get_nr_free,
+	.get_count = sm_disk_get_count,
+	.count_is_more_than_one = sm_disk_count_is_more_than_one,
+	.set_count = sm_disk_set_count,
+	.inc_block = sm_disk_inc_block,
+	.dec_block = sm_disk_dec_block,
+	.new_block = sm_disk_new_block,
+	.commit = sm_disk_commit,
+	.root_size = sm_disk_root_size,
+	.copy_root = sm_disk_copy_root
+};
+
+struct dm_space_map *dm_sm_disk_create(struct dm_transaction_manager *tm,
+				       dm_block_t nr_blocks)
+{
+	int r;
+	struct sm_disk *smd;
+
+	smd = kmalloc(sizeof(*smd), GFP_KERNEL);
+	if (!smd)
+		return ERR_PTR(-ENOMEM);
+
+	memcpy(&smd->sm, &ops_, sizeof(smd->sm));
+
+	r = ll_new(&smd->ll, tm);
+	if (r)
+		return ERR_PTR(r);
+
+	r = ll_extend(&smd->ll, nr_blocks);
+	if (r)
+		return ERR_PTR(r);
+
+	r = sm_disk_commit(&smd->sm);
+	if (r)
+		return ERR_PTR(r);
+
+	return &smd->sm;
+}
+EXPORT_SYMBOL_GPL(dm_sm_disk_create);
+
+struct dm_space_map *dm_sm_disk_open(struct dm_transaction_manager *tm,
+				     void *root, size_t len)
+{
+	int r;
+	struct sm_disk *smd;
+
+	smd = kmalloc(sizeof(*smd), GFP_KERNEL);
+	if (!smd)
+		return ERR_PTR(-ENOMEM);
+
+	memcpy(&smd->sm, &ops_, sizeof(smd->sm));
+
+	r = ll_open(&smd->ll, tm, root, len);
+	if (r)
+		return ERR_PTR(r);
+
+	r = sm_disk_commit(&smd->sm);
+	if (r)
+		return ERR_PTR(r);
+
+	return &smd->sm;
+}
+EXPORT_SYMBOL_GPL(dm_sm_disk_open);
diff --git a/drivers/md/persistent-data/dm-space-map-disk.h b/drivers/md/persistent-data/dm-space-map-disk.h
new file mode 100644
index 0000000..d13450d
--- /dev/null
+++ b/drivers/md/persistent-data/dm-space-map-disk.h
@@ -0,0 +1,21 @@
+#ifndef DM_SPACE_MAP_DISK_H
+#define DM_SPACE_MAP_DISK_H
+
+#include "dm-transaction-manager.h"
+#include "dm-space-map.h"
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Unfortunately we have to use 2 phase construction due to the cycle
+ * between the tm and sm.
+ */
+struct dm_space_map *dm_sm_disk_create(struct dm_transaction_manager *tm,
+				       dm_block_t nr_blocks);
+
+struct dm_space_map *dm_sm_disk_open(struct dm_transaction_manager *tm,
+				     void *root, size_t len);
+
+/*----------------------------------------------------------------*/
+
+#endif
diff --git a/drivers/md/persistent-data/dm-space-map-metadata.c b/drivers/md/persistent-data/dm-space-map-metadata.c
new file mode 100644
index 0000000..6263601
--- /dev/null
+++ b/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -0,0 +1,878 @@
+#include "dm-space-map-common.h"
+#include "dm-space-map-metadata.h"
+
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <asm-generic/bitops/le.h>
+#include <linux/device-mapper.h> /* For DMERR */
+
+#define DM_MSG_PREFIX "space map metadata"
+
+/*----------------------------------------------------------------
+ * index validator
+ *--------------------------------------------------------------*/
+static void index_prepare_for_write(struct dm_block_validator *v,
+				    struct dm_block *b,
+				    size_t block_size)
+{
+	struct metadata_index *mi = dm_block_data(b);
+	mi->blocknr = __cpu_to_le64(dm_block_location(b));
+	mi->csum = dm_block_csum_data(&mi->padding,
+				      block_size - sizeof(__le32));
+}
+
+static int index_check(struct dm_block_validator *v,
+		       struct dm_block *b,
+		       size_t block_size)
+{
+	struct metadata_index *mi = dm_block_data(b);
+	__le32 csum;
+
+	if (dm_block_location(b) != __le64_to_cpu(mi->blocknr)) {
+		DMERR("index_check failed blocknr %llu wanted %llu",
+		      __le64_to_cpu(mi->blocknr), dm_block_location(b));
+		return -ENOTBLK;
+	}
+
+	csum = dm_block_csum_data(&mi->padding,
+				  block_size - sizeof(__le32));
+	if (csum != mi->csum) {
+		DMERR("index_check failed csum %u wanted %u",
+		      __le32_to_cpu(csum), __le32_to_cpu(mi->csum));
+		return -EILSEQ;
+	}
+
+	return 0;
+}
+
+static struct dm_block_validator index_validator_ = {
+	.name = "index",
+	.prepare_for_write = index_prepare_for_write,
+	.check = index_check
+};
+
+/*----------------------------------------------------------------
+ * low level disk ops
+ *--------------------------------------------------------------*/
+static int ll_init(struct ll_disk *ll, struct dm_transaction_manager *tm)
+{
+	ll->tm = tm;
+
+	ll->ref_count_info.tm = tm;
+	ll->ref_count_info.levels = 1;
+	ll->ref_count_info.value_type.size = sizeof(uint32_t);
+	ll->ref_count_info.value_type.inc = NULL;
+	ll->ref_count_info.value_type.dec = NULL;
+	ll->ref_count_info.value_type.equal = NULL;
+
+	ll->block_size = dm_bm_block_size(dm_tm_get_bm(tm));
+
+	if (ll->block_size > (1 << 30)) {
+		DMERR("block size too big to hold bitmaps");
+		return -EINVAL;
+	}
+	ll->entries_per_block = (ll->block_size - sizeof(struct bitmap_header)) *
+		ENTRIES_PER_BYTE;
+	ll->nr_blocks = 0;
+	ll->bitmap_root = 0;
+	ll->ref_count_root = 0;
+
+	return 0;
+}
+
+static int ll_new(struct ll_disk *ll, struct dm_transaction_manager *tm,
+		  dm_block_t nr_blocks)
+{
+	int r;
+	dm_block_t i;
+	unsigned blocks;
+	struct dm_block *index_block;
+
+	r = ll_init(ll, tm);
+	if (r < 0)
+		return r;
+
+	ll->nr_blocks = nr_blocks;
+	ll->nr_allocated = 0;
+
+	blocks = div_up(nr_blocks, ll->entries_per_block);
+	for (i = 0; i < blocks; i++) {
+		struct dm_block *b;
+		struct index_entry *idx = ll->mi.index + i;
+
+		r = dm_tm_new_block(tm, &dm_sm_bitmap_validator, &b);
+		if (r < 0)
+			return r;
+		idx->blocknr = __cpu_to_le64(dm_block_location(b));
+
+		r = dm_tm_unlock(tm, b);
+		if (r < 0)
+			return r;
+
+		idx->nr_free = __cpu_to_le32(ll->entries_per_block);
+		idx->none_free_before = 0;
+	}
+
+	/* write the index */
+	r = dm_tm_new_block(tm, &index_validator_, &index_block);
+	if (r)
+		return r;
+	ll->bitmap_root = dm_block_location(index_block);
+	memcpy(dm_block_data(index_block), &ll->mi, sizeof(ll->mi));
+	r = dm_tm_unlock(tm, index_block);
+	if (r)
+		return r;
+
+	r = dm_btree_empty(&ll->ref_count_info, &ll->ref_count_root);
+	if (r < 0)
+		return r;
+
+	return 0;
+}
+
+static int ll_open(struct ll_disk *ll, struct dm_transaction_manager *tm,
+		   void *root, size_t len)
+{
+	int r;
+	struct sm_root *smr = (struct sm_root *) root;
+	struct dm_block *block;
+
+	if (len < sizeof(struct sm_root)) {
+		DMERR("sm_disk root too small");
+		return -ENOMEM;
+	}
+
+	r = ll_init(ll, tm);
+	if (r < 0)
+		return r;
+
+	ll->nr_blocks = __le64_to_cpu(smr->nr_blocks);
+	ll->nr_allocated = __le64_to_cpu(smr->nr_allocated);
+	ll->bitmap_root = __le64_to_cpu(smr->bitmap_root);
+
+	r = dm_tm_read_lock(tm, __le64_to_cpu(smr->bitmap_root),
+			    &index_validator_, &block);
+	if (r)
+		return r;
+	memcpy(&ll->mi, dm_block_data(block), sizeof(ll->mi));
+	r = dm_tm_unlock(tm, block);
+	if (r)
+		return r;
+
+	ll->ref_count_root = __le64_to_cpu(smr->ref_count_root);
+	return 0;
+}
+
+static int ll_lookup_bitmap(struct ll_disk *ll, dm_block_t b, uint32_t *result)
+{
+	int r;
+	dm_block_t index = b;
+	struct index_entry *ie;
+	struct dm_block *blk;
+
+	b = do_div(index, ll->entries_per_block);
+	ie = ll->mi.index + index;
+
+	r = dm_tm_read_lock(ll->tm, __le64_to_cpu(ie->blocknr),
+			    &dm_sm_bitmap_validator, &blk);
+	if (r < 0)
+		return r;
+	*result = sm_lookup_bitmap(dm_bitmap_data(blk), b);
+	return dm_tm_unlock(ll->tm, blk);
+}
+
+static int ll_lookup(struct ll_disk *ll, dm_block_t b, uint32_t *result)
+{
+	int r = ll_lookup_bitmap(ll, b, result);
+
+	if (r)
+		return r;
+
+	if (*result == 3) {
+		__le32 le_rc;
+		r = dm_btree_lookup(&ll->ref_count_info, ll->ref_count_root,
+				    &b, &le_rc);
+		if (r < 0)
+			return r;
+
+		*result = __le32_to_cpu(le_rc);
+	}
+
+	return r;
+}
+
+static int ll_find_free_block(struct ll_disk *ll, dm_block_t begin,
+			      dm_block_t end, dm_block_t *result)
+{
+	int r;
+	struct index_entry *ie;
+	dm_block_t i, index_begin = begin;
+	dm_block_t index_end = div_up(end, ll->entries_per_block);
+
+	/* FIXME: use shifts */
+	begin = do_div(index_begin, ll->entries_per_block);
+	end = do_div(end, ll->entries_per_block);
+
+	for (i = index_begin; i < index_end; i++, begin = 0) {
+		ie = ll->mi.index + i;
+
+		if (__le32_to_cpu(ie->nr_free) > 0) {
+			struct dm_block *blk;
+			unsigned position;
+			uint32_t bit_end;
+
+			r = dm_tm_read_lock(ll->tm, __le64_to_cpu(ie->blocknr),
+					    &dm_sm_bitmap_validator, &blk);
+			if (r < 0)
+				return r;
+
+			bit_end = (i == index_end - 1) ?
+				end : ll->entries_per_block;
+
+			r = sm_find_free(dm_bitmap_data(blk), begin,
+					 bit_end, &position);
+			if (r < 0) {
+				dm_tm_unlock(ll->tm, blk);
+				return r; /* avoiding retry (FIXME: explain why) */
+			}
+
+			r = dm_tm_unlock(ll->tm, blk);
+			if (r < 0)
+				return r;
+
+			*result = i * ll->entries_per_block +
+				(dm_block_t) position;
+			return 0;
+		}
+	}
+
+	return -ENOSPC;
+}
+
+static int ll_insert(struct ll_disk *ll, dm_block_t b, uint32_t ref_count)
+{
+	int r;
+	uint32_t bit, old;
+	struct dm_block *nb;
+	dm_block_t index = b;
+	struct index_entry *ie;
+	void *bm;
+	int inc;
+
+	bit = do_div(index, ll->entries_per_block);
+	ie = ll->mi.index + index;
+
+	r = dm_tm_shadow_block(ll->tm, __le64_to_cpu(ie->blocknr),
+			       &dm_sm_bitmap_validator, &nb, &inc);
+	if (r < 0) {
+		DMERR("dm_tm_shadow_block() failed");
+		return r;
+	}
+	ie->blocknr = __cpu_to_le64(dm_block_location(nb));
+
+	bm = dm_bitmap_data(nb);
+	old = sm_lookup_bitmap(bm, bit);
+
+	if (ref_count <= 2) {
+		sm_set_bitmap(bm, bit, ref_count);
+
+		r = dm_tm_unlock(ll->tm, nb);
+		if (r < 0)
+			return r;
+
+		if (old > 2) {
+			r = dm_btree_remove(&ll->ref_count_info,
+					    ll->ref_count_root,
+					    &b, &ll->ref_count_root);
+			if (r) {
+				sm_set_bitmap(bm, bit, old);
+				return r;
+			}
+		}
+	} else {
+		__le32 le_rc = __cpu_to_le32(ref_count);
+		sm_set_bitmap(bm, bit, 3);
+		r = dm_tm_unlock(ll->tm, nb);
+		if (r < 0)
+			return r;
+
+		r = dm_btree_insert(&ll->ref_count_info, ll->ref_count_root,
+				    &b, &le_rc, &ll->ref_count_root);
+		if (r < 0) {
+			/* FIXME: release shadow? or assume the whole transaction will be ditched */
+			DMERR("ref count insert failed");
+			return r;
+		}
+	}
+
+	if (ref_count && !old) {
+		ll->nr_allocated++;
+		ie->nr_free = __cpu_to_le32(__le32_to_cpu(ie->nr_free) - 1);
+		if (__le32_to_cpu(ie->none_free_before) == b)
+			ie->none_free_before = __cpu_to_le32(b + 1);
+
+	} else if (old && !ref_count) {
+		ll->nr_allocated--;
+		ie->nr_free = __cpu_to_le32(__le32_to_cpu(ie->nr_free) + 1);
+		ie->none_free_before = __cpu_to_le32(min((dm_block_t) __le32_to_cpu(ie->none_free_before), b));
+	}
+
+	return 0;
+}
+
+static int ll_inc(struct ll_disk *ll, dm_block_t b)
+{
+	int r;
+	uint32_t rc;
+
+	r = ll_lookup(ll, b, &rc);
+	if (r)
+		return r;
+
+	return ll_insert(ll, b, rc + 1);
+}
+
+static int ll_dec(struct ll_disk *ll, dm_block_t b)
+{
+	int r;
+	uint32_t rc;
+
+	r = ll_lookup(ll, b, &rc);
+	if (r)
+		return r;
+
+	if (!rc)
+		return -EINVAL;
+
+	return ll_insert(ll, b, rc - 1);
+}
+
+static int ll_commit(struct ll_disk *ll)
+{
+	int r, inc;
+	struct dm_block *b;
+
+	r = dm_tm_shadow_block(ll->tm, ll->bitmap_root,
+			       &index_validator_, &b, &inc);
+	if (r)
+		return r;
+
+	memcpy(dm_block_data(b), &ll->mi, sizeof(ll->mi));
+	ll->bitmap_root = dm_block_location(b);
+	return dm_tm_unlock(ll->tm, b);
+}
+
+/*----------------------------------------------------------------
+ * Space map interface.
+ *
+ * The low level disk format is written using the standard btree and
+ * transaction manager.  This means that performing disk operations may
+ * cause us to recurse into the space map in order to allocate new blocks.
+ * For this reason we have a pool of pre-allocated blocks large enough to
+ * service any ll_disk operation.
+ *--------------------------------------------------------------*/
+
+/*
+ * FIXME: we should calculate this based on the size of the device.
+ * Only the metadata space map needs this functionality.
+ */
+#define MAX_RECURSIVE_ALLOCATIONS 1024
+
+enum block_op_type {
+	BOP_INC,
+	BOP_DEC
+};
+
+struct block_op {
+	enum block_op_type type;
+	dm_block_t block;
+};
+
+struct sm_metadata {
+	struct dm_space_map sm;
+
+	struct ll_disk ll;
+	struct ll_disk old_ll;
+
+	dm_block_t begin;
+
+	unsigned recursion_count;
+	unsigned allocated_this_transaction;
+	unsigned nr_uncommitted;
+	struct block_op uncommitted[MAX_RECURSIVE_ALLOCATIONS];
+};
+
+static int add_bop(struct sm_metadata *smm, enum block_op_type type, dm_block_t b)
+{
+	struct block_op *op;
+
+	if (smm->nr_uncommitted == MAX_RECURSIVE_ALLOCATIONS) {
+		BUG();
+		return -1;
+	}
+
+	op = smm->uncommitted + smm->nr_uncommitted++;
+	op->type = type;
+	op->block = b;
+	return 0;
+}
+
+static int commit_bop(struct sm_metadata *smm, struct block_op *op)
+{
+	int r = 0;
+
+	switch (op->type) {
+	case BOP_INC:
+		r = ll_inc(&smm->ll, op->block);
+		break;
+
+	case BOP_DEC:
+		r = ll_dec(&smm->ll, op->block);
+		break;
+	}
+
+	return r;
+}
+
+static void in(struct sm_metadata *smm)
+{
+	smm->recursion_count++;
+}
+
+static void out(struct sm_metadata *smm)
+{
+	int r = 0;
+	BUG_ON(!smm->recursion_count);
+
+	if (smm->recursion_count == 1 && smm->nr_uncommitted) {
+		while (smm->nr_uncommitted && !r) {
+			smm->nr_uncommitted--;
+			r = commit_bop(smm, smm->uncommitted +
+				       smm->nr_uncommitted);
+		}
+	}
+
+	smm->recursion_count--;
+}
+
+static void no_recurse(struct sm_metadata *smm)
+{
+	BUG_ON(smm->recursion_count);
+}
+
+static int recursing(struct sm_metadata *smm)
+{
+	return smm->recursion_count;
+}
+
+static void sm_metadata_destroy(struct dm_space_map *sm)
+{
+	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
+	kfree(smm);
+}
+
+static int sm_metadata_extend(struct dm_space_map *sm, dm_block_t extra_blocks)
+{
+	BUG();
+	return -1;
+}
+
+static int sm_metadata_get_nr_blocks(struct dm_space_map *sm, dm_block_t *count)
+{
+	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
+	*count = smm->ll.nr_blocks;
+	return 0;
+}
+
+static int sm_metadata_get_nr_free(struct dm_space_map *sm, dm_block_t *count)
+{
+	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
+
+	*count = smm->old_ll.nr_blocks - smm->old_ll.nr_allocated -
+		smm->allocated_this_transaction;
+	return 0;
+}
+
+static int sm_metadata_get_count(struct dm_space_map *sm, dm_block_t b,
+				 uint32_t *result)
+{
+	int r, i;
+	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
+	unsigned adjustment = 0;
+
+	/*
+	 * we may have some uncommitted adjustments to add.  This list
+	 * should always be really short.
+	 */
+	for (i = 0; i < smm->nr_uncommitted; i++) {
+		struct block_op *op = smm->uncommitted + i;
+		if (op->block == b)
+			switch (op->type) {
+			case BOP_INC:
+				adjustment++;
+				break;
+
+			case BOP_DEC:
+				adjustment--;
+				break;
+			}
+	}
+
+	r = ll_lookup(&smm->ll, b, result);
+	if (r)
+		return r;
+	*result += adjustment;
+
+	return 0;
+}
+
+static int sm_metadata_count_is_more_than_one(struct dm_space_map *sm,
+					      dm_block_t b, int *result)
+{
+	int r, i, adjustment = 0;
+	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
+	uint32_t rc;
+
+	/*
+	 * we may have some uncommitted adjustments to add.  This list
+	 * should always be really short.
+	 */
+	for (i = 0; i < smm->nr_uncommitted; i++) {
+		struct block_op *op = smm->uncommitted + i;
+		if (op->block == b)
+			switch (op->type) {
+			case BOP_INC:
+				adjustment++;
+				break;
+
+			case BOP_DEC:
+				adjustment--;
+				break;
+			}
+	}
+
+	if (adjustment > 1) {
+		*result = 1;
+		return 0;
+	}
+
+	r = ll_lookup_bitmap(&smm->ll, b, &rc);
+	if (r)
+		return r;
+
+	if (rc == 3)
+		/* we err on the side of caution, and always return true */
+		*result = 1;
+	else
+		*result = rc + adjustment > 1;
+
+	return 0;
+}
+
+static int sm_metadata_set_count(struct dm_space_map *sm, dm_block_t b,
+				 uint32_t count)
+{
+	int r;
+	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
+
+	no_recurse(smm);
+
+	in(smm);
+	r = ll_insert(&smm->ll, b, count);
+	out(smm);
+	return r;
+}
+
+static int sm_metadata_inc_block(struct dm_space_map *sm, dm_block_t b)
+{
+	int r;
+	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
+
+	if (recursing(smm))
+		r = add_bop(smm, BOP_INC, b);
+
+	else {
+		in(smm);
+		r = ll_inc(&smm->ll, b);
+		out(smm);
+	}
+	return r;
+}
+
+static int sm_metadata_dec_block(struct dm_space_map *sm, dm_block_t b)
+{
+	int r;
+	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
+
+	if (recursing(smm))
+		r = add_bop(smm, BOP_DEC, b);
+
+	else {
+		in(smm);
+		r = ll_dec(&smm->ll, b);
+		out(smm);
+	}
+	return r;
+}
+
+static int sm_metadata_new_block(struct dm_space_map *sm, dm_block_t *b)
+{
+	int r;
+	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
+
+	r = ll_find_free_block(&smm->old_ll, smm->begin, smm->old_ll.nr_blocks, b);
+	if (r)
+		return r;
+
+	smm->begin = *b + 1;
+
+	if (recursing(smm))
+		r = add_bop(smm, BOP_INC, *b);
+
+	else {
+		in(smm);
+		r = ll_inc(&smm->ll, *b);
+		out(smm);
+	}
+
+	if (!r)
+		smm->allocated_this_transaction++;
+	return r;
+}
+
+static int sm_metadata_commit(struct dm_space_map *sm)
+{
+	int r;
+	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
+
+	memcpy(&smm->old_ll, &smm->ll, sizeof(smm->old_ll));
+
+	r = ll_commit(&smm->ll);
+	if (r)
+		return r;
+
+	memcpy(&smm->old_ll, &smm->ll, sizeof(smm->old_ll));
+	smm->begin = 0;
+	smm->allocated_this_transaction = 0;
+	return 0;
+}
+
+static int sm_metadata_root_size(struct dm_space_map *sm, size_t *result)
+{
+	*result = sizeof(struct sm_root);
+	return 0;
+}
+
+static int sm_metadata_copy_root(struct dm_space_map *sm, void *where, size_t max)
+{
+	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
+	struct sm_root root;
+
+	root.nr_blocks = __cpu_to_le64(smm->ll.nr_blocks);
+	root.nr_allocated = __cpu_to_le64(smm->ll.nr_allocated);
+	root.bitmap_root = __cpu_to_le64(smm->ll.bitmap_root);
+	root.ref_count_root = __cpu_to_le64(smm->ll.ref_count_root);
+
+	if (max < sizeof(root))
+		return -ENOSPC;
+
+	memcpy(where, &root, sizeof(root));
+
+	return 0;
+}
+
+static struct dm_space_map ops_ = {
+	.destroy = sm_metadata_destroy,
+	.extend = sm_metadata_extend,
+	.get_nr_blocks = sm_metadata_get_nr_blocks,
+	.get_nr_free = sm_metadata_get_nr_free,
+	.get_count = sm_metadata_get_count,
+	.count_is_more_than_one = sm_metadata_count_is_more_than_one,
+	.set_count = sm_metadata_set_count,
+	.inc_block = sm_metadata_inc_block,
+	.dec_block = sm_metadata_dec_block,
+	.new_block = sm_metadata_new_block,
+	.commit = sm_metadata_commit,
+	.root_size = sm_metadata_root_size,
+	.copy_root = sm_metadata_copy_root
+};
+
+/*----------------------------------------------------------------*/
+
+/*
+ * When a new space map is created, that manages it's own space.  We use
+ * this tiny bootstrap allocator.
+ */
+static void sm_bootstrap_destroy(struct dm_space_map *sm)
+{
+	BUG();
+}
+
+static int sm_bootstrap_extend(struct dm_space_map *sm, dm_block_t extra_blocks)
+{
+	BUG();
+	return -1;
+}
+
+static int sm_bootstrap_get_nr_blocks(struct dm_space_map *sm, dm_block_t *count)
+{
+	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
+	return smm->ll.nr_blocks;
+}
+
+static int sm_bootstrap_get_nr_free(struct dm_space_map *sm, dm_block_t *count)
+{
+	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
+	*count = smm->ll.nr_blocks - smm->begin;
+	return 0;
+}
+
+static int sm_bootstrap_get_count(struct dm_space_map *sm, dm_block_t b,
+				  uint32_t *result)
+{
+	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
+	return b < smm->begin ? 1 : 0;
+}
+
+static int sm_bootstrap_count_is_more_than_one(struct dm_space_map *sm,
+					       dm_block_t b, int *result)
+{
+	*result = 0;
+	return 0;
+}
+
+static int sm_bootstrap_set_count(struct dm_space_map *sm, dm_block_t b,
+				  uint32_t count)
+{
+	BUG();
+	return -1;
+}
+
+static int sm_bootstrap_new_block(struct dm_space_map *sm, dm_block_t *b)
+{
+	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
+
+	/*
+	 * We know the entire device is unused.
+	 */
+	if (smm->begin == smm->ll.nr_blocks)
+		return -ENOSPC;
+
+	*b = smm->begin++;
+	return 0;
+}
+
+static int sm_bootstrap_inc_block(struct dm_space_map *sm, dm_block_t b)
+{
+	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
+	return add_bop(smm, BOP_INC, b);
+}
+
+static int sm_bootstrap_dec_block(struct dm_space_map *sm, dm_block_t b)
+{
+	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
+	return add_bop(smm, BOP_DEC, b);
+}
+
+static int sm_bootstrap_commit(struct dm_space_map *sm)
+{
+	return 0;
+}
+
+static int sm_bootstrap_root_size(struct dm_space_map *sm, size_t *result)
+{
+	BUG();
+	return -1;
+}
+
+static int sm_bootstrap_copy_root(struct dm_space_map *sm, void *where,
+				  size_t max)
+{
+	BUG();
+	return -1;
+}
+
+static struct dm_space_map bootstrap_ops_ = {
+	.destroy = sm_bootstrap_destroy,
+	.extend = sm_bootstrap_extend,
+	.get_nr_blocks = sm_bootstrap_get_nr_blocks,
+	.get_nr_free = sm_bootstrap_get_nr_free,
+	.get_count = sm_bootstrap_get_count,
+	.count_is_more_than_one = sm_bootstrap_count_is_more_than_one,
+	.set_count = sm_bootstrap_set_count,
+	.inc_block = sm_bootstrap_inc_block,
+	.dec_block = sm_bootstrap_dec_block,
+	.new_block = sm_bootstrap_new_block,
+	.commit = sm_bootstrap_commit,
+	.root_size = sm_bootstrap_root_size,
+	.copy_root = sm_bootstrap_copy_root
+};
+
+/*----------------------------------------------------------------*/
+
+struct dm_space_map *dm_sm_metadata_init(void)
+{
+	struct sm_metadata *smm;
+
+	smm = kmalloc(sizeof(*smm), GFP_KERNEL);
+	if (!smm)
+		return ERR_PTR(-ENOMEM);
+
+	memcpy(&smm->sm, &ops_, sizeof(smm->sm));
+	return &smm->sm;
+}
+EXPORT_SYMBOL_GPL(dm_sm_metadata_init);
+
+int dm_sm_metadata_create(struct dm_space_map *sm,
+			  struct dm_transaction_manager *tm,
+			  dm_block_t nr_blocks,
+			  dm_block_t superblock)
+{
+	int r;
+	dm_block_t i;
+	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
+
+	smm->begin = superblock + 1;
+	smm->recursion_count = 0;
+	smm->allocated_this_transaction = 0;
+	smm->nr_uncommitted = 0;
+
+	memcpy(&smm->sm, &bootstrap_ops_, sizeof(smm->sm));
+	r = ll_new(&smm->ll, tm, nr_blocks);
+	if (r)
+		return r;
+	memcpy(&smm->sm, &ops_, sizeof(smm->sm));
+
+	/*
+	 * Now we need to update the newly created data structures with the
+	 * allocated blocks that they were built from.
+	 */
+	for (i = superblock; !r && i < smm->begin; i++)
+		r = ll_inc(&smm->ll, i);
+
+	if (r)
+		return r;
+
+	return sm_metadata_commit(sm);
+}
+EXPORT_SYMBOL_GPL(dm_sm_metadata_create);
+
+int dm_sm_metadata_open(struct dm_space_map *sm,
+			struct dm_transaction_manager *tm,
+			void *root, size_t len)
+{
+	int r;
+	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
+
+	r = ll_open(&smm->ll, tm, root, len);
+	if (r)
+		return r;
+
+	smm->begin = 0;
+	smm->recursion_count = 0;
+	smm->allocated_this_transaction = 0;
+	smm->nr_uncommitted = 0;
+
+	return sm_metadata_commit(sm);
+}
+EXPORT_SYMBOL_GPL(dm_sm_metadata_open);
diff --git a/drivers/md/persistent-data/dm-space-map-metadata.h b/drivers/md/persistent-data/dm-space-map-metadata.h
new file mode 100644
index 0000000..412c196
--- /dev/null
+++ b/drivers/md/persistent-data/dm-space-map-metadata.h
@@ -0,0 +1,29 @@
+#ifndef DM_SPACE_MAP_METADATA_H
+#define DM_SPACE_MAP_METADATA_H
+
+#include "dm-transaction-manager.h"
+#include "dm-space-map.h"
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Unfortunately we have to use 2 phase construction due to the cycle
+ * between the tm and sm.
+ */
+struct dm_space_map *dm_sm_metadata_init(void);
+
+/* create a fresh space map */
+int dm_sm_metadata_create(struct dm_space_map *sm,
+			  struct dm_transaction_manager *tm,
+			  dm_block_t nr_blocks,
+			  dm_block_t superblock);
+
+
+/* Open from a previously recorded root */
+int dm_sm_metadata_open(struct dm_space_map *sm,
+			struct dm_transaction_manager *tm,
+			void *root, size_t len);
+
+/*----------------------------------------------------------------*/
+
+#endif
diff --git a/drivers/md/persistent-data/dm-space-map.h b/drivers/md/persistent-data/dm-space-map.h
new file mode 100644
index 0000000..8e73daa
--- /dev/null
+++ b/drivers/md/persistent-data/dm-space-map.h
@@ -0,0 +1,116 @@
+#ifndef DM_SPACE_MAP_H
+#define DM_SPACE_MAP_H
+
+#include "dm-block-manager.h"
+
+/*----------------------------------------------------------------*/
+
+/*
+ * This structure keeps a record of how many times each block in a device
+ * is referenced.  It needs to be persisted to disk as part of the
+ * transaction.
+ */
+struct dm_space_map {
+	void (*destroy)(struct dm_space_map *sm);
+
+	int (*extend)(struct dm_space_map *sm, dm_block_t extra_blocks);
+
+	int (*get_nr_blocks)(struct dm_space_map *sm, dm_block_t *count);
+	int (*get_nr_free)(struct dm_space_map *sm, dm_block_t *count);
+
+	int (*get_count)(struct dm_space_map *sm, dm_block_t b, uint32_t *result);
+	int (*count_is_more_than_one)(struct dm_space_map *sm, dm_block_t b,
+				      int *result);
+	int (*set_count)(struct dm_space_map *sm, dm_block_t b, uint32_t count);
+
+	int (*commit)(struct dm_space_map *sm);
+
+	int (*inc_block)(struct dm_space_map *sm, dm_block_t b);
+	int (*dec_block)(struct dm_space_map *sm, dm_block_t b);
+
+	/* new_block will increment the returned block */
+	int (*new_block)(struct dm_space_map *sm, dm_block_t *b);
+
+	/*
+	 * The root contains all the information needed to persist the
+	 * space map.  Generally this info is small, squirrel it away in a
+	 * disk block along with other info.
+	 */
+	int (*root_size)(struct dm_space_map *sm, size_t *result);
+	int (*copy_root)(struct dm_space_map *sm, void *copy_to_here, size_t len);
+};
+
+/*----------------------------------------------------------------*/
+
+static inline void dm_sm_destroy(struct dm_space_map *sm)
+{
+	sm->destroy(sm);
+}
+
+static inline int dm_sm_extend(struct dm_space_map *sm, dm_block_t extra_blocks)
+{
+	return sm->extend(sm, extra_blocks);
+}
+
+static inline int dm_sm_get_nr_blocks(struct dm_space_map *sm, dm_block_t *count)
+{
+	return sm->get_nr_blocks(sm, count);
+}
+
+static inline int dm_sm_get_nr_free(struct dm_space_map *sm, dm_block_t *count)
+{
+	return sm->get_nr_free(sm, count);
+}
+
+static inline int dm_sm_get_count(struct dm_space_map *sm, dm_block_t b,
+				  uint32_t *result)
+{
+	return sm->get_count(sm, b, result);
+}
+
+static inline int dm_sm_count_is_more_than_one(struct dm_space_map *sm,
+					       dm_block_t b, int *result)
+{
+	return sm->count_is_more_than_one(sm, b, result);
+}
+
+static inline int dm_sm_set_count(struct dm_space_map *sm, dm_block_t b,
+				  uint32_t count)
+{
+	return sm->set_count(sm, b, count);
+}
+
+static inline int dm_sm_commit(struct dm_space_map *sm)
+{
+	return sm->commit(sm);
+}
+
+static inline int dm_sm_inc_block(struct dm_space_map *sm, dm_block_t b)
+{
+	return sm->inc_block(sm, b);
+}
+
+static inline int dm_sm_dec_block(struct dm_space_map *sm, dm_block_t b)
+{
+	return sm->dec_block(sm, b);
+}
+
+static inline int dm_sm_new_block(struct dm_space_map *sm, dm_block_t *b)
+{
+	return sm->new_block(sm, b);
+}
+
+static inline int dm_sm_root_size(struct dm_space_map *sm, size_t *result)
+{
+	return sm->root_size(sm, result);
+}
+
+static inline int dm_sm_copy_root(struct dm_space_map *sm,
+				  void *copy_to_here, size_t len)
+{
+	return sm->copy_root(sm, copy_to_here, len);
+}
+
+/*----------------------------------------------------------------*/
+
+#endif
diff --git a/drivers/md/persistent-data/dm-transaction-manager.c b/drivers/md/persistent-data/dm-transaction-manager.c
new file mode 100644
index 0000000..28042a9
--- /dev/null
+++ b/drivers/md/persistent-data/dm-transaction-manager.c
@@ -0,0 +1,442 @@
+#include "dm-transaction-manager.h"
+#include "dm-space-map-disk.h"
+#include "dm-space-map-metadata.h"
+
+#include <linux/slab.h>
+#include <linux/device-mapper.h> /* For DMERR */
+
+#define DM_MSG_PREFIX "transaction manager"
+
+/*----------------------------------------------------------------*/
+
+struct shadow_info {
+	struct hlist_node hlist;
+	dm_block_t where;
+};
+
+/* it would be nice if we scaled with the size of transaction */
+#define HASH_SIZE 256
+#define HASH_MASK (HASH_SIZE - 1)
+struct dm_transaction_manager {
+	int is_clone;
+	struct dm_transaction_manager *real;
+
+	struct dm_block_manager *bm;
+	struct dm_space_map *sm;
+
+	struct hlist_head buckets[HASH_SIZE];
+
+	/* stats */
+	unsigned shadow_count;
+};
+
+/*----------------------------------------------------------------*/
+
+/* FIXME: similar code in block-manager */
+static unsigned hash_block(dm_block_t b)
+{
+	const unsigned BIG_PRIME = 4294967291UL;
+	return (((unsigned) b) * BIG_PRIME) & HASH_MASK;
+}
+
+static int is_shadow(struct dm_transaction_manager *tm, dm_block_t b)
+{
+	unsigned bucket = hash_block(b);
+	struct shadow_info *si;
+	struct hlist_node *n;
+
+	hlist_for_each_entry(si, n, tm->buckets + bucket, hlist)
+		if (si->where == b)
+			return 1;
+
+	return 0;
+}
+
+/*
+ * This can silently fail if there's no memory.  We're ok with this since
+ * creating redundant shadows causes no harm.
+ */
+static void insert_shadow(struct dm_transaction_manager *tm, dm_block_t b)
+{
+	unsigned bucket;
+	struct shadow_info *si;
+
+	si = kmalloc(sizeof(*si), GFP_NOIO);
+	if (si) {
+		si->where = b;
+		bucket = hash_block(b);
+		hlist_add_head(&si->hlist, tm->buckets + bucket);
+	}
+}
+
+static void wipe_shadow_table(struct dm_transaction_manager *tm)
+{
+	int i;
+	for (i = 0; i < HASH_SIZE; i++) {
+		struct shadow_info *si;
+		struct hlist_node *n, *tmp;
+		struct hlist_head *bucket = tm->buckets + i;
+		hlist_for_each_entry_safe(si, n, tmp, bucket, hlist)
+			kfree(si);
+
+		INIT_HLIST_HEAD(bucket);
+	}
+
+	tm->shadow_count = 0;
+}
+
+/*----------------------------------------------------------------*/
+
+struct dm_transaction_manager *dm_tm_create(struct dm_block_manager *bm,
+					    struct dm_space_map *sm)
+{
+	int i;
+	struct dm_transaction_manager *tm;
+
+	tm = kmalloc(sizeof(*tm), GFP_KERNEL);
+	if (!tm)
+		return ERR_PTR(-ENOMEM);
+
+	tm->is_clone = 0;
+	tm->real = NULL;
+	tm->bm = bm;
+	tm->sm = sm;
+
+	for (i = 0; i < HASH_SIZE; i++)
+		INIT_HLIST_HEAD(tm->buckets + i);
+
+	tm->shadow_count = 0;
+
+	return tm;
+}
+EXPORT_SYMBOL_GPL(dm_tm_create);
+
+struct dm_transaction_manager *
+dm_tm_create_non_blocking_clone(struct dm_transaction_manager *real)
+{
+	struct dm_transaction_manager *tm;
+
+	tm = kmalloc(sizeof(*tm), GFP_KERNEL);
+	if (tm) {
+		tm->is_clone = 1;
+		tm->real = real;
+	}
+
+	return tm;
+}
+EXPORT_SYMBOL_GPL(dm_tm_create_non_blocking_clone);
+
+void dm_tm_destroy(struct dm_transaction_manager *tm)
+{
+	kfree(tm);
+}
+EXPORT_SYMBOL_GPL(dm_tm_destroy);
+
+int dm_tm_reserve_block(struct dm_transaction_manager *tm, dm_block_t b)
+{
+	if (tm->is_clone)
+		return -EWOULDBLOCK;
+
+	return dm_sm_inc_block(tm->sm, b);
+}
+EXPORT_SYMBOL_GPL(dm_tm_reserve_block);
+
+int dm_tm_begin(struct dm_transaction_manager *tm)
+{
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_tm_begin);
+
+int dm_tm_pre_commit(struct dm_transaction_manager *tm)
+{
+	int r;
+
+	if (tm->is_clone)
+		return -EWOULDBLOCK;
+
+	r = dm_sm_commit(tm->sm);
+	if (r < 0)
+		return r;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_tm_pre_commit);
+
+int dm_tm_commit(struct dm_transaction_manager *tm, struct dm_block *root)
+{
+	if (tm->is_clone)
+		return -EWOULDBLOCK;
+
+	wipe_shadow_table(tm);
+	return dm_bm_flush_and_unlock(tm->bm, root);
+}
+EXPORT_SYMBOL_GPL(dm_tm_commit);
+
+int dm_tm_alloc_block(struct dm_transaction_manager *tm, dm_block_t *new_block)
+{
+	if (tm->is_clone)
+		return -EWOULDBLOCK;
+
+	return dm_sm_new_block(tm->sm, new_block);
+}
+EXPORT_SYMBOL_GPL(dm_tm_alloc_block);
+
+int dm_tm_new_block(struct dm_transaction_manager *tm,
+		    struct dm_block_validator *v,
+		    struct dm_block **result)
+{
+	int r;
+	dm_block_t new_block;
+
+	if (tm->is_clone)
+		return -EWOULDBLOCK;
+
+	r = dm_sm_new_block(tm->sm, &new_block);
+	if (r < 0)
+		return r;
+
+	r = dm_bm_write_lock_zero(tm->bm, new_block, v, result);
+	if (r < 0) {
+		dm_sm_dec_block(tm->sm, new_block);
+		return r;
+	}
+
+	/*
+	 * New blocks count as shadows, in that they don't need to be
+	 * shadowed again.
+	 */
+	insert_shadow(tm, new_block);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_tm_new_block);
+
+static int __shadow_block(struct dm_transaction_manager *tm, dm_block_t orig,
+			  struct dm_block_validator *v,
+			  struct dm_block **result, int *inc_children)
+{
+	int r;
+	dm_block_t new;
+	uint32_t count;
+	struct dm_block *orig_block;
+
+	r = dm_sm_new_block(tm->sm, &new);
+	if (r < 0)
+		return r;
+
+	r = dm_bm_write_lock_zero(tm->bm, new, v, result);
+	if (r < 0) {
+		dm_sm_dec_block(tm->sm, new);
+		return r;
+	}
+
+	r = dm_bm_read_lock(tm->bm, orig, v, &orig_block);
+	if (r < 0) {
+		dm_sm_dec_block(tm->sm, new);
+		return r;
+	}
+	memcpy(dm_block_data(*result), dm_block_data(orig_block),
+	       dm_bm_block_size(tm->bm));
+	r = dm_bm_unlock(orig_block);
+	if (r < 0) {
+		dm_sm_dec_block(tm->sm, new);
+		return r;
+	}
+
+	r = dm_sm_get_count(tm->sm, orig, &count);
+	if (r < 0) {
+		dm_sm_dec_block(tm->sm, new);
+		dm_bm_unlock(*result);
+		return r;
+	}
+
+	r = dm_sm_dec_block(tm->sm, orig);
+	if (r < 0) {
+		dm_sm_dec_block(tm->sm, new);
+		dm_bm_unlock(*result);
+		return r;
+	}
+
+	*inc_children = count > 1;
+	return 0;
+}
+
+int dm_tm_shadow_block(struct dm_transaction_manager *tm, dm_block_t orig,
+		       struct dm_block_validator *v, struct dm_block **result,
+		       int *inc_children)
+{
+	int r, more_than_one;
+
+	if (tm->is_clone)
+		return -EWOULDBLOCK;
+
+	if (is_shadow(tm, orig)) {
+		r = dm_sm_count_is_more_than_one(tm->sm, orig, &more_than_one);
+		if (r < 0)
+			return r;
+
+		if (!more_than_one) {
+			*inc_children = 0;
+			return dm_bm_write_lock(tm->bm, orig, v, result);
+		}
+		/* fall through */
+	}
+
+	r = __shadow_block(tm, orig, v, result, inc_children);
+	if (r < 0)
+		return r;
+	tm->shadow_count++;
+	insert_shadow(tm, dm_block_location(*result));
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(dm_tm_shadow_block);
+
+int dm_tm_read_lock(struct dm_transaction_manager *tm, dm_block_t b,
+		    struct dm_block_validator *v,
+		    struct dm_block **blk)
+{
+	if (tm->is_clone)
+		return dm_bm_read_try_lock(tm->real->bm, b, v, blk);
+
+	return dm_bm_read_lock(tm->bm, b, v, blk);
+}
+EXPORT_SYMBOL_GPL(dm_tm_read_lock);
+
+int dm_tm_unlock(struct dm_transaction_manager *tm, struct dm_block *b)
+{
+	return dm_bm_unlock(b);
+}
+EXPORT_SYMBOL_GPL(dm_tm_unlock);
+
+void dm_tm_inc(struct dm_transaction_manager *tm, dm_block_t b)
+{
+	BUG_ON(tm->is_clone);
+	dm_sm_inc_block(tm->sm, b);
+}
+EXPORT_SYMBOL_GPL(dm_tm_inc);
+
+void dm_tm_dec(struct dm_transaction_manager *tm, dm_block_t b)
+{
+	BUG_ON(tm->is_clone);
+	dm_sm_dec_block(tm->sm, b);
+}
+EXPORT_SYMBOL_GPL(dm_tm_dec);
+
+int dm_tm_ref(struct dm_transaction_manager *tm, dm_block_t b,
+	      uint32_t *result)
+{
+	if (tm->is_clone)
+		return -EWOULDBLOCK;
+
+	return dm_sm_get_count(tm->sm, b, result);
+}
+EXPORT_SYMBOL_GPL(dm_tm_ref);
+
+struct dm_block_manager *dm_tm_get_bm(struct dm_transaction_manager *tm)
+{
+	BUG_ON(tm->is_clone);
+	return tm->bm;
+}
+EXPORT_SYMBOL_GPL(dm_tm_get_bm);
+
+/*----------------------------------------------------------------*/
+
+static int dm_tm_create_internal(struct dm_block_manager *bm,
+				 dm_block_t sb_location,
+				 struct dm_block_validator *sb_validator,
+				 size_t root_offset, size_t root_max_len,
+				 struct dm_transaction_manager **tm,
+				 struct dm_space_map **sm,
+				 struct dm_block **sblock,
+				 int create)
+{
+	int r;
+
+	*sm = dm_sm_metadata_init();
+	if (IS_ERR(*sm))
+		return PTR_ERR(*sm);
+
+	*tm = dm_tm_create(bm, *sm);
+	if (IS_ERR(*tm)) {
+		dm_sm_destroy(*sm);
+		return -1;
+	}
+
+	r = dm_tm_begin(*tm);
+	if (r < 0)
+		goto bad1;
+
+	if (create) {
+		r = dm_bm_write_lock_zero(dm_tm_get_bm(*tm), sb_location,
+					  sb_validator, sblock);
+		if (r < 0) {
+			DMERR("couldn't lock superblock");
+			goto bad1;
+		}
+
+		r = dm_sm_metadata_create(*sm, *tm, dm_bm_nr_blocks(bm),
+					  sb_location);
+		if (r) {
+			DMERR("couldn't create metadata space map");
+			goto bad2;
+		}
+
+	} else {
+		r = dm_bm_write_lock(dm_tm_get_bm(*tm), sb_location,
+				     sb_validator, sblock);
+		if (r < 0) {
+			DMERR("couldn't lock superblock");
+			goto bad1;
+		}
+
+		r = dm_sm_metadata_open(*sm, *tm,
+					dm_block_data(*sblock) + root_offset,
+					root_max_len);
+		if (IS_ERR(*sm)) {
+			DMERR("couldn't open metadata space map");
+			goto bad2;
+		}
+	}
+
+	r = dm_tm_begin(*tm);
+	if (r < 0)
+		goto bad2;
+
+	return 0;
+
+bad2:
+	dm_tm_unlock(*tm, *sblock);
+bad1:
+	dm_tm_destroy(*tm);
+	dm_sm_destroy(*sm);
+	return r;
+}
+
+int dm_tm_create_with_sm(struct dm_block_manager *bm, dm_block_t sb_location,
+			 struct dm_block_validator *sb_validator,
+			 struct dm_transaction_manager **tm,
+			 struct dm_space_map **sm, struct dm_block **sblock)
+{
+	return dm_tm_create_internal(bm, sb_location, sb_validator,
+				     0, 0, tm, sm, sblock, 1);
+}
+EXPORT_SYMBOL_GPL(dm_tm_create_with_sm);
+
+int dm_tm_open_with_sm(struct dm_block_manager *bm, dm_block_t sb_location,
+		       struct dm_block_validator *sb_validator,
+		       size_t root_offset, size_t root_max_len,
+		       struct dm_transaction_manager **tm,
+		       struct dm_space_map **sm, struct dm_block **sblock)
+{
+	return dm_tm_create_internal(bm, sb_location, sb_validator, root_offset,
+				     root_max_len, tm, sm, sblock, 0);
+}
+EXPORT_SYMBOL_GPL(dm_tm_open_with_sm);
+
+unsigned dm_tm_shadow_count(struct dm_transaction_manager *tm)
+{
+	return tm->shadow_count;
+}
+EXPORT_SYMBOL_GPL(dm_tm_shadow_count);
+/*----------------------------------------------------------------*/
diff --git a/drivers/md/persistent-data/dm-transaction-manager.h b/drivers/md/persistent-data/dm-transaction-manager.h
new file mode 100644
index 0000000..90c9d1f
--- /dev/null
+++ b/drivers/md/persistent-data/dm-transaction-manager.h
@@ -0,0 +1,139 @@
+#ifndef DM_TRANSACTION_MANAGER_H
+#define DM_TRANSACTION_MANAGER_H
+
+#include "dm-block-manager.h"
+#include "dm-space-map.h"
+
+/*----------------------------------------------------------------*/
+
+/*
+ * This manages the scope of a transaction.  It also enforces immutability
+ * of the on-disk data structures by limiting access to writeable blocks.
+ *
+ * Clients should not fiddle with the block manager directly.
+ */
+struct dm_transaction_manager;
+
+struct dm_transaction_manager *
+dm_tm_create(struct dm_block_manager *bm, struct dm_space_map *sm);
+
+void dm_tm_destroy(struct dm_transaction_manager *tm);
+
+/*
+ * The non-blocking version of a transaction manager is intended for use in
+ * fast path code that needs to do lookups.  eg, a dm mapping function.
+ * You create the non-blocking variant from a normal tm.  The interface is
+ * the same, except that most functions will just return -EWOULDBLOCK.
+ * Call tm_destroy() as you would with a normal tm when you've finished
+ * with it.  You may not destroy the original prior to clones.
+ */
+struct dm_transaction_manager *
+dm_tm_create_non_blocking_clone(struct dm_transaction_manager *real);
+
+/*
+ * The client may want to manage some blocks directly (eg, the
+ * superblocks).  Call this immediately after construction to reserve
+ * blocks.
+ */
+int dm_tm_reserve_block(struct dm_transaction_manager *tm, dm_block_t b);
+
+int dm_tm_begin(struct dm_transaction_manager *tm);
+
+/*
+ * We use a 2 phase commit here.
+ *
+ * i) In the first phase the block manager is told to start flushing, and
+ * the changes to the space map are written to disk.  You should interogate
+ * your particular space map to get detail of its root node etc. to be
+ * included in your superblock.
+ *
+ * ii) |root| will be committed last.  You shouldn't use more than the
+ * first 512 bytes of |root| if you wish the transaction to survive a power
+ * failure.  You *must* have a write lock held on |root| for both stage (i)
+ * and (ii).  The commit will drop the write lock.
+ */
+int dm_tm_pre_commit(struct dm_transaction_manager *tm);
+int dm_tm_commit(struct dm_transaction_manager *tm, struct dm_block *root);
+
+/*
+ * These methods are the only way to get hold of a writeable block.
+ *
+ * tm_new_block() is pretty self explanatory.  Make sure you do actually
+ * write to the whole of |data| before you unlock, otherwise you could get
+ * a data leak.  (The other option is for tm_new_block() to zero new blocks
+ * before handing them out, which will be redundant in most if not all
+ * cases).
+ *
+ * tm_shadow_block() will allocate a new block and copy the data from orig
+ * to it.  It then decrements the reference count on original block.  Use
+ * this to update the contents of a block in a data structure, don't
+ * confuse this with a clone - you shouldn't access the orig block after
+ * this operation.  Because the tm knows the scope of the transaction it
+ * can optimise requests for a shadow of a shadow to a no-op.  Don't forget
+ * to unlock when you've finished with the shadow.
+ *
+ * The |inc_children| flag is used to tell the caller whether they need to
+ * adjust reference counts for children (data in the block may refer to
+ * other blocks).
+ */
+int dm_tm_alloc_block(struct dm_transaction_manager *tm, dm_block_t *new);
+
+/* zeroes the new block at returns with write lock held */
+int dm_tm_new_block(struct dm_transaction_manager *tm,
+		    struct dm_block_validator *v,
+		    struct dm_block **result);
+
+/*
+ * Shadowing implicitly drops a reference on |orig|, so you must not have
+ * it locked when you call this.
+ */
+int dm_tm_shadow_block(struct dm_transaction_manager *tm, dm_block_t orig,
+		       struct dm_block_validator *v,
+		       struct dm_block **result, int *inc_children);
+
+/*
+ * Read access.  You can lock any block you want, if there's a write lock
+ * on it outstanding then it'll block.
+ */
+int dm_tm_read_lock(struct dm_transaction_manager *tm, dm_block_t b,
+		    struct dm_block_validator *v,
+		    struct dm_block **result);
+
+int dm_tm_unlock(struct dm_transaction_manager *tm, struct dm_block *b);
+
+/*
+ * Functions for altering the reference count of a block directly.
+ */
+void dm_tm_inc(struct dm_transaction_manager *tm, dm_block_t b);
+
+void dm_tm_dec(struct dm_transaction_manager *tm, dm_block_t b);
+
+int dm_tm_ref(struct dm_transaction_manager *tm, dm_block_t b,
+	      uint32_t *result);
+
+struct dm_block_manager *dm_tm_get_bm(struct dm_transaction_manager *tm);
+
+/*
+ * A little utility that ties the knot by producing a transaction manager
+ * that has a space map managed by the transaction manager ...
+ *
+ * Returns a tm that has an open transaction to write the new disk sm.
+ * Caller should store the new sm root and commit.
+ */
+int dm_tm_create_with_sm(struct dm_block_manager *bm, dm_block_t sb_location,
+			 struct dm_block_validator *sb_validator,
+			 struct dm_transaction_manager **tm,
+			 struct dm_space_map **sm, struct dm_block **sblock);
+
+int dm_tm_open_with_sm(struct dm_block_manager *bm, dm_block_t sb_location,
+		       struct dm_block_validator *sb_validator,
+		       size_t root_offset, size_t root_max_len,
+		       struct dm_transaction_manager **tm,
+		       struct dm_space_map **sm, struct dm_block **sblock);
+
+/* useful for debugging performance */
+unsigned dm_tm_shadow_count(struct dm_transaction_manager *tm);
+
+/*----------------------------------------------------------------*/
+
+#endif
-- 
1.7.1
