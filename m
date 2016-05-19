From: heinzm@redhat.com
Subject: [PATCH 02/11] dm-raid: use dm_arg_set API in constructor
Date: Thu, 19 May 2016 18:49:25 +0200
Message-ID: <1463676574-12596-3-git-send-email-heinzm@redhat.com>
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

Adjust the dm-raid target ti use the dm_arg_set API as other targets do:

- use dm_arg_set API in ctr and its callees parse_raid_params() and dev_parms()

- introduce _in_range() function to check a value is in a [ min, max ] range; 
  this is to support more callers in parsing parameters etc. in the future 

- correct comment on MAX_RAID_DEVICES


Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 145 +++++++++++++++++++++++++++++----------------------
 1 file changed, 84 insertions(+), 61 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 91af447..cc41f5d 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -17,7 +17,7 @@
 #include <linux/device-mapper.h>
 
 #define DM_MSG_PREFIX "raid"
-#define	MAX_RAID_DEVICES	253 /* raid4/5/6 limit */
+#define	MAX_RAID_DEVICES	253 /* md-raid kernel limit */
 
 static bool devices_handle_discard_safely = false;
 
@@ -95,6 +95,12 @@ static struct raid_type {
 	{"raid6_nc", "RAID6 (N continue)",		2, 4, 6, ALGORITHM_ROTATING_N_CONTINUE}
 };
 
+/* True, if @v is in inclusive range [@min, @max] */
+static bool _in_range(long v, long min, long max)
+{
+	return v >= min && v <= max;
+}
+
 static char *raid10_md_layout_to_format(int layout)
 {
 	/*
@@ -135,7 +141,7 @@ static int raid10_format_to_md_layout(char *format, unsigned copies)
 	return (f << 8) | n;
 }
 
-static struct raid_type *get_raid_type(char *name)
+static struct raid_type *get_raid_type(const char *name)
 {
 	int i;
 
@@ -220,14 +226,20 @@ static void context_free(struct raid_set *rs)
  * This code parses those words.  If there is a failure,
  * the caller must use context_free to unwind the operations.
  */
-static int dev_parms(struct raid_set *rs, char **argv)
+static int parse_dev_parms(struct raid_set *rs, struct dm_arg_set *as)
 {
 	int i;
 	int rebuild = 0;
 	int metadata_available = 0;
 	int r = 0;
+	const char *arg;
 
-	for (i = 0; i < rs->md.raid_disks; i++, argv += 2) {
+	/* Put off the number of raid devices argument to get to dev pairs */
+	arg = dm_shift_arg(as);
+	if (!arg)
+		return -EINVAL;
+
+	for (i = 0; i < rs->md.raid_disks; i++) {
 		rs->dev[i].rdev.raid_disk = i;
 
 		rs->dev[i].meta_dev = NULL;
@@ -240,8 +252,12 @@ static int dev_parms(struct raid_set *rs, char **argv)
 		rs->dev[i].rdev.data_offset = 0;
 		rs->dev[i].rdev.mddev = &rs->md;
 
-		if (strcmp(argv[0], "-")) {
-			r = dm_get_device(rs->ti, argv[0],
+		arg = dm_shift_arg(as);
+		if (!arg)
+			return -EINVAL;
+
+		if (strcmp(arg, "-")) {
+			r = dm_get_device(rs->ti, arg,
 					    dm_table_get_mode(rs->ti->table),
 					    &rs->dev[i].meta_dev);
 			rs->ti->error = "RAID metadata device lookup failure";
@@ -253,7 +269,11 @@ static int dev_parms(struct raid_set *rs, char **argv)
 				return -ENOMEM;
 		}
 
-		if (!strcmp(argv[1], "-")) {
+		arg = dm_shift_arg(as);
+		if (!arg)
+			return -EINVAL;
+
+		if (!strcmp(arg, "-")) {
 			if (!test_bit(In_sync, &rs->dev[i].rdev.flags) &&
 			    (!rs->dev[i].rdev.recovery_offset)) {
 				rs->ti->error = "Drive designated for rebuild not specified";
@@ -267,7 +287,7 @@ static int dev_parms(struct raid_set *rs, char **argv)
 			continue;
 		}
 
-		r = dm_get_device(rs->ti, argv[1],
+		r = dm_get_device(rs->ti, arg,
 				    dm_table_get_mode(rs->ti->table),
 				    &rs->dev[i].data_dev);
 		if (r) {
@@ -492,25 +512,30 @@ too_many:
  *    [raid10_copies <# copies>]        Number of copies.  (Default: 2)
  *    [raid10_format <near|far|offset>] Layout algorithm.  (Default: near)
  */
-static int parse_raid_params(struct raid_set *rs, char **argv,
+static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 			     unsigned num_raid_params)
 {
 	char *raid10_format = "near";
 	unsigned raid10_copies = 2;
 	unsigned i;
-	unsigned long value, region_size = 0;
+	unsigned value, region_size = 0;
 	sector_t sectors_per_dev = rs->ti->len;
 	sector_t max_io_len;
-	char *key;
+	const char *arg, *key;
+
+	arg = dm_shift_arg(as);
+	num_raid_params--; /* Account for chunk_size argument */
+
+	if (kstrtouint(arg, 10, &value) < 0) {
+		rs->ti->error = "Bad numerical argument given for chunk_size";
+		return -EINVAL;
+	}
 
 	/*
 	 * First, parse the in-order required arguments
 	 * "chunk_size" is the only argument of this type.
 	 */
-	if ((kstrtoul(argv[0], 10, &value) < 0)) {
-		rs->ti->error = "Bad chunk size";
-		return -EINVAL;
-	} else if (rs->raid_type->level == 1) {
+	if (rs->raid_type->level == 1) {
 		if (value)
 			DMERR("Ignoring chunk size parameter for RAID 1");
 		value = 0;
@@ -523,8 +548,6 @@ static int parse_raid_params(struct raid_set *rs, char **argv,
 	}
 
 	rs->md.new_chunk_sectors = rs->md.chunk_sectors = value;
-	argv++;
-	num_raid_params--;
 
 	/*
 	 * We set each individual device as In_sync with a completed
@@ -552,12 +575,18 @@ static int parse_raid_params(struct raid_set *rs, char **argv,
 	 * Second, parse the unordered optional arguments
 	 */
 	for (i = 0; i < num_raid_params; i++) {
-		if (!strcasecmp(argv[i], "nosync")) {
+		arg = dm_shift_arg(as);
+		if (!arg) {
+			rs->ti->error = "Not enough raid parameters given";
+			return -EINVAL;
+		}
+
+		if (!strcasecmp(arg, "nosync")) {
 			rs->md.recovery_cp = MaxSector;
 			rs->ctr_flags |= CTR_FLAG_NOSYNC;
 			continue;
 		}
-		if (!strcasecmp(argv[i], "sync")) {
+		if (!strcasecmp(arg, "sync")) {
 			rs->md.recovery_cp = 0;
 			rs->ctr_flags |= CTR_FLAG_SYNC;
 			continue;
@@ -569,7 +598,9 @@ static int parse_raid_params(struct raid_set *rs, char **argv,
 			return -EINVAL;
 		}
 
-		key = argv[i++];
+		key = arg;
+		arg = dm_shift_arg(as);
+		i++; /* Account for the argument pairs */
 
 		/* Parameters that take a string value are checked here. */
 		if (!strcasecmp(key, "raid10_format")) {
@@ -577,18 +608,18 @@ static int parse_raid_params(struct raid_set *rs, char **argv,
 				rs->ti->error = "'raid10_format' is an invalid parameter for this RAID type";
 				return -EINVAL;
 			}
-			if (strcmp("near", argv[i]) &&
-			    strcmp("far", argv[i]) &&
-			    strcmp("offset", argv[i])) {
+			if (strcmp("near", arg) &&
+			    strcmp("far", arg) &&
+			    strcmp("offset", arg)) {
 				rs->ti->error = "Invalid 'raid10_format' value given";
 				return -EINVAL;
 			}
-			raid10_format = argv[i];
+			raid10_format = (char *) arg;
 			rs->ctr_flags |= CTR_FLAG_RAID10_FORMAT;
 			continue;
 		}
 
-		if (kstrtoul(argv[i], 10, &value) < 0) {
+		if (kstrtouint(arg, 10, &value) < 0) {
 			rs->ti->error = "Bad numerical argument given in raid params";
 			return -EINVAL;
 		}
@@ -1218,61 +1249,53 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 {
 	int r;
 	struct raid_type *rt;
-	unsigned long num_raid_params, num_raid_devs;
+	unsigned num_raid_params, num_raid_devs;
 	struct raid_set *rs = NULL;
-
-	/* Must have at least <raid_type> <#raid_params> */
-	if (argc < 2) {
-		ti->error = "Too few arguments";
+	const char *arg;
+	struct dm_arg_set as = { argc, argv }, as_nrd;
+	struct dm_arg _args[] = {
+		{ 0, as.argc, "Cannot understand number of raid parameters" },
+		{ 1, 254, "Cannot understand number of raid devices parameters" }
+	};
+
+	/* Must have <raid_type> */
+	arg = dm_shift_arg(&as);
+	if (!arg) {
+		ti->error = "No arguments";
 		return -EINVAL;
 	}
 
-	/* raid type */
-	rt = get_raid_type(argv[0]);
+	rt = get_raid_type(arg);
 	if (!rt) {
 		ti->error = "Unrecognised raid_type";
 		return -EINVAL;
 	}
-	argc--;
-	argv++;
-
-	/* number of RAID parameters */
-	if (kstrtoul(argv[0], 10, &num_raid_params) < 0) {
-		ti->error = "Cannot understand number of RAID parameters";
-		return -EINVAL;
-	}
-	argc--;
-	argv++;
 
-	/* Skip over RAID params for now and find out # of devices */
-	if (num_raid_params >= argc) {
-		ti->error = "Arguments do not agree with counts given";
-		return -EINVAL;
-	}
+	/* Must have <#raid_params> */
+	if (dm_read_arg_group(_args, &as, &num_raid_params, &ti->error))
+                return -EINVAL;
 
-	if ((kstrtoul(argv[num_raid_params], 10, &num_raid_devs) < 0) ||
-	    (num_raid_devs > MAX_RAID_DEVICES)) {
-		ti->error = "Cannot understand number of raid devices";
-		return -EINVAL;
-	}
+	/* number of raid device tupples <meta_dev data_dev> */
+	as_nrd = as;
+	dm_consume_args(&as_nrd, num_raid_params);
+	_args[1].max = (as_nrd.argc - 1) / 2;
+	if (dm_read_arg(_args + 1, &as_nrd, &num_raid_devs, &ti->error))
+                return -EINVAL;
 
-	argc -= num_raid_params + 1; /* +1: we already have num_raid_devs */
-	if (argc != (num_raid_devs * 2)) {
-		ti->error = "Supplied RAID devices does not match the count given";
-		return -EINVAL;
+	if (!_in_range(num_raid_devs, 1, MAX_RAID_DEVICES)) {
+		ti->error = "Invalid number of supplied raid devices";
+                return -EINVAL;
 	}
 
-	rs = context_alloc(ti, rt, (unsigned)num_raid_devs);
+	rs = context_alloc(ti, rt, num_raid_devs);
 	if (IS_ERR(rs))
 		return PTR_ERR(rs);
 
-	r = parse_raid_params(rs, argv, (unsigned)num_raid_params);
+	r = parse_raid_params(rs, &as, (unsigned)num_raid_params);
 	if (r)
 		goto bad;
 
-	argv += num_raid_params + 1;
-
-	r = dev_parms(rs, argv);
+	r = parse_dev_parms(rs, &as);
 	if (r)
 		goto bad;
 
-- 
2.5.5
