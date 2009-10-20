From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 03/17] dm snapshot: initial support for
	exception handover
Date: Tue, 20 Oct 2009 18:46:51 -0400
Message-ID: <1256078825-11331-4-git-send-email-snitzer@redhat.com>
References: <1256078825-11331-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1256078825-11331-1-git-send-email-snitzer@redhat.com>
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
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>

Handover of the exception store. This is needed for merging (to allow reload of
the table) and it also enables origin or snapshot resize.

The supported call sequences are:

new_snapshot->ctr
old_snapshot->suspend
old_snapshot->dtr
new_snapshot->resume

and

new_snapshot->ctr
old_snapshot->suspend
new_snapshot->resume
old_snapshot->dtr

There may not be more than two instances of a given snapshot.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>
---
 drivers/md/dm-snap.c |   85 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index be37439..b42c82e 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -75,6 +75,9 @@ struct dm_snapshot {
 	/* Set if the parent device is suspended */
 	int suspended;
 
+	/* Exception store will be handed over from another snapshot */
+	int handover;
+
 	mempool_t *pending_pool;
 
 	atomic_t pending_exceptions_count;
@@ -506,6 +509,33 @@ static int dm_add_exception(void *context, chunk_t old, chunk_t new)
 	return 0;
 }
 
+/* _origins_lock must be held */
+static struct dm_snapshot *__find_duplicate(struct dm_snapshot *snap)
+{
+	struct dm_snapshot *dup;
+	struct dm_snapshot *l;
+	struct origin *o;
+
+	o = __lookup_origin(snap->origin->bdev);
+	if (!o)
+		return NULL;
+
+	dup = NULL;
+	list_for_each_entry(l, &o->snapshots, list)
+		if (l != snap && bdev_equal(l->cow->bdev,
+					    snap->cow->bdev)) {
+			if (!dup) {
+				dup = l;
+			} else {
+				DMERR("Multiple active duplicates, "
+				      "user misuses dmsetup.");
+				return NULL;
+			}
+		}
+
+	return dup;
+}
+
 #define min_not_zero(l, r) (((l) == 0) ? (r) : (((r) == 0) ? (l) : min(l, r)))
 
 /*
@@ -637,6 +667,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	s->active = 0;
 	s->suspended = 0;
 	atomic_set(&s->pending_exceptions_count, 0);
+	s->handover = 0;
 	init_rwsem(&s->lock);
 	spin_lock_init(&s->pe_lock);
 
@@ -672,6 +703,11 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	spin_lock_init(&s->tracked_chunk_lock);
 
+	down_read(&_origins_lock);
+	if (__find_duplicate(s))
+		s->handover = 1;
+	up_read(&_origins_lock);
+
 	/* Metadata must only be loaded into one table at once */
 	r = s->store->type->read_metadata(s->store, dm_add_exception,
 					  (void *)s);
@@ -743,15 +779,49 @@ static void __free_exceptions(struct dm_snapshot *s)
 	dm_exception_table_exit(&s->complete, exception_cache);
 }
 
+static void handover_exceptions(struct dm_snapshot *old,
+				struct dm_snapshot *new)
+{
+	union {
+		struct dm_exception_table table_swap;
+		struct dm_exception_store *store_swap;
+	} u;
+
+	u.table_swap = new->complete;
+	new->complete = old->complete;
+	old->complete = u.table_swap;
+	u.store_swap = new->store;
+	new->store = old->store;
+	old->store = u.store_swap;
+
+	new->store->snap = new;
+	old->store->snap = old;
+
+	old->active = 0;
+	new->handover = 0;
+}
+
 static void snapshot_dtr(struct dm_target *ti)
 {
 #ifdef CONFIG_DM_DEBUG
 	int i;
 #endif
 	struct dm_snapshot *s = ti->private;
+	struct dm_snapshot *dup;
 
 	flush_workqueue(ksnapd);
 
+	down_write(&_origins_lock);
+	down_write(&s->lock);
+	dup = __find_duplicate(s);
+	if (dup && dup->handover) {
+		down_write_nested(&dup->lock, SINGLE_DEPTH_NESTING);
+		handover_exceptions(s, dup);
+		up_write(&dup->lock);
+	}
+	up_write(&s->lock);
+	up_write(&_origins_lock);
+
 	/* Prevent further origin writes from using this snapshot. */
 	/* After this returns there can be no new kcopyd jobs. */
 	unregister_snapshot(s);
@@ -1155,10 +1225,25 @@ static void snapshot_resume(struct dm_target *ti)
 {
 	struct dm_snapshot *s = ti->private;
 
+	down_write(&_origins_lock);
 	down_write(&s->lock);
+	if (s->handover) {
+		struct dm_snapshot *dup;
+		dup = __find_duplicate(s);
+		if (!dup) {
+			DMERR("duplicate not found");
+			s->valid = 0;
+			goto ret;
+		}
+		down_write_nested(&dup->lock, SINGLE_DEPTH_NESTING);
+		handover_exceptions(dup, s);
+		up_write(&dup->lock);
+	}
 	s->active = 1;
 	s->suspended = 0;
+ ret:
 	up_write(&s->lock);
+	up_write(&_origins_lock);
 }
 
 static int snapshot_status(struct dm_target *ti, status_type_t type,
-- 
1.6.5.rc2
