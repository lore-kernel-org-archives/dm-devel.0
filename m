From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 4 of 7] DM RAID:  add write_mostly param
Date: Wed, 08 Jun 2011 17:20:21 -0500
Message-ID: <1307571621.18638.10.camel@f14.redhat.com>
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

Add the write_mostly parameter to the dm-raid table constructor.

This allows the user to set the WriteMostly flag on a RAID1 device, so that
it is normally avoided where read I/O is concerned.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c
+++ linux-2.6/drivers/md/dm-raid.c
@@ -305,6 +305,7 @@ static int validate_region_size(struct r
  *    [daemon_sleep <ms>]		Time between bitmap daemon work to clear bits
  *    [min_recovery_rate <kB/sec/disk>]	Throttle RAID initialization
  *    [max_recovery_rate <kB/sec/disk>]	Throttle RAID initialization
+ *    [write_mostly <idx>]		Indicate a write mostly drive via index
  *    [max_write_behind <sectors>]	See '-write-behind=' (man mdadm)
  *    [stripe_cache <sectors>]		Stripe cache size for higher RAIDs
  *    [region_size <sectors>]           Defines granularity of bitmap
@@ -373,7 +374,21 @@ static int parse_raid_params(struct raid
 			clear_bit(In_sync, &rs->dev[value].rdev.flags);
 			rs->dev[value].rdev.recovery_offset = 0;
 			rs->print_flags |= DMPF_REBUILD;
+		} else if (!strcmp(key, "write_mostly")) {
+			if (rs->raid_type->level != 1) {
+				rs->ti->error = "write_mostly option is only valid for RAID1";
+				return -EINVAL;
+			}
+			if (value > rs->md.raid_disks) {
+				rs->ti->error = "Invalid write_mostly index given";
+				return -EINVAL;
+			}
+			set_bit(WriteMostly, &rs->dev[value].rdev.flags);
 		} else if (!strcmp(key, "max_write_behind")) {
+			if (rs->raid_type->level != 1) {
+				rs->ti->error = "max_write_behind option is only valid for RAID1";
+				return -EINVAL;
+			}
 			rs->print_flags |= DMPF_MAX_WRITE_BEHIND;
 
 			/*
@@ -618,11 +633,15 @@ static int raid_status(struct dm_target 
 		break;
 	case STATUSTYPE_TABLE:
 		/* The string you would use to construct this array */
-		for (i = 0; i < rs->md.raid_disks; i++)
+		for (i = 0; i < rs->md.raid_disks; i++) {
 			if ((rs->print_flags & DMPF_REBUILD) &&
 			    rs->dev[i].data_dev &&
 			    !test_bit(In_sync, &rs->dev[i].rdev.flags))
 				raid_param_cnt += 2; /* for rebuilds */
+			if (rs->dev[i].data_dev &&
+			    test_bit(WriteMostly, &rs->dev[i].rdev.flags))
+				raid_param_cnt += 2;
+		}
 
 		raid_param_cnt += (hweight64(rs->print_flags) * 2);
 		if (rs->print_flags & (DMPF_SYNC | DMPF_NOSYNC))
@@ -636,6 +655,7 @@ static int raid_status(struct dm_target 
 			DMEMIT(" sync");
 		if (rs->print_flags & DMPF_NOSYNC)
 			DMEMIT(" nosync");
+
 		for (i = 0; i < rs->md.raid_disks; i++)
 			if ((rs->print_flags & DMPF_REBUILD) &&
 			    rs->dev[i].data_dev &&
@@ -652,6 +672,11 @@ static int raid_status(struct dm_target 
 		if (rs->print_flags & DMPF_MAX_RECOVERY_RATE)
 			DMEMIT(" max_recovery_rate %d", rs->md.sync_speed_max);
 
+		for (i = 0; i < rs->md.raid_disks; i++)
+			if (rs->dev[i].data_dev &&
+			    test_bit(WriteMostly, &rs->dev[i].rdev.flags))
+				DMEMIT(" write_mostly %u", i);
+
 		if (rs->print_flags & DMPF_MAX_WRITE_BEHIND)
 			DMEMIT(" max_write_behind %lu",
 			       rs->md.bitmap_info.max_write_behind);
Index: linux-2.6/Documentation/device-mapper/dm-raid.txt
===================================================================
--- linux-2.6.orig/Documentation/device-mapper/dm-raid.txt
+++ linux-2.6/Documentation/device-mapper/dm-raid.txt
@@ -33,6 +33,7 @@ The possible parameters are as follows:
 			the bitmap.
  [min_recovery_rate <kB/sec/disk>]      Throttle RAID initialization
  [max_recovery_rate <kB/sec/disk>]      Throttle RAID initialization
+ [write_mostly <idx>]			Indicate a write mostly drive via index
  [max_write_behind <sectors>]           See '-write-behind=' (man mdadm)
  [stripe_cache <sectors>]               Stripe cache size for higher RAIDs
  [region_size <sectors>]	Array_size / region_size = # of regions.  A
@@ -66,9 +67,10 @@ Examples:
 Performing a 'dmsetup table' will display the CTR table used to construct the
 mapping.  The optional parameters will always be printed in the order listed
 above.  "sync" or "nosync" will always be printed before the other arguments,
-for example.  If the user passes in optional arguments in a different order,
-the results of 'dmsetup table' will differ from the CTR table used to construct
-the mapping.
+for example.  In the case of arguments which can be given more than once, they
+will be ordered according to their value - for write_mostly, by the given index.
+If the user passes in optional arguments in a different order, the results of
+'dmsetup table' will differ from the CTR table used to construct the mapping.
 
 Performing a 'dmsetup status' will yield information on the state and
 health of the array.  The output is as follows:
