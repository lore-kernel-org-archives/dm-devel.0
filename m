From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 7/8] dm raid: add iterate_devices and io_hints functions
Date: Mon, 20 Dec 2010 21:37:44 -0500
Message-ID: <1292899065-31943-8-git-send-email-snitzer@redhat.com>
References: <1292899065-31943-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1292899065-31943-1-git-send-email-snitzer@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: jbrassow@redhat.com, neilb@suse.de
Cc: agk@redhat.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

From: NeilBrown <neilb@suse.de>

Add .iterate_devices function which should be implemented for all DM
targets.

Add an .io_hints function too because the provided topology information
is particularly important for a raid device.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-raid.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 4db3eab..6494833 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -577,6 +577,37 @@ static int raid_status(struct dm_target *ti, status_type_t type,
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
@@ -585,6 +616,8 @@ static struct target_type raid_target = {
 	.dtr = raid_dtr,
 	.map = raid_map,
 	.status = raid_status,
+	.iterate_devices = raid_iterate_devices,
+	.io_hints = raid_io_hints,
 };
 
 static int __init dm_raid_init(void)
-- 
1.7.2.3

