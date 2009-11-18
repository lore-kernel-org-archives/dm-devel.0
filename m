From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/7] Use the hold framework in do_failures
Date: Wed, 18 Nov 2009 07:11:39 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911180711140.21358@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0911180703410.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180709570.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180710370.21358@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0911180710370.21358@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Use the hold framework in do_failures.

This patch doesn't change any logic in processing bios, it just
simplifies failure handling and avoids periodically polling the failures
list.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-raid1.c |   34 +++++++++-------------------------
 1 file changed, 9 insertions(+), 25 deletions(-)

Index: linux-2.6.31-fast-new/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.31-fast-new.orig/drivers/md/dm-raid1.c	2009-10-06 18:15:14.000000000 +0200
+++ linux-2.6.31-fast-new/drivers/md/dm-raid1.c	2009-10-06 18:15:17.000000000 +0200
@@ -703,20 +703,12 @@ static void do_failures(struct mirror_se
 {
 	struct bio *bio;
 
-	if (!failures->head)
+	if (likely(!failures->head))
 		return;
 
-	if (!ms->log_failure) {
-		while ((bio = bio_list_pop(failures))) {
-			ms->in_sync = 0;
-			dm_rh_mark_nosync(ms->rh, bio, bio->bi_size, 0);
-		}
-		return;
-	}
-
 	/*
 	 * If the log has failed, unattempted writes are being
-	 * put on the failures list.  We can't issue those writes
+	 * put on the hold list.  We can't issue those writes
 	 * until a log has been marked, so we must store them.
 	 *
 	 * If a 'noflush' suspend is in progress, we can requeue
@@ -731,23 +723,15 @@ static void do_failures(struct mirror_se
 	 * for us to treat them the same and requeue them
 	 * as well.
 	 */
-	if (dm_noflush_suspending(ms->ti)) {
-		while ((bio = bio_list_pop(failures)))
-			bio_endio(bio, DM_ENDIO_REQUEUE);
-		return;
-	}
 
-	if (atomic_read(&ms->suspend)) {
-		while ((bio = bio_list_pop(failures)))
-			bio_endio(bio, -EIO);
-		return;
+	while ((bio = bio_list_pop(failures))) {
+		if (!ms->log_failure) {
+			ms->in_sync = 0;
+			dm_rh_mark_nosync(ms->rh, bio, bio->bi_size, 0);
+		} else {
+			hold_bio(ms, bio);
+		}
 	}
-
-	spin_lock_irq(&ms->lock);
-	bio_list_merge(&ms->failures, failures);
-	spin_unlock_irq(&ms->lock);
-
-	delayed_wake(ms);
 }
 
 static void trigger_event(struct work_struct *work)
