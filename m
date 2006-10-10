From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 6/7] dm: add the pushback feature to the dm core
Date: Tue, 10 Oct 2006 17:32:01 -0400 (EDT)
Message-ID: <20061010.173201.102581999.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
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

This patch adds the pushback feature which can suspend and table swap
without returning queued I/Os in targets to applications to the dm core.

Detail explanations are below.

======================================================================
Explanations of the patch
=-=-=-=-=-=-=-=-=-=-=-=-=-=

DMF_NOFLUSH_SUSPENDING
----------------------

If 'DM_NOFLUSH_FLAG' ioctl option is specified at suspend time,
'DMF_NOFLUSH_SUSPENDING' flag is set in md->flags at early stage
of dm_suspend() and unset before returning from dm_suspend().

The flag must be visible during the target flushing pending I/Os,
because the pushback feature is enabled only during the flag is set.
So the flag is set before presuspend, where the flush starts,
and unset after the wait for md->pending, where the flush ends.

Target drivers can check this flag by dm_noflush_suspending().


DM_MAPIO_REQUEUE / DM_ENDIO_REQUEUE
-----------------------------------

If DMF_NOFLUSH_SUSPENDING flag is set, target's map() function can
return DM_MAPIO_REQUEUE to request the device mapper core to
put the bio in queue.

Similarly, target's end_io() function can return DM_ENDIO_REQUEUE
to request the same.

These requests are called 'pushback'.
The __map_bio() and clone_endio() in device mapper core treat
these return values as error code and call dec_pending() to end
the I/O.


dec_pending
-----------

The pushback request from target drivers are passed to dec_pending()
as "error" argument.
dec_pending() saves the pushback request in struct dm_io->error.
Once the all splitted clones end, dec_pending() will check it
and put the original bio to md->pushback list.

To avoid the dm_io->error is overwritten by other values,
dec_pending() first checks if the dm_io->error is already set.
So the pushback request supersede any I/O errors.

It is possible that the suspend with DM_NOFLUSH_FLAG is
aborted after the flush started but before it ends
(e.g. by user interrupt).
dec_pending() checks it and returns EIO if it happens.


pushdback list and pushback_lock
--------------------------------

The bio which is requested to push back from target drivers is
queued to md->pushback temporarily in dec_pending(), and after all
pending I/Os return, md->pushback is merged to md->deferred in
dm_suspend() for re-issuing at resume time.

md->pushback_lock protects md->pushback.
The lock should be held with irq disabled because dec_pending()
can be called from interrupt context.

Queueing bios to md->pushback in dec_pending() must be done
atomically with the check for 'DMF_NOFLUSH_SUSPENDING' flag.
So md->pushback_lock is held when checking the flag.
Otherwise, dec_pending() may queue a bio to md->pushback after
the interrupted dm_suspend() flushes md->pushback.
Then the bio will be left in md->pushback.

Flag setting in dm_suspend() can be done without md->pushback_lock,
because the flag is checked only after presuspend and the set value
is already made visible by the multipath presuspend.

The flag can be checked without md->pushback_lock (e.g. the first
part of the dec_pending() or target drivers), because the flag is
checked again with md->pushback_lock held when the bio is really
queued to md->pushback as described above.
So even if the flag is cleared after the lock-less checkings, the bio
isn't left in md->pushback. (It is returned to applications with EIO.)


Other notes in the current patch
--------------------------------

- md->pushback is added to the struct mapped_device instead of using
  md->deferred directly.
  Because md->io_lock which protects md->deferred is rw_semaphore
  and can't be used in interrupt context like dec_pending(), and
  md->io_lock protects 'DMF_BLOCK_IO' flag of md->flags too.

- Don't issue lock_fs() in dm_suspend() if the 'DM_NOFLUSH_FLAG'
  ioctl option is specified, because I/Os for lock_fs() are pushed
  back and never return if no valid devices.
  (See dm_suspend())

- If a error occurs in dm_suspend() after 'DMF_NOFLUSH_SUSPENDING'
  flag is set, md->pushback must be flushed because I/Os may be
  queued to the list already.
  (See around 'flush_and_out:' label in dm_suspend())


======================================================================
Test results
=-=-=-=-=-=-=

I have tested by using multipath target with patch 7 (will be posted).
Following tests are for regression/compatibility.
  - I/Os succeed when valid paths are existing.
  - I/Os fail when no valid paths and no queue_if_no_path setting.
  - I/Os are queued in the multipath target when no valid paths and
    queue_if_no_path is set.
  - The queued I/Os above fail when suspend is issued WITHOUT
    'DM_NOFLUSH_FLAG' ioctl option.
  I/Os spanning 2 multipath targets are as well.

Following tests are for normal code path of new pushback feature.
  - Queued I/Os in the multipath target are flushed from the target
    but don't return when suspend is issued WITH 'DM_NOFLUSH_FLAG'
    ioctl option.
  - The I/Os above are queued in the multipath target again when
    resume is issued WITHOUT path recovery.
    The I/Os above succeed when resume is issued after path recovery
    or table load.
  - Queued I/Os in the multipath target succeed when resume is issued
    WITH 'DM_NOFLUSH_FLAG' ioctl option after table load.
  I/Os spanning 2 multipath targets are as well.

Following tests are for error code path of the new pushback feature.
  - When the bdget_disk() fails in dm_suspned(), 'DMF_NOFLUSH_SUSPENDING'
    flag is cleared and already queued I/Os to the pushback list are
    flushed properly.
  - When suspend with 'DM_NOFLUSH_FLAG' ioctl option is interrupted,
      o I/Os which had already been queued to the pushback list
        at the time don't return, and are re-issued at resume time.
      o I/Os which hadn't been returned at the time return with EIO.


======================================================================
Patch
=-=-=-=

The patch is for:
    2.6.18-mm2 + patch 1-5

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

diff -rupN 5-add-noflush-ioctl-opt/drivers/md/dm-bio-list.h 6-core-pushback/drivers/md/dm-bio-list.h
--- 5-add-noflush-ioctl-opt/drivers/md/dm-bio-list.h	2006-09-19 23:42:06.000000000 -0400
+++ 6-core-pushback/drivers/md/dm-bio-list.h	2006-10-05 11:37:39.000000000 -0400
@@ -44,6 +44,20 @@ static inline void bio_list_merge(struct
 	bl->tail = bl2->tail;
 }
 
+static inline void bio_list_merge_head(struct bio_list *bl,
+				       struct bio_list *bl2)
+{
+	if (!bl2->head)
+		return;
+
+	if (bl->head)
+		bl2->tail->bi_next = bl->head;
+	else
+		bl->tail = bl2->tail;
+
+	bl->head = bl2->head;
+}
+
 static inline struct bio *bio_list_pop(struct bio_list *bl)
 {
 	struct bio *bio = bl->head;
diff -rupN 5-add-noflush-ioctl-opt/drivers/md/dm.c 6-core-pushback/drivers/md/dm.c
--- 5-add-noflush-ioctl-opt/drivers/md/dm.c	2006-10-05 13:48:46.000000000 -0400
+++ 6-core-pushback/drivers/md/dm.c	2006-10-05 13:48:56.000000000 -0400
@@ -68,10 +68,12 @@ union map_info *dm_get_mapinfo(struct bi
 #define DMF_FROZEN 2
 #define DMF_FREEING 3
 #define DMF_DELETING 4
+#define DMF_NOFLUSH_SUSPENDING 5
 
 struct mapped_device {
 	struct rw_semaphore io_lock;
 	struct semaphore suspend_lock;
+	spinlock_t pushback_lock;
 	rwlock_t map_lock;
 	atomic_t holders;
 	atomic_t open_count;
@@ -90,6 +92,7 @@ struct mapped_device {
 	atomic_t pending;
 	wait_queue_head_t wait;
  	struct bio_list deferred;
+	struct bio_list pushback;
 
 	/*
 	 * The current mapping.
@@ -444,23 +447,50 @@ int dm_set_geometry(struct mapped_device
  *   you this clearly demarcated crap.
  *---------------------------------------------------------------*/
 
+static int __noflush_suspending(struct mapped_device *md)
+{
+	return test_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
+}
+
 /*
  * Decrements the number of outstanding ios that a bio has been
  * cloned into, completing the original io if necc.
  */
 static void dec_pending(struct dm_io *io, int error)
 {
-	if (error)
+	unsigned long flags;
+
+	/* Push-back supersedes any I/O errors */
+	if (error && !(io->error > 0 && __noflush_suspending(io->md)))
 		io->error = error;
 
 	if (atomic_dec_and_test(&io->io_count)) {
+		if (io->error == DM_ENDIO_REQUEUE) {
+			/*
+			 * Target requested pushing back the I/O.
+			 * This must be handled before the sleeper on
+			 * suspend queue merges the pushback list.
+			 */
+			spin_lock_irqsave(&io->md->pushback_lock, flags);
+			if (__noflush_suspending(io->md))
+				bio_list_add(&io->md->pushback, io->bio);
+			else
+				/* noflush suspend was interrupted. */
+				io->error = -EIO;
+			spin_unlock_irqrestore(&io->md->pushback_lock, flags);
+		}
+
 		if (end_io_acct(io))
 			/* nudge anyone waiting on suspend queue */
 			wake_up(&io->md->wait);
 
-		blk_add_trace_bio(io->md->queue, io->bio, BLK_TA_COMPLETE);
+		if (io->error != DM_ENDIO_REQUEUE) {
+			blk_add_trace_bio(io->md->queue, io->bio,
+					  BLK_TA_COMPLETE);
+
+			bio_endio(io->bio, io->bio->bi_size, io->error);
+		}
 
-		bio_endio(io->bio, io->bio->bi_size, io->error);
 		free_io(io->md, io);
 	}
 }
@@ -480,7 +510,11 @@ static int clone_endio(struct bio *bio, 
 
 	if (endio) {
 		r = endio(tio->ti, bio, error, &tio->info);
-		if (r < 0)
+		if (r < 0 || r == DM_ENDIO_REQUEUE)
+			/*
+			 * error and requeue request are handled
+			 * in dec_pending().
+			 */
 			error = r;
 		else if (r == DM_ENDIO_INCOMPLETE)
 			/* The target will handle the io */
@@ -554,8 +588,8 @@ static void __map_bio(struct dm_target *
 				    clone->bi_sector);
 
 		generic_make_request(clone);
-	} else if (r < 0) {
-		/* error the io and bail out */
+	} else if (r < 0 || r == DM_MAPIO_REQUEUE) {
+		/* error the io and bail out, or requeue it if needed */
 		md = tio->io->md;
 		dec_pending(tio->io, r);
 		/*
@@ -952,6 +986,7 @@ static struct mapped_device *alloc_dev(i
 	memset(md, 0, sizeof(*md));
 	init_rwsem(&md->io_lock);
 	init_MUTEX(&md->suspend_lock);
+	spin_lock_init(&md->pushback_lock);
 	rwlock_init(&md->map_lock);
 	atomic_set(&md->holders, 1);
 	atomic_set(&md->open_count, 0);
@@ -1282,10 +1317,12 @@ static void unlock_fs(struct mapped_devi
 int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 {
 	struct dm_table *map = NULL;
+	unsigned long flags;
 	DECLARE_WAITQUEUE(wait, current);
 	struct bio *def;
 	int r = -EINVAL;
 	int do_lockfs = suspend_flags & DM_SUSPEND_LOCKFS_FLAG ? 1 : 0;
+	int noflush = suspend_flags & DM_SUSPEND_NOFLUSH_FLAG ? 1 : 0;
 
 	down(&md->suspend_lock);
 
@@ -1294,6 +1331,13 @@ int dm_suspend(struct mapped_device *md,
 
 	map = dm_get_table(md);
 
+	/*
+	 * DMF_NOFLUSH_SUSPENDING must be set before presuspend.
+	 * This flag is cleared before dm_suspend returns.
+	 */
+	if (noflush)
+		set_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
+
 	/* This does not get reverted if there's an error later. */
 	dm_table_presuspend_targets(map);
 
@@ -1301,11 +1345,14 @@ int dm_suspend(struct mapped_device *md,
 	if (!md->suspended_bdev) {
 		DMWARN("bdget failed in dm_suspend");
 		r = -ENOMEM;
-		goto out;
+		goto flush_and_out;
 	}
 
-	/* Flush I/O to the device. */
-	if (do_lockfs) {
+	/*
+	 * Flush I/O to the device.
+	 * noflush supersedes do_lockfs, because lock_fs() needs to flush I/Os.
+	 */
+	if (do_lockfs && !noflush) {
 		r = lock_fs(md);
 		if (r)
 			goto out;
@@ -1341,6 +1388,14 @@ int dm_suspend(struct mapped_device *md,
 	down_write(&md->io_lock);
 	remove_wait_queue(&md->wait, &wait);
 
+	if (noflush) {
+		spin_lock_irqsave(&md->pushback_lock, flags);
+		clear_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
+		bio_list_merge_head(&md->deferred, &md->pushback);
+		bio_list_init(&md->pushback);
+		spin_unlock_irqrestore(&md->pushback_lock, flags);
+	}
+
 	/* were we interrupted ? */
 	r = -EINTR;
 	if (atomic_read(&md->pending)) {
@@ -1349,7 +1404,7 @@ int dm_suspend(struct mapped_device *md,
 		__flush_deferred_io(md, def);
 		up_write(&md->io_lock);
 		unlock_fs(md);
-		goto out;
+		goto out; /* pushback list is already flushed, so skip flush */
 	}
 	up_write(&md->io_lock);
 
@@ -1359,6 +1414,25 @@ int dm_suspend(struct mapped_device *md,
 
 	r = 0;
 
+flush_and_out:
+	if (r && noflush) {
+		/*
+		 * Because there may be already I/Os in the pushback list,
+		 * flush them before return.
+		 */
+		down_write(&md->io_lock);
+
+		spin_lock_irqsave(&md->pushback_lock, flags);
+		clear_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
+		bio_list_merge_head(&md->deferred, &md->pushback);
+		bio_list_init(&md->pushback);
+		spin_unlock_irqrestore(&md->pushback_lock, flags);
+
+		def = bio_list_get(&md->deferred);
+		__flush_deferred_io(md, def);
+		up_write(&md->io_lock);
+	}
+
 out:
 	if (r && md->suspended_bdev) {
 		bdput(md->suspended_bdev);
@@ -1443,6 +1517,17 @@ int dm_suspended(struct mapped_device *m
 	return test_bit(DMF_SUSPENDED, &md->flags);
 }
 
+int dm_noflush_suspending(struct dm_target *ti)
+{
+	struct mapped_device *md = dm_table_get_md(ti->table);
+	int r = __noflush_suspending(md);
+
+	dm_put(md);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(dm_noflush_suspending);
+
 static struct block_device_operations dm_blk_dops = {
 	.open = dm_blk_open,
 	.release = dm_blk_close,
diff -rupN 5-add-noflush-ioctl-opt/drivers/md/dm.h 6-core-pushback/drivers/md/dm.h
--- 5-add-noflush-ioctl-opt/drivers/md/dm.h	2006-10-05 10:54:03.000000000 -0400
+++ 6-core-pushback/drivers/md/dm.h	2006-10-05 11:36:27.000000000 -0400
@@ -36,12 +36,14 @@
  * Definitions of return values from target end_io function.
  */
 #define DM_ENDIO_INCOMPLETE	1
+#define DM_ENDIO_REQUEUE	2
 
 /*
  * Definitions of return values from target map function.
  */
 #define DM_MAPIO_SUBMITTED	0
 #define DM_MAPIO_REMAPPED	1
+#define DM_MAPIO_REQUEUE	DM_ENDIO_REQUEUE
 
 /*
  * Suspend feature flags
diff -rupN 5-add-noflush-ioctl-opt/include/linux/device-mapper.h 6-core-pushback/include/linux/device-mapper.h
--- 5-add-noflush-ioctl-opt/include/linux/device-mapper.h	2006-10-05 10:41:27.000000000 -0400
+++ 6-core-pushback/include/linux/device-mapper.h	2006-10-05 11:35:42.000000000 -0400
@@ -40,6 +40,7 @@ typedef void (*dm_dtr_fn) (struct dm_tar
  * < 0: error
  * = 0: The target will handle the io by resubmitting it later
  * = 1: simple remap complete
+ * = 2: The target wants to push back the io
  */
 typedef int (*dm_map_fn) (struct dm_target *ti, struct bio *bio,
 			  union map_info *map_context);
@@ -50,6 +51,7 @@ typedef int (*dm_map_fn) (struct dm_targ
  * 0   : ended successfully
  * 1   : for some reason the io has still not completed (eg,
  *       multipath target might want to requeue a failed io).
+ * 2   : The target wants to push back the io
  */
 typedef int (*dm_endio_fn) (struct dm_target *ti,
 			    struct bio *bio, int error,
@@ -188,6 +190,7 @@ int dm_wait_event(struct mapped_device *
 const char *dm_device_name(struct mapped_device *md);
 struct gendisk *dm_disk(struct mapped_device *md);
 int dm_suspended(struct mapped_device *md);
+int dm_noflush_suspending(struct dm_target *ti);
 
 /*
  * Geometry functions.
