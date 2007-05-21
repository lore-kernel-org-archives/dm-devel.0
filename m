From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [2.6.22-rc1-mm1 PATCH 4/10]
	dm-raid1-handle-write-failures.patch
Date: Mon, 21 May 2007 17:03:32 -0500
Message-ID: <1179785012.13913.25.camel@hydrogen.msp.redhat.com>
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
List-Id: dm-devel.ids

 brassow

This patch gives mirror the ability to handle device failures
during normal write operations.

The 'write_callback' function is called when a write completes.
If all the writes failed or succeeded, we report failure or
success respectively.  If some of the writes failed, we call
fail_mirror; which increments the error count for the device,
selects a new primary (if necessary).  We then add the bio to a new
list in the mirror set, 'failures'.
(Since we must raise an event and events can block, we must handle
the failures in the main worker thread.)  For every bio in the
'failures' list, we call a new function, '__bio_mark_nosync', where
we mark the region 'not-in-sync' in the log and properly set the
region state as, RH_NOSYNC.

In all of this, we must maintain backwards compatibility.  We
used to ignore errors; and that is still useful in some
circumstances - like pvmove.  Therefore, if the
DM_FEATURES_HANDLE_ERRORS flag is not present, we skip handling
of errors.

Index: linux-2.6.22-rc1-mm1/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.22-rc1-mm1.orig/drivers/md/dm-raid1.c
+++ linux-2.6.22-rc1-mm1/drivers/md/dm-raid1.c
@@ -125,9 +125,10 @@ struct mirror_set {
 	struct kcopyd_client *kcopyd_client;
 	uint64_t features;
 
-	spinlock_t lock;	/* protects the next two lists */
+	spinlock_t lock;	/* protects the lists */
 	struct bio_list reads;
 	struct bio_list writes;
+	struct bio_list failures;
 
 	struct dm_io_client *io_client;
 
@@ -861,12 +862,66 @@ static void do_reads(struct mirror_set *
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
+ * This function is _not_ safe in interrupt context!
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
@@ -877,20 +932,37 @@ static void write_callback(unsigned long
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
+			if (ms->features & DM_RAID1_HANDLE_ERRORS) {
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
+					wake(ms);
+				return;
 			}
+		} else {
+			DMERR("All replicated volumes dead, failing I/O");
+			/* None of the writes succeeded, fail the I/O. */
+			ret = -EIO;
+		}
 	}
-	bio_endio(bio, bio->bi_size, 0);
+	bio_endio(bio, bio->bi_size, ret);
 }
 
 static void do_write(struct mirror_set *ms, struct bio *bio)
@@ -984,6 +1056,19 @@ static void do_writes(struct mirror_set 
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
@@ -991,19 +1076,22 @@ static void do_mirror(struct work_struct
 {
 	struct mirror_set *ms =container_of(work, struct mirror_set,
 					    kmirrord_work);
-	struct bio_list reads, writes;
+	struct bio_list reads, writes, failures;
 
 	spin_lock(&ms->lock);
 	reads = ms->reads;
 	writes = ms->writes;
+	failures = ms->failures;
 	bio_list_init(&ms->reads);
 	bio_list_init(&ms->writes);
+	bio_list_init(&ms->failures);
 	spin_unlock(&ms->lock);
 
 	rh_update_states(&ms->rh);
 	do_recovery(ms);
 	do_reads(ms, &reads);
 	do_writes(ms, &writes);
+	do_failures(ms, &failures);
 }
 
 /*-----------------------------------------------------------------
@@ -1289,14 +1377,15 @@ static void mirror_dtr(struct dm_target 
 
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
 		wake(ms);
