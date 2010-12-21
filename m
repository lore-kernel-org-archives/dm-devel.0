From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 5/8] dm: introduce target callbacks and congestion callback
Date: Mon, 20 Dec 2010 21:37:42 -0500
Message-ID: <1292899065-31943-6-git-send-email-snitzer@redhat.com>
References: <1292899065-31943-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1292899065-31943-1-git-send-email-snitzer@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: jbrassow@redhat.com, neilb@suse.de
Cc: agk@redhat.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

From: NeilBrown <neilb@suse.de>

DM currently implements congestion checking by checking on congestion
in each component device.  For raid456 we need to also check if the
stripe cache is congested.

Add per-target congestion checker callback support and establish the
raid_is_congested() callback for dm-raid.

Extending the target_callbacks structure with additional callback
functions allows for establishing multiple callbacks per-target (a
callback is also needed for unplug).

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-raid.c          |   18 ++++++++++++++++--
 drivers/md/dm-table.c         |   15 +++++++++++++++
 include/linux/device-mapper.h |   12 ++++++++++++
 3 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index edcccd8..962f88f 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -58,6 +58,7 @@ struct raid_set {
 
 	struct mddev_s md;
 	struct raid_type *raid_type;
+	struct target_callbacks callbacks;
 
 	struct raid_dev dev[0];
 };
@@ -363,6 +364,13 @@ static void do_table_event(struct work_struct *ws)
 	dm_table_event(rs->ti->table);
 }
 
+static int raid_is_congested(void *v, int bits)
+{
+	struct target_callbacks *cb = v;
+	struct raid_set *rs = container_of(cb, struct raid_set,
+					   callbacks);
+	return md_raid5_congested(&rs->md, bits);
+}
 /*
  * Construct a RAID4/5/6 mapping:
  * Args:
@@ -443,8 +451,13 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	rs->md.in_sync = 0; /* Assume already marked dirty */
 	mutex_unlock(&rs->md.reconfig_mutex);
 
-	if (!errnum)
-		return 0;
+	if (errnum)
+		goto err;
+
+	rs->callbacks.congested_fn = raid_is_congested;
+	dm_table_add_callbacks(ti->table, &rs->callbacks);
+
+	return 0;
 
 err:
 	if (rs)
@@ -457,6 +470,7 @@ static void raid_dtr(struct dm_target *ti)
 {
 	struct raid_set *rs = ti->private;
 
+	list_del_init(&rs->callbacks.list);
 	md_stop(&rs->md);
 	context_free(rs);
 }
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 90267f8..88df831 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -71,6 +71,8 @@ struct dm_table {
 	void *event_context;
 
 	struct dm_md_mempools *mempools;
+
+	struct list_head target_callbacks;
 };
 
 /*
@@ -204,6 +206,7 @@ int dm_table_create(struct dm_table **result, fmode_t mode,
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&t->devices);
+	INIT_LIST_HEAD(&t->target_callbacks);
 	atomic_set(&t->holders, 0);
 	t->discards_supported = 1;
 
@@ -1229,10 +1232,18 @@ int dm_table_resume_targets(struct dm_table *t)
 	return 0;
 }
 
+void dm_table_add_callbacks(struct dm_table *t,
+			    struct target_callbacks *cb)
+{
+	list_add(&cb->list, &t->target_callbacks);
+}
+EXPORT_SYMBOL_GPL(dm_table_add_callbacks);
+
 int dm_table_any_congested(struct dm_table *t, int bdi_bits)
 {
 	struct dm_dev_internal *dd;
 	struct list_head *devices = dm_table_get_devices(t);
+	struct target_callbacks *cb;
 	int r = 0;
 
 	list_for_each_entry(dd, devices, list) {
@@ -1247,6 +1258,10 @@ int dm_table_any_congested(struct dm_table *t, int bdi_bits)
 				     bdevname(dd->dm_dev.bdev, b));
 	}
 
+	list_for_each_entry(cb, &t->target_callbacks, list)
+		if (cb->congested_fn)
+			r |= cb->congested_fn(cb, bdi_bits);
+
 	return r;
 }
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 2970022..77e2e78 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -193,6 +193,12 @@ struct dm_target {
 	char *error;
 };
 
+/* Each target can link one of these into the table */
+struct target_callbacks {
+	struct list_head list;
+	congested_fn *congested_fn;
+};
+
 int dm_register_target(struct target_type *t);
 void dm_unregister_target(struct target_type *t);
 
@@ -269,6 +275,12 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 			sector_t start, sector_t len, char *params);
 
 /*
+ * Target_ctr should call this if they need to add any
+ * callback
+ */
+void dm_table_add_callbacks(struct dm_table *t,
+			    struct target_callbacks *cb);
+/*
  * Finally call this to make the table ready for use.
  */
 int dm_table_complete(struct dm_table *t);
-- 
1.7.2.3

