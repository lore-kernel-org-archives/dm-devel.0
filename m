From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH] dm mpath: delay retry activate_path on
	SCSI_DH_RETRY
Date: Thu, 14 May 2009 20:10:17 -0700
Message-ID: <1242357018.15931.14.camel@chandra-ubuntu>
References: <1241493497.8721.60.camel@chandra-ubuntu>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1241493497.8721.60.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel <dm-devel@redhat.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>, Mike Christie <mchristi@redhat.com>
List-Id: dm-devel.ids

Resubmitting the patch with 2 changes:
 1. pg_init_delay_secs was used inconsistently (jiffies and seconds).
    Fixed the problem
 2. Moved the #define to dm_mpath.c from scsi_dh.h
-----------------------
From: Chandra Seetharaman <sekharan@us.ibm.com>

SCSI Device Handlers return SCSI_DH_IMM_RETRY if we could retry
immediately and SCSI_DH_RETRY in cases where it is better to retry
after some delay.

Currently we retry immediately irrespective of SCSI_DH_IMM_RETRY and
SCSI_DH_RETRY. This patch adds a user configurable attribute
pg_init_delay_secs which specifies the number of seconds to delay
before retrying scsi_dh_activate, when it returned SCSI_DH_RETRY.

Default for this attribute is set to 2 seconds.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

---
 drivers/md/dm-mpath.c |   44 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 9 deletions(-)

Index: linux-2.6.29/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.29.orig/drivers/md/dm-mpath.c
+++ linux-2.6.29/drivers/md/dm-mpath.c
@@ -24,6 +24,7 @@
 
 #define DM_MSG_PREFIX "multipath"
 #define MESG_STR(x) x, sizeof(x)
+#define DM_PG_INIT_RETRY_DELAY 2
 
 /* Path properties */
 struct pgpath {
@@ -35,7 +36,7 @@ struct pgpath {
 
 	struct dm_path path;
 	struct work_struct deactivate_path;
-	struct work_struct activate_path;
+	struct delayed_work activate_path;
 };
 
 #define path_to_pgpath(__pgp) container_of((__pgp), struct pgpath, path)
@@ -69,6 +70,7 @@ struct multipath {
 	struct list_head priority_groups;
 	unsigned pg_init_required;	/* pg_init needs calling? */
 	unsigned pg_init_in_progress;	/* Only one pg_init allowed at once */
+	unsigned pg_init_delay;		/* To delay or not to delay */
 
 	unsigned nr_valid_paths;	/* Total number of usable paths */
 	struct pgpath *current_pgpath;
@@ -81,6 +83,7 @@ struct multipath {
 	unsigned saved_queue_if_no_path;/* Saved state during suspension */
 	unsigned pg_init_retries;	/* Number of times to retry pg_init */
 	unsigned pg_init_count;		/* Number of times pg_init called */
+	unsigned pg_init_delay_secs;	/* Delay in seconds before retry */
 
 	struct work_struct process_queued_ios;
 	struct bio_list queued_ios;
@@ -127,7 +130,7 @@ static struct pgpath *alloc_pgpath(void)
 	if (pgpath) {
 		pgpath->is_active = 1;
 		INIT_WORK(&pgpath->deactivate_path, deactivate_path);
-		INIT_WORK(&pgpath->activate_path, activate_path);
+		INIT_DELAYED_WORK(&pgpath->activate_path, activate_path);
 	}
 
 	return pgpath;
@@ -195,6 +198,7 @@ static struct multipath *alloc_multipath
 		INIT_LIST_HEAD(&m->priority_groups);
 		spin_lock_init(&m->lock);
 		m->queue_io = 1;
+		m->pg_init_delay_secs = DM_PG_INIT_RETRY_DELAY;
 		INIT_WORK(&m->process_queued_ios, process_queued_ios);
 		INIT_WORK(&m->trigger_event, trigger_event);
 		m->mpio_pool = mempool_create_slab_pool(MIN_IOS, _mpio_cache);
@@ -443,9 +447,12 @@ static void process_queued_ios(struct wo
 		m->pg_init_count++;
 		m->pg_init_required = 0;
 		list_for_each_entry(tmp, &pgpath->pg->pgpaths, list) {
-			queue_work(kmpath_handlerd, &tmp->activate_path);
+			queue_delayed_work(kmpath_handlerd, &tmp->activate_path,
+				m->pg_init_delay ?
+					m->pg_init_delay_secs * HZ : 0);
 			m->pg_init_in_progress++;
 		}
+		m->pg_init_delay = 0;
 	}
 out:
 	spin_unlock_irqrestore(&m->lock, flags);
@@ -714,8 +721,9 @@ static int parse_features(struct arg_set
 	const char *param_name;
 
 	static struct param _params[] = {
-		{0, 3, "invalid number of feature args"},
+		{0, 5, "invalid number of feature args"},
 		{1, 50, "pg_init_retries must be between 1 and 50"},
+		{1, 50, "pg_init_delay_secs must be between 1 and 50"},
 	};
 
 	r = read_param(_params, shift(as), &argc, &ti->error);
@@ -742,6 +750,14 @@ static int parse_features(struct arg_set
 			continue;
 		}
 
+		if (!strnicmp(param_name, MESG_STR("pg_init_delay_secs")) &&
+		    (argc >= 1)) {
+			r = read_param(_params + 1, shift(as),
+				       &m->pg_init_delay_secs, &ti->error);
+			argc--;
+			continue;
+		}
+
 		ti->error = "Unrecognised multipath feature request";
 		r = -EINVAL;
 	} while (argc && !r);
@@ -919,7 +935,7 @@ static int reinstate_path(struct pgpath 
 		queue_work(kmultipathd, &m->process_queued_ios);
 	} else if (m->hw_handler_name && (m->current_pg == pgpath->pg)) {
  		m->pg_init_in_progress++;
-		queue_work(kmpath_handlerd, &pgpath->activate_path);
+		queue_delayed_work(kmpath_handlerd, &pgpath->activate_path, 0);
 	}
 
 	dm_path_uevent(DM_UEVENT_PATH_REINSTATED, m->ti,
@@ -1053,6 +1069,7 @@ static void pg_init_done(struct dm_path 
 	struct priority_group *pg = pgpath->pg;
 	struct multipath *m = pg->m;
 	unsigned long flags;
+	unsigned int delay = 0;
 
 	/* device or driver problems */
 	switch (errors) {
@@ -1077,8 +1094,11 @@ static void pg_init_done(struct dm_path 
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
@@ -1107,8 +1127,10 @@ static void pg_init_done(struct dm_path 
 	}
 
 	m->pg_init_in_progress--;
-	if (!m->pg_init_in_progress)
+	if (!m->pg_init_in_progress) {
+		m->pg_init_delay = delay;
 		queue_work(kmultipathd, &m->process_queued_ios);
+	}
 	spin_unlock_irqrestore(&m->lock, flags);
 }
 
@@ -1116,7 +1138,7 @@ static void activate_path(struct work_st
 {
 	int ret;
 	struct pgpath *pgpath =
-		container_of(work, struct pgpath, activate_path);
+		container_of(work, struct pgpath, activate_path.work);
 
 	ret = scsi_dh_activate(bdev_get_queue(pgpath->path.dev->bdev));
 	pg_init_done(&pgpath->path, ret);
@@ -1252,11 +1274,15 @@ static int multipath_status(struct dm_ta
 		DMEMIT("2 %u %u ", m->queue_size, m->pg_init_count);
 	else {
 		DMEMIT("%u ", m->queue_if_no_path +
-			      (m->pg_init_retries > 0) * 2);
+			      (m->pg_init_retries > 0) * 2 +
+			      (m->pg_init_delay_secs !=
+						DM_PG_INIT_RETRY_DELAY) * 2);
 		if (m->queue_if_no_path)
 			DMEMIT("queue_if_no_path ");
 		if (m->pg_init_retries)
 			DMEMIT("pg_init_retries %u ", m->pg_init_retries);
+		if (m->pg_init_delay_secs != DM_PG_INIT_RETRY_DELAY)
+			DMEMIT("pg_init_delay_secs %u ", m->pg_init_delay_secs);
 	}
 
 	if (!m->hw_handler_name || type == STATUSTYPE_INFO)
