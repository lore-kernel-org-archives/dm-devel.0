From: NeilBrown <nfbrown@novell.com>
Subject: [PATCH 4/8] dm-raid456: add support for setting IO hints.
Date: Mon, 26 Jul 2010 13:24:35 +1000
Message-ID: <20100726032435.29687.50704.stgit@localhost.localdomain>
References: <20100726032230.29687.5366.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100726032230.29687.5366.stgit@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/dm-raid456.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-raid456.c b/drivers/md/dm-raid456.c
index 47db9d4..4ffd654 100644
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


