From: heinzm@redhat.com
Subject: [PATCH 07/11] dm-raid: introduce v1.8.0 extended
	superblock and new raid types to support takeover/reshaping
Date: Thu, 19 May 2016 18:49:30 +0200
Message-ID: <1463676574-12596-8-git-send-email-heinzm@redhat.com>
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

Add new members to the dm-raid superblock and new raid types to support takeover/reshape.

Add all necessary members supporting takeover and reshape in
one go aiming to limit the amnout of changes to the superblock
layout to planned one.


This is a larger patch due to the new superblock members,
their related flags, validation of both and involved
API additions/changes:

 - add additional members to keep track of: 
   - state about forward/backward reshaping
   - reshape position
   - new level, layout, stripe size and delta disks
   - data offset to current and new data for out-of-place reshapes
   - failed devices bitfield extensions to keep track of max raid devices

 - adjust super_validate() to cope with new superblock members

 - adjust super_init_validation() to cope with new superblock members

 - add definitions for ctr flags supporting delta disks etc.

 - add new raid types (raid6_n_6 etc.)

 - add new raid10 supporting function API (_is_raid10_*())

 - adjust to changed raid10 supporting function API

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 607 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 475 insertions(+), 132 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 50bdd7e..3b2bdac 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -63,6 +63,10 @@ struct raid_dev {
 #define CTR_FLAG_REGION_SIZE       0x200 /* 2 */ /* Not with raid0! */
 #define CTR_FLAG_RAID10_COPIES     0x400 /* 2 */ /* Only with raid10 */
 #define CTR_FLAG_RAID10_FORMAT     0x800 /* 2 */ /* Only with raid10 */
+/* New for v1.8.0 */
+#define CTR_FLAG_DELTA_DISKS          0x1000 /* 2 */ /* Only with reshapable raid4/5/6/10! */
+#define CTR_FLAG_DATA_OFFSET          0x2000 /* 2 */ /* Only with reshapable raid4/5/6/10! */
+#define CTR_FLAG_RAID10_USE_NEAR_SETS 0x4000 /* 2 */ /* Only with raid10! */
 
 /*
  * Definitions of various constructor flags to
@@ -73,7 +77,8 @@ struct raid_dev {
 #define	CTR_FLAGS_ANY_SYNC		(CTR_FLAG_SYNC | CTR_FLAG_NOSYNC)
 
 /* Define flags for options without argument (e.g. 'nosync') */
-#define	CTR_FLAG_OPTIONS_NO_ARGS	CTR_FLAGS_ANY_SYNC
+#define	CTR_FLAG_OPTIONS_NO_ARGS	(CTR_FLAGS_ANY_SYNC | \
+					 CTR_FLAG_RAID10_USE_NEAR_SETS)
 
 /* Define flags for options with one argument (e.g. 'delta_disks +2') */
 #define CTR_FLAG_OPTIONS_ONE_ARG (CTR_FLAG_REBUILD | \
@@ -85,7 +90,9 @@ struct raid_dev {
 				  CTR_FLAG_STRIPE_CACHE | \
 				  CTR_FLAG_REGION_SIZE | \
 				  CTR_FLAG_RAID10_COPIES | \
-				  CTR_FLAG_RAID10_FORMAT)
+				  CTR_FLAG_RAID10_FORMAT | \
+				  CTR_FLAG_DELTA_DISKS | \
+				  CTR_FLAG_DATA_OFFSET)
 
 /* All ctr optional arguments */
 #define ALL_CTR_FLAGS		(CTR_FLAG_OPTIONS_NO_ARGS | \
@@ -99,7 +106,9 @@ struct raid_dev {
 /* "raid1" does not accept stripe cache or any raid10 options */
 #define RAID1_INVALID_FLAGS	(CTR_FLAG_STRIPE_CACHE | \
 				 CTR_FLAG_RAID10_COPIES | \
-				 CTR_FLAG_RAID10_FORMAT)
+				 CTR_FLAG_RAID10_FORMAT | \
+				 CTR_FLAG_DELTA_DISKS | \
+				 CTR_FLAG_DATA_OFFSET)
 
 /* "raid10" does not accept any raid1 or stripe cache options */
 #define RAID10_INVALID_FLAGS	(CTR_FLAG_WRITE_MOSTLY | \
@@ -115,16 +124,24 @@ struct raid_dev {
 #define RAID45_INVALID_FLAGS	(CTR_FLAG_WRITE_MOSTLY | \
 				 CTR_FLAG_MAX_WRITE_BEHIND | \
 				 CTR_FLAG_RAID10_FORMAT | \
-				 CTR_FLAG_RAID10_COPIES)
+				 CTR_FLAG_RAID10_COPIES | \
+				 CTR_FLAG_RAID10_USE_NEAR_SETS)
 #define RAID6_INVALID_FLAGS	(CTR_FLAG_NOSYNC | RAID45_INVALID_FLAGS)
 /* ...invalid options definitions per raid level */
 
+/* Array elements of 64 bit needed for rebuild/write_mostly bits */
+#define DISKS_ARRAY_ELEMS ((MAX_RAID_DEVICES + (sizeof(uint64_t) * 8 - 1)) / sizeof(uint64_t) / 8)
+
 struct raid_set {
 	struct dm_target *ti;
 
 	uint32_t bitmap_loaded;
 	uint32_t ctr_flags;
 
+	int raid_disks;
+	int delta_disks;
+	int raid10_copies;
+
 	struct mddev md;
 	struct raid_type *raid_type;
 	struct dm_target_callbacks callbacks;
@@ -132,6 +149,12 @@ struct raid_set {
 	struct raid_dev dev[0];
 };
 
+/* raid10 algorithms (i.e. formats) */
+#define	ALGORITHM_RAID10_DEFAULT	0
+#define	ALGORITHM_RAID10_NEAR		1
+#define	ALGORITHM_RAID10_OFFSET		2
+#define	ALGORITHM_RAID10_FAR		3
+
 /* Supported raid types and properties. */
 static struct raid_type {
 	const char *name;		/* RAID algorithm. */
@@ -141,17 +164,26 @@ static struct raid_type {
 	const unsigned level;		/* RAID level. */
 	const unsigned algorithm;	/* RAID algorithm. */
 } raid_types[] = {
-	{"raid0",    "RAID0 (striping)",                0, 2, 0, 0 /* NONE */},
-	{"raid1",    "RAID1 (mirroring)",               0, 2, 1, 0 /* NONE */},
-	{"raid10",   "RAID10 (striped mirrors)",        0, 2, 10, UINT_MAX /* Varies */},
-	{"raid4",    "RAID4 (dedicated parity disk)",	1, 2, 5, ALGORITHM_PARITY_0},
-	{"raid5_la", "RAID5 (left asymmetric)",		1, 2, 5, ALGORITHM_LEFT_ASYMMETRIC},
-	{"raid5_ra", "RAID5 (right asymmetric)",	1, 2, 5, ALGORITHM_RIGHT_ASYMMETRIC},
-	{"raid5_ls", "RAID5 (left symmetric)",		1, 2, 5, ALGORITHM_LEFT_SYMMETRIC},
-	{"raid5_rs", "RAID5 (right symmetric)",		1, 2, 5, ALGORITHM_RIGHT_SYMMETRIC},
-	{"raid6_zr", "RAID6 (zero restart)",		2, 4, 6, ALGORITHM_ROTATING_ZERO_RESTART},
-	{"raid6_nr", "RAID6 (N restart)",		2, 4, 6, ALGORITHM_ROTATING_N_RESTART},
-	{"raid6_nc", "RAID6 (N continue)",		2, 4, 6, ALGORITHM_ROTATING_N_CONTINUE}
+	{"raid0",         "raid0 (striping)",			    0, 2, 0,  0 /* NONE */},
+	{"raid1",         "raid1 (mirroring)",			    0, 2, 1,  0 /* NONE */},
+	{"raid10_far",    "raid10 far (striped mirrors)",	    0, 2, 10, ALGORITHM_RAID10_FAR},
+	{"raid10_offset", "raid10 offset (striped mirrors)",	    0, 2, 10, ALGORITHM_RAID10_OFFSET},
+	{"raid10_near",   "raid10 near (striped mirrors)",	    0, 2, 10, ALGORITHM_RAID10_NEAR},
+	{"raid10",        "raid10 (striped mirrors)",		    0, 2, 10, ALGORITHM_RAID10_DEFAULT},
+	{"raid4",         "raid4 (dedicated last parity disk)",	    1, 2, 4,  ALGORITHM_PARITY_N}, /* raid4 layout = raid5_n */
+	{"raid5_n",       "raid5 (dedicated last parity disk)",	    1, 2, 5,  ALGORITHM_PARITY_N},
+	{"raid5_ls",      "raid5 (left symmetric)",		    1, 2, 5,  ALGORITHM_LEFT_SYMMETRIC},
+	{"raid5_rs",      "raid5 (right symmetric)",		    1, 2, 5,  ALGORITHM_RIGHT_SYMMETRIC},
+	{"raid5_la",      "raid5 (left asymmetric)",		    1, 2, 5,  ALGORITHM_LEFT_ASYMMETRIC},
+	{"raid5_ra",      "raid5 (right asymmetric)",		    1, 2, 5,  ALGORITHM_RIGHT_ASYMMETRIC},
+	{"raid6_zr",      "raid6 (zero restart)",		    2, 4, 6,  ALGORITHM_ROTATING_ZERO_RESTART},
+	{"raid6_nr",      "raid6 (N restart)",			    2, 4, 6,  ALGORITHM_ROTATING_N_RESTART},
+	{"raid6_nc",      "raid6 (N continue)",			    2, 4, 6,  ALGORITHM_ROTATING_N_CONTINUE},
+	{"raid6_n_6",     "raid6 (dedicated parity/Q n/6)",	    2, 4, 6,  ALGORITHM_PARITY_N_6},
+	{"raid6_ls_6",    "raid6 (left symmetric dedicated Q 6)",   2, 4, 6,  ALGORITHM_LEFT_SYMMETRIC_6},
+	{"raid6_rs_6",    "raid6 (right symmetric dedicated Q 6)",  2, 4, 6,  ALGORITHM_RIGHT_SYMMETRIC_6},
+	{"raid6_la_6",    "raid6 (left asymmetric dedicated Q 6)",  2, 4, 6,  ALGORITHM_LEFT_ASYMMETRIC_6},
+	{"raid6_ra_6",    "raid6 (right asymmetric dedicated Q 6)", 2, 4, 6,  ALGORITHM_RIGHT_ASYMMETRIC_6}
 };
 
 /* True, if @v is in inclusive range [@min, @max] */
@@ -228,6 +260,23 @@ static const char *_argname_by_flag(const uint32_t flag)
 }
 
 /*
+ * bool helpers to test for various raid levels of a raid set,
+ * is. it's level as reported by the superblock rather than
+ * the requested raid_type passed to the constructor.
+ */
+/* Return true, if raid set in @rs is raid0 */
+static bool rs_is_raid0(struct raid_set *rs)
+{
+	return !rs->md.level;
+}
+
+/* Return true, if raid set in @rs is raid10 */
+static bool rs_is_raid10(struct raid_set *rs)
+{
+	return rs->md.level == 10;
+}
+
+/*
  * bool helpers to test for various raid levels of a raid type
  */
 
@@ -316,57 +365,184 @@ static int rs_check_for_invalid_flags(struct raid_set *rs)
 	return 0;
 }
 
-static char *raid10_md_layout_to_format(int layout)
+
+/* MD raid10 bit definitions and helpers */
+#define RAID10_OFFSET			(1 << 16) /* stripes with data copies area adjacent on devices */
+#define RAID10_BROCKEN_USE_FAR_SETS	(1 << 17) /* Broken in raid10.c: use sets instead of whole stripe rotation */
+#define RAID10_USE_FAR_SETS		(1 << 18) /* Use sets instead of whole stripe rotation */
+#define RAID10_FAR_COPIES_SHIFT		8	  /* raid10 # far copies shift (2nd byte of layout) */
+
+/* Return md raid10 near copies for @layout */
+static unsigned int _raid10_near_copies(int layout)
+{
+	return layout & 0xFF;
+}
+
+/* Return md raid10 far copies for @layout */
+static unsigned int _raid10_far_copies(int layout)
+{
+	return _raid10_near_copies(layout >> RAID10_FAR_COPIES_SHIFT);
+}
+
+/* Return true if md raid10 offset for @layout */
+static unsigned int _is_raid10_offset(int layout)
+{
+	return layout & RAID10_OFFSET;
+}
+
+/* Return true if md raid10 near for @layout */
+static unsigned int _is_raid10_near(int layout)
+{
+	return !_is_raid10_offset(layout) && _raid10_near_copies(layout) > 1;
+}
+
+/* Return true if md raid10 far for @layout */
+static unsigned int _is_raid10_far(int layout)
+{
+	return !_is_raid10_offset(layout) && _raid10_far_copies(layout) > 1;
+}
+
+/* Return md raid10 layout string for @layout */
+static const char *raid10_md_layout_to_format(int layout)
 {
 	/*
-	 * Bit 16 and 17 stand for "offset" and "use_far_sets"
+	 * Bit 16 stands for "offset"
+	 * (i.e. adjacent stripes hold copies)
+	 *
 	 * Refer to MD's raid10.c for details
 	 */
-	if ((layout & 0x10000) && (layout & 0x20000))
+	if (_is_raid10_offset(layout))
 		return "offset";
 
-	if ((layout & 0xFF) > 1)
+	if (_raid10_near_copies(layout) > 1)
 		return "near";
 
+	WARN_ON(_raid10_far_copies(layout) < 2);
+
 	return "far";
 }
 
-static unsigned raid10_md_layout_to_copies(int layout)
+/* Return md raid10 algorithm for @name */
+static const int raid10_name_to_format(const char *name)
+{
+	if (!strcasecmp(name, "near"))
+		return ALGORITHM_RAID10_NEAR;
+	else if (!strcasecmp(name, "offset"))
+		return ALGORITHM_RAID10_OFFSET;
+	else if (!strcasecmp(name, "far"))
+		return ALGORITHM_RAID10_FAR;
+
+	return -EINVAL;
+}
+
+
+/* Return md raid10 copies for @layout */
+static unsigned int raid10_md_layout_to_copies(int layout)
 {
-	if ((layout & 0xFF) > 1)
-		return layout & 0xFF;
-	return (layout >> 8) & 0xFF;
+	return _raid10_near_copies(layout) > 1 ?
+	       _raid10_near_copies(layout) : _raid10_far_copies(layout);
 }
 
-static int raid10_format_to_md_layout(char *format, unsigned copies)
+/* Return md raid10 format id for @format string */
+static int raid10_format_to_md_layout(struct raid_set *rs,
+				      unsigned int algorithm,
+				      unsigned int copies)
 {
-	unsigned n = 1, f = 1;
+	unsigned int n = 1, f = 1, r = 0;
 
-	if (!strcasecmp("near", format))
+	/*
+	 * MD resilienece flaw:
+	 *
+	 * enabling use_far_sets for far/offset formats causes copies
+	 * to be colocated on the same devs together with their origins!
+	 *
+	 * -> disable it for now in the definition above
+	 */
+	if (algorithm == ALGORITHM_RAID10_DEFAULT ||
+	    algorithm == ALGORITHM_RAID10_NEAR)
 		n = copies;
-	else
+
+	else if (algorithm == ALGORITHM_RAID10_OFFSET) {
+		f = copies;
+		r = RAID10_OFFSET;
+		if (!_test_flag(CTR_FLAG_RAID10_USE_NEAR_SETS, rs->ctr_flags))
+			r |= RAID10_USE_FAR_SETS;
+
+	} else if (algorithm == ALGORITHM_RAID10_FAR) {
 		f = copies;
+		r = !RAID10_OFFSET;
+		if (!_test_flag(CTR_FLAG_RAID10_USE_NEAR_SETS, rs->ctr_flags))
+			r |= RAID10_USE_FAR_SETS;
 
-	if (!strcasecmp("offset", format))
-		return 0x30000 | (f << 8) | n;
+	} else
+		return -EINVAL;
 
-	if (!strcasecmp("far", format))
-		return 0x20000 | (f << 8) | n;
+	return r | (f << RAID10_FAR_COPIES_SHIFT) | n;
+}
+/* END: MD raid10 bit definitions and helpers */
+
+/* Check for any of the raid10 algorithms */
+static int _got_raid10(struct raid_type *rtp, const int layout)
+{
+	if (rtp->level == 10) {
+		switch (rtp->algorithm) {
+		case ALGORITHM_RAID10_DEFAULT:
+		case ALGORITHM_RAID10_NEAR:
+			return _is_raid10_near(layout);
+		case ALGORITHM_RAID10_OFFSET:
+			return _is_raid10_offset(layout);
+		case ALGORITHM_RAID10_FAR:
+			return _is_raid10_far(layout);
+		default:
+			break;
+		}
+	}
 
-	return (f << 8) | n;
+	return 0;
 }
 
+/* Return raid_type for @name */
 static struct raid_type *get_raid_type(const char *name)
 {
-	int i;
+	struct raid_type *rtp = raid_types + ARRAY_SIZE(raid_types);
+
+	while (rtp-- > raid_types)
+		if (!strcasecmp(rtp->name, name))
+			return rtp;
+
+	return NULL;
+}
 
-	for (i = 0; i < ARRAY_SIZE(raid_types); i++)
-		if (!strcmp(raid_types[i].name, name))
-			return &raid_types[i];
+/* Return raid_type for @name based derived from @level and @layout */
+static struct raid_type *get_raid_type_by_ll(const int level, const int layout)
+{
+	struct raid_type *rtp = raid_types + ARRAY_SIZE(raid_types);
+
+	while (rtp-- > raid_types) {
+		/* RAID10 special checks based on @layout flags/properties */
+		if (rtp->level == level &&
+		    (_got_raid10(rtp, layout) || rtp->algorithm == layout))
+			return rtp;
+	}
 
 	return NULL;
 }
 
+/*
+ * Set the mddev properties in @rs to the new
+ * ones requested by the ctr
+ */
+static void rs_set_new(struct raid_set *rs)
+{
+	struct mddev *mddev = &rs->md;
+
+	mddev->level = mddev->new_level;
+	mddev->layout = mddev->new_layout;
+	mddev->chunk_sectors = mddev->new_chunk_sectors;
+	mddev->delta_disks = 0;
+}
+
+
 static struct raid_set *context_alloc(struct dm_target *ti, struct raid_type *raid_type, unsigned raid_devs)
 {
 	unsigned i;
@@ -381,6 +557,9 @@ static struct raid_set *context_alloc(struct dm_target *ti, struct raid_type *ra
 
 	mddev_init(&rs->md);
 
+	rs->raid_disks = raid_devs;
+	rs->delta_disks = 0;
+
 	rs->ti = ti;
 	rs->raid_type = raid_type;
 	rs->md.raid_disks = raid_devs;
@@ -712,7 +891,7 @@ too_many:
 static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 			     unsigned num_raid_params)
 {
-	char *raid10_format = "near";
+	int raid10_format = ALGORITHM_RAID10_DEFAULT;
 	unsigned raid10_copies = 2;
 	unsigned i;
 	unsigned value, region_size = 0;
@@ -720,6 +899,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 	sector_t max_io_len;
 	const char *arg, *key;
 	struct raid_dev *rd;
+	struct raid_type *rt = rs->raid_type;
 
 	arg = dm_shift_arg(as);
 	num_raid_params--; /* Account for chunk_size argument */
@@ -731,7 +911,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 	 * First, parse the in-order required arguments
 	 * "chunk_size" is the only argument of this type.
 	 */
-	if (rt_is_raid1(rs->raid_type)) {
+	if (rt_is_raid1(rt)) {
 		if (value)
 			DMERR("Ignoring chunk size parameter for RAID 1");
 		value = 0;
@@ -796,14 +976,11 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 		if (!strcasecmp(key, _argname_by_flag(CTR_FLAG_RAID10_FORMAT))) {
 			if (_test_and_set_flag(CTR_FLAG_RAID10_FORMAT, &rs->ctr_flags))
 				return ti_error_einval(rs->ti, "Only one raid10_format argument pair allowed");
-			if (!rt_is_raid10(rs->raid_type))
+			if (!rt_is_raid10(rt))
 				return ti_error_einval(rs->ti, "'raid10_format' is an invalid parameter for this RAID type");
-			if (strcmp("near", arg) &&
-			    strcmp("far", arg) &&
-			    strcmp("offset", arg))
-				return ti_error_einval(rs->ti, "Invalid 'raid10_format' value given");
-
-			raid10_format = (char *) arg;
+			raid10_format = raid10_name_to_format(arg);
+			if (raid10_format < 0)
+				return ti_error_ret(rs->ti, "Invalid 'raid10_format' value given", raid10_format);
 			continue;
 		}
 
@@ -825,7 +1002,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 			rd->rdev.recovery_offset = 0;
 			_set_flag(CTR_FLAG_REBUILD, &rs->ctr_flags);
 		} else if (!strcasecmp(key, _argname_by_flag(CTR_FLAG_WRITE_MOSTLY))) {
-			if (!rt_is_raid1(rs->raid_type))
+			if (!rt_is_raid1(rt))
 				return ti_error_einval(rs->ti, "write_mostly option is only valid for RAID1");
  
 			if (!_in_range(value, 0, rs->md.raid_disks - 1))
@@ -834,7 +1011,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 			set_bit(WriteMostly, &rs->dev[value].rdev.flags);
 			_set_flag(CTR_FLAG_WRITE_MOSTLY, &rs->ctr_flags);
 		} else if (!strcasecmp(key, _argname_by_flag(CTR_FLAG_MAX_WRITE_BEHIND))) {
-			if (!rt_is_raid1(rs->raid_type))
+			if (!rt_is_raid1(rt))
 				return ti_error_einval(rs->ti, "max_write_behind option is only valid for RAID1");
 
 			if (_test_and_set_flag(CTR_FLAG_MAX_WRITE_BEHIND, &rs->ctr_flags))
@@ -864,7 +1041,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 			 */
 			value /= 2;
 
-			if (!rt_is_raid456(rs->raid_type))
+			if (!rt_is_raid456(rt))
 				return ti_error_einval(rs->ti, "Inappropriate argument: stripe_cache");
 			if (raid5_set_cache_size(&rs->md, (int)value))
 				return ti_error_einval(rs->ti, "Bad stripe_cache size");
@@ -911,29 +1088,35 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 	if (dm_set_target_max_io_len(rs->ti, max_io_len))
 		return -EINVAL;
 
-	if (rt_is_raid10(rs->raid_type)) {
+	if (rt_is_raid10(rt)) {
 		if (raid10_copies > rs->md.raid_disks)
 			return ti_error_einval(rs->ti, "Not enough devices to satisfy specification");
 
-		/*
-		 * If the format is not "near", we only support
-		 * two copies at the moment.
-		 */
-		if (strcmp("near", raid10_format) && (raid10_copies > 2))
-			return ti_error_einval(rs->ti, "Too many copies for given RAID10 format.");
+		rs->md.new_layout = raid10_format_to_md_layout(rs, raid10_format, raid10_copies);
+		if (rs->md.new_layout < 0)
+			return ti_error_ret(rs->ti, "Error getting raid10 format", rs->md.new_layout);
+
+		rt = get_raid_type_by_ll(10, rs->md.new_layout);
+		if (!rt)
+			return ti_error_einval(rs->ti, "Failed to recognize new raid10 layout");
+
+		if ((rt->algorithm == ALGORITHM_RAID10_DEFAULT ||
+		     rt->algorithm == ALGORITHM_RAID10_NEAR) &&
+		    _test_flag(CTR_FLAG_RAID10_USE_NEAR_SETS, rs->ctr_flags))
+			return ti_error_einval(rs->ti, "RAID10 format \"near\" and \"raid10_use_near_sets\" are incompatible");
 
 		/* (Len * #mirrors) / #devices */
 		sectors_per_dev = rs->ti->len * raid10_copies;
 		sector_div(sectors_per_dev, rs->md.raid_disks);
 
-		rs->md.layout = raid10_format_to_md_layout(raid10_format,
-							   raid10_copies);
+		rs->md.layout = raid10_format_to_md_layout(rs, raid10_format, raid10_copies);
 		rs->md.new_layout = rs->md.layout;
-	} else if (!rt_is_raid1(rs->raid_type) &&
+	} else if (!rt_is_raid1(rt) &&
 		   sector_div(sectors_per_dev,
-			      (rs->md.raid_disks - rs->raid_type->parity_devs)))
+			      (rs->md.raid_disks - rt->parity_devs)))
 		return ti_error_einval(rs->ti, "Target length not divisible by number of data devices");
 
+	rs->raid10_copies = raid10_copies;
 	rs->md.dev_sectors = sectors_per_dev;
 
 	/* Assume there are no metadata devices until the drives are parsed */
@@ -958,6 +1141,13 @@ static int raid_is_congested(struct dm_target_callbacks *cb, int bits)
 	return mddev_congested(&rs->md, bits);
 }
 
+/*  Features */
+#define	FEATURE_FLAG_SUPPORTS_RESHAPE	0x1
+
+/* State flags for sb->flags */
+#define	SB_FLAG_RESHAPE_ACTIVE		0x1
+#define	SB_FLAG_RESHAPE_BACKWARDS	0x2
+
 /*
  * This structure is never routinely used by userspace, unlike md superblocks.
  * Devices with this superblock should only ever be accessed via device-mapper.
@@ -965,13 +1155,14 @@ static int raid_is_congested(struct dm_target_callbacks *cb, int bits)
 #define DM_RAID_MAGIC 0x64526D44
 struct dm_raid_superblock {
 	__le32 magic;		/* "DmRd" */
-	__le32 features;	/* Used to indicate possible future changes */
+	__le32 compat_features;	/* Used to indicate compatible features (like 1.8.0 ondisk metadata extension) */
 
-	__le32 num_devices;	/* Number of devices in this array. (Max 64) */
-	__le32 array_position;	/* The position of this drive in the array */
+	__le32 num_devices;	/* Number of devices in this raid set. (Max 64) */
+	__le32 array_position;	/* The position of this drive in the raid set */
 
 	__le64 events;		/* Incremented by md when superblock updated */
-	__le64 failed_devices;	/* Bit field of devices to indicate failures */
+	__le64 failed_devices;	/* Pre 1.8.0 part of bit field of devices to */
+				/* indicate failures (see extension below) */
 
 	/*
 	 * This offset tracks the progress of the repair or replacement of
@@ -980,19 +1171,62 @@ struct dm_raid_superblock {
 	__le64 disk_recovery_offset;
 
 	/*
-	 * This offset tracks the progress of the initial array
+	 * This offset tracks the progress of the initial raid set
 	 * synchronisation/parity calculation.
 	 */
 	__le64 array_resync_offset;
 
 	/*
-	 * RAID characteristics
+	 * raid characteristics
 	 */
 	__le32 level;
 	__le32 layout;
 	__le32 stripe_sectors;
 
-	/* Remainder of a logical block is zero-filled when writing (see super_sync()). */
+	/********************************************************************
+	 * BELOW FOLLOW V1.8.0 EXTENSIONS TO THE PRISTINE SUPERBLOCK FORMAT!!!
+	 *
+	 * FEATURE_FLAG_SUPPORTS_RESHAPE in the features member indicates that those exist
+	 */
+
+	__le32 flags; /* Flags defining array states for reshaping */
+
+	/*
+	 * This offset tracks the progress of a raid
+	 * set reshape in order to be able to restart it
+	 */
+	__le64 reshape_position;
+
+	/*
+	 * These define the properties of the array in case of an interrupted reshape
+	 */
+	__le32 new_level;
+	__le32 new_layout;
+	__le32 new_stripe_sectors;
+	__le32 delta_disks;
+
+	__le64 array_sectors; /* Array size in sectors */
+
+	/*
+	 * Sector offsets to data on devices (reshaping).
+	 * Needed to support out of place reshaping, thus
+	 * not writing over any stripes whilst converting
+	 * them from old to new layout
+	 */
+	__le64 data_offset;
+	__le64 new_data_offset;
+
+	__le64 sectors; /* Used device size in sectors */
+
+	/*
+	 * Additonal Bit field of devices indicating failures to support
+	 * up to 256 devices with the 1.8.0 on-disk metadata format
+	 */
+	__le64 extended_failed_devices[DISKS_ARRAY_ELEMS - 1];
+
+	__le32 incompat_features;	/* Used to indicate any incompatible features */
+
+	/* Always set rest up to logical block size to 0 when writing (see get_metadata_device() below). */
 } __packed;
 
 static int read_disk_sb(struct md_rdev *rdev, int size)
@@ -1032,7 +1266,7 @@ static void super_sync(struct mddev *mddev, struct md_rdev *rdev)
 	memset(sb + 1, 0, rdev->sb_size - sizeof(*sb));
 
 	sb->magic = cpu_to_le32(DM_RAID_MAGIC);
-	sb->features = cpu_to_le32(0);	/* No features yet */
+	sb->compat_features = cpu_to_le32(0);	/* No features yet */
 
 	sb->num_devices = cpu_to_le32(mddev->raid_disks);
 	sb->array_position = cpu_to_le32(rdev->raid_disk);
@@ -1105,119 +1339,210 @@ static int super_load(struct md_rdev *rdev, struct md_rdev *refdev)
 	return (events_sb > events_refsb) ? 1 : 0;
 }
 
-static int super_init_validation(struct mddev *mddev, struct md_rdev *rdev)
+/* Helper to retrieve all failed devices bits from @sb */
+static void sb_retrieve_failed_devices(struct dm_raid_superblock *sb, uint64_t *failed_devices)
+{
+	failed_devices[0] = le64_to_cpu(sb->failed_devices);
+	memset(failed_devices + 1, 0, sizeof(sb->extended_failed_devices));
+
+	if (_test_flag(FEATURE_FLAG_SUPPORTS_RESHAPE, le32_to_cpu(sb->compat_features))) {
+		int i = ARRAY_SIZE(sb->extended_failed_devices);
+
+		while (i--)
+			failed_devices[i+1] = le64_to_cpu(sb->extended_failed_devices[i]);
+	}
+}
+
+static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 {
 	int role;
-	struct raid_set *rs = container_of(mddev, struct raid_set, md);
+	unsigned int d;
+	struct mddev *mddev = &rs->md;
 	uint64_t events_sb;
-	uint64_t failed_devices;
+	uint64_t failed_devices[DISKS_ARRAY_ELEMS];
 	struct dm_raid_superblock *sb;
-	uint32_t new_devs = 0;
-	uint32_t rebuilds = 0;
+	uint32_t new_devs = 0, rebuild_and_new = 0, rebuilds = 0;
 	struct md_rdev *r;
 	struct dm_raid_superblock *sb2;
 
 	sb = page_address(rdev->sb_page);
 	events_sb = le64_to_cpu(sb->events);
-	failed_devices = le64_to_cpu(sb->failed_devices);
 
 	/*
 	 * Initialise to 1 if this is a new superblock.
 	 */
 	mddev->events = events_sb ? : 1;
 
+	mddev->reshape_position = MaxSector;
+
 	/*
-	 * Reshaping is not currently allowed
+	 * Reshaping is supported, e.g. reshape_position is valid
+	 * in superblock and superblock content is authoritative.
 	 */
-	if (le32_to_cpu(sb->level) != mddev->level) {
-		DMERR("Reshaping arrays not yet supported. (RAID level change)");
-		return -EINVAL;
-	}
-	if (le32_to_cpu(sb->layout) != mddev->layout) {
-		DMERR("Reshaping arrays not yet supported. (RAID layout change)");
-		DMERR("  0x%X vs 0x%X", le32_to_cpu(sb->layout), mddev->layout);
-		DMERR("  Old layout: %s w/ %d copies",
-		      raid10_md_layout_to_format(le32_to_cpu(sb->layout)),
-		      raid10_md_layout_to_copies(le32_to_cpu(sb->layout)));
-		DMERR("  New layout: %s w/ %d copies",
-		      raid10_md_layout_to_format(mddev->layout),
-		      raid10_md_layout_to_copies(mddev->layout));
-		return -EINVAL;
-	}
-	if (le32_to_cpu(sb->stripe_sectors) != mddev->chunk_sectors) {
-		DMERR("Reshaping arrays not yet supported. (stripe sectors change)");
-		return -EINVAL;
-	}
+	if (_test_flag(FEATURE_FLAG_SUPPORTS_RESHAPE, le32_to_cpu(sb->compat_features))) {
+		/* Superblock is authoritative wrt given raid set layout! */
+		mddev->raid_disks = le32_to_cpu(sb->num_devices);
+		mddev->level = le32_to_cpu(sb->level);
+		mddev->layout = le32_to_cpu(sb->layout);
+		mddev->chunk_sectors = le32_to_cpu(sb->stripe_sectors);
+		mddev->new_level = le32_to_cpu(sb->new_level);
+		mddev->new_layout = le32_to_cpu(sb->new_layout);
+		mddev->new_chunk_sectors = le32_to_cpu(sb->new_stripe_sectors);
+		mddev->delta_disks = le32_to_cpu(sb->delta_disks);
+		mddev->array_sectors = le64_to_cpu(sb->array_sectors);
+
+		/* raid was reshaping and got interrupted */
+		if (_test_flag(SB_FLAG_RESHAPE_ACTIVE, le32_to_cpu(sb->flags))) {
+			if (_test_flag(CTR_FLAG_DELTA_DISKS, rs->ctr_flags)) {
+				DMERR("Reshape requested but raid set is still reshaping");
+				return -EINVAL;
+			}
 
-	/* We can only change the number of devices in RAID1 right now */
-	if (!rt_is_raid1(rs->raid_type) &&
-	    (le32_to_cpu(sb->num_devices) != mddev->raid_disks)) {
-		DMERR("Reshaping arrays not yet supported. (device count change)");
-		return -EINVAL;
+			if (mddev->delta_disks < 0 ||
+			    (!mddev->delta_disks && _test_flag(SB_FLAG_RESHAPE_BACKWARDS, le32_to_cpu(sb->flags))))
+				mddev->reshape_backwards = 1;
+			else
+				mddev->reshape_backwards = 0;
+
+			mddev->reshape_position = le64_to_cpu(sb->reshape_position);
+			rs->raid_type = get_raid_type_by_ll(mddev->level, mddev->layout);
+		}
+
+	} else {
+		/*
+		 * Reshaping is not allowed, because we don't have the appropriate metadata
+		 */
+		if (le32_to_cpu(sb->level) != mddev->level) {
+			DMERR("Reshaping/takeover raid sets not yet supported. (raid level/stripes/size change)");
+			return -EINVAL;
+		}
+		if (le32_to_cpu(sb->layout) != mddev->layout) {
+			DMERR("Reshaping raid sets not yet supported. (raid layout change)");
+			DMERR("  0x%X vs 0x%X", le32_to_cpu(sb->layout), mddev->layout);
+			DMERR("  Old layout: %s w/ %d copies",
+			      raid10_md_layout_to_format(le32_to_cpu(sb->layout)),
+			      raid10_md_layout_to_copies(le32_to_cpu(sb->layout)));
+			DMERR("  New layout: %s w/ %d copies",
+			      raid10_md_layout_to_format(mddev->layout),
+			      raid10_md_layout_to_copies(mddev->layout));
+			return -EINVAL;
+		}
+		if (le32_to_cpu(sb->stripe_sectors) != mddev->chunk_sectors) {
+			DMERR("Reshaping raid sets not yet supported. (stripe sectors change)");
+			return -EINVAL;
+		}
+
+		/* We can only change the number of devices in raid1 with old (i.e. pre 1.0.7) metadata */
+		if (!rt_is_raid1(rs->raid_type) &&
+		    (le32_to_cpu(sb->num_devices) != mddev->raid_disks)) {
+			DMERR("Reshaping raid sets not yet supported. (device count change from %u to %u)",
+			      sb->num_devices, mddev->raid_disks);
+			return -EINVAL;
+		}
+
+		/* Table line is checked vs. authoritative superblock */
+		rs_set_new(rs);
 	}
 
-	if (!(_test_flags(CTR_FLAGS_ANY_SYNC, rs->ctr_flags)))
+	if (!_test_flag(CTR_FLAG_NOSYNC, rs->ctr_flags))
 		mddev->recovery_cp = le64_to_cpu(sb->array_resync_offset);
 
 	/*
 	 * During load, we set FirstUse if a new superblock was written.
 	 * There are two reasons we might not have a superblock:
-	 * 1) The array is brand new - in which case, all of the
+	 * 1) The raid set is brand new - in which case, all of the
 	 *    devices must have their In_sync bit set.  Also,
 	 *    recovery_cp must be 0, unless forced.
-	 * 2) This is a new device being added to an old array
+	 * 2) This is a new device being added to an old raid set
 	 *    and the new device needs to be rebuilt - in which
 	 *    case the In_sync bit will /not/ be set and
 	 *    recovery_cp must be MaxSector.
 	 */
+	d = 0;
 	rdev_for_each(r, mddev) {
+		if (test_bit(FirstUse, &r->flags))
+			new_devs++;
+
 		if (!test_bit(In_sync, &r->flags)) {
-			DMINFO("Device %d specified for rebuild: "
-			       "Clearing superblock", r->raid_disk);
+			DMINFO("Device %d specified for rebuild; clearing superblock",
+				r->raid_disk);
 			rebuilds++;
-		} else if (test_bit(FirstUse, &r->flags))
-			new_devs++;
+
+			if (test_bit(FirstUse, &r->flags))
+				rebuild_and_new++;
+		}
+
+		d++;
 	}
 
-	if (!rebuilds) {
-		if (new_devs == mddev->raid_disks) {
-			DMINFO("Superblocks created for new array");
+	if (new_devs == rs->raid_disks || !rebuilds) {
+		/* Replace a broken device */
+		if (new_devs == 1 && !rs->delta_disks)
+			;
+		if (new_devs == rs->raid_disks) {
+			DMINFO("Superblocks created for new raid set");
 			set_bit(MD_ARRAY_FIRST_USE, &mddev->flags);
-		} else if (new_devs) {
-			DMERR("New device injected "
-			      "into existing array without 'rebuild' "
-			      "parameter specified");
+			mddev->recovery_cp = 0;
+		} else if (new_devs && new_devs != rs->raid_disks && !rebuilds) {
+			DMERR("New device injected into existing raid set without "
+			      "'delta_disks' or 'rebuild' parameter specified");
 			return -EINVAL;
 		}
-	} else if (new_devs) {
-		DMERR("'rebuild' devices cannot be "
-		      "injected into an array with other first-time devices");
-		return -EINVAL;
-	} else if (mddev->recovery_cp != MaxSector) {
-		DMERR("'rebuild' specified while array is not in-sync");
+	} else if (new_devs && new_devs != rebuilds) {
+		DMERR("%u 'rebuild' devices cannot be injected into"
+		      " a raid set with %u other first-time devices",
+		      rebuilds, new_devs);
 		return -EINVAL;
+	} else if (rebuilds) {
+		if (rebuild_and_new && rebuilds != rebuild_and_new) {
+			DMERR("new device%s provided w/o 'rebuild'",
+			      new_devs > 1 ? "s" : "");
+			return -EINVAL;
+		} else if (mddev->recovery_cp != MaxSector) {
+			DMERR("'rebuild' specified while raid set is not in-sync (recovery_cp=%llu)",
+			      (unsigned long long) mddev->recovery_cp);
+			return -EINVAL;
+		} else if (mddev->reshape_position != MaxSector) {
+			DMERR("'rebuild' specified while raid set is being reshaped");
+			return -EINVAL;
+		}
 	}
 
 	/*
 	 * Now we set the Faulty bit for those devices that are
 	 * recorded in the superblock as failed.
 	 */
+	sb_retrieve_failed_devices(sb, failed_devices);
 	rdev_for_each(r, mddev) {
 		if (!r->sb_page)
 			continue;
 		sb2 = page_address(r->sb_page);
 		sb2->failed_devices = 0;
+		memset(sb2->extended_failed_devices, 0, sizeof(sb2->extended_failed_devices));
 
 		/*
 		 * Check for any device re-ordering.
 		 */
 		if (!test_bit(FirstUse, &r->flags) && (r->raid_disk >= 0)) {
 			role = le32_to_cpu(sb2->array_position);
+			if (role < 0)
+				continue;
+
 			if (role != r->raid_disk) {
-				if (!rt_is_raid1(rs->raid_type))
-					return ti_error_einval(rs->ti, "Cannot change device "
-								       "positions in RAID array");
-				DMINFO("RAID1 device #%d now at position #%d",
+				if (_is_raid10_near(mddev->layout)) {
+					if (mddev->raid_disks % _raid10_near_copies(mddev->layout) ||
+					    rs->raid_disks % rs->raid10_copies)
+						return ti_error_einval(rs->ti, "Cannot change raid10 near "
+									       "set to odd # of devices!");
+
+					sb2->array_position = cpu_to_le32(r->raid_disk);
+
+				} else if (!(rs_is_raid10(rs) && rt_is_raid0(rs->raid_type)) &&
+				    !(rs_is_raid0(rs) && rt_is_raid10(rs->raid_type)) &&
+				    !rt_is_raid1(rs->raid_type))
+					return ti_error_einval(rs->ti, "Cannot change device positions in raid set");
+
+				DMINFO("raid device #%d now at position #%d",
 				       role, r->raid_disk);
 			}
 
@@ -1225,7 +1550,7 @@ static int super_init_validation(struct mddev *mddev, struct md_rdev *rdev)
 			 * Partial recovery is performed on
 			 * returning failed devices.
 			 */
-			if (failed_devices & (1 << role))
+			if (test_bit(role, (void *) failed_devices))
 				set_bit(Faulty, &r->flags);
 		}
 	}
@@ -1236,36 +1561,54 @@ static int super_init_validation(struct mddev *mddev, struct md_rdev *rdev)
 static int super_validate(struct raid_set *rs, struct md_rdev *rdev)
 {
 	struct mddev *mddev = &rs->md;
-	struct dm_raid_superblock *sb = page_address(rdev->sb_page);
+	struct dm_raid_superblock *sb;
+
+	if (!rdev->sb_page)
+		return 0;
+
+	sb = page_address(rdev->sb_page);
 
 	/*
 	 * If mddev->events is not set, we know we have not yet initialized
 	 * the array.
 	 */
-	if (!mddev->events && super_init_validation(mddev, rdev))
+	if (!mddev->events && super_init_validation(rs, rdev))
 		return -EINVAL;
 
+	if (sb->compat_features || sb->incompat_features) /* No features supported yet */
+		return ti_error_einval(rs->ti, "Unable to assemble array: No feature flags supported yet");
+
 	/* Enable bitmap creation for RAID levels != 0 */
 	mddev->bitmap_info.offset = rt_is_raid0(rs->raid_type) ? 0 : to_sector(4096);
 	rdev->mddev->bitmap_info.default_offset = mddev->bitmap_info.offset;
 
-	if (!test_bit(FirstUse, &rdev->flags)) {
+
+	if (!test_and_clear_bit(FirstUse, &rdev->flags)) {
+		/* Retrieve device size stored in superblock to be prepared for shrink */
+		rdev->sectors = le64_to_cpu(sb->sectors);
 		rdev->recovery_offset = le64_to_cpu(sb->disk_recovery_offset);
-		if (rdev->recovery_offset != MaxSector)
-			clear_bit(In_sync, &rdev->flags);
+		if (rdev->recovery_offset == MaxSector)
+			set_bit(In_sync, &rdev->flags);
+		/*
+		 * If no reshape in progress -> we're recovering single
+		 * disk(s) and have to set the device(s) to out-of-sync
+		 */
+		else if (rs->md.reshape_position == MaxSector)
+			clear_bit(In_sync, &rdev->flags); /* Mandatory for recovery */
 	}
 
 	/*
 	 * If a device comes back, set it as not In_sync and no longer faulty.
 	 */
-	if (test_bit(Faulty, &rdev->flags)) {
-		clear_bit(Faulty, &rdev->flags);
+	if (test_and_clear_bit(Faulty, &rdev->flags)) {
+		rdev->recovery_offset = 0;
 		clear_bit(In_sync, &rdev->flags);
 		rdev->saved_raid_disk = rdev->raid_disk;
-		rdev->recovery_offset = 0;
 	}
 
-	clear_bit(FirstUse, &rdev->flags);
+	/* Reshape support -> restore repective data offsets */
+	rdev->data_offset = le64_to_cpu(sb->data_offset);
+	rdev->new_data_offset = le64_to_cpu(sb->new_data_offset);
 
 	return 0;
 }
-- 
2.5.5
