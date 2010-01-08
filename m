From: Takahiro Yasui <tyasui@redhat.com>
Subject: [PATCH][BUGFIX] dm-raid1: fix suspend stuck of failed
	device
Date: Fri, 08 Jan 2010 15:08:55 -0500
Message-ID: <4B4790D7.7000800@redhat.com>
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

When a dm-mirror device of which error recovery failed is going to
suspend, suspend process could stuck at acquireing semaphore. This
is a call trace when it happened.

dmsetup       D 01b014fa     0  2446   6087 0x00000000
 f5c2bcb0 00000086 c03a9807 01b014fa 0f87fd46 00000c81 f48ad780 f48ada00
 c2c084a0 00000000 c06944a0 c024aa17 00cd3503 ffffffff f5c2bcb4 c023211e
 00000000 00000000 000003ff f5f946b4 7fffffff 7fffffff f5c2bcfc c049554e
Call Trace:
 [<c049554e>] schedule_timeout+0x17/0x1a5
 [<c0496062>] __down+0x4a/0x6b
 [<c024aa9f>] down+0x22/0x2f
 [<f807919b>] dm_rh_stop_recovery+0x14/0x1d [dm_region_hash]
 [<f84c4c92>] mirror_presuspend+0x44/0x12f [dm_mirror]
 [<f84af571>] suspend_targets+0x2d/0x3b [dm_mod]
 [<f84af58d>] dm_table_presuspend_targets+0xe/0x10 [dm_mod]
 [<f84aee56>] dm_suspend+0x4d/0x150 [dm_mod]
 [<f84b1fe9>] dev_suspend+0x55/0x18a [dm_mod]
 [<f84b29f3>] dm_ctl_ioctl+0x303/0x344 [dm_mod]
 [<c02c3c4b>] vfs_ioctl+0x22/0x85
 [<c02c422c>] do_vfs_ioctl+0x4cb/0x516
 [<c02c42b7>] sys_ioctl+0x40/0x5a
 [<c0202858>] sysenter_do_call+0x12/0x28

When an error recovery processes a region with a positive pending count,
__rh_recovery_prepare() returns "1" without adding the region in the
quiesed_regions list. In this case, the semaphore (recovery_count) is
not released. This causes stuck when recovery_count is acquired in
dm_rh_stop_recovery() called from mirror_presuspend().

To prevent the stuck, all bios in the hold list should be processed
after the suspend flag is set but before dm_rh_stop_recovery() is called.

I appreciate your comments.

Thanks,
Taka


Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
---
 drivers/md/dm-raid1.c |   41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

Index: linux-2.6.33-rc1-dm/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.33-rc1-dm.orig/drivers/md/dm-raid1.c
+++ linux-2.6.33-rc1-dm/drivers/md/dm-raid1.c
@@ -465,9 +465,17 @@ static void map_region(struct dm_io_regi
 static void hold_bio(struct mirror_set *ms, struct bio *bio)
 {
 	/*
-	 * If device is suspended, complete the bio.
+	 * Lock is required to avoid race condition during suspend
+	 * process.
 	 */
+	spin_lock_irq(&ms->lock);
+
 	if (atomic_read(&ms->suspend)) {
+		spin_unlock_irq(&ms->lock);
+
+		/*
+		 * If device is suspended, complete the bio.
+		 */
 		if (dm_noflush_suspending(ms->ti))
 			bio_endio(bio, DM_ENDIO_REQUEUE);
 		else
@@ -478,7 +486,6 @@ static void hold_bio(struct mirror_set *
 	/*
 	 * Hold bio until the suspend is complete.
 	 */
-	spin_lock_irq(&ms->lock);
 	bio_list_add(&ms->holds, bio);
 	spin_unlock_irq(&ms->lock);
 }
@@ -1259,6 +1266,20 @@ static void mirror_presuspend(struct dm_
 	atomic_set(&ms->suspend, 1);
 
 	/*
+	 * Process bios in the hold list to start recovery waiting
+	 * for bios in the hold list. After the process, no bio has
+	 * a chance to be added in the hold list because ms->suspend
+	 * is set.
+	 */
+	spin_lock_irq(&ms->lock);
+	holds = ms->holds;
+	bio_list_init(&ms->holds);
+	spin_unlock_irq(&ms->lock);
+
+	while ((bio = bio_list_pop(&holds)))
+		hold_bio(ms, bio);
+
+	/*
 	 * We must finish up all the work that we've
 	 * generated (i.e. recovery work).
 	 */
@@ -1278,22 +1299,6 @@ static void mirror_presuspend(struct dm_
 	 * we know that all of our I/O has been pushed.
 	 */
 	flush_workqueue(ms->kmirrord_wq);
-
-	/*
-	 * Now set ms->suspend is set and the workqueue flushed, no more
-	 * entries can be added to ms->hold list, so process it.
-	 *
-	 * Bios can still arrive concurrently with or after this
-	 * presuspend function, but they cannot join the hold list
-	 * because ms->suspend is set.
-	 */
-	spin_lock_irq(&ms->lock);
-	holds = ms->holds;
-	bio_list_init(&ms->holds);
-	spin_unlock_irq(&ms->lock);
-
-	while ((bio = bio_list_pop(&holds)))
-		hold_bio(ms, bio);
 }
 
 static void mirror_postsuspend(struct dm_target *ti)

-- 
Takahiro Yasui
Hitachi Computer Products (America), Inc.
