From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 11/17] dm snapshot: the merge procedure
Date: Fri, 23 Oct 2009 12:19:37 -0400
Message-ID: <20091023161936.GB2651@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

From: Mikulas Patocka <mpatocka@redhat.com>

We don't need a separate thread, kcopyd does the job just fine
(provided that we have private kcopyd).

Merging is started when origin is resumed and it is stopped when
origin is suspended or when the merging snapshot is destoyed.

Merging is not interlocked with writes, so there is a race condition
with concurrent access. It will be fixed in further patches.

Adds a supporting function to decrement consecutive chunk counter.
Care is taken to increment the exception's old_chunk and new_chunk,
prior to the dm_consecutive_chunk_count_dec() call, if the chunk is at
the start of an exception's consecutive chunk range.  This allows for
snapshot-merge to support chunks that are added to the 'complete'
exception hash table before existing chunks.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-exception-store.h |   11 ++
 drivers/md/dm-snap.c            |  158 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 168 insertions(+), 1 deletion(-)

Index: linux-2.6-dev/drivers/md/dm-snap.c
===================================================================
--- linux-2.6-dev.orig/drivers/md/dm-snap.c
+++ linux-2.6-dev/drivers/md/dm-snap.c
@@ -121,6 +121,13 @@ struct dm_snapshot {
 	mempool_t *tracked_chunk_pool;
 	spinlock_t tracked_chunk_lock;
 	struct hlist_head tracked_chunk_hash[DM_TRACKED_CHUNK_HASH_SIZE];
+
+	/* Merge operation is in progress */
+	int merge_running;
+
+	/* It is requested to shut down merging */
+	/* Cleared back to 0 when the merging is stopped */
+	int merge_shutdown;
 };
 
 struct dm_dev *dm_snap_cow(struct dm_snapshot *s)
@@ -649,6 +656,124 @@ static int init_hash_tables(struct dm_sn
 	return 0;
 }
 
+static void merge_callback(int read_err, unsigned long write_err,
+			   void *context);
+
+static void snapshot_merge_process(struct dm_snapshot *s)
+{
+	int r;
+	chunk_t old_chunk, new_chunk;
+	struct dm_exception *e;
+	struct dm_io_region src, dest;
+
+	BUG_ON(!s->merge_running);
+	if (s->merge_shutdown)
+		goto shut;
+
+	if (!s->valid) {
+		DMERR("snapshot is invalid, can't merge");
+		goto shut;
+	}
+
+	r = s->store->type->prepare_merge(s->store, &old_chunk, &new_chunk);
+	if (r <= 0) {
+		if (r < 0)
+			DMERR("Read error in exception store, "
+			      "shutting down merge");
+		goto shut;
+	}
+
+	/* TODO: use larger I/O size once we verify that kcopyd handles it */
+
+	/* !!! FIXME: intelock writes to this chunk */
+	down_write(&s->lock);
+	e = dm_lookup_exception(&s->complete, old_chunk);
+	if (!e) {
+		DMERR("exception for block %llu is on disk but not in memory",
+		      (unsigned long long)old_chunk);
+		up_write(&s->lock);
+		goto shut;
+	}
+	if (dm_consecutive_chunk_count(e)) {
+		if (old_chunk == e->old_chunk) {
+			e->old_chunk++;
+			e->new_chunk++;
+		} else if (old_chunk != e->old_chunk +
+			   dm_consecutive_chunk_count(e)) {
+			DMERR("merge from the middle of a chunk range");
+			up_write(&s->lock);
+			goto shut;
+		}
+		dm_consecutive_chunk_count_dec(e);
+	} else {
+		dm_remove_exception(e);
+		free_completed_exception(e);
+	}
+	up_write(&s->lock);
+
+	dest.bdev = s->origin->bdev;
+	dest.sector = chunk_to_sector(s->store, old_chunk);
+	dest.count = min((sector_t)s->store->chunk_size,
+			 get_dev_size(dest.bdev) - dest.sector);
+
+	src.bdev = s->cow->bdev;
+	src.sector = chunk_to_sector(s->store, new_chunk);
+	src.count = dest.count;
+
+	dm_kcopyd_copy(s->kcopyd_client, &src, 1, &dest, 0, merge_callback, s);
+	return;
+
+shut:
+	s->merge_running = 0;
+}
+
+static void merge_callback(int read_err, unsigned long write_err, void *context)
+{
+	int r;
+	struct dm_snapshot *s = context;
+
+	if (read_err || write_err) {
+		if (read_err)
+			DMERR("Read error in data, shutting down merge");
+		else
+			DMERR("Write error in data, shutting down merge");
+		goto shut;
+	}
+
+	r = s->store->type->commit_merge(s->store, 1);
+	if (r < 0) {
+		DMERR("Write error in exception store, shutting down merge");
+		goto shut;
+	}
+
+	snapshot_merge_process(s);
+	return;
+
+shut:
+	s->merge_running = 0;
+}
+
+static void start_merge(struct dm_snapshot *merging)
+{
+	if (!merging->merge_running && !merging->merge_shutdown) {
+		merging->merge_running = 1;
+		snapshot_merge_process(merging);
+	}
+}
+
+/*
+ * Stop the merging process and wait until it finishes.
+ */
+
+static void stop_merge(struct dm_snapshot *merging)
+{
+	while (merging->merge_running) {
+		merging->merge_shutdown = 1;
+		msleep(1);
+	}
+	merging->merge_shutdown = 0;
+}
+
 /*
  * Construct a snapshot mapping: <origin_dev> <COW-dev> <p/n> <chunk-size>
  */
@@ -712,6 +837,8 @@ static int snapshot_ctr(struct dm_target
 	atomic_set(&s->pending_exceptions_count, 0);
 	s->handover = 0;
 	s->handover_snap = NULL;
+	s->merge_running = 0;
+	s->merge_shutdown = 0;
 	init_rwsem(&s->lock);
 	spin_lock_init(&s->pe_lock);
 
@@ -758,6 +885,15 @@ static int snapshot_ctr(struct dm_target
 				    "constructed with the same cow device.";
 			goto bad_load_and_register;
 		}
+
+		if (is_merge(ti) &&
+		    (!dup->store->type->prepare_merge ||
+		     !dup->store->type->commit_merge)) {
+			ti->error =
+				"Merging snapshot must support snapshot-merge";
+			goto bad_load_and_register;
+		}
+
 		/* cross reference snapshots that will do handover */
 		down_write(&dup->lock);
 		dup->handover_snap = s;
@@ -892,6 +1028,9 @@ static void snapshot_dtr(struct dm_targe
 	}
 	up_write(&s->lock);
 
+	if (is_merge(ti))
+		stop_merge(s);
+
 	/* Prevent further origin writes from using this snapshot. */
 	/* After this returns there can be no new kcopyd jobs. */
 	unregister_snapshot(s);
@@ -1345,6 +1484,22 @@ static void snapshot_resume(struct dm_ta
 	up_write(&s->lock);
 }
 
+static void snapshot_merge_resume(struct dm_target *ti)
+{
+	struct dm_snapshot *s = ti->private;
+
+	snapshot_resume(ti);
+	start_merge(s);
+}
+
+static void snapshot_merge_presuspend(struct dm_target *ti)
+{
+	struct dm_snapshot *s = ti->private;
+
+	snapshot_presuspend(ti);
+	stop_merge(s);
+}
+
 static int snapshot_status(struct dm_target *ti, status_type_t type,
 			   char *result, unsigned int maxlen)
 {
@@ -1657,7 +1812,8 @@ static struct target_type merge_target =
 	.dtr     = snapshot_dtr,
 	.map     = snapshot_merge_map,
 	.end_io  = snapshot_end_io,
-	.resume  = snapshot_resume,
+	.presuspend = snapshot_merge_presuspend,
+	.resume  = snapshot_merge_resume,
 	.status  = snapshot_status,
 	.iterate_devices = snapshot_iterate_devices,
 };
Index: linux-2.6-dev/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6-dev.orig/drivers/md/dm-exception-store.h
+++ linux-2.6-dev/drivers/md/dm-exception-store.h
@@ -157,6 +157,13 @@ static inline void dm_consecutive_chunk_
 	BUG_ON(!dm_consecutive_chunk_count(e));
 }
 
+static inline void dm_consecutive_chunk_count_dec(struct dm_exception *e)
+{
+	BUG_ON(!dm_consecutive_chunk_count(e));
+
+	e->new_chunk -= (1ULL << DM_CHUNK_NUMBER_BITS);
+}
+
 #  else
 #    define DM_CHUNK_CONSECUTIVE_BITS 0
 
@@ -174,6 +181,10 @@ static inline void dm_consecutive_chunk_
 {
 }
 
+static inline void dm_consecutive_chunk_count_dec(struct dm_exception *e)
+{
+}
+
 #  endif
 
 /*
