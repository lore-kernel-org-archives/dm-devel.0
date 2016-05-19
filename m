From: heinzm@redhat.com
Subject: [PATCH 05/11] dm-raid: cleanup / provide infrastructure
Date: Thu, 19 May 2016 18:49:28 +0200
Message-ID: <1463676574-12596-6-git-send-email-heinzm@redhat.com>
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

More flag testing infrastracture and usage of it for simplification/consistency:

 - add _test_flags() function

 - use it to simplify rs_check_for_invalid_flags()

 - use _test_flag() throughout

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 48 +++++++++++++++++++++++-------------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index ba04db4..7f85243 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -175,6 +175,12 @@ static bool _test_flag(uint32_t flag, uint32_t flags)
 	return (flag & flags) ? true : false;
 }
 
+/* Test multiple @flags in @all_flags */
+static bool _test_flags(uint32_t flags, uint32_t all_flags)
+{
+	return (flags & all_flags) ? true : false;
+}
+
 /* Return true if single @flag is set in @*flags, else set it and return false */
 static bool _test_and_set_flag(uint32_t flag, uint32_t *flags)
 {
@@ -298,16 +304,8 @@ static uint32_t _invalid_flags(struct raid_set *rs)
  */
 static int rs_check_for_invalid_flags(struct raid_set *rs)
 {
-	unsigned int ctr_flags = rs->ctr_flags, flag = 0;
-	const uint32_t invalid_flags = _invalid_flags(rs);
-
-	while ((ctr_flags &= ~flag)) {
-		flag = 1 << __ffs(ctr_flags);
-
-		if (_test_flag(flag, rs->ctr_flags) &&
-		    _test_flag(flag, invalid_flags))
-			return ti_error_einval(rs->ti, "Invalid flag combined");
-	}
+	if (_test_flags(rs->ctr_flags, _invalid_flags(rs)))
+		return ti_error_einval(rs->ti, "Invalid flag combined");
 
 	return 0;
 }
@@ -1152,7 +1150,7 @@ static int super_init_validation(struct mddev *mddev, struct md_rdev *rdev)
 		return -EINVAL;
 	}
 
-	if (!(rs->ctr_flags & (CTR_FLAG_SYNC | CTR_FLAG_NOSYNC)))
+	if (!(_test_flags(CTR_FLAGS_ANY_SYNC, rs->ctr_flags)))
 		mddev->recovery_cp = le64_to_cpu(sb->array_resync_offset);
 
 	/*
@@ -1290,7 +1288,7 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 		 */
 		rdev->sectors = to_sector(i_size_read(rdev->bdev->bd_inode));
 
-		if (rs->ctr_flags & CTR_FLAG_SYNC)
+		if (_test_flag(CTR_FLAG_SYNC, rs->ctr_flags))
 			continue;
 
 		if (!rdev->meta_bdev)
@@ -1647,7 +1645,7 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 	case STATUSTYPE_TABLE:
 		/* The string you would use to construct this array */
 		for (i = 0; i < rs->md.raid_disks; i++) {
-			if ((rs->ctr_flags & CTR_FLAG_REBUILD) &&
+			if (_test_flag(CTR_FLAG_REBUILD, rs->ctr_flags) &&
 			    rs->dev[i].data_dev &&
 			    !test_bit(In_sync, &rs->dev[i].rdev.flags))
 				raid_param_cnt += 2; /* for rebuilds */
@@ -1663,26 +1661,26 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 		DMEMIT("%s %u %u", rs->raid_type->name,
 		       raid_param_cnt, rs->md.chunk_sectors);
 
-		if ((rs->ctr_flags & CTR_FLAG_SYNC) &&
-		    (rs->md.recovery_cp == MaxSector))
+		if (_test_flag(CTR_FLAG_SYNC, rs->ctr_flags) &&
+		    rs->md.recovery_cp == MaxSector)
 			DMEMIT(" sync");
-		if (rs->ctr_flags & CTR_FLAG_NOSYNC)
+		if (_test_flag(CTR_FLAG_NOSYNC, rs->ctr_flags))
 			DMEMIT(" nosync");
 
 		for (i = 0; i < rs->md.raid_disks; i++)
-			if ((rs->ctr_flags & CTR_FLAG_REBUILD) &&
+			if (_test_flag(CTR_FLAG_REBUILD, rs->ctr_flags) &&
 			    rs->dev[i].data_dev &&
 			    !test_bit(In_sync, &rs->dev[i].rdev.flags))
 				DMEMIT(" rebuild %u", i);
 
-		if (rs->ctr_flags & CTR_FLAG_DAEMON_SLEEP)
+		if (_test_flag(CTR_FLAG_DAEMON_SLEEP, rs->ctr_flags))
 			DMEMIT(" daemon_sleep %lu",
 			       rs->md.bitmap_info.daemon_sleep);
 
-		if (rs->ctr_flags & CTR_FLAG_MIN_RECOVERY_RATE)
+		if (_test_flag(CTR_FLAG_MIN_RECOVERY_RATE, rs->ctr_flags))
 			DMEMIT(" min_recovery_rate %d", rs->md.sync_speed_min);
 
-		if (rs->ctr_flags & CTR_FLAG_MAX_RECOVERY_RATE)
+		if (_test_flag(CTR_FLAG_MAX_RECOVERY_RATE, rs->ctr_flags))
 			DMEMIT(" max_recovery_rate %d", rs->md.sync_speed_max);
 
 		for (i = 0; i < rs->md.raid_disks; i++)
@@ -1690,11 +1688,11 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 			    test_bit(WriteMostly, &rs->dev[i].rdev.flags))
 				DMEMIT(" write_mostly %u", i);
 
-		if (rs->ctr_flags & CTR_FLAG_MAX_WRITE_BEHIND)
+		if (_test_flag(CTR_FLAG_MAX_WRITE_BEHIND, rs->ctr_flags))
 			DMEMIT(" max_write_behind %lu",
 			       rs->md.bitmap_info.max_write_behind);
 
-		if (rs->ctr_flags & CTR_FLAG_STRIPE_CACHE) {
+		if (_test_flag(CTR_FLAG_STRIPE_CACHE, rs->ctr_flags)) {
 			struct r5conf *conf = rs->md.private;
 
 			/* convert from kiB to sectors */
@@ -1702,15 +1700,15 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 			       conf ? conf->max_nr_stripes * 2 : 0);
 		}
 
-		if (rs->ctr_flags & CTR_FLAG_REGION_SIZE)
+		if (_test_flag(CTR_FLAG_REGION_SIZE, rs->ctr_flags))
 			DMEMIT(" region_size %lu",
 			       rs->md.bitmap_info.chunksize >> 9);
 
-		if (rs->ctr_flags & CTR_FLAG_RAID10_COPIES)
+		if (_test_flag(CTR_FLAG_RAID10_COPIES, rs->ctr_flags))
 			DMEMIT(" raid10_copies %u",
 			       raid10_md_layout_to_copies(rs->md.layout));
 
-		if (rs->ctr_flags & CTR_FLAG_RAID10_FORMAT)
+		if (_test_flag(CTR_FLAG_RAID10_FORMAT, rs->ctr_flags))
 			DMEMIT(" raid10_format %s",
 			       raid10_md_layout_to_format(rs->md.layout));
 
-- 
2.5.5
