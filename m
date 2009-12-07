From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] snapshot merging: change timeout to a sequence
	count
Date: Mon, 7 Dec 2009 08:19:20 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0912070816120.15633@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi

This changes the timeout to a sequence count. And adds a comment.

Mikulas

---

Avoit the timeout.

Use a sequence count to resolve the race. The count increases each time
an exception reallocation finishes. Use wait_event() to wait until the count
changes.

The chunk-reallocation logic is explained in the comment in the patch.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap.c |   44 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

Index: linux-2.6.32-devel/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.32-devel.orig/drivers/md/dm-snap.c	2009-12-07 12:40:15.000000000 +0100
+++ linux-2.6.32-devel/drivers/md/dm-snap.c	2009-12-07 14:18:48.000000000 +0100
@@ -257,6 +257,8 @@ static struct list_head *_origins;
 static struct rw_semaphore _origins_lock;
 
 static DECLARE_WAIT_QUEUE_HEAD(_pending_exception_done);
+static DEFINE_SPINLOCK(_pending_exception_done_spinlock);
+static u64 _pending_exception_done_count = 0;
 
 static int init_origin_hash(void)
 {
@@ -756,6 +758,17 @@ static int __origin_write(struct list_he
 static void merge_callback(int read_err, unsigned long write_err,
 			   void *context);
 
+static u64 read_pending_exception_done_count(void)
+{
+	u64 current_count;
+
+	spin_lock(&_pending_exception_done_spinlock);
+	current_count = _pending_exception_done_count;
+	spin_unlock(&_pending_exception_done_spinlock);
+
+	return current_count;
+}
+
 static void snapshot_merge_process(struct dm_snapshot *s)
 {
 	int r;
@@ -763,6 +776,7 @@ static void snapshot_merge_process(struc
 	struct origin *o;
 	int must_wait;
 	struct dm_io_region src, dest;
+	u64 previous_count;
 
 	BUG_ON(!test_bit(MERGE_RUNNING, &s->bits));
 	if (unlikely(test_bit(SHUTDOWN_MERGE, &s->bits)))
@@ -792,8 +806,31 @@ static void snapshot_merge_process(struc
 	src.sector = chunk_to_sector(s->store, new_chunk);
 	src.count = dest.count;
 
+	/*
+	 * Reallocate the other snapshots:
+	 *
+	 * The chunk size of the merging snapshot may be larger than the chunk
+	 * size of some other snapshot. So we may need to reallocate multiple
+	 * chunks in a snapshot.
+	 *
+	 * We don't do linking of pending exceptions and waiting for the last
+	 * one --- that would complicate code too much and it would also be
+	 * bug-prone.
+	 *
+	 * Instead, we try to scan all the overlapping exceptions in all
+	 * non-merging snapshots and if something was reallocated then wait
+	 * for any pending exception to complete. Retry after the wait, until
+	 * all exceptions are done.
+	 *
+	 * This may seem ineffective, but in practice, people hardly use more
+	 * than one or two snapshots. In case of two snapshots (one merging and
+	 * one non-merging) with the same chunksize, wait and wakeup is done
+	 * only once.
+	 */
+
 test_again:
-	/* Reallocate other snapshots */
+	previous_count = read_pending_exception_done_count();
+
 	must_wait = 0;
 	/*
 	 * Merging snapshot already has the origin's __minimum_chunk_size()
@@ -809,7 +846,7 @@ test_again:
 	}
 	up_read(&_origins_lock);
 	if (must_wait) {
-		sleep_on_timeout(&_pending_exception_done, HZ / 100 + 1);
+		wait_event(_pending_exception_done, read_pending_exception_done_count() != previous_count);
 		goto test_again;
 	}
 
@@ -1345,6 +1382,9 @@ static void pending_complete(struct dm_s
 	origin_bios = bio_list_get(&pe->origin_bios);
 	free_pending_exception(pe);
 
+	spin_lock(&_pending_exception_done_spinlock);
+	_pending_exception_done_count++;
+	spin_unlock(&_pending_exception_done_spinlock);
 	wake_up_all(&_pending_exception_done);
 
 	up_write(&s->lock);
