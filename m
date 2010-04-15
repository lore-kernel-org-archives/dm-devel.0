From: NeilBrown <neilb@suse.de>
Subject: [PATCH 10/12] dm-raid456: add support for setting IO hints.
Date: Thu, 15 Apr 2010 16:43:02 +1000
Message-ID: <20100415064302.15646.3504.stgit@notabene.brown>
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

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/dm-raid456.c |   33 +++++++++++++++++++++++++++++++++
 drivers/md/raid5.c      |   19 ++++++++++---------
 2 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-raid456.c b/drivers/md/dm-raid456.c
index d0e44f2..071a8ae 100644
--- a/drivers/md/dm-raid456.c
+++ b/drivers/md/dm-raid456.c
@@ -434,6 +434,37 @@ static int raid_status(struct dm_target *ti, status_type_t type,
 	return 0;
 }
 
+static int raid_iterate_devices(struct dm_target *ti,
+				iterate_devices_callout_fn fn,
+				void *data)
+{
+	struct raid_set *rs = ti->private;
+	int ret = 0;
+	unsigned i = 0;
+
+	for (i=0; !ret && i < rs->md.raid_disks; i++)
+		if (rs->dev[i].dev)
+			ret = fn(ti,
+				 rs->dev[i].dev,
+				 rs->dev[i].rdev.data_offset,
+				 rs->md.dev_sectors,
+				 data);
+
+	return ret;
+}
+
+static void raid_io_hints(struct dm_target *ti,
+			  struct queue_limits *limits)
+{
+	struct raid_set *rs = ti->private;
+	unsigned chunk_size = rs->md.chunk_sectors << 9;
+	raid5_conf_t *conf = rs->md.private;
+
+	blk_limits_io_min(limits, chunk_size);
+	blk_limits_io_opt(limits, chunk_size *
+			  (conf->raid_disks - conf->max_degraded));
+}			  
+
 static struct target_type raid_target = {
 	.name = "raid45",
 	.version = {1, 0, 0},
@@ -442,6 +473,8 @@ static struct target_type raid_target = {
 	.dtr = raid_dtr,
 	.map = raid_map,
 	.status = raid_status,
+	.iterate_devices = raid_iterate_devices,
+	.io_hints = raid_io_hints,
 };
 
 static int __init dm_raid_init(void)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 41a905b..138f65f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4906,7 +4906,7 @@ static int only_parity(int raid_disk, int algo, int raid_disks, int max_degraded
 static int run(mddev_t *mddev)
 {
 	raid5_conf_t *conf;
-	int working_disks = 0, chunk_size;
+	int working_disks = 0;
 	int dirty_parity_disks = 0;
 	mdk_rdev_t *rdev;
 	sector_t reshape_offset = 0;
@@ -5113,6 +5113,7 @@ static int run(mddev_t *mddev)
 	plugger_init(&conf->plug, raid5_unplug);
 	mddev->plug = &conf->plug;
 	if (mddev->queue) {
+		int chunk_size;
 		/* read-ahead size must cover two whole stripes, which
 		 * is 2 * (datadisks) * chunksize where 'n' is the
 		 * number of raid devices
@@ -5130,16 +5131,16 @@ static int run(mddev_t *mddev)
 
 		mddev->queue->queue_lock = &conf->device_lock;
 		mddev->queue->unplug_fn = raid5_unplug_queue;
-	}
 
-	chunk_size = mddev->chunk_sectors << 9;
-	blk_queue_io_min(mddev->queue, chunk_size);
-	blk_queue_io_opt(mddev->queue, chunk_size *
-			 (conf->raid_disks - conf->max_degraded));
+		chunk_size = mddev->chunk_sectors << 9;
+		blk_queue_io_min(mddev->queue, chunk_size);
+		blk_queue_io_opt(mddev->queue, chunk_size *
+				 (conf->raid_disks - conf->max_degraded));
 
-	list_for_each_entry(rdev, &mddev->disks, same_set)
-		disk_stack_limits(mddev->gendisk, rdev->bdev,
-				  rdev->data_offset << 9);
+		list_for_each_entry(rdev, &mddev->disks, same_set)
+			disk_stack_limits(mddev->gendisk, rdev->bdev,
+					  rdev->data_offset << 9);
+	}
 
 	return 0;
 abort:


