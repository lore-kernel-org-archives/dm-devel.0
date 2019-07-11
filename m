From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] dm snapshot: add optional discard support
	features
Date: Thu, 11 Jul 2019 16:46:34 -0400
Message-ID: <20190711204633.GA51116@lobo>
References: <20190703162504.GA34397@lobo>
	<fb809628-40e3-245a-dda4-034eee9a931b@arrikto.com>
	<20190711203611.GA51041@lobo>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190711203611.GA51041@lobo>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikos Tsironis <ntsironis@arrikto.com>
Cc: dm-devel@redhat.com, John Dorminy <jdorminy@redhat.com>
List-Id: dm-devel.ids

discard_zeroes_cow - a discard issued to the snapshot device that maps
to entire chunks to will zero the corresponding exception(s) in the
snapshot's exception store.

discard_passdown_origin - a discard to the snapshot device is passed down
to the snapshot-origin's underlying device.  This doesn't cause copy-out
to the snapshot exception store because the snapshot-origin target is
bypassed.

The discard_passdown_origin feature depends on the discard_zeroes_cow
feature being enabled.

When these 2 features are enabled they allow a temporarily read-only
device that has completely exhausted its free space to recover space.
To do so dm-snapshot provides temporary buffer to accommodate writes
that the temporarily read-only device cannot handle yet.  Once the upper
layer frees space (e.g. fstrim to XFS) the discards issued to the
dm-snapshot target will be issued to underlying read-only device whose
free space was exhausted.  In addition those discards will also cause
zeroes to be written to the snapshot exception store if corresponding
exceptions exist.  If the underlying origin device provides
deduplication for zero blocks then if/when the snapshot is merged backed
to the origin those blocks will become unused.  Once the origin has
gained adequate space, merging the snapshot back to the thinly
provisioned device will permit continued use of that device without the
temporary space provided by the snapshot.

Requested-by: John Dorminy <jdorminy@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 Documentation/device-mapper/snapshot.txt |  16 +++
 drivers/md/dm-snap.c                     | 186 +++++++++++++++++++++++++++----
 2 files changed, 181 insertions(+), 21 deletions(-)

diff --git a/Documentation/device-mapper/snapshot.txt b/Documentation/device-mapper/snapshot.txt
index b8bbb516f989..1810833f6dc6 100644
--- a/Documentation/device-mapper/snapshot.txt
+++ b/Documentation/device-mapper/snapshot.txt
@@ -31,6 +31,7 @@ its visible content unchanged, at least until the <COW device> fills up.
 
 
 *) snapshot <origin> <COW device> <persistent?> <chunksize>
+   [<# feature args> [<arg>]*]
 
 A snapshot of the <origin> block device is created. Changed chunks of
 <chunksize> sectors will be stored on the <COW device>.  Writes will
@@ -53,8 +54,23 @@ When loading or unloading the snapshot target, the corresponding
 snapshot-origin or snapshot-merge target must be suspended. A failure to
 suspend the origin target could result in data corruption.
 
+Optional features:
+
+   discard_zeroes_cow - a discard issued to the snapshot device that
+   maps to entire chunks to will zero the corresponding exception(s) in
+   the snapshot's exception store.
+
+   discard_passdown_origin - a discard to the snapshot device is passed
+   down to the snapshot-origin's underlying device.  This doesn't cause
+   copy-out to the snapshot exception store because the snapshot-origin
+   target is bypassed.
+
+   The discard_passdown_origin feature depends on the discard_zeroes_cow
+   feature being enabled.
+
 
 * snapshot-merge <origin> <COW device> <persistent> <chunksize>
+  [<# feature args> [<arg>]*]
 
 takes the same table arguments as the snapshot target except it only
 works with persistent snapshots.  This target assumes the role of the
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 3107f2b1988b..63916e1dc569 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1,6 +1,4 @@
 /*
- * dm-snapshot.c
- *
  * Copyright (C) 2001-2002 Sistina Software (UK) Limited.
  *
  * This file is released under the GPL.
@@ -134,7 +132,10 @@ struct dm_snapshot {
 	 * - I/O error while merging
 	 *	=> stop merging; set merge_failed; process I/O normally.
 	 */
-	int merge_failed;
+	bool merge_failed:1;
+
+	bool discard_zeroes_cow:1;
+	bool discard_passdown_origin:1;
 
 	/*
 	 * Incoming bios that overlap with chunks being merged must wait
@@ -1173,12 +1174,64 @@ static void stop_merge(struct dm_snapshot *s)
 	clear_bit(SHUTDOWN_MERGE, &s->state_bits);
 }
 
+static int parse_snapshot_features(struct dm_arg_set *as, struct dm_snapshot *s,
+				   struct dm_target *ti)
+{
+	int r;
+	unsigned argc;
+	const char *arg_name;
+
+	static const struct dm_arg _args[] = {
+		{0, 2, "Invalid number of feature arguments"},
+	};
+
+	/*
+	 * No feature arguments supplied.
+	 */
+	if (!as->argc)
+		return 0;
+
+	r = dm_read_arg_group(_args, as, &argc, &ti->error);
+	if (r)
+		return -EINVAL;
+
+	while (argc && !r) {
+		arg_name = dm_shift_arg(as);
+		argc--;
+
+		if (!strcasecmp(arg_name, "discard_zeroes_cow"))
+			s->discard_zeroes_cow = true;
+
+		else if (!strcasecmp(arg_name, "discard_passdown_origin"))
+			s->discard_passdown_origin = true;
+
+		else {
+			ti->error = "Unrecognised feature requested";
+			r = -EINVAL;
+			break;
+		}
+	}
+
+	if (!s->discard_zeroes_cow && s->discard_passdown_origin) {
+		/*
+		 * TODO: really these are disjoint.. but ti->num_discard_bios
+		 * and dm_bio_get_target_bio_nr() require rigid constraints.
+		 */
+		ti->error = "discard_passdown_origin feature depends on discard_zeroes_cow";
+		r = -EINVAL;
+	}
+
+	return r;
+}
+
 /*
- * Construct a snapshot mapping: <origin_dev> <COW-dev> <p|po|n> <chunk-size>
+ * Construct a snapshot mapping:
+ * <origin_dev> <COW-dev> <p|po|n> <chunk-size> [<# feature args> [<arg>]*]
  */
 static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct dm_snapshot *s;
+	struct dm_arg_set as;
 	int i;
 	int r = -EINVAL;
 	char *origin_path, *cow_path;
@@ -1186,8 +1239,8 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	unsigned args_used, num_flush_bios = 1;
 	fmode_t origin_mode = FMODE_READ;
 
-	if (argc != 4) {
-		ti->error = "requires exactly 4 arguments";
+	if (argc < 4) {
+		ti->error = "requires 4 or more arguments";
 		r = -EINVAL;
 		goto bad;
 	}
@@ -1204,6 +1257,13 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
+	as.argc = argc;
+	as.argv = argv;
+	dm_consume_args(&as, 4);
+	r = parse_snapshot_features(&as, s, ti);
+	if (r)
+		goto bad_features;
+
 	origin_path = argv[0];
 	argv++;
 	argc--;
@@ -1289,6 +1349,8 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	ti->private = s;
 	ti->num_flush_bios = num_flush_bios;
+	if (s->discard_zeroes_cow)
+		ti->num_discard_bios = (s->discard_passdown_origin ? 2 : 1);
 	ti->per_io_data_size = sizeof(struct dm_snap_tracked_chunk);
 
 	/* Add snapshot to the list of snapshots for this origin */
@@ -1336,29 +1398,22 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 bad_read_metadata:
 	unregister_snapshot(s);
-
 bad_load_and_register:
 	mempool_exit(&s->pending_pool);
-
 bad_pending_pool:
 	dm_kcopyd_client_destroy(s->kcopyd_client);
-
 bad_kcopyd:
 	dm_exception_table_exit(&s->pending, pending_cache);
 	dm_exception_table_exit(&s->complete, exception_cache);
-
 bad_hash_tables:
 	dm_exception_store_destroy(s->store);
-
 bad_store:
 	dm_put_device(ti, s->cow);
-
 bad_cow:
 	dm_put_device(ti, s->origin);
-
 bad_origin:
+bad_features:
 	kfree(s);
-
 bad:
 	return r;
 }
@@ -1806,6 +1861,37 @@ static void remap_exception(struct dm_snapshot *s, struct dm_exception *e,
 		(bio->bi_iter.bi_sector & s->store->chunk_mask);
 }
 
+static void zero_callback(int read_err, unsigned long write_err, void *context)
+{
+	struct bio *bio = context;
+	struct dm_snapshot *s = bio->bi_private;
+
+	up(&s->cow_count);
+	bio->bi_status = write_err ? BLK_STS_IOERR : 0;
+	bio_endio(bio);
+}
+
+static void zero_exception(struct dm_snapshot *s, struct dm_exception *e,
+			   struct bio *bio, chunk_t chunk)
+{
+	struct dm_io_region dest;
+
+	dest.bdev = s->cow->bdev;
+	dest.sector = bio->bi_iter.bi_sector;
+	dest.count = s->store->chunk_size;
+
+	down(&s->cow_count);
+	WARN_ON_ONCE(bio->bi_private);
+	bio->bi_private = s;
+	dm_kcopyd_zero(s->kcopyd_client, 1, &dest, 0, zero_callback, bio);
+}
+
+static bool io_overlaps_chunk(struct dm_snapshot *s, struct bio *bio)
+{
+	return bio->bi_iter.bi_size ==
+		(s->store->chunk_size << SECTOR_SHIFT);
+}
+
 static int snapshot_map(struct dm_target *ti, struct bio *bio)
 {
 	struct dm_exception *e;
@@ -1839,10 +1925,43 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 		goto out_unlock;
 	}
 
+	if (unlikely(bio_op(bio) == REQ_OP_DISCARD)) {
+		if (s->discard_passdown_origin && dm_bio_get_target_bio_nr(bio)) {
+			/*
+			 * passdown discard to origin (without triggering
+			 * snapshot exceptions via do_origin; doing so would
+			 * defeat the goal of freeing space in origin that is
+			 * implied by the "discard_passdown_origin" feature)
+			 */
+			bio_set_dev(bio, s->origin->bdev);
+			track_chunk(s, bio, chunk);
+			goto out_unlock;
+		}
+		/* discard to snapshot (target_bio_nr == 0) zeroes exceptions */
+	}
+
 	/* If the block is already remapped - use that, else remap it */
 	e = dm_lookup_exception(&s->complete, chunk);
 	if (e) {
 		remap_exception(s, e, bio, chunk);
+		if (unlikely(bio_op(bio) == REQ_OP_DISCARD) &&
+		    io_overlaps_chunk(s, bio)) {
+			dm_exception_table_unlock(&lock);
+			up_read(&s->lock);
+			zero_exception(s, e, bio, chunk);
+			r = DM_MAPIO_SUBMITTED; /* discard is not issued */
+			goto out;
+		}
+		goto out_unlock;
+	}
+
+	if (unlikely(bio_op(bio) == REQ_OP_DISCARD)) {
+		/*
+		 * If no exception exists, complete discard immediately
+		 * otherwise it'll trigger copy-out.
+		 */
+		bio_endio(bio);
+		r = DM_MAPIO_SUBMITTED;
 		goto out_unlock;
 	}
 
@@ -1890,9 +2009,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 
 		r = DM_MAPIO_SUBMITTED;
 
-		if (!pe->started &&
-		    bio->bi_iter.bi_size ==
-		    (s->store->chunk_size << SECTOR_SHIFT)) {
+		if (!pe->started && io_overlaps_chunk(s, bio)) {
 			pe->started = 1;
 
 			dm_exception_table_unlock(&lock);
@@ -2138,6 +2255,7 @@ static void snapshot_status(struct dm_target *ti, status_type_t type,
 {
 	unsigned sz = 0;
 	struct dm_snapshot *snap = ti->private;
+	unsigned num_features;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
@@ -2178,8 +2296,16 @@ static void snapshot_status(struct dm_target *ti, status_type_t type,
 		 * make sense.
 		 */
 		DMEMIT("%s %s", snap->origin->name, snap->cow->name);
-		snap->store->type->status(snap->store, type, result + sz,
-					  maxlen - sz);
+		sz += snap->store->type->status(snap->store, type, result + sz,
+						maxlen - sz);
+		num_features = snap->discard_zeroes_cow + snap->discard_passdown_origin;
+		if (num_features) {
+			DMEMIT(" %u", num_features);
+			if (snap->discard_zeroes_cow)
+				DMEMIT(" discard_zeroes_cow");
+			if (snap->discard_passdown_origin)
+				DMEMIT(" discard_passdown_origin");
+		}
 		break;
 	}
 }
@@ -2198,6 +2324,22 @@ static int snapshot_iterate_devices(struct dm_target *ti,
 	return r;
 }
 
+static void snapshot_io_hints(struct dm_target *ti, struct queue_limits *limits)
+{
+	struct dm_snapshot *snap = ti->private;
+
+	if (snap->discard_zeroes_cow) {
+		struct dm_snapshot *snap_src = NULL, *snap_dest = NULL;
+
+		(void) __find_snapshots_sharing_cow(snap, &snap_src, &snap_dest, NULL);
+		if (snap_src && snap_dest)
+			snap = snap_src;
+
+		/* All discards are split on chunk_size boundary */
+		limits->discard_granularity = snap->store->chunk_size;
+		limits->max_discard_sectors = snap->store->chunk_size;
+	}
+}
 
 /*-----------------------------------------------------------------
  * Origin methods
@@ -2522,7 +2664,7 @@ static struct target_type origin_target = {
 
 static struct target_type snapshot_target = {
 	.name    = "snapshot",
-	.version = {1, 15, 0},
+	.version = {1, 16, 0},
 	.module  = THIS_MODULE,
 	.ctr     = snapshot_ctr,
 	.dtr     = snapshot_dtr,
@@ -2532,11 +2674,12 @@ static struct target_type snapshot_target = {
 	.resume  = snapshot_resume,
 	.status  = snapshot_status,
 	.iterate_devices = snapshot_iterate_devices,
+	.io_hints = snapshot_io_hints,
 };
 
 static struct target_type merge_target = {
 	.name    = dm_snapshot_merge_target_name,
-	.version = {1, 4, 0},
+	.version = {1, 5, 0},
 	.module  = THIS_MODULE,
 	.ctr     = snapshot_ctr,
 	.dtr     = snapshot_dtr,
@@ -2547,6 +2690,7 @@ static struct target_type merge_target = {
 	.resume  = snapshot_merge_resume,
 	.status  = snapshot_status,
 	.iterate_devices = snapshot_iterate_devices,
+	.io_hints = snapshot_io_hints,
 };
 
 static int __init dm_snapshot_init(void)
-- 
2.15.0
