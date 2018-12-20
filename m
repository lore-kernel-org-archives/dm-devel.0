From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: [PATCH 2/3] dm snapshot: Don't sleep holding the
	snapshot lock
Date: Thu, 20 Dec 2018 20:06:50 +0200
Message-ID: <20181220180651.4879-3-ntsironis@arrikto.com>
References: <20181220180651.4879-1-ntsironis@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181220180651.4879-1-ntsironis@arrikto.com>
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
Cc: mpatocka@redhat.com, iliastsi@arrikto.com
List-Id: dm-devel.ids

When completing a pending exception, pending_complete() waits for all
conflicting reads to drain, before inserting the final, completed
exception. Conflicting reads are snapshot reads redirected to the
origin, because the relevant chunk is not remapped to the COW device the
moment we receive the read.

The completed exception must be inserted into the exception table after
all conflicting reads drain to ensure snapshot reads don't return
corrupted data. This is required because inserting the completed
exception into the exception table signals that the relevant chunk is
remapped and both origin writes and snapshot merging will now overwrite
the chunk in origin.

This wait is done holding the snapshot lock to ensure that
pending_complete() doesn't starve if new snapshot reads keep coming for
this chunk.

In preparation for the next commit, where we use a spinlock instead of a
mutex to protect the exception tables, we remove the need for holding
the lock while waiting for conflicting reads to drain.

We achieve this in two steps:

1. pending_complete() inserts the completed exception before waiting for
   conflicting reads to drain and removes the pending exception after
   all conflicting reads drain.

   This ensures that new snapshot reads will be redirected to the COW
   device, instead of the origin, and thus pending_complete() will not
   starve. Moreover, we use the existence of both a completed and
   a pending exception to signify that the COW is done but there are
   conflicting reads in flight.

2. In __origin_write() we check first if there is a pending exception
   and then if there is a completed exception. If there is a pending
   exception any submitted BIO is delayed on the pe->origin_bios list and
   DM_MAPIO_SUBMITTED is returned. This ensures that neither writes to the
   origin nor snapshot merging can overwrite the origin chunk, until all
   conflicting reads drain, and thus snapshot reads will not return
   corrupted data.

Summarizing, we now have the following possible combinations of pending
and completed exceptions for a chunk, along with their meaning:

A. No exceptions exist: The chunk has not been remapped yet.
B. Only a pending exception exists: The chunk is currently being copied
   to the COW device.
C. Both a pending and a completed exception exist: COW for this chunk
   has completed but there are snapshot reads in flight which had been
   redirected to the origin before the chunk was remapped.
D. Only the completed exception exists: COW has been completed and there
   are no conflicting reads in flight.

Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Signed-off-by: Ilias Tsitsimpis <iliastsi@arrikto.com>
---
 drivers/md/dm-snap.c | 102 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 65 insertions(+), 37 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 36805b12661e..4b34bfa0900a 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1501,16 +1501,24 @@ static void pending_complete(void *context, int success)
 		goto out;
 	}
 
-	/* Check for conflicting reads */
-	__check_for_conflicting_io(s, pe->e.old_chunk);
-
 	/*
-	 * Add a proper exception, and remove the
-	 * in-flight exception from the list.
+	 * Add a proper exception. After inserting the completed exception all
+	 * subsequent snapshot reads to this chunk will be redirected to the
+	 * COW device.  This ensures that we do not starve. Moreover, as long
+	 * as the pending exception exists, neither origin writes nor snapshot
+	 * merging can overwrite the chunk in origin.
 	 */
 	dm_insert_exception(&s->complete, e);
 
+	/* Wait for conflicting reads to drain */
+	if (__chunk_is_tracked(s, pe->e.old_chunk)) {
+		mutex_unlock(&s->lock);
+		__check_for_conflicting_io(s, pe->e.old_chunk);
+		mutex_lock(&s->lock);
+	}
+
 out:
+	/* Remove the in-flight exception from the list */
 	dm_remove_exception(&pe->e);
 	snapshot_bios = bio_list_get(&pe->snapshot_bios);
 	origin_bios = bio_list_get(&pe->origin_bios);
@@ -1660,25 +1668,15 @@ __lookup_pending_exception(struct dm_snapshot *s, chunk_t chunk)
 }
 
 /*
- * Looks to see if this snapshot already has a pending exception
- * for this chunk, otherwise it allocates a new one and inserts
- * it into the pending table.
+ * Inserts a pending exception into the pending table.
  *
  * NOTE: a write lock must be held on snap->lock before calling
  * this.
  */
 static struct dm_snap_pending_exception *
-__find_pending_exception(struct dm_snapshot *s,
-			 struct dm_snap_pending_exception *pe, chunk_t chunk)
+__insert_pending_exception(struct dm_snapshot *s,
+			   struct dm_snap_pending_exception *pe, chunk_t chunk)
 {
-	struct dm_snap_pending_exception *pe2;
-
-	pe2 = __lookup_pending_exception(s, chunk);
-	if (pe2) {
-		free_pending_exception(pe);
-		return pe2;
-	}
-
 	pe->e.old_chunk = chunk;
 	bio_list_init(&pe->origin_bios);
 	bio_list_init(&pe->snapshot_bios);
@@ -1697,6 +1695,29 @@ __find_pending_exception(struct dm_snapshot *s,
 	return pe;
 }
 
+/*
+ * Looks to see if this snapshot already has a pending exception
+ * for this chunk, otherwise it allocates a new one and inserts
+ * it into the pending table.
+ *
+ * NOTE: a write lock must be held on snap->lock before calling
+ * this.
+ */
+static struct dm_snap_pending_exception *
+__find_pending_exception(struct dm_snapshot *s,
+			 struct dm_snap_pending_exception *pe, chunk_t chunk)
+{
+	struct dm_snap_pending_exception *pe2;
+
+	pe2 = __lookup_pending_exception(s, chunk);
+	if (pe2) {
+		free_pending_exception(pe);
+		return pe2;
+	}
+
+	return __insert_pending_exception(s, pe, chunk);
+}
+
 static void remap_exception(struct dm_snapshot *s, struct dm_exception *e,
 			    struct bio *bio, chunk_t chunk)
 {
@@ -2107,7 +2128,7 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
 	int r = DM_MAPIO_REMAPPED;
 	struct dm_snapshot *snap;
 	struct dm_exception *e;
-	struct dm_snap_pending_exception *pe;
+	struct dm_snap_pending_exception *pe, *pe2;
 	struct dm_snap_pending_exception *pe_to_start_now = NULL;
 	struct dm_snap_pending_exception *pe_to_start_last = NULL;
 	chunk_t chunk;
@@ -2137,17 +2158,17 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
 		 */
 		chunk = sector_to_chunk(snap->store, sector);
 
-		/*
-		 * Check exception table to see if block
-		 * is already remapped in this snapshot
-		 * and trigger an exception if not.
-		 */
-		e = dm_lookup_exception(&snap->complete, chunk);
-		if (e)
-			goto next_snapshot;
-
 		pe = __lookup_pending_exception(snap, chunk);
 		if (!pe) {
+			/*
+			 * Check exception table to see if block is already
+			 * remapped in this snapshot and trigger an exception
+			 * if not.
+			 */
+			e = dm_lookup_exception(&snap->complete, chunk);
+			if (e)
+				goto next_snapshot;
+
 			mutex_unlock(&snap->lock);
 			pe = alloc_pending_exception(snap);
 			mutex_lock(&snap->lock);
@@ -2157,16 +2178,23 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
 				goto next_snapshot;
 			}
 
-			e = dm_lookup_exception(&snap->complete, chunk);
-			if (e) {
+			pe2 = __lookup_pending_exception(snap, chunk);
+
+			if (!pe2) {
+				e = dm_lookup_exception(&snap->complete, chunk);
+				if (e) {
+					free_pending_exception(pe);
+					goto next_snapshot;
+				}
+
+				pe = __insert_pending_exception(snap, pe, chunk);
+				if (!pe) {
+					__invalidate_snapshot(snap, -ENOMEM);
+					goto next_snapshot;
+				}
+			} else {
 				free_pending_exception(pe);
-				goto next_snapshot;
-			}
-
-			pe = __find_pending_exception(snap, pe, chunk);
-			if (!pe) {
-				__invalidate_snapshot(snap, -ENOMEM);
-				goto next_snapshot;
+				pe = pe2;
 			}
 		}
 
-- 
2.11.0
