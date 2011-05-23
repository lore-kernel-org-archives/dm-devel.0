From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] DM RAID:  do not print rebuilds in table line
Date: Mon, 23 May 2011 14:54:51 -0500
Message-ID: <201105231954.p4NJspjN019139@f14.redhat.com>
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

Patch name: dm-raid-do-not-print-rebuilds-in-table-line.patch

DM RAID table status should not include rebuild parameters.

When a DM RAID device is constructed, a user may supply a 'rebuild <idx>'
pair of parameters to indicate that they want a specific device in the
array rebuilt.  This action should clear the 'recovery_offset' for the
device so that any subsequent reloading of the device will pick up where
it left off.  The rebuild option is unnecessary and, in fact, unwanted
unless it is the intent to begin the rebuild process again.  Therefore,
we should never include the rebuild parameters when printing the DM
table via the status function.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c
+++ linux-2.6/drivers/md/dm-raid.c
@@ -672,14 +672,11 @@ static int raid_status(struct dm_target 
 		break;
 	case STATUSTYPE_TABLE:
 		/* The string you would use to construct this array */
-		for (i = 0; i < rs->md.raid_disks; i++) {
-			if (rs->dev[i].data_dev &&
-			    !test_bit(In_sync, &rs->dev[i].rdev.flags))
-				raid_param_cnt += 2; /* for rebuilds */
+		for (i = 0; i < rs->md.raid_disks; i++)
 			if (rs->dev[i].data_dev &&
 			    test_bit(WriteMostly, &rs->dev[i].rdev.flags))
 				raid_param_cnt += 2;
-		}
+
 		raid_param_cnt += (hweight64(rs->print_flags) * 2);
 		if (rs->print_flags & (DMPF_SYNC | DMPF_NOSYNC))
 			raid_param_cnt--;
@@ -692,14 +689,10 @@ static int raid_status(struct dm_target 
 			DMEMIT(" sync");
 		if (rs->print_flags & DMPF_NOSYNC)
 			DMEMIT(" nosync");
-		for (i = 0; i < rs->md.raid_disks; i++) {
-			if (rs->dev[i].data_dev &&
-			    !test_bit(In_sync, &rs->dev[i].rdev.flags))
-				DMEMIT(" rebuild %u", i);
+		for (i = 0; i < rs->md.raid_disks; i++)
 			if (rs->dev[i].data_dev &&
 			    test_bit(WriteMostly, &rs->dev[i].rdev.flags))
 				DMEMIT(" write_mostly %u", i);
-		}
 
 		if (rs->print_flags & DMPF_DAEMON_SLEEP)
 			DMEMIT(" daemon_sleep %lu",
