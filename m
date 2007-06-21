From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [2.6.22-rc4-mm2 PATCH 9/11]
	dm-raid1-handle-read-failures.patch
Date: Thu, 21 Jun 2007 16:04:45 -0500
Message-ID: <1182459885.13518.31.camel@hydrogen.msp.redhat.com>
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
To: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

update header and try to reduce nesting.

[mirror_map looks pretty good now.  mirror_end_io is pretty clean with a
max of 2 levels of indentation.]

 brassow

This patch gives the ability to respond-to/record device failures
that happen during read operations.  It also adds the ability to
read from mirror devices that are not the primary if they are
in-sync.

There are essentially two read paths in mirroring; the direct path
and the queued path.  When a read request is mapped, if the region
is 'in-sync' the direct path is taken; otherwise the queued path
is taken.

If the direct path is taken, we must record bio information so that
if the read fails we can retry it.  We then discover the status of
a direct read through mirror_end_io.  If the read has failed, we will
mark the device from which the read was attempted as failed (so we
don't try to read from it again), restore the bio and try again.

If the queued path is taken, we discover the results of the read
from 'read_callback'.  If the device failed, we will mark the device
as failed and attempt the read again if there is another device
where this region is known to be 'in-sync'.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6.22-rc4-mm2/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/md/dm-raid1.c
+++ linux-2.6.22-rc4-mm2/drivers/md/dm-raid1.c
@@ -6,6 +6,7 @@
 
 #include "dm.h"
 #include "dm-bio-list.h"
+#include "dm-bio-record.h"
 #include "dm-io.h"
 #include "dm-log.h"
 #include "kcopyd.h"
@@ -637,24 +638,39 @@ static void rh_start_recovery(struct reg
 	wake(rh->ms);
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
@@ -776,13 +792,19 @@ static void do_recovery(struct mirror_se
 	}
 }
 
-/*-----------------------------------------------------------------
- * Reads
- *---------------------------------------------------------------*/
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
@@ -834,13 +856,84 @@ static void fail_mirror(struct mirror *m
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
+}
+
+/*-----------------------------------------------------------------
+ * Reads
+ *---------------------------------------------------------------*/
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
+	struct dm_io_request io_req = {
+		.bi_rw = READ,
+		.mem.type = DM_IO_BVEC,
+		.mem.ptr.bvec = bio->bi_io_vec + bio->bi_idx,
+		.notify.fn = read_callback,
+		.notify.context = bio,
+		.client = m->ms->io_client,
+	};
+
+	map_region(&io, m, bio);
+	bio_set_m(bio, m);
+	(void) dm_io(&io_req, 1, &io, NULL);
 }
 
 static void do_reads(struct mirror_set *ms, struct bio_list *reads)
@@ -851,17 +944,20 @@ static void do_reads(struct mirror_set *
 
 	while ((bio = bio_list_pop(reads))) {
 		region = bio_to_region(&ms->rh, bio);
+		m = ms->default_mirror;
 
 		/*
 		 * We can only read balance if the region is in sync.
 		 */
-		if (rh_in_sync(&ms->rh, region, 1))
+		if (likely(rh_in_sync(&ms->rh, region, 1)))
 			m = choose_mirror(ms, bio->bi_sector);
-		else
-			m = ms->default_mirror;
+		else if (m && atomic_read(&m->error_count))
+			m = NULL;
 
-		map_bio(ms, m, bio);
-		generic_make_request(bio);
+		if (likely(m))
+			read_async_bio(m, bio);
+		else
+			bio_endio(bio, bio->bi_size, -EIO);
 	}
 }
 
@@ -936,8 +1032,8 @@ static void write_callback(unsigned long
 	int uptodate = 0;
 	int should_wake = 0;
 
-	ms = bio_get_ms(bio);
-	bio_set_ms(bio, NULL);
+	ms = (bio_get_m(bio))->ms;
+	bio_set_m(bio, NULL);
 
 	/*
 	 * NOTE: We don't decrement the pending count here,
@@ -980,7 +1076,7 @@ out:
 static void do_write(struct mirror_set *ms, struct bio *bio)
 {
 	unsigned int i;
-	struct io_region io[KCOPYD_MAX_REGIONS+1];
+	struct io_region io[ms->nr_mirrors], *dest = io;
 	struct mirror *m;
 	struct dm_io_request io_req = {
 		.bi_rw = WRITE,
@@ -991,15 +1087,15 @@ static void do_write(struct mirror_set *
 		.client = ms->io_client,
 	};
 
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
 
 	(void) dm_io(&io_req, ms->nr_mirrors, io, NULL);
 }
@@ -1063,7 +1159,7 @@ static void do_writes(struct mirror_set 
 		rh_delay(&ms->rh, bio);
 
 	while ((bio = bio_list_pop(&nosync))) {
-		map_bio(ms, ms->default_mirror, bio);
+		map_bio(ms->default_mirror, bio);
 		generic_make_request(bio);
 	}
 }
@@ -1448,42 +1544,63 @@ static int mirror_map(struct dm_target *
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
 		return DM_MAPIO_SUBMITTED;
 	}
 
+	/* All about the reads now */
+
 	r = ms->rh.log->type->in_sync(ms->rh.log,
 				      bio_to_region(&ms->rh, bio), 0);
 	if (r < 0 && r != -EWOULDBLOCK)
 		return r;
 
-	if (r == -EWOULDBLOCK)	/* FIXME: ugly */
-		r = DM_MAPIO_SUBMITTED;
-
-	/*
-	 * We don't want to fast track a recovery just for a read
-	 * ahead.  So we just let it silently fail.
-	 * FIXME: get rid of this.
-	 */
-	if (!r && rw == READA)
-		return -EIO;
+	if (!r || (r == -EWOULDBLOCK)) {
+		/* Region is not in-sync, must queue bio */
+		if (rw == READA)
+			return -EWOULDBLOCK;
 
-	if (!r) {
-		/* Pass this io over to the daemon */
 		queue_bio(ms, bio, rw);
 		return DM_MAPIO_SUBMITTED;
 	}
 
+	/*
+	 * If we are here, it means the region is in-sync and
+	 * we can optimize reads by avoiding to hand them to daemon.
+	 *
+	 * In case they fail, queue them for another shot
+	 * in the mirror_end_io() function.
+	 */
 	m = choose_mirror(ms, bio->bi_sector);
-	if (!m)
+	if (unlikely(!m))
 		return -EIO;
 
-	map_bio(ms, m, bio);
-	return DM_MAPIO_REMAPPED;
+	bmi = mempool_alloc(bio_map_info_pool, GFP_NOIO);
+
+	if (likely(bmi)) {
+		/* without this, a read is not retryable */
+		bd = &bmi->bmi_bd;
+		dm_bio_record(bd, bio);
+		map_context->ptr = bmi;
+		bmi->bmi_m = m;
+	} else {
+		/*
+		 * we could fail now, but we can at least
+		 * give it a shot.  The bd is only used to
+		 * retry in the event of a failure anyway.
+		 * If we fail, we can fail the I/O then.
+		 */
+		map_context->ptr = NULL;
+	}
+
+	map_bio(m, bio);
+	return DM_MAPIO_REMAPPED; /* Mapped -> queue request. */
 }
 
 static int mirror_end_io(struct dm_target *ti, struct bio *bio,
@@ -1491,15 +1608,60 @@ static int mirror_end_io(struct dm_targe
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
+			bd = &(((struct bio_map_info *)map_context->ptr)->bmi_bd);
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
 
 static void mirror_presuspend(struct dm_target *ti)
@@ -1612,6 +1774,11 @@ static int __init dm_mirror_init(void)
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
