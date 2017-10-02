From: jbrassow@ovpn-117-28.phx2.redhat.com (Jonathan Brassow)
Subject: [PATCH 2 of 2] DM RAID: fix status dev_health reporting
Date: Mon,  2 Oct 2017 17:17:45 -0500 (CDT)
Message-ID: <20171002221745.6FDA31A472BD@ovpn-117-28.phx2.redhat.com>
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
To: -c@ovpn-117-28.phx2.redhat.com, dm-devel@redhat.com, heinzm@redhat.com
List-Id: dm-devel.ids

Patch name: dm-raid-fix-status-dev_health-reporting.patch

dm-raid:  Fix incorrect status output at the end of a "recover" process

There are three important fields that indicate the overall health and
status of an array: dev_heath, sync_ratio, and sync_action.  They tell
us the condition of the devices in the array, and the degree to which
the array is synchronized.

This patch fixes a condition that is reported incorrectly.  When a member
of the array is being rebuilt or a new device is added, the "recover"
process is used to synchronize it with the rest of the array.  When the
process is complete, but the sync thread hasn't yet been reaped, it is
possible for the state of MD to be:
mddev->
 recovery = [ MD_RECOVERY_RUNNING MD_RECOVERY_RECOVER MD_RECOVERY_DONE ]
 curr_resync_completed = <max dev size> (but not MaxSector)
and all rdevs to be In_sync.
This causes the 'array_in_sync' parameter to dm-raid.c:rs_get_progress
to be computed incorrectly and reported as '0' - or not in-sync.  This
in turn causes the dev_health characters to be reported as all 'a',
rather than the proper 'A'.

This above condition can cause erroneous output for several seconds; and
at a time when tools will want to be checking the condition due to events
that are raised at the end of a sync process.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -3331,7 +3331,9 @@ static sector_t rs_get_progress(struct r
 		else
 			r = mddev->recovery_cp;
 
-		if (r == MaxSector) {
+		if ((r == MaxSector) ||
+		    (test_bit(MD_RECOVERY_DONE, &mddev->recovery) &&
+		     (mddev->curr_resync_completed == resync_max_sectors))) {
 			/*
 			 * Sync complete.
 			 */
@@ -3891,7 +3893,7 @@ static void raid_resume(struct dm_target
 
 static struct target_type raid_target = {
 	.name = "raid",
-	.version = {1, 12, 1},
+	.version = {1, 13, 0},
 	.module = THIS_MODULE,
 	.ctr = raid_ctr,
 	.dtr = raid_dtr,
Index: linux-upstream/Documentation/device-mapper/dm-raid.txt
===================================================================
--- linux-upstream.orig/Documentation/device-mapper/dm-raid.txt
+++ linux-upstream/Documentation/device-mapper/dm-raid.txt
@@ -344,3 +344,4 @@ Version History
 	(wrong raid10_copies/raid10_format sequence)
 1.11.1  Add raid4/5/6 journal write-back support via journal_mode option
 1.12.1  fix for MD deadlock between mddev_suspend() and md_write_start() available
+1.13.0  Fix dev_health status at end of "recover" (was 'a', now 'A')
