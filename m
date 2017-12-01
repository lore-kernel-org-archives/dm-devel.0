From: heinzm@redhat.com
Subject: [PATCH 06/10] dm raid: clear out rs_get_progress()
Date: Fri,  1 Dec 2017 01:02:24 +0100
Message-ID: <20171201000228.32677-7-heinzm@redhat.com>
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
Cc: heinzm@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Retrieve recovery flags once in raid_status() and pass them
into its callees to avoid racy updates during their processing.
Access raid array members for reshaping or synchronization/recovery
offsets when needed and pay attention to the respective recovery
flags when doing so.  Address sync ratio issue as of related bz.

Related: rhbz1508070
---
 drivers/md/dm-raid.c | 122 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 73 insertions(+), 49 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index e37ee5f8ed3d..7fbb31ed9147 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -209,6 +209,8 @@ struct raid_dev {
 #define RT_FLAG_UPDATE_SBS		3
 #define RT_FLAG_RESHAPE_RS		4
 #define RT_FLAG_RS_SUSPENDED		5
+#define RT_FLAG_RS_IN_SYNC		6
+#define RT_FLAG_RS_RESYNCING		7
 
 /* Array elements of 64 bit needed for rebuild/failed disk bits */
 #define DISKS_ARRAY_ELEMS ((MAX_RAID_DEVICES + (sizeof(uint64_t) * 8 - 1)) / sizeof(uint64_t) / 8)
@@ -3282,25 +3284,26 @@ static int raid_map(struct dm_target *ti, struct bio *bio)
 }
 
 /* Return string describing the current sync action of @mddev */
-static const char *decipher_sync_action(struct mddev *mddev)
+static const char *decipher_sync_action(struct mddev *mddev, unsigned long recovery)
 {
-	if (test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
+	if (test_bit(MD_RECOVERY_FROZEN, &recovery))
 		return "frozen";
 
-	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
-	    (!mddev->ro && test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))) {
-		if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
+	if (!test_bit(MD_RECOVERY_DONE, &recovery) &&
+	    (test_bit(MD_RECOVERY_RUNNING, &recovery) ||
+	     (!mddev->ro && test_bit(MD_RECOVERY_NEEDED, &recovery)))) {
+		if (test_bit(MD_RECOVERY_RESHAPE, &recovery))
 			return "reshape";
 
-		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
-			if (!test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
+		if (test_bit(MD_RECOVERY_SYNC, &recovery)) {
+			if (!test_bit(MD_RECOVERY_REQUESTED, &recovery))
 				return "resync";
-			else if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
+			else if (test_bit(MD_RECOVERY_CHECK, &recovery))
 				return "check";
 			return "repair";
 		}
 
-		if (test_bit(MD_RECOVERY_RECOVER, &mddev->recovery))
+		if (test_bit(MD_RECOVERY_RECOVER, &recovery))
 			return "recover";
 	}
 
@@ -3317,7 +3320,7 @@ static const char *decipher_sync_action(struct mddev *mddev)
  *  'A' = Alive and in-sync raid set component _or_ alive raid4/5/6 'write_through' journal device
  *  '-' = Non-existing device (i.e. uspace passed '- -' into the ctr)
  */
-static const char *__raid_dev_status(struct raid_set *rs, struct md_rdev *rdev, bool array_in_sync)
+static const char *__raid_dev_status(struct raid_set *rs, struct md_rdev *rdev)
 {
 	if (!rdev->bdev)
 		return "-";
@@ -3325,65 +3328,86 @@ static const char *__raid_dev_status(struct raid_set *rs, struct md_rdev *rdev,
 		return "D";
 	else if (test_bit(Journal, &rdev->flags))
 		return (rs->journal_dev.mode == R5C_JOURNAL_MODE_WRITE_THROUGH) ? "A" : "a";
-	else if (!array_in_sync || !test_bit(In_sync, &rdev->flags))
+	else if (test_bit(RT_FLAG_RS_RESYNCING, &rs->runtime_flags))
+		return "a";
+	else if (!test_bit(RT_FLAG_RS_IN_SYNC, &rs->runtime_flags) &&
+		 !test_bit(In_sync, &rdev->flags))
 		return "a";
 	else
 		return "A";
 }
 
-/* Helper to return resync/reshape progress for @rs and @array_in_sync */
-static sector_t rs_get_progress(struct raid_set *rs,
-				sector_t resync_max_sectors, bool *array_in_sync)
+/* Helper to return resync/reshape progress for @rs and runtime flags for raid set in sync / resynching */
+static sector_t rs_get_progress(struct raid_set *rs, unsigned long recovery,
+				sector_t resync_max_sectors)
 {
-	sector_t r, curr_resync_completed;
+	sector_t r;
 	struct mddev *mddev = &rs->md;
 
-	curr_resync_completed = mddev->curr_resync_completed ?: mddev->recovery_cp;
-	*array_in_sync = false;
+	clear_bit(RT_FLAG_RS_IN_SYNC, &rs->runtime_flags);
+	clear_bit(RT_FLAG_RS_RESYNCING, &rs->runtime_flags);
 
 	if (rs_is_raid0(rs)) {
 		r = resync_max_sectors;
-		*array_in_sync = true;
+		set_bit(RT_FLAG_RS_IN_SYNC, &rs->runtime_flags);
 
 	} else {
-		r = mddev->reshape_position;
-
 		/* Reshape is relative to the array size */
-		if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) ||
-		    r != MaxSector) {
-			if (r == MaxSector) {
-				*array_in_sync = true;
-				r = resync_max_sectors;
-			} else {
+		if (test_bit(MD_RECOVERY_RESHAPE, &recovery)) {
+			r = mddev->reshape_position;
+			if (r != MaxSector) {
 				/* Got to reverse on backward reshape */
 				if (mddev->reshape_backwards)
 					r = mddev->array_sectors - r;
 
-				/* Devide by # of data stripes */
-				sector_div(r, mddev_data_stripes(rs));
+				/* Divide by # of data stripes unless raid1 */
+				if (!rs_is_raid1(rs))
+					sector_div(r, mddev_data_stripes(rs));
 			}
 
-		/* Sync is relative to the component device size */
-		} else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
-			r = curr_resync_completed;
+		/*
+		 * Sync/recover is relative to the component device size.
+		 *
+		 * MD_RECOVERY_NEEDED for https://bugzilla.redhat.com/show_bug.cgi?id=1508070
+		 */
+		} else if (test_bit(MD_RECOVERY_NEEDED, &recovery) ||
+			   test_bit(MD_RECOVERY_RUNNING, &recovery))
+			r = mddev->curr_resync_completed;
+
 		else
 			r = mddev->recovery_cp;
 
-		if ((r == MaxSector) ||
-		    (test_bit(MD_RECOVERY_DONE, &mddev->recovery) &&
-		     (mddev->curr_resync_completed == resync_max_sectors))) {
+		if (r >= resync_max_sectors &&
+		    (!test_bit(MD_RECOVERY_REQUESTED, &recovery) ||
+		     (!test_bit(MD_RECOVERY_FROZEN, &recovery) &&
+		      !test_bit(MD_RECOVERY_NEEDED, &recovery) &&
+		      !test_bit(MD_RECOVERY_RUNNING, &recovery)))) {
 			/*
 			 * Sync complete.
 			 */
-			*array_in_sync = true;
-			r = resync_max_sectors;
-		} else if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
+			if (test_bit(MD_RECOVERY_RECOVER, &recovery))
+				set_bit(RT_FLAG_RS_IN_SYNC, &rs->runtime_flags);
+
+		} else if (test_bit(MD_RECOVERY_RECOVER, &recovery)) {
+			;
+
+		} else if (test_bit(MD_RECOVERY_SYNC, &recovery) &&
+			   !test_bit(MD_RECOVERY_REQUESTED, &recovery)) {
+			/*
+			 * If "resync" is occurring, the raid set has
+			 * undergone an initial sync and the health characters
+			 * should not be 'a' anymore.
+			 */
+			set_bit(RT_FLAG_RS_RESYNCING, &rs->runtime_flags);
+
+		} else if (test_bit(MD_RECOVERY_REQUESTED, &recovery)) {
 			/*
 			 * If "check" or "repair" is occurring, the raid set has
 			 * undergone an initial sync and the health characters
 			 * should not be 'a' anymore.
 			 */
-			*array_in_sync = true;
+			set_bit(RT_FLAG_RS_IN_SYNC, &rs->runtime_flags);
+
 		} else {
 			struct md_rdev *rdev;
 
@@ -3395,15 +3419,14 @@ static sector_t rs_get_progress(struct raid_set *rs,
 			 */
 			rdev_for_each(rdev, mddev)
 				if (!test_bit(Journal, &rdev->flags) &&
-				    !test_bit(In_sync, &rdev->flags))
-					*array_in_sync = true;
-#if 0
-			r = 0; /* HM FIXME: TESTME: https://bugzilla.redhat.com/show_bug.cgi?id=1210637 ? */
-#endif
+				    !test_bit(In_sync, &rdev->flags)) {
+					set_bit(RT_FLAG_RS_IN_SYNC, &rs->runtime_flags);
+					break;
+				}
 		}
 	}
 
-	return r;
+	return min(r, resync_max_sectors);
 }
 
 /* Helper to return @dev name or "-" if !@dev */
@@ -3419,7 +3442,7 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 	struct mddev *mddev = &rs->md;
 	struct r5conf *conf = mddev->private;
 	int i, max_nr_stripes = conf ? conf->max_nr_stripes : 0;
-	bool array_in_sync;
+	unsigned long recovery;
 	unsigned int raid_param_cnt = 1; /* at least 1 for chunksize */
 	unsigned int sz = 0;
 	unsigned int rebuild_disks;
@@ -3439,17 +3462,18 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 
 		/* Access most recent mddev properties for status output */
 		smp_rmb();
+		recovery = rs->md.recovery;
 		/* Get sensible max sectors even if raid set not yet started */
 		resync_max_sectors = test_bit(RT_FLAG_RS_PRERESUMED, &rs->runtime_flags) ?
 				      mddev->resync_max_sectors : mddev->dev_sectors;
-		progress = rs_get_progress(rs, resync_max_sectors, &array_in_sync);
+		progress = rs_get_progress(rs, recovery, resync_max_sectors);
 		resync_mismatches = (mddev->last_sync_action && !strcasecmp(mddev->last_sync_action, "check")) ?
 				    atomic64_read(&mddev->resync_mismatches) : 0;
-		sync_action = decipher_sync_action(&rs->md);
+		sync_action = decipher_sync_action(&rs->md, recovery);
 
 		/* HM FIXME: do we want another state char for raid0? It shows 'D'/'A'/'-' now */
 		for (i = 0; i < rs->raid_disks; i++)
-			DMEMIT(__raid_dev_status(rs, &rs->dev[i].rdev, array_in_sync));
+			DMEMIT(__raid_dev_status(rs, &rs->dev[i].rdev));
 
 		/*
 		 * In-sync/Reshape ratio:
@@ -3500,7 +3524,7 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 		 * v1.10.0+:
 		 */
 		DMEMIT(" %s", test_bit(__CTR_FLAG_JOURNAL_DEV, &rs->ctr_flags) ?
-			      __raid_dev_status(rs, &rs->journal_dev.rdev, 0) : "-");
+			      __raid_dev_status(rs, &rs->journal_dev.rdev) : "-");
 		break;
 
 	case STATUSTYPE_TABLE:
-- 
2.13.6
