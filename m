From: heinzm@redhat.com
Subject: [PATCH 1/2] dm raid: fix table line argument order in
	status
Date: Sat, 18 Mar 2017 01:39:00 +0100
Message-ID: <20170318003900.4043-1-heinzm@redhat.com>
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
Cc: heinzm@redhat.com
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Upstream commit 3a1c1ef2fd62087c3d6521de217ddb9360776658
added new table line arguments and introduced an ordering
flaw.  The sequence of the raid10_copies and raid10_format
raid parameters got reversed which causes lvm2 userspace
to fail falsely assuming a changed table line.

Sequence those 2 parameters as before so that old lvm2
uspace can function properly with new kernels and adjust
the table line output to the defined one as of
Documentation/device-mapper/dm-raid.txt.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 Documentation/device-mapper/dm-raid.txt |  2 ++
 drivers/md/dm-raid.c                    | 62 +++++++++++++++++----------------
 2 files changed, 34 insertions(+), 30 deletions(-)

diff --git a/Documentation/device-mapper/dm-raid.txt b/Documentation/device-mapper/dm-raid.txt
index cd2cb2f..9ec88eb 100644
--- a/Documentation/device-mapper/dm-raid.txt
+++ b/Documentation/device-mapper/dm-raid.txt
@@ -331,3 +331,5 @@ Version History
 	'D' on the status line.  If '- -' is passed into the constructor, emit
 	'- -' on the table line and '-' as the status line health character.
 1.10.0  Add support for raid4/5/6 journal device
+1.11.0  Fix table line argument order
+	(wrong raid10_copies/raid10_format sequence)
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index f8564d6..e07185f 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3382,38 +3382,28 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 				  hweight32(rs->ctr_flags & CTR_FLAG_OPTIONS_NO_ARGS) +
 				  hweight32(rs->ctr_flags & CTR_FLAG_OPTIONS_ONE_ARG) * 2 +
 				  (test_bit(__CTR_FLAG_JOURNAL_DEV, &rs->ctr_flags) ? 2 : 0);
+
 		/* Emit table line */
+		/* This has to be in the documented order for userspace! */
 		DMEMIT("%s %u %u", rs->raid_type->name, raid_param_cnt, mddev->new_chunk_sectors);
-		if (test_bit(__CTR_FLAG_RAID10_FORMAT, &rs->ctr_flags))
-			DMEMIT(" %s %s", dm_raid_arg_name_by_flag(CTR_FLAG_RAID10_FORMAT),
-					 raid10_md_layout_to_format(mddev->layout));
-		if (test_bit(__CTR_FLAG_RAID10_COPIES, &rs->ctr_flags))
-			DMEMIT(" %s %d", dm_raid_arg_name_by_flag(CTR_FLAG_RAID10_COPIES),
-					 raid10_md_layout_to_copies(mddev->layout));
-		if (test_bit(__CTR_FLAG_NOSYNC, &rs->ctr_flags))
-			DMEMIT(" %s", dm_raid_arg_name_by_flag(CTR_FLAG_NOSYNC));
 		if (test_bit(__CTR_FLAG_SYNC, &rs->ctr_flags))
 			DMEMIT(" %s", dm_raid_arg_name_by_flag(CTR_FLAG_SYNC));
-		if (test_bit(__CTR_FLAG_REGION_SIZE, &rs->ctr_flags))
-			DMEMIT(" %s %llu", dm_raid_arg_name_by_flag(CTR_FLAG_REGION_SIZE),
-					   (unsigned long long) to_sector(mddev->bitmap_info.chunksize));
-		if (test_bit(__CTR_FLAG_DATA_OFFSET, &rs->ctr_flags))
-			DMEMIT(" %s %llu", dm_raid_arg_name_by_flag(CTR_FLAG_DATA_OFFSET),
-					   (unsigned long long) rs->data_offset);
-		if (test_bit(__CTR_FLAG_DAEMON_SLEEP, &rs->ctr_flags))
-			DMEMIT(" %s %lu", dm_raid_arg_name_by_flag(CTR_FLAG_DAEMON_SLEEP),
-					  mddev->bitmap_info.daemon_sleep);
-		if (test_bit(__CTR_FLAG_DELTA_DISKS, &rs->ctr_flags))
-			DMEMIT(" %s %d", dm_raid_arg_name_by_flag(CTR_FLAG_DELTA_DISKS),
-					 max(rs->delta_disks, mddev->delta_disks));
-		if (test_bit(__CTR_FLAG_STRIPE_CACHE, &rs->ctr_flags))
-			DMEMIT(" %s %d", dm_raid_arg_name_by_flag(CTR_FLAG_STRIPE_CACHE),
-					 max_nr_stripes);
+		if (test_bit(__CTR_FLAG_NOSYNC, &rs->ctr_flags))
+			DMEMIT(" %s", dm_raid_arg_name_by_flag(CTR_FLAG_NOSYNC));
 		if (rebuild_disks)
 			for (i = 0; i < rs->raid_disks; i++)
 				if (test_bit(rs->dev[i].rdev.raid_disk, (void *) rs->rebuild_disks))
 					DMEMIT(" %s %u", dm_raid_arg_name_by_flag(CTR_FLAG_REBUILD),
 							 rs->dev[i].rdev.raid_disk);
+		if (test_bit(__CTR_FLAG_DAEMON_SLEEP, &rs->ctr_flags))
+			DMEMIT(" %s %lu", dm_raid_arg_name_by_flag(CTR_FLAG_DAEMON_SLEEP),
+					  mddev->bitmap_info.daemon_sleep);
+		if (test_bit(__CTR_FLAG_MIN_RECOVERY_RATE, &rs->ctr_flags))
+			DMEMIT(" %s %d", dm_raid_arg_name_by_flag(CTR_FLAG_MIN_RECOVERY_RATE),
+					 mddev->sync_speed_min);
+		if (test_bit(__CTR_FLAG_MAX_RECOVERY_RATE, &rs->ctr_flags))
+			DMEMIT(" %s %d", dm_raid_arg_name_by_flag(CTR_FLAG_MAX_RECOVERY_RATE),
+					 mddev->sync_speed_max);
 		if (write_mostly_params)
 			for (i = 0; i < rs->raid_disks; i++)
 				if (test_bit(WriteMostly, &rs->dev[i].rdev.flags))
@@ -3422,12 +3412,24 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 		if (test_bit(__CTR_FLAG_MAX_WRITE_BEHIND, &rs->ctr_flags))
 			DMEMIT(" %s %lu", dm_raid_arg_name_by_flag(CTR_FLAG_MAX_WRITE_BEHIND),
 					  mddev->bitmap_info.max_write_behind);
-		if (test_bit(__CTR_FLAG_MAX_RECOVERY_RATE, &rs->ctr_flags))
-			DMEMIT(" %s %d", dm_raid_arg_name_by_flag(CTR_FLAG_MAX_RECOVERY_RATE),
-					 mddev->sync_speed_max);
-		if (test_bit(__CTR_FLAG_MIN_RECOVERY_RATE, &rs->ctr_flags))
-			DMEMIT(" %s %d", dm_raid_arg_name_by_flag(CTR_FLAG_MIN_RECOVERY_RATE),
-					 mddev->sync_speed_min);
+		if (test_bit(__CTR_FLAG_STRIPE_CACHE, &rs->ctr_flags))
+			DMEMIT(" %s %d", dm_raid_arg_name_by_flag(CTR_FLAG_STRIPE_CACHE),
+					 max_nr_stripes);
+		if (test_bit(__CTR_FLAG_REGION_SIZE, &rs->ctr_flags))
+			DMEMIT(" %s %llu", dm_raid_arg_name_by_flag(CTR_FLAG_REGION_SIZE),
+					   (unsigned long long) to_sector(mddev->bitmap_info.chunksize));
+		if (test_bit(__CTR_FLAG_RAID10_COPIES, &rs->ctr_flags))
+			DMEMIT(" %s %d", dm_raid_arg_name_by_flag(CTR_FLAG_RAID10_COPIES),
+					 raid10_md_layout_to_copies(mddev->layout));
+		if (test_bit(__CTR_FLAG_RAID10_FORMAT, &rs->ctr_flags))
+			DMEMIT(" %s %s", dm_raid_arg_name_by_flag(CTR_FLAG_RAID10_FORMAT),
+					 raid10_md_layout_to_format(mddev->layout));
+		if (test_bit(__CTR_FLAG_DELTA_DISKS, &rs->ctr_flags))
+			DMEMIT(" %s %d", dm_raid_arg_name_by_flag(CTR_FLAG_DELTA_DISKS),
+					 max(rs->delta_disks, mddev->delta_disks));
+		if (test_bit(__CTR_FLAG_DATA_OFFSET, &rs->ctr_flags))
+			DMEMIT(" %s %llu", dm_raid_arg_name_by_flag(CTR_FLAG_DATA_OFFSET),
+					   (unsigned long long) rs->data_offset);
 		if (test_bit(__CTR_FLAG_JOURNAL_DEV, &rs->ctr_flags))
 			DMEMIT(" %s %s", dm_raid_arg_name_by_flag(CTR_FLAG_JOURNAL_DEV),
 					__get_dev_name(rs->journal_dev.dev));
@@ -3791,7 +3793,7 @@ static void raid_resume(struct dm_target *ti)
 
 static struct target_type raid_target = {
 	.name = "raid",
-	.version = {1, 10, 1},
+	.version = {1, 11, 0},
 	.module = THIS_MODULE,
 	.ctr = raid_ctr,
 	.dtr = raid_dtr,
-- 
2.9.3
