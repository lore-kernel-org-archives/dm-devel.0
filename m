From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/5] dm-multipath: push back requests instead of
	queueing
Date: Fri, 31 Jan 2014 10:10:41 +0100
Message-ID: <1391159444-17987-3-git-send-email-hare@suse.de>
References: <1391159444-17987-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1391159444-17987-1-git-send-email-hare@suse.de>
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
 drivers/md/dm-mpath.c         | 115 ++++++++++++++----------------------------
 drivers/md/dm.c               |  13 +++++
 include/linux/device-mapper.h |   1 +
 3 files changed, 52 insertions(+), 77 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index d45290a..39fd166 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -93,9 +93,7 @@ struct multipath {
 	unsigned pg_init_count;		/* Number of times pg_init called */
 	unsigned pg_init_delay_msecs;	/* Number of msecs before pg_init retry */
 
-	unsigned queue_size;
 	struct work_struct process_queued_ios;
-	struct list_head queued_ios;
 
 	struct work_struct trigger_event;
 
@@ -124,6 +122,7 @@ static struct workqueue_struct *kmultipathd, *kmpath_handlerd;
 static void process_queued_ios(struct work_struct *work);
 static void trigger_event(struct work_struct *work);
 static void activate_path(struct work_struct *work);
+static int __pgpath_busy(struct pgpath *pgpath);
 
 
 /*-----------------------------------------------
@@ -195,7 +194,6 @@ static struct multipath *alloc_multipath(struct dm_target *ti)
 	m = kzalloc(sizeof(*m), GFP_KERNEL);
 	if (m) {
 		INIT_LIST_HEAD(&m->priority_groups);
-		INIT_LIST_HEAD(&m->queued_ios);
 		spin_lock_init(&m->lock);
 		m->queue_io = 1;
 		m->pg_init_delay_msecs = DM_PG_INIT_DELAY_DEFAULT;
@@ -368,12 +366,15 @@ failed:
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
@@ -391,37 +392,30 @@ static int map_io(struct multipath *m, struct request *clone,
 
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
 
@@ -443,7 +437,7 @@ static int queue_if_no_path(struct multipath *m, unsigned queue_if_no_path,
 	else
 		m->saved_queue_if_no_path = queue_if_no_path;
 	m->queue_if_no_path = queue_if_no_path;
-	if (!m->queue_if_no_path && m->queue_size)
+	if (!m->queue_if_no_path)
 		queue_work(kmultipathd, &m->process_queued_ios);
 
 	spin_unlock_irqrestore(&m->lock, flags);
@@ -451,40 +445,6 @@ static int queue_if_no_path(struct multipath *m, unsigned queue_if_no_path,
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
 static void process_queued_ios(struct work_struct *work)
 {
 	struct multipath *m =
@@ -510,7 +470,7 @@ static void process_queued_ios(struct work_struct *work)
 
 	spin_unlock_irqrestore(&m->lock, flags);
 	if (!must_queue)
-		dispatch_queued_ios(m);
+		dm_table_run_queue(m->ti->table);
 }
 
 /*
@@ -988,7 +948,7 @@ static int multipath_map(struct dm_target *ti, struct request *clone,
 		return DM_MAPIO_REQUEUE;
 
 	clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
-	r = map_io(m, clone, map_context, 0);
+	r = map_io(m, clone, map_context);
 	if (r < 0 || r == DM_MAPIO_REQUEUE)
 		clear_mapinfo(m, map_context);
 
@@ -1057,7 +1017,7 @@ static int reinstate_path(struct pgpath *pgpath)
 
 	pgpath->is_active = 1;
 
-	if (!m->nr_valid_paths++ && m->queue_size) {
+	if (!m->nr_valid_paths++) {
 		m->current_pgpath = NULL;
 		queue_work(kmultipathd, &m->process_queued_ios);
 	} else if (m->hw_handler_name && (m->current_pg == pgpath->pg)) {
@@ -1436,7 +1396,8 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 
 	/* Features */
 	if (type == STATUSTYPE_INFO)
-		DMEMIT("2 %u %u ", m->queue_size, m->pg_init_count);
+		DMEMIT("2 %u %u ", (m->queue_io << 1) + m->queue_if_no_path,
+		       m->pg_init_count);
 	else {
 		DMEMIT("%u ", m->queue_if_no_path +
 			      (m->pg_init_retries > 0) * 2 +
@@ -1684,7 +1645,7 @@ static int multipath_busy(struct dm_target *ti)
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
