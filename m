From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [2.6.22-rc4-mm2 PATCH 7/11]
	dm-raid1-fix-EIO-after-log-failure.patch
Date: Thu, 21 Jun 2007 13:51:04 -0500
Message-ID: <1182451864.13518.19.camel@hydrogen.msp.redhat.com>
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

slight header change.  Improve nesting in do_failures().

[Might be ok to pull the comment added in complete_resync_work... but
might be nice for future coders.]

 brassow

This patch adds the ability to requeue write I/O to
core device-mapper when there is a log device failure.

If a write to the log produces and error, the pending writes are
put on the "failures" list.  Since the log is marked as failed,
they will stay on the failures list until a suspend happens.

Suspends come in two phases, presuspend and postsuspend.  We must
make sure that all the writes on the failures list are requeued
in the presuspend phase (a requirement of dm core).  This means
that recovery must be complete (because writes may be delayed
behind it) and the failures list must be requeued before we
return from presuspend.

The mechanisms to ensure recovery is complete (or stopped) was
already in place, but needed to be moved from postsuspend to
presuspend.  We rely on 'flush_workqueue' to ensure that the
mirror thread is complete and therefore, has requeued all writes
in the failures list.

Because we are using flush_workqueue, we must ensure that no
additional 'queue_work' calls will produce additional I/O
that we need to requeue (because once we return from
presuspend, we are unable to do anything about it).  'queue_work'
is called in response to the following functions:
- complete_resync_work = NA, recovery is stopped
- rh_dec (mirror_end_io) = NA, only calls 'queue_work' if it
                           is ready to recover the region
                           (recovery is stopped) or it needs
                           to clear the region in the log*
                           **this doesn't get called while
                           suspending**
- rh_recovery_end = NA, recovery is stopped
- rh_recovery_start = NA, recovery is stopped
- write_callback = 1) Writes w/o failures simply call
                   bio_endio -> mirror_end_io -> rh_dec
                   (see rh_dec above)
                   2) Writes with failures are put on
                   the failures list and queue_work is
                   called**
                   ** write_callbacks don't happen
                   during suspend **
- do_failures = NA, 'queue_work' not called if suspending
- add_mirror (initialization) = NA, only done on mirror creation
- queue_bio = NA, 1) delayed I/O scheduled before flush_workqueue
              is called.  2) No more I/Os are being issued.
              3) Re-attempted READs can still be handled.
              (Write completions are handled through rh_dec/
              write_callback - mention above - and do not
              use queue_bio.)

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6.22-rc4-mm2/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/md/dm-raid1.c
+++ linux-2.6.22-rc4-mm2/drivers/md/dm-raid1.c
@@ -137,6 +137,7 @@ struct mirror_set {
 	region_t nr_regions;
 	int in_sync;
 	int log_failure;
+	atomic_t suspend;
 
 	struct mirror *default_mirror;	/* Default mirror */
 
@@ -362,6 +363,16 @@ static void complete_resync_work(struct 
 	struct region_hash *rh = reg->rh;
 
 	rh->log->type->set_region_sync(rh->log, reg->key, success);
+
+	/*
+	 * Dispatch the bios before we call 'wake_up_all'.
+	 * This is important because if we are suspending,
+	 * we want to know that recovery is complete and
+	 * the work queue is flushed.  If we wake_up_all
+	 * before we dispatch_bios (queue bios and call wake()),
+	 * then we risk suspending before the work queue
+	 * has been properly flushed.
+	 */
 	dispatch_bios(rh->ms, &reg->delayed_bios);
 	if (atomic_dec_and_test(&rh->recovery_in_flight))
 		wake_up_all(&_kmirrord_recovery_stopped);
@@ -1039,10 +1050,11 @@ static void do_writes(struct mirror_set 
 	/*
 	 * Dispatch io.
 	 */
-	if (unlikely(ms->log_failure))
-		while ((bio = bio_list_pop(&sync)))
-			bio_endio(bio, bio->bi_size, -EIO);
-	else while ((bio = bio_list_pop(&sync)))
+	if (unlikely(ms->log_failure)) {
+		spin_lock_irq(&ms->lock);
+		bio_list_merge(&ms->failures, &sync);
+		spin_unlock_irq(&ms->lock);
+	} else while ((bio = bio_list_pop(&sync)))
 		do_write(ms, bio);
 
 	while ((bio = bio_list_pop(&recover)))
@@ -1061,10 +1073,44 @@ static void do_failures(struct mirror_se
 	if (!failures->head)
 		return;
 
-	dm_table_event(ms->ti->table);
+	if (!ms->log_failure) {
+		dm_table_event(ms->ti->table);
+
+		while ((bio = bio_list_pop(failures)))
+			__bio_mark_nosync(ms, bio, bio->bi_size, 0);
+		return;
+	}
 
-	while ((bio = bio_list_pop(failures)))
-		__bio_mark_nosync(ms, bio, bio->bi_size, 0);
+	/*
+	 * If the log has failed, unattempted writes are being
+	 * put on the failures list.  We can't issue those writes
+	 * until a log has been marked, so we must store them.
+	 *
+	 * If a 'noflush' suspend is in progress, we can requeue
+	 * the I/O's to the core.  This give userspace a chance
+	 * to reconfigure the mirror, at which point the core
+	 * will reissue the writes.  If the 'noflush' flag is
+	 * not set, we have no choice but to return errors.
+	 *
+	 * Some writes on the failures list may have been
+	 * submitted before the log failure and represent a
+	 * failure to write to one of the devices.  It is ok
+	 * for us to treat them the same and requeue them
+	 * as well.
+	 */
+	if (dm_noflush_suspending(ms->ti)) {
+		while ((bio = bio_list_pop(failures)))
+			bio_endio(bio, bio->bi_size, DM_ENDIO_REQUEUE);
+	} else if (atomic_read(&ms->suspend)) {
+		while ((bio = bio_list_pop(failures)))
+			bio_endio(bio, bio->bi_size, -EIO);
+	} else {
+		spin_lock_irq(&ms->lock);
+		bio_list_merge(&ms->failures, failures);
+		spin_unlock_irq(&ms->lock);
+		wake(ms);
+	}
+	return;
 }
 
 /*-----------------------------------------------------------------
@@ -1121,6 +1167,8 @@ static struct mirror_set *alloc_context(
 	ms->nr_mirrors = nr_mirrors;
 	ms->nr_regions = dm_sector_div_up(ti->len, region_size);
 	ms->in_sync = 0;
+	ms->log_failure = 0;
+	atomic_set(&ms->suspend, 0);
 	ms->default_mirror = &ms->mirror[DEFAULT_MIRROR];
 
 	ms->io_client = dm_io_client_create(DM_IO_PAGES);
@@ -1452,26 +1500,51 @@ static int mirror_end_io(struct dm_targe
 	return 0;
 }
 
-static void mirror_postsuspend(struct dm_target *ti)
+static void mirror_presuspend(struct dm_target *ti)
 {
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
 	struct dirty_log *log = ms->rh.log;
 
+	atomic_set(&ms->suspend, 1);
+
+	/*
+	 * We must finish up all the work that we've
+	 * generated (i.e. recovery work).
+	 */
 	rh_stop_recovery(&ms->rh);
 
-	/* Wait for all I/O we generated to complete */
 	wait_event(_kmirrord_recovery_stopped,
 		   !atomic_read(&ms->rh.recovery_in_flight));
 
+	/*
+	 * Now that recovery is complete/stopped and the
+	 * delayed bios are queued, we need to wait for
+	 * the worker thread to complete.  This way,
+	 * we know that all of our I/O has been pushed.
+	 */
+	flush_workqueue(ms->kmirrord_wq);
+
+	if (log->type->presuspend && log->type->presuspend(log))
+		/* FIXME: need better error handling */
+		DMWARN("log presuspend failed");
+}
+
+static void mirror_postsuspend(struct dm_target *ti)
+{
+	struct mirror_set *ms = (struct mirror_set *) ti->private;
+	struct dirty_log *log = ms->rh.log;
+
 	if (log->type->postsuspend && log->type->postsuspend(log))
 		/* FIXME: need better error handling */
-		DMWARN("log suspend failed");
+		DMWARN("log postsuspend failed");
 }
 
 static void mirror_resume(struct dm_target *ti)
 {
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
 	struct dirty_log *log = ms->rh.log;
+
+	atomic_set(&ms->suspend, 0);
 	if (log->type->resume && log->type->resume(log))
 		/* FIXME: need better error handling */
 		DMWARN("log resume failed");
@@ -1510,7 +1583,7 @@ static int mirror_status(struct dm_targe
 		DMEMIT("%d", ms->nr_mirrors);
 		for (m = 0; m < ms->nr_mirrors; m++)
 			DMEMIT(" %s %llu", ms->mirror[m].dev->name,
-				(unsigned long long)ms->mirror[m].offset);
+			       (unsigned long long)ms->mirror[m].offset);
 
 		if (ms->features & DM_RAID1_HANDLE_ERRORS)
 			DMEMIT(" 1 handle_errors");
@@ -1527,6 +1600,7 @@ static struct target_type mirror_target 
 	.dtr	 = mirror_dtr,
 	.map	 = mirror_map,
 	.end_io	 = mirror_end_io,
+	.presuspend = mirror_presuspend,
 	.postsuspend = mirror_postsuspend,
 	.resume	 = mirror_resume,
 	.status	 = mirror_status,
