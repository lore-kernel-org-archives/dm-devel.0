From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 28 of 30] DM Snapshot: introduce snapshare (fix
	mistake)
Date: Fri, 20 Mar 2009 10:43:58 -0500
Message-ID: <1237563838.27055.12.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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

Made a mistake while trying to fix-up warnings from checkpatch.pl.
This repost fixes the introduced error.

 brassow

Patch name: dm-snap-introduce-snapshare.patch

This patch introduces the dm_snapshare structure - the structure that
will be used to share the dm_snapshot structure.  While each user-visible
snapshot will have a snapshare, if the back-end exception store is shared,
there will be sharing of the main dm_snapshot structure.  This allows us
to consume less space, make fewer exception store calls, and generally
reduce the amount of processing down per snapshot.

This patch creates the initial ties between the snapshare and snapshot
structures, sets up the constructor/destructor functions, and moves the
exception store to the snapshare structure.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -92,6 +92,20 @@ struct dm_snapshot {
 	struct hlist_head tracked_chunk_hash[DM_TRACKED_CHUNK_HASH_SIZE];
 };
 
+struct dm_snapshare {
+	struct dm_snapshot *snap;
+
+	struct list_head shared_list;
+
+	struct dm_dev *origin;
+
+	atomic_t pending_exceptions_count;
+	struct dm_exception_table *pending;
+
+	/* The on disk metadata handler */
+	struct dm_exception_store *store;
+};
+
 static struct workqueue_struct *ksnapd;
 static void flush_queued_bios(struct work_struct *work);
 
@@ -530,6 +544,7 @@ static int snapshot_ctr(struct dm_target
 {
 	sector_t hash_size, cow_dev_size, origin_dev_size, max_buckets;
 	struct dm_dev *origin;
+	struct dm_snapshare *ss;
 	struct dm_snapshot *s;
 	int i;
 	int r = -EINVAL;
@@ -546,11 +561,20 @@ static int snapshot_ctr(struct dm_target
 	argv++;
 	argc--;
 
+	ss = kzalloc(sizeof(*ss), GFP_KERNEL);
+	if (!ss) {
+		ti->error = "Failed to allocate snapshot memory";
+		return -ENOMEM;
+	}
+	INIT_LIST_HEAD(&ss->shared_list);
+	atomic_set(&ss->pending_exceptions_count, 0);
+
 	r = create_exception_store(ti, argc, argv, &args_used, &store);
 	if (r) {
 		ti->error = "Failed to create snapshot exception store";
-		return r;
+		goto bad_exception_store;
 	}
+	ss->store = store;
 
 	argv += args_used;
 	argc -= args_used;
@@ -586,9 +610,9 @@ static int snapshot_ctr(struct dm_target
 		ti->error = "Failed to create snapshot structure";
 		goto bad_alloc_snapshot;
 	}
-
+	ss->snap = s;
 	s->origin = origin;
-	s->store = store;
+	s->store = ss->store;
 
 	/* Add snapshot to the list of snapshots for this origin */
 	/* Exceptions aren't triggered till snapshot_resume() is called */
@@ -598,8 +622,8 @@ static int snapshot_ctr(struct dm_target
 		goto bad_load_and_register;
 	}
 
-	ti->private = s;
-	ti->split_io = s->store->chunk_size;
+	ti->private = ss;
+	ti->split_io = store->chunk_size;
 
 	return 0;
 
@@ -612,6 +636,9 @@ bad_alloc_snapshot:
 bad_origin:
 	dm_exception_store_destroy(store);
 
+bad_exception_store:
+	kfree(ss);
+
 	return r;
 }
 
@@ -620,7 +647,8 @@ static void snapshot_dtr(struct dm_targe
 #ifdef CONFIG_DM_DEBUG
 	int i;
 #endif
-	struct dm_snapshot *s = ti->private;
+	struct dm_snapshare *ss = ti->private;
+	struct dm_snapshot *s = ss->snap;
 
 	flush_workqueue(ksnapd);
 
@@ -643,9 +671,11 @@ static void snapshot_dtr(struct dm_targe
 
 	dm_put_device(ti, s->origin);
 
-	dm_exception_store_destroy(s->store);
-
 	dealloc_snapshot(s);
+
+	dm_exception_store_destroy(ss->store);
+
+	kfree(ss);
 }
 
 /*
@@ -843,7 +873,8 @@ static void start_copy(struct dm_snap_pe
  * this.
  */
 static struct dm_snap_pending_exception *
-__find_pending_exception(struct dm_snapshot *s, struct bio *bio, int group)
+__find_pending_exception(struct dm_snapshot *s, struct bio *bio,
+			 struct dm_snapshare *ss)
 {
 	struct dm_exception *e, *tmp_e;
 	struct dm_snap_pending_exception *pe;
@@ -887,7 +918,7 @@ __find_pending_exception(struct dm_snaps
 	atomic_set(&pe->ref_count, 0);
 	pe->started = 0;
 
-	if (s->store->type->prepare_exception(s->store, &pe->e, group)) {
+	if (s->store->type->prepare_exception(s->store, &pe->e, ss ? 0 : 1)) {
 		dm_free_exception(s->pending, &pe->e);
 		return NULL;
 	}
@@ -909,12 +940,13 @@ static void remap_exception(struct dm_sn
 static int snapshot_map(struct dm_target *ti, struct bio *bio,
 			union map_info *map_context)
 {
-	struct dm_snapshot *s = ti->private;
+	struct dm_snapshare *ss = ti->private;
+	struct dm_snapshot *s = ss->snap;
 	int rtn, r = DM_MAPIO_REMAPPED;
 	chunk_t chunk, new_chunk;
 	struct dm_snap_pending_exception *pe = NULL;
 
-	chunk = sector_to_chunk(s->store, bio->bi_sector);
+	chunk = sector_to_chunk(ss->store, bio->bi_sector);
 
 	/* Full snapshots are not usable */
 	/* To get here the table must be live so s->active is always set. */
@@ -931,7 +963,7 @@ static int snapshot_map(struct dm_target
 	}
 
 	/* If the block is already remapped - use that, else remap it */
-	rtn = s->store->type->lookup_exception(s->store, chunk, &new_chunk, 0, 0);
+	rtn = ss->store->type->lookup_exception(ss->store, chunk, &new_chunk, 0, 0);
 	if (!rtn) {
 		remap_exception(s, bio, new_chunk);
 		goto out_unlock;
@@ -950,7 +982,7 @@ static int snapshot_map(struct dm_target
 	 * writeable.
 	 */
 	if (bio_rw(bio) == WRITE) {
-		pe = __find_pending_exception(s, bio, 0);
+		pe = __find_pending_exception(s, bio, ss);
 		if (!pe) {
 			__invalidate_snapshot(s, -ENOMEM);
 			r = -EIO;
@@ -983,7 +1015,8 @@ out:
 static int snapshot_end_io(struct dm_target *ti, struct bio *bio,
 			   int error, union map_info *map_context)
 {
-	struct dm_snapshot *s = ti->private;
+	struct dm_snapshare *ss = ti->private;
+	struct dm_snapshot *s = ss->snap;
 	struct dm_snap_tracked_chunk *c = map_context->ptr;
 
 	if (c)
@@ -995,7 +1028,8 @@ static int snapshot_end_io(struct dm_tar
 static void snapshot_resume(struct dm_target *ti)
 {
 	int r;
-	struct dm_snapshot *s = ti->private;
+	struct dm_snapshare *ss = ti->private;
+	struct dm_snapshot *s = ss->snap;
 
 	/*
 	 * Target resumes cannot fail, which leaves us in a tight spot.
@@ -1004,47 +1038,50 @@ static void snapshot_resume(struct dm_ta
 	 * If invalid, mark the snapshot as such.  However, if other,
 	 * what can we do?  Mark 'not active'?
 	 */
-	r = s->store->type->resume(s->store);
+	r = ss->store->type->resume(ss->store);
+	down_write(&s->lock);
 	if (r == -EINVAL)
 		r = s->valid = 0;
+	else
+		s->active = (r) ? 0 : 1;
 
-	down_write(&s->lock);
 	s->active = (r) ? 0 : 1;
 	up_write(&s->lock);
 }
 
 static void snapshot_presuspend(struct dm_target *ti)
 {
-	struct dm_snapshot *s = ti->private;
+	struct dm_snapshare *ss = ti->private;
 
-	if (s->store->type->presuspend)
-		s->store->type->presuspend(s->store);
+	if (ss->store->type->presuspend)
+		ss->store->type->presuspend(ss->store);
 }
 
 static void snapshot_postsuspend(struct dm_target *ti)
 {
-	struct dm_snapshot *s = ti->private;
+	struct dm_snapshare *ss = ti->private;
 
-	if (s->store->type->postsuspend)
-		s->store->type->postsuspend(s->store);
+	if (ss->store->type->postsuspend)
+		ss->store->type->postsuspend(ss->store);
 }
 
 static int snapshot_status(struct dm_target *ti, status_type_t type,
 			   char *result, unsigned int maxlen)
 {
 	unsigned int sz = 0;
-	struct dm_snapshot *snap = ti->private;
+	struct dm_snapshare *ss = ti->private;
+	struct dm_snapshot *s = ss->snap;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
-		if (!snap->valid)
+		if (!s->valid)
 			DMEMIT("Invalid");
 		else {
-			if (snap->store->type->fraction_full) {
+			if (ss->store->type->fraction_full) {
 				sector_t numerator, denominator;
-				snap->store->type->fraction_full(snap->store,
-								 &numerator,
-								 &denominator);
+				ss->store->type->fraction_full(ss->store,
+							       &numerator,
+							       &denominator);
 				DMEMIT("%llu/%llu",
 				       (unsigned long long)numerator,
 				       (unsigned long long)denominator);
@@ -1060,9 +1097,9 @@ static int snapshot_status(struct dm_tar
 		 * to make private copies if the output is to
 		 * make sense.
 		 */
-		DMEMIT("%s ", snap->origin->name);
-		snap->store->type->status(snap->store, type,
-					  result+sz, maxlen-sz);
+		DMEMIT("%s ", s->origin->name);
+		ss->store->type->status(ss->store, type,
+					result+sz, maxlen-sz);
 		break;
 	}
 
@@ -1072,10 +1109,10 @@ static int snapshot_status(struct dm_tar
 static int snapshot_message(struct dm_target *ti, unsigned argc, char **argv)
 {
 	int r = 0;
-	struct dm_snapshot *s = ti->private;
+	struct dm_snapshare *ss = ti->private;
 
-	if (s->store->type->message)
-		r = s->store->type->message(s->store, argc, argv);
+	if (ss->store->type->message)
+		r = ss->store->type->message(ss->store, argc, argv);
 
 	return r;
 }
@@ -1130,7 +1167,7 @@ static int __origin_write(struct list_he
 		 */
 		BUG_ON(rtn != -ENOENT);
 
-		pe = __find_pending_exception(snap, bio, 1);
+		pe = __find_pending_exception(snap, bio, NULL);
 		if (!pe) {
 			__invalidate_snapshot(snap, -ENOMEM);
 			goto next_snapshot;
