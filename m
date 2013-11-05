From: Frank Mayhar <fmayhar@google.com>
Subject: [RFC PATCH v3] dm mpath: add a queue_if_no_path timeout
Date: Tue, 05 Nov 2013 08:02:12 -0800
Message-ID: <1383667332.4504.8.camel@bobble.lax.corp.google.com>
References: <20130926232241.GC31328@agk-dp.fab.redhat.com>
	<20130926234957.GA3658@redhat.com>
	<1382036590.1980.32.camel@bobble.lax.corp.google.com>
	<20131017191511.GA30452@redhat.com>
	<1382042759.1980.40.camel@bobble.lax.corp.google.com>
	<20131017211338.GB30993@redhat.com>
	<1382129515.1980.46.camel@bobble.lax.corp.google.com>
	<20131018225350.GB7553@redhat.com> <20131030010246.GA3611@redhat.com>
	<1383145687.6677.49.camel@bobble.lax.corp.google.com>
	<20131030154259.GA8206@redhat.com>
	<1383156565.17572.8.camel@bobble.lax.corp.google.com>
	<11AF7C027C4C02408624617A49860784EDC2C1@BPXM12GP.gisp.nec.co.jp>
	<1383229011.17572.12.camel@bobble.lax.corp.google.com>
	<11AF7C027C4C02408624617A49860784EE0B3F@BPXM12GP.gisp.nec.co.jp>
	<11AF7C027C4C02408624617A49860784EE0F5E@BPXM12GP.gisp.nec.co.jp>
	<1383664708.4504.4.camel@bobble.lax.corp.google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1383664708.4504.4.camel@bobble.lax.corp.google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

This is the patch submitted by Jun'ichi Nomura, originally based on
Mike's patch with some small changes by me.  Jun'ichi's description
follows, along with my changes:

On Tue, 2013-11-05 at 07:18 -0800, Frank Mayhar wrote:
> On Fri, 2013-11-01 at 04:17 +0000, Junichi Nomura wrote:
> > I slightly modified the patch:
> >   - fixed the timeout handler to correctly find
> >     clone request and "struct multipath"
> >   - the timeout handler just disables "queue_if_no_path"
> >     instead of killing the request directly
> >   - "dmsetup status" to show the parameter
> >   - changed an interface between dm core and target
> >   - added some debugging printk (you can remove them)
> > and checked the timeout occurs, at least.
> > 
> > I'm not sure if this feature is good or not though.
> > (The timer behavior is not intuitive, I think)
> Thanks!  I integrated your new patch and tested it.  Sure enough, it
> seems to work.  I've made a few tweaks (added a module tunable and
> support for setting the timer in multipath_message(), removed your debug
> printks) and will submit the modified patch for discussion shortly.

Comments?

---
 block/blk-timeout.c           |    2 
 drivers/md/dm-mpath.c         |   85 ++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-table.c         |   10 ++++
 drivers/md/dm.c               |   22 ++++++++++
 include/linux/device-mapper.h |    4 +
 5 files changed, 122 insertions(+), 1 deletion(-)

diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 65f1035..7ea06b0 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -170,7 +170,7 @@ void blk_add_timer(struct request *req)
 	struct request_queue *q = req->q;
 	unsigned long expiry;
 
-	if (!q->rq_timed_out_fn)
+	if (!q->rq_timed_out_fn || !q->rq_timeout)
 		return;
 
 	BUG_ON(!list_empty(&req->timeout_list));
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index de570a5..6f127b7 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -27,6 +27,8 @@
 #define DM_PG_INIT_DELAY_MSECS 2000
 #define DM_PG_INIT_DELAY_DEFAULT ((unsigned) -1)
 
+#define DEFAULT_NO_PATH_TIMEOUT_SECS 0
+
 /* Path properties */
 struct pgpath {
 	struct list_head list;
@@ -105,6 +107,8 @@ struct multipath {
 	mempool_t *mpio_pool;
 
 	struct mutex work_mutex;
+
+	unsigned no_path_timeout;
 };
 
 /*
@@ -117,6 +121,10 @@ struct dm_mpath_io {
 
 typedef int (*action_fn) (struct pgpath *pgpath);
 
+static unsigned long global_no_path_timeout = DEFAULT_NO_PATH_TIMEOUT_SECS;
+module_param_named(queue_if_no_path_timeout_secs,
+		   global_no_path_timeout, ulong, S_IRUGO | S_IWUSR);
+
 static struct kmem_cache *_mpio_cache;
 
 static struct workqueue_struct *kmultipathd, *kmpath_handlerd;
@@ -207,6 +215,7 @@ static struct multipath *alloc_multipath(struct dm_target *ti)
 			kfree(m);
 			return NULL;
 		}
+		m->no_path_timeout = global_no_path_timeout;
 		m->ti = ti;
 		ti->private = m;
 	}
@@ -444,6 +453,45 @@ static int queue_if_no_path(struct multipath *m, unsigned queue_if_no_path,
 	return 0;
 }
 
+/*
+ * Block timeout callback, called from the block layer
+ *
+ * request_queue lock is held on entry.
+ *
+ * Return values:
+ * BLK_EH_RESET_TIMER if the request should be left running
+ * BLK_EH_NOT_HANDLED if the request is handled or terminated
+ *                    by the driver.
+ */
+enum blk_eh_timer_return multipath_timed_out(struct dm_target *ti,
+					     struct request *clone)
+{
+	unsigned long flags;
+	struct multipath *m = ti->private;
+	int rc = BLK_EH_RESET_TIMER;
+	int flush_ios = 0;
+
+	/*
+	 * Only abort request if:
+	 * - queued_ios is not empty
+	 *   (protect against races with process_queued_ios)
+	 * - no valid paths are found
+	 */
+	spin_lock_irqsave(&m->lock, flags);
+	if (m->no_path_timeout &&
+	    !list_empty(&m->queued_ios) && !m->nr_valid_paths) {
+		flush_ios = 1;
+	}
+	spin_unlock_irqrestore(&m->lock, flags);
+
+	if (flush_ios) {
+		queue_if_no_path(m, 0, 0);
+		queue_work(kmultipathd, &m->process_queued_ios);
+	}
+
+	return rc;
+}
+
 /*-----------------------------------------------------------------
  * The multipath daemon is responsible for resubmitting queued ios.
  *---------------------------------------------------------------*/
@@ -790,6 +838,7 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 		{0, 6, "invalid number of feature args"},
 		{1, 50, "pg_init_retries must be between 1 and 50"},
 		{0, 60000, "pg_init_delay_msecs must be between 0 and 60000"},
+		{0, 65535, "queue_if_no_path_timeout_secs must be between 0 and 65535"},
 	};
 
 	r = dm_read_arg_group(_args, as, &argc, &ti->error);
@@ -827,6 +876,13 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 			continue;
 		}
 
+		if (!strcasecmp(arg_name, "queue_if_no_path_timeout_secs") &&
+		    (argc >= 1)) {
+			r = dm_read_arg(_args + 3, as, &m->no_path_timeout, &ti->error);
+			argc--;
+			continue;
+		}
+
 		ti->error = "Unrecognised multipath feature request";
 		r = -EINVAL;
 	} while (argc && !r);
@@ -978,6 +1034,27 @@ static int multipath_map(struct dm_target *ti, struct request *clone,
 }
 
 /*
+ * Set the no_path_timeout on behalf of a message.  Note that this only
+ * affects new requests; already-queued requests are unaffected.
+ */
+static int set_no_path_timeout(struct multipath *m, const char *timestr)
+{
+	unsigned long to;
+	unsigned long flags;
+
+	if (!timestr || (sscanf(timestr, "%lu", &to) != 1)) {
+		DMWARN("invalid timeout supplied to set_no_path_timeout");
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&m->lock, flags);
+	m->no_path_timeout = to;
+	dm_set_timeout(dm_table_get_md(m->ti->table), m->no_path_timeout);
+	spin_unlock_irqrestore(&m->lock, flags);
+	return 0;
+}
+
+/*
  * Take a path out of use.
  */
 static int fail_path(struct pgpath *pgpath)
@@ -1384,6 +1461,7 @@ static void multipath_resume(struct dm_target *ti)
 
 	spin_lock_irqsave(&m->lock, flags);
 	m->queue_if_no_path = m->saved_queue_if_no_path;
+	dm_set_timeout(dm_table_get_md(m->ti->table), m->no_path_timeout);
 	spin_unlock_irqrestore(&m->lock, flags);
 }
 
@@ -1421,11 +1499,14 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 		DMEMIT("2 %u %u ", m->queue_size, m->pg_init_count);
 	else {
 		DMEMIT("%u ", m->queue_if_no_path +
+				  (m->no_path_timeout > 0) * 2 +
 			      (m->pg_init_retries > 0) * 2 +
 			      (m->pg_init_delay_msecs != DM_PG_INIT_DELAY_DEFAULT) * 2 +
 			      m->retain_attached_hw_handler);
 		if (m->queue_if_no_path)
 			DMEMIT("queue_if_no_path ");
+		if (m->no_path_timeout)
+			DMEMIT("queue_if_no_path_timeout_secs %u ", m->no_path_timeout);
 		if (m->pg_init_retries)
 			DMEMIT("pg_init_retries %u ", m->pg_init_retries);
 		if (m->pg_init_delay_msecs != DM_PG_INIT_DELAY_DEFAULT)
@@ -1550,6 +1631,9 @@ static int multipath_message(struct dm_target *ti, unsigned argc, char **argv)
 	} else if (!strcasecmp(argv[0], "switch_group")) {
 		r = switch_pg_num(m, argv[1]);
 		goto out;
+	} else if (!strcasecmp(argv[0], "queue_if_no_path_timeout_secs")) {
+		r = set_no_path_timeout(m, argv[1]);
+		goto out;
 	} else if (!strcasecmp(argv[0], "reinstate_path"))
 		action = reinstate_path;
 	else if (!strcasecmp(argv[0], "fail_path"))
@@ -1728,6 +1812,7 @@ static struct target_type multipath_target = {
 	.ioctl  = multipath_ioctl,
 	.iterate_devices = multipath_iterate_devices,
 	.busy = multipath_busy,
+	.timed_out = multipath_timed_out,
 };
 
 static int __init dm_multipath_init(void)
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 8f87835..32c5399 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -26,6 +26,8 @@
 #define KEYS_PER_NODE (NODE_SIZE / sizeof(sector_t))
 #define CHILDREN_PER_NODE (KEYS_PER_NODE + 1)
 
+enum blk_eh_timer_return dm_rq_timed_out(struct request *rq);
+
 struct dm_table {
 	struct mapped_device *md;
 	unsigned type;
@@ -1519,6 +1521,7 @@ static void suspend_targets(struct dm_table *t, unsigned postsuspend)
 
 		ti++;
 	}
+	blk_queue_rq_timed_out(dm_disk(t->md)->queue, NULL);
 }
 
 void dm_table_presuspend_targets(struct dm_table *t)
@@ -1540,10 +1543,14 @@ void dm_table_postsuspend_targets(struct dm_table *t)
 int dm_table_resume_targets(struct dm_table *t)
 {
 	int i, r = 0;
+	int has_timeout = 0;
 
 	for (i = 0; i < t->num_targets; i++) {
 		struct dm_target *ti = t->targets + i;
 
+		if (ti->type->timed_out)
+			has_timeout = 1;
+
 		if (!ti->type->preresume)
 			continue;
 
@@ -1552,6 +1559,9 @@ int dm_table_resume_targets(struct dm_table *t)
 			return r;
 	}
 
+	if (has_timeout)
+		blk_queue_rq_timed_out(dm_disk(t->md)->queue, dm_rq_timed_out);
+
 	for (i = 0; i < t->num_targets; i++) {
 		struct dm_target *ti = t->targets + i;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b3e26c7..bb7a29c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1026,6 +1026,13 @@ static void end_clone_request(struct request *clone, int error)
 	dm_complete_request(clone, error);
 }
 
+int dm_set_timeout(struct mapped_device *md, unsigned int tmo)
+{
+	blk_queue_rq_timeout(md->queue, tmo * HZ);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_set_timeout);
+
 /*
  * Return maximum size of I/O possible at the supplied sector up to the current
  * target boundary.
@@ -1829,6 +1836,21 @@ out:
 	dm_put_live_table(md, srcu_idx);
 }
 
+enum blk_eh_timer_return dm_rq_timed_out(struct request *rq)
+{
+	struct request *clone = rq->special;
+	struct dm_rq_target_io *tio = clone->end_io_data;
+
+	if (!tio)
+		goto out; /* not mapped */
+
+	if (tio->ti->type->timed_out)
+		return tio->ti->type->timed_out(tio->ti, clone);
+
+out:
+	return BLK_EH_RESET_TIMER;
+}
+
 int dm_underlying_device_busy(struct request_queue *q)
 {
 	return blk_lld_busy(q);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index ed419c6..84c0368 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -107,6 +107,8 @@ typedef int (*dm_iterate_devices_fn) (struct dm_target *ti,
 typedef void (*dm_io_hints_fn) (struct dm_target *ti,
 				struct queue_limits *limits);
 
+typedef enum blk_eh_timer_return (*dm_rq_timed_out_fn) (struct dm_target *ti,
+							struct request *clone);
 /*
  * Returns:
  *    0: The target can handle the next I/O immediately.
@@ -162,6 +164,7 @@ struct target_type {
 	dm_busy_fn busy;
 	dm_iterate_devices_fn iterate_devices;
 	dm_io_hints_fn io_hints;
+	dm_rq_timed_out_fn timed_out;
 
 	/* For internal device-mapper use. */
 	struct list_head list;
@@ -604,5 +607,6 @@ void dm_dispatch_request(struct request *rq);
 void dm_requeue_unmapped_request(struct request *rq);
 void dm_kill_unmapped_request(struct request *rq, int error);
 int dm_underlying_device_busy(struct request_queue *q);
+int dm_set_timeout(struct mapped_device *md, unsigned int tmo);
 
 #endif	/* _LINUX_DEVICE_MAPPER_H */

-- 
Frank Mayhar
310-460-4042
