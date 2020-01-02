From: Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH] dm mpath: Add timeout mechanism for
	queue_if_no_path
Date: Thu,  2 Jan 2020 17:45:12 -0500
Message-ID: <20200102224512.3605010-1-krisman@collabora.com>
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
To: agk@redhat.com
Cc: snitzer@redhat.com, Bharath Ravi <rbharath@google.com>, Khazhismel Kumykov <khazhy@google.com>, dm-devel@redhat.com, Anatol Pomazau <anatol@google.com>, Gabriel Krisman Bertazi <krisman@collabora.com>, kernel@collabora.com, Frank Mayhar <fmayhar@google.com>
List-Id: dm-devel.ids

From: Anatol Pomazau <anatol@google.com>

Add a configurable timeout mechanism to disable queue_if_no_path without
assistance from multipathd.  In reality, this reimplements the
no_path_retry mechanism from multipathd in kernel space, which is
interesting for cases where we cannot rely on a daemon being present all
the time, in case of failure or to reduce the guest footprint of cloud
services.

Despite replicating the policy configuration on kernel space, it is
quite an important case to prevent IOs from hanging forever, waiting for
userspace to behave correctly.

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
 drivers/md/dm-mpath.c | 96 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 95 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index e0c32793c248..72ba7ae98458 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -91,6 +91,9 @@ struct multipath {
 
 	struct work_struct process_queued_bios;
 	struct bio_list queued_bios;
+
+	unsigned int nopath_timeout;	/* Timeout for queue_if_no_path */
+	struct timer_list nopath_timer;
 };
 
 /*
@@ -109,6 +112,11 @@ static void activate_or_offline_path(struct pgpath *pgpath);
 static void activate_path_work(struct work_struct *work);
 static void process_queued_bios(struct work_struct *work);
 
+static void handle_nopath_timeout(struct timer_list *t);
+static void enable_nopath_timeout(struct multipath *m);
+static int activate_nopath_timeout(struct multipath *m,
+				   unsigned int to, int enable);
+
 /*-----------------------------------------------
  * Multipath state flags.
  *-----------------------------------------------*/
@@ -195,6 +203,8 @@ static struct multipath *alloc_multipath(struct dm_target *ti)
 
 		m->ti = ti;
 		ti->private = m;
+
+		timer_setup(&m->nopath_timer, handle_nopath_timeout, 0);
 	}
 
 	return m;
@@ -1016,6 +1026,7 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 		{0, 8, "invalid number of feature args"},
 		{1, 50, "pg_init_retries must be between 1 and 50"},
 		{0, 60000, "pg_init_delay_msecs must be between 0 and 60000"},
+		{0, 600, "queue_if_no_path_timeout must be 0 or a timeout in seconds"},
 	};
 
 	r = dm_read_arg_group(_args, as, &argc, &ti->error);
@@ -1070,6 +1081,16 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 			continue;
 		}
 
+		if (!strcasecmp(arg_name, "queue_if_no_path_timeout") &&
+		    (argc >= 1)) {
+			unsigned int to;
+
+			r = dm_read_arg(_args+3, as, &to, &ti->error);
+			activate_nopath_timeout(m, to, 0);
+			argc--;
+			continue;
+		}
+
 		ti->error = "Unrecognised multipath feature request";
 		r = -EINVAL;
 	} while (argc && !r);
@@ -1090,6 +1111,7 @@ static int multipath_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	struct dm_arg_set as;
 	unsigned pg_count = 0;
 	unsigned next_pg_num;
+	unsigned long flags;
 
 	as.argc = argc;
 	as.argv = argv;
@@ -1154,6 +1176,10 @@ static int multipath_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto bad;
 	}
 
+	spin_lock_irqsave(&m->lock, flags);
+	enable_nopath_timeout(m);
+	spin_unlock_irqrestore(&m->lock, flags);
+
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
 	ti->num_write_same_bios = 1;
@@ -1208,10 +1234,26 @@ static void multipath_dtr(struct dm_target *ti)
 {
 	struct multipath *m = ti->private;
 
+	del_timer_sync(&m->nopath_timer);
+
 	flush_multipath_work(m);
 	free_multipath(m);
 }
 
+/*
+ * If the queue_if_no_path timeout fires, turn off queue_if_no_path and
+ * process any queued I/O.
+ */
+static void handle_nopath_timeout(struct timer_list *t)
+{
+	struct multipath *m = from_timer(m, t, nopath_timer);
+	struct mapped_device *md = dm_table_get_md((m)->ti->table);
+
+	DMWARN("queue_if_no_path timeout on %s", dm_device_name(md));
+
+	(void)queue_if_no_path(m, false, false);
+}
+
 /*
  * Take a path out of use.
  */
@@ -1241,6 +1283,8 @@ static int fail_path(struct pgpath *pgpath)
 
 	schedule_work(&m->trigger_event);
 
+	enable_nopath_timeout(m);
+
 out:
 	spin_unlock_irqrestore(&m->lock, flags);
 
@@ -1291,6 +1335,8 @@ static int reinstate_path(struct pgpath *pgpath)
 		process_queued_io_list(m);
 	}
 
+	del_timer_sync(&m->nopath_timer);
+
 	return r;
 }
 
@@ -1314,6 +1360,47 @@ static int action_dev(struct multipath *m, struct dm_dev *dev,
 	return r;
 }
 
+/*
+ * Enable the queue_if_no_path timeout if necessary.  Called with m->lock
+ * held.
+ */
+static void enable_nopath_timeout(struct multipath *m)
+{
+	if (atomic_read(&m->nr_valid_paths) == 0 && m->nopath_timeout > 0 &&
+	    test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
+		mod_timer(&m->nopath_timer, jiffies + m->nopath_timeout * HZ);
+	}
+}
+
+static int activate_nopath_timeout(struct multipath *m, unsigned int to,
+				   int enable)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&m->lock, flags);
+
+	m->nopath_timeout = to;
+	if (to && enable)
+		enable_nopath_timeout(m);
+
+	spin_unlock_irqrestore(&m->lock, flags);
+
+	if (!to)
+		del_timer_sync(&m->nopath_timer);
+	return 0;
+}
+
+static int set_nopath_timeout(struct multipath *m, const char *timestr)
+{
+	unsigned long to;
+
+	if (!timestr || (kstrtol(timestr, 10, &to) != 1)) {
+		DMWARN("invalid timeout supplied to %s", __func__);
+		return -EINVAL;
+	}
+	return activate_nopath_timeout(m, to, 1);
+}
+
 /*
  * Temporarily try to avoid having to use the specified PG
  */
@@ -1682,7 +1769,8 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 			      (m->pg_init_retries > 0) * 2 +
 			      (m->pg_init_delay_msecs != DM_PG_INIT_DELAY_DEFAULT) * 2 +
 			      test_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags) +
-			      (m->queue_mode != DM_TYPE_REQUEST_BASED) * 2);
+			      (m->queue_mode != DM_TYPE_REQUEST_BASED) * 2 +
+			      (m->nopath_timeout > 0) * 2);
 
 		if (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
 			DMEMIT("queue_if_no_path ");
@@ -1702,6 +1790,9 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 				break;
 			}
 		}
+		if (m->nopath_timeout)
+			DMEMIT("queue_if_no_path_timeout %u ",
+			       m->nopath_timeout);
 	}
 
 	if (!m->hw_handler_name || type == STATUSTYPE_INFO)
@@ -1821,6 +1912,9 @@ static int multipath_message(struct dm_target *ti, unsigned argc, char **argv,
 	} else if (!strcasecmp(argv[0], "switch_group")) {
 		r = switch_pg_num(m, argv[1]);
 		goto out;
+	} else if (!strcasecmp(argv[0], "queue_if_no_path_timeout")) {
+		r = set_nopath_timeout(m, argv[1]);
+		goto out;
 	} else if (!strcasecmp(argv[0], "reinstate_path"))
 		action = reinstate_path;
 	else if (!strcasecmp(argv[0], "fail_path"))
-- 
2.24.1
