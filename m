From: malahal@us.ibm.com
Subject: [PATCH] [RFC] dm: raid1 master device selection support
Date: Wed, 9 Jan 2008 18:55:17 -0800
Message-ID: <20080110025517.GA11171@us.ibm.com>
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

This patch generates a uevent on a device failure and does NOT process
further writes until it receives 'unblock' message. LVM or other tools
are expected to get the miror-set status upon receiving the above uevent
and record the failed device in their metadata, and then send the
'unblock' message to the dm-raid1 target.

The patch is based on RHEL5.1 source, uevent related changes are yet
there in the patch.

Please comment if this is a right approach. This would help LVM select
the right master device at mirror logical volume activation/load time.

Signed-off-by: Malahal Naineni <malahal@us.ibm.com>

diff -r 019598f34c67 drivers/md/dm-raid1.c
--- a/drivers/md/dm-raid1.c	Wed Dec 05 19:02:12 2007 -0800
+++ b/drivers/md/dm-raid1.c	Wed Jan 09 18:53:39 2008 -0800
@@ -20,6 +20,9 @@
 #include <linux/time.h>
 #include <linux/vmalloc.h>
 #include <linux/workqueue.h>
+
+/* TODO: fix it by including uevents patch */
+#define dm_dev_uevent(x, y) do {} while (0)
 
 #define DM_MSG_PREFIX "raid1"
 #define DM_IO_PAGES 64
@@ -134,6 +137,7 @@ struct mirror_set {
 	region_t nr_regions;
 	int in_sync;
 	int log_failure;
+	int write_blocked;
 	atomic_t suspend;
 
 	struct mirror *default_mirror;	/* Default mirror */
@@ -851,11 +855,28 @@ static void fail_mirror(struct mirror *m
 {
 	struct mirror_set *ms = m->ms;
 	struct mirror *new;
+	unsigned long flags;
+	int generate_uevent = 0;
 
 	atomic_inc(&m->error_count);
 
 	if (atomic_read(&m->error_count) > 1)
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
+	if (generate_uevent)
+		dm_dev_uevent(DM_UEVENT_DEV_STATE, ms->ti);
 
 	if (m != ms->default_mirror)
 		return;
@@ -1143,6 +1164,13 @@ static void do_writes(struct mirror_set 
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
@@ -1225,6 +1253,13 @@ static void do_failures(struct mirror_se
 
 	if (!failures->head)
 		return;
+
+	if (ms->write_blocked) {
+		spin_lock_irq(&ms->lock);
+		bio_list_merge(&ms->failures, failures);
+		spin_unlock_irq(&ms->lock);
+		return;
+	}
 
 	if (ms->log_failure) {
 		/*
@@ -1329,6 +1364,7 @@ static struct mirror_set *alloc_context(
 	ms->nr_regions = dm_sector_div_up(ti->len, region_size);
 	ms->in_sync = 0;
 	ms->log_failure = 0;
+	ms->write_blocked = 0;
 	atomic_set(&ms->suspend, 0);
 	ms->read_mirror = &ms->mirror[DEFAULT_MIRROR];
 	ms->default_mirror = &ms->mirror[DEFAULT_MIRROR];
@@ -1755,6 +1791,64 @@ static int mirror_status(struct dm_targe
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
+	dm_dev_uevent(DM_UEVENT_DEV_STATE, ms->ti);
+	return 0;
+}
+
 static struct target_type mirror_target = {
 	.name	 = "mirror",
 	.version = {1, 2, 0},
@@ -1767,6 +1861,7 @@ static struct target_type mirror_target 
 	.postsuspend = mirror_postsuspend,
 	.resume	 = mirror_resume,
 	.status	 = mirror_status,
+	.message = mirror_message,
 };
 
 static int __init dm_mirror_init(void)
