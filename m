From: malahal@us.ibm.com
Subject: Re: [PATCH] dm: raid1 block-on-error patch
Date: Sun, 27 Apr 2008 13:42:30 -0700
Message-ID: <20080427204230.GA17725@us.ibm.com>
References: <20080401233150.GA19821@us.ibm.com>
	<FD6EF7F6-5CA1-42F3-A0AA-CB558A731331@redhat.com>
	<20080420213405.GA16156@us.ibm.com>
	<D43DF1A9-ABF2-4530-BD13-36E7F02C5ED6@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <D43DF1A9-ABF2-4530-BD13-36E7F02C5ED6@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: andmike@us.ibm.com, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Jonathan Brassow [jbrassow@redhat.com] wrote:
> Looks good, but be sure to comment on the new 'U' character in the comments 
> for device_status_char()
>
>  brassow

Thank you Jonathan. Fixed the above comment and also refreshed to
2.6.25-mm1

--Malahal.


This patch generates an event on a device failure and does NOT process
further writes until it receives 'unblock' message. LVM or other tools
are expected to get the mirorset status upon receiving the above event
and record the failed device in their metadata, and then send the
'unblock' message to the dm-raid1 target.

This would help LVM select the right master device at mirror logical
volume activation/load time.

Signed-off-by: Malahal Naineni <malahal@us.ibm.com>

diff -r 7a22ba2fedc1 drivers/md/dm-raid1.c
--- a/drivers/md/dm-raid1.c	Sun Apr 27 13:26:18 2008 -0700
+++ b/drivers/md/dm-raid1.c	Sun Apr 27 13:28:01 2008 -0700
@@ -26,8 +26,10 @@
 #define DM_MSG_PREFIX "raid1"
 #define DM_IO_PAGES 64
 
-#define DM_RAID1_HANDLE_ERRORS 0x01
+#define DM_RAID1_HANDLE_ERRORS  0x01
+#define DM_RAID1_BLOCK_ON_ERROR 0x02
 #define errors_handled(p)	((p)->features & DM_RAID1_HANDLE_ERRORS)
+#define block_on_error(p)	((p)->features & DM_RAID1_BLOCK_ON_ERROR)
 
 static DECLARE_WAIT_QUEUE_HEAD(_kmirrord_recovery_stopped);
 
@@ -148,6 +150,7 @@
 	region_t nr_regions;
 	int in_sync;
 	int log_failure;
+	int write_blocked;
 	atomic_t suspend;
 
 	atomic_t default_mirror;	/* Default mirror */
@@ -726,6 +729,7 @@
 {
 	struct mirror_set *ms = m->ms;
 	struct mirror *new;
+	unsigned long flags;
 
 	if (!errors_handled(ms))
 		return;
@@ -739,6 +743,18 @@
 
 	if (test_and_set_bit(error_type, &m->error_type))
 		return;
+
+	/*
+	 * Make sure that device failure is recorded in the metadata
+	 * before allowing any new writes. Agent acting on the following
+	 * event should query the status of the mirrorset, update
+	 * metadata accordingly and then send the unblock message.
+	 */
+	if (block_on_error(ms)) {
+		spin_lock_irqsave(&ms->lock, flags);
+		ms->write_blocked = 1;
+		spin_unlock_irqrestore(&ms->lock, flags);
+	}
 
 	if (m != get_default_mirror(ms))
 		goto out;
@@ -854,6 +870,7 @@
 	int r;
 	struct region *reg;
 	struct dm_dirty_log *log = ms->rh.log;
+	struct mirror *m;
 
 	/*
 	 * Start quiescing some regions.
@@ -874,6 +891,10 @@
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
@@ -1159,6 +1180,13 @@
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
@@ -1222,6 +1250,13 @@
 
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
@@ -1329,6 +1364,7 @@
 	ms->nr_regions = dm_sector_div_up(ti->len, region_size);
 	ms->in_sync = 0;
 	ms->log_failure = 0;
+	ms->write_blocked = 0;
 	atomic_set(&ms->suspend, 0);
 	atomic_set(&ms->default_mirror, DEFAULT_MIRROR);
 
@@ -1450,6 +1486,7 @@
 {
 	unsigned num_features;
 	struct dm_target *ti = ms->ti;
+	int i;
 
 	*args_used = 0;
 
@@ -1460,24 +1497,26 @@
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
+		else if (!strcmp("block_on_error", argv[i])) {
+			ms->features |= DM_RAID1_BLOCK_ON_ERROR;
+			ms->features |= DM_RAID1_HANDLE_ERRORS;
+		} else {
+			ti->error = "Unrecognised feature requested";
+			return -EINVAL;
+		}
 	}
 
-	(*args_used)++;
+	*args_used = 1 + num_features;
 
 	return 0;
 }
@@ -1795,6 +1834,7 @@
  * We return one character representing the most severe error
  * we have encountered.
  *    A => Alive - No failures
+ *    U => Undef - No failures but out of sync (sync is in progress)
  *    D => Dead - A write failure occurred leaving mirror out-of-sync
  *    S => Sync - A sychronization failure occurred, mirror out-of-sync
  *    R => Read - A read failure occurred, mirror data unaffected
@@ -1803,8 +1843,14 @@
  */
 static char device_status_char(struct mirror *m)
 {
-	if (!atomic_read(&(m->error_count)))
-		return 'A';
+	struct mirror_set *ms = m->ms;
+
+	if (atomic_read(&m->error_count) == 0) {
+		if (ms->in_sync || get_default_mirror(ms) == m)
+			return 'A';
+		else
+			return 'U';
+	}
 
 	return (test_bit(DM_RAID1_WRITE_ERROR, &(m->error_type))) ? 'D' :
 		(test_bit(DM_RAID1_SYNC_ERROR, &(m->error_type))) ? 'S' :
@@ -1845,10 +1891,74 @@
 			DMEMIT(" %s %llu", ms->mirror[m].dev->name,
 			       (unsigned long long)ms->mirror[m].offset);
 
-		if (ms->features & DM_RAID1_HANDLE_ERRORS)
+		/*
+		 * 'handle_errors' is implicit with 'block_on_error', so
+		 * check block_on_error first.
+		 */
+		if (block_on_error(ms))
+			DMEMIT(" 1 block_on_error");
+		else if (errors_handled(ms))
 			DMEMIT(" 1 handle_errors");
 	}
 
+	return 0;
+}
+
+/* unblock message handler
+ *
+ * This message has the mirror device recorded states. If they don't
+ * agree to the actual state in the target, we regenerate uvent. If the
+ * recorded state and the actual state of each device is same, we
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
+		/* Re-generate event if the actual device state has
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
+	schedule_work(&ms->trigger_event);
 	return 0;
 }
 
@@ -1864,6 +1974,7 @@
 	.postsuspend = mirror_postsuspend,
 	.resume	 = mirror_resume,
 	.status	 = mirror_status,
+	.message = mirror_message,
 };
 
 static int __init dm_mirror_init(void)
