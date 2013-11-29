From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-snapshot: avoid snapshot space leak on crash
Date: Fri, 29 Nov 2013 18:13:37 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1311291813040.16583@file01.intranet.prod.int.rdu2.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

There is a possible leak of snapshot space in case of crash.

The reason for space leaking is that chunks in the snapshot device are
allocated sequentially, but they are finished (and stored in the metadata)
out of order, depending on the order in which copying finished.

For example, supposed that the metadata contains the following records
SUEPRBLOCK
METADATA (blocks 0 ... 250)
DATA 0
DATA 1
DATA 2
...
DATA 250

Now suppose that you allocate 10 new data blocks 251-260. Suppose, that
copying of these blocks finish out of order (with the block 260 finished
first and the block 251 finished last). Now, the snapshot device looks
like this:
SUPERBLOCK
METADATA (blocks 0 ... 250, 260, 259, 258, 257, 256)
DATA 0
DATA 1
DATA 2
...
DATA 250
DATA 251
DATA 252
DATA 253
DATA 254
DATA 255
METADATA (blocks 255, 254, 253, 252, 251)
DATA 256
DATA 257
DATA 258
DATA 259
DATA 260

Now, if the machine crashes after writing the first metadata block and
before writing the second metadata block, the space for areas DATA 250-255
is leaked, it contains no valid data and it will never be used in the
future.

This patch makes dm-snapshot complete exceptions in the same order they
were allocated, thus fixing this bug.


Note: when backporting this patch to the stable kernel, change the version
field in the following way:
* if version in the stable kernel is {1, 11, 1}, change it to {1, 12, 0}
* if version in the stable kernel is {1, 10, 0} or {1, 10, 1}, change it
  to {1, 10, 2}
Userspace reads the version to determine if the bug was fixed, so the
version change is needed.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@kernel.org

---
 drivers/md/dm-snap.c |   68 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 61 insertions(+), 7 deletions(-)

Index: linux-3.13-rc1/drivers/md/dm-snap.c
===================================================================
--- linux-3.13-rc1.orig/drivers/md/dm-snap.c	2013-11-30 00:00:26.000000000 +0100
+++ linux-3.13-rc1/drivers/md/dm-snap.c	2013-11-30 00:06:36.000000000 +0100
@@ -66,6 +66,18 @@ struct dm_snapshot {
 
 	atomic_t pending_exceptions_count;
 
+	/* Protected by "lock" */
+	sector_t exception_start_sequence;
+
+	/* Protected by kcopyd single-threaded callback */
+	sector_t exception_complete_sequence;
+
+	/*
+	 * A list of pending exceptions that completed out of order.
+	 * Protected by kcopyd single-threaded callback.
+	 */
+	struct list_head out_of_order_list;
+
 	mempool_t *pending_pool;
 
 	struct dm_exception_table pending;
@@ -173,6 +185,14 @@ struct dm_snap_pending_exception {
 	 */
 	int started;
 
+	/* There was copying error. */
+	int copy_error;
+
+	/* A sequence number, it is used for in-order completion. */
+	sector_t exception_sequence;
+
+	struct list_head out_of_order_entry;
+
 	/*
 	 * For writing a complete chunk, bypassing the copy.
 	 */
@@ -1094,6 +1114,9 @@ static int snapshot_ctr(struct dm_target
 	s->valid = 1;
 	s->active = 0;
 	atomic_set(&s->pending_exceptions_count, 0);
+	s->exception_start_sequence = 0;
+	s->exception_complete_sequence = 0;
+	INIT_LIST_HEAD(&s->out_of_order_list);
 	init_rwsem(&s->lock);
 	INIT_LIST_HEAD(&s->list);
 	spin_lock_init(&s->pe_lock);
@@ -1443,6 +1466,19 @@ static void commit_callback(void *contex
 	pending_complete(pe, success);
 }
 
+static void complete_exception(struct dm_snap_pending_exception *pe)
+{
+	struct dm_snapshot *s = pe->snap;
+
+	if (unlikely(pe->copy_error))
+		pending_complete(pe, 0);
+
+	else
+		/* Update the metadata if we are persistent */
+		s->store->type->commit_exception(s->store, &pe->e,
+						 commit_callback, pe);
+}
+
 /*
  * Called when the copy I/O has finished.  kcopyd actually runs
  * this code so don't block.
@@ -1452,13 +1488,29 @@ static void copy_callback(int read_err, 
 	struct dm_snap_pending_exception *pe = context;
 	struct dm_snapshot *s = pe->snap;
 
-	if (read_err || write_err)
-		pending_complete(pe, 0);
+	pe->copy_error = read_err || write_err;
 
-	else
-		/* Update the metadata if we are persistent */
-		s->store->type->commit_exception(s->store, &pe->e,
-						 commit_callback, pe);
+	if (pe->exception_sequence == s->exception_complete_sequence) {
+		s->exception_complete_sequence++;
+		complete_exception(pe);
+
+		while (!list_empty(&s->out_of_order_list)) {
+			pe = list_entry(s->out_of_order_list.next, struct dm_snap_pending_exception, out_of_order_entry);
+			if (pe->exception_sequence != s->exception_complete_sequence)
+				break;
+			s->exception_complete_sequence++;
+			list_del(&pe->out_of_order_entry);
+			complete_exception(pe);
+		}
+	} else {
+		struct list_head *lh;
+		list_for_each_prev(lh, &s->out_of_order_list) {
+			struct dm_snap_pending_exception *pe2 = list_entry(lh, struct dm_snap_pending_exception, out_of_order_entry);
+			if (pe2->exception_sequence < pe->exception_sequence)
+				break;
+		}
+		list_add(&pe->out_of_order_entry, lh);
+	}
 }
 
 /*
@@ -1553,6 +1605,8 @@ __find_pending_exception(struct dm_snaps
 		return NULL;
 	}
 
+	pe->exception_sequence = s->exception_start_sequence++;
+
 	dm_insert_exception(&s->pending, &pe->e);
 
 	return pe;
@@ -2192,7 +2246,7 @@ static struct target_type origin_target 
 
 static struct target_type snapshot_target = {
 	.name    = "snapshot",
-	.version = {1, 11, 1},
+	.version = {1, 12, 0},
 	.module  = THIS_MODULE,
 	.ctr     = snapshot_ctr,
 	.dtr     = snapshot_dtr,
