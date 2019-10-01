From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: [PATCH 1/1] dm snapshot: Fix bug in COW throttling
	mechanism causing deadlocks
Date: Tue,  1 Oct 2019 14:57:47 +0300
Message-ID: <20191001115747.4473-2-ntsironis@arrikto.com>
References: <20191001115747.4473-1-ntsironis@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191001115747.4473-1-ntsironis@arrikto.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
Cc: ntsironis@arrikto.com, guru2018@gmail.com
List-Id: dm-devel.ids

Commit 721b1d98fb517a ("dm snapshot: Fix excessive memory usage and
workqueue stalls") introduced a semaphore to limit the maximum number of
in-flight kcopyd (COW) jobs.

The implementation of this throttling mechanism is prone to a deadlock:

1. One or more threads write to the origin device causing COW, which is
   performed by kcopyd.

2. At some point some of these threads might reach the s->cow_count
   semaphore limit and block in down(&s->cow_count), holding a read lock
   on _origins_lock.

3. Someone tries to acquire a write lock on _origins_lock, e.g.,
   snapshot_ctr(), which blocks because the threads at step (2) already
   hold a read lock on it.

4. A COW operation completes and kcopyd runs dm-snapshot's completion
   callback, which ends up calling pending_complete().
   pending_complete() tries to resubmit any deferred origin bios. This
   requires acquiring a read lock on _origins_lock, which blocks.

   This happens because the read-write semaphore implementation gives
   priority to writers, meaning that as soon as a writer tries to enter
   the critical section, no readers will be allowed in, until all
   writers have completed their work.

   So, pending_complete() waits for the writer at step (3) to acquire
   and release the lock. This writer waits for the readers at step (2)
   to release the read lock and those readers wait for
   pending_complete() (the kcopyd thread) to signal the s->cow_count
   semaphore: DEADLOCK.

Fix this by delegating the resubmission of any deferred origin bios to
another thread, so the kcopyd thread never tries to acquire
_origins_lock and it's free to continue its work and signal the
s->cow_count semaphore.

Cc: stable@vger.kernel.org
Fixes: 721b1d98fb517a ("dm snapshot: Fix excessive memory usage and workqueue stalls")
Reported-by: Guruswamy Basavaiah <guru2018@gmail.com>
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
---
 drivers/md/dm-snap.c | 99 +++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 90 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index f150f5c5492b..d701fe53bc96 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -4,6 +4,7 @@
  * This file is released under the GPL.
  */
 
+#include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/device-mapper.h>
 #include <linux/delay.h>
@@ -19,6 +20,7 @@
 #include <linux/log2.h>
 #include <linux/dm-kcopyd.h>
 #include <linux/semaphore.h>
+#include <linux/workqueue.h>
 
 #include "dm.h"
 
@@ -94,11 +96,12 @@ struct dm_snapshot {
 	struct dm_exception_table pending;
 	struct dm_exception_table complete;
 
-	/*
-	 * pe_lock protects all pending_exception operations and access
-	 * as well as the snapshot_bios list.
-	 */
-	spinlock_t pe_lock;
+	/* Origin bios queued for resubmission to the origin device. */
+	spinlock_t deferred_bios_lock;
+	struct bio_list deferred_origin_bios;
+
+	struct workqueue_struct *wq;
+	struct work_struct deferred_bios_work;
 
 	/* Chunks with outstanding reads */
 	spinlock_t tracked_chunk_lock;
@@ -1224,6 +1227,8 @@ static int parse_snapshot_features(struct dm_arg_set *as, struct dm_snapshot *s,
 	return r;
 }
 
+static void process_deferred_bios(struct work_struct *work);
+
 /*
  * Construct a snapshot mapping:
  * <origin_dev> <COW-dev> <p|po|n> <chunk-size> [<# feature args> [<arg>]*]
@@ -1313,7 +1318,8 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	s->out_of_order_tree = RB_ROOT;
 	init_rwsem(&s->lock);
 	INIT_LIST_HEAD(&s->list);
-	spin_lock_init(&s->pe_lock);
+	spin_lock_init(&s->deferred_bios_lock);
+	bio_list_init(&s->deferred_origin_bios);
 	s->state_bits = 0;
 	s->merge_failed = 0;
 	s->first_merging_chunk = 0;
@@ -1336,6 +1342,15 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad_kcopyd;
 	}
 
+	s->wq = alloc_workqueue("dm-" DM_MSG_PREFIX, WQ_MEM_RECLAIM, 0);
+	if (!s->wq) {
+		ti->error = "Could not allocate workqueue";
+		r = -ENOMEM;
+		goto bad_workqueue;
+	}
+
+	INIT_WORK(&s->deferred_bios_work, process_deferred_bios);
+
 	r = mempool_init_slab_pool(&s->pending_pool, MIN_IOS, pending_cache);
 	if (r) {
 		ti->error = "Could not allocate mempool for pending exceptions";
@@ -1401,6 +1416,8 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 bad_load_and_register:
 	mempool_exit(&s->pending_pool);
 bad_pending_pool:
+	destroy_workqueue(s->wq);
+bad_workqueue:
 	dm_kcopyd_client_destroy(s->kcopyd_client);
 bad_kcopyd:
 	dm_exception_table_exit(&s->pending, pending_cache);
@@ -1423,6 +1440,12 @@ static void __free_exceptions(struct dm_snapshot *s)
 	dm_kcopyd_client_destroy(s->kcopyd_client);
 	s->kcopyd_client = NULL;
 
+	/*
+	 * destroy_workqueue() drains the workqueue so any pending origin bios
+	 * will be sumbitted before it returns.
+	 */
+	destroy_workqueue(s->wq);
+
 	dm_exception_table_exit(&s->pending, pending_cache);
 	dm_exception_table_exit(&s->complete, exception_cache);
 }
@@ -1534,9 +1557,11 @@ static int do_origin(struct dm_dev *origin, struct bio *bio);
  */
 static void retry_origin_bios(struct dm_snapshot *s, struct bio *bio)
 {
+	struct blk_plug plug;
 	struct bio *n;
 	int r;
 
+	blk_start_plug(&plug);
 	while (bio) {
 		n = bio->bi_next;
 		bio->bi_next = NULL;
@@ -1545,6 +1570,28 @@ static void retry_origin_bios(struct dm_snapshot *s, struct bio *bio)
 			generic_make_request(bio);
 		bio = n;
 	}
+	blk_finish_plug(&plug);
+}
+
+static void process_deferred_bios(struct work_struct *work)
+{
+	struct dm_snapshot *s = container_of(work, typeof(*s), deferred_bios_work);
+	struct bio *origin_bios;
+
+	spin_lock(&s->deferred_bios_lock);
+	origin_bios = bio_list_get(&s->deferred_origin_bios);
+	spin_unlock(&s->deferred_bios_lock);
+
+	retry_origin_bios(s, origin_bios);
+}
+
+static void issue_origin_bios(struct dm_snapshot *s, struct bio_list *origin_bios)
+{
+	spin_lock(&s->deferred_bios_lock);
+	bio_list_merge(&s->deferred_origin_bios, origin_bios);
+	spin_unlock(&s->deferred_bios_lock);
+
+	queue_work(s->wq, &s->deferred_bios_work);
 }
 
 /*
@@ -1592,7 +1639,6 @@ static void pending_complete(void *context, int success)
 	struct dm_snap_pending_exception *pe = context;
 	struct dm_exception *e;
 	struct dm_snapshot *s = pe->snap;
-	struct bio *origin_bios = NULL;
 	struct bio *snapshot_bios = NULL;
 	struct bio *full_bio = NULL;
 	struct dm_exception_table_lock lock;
@@ -1653,7 +1699,6 @@ static void pending_complete(void *context, int success)
 	dm_exception_table_unlock(&lock);
 
 	snapshot_bios = bio_list_get(&pe->snapshot_bios);
-	origin_bios = bio_list_get(&pe->origin_bios);
 	full_bio = pe->full_bio;
 	if (full_bio)
 		full_bio->bi_end_io = pe->full_bio_end_io;
@@ -1670,7 +1715,43 @@ static void pending_complete(void *context, int success)
 		flush_bios(snapshot_bios);
 	}
 
-	retry_origin_bios(s, origin_bios);
+	/*
+	 * In order to retry the origin bios we have to acquire a read lock on
+	 * _origins_lock. This could lead to a deadlock:
+	 *
+	 * 1. One or more threads write to the origin device causing COW, which
+	 *    is performed by kcopyd.
+	 *
+	 * 2. At some point some of these threads might reach the s->cow_count
+	 *    semaphore limit and block in down(&s->cow_count), holding a read
+	 *    lock on _origins_lock.
+	 *
+	 * 3. Someone tries to acquire a write lock on _origins_lock, e.g.,
+	 *    snapshot_ctr(), which blocks because the threads at step (2)
+	 *    already hold a read lock on it.
+	 *
+	 * 4. A COW operation completes and kcopyd runs our completion
+	 *    callback, which ends up calling pending_complete(). If we
+	 *    resubmit the origin bios from pending_complete(), which runs in
+	 *    the kcopyd thread, it will block trying to acquire a read lock on
+	 *    _origins_lock.
+	 *
+	 *    This happens because the read-write semaphore implementation
+	 *    gives priority to writers, meaning that as soon as a writer tries
+	 *    to enter the critical section, no readers will be allowed in,
+	 *    until all writers have completed their work.
+	 *
+	 *    So, we wait for the writer at step (3) to acquire and release the
+	 *    lock. This writer waits for the readers at step (2) to release
+	 *    the read lock and those readers wait for us (the kcopyd thread)
+	 *    to signal the s->cow_count semaphore: DEADLOCK.
+	 *
+	 * To avoid this we delegate the resubmission of the origin bios to
+	 * another thread, so the kcopyd thread never tries to acquire
+	 * _origins_lock and it's free to continue its work and signal the
+	 * s->cow_count semaphore.
+	 */
+	issue_origin_bios(s, &pe->origin_bios);
 
 	free_pending_exception(pe);
 }
-- 
2.11.0
