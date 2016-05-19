From: heinzm@redhat.com
Subject: [PATCH 10/11] dm-raid: add raid level takeover support
Date: Thu, 19 May 2016 18:49:33 +0200
Message-ID: <1463676574-12596-11-git-send-email-heinzm@redhat.com>
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

Add raid level takeover support allowing
arbitrary takeovers between raid levels supported
by md personalities (i.e. raid0, raid1/10 and raid4/5/6):

 - add rs_config_{backup|restore} function to allow for
   temporary storing ctr requested layout changes
   and restore them for takeover conersion decision
   after the superblocks got loaded and analysed

 - add members to store layout to 'struct raid_set'
  (not mandatory there for takeover but needed for reshape in later patch)

 - add rebuild_disks bitfield to 'struct raid_set' and
   set bits in ctr to use in setting up takeover 
   (base to address a 'rebuild' related raid_status()
    table line bug and needed as well for reshape in
    future patch)

 - add runtime flags and respective manipulation functions
   to be able to control e.g. wrting of superlocks
   to the preresume function on takeover and (later) reshape

 - add functions to detect takeover,
   check it's valid (mandatory here to avoid failing on md_run()),
   setup for it and use in the ctr;
   those will be likely moved out once reshaping gets
   added to simplify the ctr

 - start raid set readonly in ctr and switch to
   readwrite optionally updating superblocks in preresume
   in order to allow suspend to quiesce any active table
   before (which involves superblock updates);
   this ensures the proper sequence of writing the
   current and any new takeover(/reshape) metadata

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 448 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 423 insertions(+), 25 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8e419a6..29a3910 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -98,6 +98,13 @@ struct raid_dev {
 #define ALL_CTR_FLAGS		(CTR_FLAG_OPTIONS_NO_ARGS | \
 				 CTR_FLAG_OPTIONS_ONE_ARG)
 
+/*
+ * All flags which cause a recovery unfreeze once they got stored in the raid metadata
+ */
+#define	ALL_FREEZE_FLAGS (ALL_CTR_FLAGS & ~(CTR_FLAG_REGION_SIZE | CTR_FLAGS_ANY_SYNC | \
+					    CTR_FLAG_RAID10_FORMAT | CTR_FLAG_RAID10_COPIES | \
+					    CTR_FLAG_RAID10_USE_NEAR_SETS))
+
 /* Invalid options definitions per raid level... */
 
 /* "raid0" does not accept any options */
@@ -129,14 +136,39 @@ struct raid_dev {
 #define RAID6_INVALID_FLAGS	(CTR_FLAG_NOSYNC | RAID45_INVALID_FLAGS)
 /* ...invalid options definitions per raid level */
 
+/*
+ * Flags for rs->runtime_flags field
+ * (RT_FLAG prefix meaning "runtime flag")
+ *
+ * These are all internal and used to define runtime state,
+ * e.g. to prevent another resume from preresume processing
+ * the raid set all over again.
+ */
+#define RT_FLAG_RS_PRERESUMED		0x1
+#define RT_FLAG_RS_RESUMED		0x2
+#define RT_FLAG_RS_BITMAP_LOADED	0x4
+#define RT_FLAG_UPDATE_SBS		0x8
+
 /* Array elements of 64 bit needed for rebuild/write_mostly bits */
 #define DISKS_ARRAY_ELEMS ((MAX_RAID_DEVICES + (sizeof(uint64_t) * 8 - 1)) / sizeof(uint64_t) / 8)
 
+/*
+ * raid set level, layout and chunk sectors backup/restore
+ */
+struct rs_layout {
+	int new_level;
+	int new_layout;
+	int new_chunk_sectors;
+};
+
 struct raid_set {
 	struct dm_target *ti;
 
 	uint32_t bitmap_loaded;
 	uint32_t ctr_flags;
+	uint32_t runtime_flags;
+
+	uint64_t rebuild_disks[DISKS_ARRAY_ELEMS];
 
 	int raid_disks;
 	int delta_disks;
@@ -146,10 +178,41 @@ struct raid_set {
 	struct mddev md;
 	struct raid_type *raid_type;
 	struct dm_target_callbacks callbacks;
+	struct rs_layout rs_layout;
 
 	struct raid_dev dev[0];
 };
 
+/* Backup/restore raid set configuration helpers */
+static void _rs_config_backup(struct raid_set *rs, struct rs_layout *l)
+{
+	struct mddev *mddev = &rs->md;
+
+	l->new_level = mddev->new_level;
+	l->new_layout = mddev->new_layout;
+	l->new_chunk_sectors = mddev->new_chunk_sectors;
+}
+
+static void rs_config_backup(struct raid_set *rs)
+{
+	return _rs_config_backup(rs, &rs->rs_layout);
+}
+
+static void _rs_config_restore(struct raid_set *rs, struct rs_layout *l)
+{
+	struct mddev *mddev = &rs->md;
+
+	mddev->new_level = l->new_level;
+	mddev->new_layout = l->new_layout;
+	mddev->new_chunk_sectors = l->new_chunk_sectors;
+}
+
+static void rs_config_restore(struct raid_set *rs)
+{
+	return _rs_config_restore(rs, &rs->rs_layout);
+}
+/* END: backup/restore raid set configuration helpers */
+
 /* raid10 algorithms (i.e. formats) */
 #define	ALGORITHM_RAID10_DEFAULT	0
 #define	ALGORITHM_RAID10_NEAR		1
@@ -201,6 +264,13 @@ static void _set_flag(uint32_t flag, uint32_t *flags)
 	*flags |= flag;
 }
 
+/* Clear single @flag in @flags */
+static void _clear_flag(uint32_t flag, uint32_t *flags)
+{
+	WARN_ON_ONCE(hweight32(flag) != 1);
+	*flags &= ~flag;
+}
+
 /* Test single @flag in @flags */
 static bool _test_flag(uint32_t flag, uint32_t flags)
 {
@@ -229,6 +299,17 @@ static bool _test_and_set_flag(uint32_t flag, uint32_t *flags)
 	_set_flag(flag, flags);
 	return false;
 }
+
+/* Return true if single @flag is set in @*flags and clear it, else return false */
+static bool _test_and_clear_flag(uint32_t flag, uint32_t *flags)
+{
+	if (_test_flag(flag, *flags)) {
+		_clear_flag(flag, flags);
+		return true;
+	}
+
+	return false;
+}
 /* ...ctr and runtime flag bit manipulation */
 
 /* All table line arguments are defined here */
@@ -1012,6 +1093,9 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 			if (!_in_range(value, 0, rs->md.raid_disks - 1))
 				return ti_error_einval(rs->ti, "Invalid rebuild index given");
 
+			if (test_and_set_bit(value, (void *) rs->rebuild_disks))
+				return ti_error_einval(rs->ti, "rebuild for this index already given");
+
 			rd = rs->dev + value;
 			clear_bit(In_sync, &rd->rdev.flags);
 			clear_bit(Faulty, &rd->rdev.flags);
@@ -1177,8 +1261,166 @@ static int raid_is_congested(struct dm_target_callbacks *cb, int bits)
 	return mddev_congested(&rs->md, bits);
 }
 
+/*
+ * Make sure a valid takover (level switch) is being requested on @rs
+ *
+ * Conversions of raid sets from one MD personality to another
+ * have to conform to restrictions which are enforced here.
+ *
+ * Degration is already checked for in rs_check_conversion() below.
+ */
+static int rs_check_takeover(struct raid_set *rs)
+{
+	struct mddev *mddev = &rs->md;
+	unsigned int near_copies;
+
+	switch (mddev->level) {
+	case 0:
+		/* raid0 -> raid1/5 with one disk */
+		if ((mddev->new_level == 1 || mddev->new_level == 5) &&
+		    mddev->raid_disks == 1)
+			return 0;
+
+		/* raid0 -> raid10 */
+		if (mddev->new_level == 10 &&
+		    !(rs->raid_disks % 2))
+			return 0;
+
+		/* raid0 with multiple disks -> raid4/5/6 */
+		if (_in_range(mddev->new_level, 4, 6) &&
+		    mddev->new_layout == ALGORITHM_PARITY_N &&
+		    mddev->raid_disks > 1)
+			return 0;
+
+		break;
+
+	case 10:
+		/* Can't takeover raid10_offset! */
+		if (_is_raid10_offset(mddev->layout))
+			break;
+
+		near_copies = _raid10_near_copies(mddev->layout);
+
+		/* raid10* -> raid0 */
+		if (mddev->new_level == 0) {
+			/* Can takeover raid10_near with raid disks divisable by data copies! */
+			if (near_copies > 1 &&
+			    !(mddev->raid_disks % near_copies)) {
+				mddev->raid_disks /= near_copies;
+				mddev->delta_disks = mddev->raid_disks;
+				return 0;
+			}
+
+			/* Can takeover raid10_far */
+			if (near_copies == 1 &&
+			   _raid10_far_copies(mddev->layout) > 1)
+				return 0;
+
+			break;
+		}
+
+		/* raid10_{near,far} -> raid1 */
+		if (mddev->new_level == 1 &&
+		    max(near_copies, _raid10_far_copies(mddev->layout)) == mddev->raid_disks)
+			return 0;
+
+		/* raid10_{near,far} with 2 disks -> raid4/5 */
+		if (_in_range(mddev->new_level, 4, 5) &&
+		    mddev->raid_disks == 2)
+			return 0;
+		break;
+
+	case 1:
+		/* raid1 with 2 disks -> raid4/5 */
+		if (_in_range(mddev->new_level, 4, 5) &&
+		    mddev->raid_disks == 2) {
+			mddev->degraded = 1;
+			return 0;
+		}
+
+		/* raid1 -> raid0 */
+		if (mddev->new_level == 0 &&
+		    mddev->raid_disks == 1)
+			return 0;
+
+		/* raid1 -> raid10 */
+		if (mddev->new_level == 10)
+			return 0;
+
+		break;
+
+	case 4:
+		/* raid4 -> raid0 */
+		if (mddev->new_level == 0)
+			return 0;
+
+		/* raid4 -> raid1/5 with 2 disks */
+		if ((mddev->new_level == 1 || mddev->new_level == 5) &&
+		    mddev->raid_disks == 2)
+			return 0;
+
+		/* raid4 -> raid5/6 with parity N */
+		if (_in_range(mddev->new_level, 5, 6) &&
+		    mddev->layout == ALGORITHM_PARITY_N)
+			return 0;
+		break;
+
+	case 5:
+		/* raid5 with parity N -> raid0 */
+		if (mddev->new_level == 0 &&
+		    mddev->layout == ALGORITHM_PARITY_N)
+			return 0;
+
+		/* raid5 with parity N -> raid4 */
+		if (mddev->new_level == 4 &&
+		    mddev->layout == ALGORITHM_PARITY_N)
+			return 0;
+
+		/* raid5 with 2 disks -> raid1/4/10 */
+		if ((mddev->new_level == 1 || mddev->new_level == 4 || mddev->new_level == 10) &&
+		    mddev->raid_disks == 2)
+			return 0;
+
+		/* raid5 with parity N -> raid6 with parity N */
+		if (mddev->new_level == 6 &&
+		    ((mddev->layout == ALGORITHM_PARITY_N && mddev->new_layout == ALGORITHM_PARITY_N) ||
+		      _in_range(mddev->new_layout, ALGORITHM_LEFT_ASYMMETRIC_6, ALGORITHM_RIGHT_SYMMETRIC_6)))
+			return 0;
+		break;
+
+	case 6:
+		/* raid6 with parity N -> raid0 */
+		if (mddev->new_level == 0 &&
+		    mddev->layout == ALGORITHM_PARITY_N)
+			return 0;
+
+		/* raid6 with parity N -> raid4 */
+		if (mddev->new_level == 4 &&
+		    mddev->layout == ALGORITHM_PARITY_N)
+			return 0;
+
+		/* raid6_*_n with parity N -> raid5_* */
+		if (mddev->new_level == 5 &&
+		    ((mddev->layout == ALGORITHM_PARITY_N && mddev->new_layout == ALGORITHM_PARITY_N) ||
+		     _in_range(mddev->new_layout, ALGORITHM_LEFT_ASYMMETRIC, ALGORITHM_RIGHT_SYMMETRIC)))
+			return 0;
+
+	default:
+		break;
+	}
+
+	return ti_error_einval(rs->ti, "takeover not possible");
+}
+
+/* True if @rs requested to be taken over */
+static bool rs_takeover_requested(struct raid_set *rs)
+{
+	return rs->md.new_level != rs->md.level;
+}
+
 /*  Features */
-#define	FEATURE_FLAG_SUPPORTS_RESHAPE	0x1
+#define	FEATURE_FLAG_SUPPORTS_V180	0x1 /* Supports v1.8.0 extended superblock */
+#define	FEATURE_FLAG_SUPPORTS_RESHAPE	0x2 /* Supports v1.8.0 reshaping functionality */
 
 /* State flags for sb->flags */
 #define	SB_FLAG_RESHAPE_ACTIVE		0x1
@@ -1222,7 +1464,7 @@ struct dm_raid_superblock {
 	/********************************************************************
 	 * BELOW FOLLOW V1.8.0 EXTENSIONS TO THE PRISTINE SUPERBLOCK FORMAT!!!
 	 *
-	 * FEATURE_FLAG_SUPPORTS_RESHAPE in the features member indicates that those exist
+	 * FEATURE_FLAG_SUPPORTS_V180 in the features member indicates that those exist
 	 */
 
 	__le32 flags; /* Flags defining array states for reshaping */
@@ -1290,7 +1532,7 @@ static void sb_retrieve_failed_devices(struct dm_raid_superblock *sb, uint64_t *
 	failed_devices[0] = le64_to_cpu(sb->failed_devices);
 	memset(failed_devices + 1, 0, sizeof(sb->extended_failed_devices));
 
-	if (_test_flag(FEATURE_FLAG_SUPPORTS_RESHAPE, le32_to_cpu(sb->compat_features))) {
+	if (_test_flag(FEATURE_FLAG_SUPPORTS_V180, le32_to_cpu(sb->compat_features))) {
 		int i = ARRAY_SIZE(sb->extended_failed_devices);
 
 		while (i--)
@@ -1341,7 +1583,7 @@ static void super_sync(struct mddev *mddev, struct md_rdev *rdev)
 		sb_update_failed_devices(sb, failed_devices);
 
 	sb->magic = cpu_to_le32(DM_RAID_MAGIC);
-	sb->compat_features = cpu_to_le32(0); /* Don't set reshape flag yet */
+	sb->compat_features = cpu_to_le32(FEATURE_FLAG_SUPPORTS_V180); /* Don't set reshape flag yet */
 
 	sb->num_devices = cpu_to_le32(mddev->raid_disks);
 	sb->array_position = cpu_to_le32(rdev->raid_disk);
@@ -1420,6 +1662,7 @@ static int super_load(struct md_rdev *rdev, struct md_rdev *refdev)
 		super_sync(rdev->mddev, rdev);
 
 		set_bit(FirstUse, &rdev->flags);
+		sb->compat_features = cpu_to_le32(FEATURE_FLAG_SUPPORTS_V180); /* Don't set reshape flag yet */
 
 		/* Force writing of superblocks to disk */
 		set_bit(MD_CHANGE_DEVS, &rdev->mddev->flags);
@@ -1465,7 +1708,7 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 	 * Reshaping is supported, e.g. reshape_position is valid
 	 * in superblock and superblock content is authoritative.
 	 */
-	if (_test_flag(FEATURE_FLAG_SUPPORTS_RESHAPE, le32_to_cpu(sb->compat_features))) {
+	if (_test_flag(FEATURE_FLAG_SUPPORTS_V180, le32_to_cpu(sb->compat_features))) {
 		/* Superblock is authoritative wrt given raid set layout! */
 		mddev->raid_disks = le32_to_cpu(sb->num_devices);
 		mddev->level = le32_to_cpu(sb->level);
@@ -1568,6 +1811,7 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 		if (new_devs == rs->raid_disks) {
 			DMINFO("Superblocks created for new raid set");
 			set_bit(MD_ARRAY_FIRST_USE, &mddev->flags);
+			_set_flag(RT_FLAG_UPDATE_SBS, &rs->runtime_flags);
 			mddev->recovery_cp = 0;
 		} else if (new_devs && new_devs != rs->raid_disks && !rebuilds) {
 			DMERR("New device injected into existing raid set without "
@@ -1661,8 +1905,9 @@ static int super_validate(struct raid_set *rs, struct md_rdev *rdev)
 	if (!mddev->events && super_init_validation(rs, rdev))
 		return -EINVAL;
 
-	if (sb->compat_features || sb->incompat_features) /* No features supported yet */
-		return ti_error_einval(rs->ti, "Unable to assemble array: No feature flags supported yet");
+	if (le32_to_cpu(sb->compat_features) != FEATURE_FLAG_SUPPORTS_V180 ||
+	    sb->incompat_features) /* No incompatible features supported yet */
+		return ti_error_einval(rs->ti, "Unable to assemble array: No incompatible feature flags supported yet");
 
 	/* Enable bitmap creation for RAID levels != 0 */
 	mddev->bitmap_info.offset = rt_is_raid0(rs->raid_type) ? 0 : to_sector(4096);
@@ -1788,14 +2033,76 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 	return 0;
 }
 
+/* Userpace reordered disks -> adjust raid_disk indexes in @rs */
+static void _reorder_raid_disk_indexes(struct raid_set *rs)
+{
+	int i = 0;
+	struct md_rdev *rdev;
+
+	rdev_for_each(rdev, &rs->md) {
+		rdev->raid_disk = i++;
+		rdev->saved_raid_disk = rdev->new_raid_disk = -1;
+	}
+}
+
+/*
+ * Setup @rs for takeover by a different raid level
+ */
+static int rs_setup_takeover(struct raid_set *rs)
+{
+	struct mddev *mddev = &rs->md;
+	struct md_rdev *rdev;
+	unsigned int d = mddev->raid_disks = rs->raid_disks;
+	sector_t new_data_offset = rs->dev[0].rdev.data_offset ? 0 : rs->data_offset;
+
+	if (rt_is_raid10(rs->raid_type)) {
+		if (mddev->level == 0) {
+			/* Userpace reordered disks -> adjust raid_disk indexes */
+			_reorder_raid_disk_indexes(rs);
+
+			/* raid0 -> raid10_far layout */
+			mddev->layout = raid10_format_to_md_layout(rs, ALGORITHM_RAID10_FAR,
+								   rs->raid10_copies);
+		} else if (mddev->level == 1)
+			/* raid1 -> raid10_near layout */
+			mddev->layout = raid10_format_to_md_layout(rs, ALGORITHM_RAID10_NEAR,
+								   rs->raid_disks);
+		 else
+			return -EINVAL;
+
+	}
+
+	/* Bitmap has to be created when we takeover from raid0 */
+	if (rs_is_raid0(rs))
+		set_bit(MD_ARRAY_FIRST_USE, &mddev->flags);
+
+	while (d--) {
+		rdev = &rs->dev[d].rdev;
+
+		if (test_bit(d, (void *) rs->rebuild_disks)) {
+			clear_bit(In_sync, &rdev->flags);
+			clear_bit(Faulty, &rdev->flags);
+			rdev->recovery_offset = 0;
+		}
+
+		rdev->new_data_offset = new_data_offset;
+	}
+
+	rs_set_new(rs);
+	set_bit(MD_CHANGE_DEVS, &mddev->flags);
+
+	return 0;
+}
+
 /*
  * Enable/disable discard support on RAID set depending on
  * RAID level and discard properties of underlying RAID members.
  */
-static void configure_discard_support(struct dm_target *ti, struct raid_set *rs)
+static void configure_discard_support(struct raid_set *rs)
 {
 	int i;
 	bool raid456;
+	struct dm_target *ti = rs->ti;
 
 	/* Assume discards not supported until after checks below. */
 	ti->discards_supported = false;
@@ -1897,6 +2204,14 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto bad;
 
 	rs->md.sync_super = super_sync;
+
+	/*
+	 * Backup any new raid set level, layout, ...
+	 * requested to be able to compare to superblock
+	 * members for conversion decisions.
+	 */
+	rs_config_backup(rs);
+
 	r = analyse_superblocks(ti, rs);
 	if (r)
 		goto bad;
@@ -1905,10 +2220,29 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	ti->private = rs;
 	ti->num_flush_bios = 1;
 
+	/* Restore any requested new layout for conversion decision */
+	rs_config_restore(rs);
+
 	/*
-	 * Disable/enable discard support on RAID set.
+	 * If a takeover is needed, just set the level to
+	 * the new requested one and allow the raid set to run.
 	 */
-	configure_discard_support(ti, rs);
+	if (rs_takeover_requested(rs)) {
+		r = rs_check_takeover(rs);
+		if (r)
+			return r;
+
+		r = rs_setup_takeover(rs);
+		if (r)
+			return r;
+
+		_set_flag(RT_FLAG_UPDATE_SBS, &rs->runtime_flags);
+	}
+
+	/* Start raid set read-only and assumed clean to change in raid_resume() */
+	rs->md.ro = 1;
+	rs->md.in_sync = 1;
+	set_bit(MD_RECOVERY_FROZEN, &rs->md.recovery);
 
 	/* Has to be held on running the array */
 	mddev_lock_nointr(&rs->md);
@@ -2314,29 +2648,92 @@ static void attempt_restore_of_faulty_devices(struct raid_set *rs)
 	}
 }
 
+/* Load the dirty region bitmap */
+static int _bitmap_load(struct raid_set *rs)
+{
+	int r = 0;
+
+	/* Try loading the bitmap unless "raid0", which does not have one */
+	if (!rs_is_raid0(rs) &&
+	    !_test_and_set_flag(RT_FLAG_RS_BITMAP_LOADED, &rs->runtime_flags)) {
+		r = bitmap_load(&rs->md);
+		if (r)
+			DMERR("Failed to load bitmap");
+	}
+
+	return r;
+}
+
+static int raid_preresume(struct dm_target *ti)
+{
+	struct raid_set *rs = ti->private;
+	struct mddev *mddev = &rs->md;
+
+	/* This is a resume after a suspend of the set -> it's already started */
+	if (_test_and_set_flag(RT_FLAG_RS_PRERESUMED, &rs->runtime_flags))
+		return 0;
+
+	/*
+	 * The superblocks need to be updated on disk if the
+	 * array is new or _bitmap_load will overwrite them
+	 * in core with old data.
+	 *
+	 * In case the array got modified (takeover/reshape/resize)
+	 * or the data offsets on the component devices changed, they
+	 * have to be updated as well.
+	 *
+	 * Have to switch to readwrite and back in order to
+	 * allow for the superblock updates.
+	 */
+	if (_test_and_clear_flag(RT_FLAG_UPDATE_SBS, &rs->runtime_flags)) {
+		set_bit(MD_CHANGE_DEVS, &mddev->flags);
+		mddev->ro = 0;
+		md_update_sb(mddev, 1);
+		mddev->ro = 1;
+	}
+
+	/*
+	 * Disable/enable discard support on raid set after any
+	 * conversion, because devices can have been added
+	 */
+	configure_discard_support(rs);
+
+	/* Load the bitmap from disk unless raid0 */
+	return _bitmap_load(rs);
+}
+
 static void raid_resume(struct dm_target *ti)
 {
 	struct raid_set *rs = ti->private;
+	struct mddev *mddev = &rs->md;
 
-	if (!rt_is_raid0(rs->raid_type)) {
-		set_bit(MD_CHANGE_DEVS, &rs->md.flags);
+	if (_test_and_set_flag(RT_FLAG_RS_RESUMED, &rs->runtime_flags)) {
+		/*
+		 * A secondary resume while the device is active.
+		 * Take this opportunity to check whether any failed
+		 * devices are reachable again.
+		 */
+		attempt_restore_of_faulty_devices(rs);
 
-		if (!rs->bitmap_loaded) {
-			bitmap_load(&rs->md);
-			rs->bitmap_loaded = 1;
-		} else {
-			/*
-			 * A secondary resume while the device is active.
-			 * Take this opportunity to check whether any failed
-			 * devices are reachable again.
-			 */
-			attempt_restore_of_faulty_devices(rs);
-		}
+	} else {
+		mddev->in_sync = 0;
 
-		clear_bit(MD_RECOVERY_FROZEN, &rs->md.recovery);
+		/*
+		 * If any of the constructor flags got passed in
+		 * but "region_size" (gets always passed in for
+		 * mappings with bitmap), we expect userspace to
+		 * reset them and reload the mapping anyway.
+		 *
+		 * -> don't unfreeze resynchronization until imminant
+		 *    reload of the table w/o theses flags
+		 */
+		if (!_test_flags(ALL_FREEZE_FLAGS, rs->ctr_flags))
+			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	}
 
-	mddev_resume(&rs->md);
+	mddev->ro = 0;
+	if (mddev->suspended)
+		mddev_resume(mddev);
 }
 
 static struct target_type raid_target = {
@@ -2352,6 +2749,7 @@ static struct target_type raid_target = {
 	.io_hints = raid_io_hints,
 	.presuspend = raid_presuspend,
 	.postsuspend = raid_postsuspend,
+	.preresume = raid_preresume,
 	.resume = raid_resume,
 };
 
-- 
2.5.5
