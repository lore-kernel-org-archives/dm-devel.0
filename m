From: Takahiro Yasui <tyasui@redhat.com>
Subject: [PATCH][RESEND] dm-raid1: fix deadlock at suspending
	failed device
Date: Wed, 17 Feb 2010 18:40:36 -0500
Message-ID: <4B7C7E74.2040207@redhat.com>
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
To: Alasdair G Kergon <agk@redhat.com>, mpatocka@redhat.com, jbrassow@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a repost of the following patch but its description is revised.

1/8/2010 3:08 PM
[PATCH][BUGFIX] dm-raid1: fix suspend stuck of failed device

I appreciate your review.

Thanks,
Taka


The recovery can't start because there are pending bios and therefore
dm_rh_stop_recovery deadlocks.

When there are pending bios in the hold list, the recovery waits for
the completion of the bios after recovery_count is acquired.
The recovery_count is released when the recovery finished, however,
the bios in the hold list are processed after dm_rh_stop_recovery() in
mirror_presuspend(). dm_rh_stop_recovery() also acquires recovery_count,
then deadlock occurs.

To prevent deadlock, bios in the hold list should be flushed before
dm_rh_stop_recovery() is called in mirror_suspend().


Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
---
 drivers/md/dm-raid1.c |   41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

Index: linux-2.6.33-rc1/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.33-rc1.orig/drivers/md/dm-raid1.c
+++ linux-2.6.33-rc1/drivers/md/dm-raid1.c
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
