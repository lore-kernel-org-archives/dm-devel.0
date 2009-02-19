From: Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH] dm mpath: delay retry activate_path on
	SCSI_DH_RETRY
Date: Thu, 19 Feb 2009 12:40:21 +0530
Message-ID: <200902191240.22577.knikanth@suse.de>
References: <200902171917.38252.knikanth@suse.de>
	<20090219021118.GA3962@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090219021118.GA3962@agk.fab.redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thursday 19 February 2009 07:41:18 Alasdair G Kergon wrote:
> On Tue, Feb 17, 2009 at 07:17:37PM +0530, Nikanth Karthikesan wrote:
> > Delay retry to activate_path if it returns SCSI_DH_RETRY.
>
> Please write a complete patch header if you'd like this queued for
> upstream!
>
> E.g. Why?  Any cases where this will make matters worse or make no
> difference?
>

Sorry for the terse changelog.

> > +	unsigned long pg_init_jiffy;	/* To delay retry if SCSI_DH_RETRY */
> > +#define SCSI_DH_RETRY_DELAY ((HZ * 2))
>
> Why that particular value?

There is no specific reason. Just picked 2 seconds based on the TODO comment,
"For SCSI_DH_RETRY we should wait a couple seconds".

> Please move it into a header file with an explanation of what it does.
>
done.

Attached is the patch with comments from you and Chandra incorporated.

Thanks
Nikanth


SCSI Device Handlers return SCSI_DH_IMM_RETRY if we could retry
immediately and SCSI_DH_RETRY in cases where it is better to retry
after some delay.

Currently we retry immediately irrespective of SCSI_DH_IMM_RETRY and
SCSI_DH_RETRY.  This patch adds a 2 second delay before retrying to
activate a device, if it returns SCSI_DH_RETRY. 

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 095f77b..6fd76f1 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -65,12 +65,13 @@ struct multipath {
 	spinlock_t lock;
 
 	const char *hw_handler_name;
-	struct work_struct activate_path;
+	struct delayed_work activate_path;
 	struct pgpath *pgpath_to_activate;
 	unsigned nr_priority_groups;
 	struct list_head priority_groups;
 	unsigned pg_init_required;	/* pg_init needs calling? */
 	unsigned pg_init_in_progress;	/* Only one pg_init allowed at once */
+	unsigned pg_init_delay;		/* delay required before retry? */
 
 	unsigned nr_valid_paths;	/* Total number of usable paths */
 	struct pgpath *current_pgpath;
@@ -203,7 +204,7 @@ static struct multipath *alloc_multipath(struct dm_target *ti)
 		m->queue_io = 1;
 		INIT_WORK(&m->process_queued_ios, process_queued_ios);
 		INIT_WORK(&m->trigger_event, trigger_event);
-		INIT_WORK(&m->activate_path, activate_path);
+		INIT_DELAYED_WORK(&m->activate_path, activate_path);
 		m->mpio_pool = mempool_create_slab_pool(MIN_IOS, _mpio_cache);
 		if (!m->mpio_pool) {
 			kfree(m);
@@ -431,6 +432,7 @@ static void process_queued_ios(struct work_struct *work)
 	struct pgpath *pgpath = NULL;
 	unsigned init_required = 0, must_queue = 1;
 	unsigned long flags;
+	unsigned long delay = 0;
 
 	spin_lock_irqsave(&m->lock, flags);
 
@@ -452,13 +454,15 @@ static void process_queued_ios(struct work_struct *work)
 		m->pg_init_required = 0;
 		m->pg_init_in_progress = 1;
 		init_required = 1;
+		if (m->pg_init_delay)
+			delay = SCSI_DH_RETRY_DELAY;
 	}
 
 out:
 	spin_unlock_irqrestore(&m->lock, flags);
 
 	if (init_required)
-		queue_work(kmpath_handlerd, &m->activate_path);
+		queue_delayed_work(kmpath_handlerd, &m->activate_path, delay);
 
 	if (!must_queue)
 		dispatch_queued_ios(m);
@@ -1060,6 +1064,7 @@ static void pg_init_done(struct dm_path *path, int errors)
 	struct priority_group *pg = pgpath->pg;
 	struct multipath *m = pg->m;
 	unsigned long flags;
+	unsigned delay = 0;
 
 	/* device or driver problems */
 	switch (errors) {
@@ -1084,8 +1089,11 @@ static void pg_init_done(struct dm_path *path, int errors)
 		 */
 		bypass_pg(m, pg, 1);
 		break;
-	/* TODO: For SCSI_DH_RETRY we should wait a couple seconds */
+	/*
+	 * For SCSI_DH_RETRY we wait before retrying.
+	 */
 	case SCSI_DH_RETRY:
+		delay = 1;
 	case SCSI_DH_IMM_RETRY:
 	case SCSI_DH_RES_TEMP_UNAVAIL:
 		if (pg_init_limit_reached(m, pgpath))
@@ -1112,6 +1120,7 @@ static void pg_init_done(struct dm_path *path, int errors)
 	}
 
 	m->pg_init_in_progress = 0;
+	m->pg_init_delay = delay;
 	queue_work(kmultipathd, &m->process_queued_ios);
 	spin_unlock_irqrestore(&m->lock, flags);
 }
@@ -1120,7 +1129,7 @@ static void activate_path(struct work_struct *work)
 {
 	int ret;
 	struct multipath *m =
-		container_of(work, struct multipath, activate_path);
+		container_of(work, struct multipath, activate_path.work);
 	struct dm_path *path;
 	unsigned long flags;
 
diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
index 33efce2..f099d86 100644
--- a/include/scsi/scsi_dh.h
+++ b/include/scsi/scsi_dh.h
@@ -55,6 +55,10 @@ enum {
 	SCSI_DH_NOSYS,
 	SCSI_DH_DRIVER_MAX,
 };
+
+/* Time to wait before retry in case of SCSI_DH_RETRY */
+#define SCSI_DH_RETRY_DELAY ((HZ * 2))
+
 #if defined(CONFIG_SCSI_DH) || defined(CONFIG_SCSI_DH_MODULE)
 extern int scsi_dh_activate(struct request_queue *);
 extern int scsi_dh_handler_exist(const char *);
