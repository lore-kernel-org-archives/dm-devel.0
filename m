From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 2/4] dm_queue: add noflush feature to dm_queue
	(take 2)
Date: Mon, 10 Jul 2006 18:34:38 -0400 (EDT)
Message-ID: <20060710.183438.77065367.k-ueda@ct.jp.nec.com>
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

This patch adds 'noflush' feature which enables suspend
without flushing I/O and handovers queued bios to new mapping
after table swapping.
The feature is implemented as the following steps:

  1). At suspension, woker thread stops queue processing
      if the queue can be stopped without flushing.

  2). When table is swapped at resume time, queued bios are unmapped
      and handover the original bios to deferred list in mapped_device.

  3). Upon resuming the new table, the original bios in deferred list
      are remapped and issued based on the new table.

If table swap doesn't occur, no change is made on queued bios.

The noflush feature is optional.
dm_queue user (target driver) can decide to enable the feature.
If the feature isn't enabled, suspend/resume behavior is unchanged.

The patch is for 2.6.18-rc1-mm1.

Regards,
Kiyoshi Ueda


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

diff -rupN 2.6.18-rc1-mm1.dmq/drivers/md/dm.c 2.6.18-rc1-mm1.dmq.noflush/drivers/md/dm.c
--- 2.6.18-rc1-mm1.dmq/drivers/md/dm.c	2006-07-10 13:40:13.000000000 -0400
+++ 2.6.18-rc1-mm1.dmq.noflush/drivers/md/dm.c	2006-07-10 13:08:29.000000000 -0400
@@ -68,6 +68,7 @@ union map_info *dm_get_mapinfo(struct bi
 #define DMF_FROZEN 2
 #define DMF_FREEING 3
 #define DMF_DELETING 4
+#define DMF_NOFLUSH_SUSPENDING 5
 
 struct mapped_device {
 	struct rw_semaphore io_lock;
@@ -92,6 +93,12 @@ struct mapped_device {
  	struct bio_list deferred;
 
 	/*
+	 * The number of cloned and mapped ios.
+	 * These ios are in-flight or queued by a target.
+	 */
+	atomic_t pending_tio;
+
+	/*
 	 * The current mapping.
 	 */
 	struct dm_table *map;
@@ -462,9 +469,7 @@ static void dec_pending(struct dm_io *io
 		io->error = error;
 
 	if (atomic_dec_and_test(&io->io_count)) {
-		if (end_io_acct(io))
-			/* nudge anyone waiting on suspend queue */
-			wake_up(&io->md->wait);
+		end_io_acct(io);
 
 		blk_add_trace_bio(io->md->queue, io->bio, BLK_TA_COMPLETE);
 
@@ -473,6 +478,23 @@ static void dec_pending(struct dm_io *io
 	}
 }
 
+/*
+ * Wake up a process waiting on suspend queue
+ *   1) if a tio was finished (tio_finished) and there is no pending ios,
+ *      because all pending ios may have been finished.
+ *   2) otherwise if noflush-suspending mode is set,
+ *      because the mapped_device may have became quiescent
+ *      by having done (if tio_finished) or queued (if !tio_finished)
+ *      the last in-flight io.
+ */
+static void wakeup_suspender(struct mapped_device *md, int tio_finished)
+{
+	if ((tio_finished && atomic_dec_and_test(&md->pending_tio)) ||
+	    dm_noflush_suspending(md))
+		/* nudge anyone waiting on suspend queue */
+		wake_up(&md->wait);
+}
+
 static int clone_endio(struct bio *bio, unsigned int done, int error)
 {
 	int r = 0;
@@ -491,17 +513,57 @@ static int clone_endio(struct bio *bio, 
 		if (r < 0)
 			error = r;
 
-		else if (r > 0)
+		else if (r > 0) {
 			/* the target wants another shot at the io */
+
+			/*
+			 * Wake up waiting process on suspend queue
+			 * if noflush-suspending mode is set.
+			 */
+			wakeup_suspender(io->md, 0);
+
 			return 1;
+		}
 	}
 
 	free_tio(io->md, tio);
+	wakeup_suspender(io->md, 1);
 	dec_pending(io, error);
 	bio_put(bio);
 	return r;
 }
 
+struct bio *dm_unmap_bio(struct bio *clone)
+{
+	struct bio *orig = NULL;
+	struct target_io *tio = (struct target_io *) clone->bi_private;
+	struct dm_io *io = tio->io;
+	dm_unmap_fn unmap = tio->ti->type->unmap;
+	int r = 0;
+
+	/* remove target specific data */
+	if (unmap)
+		r = unmap(tio->ti, clone, &tio->info);
+
+	if (r) {
+		DMERR("target unmap function failed. The memory leaked!");
+		BUG();
+	}
+
+	free_tio(io->md, tio);
+	atomic_dec(&io->md->pending_tio);
+
+	if (atomic_dec_and_test(&io->io_count)) {
+		end_io_acct(io);
+		orig = io->bio;
+		free_io(io->md, io);
+	}
+
+	bio_put(clone);
+
+	return orig;
+}
+
 static sector_t max_io_len(struct mapped_device *md,
 			   sector_t sector, struct dm_target *ti)
 {
@@ -542,6 +604,7 @@ static void __map_bio(struct dm_target *
 	 * this io.
 	 */
 	atomic_inc(&tio->io->io_count);
+	atomic_inc(&tio->io->md->pending_tio);
 	sector = clone->bi_sector;
 	r = ti->type->map(ti, clone, &tio->info);
 	if (r > 0) {
@@ -558,6 +621,7 @@ static void __map_bio(struct dm_target *
 		/* error the io and bail out */
 		struct dm_io *io = tio->io;
 		free_tio(tio->io->md, tio);
+		wakeup_suspender(io->md, 1);
 		dec_pending(io, r);
 		bio_put(clone);
 	}
@@ -968,6 +1032,7 @@ static struct mapped_device *alloc_dev(i
 		goto bad4;
 
 	atomic_set(&md->pending, 0);
+	atomic_set(&md->pending_tio, 0);
 	init_waitqueue_head(&md->wait);
 	init_waitqueue_head(&md->eventq);
 
@@ -1081,6 +1146,16 @@ static void __unbind(struct mapped_devic
 	if (!map)
 		return;
 
+	if (dm_noflush_suspending(md)) {
+		struct bio_list bl;
+
+		bio_list_init(&bl);
+		dm_table_withdraw_queued_io(map, &bl);
+		down_write(&md->io_lock);
+		bio_list_merge_head(&md->deferred, &bl);
+		up_write(&md->io_lock);
+	}
+
 	dm_table_event_callback(map, NULL, NULL);
 	write_lock(&md->map_lock);
 	md->map = NULL;
@@ -1257,12 +1332,13 @@ static void unlock_fs(struct mapped_devi
  * dm_bind_table, dm_suspend must be called to flush any in
  * flight bios and ensure that any further io gets deferred.
  */
-int dm_suspend(struct mapped_device *md, int do_lockfs)
+int dm_suspend(struct mapped_device *md, int do_lockfs, int noflush)
 {
 	struct dm_table *map = NULL;
 	DECLARE_WAITQUEUE(wait, current);
 	struct bio *def;
 	int r = -EINVAL;
+	int queued_bios = 0;
 
 	down(&md->suspend_lock);
 
@@ -1271,6 +1347,10 @@ int dm_suspend(struct mapped_device *md,
 
 	map = dm_get_table(md);
 
+	/* DMF_NOFLUSH_SUSPENDING must be set before presuspend. */
+	if (noflush)
+		set_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
+
 	/* This does not get reverted if there's an error later. */
 	dm_table_presuspend_targets(map);
 
@@ -1282,7 +1362,7 @@ int dm_suspend(struct mapped_device *md,
 	}
 
 	/* Flush I/O to the device. */
-	if (do_lockfs) {
+	if (do_lockfs && !noflush) {
 		r = lock_fs(md);
 		if (r)
 			goto out;
@@ -1303,12 +1383,16 @@ int dm_suspend(struct mapped_device *md,
 
 	/*
 	 * Then we wait for the already mapped ios to
-	 * complete.
+	 * complete or be queued when no flushing.
 	 */
 	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
 
-		if (!atomic_read(&md->pending) || signal_pending(current))
+		if (noflush)
+			queued_bios = dm_table_queue_size(map, 1);
+
+		if ((atomic_read(&md->pending_tio) == queued_bios) ||
+		    signal_pending(current))
 			break;
 
 		io_schedule();
@@ -1320,7 +1404,11 @@ int dm_suspend(struct mapped_device *md,
 
 	/* were we interrupted ? */
 	r = -EINTR;
-	if (atomic_read(&md->pending)) {
+	if (atomic_read(&md->pending_tio) != queued_bios) {
+		if (noflush) {
+			clear_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
+			dm_table_process_queue(map);
+		}
 		clear_bit(DMF_BLOCK_IO, &md->flags);
 		def = bio_list_get(&md->deferred);
 		__flush_deferred_io(md, def);
@@ -1361,6 +1449,12 @@ int dm_resume(struct mapped_device *md)
 	if (!map || !dm_table_get_size(map))
 		goto out;
 
+	/*
+	 * DMF_NOFLUSH_SUSPENDING will prevent target resume function
+	 * to restart pending I/Os.  So clearing it here.
+	 */
+	clear_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
+
 	dm_table_resume_targets(map);
 
 	down_write(&md->io_lock);
@@ -1416,6 +1510,12 @@ int dm_suspended(struct mapped_device *m
 	return test_bit(DMF_SUSPENDED, &md->flags);
 }
 
+int dm_noflush_suspending(struct mapped_device *md)
+{
+	return test_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
+}
+EXPORT_SYMBOL_GPL(dm_noflush_suspending);
+
 static struct block_device_operations dm_blk_dops = {
 	.open = dm_blk_open,
 	.release = dm_blk_close,
diff -rupN 2.6.18-rc1-mm1.dmq/drivers/md/dm-table.c 2.6.18-rc1-mm1.dmq.noflush/drivers/md/dm-table.c
--- 2.6.18-rc1-mm1.dmq/drivers/md/dm-table.c	2006-07-10 13:52:28.000000000 -0400
+++ 2.6.18-rc1-mm1.dmq.noflush/drivers/md/dm-table.c	2006-07-10 13:14:52.000000000 -0400
@@ -1008,6 +1008,65 @@ struct mapped_device *dm_table_get_md(st
 	return t->md;
 }
 
+void dm_table_withdraw_queued_io(struct dm_table *t, struct bio_list *bl)
+{
+	int i, j;
+
+	for (i = 0; i < t->num_targets; i++) {
+		struct dm_target *ti = t->targets + i;
+
+		for (j = 0; j < ti->num_queues; j++) {
+			struct dm_queue *q = dm_queue_find(ti->queues, j);
+			dm_queue_withdraw(q, bl);
+		}
+	}
+}
+
+/*
+ * Abount 'noflush_suspending' parameter:
+ * noflush suspend assumes the queued bios are freezed,
+ * i.e. stay in the queue, during the suspension process.
+ * However, if the queue doesn't support noflush mode,
+ * bios in the queue can be popped and processed even when
+ * noflush suspend is underway.
+ * So if 'noflush_suspending' is non-zero, the function excludes
+ * the lengths of noflush-disabled queues.
+ */
+int dm_table_queue_size(struct dm_table *t, int noflush_suspending)
+{
+	int size = 0;
+	int i, j;
+
+	for (i = 0; i < t->num_targets; i++) {
+		struct dm_target *ti = t->targets + i;
+
+		for (j = 0; j < ti->num_queues; j++) {
+			struct dm_queue *q = dm_queue_find(ti->queues, j);
+
+			if (noflush_suspending && !dm_queue_noflush_enabled(q))
+				continue;
+
+			size += dm_queue_size(q);
+		}
+	}
+
+	return size;
+}
+
+void dm_table_process_queue(struct dm_table *t)
+{
+	int i, j;
+
+	for (i = 0; i < t->num_targets; i++) {
+		struct dm_target *ti = t->targets + i;
+
+		for (j = 0; j < ti->num_queues; j++) {
+			struct dm_queue *q = dm_queue_find(ti->queues, j);
+			dm_queue_process(q);
+		}
+	}
+}
+
 EXPORT_SYMBOL(dm_vcalloc);
 EXPORT_SYMBOL(dm_get_device);
 EXPORT_SYMBOL(dm_put_device);
diff -rupN 2.6.18-rc1-mm1.dmq/drivers/md/dm-queue.c 2.6.18-rc1-mm1.dmq.noflush/drivers/md/dm-queue.c
--- 2.6.18-rc1-mm1.dmq/drivers/md/dm-queue.c	2006-07-10 13:51:38.000000000 -0400
+++ 2.6.18-rc1-mm1.dmq.noflush/drivers/md/dm-queue.c	2006-07-10 11:47:52.000000000 -0400
@@ -11,6 +11,8 @@
 
 struct workqueue_struct *kdmqd;
 
+#define DMQ_NOFLUSH	0
+
 struct dm_queue {
 	spinlock_t lock; /* protects .bios and .size */
 	struct bio_list bios;
@@ -18,6 +20,7 @@ struct dm_queue {
 
 	struct dm_target *ti;
 	struct work_struct work;
+	unsigned long flags;
 };
 
 int dm_queue_init()
@@ -81,6 +84,7 @@ int dm_queue_setup(struct dm_queue *q, v
 	q->size = 0;
 	q->ti = ti;
 	INIT_WORK(&q->work, work, q);
+	q->flags = 0UL;
 
 	return 0;
 }
@@ -106,10 +110,14 @@ struct bio *dm_queue_pop_bio(struct dm_q
 
 	spin_lock_irqsave(&q->lock, flags);
 
+	if (dm_queue_noflush_suspending(q) && dm_queue_noflush_enabled(q))
+		goto out;
+
 	bio = bio_list_pop(&q->bios);
 	if (bio)
 		q->size--;
 
+out:
 	spin_unlock_irqrestore(&q->lock, flags);
 
 	return bio;
@@ -123,9 +131,13 @@ struct bio *dm_queue_get_bios(struct dm_
 
 	spin_lock_irqsave(&q->lock, flags);
 
+	if (dm_queue_noflush_suspending(q) && dm_queue_noflush_enabled(q))
+		goto out;
+
 	bio = bio_list_get(&q->bios);
 	q->size = 0;
 
+out:
 	spin_unlock_irqrestore(&q->lock, flags);
 
 	return bio;
@@ -151,6 +163,30 @@ struct dm_target *dm_queue_get_target(st
 }
 EXPORT_SYMBOL_GPL(dm_queue_get_target);
 
+int dm_queue_enable_noflush(struct dm_queue *q)
+{
+	set_bit(DMQ_NOFLUSH, &q->flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_queue_enable_noflush);
+
+int dm_queue_noflush_enabled(struct dm_queue *q)
+{
+	return test_bit(DMQ_NOFLUSH, &q->flags);
+}
+
+int dm_queue_noflush_suspending(struct dm_queue *q)
+{
+	struct mapped_device *md = dm_table_get_md(q->ti->table);
+	int r = dm_noflush_suspending(md);
+
+	dm_put(md);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(dm_queue_noflush_suspending);
+
 void dm_queue_process(struct dm_queue *q)
 {
 	unsigned long flags;
@@ -160,9 +196,34 @@ void dm_queue_process(struct dm_queue *q
 	if (!q->size)
 		goto out;
 
+	if (dm_queue_noflush_suspending(q) && dm_queue_noflush_enabled(q))
+		goto out;
+
 	queue_work(kdmqd, &q->work);
 
 out:
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 EXPORT_SYMBOL_GPL(dm_queue_process);
+
+void dm_queue_withdraw(struct dm_queue *q, struct bio_list *bl)
+{
+	struct bio *clone, *next, *orig;
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->lock, flags);
+	clone = bio_list_get(&q->bios);
+	q->size = 0;
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	while (clone) {
+		next = clone->bi_next;
+		clone->bi_next = NULL;
+
+		orig = dm_unmap_bio(clone);
+		if (orig)
+			bio_list_add(bl, orig);
+
+		clone = next;
+	}
+}
diff -rupN 2.6.18-rc1-mm1.dmq/drivers/md/dm-ioctl.c 2.6.18-rc1-mm1.dmq.noflush/drivers/md/dm-ioctl.c
--- 2.6.18-rc1-mm1.dmq/drivers/md/dm-ioctl.c	2006-07-10 13:44:56.000000000 -0400
+++ 2.6.18-rc1-mm1.dmq.noflush/drivers/md/dm-ioctl.c	2006-07-10 09:09:53.000000000 -0400
@@ -761,6 +761,7 @@ static int do_suspend(struct dm_ioctl *p
 {
 	int r = 0;
 	int do_lockfs = 1;
+	int noflush = 0;
 	struct mapped_device *md;
 
 	md = find_device(param);
@@ -769,9 +770,11 @@ static int do_suspend(struct dm_ioctl *p
 
 	if (param->flags & DM_SKIP_LOCKFS_FLAG)
 		do_lockfs = 0;
+	if (param->flags & DM_NOFLUSH_FLAG)
+		noflush = 1;
 
 	if (!dm_suspended(md))
-		r = dm_suspend(md, do_lockfs);
+		r = dm_suspend(md, do_lockfs, noflush);
 
 	if (!r)
 		r = __dev_status(md, param);
@@ -784,6 +787,7 @@ static int do_resume(struct dm_ioctl *pa
 {
 	int r = 0;
 	int do_lockfs = 1;
+	int noflush = 0;
 	struct hash_cell *hc;
 	struct mapped_device *md;
 	struct dm_table *new_map;
@@ -810,8 +814,10 @@ static int do_resume(struct dm_ioctl *pa
 		/* Suspend if it isn't already suspended */
 		if (param->flags & DM_SKIP_LOCKFS_FLAG)
 			do_lockfs = 0;
+		if (param->flags & DM_NOFLUSH_FLAG)
+			noflush = 1;
 		if (!dm_suspended(md))
-			dm_suspend(md, do_lockfs);
+			dm_suspend(md, do_lockfs, noflush);
 
 		r = dm_swap_table(md, new_map);
 		if (r) {
diff -rupN 2.6.18-rc1-mm1.dmq/drivers/md/dm.h 2.6.18-rc1-mm1.dmq.noflush/drivers/md/dm.h
--- 2.6.18-rc1-mm1.dmq/drivers/md/dm.h	2006-07-10 13:42:23.000000000 -0400
+++ 2.6.18-rc1-mm1.dmq.noflush/drivers/md/dm.h	2006-07-10 13:15:05.000000000 -0400
@@ -40,6 +40,8 @@ struct dm_dev {
 };
 
 struct dm_table;
+struct bio_list;
+struct dm_queue;
 
 /*-----------------------------------------------------------------
  * Internal table functions.
@@ -56,12 +58,17 @@ void dm_table_resume_targets(struct dm_t
 int dm_table_any_congested(struct dm_table *t, int bdi_bits);
 void dm_table_unplug_all(struct dm_table *t);
 int dm_table_flush_all(struct dm_table *t);
+void dm_table_withdraw_queued_io(struct dm_table *t, struct bio_list *bl);
+int dm_table_queue_size(struct dm_table *t, int noflush_suspending);
+void dm_table_process_queue(struct dm_table *t);
 
 /*-----------------------------------------------------------------
  * Queue functions.
  *---------------------------------------------------------------*/
 int dm_queue_init(void);
 void dm_queue_exit(void);
+int dm_queue_noflush_enabled(struct dm_queue *q);
+void dm_queue_withdraw(struct dm_queue *q, struct bio_list *bl);
 
 /*-----------------------------------------------------------------
  * A registry of target types.
@@ -132,5 +139,6 @@ void *dm_vcalloc(unsigned long nmemb, un
 union map_info *dm_get_mapinfo(struct bio *bio);
 int dm_open_count(struct mapped_device *md);
 int dm_lock_for_deletion(struct mapped_device *md);
+struct bio *dm_unmap_bio(struct bio *bio);
 
 #endif
diff -rupN 2.6.18-rc1-mm1.dmq/include/linux/device-mapper.h 2.6.18-rc1-mm1.dmq.noflush/include/linux/device-mapper.h
--- 2.6.18-rc1-mm1.dmq/include/linux/device-mapper.h	2006-07-10 13:54:31.000000000 -0400
+++ 2.6.18-rc1-mm1.dmq.noflush/include/linux/device-mapper.h	2006-07-10 13:21:04.000000000 -0400
@@ -56,6 +56,8 @@ typedef int (*dm_endio_fn) (struct dm_ta
 			    struct bio *bio, int error,
 			    union map_info *map_context);
 
+typedef int (*dm_unmap_fn) (struct dm_target *ti, struct bio *bio,
+			    union map_info *map_context);
 typedef void (*dm_presuspend_fn) (struct dm_target *ti);
 typedef void (*dm_postsuspend_fn) (struct dm_target *ti);
 typedef void (*dm_resume_fn) (struct dm_target *ti);
@@ -91,6 +93,7 @@ struct target_type {
 	dm_dtr_fn dtr;
 	dm_map_fn map;
 	dm_endio_fn end_io;
+	dm_unmap_fn unmap;
 	dm_presuspend_fn presuspend;
 	dm_postsuspend_fn postsuspend;
 	dm_resume_fn resume;
@@ -169,7 +172,7 @@ void *dm_get_mdptr(struct mapped_device 
 /*
  * A device can still be used while suspended, but I/O is deferred.
  */
-int dm_suspend(struct mapped_device *md, int with_lockfs);
+int dm_suspend(struct mapped_device *md, int with_lockfs, int noflush);
 int dm_resume(struct mapped_device *md);
 
 /*
@@ -184,6 +187,7 @@ int dm_wait_event(struct mapped_device *
 const char *dm_device_name(struct mapped_device *md);
 struct gendisk *dm_disk(struct mapped_device *md);
 int dm_suspended(struct mapped_device *md);
+int dm_noflush_suspending(struct mapped_device *md);
 
 /*
  * Geometry functions.
@@ -266,6 +270,11 @@ int dm_queue_setup(struct dm_queue *q, v
 		   struct dm_target *ti);
 
 /*
+ * Optional setups.
+ */
+int dm_queue_enable_noflush(struct dm_queue *q);
+
+/*
  * Free allocated queues.
  */
 void dm_queue_free(struct dm_queue *qs);
@@ -287,6 +296,7 @@ struct bio *dm_queue_get_bios(struct dm_
  */
 unsigned int dm_queue_size(struct dm_queue *q);
 struct dm_target *dm_queue_get_target(struct dm_queue *q);
+int dm_queue_noflush_suspending(struct dm_queue *q);
 
 /*
  * Start processing a queue.
diff -rupN 2.6.18-rc1-mm1.dmq/include/linux/dm-ioctl.h 2.6.18-rc1-mm1.dmq.noflush/include/linux/dm-ioctl.h
--- 2.6.18-rc1-mm1.dmq/include/linux/dm-ioctl.h	2006-07-10 13:55:15.000000000 -0400
+++ 2.6.18-rc1-mm1.dmq.noflush/include/linux/dm-ioctl.h	2006-07-10 09:09:53.000000000 -0400
@@ -323,4 +323,9 @@ typedef char ioctl_struct[308];
  */
 #define DM_SKIP_LOCKFS_FLAG	(1 << 10) /* In */
 
+/*
+ * Set this to suspend without flushing queued ios.
+ */
+#define DM_NOFLUSH_FLAG		(1 << 11) /* In */
+
 #endif				/* _LINUX_DM_IOCTL_H */
diff -rupN 2.6.18-rc1-mm1.dmq/drivers/md/dm-bio-list.h 2.6.18-rc1-mm1.dmq.noflush/drivers/md/dm-bio-list.h
--- 2.6.18-rc1-mm1.dmq/drivers/md/dm-bio-list.h	2006-07-10 13:31:13.000000000 -0400
+++ 2.6.18-rc1-mm1.dmq.noflush/drivers/md/dm-bio-list.h	2006-07-10 09:09:53.000000000 -0400
@@ -44,6 +44,19 @@ static inline void bio_list_merge(struct
 	bl->tail = bl2->tail;
 }
 
+static inline void bio_list_merge_head(struct bio_list *bl, struct bio_list *bl2)
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
