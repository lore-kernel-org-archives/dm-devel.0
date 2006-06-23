From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC PATCH 2/4] dm_queue: add fastsuspend feature to
	dm_queue
Date: Fri, 23 Jun 2006 17:48:15 -0400 (EDT)
Message-ID: <20060623.174815.45517450.k-ueda@ct.jp.nec.com>
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

This patch adds fastsuspend feature which enables suspend
without flushing I/O and handovers queued bios to new mapping
after table swapping.
The feature is implemented as the following steps:

  1). At suspension, woker thread stops queue processing
      if the queue can be stopped without flushing.
      [This step is called "fastsuspend".]

  2). When table is swapped at resume time, queued bios are unmapped
      and handover the original bios to deferred list in mapped_device.

  3). Upon resuming the new table, the original bios in deferred list
      are remapped and issued based on the new table.

If table swap doesn't occur, no change is made on queued bios.

The fastsuspend feature is optional.
dm_queue user (target driver) can decide to enable the feature.
If the feature isn't enabled, suspend/resume behavior is unchanged.

The patch is for 2.6.17-rc6-mm1 + Alasdair's patches which was sent
to this ML (Subject: "Next set of device-mapper patches").

Regards,
Kiyoshi Ueda


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

diff -rupN 2.6.17-rc6-mm1.agk.moveq/drivers/md/dm.c 2.6.17-rc6-mm1.agk.moveq.fastsusp/drivers/md/dm.c
--- 2.6.17-rc6-mm1.agk.moveq/drivers/md/dm.c	2006-06-23 11:17:29.000000000 -0400
+++ 2.6.17-rc6-mm1.agk.moveq.fastsusp/drivers/md/dm.c	2006-06-23 10:47:23.000000000 -0400
@@ -67,6 +67,7 @@ EXPORT_SYMBOL_GPL(dm_get_mapinfo);
 #define DMF_FROZEN 2
 #define DMF_FREEING 3
 #define DMF_DELETING 4
+#define DMF_QFREEZING 5
 
 struct mapped_device {
 	struct rw_semaphore io_lock;
@@ -497,6 +498,36 @@ static int clone_endio(struct bio *bio, 
 	return r;
 }
 
+struct bio *dm_unmap_bio(struct bio *clone)
+{
+	struct bio *orig = NULL;
+	struct target_io *tio = clone->bi_private;
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
@@ -1076,6 +1107,16 @@ static void __unbind(struct mapped_devic
 	if (!map)
 		return;
 
+	if (dm_qfreezing(md)) {
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
@@ -1252,12 +1293,13 @@ static void unlock_fs(struct mapped_devi
  * dm_bind_table, dm_suspend must be called to flush any in
  * flight bios and ensure that any further io gets deferred.
  */
-int dm_suspend(struct mapped_device *md, int do_lockfs)
+int dm_suspend(struct mapped_device *md, int do_lockfs, int fastsuspend)
 {
 	struct dm_table *map = NULL;
 	DECLARE_WAITQUEUE(wait, current);
 	struct bio *def;
 	int r = -EINVAL;
+	unsigned int queued_bios = 0;
 
 	down(&md->suspend_lock);
 
@@ -1266,6 +1308,10 @@ int dm_suspend(struct mapped_device *md,
 
 	map = dm_get_table(md);
 
+	/* DMF_QFREEZING must be set before presuspend. */
+	if (fastsuspend)
+		set_bit(DMF_QFREEZING, &md->flags);
+
 	/* This does not get reverted if there's an error later. */
 	dm_table_presuspend_targets(map);
 
@@ -1277,7 +1323,7 @@ int dm_suspend(struct mapped_device *md,
 	}
 
 	/* Flush I/O to the device. */
-	if (do_lockfs) {
+	if (do_lockfs && !fastsuspend) {
 		r = lock_fs(md);
 		if (r)
 			goto out;
@@ -1298,12 +1344,16 @@ int dm_suspend(struct mapped_device *md,
 
 	/*
 	 * Then we wait for the already mapped ios to
-	 * complete.
+	 * complete or be queued when fastsuspending.
 	 */
 	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
 
-		if (!atomic_read(&md->pending) || signal_pending(current))
+		if (fastsuspend)
+			queued_bios = dm_table_queue_size(map, 1);
+
+		if ((atomic_read(&md->pending) == queued_bios) ||
+		    signal_pending(current))
 			break;
 
 		io_schedule();
@@ -1315,7 +1365,11 @@ int dm_suspend(struct mapped_device *md,
 
 	/* were we interrupted ? */
 	r = -EINTR;
-	if (atomic_read(&md->pending)) {
+	if (atomic_read(&md->pending) != queued_bios) {
+		if (fastsuspend) {
+			clear_bit(DMF_QFREEZING, &md->flags);
+			dm_table_process_queue(map);
+		}
 		clear_bit(DMF_BLOCK_IO, &md->flags);
 		def = bio_list_get(&md->deferred);
 		__flush_deferred_io(md, def);
@@ -1357,6 +1411,12 @@ int dm_resume(struct mapped_device *md)
 	if (!map || !dm_table_get_size(map))
 		goto out;
 
+	/*
+	 * DMF_QFREEZING will prevent target resume function to restart
+	 * pending I/Os.  So clearing it here.
+	 */
+	clear_bit(DMF_QFREEZING, &md->flags);
+
 	dm_table_resume_targets(map);
 
 	down_write(&md->io_lock);
@@ -1417,6 +1477,12 @@ int dm_suspended(struct mapped_device *m
 }
 EXPORT_SYMBOL_GPL(dm_suspended);
 
+int dm_qfreezing(struct mapped_device *md)
+{
+	return test_bit(DMF_QFREEZING, &md->flags);
+}
+EXPORT_SYMBOL_GPL(dm_qfreezing);
+
 static struct block_device_operations dm_blk_dops = {
 	.open = dm_blk_open,
 	.release = dm_blk_close,
diff -rupN 2.6.17-rc6-mm1.agk.moveq/drivers/md/dm-table.c 2.6.17-rc6-mm1.agk.moveq.fastsusp/drivers/md/dm-table.c
--- 2.6.17-rc6-mm1.agk.moveq/drivers/md/dm-table.c	2006-06-23 11:27:10.000000000 -0400
+++ 2.6.17-rc6-mm1.agk.moveq.fastsusp/drivers/md/dm-table.c	2006-06-22 15:23:13.000000000 -0400
@@ -1011,6 +1011,62 @@ struct mapped_device *dm_table_get_md(st
 	return t->md;
 }
 
+void dm_table_withdraw_queued_io(struct dm_table *t, struct bio_list *bl)
+{
+	unsigned int i, j;
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
+unsigned int dm_table_queue_size(struct dm_table *t, int qfreezing)
+{
+	unsigned int size = 0;
+	unsigned int i, j;
+
+	for (i = 0; i < t->num_targets; i++) {
+		struct dm_target *ti = t->targets + i;
+
+		for (j = 0; j < ti->num_queues; j++) {
+			struct dm_queue *q = dm_queue_find(ti->queues, j);
+
+			/*
+			 * For fast suspend in dm_suspend().
+			 * If the queue is non fast-suspendable, the queue
+			 * should be processed during waiting for pending
+			 * I/Os in dm_suspend().
+			 * Therefore, ignore the size of such queues.
+			 */
+			if (qfreezing && !dm_queue_fastsuspendable(q))
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
+	unsigned int i, j;
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
diff -rupN 2.6.17-rc6-mm1.agk.moveq/drivers/md/dm-queue.c 2.6.17-rc6-mm1.agk.moveq.fastsusp/drivers/md/dm-queue.c
--- 2.6.17-rc6-mm1.agk.moveq/drivers/md/dm-queue.c	2006-06-23 11:36:04.000000000 -0400
+++ 2.6.17-rc6-mm1.agk.moveq.fastsusp/drivers/md/dm-queue.c	2006-06-23 09:44:21.000000000 -0400
@@ -11,6 +11,8 @@
 
 struct workqueue_struct *kdmqd;
 
+#define DMQ_FASTSUSPENDABLE	0
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
 
+	if (dm_queue_freezing(q) && dm_queue_fastsuspendable(q))
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
 
+	if (dm_queue_freezing(q) && dm_queue_fastsuspendable(q))
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
 
+int dm_queue_enable_fastsuspend(struct dm_queue *q)
+{
+	set_bit(DMQ_FASTSUSPENDABLE, &q->flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_queue_enable_fastsuspend);
+
+int dm_queue_fastsuspendable(struct dm_queue *q)
+{
+	return test_bit(DMQ_FASTSUSPENDABLE, &q->flags);
+}
+
+int dm_queue_freezing(struct dm_queue *q)
+{
+	struct mapped_device *md = dm_table_get_md(q->ti->table);
+	int r = dm_qfreezing(md);
+
+	dm_put(md);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(dm_queue_freezing);
+
 void dm_queue_process(struct dm_queue *q)
 {
 	unsigned long flags;
@@ -160,9 +196,34 @@ void dm_queue_process(struct dm_queue *q
 	if (!q->size)
 		goto out;
 
+	if (dm_queue_freezing(q) && dm_queue_fastsuspendable(q))
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
diff -rupN 2.6.17-rc6-mm1.agk.moveq/drivers/md/dm-ioctl.c 2.6.17-rc6-mm1.agk.moveq.fastsusp/drivers/md/dm-ioctl.c
--- 2.6.17-rc6-mm1.agk.moveq/drivers/md/dm-ioctl.c	2006-06-23 11:20:20.000000000 -0400
+++ 2.6.17-rc6-mm1.agk.moveq.fastsusp/drivers/md/dm-ioctl.c	2006-06-20 18:31:34.000000000 -0400
@@ -767,6 +767,7 @@ static int do_suspend(struct dm_ioctl *p
 {
 	int r = 0;
 	int do_lockfs = 1;
+	int fastsuspend = 0;
 	struct mapped_device *md;
 
 	md = find_device(param);
@@ -775,9 +776,11 @@ static int do_suspend(struct dm_ioctl *p
 
 	if (param->flags & DM_SKIP_LOCKFS_FLAG)
 		do_lockfs = 0;
+	if (param->flags & DM_FASTSUSPEND_FLAG)
+		fastsuspend = 1;
 
 	if (!dm_suspended(md))
-		r = dm_suspend(md, do_lockfs);
+		r = dm_suspend(md, do_lockfs, fastsuspend);
 
 	if (!r)
 		r = __dev_status(md, param);
@@ -790,6 +793,7 @@ static int do_resume(struct dm_ioctl *pa
 {
 	int r = 0;
 	int do_lockfs = 1;
+	int fastsuspend = 0;
 	struct hash_cell *hc;
 	struct mapped_device *md;
 	struct dm_table *new_map;
@@ -816,8 +820,10 @@ static int do_resume(struct dm_ioctl *pa
 		/* Suspend if it isn't already suspended */
 		if (param->flags & DM_SKIP_LOCKFS_FLAG)
 			do_lockfs = 0;
+		if (param->flags & DM_FASTSUSPEND_FLAG)
+			fastsuspend = 1;
 		if (!dm_suspended(md))
-			dm_suspend(md, do_lockfs);
+			dm_suspend(md, do_lockfs, fastsuspend);
 
 		r = dm_swap_table(md, new_map);
 		if (r) {
diff -rupN 2.6.17-rc6-mm1.agk.moveq/drivers/md/dm.h 2.6.17-rc6-mm1.agk.moveq.fastsusp/drivers/md/dm.h
--- 2.6.17-rc6-mm1.agk.moveq/drivers/md/dm.h	2006-06-23 11:18:54.000000000 -0400
+++ 2.6.17-rc6-mm1.agk.moveq.fastsusp/drivers/md/dm.h	2006-06-22 14:26:57.000000000 -0400
@@ -39,6 +39,7 @@ struct dm_dev {
 };
 
 struct dm_table;
+struct bio_list;
 struct dm_queue;
 
 /*-----------------------------------------------------------------
@@ -56,12 +57,17 @@ void dm_table_resume_targets(struct dm_t
 int dm_table_any_congested(struct dm_table *t, int bdi_bits);
 void dm_table_unplug_all(struct dm_table *t);
 int dm_table_flush_all(struct dm_table *t);
+void dm_table_withdraw_queued_io(struct dm_table *t, struct bio_list *bl);
+unsigned int dm_table_queue_size(struct dm_table *t, int qfreezing);
+void dm_table_process_queue(struct dm_table *t);
 
 /*-----------------------------------------------------------------
  * Queue functions.
  *---------------------------------------------------------------*/
 int dm_queue_init(void);
 void dm_queue_exit(void);
+int dm_queue_fastsuspendable(struct dm_queue *q);
+void dm_queue_withdraw(struct dm_queue *q, struct bio_list *bl);
 
 /*-----------------------------------------------------------------
  * A registry of target types.
@@ -132,5 +138,6 @@ void *dm_vcalloc(unsigned long nmemb, un
 union map_info *dm_get_mapinfo(struct bio *bio);
 int dm_open_count(struct mapped_device *md);
 int dm_lock_for_deletion(struct mapped_device *md);
+struct bio *dm_unmap_bio(struct bio *bio);
 
 #endif
diff -rupN 2.6.17-rc6-mm1.agk.moveq/include/linux/device-mapper.h 2.6.17-rc6-mm1.agk.moveq.fastsusp/include/linux/device-mapper.h
--- 2.6.17-rc6-mm1.agk.moveq/include/linux/device-mapper.h	2006-06-23 11:29:00.000000000 -0400
+++ 2.6.17-rc6-mm1.agk.moveq.fastsusp/include/linux/device-mapper.h	2006-06-23 10:42:08.000000000 -0400
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
+int dm_suspend(struct mapped_device *md, int with_lockfs, int fastsuspend);
 int dm_resume(struct mapped_device *md);
 
 /*
@@ -183,6 +186,7 @@ int dm_wait_event(struct mapped_device *
  */
 struct gendisk *dm_disk(struct mapped_device *md);
 int dm_suspended(struct mapped_device *md);
+int dm_qfreezing(struct mapped_device *md);
 
 /*
  * Geometry functions.
@@ -265,6 +269,11 @@ int dm_queue_setup(struct dm_queue *q, v
 		   struct dm_target *ti);
 
 /*
+ * Optional setups.
+ */
+int dm_queue_enable_fastsuspend(struct dm_queue *q);
+
+/*
  * Free allocated queues.
  */
 void dm_queue_free(struct dm_queue *qs);
@@ -286,6 +295,7 @@ struct bio *dm_queue_get_bios(struct dm_
  */
 unsigned int dm_queue_size(struct dm_queue *q);
 struct dm_target *dm_queue_get_target(struct dm_queue *q);
+int dm_queue_freezing(struct dm_queue *q);
 
 /*
  * Start processing a queue.
diff -rupN 2.6.17-rc6-mm1.agk.moveq/include/linux/dm-ioctl.h 2.6.17-rc6-mm1.agk.moveq.fastsusp/include/linux/dm-ioctl.h
--- 2.6.17-rc6-mm1.agk.moveq/include/linux/dm-ioctl.h	2006-06-23 11:29:25.000000000 -0400
+++ 2.6.17-rc6-mm1.agk.moveq.fastsusp/include/linux/dm-ioctl.h	2006-06-20 18:34:42.000000000 -0400
@@ -323,4 +323,9 @@ typedef char ioctl_struct[308];
  */
 #define DM_SKIP_LOCKFS_FLAG	(1 << 10) /* In */
 
+/*
+ * Set this to suspend without flushing queued ios.
+ */
+#define DM_FASTSUSPEND_FLAG	(1 << 11) /* In */
+
 #endif				/* _LINUX_DM_IOCTL_H */
diff -rupN 2.6.17-rc6-mm1.agk.moveq/drivers/md/dm-bio-list.h 2.6.17-rc6-mm1.agk.moveq.fastsusp/drivers/md/dm-bio-list.h
--- 2.6.17-rc6-mm1.agk.moveq/drivers/md/dm-bio-list.h	2006-06-23 11:13:57.000000000 -0400
+++ 2.6.17-rc6-mm1.agk.moveq.fastsusp/drivers/md/dm-bio-list.h	2006-06-20 10:40:22.000000000 -0400
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
