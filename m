From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 06/12] dm snapshot: the merge procedure
Date: Tue, 17 Nov 2009 11:12:18 -0500
Message-ID: <1258474344-10886-7-git-send-email-snitzer@redhat.com>
References: <1258474344-10886-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1258474344-10886-1-git-send-email-snitzer@redhat.com>
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
 drivers/md/dm-exception-store.h |   11 +++
 drivers/md/dm-snap.c            |  178 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 183 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-exception-store.h b/drivers/md/dm-exception-store.h
index 534427f..7b83002 100644
--- a/drivers/md/dm-exception-store.h
+++ b/drivers/md/dm-exception-store.h
@@ -153,6 +153,13 @@ static inline void dm_consecutive_chunk_count_inc(struct dm_exception *e)
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
 
@@ -170,6 +177,10 @@ static inline void dm_consecutive_chunk_count_inc(struct dm_exception *e)
 {
 }
 
+static inline void dm_consecutive_chunk_count_dec(struct dm_exception *e)
+{
+}
+
 #  endif
 
 /*
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 2a9fae9..f9aac21 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -117,6 +117,13 @@ struct dm_snapshot {
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
@@ -655,6 +662,123 @@ static int init_hash_tables(struct dm_snapshot *s)
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
+static void start_merge(struct dm_snapshot *s)
+{
+	if (!s->merge_running && !s->merge_shutdown) {
+		s->merge_running = 1;
+		snapshot_merge_process(s);
+	}
+}
+
+/*
+ * Stop the merging process and wait until it finishes.
+ */
+static void stop_merge(struct dm_snapshot *s)
+{
+	while (s->merge_running) {
+		s->merge_shutdown = 1;
+		msleep(1);
+	}
+	s->merge_shutdown = 0;
+}
+
 /*
  * Construct a snapshot mapping: <origin_dev> <COW-dev> <p/n> <chunk-size>
  */
@@ -720,6 +844,8 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	init_rwsem(&s->lock);
 	INIT_LIST_HEAD(&s->list);
 	spin_lock_init(&s->pe_lock);
+	s->merge_running = 0;
+	s->merge_shutdown = 0;
 
 	/* Allocate hash table for COW data */
 	if (init_hash_tables(s)) {
@@ -763,6 +889,13 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 				ti->error = "A snapshot is already merging.";
 				goto bad_load_and_register;
 			}
+
+			if (!handover_snap->store->type->prepare_merge ||
+			    !handover_snap->store->type->commit_merge) {
+				ti->error = "Merging snapshot store must "
+					    "support snapshot-merge";
+				goto bad_load_and_register;
+			}
 		}
 
 		down_write(&handover_snap->lock);
@@ -916,6 +1049,9 @@ static void snapshot_dtr(struct dm_target *ti)
 	}
 
 normal_snapshot:
+	if (is_merge(ti))
+		stop_merge(s);
+
 	/* Prevent further origin writes from using this snapshot. */
 	/* After this returns there can be no new kcopyd jobs. */
 	unregister_snapshot(s);
@@ -1340,6 +1476,13 @@ static int snapshot_end_io(struct dm_target *ti, struct bio *bio,
 	return 0;
 }
 
+static void snapshot_merge_presuspend(struct dm_target *ti)
+{
+	struct dm_snapshot *s = ti->private;
+
+	stop_merge(s);
+}
+
 static void snapshot_postsuspend(struct dm_target *ti)
 {
 	struct dm_snapshot *s = ti->private;
@@ -1419,6 +1562,32 @@ static void snapshot_resume(struct dm_target *ti)
 	up_write(&s->lock);
 }
 
+static chunk_t get_origin_minimum_chunksize(struct block_device *bdev)
+{
+	chunk_t min_chunksize;
+
+	down_read(&_origins_lock);
+
+	min_chunksize = __minimum_chunk_size(__lookup_origin(bdev));
+
+	up_read(&_origins_lock);
+
+	return min_chunksize;
+}
+
+static void snapshot_merge_resume(struct dm_target *ti)
+{
+	struct dm_snapshot *s = ti->private;
+
+	snapshot_resume(ti);
+	/*
+	 * snapshot-merge can take on the role of the origin too
+	 * - must adjust snapshot-merge's ti->split_io accordingly
+	 */
+	ti->split_io = get_origin_minimum_chunksize(s->origin->bdev);
+	start_merge(s);
+}
+
 static int snapshot_status(struct dm_target *ti, status_type_t type,
 			   char *result, unsigned int maxlen)
 {
@@ -1664,11 +1833,7 @@ static void origin_resume(struct dm_target *ti)
 {
 	struct dm_dev *dev = ti->private;
 
-	down_read(&_origins_lock);
-
-	ti->split_io = __minimum_chunk_size(__lookup_origin(dev->bdev));
-
-	up_read(&_origins_lock);
+	ti->split_io = get_origin_minimum_chunksize(dev->bdev);
 }
 
 static int origin_status(struct dm_target *ti, status_type_t type, char *result,
@@ -1732,9 +1897,10 @@ static struct target_type merge_target = {
 	.dtr     = snapshot_dtr,
 	.map     = snapshot_merge_map,
 	.end_io  = snapshot_end_io,
+	.presuspend = snapshot_merge_presuspend,
 	.postsuspend = snapshot_postsuspend,
 	.preresume  = snapshot_preresume,
-	.resume  = snapshot_resume,
+	.resume  = snapshot_merge_resume,
 	.status  = snapshot_status,
 	.iterate_devices = snapshot_iterate_devices,
 };
-- 
1.6.5.2
