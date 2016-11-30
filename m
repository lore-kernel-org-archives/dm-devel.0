From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH v2] dm raid: add raid4/5/6 journaling support
Date: Wed, 30 Nov 2016 22:31:05 +0100
Message-ID: <1480541465-25946-1-git-send-email-heinzm@redhat.com>
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

Add md raid4/5/6 journaling support (upstream commit bac624f3f86a started
the implementation) which closes the write hole (i.e. non-atomic updates
to stripes) using a dedicated journal device.

Background:
raid4/5/6 stripes hold N data payloads per stripe plus one parity raid4/5
or two raid6 P/Q syndrome payloads in an in-memory stripe cache.
Parity or P/Q syndromes used to recover any data payloads in case of a disk
failure are calculated from the N data payloads and need to be updated on the
different component devices of the raid device.  Those are non-atomic,
persistent updates.  Hence a crash can cause failure to update all stripe
payloads persistently and thus cause data loss during stripe recovery.
This problem gets addressed by writing whole stripe cache entries (together with
journal metadata) to a persistent journal entry on a dedicated journal device.
Only if that journal entry is written successfully, the stripe cache entry is
updated on the component devices of the raid device (i.e. writethrough type).
In case of a crash, the entry can be recovered from the journal and be written
again thus ensuring consistent stripe payload suitable to data recovery.

Future dependencies:
once writeback caching being worked on to compensate for the throughput
implictions involved with writethrough overhead is supported with journaling
in upstream, an additional patch based on this one will support it in dm-raid.

Journal resilience related remarks:
because stripes are recovered from the journal in case of a crash, the
journal device better be resilient.  Resilience becomes mandatory with
future writeback support, because loosing the working set in the log
means data loss as oposed to writethrough, were the loss of the
journal device 'only' reintroduces the write hole.

Resolves: rhbz1400194

Fix comment on data offsets in parse_dev_params()
and initialize new_data_offset as well.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 Documentation/device-mapper/dm-raid.txt |  13 +++
 drivers/md/dm-raid.c                    | 152 ++++++++++++++++++++++++++++----
 2 files changed, 147 insertions(+), 18 deletions(-)

diff --git a/Documentation/device-mapper/dm-raid.txt b/Documentation/device-mapper/dm-raid.txt
index 5e3786f..67f69b2 100644
--- a/Documentation/device-mapper/dm-raid.txt
+++ b/Documentation/device-mapper/dm-raid.txt
@@ -161,6 +161,15 @@ The target is named "raid" and it accepts the following parameters:
 		the RAID type (i.e. the allocation algorithm) as well, e.g.
 		changing from raid5_ls to raid5_n.
 
+	[journal_dev <dev>]
+		This option adds a journal device to raid4/5/6 raid sets and
+		uses it to close the 'write hole' caused by the non-atomic updates
+		to the component devices which can cause data loss during recovery.
+		The journal device is used as writethrough thus causing writes to
+		be throttled versus non-journaled raid4/5/6 sets.
+		Takeover/reshape is not possible with a raid4/5/6 journal device;
+		it has to be deconfigured before requesting these.
+
 <#raid_devs>: The number of devices composing the array.
 	Each device consists of two entries.  The first is the device
 	containing the metadata (if any); the second is the one containing the
@@ -245,6 +254,9 @@ recovery.  Here is a fuller description of the individual fields:
 	<data_offset>   The current data offset to the start of the user data on
 			each component device of a raid set (see the respective
 			raid parameter to support out-of-place reshaping).
+	<journal_char>	'J' - active raid4/5/6 journal device.
+			'D' - dead journal device.
+			'-' - no journal device.
 
 
 Message Interface
@@ -314,3 +326,4 @@ Version History
 1.9.0   Add support for RAID level takeover/reshape/region size
 	and set size reduction.
 1.9.1   Fix activation of existing RAID 4/10 mapped devices
+1.10.0  Add support for raid4/5/6 journal device
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 9d5c6bb..215285b 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -24,6 +24,11 @@
  */
 #define	MIN_FREE_RESHAPE_SPACE to_sector(4*4096)
 
+/*
+ * Minimum journal space 4 MiB in sectors.
+ */
+#define	MIN_RAID456_JOURNAL_SPACE (4*2048)
+
 static bool devices_handle_discard_safely = false;
 
 /*
@@ -73,6 +78,9 @@ struct raid_dev {
 #define __CTR_FLAG_DATA_OFFSET		13 /* 2 */ /* Only with reshapable raid4/5/6/10! */
 #define __CTR_FLAG_RAID10_USE_NEAR_SETS 14 /* 2 */ /* Only with raid10! */
 
+/* New for v1.10.0 */
+#define __CTR_FLAG_JOURNAL_DEV		15 /* 2 */ /* Only with raid4/5/6! */
+
 /*
  * Flags for rs->ctr_flags field.
  */
@@ -91,6 +99,7 @@ struct raid_dev {
 #define CTR_FLAG_DELTA_DISKS		(1 << __CTR_FLAG_DELTA_DISKS)
 #define CTR_FLAG_DATA_OFFSET		(1 << __CTR_FLAG_DATA_OFFSET)
 #define CTR_FLAG_RAID10_USE_NEAR_SETS	(1 << __CTR_FLAG_RAID10_USE_NEAR_SETS)
+#define CTR_FLAG_JOURNAL_DEV		(1 << __CTR_FLAG_JOURNAL_DEV)
 
 /*
  * Definitions of various constructor flags to
@@ -163,7 +172,8 @@ struct raid_dev {
 				 CTR_FLAG_STRIPE_CACHE | \
 				 CTR_FLAG_REGION_SIZE | \
 				 CTR_FLAG_DELTA_DISKS | \
-				 CTR_FLAG_DATA_OFFSET)
+				 CTR_FLAG_DATA_OFFSET | \
+				 CTR_FLAG_JOURNAL_DEV)
 
 #define RAID6_VALID_FLAGS	(CTR_FLAG_SYNC | \
 				 CTR_FLAG_REBUILD | \
@@ -173,7 +183,8 @@ struct raid_dev {
 				 CTR_FLAG_STRIPE_CACHE | \
 				 CTR_FLAG_REGION_SIZE | \
 				 CTR_FLAG_DELTA_DISKS | \
-				 CTR_FLAG_DATA_OFFSET)
+				 CTR_FLAG_DATA_OFFSET | \
+				 CTR_FLAG_JOURNAL_DEV)
 /* ...valid options definitions per raid level */
 
 /*
@@ -222,6 +233,12 @@ struct raid_set {
 	struct raid_type *raid_type;
 	struct dm_target_callbacks callbacks;
 
+	/* Optional raid4/5/6 journal device */
+	struct journal_dev {
+		struct dm_dev *dev;
+		struct md_rdev rdev;
+	} journal_dev;
+
 	struct raid_dev dev[0];
 };
 
@@ -306,6 +323,7 @@ static struct arg_name_flag {
 	{ CTR_FLAG_DATA_OFFSET, "data_offset"},
 	{ CTR_FLAG_DELTA_DISKS, "delta_disks"},
 	{ CTR_FLAG_RAID10_USE_NEAR_SETS, "raid10_use_near_sets"},
+	{ CTR_FLAG_JOURNAL_DEV, "journal_dev" },
 };
 
 /* Return argument name string for given @flag */
@@ -627,7 +645,8 @@ static void rs_set_capacity(struct raid_set *rs)
 	 * is unintended in case of out-of-place reshaping
 	 */
 	rdev_for_each(rdev, mddev)
-		rdev->sectors = mddev->dev_sectors;
+		if (!test_bit(Journal, &rdev->flags))
+			rdev->sectors = mddev->dev_sectors;
 
 	set_capacity(gendisk, mddev->array_sectors);
 	revalidate_disk(gendisk);
@@ -713,6 +732,11 @@ static void raid_set_free(struct raid_set *rs)
 {
 	int i;
 
+	if (rs->journal_dev.dev) {
+		md_rdev_clear(&rs->journal_dev.rdev);
+		dm_put_device(rs->ti, rs->journal_dev.dev);
+	}
+
 	for (i = 0; i < rs->raid_disks; i++) {
 		if (rs->dev[i].meta_dev)
 			dm_put_device(rs->ti, rs->dev[i].meta_dev);
@@ -760,10 +784,11 @@ static int parse_dev_params(struct raid_set *rs, struct dm_arg_set *as)
 		rs->dev[i].data_dev = NULL;
 
 		/*
-		 * There are no offsets, since there is a separate device
-		 * for data and metadata.
+		 * There are no offsets initially.
+		 * Out of place reshape will set them accordingly.
 		 */
 		rs->dev[i].rdev.data_offset = 0;
+		rs->dev[i].rdev.new_data_offset = 0;
 		rs->dev[i].rdev.mddev = &rs->md;
 
 		arg = dm_shift_arg(as);
@@ -821,6 +846,9 @@ static int parse_dev_params(struct raid_set *rs, struct dm_arg_set *as)
 			rebuild++;
 	}
 
+	if (rs->journal_dev.dev)
+		list_add_tail(&rs->journal_dev.rdev.same_set, &rs->md.disks);
+
 	if (metadata_available) {
 		rs->md.external = 0;
 		rs->md.persistent = 1;
@@ -1026,6 +1054,8 @@ static int validate_raid_redundancy(struct raid_set *rs)
  *    [max_write_behind <sectors>]	See '-write-behind=' (man mdadm)
  *    [stripe_cache <sectors>]		Stripe cache size for higher RAIDs
  *    [region_size <sectors>]		Defines granularity of bitmap
+ *    [journal_dev <dev>]		raid4/5/6 journaling deviice
+ *    					(i.e. write hole closing log)
  *
  * RAID10-only options:
  *    [raid10_copies <# copies>]	Number of copies.  (Default: 2)
@@ -1133,7 +1163,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 		/*
 		 * Parameters that take a string value are checked here.
 		 */
-
+		/* "raid10_format {near|offset|far} */
 		if (!strcasecmp(key, dm_raid_arg_name_by_flag(CTR_FLAG_RAID10_FORMAT))) {
 			if (test_and_set_bit(__CTR_FLAG_RAID10_FORMAT, &rs->ctr_flags)) {
 				rs->ti->error = "Only one 'raid10_format' argument pair allowed";
@@ -1151,6 +1181,41 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 			continue;
 		}
 
+		/* "journal_dev dev" */
+		if (!strcasecmp(key, dm_raid_arg_name_by_flag(CTR_FLAG_JOURNAL_DEV))) {
+			int r;
+			struct md_rdev *jdev;
+
+			if (test_and_set_bit(__CTR_FLAG_JOURNAL_DEV, &rs->ctr_flags)) {
+				rs->ti->error = "Only one raid4/5/6 set journaling device allowed";
+				return -EINVAL;
+			}
+			if (!rt_is_raid456(rt)) {
+				rs->ti->error = "'journal_dev' is an invalid parameter for this RAID type";
+				return -EINVAL;
+			}
+			r = dm_get_device(rs->ti, arg, dm_table_get_mode(rs->ti->table),
+					  &rs->journal_dev.dev);
+			if (r) {
+				rs->ti->error = "raid4/5/6 journal device lookup failure";
+				return r;
+			}
+			jdev = &rs->journal_dev.rdev;
+			md_rdev_init(jdev);
+			jdev->mddev = &rs->md;
+			jdev->bdev = rs->journal_dev.dev->bdev;
+			jdev->sectors = to_sector(i_size_read(jdev->bdev->bd_inode));
+			if (jdev->sectors < MIN_RAID456_JOURNAL_SPACE) {
+				rs->ti->error = "No space for raid4/5/6 journal";
+				return -ENOSPC;
+			}
+			set_bit(Journal, &jdev->flags);
+			continue;
+		}
+
+		/*
+		 * Parameters with number values from here on.
+		 */
 		if (kstrtoint(arg, 10, &value) < 0) {
 			rs->ti->error = "Bad numerical argument given in raid params";
 			return -EINVAL;
@@ -1468,7 +1533,8 @@ static int rs_set_dev_and_array_sectors(struct raid_set *rs, bool use_mddev)
 		array_sectors = (data_stripes + delta_disks) * dev_sectors;
 
 	rdev_for_each(rdev, mddev)
-		rdev->sectors = dev_sectors;
+		if (!test_bit(Journal, &rdev->flags))
+			rdev->sectors = dev_sectors;
 
 	mddev->array_sectors = array_sectors;
 	mddev->dev_sectors = dev_sectors;
@@ -2146,6 +2212,9 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 	 */
 	d = 0;
 	rdev_for_each(r, mddev) {
+		if (test_bit(Journal, &rdev->flags))
+			continue;
+
 		if (test_bit(FirstUse, &r->flags))
 			new_devs++;
 
@@ -2201,7 +2270,8 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 	 */
 	sb_retrieve_failed_devices(sb, failed_devices);
 	rdev_for_each(r, mddev) {
-		if (!r->sb_page)
+		if (test_bit(Journal, &rdev->flags) ||
+		    !r->sb_page)
 			continue;
 		sb2 = page_address(r->sb_page);
 		sb2->failed_devices = 0;
@@ -2322,6 +2392,9 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 
 	freshest = NULL;
 	rdev_for_each_safe(rdev, tmp, mddev) {
+		if (test_bit(Journal, &rdev->flags))
+			continue;
+
 		/*
 		 * Skipping super_load due to CTR_FLAG_SYNC will cause
 		 * the array to undergo initialization again as
@@ -2401,7 +2474,9 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 		return -EINVAL;
 
 	rdev_for_each(rdev, mddev)
-		if ((rdev != freshest) && super_validate(rs, rdev))
+		if (!test_bit(Journal, &rdev->flags) &&
+		    rdev != freshest &&
+		    super_validate(rs, rdev))
 			return -EINVAL;
 	return 0;
 }
@@ -2488,10 +2563,12 @@ static int rs_adjust_data_offsets(struct raid_set *rs)
 		return -ENOSPC;
 	}
 out:
-	/* Adjust data offsets on all rdevs */
+	/* Adjust data offsets on all rdevs but on any raid4/5/6 journal device */
 	rdev_for_each(rdev, &rs->md) {
-		rdev->data_offset = data_offset;
-		rdev->new_data_offset = new_data_offset;
+		if (!test_bit(Journal, &rdev->flags)) {
+			rdev->data_offset = data_offset;
+			rdev->new_data_offset = new_data_offset;
+		}
 	}
 
 	return 0;
@@ -2504,8 +2581,10 @@ static void __reorder_raid_disk_indexes(struct raid_set *rs)
 	struct md_rdev *rdev;
 
 	rdev_for_each(rdev, &rs->md) {
-		rdev->raid_disk = i++;
-		rdev->saved_raid_disk = rdev->new_raid_disk = -1;
+		if (!test_bit(Journal, &rdev->flags)) {
+			rdev->raid_disk = i++;
+			rdev->saved_raid_disk = rdev->new_raid_disk = -1;
+		}
 	}
 }
 
@@ -2902,6 +2981,13 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 			goto bad;
 		}
 
+		/* We can't takeover a journaled radi4/5/6 */
+		if (test_bit(__CTR_FLAG_JOURNAL_DEV, &rs->ctr_flags)) {
+			ti->error = "Can't takeover a journaled raid4/5/6 set";
+			r = -EPERM;
+			goto bad;
+		}
+
 		/*
 		 * If a takeover is needed, userspace sets any additional
 		 * devices to rebuild and we can check for a valid request here.
@@ -2924,6 +3010,18 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		rs_set_new(rs);
 	} else if (rs_reshape_requested(rs)) {
 		/*
+		 * No need to check for 'ongoing' takeover here, because takeover
+		 * is an instant operation as oposed to an ongoing reshape.
+		 */
+
+		/* We can't reshape a jorunaled radi4/5/6 */
+		if (test_bit(__CTR_FLAG_JOURNAL_DEV, &rs->ctr_flags)) {
+			ti->error = "Can't reshape a journaled raid4/5/6 set";
+			r = -EPERM;
+			goto bad;
+		}
+
+		/*
 		  * We can only prepare for a reshape here, because the
 		  * raid set needs to run to provide the repective reshape
 		  * check functions via its MD personality instance.
@@ -3075,11 +3173,14 @@ static const char *decipher_sync_action(struct mddev *mddev)
  *  'D' = Dead/Failed device
  *  'a' = Alive but not in-sync
  *  'A' = Alive and in-sync
+ *  'J' = Journal device (raid4/5/6)
  */
 static const char *__raid_dev_status(struct md_rdev *rdev, bool array_in_sync)
 {
 	if (test_bit(Faulty, &rdev->flags))
 		return "D";
+	else if (test_bit(Journal, &rdev->flags))
+		return "J";
 	else if (!array_in_sync || !test_bit(In_sync, &rdev->flags))
 		return "a";
 	else
@@ -3148,7 +3249,8 @@ static sector_t rs_get_progress(struct raid_set *rs,
 			 * being initialized.
 			 */
 			rdev_for_each(rdev, mddev)
-				if (!test_bit(In_sync, &rdev->flags))
+				if (!test_bit(Journal, &rdev->flags) &&
+				    !test_bit(In_sync, &rdev->flags))
 					*array_in_sync = true;
 #if 0
 			r = 0; /* HM FIXME: TESTME: https://bugzilla.redhat.com/show_bug.cgi?id=1210637 ? */
@@ -3203,7 +3305,8 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 
 		/* HM FIXME: do we want another state char for raid0? It shows 'D' or 'A' now */
 		rdev_for_each(rdev, mddev)
-			DMEMIT(__raid_dev_status(rdev, array_in_sync));
+			if (!test_bit(Journal, &rdev->flags))
+				DMEMIT(__raid_dev_status(rdev, array_in_sync));
 
 		/*
 		 * In-sync/Reshape ratio:
@@ -3249,6 +3352,12 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 		 * so retrieving it from the first raid disk is sufficient.
 		 */
 		DMEMIT(" %llu", (unsigned long long) rs->dev[0].rdev.data_offset);
+
+		/*
+		 * v1.10.0+:
+		 */
+		DMEMIT(" %s", test_bit(__CTR_FLAG_JOURNAL_DEV, &rs->ctr_flags) ?
+			      __raid_dev_status(&rs->journal_dev.rdev, 0) : "-");
 		break;
 
 	case STATUSTYPE_TABLE:
@@ -3262,7 +3371,8 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 		raid_param_cnt += rebuild_disks * 2 +
 				  write_mostly_params +
 				  hweight32(rs->ctr_flags & CTR_FLAG_OPTIONS_NO_ARGS) +
-				  hweight32(rs->ctr_flags & CTR_FLAG_OPTIONS_ONE_ARG) * 2;
+				  hweight32(rs->ctr_flags & CTR_FLAG_OPTIONS_ONE_ARG) * 2 +
+				  (test_bit(__CTR_FLAG_JOURNAL_DEV, &rs->ctr_flags) ? 2 : 0);
 		/* Emit table line */
 		DMEMIT("%s %u %u", rs->raid_type->name, raid_param_cnt, mddev->new_chunk_sectors);
 		if (test_bit(__CTR_FLAG_RAID10_FORMAT, &rs->ctr_flags))
@@ -3309,6 +3419,9 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 		if (test_bit(__CTR_FLAG_MIN_RECOVERY_RATE, &rs->ctr_flags))
 			DMEMIT(" %s %d", dm_raid_arg_name_by_flag(CTR_FLAG_MIN_RECOVERY_RATE),
 					 mddev->sync_speed_min);
+		if (test_bit(__CTR_FLAG_JOURNAL_DEV, &rs->ctr_flags))
+			DMEMIT(" %s %s", dm_raid_arg_name_by_flag(CTR_FLAG_JOURNAL_DEV),
+					__get_dev_name(rs->journal_dev.dev));
 		DMEMIT(" %d", rs->raid_disks);
 		for (i = 0; i < rs->raid_disks; i++)
 			DMEMIT(" %s %s", __get_dev_name(rs->dev[i].meta_dev),
@@ -3470,6 +3583,9 @@ static void attempt_restore_of_faulty_devices(struct raid_set *rs)
 		uint64_t failed_devices[DISKS_ARRAY_ELEMS];
 
 		rdev_for_each(r, &rs->md) {
+			if (test_bit(Journal, &r->flags))
+				continue;
+
 			sb = page_address(r->sb_page);
 			sb_retrieve_failed_devices(sb, failed_devices);
 
@@ -3654,7 +3770,7 @@ static void raid_resume(struct dm_target *ti)
 
 static struct target_type raid_target = {
 	.name = "raid",
-	.version = {1, 9, 1},
+	.version = {1, 10, 0},
 	.module = THIS_MODULE,
 	.ctr = raid_ctr,
 	.dtr = raid_dtr,
-- 
2.7.4
