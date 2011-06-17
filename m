From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-kcopyd/dm-snap: Don't read the origin on full
	chunk write
Date: Fri, 17 Jun 2011 08:32:36 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1106170829390.24411@hs20-bc2-1.build.redhat.com>
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

This optimizes full chunk writes for snapshots.

Note that there is a performance bug in device mapper that it doesn't ever 
send bios larger than 4k to snapshots. So this patch optimizes only 4k 
chunk sizes. Once the 4k limit will be removed from device mapper, this 
patch could optimize any chunk size.

Mikulas

---

dm-kcopyd/dm-snap: Don't read the origin on full chunk write

If we write a full chunk in the snapshot, there is no need to read the origin
device (because the whole chunk will be overwritten anyway).

This patch introduces a new function dm_kcopyd_submit_bios that submits the
bio (or more bios linked with bi_next) and signals the completion from the
kcopyd thread.

This patch changes snapshot write logic when full chunk is written.
In this case:
1. allocate the exception
2. dispatch the bio (but don't report the bio completion to device mapper)
3. write the exception metadata
4. report bio completed

Performance test (on snapshots with 4k chunk size):
without the patch:
non-direct-io sequential write (dd):	17.7MB/s
direct-io sequential write (dd):	20.9MB/s
non-direct-io random write (mkfs.ext2):	0.44s

with the patch:
non-direct-io sequential write (dd):	26.5MB/s
direct-io sequential write (dd):	33.2MB/s
non-direct-io random write (mkfs.ext2):	0.27s

It doesn't improve performance with >4k chunk size because there is
a problem in device mapper --- it doesn't ever send bios larger than
page size to snapshots.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c    |   64 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-snap.c      |   36 +++++++++++++++++++++++--
 include/linux/dm-kcopyd.h |    3 ++
 3 files changed, 100 insertions(+), 3 deletions(-)

Index: linux-2.6.39-fast/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-snap.c	2011-06-16 19:50:45.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-snap.c	2011-06-16 20:00:51.000000000 +0200
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
@@ -1512,6 +1527,7 @@ __find_pending_exception(struct dm_snaps
 	bio_list_init(&pe->origin_bios);
 	bio_list_init(&pe->snapshot_bios);
 	pe->started = 0;
+	pe->full_bio = NULL;
 
 	if (s->store->type->prepare_exception(s->store, &pe->e)) {
 		free_pending_exception(pe);
@@ -1605,10 +1621,24 @@ static int snapshot_map(struct dm_target
 		}
 
 		remap_exception(s, &pe->e, bio, chunk);
-		bio_list_add(&pe->snapshot_bios, bio);
 
 		r = DM_MAPIO_SUBMITTED;
 
+		if (!pe->started &&
+		    bio->bi_size == (s->store->chunk_size << SECTOR_SHIFT)) {
+			pe->full_bio_end_io = bio->bi_end_io;
+			pe->full_bio_private = bio->bi_private;
+			pe->full_bio = bio;
+			pe->started = 1;
+			up_write(&s->lock);
+
+			dm_kcopyd_submit_bios(s->kcopyd_client, bio, 0,
+					      copy_callback, pe);
+			goto out;
+		}
+
+		bio_list_add(&pe->snapshot_bios, bio);
+
 		if (!pe->started) {
 			/* this is protected by snap->lock */
 			pe->started = 1;
Index: linux-2.6.39-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-kcopyd.c	2011-06-16 19:50:45.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-kcopyd.c	2011-06-17 12:52:54.000000000 +0200
@@ -755,6 +755,70 @@ int dm_kcopyd_zero(struct dm_kcopyd_clie
 }
 EXPORT_SYMBOL(dm_kcopyd_zero);
 
+static void dm_kcopyd_bio_end_io(struct bio *bio, int error)
+{
+	struct kcopyd_job *job = bio->bi_private;
+
+	if (unlikely(error))
+		job->write_err = 1;
+
+	if (atomic_dec_and_test(&job->sub_jobs)) {
+		struct dm_kcopyd_client *kc = job->kc;
+		push(&kc->complete_jobs, job);
+		wake(kc);
+	}
+}
+
+int dm_kcopyd_submit_bios(struct dm_kcopyd_client *kc,
+			  struct bio *bios, unsigned int flags,
+			  dm_kcopyd_notify_fn fn, void *context)
+{
+	struct kcopyd_job *job;
+	struct bio *bio;
+	unsigned n_bios;
+
+	/*
+	 * Allocate a new job.
+	 */
+	job = mempool_alloc(kc->job_pool, GFP_NOIO);
+
+	/*
+	 * set up for the write.
+	 */
+	job->kc = kc;
+	job->flags = flags;
+	job->read_err = 0;
+	job->write_err = 0;
+	job->pages = NULL;
+
+	job->fn = fn;
+	job->context = context;
+
+	atomic_inc(&kc->nr_jobs);
+
+	n_bios = 0;
+	bio = bios;
+	do {
+		n_bios++;
+		bio = bio->bi_next;
+	} while (bio);
+
+	atomic_set(&job->sub_jobs, n_bios);
+
+	bio = bios;
+	do {
+		struct bio *next_bio = bio->bi_next;
+		bio->bi_next = NULL;
+		bio->bi_end_io = dm_kcopyd_bio_end_io;
+		bio->bi_private = job;
+		generic_make_request(bio);
+		bio = next_bio;
+	} while (bio);
+
+	return 0;
+}
+EXPORT_SYMBOL(dm_kcopyd_submit_bios);
+
 /*
  * Cancels a kcopyd job, eg. someone might be deactivating a
  * mirror.
Index: linux-2.6.39-fast/include/linux/dm-kcopyd.h
===================================================================
--- linux-2.6.39-fast.orig/include/linux/dm-kcopyd.h	2011-06-16 19:50:46.000000000 +0200
+++ linux-2.6.39-fast/include/linux/dm-kcopyd.h	2011-06-16 19:54:17.000000000 +0200
@@ -58,6 +58,9 @@ int dm_kcopyd_copy(struct dm_kcopyd_clie
 int dm_kcopyd_zero(struct dm_kcopyd_client *kc,
 		   unsigned num_dests, struct dm_io_region *dests,
 		   unsigned flags, dm_kcopyd_notify_fn fn, void *context);
+int dm_kcopyd_submit_bios(struct dm_kcopyd_client *kc,
+			  struct bio *bios, unsigned int flags,
+			  dm_kcopyd_notify_fn fn, void *context);
 
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_DM_KCOPYD_H */
