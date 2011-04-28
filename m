From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] DM RAID:  add write_mostly param
Date: Thu, 28 Apr 2011 14:10:28 -0500
Message-ID: <201104281910.p3SJASjp029774@localhost6.localdomain6>
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

Patch name: dm-raid-add-write_mostly-param.patch

Add the write_mostly parameter to the dm-raid table constructor.

This allows the user to set the WriteMostly flag on a RAID1 device, so that
it is normally avoided where read I/O is concerned.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c
+++ linux-2.6/drivers/md/dm-raid.c
@@ -296,6 +296,7 @@ static int validate_region_size(struct r
  *    [daemon_sleep <ms>]		Time between bitmap daemon work to clear bits
  *    [min_recovery_rate <kB/sec/disk>]	Throttle RAID initialization
  *    [max_recovery_rate <kB/sec/disk>]	Throttle RAID initialization
+ *    [write_mostly <idx>]		Indicate a write mostly drive via index
  *    [max_write_behind <sectors>]	See '-write-behind=' (man mdadm)
  *    [stripe_cache <sectors>]		Stripe cache size for higher RAIDs
  *    [region_size <sectors>]           Defines granularity of bitmap
@@ -363,7 +364,21 @@ static int parse_raid_params(struct raid
 			}
 			clear_bit(In_sync, &rs->dev[value].rdev.flags);
 			rs->dev[value].rdev.recovery_offset = 0;
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
@@ -616,11 +631,14 @@ static int raid_status(struct dm_target 
 		break;
 	case STATUSTYPE_TABLE:
 		/* The string you would use to construct this array */
-		for (i = 0; i < rs->md.raid_disks; i++)
+		for (i = 0; i < rs->md.raid_disks; i++) {
 			if (rs->dev[i].data_dev &&
 			    !test_bit(In_sync, &rs->dev[i].rdev.flags))
-				raid_param_cnt++; /* for rebuilds */
-
+				raid_param_cnt += 2; /* for rebuilds */
+			if (rs->dev[i].data_dev &&
+			    test_bit(WriteMostly, &rs->dev[i].rdev.flags))
+				raid_param_cnt += 2;
+		}
 		raid_param_cnt += (hweight64(rs->print_flags) * 2);
 		if (rs->print_flags & (DMPF_SYNC | DMPF_NOSYNC))
 			raid_param_cnt--;
@@ -633,10 +651,14 @@ static int raid_status(struct dm_target 
 			DMEMIT(" sync");
 		if (rs->print_flags & DMPF_NOSYNC)
 			DMEMIT(" nosync");
-		for (i = 0; i < rs->md.raid_disks; i++)
+		for (i = 0; i < rs->md.raid_disks; i++) {
 			if (rs->dev[i].data_dev &&
 			    !test_bit(In_sync, &rs->dev[i].rdev.flags))
 				DMEMIT(" rebuild %u", i);
+			if (rs->dev[i].data_dev &&
+			    test_bit(WriteMostly, &rs->dev[i].rdev.flags))
+				DMEMIT(" write_mostly %u", i);
+		}
 
 		if (rs->print_flags & DMPF_DAEMON_SLEEP)
 			DMEMIT(" daemon_sleep %lu",
