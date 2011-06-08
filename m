From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 2 of 7] DM RAID:  cleanups
Date: Wed, 08 Jun 2011 17:15:49 -0500
Message-ID: <1307571349.18638.5.camel@f14.redhat.com>
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

Clean-ups and minor fixes for dm-raid

Re-order the print flags so they are in the same order as the way they are later
defined, parsed, and printed.

Only print rebuild parameters if they were given on the CTR table line and tally
two params for the rebuild output - not one - in the STATUSTYPE_TABLE output.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c
+++ linux-2.6/drivers/md/dm-raid.c
@@ -43,13 +43,14 @@ struct raid_dev {
 /*
  * Flags for rs->print_flags field.
  */
-#define DMPF_DAEMON_SLEEP      0x1
-#define DMPF_MAX_WRITE_BEHIND  0x2
-#define DMPF_SYNC              0x4
-#define DMPF_NOSYNC            0x8
-#define DMPF_STRIPE_CACHE      0x10
-#define DMPF_MIN_RECOVERY_RATE 0x20
-#define DMPF_MAX_RECOVERY_RATE 0x40
+#define DMPF_SYNC              0x1
+#define DMPF_NOSYNC            0x2
+#define DMPF_REBUILD           0x4
+#define DMPF_DAEMON_SLEEP      0x8
+#define DMPF_MIN_RECOVERY_RATE 0x10
+#define DMPF_MAX_RECOVERY_RATE 0x20
+#define DMPF_MAX_WRITE_BEHIND  0x40
+#define DMPF_STRIPE_CACHE      0x80
 
 struct raid_set {
 	struct dm_target *ti;
@@ -311,6 +312,7 @@ static int parse_raid_params(struct raid
 			}
 			clear_bit(In_sync, &rs->dev[value].rdev.flags);
 			rs->dev[value].rdev.recovery_offset = 0;
+			rs->print_flags |= DMPF_REBUILD;
 		} else if (!strcmp(key, "max_write_behind")) {
 			rs->print_flags |= DMPF_MAX_WRITE_BEHIND;
 
@@ -547,9 +549,10 @@ static int raid_status(struct dm_target 
 	case STATUSTYPE_TABLE:
 		/* The string you would use to construct this array */
 		for (i = 0; i < rs->md.raid_disks; i++)
-			if (rs->dev[i].data_dev &&
+			if ((rs->print_flags & DMPF_REBUILD) &&
+			    rs->dev[i].data_dev &&
 			    !test_bit(In_sync, &rs->dev[i].rdev.flags))
-				raid_param_cnt++; /* for rebuilds */
+				raid_param_cnt += 2; /* for rebuilds */
 
 		raid_param_cnt += (hweight64(rs->print_flags) * 2);
 		if (rs->print_flags & (DMPF_SYNC | DMPF_NOSYNC))
@@ -565,7 +568,8 @@ static int raid_status(struct dm_target 
 			DMEMIT(" nosync");
 
 		for (i = 0; i < rs->md.raid_disks; i++)
-			if (rs->dev[i].data_dev &&
+			if ((rs->print_flags & DMPF_REBUILD) &&
+			    rs->dev[i].data_dev &&
 			    !test_bit(In_sync, &rs->dev[i].rdev.flags))
 				DMEMIT(" rebuild %u", i);
 
