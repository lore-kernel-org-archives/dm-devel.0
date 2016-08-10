From: heinzm@redhat.com
Subject: [PATCH] dm raid: fix restoring of failed devices
	regression
Date: Wed, 10 Aug 2016 02:45:51 +0200
Message-ID: <1470789951-8006-1-git-send-email-heinzm@redhat.com>
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

'lvchange --refresh RaidLV' causes a mapped device suspend/resume cycle
aiming at device restore and resync after transient device failures.  This
failed because flag RT_FLAG_RS_RESUMED was always cleared in the suspend path,
thus the device restore wasn't performed in the resume path.

Solve by removing RT_FLAG_RS_RESUMED from the suspend path and resume
unconditionally.  Remove superfluous comment from raid_resume().

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 73bf535..b1c251872 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3382,11 +3382,10 @@ static void raid_postsuspend(struct dm_target *ti)
 {
 	struct raid_set *rs = ti->private;
 
-	if (test_and_clear_bit(RT_FLAG_RS_RESUMED, &rs->runtime_flags)) {
-		if (!rs->md.suspended)
-			mddev_suspend(&rs->md);
-		rs->md.ro = 1;
-	}
+	if (!rs->md.suspended)
+		mddev_suspend(&rs->md);
+
+	rs->md.ro = 1;
 }
 
 static void attempt_restore_of_faulty_devices(struct raid_set *rs)
@@ -3622,25 +3621,15 @@ static void raid_resume(struct dm_target *ti)
 		 * devices are reachable again.
 		 */
 		attempt_restore_of_faulty_devices(rs);
-	} else {
-		mddev->ro = 0;
-		mddev->in_sync = 0;
+	}
 
-		/*
-		 * When passing in flags to the ctr, we expect userspace
-		 * to reset them because they made it to the superblocks
-		 * and reload the mapping anyway.
-		 *
-		 * -> only unfreeze recovery in case of a table reload or
-		 *    we'll have a bogus recovery/reshape position
-		 *    retrieved from the superblock by the ctr because
-		 *    the ongoing recovery/reshape will change it after read.
-		 */
-		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+	mddev->ro = 0;
+	mddev->in_sync = 0;
 
-		if (mddev->suspended)
-			mddev_resume(mddev);
-	}
+	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+
+	if (mddev->suspended)
+		mddev_resume(mddev);
 }
 
 static struct target_type raid_target = {
-- 
2.7.4
