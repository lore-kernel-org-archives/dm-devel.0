From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 2/4] dm-mpath: must wait for pg-init completion
	in postsuspend
Date: Mon, 01 Feb 2010 13:20:48 +0900
Message-ID: <4B6656A0.3030409@ct.jp.nec.com>
References: <4B665507.8080205@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4B665507.8080205@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Target must be quiet if it is suspended.  So multipath_postsusped()
flushes all workqueues to become quiet.
But pg-init may be still in progress even after flushing the workqueue
for kmpath_handlerd.

This patch waits for pg-init completion correctly in
multipath_postsuspend().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-mpath.c |   38 +++++++++++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 3 deletions(-)

Index: 2.6.33-rc6/drivers/md/dm-mpath.c
===================================================================
--- 2.6.33-rc6.orig/drivers/md/dm-mpath.c
+++ 2.6.33-rc6/drivers/md/dm-mpath.c
@@ -69,6 +69,7 @@ struct multipath {
 	struct list_head priority_groups;
 	unsigned pg_init_required;	/* pg_init needs calling? */
 	unsigned pg_init_in_progress;	/* Only one pg_init allowed at once */
+	wait_queue_head_t wait;		/* Wait for pg_init completion */
 
 	unsigned nr_valid_paths;	/* Total number of usable paths */
 	struct pgpath *current_pgpath;
@@ -200,6 +201,7 @@ static struct multipath *alloc_multipath
 		m->queue_io = 1;
 		INIT_WORK(&m->process_queued_ios, process_queued_ios);
 		INIT_WORK(&m->trigger_event, trigger_event);
+		init_waitqueue_head(&m->wait);
 		mutex_init(&m->work_mutex);
 		m->mpio_pool = mempool_create_slab_pool(MIN_IOS, _mpio_cache);
 		if (!m->mpio_pool) {
@@ -891,9 +893,34 @@ static int multipath_ctr(struct dm_targe
 	return r;
 }
 
-static void flush_multipath_work(void)
+static void multipath_wait_for_pg_init_completion(struct multipath *m)
+{
+	DECLARE_WAITQUEUE(wait, current);
+	unsigned long flags;
+
+	add_wait_queue(&m->wait, &wait);
+
+	while (1) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+
+		spin_lock_irqsave(&m->lock, flags);
+		if (!m->pg_init_in_progress) {
+			spin_unlock_irqrestore(&m->lock, flags);
+			break;
+		}
+		spin_unlock_irqrestore(&m->lock, flags);
+
+		io_schedule();
+	}
+	set_current_state(TASK_RUNNING);
+
+	remove_wait_queue(&m->wait, &wait);
+}
+
+static void flush_multipath_work(struct multipath *m)
 {
 	flush_workqueue(kmpath_handlerd);
+	multipath_wait_for_pg_init_completion(m);
 	flush_workqueue(kmultipathd);
 	flush_scheduled_work();
 }
@@ -902,7 +929,7 @@ static void multipath_dtr(struct dm_targ
 {
 	struct multipath *m = ti->private;
 
-	flush_multipath_work();
+	flush_multipath_work(m);
 	free_multipath(m);
 }
 
@@ -1193,6 +1220,11 @@ static void pg_init_done(void *data, int
 
 	queue_work(kmultipathd, &m->process_queued_ios);
 
+	/*
+	 * Must not do anything related to pg-init after waking up the waiter
+	 */
+	wake_up(&m->wait);
+
 out:
 	spin_unlock_irqrestore(&m->lock, flags);
 }
@@ -1281,7 +1313,7 @@ static void multipath_postsuspend(struct
 	struct multipath *m = ti->private;
 
 	mutex_lock(&m->work_mutex);
-	flush_multipath_work();
+	flush_multipath_work(m);
 	mutex_unlock(&m->work_mutex);
 }
 
