From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH 2/4] dm-core: Add zero-size barrier processing to
	device-mapper
Date: Thu, 08 Jan 2009 17:13:24 +0100
Message-ID: <49662624.7030801@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Add zero-size barrier processing to device-mapper.

Barrier without payload is now resent to all targets
in mapped devices.
Target is responsible for barrier processing.

After processing all cloned requests is the parent
barrier request finished.

Only one barrier in time is processed, all subsequent bio
requests are queued (including possible other barrier bios).

Define special processing for stripe target, every device
in stripe set must receive empty barrier bio.

All other targets (in kernel) should process barriers without
changes correctly now.
(But probably some optimizations needed.)

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-stripe.c |    9 +++
 drivers/md/dm.c        |  158 +++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 153 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 41569bc..b9e6396 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -216,6 +216,15 @@ static int stripe_map(struct dm_target *ti, struct bio *bio,
 	sector_t chunk = offset >> sc->chunk_shift;
 	uint32_t stripe = sector_div(chunk, sc->stripes);
 
+	if (unlikely(bio_empty_barrier(bio))) {
+		unsigned int i, r = 0;
+
+		for (i = 0; i < sc->stripes && r == 0; i++)
+			r = blkdev_issue_flush(sc->stripe[i].dev->bdev, NULL);
+		bio_endio(bio, r);
+		return DM_MAPIO_SUBMITTED;
+	}
+
 	bio->bi_bdev = sc->stripe[stripe].dev->bdev;
 	bio->bi_sector = sc->stripe[stripe].physical_start +
 	    (chunk << sc->chunk_shift) + (offset & sc->chunk_mask);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a9aa699..d2f7e0b 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -95,6 +95,7 @@ union map_info *dm_get_mapinfo(struct bio *bio)
 #define DMF_FREEING 3
 #define DMF_DELETING 4
 #define DMF_NOFLUSH_SUSPENDING 5
+#define DMF_BARRIER 6
 
 /*
  * Work processed by per-device workqueue.
@@ -102,6 +103,8 @@ union map_info *dm_get_mapinfo(struct bio *bio)
 struct dm_wq_req {
 	enum {
 		DM_WQ_FLUSH_DEFERRED,
+		DM_WQ_BARRIER,
+		DM_WQ_BARRIER_POST,
 	} type;
 	struct work_struct work;
 	struct mapped_device *md;
@@ -136,6 +139,11 @@ struct mapped_device {
 	 * Processing queue (flush/barriers)
 	 */
 	struct workqueue_struct *wq;
+	/*
+	 * Always processing one barrier in time,
+	 * one static struct per md is enough.
+	 */
+	struct dm_wq_req barrier_work;
 
 	/*
 	 * The current mapping.
@@ -512,6 +520,9 @@ int dm_set_geometry(struct mapped_device *md, struct hd_geometry *geo)
  *   interests of getting something for people to use I give
  *   you this clearly demarcated crap.
  *---------------------------------------------------------------*/
+static void dm_wq_queue(struct mapped_device *md, int type, void *context,
+			struct dm_wq_req *req);
+static void dm_queue_flush(struct mapped_device *md, int type, void *context);
 
 static int __noflush_suspending(struct mapped_device *md)
 {
@@ -525,6 +536,7 @@ static int __noflush_suspending(struct mapped_device *md)
 static void dec_pending(struct dm_io *io, int error)
 {
 	unsigned long flags;
+	int barrier = bio_empty_barrier(io->bio);
 
 	/* Push-back supersedes any I/O errors */
 	if (error && !(io->error > 0 && __noflush_suspending(io->md)))
@@ -552,6 +564,10 @@ static void dec_pending(struct dm_io *io, int error)
 			trace_block_bio_complete(io->md->queue, io->bio);
 
 			bio_endio(io->bio, io->error);
+
+			if (barrier)
+				dm_wq_queue(io->md, DM_WQ_BARRIER_POST, NULL,
+					    &io->md->barrier_work);
 		}
 
 		free_io(io->md, io);
@@ -623,11 +639,6 @@ static void __map_bio(struct dm_target *ti, struct bio *clone,
 	sector_t sector;
 	struct mapped_device *md;
 
-	/*
-	 * Sanity checks.
-	 */
-	BUG_ON(!clone->bi_size);
-
 	clone->bi_end_io = clone_endio;
 	clone->bi_private = tio;
 
@@ -827,6 +838,36 @@ static int __clone_and_map(struct clone_info *ci)
 	return 0;
 }
 
+static void __map_empty_barrier(struct clone_info *ci, struct dm_target *ti)
+{
+	struct dm_target_io *tio;
+	struct bio *clone;
+
+	tio = alloc_tio(ci->md);
+	tio->io = ci->io;
+	tio->ti = ti;
+	memset(&tio->info, 0, sizeof(tio->info));
+
+	clone = clone_bio(ci->bio, 0, 0, 0, 0, ci->md->bs);
+	clone->bi_rw |= 1 << BIO_RW_BARRIER;
+
+	__map_bio(ti, clone, tio);
+}
+
+static int __clone_and_map_barrier(struct clone_info *ci)
+{
+	int i, targets = dm_table_get_num_targets(ci->map);
+	struct dm_target *ti;
+
+	/* Processing barrier per target */
+	for (i=0; i < targets; i++) {
+		ti = dm_table_get_target(ci->map, i);
+		__map_empty_barrier(ci, ti);
+	}
+
+	return 0;
+}
+
 /*
  * Split the bio into several clones.
  */
@@ -851,8 +892,12 @@ static int __split_bio(struct mapped_device *md, struct bio *bio)
 	ci.idx = bio->bi_idx;
 
 	start_io_acct(ci.io);
-	while (ci.sector_count && !error)
-		error = __clone_and_map(&ci);
+
+	if (unlikely(bio_empty_barrier(ci.bio)))
+		error = __clone_and_map_barrier(&ci);
+	else
+		while (ci.sector_count && !error)
+			error = __clone_and_map(&ci);
 
 	/* drop the extra reference count */
 	dec_pending(ci.io, error);
@@ -922,12 +967,8 @@ static int dm_request(struct request_queue *q, struct bio *bio)
 	struct mapped_device *md = q->queuedata;
 	int cpu;
 
-	/*
-	 * There is no use in forwarding any barrier request since we can't
-	 * guarantee it is (or can be) handled by the targets correctly.
-	 */
 	if (unlikely(bio_barrier(bio))) {
-		bio_endio(bio, -EOPNOTSUPP);
+		dm_queue_flush(md, DM_WQ_BARRIER, bio);
 		return 0;
 	}
 
@@ -996,6 +1037,13 @@ static int dm_any_congested(void *congested_data, int bdi_bits)
 	return r;
 }
 
+/*
+ * Make block layer happy otherwise it fails barriers requests
+ */
+static void dm_prepare_flush(struct request_queue *q, struct request *req)
+{
+}
+
 /*-----------------------------------------------------------------
  * An IDR is used to keep track of allocated minor numbers.
  *---------------------------------------------------------------*/
@@ -1121,6 +1169,9 @@ static struct mapped_device *alloc_dev(int minor)
 	md->queue->unplug_fn = dm_unplug_all;
 	blk_queue_merge_bvec(md->queue, dm_merge_bvec);
 
+	blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN_FLUSH,
+			  dm_prepare_flush);
+
 	md->io_pool = mempool_create_slab_pool(MIN_IOS, _io_cache);
 	if (!md->io_pool)
 		goto bad_io_pool;
@@ -1401,19 +1452,70 @@ static int dm_wait_for_completion(struct mapped_device *md)
 	return r;
 }
 
+static void __submit_barrier(struct mapped_device *md, struct bio *bio)
+{
+	DECLARE_WAITQUEUE(wait, current);
+	int r = 0, rw = bio_data_dir(bio);
+	struct dm_table *map = NULL;
+	int cpu;
+
+	cpu = part_stat_lock();
+	part_stat_inc(cpu, &dm_disk(md)->part0, ios[rw]);
+	part_stat_add(cpu, &dm_disk(md)->part0, sectors[rw], bio_sectors(bio));
+	part_stat_unlock();
+
+	set_bit(DMF_BLOCK_IO, &md->flags);
+	set_bit(DMF_BARRIER, &md->flags);
+
+	r = __split_bio(md, bio);
+	if (r < 0) {
+		bio_endio(bio, r);
+		clear_bit(DMF_BLOCK_IO, &md->flags);
+		clear_bit(DMF_BARRIER, &md->flags);
+		return;
+	}
+
+	/* wait for completion of preceding requests + barrier */
+	add_wait_queue(&md->wait, &wait);
+	up_write(&md->io_lock);
+
+	/* unplug */
+	map = dm_get_table(md);
+	if (map)
+		dm_table_unplug_all(map);
+	dm_table_put(map);
+
+	r = dm_wait_for_completion(md);
+
+	down_write(&md->io_lock);
+	remove_wait_queue(&md->wait, &wait);
+}
+
 /*
  * Process the deferred bios
  */
-static void __flush_deferred_io(struct mapped_device *md)
+static void __flush_deferred_io(struct mapped_device *md, int barrier_flag)
 {
 	struct bio *c;
+	int barrier;
 
 	while ((c = bio_list_pop(&md->deferred))) {
+		barrier = bio_barrier(c);
+
 		if (__split_bio(md, c))
 			bio_io_error(c);
+
+		/*
+		 * Process preceding bios if bio was barrier
+		 * and then finish it in next BARRIER_POST
+		 */
+		if (barrier)
+			return;
 	}
 
 	clear_bit(DMF_BLOCK_IO, &md->flags);
+	if (barrier_flag)
+		clear_bit(DMF_BARRIER, &md->flags);
 }
 
 static void __merge_pushback_list(struct mapped_device *md)
@@ -1427,6 +1529,22 @@ static void __merge_pushback_list(struct mapped_device *md)
 	spin_unlock_irqrestore(&md->pushback_lock, flags);
 }
 
+static void __request_barrier(struct mapped_device *md, struct bio *bio)
+{
+	/* Only barriers without payload are supported */
+	if (bio->bi_size) {
+		bio_endio(bio, -EOPNOTSUPP);
+		return;
+	}
+
+	smp_mb();
+	if (!test_bit(DMF_BLOCK_IO, &md->flags))
+		__submit_barrier(md, bio);
+	else
+		/* Otherwise barrier is queued */
+		bio_list_add(&md->deferred, bio);
+}
+
 static void dm_wq_work(struct work_struct *work)
 {
 	struct dm_wq_req *req = container_of(work, struct dm_wq_req, work);
@@ -1435,7 +1553,13 @@ static void dm_wq_work(struct work_struct *work)
 	down_write(&md->io_lock);
 	switch (req->type) {
 	case DM_WQ_FLUSH_DEFERRED:
-		__flush_deferred_io(md);
+		__flush_deferred_io(md, 0);
+		break;
+	case DM_WQ_BARRIER:
+		__request_barrier(md, req->context);
+		break;
+	case DM_WQ_BARRIER_POST:
+		__flush_deferred_io(md, 1);
 		break;
 	default:
 		DMERR("dm_wq_work: unrecognised work type %d", req->type);
@@ -1545,6 +1669,12 @@ int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 		goto out_unlock;
 	}
 
+	 /* FIXME: temporary, it must not fail here  */
+	if (test_bit(DMF_BARRIER, &md->flags)) {
+		r = -EBUSY;
+		goto out_unlock;
+	}
+
 	map = dm_get_table(md);
 
 	/*
