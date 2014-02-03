From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/6] dm-multipath: remove process_queued_ios()
Date: Mon,  3 Feb 2014 09:18:11 +0100
Message-ID: <1391415493-102943-5-git-send-email-hare@suse.de>
References: <1391415493-102943-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1391415493-102943-1-git-send-email-hare@suse.de>
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
We only need to take care to add a small delay when calling
__pg_init_all_paths() to move processing off to a workqueue;
pg_init_done() is run from an interrupt context and needs to
complete as fast as possible.

Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-mpath.c | 59 +++++++++++++++------------------------------------
 1 file changed, 17 insertions(+), 42 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 5373ca9..b11e3b3 100644
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
@@ -254,10 +250,10 @@ static void clear_mapinfo(struct multipath *m, union map_info *info)
  * Path selection
  *-----------------------------------------------*/
 
-static void __pg_init_all_paths(struct multipath *m)
+static void __pg_init_all_paths(struct multipath *m, unsigned long min_delay)
 {
 	struct pgpath *pgpath;
-	unsigned long pg_init_delay = 0;
+	unsigned long pg_init_delay = min_delay;
 
 	if (m->pg_init_in_progress || m->pg_init_disabled)
 		return;
@@ -406,7 +402,7 @@ static int map_io(struct multipath *m, struct request *clone,
 							      &pgpath->path,
 							      nr_bytes);
 		} else {
-			__pg_init_all_paths(m);
+			__pg_init_all_paths(m, 0);
 			r = DM_MAPIO_REQUEUE;
 		}
 	} else {
@@ -438,41 +434,13 @@ static int queue_if_no_path(struct multipath *m, unsigned queue_if_no_path,
 		m->saved_queue_if_no_path = queue_if_no_path;
 	m->queue_if_no_path = queue_if_no_path;
 	if (!m->queue_if_no_path)
-		queue_work(kmultipathd, &m->process_queued_ios);
+		dm_table_run_md_queue_async(m->ti->table);
 
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
-		dm_table_run_md_queue_async(m->ti->table);
-}
-
 /*
  * An event is triggered whenever a path is taken out of use.
  * Includes path failure and PG bypass.
@@ -1019,7 +987,7 @@ static int reinstate_path(struct pgpath *pgpath)
 
 	if (!m->nr_valid_paths++) {
 		m->current_pgpath = NULL;
-		queue_work(kmultipathd, &m->process_queued_ios);
+		dm_table_run_md_queue_async(m->ti->table);
 	} else if (m->hw_handler_name && (m->current_pg == pgpath->pg)) {
 		if (queue_work(kmpath_handlerd, &pgpath->activate_path.work))
 			m->pg_init_in_progress++;
@@ -1217,9 +1185,11 @@ static void pg_init_done(void *data, int errors)
 
 	if (!m->pg_init_required)
 		m->queue_io = 0;
-
-	m->pg_init_delay_retry = delay_retry;
-	queue_work(kmultipathd, &m->process_queued_ios);
+	else {
+		m->pg_init_delay_retry = delay_retry;
+		__pg_init_all_paths(m, 50/HZ);
+		goto out;
+	}
 
 	/*
 	 * Wake up any thread waiting to suspend.
@@ -1593,8 +1563,13 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
 	if (!r && ti->len != i_size_read(bdev->bd_inode) >> SECTOR_SHIFT)
 		r = scsi_verify_blk_ioctl(NULL, cmd);
 
-	if (r == -ENOTCONN && !fatal_signal_pending(current))
-		queue_work(kmultipathd, &m->process_queued_ios);
+	if (r == -ENOTCONN && !fatal_signal_pending(current)) {
+		spin_lock_irqsave(&m->lock, flags);
+		if (m->current_pgpath && m->pg_init_required)
+			__pg_init_all_paths(m, 0);
+		spin_unlock_irqrestore(&m->lock, flags);
+		dm_table_run_md_queue_async(m->ti->table);
+	}
 
 	return r ? : __blkdev_driver_ioctl(bdev, mode, cmd, arg);
 }
-- 
1.7.12.4
