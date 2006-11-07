From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [Patch 11 of 14] Device Mapper Mirror
Date: Tue, 07 Nov 2006 10:06:49 -0600
Message-ID: <1162915609.17899.57.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: dm-devel@redhat.com
Cc: heinzm@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

 brassow

This patch gives the ability to respond-to/record device failures
that happen during read operations.  It also adds the ability to
read from mirror devices that are not the primary if they are
in-sync.

There are essentially two read paths in mirroring; the direct path
and the queued path.  When a read request is mapped, if the region
is 'in-sync' the direct path is taken; otherwise the queued path
is taken.

If the direct path is taken, we recored bio information so that if
the read fails we can retry it.  We discover the status of a direct
read through mirror_end_io.  If the read has failed, we mark the
device from which the read was attempted as failed (so we don't try
to read from it again), restore the bio and try again.

If the queued path is taken, we discover the results of the read
from 'read_callback'.  If the device failed, we mark the device
as failed and we attempt the read again if there is another device
where this region is known to be 'in-sync'.

Index: linux-2.6.18.1/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.18.1.orig/drivers/md/dm-raid1.c	2006-11-06 16:59:53.000000000 -0600
+++ linux-2.6.18.1/drivers/md/dm-raid1.c	2006-11-06 16:59:59.000000000 -0600
@@ -6,6 +6,7 @@
 
 #include "dm.h"
 #include "dm-bio-list.h"
+#include "dm-bio-record.h"
 #include "dm-io.h"
 #include "dm-log.h"
 #include "kcopyd.h"
@@ -626,24 +627,39 @@ static void rh_start_recovery(struct reg
 	wake();
 }
 
+struct bio_map_info {
+	struct mirror *bmi_m;
+	struct dm_bio_details bmi_bd;
+};
+
+static mempool_t *bio_map_info_pool = NULL;
+
+static void *bio_map_info_alloc(unsigned int gfp_mask, void *pool_data){
+	return kmalloc(sizeof(struct bio_map_info), gfp_mask);
+}
+
+static void bio_map_info_free(void *element, void *pool_data){
+	kfree(element);
+}
+
 /*
  * Every mirror should look like this one.
  */
 #define DEFAULT_MIRROR 0
 
 /*
- * This is yucky.  We squirrel the mirror_set struct away inside
- * bi_next for write buffers.  This is safe since the bh
+ * This is yucky.  We squirrel the mirror struct away inside
+ * bi_next for read/write buffers.  This is safe since the bh
  * doesn't get submitted to the lower levels of block layer.
  */
-static struct mirror_set *bio_get_ms(struct bio *bio)
+static struct mirror *bio_get_m(struct bio *bio)
 {
-	return (struct mirror_set *) bio->bi_next;
+	return (struct mirror *) bio->bi_next;
 }
 
-static void bio_set_ms(struct bio *bio, struct mirror_set *ms)
+static void bio_set_m(struct bio *bio, struct mirror *m)
 {
-	bio->bi_next = (struct bio *) ms;
+	bio->bi_next = (struct bio *) m;
 }
 
 /*-----------------------------------------------------------------
@@ -768,8 +784,17 @@ static void do_recovery(struct mirror_se
  *---------------------------------------------------------------*/
 static struct mirror *choose_mirror(struct mirror_set *ms, sector_t sector)
 {
-	/* FIXME: add read balancing */
-	return ms->default_mirror;
+	struct mirror *m = ms->default_mirror;
+
+	do {
+		if (likely(!atomic_read(&m->error_count)))
+		    return m;
+
+		if (m-- == ms->mirror)
+			m += ms->nr_mirrors;
+	} while (m != ms->default_mirror);
+
+	return NULL;
 }
 
 /* fail_mirror
@@ -819,37 +844,104 @@ static void fail_mirror(struct mirror *m
 		DMWARN("All sides of mirror have failed.");
 }
 
+static int default_ok(struct mirror *m)
+{
+	return !atomic_read(&m->ms->default_mirror->error_count);
+}
+
+static int mirror_available(struct mirror_set *ms, struct bio *bio)
+{
+	region_t region = bio_to_region(&ms->rh, bio);
+
+	if (ms->rh.log->type->in_sync(ms->rh.log, region, 0) > 0)
+		return choose_mirror(ms,  bio->bi_sector) ? 1 : 0;
+
+	return 0;
+}
+
 /*
  * remap a buffer to a particular mirror.
  */
-static void map_bio(struct mirror_set *ms, struct mirror *m, struct bio *bio)
+static sector_t map_sector(struct mirror *m, struct bio *bio)
+{
+	return m->offset + (bio->bi_sector - m->ms->ti->begin);
+}
+
+static void map_bio(struct mirror *m, struct bio *bio)
 {
 	bio->bi_bdev = m->dev->bdev;
-	bio->bi_sector = m->offset + (bio->bi_sector - ms->ti->begin);
+	bio->bi_sector = map_sector(m, bio);
+}
+
+static void map_region(struct io_region *io, struct mirror *m,
+		       struct bio *bio)
+{
+	io->bdev = m->dev->bdev;
+	io->sector = map_sector(m, bio);
+	io->count = bio->bi_size >> 9;
 }
 
 /*-----------------------------------------------------------------
  * Reads
  *---------------------------------------------------------------*/
+static void read_callback(unsigned long error, void *context)
+{
+	struct bio *bio = (struct bio *)context;
+	struct mirror *m;
+
+	m = bio_get_m(bio);
+	bio_set_m(bio, NULL);
+
+	if (unlikely(error)) {
+		DMWARN("A read failure occurred on a mirror device.");
+		fail_mirror(m);
+		if (likely(default_ok(m)) || mirror_available(m->ms, bio)) {
+			DMWARN("Trying different device.");
+			queue_bio(m->ms, bio, bio_rw(bio));
+		} else {
+			DMERR("No other device available, failing I/O.");
+			bio_endio(bio, bio->bi_size, -EIO);
+		}
+	} else
+		bio_endio(bio, bio->bi_size, 0);
+}
+
+/* Asynchronous read. */
+static void read_async_bio(struct mirror *m, struct bio *bio)
+{
+	struct io_region io;
+
+	map_region(&io, m, bio);
+	bio_set_m(bio, m);
+	dm_io_async_bvec(1, &io, READ,
+			 bio->bi_io_vec + bio->bi_idx,
+			 read_callback, bio);
+}
+
 static void do_reads(struct mirror_set *ms, struct bio_list *reads)
 {
-	region_t region;
 	struct bio *bio;
 	struct mirror *m;
 
 	while ((bio = bio_list_pop(reads))) {
-		region = bio_to_region(&ms->rh, bio);
-
 		/*
 		 * We can only read balance if the region is in sync.
 		 */
-		if (rh_in_sync(&ms->rh, region, 0))
+		if (likely(rh_in_sync(&ms->rh,
+				      bio_to_region(&ms->rh, bio), 0)))
 			m = choose_mirror(ms, bio->bi_sector);
-		else
+		else {
 			m = ms->default_mirror;
 
-		map_bio(ms, m, bio);
-		generic_make_request(bio);
+			/* If default has failed, we give up. */
+			if (unlikely(m && atomic_read(&m->error_count)))
+				m = NULL;
+		}
+
+		if (likely(m))
+			read_async_bio(m, bio);
+		else
+			bio_endio(bio, bio->bi_size, -EIO);
 	}
 }
 
@@ -924,8 +1016,8 @@ static void write_callback(unsigned long
 	int uptodate = 0;
 	int should_wake = 0;
 
-	ms = bio_get_ms(bio);
-	bio_set_ms(bio, NULL);
+	ms = (bio_get_m(bio))->ms;
+	bio_set_m(bio, NULL);
 
 	/*
 	 * NOTE: We don't decrement the pending count here,
@@ -970,7 +1062,7 @@ static void write_callback(unsigned long
 static void do_write(struct mirror_set *ms, struct bio *bio, int log_failure)
 {
 	unsigned int i;
-	struct io_region io[KCOPYD_MAX_REGIONS+1];
+	struct io_region io[ms->nr_mirrors], *dest = io;
 	struct mirror *m;
 
 	if (log_failure) {
@@ -982,15 +1074,15 @@ static void do_write(struct mirror_set *
 		return;
 	}
 
-	for (i = 0; i < ms->nr_mirrors; i++) {
-		m = ms->mirror + i;
-
-		io[i].bdev = m->dev->bdev;
-		io[i].sector = m->offset + (bio->bi_sector - ms->ti->begin);
-		io[i].count = bio->bi_size >> 9;
-	}
+	for (i = 0, m = ms->mirror; i < ms->nr_mirrors; i++, m++)
+		map_region(dest++, m, bio);
 
-	bio_set_ms(bio, ms);
+	/*
+	 * We can use the default mirror here, because we
+	 * only need it in order to retrieve the reference
+	 * to the mirror set in write_callback().
+	 */
+	bio_set_m(bio, ms->default_mirror);
 	dm_io_async_bvec(ms->nr_mirrors, io, WRITE,
 			 bio->bi_io_vec + bio->bi_idx,
 			 write_callback, bio);
@@ -1052,7 +1144,7 @@ static void do_writes(struct mirror_set 
 		rh_delay(&ms->rh, bio);
 
 	while ((bio = bio_list_pop(&nosync))) {
-		map_bio(ms, ms->default_mirror, bio);
+		map_bio(ms->default_mirror, bio);
 		generic_make_request(bio);
 	}
 }
@@ -1424,42 +1516,66 @@ static int mirror_map(struct dm_target *
 	int r, rw = bio_rw(bio);
 	struct mirror *m;
 	struct mirror_set *ms = ti->private;
-
-	map_context->ll = bio_to_region(&ms->rh, bio);
+	struct bio_map_info *bmi = NULL;
+	struct dm_bio_details *bd = NULL;
 
 	if (rw == WRITE) {
+		/* Save region for mirror_end_io() handler */
+		map_context->ll = bio_to_region(&ms->rh, bio);
 		queue_bio(ms, bio, rw);
 		return 0;
 	}
 
+	/* All about the reads now */
+
 	r = ms->rh.log->type->in_sync(ms->rh.log,
 				      bio_to_region(&ms->rh, bio), 0);
 	if (r < 0 && r != -EWOULDBLOCK)
 		return r;
 
-	if (r == -EWOULDBLOCK)	/* FIXME: ugly */
+	if (r == -EWOULDBLOCK)
 		r = 0;
 
-	/*
-	 * We don't want to fast track a recovery just for a read
-	 * ahead.  So we just let it silently fail.
-	 * FIXME: get rid of this.
-	 */
-	if (!r && rw == READA)
-		return -EIO;
+	if (likely(r)) {
+		/*
+		 * Optimize reads by avoiding to hand them to daemon.
+		 *
+		 * In case they fail, queue them for another shot
+		 * in the mirror_end_io() function.
+		 */
+		m = choose_mirror(ms, bio->bi_sector);
+		if (likely(m)) {
+			bmi = mempool_alloc(bio_map_info_pool, GFP_NOIO);
+
+			if (likely(bmi)) {
+				/* without this, a read is not retryable */
+				bd = &bmi->bmi_bd;
+				dm_bio_record(bd, bio);
+				map_context->ptr = bmi;
+				bmi->bmi_m = m;
+			} else {
+				/*
+				 * we could fail now, but we can at least
+				 * give it a shot.  The bd is only used to
+				 * retry in the event of a failure anyway.
+				 * If we fail, we can fail the I/O then.
+				 */
+				map_context->ptr = NULL;
+			}
+
+			map_bio(m, bio);
+			return 1; /* Mapped -> queue request. */
+		} else
+			return -EIO;
+	} else {
+		/* Either not clean, or -EWOULDBLOCK */
+		if (rw == READA)
+			return -EWOULDBLOCK;
 
-	if (!r) {
-		/* Pass this io over to the daemon */
 		queue_bio(ms, bio, rw);
-		return 0;
 	}
 
-	m = choose_mirror(ms, bio->bi_sector);
-	if (!m)
-		return -EIO;
-
-	map_bio(ms, m, bio);
-	return 1;
+	return 0;
 }
 
 static int mirror_end_io(struct dm_target *ti, struct bio *bio,
@@ -1467,15 +1583,61 @@ static int mirror_end_io(struct dm_targe
 {
 	int rw = bio_rw(bio);
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
-	region_t region = map_context->ll;
+	struct mirror *m = NULL;
+	struct dm_bio_details *bd = NULL;
 
 	/*
 	 * We need to dec pending if this was a write.
 	 */
-	if (rw == WRITE)
-		rh_dec(&ms->rh, region);
+	if (rw == WRITE) {
+		rh_dec(&ms->rh, map_context->ll);
+		return error;
+	}
 
-	return 0;
+	if (error == -EOPNOTSUPP)
+		goto out;
+
+	if ((error == -EWOULDBLOCK) && bio_rw_ahead(bio))
+		goto out;
+
+	if (unlikely(error)) {
+		DMERR("A read failure occurred on a mirror device.");
+		if (!map_context->ptr) {
+			/*
+			 * There wasn't enough memory to record necessary
+			 * information for a retry or there was no other
+			 * mirror in-sync.
+			 */
+			DMERR("Unable to retry read.");
+			return -EIO;
+		}
+		m = ((struct bio_map_info *)map_context->ptr)->bmi_m;
+		fail_mirror(m); /* Flag error on mirror. */
+
+		/*
+		 * A failed read needs to get queued
+		 * to the daemon for another shot to
+		 * one (if any) intact mirrors.
+		 */
+		if (default_ok(m) || mirror_available(ms, bio)) {
+			bd = &(((struct bio_map_info *)map_context->ptr)->bmi_bd
+				);
+
+			DMWARN("Trying different device.");
+			dm_bio_restore(bd, bio);
+			mempool_free(map_context->ptr, bio_map_info_pool);
+			map_context->ptr = NULL;
+			queue_bio(ms, bio, rw);
+			return 1; /* We want another shot on the bio. */
+		}
+		DMERR("All replicated volumes dead, failing I/O");
+	}
+
+out:
+	if (map_context->ptr)
+		mempool_free(map_context->ptr, bio_map_info_pool);
+
+	return error;
 }
 
 static void mirror_postsuspend(struct dm_target *ti)
@@ -1557,6 +1719,11 @@ static int __init dm_mirror_init(void)
 {
 	int r;
 
+	bio_map_info_pool = mempool_create(100, bio_map_info_alloc,
+					   bio_map_info_free, NULL);
+	if (!bio_map_info_pool)
+		return -ENOMEM;
+
 	r = dm_dirty_log_init();
 	if (r)
 		return r;
