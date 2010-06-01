From: NeilBrown <neilb@suse.de>
Subject: [PATCH 13/24] dm-raid456: support unplug
Date: Tue, 01 Jun 2010 19:56:19 +1000
Message-ID: <20100601095619.565.62028.stgit@notabene.brown>
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

In a similar manner to congestion checking, per-target
unplug support for raid456 under dm.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/dm-raid456.c       |    9 +++++++++
 drivers/md/dm-table.c         |    4 ++++
 drivers/md/raid5.c            |   11 +++++------
 drivers/md/raid5.h            |    1 +
 include/linux/device-mapper.h |    1 +
 5 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-raid456.c b/drivers/md/dm-raid456.c
index 0e3922a..46a5e29 100644
--- a/drivers/md/dm-raid456.c
+++ b/drivers/md/dm-raid456.c
@@ -154,6 +154,14 @@ static int raid_is_congested(void *v, int bits)
 					   callbacks);
 	return md_raid5_congested(&rs->md, bits);
 }
+static void raid_unplug(void *v)
+{
+	struct target_callbacks *cb = v;
+	struct raid_set *rs = container_of(cb, struct raid_set,
+					   callbacks);
+	raid5_unplug_device(rs->md.private);
+}
+
 /*
  * Construct a RAID4/5/6 mapping:
  * Args:
@@ -289,6 +297,7 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 			goto err;
 		clear_bit(In_sync, &rs->dev[rebuildA].rdev.flags);
 		rs->dev[rebuildA].rdev.recovery_offset = 0;
+	rs->callbacks.unplug_fn = raid_unplug;
 	}
 	if (rebuildB >= 0) {
 		if (rs->dev[rebuildB].dev == NULL)
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index b856340..cad4992 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1228,6 +1228,7 @@ void dm_table_unplug_all(struct dm_table *t)
 {
 	struct dm_dev_internal *dd;
 	struct list_head *devices = dm_table_get_devices(t);
+	struct target_callbacks *cb;
 
 	list_for_each_entry(dd, devices, list) {
 		struct request_queue *q = bdev_get_queue(dd->dm_dev.bdev);
@@ -1240,6 +1241,9 @@ void dm_table_unplug_all(struct dm_table *t)
 				     dm_device_name(t->md),
 				     bdevname(dd->dm_dev.bdev, b));
 	}
+	list_for_each_entry(cb, &t->target_callbacks, list)
+		if (cb->unplug_fn)
+			cb->unplug_fn(cb);
 }
 
 struct mapped_device *dm_table_get_md(struct dm_table *t)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 74bc7a6..efcea17 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -365,7 +365,6 @@ static struct stripe_head *__find_stripe(raid5_conf_t *conf, sector_t sector,
 }
 
 static void unplug_slaves(mddev_t *mddev);
-static void raid5_unplug_device(raid5_conf_t *conf);
 
 static struct stripe_head *
 get_active_stripe(raid5_conf_t *conf, sector_t sector,
@@ -3573,7 +3572,7 @@ static void unplug_slaves(mddev_t *mddev)
 	rcu_read_unlock();
 }
 
-static void raid5_unplug_device(raid5_conf_t *conf)
+void raid5_unplug_device(raid5_conf_t *conf)
 {
 	unsigned long flags;
 
@@ -3589,6 +3588,7 @@ static void raid5_unplug_device(raid5_conf_t *conf)
 
 	unplug_slaves(conf->mddev);
 }
+EXPORT_SYMBOL_GPL(raid5_unplug_device);
 
 static void raid5_unplug(struct plug_handle *plug)
 {
@@ -5116,11 +5116,10 @@ static int run(mddev_t *mddev)
 
 		mddev->queue->backing_dev_info.congested_data = mddev;
 		mddev->queue->backing_dev_info.congested_fn = raid5_congested;
-	}
-
-	mddev->queue->queue_lock = &conf->device_lock;
 
-	mddev->queue->unplug_fn = raid5_unplug_queue;
+		mddev->queue->queue_lock = &conf->device_lock;
+		mddev->queue->unplug_fn = raid5_unplug_queue;
+	}
 
 	chunk_size = mddev->chunk_sectors << 9;
 	blk_queue_io_min(mddev->queue, chunk_size);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index edf90a8..fa3938a 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -501,4 +501,5 @@ static inline int algorithm_is_DDF(int layout)
 	return layout >= 8 && layout <= 10;
 }
 extern int md_raid5_congested(mddev_t *mddev, int bits);
+extern void raid5_unplug_device(raid5_conf_t *conf);
 #endif
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 2b0f538..5b8ac19 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -191,6 +191,7 @@ struct dm_target {
 struct target_callbacks {
 	struct list_head list;
 	congested_fn *congested_fn;
+	void (*unplug_fn)(void *);
 };
 
 int dm_register_target(struct target_type *t);


