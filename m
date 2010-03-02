From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 01/14] dm-multisnap-common
Date: Mon,  1 Mar 2010 19:23:45 -0500
Message-ID: <1267489438-6271-2-git-send-email-snitzer@redhat.com>
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

Common code for multisnapshot target.

This is the common code, shared by all exception stores.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 Documentation/device-mapper/dm-multisnapshot.txt |   77 +
 drivers/md/Kconfig                               |   10 +
 drivers/md/Makefile                              |    2 +
 drivers/md/dm-multisnap-private.h                |  161 ++
 drivers/md/dm-multisnap.c                        | 2007 ++++++++++++++++++++++
 drivers/md/dm-multisnap.h                        |  183 ++
 6 files changed, 2440 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/device-mapper/dm-multisnapshot.txt
 create mode 100644 drivers/md/dm-multisnap-private.h
 create mode 100644 drivers/md/dm-multisnap.c
 create mode 100644 drivers/md/dm-multisnap.h

diff --git a/Documentation/device-mapper/dm-multisnapshot.txt b/Documentation/device-mapper/dm-multisnapshot.txt
new file mode 100644
index 0000000..0dff16e
--- /dev/null
+++ b/Documentation/device-mapper/dm-multisnapshot.txt
@@ -0,0 +1,77 @@
+This snapshot implementation has shared storage and high number of snapshots.
+
+The work is split to two modules:
+dm-multisnapshot.ko - the general module
+dm-store-mikulas.ko - the snapshot store
+
+The modularity allows to load other snapshot stores.
+
+Usage:
+Create two logical volumes, one for origin and one for snapshots.
+(assume /dev/mapper/vg1-lv1 for origin and /dev/mapper/vg1-lv2 for snapshot in
+these examples)
+
+Clear the first sector of the snapshot volume:
+dd if=/dev/zero of=/dev/mapper/vg1-lv2 bs=4096 count=1
+
+Table line arguments:
+- origin device
+- shared store device
+- chunk size
+- number of generic arguments
+- generic arguments
+	sync-snapshots --- synchronize snapshots according to the list
+	preserve-on-error --- halt the origin on error in the snapshot store
+- shared store type
+- number of arguments for shared store type
+- shared store arguments
+	cache-threshold size --- a background write is started
+	cache-limit size --- a limit for metadata cache size
+if sync-snapshots was specified
+	- number of snapshot ids
+	- snapshot ids
+
+Load the shared snapshot driver:
+echo 0 `blockdev --getsize /dev/mapper/vg1-lv1` multisnapshot /dev/mapper/vg1-lv1 /dev/mapper/vg1-lv2 16 0 mikulas 0|dmsetup create ms
+(16 is the chunk size in 512-byte sectors. You can place different number there)
+This creates the origin store on /dev/mapper/ms. If the store was zeroed, it
+creates new structure, otherwise it loads existing structure.
+
+Once this is done, you should no longer access /dev/mapper/vg1-lv1 and
+/dev/mapper/vg1-lv2 and only use /dev/mapper/ms.
+
+Create new snapshot:
+dmsetup message /dev/mapper/ms 0 create
+	If you want to create snapshot-of-snapshot, use
+	dmsetup message /dev/mapper/ms 0 create_subsnap <snapID>
+dmsetup status /dev/mapper/ms
+	(this will find out the newly created snapshot ID)
+dmsetup suspend /dev/mapper/ms
+dmsetup resume /dev/mapper/ms
+
+Attach the snapshot:
+echo 0 `blockdev --getsize /dev/mapper/vg1-lv1` multisnap-snap /dev/mapper/vg1-lv1 0|dmsetup create ms0
+(that '0' is the snapshot id ... you can use different number)
+This attaches the snapshot '0' on /dev/mapper/ms0
+
+Delete the snapshot:
+dmsetup message /dev/mapper/ms 0 delete 0
+(the parameter after "delete" is the snapshot id)
+
+See status:
+dmsetup status prints these information about the multisnapshot device:
+- number of arguments befor the snapshot id list (5)
+- 0 on active storage, -error number on error (-ENOSPC, -EIO, etc.)
+- the new snapshot number that will be created, "-" if there is none
+- total number of chunks on the device
+- total number of allocated chunks
+- a number of chunks allocated for metadata
+- a number of snapshots
+- existing snapshot IDs
+
+Unload it:
+dmsetup remove ms
+dmsetup remove ms0
+... etc. (note, once you unload the origin, the snapshots become inaccessible
+- the devices exist but they return -EIO on everything)
+
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index acb3a4e..c3b55a8 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -249,6 +249,16 @@ config DM_SNAPSHOT
        ---help---
          Allow volume managers to take writable snapshots of a device.
 
+config DM_MULTISNAPSHOT
+	tristate "Multisnapshot target"
+	depends on BLK_DEV_DM
+	---help---
+	  A new implementation of snapshots allowing sharing storage
+	  between several snapshots.
+
+	  A submenu allows to select a specific shared snapshot store
+	  driver.
+
 config DM_MIRROR
        tristate "Mirror target"
        depends on BLK_DEV_DM
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index e355e7f..674649c 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -7,6 +7,7 @@ dm-mod-y	+= dm.o dm-table.o dm-target.o dm-linear.o dm-stripe.o \
 dm-multipath-y	+= dm-path-selector.o dm-mpath.o
 dm-snapshot-y	+= dm-snap.o dm-exception-store.o dm-snap-transient.o \
 		    dm-snap-persistent.o
+dm-multisnapshot-y += dm-multisnap.o
 dm-mirror-y	+= dm-raid1.o
 dm-log-userspace-y \
 		+= dm-log-userspace-base.o dm-log-userspace-transfer.o
@@ -41,6 +42,7 @@ obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
 obj-$(CONFIG_DM_MULTIPATH_QL)	+= dm-queue-length.o
 obj-$(CONFIG_DM_MULTIPATH_ST)	+= dm-service-time.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
+obj-$(CONFIG_DM_MULTISNAPSHOT)	+= dm-multisnapshot.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-region-hash.o
 obj-$(CONFIG_DM_LOG_USERSPACE)	+= dm-log-userspace.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
diff --git a/drivers/md/dm-multisnap-private.h b/drivers/md/dm-multisnap-private.h
new file mode 100644
index 0000000..b623027
--- /dev/null
+++ b/drivers/md/dm-multisnap-private.h
@@ -0,0 +1,161 @@
+/*
+ * Copyright (C) 2009 Red Hat Czech, s.r.o.
+ *
+ * Mikulas Patocka <mpatocka@redhat.com>
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef DM_MULTISNAP_PRIVATE_H
+#define DM_MULTISNAP_PRIVATE_H
+
+#include "dm-multisnap.h"
+
+/*
+ * Private structures for dm-multisnap.c.
+ * This file should not be included by exception store drivers.
+ * Changes to this file do not change ABI.
+ */
+
+#include <linux/dm-kcopyd.h>
+
+#define DM_MULTISNAP_MAX_REMAPS		256
+
+#define DM_MULTISNAP_KCOPYD_PAGES	(((1UL << 20) >> PAGE_SHIFT) ? : 1)
+
+#define DM_MULTISNAP_MAX_CHUNKS_TO_REMAP DM_KCOPYD_MAX_REGIONS
+
+#define DM_PENDING_HASH_SIZE		256
+#define DM_PENDING_HASH(c)		((c) & (DM_PENDING_HASH_SIZE - 1))
+#define DM_PENDING_MEMPOOL_SIZE		256
+
+#define DM_TRACKED_CHUNK_HASH_SIZE	16
+#define DM_TRACKED_CHUNK_HASH(x)	((unsigned long)(x) & (DM_TRACKED_CHUNK_HASH_SIZE - 1))
+#define DM_TRACKED_CHUNK_POOL_SIZE	256
+
+struct dm_multisnap_bio_queue {
+	struct bio_list bios;
+};
+
+#define DM_MULTISNAP_N_QUEUES	2
+
+struct dm_multisnap {
+	struct dm_exception_store *p;
+	struct dm_multisnap_exception_store *store;
+
+	struct dm_dev *origin;
+	struct dm_dev *snapshot;
+
+	int error;
+
+	unsigned chunk_size;
+	unsigned char chunk_shift;
+
+	unsigned char flags;
+#define DM_MULTISNAP_SYNC_SNAPSHOTS		1
+#define DM_MULTISNAP_PRESERVE_ON_ERROR		2
+
+	sector_t origin_sectors;
+
+	struct mutex master_lock;
+	struct mutex status_lock;
+	struct workqueue_struct *wq;
+	struct work_struct work;
+
+	/* Queues are protected with dm_multisnap_bio_list_lock */
+	struct dm_multisnap_bio_queue queue[DM_MULTISNAP_N_QUEUES];
+	unsigned current_queue;
+
+	struct list_head background_works;
+
+	/* All snapshot IOs */
+	mempool_t *tracked_chunk_pool;
+
+	/* these two are protected with dm_multisnap_bio_list_lock */
+	long n_tracked_ios;
+	struct hlist_head tracked_chunk_hash[DM_TRACKED_CHUNK_HASH_SIZE];
+
+	mempool_t *pending_pool;
+
+	struct dm_kcopyd_client *kcopyd;
+
+	/*
+	 * The following two variables do a trick to avoid the need for
+	 * atomic operations.
+	 *
+	 * kcopyd_jobs_submitted_count is incremented each time a job is
+	 * submitted to kcopyd. master_lock protects it.
+	 *
+	 * kcopyd_jobs_finished_count is incremented each time a kcopyd
+	 * callback is called. The callback is single-threaded, so it needs
+	 * no protection.
+	 *
+	 * Both kcopyd_jobs_submitted_count and kcopyd_jobs_finished_count
+	 * can be updated simultaneously. But none of these variables is
+	 * updated multiple times concurrently.
+	 *
+	 * When these two are equal, there are no jobs in flight. When they
+	 * are equal and master_lock is held, we know that there are no jobs
+	 * in flight and no new can be submitted --- i.e. we can commit.
+	 */
+	unsigned long kcopyd_jobs_submitted_count;
+	unsigned long kcopyd_jobs_finished_count;
+
+	/* The value of the counter on last commit */
+	unsigned long kcopyd_jobs_last_commit_count;
+
+	/* This may only be accessed from kcopyd callback, it has no locking */
+	struct list_head pes_waiting_for_commit;
+
+	/* Increased each time a commit happens */
+	unsigned commit_sequence;
+
+	/* List head for struct dm_multisnap_pending_exception->hash_list */
+	struct hlist_head pending_hash[DM_PENDING_HASH_SIZE];
+
+	char pending_mempool_allocation_failed;
+
+	/* The new snapshot id to be created */
+	char new_snapid_valid;
+	snapid_t new_snapid;
+
+	/* List head for struct dm_multisnap_snap->list_snaps */
+	struct list_head all_snaps;
+
+	/* List entry for all_multisnapshots */
+	struct list_head list_all;
+};
+
+struct dm_multisnap_snap {
+	struct dm_multisnap *s;
+	snapid_t snapid;
+	/* List entry for struct dm_multisnap->list_all */
+	struct list_head list_snaps;
+	char origin_name[16];
+	char snapid_string[1];
+};
+
+struct dm_multisnap_tracked_chunk {
+	struct hlist_node node;
+	chunk_t chunk;
+	unsigned long bio_rw;
+	struct dm_multisnap *s;
+};
+
+struct dm_multisnap_pending_exception {
+	/* List entry for struct dm_multisnap->pending_hash */
+	struct hlist_node hash_list;
+
+	struct dm_multisnap *s;
+	struct bio_list bios;
+
+	chunk_t chunk;
+
+	int n_descs;
+	union chunk_descriptor desc[DM_MULTISNAP_MAX_CHUNKS_TO_REMAP];
+
+	/* List entry for struct dm_multisnap->pes_waiting_for_commit */
+	struct list_head list;
+};
+
+#endif
diff --git a/drivers/md/dm-multisnap.c b/drivers/md/dm-multisnap.c
new file mode 100644
index 0000000..758c013
--- /dev/null
+++ b/drivers/md/dm-multisnap.c
@@ -0,0 +1,2007 @@
+/*
+ * Copyright (C) 2009 Red Hat Czech, s.r.o.
+ *
+ * Mikulas Patocka <mpatocka@redhat.com>
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm-multisnap-private.h"
+
+#include <linux/delay.h>
+#include <linux/vmalloc.h>
+#include <linux/sort.h>
+
+static void dm_multisnap_process_bios(struct dm_multisnap *s);
+
+/* --- locking --- */
+
+static void dm_multisnap_lock(struct dm_multisnap *s)
+{
+	mutex_lock(&s->master_lock);
+	if (s->p && s->store->store_lock_acquired)
+		s->store->store_lock_acquired(s->p, 0);
+}
+
+static void dm_multisnap_unlock(struct dm_multisnap *s)
+{
+	mutex_unlock(&s->master_lock);
+}
+
+static int dm_multisnap_lock_contended(struct dm_multisnap *s)
+{
+	return !list_empty(&s->master_lock.wait_list);
+}
+
+static void dm_multisnap_assert_locked(struct dm_multisnap *s)
+{
+	BUG_ON(!mutex_is_locked(&s->master_lock));
+}
+
+void dm_multisnap_status_lock(struct dm_multisnap *s)
+{
+	mutex_lock(&s->status_lock);
+}
+EXPORT_SYMBOL(dm_multisnap_status_lock);
+
+void dm_multisnap_status_unlock(struct dm_multisnap *s)
+{
+	mutex_unlock(&s->status_lock);
+}
+EXPORT_SYMBOL(dm_multisnap_status_unlock);
+
+void dm_multisnap_status_assert_locked(struct dm_multisnap *s)
+{
+	BUG_ON(!mutex_is_locked(&s->status_lock));
+}
+EXPORT_SYMBOL(dm_multisnap_status_assert_locked);
+
+/* --- helper functions to access internal state --- */
+
+/*
+ * These tiny functions are used to access internal state of dm_multisnap.
+ *
+ * We access these fields with functions and don't export struct dm_multisnap
+ * to exception store drivers, so that changes to "struct dm_multisnap" don't
+ * change the ABI.
+ */
+
+struct block_device *dm_multisnap_snapshot_bdev(struct dm_multisnap *s)
+{
+	return s->snapshot->bdev;
+}
+EXPORT_SYMBOL(dm_multisnap_snapshot_bdev);
+
+unsigned dm_multisnap_chunk_size(struct dm_multisnap *s)
+{
+	return s->chunk_size;
+}
+EXPORT_SYMBOL(dm_multisnap_chunk_size);
+
+void dm_multisnap_set_error(struct dm_multisnap *s, int error)
+{
+	if (!s->error)
+		s->error = error;
+
+	/*
+	 * Dump the stack on all errors, except space overflow.
+	 *
+	 * Space overflow can happen normally, other errors may mean that
+	 * there is a bug in the code and getting a stack dump is viable.
+	 */
+	if (error != -ENOSPC)
+		dump_stack();
+}
+EXPORT_SYMBOL(dm_multisnap_set_error);
+
+int dm_multisnap_has_error(struct dm_multisnap *s)
+{
+	return s->error;
+}
+EXPORT_SYMBOL(dm_multisnap_has_error);
+
+int dm_multisnap_drop_on_error(struct dm_multisnap *s)
+{
+	return !(s->flags & DM_MULTISNAP_PRESERVE_ON_ERROR);
+}
+EXPORT_SYMBOL(dm_multisnap_drop_on_error);
+
+static DEFINE_MUTEX(all_multisnapshots_lock);
+static LIST_HEAD(all_multisnapshots);
+
+static chunk_t sector_to_chunk(struct dm_multisnap *s, sector_t sector)
+{
+	return sector >> (s->chunk_shift - SECTOR_SHIFT);
+}
+
+static sector_t chunk_to_sector(struct dm_multisnap *s, chunk_t chunk)
+{
+	return chunk << (s->chunk_shift - SECTOR_SHIFT);
+}
+
+int dm_multisnap_snapshot_exists(struct dm_multisnap *s, snapid_t snapid)
+{
+	return snapid == s->store->get_next_snapid(s->p, snapid);
+}
+EXPORT_SYMBOL(dm_multisnap_snapshot_exists);
+
+static long dm_multisnap_jobs_in_flight(struct dm_multisnap *s)
+{
+	return s->kcopyd_jobs_submitted_count - s->kcopyd_jobs_last_commit_count;
+}
+
+/* --- snapids --- */
+
+/*
+ * Any reading/writing of snapids in table/status/message must go
+ * through these functions, so that snapid format for userspace can
+ * be overridden.
+ */
+
+static void print_snapid(struct dm_multisnap *s, char *string,
+			 unsigned maxlen, snapid_t snapid)
+{
+	if (s->store->print_snapid)
+		s->store->print_snapid(s->p, string, maxlen, snapid);
+	else
+		snprintf(string, maxlen, "%llu", (unsigned long long)snapid);
+}
+
+static int read_snapid(struct dm_multisnap *s, char *string,
+		       snapid_t *snapid, char **error)
+{
+	if (s->store->read_snapid)
+		return s->store->read_snapid(s->p, string, snapid, error);
+	else {
+		int r;
+
+		char *argv_array[1] = { string };
+		char **argv = argv_array;
+		unsigned argc = 1;
+		__u64 unsigned_int64;
+
+		r = dm_multisnap_get_uint64(&argv, &argc, &unsigned_int64, error);
+		if (r)
+			return r;
+
+		*snapid = unsigned_int64;
+		return 0;
+	}
+}
+
+/* --- bio list --- */
+
+static DEFINE_SPINLOCK(dm_multisnap_bio_list_lock);
+
+static void wakeup_kmultisnapd(struct dm_multisnap *s)
+{
+	queue_work(s->wq, &s->work);
+}
+
+static void dm_multisnap_enqueue_bio_unlocked(struct dm_multisnap *s, struct bio *bio)
+{
+	struct dm_multisnap_bio_queue *q;
+	if (bio_rw(bio) != WRITE)
+		q = &s->queue[0];
+	else
+		q = &s->queue[1];
+	bio_list_add(&q->bios, bio);
+}
+
+static void dm_multisnap_enqueue_bio(struct dm_multisnap *s, struct bio *bio)
+{
+	spin_lock_irq(&dm_multisnap_bio_list_lock);
+	dm_multisnap_enqueue_bio_unlocked(s, bio);
+	spin_unlock_irq(&dm_multisnap_bio_list_lock);
+}
+
+static void dm_multisnap_enqueue_bio_list(struct dm_multisnap *s, struct bio_list *bl)
+{
+	struct bio *bio;
+	while ((bio = bio_list_pop(bl))) {
+		dm_multisnap_enqueue_bio(s, bio);
+		cond_resched();
+	}
+}
+
+static struct bio *dm_multisnap_dequeue_bio(struct dm_multisnap *s)
+{
+	struct bio *bio;
+
+	spin_lock_irq(&dm_multisnap_bio_list_lock);
+
+#ifdef DM_MULTISNAP_MAX_REMAPS
+	if (dm_multisnap_jobs_in_flight(s) >= DM_MULTISNAP_MAX_REMAPS) {
+		s->current_queue = 0;
+		goto test_current_queue;
+	}
+#endif
+
+	s->current_queue ^= 1;
+
+	bio = bio_list_pop(&s->queue[s->current_queue ^ 1].bios);
+	if (bio)
+		goto ret;
+
+#ifdef DM_MULTISNAP_MAX_REMAPS
+test_current_queue:
+#endif
+	bio = bio_list_pop(&s->queue[s->current_queue].bios);
+
+ret:
+	spin_unlock_irq(&dm_multisnap_bio_list_lock);
+
+	return bio;
+}
+
+static int dm_multisnap_bio_queue_empty(struct dm_multisnap *s)
+{
+	unsigned i;
+
+	spin_lock_irq(&dm_multisnap_bio_list_lock);
+
+	for (i = 0; i < DM_MULTISNAP_N_QUEUES; i++)
+		if (!bio_list_empty(&s->queue[i].bios))
+			break;
+
+	spin_unlock_irq(&dm_multisnap_bio_list_lock);
+
+	return i != DM_MULTISNAP_N_QUEUES;
+}
+
+static void dm_multisnap_bio_dequeue_all(struct dm_multisnap *s, struct bio_list *bl)
+{
+	unsigned i;
+
+	bio_list_init(bl);
+
+	spin_lock_irq(&dm_multisnap_bio_list_lock);
+
+	for (i = 0; i < DM_MULTISNAP_N_QUEUES; i++) {
+		bio_list_merge(bl, &s->queue[i].bios);
+		bio_list_init(&s->queue[i].bios);
+	}
+
+	spin_unlock_irq(&dm_multisnap_bio_list_lock);
+}
+
+static void dm_multisnap_init_bio_queues(struct dm_multisnap *s)
+{
+	unsigned i;
+	for (i = 0; i < DM_MULTISNAP_N_QUEUES; i++)
+		bio_list_init(&s->queue[i].bios);
+	s->current_queue = 0;
+}
+
+/* Reduce the size of the bio */
+
+static void bio_trim(struct bio *bio, unsigned size)
+{
+	unsigned i;
+	bio->bi_size = size;
+	for (i = 0; i < bio->bi_vcnt; i++) {
+		if (size <= bio->bi_io_vec[i].bv_len) {
+			bio->bi_io_vec[i].bv_len = size;
+			bio->bi_vcnt = i + 1;
+			bio->bi_flags &= ~(1 << BIO_SEG_VALID);
+			return;
+		}
+		size -= bio->bi_io_vec[i].bv_len;
+	}
+	BUG();
+}
+
+/* --- encode 64-bit snapids in bio */
+
+static snapid_t bio_get_snapid(struct bio *bio)
+{
+	return ((__u64)bio->bi_seg_front_size << 32) | bio->bi_seg_back_size;
+}
+
+static void bio_put_snapid(struct bio *bio, snapid_t snapid)
+{
+	bio->bi_seg_front_size = (__u64)snapid >> 32;
+	bio->bi_seg_back_size = snapid;
+}
+
+/* --- tracked chunks --- */
+
+static struct kmem_cache *tracked_chunk_cache;
+
+static int chunk_is_tracked(struct dm_multisnap *s, chunk_t chunk)
+{
+	struct dm_multisnap_tracked_chunk *c;
+	struct hlist_node *hn;
+
+	spin_lock_irq(&dm_multisnap_bio_list_lock);
+
+	hlist_for_each_entry(c, hn,
+	    &s->tracked_chunk_hash[DM_TRACKED_CHUNK_HASH(chunk)], node) {
+		if (likely(c->chunk == chunk)) {
+			spin_unlock_irq(&dm_multisnap_bio_list_lock);
+			return 1;
+		}
+	}
+
+	spin_unlock_irq(&dm_multisnap_bio_list_lock);
+
+	return 0;
+}
+
+/* --- pending exception cache --- */
+
+static struct kmem_cache *pending_exception_cache;
+
+#define GFP_PENDING_EXCEPTION	GFP_NOIO
+
+static void pending_exception_ctor(void *pe_)
+{
+	struct dm_multisnap_pending_exception *pe = pe_;
+	bio_list_init(&pe->bios);
+}
+
+static struct dm_multisnap_pending_exception *
+dm_multisnap_alloc_pending_exception(struct dm_multisnap *s, chunk_t chunk)
+{
+	struct dm_multisnap_pending_exception *pe;
+	/*
+	 * Warning, we don't want to wait. Because we are holding master_lock
+	 * and taking this lock is needed to complete the exception.
+	 *
+	 * If an allocation failure happens, we must go up, drop the lock,
+	 * try dummy mempool allocation and go here again.
+	 */
+	pe = mempool_alloc(s->pending_pool, GFP_PENDING_EXCEPTION & ~__GFP_WAIT);
+	if (unlikely(!pe))
+		return NULL;
+
+	pe->s = s;
+	pe->chunk = chunk;
+	hlist_add_head(&pe->hash_list, &s->pending_hash[DM_PENDING_HASH(chunk)]);
+	return pe;
+}
+
+static void dm_multisnap_free_pending_exception(struct dm_multisnap_pending_exception *pe)
+{
+	hlist_del(&pe->hash_list);
+	mempool_free(pe, pe->s->pending_pool);
+}
+
+static void dm_multisnap_wait_for_pending_exception(struct dm_multisnap *s)
+{
+	/*
+	 * Wait until there is something in the mempool. Free it immediately.
+	 */
+	struct dm_multisnap_pending_exception *pe;
+
+	pe = mempool_alloc(s->pending_pool, GFP_PENDING_EXCEPTION | __GFP_WAIT);
+	mempool_free(pe, s->pending_pool);
+}
+
+/*
+ * Check if the chunk+snapid conflicts with any pending exception.
+ *
+ * If it does, queue the bio on the pending exception.
+ */
+static int check_pending_io(struct dm_multisnap *s, struct bio *bio,
+			    chunk_t chunk, snapid_t snapid)
+{
+	struct dm_multisnap_pending_exception *pe;
+	struct hlist_node *hn;
+	hlist_for_each_entry(pe, hn, &s->pending_hash[DM_PENDING_HASH(chunk)], hash_list) {
+		if (pe->chunk == chunk) {
+			int i;
+			if (snapid == DM_SNAPID_T_ORIGIN)
+				goto conflict;
+			for (i = 0; i < pe->n_descs; i++) {
+				if (s->store->check_conflict(s->p, &pe->desc[i], snapid))
+					goto conflict;
+			}
+		}
+		cond_resched();
+	}
+	return 0;
+
+conflict:
+	bio_list_add(&pe->bios, bio);
+	return 1;
+}
+
+/* --- commit --- */
+
+/*
+ * Test if commit can be performed. If these two variables are not equal,
+ * there are some pending kcopyd jobs and we must not commit.
+ */
+int dm_multisnap_can_commit(struct dm_multisnap *s)
+{
+	return s->kcopyd_jobs_submitted_count == s->kcopyd_jobs_finished_count;
+}
+EXPORT_SYMBOL(dm_multisnap_can_commit);
+
+/*
+ * Call exception store commit method.
+ * This can be called only if dm_multisnap_can_commit returned true;
+ * master_lock must be locked.
+ */
+void dm_multisnap_call_commit(struct dm_multisnap *s)
+{
+	s->kcopyd_jobs_last_commit_count = s->kcopyd_jobs_finished_count;
+	s->store->commit(s->p);
+	s->commit_sequence++;
+}
+EXPORT_SYMBOL(dm_multisnap_call_commit);
+
+/*
+ * Force commit at this point. It is guaranteed that commit happened when
+ * this function exits.
+ * master_lock must be unlocked.
+ *
+ * If the commit cannot be performed immediately (because there are pending
+ * chunks being copied), the function drops the lock and polls. It won't
+ * livelock --- either it will be possible to do the commit or someone
+ * has done the commit already (commit_sequence changed).
+ *
+ * The polling is justified because this function is only called when deleting
+ * a snapshot or when suspending the origin with postsuspend. These functions
+ * are not performance-critical, thus 1ms delay won't cause a performance
+ * problem.
+ */
+static int dm_multisnap_force_commit(struct dm_multisnap *s)
+{
+	int err;
+	unsigned commit_sequence;
+
+	dm_multisnap_lock(s);
+
+	commit_sequence = s->commit_sequence;
+
+	while (!dm_multisnap_can_commit(s)) {
+		dm_multisnap_unlock(s);
+		msleep(1);
+		dm_multisnap_lock(s);
+		if (s->commit_sequence != commit_sequence)
+			goto unlock_ret;
+	}
+
+	dm_multisnap_call_commit(s);
+
+unlock_ret:
+	err = dm_multisnap_has_error(s);
+	dm_multisnap_unlock(s);
+
+	return err;
+}
+
+/* --- kcopyd callback --- */
+
+static void remap_callback(int read_err, unsigned long write_err, void *pe_)
+{
+	struct dm_multisnap_pending_exception *pe = pe_;
+	struct dm_multisnap *s = pe->s;
+
+	if (unlikely((read_err | write_err) != 0))
+		DM_MULTISNAP_SET_ERROR(s, -EIO, ("remap_callback: kcopyd I/O error: "
+						 "%d, %lx", read_err, write_err));
+
+	list_add_tail(&pe->list, &s->pes_waiting_for_commit);
+
+	s->kcopyd_jobs_finished_count++;
+
+	/* If there are more jobs pending, don't commit */
+	if (!dm_multisnap_can_commit(s))
+		return;
+
+	if (s->store->prepare_for_commit)
+		s->store->prepare_for_commit(s->p);
+
+	dm_multisnap_lock(s);
+
+	/* Recheck after the lock was taken */
+	if (unlikely(!dm_multisnap_can_commit(s))) {
+		/* Not yet ... kmultisnapd has just added something */
+		dm_multisnap_unlock(s);
+		return;
+	}
+
+	/* We need to commit stuff */
+
+	dm_multisnap_call_commit(s);
+
+	do {
+		pe = container_of(s->pes_waiting_for_commit.next,
+				  struct dm_multisnap_pending_exception, list);
+
+		/*
+		 * When we are about to free the pending exception, we must
+		 * wait for all reads to the appropriate chunk to finish.
+		 *
+		 * This prevents the following race condition:
+		 * - someone reads the chunk in the snapshot with no exception
+		 * - that read is remapped directly to the origin, the read
+		 *	is delayed for some reason
+		 * - someone else writes to the origin, this triggers realloc
+		 * - the realloc finishes
+		 * - the write is dispatched to the origin
+		 * - the read submitted first is dispatched and reads modified
+		 *	data
+		 *
+		 * This race is very improbable (non-shared snapshots have this
+		 * race too and it hasn't ever been reported seen, except in
+		 * artifically simulated cases). So we use active waiting with
+		 * msleep(1).
+		 */
+		while (chunk_is_tracked(s, pe->chunk))
+			msleep(1);
+
+		list_del(&pe->list);
+		dm_multisnap_enqueue_bio_list(s, &pe->bios);
+		dm_multisnap_free_pending_exception(pe);
+	} while (!list_empty(&s->pes_waiting_for_commit));
+
+	/*
+	 * Process the bios that we have just added to the queue.
+	 * It's faster to process them now than to hand them over to
+	 * kmultisnapd.
+	 */
+	dm_multisnap_process_bios(s);
+
+	dm_multisnap_unlock(s);
+
+	blk_unplug(bdev_get_queue(s->origin->bdev));
+	blk_unplug(bdev_get_queue(s->snapshot->bdev));
+}
+
+static void dispatch_kcopyd(struct dm_multisnap *s,
+			    struct dm_multisnap_pending_exception *pe,
+			    int from_snapshot, chunk_t chunk, struct bio *bio,
+			    struct dm_io_region *dests, unsigned n_dests)
+{
+	unsigned i;
+	struct dm_io_region src;
+
+	pe->n_descs = n_dests;
+
+	bio_list_add(&pe->bios, bio);
+
+	src.bdev = likely(!from_snapshot) ? s->origin->bdev : s->snapshot->bdev;
+	src.sector = chunk_to_sector(s, chunk);
+	src.count = s->chunk_size >> SECTOR_SHIFT;
+
+	if (likely(!from_snapshot) &&
+	    unlikely(src.sector + src.count > s->origin_sectors)) {
+		if (src.sector >= s->origin_sectors)
+			src.count = 0;
+		else
+			src.count = s->origin_sectors - src.sector;
+
+		for (i = 0; i < pe->n_descs; i++)
+			dests[i].count = src.count;
+	}
+
+	s->kcopyd_jobs_submitted_count++;
+
+	dm_kcopyd_copy(s->kcopyd, &src, n_dests, dests, 0, remap_callback, pe);
+}
+
+/* --- bio processing --- */
+
+/*
+ * Process bio on the origin.
+ * Reads and barriers never go here, they are dispatched directly.
+ */
+static void do_origin_write(struct dm_multisnap *s, struct bio *bio)
+{
+	int r;
+	unsigned i;
+	chunk_t chunk, new_chunk;
+	struct dm_multisnap_pending_exception *pe;
+	struct dm_io_region dests[DM_MULTISNAP_MAX_CHUNKS_TO_REMAP];
+
+	/* reads are processed directly in multisnap_origin_map */
+	BUG_ON(bio_rw(bio) != WRITE);
+
+	if (bio->bi_sector + (bio->bi_size >> SECTOR_SHIFT) > s->origin_sectors) {
+		DMERR("do_origin_write: access beyond end of device, flags %lx, "
+		      "sector %llx, size %x, origin sectors %llx",
+		      bio->bi_flags,
+		      (unsigned long long)bio->bi_sector,
+		      bio->bi_size,
+		      (unsigned long long)s->origin_sectors);
+		bio_endio(bio, -EIO);
+		return;
+	}
+
+	if (unlikely(dm_multisnap_has_error(s)))
+		goto err_endio;
+
+	s->store->reset_query(s->p);
+
+	chunk = sector_to_chunk(s, bio->bi_sector);
+
+	r = s->store->query_next_remap(s->p, chunk);
+	if (unlikely(r < 0))
+		goto err_endio;
+
+	if (likely(!r)) {
+		/* There is nothing to remap */
+		if (unlikely(check_pending_io(s, bio, chunk, DM_SNAPID_T_ORIGIN)))
+			return;
+dispatch_write:
+		bio->bi_bdev = s->origin->bdev;
+		generic_make_request(bio);
+		return;
+	}
+
+	pe = dm_multisnap_alloc_pending_exception(s, chunk);
+	if (unlikely(!pe)) {
+		s->pending_mempool_allocation_failed = 1;
+		dm_multisnap_enqueue_bio(s, bio);
+		return;
+	}
+
+	i = 0;
+	for (; i < DM_MULTISNAP_MAX_CHUNKS_TO_REMAP; i++) {
+		s->store->add_next_remap(s->p, &pe->desc[i], &new_chunk);
+		if (unlikely(dm_multisnap_has_error(s)))
+			goto free_err_endio;
+
+		dests[i].bdev = s->snapshot->bdev;
+		dests[i].sector = chunk_to_sector(s, new_chunk);
+		dests[i].count = s->chunk_size >> SECTOR_SHIFT;
+
+		r = s->store->query_next_remap(s->p, chunk);
+		if (unlikely(r < 0))
+			goto free_err_endio;
+		if (likely(!r)) {
+			i++;
+			break;
+		}
+	}
+
+	dispatch_kcopyd(s, pe, 0, chunk, bio, dests, i);
+	return;
+
+free_err_endio:
+	dm_multisnap_free_pending_exception(pe);
+err_endio:
+	r = -EIO;
+	if (!(s->flags & DM_MULTISNAP_PRESERVE_ON_ERROR))
+		goto dispatch_write;
+
+	bio_endio(bio, r);
+	return;
+}
+
+/*
+ * Process bio on the snapshot.
+ * Barriers never go here, they are dispatched directly.
+ */
+static void do_snapshot_io(struct dm_multisnap *s, struct bio *bio, snapid_t id)
+{
+	chunk_t chunk, result, copy_from;
+	int r;
+	struct dm_multisnap_pending_exception *pe;
+	struct dm_io_region dest;
+
+	if (unlikely(!s->store->make_chunk_writeable) &&
+	    unlikely(bio_rw(bio) == WRITE))
+		goto err_endio;
+
+	if (unlikely(dm_multisnap_has_error(s)))
+		goto err_endio;
+
+	chunk = sector_to_chunk(s, bio->bi_sector);
+	r = s->store->find_snapshot_chunk(s->p, id, chunk,
+					  bio_rw(bio) == WRITE, &result);
+	if (unlikely(r < 0))
+		goto err_endio;
+
+	if (!r) {
+		/* Not found in the snapshot */
+		if (likely(bio_rw(bio) != WRITE)) {
+			union map_info *map_context;
+			struct dm_multisnap_tracked_chunk *c;
+
+			if (unlikely(bio->bi_sector + (bio->bi_size >> SECTOR_SHIFT) > s->origin_sectors)) {
+				zero_fill_bio(bio);
+				if (bio->bi_sector >= s->origin_sectors) {
+					bio_endio(bio, 0);
+					return;
+				}
+				bio_trim(bio, (s->origin_sectors - bio->bi_sector) << SECTOR_SHIFT);
+			}
+
+			/*
+			 * Redirect reads to the origin.
+			 * Record the bio in the hash of tracked bios.
+			 * This prevents read-vs-realloc race.
+			 *
+			 * An important requirement is that when any bio is
+			 * added to tracked_chunk_hash, the bio must be finished
+			 * and removed from the hash without taking master_lock.
+			 *
+			 * So we add it immediately before submitting the bio
+			 * with generic_make_request.
+			 */
+			bio->bi_bdev = s->origin->bdev;
+
+			map_context = dm_get_mapinfo(bio);
+			BUG_ON(!map_context);
+			c = map_context->ptr;
+
+			spin_lock_irq(&dm_multisnap_bio_list_lock);
+			BUG_ON(!hlist_unhashed(&c->node));
+			hlist_add_head(&c->node, &s->tracked_chunk_hash[DM_TRACKED_CHUNK_HASH(c->chunk)]);
+			spin_unlock_irq(&dm_multisnap_bio_list_lock);
+		} else {
+			pe = dm_multisnap_alloc_pending_exception(s, chunk);
+			if (unlikely(!pe))
+				goto failed_pe_allocation;
+
+			s->store->add_next_remap(s->p, &pe->desc[0], &result);
+			if (unlikely(dm_multisnap_has_error(s)))
+				goto free_err_endio;
+
+			dest.bdev = s->snapshot->bdev;
+			dest.sector = chunk_to_sector(s, result);
+			dest.count = s->chunk_size >> SECTOR_SHIFT;
+
+			dispatch_kcopyd(s, pe, 0, chunk, bio, &dest, 1);
+			return;
+		}
+	} else {
+		/* Found in the snapshot */
+		if (unlikely(check_pending_io(s, bio, chunk, id)))
+			return;
+
+		if (unlikely(bio_rw(bio) == WRITE) && r == 1) {
+			copy_from = result;
+
+			pe = dm_multisnap_alloc_pending_exception(s, chunk);
+			if (unlikely(!pe))
+				goto failed_pe_allocation;
+
+			s->store->make_chunk_writeable(s->p, &pe->desc[0], &result);
+			if (unlikely(dm_multisnap_has_error(s)))
+				goto free_err_endio;
+
+			dest.bdev = s->snapshot->bdev;
+			dest.sector = chunk_to_sector(s, result);
+			dest.count = s->chunk_size >> SECTOR_SHIFT;
+
+			dispatch_kcopyd(s, pe, 1, copy_from, bio, &dest, 1);
+			return;
+		}
+
+		bio->bi_bdev = s->snapshot->bdev;
+		bio->bi_sector &= (s->chunk_size >> SECTOR_SHIFT) - 1;
+		bio->bi_sector |= chunk_to_sector(s, result);
+	}
+	generic_make_request(bio);
+	return;
+
+free_err_endio:
+	dm_multisnap_free_pending_exception(pe);
+err_endio:
+	r = -EIO;
+	bio_endio(bio, r);
+	return;
+
+failed_pe_allocation:
+	s->pending_mempool_allocation_failed = 1;
+	dm_multisnap_enqueue_bio(s, bio);
+	return;
+}
+
+/*
+ * The main routine used to process everything in the thread.
+ * It must be called with master_lock held.
+ * It is usually called from the worker thread, but can also be called
+ * from other places (for example kcopyd callback), assuming that the caller
+ * holds master_lock.
+ */
+static void dm_multisnap_process_bios(struct dm_multisnap *s)
+{
+	struct bio *bio;
+	snapid_t snapid;
+
+again:
+	cond_resched();
+
+	if (!list_empty(&s->background_works)) {
+		struct dm_multisnap_background_work *bw =
+			list_entry(s->background_works.next,
+				   struct dm_multisnap_background_work, list);
+		list_del(&bw->list);
+		bw->queued = 0;
+		bw->work(s->p, bw);
+
+		cond_resched();
+	}
+
+	bio = dm_multisnap_dequeue_bio(s);
+	if (unlikely(!bio))
+		return;
+
+	snapid = bio_get_snapid(bio);
+	if (snapid == DM_SNAPID_T_ORIGIN)
+		do_origin_write(s, bio);
+	else
+		do_snapshot_io(s, bio, snapid);
+
+	if (likely(!s->pending_mempool_allocation_failed) &&
+	    likely(!dm_multisnap_lock_contended(s)))
+		goto again;
+
+	if (!dm_multisnap_bio_queue_empty(s))
+		wakeup_kmultisnapd(s);
+}
+
+/*
+ * Background-job routines exported for exception store drivers.
+ *
+ * Jobs queued with these routines will be executed on background, with the
+ * master lock held.
+ */
+
+void dm_multisnap_queue_work(struct dm_multisnap *s,
+			     struct dm_multisnap_background_work *bw)
+{
+	dm_multisnap_assert_locked(s);
+
+	if (bw->queued) {
+		BUG_ON(bw->queued != 1);
+		return;
+	}
+
+	bw->queued = 1;
+	list_add(&bw->list, &s->background_works);
+	wakeup_kmultisnapd(s);
+}
+EXPORT_SYMBOL(dm_multisnap_queue_work);
+
+void dm_multisnap_cancel_work(struct dm_multisnap *s,
+			      struct dm_multisnap_background_work *bw)
+{
+	dm_multisnap_assert_locked(s);
+
+	if (!bw->queued)
+		return;
+
+	bw->queued = 0;
+	list_del(&bw->list);
+}
+EXPORT_SYMBOL(dm_multisnap_cancel_work);
+
+/*
+ * The main work thread.
+ */
+static void dm_multisnap_work(struct work_struct *work)
+{
+	struct dm_multisnap *s = container_of(work, struct dm_multisnap, work);
+
+	dm_multisnap_lock(s);
+	dm_multisnap_process_bios(s);
+	dm_multisnap_unlock(s);
+
+	/*
+	 * If there was some mempool allocation failure we must wait, outside
+	 * the lock, until there is some free memory.
+	 * If this branch is taken, the work is already queued again, so it
+	 * reexecutes after finding some memory.
+	 */
+	if (unlikely(s->pending_mempool_allocation_failed)) {
+		s->pending_mempool_allocation_failed = 0;
+		dm_multisnap_wait_for_pending_exception(s);
+	}
+
+	blk_unplug(bdev_get_queue(s->origin->bdev));
+	blk_unplug(bdev_get_queue(s->snapshot->bdev));
+}
+
+static struct dm_multisnap *find_multisnapshot(struct block_device *origin)
+{
+	struct dm_multisnap *s;
+	list_for_each_entry(s, &all_multisnapshots, list_all)
+		if (s->origin->bdev == origin)
+			return s;
+	return NULL;
+}
+
+/* --- exception stores --- */
+
+static DEFINE_MUTEX(exception_stores_lock);
+static LIST_HEAD(all_exception_stores);
+
+static struct dm_multisnap_exception_store *
+dm_multisnap_find_exception_store(const char *name)
+{
+	struct dm_multisnap_exception_store *store;
+
+	list_for_each_entry(store, &all_exception_stores, list)
+		if (!strcmp(store->name, name))
+			return store;
+
+	return NULL;
+}
+
+static int dm_multisnap_exception_store_active(struct dm_multisnap_exception_store *find)
+{
+	struct dm_multisnap_exception_store *store;
+
+	list_for_each_entry(store, &all_exception_stores, list)
+		if (store == find)
+			return 1;
+
+	return 0;
+}
+
+int dm_multisnap_register_exception_store(struct dm_multisnap_exception_store *store)
+{
+	mutex_lock(&exception_stores_lock);
+
+	BUG_ON(dm_multisnap_exception_store_active(store));
+
+	if (dm_multisnap_find_exception_store(store->name)) {
+		mutex_unlock(&exception_stores_lock);
+		return -EEXIST;
+	}
+	list_add(&store->list, &all_exception_stores);
+
+	mutex_unlock(&exception_stores_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(dm_multisnap_register_exception_store);
+
+void dm_multisnap_unregister_exception_store(struct dm_multisnap_exception_store *store)
+{
+	mutex_lock(&exception_stores_lock);
+
+	BUG_ON(!dm_multisnap_exception_store_active(store));
+	list_del(&store->list);
+
+	mutex_unlock(&exception_stores_lock);
+}
+EXPORT_SYMBOL(dm_multisnap_unregister_exception_store);
+
+static struct dm_multisnap_exception_store *
+dm_multisnap_get_exception_store(const char *name)
+{
+	struct dm_multisnap_exception_store *store;
+
+	mutex_lock(&exception_stores_lock);
+
+	store = dm_multisnap_find_exception_store(name);
+	if (store) {
+		if (!try_module_get(store->module))
+			store = NULL;
+	}
+
+	mutex_unlock(&exception_stores_lock);
+
+	return store;
+}
+
+static void dm_multisnap_put_exception_store(struct dm_multisnap_exception_store *store)
+{
+	mutex_lock(&exception_stores_lock);
+
+	BUG_ON(!dm_multisnap_exception_store_active(store));
+	module_put(store->module);
+
+	mutex_unlock(&exception_stores_lock);
+}
+
+/* --- argument parser --- */
+
+int dm_multisnap_get_string(char ***argv, unsigned *argc,
+			    char **string, char **error)
+{
+	if (!*argc) {
+		*error = "Not enough arguments";
+		return -EINVAL;
+	}
+	*string = *(*argv)++;
+	(*argc)--;
+	return 0;
+}
+EXPORT_SYMBOL(dm_multisnap_get_string);
+
+int dm_multisnap_get_uint64(char ***argv, unsigned *argc,
+			    __u64 *unsigned_int64, char **error)
+{
+	char *string;
+	int r = dm_multisnap_get_string(argv, argc, &string, error);
+	if (r)
+		return r;
+	if (!*string) {
+invalid_number:
+		*error = "Invalid number";
+		return -EINVAL;
+	}
+	*unsigned_int64 = simple_strtoull(string, &string, 10);
+	if (*string)
+		goto invalid_number;
+	return 0;
+}
+EXPORT_SYMBOL(dm_multisnap_get_uint64);
+
+int dm_multisnap_get_uint(char ***argv, unsigned *argc,
+			  unsigned *unsigned_int, char **error)
+{
+	__u64 unsigned_int64;
+	int r = dm_multisnap_get_uint64(argv, argc, &unsigned_int64, error);
+	if (r)
+		return r;
+	*unsigned_int = unsigned_int64;
+	if (unsigned_int64 != *unsigned_int) {
+		*error = "Number out of range";
+		return -ERANGE;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(dm_multisnap_get_uint);
+
+int dm_multisnap_get_argcount(char ***argv, unsigned *argc,
+			      unsigned *unsigned_int, char **error)
+{
+	int r = dm_multisnap_get_uint(argv, argc, unsigned_int, error);
+	if (r)
+		return r;
+	if (*unsigned_int > *argc) {
+		*error = "Not enough arguments";
+		return -EINVAL;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(dm_multisnap_get_argcount);
+
+void dm_multisnap_adjust_string(char **result, unsigned *maxlen)
+{
+	unsigned len = strlen(*result);
+	*result += len;
+	*maxlen -= len;
+}
+EXPORT_SYMBOL(dm_multisnap_adjust_string);
+
+/* --- target methods --- */
+
+static int compare_snapids(const void *p1, const void *p2)
+{
+	snapid_t s1 = *(const snapid_t *)p1;
+	snapid_t s2 = *(const snapid_t *)p2;
+	if (s1 < s2)
+		return -1;
+	if (s1 > s2)
+		return 1;
+	return 0;
+}
+
+/* --- constructor & destructor --- */
+
+static int multisnap_origin_ctr(struct dm_target *ti, unsigned argc, char **argv)
+{
+	int r;
+	int i;
+	char *origin_path;
+	char *snapshot_path;
+	unsigned chunk_size;
+	unsigned generic_args;
+	char *store_name;
+	unsigned store_args;
+	unsigned num_snapshots;
+
+	struct dm_multisnap *s, *ss;
+
+	mutex_lock(&all_multisnapshots_lock);
+
+	r = dm_multisnap_get_string(&argv, &argc, &origin_path, &ti->error);
+	if (r)
+		goto bad_arguments;
+	r = dm_multisnap_get_string(&argv, &argc, &snapshot_path, &ti->error);
+	if (r)
+		goto bad_arguments;
+	r = dm_multisnap_get_uint(&argv, &argc, &chunk_size, &ti->error);
+	if (r)
+		goto bad_arguments;
+
+	s = kmalloc(sizeof(struct dm_multisnap), GFP_KERNEL);
+	if (!s) {
+		ti->error = "Can't allocate multisnapshot structure";
+		r = -ENOMEM;
+		goto bad_s;
+	}
+
+	ti->private = s;
+
+	s->p = NULL;
+	s->error = 0;
+	s->flags = 0;
+	mutex_init(&s->master_lock);
+	mutex_init(&s->status_lock);
+	INIT_WORK(&s->work, dm_multisnap_work);
+	dm_multisnap_init_bio_queues(s);
+	INIT_LIST_HEAD(&s->background_works);
+	s->kcopyd_jobs_submitted_count = 0;
+	s->kcopyd_jobs_finished_count = 0;
+	s->kcopyd_jobs_last_commit_count = 0;
+	INIT_LIST_HEAD(&s->pes_waiting_for_commit);
+	s->commit_sequence = 0;
+	for (i = 0; i < DM_PENDING_HASH_SIZE; i++)
+		INIT_HLIST_HEAD(&s->pending_hash[i]);
+	s->pending_mempool_allocation_failed = 0;
+	s->new_snapid_valid = 0;
+	INIT_LIST_HEAD(&s->all_snaps);
+
+	r = dm_multisnap_get_argcount(&argv, &argc, &generic_args, &ti->error);
+	if (r)
+		goto bad_arguments;
+	while (generic_args--) {
+		char *arg;
+		r = dm_multisnap_get_string(&argv, &argc, &arg, &ti->error);
+		if (r)
+			goto bad_generic_arguments;
+
+		/* Synchronize snapshot list against the list given in the target table */
+		if (!strcasecmp(arg, "sync-snapshots"))
+			s->flags |= DM_MULTISNAP_SYNC_SNAPSHOTS;
+		/* Don't drop the snapshot store on error, rather stop the origin */
+		else if (!strcasecmp(arg, "preserve-on-error"))
+			s->flags |= DM_MULTISNAP_PRESERVE_ON_ERROR;
+		else {
+			r = -EINVAL;
+			ti->error = "Invalid argument";
+			goto bad_generic_arguments;
+		}
+	}
+
+	r = dm_get_device(ti, origin_path, 0, 0,
+			  FMODE_READ | FMODE_WRITE, &s->origin);
+	if (r) {
+		ti->error = "Could not get origin device";
+		goto bad_origin;
+	}
+	s->origin_sectors = i_size_read(s->origin->bdev->bd_inode) >> SECTOR_SHIFT;
+
+	r = dm_get_device(ti, snapshot_path, 0, 0,
+			  FMODE_READ | FMODE_WRITE, &s->snapshot);
+	if (r) {
+		ti->error = "Could not get snapshot device";
+		goto bad_snapshot;
+	}
+
+	/*
+	 * Prevent multiple load over the same devices.
+	 *
+	 * Currently, multisnapshot target is loaded just once, there is no
+	 * place where it would be reloaded (even lvchange --refresh doesn't
+	 * do it).  So there is no need to handle loading the target multiple
+	 * times for the same devices and "handover" of the exception store.
+	 *
+	 * As a safeguard to protect against possible data corruption from
+	 * userspace misbehavior, we check that there is no other target loaded
+	 * that has the origin or the snapshot store on the same devices.
+	 */
+	list_for_each_entry(ss, &all_multisnapshots, list_all)
+		if (ss->origin->bdev == s->origin->bdev ||
+		    ss->snapshot->bdev == s->snapshot->bdev) {
+			ti->error = "Another multisnapshot with the same devices";
+			r = -EINVAL;
+			goto bad_conflicting_snapshot;
+		}
+
+	/* Validate the chunk size */
+	if (chunk_size > INT_MAX / 512) {
+		ti->error = "Chunk size is too high";
+		r = -EINVAL;
+		goto bad_chunk_size;
+	}
+	if (!is_power_of_2(chunk_size)) {
+		ti->error = "Chunk size is not power of two";
+		r = -EINVAL;
+		goto bad_chunk_size;
+	}
+	chunk_size *= 512;
+	if (chunk_size < bdev_logical_block_size(s->origin->bdev) ||
+	    chunk_size < bdev_logical_block_size(s->snapshot->bdev)) {
+		ti->error = "Chunk size is smaller than device block size";
+		r = -EINVAL;
+		goto bad_chunk_size;
+	}
+	s->chunk_size = chunk_size;
+	s->chunk_shift = ffs(chunk_size) - 1;
+
+	s->pending_pool = mempool_create_slab_pool(DM_PENDING_MEMPOOL_SIZE,
+						   pending_exception_cache);
+	if (!s->pending_pool) {
+		ti->error = "Could not allocate mempool for pending exceptions";
+		r = -ENOMEM;
+		goto bad_pending_pool;
+	}
+
+	s->tracked_chunk_pool = mempool_create_slab_pool(DM_TRACKED_CHUNK_POOL_SIZE,
+							 tracked_chunk_cache);
+	if (!s->tracked_chunk_pool) {
+		ti->error = "Could not allocate tracked_chunk mempool for tracking reads";
+		goto bad_tracked_chunk_pool;
+	}
+	s->n_tracked_ios = 0;
+	for (i = 0; i < DM_TRACKED_CHUNK_HASH_SIZE; i++)
+		INIT_HLIST_HEAD(&s->tracked_chunk_hash[i]);
+
+	r = dm_kcopyd_client_create(DM_MULTISNAP_KCOPYD_PAGES, &s->kcopyd);
+	if (r) {
+		ti->error = "Could not create kcopyd client";
+		goto bad_kcopyd;
+	}
+
+	r = dm_multisnap_get_string(&argv, &argc, &store_name, &ti->error);
+	if (r)
+		goto bad_store;
+
+	r = dm_multisnap_get_argcount(&argv, &argc, &store_args, &ti->error);
+	if (r)
+		goto bad_store;
+
+	s->store = dm_multisnap_get_exception_store(store_name);
+	if (!s->store) {
+		request_module("dm-store-%s", store_name);
+		s->store = dm_multisnap_get_exception_store(store_name);
+		if (!s->store) {
+			ti->error = "Can't get exception store type";
+			r = -ENOENT;
+			goto bad_store;
+		}
+	}
+
+	s->wq = create_singlethread_workqueue("kmultisnapd");
+	if (!s->wq) {
+		ti->error = "Could not create kernel thread";
+		r = -ENOMEM;
+		goto bad_thread;
+	}
+
+	dm_multisnap_lock(s);
+	r = s->store->init_exception_store(s, &s->p, store_args, argv, &ti->error);
+	if (r) {
+		s->p = NULL;
+		goto exception_store_error;
+	}
+
+	ti->split_io = s->chunk_size >> SECTOR_SHIFT;
+	ti->num_flush_requests = 1;
+
+	argv += store_args;
+	argc -= store_args;
+
+	/*
+	 * Synchronize snapshot IDs according to the table line:
+	 *	allocate IDs that are specified on the table line
+	 *	free IDs that are not specified on the table line
+	 */
+	if (s->flags & DM_MULTISNAP_SYNC_SNAPSHOTS) {
+		snapid_t sn, n, *snapids;
+		r = dm_multisnap_get_argcount(&argv, &argc, &num_snapshots, &ti->error);
+		if (r)
+			goto error_syncing_snapshots;
+		snapids = vmalloc(sizeof(snapid_t) * (num_snapshots + 1));
+		if (!snapids && num_snapshots) {
+			ti->error = "Could not allocate snapids array";
+			goto bad_kcopyd;
+		}
+		for (n = 0; n < num_snapshots; n++) {
+			char *string;
+			r = dm_multisnap_get_string(&argv, &argc, &string, &ti->error);
+			if (r) {
+				vfree(snapids);
+				goto error_syncing_snapshots;
+			}
+			r = read_snapid(s, string, &snapids[n], &ti->error);
+			if (r) {
+				vfree(snapids);
+				goto error_syncing_snapshots;
+			}
+		}
+		snapids[num_snapshots] = DM_SNAPID_T_ORIGIN;
+
+		/* Delete the snapshots that shouldn't be there */
+		sort(snapids, num_snapshots, sizeof(snapid_t), compare_snapids, NULL);
+		sn = s->store->get_next_snapid(s->p, 0);
+		for (n = 0; n <= num_snapshots; n++) {
+			while (sn < snapids[n]) {
+				if (!dm_multisnap_has_error(s)) {
+					r = s->store->delete_snapshot(s->p, sn);
+					if (r && s->flags & DM_MULTISNAP_PRESERVE_ON_ERROR) {
+						ti->error = "Could not delete snapshot";
+						vfree(snapids);
+						goto error_syncing_snapshots;
+					}
+				}
+				sn = s->store->get_next_snapid(s->p, sn + 1);
+				if (sn == DM_SNAPID_T_ORIGIN)
+					goto delete_done;
+			}
+			if (sn == snapids[n]) {
+				sn = s->store->get_next_snapid(s->p, sn + 1);
+				if (sn == DM_SNAPID_T_ORIGIN)
+					goto delete_done;
+			}
+		}
+delete_done:
+		/* Create the snapshots that should be there */
+		if (s->store->compare_snapids_for_create)
+			sort(snapids, num_snapshots, sizeof(snapid_t),
+			     s->store->compare_snapids_for_create, NULL);
+		for (n = 0; n <= num_snapshots; n++) {
+			if (!dm_multisnap_snapshot_exists(s, snapids[n])) {
+				if (!dm_multisnap_has_error(s)) {
+					r = s->store->create_snapshot(s->p, snapids[n]);
+					if (r && s->flags & DM_MULTISNAP_PRESERVE_ON_ERROR) {
+						ti->error = "Could not create snapshot";
+						vfree(snapids);
+						goto error_syncing_snapshots;
+					}
+				}
+			}
+		}
+		vfree(snapids);
+	}
+
+	dm_multisnap_unlock(s);
+
+	list_add(&s->list_all, &all_multisnapshots);
+
+	mutex_unlock(&all_multisnapshots_lock);
+	return 0;
+
+error_syncing_snapshots:
+	s->store->exit_exception_store(s->p);
+	s->p = NULL;
+exception_store_error:
+	dm_multisnap_unlock(s);
+	destroy_workqueue(s->wq);
+bad_thread:
+	dm_multisnap_put_exception_store(s->store);
+bad_store:
+	dm_kcopyd_client_destroy(s->kcopyd);
+bad_kcopyd:
+	mempool_destroy(s->tracked_chunk_pool);
+bad_tracked_chunk_pool:
+	mempool_destroy(s->pending_pool);
+bad_pending_pool:
+bad_conflicting_snapshot:
+bad_chunk_size:
+	dm_put_device(ti, s->snapshot);
+bad_snapshot:
+	dm_put_device(ti, s->origin);
+bad_origin:
+bad_generic_arguments:
+	kfree(s);
+bad_s:
+bad_arguments:
+	mutex_unlock(&all_multisnapshots_lock);
+	return r;
+}
+
+static void multisnap_origin_dtr(struct dm_target *ti)
+{
+	struct dm_multisnap *s = ti->private;
+	struct dm_multisnap_snap *sn;
+	unsigned i;
+
+	mutex_lock(&all_multisnapshots_lock);
+
+	/* Make sure that no more IOs will be submitted by snapshot targets */
+	list_for_each_entry(sn, &s->all_snaps, list_snaps) {
+		spin_lock_irq(&dm_multisnap_bio_list_lock);
+		sn->s = NULL;
+		spin_unlock_irq(&dm_multisnap_bio_list_lock);
+	}
+	list_del(&s->all_snaps);
+
+	/*
+	 * This code is called in the destructor, it is not performance
+	 * sensitive and thus we use polling with active waiting (msleep(1)).
+	 *
+	 * A possible 1ms delay on device destruction won't cause any trouble
+	 * and this polling is simpler and less bug-prone than using wait
+	 * queues.
+	 */
+poll_for_ios:
+	/* Wait for IOs on the snapshot */
+	spin_lock_irq(&dm_multisnap_bio_list_lock);
+	if (s->n_tracked_ios) {
+		spin_unlock_irq(&dm_multisnap_bio_list_lock);
+		msleep(1);
+		goto poll_for_ios;
+	}
+	spin_unlock_irq(&dm_multisnap_bio_list_lock);
+
+	/* Make sure that there really are no outstanding IOs */
+	for (i = 0; i < DM_MULTISNAP_N_QUEUES; i++)
+		BUG_ON(!bio_list_empty(&s->queue[i].bios));
+	for (i = 0; i < DM_TRACKED_CHUNK_HASH_SIZE; i++)
+		BUG_ON(!hlist_empty(&s->tracked_chunk_hash[i]));
+
+	/* Wait for pending reallocations */
+	dm_multisnap_lock(s);
+	for (i = 0; i < DM_PENDING_HASH_SIZE; i++)
+		if (!hlist_empty(&s->pending_hash[i])) {
+			dm_multisnap_unlock(s);
+			msleep(1);
+			goto poll_for_ios;
+		}
+	dm_multisnap_unlock(s);
+
+	flush_workqueue(s->wq);
+
+	dm_multisnap_lock(s);
+	dm_multisnap_call_commit(s);
+	s->store->exit_exception_store(s->p);
+	s->p = NULL;
+	list_del(&s->list_all);
+	dm_multisnap_unlock(s);
+
+	destroy_workqueue(s->wq);
+	kfree(s->p);
+	dm_kcopyd_client_destroy(s->kcopyd);
+	mempool_destroy(s->tracked_chunk_pool);
+	mempool_destroy(s->pending_pool);
+	dm_put_device(ti, s->snapshot);
+	dm_put_device(ti, s->origin);
+	dm_multisnap_put_exception_store(s->store);
+
+	kfree(s);
+
+	mutex_unlock(&all_multisnapshots_lock);
+}
+
+static int multisnap_origin_map(struct dm_target *ti, struct bio *bio,
+				union map_info *map_context)
+{
+	struct dm_multisnap *s = ti->private;
+
+	/*
+	 * Do the most common case quickly: reads and write barriers are
+	 * dispatched to the origin device directly.
+	 */
+	if (likely(bio_rw(bio) != WRITE) || unlikely(bio_empty_barrier(bio))) {
+		bio->bi_bdev = s->origin->bdev;
+		return DM_MAPIO_REMAPPED;
+	}
+
+	bio_put_snapid(bio, DM_SNAPID_T_ORIGIN);
+
+	dm_multisnap_enqueue_bio(s, bio);
+	wakeup_kmultisnapd(s);
+
+	return DM_MAPIO_SUBMITTED;
+}
+
+static int multisnap_origin_message(struct dm_target *ti,
+				    unsigned argc, char **argv)
+{
+	struct dm_multisnap *s = ti->private;
+	char *error;
+	int r;
+	int subsnap = 0;
+	snapid_t subsnap_id = 0;
+
+	mutex_lock(&all_multisnapshots_lock);
+	dm_multisnap_lock(s);
+
+	if (argc == 2 && !strcasecmp(argv[0], "create_subsnap")) {
+		/*
+		 * Create snapshot of snapshot.
+		 */
+		r = read_snapid(s, argv[1], &subsnap_id, &error);
+		if (r) {
+			DMWARN("invalid snapshot id: %s", error);
+			goto unlock_ret;
+		}
+		subsnap = 1;
+		goto create_snapshot;
+	}
+
+	if (argc == 1 && !strcasecmp(argv[0], "create")) {
+create_snapshot:
+		/*
+		 * Prepare snapshot creation.
+		 *
+		 * We allocate a snapid, and return it in the status.
+		 *
+		 * The snapshot is really created in postsuspend method (to
+		 * make sure that possibly mounted filesystem is quiescent and
+		 * the snapshot will be consistent).
+		 */
+		r = dm_multisnap_has_error(s);
+		if (r)
+			goto unlock_ret;
+
+		dm_multisnap_status_lock(s);
+		s->new_snapid_valid = 0;
+		dm_multisnap_status_unlock(s);
+
+		r = s->store->allocate_snapid(s->p, &s->new_snapid,
+					      subsnap, subsnap_id);
+		if (r)
+			goto unlock_ret;
+
+		r = dm_multisnap_has_error(s);
+		if (r)
+			goto unlock_ret;
+
+		dm_multisnap_status_lock(s);
+		s->new_snapid_valid = 1;
+		dm_multisnap_status_unlock(s);
+
+		r = 0;
+		goto unlock_ret;
+	}
+
+	if (argc == 2 && !strcasecmp(argv[0], "delete")) {
+		/*
+		 * Delete a snapshot.
+		 */
+		snapid_t snapid;
+		struct dm_multisnap_snap *sn;
+		struct bio *bio;
+		struct bio_list all_bios;
+
+		r = read_snapid(s, argv[1], &snapid, &error);
+		if (r) {
+			DMWARN("invalid snapshot id: %s", error);
+			goto unlock_ret;
+		}
+
+		if (!s->store->delete_snapshot) {
+			DMERR("snapshot store doesn't support delete");
+			r = -EOPNOTSUPP;
+			goto unlock_ret;
+		}
+
+		r = dm_multisnap_has_error(s);
+		if (r)
+			goto unlock_ret;
+
+		/* Kick off possibly attached snapshot */
+		list_for_each_entry(sn, &s->all_snaps, list_snaps) {
+			if (sn->snapid == snapid) {
+				spin_lock_irq(&dm_multisnap_bio_list_lock);
+				sn->s = NULL;
+				spin_unlock_irq(&dm_multisnap_bio_list_lock);
+			}
+		}
+
+		/* Terminate bios queued for this snapshot so far */
+		dm_multisnap_bio_dequeue_all(s, &all_bios);
+		while ((bio = bio_list_pop(&all_bios))) {
+			if (bio_get_snapid(bio) == snapid)
+				bio_endio(bio, -EIO);
+			else
+				dm_multisnap_enqueue_bio(s, bio);
+		}
+
+		if (!dm_multisnap_snapshot_exists(s, snapid)) {
+			DMWARN("snapshot with this id doesn't exists.");
+			r = -EINVAL;
+			goto unlock_ret;
+		}
+
+		r = s->store->delete_snapshot(s->p, snapid);
+		if (r)
+			goto unlock_ret;
+
+		dm_multisnap_unlock(s);
+
+		r = dm_multisnap_force_commit(s);
+
+		goto unlock2_ret;
+	}
+
+	DMWARN("unrecognised message received.");
+	r = -EINVAL;
+
+unlock_ret:
+	dm_multisnap_unlock(s);
+unlock2_ret:
+	mutex_unlock(&all_multisnapshots_lock);
+
+	return r;
+}
+
+/* Print used snapshot IDs into a supplied string */
+static void print_snapshot_ids(struct dm_multisnap *s, char *result, unsigned maxlen)
+{
+	snapid_t nsnap = 0;
+	snapid_t sn = 0;
+	while ((sn = s->store->get_next_snapid(s->p, sn)) != DM_SNAPID_T_ORIGIN)
+		sn++, nsnap++;
+	snprintf(result, maxlen, " %llu", (unsigned long long)nsnap);
+	dm_multisnap_adjust_string(&result, &maxlen);
+	sn = 0;
+	while ((sn = s->store->get_next_snapid(s->p, sn)) != DM_SNAPID_T_ORIGIN) {
+		snprintf(result, maxlen, " ");
+		dm_multisnap_adjust_string(&result, &maxlen);
+		print_snapid(s, result, maxlen, sn);
+		dm_multisnap_adjust_string(&result, &maxlen);
+		sn++;
+	}
+}
+
+static int multisnap_origin_status(struct dm_target *ti, status_type_t type,
+				   char *result, unsigned maxlen)
+{
+	struct dm_multisnap *s = ti->private;
+
+	/*
+	 * Use a special status lock, so that this code can execute even
+	 * when the underlying device is suspended and there is no possibility
+	 * to obtain the master lock.
+	 */
+	dm_multisnap_status_lock(s);
+
+	switch (type) {
+		case STATUSTYPE_INFO: {
+			unsigned long long total, alloc, meta;
+			snprintf(result, maxlen, "5 %d ", dm_multisnap_has_error(s));
+			dm_multisnap_adjust_string(&result, &maxlen);
+			if (s->new_snapid_valid)
+				print_snapid(s, result, maxlen, s->new_snapid);
+			else
+				snprintf(result, maxlen, "-");
+			dm_multisnap_adjust_string(&result, &maxlen);
+			if (s->store->get_space)
+				s->store->get_space(s->p, &total, &alloc, &meta);
+			else
+				total = alloc = meta = 0;
+			total <<= s->chunk_shift - SECTOR_SHIFT;
+			alloc <<= s->chunk_shift - SECTOR_SHIFT;
+			meta <<= s->chunk_shift - SECTOR_SHIFT;
+			snprintf(result, maxlen, " %llu %llu %llu", total, alloc, meta);
+			dm_multisnap_adjust_string(&result, &maxlen);
+			print_snapshot_ids(s, result, maxlen);
+			dm_multisnap_adjust_string(&result, &maxlen);
+			break;
+		}
+		case STATUSTYPE_TABLE: {
+			unsigned ngen = 0;
+			if (s->flags & DM_MULTISNAP_SYNC_SNAPSHOTS)
+				ngen++;
+			if (s->flags & DM_MULTISNAP_PRESERVE_ON_ERROR)
+				ngen++;
+			snprintf(result, maxlen, "%s %s %u %u%s%s %s",
+				s->origin->name,
+				s->snapshot->name,
+				s->chunk_size / 512,
+				ngen,
+				s->flags & DM_MULTISNAP_SYNC_SNAPSHOTS ?
+					" sync-snapshots" : "",
+				s->flags & DM_MULTISNAP_PRESERVE_ON_ERROR ?
+					" preserve-on-error" : "",
+				s->store->name);
+			dm_multisnap_adjust_string(&result, &maxlen);
+			if (s->store->status_table)
+				s->store->status_table(s->p, result, maxlen);
+			else
+				snprintf(result, maxlen, " 0");
+			dm_multisnap_adjust_string(&result, &maxlen);
+			if (s->flags & DM_MULTISNAP_SYNC_SNAPSHOTS) {
+				print_snapshot_ids(s, result, maxlen);
+				dm_multisnap_adjust_string(&result, &maxlen);
+			}
+			break;
+		}
+	}
+
+	dm_multisnap_status_unlock(s);
+
+	/* If there's no space left in the buffer, ask for larger size */
+	return maxlen <= 1;
+}
+
+/*
+ * In postsuspend, we optionally create a snapshot that we prepared with
+ * a message.
+ */
+static void multisnap_origin_postsuspend(struct dm_target *ti)
+{
+	struct dm_multisnap *s = ti->private;
+
+	dm_multisnap_lock(s);
+	if (s->new_snapid_valid && !dm_multisnap_has_error(s)) {
+		/*
+		 * No way to return the error code, but it is recorded
+		 * in s->error anyway.
+		 */
+		s->store->create_snapshot(s->p, s->new_snapid);
+		s->new_snapid_valid = 0;
+	}
+	dm_multisnap_unlock(s);
+
+	dm_multisnap_force_commit(s);
+}
+
+static int multisnap_snap_ctr(struct dm_target *ti, unsigned argc, char **argv)
+{
+	int r;
+	char *origin_path;
+	char *snapid_str;
+	snapid_t snapid;
+	int doesnt_exist;
+
+	struct dm_dev *origin;
+
+	struct dm_multisnap *s;
+	struct dm_multisnap_snap *sn;
+
+	r = dm_multisnap_get_string(&argv, &argc, &origin_path, &ti->error);
+	if (r)
+		goto bad_arguments;
+	r = dm_multisnap_get_string(&argv, &argc, &snapid_str, &ti->error);
+	if (r)
+		goto bad_arguments;
+	r = dm_get_device(ti, origin_path, 0, 0, FMODE_READ | FMODE_WRITE, &origin);
+	if (r) {
+		ti->error = "Could not get origin device";
+		goto bad_origin;
+	}
+	mutex_lock(&all_multisnapshots_lock);
+	s = find_multisnapshot(origin->bdev);
+	if (!s) {
+		r = -ENXIO;
+		ti->error = "Origin target not loaded";
+		goto origin_not_loaded;
+	}
+
+	dm_multisnap_lock(s);
+
+	r = read_snapid(s, snapid_str, &snapid, &ti->error);
+	if (r) {
+		dm_multisnap_unlock(s);
+		goto snapid_doesnt_exist;
+	}
+
+	doesnt_exist = 0;
+	if (!dm_multisnap_snapshot_exists(s, snapid)) {
+		if (dm_multisnap_has_error(s) && dm_multisnap_drop_on_error(s)) {
+			/*
+			 * If there was an error, we don't know which snapshot
+			 * IDs are available. So we must accept it. But we
+			 * abort all accesses to this snapshot with an error.
+			 */
+			 doesnt_exist = 1;
+		} else {
+			dm_multisnap_unlock(s);
+			r = -ENOENT;
+			ti->error = "Snapshot with this id doesn't exist";
+			goto snapid_doesnt_exist;
+		}
+	}
+	dm_multisnap_unlock(s);
+
+	sn = kmalloc(sizeof(*sn) + strlen(snapid_str), GFP_KERNEL);
+	if (!sn) {
+		ti->error = "Could not allocate multisnapshot_snap structure";
+		r = -ENOMEM;
+		goto cant_allocate;
+	}
+	sn->s = doesnt_exist ? NULL : s;
+	sn->snapid = snapid;
+	list_add(&sn->list_snaps, &s->all_snaps);
+	strlcpy(sn->origin_name, origin->name, sizeof sn->origin_name);
+	strcpy(sn->snapid_string, snapid_str);
+
+	mutex_unlock(&all_multisnapshots_lock);
+
+	dm_put_device(ti, origin);
+
+	ti->private = sn;
+	ti->split_io = s->chunk_size >> SECTOR_SHIFT;
+	ti->num_flush_requests = 1;
+
+	return 0;
+
+cant_allocate:
+snapid_doesnt_exist:
+origin_not_loaded:
+	dm_put_device(ti, origin);
+	mutex_unlock(&all_multisnapshots_lock);
+bad_origin:
+bad_arguments:
+	return r;
+}
+
+static void multisnap_snap_dtr(struct dm_target *ti)
+{
+	struct dm_multisnap_snap *sn = ti->private;
+
+	mutex_lock(&all_multisnapshots_lock);
+
+	list_del(&sn->list_snaps);
+	kfree(sn);
+
+	mutex_unlock(&all_multisnapshots_lock);
+}
+
+/*
+ * Each snapshot I/O is counted in n_tracked_ios in the origin and
+ * has 'struct dm_multisnap_tracked_chunk' allocated.
+ * dm_multisnap_tracked_chunk->node can be optionally linked into
+ * origin's hash of tracked I/Os.
+ */
+static int multisnap_snap_map(struct dm_target *ti, struct bio *bio,
+			      union map_info *map_context)
+{
+	struct dm_multisnap_snap *sn = ti->private;
+	struct dm_multisnap *s;
+	struct dm_multisnap_tracked_chunk *c;
+
+	bio_put_snapid(bio, sn->snapid);
+
+	spin_lock_irq(&dm_multisnap_bio_list_lock);
+	s = sn->s;
+	if (unlikely(!s)) {
+		spin_unlock_irq(&dm_multisnap_bio_list_lock);
+		return -EIO;
+	}
+	/*
+	 * make sure that the origin is not unloaded under us while
+	 * we drop the lock
+	 */
+	s->n_tracked_ios++;
+
+	c = mempool_alloc(s->tracked_chunk_pool, GFP_ATOMIC);
+	if (unlikely(!c)) {
+		spin_unlock_irq(&dm_multisnap_bio_list_lock);
+		c = mempool_alloc(s->tracked_chunk_pool, GFP_NOIO);
+		spin_lock_irq(&dm_multisnap_bio_list_lock);
+	}
+	c->s = s;
+	c->chunk = sector_to_chunk(s, bio->bi_sector);
+	c->bio_rw = bio_rw(bio);
+	INIT_HLIST_NODE(&c->node);
+	map_context->ptr = c;
+
+	if (unlikely(bio_empty_barrier(bio))) {
+		bio->bi_bdev = s->snapshot->bdev;
+		spin_unlock_irq(&dm_multisnap_bio_list_lock);
+		return DM_MAPIO_REMAPPED;
+	}
+
+	dm_multisnap_enqueue_bio_unlocked(s, bio);
+	spin_unlock_irq(&dm_multisnap_bio_list_lock);
+
+	wakeup_kmultisnapd(s);
+
+	return DM_MAPIO_SUBMITTED;
+}
+
+static int multisnap_snap_end_io(struct dm_target *ti, struct bio *bio,
+				 int error, union map_info *map_context)
+{
+	struct dm_multisnap_tracked_chunk *c = map_context->ptr;
+	struct dm_multisnap *s = c->s;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dm_multisnap_bio_list_lock, flags);
+
+	s->n_tracked_ios--;
+	if (!hlist_unhashed(&c->node))
+		hlist_del(&c->node);
+	mempool_free(c, s->tracked_chunk_pool);
+
+	spin_unlock_irqrestore(&dm_multisnap_bio_list_lock, flags);
+
+	return 0;
+}
+
+static int multisnap_snap_status(struct dm_target *ti, status_type_t type,
+				 char *result, unsigned maxlen)
+{
+	struct dm_multisnap_snap *sn = ti->private;
+
+	switch (type) {
+
+	case STATUSTYPE_INFO:
+		/* there is no status */
+		result[0] = 0;
+		dm_multisnap_adjust_string(&result, &maxlen);
+		break;
+	case STATUSTYPE_TABLE:
+		snprintf(result, maxlen, "%s %s",
+			 sn->origin_name, sn->snapid_string);
+		dm_multisnap_adjust_string(&result, &maxlen);
+		break;
+	}
+
+	/* If there's no space left in the buffer, ask for larger size */
+	return maxlen <= 1;
+}
+
+static struct target_type multisnap_origin_target = {
+	.name		= "multisnapshot",
+	.version 	= {1, 0, 0},
+	.module		= THIS_MODULE,
+	.ctr		= multisnap_origin_ctr,
+	.dtr		= multisnap_origin_dtr,
+	.map		= multisnap_origin_map,
+	.message 	= multisnap_origin_message,
+	.status		= multisnap_origin_status,
+	.postsuspend	= multisnap_origin_postsuspend,
+};
+
+static struct target_type multisnap_snap_target = {
+	.name		= "multisnap-snap",
+	.version 	= {1, 0, 0},
+	.module		= THIS_MODULE,
+	.ctr		= multisnap_snap_ctr,
+	.dtr		= multisnap_snap_dtr,
+	.map		= multisnap_snap_map,
+	.end_io		= multisnap_snap_end_io,
+	.status		= multisnap_snap_status,
+};
+
+static int __init dm_multisnapshot_init(void)
+{
+	int r;
+
+	pending_exception_cache = kmem_cache_create(
+			"dm_multisnap_pending_exception",
+			sizeof(struct dm_multisnap_pending_exception),
+			__alignof__(struct dm_multisnap_pending_exception),
+			0,
+			pending_exception_ctor);
+	if (!pending_exception_cache) {
+		DMERR("Couldn't create exception cache.");
+		r = -ENOMEM;
+		goto bad_exception_cache;
+	}
+	tracked_chunk_cache = KMEM_CACHE(dm_multisnap_tracked_chunk, 0);
+	if (!tracked_chunk_cache) {
+		DMERR("Couldn't create cache to track chunks in use.");
+		r = -ENOMEM;
+		goto bad_tracked_chunk_cache;
+	}
+
+	r = dm_register_target(&multisnap_origin_target);
+	if (r < 0) {
+		DMERR("multisnap_origin_target target register failed %d", r);
+		goto bad_multisnap_origin_target;
+	}
+
+	r = dm_register_target(&multisnap_snap_target);
+	if (r < 0) {
+		DMERR("multisnap_snap_target target register failed %d", r);
+		goto bad_multisnap_snap_target;
+	}
+
+	return 0;
+
+bad_multisnap_snap_target:
+	dm_unregister_target(&multisnap_origin_target);
+bad_multisnap_origin_target:
+	kmem_cache_destroy(tracked_chunk_cache);
+bad_tracked_chunk_cache:
+	kmem_cache_destroy(pending_exception_cache);
+bad_exception_cache:
+	return r;
+}
+
+static void __exit dm_multisnapshot_exit(void)
+{
+	dm_unregister_target(&multisnap_origin_target);
+	dm_unregister_target(&multisnap_snap_target);
+	kmem_cache_destroy(tracked_chunk_cache);
+	kmem_cache_destroy(pending_exception_cache);
+}
+
+/* Module hooks */
+module_init(dm_multisnapshot_init);
+module_exit(dm_multisnapshot_exit);
+
+MODULE_DESCRIPTION(DM_NAME " multisnapshot target");
+MODULE_AUTHOR("Mikulas Patocka");
+MODULE_LICENSE("GPL");
diff --git a/drivers/md/dm-multisnap.h b/drivers/md/dm-multisnap.h
new file mode 100644
index 0000000..0af87dd
--- /dev/null
+++ b/drivers/md/dm-multisnap.h
@@ -0,0 +1,183 @@
+/*
+ * Copyright (C) 2009 Red Hat Czech, s.r.o.
+ *
+ * Mikulas Patocka <mpatocka@redhat.com>
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef DM_MULTISNAP_H
+#define DM_MULTISNAP_H
+
+/*
+ * This file defines the interface between generic driver (dm-multisnap.c)
+ * and exception store drivers.
+ */
+
+#include <linux/device-mapper.h>
+#include <linux/list.h>
+
+#define EFSERROR	EPERM
+
+#define DM_MSG_PREFIX	"multisnapshot"
+
+#define DM_SNAPID_T_ORIGIN	0xffffffffffffffffULL
+
+typedef sector_t chunk_t;
+typedef __u64 snapid_t;
+
+struct dm_multisnap;		/* private to dm-multisnap.c */
+struct dm_exception_store;	/* private to the exception store driver */
+
+struct dm_multisnap_background_work {
+	struct list_head list;
+	void (*work)(struct dm_exception_store *, struct dm_multisnap_background_work *);
+	int queued;
+};
+
+union chunk_descriptor {
+	__u64 bitmask;
+	struct {
+		snapid_t from;
+		snapid_t to;
+	} range;
+};
+
+struct dm_multisnap_exception_store {
+	struct list_head list;
+	struct module *module;
+	const char *name;
+
+	/* < 0 - error */
+	int (*init_exception_store)(struct dm_multisnap *dm, struct dm_exception_store **s,
+				    unsigned argc, char **argv, char **error);
+
+	void (*exit_exception_store)(struct dm_exception_store *s);
+
+	void (*store_lock_acquired)(struct dm_exception_store *s, int flags);
+
+	/* These two can override format of snapids in the table. Can be NULL */
+	void (*print_snapid)(struct dm_exception_store *s, char *string,
+			     unsigned maxlen, snapid_t snapid);
+	int (*read_snapid)(struct dm_exception_store *s, char *string,
+			   snapid_t *snapid, char **error);
+
+	/* return the exception-store specific table arguments */
+	void (*status_table)(struct dm_exception_store *s, char *result, unsigned maxlen);
+
+	/* return the space */
+	void (*get_space)(struct dm_exception_store *s, unsigned long long *chunks_total,
+			  unsigned long long *chunks_allocated,
+			  unsigned long long *chunks_metadata_allocated);
+
+	/* < 0 - error */
+	int (*allocate_snapid)(struct dm_exception_store *s, snapid_t *snapid,
+			       int snap_of_snap, snapid_t master);
+
+	/* < 0 - error */
+	int (*create_snapshot)(struct dm_exception_store *s, snapid_t snapid);
+
+	/* < 0 - error (may be NULL if not supported) */
+	int (*delete_snapshot)(struct dm_exception_store *s, snapid_t snapid);
+
+	/*
+	 * Get the first snapid at or after snapid in its argument.
+	 * If there are no more snapids, return DM_SNAPID_T_ORIGIN.
+	 */
+	snapid_t (*get_next_snapid)(struct dm_exception_store *s, snapid_t snapid);
+
+	/*
+	 * qsort()-compatible function to order snapshots for creation.
+	 * may be NULL if standard ordering should be used.
+	 */
+	int (*compare_snapids_for_create)(const void *p1, const void *p2);
+
+	/* 0 - not found, 1 - found (read-only), 2 - found (writeable), < 0 - error */
+	int (*find_snapshot_chunk)(struct dm_exception_store *s, snapid_t snapid,
+				   chunk_t chunk, int write, chunk_t *result);
+
+	/*
+	 * Chunk interface between exception store and generic code.
+	 * Allowed sequences:
+	 *
+	 * - first call reset_query
+	 *   then repeatedly query next exception to make with query_next_remap
+	 *   and add it to btree with add_next_remap. This can be repeated until
+	 *   query_next_remap indicates that it has nothing more or until all 8
+	 *   kcopyd slots are filled.
+	 *
+	 * - call find_snapshot_chunk, if it returns 0, you can call
+	 *   add_next_remap to add the chunk to the btree.
+	 *
+	 * - call find_snapshot_chunk, if it returns 1 (shared chunk), call
+	 *   make_chunk_writeable to relocate that chunk.
+	 */
+
+	void (*reset_query)(struct dm_exception_store *s);
+	int (*query_next_remap)(struct dm_exception_store *s, chunk_t chunk);
+	void (*add_next_remap)(struct dm_exception_store *s,
+			       union chunk_descriptor *cd, chunk_t *new_chunk);
+
+	/* may be NULL if writeable snapshots are not supported */
+	void (*make_chunk_writeable)(struct dm_exception_store *s,
+				     union chunk_descriptor *cd, chunk_t *new_chunk);
+	int (*check_conflict)(struct dm_exception_store *s,
+			      union chunk_descriptor *cd, snapid_t snapid);
+
+	/* This is called without the lock, prior to commit */
+	void (*prepare_for_commit)(struct dm_exception_store *s);
+
+	/* Commit the transactions */
+	void (*commit)(struct dm_exception_store *s);
+};
+
+#define DM_MULTISNAP_SET_ERROR(dm, err, msg)				\
+do {									\
+	DMERR msg;							\
+	dm_multisnap_set_error(dm, err);				\
+} while (0)
+
+/* dm-multisnap.c */
+
+/* Access generic information about the snapshot */
+struct block_device *dm_multisnap_snapshot_bdev(struct dm_multisnap *s);
+unsigned dm_multisnap_chunk_size(struct dm_multisnap *s);
+void dm_multisnap_set_error(struct dm_multisnap *s, int error);
+int dm_multisnap_has_error(struct dm_multisnap *s);
+int dm_multisnap_drop_on_error(struct dm_multisnap *s);
+int dm_multisnap_snapshot_exists(struct dm_multisnap *s, snapid_t snapid);
+
+/* Lock status/table queries */
+void dm_multisnap_status_lock(struct dm_multisnap *s);
+void dm_multisnap_status_unlock(struct dm_multisnap *s);
+void dm_multisnap_status_assert_locked(struct dm_multisnap *s);
+
+/*
+ * Commit. dm_multisnap_call_commit can only be called
+ * if dm_multisnap_can_commit returns true
+ */
+int dm_multisnap_can_commit(struct dm_multisnap *s);
+void dm_multisnap_call_commit(struct dm_multisnap *s);
+
+/* Delayed work for delete/merge */
+void dm_multisnap_queue_work(struct dm_multisnap *s,
+			     struct dm_multisnap_background_work *bw);
+void dm_multisnap_cancel_work(struct dm_multisnap *s,
+			      struct dm_multisnap_background_work *bw);
+
+/* Parsing command line */
+int dm_multisnap_get_string(char ***argv, unsigned *argc,
+			    char **string, char **error);
+int dm_multisnap_get_uint64(char ***argv, unsigned *argc,
+			    __u64 *unsigned_int64, char **error);
+int dm_multisnap_get_uint(char ***argv, unsigned *argc,
+			  unsigned *unsigned_int, char **error);
+int dm_multisnap_get_argcount(char ***argv, unsigned *argc,
+			      unsigned *unsigned_int, char **error);
+void dm_multisnap_adjust_string(char **result, unsigned *maxlen);
+
+/* Register/unregister the exception store driver */
+int dm_multisnap_register_exception_store(struct dm_multisnap_exception_store *store);
+void dm_multisnap_unregister_exception_store(struct dm_multisnap_exception_store *store);
+
+#endif
-- 
1.6.5.2
