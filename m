From: heinzm@redhat.com
Subject: [PATCH 2/2] dm raid: add raid4/5/6 journal mode support
Date: Wed, 22 Mar 2017 17:43:31 +0100
Message-ID: <20170322164331.20924-3-heinzm@redhat.com>
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

Upstream commit 7a771ceac771d009f7203c40b256b0608d7ea2f8
added journal support to close the raid4/5/6 "write hole".

Uitilizing prerequisite
"md: add raid4/5/6 journal mode API (for dm-raid use)",
add support to switch the journal device cache mode between
write-through (the current default) and write-back using
the new r5c_journal_mode_set() API.

Mind in case of journal device failures the former 'only' causes
the "write hole" to reoccur but the latter (i.e. "write-back")
will cause data loss with dirty cache entries thus requiring
resilient storage.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 Documentation/device-mapper/dm-raid.txt |  12 +++-
 drivers/md/dm-raid.c                    | 104 ++++++++++++++++++++++++++++----
 2 files changed, 102 insertions(+), 14 deletions(-)

diff --git a/Documentation/device-mapper/dm-raid.txt b/Documentation/device-mapper/dm-raid.txt
index 95c4c8d..baaf73c 100644
--- a/Documentation/device-mapper/dm-raid.txt
+++ b/Documentation/device-mapper/dm-raid.txt
@@ -170,6 +170,14 @@ The target is named "raid" and it accepts the following parameters:
 		Takeover/reshape is not possible with a raid4/5/6 journal device;
 		it has to be deconfigured before requesting these.
 
+	[journal_mode <mode>]
+		This option sets the caching mode an journaled raid4/5/6 raid sets
+		(see 'journal_dev <dev>' above) to 'writethrough' or 'writeback'.
+		In case 'writeback' is selected the journal device has to be
+		resilient and obviously may not suffer from the 'write hole'
+		problem itself (e.g. use raid1/raid10) to avoid a single
+		point of failure.
+
 <#raid_devs>: The number of devices composing the array.
 	Each device consists of two entries.  The first is the device
 	containing the metadata (if any); the second is the one containing the
@@ -254,7 +262,8 @@ recovery.  Here is a fuller description of the individual fields:
 	<data_offset>   The current data offset to the start of the user data on
 			each component device of a raid set (see the respective
 			raid parameter to support out-of-place reshaping).
-	<journal_char>	'A' - active raid4/5/6 journal device.
+	<journal_char>	'A' - active write-through journal device.
+			'a' - active write-back journal device.
 			'D' - dead journal device.
 			'-' - no journal device.
 
@@ -334,3 +343,4 @@ Version History
 1.10.1  Fix data corruption on reshape request
 1.11.0  Fix table line argument order
 	(wrong raid10_copies/raid10_format sequence)
+1.11.1  Add support for raid4/5/6 journal mode
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index e07185f..0f61bb6 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2010-2011 Neil Brown
- * Copyright (C) 2010-2016 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2010-2017 Red Hat, Inc. All rights reserved.
  *
  * This file is released under the GPL.
  */
@@ -79,7 +79,10 @@ struct raid_dev {
 #define __CTR_FLAG_RAID10_USE_NEAR_SETS 14 /* 2 */ /* Only with raid10! */
 
 /* New for v1.10.0 */
-#define __CTR_FLAG_JOURNAL_DEV		15 /* 2 */ /* Only with raid4/5/6! */
+#define __CTR_FLAG_JOURNAL_DEV		15 /* 2 */ /* Only with raid4/5/6 (journal device)! */
+
+/* New for v1.11.1 */
+#define __CTR_FLAG_JOURNAL_MODE		16 /* 2 */ /* Only with raid4/5/6 (journal mode)! */
 
 /*
  * Flags for rs->ctr_flags field.
@@ -100,6 +103,7 @@ struct raid_dev {
 #define CTR_FLAG_DATA_OFFSET		(1 << __CTR_FLAG_DATA_OFFSET)
 #define CTR_FLAG_RAID10_USE_NEAR_SETS	(1 << __CTR_FLAG_RAID10_USE_NEAR_SETS)
 #define CTR_FLAG_JOURNAL_DEV		(1 << __CTR_FLAG_JOURNAL_DEV)
+#define CTR_FLAG_JOURNAL_MODE		(1 << __CTR_FLAG_JOURNAL_MODE)
 
 #define RESUME_STAY_FROZEN_FLAGS (CTR_FLAG_DELTA_DISKS | CTR_FLAG_DATA_OFFSET)
 
@@ -175,7 +179,8 @@ struct raid_dev {
 				 CTR_FLAG_REGION_SIZE | \
 				 CTR_FLAG_DELTA_DISKS | \
 				 CTR_FLAG_DATA_OFFSET | \
-				 CTR_FLAG_JOURNAL_DEV)
+				 CTR_FLAG_JOURNAL_DEV | \
+				 CTR_FLAG_JOURNAL_MODE)
 
 #define RAID6_VALID_FLAGS	(CTR_FLAG_SYNC | \
 				 CTR_FLAG_REBUILD | \
@@ -186,7 +191,8 @@ struct raid_dev {
 				 CTR_FLAG_REGION_SIZE | \
 				 CTR_FLAG_DELTA_DISKS | \
 				 CTR_FLAG_DATA_OFFSET | \
-				 CTR_FLAG_JOURNAL_DEV)
+				 CTR_FLAG_JOURNAL_DEV | \
+				 CTR_FLAG_JOURNAL_MODE)
 /* ...valid options definitions per raid level */
 
 /*
@@ -239,6 +245,7 @@ struct raid_set {
 	struct journal_dev {
 		struct dm_dev *dev;
 		struct md_rdev rdev;
+		int mode;
 	} journal_dev;
 
 	struct raid_dev dev[0];
@@ -326,6 +333,7 @@ static struct arg_name_flag {
 	{ CTR_FLAG_DELTA_DISKS, "delta_disks"},
 	{ CTR_FLAG_RAID10_USE_NEAR_SETS, "raid10_use_near_sets"},
 	{ CTR_FLAG_JOURNAL_DEV, "journal_dev" },
+	{ CTR_FLAG_JOURNAL_MODE, "journal_mode" },
 };
 
 /* Return argument name string for given @flag */
@@ -344,6 +352,39 @@ static const char *dm_raid_arg_name_by_flag(const uint32_t flag)
 	return NULL;
 }
 
+/* Define correlation of raid456 journal cache modes and dm-raid target line parameters */
+static struct {
+	const int mode;
+	const char *param;
+} _raid456_journal_mode[] = {
+	{ R5C_JOURNAL_MODE_WRITE_THROUGH , "writethrough" },
+	{ R5C_JOURNAL_MODE_WRITE_BACK    , "writeback" }
+};
+
+/* Return MD raid4/5/6 journal mode for dm @journal_mode one */
+static int dm_raid_journal_mode_to_md(const char *mode)
+{
+	int m = ARRAY_SIZE(_raid456_journal_mode);
+
+	while (m--)
+		if (!strcasecmp(mode, _raid456_journal_mode[m].param))
+			return _raid456_journal_mode[m].mode;
+
+	return -EINVAL;
+}
+
+/* Return dm-raid raid4/5/6 journal mode string for @mode */
+static const char *md_journal_mode_to_dm_raid(const int mode)
+{
+	int m = ARRAY_SIZE(_raid456_journal_mode);
+
+	while (m--)
+		if (mode == _raid456_journal_mode[m].mode)
+			return _raid456_journal_mode[m].param;
+
+	return "unknown";
+}
+
 /*
  * Bool helpers to test for various raid levels of a raid set.
  * It's level as reported by the superblock rather than
@@ -1183,7 +1224,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 			continue;
 		}
 
-		/* "journal_dev dev" */
+		/* "journal_dev <dev>" */
 		if (!strcasecmp(key, dm_raid_arg_name_by_flag(CTR_FLAG_JOURNAL_DEV))) {
 			int r;
 			struct md_rdev *jdev;
@@ -1211,10 +1252,32 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 				rs->ti->error = "No space for raid4/5/6 journal";
 				return -ENOSPC;
 			}
+			rs->journal_dev.mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
 			set_bit(Journal, &jdev->flags);
 			continue;
 		}
 
+		/* "journal_mode <mode>" ("journal_dev" mandatory!) */
+		if (!strcasecmp(key, dm_raid_arg_name_by_flag(CTR_FLAG_JOURNAL_MODE))) {
+			int r;
+
+			if (!test_bit(__CTR_FLAG_JOURNAL_DEV, &rs->ctr_flags)) {
+				rs->ti->error = "raid4/5/6 'journal_mode' is invalid without 'journal_dev'";
+				return -EINVAL;
+			}
+			if (test_and_set_bit(__CTR_FLAG_JOURNAL_MODE, &rs->ctr_flags)) {
+				rs->ti->error = "Only one raid4/5/6 'journal_mode' argument allowed";
+				return -EINVAL;
+			}
+			r = dm_raid_journal_mode_to_md(arg);
+			if (r < 0) {
+				rs->ti->error = "Invalid 'journal_mode' argument";
+				return r;
+			}
+			rs->journal_dev.mode = r;
+			continue;
+		}
+
 		/*
 		 * Parameters with number values from here on.
 		 */
@@ -3076,6 +3139,16 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	rs->callbacks.congested_fn = raid_is_congested;
 	dm_table_add_target_callbacks(ti->table, &rs->callbacks);
 
+	/* If raid4/5/6 journal mode explictely requested (only possible with journal dev) -> set it */
+	if (test_bit(__CTR_FLAG_JOURNAL_MODE, &rs->ctr_flags)) {
+		r = r5c_journal_mode_set(&rs->md, rs->journal_dev.mode);
+		if (r) {
+			ti->error = "Failed to set raid4/5/6 journal mode";
+			mddev_unlock(&rs->md);
+			goto bad_journal_mode_set;
+		}
+	}
+
 	mddev_suspend(&rs->md);
 
 	/* Try to adjust the raid4/5/6 stripe cache size to the stripe size */
@@ -3109,6 +3182,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	mddev_unlock(&rs->md);
 	return 0;
 
+bad_journal_mode_set:
 bad_stripe_cache:
 bad_check_reshape:
 	md_stop(&rs->md);
@@ -3180,18 +3254,18 @@ static const char *decipher_sync_action(struct mddev *mddev)
  * Status characters:
  *
  *  'D' = Dead/Failed raid set component or raid4/5/6 journal device
- *  'a' = Alive but not in-sync
- *  'A' = Alive and in-sync raid set component or alive raid4/5/6 journal device
+ *  'a' = Alive but not in-sync raid set component _or_ alive raid4/5/6 'write_back' journal device
+ *  'A' = Alive and in-sync raid set component _or_ alive raid4/5/6 'write_through' journal device
  *  '-' = Non-existing device (i.e. uspace passed '- -' into the ctr)
  */
-static const char *__raid_dev_status(struct md_rdev *rdev, bool array_in_sync)
+static const char *__raid_dev_status(struct raid_set *rs, struct md_rdev *rdev, bool array_in_sync)
 {
 	if (!rdev->bdev)
 		return "-";
 	else if (test_bit(Faulty, &rdev->flags))
 		return "D";
 	else if (test_bit(Journal, &rdev->flags))
-		return "A";
+		return (rs->journal_dev.mode == R5C_JOURNAL_MODE_WRITE_THROUGH) ? "A" : "a";
 	else if (!array_in_sync || !test_bit(In_sync, &rdev->flags))
 		return "a";
 	else
@@ -3315,7 +3389,7 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 
 		/* HM FIXME: do we want another state char for raid0? It shows 'D'/'A'/'-' now */
 		for (i = 0; i < rs->raid_disks; i++)
-			DMEMIT(__raid_dev_status(&rs->dev[i].rdev, array_in_sync));
+			DMEMIT(__raid_dev_status(rs, &rs->dev[i].rdev, array_in_sync));
 
 		/*
 		 * In-sync/Reshape ratio:
@@ -3366,7 +3440,7 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 		 * v1.10.0+:
 		 */
 		DMEMIT(" %s", test_bit(__CTR_FLAG_JOURNAL_DEV, &rs->ctr_flags) ?
-			      __raid_dev_status(&rs->journal_dev.rdev, 0) : "-");
+			      __raid_dev_status(rs, &rs->journal_dev.rdev, 0) : "-");
 		break;
 
 	case STATUSTYPE_TABLE:
@@ -3381,7 +3455,8 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 				  write_mostly_params +
 				  hweight32(rs->ctr_flags & CTR_FLAG_OPTIONS_NO_ARGS) +
 				  hweight32(rs->ctr_flags & CTR_FLAG_OPTIONS_ONE_ARG) * 2 +
-				  (test_bit(__CTR_FLAG_JOURNAL_DEV, &rs->ctr_flags) ? 2 : 0);
+				  (test_bit(__CTR_FLAG_JOURNAL_DEV, &rs->ctr_flags) ? 2 : 0) +
+				  (test_bit(__CTR_FLAG_JOURNAL_MODE, &rs->ctr_flags) ? 2 : 0);
 
 		/* Emit table line */
 		/* This has to be in the documented order for userspace! */
@@ -3433,6 +3508,9 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 		if (test_bit(__CTR_FLAG_JOURNAL_DEV, &rs->ctr_flags))
 			DMEMIT(" %s %s", dm_raid_arg_name_by_flag(CTR_FLAG_JOURNAL_DEV),
 					__get_dev_name(rs->journal_dev.dev));
+		if (test_bit(__CTR_FLAG_JOURNAL_MODE, &rs->ctr_flags))
+			DMEMIT(" %s %s", dm_raid_arg_name_by_flag(CTR_FLAG_JOURNAL_MODE),
+					 md_journal_mode_to_dm_raid(rs->journal_dev.mode));
 		DMEMIT(" %d", rs->raid_disks);
 		for (i = 0; i < rs->raid_disks; i++)
 			DMEMIT(" %s %s", __get_dev_name(rs->dev[i].meta_dev),
@@ -3793,7 +3871,7 @@ static void raid_resume(struct dm_target *ti)
 
 static struct target_type raid_target = {
 	.name = "raid",
-	.version = {1, 11, 0},
+	.version = {1, 11, 1},
 	.module = THIS_MODULE,
 	.ctr = raid_ctr,
 	.dtr = raid_dtr,
-- 
2.9.3
