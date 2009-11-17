From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 07/12] dm snapshot: queue writes to an area
	that is actively being merged
Date: Tue, 17 Nov 2009 11:12:19 -0500
Message-ID: <1258474344-10886-8-git-send-email-snitzer@redhat.com>
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

New variables merge_write_interlock and merge_write_interlock_n
determine the chunk number (on the origin device) and number of chunks
that are being merged.  Writes to this area are held on the queue
merge_write_list.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |  119 +++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 88 insertions(+), 31 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index f9aac21..e37fc93 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -124,6 +124,16 @@ struct dm_snapshot {
 	/* It is requested to shut down merging */
 	/* Cleared back to 0 when the merging is stopped */
 	int merge_shutdown;
+
+	/* Merging this area --- block any writes */
+	chunk_t merge_write_interlock;
+	int merge_write_interlock_n;
+
+	/*
+	 * A list of requests that were delayed because
+	 * of racing with merge
+	 */
+	struct bio_list merge_write_list;
 };
 
 struct dm_dev *dm_snap_cow(struct dm_snapshot *s)
@@ -662,6 +672,9 @@ static int init_hash_tables(struct dm_snapshot *s)
 	return 0;
 }
 
+static void flush_bios(struct bio *bio);
+static void error_bios(struct bio *bio);
+
 static void merge_callback(int read_err, unsigned long write_err,
 			   void *context);
 
@@ -669,7 +682,6 @@ static void snapshot_merge_process(struct dm_snapshot *s)
 {
 	int r;
 	chunk_t old_chunk, new_chunk;
-	struct dm_exception *e;
 	struct dm_io_region src, dest;
 
 	BUG_ON(!s->merge_running);
@@ -691,32 +703,6 @@ static void snapshot_merge_process(struct dm_snapshot *s)
 
 	/* TODO: use larger I/O size once we verify that kcopyd handles it */
 
-	/* !!! FIXME: intelock writes to this chunk */
-	down_write(&s->lock);
-	e = dm_lookup_exception(&s->complete, old_chunk);
-	if (!e) {
-		DMERR("exception for block %llu is on disk but not in memory",
-		      (unsigned long long)old_chunk);
-		up_write(&s->lock);
-		goto shut;
-	}
-	if (dm_consecutive_chunk_count(e)) {
-		if (old_chunk == e->old_chunk) {
-			e->old_chunk++;
-			e->new_chunk++;
-		} else if (old_chunk != e->old_chunk +
-			   dm_consecutive_chunk_count(e)) {
-			DMERR("merge from the middle of a chunk range");
-			up_write(&s->lock);
-			goto shut;
-		}
-		dm_consecutive_chunk_count_dec(e);
-	} else {
-		dm_remove_exception(e);
-		free_completed_exception(e);
-	}
-	up_write(&s->lock);
-
 	dest.bdev = s->origin->bdev;
 	dest.sector = chunk_to_sector(s->store, old_chunk);
 	dest.count = min((sector_t)s->store->chunk_size,
@@ -726,6 +712,13 @@ static void snapshot_merge_process(struct dm_snapshot *s)
 	src.sector = chunk_to_sector(s->store, new_chunk);
 	src.count = dest.count;
 
+	down_write(&s->lock);
+	s->merge_write_interlock = old_chunk;
+	s->merge_write_interlock_n = 1;
+	up_write(&s->lock);
+
+	/* !!! FIXME: wait until writes to this chunk drain */
+
 	dm_kcopyd_copy(s->kcopyd_client, &src, 1, &dest, 0, merge_callback, s);
 	return;
 
@@ -733,10 +726,25 @@ shut:
 	s->merge_running = 0;
 }
 
+/* This function drops s->lock */
+static inline void release_write_interlock(struct dm_snapshot *s, int err)
+{
+	struct bio *b;
+	s->merge_write_interlock = 0;
+	s->merge_write_interlock_n = 0;
+	b = bio_list_get(&s->merge_write_list);
+	up_write(&s->lock);
+	if (!err)
+		flush_bios(b);
+	else
+		error_bios(b);
+}
+
 static void merge_callback(int read_err, unsigned long write_err, void *context)
 {
-	int r;
+	int r, i;
 	struct dm_snapshot *s = context;
+	struct dm_exception *e;
 
 	if (read_err || write_err) {
 		if (read_err)
@@ -746,16 +754,51 @@ static void merge_callback(int read_err, unsigned long write_err, void *context)
 		goto shut;
 	}
 
-	r = s->store->type->commit_merge(s->store, 1);
+	r = s->store->type->commit_merge(s->store, s->merge_write_interlock_n);
 	if (r < 0) {
 		DMERR("Write error in exception store, shutting down merge");
 		goto shut;
 	}
 
+	down_write(&s->lock);
+	/*
+	 * Must process chunks (and associated exceptions) in reverse
+	 * so that dm_consecutive_chunk_count_dec() accounting works
+	 */
+	for (i = s->merge_write_interlock_n - 1; i >= 0; i--) {
+		chunk_t old_chunk = s->merge_write_interlock + i;
+		e = dm_lookup_exception(&s->complete, old_chunk);
+		if (!e) {
+			DMERR("exception for block %llu is on "
+			      "disk but not in memory",
+			      (unsigned long long)old_chunk);
+			up_write(&s->lock);
+			goto shut;
+		}
+		if (dm_consecutive_chunk_count(e)) {
+			if (old_chunk == e->old_chunk) {
+				e->old_chunk++;
+				e->new_chunk++;
+			} else if (old_chunk != e->old_chunk +
+				   dm_consecutive_chunk_count(e)) {
+				DMERR("merge from the middle of a chunk range");
+				up_write(&s->lock);
+				goto shut;
+			}
+			dm_consecutive_chunk_count_dec(e);
+		} else {
+			dm_remove_exception(e);
+			free_completed_exception(e);
+		}
+	}
+	release_write_interlock(s, 0);
+
 	snapshot_merge_process(s);
 	return;
 
 shut:
+	down_write(&s->lock);
+	release_write_interlock(s, 1);
 	s->merge_running = 0;
 }
 
@@ -846,6 +889,9 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	spin_lock_init(&s->pe_lock);
 	s->merge_running = 0;
 	s->merge_shutdown = 0;
+	s->merge_write_interlock = 0;
+	s->merge_write_interlock_n = 0;
+	bio_list_init(&s->merge_write_list);
 
 	/* Allocate hash table for COW data */
 	if (init_hash_tables(s)) {
@@ -1440,7 +1486,7 @@ static int snapshot_merge_map(struct dm_target *ti, struct bio *bio,
 
 	chunk = sector_to_chunk(s->store, bio->bi_sector);
 
-	down_read(&s->lock);
+	down_write(&s->lock);
 
 	/* Full snapshots are not usable */
 	if (!s->valid) {
@@ -1451,6 +1497,17 @@ static int snapshot_merge_map(struct dm_target *ti, struct bio *bio,
 	/* If the block is already remapped - use that */
 	e = dm_lookup_exception(&s->complete, chunk);
 	if (e) {
+		/* We are copying this area --- so don't write to it */
+		if (bio_rw(bio) == WRITE &&
+		    chunk >= s->merge_write_interlock &&
+		    chunk < (s->merge_write_interlock +
+			     s->merge_write_interlock_n)) {
+			bio->bi_bdev = s->origin->bdev;
+			bio_list_add(&s->merge_write_list, bio);
+
+			r = DM_MAPIO_SUBMITTED;
+			goto out_unlock;
+		}
 		remap_exception(s, e, bio, chunk);
 		goto out_unlock;
 	}
@@ -1458,7 +1515,7 @@ static int snapshot_merge_map(struct dm_target *ti, struct bio *bio,
 	bio->bi_bdev = s->origin->bdev;
 
  out_unlock:
-	up_read(&s->lock);
+	up_write(&s->lock);
 
 	return r;
 }
-- 
1.6.5.2
