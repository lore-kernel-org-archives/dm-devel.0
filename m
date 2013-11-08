From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] dm-mpath: push back requests instead of queueing
Date: Fri,  8 Nov 2013 10:02:19 +0100
Message-ID: <1383901339-81536-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com, Frank Mayhar <fmayhar@google.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

There is no reason why multipath needs to queue requests
internally for queue_if_no_path or pg_init; we should
rather push them back onto the request queue.


This patch removes the internal queueing mechanism from dm-multipath.
In doing so we can also remove the ->busy check as a requeue is identical
to ->busy returning 'true' from the callers perspective. This simplifies
the code by quite a lot.

Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Frank Mayhar <fmayhar@google.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index de570a5..acf7d87 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -92,10 +92,6 @@ struct multipath {
 	unsigned pg_init_count;		/* Number of times pg_init called */
 	unsigned pg_init_delay_msecs;	/* Number of msecs before pg_init retry */
 
-	unsigned queue_size;
-	struct work_struct process_queued_ios;
-	struct list_head queued_ios;
-
 	struct work_struct trigger_event;
 
 	/*
@@ -120,7 +116,6 @@ typedef int (*action_fn) (struct pgpath *pgpath);
 static struct kmem_cache *_mpio_cache;
 
 static struct workqueue_struct *kmultipathd, *kmpath_handlerd;
-static void process_queued_ios(struct work_struct *work);
 static void trigger_event(struct work_struct *work);
 static void activate_path(struct work_struct *work);
 
@@ -194,11 +189,9 @@ static struct multipath *alloc_multipath(struct dm_target *ti)
 	m = kzalloc(sizeof(*m), GFP_KERNEL);
 	if (m) {
 		INIT_LIST_HEAD(&m->priority_groups);
-		INIT_LIST_HEAD(&m->queued_ios);
 		spin_lock_init(&m->lock);
 		m->queue_io = 1;
 		m->pg_init_delay_msecs = DM_PG_INIT_DELAY_DEFAULT;
-		INIT_WORK(&m->process_queued_ios, process_queued_ios);
 		INIT_WORK(&m->trigger_event, trigger_event);
 		init_waitqueue_head(&m->pg_init_wait);
 		mutex_init(&m->work_mutex);
@@ -369,7 +362,7 @@ static int __must_push_back(struct multipath *m)
 }
 
 static int map_io(struct multipath *m, struct request *clone,
-		  union map_info *map_context, unsigned was_queued)
+		  union map_info *map_context)
 {
 	int r = DM_MAPIO_REMAPPED;
 	size_t nr_bytes = blk_rq_bytes(clone);
@@ -385,21 +378,15 @@ static int map_io(struct multipath *m, struct request *clone,
 	    (!m->queue_io && (m->repeat_count && --m->repeat_count == 0)))
 		__choose_pgpath(m, nr_bytes);
 
-	pgpath = m->current_pgpath;
-
-	if (was_queued)
-		m->queue_size--;
+	if (m->current_pgpath &&
+	    m->pg_init_required && !m->pg_init_in_progress)
+		__pg_init_all_paths(m);
 
+	pgpath = m->current_pgpath;
 	if ((pgpath && m->queue_io) ||
 	    (!pgpath && m->queue_if_no_path)) {
-		/* Queue for the daemon to resubmit */
-		list_add_tail(&clone->queuelist, &m->queued_ios);
-		m->queue_size++;
-		if ((m->pg_init_required && !m->pg_init_in_progress) ||
-		    !m->queue_io)
-			queue_work(kmultipathd, &m->process_queued_ios);
 		pgpath = NULL;
-		r = DM_MAPIO_SUBMITTED;
+		r = DM_MAPIO_REQUEUE;
 	} else if (pgpath) {
 		bdev = pgpath->path.dev->bdev;
 		clone->q = bdev_get_queue(bdev);
@@ -436,75 +423,14 @@ static int queue_if_no_path(struct multipath *m, unsigned queue_if_no_path,
 	else
 		m->saved_queue_if_no_path = queue_if_no_path;
 	m->queue_if_no_path = queue_if_no_path;
-	if (!m->queue_if_no_path && m->queue_size)
-		queue_work(kmultipathd, &m->process_queued_ios);
+	if (!m->queue_if_no_path)
+		dm_table_run_queue(m->ti->table);
 
 	spin_unlock_irqrestore(&m->lock, flags);
 
 	return 0;
 }
 
-/*-----------------------------------------------------------------
- * The multipath daemon is responsible for resubmitting queued ios.
- *---------------------------------------------------------------*/
-
-static void dispatch_queued_ios(struct multipath *m)
-{
-	int r;
-	unsigned long flags;
-	union map_info *info;
-	struct request *clone, *n;
-	LIST_HEAD(cl);
-
-	spin_lock_irqsave(&m->lock, flags);
-	list_splice_init(&m->queued_ios, &cl);
-	spin_unlock_irqrestore(&m->lock, flags);
-
-	list_for_each_entry_safe(clone, n, &cl, queuelist) {
-		list_del_init(&clone->queuelist);
-
-		info = dm_get_rq_mapinfo(clone);
-
-		r = map_io(m, clone, info, 1);
-		if (r < 0) {
-			clear_mapinfo(m, info);
-			dm_kill_unmapped_request(clone, r);
-		} else if (r == DM_MAPIO_REMAPPED)
-			dm_dispatch_request(clone);
-		else if (r == DM_MAPIO_REQUEUE) {
-			clear_mapinfo(m, info);
-			dm_requeue_unmapped_request(clone);
-		}
-	}
-}
-
-static void process_queued_ios(struct work_struct *work)
-{
-	struct multipath *m =
-		container_of(work, struct multipath, process_queued_ios);
-	struct pgpath *pgpath = NULL;
-	unsigned must_queue = 1;
-	unsigned long flags;
-
-	spin_lock_irqsave(&m->lock, flags);
-
-	if (!m->current_pgpath)
-		__choose_pgpath(m, 0);
-
-	pgpath = m->current_pgpath;
-
-	if ((pgpath && !m->queue_io) ||
-	    (!pgpath && !m->queue_if_no_path))
-		must_queue = 0;
-
-	if (m->pg_init_required && !m->pg_init_in_progress && pgpath)
-		__pg_init_all_paths(m);
-
-	spin_unlock_irqrestore(&m->lock, flags);
-	if (!must_queue)
-		dispatch_queued_ios(m);
-}
-
 /*
  * An event is triggered whenever a path is taken out of use.
  * Includes path failure and PG bypass.
@@ -970,7 +896,7 @@ static int multipath_map(struct dm_target *ti, struct request *clone,
 		return DM_MAPIO_REQUEUE;
 
 	clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
-	r = map_io(m, clone, map_context, 0);
+	r = map_io(m, clone, map_context);
 	if (r < 0 || r == DM_MAPIO_REQUEUE)
 		clear_mapinfo(m, map_context);
 
@@ -1039,9 +965,8 @@ static int reinstate_path(struct pgpath *pgpath)
 
 	pgpath->is_active = 1;
 
-	if (!m->nr_valid_paths++ && m->queue_size) {
+	if (!m->nr_valid_paths++) {
 		m->current_pgpath = NULL;
-		queue_work(kmultipathd, &m->process_queued_ios);
 	} else if (m->hw_handler_name && (m->current_pg == pgpath->pg)) {
 		if (queue_work(kmpath_handlerd, &pgpath->activate_path.work))
 			m->pg_init_in_progress++;
@@ -1054,6 +979,8 @@ static int reinstate_path(struct pgpath *pgpath)
 
 out:
 	spin_unlock_irqrestore(&m->lock, flags);
+	if (!r)
+		dm_table_run_queue(m->ti->table);
 
 	return r;
 }
@@ -1241,7 +1168,8 @@ static void pg_init_done(void *data, int errors)
 		m->queue_io = 0;
 
 	m->pg_init_delay_retry = delay_retry;
-	queue_work(kmultipathd, &m->process_queued_ios);
+	if (!m->queue_io)
+		dm_table_run_queue(m->ti->table);
 
 	/*
 	 * Wake up any thread waiting to suspend.
@@ -1418,7 +1346,8 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 
 	/* Features */
 	if (type == STATUSTYPE_INFO)
-		DMEMIT("2 %u %u ", m->queue_size, m->pg_init_count);
+		DMEMIT("2 %u %u ", (m->queue_io << 1) + m->queue_if_no_path,
+		       m->pg_init_count);
 	else {
 		DMEMIT("%u ", m->queue_if_no_path +
 			      (m->pg_init_retries > 0) * 2 +
@@ -1591,7 +1520,7 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
 
 	spin_lock_irqsave(&m->lock, flags);
 
-	if (!m->current_pgpath)
+	if (!m->current_pgpath || !m->queue_io)
 		__choose_pgpath(m, 0);
 
 	pgpath = m->current_pgpath;
@@ -1614,8 +1543,14 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
 	if (!r && ti->len != i_size_read(bdev->bd_inode) >> SECTOR_SHIFT)
 		r = scsi_verify_blk_ioctl(NULL, cmd);
 
-	if (r == -ENOTCONN && !fatal_signal_pending(current))
-		queue_work(kmultipathd, &m->process_queued_ios);
+	if (r == -ENOTCONN && !fatal_signal_pending(current)) {
+		spin_lock_irqsave(&m->lock, flags);
+		if (m->current_pgpath &&
+		    m->pg_init_required && !m->pg_init_in_progress)
+			__pg_init_all_paths(m);
+		spin_unlock_irqrestore(&m->lock, flags);
+		dm_table_run_queue(m->ti->table);
+	}
 
 	return r ? : __blkdev_driver_ioctl(bdev, mode, cmd, arg);
 }
@@ -1640,75 +1575,6 @@ out:
 	return ret;
 }
 
-static int __pgpath_busy(struct pgpath *pgpath)
-{
-	struct request_queue *q = bdev_get_queue(pgpath->path.dev->bdev);
-
-	return dm_underlying_device_busy(q);
-}
-
-/*
- * We return "busy", only when we can map I/Os but underlying devices
- * are busy (so even if we map I/Os now, the I/Os will wait on
- * the underlying queue).
- * In other words, if we want to kill I/Os or queue them inside us
- * due to map unavailability, we don't return "busy".  Otherwise,
- * dm core won't give us the I/Os and we can't do what we want.
- */
-static int multipath_busy(struct dm_target *ti)
-{
-	int busy = 0, has_active = 0;
-	struct multipath *m = ti->private;
-	struct priority_group *pg;
-	struct pgpath *pgpath;
-	unsigned long flags;
-
-	spin_lock_irqsave(&m->lock, flags);
-
-	/* Guess which priority_group will be used at next mapping time */
-	if (unlikely(!m->current_pgpath && m->next_pg))
-		pg = m->next_pg;
-	else if (likely(m->current_pg))
-		pg = m->current_pg;
-	else
-		/*
-		 * We don't know which pg will be used at next mapping time.
-		 * We don't call __choose_pgpath() here to avoid to trigger
-		 * pg_init just by busy checking.
-		 * So we don't know whether underlying devices we will be using
-		 * at next mapping time are busy or not. Just try mapping.
-		 */
-		goto out;
-
-	/*
-	 * If there is one non-busy active path at least, the path selector
-	 * will be able to select it. So we consider such a pg as not busy.
-	 */
-	busy = 1;
-	list_for_each_entry(pgpath, &pg->pgpaths, list)
-		if (pgpath->is_active) {
-			has_active = 1;
-
-			if (!__pgpath_busy(pgpath)) {
-				busy = 0;
-				break;
-			}
-		}
-
-	if (!has_active)
-		/*
-		 * No active path in this pg, so this pg won't be used and
-		 * the current_pg will be changed at next mapping time.
-		 * We need to try mapping to determine it.
-		 */
-		busy = 0;
-
-out:
-	spin_unlock_irqrestore(&m->lock, flags);
-
-	return busy;
-}
-
 /*-----------------------------------------------------------------
  * Module setup
  *---------------------------------------------------------------*/
@@ -1727,7 +1593,6 @@ static struct target_type multipath_target = {
 	.message = multipath_message,
 	.ioctl  = multipath_ioctl,
 	.iterate_devices = multipath_iterate_devices,
-	.busy = multipath_busy,
 };
 
 static int __init dm_multipath_init(void)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b3e26c7..20a19bd 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1876,6 +1876,19 @@ static int dm_any_congested(void *congested_data, int bdi_bits)
 	return r;
 }
 
+void dm_table_run_queue(struct dm_table *t)
+{
+	struct mapped_device *md = dm_table_get_md(t);
+	unsigned long flags;
+
+	if (md->queue) {
+		spin_lock_irqsave(md->queue->queue_lock, flags);
+		blk_run_queue_async(md->queue);
+		spin_unlock_irqrestore(md->queue->queue_lock, flags);
+	}
+}
+EXPORT_SYMBOL_GPL(dm_table_run_queue);
+
 /*-----------------------------------------------------------------
  * An IDR is used to keep track of allocated minor numbers.
  *---------------------------------------------------------------*/
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index ed419c6..a33653f 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -604,5 +604,6 @@ void dm_dispatch_request(struct request *rq);
 void dm_requeue_unmapped_request(struct request *rq);
 void dm_kill_unmapped_request(struct request *rq, int error);
 int dm_underlying_device_busy(struct request_queue *q);
+void dm_table_run_queue(struct dm_table *t);
 
 #endif	/* _LINUX_DEVICE_MAPPER_H */
