From: NeilBrown <neilb@suse.de>
Subject: [PATCH 09/24] raid5: Don't set read-ahead when there is no queue
Date: Tue, 01 Jun 2010 19:56:19 +1000
Message-ID: <20100601095619.565.44865.stgit@notabene.brown>
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

dm-raid456 does not provide a 'queue' for raid5 to use,
so we must make raid5 stop depending on the queue.

First: read_ahead
dm handles read-ahead adjustment fully in userspace, so
simply don't do any readahead adjustments if there is
no queue.

Also re-arrange code slightly so all the accesses to ->queue are
together.

Finally, move the blk_queue_merge_bvec function into the 'if' as
the ->split_io setting in dm-raid456 has the same effect.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid5.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 74e36a2..8839573 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5072,16 +5072,6 @@ static int run(mddev_t *mddev)
 							"reshape");
 	}
 
-	/* read-ahead size must cover two whole stripes, which is
-	 * 2 * (datadisks) * chunksize where 'n' is the number of raid devices
-	 */
-	{
-		int data_disks = conf->previous_raid_disks - conf->max_degraded;
-		int stripe = data_disks *
-			((mddev->chunk_sectors << 9) / PAGE_SIZE);
-		if (mddev->queue->backing_dev_info.ra_pages < 2 * stripe)
-			mddev->queue->backing_dev_info.ra_pages = 2 * stripe;
-	}
 
 	/* Ok, everything is just fine now */
 	if (mddev->to_remove == &raid5_attrs_group)
@@ -5089,8 +5079,23 @@ static int run(mddev_t *mddev)
 	else if (mddev->kobj.sd &&
 	    sysfs_create_group(&mddev->kobj, &raid5_attrs_group))
 		printk(KERN_WARNING
-		       "md/raid:%s: failed to create sysfs attributes.\n",
+		       "raid5: failed to create sysfs attributes for %s\n",
 		       mdname(mddev));
+	md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
+
+	if (mddev->queue) {
+		/* read-ahead size must cover two whole stripes, which
+		 * is 2 * (datadisks) * chunksize where 'n' is the
+		 * number of raid devices
+		 */
+		int data_disks = conf->previous_raid_disks - conf->max_degraded;
+		int stripe = data_disks *
+			((mddev->chunk_sectors << 9) / PAGE_SIZE);
+		if (mddev->queue->backing_dev_info.ra_pages < 2 * stripe)
+			mddev->queue->backing_dev_info.ra_pages = 2 * stripe;
+
+		blk_queue_merge_bvec(mddev->queue, raid5_mergeable_bvec);
+	}
 
 	mddev->queue->queue_lock = &conf->device_lock;
 
@@ -5098,9 +5103,6 @@ static int run(mddev_t *mddev)
 	mddev->queue->backing_dev_info.congested_data = mddev;
 	mddev->queue->backing_dev_info.congested_fn = raid5_congested;
 
-	md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
-
-	blk_queue_merge_bvec(mddev->queue, raid5_mergeable_bvec);
 	chunk_size = mddev->chunk_sectors << 9;
 	blk_queue_io_min(mddev->queue, chunk_size);
 	blk_queue_io_opt(mddev->queue, chunk_size *
@@ -5523,7 +5525,7 @@ static void end_reshape(raid5_conf_t *conf)
 		/* read-ahead size must cover two whole stripes, which is
 		 * 2 * (datadisks) * chunksize where 'n' is the number of raid devices
 		 */
-		{
+		if (conf->mddev->queue) {
 			int data_disks = conf->raid_disks - conf->max_degraded;
 			int stripe = data_disks * ((conf->chunk_sectors << 9)
 						   / PAGE_SIZE);


