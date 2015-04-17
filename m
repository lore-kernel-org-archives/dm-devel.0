From: heinzm@redhat.com
Subject: [PATCH 1/3] dm-raid: Add support for the MD RAID0
	personality
Date: Fri, 17 Apr 2015 14:39:44 +0200
Message-ID: <1429274386-16385-2-git-send-email-heinzm@redhat.com>
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


This patch adds access to the MD RAID0 personality to dm-raid
(in addition to the already supported raid1/10/4/5/6 personalities)
to enable single zone striping.

The following changes enable that access:
- add type definition to raid_types array
- make bitmap creation conditonal in super_validat(), because
  it is not allowed in RAID0
- set rdev->sectors to the data image size in super_validate()
  to allow the RAID0 personality to calculate the MD array
  size properly
- set rs->md.gendisk, because it is required by RAID0
  to set disk stack limits
- enhance raid_resume() to not load bitmap in case of "raid0"
- enhance raid_status() to always report full sync for "raid0"
  so that userspace checks for 100% sync will succeed and allow
  for resize (and takeover/reshape once added in future paches)
- use mdddev(un)lock() functions instead of direct mutex_(un)lock()
  (wrapped in here because it's a trivial change)


Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Tested-by: Heinz Mauelshagen <heinzm@redhat.com>

---
 drivers/md/dm-raid.c | 115 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 68 insertions(+), 47 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 88e4c7f..14890dd 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -18,6 +18,7 @@
 
 #define DM_MSG_PREFIX "raid"
 
+
 static bool devices_handle_discard_safely = false;
 
 /*
@@ -81,6 +82,7 @@ static struct raid_type {
 	const unsigned level;		/* RAID level. */
 	const unsigned algorithm;	/* RAID algorithm. */
 } raid_types[] = {
+	{"raid0",    "RAID0 (striping)",                0, 2, 0, 0 /* NONE */},
 	{"raid1",    "RAID1 (mirroring)",               0, 2, 1, 0 /* NONE */},
 	{"raid10",   "RAID10 (striped mirrors)",        0, 2, 10, UINT_MAX /* Varies */},
 	{"raid4",    "RAID4 (dedicated parity disk)",	1, 2, 5, ALGORITHM_PARITY_0},
@@ -720,7 +722,7 @@ static int parse_raid_params(struct raid_set *rs, char **argv,
 		rs->md.layout = raid10_format_to_md_layout(raid10_format,
 							   raid10_copies);
 		rs->md.new_layout = rs->md.layout;
-	} else if ((rs->raid_type->level > 1) &&
+	} else if ((!rs->raid_type->level || rs->raid_type->level > 1) &&
 		   sector_div(sectors_per_dev,
 			      (rs->md.raid_disks - rs->raid_type->parity_devs))) {
 		rs->ti->error = "Target length not divisible by number of data devices";
@@ -1026,8 +1028,9 @@ static int super_init_validation(struct mddev *mddev, struct md_rdev *rdev)
 	return 0;
 }
 
-static int super_validate(struct mddev *mddev, struct md_rdev *rdev)
+static int super_validate(struct raid_set *rs, struct md_rdev *rdev)
 {
+	struct mddev *mddev = &rs->md;
 	struct dm_raid_superblock *sb = page_address(rdev->sb_page);
 
 	/*
@@ -1037,8 +1040,10 @@ static int super_validate(struct mddev *mddev, struct md_rdev *rdev)
 	if (!mddev->events && super_init_validation(mddev, rdev))
 		return -EINVAL;
 
-	mddev->bitmap_info.offset = 4096 >> 9; /* Enable bitmap creation */
-	rdev->mddev->bitmap_info.default_offset = 4096 >> 9;
+	/* Enable bitmap creation for RAID levels != 0 */
+	mddev->bitmap_info.offset = (rs->raid_type->level) ? 4096 >> 9 : 0;
+	rdev->mddev->bitmap_info.default_offset = mddev->bitmap_info.offset;
+
 	if (!test_bit(FirstUse, &rdev->flags)) {
 		rdev->recovery_offset = le64_to_cpu(sb->disk_recovery_offset);
 		if (rdev->recovery_offset != MaxSector)
@@ -1082,6 +1087,8 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 		 * that the "sync" directive is disallowed during the
 		 * reshape.
 		 */
+		rdev->sectors = to_sector(i_size_read(rdev->bdev->bd_inode));
+
 		if (rs->print_flags & DMPF_SYNC)
 			continue;
 
@@ -1140,11 +1147,11 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 	 * validation for the remaining devices.
 	 */
 	ti->error = "Unable to assemble array: Invalid superblocks";
-	if (super_validate(mddev, freshest))
+	if (super_validate(rs, freshest))
 		return -EINVAL;
 
 	rdev_for_each(rdev, mddev)
-		if ((rdev != freshest) && super_validate(mddev, rdev))
+		if ((rdev != freshest) && super_validate(rs, rdev))
 			return -EINVAL;
 
 	return 0;
@@ -1282,10 +1289,14 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	 */
 	configure_discard_support(ti, rs);
 
-	mutex_lock(&rs->md.reconfig_mutex);
+	/* "raid0" calls disk_stack_limits() requiring gendisk access */
+	rs->md.gendisk = dm_disk(dm_table_get_md(ti->table));
+
+	/* Has to be held on running the array */
+	mddev_lock_nointr(&rs->md);
 	ret = md_run(&rs->md);
 	rs->md.in_sync = 0; /* Assume already marked dirty */
-	mutex_unlock(&rs->md.reconfig_mutex);
+	mddev_unlock(&rs->md);
 
 	if (ret) {
 		ti->error = "Fail to run raid array";
@@ -1368,34 +1379,40 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 	case STATUSTYPE_INFO:
 		DMEMIT("%s %d ", rs->raid_type->name, rs->md.raid_disks);
 
-		if (test_bit(MD_RECOVERY_RUNNING, &rs->md.recovery))
-			sync = rs->md.curr_resync_completed;
-		else
-			sync = rs->md.recovery_cp;
-
-		if (sync >= rs->md.resync_max_sectors) {
-			/*
-			 * Sync complete.
-			 */
+		if (rs->raid_type->level) {
+			if (test_bit(MD_RECOVERY_RUNNING, &rs->md.recovery))
+				sync = rs->md.curr_resync_completed;
+			else
+				sync = rs->md.recovery_cp;
+
+			if (sync >= rs->md.resync_max_sectors) {
+				/*
+				 * Sync complete.
+				 */
+				array_in_sync = 1;
+				sync = rs->md.resync_max_sectors;
+			} else if (test_bit(MD_RECOVERY_REQUESTED, &rs->md.recovery)) {
+				/*
+				 * If "check" or "repair" is occurring, the array has
+				 * undergone and initial sync and the health characters
+				 * should not be 'a' anymore.
+				 */
+				array_in_sync = 1;
+			} else {
+				/*
+				 * The array may be doing an initial sync, or it may
+				 * be rebuilding individual components.  If all the
+				 * devices are In_sync, then it is the array that is
+				 * being initialized.
+				 */
+				for (i = 0; i < rs->md.raid_disks; i++)
+					if (!test_bit(In_sync, &rs->dev[i].rdev.flags))
+						array_in_sync = 1;
+			}
+		} else {
+			/* RAID0 */
 			array_in_sync = 1;
 			sync = rs->md.resync_max_sectors;
-		} else if (test_bit(MD_RECOVERY_REQUESTED, &rs->md.recovery)) {
-			/*
-			 * If "check" or "repair" is occurring, the array has
-			 * undergone and initial sync and the health characters
-			 * should not be 'a' anymore.
-			 */
-			array_in_sync = 1;
-		} else {
-			/*
-			 * The array may be doing an initial sync, or it may
-			 * be rebuilding individual components.  If all the
-			 * devices are In_sync, then it is the array that is
-			 * being initialized.
-			 */
-			for (i = 0; i < rs->md.raid_disks; i++)
-				if (!test_bit(In_sync, &rs->dev[i].rdev.flags))
-					array_in_sync = 1;
 		}
 
 		/*
@@ -1684,26 +1701,30 @@ static void raid_resume(struct dm_target *ti)
 {
 	struct raid_set *rs = ti->private;
 
-	set_bit(MD_CHANGE_DEVS, &rs->md.flags);
-	if (!rs->bitmap_loaded) {
-		bitmap_load(&rs->md);
-		rs->bitmap_loaded = 1;
-	} else {
-		/*
-		 * A secondary resume while the device is active.
-		 * Take this opportunity to check whether any failed
-		 * devices are reachable again.
-		 */
-		attempt_restore_of_faulty_devices(rs);
+	if (rs->raid_type->level) {
+		set_bit(MD_CHANGE_DEVS, &rs->md.flags);
+
+		if (!rs->bitmap_loaded) {
+			bitmap_load(&rs->md);
+			rs->bitmap_loaded = 1;
+		} else {
+			/*
+			 * A secondary resume while the device is active.
+			 * Take this opportunity to check whether any failed
+			 * devices are reachable again.
+			 */
+			attempt_restore_of_faulty_devices(rs);
+		}
+
+		clear_bit(MD_RECOVERY_FROZEN, &rs->md.recovery);
 	}
 
-	clear_bit(MD_RECOVERY_FROZEN, &rs->md.recovery);
 	mddev_resume(&rs->md);
 }
 
 static struct target_type raid_target = {
 	.name = "raid",
-	.version = {1, 6, 0},
+	.version = {1, 7, 0},
 	.module = THIS_MODULE,
 	.ctr = raid_ctr,
 	.dtr = raid_dtr,
-- 
2.1.0
