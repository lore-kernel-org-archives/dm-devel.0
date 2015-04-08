From: heinzm@redhat.com
Subject: [PATCH 1/2] dm-raid1: [PATCH RFC] dm-raid1: keep writing
	after leg failure
Date: Wed,  8 Apr 2015 14:27:33 +0200
Message-ID: <1428496054-5837-2-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>


Lidongs initial patch rebased to 4.0.0-rc7

---
 drivers/md/dm-raid1.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 089d627..ef5f20c 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -24,7 +24,9 @@
 #define MAX_RECOVERY 1	/* Maximum number of regions recovered in parallel. */
 
 #define DM_RAID1_HANDLE_ERRORS 0x01
+#define DM_RAID1_KEEP_LOG      0x02
 #define errors_handled(p)	((p)->features & DM_RAID1_HANDLE_ERRORS)
+#define keep_log(p)	        ((p)->features & DM_RAID1_KEEP_LOG)
 
 static DECLARE_WAIT_QUEUE_HEAD(_kmirrord_recovery_stopped);
 
@@ -759,7 +761,7 @@ static void do_writes(struct mirror_set *ms, struct bio_list *writes)
 		dm_rh_delay(ms->rh, bio);
 
 	while ((bio = bio_list_pop(&nosync))) {
-		if (unlikely(ms->leg_failure) && errors_handled(ms)) {
+		if (unlikely(ms->leg_failure) && errors_handled(ms) && !keep_log(ms)) {
 			spin_lock_irq(&ms->lock);
 			bio_list_add(&ms->failures, bio);
 			spin_unlock_irq(&ms->lock);
@@ -809,9 +811,19 @@ static void do_failures(struct mirror_set *ms, struct bio_list *failures)
 		 * be wrong if the failed leg returned after reboot and
 		 * got replicated back to the good legs.)
 		 */
-		if (!get_valid_mirror(ms))
+
+		/*
+		 * we return EIO when the log device is failed if keep_log is set
+		 */
+		if (!get_valid_mirror(ms) || (keep_log(ms) && !ms->log_failure))
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
@@ -1014,8 +1026,15 @@ static int parse_features(struct mirror_set *ms, unsigned argc, char **argv,
 		return -EINVAL;
 	}
 
+	argc--;
+	argv++;
 	(*args_used)++;
 
+	if (!strcmp("keep_log", argv[0])) {
+		ms->features |= DM_RAID1_KEEP_LOG;
+		(*args_used)++;
+	}
+
 	return 0;
 }
 
@@ -1394,8 +1413,11 @@ static void mirror_status(struct dm_target *ti, status_type_t type,
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
2.1.0
