From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7/7] Hold all write bios when errors are handled
Date: Wed, 18 Nov 2009 07:19:27 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911180718540.21358@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0911180703410.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180709570.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180710370.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180711140.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180711510.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180712340.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180713150.21358@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0911180713150.21358@hs20-bc2-1.build.redhat.com>
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

Hold all write bios when errors are handled.

The patch changes these things:
- previously, the failures list was used only when handling errors with
  dmeventd. Now, it is used for all bios. Even when not using dmeventd,
  the regions where some writes failed must be marked as nosync. This can only
  be done in process context (i.e. in raid1 workqueue), not in
  the write_callback function.
- previously, the write would succeed if writing to at least one leg succeeded.
  This is wrong because data from the failed leg may be replicated to the
  correct leg.
  Now, if using dmeventd, the write with some failures will fail be held until
  dmeventd does its job and reconfigures the array.
  If not using dmeventd, the write still succeeds if at least one leg succeeds,
  it is wrong but it is consistent with current behavior.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-raid1.c |   54 ++++++++++++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 25 deletions(-)

Index: linux-2.6.31.6-fast/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.31.6-fast.orig/drivers/md/dm-raid1.c	2009-11-18 10:53:00.000000000 +0100
+++ linux-2.6.31.6-fast/drivers/md/dm-raid1.c	2009-11-18 12:40:35.000000000 +0100
@@ -534,7 +534,6 @@ static void write_callback(unsigned long
 	unsigned i, ret = 0;
 	struct bio *bio = (struct bio *) context;
 	struct mirror_set *ms;
-	int uptodate = 0;
 	unsigned long flags;
 
 	ms = bio_get_m(bio)->ms;
@@ -546,33 +545,23 @@ static void write_callback(unsigned long
 	 * This way we handle both writes to SYNC and NOSYNC
 	 * regions with the same code.
 	 */
-	if (likely(!error))
-		goto out;
+	if (likely(!error)) {
+		bio_endio(bio, ret);
+		return;
+	}
 
 	for (i = 0; i < ms->nr_mirrors; i++)
 		if (test_bit(i, &error))
 			fail_mirror(ms->mirror + i, DM_RAID1_WRITE_ERROR);
-		else
-			uptodate = 1;
 
-	if (unlikely(!uptodate)) {
-		DMERR("All replicated volumes dead, failing I/O");
-		/* None of the writes succeeded, fail the I/O. */
-		ret = -EIO;
-	} else if (errors_handled(ms)) {
-		/*
-		 * Need to raise event.  Since raising
-		 * events can block, we need to do it in
-		 * the main thread.
-		 */
-		spin_lock_irqsave(&ms->lock, flags);
-		bio_list_add(&ms->failures, bio);
-		spin_unlock_irqrestore(&ms->lock, flags);
-		wakeup_mirrord(ms);
-		return;
-	}
-out:
-	bio_endio(bio, ret);
+	/*
+	 * In either case we must mark the region as NOSYNC.
+	 * That would block, so do it in the thread.
+	 */
+	spin_lock_irqsave(&ms->lock, flags);
+	bio_list_add(&ms->failures, bio);
+	spin_unlock_irqrestore(&ms->lock, flags);
+	wakeup_mirrord(ms);
 }
 
 static void do_write(struct mirror_set *ms, struct bio *bio)
@@ -730,10 +719,25 @@ static void do_failures(struct mirror_se
 		if (!ms->log_failure) {
 			ms->in_sync = 0;
 			dm_rh_mark_nosync(ms->rh, bio);
+		}
+		/*
+		 * If all the legs are dead, fail the I/O.
+		 *
+		 * If we are not using dmeventd, we pretend that the I/O
+		 * succeeded. This is wrong (the failed leg might come online
+		 * again after reboot and it would be replicated back to
+		 * the good leg) but it is consistent with current behavior.
+		 * For proper behavior, dm-raid1 shouldn't be used without
+		 * dmeventd at all.
+		 *
+		 * If we use dmeventd, hold the bio until dmeventd does its job.
+		 */
+		if (!get_valid_mirror(ms))
+			bio_endio(bio, -EIO);
+		else if (!errors_handled(ms))
 			bio_endio(bio, 0);
-		} else {
+		else
 			hold_bio(ms, bio);
-		}
 	}
 }
 
