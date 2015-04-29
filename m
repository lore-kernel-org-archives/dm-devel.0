From: heinzm@redhat.com
Subject: [PATCH v2 1/4] dm-raid: Add support for the MD RAID0
	personality
Date: Wed, 29 Apr 2015 14:03:04 +0200
Message-ID: <1430308987-24703-2-git-send-email-heinzm@redhat.com>
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

It avoids setting rs->md.gendisk by introducing a conditional
to MD raid0, because device stack and discard settings are done
by dm core

The following changes enable that access:
- add type definition to raid_types array
- make bitmap creation conditonal in super_validate(), because
  bitmaps are not allowed in raid0
- set rdev->sectors to the data image size in super_validate()
  to allow the raid0 personality to calculate the MD array
  size properly
- use mdddev(un)lock() functions instead of direct mutex_(un)lock()
  (wrapped in here because it's a trivial change)
- enhance raid_status() to always report full sync for raid0
  so that userspace checks for 100% sync will succeed and allow
  for resize (and takeover/reshape once added in future paches)
- enhance raid_resume() to not load bitmap in case of raid0
- raise version to 1.7.0 because of the raid0 API change

As side changes I applied:
- ensure maximum device limit in superblock
- rename DMPF_* (print flags) to CTR_FLAG_* (constructor flags)
  and their respective struct raid_set member
- use strcasecmp() in raid10_format_to_md_layout() as in the constructor


Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Tested-by: Heinz Mauelshagen <heinzm@redhat.com>

---
 drivers/md/dm-raid.c | 204 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 111 insertions(+), 93 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 88e4c7f..c541d5a 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2010-2011 Neil Brown
- * Copyright (C) 2010-2014 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2010-2015 Red Hat, Inc. All rights reserved.
  *
  * This file is released under the GPL.
  */
@@ -17,6 +17,7 @@
 #include <linux/device-mapper.h>
 
 #define DM_MSG_PREFIX "raid"
+#define	MAX_RAID_DEVICES	253 /* raid4/5/6 limit */
 
 static bool devices_handle_discard_safely = false;
 
@@ -45,25 +46,25 @@ struct raid_dev {
 };
 
 /*
- * Flags for rs->print_flags field.
+ * Flags for rs->ctr_flags field.
  */
-#define DMPF_SYNC              0x1
-#define DMPF_NOSYNC            0x2
-#define DMPF_REBUILD           0x4
-#define DMPF_DAEMON_SLEEP      0x8
-#define DMPF_MIN_RECOVERY_RATE 0x10
-#define DMPF_MAX_RECOVERY_RATE 0x20
-#define DMPF_MAX_WRITE_BEHIND  0x40
-#define DMPF_STRIPE_CACHE      0x80
-#define DMPF_REGION_SIZE       0x100
-#define DMPF_RAID10_COPIES     0x200
-#define DMPF_RAID10_FORMAT     0x400
+#define CTR_FLAG_SYNC              0x1
+#define CTR_FLAG_NOSYNC            0x2
+#define CTR_FLAG_REBUILD           0x4
+#define CTR_FLAG_DAEMON_SLEEP      0x8
+#define CTR_FLAG_MIN_RECOVERY_RATE 0x10
+#define CTR_FLAG_MAX_RECOVERY_RATE 0x20
+#define CTR_FLAG_MAX_WRITE_BEHIND  0x40
+#define CTR_FLAG_STRIPE_CACHE      0x80
+#define CTR_FLAG_REGION_SIZE       0x100
+#define CTR_FLAG_RAID10_COPIES     0x200
+#define CTR_FLAG_RAID10_FORMAT     0x400
 
 struct raid_set {
 	struct dm_target *ti;
 
 	uint32_t bitmap_loaded;
-	uint32_t print_flags;
+	uint32_t ctr_flags;
 
 	struct mddev md;
 	struct raid_type *raid_type;
@@ -81,6 +82,7 @@ static struct raid_type {
 	const unsigned level;		/* RAID level. */
 	const unsigned algorithm;	/* RAID algorithm. */
 } raid_types[] = {
+	{"raid0",    "RAID0 (striping)",                0, 2, 0, 0 /* NONE */},
 	{"raid1",    "RAID1 (mirroring)",               0, 2, 1, 0 /* NONE */},
 	{"raid10",   "RAID10 (striped mirrors)",        0, 2, 10, UINT_MAX /* Varies */},
 	{"raid4",    "RAID4 (dedicated parity disk)",	1, 2, 5, ALGORITHM_PARITY_0},
@@ -119,15 +121,15 @@ static int raid10_format_to_md_layout(char *format, unsigned copies)
 {
 	unsigned n = 1, f = 1;
 
-	if (!strcmp("near", format))
+	if (!strcasecmp("near", format))
 		n = copies;
 	else
 		f = copies;
 
-	if (!strcmp("offset", format))
+	if (!strcasecmp("offset", format))
 		return 0x30000 | (f << 8) | n;
 
-	if (!strcmp("far", format))
+	if (!strcasecmp("far", format))
 		return 0x20000 | (f << 8) | n;
 
 	return (f << 8) | n;
@@ -555,12 +557,12 @@ static int parse_raid_params(struct raid_set *rs, char **argv,
 	for (i = 0; i < num_raid_params; i++) {
 		if (!strcasecmp(argv[i], "nosync")) {
 			rs->md.recovery_cp = MaxSector;
-			rs->print_flags |= DMPF_NOSYNC;
+			rs->ctr_flags |= CTR_FLAG_NOSYNC;
 			continue;
 		}
 		if (!strcasecmp(argv[i], "sync")) {
 			rs->md.recovery_cp = 0;
-			rs->print_flags |= DMPF_SYNC;
+			rs->ctr_flags |= CTR_FLAG_SYNC;
 			continue;
 		}
 
@@ -585,7 +587,7 @@ static int parse_raid_params(struct raid_set *rs, char **argv,
 				return -EINVAL;
 			}
 			raid10_format = argv[i];
-			rs->print_flags |= DMPF_RAID10_FORMAT;
+			rs->ctr_flags |= CTR_FLAG_RAID10_FORMAT;
 			continue;
 		}
 
@@ -602,7 +604,7 @@ static int parse_raid_params(struct raid_set *rs, char **argv,
 			}
 			clear_bit(In_sync, &rs->dev[value].rdev.flags);
 			rs->dev[value].rdev.recovery_offset = 0;
-			rs->print_flags |= DMPF_REBUILD;
+			rs->ctr_flags |= CTR_FLAG_REBUILD;
 		} else if (!strcasecmp(key, "write_mostly")) {
 			if (rs->raid_type->level != 1) {
 				rs->ti->error = "write_mostly option is only valid for RAID1";
@@ -618,7 +620,7 @@ static int parse_raid_params(struct raid_set *rs, char **argv,
 				rs->ti->error = "max_write_behind option is only valid for RAID1";
 				return -EINVAL;
 			}
-			rs->print_flags |= DMPF_MAX_WRITE_BEHIND;
+			rs->ctr_flags |= CTR_FLAG_MAX_WRITE_BEHIND;
 
 			/*
 			 * In device-mapper, we specify things in sectors, but
@@ -631,14 +633,14 @@ static int parse_raid_params(struct raid_set *rs, char **argv,
 			}
 			rs->md.bitmap_info.max_write_behind = value;
 		} else if (!strcasecmp(key, "daemon_sleep")) {
-			rs->print_flags |= DMPF_DAEMON_SLEEP;
+			rs->ctr_flags |= CTR_FLAG_DAEMON_SLEEP;
 			if (!value || (value > MAX_SCHEDULE_TIMEOUT)) {
 				rs->ti->error = "daemon sleep period out of range";
 				return -EINVAL;
 			}
 			rs->md.bitmap_info.daemon_sleep = value;
 		} else if (!strcasecmp(key, "stripe_cache")) {
-			rs->print_flags |= DMPF_STRIPE_CACHE;
+			rs->ctr_flags |= CTR_FLAG_STRIPE_CACHE;
 
 			/*
 			 * In device-mapper, we specify things in sectors, but
@@ -656,21 +658,21 @@ static int parse_raid_params(struct raid_set *rs, char **argv,
 				return -EINVAL;
 			}
 		} else if (!strcasecmp(key, "min_recovery_rate")) {
-			rs->print_flags |= DMPF_MIN_RECOVERY_RATE;
+			rs->ctr_flags |= CTR_FLAG_MIN_RECOVERY_RATE;
 			if (value > INT_MAX) {
 				rs->ti->error = "min_recovery_rate out of range";
 				return -EINVAL;
 			}
 			rs->md.sync_speed_min = (int)value;
 		} else if (!strcasecmp(key, "max_recovery_rate")) {
-			rs->print_flags |= DMPF_MAX_RECOVERY_RATE;
+			rs->ctr_flags |= CTR_FLAG_MAX_RECOVERY_RATE;
 			if (value > INT_MAX) {
 				rs->ti->error = "max_recovery_rate out of range";
 				return -EINVAL;
 			}
 			rs->md.sync_speed_max = (int)value;
 		} else if (!strcasecmp(key, "region_size")) {
-			rs->print_flags |= DMPF_REGION_SIZE;
+			rs->ctr_flags |= CTR_FLAG_REGION_SIZE;
 			region_size = value;
 		} else if (!strcasecmp(key, "raid10_copies") &&
 			   (rs->raid_type->level == 10)) {
@@ -678,7 +680,7 @@ static int parse_raid_params(struct raid_set *rs, char **argv,
 				rs->ti->error = "Bad value for 'raid10_copies'";
 				return -EINVAL;
 			}
-			rs->print_flags |= DMPF_RAID10_COPIES;
+			rs->ctr_flags |= CTR_FLAG_RAID10_COPIES;
 			raid10_copies = value;
 		} else {
 			DMERR("Unable to parse RAID parameter: %s", key);
@@ -720,7 +722,7 @@ static int parse_raid_params(struct raid_set *rs, char **argv,
 		rs->md.layout = raid10_format_to_md_layout(raid10_format,
 							   raid10_copies);
 		rs->md.new_layout = rs->md.layout;
-	} else if ((rs->raid_type->level > 1) &&
+	} else if ((!rs->raid_type->level || rs->raid_type->level > 1) &&
 		   sector_div(sectors_per_dev,
 			      (rs->md.raid_disks - rs->raid_type->parity_devs))) {
 		rs->ti->error = "Target length not divisible by number of data devices";
@@ -947,7 +949,7 @@ static int super_init_validation(struct mddev *mddev, struct md_rdev *rdev)
 		return -EINVAL;
 	}
 
-	if (!(rs->print_flags & (DMPF_SYNC | DMPF_NOSYNC)))
+	if (!(rs->ctr_flags & (CTR_FLAG_SYNC | CTR_FLAG_NOSYNC)))
 		mddev->recovery_cp = le64_to_cpu(sb->array_resync_offset);
 
 	/*
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
+	mddev->bitmap_info.offset = (rs->raid_type->level) ? to_sector(4096) : 0;
+	rdev->mddev->bitmap_info.default_offset = mddev->bitmap_info.offset;
+
 	if (!test_bit(FirstUse, &rdev->flags)) {
 		rdev->recovery_offset = le64_to_cpu(sb->disk_recovery_offset);
 		if (rdev->recovery_offset != MaxSector)
@@ -1073,7 +1078,7 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 	freshest = NULL;
 	rdev_for_each_safe(rdev, tmp, mddev) {
 		/*
-		 * Skipping super_load due to DMPF_SYNC will cause
+		 * Skipping super_load due to CTR_FLAG_SYNC will cause
 		 * the array to undergo initialization again as
 		 * though it were new.  This is the intended effect
 		 * of the "sync" directive.
@@ -1082,7 +1087,9 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 		 * that the "sync" directive is disallowed during the
 		 * reshape.
 		 */
-		if (rs->print_flags & DMPF_SYNC)
+		rdev->sectors = to_sector(i_size_read(rdev->bdev->bd_inode));
+
+		if (rs->ctr_flags & CTR_FLAG_SYNC)
 			continue;
 
 		if (!rdev->meta_bdev)
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
@@ -1243,7 +1250,7 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	}
 
 	if ((kstrtoul(argv[num_raid_params], 10, &num_raid_devs) < 0) ||
-	    (num_raid_devs >= INT_MAX)) {
+	    (num_raid_devs > MAX_RAID_DEVICES)) {
 		ti->error = "Cannot understand number of raid devices";
 		return -EINVAL;
 	}
@@ -1282,10 +1289,11 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	 */
 	configure_discard_support(ti, rs);
 
-	mutex_lock(&rs->md.reconfig_mutex);
+	/* Has to be held on running the array */
+	mddev_lock_nointr(&rs->md);
 	ret = md_run(&rs->md);
 	rs->md.in_sync = 0; /* Assume already marked dirty */
-	mutex_unlock(&rs->md.reconfig_mutex);
+	mddev_unlock(&rs->md);
 
 	if (ret) {
 		ti->error = "Fail to run raid array";
@@ -1368,34 +1376,40 @@ static void raid_status(struct dm_target *ti, status_type_t type,
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
@@ -1446,7 +1460,7 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 	case STATUSTYPE_TABLE:
 		/* The string you would use to construct this array */
 		for (i = 0; i < rs->md.raid_disks; i++) {
-			if ((rs->print_flags & DMPF_REBUILD) &&
+			if ((rs->ctr_flags & CTR_FLAG_REBUILD) &&
 			    rs->dev[i].data_dev &&
 			    !test_bit(In_sync, &rs->dev[i].rdev.flags))
 				raid_param_cnt += 2; /* for rebuilds */
@@ -1455,33 +1469,33 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 				raid_param_cnt += 2;
 		}
 
-		raid_param_cnt += (hweight32(rs->print_flags & ~DMPF_REBUILD) * 2);
-		if (rs->print_flags & (DMPF_SYNC | DMPF_NOSYNC))
+		raid_param_cnt += (hweight32(rs->ctr_flags & ~CTR_FLAG_REBUILD) * 2);
+		if (rs->ctr_flags & (CTR_FLAG_SYNC | CTR_FLAG_NOSYNC))
 			raid_param_cnt--;
 
 		DMEMIT("%s %u %u", rs->raid_type->name,
 		       raid_param_cnt, rs->md.chunk_sectors);
 
-		if ((rs->print_flags & DMPF_SYNC) &&
+		if ((rs->ctr_flags & CTR_FLAG_SYNC) &&
 		    (rs->md.recovery_cp == MaxSector))
 			DMEMIT(" sync");
-		if (rs->print_flags & DMPF_NOSYNC)
+		if (rs->ctr_flags & CTR_FLAG_NOSYNC)
 			DMEMIT(" nosync");
 
 		for (i = 0; i < rs->md.raid_disks; i++)
-			if ((rs->print_flags & DMPF_REBUILD) &&
+			if ((rs->ctr_flags & CTR_FLAG_REBUILD) &&
 			    rs->dev[i].data_dev &&
 			    !test_bit(In_sync, &rs->dev[i].rdev.flags))
 				DMEMIT(" rebuild %u", i);
 
-		if (rs->print_flags & DMPF_DAEMON_SLEEP)
+		if (rs->ctr_flags & CTR_FLAG_DAEMON_SLEEP)
 			DMEMIT(" daemon_sleep %lu",
 			       rs->md.bitmap_info.daemon_sleep);
 
-		if (rs->print_flags & DMPF_MIN_RECOVERY_RATE)
+		if (rs->ctr_flags & CTR_FLAG_MIN_RECOVERY_RATE)
 			DMEMIT(" min_recovery_rate %d", rs->md.sync_speed_min);
 
-		if (rs->print_flags & DMPF_MAX_RECOVERY_RATE)
+		if (rs->ctr_flags & CTR_FLAG_MAX_RECOVERY_RATE)
 			DMEMIT(" max_recovery_rate %d", rs->md.sync_speed_max);
 
 		for (i = 0; i < rs->md.raid_disks; i++)
@@ -1489,11 +1503,11 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 			    test_bit(WriteMostly, &rs->dev[i].rdev.flags))
 				DMEMIT(" write_mostly %u", i);
 
-		if (rs->print_flags & DMPF_MAX_WRITE_BEHIND)
+		if (rs->ctr_flags & CTR_FLAG_MAX_WRITE_BEHIND)
 			DMEMIT(" max_write_behind %lu",
 			       rs->md.bitmap_info.max_write_behind);
 
-		if (rs->print_flags & DMPF_STRIPE_CACHE) {
+		if (rs->ctr_flags & CTR_FLAG_STRIPE_CACHE) {
 			struct r5conf *conf = rs->md.private;
 
 			/* convert from kiB to sectors */
@@ -1501,15 +1515,15 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 			       conf ? conf->max_nr_stripes * 2 : 0);
 		}
 
-		if (rs->print_flags & DMPF_REGION_SIZE)
+		if (rs->ctr_flags & CTR_FLAG_REGION_SIZE)
 			DMEMIT(" region_size %lu",
 			       rs->md.bitmap_info.chunksize >> 9);
 
-		if (rs->print_flags & DMPF_RAID10_COPIES)
+		if (rs->ctr_flags & CTR_FLAG_RAID10_COPIES)
 			DMEMIT(" raid10_copies %u",
 			       raid10_md_layout_to_copies(rs->md.layout));
 
-		if (rs->print_flags & DMPF_RAID10_FORMAT)
+		if (rs->ctr_flags & CTR_FLAG_RAID10_FORMAT)
 			DMEMIT(" raid10_format %s",
 			       raid10_md_layout_to_format(rs->md.layout));
 
@@ -1684,26 +1698,30 @@ static void raid_resume(struct dm_target *ti)
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
