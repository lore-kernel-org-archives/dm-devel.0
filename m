From: heinzm@redhat.com
Subject: [PATCH V2 22/26] dm raid: enhance reshape check and
	factor out reshape setup
Date: Thu,  7 Jul 2016 16:25:43 +0200
Message-ID: <1467901544-31250-3-git-send-email-heinzm@redhat.com>
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

Enhance rs_reshape_requested() check function to be
more transparent and fix its raid10 check.

Streamline the constructor by factoring out reshaping
preparation into fucntion rs_prepare_reshape().

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 167 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 106 insertions(+), 61 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 846c58d..473c6d9 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1700,16 +1700,30 @@ static bool rs_takeover_requested(struct raid_set *rs)
 /* True if @rs is requested to reshape by ctr */
 static bool rs_reshape_requested(struct raid_set *rs)
 {
+	bool change;
 	struct mddev *mddev = &rs->md;
 
+	if (rs_takeover_requested(rs))
+		return false;
+
 	if (!mddev->level)
 		return false;
 
-	return !__is_raid10_far(mddev->new_layout) &&
-	       mddev->new_level == mddev->level &&
-	       (mddev->new_layout != mddev->layout ||
-		mddev->new_chunk_sectors != mddev->chunk_sectors ||
-		rs->raid_disks + rs->delta_disks != mddev->raid_disks);
+	change = mddev->new_layout != mddev->layout ||
+		 mddev->new_chunk_sectors != mddev->chunk_sectors ||
+		 rs->delta_disks;
+
+	/* Historical case to support raid1 reshape without delta disks */
+	if (mddev->level == 1)
+		return !change &&
+		       mddev->raid_disks != rs->raid_disks;
+
+	if (mddev->level == 10)
+		return change &&
+		       !__is_raid10_far(mddev->new_layout) &&
+		       rs->delta_disks >= 0;
+
+	return change;
 }
 
 /*  Features */
@@ -1821,7 +1835,7 @@ static int rs_check_reshape(struct raid_set *rs)
 		rs->ti->error = "Can't reshape degraded raid set";
 	else if (rs_is_recovering(rs))
 		rs->ti->error = "Convert request on recovering raid set prohibited";
-	else if (mddev->reshape_position && rs_is_reshaping(rs))
+	else if (rs_is_reshaping(rs))
 		rs->ti->error = "raid set already reshaping!";
 	else if (!(rs_is_raid10(rs) || rs_is_raid456(rs)))
 		rs->ti->error = "Reshaping only supported for raid4/5/6/10";
@@ -2518,6 +2532,69 @@ static int rs_setup_takeover(struct raid_set *rs)
 	return 0;
 }
 
+/* Prepare @rs for reshape */
+static int rs_prepare_reshape(struct raid_set *rs)
+{
+	bool reshape;
+	struct mddev *mddev = &rs->md;
+
+	if (rs_is_raid10(rs)) {
+		if (rs->raid_disks != mddev->raid_disks &&
+		    __is_raid10_near(mddev->layout) &&
+		    rs->raid10_copies &&
+		    rs->raid10_copies != __raid10_near_copies(mddev->layout)) {
+			/*
+			 * raid disk have to be multiple of data copies to allow this conversion,
+			 *
+			 * This is actually not a reshape it is a
+			 * rebuild of any additional mirrors per group
+			 */
+			if (rs->raid_disks % rs->raid10_copies) {
+				rs->ti->error = "Can't reshape raid10 mirror groups";
+				return -EINVAL;
+			}
+
+			/* Userpace reordered disks to add/remove mirrors -> adjust raid_disk indexes */
+			__reorder_raid_disk_indexes(rs);
+			mddev->layout = raid10_format_to_md_layout(rs, ALGORITHM_RAID10_NEAR,
+								   rs->raid10_copies);
+			mddev->new_layout = mddev->layout;
+			reshape = false;
+		} else
+			reshape = true;
+
+	} else if (rs_is_raid456(rs))
+		reshape = true;
+
+	/*
+	 * HM FIXME: process raid1 via delta_disks as well?
+	 *           Would cause allocations in raid1->check_reshape
+	 *           though, thus more issues with potential failures
+	 */
+	else if (rs_is_raid1(rs)) {
+		set_bit(RT_FLAG_KEEP_RS_FROZEN, &rs->runtime_flags);
+		mddev->raid_disks = rs->raid_disks;
+		reshape = false;
+
+	} else {
+		rs->ti->error = "Called with bogus raid type";
+		return -EINVAL;
+	}
+
+	if (reshape) {
+		set_bit(RT_FLAG_RESHAPE_RS, &rs->runtime_flags);
+		set_bit(RT_FLAG_UPDATE_SBS, &rs->runtime_flags);
+		set_bit(RT_FLAG_KEEP_RS_FROZEN, &rs->runtime_flags);
+	}
+	/* Create new superblocks and bitmaps, if any */
+	if (mddev->raid_disks < rs->raid_disks) {
+		set_bit(RT_FLAG_UPDATE_SBS, &rs->runtime_flags);
+		rs_set_cur(rs);
+	}
+
+	return 0;
+}
+
 /*
  *
  * - change raid layout
@@ -2682,7 +2759,7 @@ static void configure_discard_support(struct raid_set *rs)
 static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 {
 	int r;
-	bool resize = false;
+	bool resize;
 	struct raid_type *rt;
 	unsigned num_raid_params, num_raid_devs;
 	sector_t calculated_dev_sectors;
@@ -2770,6 +2847,12 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	/* Restore any requested new layout for conversion decision */
 	rs_config_restore(rs, &rs_layout);
 
+	/*
+	 * Now that we have any superblock metadata available,
+	 * check for new, recovering, reshaping, to be taken over,
+	 * to be reshaped or an existing, unchanged raid set to
+	 * run in sequence.
+	 */
 	if (test_bit(MD_ARRAY_FIRST_USE, &rs->md.flags)) {
 		/* A new raid6 set has to be recovered to ensure proper parity and Q-Syndrome */
 		if (rs_is_raid6(rs) &&
@@ -2782,6 +2865,7 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		set_bit(RT_FLAG_UPDATE_SBS, &rs->runtime_flags);
 		rs_set_new(rs);
 	} else if (rs_is_recovering(rs)) {
+		/* A recovering raid set may be resized */
 		; /* skip setup rs */
 	} else if (rs_is_reshaping(rs)) {
 		/* Have to reject size change request during reshape */
@@ -2790,7 +2874,7 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 			r = -EPERM;
 			goto bad;
 		}
-		; /* skip setup rs */
+		/* skip setup rs */
 	} else if (rs_takeover_requested(rs)) {
 		if (rs_is_reshaping(rs)) {
 			ti->error = "Can't takeover a reshaping raid set";
@@ -2800,7 +2884,9 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 		/*
 		 * If a takeover is needed, userspace sets any additional
-		 * devices to rebuild, so set the level to the new requested
+		 * devices to rebuild and we can check for a valid request here.
+		 *
+		 * If acceptible, set the level to the new requested
 		 * one, prohibit requesting recovery, allow the raid
 		 * set to run and store superblocks during resume.
 		 */
@@ -2814,63 +2900,22 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 		set_bit(RT_FLAG_UPDATE_SBS, &rs->runtime_flags);
 		set_bit(RT_FLAG_KEEP_RS_FROZEN, &rs->runtime_flags);
+		/* Takeover ain't recovery, so disable recovery */
 		rs_setup_recovery(rs, MaxSector);
 		rs_set_new(rs);
 	} else if (rs_reshape_requested(rs)) {
-		if (rs_is_reshaping(rs)) {
-			ti->error = "raid set already reshaping!";
-			r = -EPERM;
-			goto bad;
-		}
-
-		if (rs_is_raid10(rs)) {
-			if (rs->raid_disks != rs->md.raid_disks &&
-			    __is_raid10_near(rs->md.layout) &&
-			    rs->raid10_copies &&
-			    rs->raid10_copies != __raid10_near_copies(rs->md.layout)) {
-				/*
-				 * raid disk have to be multiple of data copies to allow this conversion,
-				 *
-				 * This is actually not a reshape it is a
-				 * rebuild of any additional mirrors per group
-				 */
-				if (rs->raid_disks % rs->raid10_copies) {
-					ti->error = "Can't reshape raid10 mirror groups";
-					r = -EINVAL;
-					goto bad;
-				}
-
-				/* Userpace reordered disks to add/remove mirrors -> adjust raid_disk indexes */
-				__reorder_raid_disk_indexes(rs);
-				rs->md.layout = raid10_format_to_md_layout(rs, ALGORITHM_RAID10_NEAR,
-									   rs->raid10_copies);
-				rs->md.new_layout = rs->md.layout;
-
-			} else
-				set_bit(RT_FLAG_RESHAPE_RS, &rs->runtime_flags);
-
-		} else if (rs_is_raid456(rs))
-			set_bit(RT_FLAG_RESHAPE_RS, &rs->runtime_flags);
-
 		/*
-		 * HM FIXME: process raid1 via delta_disks as well?
-		 *           Would cause allocations in raid1->check_reshape
-		 *           though, thus more issues with potential failures
-		 */
-		else if (rs_is_raid1(rs)) {
-			set_bit(RT_FLAG_KEEP_RS_FROZEN, &rs->runtime_flags);
-			rs->md.raid_disks = rs->raid_disks;
-		}
-
-		if (test_bit(RT_FLAG_RESHAPE_RS, &rs->runtime_flags)) {
-			set_bit(RT_FLAG_UPDATE_SBS, &rs->runtime_flags);
-			set_bit(RT_FLAG_KEEP_RS_FROZEN, &rs->runtime_flags);
-		}
-
-		/* Create new superblocks and bitmaps, if any */
-		if (rs->md.raid_disks < rs->raid_disks)
-			set_bit(RT_FLAG_UPDATE_SBS, &rs->runtime_flags);
+		  * We can only prepare for a reshape here, because the
+		  * raid set needs to run to provide the repective reshape
+		  * check functions via its MD personality instance.
+		  *
+		  * So do the reshape check after md_run() succeeded.
+		  */
+		r = rs_prepare_reshape(rs);
+		if (r)
+			return r;
 
+		/* Reshaping ain't recovery, so disable recovery */
 		rs_setup_recovery(rs, MaxSector);
 		rs_set_cur(rs);
 	} else {
-- 
2.5.5
