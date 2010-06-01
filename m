From: NeilBrown <neilb@suse.de>
Subject: [PATCH 12/24] md/plug: optionally use plugger to unplug an array
	during resync/recovery.
Date: Tue, 01 Jun 2010 19:56:19 +1000
Message-ID: <20100601095619.565.35245.stgit@notabene.brown>
References: <20100601094414.565.3638.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100601094414.565.3638.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
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
index e44b9c6..ea6577b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4665,6 +4665,7 @@ static void md_clean(mddev_t *mddev)
 	mddev->bitmap_info.chunksize = 0;
 	mddev->bitmap_info.daemon_sleep = 0;
 	mddev->bitmap_info.max_write_behind = 0;
+	mddev->plug = NULL;
 }
 
 void md_stop_writes(mddev_t *mddev)
@@ -6597,6 +6598,14 @@ int md_allow_write(mddev_t *mddev)
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
@@ -6775,7 +6784,7 @@ void md_do_sync(mddev_t *mddev)
 		     >= mddev->resync_max - mddev->curr_resync_completed
 			    )) {
 			/* time to update curr_resync_completed */
-			blk_unplug(mddev->queue);
+			md_unplug(mddev);
 			wait_event(mddev->recovery_wait,
 				   atomic_read(&mddev->recovery_active) == 0);
 			mddev->curr_resync_completed =
@@ -6853,7 +6862,7 @@ void md_do_sync(mddev_t *mddev)
 		 * about not overloading the IO subsystem. (things like an
 		 * e2fsck being done on the RAID array should execute fast)
 		 */
-		blk_unplug(mddev->queue);
+		md_unplug(mddev);
 		cond_resched();
 
 		currspeed = ((unsigned long)(io_sectors-mddev->resync_mark_cnt))/2
@@ -6872,7 +6881,7 @@ void md_do_sync(mddev_t *mddev)
 	 * this also signals 'finished resyncing' to md_stop
 	 */
  out:
-	blk_unplug(mddev->queue);
+	md_unplug(mddev);
 
 	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index f210482..0bf8c18 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -325,6 +325,8 @@ struct mddev_s
 	struct list_head		all_mddevs;
 
 	struct attribute_group		*to_remove;
+	struct plug_handle		*plug; /* if used by personality */
+
 	/* Generic barrier handling.
 	 * If there is a pending barrier request, all other
 	 * writes are blocked while the devices are flushed.
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6b1802c..74bc7a6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5100,6 +5100,7 @@ static int run(mddev_t *mddev)
 	md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
 
 	plugger_init(&conf->plug, raid5_unplug);
+	mddev->plug = &conf->plug;
 	if (mddev->queue) {
 		/* read-ahead size must cover two whole stripes, which
 		 * is 2 * (datadisks) * chunksize where 'n' is the


