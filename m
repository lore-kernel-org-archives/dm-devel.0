From: Lidong Zhong <lzhong@suse.com>
Subject: [PATCH] dm-raid1: keep writing after leg failure
Date: Wed, 13 May 2015 14:04:10 +0800
Message-ID: <1431497050-10098-1-git-send-email-lzhong@suse.com>
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
To: dm-devel@redhat.com
Cc: lwang@suse.com, heinzm@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

Currently if there is a leg failure, the bio will be put into the hold
list until userspace replace/remove the leg. Here we are trying to make
dm-raid1 ignore the failure and keep the following bios going on.
This is because there maybe a temporary path failure in clvmd
which leads to cluster raid1 remove/replace the fake device failure. And
it takes a long time to do the full sync if we readd the device back.

This patch merges the former five small patches to implement this
feature. The userspace should pass "keep_log" into kernel to make this feature to
take effect when creating dm-raid1, same as "handle_errors".

Signed-off-by: Lidong Zhong <lzhong@suse.com>
Tested-by: Liuhua Wang <lwang@suse.com>
---
 drivers/md/dm-raid1.c | 62 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 49 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 089d627..3de48d1 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -24,7 +24,9 @@
 #define MAX_RECOVERY 1	/* Maximum number of regions recovered in parallel. */
 
 #define DM_RAID1_HANDLE_ERRORS 0x01
+#define DM_RAID1_KEEP_LOG      0x02
 #define errors_handled(p)	((p)->features & DM_RAID1_HANDLE_ERRORS)
+#define keep_log(p)	        ((p)->features & DM_RAID1_KEEP_LOG)
 
 static DECLARE_WAIT_QUEUE_HEAD(_kmirrord_recovery_stopped);
 
@@ -229,7 +231,7 @@ static void fail_mirror(struct mirror *m, enum dm_raid1_error error_type)
 	if (m != get_default_mirror(ms))
 		goto out;
 
-	if (!ms->in_sync) {
+	if (!ms->in_sync && !keep_log(ms)) {
 		/*
 		 * Better to issue requests to same failing device
 		 * than to risk returning corrupt data.
@@ -370,6 +372,17 @@ static int recover(struct mirror_set *ms, struct dm_region *reg)
 	return r;
 }
 
+static void reset_ms_flags(struct mirror_set *ms)
+{
+	unsigned int m;
+
+	ms->leg_failure = 0;
+	for (m = 0; m < ms->nr_mirrors; m++) {
+		atomic_set(&(ms->mirror[m].error_count), 0);
+		ms->mirror[m].error_type = 0;
+	}
+}
+
 static void do_recovery(struct mirror_set *ms)
 {
 	struct dm_region *reg;
@@ -398,6 +411,7 @@ static void do_recovery(struct mirror_set *ms)
 		/* the sync is complete */
 		dm_table_event(ms->ti->table);
 		ms->in_sync = 1;
+		reset_ms_flags(ms);
 	}
 }
 
@@ -759,7 +773,7 @@ static void do_writes(struct mirror_set *ms, struct bio_list *writes)
 		dm_rh_delay(ms->rh, bio);
 
 	while ((bio = bio_list_pop(&nosync))) {
-		if (unlikely(ms->leg_failure) && errors_handled(ms)) {
+		if (unlikely(ms->leg_failure) && errors_handled(ms) && !keep_log(ms)) {
 			spin_lock_irq(&ms->lock);
 			bio_list_add(&ms->failures, bio);
 			spin_unlock_irq(&ms->lock);
@@ -809,9 +823,21 @@ static void do_failures(struct mirror_set *ms, struct bio_list *failures)
 		 * be wrong if the failed leg returned after reboot and
 		 * got replicated back to the good legs.)
 		 */
-		if (!get_valid_mirror(ms))
+
+		/*
+		 * We return EIO when there's no valid mirror legs
+		 * -or-
+		 * the log device is failed if keep_log is set
+		 */
+		if (unlikely(!get_valid_mirror(ms) || (keep_log(ms) && ms->log_failure)))
 			bio_endio(bio, -EIO);
-		else if (errors_handled(ms))
+		/*
+		 * After the userspace get noticed that the leg has failed,
+		 * we just pretend that the bio has suceeded since the region 
+		 * has already been marked nosync. It's OK do the recovery after
+		 * the device comes back
+		 */
+		else if (errors_handled(ms) && !keep_log(ms))
 			hold_bio(ms, bio);
 		else
 			bio_endio(bio, 0);
@@ -987,6 +1013,7 @@ static int parse_features(struct mirror_set *ms, unsigned argc, char **argv,
 	unsigned num_features;
 	struct dm_target *ti = ms->ti;
 	char dummy;
+	int i;
 
 	*args_used = 0;
 
@@ -1007,14 +1034,20 @@ static int parse_features(struct mirror_set *ms, unsigned argc, char **argv,
 		return -EINVAL;
 	}
 
-	if (!strcmp("handle_errors", argv[0]))
-		ms->features |= DM_RAID1_HANDLE_ERRORS;
-	else {
-		ti->error = "Unrecognised feature requested";
-		return -EINVAL;
-	}
+	for (i = 0; i < num_features; i++) {
+		if (!strcmp("handle_errors", argv[0]))
+			ms->features |= DM_RAID1_HANDLE_ERRORS;
+		else if (!strcmp("keep_log", argv[0])) 
+			ms->features |= DM_RAID1_KEEP_LOG;
+		else {
+			ti->error = "Unrecognised feature requested";
+			return -EINVAL;
+		}
 
-	(*args_used)++;
+		argc--;
+		argv++;
+		(*args_used)++;
+	}
 
 	return 0;
 }
@@ -1029,7 +1062,7 @@ static int parse_features(struct mirror_set *ms, unsigned argc, char **argv,
  * log_type is "core" or "disk"
  * #log_params is between 1 and 3
  *
- * If present, features must be "handle_errors".
+ * If present, features must be "handle_errors" and/or "keep_log".
  */
 static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
@@ -1394,8 +1427,11 @@ static void mirror_status(struct dm_target *ti, status_type_t type,
 			DMEMIT(" %s %llu", ms->mirror[m].dev->name,
 			       (unsigned long long)ms->mirror[m].offset);
 
-		if (ms->features & DM_RAID1_HANDLE_ERRORS)
+		if (errors_handled(ms) && keep_log(ms))
+			DMEMIT(" 2 handle_errors keep_log");
+		else if (errors_handled(ms))
 			DMEMIT(" 1 handle_errors");
+
 	}
 }
 
-- 
1.8.1.4
