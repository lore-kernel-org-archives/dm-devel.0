From: heinzm@redhat.com
Subject: [PATCH 3/3] dm-raid: change 'no_discard_passdown' table
	line argument to 'ignore_discard'
Date: Wed, 24 Sep 2014 17:14:10 +0200
Message-ID: <1411571650-18702-3-git-send-email-heinzm@redhat.com>
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

The 'no_discard_passdown' table line argument introduced with [PATCH 2/3] of this
patch series may lead to the false assumption, that dm-raid might still process
discards internally for some reason.

Using 'ignore_discard' instead makes it clear, that dm-raid just completely
ignores discards, hence not passing them on to MD personalities.


Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>

---
 drivers/md/dm-raid.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index a85d3cf..b9614ae 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -45,18 +45,18 @@ struct raid_dev {
 /*
  * Flags for rs->print_flags field.
  */
-#define DMPF_SYNC                0x1
-#define DMPF_NOSYNC              0x2
-#define DMPF_REBUILD             0x4
-#define DMPF_DAEMON_SLEEP        0x8
-#define DMPF_MIN_RECOVERY_RATE   0x10
-#define DMPF_MAX_RECOVERY_RATE   0x20
-#define DMPF_MAX_WRITE_BEHIND    0x40
-#define DMPF_STRIPE_CACHE        0x80
-#define DMPF_REGION_SIZE         0x100
-#define DMPF_RAID10_COPIES       0x200
-#define DMPF_RAID10_FORMAT       0x400
-#define DMPF_NO_DISCARD_PASSDOWN 0x800
+#define DMPF_SYNC              0x1
+#define DMPF_NOSYNC            0x2
+#define DMPF_REBUILD           0x4
+#define DMPF_DAEMON_SLEEP      0x8
+#define DMPF_MIN_RECOVERY_RATE 0x10
+#define DMPF_MAX_RECOVERY_RATE 0x20
+#define DMPF_MAX_WRITE_BEHIND  0x40
+#define DMPF_STRIPE_CACHE      0x80
+#define DMPF_REGION_SIZE       0x100
+#define DMPF_RAID10_COPIES     0x200
+#define DMPF_RAID10_FORMAT     0x400
+#define DMPF_IGNORE_DISCARD    0x800
 
 struct raid_set {
 	struct dm_target *ti;
@@ -476,7 +476,7 @@ too_many:
  *                                      will form the "stripe"
  *    [[no]sync]			Force or prevent recovery of the
  *                                      entire array
- *    [no_discard_passdown]		Prohibit discard passdown to the legs of the array;
+ *    [ignore_discard]                  Ignore any discards;
  *                                      can be used in cases of bogus TRIM/UNMAP
  *                                      support on array legs (e.g. discard_zeroes_data
  *                                      flaw causing RAID4/5/6 corruption)
@@ -564,8 +564,8 @@ static int parse_raid_params(struct raid_set *rs, char **argv,
 			rs->print_flags |= DMPF_SYNC;
 			continue;
 		}
-		if (!strcasecmp(argv[i], "no_discard_passdown")) {
-			rs->print_flags |= DMPF_NO_DISCARD_PASSDOWN;
+		if (!strcasecmp(argv[i], "ignore_discard")) {
+			rs->print_flags |= DMPF_IGNORE_DISCARD;
 			continue;
 		}
 
@@ -1171,8 +1171,8 @@ static void raid_check_discard(struct dm_target *ti, struct raid_set *rs)
 	/* Assume not supported until after checks below. */
 	ti->discards_supported = false;
 
-	/* Assume 'discard_supported = true' unless table argument 'no_discard_passdown' given */
-	discard_supported = !(rs->print_flags & DMPF_NO_DISCARD_PASSDOWN);
+	/* Assume 'discard_supported = true' unless table argument 'ignore_discard' given */
+	discard_supported = !(rs->print_flags & DMPF_IGNORE_DISCARD);
 	if (!discard_supported)
 		return;
 
@@ -1471,8 +1471,8 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 			DMEMIT(" sync");
 		if (rs->print_flags & DMPF_NOSYNC)
 			DMEMIT(" nosync");
-		if (rs->print_flags & DMPF_NO_DISCARD_PASSDOWN)
-			DMEMIT(" no_discard_passsown");
+		if (rs->print_flags & DMPF_IGNORE_DISCARD)
+			DMEMIT(" ignore_discard");
 
 		for (i = 0; i < rs->md.raid_disks; i++)
 			if ((rs->print_flags & DMPF_REBUILD) &&
-- 
1.9.3
