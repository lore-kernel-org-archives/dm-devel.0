From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] DM RAID:  Add support for MD RAID10 personality
Date: Tue, 26 Jun 2012 07:03:51 -0500
Message-ID: <1340712231.19015.42.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org
Cc: jbrassow@redhat.com, agk@redhat.com, neilb@suse.de
List-Id: dm-devel.ids

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
@@ -52,7 +53,11 @@ struct raid_dev {
 #define DMPF_MAX_RECOVERY_RATE 0x20
 #define DMPF_MAX_WRITE_BEHIND  0x40
 #define DMPF_STRIPE_CACHE      0x80
-#define DMPF_REGION_SIZE       0X100
+#define DMPF_REGION_SIZE       0x100
+#define DMPF_RAID10_NEAR_COPIES 0x200
+#define DMPF_RAID10_FAR_COPIES  0x400
+#define DMPF_RAID10_FAR_OFFSET  0x800
+
 struct raid_set {
 	struct dm_target *ti;
 
@@ -66,6 +71,15 @@ struct raid_set {
 	struct raid_dev dev[0];
 };
 
+/* near_copies in first byte */
+/* far_copies in second byte */
+/* far_offset in 17th bit */
+#define ALGORITHM_RAID10(near_copies, far_copies, far_offset) \
+	((near_copies & 0xFF) | ((far_copies & 0xFF) << 8) | ((!!far_offset) << 16))
+#define RAID10_NC(layout) (layout & 0xFF)
+#define RAID10_FC(layout) ((layout >> 8) & 0xFF)
+#define RAID10_FO(layout) (layout & 0x10000)
+
 /* Supported raid types and properties. */
 static struct raid_type {
 	const char *name;		/* RAID algorithm. */
@@ -76,6 +90,8 @@ static struct raid_type {
 	const unsigned algorithm;	/* RAID algorithm. */
 } raid_types[] = {
 	{"raid1",    "RAID1 (mirroring)",               0, 2, 1, 0 /* NONE */},
+	{"raid10",   "RAID10 (striped mirrors)",        0, 2, 10, -1 /* Varies */},
+	{"raid1e",   "RAID1E (Enhanced RAID1)",         0, 2, 10, -1 /* Varies */},
 	{"raid4",    "RAID4 (dedicated parity disk)",	1, 2, 5, ALGORITHM_PARITY_0},
 	{"raid5_la", "RAID5 (left asymmetric)",		1, 2, 5, ALGORITHM_LEFT_ASYMMETRIC},
 	{"raid5_ra", "RAID5 (right asymmetric)",	1, 2, 5, ALGORITHM_RIGHT_ASYMMETRIC},
@@ -339,10 +355,17 @@ static int validate_region_size(struct r
  *    [max_write_behind <sectors>]	See '-write-behind=' (man mdadm)
  *    [stripe_cache <sectors>]		Stripe cache size for higher RAIDs
  *    [region_size <sectors>]           Defines granularity of bitmap
+ *
+ * RAID10-only options:
+ *    [raid10_near_copies   <# copies>] Near copies. (Default: 2)
+ *    [raid10_far_copies    <# copies>] Far copies.  (Default: 1)
+ *    [raid10_far_offset    <0/1>]      Offset is device size(0) or stripe(1).
  */
 static int parse_raid_params(struct raid_set *rs, char **argv,
 			     unsigned num_raid_params)
 {
+	unsigned raid10_default = ALGORITHM_RAID10(2, 1, 0);
+	unsigned raid10_nc = 1, raid10_fc = 1, raid10_fo = 0;
 	unsigned i, rebuild_cnt = 0;
 	unsigned long value, region_size = 0;
 	sector_t sectors_per_dev = rs->ti->len;
@@ -435,6 +458,7 @@ static int parse_raid_params(struct raid
 				if (rebuild_cnt > rs->raid_type->parity_devs)
 					rs->ti->error = "Too many rebuild devices specified for given RAID type";
 				break;
+			case 10:
 			default:
 				DMERR("The rebuild parameter is not supported for %s", rs->raid_type->name);
 				rs->ti->error = "Rebuild not supported for this RAID type";
@@ -492,7 +516,7 @@ static int parse_raid_params(struct raid
 			 */
 			value /= 2;
 
-			if (rs->raid_type->level < 5) {
+			if (rs->raid_type->level != 5) {
 				rs->ti->error = "Inappropriate argument: stripe_cache";
 				return -EINVAL;
 			}
@@ -517,6 +541,33 @@ static int parse_raid_params(struct raid
 		} else if (!strcasecmp(key, "region_size")) {
 			rs->print_flags |= DMPF_REGION_SIZE;
 			region_size = value;
+		} else if (!strcasecmp(key, "raid10_near_copies") &&
+			   (rs->raid_type->level == 10)) {
+			if ((value < 1) || (value > 0xFF)) {
+				rs->ti->error = "Bad value for 'raid10_near_copies'";
+				return -EINVAL;
+			}
+			rs->print_flags |= DMPF_RAID10_NEAR_COPIES;
+			raid10_nc = value;
+			raid10_default = 0;
+		} else if (!strcasecmp(key, "raid10_far_copies") &&
+			   (rs->raid_type->level == 10)) {
+			if ((value < 1) || (value > 0xFF)) {
+				rs->ti->error = "Bad value for 'raid10_far_copies'";
+				return -EINVAL;
+			}
+			rs->print_flags |= DMPF_RAID10_FAR_COPIES;
+			raid10_fc = value;
+			raid10_default = 0;
+		} else if (!strcasecmp(key, "raid10_far_offset") &&
+			   (rs->raid_type->level == 10)) {
+			if (value > 1) {
+				rs->ti->error = "Bad value for 'raid10_far_offset'";
+				return -EINVAL;
+			}
+			rs->print_flags |= DMPF_RAID10_FAR_OFFSET;
+			raid10_fo = value;
+			raid10_default = 0;
 		} else {
 			DMERR("Unable to parse RAID parameter: %s", key);
 			rs->ti->error = "Unable to parse RAID parameters";
@@ -532,9 +583,33 @@ static int parse_raid_params(struct raid
 	else
 		rs->ti->split_io = region_size;
 
-	if ((rs->raid_type->level > 1) &&
-	    sector_div(sectors_per_dev, (rs->md.raid_disks - rs->raid_type->parity_devs))) {
+	if (rs->raid_type->level == 10) {
+		/* (Len * Stripes) / Mirrors */
+		sectors_per_dev *= rs->md.raid_disks;
+		if (sector_div(sectors_per_dev, (raid10_nc * raid10_fc))) {
+			rs->ti->error = "Target length not divisible by number of data devices";
+			return -EINVAL;
+		}
+		if ((raid10_nc * raid10_fc) > rs->md.raid_disks) {
+			rs->ti->error = "Not enough devices to satisfy specification";
+			return -EINVAL;
+		}
+		if (raid10_fo && (raid10_fc < 2)) {
+			DMWARN("RAID10 parameter 'far_offset' ignored");
+			raid10_fo = 0;
+		}
+
+		if (raid10_default)
+			rs->md.layout = raid10_default;
+		else
+			rs->md.layout = ALGORITHM_RAID10(raid10_nc,
+							 raid10_fc, raid10_fo);
+		rs->md.new_layout = rs->md.layout;
+	} else if ((rs->raid_type->level > 1) &&
+		   sector_div(sectors_per_dev,
+			      (rs->md.raid_disks - rs->raid_type->parity_devs))) {
 		rs->ti->error = "Target length not divisible by number of data devices";
+
 		return -EINVAL;
 	}
 	rs->md.dev_sectors = sectors_per_dev;
@@ -560,6 +635,9 @@ static int raid_is_congested(struct dm_t
 	if (rs->raid_type->level == 1)
 		return md_raid1_congested(&rs->md, bits);
 
+	if (rs->raid_type->level == 10)
+		return md_raid10_congested(&rs->md, bits);
+
 	return md_raid5_congested(&rs->md, bits);
 }
 
@@ -878,6 +956,9 @@ static int analyse_superblocks(struct dm
 	case 6:
 		redundancy = rs->raid_type->parity_devs;
 		break;
+	case 10:
+		redundancy = RAID10_NC(mddev->layout) *	RAID10_FC(mddev->layout);
+		break;
 	default:
 		ti->error = "Unknown RAID type";
 		return -EINVAL;
@@ -1197,6 +1278,18 @@ static int raid_status(struct dm_target
 			DMEMIT(" region_size %lu",
 			       rs->md.bitmap_info.chunksize >> 9);
 
+		if (rs->print_flags & DMPF_RAID10_NEAR_COPIES)
+			DMEMIT(" raid10_near_copies %u",
+			       RAID10_NC(rs->md.layout));
+
+		if (rs->print_flags & DMPF_RAID10_FAR_COPIES)
+			DMEMIT(" raid10_far_copies %u",
+			       RAID10_FC(rs->md.layout));
+
+		if (rs->print_flags & DMPF_RAID10_FAR_OFFSET)
+			DMEMIT(" raid10_far_offset %u",
+			       RAID10_FO(rs->md.layout));
+
 		DMEMIT(" %d", rs->md.raid_disks);
 		for (i = 0; i < rs->md.raid_disks; i++) {
 			if (rs->dev[i].meta_dev)
@@ -1271,7 +1364,7 @@ static void raid_resume(struct dm_target
 
 static struct target_type raid_target = {
 	.name = "raid",
-	.version = {1, 2, 0},
+	.version = {1, 3, 0},
 	.module = THIS_MODULE,
 	.ctr = raid_ctr,
 	.dtr = raid_dtr,
@@ -1298,6 +1391,8 @@ module_init(dm_raid_init);
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
@@ -27,6 +27,11 @@ The target is named "raid" and it accept
 		- rotating parity N (right-to-left) with data restart
   raid6_nc	RAID6 N continue
 		- rotating parity N (right-to-left) with data continuation
+  raid10/raid1e Various RAID10 inspired algorithms chosen by additional params
+  		- RAID10: Striped Mirrors (aka 'Striping on top of mirrors')
+		- RAID1E: Integrated Adjacent Stripe Mirroring
+		- RAID1E: Integrated Offset Stripe Mirroring
+		-  and other similar RAID10 variants
 
   Reference: Chapter 4 of
   http://www.snia.org/sites/default/files/SNIA_DDF_Technical_Position_v2.0.pdf
@@ -59,6 +64,80 @@ The target is named "raid" and it accept
 		logical size of the array.  The bitmap records the device
 		synchronisation state for each region.
 
+        [raid10_near_copies   <# copies>]
+        [raid10_far_copies    <# copies>]
+        [raid10_far_offset    <0/1>]
+		These three options are used to alter the default layout of
+		a RAID10/RAID1E configuration.  The total number of copies is
+		given by the number of "near" (aka "adjacent") copies times
+		the number of "far" (aka "offset") copies.  Near copies
+		are what most people think of with respect to mirroring.
+		If 'raid10_near_copies 2', 'raid10_far_copies 1' and
+		'raid10_far_offset 0', then the layouts for 2, 3 and 4 devices
+		are:
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
+		The 'raid10_far_[copies|offset]' arguments work together to
+		determine where any "far"/"offset" copies will be placed.
+		If 'raid10_near_copies 1', 'raid10_far_copies 2' and
+		'raid10_far_offset 0', then the layouts for 2, 3 and 4 devices
+		are:
+		2 drives             3 drives             4 drives
+		--------             --------------       --------------------
+		A1  A2               A1   A2   A3         A1   A2   A3   A4
+		A3  A4               A4   A5   A6         A5   A6   A7   A8
+		A5  A6               A7   A8   A9         A9   A10  A11  A12
+		..  ..               ..   ..   ..         ..   ..   ..   ..
+		A2  A1               A3   A1   A2         A4   A1   A2   A3
+		A4  A3               A6   A4   A5         A8   A5   A6   A7
+		A6  A5               A9   A7   A8         A12  A9   A10  A11
+		..  ..               ..   ..   ..         ..   ..   ..   ..
+
+		If 'raid10_near_copies 1', 'raid10_far_copies 2' and
+		'raid10_far_offset 1', then the layouts for 2, 3 and 4 devices
+		are:
+		2 drives       3 drives           4 drives
+		--------       ------------       -----------------
+		A1  A2         A1  A2  A3         A1  A2  A3  A4
+		A2  A1         A3  A1  A2         A4  A1  A2  A3
+		A3  A4         A4  A5  A6         A5  A6  A7  A8
+		A4  A3         A6  A4  A5         A8  A5  A6  A7
+		A5  A6         A7  A8  A9         A9  A10 A11 A12
+		A6  A5         A9  A7  A8         A12 A9  A10 A11
+		..  ..         ..  ..  ..         ..  ..  ..  ..
+		Here we see layouts closely akin to 'RAID1E - Integrated
+		Offset Stripe Mirroring'.
+
+		Near and far copies can both be specified giving more
+		complex arrangements.  If 'raid10_near_copies 2',
+		'raid10_far_copies 2' and 'raid10_far_offset 0', then the
+		layouts for 4 and 5 devices are:
+		4 drives              5 drives
+		--------              --------
+		A1  A1  A2  A2        A1  A1  A2  A2  A3
+		A3  A3  A4  A4        A3  A4  A4  A5  A5
+		A5  A5  A6  A6        A6  A6  A7  A7  A8
+		A7  A7  A8  A8        A8  A9  A9  A10 A10
+		..  ..  ..  ..        ..  ..  ..  ..  ..
+		A2  A2  A1  A1        A2  A3  A1  A1  A2
+		A4  A4  A3  A3        A5  A5  A3  A4  A4
+		A6  A6  A5  A5        A7  A8  A6  A6  A7
+		A8  A8  A7  A7        A10 A10 A8  A9  A9
+		..  ..  ..  ..        ..  ..  ..  ..  ..
+		Thanks wikipedia 'Non-standard RAID levels' for the layout
+		figures:
+		http://en.wikipedia.org/wiki/Non-standard_RAID_levels
+
 <#raid_devs>: The number of devices composing the array.
 	Each device consists of two entries.  The first is the device
 	containing the metadata (if any); the second is the one containing the


