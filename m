From: Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 10/10] dm snapshot: Add snapshot merging code
Date: Tue,  1 Apr 2008 09:32:57 +0200
Message-ID: <1207035177-7156-11-git-send-email-markmc@redhat.com>
References: <1207035177-7156-1-git-send-email-markmc@redhat.com>
	<1207035177-7156-2-git-send-email-markmc@redhat.com>
	<1207035177-7156-3-git-send-email-markmc@redhat.com>
	<1207035177-7156-4-git-send-email-markmc@redhat.com>
	<1207035177-7156-5-git-send-email-markmc@redhat.com>
	<1207035177-7156-6-git-send-email-markmc@redhat.com>
	<1207035177-7156-7-git-send-email-markmc@redhat.com>
	<1207035177-7156-8-git-send-email-markmc@redhat.com>
	<1207035177-7156-9-git-send-email-markmc@redhat.com>
	<1207035177-7156-10-git-send-email-markmc@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1207035177-7156-10-git-send-email-markmc@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: Mark McLoughlin <markmc@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Add the code to actually perform the incremental merging of chunks
from the COW device to the origin device.

Chunks are merged one at a time by ksnapd. While a merge is in
progress the merging mutex is held, allowing us to disable merging
while the target is supended.

We take care not to initiate a copy from the COW device while there
are writes pending on the chunk in question. Likewise we take care to
delay any writes to a chunk while the chunk is being merged.

The merging_work pointer added to the pending_exception structure
allows us to indicate that ksnapd should be woken up when the I/O on
that chunk has completed or when all other associated snapshots have
finished copying the chunk to their COW device. This pointer is
protected by the pe_lock spinlock.

The old_chunk, new_chunk and delayed_bios members of the dm_merged
structure are all protected by the read/write mutex in the dm_snapshot
structure.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/md/dm-snap.c |  233 +++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/md/dm-snap.h |   16 ++++
 2 files changed, 235 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index bc13f35..b2b9762 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -76,6 +76,14 @@ struct dm_snap_pending_exception {
 	 */
 	atomic_t ref_count;
 
+	/*
+	 * If set, merging of a chunk is blocked until all snapshots
+	 * have finished copying the chunk from the origin device
+	 * and until all writes to the chunk on the COW device have
+	 * completed.
+	 */
+	struct work_struct *merging_work;
+
 	/* Pointer back to snapshot context */
 	struct dm_snapshot *snap;
 
@@ -752,6 +760,8 @@ static struct bio *put_pending_exception(struct dm_snap_pending_exception *pe)
 	 */
 	if ((!primary_pe || primary_pe != pe) &&
 	    atomic_dec_and_test(&pe->ref_count)) {
+		if (pe->merging_work)
+			queue_work(ksnapd, pe->merging_work);
 		remove_exception(&pe->e);
 		free_pending_exception(pe);
 	}
@@ -760,6 +770,8 @@ static struct bio *put_pending_exception(struct dm_snap_pending_exception *pe)
 	 * Free the primary pe if nothing references it.
 	 */
 	if (primary_pe && !atomic_read(&primary_pe->ref_count)) {
+		if (primary_pe->merging_work)
+			queue_work(ksnapd, primary_pe->merging_work);
 		remove_exception(&primary_pe->e);
 		free_pending_exception(primary_pe);
 	}
@@ -927,6 +939,7 @@ __find_pending_exception(struct dm_snapshot *s, chunk_t chunk, int prepare)
 	bio_list_init(&pe->snapshot_bios);
 	pe->primary_pe = NULL;
 	atomic_set(&pe->ref_count, 0);
+	pe->merging_work = NULL;
 	pe->snap = s;
 	pe->started = 0;
 
@@ -1104,7 +1117,7 @@ static int snapshot_status(struct dm_target *ti, status_type_t type,
  * Origin methods
  *---------------------------------------------------------------*/
 static int __origin_write(struct list_head *snapshots, sector_t sector,
-			  struct bio *bio)
+			  struct bio *bio, struct work_struct *merging_work)
 {
 	int r = DM_MAPIO_REMAPPED;
 	struct dm_snapshot *snap;
@@ -1169,6 +1182,8 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
 
 			if (bio)
 				bio_list_add(&primary_pe->origin_bios, bio);
+			if (merging_work)
+				primary_pe->merging_work = merging_work;
 
 			r = DM_MAPIO_SUBMITTED;
 		}
@@ -1215,7 +1230,7 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
  * Called on a write from the origin driver.
  */
 static int do_origin(struct dm_dev *origin, sector_t sector,
-		     struct bio *bio)
+		     struct bio *bio, struct work_struct *merging_work)
 {
 	struct origin *o;
 	int r = DM_MAPIO_REMAPPED;
@@ -1223,7 +1238,7 @@ static int do_origin(struct dm_dev *origin, sector_t sector,
 	down_read(&_origins_lock);
 	o = __lookup_origin(origin->bdev);
 	if (o)
-		r = __origin_write(&o->snapshots, sector, bio);
+		r = __origin_write(&o->snapshots, sector, bio, merging_work);
 	up_read(&_origins_lock);
 
 	return r;
@@ -1276,7 +1291,7 @@ static int origin_map(struct dm_target *ti, struct bio *bio,
 	if (bio_rw(bio) != WRITE)
 		return DM_MAPIO_REMAPPED;
 
-	return do_origin(dev, bio->bi_sector, bio);
+	return do_origin(dev, bio->bi_sector, bio, NULL);
 }
 
 #define min_not_zero(l, r) (l == 0) ? r : ((r == 0) ? l : min(l, r))
@@ -1326,6 +1341,167 @@ static int origin_status(struct dm_target *ti, status_type_t type, char *result,
 	return 0;
 }
 
+#define MERGE_COMPLETE_BIT 0
+#define MERGE_ERROR_BIT    1
+
+static inline void set_merge_complete(struct dm_merged *merged)
+{
+	set_bit(MERGE_COMPLETE_BIT, &merged->status);
+}
+
+static inline void set_merge_error(struct dm_merged *merged)
+{
+	set_bit(MERGE_ERROR_BIT, &merged->status);
+}
+
+static inline int get_merge_complete(struct dm_merged *merged)
+{
+	return test_and_clear_bit(MERGE_COMPLETE_BIT, &merged->status);
+}
+
+static inline int get_merge_error(struct dm_merged *merged)
+{
+	return test_and_clear_bit(MERGE_ERROR_BIT, &merged->status);
+}
+
+static void merge_callback(int read_err, unsigned int write_err, void *context)
+{
+	struct dm_merged *merged = (struct dm_merged *) context;
+
+	if (read_err || write_err)
+		set_merge_error(merged);
+
+	set_merge_complete(merged);
+
+	queue_work(ksnapd, &merged->merging_work);
+}
+
+static int start_merge(struct dm_merged *merged)
+{
+	struct dm_snapshot *s = &merged->snap;
+	struct io_region src, dest;
+	sector_t dev_size, old_sector;
+	struct dm_snap_exception e;
+	struct dm_snap_pending_exception *pe;
+	unsigned long flags;
+	int empty;
+	int r;
+
+	down_write(&s->lock);
+
+	if (merged->new_chunk == 0) {
+		r = s->store.prepare_merge(&s->store, &e, &empty);
+		if (r || empty) {
+			if (empty)
+				dm_table_event(s->table);
+			up_write(&s->lock);
+			return 0;
+		}
+
+		merged->old_chunk = e.old_chunk;
+		merged->new_chunk = e.new_chunk;
+	}
+
+	spin_lock_irqsave(&s->pe_lock, flags);
+
+	pe = (struct dm_snap_pending_exception *)
+		lookup_exception(&s->pending, merged->old_chunk);
+	if (pe) {
+		pe->merging_work = &merged->merging_work;
+		spin_unlock_irqrestore(&s->pe_lock, flags);
+		up_write(&s->lock);
+		return 0; /* punt the copy until pending I/O complete */
+	}
+
+	spin_unlock_irqrestore(&s->pe_lock, flags);
+
+	up_write(&s->lock);
+
+	old_sector = chunk_to_sector(s, merged->old_chunk);
+
+	r = do_origin(s->origin, old_sector, NULL, &merged->merging_work);
+	if (r <= 0)
+		return 0; /* punt until other snapshots finish copying */
+
+	dev_size = get_dev_size(s->origin->bdev);
+
+	dest.bdev = s->origin->bdev;
+	dest.sector = old_sector;
+	dest.count = min(s->chunk_size, dev_size - dest.sector);
+
+	src.bdev = s->cow->bdev;
+	src.sector = chunk_to_sector(s, merged->new_chunk);
+	src.count = dest.count;
+
+	r = kcopyd_copy(s->kcopyd_client, &src, 1, &dest, 0,
+			merge_callback, merged);
+	return r == 0;
+}
+
+static int end_merge(struct dm_merged *merged, int *error)
+{
+	struct dm_snapshot *s = &merged->snap;
+	struct dm_snap_exception *e;
+	struct bio *bio;
+	int r;
+
+	if (!get_merge_complete(merged))
+		return 0;
+
+	*error = get_merge_error(merged);
+
+	down_write(&s->lock);
+
+	e = lookup_exception(&s->complete, merged->old_chunk);
+	BUG_ON(!e);
+
+	merged->old_chunk = 0;
+	merged->new_chunk = 0;
+
+	if (*error) {
+		up_write(&s->lock);
+		return 1;
+	}
+
+	while ((bio = bio_list_pop(&merged->delayed_bios))) {
+		r = do_origin(s->origin, bio->bi_sector, bio, NULL);
+		if (r > 0)
+			generic_make_request(bio);
+		else if (r < 0) {
+			/* error the io and bail out */
+			bio_endio(bio, r);
+			bio_put(bio);
+		}
+	}
+
+	remove_exception(e);
+	free_exception(e);
+	s->store.commit_merge(&s->store);
+
+	up_write(&s->lock);
+
+	return 1;
+}
+
+static void do_merging(struct work_struct *work)
+{
+	struct dm_merged *merged =
+		container_of(work, struct dm_merged, merging_work);
+	int error;
+
+	if (end_merge(merged, &error)) {
+		up(&merged->merging);
+		if (error)
+			return;
+	}
+
+	if (down_trylock(&merged->merging))
+		return;
+
+	if (!start_merge(merged))
+		up(&merged->merging);
+}
+
 /*
  * Construct a merged snapshot: <origin_dev> <COW-dev>
  */
@@ -1360,6 +1536,17 @@ static int merged_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		return r;
 	}
 
+	sema_init(&merged->merging, 0);
+
+	INIT_WORK(&merged->merging_work, do_merging);
+
+	merged->status = 0;
+
+	merged->old_chunk = 0;
+	merged->new_chunk = 0;
+
+	bio_list_init(&merged->delayed_bios);
+
 	ti->private = merged;
 
 	return 0;
@@ -1396,6 +1583,13 @@ static int merged_map(struct dm_target *ti, struct bio *bio,
 		return -EIO;
 	}
 
+	if (bio_rw(bio) == WRITE && chunk == merged->old_chunk) {
+		bio->bi_bdev = s->origin->bdev;
+		bio_list_add(&merged->delayed_bios, bio);
+		up_write(&s->lock);
+		return 0;
+	}
+
 	e = lookup_exception(&s->complete, chunk);
 	if (e) {
 		if (bio_rw(bio) == WRITE) {
@@ -1413,7 +1607,7 @@ static int merged_map(struct dm_target *ti, struct bio *bio,
 		bio->bi_bdev = s->origin->bdev;
 
 		if (bio_rw(bio) == WRITE)
-			r = do_origin(s->origin, bio->bi_sector, bio);
+			r = do_origin(s->origin, bio->bi_sector, bio, NULL);
 	}
 
 out_unlock:
@@ -1440,6 +1634,16 @@ static void merged_resume(struct dm_target *ti)
 	struct dm_merged *merged = ti->private;
 
 	ti->split_io = min_chunk_size(merged->snap.origin);
+
+	up(&merged->merging);
+	queue_work(ksnapd, &merged->merging_work);
+}
+
+static void merged_postsuspend(struct dm_target *ti)
+{
+	struct dm_merged *merged = (struct dm_merged *) ti->private;
+
+	down(&merged->merging);
 }
 
 static int merged_status(struct dm_target *ti, status_type_t type, char *result,
@@ -1496,15 +1700,16 @@ static struct target_type snapshot_target = {
 };
 
 static struct target_type merged_target = {
-	.name    = "snapshot-merged",
-	.version = {1, 1, 1},
-	.module  = THIS_MODULE,
-	.ctr     = merged_ctr,
-	.dtr     = merged_dtr,
-	.map     = merged_map,
-	.end_io  = merged_end_io,
-	.resume  = merged_resume,
-	.status  = merged_status,
+	.name        = "snapshot-merged",
+	.version     = {1, 1, 1},
+	.module      = THIS_MODULE,
+	.ctr         = merged_ctr,
+	.dtr         = merged_dtr,
+	.map         = merged_map,
+	.end_io      = merged_end_io,
+	.resume      = merged_resume,
+	.postsuspend = merged_postsuspend,
+	.status      = merged_status,
 };
 
 static int __init dm_snapshot_init(void)
diff --git a/drivers/md/dm-snap.h b/drivers/md/dm-snap.h
index 8600477..048274c 100644
--- a/drivers/md/dm-snap.h
+++ b/drivers/md/dm-snap.h
@@ -190,6 +190,22 @@ struct dm_snapshot {
 
 struct dm_merged {
 	struct dm_snapshot snap;
+
+	/* held while there is a merge in progress */
+	struct semaphore merging;
+
+	/* merging work for ksnapd */
+	struct work_struct merging_work;
+
+	/* status of current merge - bitfield of MERGE_*_BIT */
+	unsigned long status;
+
+	/* current merge - could be delayed or in progress */
+	chunk_t old_chunk;
+	chunk_t new_chunk;
+
+	/* I/O waiting for current merge to complete */
+	struct bio_list delayed_bios;
 };
 
 /*
-- 
1.5.4.1
