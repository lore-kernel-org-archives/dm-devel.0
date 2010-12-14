From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 7 of 8] dm raid iterate_devices and io_hints
Date: Tue, 14 Dec 2010 15:17:13 -0600
Message-ID: <201012142117.oBELHDR0015746@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Patch name: dm-raid-iterate_devices-and-io_hints.patch

Addition of .iterate_devices and .io_hints function required
by device-mapper target implementations... further fleshing
out the new target.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c
+++ linux-2.6/drivers/md/dm-raid.c
@@ -569,6 +569,37 @@ static int raid_status(struct dm_target 
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
+		if (rs->dev[i].data_dev)
+			ret = fn(ti,
+				 rs->dev[i].data_dev,
+				 0, /* No offset on data devs */
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
 	.name = "raid",
 	.version = {1, 0, 0},
@@ -577,6 +608,8 @@ static struct target_type raid_target = 
 	.dtr = raid_dtr,
 	.map = raid_map,
 	.status = raid_status,
+	.iterate_devices = raid_iterate_devices,
+	.io_hints = raid_io_hints,
 };
 
 static int __init dm_raid_init(void)
