From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/2] dm-multipath: push back requests instead of
	queueing
Date: Fri, 17 Jan 2014 11:42:07 +0100
Message-ID: <1389955328-107148-2-git-send-email-hare@suse.de>
References: <1389955328-107148-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1389955328-107148-1-git-send-email-hare@suse.de>
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
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

There is no reason why multipath needs to queue requests
internally for queue_if_no_path or pg_init; we should
rather push them back onto the request queue.

And while we're at it we can simplify the conditional
statement in map_io() to make it easier to read.

Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-mpath.c         | 167 ++++++++++++++----------------------------
 drivers/md/dm.c               |  13 ++++
 include/linux/device-mapper.h |   1 +
 3 files changed, 67 insertions(+), 114 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 6eb9dc9..71c6f2c 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -93,10 +93,6 @@ struct multipath {
 	unsigned pg_init_count;		/* Number of times pg_init called */
 	unsigned pg_init_delay_msecs;	/* Number of msecs before pg_init retry */
 
-	unsigned queue_size;
-	struct work_struct process_queued_ios;
-	struct list_head queued_ios;
-
 	struct work_struct trigger_event;
 
 	/*
@@ -121,9 +117,9 @@ typedef int (*action_fn) (struct pgpath *pgpath);
 static struct kmem_cache *_mpio_cache;
 
 static struct workqueue_struct *kmultipathd, *kmpath_handlerd;
-static void process_queued_ios(struct work_struct *work);
 static void trigger_event(struct work_struct *work);
 static void activate_path(struct work_struct *work);
+static int __pgpath_busy(struct pgpath *pgpath);
 
 
 /*-----------------------------------------------
@@ -195,11 +191,9 @@ static struct multipath *alloc_multipath(struct dm_target *ti)
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
@@ -261,6 +255,9 @@ static void __pg_init_all_paths(struct multipath *m)
 	struct pgpath *pgpath;
 	unsigned long pg_init_delay = 0;
 
+	if (m->pg_init_in_progress || m->pg_init_disabled)
+		return;
+
 	m->pg_init_count++;
 	m->pg_init_required = 0;
 	if (m->pg_init_delay_retry)
@@ -365,12 +362,15 @@ failed:
  */
 static int __must_push_back(struct multipath *m)
 {
-	return (m->queue_if_no_path != m->saved_queue_if_no_path &&
-		dm_noflush_suspending(m->ti));
+	return (m->queue_if_no_path ||
+		(m->queue_if_no_path != m->saved_queue_if_no_path &&
+		 dm_noflush_suspending(m->ti)));
 }
 
+#define pg_ready(m) (!(m)->queue_io && !(m)->pg_init_required)
+
 static int map_io(struct multipath *m, struct request *clone,
-		  union map_info *map_context, unsigned was_queued)
+		  union map_info *map_context)
 {
 	int r = DM_MAPIO_REMAPPED;
 	size_t nr_bytes = blk_rq_bytes(clone);
@@ -388,37 +388,30 @@ static int map_io(struct multipath *m, struct request *clone,
 
 	pgpath = m->current_pgpath;
 
-	if (was_queued)
-		m->queue_size--;
-
-	if (m->pg_init_required) {
-		if (!m->pg_init_in_progress)
-			queue_work(kmultipathd, &m->process_queued_ios);
-		r = DM_MAPIO_REQUEUE;
-	} else if ((pgpath && m->queue_io) ||
-		   (!pgpath && m->queue_if_no_path)) {
-		/* Queue for the daemon to resubmit */
-		list_add_tail(&clone->queuelist, &m->queued_ios);
-		m->queue_size++;
-		if (!m->queue_io)
-			queue_work(kmultipathd, &m->process_queued_ios);
-		pgpath = NULL;
-		r = DM_MAPIO_SUBMITTED;
-	} else if (pgpath) {
-		bdev = pgpath->path.dev->bdev;
-		clone->q = bdev_get_queue(bdev);
-		clone->rq_disk = bdev->bd_disk;
-	} else if (__must_push_back(m))
-		r = DM_MAPIO_REQUEUE;
-	else
-		r = -EIO;	/* Failed */
-
-	mpio->pgpath = pgpath;
-	mpio->nr_bytes = nr_bytes;
-
-	if (r == DM_MAPIO_REMAPPED && pgpath->pg->ps.type->start_io)
-		pgpath->pg->ps.type->start_io(&pgpath->pg->ps, &pgpath->path,
-					      nr_bytes);
+	if (pgpath) {
+		if (__pgpath_busy(pgpath))
+			r = DM_MAPIO_REQUEUE;
+		else if (pg_ready(m)) {
+			bdev = pgpath->path.dev->bdev;
+			clone->q = bdev_get_queue(bdev);
+			clone->rq_disk = bdev->bd_disk;
+			mpio->pgpath = pgpath;
+			mpio->nr_bytes = nr_bytes;
+			if (pgpath->pg->ps.type->start_io)
+				pgpath->pg->ps.type->start_io(&pgpath->pg->ps,
+							      &pgpath->path,
+							      nr_bytes);
+		} else {
+			__pg_init_all_paths(m);
+			r = DM_MAPIO_REQUEUE;
+		}
+	} else {
+		/* No path */
+		if (__must_push_back(m))
+			r = DM_MAPIO_REQUEUE;
+		else
+			r = -EIO;	/* Failed */
+	}
 
 	spin_unlock_irqrestore(&m->lock, flags);
 
@@ -440,76 +433,14 @@ static int queue_if_no_path(struct multipath *m, unsigned queue_if_no_path,
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
-	if (m->pg_init_required && !m->pg_init_in_progress && pgpath &&
-	    !m->pg_init_disabled)
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
@@ -985,7 +916,7 @@ static int multipath_map(struct dm_target *ti, struct request *clone,
 		return DM_MAPIO_REQUEUE;
 
 	clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
-	r = map_io(m, clone, map_context, 0);
+	r = map_io(m, clone, map_context);
 	if (r < 0 || r == DM_MAPIO_REQUEUE)
 		clear_mapinfo(m, map_context);
 
@@ -1054,9 +985,8 @@ static int reinstate_path(struct pgpath *pgpath)
 
 	pgpath->is_active = 1;
 
-	if (!m->nr_valid_paths++ && m->queue_size) {
+	if (!m->nr_valid_paths++) {
 		m->current_pgpath = NULL;
-		queue_work(kmultipathd, &m->process_queued_ios);
 	} else if (m->hw_handler_name && (m->current_pg == pgpath->pg)) {
 		if (queue_work(kmpath_handlerd, &pgpath->activate_path.work))
 			m->pg_init_in_progress++;
@@ -1069,6 +999,8 @@ static int reinstate_path(struct pgpath *pgpath)
 
 out:
 	spin_unlock_irqrestore(&m->lock, flags);
+	if (!r)
+		dm_table_run_queue(m->ti->table);
 
 	return r;
 }
@@ -1256,7 +1188,8 @@ static void pg_init_done(void *data, int errors)
 		m->queue_io = 0;
 
 	m->pg_init_delay_retry = delay_retry;
-	queue_work(kmultipathd, &m->process_queued_ios);
+	if (!m->queue_io)
+		dm_table_run_queue(m->ti->table);
 
 	/*
 	 * Wake up any thread waiting to suspend.
@@ -1433,7 +1366,8 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 
 	/* Features */
 	if (type == STATUSTYPE_INFO)
-		DMEMIT("2 %u %u ", m->queue_size, m->pg_init_count);
+		DMEMIT("2 %u %u ", (m->queue_io << 1) + m->queue_if_no_path,
+		       m->pg_init_count);
 	else {
 		DMEMIT("%u ", m->queue_if_no_path +
 			      (m->pg_init_retries > 0) * 2 +
@@ -1606,7 +1540,7 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
 
 	spin_lock_irqsave(&m->lock, flags);
 
-	if (!m->current_pgpath)
+	if (!m->current_pgpath || !m->queue_io)
 		__choose_pgpath(m, 0);
 
 	pgpath = m->current_pgpath;
@@ -1629,8 +1563,13 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
 	if (!r && ti->len != i_size_read(bdev->bd_inode) >> SECTOR_SHIFT)
 		r = scsi_verify_blk_ioctl(NULL, cmd);
 
-	if (r == -ENOTCONN && !fatal_signal_pending(current))
-		queue_work(kmultipathd, &m->process_queued_ios);
+	if (r == -ENOTCONN && !fatal_signal_pending(current)) {
+		spin_lock_irqsave(&m->lock, flags);
+		if (m->current_pgpath && m->pg_init_required)
+			__pg_init_all_paths(m);
+		spin_unlock_irqrestore(&m->lock, flags);
+		dm_table_run_queue(m->ti->table);
+	}
 
 	return r ? : __blkdev_driver_ioctl(bdev, mode, cmd, arg);
 }
@@ -1681,7 +1620,7 @@ static int multipath_busy(struct dm_target *ti)
 	spin_lock_irqsave(&m->lock, flags);
 
 	/* pg_init in progress, requeue until done */
-	if (m->pg_init_in_progress) {
+	if (!pg_ready(m)) {
 		busy = 1;
 		goto out;
 	}
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 0704c52..291491b 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1912,6 +1912,19 @@ static int dm_any_congested(void *congested_data, int bdi_bits)
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
-- 
1.7.12.4
