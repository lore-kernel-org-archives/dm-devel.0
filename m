From: heinzm@redhat.com
Subject: [PATCH V2 21/26] dm raid: allow resize during recovery
Date: Thu,  7 Jul 2016 16:25:42 +0200
Message-ID: <1467901544-31250-2-git-send-email-heinzm@redhat.com>
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

Resizing a RAID set during recovery can be allowed, because the MD
resynchronization thread will either stop any ongoing recovery in case
of shrinking below the current recovery position or carry on recovery
to the new size if the set is growing.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 1ff469f..846c58d 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2682,6 +2682,7 @@ static void configure_discard_support(struct raid_set *rs)
 static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 {
 	int r;
+	bool resize = false;
 	struct raid_type *rt;
 	unsigned num_raid_params, num_raid_devs;
 	sector_t calculated_dev_sectors;
@@ -2760,7 +2761,7 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	if (r)
 		goto bad;
 
-	rs_setup_recovery(rs, calculated_dev_sectors);
+	resize = calculated_dev_sectors != rs->dev[0].rdev.sectors;
 
 	INIT_WORK(&rs->md.event_work, do_table_event);
 	ti->private = rs;
@@ -2770,8 +2771,6 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	rs_config_restore(rs, &rs_layout);
 
 	if (test_bit(MD_ARRAY_FIRST_USE, &rs->md.flags)) {
-		set_bit(RT_FLAG_UPDATE_SBS, &rs->runtime_flags);
-		rs_set_new(rs);
 		/* A new raid6 set has to be recovered to ensure proper parity and Q-Syndrome */
 		if (rs_is_raid6(rs) &&
 		    test_bit(__CTR_FLAG_NOSYNC, &rs->ctr_flags)) {
@@ -2780,16 +2779,18 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 			goto bad;
 		}
 		rs_setup_recovery(rs, 0);
-	} else if (rs_is_recovering(rs) || rs_is_reshaping(rs)) {
-		/* Have to reject size change request during recovery/reshape */
-		if (calculated_dev_sectors != rs->dev[0].rdev.sectors) {
-			ti->error = rs_is_recovering(rs) ?
-				    "Can't resize a recovering raid set" :
-				    "Can't resize a reshaping raid set";
+		set_bit(RT_FLAG_UPDATE_SBS, &rs->runtime_flags);
+		rs_set_new(rs);
+	} else if (rs_is_recovering(rs)) {
+		; /* skip setup rs */
+	} else if (rs_is_reshaping(rs)) {
+		/* Have to reject size change request during reshape */
+		if (resize) {
+			ti->error = "Can't resize a reshaping raid set";
 			r = -EPERM;
 			goto bad;
 		}
-		/* skip setup rs */
+		; /* skip setup rs */
 	} else if (rs_takeover_requested(rs)) {
 		if (rs_is_reshaping(rs)) {
 			ti->error = "Can't takeover a reshaping raid set";
@@ -2799,8 +2800,9 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 		/*
 		 * If a takeover is needed, userspace sets any additional
-		 * devices to rebuild, so just set the level to the new
-		 * requested one and allow the raid set to run
+		 * devices to rebuild, so set the level to the new requested
+		 * one, prohibit requesting recovery, allow the raid
+		 * set to run and store superblocks during resume.
 		 */
 		r = rs_check_takeover(rs);
 		if (r)
@@ -2812,6 +2814,7 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 		set_bit(RT_FLAG_UPDATE_SBS, &rs->runtime_flags);
 		set_bit(RT_FLAG_KEEP_RS_FROZEN, &rs->runtime_flags);
+		rs_setup_recovery(rs, MaxSector);
 		rs_set_new(rs);
 	} else if (rs_reshape_requested(rs)) {
 		if (rs_is_reshaping(rs)) {
@@ -2868,16 +2871,17 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		if (rs->md.raid_disks < rs->raid_disks)
 			set_bit(RT_FLAG_UPDATE_SBS, &rs->runtime_flags);
 
-		rs_set_cur(rs);
 		rs_setup_recovery(rs, MaxSector);
-	} else {
 		rs_set_cur(rs);
+	} else {
+		/* May not set recovery when a device rebuild is requested */
 		if (test_bit(__CTR_FLAG_REBUILD, &rs->ctr_flags)) {
 			rs_setup_recovery(rs, MaxSector);
 			set_bit(RT_FLAG_UPDATE_SBS, &rs->runtime_flags);
 		} else
 			rs_setup_recovery(rs, test_bit(__CTR_FLAG_SYNC, &rs->ctr_flags) ?
-					      0 : calculated_dev_sectors);
+					      0 : (resize ? calculated_dev_sectors : MaxSector));
+		rs_set_cur(rs);
 	}
 
 	/* If constructor requested it, change data and new_data offsets */
-- 
2.5.5
