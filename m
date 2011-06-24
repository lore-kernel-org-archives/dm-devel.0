From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-kcopyd/dm-snap: Don't read the origin on full
	chunk write
Date: Thu, 23 Jun 2011 20:25:44 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1106232021200.12675@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This is the new patch for optimizing full chunk write. dm-kcopyd provides 
only callbacks.

Mikulas

---

dm-kcopyd/dm-snap: Don't read the origin on full chunk write

If we write a full chunk in the snapshot, there is no need to read the origin
device (because the whole chunk will be overwritten anyway).

This patch changes snapshot write logic when full chunk is written.
In this case:
1. allocate the exception
2. dispatch the bio (but don't report the bio completion to device mapper)
3. write the exception record
4. report bio completed

Callbacks must be done through kcopyd thread, because callbacks must not
race with each other. So we create new functions 
dm_kcopyd_prepare_callback: allocate a job structure and prepare the callback.
This functino must not be called from interrupt context.
dm_kcopyd_do_callback: submit callback. This function may be called from
interrupt context.


Performance test (on snapshots with 4k chunk size):
without the patch:
non-direct-io sequential write (dd):    17.7MB/s
direct-io sequential write (dd):        20.9MB/s
non-direct-io random write (mkfs.ext2): 0.44s

with the patch:
non-direct-io sequential write (dd):    26.5MB/s
direct-io sequential write (dd):        33.2MB/s
non-direct-io random write (mkfs.ext2): 0.27s

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c    |   31 +++++++++++++++++++++++++
 drivers/md/dm-snap.c      |   56 +++++++++++++++++++++++++++++++++++++++++++---
 include/linux/dm-kcopyd.h |   11 +++++++++
 3 files changed, 95 insertions(+), 3 deletions(-)

Index: linux-2.6.39-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-kcopyd.c	2011-06-24 02:05:20.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-kcopyd.c	2011-06-24 02:07:09.000000000 +0200
@@ -725,6 +725,37 @@ int dm_kcopyd_zero(struct dm_kcopyd_clie
 }
 EXPORT_SYMBOL(dm_kcopyd_zero);
 
+void *dm_kcopyd_prepare_callback(struct dm_kcopyd_client *kc,
+				 dm_kcopyd_notify_fn fn, void *context)
+{
+	struct kcopyd_job *job;
+
+	job = mempool_alloc(kc->job_pool, GFP_NOIO);
+
+	memset(job, 0, sizeof(struct kcopyd_job));
+	job->kc = kc;
+	job->fn = fn;
+	job->context = context;
+
+	atomic_inc(&kc->nr_jobs);
+
+	return job;
+}
+EXPORT_SYMBOL(dm_kcopyd_prepare_callback);
+
+void dm_kcopyd_do_callback(void *j, int read_err, unsigned long write_err)
+{
+	struct kcopyd_job *job = j;
+	struct dm_kcopyd_client *kc = job->kc;
+
+	job->read_err = read_err;
+	job->write_err = write_err;
+
+	push(&kc->complete_jobs, job);
+	wake(kc);
+}
+EXPORT_SYMBOL(dm_kcopyd_do_callback);
+
 /*
  * Cancels a kcopyd job, eg. someone might be deactivating a
  * mirror.
Index: linux-2.6.39-fast/include/linux/dm-kcopyd.h
===================================================================
--- linux-2.6.39-fast.orig/include/linux/dm-kcopyd.h	2011-06-24 02:05:21.000000000 +0200
+++ linux-2.6.39-fast/include/linux/dm-kcopyd.h	2011-06-24 02:13:22.000000000 +0200
@@ -57,6 +57,17 @@ int dm_kcopyd_copy(struct dm_kcopyd_clie
 int dm_kcopyd_zero(struct dm_kcopyd_client *kc,
 		   unsigned num_dests, struct dm_io_region *dests,
 		   unsigned flags, dm_kcopyd_notify_fn fn, void *context);
+/*
+ * Prepare a callback and submit it via kcopyd thread.
+ * dm_kcopyd_prepare_callback allocates a callback structure and returns it.
+ * The returned value is then passed to dm_kcopyd_do_callback.
+ * dm_kcopyd_prepare_callback must not be called from interrupt context.
+ * dm_kcopyd_do_callback submits the callback. The callback is done via kcopyd
+ * thread. dm_kcopyd_do_callback may be called from interrupt context.
+ */
+void *dm_kcopyd_prepare_callback(struct dm_kcopyd_client *kc,
+				 dm_kcopyd_notify_fn fn, void *context);
+void dm_kcopyd_do_callback(void *job, int read_err, unsigned long write_err);
 
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_DM_KCOPYD_H */
Index: linux-2.6.39-fast/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-snap.c	2011-06-24 02:05:21.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-snap.c	2011-06-24 02:07:09.000000000 +0200
@@ -173,6 +173,10 @@ struct dm_snap_pending_exception {
 	 * kcopyd.
 	 */
 	int started;
+
+	struct bio *full_bio;
+	bio_end_io_t *full_bio_end_io;
+	void *full_bio_private;
 };
 
 /*
@@ -1373,6 +1377,7 @@ static void pending_complete(struct dm_s
 	struct dm_snapshot *s = pe->snap;
 	struct bio *origin_bios = NULL;
 	struct bio *snapshot_bios = NULL;
+	struct bio *full_bio = NULL;
 	int error = 0;
 
 	if (!success) {
@@ -1412,6 +1417,11 @@ static void pending_complete(struct dm_s
 	dm_remove_exception(&pe->e);
 	snapshot_bios = bio_list_get(&pe->snapshot_bios);
 	origin_bios = bio_list_get(&pe->origin_bios);
+	full_bio = pe->full_bio;
+	if (full_bio) {
+		full_bio->bi_end_io = pe->full_bio_end_io;
+		full_bio->bi_private = pe->full_bio_private;
+	}
 	free_pending_exception(pe);
 
 	increment_pending_exceptions_done_count();
@@ -1419,10 +1429,15 @@ static void pending_complete(struct dm_s
 	up_write(&s->lock);
 
 	/* Submit any pending write bios */
-	if (error)
+	if (error) {
+		if (full_bio)
+			bio_io_error(full_bio);
 		error_bios(snapshot_bios);
-	else
+	} else {
+		if (full_bio)
+			bio_endio(full_bio, 0);
 		flush_bios(snapshot_bios);
+	}
 
 	retry_origin_bios(s, origin_bios);
 }
@@ -1477,6 +1492,31 @@ static void start_copy(struct dm_snap_pe
 		    &src, 1, &dest, 0, copy_callback, pe);
 }
 
+static void full_bio_end_io(struct bio *bio, int error)
+{
+	void *callback = bio->bi_private;
+	dm_kcopyd_do_callback(callback, 0, error ? 1 : 0);
+}
+
+static void start_full_bio(struct dm_snap_pending_exception *pe,
+			   struct bio *bio)
+{
+	struct dm_snapshot *s = pe->snap;
+	void *callback;
+
+	pe->full_bio = bio;
+	pe->full_bio_end_io = bio->bi_end_io;
+	pe->full_bio_private = bio->bi_private;
+
+	callback = dm_kcopyd_prepare_callback(s->kcopyd_client,
+					      copy_callback, pe);
+
+	bio->bi_end_io = full_bio_end_io;
+	bio->bi_private = callback;
+
+	generic_make_request(bio);
+}
+
 static struct dm_snap_pending_exception *
 __lookup_pending_exception(struct dm_snapshot *s, chunk_t chunk)
 {
@@ -1512,6 +1552,7 @@ __find_pending_exception(struct dm_snaps
 	bio_list_init(&pe->origin_bios);
 	bio_list_init(&pe->snapshot_bios);
 	pe->started = 0;
+	pe->full_bio = NULL;
 
 	if (s->store->type->prepare_exception(s->store, &pe->e)) {
 		free_pending_exception(pe);
@@ -1605,10 +1646,19 @@ static int snapshot_map(struct dm_target
 		}
 
 		remap_exception(s, &pe->e, bio, chunk);
-		bio_list_add(&pe->snapshot_bios, bio);
 
 		r = DM_MAPIO_SUBMITTED;
 
+		if (!pe->started &&
+		    bio->bi_size == (s->store->chunk_size << SECTOR_SHIFT)) {
+			pe->started = 1;
+			up_write(&s->lock);
+			start_full_bio(pe, bio);
+			goto out;
+		}
+
+		bio_list_add(&pe->snapshot_bios, bio);
+
 		if (!pe->started) {
 			/* this is protected by snap->lock */
 			pe->started = 1;
