From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: [PATCH for-3.14] Add dm-writeboost (log-structured
	caching target)
Date: Sat, 11 Jan 2014 16:36:02 +0900
Message-ID: <52D0F462.4020300@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
List-Id: dm-devel.ids

dm-writeboost is an another cache target like dm-cache and bcache.
The biggest difference from existing cache softwares is that
it focuses on bursty writes.

dm-writeboost first writes the data to RAM buffer and makes a
log containing both data and their metadata.
The log is written to the cache device in log-structured manner.
The fact that the log contains metadata of the data blocks makes
dm-writeboost is robust for power fault. It can replay the log
after crash.

Signed-off-by: Akira Hayakawa <ruby.wktk@gmail.com>
---
 Documentation/device-mapper/dm-writeboost.txt |  161 +++
 drivers/md/Kconfig                            |    8 +
 drivers/md/Makefile                           |    3 +
 drivers/md/dm-writeboost-daemon.c             |  520 ++++++++++
 drivers/md/dm-writeboost-daemon.h             |   40 +
 drivers/md/dm-writeboost-metadata.c           | 1352 +++++++++++++++++++++++++
 drivers/md/dm-writeboost-metadata.h           |   51 +
 drivers/md/dm-writeboost-target.c             | 1258 +++++++++++++++++++++++
 drivers/md/dm-writeboost.h                    |  464 +++++++++
 9 files changed, 3857 insertions(+)
 create mode 100644 Documentation/device-mapper/dm-writeboost.txt
 create mode 100644 drivers/md/dm-writeboost-daemon.c
 create mode 100644 drivers/md/dm-writeboost-daemon.h
 create mode 100644 drivers/md/dm-writeboost-metadata.c
 create mode 100644 drivers/md/dm-writeboost-metadata.h
 create mode 100644 drivers/md/dm-writeboost-target.c
 create mode 100644 drivers/md/dm-writeboost.h

diff --git a/Documentation/device-mapper/dm-writeboost.txt b/Documentation/device-mapper/dm-writeboost.txt
new file mode 100644
index 0000000..0161663
--- /dev/null
+++ b/Documentation/device-mapper/dm-writeboost.txt
@@ -0,0 +1,161 @@
+dm-writeboost
+=============
+Writeboost target provides log-structured caching.
+It batches random writes into a big sequential write to a cache device.
+
+It is like dm-cache as a cache target but the difference is that Writeboost
+focuses on bursty writes and the lifetime of the SSD cache device.
+
+More documents and tests are available in
+https://github.com/akiradeveloper/dm-writeboost
+
+Design
+======
+There are 1 foreground and 6 background processes.
+
+Foreground
+----------
+It accepts bios and stores the write data to RAM buffer.
+When the buffer is full, it creates a "flush job" and queues it.
+
+Background
+----------
+* wbflusher (Writeboost flusher)
+Executes a flush job.
+wbflusher exploits workqueue mechanism and may run in parallel.
+It exhibits the sysfs (/sys/bus/workqueue/devices/wbflusher)
+to control the behavior.
+
+* Barrier deadline worker
+Barrier flags such as REQ_FUA and REQ_FLUSH are acked lazily.
+Immediately handling these bios badly deteriorate the throughput.
+Bios with these flags are queued and forcefully processed at worst
+within `barrier_deadline_ms` period.
+
+* Migrate Daemon
+It migrates, or writes back, cache data to backing store.
+
+If `allow_migrate` is true, it migrates without impending situation.
+Being in impending situation is that there are no room in cache device
+for writing more flush jobs.
+
+Migration is done batching `nr_max_batched_migration` segments at maximum
+at a time. Thus, unlike existing I/O scheduler, two dirty writes close in
+positional space but distant in time space can be merged. Writetboost is
+also a extension of I/O scheduler.
+
+* Migration Modulator
+Migration while the backing store is heavily loaded grows the device queue
+longer and affects the read from the backing store.
+Migration modulator surveils the load of the backing store and turns on/off
+the migration by switching `allow_migrate`.
+
+* Superblock Recorder
+Superblock is a last sector of first 1MB region in cache device containing
+what id of the segment lastly migrated. This daemon periodically updates
+the region every `update_record_interval` seconds.
+
+* Sync Daemon
+This daemon forcefully writes out all the dirty data persistently every
+`sync_interval` seconds. Some careful users want to make all the writes
+persistent periodically.
+
+Target Interface
+================
+All the operations are via dmsetup command.
+
+Constructor
+-----------
+<type>
+<essential args>*
+<#optional args> <optional args>*
+<#tunable args> <tunable args>* (see 'Message')
+
+Optionals are tunables are unordered lists of Key-Value pairs.
+
+Essential args and optional args are different for different buffer type.
+
+<type> (The type of the RAM buffer)
+0: volatile RAM buffer (DRAM)
+1: non-volatile buffer with a block I/F
+2: non-volatile buffer with PRAM I/F
+
+Currently, only type 0 is supported.
+
+Type 0
+------
+<essential args>
+backing_dev        : Slow device holding original data blocks.
+cache_dev          : Fast device holding cached data and its metadata.
+
+<optional args>
+segment_size_order : The size of RAM buffer
+                     1 << n (sectors), 4 <= n <= 10
+                     default 7
+rambuf_pool_amount : The amount of the RAM buffer pool (kB).
+                     Too fewer amount may cause waiting for new buffer
+                     to become available again. But too much doesn't
+		     benefit the performance.
+                     default 2048
+
+Note that cache device is re-formatted if the first sector of the cache
+device is zeroed out.
+
+Status
+------
+<cursor pos>
+<#cache blocks>
+<#segments>
+<current id>
+<lastly flushed id>
+<lastly migrated id>
+<#dirty cache blocks>
+<stat (w/r) x (hit/miss) x (on buffer?) x (fullsize?)>
+<#not full flushed>
+<#tunable args> [tunable args]
+
+Messages
+--------
+You can tune up the behavior of writeboost via message interface.
+
+* barrier_deadline_ms (ms)
+Default: 3
+All the bios with barrier flags like REQ_FUA or REQ_FLUSH
+are guaranteed to be acked within this deadline.
+
+* allow_migrate (bool)
+Default: 1
+Set to 1 to start migration.
+
+* enable_migration_modulator (bool) and
+  migrate_threshold (%)
+Default: 1 and 70
+Set to 1 to run migration modulator.
+Migration modulator surveils the load of backing store and sets the
+migration started if the load is lower than the `migrate_threshold`.
+
+* nr_max_batched_migration (int)
+Default: 1MB / segment size
+Number of segments to migrate at a time.
+Set higher value to fully exploit the capacily of the backing store.
+Even a single HDD is capable of processing 1MB/sec random writes so
+the default value is set to 1MB / segment size. Set higher value if
+you use RAID-ed drive as the backing store.
+
+* update_record_interval (sec)
+Default: 60
+The superblock record is updated every update_record_interval seconds.
+
+* sync_interval (sec)
+Default: 60
+All the dirty writes are guaranteed to be persistent every this interval.
+
+Example
+=======
+dmsetup create writeboost-vol --table "0 ${sz} 0 writeboost ${BACKING} {CACHE}"
+dmsetup create writeboost-vol --table "0 ${sz} 0 writeboost ${BACKING} {CACHE} \
+                                       4 rambuf_pool_amount 8192 segment_size_order 8 \
+				       2 allow_migrate 1"
+dmsetup create writeboost-vol --table "0 ${sz} 0 writeboost ${BACKING} {CACHE} \
+                                       0 \
+				       2 allow_migrate 1"
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index f2ccbc3..65a6d95 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -290,6 +290,14 @@ config DM_CACHE_CLEANER
          A simple cache policy that writes back all data to the
          origin.  Used when decommissioning a dm-cache.
 
+config DM_WRITEBOOST
+	tristate "Log-structured Caching (EXPERIMENTAL)"
+	depends on BLK_DEV_DM
+	default y
+	---help---
+	  A cache layer that batches random writes into a big sequential
+	  write to a cache device in log-structured manner.
+
 config DM_MIRROR
        tristate "Mirror target"
        depends on BLK_DEV_DM
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 2acc43f..6db61ce 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -14,6 +14,8 @@ dm-thin-pool-y	+= dm-thin.o dm-thin-metadata.o
 dm-cache-y	+= dm-cache-target.o dm-cache-metadata.o dm-cache-policy.o
 dm-cache-mq-y   += dm-cache-policy-mq.o
 dm-cache-cleaner-y += dm-cache-policy-cleaner.o
+dm-writeboost-y	+= dm-writeboost-target.o dm-writeboost-metadata.o \
+			dm-writeboost-daemon.o
 md-mod-y	+= md.o bitmap.o
 raid456-y	+= raid5.o
 
@@ -52,6 +54,7 @@ obj-$(CONFIG_DM_VERITY)		+= dm-verity.o
 obj-$(CONFIG_DM_CACHE)		+= dm-cache.o
 obj-$(CONFIG_DM_CACHE_MQ)	+= dm-cache-mq.o
 obj-$(CONFIG_DM_CACHE_CLEANER)	+= dm-cache-cleaner.o
+obj-$(CONFIG_DM_WRITEBOOST)	+= dm-writeboost.o
 
 ifeq ($(CONFIG_DM_UEVENT),y)
 dm-mod-objs			+= dm-uevent.o
diff --git a/drivers/md/dm-writeboost-daemon.c b/drivers/md/dm-writeboost-daemon.c
new file mode 100644
index 0000000..5ea1300
--- /dev/null
+++ b/drivers/md/dm-writeboost-daemon.c
@@ -0,0 +1,520 @@
+/*
+ * Copyright (C) 2012-2014 Akira Hayakawa <ruby.wktk@gmail.com>
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm-writeboost.h"
+#include "dm-writeboost-metadata.h"
+#include "dm-writeboost-daemon.h"
+
+/*----------------------------------------------------------------*/
+
+static void update_barrier_deadline(struct wb_device *wb)
+{
+	mod_timer(&wb->barrier_deadline_timer,
+		  jiffies + msecs_to_jiffies(ACCESS_ONCE(wb->barrier_deadline_ms)));
+}
+
+void queue_barrier_io(struct wb_device *wb, struct bio *bio)
+{
+	mutex_lock(&wb->io_lock);
+	bio_list_add(&wb->barrier_ios, bio);
+	mutex_unlock(&wb->io_lock);
+
+	if (!timer_pending(&wb->barrier_deadline_timer))
+		update_barrier_deadline(wb);
+}
+
+void barrier_deadline_proc(unsigned long data)
+{
+	struct wb_device *wb = (struct wb_device *) data;
+	schedule_work(&wb->barrier_deadline_work);
+}
+
+void flush_barrier_ios(struct work_struct *work)
+{
+	struct wb_device *wb = container_of(
+		work, struct wb_device, barrier_deadline_work);
+
+	if (bio_list_empty(&wb->barrier_ios))
+		return;
+
+	atomic64_inc(&wb->count_non_full_flushed);
+	flush_current_buffer(wb);
+}
+
+/*----------------------------------------------------------------*/
+
+static void
+process_deferred_barriers(struct wb_device *wb, struct flush_job *job)
+{
+	int r = 0;
+	bool has_barrier = !bio_list_empty(&job->barrier_ios);
+
+	/*
+	 * Make all the data until now persistent.
+	 */
+	if (has_barrier)
+		IO(blkdev_issue_flush(wb->cache_dev->bdev, GFP_NOIO, NULL));
+
+	/*
+	 * Ack the chained barrier requests.
+	 */
+	if (has_barrier) {
+		struct bio *bio;
+		while ((bio = bio_list_pop(&job->barrier_ios))) {
+			LIVE_DEAD(
+				bio_endio(bio, 0),
+				bio_endio(bio, -EIO)
+			);
+		}
+	}
+
+	if (has_barrier)
+		update_barrier_deadline(wb);
+}
+
+void flush_proc(struct work_struct *work)
+{
+	int r = 0;
+
+	struct flush_job *job = container_of(work, struct flush_job, work);
+
+	struct wb_device *wb = job->wb;
+	struct segment_header *seg = job->seg;
+
+	struct dm_io_request io_req = {
+		.client = wb_io_client,
+		.bi_rw = WRITE,
+		.notify.fn = NULL,
+		.mem.type = DM_IO_KMEM,
+		.mem.ptr.addr = job->rambuf->data,
+	};
+	struct dm_io_region region = {
+		.bdev = wb->cache_dev->bdev,
+		.sector = seg->start_sector,
+		.count = (seg->length + 1) << 3,
+	};
+
+	/*
+	 * The actual write requests to the cache device are not serialized.
+	 * They may perform in parallel.
+	 */
+	IO(dm_safe_io(&io_req, 1, &region, NULL, false));
+
+	/*
+	 * Deferred ACK for barrier requests
+	 * To serialize barrier ACK in logging we wait for the previous
+	 * segment to be persistently written (if needed).
+	 */
+	wait_for_flushing(wb, SUB_ID(seg->id, 1));
+
+	process_deferred_barriers(wb, job);
+
+	/*
+	 * We can count up the last_flushed_segment_id only after segment
+	 * is written persistently. Counting up the id is serialized.
+	 */
+	atomic64_inc(&wb->last_flushed_segment_id);
+	wake_up_interruptible(&wb->flush_wait_queue);
+
+	mempool_free(job, wb->flush_job_pool);
+}
+
+void wait_for_flushing(struct wb_device *wb, u64 id)
+{
+	wait_event_interruptible(wb->flush_wait_queue,
+		atomic64_read(&wb->last_flushed_segment_id) >= id);
+}
+
+/*----------------------------------------------------------------*/
+
+static void migrate_endio(unsigned long error, void *context)
+{
+	struct wb_device *wb = context;
+
+	if (error)
+		atomic_inc(&wb->migrate_fail_count);
+
+	if (atomic_dec_and_test(&wb->migrate_io_count))
+		wake_up_interruptible(&wb->migrate_io_wait_queue);
+}
+
+/*
+ * Asynchronously submit the segment data at position k in the migrate buffer.
+ * Batched migration first collects all the segments to migrate into a migrate buffer.
+ * So, there are a number of segment data in the migrate buffer.
+ * This function submits the one in position k.
+ */
+static void submit_migrate_io(struct wb_device *wb, struct segment_header *seg,
+			      size_t k)
+{
+	int r = 0;
+
+	size_t a = wb->nr_caches_inseg * k;
+	void *p = wb->migrate_buffer + (wb->nr_caches_inseg << 12) * k;
+
+	u8 i;
+	for (i = 0; i < seg->length; i++) {
+		unsigned long offset = i << 12;
+		void *base = p + offset;
+
+		struct metablock *mb = seg->mb_array + i;
+		u8 dirty_bits = *(wb->dirtiness_snapshot + (a + i));
+		if (!dirty_bits)
+			continue;
+
+		if (dirty_bits == 255) {
+			void *addr = base;
+			struct dm_io_request io_req_w = {
+				.client = wb_io_client,
+				.bi_rw = WRITE,
+				.notify.fn = migrate_endio,
+				.notify.context = wb,
+				.mem.type = DM_IO_VMA,
+				.mem.ptr.vma = addr,
+			};
+			struct dm_io_region region_w = {
+				.bdev = wb->origin_dev->bdev,
+				.sector = mb->sector,
+				.count = 1 << 3,
+			};
+			IO(dm_safe_io(&io_req_w, 1, &region_w, NULL, false));
+		} else {
+			u8 j;
+			for (j = 0; j < 8; j++) {
+				struct dm_io_request io_req_w;
+				struct dm_io_region region_w;
+
+				void *addr = base + (j << SECTOR_SHIFT);
+				bool bit_on = dirty_bits & (1 << j);
+				if (!bit_on)
+					continue;
+
+				io_req_w = (struct dm_io_request) {
+					.client = wb_io_client,
+					.bi_rw = WRITE,
+					.notify.fn = migrate_endio,
+					.notify.context = wb,
+					.mem.type = DM_IO_VMA,
+					.mem.ptr.vma = addr,
+				};
+				region_w = (struct dm_io_region) {
+					.bdev = wb->origin_dev->bdev,
+					.sector = mb->sector + j,
+					.count = 1,
+				};
+				IO(dm_safe_io(&io_req_w, 1, &region_w, NULL, false));
+			}
+		}
+	}
+}
+
+static void memorize_data_to_migrate(struct wb_device *wb,
+				     struct segment_header *seg, size_t k)
+{
+	int r = 0;
+
+	void *p = wb->migrate_buffer + (wb->nr_caches_inseg << 12) * k;
+	struct dm_io_request io_req_r = {
+		.client = wb_io_client,
+		.bi_rw = READ,
+		.notify.fn = NULL,
+		.mem.type = DM_IO_VMA,
+		.mem.ptr.vma = p,
+	};
+	struct dm_io_region region_r = {
+		.bdev = wb->cache_dev->bdev,
+		.sector = seg->start_sector + (1 << 3),
+		.count = seg->length << 3,
+	};
+	IO(dm_safe_io(&io_req_r, 1, &region_r, NULL, false));
+}
+
+/*
+ * We first memorize the snapshot of the dirtiness in the segments.
+ * The snapshot dirtiness is dirtier than that of any future moment
+ * because it is only monotonously decreasing after flushed.
+ * Therefore, we will migrate the possible dirtiest state of the
+ * segments which won't lose any dirty data.
+ */
+static void memorize_metadata_to_migrate(struct wb_device *wb, struct segment_header *seg,
+					 size_t k, size_t *migrate_io_count)
+{
+	u8 i, j;
+
+	struct metablock *mb;
+	size_t a = wb->nr_caches_inseg * k;
+
+	/*
+	 * We first memorize the dirtiness of the metablocks.
+	 * Dirtiness may decrease while we run through the migration code
+	 * and it may cause corruption.
+	 */
+	for (i = 0; i < seg->length; i++) {
+		mb = seg->mb_array + i;
+		*(wb->dirtiness_snapshot + (a + i)) = read_mb_dirtiness(wb, seg, mb);
+	}
+
+	for (i = 0; i < seg->length; i++) {
+		u8 dirty_bits = *(wb->dirtiness_snapshot + (a + i));
+
+		if (!dirty_bits)
+			continue;
+
+		if (dirty_bits == 255) {
+			(*migrate_io_count)++;
+		} else {
+			for (j = 0; j < 8; j++) {
+				if (dirty_bits & (1 << j))
+					(*migrate_io_count)++;
+			}
+		}
+	}
+}
+
+/*
+ * Memorize the dirtiness snapshot and count up the number of io to migrate.
+ */
+static void memorize_dirty_state(struct wb_device *wb, struct segment_header *seg,
+				 size_t k, size_t *migrate_io_count)
+{
+	memorize_data_to_migrate(wb, seg, k);
+	memorize_metadata_to_migrate(wb, seg, k, migrate_io_count);
+}
+
+static void cleanup_segment(struct wb_device *wb, struct segment_header *seg)
+{
+	u8 i;
+	for (i = 0; i < seg->length; i++) {
+		struct metablock *mb = seg->mb_array + i;
+		cleanup_mb_if_dirty(wb, seg, mb);
+	}
+}
+
+static void transport_emigrates(struct wb_device *wb)
+{
+	int r;
+	struct segment_header *seg;
+	size_t k, migrate_io_count = 0;
+
+	for (k = 0; k < wb->num_emigrates; k++) {
+		seg = *(wb->emigrates + k);
+		memorize_dirty_state(wb, seg, k, &migrate_io_count);
+	}
+
+migrate_write:
+	atomic_set(&wb->migrate_io_count, migrate_io_count);
+	atomic_set(&wb->migrate_fail_count, 0);
+
+	for (k = 0; k < wb->num_emigrates; k++) {
+		seg = *(wb->emigrates + k);
+		submit_migrate_io(wb, seg, k);
+	}
+
+	LIVE_DEAD(
+		wait_event_interruptible(wb->migrate_io_wait_queue,
+					 !atomic_read(&wb->migrate_io_count)),
+		atomic_set(&wb->migrate_io_count, 0));
+
+	if (atomic_read(&wb->migrate_fail_count)) {
+		WBWARN("%u writebacks failed. retry",
+		       atomic_read(&wb->migrate_fail_count));
+		goto migrate_write;
+	}
+	BUG_ON(atomic_read(&wb->migrate_io_count));
+
+	/*
+	 * We clean up the metablocks because there is no reason
+	 * to leave the them dirty.
+	 */
+	for (k = 0; k < wb->num_emigrates; k++) {
+		seg = *(wb->emigrates + k);
+		cleanup_segment(wb, seg);
+	}
+
+	/*
+	 * We must write back a segments if it was written persistently.
+	 * Nevertheless, we betray the upper layer.
+	 * Remembering which segment is persistent is too expensive
+	 * and furthermore meaningless.
+	 * So we consider all segments are persistent and write them back
+	 * persistently.
+	 */
+	IO(blkdev_issue_flush(wb->origin_dev->bdev, GFP_NOIO, NULL));
+}
+
+static void do_migrate_proc(struct wb_device *wb)
+{
+	u32 i, nr_mig_candidates, nr_mig, nr_max_batch;
+	struct segment_header *seg;
+
+	bool start_migrate = ACCESS_ONCE(wb->allow_migrate) ||
+			     ACCESS_ONCE(wb->urge_migrate)  ||
+			     ACCESS_ONCE(wb->force_drop);
+
+	if (!start_migrate) {
+		schedule_timeout_interruptible(msecs_to_jiffies(1000));
+		return;
+	}
+
+	nr_mig_candidates = atomic64_read(&wb->last_flushed_segment_id) -
+			    atomic64_read(&wb->last_migrated_segment_id);
+
+	if (!nr_mig_candidates) {
+		schedule_timeout_interruptible(msecs_to_jiffies(1000));
+		return;
+	}
+
+	nr_max_batch = ACCESS_ONCE(wb->nr_max_batched_migration);
+	if (wb->nr_cur_batched_migration != nr_max_batch)
+		try_alloc_migration_buffer(wb, nr_max_batch);
+	nr_mig = min(nr_mig_candidates, wb->nr_cur_batched_migration);
+
+	/*
+	 * Store emigrates
+	 */
+	for (i = 0; i < nr_mig; i++) {
+		seg = get_segment_header_by_id(wb,
+			atomic64_read(&wb->last_migrated_segment_id) + 1 + i);
+		*(wb->emigrates + i) = seg;
+	}
+	wb->num_emigrates = nr_mig;
+	transport_emigrates(wb);
+
+	atomic64_add(nr_mig, &wb->last_migrated_segment_id);
+	wake_up_interruptible(&wb->migrate_wait_queue);
+}
+
+int migrate_proc(void *data)
+{
+	struct wb_device *wb = data;
+	while (!kthread_should_stop())
+		do_migrate_proc(wb);
+	return 0;
+}
+
+/*
+ * Wait for a segment to be migrated.
+ * After migrated the metablocks in the segment are clean.
+ */
+void wait_for_migration(struct wb_device *wb, u64 id)
+{
+	wb->urge_migrate = true;
+	wake_up_process(wb->migrate_daemon);
+	wait_event_interruptible(wb->migrate_wait_queue,
+		atomic64_read(&wb->last_migrated_segment_id) >= id);
+	wb->urge_migrate = false;
+}
+
+/*----------------------------------------------------------------*/
+
+int modulator_proc(void *data)
+{
+	struct wb_device *wb = data;
+
+	struct hd_struct *hd = wb->origin_dev->bdev->bd_part;
+	unsigned long old = 0, new, util;
+	unsigned long intvl = 1000;
+
+	while (!kthread_should_stop()) {
+		new = jiffies_to_msecs(part_stat_read(hd, io_ticks));
+
+		if (!ACCESS_ONCE(wb->enable_migration_modulator))
+			goto modulator_update;
+
+		util = div_u64(100 * (new - old), 1000);
+
+		if (util < ACCESS_ONCE(wb->migrate_threshold))
+			wb->allow_migrate = true;
+		else
+			wb->allow_migrate = false;
+
+modulator_update:
+		old = new;
+
+		schedule_timeout_interruptible(msecs_to_jiffies(intvl));
+	}
+	return 0;
+}
+
+/*----------------------------------------------------------------*/
+
+static void update_superblock_record(struct wb_device *wb)
+{
+	int r = 0;
+
+	struct superblock_record_device o;
+	void *buf;
+	struct dm_io_request io_req;
+	struct dm_io_region region;
+
+	o.last_migrated_segment_id =
+		cpu_to_le64(atomic64_read(&wb->last_migrated_segment_id));
+
+	buf = mempool_alloc(wb->buf_1_pool, GFP_NOIO | __GFP_ZERO);
+	memcpy(buf, &o, sizeof(o));
+
+	io_req = (struct dm_io_request) {
+		.client = wb_io_client,
+		.bi_rw = WRITE_FUA,
+		.notify.fn = NULL,
+		.mem.type = DM_IO_KMEM,
+		.mem.ptr.addr = buf,
+	};
+	region = (struct dm_io_region) {
+		.bdev = wb->cache_dev->bdev,
+		.sector = (1 << 11) - 1,
+		.count = 1,
+	};
+	IO(dm_safe_io(&io_req, 1, &region, NULL, false));
+
+	mempool_free(buf, wb->buf_1_pool);
+}
+
+int recorder_proc(void *data)
+{
+	struct wb_device *wb = data;
+
+	unsigned long intvl;
+
+	while (!kthread_should_stop()) {
+		/* sec -> ms */
+		intvl = ACCESS_ONCE(wb->update_record_interval) * 1000;
+
+		if (!intvl) {
+			schedule_timeout_interruptible(msecs_to_jiffies(1000));
+			continue;
+		}
+
+		update_superblock_record(wb);
+		schedule_timeout_interruptible(msecs_to_jiffies(intvl));
+	}
+	return 0;
+}
+
+/*----------------------------------------------------------------*/
+
+int sync_proc(void *data)
+{
+	int r = 0;
+
+	struct wb_device *wb = data;
+	unsigned long intvl;
+
+	while (!kthread_should_stop()) {
+		/* sec -> ms */
+		intvl = ACCESS_ONCE(wb->sync_interval) * 1000;
+
+		if (!intvl) {
+			schedule_timeout_interruptible(msecs_to_jiffies(1000));
+			continue;
+		}
+
+		flush_current_buffer(wb);
+		IO(blkdev_issue_flush(wb->cache_dev->bdev, GFP_NOIO, NULL));
+		schedule_timeout_interruptible(msecs_to_jiffies(intvl));
+	}
+	return 0;
+}
diff --git a/drivers/md/dm-writeboost-daemon.h b/drivers/md/dm-writeboost-daemon.h
new file mode 100644
index 0000000..7e913db
--- /dev/null
+++ b/drivers/md/dm-writeboost-daemon.h
@@ -0,0 +1,40 @@
+/*
+ * Copyright (C) 2012-2014 Akira Hayakawa <ruby.wktk@gmail.com>
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef DM_WRITEBOOST_DAEMON_H
+#define DM_WRITEBOOST_DAEMON_H
+
+/*----------------------------------------------------------------*/
+
+void flush_proc(struct work_struct *);
+void wait_for_flushing(struct wb_device *, u64 id);
+
+/*----------------------------------------------------------------*/
+
+void queue_barrier_io(struct wb_device *, struct bio *);
+void barrier_deadline_proc(unsigned long data);
+void flush_barrier_ios(struct work_struct *);
+
+/*----------------------------------------------------------------*/
+
+int migrate_proc(void *);
+void wait_for_migration(struct wb_device *, u64 id);
+
+/*----------------------------------------------------------------*/
+
+int modulator_proc(void *);
+
+/*----------------------------------------------------------------*/
+
+int sync_proc(void *);
+
+/*----------------------------------------------------------------*/
+
+int recorder_proc(void *);
+
+/*----------------------------------------------------------------*/
+
+#endif
diff --git a/drivers/md/dm-writeboost-metadata.c b/drivers/md/dm-writeboost-metadata.c
new file mode 100644
index 0000000..54a94f5
--- /dev/null
+++ b/drivers/md/dm-writeboost-metadata.c
@@ -0,0 +1,1352 @@
+/*
+ * Copyright (C) 2012-2014 Akira Hayakawa <ruby.wktk@gmail.com>
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm-writeboost.h"
+#include "dm-writeboost-metadata.h"
+#include "dm-writeboost-daemon.h"
+
+#include <linux/crc32c.h>
+
+/*----------------------------------------------------------------*/
+
+struct part {
+	void *memory;
+};
+
+struct large_array {
+	struct part *parts;
+	u64 nr_elems;
+	u32 elemsize;
+};
+
+#define ALLOC_SIZE (1 << 16)
+static u32 nr_elems_in_part(struct large_array *arr)
+{
+	return div_u64(ALLOC_SIZE, arr->elemsize);
+};
+
+static u64 nr_parts(struct large_array *arr)
+{
+	u64 a = arr->nr_elems;
+	u32 b = nr_elems_in_part(arr);
+	return div_u64(a + b - 1, b);
+}
+
+static struct large_array *large_array_alloc(u32 elemsize, u64 nr_elems)
+{
+	u64 i;
+
+	struct large_array *arr = kmalloc(sizeof(*arr), GFP_KERNEL);
+	if (!arr) {
+		WBERR("failed to allocate arr");
+		return NULL;
+	}
+
+	arr->elemsize = elemsize;
+	arr->nr_elems = nr_elems;
+	arr->parts = kmalloc(sizeof(struct part) * nr_parts(arr), GFP_KERNEL);
+	if (!arr->parts) {
+		WBERR("failed to allocate parts");
+		goto bad_alloc_parts;
+	}
+
+	for (i = 0; i < nr_parts(arr); i++) {
+		struct part *part = arr->parts + i;
+		part->memory = kmalloc(ALLOC_SIZE, GFP_KERNEL);
+		if (!part->memory) {
+			u8 j;
+
+			WBERR("failed to allocate part memory");
+			for (j = 0; j < i; j++) {
+				part = arr->parts + j;
+				kfree(part->memory);
+			}
+			goto bad_alloc_parts_memory;
+		}
+	}
+	return arr;
+
+bad_alloc_parts_memory:
+	kfree(arr->parts);
+bad_alloc_parts:
+	kfree(arr);
+	return NULL;
+}
+
+static void large_array_free(struct large_array *arr)
+{
+	size_t i;
+	for (i = 0; i < nr_parts(arr); i++) {
+		struct part *part = arr->parts + i;
+		kfree(part->memory);
+	}
+	kfree(arr->parts);
+	kfree(arr);
+}
+
+static void *large_array_at(struct large_array *arr, u64 i)
+{
+	u32 n = nr_elems_in_part(arr);
+	u32 k;
+	u64 j = div_u64_rem(i, n, &k);
+	struct part *part = arr->parts + j;
+	return part->memory + (arr->elemsize * k);
+}
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Get the in-core metablock of the given index.
+ */
+static struct metablock *mb_at(struct wb_device *wb, u32 idx)
+{
+	u32 idx_inseg;
+	u32 seg_idx = div_u64_rem(idx, wb->nr_caches_inseg, &idx_inseg);
+	struct segment_header *seg =
+		large_array_at(wb->segment_header_array, seg_idx);
+	return seg->mb_array + idx_inseg;
+}
+
+static void mb_array_empty_init(struct wb_device *wb)
+{
+	u32 i;
+	for (i = 0; i < wb->nr_caches; i++) {
+		struct metablock *mb = mb_at(wb, i);
+		INIT_HLIST_NODE(&mb->ht_list);
+
+		mb->idx = i;
+		mb->dirty_bits = 0;
+	}
+}
+
+/*
+ * Calc the starting sector of the k-th segment
+ */
+static sector_t calc_segment_header_start(struct wb_device *wb, u32 k)
+{
+	return (1 << 11) + (1 << wb->segment_size_order) * k;
+}
+
+static u32 calc_nr_segments(struct dm_dev *dev, struct wb_device *wb)
+{
+	sector_t devsize = dm_devsize(dev);
+	return div_u64(devsize - (1 << 11), 1 << wb->segment_size_order);
+}
+
+/*
+ * Get the relative index in a segment of the mb_idx-th metablock
+ */
+u32 mb_idx_inseg(struct wb_device *wb, u32 mb_idx)
+{
+	u32 tmp32;
+	div_u64_rem(mb_idx, wb->nr_caches_inseg, &tmp32);
+	return tmp32;
+}
+
+/*
+ * Calc the starting sector of the mb_idx-th cache block
+ */
+sector_t calc_mb_start_sector(struct wb_device *wb, struct segment_header *seg, u32 mb_idx)
+{
+	return seg->start_sector + ((1 + mb_idx_inseg(wb, mb_idx)) << 3);
+}
+
+/*
+ * Get the segment that contains the passed mb
+ */
+struct segment_header *mb_to_seg(struct wb_device *wb, struct metablock *mb)
+{
+	struct segment_header *seg;
+	seg = ((void *) mb)
+	      - mb_idx_inseg(wb, mb->idx) * sizeof(struct metablock)
+	      - sizeof(struct segment_header);
+	return seg;
+}
+
+bool is_on_buffer(struct wb_device *wb, u32 mb_idx)
+{
+	u32 start = wb->current_seg->start_idx;
+	if (mb_idx < start)
+		return false;
+
+	if (mb_idx >= (start + wb->nr_caches_inseg))
+		return false;
+
+	return true;
+}
+
+static u32 segment_id_to_idx(struct wb_device *wb, u64 id)
+{
+	u32 idx;
+	div_u64_rem(id - 1, wb->nr_segments, &idx);
+	return idx;
+}
+
+static struct segment_header *segment_at(struct wb_device *wb, u32 k)
+{
+	return large_array_at(wb->segment_header_array, k);
+}
+
+/*
+ * Get the segment from the segment id.
+ * The Index of the segment is calculated from the segment id.
+ */
+struct segment_header *
+get_segment_header_by_id(struct wb_device *wb, u64 id)
+{
+	return segment_at(wb, segment_id_to_idx(wb, id));
+}
+
+/*----------------------------------------------------------------*/
+
+static int __must_check init_segment_header_array(struct wb_device *wb)
+{
+	u32 segment_idx;
+
+	wb->segment_header_array = large_array_alloc(
+			sizeof(struct segment_header) +
+			sizeof(struct metablock) * wb->nr_caches_inseg,
+			wb->nr_segments);
+	if (!wb->segment_header_array) {
+		WBERR("failed to allocate segment header array");
+		return -ENOMEM;
+	}
+
+	for (segment_idx = 0; segment_idx < wb->nr_segments; segment_idx++) {
+		struct segment_header *seg = large_array_at(wb->segment_header_array, segment_idx);
+
+		seg->id = 0;
+		seg->length = 0;
+		atomic_set(&seg->nr_inflight_ios, 0);
+
+		/*
+		 * Const values
+		 */
+		seg->start_idx = wb->nr_caches_inseg * segment_idx;
+		seg->start_sector = calc_segment_header_start(wb, segment_idx);
+	}
+
+	mb_array_empty_init(wb);
+
+	return 0;
+}
+
+static void free_segment_header_array(struct wb_device *wb)
+{
+	large_array_free(wb->segment_header_array);
+}
+
+/*----------------------------------------------------------------*/
+
+struct ht_head {
+	struct hlist_head ht_list;
+};
+
+/*
+ * Initialize the Hash Table.
+ */
+static int __must_check ht_empty_init(struct wb_device *wb)
+{
+	u32 idx;
+	size_t i, nr_heads;
+	struct large_array *arr;
+
+	wb->htsize = wb->nr_caches;
+	nr_heads = wb->htsize + 1;
+	arr = large_array_alloc(sizeof(struct ht_head), nr_heads);
+	if (!arr) {
+		WBERR("failed to allocate arr");
+		return -ENOMEM;
+	}
+
+	wb->htable = arr;
+
+	for (i = 0; i < nr_heads; i++) {
+		struct ht_head *hd = large_array_at(arr, i);
+		INIT_HLIST_HEAD(&hd->ht_list);
+	}
+
+	/*
+	 * Our hashtable has one special bucket called null head.
+	 * Orphan metablocks are linked to the null head.
+	 */
+	wb->null_head = large_array_at(wb->htable, wb->htsize);
+
+	for (idx = 0; idx < wb->nr_caches; idx++) {
+		struct metablock *mb = mb_at(wb, idx);
+		hlist_add_head(&mb->ht_list, &wb->null_head->ht_list);
+	}
+
+	return 0;
+}
+
+static void free_ht(struct wb_device *wb)
+{
+	large_array_free(wb->htable);
+}
+
+struct ht_head *ht_get_head(struct wb_device *wb, struct lookup_key *key)
+{
+	u32 idx;
+	div_u64_rem(key->sector, wb->htsize, &idx);
+	return large_array_at(wb->htable, idx);
+}
+
+static bool mb_hit(struct metablock *mb, struct lookup_key *key)
+{
+	return mb->sector == key->sector;
+}
+
+/*
+ * Remove the metablock from the hashtable
+ * and link the orphan to the null head.
+ */
+void ht_del(struct wb_device *wb, struct metablock *mb)
+{
+	struct ht_head *null_head;
+
+	hlist_del(&mb->ht_list);
+
+	null_head = wb->null_head;
+	hlist_add_head(&mb->ht_list, &null_head->ht_list);
+}
+
+void ht_register(struct wb_device *wb, struct ht_head *head,
+		 struct metablock *mb, struct lookup_key *key)
+{
+	hlist_del(&mb->ht_list);
+	hlist_add_head(&mb->ht_list, &head->ht_list);
+
+	mb->sector = key->sector;
+};
+
+struct metablock *ht_lookup(struct wb_device *wb, struct ht_head *head,
+			    struct lookup_key *key)
+{
+	struct metablock *mb, *found = NULL;
+	hlist_for_each_entry(mb, &head->ht_list, ht_list) {
+		if (mb_hit(mb, key)) {
+			found = mb;
+			break;
+		}
+	}
+	return found;
+}
+
+/*
+ * Remove all the metablock in the segment from the lookup table.
+ */
+void discard_caches_inseg(struct wb_device *wb, struct segment_header *seg)
+{
+	u8 i;
+	for (i = 0; i < wb->nr_caches_inseg; i++) {
+		struct metablock *mb = seg->mb_array + i;
+		ht_del(wb, mb);
+	}
+}
+
+/*----------------------------------------------------------------*/
+
+static int read_superblock_header(struct superblock_header_device *sup,
+				  struct wb_device *wb)
+{
+	int r = 0;
+	struct dm_io_request io_req_sup;
+	struct dm_io_region region_sup;
+
+	void *buf = kmalloc(1 << SECTOR_SHIFT, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	io_req_sup = (struct dm_io_request) {
+		.client = wb_io_client,
+		.bi_rw = READ,
+		.notify.fn = NULL,
+		.mem.type = DM_IO_KMEM,
+		.mem.ptr.addr = buf,
+	};
+	region_sup = (struct dm_io_region) {
+		.bdev = wb->cache_dev->bdev,
+		.sector = 0,
+		.count = 1,
+	};
+	r = dm_safe_io(&io_req_sup, 1, &region_sup, NULL, false);
+	if (r) {
+		WBERR("I/O failed");
+		goto bad_io;
+	}
+
+	memcpy(sup, buf, sizeof(*sup));
+
+bad_io:
+	kfree(buf);
+	return r;
+}
+
+/*
+ * Check if the cache device is already formatted.
+ * Returns 0 iff this routine runs without failure.
+ */
+static int __must_check
+audit_cache_device(struct wb_device *wb, bool *need_format, bool *allow_format)
+{
+	int r = 0;
+	struct superblock_header_device sup;
+	r = read_superblock_header(&sup, wb);
+	if (r) {
+		WBERR("failed to read superblock header");
+		return r;
+	}
+
+	*need_format = true;
+	*allow_format = false;
+
+	if (le32_to_cpu(sup.magic) != WB_MAGIC) {
+		*allow_format = true;
+		WBERR("superblock header: magic number invalid");
+		return 0;
+	}
+
+	if (sup.segment_size_order != wb->segment_size_order) {
+		WBERR("superblock header: segment order not same %u != %u",
+		      sup.segment_size_order, wb->segment_size_order);
+	} else {
+		*need_format = false;
+	}
+
+	return r;
+}
+
+static int format_superblock_header(struct wb_device *wb)
+{
+	int r = 0;
+
+	struct dm_io_request io_req_sup;
+	struct dm_io_region region_sup;
+
+	struct superblock_header_device sup = {
+		.magic = cpu_to_le32(WB_MAGIC),
+		.segment_size_order = wb->segment_size_order,
+	};
+
+	void *buf = kzalloc(1 << SECTOR_SHIFT, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	memcpy(buf, &sup, sizeof(sup));
+
+	io_req_sup = (struct dm_io_request) {
+		.client = wb_io_client,
+		.bi_rw = WRITE_FUA,
+		.notify.fn = NULL,
+		.mem.type = DM_IO_KMEM,
+		.mem.ptr.addr = buf,
+	};
+	region_sup = (struct dm_io_region) {
+		.bdev = wb->cache_dev->bdev,
+		.sector = 0,
+		.count = 1,
+	};
+	r = dm_safe_io(&io_req_sup, 1, &region_sup, NULL, false);
+	if (r) {
+		WBERR("I/O failed");
+		goto bad_io;
+	}
+
+bad_io:
+	kfree(buf);
+	return 0;
+}
+
+struct format_segmd_context {
+	int err;
+	atomic64_t count;
+};
+
+static void format_segmd_endio(unsigned long error, void *__context)
+{
+	struct format_segmd_context *context = __context;
+	if (error)
+		context->err = 1;
+	atomic64_dec(&context->count);
+}
+
+static int zeroing_full_superblock(struct wb_device *wb)
+{
+	int r = 0;
+	struct dm_dev *dev = wb->cache_dev;
+
+	struct dm_io_request io_req_sup;
+	struct dm_io_region region_sup;
+
+	void *buf = kzalloc(1 << 20, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	io_req_sup = (struct dm_io_request) {
+		.client = wb_io_client,
+		.bi_rw = WRITE_FUA,
+		.notify.fn = NULL,
+		.mem.type = DM_IO_KMEM,
+		.mem.ptr.addr = buf,
+	};
+	region_sup = (struct dm_io_region) {
+		.bdev = dev->bdev,
+		.sector = 0,
+		.count = (1 << 11),
+	};
+	r = dm_safe_io(&io_req_sup, 1, &region_sup, NULL, false);
+	if (r) {
+		WBERR("I/O failed");
+		goto bad_io;
+	}
+
+bad_io:
+	kfree(buf);
+	return r;
+}
+
+static int format_all_segment_headers(struct wb_device *wb)
+{
+	int r = 0;
+	struct dm_dev *dev = wb->cache_dev;
+	u32 i, nr_segments = calc_nr_segments(dev, wb);
+
+	struct format_segmd_context context;
+
+	void *buf = kzalloc(1 << 12, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	atomic64_set(&context.count, nr_segments);
+	context.err = 0;
+
+	/*
+	 * Submit all the writes asynchronously.
+	 */
+	for (i = 0; i < nr_segments; i++) {
+		struct dm_io_request io_req_seg = {
+			.client = wb_io_client,
+			.bi_rw = WRITE,
+			.notify.fn = format_segmd_endio,
+			.notify.context = &context,
+			.mem.type = DM_IO_KMEM,
+			.mem.ptr.addr = buf,
+		};
+		struct dm_io_region region_seg = {
+			.bdev = dev->bdev,
+			.sector = calc_segment_header_start(wb, i),
+			.count = (1 << 3),
+		};
+		r = dm_safe_io(&io_req_seg, 1, &region_seg, NULL, false);
+		if (r) {
+			WBERR("I/O failed");
+			break;
+		}
+	}
+	kfree(buf);
+
+	if (r)
+		return r;
+
+	/*
+	 * Wait for all the writes complete.
+	 */
+	while (atomic64_read(&context.count))
+		schedule_timeout_interruptible(msecs_to_jiffies(100));
+
+	if (context.err) {
+		WBERR("I/O failed at last");
+		return -EIO;
+	}
+
+	return r;
+}
+
+/*
+ * Format superblock header and
+ * all the segment headers in a cache device
+ */
+static int __must_check format_cache_device(struct wb_device *wb)
+{
+	int r = 0;
+	struct dm_dev *dev = wb->cache_dev;
+	r = zeroing_full_superblock(wb);
+	if (r)
+		return r;
+	r = format_superblock_header(wb); /* first 512B */
+	if (r)
+		return r;
+	r = format_all_segment_headers(wb);
+	if (r)
+		return r;
+	r = blkdev_issue_flush(dev->bdev, GFP_KERNEL, NULL);
+	return r;
+}
+
+/*
+ * First check if the superblock and the passed arguments
+ * are consistent and re-format the cache structure if they are not.
+ * If you want to re-format the cache device you must zeroed out
+ * the first one sector of the device.
+ *
+ * After this, the segment_size_order is fixed.
+ */
+static int might_format_cache_device(struct wb_device *wb)
+{
+	int r = 0;
+
+	bool need_format, allow_format;
+	r = audit_cache_device(wb, &need_format, &allow_format);
+	if (r) {
+		WBERR("failed to audit cache device");
+		return r;
+	}
+
+	if (need_format) {
+		if (allow_format) {
+			r = format_cache_device(wb);
+			if (r) {
+				WBERR("failed to format cache device");
+				return r;
+			}
+		} else {
+			r = -EINVAL;
+			WBERR("cache device not allowed to format");
+			return r;
+		}
+	}
+
+	return r;
+}
+
+/*----------------------------------------------------------------*/
+
+static int __must_check
+read_superblock_record(struct superblock_record_device *record,
+		       struct wb_device *wb)
+{
+	int r = 0;
+	struct dm_io_request io_req;
+	struct dm_io_region region;
+
+	void *buf = kmalloc(1 << SECTOR_SHIFT, GFP_KERNEL);
+	if (!buf) {
+		WBERR();
+		return -ENOMEM;
+	}
+
+	io_req = (struct dm_io_request) {
+		.client = wb_io_client,
+		.bi_rw = READ,
+		.notify.fn = NULL,
+		.mem.type = DM_IO_KMEM,
+		.mem.ptr.addr = buf,
+	};
+	region = (struct dm_io_region) {
+		.bdev = wb->cache_dev->bdev,
+		.sector = (1 << 11) - 1,
+		.count = 1,
+	};
+	r = dm_safe_io(&io_req, 1, &region, NULL, false);
+	if (r) {
+		WBERR("I/O failed");
+		goto bad_io;
+	}
+
+	memcpy(record, buf, sizeof(*record));
+
+bad_io:
+	kfree(buf);
+	return r;
+}
+
+/*
+ * Read whole segment on the cache device to a pre-allocated buffer.
+ */
+static int __must_check
+read_whole_segment(void *buf, struct wb_device *wb, struct segment_header *seg)
+{
+	struct dm_io_request io_req = {
+		.client = wb_io_client,
+		.bi_rw = READ,
+		.notify.fn = NULL,
+		.mem.type = DM_IO_KMEM,
+		.mem.ptr.addr = buf,
+	};
+	struct dm_io_region region = {
+		.bdev = wb->cache_dev->bdev,
+		.sector = seg->start_sector,
+		.count = 1 << wb->segment_size_order,
+	};
+	return dm_safe_io(&io_req, 1, &region, NULL, false);
+}
+
+/*
+ * We make a checksum of a segment from the valid data
+ * in a segment except the first 1 sector.
+ */
+static u32 calc_checksum(void *rambuffer, u8 length)
+{
+	unsigned int len = (4096 - 512) + 4096 * length;
+	return crc32c(WB_CKSUM_SEED, rambuffer + 512, len);
+}
+
+/*
+ * Complete metadata in a segment buffer.
+ */
+void prepare_segment_header_device(void *rambuffer,
+				   struct wb_device *wb,
+				   struct segment_header *src)
+{
+	struct segment_header_device *dest = rambuffer;
+	u32 i;
+
+	BUG_ON((src->length - 1) != mb_idx_inseg(wb, wb->cursor));
+
+	for (i = 0; i < src->length; i++) {
+		struct metablock *mb = src->mb_array + i;
+		struct metablock_device *mbdev = dest->mbarr + i;
+
+		mbdev->sector = cpu_to_le64(mb->sector);
+		mbdev->dirty_bits = mb->dirty_bits;
+	}
+
+	dest->id = cpu_to_le64(src->id);
+	dest->checksum = cpu_to_le32(calc_checksum(rambuffer, src->length));
+	dest->length = src->length;
+}
+
+static void
+apply_metablock_device(struct wb_device *wb, struct segment_header *seg,
+		       struct segment_header_device *src, u8 i)
+{
+	struct lookup_key key;
+	struct ht_head *head;
+	struct metablock *found = NULL, *mb = seg->mb_array + i;
+	struct metablock_device *mbdev = src->mbarr + i;
+
+	mb->sector = le64_to_cpu(mbdev->sector);
+	mb->dirty_bits = mbdev->dirty_bits;
+
+	/*
+	 * A metablock is usually dirty but the exception is that
+	 * the one inserted by force flush.
+	 * In that case, the first metablock in a segment is clean.
+	 */
+	if (!mb->dirty_bits)
+		return;
+
+	key = (struct lookup_key) {
+		.sector = mb->sector,
+	};
+	head = ht_get_head(wb, &key);
+	found = ht_lookup(wb, head, &key);
+	if (found) {
+		bool overwrite_fullsize = (mb->dirty_bits == 255);
+		invalidate_previous_cache(wb, mb_to_seg(wb, found), found,
+					  overwrite_fullsize);
+	}
+
+	inc_nr_dirty_caches(wb);
+	ht_register(wb, head, mb, &key);
+}
+
+/*
+ * Read the on-disk metadata of the segment and
+ * update the in-core cache metadata structure.
+ */
+static void
+apply_segment_header_device(struct wb_device *wb, struct segment_header *seg,
+			    struct segment_header_device *src)
+{
+	u8 i;
+
+	seg->length = src->length;
+
+	for (i = 0; i < src->length; i++)
+		apply_metablock_device(wb, seg, src, i);
+}
+
+/*
+ * If the RAM buffer is non-volatile
+ * we first write back all the valid buffers on them.
+ * By doing this, the discussion on replay algorithm is closed
+ * in replaying logs on only cache device.
+ */
+static int writeback_non_volatile_buffers(struct wb_device *wb)
+{
+	return 0;
+}
+
+static int find_max_id(struct wb_device *wb, u64 *max_id)
+{
+	int r = 0;
+
+	void *rambuf = kmalloc(1 << (wb->segment_size_order + SECTOR_SHIFT),
+			       GFP_KERNEL);
+	u32 k;
+
+	*max_id = 0;
+	for (k = 0; k < wb->nr_segments; k++) {
+		struct segment_header *seg = segment_at(wb, k);
+		struct segment_header_device *header;
+		r = read_whole_segment(rambuf, wb, seg);
+		if (r) {
+			kfree(rambuf);
+			return r;
+		}
+
+		header = rambuf;
+		if (le64_to_cpu(header->id) > *max_id)
+			*max_id = le64_to_cpu(header->id);
+	}
+	kfree(rambuf);
+	return r;
+}
+
+static int apply_valid_segments(struct wb_device *wb, u64 *max_id)
+{
+	int r = 0;
+	struct segment_header *seg;
+	struct segment_header_device *header;
+
+	void *rambuf = kmalloc(1 << (wb->segment_size_order + SECTOR_SHIFT),
+			       GFP_KERNEL);
+
+	u32 i, start_idx = segment_id_to_idx(wb, *max_id + 1);
+	*max_id = 0;
+	for (i = start_idx; i < (start_idx + wb->nr_segments); i++) {
+		u32 checksum1, checksum2, k;
+		div_u64_rem(i, wb->nr_segments, &k);
+		seg = segment_at(wb, k);
+
+		r = read_whole_segment(rambuf, wb, seg);
+		if (r) {
+			kfree(rambuf);
+			return r;
+		}
+
+		header = rambuf;
+
+		if (!le64_to_cpu(header->id))
+			continue;
+
+		checksum1 = le32_to_cpu(header->checksum);
+		checksum2 = calc_checksum(rambuf, header->length);
+		if (checksum1 != checksum2) {
+			DMWARN("checksum inconsistent id:%llu checksum:%u != %u",
+			       (long long unsigned int) le64_to_cpu(header->id),
+			       checksum1, checksum2);
+			continue;
+		}
+
+		apply_segment_header_device(wb, seg, header);
+		*max_id = le64_to_cpu(header->id);
+	}
+	kfree(rambuf);
+	return r;
+}
+
+static int infer_last_migrated_id(struct wb_device *wb)
+{
+	int r = 0;
+
+	u64 record_id;
+	struct superblock_record_device uninitialized_var(record);
+	r = read_superblock_record(&record, wb);
+	if (r)
+		return r;
+
+	atomic64_set(&wb->last_migrated_segment_id,
+		atomic64_read(&wb->last_flushed_segment_id) > wb->nr_segments ?
+		atomic64_read(&wb->last_flushed_segment_id) - wb->nr_segments : 0);
+
+	record_id = le64_to_cpu(record.last_migrated_segment_id);
+	if (record_id > atomic64_read(&wb->last_migrated_segment_id))
+		atomic64_set(&wb->last_migrated_segment_id, record_id);
+
+	return r;
+}
+
+/*
+ * Replay all the log on the cache device to reconstruct
+ * the in-memory metadata.
+ *
+ * Algorithm:
+ * 1. find the maxium id
+ * 2. start from the right. iterate all the log.
+ * 2. skip if id=0 or checkum invalid
+ * 2. apply otherwise.
+ *
+ * This algorithm is robust for floppy SSD that may write
+ * a segment partially or lose data on its buffer on power fault.
+ *
+ * Even if number of threads flush segments in parallel and
+ * some of them loses atomicity because of power fault
+ * this robust algorithm works.
+ */
+static int replay_log_on_cache(struct wb_device *wb)
+{
+	int r = 0;
+	u64 max_id;
+
+	r = find_max_id(wb, &max_id);
+	if (r) {
+		WBERR("failed to find max id");
+		return r;
+	}
+	r = apply_valid_segments(wb, &max_id);
+	if (r) {
+		WBERR("failed to apply valid segments");
+		return r;
+	}
+
+	/*
+	 * Setup last_flushed_segment_id
+	 */
+	atomic64_set(&wb->last_flushed_segment_id, max_id);
+
+	/*
+	 * Setup last_migrated_segment_id
+	 */
+	infer_last_migrated_id(wb);
+
+	return r;
+}
+
+/*
+ * Acquire and initialize the first segment header for our caching.
+ */
+static void prepare_first_seg(struct wb_device *wb)
+{
+	u64 init_segment_id = atomic64_read(&wb->last_flushed_segment_id) + 1;
+	acquire_new_seg(wb, init_segment_id);
+
+	/*
+	 * We always keep the intergrity between cursor
+	 * and seg->length.
+	 */
+	wb->cursor = wb->current_seg->start_idx;
+	wb->current_seg->length = 1;
+}
+
+/*
+ * Recover all the cache state from the
+ * persistent devices (non-volatile RAM and SSD).
+ */
+static int __must_check recover_cache(struct wb_device *wb)
+{
+	int r = 0;
+
+	r = writeback_non_volatile_buffers(wb);
+	if (r) {
+		WBERR("failed to write back all the persistent data on non-volatile RAM");
+		return r;
+	}
+
+	r = replay_log_on_cache(wb);
+	if (r) {
+		WBERR("failed to replay log");
+		return r;
+	}
+
+	prepare_first_seg(wb);
+	return 0;
+}
+
+/*----------------------------------------------------------------*/
+
+static int __must_check init_rambuf_pool(struct wb_device *wb)
+{
+	size_t i;
+	sector_t alloc_sz = 1 << wb->segment_size_order;
+	u32 nr = div_u64(wb->rambuf_pool_amount * 2, alloc_sz);
+
+	if (!nr)
+		return -EINVAL;
+
+	wb->nr_rambuf_pool = nr;
+	wb->rambuf_pool = kmalloc(sizeof(struct rambuffer) * nr,
+				  GFP_KERNEL);
+	if (!wb->rambuf_pool)
+		return -ENOMEM;
+
+	for (i = 0; i < wb->nr_rambuf_pool; i++) {
+		size_t j;
+		struct rambuffer *rambuf = wb->rambuf_pool + i;
+
+		rambuf->data = kmalloc(alloc_sz << SECTOR_SHIFT, GFP_KERNEL);
+		if (!rambuf->data) {
+			WBERR("failed to allocate rambuf data");
+			for (j = 0; j < i; j++) {
+				rambuf = wb->rambuf_pool + j;
+				kfree(rambuf->data);
+			}
+			kfree(wb->rambuf_pool);
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
+static void free_rambuf_pool(struct wb_device *wb)
+{
+	size_t i;
+	for (i = 0; i < wb->nr_rambuf_pool; i++) {
+		struct rambuffer *rambuf = wb->rambuf_pool + i;
+		kfree(rambuf->data);
+	}
+	kfree(wb->rambuf_pool);
+}
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Try to allocate new migration buffer by the nr_batch size.
+ * On success, it frees the old buffer.
+ *
+ * Bad User may set # of batches that can hardly allocate.
+ * This function is robust in that case.
+ */
+int try_alloc_migration_buffer(struct wb_device *wb, size_t nr_batch)
+{
+	int r = 0;
+
+	struct segment_header **emigrates;
+	void *buf;
+	void *snapshot;
+
+	emigrates = kmalloc(nr_batch * sizeof(struct segment_header *), GFP_KERNEL);
+	if (!emigrates) {
+		WBERR("failed to allocate emigrates");
+		r = -ENOMEM;
+		return r;
+	}
+
+	buf = vmalloc(nr_batch * (wb->nr_caches_inseg << 12));
+	if (!buf) {
+		WBERR("failed to allocate migration buffer");
+		r = -ENOMEM;
+		goto bad_alloc_buffer;
+	}
+
+	snapshot = kmalloc(nr_batch * wb->nr_caches_inseg, GFP_KERNEL);
+	if (!snapshot) {
+		WBERR("failed to allocate dirty snapshot");
+		r = -ENOMEM;
+		goto bad_alloc_snapshot;
+	}
+
+	/*
+	 * Free old buffers
+	 */
+	kfree(wb->emigrates); /* kfree(NULL) is safe */
+	if (wb->migrate_buffer)
+		vfree(wb->migrate_buffer);
+	kfree(wb->dirtiness_snapshot);
+
+	/*
+	 * Swap by new values
+	 */
+	wb->emigrates = emigrates;
+	wb->migrate_buffer = buf;
+	wb->dirtiness_snapshot = snapshot;
+	wb->nr_cur_batched_migration = nr_batch;
+
+	return r;
+
+bad_alloc_buffer:
+	kfree(wb->emigrates);
+bad_alloc_snapshot:
+	vfree(wb->migrate_buffer);
+
+	return r;
+}
+
+static void free_migration_buffer(struct wb_device *wb)
+{
+	kfree(wb->emigrates);
+	vfree(wb->migrate_buffer);
+	kfree(wb->dirtiness_snapshot);
+}
+
+/*----------------------------------------------------------------*/
+
+#define CREATE_DAEMON(name) \
+	do { \
+		wb->name##_daemon = kthread_create( \
+				name##_proc, wb,  #name "_daemon"); \
+		if (IS_ERR(wb->name##_daemon)) { \
+			r = PTR_ERR(wb->name##_daemon); \
+			wb->name##_daemon = NULL; \
+			WBERR("couldn't spawn " #name " daemon"); \
+			goto bad_##name##_daemon; \
+		} \
+		wake_up_process(wb->name##_daemon); \
+	} while (0)
+
+/*
+ * Setup the core info relavant to the cache format or geometry.
+ */
+static void setup_geom_info(struct wb_device *wb)
+{
+	wb->nr_segments = calc_nr_segments(wb->cache_dev, wb);
+	wb->nr_caches_inseg = (1 << (wb->segment_size_order - 3)) - 1;
+	wb->nr_caches = wb->nr_segments * wb->nr_caches_inseg;
+}
+
+/*
+ * Harmless init
+ * - allocate memory
+ * - setup the initial state of the objects
+ */
+static int harmless_init(struct wb_device *wb)
+{
+	int r = 0;
+
+	setup_geom_info(wb);
+
+	wb->buf_1_pool = mempool_create_kmalloc_pool(16, 1 << SECTOR_SHIFT);
+	if (!wb->buf_1_pool) {
+		r = -ENOMEM;
+		WBERR("failed to allocate 1 sector pool");
+		goto bad_buf_1_pool;
+	}
+	wb->buf_8_pool = mempool_create_kmalloc_pool(16, 8 << SECTOR_SHIFT);
+	if (!wb->buf_8_pool) {
+		r = -ENOMEM;
+		WBERR("failed to allocate 8 sector pool");
+		goto bad_buf_8_pool;
+	}
+
+	r = init_rambuf_pool(wb);
+	if (r) {
+		WBERR("failed to allocate rambuf pool");
+		goto bad_init_rambuf_pool;
+	}
+	wb->flush_job_pool = mempool_create_kmalloc_pool(
+				wb->nr_rambuf_pool, sizeof(struct flush_job));
+	if (!wb->flush_job_pool) {
+		r = -ENOMEM;
+		WBERR("failed to allocate flush job pool");
+		goto bad_flush_job_pool;
+	}
+
+	r = init_segment_header_array(wb);
+	if (r) {
+		WBERR("failed to allocate segment header array");
+		goto bad_alloc_segment_header_array;
+	}
+
+	r = ht_empty_init(wb);
+	if (r) {
+		WBERR("failed to allocate hashtable");
+		goto bad_alloc_ht;
+	}
+
+	return r;
+
+bad_alloc_ht:
+	free_segment_header_array(wb);
+bad_alloc_segment_header_array:
+	mempool_destroy(wb->flush_job_pool);
+bad_flush_job_pool:
+	free_rambuf_pool(wb);
+bad_init_rambuf_pool:
+	mempool_destroy(wb->buf_8_pool);
+bad_buf_8_pool:
+	mempool_destroy(wb->buf_1_pool);
+bad_buf_1_pool:
+
+	return r;
+}
+
+static void harmless_free(struct wb_device *wb)
+{
+	free_ht(wb);
+	free_segment_header_array(wb);
+	mempool_destroy(wb->flush_job_pool);
+	free_rambuf_pool(wb);
+	mempool_destroy(wb->buf_8_pool);
+	mempool_destroy(wb->buf_1_pool);
+}
+
+static int init_migrate_daemon(struct wb_device *wb)
+{
+	int r = 0;
+	size_t nr_batch;
+
+	atomic_set(&wb->migrate_fail_count, 0);
+	atomic_set(&wb->migrate_io_count, 0);
+
+	/*
+	 * Default number of batched migration is 1MB / segment size.
+	 * An ordinary HDD can afford at least 1MB/sec.
+	 */
+	nr_batch = 1 << (11 - wb->segment_size_order);
+	wb->nr_max_batched_migration = nr_batch;
+	if (try_alloc_migration_buffer(wb, nr_batch))
+		return -ENOMEM;
+
+	init_waitqueue_head(&wb->migrate_wait_queue);
+	init_waitqueue_head(&wb->wait_drop_caches);
+	init_waitqueue_head(&wb->migrate_io_wait_queue);
+
+	wb->allow_migrate = false;
+	wb->urge_migrate = false;
+	CREATE_DAEMON(migrate);
+
+	return r;
+
+bad_migrate_daemon:
+	free_migration_buffer(wb);
+	return r;
+}
+
+static int init_flusher(struct wb_device *wb)
+{
+	int r = 0;
+	wb->flusher_wq = alloc_workqueue(
+		"%s", WQ_MEM_RECLAIM | WQ_SYSFS, 1, "wbflusher");
+	if (!wb->flusher_wq) {
+		WBERR("failed to allocate wbflusher");
+		return -ENOMEM;
+	}
+	init_waitqueue_head(&wb->flush_wait_queue);
+	return r;
+}
+
+static void init_barrier_deadline_work(struct wb_device *wb)
+{
+	wb->barrier_deadline_ms = 3;
+	setup_timer(&wb->barrier_deadline_timer,
+		    barrier_deadline_proc, (unsigned long) wb);
+	bio_list_init(&wb->barrier_ios);
+	INIT_WORK(&wb->barrier_deadline_work, flush_barrier_ios);
+}
+
+static int init_migrate_modulator(struct wb_device *wb)
+{
+	int r = 0;
+	/*
+	 * EMC's textbook on storage system teaches us
+	 * storage should keep its load no more than 70%.
+	 */
+	wb->migrate_threshold = 70;
+	wb->enable_migration_modulator = true;
+	CREATE_DAEMON(modulator);
+	return r;
+
+bad_modulator_daemon:
+	return r;
+}
+
+static int init_recorder_daemon(struct wb_device *wb)
+{
+	int r = 0;
+	wb->update_record_interval = 60;
+	CREATE_DAEMON(recorder);
+	return r;
+
+bad_recorder_daemon:
+	return r;
+}
+
+static int init_sync_daemon(struct wb_device *wb)
+{
+	int r = 0;
+	wb->sync_interval = 60;
+	CREATE_DAEMON(sync);
+	return r;
+
+bad_sync_daemon:
+	return r;
+}
+
+int __must_check resume_cache(struct wb_device *wb)
+{
+	int r = 0;
+
+	r = might_format_cache_device(wb);
+	if (r)
+		goto bad_might_format_cache;
+	r = harmless_init(wb);
+	if (r)
+		goto bad_harmless_init;
+	r = init_migrate_daemon(wb);
+	if (r) {
+		WBERR("failed to init migrate daemon");
+		goto bad_migrate_daemon;
+	}
+	r = recover_cache(wb);
+	if (r) {
+		WBERR("failed to recover cache metadata");
+		goto bad_recover;
+	}
+	r = init_flusher(wb);
+	if (r) {
+		WBERR("failed to init wbflusher");
+		goto bad_flusher;
+	}
+	init_barrier_deadline_work(wb);
+	r = init_migrate_modulator(wb);
+	if (r) {
+		WBERR("failed to init migrate modulator");
+		goto bad_migrate_modulator;
+	}
+	r = init_recorder_daemon(wb);
+	if (r) {
+		WBERR("failed to init superblock recorder");
+		goto bad_recorder_daemon;
+	}
+	r = init_sync_daemon(wb);
+	if (r) {
+		WBERR("failed to init sync daemon");
+		goto bad_sync_daemon;
+	}
+
+	return r;
+
+bad_sync_daemon:
+	kthread_stop(wb->recorder_daemon);
+bad_recorder_daemon:
+	kthread_stop(wb->modulator_daemon);
+bad_migrate_modulator:
+	cancel_work_sync(&wb->barrier_deadline_work);
+	destroy_workqueue(wb->flusher_wq);
+bad_flusher:
+bad_recover:
+	kthread_stop(wb->migrate_daemon);
+	free_migration_buffer(wb);
+bad_migrate_daemon:
+	harmless_free(wb);
+bad_harmless_init:
+bad_might_format_cache:
+
+	return r;
+}
+
+void free_cache(struct wb_device *wb)
+{
+	/*
+	 * kthread_stop() wakes up the thread.
+	 * We don't need to wake them up in our code.
+	 */
+	kthread_stop(wb->sync_daemon);
+	kthread_stop(wb->recorder_daemon);
+	kthread_stop(wb->modulator_daemon);
+
+	cancel_work_sync(&wb->barrier_deadline_work);
+
+	destroy_workqueue(wb->flusher_wq);
+
+	kthread_stop(wb->migrate_daemon);
+	free_migration_buffer(wb);
+
+	harmless_free(wb);
+}
diff --git a/drivers/md/dm-writeboost-metadata.h b/drivers/md/dm-writeboost-metadata.h
new file mode 100644
index 0000000..860e4bf
--- /dev/null
+++ b/drivers/md/dm-writeboost-metadata.h
@@ -0,0 +1,51 @@
+/*
+ * Copyright (C) 2012-2014 Akira Hayakawa <ruby.wktk@gmail.com>
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef DM_WRITEBOOST_METADATA_H
+#define DM_WRITEBOOST_METADATA_H
+
+/*----------------------------------------------------------------*/
+
+struct segment_header *
+get_segment_header_by_id(struct wb_device *, u64 segment_id);
+sector_t calc_mb_start_sector(struct wb_device *, struct segment_header *,
+			      u32 mb_idx);
+u32 mb_idx_inseg(struct wb_device *, u32 mb_idx);
+struct segment_header *mb_to_seg(struct wb_device *, struct metablock *);
+bool is_on_buffer(struct wb_device *, u32 mb_idx);
+
+/*----------------------------------------------------------------*/
+
+struct lookup_key {
+	sector_t sector;
+};
+
+struct ht_head;
+struct ht_head *ht_get_head(struct wb_device *, struct lookup_key *);
+struct metablock *ht_lookup(struct wb_device *,
+			    struct ht_head *, struct lookup_key *);
+void ht_register(struct wb_device *, struct ht_head *,
+		 struct metablock *, struct lookup_key *);
+void ht_del(struct wb_device *, struct metablock *);
+void discard_caches_inseg(struct wb_device *, struct segment_header *);
+
+/*----------------------------------------------------------------*/
+
+void prepare_segment_header_device(void *rambuffer, struct wb_device *,
+				   struct segment_header *src);
+
+/*----------------------------------------------------------------*/
+
+int try_alloc_migration_buffer(struct wb_device *, size_t nr_batch);
+
+/*----------------------------------------------------------------*/
+
+int __must_check resume_cache(struct wb_device *);
+void free_cache(struct wb_device *);
+
+/*----------------------------------------------------------------*/
+
+#endif
diff --git a/drivers/md/dm-writeboost-target.c b/drivers/md/dm-writeboost-target.c
new file mode 100644
index 0000000..4cbf579
--- /dev/null
+++ b/drivers/md/dm-writeboost-target.c
@@ -0,0 +1,1258 @@
+/*
+ * Writeboost
+ * Log-structured Caching for Linux
+ *
+ * Copyright (C) 2012-2014 Akira Hayakawa <ruby.wktk@gmail.com>
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm-writeboost.h"
+#include "dm-writeboost-metadata.h"
+#include "dm-writeboost-daemon.h"
+
+/*----------------------------------------------------------------*/
+
+struct safe_io {
+	struct work_struct work;
+	int err;
+	unsigned long err_bits;
+	struct dm_io_request *io_req;
+	unsigned num_regions;
+	struct dm_io_region *regions;
+};
+
+static void safe_io_proc(struct work_struct *work)
+{
+	struct safe_io *io = container_of(work, struct safe_io, work);
+	io->err_bits = 0;
+	io->err = dm_io(io->io_req, io->num_regions, io->regions,
+			&io->err_bits);
+}
+
+int dm_safe_io_internal(struct wb_device *wb, struct dm_io_request *io_req,
+			unsigned num_regions, struct dm_io_region *regions,
+			unsigned long *err_bits, bool thread, const char *caller)
+{
+	int err = 0;
+
+	if (thread) {
+		struct safe_io io = {
+			.io_req = io_req,
+			.regions = regions,
+			.num_regions = num_regions,
+		};
+
+		INIT_WORK_ONSTACK(&io.work, safe_io_proc);
+
+		queue_work(safe_io_wq, &io.work);
+		flush_work(&io.work);
+
+		err = io.err;
+		if (err_bits)
+			*err_bits = io.err_bits;
+	} else {
+		err = dm_io(io_req, num_regions, regions, err_bits);
+	}
+
+	/*
+	 * err_bits can be NULL.
+	 */
+	if (err || (err_bits && *err_bits)) {
+		char buf[BDEVNAME_SIZE];
+		dev_t dev = regions->bdev->bd_dev;
+
+		unsigned long eb;
+		if (!err_bits)
+			eb = (~(unsigned long)0);
+		else
+			eb = *err_bits;
+
+		format_dev_t(buf, dev);
+		WBERR("%s() I/O error(%d), bits(%lu), dev(%s), sector(%llu), rw(%d)",
+		      caller, err, eb,
+		      buf, (unsigned long long) regions->sector, io_req->bi_rw);
+	}
+
+	return err;
+}
+
+sector_t dm_devsize(struct dm_dev *dev)
+{
+	return i_size_read(dev->bdev->bd_inode) >> SECTOR_SHIFT;
+}
+
+/*----------------------------------------------------------------*/
+
+static u8 count_dirty_caches_remained(struct segment_header *seg)
+{
+	u8 i, count = 0;
+	struct metablock *mb;
+	for (i = 0; i < seg->length; i++) {
+		mb = seg->mb_array + i;
+		if (mb->dirty_bits)
+			count++;
+	}
+	return count;
+}
+
+/*
+ * Prepare the kmalloc-ed RAM buffer for segment write.
+ *
+ * dm_io routine requires RAM buffer for its I/O buffer.
+ * Even if we uses non-volatile RAM we have to copy the
+ * data to the volatile buffer when we come to submit I/O.
+ */
+static void prepare_rambuffer(struct rambuffer *rambuf,
+			      struct wb_device *wb,
+			      struct segment_header *seg)
+{
+	prepare_segment_header_device(rambuf->data, wb, seg);
+}
+
+static void init_rambuffer(struct wb_device *wb)
+{
+	memset(wb->current_rambuf->data, 0, 1 << 12);
+}
+
+/*
+ * Acquire new RAM buffer for the new segment.
+ */
+static void acquire_new_rambuffer(struct wb_device *wb, u64 id)
+{
+	struct rambuffer *next_rambuf;
+	u32 tmp32;
+
+	wait_for_flushing(wb, SUB_ID(id, wb->nr_rambuf_pool));
+
+	div_u64_rem(id - 1, wb->nr_rambuf_pool, &tmp32);
+	next_rambuf = wb->rambuf_pool + tmp32;
+
+	wb->current_rambuf = next_rambuf;
+
+	init_rambuffer(wb);
+}
+
+/*
+ * Acquire the new segment and RAM buffer for the following writes.
+ * Gurantees all dirty caches in the segments are migrated and all metablocks
+ * in it are invalidated (linked to null head).
+ */
+void acquire_new_seg(struct wb_device *wb, u64 id)
+{
+	struct segment_header *new_seg = get_segment_header_by_id(wb, id);
+
+	/*
+	 * We wait for all requests to the new segment is consumed.
+	 * Mutex taken gurantees that no new I/O to this segment is coming in.
+	 */
+	size_t rep = 0;
+	while (atomic_read(&new_seg->nr_inflight_ios)) {
+		rep++;
+		if (rep == 1000)
+			WBWARN("too long to process all requests");
+		schedule_timeout_interruptible(msecs_to_jiffies(1));
+	}
+	BUG_ON(count_dirty_caches_remained(new_seg));
+
+	wait_for_migration(wb, SUB_ID(id, wb->nr_segments));
+
+	discard_caches_inseg(wb, new_seg);
+
+	/*
+	 * We must not set new id to the new segment before
+	 * all wait_* events are done since they uses those id for waiting.
+	 */
+	new_seg->id = id;
+	wb->current_seg = new_seg;
+
+	acquire_new_rambuffer(wb, id);
+}
+
+static void prepare_new_seg(struct wb_device *wb)
+{
+	u64 next_id = wb->current_seg->id + 1;
+	acquire_new_seg(wb, next_id);
+
+	/*
+	 * Set the cursor to the last of the flushed segment.
+	 */
+	wb->cursor = wb->current_seg->start_idx + (wb->nr_caches_inseg - 1);
+	wb->current_seg->length = 0;
+}
+
+static void
+copy_barrier_requests(struct flush_job *job, struct wb_device *wb)
+{
+	bio_list_init(&job->barrier_ios);
+	bio_list_merge(&job->barrier_ios, &wb->barrier_ios);
+	bio_list_init(&wb->barrier_ios);
+}
+
+static void init_flush_job(struct flush_job *job, struct wb_device *wb)
+{
+	job->wb = wb;
+	job->seg = wb->current_seg;
+	job->rambuf = wb->current_rambuf;
+
+	copy_barrier_requests(job, wb);
+}
+
+static void queue_flush_job(struct wb_device *wb)
+{
+	struct flush_job *job;
+	size_t rep = 0;
+
+	while (atomic_read(&wb->current_seg->nr_inflight_ios)) {
+		rep++;
+		if (rep == 1000)
+			WBWARN("too long to process all requests");
+		schedule_timeout_interruptible(msecs_to_jiffies(1));
+	}
+	prepare_rambuffer(wb->current_rambuf, wb, wb->current_seg);
+
+	job = mempool_alloc(wb->flush_job_pool, GFP_NOIO);
+	init_flush_job(job, wb);
+	INIT_WORK(&job->work, flush_proc);
+	queue_work(wb->flusher_wq, &job->work);
+}
+
+static void queue_current_buffer(struct wb_device *wb)
+{
+	queue_flush_job(wb);
+	prepare_new_seg(wb);
+}
+
+/*
+ * Flush out all the transient data at a moment but _NOT_ persistently.
+ * Clean up the writes before termination is an example of the usecase.
+ */
+void flush_current_buffer(struct wb_device *wb)
+{
+	struct segment_header *old_seg;
+
+	mutex_lock(&wb->io_lock);
+	old_seg = wb->current_seg;
+
+	queue_current_buffer(wb);
+
+	wb->cursor = wb->current_seg->start_idx;
+	wb->current_seg->length = 1;
+	mutex_unlock(&wb->io_lock);
+
+	wait_for_flushing(wb, old_seg->id);
+}
+
+/*----------------------------------------------------------------*/
+
+static void bio_remap(struct bio *bio, struct dm_dev *dev, sector_t sector)
+{
+	bio->bi_bdev = dev->bdev;
+	bio->bi_sector = sector;
+}
+
+static u8 io_offset(struct bio *bio)
+{
+	u32 tmp32;
+	div_u64_rem(bio->bi_sector, 1 << 3, &tmp32);
+	return tmp32;
+}
+
+static sector_t io_count(struct bio *bio)
+{
+	return bio->bi_size >> SECTOR_SHIFT;
+}
+
+static bool io_fullsize(struct bio *bio)
+{
+	return io_count(bio) == (1 << 3);
+}
+
+/*
+ * We use 4KB alignment address of original request the for the lookup key.
+ */
+static sector_t calc_cache_alignment(sector_t bio_sector)
+{
+	return div_u64(bio_sector, 1 << 3) * (1 << 3);
+}
+
+/*----------------------------------------------------------------*/
+
+static void inc_stat(struct wb_device *wb,
+		     int rw, bool found, bool on_buffer, bool fullsize)
+{
+	atomic64_t *v;
+
+	int i = 0;
+	if (rw)
+		i |= (1 << STAT_WRITE);
+	if (found)
+		i |= (1 << STAT_HIT);
+	if (on_buffer)
+		i |= (1 << STAT_ON_BUFFER);
+	if (fullsize)
+		i |= (1 << STAT_FULLSIZE);
+
+	v = &wb->stat[i];
+	atomic64_inc(v);
+}
+
+static void clear_stat(struct wb_device *wb)
+{
+	size_t i;
+	for (i = 0; i < STATLEN; i++) {
+		atomic64_t *v = &wb->stat[i];
+		atomic64_set(v, 0);
+	}
+}
+
+/*----------------------------------------------------------------*/
+
+void inc_nr_dirty_caches(struct wb_device *wb)
+{
+	BUG_ON(!wb);
+	atomic64_inc(&wb->nr_dirty_caches);
+}
+
+static void dec_nr_dirty_caches(struct wb_device *wb)
+{
+	BUG_ON(!wb);
+	if (atomic64_dec_and_test(&wb->nr_dirty_caches))
+		wake_up_interruptible(&wb->wait_drop_caches);
+}
+
+/*
+ * Increase the dirtiness of a metablock.
+ */
+static void taint_mb(struct wb_device *wb, struct segment_header *seg,
+		     struct metablock *mb, struct bio *bio)
+{
+	unsigned long flags;
+
+	bool was_clean = false;
+
+	spin_lock_irqsave(&wb->lock, flags);
+	if (!mb->dirty_bits) {
+		seg->length++;
+		BUG_ON(seg->length > wb->nr_caches_inseg);
+		was_clean = true;
+	}
+	if (likely(io_fullsize(bio))) {
+		mb->dirty_bits = 255;
+	} else {
+		u8 i;
+		u8 acc_bits = 0;
+		for (i = io_offset(bio); i < (io_offset(bio) + io_count(bio)); i++)
+			acc_bits += (1 << i);
+
+		mb->dirty_bits |= acc_bits;
+	}
+	BUG_ON(!io_count(bio));
+	BUG_ON(!mb->dirty_bits);
+	spin_unlock_irqrestore(&wb->lock, flags);
+
+	if (was_clean)
+		inc_nr_dirty_caches(wb);
+}
+
+void cleanup_mb_if_dirty(struct wb_device *wb, struct segment_header *seg,
+			 struct metablock *mb)
+{
+	unsigned long flags;
+
+	bool was_dirty = false;
+
+	spin_lock_irqsave(&wb->lock, flags);
+	if (mb->dirty_bits) {
+		mb->dirty_bits = 0;
+		was_dirty = true;
+	}
+	spin_unlock_irqrestore(&wb->lock, flags);
+
+	if (was_dirty)
+		dec_nr_dirty_caches(wb);
+}
+
+/*
+ * Read the dirtiness of a metablock at the moment.
+ *
+ * In fact, I don't know if we should have the read statement surrounded
+ * by spinlock. Why I do this is that I worry about reading the
+ * intermediate value (neither the value of before-write nor after-write).
+ * Intel CPU guarantees it but other CPU may not.
+ * If any other CPU guarantees it we can remove the spinlock held.
+ */
+u8 read_mb_dirtiness(struct wb_device *wb, struct segment_header *seg,
+		     struct metablock *mb)
+{
+	unsigned long flags;
+	u8 val;
+
+	spin_lock_irqsave(&wb->lock, flags);
+	val = mb->dirty_bits;
+	spin_unlock_irqrestore(&wb->lock, flags);
+
+	return val;
+}
+
+/*
+ * Migrate the caches in a metablock on the SSD (after flushed).
+ * The caches on the SSD are considered to be persistent so we need to
+ * write them back with WRITE_FUA flag.
+ */
+static void migrate_mb(struct wb_device *wb, struct segment_header *seg,
+		       struct metablock *mb, u8 dirty_bits, bool thread)
+{
+	int r = 0;
+
+	if (!dirty_bits)
+		return;
+
+	if (dirty_bits == 255) {
+		void *buf = mempool_alloc(wb->buf_8_pool, GFP_NOIO);
+		struct dm_io_request io_req_r, io_req_w;
+		struct dm_io_region region_r, region_w;
+
+		io_req_r = (struct dm_io_request) {
+			.client = wb_io_client,
+			.bi_rw = READ,
+			.notify.fn = NULL,
+			.mem.type = DM_IO_KMEM,
+			.mem.ptr.addr = buf,
+		};
+		region_r = (struct dm_io_region) {
+			.bdev = wb->cache_dev->bdev,
+			.sector = calc_mb_start_sector(wb, seg, mb->idx),
+			.count = (1 << 3),
+		};
+		IO(dm_safe_io(&io_req_r, 1, &region_r, NULL, thread));
+
+		io_req_w = (struct dm_io_request) {
+			.client = wb_io_client,
+			.bi_rw = WRITE_FUA,
+			.notify.fn = NULL,
+			.mem.type = DM_IO_KMEM,
+			.mem.ptr.addr = buf,
+		};
+		region_w = (struct dm_io_region) {
+			.bdev = wb->origin_dev->bdev,
+			.sector = mb->sector,
+			.count = (1 << 3),
+		};
+		IO(dm_safe_io(&io_req_w, 1, &region_w, NULL, thread));
+
+		mempool_free(buf, wb->buf_8_pool);
+	} else {
+		void *buf = mempool_alloc(wb->buf_1_pool, GFP_NOIO);
+		u8 i;
+		for (i = 0; i < 8; i++) {
+			struct dm_io_request io_req_r, io_req_w;
+			struct dm_io_region region_r, region_w;
+
+			bool bit_on = dirty_bits & (1 << i);
+			if (!bit_on)
+				continue;
+
+			io_req_r = (struct dm_io_request) {
+				.client = wb_io_client,
+				.bi_rw = READ,
+				.notify.fn = NULL,
+				.mem.type = DM_IO_KMEM,
+				.mem.ptr.addr = buf,
+			};
+			region_r = (struct dm_io_region) {
+				.bdev = wb->cache_dev->bdev,
+				.sector = calc_mb_start_sector(wb, seg, mb->idx) + i,
+				.count = 1,
+			};
+			IO(dm_safe_io(&io_req_r, 1, &region_r, NULL, thread));
+
+			io_req_w = (struct dm_io_request) {
+				.client = wb_io_client,
+				.bi_rw = WRITE_FUA,
+				.notify.fn = NULL,
+				.mem.type = DM_IO_KMEM,
+				.mem.ptr.addr = buf,
+			};
+			region_w = (struct dm_io_region) {
+				.bdev = wb->origin_dev->bdev,
+				.sector = mb->sector + i,
+				.count = 1,
+			};
+			IO(dm_safe_io(&io_req_w, 1, &region_w, NULL, thread));
+		}
+		mempool_free(buf, wb->buf_1_pool);
+	}
+}
+
+/*
+ * Migrate the caches on the RAM buffer.
+ * Calling this function is really rare so the code is not optimal.
+ *
+ * Since the caches are of either one of these two status
+ * - not flushed and thus not persistent (volatile buffer)
+ * - acked to barrier request before but it is also on the
+ *   non-volatile buffer (non-volatile buffer)
+ * there is no reason to write them back with FUA flag.
+ */
+static void migrate_buffered_mb(struct wb_device *wb,
+				struct metablock *mb, u8 dirty_bits)
+{
+	int r = 0;
+
+	sector_t offset = ((mb_idx_inseg(wb, mb->idx) + 1) << 3);
+	void *buf = mempool_alloc(wb->buf_1_pool, GFP_NOIO);
+
+	u8 i;
+	for (i = 0; i < 8; i++) {
+		struct dm_io_request io_req;
+		struct dm_io_region region;
+		void *src;
+		sector_t dest;
+
+		bool bit_on = dirty_bits & (1 << i);
+		if (!bit_on)
+			continue;
+
+		src = wb->current_rambuf->data +
+		      ((offset + i) << SECTOR_SHIFT);
+		memcpy(buf, src, 1 << SECTOR_SHIFT);
+
+		io_req = (struct dm_io_request) {
+			.client = wb_io_client,
+			.bi_rw = WRITE,
+			.notify.fn = NULL,
+			.mem.type = DM_IO_KMEM,
+			.mem.ptr.addr = buf,
+		};
+
+		dest = mb->sector + i;
+		region = (struct dm_io_region) {
+			.bdev = wb->origin_dev->bdev,
+			.sector = dest,
+			.count = 1,
+		};
+
+		IO(dm_safe_io(&io_req, 1, &region, NULL, true));
+	}
+	mempool_free(buf, wb->buf_1_pool);
+}
+
+void invalidate_previous_cache(struct wb_device *wb, struct segment_header *seg,
+			       struct metablock *old_mb, bool overwrite_fullsize)
+{
+	u8 dirty_bits = read_mb_dirtiness(wb, seg, old_mb);
+
+	/*
+	 * First clean up the previous cache and migrate the cache if needed.
+	 */
+	bool needs_cleanup_prev_cache =
+		!overwrite_fullsize || !(dirty_bits == 255);
+
+	/*
+	 * Migration works in background and may have cleaned up the metablock.
+	 * If the metablock is clean we need not to migrate.
+	 */
+	if (!dirty_bits)
+		needs_cleanup_prev_cache = false;
+
+	if (overwrite_fullsize)
+		needs_cleanup_prev_cache = false;
+
+	if (unlikely(needs_cleanup_prev_cache)) {
+		wait_for_flushing(wb, seg->id);
+		migrate_mb(wb, seg, old_mb, dirty_bits, true);
+	}
+
+	cleanup_mb_if_dirty(wb, seg, old_mb);
+
+	ht_del(wb, old_mb);
+}
+
+static void
+write_on_buffer(struct wb_device *wb, struct segment_header *seg,
+		struct metablock *mb, struct bio *bio)
+{
+	sector_t start_sector = ((mb_idx_inseg(wb, mb->idx) + 1) << 3) +
+				io_offset(bio);
+	size_t start_byte = start_sector << SECTOR_SHIFT;
+	void *data = bio_data(bio);
+
+	/*
+	 * Write data block to the volatile RAM buffer.
+	 */
+	memcpy(wb->current_rambuf->data + start_byte, data, bio->bi_size);
+}
+
+static void advance_cursor(struct wb_device *wb)
+{
+	u32 tmp32;
+	div_u64_rem(wb->cursor + 1, wb->nr_caches, &tmp32);
+	wb->cursor = tmp32;
+}
+
+struct per_bio_data {
+	void *ptr;
+};
+
+static int writeboost_map(struct dm_target *ti, struct bio *bio)
+{
+	struct wb_device *wb = ti->private;
+	struct dm_dev *origin_dev = wb->origin_dev;
+	int rw = bio_data_dir(bio);
+	struct lookup_key key = {
+		.sector = calc_cache_alignment(bio->bi_sector),
+	};
+	struct ht_head *head = ht_get_head(wb, &key);
+
+	struct segment_header *uninitialized_var(found_seg);
+	struct metablock *mb, *new_mb;
+
+	bool found,
+	     on_buffer, /* is the metablock found on the RAM buffer? */
+	     needs_queue_seg; /* need to queue the current seg? */
+
+	struct per_bio_data *map_context;
+	map_context = dm_per_bio_data(bio, ti->per_bio_data_size);
+	map_context->ptr = NULL;
+
+	DEAD(bio_endio(bio, -EIO); return DM_MAPIO_SUBMITTED);
+
+	/*
+	 * We only discard sectors on only the backing store because
+	 * blocks on cache device are unlikely to be discarded.
+	 * Discarding blocks is likely to be operated long after writing;
+	 * the block is likely to be migrated before that.
+	 *
+	 * Moreover, it is very hard to implement discarding cache blocks.
+	 */
+	if (bio->bi_rw & REQ_DISCARD) {
+		bio_remap(bio, origin_dev, bio->bi_sector);
+		return DM_MAPIO_REMAPPED;
+	}
+
+	/*
+	 * Defered ACK for flush requests
+	 *
+	 * In device-mapper, bio with REQ_FLUSH is guaranteed to have no data.
+	 * So, we can simply defer it for lazy execution.
+	 */
+	if (bio->bi_rw & REQ_FLUSH) {
+		BUG_ON(bio->bi_size);
+		queue_barrier_io(wb, bio);
+		return DM_MAPIO_SUBMITTED;
+	}
+
+	mutex_lock(&wb->io_lock);
+	mb = ht_lookup(wb, head, &key);
+	if (mb) {
+		found_seg = mb_to_seg(wb, mb);
+		atomic_inc(&found_seg->nr_inflight_ios);
+	}
+
+	found = (mb != NULL);
+	on_buffer = false;
+	if (found)
+		on_buffer = is_on_buffer(wb, mb->idx);
+
+	inc_stat(wb, rw, found, on_buffer, io_fullsize(bio));
+
+	/*
+	 * (Locking)
+	 * A cache data is placed either on RAM buffer or SSD if it was flushed.
+	 * To ease the locking, we establish a simple rule for the dirtiness
+	 * of a cache data.
+	 *
+	 * If the data is on the RAM buffer, the dirtiness (dirty_bits of metablock)
+	 * only increases. The justification for this design is that the cache on the
+	 * RAM buffer is seldom migrated.
+	 * If the data is, on the other hand, on the SSD after flushed the dirtiness
+	 * only decreases.
+	 *
+	 * This simple rule frees us from the dirtiness fluctuating thus simplies
+	 * locking design.
+	 */
+
+	if (!rw) {
+		u8 dirty_bits;
+
+		mutex_unlock(&wb->io_lock);
+
+		if (!found) {
+			bio_remap(bio, origin_dev, bio->bi_sector);
+			return DM_MAPIO_REMAPPED;
+		}
+
+		dirty_bits = read_mb_dirtiness(wb, found_seg, mb);
+		if (unlikely(on_buffer)) {
+			if (dirty_bits)
+				migrate_buffered_mb(wb, mb, dirty_bits);
+
+			atomic_dec(&found_seg->nr_inflight_ios);
+			bio_remap(bio, origin_dev, bio->bi_sector);
+			return DM_MAPIO_REMAPPED;
+		}
+
+		/*
+		 * We must wait for the (maybe) queued segment to be flushed
+		 * to the cache device.
+		 * Without this, we read the wrong data from the cache device.
+		 */
+		wait_for_flushing(wb, found_seg->id);
+
+		if (likely(dirty_bits == 255)) {
+			bio_remap(bio, wb->cache_dev,
+				  calc_mb_start_sector(wb, found_seg, mb->idx) +
+				  io_offset(bio));
+			map_context->ptr = found_seg;
+		} else {
+			migrate_mb(wb, found_seg, mb, dirty_bits, true);
+			cleanup_mb_if_dirty(wb, found_seg, mb);
+
+			atomic_dec(&found_seg->nr_inflight_ios);
+			bio_remap(bio, origin_dev, bio->bi_sector);
+		}
+		return DM_MAPIO_REMAPPED;
+	}
+
+	if (found) {
+		if (unlikely(on_buffer)) {
+			mutex_unlock(&wb->io_lock);
+			goto write_on_buffer;
+		} else {
+			invalidate_previous_cache(wb, found_seg, mb,
+						  io_fullsize(bio));
+			atomic_dec(&found_seg->nr_inflight_ios);
+			goto write_not_found;
+		}
+	}
+
+write_not_found:
+	/*
+	 * If wb->cursor is 254, 509, ...
+	 * which is the last cache line in the segment.
+	 * We must flush the current segment and get the new one.
+	 */
+	needs_queue_seg = !mb_idx_inseg(wb, wb->cursor + 1);
+
+	if (needs_queue_seg)
+		queue_current_buffer(wb);
+
+	advance_cursor(wb);
+
+	new_mb = wb->current_seg->mb_array + mb_idx_inseg(wb, wb->cursor);
+	BUG_ON(new_mb->dirty_bits);
+	ht_register(wb, head, new_mb, &key);
+
+	atomic_inc(&wb->current_seg->nr_inflight_ios);
+	mutex_unlock(&wb->io_lock);
+
+	mb = new_mb;
+
+write_on_buffer:
+	taint_mb(wb, wb->current_seg, mb, bio);
+
+	write_on_buffer(wb, wb->current_seg, mb, bio);
+
+	atomic_dec(&wb->current_seg->nr_inflight_ios);
+
+	/*
+	 * Deferred ACK for FUA request
+	 *
+	 * bio with REQ_FUA flag has data.
+	 * So, we must run through the path for usual bio.
+	 * And the data is now stored in the RAM buffer.
+	 */
+	if (bio->bi_rw & REQ_FUA) {
+		queue_barrier_io(wb, bio);
+		return DM_MAPIO_SUBMITTED;
+	}
+
+	LIVE_DEAD(bio_endio(bio, 0),
+		  bio_endio(bio, -EIO));
+
+	return DM_MAPIO_SUBMITTED;
+}
+
+static int writeboost_end_io(struct dm_target *ti, struct bio *bio, int error)
+{
+	struct segment_header *seg;
+	struct per_bio_data *map_context =
+		dm_per_bio_data(bio, ti->per_bio_data_size);
+
+	if (!map_context->ptr)
+		return 0;
+
+	seg = map_context->ptr;
+	atomic_dec(&seg->nr_inflight_ios);
+
+	return 0;
+}
+
+static int consume_essential_argv(struct wb_device *wb, struct dm_arg_set *as)
+{
+	int r = 0;
+	struct dm_target *ti = wb->ti;
+
+	static struct dm_arg _args[] = {
+		{0, 0, "invalid buffer type"},
+	};
+	unsigned tmp;
+
+	r = dm_read_arg(_args, as, &tmp, &ti->error);
+	if (r)
+		return r;
+	wb->type = tmp;
+
+	r = dm_get_device(ti, dm_shift_arg(as), dm_table_get_mode(ti->table),
+			  &wb->origin_dev);
+	if (r) {
+		ti->error = "failed to get origin dev";
+		return r;
+	}
+
+	r = dm_get_device(ti, dm_shift_arg(as), dm_table_get_mode(ti->table),
+			  &wb->cache_dev);
+	if (r) {
+		ti->error = "failed to get cache dev";
+		goto bad;
+	}
+
+	return r;
+
+bad:
+	dm_put_device(ti, wb->origin_dev);
+	return r;
+}
+
+#define consume_kv(name, nr) { \
+	if (!strcasecmp(key, #name)) { \
+		if (!argc) \
+			break; \
+		r = dm_read_arg(_args + (nr), as, &tmp, &ti->error); \
+		if (r) \
+			break; \
+		wb->name = tmp; \
+	 } }
+
+static int consume_optional_argv(struct wb_device *wb, struct dm_arg_set *as)
+{
+	int r = 0;
+	struct dm_target *ti = wb->ti;
+
+	static struct dm_arg _args[] = {
+		{0, 4, "invalid optional argc"},
+		{4, 10, "invalid segment_size_order"},
+		{512, UINT_MAX, "invalid rambuf_pool_amount"},
+	};
+	unsigned tmp, argc = 0;
+
+	if (as->argc) {
+		r = dm_read_arg_group(_args, as, &argc, &ti->error);
+		if (r)
+			return r;
+	}
+
+	while (argc) {
+		const char *key = dm_shift_arg(as);
+		argc--;
+
+		r = -EINVAL;
+
+		consume_kv(segment_size_order, 1);
+		consume_kv(rambuf_pool_amount, 2);
+
+		if (!r) {
+			argc--;
+		} else {
+			ti->error = "invalid optional key";
+			break;
+		}
+	}
+
+	return r;
+}
+
+static int do_consume_tunable_argv(struct wb_device *wb,
+				   struct dm_arg_set *as, unsigned argc)
+{
+	int r = 0;
+	struct dm_target *ti = wb->ti;
+
+	static struct dm_arg _args[] = {
+		{0, 1, "invalid allow_migrate"},
+		{0, 1, "invalid enable_migration_modulator"},
+		{1, 1000, "invalid barrier_deadline_ms"},
+		{1, 1000, "invalid nr_max_batched_migration"},
+		{0, 100, "invalid migrate_threshold"},
+		{0, 3600, "invalid update_record_interval"},
+		{0, 3600, "invalid sync_interval"},
+	};
+	unsigned tmp;
+
+	while (argc) {
+		const char *key = dm_shift_arg(as);
+		argc--;
+
+		r = -EINVAL;
+
+		consume_kv(allow_migrate, 0);
+		consume_kv(enable_migration_modulator, 1);
+		consume_kv(barrier_deadline_ms, 2);
+		consume_kv(nr_max_batched_migration, 3);
+		consume_kv(migrate_threshold, 4);
+		consume_kv(update_record_interval, 5);
+		consume_kv(sync_interval, 6);
+
+		if (!r) {
+			argc--;
+		} else {
+			ti->error = "invalid tunable key";
+			break;
+		}
+	}
+
+	return r;
+}
+
+static int consume_tunable_argv(struct wb_device *wb, struct dm_arg_set *as)
+{
+	int r = 0;
+	struct dm_target *ti = wb->ti;
+
+	static struct dm_arg _args[] = {
+		{0, 14, "invalid tunable argc"},
+	};
+	unsigned argc = 0;
+
+	if (as->argc) {
+		r = dm_read_arg_group(_args, as, &argc, &ti->error);
+		if (r)
+			return r;
+		/*
+		 * tunables are emitted only if
+		 * they were origianlly passed.
+		 */
+		wb->should_emit_tunables = true;
+	}
+
+	return do_consume_tunable_argv(wb, as, argc);
+}
+
+static int init_core_struct(struct dm_target *ti)
+{
+	int r = 0;
+	struct wb_device *wb;
+
+	r = dm_set_target_max_io_len(ti, 1 << 3);
+	if (r) {
+		WBERR("failed to set max_io_len");
+		return r;
+	}
+
+	ti->flush_supported = true;
+	ti->num_flush_bios = 1;
+	ti->num_discard_bios = 1;
+	ti->discard_zeroes_data_unsupported = true;
+	ti->per_bio_data_size = sizeof(struct per_bio_data);
+
+	wb = kzalloc(sizeof(*wb), GFP_KERNEL);
+	if (!wb) {
+		WBERR("failed to allocate wb");
+		return -ENOMEM;
+	}
+	ti->private = wb;
+	wb->ti = ti;
+
+	mutex_init(&wb->io_lock);
+	spin_lock_init(&wb->lock);
+	atomic64_set(&wb->nr_dirty_caches, 0);
+	clear_bit(WB_DEAD, &wb->flags);
+	wb->should_emit_tunables = false;
+
+	return r;
+}
+
+/*
+ * Create a Writeboost device
+ *
+ * <type>
+ * <essential args>*
+ * <#optional args> <optional args>*
+ * <#tunable args> <tunable args>*
+ * optionals are tunables are unordered lists of k-v pair.
+ *
+ * See Documentation for detail.
+  */
+static int writeboost_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	int r = 0;
+	struct wb_device *wb;
+
+	struct dm_arg_set as;
+	as.argc = argc;
+	as.argv = argv;
+
+	r = init_core_struct(ti);
+	if (r) {
+		ti->error = "failed to init core";
+		return r;
+	}
+	wb = ti->private;
+
+	r = consume_essential_argv(wb, &as);
+	if (r) {
+		ti->error = "failed to consume essential argv";
+		goto bad_essential_argv;
+	}
+
+	wb->segment_size_order = 7;
+	wb->rambuf_pool_amount = 2048;
+	r = consume_optional_argv(wb, &as);
+	if (r) {
+		ti->error = "failed to consume optional argv";
+		goto bad_optional_argv;
+	}
+
+	r = resume_cache(wb);
+	if (r) {
+		ti->error = "failed to resume cache";
+		goto bad_resume_cache;
+	}
+
+	r = consume_tunable_argv(wb, &as);
+	if (r) {
+		ti->error = "failed to consume tunable argv";
+		goto bad_tunable_argv;
+	}
+
+	clear_stat(wb);
+	atomic64_set(&wb->count_non_full_flushed, 0);
+
+	return r;
+
+bad_tunable_argv:
+	free_cache(wb);
+bad_resume_cache:
+bad_optional_argv:
+	dm_put_device(ti, wb->cache_dev);
+	dm_put_device(ti, wb->origin_dev);
+bad_essential_argv:
+	kfree(wb);
+
+	return r;
+}
+
+static void writeboost_dtr(struct dm_target *ti)
+{
+	struct wb_device *wb = ti->private;
+
+	free_cache(wb);
+
+	dm_put_device(ti, wb->cache_dev);
+	dm_put_device(ti, wb->origin_dev);
+
+	kfree(wb);
+
+	ti->private = NULL;
+}
+
+/*
+ * .postsuspend is called before .dtr.
+ * We flush out all the transient data and make them persistent.
+ */
+static void writeboost_postsuspend(struct dm_target *ti)
+{
+	int r = 0;
+	struct wb_device *wb = ti->private;
+
+	flush_current_buffer(wb);
+	IO(blkdev_issue_flush(wb->cache_dev->bdev, GFP_NOIO, NULL));
+}
+
+static int writeboost_message(struct dm_target *ti, unsigned argc, char **argv)
+{
+	struct wb_device *wb = ti->private;
+
+	struct dm_arg_set as;
+	as.argc = argc;
+	as.argv = argv;
+
+	if (!strcasecmp(argv[0], "clear_stat")) {
+		clear_stat(wb);
+		return 0;
+	}
+
+	if (!strcasecmp(argv[0], "drop_caches")) {
+		int r = 0;
+		wb->force_drop = true;
+		r = wait_event_interruptible(wb->wait_drop_caches,
+			     !atomic64_read(&wb->nr_dirty_caches));
+		wb->force_drop = false;
+		return r;
+	}
+
+	return do_consume_tunable_argv(wb, &as, 2);
+}
+
+/*
+ * Since Writeboost is just a cache target and the cache block size is fixed
+ * to 4KB. There is no reason to count the cache device in device iteration.
+ */
+static int
+writeboost_iterate_devices(struct dm_target *ti,
+			   iterate_devices_callout_fn fn, void *data)
+{
+	struct wb_device *wb = ti->private;
+	struct dm_dev *orig = wb->origin_dev;
+	sector_t start = 0;
+	sector_t len = dm_devsize(orig);
+	return fn(ti, orig, start, len, data);
+}
+
+static void
+writeboost_io_hints(struct dm_target *ti, struct queue_limits *limits)
+{
+	blk_limits_io_opt(limits, 4096);
+}
+
+static void emit_tunables(struct wb_device *wb, char *result, unsigned maxlen)
+{
+	ssize_t sz = 0;
+
+	DMEMIT(" %d", 14);
+	DMEMIT(" barrier_deadline_ms %lu",
+	       wb->barrier_deadline_ms);
+	DMEMIT(" allow_migrate %d",
+	       wb->allow_migrate ? 1 : 0);
+	DMEMIT(" enable_migration_modulator %d",
+	       wb->enable_migration_modulator ? 1 : 0);
+	DMEMIT(" migrate_threshold %d",
+	       wb->migrate_threshold);
+	DMEMIT(" nr_cur_batched_migration %u",
+	       wb->nr_cur_batched_migration);
+	DMEMIT(" sync_interval %lu",
+	       wb->sync_interval);
+	DMEMIT(" update_record_interval %lu",
+	       wb->update_record_interval);
+}
+
+static void writeboost_status(struct dm_target *ti, status_type_t type,
+			      unsigned flags, char *result, unsigned maxlen)
+{
+	ssize_t sz = 0;
+	char buf[BDEVNAME_SIZE];
+	struct wb_device *wb = ti->private;
+	size_t i;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		DMEMIT("%u %u %llu %llu %llu %llu %llu",
+		       (unsigned int)
+		       wb->cursor,
+		       (unsigned int)
+		       wb->nr_caches,
+		       (long long unsigned int)
+		       wb->nr_segments,
+		       (long long unsigned int)
+		       wb->current_seg->id,
+		       (long long unsigned int)
+		       atomic64_read(&wb->last_flushed_segment_id),
+		       (long long unsigned int)
+		       atomic64_read(&wb->last_migrated_segment_id),
+		       (long long unsigned int)
+		       atomic64_read(&wb->nr_dirty_caches));
+
+		for (i = 0; i < STATLEN; i++) {
+			atomic64_t *v = &wb->stat[i];
+			DMEMIT(" %llu", (unsigned long long) atomic64_read(v));
+		}
+		DMEMIT(" %llu", (unsigned long long) atomic64_read(&wb->count_non_full_flushed));
+		emit_tunables(wb, result + sz, maxlen - sz);
+		break;
+
+	case STATUSTYPE_TABLE:
+		DMEMIT("%u", wb->type);
+		format_dev_t(buf, wb->origin_dev->bdev->bd_dev),
+		DMEMIT(" %s", buf);
+		format_dev_t(buf, wb->cache_dev->bdev->bd_dev),
+		DMEMIT(" %s", buf);
+		DMEMIT(" 4 segment_size_order %u rambuf_pool_amount %u",
+		       wb->segment_size_order,
+		       wb->rambuf_pool_amount);
+		if (wb->should_emit_tunables)
+			emit_tunables(wb, result + sz, maxlen - sz);
+		break;
+	}
+}
+
+static struct target_type writeboost_target = {
+	.name = "writeboost",
+	.version = {0, 1, 0},
+	.module = THIS_MODULE,
+	.map = writeboost_map,
+	.end_io = writeboost_end_io,
+	.ctr = writeboost_ctr,
+	.dtr = writeboost_dtr,
+	/*
+	 * .merge is not implemented
+	 * We split the passed I/O into 4KB cache block no matter
+	 * how big the I/O is.
+	 */
+	.postsuspend = writeboost_postsuspend,
+	.message = writeboost_message,
+	.status = writeboost_status,
+	.io_hints = writeboost_io_hints,
+	.iterate_devices = writeboost_iterate_devices,
+};
+
+struct dm_io_client *wb_io_client;
+struct workqueue_struct *safe_io_wq;
+static int __init writeboost_module_init(void)
+{
+	int r = 0;
+
+	r = dm_register_target(&writeboost_target);
+	if (r < 0) {
+		WBERR("failed to register target");
+		return r;
+	}
+
+	safe_io_wq = alloc_workqueue("wbsafeiowq",
+				     WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
+	if (!safe_io_wq) {
+		WBERR("failed to allocate safe_io_wq");
+		r = -ENOMEM;
+		goto bad_wq;
+	}
+
+	wb_io_client = dm_io_client_create();
+	if (IS_ERR(wb_io_client)) {
+		WBERR("failed to allocate wb_io_client");
+		r = PTR_ERR(wb_io_client);
+		goto bad_io_client;
+	}
+
+	return r;
+
+bad_io_client:
+	destroy_workqueue(safe_io_wq);
+bad_wq:
+	dm_unregister_target(&writeboost_target);
+
+	return r;
+}
+
+static void __exit writeboost_module_exit(void)
+{
+	dm_io_client_destroy(wb_io_client);
+	destroy_workqueue(safe_io_wq);
+	dm_unregister_target(&writeboost_target);
+}
+
+module_init(writeboost_module_init);
+module_exit(writeboost_module_exit);
+
+MODULE_AUTHOR("Akira Hayakawa <ruby.wktk@gmail.com>");
+MODULE_DESCRIPTION(DM_NAME " writeboost target");
+MODULE_LICENSE("GPL");
diff --git a/drivers/md/dm-writeboost.h b/drivers/md/dm-writeboost.h
new file mode 100644
index 0000000..3e37b53
--- /dev/null
+++ b/drivers/md/dm-writeboost.h
@@ -0,0 +1,464 @@
+/*
+ * Copyright (C) 2012-2014 Akira Hayakawa <ruby.wktk@gmail.com>
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef DM_WRITEBOOST_H
+#define DM_WRITEBOOST_H
+
+#define DM_MSG_PREFIX "writeboost"
+
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/mutex.h>
+#include <linux/kthread.h>
+#include <linux/sched.h>
+#include <linux/timer.h>
+#include <linux/workqueue.h>
+#include <linux/device-mapper.h>
+#include <linux/dm-io.h>
+
+/*----------------------------------------------------------------*/
+
+#define SUB_ID(x, y) ((x) > (y) ? (x) - (y) : 0)
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Nice printk macros
+ *
+ * Production code should not include lineno
+ * but name of the caller seems to be OK.
+ */
+
+/*
+ * Only for debugging.
+ * Don't include this macro in the production code.
+ */
+#define wbdebug(f, args...) \
+	DMINFO("debug@%s() L.%d " f, __func__, __LINE__, ## args)
+
+#define WBERR(f, args...) \
+	DMERR("err@%s() " f, __func__, ## args)
+#define WBWARN(f, args...) \
+	DMWARN("warn@%s() " f, __func__, ## args)
+#define WBINFO(f, args...) \
+	DMINFO("info@%s() " f, __func__, ## args)
+
+/*----------------------------------------------------------------*/
+
+/*
+ * The Detail of the Disk Format (SSD)
+ * -----------------------------------
+ *
+ * ### Overall
+ * Superblock (1MB) + Segment + Segment ...
+ *
+ * ### Superblock
+ * head <----                                     ----> tail
+ * superblock header (512B) + ... + superblock record (512B)
+ *
+ * ### Segment
+ * segment_header_device (512B) +
+ * metablock_device * nr_caches_inseg +
+ * data[0] (4KB) + data[1] + ... + data[nr_cache_inseg - 1]
+ */
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Superblock Header (Immutable)
+ * -----------------------------
+ * First one sector of the super block region whose value
+ * is unchanged after formatted.
+ */
+#define WB_MAGIC 0x57427374 /* Magic number "WBst" */
+struct superblock_header_device {
+	__le32 magic;
+	__u8 segment_size_order;
+} __packed;
+
+/*
+ * Superblock Record (Mutable)
+ * ---------------------------
+ * Last one sector of the superblock region.
+ * Record the current cache status if required.
+ */
+struct superblock_record_device {
+	__le64 last_migrated_segment_id;
+} __packed;
+
+/*----------------------------------------------------------------*/
+
+/*
+ * The size must be a factor of one sector to avoid starddling
+ * neighboring two sectors.
+ * Facebook's flashcache does the same thing.
+ */
+struct metablock_device {
+	__le64 sector;
+	__u8 dirty_bits;
+	__u8 padding[16 - (8 + 1)]; /* 16B */
+} __packed;
+
+#define WB_CKSUM_SEED (~(u32)0)
+
+struct segment_header_device {
+	/*
+	 * We assume 1 sector write is atomic.
+	 * This 1 sector region contains important information
+	 * such as checksum of the rest of the segment data.
+	 * We use 32bit checksum to audit if the segment is
+	 * correctly written to the cache device.
+	 */
+	/* - FROM ------------------------------------ */
+	__le64 id;
+	/* TODO add timestamp? */
+	__le32 checksum;
+	/*
+	 * The number of metablocks in this segment header
+	 * to be considered in log replay. The rest are ignored.
+	 */
+	__u8 length;
+	__u8 padding[512 - (8 + 4 + 1)]; /* 512B */
+	/* - TO -------------------------------------- */
+	struct metablock_device mbarr[0]; /* 16B * N */
+} __packed;
+
+/*----------------------------------------------------------------*/
+
+struct metablock {
+	sector_t sector; /* The original aligned address */
+
+	u32 idx; /* Index in the metablock array. Const */
+
+	struct hlist_node ht_list; /* Linked to the Hash table */
+
+	u8 dirty_bits; /* 8bit for dirtiness in sector granularity */
+};
+
+#define SZ_MAX (~(size_t)0)
+struct segment_header {
+	u64 id; /* Must be initialized to 0 */
+
+	/*
+	 * The number of metablocks in a segment to flush and then migrate.
+	 */
+	u8 length;
+
+	u32 start_idx; /* Const */
+	sector_t start_sector; /* Const */
+
+	atomic_t nr_inflight_ios;
+
+	struct metablock mb_array[0];
+};
+
+/*----------------------------------------------------------------*/
+
+enum RAMBUF_TYPE {
+	BUF_NORMAL = 0, /* Volatile DRAM */
+	BUF_NV_BLK, /* Non-volatile with block I/F */
+	BUF_NV_RAM, /* Non-volatile with PRAM I/F */
+};
+
+/*
+ * RAM buffer is a buffer that any dirty data are first written to.
+ * type member in wb_device indicates the buffer type.
+ */
+struct rambuffer {
+	void *data; /* The DRAM buffer. Used as the buffer to submit I/O */
+};
+
+/*
+ * wbflusher's favorite food.
+ * foreground queues this object and wbflusher later pops
+ * one job to submit journal write to the cache device.
+ */
+struct flush_job {
+	struct work_struct work;
+	struct wb_device *wb;
+	struct segment_header *seg;
+	struct rambuffer *rambuf; /* RAM buffer to flush */
+	struct bio_list barrier_ios; /* List of deferred bios */
+};
+
+/*----------------------------------------------------------------*/
+
+enum STATFLAG {
+	STAT_WRITE = 0,
+	STAT_HIT,
+	STAT_ON_BUFFER,
+	STAT_FULLSIZE,
+};
+#define STATLEN (1 << 4)
+
+enum WB_FLAG {
+	/*
+	 * This flag is set when either one of the underlying devices
+	 * returned EIO and we must immediately block up the whole to
+	 * avoid further damage.
+	 */
+	WB_DEAD = 0,
+};
+
+/*
+ * The context of the cache driver.
+ */
+struct wb_device {
+	enum RAMBUF_TYPE type;
+
+	struct dm_target *ti;
+
+	struct dm_dev *origin_dev; /* Slow device (HDD) */
+	struct dm_dev *cache_dev; /* Fast device (SSD) */
+
+	mempool_t *buf_1_pool; /* 1 sector buffer pool */
+	mempool_t *buf_8_pool; /* 8 sector buffer pool */
+
+	/*
+	 * Mutex is very light-weight.
+	 * To mitigate the overhead of the locking we chose to
+	 * use mutex.
+	 * To optimize the read path, rw_semaphore is an option
+	 * but it means to sacrifice write path.
+	 */
+	struct mutex io_lock;
+
+	spinlock_t lock;
+
+	u8 segment_size_order; /* Const */
+	u8 nr_caches_inseg; /* Const */
+
+	/*---------------------------------------------*/
+
+	/******************
+	 * Current position
+	 ******************/
+
+	/*
+	 * Current metablock index
+	 * which is the last place already written
+	 * *not* the position to write hereafter.
+	 */
+	u32 cursor;
+	struct segment_header *current_seg;
+	struct rambuffer *current_rambuf;
+
+	/*---------------------------------------------*/
+
+	/**********************
+	 * Segment header array
+	 **********************/
+
+	u32 nr_segments; /* Const */
+	struct large_array *segment_header_array;
+
+	/*---------------------------------------------*/
+
+	/********************
+	 * Chained Hash table
+	 ********************/
+
+	u32 nr_caches; /* Const */
+	struct large_array *htable;
+	size_t htsize;
+	struct ht_head *null_head;
+
+	/*---------------------------------------------*/
+
+	/*****************
+	 * RAM buffer pool
+	 *****************/
+
+	u32 rambuf_pool_amount; /* kB */
+	u32 nr_rambuf_pool; /* Const */
+	struct rambuffer *rambuf_pool;
+	mempool_t *flush_job_pool;
+
+	/*---------------------------------------------*/
+
+	/***********
+	 * wbflusher
+	 ***********/
+
+	struct workqueue_struct *flusher_wq;
+	wait_queue_head_t flush_wait_queue; /* wait for a segment to be flushed */
+	atomic64_t last_flushed_segment_id;
+
+	/*---------------------------------------------*/
+
+	/*************************
+	 * Barrier deadline worker
+	 *************************/
+
+	struct work_struct barrier_deadline_work;
+	struct timer_list barrier_deadline_timer;
+	struct bio_list barrier_ios; /* List of barrier requests */
+	unsigned long barrier_deadline_ms; /* tunable */
+
+	/*---------------------------------------------*/
+
+	/****************
+	 * Migrate daemon
+	 ****************/
+
+	struct task_struct *migrate_daemon;
+	int allow_migrate;
+	int urge_migrate; /* Start migration immediately */
+	int force_drop; /* Don't stop migration */
+	atomic64_t last_migrated_segment_id;
+
+	/*
+	 * Data structures used by migrate daemon
+	 */
+	wait_queue_head_t migrate_wait_queue; /* wait for a segment to be migrated */
+	wait_queue_head_t wait_drop_caches; /* wait for drop_caches */
+
+	wait_queue_head_t migrate_io_wait_queue; /* wait for migrate ios */
+	atomic_t migrate_io_count;
+	atomic_t migrate_fail_count;
+
+	u32 nr_cur_batched_migration;
+	u32 nr_max_batched_migration; /* tunable */
+
+	u32 num_emigrates; /* Number of emigrates */
+	struct segment_header **emigrates; /* Segments to be migrated */
+	void *migrate_buffer; /* Memorizes the data blocks of the emigrates */
+	u8 *dirtiness_snapshot; /* Memorizes the dirtiness of the metablocks to be migrated */
+
+	/*---------------------------------------------*/
+
+	/*********************
+	 * Migration modulator
+	 *********************/
+
+	struct task_struct *modulator_daemon;
+	int enable_migration_modulator; /* tunable */
+	u8 migrate_threshold;
+
+	/*---------------------------------------------*/
+
+	/*********************
+	 * Superblock recorder
+	 *********************/
+
+	struct task_struct *recorder_daemon;
+	unsigned long update_record_interval; /* tunable */
+
+	/*---------------------------------------------*/
+
+	/*************
+	 * Sync daemon
+	 *************/
+
+	struct task_struct *sync_daemon;
+	unsigned long sync_interval; /* tunable */
+
+	/*---------------------------------------------*/
+
+	/************
+	 * Statistics
+	 ************/
+
+	atomic64_t nr_dirty_caches;
+	atomic64_t stat[STATLEN];
+	atomic64_t count_non_full_flushed;
+
+	/*---------------------------------------------*/
+
+	unsigned long flags;
+	bool should_emit_tunables; /* should emit tunables in dmsetup table? */
+};
+
+/*----------------------------------------------------------------*/
+
+void acquire_new_seg(struct wb_device *, u64 id);
+void flush_current_buffer(struct wb_device *);
+void inc_nr_dirty_caches(struct wb_device *);
+void cleanup_mb_if_dirty(struct wb_device *, struct segment_header *, struct metablock *);
+u8 read_mb_dirtiness(struct wb_device *, struct segment_header *, struct metablock *);
+void invalidate_previous_cache(struct wb_device *, struct segment_header *,
+			       struct metablock *old_mb, bool overwrite_fullsize);
+
+/*----------------------------------------------------------------*/
+
+extern struct workqueue_struct *safe_io_wq;
+extern struct dm_io_client *wb_io_client;
+
+/*
+ * Wrapper of dm_io function.
+ * Set thread to true to run dm_io in other thread to avoid potential deadlock.
+ */
+#define dm_safe_io(io_req, num_regions, regions, err_bits, thread) \
+	dm_safe_io_internal(wb, (io_req), (num_regions), (regions), \
+			    (err_bits), (thread), __func__);
+int dm_safe_io_internal(struct wb_device *, struct dm_io_request *,
+			unsigned num_regions, struct dm_io_region *,
+			unsigned long *err_bits, bool thread, const char *caller);
+
+sector_t dm_devsize(struct dm_dev *);
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Device blockup
+ * --------------
+ *
+ * I/O error on either backing device or cache device should block
+ * up the whole system immediately.
+ * After the system is blocked up all the I/Os to underlying
+ * devices are all ignored as if they are switched to /dev/null.
+ */
+
+#define LIVE_DEAD(proc_live, proc_dead) \
+	do { \
+		if (likely(!test_bit(WB_DEAD, &wb->flags))) { \
+			proc_live; \
+		} else { \
+			proc_dead; \
+		} \
+	} while (0)
+
+#define noop_proc do {} while (0)
+#define LIVE(proc) LIVE_DEAD(proc, noop_proc);
+#define DEAD(proc) LIVE_DEAD(noop_proc, proc);
+
+/*
+ * Macro to add context of failure to I/O routine call.
+ * We inherited the idea from Maybe monad of the Haskell language.
+ *
+ * Policies
+ * --------
+ * 1. Only -EIO will block up the system.
+ * 2. -EOPNOTSUPP could be returned if the target device is a virtual
+ *    device and we request discard to the device.
+ * 3. -ENOMEM could be returned from blkdev_issue_discard (3.12-rc5)
+ *    for example. Waiting for a while can make room for new allocation.
+ * 4. For other unknown error codes we ignore them and ask the users to report.
+ */
+#define IO(proc) \
+	do { \
+		r = 0; \
+		LIVE(r = proc); /* do nothing after blockup */ \
+		if (r == -EOPNOTSUPP) { \
+			r = 0; \
+		} else if (r == -EIO) { \
+			set_bit(WB_DEAD, &wb->flags); \
+			WBERR("device is marked as dead"); \
+		} else if (r == -ENOMEM) { \
+			WBERR("I/O failed by ENOMEM"); \
+			schedule_timeout_interruptible(msecs_to_jiffies(1000));\
+		} else if (r) { \
+			r = 0;\
+			WARN_ONCE(1, "PLEASE REPORT!!! I/O FAILED FOR UNKNOWN REASON err(%d)", r); \
+		} \
+	} while (r)
+
+/*----------------------------------------------------------------*/
+
+#endif
-- 
1.8.3.4
