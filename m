From: NeilBrown <neilb@suse.de>
Subject: [PATCH 08/12] md/plug: optionally use plugger to unplug an array
	during resync/recovery.
Date: Thu, 15 Apr 2010 16:43:02 +1000
Message-ID: <20100415064302.15646.73901.stgit@notabene.brown>
References: <20100415062909.15646.16.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415062909.15646.16.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: dm-devel.ids

If an array doesn't have a 'queue' then md_do_sync cannot
unplug it.
In that case it will have a 'plugger', so make that available
to the mddev, and us it to unplug the array if needed.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c    |   15 ++++++++++++---
 drivers/md/md.h    |    2 ++
 drivers/md/raid5.c |    1 +
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 49336e7..b292dc5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4660,6 +4660,7 @@ static void md_clean(mddev_t *mddev)
 	mddev->bitmap_info.chunksize = 0;
 	mddev->bitmap_info.daemon_sleep = 0;
 	mddev->bitmap_info.max_write_behind = 0;
+	mddev->plug = NULL;
 }
 
 static void md_stop_writes(mddev_t *mddev)
@@ -6563,6 +6564,14 @@ int md_allow_write(mddev_t *mddev)
 }
 EXPORT_SYMBOL_GPL(md_allow_write);
 
+static void md_unplug(mddev_t *mddev)
+{
+	if (mddev->queue)
+		blk_unplug(mddev->queue);
+	if (mddev->plug)
+		mddev->plug->unplug_fn(mddev->plug);
+}
+
 #define SYNC_MARKS	10
 #define	SYNC_MARK_STEP	(3*HZ)
 void md_do_sync(mddev_t *mddev)
@@ -6741,7 +6750,7 @@ void md_do_sync(mddev_t *mddev)
 		     >= mddev->resync_max - mddev->curr_resync_completed
 			    )) {
 			/* time to update curr_resync_completed */
-			blk_unplug(mddev->queue);
+			md_unplug(mddev);
 			wait_event(mddev->recovery_wait,
 				   atomic_read(&mddev->recovery_active) == 0);
 			mddev->curr_resync_completed =
@@ -6818,7 +6827,7 @@ void md_do_sync(mddev_t *mddev)
 		 * about not overloading the IO subsystem. (things like an
 		 * e2fsck being done on the RAID array should execute fast)
 		 */
-		blk_unplug(mddev->queue);
+		md_unplug(mddev);
 		cond_resched();
 
 		currspeed = ((unsigned long)(io_sectors-mddev->resync_mark_cnt))/2
@@ -6837,7 +6846,7 @@ void md_do_sync(mddev_t *mddev)
 	 * this also signals 'finished resyncing' to md_stop
 	 */
  out:
-	blk_unplug(mddev->queue);
+	md_unplug(mddev);
 
 	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1c14c33..e4f60ae 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -319,6 +319,8 @@ struct mddev_s
 	struct list_head		all_mddevs;
 
 	struct attribute_group		*to_remove;
+	struct plug_handle		*plug; /* if used by personality */
+
 	/* Generic barrier handling.
 	 * If there is a pending barrier request, all other
 	 * writes are blocked while the devices are flushed.
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ac63012..fae805e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5111,6 +5111,7 @@ static int run(mddev_t *mddev)
 	md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
 
 	plugger_init(&conf->plug, raid5_unplug);
+	mddev->plug = &conf->plug;
 	if (mddev->queue) {
 		/* read-ahead size must cover two whole stripes, which
 		 * is 2 * (datadisks) * chunksize where 'n' is the


