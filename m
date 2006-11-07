From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [Patch 9 of 14] Device Mapper Mirror
Date: Tue, 07 Nov 2006 10:06:04 -0600
Message-ID: <1162915564.17899.55.camel@hydrogen.msp.redhat.com>
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

This patch gives mirror the ability to handle device failures
during write operations.

The 'write_callback' function is called when a write completes.
If all the writes failed or succeeded, we report failure or
success respectively.  If some of the writes failed, we increment
the error count for the device, select a new primary (if necessary)
and we add the bio to a new list in the mirror set, 'failures'.
(Since we must raise an event and events can block, we must handle
the failures in the main worker thread.)  For every bio in the
'failures' list, we call a new function, '__bio_mark_nosync', where
we mark the region 'not-in-sync' in the log and properly set the
region state as, RH_NOSYNC.

We also add extra information to the mirror status output, so that
it can be determined which device(s) have failed.

We now also check for the correct operation of 'rh_flush'.  That
is, we check the return code of the log flushing function.  If
we fail to flush the log, it means we cannot do our writes.  At
this time, we fail those writes.  A follow-up patch - which is
dependent on the ability to requeue I/O's to core device-mapper -
will requeue the I/O's for retry (or allow the mirror to be
reconfigured.)

In all of this, we must maintain backwards compatibility.  We
used to ignore errors; and that is still useful in some
circumstances - like pvmove.  Therefore, if the
DM_FEATURES_HANDLE_ERRORS flag is not present, we skip handling
of errors.
Index: linux-2.6.18.1/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.18.1.orig/drivers/md/dm-raid1.c	2006-11-06 14:38:17.000000000 -0600
+++ linux-2.6.18.1/drivers/md/dm-raid1.c	2006-11-06 16:59:32.000000000 -0600
@@ -118,7 +118,8 @@ struct region {
 #define DM_FEATURE_HANDLE_ERRORS 0x1
 
 struct mirror {
-	atomic_t error_count;
+	atomic_t error_count;  /* Error counter to flag mirror failure */
+	struct mirror_set *ms;
 	struct dm_dev *dev;
 	sector_t offset;
 };
@@ -129,9 +130,10 @@ struct mirror_set {
 	struct region_hash rh;
 	struct kcopyd_client *kcopyd_client;
 
-	spinlock_t lock;	/* protects the next two lists */
+	spinlock_t lock;	/* protects the lists */
 	struct bio_list reads;
 	struct bio_list writes;
+	struct bio_list failures;
 
 	/* Features */
 	uint64_t feature_flags;
@@ -590,9 +592,9 @@ static void rh_recovery_end(struct regio
 	wake();
 }
 
-static void rh_flush(struct region_hash *rh)
+static int rh_flush(struct region_hash *rh)
 {
-	rh->log->type->flush(rh->log);
+	return rh->log->type->flush(rh->log);
 }
 
 static void rh_delay(struct region_hash *rh, struct bio *bio)
@@ -651,19 +653,38 @@ static void bio_set_ms(struct bio *bio, 
  * are in the no-sync state.  We have to recover these by
  * recopying from the default mirror to all the others.
  *---------------------------------------------------------------*/
+static void fail_mirror(struct mirror *m);
 static void recovery_complete(int read_err, unsigned int write_err,
 			      void *context)
 {
 	struct region *reg = (struct region *) context;
+	struct mirror_set *ms = reg->rh->ms;
+	int m, bit = 0;
 
 	/* FIXME:  don't spray the console */
-	if (read_err)
+	if (read_err) {
 		/* Read error means the failure of default mirror. */
 		DMERR("Unable to read from primary mirror during recovery");
+		fail_mirror(ms->default_mirror);
+	}
 
-	if (write_err)
+	if (write_err) {
 		DMERR("Write error during recovery (error = 0x%x)",
 		      write_err);
+		/*
+		 * Bits correspond to devices (excluding default mirror).
+		 * The default mirror cannot change during recovery.
+		 */
+		for (m = 0; m < ms->nr_mirrors; m++) {
+			if (&ms->mirror[m] == ms->default_mirror)
+				continue;
+
+			/* FIXME: does write_err need to be 'unsigned long'? */
+			if (test_bit(bit, &write_err))
+				fail_mirror(ms->mirror + m);
+			bit++;
+		}
+	}
 
 	rh_recovery_end(reg, !(read_err || write_err));
 }
@@ -751,6 +772,53 @@ static struct mirror *choose_mirror(stru
 	return ms->default_mirror;
 }
 
+/* fail_mirror
+ * @m: mirror device to fail
+ *
+ * If the device is valid, mark it invalid.  Also,
+ * if this is the default mirror device (i.e. the primary
+ * device) and the mirror set is in-sync, choose an
+ * alternate primary device.
+ */
+static void fail_mirror(struct mirror *m)
+{
+	struct mirror_set *ms = m->ms;
+	struct mirror *new;
+
+	/* Are we handling or ignoring device failures */
+	if (!(ms->feature_flags & DM_FEATURE_HANDLE_ERRORS))
+		return;
+
+	atomic_inc(&m->error_count);
+
+	if (atomic_read(&m->error_count) > 1)
+		return;
+
+	if (m != ms->default_mirror)
+		return;
+
+	/* If the default mirror fails, change it. */
+	if (!ms->in_sync) {
+		/*
+		 * Can not switch primary.  Better to issue requests
+		 * to same failing device than to risk returning
+		 * corrupt data.
+		 */
+		DMERR("Primary mirror device has failed while mirror is not in-sync");
+		DMERR("Unable to choose alternative primary device");
+		return;
+	}
+
+	for (new = ms->mirror; new < ms->mirror + ms->nr_mirrors; new++)
+		if (!atomic_read(&new->error_count)) {
+			ms->default_mirror = new;
+			break;
+		}
+
+	if (unlikely(new == ms->mirror + ms->nr_mirrors))
+		DMWARN("All sides of mirror have failed.");
+}
+
 /*
  * remap a buffer to a particular mirror.
  */
@@ -760,6 +828,9 @@ static void map_bio(struct mirror_set *m
 	bio->bi_sector = m->offset + (bio->bi_sector - ms->ti->begin);
 }
 
+/*-----------------------------------------------------------------
+ * Reads
+ *---------------------------------------------------------------*/
 static void do_reads(struct mirror_set *ms, struct bio_list *reads)
 {
 	region_t region;
@@ -792,12 +863,66 @@ static void do_reads(struct mirror_set *
  * RECOVERING:	delay the io until recovery completes
  * NOSYNC:	increment pending, just write to the default mirror
  *---------------------------------------------------------------*/
+
+/* __bio_mark_nosync
+ * @ms
+ * @bio
+ * @done
+ * @error
+ *
+ * The bio was written on some mirror(s) but failed on other mirror(s).
+ * We can successfully endio the bio but should avoid the region being
+ * marked clean by setting the state RH_NOSYNC.
+ *
+ * This function is _not_ interrupt safe!
+ */
+static void __bio_mark_nosync(struct mirror_set *ms,
+			      struct bio *bio, unsigned int done, int error)
+{
+	unsigned long flags;
+	struct region_hash *rh = &ms->rh;
+	struct dirty_log *log = ms->rh.log;
+	struct region *reg;
+	region_t region = bio_to_region(rh, bio);
+	int recovering = 0;
+
+	/* We must inform the log that the sync count has changed. */
+	log->type->set_region_sync(log, region, 0);
+	ms->in_sync = 0;
+
+	read_lock(&rh->hash_lock);
+	reg = __rh_find(rh, region);
+	read_unlock(&rh->hash_lock);
+
+	/* region hash entry should exist because write was in-flight */
+	BUG_ON(!reg);
+	BUG_ON(!list_empty(&reg->list));
+
+	spin_lock_irqsave(&rh->region_lock, flags);
+	/*
+	 * Possible cases:
+	 *   1) RH_DIRTY
+	 *   2) RH_NOSYNC: was dirty, other preceeding writes failed
+	 *   3) RH_RECOVERING: flushing pending writes
+	 * Either case, the region should have not been connected to list.
+	 */
+	recovering = (reg->state == RH_RECOVERING);
+	reg->state = RH_NOSYNC;
+	BUG_ON(!list_empty(&reg->list));
+	spin_unlock_irqrestore(&rh->region_lock, flags);
+
+	bio_endio(bio, done, error);
+	if (recovering)
+		complete_resync_work(reg, 0);
+}
+
 static void write_callback(unsigned long error, void *context)
 {
-	unsigned int i;
-	int uptodate = 1;
+	unsigned int i, ret = 0;
 	struct bio *bio = (struct bio *) context;
 	struct mirror_set *ms;
+	int uptodate = 0;
+	int should_wake = 0;
 
 	ms = bio_get_ms(bio);
 	bio_set_ms(bio, NULL);
@@ -808,28 +933,57 @@ static void write_callback(unsigned long
 	 * This way we handle both writes to SYNC and NOSYNC
 	 * regions with the same code.
 	 */
-
-	if (error) {
-		/*
-		 * only error the io if all mirrors failed.
-		 * FIXME: bogus
-		 */
-		uptodate = 0;
-		for (i = 0; i < ms->nr_mirrors; i++)
-			if (!test_bit(i, &error)) {
+	if (unlikely(error)) {
+		for (i = 0; i < ms->nr_mirrors; i++) {
+			if (test_bit(i, &error))
+				fail_mirror(ms->mirror + i);
+			else
 				uptodate = 1;
-				break;
+		}
+
+		if (likely(uptodate)) {
+			if (ms->feature_flags & DM_FEATURE_HANDLE_ERRORS) {
+				/*
+				 * Need to raise event.  Since raising
+				 * events can block, we need to do it in
+				 * the main thread.
+				 */
+				spin_lock(&ms->lock);
+				if (!ms->failures.head)
+					should_wake = 1;
+				bio_list_add(&ms->failures, bio);
+				spin_unlock(&ms->lock);
+				if (should_wake)
+					wake();
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
 
-static void do_write(struct mirror_set *ms, struct bio *bio)
+static void do_write(struct mirror_set *ms, struct bio *bio, int log_failure)
 {
 	unsigned int i;
 	struct io_region io[KCOPYD_MAX_REGIONS+1];
 	struct mirror *m;
 
+	/*
+	 * FIXME: Requeue I/O to dm-core
+	 * Otherwise, errors result if log device fails.
+	 * We cannot allow writes to continue if log device
+	 * is dead.
+	 */
+	if (log_failure) {
+		bio_endio(bio, bio->bi_size, -EIO);
+		return;
+	}
+
 	for (i = 0; i < ms->nr_mirrors; i++) {
 		m = ms->mirror + i;
 
@@ -846,7 +1000,7 @@ static void do_write(struct mirror_set *
 
 static void do_writes(struct mirror_set *ms, struct bio_list *writes)
 {
-	int state;
+	int state, r;
 	struct bio *bio;
 	struct bio_list sync, nosync, recover, *this_list = NULL;
 
@@ -887,13 +1041,14 @@ static void do_writes(struct mirror_set 
 	 */
 	rh_inc_pending(&ms->rh, &sync);
 	rh_inc_pending(&ms->rh, &nosync);
-	rh_flush(&ms->rh);
+
+	r = rh_flush(&ms->rh);
 
 	/*
 	 * Dispatch io.
 	 */
 	while ((bio = bio_list_pop(&sync)))
-		do_write(ms, bio);
+		do_write(ms, bio, r ? 1 : 0);
 
 	while ((bio = bio_list_pop(&recover)))
 		rh_delay(&ms->rh, bio);
@@ -904,6 +1059,19 @@ static void do_writes(struct mirror_set 
 	}
 }
 
+static void do_failures(struct mirror_set *ms, struct bio_list *failures)
+{
+	struct bio *bio;
+
+	if (!failures->head)
+		return;
+
+	dm_table_event(ms->ti->table);
+
+	while ((bio = bio_list_pop(failures)))
+		__bio_mark_nosync(ms, bio, bio->bi_size, 0);
+}
+
 /*-----------------------------------------------------------------
  * kmirrord
  *---------------------------------------------------------------*/
@@ -912,19 +1080,22 @@ static DECLARE_RWSEM(_mirror_sets_lock);
 
 static void do_mirror(struct mirror_set *ms)
 {
-	struct bio_list reads, writes;
+	struct bio_list reads, writes, failures;
 
-	spin_lock(&ms->lock);
+	spin_lock_irq(&ms->lock);
 	reads = ms->reads;
 	writes = ms->writes;
+	failures = ms->failures;
 	bio_list_init(&ms->reads);
 	bio_list_init(&ms->writes);
-	spin_unlock(&ms->lock);
+	bio_list_init(&ms->failures);
+	spin_unlock_irq(&ms->lock);
 
 	rh_update_states(&ms->rh);
 	do_recovery(ms);
 	do_reads(ms, &reads);
 	do_writes(ms, &writes);
+	do_failures(ms, &failures);
 }
 
 static void do_work(void *ignored)
@@ -974,6 +1145,8 @@ static struct mirror_set *alloc_context(
 		return NULL;
 	}
 
+	bio_list_init(&ms->failures);
+
 	return ms;
 }
 
@@ -1011,6 +1184,8 @@ static int get_mirror(struct mirror_set 
 	}
 
 	ms->mirror[mirror].offset = offset;
+	atomic_set(&(ms->mirror[mirror].error_count), 0);
+	ms->mirror[mirror].ms = ms;
 
 	return 0;
 }
@@ -1228,14 +1403,15 @@ static void mirror_dtr(struct dm_target 
 
 static void queue_bio(struct mirror_set *ms, struct bio *bio, int rw)
 {
+	unsigned long flags;
 	int should_wake = 0;
 	struct bio_list *bl;
 
 	bl = (rw == WRITE) ? &ms->writes : &ms->reads;
-	spin_lock(&ms->lock);
+	spin_lock_irqsave(&ms->lock, flags);
 	should_wake = !(bl->head);
 	bio_list_add(bl, bio);
-	spin_unlock(&ms->lock);
+	spin_unlock_irqrestore(&ms->lock, flags);
 
 	if (should_wake)
 		wake();
@@ -1335,17 +1511,21 @@ static int mirror_status(struct dm_targe
 {
 	unsigned int m, sz = 0;
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
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
 
-		DMEMIT("%llu/%llu",
-			(unsigned long long)ms->rh.log->type->
-				get_sync_count(ms->rh.log),
-			(unsigned long long)ms->nr_regions);
+		DMEMIT("%llu/%llu 1 %s",
+		       ms->rh.log->type->get_sync_count(ms->rh.log),
+		       ms->nr_regions, buffer);
 		break;
 
 	case STATUSTYPE_TABLE:
@@ -1387,7 +1567,7 @@ static int __init dm_mirror_init(void)
 	if (!_kmirrord_wq) {
 		DMERR("couldn't start kmirrord");
 		dm_dirty_log_exit();
-		return r;
+		return -ENOMEM;
 	}
 	INIT_WORK(&_kmirrord_work, do_work, NULL);
 
