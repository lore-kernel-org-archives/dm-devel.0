From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 4 of 4] MD RAID10: Export md_raid10_congested
Date: Tue, 26 Jun 2012 03:54:27 -0500
Message-ID: <1340700867.19015.24.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, dm-devel@redhat.com
Cc: jbrassow@redhat.com, agk@redhat.com, neilb@suse.de
List-Id: dm-devel.ids

md/raid10: Export is_congested test.

In similar fashion to commits
	11d8a6e3719519fbc0e2c9d61b6fa931b84bf813
	1ed7242e591af7e233234d483f12d33818b189d9
we export the RAID10 congestion checking function so that dm-raid.c can
make use of it and make use of the personality.  The 'queue' and 'gendisk'
structures will not be available to the MD code when device-mapper sets
up the device, so we conditionalize access to these fields also.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/raid10.c
===================================================================
--- linux-upstream.orig/drivers/md/raid10.c
+++ linux-upstream/drivers/md/raid10.c
@@ -853,9 +853,8 @@ retry:
 	return rdev;
 }
 
-static int raid10_congested(void *data, int bits)
+int md_raid10_congested(struct mddev *mddev, int bits)
 {
-	struct mddev *mddev = data;
 	struct r10conf *conf = mddev->private;
 	int i, ret = 0;
 
@@ -863,8 +862,6 @@ static int raid10_congested(void *data,
 	    conf->pending_count >= max_queued_requests)
 		return 1;
 
-	if (mddev_congested(mddev, bits))
-		return 1;
 	rcu_read_lock();
 	for (i = 0;
 	     (i < conf->geo.raid_disks || i < conf->prev.raid_disks)
@@ -880,6 +877,15 @@ static int raid10_congested(void *data,
 	rcu_read_unlock();
 	return ret;
 }
+EXPORT_SYMBOL_GPL(md_raid10_congested);
+
+static int raid10_congested(void *data, int bits)
+{
+	struct mddev *mddev = data;
+
+	return mddev_congested(mddev, bits) ||
+		md_raid10_congested(mddev, bits);
+}
 
 static void flush_pending_writes(struct r10conf *conf)
 {
@@ -3480,12 +3486,14 @@ static int run(struct mddev *mddev)
 	conf->thread = NULL;
 
 	chunk_size = mddev->chunk_sectors << 9;
-	blk_queue_io_min(mddev->queue, chunk_size);
-	if (conf->geo.raid_disks % conf->geo.near_copies)
-		blk_queue_io_opt(mddev->queue, chunk_size * conf->geo.raid_disks);
-	else
-		blk_queue_io_opt(mddev->queue, chunk_size *
-				 (conf->geo.raid_disks / conf->geo.near_copies));
+	if (mddev->queue) {
+		blk_queue_io_min(mddev->queue, chunk_size);
+		if (conf->geo.raid_disks % conf->geo.near_copies)
+			blk_queue_io_opt(mddev->queue, chunk_size * conf->geo.raid_disks);
+		else
+			blk_queue_io_opt(mddev->queue, chunk_size *
+					 (conf->geo.raid_disks / conf->geo.near_copies));
+	}
 
 	rdev_for_each(rdev, mddev) {
 		long long diff;
@@ -3519,8 +3527,9 @@ static int run(struct mddev *mddev)
 		if (first || diff < min_offset_diff)
 			min_offset_diff = diff;
 
-		disk_stack_limits(mddev->gendisk, rdev->bdev,
-				  rdev->data_offset << 9);
+		if (mddev->gendisk)
+			disk_stack_limits(mddev->gendisk, rdev->bdev,
+					  rdev->data_offset << 9);
 
 		disk->head_position = 0;
 	}
@@ -3583,22 +3592,22 @@ static int run(struct mddev *mddev)
 	md_set_array_sectors(mddev, size);
 	mddev->resync_max_sectors = size;
 
-	mddev->queue->backing_dev_info.congested_fn = raid10_congested;
-	mddev->queue->backing_dev_info.congested_data = mddev;
-
-	/* Calculate max read-ahead size.
-	 * We need to readahead at least twice a whole stripe....
-	 * maybe...
-	 */
-	{
+	if (mddev->queue) {
 		int stripe = conf->geo.raid_disks *
 			((mddev->chunk_sectors << 9) / PAGE_SIZE);
+		mddev->queue->backing_dev_info.congested_fn = raid10_congested;
+		mddev->queue->backing_dev_info.congested_data = mddev;
+
+		/* Calculate max read-ahead size.
+		 * We need to readahead at least twice a whole stripe....
+		 * maybe...
+		 */
 		stripe /= conf->geo.near_copies;
 		if (mddev->queue->backing_dev_info.ra_pages < 2 * stripe)
 			mddev->queue->backing_dev_info.ra_pages = 2 * stripe;
+		blk_queue_merge_bvec(mddev->queue, raid10_mergeable_bvec);
 	}
 
-	blk_queue_merge_bvec(mddev->queue, raid10_mergeable_bvec);
 
 	if (md_integrity_register(mddev))
 		goto out_free_conf;
@@ -3649,7 +3658,10 @@ static int stop(struct mddev *mddev)
 	lower_barrier(conf);
 
 	md_unregister_thread(&mddev->thread);
-	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
+	if (mddev->queue)
+		/* the unplug fn references 'conf'*/
+		blk_sync_queue(mddev->queue);
+
 	if (conf->r10bio_pool)
 		mempool_destroy(conf->r10bio_pool);
 	kfree(conf->mirrors);
Index: linux-upstream/drivers/md/raid10.h
===================================================================
--- linux-upstream.orig/drivers/md/raid10.h
+++ linux-upstream/drivers/md/raid10.h
@@ -145,4 +145,7 @@ enum r10bio_state {
  */
 	R10BIO_Previous,
 };
+
+extern int md_raid10_congested(struct mddev *mddev, int bits);
+
 #endif


