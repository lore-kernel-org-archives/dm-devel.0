From: heinzm@redhat.com
Subject: [PATCH 11/26] dm raid: clearify and fix recovery
Date: Wed,  6 Jul 2016 19:24:42 +0200
Message-ID: <1467825897-26058-12-git-send-email-heinzm@redhat.com>
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

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 64 ++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 55 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 63883f4..7e334b6 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -349,6 +349,12 @@ static bool rs_is_raid10(struct raid_set *rs)
 	return rs->md.level == 10;
 }
 
+/* Return true, if raid set in @rs is level 6 */
+static bool rs_is_raid6(struct raid_set *rs)
+{
+	return rs->md.level == 6;
+}
+
 /* Return true, if raid set in @rs is level 4, 5 or 6 */
 static bool rs_is_raid456(struct raid_set *rs)
 {
@@ -681,7 +687,7 @@ static struct raid_set *raid_set_alloc(struct dm_target *ti, struct raid_type *r
 	rs->md.layout = raid_type->algorithm;
 	rs->md.new_layout = rs->md.layout;
 	rs->md.delta_disks = 0;
-	rs->md.recovery_cp = rs_is_raid0(rs) ? MaxSector : 0;
+	rs->md.recovery_cp = MaxSector;
 
 	for (i = 0; i < raid_devs; i++)
 		md_rdev_init(&rs->dev[i].rdev);
@@ -1090,7 +1096,6 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 				rs->ti->error = "Only one 'nosync' argument allowed";
 				return -EINVAL;
 			}
-			rs->md.recovery_cp = MaxSector;
 			continue;
 		}
 		if (!strcasecmp(key, dm_raid_arg_name_by_flag(CTR_FLAG_SYNC))) {
@@ -1098,7 +1103,6 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 				rs->ti->error = "Only one 'sync' argument allowed";
 				return -EINVAL;
 			}
-			rs->md.recovery_cp = 0;
 			continue;
 		}
 		if (!strcasecmp(key, dm_raid_arg_name_by_flag(CTR_FLAG_RAID10_USE_NEAR_SETS))) {
@@ -1412,7 +1416,6 @@ static int rs_set_dev_and_array_sectors(struct raid_set *rs, bool use_mddev)
 	struct mddev *mddev = &rs->md;
 	struct md_rdev *rdev;
 	sector_t array_sectors = rs->ti->len, dev_sectors = rs->ti->len;
-	sector_t cur_dev_sectors = rs->dev[0].rdev.sectors;
 
 	if (use_mddev) {
 		delta_disks = mddev->delta_disks;
@@ -1453,15 +1456,50 @@ static int rs_set_dev_and_array_sectors(struct raid_set *rs, bool use_mddev)
 	mddev->array_sectors = array_sectors;
 	mddev->dev_sectors = dev_sectors;
 
-	if (!rs_is_raid0(rs) && dev_sectors > cur_dev_sectors)
-		mddev->recovery_cp = dev_sectors;
-
 	return 0;
 bad:
 	rs->ti->error = "Target length not divisible by number of data devices";
 	return EINVAL;
 }
 
+/* Setup recovery on @rs */
+static void __rs_setup_recovery(struct raid_set *rs, sector_t dev_sectors)
+{
+	/* raid0 does not recover */
+	if (rs_is_raid0(rs))
+		rs->md.recovery_cp = MaxSector;
+	/*
+	 * A raid6 set has to be recovered either
+	 * completely or for the grown part to
+	 * ensure proper parity and Q-Syndrome
+	 */
+	else if (rs_is_raid6(rs))
+		rs->md.recovery_cp = dev_sectors;
+	/*
+	 * Other raid set types may skip recovery
+	 * depending on the 'nosync' flag.
+	 */
+	else
+		rs->md.recovery_cp = test_bit(__CTR_FLAG_NOSYNC, &rs->ctr_flags)
+				     ? MaxSector : dev_sectors;
+}
+
+/* Setup recovery on @rs based on raid type, device size and 'nosync' flag */
+static void rs_setup_recovery(struct raid_set *rs, sector_t dev_sectors)
+{
+	if (!dev_sectors)
+		/* New raid set or 'sync' flag provided */
+		__rs_setup_recovery(rs, 0);
+	else if (dev_sectors == MaxSector)
+		/* Prevent recovery */
+		__rs_setup_recovery(rs, MaxSector);
+	else if (rs->dev[0].rdev.sectors < dev_sectors)
+		/* Grown raid set */
+		__rs_setup_recovery(rs, rs->dev[0].rdev.sectors);
+	else
+		__rs_setup_recovery(rs, MaxSector);
+}
+
 static void do_table_event(struct work_struct *ws)
 {
 	struct raid_set *rs = container_of(ws, struct raid_set, md.event_work);
@@ -2086,7 +2124,6 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 		if (new_devs == rs->raid_disks) {
 			DMINFO("Superblocks created for new raid set");
 			set_bit(MD_ARRAY_FIRST_USE, &mddev->flags);
-			mddev->recovery_cp = 0;
 		} else if (new_devs != rebuilds &&
 			   new_devs != rs->delta_disks) {
 			DMERR("New device injected into existing raid set without "
@@ -2633,6 +2670,7 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	int r;
 	struct raid_type *rt;
 	unsigned num_raid_params, num_raid_devs;
+	sector_t calculated_dev_sectors;
 	struct raid_set *rs = NULL;
 	const char *arg;
 	struct rs_layout rs_layout;
@@ -2689,6 +2727,8 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	if (r)
 		return r;
 
+	calculated_dev_sectors = rs->dev[0].rdev.sectors;
+
 	/*
 	 * Backup any new raid set level, layout, ...
 	 * requested to be able to compare to superblock
@@ -2700,6 +2740,8 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	if (r)
 		goto bad;
 
+	rs_setup_recovery(rs, calculated_dev_sectors);
+
 	INIT_WORK(&rs->md.event_work, do_table_event);
 	ti->private = rs;
 	ti->num_flush_bios = 1;
@@ -2786,8 +2828,12 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 			set_bit(MD_ARRAY_FIRST_USE, &rs->md.flags);
 
 		rs_set_cur(rs);
-	} else
+		rs_setup_recovery(rs, MaxSector);
+	} else {
 		rs_set_cur(rs);
+		rs_setup_recovery(rs, test_bit(__CTR_FLAG_SYNC, &rs->ctr_flags) ?
+				      0 : calculated_dev_sectors);
+	}
 
 	/* If constructor requested it, change data and new_data offsets */
 	r = rs_adjust_data_offsets(rs);
-- 
2.5.5
