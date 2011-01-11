From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v4] dm mpath: delay retry of activate_path on
	SCSI_DH_RETRY
Date: Tue, 11 Jan 2011 11:20:31 -0500
Message-ID: <1294762831-29873-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.comdm-devel@redhat.com
Cc: Nikanth Karthikesan <knikanth@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

From: Chandra Seetharaman <sekharan@us.ibm.com>

SCSI Device Handlers return SCSI_DH_IMM_RETRY if we could retry
activation immediately and SCSI_DH_RETRY in cases where it is better to
retry after some delay.

Currently we immediately retry scsi_dh_activate irrespective of
SCSI_DH_IMM_RETRY and SCSI_DH_RETRY.

This patch adds a user configurable 'pg_init_delay_msecs' feature.  Use
this feature to specify the number of milliseconds to delay before
retrying scsi_dh_activate, when SCSI_DH_RETRY is returned.

The 'pg_init_delay_msecs' feature may be provided during table create or
load, e.g.:
echo "0 20971520 multipath 3 queue_if_no_path pg_init_delay_msecs 2500
..." | dmsetup create mpatha

The default for 'pg_init_delay_msecs' is 2000 milliseconds.
Maximum configurable delay is 60000 milliseconds.  Specifying a
'pg_init_delay_msecs' of 0 will cause immediate retry.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Acked-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c |   48 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 38 insertions(+), 10 deletions(-)

v4:
. bumped target version from 1.1.1 to 1.2.0 (user visible change)
. default 'pg_init_delay_msecs' to -1 so we know if user feature arg
  was provided
. allow user to specify a pg_init_delay_msecs of 0 (to disable delay)

v3:
. renamed 'pg_init_delay' to 'pg_init_delay_retry'
. switched 'pg_init_delay_secs' to 'pg_init_delay_msecs' and use
  msecs_to_jiffies() -- DM targets expect time in milliseconds
. moved 'pg_init_wait' in 'struct multipath' to avoid creating 2 new
  4-byte holes when introducing new members

Index: linux-2.6/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-mpath.c
+++ linux-2.6/drivers/md/dm-mpath.c
@@ -23,6 +23,7 @@
 
 #define DM_MSG_PREFIX "multipath"
 #define MESG_STR(x) x, sizeof(x)
+#define DM_PG_INIT_DELAY_MSECS 2000
 
 /* Path properties */
 struct pgpath {
@@ -33,7 +34,7 @@ struct pgpath {
 	unsigned fail_count;		/* Cumulative failure count */
 
 	struct dm_path path;
-	struct work_struct activate_path;
+	struct delayed_work activate_path;
 };
 
 #define path_to_pgpath(__pgp) container_of((__pgp), struct pgpath, path)
@@ -64,11 +65,15 @@ struct multipath {
 
 	const char *hw_handler_name;
 	char *hw_handler_params;
+
 	unsigned nr_priority_groups;
 	struct list_head priority_groups;
+
+	wait_queue_head_t pg_init_wait;	/* Wait for pg_init completion */
+
 	unsigned pg_init_required;	/* pg_init needs calling? */
 	unsigned pg_init_in_progress;	/* Only one pg_init allowed at once */
-	wait_queue_head_t pg_init_wait;	/* Wait for pg_init completion */
+	unsigned pg_init_delay_retry;	/* Delay pg_init retry? */
 
 	unsigned nr_valid_paths;	/* Total number of usable paths */
 	struct pgpath *current_pgpath;
@@ -81,6 +86,7 @@ struct multipath {
 	unsigned saved_queue_if_no_path;/* Saved state during suspension */
 	unsigned pg_init_retries;	/* Number of times to retry pg_init */
 	unsigned pg_init_count;		/* Number of times pg_init called */
+	int pg_init_delay_msecs;	/* Number of msecs before pg_init retry */
 
 	struct work_struct process_queued_ios;
 	struct list_head queued_ios;
@@ -127,7 +133,7 @@ static struct pgpath *alloc_pgpath(void)
 
 	if (pgpath) {
 		pgpath->is_active = 1;
-		INIT_WORK(&pgpath->activate_path, activate_path);
+		INIT_DELAYED_WORK(&pgpath->activate_path, activate_path);
 	}
 
 	return pgpath;
@@ -188,6 +194,7 @@ static struct multipath *alloc_multipath
 		INIT_LIST_HEAD(&m->queued_ios);
 		spin_lock_init(&m->lock);
 		m->queue_io = 1;
+		m->pg_init_delay_msecs = -1;
 		INIT_WORK(&m->process_queued_ios, process_queued_ios);
 		INIT_WORK(&m->trigger_event, trigger_event);
 		init_waitqueue_head(&m->pg_init_wait);
@@ -227,14 +234,20 @@ static void free_multipath(struct multip
 static void __pg_init_all_paths(struct multipath *m)
 {
 	struct pgpath *pgpath;
+	unsigned long pg_init_delay = 0;
 
 	m->pg_init_count++;
 	m->pg_init_required = 0;
+	if (m->pg_init_delay_retry)
+		pg_init_delay = msecs_to_jiffies(m->pg_init_delay_msecs != -1 ?
+						 m->pg_init_delay_msecs :
+						 DM_PG_INIT_DELAY_MSECS);
 	list_for_each_entry(pgpath, &m->current_pg->pgpaths, list) {
 		/* Skip failed paths */
 		if (!pgpath->is_active)
 			continue;
-		if (queue_work(kmpath_handlerd, &pgpath->activate_path))
+		if (queue_delayed_work(kmpath_handlerd, &pgpath->activate_path,
+				       pg_init_delay))
 			m->pg_init_in_progress++;
 	}
 }
@@ -782,8 +795,9 @@ static int parse_features(struct arg_set
 	const char *param_name;
 
 	static struct param _params[] = {
-		{0, 3, "invalid number of feature args"},
+		{0, 5, "invalid number of feature args"},
 		{1, 50, "pg_init_retries must be between 1 and 50"},
+		{0, 60000, "pg_init_delay_msecs must be between 0 and 60000"},
 	};
 
 	r = read_param(_params, shift(as), &argc, &ti->error);
@@ -810,6 +824,14 @@ static int parse_features(struct arg_set
 			continue;
 		}
 
+		if (!strnicmp(param_name, MESG_STR("pg_init_delay_msecs")) &&
+		    (argc >= 1)) {
+			r = read_param(_params + 1, shift(as),
+				       &m->pg_init_delay_msecs, &ti->error);
+			argc--;
+			continue;
+		}
+
 		ti->error = "Unrecognised multipath feature request";
 		r = -EINVAL;
 	} while (argc && !r);
@@ -1022,7 +1044,7 @@ static int reinstate_path(struct pgpath 
 		m->current_pgpath = NULL;
 		queue_work(kmultipathd, &m->process_queued_ios);
 	} else if (m->hw_handler_name && (m->current_pg == pgpath->pg)) {
-		if (queue_work(kmpath_handlerd, &pgpath->activate_path))
+		if (queue_work(kmpath_handlerd, &pgpath->activate_path.work))
 			m->pg_init_in_progress++;
 	}
 
@@ -1157,6 +1179,7 @@ static void pg_init_done(void *data, int
 	struct priority_group *pg = pgpath->pg;
 	struct multipath *m = pg->m;
 	unsigned long flags;
+	unsigned delay_retry = 0;
 
 	/* device or driver problems */
 	switch (errors) {
@@ -1181,8 +1204,9 @@ static void pg_init_done(void *data, int
 		 */
 		bypass_pg(m, pg, 1);
 		break;
-	/* TODO: For SCSI_DH_RETRY we should wait a couple seconds */
 	case SCSI_DH_RETRY:
+		/* Wait before retrying. */
+		delay_retry = 1;
 	case SCSI_DH_IMM_RETRY:
 	case SCSI_DH_RES_TEMP_UNAVAIL:
 		if (pg_init_limit_reached(m, pgpath))
@@ -1215,6 +1239,7 @@ static void pg_init_done(void *data, int
 	if (!m->pg_init_required)
 		m->queue_io = 0;
 
+	m->pg_init_delay_retry = delay_retry;
 	queue_work(kmultipathd, &m->process_queued_ios);
 
 	/*
@@ -1229,7 +1254,7 @@ out:
 static void activate_path(struct work_struct *work)
 {
 	struct pgpath *pgpath =
-		container_of(work, struct pgpath, activate_path);
+		container_of(work, struct pgpath, activate_path.work);
 
 	scsi_dh_activate(bdev_get_queue(pgpath->path.dev->bdev),
 				pg_init_done, pgpath);
@@ -1370,11 +1395,14 @@ static int multipath_status(struct dm_ta
 		DMEMIT("2 %u %u ", m->queue_size, m->pg_init_count);
 	else {
 		DMEMIT("%u ", m->queue_if_no_path +
-			      (m->pg_init_retries > 0) * 2);
+			      (m->pg_init_retries > 0) * 2 +
+		              (m->pg_init_delay_msecs != -1) * 2);
 		if (m->queue_if_no_path)
 			DMEMIT("queue_if_no_path ");
 		if (m->pg_init_retries)
 			DMEMIT("pg_init_retries %u ", m->pg_init_retries);
+		if (m->pg_init_delay_msecs != -1)
+			DMEMIT("pg_init_delay_msecs %u ", m->pg_init_delay_msecs);
 	}
 
 	if (!m->hw_handler_name || type == STATUSTYPE_INFO)
@@ -1643,7 +1671,7 @@ out:
  *---------------------------------------------------------------*/
 static struct target_type multipath_target = {
 	.name = "multipath",
-	.version = {1, 1, 1},
+	.version = {1, 2, 0},
 	.module = THIS_MODULE,
 	.ctr = multipath_ctr,
 	.dtr = multipath_dtr,
