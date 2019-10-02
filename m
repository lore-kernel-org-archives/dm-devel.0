From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2] dm-snapshot: Reimplement the cow limit.
Date: Wed, 2 Oct 2019 06:15:53 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1910020614190.973@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Nikos Tsironis <ntsironis@arrikto.com>, Mike Snitzer <msnitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, guru2018@gmail.com
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

In order to fix the bug, I reworked limiting, so that it waits without 
holding any locks. The patch adds a variable in_progress that counts how 
many kcopyd jobs are running. A function wait_for_in_progress will sleep 
if the variable in_progress is over the limit. It drops _origins_lock in 
order to avoid the deadlock.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v5.0+
Fixes: 721b1d98fb51 ("dm snapshot: Fix excessive memory usage and workqueue stalls")

---
 drivers/md/dm-snap.c |   69 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 55 insertions(+), 14 deletions(-)

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c	2019-10-01 15:23:42.000000000 +0200
+++ linux-2.6/drivers/md/dm-snap.c	2019-10-02 12:01:23.000000000 +0200
@@ -18,7 +18,6 @@
 #include <linux/vmalloc.h>
 #include <linux/log2.h>
 #include <linux/dm-kcopyd.h>
-#include <linux/semaphore.h>
 
 #include "dm.h"
 
@@ -107,8 +106,8 @@ struct dm_snapshot {
 	/* The on disk metadata handler */
 	struct dm_exception_store *store;
 
-	/* Maximum number of in-flight COW jobs. */
-	struct semaphore cow_count;
+	unsigned in_progress;
+	struct wait_queue_head in_progress_wait;
 
 	struct dm_kcopyd_client *kcopyd_client;
 
@@ -162,8 +161,8 @@ struct dm_snapshot {
  */
 #define DEFAULT_COW_THRESHOLD 2048
 
-static int cow_threshold = DEFAULT_COW_THRESHOLD;
-module_param_named(snapshot_cow_threshold, cow_threshold, int, 0644);
+static unsigned cow_threshold = DEFAULT_COW_THRESHOLD;
+module_param_named(snapshot_cow_threshold, cow_threshold, uint, 0644);
 MODULE_PARM_DESC(snapshot_cow_threshold, "Maximum number of chunks being copied on write");
 
 DECLARE_DM_KCOPYD_THROTTLE_WITH_MODULE_PARM(snapshot_copy_throttle,
@@ -1327,7 +1326,7 @@ static int snapshot_ctr(struct dm_target
 		goto bad_hash_tables;
 	}
 
-	sema_init(&s->cow_count, (cow_threshold > 0) ? cow_threshold : INT_MAX);
+	init_waitqueue_head(&s->in_progress_wait);
 
 	s->kcopyd_client = dm_kcopyd_client_create(&dm_kcopyd_throttle);
 	if (IS_ERR(s->kcopyd_client)) {
@@ -1509,17 +1508,46 @@ static void snapshot_dtr(struct dm_targe
 
 	dm_put_device(ti, s->origin);
 
+	WARN_ON(s->in_progress);
+
 	kfree(s);
 }
 
 static void account_start_copy(struct dm_snapshot *s)
 {
-	down(&s->cow_count);
+	spin_lock(&s->in_progress_wait.lock);
+	s->in_progress++;
+	spin_unlock(&s->in_progress_wait.lock);
 }
 
 static void account_end_copy(struct dm_snapshot *s)
 {
-	up(&s->cow_count);
+	spin_lock(&s->in_progress_wait.lock);
+	BUG_ON(!s->in_progress);
+	s->in_progress--;
+	if (likely(s->in_progress <= cow_threshold) && unlikely(waitqueue_active(&s->in_progress_wait)))
+		wake_up_locked(&s->in_progress_wait);
+	spin_unlock(&s->in_progress_wait.lock);
+}
+
+static bool wait_for_in_progress(struct dm_snapshot *s, bool unlock_origins)
+{
+	if (unlikely(s->in_progress > cow_threshold)) {
+		spin_lock(&s->in_progress_wait.lock);
+		if (likely(s->in_progress > cow_threshold)) {
+			DECLARE_WAITQUEUE(wait, current);
+			__add_wait_queue(&s->in_progress_wait, &wait);
+			__set_current_state(TASK_UNINTERRUPTIBLE);
+			spin_unlock(&s->in_progress_wait.lock);
+			if (unlock_origins)
+				up_read(&_origins_lock);
+			io_schedule();
+			remove_wait_queue(&s->in_progress_wait, &wait);
+			return false;
+		}
+		spin_unlock(&s->in_progress_wait.lock);
+	}
+	return true;
 }
 
 /*
@@ -1537,7 +1565,7 @@ static void flush_bios(struct bio *bio)
 	}
 }
 
-static int do_origin(struct dm_dev *origin, struct bio *bio);
+static int do_origin(struct dm_dev *origin, struct bio *bio, bool limit);
 
 /*
  * Flush a list of buffers.
@@ -1550,7 +1578,7 @@ static void retry_origin_bios(struct dm_
 	while (bio) {
 		n = bio->bi_next;
 		bio->bi_next = NULL;
-		r = do_origin(s->origin, bio);
+		r = do_origin(s->origin, bio, false);
 		if (r == DM_MAPIO_REMAPPED)
 			generic_make_request(bio);
 		bio = n;
@@ -1926,6 +1954,10 @@ static int snapshot_map(struct dm_target
 	if (!s->valid)
 		return DM_MAPIO_KILL;
 
+	if (bio_data_dir(bio) == WRITE) {
+		while (unlikely(!wait_for_in_progress(s, false))) ;
+	}
+
 	down_read(&s->lock);
 	dm_exception_table_lock(&lock);
 
@@ -2122,7 +2154,7 @@ redirect_to_origin:
 
 	if (bio_data_dir(bio) == WRITE) {
 		up_write(&s->lock);
-		return do_origin(s->origin, bio);
+		return do_origin(s->origin, bio, false);
 	}
 
 out_unlock:
@@ -2497,15 +2529,24 @@ next_snapshot:
 /*
  * Called on a write from the origin driver.
  */
-static int do_origin(struct dm_dev *origin, struct bio *bio)
+static int do_origin(struct dm_dev *origin, struct bio *bio, bool limit)
 {
 	struct origin *o;
 	int r = DM_MAPIO_REMAPPED;
 
+again:
 	down_read(&_origins_lock);
 	o = __lookup_origin(origin->bdev);
-	if (o)
+	if (o) {
+		struct dm_snapshot *s;
+		if (limit) {
+			list_for_each_entry(s, &o->snapshots, list)
+				if (unlikely(!wait_for_in_progress(s, true)))
+					goto again;
+		}
+
 		r = __origin_write(&o->snapshots, bio->bi_iter.bi_sector, bio);
+	}
 	up_read(&_origins_lock);
 
 	return r;
@@ -2618,7 +2659,7 @@ static int origin_map(struct dm_target *
 		dm_accept_partial_bio(bio, available_sectors);
 
 	/* Only tell snapshots if this is a write */
-	return do_origin(o->dev, bio);
+	return do_origin(o->dev, bio, true);
 }
 
 /*
