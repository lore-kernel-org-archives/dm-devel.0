From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 5 of 9] dm target callbacks and congestion fn
Date: Thu, 18 Nov 2010 17:43:02 -0600
Message-ID: <201011182343.oAINh29s010747@hydrogen.msp.redhat.com>
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

Patch name: dm-target-callbacks-and-congestion-fn.patch


dm currently implements congestion checking by checking on congestion
in each component device.

For raid456 we need to also check if the stripe cache is congested.
So add support to dm for a target to register a congestion checker,
then registered such a checker for dm-raid.

We add support for multiple callbacks as we will need one for unplug
too.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c
+++ linux-2.6/drivers/md/dm-raid.c
@@ -32,6 +32,7 @@ struct raid_set {
 	struct dm_target *ti;
 	struct mddev_s md;
 	struct raid_type *raid_type;
+	struct target_callbacks callbacks;
 	struct raid_dev dev[0];
 };
 
@@ -250,6 +251,13 @@ static void do_table_event(struct work_s
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
@@ -330,8 +338,13 @@ static int raid_ctr(struct dm_target *ti
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
@@ -344,6 +357,7 @@ static void raid_dtr(struct dm_target *t
 {
 	struct raid_set *rs = ti->private;
 
+	list_del_init(&rs->callbacks.list);
 	md_stop(&rs->md);
 	context_free(rs);
 }
Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c
+++ linux-2.6/drivers/md/dm-table.c
@@ -70,6 +70,8 @@ struct dm_table {
 	void (*event_fn)(void *);
 	void *event_context;
 
+	struct list_head target_callbacks;
+
 	struct dm_md_mempools *mempools;
 };
 
@@ -204,6 +206,7 @@ int dm_table_create(struct dm_table **re
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&t->devices);
+	INIT_LIST_HEAD(&t->target_callbacks);
 	atomic_set(&t->holders, 0);
 	t->discards_supported = 1;
 
@@ -1229,10 +1232,18 @@ int dm_table_resume_targets(struct dm_ta
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
@@ -1247,6 +1258,10 @@ int dm_table_any_congested(struct dm_tab
 				     bdevname(dd->dm_dev.bdev, b));
 	}
 
+	list_for_each_entry(cb, &t->target_callbacks, list)
+		if (cb->congested_fn)
+			r |= cb->congested_fn(cb, bdi_bits);
+
 	return r;
 }
 
Index: linux-2.6/include/linux/device-mapper.h
===================================================================
--- linux-2.6.orig/include/linux/device-mapper.h
+++ linux-2.6/include/linux/device-mapper.h
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
 
@@ -269,6 +275,12 @@ int dm_table_add_target(struct dm_table 
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
