From: malahal@us.ibm.com
Subject: [PATCH] dm: raid1 block-on-error patch
Date: Tue, 1 Apr 2008 16:21:23 -0700
Message-ID: <20080401232123.GA19676@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Refreshed to linux-2.6.25-rc5-mm1.

This patch generates a uevent on a device failure and does NOT process
further writes until it receives 'unblock' message. LVM or other tools
are expected to get the miror-set status upon receiving the above uevent
and record the failed device in their metadata, and then send the
'unblock' message to the dm-raid1 target.

Please comment. This would help LVM select the right master device at
mirror logical volume activation/load time.

Signed-off-by: Malahal Naineni <malahal@us.ibm.com>

diff -r bfb50ef53671 drivers/md/dm-raid1.c
--- a/drivers/md/dm-raid1.c	Mon Mar 31 10:13:13 2008 -0700
+++ b/drivers/md/dm-raid1.c	Tue Apr 01 16:09:09 2008 -0700
@@ -10,6 +10,7 @@
 #include "dm-io.h"
 #include "dm-log.h"
 #include "kcopyd.h"
+#include "dm-uevent.h"
 
 #include <linux/ctype.h>
 #include <linux/init.h>
@@ -26,8 +27,11 @@
 #define DM_MSG_PREFIX "raid1"
 #define DM_IO_PAGES 64
 
-#define DM_RAID1_HANDLE_ERRORS 0x01
+#define DM_RAID1_HANDLE_ERRORS  0x01
+#define DM_RAID1_BLOCK_ON_ERROR 0x02
 #define errors_handled(p)	((p)->features & DM_RAID1_HANDLE_ERRORS)
+#define block_on_error(p)	((p)->features & DM_RAID1_BLOCK_ON_ERROR)
+#define handle_all_errors(p)	(errors_handled(p) || block_on_error(p))
 
 static DECLARE_WAIT_QUEUE_HEAD(_kmirrord_recovery_stopped);
 
@@ -148,6 +152,7 @@ struct mirror_set {
 	region_t nr_regions;
 	int in_sync;
 	int log_failure;
+	int write_blocked;
 	atomic_t suspend;
 
 	atomic_t default_mirror;	/* Default mirror */
@@ -443,7 +448,7 @@ static void rh_update_states(struct regi
 	}
 
 	list_for_each_entry_safe(reg, next, &failed_recovered, list) {
-		complete_resync_work(reg, errors_handled(rh->ms) ? 0 : 1);
+		complete_resync_work(reg, handle_all_errors(rh->ms) ? 0 : 1);
 		mempool_free(reg, rh->region_pool);
 	}
 
@@ -706,8 +711,10 @@ static void fail_mirror(struct mirror *m
 {
 	struct mirror_set *ms = m->ms;
 	struct mirror *new;
+	unsigned long flags;
+	int generate_uevent = 0;
 
-	if (!errors_handled(ms))
+	if (!handle_all_errors(ms))
 		return;
 
 	/*
@@ -719,6 +726,25 @@ static void fail_mirror(struct mirror *m
 
 	if (test_and_set_bit(error_type, &m->error_type))
 		return;
+
+	/*
+	 * Make sure that device failure is recorded in the metadata
+	 * before allowing any new writes. Agent acting on the following
+	 * uevent should query the status of the mirrorset, update
+	 * metadata accordingly and then send the unblock message.
+	 */
+	if (block_on_error(ms)) {
+		spin_lock_irqsave(&ms->lock, flags);
+		if (!ms->write_blocked) {
+			ms->write_blocked = 1;
+			generate_uevent = 1;
+		}
+		spin_unlock_irqrestore(&ms->lock, flags);
+		if (generate_uevent) {
+			dm_dev_uevent(DM_UEVENT_DEV_CHANGE, ms->ti);
+			schedule_work(&ms->trigger_event);
+		}
+	}
 
 	if (m != get_default_mirror(ms))
 		goto out;
@@ -835,6 +861,7 @@ static void do_recovery(struct mirror_se
 	int r;
 	struct region *reg;
 	struct dm_dirty_log *log = ms->rh.log;
+	struct mirror *m;
 
 	/*
 	 * Start quiescing some regions.
@@ -855,6 +882,10 @@ static void do_recovery(struct mirror_se
 	 */
 	if (!ms->in_sync &&
 	    (log->type->get_sync_count(log) == ms->nr_regions)) {
+		for (m = ms->mirror; m < ms->mirror + ms->nr_mirrors; m++) {
+			atomic_set(&m->error_count, 0);
+			m->error_type = 0;
+		}
 		/* the sync is complete */
 		dm_table_event(ms->ti->table);
 		ms->in_sync = 1;
@@ -1086,7 +1117,7 @@ static void write_callback(unsigned long
 		DMERR("All replicated volumes dead, failing I/O");
 		/* None of the writes succeeded, fail the I/O. */
 		ret = -EIO;
-	} else if (errors_handled(ms)) {
+	} else if (handle_all_errors(ms)) {
 		/*
 		 * Need to raise event.  Since raising
 		 * events can block, we need to do it in
@@ -1139,6 +1170,13 @@ static void do_writes(struct mirror_set 
 
 	if (!writes->head)
 		return;
+
+	if (ms->write_blocked) {
+		spin_lock_irq(&ms->lock);
+		bio_list_merge(&ms->writes, writes);
+		spin_unlock_irq(&ms->lock);
+		return;
+	}
 
 	/*
 	 * Classify each write.
@@ -1202,6 +1240,13 @@ static void do_failures(struct mirror_se
 
 	if (!failures->head)
 		return;
+
+	if (ms->write_blocked) {
+		spin_lock_irq(&ms->lock);
+		bio_list_merge(&ms->failures, failures);
+		spin_unlock_irq(&ms->lock);
+		return;
+	}
 
 	if (!ms->log_failure) {
 		while ((bio = bio_list_pop(failures)))
@@ -1297,7 +1342,6 @@ static void do_mirror(struct work_struct
 		schedule();
 }
 
-
 /*-----------------------------------------------------------------
  * Target functions
  *---------------------------------------------------------------*/
@@ -1327,6 +1371,7 @@ static struct mirror_set *alloc_context(
 	ms->nr_regions = dm_sector_div_up(ti->len, region_size);
 	ms->in_sync = 0;
 	ms->log_failure = 0;
+	ms->write_blocked = 0;
 	atomic_set(&ms->suspend, 0);
 	atomic_set(&ms->default_mirror, DEFAULT_MIRROR);
 
@@ -1448,6 +1493,7 @@ static int parse_features(struct mirror_
 {
 	unsigned num_features;
 	struct dm_target *ti = ms->ti;
+	int i;
 
 	*args_used = 0;
 
@@ -1458,24 +1504,25 @@ static int parse_features(struct mirror_
 		ti->error = "Invalid number of features";
 		return -EINVAL;
 	}
+	argv++, argc--;
 
-	argc--;
-	argv++;
-	(*args_used)++;
-
-	if (num_features > argc) {
+	if (argc < num_features) {
 		ti->error = "Not enough arguments to support feature count";
 		return -EINVAL;
 	}
 
-	if (!strcmp("handle_errors", argv[0]))
-		ms->features |= DM_RAID1_HANDLE_ERRORS;
-	else {
-		ti->error = "Unrecognised feature requested";
-		return -EINVAL;
+	for (i = 0; i < num_features; i++) {
+		if (!strcmp("handle_errors", argv[i]))
+			ms->features |= DM_RAID1_HANDLE_ERRORS;
+		else if (!strcmp("block_on_error", argv[i]))
+			ms->features |= DM_RAID1_BLOCK_ON_ERROR;
+		else {
+			ti->error = "Unrecognised feature requested";
+			return -EINVAL;
+		}
 	}
 
-	(*args_used)++;
+	*args_used = 1 + num_features;
 
 	return 0;
 }
@@ -1789,6 +1836,7 @@ static void mirror_resume(struct dm_targ
  *
  * We return one character representing the most severe error
  * we have encountered.
+ *    M => Master - Has the latest data, can serve as a mirror Master
  *    A => Alive - No failures
  *    D => Dead - A write failure occurred leaving mirror out-of-sync
  *    S => Sync - A sychronization failure occurred, mirror out-of-sync
@@ -1798,6 +1846,14 @@ static void mirror_resume(struct dm_targ
  */
 static char device_status_char(struct mirror *m)
 {
+	struct mirror_set *ms = m->ms;
+
+	if (block_on_error(ms)) {
+		if (atomic_read(&m->error_count) == 0 &&
+		    (ms->in_sync || get_default_mirror(ms) == m))
+			return 'M';
+	}
+
 	if (!atomic_read(&(m->error_count)))
 		return 'A';
 
@@ -1840,10 +1896,73 @@ static int mirror_status(struct dm_targe
 			DMEMIT(" %s %llu", ms->mirror[m].dev->name,
 			       (unsigned long long)ms->mirror[m].offset);
 
-		if (ms->features & DM_RAID1_HANDLE_ERRORS)
+		if (errors_handled(ms) && block_on_error(ms))
+			DMEMIT(" 2 handle_errors block_on_error");
+		else if (errors_handled(ms))
 			DMEMIT(" 1 handle_errors");
+		else if (block_on_error(ms))
+			DMEMIT(" 1 block_on_error");
 	}
 
+	return 0;
+}
+
+/* unblock message handler
+ *
+ * This message has the mirror device recorded states. If they don't
+ * agree to the actual state in the target, we regenerate uvent. If the
+ * recorded state and the actual of state of each device is same, we
+ * unblock the mirrorset to allow writes.
+ */
+static int mirror_message(struct dm_target *ti, unsigned argc, char **argv)
+{
+	struct mirror_set *ms = (struct mirror_set *) ti->private;
+	char device_status;
+	char *name;	/* major:minor format */
+	int i;
+
+	if (!block_on_error(ms))
+		return -EINVAL;
+	if (argc < 1 || strnicmp(argv[0], "unblock", sizeof("unblock")))
+		return -EINVAL;
+	argv++;
+	argc--;
+
+	spin_lock_irq(&ms->lock);
+	if (!ms->write_blocked)
+		DMWARN("Received unblock message when not blocked!");
+	if (argc != 2 * ms->nr_mirrors)
+		goto error;
+
+	for (i = 0; i < ms->nr_mirrors; i++) {
+		name = argv[2 * i];
+		if (strncmp(name, ms->mirror[i].dev->name,
+			   sizeof(ms->mirror[i].dev->name))) {
+			DMWARN("name %s doesn't match name %s\n", name,
+			       (ms->mirror[i].dev->name));
+			goto error;
+		}
+		if (sscanf(argv[2 * i + 1], "%c", &device_status) != 1) {
+			DMWARN("incorrect recorded state value");
+			goto error;
+		}
+
+		/* Re-generate uevent if the actual device state has
+		 * changed since we last reported.
+		 */
+		if (device_status != device_status_char(&ms->mirror[i]))
+			goto error;
+	}
+	ms->write_blocked = 0;
+	spin_unlock_irq(&ms->lock);
+	wake(ms);
+	return 0;
+
+error:
+	/* Regenerate the event */
+	spin_unlock_irq(&ms->lock);
+	dm_dev_uevent(DM_UEVENT_DEV_CHANGE, ms->ti);
+	schedule_work(&ms->trigger_event);
 	return 0;
 }
 
@@ -1859,6 +1978,7 @@ static struct target_type mirror_target 
 	.postsuspend = mirror_postsuspend,
 	.resume	 = mirror_resume,
 	.status	 = mirror_status,
+	.message = mirror_message,
 };
 
 static int __init dm_mirror_init(void)
diff -r bfb50ef53671 drivers/md/dm-uevent.c
--- a/drivers/md/dm-uevent.c	Mon Mar 31 10:13:13 2008 -0700
+++ b/drivers/md/dm-uevent.c	Tue Apr 01 16:09:09 2008 -0700
@@ -35,6 +35,7 @@ static const struct {
 } _dm_uevent_type_names[] = {
 	{DM_UEVENT_PATH_FAILED, KOBJ_CHANGE, "PATH_FAILED"},
 	{DM_UEVENT_PATH_REINSTATED, KOBJ_CHANGE, "PATH_REINSTATED"},
+	{DM_UEVENT_DEV_CHANGE, KOBJ_CHANGE, "TARGET_STATE_CHANGE"},
 };
 
 static struct kmem_cache *_dm_event_cache;
@@ -111,6 +112,48 @@ static struct dm_uevent *dm_build_path_u
 	if (add_uevent_var(&event->ku_env, "DM_NR_VALID_PATHS=%d",
 			   nr_valid_paths)) {
 		DMERR("%s: add_uevent_var() for DM_NR_VALID_PATHS failed",
+		      __func__);
+		goto err_add;
+	}
+
+	return event;
+
+err_add:
+	dm_uevent_free(event);
+err_nomem:
+	return ERR_PTR(-ENOMEM);
+}
+
+static struct dm_uevent *dm_build_dev_uevent(struct mapped_device *md,
+					      struct dm_target *ti,
+					      enum kobject_action action,
+					      const char *dm_action)
+{
+	struct dm_uevent *event;
+
+	event = dm_uevent_alloc(md);
+	if (!event) {
+		DMERR("%s: dm_uevent_alloc() failed", __func__);
+		goto err_nomem;
+	}
+
+	event->action = action;
+
+	if (add_uevent_var(&event->ku_env, "DM_TARGET=%s", ti->type->name)) {
+		DMERR("%s: add_uevent_var() for DM_TARGET failed",
+		      __func__);
+		goto err_add;
+	}
+
+	if (add_uevent_var(&event->ku_env, "DM_ACTION=%s", dm_action)) {
+		DMERR("%s: add_uevent_var() for DM_ACTION failed",
+		      __func__);
+		goto err_add;
+	}
+
+	if (add_uevent_var(&event->ku_env, "DM_SEQNUM=%u",
+			   dm_next_uevent_seq(md))) {
+		DMERR("%s: add_uevent_var() for DM_SEQNUM failed",
 		      __func__);
 		goto err_add;
 	}
@@ -205,6 +248,36 @@ out:
 }
 EXPORT_SYMBOL_GPL(dm_path_uevent);
 
+/**
+ * dm_dev_uevent - called to create a new dev event and queue it
+ *
+ * @event_type:	dev event type enum
+ * @ti:		pointer to a dm_target
+ *
+ */
+void dm_dev_uevent(enum dm_uevent_type event_type, struct dm_target *ti)
+{
+	struct mapped_device *md = dm_table_get_md(ti->table);
+	struct dm_uevent *event;
+
+	if (event_type >= ARRAY_SIZE(_dm_uevent_type_names)) {
+		DMERR("%s: Invalid event_type %d", __func__, event_type);
+		goto out;
+	}
+
+	event = dm_build_dev_uevent(md, ti,
+				     _dm_uevent_type_names[event_type].action,
+				     _dm_uevent_type_names[event_type].name);
+	if (IS_ERR(event))
+		goto out;
+
+	dm_uevent_add(md, &event->elist);
+
+out:
+	dm_put(md);
+}
+EXPORT_SYMBOL_GPL(dm_dev_uevent);
+
 int dm_uevent_init(void)
 {
 	_dm_event_cache = KMEM_CACHE(dm_uevent, 0);
diff -r bfb50ef53671 drivers/md/dm-uevent.h
--- a/drivers/md/dm-uevent.h	Mon Mar 31 10:13:13 2008 -0700
+++ b/drivers/md/dm-uevent.h	Tue Apr 01 16:09:09 2008 -0700
@@ -24,6 +24,7 @@ enum dm_uevent_type {
 enum dm_uevent_type {
 	DM_UEVENT_PATH_FAILED,
 	DM_UEVENT_PATH_REINSTATED,
+	DM_UEVENT_DEV_CHANGE,
 };
 
 #ifdef CONFIG_DM_UEVENT
@@ -34,6 +35,8 @@ extern void dm_path_uevent(enum dm_ueven
 extern void dm_path_uevent(enum dm_uevent_type event_type,
 			   struct dm_target *ti, const char *path,
 			   unsigned nr_valid_paths);
+extern void dm_dev_uevent(enum dm_uevent_type event_type,
+			  struct dm_target *ti);
 
 #else
 
@@ -53,6 +56,10 @@ static inline void dm_path_uevent(enum d
 				  unsigned nr_valid_paths)
 {
 }
+static inline void dm_dev_uevent(enum dm_uevent_type event_type,
+				 struct dm_target *ti)
+{
+}
 
 #endif	/* CONFIG_DM_UEVENT */
 
