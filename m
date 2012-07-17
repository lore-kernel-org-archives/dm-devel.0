From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH v3] DM RAID: Add support for MD RAID10
Date: Tue, 17 Jul 2012 15:43:02 -0500
Message-ID: <1342557782.31336.3.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org
Cc: agk@redhat.com, neilb@suse.de
List-Id: dm-devel.ids

Neil,

I've pulled out the 'far' and 'offset' format options for now.  Also
note that I haven't changed the 'sectors_per_dev' (aka
mddev->dev_sectors) calculations...

 brassow

dm raid: add md raid10 support

Support the MD RAID10 personality through dm-raid.c

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -11,6 +11,7 @@
 #include "md.h"
 #include "raid1.h"
 #include "raid5.h"
+#include "raid10.h"
 #include "bitmap.h"
 
 #include <linux/device-mapper.h>
@@ -52,7 +53,10 @@ struct raid_dev {
 #define DMPF_MAX_RECOVERY_RATE 0x20
 #define DMPF_MAX_WRITE_BEHIND  0x40
 #define DMPF_STRIPE_CACHE      0x80
-#define DMPF_REGION_SIZE       0X100
+#define DMPF_REGION_SIZE       0x100
+#define DMPF_RAID10_COPIES     0x200
+#define DMPF_RAID10_FORMAT     0x400
+
 struct raid_set {
 	struct dm_target *ti;
 
@@ -76,6 +80,7 @@ static struct raid_type {
 	const unsigned algorithm;	/* RAID algorithm. */
 } raid_types[] = {
 	{"raid1",    "RAID1 (mirroring)",               0, 2, 1, 0 /* NONE */},
+	{"raid10",   "RAID10 (striped mirrors)",        0, 2, 10, UINT_MAX /* Varies */},
 	{"raid4",    "RAID4 (dedicated parity disk)",	1, 2, 5, ALGORITHM_PARITY_0},
 	{"raid5_la", "RAID5 (left asymmetric)",		1, 2, 5, ALGORITHM_LEFT_ASYMMETRIC},
 	{"raid5_ra", "RAID5 (right asymmetric)",	1, 2, 5, ALGORITHM_RIGHT_ASYMMETRIC},
@@ -86,6 +91,17 @@ static struct raid_type {
 	{"raid6_nc", "RAID6 (N continue)",		2, 4, 6, ALGORITHM_ROTATING_N_CONTINUE}
 };
 
+static unsigned raid10_md_layout_to_copies(int layout)
+{
+	return layout & 0xFF;
+}
+
+static int raid10_format_to_md_layout(char *format, unsigned copies)
+{
+	/* 1 "far" copy, and 'copies' "near" copies */
+	return (1 << 8) | (copies & 0xFF);
+}
+
 static struct raid_type *get_raid_type(char *name)
 {
 	int i;
@@ -339,10 +355,16 @@ static int validate_region_size(struct r
  *    [max_write_behind <sectors>]	See '-write-behind=' (man mdadm)
  *    [stripe_cache <sectors>]		Stripe cache size for higher RAIDs
  *    [region_size <sectors>]           Defines granularity of bitmap
+ *
+ * RAID10-only options:
+ *    [raid10_copies <# copies>]        Number of copies.  (Default: 2)
+ *    [raid10_format <near>]            Layout algorithm.  (Default: near)
  */
 static int parse_raid_params(struct raid_set *rs, char **argv,
 			     unsigned num_raid_params)
 {
+	char *raid10_format = "near";
+	unsigned raid10_copies = 2;
 	unsigned i, rebuild_cnt = 0;
 	unsigned long value, region_size = 0;
 	sector_t sectors_per_dev = rs->ti->len;
@@ -416,11 +438,28 @@ static int parse_raid_params(struct raid
 		}
 
 		key = argv[i++];
+
+		/* Parameters that take a string value are checked here. */
+		if (!strcasecmp(key, "raid10_format")) {
+			if (rs->raid_type->level != 10) {
+				rs->ti->error = "'raid10_format' is an invalid parameter for this RAID type";
+				return -EINVAL;
+			}
+			if (strcmp("near", argv[i])) {
+				rs->ti->error = "Invalid 'raid10_format' value given";
+				return -EINVAL;
+			}
+			raid10_format = argv[i];
+			rs->print_flags |= DMPF_RAID10_FORMAT;
+			continue;
+		}
+
 		if (strict_strtoul(argv[i], 10, &value) < 0) {
 			rs->ti->error = "Bad numerical argument given in raid params";
 			return -EINVAL;
 		}
 
+		/* Parameters that take a numeric value are checked here */
 		if (!strcasecmp(key, "rebuild")) {
 			rebuild_cnt++;
 			rs->ti->error = NULL;
@@ -436,6 +475,7 @@ static int parse_raid_params(struct raid
 				if (rebuild_cnt > rs->raid_type->parity_devs)
 					rs->ti->error = "Too many rebuild devices specified for given RAID type";
 				break;
+			case 10:
 			default:
 				DMERR("The rebuild parameter is not supported for %s", rs->raid_type->name);
 				rs->ti->error = "Rebuild not supported for this RAID type";
@@ -493,7 +533,8 @@ static int parse_raid_params(struct raid
 			 */
 			value /= 2;
 
-			if (rs->raid_type->level < 5) {
+			if ((rs->raid_type->level != 5) &&
+			    (rs->raid_type->level != 6)) {
 				rs->ti->error = "Inappropriate argument: stripe_cache";
 				return -EINVAL;
 			}
@@ -518,6 +559,14 @@ static int parse_raid_params(struct raid
 		} else if (!strcasecmp(key, "region_size")) {
 			rs->print_flags |= DMPF_REGION_SIZE;
 			region_size = value;
+		} else if (!strcasecmp(key, "raid10_copies") &&
+			   (rs->raid_type->level == 10)) {
+			if ((value < 2) || (value > 0xFF)) {
+				rs->ti->error = "Bad value for 'raid10_copies'";
+				return -EINVAL;
+			}
+			rs->print_flags |= DMPF_RAID10_COPIES;
+			raid10_copies = value;
 		} else {
 			DMERR("Unable to parse RAID parameter: %s", key);
 			rs->ti->error = "Unable to parse RAID parameters";
@@ -536,9 +585,25 @@ static int parse_raid_params(struct raid
 	if (dm_set_target_max_io_len(rs->ti, max_io_len))
 		return -EINVAL;
 
-	if ((rs->raid_type->level > 1) &&
-	    sector_div(sectors_per_dev, (rs->md.raid_disks - rs->raid_type->parity_devs))) {
+	if (rs->raid_type->level == 10) {
+		/* (Len * Stripes) / Mirrors */
+		sectors_per_dev *= rs->md.raid_disks;
+		if (sector_div(sectors_per_dev, raid10_copies)) {
+			rs->ti->error = "Target length not divisible by number of data devices";
+			return -EINVAL;
+		}
+		if (raid10_copies > rs->md.raid_disks) {
+			rs->ti->error = "Not enough devices to satisfy specification";
+			return -EINVAL;
+		}
+		rs->md.layout = raid10_format_to_md_layout(raid10_format,
+							   raid10_copies);
+		rs->md.new_layout = rs->md.layout;
+	} else if ((rs->raid_type->level > 1) &&
+		   sector_div(sectors_per_dev,
+			      (rs->md.raid_disks - rs->raid_type->parity_devs))) {
 		rs->ti->error = "Target length not divisible by number of data devices";
+
 		return -EINVAL;
 	}
 	rs->md.dev_sectors = sectors_per_dev;
@@ -564,6 +629,9 @@ static int raid_is_congested(struct dm_t
 	if (rs->raid_type->level == 1)
 		return md_raid1_congested(&rs->md, bits);
 
+	if (rs->raid_type->level == 10)
+		return md_raid10_congested(&rs->md, bits);
+
 	return md_raid5_congested(&rs->md, bits);
 }
 
@@ -882,6 +950,9 @@ static int analyse_superblocks(struct dm
 	case 6:
 		redundancy = rs->raid_type->parity_devs;
 		break;
+	case 10:
+		redundancy = raid10_md_layout_to_copies(mddev->layout) - 1;
+		break;
 	default:
 		ti->error = "Unknown RAID type";
 		return -EINVAL;
@@ -1201,6 +1272,13 @@ static int raid_status(struct dm_target
 			DMEMIT(" region_size %lu",
 			       rs->md.bitmap_info.chunksize >> 9);
 
+		if (rs->print_flags & DMPF_RAID10_COPIES)
+			DMEMIT(" raid10_copies %u",
+			       raid10_md_layout_to_copies(rs->md.layout));
+
+		if (rs->print_flags & DMPF_RAID10_FORMAT)
+			DMEMIT(" raid10_format near");
+
 		DMEMIT(" %d", rs->md.raid_disks);
 		for (i = 0; i < rs->md.raid_disks; i++) {
 			if (rs->dev[i].meta_dev)
@@ -1275,7 +1353,7 @@ static void raid_resume(struct dm_target
 
 static struct target_type raid_target = {
 	.name = "raid",
-	.version = {1, 2, 0},
+	.version = {1, 3, 0},
 	.module = THIS_MODULE,
 	.ctr = raid_ctr,
 	.dtr = raid_dtr,
@@ -1302,6 +1380,8 @@ module_init(dm_raid_init);
 module_exit(dm_raid_exit);
 
 MODULE_DESCRIPTION(DM_NAME " raid4/5/6 target");
+MODULE_ALIAS("dm-raid1");
+MODULE_ALIAS("dm-raid10");
 MODULE_ALIAS("dm-raid4");
 MODULE_ALIAS("dm-raid5");
 MODULE_ALIAS("dm-raid6");
Index: linux-upstream/Documentation/device-mapper/dm-raid.txt
===================================================================
--- linux-upstream.orig/Documentation/device-mapper/dm-raid.txt
+++ linux-upstream/Documentation/device-mapper/dm-raid.txt
@@ -27,6 +27,10 @@ The target is named "raid" and it accept
 		- rotating parity N (right-to-left) with data restart
   raid6_nc	RAID6 N continue
 		- rotating parity N (right-to-left) with data continuation
+  raid10        Various RAID10 inspired algorithms chosen by additional params
+  		- RAID10: Striped Mirrors (aka 'Striping on top of mirrors')
+		- RAID1E: Integrated Adjacent Stripe Mirroring
+		-  and other similar RAID10 variants
 
   Reference: Chapter 4 of
   http://www.snia.org/sites/default/files/SNIA_DDF_Technical_Position_v2.0.pdf
@@ -59,6 +63,28 @@ The target is named "raid" and it accept
 		logical size of the array.  The bitmap records the device
 		synchronisation state for each region.
 
+        [raid10_copies   <# copies>]
+        [raid10_format   near]
+		These two options are used to alter the default layout of
+		a RAID10 configuration.  The number of copies is can be
+		specified, but the default is 2.  There are other variations
+		to how the copies are laid down - the default and only current
+		option is "near".  Near copies are what most people think of
+		with respect to mirroring.  If these options are left
+		unspecified, or 'raid10_copies 2' and/or 'raid10_format near'
+		are given, then the layouts for 2, 3 and 4 devices are:
+		2 drives         3 drives          4 drives
+		--------         ----------        --------------
+		A1  A1           A1  A1  A2        A1  A1  A2  A2
+		A2  A2           A2  A3  A3        A3  A3  A4  A4
+		A3  A3           A4  A4  A5        A5  A5  A6  A6
+		A4  A4           A5  A6  A6        A7  A7  A8  A8
+		..  ..           ..  ..  ..        ..  ..  ..  ..
+		The 2-device layout is equivalent 2-way RAID1.  The 4-device
+		layout is what a traditional RAID10 would look like.  The
+		3-device layout is what might be called a 'RAID1E - Integrated
+		Adjacent Stripe Mirroring'.
+
 <#raid_devs>: The number of devices composing the array.
 	Each device consists of two entries.  The first is the device
 	containing the metadata (if any); the second is the one containing the


