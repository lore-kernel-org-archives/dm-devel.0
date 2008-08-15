From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 03/10] dm snapshot: add
	lookup_completed_exception hook to struct exception_store
Date: Fri, 15 Aug 2008 15:42:44 +0900
Message-ID: <1218782571-15290-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1218782571-15290-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1218782571-15290-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1218782571-15290-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1218782571-15290-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
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
Cc: agk@redhat.com
List-Id: dm-devel.ids

The current two exception store implementations (persistent and
transient) always keep completed exceptions in memory. The problem is
that it doesn't scale.

This enables exception store implementations to use the own function
to look for a completed exception so that they can store exceptions at
any place such as disk.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/md/dm-snap.c |   38 +++++++++++++++++++++++++-------------
 drivers/md/dm-snap.h |    6 ++++++
 2 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 6e5528a..4f15b5f 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -347,6 +347,15 @@ static struct dm_snap_exception *lookup_exception(struct exception_table *et,
 	return NULL;
 }
 
+struct dm_snap_exception *lookup_complete_exception(struct dm_snapshot *s,
+						    chunk_t chunk)
+{
+	if (s->store.lookup_completed_exception)
+		return s->store.lookup_completed_exception(&s->store, chunk);
+	else
+		return lookup_exception(&s->complete, chunk);
+}
+
 static struct dm_snap_exception *alloc_exception(void)
 {
 	struct dm_snap_exception *e;
@@ -845,7 +854,7 @@ static struct bio *put_pending_exception(struct dm_snap_pending_exception *pe)
 
 static void pending_complete(struct dm_snap_pending_exception *pe, int success)
 {
-	struct dm_snap_exception *e;
+	struct dm_snap_exception *e = NULL;
 	struct dm_snapshot *s = pe->snap;
 	struct bio *origin_bios = NULL;
 	struct bio *snapshot_bios = NULL;
@@ -859,18 +868,21 @@ static void pending_complete(struct dm_snap_pending_exception *pe, int success)
 		goto out;
 	}
 
-	e = alloc_exception();
-	if (!e) {
-		down_write(&s->lock);
-		__invalidate_snapshot(s, -ENOMEM);
-		error = 1;
-		goto out;
+	if (!s->store.lookup_completed_exception) {
+		e = alloc_exception();
+		if (!e) {
+			down_write(&s->lock);
+			__invalidate_snapshot(s, -ENOMEM);
+			error = 1;
+			goto out;
+		}
+		*e = pe->e;
 	}
-	*e = pe->e;
 
 	down_write(&s->lock);
 	if (!s->valid) {
-		free_exception(e);
+		if (e)
+			free_exception(e);
 		error = 1;
 		goto out;
 	}
@@ -886,8 +898,8 @@ static void pending_complete(struct dm_snap_pending_exception *pe, int success)
 	 * Add a proper exception, and remove the
 	 * in-flight exception from the list.
 	 */
-	insert_completed_exception(s, e);
-
+	if (e)
+		insert_completed_exception(s, e);
  out:
 	remove_exception(&pe->e);
 	snapshot_bios = bio_list_get(&pe->snapshot_bios);
@@ -1053,7 +1065,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio,
 	}
 
 	/* If the block is already remapped - use that, else remap it */
-	e = lookup_exception(&s->complete, chunk);
+	e = lookup_complete_exception(s, chunk);
 	if (e) {
 		remap_exception(s, e, bio, chunk);
 		goto out_unlock;
@@ -1195,7 +1207,7 @@ static int __origin_write(struct list_head *snapshots, struct bio *bio)
 		 * ref_count is initialised to 1 so pending_complete()
 		 * won't destroy the primary_pe while we're inside this loop.
 		 */
-		e = lookup_exception(&snap->complete, chunk);
+		e = lookup_complete_exception(snap, chunk);
 		if (e)
 			goto next_snapshot;
 
diff --git a/drivers/md/dm-snap.h b/drivers/md/dm-snap.h
index 292c156..a830781 100644
--- a/drivers/md/dm-snap.h
+++ b/drivers/md/dm-snap.h
@@ -126,6 +126,12 @@ struct exception_store {
 			       sector_t *numerator,
 			       sector_t *denominator);
 
+	/*
+	 * look up if a chunk is in completed exception.
+	 */
+	struct dm_snap_exception *(*lookup_completed_exception)
+	(struct exception_store *store, chunk_t chunk);
+
 	struct dm_snapshot *snap;
 	void *context;
 };
-- 
1.5.5.GIT
