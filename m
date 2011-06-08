From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 6 of 7] DM RAID:  add RAID1 support
Date: Wed, 08 Jun 2011 17:23:22 -0500
Message-ID: <1307571802.18638.15.camel@f14.redhat.com>
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
@@ -71,6 +72,7 @@ static struct raid_type {
 	const unsigned level;		/* RAID level. */
 	const unsigned algorithm;	/* RAID algorithm. */
 } raid_types[] = {
+	{"raid1",    "RAID1 (mirroring)",               0, 2, 1, 0 /* NONE */},
 	{"raid4",    "RAID4 (dedicated parity disk)",	1, 2, 5, ALGORITHM_PARITY_0},
 	{"raid5_la", "RAID5 (left asymmetric)",		1, 2, 5, ALGORITHM_LEFT_ASYMMETRIC},
 	{"raid5_ra", "RAID5 (right asymmetric)",	1, 2, 5, ALGORITHM_RIGHT_ASYMMETRIC},
@@ -104,7 +106,8 @@ static struct raid_set *context_alloc(st
 	}
 
 	sectors_per_dev = ti->len;
-	if (sector_div(sectors_per_dev, (raid_devs - raid_type->parity_devs))) {
+	if ((raid_type->level > 1) &&
+	    sector_div(sectors_per_dev, (raid_devs - raid_type->parity_devs))) {
 		ti->error = "Target length not divisible by number of data devices";
 		return ERR_PTR(-EINVAL);
 	}
@@ -325,13 +328,16 @@ static int validate_region_size(struct r
 
 /*
  * Possible arguments are...
- * RAID456:
  *	<chunk_size> [optional_args]
  *
- * Optional args:
- *    [[no]sync]			Force or prevent recovery of the entire array
+ * Argument definitions
+ *    <chunk_sectors>			The number of sectors per disk that
+ *                                      will form the "stripe"
+ *    [[no]sync]			Force or prevent recovery of the
+ *                                      entire array
  *    [rebuild <idx>]			Rebuild the drive indicated by the index
- *    [daemon_sleep <ms>]		Time between bitmap daemon work to clear bits
+ *    [daemon_sleep <ms>]		Time between bitmap daemon work to
+ *                                      clear bits
  *    [min_recovery_rate <kB/sec/disk>]	Throttle RAID initialization
  *    [max_recovery_rate <kB/sec/disk>]	Throttle RAID initialization
  *    [write_mostly <idx>]		Indicate a write mostly drive via index
@@ -348,13 +354,24 @@ static int parse_raid_params(struct raid
 
 	/*
 	 * First, parse the in-order required arguments
+	 * "chunk_sectors" is the only argument of this type
 	 */
-	if ((strict_strtoul(argv[0], 10, &value) < 0) ||
-	    !is_power_of_2(value) || (value < 8)) {
+	if ((strict_strtoul(argv[0], 10, &value) < 0)) {
 		rs->ti->error = "Bad chunk size";
 		return -EINVAL;
+	} else if (rs->raid_type->level == 1) {
+		if (value != 0)
+			DMERR("Ignoring chunk size parameter for RAID 1");
+		value = 0;
+	} else if (!is_power_of_2(value)) {
+		rs->ti->error = "Chunk size must be a power of 2";
+		return -EINVAL;
+	} else if (value < 8) {
+		rs->ti->error = "Chunk size value is too small";
+		return -EINVAL;
 	}
 
+
 	rs->md.new_chunk_sectors = rs->md.chunk_sectors = value;
 	argv++;
 	num_raid_params--;
@@ -504,6 +521,11 @@ static int parse_raid_params(struct raid
 	else
 		rs->ti->split_io = region_size;
 
+	if (rs->md.chunk_sectors)
+		rs->ti->split_io = rs->md.chunk_sectors;
+	else
+		rs->ti->split_io = region_size;
+
 	/* Assume there are no metadata devices until the drives are parsed */
 	rs->md.persistent = 0;
 	rs->md.external = 1;
@@ -522,6 +544,9 @@ static int raid_is_congested(struct dm_t
 {
 	struct raid_set *rs = container_of(cb, struct raid_set, callbacks);
 
+	if (rs->raid_type->level == 1)
+		return md_raid1_congested(&rs->md, bits);
+
 	return md_raid5_congested(&rs->md, bits);
 }
 
@@ -946,6 +971,7 @@ static int raid_ctr(struct dm_target *ti
 	rs->callbacks.congested_fn = raid_is_congested;
 	dm_table_add_target_callbacks(ti->table, &rs->callbacks);
 
+	mddev_suspend(&rs->md);
 	return 0;
 
 bad:
