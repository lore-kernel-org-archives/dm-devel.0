From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] DM RAID:  add RAID1 support
Date: Tue, 24 May 2011 14:31:34 -0500
Message-ID: <201105241931.p4OJVZWJ006336@localhost6.localdomain6>
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
List-Id: dm-devel.ids

Patch name: dm-raid-add-RAID1-support.patch

Add support to access the MD RAID1 personality through dm-raid.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c
+++ linux-2.6/drivers/md/dm-raid.c
@@ -8,6 +8,7 @@
 #include <linux/slab.h>
 
 #include "md.h"
+#include "raid1.h"
 #include "raid5.h"
 #include "dm.h"
 #include "bitmap.h"
@@ -73,6 +74,7 @@ static struct raid_type {
 	const unsigned level;		/* RAID level. */
 	const unsigned algorithm;	/* RAID algorithm. */
 } raid_types[] = {
+	{"raid1",    "RAID1 (mirroring)",               0, 2, 1, 0 /* NONE */},
 	{"raid4",    "RAID4 (dedicated parity disk)",	1, 2, 5, ALGORITHM_PARITY_0},
 	{"raid5_la", "RAID5 (left asymmetric)",		1, 2, 5, ALGORITHM_LEFT_ASYMMETRIC},
 	{"raid5_ra", "RAID5 (right asymmetric)",	1, 2, 5, ALGORITHM_RIGHT_ASYMMETRIC},
@@ -106,7 +108,8 @@ static struct raid_set *context_alloc(st
 	}
 
 	sectors_per_dev = ti->len;
-	if (sector_div(sectors_per_dev, (raid_devs - raid_type->parity_devs))) {
+	if ((raid_type->level > 1) &&
+	    sector_div(sectors_per_dev, (raid_devs - raid_type->parity_devs))) {
 		ti->error = "Target length not divisible by number of data devices";
 		return ERR_PTR(-EINVAL);
 	}
@@ -318,10 +321,14 @@ static int validate_region_size(struct r
 
 /*
  * Possible arguments are...
+ * RAID1:
+ *	[optional_args]
  * RAID456:
  *	<chunk_size> [optional_args]
  *
- * Optional args:
+ * Argument definitions
+ *    <chunk_sectors>         Specific to raid456, the number of sectors per
+ *                            disk that will form the "stripe"
  *    [[no]sync]			Force or prevent recovery of the entire array
  *    [rebuild <idx>]			Rebuild the drive indicated by the index
  *    [daemon_sleep <ms>]		Time between bitmap daemon work to clear bits
@@ -341,16 +348,20 @@ static int parse_raid_params(struct raid
 
 	/*
 	 * First, parse the in-order required arguments
+	 * "chunk_sectors" is the only argument of this type and
+	 * is only required by raid456
 	 */
-	if ((strict_strtoul(argv[0], 10, &value) < 0) ||
-	    !is_power_of_2(value) || (value < 8)) {
-		rs->ti->error = "Bad chunk size";
-		return -EINVAL;
-	}
+	if (rs->raid_type->level != 1) {
+		if ((strict_strtoul(argv[0], 10, &value) < 0) ||
+		    !is_power_of_2(value) || (value < 8)) {
+			rs->ti->error = "Bad chunk size";
+			return -EINVAL;
+		}
 
-	rs->md.new_chunk_sectors = rs->md.chunk_sectors = value;
-	argv++;
-	num_raid_params--;
+		rs->md.new_chunk_sectors = rs->md.chunk_sectors = value;
+		argv++;
+		num_raid_params--;
+	}
 
 	for (i = 0; i < rs->md.raid_disks; i++) {
 		/*
@@ -515,6 +526,11 @@ static int raid_is_congested(struct dm_t
 {
 	struct raid_set *rs = container_of(cb, struct raid_set, callbacks);
 
+#ifdef md_raid1_congested
+	if (rs->raid_type->level == 1)
+		return md_raid1_congested(&rs->md, bits);
+#endif
+
 	return md_raid5_congested(&rs->md, bits);
 }
 
@@ -549,6 +565,13 @@ static int raid_ctr(struct dm_target *ti
 	argc--;
 	argv++;
 
+#ifndef md_raid1_congested
+	if (rt->level == 1) {
+		ti->error = "RAID 1 is not yet supported";
+		return -EINVAL;
+	}
+#endif
+
 	/* number of RAID parameters */
 	if (strict_strtoul(argv[0], 10, &num_raid_params) < 0) {
 		ti->error = "Cannot understand number of RAID parameters";
@@ -608,6 +631,7 @@ static int raid_ctr(struct dm_target *ti
 	rs->callbacks.congested_fn = raid_is_congested;
 	dm_table_add_target_callbacks(ti->table, &rs->callbacks);
 
+	mddev_suspend(&rs->md);
 	return 0;
 
 bad:
@@ -681,8 +705,11 @@ static int raid_status(struct dm_target 
 		if (rs->print_flags & (DMPF_SYNC | DMPF_NOSYNC))
 			raid_param_cnt--;
 
-		DMEMIT("%s %u %u", rs->raid_type->name,
-		       raid_param_cnt, rs->md.chunk_sectors);
+		if (rs->raid_type->level != 1)
+			DMEMIT("%s %u %u", rs->raid_type->name,
+			       raid_param_cnt, rs->md.chunk_sectors);
+		else
+			DMEMIT("%s %u", rs->raid_type->name, raid_param_cnt - 1);
 
 		if ((rs->print_flags & DMPF_SYNC) &&
 		    (rs->md.recovery_cp == MaxSector))
