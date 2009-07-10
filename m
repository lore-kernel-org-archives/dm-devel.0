From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [RFC][PATCH] dm-mirror: fix data corruption
Date: Fri, 10 Jul 2009 09:49:49 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0907100947320.2450@hs20-bc2-1.build.redhat.com>
References: <4A568333.6090901@redhat.com>
	<Pine.LNX.4.64.0907100939060.568@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0907100939060.568@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Takahiro Yasui <tyasui@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Fri, 10 Jul 2009, Mikulas Patocka wrote:

> Hi
> 
> For me this approach looks very complex, I would be much more simple to 
> hold back bios until dmeventd processes the failed mirror.
> 
> This approach has redundant data structures (log and superblock) that 
> could really be joined to one structure. You need an extra code to 
> allocate the superblocks.
> 
> Note that you also need to handle errors superblocks without loss of 
> functionality (raid1 is supposed to survive failing disks) ... and it just 
> increases testing time and increases possibility for other bugs.
> 
> 
> If someone wants to make new dm-raid1 design that wouldn't be dependent on 
> dmeventd, I'm not against it, but make it from scratch without patching 
> over existing code (for example, store superblocks and bitmap at the end 
> of the legs like raid-145 does).
> 
> Mikulas

patch to hold back bios --- untested (and not quite optimal because it 
scans the "failures" list in fixed intervals), but it shows the approach.

---
 drivers/md/dm-raid1.c          |   10 +++++++---
 drivers/md/dm-region-hash.c    |    6 +-----
 include/linux/dm-region-hash.h |    3 +--
 3 files changed, 9 insertions(+), 10 deletions(-)

Index: linux-2.6.31-rc2-devel/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.31-rc2-devel.orig/drivers/md/dm-raid1.c	2009-07-10 14:48:19.000000000 +0200
+++ linux-2.6.31-rc2-devel/drivers/md/dm-raid1.c	2009-07-10 15:46:11.000000000 +0200
@@ -535,11 +535,11 @@ static void write_callback(unsigned long
 		else
 			uptodate = 1;
 
-	if (unlikely(!uptodate)) {
+	if (unlikely(!uptodate) || !errors_handled(ms)) {
 		DMERR("All replicated volumes dead, failing I/O");
 		/* None of the writes succeeded, fail the I/O. */
 		ret = -EIO;
-	} else if (errors_handled(ms)) {
+	} else {
 		/*
 		 * Need to raise event.  Since raising
 		 * events can block, we need to do it in
@@ -687,8 +687,12 @@ static void do_failures(struct mirror_se
 	if (!ms->log_failure) {
 		while ((bio = bio_list_pop(failures))) {
 			ms->in_sync = 0;
-			dm_rh_mark_nosync(ms->rh, bio, bio->bi_size, 0);
+			dm_rh_mark_nosync(ms->rh, bio);
+			spin_lock_irq(&ms->lock);
+			bio_list_add(&ms->failures, bio);
+			spin_unlock_irq(&ms->lock);
 		}
+		delayed_wake(ms);
 		return;
 	}
 
Index: linux-2.6.31-rc2-devel/drivers/md/dm-region-hash.c
===================================================================
--- linux-2.6.31-rc2-devel.orig/drivers/md/dm-region-hash.c	2009-07-10 14:54:07.000000000 +0200
+++ linux-2.6.31-rc2-devel/drivers/md/dm-region-hash.c	2009-07-10 15:45:07.000000000 +0200
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
Index: linux-2.6.31-rc2-devel/include/linux/dm-region-hash.h
===================================================================
--- linux-2.6.31-rc2-devel.orig/include/linux/dm-region-hash.h	2009-07-10 15:45:26.000000000 +0200
+++ linux-2.6.31-rc2-devel/include/linux/dm-region-hash.h	2009-07-10 15:45:36.000000000 +0200
@@ -78,8 +78,7 @@ void dm_rh_dec(struct dm_region_hash *rh
 /* Delay bios on regions. */
 void dm_rh_delay(struct dm_region_hash *rh, struct bio *bio);
 
-void dm_rh_mark_nosync(struct dm_region_hash *rh,
-		       struct bio *bio, unsigned done, int error);
+void dm_rh_mark_nosync(struct dm_region_hash *rh, struct bio *bio);
 
 /*
  * Region recovery control.
