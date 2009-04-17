From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] DM Snapshot:  snapshot-merge target
Date: Fri, 17 Apr 2009 14:04:42 -0500
Message-ID: <1239995082.30836.4.camel@hydrogen.msp.redhat.com>
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

This is just a concept at this stage, I may change the way the
implementation works... but it does work (as far as my light tests
show).

 brassow

This patch introduces the "snapshot-merge" target.  This target can be
used to merge a snapshot into an origin - amoung other uses.  The
constructor table is almost identical to the snapshot target.

snapshot table      : <start> <len> snapshot       <real-origin> <exstore args>
snapshot-merge table: <start> <len> snapshot-merge <virt-origin> <exstore args>

When you create a device-mapper "snapshot-origin" device, the device you
interface with is the 'virt-origin', while the device it covers is the
'real-origin'.

The benefit of using the 'virt-origin' in the snapshot-merge table is that
doing so will preserve all the other snapshots that were made against the
origin.  If you specify the 'real-origin', the other snapshots (the ones
you are not merging) would be corrupted.  [There are reasons for using the
underlying 'real' devices, though.  More on this later.]

The most common use for this target will be for "rollback" capability.  If
you are going to upgrade a machine, you first take a snapshot.  If the
upgrade fails, then you "merge" the snapshot deltas back into the origin -
restoring the pre-upgrade state.  [In this case, you would be sure to
use the 'virt-origin' in your snapshot-merge table.]

Another use of this target is for quick backups.  Imagine the following
method for backup (courtesy of Christophe Varoqui):
- snap lv_src (lv_src_snap0)
- full copy lv_src_snap0 to lv_dst
- while true
-	wait n seconds
-	snap lv_src (lv_src_snap1)
-	use snapshot-merge to copy deltas of lv_src_snap0 to lv_dst
-	remove lv_src_snap0
-	rename lv_src_snap1 lv_src_snap0
- done
In this case, you would use the lv_dst in place of the 'virt-origin'.
The tricky part in this case is that the origin can be under active
use, and the COW will be changing.  I don't have a good answer for this
yet, short of suspending the origin while the merge target is active.


Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -1263,8 +1263,26 @@ static int snapshot_status(struct dm_tar
 static int snapshot_message(struct dm_target *ti, unsigned argc, char **argv)
 {
 	int r = 0;
+	chunk_t old, new;
 	struct dm_snapshare *ss = ti->private;
 
+	if ((argc == 2) &&
+	    !strcmp(argv[0], "lookup")) {
+		if (sscanf(argv[1], "%lu", &old) != 1) {
+			DMERR("Failed to read in old chunk value");
+			return -EINVAL;
+		}
+		r = ss->store->type->lookup_exception(ss->store, old, &new,
+						      DM_ES_LOOKUP_EXISTS |
+						      DM_ES_LOOKUP_CAN_BLOCK);
+		new = dm_chunk_number(new);
+		if (!r)
+			DMERR("Exception found: %lu -> %lu", old, new);
+		else
+			DMERR("Exception not found: %d", r);
+		return 0;
+	}
+
 	if (ss->store->type->message)
 		r = ss->store->type->message(ss->store, argc, argv);
 
@@ -1517,6 +1535,307 @@ static int origin_status(struct dm_targe
 	return 0;
 }
 
+/*-----------------------------------------------------------------
+ * Snapshot-merge methods
+ *---------------------------------------------------------------*/
+struct dm_snapshot_merge {
+	struct dm_dev *usable_origin;
+
+	spinlock_t lock;
+
+	chunk_t nr_chunks;           /* total number of chunks */
+	chunk_t merge_progress;      /* Number of chunks completed */
+	struct bio_list queued_bios; /* Block All I/O until merge complete */
+
+	struct dm_exception_store *store;
+
+	struct work_struct merge_work;
+	struct dm_kcopyd_client *kcopyd_client;
+};
+
+static void merge_callback(int read_err, unsigned long write_err, void *context)
+{
+	struct dm_snapshot_merge *sm = context;
+
+	if (read_err || write_err) {
+		DMERR("Failed merge operation");
+		return;
+	}
+
+	spin_lock(&sm->lock);
+	sm->merge_progress++;
+	spin_unlock(&sm->lock);
+
+	schedule_work(&sm->merge_work);
+}
+
+static void merge_work(struct work_struct *work)
+{
+	int rtn;
+	struct bio *bio;
+	struct bio_list bl;
+	uint32_t flags = DM_ES_LOOKUP_EXISTS | DM_ES_LOOKUP_CAN_BLOCK;
+	chunk_t merge_chunk;
+	struct dm_io_region src, dest;
+	struct dm_snapshot_merge *sm =
+		container_of(work, struct dm_snapshot_merge, merge_work);
+
+	for (; sm->merge_progress < sm->nr_chunks;) {
+		rtn = sm->store->type->lookup_exception(sm->store,
+							sm->merge_progress,
+							&merge_chunk, flags);
+		merge_chunk = dm_chunk_number(merge_chunk);
+		if (!rtn) {
+			if (merge_chunk > sm->nr_chunks)
+				DMERR("merge_chunk out of range");
+			else
+				break;
+		} else
+			BUG_ON(rtn != -ENOENT);
+
+		spin_lock(&sm->lock);
+		/*
+		 * You can see that we are reading 'merge_progress' above
+		 * without the lock, but this is ok, because only this
+		 * function and 'merge_callback' increment 'merge_progress';
+		 * and 'merge_callback' is a result of this function.
+		 */
+		sm->merge_progress++;
+		spin_unlock(&sm->lock);
+	}
+
+	if (sm->merge_progress < sm->nr_chunks) {
+		src.bdev = sm->store->cow->bdev;
+		src.sector = chunk_to_sector(sm->store, merge_chunk);
+		src.count = sm->store->chunk_size;
+
+		dest.bdev = sm->usable_origin->bdev;
+		dest.sector = chunk_to_sector(sm->store, sm->merge_progress);
+		dest.count = src.count;
+
+		rtn = dm_kcopyd_copy(sm->kcopyd_client, &src, 1, &dest, 0,
+				     merge_callback, sm);
+		return;
+	}
+
+	/* Raise the event that the merging is completed */
+	dm_table_event(sm->store->ti->table);
+
+	spin_lock(&sm->lock);
+	bio_list_init(&bl);
+	bio_list_merge(&bl, &sm->queued_bios);
+	bio_list_init(&sm->queued_bios);
+	spin_unlock(&sm->lock);
+
+	/* bios in the list are already remapped and can be sent */
+	while ((bio = bio_list_pop(&bl)))
+		generic_make_request(bio);
+}
+
+/*
+ * snapshot_merge_ctr
+ * @ti
+ * @argc
+ * @argv
+ *
+ * Construct a snapshot mapping.  Possible mapping tables include:
+ *     <ORIGIN> <exception store args> <feature args>
+ * See 'create_exception_store' for format of <exception store args>.
+ *
+ * IMPORTANT:  The 'ORIGIN' argument must be the actual origin that
+ *             would be used.  This is unlike the 'origin' arguments
+ *             used in the origin_ctr or snapshot_ctr functions, which
+ *             are really just the "real device" under what the actual
+ *             user would consider the origin.
+ *
+ * Returns: 0 on success, -XXX on error
+ */
+static int snapshot_merge_ctr(struct dm_target *ti, unsigned argc, char **argv)
+{
+	int r;
+	unsigned args_used;
+	char *usable_origin_path;
+	struct dm_snapshot_merge *sm;
+
+	if (argc < 4) {
+		ti->error = "too few arguments";
+		return -EINVAL;
+	}
+
+	usable_origin_path = argv[0];
+	argv++;
+	argc--;
+
+	sm = kzalloc(sizeof(*sm), GFP_KERNEL);
+	if (!sm) {
+		ti->error = "Failed to allocate snapshot memory";
+		return -ENOMEM;
+	}
+
+	spin_lock_init(&sm->lock);
+	INIT_WORK(&sm->merge_work, merge_work);
+	bio_list_init(&sm->queued_bios);
+
+	r = create_exception_store(ti, argc, argv, &args_used, &sm->store);
+	if (r) {
+		ti->error = "Failed to create snapshot exception store";
+		goto bad_exception_store;
+	}
+
+	argv += args_used;
+	argc -= args_used;
+
+	sm->nr_chunks = ti->len / sm->store->chunk_size;
+	DMERR("There are %lu chunks to merge", sm->nr_chunks);
+
+	r = dm_get_device(ti, usable_origin_path, 0, ti->len,
+			  FMODE_READ | FMODE_WRITE, /* FMODE_EXCL ? */
+			  &sm->usable_origin);
+	if (r) {
+		ti->error = "Cannot get usable_origin device";
+		goto bad_origin;
+	}
+
+	r = dm_kcopyd_client_create(SNAPSHOT_PAGES, &sm->kcopyd_client);
+	if (r) {
+		DMERR("Could not create kcopyd client");
+		goto bad_kcopyd;
+	}
+
+	ti->private = sm;
+	return 0;
+
+bad_kcopyd:
+	dm_put_device(ti, sm->usable_origin);
+bad_origin:
+	dm_exception_store_destroy(sm->store);
+bad_exception_store:
+	kfree(sm);
+
+	return r;
+}
+
+static void snapshot_merge_dtr(struct dm_target *ti)
+{
+	struct dm_snapshot_merge *sm = ti->private;
+
+	dm_kcopyd_client_destroy(sm->kcopyd_client);
+
+	dm_put_device(ti, sm->usable_origin);
+
+	dm_exception_store_destroy(sm->store);
+
+	kfree(sm);
+}
+
+static int snapshot_merge_map(struct dm_target *ti, struct bio *bio,
+			      union map_info *map_context)
+{
+	int r = DM_MAPIO_SUBMITTED;
+	struct dm_snapshot_merge *sm = ti->private;
+
+	bio->bi_bdev = sm->usable_origin->bdev;
+
+	spin_lock(&sm->lock);
+
+	if (sm->merge_progress < sm->nr_chunks)
+		bio_list_add(&sm->queued_bios, bio);
+	else
+		r = DM_MAPIO_REMAPPED;
+
+	spin_unlock(&sm->lock);
+
+	return r;
+}
+
+static void snapshot_merge_resume(struct dm_target *ti)
+{
+	int r;
+	struct dm_snapshot_merge *sm = ti->private;
+
+	r = sm->store->type->resume(sm->store);
+	if (r)
+		DMERR("Exception store resume failed");
+
+	/* Start copying work */
+	schedule_work(&sm->merge_work);
+}
+
+static void snapshot_merge_presuspend(struct dm_target *ti)
+{
+	struct dm_snapshot_merge *sm = ti->private;
+
+	/* Wait for copy completion and flush I/O */
+	if (sm->store->type->presuspend)
+		sm->store->type->presuspend(sm->store);
+}
+
+static void snapshot_merge_postsuspend(struct dm_target *ti)
+{
+	struct dm_snapshot_merge *sm = ti->private;
+
+	/*
+	 * No need to wait for I/O to finish.
+	 * DM super-structure will do that for us.
+	 */
+	if (sm->store->type->postsuspend)
+		sm->store->type->postsuspend(sm->store);
+}
+
+static int snapshot_merge_status(struct dm_target *ti, status_type_t type,
+				 char *result, unsigned int maxlen)
+{
+	unsigned sz = 0;
+	struct dm_snapshot_merge *sm = ti->private;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		spin_lock(&sm->lock);
+
+		/* Report copy progress - similar to mirror sync progress */
+		DMEMIT("%lu/%lu", sm->merge_progress, sm->nr_chunks);
+		spin_unlock(&sm->lock);
+		break;
+	case STATUSTYPE_TABLE:
+		DMEMIT("%s", sm->usable_origin->name);
+		sm->store->type->status(sm->store, type, result + sz,
+					maxlen - sz);
+		break;
+	}
+
+	return 0;
+}
+
+static int snapshot_merge_message(struct dm_target *ti,
+				  unsigned argc, char **argv)
+{
+	int r = 0;
+	chunk_t old, new;
+	struct dm_snapshot_merge *sm = ti->private;
+
+	if ((argc == 2) &&
+	    !strcmp(argv[0], "lookup")) {
+		if (sscanf(argv[1], "%lu", &old) != 1) {
+			DMERR("Failed to read in old chunk value");
+			return -EINVAL;
+		}
+		r = sm->store->type->lookup_exception(sm->store, old, &new,
+						      DM_ES_LOOKUP_EXISTS |
+						      DM_ES_LOOKUP_CAN_BLOCK);
+		new = dm_chunk_number(new);
+		if (!r)
+			DMERR("Exception found: %lu -> %lu", old, new);
+		else
+			DMERR("Exception not found: %d", r);
+		return 0;
+	}
+
+	if (sm->store->type->message)
+		r = sm->store->type->message(sm->store, argc, argv);
+
+	return r;
+}
+
 static struct target_type origin_target = {
 	.name    = "snapshot-origin",
 	.version = {1, 6, 0},
@@ -1543,6 +1862,20 @@ static struct target_type snapshot_targe
 	.message = snapshot_message,
 };
 
+static struct target_type snapshot_merge_target = {
+	.name    = "snapshot-merge",
+	.version = {0, 1, 0},
+	.module  = THIS_MODULE,
+	.ctr     = snapshot_merge_ctr,
+	.dtr     = snapshot_merge_dtr,
+	.map     = snapshot_merge_map,
+	.resume  = snapshot_merge_resume,
+	.presuspend = snapshot_merge_presuspend,
+	.postsuspend = snapshot_merge_postsuspend,
+	.status  = snapshot_merge_status,
+	.message = snapshot_merge_message,
+};
+
 static int __init dm_snapshot_init(void)
 {
 	int r;
@@ -1553,6 +1886,12 @@ static int __init dm_snapshot_init(void)
 		return r;
 	}
 
+	r = dm_register_target(&snapshot_merge_target);
+	if (r) {
+		DMERR("snapshot-merge target register failed %d", r);
+		goto bad_merge_target;
+	}
+
 	r = dm_register_target(&snapshot_target);
 	if (r) {
 		DMERR("snapshot target register failed %d", r);
@@ -1605,6 +1944,8 @@ bad2:
 bad1:
 	dm_unregister_target(&snapshot_target);
 bad0:
+	dm_unregister_target(&snapshot_merge_target);
+bad_merge_target:
 	dm_exception_store_exit();
 	return r;
 }
@@ -1613,8 +1954,9 @@ static void __exit dm_snapshot_exit(void
 {
 	destroy_workqueue(ksnapd);
 
-	dm_unregister_target(&snapshot_target);
 	dm_unregister_target(&origin_target);
+	dm_unregister_target(&snapshot_target);
+	dm_unregister_target(&snapshot_merge_target);
 
 	exit_origin_hash();
 	kmem_cache_destroy(pending_cache);
