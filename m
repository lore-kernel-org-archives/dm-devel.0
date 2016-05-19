From: heinzm@redhat.com
Subject: [PATCH 03/11] dm-raid: cleanup / provide infrastructure
Date: Thu, 19 May 2016 18:49:26 +0200
Message-ID: <1463676574-12596-4-git-send-email-heinzm@redhat.com>
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

Provide necessary infrastructure to handle ctr flags and their names
and cleanup setting setting ti->error:

 - comment constructor flags

 - introduce constructor flag manipulation,
 - introduce ti_error_*() functions to simplify
   setting the error message (use in other targets?)

 - introduce array to hold ctr flag <-> flag name mapping

 - introduce argument name by flag functions for that array

 - use those functions throughout the ctr call path

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 422 +++++++++++++++++++++++++++------------------------
 1 file changed, 227 insertions(+), 195 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index cc41f5d..c99ef1b 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -47,18 +47,22 @@ struct raid_dev {
 
 /*
  * Flags for rs->ctr_flags field.
+ *
+ * 1 = no flag value
+ * 2 = flag with value
  */
-#define CTR_FLAG_SYNC              0x1
-#define CTR_FLAG_NOSYNC            0x2
-#define CTR_FLAG_REBUILD           0x4
-#define CTR_FLAG_DAEMON_SLEEP      0x8
-#define CTR_FLAG_MIN_RECOVERY_RATE 0x10
-#define CTR_FLAG_MAX_RECOVERY_RATE 0x20
-#define CTR_FLAG_MAX_WRITE_BEHIND  0x40
-#define CTR_FLAG_STRIPE_CACHE      0x80
-#define CTR_FLAG_REGION_SIZE       0x100
-#define CTR_FLAG_RAID10_COPIES     0x200
-#define CTR_FLAG_RAID10_FORMAT     0x400
+#define CTR_FLAG_SYNC              0x1   /* 1 */ /* Not with raid0! */
+#define CTR_FLAG_NOSYNC            0x2   /* 1 */ /* Not with raid0! */
+#define CTR_FLAG_REBUILD           0x4   /* 2 */ /* Not with raid0! */
+#define CTR_FLAG_DAEMON_SLEEP      0x8   /* 2 */ /* Not with raid0! */
+#define CTR_FLAG_MIN_RECOVERY_RATE 0x10  /* 2 */ /* Not with raid0! */
+#define CTR_FLAG_MAX_RECOVERY_RATE 0x20  /* 2 */ /* Not with raid0! */
+#define CTR_FLAG_MAX_WRITE_BEHIND  0x40  /* 2 */ /* Only with raid1! */
+#define CTR_FLAG_WRITE_MOSTLY      0x80  /* 2 */ /* Only with raid1! */
+#define CTR_FLAG_STRIPE_CACHE      0x100 /* 2 */ /* Only with raid4/5/6! */
+#define CTR_FLAG_REGION_SIZE       0x200 /* 2 */ /* Not with raid0! */
+#define CTR_FLAG_RAID10_COPIES     0x400 /* 2 */ /* Only with raid10 */
+#define CTR_FLAG_RAID10_FORMAT     0x800 /* 2 */ /* Only with raid10 */
 
 struct raid_set {
 	struct dm_target *ti;
@@ -101,6 +105,83 @@ static bool _in_range(long v, long min, long max)
 	return v >= min && v <= max;
 }
 
+/* ctr flag bit manipulation... */
+/* Set single @flag in @flags */
+static void _set_flag(uint32_t flag, uint32_t *flags)
+{
+	WARN_ON_ONCE(hweight32(flag) != 1);
+	*flags |= flag;
+}
+
+/* Test single @flag in @flags */
+static bool _test_flag(uint32_t flag, uint32_t flags)
+{
+	WARN_ON_ONCE(hweight32(flag) != 1);
+	return (flag & flags) ? true : false;
+}
+
+/* Return true if single @flag is set in @*flags, else set it and return false */
+static bool _test_and_set_flag(uint32_t flag, uint32_t *flags)
+{
+	if (_test_flag(flag, *flags))
+		return true;
+
+	_set_flag(flag, flags);
+	return false;
+}
+/* ...ctr and runtime flag bit manipulation */
+
+/* All table line arguments are defined here */
+struct arg_name_flag {
+	const uint32_t flag;
+	const char *name;
+} _arg_name_flags[] = {
+	{ CTR_FLAG_SYNC, "sync"},
+	{ CTR_FLAG_NOSYNC, "nosync"},
+	{ CTR_FLAG_REBUILD, "rebuild"},
+	{ CTR_FLAG_DAEMON_SLEEP, "daemon_sleep"},
+	{ CTR_FLAG_MIN_RECOVERY_RATE, "min_recovery_rate"},
+	{ CTR_FLAG_MAX_RECOVERY_RATE, "max_recovery_rate"},
+	{ CTR_FLAG_MAX_WRITE_BEHIND, "max_write_behind"},
+	{ CTR_FLAG_WRITE_MOSTLY, "writemostly"},
+	{ CTR_FLAG_STRIPE_CACHE, "stripe_cache"},
+	{ CTR_FLAG_REGION_SIZE, "region_size"},
+	{ CTR_FLAG_RAID10_COPIES, "raid10_copies"},
+	{ CTR_FLAG_RAID10_FORMAT, "raid10_format"},
+};
+
+/* Return argument name string for given @flag */
+static const char *_argname_by_flag(const uint32_t flag)
+{
+	if (hweight32(flag) == 1) {
+		struct arg_name_flag *anf = _arg_name_flags + ARRAY_SIZE(_arg_name_flags);
+
+		while (anf-- > _arg_name_flags)
+			if (_test_flag(flag, anf->flag))
+				return anf->name;
+
+	} else
+		DMERR("%s called with more than one flag!", __func__);
+
+	return NULL;
+}
+
+/*
+ * Convenience functions to set ti->error to @errmsg and
+ * return @r in order to shorten code in a lot of places
+ */
+static int ti_error_ret(struct dm_target *ti, const char *errmsg, int r)
+{
+	ti->error = (char *) errmsg;
+	return r;
+}
+
+static int ti_error_einval(struct dm_target *ti, const char *errmsg)
+{
+	return ti_error_ret(ti, errmsg, -EINVAL);
+}
+/* END: convenience functions to set ti->error to @errmsg... */
+
 static char *raid10_md_layout_to_format(int layout)
 {
 	/*
@@ -157,16 +238,12 @@ static struct raid_set *context_alloc(struct dm_target *ti, struct raid_type *ra
 	unsigned i;
 	struct raid_set *rs;
 
-	if (raid_devs <= raid_type->parity_devs) {
-		ti->error = "Insufficient number of devices";
-		return ERR_PTR(-EINVAL);
-	}
+	if (raid_devs <= raid_type->parity_devs)
+		return ERR_PTR(ti_error_einval(ti, "Insufficient number of devices"));
 
 	rs = kzalloc(sizeof(*rs) + raid_devs * sizeof(rs->dev[0]), GFP_KERNEL);
-	if (!rs) {
-		ti->error = "Cannot allocate raid context";
-		return ERR_PTR(-ENOMEM);
-	}
+	if (!rs)
+		return ERR_PTR(ti_error_ret(ti, "Cannot allocate raid context", -ENOMEM));
 
 	mddev_init(&rs->md);
 
@@ -226,7 +303,7 @@ static void context_free(struct raid_set *rs)
  * This code parses those words.  If there is a failure,
  * the caller must use context_free to unwind the operations.
  */
-static int parse_dev_parms(struct raid_set *rs, struct dm_arg_set *as)
+static int parse_dev_params(struct raid_set *rs, struct dm_arg_set *as)
 {
 	int i;
 	int rebuild = 0;
@@ -260,13 +337,12 @@ static int parse_dev_parms(struct raid_set *rs, struct dm_arg_set *as)
 			r = dm_get_device(rs->ti, arg,
 					    dm_table_get_mode(rs->ti->table),
 					    &rs->dev[i].meta_dev);
-			rs->ti->error = "RAID metadata device lookup failure";
 			if (r)
-				return r;
+				return ti_error_ret(rs->ti, "RAID metadata device lookup failure", r);
 
 			rs->dev[i].rdev.sb_page = alloc_page(GFP_KERNEL);
 			if (!rs->dev[i].rdev.sb_page)
-				return -ENOMEM;
+				return ti_error_ret(rs->ti, "Failed to allocate superblock page", -ENOMEM);
 		}
 
 		arg = dm_shift_arg(as);
@@ -275,14 +351,11 @@ static int parse_dev_parms(struct raid_set *rs, struct dm_arg_set *as)
 
 		if (!strcmp(arg, "-")) {
 			if (!test_bit(In_sync, &rs->dev[i].rdev.flags) &&
-			    (!rs->dev[i].rdev.recovery_offset)) {
-				rs->ti->error = "Drive designated for rebuild not specified";
-				return -EINVAL;
-			}
+			    (!rs->dev[i].rdev.recovery_offset))
+				return ti_error_einval(rs->ti, "Drive designated for rebuild not specified");
 
-			rs->ti->error = "No data device supplied with metadata device";
 			if (rs->dev[i].meta_dev)
-				return -EINVAL;
+				return ti_error_einval(rs->ti, "No data device supplied with metadata device");
 
 			continue;
 		}
@@ -290,10 +363,8 @@ static int parse_dev_parms(struct raid_set *rs, struct dm_arg_set *as)
 		r = dm_get_device(rs->ti, arg,
 				    dm_table_get_mode(rs->ti->table),
 				    &rs->dev[i].data_dev);
-		if (r) {
-			rs->ti->error = "RAID device lookup failure";
-			return r;
-		}
+		if (r)
+			return ti_error_ret(rs->ti, "RAID device lookup failure", r);
 
 		if (rs->dev[i].meta_dev) {
 			metadata_available = 1;
@@ -322,8 +393,7 @@ static int parse_dev_parms(struct raid_set *rs, struct dm_arg_set *as)
 		 * User could specify 'nosync' option if desperate.
 		 */
 		DMERR("Unable to rebuild drive while array is not in-sync");
-		rs->ti->error = "RAID device lookup failure";
-		return -EINVAL;
+		return ti_error_einval(rs->ti, "Unable to rebuild drive while array is not in-sync");
 	}
 
 	return 0;
@@ -360,27 +430,20 @@ static int validate_region_size(struct raid_set *rs, unsigned long region_size)
 		/*
 		 * Validate user-supplied value.
 		 */
-		if (region_size > rs->ti->len) {
-			rs->ti->error = "Supplied region size is too large";
-			return -EINVAL;
-		}
+		if (region_size > rs->ti->len)
+			return ti_error_einval(rs->ti, "Supplied region size is too large");
 
 		if (region_size < min_region_size) {
 			DMERR("Supplied region_size (%lu sectors) below minimum (%lu)",
 			      region_size, min_region_size);
-			rs->ti->error = "Supplied region size is too small";
-			return -EINVAL;
+			return ti_error_einval(rs->ti, "Supplied region size is too small");
 		}
 
-		if (!is_power_of_2(region_size)) {
-			rs->ti->error = "Region size is not a power of 2";
-			return -EINVAL;
-		}
+		if (!is_power_of_2(region_size))
+			return ti_error_einval(rs->ti, "Region size is not a power of 2");
 
-		if (region_size < rs->md.chunk_sectors) {
-			rs->ti->error = "Region size is smaller than the chunk size";
-			return -EINVAL;
-		}
+		if (region_size < rs->md.chunk_sectors)
+			return ti_error_einval(rs->ti, "Region size is smaller than the chunk size");
 	}
 
 	/*
@@ -522,14 +585,13 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 	sector_t sectors_per_dev = rs->ti->len;
 	sector_t max_io_len;
 	const char *arg, *key;
+	struct raid_dev *rd;
 
 	arg = dm_shift_arg(as);
 	num_raid_params--; /* Account for chunk_size argument */
 
-	if (kstrtouint(arg, 10, &value) < 0) {
-		rs->ti->error = "Bad numerical argument given for chunk_size";
-		return -EINVAL;
-	}
+	if (kstrtouint(arg, 10, &value) < 0)
+		return ti_error_einval(rs->ti, "Bad numerical argument given for chunk_size");
 
 	/*
 	 * First, parse the in-order required arguments
@@ -539,13 +601,10 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 		if (value)
 			DMERR("Ignoring chunk size parameter for RAID 1");
 		value = 0;
-	} else if (!is_power_of_2(value)) {
-		rs->ti->error = "Chunk size must be a power of 2";
-		return -EINVAL;
-	} else if (value < 8) {
-		rs->ti->error = "Chunk size value is too small";
-		return -EINVAL;
-	}
+	} else if (!is_power_of_2(value))
+		return ti_error_einval(rs->ti, "Chunk size must be a power of 2");
+	else if (value < 8)
+		return ti_error_einval(rs->ti, "Chunk size value is too small");
 
 	rs->md.new_chunk_sectors = rs->md.chunk_sectors = value;
 
@@ -576,144 +635,134 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 	 */
 	for (i = 0; i < num_raid_params; i++) {
 		arg = dm_shift_arg(as);
-		if (!arg) {
-			rs->ti->error = "Not enough raid parameters given";
-			return -EINVAL;
-		}
+		if (!arg)
+			return ti_error_einval(rs->ti, "Not enough raid parameters given");
 
 		if (!strcasecmp(arg, "nosync")) {
 			rs->md.recovery_cp = MaxSector;
-			rs->ctr_flags |= CTR_FLAG_NOSYNC;
+			_set_flag(CTR_FLAG_NOSYNC, &rs->ctr_flags);
 			continue;
 		}
 		if (!strcasecmp(arg, "sync")) {
 			rs->md.recovery_cp = 0;
-			rs->ctr_flags |= CTR_FLAG_SYNC;
+			_set_flag(CTR_FLAG_SYNC, &rs->ctr_flags);
 			continue;
 		}
 
-		/* The rest of the optional arguments come in key/value pairs */
-		if ((i + 1) >= num_raid_params) {
-			rs->ti->error = "Wrong number of raid parameters given";
-			return -EINVAL;
-		}
-
 		key = arg;
 		arg = dm_shift_arg(as);
 		i++; /* Account for the argument pairs */
+		if (!arg)
+			return ti_error_einval(rs->ti, "Wrong number of raid parameters given");
 
-		/* Parameters that take a string value are checked here. */
-		if (!strcasecmp(key, "raid10_format")) {
-			if (rs->raid_type->level != 10) {
-				rs->ti->error = "'raid10_format' is an invalid parameter for this RAID type";
-				return -EINVAL;
-			}
+		/*
+		 * Parameters that take a string value are checked here.
+		 */
+		/* Parameter "raid10_format" which takes a string value is checked here. */
+		if (!strcasecmp(key, _argname_by_flag(CTR_FLAG_RAID10_FORMAT))) {
+			if (_test_and_set_flag(CTR_FLAG_RAID10_FORMAT, &rs->ctr_flags))
+				return ti_error_einval(rs->ti, "Only one raid10_format argument pair allowed");
+			if (rs->raid_type->level != 10)
+				return ti_error_einval(rs->ti, "'raid10_format' is an invalid parameter for this RAID type");
 			if (strcmp("near", arg) &&
 			    strcmp("far", arg) &&
-			    strcmp("offset", arg)) {
-				rs->ti->error = "Invalid 'raid10_format' value given";
-				return -EINVAL;
-			}
+			    strcmp("offset", arg))
+				return ti_error_einval(rs->ti, "Invalid 'raid10_format' value given");
+
 			raid10_format = (char *) arg;
-			rs->ctr_flags |= CTR_FLAG_RAID10_FORMAT;
 			continue;
 		}
 
-		if (kstrtouint(arg, 10, &value) < 0) {
-			rs->ti->error = "Bad numerical argument given in raid params";
-			return -EINVAL;
-		}
+		if (kstrtouint(arg, 10, &value) < 0)
+			return ti_error_einval(rs->ti, "Bad numerical argument given in raid params");
 
-		/* Parameters that take a numeric value are checked here */
-		if (!strcasecmp(key, "rebuild")) {
-			if (value >= rs->md.raid_disks) {
-				rs->ti->error = "Invalid rebuild index given";
-				return -EINVAL;
-			}
-			clear_bit(In_sync, &rs->dev[value].rdev.flags);
-			rs->dev[value].rdev.recovery_offset = 0;
-			rs->ctr_flags |= CTR_FLAG_REBUILD;
-		} else if (!strcasecmp(key, "write_mostly")) {
-			if (rs->raid_type->level != 1) {
-				rs->ti->error = "write_mostly option is only valid for RAID1";
-				return -EINVAL;
-			}
-			if (value >= rs->md.raid_disks) {
-				rs->ti->error = "Invalid write_mostly drive index given";
-				return -EINVAL;
-			}
+		if (!strcasecmp(key, _argname_by_flag(CTR_FLAG_REBUILD))) {
+			/*
+			 * "rebuild" is being passed in by userspace to provide
+			 * indexes of replaced devices and to set up additional
+			 * devices on raid level takeover.
+ 			 */
+			if (!_in_range(value, 0, rs->md.raid_disks - 1))
+				return ti_error_einval(rs->ti, "Invalid rebuild index given");
+
+			rd = rs->dev + value;
+			clear_bit(In_sync, &rd->rdev.flags);
+			clear_bit(Faulty, &rd->rdev.flags);
+			rd->rdev.recovery_offset = 0;
+			_set_flag(CTR_FLAG_REBUILD, &rs->ctr_flags);
+		} else if (!strcasecmp(key, _argname_by_flag(CTR_FLAG_WRITE_MOSTLY))) {
+			if (rs->raid_type->level != 1)
+				return ti_error_einval(rs->ti, "write_mostly option is only valid for RAID1");
+ 
+			if (!_in_range(value, 0, rs->md.raid_disks - 1))
+				return ti_error_einval(rs->ti, "Invalid write_mostly index given");
+ 
 			set_bit(WriteMostly, &rs->dev[value].rdev.flags);
-		} else if (!strcasecmp(key, "max_write_behind")) {
-			if (rs->raid_type->level != 1) {
-				rs->ti->error = "max_write_behind option is only valid for RAID1";
-				return -EINVAL;
-			}
-			rs->ctr_flags |= CTR_FLAG_MAX_WRITE_BEHIND;
+			_set_flag(CTR_FLAG_WRITE_MOSTLY, &rs->ctr_flags);
+		} else if (!strcasecmp(key, _argname_by_flag(CTR_FLAG_MAX_WRITE_BEHIND))) {
+			if (rs->raid_type->level != 1)
+				return ti_error_einval(rs->ti, "max_write_behind option is only valid for RAID1");
+
+			if (_test_and_set_flag(CTR_FLAG_MAX_WRITE_BEHIND, &rs->ctr_flags))
+				return ti_error_einval(rs->ti, "Only one max_write_behind argument pair allowed");
 
 			/*
 			 * In device-mapper, we specify things in sectors, but
 			 * MD records this value in kB
 			 */
 			value /= 2;
-			if (value > COUNTER_MAX) {
-				rs->ti->error = "Max write-behind limit out of range";
-				return -EINVAL;
-			}
+			if (value > COUNTER_MAX)
+				return ti_error_einval(rs->ti, "Max write-behind limit out of range");
+
 			rs->md.bitmap_info.max_write_behind = value;
-		} else if (!strcasecmp(key, "daemon_sleep")) {
-			rs->ctr_flags |= CTR_FLAG_DAEMON_SLEEP;
-			if (!value || (value > MAX_SCHEDULE_TIMEOUT)) {
-				rs->ti->error = "daemon sleep period out of range";
-				return -EINVAL;
-			}
+		} else if (!strcasecmp(key, _argname_by_flag(CTR_FLAG_DAEMON_SLEEP))) {
+			if (_test_and_set_flag(CTR_FLAG_DAEMON_SLEEP, &rs->ctr_flags))
+				return ti_error_einval(rs->ti, "Only one daemon_sleep argument pair allowed");
+			if (!value || (value > MAX_SCHEDULE_TIMEOUT))
+				return ti_error_einval(rs->ti, "daemon sleep period out of range");
 			rs->md.bitmap_info.daemon_sleep = value;
-		} else if (!strcasecmp(key, "stripe_cache")) {
-			rs->ctr_flags |= CTR_FLAG_STRIPE_CACHE;
-
+		} else if (!strcasecmp(key, _argname_by_flag(CTR_FLAG_STRIPE_CACHE))) {
+			if (_test_and_set_flag(CTR_FLAG_STRIPE_CACHE, &rs->ctr_flags))
+				return ti_error_einval(rs->ti, "Only one stripe_cache argument pair allowed");
 			/*
 			 * In device-mapper, we specify things in sectors, but
 			 * MD records this value in kB
 			 */
 			value /= 2;
 
-			if ((rs->raid_type->level != 5) &&
-			    (rs->raid_type->level != 6)) {
-				rs->ti->error = "Inappropriate argument: stripe_cache";
-				return -EINVAL;
-			}
-			if (raid5_set_cache_size(&rs->md, (int)value)) {
-				rs->ti->error = "Bad stripe_cache size";
-				return -EINVAL;
-			}
-		} else if (!strcasecmp(key, "min_recovery_rate")) {
-			rs->ctr_flags |= CTR_FLAG_MIN_RECOVERY_RATE;
-			if (value > INT_MAX) {
-				rs->ti->error = "min_recovery_rate out of range";
-				return -EINVAL;
-			}
+			if (!_in_range(rs->raid_type->level, 4, 6))
+				return ti_error_einval(rs->ti, "Inappropriate argument: stripe_cache");
+			if (raid5_set_cache_size(&rs->md, (int)value))
+				return ti_error_einval(rs->ti, "Bad stripe_cache size");
+
+		} else if (!strcasecmp(key, _argname_by_flag(CTR_FLAG_MIN_RECOVERY_RATE))) {
+			if (_test_and_set_flag(CTR_FLAG_MIN_RECOVERY_RATE, &rs->ctr_flags))
+				return ti_error_einval(rs->ti, "Only one min_recovery_rate argument pair allowed");
+			if (value > INT_MAX)
+				return ti_error_einval(rs->ti, "min_recovery_rate out of range");
 			rs->md.sync_speed_min = (int)value;
-		} else if (!strcasecmp(key, "max_recovery_rate")) {
-			rs->ctr_flags |= CTR_FLAG_MAX_RECOVERY_RATE;
-			if (value > INT_MAX) {
-				rs->ti->error = "max_recovery_rate out of range";
-				return -EINVAL;
-			}
+		} else if (!strcasecmp(key, _argname_by_flag(CTR_FLAG_MAX_RECOVERY_RATE))) {
+			if (_test_and_set_flag(CTR_FLAG_MIN_RECOVERY_RATE, &rs->ctr_flags))
+				return ti_error_einval(rs->ti, "Only one max_recovery_rate argument pair allowed");
+			if (value > INT_MAX)
+				return ti_error_einval(rs->ti, "max_recovery_rate out of range");
 			rs->md.sync_speed_max = (int)value;
-		} else if (!strcasecmp(key, "region_size")) {
-			rs->ctr_flags |= CTR_FLAG_REGION_SIZE;
+		} else if (!strcasecmp(key, _argname_by_flag(CTR_FLAG_REGION_SIZE))) {
+			if (_test_and_set_flag(CTR_FLAG_REGION_SIZE, &rs->ctr_flags))
+				return ti_error_einval(rs->ti, "Only one region_size argument pair allowed");
+ 
 			region_size = value;
-		} else if (!strcasecmp(key, "raid10_copies") &&
-			   (rs->raid_type->level == 10)) {
-			if ((value < 2) || (value > 0xFF)) {
-				rs->ti->error = "Bad value for 'raid10_copies'";
-				return -EINVAL;
-			}
-			rs->ctr_flags |= CTR_FLAG_RAID10_COPIES;
+		} else if (!strcasecmp(key, _argname_by_flag(CTR_FLAG_RAID10_COPIES))) {
+			if (_test_and_set_flag(CTR_FLAG_RAID10_COPIES, &rs->ctr_flags))
+				return ti_error_einval(rs->ti, "Only one raid10_copies argument pair allowed");
+
+			if (!_in_range(value, 2, rs->md.raid_disks))
+				return ti_error_einval(rs->ti, "Bad value for 'raid10_copies'");
+
 			raid10_copies = value;
 		} else {
 			DMERR("Unable to parse RAID parameter: %s", key);
-			rs->ti->error = "Unable to parse RAID parameters";
-			return -EINVAL;
+			return ti_error_einval(rs->ti, "Unable to parse RAID parameters");
 		}
 	}
 
@@ -729,19 +778,15 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 		return -EINVAL;
 
 	if (rs->raid_type->level == 10) {
-		if (raid10_copies > rs->md.raid_disks) {
-			rs->ti->error = "Not enough devices to satisfy specification";
-			return -EINVAL;
-		}
+		if (raid10_copies > rs->md.raid_disks)
+			return ti_error_einval(rs->ti, "Not enough devices to satisfy specification");
 
 		/*
 		 * If the format is not "near", we only support
 		 * two copies at the moment.
 		 */
-		if (strcmp("near", raid10_format) && (raid10_copies > 2)) {
-			rs->ti->error = "Too many copies for given RAID10 format.";
-			return -EINVAL;
-		}
+		if (strcmp("near", raid10_format) && (raid10_copies > 2))
+			return ti_error_einval(rs->ti, "Too many copies for given RAID10 format.");
 
 		/* (Len * #mirrors) / #devices */
 		sectors_per_dev = rs->ti->len * raid10_copies;
@@ -752,10 +797,9 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 		rs->md.new_layout = rs->md.layout;
 	} else if ((!rs->raid_type->level || rs->raid_type->level > 1) &&
 		   sector_div(sectors_per_dev,
-			      (rs->md.raid_disks - rs->raid_type->parity_devs))) {
-		rs->ti->error = "Target length not divisible by number of data devices";
-		return -EINVAL;
-	}
+			      (rs->md.raid_disks - rs->raid_type->parity_devs)))
+		return ti_error_einval(rs->ti, "Target length not divisible by number of data devices");
+
 	rs->md.dev_sectors = sectors_per_dev;
 
 	/* Assume there are no metadata devices until the drives are parsed */
@@ -1035,11 +1079,9 @@ static int super_init_validation(struct mddev *mddev, struct md_rdev *rdev)
 		if (!test_bit(FirstUse, &r->flags) && (r->raid_disk >= 0)) {
 			role = le32_to_cpu(sb2->array_position);
 			if (role != r->raid_disk) {
-				if (rs->raid_type->level != 1) {
-					rs->ti->error = "Cannot change device "
-						"positions in RAID array";
-					return -EINVAL;
-				}
+				if (rs->raid_type->level != 1)
+					return ti_error_einval(rs->ti, "Cannot change device "
+								       "positions in RAID array");
 				DMINFO("RAID1 device #%d now at position #%d",
 				       role, r->raid_disk);
 			}
@@ -1165,18 +1207,15 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 	if (!freshest)
 		return 0;
 
-	if (validate_raid_redundancy(rs)) {
-		rs->ti->error = "Insufficient redundancy to activate array";
-		return -EINVAL;
-	}
+	if (validate_raid_redundancy(rs))
+		return ti_error_einval(rs->ti, "Insufficient redundancy to activate array");
 
 	/*
 	 * Validation of the freshest device provides the source of
 	 * validation for the remaining devices.
 	 */
-	ti->error = "Unable to assemble array: Invalid superblocks";
 	if (super_validate(rs, freshest))
-		return -EINVAL;
+		return ti_error_einval(rs->ti, "Unable to assemble array: Invalid superblocks");
 
 	rdev_for_each(rdev, mddev)
 		if ((rdev != freshest) && super_validate(rs, rdev))
@@ -1260,16 +1299,12 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	/* Must have <raid_type> */
 	arg = dm_shift_arg(&as);
-	if (!arg) {
-		ti->error = "No arguments";
-		return -EINVAL;
-	}
+	if (!arg)
+		return ti_error_einval(rs->ti, "No arguments");
 
 	rt = get_raid_type(arg);
-	if (!rt) {
-		ti->error = "Unrecognised raid_type";
-		return -EINVAL;
-	}
+	if (!rt)
+		return ti_error_einval(rs->ti, "Unrecognised raid_type");
 
 	/* Must have <#raid_params> */
 	if (dm_read_arg_group(_args, &as, &num_raid_params, &ti->error))
@@ -1282,10 +1317,8 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	if (dm_read_arg(_args + 1, &as_nrd, &num_raid_devs, &ti->error))
                 return -EINVAL;
 
-	if (!_in_range(num_raid_devs, 1, MAX_RAID_DEVICES)) {
-		ti->error = "Invalid number of supplied raid devices";
-                return -EINVAL;
-	}
+	if (!_in_range(num_raid_devs, 1, MAX_RAID_DEVICES))
+		return ti_error_einval(rs->ti, "Invalid number of supplied raid devices");
 
 	rs = context_alloc(ti, rt, num_raid_devs);
 	if (IS_ERR(rs))
@@ -1295,7 +1328,7 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	if (r)
 		goto bad;
 
-	r = parse_dev_parms(rs, &as);
+	r = parse_dev_params(rs, &as);
 	if (r)
 		goto bad;
 
@@ -1325,8 +1358,7 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	}
 
 	if (ti->len != rs->md.array_sectors) {
-		ti->error = "Array size does not match requested target length";
-		r = -EINVAL;
+		r = ti_error_einval(ti, "Array size does not match requested target length");
 		goto size_mismatch;
 	}
 	rs->callbacks.congested_fn = raid_is_congested;
@@ -1745,7 +1777,7 @@ static void raid_resume(struct dm_target *ti)
 
 static struct target_type raid_target = {
 	.name = "raid",
-	.version = {1, 7, 0},
+	.version = {1, 7, 1},
 	.module = THIS_MODULE,
 	.ctr = raid_ctr,
 	.dtr = raid_dtr,
-- 
2.5.5
