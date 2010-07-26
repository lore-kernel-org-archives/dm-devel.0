From: NeilBrown <nfbrown@novell.com>
Subject: [PATCH 3/8] dm-raid456: support unplug
Date: Mon, 26 Jul 2010 13:24:35 +1000
Message-ID: <20100726032435.29687.63743.stgit@localhost.localdomain>
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

In a similar manner to congestion checking, per-target
unplug support for raid456 under dm.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/dm-raid456.c       |    9 +++++++++
 drivers/md/dm-table.c         |    4 ++++
 include/linux/device-mapper.h |    1 +
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-raid456.c b/drivers/md/dm-raid456.c
index 0e3922a..47db9d4 100644
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
+	md_raid5_unplug_device(rs->md.private);
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


