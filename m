From: heinzm@redhat.com
Subject: [PATCH 2/2] dm-raid: add 'no_discard_passdown' table
	argument
Date: Wed, 24 Sep 2014 16:12:58 +0200
Message-ID: <1411567978-16397-2-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Add the 'no_discard_passdown' table line argument to the target in order
to be able to prohibit discards from being passed down to the legs
of an array (this is in line with our other targets thin and cache).


This addresses:

o prohibit discards in case of _potential_ data corruptions in RAID4/5/6
  (i.e. discard_zeroes_data not processing properly when
   RAID4/5/6 relies on zeroed data)

o avoid discard processing overhead


Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>

---
 drivers/md/dm-raid.c | 73 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 44 insertions(+), 29 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 4edb2c7..a85d3cf 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -45,17 +45,18 @@ struct raid_dev {
 /*
  * Flags for rs->print_flags field.
  */
-#define DMPF_SYNC              0x1
-#define DMPF_NOSYNC            0x2
-#define DMPF_REBUILD           0x4
-#define DMPF_DAEMON_SLEEP      0x8
-#define DMPF_MIN_RECOVERY_RATE 0x10
-#define DMPF_MAX_RECOVERY_RATE 0x20
-#define DMPF_MAX_WRITE_BEHIND  0x40
-#define DMPF_STRIPE_CACHE      0x80
-#define DMPF_REGION_SIZE       0x100
-#define DMPF_RAID10_COPIES     0x200
-#define DMPF_RAID10_FORMAT     0x400
+#define DMPF_SYNC                0x1
+#define DMPF_NOSYNC              0x2
+#define DMPF_REBUILD             0x4
+#define DMPF_DAEMON_SLEEP        0x8
+#define DMPF_MIN_RECOVERY_RATE   0x10
+#define DMPF_MAX_RECOVERY_RATE   0x20
+#define DMPF_MAX_WRITE_BEHIND    0x40
+#define DMPF_STRIPE_CACHE        0x80
+#define DMPF_REGION_SIZE         0x100
+#define DMPF_RAID10_COPIES       0x200
+#define DMPF_RAID10_FORMAT       0x400
+#define DMPF_NO_DISCARD_PASSDOWN 0x800
 
 struct raid_set {
 	struct dm_target *ti;
@@ -475,6 +476,10 @@ too_many:
  *                                      will form the "stripe"
  *    [[no]sync]			Force or prevent recovery of the
  *                                      entire array
+ *    [no_discard_passdown]		Prohibit discard passdown to the legs of the array;
+ *                                      can be used in cases of bogus TRIM/UNMAP
+ *                                      support on array legs (e.g. discard_zeroes_data
+ *                                      flaw causing RAID4/5/6 corruption)
  *    [rebuild <idx>]			Rebuild the drive indicated by the index
  *    [daemon_sleep <ms>]		Time between bitmap daemon work to
  *                                      clear bits
@@ -559,6 +564,10 @@ static int parse_raid_params(struct raid_set *rs, char **argv,
 			rs->print_flags |= DMPF_SYNC;
 			continue;
 		}
+		if (!strcasecmp(argv[i], "no_discard_passdown")) {
+			rs->print_flags |= DMPF_NO_DISCARD_PASSDOWN;
+			continue;
+		}
 
 		/* The rest of the optional arguments come in key/value pairs */
 		if ((i + 1) >= num_raid_params) {
@@ -1157,33 +1166,37 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 static void raid_check_discard(struct dm_target *ti, struct raid_set *rs)
 {
 	int i;
-	bool discard_supported = true;
+	bool discard_supported, raid456;
+
+	/* Assume not supported until after checks below. */
+	ti->discards_supported = false;
+
+	/* Assume 'discard_supported = true' unless table argument 'no_discard_passdown' given */
+	discard_supported = !(rs->print_flags & DMPF_NO_DISCARD_PASSDOWN);
+	if (!discard_supported)
+		return;
+
 	/* RAID level 4,5,6 request discard_zeroes_data for data integrity! */
-	bool raid1_or_10 = rs->md.level == 1 || rs->md.level == 10;
-	bool zeroes_data_mandatory = !raid1_or_10;
+	raid456 = (rs->md.level == 5 || rs->md.level == 6 || rs->md.level == 4);
 
 	for (i = 0; i < rs->md.raid_disks; i++) {
 		struct request_queue *q = bdev_get_queue(rs->dev[i].rdev.bdev);
 
 		if (!q ||
 		    !blk_queue_discard(q) ||
-		    (zeroes_data_mandatory && !q->limits.discard_zeroes_data)) {
-			discard_supported = false;
-			break;
-		}
+		    (raid456 && !q->limits.discard_zeroes_data))
+			return;
 	}
 
-	if (discard_supported) {
-		ti->discards_supported = true;
-		/*
-		 * raid1 and raid10 personalities require bio splitting,
-		 * raid4/5/6 don't and process large discard bios properly.
-		 */
-		ti->split_discard_bios = raid1_or_10;
-		ti->num_discard_bios = 1;
+	/* Passed check on array legs -> enable discard */
+	ti->discards_supported = true;
 
-	} else
-		ti->discards_supported = false;
+	/*
+	 * RAID1 and RAID10 personalities require bio splitting,
+	 * RAID0/4/5/6 don't and process large discard bios properly
+	 */
+	ti->split_discard_bios = (rs->md.level == 1 || rs->md.level == 10);
+	ti->num_discard_bios = 1;
 }
 
 /*
@@ -1458,6 +1471,8 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 			DMEMIT(" sync");
 		if (rs->print_flags & DMPF_NOSYNC)
 			DMEMIT(" nosync");
+		if (rs->print_flags & DMPF_NO_DISCARD_PASSDOWN)
+			DMEMIT(" no_discard_passsown");
 
 		for (i = 0; i < rs->md.raid_disks; i++)
 			if ((rs->print_flags & DMPF_REBUILD) &&
@@ -1694,7 +1709,7 @@ static void raid_resume(struct dm_target *ti)
 
 static struct target_type raid_target = {
 	.name = "raid",
-	.version = {1, 5, 2},
+	.version = {1, 6, 0},
 	.module = THIS_MODULE,
 	.ctr = raid_ctr,
 	.dtr = raid_dtr,
-- 
1.9.3
