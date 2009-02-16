From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Re: 2.6.28.2 & dm-snapshot or kcopyd Oops
Date: Mon, 16 Feb 2009 02:40:27 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902160237170.4977@hs20-bc2-1.build.redhat.com>
References: <200901231836184950432@163.com>,
	<Pine.LNX.4.64.0901231514590.9877@hs20-bc2-1.build.redhat.com>,
	<200901301800149019891@163.com>,
	<Pine.LNX.4.64.0901301533390.5744@hs20-bc2-1.build.redhat.com>,
	<200901311416111648168@163.com>,
	<Pine.LNX.4.64.0902031505180.28433@hs20-bc2-1.build.redhat.com>,
	<200902051113011850587@163.com>,
	<Pine.LNX.4.64.0902051749150.5515@hs20-bc2-1.build.redhat.com>,
	<Pine.LNX.4.64.0902052218040.5380@hs20-bc2-1.build.redhat.com>,
	<200902061924107769776@163.com>,
	<Pine.LNX.4.64.0902061815440.11986@hs20-bc2-1.build.redhat.com>,
	<200902072041046488539@163.com>,
	<Pine.LNX.4.64.0902090311340.28754@hs20-bc2-1.build.redhat.com>,
	<200902101305353713189@163.com>,
	<Pine.LNX.4.64.0902101832050.386@hs20-bc2-1.build.redhat.com>,
	<Pine.LNX.4.64.0902110552550.20020@hs20-bc2-1.build.redhat.com>,
	<200902121131140773281@163.com>,
	<Pine.LNX.4.64.0902130138400.26381@hs20-bc2-1.build.redhat.com>,
	<Pine.LNX.4.64.0902130229040.2110@hs20-bc2-1.build.redhat.com>
	<200902131912139165975@163.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200902131912139165975@163.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jacky Kim <jcy_2008@163.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids



On Fri, 13 Feb 2009, Jacky Kim wrote:

> Hi,
> 
> 1. I test with the origin LV, and don't write to snapshots.
> 2. I don't delete snapshots when copy big files to the origin LV, but do create snapshot sometimes.
> 3. The snapshots have the same chunk size: 4KB or 64KB.
> 4. It seems to work well with 1 snapshot. But it always crashes each time with 2 snapshots.
> 5. I don't resize the origin device and the snapshots.
> 
> The latest debug information is as follows:

Hi

As an alternative, try this patch on a clean 2.6.28.* kernel. It combines 
patches for two bugs found so far + complete rewrite of chunk handling. 
(the old code was really terrible, I found multiple bugs in it and there 
is no way how to improve it except to rewrite it).

Don't erase the old kernel and test my previous patch too, I intend to 
backport it to RHEL (when I find the bug with your help) and I intend to 
submit this rewrite patch for upstream kernel.

Mikulas

Index: linux-2.6.28-snap-rewrite/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.28-snap-rewrite.orig/drivers/md/dm-kcopyd.c	2009-02-16 02:54:36.000000000 +0100
+++ linux-2.6.28-snap-rewrite/drivers/md/dm-kcopyd.c	2009-02-13 08:44:05.000000000 +0100
@@ -297,7 +297,8 @@ static int run_complete_job(struct kcopy
 	dm_kcopyd_notify_fn fn = job->fn;
 	struct dm_kcopyd_client *kc = job->kc;
 
-	kcopyd_put_pages(kc, job->pages);
+	if (job->pages)
+		kcopyd_put_pages(kc, job->pages);
 	mempool_free(job, kc->job_pool);
 	fn(read_err, write_err, context);
 
@@ -461,6 +462,7 @@ static void segment_complete(int read_er
 	sector_t progress = 0;
 	sector_t count = 0;
 	struct kcopyd_job *job = (struct kcopyd_job *) context;
+	struct dm_kcopyd_client *kc = job->kc;
 
 	mutex_lock(&job->lock);
 
@@ -490,7 +492,7 @@ static void segment_complete(int read_er
 
 	if (count) {
 		int i;
-		struct kcopyd_job *sub_job = mempool_alloc(job->kc->job_pool,
+		struct kcopyd_job *sub_job = mempool_alloc(kc->job_pool,
 							   GFP_NOIO);
 
 		*sub_job = *job;
@@ -508,14 +510,8 @@ static void segment_complete(int read_er
 
 	} else if (atomic_dec_and_test(&job->sub_jobs)) {
 
-		/*
-		 * To avoid a race we must keep the job around
-		 * until after the notify function has completed.
-		 * Otherwise the client may try and stop the job
-		 * after we've completed.
-		 */
-		job->fn(read_err, write_err, job->context);
-		mempool_free(job, job->kc->job_pool);
+		push(&kc->complete_jobs, job);
+		wake(kc);
 	}
 }
 
@@ -528,6 +524,8 @@ static void split_job(struct kcopyd_job 
 {
 	int i;
 
+	atomic_inc(&job->kc->nr_jobs);
+
 	atomic_set(&job->sub_jobs, SPLIT_COUNT);
 	for (i = 0; i < SPLIT_COUNT; i++)
 		segment_complete(0, 0u, job);
Index: linux-2.6.28-snap-rewrite/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.28-snap-rewrite.orig/drivers/md/dm-snap.c	2009-02-13 08:44:00.000000000 +0100
+++ linux-2.6.28-snap-rewrite/drivers/md/dm-snap.c	2009-02-13 08:47:21.000000000 +0100
@@ -58,28 +58,6 @@ struct dm_snap_pending_exception {
 	struct bio_list origin_bios;
 	struct bio_list snapshot_bios;
 
-	/*
-	 * Short-term queue of pending exceptions prior to submission.
-	 */
-	struct list_head list;
-
-	/*
-	 * The primary pending_exception is the one that holds
-	 * the ref_count and the list of origin_bios for a
-	 * group of pending_exceptions.  It is always last to get freed.
-	 * These fields get set up when writing to the origin.
-	 */
-	struct dm_snap_pending_exception *primary_pe;
-
-	/*
-	 * Number of pending_exceptions processing this chunk.
-	 * When this drops to zero we must complete the origin bios.
-	 * If incrementing or decrementing this, hold pe->snap->lock for
-	 * the sibling concerned and not pe->primary_pe->snap->lock unless
-	 * they are the same.
-	 */
-	atomic_t ref_count;
-
 	/* Pointer back to snapshot context */
 	struct dm_snapshot *snap;
 
@@ -788,6 +766,28 @@ static void flush_queued_bios(struct wor
 	flush_bios(queued_bios);
 }
 
+static int do_origin(struct dm_dev *origin, struct bio *bio);
+
+/*
+ * Flush a list of buffers.
+ */
+static void retry_origin_bios(struct dm_snapshot *s, struct bio *bio)
+{
+	struct bio *n;
+	int r;
+
+	while (bio) {
+		n = bio->bi_next;
+		bio->bi_next = NULL;
+		r = do_origin(s->origin, bio);
+		if (r == DM_MAPIO_REMAPPED)
+			generic_make_request(bio);
+		else
+			BUG_ON(r != DM_MAPIO_SUBMITTED);
+		bio = n;
+	}
+}
+
 /*
  * Error a list of buffers.
  */
@@ -821,39 +821,6 @@ static void __invalidate_snapshot(struct
 	dm_table_event(s->ti->table);
 }
 
-static void get_pending_exception(struct dm_snap_pending_exception *pe)
-{
-	atomic_inc(&pe->ref_count);
-}
-
-static struct bio *put_pending_exception(struct dm_snap_pending_exception *pe)
-{
-	struct dm_snap_pending_exception *primary_pe;
-	struct bio *origin_bios = NULL;
-
-	primary_pe = pe->primary_pe;
-
-	/*
-	 * If this pe is involved in a write to the origin and
-	 * it is the last sibling to complete then release
-	 * the bios for the original write to the origin.
-	 */
-	if (primary_pe &&
-	    atomic_dec_and_test(&primary_pe->ref_count)) {
-		origin_bios = bio_list_get(&primary_pe->origin_bios);
-		free_pending_exception(primary_pe);
-	}
-
-	/*
-	 * Free the pe if it's not linked to an origin write or if
-	 * it's not itself a primary pe.
-	 */
-	if (!primary_pe || primary_pe != pe)
-		free_pending_exception(pe);
-
-	return origin_bios;
-}
-
 static void pending_complete(struct dm_snap_pending_exception *pe, int success)
 {
 	struct dm_snap_exception *e;
@@ -902,7 +869,8 @@ static void pending_complete(struct dm_s
  out:
 	remove_exception(&pe->e);
 	snapshot_bios = bio_list_get(&pe->snapshot_bios);
-	origin_bios = put_pending_exception(pe);
+	origin_bios = bio_list_get(&pe->origin_bios);
+	free_pending_exception(pe);
 
 	up_write(&s->lock);
 
@@ -912,7 +880,7 @@ static void pending_complete(struct dm_s
 	else
 		flush_bios(snapshot_bios);
 
-	flush_bios(origin_bios);
+	retry_origin_bios(s, origin_bios);
 }
 
 static void commit_callback(void *context, int success)
@@ -970,15 +938,19 @@ static void start_copy(struct dm_snap_pe
  * for this chunk, otherwise it allocates a new one and inserts
  * it into the pending table.
  *
+ * Returns: pointer to a pending exception
+ *	ERR_PTR(-ENOMEM) pointer --- the snapshot is invalidated
+ *	NULL --- the exception was already completed, the caller should recheck
+ *
  * NOTE: a write lock must be held on snap->lock before calling
  * this.
  */
 static struct dm_snap_pending_exception *
-__find_pending_exception(struct dm_snapshot *s, struct bio *bio)
+__find_pending_exception(struct dm_snapshot *s, sector_t sector)
 {
 	struct dm_snap_exception *e;
 	struct dm_snap_pending_exception *pe;
-	chunk_t chunk = sector_to_chunk(s, bio->bi_sector);
+	chunk_t chunk = sector_to_chunk(s, sector);
 
 	/*
 	 * Is there a pending exception for this already ?
@@ -1000,6 +972,12 @@ __find_pending_exception(struct dm_snaps
 
 	if (!s->valid) {
 		free_pending_exception(pe);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	e = lookup_exception(&s->complete, chunk);
+	if (e) {
+		free_pending_exception(pe);
 		return NULL;
 	}
 
@@ -1013,16 +991,13 @@ __find_pending_exception(struct dm_snaps
 	pe->e.old_chunk = chunk;
 	bio_list_init(&pe->origin_bios);
 	bio_list_init(&pe->snapshot_bios);
-	pe->primary_pe = NULL;
-	atomic_set(&pe->ref_count, 0);
 	pe->started = 0;
 
 	if (s->store.prepare_exception(&s->store, &pe->e)) {
 		free_pending_exception(pe);
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 
-	get_pending_exception(pe);
 	insert_exception(&s->pending, &pe->e);
 
  out:
@@ -1063,6 +1038,7 @@ static int snapshot_map(struct dm_target
 		goto out_unlock;
 	}
 
+lookup_again:
 	/* If the block is already remapped - use that, else remap it */
 	e = lookup_exception(&s->complete, chunk);
 	if (e) {
@@ -1076,9 +1052,11 @@ static int snapshot_map(struct dm_target
 	 * writeable.
 	 */
 	if (bio_rw(bio) == WRITE) {
-		pe = __find_pending_exception(s, bio);
-		if (!pe) {
-			__invalidate_snapshot(s, -ENOMEM);
+		pe = __find_pending_exception(s, bio->bi_sector);
+		if (!pe)
+			goto lookup_again;
+		if (IS_ERR(pe)) {
+			__invalidate_snapshot(s, PTR_ERR(pe));
 			r = -EIO;
 			goto out_unlock;
 		}
@@ -1170,14 +1148,20 @@ static int snapshot_status(struct dm_tar
 /*-----------------------------------------------------------------
  * Origin methods
  *---------------------------------------------------------------*/
-static int __origin_write(struct list_head *snapshots, struct bio *bio)
+
+/*
+ * Returns:
+ *	DM_MAPIO_REMAPPED: bio may be submitted to origin device
+ *	DM_MAPIO_SUBMITTED: bio was queued on queue on one of exceptions
+ */
+
+static int __origin_write(struct list_head *snapshots, sector_t sector, struct bio *bio)
 {
-	int r = DM_MAPIO_REMAPPED, first = 0;
+	int r = DM_MAPIO_REMAPPED;
 	struct dm_snapshot *snap;
 	struct dm_snap_exception *e;
-	struct dm_snap_pending_exception *pe, *next_pe, *primary_pe = NULL;
+	struct dm_snap_pending_exception *pe, *pe_to_start = NULL;
 	chunk_t chunk;
-	LIST_HEAD(pe_queue);
 
 	/* Do all the snapshots on this origin */
 	list_for_each_entry (snap, snapshots, list) {
@@ -1189,86 +1173,65 @@ static int __origin_write(struct list_he
 			goto next_snapshot;
 
 		/* Nothing to do if writing beyond end of snapshot */
-		if (bio->bi_sector >= dm_table_get_size(snap->ti->table))
+		if (sector >= dm_table_get_size(snap->ti->table))
 			goto next_snapshot;
 
 		/*
 		 * Remember, different snapshots can have
 		 * different chunk sizes.
 		 */
-		chunk = sector_to_chunk(snap, bio->bi_sector);
+		chunk = sector_to_chunk(snap, sector);
 
 		/*
 		 * Check exception table to see if block
 		 * is already remapped in this snapshot
 		 * and trigger an exception if not.
-		 *
-		 * ref_count is initialised to 1 so pending_complete()
-		 * won't destroy the primary_pe while we're inside this loop.
 		 */
 		e = lookup_exception(&snap->complete, chunk);
 		if (e)
 			goto next_snapshot;
 
-		pe = __find_pending_exception(snap, bio);
-		if (!pe) {
-			__invalidate_snapshot(snap, -ENOMEM);
+		pe = __find_pending_exception(snap, sector);
+		if (!pe)
+			goto next_snapshot;
+		if (IS_ERR(pe)) {
+			__invalidate_snapshot(snap, PTR_ERR(pe));
 			goto next_snapshot;
 		}
 
-		if (!primary_pe) {
-			/*
-			 * Either every pe here has same
-			 * primary_pe or none has one yet.
-			 */
-			if (pe->primary_pe)
-				primary_pe = pe->primary_pe;
-			else {
-				primary_pe = pe;
-				first = 1;
-			}
-
-			bio_list_add(&primary_pe->origin_bios, bio);
-
-			r = DM_MAPIO_SUBMITTED;
-		}
+		r = DM_MAPIO_SUBMITTED;
 
-		if (!pe->primary_pe) {
-			pe->primary_pe = primary_pe;
-			get_pending_exception(primary_pe);
+		if (bio) {
+			bio_list_add(&pe->origin_bios, bio);
+			bio = NULL;
+
+			if (!pe->started) {
+				pe->started = 1;
+				pe_to_start = pe;
+			}
 		}
 
 		if (!pe->started) {
 			pe->started = 1;
-			list_add_tail(&pe->list, &pe_queue);
+			start_copy(pe);
 		}
 
  next_snapshot:
 		up_write(&snap->lock);
 	}
 
-	if (!primary_pe)
-		return r;
-
 	/*
-	 * If this is the first time we're processing this chunk and
-	 * ref_count is now 1 it means all the pending exceptions
-	 * got completed while we were in the loop above, so it falls to
-	 * us here to remove the primary_pe and submit any origin_bios.
+	 * pe_to_start is a small performance improvement:
+	 * To avoid calling __origin_write N times for N snapshots, we start
+	 * the snapshot where we queued the bio as the last one.
+	 *
+	 * If we start it as the last one, it finishes most likely as the last
+	 * one and exceptions in other snapshots will be already finished when
+	 * the bio will be retried.
 	 */
 
-	if (first && atomic_dec_and_test(&primary_pe->ref_count)) {
-		flush_bios(bio_list_get(&primary_pe->origin_bios));
-		free_pending_exception(primary_pe);
-		/* If we got here, pe_queue is necessarily empty. */
-		return r;
-	}
-
-	/*
-	 * Now that we have a complete pe list we can start the copying.
-	 */
-	list_for_each_entry_safe(pe, next_pe, &pe_queue, list)
-		start_copy(pe);
+	if (pe_to_start)
+		start_copy(pe_to_start);
 
 	return r;
 }
@@ -1284,7 +1247,7 @@ static int do_origin(struct dm_dev *orig
 	down_read(&_origins_lock);
 	o = __lookup_origin(origin->bdev);
 	if (o)
-		r = __origin_write(&o->snapshots, bio);
+		r = __origin_write(&o->snapshots, bio->bi_sector, bio);
 	up_read(&_origins_lock);
 
 	return r;
