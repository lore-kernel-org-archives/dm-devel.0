From: NeilBrown <neilb@suse.de>
Subject: [PATCH 14/24] dm-raid456: add support for setting IO hints.
Date: Tue, 01 Jun 2010 19:56:19 +1000
Message-ID: <20100601095619.565.76605.stgit@notabene.brown>
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

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/dm-raid456.c |   33 +++++++++++++++++++++++++++++++++
 drivers/md/raid5.c      |   19 ++++++++++---------
 2 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-raid456.c b/drivers/md/dm-raid456.c
index 46a5e29..0b72fa4 100644
--- a/drivers/md/dm-raid456.c
+++ b/drivers/md/dm-raid456.c
@@ -435,6 +435,37 @@ static int raid_status(struct dm_target *ti, status_type_t type,
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
+	for (i = 0; !ret && i < rs->md.raid_disks; i++)
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
@@ -443,6 +474,8 @@ static struct target_type raid_target = {
 	.dtr = raid_dtr,
 	.map = raid_map,
 	.status = raid_status,
+	.iterate_devices = raid_iterate_devices,
+	.io_hints = raid_io_hints,
 };
 
 static int __init dm_raid_init(void)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index efcea17..be5cab8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4904,7 +4904,7 @@ static int only_parity(int raid_disk, int algo, int raid_disks, int max_degraded
 static int run(mddev_t *mddev)
 {
 	raid5_conf_t *conf;
-	int working_disks = 0, chunk_size;
+	int working_disks = 0;
 	int dirty_parity_disks = 0;
 	mdk_rdev_t *rdev;
 	sector_t reshape_offset = 0;
@@ -5102,6 +5102,7 @@ static int run(mddev_t *mddev)
 	plugger_init(&conf->plug, raid5_unplug);
 	mddev->plug = &conf->plug;
 	if (mddev->queue) {
+		int chunk_size;
 		/* read-ahead size must cover two whole stripes, which
 		 * is 2 * (datadisks) * chunksize where 'n' is the
 		 * number of raid devices
@@ -5119,16 +5120,16 @@ static int run(mddev_t *mddev)
 
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


