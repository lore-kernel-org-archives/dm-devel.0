From: heinzm@redhat.com
Subject: [PATCH 03/10] dm raid: fix deadlock caused by stopped
	writes
Date: Fri,  1 Dec 2017 01:02:21 +0100
Message-ID: <20171201000228.32677-4-heinzm@redhat.com>
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
Cc: heinzm@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

md_stop_writes() is called in presuspend causing deadlocks on
bios submitted afterwards which happens on loaded raid sets
with conversion requests.

Fix by moving md_stop_writes to postsuspend.
Hence the raid set is quiesced remove superfluous
readonly setting too.

Adjust target version to be able to recognize the fix.

Related: rhbz1448116
---
 Documentation/device-mapper/dm-raid.txt |  3 ++-
 drivers/md/dm-raid.c                    | 20 +++++++++-----------
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/Documentation/device-mapper/dm-raid.txt b/Documentation/device-mapper/dm-raid.txt
index 32df07e29f68..4d260fedcd8b 100644
--- a/Documentation/device-mapper/dm-raid.txt
+++ b/Documentation/device-mapper/dm-raid.txt
@@ -343,5 +343,6 @@ Version History
 1.11.0  Fix table line argument order
 	(wrong raid10_copies/raid10_format sequence)
 1.11.1  Add raid4/5/6 journal write-back support via journal_mode option
-1.12.1  fix for MD deadlock between mddev_suspend() and md_write_start() available
+1.12.1  Fix for MD deadlock between mddev_suspend() and md_write_start() available
 1.13.0  Fix dev_health status at end of "recover" (was 'a', now 'A')
+1.13.1  Fix deadlock caused by early md_stop_writes()
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 3dcaceb13811..ec28a6cf1bf8 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3649,24 +3649,23 @@ static void raid_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	blk_limits_io_opt(limits, chunk_size * mddev_data_stripes(rs));
 }
 
-static void raid_presuspend(struct dm_target *ti)
-{
-	struct raid_set *rs = ti->private;
-
-	md_stop_writes(&rs->md);
-}
-
 static void raid_postsuspend(struct dm_target *ti)
 {
 	struct raid_set *rs = ti->private;
 
 	if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
+		/*
+		 * Writes have to be stopped before suspending to avoid deadlocks.
+		 *
+		 * https://bugzilla.redhat.com/show_bug.cgi?id=1514539
+		 */
+		if (!test_bit(MD_RECOVERY_FROZEN, &rs->md.recovery))
+			md_stop_writes(&rs->md);
+
 		mddev_lock_nointr(&rs->md);
 		mddev_suspend(&rs->md);
 		mddev_unlock(&rs->md);
 	}
-
-	rs->md.ro = 1;
 }
 
 static void attempt_restore_of_faulty_devices(struct raid_set *rs)
@@ -3930,7 +3929,7 @@ static void raid_resume(struct dm_target *ti)
 
 static struct target_type raid_target = {
 	.name = "raid",
-	.version = {1, 13, 0},
+	.version = {1, 13, 1},
 	.module = THIS_MODULE,
 	.ctr = raid_ctr,
 	.dtr = raid_dtr,
@@ -3939,7 +3938,6 @@ static struct target_type raid_target = {
 	.message = raid_message,
 	.iterate_devices = raid_iterate_devices,
 	.io_hints = raid_io_hints,
-	.presuspend = raid_presuspend,
 	.postsuspend = raid_postsuspend,
 	.preresume = raid_preresume,
 	.resume = raid_resume,
-- 
2.13.6
