From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6/7] Move bio completion from dm_rh_mark_nosync
	to its caller
Date: Wed, 18 Nov 2009 07:18:50 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911180713150.21358@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0911180703410.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180709570.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180710370.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180711140.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180711510.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180712340.21358@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0911180712340.21358@hs20-bc2-1.build.redhat.com>
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

Move bio completion from dm_rh_mark_nosync to its caller.

It is more understandable this way.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-raid1.c          |    3 ++-
 drivers/md/dm-region-hash.c    |    6 +-----
 include/linux/dm-region-hash.h |    3 +--
 3 files changed, 4 insertions(+), 8 deletions(-)

Index: linux-2.6.31.6-fast/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.31.6-fast.orig/drivers/md/dm-raid1.c	2009-11-18 10:51:37.000000000 +0100
+++ linux-2.6.31.6-fast/drivers/md/dm-raid1.c	2009-11-18 10:53:00.000000000 +0100
@@ -729,7 +729,8 @@ static void do_failures(struct mirror_se
 	while ((bio = bio_list_pop(failures))) {
 		if (!ms->log_failure) {
 			ms->in_sync = 0;
-			dm_rh_mark_nosync(ms->rh, bio, bio->bi_size, 0);
+			dm_rh_mark_nosync(ms->rh, bio);
+			bio_endio(bio, 0);
 		} else {
 			hold_bio(ms, bio);
 		}
Index: linux-2.6.31.6-fast/drivers/md/dm-region-hash.c
===================================================================
--- linux-2.6.31.6-fast.orig/drivers/md/dm-region-hash.c	2009-11-18 10:53:10.000000000 +0100
+++ linux-2.6.31.6-fast/drivers/md/dm-region-hash.c	2009-11-18 10:59:17.000000000 +0100
@@ -392,8 +392,6 @@ static void complete_resync_work(struct 
 /* dm_rh_mark_nosync
  * @ms
  * @bio
- * @done
- * @error
  *
  * The bio was written on some mirror(s) but failed on other mirror(s).
  * We can successfully endio the bio but should avoid the region being
@@ -401,8 +399,7 @@ static void complete_resync_work(struct 
  *
  * This function is _not_ safe in interrupt context!
  */
-void dm_rh_mark_nosync(struct dm_region_hash *rh,
-		       struct bio *bio, unsigned done, int error)
+void dm_rh_mark_nosync(struct dm_region_hash *rh, struct bio *bio)
 {
 	unsigned long flags;
 	struct dm_dirty_log *log = rh->log;
@@ -439,7 +436,6 @@ void dm_rh_mark_nosync(struct dm_region_
 	BUG_ON(!list_empty(&reg->list));
 	spin_unlock_irqrestore(&rh->region_lock, flags);
 
-	bio_endio(bio, error);
 	if (recovering)
 		complete_resync_work(reg, 0);
 }
Index: linux-2.6.31.6-fast/include/linux/dm-region-hash.h
===================================================================
--- linux-2.6.31.6-fast.orig/include/linux/dm-region-hash.h	2009-11-18 10:53:39.000000000 +0100
+++ linux-2.6.31.6-fast/include/linux/dm-region-hash.h	2009-11-18 10:53:45.000000000 +0100
@@ -78,8 +78,7 @@ void dm_rh_dec(struct dm_region_hash *rh
 /* Delay bios on regions. */
 void dm_rh_delay(struct dm_region_hash *rh, struct bio *bio);
 
-void dm_rh_mark_nosync(struct dm_region_hash *rh,
-		       struct bio *bio, unsigned done, int error);
+void dm_rh_mark_nosync(struct dm_region_hash *rh, struct bio *bio);
 
 /*
  * Region recovery control.
