From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 6 of 8] dm unplug callback
Date: Tue, 14 Dec 2010 15:17:02 -0600
Message-ID: <201012142117.oBELH2tX015673@hydrogen.msp.redhat.com>
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

Patch name: dm-unplug-callback.patch


In a similar manner to congestion checking, per-target
unplug support for raid456 under dm.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c
+++ linux-2.6/drivers/md/dm-raid.c
@@ -363,6 +363,14 @@ static int raid_is_congested(void *v, in
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
@@ -446,6 +454,7 @@ static int raid_ctr(struct dm_target *ti
 	if (errnum)
 		goto err;
 
+	rs->callbacks.unplug_fn = raid_unplug;
 	rs->callbacks.congested_fn = raid_is_congested;
 	dm_table_add_callbacks(ti->table, &rs->callbacks);
 
Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c
+++ linux-2.6/drivers/md/dm-table.c
@@ -1283,6 +1283,7 @@ void dm_table_unplug_all(struct dm_table
 {
 	struct dm_dev_internal *dd;
 	struct list_head *devices = dm_table_get_devices(t);
+	struct target_callbacks *cb;
 
 	list_for_each_entry(dd, devices, list) {
 		struct request_queue *q = bdev_get_queue(dd->dm_dev.bdev);
@@ -1295,6 +1296,9 @@ void dm_table_unplug_all(struct dm_table
 				     dm_device_name(t->md),
 				     bdevname(dd->dm_dev.bdev, b));
 	}
+	list_for_each_entry(cb, &t->target_callbacks, list)
+		if (cb->unplug_fn)
+			cb->unplug_fn(cb);
 }
 
 struct mapped_device *dm_table_get_md(struct dm_table *t)
Index: linux-2.6/include/linux/device-mapper.h
===================================================================
--- linux-2.6.orig/include/linux/device-mapper.h
+++ linux-2.6/include/linux/device-mapper.h
@@ -197,6 +197,7 @@ struct dm_target {
 struct target_callbacks {
 	struct list_head list;
 	congested_fn *congested_fn;
+	void (*unplug_fn)(void *);
 };
 
 int dm_register_target(struct target_type *t);
