From: malahal@us.ibm.com
Subject: [PATCH] [RFC] dm: raid1 master device selection support
Date: Mon, 4 Feb 2008 19:41:45 -0800
Message-ID: <20080205034145.GA19229@us.ibm.com>
References: <20080110025517.GA11171@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080110025517.GA11171@us.ibm.com>
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

Refreshed to linux-2.6.24-rc8-mm1.

This patch generates a uevent on a device failure and does NOT process
further writes until it receives 'unblock' message. LVM or other tools
are expected to get the miror-set status upon receiving the above uevent
and record the failed device in their metadata, and then send the
'unblock' message to the dm-raid1 target.

Please comment if this is a right approach. This would help LVM select
the right master device at mirror logical volume activation/load time.

Signed-off-by: Malahal Naineni <malahal@us.ibm.com>

diff -r 04cb7a8486f5 drivers/md/dm-raid1.c
--- a/drivers/md/dm-raid1.c	Mon Jan 28 01:05:26 2008 -0800
+++ b/drivers/md/dm-raid1.c	Mon Feb 04 19:24:59 2008 -0800
@@ -10,6 +10,7 @@
 #include "dm-io.h"
 #include "dm-log.h"
 #include "kcopyd.h"
+#include "dm-uevent.h"
 
 #include <linux/ctype.h>
 #include <linux/init.h>
@@ -139,6 +140,7 @@ struct mirror_set {
 	region_t nr_regions;
 	int in_sync;
 	int log_failure;
+	int write_blocked;
 	atomic_t suspend;
 
 	rwlock_t default_mirror_lock;
@@ -146,6 +148,7 @@ struct mirror_set {
 
 	struct workqueue_struct *kmirrord_wq;
 	struct work_struct kmirrord_work;
+	struct work_struct kmirrord_uevent;
 
 	unsigned int nr_mirrors;
 	struct mirror mirror[0];
@@ -167,6 +170,17 @@ static void wake(struct mirror_set *ms)
 static void wake(struct mirror_set *ms)
 {
 	queue_work(ms->kmirrord_wq, &ms->kmirrord_work);
+}
+
+/*
+ * FIXME: We stop processing any writes or failures when we block for
+ * writes.  Because of that the thread handling kmirrord_wq (kmirrord)
+ * mayb be in a loop executing in do_mirror(). Use schedule_work for
+ * now.
+ */
+static void send_uevents(struct mirror_set *ms)
+{
+	schedule_work(&ms->kmirrord_uevent);
 }
 
 /* FIXME move this */
@@ -706,6 +720,8 @@ static void fail_mirror(struct mirror *m
 {
 	struct mirror_set *ms = m->ms;
 	struct mirror *new;
+	unsigned long flags;
+	int generate_uevent = 0;
 
 	if (!errors_handled(ms))
 		return;
@@ -719,6 +735,23 @@ static void fail_mirror(struct mirror *m
 	 */
 	if (atomic_inc_return(&m->error_count) > 1)
 		return;
+
+	/*
+	 * Make sure that device failure is recorded in the metadata
+	 * before allowing any new writes. Agent acting on the following
+	 * uevent should query the status of the mirrorset, update
+	 * metadata accordingly and then send the unblock message.
+	 */
+	spin_lock_irqsave(&ms->lock, flags);
+	if (!ms->write_blocked) {
+		ms->write_blocked = 1;
+		generate_uevent = 1;
+	}
+	spin_unlock_irqrestore(&ms->lock, flags);
+	if (generate_uevent) {
+		dm_dev_uevent(DM_UEVENT_DEV_CHANGE, ms->ti);
+		send_uevents(ms);
+	}
 
 	if (m != get_default_mirror(ms))
 		return;
@@ -1117,6 +1150,13 @@ static void do_writes(struct mirror_set 
 	if (!writes->head)
 		return;
 
+	if (ms->write_blocked) {
+		spin_lock_irq(&ms->lock);
+		bio_list_merge(&ms->writes, writes);
+		spin_unlock_irq(&ms->lock);
+		return;
+	}
+
 	/*
 	 * Classify each write.
 	 */
@@ -1179,6 +1219,13 @@ static void do_failures(struct mirror_se
 
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
 		dm_table_event(ms->ti->table);
@@ -1267,6 +1314,13 @@ static void do_mirror(struct work_struct
 		schedule();
 }
 
+static void _send_uevents(struct work_struct *work)
+{
+	struct mirror_set *ms = container_of(work, struct mirror_set,
+					     kmirrord_uevent);
+
+	dm_table_event(ms->ti->table);
+}
 
 /*-----------------------------------------------------------------
  * Target functions
@@ -1297,6 +1351,7 @@ static struct mirror_set *alloc_context(
 	ms->nr_regions = dm_sector_div_up(ti->len, region_size);
 	ms->in_sync = 0;
 	ms->log_failure = 0;
+	ms->write_blocked = 0;
 	atomic_set(&ms->suspend, 0);
 	atomic_set(&ms->default_mirror, DEFAULT_MIRROR);
 
@@ -1505,6 +1560,7 @@ static int mirror_ctr(struct dm_target *
 		goto err_free_context;
 	}
 	INIT_WORK(&ms->kmirrord_work, do_mirror);
+	INIT_WORK(&ms->kmirrord_uevent, _send_uevents);
 
 	r = parse_features(ms, argc, argv, &args_used);
 	if (r)
@@ -1789,6 +1845,65 @@ static int mirror_status(struct dm_targe
 	return 0;
 }
 
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
+	int recorded_state, actual_state;
+	char *name;	/* major:minor format */
+	int i;
+
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
+		if (sscanf(argv[2 * i + 1], "%u", &recorded_state) != 1) {
+			DMWARN("incorrect recorded state value");
+			goto error;
+		}
+
+		actual_state = !atomic_read(&(ms->mirror[i].error_count));
+
+		/* Re-generate uevent if the actual device state has
+		 * changed since we last reported.
+		 */
+		if (recorded_state != actual_state)
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
+	send_uevents(ms);
+	return 0;
+}
+
 static struct target_type mirror_target = {
 	.name	 = "mirror",
 	.version = {1, 0, 20},
@@ -1801,6 +1916,7 @@ static struct target_type mirror_target 
 	.postsuspend = mirror_postsuspend,
 	.resume	 = mirror_resume,
 	.status	 = mirror_status,
+	.message = mirror_message,
 };
 
 static int __init dm_mirror_init(void)
diff -r 04cb7a8486f5 drivers/md/dm-uevent.c
--- a/drivers/md/dm-uevent.c	Mon Jan 28 01:05:26 2008 -0800
+++ b/drivers/md/dm-uevent.c	Mon Feb 04 19:24:59 2008 -0800
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
+		      __FUNCTION__);
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
+		DMERR("%s: dm_uevent_alloc() failed", __FUNCTION__);
+		goto err_nomem;
+	}
+
+	event->action = action;
+
+	if (add_uevent_var(&event->ku_env, "DM_TARGET=%s", ti->type->name)) {
+		DMERR("%s: add_uevent_var() for DM_TARGET failed",
+		      __FUNCTION__);
+		goto err_add;
+	}
+
+	if (add_uevent_var(&event->ku_env, "DM_ACTION=%s", dm_action)) {
+		DMERR("%s: add_uevent_var() for DM_ACTION failed",
+		      __FUNCTION__);
+		goto err_add;
+	}
+
+	if (add_uevent_var(&event->ku_env, "DM_SEQNUM=%u",
+			   dm_next_uevent_seq(md))) {
+		DMERR("%s: add_uevent_var() for DM_SEQNUM failed",
 		      __FUNCTION__);
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
+		DMERR("%s: Invalid event_type %d", __FUNCTION__, event_type);
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
diff -r 04cb7a8486f5 drivers/md/dm-uevent.h
--- a/drivers/md/dm-uevent.h	Mon Jan 28 01:05:26 2008 -0800
+++ b/drivers/md/dm-uevent.h	Mon Feb 04 19:24:59 2008 -0800
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
 
