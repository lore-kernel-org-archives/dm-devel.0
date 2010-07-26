From: NeilBrown <nfbrown@novell.com>
Subject: [PATCH 2/8] dm-raid456: add congestion checking.
Date: Mon, 26 Jul 2010 13:24:35 +1000
Message-ID: <20100726032435.29687.16275.stgit@localhost.localdomain>
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

dm currently implements congestion checking by checking on congestion
in each component device.

For raid456 we need to also check if the stripe cache is congested.
So add support to dm for a target to register a congestion checker,
then registered such a checker for dm-raid456.

We add support for multiple callbacks as we will need one for unplug
too.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/dm-raid456.c       |   13 +++++++++++++
 drivers/md/dm-table.c         |   15 +++++++++++++++
 include/linux/device-mapper.h |   12 ++++++++++++
 3 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-raid456.c b/drivers/md/dm-raid456.c
index d54f901..0e3922a 100644
--- a/drivers/md/dm-raid456.c
+++ b/drivers/md/dm-raid456.c
@@ -17,6 +17,7 @@ struct raid_set {
 	struct dm_target *ti;
 	struct mddev_s md;
 	struct raid_type *raid_type;
+	struct target_callbacks callbacks;
 	struct raid_dev dev[0];
 };
 
@@ -146,6 +147,13 @@ static void do_table_event(struct work_struct *ws)
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
@@ -309,6 +317,10 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	if (errnum)
 		goto err;
+
+	rs->callbacks.congested_fn = raid_is_congested;
+	dm_table_add_callbacks(ti->table, &rs->callbacks);
+
 	return 0;
 err:
 	if (rs)
@@ -321,6 +333,7 @@ static void raid_dtr(struct dm_target *ti)
 {
 	struct raid_set *rs = ti->private;
 
+	list_del_init(&rs->callbacks.list);
 	md_stop(&rs->md);
 	context_free(rs);
 }
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 9924ea2..b856340 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -68,6 +68,8 @@ struct dm_table {
 	void (*event_fn)(void *);
 	void *event_context;
 
+	struct list_head target_callbacks;
+
 	struct dm_md_mempools *mempools;
 };
 
@@ -202,6 +204,7 @@ int dm_table_create(struct dm_table **result, fmode_t mode,
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&t->devices);
+	INIT_LIST_HEAD(&t->target_callbacks);
 	atomic_set(&t->holders, 0);
 
 	if (!num_targets)
@@ -1174,10 +1177,18 @@ int dm_table_resume_targets(struct dm_table *t)
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
@@ -1192,6 +1203,10 @@ int dm_table_any_congested(struct dm_table *t, int bdi_bits)
 				     bdevname(dd->dm_dev.bdev, b));
 	}
 
+	list_for_each_entry(cb, &t->target_callbacks, list)
+		if (cb->congested_fn)
+			r |= cb->congested_fn(cb, bdi_bits);
+
 	return r;
 }
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 1381cd9..2b0f538 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -187,6 +187,12 @@ struct dm_target {
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
 
@@ -263,6 +269,12 @@ int dm_table_add_target(struct dm_table *t, const char *type,
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


