From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/5] dm-multipath: remove process_queued_ios()
Date: Fri, 31 Jan 2014 10:10:42 +0100
Message-ID: <1391159444-17987-4-git-send-email-hare@suse.de>
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

Doesn't serve any real purpose anymore; dm_table_run_queue()
will already move things to a workqueue, so we don't need
to do it ourselves.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-mpath.c | 67 ++++++++++++++++++++-------------------------------
 1 file changed, 26 insertions(+), 41 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 39fd166..7122ac3 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -93,8 +93,6 @@ struct multipath {
 	unsigned pg_init_count;		/* Number of times pg_init called */
 	unsigned pg_init_delay_msecs;	/* Number of msecs before pg_init retry */
 
-	struct work_struct process_queued_ios;
-
 	struct work_struct trigger_event;
 
 	/*
@@ -119,7 +117,6 @@ typedef int (*action_fn) (struct pgpath *pgpath);
 static struct kmem_cache *_mpio_cache;
 
 static struct workqueue_struct *kmultipathd, *kmpath_handlerd;
-static void process_queued_ios(struct work_struct *work);
 static void trigger_event(struct work_struct *work);
 static void activate_path(struct work_struct *work);
 static int __pgpath_busy(struct pgpath *pgpath);
@@ -197,7 +194,6 @@ static struct multipath *alloc_multipath(struct dm_target *ti)
 		spin_lock_init(&m->lock);
 		m->queue_io = 1;
 		m->pg_init_delay_msecs = DM_PG_INIT_DELAY_DEFAULT;
-		INIT_WORK(&m->process_queued_ios, process_queued_ios);
 		INIT_WORK(&m->trigger_event, trigger_event);
 		init_waitqueue_head(&m->pg_init_wait);
 		mutex_init(&m->work_mutex);
@@ -438,41 +434,13 @@ static int queue_if_no_path(struct multipath *m, unsigned queue_if_no_path,
 		m->saved_queue_if_no_path = queue_if_no_path;
 	m->queue_if_no_path = queue_if_no_path;
 	if (!m->queue_if_no_path)
-		queue_work(kmultipathd, &m->process_queued_ios);
+		dm_table_run_queue(m->ti->table);
 
 	spin_unlock_irqrestore(&m->lock, flags);
 
 	return 0;
 }
 
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
-		dm_table_run_queue(m->ti->table);
-}
-
 /*
  * An event is triggered whenever a path is taken out of use.
  * Includes path failure and PG bypass.
@@ -1019,7 +987,7 @@ static int reinstate_path(struct pgpath *pgpath)
 
 	if (!m->nr_valid_paths++) {
 		m->current_pgpath = NULL;
-		queue_work(kmultipathd, &m->process_queued_ios);
+		dm_table_run_queue(m->ti->table);
 	} else if (m->hw_handler_name && (m->current_pg == pgpath->pg)) {
 		if (queue_work(kmpath_handlerd, &pgpath->activate_path.work))
 			m->pg_init_in_progress++;
@@ -1158,7 +1126,7 @@ static void pg_init_done(void *data, int errors)
 	struct priority_group *pg = pgpath->pg;
 	struct multipath *m = pg->m;
 	unsigned long flags;
-	unsigned delay_retry = 0;
+	unsigned long pg_init_delay = 0;
 
 	/* device or driver problems */
 	switch (errors) {
@@ -1185,7 +1153,7 @@ static void pg_init_done(void *data, int errors)
 		break;
 	case SCSI_DH_RETRY:
 		/* Wait before retrying. */
-		delay_retry = 1;
+		pg_init_delay = msecs_to_jiffies(m->pg_init_delay_msecs);
 	case SCSI_DH_IMM_RETRY:
 	case SCSI_DH_RES_TEMP_UNAVAIL:
 		if (pg_init_limit_reached(m, pgpath))
@@ -1217,9 +1185,21 @@ static void pg_init_done(void *data, int errors)
 
 	if (!m->pg_init_required)
 		m->queue_io = 0;
-
-	m->pg_init_delay_retry = delay_retry;
-	queue_work(kmultipathd, &m->process_queued_ios);
+	else {
+		if (!pg_init_delay) {
+			m->pg_init_delay_retry = 0;
+			/*
+			 * Add a small delay to move the
+			 * activation to a workqueue
+			 */
+			pg_init_delay = HZ / 50;
+		} else
+			m->pg_init_delay_retry = 1;
+		if (queue_delayed_work(kmpath_handlerd, &pgpath->activate_path,
+				       pg_init_delay))
+			m->pg_init_in_progress++;
+		goto out;
+	}
 
 	/*
 	 * Wake up any thread waiting to suspend.
@@ -1593,8 +1573,13 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
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
-- 
1.7.12.4
