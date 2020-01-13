From: Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH v2] dm mpath: Add timeout mechanism for
	queue_if_no_path
Date: Mon, 13 Jan 2020 17:41:27 -0500
Message-ID: <20200113224127.3367484-1-krisman@collabora.com>
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
To: snitzer@redhat.com
Cc: dm-devel@redhat.com, kernel@collabora.com, krisman@collabora.com, khazhy@google.com
List-Id: dm-devel.ids

From: Anatol Pomazau <anatol@google.com>

Add a configurable timeout mechanism to disable queue_if_no_path without
assistance from multipathd.  In reality, this reimplements the
no_path_retry mechanism from multipathd in kernel space, which is
interesting to prevent processes from hanging indefinitely in cases
where the daemon might be unable to respond, after a failure or for
whatever reason.

Despite replicating the policy configuration on kernel space, it is
quite an important case to prevent IOs from hanging forever, waiting for
userspace to behave correctly.

v2:
  - Use a module parameter instead of configuring per table
  - Simplify code

Co-developed-by: Frank Mayhar <fmayhar@google.com>
Signed-off-by: Frank Mayhar <fmayhar@google.com>
Co-developed-by: Bharath Ravi <rbharath@google.com>
Signed-off-by: Bharath Ravi <rbharath@google.com>
Co-developed-by: Khazhismel Kumykov <khazhy@google.com>
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
Signed-off-by: Anatol Pomazau <anatol@google.com>
Co-developed-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 drivers/md/dm-mpath.c | 62 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index e0c32793c248..52d90900e85b 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -29,6 +29,7 @@
 #define DM_MSG_PREFIX "multipath"
 #define DM_PG_INIT_DELAY_MSECS 2000
 #define DM_PG_INIT_DELAY_DEFAULT ((unsigned) -1)
+#define QUEUE_IF_NO_PATH_TIMEOUT_DEFAULT 0
 
 /* Path properties */
 struct pgpath {
@@ -91,6 +92,8 @@ struct multipath {
 
 	struct work_struct process_queued_bios;
 	struct bio_list queued_bios;
+
+	struct timer_list nopath_timer;	/* Timeout for queue_if_no_path */
 };
 
 /*
@@ -101,6 +104,10 @@ struct dm_mpath_io {
 	size_t nr_bytes;
 };
 
+static unsigned long queue_if_no_path_timeout = QUEUE_IF_NO_PATH_TIMEOUT_DEFAULT;
+module_param_named(queue_if_no_path_timeout_secs,
+                  queue_if_no_path_timeout, ulong, 0644);
+
 typedef int (*action_fn) (struct pgpath *pgpath);
 
 static struct workqueue_struct *kmultipathd, *kmpath_handlerd;
@@ -109,6 +116,10 @@ static void activate_or_offline_path(struct pgpath *pgpath);
 static void activate_path_work(struct work_struct *work);
 static void process_queued_bios(struct work_struct *work);
 
+static void queue_if_no_path_timeout_work(struct timer_list *t);
+static void enable_nopath_timeout(struct multipath *m);
+static void disable_nopath_timeout(struct multipath *m);
+
 /*-----------------------------------------------
  * Multipath state flags.
  *-----------------------------------------------*/
@@ -195,6 +206,8 @@ static struct multipath *alloc_multipath(struct dm_target *ti)
 
 		m->ti = ti;
 		ti->private = m;
+
+		timer_setup(&m->nopath_timer, queue_if_no_path_timeout_work, 0);
 	}
 
 	return m;
@@ -1090,6 +1103,7 @@ static int multipath_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	struct dm_arg_set as;
 	unsigned pg_count = 0;
 	unsigned next_pg_num;
+	unsigned long flags;
 
 	as.argc = argc;
 	as.argv = argv;
@@ -1154,6 +1168,10 @@ static int multipath_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto bad;
 	}
 
+	spin_lock_irqsave(&m->lock, flags);
+	enable_nopath_timeout(m);
+	spin_unlock_irqrestore(&m->lock, flags);
+
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
 	ti->num_write_same_bios = 1;
@@ -1208,10 +1226,25 @@ static void multipath_dtr(struct dm_target *ti)
 {
 	struct multipath *m = ti->private;
 
+	disable_nopath_timeout(m);
 	flush_multipath_work(m);
 	free_multipath(m);
 }
 
+/*
+ * If the queue_if_no_path timeout fires, turn off queue_if_no_path and
+ * process any queued I/O.
+ */
+static void queue_if_no_path_timeout_work(struct timer_list *t)
+{
+	struct multipath *m = from_timer(m, t, nopath_timer);
+	struct mapped_device *md = dm_table_get_md((m)->ti->table);
+
+	DMWARN("queue_if_no_path timeout on %s", dm_device_name(md));
+
+	queue_if_no_path(m, false, false);
+}
+
 /*
  * Take a path out of use.
  */
@@ -1241,6 +1274,8 @@ static int fail_path(struct pgpath *pgpath)
 
 	schedule_work(&m->trigger_event);
 
+	enable_nopath_timeout(m);
+
 out:
 	spin_unlock_irqrestore(&m->lock, flags);
 
@@ -1291,6 +1326,9 @@ static int reinstate_path(struct pgpath *pgpath)
 		process_queued_io_list(m);
 	}
 
+	if (pgpath->is_active)
+		disable_nopath_timeout(m);
+
 	return r;
 }
 
@@ -1314,6 +1352,25 @@ static int action_dev(struct multipath *m, struct dm_dev *dev,
 	return r;
 }
 
+/*
+ * Enable the queue_if_no_path timeout if necessary.  Called with m->lock
+ * held.
+ */
+static void enable_nopath_timeout(struct multipath *m)
+{
+	if (queue_if_no_path_timeout > 0 &&
+	    atomic_read(&m->nr_valid_paths) == 0 &&
+	    test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
+		mod_timer(&m->nopath_timer,
+			  jiffies + queue_if_no_path_timeout * HZ);
+	}
+}
+
+static void disable_nopath_timeout(struct multipath *m)
+{
+	del_timer_sync(&m->nopath_timer);
+}
+
 /*
  * Temporarily try to avoid having to use the specified PG
  */
@@ -1789,6 +1846,7 @@ static int multipath_message(struct dm_target *ti, unsigned argc, char **argv,
 	struct dm_dev *dev;
 	struct multipath *m = ti->private;
 	action_fn action;
+	unsigned long flags;
 
 	mutex_lock(&m->work_mutex);
 
@@ -1800,9 +1858,13 @@ static int multipath_message(struct dm_target *ti, unsigned argc, char **argv,
 	if (argc == 1) {
 		if (!strcasecmp(argv[0], "queue_if_no_path")) {
 			r = queue_if_no_path(m, true, false);
+			spin_lock_irqsave(&m->lock, flags);
+			enable_nopath_timeout(m);
+			spin_unlock_irqrestore(&m->lock, flags);
 			goto out;
 		} else if (!strcasecmp(argv[0], "fail_if_no_path")) {
 			r = queue_if_no_path(m, false, false);
+			disable_nopath_timeout(m);
 			goto out;
 		}
 	}
-- 
2.24.1
