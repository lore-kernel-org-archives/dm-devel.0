From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 1/7] dm core: add core functions for
	request-based dm
Date: Fri, 24 Apr 2009 17:12:39 +0900
Message-ID: <49F17477.1010807@ct.jp.nec.com>
References: <49F17409.4060201@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49F17409.4060201@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch adds core functions for request-based dm.

When struct mapped device (md) is initialized, md->queue has
an I/O scheduler and the following functions are used for
request-based dm as the queue functions:
    make_request_fn: dm_make_request()
    pref_fn:         dm_prep_fn()
    request_fn:      dm_request_fn()
    softirq_done_fn: dm_softirq_done()
    lld_busy_fn:     dm_lld_busy()
Actual initializations are done in another patch (PATCH 3).

Below is a brief summary of how request-based dm behaves, including:
  - making request from bio
  - cloning, mapping and dispatching request
  - completing request and bio
  - suspending md
  - resuming md


bio to request
==============
md->queue->make_request_fn() (dm_make_request()) calls__make_request()
for a bio submitted to the md.
Then, the bio is kept in the queue as a new request or merged into
another request in the queue if possible.


Cloning and Mapping
===================
Cloning and mapping are done in md->queue->request_fn() (dm_request_fn()),
when requests are dispatched after they are sorted by the I/O scheduler.

dm_request_fn() checks busy state of underlying devices using
target's busy() function and stops dispatching requests to keep them
on the dm device's queue if busy.
It helps better I/O merging, since no merge is done for a request
once it is dispatched to underlying devices.

Actual cloning and mapping are done in dm_prep_fn() and map_request()
called from dm_request_fn().
dm_prep_fn() clones not only request but also bios of the request
so that dm can hold bio completion in error cases and prevent
the bio submitter from noticing the error.
(See the "Completion" section below for details.)

After the cloning, the clone is mapped by target's map_rq() function
and inserted to underlying device's queue using
blk_insert_cloned_request().


Completion
==========
Request completion can be hooked by rq->end_io(), but then, all bios
in the request will have been completed even error cases, and the bio
submitter will have noticed the error.
To prevent the bio completion in error cases, request-based dm clones
both bio and request and hooks both bio->bi_end_io() and rq->end_io():
    bio->bi_end_io(): end_clone_bio()
    rq->end_io():     end_clone_request()

Summary of the request completion flow is below:
blk_end_request() for a clone request
  => __end_that_request_first()
     => bio->bi_end_io() == end_clone_bio() for each clone bio
        => Free the clone bio
        => Success: Complete the original bio (blk_update_request())
           Error:   Don't complete the original bio
  => end_that_request_last()
     => rq->end_io() == end_clone_request()
        => blk_complete_request()
           => dm_softirq_done()
              => Free the clone request
              => Success: Complete the original request (blk_end_request())
                 Error:   Requeue the original request

end_clone_bio() completes the original request on the size of
the original bio in successful cases.
Even if all bios in the original request are completed by that
completion, the original request must not be completed yet to keep
the ordering of request completion for the stacking.
So end_clone_bio() uses blk_update_request() instead of
blk_end_request().
In error cases, end_clone_bio() doesn't complete the original bio.
It just frees the cloned bio and gives over the error handling to
end_clone_request().

end_clone_request(), which is called with queue lock held, completes
the clone request and the original request in a softirq context
(dm_softirq_done()), which has no queue lock, to avoid a deadlock
issue on submission of another request during the completion:
    - The submitted request may be mapped to the same device
    - Request submission requires queue lock, but the queue lock
      has been held by itself and it doesn't know that

The clone request has no clone bio when dm_softirq_done() is called.
So target drivers can't resubmit it again even error cases.
Instead, they can ask dm core for requeueing and remapping
the original request in that cases.


suspend
=======
Request-based dm uses stopping md->queue as suspend of the md.
For noflush suspend, just stops md->queue.

For flush suspend, inserts a marker request to the tail of md->queue.
And dispatches all requests in md->queue until the marker comes to
the front of md->queue.  Then, stops dispatching request and waits
for the all dispatched requests to complete.
After that, completes the marker request, stops md->queue and
wake up the waiter on the suspend queue, md->wait.


resume
======
Starts md->queue.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-table.c         |   14 
 drivers/md/dm.c               |  758 +++++++++++++++++++++++++++++++++++++++++-
 drivers/md/dm.h               |    1 
 include/linux/device-mapper.h |    9 
 4 files changed, 779 insertions(+), 3 deletions(-)

Index: 2.6.30-rc3/drivers/md/dm.c
===================================================================
--- 2.6.30-rc3.orig/drivers/md/dm.c
+++ 2.6.30-rc3/drivers/md/dm.c
@@ -83,6 +83,14 @@ union map_info *dm_get_mapinfo(struct bi
 	return NULL;
 }
 
+union map_info *dm_get_rq_mapinfo(struct request *rq)
+{
+	if (rq && rq->end_io_data)
+		return &((struct dm_rq_target_io *)rq->end_io_data)->info;
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(dm_get_rq_mapinfo);
+
 #define MINOR_ALLOCED ((void *)-1)
 
 /*
@@ -164,6 +172,12 @@ struct mapped_device {
 	/* forced geometry settings */
 	struct hd_geometry geometry;
 
+	/* marker of flush suspend for request-based dm */
+	struct request suspend_rq;
+
+	/* For saving the address of __make_request for request based dm */
+	make_request_fn *saved_make_request_fn;
+
 	/* sysfs handle */
 	struct kobject kobj;
 };
@@ -403,6 +417,27 @@ static void free_tio(struct mapped_devic
 	mempool_free(tio, md->tio_pool);
 }
 
+static struct dm_rq_target_io *alloc_rq_tio(struct mapped_device *md)
+{
+	return mempool_alloc(md->tio_pool, GFP_ATOMIC);
+}
+
+static void free_rq_tio(struct mapped_device *md, struct dm_rq_target_io *tio)
+{
+	mempool_free(tio, md->tio_pool);
+}
+
+static struct dm_rq_clone_bio_info *alloc_bio_info(struct mapped_device *md)
+{
+	return mempool_alloc(md->io_pool, GFP_ATOMIC);
+}
+
+static void free_bio_info(struct mapped_device *md,
+			  struct dm_rq_clone_bio_info *info)
+{
+	mempool_free(info, md->io_pool);
+}
+
 static void start_io_acct(struct dm_io *io)
 {
 	struct mapped_device *md = io->md;
@@ -609,6 +644,283 @@ static void clone_endio(struct bio *bio,
 	dec_pending(io, error);
 }
 
+/*
+ * Partial completion handling for request-based dm
+ */
+static void end_clone_bio(struct bio *clone, int error)
+{
+	struct dm_rq_clone_bio_info *info = clone->bi_private;
+	struct dm_rq_target_io *tio = info->rq->end_io_data;
+	struct bio *bio = info->orig;
+	unsigned int nr_bytes = info->orig->bi_size;
+
+	free_bio_info(tio->md, info);
+	clone->bi_private = tio->md->bs;
+	bio_put(clone);
+
+	if (tio->error) {
+		/*
+		 * An error has already been detected on the request.
+		 * Once error occurred, just let clone->end_io() handle
+		 * the remainder.
+		 */
+		return;
+	} else if (error) {
+		/*
+		 * Don't notice the error to the upper layer yet.
+		 * The error handling decision is made by the target driver,
+		 * when the request is completed.
+		 */
+		tio->error = error;
+		return;
+	}
+
+	/*
+	 * I/O for the bio successfully completed.
+	 * Notice the data completion to the upper layer.
+	 */
+
+	/*
+	 * bios are processed from the head of the list.
+	 * So the completing bio should always be rq->bio.
+	 * If it's not, something wrong is happening.
+	 */
+	if (tio->orig->bio != bio)
+		DMERR("bio completion is going in the middle of the request");
+
+	/*
+	 * Update the original request.
+	 * Do not use blk_end_request() here, because it may complete
+	 * the original request before the clone, and break the ordering.
+	 */
+	blk_update_request(tio->orig, 0, nr_bytes);
+}
+
+static void free_bio_clone(struct mapped_device *md, struct request *clone)
+{
+	struct bio *bio;
+	struct dm_rq_clone_bio_info *info;
+
+	while ((bio = clone->bio) != NULL) {
+		clone->bio = bio->bi_next;
+
+		info = bio->bi_private;
+		free_bio_info(md, info);
+
+		bio->bi_private = md->bs;
+		bio_put(bio);
+	}
+}
+
+/*
+ * Don't touch any member of the md after calling this function because
+ * the md may be freed in dm_put() at the end of this function.
+ * Or do dm_get() before calling this function and dm_put() later.
+ */
+static void rq_completed(struct mapped_device *md, int run_queue)
+{
+	int wakeup_waiters = 0;
+	struct request_queue *q = md->queue;
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	if (!q->in_flight)
+		wakeup_waiters = 1;
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	/* nudge anyone waiting on suspend queue */
+	if (wakeup_waiters)
+		wake_up(&md->wait);
+
+	if (run_queue)
+		blk_run_queue(q);
+
+	/*
+	 * dm_put() must be at the end of this function. See the comment above
+	 */
+	dm_put(md);
+}
+
+static void dm_unprep_request(struct request *rq)
+{
+	struct request *clone = rq->special;
+	struct dm_rq_target_io *tio = clone->end_io_data;
+	struct mapped_device *md = tio->md;
+
+	rq->special = NULL;
+	rq->cmd_flags &= ~REQ_DONTPREP;
+
+	free_bio_clone(md, clone);
+	free_rq_tio(md, tio);
+}
+
+/*
+ * Requeue the original request of a clone.
+ */
+void dm_requeue_unmapped_request(struct request *clone)
+{
+	struct dm_rq_target_io *tio = clone->end_io_data;
+	struct mapped_device *md = tio->md;
+	struct request *rq = tio->orig;
+	struct request_queue *q = rq->q;
+	unsigned long flags;
+
+	dm_unprep_request(rq);
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	if (elv_queue_empty(q))
+		blk_plug_device(q);
+	blk_requeue_request(q, rq);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	rq_completed(md, 0);
+}
+EXPORT_SYMBOL_GPL(dm_requeue_unmapped_request);
+
+static void __stop_queue(struct request_queue *q)
+{
+	blk_stop_queue(q);
+}
+
+static void stop_queue(struct request_queue *q)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	__stop_queue(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+
+static void __start_queue(struct request_queue *q)
+{
+	if (blk_queue_stopped(q))
+		blk_start_queue(q);
+}
+
+static void start_queue(struct request_queue *q)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	__start_queue(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+
+/*
+ * Complete the clone and the original request.
+ * Must be called without queue lock.
+ */
+static void dm_end_request(struct request *clone, int error)
+{
+	struct dm_rq_target_io *tio = clone->end_io_data;
+	struct mapped_device *md = tio->md;
+	struct request *rq = tio->orig;
+	unsigned int nr_bytes = blk_rq_bytes(rq);
+
+	if (blk_pc_request(rq)) {
+		rq->errors = clone->errors;
+		rq->data_len = clone->data_len;
+
+		if (rq->sense)
+			/*
+			 * We are using the sense buffer of the original
+			 * request.
+			 * So setting the length of the sense data is enough.
+			 */
+			rq->sense_len = clone->sense_len;
+	}
+
+	free_bio_clone(md, clone);
+	free_rq_tio(md, tio);
+
+	if (unlikely(blk_end_request(rq, error, nr_bytes)))
+		BUG();
+
+	rq_completed(md, 1);
+}
+
+/*
+ * Request completion handler for request-based dm
+ */
+static void dm_softirq_done(struct request *rq)
+{
+	struct request *clone = rq->completion_data;
+	struct dm_rq_target_io *tio = clone->end_io_data;
+	dm_request_endio_fn rq_end_io = tio->ti->type->rq_end_io;
+	int error = tio->error;
+
+	if (!(rq->cmd_flags & REQ_FAILED) && rq_end_io)
+		error = rq_end_io(tio->ti, clone, error, &tio->info);
+
+	if (error <= 0)
+		/* The target wants to complete the I/O */
+		dm_end_request(clone, error);
+	else if (error == DM_ENDIO_INCOMPLETE)
+		/* The target will handle the I/O */
+		return;
+	else if (error == DM_ENDIO_REQUEUE)
+		/* The target wants to requeue the I/O */
+		dm_requeue_unmapped_request(clone);
+	else {
+		DMWARN("unimplemented target endio return value: %d", error);
+		BUG();
+	}
+}
+
+/*
+ * Complete the clone and the original request with the error status
+ * through softirq context.
+ */
+static void dm_complete_request(struct request *clone, int error)
+{
+	struct dm_rq_target_io *tio = clone->end_io_data;
+	struct request *rq = tio->orig;
+
+	tio->error = error;
+	rq->completion_data = clone;
+	blk_complete_request(rq);
+}
+
+/*
+ * Complete the not-mapped clone and the original request with the error status
+ * through softirq context.
+ * Target's rq_end_io() function isn't called.
+ * This may be used when the target's map_rq() function fails.
+ */
+void dm_kill_unmapped_request(struct request *clone, int error)
+{
+	struct dm_rq_target_io *tio = clone->end_io_data;
+	struct request *rq = tio->orig;
+
+	rq->cmd_flags |= REQ_FAILED;
+	dm_complete_request(clone, error);
+}
+EXPORT_SYMBOL_GPL(dm_kill_unmapped_request);
+
+/*
+ * Called with the queue lock held
+ */
+static void end_clone_request(struct request *clone, int error)
+{
+	/*
+	 * For just cleaning up the information of the queue in which
+	 * the clone was dispatched.
+	 * The clone is *NOT* freed actually here because it is alloced from
+	 * dm own mempool and REQ_ALLOCED isn't set in clone->cmd_flags.
+	 */
+	__blk_put_request(clone->q, clone);
+
+	/*
+	 * Actual request completion is done in a softirq context which doesn't
+	 * hold the queue lock.  Otherwise, deadlock could occur because:
+	 *     - another request may be submitted by the upper level driver
+	 *       of the stacking during the completion
+	 *     - the submission which requires queue lock may be done
+	 *       against this queue
+	 */
+	dm_complete_request(clone, error);
+}
+
 static sector_t max_io_len(struct mapped_device *md,
 			   sector_t sector, struct dm_target *ti)
 {
@@ -946,7 +1258,7 @@ out:
  * The request function that just remaps the bio built up by
  * dm_merge_bvec.
  */
-static int dm_request(struct request_queue *q, struct bio *bio)
+static int _dm_request(struct request_queue *q, struct bio *bio)
 {
 	int rw = bio_data_dir(bio);
 	struct mapped_device *md = q->queuedata;
@@ -983,12 +1295,307 @@ static int dm_request(struct request_que
 	return 0;
 }
 
+static int dm_make_request(struct request_queue *q, struct bio *bio)
+{
+	struct mapped_device *md = q->queuedata;
+
+	if (unlikely(bio_barrier(bio))) {
+		bio_endio(bio, -EOPNOTSUPP);
+		return 0;
+	}
+
+	return md->saved_make_request_fn(q, bio); /* call __make_request() */
+}
+
+static int dm_request_based(struct mapped_device *md)
+{
+	return blk_queue_stackable(md->queue);
+}
+
+static int dm_request(struct request_queue *q, struct bio *bio)
+{
+	struct mapped_device *md = q->queuedata;
+
+	if (dm_request_based(md))
+		return dm_make_request(q, bio);
+
+	return _dm_request(q, bio);
+}
+
+void dm_dispatch_request(struct request *rq)
+{
+	int r;
+
+	rq->start_time = jiffies;
+	r = blk_insert_cloned_request(rq->q, rq);
+	if (r)
+		dm_complete_request(rq, r);
+}
+EXPORT_SYMBOL_GPL(dm_dispatch_request);
+
+static void copy_request_info(struct request *clone, struct request *rq)
+{
+	clone->cmd_flags = (rq_data_dir(rq) | REQ_NOMERGE);
+	clone->cmd_type = rq->cmd_type;
+	clone->sector = rq->sector;
+	clone->hard_sector = rq->hard_sector;
+	clone->nr_sectors = rq->nr_sectors;
+	clone->hard_nr_sectors = rq->hard_nr_sectors;
+	clone->current_nr_sectors = rq->current_nr_sectors;
+	clone->hard_cur_sectors = rq->hard_cur_sectors;
+	clone->nr_phys_segments = rq->nr_phys_segments;
+	clone->ioprio = rq->ioprio;
+	clone->buffer = rq->buffer;
+	clone->cmd_len = rq->cmd_len;
+	if (rq->cmd_len)
+		clone->cmd = rq->cmd;
+	clone->data_len = rq->data_len;
+	clone->extra_len = rq->extra_len;
+	clone->sense_len = rq->sense_len;
+	clone->data = rq->data;
+	clone->sense = rq->sense;
+}
+
+static int clone_request_bios(struct request *clone, struct request *rq,
+			      struct mapped_device *md)
+{
+	struct bio *bio, *clone_bio;
+	struct dm_rq_clone_bio_info *info;
+
+	for (bio = rq->bio; bio; bio = bio->bi_next) {
+		info = alloc_bio_info(md);
+		if (!info)
+			goto free_and_out;
+
+		clone_bio = bio_alloc_bioset(GFP_ATOMIC, bio->bi_max_vecs,
+					     md->bs);
+		if (!clone_bio) {
+			free_bio_info(md, info);
+			goto free_and_out;
+		}
+
+		__bio_clone(clone_bio, bio);
+		clone_bio->bi_destructor = dm_bio_destructor;
+		clone_bio->bi_end_io = end_clone_bio;
+		info->rq = clone;
+		info->orig = bio;
+		clone_bio->bi_private = info;
+
+		if (clone->bio) {
+			clone->biotail->bi_next = clone_bio;
+			clone->biotail = clone_bio;
+		} else
+			clone->bio = clone->biotail = clone_bio;
+	}
+
+	return 0;
+
+free_and_out:
+	free_bio_clone(md, clone);
+
+	return -ENOMEM;
+}
+
+static int setup_clone(struct request *clone, struct request *rq,
+		       struct dm_rq_target_io *tio)
+{
+	int r;
+
+	blk_rq_init(NULL, clone);
+
+	r = clone_request_bios(clone, rq, tio->md);
+	if (r)
+		return r;
+
+	copy_request_info(clone, rq);
+	clone->start_time = jiffies;
+	clone->end_io = end_clone_request;
+	clone->end_io_data = tio;
+
+	return 0;
+}
+
+static int dm_rq_flush_suspending(struct mapped_device *md)
+{
+	return !md->suspend_rq.data;
+}
+
+/*
+ * Called with the queue lock held.
+ */
+static int dm_prep_fn(struct request_queue *q, struct request *rq)
+{
+	struct mapped_device *md = q->queuedata;
+	struct dm_rq_target_io *tio;
+	struct request *clone;
+
+	if (unlikely(rq == &md->suspend_rq)) {
+		if (dm_rq_flush_suspending(md))
+			return BLKPREP_OK;
+		else
+			/* The flush suspend was interrupted */
+			return BLKPREP_KILL;
+	}
+
+	if (unlikely(rq->special)) {
+		DMWARN("Already has something in rq->special.");
+		return BLKPREP_KILL;
+	}
+
+	tio = alloc_rq_tio(md); /* Only one for each original request */
+	if (!tio)
+		/* -ENOMEM */
+		return BLKPREP_DEFER;
+
+	tio->md = md;
+	tio->ti = NULL;
+	tio->orig = rq;
+	tio->error = 0;
+	memset(&tio->info, 0, sizeof(tio->info));
+
+	clone = &tio->clone;
+	if (setup_clone(clone, rq, tio)) {
+		/* -ENOMEM */
+		free_rq_tio(md, tio);
+		return BLKPREP_DEFER;
+	}
+
+	rq->special = clone;
+	rq->cmd_flags |= REQ_DONTPREP;
+
+	return BLKPREP_OK;
+}
+
+static void map_request(struct dm_target *ti, struct request *rq,
+			struct mapped_device *md)
+{
+	int r;
+	struct request *clone = rq->special;
+	struct dm_rq_target_io *tio = clone->end_io_data;
+
+	/*
+	 * Hold the md reference here for the in-flight I/O.
+	 * We can't rely on the reference count by device opener,
+	 * because the device may be closed during the request completion
+	 * when all bios are completed.
+	 * See the comment in rq_completed() too.
+	 */
+	dm_get(md);
+
+	tio->ti = ti;
+	r = ti->type->map_rq(ti, clone, &tio->info);
+	switch (r) {
+	case DM_MAPIO_SUBMITTED:
+		/* The target has taken the I/O to submit by itself later */
+		break;
+	case DM_MAPIO_REMAPPED:
+		/* The target has remapped the I/O so dispatch it */
+		dm_dispatch_request(clone);
+		break;
+	case DM_MAPIO_REQUEUE:
+		/* The target wants to requeue the I/O */
+		dm_requeue_unmapped_request(clone);
+		break;
+	default:
+		if (r > 0) {
+			DMWARN("unimplemented target map return value: %d", r);
+			BUG();
+		}
+
+		/* The target wants to complete the I/O */
+		dm_kill_unmapped_request(clone, r);
+		break;
+	}
+}
+
+/*
+ * q->request_fn for request-based dm.
+ * Called with the queue lock held.
+ */
+static void dm_request_fn(struct request_queue *q)
+{
+	struct mapped_device *md = q->queuedata;
+	struct dm_table *map = dm_get_table(md);
+	struct dm_target *ti;
+	struct request *rq;
+
+	/*
+	 * For noflush suspend, check blk_queue_stopped() to immediately
+	 * quit I/O dispatching.
+	 */
+	while (!blk_queue_plugged(q) && !blk_queue_stopped(q)) {
+		rq = elv_next_request(q);
+		if (!rq)
+			goto plug_and_out;
+
+		if (unlikely(rq == &md->suspend_rq)) { /* Flush suspend maker */
+			if (q->in_flight)
+				/* Not quiet yet.  Wait more */
+				goto plug_and_out;
+
+			/* This device should be quiet now */
+			__stop_queue(q);
+			blkdev_dequeue_request(rq);
+			if (unlikely(__blk_end_request(rq, 0, 0)))
+				BUG();
+			wake_up(&md->wait);
+			goto out;
+		}
+
+		ti = dm_table_find_target(map, rq->sector);
+		if (ti->type->busy && ti->type->busy(ti))
+			goto plug_and_out;
+
+		blkdev_dequeue_request(rq);
+		spin_unlock(q->queue_lock);
+		map_request(ti, rq, md);
+		spin_lock_irq(q->queue_lock);
+	}
+
+	goto out;
+
+plug_and_out:
+	if (!elv_queue_empty(q))
+		/* Some requests still remain, retry later */
+		blk_plug_device(q);
+
+out:
+	dm_table_put(map);
+
+	return;
+}
+
+int dm_underlying_device_busy(struct request_queue *q)
+{
+	return blk_lld_busy(q);
+}
+EXPORT_SYMBOL_GPL(dm_underlying_device_busy);
+
+static int dm_lld_busy(struct request_queue *q)
+{
+	int r;
+	struct mapped_device *md = q->queuedata;
+	struct dm_table *map = dm_get_table(md);
+
+	if (!map || test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags))
+		r = 1;
+	else
+		r = dm_table_any_busy_target(map);
+
+	dm_table_put(map);
+
+	return r;
+}
+
 static void dm_unplug_all(struct request_queue *q)
 {
 	struct mapped_device *md = q->queuedata;
 	struct dm_table *map = dm_get_table(md);
 
 	if (map) {
+		if (dm_request_based(md))
+			generic_unplug_device(q);
+
 		dm_table_unplug_all(map);
 		dm_table_put(map);
 	}
@@ -1003,7 +1610,16 @@ static int dm_any_congested(void *conges
 	if (!test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) {
 		map = dm_get_table(md);
 		if (map) {
-			r = dm_table_any_congested(map, bdi_bits);
+			/*
+			 * Request-based dm cares about only own queue for
+			 * the query about congestion status of request_queue
+			 */
+			if (dm_request_based(md))
+				r = md->queue->backing_dev_info.state &
+				    bdi_bits;
+			else
+				r = dm_table_any_congested(map, bdi_bits);
+
 			dm_table_put(map);
 		}
 	}
@@ -1402,6 +2018,8 @@ static int dm_wait_for_completion(struct
 {
 	int r = 0;
 	DECLARE_WAITQUEUE(wait, current);
+	struct request_queue *q = md->queue;
+	unsigned long flags;
 
 	dm_unplug_all(md->queue);
 
@@ -1411,7 +2029,14 @@ static int dm_wait_for_completion(struct
 		set_current_state(interruptible);
 
 		smp_mb();
-		if (!atomic_read(&md->pending))
+		if (dm_request_based(md)) {
+			spin_lock_irqsave(q->queue_lock, flags);
+			if (!q->in_flight && blk_queue_stopped(q)) {
+				spin_unlock_irqrestore(q->queue_lock, flags);
+				break;
+			}
+			spin_unlock_irqrestore(q->queue_lock, flags);
+		} else if (!atomic_read(&md->pending))
 			break;
 
 		if (interruptible == TASK_INTERRUPTIBLE &&
@@ -1526,6 +2151,67 @@ out:
 	return r;
 }
 
+static void dm_rq_invalidate_suspend_marker(struct mapped_device *md)
+{
+	md->suspend_rq.data = (void *)0x1;
+}
+
+static void dm_rq_abort_suspend(struct mapped_device *md, int noflush)
+{
+	struct request_queue *q = md->queue;
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	if (!noflush)
+		dm_rq_invalidate_suspend_marker(md);
+	__start_queue(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+
+static void dm_rq_start_suspend(struct mapped_device *md, int noflush)
+{
+	struct request *rq = &md->suspend_rq;
+	struct request_queue *q = md->queue;
+
+	if (noflush)
+		stop_queue(q);
+	else {
+		blk_rq_init(q, rq);
+		blk_insert_request(q, rq, 0, NULL);
+	}
+}
+
+static int dm_rq_suspend_available(struct mapped_device *md, int noflush)
+{
+	int r = 1;
+	struct request *rq = &md->suspend_rq;
+	struct request_queue *q = md->queue;
+	unsigned long flags;
+
+	if (noflush)
+		return r;
+
+	/* The marker must be protected by queue lock if it is in use */
+	spin_lock_irqsave(q->queue_lock, flags);
+	if (unlikely(rq->ref_count)) {
+		/*
+		 * This can happen, when the previous flush suspend was
+		 * interrupted, the marker is still in the queue and
+		 * this flush suspend has been invoked, because we don't
+		 * remove the marker at the time of suspend interruption.
+		 * We have only one marker per mapped_device, so we can't
+		 * start another flush suspend while it is in use.
+		 */
+		BUG_ON(!rq->data); /* The marker should be invalidated */
+		DMWARN("Invalidating the previous flush suspend is still in"
+		       " progress.  Please retry later.");
+		r = 0;
+	}
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	return r;
+}
+
 /*
  * Functions to lock and unlock any filesystem running on the
  * device.
@@ -1568,6 +2254,53 @@ static void unlock_fs(struct mapped_devi
  * dm_bind_table, dm_suspend must be called to flush any in
  * flight bios and ensure that any further io gets deferred.
  */
+/*
+ * Suspend mechanism in request-based dm.
+ *
+ * After the suspend starts, further incoming requests are kept in
+ * the request_queue and deferred.
+ * Remaining requests in the request_queue at the start of suspend are flushed
+ * if it is flush suspend.
+ * The suspend completes when the following conditions have been satisfied,
+ * so wait for it:
+ *    1. q->in_flight is 0 (which means no in_flight request)
+ *    2. queue has been stopped (which means no request dispatching)
+ *
+ *
+ * Noflush suspend
+ * ---------------
+ * Noflush suspend doesn't need to dispatch remaining requests.
+ * So stop the queue immediately.  Then, wait for all in_flight requests
+ * to be completed or requeued.
+ *
+ * To abort noflush suspend, start the queue.
+ *
+ *
+ * Flush suspend
+ * -------------
+ * Flush suspend needs to dispatch remaining requests.  So stop the queue
+ * after the remaining requests are completed. (Requeued request must be also
+ * re-dispatched and completed.  Until then, we can't stop the queue.)
+ *
+ * During flushing the remaining requests, further incoming requests are also
+ * inserted to the same queue.  To distinguish which requests are to be
+ * flushed, we insert a marker request to the queue at the time of starting
+ * flush suspend, like a barrier.
+ * The dispatching is blocked when the marker is found on the top of the queue.
+ * And the queue is stopped when all in_flight requests are completed, since
+ * that means the remaining requests are completely flushed.
+ * Then, the marker is removed from the queue.
+ *
+ * To abort flush suspend, we also need to take care of the marker, not only
+ * starting the queue.
+ * We don't remove the marker forcibly from the queue since it's against
+ * the block-layer manner.  Instead, we put a invalidated mark on the marker.
+ * When the invalidated marker is found on the top of the queue, it is
+ * immediately removed from the queue, so it doesn't block dispatching.
+ * Because we have only one marker per mapped_device, we can't start another
+ * flush suspend until the invalidated marker is removed from the queue.
+ * So fail and return with -EBUSY in such a case.
+ */
 int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 {
 	struct dm_table *map = NULL;
@@ -1582,6 +2315,11 @@ int dm_suspend(struct mapped_device *md,
 		goto out_unlock;
 	}
 
+	if (dm_request_based(md) && !dm_rq_suspend_available(md, noflush)) {
+		r = -EBUSY;
+		goto out_unlock;
+	}
+
 	map = dm_get_table(md);
 
 	/*
@@ -1637,6 +2375,9 @@ int dm_suspend(struct mapped_device *md,
 
 	flush_workqueue(md->wq);
 
+	if (dm_request_based(md))
+		dm_rq_start_suspend(md, noflush);
+
 	/*
 	 * At this point no more requests are entering target request routines.
 	 * We call dm_wait_for_completion to wait for all existing requests
@@ -1653,6 +2394,9 @@ int dm_suspend(struct mapped_device *md,
 	if (r < 0) {
 		dm_queue_flush(md);
 
+		if (dm_request_based(md))
+			dm_rq_abort_suspend(md, noflush);
+
 		unlock_fs(md);
 		goto out; /* pushback list is already flushed, so skip flush */
 	}
@@ -1699,6 +2443,14 @@ int dm_resume(struct mapped_device *md)
 
 	dm_queue_flush(md);
 
+	/*
+	 * Flushing deferred I/Os must be done after targets are resumed
+	 * so that mapping of targets can work correctly.
+	 * Request-based dm is queueing the deferred I/Os in its request_queue.
+	 */
+	if (dm_request_based(md))
+		start_queue(md->queue);
+
 	unlock_fs(md);
 
 	if (md->suspended_bdev) {
Index: 2.6.30-rc3/drivers/md/dm.h
===================================================================
--- 2.6.30-rc3.orig/drivers/md/dm.h
+++ 2.6.30-rc3/drivers/md/dm.h
@@ -47,6 +47,7 @@ void dm_table_presuspend_targets(struct 
 void dm_table_postsuspend_targets(struct dm_table *t);
 int dm_table_resume_targets(struct dm_table *t);
 int dm_table_any_congested(struct dm_table *t, int bdi_bits);
+int dm_table_any_busy_target(struct dm_table *t);
 
 /*
  * To check the return value from dm_table_find_target().
Index: 2.6.30-rc3/drivers/md/dm-table.c
===================================================================
--- 2.6.30-rc3.orig/drivers/md/dm-table.c
+++ 2.6.30-rc3/drivers/md/dm-table.c
@@ -1021,6 +1021,20 @@ int dm_table_any_congested(struct dm_tab
 	return r;
 }
 
+int dm_table_any_busy_target(struct dm_table *t)
+{
+	int i;
+	struct dm_target *ti;
+
+	for (i = 0; i < t->num_targets; i++) {
+		ti = t->targets + i;
+		if (ti->type->busy && ti->type->busy(ti))
+			return 1;
+	}
+
+	return 0;
+}
+
 void dm_table_unplug_all(struct dm_table *t)
 {
 	struct dm_dev_internal *dd;
Index: 2.6.30-rc3/include/linux/device-mapper.h
===================================================================
--- 2.6.30-rc3.orig/include/linux/device-mapper.h
+++ 2.6.30-rc3/include/linux/device-mapper.h
@@ -230,6 +230,7 @@ struct gendisk *dm_disk(struct mapped_de
 int dm_suspended(struct mapped_device *md);
 int dm_noflush_suspending(struct dm_target *ti);
 union map_info *dm_get_mapinfo(struct bio *bio);
+union map_info *dm_get_rq_mapinfo(struct request *rq);
 
 /*
  * Geometry functions.
@@ -392,4 +393,12 @@ static inline unsigned long to_bytes(sec
 	return (n << SECTOR_SHIFT);
 }
 
+/*-----------------------------------------------------------------
+ * Helper for block layer and dm core operations
+ *---------------------------------------------------------------*/
+void dm_dispatch_request(struct request *rq);
+void dm_requeue_unmapped_request(struct request *rq);
+void dm_kill_unmapped_request(struct request *rq, int error);
+int dm_underlying_device_busy(struct request_queue *q);
+
 #endif	/* _LINUX_DEVICE_MAPPER_H */
