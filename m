From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH V2 06/12] dm raid: close MD recovery flags race
	window
Date: Sat,  2 Dec 2017 01:03:53 +0100
Message-ID: <5a67d128834ffb2136e185a04a169ae52facc491.1512171097.git.heinzm@redhat.com>
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

The MD sync thread updates recovery flags providing state
of any running,idle,frozen,recovering,reshaping,... activity
it performs and updates respective flags asynchronously to
dm processing raid_status().  To close that race window,
take a copy of the flags and pass it into its callees.
---
 drivers/md/dm-raid.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index e37ee5f8ed3d..2d45c04f9c48 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3282,25 +3282,26 @@ static int raid_map(struct dm_target *ti, struct bio *bio)
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
 
@@ -3332,7 +3333,7 @@ static const char *__raid_dev_status(struct raid_set *rs, struct md_rdev *rdev,
 }
 
 /* Helper to return resync/reshape progress for @rs and @array_in_sync */
-static sector_t rs_get_progress(struct raid_set *rs,
+static sector_t rs_get_progress(struct raid_set *rs, unsigned long recovery,
 				sector_t resync_max_sectors, bool *array_in_sync)
 {
 	sector_t r, curr_resync_completed;
@@ -3349,7 +3350,7 @@ static sector_t rs_get_progress(struct raid_set *rs,
 		r = mddev->reshape_position;
 
 		/* Reshape is relative to the array size */
-		if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) ||
+		if (test_bit(MD_RECOVERY_RESHAPE, &recovery) ||
 		    r != MaxSector) {
 			if (r == MaxSector) {
 				*array_in_sync = true;
@@ -3364,20 +3365,20 @@ static sector_t rs_get_progress(struct raid_set *rs,
 			}
 
 		/* Sync is relative to the component device size */
-		} else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
+		} else if (test_bit(MD_RECOVERY_RUNNING, &recovery))
 			r = curr_resync_completed;
 		else
 			r = mddev->recovery_cp;
 
 		if ((r == MaxSector) ||
-		    (test_bit(MD_RECOVERY_DONE, &mddev->recovery) &&
+		    (test_bit(MD_RECOVERY_DONE, &recovery) &&
 		     (mddev->curr_resync_completed == resync_max_sectors))) {
 			/*
 			 * Sync complete.
 			 */
 			*array_in_sync = true;
 			r = resync_max_sectors;
-		} else if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
+		} else if (test_bit(MD_RECOVERY_REQUESTED, &recovery)) {
 			/*
 			 * If "check" or "repair" is occurring, the raid set has
 			 * undergone an initial sync and the health characters
@@ -3420,6 +3421,7 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 	struct r5conf *conf = mddev->private;
 	int i, max_nr_stripes = conf ? conf->max_nr_stripes : 0;
 	bool array_in_sync;
+	unsigned long recovery;
 	unsigned int raid_param_cnt = 1; /* at least 1 for chunksize */
 	unsigned int sz = 0;
 	unsigned int rebuild_disks;
@@ -3439,13 +3441,14 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 
 		/* Access most recent mddev properties for status output */
 		smp_rmb();
+		recovery = rs->md.recovery;
 		/* Get sensible max sectors even if raid set not yet started */
 		resync_max_sectors = test_bit(RT_FLAG_RS_PRERESUMED, &rs->runtime_flags) ?
 				      mddev->resync_max_sectors : mddev->dev_sectors;
-		progress = rs_get_progress(rs, resync_max_sectors, &array_in_sync);
+		progress = rs_get_progress(rs, recovery, resync_max_sectors, &array_in_sync);
 		resync_mismatches = (mddev->last_sync_action && !strcasecmp(mddev->last_sync_action, "check")) ?
 				    atomic64_read(&mddev->resync_mismatches) : 0;
-		sync_action = decipher_sync_action(&rs->md);
+		sync_action = decipher_sync_action(&rs->md, recovery);
 
 		/* HM FIXME: do we want another state char for raid0? It shows 'D'/'A'/'-' now */
 		for (i = 0; i < rs->raid_disks; i++)
-- 
2.13.6
