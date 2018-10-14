From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: Some questions on commit 3db2776d9fca (dm snapshot:
	improve performance by switching out_of_order_list to rbtree)
Date: Sun, 14 Oct 2018 13:44:48 -0400
Message-ID: <20181014174448.5752-1-ntsironis@arrikto.com>
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
To: djeffery@redhat.com
Cc: bhull@redhat.com, dm-devel@redhat.com, mpatocka@redhat.com, snitzer@redhat.com, iliastsi@arrikto.com
List-Id: dm-devel.ids

Hello all,

Commit 3db2776d9fca (dm snapshot: improve performance by switching
out_of_order_list to rbtree) fixed a performance issue with dm-snapshot.
I had also stumbled on this performance issue when taking multiple
snapshots of an LV and doing parallel IO to all of them, but I was not
using the latest commits so I hadn't caught up with the fix.

Unaware that this issue was fixed in the latest mainline kernel I tried
to fix it myself and came up with a solution which is a bit different
from the one in 3db2776d. I attach my original patch to this mail. I
don't suggest that this patch should be merged but it'd be great if
someone could take a look at it and comment on its correctness and
suitability for solving the performance issue.

I opted to keep the out_of_order_list and append new exceptions to it as
they are allocated, instead of inserting them in the right position in
the sorted list when they complete out-of-order. It worked, but I'd like
to understand more about the rationale behind commit 3db2776d9fca.

I am just beginning to learn how device mapper works, so any feedback
would help me a lot to better understand the inner workings of
dm-snapshot and avoid mistakes in future patches.

Towards this goal I have a couple more questions:

  * What test suite did you use to find the bug and verify your fix?
    Can I download it from somewhere so I can also verify my own
    patches, before submitting them?

  * How can I ensure I am synced up with the latest developments,
    in the future? Should I track the dm-4.xx branch on the
    git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
    repository and base my patches on it? I am already subscribed to the
    dm-devel mailing list.

Thanks in advance for your time,
Nikos

---
Fix the performance issue by changing how we handle the in-order
completion of pending exceptions. Exceptions are appended to the
out_of_order_list as they are allocated. This keeps the issued
exceptions in order, as required by persistent snapshots. When a pending
exception completes, copy_callback() will set to true a completed flag
in the exception's structure. Then we traverse the out_of_order_list
committing all exceptions that have completed==true and stopping at the
first one where completed==false. This ensures that exceptions are
completed in the order they were allocated.

 drivers/md/dm-snap.c | 60 ++++++++++++++++++++--------------------------------
 1 file changed, 23 insertions(+), 37 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 97de7a7334d4..c82d84f39cd5 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -75,16 +75,8 @@ struct dm_snapshot {
 
 	atomic_t pending_exceptions_count;
 
-	/* Protected by "lock" */
-	sector_t exception_start_sequence;
-
-	/* Protected by kcopyd single-threaded callback */
-	sector_t exception_complete_sequence;
-
-	/*
-	 * A list of pending exceptions that completed out of order.
-	 * Protected by kcopyd single-threaded callback.
-	 */
+	/* A list of pending exceptions that completed out of order. */
+	spinlock_t completion_lock;
 	struct list_head out_of_order_list;
 
 	mempool_t pending_pool;
@@ -197,8 +189,11 @@ struct dm_snap_pending_exception {
 	/* There was copying error. */
 	int copy_error;
 
-	/* A sequence number, it is used for in-order completion. */
-	sector_t exception_sequence;
+	/*
+	 * If true the pending exception is ready to be committed. It is used
+	 * for in-order completion.
+	 * */
+	bool completed;
 
 	struct list_head out_of_order_entry;
 
@@ -1171,8 +1166,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	s->snapshot_overflowed = 0;
 	s->active = 0;
 	atomic_set(&s->pending_exceptions_count, 0);
-	s->exception_start_sequence = 0;
-	s->exception_complete_sequence = 0;
+	spin_lock_init(&s->completion_lock);
 	INIT_LIST_HEAD(&s->out_of_order_list);
 	mutex_init(&s->lock);
 	INIT_LIST_HEAD(&s->list);
@@ -1537,31 +1531,20 @@ static void copy_callback(int read_err, unsigned long write_err, void *context)
 	struct dm_snapshot *s = pe->snap;
 
 	pe->copy_error = read_err || write_err;
+	pe->completed = true;
 
-	if (pe->exception_sequence == s->exception_complete_sequence) {
-		s->exception_complete_sequence++;
+	spin_lock(&s->completion_lock);
+	while (!list_empty(&s->out_of_order_list)) {
+		pe = list_entry(s->out_of_order_list.next,
+				struct dm_snap_pending_exception, out_of_order_entry);
+		if (!pe->completed)
+			break;
+		list_del(&pe->out_of_order_entry);
+		spin_unlock(&s->completion_lock);
 		complete_exception(pe);
-
-		while (!list_empty(&s->out_of_order_list)) {
-			pe = list_entry(s->out_of_order_list.next,
-					struct dm_snap_pending_exception, out_of_order_entry);
-			if (pe->exception_sequence != s->exception_complete_sequence)
-				break;
-			s->exception_complete_sequence++;
-			list_del(&pe->out_of_order_entry);
-			complete_exception(pe);
-		}
-	} else {
-		struct list_head *lh;
-		struct dm_snap_pending_exception *pe2;
-
-		list_for_each_prev(lh, &s->out_of_order_list) {
-			pe2 = list_entry(lh, struct dm_snap_pending_exception, out_of_order_entry);
-			if (pe2->exception_sequence < pe->exception_sequence)
-				break;
-		}
-		list_add(&pe->out_of_order_entry, lh);
+		spin_lock(&s->completion_lock);
 	}
+	spin_unlock(&s->completion_lock);
 }
 
 /*
@@ -1649,13 +1632,16 @@ __find_pending_exception(struct dm_snapshot *s,
 	bio_list_init(&pe->snapshot_bios);
 	pe->started = 0;
 	pe->full_bio = NULL;
+	pe->completed = false;
 
 	if (s->store->type->prepare_exception(s->store, &pe->e)) {
 		free_pending_exception(pe);
 		return NULL;
 	}
 
-	pe->exception_sequence = s->exception_start_sequence++;
+	spin_lock(&s->completion_lock);
+	list_add_tail(&pe->out_of_order_entry, &s->out_of_order_list);
+	spin_unlock(&s->completion_lock);
 
 	dm_insert_exception(&s->pending, &pe->e);
 
-- 
2.11.0
