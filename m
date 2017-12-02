From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH V2 07/12] dm raid: avoid array_in_sync variable
Date: Sat,  2 Dec 2017 01:03:54 +0100
Message-ID: <db0fdacb4a74befd14572a6835f59fc8a1387195.1512171097.git.heinzm@redhat.com>
References: <cover.1512171097.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1512171097.git.heinzm@redhat.com>
In-Reply-To: <cover.1512171097.git.heinzm@redhat.com>
References: <cover.1512171097.git.heinzm@redhat.com>
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
Cc: snitzer@redhat.com
List-Id: dm-devel.ids

The raid_status() function passes the bool array_in_sync variable
around providing synchronization state of the MD array.  Replace
it by a runtime flag preparing for a following patch which needs
to pass another state between raid_status() and its callees thus
avoiding function argument bloat.
---
 drivers/md/dm-raid.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 2d45c04f9c48..7be73d4e439a 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -209,6 +209,7 @@ struct raid_dev {
 #define RT_FLAG_UPDATE_SBS		3
 #define RT_FLAG_RESHAPE_RS		4
 #define RT_FLAG_RS_SUSPENDED		5
+#define RT_FLAG_RS_IN_SYNC		6
 
 /* Array elements of 64 bit needed for rebuild/failed disk bits */
 #define DISKS_ARRAY_ELEMS ((MAX_RAID_DEVICES + (sizeof(uint64_t) * 8 - 1)) / sizeof(uint64_t) / 8)
@@ -3318,7 +3319,7 @@ static const char *decipher_sync_action(struct mddev *mddev, unsigned long recov
  *  'A' = Alive and in-sync raid set component _or_ alive raid4/5/6 'write_through' journal device
  *  '-' = Non-existing device (i.e. uspace passed '- -' into the ctr)
  */
-static const char *__raid_dev_status(struct raid_set *rs, struct md_rdev *rdev, bool array_in_sync)
+static const char *__raid_dev_status(struct raid_set *rs, struct md_rdev *rdev)
 {
 	if (!rdev->bdev)
 		return "-";
@@ -3326,25 +3327,27 @@ static const char *__raid_dev_status(struct raid_set *rs, struct md_rdev *rdev,
 		return "D";
 	else if (test_bit(Journal, &rdev->flags))
 		return (rs->journal_dev.mode == R5C_JOURNAL_MODE_WRITE_THROUGH) ? "A" : "a";
-	else if (!array_in_sync || !test_bit(In_sync, &rdev->flags))
+	else if (!test_bit(RT_FLAG_RS_IN_SYNC, &rs->runtime_flags) &&
+		 !test_bit(In_sync, &rdev->flags))
 		return "a";
 	else
 		return "A";
 }
 
-/* Helper to return resync/reshape progress for @rs and @array_in_sync */
+/* Helper to return resync/reshape progress for @rs and runtime flags for raid set in sync / resynching */
 static sector_t rs_get_progress(struct raid_set *rs, unsigned long recovery,
-				sector_t resync_max_sectors, bool *array_in_sync)
+				sector_t resync_max_sectors)
 {
 	sector_t r, curr_resync_completed;
 	struct mddev *mddev = &rs->md;
 
+	clear_bit(RT_FLAG_RS_IN_SYNC, &rs->runtime_flags);
+
 	curr_resync_completed = mddev->curr_resync_completed ?: mddev->recovery_cp;
-	*array_in_sync = false;
 
 	if (rs_is_raid0(rs)) {
 		r = resync_max_sectors;
-		*array_in_sync = true;
+		set_bit(RT_FLAG_RS_IN_SYNC, &rs->runtime_flags);
 
 	} else {
 		r = mddev->reshape_position;
@@ -3353,7 +3356,7 @@ static sector_t rs_get_progress(struct raid_set *rs, unsigned long recovery,
 		if (test_bit(MD_RECOVERY_RESHAPE, &recovery) ||
 		    r != MaxSector) {
 			if (r == MaxSector) {
-				*array_in_sync = true;
+				set_bit(RT_FLAG_RS_IN_SYNC, &rs->runtime_flags);
 				r = resync_max_sectors;
 			} else {
 				/* Got to reverse on backward reshape */
@@ -3376,7 +3379,7 @@ static sector_t rs_get_progress(struct raid_set *rs, unsigned long recovery,
 			/*
 			 * Sync complete.
 			 */
-			*array_in_sync = true;
+			set_bit(RT_FLAG_RS_IN_SYNC, &rs->runtime_flags);
 			r = resync_max_sectors;
 		} else if (test_bit(MD_RECOVERY_REQUESTED, &recovery)) {
 			/*
@@ -3384,7 +3387,7 @@ static sector_t rs_get_progress(struct raid_set *rs, unsigned long recovery,
 			 * undergone an initial sync and the health characters
 			 * should not be 'a' anymore.
 			 */
-			*array_in_sync = true;
+			set_bit(RT_FLAG_RS_IN_SYNC, &rs->runtime_flags);
 		} else {
 			struct md_rdev *rdev;
 
@@ -3397,7 +3400,7 @@ static sector_t rs_get_progress(struct raid_set *rs, unsigned long recovery,
 			rdev_for_each(rdev, mddev)
 				if (!test_bit(Journal, &rdev->flags) &&
 				    !test_bit(In_sync, &rdev->flags))
-					*array_in_sync = true;
+					set_bit(RT_FLAG_RS_IN_SYNC, &rs->runtime_flags);
 #if 0
 			r = 0; /* HM FIXME: TESTME: https://bugzilla.redhat.com/show_bug.cgi?id=1210637 ? */
 #endif
@@ -3420,7 +3423,6 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 	struct mddev *mddev = &rs->md;
 	struct r5conf *conf = mddev->private;
 	int i, max_nr_stripes = conf ? conf->max_nr_stripes : 0;
-	bool array_in_sync;
 	unsigned long recovery;
 	unsigned int raid_param_cnt = 1; /* at least 1 for chunksize */
 	unsigned int sz = 0;
@@ -3445,14 +3447,14 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 		/* Get sensible max sectors even if raid set not yet started */
 		resync_max_sectors = test_bit(RT_FLAG_RS_PRERESUMED, &rs->runtime_flags) ?
 				      mddev->resync_max_sectors : mddev->dev_sectors;
-		progress = rs_get_progress(rs, recovery, resync_max_sectors, &array_in_sync);
+		progress = rs_get_progress(rs, recovery, resync_max_sectors);
 		resync_mismatches = (mddev->last_sync_action && !strcasecmp(mddev->last_sync_action, "check")) ?
 				    atomic64_read(&mddev->resync_mismatches) : 0;
 		sync_action = decipher_sync_action(&rs->md, recovery);
 
 		/* HM FIXME: do we want another state char for raid0? It shows 'D'/'A'/'-' now */
 		for (i = 0; i < rs->raid_disks; i++)
-			DMEMIT(__raid_dev_status(rs, &rs->dev[i].rdev, array_in_sync));
+			DMEMIT(__raid_dev_status(rs, &rs->dev[i].rdev));
 
 		/*
 		 * In-sync/Reshape ratio:
@@ -3503,7 +3505,7 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 		 * v1.10.0+:
 		 */
 		DMEMIT(" %s", test_bit(__CTR_FLAG_JOURNAL_DEV, &rs->ctr_flags) ?
-			      __raid_dev_status(rs, &rs->journal_dev.rdev, 0) : "-");
+			      __raid_dev_status(rs, &rs->journal_dev.rdev) : "-");
 		break;
 
 	case STATUSTYPE_TABLE:
-- 
2.13.6
