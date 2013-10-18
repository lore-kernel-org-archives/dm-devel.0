From: Mike Snitzer <snitzer@redhat.com>
Subject: [RFC PATCH v2] dm mpath: add a queue_if_no_path timeout
Date: Fri, 18 Oct 2013 18:53:51 -0400
Message-ID: <20131018225350.GB7553@redhat.com>
References: <1380216716.25252.39.camel@bobble.lax.corp.google.com>
	<20130926173814.GB31328@agk-dp.fab.redhat.com>
	<1380217633.25252.46.camel@bobble.lax.corp.google.com>
	<20130926232241.GC31328@agk-dp.fab.redhat.com>
	<20130926234957.GA3658@redhat.com>
	<1382036590.1980.32.camel@bobble.lax.corp.google.com>
	<20131017191511.GA30452@redhat.com>
	<1382042759.1980.40.camel@bobble.lax.corp.google.com>
	<20131017211338.GB30993@redhat.com>
	<1382129515.1980.46.camel@bobble.lax.corp.google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1382129515.1980.46.camel@bobble.lax.corp.google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Frank Mayhar <fmayhar@google.com>
Cc: dm-devel <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Oct 18 2013 at  4:51pm -0400,
Frank Mayhar <fmayhar@google.com> wrote:

> On Thu, 2013-10-17 at 17:13 -0400, Mike Snitzer wrote:
> > Cannot say that argument wins me over but I will say that if you intend
> > to take the approach to have the kernel have a timeout; please pursue
> > the approach Hannes offered:
> > 
> > https://patchwork.kernel.org/patch/2953231/
> > 
> > It is much cleaner and if it works for your needs we can see about
> > getting a tested version upstream.
> 
> Unfortunately his patch doesn't work as-is; it turns out that it tries
> to set the timeout only if the target is request-based but at the time
> he tries to set it the table type hasn't yet been set.
> 
> I'm looking into fixing it.

Ouch, yeah, can't access the DM device's queue from .ctr()
There were other issues with Hannes RFC patch, wouldn't compile.

Anyway, looks like we need a new target_type hook (e.g. .init_queue)
that is called from dm_init_request_based_queue().

Request-based DM only allows a single DM target per device so we don't
need the usual multi DM-target iterators.

But, unfortunately, at the time we call dm_init_request_based_queue()
the mapped_device isn't yet connected to the inactive table that is
being loaded (but the table is connected to the mapped_device).

In dm-ioctl.c:table_load(), the inactive table could be passed directly
into dm_setup_md_queue().

Please give the following revised patch a try, if it works we can clean
it up further (think multipath_status needs updating, we also may want
to constrain .init_queue to only being called if the target is a
singleton, which dm-mpath should be, but isn't flagged as such yet).

It compiles, but I haven't tested it...

---
 drivers/md/dm-ioctl.c         |    2 +-
 drivers/md/dm-mpath.c         |   77 +++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm.c               |   12 +++++--
 drivers/md/dm.h               |    2 +-
 include/linux/device-mapper.h |    4 ++
 5 files changed, 92 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index afe0814..74d1ab4 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1289,7 +1289,7 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
 	}
 
 	/* setup md->queue to reflect md's type (may block) */
-	r = dm_setup_md_queue(md);
+	r = dm_setup_md_queue(md, t);
 	if (r) {
 		DMWARN("unable to set up device queue for new table.");
 		goto err_unlock_md_type;
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index de570a5..2c3e427 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -105,6 +105,8 @@ struct multipath {
 	mempool_t *mpio_pool;
 
 	struct mutex work_mutex;
+
+	unsigned no_path_timeout;
 };
 
 /*
@@ -444,6 +446,61 @@ static int queue_if_no_path(struct multipath *m, unsigned queue_if_no_path,
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
+enum blk_eh_timer_return abort_if_no_path(struct request *rq)
+{
+	union map_info *info;
+	struct dm_mpath_io *mpio;
+	struct multipath *m;
+	unsigned long flags;
+	int rc = BLK_EH_RESET_TIMER;
+	int flush_ios = 0;
+
+	info = dm_get_rq_mapinfo(rq);
+	if (!info || !info->ptr)
+		return BLK_EH_NOT_HANDLED;
+
+	mpio = info->ptr;
+	m = mpio->pgpath->pg->m;
+	/*
+	 * Only abort request if:
+	 * - queued_ios is not empty
+	 *   (protect against races with process_queued_ios)
+	 * - queue_io is not set
+	 * - no valid paths are found
+	 */
+	spin_lock_irqsave(&m->lock, flags);
+	if (!list_empty(&m->queued_ios) &&
+	    !m->queue_io &&
+	    !m->nr_valid_paths) {
+		list_del_init(&rq->queuelist);
+		m->queue_size--;
+		m->queue_if_no_path = 0;
+		if (m->queue_size)
+			flush_ios = 1;
+		rc = BLK_EH_NOT_HANDLED;
+	}
+	spin_unlock_irqrestore(&m->lock, flags);
+
+	if (rc == BLK_EH_NOT_HANDLED) {
+		mempool_free(mpio, m->mpio_pool);
+		dm_kill_unmapped_request(rq, -ETIMEDOUT);
+	}
+	if (flush_ios)
+		queue_work(kmultipathd, &m->process_queued_ios);
+
+	return rc;
+}
+
 /*-----------------------------------------------------------------
  * The multipath daemon is responsible for resubmitting queued ios.
  *---------------------------------------------------------------*/
@@ -790,6 +847,7 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 		{0, 6, "invalid number of feature args"},
 		{1, 50, "pg_init_retries must be between 1 and 50"},
 		{0, 60000, "pg_init_delay_msecs must be between 0 and 60000"},
+		{0, 65535, "no_path_timeout must be between 0 and 65535"},
 	};
 
 	r = dm_read_arg_group(_args, as, &argc, &ti->error);
@@ -827,6 +885,13 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 			continue;
 		}
 
+		if (!strcasecmp(arg_name, "no_path_timeout") &&
+		    (argc >= 1)) {
+			r = dm_read_arg(_args + 3, as, &m->no_path_timeout, &ti->error);
+			argc--;
+			continue;
+		}
+
 		ti->error = "Unrecognised multipath feature request";
 		r = -EINVAL;
 	} while (argc && !r);
@@ -1709,6 +1774,17 @@ out:
 	return busy;
 }
 
+static void multipath_init_queue(struct dm_target *ti,
+				 struct request_queue *q)
+{
+	struct multipath *m = ti->private;
+
+	if (m->no_path_timeout) {
+		blk_queue_rq_timed_out(q, abort_if_no_path);
+		blk_queue_rq_timeout(q, m->no_path_timeout * HZ);
+	}
+}
+
 /*-----------------------------------------------------------------
  * Module setup
  *---------------------------------------------------------------*/
@@ -1728,6 +1804,7 @@ static struct target_type multipath_target = {
 	.ioctl  = multipath_ioctl,
 	.iterate_devices = multipath_iterate_devices,
 	.busy = multipath_busy,
+	.init_queue = multipath_init_queue,
 };
 
 static int __init dm_multipath_init(void)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b3e26c7..ce87b8a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2336,8 +2336,10 @@ EXPORT_SYMBOL_GPL(dm_get_queue_limits);
 /*
  * Fully initialize a request-based queue (->elevator, ->request_fn, etc).
  */
-static int dm_init_request_based_queue(struct mapped_device *md)
+static int dm_init_request_based_queue(struct mapped_device *md,
+				       struct dm_table *table)
 {
+	struct dm_target *ti = NULL;
 	struct request_queue *q = NULL;
 
 	if (md->queue->elevator)
@@ -2356,16 +2358,20 @@ static int dm_init_request_based_queue(struct mapped_device *md)
 
 	elv_register_queue(md->queue);
 
+	ti = dm_table_get_target(table, 0);
+	if (ti->type->init_queue)
+		ti->type->init_queue(ti, md->queue);
+
 	return 1;
 }
 
 /*
  * Setup the DM device's queue based on md's type
  */
-int dm_setup_md_queue(struct mapped_device *md)
+int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 {
 	if ((dm_get_md_type(md) == DM_TYPE_REQUEST_BASED) &&
-	    !dm_init_request_based_queue(md)) {
+	    !dm_init_request_based_queue(md, t)) {
 		DMWARN("Cannot initialize queue for request-based mapped device");
 		return -EINVAL;
 	}
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 1d1ad7b..55cb207 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -83,7 +83,7 @@ void dm_set_md_type(struct mapped_device *md, unsigned type);
 unsigned dm_get_md_type(struct mapped_device *md);
 struct target_type *dm_get_immutable_target_type(struct mapped_device *md);
 
-int dm_setup_md_queue(struct mapped_device *md);
+int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t);
 
 /*
  * To check the return value from dm_table_find_target().
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index ed419c6..650c575 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -107,6 +107,9 @@ typedef int (*dm_iterate_devices_fn) (struct dm_target *ti,
 typedef void (*dm_io_hints_fn) (struct dm_target *ti,
 				struct queue_limits *limits);
 
+typedef void (*dm_init_queue_fn) (struct dm_target *ti,
+				  struct request_queue *q);
+
 /*
  * Returns:
  *    0: The target can handle the next I/O immediately.
@@ -162,6 +165,7 @@ struct target_type {
 	dm_busy_fn busy;
 	dm_iterate_devices_fn iterate_devices;
 	dm_io_hints_fn io_hints;
+	dm_init_queue_fn init_queue;
 
 	/* For internal device-mapper use. */
 	struct list_head list;
