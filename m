From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm snapshot: introduce common
	__check_for_conflicting_io
Date: Fri,  4 Dec 2009 16:40:08 -0500
Message-ID: <1259962808-13939-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
List-Id: dm-devel.ids

Both existing callers of __chunk_is_tracked() address very rare races
with conflicting I/O.  In both cases the potential for conflict is so
improbable that the use of msleep(1) is warranted.

The justification for the pending_complete() call was introduced with
commit a8d41b59f3f5a7ac19452ef442a7fc1b5fa17366 ("dm snapshot: fix race
during exception creation").

In the case of snapshot_merge_process(), conflicting writes on a chunk
that is about to be merged is also quite rare.  For example, a linear
write to a device that has a background merge active, e.g. the root
device, will only trigger the msleep(1) once.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -236,6 +236,16 @@ static int __chunk_is_tracked(struct dm_
 }
 
 /*
+ * This conflicting I/O is extremely improbable in the caller,
+ * so msleep(1) is sufficient and there is no need for a wait queue.
+ */
+static void __check_for_conflicting_io(struct dm_snapshot *s, chunk_t chunk)
+{
+	while (__chunk_is_tracked(s, chunk))
+		msleep(1);
+}
+
+/*
  * One of these per registered origin, held in the snapshot_origins hash
  */
 struct origin {
@@ -832,10 +842,8 @@ test_again:
 	up_write(&s->lock);
 
 	/* Wait until writes to all 'linear_chunks' drain */
-	for (i = 0; i < linear_chunks; i++) {
-		while (__chunk_is_tracked(s, old_chunk + i))
-			msleep(1);
-	}
+	for (i = 0; i < linear_chunks; i++)
+		__check_for_conflicting_io(s, old_chunk + i);
 
 	dm_kcopyd_copy(s->kcopyd_client, &src, 1, &dest, 0, merge_callback, s);
 	return;
@@ -1340,12 +1348,8 @@ static void pending_complete(struct dm_s
 		goto out;
 	}
 
-	/*
-	 * Check for conflicting reads. This is extremely improbable,
-	 * so msleep(1) is sufficient and there is no need for a wait queue.
-	 */
-	while (__chunk_is_tracked(s, pe->e.old_chunk))
-		msleep(1);
+	/* Check for conflicting reads */
+	__check_for_conflicting_io(s, pe->e.old_chunk);
 
 	/*
 	 * Add a proper exception, and remove the
