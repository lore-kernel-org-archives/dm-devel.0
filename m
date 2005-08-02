From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: mirror patches - device failure detection/race
	fix/deadlock fix
Date: Tue, 2 Aug 2005 11:00:05 -0500
Message-ID: <278411eef6c06676d89c4ab5530cde8e@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v622)
Content-Type: multipart/mixed; boundary=Apple-Mail-6-809801448
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


--Apple-Mail-6-809801448
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed

The first 4 patches (0000[1234].patch) are the device failure detection 
patches.  They've been cleaned up a bit from the last time they were 
posted.

The 'race.patch' fixes a couple race conditions that were a result of 
the __rh_alloc() function releasing and regrabbing a lock when called.

The 'deadlock.patch' switches all spin_lock calls on the region_lock to 
spin_lock_irqsave.  Without this patch you machine will hang.

The patches apply in the order described, and should apply to kernels 
2.6.12 - 2.6.13-rc5.

I've made them all attachments to this e-mail.  If people don't like it 
this way, let me know, and I'll do it lkml style.

  brassow


--Apple-Mail-6-809801448
Content-Transfer-Encoding: 7bit
Content-Type: application/octet-stream; x-unix-mode=0664; name="00001.patch"
Content-Disposition: attachment;
	filename=00001.patch

diff -urN linux-2.6.12-orig/drivers/md/dm-log.c linux-2.6.12-00001/drivers/md/dm-log.c
--- linux-2.6.12-orig/drivers/md/dm-log.c	2005-06-17 14:48:29.000000000 -0500
+++ linux-2.6.12-00001/drivers/md/dm-log.c	2005-07-20 16:16:33.000189771 -0500
@@ -30,7 +30,8 @@
 	spin_lock(&_lock);
 
 	if (type->use_count)
-		DMWARN("Attempt to unregister a log type that is still in use");
+		DMWARN("Unregister failed: log type '%s' still in use",
+		       type->name);
 	else
 		list_del(&type->list);
 
@@ -136,7 +137,7 @@
 	unsigned bitset_uint32_count;
 	uint32_t *clean_bits;
 	uint32_t *sync_bits;
-	uint32_t *recovering_bits;	/* FIXME: this seems excessive */
+	uint32_t *recovering_bits;
 
 	int sync_search;
 
@@ -150,6 +151,9 @@
 	/*
 	 * Disk log fields
 	 */
+	int log_dev_failed;
+	atomic_t suspended;
+	struct completion failure_completion;
 	struct dm_dev *log_dev;
 	struct log_header header;
 
@@ -360,7 +364,7 @@
 
 	lc->recovering_bits = vmalloc(bitset_size);
 	if (!lc->recovering_bits) {
-		DMWARN("couldn't allocate sync bitset");
+		DMWARN("couldn't allocate recovering bitset");
 		vfree(lc->sync_bits);
 		vfree(lc->clean_bits);
 		kfree(lc);
@@ -412,6 +416,8 @@
 
 	lc = (struct log_c *) log->context;
 	lc->log_dev = dev;
+	lc->log_dev_failed = 0;
+	init_completion(&lc->failure_completion);
 
 	/* setup the disk header fields */
 	lc->header_location.bdev = lc->log_dev->bdev;
@@ -465,22 +471,35 @@
 	return count;
 }
 
+static void fail_log_device(struct log_c *lc)
+{
+	lc->log_dev_failed = 1;
+	dm_table_event(lc->ti->table);
+}
+
+static void restore_log_device(struct log_c *lc)
+{
+	lc->log_dev_failed = 0;
+}
+
 static int disk_resume(struct dirty_log *log)
 {
-	int r;
+	int r = 0;
 	unsigned i;
 	struct log_c *lc = (struct log_c *) log->context;
 	size_t size = lc->bitset_uint32_count * sizeof(uint32_t);
 
-	/* read the disk header */
-	r = read_header(lc);
-	if (r)
-		return r;
-
-	/* read the bits */
-	r = read_bits(lc);
-	if (r)
-		return r;
+	/* 
+	 * Read the disk header, but only if we know it is good.
+	 * Assume the worst in the event of failure.
+	 */
+	if (!lc->log_dev_failed &&
+	    ((r = read_header(lc)) || read_bits(lc))) {
+		DMWARN("Read %s failed on mirror log device, %s.",
+		      r ? "header" : "bits", lc->log_dev->name);
+		fail_log_device(lc);
+		lc->header.nr_regions = 0;
+	}
 
 	/* set or clear any new bits */
 	if (lc->sync == NOSYNC)
@@ -496,16 +515,20 @@
 	memcpy(lc->sync_bits, lc->clean_bits, size);
 	lc->sync_count = count_bits32(lc->clean_bits, lc->bitset_uint32_count);
 
-	/* write the bits */
-	r = write_bits(lc);
-	if (r)
-		return r;
-
 	/* set the correct number of regions in the header */
 	lc->header.nr_regions = lc->region_count;
 
-	/* write the new header */
-	return write_header(lc);
+	/* write out the log.  'i' tells us which has failed if any */
+	i = 1;
+	if ((r = write_bits(lc)) || (i = 0) || (r = write_header(lc))) {
+		DMWARN("Write %s failed on mirror log device, %s.",
+		      i ? "bits" : "header", lc->log_dev->name);
+		fail_log_device(lc);
+	} else
+		restore_log_device(lc);
+
+	atomic_set(&lc->suspended, 0);
+	return r;
 }
 
 static uint32_t core_get_region_size(struct dirty_log *log)
@@ -532,6 +555,17 @@
 	return 0;
 }
 
+static int disk_presuspend(struct dirty_log *log)
+{
+	struct log_c *lc = (struct log_c *) log->context;
+
+	atomic_set(&lc->suspended, 1);
+	if (lc->log_dev_failed)
+		complete(&lc->failure_completion);
+
+	return 0;
+}
+
 static int disk_flush(struct dirty_log *log)
 {
 	int r;
@@ -541,9 +575,23 @@
 	if (!lc->touched)
 		return 0;
 
+	/*
+	 * If a failure occurs, we must wait for a suspension.
+	 * We must not proceed in the event of a failure,
+	 * because if the machine reboots with the log
+	 * incorrect, recovery could be compromised
+	 */
 	r = write_bits(lc);
-	if (!r)
+	if (!r) {
 		lc->touched = 0;
+		restore_log_device(lc);
+	} else {
+		DMERR("Write failure on mirror log device, %s.",
+		      lc->log_dev->name);
+		fail_log_device(lc);
+		if (!atomic_read(&lc->suspended))
+			wait_for_completion(&lc->failure_completion);
+	}
 
 	return r;
 }
@@ -613,6 +661,7 @@
 
 	switch(status) {
 	case STATUSTYPE_INFO:
+		DMEMIT("1 core");
 		break;
 
 	case STATUSTYPE_TABLE:
@@ -628,17 +677,18 @@
 		       char *result, unsigned int maxlen)
 {
 	int sz = 0;
-	char buffer[16];
 	struct log_c *lc = log->context;
 
 	switch(status) {
 	case STATUSTYPE_INFO:
+		DMEMIT("3 disk %s %c", lc->log_dev->name,
+		       lc->log_dev_failed ? 'D' : 'A');
 		break;
 
 	case STATUSTYPE_TABLE:
-		format_dev_t(buffer, lc->log_dev->bdev->bd_dev);
 		DMEMIT("%s %u %s %u ", log->type->name,
-		       lc->sync == DEFAULTSYNC ? 2 : 3, buffer,
+		       lc->sync == DEFAULTSYNC ? 2 : 3,
+		       lc->log_dev->name,
 		       lc->region_size);
 		DMEMIT_SYNC;
 	}
@@ -668,7 +718,8 @@
 	.module = THIS_MODULE,
 	.ctr = disk_ctr,
 	.dtr = disk_dtr,
-	.suspend = disk_flush,
+	.presuspend = disk_presuspend,
+	.postsuspend = disk_flush,
 	.resume = disk_resume,
 	.get_region_size = core_get_region_size,
 	.is_clean = core_is_clean,
diff -urN linux-2.6.12-orig/drivers/md/dm-log.h linux-2.6.12-00001/drivers/md/dm-log.h
--- linux-2.6.12-orig/drivers/md/dm-log.h	2005-06-17 14:48:29.000000000 -0500
+++ linux-2.6.12-00001/drivers/md/dm-log.h	2005-07-13 11:00:43.000000000 -0500
@@ -32,7 +32,8 @@
 	 * There are times when we don't want the log to touch
 	 * the disk.
 	 */
-	int (*suspend)(struct dirty_log *log);
+	int (*presuspend)(struct dirty_log *log);
+	int (*postsuspend)(struct dirty_log *log);
 	int (*resume)(struct dirty_log *log);
 
 	/*
diff -urN linux-2.6.12-orig/drivers/md/dm-raid1.c linux-2.6.12-00001/drivers/md/dm-raid1.c
--- linux-2.6.12-orig/drivers/md/dm-raid1.c	2005-06-17 14:48:29.000000000 -0500
+++ linux-2.6.12-00001/drivers/md/dm-raid1.c	2005-07-13 11:00:43.000000000 -0500
@@ -1158,15 +1158,25 @@
 	return 0;
 }
 
+static void mirror_presuspend(struct dm_target *ti)
+{
+	struct mirror_set *ms = (struct mirror_set *) ti->private;
+	struct dirty_log *log = ms->rh.log;
+
+	if (log->type->presuspend && log->type->presuspend(log))
+		/* FIXME: need better error handling */
+		DMWARN("log presuspend failed");
+}  
+
 static void mirror_postsuspend(struct dm_target *ti)
 {
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
 	struct dirty_log *log = ms->rh.log;
 
 	rh_stop_recovery(&ms->rh);
-	if (log->type->suspend && log->type->suspend(log))
+	if (log->type->postsuspend && log->type->postsuspend(log))
 		/* FIXME: need better error handling */
-		DMWARN("log suspend failed");
+		DMWARN("log postsuspend failed");
 }
 
 static void mirror_resume(struct dm_target *ti)

--Apple-Mail-6-809801448
Content-Transfer-Encoding: 7bit
Content-Type: application/octet-stream; x-unix-mode=0664; name="00002.patch"
Content-Disposition: attachment;
	filename=00002.patch

diff -urN linux-2.6.12-00001/drivers/md/dm-raid1.c linux-2.6.12-00002/drivers/md/dm-raid1.c
--- linux-2.6.12-00001/drivers/md/dm-raid1.c	2005-07-13 11:00:43.000000000 -0500
+++ linux-2.6.12-00002/drivers/md/dm-raid1.c	2005-07-20 16:25:50.670999981 -0500
@@ -28,6 +28,8 @@
 	queue_work(_kmirrord_wq, &_kmirrord_work);
 }
 
+static struct workqueue_struct *_kmir_mon_wq;
+
 /*-----------------------------------------------------------------
  * Region hash
  *
@@ -539,7 +541,8 @@
  * Mirror set structures.
  *---------------------------------------------------------------*/
 struct mirror {
-	atomic_t error_count;
+	atomic_t error_count;  /* Error counter to flag mirror failure */
+	struct mirror_set *ms;
 	struct dm_dev *dev;
 	sector_t offset;
 };
@@ -550,16 +553,24 @@
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
 
 	unsigned int nr_mirrors;
-	struct mirror mirror[0];
+	spinlock_t choose_lock; /* protects select in choose_mirror(). */
+	atomic_t read_count;    /* Read counter for read balancing. */
+	unsigned int read_mirror;       /* Last mirror read. */
+	struct mirror *default_mirror;  /* Default mirror. */
+ 	struct mirror mirror[0];
 };
 
 /*
@@ -607,7 +618,7 @@
 	unsigned long flags = 0;
 
 	/* fill in the source */
-	m = ms->mirror + DEFAULT_MIRROR;
+	m = ms->default_mirror;
 	from.bdev = m->dev->bdev;
 	from.sector = m->offset + region_to_sector(reg->rh, reg->key);
 	if (reg->key == (ms->nr_regions - 1)) {
@@ -623,7 +634,7 @@
 
 	/* fill in the destinations */
 	for (i = 0, dest = to; i < ms->nr_mirrors; i++) {
-		if (i == DEFAULT_MIRROR)
+		if (&ms->mirror[i] == ms->default_mirror)
 			continue;
 
 		m = ms->mirror + i;
@@ -673,12 +684,72 @@
 }
 
 /*-----------------------------------------------------------------
- * Reads
+ * Misc Functions
  *---------------------------------------------------------------*/
-static struct mirror *choose_mirror(struct mirror_set *ms, sector_t sector)
+#define MIN_READS       128
+/*
+ * choose_mirror
+ * @ms: the mirror set
+ * @m: mirror that has failed, or NULL if just choosing
+ *
+ * Returns: chosen mirror, or NULL on failure
+ */
+static struct mirror *choose_mirror(struct mirror_set *ms, struct mirror *m)
+{
+	int i, retry;
+	unsigned long flags;
+	struct mirror *ret = NULL;
+
+	spin_lock_irqsave(&ms->choose_lock, flags);
+
+	if (unlikely(m == ms->default_mirror)) {
+		i = DEFAULT_MIRROR;
+		atomic_set(&ms->read_count, MIN_READS);
+	} else
+		i = ms->read_mirror;
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
+	/* Check for failure of default mirror, reset if necessary */
+	if (unlikely(m == ms->default_mirror))
+		ms->default_mirror = ret;
+
+	spin_unlock_irqrestore(&ms->choose_lock, flags);
+
+	if (unlikely(atomic_read(&ret->error_count))) {
+		DMERR("All mirror devices are dead. Unable to choose mirror.");
+		return NULL;
+	}
+
+	return ret;
+}
+
+static void fail_mirror(struct mirror *m)
 {
-	/* FIXME: add read balancing */
-	return ms->mirror + DEFAULT_MIRROR;
+	DMINFO("incrementing error_count on %s", m->dev->name);
+	atomic_inc(&m->error_count);
+
+	choose_mirror(m->ms, m);
 }
 
 /*
@@ -690,6 +761,9 @@
 	bio->bi_sector = m->offset + (bio->bi_sector - ms->ti->begin);
 }
 
+/*-----------------------------------------------------------------
+ * Reads
+ *---------------------------------------------------------------*/
 static void do_reads(struct mirror_set *ms, struct bio_list *reads)
 {
 	region_t region;
@@ -703,9 +777,9 @@
 		 * We can only read balance if the region is in sync.
 		 */
 		if (rh_in_sync(&ms->rh, region, 0))
-			m = choose_mirror(ms, bio->bi_sector);
+			m = choose_mirror(ms, NULL);
 		else
-			m = ms->mirror + DEFAULT_MIRROR;
+			m = ms->default_mirror;
 
 		map_bio(ms, m, bio);
 		generic_make_request(bio);
@@ -722,36 +796,90 @@
  * RECOVERING:	delay the io until recovery completes
  * NOSYNC:	increment pending, just write to the default mirror
  *---------------------------------------------------------------*/
+static void write_failure_handler(void *data)
+{
+	struct bio *bio;
+	struct bio_list failed_writes;
+	struct mirror_set *ms = (struct mirror_set *)data;
+
+	dm_table_event(ms->ti->table);
+	wait_for_completion(&ms->failure_completion);
+
+	/* Take list out to handle endios. */
+	spin_lock_irq(&ms->lock);
+	failed_writes = ms->failures;
+	bio_list_init(&ms->failures);
+	spin_unlock_irq(&ms->lock);
+
+	while ((bio = bio_list_pop(&failed_writes)))
+		bio_endio(bio, bio->bi_size, 0);
+}
+
 static void write_callback(unsigned long error, void *context)
 {
-	unsigned int i;
-	int uptodate = 1;
+	unsigned int i, ret = 0;
 	struct bio *bio = (struct bio *) context;
 	struct mirror_set *ms;
-
+	int uptodate = 0, run;
+ 
 	ms = bio_get_ms(bio);
 	bio_set_ms(bio, NULL);
-
+ 
 	/*
 	 * NOTE: We don't decrement the pending count here,
 	 * instead it is done by the targets endio function.
 	 * This way we handle both writes to SYNC and NOSYNC
 	 * regions with the same code.
 	 */
+	if (unlikely(error)) {
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
+		for (i = 0; i < ms->nr_mirrors; i++) {
+			if (test_bit(i, &error))
+				fail_mirror(ms->mirror + i);
+			else
 				uptodate = 1;
-				break;
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
+				 * Need to raise event.  Since raising
+				 * events can block, we need to do it in
+				 * seperate thread.
+				 *
+				 * run gets set if this will be the first
+				 * bio in the list.
+				 */
+				run = !ms->failures.head;
+				bio_list_add(&ms->failures, bio);
+				spin_unlock(&ms->lock);
+
+				if (run)
+					queue_work(_kmir_mon_wq,
+						   &ms->failure_work);
+
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
@@ -829,7 +957,7 @@
 		rh_delay(&ms->rh, bio);
 
 	while ((bio = bio_list_pop(&nosync))) {
-		map_bio(ms, ms->mirror + DEFAULT_MIRROR, bio);
+		map_bio(ms, ms->default_mirror, bio);
 		generic_make_request(bio);
 	}
 }
@@ -891,11 +1019,16 @@
 
 	memset(ms, 0, len);
 	spin_lock_init(&ms->lock);
+	spin_lock_init(&ms->choose_lock);
 
 	ms->ti = ti;
 	ms->nr_mirrors = nr_mirrors;
 	ms->nr_regions = dm_sector_div_up(ti->len, region_size);
 	ms->in_sync = 0;
+	ms->default_mirror = &ms->mirror[DEFAULT_MIRROR];
+
+	/* a resume must be issued to start the device */
+	atomic_set(&ms->suspended, 1);
 
 	if (rh_init(&ms->rh, ms, dl, region_size, ms->nr_regions)) {
 		ti->error = "dm-mirror: Error creating dirty region hash";
@@ -903,6 +1036,13 @@
 		return NULL;
 	}
 
+	atomic_set(&ms->read_count, MIN_READS);
+
+	bio_list_init(&ms->failures);
+	INIT_WORK(&ms->failure_work, write_failure_handler, ms);
+
+	init_completion(&ms->failure_completion);
+
 	return ms;
 }
 
@@ -940,6 +1080,8 @@
 	}
 
 	ms->mirror[mirror].offset = offset;
+	atomic_set(&(ms->mirror[mirror].error_count), 0);
+	ms->mirror[mirror].ms = ms;
 
 	return 0;
 }
@@ -1134,7 +1276,7 @@
 		return 0;
 	}
 
-	m = choose_mirror(ms, bio->bi_sector);
+	m = choose_mirror(ms, NULL);
 	if (!m)
 		return -EIO;
 
@@ -1162,10 +1304,24 @@
 {
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
 	struct dirty_log *log = ms->rh.log;
+	unsigned long flags;
+	int run;
+
+	/*
+	 * Only run the completion if we are suspending after
+	 * a disk failure.
+	 */
+	spin_lock_irqsave(&ms->lock, flags);
+	run = ms->failures.head ? 1 : 0;
+	spin_unlock_irqrestore(&ms->lock, flags);
+
+	if (run)
+		complete(&ms->failure_completion);
 
 	if (log->type->presuspend && log->type->presuspend(log))
 		/* FIXME: need better error handling */
 		DMWARN("log presuspend failed");
+
 }  
 
 static void mirror_postsuspend(struct dm_target *ti)
@@ -1177,38 +1333,48 @@
 	if (log->type->postsuspend && log->type->postsuspend(log))
 		/* FIXME: need better error handling */
 		DMWARN("log postsuspend failed");
+	atomic_set(&ms->suspended, 1);
 }
 
 static void mirror_resume(struct dm_target *ti)
 {
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
 	struct dirty_log *log = ms->rh.log;
+
 	if (log->type->resume && log->type->resume(log))
 		/* FIXME: need better error handling */
 		DMWARN("log resume failed");
-	rh_start_recovery(&ms->rh);
+
+	if (atomic_dec_and_test(&ms->suspended))
+		rh_start_recovery(&ms->rh);
+	atomic_set(&ms->suspended, 0);
 }
 
 static int mirror_status(struct dm_target *ti, status_type_t type,
 			 char *result, unsigned int maxlen)
 {
-	unsigned int m, sz;
+	unsigned int m, sz = 0;
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
-
-	sz = ms->rh.log->type->status(ms->rh.log, type, result, maxlen);
+	char buffer[ms->nr_mirrors + 1];
 
 	switch (type) {
 	case STATUSTYPE_INFO:
 		DMEMIT("%d ", ms->nr_mirrors);
-		for (m = 0; m < ms->nr_mirrors; m++)
+		for (m = 0; m < ms->nr_mirrors; m++) {
 			DMEMIT("%s ", ms->mirror[m].dev->name);
+			buffer[m] = atomic_read(&(ms->mirror[m].error_count)) ? 
+				'D' : 'A';
+		}
+		buffer[m] = '\0';
 
-		DMEMIT(SECTOR_FORMAT "/" SECTOR_FORMAT,
+		DMEMIT(SECTOR_FORMAT "/" SECTOR_FORMAT " 1 %s ",
 		       ms->rh.log->type->get_sync_count(ms->rh.log),
-		       ms->nr_regions);
+		       ms->nr_regions, buffer);
+		ms->rh.log->type->status(ms->rh.log, type, result+sz, maxlen-sz);
 		break;
 
 	case STATUSTYPE_TABLE:
+		sz = ms->rh.log->type->status(ms->rh.log, type, result, maxlen);
 		DMEMIT("%d ", ms->nr_mirrors);
 		for (m = 0; m < ms->nr_mirrors; m++)
 			DMEMIT("%s " SECTOR_FORMAT " ",
@@ -1226,6 +1392,7 @@
 	.dtr	 = mirror_dtr,
 	.map	 = mirror_map,
 	.end_io	 = mirror_end_io,
+	.presuspend = mirror_presuspend,
 	.postsuspend = mirror_postsuspend,
 	.resume	 = mirror_resume,
 	.status	 = mirror_status,
@@ -1243,16 +1410,25 @@
 	if (!_kmirrord_wq) {
 		DMERR("couldn't start kmirrord");
 		dm_dirty_log_exit();
-		return r;
+		return -ENOMEM;
 	}
 	INIT_WORK(&_kmirrord_work, do_work, NULL);
 
+	_kmir_mon_wq = create_workqueue("kmir_mon");
+	if (!_kmir_mon_wq) {
+		DMERR("couldn't start kmir_mon");
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
+		destroy_workqueue(_kmir_mon_wq);
 	}
 
 	return r;

--Apple-Mail-6-809801448
Content-Transfer-Encoding: 7bit
Content-Type: application/octet-stream; x-unix-mode=0664; name="00003.patch"
Content-Disposition: attachment;
	filename=00003.patch

diff -urN linux-2.6.12-00002/drivers/md/dm-raid1.c linux-2.6.12-00003/drivers/md/dm-raid1.c
--- linux-2.6.12-00002/drivers/md/dm-raid1.c	2005-07-20 16:25:50.670999981 -0500
+++ linux-2.6.12-00003/drivers/md/dm-raid1.c	2005-07-20 16:32:08.092180248 -0500
@@ -6,6 +6,7 @@
 
 #include "dm.h"
 #include "dm-bio-list.h"
+#include "dm-bio-record.h"
 #include "dm-io.h"
 #include "dm-log.h"
 #include "kcopyd.h"
@@ -573,24 +574,39 @@
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
@@ -752,37 +768,95 @@
 	choose_mirror(m->ms, m);
 }
 
+static int default_ok(struct mirror *m)
+{
+	return !atomic_read(&m->ms->default_mirror->error_count);
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
+		if (likely(default_ok(m))) {
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
+				      bio_to_region(&ms->rh, bio),
+				      0) == RH_CLEAN))
 			m = choose_mirror(ms, NULL);
-		else
+		else {
 			m = ms->default_mirror;
 
-		map_bio(ms, m, bio);
-		generic_make_request(bio);
+			/* If the default fails, we give up .*/
+			if (unlikely(m && atomic_read(&m->error_count)))
+				m = NULL;
+		}
+
+		if (likely(m))
+			read_async_bio(m, bio);
+		else
+			bio_endio(bio, 0, -EIO);
 	}
 }
 
@@ -822,8 +896,8 @@
 	struct mirror_set *ms;
 	int uptodate = 0, run;
  
-	ms = bio_get_ms(bio);
-	bio_set_ms(bio, NULL);
+	ms = (bio_get_m(bio))->ms;
+	bio_set_m(bio, NULL);
  
 	/*
 	 * NOTE: We don't decrement the pending count here,
@@ -885,21 +959,24 @@
 static void do_write(struct mirror_set *ms, struct bio *bio)
 {
 	unsigned int i;
-	struct io_region io[KCOPYD_MAX_REGIONS+1];
+	struct io_region io[ms->nr_mirrors], *dest = io;
 	struct mirror *m;
 
-	for (i = 0; i < ms->nr_mirrors; i++) {
-		m = ms->mirror + i;
+	for (i = 0, m = ms->mirror; i < ms->nr_mirrors; i++, m++)
+		map_region(dest++, m, bio);
 
-		io[i].bdev = m->dev->bdev;
-		io[i].sector = m->offset + (bio->bi_sector - ms->ti->begin);
-		io[i].count = bio->bi_size >> 9;
-	}
-
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
@@ -957,7 +1034,7 @@
 		rh_delay(&ms->rh, bio);
 
 	while ((bio = bio_list_pop(&nosync))) {
-		map_bio(ms, ms->default_mirror, bio);
+		map_bio(ms->default_mirror, bio);
 		generic_make_request(bio);
 	}
 }
@@ -1246,42 +1323,64 @@
 	int r, rw = bio_rw(bio);
 	struct mirror *m;
 	struct mirror_set *ms = ti->private;
-
-	map_context->ll = bio->bi_sector >> ms->rh.region_shift;
+	struct dm_bio_details *bd;
+	struct bio_map_info *bmi;
 
 	if (rw == WRITE) {
+		/* Save region for mirror_end_io() handler */
+		map_context->ll = bio_to_region(&ms->rh, bio);
 		queue_bio(ms, bio, rw);
 		return 0;
 	}
 
+	/* It's all about the READs now */
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
+		m = choose_mirror(ms, NULL);
+		if (likely(m)) {
+			bmi = mempool_alloc(bio_map_info_pool, GFP_KERNEL);
+
+			if (likely(bmi)) {
+				/* without this, a read is not retryable */
+				bd = &bmi->bmi_bd;
+				dm_bio_record(bd, bio);
+				map_context->ptr = bmi;
+				bmi->bmi_m = m;
+			} else {
+				/* we could fail now, but we can at least  **
+				** give it a shot.  The bd is only used to **
+				** retry in the event of a failure anyway. **
+				** If we fail, we can fail the I/O then.   */
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
 
-	m = choose_mirror(ms, NULL);
-	if (!m)
-		return -EIO;
-
-	map_bio(ms, m, bio);
-	return 1;
+	return 0;
 }
 
 static int mirror_end_io(struct dm_target *ti, struct bio *bio,
@@ -1289,15 +1388,53 @@
 {
 	int rw = bio_rw(bio);
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
-	region_t region = map_context->ll;
+	struct mirror *m = NULL;
 
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
+	if (unlikely(error)) {
+		struct dm_bio_details *bd = NULL;
+
+		DMERR("A read failure occurred on a mirror device.");
+		if (!map_context->ptr) {
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
+		if (rw == READ && default_ok(m)) {
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
+	if (map_context->ptr)
+		mempool_free(map_context->ptr, bio_map_info_pool);
+
+	return error;
 }
 
 static void mirror_presuspend(struct dm_target *ti)
@@ -1402,6 +1539,11 @@
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

--Apple-Mail-6-809801448
Content-Transfer-Encoding: 7bit
Content-Type: application/octet-stream; x-unix-mode=0664; name="00004.patch"
Content-Disposition: attachment;
	filename=00004.patch

diff -urN linux-2.6.12-00003/drivers/md/dm-log.h linux-2.6.12-00004/drivers/md/dm-log.h
--- linux-2.6.12-00003/drivers/md/dm-log.h	2005-07-20 16:27:00.000000000 -0500
+++ linux-2.6.12-00004/drivers/md/dm-log.h	2005-07-20 16:33:23.000000000 -0500
@@ -49,6 +49,16 @@
 	int (*is_clean)(struct dirty_log *log, region_t region);
 
 	/*
+	 * Returns: 0, 1
+	 *
+	 * This is necessary for cluster mirroring. It provides
+	 * a way to detect recovery on another node, so we
+	 * aren't writing concurrently.  This function is likely
+	 * to block (when a cluster log is used).
+	 */
+	int (*is_remote_recovering)(struct dirty_log *log, region_t region);
+
+	/*
 	 *  Returns: 0, 1, -EWOULDBLOCK, < 0
 	 *
 	 * A predicate function to check the area given by
diff -urN linux-2.6.12-00003/drivers/md/dm-raid1.c linux-2.6.12-00004/drivers/md/dm-raid1.c
--- linux-2.6.12-00003/drivers/md/dm-raid1.c	2005-07-20 16:32:08.000000000 -0500
+++ linux-2.6.12-00004/drivers/md/dm-raid1.c	2005-07-21 10:44:00.576555874 -0500
@@ -984,6 +984,9 @@
 	int state;
 	struct bio *bio;
 	struct bio_list sync, nosync, recover, *this_list = NULL;
+	struct bio_list requeue;
+	struct dirty_log *log = ms->rh.log;
+	region_t region;
 
 	if (!writes->head)
 		return;
@@ -994,9 +997,18 @@
 	bio_list_init(&sync);
 	bio_list_init(&nosync);
 	bio_list_init(&recover);
+	bio_list_init(&requeue);
 
 	while ((bio = bio_list_pop(writes))) {
-		state = rh_state(&ms->rh, bio_to_region(&ms->rh, bio), 1);
+		region = bio_to_region(&ms->rh, bio);
+
+		if (log->type->is_remote_recovering &&
+		    log->type->is_remote_recovering(log, region)) {
+			bio_list_add(&requeue, bio);
+			continue;
+		}
+
+		state = rh_state(&ms->rh, region, 1);
 		switch (state) {
 		case RH_CLEAN:
 		case RH_DIRTY:
@@ -1015,6 +1027,8 @@
 		bio_list_add(this_list, bio);
 	}
 
+	bio_list_merge(writes, &requeue);
+
 	/*
 	 * Increment the pending counts for any regions that will
 	 * be written to (writes to recover regions are going to

--Apple-Mail-6-809801448
Content-Transfer-Encoding: 7bit
Content-Type: application/octet-stream;
	x-unix-mode=0664;
	name="race.patch"
Content-Disposition: attachment;
	filename=race.patch

diff -purN linux-2.6.9-11.34.EL-04/drivers/md/dm-raid1.c linux-2.6.9-11.34.EL-05/drivers/md/dm-raid1.c
--- linux-2.6.9-11.34.EL-04/drivers/md/dm-raid1.c	2005-07-29 13:22:45.000000000 -0500
+++ linux-2.6.9-11.34.EL-05/drivers/md/dm-raid1.c	2005-07-29 15:17:29.725740024 -0500
@@ -231,12 +231,18 @@ static void __rh_insert(struct region_ha
 	list_add(&reg->hash_list, rh->buckets + h);
 }
 
+/* __rh_alloc
+ * @rh
+ * @region
+ *
+ * The region_hash hash_lock _must_ be held write_lock_irq.
+ * Never call this directly - use __rh_find
+ */
 static struct region *__rh_alloc(struct region_hash *rh, region_t region)
 {
-	struct region *reg, *nreg;
+	struct region *nreg;
 
-	read_unlock(&rh->hash_lock);
-	nreg = mempool_alloc(rh->region_pool, GFP_NOIO);
+	nreg = mempool_alloc(rh->region_pool, GFP_ATOMIC);
 	nreg->state = rh->log->type->in_sync(rh->log, region, 1) ?
 		RH_CLEAN : RH_NOSYNC;
 	nreg->rh = rh;
@@ -246,34 +252,33 @@ static struct region *__rh_alloc(struct 
 
 	atomic_set(&nreg->pending, 0);
 	bio_list_init(&nreg->delayed_bios);
-	write_lock_irq(&rh->hash_lock);
-
-	reg = __rh_lookup(rh, region);
-	if (reg)
-		/* we lost the race */
-		mempool_free(nreg, rh->region_pool);
 
-	else {
-		__rh_insert(rh, nreg);
-		if (nreg->state == RH_CLEAN) {
-			spin_lock(&rh->region_lock);
-			list_add(&nreg->list, &rh->clean_regions);
-			spin_unlock(&rh->region_lock);
-		}
-		reg = nreg;
+	__rh_insert(rh, nreg);
+	if (nreg->state == RH_CLEAN) {
+		spin_lock(&rh->region_lock);
+		list_add(&nreg->list, &rh->clean_regions);
+		spin_unlock(&rh->region_lock);
 	}
-	write_unlock_irq(&rh->hash_lock);
-	read_lock(&rh->hash_lock);
 
-	return reg;
+	return nreg;
 }
 
-static inline struct region *__rh_find(struct region_hash *rh, region_t region)
+/* __rh_find
+ * @rh
+ * @region
+ * @rw: either READ or WRITE
+ *
+ * The region_hash hash_lock must be held in one of two states
+ *  read_lock(): perform lookup only
+ *  write_lock_irq(): perform lookup and possible allocation
+ */
+static inline struct region *__rh_find(struct region_hash *rh,
+				       region_t region, int rw)
 {
 	struct region *reg;
 
 	reg = __rh_lookup(rh, region);
-	if (!reg)
+	if (!reg && (rw == WRITE))
 		reg = __rh_alloc(rh, region);
 
 	return reg;
@@ -374,10 +379,21 @@ static void rh_update_states(struct regi
 
 static void rh_inc(struct region_hash *rh, region_t region)
 {
+	int rw = READ;
 	struct region *reg;
 
 	read_lock(&rh->hash_lock);
-	reg = __rh_find(rh, region);
+	reg = __rh_find(rh, region, rw);
+	if (!reg) {
+		read_unlock(&rh->hash_lock);
+		rw = WRITE;
+		write_lock_irq(&rh->hash_lock);
+		reg = __rh_find(rh, region, rw);
+	}
+
+	spin_lock_irq(&rh->region_lock);
+	atomic_inc(&reg->pending);
+	spin_unlock_irq(&rh->region_lock);
 	if (reg->state == RH_CLEAN) {
 		rh->log->type->mark_region(rh->log, reg->key);
 
@@ -387,8 +403,10 @@ static void rh_inc(struct region_hash *r
 		spin_unlock_irq(&rh->region_lock);
 	}
 
-	atomic_inc(&reg->pending);
-	read_unlock(&rh->hash_lock);
+	if (rw == WRITE)
+		write_unlock_irq(&rh->hash_lock);
+	else
+		read_unlock(&rh->hash_lock);
 }
 
 static void rh_inc_pending(struct region_hash *rh, struct bio_list *bios)
@@ -409,17 +427,17 @@ static void rh_dec(struct region_hash *r
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
@@ -446,8 +464,15 @@ static int __rh_recovery_prepare(struct 
 	 * recovering flag.
 	 */
 	read_lock(&rh->hash_lock);
-	reg = __rh_find(rh, region);
-	read_unlock(&rh->hash_lock);
+	reg = __rh_find(rh, region, READ);
+	if (reg)
+		read_unlock(&rh->hash_lock);
+	else {
+		read_unlock(&rh->hash_lock);
+		write_lock_irq(&rh->hash_lock);
+		reg = __rh_find(rh, region, WRITE);
+		write_unlock_irq(&rh->hash_lock);
+	}
 
 	spin_lock_irq(&rh->region_lock);
 	reg->state = RH_RECOVERING;
@@ -511,12 +536,23 @@ static void rh_flush(struct region_hash 
 
 static void rh_delay(struct region_hash *rh, struct bio *bio)
 {
+	int rw = READ;
 	struct region *reg;
 
 	read_lock(&rh->hash_lock);
-	reg = __rh_find(rh, bio_to_region(rh, bio));
+	reg = __rh_find(rh, bio_to_region(rh, bio), rw);
+	if (!reg) {
+		read_unlock(&rh->hash_lock);
+		rw = WRITE;
+		write_lock_irq(&rh->hash_lock);
+		reg = __rh_find(rh, bio_to_region(rh, bio), rw);
+	}
 	bio_list_add(&reg->delayed_bios, bio);
-	read_unlock(&rh->hash_lock);
+
+	if (rw == WRITE)
+		write_unlock(&rh->hash_lock);
+	else
+		read_unlock(&rh->hash_lock);
 }
 
 static void rh_stop_recovery(struct region_hash *rh)

--Apple-Mail-6-809801448
Content-Transfer-Encoding: 7bit
Content-Type: application/octet-stream; x-unix-mode=0664; name="deadlock.patch"
Content-Disposition: attachment;
	filename=deadlock.patch

diff -purN linux-2.6.9-11.34.EL-05/drivers/md/dm-raid1.c linux-2.6.9-11.34.EL-06/drivers/md/dm-raid1.c
--- linux-2.6.9-11.34.EL-05/drivers/md/dm-raid1.c	2005-07-29 17:06:50.000000000 -0500
+++ linux-2.6.9-11.34.EL-06/drivers/md/dm-raid1.c	2005-08-01 17:09:36.588526216 -0500
@@ -240,6 +240,7 @@ static void __rh_insert(struct region_ha
  */
 static struct region *__rh_alloc(struct region_hash *rh, region_t region)
 {
+	unsigned long flags;
 	struct region *nreg;
 
 	nreg = mempool_alloc(rh->region_pool, GFP_ATOMIC);
@@ -255,9 +256,9 @@ static struct region *__rh_alloc(struct 
 
 	__rh_insert(rh, nreg);
 	if (nreg->state == RH_CLEAN) {
-		spin_lock(&rh->region_lock);
+		spin_lock_irqsave(&rh->region_lock, flags);
 		list_add(&nreg->list, &rh->clean_regions);
-		spin_unlock(&rh->region_lock);
+		spin_unlock_irqrestore(&rh->region_lock, flags);
 	}
 
 	return nreg;
@@ -327,6 +328,7 @@ static void dispatch_bios(struct mirror_
 
 static void rh_update_states(struct region_hash *rh)
 {
+	unsigned long flags;
 	struct region *reg, *next;
 
 	LIST_HEAD(clean);
@@ -336,7 +338,7 @@ static void rh_update_states(struct regi
 	 * Quickly grab the lists.
 	 */
 	write_lock_irq(&rh->hash_lock);
-	spin_lock(&rh->region_lock);
+	spin_lock_irqsave(&rh->region_lock, flags);
 	if (!list_empty(&rh->clean_regions)) {
 		list_splice(&rh->clean_regions, &clean);
 		INIT_LIST_HEAD(&rh->clean_regions);
@@ -354,7 +356,7 @@ static void rh_update_states(struct regi
 		list_for_each_entry (reg, &recovered, list)
 			list_del(&reg->hash_list);
 	}
-	spin_unlock(&rh->region_lock);
+	spin_unlock_irqrestore(&rh->region_lock, flags);
 	write_unlock_irq(&rh->hash_lock);
 
 	/*
@@ -379,6 +381,7 @@ static void rh_update_states(struct regi
 
 static void rh_inc(struct region_hash *rh, region_t region)
 {
+	unsigned long flags;
 	int rw = READ;
 	struct region *reg;
 
@@ -391,21 +394,21 @@ static void rh_inc(struct region_hash *r
 		reg = __rh_find(rh, region, rw);
 	}
 
-	spin_lock_irq(&rh->region_lock);
+	spin_lock_irqsave(&rh->region_lock, flags);
 	atomic_inc(&reg->pending);
-	spin_unlock_irq(&rh->region_lock);
+	spin_unlock_irqrestore(&rh->region_lock, flags);
 	if (reg->state == RH_CLEAN) {
 		rh->log->type->mark_region(rh->log, reg->key);
 
-		spin_lock_irq(&rh->region_lock);
+		spin_lock_irqsave(&rh->region_lock, flags);
 		reg->state = RH_DIRTY;
 		list_del_init(&reg->list);	/* take off the clean list */
-		spin_unlock_irq(&rh->region_lock);
+		spin_unlock_irqrestore(&rh->region_lock, flags);
 	}
 
-	if (rw == WRITE)
+	if (rw == WRITE) {
 		write_unlock_irq(&rh->hash_lock);
-	else
+	} else
 		read_unlock(&rh->hash_lock);
 }
 
@@ -449,6 +452,7 @@ static void rh_dec(struct region_hash *r
 static int __rh_recovery_prepare(struct region_hash *rh)
 {
 	int r;
+	unsigned long flags;
 	struct region *reg;
 	region_t region;
 
@@ -474,7 +478,7 @@ static int __rh_recovery_prepare(struct 
 		write_unlock_irq(&rh->hash_lock);
 	}
 
-	spin_lock_irq(&rh->region_lock);
+	spin_lock_irqsave(&rh->region_lock, flags);
 	reg->state = RH_RECOVERING;
 
 	/* Already quiesced ? */
@@ -485,7 +489,7 @@ static int __rh_recovery_prepare(struct 
 		list_del_init(&reg->list);
 		list_add(&reg->list, &rh->quiesced_regions);
 	}
-	spin_unlock_irq(&rh->region_lock);
+	spin_unlock_irqrestore(&rh->region_lock, flags);
 
 	return 1;
 }
@@ -504,15 +508,16 @@ static void rh_recovery_prepare(struct r
  */
 static struct region *rh_recovery_start(struct region_hash *rh)
 {
+	unsigned long flags;
 	struct region *reg = NULL;
 
-	spin_lock_irq(&rh->region_lock);
+	spin_lock_irqsave(&rh->region_lock, flags);
 	if (!list_empty(&rh->quiesced_regions)) {
 		reg = list_entry(rh->quiesced_regions.next,
 				 struct region, list);
 		list_del_init(&reg->list);	/* remove from the quiesced list */
 	}
-	spin_unlock_irq(&rh->region_lock);
+	spin_unlock_irqrestore(&rh->region_lock, flags);
 
 	return reg;
 }
@@ -520,11 +525,12 @@ static struct region *rh_recovery_start(
 /* FIXME: success ignored for now */
 static void rh_recovery_end(struct region *reg, int success)
 {
+	unsigned long flags;
 	struct region_hash *rh = reg->rh;
 
-	spin_lock_irq(&rh->region_lock);
+	spin_lock_irqsave(&rh->region_lock, flags);
 	list_add(&reg->list, &reg->rh->recovered_regions);
-	spin_unlock_irq(&rh->region_lock);
+	spin_unlock_irqrestore(&rh->region_lock, flags);
 
 	wake();
 }
@@ -549,9 +555,9 @@ static void rh_delay(struct region_hash 
 	}
 	bio_list_add(&reg->delayed_bios, bio);
 
-	if (rw == WRITE)
+	if (rw == WRITE) {
 		write_unlock(&rh->hash_lock);
-	else
+	} else
 		read_unlock(&rh->hash_lock);
 }
 

--Apple-Mail-6-809801448
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--Apple-Mail-6-809801448--
