From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: mirroring: device failure tolerance
Date: Fri, 24 Jun 2005 15:16:16 -0500
Message-ID: <12249dad6f7ea11612dfb0a87d22bbf3@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v622)
Content-Type: multipart/mixed; boundary=Apple-Mail-9--396943727
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


--Apple-Mail-9--396943727
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed

Attached is a patch to provide device failure tolerance/detection for 
mirroring.

  brassow

P.S.  A basic write-up of how things work is at 
http://www.brassow.com/mirroring/index.html


--Apple-Mail-9--396943727
Content-Transfer-Encoding: 7bit
Content-Type: application/octet-stream;
	x-unix-mode=0664;
	name="005.patch"
Content-Disposition: attachment;
	filename=005.patch

--- linux-2.6.12/drivers/md/dm-log.h-patch	2005-06-21 14:40:48.000000000 -0500
+++ linux-2.6.12/drivers/md/dm-log.h	2005-06-23 22:39:04.687203685 -0500
@@ -9,6 +9,11 @@
 
 #include "dm.h"
 
+#define LOG_DIRTY 0
+#define LOG_CLEAN 1  /* if a region is clean, it is also in sync */
+#define LOG_NOSYNC 2
+#define LOG_REMOTE_RECOVERING 3
+
 typedef sector_t region_t;
 
 struct dirty_log_type;
@@ -23,6 +28,7 @@
 	const char *name;
 	struct module *module;
 	unsigned int use_count;
+	unsigned int multi_node;
 
 	int (*ctr)(struct dirty_log *log, struct dm_target *ti,
 		   unsigned int argc, char **argv);
@@ -128,3 +134,13 @@
 void dm_dirty_log_exit(void);
 
 #endif
+/*
+ * Overrides for Emacs so that we follow Linus's tabbing style.
+ * Emacs will notice this stuff at the end of the file and automatically
+ * adjust the settings for this buffer only.  This must remain at the end
+ * of the file.
+ * ---------------------------------------------------------------------------
+ * Local variables:
+ * c-file-style: "linux"
+ * End:
+ */
--- linux-2.6.12/drivers/md/dm.c-patch	2005-06-21 14:40:48.000000000 -0500
+++ linux-2.6.12/drivers/md/dm.c	2005-06-23 15:31:03.000000000 -0500
@@ -1055,14 +1055,14 @@
 	if (test_bit(DMF_BLOCK_IO, &md->flags))
 		goto out_read_unlock;
 
-	error = __lock_fs(md);
-	if (error)
-		goto out_read_unlock;
-
 	map = dm_get_table(md);
 	if (map)
 		dm_table_presuspend_targets(map);
 
+	error = __lock_fs(md);
+	if (error)
+		goto out_read_unlock;
+
 	up_read(&md->lock);
 
 	/*
--- linux-2.6.12/drivers/md/dm-raid1.c-patch	2005-06-21 14:40:48.000000000 -0500
+++ linux-2.6.12/drivers/md/dm-raid1.c	2005-06-24 15:11:53.150233021 -0500
@@ -1,11 +1,13 @@
 /*
  * Copyright (C) 2003 Sistina Software Limited.
+ * Copyright (C) 2004-2005 Red Hat Inc.
  *
  * This file is released under the GPL.
  */
 
 #include "dm.h"
 #include "dm-bio-list.h"
+#include "dm-bio-record.h"
 #include "dm-io.h"
 #include "dm-log.h"
 #include "kcopyd.h"
@@ -28,6 +30,8 @@
 	queue_work(_kmirrord_wq, &_kmirrord_work);
 }
 
+static struct workqueue_struct *_mir_mond_wq;
+
 /*-----------------------------------------------------------------
  * Region hash
  *
@@ -91,7 +95,8 @@
 	RH_CLEAN,
 	RH_DIRTY,
 	RH_NOSYNC,
-	RH_RECOVERING
+	RH_RECOVERING,
+	RH_REMOTE_RECOVERING
 };
 
 struct region {
@@ -120,7 +125,7 @@
 }
 
 /* FIXME move this */
-static void queue_bio(struct mirror_set *ms, struct bio *bio, int rw);
+static int queue_bio(struct mirror_set *ms, struct bio *bio, int rw);
 
 static void *region_alloc(unsigned int __nocast gfp_mask, void *pool_data)
 {
@@ -234,7 +239,7 @@
 
 	read_unlock(&rh->hash_lock);
 	nreg = mempool_alloc(rh->region_pool, GFP_NOIO);
-	nreg->state = rh->log->type->in_sync(rh->log, region, 1) ?
+	nreg->state = (rh->log->type->in_sync(rh->log, region, 1) == LOG_CLEAN) ?
 		RH_CLEAN : RH_NOSYNC;
 	nreg->rh = rh;
 	nreg->key = region;
@@ -252,15 +257,15 @@
 
 	else {
 		__rh_insert(rh, nreg);
-		if (nreg->state == RH_CLEAN) {
-			spin_lock(&rh->region_lock);
-			list_add(&nreg->list, &rh->clean_regions);
-			spin_unlock(&rh->region_lock);
-		}
 		reg = nreg;
 	}
 	write_unlock_irq(&rh->hash_lock);
 	read_lock(&rh->hash_lock);
+	if (reg->state == RH_CLEAN) {
+		spin_lock(&rh->region_lock);
+		list_add(&reg->list, &rh->clean_regions);
+		spin_unlock(&rh->region_lock);
+	}
 
 	return reg;
 }
@@ -278,33 +283,47 @@
 
 static int rh_state(struct region_hash *rh, region_t region, int may_block)
 {
-	int r;
+	int r = 0;
 	struct region *reg;
 
 	read_lock(&rh->hash_lock);
 	reg = __rh_lookup(rh, region);
+	if (reg)
+		r = reg->state;
 	read_unlock(&rh->hash_lock);
 
-	if (reg)
-		return reg->state;
+	if (r)
+		return r;
 
 	/*
-	 * The region wasn't in the hash, so we fall back to the
-	 * dirty log.
+	 * The region wasn't in the hash, so we fall back to the dirty log.
 	 */
-	r = rh->log->type->in_sync(rh->log, region, may_block);
+	switch(rh->log->type->in_sync(rh->log, region, may_block)){
+	case LOG_CLEAN:
+		r = RH_CLEAN;
+		break;
+	case LOG_DIRTY:
+		r = RH_DIRTY;
+		break;
+	case LOG_REMOTE_RECOVERING:
+		r = RH_REMOTE_RECOVERING;
+		break;
+	default:
+		r = RH_NOSYNC;
+		break;
+	}
 
 	/*
 	 * Any error from the dirty log (eg. -EWOULDBLOCK) gets
 	 * taken as a RH_NOSYNC
 	 */
-	return r == 1 ? RH_CLEAN : RH_NOSYNC;
+	return r;
 }
 
-static inline int rh_in_sync(struct region_hash *rh,
-			     region_t region, int may_block)
+static inline int rh_in_sync(struct region_hash *rh, region_t region)
 {
-	int state = rh_state(rh, region, may_block);
+	int state = rh_state(rh, region, 0);
+
 	return state == RH_CLEAN || state == RH_DIRTY;
 }
 
@@ -312,9 +331,8 @@
 {
 	struct bio *bio;
 
-	while ((bio = bio_list_pop(bio_list))) {
+	while ((bio = bio_list_pop(bio_list)))
 		queue_bio(ms, bio, WRITE);
-	}
 }
 
 static void rh_update_states(struct region_hash *rh)
@@ -333,7 +351,7 @@
 		list_splice(&rh->clean_regions, &clean);
 		INIT_LIST_HEAD(&rh->clean_regions);
 
-		list_for_each_entry (reg, &clean, list) {
+		list_for_each_entry(reg, &clean, list) {
 			rh->log->type->clear_region(rh->log, reg->key);
 			list_del(&reg->hash_list);
 		}
@@ -343,9 +361,10 @@
 		list_splice(&rh->recovered_regions, &recovered);
 		INIT_LIST_HEAD(&rh->recovered_regions);
 
-		list_for_each_entry (reg, &recovered, list)
+		list_for_each_entry(reg, &recovered, list)
 			list_del(&reg->hash_list);
 	}
+
 	spin_unlock(&rh->region_lock);
 	write_unlock_irq(&rh->hash_lock);
 
@@ -365,7 +384,7 @@
 	if (!list_empty(&recovered))
 		rh->log->type->flush(rh->log);
 
-	list_for_each_entry_safe (reg, next, &clean, list)
+	list_for_each_entry_safe(reg, next, &clean, list)
 		mempool_free(reg, rh->region_pool);
 }
 
@@ -375,16 +394,24 @@
 
 	read_lock(&rh->hash_lock);
 	reg = __rh_find(rh, region);
+
+	/*
+	 * We lock around this to prevent a race with rh_dec.
+	 * We unlock because the mark can block - holding things up
+	 */
+	spin_lock_irq(&rh->region_lock);
+	atomic_inc(&reg->pending);
+	spin_unlock_irq(&rh->region_lock);
+
 	if (reg->state == RH_CLEAN) {
 		rh->log->type->mark_region(rh->log, reg->key);
 
 		spin_lock_irq(&rh->region_lock);
 		reg->state = RH_DIRTY;
-		list_del_init(&reg->list);	/* take off the clean list */
+		list_del_init(&reg->list);	/* Take off the clean list. */
 		spin_unlock_irq(&rh->region_lock);
 	}
 
-	atomic_inc(&reg->pending);
 	read_unlock(&rh->hash_lock);
 }
 
@@ -406,17 +433,17 @@
 	reg = __rh_lookup(rh, region);
 	read_unlock(&rh->hash_lock);
 
+	spin_lock_irqsave(&rh->region_lock, flags);
 	if (atomic_dec_and_test(&reg->pending)) {
-		spin_lock_irqsave(&rh->region_lock, flags);
 		if (reg->state == RH_RECOVERING) {
 			list_add_tail(&reg->list, &rh->quiesced_regions);
 		} else {
 			reg->state = RH_CLEAN;
 			list_add(&reg->list, &rh->clean_regions);
 		}
-		spin_unlock_irqrestore(&rh->region_lock, flags);
 		should_wake = 1;
 	}
+	spin_unlock_irqrestore(&rh->region_lock, flags);
 
 	if (should_wake)
 		wake();
@@ -452,7 +479,6 @@
 	/* Already quiesced ? */
 	if (atomic_read(&reg->pending))
 		list_del_init(&reg->list);
-
 	else {
 		list_del_init(&reg->list);
 		list_add(&reg->list, &rh->quiesced_regions);
@@ -482,7 +508,7 @@
 	if (!list_empty(&rh->quiesced_regions)) {
 		reg = list_entry(rh->quiesced_regions.next,
 				 struct region, list);
-		list_del_init(&reg->list);	/* remove from the quiesced list */
+		list_del_init(&reg->list); /* Remove from the quiesced list. */
 	}
 	spin_unlock_irq(&rh->region_lock);
 
@@ -538,8 +564,10 @@
 /*-----------------------------------------------------------------
  * Mirror set structures.
  *---------------------------------------------------------------*/
+
 struct mirror {
-	atomic_t error_count;
+	atomic_t error_count; /* Error counter to flag mirror failure. */
+	struct mirror_set *ms;
 	struct dm_dev *dev;
 	sector_t offset;
 };
@@ -550,36 +578,59 @@
 	struct region_hash rh;
 	struct kcopyd_client *kcopyd_client;
 
-	spinlock_t lock;	/* protects the next two lists */
+	spinlock_t lock;	/* protects the lists */
 	struct bio_list reads;
 	struct bio_list writes;
+	struct bio_list failures;
+	struct work_struct failure_work;
+	struct completion failure_completion;
 
 	/* recovery */
+	atomic_t suspended;
 	region_t nr_regions;
 	int in_sync;
 
-	unsigned int nr_mirrors;
+	spinlock_t choose_lock;	/* protects select in choose_mirror(). */
+	atomic_t read_count;	/* Read counter for read balancing. */
+	unsigned int nr_mirrors;	/* # of mirrors in this set. */
+	unsigned int read_mirror;	/* Last mirror read. */
+	struct mirror *default_mirror;	/* Default mirror. */
 	struct mirror mirror[0];
 };
 
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
+ * bi_next for read+write buffers.  This is safe since the bh
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
@@ -602,12 +653,12 @@
 {
 	int r;
 	unsigned int i;
-	struct io_region from, to[KCOPYD_MAX_REGIONS], *dest;
+	struct io_region from, to[ms->nr_mirrors - 1], *dest;
 	struct mirror *m;
 	unsigned long flags = 0;
 
-	/* fill in the source */
-	m = ms->mirror + DEFAULT_MIRROR;
+	/* Fill in the source. */
+	m = ms->default_mirror;
 	from.bdev = m->dev->bdev;
 	from.sector = m->offset + region_to_sector(reg->rh, reg->key);
 	if (reg->key == (ms->nr_regions - 1)) {
@@ -623,7 +674,7 @@
 
 	/* fill in the destinations */
 	for (i = 0, dest = to; i < ms->nr_mirrors; i++) {
-		if (i == DEFAULT_MIRROR)
+		if (&ms->mirror[i] == ms->default_mirror)
 			continue;
 
 		m = ms->mirror + i;
@@ -666,49 +717,208 @@
 	 */
 	if (!ms->in_sync &&
 	    (log->type->get_sync_count(log) == ms->nr_regions)) {
-		/* the sync is complete */
+		/* The sync is complete. */
 		dm_table_event(ms->ti->table);
 		ms->in_sync = 1;
 	}
 }
 
+/*
+ * Remap a buffer to a particular mirror.
+ */
+static sector_t map_sector(struct mirror *m, struct bio *bio)
+{
+	return m->offset + (bio->bi_sector - m->ms->ti->begin);
+}
+
+static void map_bio(struct mirror *m, struct bio *bio)
+{
+	bio->bi_bdev = m->dev->bdev;
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
 /*-----------------------------------------------------------------
  * Reads
  *---------------------------------------------------------------*/
-static struct mirror *choose_mirror(struct mirror_set *ms, sector_t sector)
+/* FIXME: do something smarter for read balancing. */
+
+/*
+ * Select a mirror to queue the read to (read balancing).
+ *
+ * The selection process must be locked, because the daemon
+ * and the mapping function can access it concurrently.
+ */
+#define	MIN_READS	128
+static struct mirror *choose_mirror(struct mirror_set *ms, struct mirror *m)
 {
-	/* FIXME: add read balancing */
-	return ms->mirror + DEFAULT_MIRROR;
+	int i, retry;
+	unsigned long flags;
+	struct mirror *ret = NULL;
+
+	spin_lock_irqsave(&ms->choose_lock, flags);
+
+	if (unlikely(m == ms->default_mirror)) {
+		i = DEFAULT_MIRROR;
+		atomic_set(&ms->read_count, MIN_READS);
+	} else {
+		i = ms->read_mirror;
+	}
+
+	for (retry = 0; retry < ms->nr_mirrors; ) {
+		i %= ms->nr_mirrors;
+		ret = ms->mirror + i;
+
+		if (unlikely(atomic_read(&ret->error_count))) {
+			retry++;
+			i++;
+		} else {
+			/*
+			 * Guarantee that a number of read IOs
+			 * get queued to the same mirror.
+			 */
+			if (atomic_dec_and_test(&ms->read_count)) {
+				atomic_set(&ms->read_count, MIN_READS);
+				i++;
+			}
+
+			ms->read_mirror = i;
+			break;
+		}
+	}
+
+	if(unlikely(m == ms->default_mirror)){
+		ms->default_mirror = ret;
+	}
+
+	spin_unlock_irqrestore(&ms->choose_lock, flags);
+
+	if (unlikely(atomic_read(&ret->error_count))){
+		DMERR("All mirror devices are dead. Unable to choose_mirror.");
+		return NULL;
+	}
+
+	return ret;
 }
 
 /*
- * remap a buffer to a particular mirror.
+ * Fail a mirror and optionally select another one as the default.
  */
-static void map_bio(struct mirror_set *ms, struct mirror *m, struct bio *bio)
+static void fail_mirror(struct mirror *m)
 {
-	bio->bi_bdev = m->dev->bdev;
-	bio->bi_sector = m->offset + (bio->bi_sector - ms->ti->begin);
+	DMINFO("incrementing error_count on %s", m->dev->name);
+	atomic_inc(&m->error_count);
+
+	choose_mirror(m->ms, m);
+}
+
+static int default_mirror(struct mirror *m)
+{
+	return !atomic_read(&m->ms->default_mirror->error_count);
+}
+
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
+		if (likely(default_mirror(m))) {
+			DMWARN("Trying different device.");
+			queue_bio(m->ms, bio, bio_rw(bio));
+		} else {
+			DMERR("No other device available, failing I/O.");
+			bio_endio(bio, 0, -EIO);
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
 }
 
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
-			m = choose_mirror(ms, bio->bi_sector);
-		else
-			m = ms->mirror + DEFAULT_MIRROR;
+		if (likely(rh_in_sync(&ms->rh, bio_to_region(&ms->rh, bio))))
+			m = choose_mirror(ms, NULL);
+		else {
+			m = ms->default_mirror;
+
+			/* If the default fails, we give up .*/
+			if (unlikely(m && atomic_read(&m->error_count)))
+				m = NULL;
+		}
 
-		map_bio(ms, m, bio);
-		generic_make_request(bio);
+		if (likely(m)){
+			read_async_bio(m, bio);
+		}else{
+			bio_endio(bio, 0, -EIO);
+		}
+	}
+}
+
+static void write_failure_handler(void *data)
+{
+	int i = 0;
+	struct bio *bio;
+	struct bio_list failed_writes;
+	struct mirror_set *ms = (struct mirror_set *)data;
+	struct dirty_log *log = ms->rh.log;
+
+
+	dm_table_event(ms->ti->table);
+
+	if(log->type->multi_node){
+		DMERR("Event signaled.  Waiting to start failure handling.");
+		wait_for_completion(&ms->failure_completion);
+		DMINFO("Wait complete");
+	}
+
+	/*
+	 * Device must be suspended to prevent corruption in
+	 * cluster context.
+	 */
+
+	/* Take list out to handle endios. */
+	spin_lock(&ms->lock);
+	failed_writes = ms->failures;
+	bio_list_init(&ms->failures);
+	spin_unlock(&ms->lock);
+
+	while ((bio = bio_list_pop(&failed_writes))) {
+		DMINFO("Completing I/O :  %d", i++);
+		bio_endio(bio, bio->bi_size, 0);
+	}
+	if(log->type->multi_node){
+		DMERR("Failure handling complete.");
 	}
 }
 
@@ -724,13 +934,12 @@
  *---------------------------------------------------------------*/
 static void write_callback(unsigned long error, void *context)
 {
-	unsigned int i;
-	int uptodate = 1;
+	unsigned int i, ret = 0;
 	struct bio *bio = (struct bio *) context;
 	struct mirror_set *ms;
 
-	ms = bio_get_ms(bio);
-	bio_set_ms(bio, NULL);
+	ms = (bio_get_m(bio))->ms;
+	bio_set_m(bio, NULL);
 
 	/*
 	 * NOTE: We don't decrement the pending count here,
@@ -738,48 +947,98 @@
 	 * This way we handle both writes to SYNC and NOSYNC
 	 * regions with the same code.
 	 */
+	if (unlikely(error)) {
+		int uptodate = 0, run;
+
+		DMERR("Error during write occurred.");
 
-	if (error) {
 		/*
-		 * only error the io if all mirrors failed.
-		 * FIXME: bogus
+		 * Test all bits - if all failed, fail io.
+		 * Otherwise, go through hassle of failing a device...
 		 */
-		uptodate = 0;
-		for (i = 0; i < ms->nr_mirrors; i++)
-			if (!test_bit(i, &error)) {
+		for (i = 0; i < ms->nr_mirrors; i++){
+			if (test_bit(i, &error))
+				fail_mirror(ms->mirror + i);
+			else
 				uptodate = 1;
-				break;
+		
+		}
+
+		if (likely(uptodate)) {
+			spin_lock(&ms->lock);
+			if (atomic_read(&ms->suspended)) {
+				/*
+				 * The device is suspended, it is
+				 * safe to complete I/O.
+				 */
+				spin_unlock(&ms->lock);
+			} else {
+				/*
+				 * Failed writes on the list ->
+				 *	process is scheduled.
+				 *
+				 * None on the list ->
+				 *	process must block for the
+				 *	suspend, then complete the I/O.
+				 */
+				run = !ms->failures.head;
+				bio_list_add(&ms->failures, bio);
+				spin_unlock(&ms->lock);
+				
+				if (run){
+					queue_work(_mir_mond_wq,
+						   &ms->failure_work);
+				}
+
+				/*
+				 * DO NOT SIGNAL COMPLETION, work thread will call 
+				 * bio_endio()
+				 */
+				return;
 			}
+		} else {
+			DMERR("All replicated volumes dead, failing I/O");
+			/* None of the writes succeeded, fail the I/O. */
+			ret = -EIO;
+		}
 	}
-	bio_endio(bio, bio->bi_size, 0);
+
+	bio_endio(bio, bio->bi_size, ret);
 }
 
 static void do_write(struct mirror_set *ms, struct bio *bio)
 {
 	unsigned int i;
-	struct io_region io[KCOPYD_MAX_REGIONS+1];
+	struct io_region io[ms->nr_mirrors], *dest = io;
 	struct mirror *m;
+	struct dirty_log *log = ms->rh.log;
 
-	for (i = 0; i < ms->nr_mirrors; i++) {
-		m = ms->mirror + i;
-
-		io[i].bdev = m->dev->bdev;
-		io[i].sector = m->offset + (bio->bi_sector - ms->ti->begin);
-		io[i].count = bio->bi_size >> 9;
+	for (i = 0, m = ms->mirror; i < ms->nr_mirrors; i++, m++) {
+		if (likely(!atomic_read(&m->error_count) || log->type->multi_node))
+			map_region(dest++, m, bio);
 	}
 
-	bio_set_ms(bio, ms);
-	dm_io_async_bvec(ms->nr_mirrors, io, WRITE,
-			 bio->bi_io_vec + bio->bi_idx,
-			 write_callback, bio);
+	if (likely(dest - io)) {
+		/*
+		 * We can use the default mirror here, because we
+		 * only need it in order to retrieve the reference
+		 * to the mirror set in write_callback().
+		 */
+		bio_set_m(bio, ms->default_mirror);
+		dm_io_async_bvec(dest - io, io, WRITE,
+				 bio->bi_io_vec + bio->bi_idx,
+				 write_callback, bio);
+	} else
+		bio_endio(bio, bio->bi_size, -EIO);
 }
 
 static void do_writes(struct mirror_set *ms, struct bio_list *writes)
 {
-	int state;
 	struct bio *bio;
 	struct bio_list sync, nosync, recover, *this_list = NULL;
+	struct bio_list tmp;
 
+	/* Nothing to do... */
 	if (!writes->head)
 		return;
 
@@ -789,10 +1048,10 @@
 	bio_list_init(&sync);
 	bio_list_init(&nosync);
 	bio_list_init(&recover);
+	bio_list_init(&tmp);
 
 	while ((bio = bio_list_pop(writes))) {
-		state = rh_state(&ms->rh, bio_to_region(&ms->rh, bio), 1);
-		switch (state) {
+		switch (rh_state(&ms->rh, bio_to_region(&ms->rh, bio), 1)) {
 		case RH_CLEAN:
 		case RH_DIRTY:
 			this_list = &sync;
@@ -805,15 +1064,20 @@
 		case RH_RECOVERING:
 			this_list = &recover;
 			break;
+
+		case RH_REMOTE_RECOVERING:
+			this_list = &tmp;
+			break;
 		}
 
 		bio_list_add(this_list, bio);
 	}
+	bio_list_merge(writes, &tmp);
 
 	/*
 	 * Increment the pending counts for any regions that will
 	 * be written to (writes to recover regions are going to
-	 * be delayed).
+	 * be delayed) and flush the dirty log.
 	 */
 	rh_inc_pending(&ms->rh, &sync);
 	rh_inc_pending(&ms->rh, &nosync);
@@ -825,13 +1089,13 @@
 	while ((bio = bio_list_pop(&sync)))
 		do_write(ms, bio);
 
-	while ((bio = bio_list_pop(&recover)))
-		rh_delay(&ms->rh, bio);
-
 	while ((bio = bio_list_pop(&nosync))) {
-		map_bio(ms, ms->mirror + DEFAULT_MIRROR, bio);
+		map_bio(ms->default_mirror, bio);
 		generic_make_request(bio);
 	}
+
+	while ((bio = bio_list_pop(&recover)))
+		rh_delay(&ms->rh, bio);
 }
 
 /*-----------------------------------------------------------------
@@ -861,8 +1125,9 @@
 {
 	struct mirror_set *ms;
 
+	/* FIXME: adding/deleting sets can take forever in busy situations. */
 	down_read(&_mirror_sets_lock);
-	list_for_each_entry (ms, &_mirror_sets, list)
+	list_for_each_entry(ms, &_mirror_sets, list)
 		do_mirror(ms);
 	up_read(&_mirror_sets_lock);
 }
@@ -891,17 +1156,27 @@
 
 	memset(ms, 0, len);
 	spin_lock_init(&ms->lock);
+	spin_lock_init(&ms->choose_lock);
 
 	ms->ti = ti;
 	ms->nr_mirrors = nr_mirrors;
 	ms->nr_regions = dm_sector_div_up(ti->len, region_size);
 	ms->in_sync = 0;
+	ms->default_mirror = &ms->mirror[DEFAULT_MIRROR];
+	
+	atomic_set(&ms->suspended, 0);
 
 	if (rh_init(&ms->rh, ms, dl, region_size, ms->nr_regions)) {
 		ti->error = "dm-mirror: Error creating dirty region hash";
 		kfree(ms);
 		return NULL;
 	}
+	
+	atomic_set(&ms->read_count, MIN_READS);
+
+	bio_list_init(&ms->failures);
+	INIT_WORK(&ms->failure_work, write_failure_handler, ms);
+	init_completion(&ms->failure_completion);
 
 	return ms;
 }
@@ -926,6 +1201,7 @@
 		      unsigned int mirror, char **argv)
 {
 	sector_t offset;
+	struct mirror *m = ms->mirror + mirror;
 
 	if (sscanf(argv[1], SECTOR_FORMAT, &offset) != 1) {
 		ti->error = "dm-mirror: Invalid offset";
@@ -933,13 +1209,14 @@
 	}
 
 	if (dm_get_device(ti, argv[0], offset, ti->len,
-			  dm_table_get_mode(ti->table),
-			  &ms->mirror[mirror].dev)) {
+			  dm_table_get_mode(ti->table), &m->dev)) {
 		ti->error = "dm-mirror: Device lookup failure";
 		return -ENXIO;
 	}
 
-	ms->mirror[mirror].offset = offset;
+	atomic_set(&m->error_count, 0);
+	m->offset = offset;
+	m->ms = ms;
 
 	return 0;
 }
@@ -1028,7 +1305,7 @@
 	argc -= args_used;
 
 	if (!argc || sscanf(argv[0], "%u", &nr_mirrors) != 1 ||
-	    nr_mirrors < 2 || nr_mirrors > KCOPYD_MAX_REGIONS + 1) {
+	    nr_mirrors < 2 || nr_mirrors > KCOPYD_MAX_REGIONS) {
 		ti->error = "dm-mirror: Invalid number of mirrors";
 		dm_destroy_dirty_log(dl);
 		return -EINVAL;
@@ -1059,7 +1336,7 @@
 		argc -= 2;
 	}
 
-	ti->private = ms;
+	ti->private = ms->mirror;
 
 	r = kcopyd_client_create(DM_IO_PAGES, &ms->kcopyd_client);
 	if (r) {
@@ -1067,100 +1344,185 @@
 		return r;
 	}
 
+	ms->read_mirror = 1;
+
 	add_mirror_set(ms);
 	return 0;
 }
 
 static void mirror_dtr(struct dm_target *ti)
 {
-	struct mirror_set *ms = (struct mirror_set *) ti->private;
+	struct mirror_set *ms = ((struct mirror *) ti->private)->ms;
 
 	del_mirror_set(ms);
 	kcopyd_client_destroy(ms->kcopyd_client);
 	free_context(ms, ti, ms->nr_mirrors);
 }
 
-static void queue_bio(struct mirror_set *ms, struct bio *bio, int rw)
+static int queue_bio(struct mirror_set *ms, struct bio *bio, int rw)
 {
-	int should_wake = 0;
-	struct bio_list *bl;
+	int should_wake;
+	struct bio_list *bl = rw == WRITE ? &ms->writes : &ms->reads;
 
-	bl = (rw == WRITE) ? &ms->writes : &ms->reads;
 	spin_lock(&ms->lock);
-	should_wake = !(bl->head);
+	should_wake = !bl->head;
 	bio_list_add(bl, bio);
 	spin_unlock(&ms->lock);
 
 	if (should_wake)
 		wake();
+
+	return 0;
 }
 
 /*
- * Mirror mapping function
+ * Mirror mapping function.
  */
 static int mirror_map(struct dm_target *ti, struct bio *bio,
 		      union map_info *map_context)
 {
 	int r, rw = bio_rw(bio);
-	struct mirror *m;
-	struct mirror_set *ms = ti->private;
-
-	map_context->ll = bio->bi_sector >> ms->rh.region_shift;
-
-	if (rw == WRITE) {
-		queue_bio(ms, bio, rw);
-		return 0;
+	struct mirror *m = (struct mirror *) ti->private;
+	struct mirror_set *ms = m->ms;
+	struct dm_bio_details *bd;
+	struct bio_map_info *bmi;
+
+	/* Queue writes to daemon to duplicate them to all mirrors. */
+	if (rw == WRITE){
+		/* Save region for mirror_end_io() handler. */
+		map_context->ll = bio_to_region(&ms->rh, bio);
+		
+		return queue_bio(ms, bio, rw);
+	}
+
+	/* From here down, it's about READS */
+
+	bmi = mempool_alloc(bio_map_info_pool, GFP_KERNEL);
+
+	if(bmi){
+		/* without this, a read is not retryable */
+		bd = &bmi->bmi_bd;
+		dm_bio_record(bd, bio);
+		map_context->ptr = bmi;
+	} else {
+		/* we could fail now, but we can at least give it a shot.  **
+		** the bd is only used to retry in the event of a failure  **
+		** anyway.  If we fail, we can fail the I/O then.          */
+		map_context->ptr = NULL;
+	}
+
+	/* Ask dirty log non-blocking, if region's in sync. */
+	r = ms->rh.log->type->in_sync(ms->rh.log, bio_to_region(&ms->rh, bio), 0);
+	if (unlikely(r < 0)) {
+		if (likely(r == -EWOULDBLOCK))	/* FIXME: ugly */
+			r = 0;
+		else
+			return r; /* Can't carry on w/o dirty log. */
 	}
 
-	r = ms->rh.log->type->in_sync(ms->rh.log,
-				      bio_to_region(&ms->rh, bio), 0);
-	if (r < 0 && r != -EWOULDBLOCK)
-		return r;
-
-	if (r == -EWOULDBLOCK)	/* FIXME: ugly */
-		r = 0;
-
-	/*
-	 * We don't want to fast track a recovery just for a read
-	 * ahead.  So we just let it silently fail.
-	 * FIXME: get rid of this.
-	 */
-	if (!r && rw == READA)
-		return -EIO;
+	/* Region in sync. */
+	if (likely(r == LOG_CLEAN)) {
+		/*
+		 * Optimize reads by avoiding to hand them to daemon.
+		 *
+		 * In case they fail, queue them for another shot
+		 * in the mirror_end_io() function.
+		 */
+		m = choose_mirror(ms, NULL);
+		if (likely(m)) {
+			bmi->bmi_m = m;
+			map_bio(m, bio);
+			return 1; /* Mapped -> queue request. */
+		} else{
+			mempool_free(bmi, bio_map_info_pool);
+			return -EIO;
+		}
+	} else {
+		/*
+		 * We don't want to fast track a recovery just for
+		 * a read ahead. So we just let it silently fail.
+		 *
+		 * FIXME: get rid of this.
+		 */
+		if (rw == READA)
+			return -EIO;
 
-	if (!r) {
-		/* Pass this io over to the daemon */
+		/* Queue reads to out of sync regions to the daemon. */
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
 
+/*
+ * End io handler.
+ *
+ * Decrements write pending count on regions
+ * and fails mirrors on error.
+ */
 static int mirror_end_io(struct dm_target *ti, struct bio *bio,
 			 int error, union map_info *map_context)
 {
 	int rw = bio_rw(bio);
-	struct mirror_set *ms = (struct mirror_set *) ti->private;
-	region_t region = map_context->ll;
+	struct mirror *m = NULL;
 
 	/*
 	 * We need to dec pending if this was a write.
 	 */
-	if (rw == WRITE)
-		rh_dec(&ms->rh, region);
+	if (rw == WRITE){
+		m = (struct mirror *)ti->private;
+		rh_dec(&m->ms->rh, map_context->ll); /* Region squirreled. */
+		return error;
+	}
 
-	return 0;
+	if (unlikely(error)) {
+		DMERR("A read failure occurred on a mirror device.");
+		if(!map_context->ptr){
+			/*
+			 * There wasn't enough memory to record necessary
+			 * information for a retry.
+			 */
+			DMERR("Out of memory causing inability to retry read.");
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
+		if (rw == READ && default_mirror(m)) {
+			struct dm_bio_details *bd = &(((struct bio_map_info *)map_context->ptr)->bmi_bd);
+
+			DMWARN("Trying different device.");
+			dm_bio_restore(bd, bio);
+			mempool_free(map_context->ptr, bio_map_info_pool);
+			map_context->ptr = NULL;
+			queue_bio(m->ms, bio, rw);
+			return 1; /* We want another shot on the bio. */
+		}
+		DMERR("All replicated volumes dead, failing I/O");
+	}
+	if(map_context->ptr)
+		mempool_free(map_context->ptr, bio_map_info_pool);
+
+	/* ATTENTION -- we want to return the error, right? */
+	return error;
+}
+
+static void mirror_presuspend(struct dm_target *ti)
+{
+	struct mirror_set *ms = ((struct mirror *) ti->private)->ms;
+
+	atomic_set(&ms->suspended, 1);
+	complete(&ms->failure_completion);
 }
 
 static void mirror_postsuspend(struct dm_target *ti)
 {
-	struct mirror_set *ms = (struct mirror_set *) ti->private;
+	struct mirror_set *ms = ((struct mirror *) ti->private)->ms;
 	struct dirty_log *log = ms->rh.log;
 
 	rh_stop_recovery(&ms->rh);
@@ -1171,27 +1533,35 @@
 
 static void mirror_resume(struct dm_target *ti)
 {
-	struct mirror_set *ms = (struct mirror_set *) ti->private;
+	struct mirror_set *ms = ((struct mirror *) ti->private)->ms;
 	struct dirty_log *log = ms->rh.log;
+
 	if (log->type->resume && log->type->resume(log))
 		/* FIXME: need better error handling */
 		DMWARN("log resume failed");
+
 	rh_start_recovery(&ms->rh);
+	atomic_set(&ms->suspended, 0);
 }
 
 static int mirror_status(struct dm_target *ti, status_type_t type,
 			 char *result, unsigned int maxlen)
 {
-	unsigned int m, sz;
-	struct mirror_set *ms = (struct mirror_set *) ti->private;
+	char buffer[32];
+	unsigned int sz;
+	struct mirror *m = (struct mirror *) ti->private;
+	struct mirror_set *ms = m->ms;
 
 	sz = ms->rh.log->type->status(ms->rh.log, type, result, maxlen);
 
 	switch (type) {
 	case STATUSTYPE_INFO:
 		DMEMIT("%d ", ms->nr_mirrors);
-		for (m = 0; m < ms->nr_mirrors; m++)
-			DMEMIT("%s ", ms->mirror[m].dev->name);
+		for (m = ms->mirror;  m < ms->mirror + ms->nr_mirrors; m++) {
+			format_dev_t(buffer, m->dev->bdev->bd_dev);
+			DMEMIT("%s/%s ", buffer,
+				atomic_read(&m->error_count) ? "D" : "A");
+		}
 
 		DMEMIT(SECTOR_FORMAT "/" SECTOR_FORMAT,
 		       ms->rh.log->type->get_sync_count(ms->rh.log),
@@ -1200,14 +1570,16 @@
 
 	case STATUSTYPE_TABLE:
 		DMEMIT("%d ", ms->nr_mirrors);
-		for (m = 0; m < ms->nr_mirrors; m++)
-			DMEMIT("%s " SECTOR_FORMAT " ",
-			       ms->mirror[m].dev->name, ms->mirror[m].offset);
+		for (m = ms->mirror;  m < ms->mirror + ms->nr_mirrors; m++) {
+			format_dev_t(buffer, m->dev->bdev->bd_dev);
+			DMEMIT("%s " SECTOR_FORMAT " ", buffer, m->offset);
+		}
 	}
 
 	return 0;
 }
 
+
 static struct target_type mirror_target = {
 	.name	 = "mirror",
 	.version = {1, 0, 1},
@@ -1216,6 +1588,7 @@
 	.dtr	 = mirror_dtr,
 	.map	 = mirror_map,
 	.end_io	 = mirror_end_io,
+	.presuspend = mirror_presuspend,
 	.postsuspend = mirror_postsuspend,
 	.resume	 = mirror_resume,
 	.status	 = mirror_status,
@@ -1225,6 +1598,11 @@
 {
 	int r;
 
+	bio_map_info_pool = mempool_create(100, bio_map_info_alloc, bio_map_info_free, NULL);
+	if(!bio_map_info_pool){
+		return -ENOMEM;
+	}
+
 	r = dm_dirty_log_init();
 	if (r)
 		return r;
@@ -1233,16 +1611,25 @@
 	if (!_kmirrord_wq) {
 		DMERR("couldn't start kmirrord");
 		dm_dirty_log_exit();
-		return r;
+		return -ENOMEM;
 	}
 	INIT_WORK(&_kmirrord_work, do_work, NULL);
 
+	_mir_mond_wq = create_workqueue("mir_mond");
+	if (!_mir_mond_wq) {
+		DMERR("couldn't start mir_mond");
+		dm_dirty_log_exit();
+		destroy_workqueue(_kmirrord_wq);
+		return -ENOMEM;
+	}
+
 	r = dm_register_target(&mirror_target);
 	if (r < 0) {
 		DMERR("%s: Failed to register mirror target",
 		      mirror_target.name);
 		dm_dirty_log_exit();
 		destroy_workqueue(_kmirrord_wq);
+		destroy_workqueue(_mir_mond_wq);
 	}
 
 	return r;
@@ -1265,5 +1652,15 @@
 module_exit(dm_mirror_exit);
 
 MODULE_DESCRIPTION(DM_NAME " mirror target");
-MODULE_AUTHOR("Joe Thornber");
+MODULE_AUTHOR("Joe Thornber / Jon Brassow / Heinz Mauelshagen");
 MODULE_LICENSE("GPL");
+/*
+ * Overrides for Emacs so that we follow Linus's tabbing style.
+ * Emacs will notice this stuff at the end of the file and automatically
+ * adjust the settings for this buffer only.  This must remain at the end
+ * of the file.
+ * ---------------------------------------------------------------------------
+ * Local variables:
+ * c-file-style: "linux"
+ * End:
+ */
--- linux-2.6.12/drivers/md/dm-log.c-patch	2005-06-21 14:40:48.000000000 -0500
+++ linux-2.6.12/drivers/md/dm-log.c	2005-06-24 14:28:52.649687339 -0500
@@ -15,6 +15,7 @@
 static LIST_HEAD(_log_types);
 static DEFINE_SPINLOCK(_lock);
 
+
 int dm_register_dirty_log_type(struct dirty_log_type *type)
 {
 	spin_lock(&_lock);
@@ -150,6 +151,7 @@
 	/*
 	 * Disk log fields
 	 */
+	int log_dev_failed;
 	struct dm_dev *log_dev;
 	struct log_header header;
 
@@ -276,8 +278,7 @@
 	unsigned long ebits;
 	bits_to_disk(log->clean_bits, log->disk_bits,
 		     log->bitset_uint32_count);
-	return dm_io_sync_vm(1, &log->bits_location, WRITE,
-			     log->disk_bits, &ebits);
+	return dm_io_sync_vm(1, &log->bits_location, WRITE, log->disk_bits, &ebits);
 }
 
 /*----------------------------------------------------------------
@@ -412,6 +413,7 @@
 
 	lc = (struct log_c *) log->context;
 	lc->log_dev = dev;
+	lc->log_dev_failed = 0;
 
 	/* setup the disk header fields */
 	lc->header_location.bdev = lc->log_dev->bdev;
@@ -474,13 +476,19 @@
 
 	/* read the disk header */
 	r = read_header(lc);
-	if (r)
-		return r;
-
-	/* read the bits */
-	r = read_bits(lc);
-	if (r)
-		return r;
+	if (r){
+		DMERR("A read failure has occurred on a mirror log device.");
+		dm_table_event(lc->ti->table);
+		lc->header.nr_regions = 0;
+	} else {
+		/* read the bits */
+		r = read_bits(lc);
+		if (r){
+			DMERR("A read failure has occurred on a mirror log device.");
+			dm_table_event(lc->ti->table);
+			lc->header.nr_regions = 0;
+		}
+	}
 
 	/* set or clear any new bits */
 	if (lc->sync == NOSYNC)
@@ -496,16 +504,24 @@
 	memcpy(lc->sync_bits, lc->clean_bits, size);
 	lc->sync_count = count_bits32(lc->clean_bits, lc->bitset_uint32_count);
 
+	/* set the correct number of regions in the header */
+	lc->header.nr_regions = lc->region_count;
+
 	/* write the bits */
 	r = write_bits(lc);
-	if (r)
+	if (r){
+		DMERR("A write failure has occurred on a mirror log device.");
+		dm_table_event(lc->ti->table);
 		return r;
-
-	/* set the correct number of regions in the header */
-	lc->header.nr_regions = lc->region_count;
+	}
 
 	/* write the new header */
-	return write_header(lc);
+	r = write_header(lc);
+	if(r){
+		DMERR("A write failure has occurred on a mirror log device.");
+		dm_table_event(lc->ti->table);
+	}
+	return r;
 }
 
 static uint32_t core_get_region_size(struct dirty_log *log)
@@ -517,13 +533,13 @@
 static int core_is_clean(struct dirty_log *log, region_t region)
 {
 	struct log_c *lc = (struct log_c *) log->context;
-	return log_test_bit(lc->clean_bits, region);
+	return log_test_bit(lc->clean_bits, region)? LOG_CLEAN: LOG_DIRTY;
 }
 
 static int core_in_sync(struct dirty_log *log, region_t region, int block)
 {
 	struct log_c *lc = (struct log_c *) log->context;
-	return log_test_bit(lc->sync_bits, region);
+	return log_test_bit(lc->sync_bits, region) ? LOG_CLEAN: LOG_NOSYNC;
 }
 
 static int core_flush(struct dirty_log *log)
@@ -541,10 +557,28 @@
 	if (!lc->touched)
 		return 0;
 
+	/*
+	 * Could be dangerous if the write fails.
+	 * If the machine dies while the on-disk log is different from the core,
+	 * and the device is readalbe when the machine comes back, it may be
+	 * possible that not all regions will be recovered.
+	 *
+	 * The event is raised so that dmeventd can suspend the device for a
+	 * moment while it removes the log device.
+	 *
+	 * So, not running dmeventd and having a machine fail after a log has
+	 * failed and having the device available when the machine reboots is
+	 * a bad thing.
+	 */
 	r = write_bits(lc);
 	if (!r)
 		lc->touched = 0;
-
+	else {
+		DMERR("A write failure has occurred on a mirror log device.");
+		DMERR("Log device is now not in-sync with the core.");
+		dm_table_event(lc->ti->table);
+	}
+	
 	return r;
 }
 
@@ -613,11 +647,18 @@
 
 	switch(status) {
 	case STATUSTYPE_INFO:
+		DMEMIT("%s %u %u ",
+		       log->type->name,                  /* type name */
+		       lc->sync == DEFAULTSYNC ? 1 : 2,  /* # of args */
+		       lc->region_size);                 /* region size */
+		DMEMIT_SYNC;
 		break;
 
 	case STATUSTYPE_TABLE:
-		DMEMIT("%s %u %u ", log->type->name,
-		       lc->sync == DEFAULTSYNC ? 1 : 2, lc->region_size);
+		DMEMIT("%s %u %u ",
+		       log->type->name,                  /* type name */
+		       lc->sync == DEFAULTSYNC ? 1 : 2,  /* # of args */
+		       lc->region_size);                 /* region size */
 		DMEMIT_SYNC;
 	}
 
@@ -633,13 +674,23 @@
 
 	switch(status) {
 	case STATUSTYPE_INFO:
+		format_dev_t(buffer, lc->log_dev->bdev->bd_dev);
+		DMEMIT("%s %u %s%s %u ",
+		       log->type->name,                  /* type name */
+		       lc->sync == DEFAULTSYNC ? 2 : 3,  /* # of args */
+		       buffer,                           /* The log device */
+		       (lc->log_dev_failed)? "/D":"/A",  /* log device liveness */
+		       lc->region_size);                 /* Region size */
+		DMEMIT_SYNC;
 		break;
 
 	case STATUSTYPE_TABLE:
 		format_dev_t(buffer, lc->log_dev->bdev->bd_dev);
-		DMEMIT("%s %u %s %u ", log->type->name,
-		       lc->sync == DEFAULTSYNC ? 2 : 3, buffer,
-		       lc->region_size);
+		DMEMIT("%s %u %s %u ",
+		       log->type->name,                  /* type name */
+		       lc->sync == DEFAULTSYNC ? 2 : 3,  /* # of args */
+		       buffer,                           /* The log device */
+		       lc->region_size);                 /* Region size */
 		DMEMIT_SYNC;
 	}
 
@@ -649,6 +700,7 @@
 static struct dirty_log_type _core_type = {
 	.name = "core",
 	.module = THIS_MODULE,
+	.multi_node = 0,
 	.ctr = core_ctr,
 	.dtr = core_dtr,
 	.get_region_size = core_get_region_size,
@@ -666,6 +718,7 @@
 static struct dirty_log_type _disk_type = {
 	.name = "disk",
 	.module = THIS_MODULE,
+	.multi_node = 0,
 	.ctr = disk_ctr,
 	.dtr = disk_dtr,
 	.suspend = disk_flush,
@@ -709,3 +762,13 @@
 EXPORT_SYMBOL(dm_unregister_dirty_log_type);
 EXPORT_SYMBOL(dm_create_dirty_log);
 EXPORT_SYMBOL(dm_destroy_dirty_log);
+/*
+ * Overrides for Emacs so that we follow Linus's tabbing style.
+ * Emacs will notice this stuff at the end of the file and automatically
+ * adjust the settings for this buffer only.  This must remain at the end
+ * of the file.
+ * ---------------------------------------------------------------------------
+ * Local variables:
+ * c-file-style: "linux"
+ * End:
+ */

--Apple-Mail-9--396943727
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--Apple-Mail-9--396943727--
