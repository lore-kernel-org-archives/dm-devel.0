From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 6/8] dm: per-target unplug callback support
Date: Mon, 20 Dec 2010 21:37:43 -0500
Message-ID: <1292899065-31943-7-git-send-email-snitzer@redhat.com>
References: <1292899065-31943-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1292899065-31943-1-git-send-email-snitzer@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: jbrassow@redhat.com, neilb@suse.de
Cc: agk@redhat.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

From: NeilBrown <neilb@suse.de>

Add per-target unplug callback support and establish the raid_unplug()
callback for dm-raid.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-raid.c          |   10 ++++++++++
 drivers/md/dm-table.c         |    4 ++++
 include/linux/device-mapper.h |    1 +
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 962f88f..4db3eab 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -371,6 +371,15 @@ static int raid_is_congested(void *v, int bits)
 					   callbacks);
 	return md_raid5_congested(&rs->md, bits);
 }
+
+static void raid_unplug(void *v)
+{
+	struct target_callbacks *cb = v;
+	struct raid_set *rs = container_of(cb, struct raid_set,
+					   callbacks);
+	md_raid5_unplug_device(rs->md.private);
+}
+
 /*
  * Construct a RAID4/5/6 mapping:
  * Args:
@@ -455,6 +464,7 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto err;
 
 	rs->callbacks.congested_fn = raid_is_congested;
+	rs->callbacks.unplug_fn = raid_unplug;
 	dm_table_add_callbacks(ti->table, &rs->callbacks);
 
 	return 0;
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 88df831..bd4c4ef 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1283,6 +1283,7 @@ void dm_table_unplug_all(struct dm_table *t)
 {
 	struct dm_dev_internal *dd;
 	struct list_head *devices = dm_table_get_devices(t);
+	struct target_callbacks *cb;
 
 	list_for_each_entry(dd, devices, list) {
 		struct request_queue *q = bdev_get_queue(dd->dm_dev.bdev);
@@ -1295,6 +1296,9 @@ void dm_table_unplug_all(struct dm_table *t)
 				     dm_device_name(t->md),
 				     bdevname(dd->dm_dev.bdev, b));
 	}
+	list_for_each_entry(cb, &t->target_callbacks, list)
+		if (cb->unplug_fn)
+			cb->unplug_fn(cb);
 }
 
 struct mapped_device *dm_table_get_md(struct dm_table *t)
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 77e2e78..92511d2f 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -197,6 +197,7 @@ struct dm_target {
 struct target_callbacks {
 	struct list_head list;
 	congested_fn *congested_fn;
+	void (*unplug_fn)(void *);
 };
 
 int dm_register_target(struct target_type *t);
-- 
1.7.2.3

