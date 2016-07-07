From: heinzm@redhat.com
Subject: [PATCH V2 23/26] dm raid: support delta_disk for raid1,
	fix table output
Date: Thu,  7 Jul 2016 16:25:44 +0200
Message-ID: <1467901544-31250-4-git-send-email-heinzm@redhat.com>
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

Add "delta_disks" constructor argument support to raid1 to allow for consistent
userspace disk addition/removal handling.

Fix raid_status() to report all raid disks with status and table output on disk
adding reshapes, not just the ones listed on the mddev;
optimize its rebuild and writemostly output.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 92 ++++++++++++++++++++++++++++------------------------
 1 file changed, 49 insertions(+), 43 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 473c6d9..4caf51fe 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -132,6 +132,7 @@ struct raid_dev {
 				 CTR_FLAG_MAX_RECOVERY_RATE | \
 				 CTR_FLAG_MAX_WRITE_BEHIND | \
 				 CTR_FLAG_REGION_SIZE | \
+				 CTR_FLAG_DELTA_DISKS | \
 				 CTR_FLAG_DATA_OFFSET)
 
 /* "raid10" does not accept any raid1 or stripe cache options */
@@ -1714,9 +1715,13 @@ static bool rs_reshape_requested(struct raid_set *rs)
 		 rs->delta_disks;
 
 	/* Historical case to support raid1 reshape without delta disks */
-	if (mddev->level == 1)
+	if (mddev->level == 1) {
+		if (rs->delta_disks)
+			return !!rs->delta_disks;
+
 		return !change &&
 		       mddev->raid_disks != rs->raid_disks;
+	}
 
 	if (mddev->level == 10)
 		return change &&
@@ -1837,8 +1842,8 @@ static int rs_check_reshape(struct raid_set *rs)
 		rs->ti->error = "Convert request on recovering raid set prohibited";
 	else if (rs_is_reshaping(rs))
 		rs->ti->error = "raid set already reshaping!";
-	else if (!(rs_is_raid10(rs) || rs_is_raid456(rs)))
-		rs->ti->error = "Reshaping only supported for raid4/5/6/10";
+	else if (!(rs_is_raid1(rs) || rs_is_raid10(rs) || rs_is_raid456(rs)))
+		rs->ti->error = "Reshaping only supported for raid1/4/5/6/10";
 	else
 		return 0;
 
@@ -2566,16 +2571,17 @@ static int rs_prepare_reshape(struct raid_set *rs)
 	} else if (rs_is_raid456(rs))
 		reshape = true;
 
-	/*
-	 * HM FIXME: process raid1 via delta_disks as well?
-	 *           Would cause allocations in raid1->check_reshape
-	 *           though, thus more issues with potential failures
-	 */
 	else if (rs_is_raid1(rs)) {
-		set_bit(RT_FLAG_KEEP_RS_FROZEN, &rs->runtime_flags);
-		mddev->raid_disks = rs->raid_disks;
-		reshape = false;
-
+		if (rs->delta_disks) {
+			/* Process raid1 via delta_disks */
+			mddev->degraded = rs->delta_disks < 0 ? -rs->delta_disks : rs->delta_disks;
+			reshape = true;
+		} else {
+			/* Process raid1 without delta_disks */
+			mddev->raid_disks = rs->raid_disks;
+			set_bit(RT_FLAG_KEEP_RS_FROZEN, &rs->runtime_flags);
+			reshape = false;
+		}
 	} else {
 		rs->ti->error = "Called with bogus raid type";
 		return -EINVAL;
@@ -2585,12 +2591,9 @@ static int rs_prepare_reshape(struct raid_set *rs)
 		set_bit(RT_FLAG_RESHAPE_RS, &rs->runtime_flags);
 		set_bit(RT_FLAG_UPDATE_SBS, &rs->runtime_flags);
 		set_bit(RT_FLAG_KEEP_RS_FROZEN, &rs->runtime_flags);
-	}
-	/* Create new superblocks and bitmaps, if any */
-	if (mddev->raid_disks < rs->raid_disks) {
+	} else if (mddev->raid_disks < rs->raid_disks)
+		/* Create new superblocks and bitmaps, if any new disks */
 		set_bit(RT_FLAG_UPDATE_SBS, &rs->runtime_flags);
-		rs_set_cur(rs);
-	}
 
 	return 0;
 }
@@ -2656,7 +2659,7 @@ static int rs_setup_reshape(struct raid_set *rs)
 			rdev->raid_disk = d;
 
 			rdev->sectors = mddev->dev_sectors;
-			rdev->recovery_offset = MaxSector;
+			rdev->recovery_offset = rs_is_raid1(rs) ? 0 : MaxSector;
 		}
 
 		mddev->reshape_backwards = 0; /* adding disks -> forward reshape */
@@ -2971,10 +2974,12 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		/* Restore new, ctr requested layout to perform check */
 		rs_config_restore(rs, &rs_layout);
 
-		r = rs->md.pers->check_reshape(&rs->md);
-		if (r) {
-			ti->error = "Reshape check failed";
-			goto bad_check_reshape;
+		if (rs->md.pers->start_reshape) {
+			r = rs->md.pers->check_reshape(&rs->md);
+			if (r) {
+				ti->error = "Reshape check failed";
+				goto bad_check_reshape;
+			}
 		}
 	}
 
@@ -3150,10 +3155,11 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 	struct raid_set *rs = ti->private;
 	struct mddev *mddev = &rs->md;
 	struct r5conf *conf = mddev->private;
-	int max_nr_stripes = conf ? conf->max_nr_stripes : 0;
+	int i, max_nr_stripes = conf ? conf->max_nr_stripes : 0;
 	bool array_in_sync;
 	unsigned int raid_param_cnt = 1; /* at least 1 for chunksize */
 	unsigned int sz = 0;
+	unsigned int rebuild_disks;
 	unsigned int write_mostly_params = 0;
 	sector_t progress, resync_max_sectors, resync_mismatches;
 	const char *sync_action;
@@ -3181,7 +3187,8 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 
 		/* HM FIXME: do we want another state char for raid0? It shows 'D' or 'A' now */
 		rdev_for_each(rdev, mddev)
-			DMEMIT(__raid_dev_status(rdev, array_in_sync));
+		for (i = 0; i < rs->raid_disks; i++)
+			DMEMIT(__raid_dev_status(&rs->dev[i].rdev, array_in_sync));
 
 		/*
 		 * In-sync/Reshape ratio:
@@ -3233,11 +3240,11 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 		/* Report the table line string you would use to construct this raid set */
 
 		/* Calculate raid parameter count */
-		rdev_for_each(rdev, mddev)
-			if (test_bit(WriteMostly, &rdev->flags))
+		for (i = 0; i < rs->raid_disks; i++)
+			if (test_bit(WriteMostly, &rs->dev[i].rdev.flags))
 				write_mostly_params += 2;
-		raid_param_cnt += memweight(rs->rebuild_disks,
-					    DISKS_ARRAY_ELEMS * sizeof(*rs->rebuild_disks)) * 2 +
+		rebuild_disks = memweight(rs->rebuild_disks, DISKS_ARRAY_ELEMS * sizeof(*rs->rebuild_disks));
+		raid_param_cnt += rebuild_disks * 2 +
 				  write_mostly_params +
 				  hweight32(rs->ctr_flags & CTR_FLAG_OPTIONS_NO_ARGS) +
 				  hweight32(rs->ctr_flags & CTR_FLAG_OPTIONS_ONE_ARG) * 2;
@@ -3264,18 +3271,20 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 					  mddev->bitmap_info.daemon_sleep);
 		if (test_bit(__CTR_FLAG_DELTA_DISKS, &rs->ctr_flags))
 			DMEMIT(" %s %d", dm_raid_arg_name_by_flag(CTR_FLAG_DELTA_DISKS),
-					 mddev->delta_disks);
+					 max(rs->delta_disks, mddev->delta_disks));
 		if (test_bit(__CTR_FLAG_STRIPE_CACHE, &rs->ctr_flags))
 			DMEMIT(" %s %d", dm_raid_arg_name_by_flag(CTR_FLAG_STRIPE_CACHE),
 					 max_nr_stripes);
-		rdev_for_each(rdev, mddev)
-			if (test_bit(rdev->raid_disk, (void *) rs->rebuild_disks))
-				DMEMIT(" %s %u", dm_raid_arg_name_by_flag(CTR_FLAG_REBUILD),
-						 rdev->raid_disk);
-		rdev_for_each(rdev, mddev)
-			if (test_bit(WriteMostly, &rdev->flags))
-				DMEMIT(" %s %d", dm_raid_arg_name_by_flag(CTR_FLAG_WRITE_MOSTLY),
-						 rdev->raid_disk);
+		if (rebuild_disks)
+			for (i = 0; i < rs->raid_disks; i++)
+				if (test_bit(rs->dev[i].rdev.raid_disk, (void *) rs->rebuild_disks))
+					DMEMIT(" %s %u", dm_raid_arg_name_by_flag(CTR_FLAG_REBUILD),
+							 rs->dev[i].rdev.raid_disk);
+		if (write_mostly_params)
+			for (i = 0; i < rs->raid_disks; i++)
+				if (test_bit(WriteMostly, &rs->dev[i].rdev.flags))
+					DMEMIT(" %s %d", dm_raid_arg_name_by_flag(CTR_FLAG_WRITE_MOSTLY),
+					       rs->dev[i].rdev.raid_disk);
 		if (test_bit(__CTR_FLAG_MAX_WRITE_BEHIND, &rs->ctr_flags))
 			DMEMIT(" %s %lu", dm_raid_arg_name_by_flag(CTR_FLAG_MAX_WRITE_BEHIND),
 					  mddev->bitmap_info.max_write_behind);
@@ -3286,12 +3295,9 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 			DMEMIT(" %s %d", dm_raid_arg_name_by_flag(CTR_FLAG_MIN_RECOVERY_RATE),
 					 mddev->sync_speed_min);
 		DMEMIT(" %d", rs->raid_disks);
-		rdev_for_each(rdev, mddev) {
-			struct raid_dev *rd = container_of(rdev, struct raid_dev, rdev);
-
-			DMEMIT(" %s %s", __get_dev_name(rd->meta_dev),
-					 __get_dev_name(rd->data_dev));
-		}
+		for (i = 0; i < rs->raid_disks; i++)
+			DMEMIT(" %s %s", __get_dev_name(rs->dev[i].meta_dev),
+					 __get_dev_name(rs->dev[i].data_dev));
 	}
 }
 
-- 
2.5.5
