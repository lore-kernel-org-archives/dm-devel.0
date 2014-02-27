From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/8] dm mpath: remove process_queued_ios()
Date: Thu, 27 Feb 2014 08:30:25 +0100
Message-ID: <1393486229-72034-5-git-send-email-hare@suse.de>
References: <1393486229-72034-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1393486229-72034-1-git-send-email-hare@suse.de>
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

process_queued_ios() has served 3 functions:
  1) select pg and pgpath if none is selected
  2) start pg_init if requested
  3) dispatch queued IOs when pg is ready

Basically, a call to queue_work(process_queued_ios) can be replaced by
dm_table_run_md_queue_async(), which runs request queue and ends up
calling map_io(), which does 1), 2) and 3).

Exception is when !pg_ready() (which means either pg_init is running or
requested), then multipath_busy() prevents map_io() being called from
request_fn.

If pg_init is running, it should be ok as long as pg_init_done() does
the right thing when pg_init is completed, I.e.: restart pg_init if
!pg_ready() or call dm_table_run_md_queue_async() to kick map_io().

If pg_init is requested, we have to make sure the request is detected
and pg_init will be started.  pg_init is requested in 3 places:
  a) __choose_pgpath() in map_io()
  b) __choose_pgpath() in multipath_ioctl()
  c) pg_init retry in pg_init_done()
a) is ok because map_io() calls __pg_init_all_paths(), which does 2).
b) needs a call to __pg_init_all_paths(), which does 2).
c) needs a call to __pg_init_all_paths(), which does 2).

So this patch removes process_queued_ios() and ensures that
__pg_init_all_paths() is called at the appropriate locations.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c | 66 ++++++++++++++++++++-------------------------------
 1 file changed, 26 insertions(+), 40 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 1c6ca5c..7549b78 100644
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
@@ -254,16 +250,21 @@ static void clear_mapinfo(struct multipath *m, union map_info *info)
  * Path selection
  *-----------------------------------------------*/
 
-static void __pg_init_all_paths(struct multipath *m)
+static int __pg_init_all_paths(struct multipath *m)
 {
 	struct pgpath *pgpath;
 	unsigned long pg_init_delay = 0;
 
 	if (m->pg_init_in_progress || m->pg_init_disabled)
-		return;
+		return 0;
 
 	m->pg_init_count++;
 	m->pg_init_required = 0;
+
+	/* Check here to reset pg_init_required */
+	if (!m->current_pg)
+		return 0;
+
 	if (m->pg_init_delay_retry)
 		pg_init_delay = msecs_to_jiffies(m->pg_init_delay_msecs != DM_PG_INIT_DELAY_DEFAULT ?
 						 m->pg_init_delay_msecs : DM_PG_INIT_DELAY_MSECS);
@@ -275,6 +276,7 @@ static void __pg_init_all_paths(struct multipath *m)
 				       pg_init_delay))
 			m->pg_init_in_progress++;
 	}
+	return m->pg_init_in_progress;
 }
 
 static void __switch_pg(struct multipath *m, struct pgpath *pgpath)
@@ -436,40 +438,13 @@ static int queue_if_no_path(struct multipath *m, unsigned queue_if_no_path,
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
-	if (pgpath && m->pg_init_required)
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
@@ -1016,7 +991,7 @@ static int reinstate_path(struct pgpath *pgpath)
 
 	if (!m->nr_valid_paths++) {
 		m->current_pgpath = NULL;
-		queue_work(kmultipathd, &m->process_queued_ios);
+		dm_table_run_md_queue_async(m->ti->table);
 	} else if (m->hw_handler_name && (m->current_pg == pgpath->pg)) {
 		if (queue_work(kmpath_handlerd, &pgpath->activate_path.work))
 			m->pg_init_in_progress++;
@@ -1214,9 +1189,11 @@ static void pg_init_done(void *data, int errors)
 
 	if (!m->pg_init_required)
 		m->queue_io = 0;
-
-	m->pg_init_delay_retry = delay_retry;
-	queue_work(kmultipathd, &m->process_queued_ios);
+	else if (m->current_pg) {
+		m->pg_init_delay_retry = delay_retry;
+		if (__pg_init_all_paths(m))
+			goto out;
+	}
 
 	/*
 	 * Wake up any thread waiting to suspend.
@@ -1594,8 +1571,17 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
 			r = err;
 	}
 
-	if (r == -ENOTCONN && !fatal_signal_pending(current))
-		queue_work(kmultipathd, &m->process_queued_ios);
+	if (r == -ENOTCONN && !fatal_signal_pending(current)) {
+		spin_lock_irqsave(&m->lock, flags);
+		if (!m->current_pg) {
+			/* Path status changed, redo selection */
+			__choose_pgpath(m, 0);
+		}
+		if (m->pg_init_required)
+			__pg_init_all_paths(m);
+		spin_unlock_irqrestore(&m->lock, flags);
+		dm_table_run_md_queue_async(m->ti->table);
+	}
 
 	return r ? : __blkdev_driver_ioctl(bdev, mode, cmd, arg);
 }
-- 
1.7.12.4
