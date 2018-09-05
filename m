From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH 4/5] dm-raid: share decipher_sync_action
Date: Wed,  5 Sep 2018 19:36:44 +0200
Message-ID: <1f72d1f0983256e92994601825bb73617d00ae5b.1536167421.git.heinzm@redhat.com>
References: <cover.1536167421.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1536167421.git.heinzm@redhat.com>
In-Reply-To: <cover.1536167421.git.heinzm@redhat.com>
References: <cover.1536167421.git.heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

decipher_sync_action() is only called from raid_status() thus
duplicating tests to define the current synchronization action
(frozen, check, resync, ...) in rs_get_progress().

Change it to return an enum defining the sync states and
share it to avoid code duplication.  Introduce sync_str()
to translate from enum to string in raid_status().

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 88 ++++++++++++++++++++++++++------------------
 1 file changed, 52 insertions(+), 36 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index efe035fcb23e..9754ef24fd0b 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3330,32 +3330,55 @@ static int raid_map(struct dm_target *ti, struct bio *bio)
 	return DM_MAPIO_SUBMITTED;
 }
 
-/* Return string describing the current sync action of @mddev */
-static const char *decipher_sync_action(struct mddev *mddev, unsigned long recovery)
+/* Return sync state string for @state */
+enum sync_state { st_frozen, st_reshape, st_resync, st_check, st_repair, st_recover, st_idle };
+static const char *sync_str(enum sync_state state)
+{
+	/* Has to be in above sync_state order! */
+	static const char *sync_strs[] = {
+		"frozen",
+		"reshape",
+		"resync",
+		"check",
+		"repair",
+		"recover",
+		"idle"
+	};
+
+	BUG_ON(!__within_range(state, 0, ARRAY_SIZE(sync_strs) - 1));
+
+	return sync_strs[state];
+};
+
+/* Return enum sync_state for @mddev derived from @recovery flags */
+static const enum sync_state decipher_sync_action(struct mddev *mddev, unsigned long recovery)
 {
 	if (test_bit(MD_RECOVERY_FROZEN, &recovery))
-		return "frozen";
+		return st_frozen;
 
-	/* The MD sync thread can be done with io but still be running */
+	/* The MD sync thread can be done with io or be interrupted but still be running */
 	if (!test_bit(MD_RECOVERY_DONE, &recovery) &&
 	    (test_bit(MD_RECOVERY_RUNNING, &recovery) ||
 	     (!mddev->ro && test_bit(MD_RECOVERY_NEEDED, &recovery)))) {
 		if (test_bit(MD_RECOVERY_RESHAPE, &recovery))
-			return "reshape";
+			return st_reshape;
 
 		if (test_bit(MD_RECOVERY_SYNC, &recovery)) {
 			if (!test_bit(MD_RECOVERY_REQUESTED, &recovery))
-				return "resync";
-			else if (test_bit(MD_RECOVERY_CHECK, &recovery))
-				return "check";
-			return "repair";
+				return st_resync;
+			if (test_bit(MD_RECOVERY_CHECK, &recovery))
+				return st_check;
+			return st_repair;
 		}
 
 		if (test_bit(MD_RECOVERY_RECOVER, &recovery))
-			return "recover";
+			return st_recover;
+
+		if (mddev->reshape_position != MaxSector)
+			return st_reshape;
 	}
 
-	return "idle";
+	return st_idle;
 }
 
 /*
@@ -3389,6 +3412,7 @@ static sector_t rs_get_progress(struct raid_set *rs, unsigned long recovery,
 				sector_t resync_max_sectors)
 {
 	sector_t r;
+	enum sync_state state;
 	struct mddev *mddev = &rs->md;
 
 	clear_bit(RT_FLAG_RS_IN_SYNC, &rs->runtime_flags);
@@ -3399,20 +3423,14 @@ static sector_t rs_get_progress(struct raid_set *rs, unsigned long recovery,
 		set_bit(RT_FLAG_RS_IN_SYNC, &rs->runtime_flags);
 
 	} else {
-		if (!test_bit(__CTR_FLAG_NOSYNC, &rs->ctr_flags) &&
-		    !test_bit(MD_RECOVERY_INTR, &recovery) &&
-		    (test_bit(MD_RECOVERY_NEEDED, &recovery) ||
-		     test_bit(MD_RECOVERY_RESHAPE, &recovery) ||
-		     test_bit(MD_RECOVERY_RUNNING, &recovery)))
-			r = mddev->curr_resync_completed;
-		else
+		state = decipher_sync_action(mddev, recovery);
+
+		if (state == st_idle && !test_bit(MD_RECOVERY_INTR, &recovery))
 			r = mddev->recovery_cp;
+		else
+			r = mddev->curr_resync_completed;
 
-		if (r >= resync_max_sectors &&
-		    (!test_bit(MD_RECOVERY_REQUESTED, &recovery) ||
-		     (!test_bit(MD_RECOVERY_FROZEN, &recovery) &&
-		      !test_bit(MD_RECOVERY_NEEDED, &recovery) &&
-		      !test_bit(MD_RECOVERY_RUNNING, &recovery)))) {
+		if (state == st_idle && r >= resync_max_sectors) {
 			/*
 			 * Sync complete.
 			 */
@@ -3420,24 +3438,20 @@ static sector_t rs_get_progress(struct raid_set *rs, unsigned long recovery,
 			if (test_bit(MD_RECOVERY_RECOVER, &recovery))
 				set_bit(RT_FLAG_RS_IN_SYNC, &rs->runtime_flags);
 
-		} else if (test_bit(MD_RECOVERY_RECOVER, &recovery)) {
+		} else if (state == st_recover)
 			/*
 			 * In case we are recovering, the array is not in sync
 			 * and health chars should show the recovering legs.
 			 */
 			;
-
-		} else if (test_bit(MD_RECOVERY_SYNC, &recovery) &&
-			   !test_bit(MD_RECOVERY_REQUESTED, &recovery)) {
+		else if (state == st_resync)
 			/*
 			 * If "resync" is occurring, the raid set
 			 * is or may be out of sync hence the health
 			 * characters shall be 'a'.
 			 */
 			set_bit(RT_FLAG_RS_RESYNCING, &rs->runtime_flags);
-
-		} else if (test_bit(MD_RECOVERY_RESHAPE, &recovery) &&
-			   !test_bit(MD_RECOVERY_REQUESTED, &recovery)) {
+		else if (state == st_reshape)
 			/*
 			 * If "reshape" is occurring, the raid set
 			 * is or may be out of sync hence the health
@@ -3445,7 +3459,7 @@ static sector_t rs_get_progress(struct raid_set *rs, unsigned long recovery,
 			 */
 			set_bit(RT_FLAG_RS_RESYNCING, &rs->runtime_flags);
 
-		} else if (test_bit(MD_RECOVERY_REQUESTED, &recovery)) {
+		else if (state == st_check || state == st_repair)
 			/*
 			 * If "check" or "repair" is occurring, the raid set has
 			 * undergone an initial sync and the health characters
@@ -3453,12 +3467,12 @@ static sector_t rs_get_progress(struct raid_set *rs, unsigned long recovery,
 			 */
 			set_bit(RT_FLAG_RS_IN_SYNC, &rs->runtime_flags);
 
-		} else {
+		else {
 			struct md_rdev *rdev;
 
 			/*
 			 * We are idle and recovery is needed, prevent 'A' chars race
-			 * caused by components still set to in-sync by constrcuctor.
+			 * caused by components still set to in-sync by constructor.
 			 */
 			if (test_bit(MD_RECOVERY_NEEDED, &recovery))
 				set_bit(RT_FLAG_RS_RESYNCING, &rs->runtime_flags);
@@ -3522,7 +3536,7 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 		progress = rs_get_progress(rs, recovery, resync_max_sectors);
 		resync_mismatches = (mddev->last_sync_action && !strcasecmp(mddev->last_sync_action, "check")) ?
 				    atomic64_read(&mddev->resync_mismatches) : 0;
-		sync_action = decipher_sync_action(&rs->md, recovery);
+		sync_action = sync_str(decipher_sync_action(&rs->md, recovery));
 
 		/* HM FIXME: do we want another state char for raid0? It shows 'D'/'A'/'-' now */
 		for (i = 0; i < rs->raid_disks; i++)
@@ -3739,12 +3753,14 @@ static void raid_postsuspend(struct dm_target *ti)
 	struct raid_set *rs = ti->private;
 
 	if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
+		BUG_ON(rs->md.suspended);
+
 		/* Writes have to be stopped before suspending to avoid deadlocks. */
-		if (!test_bit(MD_RECOVERY_FROZEN, &rs->md.recovery))
-			md_stop_writes(&rs->md);
+		md_stop_writes(&rs->md);
 
 		mddev_lock_nointr(&rs->md);
 		mddev_suspend(&rs->md);
+		rs->md.ro = 1;
 		mddev_unlock(&rs->md);
 	}
 }
-- 
2.17.1
