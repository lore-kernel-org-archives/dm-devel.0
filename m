From: Frank Mayhar <fmayhar@google.com>
Subject: [PATCH 1/1] dm mpath: Add timeout mechanism for
	queue_if_no_path.
Date: Thu, 26 Sep 2013 13:36:19 -0700
Message-ID: <1380227779.25252.57.camel@bobble.lax.corp.google.com>
References: <1380215696.25252.36.camel@bobble.lax.corp.google.com>
	<20130926172422.GA31328@agk-dp.fab.redhat.com>
	<1380216716.25252.39.camel@bobble.lax.corp.google.com>
	<20130926173814.GB31328@agk-dp.fab.redhat.com>
	<1380217633.25252.46.camel@bobble.lax.corp.google.com>
	<20130926175254.GA32410@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130926175254.GA32410@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Add a configurable timeout mechanism to the queue_if_no_path function
of multipath.  If set and if queue_if_no_path is set, the timeout is
started when there are no active paths on a multipath device.  The
timeout is reset if an active path is introduced or, of course, if a
new table (and therefore a new multipath definition) is loaded.  If
the timeout ever fires, the handler simply turns queue_if_no_path off.
This allows I/O queued in multipath to be errored, possibly releasing
locks and semaphores that may be being held waiting for that I/O to
complete.

The implementation dynamically allocates the timeout as needed, so
as to add as little overhead as possible when it is not being used.

This mechanism is not turned on by default (the default timeout is zero).
It can be turned on by either adding the queue_if_no_path_timeout
parameter to the table definition or sending the parameter via the
DM message mechanism (sets a timeout for only that multipath instance;
note that this doesn't survive a table reload unless the parameter is
included in the new table).

Signed-off-by: Frank Mayhar <fmayhar@google.com>

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index de570a5..a746306 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -27,6 +27,8 @@
 #define DM_PG_INIT_DELAY_MSECS 2000
 #define DM_PG_INIT_DELAY_DEFAULT ((unsigned) -1)
 
+#define DEFAULT_NOPATH_TIMEOUT_SECS 0
+
 /* Path properties */
 struct pgpath {
 	struct list_head list;
@@ -105,6 +107,17 @@ struct multipath {
 	mempool_t *mpio_pool;
 
 	struct mutex work_mutex;
+
+	/*
+	 * When a context loses its last path, queue_if_no_path is set and
+	 * nopath_timeout > 0, we start this timer.  If it fires, we clear
+	 * queue_if_no_path.  If we get a new path before it fires, we stop
+	 * the timer.
+	 *
+	 * The timeout is given in seconds.
+	 */
+	unsigned nopath_timeout;
+	struct timer_list *nopath_timer;
 };
 
 /*
@@ -117,12 +130,19 @@ struct dm_mpath_io {
 
 typedef int (*action_fn) (struct pgpath *pgpath);
 
+static unsigned long dm_mpath_nopath_timeout = DEFAULT_NOPATH_TIMEOUT_SECS;
+module_param_named(queue_if_no_path_timeout_secs,
+		   dm_mpath_nopath_timeout, ulong, S_IRUGO | S_IWUSR);
+
 static struct kmem_cache *_mpio_cache;
 
 static struct workqueue_struct *kmultipathd, *kmpath_handlerd;
 static void process_queued_ios(struct work_struct *work);
 static void trigger_event(struct work_struct *work);
 static void activate_path(struct work_struct *work);
+static void handle_nopath_timeout(unsigned long data);
+static void activate_nopath_timeout_l(struct multipath *m);
+static int activate_nopath_timeout(struct multipath *m, unsigned to);
 
 
 /*-----------------------------------------------
@@ -193,6 +213,8 @@ static struct multipath *alloc_multipath(struct dm_target *ti)
 
 	m = kzalloc(sizeof(*m), GFP_KERNEL);
 	if (m) {
+		int r;
+
 		INIT_LIST_HEAD(&m->priority_groups);
 		INIT_LIST_HEAD(&m->queued_ios);
 		spin_lock_init(&m->lock);
@@ -207,6 +229,14 @@ static struct multipath *alloc_multipath(struct dm_target *ti)
 			kfree(m);
 			return NULL;
 		}
+		m->nopath_timer = NULL;
+		r = activate_nopath_timeout(m, DEFAULT_NOPATH_TIMEOUT_SECS);
+		if (r == -ENOMEM) {
+			DMWARN("Couldn't allocate timer list!");
+			mempool_destroy(m->mpio_pool);
+			kfree(m);
+			return NULL;
+		}
 		m->ti = ti;
 		ti->private = m;
 	}
@@ -790,6 +820,8 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 		{0, 6, "invalid number of feature args"},
 		{1, 50, "pg_init_retries must be between 1 and 50"},
 		{0, 60000, "pg_init_delay_msecs must be between 0 and 60000"},
+		{0, 31557600, "queue_if_no_path_timeout_secs must be 0 or"
+			      " a positive number of seconds"},
 	};
 
 	r = dm_read_arg_group(_args, as, &argc, &ti->error);
@@ -827,6 +859,16 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 			continue;
 		}
 
+		if (!strcasecmp(arg_name, "queue_if_no_path_timeout_secs") &&
+		    (argc >= 1)) {
+			unsigned to;
+
+			r = dm_read_arg(_args+3, as, &to, &ti->error);
+			activate_nopath_timeout(m, to);
+			argc--;
+			continue;
+		}
+
 		ti->error = "Unrecognised multipath feature request";
 		r = -EINVAL;
 	} while (argc && !r);
@@ -952,6 +994,8 @@ static void multipath_dtr(struct dm_target *ti)
 {
 	struct multipath *m = ti->private;
 
+	if (m->nopath_timer)
+		del_timer_sync(m->nopath_timer);
 	flush_multipath_work(m);
 	free_multipath(m);
 }
@@ -978,6 +1022,17 @@ static int multipath_map(struct dm_target *ti, struct request *clone,
 }
 
 /*
+ * If the queue_if_no_path timeout fires, turn off queue_if_no_path and
+ * process any queued I/O.
+ */
+static void handle_nopath_timeout(unsigned long data)
+{
+	struct multipath *m = (struct multipath *)data;
+
+	(void)queue_if_no_path(m, 0, 0);
+}
+
+/*
  * Take a path out of use.
  */
 static int fail_path(struct pgpath *pgpath)
@@ -1006,6 +1061,8 @@ static int fail_path(struct pgpath *pgpath)
 
 	schedule_work(&m->trigger_event);
 
+	activate_nopath_timeout_l(m);
+
 out:
 	spin_unlock_irqrestore(&m->lock, flags);
 
@@ -1055,6 +1112,9 @@ static int reinstate_path(struct pgpath *pgpath)
 out:
 	spin_unlock_irqrestore(&m->lock, flags);
 
+	if (m->nopath_timer)
+		del_timer_sync(m->nopath_timer);
+
 	return r;
 }
 
@@ -1079,6 +1139,79 @@ static int action_dev(struct multipath *m, struct dm_dev *dev,
 }
 
 /*
+ * Activate the queue_if_no_path timeout if necessary.  Called with m->lock
+ * held.
+ */
+static void activate_nopath_timeout_l(struct multipath *m)
+{
+	if (m->nr_valid_paths == 0 && m->nopath_timer &&
+	    m->nopath_timeout > 0 && m->queue_if_no_path)
+		mod_timer(m->nopath_timer, jiffies + m->nopath_timeout * HZ);
+}
+
+/*
+ * Set the queue_if_no_path timeout and activate it.
+ */
+static int activate_nopath_timeout(struct multipath *m, unsigned to)
+{
+	unsigned long flags;
+	struct timer_list *nopath_timer = NULL;
+
+	spin_lock_irqsave(&m->lock, flags);
+	/*
+	 * If the user is turning the timeout on, allocate the timer list.
+	 */
+	if (to && !m->nopath_timer) {
+		spin_unlock_irqrestore(&m->lock, flags);
+		nopath_timer = kzalloc(sizeof(struct timer_list), GFP_KERNEL);
+		if (!nopath_timer)
+			return -ENOMEM;
+		init_timer(nopath_timer);
+		nopath_timer->data = (unsigned long)m;
+		nopath_timer->function = handle_nopath_timeout;
+		spin_lock_irqsave(&m->lock, flags);
+		/* If we raced with an allocate, drop the new one. */
+		if (m->nopath_timer)
+			kfree(nopath_timer);
+		else
+			m->nopath_timer = nopath_timer;
+		nopath_timer = NULL;
+	}
+	m->nopath_timeout = to;
+	if (to)
+		activate_nopath_timeout_l(m);
+	else {
+		/*
+		 * If the user is turning the timeout off, null out the timer
+		 * list pointer so we can free it below.
+		 */
+		nopath_timer = m->nopath_timer;
+		m->nopath_timer = NULL;
+	}
+	spin_unlock_irqrestore(&m->lock, flags);
+	/* Now turn off the timer and free the timer list. */
+	if (nopath_timer) {
+		del_timer_sync(nopath_timer);
+		kfree(nopath_timer);
+	}
+	return 0;
+}
+
+/*
+ * Get the queue_if_no_path timeout, set it and activate it.
+ */
+static int set_nopath_timeout(struct multipath *m, const char *timestr)
+{
+	unsigned long to;
+
+	if (!timestr || (sscanf(timestr, "%lu", &to) != 1)) {
+		DMWARN("invalid timeout supplied to set_nopath_timeout");
+		return -EINVAL;
+	}
+	return activate_nopath_timeout(m, to);
+}
+
+/*
  * Temporarily try to avoid having to use the specified PG
  */
 static void bypass_pg(struct multipath *m, struct priority_group *pg,
@@ -1423,7 +1556,8 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 		DMEMIT("%u ", m->queue_if_no_path +
 			      (m->pg_init_retries > 0) * 2 +
 			      (m->pg_init_delay_msecs != DM_PG_INIT_DELAY_DEFAULT) * 2 +
-			      m->retain_attached_hw_handler);
+			      m->retain_attached_hw_handler) +
+			      (m->nopath_timeout > 0) * 2;
 		if (m->queue_if_no_path)
 			DMEMIT("queue_if_no_path ");
 		if (m->pg_init_retries)
@@ -1432,6 +1566,9 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 			DMEMIT("pg_init_delay_msecs %u ", m->pg_init_delay_msecs);
 		if (m->retain_attached_hw_handler)
 			DMEMIT("retain_attached_hw_handler ");
+		if (m->nopath_timeout)
+			DMEMIT("queue_if_no_path_timeout_secs %u ",
+				   m->nopath_timeout);
 	}
 
 	if (!m->hw_handler_name || type == STATUSTYPE_INFO)
@@ -1550,6 +1687,9 @@ static int multipath_message(struct dm_target *ti, unsigned argc, char **argv)
 	} else if (!strcasecmp(argv[0], "switch_group")) {
 		r = switch_pg_num(m, argv[1]);
 		goto out;
+	} else if (!strcasecmp(argv[0], "queue_if_no_path_timeout_secs")) {
+		r = set_nopath_timeout(m, argv[1]);
+		goto out;
 	} else if (!strcasecmp(argv[0], "reinstate_path"))
 		action = reinstate_path;
 	else if (!strcasecmp(argv[0], "fail_path"))

-- 
Frank Mayhar
310-460-4042
